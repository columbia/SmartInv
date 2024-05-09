1 // hevm: flattened sources of src/rewardsDecayHolder.sol
2 pragma solidity >0.4.13 >=0.4.23 >=0.5.12 >=0.5.0 <0.6.0 >=0.5.10 <0.6.0 >=0.5.12 <0.6.0;
3 
4 ////// src/IERC20.sol
5 /* pragma solidity ^0.5.0; */
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
9  * the optional functions; to access them see {ERC20Detailed}.
10  */
11 interface IERC20 {
12     function decimals() external view returns (uint8);
13 
14     /**
15      * @dev Returns the amount of tokens in existence.
16      */
17     function totalSupply() external view returns (uint256);
18 
19     /**
20      * @dev Returns the amount of tokens owned by `account`.
21      */
22     function balanceOf(address account) external view returns (uint256);
23 
24     /**
25      * @dev Moves `amount` tokens from the caller's account to `recipient`.
26      *
27      * Returns a boolean value indicating whether the operation succeeded.
28      *
29      * Emits a {Transfer} event.
30      */
31     function transfer(address recipient, uint256 amount) external returns (bool);
32 
33     function mint(address account, uint256 amount) external;
34 
35     /**
36      * @dev Returns the remaining number of tokens that `spender` will be
37      * allowed to spend on behalf of `owner` through {transferFrom}. This is
38      * zero by default.
39      *
40      * This value changes when {approve} or {transferFrom} are called.
41      */
42     function allowance(address owner, address spender) external view returns (uint256);
43 
44     /**
45      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * IMPORTANT: Beware that changing an allowance with this method brings the risk
50      * that someone may use both the old and the new allowance by unfortunate
51      * transaction ordering. One possible solution to mitigate this race
52      * condition is to first reduce the spender's allowance to 0 and set the
53      * desired value afterwards:
54      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
55      *
56      * Emits an {Approval} event.
57      */
58     function approve(address spender, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Moves `amount` tokens from `sender` to `recipient` using the
62      * allowance mechanism. `amount` is then deducted from the caller's
63      * allowance.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transferFrom(
70         address sender,
71         address recipient,
72         uint256 amount
73     ) external returns (bool);
74 
75     /**
76      * @dev Emitted when `value` tokens are moved from one account (`from`) to
77      * another (`to`).
78      *
79      * Note that `value` may be zero.
80      */
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     /**
84      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
85      * a call to {approve}. `value` is the new allowance.
86      */
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 ////// src/safeMath.sol
91 /* pragma solidity ^0.5.0; */
92 
93 /**
94  * @dev Wrappers over Solidity's arithmetic operations with added overflow
95  * checks.
96  *
97  * Arithmetic operations in Solidity wrap on overflow. This can easily result
98  * in bugs, because programmers usually assume that an overflow raises an
99  * error, which is the standard behavior in high level programming languages.
100  * `SafeMath` restores this intuition by reverting the transaction when an
101  * operation overflows.
102  *
103  * Using this library instead of the unchecked operations eliminates an entire
104  * class of bugs, so it's recommended to use it always.
105  */
106 library SafeMath {
107     /**
108      * @dev Returns the addition of two unsigned integers, reverting on
109      * overflow.
110      *
111      * Counterpart to Solidity's `+` operator.
112      *
113      * Requirements:
114      * - Addition cannot overflow.
115      */
116     function add(uint256 a, uint256 b) internal pure returns (uint256) {
117         uint256 c = a + b;
118         require(c >= a, "SafeMath: addition overflow");
119 
120         return c;
121     }
122 
123     /**
124      * @dev Returns the subtraction of two unsigned integers, reverting on
125      * overflow (when the result is negative).
126      *
127      * Counterpart to Solidity's `-` operator.
128      *
129      * Requirements:
130      * - Subtraction cannot overflow.
131      */
132     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
133         return sub(a, b, "SafeMath: subtraction overflow");
134     }
135 
136     /**
137      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
138      * overflow (when the result is negative).
139      *
140      * Counterpart to Solidity's `-` operator.
141      *
142      * Requirements:
143      * - Subtraction cannot overflow.
144      *
145      * _Available since v2.4.0._
146      */
147     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
148         require(b <= a, errorMessage);
149         uint256 c = a - b;
150 
151         return c;
152     }
153 
154     /**
155      * @dev Returns the multiplication of two unsigned integers, reverting on
156      * overflow.
157      *
158      * Counterpart to Solidity's `*` operator.
159      *
160      * Requirements:
161      * - Multiplication cannot overflow.
162      */
163     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
164         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
165         // benefit is lost if 'b' is also tested.
166         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
167         if (a == 0) {
168             return 0;
169         }
170 
171         uint256 c = a * b;
172         require(c / a == b, "SafeMath: multiplication overflow");
173 
174         return c;
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers. Reverts on
179      * division by zero. The result is rounded towards zero.
180      *
181      * Counterpart to Solidity's `/` operator. Note: this function uses a
182      * `revert` opcode (which leaves remaining gas untouched) while Solidity
183      * uses an invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      * - The divisor cannot be zero.
187      */
188     function div(uint256 a, uint256 b) internal pure returns (uint256) {
189         return div(a, b, "SafeMath: division by zero");
190     }
191 
192     /**
193      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
194      * division by zero. The result is rounded towards zero.
195      *
196      * Counterpart to Solidity's `/` operator. Note: this function uses a
197      * `revert` opcode (which leaves remaining gas untouched) while Solidity
198      * uses an invalid opcode to revert (consuming all remaining gas).
199      *
200      * Requirements:
201      * - The divisor cannot be zero.
202      *
203      * _Available since v2.4.0._
204      */
205     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
206         // Solidity only automatically asserts when dividing by 0
207         require(b > 0, errorMessage);
208         uint256 c = a / b;
209         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
210 
211         return c;
212     }
213 
214     /**
215      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
216      * Reverts when dividing by zero.
217      *
218      * Counterpart to Solidity's `%` operator. This function uses a `revert`
219      * opcode (which leaves remaining gas untouched) while Solidity uses an
220      * invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      * - The divisor cannot be zero.
224      */
225     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
226         return mod(a, b, "SafeMath: modulo by zero");
227     }
228 
229     /**
230      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
231      * Reverts with custom message when dividing by zero.
232      *
233      * Counterpart to Solidity's `%` operator. This function uses a `revert`
234      * opcode (which leaves remaining gas untouched) while Solidity uses an
235      * invalid opcode to revert (consuming all remaining gas).
236      *
237      * Requirements:
238      * - The divisor cannot be zero.
239      *
240      * _Available since v2.4.0._
241      */
242     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
243         require(b != 0, errorMessage);
244         return a % b;
245     }
246 
247     function min(uint x, uint y) internal pure returns (uint z) {
248         return x <= y ? x : y;
249     }
250 }
251 
252 ////// src/safeERC20.sol
253 /* pragma solidity ^0.5.12; */
254 
255 /* import "./IERC20.sol"; */
256 /* import "./safeMath.sol"; */
257 
258 
259 
260 /**
261  * @dev Collection of functions related to the address type
262  */
263 library Address {
264     /**
265      * @dev Returns true if `account` is a contract.
266      *
267      * This test is non-exhaustive, and there may be false-negatives: during the
268      * execution of a contract's constructor, its address will be reported as
269      * not containing a contract.
270      *
271      * IMPORTANT: It is unsafe to assume that an address for which this
272      * function returns false is an externally-owned account (EOA) and not a
273      * contract.
274      */
275     function isContract(address account) internal view returns (bool) {
276         // This method relies in extcodesize, which returns 0 for contracts in
277         // construction, since the code is only stored at the end of the
278         // constructor execution.
279 
280         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
281         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
282         // for accounts without code, i.e. `keccak256('')`
283         bytes32 codehash;
284         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
285         // solhint-disable-next-line no-inline-assembly
286         assembly { codehash := extcodehash(account) }
287         return (codehash != 0x0 && codehash != accountHash);
288     }
289 
290     /**
291      * @dev Converts an `address` into `address payable`. Note that this is
292      * simply a type cast: the actual underlying value is not changed.
293      *
294      * _Available since v2.4.0._
295      */
296     function toPayable(address account) internal pure returns (address payable) {
297         return address(uint160(account));
298     }
299 
300     /**
301      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
302      * `recipient`, forwarding all available gas and reverting on errors.
303      *
304      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
305      * of certain opcodes, possibly making contracts go over the 2300 gas limit
306      * imposed by `transfer`, making them unable to receive funds via
307      * `transfer`. {sendValue} removes this limitation.
308      *
309      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
310      *
311      * IMPORTANT: because control is transferred to `recipient`, care must be
312      * taken to not create reentrancy vulnerabilities. Consider using
313      * {ReentrancyGuard} or the
314      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
315      *
316      * _Available since v2.4.0._
317      */
318     function sendValue(address payable recipient, uint256 amount) internal {
319         require(address(this).balance >= amount, "Address: insufficient balance");
320 
321         // solhint-disable-next-line avoid-call-value
322         (bool success, ) = recipient.call.value(amount)("");
323         require(success, "Address: unable to send value, recipient may have reverted");
324     }
325 }
326 
327 
328 
329 
330 /**
331  * @title SafeERC20
332  * @dev Wrappers around ERC20 operations that throw on failure (when the token
333  * contract returns false). Tokens that return no value (and instead revert or
334  * throw on failure) are also supported, non-reverting calls are assumed to be
335  * successful.
336  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
337  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
338  */
339 library SafeERC20 {
340     using SafeMath for uint256;
341     using Address for address;
342 
343     function safeTransfer(IERC20 token, address to, uint256 value) internal {
344         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
345     }
346 
347     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
348         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
349     }
350 
351     function safeApprove(IERC20 token, address spender, uint256 value) internal {
352         // safeApprove should only be called when setting an initial allowance,
353         // or when resetting it to zero. To increase and decrease it, use
354         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
355         // solhint-disable-next-line max-line-length
356         require((value == 0) || (token.allowance(address(this), spender) == 0),
357             "SafeERC20: approve from non-zero to non-zero allowance"
358         );
359         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
360     }
361 
362     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
363         uint256 newAllowance = token.allowance(address(this), spender).add(value);
364         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
365     }
366 
367     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
368         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
369         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
370     }
371 
372     /**
373      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
374      * on the return value: the return value is optional (but if data is returned, it must not be false).
375      * @param token The token targeted by the call.
376      * @param data The call data (encoded using abi.encode or one of its variants).
377      */
378     function callOptionalReturn(IERC20 token, bytes memory data) private {
379         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
380         // we're implementing it ourselves.
381 
382         // A Solidity high level call has three parts:
383         //  1. The target address is checked to verify it contains contract code
384         //  2. The call itself is made, and success asserted
385         //  3. The return value is decoded, which in turn checks the size of the returned data.
386         // solhint-disable-next-line max-line-length
387         require(address(token).isContract(), "SafeERC20: call to non-contract");
388 
389         // solhint-disable-next-line avoid-low-level-calls
390         (bool success, bytes memory returndata) = address(token).call(data);
391         require(success, "SafeERC20: low-level call failed");
392 
393         if (returndata.length > 0) { // Return data is optional
394             // solhint-disable-next-line max-line-length
395             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
396         }
397     }
398 }
399 
400 
401 ////// src/rewardsDecayHolder.sol
402 /* pragma solidity ^0.5.12; */
403 
404 /* import "./IERC20.sol"; */
405 /* import "./safeMath.sol"; */
406 /* import "./safeERC20.sol"; */
407 
408 interface IRewarder {
409     function stake(
410         address account,
411         uint256 amount,
412         address gem
413     ) external;
414 
415     function withdraw(
416         address account,
417         uint256 amount,
418         address gem
419     ) external;
420 }
421 
422 contract StakingRewardsDecayHolder {
423     using SafeMath for uint256;
424     using SafeERC20 for IERC20;
425 
426     IRewarder public rewarder;
427 
428     uint256 public withdrawErrorCount;
429 
430     mapping(address => mapping(address => uint256)) public amounts;
431 
432     event withdrawError(uint256 amount, address gem);
433 
434     constructor(address _rewarder) public {
435         rewarder = IRewarder(_rewarder);
436     }
437 
438     function stake(uint256 amount, address gem) public {
439         require(amount > 0, "Cannot stake 0");
440 
441         rewarder.stake(msg.sender, amount, gem);
442 
443         amounts[gem][msg.sender] = amounts[gem][msg.sender].add(amount);
444         IERC20(gem).safeTransferFrom(msg.sender, address(this), amount);
445     }
446 
447     function withdraw(uint256 amount, address gem) public {
448         require(amount > 0, "Cannot withdraw 0");
449 
450         (bool success, ) =
451             address(rewarder).call(
452                 abi.encodeWithSelector(rewarder.withdraw.selector, msg.sender, amount, gem)
453             );
454         if (!success) {
455             //don't interfere with user to withdraw his money regardless
456             //of potential rewarder's bug or hacks
457             //only amounts map matters
458             emit withdrawError(amount, gem);
459             withdrawErrorCount++;
460         }
461 
462         amounts[gem][msg.sender] = amounts[gem][msg.sender].sub(amount);
463         IERC20(gem).safeTransfer(msg.sender, amount);
464     }
465 }
