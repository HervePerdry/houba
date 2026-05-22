#' @rdname as-array
#' @exportS3Method as.vector mvector
as.vector.mvector <- function(x, mode = "any") {
  if(isnullptr(x@ptr)) {
    stop("This mvector has a broken ptr, try re-mapping it with restore()")
  } else {
    V <- MMatrixToRMatrix(x@ptr, x@datatype)
    V <- as.vector(V)
    names(V) <- x@names
    V
  }
}
