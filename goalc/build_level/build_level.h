#pragma once
#include "decompiler/level_extractor/extract_level.h"
#include <string>
#include <vector>

bool run_build_level(const std::string& input_file,
                     const std::string& bsp_output_file,
                     const std::string& output_prefix,
                     const decompiler::ObjectFileDB& db,
                     const decompiler::TextureDB& tex_db,
                     const std::string& dgo_name,
                     const decompiler::DecompileHacks& hacks,
                     bool extract_collision);
std::vector<std::string> get_build_level_deps(const std::string& input_file);
