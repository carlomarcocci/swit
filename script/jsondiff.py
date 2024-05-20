import json
import sys
from deepdiff import DeepDiff

# Requirements:
# pip install deepdiff

# Usage:
# python3 JsonDiff.py /path/to/json1.json /path/to/json2.json 

def compare_json(file1_path, file2_path):
    # Read the content of the JSON files
    with open(file1_path, 'r') as file1:
        json_data1 = json.load(file1)
    with open(file2_path, 'r') as file2:
        json_data2 = json.load(file2)
    # Compare the JSON files
    diff = DeepDiff(json_data1, json_data2, ignore_order=True)
    # Verify if there any difference
    if not diff:
        # print("The two JSON files have the same content.")
        return 0
    else:
        # print("The two json files have not the same content. Here the differences:")
        # print(diff)
        return 1

if __name__ == "__main__":
    # Ensure that the arguments are two
    if len(sys.argv) != 3:
        print("Usage: python script.py file1.json file2.json")
        sys.exit(1)
    
    # Absolute path of the JSON files
    file1_path = sys.argv[1]
    file2_path = sys.argv[2]

    # Compare the JSON files and exit with the code 0 or 1
    sys.exit(compare_json(file1_path, file2_path))
