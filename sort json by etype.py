import json





def remove_4th_value(json_file):
    with open(json_file, 'r') as file:
        data = json.load(file)
    # Iterate through the JSON entries
    for entry in data:
        if "trans" in entry and len(entry["trans"]) >= 4:
            entry["trans"] = entry["trans"][:3]


    with open(json_file, 'w') as output_file:
        json.dump(data, output_file, indent=4)

def remove_visvol(json_file):
    with open(json_file, 'r') as file:
        data = json.load(file)

    # Iterate through the JSON entries
    for entry in data:
        if "lump" in entry and "visvol" in entry["lump"]:
            del entry["lump"]["visvol"]

    with open(json_file, 'w') as output_file:
        json.dump(data, output_file, indent=4)

# Function to sort JSON entries based on "etype" field and save to a file
def sort_and_save_json_entries(input_json_file, output_json_file):
    with open(input_json_file, 'r') as file:
        data = json.load(file)

    # Sort the entries based on the "etype" field
    sorted_data = sorted(data, key=lambda entry: entry["etype"])

    with open(output_json_file, 'w') as output_file:
        json.dump(sorted_data, output_file, indent=4)

# Provide the path to your input and output JSON files
input_json_file_path = r"C:\Users\NinjaPC\Documents\Github\OG-1-in-2\decompiler_out\jak1\entities\beach_actors.json"
output_json_file_path = input_json_file_path

# Sort the JSON entries and save to the output file
sort_and_save_json_entries(input_json_file_path, output_json_file_path)
remove_4th_value(input_json_file_path)
remove_visvol(input_json_file_path)

print(f"Sorted JSON data has been saved to {output_json_file_path}.")
