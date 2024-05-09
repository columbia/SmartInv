1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      *
29      * - Addition cannot overflow.
30      */
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, reverting on
40      * overflow (when the result is negative).
41      *
42      * Counterpart to Solidity's `-` operator.
43      *
44      * Requirements:
45      *
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      *
60      * - Subtraction cannot overflow.
61      */
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `*` operator.
74      *
75      * Requirements:
76      *
77      * - Multiplication cannot overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      *
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     /**
110      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
111      * division by zero. The result is rounded towards zero.
112      *
113      * Counterpart to Solidity's `/` operator. Note: this function uses a
114      * `revert` opcode (which leaves remaining gas untouched) while Solidity
115      * uses an invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      *
119      * - The divisor cannot be zero.
120      */
121     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return mod(a, b, "SafeMath: modulo by zero");
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * Reverts with custom message when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b != 0, errorMessage);
159         return a % b;
160     }
161 }
162 
163 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
164 
165 
166 
167 pragma solidity ^0.6.0;
168 
169 /**
170  * @dev Interface of the ERC20 standard as defined in the EIP.
171  */
172 interface IERC20 {
173     /**
174      * @dev Returns the amount of tokens in existence.
175      */
176     function totalSupply() external view returns (uint256);
177 
178     /**
179      * @dev Returns the amount of tokens owned by `account`.
180      */
181     function balanceOf(address account) external view returns (uint256);
182 
183     /**
184      * @dev Moves `amount` tokens from the caller's account to `recipient`.
185      *
186      * Returns a boolean value indicating whether the operation succeeded.
187      *
188      * Emits a {Transfer} event.
189      */
190     function transfer(address recipient, uint256 amount) external returns (bool);
191 
192     /**
193      * @dev Returns the remaining number of tokens that `spender` will be
194      * allowed to spend on behalf of `owner` through {transferFrom}. This is
195      * zero by default.
196      *
197      * This value changes when {approve} or {transferFrom} are called.
198      */
199     function allowance(address owner, address spender) external view returns (uint256);
200 
201     /**
202      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
203      *
204      * Returns a boolean value indicating whether the operation succeeded.
205      *
206      * IMPORTANT: Beware that changing an allowance with this method brings the risk
207      * that someone may use both the old and the new allowance by unfortunate
208      * transaction ordering. One possible solution to mitigate this race
209      * condition is to first reduce the spender's allowance to 0 and set the
210      * desired value afterwards:
211      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
212      *
213      * Emits an {Approval} event.
214      */
215     function approve(address spender, uint256 amount) external returns (bool);
216 
217     /**
218      * @dev Moves `amount` tokens from `sender` to `recipient` using the
219      * allowance mechanism. `amount` is then deducted from the caller's
220      * allowance.
221      *
222      * Returns a boolean value indicating whether the operation succeeded.
223      *
224      * Emits a {Transfer} event.
225      */
226     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
227 
228     /**
229      * @dev Emitted when `value` tokens are moved from one account (`from`) to
230      * another (`to`).
231      *
232      * Note that `value` may be zero.
233      */
234     event Transfer(address indexed from, address indexed to, uint256 value);
235 
236     /**
237      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
238      * a call to {approve}. `value` is the new allowance.
239      */
240     event Approval(address indexed owner, address indexed spender, uint256 value);
241 }
242 
243 // File: @openzeppelin/contracts/utils/Address.sol
244 
245 
246 
247 pragma solidity ^0.6.2;
248 
249 /**
250  * @dev Collection of functions related to the address type
251  */
252 library Address {
253     /**
254      * @dev Returns true if `account` is a contract.
255      *
256      * [IMPORTANT]
257      * ====
258      * It is unsafe to assume that an address for which this function returns
259      * false is an externally-owned account (EOA) and not a contract.
260      *
261      * Among others, `isContract` will return false for the following
262      * types of addresses:
263      *
264      *  - an externally-owned account
265      *  - a contract in construction
266      *  - an address where a contract will be created
267      *  - an address where a contract lived, but was destroyed
268      * ====
269      */
270     function isContract(address account) internal view returns (bool) {
271         // This method relies in extcodesize, which returns 0 for contracts in
272         // construction, since the code is only stored at the end of the
273         // constructor execution.
274 
275         uint256 size;
276         // solhint-disable-next-line no-inline-assembly
277         assembly { size := extcodesize(account) }
278         return size > 0;
279     }
280 
281     /**
282      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
283      * `recipient`, forwarding all available gas and reverting on errors.
284      *
285      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
286      * of certain opcodes, possibly making contracts go over the 2300 gas limit
287      * imposed by `transfer`, making them unable to receive funds via
288      * `transfer`. {sendValue} removes this limitation.
289      *
290      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
291      *
292      * IMPORTANT: because control is transferred to `recipient`, care must be
293      * taken to not create reentrancy vulnerabilities. Consider using
294      * {ReentrancyGuard} or the
295      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
296      */
297     function sendValue(address payable recipient, uint256 amount) internal {
298         require(address(this).balance >= amount, "Address: insufficient balance");
299 
300         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
301         (bool success, ) = recipient.call{ value: amount }("");
302         require(success, "Address: unable to send value, recipient may have reverted");
303     }
304 
305     /**
306      * @dev Performs a Solidity function call using a low level `call`. A
307      * plain`call` is an unsafe replacement for a function call: use this
308      * function instead.
309      *
310      * If `target` reverts with a revert reason, it is bubbled up by this
311      * function (like regular Solidity function calls).
312      *
313      * Returns the raw returned data. To convert to the expected return value,
314      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
315      *
316      * Requirements:
317      *
318      * - `target` must be a contract.
319      * - calling `target` with `data` must not revert.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
324       return functionCall(target, data, "Address: low-level call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
329      * `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
334         return _functionCallWithValue(target, data, 0, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but also transferring `value` wei to `target`.
340      *
341      * Requirements:
342      *
343      * - the calling contract must have an ETH balance of at least `value`.
344      * - the called Solidity function must be `payable`.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
354      * with `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
359         require(address(this).balance >= value, "Address: insufficient balance for call");
360         return _functionCallWithValue(target, data, value, errorMessage);
361     }
362 
363     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
364         require(isContract(target), "Address: call to non-contract");
365 
366         // solhint-disable-next-line avoid-low-level-calls
367         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
368         if (success) {
369             return returndata;
370         } else {
371             // Look for revert reason and bubble it up if present
372             if (returndata.length > 0) {
373                 // The easiest way to bubble the revert reason is using memory via assembly
374 
375                 // solhint-disable-next-line no-inline-assembly
376                 assembly {
377                     let returndata_size := mload(returndata)
378                     revert(add(32, returndata), returndata_size)
379                 }
380             } else {
381                 revert(errorMessage);
382             }
383         }
384     }
385 }
386 
387 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
388 
389 
390 
391 pragma solidity ^0.6.0;
392 
393 
394 
395 
396 /**
397  * @title SafeERC20
398  * @dev Wrappers around ERC20 operations that throw on failure (when the token
399  * contract returns false). Tokens that return no value (and instead revert or
400  * throw on failure) are also supported, non-reverting calls are assumed to be
401  * successful.
402  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
403  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
404  */
405 library SafeERC20 {
406     using SafeMath for uint256;
407     using Address for address;
408 
409     function safeTransfer(IERC20 token, address to, uint256 value) internal {
410         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
411     }
412 
413     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
414         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
415     }
416 
417     /**
418      * @dev Deprecated. This function has issues similar to the ones found in
419      * {IERC20-approve}, and its usage is discouraged.
420      *
421      * Whenever possible, use {safeIncreaseAllowance} and
422      * {safeDecreaseAllowance} instead.
423      */
424     function safeApprove(IERC20 token, address spender, uint256 value) internal {
425         // safeApprove should only be called when setting an initial allowance,
426         // or when resetting it to zero. To increase and decrease it, use
427         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
428         // solhint-disable-next-line max-line-length
429         require((value == 0) || (token.allowance(address(this), spender) == 0),
430             "SafeERC20: approve from non-zero to non-zero allowance"
431         );
432         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
433     }
434 
435     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
436         uint256 newAllowance = token.allowance(address(this), spender).add(value);
437         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
438     }
439 
440     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
441         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
442         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
443     }
444 
445     /**
446      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
447      * on the return value: the return value is optional (but if data is returned, it must not be false).
448      * @param token The token targeted by the call.
449      * @param data The call data (encoded using abi.encode or one of its variants).
450      */
451     function _callOptionalReturn(IERC20 token, bytes memory data) private {
452         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
453         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
454         // the target address contains contract code and also asserts for success in the low-level call.
455 
456         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
457         if (returndata.length > 0) { // Return data is optional
458             // solhint-disable-next-line max-line-length
459             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
460         }
461     }
462 }
463 
464 // File: contracts/interfaces/flamincome/Controller.sol
465 
466 
467 pragma solidity ^0.6.2;
468 
469 interface Controller {
470     function strategist() external view returns (address);
471     function vaults(address) external view returns (address);
472     function rewards() external view returns (address);
473     function balanceOf(address) external view returns (uint);
474     function withdraw(address, uint) external;
475     function earn(address, uint) external;
476 }
477 
478 // File: contracts/interfaces/flamincome/Vault.sol
479 
480 
481 pragma solidity ^0.6.2;
482 
483 interface Vault {
484     function token() external view returns (address);
485     function priceE18() external view returns (uint);
486     function deposit(uint) external;
487     function withdraw(uint) external;
488     function depositAll() external;
489     function withdrawAll() external;
490 }
491 
492 // File: contracts/interfaces/external/Gauge.sol
493 
494 
495 pragma solidity ^0.6.2;
496 
497 interface IGauge {
498     function deposit(uint) external;
499     function balanceOf(address) external view returns (uint);
500     function withdraw(uint) external;
501     function user_checkpoint(address) external;
502 }
503 
504 interface VotingEscrow {
505     function create_lock(uint256 v, uint256 time) external;
506     function increase_amount(uint256 _value) external;
507     function increase_unlock_time(uint256 _unlock_time) external;
508     function withdraw() external;
509 }
510 
511 interface IMintr {
512     function mint(address) external;
513 }
514 
515 // File: contracts/interfaces/external/Curve.sol
516 
517 
518 pragma solidity ^0.6.2;
519 
520 interface ICurveFi {
521   function coins(int128) external view returns (address);
522   function get_virtual_price() external view returns (uint);
523   function add_liquidity(uint256[4] calldata amounts, uint256 min_mint_amount) external;
524   function remove_liquidity_imbalance(uint256[4] calldata amounts, uint256 max_burn_amount) external;
525   function remove_liquidity(uint256 _amount, uint256[4] calldata amounts) external;
526   function exchange(int128 from, int128 to, uint256 _from_amount, uint256 _min_to_amount) external;
527   function exchange_underlying(int128 from, int128 to, uint256 _from_amount, uint256 _min_to_amount) external;
528 }
529 
530 interface ICurveFiBTC {
531   function coins(int128) external view returns (address);
532   function get_virtual_price() external view returns (uint);
533   function add_liquidity(uint256[3] calldata amounts, uint256 min_mint_amount) external;
534   function remove_liquidity_imbalance(uint256[3] calldata amounts, uint256 max_burn_amount) external;
535   function remove_liquidity(uint256 _amount, uint256[3] calldata amounts) external;
536   function exchange(int128 from, int128 to, uint256 _from_amount, uint256 _min_to_amount) external;
537   function exchange_underlying(int128 from, int128 to, uint256 _from_amount, uint256 _min_to_amount) external;
538 }
539 
540 interface ICurveFiREN {
541   function coins(int128) external view returns (address);
542   function get_virtual_price() external view returns (uint);
543   function add_liquidity(uint256[2] calldata amounts, uint256 min_mint_amount) external;
544   function remove_liquidity_imbalance(uint256[2] calldata amounts, uint256 max_burn_amount) external;
545   function remove_liquidity(uint256 _amount, uint256[2] calldata amounts) external;
546   function exchange(int128 from, int128 to, uint256 _from_amount, uint256 _min_to_amount) external;
547   function exchange_underlying(int128 from, int128 to, uint256 _from_amount, uint256 _min_to_amount) external;
548 }
549 
550 // File: contracts/interfaces/external/Uniswap.sol
551 
552 
553 pragma solidity ^0.6.2;
554 
555 interface IUniV2 {
556     function swapExactTokensForTokens(uint, uint, address[] calldata, address, uint) external;
557 }
558 
559 interface UniSwapV1 {
560     function tokenAddress() external view returns (address token);
561     function factoryAddress() external view returns (address factory);
562     function addLiquidity(uint256 min_liquidity, uint256 max_tokens, uint256 deadline) external payable returns (uint256);
563     function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline) external returns (uint256, uint256);
564     function getEthToTokenInputPrice(uint256 eth_sold) external view returns (uint256 tokens_bought);
565     function getEthToTokenOutputPrice(uint256 tokens_bought) external view returns (uint256 eth_sold);
566     function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256 eth_bought);
567     function getTokenToEthOutputPrice(uint256 eth_bought) external view returns (uint256 tokens_sold);
568     function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256  tokens_bought);
569     function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient) external payable returns (uint256  tokens_bought);
570     function ethToTokenSwapOutput(uint256 tokens_bought, uint256 deadline) external payable returns (uint256  eth_sold);
571     function ethToTokenTransferOutput(uint256 tokens_bought, uint256 deadline, address recipient) external payable returns (uint256  eth_sold);
572     function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256  eth_bought);
573     function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline, address recipient) external returns (uint256  eth_bought);
574     function tokenToEthSwapOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline) external returns (uint256  tokens_sold);
575     function tokenToEthTransferOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline, address recipient) external returns (uint256  tokens_sold);
576     function tokenToTokenSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address token_addr) external returns (uint256  tokens_bought);
577     function tokenToTokenTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_bought);
578     function tokenToTokenSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address token_addr) external returns (uint256  tokens_sold);
579     function tokenToTokenTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_sold);
580     function tokenToExchangeSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address exchange_addr) external returns (uint256  tokens_bought);
581     function tokenToExchangeTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_bought);
582     function tokenToExchangeSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address exchange_addr) external returns (uint256  tokens_sold);
583     function tokenToExchangeTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_sold);
584     function transfer(address _to, uint256 _value) external returns (bool);
585     function transferFrom(address _from, address _to, uint256 value) external returns (bool);
586     function approve(address _spender, uint256 _value) external returns (bool);
587     function allowance(address _owner, address _spender) external view returns (uint256);
588     function balanceOf(address _owner) external view returns (uint256);
589     function totalSupply() external view returns (uint256);
590 }
591 
592 interface IUniStakingRewards{
593     function balanceOf(address account) external view returns (uint256);
594     function stake(uint256 amount) external;
595     function withdraw(uint256 amount) external;
596     function getReward() external;
597     function rewardPerToken() external;
598     function exit() external;
599 }
600 
601 interface IUniswapV2Router02{
602     function addLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB, uint liquidity);
603     function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
604     function removeLiquidity(address tokenA, address tokenB, uint liquidity, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB);
605     function removeLiquidityETH(address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external returns (uint amountToken, uint amountETH);
606     function swapExactTokensForTokens(uint, uint, address[] calldata, address, uint) external;
607 }
608 
609 // File: contracts/interfaces/external/YFI.sol
610 
611 
612 pragma solidity ^0.6.2;
613 
614 interface IYFIVault {
615   function token() external view returns (address);
616   function deposit(uint256 _amount) external;
617   function depositAll() external;
618   function withdrawAll() external;
619   function withdraw(uint256 _amount) external;
620   function getPricePerFullShare() external view returns (uint);
621   function earn() external;
622 }
623 
624 // File: @openzeppelin/contracts/math/Math.sol
625 
626 
627 
628 pragma solidity ^0.6.0;
629 
630 /**
631  * @dev Standard math utilities missing in the Solidity language.
632  */
633 library Math {
634     /**
635      * @dev Returns the largest of two numbers.
636      */
637     function max(uint256 a, uint256 b) internal pure returns (uint256) {
638         return a >= b ? a : b;
639     }
640 
641     /**
642      * @dev Returns the smallest of two numbers.
643      */
644     function min(uint256 a, uint256 b) internal pure returns (uint256) {
645         return a < b ? a : b;
646     }
647 
648     /**
649      * @dev Returns the average of two numbers. The result is rounded towards
650      * zero.
651      */
652     function average(uint256 a, uint256 b) internal pure returns (uint256) {
653         // (a + b) / 2 can overflow, so we distribute
654         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
655     }
656 }
657 
658 // File: contracts/implementations/strategy/StrategyBaseline.sol
659 
660 
661 pragma solidity ^0.6.2;
662 
663 
664 
665 
666 
667 
668 
669 abstract contract StrategyBaseline {
670     using SafeERC20 for IERC20;
671     using Address for address;
672     using SafeMath for uint256;
673 
674     address public want;
675     address public governance;
676     address public controller;
677 
678     constructor(address _want, address _controller) public {
679         governance = msg.sender;
680         controller = _controller;
681         want = _want;
682     }
683 
684     function deposit() public virtual;
685 
686     function withdraw(IERC20 _asset) external virtual returns (uint256 balance);
687 
688     function withdraw(uint256 _amount) external virtual;
689 
690     function withdrawAll() external virtual returns (uint256 balance);
691 
692     function balanceOf() public virtual view returns (uint256);
693 
694     function SetGovernance(address _governance) external {
695         require(msg.sender == governance, "!governance");
696         governance = _governance;
697     }
698 
699     function SetController(address _controller) external {
700         require(msg.sender == governance, "!governance");
701         controller = _controller;
702     }
703 }
704 
705 // File: contracts/implementations/strategy/StrategyBaselineCarbon.sol
706 
707 
708 pragma solidity ^0.6.2;
709 
710 
711 
712 
713 
714 
715 
716 
717 abstract contract StrategyBaselineCarbon is StrategyBaseline {
718     using SafeERC20 for IERC20;
719     using Address for address;
720     using SafeMath for uint256;
721 
722     uint256 public feen = 5e15;
723     uint256 public constant feed = 1e18;
724 
725     constructor(address _want, address _controller)
726         public
727         StrategyBaseline(_want, _controller)
728     {}
729 
730     function DepositToken(uint256 _amount) internal virtual;
731 
732     function WithdrawToken(uint256 _amount) internal virtual;
733 
734     function Harvest() external virtual;
735 
736     function GetDeposited() public virtual view returns (uint256);
737 
738     function deposit() public override {
739         uint256 _want = IERC20(want).balanceOf(address(this));
740         if (_want > 0) {
741             DepositToken(_want);
742         }
743     }
744 
745     function withdraw(IERC20 _asset)
746         external
747         override
748         returns (uint256 balance)
749     {
750         require(msg.sender == controller, "!controller");
751         require(want != address(_asset), "want");
752         balance = _asset.balanceOf(address(this));
753         _asset.safeTransfer(controller, balance);
754     }
755 
756     function withdraw(uint256 _aw) external override {
757         require(msg.sender == controller, "!controller");
758         uint256 _w = IERC20(want).balanceOf(address(this));
759         if (_w < _aw) {
760             WithdrawToken(_aw.sub(_w));
761         }
762         _w = IERC20(want).balanceOf(address(this));
763         address _vault = Controller(controller).vaults(address(want));
764         require(_vault != address(0), "!vault");
765         IERC20(want).safeTransfer(_vault, Math.min(_aw, _w));
766     }
767 
768     function withdrawAll() external override returns (uint256 balance) {
769         require(msg.sender == controller, "!controller");
770         WithdrawToken(GetDeposited());
771         balance = IERC20(want).balanceOf(address(this));
772         address _vault = Controller(controller).vaults(address(want));
773         require(_vault != address(0), "!vault");
774         IERC20(want).safeTransfer(_vault, balance);
775     }
776 
777     function balanceOf() public override view returns (uint256) {
778         uint256 _want = IERC20(want).balanceOf(address(this));
779         return GetDeposited().add(_want);
780     }
781 
782     function setFeeN(uint256 _feen) external {
783         require(msg.sender == governance, "!governance");
784         feen = _feen;
785     }
786 }
787 
788 // File: contracts/implementations/strategy/StrategyBaselineCarbonGaugeREN.sol
789 
790 
791 pragma solidity ^0.6.2;
792 
793 
794 
795 
796 
797 
798 
799 
800 
801 
802 
803 
804 contract StrategyBaselineCarbonGaugeREN is StrategyBaselineCarbon {
805     using SafeERC20 for IERC20;
806     using Address for address;
807     using SafeMath for uint256;
808 
809     address public constant crvbtc = address(
810         0x49849C98ae39Fff122806C06791Fa73784FB3675
811     );
812     address public constant pool = address(
813         0xB1F2cdeC61db658F091671F5f199635aEF202CAC
814     );
815     address public constant mintr = address(
816         0xd061D61a4d941c39E5453435B6345Dc261C2fcE0
817     );
818     address public constant crv = address(
819         0xD533a949740bb3306d119CC777fa900bA034cd52
820     );
821     address public constant uni = address(
822         0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
823     );
824     address public constant weth = address(
825         0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
826     );
827     address public constant wbtc = address(
828         0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599
829     );
830     address public constant curve = address(
831         0x93054188d876f558f4a66B2EF1d97d16eDf0895B
832     );
833 
834     constructor(address _controller)
835         public
836         StrategyBaselineCarbon(crvbtc, _controller)
837     {}
838 
839     function DepositToken(uint256 _amount) internal override {
840         IERC20(want).safeApprove(pool, 0);
841         IERC20(want).safeApprove(pool, _amount);
842         IGauge(pool).deposit(_amount);
843     }
844 
845     function WithdrawToken(uint256 _amount) internal override {
846         IGauge(pool).withdraw(_amount);
847     }
848 
849     function Harvest() external override {
850         require(msg.sender == Controller(controller).strategist() || msg.sender == governance, "!permission");
851         IMintr(mintr).mint(pool);
852         uint256 _crv = IERC20(crv).balanceOf(address(this));
853         if (_crv > 0) {
854             uint256 _fee = _crv.mul(feen).div(feed);
855             IERC20(crv).safeTransfer(Controller(controller).rewards(), _fee);
856             _crv = _crv.sub(_fee);
857             IERC20(crv).safeApprove(uni, 0);
858             IERC20(crv).safeApprove(uni, _crv);
859             address[] memory path = new address[](3);
860             path[0] = crv;
861             path[1] = weth;
862             path[2] = wbtc;
863             IUniV2(uni).swapExactTokensForTokens(
864                 _crv,
865                 uint256(0),
866                 path,
867                 address(this),
868                 now.add(1800)
869             );
870             uint256 _wbtc = IERC20(wbtc).balanceOf(address(this));
871             IERC20(wbtc).safeApprove(curve, 0);
872             IERC20(wbtc).safeApprove(curve, _wbtc);
873             uint256[2] memory vec = [
874                 uint256(0),
875                 uint256(0)
876             ];
877             vec[1] = _wbtc;
878             ICurveFiREN(curve).add_liquidity(vec, 0);
879         }
880     }
881 
882     function GetDeposited() public override view returns (uint256) {
883         return IGauge(pool).balanceOf(address(this));
884     }
885 }
886 
887 // File: contracts/instances/StrategyBaselineCarbonGaugeRENInstance.sol
888 
889 
890 pragma solidity ^0.6.2;
891 
892 
893 contract StrategyBaselineCarbonGaugeRENInstance is StrategyBaselineCarbonGaugeREN {
894     constructor()
895         public
896         StrategyBaselineCarbonGaugeREN(
897             address(0xDc03b4900Eff97d997f4B828ae0a45cd48C3b22d)
898         )
899     {}
900 }