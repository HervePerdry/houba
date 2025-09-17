#' @rdname as-marray
#' @export
setGeneric("as.marray", function(x, datatype, filename) standardGeneric("as.marray"), package = "houba")

#' @rdname as-marray
#' @export
setMethod("as.marray", "array",
   function(x, datatype, filename) { 
     if(missing(datatype)) {
       datatype <- if(typeof(x) == "double") "double" else "integer"
     }
     r <- marray(datatype, dim(x), filename)
     copy_values(r, x)
   }
)


