1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 /**
6  * @title SignedSafeMath
7  * @dev Signed math operations with safety checks that revert on error.
8  */
9 library LibSafeMathSigned128 {
10     int128 constant private _INT128_MIN = -2**127;
11 
12     /**
13      * @dev Returns the multiplication of two signed integers, reverting on
14      * overflow.
15      *
16      * Counterpart to Solidity's `*` operator.
17      *
18      * Requirements:
19      *
20      * - Multiplication cannot overflow.
21      */
22     function mul(int128 a, int128 b) internal pure returns (int128) {
23         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
24         // benefit is lost if 'b' is also tested.
25         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
26         if (a == 0) {
27             return 0;
28         }
29 
30         require(!(a == -1 && b == _INT128_MIN), "SignedSafeMath: multiplication overflow");
31 
32         int128 c = a * b;
33         require(c / a == b, "SignedSafeMath: multiplication overflow");
34 
35         return c;
36     }
37 
38     /**
39      * @dev Returns the integer division of two signed integers. Reverts on
40      * division by zero. The result is rounded towards zero.
41      *
42      * Counterpart to Solidity's `/` operator. Note: this function uses a
43      * `revert` opcode (which leaves remaining gas untouched) while Solidity
44      * uses an invalid opcode to revert (consuming all remaining gas).
45      *
46      * Requirements:
47      *
48      * - The divisor cannot be zero.
49      */
50     function div(int128 a, int128 b) internal pure returns (int128) {
51         require(b != 0, "SignedSafeMath: division by zero");
52         require(!(b == -1 && a == _INT128_MIN), "SignedSafeMath: division overflow");
53 
54         int128 c = a / b;
55 
56         return c;
57     }
58 
59     /**
60      * @dev Returns the subtraction of two signed integers, reverting on
61      * overflow.
62      *
63      * Counterpart to Solidity's `-` operator.
64      *
65      * Requirements:
66      *
67      * - Subtraction cannot overflow.
68      */
69     function sub(int128 a, int128 b) internal pure returns (int128) {
70         int128 c = a - b;
71         require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");
72 
73         return c;
74     }
75 
76     /**
77      * @dev Returns the addition of two signed integers, reverting on
78      * overflow.
79      *
80      * Counterpart to Solidity's `+` operator.
81      *
82      * Requirements:
83      *
84      * - Addition cannot overflow.
85      */
86     function add(int128 a, int128 b) internal pure returns (int128) {
87         int128 c = a + b;
88         require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");
89 
90         return c;
91     }
92 }