import bpy
import json
import os


#Cells
# Get the collection
collection = bpy.data.collections.get("Cell Collection")
print(r"// Start automatic actors from blender")
print()
# Check if the collection exists
if collection is None:
    print(r"//Cell Collection not found")
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
            "game_task": 2,
            "quat": [0, 0, 0, 1],
            "bsphere": [0.0, 0.0, 0.0, 0.0],
            "lump": {
                "name": f"{blend_file_name}-{etype}-{count}",
                "eco-info": ["int32", 6, 2],
                #"movie-pos": [pos.x, pos.z, -1 * pos.y],
            }
        }

        # Increment the counter
        count += 1

        # Add the object's data to the list of positions
        positions.append(data)

    # Output the positions as JSON
    print(r"//Cells below")
    print(json.dumps(positions))
    print()


#Orbs
# Get the collection
collection = bpy.data.collections.get("Orb Collection")

# Check if the collection exists
if collection is None:
    print(r"//Orb Collection not found")
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

        # Increment the counter
        count += 1

        # Add the object's data to the list of positions
        positions.append(data)

    # Output the positions as JSON
    print(r"//Orbs below")
    print(json.dumps(positions))
    print()
    
#Crates
# Get the collection
collection = bpy.data.collections.get("Crate Collection")

# Check if the collection exists
if collection is None:
    print(r"//Crate Collection not found")
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
            "etype": etype,
            "game_task": 0,
            "quat": [0, 0, 0, 1],
            "bsphere": [0.0, 0.0, 0.0, 0.0],
            "lump": {
                "name": f"{blend_file_name}-{etype}-{count}",
            }
        }

        # Increment the counter
        count += 1

        # Add the object's data to the list of positions
        positions.append(data)

    # Output the positions as JSON
    print(r"//Crates below")
    print(json.dumps(positions))
    print()
    
print(r"//End automatic actors from blender")



# Define the path to the glb models
glb_model_path = r"C:\Users\NinjaPC\AppData\Roaming\Blender Foundation\Blender\3.2\scripts\addons\OpenMaya\actorsa"

# Define the mapping of etype to glb model filenames
model_mapping = {
    "fuel-cell": "fuel.glb",
    "money": "money.glb",
    "crate": "crate-wood.glb",
}
# Function to replace the model of an object while preserving its properties
def replace_object_model(obj, glb_filename, new_collection):
    # Store object properties
    obj_name = obj.name
    obj_location = obj.location.copy()

    # Remove the old object
    bpy.data.objects.remove(obj, do_unlink=True)

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
        glb_filename = model_mapping["fuel-cell"]
        replace_object_model(obj, glb_filename, cell_collection)

# Orbs
orb_collection = bpy.data.collections.get("Orb Collection")
if orb_collection:
    for obj in list(orb_collection.objects):  # Iterate through a copy of the objects
        glb_filename = model_mapping["money"]
        replace_object_model(obj, glb_filename, orb_collection)


# Crates
crate_collection = bpy.data.collections.get("Crate Collection")
if crate_collection:
    for obj in crate_collection.objects:
        etype = obj.get("etype")
        if etype in model_mapping:
            glb_filename = model_mapping[etype]
            replace_object_model(obj, glb_filename, crate_collection)

