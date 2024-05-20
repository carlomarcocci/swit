#!/bin/bash

# Directory containing configuration files
CONFIG_DIR="/etc/switws/config/conf.d/"

# Function to execute the healthcheck for each configuration file
perform_healthcheck() {
    for config_file in "$CONFIG_DIR"/*.yml; do

        endpoint="/swit/$(basename "$config_file" .yml)/status/"
        response=$(timeout 5 curl -s "http://localhost:5000$endpoint")

        # Verify if the JSON contains the 'error' field
        if echo "$response" | grep -q '"error"'; then
            # echo "Error in response for $config_file: $response"
            return 1
        fi

        stress_indicator=$(echo "$response" | jq -r '.status.stress_indicator')
        
        if [ "$(echo "$stress_indicator > 0" | bc)" -eq 1 ]; then
            # echo "Terminating long running queries for $config_file..."
            return 1
        fi
    done
}

# Execute the healthcheck
perform_healthcheck

# Process control
if [ $? -eq 0 ]; then
    # echo "Healthcheck passed."
    exit 0
else
    # echo "Healthcheck failed."
    exit 1
fi