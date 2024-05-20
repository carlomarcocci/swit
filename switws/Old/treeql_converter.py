class TreeQLToSQLConverter:

    operatorMapping = {
        'cs': 'LIKE',
        'sw': 'LIKE',
        'ew': 'LIKE',
        'ncs': 'NOT LIKE',
        'nsw': 'NOT LIKE',
        'new': 'NOT LIKE',        
        'eq': '=',
        'neq': '<>',
        'lt': '<',
        'le': '<=',
        'ge': '>=',
        'gt': '>',
        'bt': 'BETWEEN',
        'nbt': 'NOT BETWEEN',        
        'in': 'IN',
        'nin': 'NOT IN',        
        'is': 'IS NULL',
    }

    def convert_query(self, treeql_query):

        parts = treeql_query.split('?')
        if len(parts) != 2:

            table_name = parts[0]
            sql_query = f"SELECT * FROM {table_name}"

            return sql_query                                                    # Invalid query format

        table_name = parts[0]
        query_params = parts[1].split('&')

        filters = []
        limit = None
        order_bys = []
        include_fields = []

        for param in query_params:

            if param.startswith('filter='):
                filters.append(param[7:])                                       # Remove 'filter='

            elif param.startswith('size'):
                limit = param[5:]                                               # Remove 'size='

            elif param.startswith('order'):
                order_bys.append(param[6:])                                     # Remove 'order='

            elif param.startswith('include'):
                include_fields = param[8:].split(',')                           # Remove 'include='

        sql_filters = self._convert_filters(filters)

        sql_query = f"SELECT {', '.join(include_fields) if include_fields else '*'} FROM {table_name}"

        if sql_filters:
            sql_query += f" WHERE {sql_filters}"

        if order_bys:
            sql_order_bys = [self._convert_order_by(order_by) for order_by in order_bys]
            sql_query += f" ORDER BY {', '.join(sql_order_bys)}"

        if limit:
            sql_query += f" LIMIT {limit}"

        return sql_query

    def _convert_filters(self, filters):

        sql_filters = []

        for filter_str in filters:
            filter_parts = filter_str.split(',')

            if len(filter_parts) == 3:
                field, operator, value = filter_parts
                sql_operator = self.operatorMapping.get(operator)

                if sql_operator:

                    sql_filters.append(self._build_single_condition(field, sql_operator, value))                    

            elif len(filter_parts) == 4:
                field, operator, *values = filter_parts
                sql_operator = self.operatorMapping.get(operator)

                if sql_operator:                   

                    if operator == 'bt' or operator=='nbt':
                        # Handle BETWEEN operator with two values separated by a comma
                        sql_values = [f"'{v}'" if not v.isdigit() else v for v in values]
                        sql_filters.append(f"{field} {sql_operator} {sql_values[0]} AND {sql_values[1]}")

                    elif operator == 'in' or operator=='nin':
                        # Handle IN operator
                        sql_values = [f"'{v}'" if not v.isdigit() else v for v in values]
                        values = ','.join(sql_values)
                        sql_filters.append(f"{field} {sql_operator} ({values})")

        return ' AND '.join(sql_filters)

    def _convert_order_by(self, order_by):

        order_by_parts = order_by.split(',')
        field = order_by_parts[0]
        direction = order_by_parts[1] if len(order_by_parts) > 1 else 'ASC'
        return f"{field} {direction}"

    def _build_single_condition(self, field, operator, value):

        # Check if value is a date or a string and add quotes accordingly
        value = f"'{value}'" if not value.isdigit() else value
        return f"{field} {operator} {value}"
