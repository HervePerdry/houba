#include "MMatrix.h"
#include <Rcpp.h>
#include "apply.h"

class _fl_ {
  public:
    // pour pouvoir utiliser le template apply_R, il faut prendre un 2e argument
    // qu'on ne va pas utiliser
    template<typename T>
    inline void operator()(Rcpp::XPtr<houba::MMatrix<T>> M, Rcpp::IntegerVector) {
      M->flush();
    }
};

// [[Rcpp::export]]
void flush_(SEXP pM, std::string datatype) {
  _fl_ x;
  Rcpp::IntegerVector dummy(0); // juste à cause du format du template, il faut un argument de plus
  apply_R(pM, datatype, dummy, x);
}

