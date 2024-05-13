1 // SPDX-License-Identifier: GPL-3.0-or-later
2 
3 pragma solidity >=0.8.4;
4 
5 /// @notice Babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method).
6 library Babylonian {
7     // computes square roots using the babylonian method
8     // credit for this implementation goes to
9     // https://github.com/abdk-consulting/abdk-libraries-solidity/blob/master/ABDKMath64x64.sol#L687
10     function sqrt(uint256 x) internal pure returns (uint256) {
11         if (x == 0) return 0;
12         // this block is equivalent to r = uint256(1) << (BitMath.mostSignificantBit(x) / 2);
13         // however that code costs significantly more gas
14         uint256 xx = x;
15         uint256 r = 1;
16         if (xx >= 0x100000000000000000000000000000000) {
17             xx >>= 128;
18             r <<= 64;
19         }
20         if (xx >= 0x10000000000000000) {
21             xx >>= 64;
22             r <<= 32;
23         }
24         if (xx >= 0x100000000) {
25             xx >>= 32;
26             r <<= 16;
27         }
28         if (xx >= 0x10000) {
29             xx >>= 16;
30             r <<= 8;
31         }
32         if (xx >= 0x100) {
33             xx >>= 8;
34             r <<= 4;
35         }
36         if (xx >= 0x10) {
37             xx >>= 4;
38             r <<= 2;
39         }
40         if (xx >= 0x8) {
41             r <<= 1;
42         }
43         r = (r + x / r) >> 1;
44         r = (r + x / r) >> 1;
45         r = (r + x / r) >> 1;
46         r = (r + x / r) >> 1;
47         r = (r + x / r) >> 1;
48         r = (r + x / r) >> 1;
49         r = (r + x / r) >> 1; // Seven iterations should be enough
50         uint256 r1 = x / r;
51         return (r < r1 ? r : r1);
52     }
53 }