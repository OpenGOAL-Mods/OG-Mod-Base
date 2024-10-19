import json
import os
from tkinter import Tk, filedialog

# Known valid fields and their expected sizes for "skill" types
VALID_FIELDS_FOR_SKILL = {
    "aid": None,  # No size validation, just needs to exist
    "etype": None,  # No size validation
    "name": None,  # No size validation
    "trans": 3,  # Expecting a 3D vector
    "quat": 4,  # Expecting a quaternion (4D vector)
    "vis-dist": None,  # No size validation, should be a float or int
    "scale": 4  # Expecting a 4D scale vector
}

# Function to "teach" the program about known types
KNOWN_TYPES = {"money"}  # Add known types here

def validate_field(field_name, value):
    """Validate a field based on its expected size (if applicable)."""
    expected_size = VALID_FIELDS_FOR_SKILL.get(field_name)

    # Handle special case for "trans" where we skip the 4th value if it exists
    if field_name == "trans" and isinstance(value, list):
        if len(value) == 4:
            print(f"Truncating trans field: {value} -> {value[:3]}")
            return value[:3]  # Return only the first 3 elements
        elif len(value) == 3:
            return value  # Keep it as is if it already has 3 elements
        else:
            print(f"Error: Field 'trans' has an invalid size: {value}. Expected size: 3.")
            return None  # Invalid, skip this actor

    # Regular validation for fields with specific sizes
    if expected_size is not None:
        if not isinstance(value, list) or len(value) != expected_size:
            print(f"Error: Field '{field_name}' has an invalid size or type: {value}. Expected size: {expected_size}.")
            return None  # Return None to indicate invalid field
    return value

def validate_actor_fields(lump):
    """Validate each field of the actor to ensure it's structured correctly."""
    for field, expected_size in VALID_FIELDS_FOR_SKILL.items():
        if field in lump:
            new_value = validate_field(field, lump[field])
            if new_value is None:
                return False  # Invalid field, skip this actor
            lump[field] = new_value  # Update the field with its validated/truncated value
    return True

def process_lump(lump, etype):
    """Process the lump field, extracting valid fields if it's a skill."""
    if etype == "skill":
        # Only keep valid fields for skill type and validate their sizes
        valid_lump = {key: value for key, value in lump.items() if key in VALID_FIELDS_FOR_SKILL}
        if validate_actor_fields(valid_lump):
            return valid_lump
        else:
            print(f"Skipping lump due to invalid field sizes: {lump}")
            return None  # Invalid lump, return None to skip this actor
    return lump

def process_actor(actor):
    """Process each actor entry, only if etype is 'money', skipping visvol."""
    etype = actor.get("etype", "unknown")

    # Only process if etype is "money"
    if etype != "money":
        return None  # Skip processing for actors that are not money

    lump = actor.get("lump", {})

    # Remove visvol from lump if it exists
    if "visvol" in lump:
        del lump["visvol"]  # Skip visvol

    # Validate and handle "trans" explicitly, ensuring it only has 3 elements
    if "trans" in actor:
        actor["trans"] = validate_field("trans", actor["trans"])

    # Validate vector sizes (trans is expected to have 3 elements, quat typically has 4)
    if etype not in KNOWN_TYPES:
        # Handle unknown types
        actor["etype"] = "skill"  # Change to skill type
        actor["lump"]["name"] = actor["lump"].get("name", "") + "-UNKNOWN"  # Append -UNKNOWN
        actor["lump"] = process_lump(actor["lump"], "skill")  # Process lump for skill type

        if actor["lump"] is None:
            print(f"Skipping actor with aid {actor['aid']} due to invalid fields.")
            return None  # Invalid actor, return None to skip it

    return actor


def generate_levelc_jsonc(input_file):
    """Generate the levelc.jsonc file from the level-actors file."""
    # Read the input file
    with open(input_file, 'r') as infile:
        actors = json.load(infile)

    # Process the actors
    processed_actors = [process_actor(actor) for actor in actors if process_actor(actor)]

    # Generate the output file path (next to input file)
    output_file = os.path.join(os.path.dirname(input_file), 'levelc.jsonc')

    # Write the output file
    with open(output_file, 'w') as outfile:
        json.dump(processed_actors, outfile, indent=2)

    return output_file

# Setup tkinter to prompt for file selection
def select_input_file():
    """Open file dialog to select the input file."""
    root = Tk()
    root.withdraw()  # Hide the main window
    file_path = filedialog.askopenfilename(title="Select the level-actors file",
                                           filetypes=[("JSON Files", "*.json")])
    return file_path

# Main function to run the script
if __name__ == "__main__":
    input_file = select_input_file()
    if input_file:
        output_file = generate_levelc_jsonc(input_file)
        print(f"Processed level actors saved to {output_file}")
    else:
        print("No file selected.")