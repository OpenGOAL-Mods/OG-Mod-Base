# Simple script to emit a metadata.json file with the relevant mod information
# Values are passed in as environment variables
from datetime import datetime
import json
import os

def split_comma_sep_val(str):
    if "," not in str:
        return [str]
    return str.split(",")

# Validate supported games list
games = split_comma_sep_val(os.getenv("SUPPORTED_GAMES"))
if len(games) == 0:
    print("SUPPORTED_GAMES list is empty")
    exit(1)
for game in games:
    if game != "jak1" and game != "jak2" and game != "jak3" and game != "jakx":
        print("SUPPORTED_GAMES contains invalid game: ", game)
        exit(1)

# Input has been validated, create metadata.json
metadata = {
    "schemaVersion": os.getenv("SCHEMA_VERSION"),
    "version": os.getenv("VERSION").removeprefix("v"),
    "supportedGames": games,
    "publishedDate": datetime.now().isoformat(),
}

with open("{}/metadata.json".format(os.getenv("OUT_DIR")), "w", encoding="utf-8") as f:
    print(
        "Writing the following metadata: {}".format(
            json.dumps(metadata, indent=2, ensure_ascii=False)
        )
    )
    f.write(json.dumps(metadata, indent=2, ensure_ascii=False))
