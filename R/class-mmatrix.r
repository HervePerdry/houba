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
#' 
#' @section Objects from the Class:
#' Objects can be created by calling \link{mmatrix}.
#'
#' @seealso \link{marray-class}, \link{mvector-class}
#' @seealso \link{read.descriptor}, \link{add.descriptor.file}
#'
#' @exportClass mmatrix
setClass("mmatrix", slots = c(ptr = "externalptr", file = "character", dim = "integer", datatype = "character", readonly = "logical"))

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
      cat("File:", object@file, "\n")
      cat("--- excerpt\n")
      if( (savevalue <- houba("max.size")) < 25 )
        houba(max.size = 25)
      n <- min(5,nrow(object))
      m <- min(5,ncol(object))
      print(object[seq_len(n), seq_len(m)])
      houba(max.size = savevalue)
    }
  }
)
