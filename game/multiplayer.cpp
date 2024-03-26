#include "multiplayer.h"
#include "game/kernel/jak1/kscheme.h"
#include "game/kernel/common/kmachine.h"

// Custom logger
#include <common/log/log.h>

#define ASIO_STANDALONE
#include <websocketpp/common/connection_hdl.hpp>


using json = nlohmann::json;

MultiplayerInfo* gMultiplayerInfo;
RemotePlayerInfo* gSelfPlayerInfo;
TeamrunPlayerInfo* gTeamrunInfo;
TeamrunLevelInfo* gTeamrunLevelInfo;

int commandBuffer[MAX_COMMAND_COUNT] = { 0, 0, 0 };
InteractionInfo interactionBuffer[MAX_INTERACTION_BUFFER_COUNT];
bool hasInteractionsBuffered = false;

// Create a server endpoint
server ogSocket;
int socketPort;
websocketpp::connection_hdl connection;
bool isConnectedOverSocket = false;
bool isConnectedToGame = false;
bool sendConnectionAcknowledgement = true;

typedef websocketpp::server<websocketpp::config::asio> server;

using websocketpp::lib::bind;
using websocketpp::lib::placeholders::_1;
using websocketpp::lib::placeholders::_2;

typedef server::message_ptr message_ptr;

void on_open(websocketpp::connection_hdl hdl) {
  connection = hdl;
  isConnectedOverSocket = true;
  lg::warn("Client connected");

  if (isConnectedToGame) {
    gMultiplayerInfo->teamrun_command = 1;
    sendConnectionAcknowledgement = true;
    send_position_update();
  }

}

void on_close(websocketpp::connection_hdl) {
  isConnectedOverSocket = false;
  lg::warn("Client disconnected");
}

void on_fail(server* s, websocketpp::connection_hdl hdl) {
  lg::warn("Socket handler failed");
}

void on_json_message(server* s, websocketpp::connection_hdl hdl, message_ptr msg) {
  if (!isConnectedToGame)
    return;

  json response_json = json::parse(msg->get_payload());
  
  for (const auto& section : response_json.items()) {
    if (section.key().compare("command") == 0) {
      for (int i = 0; i < MAX_COMMAND_COUNT; i++) {
        if (commandBuffer[i] == 0) {
          commandBuffer[i] = section.value();
          break;
        }
      }
    } else if (section.key().compare("gameSettings") == 0) {
      for (const auto& gameField : section.value().items()) {
        if (gameField.key().compare("category") == 0) {
          gMultiplayerInfo->game.category = gameField.value();
        } else if (gameField.key().compare("mode") == 0) {
          gMultiplayerInfo->game.mode = gameField.value();
        } else if (gameField.key().compare("requireSameLevel") == 0) {
          gMultiplayerInfo->game.require_same_level = gameField.value();
        } else if (gameField.key().compare("allowSoloHubZoomers") == 0) {
          gMultiplayerInfo->game.allow_solo_hub_zoomers = gameField.value();
        } else if (gameField.key().compare("noLTS") == 0) {
          gMultiplayerInfo->game.no_lts = gameField.value();
        } else if (gameField.key().compare("citadelSkip") == 0) {
          gMultiplayerInfo->game.citadel_skip_version = gameField.value();
        } else if (gameField.key().compare("freeForAll") == 0) {
          gMultiplayerInfo->game.free_for_all = gameField.value();
        } else if (gameField.key().compare("enablePvp") == 0) {
          gMultiplayerInfo->game.enable_pvp = gameField.value();
        }
      }
    } else if (section.key().compare("selfInfo") == 0) {
      for (const auto& infoField : section.value().items()) {
        if (infoField.key().compare("teamId") == 0) {
          gSelfPlayerInfo->team_id = infoField.value();
          RemotePlayerInfo* player = &(gMultiplayerInfo->players[gMultiplayerInfo->player_num]);
          player->team_id = infoField.value();
        } else if (infoField.key().compare("playerIndex") == 0) {
          gSelfPlayerInfo->player_index = infoField.value();
          RemotePlayerInfo* player = &(gMultiplayerInfo->players[gMultiplayerInfo->player_num]);
          player->player_index = infoField.value();
        } else if (infoField.key().compare("cellsCollected") == 0) {
          gSelfPlayerInfo->cells_collected = infoField.value();
          RemotePlayerInfo* player = &(gMultiplayerInfo->players[gMultiplayerInfo->player_num]);
          player->cells_collected = infoField.value();
        }
      }
    } else if (section.key().compare("selfInteraction") == 0) {
      RemotePlayerInfo* selfPlayer = &(gMultiplayerInfo->players[gMultiplayerInfo->player_num]);
      if (selfPlayer->inter_type == 0) {
        for (const auto& interactionField : section.value().items()) {
          if (interactionField.key().compare("interType") == 0) {
            selfPlayer->inter_type = interactionField.value();
          } else if (interactionField.key().compare("interAmount") == 0) {
            selfPlayer->inter_amount = interactionField.value().get<float>();
          } else if (interactionField.key().compare("interStatus") == 0) {
            selfPlayer->inter_status = interactionField.value().get<float>();
          } else if (interactionField.key().compare("interName") == 0) {
            std::string ename = interactionField.value();
            strncpy(Ptr<String>(selfPlayer->inter_name).c()->data(), ename.c_str(), INTERACTION_STRING_LEN);
          } else if (interactionField.key().compare("interParent") == 0) {
            std::string parent = interactionField.value();
            strncpy(Ptr<String>(selfPlayer->inter_parent).c()->data(), parent.c_str(), INTERACTION_STRING_LEN);
          } else if (interactionField.key().compare("interLevel") == 0) {
            std::string level = interactionField.value();
            strncpy(Ptr<String>(selfPlayer->inter_level).c()->data(), level.c_str(), INTERACTION_STRING_LEN);
          } else if (interactionField.key().compare("interCleanup") == 0) {
            selfPlayer->inter_cleanup = interactionField.value();
          }
        }
      } else {
        lg::warn("skipped interaction, adding to buffer");
        bool hasOverflow = true;
        for (int i = 0; i < MAX_INTERACTION_BUFFER_COUNT; i++) {
          if (!interactionBuffer[i].buffered) {
            for (const auto& interaction : section.value().items()) {
              if (interaction.key().compare("interType") == 0) {
                interactionBuffer[i].inter_type = interaction.value();
              } else if (interaction.key().compare("interAmount") == 0) {
                interactionBuffer[i].inter_amount = interaction.value().get<float>();
              } else if (interaction.key().compare("interStatus") == 0) {
                interactionBuffer[i].inter_status = interaction.value().get<float>();
              } else if (interaction.key().compare("interName") == 0) {
                interactionBuffer[i].inter_name = interaction.value();
              } else if (interaction.key().compare("interParent") == 0) {
                interactionBuffer[i].inter_parent = interaction.value();
              } else if (interaction.key().compare("interLevel") == 0) {
                interactionBuffer[i].inter_level = interaction.value();
              } else if (interaction.key().compare("interCleanup") == 0) {
                interactionBuffer[i].inter_cleanup = interaction.value();
              }
            }
            interactionBuffer[i].player_id = gMultiplayerInfo->player_num;
            interactionBuffer[i].buffered = true;
            hasInteractionsBuffered = true;
            hasOverflow = false;
            break;
          }
        }
        if (hasOverflow) {
          lg::warn("Interaction buffer overflow!");
        }
      }
    } else if (section.key().compare("version") == 0) {
      std::string buildVersion = section.value();
      strncpy(Ptr<String>(gMultiplayerInfo->client_version).c()->data(), buildVersion.c_str(), INTERACTION_STRING_LEN);
    } else if (section.key().compare("username") == 0) {
      std::string username = section.value();
      strncpy(Ptr<String>(gSelfPlayerInfo->username).c()->data(), username.c_str(), MAX_USERNAME_LEN);
    } else if (section.key().compare("controllerPort") == 0) {
      pc_get_controller(section.value(), 0);
    } else if (section.key().compare("players") == 0) {
      // update player positions
      for (const auto& item : section.value().items()) {
        int playerId = stoi(item.key()) + 1; //current player not included which 0 is reserved for
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
            } else if (field.key().compare("rotY") == 0) {
              player->zoomer_rot_y = field.value().get<float>();
            } else if (field.key().compare("tgtState") == 0) {
              player->tgt_state = field.value();
            } else if (field.key().compare("mpState") == 0) {
              player->mp_state = field.value().get<float>();
            } else if (field.key().compare("currentLevel") == 0) {
              std::string levelName = field.value();
              strncpy(Ptr<String>(player->current_level).c()->data(), levelName.c_str(), INTERACTION_STRING_LEN);
            } else if (field.key().compare("interaction") == 0) {

              //check if interaction available
              if (player->inter_type == 0) {
                for (const auto& interaction : field.value().items()) {
                  if (interaction.key().compare("interType") == 0) {
                    player->inter_type = interaction.value();
                  } else if (interaction.key().compare("interAmount") == 0) {
                    player->inter_amount = interaction.value().get<float>();
                  } else if (interaction.key().compare("interStatus") == 0) {
                    player->inter_status = interaction.value().get<float>();
                  } else if (interaction.key().compare("interName") == 0) {
                    std::string ename = interaction.value();
                    strncpy(Ptr<String>(player->inter_name).c()->data(), ename.c_str(), INTERACTION_STRING_LEN);
                  } else if (interaction.key().compare("interParent") == 0) {
                    std::string parent = interaction.value();
                    strncpy(Ptr<String>(player->inter_parent).c()->data(), parent.c_str(), INTERACTION_STRING_LEN);
                  } else if (interaction.key().compare("interLevel") == 0) {
                    std::string level = interaction.value();
                    strncpy(Ptr<String>(player->inter_level).c()->data(), level.c_str(), INTERACTION_STRING_LEN);
                  } else if (interaction.key().compare("interCleanup") == 0) {
                    player->inter_cleanup = interaction.value();
                  }
                }
              } else {
                lg::warn("skipped interaction, adding to buffer");
                bool hasOverflow = true;
                for (int i = 0; i < MAX_INTERACTION_BUFFER_COUNT; i++) {
                  if (!interactionBuffer[i].buffered) {
                    for (const auto& interaction : field.value().items()) {
                      if (interaction.key().compare("interType") == 0) {
                        interactionBuffer[i].inter_type = interaction.value();
                      } else if (interaction.key().compare("interAmount") == 0) {
                        interactionBuffer[i].inter_amount = interaction.value().get<float>();
                      } else if (interaction.key().compare("interStatus") == 0) {
                        interactionBuffer[i].inter_status = interaction.value().get<float>();
                      } else if (interaction.key().compare("interName") == 0) {
                        interactionBuffer[i].inter_name = interaction.value();
                      } else if (interaction.key().compare("interParent") == 0) {
                        interactionBuffer[i].inter_parent = interaction.value();
                      } else if (interaction.key().compare("interLevel") == 0) {
                        interactionBuffer[i].inter_level = interaction.value();
                      } else if (interaction.key().compare("interCleanup") == 0) {
                        interactionBuffer[i].inter_cleanup = interaction.value();
                      }
                    }
                    interactionBuffer[i].player_id = playerId;
                    interactionBuffer[i].buffered = true;
                    hasInteractionsBuffered = true;
                    hasOverflow = false;
                    break;
                  }
                }
                if (hasOverflow) {
                  lg::warn("Interaction buffer overflow!");
                }
              }
            } else if (field.key().compare("playerInfo") == 0) {
              for (const auto& infoField : field.value().items()) {
                if (infoField.key().compare("teamId") == 0) {
                  player->team_id = infoField.value();
                } else if (infoField.key().compare("playerIndex") == 0) {
                  player->player_index = infoField.value();
                } else if (infoField.key().compare("cellsCollected") == 0) {
                  player->cells_collected = infoField.value();
                }
              }
            }
          }
        }
      }
    }
  }

  //check and fill interactions from buffer if any
  if (hasInteractionsBuffered) {
    bool hasUnclearedInteraction = false;
    for (int i = 0; i < MAX_INTERACTION_BUFFER_COUNT; i++) {
      if (interactionBuffer[i].buffered) {
        RemotePlayerInfo* player = &(gMultiplayerInfo->players[interactionBuffer[i].player_id]);
        if (player->inter_type != 0) {
          hasUnclearedInteraction = true;
        }
        else {
          player->inter_type = interactionBuffer[i].inter_type;
          player->inter_amount = interactionBuffer[i].inter_amount;
          player->inter_status = interactionBuffer[i].inter_status;
          strncpy(Ptr<String>(player->inter_name).c()->data(), interactionBuffer[i].inter_name.c_str(), INTERACTION_STRING_LEN);
          strncpy(Ptr<String>(player->inter_parent).c()->data(), interactionBuffer[i].inter_parent.c_str(), INTERACTION_STRING_LEN);
          strncpy(Ptr<String>(player->inter_level).c()->data(), interactionBuffer[i].inter_level.c_str(), INTERACTION_STRING_LEN);
          player->inter_cleanup = interactionBuffer[i].inter_cleanup;
          interactionBuffer[i].buffered = false;
        }
      }
    }
    hasInteractionsBuffered = hasUnclearedInteraction;
  }

  //check and fill command slot if any
  if (gMultiplayerInfo->teamrun_command == 0) {
    for (int i = 0; i < MAX_COMMAND_COUNT; i++) {
      if (commandBuffer[i] != 0) {
        gMultiplayerInfo->teamrun_command = commandBuffer[i];
        break;
      }
    }
  }

}


void start_socket(int port) {
  socketPort = port;
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

      // Listen on port
      ogSocket.listen(socketPort);

      // Start the server accept loop
      ogSocket.start_accept();

      lg::warn("Starting Teamrun socket on port: {}", socketPort);

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

void connect_mp_info(u64 mpInfo, u64 selfPlayerInfo, u64 teamrunInfo, u64 teamrunLevelInfo) {
  gMultiplayerInfo = Ptr<MultiplayerInfo>(mpInfo).c();
  gSelfPlayerInfo = Ptr<RemotePlayerInfo>(selfPlayerInfo).c();
  gTeamrunInfo = Ptr<TeamrunPlayerInfo>(teamrunInfo).c();
  gTeamrunLevelInfo = Ptr<TeamrunLevelInfo>(teamrunLevelInfo).c();

  lg::info("Multiplayer ready");
  isConnectedToGame = true;

  if (isConnectedOverSocket) {
    gMultiplayerInfo->teamrun_command = 1;
    sendConnectionAcknowledgement = true;
    send_position_update();
  }
}

void clear_mp_command() {
  for (int i = 0; i < MAX_COMMAND_COUNT; i++) {
    if (commandBuffer[i] == gMultiplayerInfo->teamrun_command) {
      commandBuffer[i] = 0;
      break;
    }
  }
  gMultiplayerInfo->teamrun_command = 0;
}


void send_position_update() {
  if (!isConnectedOverSocket || !isConnectedToGame)
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
      {"rotY", gSelfPlayerInfo->zoomer_rot_y},
      {"tgtState", gSelfPlayerInfo->tgt_state},
      {"interType", gSelfPlayerInfo->inter_type},
      {"interAmount", gSelfPlayerInfo->inter_amount},
      {"interStatus", gSelfPlayerInfo->inter_status},
      {"interName", Ptr<String>(gSelfPlayerInfo->inter_name).c()->data()},
      {"interParent", Ptr<String>(gSelfPlayerInfo->inter_parent).c()->data()},
      {"interLevel", Ptr<String>(gSelfPlayerInfo->inter_level).c()->data()},
      {"currentLevel", Ptr<String>(gSelfPlayerInfo->current_level).c()->data()}
      }
    }
  };

  if (gTeamrunInfo->has_state_update) {
    json_payload["state"] = {
        {"debugModeActive", gTeamrunInfo->debug_mode_active},
        {"justSpawned", gTeamrunInfo->just_spawned},
        {"justLoaded", gTeamrunInfo->just_loaded},
        {"justSaved", gTeamrunInfo->just_saved},
        {"cellCount", gTeamrunInfo->cell_count},
        {"buzzerCount", gTeamrunInfo->buzzer_count},
        {"orbCount", gTeamrunInfo->money_count},
        {"deathCount", gTeamrunInfo->death_count}
    };
  }

  if (gTeamrunLevelInfo->has_level_update) {
    json_payload["levels"] = json::array({
      {
      {"name", Ptr<String>(gTeamrunLevelInfo->level0_name).c()->data()},
      {"status", Ptr<String>(gTeamrunLevelInfo->level0_status).c()->data()}
      },
      {
      {"name", Ptr<String>(gTeamrunLevelInfo->level1_name).c()->data()},
      {"status", Ptr<String>(gTeamrunLevelInfo->level1_status).c()->data()}
      }
    });
  }

  if (sendConnectionAcknowledgement) {
    json_payload["connected"] = true;
    sendConnectionAcknowledgement = false;
  }

  try {
    ogSocket.send(connection, json_payload.dump(), websocketpp::frame::opcode::text);
  } catch (websocketpp::exception const& e) {
    lg::warn("position update failed");
  }
}
