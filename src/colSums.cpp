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

// -------- result est un pointeur vers une mmatrix de type restype 
//

template<typename T>
inline void colSums(T instanc, SEXP result, std::string restype) {
  if(restype == "float") {
    Rcpp::XPtr<houba::MMatrix<float>> res(result);
    instanc->colSums(*res);
  } else if(restype == "double") {
    Rcpp::XPtr<houba::MMatrix<double>> res(result);
    instanc->colSums(*res);
  } else if(restype == "int") {
    Rcpp::XPtr<houba::MMatrix<int>> res(result);
    instanc->colSums(*res);
  } else if (restype == "short") {
    Rcpp::XPtr<houba::MMatrix<int16_t>> res(result);
    instanc->colSums(*res);
  } else {
    throw std::runtime_error("Unsupported datatype for values for now !");
  }

}

// [[Rcpp::export]]
void colSums_mvector(SEXP pM, std::string datatype, SEXP result, std::string restype) {
  if (datatype == "float") { 
    Rcpp::XPtr<houba::MMatrix<float>> instanc(pM);
    colSums(instanc, result, restype);
  } else if (datatype == "double") {
    Rcpp::XPtr<houba::MMatrix<double>> instanc(pM);
    colSums(instanc, result, restype);
  } else if (datatype == "int") {
    Rcpp::XPtr<houba::MMatrix<int>> instanc(pM);
    colSums(instanc, result, restype);
  } else if (datatype == "short") {
    Rcpp::XPtr<houba::MMatrix<int16_t>> instanc(pM);
    colSums(instanc, result, restype);
  } else {
    throw std::runtime_error("Unsupported datatype for now !");
  }
}

