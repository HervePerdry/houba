#ifndef MMATRIX_CLASS_H
#define MMATRIX_CLASS_H

#include <sstream> // for std::ostringstream verbosout_
#include <vector>

#include "mio.hpp"

/**
 * @file MMatrix-class.h
 * @class MMatrix MMatrix-class.h
 * @brief Handling a memory mapped file as a big matrix, using mio library.
 *        It is column major.
 */
template <typename T>
class MMatrix
{
protected:
    /**
     * @fn void FileHandler(std::string path, size_t matrix_size, bool verbose, bool authorize_resize)
     * @brief Helper function called by the constructor to open (and potentially resize) or create a file, after checking it's existence and validity
     *
     * @param path an std::string referencing the absolute path to the file in need of checking
     * @param matrix_size a size_t containing the size of the MMatrix's data in bytes
     * @param verbose a boolean used to silence the class (if true, will add logs to verbosout_)
     * @param authorize_resize a boolean used to allow resizing of the file if it is smaller or greater than matrix_size
     */
    void FileHandler(std::string path, size_t matrix_size, bool verbose, bool authorize_resize);

public:
    /** Constructor for a "matrix-style" call
     * @brief Constructor only for 2 dimensions matrices, opening or creating the file before mapping it.
     *
     * @param path an std::string referencing the absolute path to the file
     * @param nrow a size_t
     * @param ncol a size_t
     * @param verbose a boolean true by default used to silence the class (if true, will add logs to verbosout_)
     * @param authorize_resize a boolean false by default used to allow resizing of the file if it is smaller or greater than matrix_size
     */
    MMatrix(std::string path, size_t nrow, size_t ncol, bool verbose = true, bool authorize_resize = false);

    /** Constructor for a "array-style" call
     * @brief Constructor for multidimensional matrices, opening or creating the file before mapping it.
     *
     * @param path an std::string referencing the absolute path to the file
     * @param dims a std::vector<size_t> 
     * @param verbose a boolean true by default used to silence the class (if true, will add logs to verbosout_)
     * @param authorize_resize a boolean false by default used to allow resizing of the file if it is smaller or greater than matrix_size
     */    
    MMatrix(std::string path, std::vector<size_t> dims, bool verbose = true, bool authorize_resize = false);
     /** Destructor
     * @brief Destructor flushing changes to the disk before unmapping
     **/
    ~MMatrix();

public:
    // Getters
    size_t nrow() const; /**< Getter for nrow_. @return size_t */
    size_t ncol() const; /**< Getter for ncol_. @return size_t */
    size_t size() const; /**< Getter for size_. @return size_t */

    std::string path() const; /**< Getter for path_. @return std::string */
    std::vector<size_t> dim() const; /**< Getter for dims_. @return std::vector<size_t> */
    T *data() const; /**< Getter for data_. @return a pointer to the first byte of data*/
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

    void flush();

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

    /**
    * product of all dimensions 
    * (not mapped size in bytes as this also needs sizeof(datatype))
    */
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
