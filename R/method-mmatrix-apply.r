#' @title Apply functions over margins of a mmatrix
#' @name apply
#' @aliases apply,mmatrix-method
#'
#' @description This method generalizes `base::apply` to mmatrix objects
#'
#' @param X a mmatrix
#' @param MARGIN an integer giving the subscript which the function will be applied over
#' @param FUN the function to be applied
#' @param ... extra arguments for `FUN`
#' @param simplify a logical indicating whether the results should be simplified
#'
#' @details If 'simplify' is TRUE the result will be a vector or a matrix, depending
#' on the size of the values returned by 'FUN'. If the size of this object is greater
#' than \code{houba(max.size)}, then it will be memory-mapped (i.e., either a mvector
#' or a mmatrix). If 'simplify' is FALSE, the result is a list.
#'
#' @details The function extracts the rows or the columns of 'X' one by one, to a R
#' object, which is passed to 'FUN'. 
#'
#' @return If 'simplify' is TRUE, a matrix (or a mmatrix) or a vector (or a mvector). 
#' If 'simplify' is FALSE, a list.
#'
#' @examples a <- matrix(1:6, 2, 3)
#' A <- as.mmatrix(a)
#' apply(A, 1, var)
#' apply(A, 2, var)
#'
#' @seealso \code{\link[base:apply]{base:apply}}
#' 
#' @export
setMethod("apply", c(X = "mmatrix"), 
   function(X, MARGIN, FUN, ..., simplify = TRUE) {
     FUN <- match.fun(FUN)
     simplify <- isTRUE(simplify)
     d <- dim(X)
     if(is.character(MARGIN)) 
       stop("Mmatrix objects don't have dimnames, 'MARGIN' should be 1 or 2")
     MARGIN <- as.integer(MARGIN)
     if(!(MARGIN %in% 1:2))
       stop("'MARGIN' should be 1 or 2")
       
     nc <- ncol(X)
     nr <- nrow(X)

     if(MARGIN == 1L) { # prepare apply to rows
       if( (savevalue <- houba("max.size")) < nc )
          houba(max.size = nc) # pour que les extractions soient vers des objets R
     
       # premier elt du résultat
       tmp <- forceAndCall(1, FUN, X[1,], ...)
       nr.ans <- length(tmp)
       nc.ans <- nr
     } else {  # apply to cols
       if( (savevalue <- houba("max.size")) < nr )
          houba(max.size = nr) # cf ci dessus
     
       # premier elt
       tmp <- forceAndCall(1, FUN, X[,1], ...)
       nr.ans <- length(tmp)
       nc.ans <- nc
     }
   
     if(simplify) { # determine dimensions of result
       le.ans <- nr.ans * nc.ans
       if(le.ans > savevalue) { # big answer !
         ty <- typeof(tmp)
         if( !(ty %in% c("integer", "double")) )
           stop("Result size greater than houba(max.size), with type we can't handle")
         ans <- mmatrix(ty, nr.ans, nc.ans)
         ans[,1] <- tmp
       } else { # small answer
         ans <- matrix(tmp, nr.ans, nc.ans)
       }
     } else { # don't simplify: answer is a list
       ans <- vector("list", nc.ans)
       ans[[1]] <- tmp
     }

     I <- seq_len(nc.ans)[-1L] # on a déjà fait le premier élt
     for(i in I) {
       if(MARGIN == 1L) { # apply to rows
         tmp <- forceAndCall(1, FUN, X[i,], ...)
       } else { # to cols
         tmp <- forceAndCall(1, FUN, X[,i], ...)
       }
       if(simplify) {
         if(length(tmp) != nr.ans) 
           stop("Can't simplify, results don't all have same length")
         ans[,i] <- tmp
       } else {
         if(!is.null(tmp)) ans[[i]] <- tmp
       }
     }
     # restore saved value
     houba(max.size = savevalue)
     if(simplify) { # drop dimension if possible
       if(nrow(ans) == 1L) dim(ans) <- NULL
     }
     ans
   }
)

