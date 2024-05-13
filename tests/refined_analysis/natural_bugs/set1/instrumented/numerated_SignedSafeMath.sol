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
26         require(!(a == -1 && b == _INT256_MIN), "SignedSafeMath: multiplication overflow");
27 
28         int256 c = a * b;
29         require(c / a == b, "SignedSafeMath: multiplication overflow");
30 
31         return c;
32     }
33 
34     /**
35      * @dev Returns the integer division of two signed integers. Reverts on
36      * division by zero. The result is rounded towards zero.
37      *
38      * Counterpart to Solidity's `/` operator. Note: this function uses a
39      * `revert` opcode (which leaves remaining gas untouched) while Solidity
40      * uses an invalid opcode to revert (consuming all remaining gas).
41      *
42      * Requirements:
43      *
44      * - The divisor cannot be zero.
45      */
46     function div(int256 a, int256 b) internal pure returns (int256) {
47         require(b != 0, "SignedSafeMath: division by zero");
48         require(!(b == -1 && a == _INT256_MIN), "SignedSafeMath: division overflow");
49 
50         int256 c = a / b;
51 
52         return c;
53     }
54 
55     /**
56      * @dev Returns the subtraction of two signed integers, reverting on
57      * overflow.
58      *
59      * Counterpart to Solidity's `-` operator.
60      *
61      * Requirements:
62      *
63      * - Subtraction cannot overflow.
64      */
65     function sub(int256 a, int256 b) internal pure returns (int256) {
66         int256 c = a - b;
67         require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");
68 
69         return c;
70     }
71 
72     /**
73      * @dev Returns the addition of two signed integers, reverting on
74      * overflow.
75      *
76      * Counterpart to Solidity's `+` operator.
77      *
78      * Requirements:
79      *
80      * - Addition cannot overflow.
81      */
82     function add(int256 a, int256 b) internal pure returns (int256) {
83         int256 c = a + b;
84         require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");
85         return c;
86     }
87 
88     function toUInt256(int256 a) internal pure returns (uint256) {
89         require(a >= 0, "Integer < 0");
90         return uint256(a);
91     }
92 }
