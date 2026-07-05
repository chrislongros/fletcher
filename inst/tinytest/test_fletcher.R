library(fletcher)

# Check vectors from the Fletcher's checksum article.
expect_equal(fletcher("abcde",    16), "c8f0")
expect_equal(fletcher("abcdef",   16), "2057")
expect_equal(fletcher("abcdefgh", 16), "0627")

expect_equal(fletcher("abcde",    32), "f04fc729")
expect_equal(fletcher("abcdef",   32), "56502d2a")
expect_equal(fletcher("abcdefgh", 32), "ebe19591")

expect_equal(fletcher("abcde",    64), "c8c6c527646362c6")
expect_equal(fletcher("abcdef",   64), "c8c72b276463c8c6")
expect_equal(fletcher("abcdefgh", 64), "312e2b28cccac8c6")

# Raw and integer input match character input.
expect_equal(fletcher(charToRaw("abcde"), 32), fletcher("abcde", 32))
expect_equal(fletcher(as.integer(charToRaw("abcde")), 32), fletcher("abcde", 32))

# Empty input gives zero.
expect_equal(fletcher("", 16), "0000")

# Widths other than 16/32/64 are rejected.
expect_error(fletcher("abc", 8))
