#' Class \code{mvector}
#'
#' @name mvector-class
#' @docType class
#'
#' @description S4 class for manipulating memory-mapped files as vectors
#'
#' @slot ptr
#' \code{externalptr} to an instance of the C++ \code{MMatrix} class
#' @slot file
#' \code{character} with the path (absolute) of the file used to store the mvector
#' @slot length 
#' An integer giving the length of the mvector
#' @slot datatype
#' \code{character} giving the C++ underlying datatype.
#' @slot readonly \code{logical} Indicates if the vector if read-only.
#' 
#' @section Objects from the Class:
#' Objects can be created by calling \link{mvector}.
#'
#' @seealso \link{marray-class}, \link{mmatrix-class}
#'
#' @exportClass mvector
setClass("mvector", slots = c(ptr = "externalptr", file = "character", length = "integer", datatype = "character", readonly = "logical"))

setMethod("show", "mvector",
  function(object) {
    if(isnullptr(object@ptr)) {
      cat("A mvector with a broken external ptr ! Try using restore()\n")
    } else {
      if(object@readonly)
        cat("A read-only ")
      else
        cat("A ")
      cat("mvector of length", object@length, "\n")
      cat("data type: ", object@datatype, "\n")
      if(object@file == "") {
        cat("Location: memory\n")
      } else {
        cat("Location: file ", object@file, "\n")
      }
      cat("--- excerpt\n")
      n <- min(5,object@length)
      print(as.vector(object[seq_len(n)]))
    }
  }
)

#' Length of mvector
#'
#' @description returns the length of a mvector
#' @param x mvector
#'
#' @return an integer
#'
#' @export
setMethod("length", "mvector", function(x) x@length)
