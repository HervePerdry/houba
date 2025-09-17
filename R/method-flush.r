#' Flushes changes from a memory-mapped matrix
#'
#' @rdname flush
#' @param con a memory mapped object
#' @description Sync makes sure that the data written to the file linked with the object.
#' @details An error will be raised if the object is read-only, or if the operation failed.
#'
#' @return None
#'
#' @examples x <- as.mvector(1:50)
#' x <- x + 1
#' flush(x)
#'
#' @export
setGeneric('flush', function(con) standardGeneric('flush'))

# use "con" to be compatible with already existing generic "flush" 
#' @rdname flush
#' @export
setMethod("flush", signature(con = "memoryMapped"),
  function(con) {
    if(isnullptr(con@ptr)) {
      stop("This object has a broken ptr ! Try using restore()")
    } else if(con@readonly) {
      stop("Read-only object")
    } else {
      flush_(con@ptr, con@datatype)
    }
  }
)

