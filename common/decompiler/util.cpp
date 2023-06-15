#include "util.h"

#include "common/util/FileUtil.h"
#include "common/util/json_util.h"
#include "common/util/string_util.h"
#include "common/versions/versions.h"

// TODO - expand a list of hints (ie. a hint for defun to show at a glance how to write a function,
// or perhaps, show the docstring for the current function being used?)

namespace decompiler {

decompiler::Configjson load_decompiler_config(const std::string& username, const GameVersion game_version) {
  auto decompiler_config_path =
      file_util::get_user_home_dir() / "openGOAL" / "decompiler-config.json";
  if (file_util::file_exists(decompiler_config_path.string())) {
    try {
      decompiler::Configjson config(game_version);
      auto decompiler_config_data =
          parse_commented_json(file_util::read_text_file(decompiler_config_path), "decompiler-config.json");
      from_json(decompiler_config_data, config);
      return config;
    } catch (std::exception& e) {
      decompiler::Configjson config(game_version);
    }
  }
  return decompiler::Configjson(game_version);
}

} // namespace decompiler

