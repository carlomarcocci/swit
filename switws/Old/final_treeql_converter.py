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
            return sql_query 

        table_name = parts[0]
        query_params = parts[1].split('&')

        filters = {}
        limit = None
        order_bys = []
        include_fields = []

        for param in query_params:

            if param.startswith('filter'):
                filter_parts = param[len('filter'):].split('=')

                if len(filter_parts) == 2:
                    tag, filter_str = filter_parts[0], filter_parts[1]

                    if tag not in filters:
                        filters[tag] = []

                    filters[tag].append(filter_str)

            elif param.startswith('size'):
                limit = param[5:]  # Remove 'size='

            elif param.startswith('order'):
                order_bys.append(param[6:])  # Remove 'order='

            elif param.startswith('include'):
                include_fields = param[8:].split(',')  # Remove 'include='

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
        tag_list = []

        for tag, filter_list in filters.items():

            tag_list.append(tag)

            if len(filter_list) == 1:
                field, operator, value = filter_list[0].split(',')
                sql_operator = self.operatorMapping.get(operator)

                if sql_operator:
                    sql_filters.append(self._build_condition(field, sql_operator, value))

            elif len(filter_list) > 1:
                or_conditions = []

                for filter_str in filter_list:
                    field, operator, *values = filter_str.split(',')
                    sql_operator = self.operatorMapping.get(operator)

                    if sql_operator:
                        or_conditions.append(self._build_condition(field, sql_operator, *values))

                sql_filters.append(f"({' AND '.join(or_conditions)})")

        if '' in tag_list:
            sub_conditions = f"({' OR '.join(sql_filters[1:])})"
            conditions = f"{sql_filters[0]} AND {sub_conditions}"

        else:
            conditions = ' OR '.join(sql_filters)

        return conditions

    def _convert_order_by(self, order_by):

        order_by_parts = order_by.split(',')
        field = order_by_parts[0]
        direction = order_by_parts[1] if len(order_by_parts) > 1 else 'ASC'
        return f"{field} {direction}"

    def _build_condition(self, field, operator, *values):

        # Check if value is a date or a string and add quotes accordingly
        if operator == 'LIKE' or operator == 'NOT LIKE':
            sql_values = [f"'{v}%'" if not v.isdigit() else v for v in values]

        else:
            sql_values = [f"'{v}'" if not v.isdigit() else v for v in values]

        if operator == 'BETWEEN' or operator == 'NOT BETWEEN':
            return f"{field} {operator} {sql_values[0]} AND {sql_values[1]}"

        elif operator == 'IN' or operator == 'NOT IN':
            return f"{field} {operator} ({', '.join(sql_values)})"       

        else:
            return f"{field} {operator} {sql_values[0]}"


# Example:
#treeql_query = 'categories?filter1=id,eq,2&filter2=id,eq,4&filter2=id,eq,5&filter1=name,cs,apple&filter2=name,cs,orange&include=categories.name&order=id,asc&order=sat,desc'
#treeql_query = 'wsthu0p?filter=dt,bt,2024-02-14 12:53:00,2024-02-14 15:53:00&filter=elevation,gt,30&filter0=PRN,sw,&filter1=PRN,sw,N&filter2=PRN,sw,N&filter3=PRN,sw,N&filter4=PRN,sw,N&filter5=PRN,sw,N&filter6=PRN,sw,N&include=dt,PRN,ipp_lat,ipp_lon,elevation,azimuth,s4_l1_vert,totals4l1,corrections4l1&order=dt,desc'
treeql_query = 'categories?filter=id,eq,2&filter2=id,eq,4&filter3=id,eq,3&filter3=id,eq,6&filter=id,bt,9,11'
converter = TreeQLToSQLConverter()
sql_query = converter.convert_query(treeql_query)
print(sql_query)