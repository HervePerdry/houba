#' Creation of memory mapped objects
#'
#' @name marray
#' @rdname marray
#'
#' @description These functions create memory mapped vectors, matrices or arrays, 
#' possibly from an existing file. It is also possible to create objects in memory,
#' by passing the argument \code{filename = ""}.
#'
#' @param datatype the data type
#' @param nrow number of rows of mmatrix
#' @param ncol number of columns of mmatrix
#' @param dim dimension of marray
#' @param length length of mvector
#' @param filename (optional) path to file
#' @param readonly (optional) if \code{TRUE}, the object will be read-only.
#' @param names (optional) a vector of names for mvector
#' @param dimnames (optional) a list of dimension names for mmatrix and marray
#'
#' @details Currently \code{datatype} can only be double, float, int, or short. Short will always be a 16 bits 
#' integer (int16_t). 
#' @details If \code{filename} is missing, a temporary filename will be generated using \code{tempfile}.
#' If it is an empty string, the object will be created by allocating memory.
#' Otherwise, \code{filename} must be a valid path file; 
#' if the file exists, it will be opened (if its size is compatible with the dimension
#' of the object); if the file does not exist, it will be created.
#' @details If \code{readonly} is missing, it will be set to \code{TRUE} when opening an existing file, and
#' to \code{FALSE} when the file is created by the function.
#' @details If \code{dimnames} is missing, it will be considered as 'NULL'
#'
#' @return a memory mapped object, of class 'mvector', 'mmatrix' or 'marray'
#'
#' @examples a <- mmatrix("float", 4, 3)
#' a[] <- 1:12
#' a[1,]
#'
#' @export
marray <- function(datatype = c("double", "float", "integer", "short"), dim, filename, readonly, dimnames) {
  datatype <- match.arg(datatype)
  if(missing(filename)) filename <- tempfile("mmatrix")
  if(missing(readonly)) readonly <- file.exists(filename)
  dimnames <- if(missing(dimnames)) NULL else dimnames_check(dimnames, as.integer(dim))
  ptr <- link_marray(datatype, filename, dim)
  if(isnullptr(ptr)) stop("Failed to map the marray")
  new("marray", ptr = ptr, file = filename, dim = as.integer(dim), datatype = datatype, readonly = readonly)
}
