#' Class \code{"mmatrix"}
#'
#' @name mmatrix-class
#' @docType class
#' 
#' @description S4 class for manipulating memory-mapped files as matrices
#' 
#' @slot ptr
#' \code{externalptr} to an instance of the C++ \code{MMatrix} class
#' @slot file
#' \code{character} with the path (absolute) of the file used to store the mmatrix
#' @slot dim
#' An integer vector giving the dimensions of the mmatrix
#' @slot datatype
#' \code{character} giving the C++ underlying datatype.
#' @slot readonly \code{logical} Indicates if the array is read-only.
#' @slot dimnames optional dimnames (just as for a R matrix).
#' 
#' @section Objects from the Class:
#' Objects can be created by calling \link{mmatrix}.
#'
#' @seealso \link{marray-class}, \link{mvector-class}
#'
#' @exportClass mmatrix
setClass("mmatrix", slots = c(ptr = "externalptr", file = "character", dim = "integer", 
   datatype = "character", readonly = "logical", dimnames = "listOrNULL"))

setMethod("show", "mmatrix",
  function(object) {
    if(isnullptr(object@ptr)) {
      cat("A mmatrix with a broken external ptr ! Try using restore()\n")
    } else {
      if(object@readonly)
        cat("A read-only ")
      else
        cat("A ")
      cat("mmatrix with", nrow(object), "rows and", ncol(object), "cols\n")
      cat("data type: ", object@datatype, "\n")
      if(object@file == "") {
        cat("Location: memory\n")
      } else {
        cat("Location: file ", object@file, "\n")
      }
      cat("--- excerpt\n")
      n <- min(5,nrow(object))
      m <- min(5,ncol(object))
      print(as.matrix(object[seq_len(n), seq_len(m)]))
    }
  }
)
