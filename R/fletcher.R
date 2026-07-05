#' Compute a Fletcher checksum
#'
#' Computes Fletcher's position-dependent checksum. Input is processed as
#' little-endian words with the final partial word zero-padded, so the result
#' is reproducible across platforms.
#'
#' @param x A character string, a raw vector, or an integer/numeric vector of
#'   byte values (0-255) coercible with \code{as.raw}. Character input is
#'   converted with \code{charToRaw}.
#' @param width Checksum width in bits; one of \code{16}, \code{32}, or
#'   \code{64}.
#' @return A lowercase hexadecimal string of \code{width / 4} characters.
#' @examples
#' fletcher("abcde", 16)  # "c8f0"
#' fletcher("abcde", 32)  # "f04fc729"
#' fletcher("abcde", 64)  # "c8c6c527646362c6"
#' @export
fletcher <- function(x, width = 32L) {
  if (is.character(x)) {
    x <- charToRaw(paste(x, collapse = ""))
  } else if (!is.raw(x)) {
    x <- as.raw(x)
  }
  width <- as.integer(width)
  if (length(width) != 1L || !width %in% c(16L, 32L, 64L)) {
    stop("`width` must be one of 16, 32, or 64.")
  }
  .Call(C_fletcher, x, width)
}
