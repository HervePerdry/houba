#' @rdname marray
#'
#' @export
mmatrix <- function(datatype = c("double", "float", "integer", "short"), nrow, ncol, filename, readonly, dimnames) {
  datatype <- match.arg(datatype)
  if(missing(filename)) filename <- tempfile("mmatrix")
  if(missing(readonly)) readonly <- file.exists(filename)
  dimnames <- if(missing(dimnames)) NULL else dimnames_check(dimnames, as.integer(c(nrow, ncol)))
  ptr <- link_mmatrix(datatype, filename, nrow, ncol)
  if(isnullptr(ptr)) stop("Failed to map the mmatrix")
  new("mmatrix", ptr = ptr, file = filename, dim = as.integer(c(nrow, ncol)), datatype = datatype, 
      readonly = readonly, dimnames = dimnames)
}
