#pragma once

#include "common/common_types.h"
#include <string>

//! Mirror of cpad-info
#pragma pack(push, 1)
struct CPadInfo {
  u8 valid;
  u8 status;
  u16 button0;
  u8 rightx;
  u8 righty;
  u8 leftx;
  u8 lefty;
  u8 abutton[12];
  u8 dummy[12];
  s32 number;
  s32 cpad_file;
  u32 button0_abs[3];
  u32 button0_shadow_abs[1];
  u32 button0_rel[3];
  float stick0_dir;
  float stick0_speed;
  s32 new_pad;
  s32 state;
  u8 align[6];
  u8 direct[6];
  u8 buzz_val[2];
  u8 buzz_pause_val[1];
  u8 buzz_pause_time;
  u64 buzz_time[2];
  u32 buzz;
  s32 buzz_act;
  s64 change_time;  // actually u64 in goal!
};
// static_assert(offsetof(CPadInfo, number) == 32, "CPadInfo number field is wrong");
static_assert(sizeof(CPadInfo) == 132, "CPadInfo size is wrong");
#pragma pack(pop)

struct FileStream {
  u32 flags;
  u32 mode;  // basic
  u32 name;  // basic
  s32 file;  // int32
};

const int MAX_USERNAME_LEN = 100;
const int NOTIFIFCATION_STRING_LEN = 100;
const int INTERACTION_STRING_LEN = 32;
struct RemotePlayerInfo {
  u32 username;           // string (basic)
  s32 color;              // tgt-color enum
  float trans_x;
  float trans_y;
  float trans_z;
  float quat_x;
  float quat_y;
  float quat_z;
  float quat_w;
  
  float zoomer_rot_y;

  s32 inter_type;
  float inter_amount;
  float inter_status;
  u32 inter_name;         // string (basic)
  u32 inter_parent;       // string (basic)
  u32 inter_level;        // string (basic)
  s32 inter_cleanup;      // 0 or 1 (bool)

  u32 current_level;
  u32 tgt_state;
  s32 mp_state;           // mp-tgt-state enum
  s32 mp_state_check;     // mp-tgt-state enum (only used on goal side)
  
  s32 cells_collected;
  s32 player_index;
  s32 team_id;
};

struct InteractionInfo {
  bool buffered;
  s32 player_id;
  u32 inter_type;
  float inter_amount;
  float inter_status;
  std::string inter_name;
  std::string inter_parent;
  std::string inter_level;
  s32 inter_cleanup;      // 0 or 1 (bool)
};

struct TeamrunPlayerInfo {
  s32 has_state_update;
  s32 debug_mode_active;
  s32 just_spawned;
  s32 just_loaded;
  s32 just_saved;
  s32 current_continue;
  s32 cell_count;
  s32 buzzer_count;
  s32 money_count;
  s32 death_count;
};

struct TeamrunLevelInfo {
  s32 has_level_update;
  
  u32 level0_name;      // string (basic)
  u32 level0_status;    // string (basic)

  u32 level1_name;      // string (basic)
  u32 level1_status;    // string (basic)
};

struct GameMode {
  s32 category;
  s32 mode;
  s32 require_same_level;
  s32 allow_solo_hub_zoomers;
  s32 no_lts;
  s32 citadel_skip_version;
  s32 free_for_all;
  s32 enable_pvp;
};

struct TimerInfo {
  s32 hours;
  s32 minutes;
  s32 seconds;
  s32 milliseconds;
  u32 split_time;      // string (basic)
  u32 split_name;      // string (basic)
  u32 split_player;    // string (basic)
  u32 split_timesave;  // string (basic)
};

struct NotificationInfo {
  s32 has_notif;
  u32 message;      // string (basic)
  s32 time;
};

const int MAX_MULTIPLAYER_COUNT = 20;
const int MAX_COMMAND_COUNT = 3;
const int MAX_INTERACTION_BUFFER_COUNT = 20;

struct MultiplayerInfo {
  u32 teamrun_command;
  u32 force_continue;       // string (basic)
  u32 client_version;       // string (basic)
  s32 player_num;
  RemotePlayerInfo players[MAX_MULTIPLAYER_COUNT];
  GameMode game;
  TimerInfo timer;
  NotificationInfo notification;
};
