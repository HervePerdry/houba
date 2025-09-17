#' @rdname colSums
#' @export
setMethod("rowMeans", c(x = "mmatrix"), 
   function(x, output.type) { 
     nc <- ncol(x)
     nr <- nrow(x)
     if(houba("max.size") > nr){
       ans <- numeric(nr)
       rowSums_R_double(x@ptr, x@datatype, ans)
       ans <- ans/nc
     } else {
       if(!missing(output.type)) 
         ty <- output.type 
       else if(type(x) %in% c("integer","short"))
         ty <- "double"
       else
         ty <- x@datatype
       ans <- mvector(ty, nr)
       rowSums_mvector(x@ptr, x@datatype, ans@ptr, ans@datatype)
       inplace.div(ans, nc)
     }
     ans
   }
)

