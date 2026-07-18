from common import (
    create_output_dir,
    download_release,
    finalize_bundle,
    get_args,
    override_binaries_and_assets,
    patch_mod_timestamp_and_version_info,
)

args = get_args("windows")

print(args)

# Create our output directory
create_output_dir(args, "windows")

# Download or Build the Release
download_release(args, "windows", is_zip=True)

# Override any files
override_binaries_and_assets(args, "windows")

# Replace placeholder text with mod version and timestamp
patch_mod_timestamp_and_version_info(args, "windows")

# Rezip it up and prepare it for upload
finalize_bundle(args, "windows", is_zip=True)
