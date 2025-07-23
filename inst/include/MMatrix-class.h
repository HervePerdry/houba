#ifndef MMATRIX_CLASS_H
#define MMATRIX_CLASS_H

#include <fstream>
#include <sstream>
#include <string>
#include <system_error>
#include <vector>

#include "mio.hpp"

/*
 The goal of this class is to add the possibility for big matrices
 to become a memory mapped file using mio library 
 IT IS COLUMN MAJOR !
 */
template <typename T>
class MMatrix
{
public:
    // Constructor opening the file containing the matrix
    // if path exists else creating one.
    MMatrix(std::string path, size_t nrow, size_t ncol, bool verbose = true, bool authorize_resize = false);
    // Constructor for a multidimensional matrix / R-style array
    MMatrix(std::string path, std::vector<size_t> dims, bool verbose = true, bool authorize_resize = false);
    // Destructor flushing changes to disk before unmapping
    ~MMatrix();

protected:
    // this is a function called by the constructor to create a file of the good size 
    // check if it exists / resize it - if authorize_resize == true
    void FileHandler(std::string path, size_t matrix_size, bool verbose, bool authorize_resize);

public:
    // Getters
    size_t nrow() const;
    size_t ncol() const;
    size_t size() const;

    std::string path() const;
    std::vector<size_t> dim() const;
    T *data() const;
    bool verbose() const;
    std::string getVerbosout() const;

    // Setter for dimension
    template <typename intVec> 
    void setDim(intVec newdims);
 
    // a function for tests
    template <typename U>
    std::vector<U> sum() const;

    // operator[] and at() for accessing like a vector
    T & operator[](size_t ind);
    const T & operator[](size_t ind) const;

    T & at(size_t ind) const;

    // operator() and at() for accessing as matrix
    T & operator()(size_t i, size_t j);
    const T & operator()(size_t i, size_t j) const;

    T & at(size_t i, size_t j) const;

    // operator() and at() for accessing as array
    template <typename intVec>
    T & operator()(const intVec & index);

    template <typename intVec>
    const T & operator()(const intVec & index) const;

    template <typename intVec>
    T & at(const intVec & index) const;

    // copy values "as a vector" (with recycling)
    template <typename Tvec>
    void copy_values(Tvec & values);

    // setting values for matrices
    template <typename intVec, typename Tvec>
    void set_values_matrix(const intVec & I, const intVec & J, Tvec & values);

    // setting values for arrays
    template <typename intVec, typename Tvec>
    void set_values_array(const std::vector<intVec> & I, Tvec & values);
 
    // extraction for object seen as a vector
    template <typename intVec, typename targetVec>
    void extract_vector(const intVec & I, targetVec & target) const;

    // extraction for matrices (targetVec can be MMatrix<T> !)
    template <typename intVec, typename targetVec>
    void extract_matrix(const intVec & I, const intVec & J, targetVec & target) const;

    // extraction for arrays
    template <typename intVec, typename targetVec>
    void extract_array(const std::vector<intVec> & I, targetVec & target) const;

    // component wise arithmetic
    template <typename Tvec>
    void cw_sum(Tvec & e2);
    template <typename Tvec>
    void cw_minus(Tvec & e2);
    template <typename Tvec>
    void cw_prod(Tvec & e2);
    template <typename Tvec>
    void cw_div(Tvec & e2);
    void cw_inverse();
    void cw_opposite();

private:
    // auxiliary function for extract_array
    template<typename intVec>
    void indices(const std::vector<intVec> & I, std::vector<size_t> & ind) const;

protected:
    // Number of columns of the matrix, (base 1).
    // hardcoded to simplify the "matrix" use
    // but equivalent to dim[1]
    size_t ncol_;

    // Number of rows of the matrix (base 1).
    // hardcoded to simplify the "matrix" use
    // but equivalent to dim[0]
    size_t nrow_;

    // product of all dimensions 
    // (not mapped size in bytes as this also needs sizeof(datatype))
    size_t size_;

    // A vector containing all the dimension sizes
    // to mimic an R-style array
    // TO THINK : should dim_ be a template ? 
    std::vector<size_t> dim_;

    // (Relative ?) path of the file containing the matrix
    std::string path_;

    // Mio object handling the matrix.
    mio::mmap_sink matrix_file_;

    // type T pointer to the first byte of data in matrix_file_
    T *data_ptr_;

    // Boolean used to silence the class 
    bool verbose_;

    // used for logging
    std::ostringstream verbosout_;
};

#endif // MMATRIX_CLASS_H
