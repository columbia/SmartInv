1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.5.16;
4 
5 // a library for performing various math operations
6 
7 library Math {
8     function min(uint x, uint y) internal pure returns (uint z) {
9         z = x < y ? x : y;
10     }
11 
12     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
13     function sqrt(uint y) internal pure returns (uint z) {
14         if (y > 3) {
15             z = y;
16             uint x = y / 2 + 1;
17             while (x < z) {
18                 z = x;
19                 x = (y / x + x) / 2;
20             }
21         } else if (y != 0) {
22             z = 1;
23         }
24     }
25 }
