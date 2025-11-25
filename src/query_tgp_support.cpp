#include <Rcpp.h>
#include <optional>

#if defined (__unix__) || defined (__APPLE__) 

#include "utils.h"
#include <string>
#include <unistd.h>
#include <stdio.h>
#include <sys/ioctl.h>

std::optional<std::string> query_tgp_support() {
  // If we are not connected to a terminal return false immediately
  if (!isatty(0)) return {};

  // query from
  // https://sw.kovidgoyal.net/kitty/graphics-protocol/#querying-support-and-available-transmission-mediums
  const std::string query = "\033_Gi=33,s=1,v=1,a=q,t=d,f=24;AAAA\033\\";

  // Query support
  Rcpp::Rcout << query.c_str() << "\033[c";
  Rcpp::Rcout.flush();
  if (device_ansi_response_ok()) return ""; // no protocol needed

  // Query support with tmux passthrough
  // TODO: this periodically fails to suppress "\033[c" response
  Rcpp::Rcout << tgp_passthrough("tmux", query + "\033[c").c_str();
  Rcpp::Rcout.flush();
  if (device_ansi_response_ok()) return "tmux";

  return {};
}

#else

std::optional<bool> query_tgp_support() {
  return {};
}

#endif


// [[Rcpp::export]]
Rcpp::CharacterVector query_tgp_support_rcpp() {
  const auto res = query_tgp_support();
  if (res.has_value()) {
    return res.value();
  } else {
    Rcpp::CharacterVector res{1L};
    res[0] = Rcpp::CharacterVector::get_na();
    return res;
  }
}

