// small test function
// sends back as an R object (NOT mmatrix)
// the data specified in List
#include "MMatrix.h"
#include <iostream>
#include <Rcpp.h>

// [[Rcpp::export]]
SEXP MMatrixAccess(SEXP pM, std::string datatype, Rcpp::IntegerVector I) {
    // the default verbose true should 
    // prove that the c° is not called
    if(datatype == "float") { 
        Rcpp::XPtr<MMatrix<float>> instanc(pM);
        return Rcpp::wrap(instanc->at(I));
    }
    else if(datatype == "double") { 
        Rcpp::XPtr<MMatrix<double>> instanc(pM);
        return Rcpp::wrap(instanc->at(I));
    }
    else if(datatype == "int") {
        Rcpp::XPtr<MMatrix<int>> instanc(pM);
        return Rcpp::wrap(instanc->at(I));
    }
    else if(datatype == "short") {
        Rcpp::XPtr<MMatrix<int16_t>> instanc(pM);
        return Rcpp::wrap(instanc->at(I));
    }
    else {
      throw std::runtime_error("Unsupported datatype");
    } 
}
