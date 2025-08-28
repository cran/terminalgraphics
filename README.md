# terminalgraphics

An R-package for graphical output in terminals. Currently supports terminals
that support the [Terminal Graphics
Protocol](https://sw.kovidgoyal.net/kitty/graphics-protocol/) and terminals that
support [Sixel](https://en.wikipedia.org/wiki/Sixel). It implements a graphical
device that will output into the terminal and also some functions for retrieving
information from the terminal such as the colour scheme used, the dimensions of
the terminal and function for displaying png images and image matrices. 

### Example code

Set the `tgp` (Terminal Graphics Protocol) device as the standard device and
instruct the package to use the terminal colors (only supported currently in
Kitty):
```R
options(device = terminalgraphics::tgp, term_col = TRUE)
```

For example, one could use the following lines in `~/.Rprofile` to set the the
`tgp` device as the default device.
```R
if (interactive() && terminalgraphics::has_tgp_support()) {
  options(device = terminalgraphics::tgp, term_col = TRUE)
}
```
or for Sixel support:
```R
if (interactive() && terminalgraphics::has_tgp_support()) {
  options(device = terminalgraphics::sixel)
}
```

Creating a plot like, for example:
```R
{
  data(iris)
  plot(iris$Sepal.Width, iris$Sepal.Length, 
    col = term_palette()[iris$Species], 
    pch = 20)
  grid(lty = 2)
  legend("topright", legend = levels(iris$Species), 
    col = term_palette()[1:3], pch = 20)
}
```

Results in:

<img src="kitty_demo.png" width="600" alt="Screenshot of a plot in kitty">

By default it will match the colours of the plot to those used of the theme used
in the terminal (currently the theme can only be determined for
[Kitty](https://sw.kovidgoyal.net/kitty/)).


Other functions are:

`png2terminal`, `png2tgp`, `png2sixel`
: display a png file in the terminal.

`raster2terminal`, `raster2tgp`, `raster2sixel`
: display image raster in the terminal.

`term_dim`, `term_width`, `term_height`
: Get the dimensions of the terminal (in pixels and number rows and columns). 

`term_palette` 
: get a palette based on the colours used in the current theme.

`kitty_foreground` and `kitty_background` 
: get the foreground and background colours of the current theme.

`has_tgp_support`
: determine if the terminal supports the Terminal Graphics Protocol.

`has_sixel_support`
: determine if the terminal supports Sixel.

`is_kitty`
: is R running in a Kitty terminal.


### Tips 

Every time the contents of the graphics device change after evaluating an
expression, a new version of the plot is shown in the terminal. Therefore, the
following two lines will result in two plots in the terminal:

```R
plot(rnorm(200))
abline(h = 0)
```

If you want only one plot to appear in the terminal, you should combine the
lines into one expression:

```R
{ 
  plot(rnorm(200))
  abline(h = 0)
}
```

The size and resolution of the plot can be changed using arguments of `tgp` and
`sixel`:
```R
tgp(width = 1000, height = 500)
plot(rnorm(200))
```

It is also possible to set some of these using options:

```R
options(device = terminalgraphics::tgp, term_width = 1000, term_height = 500, 
  term_res = 150, term_col = TRUE)
```

Note that these options are used for *new* devices. Therefore, when there is
already a device open, you should call `tgp`/`sixel` to open a new device or
close open devices using `dev.off` before starting a new plot.

