#' @rdname marray
#' @description  The \code{mmatrix} function creates an object of class \link{mmatrix-class}, of
#' indicated types and dimension.
#' @details By default, the \code{mmatrix-class} is filled with 0.
#' This function is kind of acting as a manual constructor for \code{mmatrix-class}.
#' If you want to instanciate a \code{mmatrix-class} from a descriptor file, check \link{read.descriptor}.
#' @param type can be \code{double}, \code{float}, \code{int}, \code{short}
#' @param nrow number of rows
#' @param ncol number of columns
#' @param filename (optional)
#' the relative or absolute path to the file you want to store your \code{mmatrix-class}.
#' If omitted, \link{tempfile} is used to generate a file name for a temporary file.
#' @param readonly \code{logical} Indicates if the array is read-only.
#' @return the newly created \link{mmatrix-class}.
#' @export
mmatrix <- function(type = c("double", "float", "int", "short"), nrow, ncol, filename, readonly) {
  type <- match.arg(type)
  if(missing(filename)) filename <- tempfile("mmatrix")
  if(missing(readonly)) readonly <- file.exists(filename)
  ptr <- link_mmatrix(type, filename, nrow, ncol)
  if(isnullptr(ptr)) stop("Failed to map the mmatrix")
  new("mmatrix", ptr = ptr, file = filename, dim = as.integer(c(nrow, ncol)), datatype = type, readonly = readonly)
}
