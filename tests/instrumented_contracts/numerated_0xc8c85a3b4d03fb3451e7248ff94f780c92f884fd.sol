1 // Dependency file: @openzeppelin/contracts/utils/Address.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 // pragma solidity >=0.6.2 <0.8.0;
6 
7 /**
8  * @dev Collection of functions related to the address type
9  */
10 library Address {
11     /**
12      * @dev Returns true if `account` is a contract.
13      *
14      * [// importANT]
15      * ====
16      * It is unsafe to assume that an address for which this function returns
17      * false is an externally-owned account (EOA) and not a contract.
18      *
19      * Among others, `isContract` will return false for the following
20      * types of addresses:
21      *
22      *  - an externally-owned account
23      *  - a contract in construction
24      *  - an address where a contract will be created
25      *  - an address where a contract lived, but was destroyed
26      * ====
27      */
28     function isContract(address account) internal view returns (bool) {
29         // This method relies on extcodesize, which returns 0 for contracts in
30         // construction, since the code is only stored at the end of the
31         // constructor execution.
32 
33         uint256 size;
34         // solhint-disable-next-line no-inline-assembly
35         assembly { size := extcodesize(account) }
36         return size > 0;
37     }
38 
39     /**
40      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
41      * `recipient`, forwarding all available gas and reverting on errors.
42      *
43      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
44      * of certain opcodes, possibly making contracts go over the 2300 gas limit
45      * imposed by `transfer`, making them unable to receive funds via
46      * `transfer`. {sendValue} removes this limitation.
47      *
48      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
49      *
50      * // importANT: because control is transferred to `recipient`, care must be
51      * taken to not create reentrancy vulnerabilities. Consider using
52      * {ReentrancyGuard} or the
53      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
54      */
55     function sendValue(address payable recipient, uint256 amount) internal {
56         require(address(this).balance >= amount, "Address: insufficient balance");
57 
58         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
59         (bool success, ) = recipient.call{ value: amount }("");
60         require(success, "Address: unable to send value, recipient may have reverted");
61     }
62 
63     /**
64      * @dev Performs a Solidity function call using a low level `call`. A
65      * plain`call` is an unsafe replacement for a function call: use this
66      * function instead.
67      *
68      * If `target` reverts with a revert reason, it is bubbled up by this
69      * function (like regular Solidity function calls).
70      *
71      * Returns the raw returned data. To convert to the expected return value,
72      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
73      *
74      * Requirements:
75      *
76      * - `target` must be a contract.
77      * - calling `target` with `data` must not revert.
78      *
79      * _Available since v3.1._
80      */
81     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
82       return functionCall(target, data, "Address: low-level call failed");
83     }
84 
85     /**
86      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
87      * `errorMessage` as a fallback revert reason when `target` reverts.
88      *
89      * _Available since v3.1._
90      */
91     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
92         return functionCallWithValue(target, data, 0, errorMessage);
93     }
94 
95     /**
96      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
97      * but also transferring `value` wei to `target`.
98      *
99      * Requirements:
100      *
101      * - the calling contract must have an ETH balance of at least `value`.
102      * - the called Solidity function must be `payable`.
103      *
104      * _Available since v3.1._
105      */
106     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
107         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
108     }
109 
110     /**
111      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
112      * with `errorMessage` as a fallback revert reason when `target` reverts.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
117         require(address(this).balance >= value, "Address: insufficient balance for call");
118         require(isContract(target), "Address: call to non-contract");
119 
120         // solhint-disable-next-line avoid-low-level-calls
121         (bool success, bytes memory returndata) = target.call{ value: value }(data);
122         return _verifyCallResult(success, returndata, errorMessage);
123     }
124 
125     /**
126      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
127      * but performing a static call.
128      *
129      * _Available since v3.3._
130      */
131     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
132         return functionStaticCall(target, data, "Address: low-level static call failed");
133     }
134 
135     /**
136      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
137      * but performing a static call.
138      *
139      * _Available since v3.3._
140      */
141     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
142         require(isContract(target), "Address: static call to non-contract");
143 
144         // solhint-disable-next-line avoid-low-level-calls
145         (bool success, bytes memory returndata) = target.staticcall(data);
146         return _verifyCallResult(success, returndata, errorMessage);
147     }
148 
149     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
150         if (success) {
151             return returndata;
152         } else {
153             // Look for revert reason and bubble it up if present
154             if (returndata.length > 0) {
155                 // The easiest way to bubble the revert reason is using memory via assembly
156 
157                 // solhint-disable-next-line no-inline-assembly
158                 assembly {
159                     let returndata_size := mload(returndata)
160                     revert(add(32, returndata), returndata_size)
161                 }
162             } else {
163                 revert(errorMessage);
164             }
165         }
166     }
167 }
168 
169 
170 // Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol
171 
172 
173 // pragma solidity >=0.6.0 <0.8.0;
174 
175 /**
176  * @dev Interface of the ERC20 standard as defined in the EIP.
177  */
178 interface IERC20 {
179     /**
180      * @dev Returns the amount of tokens in existence.
181      */
182     function totalSupply() external view returns (uint256);
183 
184     /**
185      * @dev Returns the amount of tokens owned by `account`.
186      */
187     function balanceOf(address account) external view returns (uint256);
188 
189     /**
190      * @dev Moves `amount` tokens from the caller's account to `recipient`.
191      *
192      * Returns a boolean value indicating whether the operation succeeded.
193      *
194      * Emits a {Transfer} event.
195      */
196     function transfer(address recipient, uint256 amount) external returns (bool);
197 
198     /**
199      * @dev Returns the remaining number of tokens that `spender` will be
200      * allowed to spend on behalf of `owner` through {transferFrom}. This is
201      * zero by default.
202      *
203      * This value changes when {approve} or {transferFrom} are called.
204      */
205     function allowance(address owner, address spender) external view returns (uint256);
206 
207     /**
208      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
209      *
210      * Returns a boolean value indicating whether the operation succeeded.
211      *
212      * // importANT: Beware that changing an allowance with this method brings the risk
213      * that someone may use both the old and the new allowance by unfortunate
214      * transaction ordering. One possible solution to mitigate this race
215      * condition is to first reduce the spender's allowance to 0 and set the
216      * desired value afterwards:
217      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
218      *
219      * Emits an {Approval} event.
220      */
221     function approve(address spender, uint256 amount) external returns (bool);
222 
223     /**
224      * @dev Moves `amount` tokens from `sender` to `recipient` using the
225      * allowance mechanism. `amount` is then deducted from the caller's
226      * allowance.
227      *
228      * Returns a boolean value indicating whether the operation succeeded.
229      *
230      * Emits a {Transfer} event.
231      */
232     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
233 
234     /**
235      * @dev Emitted when `value` tokens are moved from one account (`from`) to
236      * another (`to`).
237      *
238      * Note that `value` may be zero.
239      */
240     event Transfer(address indexed from, address indexed to, uint256 value);
241 
242     /**
243      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
244      * a call to {approve}. `value` is the new allowance.
245      */
246     event Approval(address indexed owner, address indexed spender, uint256 value);
247 }
248 
249 
250 // Dependency file: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol
251 
252 // pragma solidity >=0.5.0;
253 
254 interface IUniswapV2Factory {
255     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
256 
257     function feeTo() external view returns (address);
258     function feeToSetter() external view returns (address);
259 
260     function getPair(address tokenA, address tokenB) external view returns (address pair);
261     function allPairs(uint) external view returns (address pair);
262     function allPairsLength() external view returns (uint);
263 
264     function createPair(address tokenA, address tokenB) external returns (address pair);
265 
266     function setFeeTo(address) external;
267     function setFeeToSetter(address) external;
268 }
269 
270 
271 // Dependency file: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol
272 
273 // pragma solidity >=0.6.2;
274 
275 interface IUniswapV2Router01 {
276     function factory() external pure returns (address);
277     function WETH() external pure returns (address);
278 
279     function addLiquidity(
280         address tokenA,
281         address tokenB,
282         uint amountADesired,
283         uint amountBDesired,
284         uint amountAMin,
285         uint amountBMin,
286         address to,
287         uint deadline
288     ) external returns (uint amountA, uint amountB, uint liquidity);
289     function addLiquidityETH(
290         address token,
291         uint amountTokenDesired,
292         uint amountTokenMin,
293         uint amountETHMin,
294         address to,
295         uint deadline
296     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
297     function removeLiquidity(
298         address tokenA,
299         address tokenB,
300         uint liquidity,
301         uint amountAMin,
302         uint amountBMin,
303         address to,
304         uint deadline
305     ) external returns (uint amountA, uint amountB);
306     function removeLiquidityETH(
307         address token,
308         uint liquidity,
309         uint amountTokenMin,
310         uint amountETHMin,
311         address to,
312         uint deadline
313     ) external returns (uint amountToken, uint amountETH);
314     function removeLiquidityWithPermit(
315         address tokenA,
316         address tokenB,
317         uint liquidity,
318         uint amountAMin,
319         uint amountBMin,
320         address to,
321         uint deadline,
322         bool approveMax, uint8 v, bytes32 r, bytes32 s
323     ) external returns (uint amountA, uint amountB);
324     function removeLiquidityETHWithPermit(
325         address token,
326         uint liquidity,
327         uint amountTokenMin,
328         uint amountETHMin,
329         address to,
330         uint deadline,
331         bool approveMax, uint8 v, bytes32 r, bytes32 s
332     ) external returns (uint amountToken, uint amountETH);
333     function swapExactTokensForTokens(
334         uint amountIn,
335         uint amountOutMin,
336         address[] calldata path,
337         address to,
338         uint deadline
339     ) external returns (uint[] memory amounts);
340     function swapTokensForExactTokens(
341         uint amountOut,
342         uint amountInMax,
343         address[] calldata path,
344         address to,
345         uint deadline
346     ) external returns (uint[] memory amounts);
347     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
348         external
349         payable
350         returns (uint[] memory amounts);
351     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
352         external
353         returns (uint[] memory amounts);
354     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
355         external
356         returns (uint[] memory amounts);
357     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
358         external
359         payable
360         returns (uint[] memory amounts);
361 
362     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
363     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
364     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
365     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
366     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
367 }
368 
369 
370 // Dependency file: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol
371 
372 // pragma solidity >=0.6.2;
373 
374 // import '/Users/alexsoong/Source/set-protocol/index-coop-contracts/node_modules/@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol';
375 
376 interface IUniswapV2Router02 is IUniswapV2Router01 {
377     function removeLiquidityETHSupportingFeeOnTransferTokens(
378         address token,
379         uint liquidity,
380         uint amountTokenMin,
381         uint amountETHMin,
382         address to,
383         uint deadline
384     ) external returns (uint amountETH);
385     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
386         address token,
387         uint liquidity,
388         uint amountTokenMin,
389         uint amountETHMin,
390         address to,
391         uint deadline,
392         bool approveMax, uint8 v, bytes32 r, bytes32 s
393     ) external returns (uint amountETH);
394 
395     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
396         uint amountIn,
397         uint amountOutMin,
398         address[] calldata path,
399         address to,
400         uint deadline
401     ) external;
402     function swapExactETHForTokensSupportingFeeOnTransferTokens(
403         uint amountOutMin,
404         address[] calldata path,
405         address to,
406         uint deadline
407     ) external payable;
408     function swapExactTokensForETHSupportingFeeOnTransferTokens(
409         uint amountIn,
410         uint amountOutMin,
411         address[] calldata path,
412         address to,
413         uint deadline
414     ) external;
415 }
416 
417 
418 // Dependency file: @openzeppelin/contracts/math/Math.sol
419 
420 
421 // pragma solidity >=0.6.0 <0.8.0;
422 
423 /**
424  * @dev Standard math utilities missing in the Solidity language.
425  */
426 library Math {
427     /**
428      * @dev Returns the largest of two numbers.
429      */
430     function max(uint256 a, uint256 b) internal pure returns (uint256) {
431         return a >= b ? a : b;
432     }
433 
434     /**
435      * @dev Returns the smallest of two numbers.
436      */
437     function min(uint256 a, uint256 b) internal pure returns (uint256) {
438         return a < b ? a : b;
439     }
440 
441     /**
442      * @dev Returns the average of two numbers. The result is rounded towards
443      * zero.
444      */
445     function average(uint256 a, uint256 b) internal pure returns (uint256) {
446         // (a + b) / 2 can overflow, so we distribute
447         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
448     }
449 }
450 
451 
452 // Dependency file: @openzeppelin/contracts/math/SafeMath.sol
453 
454 
455 // pragma solidity >=0.6.0 <0.8.0;
456 
457 /**
458  * @dev Wrappers over Solidity's arithmetic operations with added overflow
459  * checks.
460  *
461  * Arithmetic operations in Solidity wrap on overflow. This can easily result
462  * in bugs, because programmers usually assume that an overflow raises an
463  * error, which is the standard behavior in high level programming languages.
464  * `SafeMath` restores this intuition by reverting the transaction when an
465  * operation overflows.
466  *
467  * Using this library instead of the unchecked operations eliminates an entire
468  * class of bugs, so it's recommended to use it always.
469  */
470 library SafeMath {
471     /**
472      * @dev Returns the addition of two unsigned integers, reverting on
473      * overflow.
474      *
475      * Counterpart to Solidity's `+` operator.
476      *
477      * Requirements:
478      *
479      * - Addition cannot overflow.
480      */
481     function add(uint256 a, uint256 b) internal pure returns (uint256) {
482         uint256 c = a + b;
483         require(c >= a, "SafeMath: addition overflow");
484 
485         return c;
486     }
487 
488     /**
489      * @dev Returns the subtraction of two unsigned integers, reverting on
490      * overflow (when the result is negative).
491      *
492      * Counterpart to Solidity's `-` operator.
493      *
494      * Requirements:
495      *
496      * - Subtraction cannot overflow.
497      */
498     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
499         return sub(a, b, "SafeMath: subtraction overflow");
500     }
501 
502     /**
503      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
504      * overflow (when the result is negative).
505      *
506      * Counterpart to Solidity's `-` operator.
507      *
508      * Requirements:
509      *
510      * - Subtraction cannot overflow.
511      */
512     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
513         require(b <= a, errorMessage);
514         uint256 c = a - b;
515 
516         return c;
517     }
518 
519     /**
520      * @dev Returns the multiplication of two unsigned integers, reverting on
521      * overflow.
522      *
523      * Counterpart to Solidity's `*` operator.
524      *
525      * Requirements:
526      *
527      * - Multiplication cannot overflow.
528      */
529     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
530         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
531         // benefit is lost if 'b' is also tested.
532         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
533         if (a == 0) {
534             return 0;
535         }
536 
537         uint256 c = a * b;
538         require(c / a == b, "SafeMath: multiplication overflow");
539 
540         return c;
541     }
542 
543     /**
544      * @dev Returns the integer division of two unsigned integers. Reverts on
545      * division by zero. The result is rounded towards zero.
546      *
547      * Counterpart to Solidity's `/` operator. Note: this function uses a
548      * `revert` opcode (which leaves remaining gas untouched) while Solidity
549      * uses an invalid opcode to revert (consuming all remaining gas).
550      *
551      * Requirements:
552      *
553      * - The divisor cannot be zero.
554      */
555     function div(uint256 a, uint256 b) internal pure returns (uint256) {
556         return div(a, b, "SafeMath: division by zero");
557     }
558 
559     /**
560      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
561      * division by zero. The result is rounded towards zero.
562      *
563      * Counterpart to Solidity's `/` operator. Note: this function uses a
564      * `revert` opcode (which leaves remaining gas untouched) while Solidity
565      * uses an invalid opcode to revert (consuming all remaining gas).
566      *
567      * Requirements:
568      *
569      * - The divisor cannot be zero.
570      */
571     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
572         require(b > 0, errorMessage);
573         uint256 c = a / b;
574         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
575 
576         return c;
577     }
578 
579     /**
580      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
581      * Reverts when dividing by zero.
582      *
583      * Counterpart to Solidity's `%` operator. This function uses a `revert`
584      * opcode (which leaves remaining gas untouched) while Solidity uses an
585      * invalid opcode to revert (consuming all remaining gas).
586      *
587      * Requirements:
588      *
589      * - The divisor cannot be zero.
590      */
591     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
592         return mod(a, b, "SafeMath: modulo by zero");
593     }
594 
595     /**
596      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
597      * Reverts with custom message when dividing by zero.
598      *
599      * Counterpart to Solidity's `%` operator. This function uses a `revert`
600      * opcode (which leaves remaining gas untouched) while Solidity uses an
601      * invalid opcode to revert (consuming all remaining gas).
602      *
603      * Requirements:
604      *
605      * - The divisor cannot be zero.
606      */
607     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
608         require(b != 0, errorMessage);
609         return a % b;
610     }
611 }
612 
613 
614 // Dependency file: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
615 
616 
617 // pragma solidity >=0.6.0 <0.8.0;
618 
619 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
620 // import "@openzeppelin/contracts/math/SafeMath.sol";
621 // import "@openzeppelin/contracts/utils/Address.sol";
622 
623 /**
624  * @title SafeERC20
625  * @dev Wrappers around ERC20 operations that throw on failure (when the token
626  * contract returns false). Tokens that return no value (and instead revert or
627  * throw on failure) are also supported, non-reverting calls are assumed to be
628  * successful.
629  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
630  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
631  */
632 library SafeERC20 {
633     using SafeMath for uint256;
634     using Address for address;
635 
636     function safeTransfer(IERC20 token, address to, uint256 value) internal {
637         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
638     }
639 
640     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
641         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
642     }
643 
644     /**
645      * @dev Deprecated. This function has issues similar to the ones found in
646      * {IERC20-approve}, and its usage is discouraged.
647      *
648      * Whenever possible, use {safeIncreaseAllowance} and
649      * {safeDecreaseAllowance} instead.
650      */
651     function safeApprove(IERC20 token, address spender, uint256 value) internal {
652         // safeApprove should only be called when setting an initial allowance,
653         // or when resetting it to zero. To increase and decrease it, use
654         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
655         // solhint-disable-next-line max-line-length
656         require((value == 0) || (token.allowance(address(this), spender) == 0),
657             "SafeERC20: approve from non-zero to non-zero allowance"
658         );
659         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
660     }
661 
662     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
663         uint256 newAllowance = token.allowance(address(this), spender).add(value);
664         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
665     }
666 
667     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
668         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
669         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
670     }
671 
672     /**
673      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
674      * on the return value: the return value is optional (but if data is returned, it must not be false).
675      * @param token The token targeted by the call.
676      * @param data The call data (encoded using abi.encode or one of its variants).
677      */
678     function _callOptionalReturn(IERC20 token, bytes memory data) private {
679         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
680         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
681         // the target address contains contract code and also asserts for success in the low-level call.
682 
683         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
684         if (returndata.length > 0) { // Return data is optional
685             // solhint-disable-next-line max-line-length
686             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
687         }
688     }
689 }
690 
691 
692 // Dependency file: @openzeppelin/contracts/utils/ReentrancyGuard.sol
693 
694 
695 // pragma solidity >=0.6.0 <0.8.0;
696 
697 /**
698  * @dev Contract module that helps prevent reentrant calls to a function.
699  *
700  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
701  * available, which can be applied to functions to make sure there are no nested
702  * (reentrant) calls to them.
703  *
704  * Note that because there is a single `nonReentrant` guard, functions marked as
705  * `nonReentrant` may not call one another. This can be worked around by making
706  * those functions `private`, and then adding `external` `nonReentrant` entry
707  * points to them.
708  *
709  * TIP: If you would like to learn more about reentrancy and alternative ways
710  * to protect against it, check out our blog post
711  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
712  */
713 abstract contract ReentrancyGuard {
714     // Booleans are more expensive than uint256 or any type that takes up a full
715     // word because each write operation emits an extra SLOAD to first read the
716     // slot's contents, replace the bits taken up by the boolean, and then write
717     // back. This is the compiler's defense against contract upgrades and
718     // pointer aliasing, and it cannot be disabled.
719 
720     // The values being non-zero value makes deployment a bit more expensive,
721     // but in exchange the refund on every call to nonReentrant will be lower in
722     // amount. Since refunds are capped to a percentage of the total
723     // transaction's gas, it is best to keep them low in cases like this one, to
724     // increase the likelihood of the full refund coming into effect.
725     uint256 private constant _NOT_ENTERED = 1;
726     uint256 private constant _ENTERED = 2;
727 
728     uint256 private _status;
729 
730     constructor () internal {
731         _status = _NOT_ENTERED;
732     }
733 
734     /**
735      * @dev Prevents a contract from calling itself, directly or indirectly.
736      * Calling a `nonReentrant` function from another `nonReentrant`
737      * function is not supported. It is possible to prevent this from happening
738      * by making the `nonReentrant` function external, and make it call a
739      * `private` function that does the actual work.
740      */
741     modifier nonReentrant() {
742         // On the first call to nonReentrant, _notEntered will be true
743         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
744 
745         // Any calls to nonReentrant after this point will fail
746         _status = _ENTERED;
747 
748         _;
749 
750         // By storing the original value once again, a refund is triggered (see
751         // https://eips.ethereum.org/EIPS/eip-2200)
752         _status = _NOT_ENTERED;
753     }
754 }
755 
756 
757 // Dependency file: contracts/interfaces/ISetToken.sol
758 
759 // pragma solidity 0.6.10;
760 pragma experimental "ABIEncoderV2";
761 
762 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
763 
764 /**
765  * @title ISetToken
766  * @author Set Protocol
767  *
768  * Interface for operating with SetTokens.
769  */
770 interface ISetToken is IERC20 {
771 
772     /* ============ Enums ============ */
773 
774     enum ModuleState {
775         NONE,
776         PENDING,
777         INITIALIZED
778     }
779 
780     /* ============ Structs ============ */
781     /**
782      * The base definition of a SetToken Position
783      *
784      * @param component           Address of token in the Position
785      * @param module              If not in default state, the address of associated module
786      * @param unit                Each unit is the # of components per 10^18 of a SetToken
787      * @param positionState       Position ENUM. Default is 0; External is 1
788      * @param data                Arbitrary data
789      */
790     struct Position {
791         address component;
792         address module;
793         int256 unit;
794         uint8 positionState;
795         bytes data;
796     }
797 
798     /**
799      * A struct that stores a component's cash position details and external positions
800      * This data structure allows O(1) access to a component's cash position units and 
801      * virtual units.
802      *
803      * @param virtualUnit               Virtual value of a component's DEFAULT position. Stored as virtual for efficiency
804      *                                  updating all units at once via the position multiplier. Virtual units are achieved
805      *                                  by dividing a "real" value by the "positionMultiplier"
806      * @param componentIndex            
807      * @param externalPositionModules   List of external modules attached to each external position. Each module
808      *                                  maps to an external position
809      * @param externalPositions         Mapping of module => ExternalPosition struct for a given component
810      */
811     struct ComponentPosition {
812       int256 virtualUnit;
813       address[] externalPositionModules;
814       mapping(address => ExternalPosition) externalPositions;
815     }
816 
817     /**
818      * A struct that stores a component's external position details including virtual unit and any
819      * auxiliary data.
820      *
821      * @param virtualUnit       Virtual value of a component's EXTERNAL position.
822      * @param data              Arbitrary data
823      */
824     struct ExternalPosition {
825       int256 virtualUnit;
826       bytes data;
827     }
828 
829 
830     /* ============ Functions ============ */
831     
832     function addComponent(address _component) external;
833     function removeComponent(address _component) external;
834     function editDefaultPositionUnit(address _component, int256 _realUnit) external;
835     function addExternalPositionModule(address _component, address _positionModule) external;
836     function removeExternalPositionModule(address _component, address _positionModule) external;
837     function editExternalPositionUnit(address _component, address _positionModule, int256 _realUnit) external;
838     function editExternalPositionData(address _component, address _positionModule, bytes calldata _data) external;
839 
840     function invoke(address _target, uint256 _value, bytes calldata _data) external returns(bytes memory);
841 
842     function editPositionMultiplier(int256 _newMultiplier) external;
843 
844     function mint(address _account, uint256 _quantity) external;
845     function burn(address _account, uint256 _quantity) external;
846 
847     function lock() external;
848     function unlock() external;
849 
850     function addModule(address _module) external;
851     function removeModule(address _module) external;
852     function initializeModule() external;
853 
854     function setManager(address _manager) external;
855 
856     function manager() external view returns (address);
857     function moduleStates(address _module) external view returns (ModuleState);
858     function getModules() external view returns (address[] memory);
859     
860     function getDefaultPositionRealUnit(address _component) external view returns(int256);
861     function getExternalPositionRealUnit(address _component, address _positionModule) external view returns(int256);
862     function getComponents() external view returns(address[] memory);
863     function getExternalPositionModules(address _component) external view returns(address[] memory);
864     function getExternalPositionData(address _component, address _positionModule) external view returns(bytes memory);
865     function isExternalPositionModule(address _component, address _module) external view returns(bool);
866     function isComponent(address _component) external view returns(bool);
867     
868     function positionMultiplier() external view returns (int256);
869     function getPositions() external view returns (Position[] memory);
870     function getTotalComponentRealUnits(address _component) external view returns(int256);
871 
872     function isInitializedModule(address _module) external view returns(bool);
873     function isPendingModule(address _module) external view returns(bool);
874     function isLocked() external view returns (bool);
875 }
876 
877 // Dependency file: contracts/interfaces/IBasicIssuanceModule.sol
878 
879 /*
880     Copyright 2020 Set Labs Inc.
881     Licensed under the Apache License, Version 2.0 (the "License");
882     you may not use this file except in compliance with the License.
883     You may obtain a copy of the License at
884     http://www.apache.org/licenses/LICENSE-2.0
885     Unless required by applicable law or agreed to in writing, software
886     distributed under the License is distributed on an "AS IS" BASIS,
887     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
888     See the License for the specific language governing permissions and
889     limitations under the License.
890 */
891 // pragma solidity >=0.6.10;
892 
893 // import { ISetToken } from "contracts/interfaces/ISetToken.sol";
894 
895 interface IBasicIssuanceModule {
896     function getRequiredComponentUnitsForIssue(
897         ISetToken _setToken,
898         uint256 _quantity
899     ) external returns(address[] memory, uint256[] memory);
900     function issue(ISetToken _setToken, uint256 _quantity, address _to) external;
901     function redeem(ISetToken _token, uint256 _quantity, address _to) external;
902 }
903 
904 // Dependency file: contracts/interfaces/IController.sol
905 
906 /*
907     Copyright 2020 Set Labs Inc.
908     Licensed under the Apache License, Version 2.0 (the "License");
909     you may not use this file except in compliance with the License.
910     You may obtain a copy of the License at
911     http://www.apache.org/licenses/LICENSE-2.0
912     Unless required by applicable law or agreed to in writing, software
913     distributed under the License is distributed on an "AS IS" BASIS,
914     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
915     See the License for the specific language governing permissions and
916     limitations under the License.
917 */
918 // pragma solidity 0.6.10;
919 
920 interface IController {
921     function addSet(address _setToken) external;
922     function feeRecipient() external view returns(address);
923     function getModuleFee(address _module, uint256 _feeType) external view returns(uint256);
924     function isModule(address _module) external view returns(bool);
925     function isSet(address _setToken) external view returns(bool);
926     function isSystemContract(address _contractAddress) external view returns (bool);
927     function resourceId(uint256 _id) external view returns(address);
928 }
929 
930 
931 // Dependency file: contracts/interfaces/IWETH.sol
932 
933 // pragma solidity >=0.6.10;
934 
935 interface IWETH {
936     function deposit() external payable;
937     function transfer(address to, uint value) external returns (bool);
938     function withdraw(uint) external;
939 }
940 
941 // Dependency file: @openzeppelin/contracts/math/SignedSafeMath.sol
942 
943 
944 // pragma solidity >=0.6.0 <0.8.0;
945 
946 /**
947  * @title SignedSafeMath
948  * @dev Signed math operations with safety checks that revert on error.
949  */
950 library SignedSafeMath {
951     int256 constant private _INT256_MIN = -2**255;
952 
953     /**
954      * @dev Returns the multiplication of two signed integers, reverting on
955      * overflow.
956      *
957      * Counterpart to Solidity's `*` operator.
958      *
959      * Requirements:
960      *
961      * - Multiplication cannot overflow.
962      */
963     function mul(int256 a, int256 b) internal pure returns (int256) {
964         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
965         // benefit is lost if 'b' is also tested.
966         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
967         if (a == 0) {
968             return 0;
969         }
970 
971         require(!(a == -1 && b == _INT256_MIN), "SignedSafeMath: multiplication overflow");
972 
973         int256 c = a * b;
974         require(c / a == b, "SignedSafeMath: multiplication overflow");
975 
976         return c;
977     }
978 
979     /**
980      * @dev Returns the integer division of two signed integers. Reverts on
981      * division by zero. The result is rounded towards zero.
982      *
983      * Counterpart to Solidity's `/` operator. Note: this function uses a
984      * `revert` opcode (which leaves remaining gas untouched) while Solidity
985      * uses an invalid opcode to revert (consuming all remaining gas).
986      *
987      * Requirements:
988      *
989      * - The divisor cannot be zero.
990      */
991     function div(int256 a, int256 b) internal pure returns (int256) {
992         require(b != 0, "SignedSafeMath: division by zero");
993         require(!(b == -1 && a == _INT256_MIN), "SignedSafeMath: division overflow");
994 
995         int256 c = a / b;
996 
997         return c;
998     }
999 
1000     /**
1001      * @dev Returns the subtraction of two signed integers, reverting on
1002      * overflow.
1003      *
1004      * Counterpart to Solidity's `-` operator.
1005      *
1006      * Requirements:
1007      *
1008      * - Subtraction cannot overflow.
1009      */
1010     function sub(int256 a, int256 b) internal pure returns (int256) {
1011         int256 c = a - b;
1012         require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");
1013 
1014         return c;
1015     }
1016 
1017     /**
1018      * @dev Returns the addition of two signed integers, reverting on
1019      * overflow.
1020      *
1021      * Counterpart to Solidity's `+` operator.
1022      *
1023      * Requirements:
1024      *
1025      * - Addition cannot overflow.
1026      */
1027     function add(int256 a, int256 b) internal pure returns (int256) {
1028         int256 c = a + b;
1029         require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");
1030 
1031         return c;
1032     }
1033 }
1034 
1035 
1036 // Dependency file: contracts/lib/PreciseUnitMath.sol
1037 
1038 /*
1039     Copyright 2020 Set Labs Inc.
1040 
1041     Licensed under the Apache License, Version 2.0 (the "License");
1042     you may not use this file except in compliance with the License.
1043     You may obtain a copy of the License at
1044 
1045     http://www.apache.org/licenses/LICENSE-2.0
1046 
1047     Unless required by applicable law or agreed to in writing, software
1048     distributed under the License is distributed on an "AS IS" BASIS,
1049     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1050     See the License for the specific language governing permissions and
1051     limitations under the License.
1052 
1053 */
1054 
1055 // pragma solidity 0.6.10;
1056 
1057 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
1058 // import { SignedSafeMath } from "@openzeppelin/contracts/math/SignedSafeMath.sol";
1059 
1060 
1061 /**
1062  * @title PreciseUnitMath
1063  * @author Set Protocol
1064  *
1065  * Arithmetic for fixed-point numbers with 18 decimals of precision. Some functions taken from
1066  * dYdX's BaseMath library.
1067  *
1068  * CHANGELOG:
1069  * - 9/21/20: Added safePower function
1070  */
1071 library PreciseUnitMath {
1072     using SafeMath for uint256;
1073     using SignedSafeMath for int256;
1074 
1075     // The number One in precise units.
1076     uint256 constant internal PRECISE_UNIT = 10 ** 18;
1077     int256 constant internal PRECISE_UNIT_INT = 10 ** 18;
1078 
1079     // Max unsigned integer value
1080     uint256 constant internal MAX_UINT_256 = type(uint256).max;
1081     // Max and min signed integer value
1082     int256 constant internal MAX_INT_256 = type(int256).max;
1083     int256 constant internal MIN_INT_256 = type(int256).min;
1084 
1085     /**
1086      * @dev Getter function since constants can't be read directly from libraries.
1087      */
1088     function preciseUnit() internal pure returns (uint256) {
1089         return PRECISE_UNIT;
1090     }
1091 
1092     /**
1093      * @dev Getter function since constants can't be read directly from libraries.
1094      */
1095     function preciseUnitInt() internal pure returns (int256) {
1096         return PRECISE_UNIT_INT;
1097     }
1098 
1099     /**
1100      * @dev Getter function since constants can't be read directly from libraries.
1101      */
1102     function maxUint256() internal pure returns (uint256) {
1103         return MAX_UINT_256;
1104     }
1105 
1106     /**
1107      * @dev Getter function since constants can't be read directly from libraries.
1108      */
1109     function maxInt256() internal pure returns (int256) {
1110         return MAX_INT_256;
1111     }
1112 
1113     /**
1114      * @dev Getter function since constants can't be read directly from libraries.
1115      */
1116     function minInt256() internal pure returns (int256) {
1117         return MIN_INT_256;
1118     }
1119 
1120     /**
1121      * @dev Multiplies value a by value b (result is rounded down). It's assumed that the value b is the significand
1122      * of a number with 18 decimals precision.
1123      */
1124     function preciseMul(uint256 a, uint256 b) internal pure returns (uint256) {
1125         return a.mul(b).div(PRECISE_UNIT);
1126     }
1127 
1128     /**
1129      * @dev Multiplies value a by value b (result is rounded towards zero). It's assumed that the value b is the
1130      * significand of a number with 18 decimals precision.
1131      */
1132     function preciseMul(int256 a, int256 b) internal pure returns (int256) {
1133         return a.mul(b).div(PRECISE_UNIT_INT);
1134     }
1135 
1136     /**
1137      * @dev Multiplies value a by value b (result is rounded up). It's assumed that the value b is the significand
1138      * of a number with 18 decimals precision.
1139      */
1140     function preciseMulCeil(uint256 a, uint256 b) internal pure returns (uint256) {
1141         if (a == 0 || b == 0) {
1142             return 0;
1143         }
1144         return a.mul(b).sub(1).div(PRECISE_UNIT).add(1);
1145     }
1146 
1147     /**
1148      * @dev Divides value a by value b (result is rounded down).
1149      */
1150     function preciseDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1151         return a.mul(PRECISE_UNIT).div(b);
1152     }
1153 
1154 
1155     /**
1156      * @dev Divides value a by value b (result is rounded towards 0).
1157      */
1158     function preciseDiv(int256 a, int256 b) internal pure returns (int256) {
1159         return a.mul(PRECISE_UNIT_INT).div(b);
1160     }
1161 
1162     /**
1163      * @dev Divides value a by value b (result is rounded up or away from 0).
1164      */
1165     function preciseDivCeil(uint256 a, uint256 b) internal pure returns (uint256) {
1166         require(b != 0, "Cant divide by 0");
1167 
1168         return a > 0 ? a.mul(PRECISE_UNIT).sub(1).div(b).add(1) : 0;
1169     }
1170 
1171     /**
1172      * @dev Divides value a by value b (result is rounded down - positive numbers toward 0 and negative away from 0).
1173      */
1174     function divDown(int256 a, int256 b) internal pure returns (int256) {
1175         require(b != 0, "Cant divide by 0");
1176         require(a != MIN_INT_256 || b != -1, "Invalid input");
1177 
1178         int256 result = a.div(b);
1179         if (a ^ b < 0 && a % b != 0) {
1180             result -= 1;
1181         }
1182 
1183         return result;
1184     }
1185 
1186     /**
1187      * @dev Multiplies value a by value b where rounding is towards the lesser number. 
1188      * (positive values are rounded towards zero and negative values are rounded away from 0). 
1189      */
1190     function conservativePreciseMul(int256 a, int256 b) internal pure returns (int256) {
1191         return divDown(a.mul(b), PRECISE_UNIT_INT);
1192     }
1193 
1194     /**
1195      * @dev Divides value a by value b where rounding is towards the lesser number. 
1196      * (positive values are rounded towards zero and negative values are rounded away from 0). 
1197      */
1198     function conservativePreciseDiv(int256 a, int256 b) internal pure returns (int256) {
1199         return divDown(a.mul(PRECISE_UNIT_INT), b);
1200     }
1201 
1202     /**
1203     * @dev Performs the power on a specified value, reverts on overflow.
1204     */
1205     function safePower(
1206         uint256 a,
1207         uint256 pow
1208     )
1209         internal
1210         pure
1211         returns (uint256)
1212     {
1213         require(a > 0, "Value must be positive");
1214 
1215         uint256 result = 1;
1216         for (uint256 i = 0; i < pow; i++){
1217             uint256 previousResult = result;
1218 
1219             // Using safemath multiplication prevents overflows
1220             result = previousResult.mul(a);
1221         }
1222 
1223         return result;
1224     }
1225 }
1226 
1227 // Dependency file: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
1228 
1229 // pragma solidity >=0.5.0;
1230 
1231 interface IUniswapV2Pair {
1232     event Approval(address indexed owner, address indexed spender, uint value);
1233     event Transfer(address indexed from, address indexed to, uint value);
1234 
1235     function name() external pure returns (string memory);
1236     function symbol() external pure returns (string memory);
1237     function decimals() external pure returns (uint8);
1238     function totalSupply() external view returns (uint);
1239     function balanceOf(address owner) external view returns (uint);
1240     function allowance(address owner, address spender) external view returns (uint);
1241 
1242     function approve(address spender, uint value) external returns (bool);
1243     function transfer(address to, uint value) external returns (bool);
1244     function transferFrom(address from, address to, uint value) external returns (bool);
1245 
1246     function DOMAIN_SEPARATOR() external view returns (bytes32);
1247     function PERMIT_TYPEHASH() external pure returns (bytes32);
1248     function nonces(address owner) external view returns (uint);
1249 
1250     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1251 
1252     event Mint(address indexed sender, uint amount0, uint amount1);
1253     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1254     event Swap(
1255         address indexed sender,
1256         uint amount0In,
1257         uint amount1In,
1258         uint amount0Out,
1259         uint amount1Out,
1260         address indexed to
1261     );
1262     event Sync(uint112 reserve0, uint112 reserve1);
1263 
1264     function MINIMUM_LIQUIDITY() external pure returns (uint);
1265     function factory() external view returns (address);
1266     function token0() external view returns (address);
1267     function token1() external view returns (address);
1268     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1269     function price0CumulativeLast() external view returns (uint);
1270     function price1CumulativeLast() external view returns (uint);
1271     function kLast() external view returns (uint);
1272 
1273     function mint(address to) external returns (uint liquidity);
1274     function burn(address to) external returns (uint amount0, uint amount1);
1275     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1276     function skim(address to) external;
1277     function sync() external;
1278 
1279     function initialize(address, address) external;
1280 }
1281 
1282 
1283 // Dependency file: external/contracts/UniSushiV2Library.sol
1284 
1285 
1286 // pragma solidity >=0.5.0;
1287 
1288 // import '/Users/alexsoong/Source/set-protocol/index-coop-contracts/node_modules/@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol';
1289 
1290 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
1291 
1292 library UniSushiV2Library {
1293     using SafeMath for uint;
1294 
1295     // returns sorted token addresses, used to handle return values from pairs sorted in this order
1296     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
1297         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
1298         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
1299         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
1300     }
1301 
1302     // fetches and sorts the reserves for a pair
1303     function getReserves(address pair, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
1304         (address token0,) = sortTokens(tokenA, tokenB);
1305         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pair).getReserves();
1306         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1307     }
1308 
1309     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
1310     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
1311         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
1312         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
1313         amountB = amountA.mul(reserveB) / reserveA;
1314     }
1315 
1316     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
1317     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
1318         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
1319         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
1320         uint amountInWithFee = amountIn.mul(997);
1321         uint numerator = amountInWithFee.mul(reserveOut);
1322         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
1323         amountOut = numerator / denominator;
1324     }
1325 
1326     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
1327     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
1328         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
1329         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
1330         uint numerator = reserveIn.mul(amountOut).mul(1000);
1331         uint denominator = reserveOut.sub(amountOut).mul(997);
1332         amountIn = (numerator / denominator).add(1);
1333     }
1334 
1335     // performs chained getAmountOut calculations on any number of pairs
1336     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
1337         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
1338         amounts = new uint[](path.length);
1339         amounts[0] = amountIn;
1340         for (uint i; i < path.length - 1; i++) {
1341             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
1342             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
1343         }
1344     }
1345 
1346     // performs chained getAmountIn calculations on any number of pairs
1347     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
1348         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
1349         amounts = new uint[](path.length);
1350         amounts[amounts.length - 1] = amountOut;
1351         for (uint i = path.length - 1; i > 0; i--) {
1352             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
1353             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
1354         }
1355     }
1356 }
1357 
1358 // Root file: contracts/exchangeIssuance/ExchangeIssuance.sol
1359 
1360 /*
1361     Copyright 2021 Index Cooperative
1362     Licensed under the Apache License, Version 2.0 (the "License");
1363     you may not use this file except in compliance with the License.
1364     You may obtain a copy of the License at
1365     http://www.apache.org/licenses/LICENSE-2.0
1366     Unless required by applicable law or agreed to in writing, software
1367     distributed under the License is distributed on an "AS IS" BASIS,
1368     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1369     See the License for the specific language governing permissions and
1370     limitations under the License.
1371 */
1372 pragma solidity 0.6.10;
1373 
1374 // import { Address } from "@openzeppelin/contracts/utils/Address.sol";
1375 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
1376 // import { IUniswapV2Factory } from "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
1377 // import { IUniswapV2Router02 } from "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
1378 // import { Math } from "@openzeppelin/contracts/math/Math.sol";
1379 // import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
1380 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
1381 // import { ReentrancyGuard } from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
1382 
1383 // import { IBasicIssuanceModule } from "contracts/interfaces/IBasicIssuanceModule.sol";
1384 // import { IController } from "contracts/interfaces/IController.sol";
1385 // import { ISetToken } from "contracts/interfaces/ISetToken.sol";
1386 // import { IWETH } from "contracts/interfaces/IWETH.sol";
1387 // import { PreciseUnitMath } from "contracts/lib/PreciseUnitMath.sol";
1388 // import { UniSushiV2Library } from "external/contracts/UniSushiV2Library.sol";
1389 
1390 
1391 /**
1392  * @title ExchangeIssuance
1393  * @author Index Coop
1394  *
1395  * Contract for issuing and redeeming any SetToken using ETH or an ERC20 as the paying/receiving currency.
1396  * All swaps are done using the best price found on Uniswap or Sushiswap.
1397  *
1398  */
1399 contract ExchangeIssuance is ReentrancyGuard {
1400     
1401     using Address for address payable;
1402     using SafeMath for uint256;
1403     using PreciseUnitMath for uint256;
1404     using SafeERC20 for IERC20;
1405     using SafeERC20 for ISetToken;
1406     
1407     /* ============ Enums ============ */
1408     
1409     enum Exchange { Uniswap, Sushiswap, None }
1410 
1411     /* ============ Constants ============= */
1412 
1413     uint256 constant private MAX_UINT96 = 2**96 - 1;
1414     address constant public ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
1415     
1416     /* ============ State Variables ============ */
1417 
1418     address public WETH;
1419     IUniswapV2Router02 public uniRouter;
1420     IUniswapV2Router02 public sushiRouter;
1421     
1422     address public immutable uniFactory;
1423     address public immutable sushiFactory;
1424     
1425     IController public immutable setController;
1426     IBasicIssuanceModule public immutable basicIssuanceModule;
1427 
1428     /* ============ Events ============ */
1429 
1430     event ExchangeIssue(
1431         address indexed _recipient,     // The recipient address of the issued SetTokens
1432         ISetToken indexed _setToken,    // The issued SetToken
1433         IERC20 indexed _inputToken,     // The address of the input asset(ERC20/ETH) used to issue the SetTokens
1434         uint256 _amountInputToken,      // The amount of input tokens used for issuance
1435         uint256 _amountSetIssued        // The amount of SetTokens received by the recipient
1436     );
1437 
1438     event ExchangeRedeem(
1439         address indexed _recipient,     // The recipient address which redeemed the SetTokens
1440         ISetToken indexed _setToken,    // The redeemed SetToken
1441         IERC20 indexed _outputToken,    // The address of output asset(ERC20/ETH) received by the recipient
1442         uint256 _amountSetRedeemed,     // The amount of SetTokens redeemed for output tokens
1443         uint256 _amountOutputToken      // The amount of output tokens received by the recipient
1444     );
1445 
1446     event Refund(
1447         address indexed _recipient,     // The recipient address which redeemed the SetTokens
1448         uint256 _refundAmount           // The amount of ETH redunded to the recipient
1449     );
1450     
1451     /* ============ Modifiers ============ */
1452     
1453     modifier isSetToken(ISetToken _setToken) {
1454          require(setController.isSet(address(_setToken)), "ExchangeIssuance: INVALID SET");
1455          _;
1456     }
1457     
1458     /* ============ Constructor ============ */
1459 
1460     constructor(
1461         address _weth,
1462         address _uniFactory,
1463         IUniswapV2Router02 _uniRouter, 
1464         address _sushiFactory, 
1465         IUniswapV2Router02 _sushiRouter, 
1466         IController _setController,
1467         IBasicIssuanceModule _basicIssuanceModule
1468     )
1469         public
1470     {
1471         uniFactory = _uniFactory;
1472         uniRouter = _uniRouter;
1473 
1474         sushiFactory = _sushiFactory;
1475         sushiRouter = _sushiRouter;
1476         
1477         setController = _setController;
1478         basicIssuanceModule = _basicIssuanceModule;
1479         
1480         WETH = _weth;
1481         IERC20(WETH).safeApprove(address(uniRouter), PreciseUnitMath.maxUint256());
1482         IERC20(WETH).safeApprove(address(sushiRouter), PreciseUnitMath.maxUint256());
1483     }
1484     
1485     /* ============ Public Functions ============ */
1486     
1487     /**
1488      * Runs all the necessary approval functions required for a given ERC20 token.
1489      * This function can be called when a new token is added to a SetToken during a 
1490      * rebalance.
1491      *
1492      * @param _token    Address of the token which needs approval
1493      */
1494     function approveToken(IERC20 _token) public {
1495         _safeApprove(_token, address(uniRouter), MAX_UINT96);
1496         _safeApprove(_token, address(sushiRouter), MAX_UINT96);
1497         _safeApprove(_token, address(basicIssuanceModule), MAX_UINT96);
1498     }
1499 
1500     /* ============ External Functions ============ */
1501     
1502     receive() external payable {
1503         // required for weth.withdraw() to work properly
1504         require(msg.sender == WETH, "ExchangeIssuance: Direct deposits not allowed");
1505     }
1506     
1507     /**
1508      * Runs all the necessary approval functions required for a list of ERC20 tokens.
1509      *
1510      * @param _tokens    Addresses of the tokens which need approval
1511      */
1512     function approveTokens(IERC20[] calldata _tokens) external {
1513         for (uint256 i = 0; i < _tokens.length; i++) {
1514             approveToken(_tokens[i]);
1515         }
1516     }
1517 
1518     /**
1519      * Runs all the necessary approval functions required before issuing
1520      * or redeeming a SetToken. This function need to be called only once before the first time
1521      * this smart contract is used on any particular SetToken.
1522      *
1523      * @param _setToken    Address of the SetToken being initialized
1524      */
1525     function approveSetToken(ISetToken _setToken) isSetToken(_setToken) external {
1526         address[] memory components = _setToken.getComponents();
1527         for (uint256 i = 0; i < components.length; i++) {
1528             // Check that the component does not have external positions
1529             require(
1530                 _setToken.getExternalPositionModules(components[i]).length == 0,
1531                 "ExchangeIssuance: EXTERNAL_POSITIONS_NOT_ALLOWED"
1532             );
1533             approveToken(IERC20(components[i]));
1534         }
1535     }
1536 
1537     /**
1538      * Issues SetTokens for an exact amount of input ERC20 tokens.
1539      * The ERC20 token must be approved by the sender to this contract. 
1540      *
1541      * @param _setToken         Address of the SetToken being issued
1542      * @param _inputToken       Address of input token
1543      * @param _amountInput      Amount of the input token / ether to spend
1544      * @param _minSetReceive    Minimum amount of SetTokens to receive. Prevents unnecessary slippage.
1545      *
1546      * @return setTokenAmount   Amount of SetTokens issued to the caller
1547      */
1548     function issueSetForExactToken(
1549         ISetToken _setToken,
1550         IERC20 _inputToken,
1551         uint256 _amountInput,
1552         uint256 _minSetReceive
1553     )   
1554         isSetToken(_setToken)
1555         external
1556         nonReentrant
1557         returns (uint256)
1558     {   
1559         require(_amountInput > 0, "ExchangeIssuance: INVALID INPUTS");
1560         
1561         _inputToken.safeTransferFrom(msg.sender, address(this), _amountInput);
1562         
1563         uint256 amountEth = address(_inputToken) == WETH
1564             ? _amountInput
1565             : _swapTokenForWETH(_inputToken, _amountInput);
1566 
1567         uint256 setTokenAmount = _issueSetForExactWETH(_setToken, _minSetReceive, amountEth);
1568         
1569         emit ExchangeIssue(msg.sender, _setToken, _inputToken, _amountInput, setTokenAmount);
1570         return setTokenAmount;
1571     }
1572     
1573     /**
1574      * Issues SetTokens for an exact amount of input ether.
1575      * 
1576      * @param _setToken         Address of the SetToken to be issued
1577      * @param _minSetReceive    Minimum amount of SetTokens to receive. Prevents unnecessary slippage.
1578      *
1579      * @return setTokenAmount   Amount of SetTokens issued to the caller
1580      */
1581     function issueSetForExactETH(
1582         ISetToken _setToken,
1583         uint256 _minSetReceive
1584     )
1585         isSetToken(_setToken)
1586         external
1587         payable
1588         nonReentrant
1589         returns(uint256)
1590     {
1591         require(msg.value > 0, "ExchangeIssuance: INVALID INPUTS");
1592         
1593         IWETH(WETH).deposit{value: msg.value}();
1594         
1595         uint256 setTokenAmount = _issueSetForExactWETH(_setToken, _minSetReceive, msg.value);
1596         
1597         emit ExchangeIssue(msg.sender, _setToken, IERC20(ETH_ADDRESS), msg.value, setTokenAmount);
1598         return setTokenAmount;
1599     }
1600     
1601     /**
1602     * Issues an exact amount of SetTokens for given amount of input ERC20 tokens.
1603     * The excess amount of tokens is returned in an equivalent amount of ether.
1604     *
1605     * @param _setToken              Address of the SetToken to be issued
1606     * @param _inputToken            Address of the input token
1607     * @param _amountSetToken        Amount of SetTokens to issue
1608     * @param _maxAmountInputToken   Maximum amount of input tokens to be used to issue SetTokens. The unused 
1609     *                               input tokens are returned as ether.
1610     *
1611     * @return amountEthReturn       Amount of ether returned to the caller
1612     */
1613     function issueExactSetFromToken(
1614         ISetToken _setToken,
1615         IERC20 _inputToken,
1616         uint256 _amountSetToken,
1617         uint256 _maxAmountInputToken
1618     )
1619         isSetToken(_setToken)
1620         external
1621         nonReentrant
1622         returns (uint256)
1623     {
1624         require(_amountSetToken > 0 && _maxAmountInputToken > 0, "ExchangeIssuance: INVALID INPUTS");
1625         
1626         _inputToken.safeTransferFrom(msg.sender, address(this), _maxAmountInputToken);
1627         
1628         uint256 initETHAmount = address(_inputToken) == WETH
1629             ? _maxAmountInputToken
1630             : _swapTokenForWETH(_inputToken, _maxAmountInputToken);
1631         
1632         uint256 amountEthSpent = _issueExactSetFromWETH(_setToken, _amountSetToken, initETHAmount);
1633         
1634         uint256 amountEthReturn = initETHAmount.sub(amountEthSpent);
1635         if (amountEthReturn > 0) {
1636             IWETH(WETH).withdraw(amountEthReturn);
1637             (payable(msg.sender)).sendValue(amountEthReturn);
1638         }
1639         
1640         emit Refund(msg.sender, amountEthReturn);
1641         emit ExchangeIssue(msg.sender, _setToken, _inputToken, _maxAmountInputToken, _amountSetToken);
1642         return amountEthReturn;
1643     }
1644     
1645     /**
1646     * Issues an exact amount of SetTokens using a given amount of ether.
1647     * The excess ether is returned back.
1648     * 
1649     * @param _setToken          Address of the SetToken being issued
1650     * @param _amountSetToken    Amount of SetTokens to issue
1651     *
1652     * @return amountEthReturn   Amount of ether returned to the caller
1653     */
1654     function issueExactSetFromETH(
1655         ISetToken _setToken,
1656         uint256 _amountSetToken
1657     )
1658         isSetToken(_setToken)
1659         external
1660         payable
1661         nonReentrant
1662         returns (uint256)
1663     {
1664         require(msg.value > 0 && _amountSetToken > 0, "ExchangeIssuance: INVALID INPUTS");
1665         
1666         IWETH(WETH).deposit{value: msg.value}();
1667         
1668         uint256 amountEth = _issueExactSetFromWETH(_setToken, _amountSetToken, msg.value);
1669         
1670         uint256 amountEthReturn = msg.value.sub(amountEth);
1671         
1672         if (amountEthReturn > 0) {
1673             IWETH(WETH).withdraw(amountEthReturn);
1674             (payable(msg.sender)).sendValue(amountEthReturn);
1675         }
1676         
1677         emit Refund(msg.sender, amountEthReturn);
1678         emit ExchangeIssue(msg.sender, _setToken, IERC20(ETH_ADDRESS), amountEth, _amountSetToken);
1679         return amountEthReturn;
1680     }
1681     
1682     /**
1683      * Redeems an exact amount of SetTokens for an ERC20 token.
1684      * The SetToken must be approved by the sender to this contract.
1685      *
1686      * @param _setToken             Address of the SetToken being redeemed
1687      * @param _outputToken          Address of output token
1688      * @param _amountSetToken       Amount SetTokens to redeem
1689      * @param _minOutputReceive     Minimum amount of output token to receive
1690      *
1691      * @return outputAmount         Amount of output tokens sent to the caller
1692      */
1693     function redeemExactSetForToken(
1694         ISetToken _setToken,
1695         IERC20 _outputToken,
1696         uint256 _amountSetToken,
1697         uint256 _minOutputReceive
1698     )
1699         isSetToken(_setToken)
1700         external
1701         nonReentrant
1702         returns (uint256)
1703     {
1704         require(_amountSetToken > 0, "ExchangeIssuance: INVALID INPUTS");
1705         
1706         address[] memory components = _setToken.getComponents();
1707         (
1708             uint256 totalEth, 
1709             uint256[] memory amountComponents, 
1710             Exchange[] memory exchanges
1711         ) =  _getAmountETHForRedemption(_setToken, components, _amountSetToken);
1712         
1713         uint256 outputAmount;
1714         if (address(_outputToken) == WETH) {
1715             require(totalEth > _minOutputReceive, "ExchangeIssuance: INSUFFICIENT_OUTPUT_AMOUNT");
1716             _redeemExactSet(_setToken, _amountSetToken);
1717             outputAmount = _liquidateComponentsForWETH(components, amountComponents, exchanges);
1718         } else {
1719             (uint256 totalOutput, Exchange outTokenExchange, ) = _getMaxTokenForExactToken(totalEth, address(WETH), address(_outputToken));
1720             require(totalOutput > _minOutputReceive, "ExchangeIssuance: INSUFFICIENT_OUTPUT_AMOUNT");
1721             _redeemExactSet(_setToken, _amountSetToken);
1722             uint256 outputEth = _liquidateComponentsForWETH(components, amountComponents, exchanges);
1723             outputAmount = _swapExactTokensForTokens(outTokenExchange, WETH, address(_outputToken), outputEth);
1724         }
1725         
1726         _outputToken.safeTransfer(msg.sender, outputAmount);
1727         emit ExchangeRedeem(msg.sender, _setToken, _outputToken, _amountSetToken, outputAmount);
1728         return outputAmount;
1729     }
1730     
1731     /**
1732      * Redeems an exact amount of SetTokens for ETH.
1733      * The SetToken must be approved by the sender to this contract.
1734      *
1735      * @param _setToken             Address of the SetToken to be redeemed
1736      * @param _amountSetToken       Amount of SetTokens to redeem
1737      * @param _minEthOut            Minimum amount of ETH to receive
1738      *
1739      * @return amountEthOut         Amount of ether sent to the caller
1740      */
1741     function redeemExactSetForETH(
1742         ISetToken _setToken,
1743         uint256 _amountSetToken,
1744         uint256 _minEthOut
1745     )
1746         isSetToken(_setToken)
1747         external
1748         nonReentrant
1749         returns (uint256)
1750     {
1751         require(_amountSetToken > 0, "ExchangeIssuance: INVALID INPUTS");
1752         
1753         address[] memory components = _setToken.getComponents();
1754         (
1755             uint256 totalEth, 
1756             uint256[] memory amountComponents, 
1757             Exchange[] memory exchanges
1758         ) =  _getAmountETHForRedemption(_setToken, components, _amountSetToken);
1759         
1760         require(totalEth > _minEthOut, "ExchangeIssuance: INSUFFICIENT_OUTPUT_AMOUNT");
1761         
1762         _redeemExactSet(_setToken, _amountSetToken);
1763         
1764         uint256 amountEthOut = _liquidateComponentsForWETH(components, amountComponents, exchanges);
1765         
1766         IWETH(WETH).withdraw(amountEthOut);
1767         (payable(msg.sender)).sendValue(amountEthOut);
1768 
1769         emit ExchangeRedeem(msg.sender, _setToken, IERC20(ETH_ADDRESS), _amountSetToken, amountEthOut);
1770         return amountEthOut;
1771     }
1772 
1773     /**
1774      * Returns an estimated amount of SetToken that can be issued given an amount of input ERC20 token.
1775      *
1776      * @param _setToken         Address of the SetToken being issued
1777      * @param _amountInput      Amount of the input token to spend
1778      * @param _inputToken       Address of input token.
1779      *
1780      * @return                  Estimated amount of SetTokens that will be received
1781      */
1782     function getEstimatedIssueSetAmount(
1783         ISetToken _setToken,
1784         IERC20 _inputToken,
1785         uint256 _amountInput
1786     )
1787         isSetToken(_setToken)
1788         external
1789         view
1790         returns (uint256)
1791     {
1792         require(_amountInput > 0, "ExchangeIssuance: INVALID INPUTS");
1793         
1794         uint256 amountEth;
1795         if (address(_inputToken) != WETH) {
1796             // get max amount of WETH for the `_amountInput` amount of input tokens
1797             (amountEth, , ) = _getMaxTokenForExactToken(_amountInput, address(_inputToken), WETH);
1798         } else {
1799             amountEth = _amountInput;
1800         }
1801         
1802         address[] memory components = _setToken.getComponents();
1803         (uint256 setIssueAmount, , ) = _getSetIssueAmountForETH(_setToken, components, amountEth);
1804         return setIssueAmount;
1805     }
1806     
1807     /**
1808     * Returns the amount of input ERC20 tokens required to issue an exact amount of SetTokens.
1809     *
1810     * @param _setToken          Address of the SetToken being issued
1811     * @param _amountSetToken    Amount of SetTokens to issue
1812     *
1813     * @return                   Amount of tokens needed to issue specified amount of SetTokens
1814     */
1815     function getAmountInToIssueExactSet(
1816         ISetToken _setToken,
1817         IERC20 _inputToken,
1818         uint256 _amountSetToken
1819     )
1820         isSetToken(_setToken)
1821         external
1822         view
1823         returns(uint256)
1824     {
1825         require(_amountSetToken > 0, "ExchangeIssuance: INVALID INPUTS");
1826         
1827         address[] memory components = _setToken.getComponents();
1828         (uint256 totalEth, , , , ) = _getAmountETHForIssuance(_setToken, components, _amountSetToken);
1829         
1830         if (address(_inputToken) == WETH) {
1831             return totalEth;
1832         }
1833         
1834         (uint256 tokenAmount, , ) = _getMinTokenForExactToken(totalEth, address(_inputToken), address(WETH));
1835         return tokenAmount;
1836     }
1837     
1838     /**
1839      * Returns amount of output ERC20 tokens received upon redeeming a given amount of SetToken.
1840      *
1841      * @param _setToken             Address of SetToken to be redeemed
1842      * @param _amountSetToken       Amount of SetToken to be redeemed
1843      * @param _outputToken          Address of output token
1844      *
1845      * @return                      Estimated amount of ether/erc20 that will be received
1846      */
1847     function getAmountOutOnRedeemSet(
1848         ISetToken _setToken,
1849         address _outputToken,
1850         uint256 _amountSetToken
1851     ) 
1852         isSetToken(_setToken)
1853         external
1854         view
1855         returns (uint256)
1856     {
1857         require(_amountSetToken > 0, "ExchangeIssuance: INVALID INPUTS");
1858         
1859         address[] memory components = _setToken.getComponents();
1860         (uint256 totalEth, , ) = _getAmountETHForRedemption(_setToken, components, _amountSetToken);
1861         
1862         if (_outputToken == WETH) {
1863             return totalEth;
1864         }
1865         
1866         // get maximum amount of tokens for totalEth amount of ETH
1867         (uint256 tokenAmount, , ) = _getMaxTokenForExactToken(totalEth, WETH, _outputToken);
1868         return tokenAmount;
1869     }
1870     
1871     
1872     /* ============ Internal Functions ============ */
1873 
1874     /**
1875      * Sets a max approval limit for an ERC20 token, provided the current allowance 
1876      * is less than the required allownce. 
1877      * 
1878      * @param _token    Token to approve
1879      * @param _spender  Spender address to approve
1880      */
1881     function _safeApprove(IERC20 _token, address _spender, uint256 _requiredAllowance) internal {
1882         uint256 allowance = _token.allowance(address(this), _spender);
1883         if (allowance < _requiredAllowance) {
1884             _token.safeIncreaseAllowance(_spender, MAX_UINT96 - allowance);
1885         }
1886     }
1887     
1888     /**
1889      * Issues SetTokens for an exact amount of input WETH.
1890      * 
1891      * @param _setToken         Address of the SetToken being issued
1892      * @param _minSetReceive    Minimum amount of index to receive
1893      * @param _totalEthAmount   Total amount of WETH to be used to purchase the SetToken components
1894      *
1895      * @return setTokenAmount   Amount of SetTokens issued
1896      */
1897     function _issueSetForExactWETH(ISetToken _setToken, uint256 _minSetReceive, uint256 _totalEthAmount) internal returns (uint256) {
1898         
1899         address[] memory components = _setToken.getComponents();
1900         (
1901             uint256 setIssueAmount, 
1902             uint256[] memory amountEthIn, 
1903             Exchange[] memory exchanges
1904         ) = _getSetIssueAmountForETH(_setToken, components, _totalEthAmount);
1905         
1906         require(setIssueAmount > _minSetReceive, "ExchangeIssuance: INSUFFICIENT_OUTPUT_AMOUNT");
1907         
1908         for (uint256 i = 0; i < components.length; i++) {
1909             _swapExactTokensForTokens(exchanges[i], WETH, components[i], amountEthIn[i]);
1910         }
1911         
1912         basicIssuanceModule.issue(_setToken, setIssueAmount, msg.sender);
1913         return setIssueAmount;
1914     }
1915     
1916     /**
1917      * Issues an exact amount of SetTokens using WETH. 
1918      * Acquires SetToken components at the best price accross uniswap and sushiswap.
1919      * Uses the acquired components to issue the SetTokens.
1920      * 
1921      * @param _setToken          Address of the SetToken being issued
1922      * @param _amountSetToken    Amount of SetTokens to be issued
1923      * @param _maxEther          Max amount of ether that can be used to acquire the SetToken components
1924      *
1925      * @return totalEth          Total amount of ether used to acquire the SetToken components
1926      */
1927     function _issueExactSetFromWETH(ISetToken _setToken, uint256 _amountSetToken, uint256 _maxEther) internal returns (uint256) {
1928         
1929         address[] memory components = _setToken.getComponents();
1930         (
1931             uint256 sumEth,
1932             , 
1933             Exchange[] memory exchanges, 
1934             uint256[] memory amountComponents,
1935         ) = _getAmountETHForIssuance(_setToken, components, _amountSetToken);
1936         
1937         require(sumEth <= _maxEther, "ExchangeIssuance: INSUFFICIENT_INPUT_AMOUNT");
1938         
1939         uint256 totalEth = 0;
1940         for (uint256 i = 0; i < components.length; i++) {
1941             uint256 amountEth = _swapTokensForExactTokens(exchanges[i], WETH, components[i], amountComponents[i]);
1942             totalEth = totalEth.add(amountEth);
1943         }
1944         basicIssuanceModule.issue(_setToken, _amountSetToken, msg.sender);
1945         return totalEth;
1946     }
1947     
1948     /**
1949      * Redeems a given amount of SetToken.
1950      * 
1951      * @param _setToken     Address of the SetToken to be redeemed
1952      * @param _amount       Amount of SetToken to be redeemed
1953      */
1954     function _redeemExactSet(ISetToken _setToken, uint256 _amount) internal returns (uint256) {
1955         _setToken.safeTransferFrom(msg.sender, address(this), _amount);
1956         basicIssuanceModule.redeem(_setToken, _amount, address(this));
1957     }
1958     
1959     /**
1960      * Liquidates a given list of SetToken components for WETH.
1961      * 
1962      * @param _components           An array containing the address of SetToken components
1963      * @param _amountComponents     An array containing the amount of each SetToken component
1964      * @param _exchanges            An array containing the exchange on which to liquidate the SetToken component
1965      *
1966      * @return                      Total amount of WETH received after liquidating all SetToken components
1967      */
1968     function _liquidateComponentsForWETH(address[] memory _components, uint256[] memory _amountComponents, Exchange[] memory _exchanges)
1969         internal
1970         returns (uint256)
1971     {
1972         uint256 sumEth = 0;
1973         for (uint256 i = 0; i < _components.length; i++) {
1974             sumEth = _exchanges[i] == Exchange.None
1975                 ? sumEth.add(_amountComponents[i]) 
1976                 : sumEth.add(_swapExactTokensForTokens(_exchanges[i], _components[i], WETH, _amountComponents[i]));
1977         }
1978         return sumEth;
1979     }
1980     
1981     /**
1982      * Gets the total amount of ether required for purchasing each component in a SetToken,
1983      * to enable the issuance of a given amount of SetTokens.
1984      * 
1985      * @param _setToken             Address of the SetToken to be issued
1986      * @param _components           An array containing the addresses of the SetToken components
1987      * @param _amountSetToken       Amount of SetToken to be issued
1988      *
1989      * @return sumEth               The total amount of Ether reuired to issue the set
1990      * @return amountEthIn          An array containing the amount of ether to purchase each component of the SetToken
1991      * @return exchanges            An array containing the exchange on which to perform the purchase
1992      * @return amountComponents     An array containing the amount of each SetToken component required for issuing the given
1993      *                              amount of SetToken
1994      * @return pairAddresses        An array containing the pair addresses of ETH/component exchange pool
1995      */
1996     function _getAmountETHForIssuance(ISetToken _setToken, address[] memory _components, uint256 _amountSetToken)
1997         internal
1998         view
1999         returns (
2000             uint256 sumEth, 
2001             uint256[] memory amountEthIn, 
2002             Exchange[] memory exchanges, 
2003             uint256[] memory amountComponents, 
2004             address[] memory pairAddresses
2005         )
2006     {
2007         sumEth = 0;
2008         amountEthIn = new uint256[](_components.length);
2009         amountComponents = new uint256[](_components.length);
2010         exchanges = new Exchange[](_components.length);
2011         pairAddresses = new address[](_components.length);
2012         
2013         for (uint256 i = 0; i < _components.length; i++) {
2014 
2015             // Check that the component does not have external positions
2016             require(
2017                 _setToken.getExternalPositionModules(_components[i]).length == 0,
2018                 "ExchangeIssuance: EXTERNAL_POSITIONS_NOT_ALLOWED"
2019             );
2020 
2021             // Get minimum amount of ETH to be spent to acquire the required amount of SetToken component
2022             uint256 unit = uint256(_setToken.getDefaultPositionRealUnit(_components[i]));
2023             amountComponents[i] = uint256(unit).preciseMulCeil(_amountSetToken);
2024             
2025             (amountEthIn[i], exchanges[i], pairAddresses[i]) = _getMinTokenForExactToken(amountComponents[i], WETH, _components[i]);
2026             sumEth = sumEth.add(amountEthIn[i]);
2027         }
2028         return (sumEth, amountEthIn, exchanges, amountComponents, pairAddresses);
2029     }
2030     
2031     /**
2032      * Gets the total amount of ether returned from liquidating each component in a SetToken.
2033      * 
2034      * @param _setToken             Address of the SetToken to be redeemed
2035      * @param _components           An array containing the addresses of the SetToken components
2036      * @param _amountSetToken       Amount of SetToken to be redeemed
2037      *
2038      * @return sumEth               The total amount of Ether that would be obtained from liquidating the SetTokens
2039      * @return amountComponents     An array containing the amount of SetToken component to be liquidated
2040      * @return exchanges            An array containing the exchange on which to liquidate the SetToken components
2041      */
2042     function _getAmountETHForRedemption(ISetToken _setToken, address[] memory _components, uint256 _amountSetToken)
2043         internal
2044         view
2045         returns (uint256, uint256[] memory, Exchange[] memory)
2046     {
2047         uint256 sumEth = 0;
2048         uint256 amountEth = 0;
2049         
2050         uint256[] memory amountComponents = new uint256[](_components.length);
2051         Exchange[] memory exchanges = new Exchange[](_components.length);
2052         
2053         for (uint256 i = 0; i < _components.length; i++) {
2054             
2055             // Check that the component does not have external positions
2056             require(
2057                 _setToken.getExternalPositionModules(_components[i]).length == 0,
2058                 "ExchangeIssuance: EXTERNAL_POSITIONS_NOT_ALLOWED"
2059             );
2060             
2061             uint256 unit = uint256(_setToken.getDefaultPositionRealUnit(_components[i]));
2062             amountComponents[i] = unit.preciseMul(_amountSetToken);
2063             
2064             // get maximum amount of ETH received for a given amount of SetToken component
2065             (amountEth, exchanges[i], ) = _getMaxTokenForExactToken(amountComponents[i], _components[i], WETH);
2066             sumEth = sumEth.add(amountEth);
2067         }
2068         return (sumEth, amountComponents, exchanges);
2069     }
2070     
2071     /**
2072      * Returns an estimated amount of SetToken that can be issued given an amount of input ERC20 token.
2073      * 
2074      * @param _setToken             Address of the SetToken to be issued
2075      * @param _components           An array containing the addresses of the SetToken components
2076      * @param _amountEth            Total amount of ether available for the purchase of SetToken components       
2077      *
2078      * @return setIssueAmount       The max amount of SetTokens that can be issued
2079      * @return amountEthIn          An array containing the amount ether required to purchase each SetToken component
2080      * @return exchanges            An array containing the exchange on which to purchase the SetToken components
2081      */
2082     function _getSetIssueAmountForETH(ISetToken _setToken, address[] memory _components, uint256 _amountEth) 
2083         internal
2084         view
2085         returns (uint256 setIssueAmount, uint256[] memory amountEthIn, Exchange[] memory exchanges)
2086     {
2087         uint256 sumEth;
2088         uint256[] memory unitAmountEthIn;
2089         uint256[] memory unitAmountComponents;
2090         address[] memory pairAddresses;
2091         (
2092             sumEth,
2093             unitAmountEthIn,
2094             exchanges, 
2095             unitAmountComponents,
2096             pairAddresses
2097         ) = _getAmountETHForIssuance(_setToken, _components, PreciseUnitMath.preciseUnit());
2098         
2099         setIssueAmount = PreciseUnitMath.maxUint256();
2100         amountEthIn = new uint256[](_components.length);
2101         
2102         for (uint256 i = 0; i < _components.length; i++) {
2103             
2104             amountEthIn[i] = unitAmountEthIn[i].mul(_amountEth).div(sumEth);
2105             
2106             uint256 amountComponent;
2107             if (exchanges[i] == Exchange.None) {
2108                 amountComponent = amountEthIn[i];
2109             } else {
2110                 (uint256 reserveIn, uint256 reserveOut) = UniSushiV2Library.getReserves(pairAddresses[i], WETH, _components[i]);
2111                 amountComponent = UniSushiV2Library.getAmountOut(amountEthIn[i], reserveIn, reserveOut);
2112             }
2113             setIssueAmount = Math.min(amountComponent.preciseDiv(unitAmountComponents[i]), setIssueAmount);
2114         }
2115         return (setIssueAmount, amountEthIn, exchanges);
2116     }
2117     
2118     /**
2119      * Swaps a given amount of an ERC20 token for WETH for the best price on Uniswap/Sushiswap.
2120      * 
2121      * @param _token    Address of the ERC20 token to be swapped for WETH
2122      * @param _amount   Amount of ERC20 token to be swapped
2123      *
2124      * @return          Amount of WETH received after the swap
2125      */
2126     function _swapTokenForWETH(IERC20 _token, uint256 _amount) internal returns (uint256) {
2127         (, Exchange exchange, ) = _getMaxTokenForExactToken(_amount, address(_token), WETH);
2128         IUniswapV2Router02 router = _getRouter(exchange);
2129         _safeApprove(_token, address(router), _amount);
2130         return _swapExactTokensForTokens(exchange, address(_token), WETH, _amount);
2131     }
2132     
2133     /**
2134      * Swap exact tokens for another token on a given DEX.
2135      *
2136      * @param _exchange     The exchange on which to peform the swap
2137      * @param _tokenIn      The address of the input token
2138      * @param _tokenOut     The address of the output token
2139      * @param _amountIn     The amount of input token to be spent
2140      *
2141      * @return              The amount of output tokens
2142      */
2143     function _swapExactTokensForTokens(Exchange _exchange, address _tokenIn, address _tokenOut, uint256 _amountIn) internal returns (uint256) {
2144         if (_tokenIn == _tokenOut) {
2145             return _amountIn;
2146         }
2147         address[] memory path = new address[](2);
2148         path[0] = _tokenIn;
2149         path[1] = _tokenOut;
2150         return _getRouter(_exchange).swapExactTokensForTokens(_amountIn, 0, path, address(this), block.timestamp)[1];
2151     }
2152     
2153     /**
2154      * Swap tokens for exact amount of output tokens on a given DEX.
2155      *
2156      * @param _exchange     The exchange on which to peform the swap
2157      * @param _tokenIn      The address of the input token
2158      * @param _tokenOut     The address of the output token
2159      * @param _amountOut    The amount of output token required
2160      *
2161      * @return              The amount of input tokens spent
2162      */
2163     function _swapTokensForExactTokens(Exchange _exchange, address _tokenIn, address _tokenOut, uint256 _amountOut) internal returns (uint256) {
2164         if (_tokenIn == _tokenOut) {
2165             return _amountOut;
2166         }
2167         address[] memory path = new address[](2);
2168         path[0] = _tokenIn;
2169         path[1] = _tokenOut;
2170         return _getRouter(_exchange).swapTokensForExactTokens(_amountOut, PreciseUnitMath.maxUint256(), path, address(this), block.timestamp)[0];
2171     }
2172  
2173     /**
2174      * Compares the amount of token required for an exact amount of another token across both exchanges,
2175      * and returns the min amount.
2176      *
2177      * @param _amountOut    The amount of output token
2178      * @param _tokenA       The address of tokenA
2179      * @param _tokenB       The address of tokenB
2180      *
2181      * @return              The min amount of tokenA required across both exchanges
2182      * @return              The Exchange on which minimum amount of tokenA is required
2183      * @return              The pair address of the uniswap/sushiswap pool containing _tokenA and _tokenB
2184      */
2185     function _getMinTokenForExactToken(uint256 _amountOut, address _tokenA, address _tokenB) internal view returns (uint256, Exchange, address) {
2186         if (_tokenA == _tokenB) {
2187             return (_amountOut, Exchange.None, ETH_ADDRESS);
2188         }
2189         
2190         uint256 maxIn = PreciseUnitMath.maxUint256() ; 
2191         uint256 uniTokenIn = maxIn;
2192         uint256 sushiTokenIn = maxIn;
2193         
2194         address uniswapPair = _getPair(uniFactory, _tokenA, _tokenB);
2195         if (uniswapPair != address(0)) {
2196             (uint256 reserveIn, uint256 reserveOut) = UniSushiV2Library.getReserves(uniswapPair, _tokenA, _tokenB);
2197             // Prevent subtraction overflow by making sure pool reserves are greater than swap amount
2198             if (reserveOut > _amountOut) {
2199                 uniTokenIn = UniSushiV2Library.getAmountIn(_amountOut, reserveIn, reserveOut);
2200             }
2201         }
2202         
2203         address sushiswapPair = _getPair(sushiFactory, _tokenA, _tokenB);
2204         if (sushiswapPair != address(0)) {
2205             (uint256 reserveIn, uint256 reserveOut) = UniSushiV2Library.getReserves(sushiswapPair, _tokenA, _tokenB);
2206             // Prevent subtraction overflow by making sure pool reserves are greater than swap amount
2207             if (reserveOut > _amountOut) {
2208                 sushiTokenIn = UniSushiV2Library.getAmountIn(_amountOut, reserveIn, reserveOut);
2209             }
2210         }
2211         
2212         // Fails if both the values are maxIn
2213         require(!(uniTokenIn == maxIn && sushiTokenIn == maxIn), "ExchangeIssuance: ILLIQUID_SET_COMPONENT");
2214         return (uniTokenIn <= sushiTokenIn) ? (uniTokenIn, Exchange.Uniswap, uniswapPair) : (sushiTokenIn, Exchange.Sushiswap, sushiswapPair);
2215     }
2216     
2217     /**
2218      * Compares the amount of token received for an exact amount of another token across both exchanges,
2219      * and returns the max amount.
2220      *
2221      * @param _amountIn     The amount of input token
2222      * @param _tokenA       The address of tokenA
2223      * @param _tokenB       The address of tokenB
2224      *
2225      * @return              The max amount of tokens that can be received across both exchanges
2226      * @return              The Exchange on which maximum amount of token can be received
2227      * @return              The pair address of the uniswap/sushiswap pool containing _tokenA and _tokenB
2228      */
2229     function _getMaxTokenForExactToken(uint256 _amountIn, address _tokenA, address _tokenB) internal view returns (uint256, Exchange, address) {
2230         if (_tokenA == _tokenB) {
2231             return (_amountIn, Exchange.None, ETH_ADDRESS);
2232         }
2233         
2234         uint256 uniTokenOut = 0;
2235         uint256 sushiTokenOut = 0;
2236         
2237         address uniswapPair = _getPair(uniFactory, _tokenA, _tokenB);
2238         if(uniswapPair != address(0)) {
2239             (uint256 reserveIn, uint256 reserveOut) = UniSushiV2Library.getReserves(uniswapPair, _tokenA, _tokenB);
2240             uniTokenOut = UniSushiV2Library.getAmountOut(_amountIn, reserveIn, reserveOut);
2241         }
2242         
2243         address sushiswapPair = _getPair(sushiFactory, _tokenA, _tokenB);
2244         if(sushiswapPair != address(0)) {
2245             (uint256 reserveIn, uint256 reserveOut) = UniSushiV2Library.getReserves(sushiswapPair, _tokenA, _tokenB);
2246             sushiTokenOut = UniSushiV2Library.getAmountOut(_amountIn, reserveIn, reserveOut);
2247         }
2248         
2249         // Fails if both the values are 0
2250         require(!(uniTokenOut == 0 && sushiTokenOut == 0), "ExchangeIssuance: ILLIQUID_SET_COMPONENT");
2251         return (uniTokenOut >= sushiTokenOut) ? (uniTokenOut, Exchange.Uniswap, uniswapPair) : (sushiTokenOut, Exchange.Sushiswap, sushiswapPair); 
2252     }
2253     
2254     /**
2255      * Returns the pair address for on a given DEX.
2256      *
2257      * @param _factory   The factory to address
2258      * @param _tokenA    The address of tokenA
2259      * @param _tokenB    The address of tokenB
2260      *
2261      * @return           The pair address (Note: address(0) is returned by default if the pair is not available on that DEX)
2262      */
2263     function _getPair(address _factory, address _tokenA, address _tokenB) internal view returns (address) {
2264         return IUniswapV2Factory(_factory).getPair(_tokenA, _tokenB);
2265     }
2266     
2267     /**
2268      * Returns the router address of a given exchange.
2269      * 
2270      * @param _exchange     The Exchange whose router address is needed
2271      *
2272      * @return              IUniswapV2Router02 router of the given exchange
2273      */
2274      function _getRouter(Exchange _exchange) internal view returns(IUniswapV2Router02) {
2275          return (_exchange == Exchange.Uniswap) ? uniRouter : sushiRouter;
2276      }
2277     
2278 }