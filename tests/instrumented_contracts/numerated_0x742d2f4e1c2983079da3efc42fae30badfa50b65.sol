1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.12;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8  
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 /**
81  * @title SafeERC20
82  * @dev Wrappers around ERC20 operations that throw on failure (when the token
83  * contract returns false). Tokens that return no value (and instead revert or
84  * throw on failure) are also supported, non-reverting calls are assumed to be
85  * successful.
86  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
87  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
88  */
89 library SafeERC20 {
90     using SafeMath for uint256;
91     using Address for address;
92 
93     function safeTransfer(IERC20 token, address to, uint256 value) internal {
94         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
95     }
96 
97     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
98         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
99     }
100 
101     /**
102      * @dev Deprecated. This function has issues similar to the ones found in
103      * {IERC20-approve}, and its usage is discouraged.
104      *
105      * Whenever possible, use {safeIncreaseAllowance} and
106      * {safeDecreaseAllowance} instead.
107      */
108     function safeApprove(IERC20 token, address spender, uint256 value) internal {
109         // safeApprove should only be called when setting an initial allowance,
110         // or when resetting it to zero. To increase and decrease it, use
111         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
112         // solhint-disable-next-line max-line-length
113         require((value == 0) || (token.allowance(address(this), spender) == 0),
114             "SafeERC20: approve from non-zero to non-zero allowance"
115         );
116         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
117     }
118 
119     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
120         uint256 newAllowance = token.allowance(address(this), spender).add(value);
121         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
122     }
123 
124     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
125         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
126         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
127     }
128 
129     /**
130      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
131      * on the return value: the return value is optional (but if data is returned, it must not be false).
132      * @param token The token targeted by the call.
133      * @param data The call data (encoded using abi.encode or one of its variants).
134      */
135     function _callOptionalReturn(IERC20 token, bytes memory data) private {
136         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
137         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
138         // the target address contains contract code and also asserts for success in the low-level call.
139 
140         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
141         if (returndata.length > 0) { // Return data is optional
142             // solhint-disable-next-line max-line-length
143             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
144         }
145     }
146 }
147 
148 interface IWETH {
149     function deposit() external payable;
150     function transfer(address to, uint value) external returns (bool);
151     function withdraw(uint) external;
152 }
153 
154 interface IUniswapV2Router01 {
155     function factory() external pure returns (address);
156     function WETH() external pure returns (address);
157 
158     function addLiquidity(
159         address tokenA,
160         address tokenB,
161         uint amountADesired,
162         uint amountBDesired,
163         uint amountAMin,
164         uint amountBMin,
165         address to,
166         uint deadline
167     ) external returns (uint amountA, uint amountB, uint liquidity);
168     function addLiquidityETH(
169         address token,
170         uint amountTokenDesired,
171         uint amountTokenMin,
172         uint amountETHMin,
173         address to,
174         uint deadline
175     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
176     function removeLiquidity(
177         address tokenA,
178         address tokenB,
179         uint liquidity,
180         uint amountAMin,
181         uint amountBMin,
182         address to,
183         uint deadline
184     ) external returns (uint amountA, uint amountB);
185     function removeLiquidityETH(
186         address token,
187         uint liquidity,
188         uint amountTokenMin,
189         uint amountETHMin,
190         address to,
191         uint deadline
192     ) external returns (uint amountToken, uint amountETH);
193     function removeLiquidityWithPermit(
194         address tokenA,
195         address tokenB,
196         uint liquidity,
197         uint amountAMin,
198         uint amountBMin,
199         address to,
200         uint deadline,
201         bool approveMax, uint8 v, bytes32 r, bytes32 s
202     ) external returns (uint amountA, uint amountB);
203     function removeLiquidityETHWithPermit(
204         address token,
205         uint liquidity,
206         uint amountTokenMin,
207         uint amountETHMin,
208         address to,
209         uint deadline,
210         bool approveMax, uint8 v, bytes32 r, bytes32 s
211     ) external returns (uint amountToken, uint amountETH);
212     function swapExactTokensForTokens(
213         uint amountIn,
214         uint amountOutMin,
215         address[] calldata path,
216         address to,
217         uint deadline
218     ) external returns (uint[] memory amounts);
219     function swapTokensForExactTokens(
220         uint amountOut,
221         uint amountInMax,
222         address[] calldata path,
223         address to,
224         uint deadline
225     ) external returns (uint[] memory amounts);
226     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
227         external
228         payable
229         returns (uint[] memory amounts);
230     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
231         external
232         returns (uint[] memory amounts);
233     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
234         external
235         returns (uint[] memory amounts);
236     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
237         external
238         payable
239         returns (uint[] memory amounts);
240 
241     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
242     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
243     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
244     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
245     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
246 }
247 
248 interface IUniswapV2Router02 is IUniswapV2Router01 {
249     function removeLiquidityETHSupportingFeeOnTransferTokens(
250         address token,
251         uint liquidity,
252         uint amountTokenMin,
253         uint amountETHMin,
254         address to,
255         uint deadline
256     ) external returns (uint amountETH);
257     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
258         address token,
259         uint liquidity,
260         uint amountTokenMin,
261         uint amountETHMin,
262         address to,
263         uint deadline,
264         bool approveMax, uint8 v, bytes32 r, bytes32 s
265     ) external returns (uint amountETH);
266 
267     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
268         uint amountIn,
269         uint amountOutMin,
270         address[] calldata path,
271         address to,
272         uint deadline
273     ) external;
274     function swapExactETHForTokensSupportingFeeOnTransferTokens(
275         uint amountOutMin,
276         address[] calldata path,
277         address to,
278         uint deadline
279     ) external payable;
280     function swapExactTokensForETHSupportingFeeOnTransferTokens(
281         uint amountIn,
282         uint amountOutMin,
283         address[] calldata path,
284         address to,
285         uint deadline
286     ) external;
287 }
288 
289 interface IUniswapV2Pair {
290     event Approval(address indexed owner, address indexed spender, uint value);
291     event Transfer(address indexed from, address indexed to, uint value);
292 
293     function name() external pure returns (string memory);
294     function symbol() external pure returns (string memory);
295     function decimals() external pure returns (uint8);
296     function totalSupply() external view returns (uint);
297     function balanceOf(address owner) external view returns (uint);
298     function allowance(address owner, address spender) external view returns (uint);
299 
300     function approve(address spender, uint value) external returns (bool);
301     function transfer(address to, uint value) external returns (bool);
302     function transferFrom(address from, address to, uint value) external returns (bool);
303 
304     function DOMAIN_SEPARATOR() external view returns (bytes32);
305     function PERMIT_TYPEHASH() external pure returns (bytes32);
306     function nonces(address owner) external view returns (uint);
307 
308     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
309 
310     event Mint(address indexed sender, uint amount0, uint amount1);
311     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
312     event Swap(
313         address indexed sender,
314         uint amount0In,
315         uint amount1In,
316         uint amount0Out,
317         uint amount1Out,
318         address indexed to
319     );
320     event Sync(uint112 reserve0, uint112 reserve1);
321 
322     function MINIMUM_LIQUIDITY() external pure returns (uint);
323     function factory() external view returns (address);
324     function token0() external view returns (address);
325     function token1() external view returns (address);
326     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
327     function price0CumulativeLast() external view returns (uint);
328     function price1CumulativeLast() external view returns (uint);
329     function kLast() external view returns (uint);
330 
331     function mint(address to) external returns (uint liquidity);
332     function burn(address to) external returns (uint amount0, uint amount1);
333     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
334     function skim(address to) external;
335     function sync() external;
336 
337     function initialize(address, address) external;
338 }
339 
340 interface IUniswapV2Factory {
341     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
342 
343     function feeTo() external view returns (address);
344     function feeToSetter() external view returns (address);
345     function migrator() external view returns (address);
346 
347     function getPair(address tokenA, address tokenB) external view returns (address pair);
348     function allPairs(uint) external view returns (address pair);
349     function allPairsLength() external view returns (uint);
350 
351     function createPair(address tokenA, address tokenB) external returns (address pair);
352 
353     function setFeeTo(address) external;
354     function setFeeToSetter(address) external;
355     function setMigrator(address) external;
356 }
357 
358 /**
359  * @dev Contract module that helps prevent reentrant calls to a function.
360  *
361  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
362  * available, which can be applied to functions to make sure there are no nested
363  * (reentrant) calls to them.
364  *
365  * Note that because there is a single `nonReentrant` guard, functions marked as
366  * `nonReentrant` may not call one another. This can be worked around by making
367  * those functions `private`, and then adding `external` `nonReentrant` entry
368  * points to them.
369  *
370  * TIP: If you would like to learn more about reentrancy and alternative ways
371  * to protect against it, check out our blog post
372  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
373  */
374 contract ReentrancyGuard {
375     // Booleans are more expensive than uint256 or any type that takes up a full
376     // word because each write operation emits an extra SLOAD to first read the
377     // slot's contents, replace the bits taken up by the boolean, and then write
378     // back. This is the compiler's defense against contract upgrades and
379     // pointer aliasing, and it cannot be disabled.
380 
381     // The values being non-zero value makes deployment a bit more expensive,
382     // but in exchange the refund on every call to nonReentrant will be lower in
383     // amount. Since refunds are capped to a percentage of the total
384     // transaction's gas, it is best to keep them low in cases like this one, to
385     // increase the likelihood of the full refund coming into effect.
386     uint256 private constant _NOT_ENTERED = 1;
387     uint256 private constant _ENTERED = 2;
388 
389     uint256 private _status;
390 
391     constructor () internal {
392         _status = _NOT_ENTERED;
393     }
394 
395     /**
396      * @dev Prevents a contract from calling itself, directly or indirectly.
397      * Calling a `nonReentrant` function from another `nonReentrant`
398      * function is not supported. It is possible to prevent this from happening
399      * by making the `nonReentrant` function external, and make it call a
400      * `private` function that does the actual work.
401      */
402     modifier nonReentrant() {
403         // On the first call to nonReentrant, _notEntered will be true
404         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
405 
406         // Any calls to nonReentrant after this point will fail
407         _status = _ENTERED;
408 
409         _;
410 
411         // By storing the original value once again, a refund is triggered (see
412         // https://eips.ethereum.org/EIPS/eip-2200)
413         _status = _NOT_ENTERED;
414     }
415 }
416 
417 /**
418  * @dev Standard math utilities missing in the Solidity language.
419  */
420 library Math {
421     /**
422      * @dev Returns the largest of two numbers.
423      */
424     function max(uint256 a, uint256 b) internal pure returns (uint256) {
425         return a >= b ? a : b;
426     }
427 
428     /**
429      * @dev Returns the smallest of two numbers.
430      */
431     function min(uint256 a, uint256 b) internal pure returns (uint256) {
432         return a < b ? a : b;
433     }
434 
435     /**
436      * @dev Returns the average of two numbers. The result is rounded towards
437      * zero.
438      */
439     function average(uint256 a, uint256 b) internal pure returns (uint256) {
440         // (a + b) / 2 can overflow, so we distribute
441         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
442     }
443 }
444 
445 library Address {
446     /**
447      * @dev Returns true if `account` is a contract.
448      *
449      * [IMPORTANT]
450      * ====
451      * It is unsafe to assume that an address for which this function returns
452      * false is an externally-owned account (EOA) and not a contract.
453      *
454      * Among others, `isContract` will return false for the following
455      * types of addresses:
456      *
457      *  - an externally-owned account
458      *  - a contract in construction
459      *  - an address where a contract will be created
460      *  - an address where a contract lived, but was destroyed
461      * ====
462      */
463     function isContract(address account) internal view returns (bool) {
464         // This method relies in extcodesize, which returns 0 for contracts in
465         // construction, since the code is only stored at the end of the
466         // constructor execution.
467 
468         uint256 size;
469         // solhint-disable-next-line no-inline-assembly
470         assembly { size := extcodesize(account) }
471         return size > 0;
472     }
473 
474     /**
475      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
476      * `recipient`, forwarding all available gas and reverting on errors.
477      *
478      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
479      * of certain opcodes, possibly making contracts go over the 2300 gas limit
480      * imposed by `transfer`, making them unable to receive funds via
481      * `transfer`. {sendValue} removes this limitation.
482      *
483      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
484      *
485      * IMPORTANT: because control is transferred to `recipient`, care must be
486      * taken to not create reentrancy vulnerabilities. Consider using
487      * {ReentrancyGuard} or the
488      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
489      */
490     function sendValue(address payable recipient, uint256 amount) internal {
491         require(address(this).balance >= amount, "Address: insufficient balance");
492 
493         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
494         (bool success, ) = recipient.call{ value: amount }("");
495         require(success, "Address: unable to send value, recipient may have reverted");
496     }
497 
498     /**
499      * @dev Performs a Solidity function call using a low level `call`. A
500      * plain`call` is an unsafe replacement for a function call: use this
501      * function instead.
502      *
503      * If `target` reverts with a revert reason, it is bubbled up by this
504      * function (like regular Solidity function calls).
505      *
506      * Returns the raw returned data. To convert to the expected return value,
507      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
508      *
509      * Requirements:
510      *
511      * - `target` must be a contract.
512      * - calling `target` with `data` must not revert.
513      *
514      * _Available since v3.1._
515      */
516     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
517       return functionCall(target, data, "Address: low-level call failed");
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
522      * `errorMessage` as a fallback revert reason when `target` reverts.
523      *
524      * _Available since v3.1._
525      */
526     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
527         return _functionCallWithValue(target, data, 0, errorMessage);
528     }
529 
530     /**
531      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
532      * but also transferring `value` wei to `target`.
533      *
534      * Requirements:
535      *
536      * - the calling contract must have an ETH balance of at least `value`.
537      * - the called Solidity function must be `payable`.
538      *
539      * _Available since v3.1._
540      */
541     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
542         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
543     }
544 
545     /**
546      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
547      * with `errorMessage` as a fallback revert reason when `target` reverts.
548      *
549      * _Available since v3.1._
550      */
551     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
552         require(address(this).balance >= value, "Address: insufficient balance for call");
553         return _functionCallWithValue(target, data, value, errorMessage);
554     }
555 
556     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
557         require(isContract(target), "Address: call to non-contract");
558 
559         // solhint-disable-next-line avoid-low-level-calls
560         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
561         if (success) {
562             return returndata;
563         } else {
564             // Look for revert reason and bubble it up if present
565             if (returndata.length > 0) {
566                 // The easiest way to bubble the revert reason is using memory via assembly
567 
568                 // solhint-disable-next-line no-inline-assembly
569                 assembly {
570                     let returndata_size := mload(returndata)
571                     revert(add(32, returndata), returndata_size)
572                 }
573             } else {
574                 revert(errorMessage);
575             }
576         }
577     }
578 }
579 
580 /**
581  * @dev Wrappers over Solidity's arithmetic operations with added overflow
582  * checks.
583  *
584  * Arithmetic operations in Solidity wrap on overflow. This can easily result
585  * in bugs, because programmers usually assume that an overflow raises an
586  * error, which is the standard behavior in high level programming languages.
587  * `SafeMath` restores this intuition by reverting the transaction when an
588  * operation overflows.
589  *
590  * Using this library instead of the unchecked operations eliminates an entire
591  * class of bugs, so it's recommended to use it always.
592  */
593 library SafeMath {
594     /**
595      * @dev Returns the addition of two unsigned integers, reverting on
596      * overflow.
597      *
598      * Counterpart to Solidity's `+` operator.
599      *
600      * Requirements:
601      *
602      * - Addition cannot overflow.
603      */
604     function add(uint256 a, uint256 b) internal pure returns (uint256) {
605         uint256 c = a + b;
606         require(c >= a, "SafeMath: addition overflow");
607 
608         return c;
609     }
610 
611     /**
612      * @dev Returns the subtraction of two unsigned integers, reverting on
613      * overflow (when the result is negative).
614      *
615      * Counterpart to Solidity's `-` operator.
616      *
617      * Requirements:
618      *
619      * - Subtraction cannot overflow.
620      */
621     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
622         return sub(a, b, "SafeMath: subtraction overflow");
623     }
624 
625     /**
626      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
627      * overflow (when the result is negative).
628      *
629      * Counterpart to Solidity's `-` operator.
630      *
631      * Requirements:
632      *
633      * - Subtraction cannot overflow.
634      */
635     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
636         require(b <= a, errorMessage);
637         uint256 c = a - b;
638 
639         return c;
640     }
641 
642     /**
643      * @dev Returns the multiplication of two unsigned integers, reverting on
644      * overflow.
645      *
646      * Counterpart to Solidity's `*` operator.
647      *
648      * Requirements:
649      *
650      * - Multiplication cannot overflow.
651      */
652     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
653         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
654         // benefit is lost if 'b' is also tested.
655         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
656         if (a == 0) {
657             return 0;
658         }
659 
660         uint256 c = a * b;
661         require(c / a == b, "SafeMath: multiplication overflow");
662 
663         return c;
664     }
665 
666     /**
667      * @dev Returns the integer division of two unsigned integers. Reverts on
668      * division by zero. The result is rounded towards zero.
669      *
670      * Counterpart to Solidity's `/` operator. Note: this function uses a
671      * `revert` opcode (which leaves remaining gas untouched) while Solidity
672      * uses an invalid opcode to revert (consuming all remaining gas).
673      *
674      * Requirements:
675      *
676      * - The divisor cannot be zero.
677      */
678     function div(uint256 a, uint256 b) internal pure returns (uint256) {
679         return div(a, b, "SafeMath: division by zero");
680     }
681 
682     /**
683      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
684      * division by zero. The result is rounded towards zero.
685      *
686      * Counterpart to Solidity's `/` operator. Note: this function uses a
687      * `revert` opcode (which leaves remaining gas untouched) while Solidity
688      * uses an invalid opcode to revert (consuming all remaining gas).
689      *
690      * Requirements:
691      *
692      * - The divisor cannot be zero.
693      */
694     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
695         require(b > 0, errorMessage);
696         uint256 c = a / b;
697         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
698 
699         return c;
700     }
701 
702     /**
703      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
704      * Reverts when dividing by zero.
705      *
706      * Counterpart to Solidity's `%` operator. This function uses a `revert`
707      * opcode (which leaves remaining gas untouched) while Solidity uses an
708      * invalid opcode to revert (consuming all remaining gas).
709      *
710      * Requirements:
711      *
712      * - The divisor cannot be zero.
713      */
714     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
715         return mod(a, b, "SafeMath: modulo by zero");
716     }
717 
718     /**
719      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
720      * Reverts with custom message when dividing by zero.
721      *
722      * Counterpart to Solidity's `%` operator. This function uses a `revert`
723      * opcode (which leaves remaining gas untouched) while Solidity uses an
724      * invalid opcode to revert (consuming all remaining gas).
725      *
726      * Requirements:
727      *
728      * - The divisor cannot be zero.
729      */
730     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
731         require(b != 0, errorMessage);
732         return a % b;
733     }
734 }
735 
736 library MathUtils {
737     using SafeMath for uint256;
738 
739     /// @notice Calculates the square root of a given value.
740     function sqrt(uint256 x) internal pure returns (uint256 y) {
741         uint256 z = (x + 1) / 2;
742         y = x;
743         while (z < y) {
744             y = z;
745             z = (x / z + z) / 2;
746         }
747     }
748 
749     /// @notice Rounds a division result.
750     function roundedDiv(uint256 a, uint256 b) internal pure returns (uint256) {
751         require(b > 0, 'div by 0');
752 
753         uint256 halfB = (b.mod(2) == 0) ? (b.div(2)) : (b.div(2).add(1));
754         return (a.mod(b) >= halfB) ? (a.div(b).add(1)) : (a.div(b));
755     }
756 }
757 
758 interface IUniswapV2ERC20 {
759     event Approval(address indexed owner, address indexed spender, uint value);
760     event Transfer(address indexed from, address indexed to, uint value);
761 
762     function name() external pure returns (string memory);
763     function symbol() external pure returns (string memory);
764     function decimals() external pure returns (uint8);
765     function totalSupply() external view returns (uint);
766     function balanceOf(address owner) external view returns (uint);
767     function allowance(address owner, address spender) external view returns (uint);
768 
769     function approve(address spender, uint value) external returns (bool);
770     function transfer(address to, uint value) external returns (bool);
771     function transferFrom(address from, address to, uint value) external returns (bool);
772 
773     function DOMAIN_SEPARATOR() external view returns (bytes32);
774     function PERMIT_TYPEHASH() external pure returns (bytes32);
775     function nonces(address owner) external view returns (uint);
776 
777     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
778 }
779 
780 interface IUniswapV2Callee {
781     function uniswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external;
782 }
783 
784 interface IERC20Uniswap {
785     event Approval(address indexed owner, address indexed spender, uint value);
786     event Transfer(address indexed from, address indexed to, uint value);
787 
788     function name() external view returns (string memory);
789     function symbol() external view returns (string memory);
790     function decimals() external view returns (uint8);
791     function totalSupply() external view returns (uint);
792     function balanceOf(address owner) external view returns (uint);
793     function allowance(address owner, address spender) external view returns (uint);
794 
795     function approve(address spender, uint value) external returns (bool);
796     function transfer(address to, uint value) external returns (bool);
797     function transferFrom(address from, address to, uint value) external returns (bool);
798 }
799 
800 /*
801  * @dev Provides information about the current execution context, including the
802  * sender of the transaction and its data. While these are generally available
803  * via msg.sender and msg.data, they should not be accessed in such a direct
804  * manner, since when dealing with GSN meta-transactions the account sending and
805  * paying for execution may not be the actual sender (as far as an application
806  * is concerned).
807  *
808  * This contract is only required for intermediate, library-like contracts.
809  */
810 abstract contract Context {
811     function _msgSender() internal view virtual returns (address payable) {
812         return msg.sender;
813     }
814 
815     function _msgData() internal view virtual returns (bytes memory) {
816         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
817         return msg.data;
818     }
819 }
820 
821 /**
822  * @dev Implementation of the {IERC20} interface.
823  *
824  * This implementation is agnostic to the way tokens are created. This means
825  * that a supply mechanism has to be added in a derived contract using {_mint}.
826  * For a generic mechanism see {ERC20PresetMinterPauser}.
827  *
828  * TIP: For a detailed writeup see our guide
829  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
830  * to implement supply mechanisms].
831  *
832  * We have followed general OpenZeppelin guidelines: functions revert instead
833  * of returning `false` on failure. This behavior is nonetheless conventional
834  * and does not conflict with the expectations of ERC20 applications.
835  *
836  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
837  * This allows applications to reconstruct the allowance for all accounts just
838  * by listening to said events. Other implementations of the EIP may not emit
839  * these events, as it isn't required by the specification.
840  *
841  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
842  * functions have been added to mitigate the well-known issues around setting
843  * allowances. See {IERC20-approve}.
844  */
845 contract ERC20 is Context, IERC20 {
846     using SafeMath for uint256;
847     using Address for address;
848 
849     mapping (address => uint256) private _balances;
850 
851     mapping (address => mapping (address => uint256)) private _allowances;
852 
853     uint256 private _totalSupply;
854 
855     string private _name;
856     string private _symbol;
857     uint8 private _decimals;
858 
859     /**
860      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
861      * a default value of 18.
862      *
863      * To select a different value for {decimals}, use {_setupDecimals}.
864      *
865      * All three of these values are immutable: they can only be set once during
866      * construction.
867      */
868     constructor (string memory name, string memory symbol) public {
869         _name = name;
870         _symbol = symbol;
871         _decimals = 18;
872     }
873 
874     /**
875      * @dev Returns the name of the token.
876      */
877     function name() public view returns (string memory) {
878         return _name;
879     }
880 
881     /**
882      * @dev Returns the symbol of the token, usually a shorter version of the
883      * name.
884      */
885     function symbol() public view returns (string memory) {
886         return _symbol;
887     }
888 
889     /**
890      * @dev Returns the number of decimals used to get its user representation.
891      * For example, if `decimals` equals `2`, a balance of `505` tokens should
892      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
893      *
894      * Tokens usually opt for a value of 18, imitating the relationship between
895      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
896      * called.
897      *
898      * NOTE: This information is only used for _display_ purposes: it in
899      * no way affects any of the arithmetic of the contract, including
900      * {IERC20-balanceOf} and {IERC20-transfer}.
901      */
902     function decimals() public view returns (uint8) {
903         return _decimals;
904     }
905 
906     /**
907      * @dev See {IERC20-totalSupply}.
908      */
909     function totalSupply() public view override returns (uint256) {
910         return _totalSupply;
911     }
912 
913     /**
914      * @dev See {IERC20-balanceOf}.
915      */
916     function balanceOf(address account) public view override returns (uint256) {
917         return _balances[account];
918     }
919 
920     /**
921      * @dev See {IERC20-transfer}.
922      *
923      * Requirements:
924      *
925      * - `recipient` cannot be the zero address.
926      * - the caller must have a balance of at least `amount`.
927      */
928     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
929         _transfer(_msgSender(), recipient, amount);
930         return true;
931     }
932 
933     /**
934      * @dev See {IERC20-allowance}.
935      */
936     function allowance(address owner, address spender) public view virtual override returns (uint256) {
937         return _allowances[owner][spender];
938     }
939 
940     /**
941      * @dev See {IERC20-approve}.
942      *
943      * Requirements:
944      *
945      * - `spender` cannot be the zero address.
946      */
947     function approve(address spender, uint256 amount) public virtual override returns (bool) {
948         _approve(_msgSender(), spender, amount);
949         return true;
950     }
951 
952     /**
953      * @dev See {IERC20-transferFrom}.
954      *
955      * Emits an {Approval} event indicating the updated allowance. This is not
956      * required by the EIP. See the note at the beginning of {ERC20};
957      *
958      * Requirements:
959      * - `sender` and `recipient` cannot be the zero address.
960      * - `sender` must have a balance of at least `amount`.
961      * - the caller must have allowance for ``sender``'s tokens of at least
962      * `amount`.
963      */
964     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
965         _transfer(sender, recipient, amount);
966         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
967         return true;
968     }
969 
970     /**
971      * @dev Atomically increases the allowance granted to `spender` by the caller.
972      *
973      * This is an alternative to {approve} that can be used as a mitigation for
974      * problems described in {IERC20-approve}.
975      *
976      * Emits an {Approval} event indicating the updated allowance.
977      *
978      * Requirements:
979      *
980      * - `spender` cannot be the zero address.
981      */
982     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
983         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
984         return true;
985     }
986 
987     /**
988      * @dev Atomically decreases the allowance granted to `spender` by the caller.
989      *
990      * This is an alternative to {approve} that can be used as a mitigation for
991      * problems described in {IERC20-approve}.
992      *
993      * Emits an {Approval} event indicating the updated allowance.
994      *
995      * Requirements:
996      *
997      * - `spender` cannot be the zero address.
998      * - `spender` must have allowance for the caller of at least
999      * `subtractedValue`.
1000      */
1001     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1002         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1003         return true;
1004     }
1005 
1006     /**
1007      * @dev Moves tokens `amount` from `sender` to `recipient`.
1008      *
1009      * This is internal function is equivalent to {transfer}, and can be used to
1010      * e.g. implement automatic token fees, slashing mechanisms, etc.
1011      *
1012      * Emits a {Transfer} event.
1013      *
1014      * Requirements:
1015      *
1016      * - `sender` cannot be the zero address.
1017      * - `recipient` cannot be the zero address.
1018      * - `sender` must have a balance of at least `amount`.
1019      */
1020     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1021         require(sender != address(0), "ERC20: transfer from the zero address");
1022         require(recipient != address(0), "ERC20: transfer to the zero address");
1023 
1024         _beforeTokenTransfer(sender, recipient, amount);
1025 
1026         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1027         _balances[recipient] = _balances[recipient].add(amount);
1028         emit Transfer(sender, recipient, amount);
1029     }
1030 
1031     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1032      * the total supply.
1033      *
1034      * Emits a {Transfer} event with `from` set to the zero address.
1035      *
1036      * Requirements
1037      *
1038      * - `to` cannot be the zero address.
1039      */
1040     function _mint(address account, uint256 amount) internal virtual {
1041         require(account != address(0), "ERC20: mint to the zero address");
1042 
1043         _beforeTokenTransfer(address(0), account, amount);
1044 
1045         _totalSupply = _totalSupply.add(amount);
1046         _balances[account] = _balances[account].add(amount);
1047         emit Transfer(address(0), account, amount);
1048     }
1049 
1050     /**
1051      * @dev Destroys `amount` tokens from `account`, reducing the
1052      * total supply.
1053      *
1054      * Emits a {Transfer} event with `to` set to the zero address.
1055      *
1056      * Requirements
1057      *
1058      * - `account` cannot be the zero address.
1059      * - `account` must have at least `amount` tokens.
1060      */
1061     function _burn(address account, uint256 amount) internal virtual {
1062         require(account != address(0), "ERC20: burn from the zero address");
1063 
1064         _beforeTokenTransfer(account, address(0), amount);
1065 
1066         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1067         _totalSupply = _totalSupply.sub(amount);
1068         emit Transfer(account, address(0), amount);
1069     }
1070 
1071     /**
1072      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1073      *
1074      * This internal function is equivalent to `approve`, and can be used to
1075      * e.g. set automatic allowances for certain subsystems, etc.
1076      *
1077      * Emits an {Approval} event.
1078      *
1079      * Requirements:
1080      *
1081      * - `owner` cannot be the zero address.
1082      * - `spender` cannot be the zero address.
1083      */
1084     function _approve(address owner, address spender, uint256 amount) internal virtual {
1085         require(owner != address(0), "ERC20: approve from the zero address");
1086         require(spender != address(0), "ERC20: approve to the zero address");
1087 
1088         _allowances[owner][spender] = amount;
1089         emit Approval(owner, spender, amount);
1090     }
1091 
1092     /**
1093      * @dev Sets {decimals} to a value other than the default one of 18.
1094      *
1095      * WARNING: This function should only be called from the constructor. Most
1096      * applications that interact with token contracts will not expect
1097      * {decimals} to ever change, and may work incorrectly if it does.
1098      */
1099     function _setupDecimals(uint8 decimals_) internal {
1100         _decimals = decimals_;
1101     }
1102 
1103     /**
1104      * @dev Hook that is called before any transfer of tokens. This includes
1105      * minting and burning.
1106      *
1107      * Calling conditions:
1108      *
1109      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1110      * will be to transferred to `to`.
1111      * - when `from` is zero, `amount` tokens will be minted for `to`.
1112      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1113      * - `from` and `to` are never both zero.
1114      *
1115      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1116      */
1117     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1118 }
1119 
1120 contract WETH9 {
1121     string public name = "Wrapped Ether";
1122     string public symbol = "WETH";
1123     uint8  public decimals = 18;
1124 
1125     event  Approval(address indexed src, address indexed guy, uint wad);
1126     event  Transfer(address indexed src, address indexed dst, uint wad);
1127     event  Deposit(address indexed dst, uint wad);
1128     event  Withdrawal(address indexed src, uint wad);
1129 
1130     mapping(address => uint)                       public  balanceOf;
1131     mapping(address => mapping(address => uint))  public  allowance;
1132 
1133     receive() external payable {
1134         deposit();
1135     }
1136 
1137     function deposit() public payable {
1138         balanceOf[msg.sender] += msg.value;
1139         Deposit(msg.sender, msg.value);
1140     }
1141 
1142     function withdraw(uint wad) public {
1143         require(balanceOf[msg.sender] >= wad);
1144         balanceOf[msg.sender] -= wad;
1145         msg.sender.transfer(wad);
1146         Withdrawal(msg.sender, wad);
1147     }
1148 
1149     function totalSupply() public view returns (uint) {
1150         return address(this).balance;
1151     }
1152 
1153     function approve(address guy, uint wad) public returns (bool) {
1154         allowance[msg.sender][guy] = wad;
1155         Approval(msg.sender, guy, wad);
1156         return true;
1157     }
1158 
1159     function transfer(address dst, uint wad) public returns (bool) {
1160         return transferFrom(msg.sender, dst, wad);
1161     }
1162 
1163     function transferFrom(address src, address dst, uint wad)
1164     public
1165     returns (bool)
1166     {
1167         require(balanceOf[src] >= wad);
1168 
1169         if (src != msg.sender && allowance[src][msg.sender] != uint(- 1)) {
1170             require(allowance[src][msg.sender] >= wad);
1171             allowance[src][msg.sender] -= wad;
1172         }
1173 
1174         balanceOf[src] -= wad;
1175         balanceOf[dst] += wad;
1176 
1177         Transfer(src, dst, wad);
1178 
1179         return true;
1180     }
1181 }
1182 
1183 contract twis is ERC20 {
1184 
1185     address minter;
1186 
1187     modifier onlyMinter {
1188         require(msg.sender == minter, 'Only minter can call this function.');
1189         _;
1190     }
1191 
1192     constructor(address _minter) public ERC20('Twister', 'TWIS') {
1193         minter = _minter;
1194     }
1195 
1196     function mint(address account, uint256 amount) external onlyMinter {
1197         _mint(account, amount);
1198     }
1199 
1200     function burn(address account, uint256 amount) external onlyMinter {
1201         _burn(account, amount);
1202     }
1203 
1204 }
1205 
1206 
1207 contract Twister is ReentrancyGuard {
1208 
1209     using SafeMath for uint256;
1210     using Address for address;
1211     using SafeERC20 for IERC20;
1212 
1213     event Staked(address indexed from, uint256 amountETH, uint256 amountLP);
1214     event Withdrawn(address indexed to, uint256 amountETH, uint256 amountLP);
1215     event Claimed(address indexed to, uint256 amount);
1216     event Halving(uint256 amount);
1217     event Received(address indexed from, uint256 amount);
1218 
1219     twis public token;
1220     IUniswapV2Factory public factory;
1221     IUniswapV2Router02 public router;
1222     address public weth;
1223     address payable public treasury;
1224     address public pairAddress;
1225 
1226     struct AccountInfo {
1227         // Staked LP token balance
1228         uint256 balance;
1229         uint256 peakBalance;
1230         uint256 withdrawTimestamp;
1231         uint256 reward;
1232         uint256 rewardPerTokenPaid;
1233     }
1234     mapping(address => AccountInfo) public accountInfos;
1235 
1236     // Staked LP token total supply
1237     uint256 private _totalSupply = 0;
1238 
1239     uint256 public constant HALVING_DURATION = 7 days;
1240     uint256 public rewardAllocation = 1500 * 1e18;
1241     uint256 public halvingTimestamp = 0;
1242     uint256 public lastUpdateTimestamp = 0;
1243 
1244     uint256 public rewardRate = 0;
1245     uint256 public rewardPerTokenStored = 0;
1246 
1247     // Farming will be open on this timestamp
1248     // Date and time (GMT): Monday, October 26, 2020 3:00:00 PM
1249     uint256 public farmingStartTimestamp = 1604635200;
1250     bool public farmingStarted = false;
1251 
1252     // Max 10% / day LP withdraw
1253     uint256 public constant WITHDRAW_LIMIT = 10;
1254 
1255     // Burn address
1256     address constant BURN_ADDRESS = 0x000000000000000000000000000000000000dEaD;
1257 
1258     // Dev decided to launch without whitelist but since it has been coded and tested, so dev will leave it here.
1259     // Whitelisted address
1260     mapping (address => bool) public whitelists;
1261     // Whitelist deposited balance
1262     mapping (address => uint256) public whitelistBalance;
1263     // End period for whitelist advantage
1264     uint256 public whitelistEndTimestamp = 0;
1265     // Max stake for whitelist
1266     uint256 public constant WHITELIST_STAKE_LIMIT = 3 ether;
1267     // Whitelist advantage duration (reduced to 1 minutes since we dont have whitelist)
1268     uint256 public constant WHITELIST_DURATION = 1 minutes;
1269 
1270     constructor(address _routerAddress, address[] memory _whitelists) public {
1271         token = new twis(address(this));
1272 
1273         router = IUniswapV2Router02(_routerAddress);
1274         factory = IUniswapV2Factory(router.factory());
1275         weth = router.WETH();
1276         treasury = msg.sender;
1277         pairAddress = factory.createPair(address(token), weth);
1278 
1279         // Calc reward rate
1280         rewardRate = rewardAllocation.div(HALVING_DURATION);
1281 
1282         // Init whitelist
1283         _setupWhitelists(_whitelists);
1284         whitelistEndTimestamp = farmingStartTimestamp.add(WHITELIST_DURATION);
1285     }
1286 
1287     receive() external payable {
1288         emit Received(msg.sender, msg.value);
1289     }
1290 
1291     function stake() external payable nonReentrant {
1292         _checkFarming();
1293         _updateReward(msg.sender);
1294         _halving();
1295 
1296         require(msg.value > 0, 'Cannot stake 0');
1297         require(!address(msg.sender).isContract(), 'Please use your individual account');
1298 
1299         // If we are still in whitelist duration
1300         if (whitelistEndTimestamp >= block.timestamp) {
1301             require(whitelists[msg.sender], 'Only whitelisted address can stake right now');
1302             whitelistBalance[msg.sender] = whitelistBalance[msg.sender].add(msg.value);
1303             require(whitelistBalance[msg.sender] <= WHITELIST_STAKE_LIMIT, 'Cannot stake more than allowed in whitelist period');
1304         }
1305 
1306         // 10% compensation fee
1307         // since dev doesn't hold any initial supply
1308         uint256 fee = msg.value.div(10);
1309         uint256 amount = msg.value.sub(fee);
1310         treasury.transfer(fee);
1311 
1312         uint256 ethAmount = IERC20(weth).balanceOf(pairAddress);
1313         uint256 tokenAmount = IERC20(token).balanceOf(pairAddress);
1314 
1315         // If eth amount = 0 then set initial price to 1 eth = 2 twis
1316         uint256 amountTokenDesired = ethAmount == 0 ? (amount * 2) : amount.mul(tokenAmount).div(ethAmount);
1317         // Mint borrowed twis
1318         token.mint(address(this), amountTokenDesired);
1319 
1320         // Add liquidity in uniswap
1321         uint256 amountETHDesired = amount;
1322         IERC20(token).approve(address(router), amountTokenDesired);
1323         (,, uint256 liquidity) = router.addLiquidityETH{value : amountETHDesired}(address(token), amountTokenDesired, 1, 1, address(this), block.timestamp + 1 days);
1324 
1325         // Add LP token to total supply
1326         _totalSupply = _totalSupply.add(liquidity);
1327 
1328         // Add to balance
1329         accountInfos[msg.sender].balance = accountInfos[msg.sender].balance.add(liquidity);
1330         // Set peak balance
1331         if (accountInfos[msg.sender].balance > accountInfos[msg.sender].peakBalance) {
1332             accountInfos[msg.sender].peakBalance = accountInfos[msg.sender].balance;
1333         }
1334 
1335         // Set stake timestamp as withdraw timestamp
1336         // to prevent withdraw immediately after first staking
1337         if (accountInfos[msg.sender].withdrawTimestamp == 0) {
1338             accountInfos[msg.sender].withdrawTimestamp = block.timestamp;
1339         }
1340 
1341         emit Staked(msg.sender, msg.value, liquidity);
1342     }
1343 
1344     function withdraw() external nonReentrant {
1345         _checkFarming();
1346         _updateReward(msg.sender);
1347         _halving();
1348 
1349         require(accountInfos[msg.sender].withdrawTimestamp + 1 days <= block.timestamp, 'You must wait 1 day since your last withdraw or stake');
1350         require(accountInfos[msg.sender].balance > 0, 'Cannot withdraw 0');
1351 
1352         // Limit withdraw LP token
1353         uint256 amount = accountInfos[msg.sender].peakBalance.div(WITHDRAW_LIMIT);
1354         if (accountInfos[msg.sender].balance < amount) {
1355             amount = accountInfos[msg.sender].balance;
1356         }
1357 
1358         // Reduce total supply
1359         _totalSupply = _totalSupply.sub(amount);
1360         // Reduce balance
1361         accountInfos[msg.sender].balance = accountInfos[msg.sender].balance.sub(amount);
1362         // Set timestamp
1363         accountInfos[msg.sender].withdrawTimestamp = block.timestamp;
1364 
1365         // Remove liquidity in uniswap
1366         IERC20(pairAddress).approve(address(router), amount);
1367         (uint256 tokenAmount, uint256 ethAmount) = router.removeLiquidity(address(token), weth, amount, 0, 0, address(this), block.timestamp + 1 days);
1368 
1369         // Burn borrowed twis
1370         token.burn(address(this), tokenAmount);
1371         // Withdraw ETH and send to sender
1372         IWETH(weth).withdraw(ethAmount);
1373         msg.sender.transfer(ethAmount);
1374 
1375         emit Withdrawn(msg.sender, ethAmount, amount);
1376     }
1377 
1378     function claim() external nonReentrant {
1379         _checkFarming();
1380         _updateReward(msg.sender);
1381         _halving();
1382 
1383         uint256 reward = accountInfos[msg.sender].reward;
1384         require(reward > 0, 'There is no reward to claim');
1385 
1386         if (reward > 0) {
1387             // Reduce first
1388             accountInfos[msg.sender].reward = 0;
1389             // Apply tax
1390             uint256 taxDenominator = claimTaxDenominator();
1391             uint256 tax = taxDenominator > 0 ? reward.div(taxDenominator) : 0;
1392             uint256 net = reward.sub(tax);
1393 
1394             // Send reward
1395             token.mint(msg.sender, net);
1396             if (tax > 0) {
1397                 // Burn taxed token
1398                 token.mint(BURN_ADDRESS, tax);
1399             }
1400 
1401             emit Claimed(msg.sender, reward);
1402         }
1403     }
1404 
1405     function totalSupply() external view returns (uint256) {
1406         return _totalSupply;
1407     }
1408 
1409     function balanceOf(address account) external view returns (uint256) {
1410         return accountInfos[account].balance;
1411     }
1412 
1413     function burnedTokenAmount() public view returns (uint256) {
1414         return token.balanceOf(BURN_ADDRESS);
1415     }
1416 
1417     function rewardPerToken() public view returns (uint256) {
1418         if (_totalSupply == 0) {
1419             return rewardPerTokenStored;
1420         }
1421 
1422         return rewardPerTokenStored
1423         .add(
1424             lastRewardTimestamp()
1425             .sub(lastUpdateTimestamp)
1426             .mul(rewardRate)
1427             .mul(1e18)
1428             .div(_totalSupply)
1429         );
1430     }
1431 
1432     function lastRewardTimestamp() public view returns (uint256) {
1433         return Math.min(block.timestamp, halvingTimestamp);
1434     }
1435 
1436     function rewardEarned(address account) public view returns (uint256) {
1437         return accountInfos[account].balance.mul(
1438             rewardPerToken().sub(accountInfos[account].rewardPerTokenPaid)
1439         )
1440         .div(1e18)
1441         .add(accountInfos[account].reward);
1442     }
1443 
1444     // Token price in eth
1445     function tokenPrice() public view returns (uint256) {
1446         uint256 ethAmount = IERC20(weth).balanceOf(pairAddress);
1447         uint256 tokenAmount = IERC20(token).balanceOf(pairAddress);
1448         return tokenAmount > 0 ?
1449         // Current price
1450         ethAmount.mul(1e18).div(tokenAmount) :
1451         // Initial price
1452         (uint256(1e18).div(2));
1453     }
1454 
1455     function claimTaxDenominator() public view returns (uint256) {
1456         if (block.timestamp < farmingStartTimestamp + 1 days) {
1457             return 4;
1458         } else if (block.timestamp < farmingStartTimestamp + 2 days) {
1459             return 5;
1460         } else if (block.timestamp < farmingStartTimestamp + 3 days) {
1461             return 10;
1462         } else if (block.timestamp < farmingStartTimestamp + 4 days) {
1463             return 20;
1464         } else {
1465             return 0;
1466         }
1467     }
1468 
1469     function _updateReward(address account) internal {
1470         rewardPerTokenStored = rewardPerToken();
1471         lastUpdateTimestamp = lastRewardTimestamp();
1472         if (account != address(0)) {
1473             accountInfos[account].reward = rewardEarned(account);
1474             accountInfos[account].rewardPerTokenPaid = rewardPerTokenStored;
1475         }
1476     }
1477 
1478     // Do halving when timestamp reached
1479     function _halving() internal {
1480         if (block.timestamp >= halvingTimestamp) {
1481             rewardAllocation = rewardAllocation.div(2);
1482 
1483             rewardRate = rewardAllocation.div(HALVING_DURATION);
1484             halvingTimestamp = halvingTimestamp.add(HALVING_DURATION);
1485 
1486             _updateReward(msg.sender);
1487             emit Halving(rewardAllocation);
1488         }
1489     }
1490 
1491     // Check if farming is started
1492     function _checkFarming() internal {
1493         require(farmingStartTimestamp <= block.timestamp, 'Please wait until farming started');
1494         if (!farmingStarted) {
1495             farmingStarted = true;
1496             halvingTimestamp = block.timestamp.add(HALVING_DURATION);
1497             lastUpdateTimestamp = block.timestamp;
1498         }
1499     }
1500 
1501     function _setupWhitelists(address[] memory addresses) internal {
1502         for (uint256 i = 0; i < addresses.length; i++) {
1503             whitelists[addresses[i]] = true;
1504         }
1505     }
1506 }