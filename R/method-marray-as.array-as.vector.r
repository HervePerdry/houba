#' Converting memory-mapped objects to R objects
#'
#' @rdname as-array
#' 
#' @param x memory-mapped object to convert
#' @param mode the mode oh the created vector
#' @param ... extra parameters (ignored)
#'
#' @return an array
#' 
#' @examples a <- array( 1:24, c(2,3,4) )
#' A <- as.marray(a)
#' all(as.array(A) == a)
#' as.vector(A)
#'
#' @exportS3Method as.array marray
as.array.marray <- function(x, ...) {
  if(isnullptr(x@ptr)) {
    stop("This mvector has a broken ptr, try re-mapping it with restore()")
  } else {
    R <- MMatrixToRArray(x@ptr, x@datatype)
    dimnames(R) <- x@dimnames
    R
  }
}

#' @rdname as-array
#' @exportS3Method as.vector marray
as.vector.marray <- function(x, mode = "any") {
  if(isnullptr(x@ptr)) {
    stop("This mmatrix has a broken ptr, try re-mapping it with restore()")
  } else {
    R <- MMatrixToRArray(x@ptr, x@datatype)
    as.vector(R, mode)
  }
}
