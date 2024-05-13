1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @title MathUtils library
7  * @notice A library to be used in conjunction with SafeMath. Contains functions for calculating
8  * differences between two uint256.
9  */
10 library MathUtilsV1 {
11     /**
12      * @notice Compares a and b and returns true if the difference between a and b
13      *         is less than 1 or equal to each other.
14      * @param a uint256 to compare with
15      * @param b uint256 to compare with
16      * @return True if the difference between a and b is less than 1 or equal,
17      *         otherwise return false
18      */
19     function within1(uint256 a, uint256 b) internal pure returns (bool) {
20         return (difference(a, b) <= 1);
21     }
22 
23     /**
24      * @notice Calculates absolute difference between a and b
25      * @param a uint256 to compare with
26      * @param b uint256 to compare with
27      * @return Difference between a and b
28      */
29     function difference(uint256 a, uint256 b) internal pure returns (uint256) {
30         if (a > b) {
31             return a - b;
32         }
33         return b - a;
34     }
35 }
