// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

=======
/// @title Advanced Control Structures and Sorting Algorithms
/// @notice Demonstrates control structures and efficient sorting algorithms in Solidity
/// @dev Includes gas-optimized implementations and comprehensive error handling
contract InsertionSort {
    // Custom errors for better gas efficiency and clarity
    error EmptyArray();
    error ArrayTooLarge(uint256 length);
    error InvalidIndex(uint256 index);
    error UnsortedArray();

    // Constants for configuration
    uint256 public constant MAX_ARRAY_LENGTH = 1000;
    uint256 public constant MAX_SORT_GAS = 5000000;

    // Events for debugging and monitoring
    event SortCompleted(uint256 arrayLength, uint256 gasUsed);
    event ArraySorted(uint256[] sortedArray);
    event GasLimitExceeded(uint256 gasUsed, uint256 gasLimit);

    /// @notice Basic if-else conditional test
    /// @param _number The number to test
    /// @return true if number is zero, false otherwise
    function ifElseTest(uint256 _number) public pure returns(bool) {
        return _number == 0;
    }

    /// @notice Optimized for loop example
    /// @return sum The sum of numbers from 0 to 9
    function forLoopTest() public pure returns(uint256) {
        uint256 sum = 0;
        
        // Use unchecked block for gas optimization since no overflow possible
        unchecked {
            for(uint256 i = 0; i < 10; i++) {
                sum += i;
            }
        }
        return sum;
    }

    /// @notice While loop example with gas optimization
    /// @return sum The sum of numbers from 0 to 9
    function whileTest() public pure returns(uint256) {
        uint256 sum = 0;
        uint256 i = 0;
        
        unchecked {
            while(i < 10) {
                sum += i;
                i++;
            }
        }
        return sum;
    }

    /// @notice Do-while loop example
    /// @return sum The sum of numbers from 0 to 9
    function doWhileTest() public pure returns(uint256) {
        uint256 sum = 0;
        uint256 i = 0;
        
        unchecked {
            do {
                sum += i;
                i++;
            } while(i < 10);
        }
        return sum;
    }

    /// @notice Ternary operator example
    /// @param x First number
    /// @param y Second number
    /// @return The maximum of x and y
    function ternaryTest(uint256 x, uint256 y) public pure returns(uint256) {
        return x >= y ? x : y; 
    }

    /// @notice Find minimum value in array
    /// @param arr The input array
    /// @return min The minimum value
    function findMin(uint256[] memory arr) public pure returns(uint256 min) {
        if (arr.length == 0) revert EmptyArray();
        
        min = arr[0];
        unchecked {
            for (uint256 i = 1; i < arr.length; i++) {
                if (arr[i] < min) {
                    min = arr[i];
                }
            }
        }
    }

    /// @notice Find maximum value in array
    /// @param arr The input array
    /// @return max The maximum value
    function findMax(uint256[] memory arr) public pure returns(uint256 max) {
        if (arr.length == 0) revert EmptyArray();
        
        max = arr[0];
        unchecked {
            for (uint256 i = 1; i < arr.length; i++) {
                if (arr[i] > max) {
                    max = arr[i];
                }
            }
        }
    }

    /// @notice Calculate sum of array elements
    /// @param arr The input array
    /// @return total The sum of all elements
    function arraySum(uint256[] memory arr) public pure returns(uint256 total) {
        if (arr.length == 0) revert EmptyArray();
        
        unchecked {
            for (uint256 i = 0; i < arr.length; i++) {
                total += arr[i];
            }
        }
    }

    /// @notice Insertion sort implementation with gas optimization and safety checks
    /// @param a The array to sort
    /// @return The sorted array
    function insertionSort(uint256[] memory a) public returns(uint256[] memory) {
        uint256 gasStart = gasleft();
        
        // Input validation
        if (a.length == 0) revert EmptyArray();
        if (a.length > MAX_ARRAY_LENGTH) revert ArrayTooLarge(a.length);
        
        // Early return for single-element arrays
        if (a.length == 1) {
            emit SortCompleted(1, gasStart - gasleft());
            emit ArraySorted(a);
            return a;
        }

        unchecked {
            for (uint256 i = 1; i < a.length; i++) {
                // Check gas limit to prevent out-of-gas errors
                if (gasleft() < 10000) {
                    emit GasLimitExceeded(gasStart - gasleft(), MAX_SORT_GAS);
                    revert("Gas limit exceeded");
                }

                uint256 temp = a[i];
                uint256 j = i;

                // Shift elements greater than temp to the right
                while (j > 0 && temp < a[j - 1]) {
                    a[j] = a[j - 1];
                    j--;
                }
                
                a[j] = temp;
            }
        }

        uint256 gasUsed = gasStart - gasleft();
        emit SortCompleted(a.length, gasUsed);
        emit ArraySorted(a);
        
        return a;
    }

    /// @notice Optimized insertion sort for nearly sorted arrays
    /// @param a The array to sort
    /// @return The sorted array
    function optimizedInsertionSort(uint256[] memory a) public returns(uint256[] memory) {
        if (a.length == 0) revert EmptyArray();
        if (a.length == 1) return a;

        unchecked {
            for (uint256 i = 1; i < a.length; i++) {
                uint256 temp = a[i];
                uint256 j = i;

                // Use binary search for the insertion position (optimization)
                if (j > 8) { // Only for larger subarrays
                    uint256 left = 0;
                    uint256 right = j;
                    
                    while (left < right) {
                        uint256 mid = (left + right) / 2;
                        if (temp < a[mid]) {
                            right = mid;
                        } else {
                            left = mid + 1;
                        }
                    }
                    
                    // Shift elements
                    for (uint256 k = i; k > left; k--) {
                        a[k] = a[k - 1];
                    }
                    a[left] = temp;
                } else {
                    // Standard insertion for small subarrays
                    while (j > 0 && temp < a[j - 1]) {
                        a[j] = a[j - 1];
                        j--;
                    }
                    a[j] = temp;
                }
            }
        }
        
        return a;
    }

    /// @notice Verify if array is sorted
    /// @param arr The array to check
    /// @return true if sorted, false otherwise
    function isSorted(uint256[] memory arr) public pure returns(bool) {
        if (arr.length <= 1) return true;
        
        unchecked {
            for (uint256 i = 1; i < arr.length; i++) {
                if (arr[i] < arr[i - 1]) {
                    return false;
                }
            }
        }
        return true;
    }

    /// @notice Reverse an array
    /// @param arr The array to reverse
    /// @return The reversed array
    function reverseArray(uint256[] memory arr) public pure returns(uint256[] memory) {
        if (arr.length == 0) revert EmptyArray();
        
        uint256[] memory reversed = new uint256[](arr.length);
        
        unchecked {
            for (uint256 i = 0; i < arr.length; i++) {
                reversed[arr.length - 1 - i] = arr[i];
            }
        }
        
        return reversed;
    }

    /// @notice Generate test array of specified length
    /// @param length The length of the array
    /// @param reverse Whether to generate reverse sorted array
    /// @return The generated array
    function generateTestArray(uint256 length, bool reverse) public pure returns(uint256[] memory) {
        if (length == 0) revert EmptyArray();
        if (length > MAX_ARRAY_LENGTH) revert ArrayTooLarge(length);
        
        uint256[] memory arr = new uint256[](length);
        
        unchecked {
            for (uint256 i = 0; i < length; i++) {
                arr[i] = reverse ? length - i : i + 1;
            }
        }
        
        return arr;
    }

    /// @notice Benchmark sorting performance
    /// @param length Array length for benchmark
    /// @return gasUsed The gas used for sorting
    function benchmarkSort(uint256 length) public returns(uint256 gasUsed) {
        if (length > MAX_ARRAY_LENGTH) revert ArrayTooLarge(length);
        
        uint256[] memory testArray = generateTestArray(length, true); // Reverse sorted for worst-case
        uint256 gasStart = gasleft();
        
        insertionSort(testArray);
        
        gasUsed = gasStart - gasleft();
        return gasUsed;
    }

    /// @notice Get maximum recommended array length for sorting
    /// @return The maximum safe array length
    function getMaxArrayLength() public pure returns(uint256) {
        return MAX_ARRAY_LENGTH;
    }

    /// @notice Emergency stop for large sorts (not needed in pure functions but good practice)
    function emergencyStop() public pure {
        revert("Emergency stop called");
    }
}
