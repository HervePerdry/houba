#include "MMatrix.h"
#include <cstdint> // for int16_t
#include <Rcpp.h>
#include "apply.h"

class rs {
  public:

    template<typename T, int T2>
    inline void operator()(Rcpp::XPtr<houba::MMatrix<T>> instanc, Rcpp::Vector<T2> result) {
      instanc->rowSums(result);
    }

    template<typename T, typename T2>
    inline void operator()(Rcpp::XPtr<houba::MMatrix<T>> instanc, Rcpp::XPtr<houba::MMatrix<T2>> result) {
      instanc->rowSums(*result);
    }
};


// ------- result est un R vector -------------
// [[Rcpp::export]]
void rowSums_R_double(SEXP pM, std::string datatype, Rcpp::NumericVector result) {
  rs x;
  apply_R(pM, datatype, result, x);
}

// [[Rcpp::export]]
void rowSums_R_int(SEXP pM, std::string datatype, Rcpp::IntegerVector result) {
  rs x;
  apply_R(pM, datatype, result, x);
}

// -------- result est un pointeur vers une mmatrix de type restype 
// [[Rcpp::export]]
void rowSums_mvector(SEXP pM, std::string datatype, SEXP result, std::string restype) {
  rs x;
  apply_mmatrix(pM, datatype, result, restype, x);
}

