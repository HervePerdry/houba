#include "MMatrix.h"
#include <Rcpp.h>
#include "list2vec.h"

// pM est un pointeur une houba::MMatrix de type donné par datatype
// L est la liste des dimensions à extraitre
// pour cette fonction target est une matrice R du bon type (Rcpp::NumericVector ou Rcpp::IntegerVector)
// [[Rcpp::export]]
void extract_marray_to_R(SEXP pM, std::string datatype, Rcpp::List L, SEXP target) {
  std::vector<Rcpp::IntegerVector> IND;
  Rcpp::IntegerVector dim = list2vec_dim(L, IND);
  if (datatype == "float") { 
    Rcpp::XPtr<houba::MMatrix<float>> instanc(pM);
    Rcpp::NumericVector tar(target);
    instanc->extract_array(IND, tar);
    tar.attr("dim") = dim;
  } else if (datatype == "double") {
    Rcpp::XPtr<houba::MMatrix<double>> instanc(pM);
    Rcpp::NumericVector tar(target);
    instanc->extract_array(IND, tar);
    tar.attr("dim") = dim;
  } else if (datatype == "integer") {
    Rcpp::XPtr<houba::MMatrix<int>> instanc(pM);
    Rcpp::IntegerVector tar(target);
    instanc->extract_array(IND, tar);
    tar.attr("dim") = dim;
  } else if (datatype == "short") {
    Rcpp::XPtr<houba::MMatrix<int16_t>> instanc(pM);
    Rcpp::IntegerVector tar(target);
    instanc->extract_array(IND, tar);
    tar.attr("dim") = dim;
  } else {
    throw std::runtime_error("Unsupported datatype for now !");
  }
}

// et pour celle-ci target est un pointeur vers une marray du même type que celle pointée par pM
// [[Rcpp::export]]
void extract_marray_to_marray(SEXP pM, std::string datatype, Rcpp::List L, SEXP target) {
  std::vector<Rcpp::IntegerVector> IND;
  list2vec(L, IND);
  if (datatype == "float") { 
    Rcpp::XPtr<houba::MMatrix<float>> instanc(pM);
    Rcpp::XPtr<houba::MMatrix<float>> tar(target);
    instanc->extract_array(IND, *tar);
  } else if (datatype == "double") {
    Rcpp::XPtr<houba::MMatrix<double>> instanc(pM);
    Rcpp::XPtr<houba::MMatrix<double>> tar(target);
    instanc->extract_array(IND, *tar);
  } else if (datatype == "integer") {
    Rcpp::XPtr<houba::MMatrix<int>> instanc(pM);
    Rcpp::XPtr<houba::MMatrix<int>> tar(target);
    instanc->extract_array(IND, *tar);
  } else if (datatype == "short") {
    Rcpp::XPtr<houba::MMatrix<int16_t>> instanc(pM);
    Rcpp::XPtr<houba::MMatrix<int16_t>> tar(target);
    instanc->extract_array(IND, *tar);
  } else {
    throw std::runtime_error("Unsupported datatype for now !");
  }
}


