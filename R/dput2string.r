
dput2string <- function(x) {
  zz <- textConnection("res", "w")
  dput(x, zz)
  close(zz)
  paste0(res, collapse = "")
}
