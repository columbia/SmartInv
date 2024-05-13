1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 library SignedSafeMath {
6     int256 private constant _INT256_MIN = -2**255;
7 
8     /**
9      * @dev Returns the multiplication of two signed integers, reverting on
10      * overflow.
11      *
12      * Counterpart to Solidity's `*` operator.
13      *
14      * Requirements:
15      *
16      * - Multiplication cannot overflow.
17      */
18     function mul(int256 a, int256 b) internal pure returns (int256) {
19         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
20         // benefit is lost if 'b' is also tested.
21         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
22         if (a == 0) {
23             return 0;
24         }
25 
26         require(
27             !(a == -1 && b == _INT256_MIN),
28             "SignedSafeMath: multiplication overflow"
29         );
30 
31         int256 c = a * b;
32         require(c / a == b, "SignedSafeMath: multiplication overflow");
33 
34         return c;
35     }
36 
37     /**
38      * @dev Returns the integer division of two signed integers. Reverts on
39      * division by zero. The result is rounded towards zero.
40      *
41      * Counterpart to Solidity's `/` operator. Note: this function uses a
42      * `revert` opcode (which leaves remaining gas untouched) while Solidity
43      * uses an invalid opcode to revert (consuming all remaining gas).
44      *
45      * Requirements:
46      *
47      * - The divisor cannot be zero.
48      */
49     function div(int256 a, int256 b) internal pure returns (int256) {
50         require(b != 0, "SignedSafeMath: division by zero");
51         require(
52             !(b == -1 && a == _INT256_MIN),
53             "SignedSafeMath: division overflow"
54         );
55 
56         int256 c = a / b;
57 
58         return c;
59     }
60 
61     /**
62      * @dev Returns the subtraction of two signed integers, reverting on
63      * overflow.
64      *
65      * Counterpart to Solidity's `-` operator.
66      *
67      * Requirements:
68      *
69      * - Subtraction cannot overflow.
70      */
71     function sub(int256 a, int256 b) internal pure returns (int256) {
72         int256 c = a - b;
73         require(
74             (b >= 0 && c <= a) || (b < 0 && c > a),
75             "SignedSafeMath: subtraction overflow"
76         );
77 
78         return c;
79     }
80 
81     /**
82      * @dev Returns the addition of two signed integers, reverting on
83      * overflow.
84      *
85      * Counterpart to Solidity's `+` operator.
86      *
87      * Requirements:
88      *
89      * - Addition cannot overflow.
90      */
91     function add(int256 a, int256 b) internal pure returns (int256) {
92         int256 c = a + b;
93         require(
94             (b >= 0 && c >= a) || (b < 0 && c < a),
95             "SignedSafeMath: addition overflow"
96         );
97 
98         return c;
99     }
100 
101     function toUInt256(int256 a) internal pure returns (uint256) {
102         require(a >= 0, "Integer < 0");
103         return uint256(a);
104     }
105 }
