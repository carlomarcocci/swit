import os
import psycopg2
import re
import yaml
import sys
import json
from datetime import datetime, date, time
import logging
import markdown
import hashlib

class LoadConfig:

    # Set loglevel to ERROR to make it visible on the logs errors while uploading the configurations
    logging.basicConfig(level=logging.WARNING, format='%(asctime)s - %(levelname)s - %(message)s')

    default_ws_config = {
        "timeout": 120,
        "requests_per_minute": 100,
        "loglevel": None,
        "workers": None,
        "cors_allowed": ['*'],
        "datetime_format": '%Y/%m/%d %H:%M:%S',
        "jsonb_to_string": True,
        "cache_config": {
            "CACHE_TYPE": "NullCache"
        }
    }

    default_db_config = {
        "allowed_tables": None,
        "clauses_not_allowed": [],
        "default_size": None,
        "validate_between_clause": None,
        "timeout": 120
    }

    db_config_required_fields = ['host', 'port', 'database', 'user']

    @staticmethod
    def load_db_config(name_yml):
        return LoadConfig.load_config(name_yml, 'db')

    @staticmethod
    def load_ws_config(name_yml):
        return LoadConfig.load_config(name_yml, 'ws')

    @staticmethod
    def load_config(name_yml, config_type):
        if config_type == "ws":
            app_dir = '/etc/switws/config/'
            default_config = LoadConfig.default_ws_config
        elif config_type == "db":
            app_dir = '/etc/switws/config/conf.d/'
            default_config = LoadConfig.default_db_config
        else:
            return None
        
        config_file = os.path.join(app_dir, name_yml + '.yml')

        try:
            with open(config_file, 'r') as file:
                config = yaml.safe_load(file)

            # Check if required fields are present
            if config_type == "db" and not all(field in config for field in LoadConfig.db_config_required_fields):
                logging.error("One or more required fields are missing in the database configuration.")
                return None

            # Attempt to retrieve password from environment variable if not present in config
            if config_type == "db" and 'password' not in config:
                password_env_var = f"{name_yml.upper()}_POSTGRES_PASSWORD"
                if password_env_var in os.environ:
                    config['password'] = os.environ[password_env_var]
                else:
                    logging.error("Postgres password not found in configuration or environment.")
                    return None

            # Check for inconsistencies in the field format
            LoadConfig._validate_config(config, config_type)

            # Fill missing fields with defaults from default_db_config
            for field, default_value in default_config.items():
                config.setdefault(field, default_value)

            return config

        except Exception as e:
            logging.error(f"Error loading database configuration: {str(e)}")
            return None

    @staticmethod
    def _validate_config(config, config_type):
        if config_type == "ws":
            LoadConfig._validate_ws_config(config)
        if config_type == "db":
            LoadConfig._validate_db_config(config)  

    @staticmethod
    def _validate_ws_config(ws_config):
        for key, value in ws_config.items():
            if key in LoadConfig.default_ws_config:
                if key == 'loglevel':
                    if value not in ['debug', 'info', 'warning', 'error', 'critical']:
                        logging.warning(f"Invalid value '{value}' for '{key}'. Setting to default.")
                        ws_config[key] = LoadConfig.default_ws_config[key]
                elif key == 'workers':
                    if not isinstance(value, int):
                        logging.warning(f"Invalid value '{value}' type for '{key}'. Setting to default.")
                        ws_config[key] = LoadConfig.default_ws_config[key]
                elif isinstance(LoadConfig.default_ws_config[key], int) and not isinstance(value, int):
                    logging.warning(f"Invalid value '{value}' type for '{key}'. Setting to default.")
                    ws_config[key] = LoadConfig.default_ws_config[key]
                elif isinstance(LoadConfig.default_ws_config[key], str) and not isinstance(value, str):
                    logging.warning(f"Invalid value '{value}' type for '{key}'. Setting to default.")
                    ws_config[key] = LoadConfig.default_ws_config[key]
                elif isinstance(LoadConfig.default_ws_config[key], list) and not isinstance(value, list):
                    logging.warning(f"Invalid value '{value}' type for '{key}'. Setting to default.")
                    ws_config[key] = LoadConfig.default_ws_config[key]
                elif isinstance(LoadConfig.default_ws_config[key], dict) and not isinstance(value, dict):
                    logging.warning(f"Invalid value '{value}' type for '{key}'. Setting to default.")
                    ws_config[key] = LoadConfig.default_ws_config[key]
                elif isinstance(LoadConfig.default_ws_config[key], bool) and not isinstance(value, bool):
                    logging.warning(f"Invalid value '{value}' type for '{key}'. Setting to default.")
                    ws_config[key] = LoadConfig.default_ws_config[key]

    @staticmethod
    def _validate_db_config(db_config):
        for key, value in db_config.items():
            if key in LoadConfig.default_db_config:
                if key == 'allowed_tables':
                    if not isinstance(value, list):
                        logging.debug(f"Invalid value '{value}' type for '{key}'. Setting to default.")
                        db_config[key] = LoadConfig.default_db_config[key]
                if key == 'default_size':
                    if not isinstance(value, int):
                        logging.debug(f"Invalid value '{value}' type for '{key}'. Setting to default.")
                        db_config[key] = LoadConfig.default_db_config[key]
                elif key == 'validate_between_clause': 
                    if not isinstance(value, dict):
                        logging.debug(f"Invalid value '{value}' type for '{key}'. Setting to default.")
                        db_config[key] = LoadConfig.default_db_config[key]
                    else:
                        if LoadConfig._validate_between_clause(value):
                            db_config[key] = LoadConfig.default_db_config[key]                
                elif isinstance(LoadConfig.default_db_config[key], int) and not isinstance(value, int):
                    logging.debug(f"Invalid value '{value}' type for '{key}'. Setting to default.")
                    db_config[key] = LoadConfig.default_db_config[key]
                elif isinstance(LoadConfig.default_db_config[key], list) and not isinstance(value, list):
                    logging.debug(f"Invalid value '{value}' type for '{key}'. Setting to default.")
                    db_config[key] = LoadConfig.default_db_config[key]

    @staticmethod
    def _validate_between_clause(validate_between_clause):
        # Check if 'columns' key is present and it is a list
        if 'columns' not in validate_between_clause or not isinstance(validate_between_clause['columns'], list):
            logging.debug("Invalid format for 'validate_between_clause.columns'. Setting to default.")
            return True

        # Check if 'tables' key is present and it is a list
        if 'tables' not in validate_between_clause or not isinstance(validate_between_clause['tables'], list) or validate_between_clause['tables'] == '*':
            logging.debug("Invalid format for 'validate_between_clause.tables'. Setting to default.")
            return True

        for column in validate_between_clause['columns']:
            if not isinstance(column, dict):
                logging.debug(f"Invalid format for 'validate_between_clause.columns'. Setting to default.")
                return True

            # Check if required keys are present
            required_keys = ['column_name', 'type', 'format_string', 'max_difference']
            if not all(key in column for key in required_keys):
                logging.debug(f"One or more required keys are missing in 'validate_between_clause.columns'. Setting to default.")
                return True

            # Check if 'type' value is valid
            valid_types = ['datetime', 'time', 'numeric']

            if column['type'] not in valid_types:
                logging.debug(f"Invalid value '{column['type']}' for 'type' in 'validate_between_clause.columns'. Setting to default.")
                return True

            # Check if 'max_difference' value is an integer
            if not isinstance(column['max_difference'], int):
                logging.debug(f"Invalid value '{column['max_difference']}' type for 'max_difference' in 'validate_between_clause.columns'. Setting to default.")
                return True

class ContentLoader:
    @staticmethod
    def md_loader(md_file, app_dir):
        about_path = os.path.join(app_dir, 'templates', 'markdown', md_file + '.md')
        with open(about_path, 'r') as file:
            content = file.read()
        return content 

class DecodeMarkdown:
    @staticmethod
    def to_html(content):
        html = markdown.markdown(content, extensions=['fenced_code', 'tables', 'toc'])
        return html

class DatabaseConnector:
    def __init__(self, host, port, database, user, password, timeout):
        self.host = host
        self.port = port
        self.database = database
        self.user = user
        self.password = password
        self.connection = None
        self.cursor = None
        self.timeout = timeout


    def connect(self):
        try:
            self.connection = psycopg2.connect(
                host=self.host,
                port=self.port,
                database=self.database,
                user=self.user,
                password=self.password,
                connect_timeout=self.timeout,
                options= f"-c statement_timeout={self.timeout}s"
            )
            self.cursor = self.connection.cursor()

        except psycopg2.OperationalError as error:
            raise ValueError(str(error).rstrip('\n'))        
        except psycopg2.extensions.QueryCanceledError:
            raise ValueError("Query timed out")    
        except (psycopg2.Error, psycopg2.DatabaseError):
            raise ValueError("Error connecting to the database")

    def ping_database(self):

        if self.cursor:
            try:     

                # Execute the query to obtain the number of active queries for the selected user
                self.cursor.execute("SELECT COUNT(*) - 1 FROM pg_stat_activity WHERE usename = current_user AND state = 'active'")
                active_queries_count = self.cursor.fetchone()[0]

                # Execute the query to obtain the number of active queries for the selected user that last for more than 30 seconds
                self.cursor.execute("SELECT COUNT(*) FROM pg_stat_activity WHERE usename = current_user AND state = 'active' AND now() - query_start > interval '30 seconds'")
                active_long_running_queries = self.cursor.fetchone()[0]

                # Compute the stress indicator
                if active_queries_count > 0:
                    stress_indicator = round(active_long_running_queries / active_queries_count * 100, 2)
                else:
                    stress_indicator = 0.00

                return {
                    'database_status': 'Database reachable',
                    'connection_time': '0.0 seconds',
                    'active_queries_count': active_queries_count,
                    'stress_indicator': stress_indicator
                }
                
            except Exception:
                return {'database_status': 'Database not reachable',
                        'connection_time': '0.0 seconds',
                        'active_queries_count': None,
                        'stress_indicator': None
                }
        else:
            raise ValueError("Database connection not established.")

    def get_tables_and_views(self):
        if self.cursor:
            try:
                self.cursor.execute("""
                    SELECT table_name, table_type
                    FROM information_schema.tables
                    WHERE table_schema = 'public'
                """)
                rows = self.cursor.fetchall()
                tables = [{'name': row[0], 'type': row[1]} for row in rows]
                return tables

            except psycopg2.extensions.QueryCanceledError:
                raise ValueError("Query timed out")      
            except (psycopg2.Error, psycopg2.DatabaseError, AttributeError):
                raise ValueError("Error executing the query")
        else:
            raise ValueError("Database connection not established.")

    def get_table_struct(self, table):
        if self.cursor:
            try:
                # Check if the table is a view or a simple table
                self.cursor.execute("""
                    SELECT table_name
                    FROM information_schema.views
                    WHERE table_name = %s
                """, (table,))
                is_view = bool(self.cursor.fetchone())

                if is_view:
                    # If table is a view, obtain the columns from information_schema.views
                    self.cursor.execute("""
                        SELECT column_name, data_type
                        FROM information_schema.columns
                        WHERE table_name = %s
                    """, (table,))
                else:
                    # If table is a table, ontain the columns from information_schema.columns
                    self.cursor.execute("""
                        SELECT column_name, data_type
                        FROM information_schema.columns
                        WHERE table_name = %s
                    """, (table,))

                rows = self.cursor.fetchall()
                table_struct = [{'name': row[0], 'type': row[1]} for row in rows]
                if table_struct == []:
                    raise ValueError("Table or view not found")
                return table_struct

            except psycopg2.ProgrammingError:
                raise ValueError("Invalid table or privilege issues")
            except psycopg2.extensions.QueryCanceledError:
                raise ValueError("Query timed out")      
            except (psycopg2.Error, psycopg2.DatabaseError, AttributeError):
                raise ValueError("Error executing the query")
        else:
            raise ValueError("Database connection not established.")

    def execute_query(self, query):
        if self.cursor:
            try:
                self.cursor.execute(query)
                result = self.cursor.fetchall()
                column_names = [desc[0] for desc in self.cursor.description]
                data = []

                for row in result:
                    data.append(dict(zip(column_names, row)))
                return data

            except psycopg2.errors.SyntaxError:
                raise ValueError("Error in the statement syntax")
            except psycopg2.ProgrammingError:
                raise ValueError("Invalid table/column names or incorrect data types")
            except psycopg2.extensions.QueryCanceledError:
                raise ValueError("Query timed out")                
            except (psycopg2.Error, psycopg2.DatabaseError, AttributeError):
                raise ValueError("Error executing the query")
        else:
            raise ValueError("Database connection not established.")

    def close_connection(self):

        if self.cursor:
            self.cursor.close()

        if self.connection:
            self.connection.close()

class IsoConverter:
    @staticmethod
    def convert_to_iso(results, datetime_format, jsonb_to_string = False):

        if isinstance(results, dict) and results['error']:
            return results

        else:
            for row in results:
                for key, value in row.items():

                    if isinstance(value, (date, time)):
                        row[key] = value.isoformat()

                    if isinstance(value, datetime):
                        row[key] = value.strftime(datetime_format)

                    elif jsonb_to_string and (isinstance(value, list) or isinstance(value, dict)):
                        row[key] = json.dumps(value)

            return results

class ErrorHandler:
    error_dict = {
                1001: "Database Connection Not Established",
                1002: "Database Connection Timeout",
                1003: "Too Many Requests",
                1004: "Request Not Allowed",
                1005: "Query Error",
                1006: "Timeout Reached"
                }

    @classmethod
    def handle_error(cls, error_code, error_description):
        if error_code in cls.error_dict:
            return {
                "error_code": error_code,
                "error_message": cls.error_dict[error_code],
                "error_description": error_description
            }
        else:
            return {
                "error_code": error_code,
                "error_message": "Unknown Error",
                "error_description": error_description
            }

class NewLoadConfig:
    # Set loglevel to ERROR to make it visible on the logs errors while uploading the configurations
    logging.basicConfig(level=logging.WARNING, format='%(asctime)s - %(levelname)s - %(message)s')

    default_ws_config = {
        "timeout": 60,
        "requests_per_minute": 100,
        "loglevel": None,
        "workers": None,
        "cors_allowed": ['*'],
        "datetime_format": '%Y/%m/%d %H:%M:%S',
        "jsonb_to_string": True,
    }

    default_db_config = {
        "allowed_tables": None,
        "clauses_not_allowed": [],
        "validate_between_clause": None,
        "timeout": 60
    }

    db_config_required_fields = ['host', 'port', 'database', 'user', 'password']

    def __init__(self):
        self._ws_config = None
        self._db_configs = {}
        self._load_all_db_configs()

    @property
    def ws_config(self):
        if self._ws_config is None:
            self._ws_config = self._load_ws_config()
        return self._ws_config

    @property
    def db_configs(self):
        if not self._db_configs:
            self._load_all_db_configs()
        return self._db_configs

    def get_db_config(self, name_yml):
        if name_yml in self._db_configs:
            current_config = self._db_configs[name_yml]
            file_hash = self._retrieve_hash(name_yml)

            if file_hash != current_config.get('hash'):
                logging.warning(f"Configuration '{name_yml}' has changed. Reloading...")
                new_config = self._load_db_config(name_yml)
                self._db_configs[name_yml] = new_config
                return new_config
            else:
                return current_config
        else:
            logging.warning(f"Configuration '{name_yml}' not found in cache. Loading...")
            new_config = self._load_db_config(name_yml)
            self._db_configs[name_yml] = new_config             
            return new_config

    def _load_ws_config(self):
        ws_config = self._load_yaml_config("ws", 'ws_configuration')
        if ws_config:
            return ws_config
        else:
            return self.default_ws_config

    def _load_db_config(self, name_yml):
        return self._load_yaml_config("db", name_yml)

    def _load_all_db_configs(self):
        app_dir = '/etc/switws/config/conf.d/'
        yaml_files = [f for f in os.listdir(app_dir) if f.endswith('.yml')]
        for name_yml in yaml_files:
            db_config = self._load_db_config(os.path.splitext(name_yml)[0])
            if db_config:
                self._db_configs[os.path.splitext(name_yml)[0]] = db_config

    def _load_yaml_config(self, config_type, name_yml):
        if config_type == "ws":
            app_dir = '/etc/switws/config/'
            default_config = self.default_ws_config
        elif config_type == "db":
            app_dir = '/etc/switws/config/conf.d/'
            default_config = self.default_db_config
        else:
            return None

        config_file = os.path.join(app_dir, name_yml + '.yml')
        try:
            with open(config_file, 'r') as file:
                file_content = file.read()
                config = yaml.safe_load(file_content)

            # Check if required fields are present
            if config_type == "db" and not all(field in config for field in self.db_config_required_fields):
                logging.error("One or more required fields are missing in the configuration.")
                return None

            # Check for inconsistencies in the field format
            self._validate_config(config, default_config)

            # Fill missing fields with defaults from default_config
            for field, default_value in default_config.items():
                config.setdefault(field, default_value)

            # Set the hash value
            if config_type == 'db':
                config_hash = hashlib.md5(file_content.encode()).hexdigest()
                
                config["hash"] = config_hash

            return config

        except FileNotFoundError:
            logging.error(f"Configuration file '{config_file}' not found.")
            
        except yaml.YAMLError as e:
            logging.error(f"Error parsing YAML in configuration file '{config_file}': {e}")
            
        except Exception as e:
            logging.error(f"Error loading '{config_file}' configuration: {str(e)}")
            return None

    def _retrieve_hash(self, name_yml):
        if name_yml not in self._db_configs:
            logging.warning(f"Configuration '{name_yml}' not found.")
            return None

        config_file = os.path.join('/etc/switws/config/conf.d/', name_yml + '.yml')
        try:
            with open(config_file, 'r') as file:
                file_content = file.read()
                config_hash = hashlib.md5(file_content.encode()).hexdigest()

                return config_hash

        except Exception as e:
            logging.error(f"Error loading '{config_file}' configuration: {str(e)}")
            return None        

    def _validate_config(self, config, default_config):
        for key, value in config.items():
            if key in default_config:
                default_value = default_config[key]
                
                if key == 'allowed_tables':
                    if not isinstance(value, list):
                        logging.warning(f"Invalid value '{value}' type for '{key}'. Setting to default.")
                        config[key] = default_value
                        
                elif key == 'validate_between_clause': 
                    if not isinstance(value, dict):
                        logging.warning(f"Invalid value '{value}' type for '{key}'. Setting to default.")
                        config[key] = default_value
                    else:
                        if self._validate_between_clause(value):
                            config[key] = default_value
                             
                elif key == 'loglevel':
                    if value not in ['debug', 'info', 'warning', 'error', 'critical']:
                        logging.warning(f"Invalid value '{value}' for '{key}'. Setting to default.")
                        config[key] = default_value
                        
                elif key == 'workers':
                    if not isinstance(value, int):
                        logging.warning(f"Invalid value '{value}' type for '{key}'. Setting to default.")
                        config[key] = default_value
                        
                elif isinstance(default_value, list) and not isinstance(value, list) and default_value is not None:
                    logging.warning(f"Invalid value '{value}' type for '{key}'. Setting to default.")
                    config[key] = default_value
                    
                elif isinstance(default_value, int) and not isinstance(value, int) and default_value is not None:
                    logging.warning(f"Invalid value '{value}' type for '{key}'. Setting to default.")
                    config[key] = default_value
                    
                elif isinstance(default_value, str) and not isinstance(value, str) and default_value is not None:
                    logging.warning(f"Invalid value '{value}' type for '{key}'. Setting to default.")
                    config[key] = default_value
                    
                elif isinstance(default_value, bool) and not isinstance(value, bool) and default_value is not None:
                    logging.warning(f"Invalid value '{value}' type for '{key}'. Setting to default.")
                    config[key] = default_value

    @staticmethod
    def _validate_between_clause(validate_between_clause):
        # Check if 'columns' key is present and it is a list
        if 'columns' not in validate_between_clause or not isinstance(validate_between_clause['columns'], list):
            logging.warning("Invalid format for 'validate_between_clause.columns'. Setting to default.")
            return True

        for column in validate_between_clause['columns']:
            if not isinstance(column, dict):
                logging.warning(f"Invalid format for 'validate_between_clause.columns'. Setting to default.")
                return True

            # Check if required keys are present
            required_keys = ['column_name', 'type', 'format_string', 'max_difference']
            if not all(key in column for key in required_keys):
                logging.warning(f"One or more required keys are missing in 'validate_between_clause.columns'. Setting to default.")
                return True

            # Check if 'type' value is valid
            valid_types = ['datetime', 'time', 'numeric']

            if column['type'] not in valid_types:
                logging.warning(f"Invalid value '{column['type']}' for 'type' in 'validate_between_clause.columns'. Setting to default.")
                return True

            # Check if 'max_difference' value is an integer
            if not isinstance(column['max_difference'], int):
                logging.warning(f"Invalid value '{column['max_difference']}' type for 'max_difference' in 'validate_between_clause.columns'. Setting to default.")
                return True