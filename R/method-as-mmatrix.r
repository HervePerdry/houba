#' Conversion of R objects to memory mapped objects
#'
#' @rdname as-marray
#' 
#' @param x an r object
#' @param datatype (optional) type of the memory mapped object
#' @param filename (optional) path to file
#'
#' @details If 'filename' is a path to an existing file, the function will raise an error.
#' If you need to overwrite a file, unlink it first.
#'
#' @return A memmory-mapped object, of class 'mvector', 'mmatrix' or 'marray'
#'
#' @examples a <- matrix(1:6, 2)
#' A <- as.mmatrix(a)
#' B <- as.mmatrix(a, "float")
#' A
#' B
#'
#' @export
setGeneric("as.mmatrix", function(x, datatype, filename) standardGeneric("as.mmatrix"), package = "houba")

#' @rdname as-marray
#' @export
setMethod("as.mmatrix", "matrix",
   function(x, datatype, filename) { 
     if(missing(datatype)) {
       datatype <- if(typeof(x) == "double") "double" else "integer"
     }
     r <- mmatrix(datatype, nrow(x), ncol(x), filename)
     copy_values(r, x)
   }
)


