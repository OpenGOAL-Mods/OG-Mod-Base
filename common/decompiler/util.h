#pragma once

#include <functional>
#include <optional>
#include <string>
#include <vector>

#include "config.h"



namespace decompiler {

struct StartupFile {
  std::vector<std::string> run_before_listen = {};
  std::vector<std::string> run_after_listen = {};
};
class Wrapper {


  Wrapper(const std::string& _username, const Configjson& config, const StartupFile& startup)
      : username(_username), Decompiler_config(config), startup_file(startup) {}
  std::string username;
  Configjson Decompiler_config;
  StartupFile startup_file;
  std::vector<std::string> examples{};
  void init_settings();




};  // namespace decompiler


decompiler::Configjson load_Decompiler_config(const std::string& username, const GameVersion game_version);
}