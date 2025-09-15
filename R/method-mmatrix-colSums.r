#' @title Row and Columns sums and means
#' @name colSums
#'
#' @description Methods generalizing the base methods to mmatrix objects
#'
#' @param x a dual matrix or array
#' @param output.type type of the result, if it's a mvector (see details)
#'
#'
#' @details If the size of the result is greater
#' than \code{houba(max.size)}, then it will be a mvector instead of R object.
#' In this case its type will be determined using 'output.type'. If 'output.type'
#' is missing, a coherent choice will be made.
#'
#' @export
setMethod("colSums", c(x = "mmatrix"), 
   function(x, output.type) { 
     nc <- ncol(x)
     if(houba("max.size") > nc){
       if(type(x) %in% c("int","short")) {
         ans <- integer(nc)
         colSums_R_int(x@ptr, x@datatype, ans)
       } else {
         ans <- numeric(nc)
         colSums_R_double(x@ptr, x@datatype, ans)
       }
     } else {
       if(!missing(output.type)) 
         ty <- output.type 
       else if(type(x) %in% c("int","short"))
         ty <- "int"
       else
         ty <- x@datatype
       ans <- mvector(ty, nc)
       colSums_mvector(x@ptr, x@datatype, ans@ptr, ans@datatype)
     }
     ans
   }
)

