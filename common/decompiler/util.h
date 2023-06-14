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

Wrapper(GameVersion version) : Decompiler_config(version) {}
  Wrapper(const std::string& _username, const Config& config, const StartupFile& startup)
      : username(_username), Decompiler_config(config), startup_file(startup) {}
  std::string username;
  Config Decompiler_config;
  StartupFile startup_file;
  std::vector<std::string> examples{};
  void init_settings();



std::string find_Decompiler_username();
StartupFile load_user_startup_file(const std::string& username, const GameVersion game_version);
Decompiler::Config load_Decompiler_config(const GameVersion game_version);
};  // namespace decompiler

}