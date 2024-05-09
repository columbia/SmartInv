1 pragma solidity 0.6.12;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP.
5  */
6 interface IERC20 {
7     /**
8      * @dev Returns the amount of tokens in existence.
9      */
10     function totalSupply() external view returns (uint256);
11 
12     /**
13      * @dev Returns the amount of tokens owned by `account`.
14      */
15     function balanceOf(address account) external view returns (uint256);
16 
17     /**
18      * @dev Moves `amount` tokens from the caller's account to `recipient`.
19      *
20      * Returns a boolean value indicating whether the operation succeeded.
21      *
22      * Emits a {Transfer} event.
23      */
24     function transfer(address recipient, uint256 amount) external returns (bool);
25 
26     /**
27      * @dev Returns the remaining number of tokens that `spender` will be
28      * allowed to spend on behalf of `owner` through {transferFrom}. This is
29      * zero by default.
30      *
31      * This value changes when {approve} or {transferFrom} are called.
32      */
33     function allowance(address owner, address spender) external view returns (uint256);
34 
35     /**
36      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * IMPORTANT: Beware that changing an allowance with this method brings the risk
41      * that someone may use both the old and the new allowance by unfortunate
42      * transaction ordering. One possible solution to mitigate this race
43      * condition is to first reduce the spender's allowance to 0 and set the
44      * desired value afterwards:
45      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
46      *
47      * Emits an {Approval} event.
48      */
49     function approve(address spender, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Moves `amount` tokens from `sender` to `recipient` using the
53      * allowance mechanism. `amount` is then deducted from the caller's
54      * allowance.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Emitted when `value` tokens are moved from one account (`from`) to
64      * another (`to`).
65      *
66      * Note that `value` may be zero.
67      */
68     event Transfer(address indexed from, address indexed to, uint256 value);
69 
70     /**
71      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
72      * a call to {approve}. `value` is the new allowance.
73      */
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 // File: @openzeppelin/contracts/math/SafeMath.sol
78 /**
79  * @dev Wrappers over Solidity's arithmetic operations with added overflow
80  * checks.
81  *
82  * Arithmetic operations in Solidity wrap on overflow. This can easily result
83  * in bugs, because programmers usually assume that an overflow raises an
84  * error, which is the standard behavior in high level programming languages.
85  * `SafeMath` restores this intuition by reverting the transaction when an
86  * operation overflows.
87  *
88  * Using this library instead of the unchecked operations eliminates an entire
89  * class of bugs, so it's recommended to use it always.
90  */
91 library SafeMath {
92     /**
93      * @dev Returns the addition of two unsigned integers, reverting on
94      * overflow.
95      *
96      * Counterpart to Solidity's `+` operator.
97      *
98      * Requirements:
99      *
100      * - Addition cannot overflow.
101      */
102     function add(uint256 a, uint256 b) internal pure returns (uint256) {
103         uint256 c = a + b;
104         require(c >= a, "SafeMath: addition overflow");
105 
106         return c;
107     }
108 
109     /**
110      * @dev Returns the subtraction of two unsigned integers, reverting on
111      * overflow (when the result is negative).
112      *
113      * Counterpart to Solidity's `-` operator.
114      *
115      * Requirements:
116      *
117      * - Subtraction cannot overflow.
118      */
119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120         return sub(a, b, "SafeMath: subtraction overflow");
121     }
122 
123     /**
124      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
125      * overflow (when the result is negative).
126      *
127      * Counterpart to Solidity's `-` operator.
128      *
129      * Requirements:
130      *
131      * - Subtraction cannot overflow.
132      */
133     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
134         require(b <= a, errorMessage);
135         uint256 c = a - b;
136 
137         return c;
138     }
139 
140     /**
141      * @dev Returns the multiplication of two unsigned integers, reverting on
142      * overflow.
143      *
144      * Counterpart to Solidity's `*` operator.
145      *
146      * Requirements:
147      *
148      * - Multiplication cannot overflow.
149      */
150     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
151         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
152         // benefit is lost if 'b' is also tested.
153         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
154         if (a == 0) {
155             return 0;
156         }
157 
158         uint256 c = a * b;
159         require(c / a == b, "SafeMath: multiplication overflow");
160 
161         return c;
162     }
163 
164     /**
165      * @dev Returns the integer division of two unsigned integers. Reverts on
166      * division by zero. The result is rounded towards zero.
167      *
168      * Counterpart to Solidity's `/` operator. Note: this function uses a
169      * `revert` opcode (which leaves remaining gas untouched) while Solidity
170      * uses an invalid opcode to revert (consuming all remaining gas).
171      *
172      * Requirements:
173      *
174      * - The divisor cannot be zero.
175      */
176     function div(uint256 a, uint256 b) internal pure returns (uint256) {
177         return div(a, b, "SafeMath: division by zero");
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         require(b > 0, errorMessage);
194         uint256 c = a / b;
195         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
202      * Reverts when dividing by zero.
203      *
204      * Counterpart to Solidity's `%` operator. This function uses a `revert`
205      * opcode (which leaves remaining gas untouched) while Solidity uses an
206      * invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
213         return mod(a, b, "SafeMath: modulo by zero");
214     }
215 
216     /**
217      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
218      * Reverts with custom message when dividing by zero.
219      *
220      * Counterpart to Solidity's `%` operator. This function uses a `revert`
221      * opcode (which leaves remaining gas untouched) while Solidity uses an
222      * invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         require(b != 0, errorMessage);
230         return a % b;
231     }
232 }
233 
234 // File: @openzeppelin/contracts/utils/Address.sol
235 /**
236  * @dev Collection of functions related to the address type
237  */
238 library Address {
239     /**
240      * @dev Returns true if `account` is a contract.
241      *
242      * [IMPORTANT]
243      * ====
244      * It is unsafe to assume that an address for which this function returns
245      * false is an externally-owned account (EOA) and not a contract.
246      *
247      * Among others, `isContract` will return false for the following
248      * types of addresses:
249      *
250      *  - an externally-owned account
251      *  - a contract in construction
252      *  - an address where a contract will be created
253      *  - an address where a contract lived, but was destroyed
254      * ====
255      */
256     function isContract(address account) internal view returns (bool) {
257         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
258         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
259         // for accounts without code, i.e. `keccak256('')`
260         bytes32 codehash;
261         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
262         // solhint-disable-next-line no-inline-assembly
263         assembly { codehash := extcodehash(account) }
264         return (codehash != accountHash && codehash != 0x0);
265     }
266 
267     /**
268      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
269      * `recipient`, forwarding all available gas and reverting on errors.
270      *
271      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
272      * of certain opcodes, possibly making contracts go over the 2300 gas limit
273      * imposed by `transfer`, making them unable to receive funds via
274      * `transfer`. {sendValue} removes this limitation.
275      *
276      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
277      *
278      * IMPORTANT: because control is transferred to `recipient`, care must be
279      * taken to not create reentrancy vulnerabilities. Consider using
280      * {ReentrancyGuard} or the
281      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
282      */
283     function sendValue(address payable recipient, uint256 amount) internal {
284         require(address(this).balance >= amount, "Address: insufficient balance");
285 
286         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
287         (bool success, ) = recipient.call{ value: amount }("");
288         require(success, "Address: unable to send value, recipient may have reverted");
289     }
290 
291     /**
292      * @dev Performs a Solidity function call using a low level `call`. A
293      * plain`call` is an unsafe replacement for a function call: use this
294      * function instead.
295      *
296      * If `target` reverts with a revert reason, it is bubbled up by this
297      * function (like regular Solidity function calls).
298      *
299      * Returns the raw returned data. To convert to the expected return value,
300      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
301      *
302      * Requirements:
303      *
304      * - `target` must be a contract.
305      * - calling `target` with `data` must not revert.
306      *
307      * _Available since v3.1._
308      */
309     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
310       return functionCall(target, data, "Address: low-level call failed");
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
315      * `errorMessage` as a fallback revert reason when `target` reverts.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
320         return _functionCallWithValue(target, data, 0, errorMessage);
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
325      * but also transferring `value` wei to `target`.
326      *
327      * Requirements:
328      *
329      * - the calling contract must have an ETH balance of at least `value`.
330      * - the called Solidity function must be `payable`.
331      *
332      * _Available since v3.1._
333      */
334     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
335         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
340      * with `errorMessage` as a fallback revert reason when `target` reverts.
341      *
342      * _Available since v3.1._
343      */
344     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
345         require(address(this).balance >= value, "Address: insufficient balance for call");
346         return _functionCallWithValue(target, data, value, errorMessage);
347     }
348 
349     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
350         require(isContract(target), "Address: call to non-contract");
351 
352         // solhint-disable-next-line avoid-low-level-calls
353         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
354         if (success) {
355             return returndata;
356         } else {
357             // Look for revert reason and bubble it up if present
358             if (returndata.length > 0) {
359                 // The easiest way to bubble the revert reason is using memory via assembly
360 
361                 // solhint-disable-next-line no-inline-assembly
362                 assembly {
363                     let returndata_size := mload(returndata)
364                     revert(add(32, returndata), returndata_size)
365                 }
366             } else {
367                 revert(errorMessage);
368             }
369         }
370     }
371 }
372 
373 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
374 /**
375  * @title SafeERC20
376  * @dev Wrappers around ERC20 operations that throw on failure (when the token
377  * contract returns false). Tokens that return no value (and instead revert or
378  * throw on failure) are also supported, non-reverting calls are assumed to be
379  * successful.
380  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
381  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
382  */
383 library SafeERC20 {
384     using SafeMath for uint256;
385     using Address for address;
386 
387     function safeTransfer(IERC20 token, address to, uint256 value) internal {
388         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
389     }
390 
391     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
392         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
393     }
394 
395     /**
396      * @dev Deprecated. This function has issues similar to the ones found in
397      * {IERC20-approve}, and its usage is discouraged.
398      *
399      * Whenever possible, use {safeIncreaseAllowance} and
400      * {safeDecreaseAllowance} instead.
401      */
402     function safeApprove(IERC20 token, address spender, uint256 value) internal {
403         // safeApprove should only be called when setting an initial allowance,
404         // or when resetting it to zero. To increase and decrease it, use
405         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
406         // solhint-disable-next-line max-line-length
407         require((value == 0) || (token.allowance(address(this), spender) == 0),
408             "SafeERC20: approve from non-zero to non-zero allowance"
409         );
410         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
411     }
412 
413     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
414         uint256 newAllowance = token.allowance(address(this), spender).add(value);
415         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
416     }
417 
418     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
419         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
420         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
421     }
422 
423     /**
424      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
425      * on the return value: the return value is optional (but if data is returned, it must not be false).
426      * @param token The token targeted by the call.
427      * @param data The call data (encoded using abi.encode or one of its variants).
428      */
429     function _callOptionalReturn(IERC20 token, bytes memory data) private {
430         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
431         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
432         // the target address contains contract code and also asserts for success in the low-level call.
433 
434         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
435         if (returndata.length > 0) { // Return data is optional
436             // solhint-disable-next-line max-line-length
437             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
438         }
439     }
440 }
441 
442 // File: contracts/uniswapv2/interfaces/IUniswapV2ERC20.sol
443 interface IUniswapV2ERC20 {
444     event Approval(address indexed owner, address indexed spender, uint value);
445     event Transfer(address indexed from, address indexed to, uint value);
446 
447     function name() external pure returns (string memory);
448     function symbol() external pure returns (string memory);
449     function decimals() external pure returns (uint8);
450     function totalSupply() external view returns (uint);
451     function balanceOf(address owner) external view returns (uint);
452     function allowance(address owner, address spender) external view returns (uint);
453 
454     function approve(address spender, uint value) external returns (bool);
455     function transfer(address to, uint value) external returns (bool);
456     function transferFrom(address from, address to, uint value) external returns (bool);
457 
458     function DOMAIN_SEPARATOR() external view returns (bytes32);
459     function PERMIT_TYPEHASH() external pure returns (bytes32);
460     function nonces(address owner) external view returns (uint);
461 
462     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
463 }
464 
465 // File: contracts/uniswapv2/interfaces/IUniswapV2Pair.sol
466 interface IUniswapV2Pair {
467     event Approval(address indexed owner, address indexed spender, uint value);
468     event Transfer(address indexed from, address indexed to, uint value);
469 
470     function name() external pure returns (string memory);
471     function symbol() external pure returns (string memory);
472     function decimals() external pure returns (uint8);
473     function totalSupply() external view returns (uint);
474     function balanceOf(address owner) external view returns (uint);
475     function allowance(address owner, address spender) external view returns (uint);
476 
477     function approve(address spender, uint value) external returns (bool);
478     function transfer(address to, uint value) external returns (bool);
479     function transferFrom(address from, address to, uint value) external returns (bool);
480 
481     function DOMAIN_SEPARATOR() external view returns (bytes32);
482     function PERMIT_TYPEHASH() external pure returns (bytes32);
483     function nonces(address owner) external view returns (uint);
484 
485     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
486 
487     event Mint(address indexed sender, uint amount0, uint amount1);
488     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
489     event Swap(
490         address indexed sender,
491         uint amount0In,
492         uint amount1In,
493         uint amount0Out,
494         uint amount1Out,
495         address indexed to
496     );
497     event Sync(uint112 reserve0, uint112 reserve1);
498 
499     function MINIMUM_LIQUIDITY() external pure returns (uint);
500     function factory() external view returns (address);
501     function token0() external view returns (address);
502     function token1() external view returns (address);
503     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
504     function price0CumulativeLast() external view returns (uint);
505     function price1CumulativeLast() external view returns (uint);
506     function kLast() external view returns (uint);
507 
508     function mint(address to) external returns (uint liquidity);
509     function burn(address to) external returns (uint amount0, uint amount1);
510     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
511     function skim(address to) external;
512     function sync() external;
513 
514     function initialize(address, address) external;
515 }
516 
517 interface IUniswapV2Factory {
518     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
519 
520     function feeTo() external view returns (address);
521     function feeToSetter() external view returns (address);
522     function migrator() external view returns (address);
523 
524     function getPair(address tokenA, address tokenB) external view returns (address pair);
525     function allPairs(uint) external view returns (address pair);
526     function allPairsLength() external view returns (uint);
527 
528     function createPair(address tokenA, address tokenB) external returns (address pair);
529 
530     function setFeeTo(address) external;
531     function setFeeToSetter(address) external;
532     function setMigrator(address) external;
533 }
534 
535 contract SushiMaker {
536     using SafeMath for uint256;
537     using SafeERC20 for IERC20;
538 
539     IUniswapV2Factory public constant factory = IUniswapV2Factory(0xC0AEe478e3658e2610c5F7A4A2E1777cE9e4f2Ac);
540     address public constant bar = 0x8798249c2E607446EfB7Ad49eC89dD1865Ff4272;
541     address public constant sushi = 0x6B3595068778DD592e39A122f4f5a5cF09C90fE2;
542     address public constant weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
543 
544     function convert(address token0, address token1) public {
545         // At least we try to make front-running harder to do.
546         require(msg.sender == tx.origin, "do not convert from contract");
547         
548         IUniswapV2Pair pair = IUniswapV2Pair(factory.getPair(token0, token1));
549         pair.transfer(address(pair), pair.balanceOf(address(this)));
550         (uint amount0, uint amount1) = pair.burn(address(this));
551         uint256 wethAmount = _toWETH(token0, amount0) + _toWETH(token1, amount1);
552         _toSUSHI(wethAmount);
553     }
554 
555     function _toWETH(address token, uint amountIn) internal returns (uint256) {
556         if (token == sushi) {
557             _safeTransfer(token, bar, amountIn);
558             return 0;
559         }
560         if (token == weth) {
561             _safeTransfer(token, factory.getPair(weth, sushi), amountIn);
562             return amountIn;
563         }
564         IUniswapV2Pair pair = IUniswapV2Pair(factory.getPair(token, weth));
565         if (address(pair) == address(0)) {
566             return 0;
567         }
568         (uint reserve0, uint reserve1,) = pair.getReserves();
569         address token0 = pair.token0();
570         (uint reserveIn, uint reserveOut) = token0 == token ? (reserve0, reserve1) : (reserve1, reserve0);
571         uint amountInWithFee = amountIn.mul(997);
572         uint amountOut = amountInWithFee.mul(reserveOut) / reserveIn.mul(1000).add(amountInWithFee);
573         (uint amount0Out, uint amount1Out) = token0 == token ? (uint(0), amountOut) : (amountOut, uint(0));
574         _safeTransfer(token, address(pair), amountIn);
575         pair.swap(amount0Out, amount1Out, factory.getPair(weth, sushi), new bytes(0));
576         return amountOut;
577     }
578 
579     function _toSUSHI(uint256 amountIn) internal {
580         IUniswapV2Pair pair = IUniswapV2Pair(factory.getPair(weth, sushi));
581         (uint reserve0, uint reserve1,) = pair.getReserves();
582         address token0 = pair.token0();
583         (uint reserveIn, uint reserveOut) = token0 == weth ? (reserve0, reserve1) : (reserve1, reserve0);
584         uint amountInWithFee = amountIn.mul(997);
585         uint numerator = amountInWithFee.mul(reserveOut);
586         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
587         uint amountOut = numerator / denominator;
588         (uint amount0Out, uint amount1Out) = token0 == weth ? (uint(0), amountOut) : (amountOut, uint(0));
589         pair.swap(amount0Out, amount1Out, bar, new bytes(0));
590     }
591 
592     function _safeTransfer(address token, address to, uint256 amount) internal {
593         IERC20(token).safeTransfer(to, amount);
594     }
595 }