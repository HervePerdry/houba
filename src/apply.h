#include "MMatrix.h"
#include <cstdint> // for int16_t
#include <Rcpp.h>

#ifndef _houba_apply__
#define _houba_apply__


// pM = pointeur vers une MMatrix
// datatype = type de cette MMatrix
// TSXP = un entier définissant le type de vecteur (REALSXP ou INTSXP)
// r_vector = un vecteur de type compatible avec la méthode à appeler (float ou ind)
// F = un objet avec un operateur ()(MMatrix, Vector) [templated] (cf exemple dans colSums.cpp)
// qui applique la méthode voulue...
// ie appele F( M, r_vector ) avec M la matrice pointée par pM
template<typename FTYPE, int TSXP>
inline void apply_R(SEXP pM, std::string datatype, Rcpp::Vector<TSXP> r_vector, FTYPE F) {
  if (datatype == "float") { 
    Rcpp::XPtr<houba::MMatrix<float>> instanc(pM);
    F(instanc, r_vector);
  } else if (datatype == "double") {
    Rcpp::XPtr<houba::MMatrix<double>> instanc(pM);
    F(instanc, r_vector);
  } else if (datatype == "integer") {
    Rcpp::XPtr<houba::MMatrix<int>> instanc(pM);
    F(instanc, r_vector);
  } else if (datatype == "short") {
    Rcpp::XPtr<houba::MMatrix<int16_t>> instanc(pM);
    F(instanc, r_vector);
  } else {
    throw std::runtime_error("Unsupported datatype for now !");
  }
}

template<typename FTYPE>
inline void apply_R(SEXP pM, std::string datatype, SEXP r_vec, FTYPE F) {
  if (datatype == "float") {
    Rcpp::XPtr<houba::MMatrix<float>> instanc(pM);
    Rcpp::NumericVector r_vector(r_vec);
    F(instanc, r_vector);
  } else if (datatype == "double") {
    Rcpp::XPtr<houba::MMatrix<double>> instanc(pM);
    Rcpp::NumericVector r_vector(r_vec);
    F(instanc, r_vector);
  } else if (datatype == "integer") {
    Rcpp::XPtr<houba::MMatrix<int>> instanc(pM);
    Rcpp::IntegerVector r_vector(r_vec);
    F(instanc, r_vector);
  } else if (datatype == "short") {
    Rcpp::XPtr<houba::MMatrix<int16_t>> instanc(pM);
    Rcpp::IntegerVector r_vector(r_vec);
    F(instanc, r_vector);
  } else {
    throw std::runtime_error("Unsupported datatype for now !");
  }
}


// pM = pointeur vers une MMatrix
// datatype = type de cette MMatrix
// pM2 = pointeur vers une MMatrix
// datatype2 = type de cette MMatrix
// F = un objet avec un operateur ()(MMatrix, MMatrix) [templated] (cf exemple dans colSums.cpp)a
// le template va appeler F( M, M2 ) avec M et M2 les matrices pointées par pM et pM2
template<typename FTYPE>
inline void apply_mmatrix(SEXP pM, std::string datatype, SEXP pM2, std::string datatype2, FTYPE F) {
  if (datatype == "float") { 
    Rcpp::XPtr<houba::MMatrix<float>> instanc(pM);
    apply_mmatrix_2(instanc, pM2, datatype2, F);
  } else if (datatype == "double") {
    Rcpp::XPtr<houba::MMatrix<double>> instanc(pM);
    apply_mmatrix_2(instanc, pM2, datatype2, F);
  } else if (datatype == "integer") {
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
// le dispatching est maintenant fait sur le type de la deuxième MMatrix
template<typename T, typename FTYPE>
inline void apply_mmatrix_2(Rcpp::XPtr<houba::MMatrix<T>> instanc, SEXP pM2, std::string datatype2, FTYPE F) {
  if(datatype2 == "float") {
    Rcpp::XPtr<houba::MMatrix<float>> instanc2(pM2);
    F(instanc, instanc2);
  } else if(datatype2 == "double") {
    Rcpp::XPtr<houba::MMatrix<double>> instanc2(pM2);
    F(instanc, instanc2);
  } else if(datatype2 == "integer") {
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
