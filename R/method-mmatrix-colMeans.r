#' @rdname colSums
#' @export
setMethod("colMeans", c(x = "mmatrix"), 
   function(x, output.type) { 
     nc <- ncol(x)
     nr <- nrow(x)
     if(houba("max.size") > nc){
       ans <- numeric(nc)
       colSums_R_double(x@ptr, x@datatype, ans)
       ans <- ans/nr
     } else {
       if(!missing(output.type)) 
         ty <- output.type 
       else if(type(x) %in% c("integer","short"))
         ty <- "double"
       else
         ty <- x@datatype
       ans <- mvector(ty, nc)
       colSums_mvector(x@ptr, x@datatype, ans@ptr, ans@datatype)
       inplace.div(ans, nr)
     }
     ans
   }
)

