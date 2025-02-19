from flask_caching import Cache
from forms import LoadConfig
import logging

# Load the ws general configuration and set the cache
logging.getLogger('LoadConfig').setLevel(logging.ERROR)
ws_config = LoadConfig.load_ws_config('ws_configuration')                          # Load configuration file to control the execution of each step

if ws_config['loglevel'] == 'debug':
    logging.getLogger('LoadConfig').setLevel(logging.DEBUG)                        # Allowing printing the messages for loading of db config files

cache = Cache(config=ws_config['cache_config']) 								   # Init the Cache object with the configured cache system