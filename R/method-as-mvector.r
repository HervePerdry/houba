
#' @rdname as-marray
#' @export
setGeneric("as.mvector", function(x, datatype, filename) standardGeneric("as.mvector"), package = "houba")

setMethod("as.mvector", "numeric",
   function(x, datatype, filename) { 
     if(missing(datatype)) {
       datatype <- if(typeof(x) == "double") "double" else "int"
     }
     r <- mvector(datatype, length(x), filename)
     copy_values(r, x)
   }
)


