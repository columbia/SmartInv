1 // SPDX-License-Identifier: GPL-3.0-only
2 pragma solidity =0.7.6;
3 pragma abicoder v2;
4 
5 import "../global/Types.sol";
6 import "../global/Constants.sol";
7 
8 /// @notice Helper methods for bitmaps, they are big-endian and 1-indexed.
9 library Bitmap {
10 
11     /// @notice Set a bit on or off in a bitmap, index is 1-indexed
12     function setBit(
13         bytes32 bitmap,
14         uint256 index,
15         bool setOn
16     ) internal pure returns (bytes32) {
17         require(index >= 1 && index <= 256); // dev: set bit index bounds
18 
19         if (setOn) {
20             return bitmap | (Constants.MSB >> (index - 1));
21         } else {
22             return bitmap & ~(Constants.MSB >> (index - 1));
23         }
24     }
25 
26     /// @notice Check if a bit is set
27     function isBitSet(bytes32 bitmap, uint256 index) internal pure returns (bool) {
28         require(index >= 1 && index <= 256); // dev: set bit index bounds
29         return ((bitmap << (index - 1)) & Constants.MSB) == Constants.MSB;
30     }
31 
32     /// @notice Count the total bits set
33     function totalBitsSet(bytes32 bitmap) internal pure returns (uint256) {
34         uint256 x = uint256(bitmap);
35         x = (x & 0x5555555555555555555555555555555555555555555555555555555555555555) + (x >> 1 & 0x5555555555555555555555555555555555555555555555555555555555555555);
36         x = (x & 0x3333333333333333333333333333333333333333333333333333333333333333) + (x >> 2 & 0x3333333333333333333333333333333333333333333333333333333333333333);
37         x = (x & 0x0707070707070707070707070707070707070707070707070707070707070707) + (x >> 4);
38         x = (x & 0x000F000F000F000F000F000F000F000F000F000F000F000F000F000F000F000F) + (x >> 8 & 0x000F000F000F000F000F000F000F000F000F000F000F000F000F000F000F000F);
39         x = x + (x >> 16);
40         x = x + (x >> 32);
41         x = x  + (x >> 64);
42         return (x & 0xFF) + (x >> 128 & 0xFF);
43     }
44 
45     // Does a binary search over x to get the position of the most significant bit
46     function getMSB(uint256 x) internal pure returns (uint256 msb) {
47         // If x == 0 then there is no MSB and this method will return zero. That would
48         // be the same as the return value when x == 1 (MSB is zero indexed), so instead
49         // we have this require here to ensure that the values don't get mixed up.
50         require(x != 0); // dev: get msb zero value
51         if (x >= 0x100000000000000000000000000000000) {
52             x >>= 128;
53             msb += 128;
54         }
55         if (x >= 0x10000000000000000) {
56             x >>= 64;
57             msb += 64;
58         }
59         if (x >= 0x100000000) {
60             x >>= 32;
61             msb += 32;
62         }
63         if (x >= 0x10000) {
64             x >>= 16;
65             msb += 16;
66         }
67         if (x >= 0x100) {
68             x >>= 8;
69             msb += 8;
70         }
71         if (x >= 0x10) {
72             x >>= 4;
73             msb += 4;
74         }
75         if (x >= 0x4) {
76             x >>= 2;
77             msb += 2;
78         }
79         if (x >= 0x2) msb += 1; // No need to shift xc anymore
80     }
81 
82     /// @dev getMSB returns a zero indexed bit number where zero is the first bit counting
83     /// from the right (little endian). Asset Bitmaps are counted from the left (big endian)
84     /// and one indexed.
85     function getNextBitNum(bytes32 bitmap) internal pure returns (uint256 bitNum) {
86         // Short circuit the search if bitmap is all zeros
87         if (bitmap == 0x00) return 0;
88 
89         return 255 - getMSB(uint256(bitmap)) + 1;
90     }
91 }
