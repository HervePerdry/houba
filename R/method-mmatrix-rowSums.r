#' @rdname colSums
#' @export
setMethod("rowSums", c(x = "mmatrix"), 
   function(x, output.type) { 
     nr <- nrow(x)
     if(houba("max.size") > nr){
       if(type(x) %in% c("integer","short")) {
         ans <- integer(nr)
         rowSums_R_int(x@ptr, x@datatype, ans)
       } else {
         ans <- numeric(nr)
         rowSums_R_double(x@ptr, x@datatype, ans)
       }
     } else {
       if(!missing(output.type)) 
         ty <- output.type 
       else if(type(x) %in% c("integer","short"))
         ty <- "integer"
       else
         ty <- x@datatype
       ans <- mvector(ty, nr)
       rowSums_mvector(x@ptr, x@datatype, ans@ptr, ans@datatype)
     }
     ans
   }
)

