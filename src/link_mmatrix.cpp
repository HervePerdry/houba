#include "MMatrix.h"
#include <stdexcept> // for std::runtime_error
#include <Rcpp.h>

// [[Rcpp::export]]
SEXP link_mmatrix(std::string datatype, std::string file, size_t nrow, size_t ncol) {
    if (datatype == "float") {
        Rcpp::XPtr<MMatrix<float>> MMatrix_ptr(new MMatrix<float>(file, nrow, ncol));
        return MMatrix_ptr;
    } else if (datatype == "double") {
        Rcpp::XPtr<MMatrix<double>> MMatrix_ptr(new MMatrix<double>(file, nrow, ncol));
        return MMatrix_ptr;
    } else if (datatype == "int") {
        Rcpp::XPtr<MMatrix<int>> MMatrix_ptr(new MMatrix<int>(file, nrow, ncol));
        return MMatrix_ptr;
    } else if (datatype == "short") {
        Rcpp::XPtr<MMatrix<int16_t>> MMatrix_ptr(new MMatrix<int16_t>(file, nrow, ncol));
        return MMatrix_ptr;
    } else {
        throw std::runtime_error("Type of mmatrix (" + datatype + ") is unimplemented");
    }
}
