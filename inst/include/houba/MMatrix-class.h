#ifndef MMATRIX_CLASS_H
#define MMATRIX_CLASS_H

#include <sstream> // for std::ostringstream verbosout_
#include <vector>

#include "mio/mio.hpp"

/**
 * @namespace houba
 */
namespace houba {

/**
 * @file MMatrix-class.h
 * @class MMatrix MMatrix-class.h
 * @brief Handling a memory mapped file as a big matrix, using mio library.
 *        It is column major, just like R.
 */
template <typename T>
class MMatrix
{
protected:
    /**
     * @fn void FileHandler(size_t matrix_size, bool authorize_resize)
     * @brief Helper function called by the constructor to open (and potentially resize) or create a file, after checking 
     * its existence and validity. If path_ is empty, allocates memory instead
     *
     * @param path an std::string referencing the absolute path to the file in need of checking
     * @param matrix_size a size_t containing the size of the MMatrix's data in bytes
     * @param authorize_resize a boolean used to allow resizing of the file if it is smaller or greater than matrix_size
     */
    void FileHandler(size_t matrix_size, bool authorize_resize);

public:
    using value_type = T;
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
    size_t nrow() const; /**< Getter for @ref nrow_. @return size_t */
    size_t ncol() const; /**< Getter for @ref ncol_. @return size_t */
    size_t size() const; /**< Getter for @ref size_. @return size_t */

    std::string path() const; /**< Getter for @ref path_. @return std::string */
    std::vector<size_t> dim() const; /**< Getter for @ref dims_. @return std::vector<size_t> */
    T *data() const; /**< Getter for @ref data_. @return a pointer to the first byte of data*/
    bool verbose() const; /**< Getter for @ref verbose_. @return bool */
    std::string getVerbosout() const; /**< Getter for @ref verbosout_ content. @return std::string */

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

    // setting values for vectors (or matrices or arrays seen as a vector)
    template <typename intVec, typename Tvec>
    void set_values_vector(const intVec & I, Tvec & values);

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

    // colSums
    template <typename resultVec>
    void colSums(resultVec & result) const;

    // rowSums
    template <typename resultVec>
    void rowSums(resultVec & result) const;

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
    /** 
     * Number of columns of the matrix, (base 1).
     * @details hardcoded to simplify the "matrix" use but equivalent to dim[1] 
     * */
    size_t ncol_;

    /**
    * Number of rows of the matrix (base 1).
    * @details hardcoded to simplify the "matrix" use but equivalent to dim[0]
    * */
    size_t nrow_;

    /**
    * Product of all dimensions of the MMatrix
    * @details It is NOT the mapped size in bytes as this also needs sizeof(datatype))
    */
    size_t size_;

    /**
     * A vector containing all the dimension in order, to mimic an R-style array
     * @details stopping at @ref nrow for dim[0] and @ref ncol for dim[1] if the matrix is of 2 dimensions.  
     */ 
    std::vector<size_t> dim_;

    /**
     * Path of the file containing the MMatrix data
     * @details can be relative to where the program is being run or absolute
     */
    std::string path_;

    /**
     * Mio object handling the file behind the matrix
     * @details read and write, see more on @ref mio::mmap_sink
     */
    mio::mmap_sink matrix_file_;

    /**
     * A pointer of type T, to the first data in matrix_file_
     * @details read and write also
     */
    T *data_ptr_;

    // Boolean used to silence the class 
    bool verbose_;

    // used for logging
    std::ostringstream verbosout_;
};

} // end namespace houba

#endif // MMATRIX_CLASS_H
