#include "MMatrix.h"
#include <Rcpp.h>

// [[Rcpp::export]]
void flush_(SEXP pM, std::string datatype) {
    if (datatype == "float") { 
    Rcpp::XPtr<MMatrix<float>> instanc(pM);
    instanc->flush();
  } else if (datatype == "double") {
    Rcpp::XPtr<MMatrix<double>> instanc(pM);
    instanc->flush();
  } else if (datatype == "int") {
    Rcpp::XPtr<MMatrix<int>> instanc(pM);
    instanc->flush();
  } else if (datatype == "short") {
    Rcpp::XPtr<MMatrix<int16_t>> instanc(pM);
    instanc->flush();
  } else {
    throw std::runtime_error("Unsupported datatype for now !");
  }
}