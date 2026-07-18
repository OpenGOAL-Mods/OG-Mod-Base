from common import (
    create_output_dir,
    download_release,
    finalize_bundle,
    get_args,
    override_binaries_and_assets,
    patch_mod_timestamp_and_version_info,
)

args = get_args("linux")

print(args)

# Create our output directory
create_output_dir(args, "linux")

# Download the Release
download_release(args, "linux", is_zip=False)

# Override any files
override_binaries_and_assets(args, "linux")

# Replace placeholder text with mod version and timestamp
patch_mod_timestamp_and_version_info(args, "linux")

# Rezip it up and prepare it for upload
finalize_bundle(args, "linux", is_zip=False)
