#pragma once

#include "common/common_types.h"

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
struct RemotePlayerInfo {
  u32 username; // string (basic)
  u32 color;  // tgt-color enum
  float trans_x;
  float trans_y;
  float trans_z;
  float quat_x;
  float quat_y;
  float quat_z;
  float quat_w;
  u32 tgt_state;
  u32 mp_state;  // mp-tgt-state enum
};

struct TeamrunPlayerInfo {
  s32 has_state_update;
  s32 debug_mode_active;
  u32 current_level;       // string (basic)
  u32 current_checkpoint;  // string (basic)
  s32 on_zoomer;
  s32 just_spawned;
  int cell_count;
  int death_count;

  //task updates
  s32 has_task_update;
  u32 task_name;          // string (basic)
  u32 task_status;        // string (basic)

  //buzzer updates
  s32 has_buzzer_update;
  int buzzer_id;
  u32 buzzer_container_ename;          // string (basic)

  //money updates
  s32 has_money_update;
  u32 money_ename;          // string (basic)

  //shared update data
  u32 collectable_level_name;          // string (basic)
};

const int MAX_MULTIPLAYER_COUNT = 20;

struct MultiplayerInfo {
  s32 player_num;
  RemotePlayerInfo players[MAX_MULTIPLAYER_COUNT];
};
