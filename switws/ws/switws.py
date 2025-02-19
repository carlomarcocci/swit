from flask import Flask, request, jsonify, render_template, url_for, redirect
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
from forms import LoadConfig, IsoConverter, ContentLoader, DecodeMarkdown
from databaseHandler import DatabaseConnector
from werkzeug.wrappers import Response, ResponseStream
from treeqlConverter import TreeQLToSQLConverter
from extensions import cache, ws_config
import json
import redis
import time
import os

app = Flask(__name__)
cache.init_app(app)                                                                # Init the cache

app_dir = os.path.dirname(os.path.abspath(__file__))                               # Application directory
app.json.sort_keys = True                                                          # Disable key reordering in jsonify response

# Custom middleware for rate limiting
class RateLimitMiddleware():
    def __init__(self, app, limit, per):
        self.app = app
        self.limit = limit
        self.per = per
        self.rate_limiter = {}

    def __call__(self, environ, start_response):
        remote_address = environ.get('REMOTE_ADDR')
        path = environ.get('PATH_INFO')

        if remote_address not in self.rate_limiter:
            self.rate_limiter[remote_address] = {'count': 1, 'last_time': time.time()}
        else:
            current_time = time.time()
            time_diff = current_time - self.rate_limiter[remote_address]['last_time']
            
            if time_diff < self.per:
                if self.rate_limiter[remote_address]['count'] >= self.limit:
                    res = Response(json.dumps({'error': 'Too Many Requests'}), mimetype= 'application/json', status=429)
                    return res(environ, start_response) 
                else:
                    self.rate_limiter[remote_address]['count'] += 1
            else:
                self.rate_limiter[remote_address] = {'count': 1, 'last_time': current_time}

        return self.app(environ, start_response)

# Apply the rate limiting middleware
app.wsgi_app = RateLimitMiddleware(app.wsgi_app, limit=int(ws_config['requests_per_minute']), per=60)

# Catch the desired datetime format to elaborate the response
datetime_format = ws_config['datetime_format']

@app.route('/')
def about():
    content = ContentLoader.md_loader('README', app_dir)
    html = DecodeMarkdown.to_html(content)
    return render_template('about.html', title='About', html = html)

@app.route('/swit/', methods=['GET'])
@cache.cached()
def get_databases():

    directory = '/etc/switws/config/conf.d/'

    # Obtain the name of the configuration files contained in the default directory
    yaml_files = [f for f in os.listdir(directory) if f.endswith('.yml')]

    databases = []

    # Check if each file is valid
    for file_name in yaml_files:
        full_path = os.path.join(directory, file_name)

        # Try loading the class using LoadConfig
        db_config = LoadConfig.load_db_config(os.path.splitext(file_name)[0])

        if db_config:
            # If the YAML contains each required field, append to the list
            sanitized_config = {key: value for key, value in db_config.items() if key not in ['host', 'port', 'database', 'user', 'password']}
            file_name_without_extension = os.path.splitext(file_name)[0]
            databases.append({file_name_without_extension: sanitized_config})

    return jsonify({'swit': databases})

@app.route('/swit/<string:config_file>/', methods=['GET'])
@cache.cached(query_string=True)
def get_tables(config_file):

    db_config = LoadConfig.load_db_config(config_file)

    if not db_config:
        response = jsonify({'error': 'No configuration provided for the selected database'})
        return response, 404

    db_connector = DatabaseConnector(db_config)                                     # Connect to the database

    try:
        db_connector.connect()
    except ValueError as e:
        response = jsonify({'error': str(e)})
        return response, 403

    try:
        # Extract the list of tables and views
        tables = db_connector.get_tables_and_views()

        return jsonify({config_file: tables})

    except Exception as e:
        response = jsonify({'error': str(e)})
        return response, 422
    finally:
        db_connector.close_connection()

@app.route('/swit/<string:config_file>/<path:table>/', methods=['GET'])
@cache.cached(query_string=True)
def get_table_struct(config_file, table):

    db_config = LoadConfig.load_db_config(config_file)

    if not db_config:
        response = jsonify({'error': 'No configuration provided for the selected database'})
        return response, 404

    db_connector = DatabaseConnector(db_config)                                     # Connect to the database

    try:
        db_connector.connect()
    except ValueError as e:
        response = jsonify({'error': str(e)})
        return response, 403

    try:
        # Extract the structure of the table
        table_struct = db_connector.get_table_struct(table)

        return jsonify({table: table_struct})

    except Exception as e:
        response = jsonify({'error': str(e)})
        return response, 422
    finally:
        db_connector.close_connection()

@app.route('/swit/<string:config_file>/records/<path:table>', methods=['GET'])
@cache.cached(query_string=True, unless=lambda: len(request.data) > 10 * 1024)
def get_records(config_file, table):

    filters = {}

    request_include = request.args.get('include')									# Get list the list of columns to perform the query
    request_size = request.args.get('size')											# Get any LIMIT TO clause
    request_order = request.args.getlist('order')									# Get multiple order by clauses
    request_filter = request.args.getlist('filter')									# Get the list of main where conditions to be put in AND condition
    request_argument = request.args.getlist('argument')                             # Get the list of the arguments for functions calling

    if request_filter:
        filters[''] = request_filter

    for i in range(0, 11):
        tagged_filter = request.args.getlist(f'filter{i}')

        if tagged_filter:
            tag = f'{i}'
            if tag not in filters:
                filters[tag] = tagged_filter					  					# Get the lists for each branch to be put in OR conditions

    # Start collecting the information to parse the route and execute the query
    db_config = LoadConfig.load_db_config(config_file)								# Get configuration file from URL

    if not db_config:																# Raise error if the database config file is not provided
        response = jsonify({'error': 'No configuration provided for the selected database'})
        return response, 404

    db_connector = DatabaseConnector(db_config)                                     # Connect to the database

    try:
        db_connector.connect()
    except ValueError as e:
        response = jsonify({'error': str(e)})
        return response, 403

    try:
        # Extract the list of tables and views
        tables_and_views = db_connector.get_tables_and_views()

        # Check if the table exists
        table_info = next((item for item in tables_and_views if table in item), None)

        if not table_info:
            response = jsonify({'error': 'Table, view, or function not found'})
            return response, 422

        table_type = table_info[table]

        if table_type == 'FUNCTION' and not request_argument:
            response = jsonify({'error': 'Function arguments required'})
            return response, 422

        if table_type in ['BASE TABLE', 'VIEW'] and request_argument:
            response = jsonify({'error': 'Arguments not allowed for tables or views'})
            return response, 422

        # Set config variables to pass to init the converter class
        schema = db_config.get('schema')
        clauses_not_allowed = db_config.get('clauses_not_allowed')
        default_size = db_config.get('default_size')
        validate_between_clause = db_config.get('validate_between_clause')

        if default_size:                                                            # If default_size assign the value to the request method
            if request_size and request_size.isdigit():                             # Check if the the size exceeds the limit
                if int(request_size) > default_size:
                    request_size = str(default_size)
            else:                                                                   # Assign the default value if it is not given or is not a number
                request_size = str(default_size)

        converter = TreeQLToSQLConverter(schema, clauses_not_allowed, validate_between_clause)

        # Convert TreeQl statement to SQL 
        sql_query = converter.convert_query_from_request(table, filters, request_include, request_size, 
                                                          request_order, request_argument)

        # Execute the query
        results = db_connector.execute_query(sql_query)
        results = IsoConverter.convert_to_iso(results, datetime_format, 
                                                ws_config['jsonb_to_string'])

        return jsonify({"records" : results})

    except ValueError as e:
        response = jsonify({'error': str(e)})
        return response, 422
    finally:
        db_connector.close_connection()

@app.route('/swit/<string:config_file>/status/', methods=['GET'])
def database_status(config_file):
    db_config = LoadConfig.load_db_config(config_file)

    if not db_config:
        response = jsonify({'error': 'No configuration provided for the selected database'})
        return response, 404

    if db_config:

        start_time = time.time()                                                    # Set the starting time of the connection

        db_connector = DatabaseConnector(db_config)                                 # Connect to the database

        try:
            db_connector.connect()
        except ValueError as e:
            response = jsonify({'error': str(e)})
            return response, 403

        end_time = time.time()
        duration = round(end_time - start_time, 4)                                  # Set the ending time of the connection

        try:
            status = db_connector.ping_database()                                   # Ping the database and extract connection time and number of active queries

            if status.get('connection_time'):
                status['connection_time'] = f'{duration} seconds'                   # Set the duration time in the dictionary

            return jsonify({'status': status})

        except ValueError as e:
            response = jsonify({'error': str(e)})
            return response, 403
        finally:
            db_connector.close_connection()

# Redirects old routes to the the ones
@app.route('/<string:config_file>.php/records/<path:table>', methods=['GET'])
def redirect_to_get_records(config_file, table):
    """
    Redirects the old-style URL to the new get_records route, 
    including the query parameters.
    """
    # Get the full query string (e.g., ?filter1=value&size=10)
    query_string = request.query_string.decode()  # .decode() is used to convert bytes to string

    # Generate the redirect URL with the query parameters
    redirect_url = url_for('get_records', config_file=config_file, table=table)

    # Append the original query string to the URL, if it exists
    if query_string:
        redirect_url += f'?{query_string}'

    # Perform the redirect
    return redirect(redirect_url)

# Troubleshoot undesired browser extensions
@app.route("/favicon.ico")
def favicon():
    return url_for('static', filename='data:,')

@app.after_request
def handle_options(response):
    response.headers["Access-Control-Allow-Origin"] = ','.join(ws_config['cors_allowed'])
    response.headers["Access-Control-Allow-Methods"] = "GET"
    response.headers["Access-Control-Allow-Headers"] = "application/json; charset=utf-8"

    return response
