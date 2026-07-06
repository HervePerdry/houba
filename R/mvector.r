#' @rdname marray
#' @export
mvector <- function(datatype = c("double", "float", "integer", "short"), length, filename, readonly, names) {
  datatype <- match.arg(datatype)
  if(missing(filename)) {
    filename <- tempfile("mmatrix")
    tmpfile <- FALSE
  } else {
    tmpfile <- TRUE
  }
  if(missing(readonly)) readonly <- file.exists(filename)
  # on the C++ size mvector are mmatrices with ncol = 1
  names <- if(missing(names)) NULL else names_check(names, length)
  ptr <- link_mmatrix(datatype, filename, length, 1L, tmpfile)
  if(isnullptr(ptr)) stop("Failed to map the mvector")
  new("mvector", ptr = ptr, file = filename, length = as.integer(length), datatype = datatype, 
      readonly = readonly, names = names)
}
