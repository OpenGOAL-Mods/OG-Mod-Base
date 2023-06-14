#pragma once

#include <optional>
#include <string>
#include <unordered_map>
#include <vector>

#include "common/versions/versions.h"

#include "third-party/json.hpp"

using json = nlohmann::json;

namespace decompiler {
struct Config {
  GameVersion game_version;
  Config(GameVersion _game_version) : game_version(_game_version){};

  // this is the default REPL configuration
  std::string game_version_folder;
  std::vector<std::string> iso_file_dirs = {};
  bool append_keybinds = true;
void to_json(json& j, const Config& obj);
void from_json(const json& j, Config& obj);
};
}  // namespace REPL
