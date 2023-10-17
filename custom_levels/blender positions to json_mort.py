import bpy
import json
import os
import re
import math


#functions

def degree_to_value(degrees):
    # Define the mapping range
    min_degree = 0
    max_degree = 360
    min_value = 4  # Value for 0 degrees
    max_value = -4  # Value for 180 degrees

    # Ensure degrees are within the mapping range
    if degrees < min_degree:
        degrees = min_degree
    elif degrees > max_degree:
        degrees = max_degree

    # Calculate the interpolated value
    value = min_value + (max_value - min_value) * (degrees - min_degree) / (max_degree - min_degree)
    return value

#globals

orb_msg = ""
orb_json = ""
cell_msg = ""
cell_json = ""
crate_msg = ""
crate_json =""
star_msg = ""
star_json =""
misc_msg = ""
misc_json =""

#Cells
# Get the collection
collection = bpy.data.collections.get("Cell Collection")
print(r"// Start automatic actors from blender")
print()
# Check if the collection exists
if collection is None:
    cell_msg = r"//Cell Collection not found"
    print(cell_msg)
    print()
else:
    # Create a list to store the positions of all objects in the collection
    positions = []

    # Get the name of the blend file without the extension
    blend_file_name = bpy.path.display_name_from_filepath(bpy.data.filepath).replace(" ", "-")
    etype = "fuel-cell"

    # Counter for generating incrementing numbers
    count = 1

    # Loop through all objects in the collection
    for obj in collection.objects:
        # Get the object's position and bounding sphere
        pos = obj.location
        bsphere = obj.bound_box

        # Create a dictionary to store the object's data
        data = {
            "trans": [pos.x, pos.z, -1 * pos.y],
            "etype": etype,
            "game_task": 117,
            "quat": [0, 0, 0, 1],
            "bsphere": [0.0, 0.0, 0.0, 0.0],
            "lump": {
                #"name": f"{blend_file_name}-{etype}-{count}",
                "name": f"{blend_file_name}-chick-{count}",
                "eco-info": ["int32", 6, 117],
                #"movie-pos": [pos.x, pos.z, -1 * pos.y],
            }
        }
        obj.name = f"{blend_file_name}-chick-{count}"
        # Increment the counter
        count += 1

        # Add the object's data to the list of positions
        positions.append(data)

    # Output the positions as JSON
    cell_msg = r"//Cells below"
    print(cell_msg)
    cell_json=(json.dumps(positions))[1:]
    cell_json = cell_json[:-1] + ","
    print(cell_json)
    print()

# Stars
# Get the collection
collection = bpy.data.collections.get("Star Collection")
# Check if the collection exists
if collection is None:
    star_msg = r"//Star Collection not found"
    print(star_msg)
    print()
else:
    # Create a list to store the positions of all objects in the collection
    positions = []

    # Get the name of the blend file without the extension
    blend_file_name = bpy.path.display_name_from_filepath(bpy.data.filepath).replace(" ", "-")
    etype = "star"

    # Counter for generating incrementing numbers
    count = 1

    # Loop through all objects in the collection
    for obj in collection.objects:
        # Get the object's position and bounding sphere
        pos = obj.location
        bsphere = obj.bound_box

        # Create a dictionary to store the object's data
        data = {
            "trans": [pos.x, pos.z, -1 * pos.y],
            "etype": etype,
            "game_task": 2,
            "quat": [0, 0, 0, 1],
            "bsphere": [0.0, 0.0, 0.0, 0.0],
            "lump": {
                "name": f"{blend_file_name}-{etype}-{count}",
                #"eco-info": ["int32", 6, 2],
                #"movie-pos": [pos.x, pos.z, -1 * pos.y],
            }
        }
        obj.name = f"{blend_file_name}-{etype}-{count}"
        # Increment the counter
        count += 1

        # Add the object's data to the list of positions
        positions.append(data)

    # Output the positions as JSON
    star_msg = r"//Stars below"
    print(star_msg)
    star_json=(json.dumps(positions))[1:]
    star_json = star_json[:-1] + ","
    print(star_json)
    print()


#Orbs
# Get the collection
collection = bpy.data.collections.get("Orb Collection")

# Check if the collection exists
if collection is None:
    orb_msg = r"//Orb Collection not found"
    print(orb_msg)
    print()
else:
    # Create a list to store the positions of all objects in the collection
    positions = []

    # Get the name of the blend file without the extension
    blend_file_name = bpy.path.display_name_from_filepath(bpy.data.filepath).replace(" ", "-")
    etype = "money"

    # Counter for generating incrementing numbers
    count = 1

    # Loop through all objects in the collection
    for obj in collection.objects:
        # Get the object's position and bounding sphere
        pos = obj.location
        bsphere = obj.bound_box

        # Create a dictionary to store the object's data
        data = {
            "trans": [pos.x, pos.z, -1 * pos.y],
            "etype": etype,
            "game_task": 0,
            "quat": [0, 0, 0, 1],
            "bsphere": [0.0, 0.0, 0.0, 0.0],
            "lump": {
                "name": f"{blend_file_name}-{etype}-{count}",
            }
        }
        obj.name = f"{blend_file_name}-{etype}-{count}"
        # Increment the counter
        count += 1

        # Add the object's data to the list of positions
        positions.append(data)

    # Output the positions as JSON
    orb_msg = r"//Orbs below"
    print(orb_msg)
    orb_json=(json.dumps(positions))[1:]
    orb_json = orb_json[:-1] + ","
    print(orb_json)
    print()
    
#Crates
# Get the collection
collection = bpy.data.collections.get("Crate Collection")

# Check if the collection exists
if collection is None:
    crate_msg = r"//Crate Collection not found"
    print(crate_msg)
    print()
else:
    # Create a list to store the positions of all objects in the collection
    positions = []

    # Get the name of the blend file without the extension
    blend_file_name = bpy.path.display_name_from_filepath(bpy.data.filepath).replace(" ", "-")
    etype = "crate"

    # Counter for generating incrementing numbers
    count = 1

    # Loop through all objects in the collection
    for obj in collection.objects:
        # Get the object's position and bounding sphere
        pos = obj.location
        bsphere = obj.bound_box

        # Create a dictionary to store the object's data
        data = {
            "trans": [pos.x, pos.z, -1 * pos.y],
            "etype": "flutflutegg",
            "game_task": 0,
            "quat": [0, 0, 0, 1],
            "bsphere": [0.0, 0.0, 0.0, 0.0],
            "scale" : ["vector",[0.2, 0.2, 0.2, 1.0]],
            "lump": {
                "name": f"{blend_file_name}-{etype}-{count}",
               "scale" : ["vector",[0.2, 0.2, 0.2, 1.0]],

            }
        }
        
        


        # Check if "yelloweco" is in the object's name
        if "yeco" in obj.name.lower():
            data["lump"]["name"] = data["lump"]["name"] + "-yeco"
            data["lump"]["crate-type"] = "'wood"
            data["lump"]["eco-info"] = ["int32", 1, 1]
            data["lump"]["eco-collectable"] = "1"
            data["lump"]["eco-quantity"] = "1"
            #data["lump"]["light-index"] = ["int32", 2]

        # Check if "yelloweco" is in the object's name
        if "reco" in obj.name.lower():
            data["lump"]["name"] = data["lump"]["name"] + "-reco"
            data["lump"]["crate-type"] = "'wood"
            data["lump"]["eco-collectable"] = "2"
            data["lump"]["eco-quantity"] = "1"
            #data["lump"]["light-index"] = ["int32", 2]

        # Check if "yelloweco" is in the object's name
        if "beco" in obj.name.lower():
            data["lump"]["name"] = data["lump"]["name"] + "-beco"
            data["lump"]["crate-type"] = "'wood"
            data["lump"]["eco-collectable"] = "3"
            data["lump"]["eco-quantity"] = "1"
            #data["lump"]["light-index"] = ["int32", 2]

        # Check if "yelloweco" is in the object's name
        if "geco" in obj.name.lower():
            data["lump"]["name"] = data["lump"]["name"] + "-geco"
            data["lump"]["crate-type"] = "'wood"
            data["lump"]["eco-collectable"] = "4"
            data["lump"]["eco-quantity"] = "1"
            #data["lump"]["light-index"] = ["int32", 2]
       
        # Check if "yelloweco" is in the object's name
        if "ieco" in obj.name.lower():
            data["lump"]["name"] = data["lump"]["name"] + "-ieco"
            data["lump"]["crate-type"] = "'wood"
            data["lump"]["eco-collectable"] = "12"
            data["lump"]["eco-quantity"] = "1"
            #data["lump"]["light-index"] = ["int32", 2]
       
        # Check if "yelloweco" is in the object's name
        if "graveco" in obj.name.lower():
            data["lump"]["name"] = data["lump"]["name"] + "-graveco"
            data["lump"]["crate-type"] = "'wood"
            data["lump"]["eco-collectable"] = "11"
            data["lump"]["eco-quantity"] = "1"
            #data["lump"]["light-index"] = ["int32", 2]
        
        # Check if "yelloweco" is in the object's name
        if "chickeco" in obj.name.lower():
            data["lump"]["name"] = data["lump"]["name"] + "-chickeco"
            data["lump"]["crate-type"] = "'wood"
            data["lump"]["eco-collectable"] = "13"
            data["lump"]["eco-quantity"] = "1"
            #data["lump"]["light-index"] = ["int32", 2]

        # Check end of crate file name for quantity
        quantity = re.search(r'(\d+)$', obj.name)
        if quantity:
            data["lump"]["eco-quantity"] = quantity.group(1)
            obj.name = data["lump"]["name"] + "-" + quantity.group(1)

        # Increment the counter
        count += 1

        # Add the object's data to the list of positions
        positions.append(data)

    # Output the positions as JSON
    crate_msg = r"//Crates below"
    print(crate_msg)
    crate_json=(json.dumps(positions))[1:]
    crate_json = crate_json[:-1] + ","
    print(crate_json)
    print()


# Misc
# Get the collection
collection = bpy.data.collections.get("Misc Collection")
# Check if the collection exists
if collection is None:
    star_msg = r"//Misc Collection not found"
    print(star_msg)
    print()
else:
    # Create a list to store the positions of all objects in the collection
    positions = []

    # Get the name of the blend file without the extension
    blend_file_name = bpy.path.display_name_from_filepath(bpy.data.filepath).replace(" ", "-")
    etype = "Buzzer" # COME BACK TO THIS WONT WORK

    # Counter for generating incrementing numbers
    count = 1

    # Loop through all objects in the collection
    for obj in collection.objects:
        # Get the object's position and bounding sphere
        pos = obj.location
        bsphere = obj.bound_box

        # Create a dictionary to store the object's data
        data = {
            "trans": [pos.x, pos.z, -1 * pos.y],
            "etype": etype,
            "game_task": 2,
            "quat": [0, 0, 0, 1],
            "bsphere": [0.0, 0.0, 0.0, 0.0],
            "lump": {
                "name": f"{blend_file_name}-{etype}-{count}",
                #"eco-info": ["int32", 6, 2],
                #"movie-pos": [pos.x, pos.z, -1 * pos.y],
            }
        }


        if "project-warpgate" in obj.name.lower():
            data["etype"] = "warpgate"
            #data["trans"] = [pos.x, pos.z, -1 * pos.y],
            data["lump"]["name"] = "project-warpgate"
            rotation_radians = obj.rotation_euler
            rotation_degrees = [math.degrees(angle) for angle in rotation_radians]
            obj.name = data["lump"]["name"] + "-rot" +str(degree_to_value(rotation_degrees[2]))
            #training part
            data2 = {
            "trans": [pos.x, (pos.z - 2.5), -1 * pos.y],
            "etype": "training-part",
            "game_task": 0,
            "quat": [0, 0, 0, 1],
            "bsphere": [0.0, 0.0, 0.0, 0.0],
            "lump": {
                "name": "project-training-part-1",
                "effect-name": "'warpgate-loop",
                "art-name":"group-training-warpgate",
                #"art-name" : str(degree_to_value(rotation_degrees[2])),
                "effect-param": ["float", 3.0000, 80.0000, 12.0000, 40.0000],
                "cycle-speed": ["float", -1.0000, 0.0000],
                "game_task": str(degree_to_value(rotation_degrees[2])),
             }
        }   
            positions.append(data2)
        
        if obj.name.lower() == "project-warp-gate-switch":
            data["etype"] = "warp-gate-switch"
            data["lump"]["name"] = "project-warp-gate-switch"
            data["game_task"] = 117
            data["lump"]["alt-actor"] = "project-training-part-1"
            obj.name = data["lump"]["name"]




        
        # Increment the counter
        count += 1

        # Add the object's data to the list of positions
        positions.append(data)
        

    # Output the positions as JSON
    misc_msg = r"//Misc below"
    print(misc_msg)
    misc_json=(json.dumps(positions))[1:]
    misc_json = misc_json[:-1] + ","
    print(misc_json)
    print()

print(r"//End automatic actors from blender")


#START DEATH PLANE STUFF



def replace_actors(file_path):
    """Replaces the actors in a file between the markers "// Start automatic actors from blender" and "//End automatic actors from blender".
    
    Args:
        file_path: The path to the file to read and write.
    
    Returns:
        None.
    """
    
    with open(file_path, "r") as f:
        data = f.read()
    
    start_marker = "// Start automatic actors from blender"
    end_marker = "//End automatic actors from blender"
    
    start_index = data.find(start_marker)
    end_index = data.find(end_marker)
    
    if start_index == -1 or end_index == -1:
        print("Could not find the start or end marker in the file.")
        return
    
    custom_input = {
        "name": "my_cusom_actor",
        "etype": "money",
        "game_task": 0,
        "trans": [100, 200, 300],
        "quat": [1, 0, 0, 0],
        "bsphere": [10, 10, 10],
        "lump": {"name": "my_custom_lump"}
    }
    
    output = start_marker + "\n" + orb_msg + "\n" + orb_json + "\n" + cell_msg + "\n" + star_msg + "\n" + star_json + "\n" + cell_json + "\n" + crate_msg + "\n" + crate_json  + "\n" + misc_msg + "\n" + misc_json + "\n" +end_marker

    # Find the last comma and its index
    last_comma_index = output.rfind(",")

    if last_comma_index != -1:
        # Remove the last comma
        output = output[:last_comma_index] + output[last_comma_index + 1:]

    new_data = data[:start_index] + output + data[end_index + len(end_marker):]
    
    with open(file_path, "w") as f:
        f.write(new_data)


blend_file_path = bpy.data.filepath
jsonc_file_path = blend_file_path.rsplit('.', 1)[0] + '.jsonc'
replace_actors(jsonc_file_path)


# Define the path to the glb models
glb_model_path = r"C:\Users\NinjaPC\AppData\Roaming\Blender Foundation\Blender\3.2\scripts\addons\OpenMaya\actorsa"

# Define the mapping of etype to glb model filenames
model_mapping = {
    "fuel-cell": "fuel.glb",
    "money": "money.glb",
    "crate": "crate-wood.glb",
}

# Function to check if a file exists in the glb model path
def glb_file_exists(filename):
    return os.path.exists(os.path.join(glb_model_path, filename))

# Function to replace the model of an object while preserving its properties
def replace_object_model(obj, glb_filename, new_collection):
    # Store object properties
    obj_name = obj.name
    obj_location = obj.location.copy()

    # Remove the old object
    bpy.data.objects.remove(obj, do_unlink=True)

    if glb_file_exists(glb_filename):
        # Create a new object with the glb model
        bpy.ops.import_scene.gltf(filepath=os.path.join(glb_model_path, glb_filename))
        new_obj = bpy.context.selected_objects[0]

        # Set properties of the new object based on the old object
        new_obj.name = obj_name
        new_obj.location = obj_location

        # Link the new object to the specified collection
        # Remove the new object link to the main scene too
        new_collection.objects.link(new_obj)
        bpy.context.scene.collection.objects.unlink(new_obj)
        return new_obj

# Cells
cell_collection = bpy.data.collections.get("Cell Collection")
if cell_collection:
    objects_to_replace = list(cell_collection.objects)
    for obj in objects_to_replace:
        glb_filename = model_mapping.get("fuel-cell", "")
        if glb_filename and glb_file_exists(glb_filename):
            replace_object_model(obj, glb_filename, cell_collection)

# Orbs
orb_collection = bpy.data.collections.get("Orb Collection")
if orb_collection:
    for obj in list(orb_collection.objects):  # Iterate through a copy of the objects
        glb_filename = model_mapping.get("money", "")
        if glb_filename and glb_file_exists(glb_filename):
            replace_object_model(obj, glb_filename, orb_collection)
            
# Star
star_collection = bpy.data.collections.get("Star Collection")
if star_collection:
    for obj in list(star_collection.objects):  # Iterate through a copy of the objects
        glb_filename = model_mapping.get("crate", "")
        if glb_filename and glb_file_exists(glb_filename):
            replace_object_model(obj, glb_filename, star_collection)

# Crates
crate_collection = bpy.data.collections.get("Crate Collection")
if crate_collection:
    for obj in list(crate_collection.objects):  # Iterate through a copy of the objects
        glb_filename = model_mapping.get("crate", "")
        if glb_filename and glb_file_exists(glb_filename):
            replace_object_model(obj, glb_filename, crate_collection)