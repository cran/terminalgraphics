#include "utils.h"

#if defined (__unix__) || defined (__APPLE__) 
#include <unistd.h>
#include <termios.h>
#endif

char getch() {
  char buf = 0;

#if defined (__unix__) || defined (__APPLE__) 
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
#endif

  return (buf);
}

bool device_ansi_response_ok() {
#if defined (__unix__) || defined (__APPLE__) 
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
#else 
  return true;
#endif
}

std::string string_replace(std::string x, std::string_view seq, std::string_view rep) {
  size_t index = 0;
  while (true) {
    index = x.find(seq, index);
    if (index == std::string::npos) break;
    x.replace(index, seq.length(), rep);
    index += rep.length();
  }
  return x;
}

std::string tgp_passthrough(std::string_view protocol, std::string_view query) {
  return "\033P" + std::string(protocol) + ";" +
    string_replace(std::string(query), "\033", "\033\033") + "\033\\";
}

