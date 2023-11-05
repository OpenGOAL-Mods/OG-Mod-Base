import json

def remove_4th_value_and_visvol(json_file):
    with open(json_file, 'r') as file:
        data = json.load(file)

    # Iterate through the JSON entries
    for entry in data:
        if "trans" in entry and len(entry["trans"]) >= 4:
            entry["trans"] = entry["trans"][:3]
        if "visvol" in entry:
            del entry["visvol"]
        if "scale" in entry:
            del entry["scale"]

    with open(json_file, 'w') as output_file:
        json.dump(data, output_file, indent=4)

def remove_visvol(json_file):
    with open(json_file, 'r') as file:
        data = json.load(file)

    # Iterate through the JSON entries
    for entry in data:
        if "lump" in entry and "visvol" in entry["lump"]:
            del entry["lump"]["visvol"]
        if "lump" in entry and "scale" in entry["lump"]:
            del entry["lump"]["scale"]

    with open(json_file, 'w') as output_file:
        json.dump(data, output_file, indent=4)

# Example usage:
jsonc_file_path = r"C:\Users\NinjaPC\Documents\Github\og-1-in-2\decompiler_out\jak1\entities\beach_actors.json"

remove_4th_value_and_visvol(jsonc_file_path)
remove_visvol(jsonc_file_path)
