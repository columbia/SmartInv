1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.4;
3 
4 library SquareRoot {
5     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
6     function sqrt(uint256 x) internal pure returns (uint256 y) {
7         uint256 z = (x + 1) / 2;
8         y = x;
9         while (z < y) {
10             y = z;
11             z = (x / z + z) / 2;
12         }
13     }
14 
15     function sqrtUp(uint256 x) internal pure returns (uint256 y) {
16         y = sqrt(x);
17         if (x % y != 0) y++;
18     }
19 }
