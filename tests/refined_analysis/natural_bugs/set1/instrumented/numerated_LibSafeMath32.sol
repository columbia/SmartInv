1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 /**
6  * @author Publius
7  * @title LibSafeMath32 is a uint32 variation of Open Zeppelin's Safe Math library.
8 **/
9 library LibSafeMath32 {
10     /**
11      * @dev Returns the addition of two unsigned integers, with an overflow flag.
12      *
13      * _Available since v3.4._
14      */
15     function tryAdd(uint32 a, uint32 b) internal pure returns (bool, uint32) {
16         uint32 c = a + b;
17         if (c < a) return (false, 0);
18         return (true, c);
19     }
20 
21     /**
22      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
23      *
24      * _Available since v3.4._
25      */
26     function trySub(uint32 a, uint32 b) internal pure returns (bool, uint32) {
27         if (b > a) return (false, 0);
28         return (true, a - b);
29     }
30 
31     /**
32      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
33      *
34      * _Available since v3.4._
35      */
36     function tryMul(uint32 a, uint32 b) internal pure returns (bool, uint32) {
37         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
38         // benefit is lost if 'b' is also tested.
39         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
40         if (a == 0) return (true, 0);
41         uint32 c = a * b;
42         if (c / a != b) return (false, 0);
43         return (true, c);
44     }
45 
46     /**
47      * @dev Returns the division of two unsigned integers, with a division by zero flag.
48      *
49      * _Available since v3.4._
50      */
51     function tryDiv(uint32 a, uint32 b) internal pure returns (bool, uint32) {
52         if (b == 0) return (false, 0);
53         return (true, a / b);
54     }
55 
56     /**
57      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
58      *
59      * _Available since v3.4._
60      */
61     function tryMod(uint32 a, uint32 b) internal pure returns (bool, uint32) {
62         if (b == 0) return (false, 0);
63         return (true, a % b);
64     }
65 
66     /**
67      * @dev Returns the addition of two unsigned integers, reverting on
68      * overflow.
69      *
70      * Counterpart to Solidity's `+` operator.
71      *
72      * Requirements:
73      *
74      * - Addition cannot overflow.
75      */
76     function add(uint32 a, uint32 b) internal pure returns (uint32) {
77         uint32 c = a + b;
78         require(c >= a, "SafeMath: addition overflow");
79         return c;
80     }
81 
82     /**
83      * @dev Returns the subtraction of two unsigned integers, reverting on
84      * overflow (when the result is negative).
85      *
86      * Counterpart to Solidity's `-` operator.
87      *
88      * Requirements:
89      *
90      * - Subtraction cannot overflow.
91      */
92     function sub(uint32 a, uint32 b) internal pure returns (uint32) {
93         require(b <= a, "SafeMath: subtraction overflow");
94         return a - b;
95     }
96 
97     /**
98      * @dev Returns the multiplication of two unsigned integers, reverting on
99      * overflow.
100      *
101      * Counterpart to Solidity's `*` operator.
102      *
103      * Requirements:
104      *
105      * - Multiplication cannot overflow.
106      */
107     function mul(uint32 a, uint32 b) internal pure returns (uint32) {
108         if (a == 0) return 0;
109         uint32 c = a * b;
110         require(c / a == b, "SafeMath: multiplication overflow");
111         return c;
112     }
113 
114     /**
115      * @dev Returns the integer division of two unsigned integers, reverting on
116      * division by zero. The result is rounded towards zero.
117      *
118      * Counterpart to Solidity's `/` operator. Note: this function uses a
119      * `revert` opcode (which leaves remaining gas untouched) while Solidity
120      * uses an invalid opcode to revert (consuming all remaining gas).
121      *
122      * Requirements:
123      *
124      * - The divisor cannot be zero.
125      */
126     function div(uint32 a, uint32 b) internal pure returns (uint32) {
127         require(b > 0, "SafeMath: division by zero");
128         return a / b;
129     }
130 
131     /**
132      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
133      * reverting when dividing by zero.
134      *
135      * Counterpart to Solidity's `%` operator. This function uses a `revert`
136      * opcode (which leaves remaining gas untouched) while Solidity uses an
137      * invalid opcode to revert (consuming all remaining gas).
138      *
139      * Requirements:
140      *
141      * - The divisor cannot be zero.
142      */
143     function mod(uint32 a, uint32 b) internal pure returns (uint32) {
144         require(b > 0, "SafeMath: modulo by zero");
145         return a % b;
146     }
147 
148     /**
149      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
150      * overflow (when the result is negative).
151      *
152      * CAUTION: This function is deprecated because it requires allocating memory for the error
153      * message unnecessarily. For custom revert reasons use {trySub}.
154      *
155      * Counterpart to Solidity's `-` operator.
156      *
157      * Requirements:
158      *
159      * - Subtraction cannot overflow.
160      */
161     function sub(uint32 a, uint32 b, string memory errorMessage) internal pure returns (uint32) {
162         require(b <= a, errorMessage);
163         return a - b;
164     }
165 
166     /**
167      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
168      * division by zero. The result is rounded towards zero.
169      *
170      * CAUTION: This function is deprecated because it requires allocating memory for the error
171      * message unnecessarily. For custom revert reasons use {tryDiv}.
172      *
173      * Counterpart to Solidity's `/` operator. Note: this function uses a
174      * `revert` opcode (which leaves remaining gas untouched) while Solidity
175      * uses an invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      *
179      * - The divisor cannot be zero.
180      */
181     function div(uint32 a, uint32 b, string memory errorMessage) internal pure returns (uint32) {
182         require(b > 0, errorMessage);
183         return a / b;
184     }
185 
186     /**
187      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
188      * reverting with custom message when dividing by zero.
189      *
190      * CAUTION: This function is deprecated because it requires allocating memory for the error
191      * message unnecessarily. For custom revert reasons use {tryMod}.
192      *
193      * Counterpart to Solidity's `%` operator. This function uses a `revert`
194      * opcode (which leaves remaining gas untouched) while Solidity uses an
195      * invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      *
199      * - The divisor cannot be zero.
200      */
201     function mod(uint32 a, uint32 b, string memory errorMessage) internal pure returns (uint32) {
202         require(b > 0, errorMessage);
203         return a % b;
204     }
205 }
