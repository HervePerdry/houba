#' Length of memory mapped object
#'
#' @rdname length-mmap
#' @description returns the length of a memory mapped object 
#' @param x mvector, mmatrix or marray
#'
#' @details for memory mapped matrices and arrays, it is the total data length
#'
#' @return an integer
#'
#' @export
setMethod("length", "mvector", function(x) x@length)


#' @rdname length-mmap
#' @export
setMethod("length", "mmatrix", function(x) prod(x@dim))

#' @rdname length-mmap
#' @export
setMethod("length", "marray", function(x) prod(x@dim))

