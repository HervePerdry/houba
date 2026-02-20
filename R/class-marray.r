#' Class \code{"marray"}
#'
#' @name marray-class
#' @docType class
#' 
#' @description S4 class for manipulating memory-mapped files as arrays 
#' 
#' @slot ptr
#' \code{externalptr} to an instance of the C++ \code{MMatrix} class
#' @slot file
#' \code{character} with the path (absolute) of the file used to store the marray.
#' @slot dim
#' An integer vector giving the dimensions of the marray.
#' @slot datatype
#' \code{character} giving the C++ underlying datatype.
#' @slot readonly \code{logical} Indicates if the array if read-only.
#' 
#' @section Objects from the Class:
#' Objects can be created by calling \link{marray}.
#'
#' @seealso \link{mmatrix-class}, \link{mvector-class}
#'
#' @exportClass marray
setClass("marray", slots = c(ptr = "externalptr", file = "character", dim = "integer", datatype = "character", readonly = "logical"))

setMethod("show", "marray",
  function(object) {
    if(isnullptr(object@ptr)) {
      cat("A marray with a broken external ptr ! Try using restore()\n")
    } else {
      if(object@readonly)
        cat("A read-only ")
      else 
        cat("A ")
      cat("marray with dimensions", paste(object@dim, sep =", "), "\n")
      cat("data type: ", object@datatype, "\n")
      if(object@file == "") {
        cat("Location: memory\n")
      } else {
        cat("Location: file ", object@file, "\n")
      }
    }
  }
)
