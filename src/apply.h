#include "MMatrix.h"
#include <cstdint> // for int16_t
#include <Rcpp.h>

#ifndef _houba_apply__
#define _houba_apply__


// pM = pointeur vers une MMatrix
// datatype = type de cette MMatrix
// r_vector = un vecteur de type compatible (float ou ind)
// F = un objet avec un operateur ()(MMatrix, Vector) [templated] (cf exemple dans colSums.cpp)
// qui applique la méthode voulue...
template<typename FTYPE>
inline void apply_R(SEXP pM, std::string datatype, SEXP r_vector, FTYPE F) {
  if (datatype == "float") { 
    Rcpp::XPtr<houba::MMatrix<float>> instanc(pM);
    Rcpp::NumericVector r(r_vector);
    F(instanc, r);
  } else if (datatype == "double") {
    Rcpp::XPtr<houba::MMatrix<double>> instanc(pM);
    Rcpp::NumericVector r(r_vector);
    F(instanc, r);
  } else if (datatype == "int") {
    Rcpp::XPtr<houba::MMatrix<int>> instanc(pM);
    Rcpp::IntegerVector r(r_vector);
    F(instanc, r);
  } else if (datatype == "short") {
    Rcpp::XPtr<houba::MMatrix<int16_t>> instanc(pM);
    Rcpp::IntegerVector r(r_vector);
    F(instanc, r);
  } else {
    throw std::runtime_error("Unsupported datatype for now !");
  }
}

// pM = pointeur vers une MMatrix
// datatype = type de cette MMatrix
// pM2 = pointeur vers une MMatrix
// datatype2 = type de cette MMatrix
// F = un objet avec un operateur ()(MMatrix, MMatrix) [templated] (cf exemple dans colSums.cpp)
template<typename FTYPE>
inline void apply_mmatrix(SEXP pM, std::string datatype, SEXP pM2, std::string datatype2, FTYPE F) {
  if (datatype == "float") { 
    Rcpp::XPtr<houba::MMatrix<float>> instanc(pM);
    apply_mmatrix_2(instanc, pM2, datatype2, F);
  } else if (datatype == "double") {
    Rcpp::XPtr<houba::MMatrix<double>> instanc(pM);
    apply_mmatrix_2(instanc, pM2, datatype2, F);
  } else if (datatype == "int") {
    Rcpp::XPtr<houba::MMatrix<int>> instanc(pM);
    apply_mmatrix_2(instanc, pM2, datatype2, F);
  } else if (datatype == "short") {
    Rcpp::XPtr<houba::MMatrix<int16_t>> instanc(pM);
    apply_mmatrix_2(instanc, pM2, datatype2, F);
  } else {
    throw std::runtime_error("Unsupported datatype for now !");
  }
}

// dispatcher utilisé dans le template précédent
template<typename T, typename FTYPE>
inline void apply_mmatrix_2(Rcpp::XPtr<houba::MMatrix<T>> instanc, SEXP pM2, std::string datatype2, FTYPE F) {
  if(datatype2 == "float") {
    Rcpp::XPtr<houba::MMatrix<float>> instanc2(pM2);
    F(instanc, instanc2);
  } else if(datatype2 == "double") {
    Rcpp::XPtr<houba::MMatrix<double>> instanc2(pM2);
    F(instanc, instanc2);
  } else if(datatype2 == "int") {
    Rcpp::XPtr<houba::MMatrix<int>> instanc2(pM2);
    F(instanc, instanc2);
  } else if (datatype2 == "short") {
    Rcpp::XPtr<houba::MMatrix<int16_t>> instanc2(pM2);
    F(instanc, instanc2);
  } else {
    throw std::runtime_error("Unsupported datatype for now !");
  }
}
#endif
