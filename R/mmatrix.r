#' @rdname marray
#'
#' @export
mmatrix <- function(datatype = c("double", "float", "integer", "short"), nrow, ncol, filename, readonly) {
  datatype <- match.arg(datatype)
  if(missing(filename)) filename <- tempfile("mmatrix")
  if(missing(readonly)) readonly <- file.exists(filename)
  ptr <- link_mmatrix(datatype, filename, nrow, ncol)
  if(isnullptr(ptr)) stop("Failed to map the mmatrix")
  new("mmatrix", ptr = ptr, file = filename, dim = as.integer(c(nrow, ncol)), datatype = datatype, readonly = readonly)
}
