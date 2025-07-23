#include "MMatrix.h"
#include <iostream>
#include <Rcpp.h>

// pour celui ci target est une matrice R du bon type
// [[Rcpp::export]]
void extract_mmatrix_to_R(SEXP pM, std::string datatype, Rcpp::IntegerVector I, Rcpp::IntegerVector J, SEXP target) {
  if (datatype == "float") { 
    Rcpp::XPtr<MMatrix<float>> instanc(pM);
    Rcpp::NumericMatrix tar(target);
    instanc->extract_matrix(I, J, tar);
  } else if (datatype == "double") {
    Rcpp::XPtr<MMatrix<double>> instanc(pM);
    Rcpp::NumericMatrix tar(target);
    instanc->extract_matrix(I, J, tar);
  } else if (datatype == "int") {
    Rcpp::XPtr<MMatrix<int>> instanc(pM);
    Rcpp::IntegerMatrix tar(target);
    instanc->extract_matrix(I, J, tar);
  } else if (datatype == "short") {
    Rcpp::XPtr<MMatrix<int16_t>> instanc(pM);
    Rcpp::IntegerMatrix tar(target);
    instanc->extract_matrix(I, J, tar);
  } else {
    throw std::runtime_error("Unsupported datatype for now !");
  }
}

// et pour celui ci target est un pointeur vers une mmatrix
// [[Rcpp::export]]
void extract_mmatrix_to_mmatrix(SEXP pM, std::string datatype, Rcpp::IntegerVector I, Rcpp::IntegerVector J, SEXP target) {
  if (datatype == "float") { 
    Rcpp::XPtr<MMatrix<float>> instanc(pM);
    Rcpp::XPtr<MMatrix<float>> tar(target);
    instanc->extract_matrix(I, J, *tar);
  } else if (datatype == "double") {
    Rcpp::XPtr<MMatrix<double>> instanc(pM);
    Rcpp::XPtr<MMatrix<double>> tar(target);
    instanc->extract_matrix(I, J, *tar);
  } else if (datatype == "int") {
    Rcpp::XPtr<MMatrix<int>> instanc(pM);
    Rcpp::XPtr<MMatrix<int>> tar(target);
    instanc->extract_matrix(I, J, *tar);
  } else if (datatype == "short") {
    Rcpp::XPtr<MMatrix<int16_t>> instanc(pM);
    Rcpp::XPtr<MMatrix<int16_t>> tar(target);
    instanc->extract_matrix(I, J, *tar);
  } else {
    throw std::runtime_error("Unsupported datatype for now !");
  }
}


