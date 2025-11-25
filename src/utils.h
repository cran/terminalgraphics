#pragma once

#include <string_view>
#include <string>

char getch();
bool device_ansi_response_ok();
std::string tgp_passthrough(std::string_view protocol, std::string_view query);
std::string string_replace(std::string x, std::string_view seq, std::string_view  rep);

