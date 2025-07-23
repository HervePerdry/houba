#include "MMatrix.h"
#include <iostream>
#include <Rcpp.h>
#include "list2vec.h"

// pour celui ci target est une matrice R du bon type
// [[Rcpp::export]]
void extract_marray_to_R(SEXP pM, std::string datatype, Rcpp::List L, SEXP target) {
  std::vector<Rcpp::IntegerVector> IND;
  Rcpp::IntegerVector dim = list2vec_dim(L, IND);
  if (datatype == "float") { 
    Rcpp::XPtr<MMatrix<float>> instanc(pM);
    Rcpp::NumericVector tar(target);
    instanc->extract_array(IND, tar);
    tar.attr("dim") = dim;
  } else if (datatype == "double") {
    Rcpp::XPtr<MMatrix<double>> instanc(pM);
    Rcpp::NumericVector tar(target);
    instanc->extract_array(IND, tar);
    tar.attr("dim") = dim;
  } else if (datatype == "int") {
    Rcpp::XPtr<MMatrix<int>> instanc(pM);
    Rcpp::IntegerVector tar(target);
    instanc->extract_array(IND, tar);
    tar.attr("dim") = dim;
  } else if (datatype == "short") {
    Rcpp::XPtr<MMatrix<int16_t>> instanc(pM);
    Rcpp::IntegerVector tar(target);
    instanc->extract_array(IND, tar);
    tar.attr("dim") = dim;
  } else {
    throw std::runtime_error("Unsupported datatype for now !");
  }
}

// et pour celui ci target est un pointeur vers une marray
// [[Rcpp::export]]
void extract_marray_to_marray(SEXP pM, std::string datatype, Rcpp::List L, SEXP target) {
  std::vector<Rcpp::IntegerVector> IND;
  list2vec(L, IND);
  if (datatype == "float") { 
    Rcpp::XPtr<MMatrix<float>> instanc(pM);
    Rcpp::XPtr<MMatrix<float>> tar(target);
    instanc->extract_array(IND, *tar);
  } else if (datatype == "double") {
    Rcpp::XPtr<MMatrix<double>> instanc(pM);
    Rcpp::XPtr<MMatrix<double>> tar(target);
    instanc->extract_array(IND, *tar);
  } else if (datatype == "int") {
    Rcpp::XPtr<MMatrix<int>> instanc(pM);
    Rcpp::XPtr<MMatrix<int>> tar(target);
    instanc->extract_array(IND, *tar);
  } else if (datatype == "short") {
    Rcpp::XPtr<MMatrix<int16_t>> instanc(pM);
    Rcpp::XPtr<MMatrix<int16_t>> tar(target);
    instanc->extract_array(IND, *tar);
  } else {
    throw std::runtime_error("Unsupported datatype for now !");
  }
}


