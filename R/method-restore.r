#' Restore memory-mapped matrix
#'
#' @rdname restore
#' @param object a memory mapped matrix
#' @description When the external pointer is broken, 
#' attempt to recreate a valid object, if the file still exists.
#'
#' @return a memory-mapped object
#'
#' @examples a <- matrix(1:24, 4, 6)
#' A <- as.mmatrix(a, "float")
#' rdsfile <- tempfile(fileext = ".rds")
#' saveRDS(A, rdsfile)
#' A <- readRDS(rdsfile)
#' A
#' A <- restore(A)
#' A
#' 
#' @export
setGeneric("restore", function(object) standardGeneric("restore"))

#' @rdname restore
setMethod("restore", "marray",
  function(object) {
    if(!isnullptr(object@ptr)) {
      stop("This marray doesn't need to be restored !")
    } else {
      object@ptr = link_marray(object@datatype, object@file, object@dim)
    }
    object
  }
)

#' @rdname restore
setMethod("restore", "mmatrix",
  function(object) {
    if(!isnullptr(object@ptr)) {
      stop("This mmatrix doesn't need to be restored !")
    } else {
      object@ptr = link_mmatrix(object@datatype, object@file, object@dim[1], object@dim[2])
    }
    object
  }
)

#' @rdname restore
setMethod("restore", "mvector",
  function(object) {
    if(!isnullptr(object@ptr)) {
      stop("This mvector doesn't need to be restored !")
    } else {
      object@ptr = link_mmatrix(object@datatype, object@file, object@length, 1L)
    }
    object
  }
)
