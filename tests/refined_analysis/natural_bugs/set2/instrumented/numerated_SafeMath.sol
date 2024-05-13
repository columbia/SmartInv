1 pragma solidity ^0.5.16;
2 
3 // From https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/Math.sol
4 // Subject to the MIT license.
5 
6 /**
7  * @dev Wrappers over Solidity's arithmetic operations with added overflow
8  * checks.
9  *
10  * Arithmetic operations in Solidity wrap on overflow. This can easily result
11  * in bugs, because programmers usually assume that an overflow raises an
12  * error, which is the standard behavior in high level programming languages.
13  * `SafeMath` restores this intuition by reverting the transaction when an
14  * operation overflows.
15  *
16  * Using this library instead of the unchecked operations eliminates an entire
17  * class of bugs, so it's recommended to use it always.
18  */
19 library SafeMath {
20     /**
21      * @dev Returns the addition of two unsigned integers, reverting on overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the addition of two unsigned integers, reverting with custom message on overflow.
37      *
38      * Counterpart to Solidity's `+` operator.
39      *
40      * Requirements:
41      * - Addition cannot overflow.
42      */
43     function add(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         uint256 c = a + b;
45         require(c >= a, errorMessage);
46 
47         return c;
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting on underflow (when the result is negative).
52      *
53      * Counterpart to Solidity's `-` operator.
54      *
55      * Requirements:
56      * - Subtraction cannot underflow.
57      */
58     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59         return sub(a, b, "SafeMath: subtraction underflow");
60     }
61 
62     /**
63      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on underflow (when the result is negative).
64      *
65      * Counterpart to Solidity's `-` operator.
66      *
67      * Requirements:
68      * - Subtraction cannot underflow.
69      */
70     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
71         require(b <= a, errorMessage);
72         uint256 c = a - b;
73 
74         return c;
75     }
76 
77     /**
78      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
79      *
80      * Counterpart to Solidity's `*` operator.
81      *
82      * Requirements:
83      * - Multiplication cannot overflow.
84      */
85     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
86         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
87         // benefit is lost if 'b' is also tested.
88         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
89         if (a == 0) {
90             return 0;
91         }
92 
93         uint256 c = a * b;
94         require(c / a == b, "SafeMath: multiplication overflow");
95 
96         return c;
97     }
98 
99     /**
100      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
101      *
102      * Counterpart to Solidity's `*` operator.
103      *
104      * Requirements:
105      * - Multiplication cannot overflow.
106      */
107     function mul(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
108         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
109         // benefit is lost if 'b' is also tested.
110         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
111         if (a == 0) {
112             return 0;
113         }
114 
115         uint256 c = a * b;
116         require(c / a == b, errorMessage);
117 
118         return c;
119     }
120 
121     /**
122      * @dev Returns the integer division of two unsigned integers.
123      * Reverts on division by zero. The result is rounded towards zero.
124      *
125      * Counterpart to Solidity's `/` operator. Note: this function uses a
126      * `revert` opcode (which leaves remaining gas untouched) while Solidity
127      * uses an invalid opcode to revert (consuming all remaining gas).
128      *
129      * Requirements:
130      * - The divisor cannot be zero.
131      */
132     function div(uint256 a, uint256 b) internal pure returns (uint256) {
133         return div(a, b, "SafeMath: division by zero");
134     }
135 
136     /**
137      * @dev Returns the integer division of two unsigned integers.
138      * Reverts with custom message on division by zero. The result is rounded towards zero.
139      *
140      * Counterpart to Solidity's `/` operator. Note: this function uses a
141      * `revert` opcode (which leaves remaining gas untouched) while Solidity
142      * uses an invalid opcode to revert (consuming all remaining gas).
143      *
144      * Requirements:
145      * - The divisor cannot be zero.
146      */
147     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
148         // Solidity only automatically asserts when dividing by 0
149         require(b > 0, errorMessage);
150         uint256 c = a / b;
151         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
152 
153         return c;
154     }
155 
156     /**
157      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
158      * Reverts when dividing by zero.
159      *
160      * Counterpart to Solidity's `%` operator. This function uses a `revert`
161      * opcode (which leaves remaining gas untouched) while Solidity uses an
162      * invalid opcode to revert (consuming all remaining gas).
163      *
164      * Requirements:
165      * - The divisor cannot be zero.
166      */
167     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
168         return mod(a, b, "SafeMath: modulo by zero");
169     }
170 
171     /**
172      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
173      * Reverts with custom message when dividing by zero.
174      *
175      * Counterpart to Solidity's `%` operator. This function uses a `revert`
176      * opcode (which leaves remaining gas untouched) while Solidity uses an
177      * invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      * - The divisor cannot be zero.
181      */
182     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
183         require(b != 0, errorMessage);
184         return a % b;
185     }
186 }