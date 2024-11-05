import os
import subprocess

def run_formatter_on_gc_files(root_dir):
    # Traverse all subdirectories for .gc files
    for dirpath, _, filenames in os.walk(root_dir):
        for filename in filenames:
            if filename.endswith('.gc'):
                gc_file_path = os.path.join(dirpath, filename)
                # Command to run formatter.exe with the specified arguments
                command = [
                    r"C:\Users\NinjaPC\Documents\Github\OG-Jak-The-Chicken-Reborn\out\build\Release\bin\formatter.exe",
                    "-w", "-f", gc_file_path
                ]

                # Run the command
                try:
                    subprocess.run(command, check=True)
                    print(f"Formatted: {gc_file_path}")
                except subprocess.CalledProcessError as e:
                    print(f"Error formatting {gc_file_path}: {e}")

# Specify the root directory to search for .gc files
root_directory = r"C:\Users\NinjaPC\Documents\Github\OG-Jak-The-Chicken-Reborn\goal_src\jak1"  # Replace with your target directory

#root_directory = r"C:\Users\NinjaPC\Desktop\chickenoct28\OG-Jak-The-Chicken-Reborn-main\goal_src\jak1"  # Replace with your target directory

#root_directory = r"C:\Users\NinjaPC\Desktop\chickenoct28\mod-base\OG-Mod-Base-813577b19e4a91babd52f31d53e38bf6466cbb2c\goal_src\jak1"  # Replace with your target directory
run_formatter_on_gc_files(root_directory)
