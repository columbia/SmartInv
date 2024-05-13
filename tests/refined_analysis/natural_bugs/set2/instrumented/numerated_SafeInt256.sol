1 // SPDX-License-Identifier: GPL-3.0-only
2 pragma solidity =0.7.6;
3 
4 import "../global/Constants.sol";
5 
6 library SafeInt256 {
7     int256 private constant _INT256_MIN = type(int256).min;
8 
9     /// @dev Returns the multiplication of two signed integers, reverting on
10     /// overflow.
11 
12     /// Counterpart to Solidity's `*` operator.
13 
14     /// Requirements:
15 
16     /// - Multiplication cannot overflow.
17 
18     function mul(int256 a, int256 b) internal pure returns (int256 c) {
19         c = a * b;
20         if (a == -1) require (b == 0 || c / b == a);
21         else require (a == 0 || c / a == b);
22     }
23 
24     /// @dev Returns the integer division of two signed integers. Reverts on
25     /// division by zero. The result is rounded towards zero.
26 
27     /// Counterpart to Solidity's `/` operator. Note: this function uses a
28     /// `revert` opcode (which leaves remaining gas untouched) while Solidity
29     /// uses an invalid opcode to revert (consuming all remaining gas).
30 
31     /// Requirements:
32 
33     /// - The divisor cannot be zero.
34 
35     function div(int256 a, int256 b) internal pure returns (int256 c) {
36         require(!(b == -1 && a == _INT256_MIN)); // dev: int256 div overflow
37         // NOTE: solidity will automatically revert on divide by zero
38         c = a / b;
39     }
40 
41     function sub(int256 x, int256 y) internal pure returns (int256 z) {
42         //  taken from uniswap v3
43         require((z = x - y) <= x == (y >= 0));
44     }
45 
46     function add(int256 x, int256 y) internal pure returns (int256 z) {
47         require((z = x + y) >= x == (y >= 0));
48     }
49 
50     function neg(int256 x) internal pure returns (int256 y) {
51         return mul(-1, x);
52     }
53 
54     function abs(int256 x) internal pure returns (int256) {
55         if (x < 0) return neg(x);
56         else return x;
57     }
58 
59     function subNoNeg(int256 x, int256 y) internal pure returns (int256 z) {
60         z = sub(x, y);
61         require(z >= 0); // dev: int256 sub to negative
62 
63         return z;
64     }
65 
66     function toUint(int256 x) internal pure returns (uint256) {
67         require(x >= 0);
68         return uint256(x);
69     }
70 
71     function toInt(uint256 x) internal pure returns (int256) {
72         require (x <= uint256(type(int256).max)); // dev: toInt overflow
73         return int256(x);
74     }
75 
76     function max(int256 x, int256 y) internal pure returns (int256) {
77         return x > y ? x : y;
78     }
79 
80     function min(int256 x, int256 y) internal pure returns (int256) {
81         return x < y ? x : y;
82     }
83 }
