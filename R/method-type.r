#' Type of a memory-mapped object
#'
#' @rdname type
#' @name type
#'
#' @param x a memory mapped object
#'
#' @details Sends back the stored data type (currently "double", "float", "integer" or "short").
#'
#' @return a string
#'
#' @examples x <- mvector("integer", 6)
#' type(x)
#'
#' @export
setGeneric("type", function(x) standardGeneric("type"))

#' @rdname type
setMethod("type", c(x = "memoryMapped"), 
  function(x) x@datatype
)
