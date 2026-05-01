#include <Rcpp.h>
#include <optional>
#include "utils.h"

#if defined (__unix__) || defined (__APPLE__) 

#include <unistd.h>
#include <stdio.h>
#include <termios.h>
#include <sys/ioctl.h>

bool device_ansi_ansi_response_sixel() {
  // We expect something like \033[?1;2;3c
  // If one of the number is 6, the terminal supports sixel
  bool support = false;
  char c = getch();
  if (c != 27) return false;
  c = getch();
  if (c == '[') {
    c = getch();
    if (c == '?') {
      int charcount = 0;
      c = ';';
      while (c != 'c') {
        const char oldc = c;
        c = getch();
        if (c == ';' || c == 'c') {
          if (charcount == 1 && oldc == '6') support = true;
          charcount = 0;
        } else {
          charcount++;
        }
      }
    } 
  } 
  // read remainder
  while (c != 'c') c = getch();
  return support;
}

std::optional<bool> query_sixel_support(bool tmux) {
  // If we are not connected to a terminal return false immediately
  if (!isatty(0)) return false;
  // Query support
  const std::string query = "\033[0c";
  if (!tmux) {
    Rcpp::Rcout << query.c_str();
    Rcpp::Rcout.flush();
    if (device_ansi_ansi_response_sixel()) return true;
  } else {
    // Query support with tmux passthough
    Rcpp::Rcout << tgp_passthrough("tmux", query).c_str();
    Rcpp::Rcout.flush();
    if (device_ansi_ansi_response_sixel()) return true;
  }
  return false;
}

#else

std::optional<bool> query_sixel_support(bool tmux) {
  return {};
}

#endif


// [[Rcpp::export]]
Rcpp::LogicalVector query_sixel_support_rcpp(bool tmux) {
  const auto res = query_sixel_support(tmux);
  if (res.has_value()) {
    return res.value();
  } else {
    Rcpp::LogicalVector res{1L};
    res[0] = Rcpp::LogicalVector::get_na();
    return res;
  }
}

