from typing import Callable
from functools import wraps
from datetime import datetime, time
import re

class TreeQLToSQLConverter:
    def __init__(self, schema, clauses_not_allowed, validate_between_clause):
        self.schema = schema
        self.clauses_not_allowed = clauses_not_allowed
        self.validate_between_clause = validate_between_clause

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
        'nis': 'IS NOT NULL'
    }

    # Wrapper for validate methods
    @staticmethod
    def validate_input(*arg_types):
        def decorator(func: Callable):
            def wrapper(self, *args, **kwargs):
                if len(args) > len(arg_types):
                    raise ValueError(f"Too many arguments for {func.__name__}")
                
                for i, arg in enumerate(args):
                    if not isinstance(arg, arg_types[i]):
                        raise ValueError(f"Argument {i+1} of {func.__name__} should be of type {arg_types[i]}")
                
                for key, value in kwargs.items():
                    if not isinstance(value, arg_types[-1]):
                        raise ValueError(f"Keyword argument {key} of {func.__name__} should be of type {arg_types[-1]}")

                # Custom checks
                special_chars_pattern = re.compile(r'[!@#$%^&*()+{}\[\]:;<>?~\\/]')

                if isinstance(self, TreeQLToSQLConverter):
                    # Check table name 
                    if special_chars_pattern.search(args[0]):
                        raise ValueError("Invalid characters in table field.")             

                    # Custom check for filters
                    if args[1]:

                        collected_dictionary = {}

                        for tag, filter_list in args[1].items():
                            collected_dictionary[tag] = []

                            for filter_str in filter_list:
                                filter_elements = filter_str.split(',')

                                # Check first element for special characters
                                if re.search(r'[!@#$%^&*()+{}\[\]:;<>?~\\/]', filter_elements[0]):
                                    raise ValueError("Invalid characters in filter field.")
                                
                                # Check second element in operator mapping
                                if filter_elements[1] not in self.operatorMapping:
                                    raise ValueError(f"Invalid operator '{filter_elements[1]}' in filter.")

                                # Check length of filter elements
                                if filter_elements[1] not in ['bt', 'nbt', 'in', 'nin', 'is', 'nis'] and len(filter_elements) != 3:
                                    raise ValueError("Invalid number of elements in filter: Each filter should contain exactly 3 elements separated by comma.")

                                # Check for valid number of elements for certain operators
                                if filter_elements[1] in ['bt', 'nbt', 'in', 'nin'] and len(filter_elements) != 4:
                                    raise ValueError(f"Invalid number of elements for operator '{filter_elements[1]}'. Expected 4 elements separated by comma.")

                                # Check for valid number of elements is operator
                                if filter_elements[1] in ['is', 'nis'] and len(filter_elements) != 2:
                                    raise ValueError(f"Invalid number of elements for operator '{filter_elements[1]}'. Expected 2 elements separated by comma.")

                                # Check if there are any not allowed clauses in the query struct
                                if self.clauses_not_allowed:
                                    if filter_elements[1] in self.clauses_not_allowed:
                                        raise ValueError(f"Operator '{filter_elements[1]}' not allowed.")

                                # Check for between conditions
                                if self.validate_between_clause and (args[0] in self.validate_between_clause['tables'] or self.validate_between_clause['tables'] == '*'):
                                    
                                    column_names = [v['column_name'] for v in self.validate_between_clause['columns']]
                                    if filter_elements[1] in ['bt', 'eq'] and filter_elements[0] in column_names:
                                        collected_dictionary[tag].append({'column_name': filter_elements[0],
                                                                          'operator': filter_elements[1],
                                                                          'values': [value for value in filter_elements[2:]]})
                        if self.validate_between_clause and (args[0] in self.validate_between_clause['tables'] or self.validate_between_clause['tables'] == '*'):
                            filtered_dictionary = self._manipulate_collected_dict(collected_dictionary)

                            if not args[3] and filtered_dictionary == {}:
                                raise ValueError('Query not allowed since the query results unbounded. Insert proper between conditions or a limit condition.')

                    # Check include fields clause
                    if args[2]:
                        include_fields = args[2]
                        include_fields = [field.strip() for field in include_fields.split(',')]

                        # Check for special characters in each field and check for sql injections
                        for field in include_fields:
                            if special_chars_pattern.search(field):
                                raise ValueError("Invalid characters in include fields.")

                            # Check for SQL injection patterns
                            if re.search(r'\bDROP\b|\bDELETE\b|\bTRUNCATE\b|\bALTER\b|\bINSERT\b|\bUPDATE\b|\bSELECT\b', field, re.IGNORECASE):
                                raise ValueError('SQL injection detected in include fields.')

                    # Check size
                    if args[3] and not args[3].isdigit():
                        raise ValueError("Invalid format for size. It should be a positive integer.")

                    # Check for limits in size clause
                    if self.validate_between_clause and (args[0] in self.validate_between_clause['tables'] or self.validate_between_clause['tables'] == '*'):
                        if args[3] and args[1]:
                            if filtered_dictionary == {}:
                                if int(args[3]) > self.validate_between_clause.get('size_max', 100):
                                   raise ValueError("Query size exceeds maximum allowed.")
                        if args[3] and not args[1]:
                            if int(args[3]) > self.validate_between_clause.get('size_max', 100):
                               raise ValueError("Query size exceeds maximum allowed.")                            

                    # Check order by clause
                    if args[4]:
                        for order_by in args[4]:
                            order_by_parts = order_by.split(',')

                            # Check if the list contains only the least minimum number of elements
                            if len(order_by_parts) > 2:
                                raise ValueError("Invalid format for order clause. It should have maximum 2 elements.")

                            # Check if the order by clause contains asc or desc clause or none
                            if len(order_by_parts) > 1 and order_by_parts[1].upper() not in ['ASC', 'DESC']:
                                raise ValueError("Invalid format for order_by. It should be 'field' or 'field, ASC/DESC'.")

                            # Check for special characters in order_by field
                            if special_chars_pattern.search(order_by_parts[0]):
                                raise ValueError("Invalid characters in order_by field.")

                    # Check arguments
                    if args[5]:
                        for argument in args[5]:
                            argument_parts = argument.split(',')

                            # Check if the list contains only the least minimum number of elements
                            if len(argument_parts) != 2:
                                raise ValueError("Invalid format for argument clause. It should have 2 elements.")

                            # Check for special characters in any argument field
                            if special_chars_pattern.search(argument_parts[0]):
                                raise ValueError("Invalid characters in argument field.")
                
                return func(self, *args, **kwargs)
            return wrapper
        return decorator  

    @validate_input(str, (dict, type(None)), (str, type(None)), (str, type(None)), (list, type(None)), (list, type(None)))
    def convert_query_from_request(self, table, filters=None, include_fields=None, size=None, order_bys=None, arguments=None):
        
        sql_filters = self._convert_filters(filters)

        if arguments:
            sql_arguments = self._convert_arguments(arguments)
            sql_query = f"SELECT {include_fields if include_fields else '*'} FROM {self.schema}.{table}({sql_arguments})"
        else:
            sql_query = f"SELECT {include_fields if include_fields else '*'} FROM {self.schema}.{table}"

        if sql_filters:
            sql_query += f" WHERE {sql_filters}"

        if order_bys:
            sql_order_bys = [self._convert_order_by(order_by) for order_by in order_bys]
            sql_query += f" ORDER BY {', '.join(sql_order_bys)}"

        if size:
            sql_query += f" LIMIT {size}"

        return sql_query

    def _convert_filters(self, filters):

        sql_filters = []
        tag_list = []

        for tag, filter_list in filters.items():

            tag_list.append(tag)

            if len(filter_list) == 1:
                field, operator, *values = filter_list[0].split(',')
                sql_operator = self.operatorMapping.get(operator)

                if sql_operator:
                    sql_filters.append(self._build_condition(field, operator, sql_operator, *values))

            elif len(filter_list) > 1:
                or_conditions = []

                for filter_str in filter_list:
                    field, operator, *values = filter_str.split(',')
                    sql_operator = self.operatorMapping.get(operator)

                    if sql_operator:
                        or_conditions.append(self._build_condition(field, operator, sql_operator, *values))

                sql_filters.append(f"({' AND '.join(or_conditions)})")

        if '' in tag_list and len(tag_list) > 1:
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

    def _convert_arguments(self, arguments):

        sql_arguments = []
        for argument in arguments:
            field, value = argument.split(',')
            # Build {field}:= {value} statement            
            if value.isdigit():
                sql_arguments.append(f"{field}:={value}")
            else:
                sql_arguments.append(f"{field}:='{value}'")
        return ', '.join(sql_arguments)

    def _build_condition(self, field, treeql_operator, operator, *values):

        # Check if value is a date or a string and add quotes accordingly
        if operator == 'LIKE' or operator == 'NOT LIKE':
            if treeql_operator == 'sw' or treeql_operator == 'nsw':
                sql_values = [f"'{v}%'" if not v.isdigit() else v for v in values]
            elif treeql_operator == 'cs' or treeql_operator == 'ncs':
                sql_values = [f"'%{v}%'" if not v.isdigit() else v for v in values]
            elif treeql_operator == 'ew' or treeql_operator == 'new':
                sql_values = [f"'%{v}'" if not v.isdigit() else v for v in values]
        else:          
            sql_values = [f"'{v}'" if not v.isdigit() else v for v in values]

        if operator == 'BETWEEN' or operator == 'NOT BETWEEN':
            return f"{field} {operator} {sql_values[0]} AND {sql_values[1]}"

        elif operator == 'IN' or operator == 'NOT IN':
            return f"{field} {operator} ({', '.join(sql_values)})"

        elif operator == 'IS NULL' or operator == 'IS NOT NULL':       
            return f"{field} {operator}"

        else:
            return f"{field} {operator} {sql_values[0]}"

    def _manipulate_collected_dict(self, collected_dictionary):

        validated_dictionary = {}

        # Check if there is an 'eq' operator for the empty tag
        empty_tag_conditions = collected_dictionary.get('')
        if empty_tag_conditions:
            eq_present = any(condition['operator'] == 'eq' for condition in empty_tag_conditions)
            if eq_present:
                # If 'eq' operator is present, return conditions as they are
                validated_dictionary[''] = empty_tag_conditions
                return validated_dictionary

        for tag, conditions in collected_dictionary.items():
            validated_conditions = []

            if tag == '':
                validated_conditions = self._validate_empty_tag_conditions(conditions)
            else:
                validated_conditions = self._validate_tag_conditions(conditions, tag)

            validated_dictionary[tag] = validated_conditions

        # Check if any keys were removed during validation
        if empty_tag_conditions: 
            if not validated_dictionary or all(len(conditions) == 0 for conditions in validated_dictionary.values()):
                # Return an empty dictionary if any conditions were excluded
                return {}

        elif not empty_tag_conditions:
            if not validated_dictionary or any(len(conditions) == 0 for conditions in validated_dictionary.values()):
                # Return an empty dictionary if any conditions were excluded
                return {}
        else:
            # Return the updated collected_dictionary
            return validated_dictionary

    def _validate_empty_tag_conditions(self, conditions):

        validated_conditions = []

        # Check if there are more than one 'bt' operator
        bt_count = sum(1 for condition in conditions if condition['operator'] == 'bt')
        if bt_count > 1:
            raise ValueError("Multiple 'bt' operators are not allowed.")

        # Validate conditions for 'bt' operators based on configuration
        for condition in conditions:
            if condition['operator'] == 'bt':
                column_name = condition['column_name']
                if self._validate_bt_condition(column_name, condition['values']):
                    validated_conditions.append(condition)
            else:
                validated_conditions.append(condition)

        return validated_conditions

    def _validate_tag_conditions(self, conditions, tag):

        validated_conditions = []

        # Check if there is an 'eq' operator
        if any(condition['operator'] == 'eq' for condition in conditions):
            return conditions

        # Check if there are more than one 'bt' operator
        bt_count = sum(1 for condition in conditions if condition['operator'] == 'bt')
        if bt_count > 1:
            raise ValueError("Multiple 'bt' operators are not allowed.")

        # Validate conditions for 'bt' operators based on configuration
        for condition in conditions:
            column_name = condition['column_name']
            if condition['operator'] == 'bt':
                if self._validate_bt_condition(column_name, condition['values']):
                    validated_conditions.append(condition)
            else:
                validated_conditions.append(condition)

        return validated_conditions

    def _validate_bt_condition(self, column_name, values):

        column_config = next((col for col in self.validate_between_clause['columns'] if col['column_name'] == column_name), None)
        if column_config:
            format_string = column_config['format_string']
            max_difference = column_config['max_difference']

            # Check using the data type
            if column_config['type'] == 'datetime':
                value1 = datetime.strptime(values[0], format_string)
                value2 = datetime.strptime(values[1], format_string)
                difference = abs((value2 - value1).total_seconds())

            # Check using the time type
            elif column_config['type'] == 'time':
                value1 = datetime.strptime(values[0], format_string).time()
                value2 = datetime.strptime(values[1], format_string).time()
                difference = abs((datetime.combine(datetime.min, value2) - datetime.combine(datetime.min, value1)).total_seconds())

            # Check using the numeric type
            elif column_config['type'] == 'numeric':
                value1 = float(values[0])
                value2 = float(values[1])
                difference = abs(value2 - value1)

            if difference > max_difference:
                return False

        return True
