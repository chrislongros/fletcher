#include <R.h>
#include <Rinternals.h>
#include <stdint.h>
#include <stddef.h>
#include <stdio.h>

/*
 * Two running sums mod 2^k - 1, concatenated as (s2 << k/2) | s1.
 * Words are built up byte by byte so the result is the same on big- and
 * little-endian hosts; a trailing partial word is zero-padded.
 */

/* 8-bit blocks, mod 255 */
static uint16_t fletcher16(const uint8_t *d, size_t n) {
    uint32_t s1 = 0, s2 = 0;
    for (size_t i = 0; i < n; i++) {
        s1 = (s1 + d[i]) % 255;
        s2 = (s2 + s1)   % 255;
    }
    return (uint16_t)((s2 << 8) | s1);
}

/* 16-bit blocks, mod 65535 */
static uint32_t fletcher32(const uint8_t *d, size_t n) {
    uint32_t s1 = 0, s2 = 0;
    for (size_t i = 0; i < n; i += 2) {
        uint32_t w = d[i];
        if (i + 1 < n) w |= (uint32_t)d[i + 1] << 8;
        s1 = (s1 + w)  % 65535;
        s2 = (s2 + s1) % 65535;
    }
    return (s2 << 16) | s1;
}

/* 32-bit blocks, mod 2^32 - 1 */
static uint64_t fletcher64(const uint8_t *d, size_t n) {
    uint64_t s1 = 0, s2 = 0;
    for (size_t i = 0; i < n; i += 4) {
        uint64_t w = d[i];
        if (i + 1 < n) w |= (uint64_t)d[i + 1] << 8;
        if (i + 2 < n) w |= (uint64_t)d[i + 2] << 16;
        if (i + 3 < n) w |= (uint64_t)d[i + 3] << 24;
        s1 = (s1 + w)  % 0xffffffffULL;
        s2 = (s2 + s1) % 0xffffffffULL;
    }
    return (s2 << 32) | s1;
}

SEXP C_fletcher(SEXP raw, SEXP width) {
    const uint8_t *buf = RAW(raw);
    size_t n = (size_t) XLENGTH(raw);
    int w = INTEGER(width)[0];
    char out[17];
    if (w == 16) {
        snprintf(out, sizeof out, "%04x", fletcher16(buf, n));
    } else if (w == 32) {
        snprintf(out, sizeof out, "%08x", fletcher32(buf, n));
    } else {
        snprintf(out, sizeof out, "%016llx",
                 (unsigned long long) fletcher64(buf, n));
    }
    return mkString(out);
}
