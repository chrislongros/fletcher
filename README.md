# fletcher

Fletcher's checksum for R, in 16-, 32-, and 64-bit widths.

Fletcher's checksum keeps two running sums as it walks the input and
concatenates them into the result. It catches the reordering and
single-bit errors a plain sum misses, at a fraction of the cost of a CRC.
The algorithm lives in C; the R side is a thin wrapper.

## Install

```r
# install.packages("remotes")
remotes::install_github("chrislongros/fletcher")
```

## Use

```r
library(fletcher)

fletcher("abcde", 16)  # "c8f0"
fletcher("abcde", 32)  # "f04fc729"
fletcher("abcde", 64)  # "c8c6c527646362c6"
```

`x` can be a string, a raw vector, or a vector of byte values:

```r
fletcher(charToRaw("abcde"), 32)          # "f04fc729"
fletcher(as.integer(charToRaw("abcde")))  # width defaults to 32
```

The result is a lowercase hex string of `width / 4` characters.

## Details

Input is read as little-endian words, so the output does not depend on the
host's byte order. A final partial word is zero-padded. The running sums
start at zero and reduce modulo `2^(width/2) - 1`; the checksum is the high
sum shifted over the low sum.

## License

MIT.
