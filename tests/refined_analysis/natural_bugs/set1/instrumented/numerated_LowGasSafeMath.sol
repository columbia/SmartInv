1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity >=0.7.0 <0.8.0;
3 
4 /// @title Optimized overflow and underflow safe math operations
5 /// @notice Contains methods for doing math operations that revert on overflow or underflow for minimal gas cost
6 library LowGasSafeMath {
7     /// @notice Returns x + y, reverts if sum overflows uint256
8     /// @param x The augend
9     /// @param y The addend
10     /// @return z The sum of x and y
11     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
12         require((z = x + y) >= x);
13     }
14 
15     /// @notice Returns x - y, reverts if underflows
16     /// @param x The minuend
17     /// @param y The subtrahend
18     /// @return z The difference of x and y
19     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
20         require((z = x - y) <= x);
21     }
22 
23     /// @notice Returns x * y, reverts if overflows
24     /// @param x The multiplicand
25     /// @param y The multiplier
26     /// @return z The product of x and y
27     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
28         require(x == 0 || (z = x * y) / x == y);
29     }
30 
31     /// @notice Returns x + y, reverts if overflows or underflows
32     /// @param x The augend
33     /// @param y The addend
34     /// @return z The sum of x and y
35     function add(int256 x, int256 y) internal pure returns (int256 z) {
36         require((z = x + y) >= x == (y >= 0));
37     }
38 
39     /// @notice Returns x - y, reverts if overflows or underflows
40     /// @param x The minuend
41     /// @param y The subtrahend
42     /// @return z The difference of x and y
43     function sub(int256 x, int256 y) internal pure returns (int256 z) {
44         require((z = x - y) <= x == (y >= 0));
45     }
46 }