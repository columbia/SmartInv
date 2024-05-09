1 pragma solidity ^0.8.0;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5     function balanceOf(address account) external view returns (uint256);
6     function transfer(address recipient, uint256 amount) external returns (bool);
7     function allowance(address owner, address spender) external view returns (uint256);
8     function approve(address spender, uint256 amount) external returns (bool);
9     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
10 }
11 
12 // SPDX-License-Identifier: MIT
13 
14 pragma solidity ^0.8.0;
15 
16 // CAUTION
17 // This version of SafeMath should only be used with Solidity 0.8 or later,
18 // because it relies on the compiler's built in overflow checks.
19 
20 /**
21  * @dev Wrappers over Solidity's arithmetic operations.
22  *
23  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
24  * now has built in overflow checking.
25  */
26 library SafeMath {
27     /**
28      * @dev Returns the addition of two unsigned integers, with an overflow flag.
29      *
30      * _Available since v3.4._
31      */
32     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
33         unchecked {
34             uint256 c = a + b;
35             if (c < a) return (false, 0);
36             return (true, c);
37         }
38     }
39 
40     /**
41      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
42      *
43      * _Available since v3.4._
44      */
45     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
46         unchecked {
47             if (b > a) return (false, 0);
48             return (true, a - b);
49         }
50     }
51 
52     /**
53      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
54      *
55      * _Available since v3.4._
56      */
57     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
58         unchecked {
59             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
60             // benefit is lost if 'b' is also tested.
61             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
62             if (a == 0) return (true, 0);
63             uint256 c = a * b;
64             if (c / a != b) return (false, 0);
65             return (true, c);
66         }
67     }
68 
69     /**
70      * @dev Returns the division of two unsigned integers, with a division by zero flag.
71      *
72      * _Available since v3.4._
73      */
74     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
75         unchecked {
76             if (b == 0) return (false, 0);
77             return (true, a / b);
78         }
79     }
80 
81     /**
82      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
83      *
84      * _Available since v3.4._
85      */
86     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
87         unchecked {
88             if (b == 0) return (false, 0);
89             return (true, a % b);
90         }
91     }
92 
93     /**
94      * @dev Returns the addition of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `+` operator.
98      *
99      * Requirements:
100      *
101      * - Addition cannot overflow.
102      */
103     function add(uint256 a, uint256 b) internal pure returns (uint256) {
104         return a + b;
105     }
106 
107     /**
108      * @dev Returns the subtraction of two unsigned integers, reverting on
109      * overflow (when the result is negative).
110      *
111      * Counterpart to Solidity's `-` operator.
112      *
113      * Requirements:
114      *
115      * - Subtraction cannot overflow.
116      */
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         return a - b;
119     }
120 
121     /**
122      * @dev Returns the multiplication of two unsigned integers, reverting on
123      * overflow.
124      *
125      * Counterpart to Solidity's `*` operator.
126      *
127      * Requirements:
128      *
129      * - Multiplication cannot overflow.
130      */
131     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
132         return a * b;
133     }
134 
135     /**
136      * @dev Returns the integer division of two unsigned integers, reverting on
137      * division by zero. The result is rounded towards zero.
138      *
139      * Counterpart to Solidity's `/` operator.
140      *
141      * Requirements:
142      *
143      * - The divisor cannot be zero.
144      */
145     function div(uint256 a, uint256 b) internal pure returns (uint256) {
146         return a / b;
147     }
148 
149     /**
150      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
151      * reverting when dividing by zero.
152      *
153      * Counterpart to Solidity's `%` operator. This function uses a `revert`
154      * opcode (which leaves remaining gas untouched) while Solidity uses an
155      * invalid opcode to revert (consuming all remaining gas).
156      *
157      * Requirements:
158      *
159      * - The divisor cannot be zero.
160      */
161     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
162         return a % b;
163     }
164 
165     /**
166      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
167      * overflow (when the result is negative).
168      *
169      * CAUTION: This function is deprecated because it requires allocating memory for the error
170      * message unnecessarily. For custom revert reasons use {trySub}.
171      *
172      * Counterpart to Solidity's `-` operator.
173      *
174      * Requirements:
175      *
176      * - Subtraction cannot overflow.
177      */
178     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
179         unchecked {
180             require(b <= a, errorMessage);
181             return a - b;
182         }
183     }
184 
185     /**
186      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
187      * division by zero. The result is rounded towards zero.
188      *
189      * Counterpart to Solidity's `%` operator. This function uses a `revert`
190      * opcode (which leaves remaining gas untouched) while Solidity uses an
191      * invalid opcode to revert (consuming all remaining gas).
192      *
193      * Counterpart to Solidity's `/` operator. Note: this function uses a
194      * `revert` opcode (which leaves remaining gas untouched) while Solidity
195      * uses an invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      *
199      * - The divisor cannot be zero.
200      */
201     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
202         unchecked {
203             require(b > 0, errorMessage);
204             return a / b;
205         }
206     }
207 
208     /**
209      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
210      * reverting with custom message when dividing by zero.
211      *
212      * CAUTION: This function is deprecated because it requires allocating memory for the error
213      * message unnecessarily. For custom revert reasons use {tryMod}.
214      *
215      * Counterpart to Solidity's `%` operator. This function uses a `revert`
216      * opcode (which leaves remaining gas untouched) while Solidity uses an
217      * invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      *
221      * - The divisor cannot be zero.
222      */
223     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
224         unchecked {
225             require(b > 0, errorMessage);
226             return a % b;
227         }
228     }
229 }
230 
231 contract presale_tokens {
232     using SafeMath for uint256;
233     
234     IERC20 meow_token;
235     address owner;
236     address payable beneficiary;
237     
238     constructor(address _token, address payable _beneficiary) {
239         meow_token = IERC20(_token);
240         owner = payable(msg.sender);
241         beneficiary = _beneficiary;
242     }
243     
244     function sell() public payable{
245         require(msg.value > 0, "0 eth sent");
246         require(meow_token.balanceOf(address(this)) >= msg.value.mul(1e18).div(0.005e18) , "token supply exceeded");
247         meow_token.transfer(msg.sender, msg.value.mul(1e18).div(0.005e18));
248     }
249     
250     
251     function withdraw() public {
252         require(msg.sender == owner, "only Owner");
253         beneficiary.transfer(address(this).balance);
254     }
255     
256     receive() external payable {
257         sell();
258     }
259 }