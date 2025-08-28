
#include <Rcpp.h>

#if defined (__unix__) || defined (__APPLE__) 
#include <stdio.h>
#include <sys/ioctl.h>
#endif

// [[Rcpp::export]]
Rcpp::IntegerVector screen_dim_cpp() {
#if defined (__unix__) || defined (__APPLE__) 
  struct winsize sz;
  ioctl(0, TIOCGWINSZ, &sz);
  return {sz.ws_xpixel, sz.ws_ypixel, sz.ws_row, sz.ws_col};
#else
  return {0L, 0L, 0L, 0L}; 
#endif
}


