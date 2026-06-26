
dput2string <- function(x) {
  res <- NULL
  zz <- textConnection("res", "w", local = TRUE)
  dput(x, zz)
  close(zz)
  paste0(res, collapse = "")
}
