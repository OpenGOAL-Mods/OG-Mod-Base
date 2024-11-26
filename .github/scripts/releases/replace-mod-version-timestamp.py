import datetime
import json
import os
import glob
import shutil
import tarfile
import urllib.request
import zipfile
import sys

def patch_mod_timestamp(goal_src_path):
    try:
        mod_settings_files = glob.glob(f"{goal_src_path}/**/mod-settings.gc", recursive=True)
        for settings_file_path in mod_settings_files:
            file = open(settings_file_path, "r")
            file_data = file.read()
            file.close()
            # Check if the placeholder string is present in the file
            if "%MODVERSIONPLACEHOLDER%" in file_data:
                # Replace the placeholder string with the version and date string
                version_str = datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%d %H:%M:%S")
                file_data = file_data.replace("%MODVERSIONPLACEHOLDER%", version_str)
                # Write the updated content back to the mod-settings
                file = open(settings_file_path, "w")
                file.write(file_data)
                file.close()
                print(
                    f"String %MODVERSIONPLACEHOLDER% replaced with '{version_str}' in the file."
                )
            else:
                print(f"Couldn't find %MODVERSIONPLACEHOLDER% in the file.")
    except Exception as e:
        print(
            f"Something went wrong trying to replace placeholder text with mod version info:"
        )
        print(e)

if len(sys.argv) > 1:
    patch_mod_timestamp(sys.argv[1])
else:
    print(f"No goal_src path provided to replace-mod-version-timestamp")