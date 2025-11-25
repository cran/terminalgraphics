#' Dump an image raster to the terminal using the Terminal Graphics Protocol
#'
#' @param raster the image 'raster' e.g. the output of \code{\link{as.raster}}.
#'
#' @param compress compress the data before sending to the terminal.
#'
#' @details
#' The Terminal Graphics Protocol is not supported by many Terminal Emulators.
#' The most notable terminal emulator supporting the protocol is Kitty.
#'
#' @return
#' Called for it's side effect of writing the image to the terminal (standard
#' out). Returns \code{NULL} invisibly.
#'
#' @seealso
#' See \code{\link{raster2sixel}} for output in Sixel format. See
#' \code{\link{png2terminal}} for writing a PNG image to the terminal.
#'
#' @importFrom base64enc base64encode
#' @export
raster2tgp <- function(raster, compress = TRUE) {
  warn_tgp_support()

  td <- term_dim()
  support <- query_tgp_support()

  # Convert the raster to raw byte vector
  bytes <- 24
  if (methods::is(raster, "nativeRaster")) {
    r <- bitwAnd(bitwShiftR(raster, 0), 255)
    g <- bitwAnd(bitwShiftR(raster, 8), 255)
    b <- bitwAnd(bitwShiftR(raster, 16), 255)
    a <- bitwAnd(bitwShiftR(raster, 24), 255)
    data <- rbind(r,g,b,a) |> as.vector() |> as.raw()
    bytes <- 32
  } else {
    data <- t(raster) |> grDevices::col2rgb() |> as.vector() |> as.raw() 
  }

  # Calculate image dimensions in units of terminal characters
  cols <- ceiling(ncol(raster) / (td[["x_pixels"]] %/% td[["columns"]]))
  rows <- ceiling(nrow(raster) / (td[["y_pixels"]] %/% td[["rows"]]))

  # Build control character prefix for transmitting image
  control <- character()
  control[["a"]] <- "T" # type of transmission; T = data & image display
  control[["f"]] <- bytes # image format; 24bit RGB
  control[["q"]] <- 2 # suppress terminal response
  control[["s"]] <- ncol(raster) # image width in pixels
  control[["v"]] <- nrow(raster) # image height
  control[["i"]] <- next_tgp_id()

  # If a protocol is required, render as a virtual placeholder
  if (!is.na(support) && nzchar(support)) {
    control[["U"]] <- 1
    control[["c"]] <- cols # number of columns to display image over
    control[["r"]] <- rows # number of rows to display image over
  }

  if (compress) {
    data <- memCompress(data)
    control[["o"]] <- "z" # type of compression
  }

  # Encode
  payloads <- base64enc::base64encode(data, 4096)

  # Send the chunks to the terminal
  for (i in seq_along(payloads)) {
    control[["m"]] <- as.integer(i != length(payloads))
    controlstring <- paste0(names(control), "=", control, collapse = ",")
    out <- paste0("\033_G", controlstring, ";", payloads[i], "\033\\")
    out <- with_tgp_protocol(out)
    cat(out)
  }

  # If a virtual placeholder is used, emit placeholder characters
  if ("U" %in% names(control)) {
    flag <- "\U10EEEE"
    prefix <- paste0("\r\033[38;5;", control[["i"]], "m")
    suffix <- paste0("\033[39m")
    x_cols <- min(as.integer(control[["c"]]), td[["columns"]])
    col_str <- strrep(flag, x_cols - 1L)
    row_str <- tgp_diacritics[seq_len(as.integer(control[["r"]]))]
    row_out <- paste0(prefix, flag, row_str, col_str, suffix)
    cat(paste0(row_out, collapse = "\n"))
  }

  invisible(NULL)
}

next_tgp_id <- local({
  id <- 0L
  function() id <<- id + 1L
})

