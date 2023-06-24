import os
import shutil
import requests
import urllib.request
import zipfile

args = {
    "outputDir": os.getenv("outputDir"),
    "versionName": os.getenv("versionName"),
    "toolingVersion": os.getenv("toolingVersion"),
    "toolingBinaryDir": os.getenv("toolingBinaryDir"),
    "textureReplacementDir": os.getenv("textureReplacementDir"),
    "customLevelsDir": os.getenv("customLevelsDir"),
    "goalSourceDir": os.getenv("goalSourceDir")
}

# Create our output directory
if os.path.exists(os.path.join(args.outputDir, "windows")):
    print(
        "Expected output directory already exists, clearing it - {}".format(
            os.path.join(args.outputDir, "windows")
        )
    )
    os.rmdir(os.path.join(args.outputDir, "windows"))

os.makedirs(os.path.join(args.outputDir, "windows"), exist_ok=True)

# Download the Release
toolingVersion = args.toolingVersion
if toolingVersion == "latest":
    # Get the latest open-goal/jak-project release
    toolingVersion = requests.get(
        "https://api.github.com/repos/open-goal/jak-project/releases/latest"
    ).json()["tag_name"]
releaseAssetUrl = "https://github.com/open-goal/jak-project/releases/download/{}/opengoal-windows-{}.zip".format(
    toolingVersion, toolingVersion
)
urllib.request.urlretrieve(
    releaseAssetUrl, os.path.join(args.outputDir, "windows", "release.zip")
)

# Extract it
with zipfile.ZipFile(
    os.path.join(args.outputDir, "windows", "release.zip"), "r"
) as zip_ref:
    zip_ref.extractall(os.path.join(args.outputDir, "windows"))
os.remove(os.path.join(args.outputDir, "windows", "release.zip"))


if args.toolingBinaryDir != "":
    # User is specifying the binaries themselves, let's make sure they exist
    dir = args.toolingBinaryDir
    if (
        not os.path.exists(os.path.join(dir, "extractor.exe"))
        or not os.path.exists(os.path.join(dir, "goalc.exe"))
        or not os.path.exists(os.path.join(dir, "gk.exe"))
    ):
        print(
            "Tooling binaries not found, expecting extractor.exe, goalc.exe, and gk.exe"
        )
        exit(1)
    # Binaries are all there, let's replace 'em
    shutil.copyfile(
        os.path.join(dir, "extractor.exe"),
        os.path.join(args.outputDir, "windows", "extractor.exe"),
    )
    shutil.copyfile(
        os.path.join(dir, "goalc.exe"),
        os.path.join(args.outputDir, "windows", "goalc.exe"),
    )
    shutil.copyfile(
        os.path.join(dir, "gk.exe"), os.path.join(args.outputDir, "windows", "gk.exe")
    )

# Copy-in Mod Assets
textureReplacementDir = args.textureReplacementDir
shutil.copytree(
    textureReplacementDir,
    os.path.join(args.outputDir, "windows", "data", "texture_replacements"),
    dirs_exist_ok=True,
)

customLevelsDir = args.customLevelsDir
shutil.copytree(
    customLevelsDir,
    os.path.join(args.outputDir, "windows", "data", "custom_levels"),
    dirs_exist_ok=True,
)

goalSourceDir = args.goalSourceDir
shutil.copytree(
    goalSourceDir,
    os.path.join(args.outputDir, "windows", "data", "goal_src"),
    dirs_exist_ok=True,
)

# Rezip it up and prepare it for upload
shutil.make_archive(
    "windows-{}".format(args.versionName),
    "zip",
    os.path.join(args.outputDir, "windows"),
)
os.makedirs(os.path.join(args.outputDir, "dist"), exist_ok=True)
shutil.move(
    "windows-{}.zip".format(args.versionName),
    os.path.join(args.outputDir, "dist", "windows-{}.zip".format(args.versionName)),
)

# Cleanup
shutil.rmtree(os.path.join(args.outputDir, "windows"))
