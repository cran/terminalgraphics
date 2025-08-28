#include <Rcpp.h>
#include <optional>

#if defined (__unix__) || defined (__APPLE__) 

#include <unistd.h>
#include <stdio.h>
#include <termios.h>
#include <sys/ioctl.h>

inline char getch() {
  char buf = 0;
  struct termios old = {0};
  if (tcgetattr(0, &old) < 0)
    perror("tcsetattr()");
  old.c_lflag &= ~ICANON;
  old.c_lflag &= ~ECHO;
  old.c_cc[VMIN] = 1;
  old.c_cc[VTIME] = 0;
  if (tcsetattr(0, TCSANOW, &old) < 0)
    perror("tcsetattr ICANON");
  if (read(0, &buf, 1) < 0)
    perror ("read()");
  old.c_lflag |= ICANON;
  old.c_lflag |= ECHO;
  if (tcsetattr(0, TCSADRAIN, &old) < 0)
    perror ("tcsetattr ~ICANON");
  return (buf);
}


std::optional<bool> query_sixel_support() {
  // If we are not connected to a terminal return false immediately
  if (!isatty(0)) return false;
  // Query support
  Rcpp::Rcout << "\033[0c";
  Rcpp::Rcout.flush();
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

#else

std::optional<bool> query_sixel_support() {
  return {};
}

#endif


// [[Rcpp::export]]
Rcpp::LogicalVector query_sixel_support_rcpp() {
  const auto res = query_sixel_support();
  if (res.has_value()) {
    return res.value();
  } else {
    Rcpp::LogicalVector res{1L};
    res[0] = Rcpp::LogicalVector::get_na();
    return res;
  }
}

