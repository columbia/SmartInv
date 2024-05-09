1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.12;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      *
27      * - Addition cannot overflow.
28      */
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      *
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      *
58      * - Subtraction cannot overflow.
59      */
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the multiplication of two unsigned integers, reverting on
69      * overflow.
70      *
71      * Counterpart to Solidity's `*` operator.
72      *
73      * Requirements:
74      *
75      * - Multiplication cannot overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the integer division of two unsigned integers. Reverts on
93      * division by zero. The result is rounded towards zero.
94      *
95      * Counterpart to Solidity's `/` operator. Note: this function uses a
96      * `revert` opcode (which leaves remaining gas untouched) while Solidity
97      * uses an invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      *
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
109      * division by zero. The result is rounded towards zero.
110      *
111      * Counterpart to Solidity's `/` operator. Note: this function uses a
112      * `revert` opcode (which leaves remaining gas untouched) while Solidity
113      * uses an invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      *
117      * - The divisor cannot be zero.
118      */
119     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         return mod(a, b, "SafeMath: modulo by zero");
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * Reverts with custom message when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b != 0, errorMessage);
157         return a % b;
158     }
159 }
160 
161 
162 
163 /**
164  * @dev Interface of the ERC20 standard as defined in the EIP.
165  */
166 interface IERC20 {
167     /**
168      * @dev Returns the amount of tokens in existence.
169      */
170     function totalSupply() external view returns (uint256);
171 
172     /**
173      * @dev Returns the amount of tokens owned by `account`.
174      */
175     function balanceOf(address account) external view returns (uint256);
176 
177     /**
178      * @dev Moves `amount` tokens from the caller's account to `recipient`.
179      *
180      * Returns a boolean value indicating whether the operation succeeded.
181      *
182      * Emits a {Transfer} event.
183      */
184     function transfer(address recipient, uint256 amount) external returns (bool);
185 
186     /**
187      * @dev Returns the remaining number of tokens that `spender` will be
188      * allowed to spend on behalf of `owner` through {transferFrom}. This is
189      * zero by default.
190      *
191      * This value changes when {approve} or {transferFrom} are called.
192      */
193     function allowance(address owner, address spender) external view returns (uint256);
194 
195     /**
196      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
197      *
198      * Returns a boolean value indicating whether the operation succeeded.
199      *
200      * IMPORTANT: Beware that changing an allowance with this method brings the risk
201      * that someone may use both the old and the new allowance by unfortunate
202      * transaction ordering. One possible solution to mitigate this race
203      * condition is to first reduce the spender's allowance to 0 and set the
204      * desired value afterwards:
205      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
206      *
207      * Emits an {Approval} event.
208      */
209     function approve(address spender, uint256 amount) external returns (bool);
210 
211     /**
212      * @dev Moves `amount` tokens from `sender` to `recipient` using the
213      * allowance mechanism. `amount` is then deducted from the caller's
214      * allowance.
215      *
216      * Returns a boolean value indicating whether the operation succeeded.
217      *
218      * Emits a {Transfer} event.
219      */
220     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
221 
222     function burn(address to, uint256 value) external returns (bool);
223     function mint(address to, uint256 value) external returns (bool);
224     
225     /**
226      * @dev Emitted when `value` tokens are moved from one account (`from`) to
227      * another (`to`).
228      *
229      * Note that `value` may be zero.
230      */
231     event Transfer(address indexed from, address indexed to, uint256 value);
232 
233     /**
234      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
235      * a call to {approve}. `value` is the new allowance.
236      */
237     event Approval(address indexed owner, address indexed spender, uint256 value);
238 }
239 
240 
241 /**
242  * @title Blender is exchange contract for MILK2 <=> SHAKE tokens
243  *
244  * @dev Don't forget permit mint and burn in tokens contracts
245  */contract Blender {
246     using SafeMath for uint256;
247     
248     uint256 public constant  SHAKE_PRICE_STEP = 10*10**18;  //MILK2
249     
250     address public immutable MILK_ADDRESS;
251     address public immutable SHAKE_ADDRESS;
252     uint32  public immutable START_FROM_BLOCK;
253     
254     uint256 public currShakePrice;
255     
256     /**
257      * @dev Sets the values for {MILK_ADDRESS}, {SHAKE_ADDRESS}
258      * {START_FROM_BLOCK} , initializes {currShakePrice} with
259      * a default value of 1000*10**18.
260      */ 
261     constructor (
262         address _milkAddress,
263         address _shakeAddress,
264         uint32  _startFromBlock
265     )
266     public
267     {
268         MILK_ADDRESS     = _milkAddress;
269         SHAKE_ADDRESS    = _shakeAddress;
270         currShakePrice   = 1000*10**18; //MILK2
271         START_FROM_BLOCK = _startFromBlock;
272     }
273     
274     /**
275      * @dev Just exchage your MILK2 for one(1) SHAKE.
276      * Caller must have MILK2 on his/her balance, see `currShakePrice`
277      * Each call will increase SHAKE price with one step, see `SHAKE_PRICE_STEP`.
278      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
279      *
280      * Function can be called after `START_FROM_BLOCK` 
281      */
282     function getOneShake() external {
283         require(block.number >= START_FROM_BLOCK, "Please wait for start block");
284 
285         IERC20 milk2Token = IERC20(MILK_ADDRESS);
286 
287         require(milk2Token.balanceOf(msg.sender) >= currShakePrice, "There is no enough MILK2");
288         require(milk2Token.burn(msg.sender, currShakePrice), "Can't burn your MILK2");
289         
290         IERC20 shakeToken = IERC20(SHAKE_ADDRESS);
291         currShakePrice  = currShakePrice.add(SHAKE_PRICE_STEP);
292         shakeToken.mint(msg.sender, 1*10**18);
293         
294     }
295     
296     /**
297      * @dev Just exchange your SHAKE for MILK2.
298      * Caller must have SHAKE on his/her balance.
299      * `_amount` is amount of user's SHAKE that he/she want burn for get MILK2 
300      * Note that one need use `_amount` without decimals.
301      * 
302      * Note that MILK2 amount will calculate from the reduced by one step `currShakePrice`
303      *
304      * Function can be called after `START_FROM_BLOCK`
305      */
306     function getMilkForShake(uint16 _amount) external {
307         require(block.number >= START_FROM_BLOCK, "Please wait for start block");
308 
309         IERC20 shakeToken = IERC20(SHAKE_ADDRESS);
310         
311         require(shakeToken.balanceOf(msg.sender) >= uint256(_amount)*10**18, "There is no enough SHAKE");
312         require(shakeToken.burn(msg.sender, uint256(_amount)*10**18), "Can't burn your SHAKE");
313         
314         IERC20 milk2Token = IERC20(MILK_ADDRESS);
315         milk2Token.mint(msg.sender, uint256(_amount).mul(currShakePrice.sub(SHAKE_PRICE_STEP)));
316         
317     }
318     
319 }