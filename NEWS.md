# terminalgraphics 0.2.1

## Bug fixes

* Opening a `sixel` or `tgp` device generated an error when either `raster` or
  `ragg` (version <= 1.5.0) is installed.


# terminalgraphics 0.2.0

## New features

* Adds support for the terminal graphics protocol (tgp) when used within `tmux`.
  Leveraging this feature requires that `tmux` is configured with
  `allow-passthrough on`. (@dgkf, #9)

* Fixes the labelling of values in `term_dim()`, which previously had columns
  and rows names swapped. (@dgkf, #9)

* Add options `term_background`, `term_foreground` and `term_palette` to set the
  background and foreground colour of the terminal. Currently these are only
  detected automatically in kitty. With these options it is possible to set
  these manually for other terminals. Note that in order to automatically use
  these in new devices, either the argument `term_col = TRUE` of `tgp()` or
  `sixel()`. or the option `term_col = TRUE` needs to be set. (#8)

* Add support for quering colour mode (dark/light) for terminals that support
  this. When `term_col = TRUE`, different default colours are used for dark and
  light mode. When the terminal does not support this, the colours of light mode
  are used. (@dgkf, #11)

* New `is_ghostty()` function to determine if we are running in ghostty.

## Bug fixes

* The package now uses the new feature of `ragg` (>1.5.0) where it is possible to
  query the `ragg` device if it has changed
  (<https://github.com/r-lib/ragg/issues/204>). This has the advantage that it
  is much less resource intensive to detect changes. Previously changes were
  detected by comparing the raster pixel by pixel to the previous raster. It is
  also more reliable. For example when a plot command does not change the
  device, the device previously also didn't update, which could be confusing.
  Note that at the moment of release of this version of `terminalgraphics` this
  feature is not yet available in the version of `ragg` currently on CRAN.

* Determination of DPI of output handles missing resolution.

