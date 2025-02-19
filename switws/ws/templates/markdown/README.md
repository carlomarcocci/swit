# SwitWs

SwitWs, similar to other web services such as TreeQL, is developed to display query results in JSON format. It is possible to configure the service to connect to a database and make queries via requests to the endpoint. The WS web interface is entirely developed in Python using Flask and can be extended according to user needs.

The project is inspired by the work already done in PHP and documented in the [PHP-CRUD-API repository](https://github.com/mevdschee/php-crud-api/), which serves as a valuable reference for similar functionalities.

The service is entirely containerized with Docker, and you can configure endpoints, volumes (for both configuration directories and system directories), and logging paths directly from the docker-compose.yml file.

It's important to note that while SwitWs is inspired by an open-source project, it's developed independently, ensuring compliance with legal requirements and avoiding any direct code usage or infringement issues.

## Configuration

To configure SwitWs, you need to populate two types of files:

- A YAML configuration file (*ws_configuration*) where you can define timeouts, limiters and other middlewares. These checks include:
    - ```timeout```: Set the timeout of the connection for each worker (default: *120*)
    - ```requests_per_minute```: this middleware limits the number of requests per minute for each worker (default: *1000*)
    - ```workers```: this option sets the number of workers, if not provided the number of workers is calculated automatically by considering the server capabilities
    - ```loglevel```: this option sets the loglevel (fields allowed: *'debug'*, *'info'*, *'warning'*, *'error'*, *'critical'*; default: *'debug'*)
    - ```cors_allowed```: this options set the list of CORS allowed (default: all)
    - ```datetime_format```: this option sets the format of the response for datatime fields, if provided sets the desired format
    - ```jsonb_to_string```: set to *true* if is needed to convert the jsonb fields extracted as string values (default: *true*)
    - ```cache_config```: with this option you can set the configuration for the cache (default: *NullCache*, allowed cache types: *NullCache*, *SimpleCache*, *FileSystemCache*, *RedisCache*). To set properly the cache configuration see [Flask-Caching](https://flask-caching.readthedocs.io/en/latest/)
- One or more YAML files containing the host, ports, username, and password to connect to Postgres databases. If you want to establish connections with multiple databases or different users (e.g., with different grants on their respective databases), you can insert several configuration files of this type in the designated path. In each file, middlewares for input validation can also be configured, as described in the dedicated section of this document.

To define the correct configuration path, you can use the .env file located in the main directory (it is recommended to maintain the indicated path).

## User Guide

In this section are described:

- Web Service routes and functionalities
- How to perform TreeQL queries
- Middlewares for input validation

### Routing

Below is the list of operations that can be performed by accessing a specific route:

- **About Route** (/)
    - **Method**: GET
    - **Description**: Renders the README content in HTML format.
    - **Functionality**: Reads the README content from a Markdown file, converts it to HTML, and renders it using a template.  
- **Get Databases Route** (/swit/)
    - **Method**: GET
    - **Description**: Retrieves a list of available database configurations.
    - **Functionality**: Scans the configuration directory for YAML files, loads each file, and extracts database configuration details.  
- **Get Tables Route** (/swit/```<string:config_file>```/)
    - **Method**: GET
    - **Description**: Retrieves a list of tables, views and tablefuncs from a specific database configuration.
    - **Functionality**: Connects to the specified database using the provided configuration, fetches table and view information, and filters based on allowed tables and functions if specified. 
- **Get Table Struct Route** (/swit/```<string:config_file>```/```<path:table>```)
    - **Method**: GET
    - **Description**: Lists columns and column types for a specific table or view in a database. For tablefuncs it lists also the arguments and argument types required.
    - **Functionality**: Returns a list of columns and column types for a specific table or view in a database.
- **Get Records Route** (/swit/```<string:config_file>```/records/```<path:table>?[GET methods]```)
    - **Method**: GET
    - **Description**: Retrieves records from a specific table, view or tablefunc in a database.
    - **Functionality**: Converts TreeQL queries to SQL, executes the SQL query on the database, and returns the records in JSON format. For this routing are elencated in next section the functionalities.
- **Database Status Route** (/swit/```<string:config_file>```/status/)
    - **Method**: GET
    - **Description**: Checks the status of a specific database.
    - **Functionality**: Connects to the specified database using the provided configuration, pings the database to check connectivity and active queries, and returns the status.
        The status is reported with the following struct containing the following fields:
        - *database_status*: reports if the database is reachable, 
        - *connection_time*: tracks the time required to connect to the database, 
        - *active_queries_count*: reports the number of queries in status *active* for the given user, 
        - *stress_indicator*: gives information on the number of queries that are active for more than 30 seconds with respect the total number.

### TreeQL queries

The example posts table has only a a few fields:
```bash
    posts  
    =======
    id     
    title  
    content
    created
```
The CRUD + List operations below act on this table.

To list records from this table the request can be written in URL format as:

```bash
    GET /records/posts
```

It will return:
```bash
    {
        "records":[
            {
                "id": 1,
                "title": "Hello world!",
                "content": "Welcome to the first post.",
                "created": "2018-03-05T20:12:56Z"
            }
        ]
    }
```
On list operations you may apply filters and joins.

#### Filters

Filters provide search functionality, on list calls, using the "filter" parameter. You need to specify the column
name, a comma, the match type, another comma and the value you want to filter on. These are supported match types:

  - *cs*: contain string (string contains value)
  - *sw*: start with (string starts with value)
  - *ew*: end with (string end with value)
  - *eq*: equal (string or number matches exactly)
  - *lt*: lower than (number is lower than value)
  - *le*: lower or equal (number is lower than or equal to value)
  - *ge*: greater or equal (number is higher than or equal to value)
  - *gt*: greater than (number is higher than value)
  - *bt*: between (number is between two comma separated values)
  - *in*: in (number or string is in comma separated list of values)
  - *is*: is null (field contains "NULL" value)

You can negate all filters by prepending a "n" character, so that "eq" becomes "neq". 
Examples of filter usage are:

```bash
    GET /records/categories?filter=name,eq,Internet
    GET /records/categories?filter=name,sw,Inter
    GET /records/categories?filter=id,le,1
    GET /records/categories?filter=id,ngt,1
    GET /records/categories?filter=id,bt,0,1
    GET /records/categories?filter=id,in,0,1
```

Output:
```bash
    {
        "records":[
            {
                "id": 1
                "name": "Internet"
            }
        ]
    }
```

In the next section we dive deeper into how you can apply multiple filters on a single list call.

#### Multiple filters

Filters can be a by applied by repeating the "filter" parameter in the URL. For example the following URL: 

```bash
    GET /records/categories?filter=id,gt,1&filter=id,lt,3
```

will request all categories "where id > 1 and id < 3". If you wanted "where id = 2 or id = 4" you should write:

```bash
    GET /records/categories?filter1=id,eq,2&filter2=id,eq,4
```

As you see we added a number to the "filter" parameter to indicate that "OR" instead of "AND" should be applied.
Note that you can also repeat "filter1" and create an "AND" within an "OR". 

NB: You can only filter on the requested table (not on it's included tables) and filters are only applied on list calls.

#### Column selection

By default all columns are selected. With the "include" parameter you can select specific columns. 
You may use a dot to separate the table name from the column name. Multiple columns should be comma separated:

```bash
    GET /records/categories?include=name
    GET /records/categories?include=categories.name
```

Output:
```bash
    {
        "name": "Internet"
    }
```

NB: Columns that are used to include related entities are automatically added and cannot be left out of the output.

#### Ordering

With the "order" parameter you can sort. By default the sort is in ascending order, but by specifying "desc" this can be reversed:

```bash
    GET /records/categories?order=name,desc
    GET /records/categories?order=id,desc&order=name
```

Output:
```bash
    {
        "records":[
            {
                "id": 3
                "name": "Web development"
            },
            {
                "id": 1
                "name": "Internet"
            }
        ]
    }
```

NB: You may sort on multiple fields by using multiple "order" parameters.

#### Limit size

The "size" parameter limits the number of returned records. This can be used for top N lists together with the "order" parameter (use descending order).

```bash
    GET /records/categories?order=id,desc&size=1
```

Output:

```bash
    {
        "records":[
            {
                "id": 3
                "name": "Web development"
            }
        ]
    }
```

#### Tablefuncs interrogation

SwitWs supports querying PostgreSQL table functions (tablefuncs), which return sets of records in a format similar to tables. These functions can be invoked via the **Get Records Route**, just like tables and views. To do this, specify the function name in place of the table name and use the "argument" parameter for each required input. All other query parameters (e.g., filters, ordering, sizing, etc...) previously listed for tables and views are also supported.

For example:

```bash
    GET /records/roles_tablefunc?argument=name,Marco Polo&argument=role,consultant&order=id,desc&size=1
```

This query calls the *roles_tablefunc* function, passing "Marco Polo" as the name argument and "consultant" as the role argument, while also ordering the results by id in descending order and limiting the response to 1 record.

Output:

```bash
    {
        "records":[
            {
                "id": 200
                "birth_date": "09/15/1254"
                "assigned_to": "Repubblica di Venezia"
            }
        ]
    }
```


### Input Validation Configuration

To ensure the integrity and security of the incoming queries, you can configure each database configuration YAML file to performs checks ont the query structure and content. In details: 

#### timeout

Set the ```timeout``` for Postgres connection and query executions.

- **Configuration**
    - **timeout**: An integer which represents the maximum number of seconds for Postgres connections. If none or not given, is set to a default of 120 seconds.

#### schema

Set the ```schema``` that the objects being queried belong to.

- **Configuration**
    - **schema**: A string which represents the schema to which the objects to be queried belong. If none or not given, is set to *public*.

#### allowed_tables

The ```allowed_tables``` check allows specifying a list of tables that are allowed to be queried. If no tables are specified or if the list is empty, no restrictions are applied, and queries to all tables are allowed.

- **Configuration**
    - **allowed_tables**: A list of tables that are allowed to be queried. If none or not given, no restrictions are applied.

#### allowed_functions

The ```allowed_functions``` check allows specifying a list of tablefuncs that are allowed to be queried. If no tablefuncs are specified or if the list is empty, no restrictions are applied, and queries to all tablefuncs are allowed.

- **Configuration**
    - **allowed_functions**: A list of tablefuncs that are allowed to be queried. If none or not given, no restrictions are applied.

#### clauses_not_allowed

The ```clauses_not_allowed``` check allows specifying an array of clauses that are not allowed in the WHERE conditions of queries. If any of these clauses are found in the query, an error is raised.

- **Configuration**
    - **clauses_not_allowed**: An array of clauses that are not allowed in the WHERE conditions of queries.

#### default_size

Insert a default value to limit the size of the requests. If the size exceeds ```default_size``` or no limit clause is given, it takes the default value.

- **Configuration**
    - **default_size**: An integer representing the default size limit for query results. If not specified, the default value is *None* and no limit clause is applied.

#### validate_between_clause
The ```validate_between_clause``` check enables validation on the bt (between) clause in queries. It checks for the presence of an eq clause or a bt clause bounded by the given limits. If the conditions are not satisfied, it also checks if the size clause respects the maximum limit size.

- **Configuration**
    - ```tables```: A list of tables that for which is required the validation control.
    - ```columns```: A list of columns that require a date or numeric value between two specified values.
        - ```column_name```: The name of the column to be checked.
        - ```type```: The type of variable to check (supported types: datetime, time, numeric).
        - ```format_string```: The format string to be allowed for datetime or time types (leave blank for numeric types).
        - ```max_difference```: The maximum difference allowed between the two values.
    - ```size_max```: The maximum size allowed for query results if the conditions specified by validate_between_clause are not met.

## Errors

The following errors may be reported:

HTTP response code        | Message
------------------------- | --------------
403 Forbidden             | Origin is forbidden 
403 Forbidden             | Database connection not established
404 Not found             | Route not found 
404 Not found             | Configuration file not found
422 Unprocessable entity  | Error performing queries
422 Unprocessable entity  | Input validations failed
422 Unprocessable entity  | Cannot read HTTP message 
429 Too Many Requests     | Requests exceed the maximum limit
500 Internal server error | Unknown error 
  

```
```
The following JSON structure is used:

```bash
    {
        "error": "No configuration provided for the selected database"
    }
```

**NB:** Any non-error response will have status: 200 OK