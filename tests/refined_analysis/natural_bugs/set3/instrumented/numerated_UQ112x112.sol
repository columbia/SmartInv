1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.5.16;
4 
5 // a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
6 
7 // range: [0, 2**112 - 1]
8 // resolution: 1 / 2**112
9 
10 library UQ112x112 {
11     uint224 constant Q112 = 2**112;
12 
13     // encode a uint112 as a UQ112x112
14     function encode(uint112 y) internal pure returns (uint224 z) {
15         z = uint224(y) * Q112; // never overflows
16     }
17 
18     // divide a UQ112x112 by a uint112, returning a UQ112x112
19     function uqdiv(uint224 x, uint112 y) internal pure returns (uint224 z) {
20         z = x / uint224(y);
21     }
22 }
