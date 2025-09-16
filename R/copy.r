#' Copy memory mapped object
#'
#' @rdname copy
#' @aliases copy
#' 
#' @param x a memory mapped object
#' @param filename (optional) a file name for the new object
#' 
#' @details Creates a new memory mapped object, identical to \code{x}.
#'
#' @return A memory mapped object.
#'
#' @examples a <- as.mvector(1:4)
#' b <- copy(a)
#' a
#' b
#' 
#' @export 
copy <- function(x, filename) UseMethod("copy")

#' @rdname copy
setMethod("copy", c(x = "mvector"), 
  function(x, filename) {
    a <- mvector(x@datatype, x@length, filename)
    copy_values_mm(a, x)
    a
  }
)

#' @rdname copy
setMethod("copy", c(x = "mmatrix"), 
  function(x, filename) {
    a <- mmatrix(x@datatype, x@dim[1], x@dim[2], filename)
    copy_values_mm(a, x)
    a
  }
)

#' @rdname copy
setMethod("copy", c(x = "marray"), 
  function(x, filename) {
    a <- marray(x@datatype, x@dim, filename)
    copy_values_mm(a, x)
    a
  }
)


