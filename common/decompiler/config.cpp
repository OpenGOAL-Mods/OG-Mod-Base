#include "config.h"

#include "common/versions/versions.h"

#include "third-party/fmt/core.h"

namespace decompiler {
void to_json(json& j, const Configjson& obj) {
  j = json{
      {"gameVersionFolder", obj.game_version_folder},
      {"iso_file_dirs", obj.iso_file_dirs},
  };
}

void from_json(const json& j, Configjson& obj) {
  if (j.contains("gameVersionFolder")) {
    j.at("gameVersionFolder").get_to(obj.game_version_folder);
  }
  if (j.contains("iso_file_dirs")) {
    j.at("iso_file_dirs").get_to(obj.iso_file_dirs);
  }
    
  
  // if there is game specific configuration, override any values we just set
  if (j.contains(version_to_game_name(obj.game_version))) {
    from_json(j.at(version_to_game_name(obj.game_version)), obj);
  }
}
}


  // namespace REPL
