#' @title Row and Columns sums and meands
#'
#' @description Methods generalizing the base methods to mmatrix objects
#'
#' @param x a dual matrix or array
#' @param na.rm if 'TRUE', missing values are removed
#' @param dims which dimensions are regarded as rows and cols
#' @param ... extra parameters (ignored)
#'
#'
#' @details If the size of the result is greater
#' than \code{houba(max.size)}, then it will be a mvector instead of R object.
#'
#' @export
setMethod("colSums", c(x = "mmatrix"), 
   function(x, output.type) { browser()
     nc <- ncol(x)
     if(houba("max.size") > nc){
       if(type(x) %in% c("int","short"))
         ans <- integer(nc)
       else
         ans <- numeric(nc)
       colSums_R(x@ptr, x@datatype, ans)
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

