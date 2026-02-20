#include "MMatrix.h"
#include <Rcpp.h>
#include "apply.h"

class svv {
  Rcpp::IntegerVector I;
  public:
    svv(Rcpp::IntegerVector I_) : I(I_) {}

    template<typename T, int T2>
    inline void operator()(Rcpp::XPtr<houba::MMatrix<T>> instance, Rcpp::Vector<T2> values) {
      instance->set_values_vector(I, values);
    }

    template<typename T, typename T2>
    inline void operator()(Rcpp::XPtr<houba::MMatrix<T>> instance, Rcpp::XPtr<houba::MMatrix<T2>> values) {
      instance->set_values_vector(I, *values);
    }
};

// values est un Rvector
// [[Rcpp::export]]
void set_values_mvector(SEXP pM, std::string datatype, Rcpp::IntegerVector I, SEXP values) {
  svv x(I);
  apply_R(pM, datatype, values, x); 
}

// values est un pointeur vers une mmatrix
// [[Rcpp::export]]
void set_values_mvector_mm(SEXP pM, std::string datatype, Rcpp::IntegerVector I, SEXP values, std::string valtype) {
  svv x(I);
  apply_mmatrix(pM, datatype, values, valtype, x); 
}


