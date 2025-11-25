source("helpers.R")

library(terminalgraphics)

if (!is_kitty()) {

  expect_equal(term_background(), "white")
  expect_equal(term_foreground(), "black")
  expect_equal(term_palette(), grDevices::hcl.colors("Dark2", n = 9 ))

} 


options(
  term_background = "red", 
  term_foreground = "yellow",
  term_palette = c("pink", "green")
)
expect_equal(term_background(), "red")
expect_equal(term_foreground(), "yellow")
expect_equal(term_palette(), c("pink", "green"))



