#include <Rcpp.h>
#include <optional>
#include <string>

#if defined (__unix__) || defined (__APPLE__) 

#include "utils.h"
#include <unistd.h>

std::optional<std::string> query_term_color_mode(bool dsr = true) {
  std::optional<std::string> mode = {};
  // If we are not connected to a terminal return false immediately
  if (!isatty(0)) return mode;
  // Query support
  //Rcpp::Rcout << "\033[?2031h" << "\033[?996n" << "\033[?2031l" << "\033[c";
  Rcpp::Rcout << "\033[?996n";
  if (dsr) Rcpp::Rcout << "\033[c";
  Rcpp::Rcout.flush();
  // Flush the expected response prefix
  char c = getch();
  unsigned int i = 0;
  const std::string resp_prefix = "\033[?997;";
  while (i < resp_prefix.size() && c == resp_prefix[i]) {
    c = getch(); ++i;
    //if (c < 33) std::cout << (int)(c) << "\n"; else std::cout << "'" << c << "'\n";
  }
  // If we received our expected response, use next character as indicator
  if (i == resp_prefix.size()) {
    if (c == '1') mode = "dark";
    if (c == '2') mode = "light";
  }
  // Read the last n
  getch();
  // And flush remainder until we get our standard device response terminator
  if (dsr) {
    while (c != 'c') {
      c = getch();
      //if (c < 33) std::cout << (int)(c) << "\n"; else std::cout << "'" << c << "'\n";
    }
  }
  return mode;
}

#else

std::optional<std::string> query_term_color_mode(bool dsr = true) {
  return {};
}

#endif


// [[Rcpp::export]]
Rcpp::CharacterVector term_color_mode_rcpp(bool dsr = true) {
  const auto res = query_term_color_mode(dsr);
  if (res.has_value()) {
    return res.value();
  } else {
    Rcpp::CharacterVector res{1L};
    res[0] = Rcpp::CharacterVector::get_na();
    return res;
  }
}

