#include <Rcpp.h>
#include <optional>

#if defined (__unix__) || defined (__APPLE__) 

#include <string>
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


std::optional<bool> query_tgp_support() {
  // If we are not connected to a terminal return false immediately
  if (!isatty(0)) return false;
  // Query support
  Rcpp::Rcout << "\033_Gi=33,s=1,v=1,a=q,t=d,f=24;AAAA\033\\\033[c";
  Rcpp::Rcout.flush();
  char c = getch();
  if (c != 27) return false;
  c = getch();
  bool support = true;
  if (c == '_') {
    // we expect "_Gi=33;OK\033\\"
    const std::string okstr = "_Gi=33;OK\033\\";
    unsigned int i = 0;
    while (c != '\033') {
      if (support && i < okstr.size() && c != okstr[i])
        support = false;
      c = getch();
      ++i;
    }
    c = getch();
    if (c != '\\') support = false;
    c = getch();
  } else support = false;
  // read remainder
  while (c != 'c') c = getch();
  return support;

}

#else

std::optional<bool> query_tgp_support() {
  return {};
}

#endif


// [[Rcpp::export]]
Rcpp::LogicalVector query_tgp_support_rcpp() {
  const auto res = query_tgp_support();
  if (res.has_value()) {
    return res.value();
  } else {
    Rcpp::LogicalVector res{1L};
    res[0] = Rcpp::LogicalVector::get_na();
    return res;
  }
}

