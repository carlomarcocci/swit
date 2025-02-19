import os
import re
import yaml
import sys
import json
from datetime import datetime, date, time
import logging
import markdown

class LoadConfig:

    # Set loglevel to ERROR to make it visible on the logs errors while uploading the configurations
    logging.basicConfig(level=logging.WARNING, format='%(asctime)s - %(levelname)s - %(message)s')

    default_ws_config = {
        "timeout": 120,
        "requests_per_minute": 1000,
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
        "schema": 'public',
        "allowed_tables": None,
        "allowed_functions": None,
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
                if key == 'allowed_tables' or key =='allowed_functions':
                    if not isinstance(value, list):
                        logging.debug(f"Invalid value '{value}' type for '{key}'. Setting to default.")
                        db_config[key] = LoadConfig.default_db_config[key]
                if key == 'default_size':
                    if not isinstance(value, int):
                        logging.debug(f"Invalid value '{value}' type for '{key}'. Setting to default.")
                        db_config[key] = LoadConfig.default_db_config[key]
                if key == 'schema':
                    if not isinstance(value, str):
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