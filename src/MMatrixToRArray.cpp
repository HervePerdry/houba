#include "MMatrix.h"
#include <cstdint> // for int16_t
#include <Rcpp.h>

// [[Rcpp::export]]
SEXP MMatrixToRArray(SEXP pM, std::string datatype) {
  if (datatype == "float") { 
    // comment faire un check plus délicat sur la validité du ptr vers la MMatrix ?
    Rcpp::XPtr<MMatrix<float>> instanc(pM);

    unsigned int s = instanc->size();
    Rcpp::NumericVector R(s);
    for(unsigned int i = 0; i < s; i++) {
      R[i] = (*instanc)[i]; 
    }
    R.attr("dim") = Rcpp::wrap(instanc->dim());

    return R;
  } else if (datatype == "double") {
    Rcpp::XPtr<MMatrix<double>> instanc(pM);

    unsigned int s = instanc->size();
    Rcpp::NumericVector R(s);
    for(unsigned int i = 0; i < s; i++) {
      R[i] = (*instanc)[i]; 
    }
    R.attr("dim") = Rcpp::wrap(instanc->dim());

    return R;
  } else if (datatype == "int") {
    Rcpp::XPtr<MMatrix<int>> instanc(pM);

    unsigned int s = instanc->size();
    Rcpp::IntegerVector R(s);
    for(unsigned int i = 0; i < s; i++) {
      R[i] = (*instanc)[i]; 
    }
    R.attr("dim") = Rcpp::wrap(instanc->dim());

    return R;
  } else if (datatype == "short") {
    Rcpp::XPtr<MMatrix<int16_t>> instanc(pM);

    unsigned int s = instanc->size();
    Rcpp::IntegerVector R(s);
    for(unsigned int i = 0; i < s; i++) {
      R[i] = (*instanc)[i]; 
    }
    R.attr("dim") = Rcpp::wrap(instanc->dim());

    return R;
  } else {
    throw std::runtime_error("Unsupported datatypes for now ! This mmatrix will not be translated.");
  }
}
