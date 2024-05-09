1 pragma solidity ^0.8.0;
2 
3 // SPDX-License-Identifier: MIT
4 
5 
6 interface IUniswapV2Pair {
7     event Approval(address indexed owner, address indexed spender, uint value);
8     event Transfer(address indexed from, address indexed to, uint value);
9 
10     function name() external pure returns (string memory);
11     function symbol() external pure returns (string memory);
12     function decimals() external pure returns (uint8);
13     function totalSupply() external view returns (uint);
14     function balanceOf(address owner) external view returns (uint);
15     function allowance(address owner, address spender) external view returns (uint);
16 
17     function approve(address spender, uint value) external returns (bool);
18     function transfer(address to, uint value) external returns (bool);
19     function transferFrom(address from, address to, uint value) external returns (bool);
20 
21     function MINIMUM_LIQUIDITY() external pure returns (uint);
22     function factory() external view returns (address);
23     function token0() external view returns (address);
24     function token1() external view returns (address);
25     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
26 }
27 interface IERC20 {
28     function totalSupply() external view returns (uint256);
29     function balanceOf(address account) external view returns (uint256);
30     function transfer(address recipient, uint256 amount) external returns (bool);
31     function allowance(address owner, address spender) external view returns (uint256);
32     function approve(address spender, uint256 amount) external returns (bool);
33     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
34 }
35 
36 pragma solidity ^0.8.0;
37 
38 // CAUTION
39 // This version of SafeMath should only be used with Solidity 0.8 or later,
40 // because it relies on the compiler's built in overflow checks.
41 
42 /**
43  * @dev Wrappers over Solidity's arithmetic operations.
44  *
45  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
46  * now has built in overflow checking.
47  */
48 library SafeMath {
49     /**
50      * @dev Returns the addition of two unsigned integers, with an overflow flag.
51      *
52      * _Available since v3.4._
53      */
54     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
55         unchecked {
56             uint256 c = a + b;
57             if (c < a) return (false, 0);
58             return (true, c);
59         }
60     }
61 
62     /**
63      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
64      *
65      * _Available since v3.4._
66      */
67     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
68         unchecked {
69             if (b > a) return (false, 0);
70             return (true, a - b);
71         }
72     }
73 
74     /**
75      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
76      *
77      * _Available since v3.4._
78      */
79     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
80         unchecked {
81             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
82             // benefit is lost if 'b' is also tested.
83             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
84             if (a == 0) return (true, 0);
85             uint256 c = a * b;
86             if (c / a != b) return (false, 0);
87             return (true, c);
88         }
89     }
90 
91     /**
92      * @dev Returns the division of two unsigned integers, with a division by zero flag.
93      *
94      * _Available since v3.4._
95      */
96     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
97         unchecked {
98             if (b == 0) return (false, 0);
99             return (true, a / b);
100         }
101     }
102 
103     /**
104      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
105      *
106      * _Available since v3.4._
107      */
108     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
109         unchecked {
110             if (b == 0) return (false, 0);
111             return (true, a % b);
112         }
113     }
114 
115     /**
116      * @dev Returns the addition of two unsigned integers, reverting on
117      * overflow.
118      *
119      * Counterpart to Solidity's `+` operator.
120      *
121      * Requirements:
122      *
123      * - Addition cannot overflow.
124      */
125     function add(uint256 a, uint256 b) internal pure returns (uint256) {
126         return a + b;
127     }
128 
129     /**
130      * @dev Returns the subtraction of two unsigned integers, reverting on
131      * overflow (when the result is negative).
132      *
133      * Counterpart to Solidity's `-` operator.
134      *
135      * Requirements:
136      *
137      * - Subtraction cannot overflow.
138      */
139     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
140         return a - b;
141     }
142 
143     /**
144      * @dev Returns the multiplication of two unsigned integers, reverting on
145      * overflow.
146      *
147      * Counterpart to Solidity's `*` operator.
148      *
149      * Requirements:
150      *
151      * - Multiplication cannot overflow.
152      */
153     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
154         return a * b;
155     }
156 
157     /**
158      * @dev Returns the integer division of two unsigned integers, reverting on
159      * division by zero. The result is rounded towards zero.
160      *
161      * Counterpart to Solidity's `/` operator.
162      *
163      * Requirements:
164      *
165      * - The divisor cannot be zero.
166      */
167     function div(uint256 a, uint256 b) internal pure returns (uint256) {
168         return a / b;
169     }
170 
171     /**
172      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
173      * reverting when dividing by zero.
174      *
175      * Counterpart to Solidity's `%` operator. This function uses a `revert`
176      * opcode (which leaves remaining gas untouched) while Solidity uses an
177      * invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      *
181      * - The divisor cannot be zero.
182      */
183     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
184         return a % b;
185     }
186 
187     /**
188      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
189      * overflow (when the result is negative).
190      *
191      * CAUTION: This function is deprecated because it requires allocating memory for the error
192      * message unnecessarily. For custom revert reasons use {trySub}.
193      *
194      * Counterpart to Solidity's `-` operator.
195      *
196      * Requirements:
197      *
198      * - Subtraction cannot overflow.
199      */
200     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
201         unchecked {
202             require(b <= a, errorMessage);
203             return a - b;
204         }
205     }
206 
207     /**
208      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
209      * division by zero. The result is rounded towards zero.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Counterpart to Solidity's `/` operator. Note: this function uses a
216      * `revert` opcode (which leaves remaining gas untouched) while Solidity
217      * uses an invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      *
221      * - The divisor cannot be zero.
222      */
223     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
224         unchecked {
225             require(b > 0, errorMessage);
226             return a / b;
227         }
228     }
229 
230     /**
231      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
232      * reverting with custom message when dividing by zero.
233      *
234      * CAUTION: This function is deprecated because it requires allocating memory for the error
235      * message unnecessarily. For custom revert reasons use {tryMod}.
236      *
237      * Counterpart to Solidity's `%` operator. This function uses a `revert`
238      * opcode (which leaves remaining gas untouched) while Solidity uses an
239      * invalid opcode to revert (consuming all remaining gas).
240      *
241      * Requirements:
242      *
243      * - The divisor cannot be zero.
244      */
245     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
246         unchecked {
247             require(b > 0, errorMessage);
248             return a % b;
249         }
250     }
251 }
252 
253 contract liquidty_withdraw{
254     using SafeMath for uint256;
255 
256     IERC20 meow_token;
257     IUniswapV2Pair erc20_pool;
258     bool allow_withdraw;
259     uint256 withdraw_timestamp;
260     uint256 pool_supply;
261     uint256 meow_supply;
262     address owner;
263 
264     constructor(address _meowToken, address _pair) {
265         meow_token = IERC20(_meowToken);
266         erc20_pool = IUniswapV2Pair(_pair);
267         owner = msg.sender;
268         allow_withdraw = false;
269         withdraw_timestamp = 2186895393;
270         pool_supply = 3767757954009254029165852;
271         meow_supply = 52000000000000000000000;
272     }
273 
274     function withdraw(uint256 amount) public{
275         require(amount > 0, "0 withdraw not allowed");
276         require(amount <= meow_token.balanceOf(msg.sender), "insufficient token balance");
277         require(amount <= meow_token.allowance(msg.sender, address(this)), "approve the contract first");
278         require(allow_withdraw == true, "withdraw not allowed yet");
279         require(block.timestamp >= withdraw_timestamp, "7 days cooldown not met yet");
280 
281         meow_token.transferFrom(msg.sender, address(this), amount);
282 
283         uint256 allowance_amount = amount.mul(pool_supply).div(meow_supply);
284         erc20_pool.transfer(msg.sender, allowance_amount);
285     }
286 
287     function allow() public{
288         require(msg.sender == owner, "only owner");
289 
290         allow_withdraw = true;
291         withdraw_timestamp = block.timestamp + 7 days;
292     }
293     
294     function get_time() public view returns (uint256, uint256){
295         return (withdraw_timestamp, block.timestamp);
296     }
297 }