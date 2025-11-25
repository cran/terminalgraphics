
# Send a ANSI-command to the terminal possibly wrapping it in ANSI passthrough 
# codes for a given protocol. This is used to send ANSI codes to the underlying
# terminal when working in tmux.
#
with_tgp_protocol <- function(x) {
  protocol <- query_tgp_support()
  if (nzchar(protocol)) {
    paste0("\033P", protocol, ";", gsub("\033", "\033\033", x), "\033\\")
  } else {
    x
  }
}

