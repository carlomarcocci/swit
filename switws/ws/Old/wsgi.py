from switws import app
from forms import LoadConfig
from gunicorn.app.base import BaseApplication
from urllib.parse import parse_qs
import multiprocessing
from urllib.parse import parse_qs

def on_starting(server):
    # Print debug message on reloading
    server.log.debug("Loaded WS configuration:")

    for conf in list(ws_config):
        server.log.debug(f'   {conf}: {ws_config[conf]}')

def on_reload(server):
    # Print debug message on reloading
    server.log.debug("Reloading workers...")

def worker_int(worker):
    # Print debug message on worker init
    worker.log.debug("Worker received SIGINT or SIGQUIT")

def pre_request(worker, req):
    # Print debug message pre requests
    worker.log.debug("Processing request: %s %s" % (req.method, req.path))
    
    # Print the body of GET request
    if req.method == 'GET' and req.body:
        worker.log.debug("Request GET data: %s" % req.body)

def post_request(worker, req, environ, resp):
    # Print debug message post request
    worker.log.debug("Request processed successfully")

    # Log additional details (status code, response length, etc.)
    worker.log.debug("Response Status Code: %s" % resp.status)
    worker.log.debug("Response Content Length: %s" % resp.response_length)    
    worker.log.debug("Response Headers: %s" % resp.headers)    

if __name__ == "__main__":

    # Load configuration file to control the execution of each step
    ws_config = LoadConfig.load_ws_config('ws_configuration')

    def number_of_workers():
        return (multiprocessing.cpu_count() * 2) + 1    

    class StandaloneApplication(BaseApplication):
        def __init__(self, app, options=None):
            self.options = options or {}
            self.application = app
            super(StandaloneApplication, self).__init__()

        def load_config(self):
            config = {key: value for key, value in self.options.items()
                      if key in self.cfg.settings and value is not None}
            for key, value in config.items():
                self.cfg.set(key.lower(), value)

        def load(self):
            return self.application

    options = {
        'bind': '0.0.0.0:5000',
        'workers': number_of_workers() if not ws_config.get('workers') else ws_config['workers'],
        'loglevel': 'debug' if not ws_config.get('loglevel') else ws_config['loglevel'],
        'timeout': ws_config['timeout'],
        'debug': False,
        'daemon': True,
        'accesslog': '-',
        'reload': True,
        'on_starting': on_starting,
        'on_reload': on_reload,
        'worker_int': worker_int,
        'pre_request': pre_request,
        'post_request': post_request        
    }

    StandaloneApplication(app, options).run()