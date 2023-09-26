#include "multiplayer.h"
#include "game/kernel/jak1/kscheme.h"

// Custom logger
#include <common/log/log.h>

#define ASIO_STANDALONE
#include <websocketpp/common/connection_hdl.hpp>


using json = nlohmann::json;

MultiplayerInfo* gMultiplayerInfo;
RemotePlayerInfo* gSelfPlayerInfo;
TeamrunPlayerInfo* gTeamrunInfo;

// Create a server endpoint
server ogSocket;
websocketpp::connection_hdl connection;
bool isConnected = false;

typedef websocketpp::server<websocketpp::config::asio> server;

using websocketpp::lib::bind;
using websocketpp::lib::placeholders::_1;
using websocketpp::lib::placeholders::_2;

typedef server::message_ptr message_ptr;

void on_open(websocketpp::connection_hdl hdl) {
  connection = hdl;
  isConnected = true;
  lg::warn("Client connected");
}

void on_close(websocketpp::connection_hdl) {
  isConnected = false;
  lg::warn("Client disconnected");
}

void on_fail(server* s, websocketpp::connection_hdl hdl) {
  lg::warn("Socket handler failed");
}

void on_json_message(server* s, websocketpp::connection_hdl hdl, message_ptr msg) {
  json response_json = json::parse(msg->get_payload());

  // update player positions
  for (const auto& item : response_json.items()) {
    int playerId = stoi(item.key());
    if (playerId < MAX_MULTIPLAYER_COUNT && playerId != gMultiplayerInfo->player_num) {
      RemotePlayerInfo* player = &(gMultiplayerInfo->players[playerId]);

      for (const auto& field : item.value().items()) {
        if (field.key().compare("username") == 0) {
          std::string username = field.value();
          strncpy(Ptr<String>(player->username).c()->data(), username.c_str(), MAX_USERNAME_LEN);
        } else if (field.key().compare("color") == 0) {
          player->color = field.value().get<float>();
        } else if (field.key().compare("transX") == 0) {
          player->trans_x = field.value().get<float>();
        } else if (field.key().compare("transY") == 0) {
          player->trans_y = field.value().get<float>();
        } else if (field.key().compare("transZ") == 0) {
          player->trans_z = field.value().get<float>();
        } else if (field.key().compare("quatX") == 0) {
          player->quat_x = field.value().get<float>();
        } else if (field.key().compare("quatY") == 0) {
          player->quat_y = field.value().get<float>();
        } else if (field.key().compare("quatZ") == 0) {
          player->quat_z = field.value().get<float>();
        } else if (field.key().compare("quatW") == 0) {
          player->quat_w = field.value().get<float>();
        } else if (field.key().compare("tgtState") == 0) {
          player->tgt_state = field.value();
        } else if (field.key().compare("mpState") == 0) {
          player->mp_state = field.value().get<float>();
        }
      }
    }
  }
}


void start_socket() {
  std::thread([]() {
    try {
      // Set logging settings
      ogSocket.clear_access_channels(websocketpp::log::alevel::all);
      ogSocket.set_access_channels(websocketpp::log::alevel::connect);

      // For debugging Use
      //ogSocket.set_access_channels(websocketpp::log::alevel::all);
      //ogSocket.clear_access_channels(websocketpp::log::alevel::frame_payload);

      // Initialize ASIO
      ogSocket.init_asio();

      // Register message handler
      ogSocket.set_message_handler(bind(&on_json_message, &ogSocket, ::_1, ::_2));

      ogSocket.set_fail_handler(bind(&on_fail, &ogSocket, ::_1));
      ogSocket.set_open_handler(&on_open);
      ogSocket.set_close_handler(&on_close);

      // Listen on port 8111
      ogSocket.listen(8111);

      // Start the server accept loop
      ogSocket.start_accept();

      lg::info("Starting Teamrun socket on port: 9002");

      // Start the ASIO io_service run loop
      ogSocket.run();
    } catch (websocketpp::exception const& e) {
      lg::warn(e.what());
      std::cout << e.what() << std::endl;
    } catch (const std::exception& e) {
      lg::warn(e.what());
    } catch (...) {
      lg::warn("Socket error");
    }
  }).detach();
}

void connect_mp_info(u64 mpInfo, u64 selfPlayerInfo, u64 teamrunInfo) {
  gMultiplayerInfo = Ptr<MultiplayerInfo>(mpInfo).c();
  gSelfPlayerInfo = Ptr<RemotePlayerInfo>(selfPlayerInfo).c();
  gTeamrunInfo = Ptr<TeamrunPlayerInfo>(teamrunInfo).c();
  lg::info("Multiplayer ready");
}


void send_position_update(bool includeState) {
  if (!isConnected)
    return;

  // Construct JSON payload
  json json_payload = {
    {"position", {
      {"transX", gSelfPlayerInfo->trans_x},
      {"transY", gSelfPlayerInfo->trans_y},
      {"transZ", gSelfPlayerInfo->trans_z},
      {"quatX", gSelfPlayerInfo->quat_x},
      {"quatY", gSelfPlayerInfo->quat_y},
      {"quatZ", gSelfPlayerInfo->quat_z},
      {"quatW", gSelfPlayerInfo->quat_w},
      {"tgtState", gSelfPlayerInfo->tgt_state}
      }
    }
  };

  if (includeState) {
    json_payload["state"] = {
        {"debugModeActive", gTeamrunInfo->debug_mode_active},
        {"currentLevel", Ptr<String>(gTeamrunInfo->current_level).c()->data()},
        {"currentCheckpoint", Ptr<String>(gTeamrunInfo->current_checkpoint).c()->data()},
        {"onZoomer", gTeamrunInfo->on_zoomer},
        {"justSpawned", gTeamrunInfo->just_spawned},
        {"cellCount", gTeamrunInfo->cell_count},
        {"deathCount", gTeamrunInfo->death_count}
    };
  }

  if (gTeamrunInfo->has_task_update) {
    json_payload["task"] = {
      {"name", Ptr<String>(gTeamrunInfo->task_name).c()->data()},
      {"status", Ptr<String>(gTeamrunInfo->task_status).c()->data()}
    };
  }

  try {
    ogSocket.send(connection, json_payload.dump(), websocketpp::frame::opcode::text);
  } catch (websocketpp::exception const& e) {
    lg::warn("position update failed");
  }
}
