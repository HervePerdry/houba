#' @rdname colSums
#' @export
setMethod("rowSums", c(x = "mmatrix"), 
   function(x, output.type) { 
     nr <- nrow(x)
     if(houba("max.size") > nr){
       if(type(x) %in% c("int","short")) {
         ans <- integer(nr)
         rowSums_R_int(x@ptr, x@datatype, ans)
       } else {
         ans <- numeric(nr)
         rowSums_R_double(x@ptr, x@datatype, ans)
       }
     } else {
       if(!missing(output.type)) 
         ty <- output.type 
       else if(type(x) %in% c("int","short"))
         ty <- "int"
       else
         ty <- x@datatype
       ans <- mvector(ty, nr)
       rowSums_mvector(x@ptr, x@datatype, ans@ptr, ans@datatype)
     }
     ans
   }
)

