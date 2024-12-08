from common import (
    create_output_dir,
    download_release,
    finalize_bundle,
    get_args,
    override_binaries_and_assets,
    patch_mod_timestamp_and_version_info,
)

args = get_args("macos-intel")

print(args)

# Create our output directory
create_output_dir(args, "macos-intel")

# Download the Release
download_release(args, "macos-intel", is_zip=False)

# Override any files
override_binaries_and_assets(args, "macos-intel")

# Replace placeholder text with mod version and timestamp
patch_mod_timestamp_and_version_info(args, "macos-intel")

# Rezip it up and prepare it for upload
finalize_bundle(args, "macos-intel", is_zip=False)
