#' Descriptor file
#'
#' @rdname descriptor
#' @param object a mmatrix object
#' 
#' @details Creates a descriptor file, for reading the matrix with the package bigmemory or the \link{read.descriptor} function.
#'
#' @export
setGeneric("add.descriptor.file", function(object) standardGeneric("add.descriptor.file"))

#' @rdname descriptor
setMethod("add.descriptor.file", "mmatrix",
function(object) {
  mk.descriptor.file(object@file, object@dim[1], object@dim[2], object@datatype)
})
