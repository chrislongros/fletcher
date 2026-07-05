#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>

extern SEXP C_fletcher(SEXP, SEXP);

static const R_CallMethodDef CallEntries[] = {
    {"C_fletcher", (DL_FUNC) &C_fletcher, 2},
    {NULL, NULL, 0}
};

void R_init_fletcher(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
