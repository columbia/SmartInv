1 // SPDX-License-Identifier: MIT
2 
3 // ██╗     ██╗  █████╗  ██╗      ██╗  ██╗  █████╗  ██╗      ██╗       █████╗ 
4 // ╚██╗   ██╔╝ ██╔══██╗ ██║      ██║  ██║ ██╔══██╗ ██║      ██║      ██╔══██╗
5 //  ╚██╗ ██╔╝  ███████║ ██║      ███████║ ███████║ ██║      ██║      ███████║
6 //   ╚████╔╝   ██╔══██║ ██║      ██╔══██║ ██╔══██║ ██║      ██║      ██╔══██║
7 //    ╚██╔╝    ██║  ██║ ███████╗ ██║  ██║ ██║  ██║ ███████╗ ███████╗ ██║  ██║
8 //     ╚═╝     ╚═╝  ╚═╝ ╚══════╝ ╚═╝  ╚═╝ ╚═╝  ╚═╝ ╚══════╝ ╚══════╝ ╚═╝  ╚═╝
9 
10 //Telegram: https://t.me/chillhalla
11 //Website: https://valdao.org/
12 
13 pragma solidity >=0.6.12;
14 
15 /**
16  * @dev Interface of the ERC20 standard as defined in the EIP.
17  */
18  
19 interface IERC20 {
20     /**
21      * @dev Returns the amount of tokens in existence.
22      */
23     function totalSupply() external view returns (uint256);
24 
25     /**
26      * @dev Returns the amount of tokens owned by `account`.
27      */
28     function balanceOf(address account) external view returns (uint256);
29 
30     /**
31      * @dev Moves `amount` tokens from the caller's account to `recipient`.
32      *
33      * Returns a boolean value indicating whether the operation succeeded.
34      *
35      * Emits a {Transfer} event.
36      */
37     function transfer(address recipient, uint256 amount) external returns (bool);
38 
39     /**
40      * @dev Returns the remaining number of tokens that `spender` will be
41      * allowed to spend on behalf of `owner` through {transferFrom}. This is
42      * zero by default.
43      *
44      * This value changes when {approve} or {transferFrom} are called.
45      */
46     function allowance(address owner, address spender) external view returns (uint256);
47 
48     /**
49      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * IMPORTANT: Beware that changing an allowance with this method brings the risk
54      * that someone may use both the old and the new allowance by unfortunate
55      * transaction ordering. One possible solution to mitigate this race
56      * condition is to first reduce the spender's allowance to 0 and set the
57      * desired value afterwards:
58      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
59      *
60      * Emits an {Approval} event.
61      */
62     function approve(address spender, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Moves `amount` tokens from `sender` to `recipient` using the
66      * allowance mechanism. `amount` is then deducted from the caller's
67      * allowance.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * Emits a {Transfer} event.
72      */
73     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
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
90 /**
91  * @title SafeERC20
92  * @dev Wrappers around ERC20 operations that throw on failure (when the token
93  * contract returns false). Tokens that return no value (and instead revert or
94  * throw on failure) are also supported, non-reverting calls are assumed to be
95  * successful.
96  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
97  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
98  */
99 library SafeERC20 {
100     using SafeMath for uint256;
101     using Address for address;
102 
103     function safeTransfer(IERC20 token, address to, uint256 value) internal {
104         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
105     }
106 
107     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
108         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
109     }
110 
111     /**
112      * @dev Deprecated. This function has issues similar to the ones found in
113      * {IERC20-approve}, and its usage is discouraged.
114      *
115      * Whenever possible, use {safeIncreaseAllowance} and
116      * {safeDecreaseAllowance} instead.
117      */
118     function safeApprove(IERC20 token, address spender, uint256 value) internal {
119         // safeApprove should only be called when setting an initial allowance,
120         // or when resetting it to zero. To increase and decrease it, use
121         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
122         // solhint-disable-next-line max-line-length
123         require((value == 0) || (token.allowance(address(this), spender) == 0),
124             "SafeERC20: approve from non-zero to non-zero allowance"
125         );
126         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
127     }
128 
129     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
130         uint256 newAllowance = token.allowance(address(this), spender).add(value);
131         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
132     }
133 
134     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
135         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
136         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
137     }
138 
139     /**
140      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
141      * on the return value: the return value is optional (but if data is returned, it must not be false).
142      * @param token The token targeted by the call.
143      * @param data The call data (encoded using abi.encode or one of its variants).
144      */
145     function _callOptionalReturn(IERC20 token, bytes memory data) private {
146         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
147         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
148         // the target address contains contract code and also asserts for success in the low-level call.
149 
150         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
151         if (returndata.length > 0) { // Return data is optional
152             // solhint-disable-next-line max-line-length
153             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
154         }
155     }
156 }
157 
158 interface IWETH {
159     function deposit() external payable;
160     function transfer(address to, uint value) external returns (bool);
161     function withdraw(uint) external;
162 }
163 
164 interface IUniswapV2Router01 {
165     function factory() external pure returns (address);
166     function WETH() external pure returns (address);
167 
168     function addLiquidity(
169         address tokenA,
170         address tokenB,
171         uint amountADesired,
172         uint amountBDesired,
173         uint amountAMin,
174         uint amountBMin,
175         address to,
176         uint deadline
177     ) external returns (uint amountA, uint amountB, uint liquidity);
178     function addLiquidityETH(
179         address token,
180         uint amountTokenDesired,
181         uint amountTokenMin,
182         uint amountETHMin,
183         address to,
184         uint deadline
185     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
186     function removeLiquidity(
187         address tokenA,
188         address tokenB,
189         uint liquidity,
190         uint amountAMin,
191         uint amountBMin,
192         address to,
193         uint deadline
194     ) external returns (uint amountA, uint amountB);
195     function removeLiquidityETH(
196         address token,
197         uint liquidity,
198         uint amountTokenMin,
199         uint amountETHMin,
200         address to,
201         uint deadline
202     ) external returns (uint amountToken, uint amountETH);
203     function removeLiquidityWithPermit(
204         address tokenA,
205         address tokenB,
206         uint liquidity,
207         uint amountAMin,
208         uint amountBMin,
209         address to,
210         uint deadline,
211         bool approveMax, uint8 v, bytes32 r, bytes32 s
212     ) external returns (uint amountA, uint amountB);
213     function removeLiquidityETHWithPermit(
214         address token,
215         uint liquidity,
216         uint amountTokenMin,
217         uint amountETHMin,
218         address to,
219         uint deadline,
220         bool approveMax, uint8 v, bytes32 r, bytes32 s
221     ) external returns (uint amountToken, uint amountETH);
222     function swapExactTokensForTokens(
223         uint amountIn,
224         uint amountOutMin,
225         address[] calldata path,
226         address to,
227         uint deadline
228     ) external returns (uint[] memory amounts);
229     function swapTokensForExactTokens(
230         uint amountOut,
231         uint amountInMax,
232         address[] calldata path,
233         address to,
234         uint deadline
235     ) external returns (uint[] memory amounts);
236     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
237         external
238         payable
239         returns (uint[] memory amounts);
240     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
241         external
242         returns (uint[] memory amounts);
243     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
244         external
245         returns (uint[] memory amounts);
246     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
247         external
248         payable
249         returns (uint[] memory amounts);
250 
251     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
252     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
253     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
254     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
255     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
256 }
257 
258 interface IUniswapV2Router02 is IUniswapV2Router01 {
259     function removeLiquidityETHSupportingFeeOnTransferTokens(
260         address token,
261         uint liquidity,
262         uint amountTokenMin,
263         uint amountETHMin,
264         address to,
265         uint deadline
266     ) external returns (uint amountETH);
267     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
268         address token,
269         uint liquidity,
270         uint amountTokenMin,
271         uint amountETHMin,
272         address to,
273         uint deadline,
274         bool approveMax, uint8 v, bytes32 r, bytes32 s
275     ) external returns (uint amountETH);
276 
277     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
278         uint amountIn,
279         uint amountOutMin,
280         address[] calldata path,
281         address to,
282         uint deadline
283     ) external;
284     function swapExactETHForTokensSupportingFeeOnTransferTokens(
285         uint amountOutMin,
286         address[] calldata path,
287         address to,
288         uint deadline
289     ) external payable;
290     function swapExactTokensForETHSupportingFeeOnTransferTokens(
291         uint amountIn,
292         uint amountOutMin,
293         address[] calldata path,
294         address to,
295         uint deadline
296     ) external;
297 }
298 
299 interface IUniswapV2Pair {
300     event Approval(address indexed owner, address indexed spender, uint value);
301     event Transfer(address indexed from, address indexed to, uint value);
302 
303     function name() external pure returns (string memory);
304     function symbol() external pure returns (string memory);
305     function decimals() external pure returns (uint8);
306     function totalSupply() external view returns (uint);
307     function balanceOf(address owner) external view returns (uint);
308     function allowance(address owner, address spender) external view returns (uint);
309 
310     function approve(address spender, uint value) external returns (bool);
311     function transfer(address to, uint value) external returns (bool);
312     function transferFrom(address from, address to, uint value) external returns (bool);
313 
314     function DOMAIN_SEPARATOR() external view returns (bytes32);
315     function PERMIT_TYPEHASH() external pure returns (bytes32);
316     function nonces(address owner) external view returns (uint);
317 
318     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
319 
320     event Mint(address indexed sender, uint amount0, uint amount1);
321     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
322     event Swap(
323         address indexed sender,
324         uint amount0In,
325         uint amount1In,
326         uint amount0Out,
327         uint amount1Out,
328         address indexed to
329     );
330     event Sync(uint112 reserve0, uint112 reserve1);
331 
332     function MINIMUM_LIQUIDITY() external pure returns (uint);
333     function factory() external view returns (address);
334     function token0() external view returns (address);
335     function token1() external view returns (address);
336     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
337     function price0CumulativeLast() external view returns (uint);
338     function price1CumulativeLast() external view returns (uint);
339     function kLast() external view returns (uint);
340 
341     function mint(address to) external returns (uint liquidity);
342     function burn(address to) external returns (uint amount0, uint amount1);
343     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
344     function skim(address to) external;
345     function sync() external;
346 
347     function initialize(address, address) external;
348 }
349 
350 interface IUniswapV2Factory {
351     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
352 
353     function feeTo() external view returns (address);
354     function feeToSetter() external view returns (address);
355     function migrator() external view returns (address);
356 
357     function getPair(address tokenA, address tokenB) external view returns (address pair);
358     function allPairs(uint) external view returns (address pair);
359     function allPairsLength() external view returns (uint);
360 
361     function createPair(address tokenA, address tokenB) external returns (address pair);
362 
363     function setFeeTo(address) external;
364     function setFeeToSetter(address) external;
365     function setMigrator(address) external;
366 }
367 
368 /**
369  * @dev Contract module that helps prevent reentrant calls to a function.
370  *
371  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
372  * available, which can be applied to functions to make sure there are no nested
373  * (reentrant) calls to them.
374  *
375  * Note that because there is a single `nonReentrant` guard, functions marked as
376  * `nonReentrant` may not call one another. This can be worked around by making
377  * those functions `private`, and then adding `external` `nonReentrant` entry
378  * points to them.
379  *
380  * TIP: If you would like to learn more about reentrancy and alternative ways
381  * to protect against it, check out our blog post
382  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
383  */
384 contract ReentrancyGuard {
385     // Booleans are more expensive than uint256 or any type that takes up a full
386     // word because each write operation emits an extra SLOAD to first read the
387     // slot's contents, replace the bits taken up by the boolean, and then write
388     // back. This is the compiler's defense against contract upgrades and
389     // pointer aliasing, and it cannot be disabled.
390 
391     // The values being non-zero value makes deployment a bit more expensive,
392     // but in exchange the refund on every call to nonReentrant will be lower in
393     // amount. Since refunds are capped to a percentage of the total
394     // transaction's gas, it is best to keep them low in cases like this one, to
395     // increase the likelihood of the full refund coming into effect.
396     uint256 private constant _NOT_ENTERED = 1;
397     uint256 private constant _ENTERED = 2;
398 
399     uint256 private _status;
400 
401     constructor () internal {
402         _status = _NOT_ENTERED;
403     }
404 
405     /**
406      * @dev Prevents a contract from calling itself, directly or indirectly.
407      * Calling a `nonReentrant` function from another `nonReentrant`
408      * function is not supported. It is possible to prevent this from happening
409      * by making the `nonReentrant` function external, and make it call a
410      * `private` function that does the actual work.
411      */
412     modifier nonReentrant() {
413         // On the first call to nonReentrant, _notEntered will be true
414         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
415 
416         // Any calls to nonReentrant after this point will fail
417         _status = _ENTERED;
418 
419         _;
420 
421         // By storing the original value once again, a refund is triggered (see
422         // https://eips.ethereum.org/EIPS/eip-2200)
423         _status = _NOT_ENTERED;
424     }
425 }
426 
427 /**
428  * @dev Standard math utilities missing in the Solidity language.
429  */
430 library Math {
431     /**
432      * @dev Returns the largest of two numbers.
433      */
434     function max(uint256 a, uint256 b) internal pure returns (uint256) {
435         return a >= b ? a : b;
436     }
437 
438     /**
439      * @dev Returns the smallest of two numbers.
440      */
441     function min(uint256 a, uint256 b) internal pure returns (uint256) {
442         return a < b ? a : b;
443     }
444 
445     /**
446      * @dev Returns the average of two numbers. The result is rounded towards
447      * zero.
448      */
449     function average(uint256 a, uint256 b) internal pure returns (uint256) {
450         // (a + b) / 2 can overflow, so we distribute
451         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
452     }
453 }
454 
455 library Address {
456     /**
457      * @dev Returns true if `account` is a contract.
458      *
459      * [IMPORTANT]
460      * ====
461      * It is unsafe to assume that an address for which this function returns
462      * false is an externally-owned account (EOA) and not a contract.
463      *
464      * Among others, `isContract` will return false for the following
465      * types of addresses:
466      *
467      *  - an externally-owned account
468      *  - a contract in construction
469      *  - an address where a contract will be created
470      *  - an address where a contract lived, but was destroyed
471      * ====
472      */
473     function isContract(address account) internal view returns (bool) {
474         // This method relies in extcodesize, which returns 0 for contracts in
475         // construction, since the code is only stored at the end of the
476         // constructor execution.
477 
478         uint256 size;
479         // solhint-disable-next-line no-inline-assembly
480         assembly { size := extcodesize(account) }
481         return size > 0;
482     }
483 
484     /**
485      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
486      * `recipient`, forwarding all available gas and reverting on errors.
487      *
488      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
489      * of certain opcodes, possibly making contracts go over the 2300 gas limit
490      * imposed by `transfer`, making them unable to receive funds via
491      * `transfer`. {sendValue} removes this limitation.
492      *
493      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
494      *
495      * IMPORTANT: because control is transferred to `recipient`, care must be
496      * taken to not create reentrancy vulnerabilities. Consider using
497      * {ReentrancyGuard} or the
498      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
499      */
500     function sendValue(address payable recipient, uint256 amount) internal {
501         require(address(this).balance >= amount, "Address: insufficient balance");
502 
503         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
504         (bool success, ) = recipient.call{ value: amount }("");
505         require(success, "Address: unable to send value, recipient may have reverted");
506     }
507 
508     /**
509      * @dev Performs a Solidity function call using a low level `call`. A
510      * plain`call` is an unsafe replacement for a function call: use this
511      * function instead.
512      *
513      * If `target` reverts with a revert reason, it is bubbled up by this
514      * function (like regular Solidity function calls).
515      *
516      * Returns the raw returned data. To convert to the expected return value,
517      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
518      *
519      * Requirements:
520      *
521      * - `target` must be a contract.
522      * - calling `target` with `data` must not revert.
523      *
524      * _Available since v3.1._
525      */
526     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
527       return functionCall(target, data, "Address: low-level call failed");
528     }
529 
530     /**
531      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
532      * `errorMessage` as a fallback revert reason when `target` reverts.
533      *
534      * _Available since v3.1._
535      */
536     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
537         return _functionCallWithValue(target, data, 0, errorMessage);
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
542      * but also transferring `value` wei to `target`.
543      *
544      * Requirements:
545      *
546      * - the calling contract must have an ETH balance of at least `value`.
547      * - the called Solidity function must be `payable`.
548      *
549      * _Available since v3.1._
550      */
551     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
552         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
553     }
554 
555     /**
556      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
557      * with `errorMessage` as a fallback revert reason when `target` reverts.
558      *
559      * _Available since v3.1._
560      */
561     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
562         require(address(this).balance >= value, "Address: insufficient balance for call");
563         return _functionCallWithValue(target, data, value, errorMessage);
564     }
565 
566     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
567         require(isContract(target), "Address: call to non-contract");
568 
569         // solhint-disable-next-line avoid-low-level-calls
570         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
571         if (success) {
572             return returndata;
573         } else {
574             // Look for revert reason and bubble it up if present
575             if (returndata.length > 0) {
576                 // The easiest way to bubble the revert reason is using memory via assembly
577 
578                 // solhint-disable-next-line no-inline-assembly
579                 assembly {
580                     let returndata_size := mload(returndata)
581                     revert(add(32, returndata), returndata_size)
582                 }
583             } else {
584                 revert(errorMessage);
585             }
586         }
587     }
588 }
589 
590 /**
591  * @dev Wrappers over Solidity's arithmetic operations with added overflow
592  * checks.
593  *
594  * Arithmetic operations in Solidity wrap on overflow. This can easily result
595  * in bugs, because programmers usually assume that an overflow raises an
596  * error, which is the standard behavior in high level programming languages.
597  * `SafeMath` restores this intuition by reverting the transaction when an
598  * operation overflows.
599  *
600  * Using this library instead of the unchecked operations eliminates an entire
601  * class of bugs, so it's recommended to use it always.
602  */
603 library SafeMath {
604     /**
605      * @dev Returns the addition of two unsigned integers, reverting on
606      * overflow.
607      *
608      * Counterpart to Solidity's `+` operator.
609      *
610      * Requirements:
611      *
612      * - Addition cannot overflow.
613      */
614     function add(uint256 a, uint256 b) internal pure returns (uint256) {
615         uint256 c = a + b;
616         require(c >= a, "SafeMath: addition overflow");
617 
618         return c;
619     }
620 
621     /**
622      * @dev Returns the subtraction of two unsigned integers, reverting on
623      * overflow (when the result is negative).
624      *
625      * Counterpart to Solidity's `-` operator.
626      *
627      * Requirements:
628      *
629      * - Subtraction cannot overflow.
630      */
631     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
632         return sub(a, b, "SafeMath: subtraction overflow");
633     }
634 
635     /**
636      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
637      * overflow (when the result is negative).
638      *
639      * Counterpart to Solidity's `-` operator.
640      *
641      * Requirements:
642      *
643      * - Subtraction cannot overflow.
644      */
645     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
646         require(b <= a, errorMessage);
647         uint256 c = a - b;
648 
649         return c;
650     }
651 
652     /**
653      * @dev Returns the multiplication of two unsigned integers, reverting on
654      * overflow.
655      *
656      * Counterpart to Solidity's `*` operator.
657      *
658      * Requirements:
659      *
660      * - Multiplication cannot overflow.
661      */
662     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
663         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
664         // benefit is lost if 'b' is also tested.
665         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
666         if (a == 0) {
667             return 0;
668         }
669 
670         uint256 c = a * b;
671         require(c / a == b, "SafeMath: multiplication overflow");
672 
673         return c;
674     }
675 
676     /**
677      * @dev Returns the integer division of two unsigned integers. Reverts on
678      * division by zero. The result is rounded towards zero.
679      *
680      * Counterpart to Solidity's `/` operator. Note: this function uses a
681      * `revert` opcode (which leaves remaining gas untouched) while Solidity
682      * uses an invalid opcode to revert (consuming all remaining gas).
683      *
684      * Requirements:
685      *
686      * - The divisor cannot be zero.
687      */
688     function div(uint256 a, uint256 b) internal pure returns (uint256) {
689         return div(a, b, "SafeMath: division by zero");
690     }
691 
692     /**
693      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
694      * division by zero. The result is rounded towards zero.
695      *
696      * Counterpart to Solidity's `/` operator. Note: this function uses a
697      * `revert` opcode (which leaves remaining gas untouched) while Solidity
698      * uses an invalid opcode to revert (consuming all remaining gas).
699      *
700      * Requirements:
701      *
702      * - The divisor cannot be zero.
703      */
704     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
705         require(b > 0, errorMessage);
706         uint256 c = a / b;
707         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
708 
709         return c;
710     }
711 
712     /**
713      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
714      * Reverts when dividing by zero.
715      *
716      * Counterpart to Solidity's `%` operator. This function uses a `revert`
717      * opcode (which leaves remaining gas untouched) while Solidity uses an
718      * invalid opcode to revert (consuming all remaining gas).
719      *
720      * Requirements:
721      *
722      * - The divisor cannot be zero.
723      */
724     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
725         return mod(a, b, "SafeMath: modulo by zero");
726     }
727 
728     /**
729      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
730      * Reverts with custom message when dividing by zero.
731      *
732      * Counterpart to Solidity's `%` operator. This function uses a `revert`
733      * opcode (which leaves remaining gas untouched) while Solidity uses an
734      * invalid opcode to revert (consuming all remaining gas).
735      *
736      * Requirements:
737      *
738      * - The divisor cannot be zero.
739      */
740     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
741         require(b != 0, errorMessage);
742         return a % b;
743     }
744 }
745 
746 library MathUtils {
747     using SafeMath for uint256;
748 
749     /// @notice Calculates the square root of a given value.
750     function sqrt(uint256 x) internal pure returns (uint256 y) {
751         uint256 z = (x + 1) / 2;
752         y = x;
753         while (z < y) {
754             y = z;
755             z = (x / z + z) / 2;
756         }
757     }
758 
759     /// @notice Rounds a division result.
760     function roundedDiv(uint256 a, uint256 b) internal pure returns (uint256) {
761         require(b > 0, 'div by 0');
762 
763         uint256 halfB = (b.mod(2) == 0) ? (b.div(2)) : (b.div(2).add(1));
764         return (a.mod(b) >= halfB) ? (a.div(b).add(1)) : (a.div(b));
765     }
766 }
767 
768 interface IUniswapV2ERC20 {
769     event Approval(address indexed owner, address indexed spender, uint value);
770     event Transfer(address indexed from, address indexed to, uint value);
771 
772     function name() external pure returns (string memory);
773     function symbol() external pure returns (string memory);
774     function decimals() external pure returns (uint8);
775     function totalSupply() external view returns (uint);
776     function balanceOf(address owner) external view returns (uint);
777     function allowance(address owner, address spender) external view returns (uint);
778 
779     function approve(address spender, uint value) external returns (bool);
780     function transfer(address to, uint value) external returns (bool);
781     function transferFrom(address from, address to, uint value) external returns (bool);
782 
783     function DOMAIN_SEPARATOR() external view returns (bytes32);
784     function PERMIT_TYPEHASH() external pure returns (bytes32);
785     function nonces(address owner) external view returns (uint);
786 
787     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
788 }
789 
790 interface IUniswapV2Callee {
791     function uniswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external;
792 }
793 
794 interface IERC20Uniswap {
795     event Approval(address indexed owner, address indexed spender, uint value);
796     event Transfer(address indexed from, address indexed to, uint value);
797 
798     function name() external view returns (string memory);
799     function symbol() external view returns (string memory);
800     function decimals() external view returns (uint8);
801     function totalSupply() external view returns (uint);
802     function balanceOf(address owner) external view returns (uint);
803     function allowance(address owner, address spender) external view returns (uint);
804 
805     function approve(address spender, uint value) external returns (bool);
806     function transfer(address to, uint value) external returns (bool);
807     function transferFrom(address from, address to, uint value) external returns (bool);
808 }
809 
810 /*
811  * @dev Provides information about the current execution context, including the
812  * sender of the transaction and its data. While these are generally available
813  * via msg.sender and msg.data, they should not be accessed in such a direct
814  * manner, since when dealing with GSN meta-transactions the account sending and
815  * paying for execution may not be the actual sender (as far as an application
816  * is concerned).
817  *
818  * This contract is only required for intermediate, library-like contracts.
819  */
820 abstract contract Context {
821     function _msgSender() internal view virtual returns (address payable) {
822         return msg.sender;
823     }
824 
825     function _msgData() internal view virtual returns (bytes memory) {
826         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
827         return msg.data;
828     }
829 }
830 
831 /**
832  * @dev Implementation of the {IERC20} interface.
833  *
834  * This implementation is agnostic to the way tokens are created. This means
835  * that a supply mechanism has to be added in a derived contract using {_mint}.
836  * For a generic mechanism see {ERC20PresetMinterPauser}.
837  *
838  * TIP: For a detailed writeup see our guide
839  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
840  * to implement supply mechanisms].
841  *
842  * We have followed general OpenZeppelin guidelines: functions revert instead
843  * of returning `false` on failure. This behavior is nonetheless conventional
844  * and does not conflict with the expectations of ERC20 applications.
845  *
846  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
847  * This allows applications to reconstruct the allowance for all accounts just
848  * by listening to said events. Other implementations of the EIP may not emit
849  * these events, as it isn't required by the specification.
850  *
851  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
852  * functions have been added to mitigate the well-known issues around setting
853  * allowances. See {IERC20-approve}.
854  */
855 contract ERC20 is Context, IERC20 {
856     using SafeMath for uint256;
857     using Address for address;
858 
859     mapping (address => uint256) private _balances;
860 
861     mapping (address => mapping (address => uint256)) private _allowances;
862 
863     uint256 private _totalSupply;
864 
865     string private _name;
866     string private _symbol;
867     uint8 private _decimals;
868 
869     /**
870      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
871      * a default value of 18.
872      *
873      * To select a different value for {decimals}, use {_setupDecimals}.
874      *
875      * All three of these values are immutable: they can only be set once during
876      * construction.
877      */
878     constructor (string memory name, string memory symbol) public {
879         _name = name;
880         _symbol = symbol;
881         _decimals = 18;
882     }
883 
884     /**
885      * @dev Returns the name of the token.
886      */
887     function name() public view returns (string memory) {
888         return _name;
889     }
890 
891     /**
892      * @dev Returns the symbol of the token, usually a shorter version of the
893      * name.
894      */
895     function symbol() public view returns (string memory) {
896         return _symbol;
897     }
898 
899     /**
900      * @dev Returns the number of decimals used to get its user representation.
901      * For example, if `decimals` equals `2`, a balance of `505` tokens should
902      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
903      *
904      * Tokens usually opt for a value of 18, imitating the relationship between
905      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
906      * called.
907      *
908      * NOTE: This information is only used for _display_ purposes: it in
909      * no way affects any of the arithmetic of the contract, including
910      * {IERC20-balanceOf} and {IERC20-transfer}.
911      */
912     function decimals() public view returns (uint8) {
913         return _decimals;
914     }
915 
916     /**
917      * @dev See {IERC20-totalSupply}.
918      */
919     function totalSupply() public view override returns (uint256) {
920         return _totalSupply;
921     }
922 
923     /**
924      * @dev See {IERC20-balanceOf}.
925      */
926     function balanceOf(address account) public view override returns (uint256) {
927         return _balances[account];
928     }
929 
930     /**
931      * @dev See {IERC20-transfer}.
932      *
933      * Requirements:
934      *
935      * - `recipient` cannot be the zero address.
936      * - the caller must have a balance of at least `amount`.
937      */
938     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
939         _transfer(_msgSender(), recipient, amount);
940         return true;
941     }
942 
943     /**
944      * @dev See {IERC20-allowance}.
945      */
946     function allowance(address owner, address spender) public view virtual override returns (uint256) {
947         return _allowances[owner][spender];
948     }
949 
950     /**
951      * @dev See {IERC20-approve}.
952      *
953      * Requirements:
954      *
955      * - `spender` cannot be the zero address.
956      */
957     function approve(address spender, uint256 amount) public virtual override returns (bool) {
958         _approve(_msgSender(), spender, amount);
959         return true;
960     }
961 
962     /**
963      * @dev See {IERC20-transferFrom}.
964      *
965      * Emits an {Approval} event indicating the updated allowance. This is not
966      * required by the EIP. See the note at the beginning of {ERC20};
967      *
968      * Requirements:
969      * - `sender` and `recipient` cannot be the zero address.
970      * - `sender` must have a balance of at least `amount`.
971      * - the caller must have allowance for ``sender``'s tokens of at least
972      * `amount`.
973      */
974     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
975         _transfer(sender, recipient, amount);
976         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
977         return true;
978     }
979 
980     /**
981      * @dev Atomically increases the allowance granted to `spender` by the caller.
982      *
983      * This is an alternative to {approve} that can be used as a mitigation for
984      * problems described in {IERC20-approve}.
985      *
986      * Emits an {Approval} event indicating the updated allowance.
987      *
988      * Requirements:
989      *
990      * - `spender` cannot be the zero address.
991      */
992     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
993         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
994         return true;
995     }
996 
997     /**
998      * @dev Atomically decreases the allowance granted to `spender` by the caller.
999      *
1000      * This is an alternative to {approve} that can be used as a mitigation for
1001      * problems described in {IERC20-approve}.
1002      *
1003      * Emits an {Approval} event indicating the updated allowance.
1004      *
1005      * Requirements:
1006      *
1007      * - `spender` cannot be the zero address.
1008      * - `spender` must have allowance for the caller of at least
1009      * `subtractedValue`.
1010      */
1011     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1012         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1013         return true;
1014     }
1015 
1016     /**
1017      * @dev Moves tokens `amount` from `sender` to `recipient`.
1018      *
1019      * This is internal function is equivalent to {transfer}, and can be used to
1020      * e.g. implement automatic token fees, slashing mechanisms, etc.
1021      *
1022      * Emits a {Transfer} event.
1023      *
1024      * Requirements:
1025      *
1026      * - `sender` cannot be the zero address.
1027      * - `recipient` cannot be the zero address.
1028      * - `sender` must have a balance of at least `amount`.
1029      */
1030     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1031         require(sender != address(0), "ERC20: transfer from the zero address");
1032         require(recipient != address(0), "ERC20: transfer to the zero address");
1033 
1034         _beforeTokenTransfer(sender, recipient, amount);
1035 
1036         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1037         _balances[recipient] = _balances[recipient].add(amount);
1038         emit Transfer(sender, recipient, amount);
1039     }
1040 
1041     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1042      * the total supply.
1043      *
1044      * Emits a {Transfer} event with `from` set to the zero address.
1045      *
1046      * Requirements
1047      *
1048      * - `to` cannot be the zero address.
1049      */
1050     function _mint(address account, uint256 amount) internal virtual {
1051         require(account != address(0), "ERC20: mint to the zero address");
1052 
1053         _beforeTokenTransfer(address(0), account, amount);
1054 
1055         _totalSupply = _totalSupply.add(amount);
1056         _balances[account] = _balances[account].add(amount);
1057         emit Transfer(address(0), account, amount);
1058     }
1059 
1060     /**
1061      * @dev Destroys `amount` tokens from `account`, reducing the
1062      * total supply.
1063      *
1064      * Emits a {Transfer} event with `to` set to the zero address.
1065      *
1066      * Requirements
1067      *
1068      * - `account` cannot be the zero address.
1069      * - `account` must have at least `amount` tokens.
1070      */
1071     function _burn(address account, uint256 amount) internal virtual {
1072         require(account != address(0), "ERC20: burn from the zero address");
1073 
1074         _beforeTokenTransfer(account, address(0), amount);
1075 
1076         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1077         _totalSupply = _totalSupply.sub(amount);
1078         emit Transfer(account, address(0), amount);
1079     }
1080 
1081     /**
1082      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1083      *
1084      * This internal function is equivalent to `approve`, and can be used to
1085      * e.g. set automatic allowances for certain subsystems, etc.
1086      *
1087      * Emits an {Approval} event.
1088      *
1089      * Requirements:
1090      *
1091      * - `owner` cannot be the zero address.
1092      * - `spender` cannot be the zero address.
1093      */
1094     function _approve(address owner, address spender, uint256 amount) internal virtual {
1095         require(owner != address(0), "ERC20: approve from the zero address");
1096         require(spender != address(0), "ERC20: approve to the zero address");
1097 
1098         _allowances[owner][spender] = amount;
1099         emit Approval(owner, spender, amount);
1100     }
1101 
1102     /**
1103      * @dev Sets {decimals} to a value other than the default one of 18.
1104      *
1105      * WARNING: This function should only be called from the constructor. Most
1106      * applications that interact with token contracts will not expect
1107      * {decimals} to ever change, and may work incorrectly if it does.
1108      */
1109     function _setupDecimals(uint8 decimals_) internal {
1110         _decimals = decimals_;
1111     }
1112 
1113     /**
1114      * @dev Hook that is called before any transfer of tokens. This includes
1115      * minting and burning.
1116      *
1117      * Calling conditions:
1118      *
1119      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1120      * will be to transferred to `to`.
1121      * - when `from` is zero, `amount` tokens will be minted for `to`.
1122      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1123      * - `from` and `to` are never both zero.
1124      *
1125      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1126      */
1127     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1128 }
1129 
1130 contract WETH9 {
1131     string public name = "Wrapped Ether";
1132     string public symbol = "WETH";
1133     uint8  public decimals = 18;
1134 
1135     event  Approval(address indexed src, address indexed guy, uint wad);
1136     event  Transfer(address indexed src, address indexed dst, uint wad);
1137     event  Deposit(address indexed dst, uint wad);
1138     event  Withdrawal(address indexed src, uint wad);
1139 
1140     mapping(address => uint)                       public  balanceOf;
1141     mapping(address => mapping(address => uint))  public  allowance;
1142 
1143     receive() external payable {
1144         deposit();
1145     }
1146 
1147     function deposit() public payable {
1148         balanceOf[msg.sender] += msg.value;
1149         Deposit(msg.sender, msg.value);
1150     }
1151 
1152     function withdraw(uint wad) public {
1153         require(balanceOf[msg.sender] >= wad);
1154         balanceOf[msg.sender] -= wad;
1155         msg.sender.transfer(wad);
1156         Withdrawal(msg.sender, wad);
1157     }
1158 
1159     function totalSupply() public view returns (uint) {
1160         return address(this).balance;
1161     }
1162 
1163     function approve(address guy, uint wad) public returns (bool) {
1164         allowance[msg.sender][guy] = wad;
1165         Approval(msg.sender, guy, wad);
1166         return true;
1167     }
1168 
1169     function transfer(address dst, uint wad) public returns (bool) {
1170         return transferFrom(msg.sender, dst, wad);
1171     }
1172 
1173     function transferFrom(address src, address dst, uint wad)
1174     public
1175     returns (bool)
1176     {
1177         require(balanceOf[src] >= wad);
1178 
1179         if (src != msg.sender && allowance[src][msg.sender] != uint(- 1)) {
1180             require(allowance[src][msg.sender] >= wad);
1181             allowance[src][msg.sender] -= wad;
1182         }
1183 
1184         balanceOf[src] -= wad;
1185         balanceOf[dst] += wad;
1186 
1187         Transfer(src, dst, wad);
1188 
1189         return true;
1190     }
1191 }
1192 
1193 contract Valhalla is ERC20 {
1194 
1195     address minter;
1196 
1197     modifier onlyMinter {
1198         require(msg.sender == minter, 'Only minter can call this function.');
1199         _;
1200     }
1201 
1202     constructor(address _minter) public ERC20('Valhalla', 'VAL') {
1203         minter = _minter;
1204     }
1205 
1206     function mint(address account, uint256 amount) external onlyMinter {
1207         _mint(account, amount);
1208     }
1209 
1210     function burn(address account, uint256 amount) external onlyMinter {
1211         _burn(account, amount);
1212     }
1213 
1214 }
1215 
1216 
1217 contract Farmhalla is ReentrancyGuard {
1218 
1219     using SafeMath for uint256;
1220     using Address for address;
1221     using SafeERC20 for IERC20;
1222 
1223     event Staked(address indexed from, uint256 amountETH, uint256 amountLP);
1224     event Withdrawn(address indexed to, uint256 amountETH, uint256 amountLP);
1225     event Claimed(address indexed to, uint256 amount);
1226     event Halving(uint256 amount);
1227     event Received(address indexed from, uint256 amount);
1228 
1229     Valhalla public token;
1230     IUniswapV2Factory public factory;
1231     IUniswapV2Router02 public router;
1232     address public weth;
1233     address payable public treasury;
1234     address public pairAddress;
1235 
1236     struct AccountInfo {
1237         // Staked LP token balance
1238         uint256 balance;
1239         uint256 withdrawTimestamp;
1240         uint256 reward;
1241         uint256 rewardPerTokenPaid;
1242     }
1243     mapping(address => AccountInfo) public accountInfos;
1244 
1245     // Staked LP token total supply
1246     uint256 private _totalSupply = 0;
1247 
1248     uint256 public constant HALVING_DURATION = 8 days;
1249     uint256 public rewardAllocation = 4444 * 1e18;
1250     uint256 public halvingTimestamp = 0;
1251     uint256 public lastUpdateTimestamp = 0;
1252 
1253     uint256 public rewardRate = 0;
1254     uint256 public rewardPerTokenStored = 0;
1255 
1256     // Farming will be started manually by dev
1257     uint256 public farmingStartTimestamp = 0;
1258     bool public farmingStarted = false;
1259 
1260     constructor(address _routerAddress) public {
1261         token = new Valhalla(address(this));
1262 
1263         router = IUniswapV2Router02(_routerAddress);
1264         factory = IUniswapV2Factory(router.factory());
1265         weth = router.WETH();
1266         treasury = msg.sender;
1267         pairAddress = factory.createPair(address(token), weth);
1268 
1269         // Calc reward rate
1270         rewardRate = rewardAllocation.div(HALVING_DURATION);
1271     }
1272 
1273     receive() external payable {
1274         emit Received(msg.sender, msg.value);
1275     }
1276 
1277     function stake() external payable nonReentrant {
1278         _checkFarming();
1279         _updateReward(msg.sender);
1280         _halving();
1281 
1282         require(msg.value > 0, 'Cannot stake 0');
1283         require(!address(msg.sender).isContract(), 'Please use your individual account');
1284 
1285         // 10% allocated to treasury for marketing and development expenses
1286         uint256 fee = msg.value.div(10);
1287         uint256 amount = msg.value.sub(fee);
1288         treasury.transfer(fee);
1289 
1290         uint256 ethAmount = IERC20(weth).balanceOf(pairAddress);
1291         uint256 tokenAmount = IERC20(token).balanceOf(pairAddress);
1292 
1293         // If eth amount = 0 then set initial price to 1 eth = 8 val
1294         uint256 amountTokenDesired = ethAmount == 0 ? (amount * 8) : amount.mul(tokenAmount).div(ethAmount);
1295         // Mint borrowed val
1296         token.mint(address(this), amountTokenDesired);
1297 
1298         // Add liquidity in uniswap
1299         uint256 amountETHDesired = amount;
1300         IERC20(token).approve(address(router), amountTokenDesired);
1301         (,, uint256 liquidity) = router.addLiquidityETH{value : amountETHDesired}(address(token), amountTokenDesired, 1, 1, address(this), block.timestamp + 1 days);
1302 
1303         // Add LP token to total supply
1304         _totalSupply = _totalSupply.add(liquidity);
1305 
1306         // Add to balance
1307         accountInfos[msg.sender].balance = accountInfos[msg.sender].balance.add(liquidity);
1308         
1309         // Set stake timestamp as withdraw timestamp
1310         // to prevent withdraw immediately after first staking
1311         if (accountInfos[msg.sender].withdrawTimestamp == 0) {
1312             accountInfos[msg.sender].withdrawTimestamp = block.timestamp;
1313         }
1314 
1315         emit Staked(msg.sender, msg.value, liquidity);
1316     }
1317 
1318     function withdraw() external nonReentrant {
1319         _checkFarming();
1320         _updateReward(msg.sender);
1321         _halving();
1322 
1323         require(accountInfos[msg.sender].withdrawTimestamp + 8 days <= block.timestamp, 'You must wait 8 days since your last withdraw or stake');
1324         require(accountInfos[msg.sender].balance > 0, 'Cannot withdraw 0');
1325 
1326         // Limit withdraw LP token
1327         uint256 amount = accountInfos[msg.sender].balance;
1328         
1329         // Reduce total supply
1330         _totalSupply = _totalSupply.sub(amount);
1331         // Reduce balance
1332         accountInfos[msg.sender].balance = accountInfos[msg.sender].balance.sub(amount);
1333         // Set timestamp
1334         accountInfos[msg.sender].withdrawTimestamp = block.timestamp;
1335 
1336         // Remove liquidity in uniswap
1337         IERC20(pairAddress).approve(address(router), amount);
1338         (uint256 tokenAmount, uint256 ethAmount) = router.removeLiquidity(address(token), weth, amount, 0, 0, address(this), block.timestamp + 1 days);
1339 
1340         // Burn borrowed val
1341         token.burn(address(this), tokenAmount);
1342         // Withdraw ETH and send to sender
1343         IWETH(weth).withdraw(ethAmount);
1344         msg.sender.transfer(ethAmount);
1345 
1346         emit Withdrawn(msg.sender, ethAmount, amount);
1347     }
1348 
1349     function claim() external nonReentrant {
1350         _checkFarming();
1351         _updateReward(msg.sender);
1352         _halving();
1353 
1354         uint256 reward = accountInfos[msg.sender].reward;
1355         require(reward > 0, 'There is no reward to claim');
1356 
1357         if (reward > 0) {
1358             // Reduce first
1359             accountInfos[msg.sender].reward = 0;
1360             
1361             // Send reward
1362             token.mint(msg.sender, reward);
1363             
1364             emit Claimed(msg.sender, reward);
1365         }
1366     }
1367 
1368     function totalSupply() external view returns (uint256) {
1369         return _totalSupply;
1370     }
1371 
1372     function balanceOf(address account) external view returns (uint256) {
1373         return accountInfos[account].balance;
1374     }
1375 
1376     function rewardPerToken() public view returns (uint256) {
1377         if (_totalSupply == 0) {
1378             return rewardPerTokenStored;
1379         }
1380 
1381         return rewardPerTokenStored
1382         .add(
1383             lastRewardTimestamp()
1384             .sub(lastUpdateTimestamp)
1385             .mul(rewardRate)
1386             .mul(1e18)
1387             .div(_totalSupply)
1388         );
1389     }
1390 
1391     function lastRewardTimestamp() public view returns (uint256) {
1392         return Math.min(block.timestamp, halvingTimestamp);
1393     }
1394 
1395     function rewardEarned(address account) public view returns (uint256) {
1396         return accountInfos[account].balance.mul(
1397             rewardPerToken().sub(accountInfos[account].rewardPerTokenPaid)
1398         )
1399         .div(1e18)
1400         .add(accountInfos[account].reward);
1401     }
1402 
1403     // Token price in eth
1404     function tokenPrice() public view returns (uint256) {
1405         uint256 ethAmount = IERC20(weth).balanceOf(pairAddress);
1406         uint256 tokenAmount = IERC20(token).balanceOf(pairAddress);
1407         return tokenAmount > 0 ?
1408         // Current price
1409         ethAmount.mul(1e18).div(tokenAmount) :
1410         // Initial price
1411         (uint256(1e18).div(2));
1412     }
1413 
1414     function _updateReward(address account) internal {
1415         rewardPerTokenStored = rewardPerToken();
1416         lastUpdateTimestamp = lastRewardTimestamp();
1417         if (account != address(0)) {
1418             accountInfos[account].reward = rewardEarned(account);
1419             accountInfos[account].rewardPerTokenPaid = rewardPerTokenStored;
1420         }
1421     }
1422 
1423     // Do halving when timestamp reached
1424     function _halving() internal {
1425         if (block.timestamp >= halvingTimestamp) {
1426             rewardAllocation = rewardAllocation.div(2);
1427 
1428             rewardRate = rewardAllocation.div(HALVING_DURATION);
1429             halvingTimestamp = halvingTimestamp.add(HALVING_DURATION);
1430 
1431             _updateReward(msg.sender);
1432             emit Halving(rewardAllocation);
1433         }
1434     }
1435 
1436     // Check if farming is started
1437     function _checkFarming() internal {
1438         require(farmingStartTimestamp != 0, 'Please wait until farming started');
1439         if (!farmingStarted) {
1440             farmingStarted = true;
1441             halvingTimestamp = block.timestamp.add(HALVING_DURATION);
1442             lastUpdateTimestamp = block.timestamp;
1443         }
1444     }
1445 
1446     // Start farming
1447     // Only dev can call this function
1448     function start() public {
1449         require(msg.sender == treasury, 'Only dev can start farming');
1450         require(farmingStartTimestamp == 0, 'Farming has already started');
1451 
1452         farmingStartTimestamp = block.timestamp;
1453     }
1454 }