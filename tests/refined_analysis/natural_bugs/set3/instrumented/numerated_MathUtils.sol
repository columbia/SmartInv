1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 import "@openzeppelin/contracts/math/SafeMath.sol";
6 
7 /**
8  * @title MathUtils library
9  * @notice A library to be used in conjunction with SafeMath. Contains functions for calculating
10  * differences between two uint256.
11  */
12 library MathUtils {
13     /**
14      * @notice Compares a and b and returns true if the difference between a and b
15      *         is less than 1 or equal to each other.
16      * @param a uint256 to compare with
17      * @param b uint256 to compare with
18      * @return True if the difference between a and b is less than 1 or equal,
19      *         otherwise return false
20      */
21     function within1(uint256 a, uint256 b) internal pure returns (bool) {
22         return (difference(a, b) <= 1);
23     }
24 
25     /**
26      * @notice Calculates absolute difference between a and b
27      * @param a uint256 to compare with
28      * @param b uint256 to compare with
29      * @return Difference between a and b
30      */
31     function difference(uint256 a, uint256 b) internal pure returns (uint256) {
32         if (a > b) {
33             return a - b;
34         }
35         return b - a;
36     }
37 }
