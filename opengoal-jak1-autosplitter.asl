state("gk") {
  // nothing to do here; we need to grab the pointers ourselves instead of hardcoding them
}

// Runs once, the only place you can add custom settings, before the process is connected to!
startup {
  // NOTE: Enable Log Output
  Action<string, bool> DebugOutput = (text, setting) => {
    if (setting) {
      print("[OpenGOAL-Jak1] " + text);
    }
  };
  vars.DebugOutput = DebugOutput;

  Action<List<Dictionary<String, dynamic>>, string, int, Type, dynamic, bool, string, bool> AddOption = (list, id, offset, type, splitVal, defaultEnabled, name, debug) => {
    var d = new Dictionary<String, dynamic>();
    d.Add("id", id);
    d.Add("offset", offset);
    d.Add("type", type);
    d.Add("splitVal", splitVal);
    d.Add("defaultEnabled", defaultEnabled);
    d.Add("name", name);
    d.Add("debug", debug);
    list.Add(d);
  };

  Action<dynamic, string> AddToSettings = (options, parent) => {
    foreach (Dictionary<String, dynamic> option in options) {
      settings.Add(option["id"], option["defaultEnabled"], option["name"], parent);
    }
  };

  settings.Add("asl_settings", true, "Autosplitter Settings");
  settings.Add("asl_settings_debug", false, "Enable Debug Logs", "asl_settings");

  vars.optionLists = new List<List<Dictionary<String, dynamic>>>();

  // // Per-level All Orbs Splits
  // settings.Add("jak1_level_all_orbs", true, "All Orbs per level");
  // vars.allOrbs = new List<Dictionary<String, dynamic>>();

  // AddOption(vars.allOrbs, "training_num_orbs", 12, typeof(byte), 50, false, "Geyser Rock - All Orbs", false);
  // AddOption(vars.allOrbs, "village1_num_orbs", 13, typeof(byte), 50, false, "Sandover Village - All Orbs", false);
  // AddOption(vars.allOrbs, "beach_num_orbs", 14, typeof(byte), 150, false, "Sentinel Beach - All Orbs", false);
  // AddOption(vars.allOrbs, "jungle_num_orbs", 15, typeof(byte), 150, false, "Forbidden Jungle - All Orbs", false);
  // AddOption(vars.allOrbs, "misty_num_orbs", 16, typeof(byte), 150, false, "Misty Island - All Orbs", false);
  // AddOption(vars.allOrbs, "firecanyon_num_orbs", 17, typeof(byte), 50, false, "Fire Canyon - All Orbs", false);
  // AddOption(vars.allOrbs, "village2_num_orbs", 18, typeof(byte), 50, false, "Rock Village - All Orbs", false);
  // AddOption(vars.allOrbs, "sunken_num_orbs", 19, typeof(byte), 200, false, "Lost Precursor City - All Orbs", false);
  // AddOption(vars.allOrbs, "swamp_num_orbs", 20, typeof(byte), 200, false, "Boggy Swamp - All Orbs", false);
  // AddOption(vars.allOrbs, "rolling_num_orbs", 21, typeof(byte), 200, false, "Precursor Basin - All Orbs", false);
  // AddOption(vars.allOrbs, "ogre_num_orbs", 22, typeof(byte), 50, false, "Mountain Pass - All Orbs", false);
  // AddOption(vars.allOrbs, "village3_num_orbs", 23, typeof(byte), 50, false, "Volcanic Crater - All Orbs", false);
  // AddOption(vars.allOrbs, "snow_num_orbs", 24, typeof(byte), 200, false, "Snowy Mountain - All Orbs", false);
  // AddOption(vars.allOrbs, "cave_num_orbs", 25, typeof(byte), 200, false, "Spider Cave - All Orbs", false);
  // AddOption(vars.allOrbs, "lavatube_num_orbs", 26, typeof(byte), 50, false, "Lava Tube - All Orbs", false);
  // AddOption(vars.allOrbs, "citadel_num_orbs", 27, typeof(byte), 200, false, "Gol and Maia's Citadel - All Orbs", false);
  // AddToSettings(vars.allOrbs, "jak1_level_all_orbs");
  // vars.optionLists.Add(vars.allOrbs);

  // // Per-level Scout Fly Splits
  // Action<List<Dictionary<String, dynamic>>, string, int, string> AddScoutFlyOptions = (list, id_prefix, offset, name_prefix) => {
  //   for (int i = 1; i <= 7; i++) {
  //     AddOption(list, id_prefix + i, offset, typeof(byte), i, false, name_prefix + "Scout Fly " + i, false);
  //   }
  // };
  // settings.Add("jak1_level_scout_flies", true, "Scout Flies per level");

  // vars.trainingScoutFlies = new List<Dictionary<String, dynamic>>();
  // AddScoutFlyOptions(vars.trainingScoutFlies, "training_num_flies_", 28, "Geyser Rock - ");
  // settings.Add("jak1_level_scout_flies_training", true, "Geyser Rock", "jak1_level_scout_flies");
  // AddToSettings(vars.trainingScoutFlies, "jak1_level_scout_flies_training");
  // vars.optionLists.Add(vars.trainingScoutFlies);

  // vars.village1ScoutFlies = new List<Dictionary<String, dynamic>>();
  // AddScoutFlyOptions(vars.village1ScoutFlies, "village1_num_flies_", 29, "Sandover Village - ");
  // settings.Add("jak1_level_scout_flies_village1", true, "Sandover Village", "jak1_level_scout_flies");
  // AddToSettings(vars.village1ScoutFlies, "jak1_level_scout_flies_village1");
  // vars.optionLists.Add(vars.village1ScoutFlies);

  // vars.beachScoutFlies = new List<Dictionary<String, dynamic>>();
  // AddScoutFlyOptions(vars.beachScoutFlies, "beach_num_flies_", 30, "Sentinel Beach - ");
  // settings.Add("jak1_level_scout_flies_beach", true, "Sentinel Beach", "jak1_level_scout_flies");
  // AddToSettings(vars.beachScoutFlies, "jak1_level_scout_flies_beach");
  // vars.optionLists.Add(vars.beachScoutFlies);

  // vars.jungleScoutFlies = new List<Dictionary<String, dynamic>>();
  // AddScoutFlyOptions(vars.jungleScoutFlies, "jungle_num_flies_", 31, "Forbidden Jungle - ");
  // settings.Add("jak1_level_scout_flies_jungle", true, "Forbidden Jungle", "jak1_level_scout_flies");
  // AddToSettings(vars.jungleScoutFlies, "jak1_level_scout_flies_jungle");
  // vars.optionLists.Add(vars.jungleScoutFlies);

  // vars.mistyScoutFlies = new List<Dictionary<String, dynamic>>();
  // AddScoutFlyOptions(vars.mistyScoutFlies, "misty_num_flies_", 32, "Misty Island - ");
  // settings.Add("jak1_level_scout_flies_misty", true, "Misty Island", "jak1_level_scout_flies");
  // AddToSettings(vars.mistyScoutFlies, "jak1_level_scout_flies_misty");
  // vars.optionLists.Add(vars.mistyScoutFlies);

  // vars.firecanyonScoutFlies = new List<Dictionary<String, dynamic>>();
  // AddScoutFlyOptions(vars.firecanyonScoutFlies, "firecanyon_num_flies_", 33, "Fire Canyon - ");
  // settings.Add("jak1_level_scout_flies_firecanyon", true, "Fire Canyon", "jak1_level_scout_flies");
  // AddToSettings(vars.firecanyonScoutFlies, "jak1_level_scout_flies_firecanyon");
  // vars.optionLists.Add(vars.firecanyonScoutFlies);

  // vars.village2ScoutFlies = new List<Dictionary<String, dynamic>>();
  // AddScoutFlyOptions(vars.village2ScoutFlies, "village2_num_flies_", 34, "Rock Village - ");
  // settings.Add("jak1_level_scout_flies_village2", true, "Rock Village", "jak1_level_scout_flies");
  // AddToSettings(vars.village2ScoutFlies, "jak1_level_scout_flies_village2");
  // vars.optionLists.Add(vars.village2ScoutFlies);

  // vars.sunkenScoutFlies = new List<Dictionary<String, dynamic>>();
  // AddScoutFlyOptions(vars.sunkenScoutFlies, "sunken_num_flies_", 35, "Lost Precursor City - ");
  // settings.Add("jak1_level_scout_flies_sunken", true, "Lost Precursor City", "jak1_level_scout_flies");
  // AddToSettings(vars.sunkenScoutFlies, "jak1_level_scout_flies_sunken");
  // vars.optionLists.Add(vars.sunkenScoutFlies);

  // vars.swampScoutFlies = new List<Dictionary<String, dynamic>>();
  // AddScoutFlyOptions(vars.swampScoutFlies, "swamp_num_flies_", 36, "Boggy Swamp - ");
  // settings.Add("jak1_level_scout_flies_swamp", true, "Boggy Swamp", "jak1_level_scout_flies");
  // AddToSettings(vars.swampScoutFlies, "jak1_level_scout_flies_swamp");
  // vars.optionLists.Add(vars.swampScoutFlies);

  // vars.rollingScoutFlies = new List<Dictionary<String, dynamic>>();
  // AddScoutFlyOptions(vars.rollingScoutFlies, "rolling_num_flies_", 37, "Precursor Basin - ");
  // settings.Add("jak1_level_scout_flies_rolling", true, "Precursor Basin", "jak1_level_scout_flies");
  // AddToSettings(vars.rollingScoutFlies, "jak1_level_scout_flies_rolling");
  // vars.optionLists.Add(vars.rollingScoutFlies);

  // vars.ogreScoutFlies = new List<Dictionary<String, dynamic>>();
  // AddScoutFlyOptions(vars.ogreScoutFlies, "ogre_num_flies_", 38, "Mountain Pass - ");
  // settings.Add("jak1_level_scout_flies_ogre", true, "Mountain Pass", "jak1_level_scout_flies");
  // AddToSettings(vars.ogreScoutFlies, "jak1_level_scout_flies_ogre");
  // vars.optionLists.Add(vars.ogreScoutFlies);

  // vars.village3ScoutFlies = new List<Dictionary<String, dynamic>>();
  // AddScoutFlyOptions(vars.village3ScoutFlies, "village3_num_flies_", 39, "Volcanic Crater - ");
  // settings.Add("jak1_level_scout_flies_village3", true, "Volcanic Crater", "jak1_level_scout_flies");
  // AddToSettings(vars.village3ScoutFlies, "jak1_level_scout_flies_village3");
  // vars.optionLists.Add(vars.village3ScoutFlies);

  // vars.snowScoutFlies = new List<Dictionary<String, dynamic>>();
  // AddScoutFlyOptions(vars.snowScoutFlies, "snow_num_flies_", 40, "Snowy Mountain - ");
  // settings.Add("jak1_level_scout_flies_snow", true, "Snowy Mountain", "jak1_level_scout_flies");
  // AddToSettings(vars.snowScoutFlies, "jak1_level_scout_flies_snow");
  // vars.optionLists.Add(vars.snowScoutFlies);

  // vars.caveScoutFlies = new List<Dictionary<String, dynamic>>();
  // AddScoutFlyOptions(vars.caveScoutFlies, "cave_num_flies_", 41, "Spider Cave - ");
  // settings.Add("jak1_level_scout_flies_cave", true, "Spider Cave", "jak1_level_scout_flies");
  // AddToSettings(vars.caveScoutFlies, "jak1_level_scout_flies_cave");
  // vars.optionLists.Add(vars.caveScoutFlies);

  // vars.lavatubeScoutFlies = new List<Dictionary<String, dynamic>>();
  // AddScoutFlyOptions(vars.lavatubeScoutFlies, "lavatube_num_flies_", 42, "Lava Tube - ");
  // settings.Add("jak1_level_scout_flies_lavatube", true, "Lava Tube", "jak1_level_scout_flies");
  // AddToSettings(vars.lavatubeScoutFlies, "jak1_level_scout_flies_lavatube");
  // vars.optionLists.Add(vars.lavatubeScoutFlies);

  // vars.citadelScoutFlies = new List<Dictionary<String, dynamic>>();
  // AddScoutFlyOptions(vars.citadelScoutFlies, "citadel_num_flies_", 43, "Gol and Maia's Citadel - ");
  // settings.Add("jak1_level_scout_flies_citadel", true, "Gol and Maia's Citadel", "jak1_level_scout_flies");
  // AddToSettings(vars.citadelScoutFlies, "jak1_level_scout_flies_citadel");
  // vars.optionLists.Add(vars.citadelScoutFlies);
  
  // Need Resolution Splits (power cells) - offset is relative from the need resolution block of the struct
  settings.Add("jak1_need_res", true, "Mort Levels");
  var jak1_need_res_offset = 424;

  // // Training
  // vars.trainingResolutions = new List<Dictionary<String, dynamic>>();

  // AddOption(vars.trainingResolutions, "res_training_gimmie", jak1_need_res_offset + 0, typeof(byte), 1, false, "Find the Cell on the Path", false);
  // AddOption(vars.trainingResolutions, "res_training_door", jak1_need_res_offset + 1, typeof(byte), 1, false, "Open the Precursor Door", false);
  // AddOption(vars.trainingResolutions, "res_training_climb", jak1_need_res_offset + 2, typeof(byte), 1, false, "Climb up the Cliff", false);
  // AddOption(vars.trainingResolutions, "res_training_buzzer", jak1_need_res_offset + 3, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  // settings.Add("jak1_need_res_training", true, "Geyser Rock", "jak1_need_res");
  // AddToSettings(vars.trainingResolutions, "jak1_need_res_training");
  // vars.optionLists.Add(vars.trainingResolutions);

  // // Village 1
  // vars.village1Resolutions = new List<Dictionary<String, dynamic>>();
  // AddOption(vars.village1Resolutions, "res_village1_yakow", jak1_need_res_offset + 12, typeof(byte), 1, false, "Herd the Yakows into their pen", false);
  // AddOption(vars.village1Resolutions, "res_village1_mayor_money", jak1_need_res_offset + 13, typeof(byte), 1, false, "Bring 90 orbs to the Mayor", false);
  // AddOption(vars.village1Resolutions, "res_village1_uncle_money", jak1_need_res_offset + 14, typeof(byte), 1, false, "Bring 90 orbs to your Uncle", false);
  // AddOption(vars.village1Resolutions, "res_village1_oracle_money1", jak1_need_res_offset + 15, typeof(byte), 1, false, "Bring 120 orbs to the Oracle", false);
  // AddOption(vars.village1Resolutions, "res_village1_oracle_money2", jak1_need_res_offset + 16, typeof(byte), 1, false, "Bring another 120 orbs to the Oracle", false);
  // AddOption(vars.village1Resolutions, "res_village1_buzzer", jak1_need_res_offset + 17, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  // settings.Add("jak1_need_res_village1", true, "Sandover Village", "jak1_need_res");
  // AddToSettings(vars.village1Resolutions, "jak1_need_res_village1");
  // vars.optionLists.Add(vars.village1Resolutions);

  // // Beach
  // vars.beachResolutions = new List<Dictionary<String, dynamic>>();

  // AddOption(vars.beachResolutions, "res_beach_ecorocks", jak1_need_res_offset + 18, typeof(byte), 1, false, "Unblock the eco harvesters", false);
  // AddOption(vars.beachResolutions, "res_beach_pelican", jak1_need_res_offset + 19, typeof(byte), 1, false, "Get the power cell from the pelican", false);
  // AddOption(vars.beachResolutions, "res_beach_flutflut", jak1_need_res_offset + 20, typeof(byte), 1, false, "Push the Flut Flut egg off the cliff", false);
  // AddOption(vars.beachResolutions, "res_beach_seagull", jak1_need_res_offset + 21, typeof(byte), 1, false, "Chase the seagulls", false);
  // AddOption(vars.beachResolutions, "res_beach_cannon", jak1_need_res_offset + 22, typeof(byte), 1, false, "Launch up to the cannon tower", false);
  // AddOption(vars.beachResolutions, "res_beach_buzzer", jak1_need_res_offset + 23, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  // AddOption(vars.beachResolutions, "res_beach_gimmie", jak1_need_res_offset + 24, typeof(byte), 1, false, "Explore the Beach", false);
  // AddOption(vars.beachResolutions, "res_beach_sentinel", jak1_need_res_offset + 25, typeof(byte), 1, false, "Climb the Sentinel", false);
  // settings.Add("jak1_need_res_beach", true, "Sentinel Beach", "jak1_need_res");
  // AddToSettings(vars.beachResolutions, "jak1_need_res_beach");
  // vars.optionLists.Add(vars.beachResolutions);

  // // Jungle
  // vars.jungleResolutions = new List<Dictionary<String, dynamic>>();
  // AddOption(vars.jungleResolutions, "res_jungle_eggtop", jak1_need_res_offset + 4, typeof(byte), 1, false, "Find the Blue Vent Switch", false);
  // AddOption(vars.jungleResolutions, "res_jungle_lurkerm", jak1_need_res_offset + 5, typeof(byte), 1, false, "Connect the Eco Beams", false);
  // AddOption(vars.jungleResolutions, "res_jungle_tower", jak1_need_res_offset + 6, typeof(byte), 1, false, "Get to the Top of the Temple", false);
  // AddOption(vars.jungleResolutions, "res_jungle_fishgame", jak1_need_res_offset + 7, typeof(byte), 1, false, "Catch 200 Pounds of Fish", false);
  // AddOption(vars.jungleResolutions, "res_jungle_plant", jak1_need_res_offset + 8, typeof(byte), 1, false, "Defeat the Dark Eco Plant", false);
  // AddOption(vars.jungleResolutions, "res_jungle_buzzer", jak1_need_res_offset + 9, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  // AddOption(vars.jungleResolutions, "res_jungle_canyon_end", jak1_need_res_offset + 10, typeof(byte), 1, false, "Follow the canyon to the Sea", false);
  // AddOption(vars.jungleResolutions, "res_jungle_temple_door", jak1_need_res_offset + 11, typeof(byte), 1, false, "Open the Locked Temple Door", false);
  // AddOption(vars.jungleResolutions, "int_jungle_fishgame", jak1_need_res_offset + 107, typeof(byte), 1, false, "Talk to Fisherman", false);
  // settings.Add("jak1_need_res_jungle", true, "Forbidden Jungle", "jak1_need_res");
  // AddToSettings(vars.jungleResolutions, "jak1_need_res_jungle");
  // vars.optionLists.Add(vars.jungleResolutions);

  // Mort
  vars.mortResolutions = new List<Dictionary<String, dynamic>>();
  AddOption(vars.mortResolutions, "res_block_world", jak1_need_res_offset + 108, typeof(byte), 1, false, "Finish Block World", false);
  AddOption(vars.mortResolutions, "res_factory_cross", jak1_need_res_offset + 109, typeof(byte), 1, false, "Finish Factory Cross", false);
  AddOption(vars.mortResolutions, "res_holly_wood", jak1_need_res_offset + 110, typeof(byte), 1, false, "Finish Holly Wood", false);
  AddOption(vars.mortResolutions, "res_monument", jak1_need_res_offset + 111, typeof(byte), 1, false, "Finish Monument", false);
  AddOption(vars.mortResolutions, "res_cathedral", jak1_need_res_offset + 112, typeof(byte), 1, false, "Finish Cathedral", false);
  AddOption(vars.mortResolutions, "res_pyramid", jak1_need_res_offset + 113, typeof(byte), 1, false, "Finish Pyramid", false);
  AddOption(vars.mortResolutions, "res_ice_canyon", jak1_need_res_offset + 114, typeof(byte), 1, false, "Finish Ice Canyon", false);
  AddOption(vars.mortResolutions, "res_coins", jak1_need_res_offset + 115, typeof(byte), 1, false, "Finish Coins", false);
  AddOption(vars.mortResolutions, "res_villa_cuba", jak1_need_res_offset + 116, typeof(byte), 1, false, "Finish Villa Cuba", false);
  AddOption(vars.mortResolutions, "res_ice_slide", jak1_need_res_offset + 117, typeof(byte), 1, false, "Finish Ice Slide", false);
  AddOption(vars.mortResolutions, "res_islands", jak1_need_res_offset + 118, typeof(byte), 1, false, "Finish Islands", false);
  AddOption(vars.mortResolutions, "res_glass_towers", jak1_need_res_offset + 119, typeof(byte), 1, false, "Finish Glass Towers", false);
  AddOption(vars.mortResolutions, "res_chemical_factory", jak1_need_res_offset + 120, typeof(byte), 1, false, "Finish Chemical Factory", false);
  AddOption(vars.mortResolutions, "res_space_bridge", jak1_need_res_offset + 121, typeof(byte), 1, false, "Finish Space Bridge", false);
  AddOption(vars.mortResolutions, "res_chicks", jak1_need_res_offset + 122, typeof(byte), 1, false, "Finish Chicks", false);
  AddOption(vars.mortResolutions, "res_garden", jak1_need_res_offset + 123, typeof(byte), 1, false, "Finish Garden", false);
  AddOption(vars.mortResolutions, "res_cold_pipe", jak1_need_res_offset + 124, typeof(byte), 1, false, "Finish Cold Pipe", false);
  // AddOption(vars.mortResolutions, "res_block_man", jak1_need_res_offset + 125, typeof(byte), 1, false, "Finish Block Man", false);
  // AddOption(vars.mortResolutions, "res_cube_face", jak1_need_res_offset + 126, typeof(byte), 1, false, "Finish Cube Face", false);

  settings.Add("jak1_need_res_block_world", true, "Mort Any%", "jak1_need_res");
  AddToSettings(vars.mortResolutions, "jak1_need_res_block_world");
  vars.optionLists.Add(vars.mortResolutions);

    // Per-level All Orbs Splits
  settings.Add("jak1_level_all_mort_orbs", true, "All Orbs per level", "jak1_need_res");
  vars.allMortOrbs = new List<Dictionary<String, dynamic>>();

AddOption(vars.allMortOrbs, "block-world-num-orbs", jak1_need_res_offset + 127, typeof(byte), 55 , false, "Block World - All Orbs" , false);
AddOption(vars.allMortOrbs, "factory-cross-num-orbs", jak1_need_res_offset + 128, typeof(byte), 45 , false, "Factory Cross - All Orbs" , false);
AddOption(vars.allMortOrbs, "holly-wood-num-orbs", jak1_need_res_offset + 129, typeof(byte), 50 , false, "Holly Wood - All Orbs" , false);
AddOption(vars.allMortOrbs, "monument-num-orbs", jak1_need_res_offset + 130, typeof(byte), 51 , false, "Monument - All Orbs" , false);
AddOption(vars.allMortOrbs, "cathedral-num-orbs", jak1_need_res_offset + 131, typeof(byte), 47 , false, "Cathedral - All Orbs" , false);
AddOption(vars.allMortOrbs, "pyramid-num-orbs", jak1_need_res_offset + 132, typeof(byte), 47 , false, "Pyramid - All Orbs" , false);
AddOption(vars.allMortOrbs, "ice-canyon-num-orbs", jak1_need_res_offset + 133, typeof(byte), 46 , false, "Ice Canyon - All Orbs" , false);
AddOption(vars.allMortOrbs, "coins-num-orbs", jak1_need_res_offset + 134, typeof(byte), 98 , false, "Coins - All Orbs" , false);
AddOption(vars.allMortOrbs, "villa-cuba-num-orbs", jak1_need_res_offset + 135, typeof(byte), 43 , false, "Villa Cuba - All Orbs" , false);
AddOption(vars.allMortOrbs, "ice-slide-num-orbs", jak1_need_res_offset + 136, typeof(byte), 35 , false, "Ice Slide - All Orbs" , false);
AddOption(vars.allMortOrbs, "islands-num-orbs", jak1_need_res_offset + 137, typeof(byte), 41 , false, "Islands - All Orbs" , false);
AddOption(vars.allMortOrbs, "glass-towers-num-orbs", jak1_need_res_offset + 138, typeof(byte), 43 , false, "Glass Towers - All Orbs" , false);
AddOption(vars.allMortOrbs, "chemical-factory-num-orbs", jak1_need_res_offset + 139, typeof(byte), 54 , false, "Chemical Factory - All Orbs" , false);
AddOption(vars.allMortOrbs, "space-bridge-num-orbs", jak1_need_res_offset + 140, typeof(byte), 55, false, "Space Bridge - All Orbs" , false);
AddOption(vars.allMortOrbs, "chicks-num-orbs", jak1_need_res_offset + 141, typeof(byte), 1, false, "Chicks - All Orbs" , false);
AddOption(vars.allMortOrbs, "garden-num-orbs", jak1_need_res_offset + 142, typeof(byte), 33 , false, "Garden - All Orbs" , false);
AddOption(vars.allMortOrbs, "cold-pipe-num-orbs", jak1_need_res_offset + 143, typeof(byte), 50 , false, "Cold Pipe - All Orbs" , false);
// AddOption(vars.allMortOrbs, "block-man-num-orbs", jak1_need_res_offset + 144, typeof(byte), 50 , false, "Block Man - All Orbs" , false);
// AddOption(vars.allMortOrbs, "cube-face-num-orbs", jak1_need_res_offset + 145, typeof(byte), 200 , false, "Cube Face - All Orbs" , false);
AddToSettings(vars.allMortOrbs, "jak1_level_all_mort_orbs");
vars.optionLists.Add(vars.allMortOrbs);

  // settings.Add("jak1_level_all_orbs", true, "All Orbs per level");
  // vars.allOrbs = new List<Dictionary<String, dynamic>>();

  // AddOption(vars.allOrbs, "training_num_orbs", 12, typeof(byte), 50, false, "Geyser Rock - All Orbs", false);
  // AddOption(vars.allOrbs, "village1_num_orbs", 13, typeof(byte), 50, false, "Sandover Village - All Orbs", false);
  // AddOption(vars.allOrbs, "beach_num_orbs", 14, typeof(byte), 150, false, "Sentinel Beach - All Orbs", false);
  // AddOption(vars.allOrbs, "jungle_num_orbs", 15, typeof(byte), 150, false, "Forbidden Jungle - All Orbs", false);
  // AddOption(vars.allOrbs, "misty_num_orbs", 16, typeof(byte), 150, false, "Misty Island - All Orbs", false);
  // AddOption(vars.allOrbs, "firecanyon_num_orbs", 17, typeof(byte), 50, false, "Fire Canyon - All Orbs", false);
  // AddOption(vars.allOrbs, "village2_num_orbs", 18, typeof(byte), 50, false, "Rock Village - All Orbs", false);
  // AddOption(vars.allOrbs, "sunken_num_orbs", 19, typeof(byte), 200, false, "Lost Precursor City - All Orbs", false);
  // AddOption(vars.allOrbs, "swamp_num_orbs", 20, typeof(byte), 200, false, "Boggy Swamp - All Orbs", false);
  // AddOption(vars.allOrbs, "rolling_num_orbs", 21, typeof(byte), 200, false, "Precursor Basin - All Orbs", false);
  // AddOption(vars.allOrbs, "ogre_num_orbs", 22, typeof(byte), 50, false, "Mountain Pass - All Orbs", false);
  // AddOption(vars.allOrbs, "village3_num_orbs", 23, typeof(byte), 50, false, "Volcanic Crater - All Orbs", false);
  // AddOption(vars.allOrbs, "snow_num_orbs", 24, typeof(byte), 200, false, "Snowy Mountain - All Orbs", false);
  // AddOption(vars.allOrbs, "cave_num_orbs", 25, typeof(byte), 200, false, "Spider Cave - All Orbs", false);
  // AddOption(vars.allOrbs, "lavatube_num_orbs", 26, typeof(byte), 50, false, "Lava Tube - All Orbs", false);
  // AddOption(vars.allOrbs, "citadel_num_orbs", 27, typeof(byte), 200, false, "Gol and Maia's Citadel - All Orbs", false);
  // AddToSettings(vars.allOrbs, "jak1_level_all_orbs");
  // vars.optionLists.Add(vars.allOrbs);
  // Misty
  vars.mistyResolutions = new List<Dictionary<String, dynamic>>();

  // AddOption(vars.mistyResolutions, "res_misty_muse", jak1_need_res_offset + 26, typeof(byte), 1, false, "Catch the Sculptors Muse", false);
  // AddOption(vars.mistyResolutions, "res_misty_boat", jak1_need_res_offset + 27, typeof(byte), 1, false, "Climb the Lurker Ship", false);
  // AddOption(vars.mistyResolutions, "res_misty_warehouse", jak1_need_res_offset + 28, typeof(byte), 1, false, "Return to the Dark Eco Pool", false);
  // AddOption(vars.mistyResolutions, "res_misty_cannon", jak1_need_res_offset + 29, typeof(byte), 1, false, "Stop the Cannon", false);
  // AddOption(vars.mistyResolutions, "res_misty_bike", jak1_need_res_offset + 30, typeof(byte), 1, false, "Destroy the Balloon Lurkers", false);
  // AddOption(vars.mistyResolutions, "res_misty_buzzer", jak1_need_res_offset + 31, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  // AddOption(vars.mistyResolutions, "res_misty_bike_jump", jak1_need_res_offset + 32, typeof(byte), 1, false, "Use Zoomer to Reach Power Cell", false);
  // AddOption(vars.mistyResolutions, "res_misty_eco_challenge", jak1_need_res_offset + 33, typeof(byte), 1, false, "Use Blue Eco to Reach Power Cell", false);
  // settings.Add("jak1_need_res_misty", true, "Misty Island", "jak1_need_res");
  // AddToSettings(vars.mistyResolutions, "jak1_need_res_misty");
  // vars.optionLists.Add(vars.mistyResolutions);

  // // Fire Canyon
  // vars.firecanyonResolutions = new List<Dictionary<String, dynamic>>();
  // AddOption(vars.firecanyonResolutions, "res_firecanyon_buzzer", jak1_need_res_offset + 74, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  // AddOption(vars.firecanyonResolutions, "res_firecanyon_end", jak1_need_res_offset + 75, typeof(byte), 1, false, "Reach the End of Fire Canyon", false);
  // settings.Add("jak1_need_res_firecanyon", true, "Fire Canyon", "jak1_need_res");
  // AddToSettings(vars.firecanyonResolutions, "jak1_need_res_firecanyon");
  // vars.optionLists.Add(vars.firecanyonResolutions);

  // // Village 2
  // vars.village2Resolutions = new List<Dictionary<String, dynamic>>();
  // AddOption(vars.village2Resolutions, "res_village2_gambler_money", jak1_need_res_offset + 34, typeof(byte), 1, false, "Bring 90 Orbs to the Gambler", false);
  // AddOption(vars.village2Resolutions, "res_village2_geologist_money", jak1_need_res_offset + 35, typeof(byte), 1, false, "Bring 90 Orbs to the Geologist", false);
  // AddOption(vars.village2Resolutions, "res_village2_warrior_money", jak1_need_res_offset + 36, typeof(byte), 1, false, "Bring 90 Orbs to the Warrior", false);
  // AddOption(vars.village2Resolutions, "res_village2_oracle_money1", jak1_need_res_offset + 37, typeof(byte), 1, false, "Bring 120 Orbs to the oracle", false);
  // AddOption(vars.village2Resolutions, "res_village2_oracle_money2", jak1_need_res_offset + 38, typeof(byte), 1, false, "Bring another 120 Orbs to the oracle", false);
  // AddOption(vars.village2Resolutions, "res_village2_buzzer", jak1_need_res_offset + 39, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  // settings.Add("jak1_need_res_village2", true, "Rock Village", "jak1_need_res");
  // AddToSettings(vars.village2Resolutions, "jak1_need_res_village2");
  // vars.optionLists.Add(vars.village2Resolutions);

  // // Sunken
  // vars.sunkenResolutions = new List<Dictionary<String, dynamic>>();
  // AddOption(vars.sunkenResolutions, "res_sunken_platforms", jak1_need_res_offset + 49, typeof(byte), 1, false, "Match the Platform Colors", false);
  // AddOption(vars.sunkenResolutions, "res_sunken_pipe", jak1_need_res_offset + 50, typeof(byte), 1, false, "Follow the Colored Pipes", false);
  // AddOption(vars.sunkenResolutions, "res_sunken_slide", jak1_need_res_offset + 51, typeof(byte), 1, false, "Reach the Bottom of the City", false);
  // AddOption(vars.sunkenResolutions, "res_sunken_room", jak1_need_res_offset + 52, typeof(byte), 1, false, "Raise the Chamber", false);
  // AddOption(vars.sunkenResolutions, "res_sunken_sharks", jak1_need_res_offset + 53, typeof(byte), 1, false, "Quickly Cross the Dangerous Pool", false);
  // AddOption(vars.sunkenResolutions, "res_sunken_buzzer", jak1_need_res_offset + 54, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  // AddOption(vars.sunkenResolutions, "res_sunken_top_of_helix", jak1_need_res_offset + 55, typeof(byte), 1, false, "Climb the Slide Tube", false);
  // AddOption(vars.sunkenResolutions, "res_sunken_spinning_room", jak1_need_res_offset + 56, typeof(byte), 1, false, "Reach the Center of the Complex", false);
  // settings.Add("jak1_need_res_sunken", true, "Lost Precursor City", "jak1_need_res");
  // AddToSettings(vars.sunkenResolutions, "jak1_need_res_sunken");
  // vars.optionLists.Add(vars.sunkenResolutions);

  // // Swamp
  // vars.swampResolutions = new List<Dictionary<String, dynamic>>();
  // AddOption(vars.swampResolutions, "res_swamp_billy", jak1_need_res_offset + 40, typeof(byte), 1, false, "Protect Farthy's Snacks", false);
  // AddOption(vars.swampResolutions, "res_swamp_flutflut", jak1_need_res_offset + 41, typeof(byte), 1, false, "Ride the Flut Flut", false);
  // AddOption(vars.swampResolutions, "res_swamp_battle", jak1_need_res_offset + 42, typeof(byte), 1, false, "Defeat the Lurker Ambush", false);
  // AddOption(vars.swampResolutions, "res_swamp_tether_4", jak1_need_res_offset + 46, typeof(byte), 1, false, "Break the first tether to the Zeppelin", false);
  // AddOption(vars.swampResolutions, "res_swamp_tether_1", jak1_need_res_offset + 43, typeof(byte), 1, false, "Break the second tether to the Zeppelin", false);
  // AddOption(vars.swampResolutions, "res_swamp_tether_2", jak1_need_res_offset + 44, typeof(byte), 1, false, "Break the third tether to the Zeppelin", false);
  // AddOption(vars.swampResolutions, "res_swamp_tether_3", jak1_need_res_offset + 45, typeof(byte), 1, false, "Break the last tether to the Zeppelin", false);
  // AddOption(vars.swampResolutions, "res_swamp_buzzer", jak1_need_res_offset + 47, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  // //While this is a "need res task" I think its more clear if we move it to a cutscenes category and rename this category "Power cells" Or something
  // //AddOption(vars.swampResolutions, "res_swamp_arm", jak1_need_res_offset + 48, typeof(byte), 1, false, "swamp_arm", false);
  // settings.Add("jak1_need_res_swamp", true, "Boggy Swamp", "jak1_need_res");
  // AddToSettings(vars.swampResolutions, "jak1_need_res_swamp");
  // vars.optionLists.Add(vars.swampResolutions);

  // // Rolling
  // vars.rollingResolutions = new List<Dictionary<String, dynamic>>();
  // AddOption(vars.rollingResolutions, "res_rolling_race", jak1_need_res_offset + 57, typeof(byte), 1, false, "Beat Record Time on the Gorge", false);
  // AddOption(vars.rollingResolutions, "res_rolling_robbers", jak1_need_res_offset + 58, typeof(byte), 1, false, "Catch the Flying Lurkers", false);
  // AddOption(vars.rollingResolutions, "res_rolling_moles", jak1_need_res_offset + 59, typeof(byte), 1, false, "Herd the Moles into their Hole", false);
  // AddOption(vars.rollingResolutions, "res_rolling_plants", jak1_need_res_offset + 60, typeof(byte), 1, false, "Cure Dark Eco Infected Plants", false);
  // AddOption(vars.rollingResolutions, "res_rolling_lake", jak1_need_res_offset + 61, typeof(byte), 1, false, "Get the Power Cell over the Lake", false);
  // AddOption(vars.rollingResolutions, "res_rolling_buzzer", jak1_need_res_offset + 62, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  // AddOption(vars.rollingResolutions, "res_rolling_ring_chase_1", jak1_need_res_offset + 63, typeof(byte), 1, false, "Navigate the Purple Precursor Rings", false);
  // AddOption(vars.rollingResolutions, "res_rolling_ring_chase_2", jak1_need_res_offset + 64, typeof(byte), 1, false, "Navigate the Blue Precursor Rings", false);
  // settings.Add("jak1_need_res_rolling", true, "Precursor Basin", "jak1_need_res");
  // AddToSettings(vars.rollingResolutions, "jak1_need_res_rolling");
  // vars.optionLists.Add(vars.rollingResolutions);

  // // Ogre Boss
  // vars.ogrebossResolutons = new List<Dictionary<String, dynamic>>();
  // AddOption(vars.ogrebossResolutons, "res_ogre_boss", jak1_need_res_offset + 97, typeof(byte), 1, false, "Defeat Klaww", false);
  // AddOption(vars.ogrebossResolutons, "res_ogre_end", jak1_need_res_offset + 98, typeof(byte), 1, false, "Reach the End of the Mountain Pass", false);
  // AddOption(vars.ogrebossResolutons, "res_ogre_buzzer", jak1_need_res_offset + 99, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  // AddOption(vars.ogrebossResolutons, "res_ogre_secret", jak1_need_res_offset + 100, typeof(byte), 1, false, "Find the Hidden Power Cell", false);
  // settings.Add("jak1_need_res_ogreboss", true, "Mountain Pass", "jak1_need_res");
  // AddToSettings(vars.ogrebossResolutons, "jak1_need_res_ogreboss");
  // vars.optionLists.Add(vars.ogrebossResolutons);

  // // Village 3
  // vars.village3Resolutions = new List<Dictionary<String, dynamic>>();
  // AddOption(vars.village3Resolutions, "res_village3_extra1", jak1_need_res_offset + 81, typeof(byte), 1, false, "Find the Hidden Power Cell", false);
  // AddOption(vars.village3Resolutions, "res_village3_buzzer", jak1_need_res_offset + 82, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  // AddOption(vars.village3Resolutions, "res_village3_miner_money1", jak1_need_res_offset + 83, typeof(byte), 1, false, "Bring 90 Orbs to the Miners once", false);
  // AddOption(vars.village3Resolutions, "res_village3_miner_money2", jak1_need_res_offset + 84, typeof(byte), 1, false, "Bring 90 Orbs to the Miners twice", false);
  // AddOption(vars.village3Resolutions, "res_village3_miner_money3", jak1_need_res_offset + 85, typeof(byte), 1, false, "Bring 90 Orbs to the Miners three times", false);
  // AddOption(vars.village3Resolutions, "res_village3_miner_money4", jak1_need_res_offset + 86, typeof(byte), 1, false, "Bring 90 Orbs to the Miners four times", false);
  // AddOption(vars.village3Resolutions, "res_village3_oracle_money1", jak1_need_res_offset + 87, typeof(byte), 1, false, "Bring 120 Orbs to the Oracle", false);
  // AddOption(vars.village3Resolutions, "res_village3_oracle_money2", jak1_need_res_offset + 88, typeof(byte), 1, false, "Bring another 120 Orbs to the Oracle", false);
  // settings.Add("jak1_need_res_village3", true, "Volcanic Crater", "jak1_need_res");
  // AddToSettings(vars.village3Resolutions, "jak1_need_res_village3");
  // vars.optionLists.Add(vars.village3Resolutions);

  // // Snowy
  // vars.snowyResolutions = new List<Dictionary<String, dynamic>>();
  // AddOption(vars.snowyResolutions, "res_snow_eggtop", jak1_need_res_offset + 65, typeof(byte), 1, false, "Find the Yellow Vent switch", false);
  // AddOption(vars.snowyResolutions, "res_snow_ram", jak1_need_res_offset + 66, typeof(byte), 1, false, "Stop the 3 Lurker Glacier Troops", false);
  // AddOption(vars.snowyResolutions, "res_snow_fort", jak1_need_res_offset + 67, typeof(byte), 1, false, "Get through the Lurker Fort", false);
  // AddOption(vars.snowyResolutions, "res_snow_ball", jak1_need_res_offset + 68, typeof(byte), 1, false, "Open the Lurker Fort Gate", false);
  // AddOption(vars.snowyResolutions, "res_snow_bunnies", jak1_need_res_offset + 69, typeof(byte), 1, false, "Survive the Lurker Infested Cave", false);
  // AddOption(vars.snowyResolutions, "res_snow_buzzer", jak1_need_res_offset + 70, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  // AddOption(vars.snowyResolutions, "res_snow_bumpers", jak1_need_res_offset + 71, typeof(byte), 1, false, "Deactivate the Precursor Blockers", false);
  // AddOption(vars.snowyResolutions, "res_snow_cage", jak1_need_res_offset + 72, typeof(byte), 1, false, "Opent the Frozen Crate", false);
  // //The task below is unsed in retail versions of the game.
  // //AddOption(vars.snowyResolutions, "res_red_eggtop", jak1_need_res_offset + 73, typeof(byte), 1, false, "red_eggtop", false);
  // settings.Add("jak1_need_res_snowy", true, "Snowy Mountain", "jak1_need_res");
  // AddToSettings(vars.snowyResolutions, "jak1_need_res_snowy");
  // vars.optionLists.Add(vars.snowyResolutions);

  // // Spider Cave
  // vars.spiderCaveResolutions = new List<Dictionary<String, dynamic>>();
  // AddOption(vars.spiderCaveResolutions, "res_cave_gnawers", jak1_need_res_offset + 89, typeof(byte), 1, false, "Use your Goggles to shoot the Gnawing Lurkers", false);
  // AddOption(vars.spiderCaveResolutions, "res_cave_dark_crystals", jak1_need_res_offset + 90, typeof(byte), 1, false, "Destroy the dark Eco Crystals", false);
  // AddOption(vars.spiderCaveResolutions, "res_cave_dark_climb", jak1_need_res_offset + 91, typeof(byte), 1, false, "Explore the Dark Cave", false);
  // AddOption(vars.spiderCaveResolutions, "res_cave_robot_climb", jak1_need_res_offset + 92, typeof(byte), 1, false, "Climb the giant robot", false);
  // AddOption(vars.spiderCaveResolutions, "res_cave_swing_poles", jak1_need_res_offset + 93, typeof(byte), 1, false, "Launch to the Poles", false);
  // AddOption(vars.spiderCaveResolutions, "res_cave_spider_tunnel", jak1_need_res_offset + 94, typeof(byte), 1, false, "Navigate the Spider Tunnel", false);
  // AddOption(vars.spiderCaveResolutions, "res_cave_platforms", jak1_need_res_offset + 95, typeof(byte), 1, false, "Climb the Precursor Platforms", false);
  // AddOption(vars.spiderCaveResolutions, "res_cave_buzzer", jak1_need_res_offset + 96, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  // settings.Add("jak1_need_res_spidercave", true, "Spider Cave", "jak1_need_res");
  // AddToSettings(vars.spiderCaveResolutions, "jak1_need_res_spidercave");
  // vars.optionLists.Add(vars.spiderCaveResolutions);


  // // Lava Tube
  // vars.lavatubeResolutions = new List<Dictionary<String, dynamic>>();
  // AddOption(vars.lavatubeResolutions, "res_lavatube_end", jak1_need_res_offset + 101, typeof(byte), 1, false, "Reach the end of the Lava Tube", false);
  // AddOption(vars.lavatubeResolutions, "res_lavatube_buzzer", jak1_need_res_offset + 102, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  // //This task below does not go with a in game Power Cell
  // AddOption(vars.lavatubeResolutions, "res_lavatube_balls", jak1_need_res_offset + 103, typeof(byte), 1, false, "Finish Oranges", false);
  // settings.Add("jak1_need_res_lavatube", true, "Lava Tube", "jak1_need_res");
  // AddToSettings(vars.lavatubeResolutions, "jak1_need_res_lavatube");
  // vars.optionLists.Add(vars.lavatubeResolutions);

  // // Citadel
  // vars.citadelResolutions = new List<Dictionary<String, dynamic>>();
  // AddOption(vars.citadelResolutions, "res_citadel_sage_green", jak1_need_res_offset + 76, typeof(byte), 1, false, "Free the Green Sage", false);
  // AddOption(vars.citadelResolutions, "res_citadel_sage_blue", jak1_need_res_offset + 77, typeof(byte), 1, false, "Free the Blue Sage", false);
  // AddOption(vars.citadelResolutions, "res_citadel_sage_red", jak1_need_res_offset + 78, typeof(byte), 1, false, "Free the Red Sage", false);
  // AddOption(vars.citadelResolutions, "res_citadel_sage_yellow", jak1_need_res_offset + 79, typeof(byte), 1, false, "Free the Yellow Sage", false);
  // AddOption(vars.citadelResolutions, "res_citadel_buzzer", jak1_need_res_offset + 80, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  // AddOption(vars.citadelResolutions, "unk_finalboss_movies", jak1_need_res_offset + 106, typeof(byte), 1, false, "Light Eco?!?! That could be the stuff to change me back!", false);
  // settings.Add("jak1_need_res_citadel", true, "Gol and Maia's Citadel", "jak1_need_res");
  // AddToSettings(vars.citadelResolutions, "jak1_need_res_citadel");
  // vars.optionLists.Add(vars.citadelResolutions);

  // NOTE - skipping `need_res_intro` because it's skipped when starting a run anyway

  // Misc Tasks
  // - other tasks other than `need_resolution` ones, the ones deemed useful enough to be added
  settings.Add("jak1_misc_tasks", true, "Final Task");
  vars.miscallenousTasks = new List<Dictionary<String, dynamic>>();
  AddOption(vars.miscallenousTasks, "int_finalboss_movies", jak1_need_res_offset + 105, typeof(byte), 1, true, "Collect Samos Fart", false);
  AddToSettings(vars.miscallenousTasks, "jak1_misc_tasks");
  vars.optionLists.Add(vars.miscallenousTasks);

  // Treat this one as special, so we can ensure the timer ends no matter what!
  vars.finalSplitTask = vars.miscallenousTasks[0];

  vars.DebugOutput("Finished {startup}", true);
}

init {
  vars.DebugOutput("Running {init} looking for `gk.exe`", true);
  var sw = new Stopwatch();
  sw.Start();
  var exported_ptr = IntPtr.Zero;
  vars.foundPointers = false;
  byte[] marker = Encoding.ASCII.GetBytes("UnLiStEdStRaTs_JaK1" + Char.MinValue);
  vars.debugTick = 0;
  // NOTE - the subtraction is a total hack.  When we switched to SDL the statically linked binary now has this new `No Access` region of 0x1000 bytes near the end of the first module
  // This feels like a total hack and is brittle (memory layout can change in the future, sizes can change, new regions can be added).
  //
  // 28672 = 0x7000 and this is the size from the end of the first module to before the beginning of this No Access region at the time of writing.
  //
  // However, since this is a hack, we should probably be a bit more conservative incase more the region layout changes.
  //
  // LiveSplit tries to read the entire region it's given into memory and a partial read is a failure.
  vars.DebugOutput(String.Format("Scanning First Module - {0}->{1}", modules.First().BaseAddress.ToString("x8"), (modules.First().BaseAddress.ToInt64() + modules.First().ModuleMemorySize - 100000).ToString("x8")), true);
  exported_ptr = new SignatureScanner(game, modules.First().BaseAddress, modules.First().ModuleMemorySize - 200000).Scan(
    new SigScanTarget(marker.Length, marker)
  );

  if (exported_ptr == IntPtr.Zero) {
    vars.DebugOutput("Could not find the AutoSplittingInfo struct, old version of gk.exe? Failing!", true);
    sw.Reset();
    return false;
  }
  vars.DebugOutput(String.Format("Found AutoSplittingInfo struct - {0}", exported_ptr.ToString("x8")), true);

  // The offset to the GOAL struct is stored in a u64 next to the marker!
  var goal_struct_ptr = new IntPtr(memory.ReadValue<long>(exported_ptr + 4));
  while (goal_struct_ptr == IntPtr.Zero) {
    vars.DebugOutput("Could not find pointer to GOAL struct, game still loading? Retrying in 1000ms...!", true);
    Thread.Sleep(1000);
    sw.Reset();
    throw new Exception("Could not find pointer to GOAL struct, game still loading? Retrying...");
  }
  Action<MemoryWatcherList, IntPtr, List<Dictionary<String, dynamic>>> AddMemoryWatchers = (memList, bPtr, options) => {
    foreach (Dictionary<String, dynamic> option in options) {
      var finalOffset = bPtr + (option["offset"]);
      // TODO - use the type on the object to make this value properly.  Right now everything is a u8
      memList.Add(new MemoryWatcher<byte>(finalOffset) { Name = option["id"] });
      if (option["debug"] == true) {
        memList[option["id"]].Update(game);
        vars.DebugOutput(String.Format("Debug ({0}) -> ptr [{1}]; val [{2}]", option["id"], finalOffset.ToString("x8"), memList[option["id"]].Current), true);
      }
    }
  };

  var watchers = new MemoryWatcherList{
    new MemoryWatcher<uint>(goal_struct_ptr + 212) { Name = "currentGameHash" }
  };

  // Init current game has in case script is loaded while game is already started
  watchers["currentGameHash"].Update(game);

  var jak1_need_res_bptr = goal_struct_ptr; // bytes
  foreach (List<Dictionary<String, dynamic>> optionList in vars.optionLists) {
    AddMemoryWatchers(watchers, jak1_need_res_bptr, optionList);
  }
  vars.foundPointers = true;
  vars.watchers = watchers;
  sw.Stop();
  vars.DebugOutput("Script Initialized, Game Compatible.", true);
  vars.DebugOutput(String.Format("Found the exported struct at {0}", goal_struct_ptr.ToString("x8")), true);
  vars.DebugOutput(String.Format("It took {0} ms", sw.ElapsedMilliseconds), true);
}

update {
  if (!vars.foundPointers) {
    return false;
  }

  vars.watchers.UpdateAll(game);
}

reset {
  if (vars.watchers["currentGameHash"].Current != 0 && vars.watchers["currentGameHash"].Current != vars.watchers["currentGameHash"].Old) {
    vars.DebugOutput("Resetting!", settings["asl_settings_debug"]);
    vars.DebugOutput(String.Format("Reset -> Old: {0}, Curr: {1}", vars.watchers["currentGameHash"].Old, vars.watchers["currentGameHash"].Current), settings["asl_settings_debug"]);
    return true;
  }
  return false;
}

start {
  if (vars.watchers["currentGameHash"].Current != 0 && vars.watchers["currentGameHash"].Current != vars.watchers["currentGameHash"].Old) {
    vars.DebugOutput("Starting!", settings["asl_settings_debug"]);
    vars.DebugOutput(String.Format("Start -> Old: {0}, Curr: {1}", vars.watchers["currentGameHash"].Old, vars.watchers["currentGameHash"].Current), settings["asl_settings_debug"]);
    return true;
  }
  return false;
}

isLoading {
  // todo
  return false;
}

split {
  Func<List<Dictionary<String, dynamic>>, bool> InspectValues = (list) => {
    var debugThisIter = false;
    if (vars.debugTick++ % 60 == 0) {
      debugThisIter = true;
    }
    foreach (Dictionary<String, dynamic> option in list) {
      var watcher = vars.watchers[option["id"]];
      if (option["debug"] && debugThisIter) {
        vars.DebugOutput(String.Format("Debug ({0}) -> old [{1}]; current [{2}]", option["id"], watcher.Old, watcher.Current), settings["asl_settings_debug"]);
      }
      if (settings[option["id"]]) {
        // if we don't care about the amount, split on any change
        if (option["splitVal"] == null && watcher.Current != watcher.Old) {
          return true;
        }
        // Else, make sure we've hit that goal amount
        else if (option["splitVal"] != null && watcher.Current != watcher.Old && watcher.Current == option["splitVal"]) {
          return true;
        }
      }
    }
    return false;
  };
  foreach (List<Dictionary<String, dynamic>> optionList in vars.optionLists) {
    if (InspectValues(optionList)) {
      return true;
    }
  }

  // ALWAYS split if the final split condition is true, so no matter what we exhaust all splits until the end
  if (vars.watchers[vars.finalSplitTask["id"]].Current == vars.finalSplitTask["splitVal"]) {
    return true;
  }
}
