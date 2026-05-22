#' Descriptor file
#'
#' @rdname descriptor
#' @param object a memory mapped object
#' 
#' @details Creates a descriptor file, similar to the descriptor files of the package 'bigmemomry'.
#' This descriptor allows to map the object with the package bigmemory, or the \link{read.descriptor} function
#' in this package. Its name is obtained by appending ".desc' to the name of the file mapped by 'object'.
#' @details A method is available for marrays as well, but the resulting descriptor can't be read by
#' 'bigmemory' as this package doesn't handle arrays. The function 'read.descriptor' in houba can read it.
#'
#' @seealso \code{read.descriptor}
#'
#' @return None.
#'
#' @examples A <- mmatrix("short", 10, 20)
#' A[] <- sample.int(200)
#' 
#' # create descriptor file 
#' dsc <- descriptor.file(A)
#' 
#' # linking file to other object
#' B <- read.descriptor(dsc, readonly = FALSE)
#' all(as.matrix(A) == as.matrix(B)) # TRUE
#' 
#' B[1:10] <- 0
#' all(A[1:10] == 0) # TRUE
#' 
#' @export
setGeneric("descriptor.file", function(object) standardGeneric("descriptor.file"))

#' @rdname descriptor
setMethod("descriptor.file", "mmatrix",
function(object) {
  mk.descriptor.file(object@file, object@dim[1], object@dim[2], object@datatype, object@dimnames)
})

#' @rdname descriptor
setMethod("descriptor.file", "mvector",
function(object) {
  mk.descriptor.file(object@file, object@length, 1L, object@datatype, list(object@names, NULL))
})

#' @rdname descriptor
setMethod("descriptor.file", "marray",
function(object) {
  mk.array.descriptor.file(object@file, object@dim, object@datatype, object@dimnames)
})
