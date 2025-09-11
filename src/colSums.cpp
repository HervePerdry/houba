#include "MMatrix.h"
#include <cstdint> // for int16_t
#include <Rcpp.h>

// ------- result est un R vector -------------
// [[Rcpp::export]]
void colSums_R(SEXP pM, std::string datatype, SEXP result) {
  if (datatype == "float") { 
    Rcpp::XPtr<houba::MMatrix<float>> instanc(pM);
    Rcpp::NumericVector res(result);
    instanc->colSums(res);
  } else if (datatype == "double") {
    Rcpp::XPtr<houba::MMatrix<double>> instanc(pM);
    Rcpp::NumericVector res(result);
    instanc->colSums(res);
  } else if (datatype == "int") {
    Rcpp::XPtr<houba::MMatrix<int>> instanc(pM);
    Rcpp::IntegerVector res(result);
    instanc->colSums(res);
  } else if (datatype == "short") {
    Rcpp::XPtr<houba::MMatrix<int16_t>> instanc(pM);
    Rcpp::IntegerVector res(result);
    instanc->colSums(res);
  } else {
    throw std::runtime_error("Unsupported datatype for now !");
  }
}

