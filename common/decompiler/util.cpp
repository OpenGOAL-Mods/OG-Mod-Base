#include "util.h"

#include "common/util/FileUtil.h"
#include "common/util/json_util.h"
#include "common/util/string_util.h"
#include "common/versions/versions.h"

// TODO - expand a list of hints (ie. a hint for defun to show at a glance how to write a function,
// or perhaps, show the docstring for the current function being used?)

namespace decompiler {
decompiler::Config load_Decompiler_config( const GameVersion game_version) {
  auto Decompiler_config_path =
      file_util::get_user_home_dir() / "OpenGOAL" / "Decompiler-config.json";
  if (file_util::file_exists(Decompiler_config_path.string())) {
    try {
      decompiler::Config config(game_version);
      auto Decompiler_config_data =
          parse_commented_json(file_util::read_text_file(Decompiler_config_path), "Decompiler-config.json");
      from_json(Decompiler_config_data, config);
      return config;
    } catch (std::exception& e) {
      decompiler::Config config(game_version);
    }
  }
  return decompiler::Config(game_version);
}
}  // namespace decompiler
