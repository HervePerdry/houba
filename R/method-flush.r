#' Flushes changes from a memory-mapped matrix
#'
#' @rdname flush
#' @param object a memory mapped matrix
#' @description This will sync the content written to the file,
#' ensuring the changes are saved.
#' @details will only work if the object is not read-only
#'
#'
#' @export
setGeneric('flush', function(con) standardGeneric('flush'))

# object changed to "con" to be compatible with already existing generic "flush" 
#(particularly usefull with bigmemory)
#' @rdname flush
setMethod("flush", signature(con="marray"),
  function(con) {
    if(isnullptr(con@ptr)) {
      stop("This marray has a broken ptr ! Try using restore()")
    } else if(con@readonly) {
        stop("Read-only object")
    } else {
      flush_(con@ptr, con@datatype)
    }
    con
  }
)

#' @rdname flush
setMethod("flush", signature(con="mmatrix"),
  function(con) {
    if(isnullptr(con@ptr)) {
      stop("This mmatrix has a broken ptr ! Try using restore()")
    } else if(con@readonly) {
        stop("Read-only object")
    } else {
      flush_(con@ptr, con@datatype)
    }
    con
  }
)

#' @rdname flush
setMethod("flush", signature(con="mvector"),
  function(con) {
    if(isnullptr(con@ptr)) {
      stop("This mvector has a broken ptr ! Try using restore()")
    } else if(con@readonly) {
        stop("Read-only object")
    } else {
      flush_(con@ptr, con@datatype)
    }
    con
  }
)
