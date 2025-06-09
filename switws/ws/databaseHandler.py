import psycopg2
from extensions import cache

class DatabaseConnector:
    def __init__(self, db_config):
        self.db_config = db_config
        self.host = self.db_config['host']
        self.port = self.db_config['port']
        self.database = self.db_config['database']
        self.user = self.db_config['user']
        self.password = self.db_config['password']
        self.connection = None
        self.cursor = None
        self.timeout = self.db_config['timeout']
        self.schema = self.db_config['schema']

        # Use allowed tables to filter out undesired not alllowed tables
        self.allowed_tables = self.db_config.get('allowed_tables', None)
        if self.allowed_tables:
            if len(self.allowed_tables) == 1:
                self.table_filter = f"AND table_name = '{self.allowed_tables[0]}'"
            else:
                self.table_filter = f"AND table_name IN {tuple(self.allowed_tables)}"
        else:
            self.table_filter = ""

        # Use allowed functions to filter out undesired not alllowed functions
        self.allowed_functions = self.db_config.get('allowed_functions', None)
        if self.allowed_functions:
            if len(self.allowed_functions) == 1:
                self.function_filter = f"AND p.proname = '{self.allowed_functions[0]}'"
            else:
                self.function_filter = f"AND p.proname IN {tuple(self.allowed_functions)}"
        else:
            self.function_filter = ""

    def make_key(self):

        # Construct the base key with the database name
        key_components = [self.database]

        # Add the schema
        key_components.append(self.schema)

        # Add the user
        key_components.append(self.user)

        # Convert all components to a single string joined by "_"
        key = "_".join([str(component) for component in key_components])

        return key

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

    @cache.cached(make_cache_key=make_key)
    def get_tables_and_views(self):
        if self.cursor:
            try:
                query = f"""
                    SELECT table_name, table_type
                    FROM information_schema.tables
                    WHERE table_schema = %s
                    {self.table_filter}
                    UNION
                    SELECT p.proname AS table_name, 'FUNCTION' AS table_type
                    FROM pg_proc p
                    JOIN pg_namespace n ON n.oid = p.pronamespace
                    WHERE n.nspname = %s
                    AND p.prorettype IN (
                        SELECT oid FROM pg_type WHERE typname = 'record'
                    )
                    AND p.proowner IN (SELECT oid FROM pg_roles WHERE rolname <> 'postgres')
                    {self.function_filter}
                """

                params = [self.schema, self.schema]
                self.cursor.execute(query, tuple(params))

                rows = self.cursor.fetchall()
                tables = [{row[0]: row[1]} for row in rows]
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
                # Check if the table is a function
                self.cursor.execute(f"""
                    SELECT 1 AS is_function
                    FROM pg_proc p
                    JOIN pg_namespace n ON n.oid = p.pronamespace
                    WHERE p.proname = %s
                    AND p.prorettype IN (
                        SELECT oid FROM pg_type WHERE typname = 'record'
                    )
                    AND p.proowner IN (SELECT oid FROM pg_roles WHERE rolname <> 'postgres')
                    AND p.pronamespace = (
                        SELECT oid FROM pg_namespace WHERE nspname = %s
                    )
                    {self.function_filter}
                """, (table, self.schema,))
                is_function = bool(self.cursor.fetchone())

                if is_function:
                    # If the table is a function, obtain the columns from pg_proc
                    self.cursor.execute("""
                        SELECT 
                            proargnames[i] AS column_name,
                            proallargtypes[i]::regtype AS data_type,
                            proargmodes[i] AS arg_mode
                        FROM 
                            pg_proc, 
                            generate_subscripts(proallargtypes, 1) AS i
                        WHERE 
                            proname = %s
                    """, (table,))
                    
                    rows = self.cursor.fetchall()
                    arguments = [{'name': row[0], 'type': row[1]} for row in rows if row[2] in ('i', 'b')]
                    records = [{'name': row[0], 'type': row[1]} for row in rows if row[2] in ('t', 'b')]
                else:
                    # If the table is a table, obtain the columns from information_schema.columns
                    self.cursor.execute(f"""
                        SELECT column_name, data_type
                        FROM information_schema.columns
                        WHERE table_name = %s
                        AND table_schema = %s
                        {self.table_filter}
                    """, (table, self.schema,))
                    
                    rows = self.cursor.fetchall()
                    arguments = []
                    records = [{'name': row[0], 'type': row[1]} for row in rows]

                if records == [] and arguments == []:
                    raise ValueError("Table, view or function not found")

                return {'arguments': arguments, 'records': records}

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
                column_names_raw = [desc[0] for desc in self.cursor.description]

                # Applica le modifiche richieste ai nomi delle colonne
                column_names = []
                for name in column_names_raw:
                    if name.lower() == 'prn':
                        column_names.append('PRN')
                    elif name.lower() == 'corrections4_l2c':
                        column_names.append('correctionS4_L2C')
                    else:
                        column_names.append(name)

                data = []

                for row in result:
                    if self.db_config['database'] == 'scint':
                        data.append(dict(zip(column_names, row)))
                    else:
                        processed_row = [
                            str(value) if isinstance(value, (float, complex)) else value
                            for value in row
                        ]
                        data.append(dict(zip(column_names, processed_row)))

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
