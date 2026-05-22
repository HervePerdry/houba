#' @rdname as-marray
#' @export
setGeneric("as.mvector", function(x, datatype, filename) standardGeneric("as.mvector"), package = "houba")

#' @rdname as-marray
#' @export
setMethod("as.mvector", "numeric",
   function(x, datatype, filename) { 
     if(missing(datatype)) {
       datatype <- if(typeof(x) == "double") "double" else "integer"
     }
     r <- mvector(datatype, length(x), filename, names = names(x))
     copy_values(r, x)
   }
)


