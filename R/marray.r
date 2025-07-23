#' Creation of memory mapped objects
#'
#' @name marray
#' @rdname marray
#'
#' @description These functions create memory mapped vectors, matrices or arrays, 
#' possibly from an existing file.
#'
#' @param type the data type
#' @param nrow number of rows of mmatrix
#' @param ncol number of columns of mmatrix
#' @param dim dimension of marray
#' @param length length of mvector
#' @param filename (optional) path to file
#' @param readonly (optional) if \code{TRUE}, the object will be read-only.
#'
#' @details Currently \code{type} can only be double, float, int, or short. Short will always be a 16 bits 
#' integer (int16_t). 
#' @details If \code{filename} is missing, a temporary filename will be generated using \code{tempfile}.
#' In the contrary case, is the file exists, it will be opened (if its size is compatible with the dimension
#' of the object); if the file does not exist, it will be created.
#' @details If \code{readonly} is missing, it will be set to \code{TRUE} when opening an existing file, and
#' to \code{FALSE} when the file is created by the function.
#' 
#' @export
marray <- function(type = c("double", "float", "int", "short"), dim, filename, readonly) {
  type <- match.arg(type)
  if(missing(filename)) filename <- tempfile("mmatrix")
  if(missing(readonly)) readonly <- file.exists(filename)
  ptr <- link_marray(type, filename, dim)
  if(isnullptr(ptr)) stop("Failed to map the marray")
  new("marray", ptr = ptr, file = filename, dim = as.integer(dim), datatype = type, readonly = readonly)
}
