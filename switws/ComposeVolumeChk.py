import os
import re
import yaml

def load_env_variables(env_file):
    env_variables = {}
    with open(env_file, 'r') as file:
        for line in file:
            if '=' in line:
                key, value = line.strip().split('=', 1)
                env_variables[key] = value
    return env_variables

def check_volume_paths(compose_file, env_variables):
    volume_paths = []
    with open(compose_file, 'r') as file:
        compose_data = yaml.safe_load(file)
        services = compose_data.get('services', {})
        for service in services.values():
            volumes = service.get('volumes', [])
            for volume in volumes:
                print(volume)
                if ':' in volume:  # Control if the volume contains a path separator
                    volume_path = volume.split(':')[0]
                    if '$' in volume_path:  # Check for placeholders in the volume path
                        placeholders = re.findall(r'\$([A-Za-z0-9_]+)', volume_path)
                        for placeholder in placeholders:
                            if placeholder in env_variables:
                                volume_path = volume_path.replace(f'${placeholder}', env_variables[placeholder])
                            else:
                                print(f"Environment variable '{placeholder}' not found in .env file.")
                                return False
                    volume_paths.append(volume_path)

    for volume_path in volume_paths:
        if not os.path.exists(volume_path):
            print(f"Path {volume_path} for volume does not exist.")
            return False
    return True

if __name__ == "__main__":
    env_file = ".env"
    compose_file = "docker-compose.yml"
    
    env_variables = load_env_variables(env_file)
    if env_variables:
        paths_exist = check_volume_paths(compose_file, env_variables)
        if paths_exist:
            print("All volume paths are valid.")
        else:
            print("One or more volume paths are invalid.")