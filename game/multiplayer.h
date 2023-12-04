#pragma once

#define ASIO_STANDALONE
#include "kernel/common/kernel_types.h"
#include <websocketpp/config/asio_no_tls.hpp>
#include <websocketpp/server.hpp>
#include "common/util/json_util.h"

using websocketpp::lib::bind;

typedef websocketpp::server<websocketpp::config::asio> server;

void start_socket();
void connect_mp_info(u64 mpInfo, u64 selfPlayerInfo, u64 teamrunInfo, u64 teamrunLevelInfo);
void clear_mp_command();
void send_position_update();
void send_repl_connection_acknowledgement();

//extern char username[101];
