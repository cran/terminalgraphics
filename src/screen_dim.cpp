#include <Rcpp.h>
#include "utils.h"

#if defined (__unix__) || defined (__APPLE__) 
#include <stdio.h>
#include <unistd.h>
#include <sys/ioctl.h>

void query_screen_dim_ansi(int dim[]) {
    // parse response in the form of "<ESC>[4;<height>;<width>;t"
    Rcpp::Rcout << "\033[14t";
    Rcpp::Rcout.flush();
    char c = getch();

    // read to first ";"
    while (c != ';') c = getch();

    // read height (y_pixels)
    char dim_string[16];
    unsigned int i = 0;
    do {
       c = dim_string[i] = getch();
       i++;
    } while (c != ';' && i < 15L);
    dim_string[i] = 0;
    dim[1] = std::atoi(dim_string);

    // read width (x_pixels)
    std::fill(dim_string, dim_string + 16, 0);
    i = 0;
    do {
       c = dim_string[i] = getch();
       i++;
    } while (c != 't' && i < 15L);
    dim_string[i] = 0;
    dim[0] = std::atoi(dim_string);
}
#endif

// [[Rcpp::export]]
Rcpp::IntegerVector screen_dim_cpp() {
#if defined (__unix__) || defined (__APPLE__) 
  struct winsize sz = winsize();
  ioctl(0, TIOCGWINSZ, &sz);

  // if we can't get pixel dimensions using ioctl, use ansi code response
  // notably when running inside a container with attached tty
  if (isatty(0) && (sz.ws_xpixel == 0 || sz.ws_ypixel == 0)) {
    int dim[2];
    query_screen_dim_ansi(dim);
    sz.ws_xpixel = dim[0];
    sz.ws_ypixel = dim[1];
  }

  return {sz.ws_xpixel, sz.ws_ypixel, sz.ws_row, sz.ws_col};
#else
  return {0L, 0L, 0L, 0L};
#endif
}


