1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.3;
4 
5 library UnsafeMath64x64 {
6 
7   /**
8    * Calculate x * y rounding down.
9    *
10    * @param x signed 64.64-bit fixed point number
11    * @param y signed 64.64-bit fixed point number
12    * @return signed 64.64-bit fixed point number
13    */
14 
15   function us_mul (int128 x, int128 y) internal pure returns (int128) {
16     int256 result = int256(x) * y >> 64;
17     return int128 (result);
18   }
19 
20   /**
21    * Calculate x / y rounding towards zero.  Revert on overflow or when y is
22    * zero.
23    *
24    * @param x signed 64.64-bit fixed point number
25    * @param y signed 64.64-bit fixed point number
26    * @return signed 64.64-bit fixed point number
27    */
28 
29   function us_div (int128 x, int128 y) internal pure returns (int128) {
30     int256 result = (int256 (x) << 64) / y;
31     return int128 (result);
32   }
33 
34 }