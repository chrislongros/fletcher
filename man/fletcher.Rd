\name{fletcher}
\alias{fletcher}
\title{Compute a Fletcher checksum}
\usage{
fletcher(x, width = 32L)
}
\arguments{
\item{x}{A character string, a raw vector, or an integer/numeric vector of
byte values (0-255) coercible with \code{as.raw}. Character input is
converted with \code{charToRaw}.}

\item{width}{Checksum width in bits; one of \code{16}, \code{32}, or
\code{64}.}
}
\value{
A lowercase hexadecimal string of \code{width / 4} characters.
}
\description{
Computes Fletcher's position-dependent checksum. Input is processed as
little-endian words with the final partial word zero-padded, so the result
is reproducible across platforms.
}
\examples{
fletcher("abcde", 16)  # "c8f0"
fletcher("abcde", 32)  # "f04fc729"
fletcher("abcde", 64)  # "c8c6c527646362c6"
}
