1 // SPDX-License-Identifier: UNLICENSED
2 // Sources flattened with hardhat v2.6.4 https://hardhat.org
3 
4 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.3.2
5 
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(
67         address sender,
68         address recipient,
69         uint256 amount
70     ) external returns (bool);
71 
72     /**
73      * @dev Emitted when `value` tokens are moved from one account (`from`) to
74      * another (`to`).
75      *
76      * Note that `value` may be zero.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82      * a call to {approve}. `value` is the new allowance.
83      */
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 
88 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
89 
90 
91 pragma solidity ^0.8.0;
92 
93 /**
94  * @dev Collection of functions related to the address type
95  */
96 library Address {
97     /**
98      * @dev Returns true if `account` is a contract.
99      *
100      * [IMPORTANT]
101      * ====
102      * It is unsafe to assume that an address for which this function returns
103      * false is an externally-owned account (EOA) and not a contract.
104      *
105      * Among others, `isContract` will return false for the following
106      * types of addresses:
107      *
108      *  - an externally-owned account
109      *  - a contract in construction
110      *  - an address where a contract will be created
111      *  - an address where a contract lived, but was destroyed
112      * ====
113      */
114     function isContract(address account) internal view returns (bool) {
115         // This method relies on extcodesize, which returns 0 for contracts in
116         // construction, since the code is only stored at the end of the
117         // constructor execution.
118 
119         uint256 size;
120         assembly {
121             size := extcodesize(account)
122         }
123         return size > 0;
124     }
125 
126     /**
127      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
128      * `recipient`, forwarding all available gas and reverting on errors.
129      *
130      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
131      * of certain opcodes, possibly making contracts go over the 2300 gas limit
132      * imposed by `transfer`, making them unable to receive funds via
133      * `transfer`. {sendValue} removes this limitation.
134      *
135      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
136      *
137      * IMPORTANT: because control is transferred to `recipient`, care must be
138      * taken to not create reentrancy vulnerabilities. Consider using
139      * {ReentrancyGuard} or the
140      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
141      */
142     function sendValue(address payable recipient, uint256 amount) internal {
143         require(address(this).balance >= amount, "Address: insufficient balance");
144 
145         (bool success, ) = recipient.call{value: amount}("");
146         require(success, "Address: unable to send value, recipient may have reverted");
147     }
148 
149     /**
150      * @dev Performs a Solidity function call using a low level `call`. A
151      * plain `call` is an unsafe replacement for a function call: use this
152      * function instead.
153      *
154      * If `target` reverts with a revert reason, it is bubbled up by this
155      * function (like regular Solidity function calls).
156      *
157      * Returns the raw returned data. To convert to the expected return value,
158      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
159      *
160      * Requirements:
161      *
162      * - `target` must be a contract.
163      * - calling `target` with `data` must not revert.
164      *
165      * _Available since v3.1._
166      */
167     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
168         return functionCall(target, data, "Address: low-level call failed");
169     }
170 
171     /**
172      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
173      * `errorMessage` as a fallback revert reason when `target` reverts.
174      *
175      * _Available since v3.1._
176      */
177     function functionCall(
178         address target,
179         bytes memory data,
180         string memory errorMessage
181     ) internal returns (bytes memory) {
182         return functionCallWithValue(target, data, 0, errorMessage);
183     }
184 
185     /**
186      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
187      * but also transferring `value` wei to `target`.
188      *
189      * Requirements:
190      *
191      * - the calling contract must have an ETH balance of at least `value`.
192      * - the called Solidity function must be `payable`.
193      *
194      * _Available since v3.1._
195      */
196     function functionCallWithValue(
197         address target,
198         bytes memory data,
199         uint256 value
200     ) internal returns (bytes memory) {
201         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
202     }
203 
204     /**
205      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
206      * with `errorMessage` as a fallback revert reason when `target` reverts.
207      *
208      * _Available since v3.1._
209      */
210     function functionCallWithValue(
211         address target,
212         bytes memory data,
213         uint256 value,
214         string memory errorMessage
215     ) internal returns (bytes memory) {
216         require(address(this).balance >= value, "Address: insufficient balance for call");
217         require(isContract(target), "Address: call to non-contract");
218 
219         (bool success, bytes memory returndata) = target.call{value: value}(data);
220         return verifyCallResult(success, returndata, errorMessage);
221     }
222 
223     /**
224      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
225      * but performing a static call.
226      *
227      * _Available since v3.3._
228      */
229     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
230         return functionStaticCall(target, data, "Address: low-level static call failed");
231     }
232 
233     /**
234      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
235      * but performing a static call.
236      *
237      * _Available since v3.3._
238      */
239     function functionStaticCall(
240         address target,
241         bytes memory data,
242         string memory errorMessage
243     ) internal view returns (bytes memory) {
244         require(isContract(target), "Address: static call to non-contract");
245 
246         (bool success, bytes memory returndata) = target.staticcall(data);
247         return verifyCallResult(success, returndata, errorMessage);
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
252      * but performing a delegate call.
253      *
254      * _Available since v3.4._
255      */
256     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
257         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
258     }
259 
260     /**
261      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
262      * but performing a delegate call.
263      *
264      * _Available since v3.4._
265      */
266     function functionDelegateCall(
267         address target,
268         bytes memory data,
269         string memory errorMessage
270     ) internal returns (bytes memory) {
271         require(isContract(target), "Address: delegate call to non-contract");
272 
273         (bool success, bytes memory returndata) = target.delegatecall(data);
274         return verifyCallResult(success, returndata, errorMessage);
275     }
276 
277     /**
278      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
279      * revert reason using the provided one.
280      *
281      * _Available since v4.3._
282      */
283     function verifyCallResult(
284         bool success,
285         bytes memory returndata,
286         string memory errorMessage
287     ) internal pure returns (bytes memory) {
288         if (success) {
289             return returndata;
290         } else {
291             // Look for revert reason and bubble it up if present
292             if (returndata.length > 0) {
293                 // The easiest way to bubble the revert reason is using memory via assembly
294 
295                 assembly {
296                     let returndata_size := mload(returndata)
297                     revert(add(32, returndata), returndata_size)
298                 }
299             } else {
300                 revert(errorMessage);
301             }
302         }
303     }
304 }
305 
306 
307 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.3.2
308 
309 
310 pragma solidity ^0.8.0;
311 
312 
313 /**
314  * @title SafeERC20
315  * @dev Wrappers around ERC20 operations that throw on failure (when the token
316  * contract returns false). Tokens that return no value (and instead revert or
317  * throw on failure) are also supported, non-reverting calls are assumed to be
318  * successful.
319  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
320  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
321  */
322 library SafeERC20 {
323     using Address for address;
324 
325     function safeTransfer(
326         IERC20 token,
327         address to,
328         uint256 value
329     ) internal {
330         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
331     }
332 
333     function safeTransferFrom(
334         IERC20 token,
335         address from,
336         address to,
337         uint256 value
338     ) internal {
339         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
340     }
341 
342     /**
343      * @dev Deprecated. This function has issues similar to the ones found in
344      * {IERC20-approve}, and its usage is discouraged.
345      *
346      * Whenever possible, use {safeIncreaseAllowance} and
347      * {safeDecreaseAllowance} instead.
348      */
349     function safeApprove(
350         IERC20 token,
351         address spender,
352         uint256 value
353     ) internal {
354         // safeApprove should only be called when setting an initial allowance,
355         // or when resetting it to zero. To increase and decrease it, use
356         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
357         require(
358             (value == 0) || (token.allowance(address(this), spender) == 0),
359             "SafeERC20: approve from non-zero to non-zero allowance"
360         );
361         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
362     }
363 
364     function safeIncreaseAllowance(
365         IERC20 token,
366         address spender,
367         uint256 value
368     ) internal {
369         uint256 newAllowance = token.allowance(address(this), spender) + value;
370         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
371     }
372 
373     function safeDecreaseAllowance(
374         IERC20 token,
375         address spender,
376         uint256 value
377     ) internal {
378         unchecked {
379             uint256 oldAllowance = token.allowance(address(this), spender);
380             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
381             uint256 newAllowance = oldAllowance - value;
382             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
383         }
384     }
385 
386     /**
387      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
388      * on the return value: the return value is optional (but if data is returned, it must not be false).
389      * @param token The token targeted by the call.
390      * @param data The call data (encoded using abi.encode or one of its variants).
391      */
392     function _callOptionalReturn(IERC20 token, bytes memory data) private {
393         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
394         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
395         // the target address contains contract code and also asserts for success in the low-level call.
396 
397         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
398         if (returndata.length > 0) {
399             // Return data is optional
400             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
401         }
402     }
403 }
404 
405 
406 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
407 
408 
409 pragma solidity ^0.8.0;
410 
411 /**
412  * @dev Provides information about the current execution context, including the
413  * sender of the transaction and its data. While these are generally available
414  * via msg.sender and msg.data, they should not be accessed in such a direct
415  * manner, since when dealing with meta-transactions the account sending and
416  * paying for execution may not be the actual sender (as far as an application
417  * is concerned).
418  *
419  * This contract is only required for intermediate, library-like contracts.
420  */
421 abstract contract Context {
422     function _msgSender() internal view virtual returns (address) {
423         return msg.sender;
424     }
425 
426     function _msgData() internal view virtual returns (bytes calldata) {
427         return msg.data;
428     }
429 }
430 
431 
432 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.2
433 
434 
435 pragma solidity ^0.8.0;
436 
437 /**
438  * @dev Contract module which provides a basic access control mechanism, where
439  * there is an account (an owner) that can be granted exclusive access to
440  * specific functions.
441  *
442  * By default, the owner account will be the one that deploys the contract. This
443  * can later be changed with {transferOwnership}.
444  *
445  * This module is used through inheritance. It will make available the modifier
446  * `onlyOwner`, which can be applied to your functions to restrict their use to
447  * the owner.
448  */
449 abstract contract Ownable is Context {
450     address private _owner;
451 
452     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
453 
454     /**
455      * @dev Initializes the contract setting the deployer as the initial owner.
456      */
457     constructor() {
458         _setOwner(_msgSender());
459     }
460 
461     /**
462      * @dev Returns the address of the current owner.
463      */
464     function owner() public view virtual returns (address) {
465         return _owner;
466     }
467 
468     /**
469      * @dev Throws if called by any account other than the owner.
470      */
471     modifier onlyOwner() {
472         require(owner() == _msgSender(), "Ownable: caller is not the owner");
473         _;
474     }
475 
476     /**
477      * @dev Leaves the contract without owner. It will not be possible to call
478      * `onlyOwner` functions anymore. Can only be called by the current owner.
479      *
480      * NOTE: Renouncing ownership will leave the contract without an owner,
481      * thereby removing any functionality that is only available to the owner.
482      */
483     function renounceOwnership() public virtual onlyOwner {
484         _setOwner(address(0));
485     }
486 
487     /**
488      * @dev Transfers ownership of the contract to a new account (`newOwner`).
489      * Can only be called by the current owner.
490      */
491     function transferOwnership(address newOwner) public virtual onlyOwner {
492         require(newOwner != address(0), "Ownable: new owner is the zero address");
493         _setOwner(newOwner);
494     }
495 
496     function _setOwner(address newOwner) private {
497         address oldOwner = _owner;
498         _owner = newOwner;
499         emit OwnershipTransferred(oldOwner, newOwner);
500     }
501 }
502 
503 
504 // File @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol@v1.0.1
505 
506 pragma solidity >=0.5.0;
507 
508 interface IUniswapV2Pair {
509     event Approval(address indexed owner, address indexed spender, uint value);
510     event Transfer(address indexed from, address indexed to, uint value);
511 
512     function name() external pure returns (string memory);
513     function symbol() external pure returns (string memory);
514     function decimals() external pure returns (uint8);
515     function totalSupply() external view returns (uint);
516     function balanceOf(address owner) external view returns (uint);
517     function allowance(address owner, address spender) external view returns (uint);
518 
519     function approve(address spender, uint value) external returns (bool);
520     function transfer(address to, uint value) external returns (bool);
521     function transferFrom(address from, address to, uint value) external returns (bool);
522 
523     function DOMAIN_SEPARATOR() external view returns (bytes32);
524     function PERMIT_TYPEHASH() external pure returns (bytes32);
525     function nonces(address owner) external view returns (uint);
526 
527     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
528 
529     event Mint(address indexed sender, uint amount0, uint amount1);
530     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
531     event Swap(
532         address indexed sender,
533         uint amount0In,
534         uint amount1In,
535         uint amount0Out,
536         uint amount1Out,
537         address indexed to
538     );
539     event Sync(uint112 reserve0, uint112 reserve1);
540 
541     function MINIMUM_LIQUIDITY() external pure returns (uint);
542     function factory() external view returns (address);
543     function token0() external view returns (address);
544     function token1() external view returns (address);
545     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
546     function price0CumulativeLast() external view returns (uint);
547     function price1CumulativeLast() external view returns (uint);
548     function kLast() external view returns (uint);
549 
550     function mint(address to) external returns (uint liquidity);
551     function burn(address to) external returns (uint amount0, uint amount1);
552     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
553     function skim(address to) external;
554     function sync() external;
555 
556     function initialize(address, address) external;
557 }
558 
559 
560 // File @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol@v1.1.0-beta.0
561 
562 pragma solidity >=0.6.2;
563 
564 interface IUniswapV2Router01 {
565     function factory() external pure returns (address);
566     function WETH() external pure returns (address);
567 
568     function addLiquidity(
569         address tokenA,
570         address tokenB,
571         uint amountADesired,
572         uint amountBDesired,
573         uint amountAMin,
574         uint amountBMin,
575         address to,
576         uint deadline
577     ) external returns (uint amountA, uint amountB, uint liquidity);
578     function addLiquidityETH(
579         address token,
580         uint amountTokenDesired,
581         uint amountTokenMin,
582         uint amountETHMin,
583         address to,
584         uint deadline
585     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
586     function removeLiquidity(
587         address tokenA,
588         address tokenB,
589         uint liquidity,
590         uint amountAMin,
591         uint amountBMin,
592         address to,
593         uint deadline
594     ) external returns (uint amountA, uint amountB);
595     function removeLiquidityETH(
596         address token,
597         uint liquidity,
598         uint amountTokenMin,
599         uint amountETHMin,
600         address to,
601         uint deadline
602     ) external returns (uint amountToken, uint amountETH);
603     function removeLiquidityWithPermit(
604         address tokenA,
605         address tokenB,
606         uint liquidity,
607         uint amountAMin,
608         uint amountBMin,
609         address to,
610         uint deadline,
611         bool approveMax, uint8 v, bytes32 r, bytes32 s
612     ) external returns (uint amountA, uint amountB);
613     function removeLiquidityETHWithPermit(
614         address token,
615         uint liquidity,
616         uint amountTokenMin,
617         uint amountETHMin,
618         address to,
619         uint deadline,
620         bool approveMax, uint8 v, bytes32 r, bytes32 s
621     ) external returns (uint amountToken, uint amountETH);
622     function swapExactTokensForTokens(
623         uint amountIn,
624         uint amountOutMin,
625         address[] calldata path,
626         address to,
627         uint deadline
628     ) external returns (uint[] memory amounts);
629     function swapTokensForExactTokens(
630         uint amountOut,
631         uint amountInMax,
632         address[] calldata path,
633         address to,
634         uint deadline
635     ) external returns (uint[] memory amounts);
636     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
637         external
638         payable
639         returns (uint[] memory amounts);
640     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
641         external
642         returns (uint[] memory amounts);
643     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
644         external
645         returns (uint[] memory amounts);
646     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
647         external
648         payable
649         returns (uint[] memory amounts);
650 
651     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
652     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
653     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
654     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
655     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
656 }
657 
658 
659 // File @uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolImmutables.sol@v1.0.0
660 
661 pragma solidity >=0.5.0;
662 
663 /// @title Pool state that never changes
664 /// @notice These parameters are fixed for a pool forever, i.e., the methods will always return the same values
665 interface IUniswapV3PoolImmutables {
666     /// @notice The contract that deployed the pool, which must adhere to the IUniswapV3Factory interface
667     /// @return The contract address
668     function factory() external view returns (address);
669 
670     /// @notice The first of the two tokens of the pool, sorted by address
671     /// @return The token contract address
672     function token0() external view returns (address);
673 
674     /// @notice The second of the two tokens of the pool, sorted by address
675     /// @return The token contract address
676     function token1() external view returns (address);
677 
678     /// @notice The pool's fee in hundredths of a bip, i.e. 1e-6
679     /// @return The fee
680     function fee() external view returns (uint24);
681 
682     /// @notice The pool tick spacing
683     /// @dev Ticks can only be used at multiples of this value, minimum of 1 and always positive
684     /// e.g.: a tickSpacing of 3 means ticks can be initialized every 3rd tick, i.e., ..., -6, -3, 0, 3, 6, ...
685     /// This value is an int24 to avoid casting even though it is always positive.
686     /// @return The tick spacing
687     function tickSpacing() external view returns (int24);
688 
689     /// @notice The maximum amount of position liquidity that can use any tick in the range
690     /// @dev This parameter is enforced per tick to prevent liquidity from overflowing a uint128 at any point, and
691     /// also prevents out-of-range liquidity from being used to prevent adding in-range liquidity to a pool
692     /// @return The max amount of liquidity per tick
693     function maxLiquidityPerTick() external view returns (uint128);
694 }
695 
696 
697 // File @uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolState.sol@v1.0.0
698 
699 pragma solidity >=0.5.0;
700 
701 /// @title Pool state that can change
702 /// @notice These methods compose the pool's state, and can change with any frequency including multiple times
703 /// per transaction
704 interface IUniswapV3PoolState {
705     /// @notice The 0th storage slot in the pool stores many values, and is exposed as a single method to save gas
706     /// when accessed externally.
707     /// @return sqrtPriceX96 The current price of the pool as a sqrt(token1/token0) Q64.96 value
708     /// tick The current tick of the pool, i.e. according to the last tick transition that was run.
709     /// This value may not always be equal to SqrtTickMath.getTickAtSqrtRatio(sqrtPriceX96) if the price is on a tick
710     /// boundary.
711     /// observationIndex The index of the last oracle observation that was written,
712     /// observationCardinality The current maximum number of observations stored in the pool,
713     /// observationCardinalityNext The next maximum number of observations, to be updated when the observation.
714     /// feeProtocol The protocol fee for both tokens of the pool.
715     /// Encoded as two 4 bit values, where the protocol fee of token1 is shifted 4 bits and the protocol fee of token0
716     /// is the lower 4 bits. Used as the denominator of a fraction of the swap fee, e.g. 4 means 1/4th of the swap fee.
717     /// unlocked Whether the pool is currently locked to reentrancy
718     function slot0()
719         external
720         view
721         returns (
722             uint160 sqrtPriceX96,
723             int24 tick,
724             uint16 observationIndex,
725             uint16 observationCardinality,
726             uint16 observationCardinalityNext,
727             uint8 feeProtocol,
728             bool unlocked
729         );
730 
731     /// @notice The fee growth as a Q128.128 fees of token0 collected per unit of liquidity for the entire life of the pool
732     /// @dev This value can overflow the uint256
733     function feeGrowthGlobal0X128() external view returns (uint256);
734 
735     /// @notice The fee growth as a Q128.128 fees of token1 collected per unit of liquidity for the entire life of the pool
736     /// @dev This value can overflow the uint256
737     function feeGrowthGlobal1X128() external view returns (uint256);
738 
739     /// @notice The amounts of token0 and token1 that are owed to the protocol
740     /// @dev Protocol fees will never exceed uint128 max in either token
741     function protocolFees() external view returns (uint128 token0, uint128 token1);
742 
743     /// @notice The currently in range liquidity available to the pool
744     /// @dev This value has no relationship to the total liquidity across all ticks
745     function liquidity() external view returns (uint128);
746 
747     /// @notice Look up information about a specific tick in the pool
748     /// @param tick The tick to look up
749     /// @return liquidityGross the total amount of position liquidity that uses the pool either as tick lower or
750     /// tick upper,
751     /// liquidityNet how much liquidity changes when the pool price crosses the tick,
752     /// feeGrowthOutside0X128 the fee growth on the other side of the tick from the current tick in token0,
753     /// feeGrowthOutside1X128 the fee growth on the other side of the tick from the current tick in token1,
754     /// tickCumulativeOutside the cumulative tick value on the other side of the tick from the current tick
755     /// secondsPerLiquidityOutsideX128 the seconds spent per liquidity on the other side of the tick from the current tick,
756     /// secondsOutside the seconds spent on the other side of the tick from the current tick,
757     /// initialized Set to true if the tick is initialized, i.e. liquidityGross is greater than 0, otherwise equal to false.
758     /// Outside values can only be used if the tick is initialized, i.e. if liquidityGross is greater than 0.
759     /// In addition, these values are only relative and must be used only in comparison to previous snapshots for
760     /// a specific position.
761     function ticks(int24 tick)
762         external
763         view
764         returns (
765             uint128 liquidityGross,
766             int128 liquidityNet,
767             uint256 feeGrowthOutside0X128,
768             uint256 feeGrowthOutside1X128,
769             int56 tickCumulativeOutside,
770             uint160 secondsPerLiquidityOutsideX128,
771             uint32 secondsOutside,
772             bool initialized
773         );
774 
775     /// @notice Returns 256 packed tick initialized boolean values. See TickBitmap for more information
776     function tickBitmap(int16 wordPosition) external view returns (uint256);
777 
778     /// @notice Returns the information about a position by the position's key
779     /// @param key The position's key is a hash of a preimage composed by the owner, tickLower and tickUpper
780     /// @return _liquidity The amount of liquidity in the position,
781     /// Returns feeGrowthInside0LastX128 fee growth of token0 inside the tick range as of the last mint/burn/poke,
782     /// Returns feeGrowthInside1LastX128 fee growth of token1 inside the tick range as of the last mint/burn/poke,
783     /// Returns tokensOwed0 the computed amount of token0 owed to the position as of the last mint/burn/poke,
784     /// Returns tokensOwed1 the computed amount of token1 owed to the position as of the last mint/burn/poke
785     function positions(bytes32 key)
786         external
787         view
788         returns (
789             uint128 _liquidity,
790             uint256 feeGrowthInside0LastX128,
791             uint256 feeGrowthInside1LastX128,
792             uint128 tokensOwed0,
793             uint128 tokensOwed1
794         );
795 
796     /// @notice Returns data about a specific observation index
797     /// @param index The element of the observations array to fetch
798     /// @dev You most likely want to use #observe() instead of this method to get an observation as of some amount of time
799     /// ago, rather than at a specific index in the array.
800     /// @return blockTimestamp The timestamp of the observation,
801     /// Returns tickCumulative the tick multiplied by seconds elapsed for the life of the pool as of the observation timestamp,
802     /// Returns secondsPerLiquidityCumulativeX128 the seconds per in range liquidity for the life of the pool as of the observation timestamp,
803     /// Returns initialized whether the observation has been initialized and the values are safe to use
804     function observations(uint256 index)
805         external
806         view
807         returns (
808             uint32 blockTimestamp,
809             int56 tickCumulative,
810             uint160 secondsPerLiquidityCumulativeX128,
811             bool initialized
812         );
813 }
814 
815 
816 // File @uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolDerivedState.sol@v1.0.0
817 
818 pragma solidity >=0.5.0;
819 
820 /// @title Pool state that is not stored
821 /// @notice Contains view functions to provide information about the pool that is computed rather than stored on the
822 /// blockchain. The functions here may have variable gas costs.
823 interface IUniswapV3PoolDerivedState {
824     /// @notice Returns the cumulative tick and liquidity as of each timestamp `secondsAgo` from the current block timestamp
825     /// @dev To get a time weighted average tick or liquidity-in-range, you must call this with two values, one representing
826     /// the beginning of the period and another for the end of the period. E.g., to get the last hour time-weighted average tick,
827     /// you must call it with secondsAgos = [3600, 0].
828     /// @dev The time weighted average tick represents the geometric time weighted average price of the pool, in
829     /// log base sqrt(1.0001) of token1 / token0. The TickMath library can be used to go from a tick value to a ratio.
830     /// @param secondsAgos From how long ago each cumulative tick and liquidity value should be returned
831     /// @return tickCumulatives Cumulative tick values as of each `secondsAgos` from the current block timestamp
832     /// @return secondsPerLiquidityCumulativeX128s Cumulative seconds per liquidity-in-range value as of each `secondsAgos` from the current block
833     /// timestamp
834     function observe(uint32[] calldata secondsAgos)
835         external
836         view
837         returns (int56[] memory tickCumulatives, uint160[] memory secondsPerLiquidityCumulativeX128s);
838 
839     /// @notice Returns a snapshot of the tick cumulative, seconds per liquidity and seconds inside a tick range
840     /// @dev Snapshots must only be compared to other snapshots, taken over a period for which a position existed.
841     /// I.e., snapshots cannot be compared if a position is not held for the entire period between when the first
842     /// snapshot is taken and the second snapshot is taken.
843     /// @param tickLower The lower tick of the range
844     /// @param tickUpper The upper tick of the range
845     /// @return tickCumulativeInside The snapshot of the tick accumulator for the range
846     /// @return secondsPerLiquidityInsideX128 The snapshot of seconds per liquidity for the range
847     /// @return secondsInside The snapshot of seconds per liquidity for the range
848     function snapshotCumulativesInside(int24 tickLower, int24 tickUpper)
849         external
850         view
851         returns (
852             int56 tickCumulativeInside,
853             uint160 secondsPerLiquidityInsideX128,
854             uint32 secondsInside
855         );
856 }
857 
858 
859 // File @uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolActions.sol@v1.0.0
860 
861 pragma solidity >=0.5.0;
862 
863 /// @title Permissionless pool actions
864 /// @notice Contains pool methods that can be called by anyone
865 interface IUniswapV3PoolActions {
866     /// @notice Sets the initial price for the pool
867     /// @dev Price is represented as a sqrt(amountToken1/amountToken0) Q64.96 value
868     /// @param sqrtPriceX96 the initial sqrt price of the pool as a Q64.96
869     function initialize(uint160 sqrtPriceX96) external;
870 
871     /// @notice Adds liquidity for the given recipient/tickLower/tickUpper position
872     /// @dev The caller of this method receives a callback in the form of IUniswapV3MintCallback#uniswapV3MintCallback
873     /// in which they must pay any token0 or token1 owed for the liquidity. The amount of token0/token1 due depends
874     /// on tickLower, tickUpper, the amount of liquidity, and the current price.
875     /// @param recipient The address for which the liquidity will be created
876     /// @param tickLower The lower tick of the position in which to add liquidity
877     /// @param tickUpper The upper tick of the position in which to add liquidity
878     /// @param amount The amount of liquidity to mint
879     /// @param data Any data that should be passed through to the callback
880     /// @return amount0 The amount of token0 that was paid to mint the given amount of liquidity. Matches the value in the callback
881     /// @return amount1 The amount of token1 that was paid to mint the given amount of liquidity. Matches the value in the callback
882     function mint(
883         address recipient,
884         int24 tickLower,
885         int24 tickUpper,
886         uint128 amount,
887         bytes calldata data
888     ) external returns (uint256 amount0, uint256 amount1);
889 
890     /// @notice Collects tokens owed to a position
891     /// @dev Does not recompute fees earned, which must be done either via mint or burn of any amount of liquidity.
892     /// Collect must be called by the position owner. To withdraw only token0 or only token1, amount0Requested or
893     /// amount1Requested may be set to zero. To withdraw all tokens owed, caller may pass any value greater than the
894     /// actual tokens owed, e.g. type(uint128).max. Tokens owed may be from accumulated swap fees or burned liquidity.
895     /// @param recipient The address which should receive the fees collected
896     /// @param tickLower The lower tick of the position for which to collect fees
897     /// @param tickUpper The upper tick of the position for which to collect fees
898     /// @param amount0Requested How much token0 should be withdrawn from the fees owed
899     /// @param amount1Requested How much token1 should be withdrawn from the fees owed
900     /// @return amount0 The amount of fees collected in token0
901     /// @return amount1 The amount of fees collected in token1
902     function collect(
903         address recipient,
904         int24 tickLower,
905         int24 tickUpper,
906         uint128 amount0Requested,
907         uint128 amount1Requested
908     ) external returns (uint128 amount0, uint128 amount1);
909 
910     /// @notice Burn liquidity from the sender and account tokens owed for the liquidity to the position
911     /// @dev Can be used to trigger a recalculation of fees owed to a position by calling with an amount of 0
912     /// @dev Fees must be collected separately via a call to #collect
913     /// @param tickLower The lower tick of the position for which to burn liquidity
914     /// @param tickUpper The upper tick of the position for which to burn liquidity
915     /// @param amount How much liquidity to burn
916     /// @return amount0 The amount of token0 sent to the recipient
917     /// @return amount1 The amount of token1 sent to the recipient
918     function burn(
919         int24 tickLower,
920         int24 tickUpper,
921         uint128 amount
922     ) external returns (uint256 amount0, uint256 amount1);
923 
924     /// @notice Swap token0 for token1, or token1 for token0
925     /// @dev The caller of this method receives a callback in the form of IUniswapV3SwapCallback#uniswapV3SwapCallback
926     /// @param recipient The address to receive the output of the swap
927     /// @param zeroForOne The direction of the swap, true for token0 to token1, false for token1 to token0
928     /// @param amountSpecified The amount of the swap, which implicitly configures the swap as exact input (positive), or exact output (negative)
929     /// @param sqrtPriceLimitX96 The Q64.96 sqrt price limit. If zero for one, the price cannot be less than this
930     /// value after the swap. If one for zero, the price cannot be greater than this value after the swap
931     /// @param data Any data to be passed through to the callback
932     /// @return amount0 The delta of the balance of token0 of the pool, exact when negative, minimum when positive
933     /// @return amount1 The delta of the balance of token1 of the pool, exact when negative, minimum when positive
934     function swap(
935         address recipient,
936         bool zeroForOne,
937         int256 amountSpecified,
938         uint160 sqrtPriceLimitX96,
939         bytes calldata data
940     ) external returns (int256 amount0, int256 amount1);
941 
942     /// @notice Receive token0 and/or token1 and pay it back, plus a fee, in the callback
943     /// @dev The caller of this method receives a callback in the form of IUniswapV3FlashCallback#uniswapV3FlashCallback
944     /// @dev Can be used to donate underlying tokens pro-rata to currently in-range liquidity providers by calling
945     /// with 0 amount{0,1} and sending the donation amount(s) from the callback
946     /// @param recipient The address which will receive the token0 and token1 amounts
947     /// @param amount0 The amount of token0 to send
948     /// @param amount1 The amount of token1 to send
949     /// @param data Any data to be passed through to the callback
950     function flash(
951         address recipient,
952         uint256 amount0,
953         uint256 amount1,
954         bytes calldata data
955     ) external;
956 
957     /// @notice Increase the maximum number of price and liquidity observations that this pool will store
958     /// @dev This method is no-op if the pool already has an observationCardinalityNext greater than or equal to
959     /// the input observationCardinalityNext.
960     /// @param observationCardinalityNext The desired minimum number of observations for the pool to store
961     function increaseObservationCardinalityNext(uint16 observationCardinalityNext) external;
962 }
963 
964 
965 // File @uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolOwnerActions.sol@v1.0.0
966 
967 pragma solidity >=0.5.0;
968 
969 /// @title Permissioned pool actions
970 /// @notice Contains pool methods that may only be called by the factory owner
971 interface IUniswapV3PoolOwnerActions {
972     /// @notice Set the denominator of the protocol's % share of the fees
973     /// @param feeProtocol0 new protocol fee for token0 of the pool
974     /// @param feeProtocol1 new protocol fee for token1 of the pool
975     function setFeeProtocol(uint8 feeProtocol0, uint8 feeProtocol1) external;
976 
977     /// @notice Collect the protocol fee accrued to the pool
978     /// @param recipient The address to which collected protocol fees should be sent
979     /// @param amount0Requested The maximum amount of token0 to send, can be 0 to collect fees in only token1
980     /// @param amount1Requested The maximum amount of token1 to send, can be 0 to collect fees in only token0
981     /// @return amount0 The protocol fee collected in token0
982     /// @return amount1 The protocol fee collected in token1
983     function collectProtocol(
984         address recipient,
985         uint128 amount0Requested,
986         uint128 amount1Requested
987     ) external returns (uint128 amount0, uint128 amount1);
988 }
989 
990 
991 // File @uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolEvents.sol@v1.0.0
992 
993 pragma solidity >=0.5.0;
994 
995 /// @title Events emitted by a pool
996 /// @notice Contains all events emitted by the pool
997 interface IUniswapV3PoolEvents {
998     /// @notice Emitted exactly once by a pool when #initialize is first called on the pool
999     /// @dev Mint/Burn/Swap cannot be emitted by the pool before Initialize
1000     /// @param sqrtPriceX96 The initial sqrt price of the pool, as a Q64.96
1001     /// @param tick The initial tick of the pool, i.e. log base 1.0001 of the starting price of the pool
1002     event Initialize(uint160 sqrtPriceX96, int24 tick);
1003 
1004     /// @notice Emitted when liquidity is minted for a given position
1005     /// @param sender The address that minted the liquidity
1006     /// @param owner The owner of the position and recipient of any minted liquidity
1007     /// @param tickLower The lower tick of the position
1008     /// @param tickUpper The upper tick of the position
1009     /// @param amount The amount of liquidity minted to the position range
1010     /// @param amount0 How much token0 was required for the minted liquidity
1011     /// @param amount1 How much token1 was required for the minted liquidity
1012     event Mint(
1013         address sender,
1014         address indexed owner,
1015         int24 indexed tickLower,
1016         int24 indexed tickUpper,
1017         uint128 amount,
1018         uint256 amount0,
1019         uint256 amount1
1020     );
1021 
1022     /// @notice Emitted when fees are collected by the owner of a position
1023     /// @dev Collect events may be emitted with zero amount0 and amount1 when the caller chooses not to collect fees
1024     /// @param owner The owner of the position for which fees are collected
1025     /// @param tickLower The lower tick of the position
1026     /// @param tickUpper The upper tick of the position
1027     /// @param amount0 The amount of token0 fees collected
1028     /// @param amount1 The amount of token1 fees collected
1029     event Collect(
1030         address indexed owner,
1031         address recipient,
1032         int24 indexed tickLower,
1033         int24 indexed tickUpper,
1034         uint128 amount0,
1035         uint128 amount1
1036     );
1037 
1038     /// @notice Emitted when a position's liquidity is removed
1039     /// @dev Does not withdraw any fees earned by the liquidity position, which must be withdrawn via #collect
1040     /// @param owner The owner of the position for which liquidity is removed
1041     /// @param tickLower The lower tick of the position
1042     /// @param tickUpper The upper tick of the position
1043     /// @param amount The amount of liquidity to remove
1044     /// @param amount0 The amount of token0 withdrawn
1045     /// @param amount1 The amount of token1 withdrawn
1046     event Burn(
1047         address indexed owner,
1048         int24 indexed tickLower,
1049         int24 indexed tickUpper,
1050         uint128 amount,
1051         uint256 amount0,
1052         uint256 amount1
1053     );
1054 
1055     /// @notice Emitted by the pool for any swaps between token0 and token1
1056     /// @param sender The address that initiated the swap call, and that received the callback
1057     /// @param recipient The address that received the output of the swap
1058     /// @param amount0 The delta of the token0 balance of the pool
1059     /// @param amount1 The delta of the token1 balance of the pool
1060     /// @param sqrtPriceX96 The sqrt(price) of the pool after the swap, as a Q64.96
1061     /// @param liquidity The liquidity of the pool after the swap
1062     /// @param tick The log base 1.0001 of price of the pool after the swap
1063     event Swap(
1064         address indexed sender,
1065         address indexed recipient,
1066         int256 amount0,
1067         int256 amount1,
1068         uint160 sqrtPriceX96,
1069         uint128 liquidity,
1070         int24 tick
1071     );
1072 
1073     /// @notice Emitted by the pool for any flashes of token0/token1
1074     /// @param sender The address that initiated the swap call, and that received the callback
1075     /// @param recipient The address that received the tokens from flash
1076     /// @param amount0 The amount of token0 that was flashed
1077     /// @param amount1 The amount of token1 that was flashed
1078     /// @param paid0 The amount of token0 paid for the flash, which can exceed the amount0 plus the fee
1079     /// @param paid1 The amount of token1 paid for the flash, which can exceed the amount1 plus the fee
1080     event Flash(
1081         address indexed sender,
1082         address indexed recipient,
1083         uint256 amount0,
1084         uint256 amount1,
1085         uint256 paid0,
1086         uint256 paid1
1087     );
1088 
1089     /// @notice Emitted by the pool for increases to the number of observations that can be stored
1090     /// @dev observationCardinalityNext is not the observation cardinality until an observation is written at the index
1091     /// just before a mint/swap/burn.
1092     /// @param observationCardinalityNextOld The previous value of the next observation cardinality
1093     /// @param observationCardinalityNextNew The updated value of the next observation cardinality
1094     event IncreaseObservationCardinalityNext(
1095         uint16 observationCardinalityNextOld,
1096         uint16 observationCardinalityNextNew
1097     );
1098 
1099     /// @notice Emitted when the protocol fee is changed by the pool
1100     /// @param feeProtocol0Old The previous value of the token0 protocol fee
1101     /// @param feeProtocol1Old The previous value of the token1 protocol fee
1102     /// @param feeProtocol0New The updated value of the token0 protocol fee
1103     /// @param feeProtocol1New The updated value of the token1 protocol fee
1104     event SetFeeProtocol(uint8 feeProtocol0Old, uint8 feeProtocol1Old, uint8 feeProtocol0New, uint8 feeProtocol1New);
1105 
1106     /// @notice Emitted when the collected protocol fees are withdrawn by the factory owner
1107     /// @param sender The address that collects the protocol fees
1108     /// @param recipient The address that receives the collected protocol fees
1109     /// @param amount0 The amount of token0 protocol fees that is withdrawn
1110     /// @param amount0 The amount of token1 protocol fees that is withdrawn
1111     event CollectProtocol(address indexed sender, address indexed recipient, uint128 amount0, uint128 amount1);
1112 }
1113 
1114 
1115 // File @uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol@v1.0.0
1116 
1117 pragma solidity >=0.5.0;
1118 
1119 
1120 
1121 
1122 
1123 
1124 /// @title The interface for a Uniswap V3 Pool
1125 /// @notice A Uniswap pool facilitates swapping and automated market making between any two assets that strictly conform
1126 /// to the ERC20 specification
1127 /// @dev The pool interface is broken up into many smaller pieces
1128 interface IUniswapV3Pool is
1129     IUniswapV3PoolImmutables,
1130     IUniswapV3PoolState,
1131     IUniswapV3PoolDerivedState,
1132     IUniswapV3PoolActions,
1133     IUniswapV3PoolOwnerActions,
1134     IUniswapV3PoolEvents
1135 {
1136 
1137 }
1138 
1139 
1140 // File contracts/interfaces/IBakeryPair.sol
1141 
1142 pragma solidity ^0.8.0;
1143 
1144 interface IBakeryPair {
1145     function MINIMUM_LIQUIDITY() external pure returns (uint256);
1146 
1147     function factory() external view returns (address);
1148 
1149     function token0() external view returns (address);
1150 
1151     function token1() external view returns (address);
1152 
1153     function getReserves()
1154         external
1155         view
1156         returns (
1157             uint112 reserve0,
1158             uint112 reserve1,
1159             uint32 blockTimestampLast
1160         );
1161 
1162     function swap(
1163         uint256 amount0Out,
1164         uint256 amount1Out,
1165         address to
1166     ) external;
1167 }
1168 
1169 
1170 // File contracts/interfaces/IDODOV2.sol
1171 
1172 
1173 pragma solidity ^0.8.0;
1174 
1175 interface IDODOV2 {
1176     function sellBase(address to) external returns (uint256 receiveQuoteAmount);
1177 
1178     function sellQuote(address to) external returns (uint256 receiveBaseAmount);
1179 
1180     function getVaultReserve()
1181         external
1182         view
1183         returns (uint256 baseReserve, uint256 quoteReserve);
1184 
1185     function _BASE_TOKEN_() external view returns (address);
1186 
1187     function _QUOTE_TOKEN_() external view returns (address);
1188 }
1189 
1190 
1191 // File contracts/interfaces/IWETH.sol
1192 
1193 
1194 pragma solidity ^0.8.0;
1195 
1196 interface IWETH {
1197     function deposit() external payable;
1198 
1199     function transfer(address to, uint256 value) external returns (bool);
1200 
1201     function withdraw(uint256) external;
1202 }
1203 
1204 
1205 // File contracts/interfaces/IVyperSwap.sol
1206 
1207 
1208 pragma solidity ^0.8.0;
1209 
1210 interface IVyperSwap {
1211     function exchange(
1212         int128 tokenIndexFrom,
1213         int128 tokenIndexTo,
1214         uint256 dx,
1215         uint256 minDy
1216     ) external;
1217 }
1218 
1219 
1220 // File contracts/interfaces/IVyperUnderlyingSwap.sol
1221 
1222 
1223 pragma solidity ^0.8.0;
1224 
1225 interface IVyperUnderlyingSwap {
1226     function exchange(
1227         int128 tokenIndexFrom,
1228         int128 tokenIndexTo,
1229         uint256 dx,
1230         uint256 minDy
1231     ) external;
1232 
1233     function exchange_underlying(
1234         int128 tokenIndexFrom,
1235         int128 tokenIndexTo,
1236         uint256 dx,
1237         uint256 minDy
1238     ) external;
1239 }
1240 
1241 
1242 // File contracts/interfaces/ISaddleDex.sol
1243 
1244 
1245 pragma solidity ^0.8.0;
1246 
1247 interface ISaddleDex {
1248     function getTokenIndex(address tokenAddress) external view returns (uint8);
1249 
1250     function swap(
1251         uint8 tokenIndexFrom,
1252         uint8 tokenIndexTo,
1253         uint256 dx,
1254         uint256 minDy,
1255         uint256 deadline
1256     ) external returns (uint256);
1257 }
1258 
1259 
1260 // File contracts/interfaces/IDODOV2Proxy.sol
1261 
1262 
1263 pragma solidity ^0.8.0;
1264 
1265 interface IDODOV2Proxy {
1266     function dodoSwapV2ETHToToken(
1267         address toToken,
1268         uint256 minReturnAmount,
1269         address[] memory dodoPairs,
1270         uint256 directions,
1271         bool isIncentive,
1272         uint256 deadLine
1273     ) external payable returns (uint256 returnAmount);
1274 
1275     function dodoSwapV2TokenToETH(
1276         address fromToken,
1277         uint256 fromTokenAmount,
1278         uint256 minReturnAmount,
1279         address[] memory dodoPairs,
1280         uint256 directions,
1281         bool isIncentive,
1282         uint256 deadLine
1283     ) external returns (uint256 returnAmount);
1284 
1285     function dodoSwapV2TokenToToken(
1286         address fromToken,
1287         address toToken,
1288         uint256 fromTokenAmount,
1289         uint256 minReturnAmount,
1290         address[] memory dodoPairs,
1291         uint256 directions,
1292         bool isIncentive,
1293         uint256 deadLine
1294     ) external returns (uint256 returnAmount);
1295 
1296     function dodoSwapV1(
1297         address fromToken,
1298         address toToken,
1299         uint256 fromTokenAmount,
1300         uint256 minReturnAmount,
1301         address[] memory dodoPairs,
1302         uint256 directions,
1303         bool isIncentive,
1304         uint256 deadLine
1305     ) external payable returns (uint256 returnAmount);
1306 }
1307 
1308 
1309 // File contracts/interfaces/IBalancer.sol
1310 
1311 
1312 pragma solidity ^0.8.0;
1313 
1314 interface IAsset {
1315     // solhint-disable-previous-line no-empty-blocks
1316 }
1317 
1318 library Balancer {
1319     enum SwapKind {
1320         GIVEN_IN,
1321         GIVEN_OUT
1322     }
1323 
1324     struct FundManagement {
1325         address sender;
1326         bool fromInternalBalance;
1327         address payable recipient;
1328         bool toInternalBalance;
1329     }
1330 
1331     struct SingleSwap {
1332         bytes32 poolId;
1333         SwapKind kind;
1334         IAsset assetIn;
1335         IAsset assetOut;
1336         uint256 amount;
1337         bytes userData;
1338     }
1339 }
1340 
1341 interface IBalancerRouter {
1342     function swap(
1343         Balancer.SingleSwap memory singleSwap,
1344         Balancer.FundManagement memory funds,
1345         uint256 limit,
1346         uint256 deadline
1347     ) external payable returns (uint256);
1348 }
1349 
1350 interface IBalancerPool {
1351     function getPoolId() external view returns (bytes32);
1352 }
1353 
1354 
1355 // File contracts/interfaces/IArkenApprove.sol
1356 
1357 
1358 pragma solidity ^0.8.0;
1359 
1360 interface IArkenApprove {
1361     function transferToken(
1362         address token,
1363         address from,
1364         address to,
1365         uint256 amount
1366     ) external;
1367 
1368     function updateCallableAddress(address _callableAddress) external;
1369 }
1370 
1371 
1372 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.3.2
1373 
1374 
1375 pragma solidity ^0.8.0;
1376 
1377 // CAUTION
1378 // This version of SafeMath should only be used with Solidity 0.8 or later,
1379 // because it relies on the compiler's built in overflow checks.
1380 
1381 /**
1382  * @dev Wrappers over Solidity's arithmetic operations.
1383  *
1384  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1385  * now has built in overflow checking.
1386  */
1387 library SafeMath {
1388     /**
1389      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1390      *
1391      * _Available since v3.4._
1392      */
1393     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1394         unchecked {
1395             uint256 c = a + b;
1396             if (c < a) return (false, 0);
1397             return (true, c);
1398         }
1399     }
1400 
1401     /**
1402      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1403      *
1404      * _Available since v3.4._
1405      */
1406     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1407         unchecked {
1408             if (b > a) return (false, 0);
1409             return (true, a - b);
1410         }
1411     }
1412 
1413     /**
1414      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1415      *
1416      * _Available since v3.4._
1417      */
1418     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1419         unchecked {
1420             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1421             // benefit is lost if 'b' is also tested.
1422             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1423             if (a == 0) return (true, 0);
1424             uint256 c = a * b;
1425             if (c / a != b) return (false, 0);
1426             return (true, c);
1427         }
1428     }
1429 
1430     /**
1431      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1432      *
1433      * _Available since v3.4._
1434      */
1435     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1436         unchecked {
1437             if (b == 0) return (false, 0);
1438             return (true, a / b);
1439         }
1440     }
1441 
1442     /**
1443      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1444      *
1445      * _Available since v3.4._
1446      */
1447     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1448         unchecked {
1449             if (b == 0) return (false, 0);
1450             return (true, a % b);
1451         }
1452     }
1453 
1454     /**
1455      * @dev Returns the addition of two unsigned integers, reverting on
1456      * overflow.
1457      *
1458      * Counterpart to Solidity's `+` operator.
1459      *
1460      * Requirements:
1461      *
1462      * - Addition cannot overflow.
1463      */
1464     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1465         return a + b;
1466     }
1467 
1468     /**
1469      * @dev Returns the subtraction of two unsigned integers, reverting on
1470      * overflow (when the result is negative).
1471      *
1472      * Counterpart to Solidity's `-` operator.
1473      *
1474      * Requirements:
1475      *
1476      * - Subtraction cannot overflow.
1477      */
1478     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1479         return a - b;
1480     }
1481 
1482     /**
1483      * @dev Returns the multiplication of two unsigned integers, reverting on
1484      * overflow.
1485      *
1486      * Counterpart to Solidity's `*` operator.
1487      *
1488      * Requirements:
1489      *
1490      * - Multiplication cannot overflow.
1491      */
1492     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1493         return a * b;
1494     }
1495 
1496     /**
1497      * @dev Returns the integer division of two unsigned integers, reverting on
1498      * division by zero. The result is rounded towards zero.
1499      *
1500      * Counterpart to Solidity's `/` operator.
1501      *
1502      * Requirements:
1503      *
1504      * - The divisor cannot be zero.
1505      */
1506     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1507         return a / b;
1508     }
1509 
1510     /**
1511      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1512      * reverting when dividing by zero.
1513      *
1514      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1515      * opcode (which leaves remaining gas untouched) while Solidity uses an
1516      * invalid opcode to revert (consuming all remaining gas).
1517      *
1518      * Requirements:
1519      *
1520      * - The divisor cannot be zero.
1521      */
1522     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1523         return a % b;
1524     }
1525 
1526     /**
1527      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1528      * overflow (when the result is negative).
1529      *
1530      * CAUTION: This function is deprecated because it requires allocating memory for the error
1531      * message unnecessarily. For custom revert reasons use {trySub}.
1532      *
1533      * Counterpart to Solidity's `-` operator.
1534      *
1535      * Requirements:
1536      *
1537      * - Subtraction cannot overflow.
1538      */
1539     function sub(
1540         uint256 a,
1541         uint256 b,
1542         string memory errorMessage
1543     ) internal pure returns (uint256) {
1544         unchecked {
1545             require(b <= a, errorMessage);
1546             return a - b;
1547         }
1548     }
1549 
1550     /**
1551      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1552      * division by zero. The result is rounded towards zero.
1553      *
1554      * Counterpart to Solidity's `/` operator. Note: this function uses a
1555      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1556      * uses an invalid opcode to revert (consuming all remaining gas).
1557      *
1558      * Requirements:
1559      *
1560      * - The divisor cannot be zero.
1561      */
1562     function div(
1563         uint256 a,
1564         uint256 b,
1565         string memory errorMessage
1566     ) internal pure returns (uint256) {
1567         unchecked {
1568             require(b > 0, errorMessage);
1569             return a / b;
1570         }
1571     }
1572 
1573     /**
1574      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1575      * reverting with custom message when dividing by zero.
1576      *
1577      * CAUTION: This function is deprecated because it requires allocating memory for the error
1578      * message unnecessarily. For custom revert reasons use {tryMod}.
1579      *
1580      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1581      * opcode (which leaves remaining gas untouched) while Solidity uses an
1582      * invalid opcode to revert (consuming all remaining gas).
1583      *
1584      * Requirements:
1585      *
1586      * - The divisor cannot be zero.
1587      */
1588     function mod(
1589         uint256 a,
1590         uint256 b,
1591         string memory errorMessage
1592     ) internal pure returns (uint256) {
1593         unchecked {
1594             require(b > 0, errorMessage);
1595             return a % b;
1596         }
1597     }
1598 }
1599 
1600 
1601 // File contracts/lib/UniswapV2Library.sol
1602 
1603 pragma solidity ^0.8.0;
1604 
1605 
1606 library UniswapV2Library {
1607     using SafeMath for uint256;
1608 
1609     // returns sorted token addresses, used to handle return values from pairs sorted in this order
1610     function sortTokens(address tokenA, address tokenB)
1611         internal
1612         pure
1613         returns (address token0, address token1)
1614     {
1615         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
1616         (token0, token1) = tokenA < tokenB
1617             ? (tokenA, tokenB)
1618             : (tokenB, tokenA);
1619         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
1620     }
1621 
1622     // calculates the CREATE2 address for a pair without making any external calls
1623     function pairFor(
1624         address factory,
1625         address tokenA,
1626         address tokenB
1627     ) internal pure returns (address pair) {
1628         (address token0, address token1) = sortTokens(tokenA, tokenB);
1629         pair = address(
1630             uint160(
1631                 uint256(
1632                     keccak256(
1633                         abi.encodePacked(
1634                             hex'ff',
1635                             factory,
1636                             keccak256(abi.encodePacked(token0, token1)),
1637                             hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
1638                         )
1639                     )
1640                 )
1641             )
1642         );
1643     }
1644 
1645     // fetches and sorts the reserves for a pair
1646     function getReserves(
1647         address factory,
1648         address tokenA,
1649         address tokenB
1650     ) internal view returns (uint256 reserveA, uint256 reserveB) {
1651         (address token0, ) = sortTokens(tokenA, tokenB);
1652         (uint256 reserve0, uint256 reserve1, ) = IUniswapV2Pair(
1653             pairFor(factory, tokenA, tokenB)
1654         ).getReserves();
1655         (reserveA, reserveB) = tokenA == token0
1656             ? (reserve0, reserve1)
1657             : (reserve1, reserve0);
1658     }
1659 
1660     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
1661     function quote(
1662         uint256 amountA,
1663         uint256 reserveA,
1664         uint256 reserveB
1665     ) internal pure returns (uint256 amountB) {
1666         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
1667         require(
1668             reserveA > 0 && reserveB > 0,
1669             'UniswapV2Library: INSUFFICIENT_LIQUIDITY'
1670         );
1671         amountB = amountA.mul(reserveB) / reserveA;
1672     }
1673 
1674     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
1675     function getAmountOut(
1676         uint256 amountIn,
1677         uint256 reserveIn,
1678         uint256 reserveOut,
1679         uint256 amountAfterFee // 9970 = fee 0.3%
1680     ) internal pure returns (uint256 amountOut) {
1681         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
1682         require(
1683             reserveIn > 0 && reserveOut > 0,
1684             'UniswapV2Library: INSUFFICIENT_LIQUIDITY'
1685         );
1686         uint256 amountInWithFee = amountIn.mul(amountAfterFee);
1687         uint256 numerator = amountInWithFee.mul(reserveOut);
1688         uint256 denominator = reserveIn.mul(10000).add(amountInWithFee);
1689         amountOut = numerator / denominator;
1690     }
1691 
1692     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
1693     function getAmountIn(
1694         uint256 amountOut,
1695         uint256 reserveIn,
1696         uint256 reserveOut,
1697         uint256 amountAfterFee // 9970 = fee 0.3%
1698     ) internal pure returns (uint256 amountIn) {
1699         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
1700         require(
1701             reserveIn > 0 && reserveOut > 0,
1702             'UniswapV2Library: INSUFFICIENT_LIQUIDITY'
1703         );
1704         uint256 numerator = reserveIn.mul(amountOut).mul(10000);
1705         uint256 denominator = reserveOut.sub(amountOut).mul(amountAfterFee);
1706         amountIn = (numerator / denominator).add(1);
1707     }
1708 
1709     // performs chained getAmountOut calculations on any number of pairs
1710     function getAmountsOut(
1711         address factory,
1712         uint256 amountIn,
1713         address[] memory path,
1714         uint256 amountAfterFee
1715     ) internal view returns (uint256[] memory amounts) {
1716         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
1717         amounts = new uint256[](path.length);
1718         amounts[0] = amountIn;
1719         for (uint256 i; i < path.length - 1; i++) {
1720             (uint256 reserveIn, uint256 reserveOut) = getReserves(
1721                 factory,
1722                 path[i],
1723                 path[i + 1]
1724             );
1725             amounts[i + 1] = getAmountOut(
1726                 amounts[i],
1727                 reserveIn,
1728                 reserveOut,
1729                 amountAfterFee
1730             );
1731         }
1732     }
1733 
1734     // performs chained getAmountIn calculations on any number of pairs
1735     function getAmountsIn(
1736         address factory,
1737         uint256 amountOut,
1738         address[] memory path,
1739         uint256 amountAfterFee
1740     ) internal view returns (uint256[] memory amounts) {
1741         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
1742         amounts = new uint256[](path.length);
1743         amounts[amounts.length - 1] = amountOut;
1744         for (uint256 i = path.length - 1; i > 0; i--) {
1745             (uint256 reserveIn, uint256 reserveOut) = getReserves(
1746                 factory,
1747                 path[i - 1],
1748                 path[i]
1749             );
1750             amounts[i - 1] = getAmountIn(
1751                 amounts[i],
1752                 reserveIn,
1753                 reserveOut,
1754                 amountAfterFee
1755             );
1756         }
1757     }
1758 }
1759 
1760 
1761 // File contracts/lib/UniswapV3CallbackValidation.sol
1762 
1763 pragma solidity ^0.8.0;
1764 
1765 // This code is forked from @uniswap/v3-periphery due to the library specifying solidity version as =0.7.6
1766 
1767 /// @title Provides functions for deriving a pool address from the factory, tokens, and the fee
1768 library PoolAddress {
1769     bytes32 internal constant POOL_INIT_CODE_HASH =
1770         0xe34f199b19b2b4f47f68442619d555527d244f78a3297ea89325f843f87b8b54;
1771 
1772     /// @notice The identifying key of the pool
1773     struct PoolKey {
1774         address token0;
1775         address token1;
1776         uint24 fee;
1777     }
1778 
1779     /// @notice Returns PoolKey: the ordered tokens with the matched fee levels
1780     /// @param tokenA The first token of a pool, unsorted
1781     /// @param tokenB The second token of a pool, unsorted
1782     /// @param fee The fee level of the pool
1783     /// @return Poolkey The pool details with ordered token0 and token1 assignments
1784     function getPoolKey(
1785         address tokenA,
1786         address tokenB,
1787         uint24 fee
1788     ) internal pure returns (PoolKey memory) {
1789         if (tokenA > tokenB) (tokenA, tokenB) = (tokenB, tokenA);
1790         return PoolKey({token0: tokenA, token1: tokenB, fee: fee});
1791     }
1792 
1793     /// @notice Deterministically computes the pool address given the factory and PoolKey
1794     /// @param factory The Uniswap V3 factory contract address
1795     /// @param key The PoolKey
1796     /// @return pool The contract address of the V3 pool
1797     function computeAddress(address factory, PoolKey memory key)
1798         internal
1799         pure
1800         returns (address pool)
1801     {
1802         require(key.token0 < key.token1);
1803         pool = address(
1804             uint160(
1805                 uint256(
1806                     keccak256(
1807                         abi.encodePacked(
1808                             hex'ff',
1809                             factory,
1810                             keccak256(
1811                                 abi.encode(key.token0, key.token1, key.fee)
1812                             ),
1813                             POOL_INIT_CODE_HASH
1814                         )
1815                     )
1816                 )
1817             )
1818         );
1819     }
1820 }
1821 
1822 /// @notice Provides validation for callbacks from Uniswap V3 Pools
1823 library UniswapV3CallbackValidation {
1824     /// @notice Returns the address of a valid Uniswap V3 Pool
1825     /// @param factory The contract address of the Uniswap V3 factory
1826     /// @param tokenA The contract address of either token0 or token1
1827     /// @param tokenB The contract address of the other token
1828     /// @param fee The fee collected upon every swap in the pool, denominated in hundredths of a bip
1829     /// @return pool The V3 pool contract address
1830     function verifyCallback(
1831         address factory,
1832         address tokenA,
1833         address tokenB,
1834         uint24 fee
1835     ) internal view returns (IUniswapV3Pool pool) {
1836         return
1837             verifyCallback(
1838                 factory,
1839                 PoolAddress.getPoolKey(tokenA, tokenB, fee)
1840             );
1841     }
1842 
1843     /// @notice Returns the address of a valid Uniswap V3 Pool
1844     /// @param factory The contract address of the Uniswap V3 factory
1845     /// @param poolKey The identifying key of the V3 pool
1846     /// @return pool The V3 pool contract address
1847     function verifyCallback(address factory, PoolAddress.PoolKey memory poolKey)
1848         internal
1849         view
1850         returns (IUniswapV3Pool pool)
1851     {
1852         pool = IUniswapV3Pool(PoolAddress.computeAddress(factory, poolKey));
1853         require(msg.sender == address(pool));
1854     }
1855 }
1856 
1857 
1858 // File contracts/ArkenDexV3.sol
1859 
1860 
1861 pragma solidity =0.8.11;
1862 pragma experimental ABIEncoderV2;
1863 
1864 
1865 
1866 
1867 
1868 
1869 
1870 
1871 
1872 
1873 
1874 
1875 
1876 
1877 
1878 
1879 // import 'hardhat/console.sol';
1880 
1881 contract ArkenDexV3 is Ownable {
1882     using SafeERC20 for IERC20;
1883 
1884     uint256 constant MAX_INT = 2**256 - 1;
1885     uint256 public constant _DEADLINE_ = 2**256 - 1;
1886     address public constant _ETH_ = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
1887 
1888     // Uniswap V3
1889     uint160 internal constant MIN_SQRT_RATIO = 4295128739 + 1;
1890     uint160 internal constant MAX_SQRT_RATIO =
1891         1461446703485210103287273052203988822378723970342 - 1;
1892 
1893     address payable public _FEE_WALLET_ADDR_;
1894     address public _DODO_APPROVE_ADDR_;
1895     address public _WETH_;
1896     address public _WETH_DFYN_;
1897     address public _ARKEN_APPROVE_;
1898     address public _UNISWAP_V3_FACTORY_;
1899 
1900     /*
1901     ==============================================================================
1902 
1903     █▀▀ █░█ █▀▀ █▄░█ ▀█▀ █▀
1904     ██▄ ▀▄▀ ██▄ █░▀█ ░█░ ▄█
1905 
1906     ==============================================================================
1907     */
1908     event Swapped(
1909         address srcToken,
1910         address dstToken,
1911         uint256 amountIn,
1912         uint256 returnAmount
1913     );
1914     event FeeWalletUpdated(address newFeeWallet);
1915     event WETHUpdated(address newWETH);
1916     event WETHDfynUpdated(address newWETHDfyn);
1917     event DODOApproveUpdated(address newDODOApproveAddress);
1918     event ArkenApproveUpdated(address newArkenApproveAddress);
1919     event UniswapV3FactoryUpdated(address newUv3Factory);
1920 
1921     /*
1922     ==============================================================================
1923 
1924     █▀▀ █▀█ █▄░█ █▀▀ █ █▀▀ █░█ █▀█ ▄▀█ ▀█▀ █ █▀█ █▄░█ █▀
1925     █▄▄ █▄█ █░▀█ █▀░ █ █▄█ █▄█ █▀▄ █▀█ ░█░ █ █▄█ █░▀█ ▄█
1926 
1927     ==============================================================================
1928     */
1929     constructor(
1930         address _ownerAddress,
1931         address payable _feeWalletAddress,
1932         address _wrappedEther,
1933         address _wrappedEtherDfyn,
1934         address _dodoApproveAddress,
1935         address _arkenApprove,
1936         address _uniswapV3Factory
1937     ) {
1938         transferOwnership(_ownerAddress);
1939         _FEE_WALLET_ADDR_ = _feeWalletAddress;
1940         _DODO_APPROVE_ADDR_ = _dodoApproveAddress;
1941         _WETH_ = _wrappedEther;
1942         _WETH_DFYN_ = _wrappedEtherDfyn;
1943         _ARKEN_APPROVE_ = _arkenApprove;
1944         _UNISWAP_V3_FACTORY_ = _uniswapV3Factory;
1945     }
1946 
1947     receive() external payable {}
1948 
1949     fallback() external payable {}
1950 
1951     function updateFeeWallet(address payable _feeWallet) external onlyOwner {
1952         require(_feeWallet != address(0), 'fee wallet zero address');
1953         _FEE_WALLET_ADDR_ = _feeWallet;
1954         emit FeeWalletUpdated(_FEE_WALLET_ADDR_);
1955     }
1956 
1957     function updateWETH(address _weth) external onlyOwner {
1958         require(_weth != address(0), 'WETH zero address');
1959         _WETH_ = _weth;
1960         emit WETHUpdated(_WETH_);
1961     }
1962 
1963     function updateWETHDfyn(address _weth_dfyn) external onlyOwner {
1964         require(_weth_dfyn != address(0), 'WETH dfyn zero address');
1965         _WETH_DFYN_ = _weth_dfyn;
1966         emit WETHDfynUpdated(_WETH_DFYN_);
1967     }
1968 
1969     function updateDODOApproveAddress(address _dodoApproveAddress)
1970         external
1971         onlyOwner
1972     {
1973         require(_dodoApproveAddress != address(0), 'dodo approve zero address');
1974         _DODO_APPROVE_ADDR_ = _dodoApproveAddress;
1975         emit DODOApproveUpdated(_DODO_APPROVE_ADDR_);
1976     }
1977 
1978     function updateArkenApprove(address _arkenApprove) external onlyOwner {
1979         require(_arkenApprove != address(0), 'arken approve zero address');
1980         _ARKEN_APPROVE_ = _arkenApprove;
1981         emit ArkenApproveUpdated(_ARKEN_APPROVE_);
1982     }
1983 
1984     function updateUniswapV3Factory(address _uv3Factory) external onlyOwner {
1985         require(_uv3Factory != address(0), 'UniswapV3 Factory zero address');
1986         _UNISWAP_V3_FACTORY_ = _uv3Factory;
1987         emit UniswapV3FactoryUpdated(_UNISWAP_V3_FACTORY_);
1988     }
1989 
1990     /*
1991     ==================================================================================
1992 
1993     ▀█▀ █▀█ ▄▀█ █▀▄ █▀▀ ░   ▀█▀ █▀█ ▄▀█ █▀▄ █▀▀ ░   ▀█▀ █▀█ ▄▀█ █▀▄ █▀▀ ░
1994     ░█░ █▀▄ █▀█ █▄▀ ██▄ ▄   ░█░ █▀▄ █▀█ █▄▀ ██▄ ▄   ░█░ █▀▄ █▀█ █▄▀ ██▄ ▄
1995 
1996     ==================================================================================
1997     */
1998 
1999     enum RouterInterface {
2000         UNISWAP_V2,
2001         BAKERY,
2002         VYPER,
2003         VYPER_UNDERLYING,
2004         SADDLE,
2005         DODO_V2,
2006         DODO_V1,
2007         DFYN,
2008         BALANCER,
2009         UNISWAP_V3
2010     }
2011     struct TradeRoute {
2012         address routerAddress;
2013         address lpAddress;
2014         address fromToken;
2015         address toToken;
2016         address from;
2017         address to;
2018         uint32 part;
2019         uint8 direction; // DODO
2020         int16 fromTokenIndex; // Vyper
2021         int16 toTokenIndex; // Vyper
2022         uint16 amountAfterFee; // 9970 = fee 0.3% -- 10000 = no fee
2023         RouterInterface dexInterface; // uint8
2024     }
2025     struct TradeDescription {
2026         address srcToken;
2027         address dstToken;
2028         uint256 amountIn;
2029         uint256 amountOutMin;
2030         address payable to;
2031         TradeRoute[] routes;
2032         bool isRouterSource;
2033         bool isSourceFee;
2034     }
2035     struct TradeData {
2036         uint256 amountIn;
2037     }
2038     struct UniswapV3CallbackData {
2039         address token0;
2040         address token1;
2041         uint24 fee;
2042     }
2043 
2044     function trade(TradeDescription memory desc) external payable {
2045         require(desc.amountIn > 0, 'Amount-in needs to be more than zero');
2046         require(
2047             desc.amountOutMin > 0,
2048             'Amount-out minimum needs to be more than zero'
2049         );
2050         if (_ETH_ == desc.srcToken) {
2051             require(
2052                 desc.amountIn == msg.value,
2053                 'Ether value not match amount-in'
2054             );
2055             require(
2056                 desc.isRouterSource,
2057                 'Source token Ether requires isRouterSource=true'
2058             );
2059         }
2060 
2061         uint256 beforeDstAmt = _getBalance(desc.dstToken, desc.to);
2062 
2063         uint256 returnAmount = _trade(desc);
2064 
2065         if (returnAmount > 0) {
2066             if (_ETH_ == desc.dstToken) {
2067                 (bool sent, ) = desc.to.call{value: returnAmount}('');
2068                 require(sent, 'Failed to send Ether');
2069             } else {
2070                 IERC20(desc.dstToken).safeTransfer(desc.to, returnAmount);
2071             }
2072         }
2073 
2074         uint256 receivedAmt = _getBalance(desc.dstToken, desc.to) -
2075             beforeDstAmt;
2076         require(
2077             receivedAmt >= desc.amountOutMin,
2078             'Received token is not enough'
2079         );
2080 
2081         emit Swapped(desc.srcToken, desc.dstToken, desc.amountIn, receivedAmt);
2082     }
2083 
2084     function _trade(TradeDescription memory desc)
2085         internal
2086         returns (uint256 returnAmount)
2087     {
2088         TradeData memory data = TradeData({amountIn: desc.amountIn});
2089         if (desc.isSourceFee) {
2090             if (_ETH_ == desc.srcToken) {
2091                 data.amountIn = _collectFee(desc.amountIn, desc.srcToken);
2092             } else {
2093                 uint256 fee = _calculateFee(desc.amountIn);
2094                 require(fee < desc.amountIn, 'Fee exceeds amount');
2095                 _transferFromSender(
2096                     desc.srcToken,
2097                     _FEE_WALLET_ADDR_,
2098                     fee,
2099                     desc.srcToken,
2100                     data
2101                 );
2102             }
2103         }
2104         if (desc.isRouterSource && _ETH_ != desc.srcToken) {
2105             _transferFromSender(
2106                 desc.srcToken,
2107                 address(this),
2108                 data.amountIn,
2109                 desc.srcToken,
2110                 data
2111             );
2112         }
2113         if (_ETH_ == desc.srcToken) {
2114             _wrapEther(_WETH_, address(this).balance);
2115         }
2116 
2117         for (uint256 i = 0; i < desc.routes.length; i++) {
2118             _tradeRoute(desc.routes[i], desc, data);
2119         }
2120 
2121         if (_ETH_ == desc.dstToken) {
2122             returnAmount = IERC20(_WETH_).balanceOf(address(this));
2123             _unwrapEther(_WETH_, returnAmount);
2124         } else {
2125             returnAmount = IERC20(desc.dstToken).balanceOf(address(this));
2126         }
2127         if (!desc.isSourceFee) {
2128             require(
2129                 returnAmount >= desc.amountOutMin && returnAmount > 0,
2130                 'Return amount is not enough'
2131             );
2132             returnAmount = _collectFee(returnAmount, desc.dstToken);
2133         }
2134     }
2135 
2136     /*
2137 
2138     █▀▄ █▀▀ ▀▄▀
2139     █▄▀ ██▄ █░█
2140 
2141     */
2142 
2143     function _tradeRoute(
2144         TradeRoute memory route,
2145         TradeDescription memory desc,
2146         TradeData memory data
2147     ) internal {
2148         require(
2149             route.part <= 100000000,
2150             'Route percentage can not exceed 100000000'
2151         );
2152         require(
2153             route.fromToken != _ETH_ && route.toToken != _ETH_,
2154             'TradeRoute from/to token cannot be Ether'
2155         );
2156         if (route.from == address(1)) {
2157             require(
2158                 route.fromToken == desc.srcToken,
2159                 'Cannot transfer token from msg.sender'
2160             );
2161         }
2162         if (
2163             !desc.isSourceFee &&
2164             (route.toToken == desc.dstToken ||
2165                 (_ETH_ == desc.dstToken && _WETH_ == route.toToken))
2166         ) {
2167             require(
2168                 route.to == address(0),
2169                 'Destination swap have to be ArkenDex'
2170             );
2171         }
2172         uint256 amountIn;
2173         if (route.from == address(0)) {
2174             amountIn =
2175                 (IERC20(
2176                     route.fromToken == _WETH_DFYN_ ? _WETH_ : route.fromToken
2177                 ).balanceOf(address(this)) * route.part) /
2178                 100000000;
2179         } else if (route.from == address(1)) {
2180             amountIn = (data.amountIn * route.part) / 100000000;
2181         }
2182         if (route.dexInterface == RouterInterface.UNISWAP_V2) {
2183             _tradeUniswapV2(route, amountIn, desc, data);
2184         } else if (route.dexInterface == RouterInterface.BAKERY) {
2185             _tradeBakery(route, amountIn, desc, data);
2186         } else if (route.dexInterface == RouterInterface.DODO_V2) {
2187             _tradeDODOV2(route, amountIn, desc, data);
2188         } else if (route.dexInterface == RouterInterface.DODO_V1) {
2189             _tradeDODOV1(route, amountIn);
2190         } else if (route.dexInterface == RouterInterface.DFYN) {
2191             _tradeDfyn(route, amountIn, desc, data);
2192         } else if (route.dexInterface == RouterInterface.VYPER) {
2193             _tradeVyper(route, amountIn);
2194         } else if (route.dexInterface == RouterInterface.VYPER_UNDERLYING) {
2195             _tradeVyperUnderlying(route, amountIn);
2196         } else if (route.dexInterface == RouterInterface.SADDLE) {
2197             _tradeSaddle(route, amountIn);
2198         } else if (route.dexInterface == RouterInterface.BALANCER) {
2199             _tradeBalancer(route, amountIn);
2200         } else if (route.dexInterface == RouterInterface.UNISWAP_V3) {
2201             _tradeUniswapV3(route, amountIn, desc);
2202         } else {
2203             revert('unknown router interface');
2204         }
2205     }
2206 
2207     function _tradeUniswapV2(
2208         TradeRoute memory route,
2209         uint256 amountIn,
2210         TradeDescription memory desc,
2211         TradeData memory data
2212     ) internal {
2213         if (route.from == address(0)) {
2214             IERC20(route.fromToken).safeTransfer(route.lpAddress, amountIn);
2215         } else if (route.from == address(1)) {
2216             _transferFromSender(
2217                 route.fromToken,
2218                 route.lpAddress,
2219                 amountIn,
2220                 desc.srcToken,
2221                 data
2222             );
2223         }
2224         IUniswapV2Pair pair = IUniswapV2Pair(route.lpAddress);
2225         (uint256 reserve0, uint256 reserve1, ) = pair.getReserves();
2226         (uint256 reserveFrom, uint256 reserveTo) = route.fromToken ==
2227             pair.token0()
2228             ? (reserve0, reserve1)
2229             : (reserve1, reserve0);
2230         amountIn =
2231             IERC20(route.fromToken).balanceOf(route.lpAddress) -
2232             reserveFrom;
2233         uint256 amountOut = UniswapV2Library.getAmountOut(
2234             amountIn,
2235             reserveFrom,
2236             reserveTo,
2237             route.amountAfterFee
2238         );
2239         address to = route.to;
2240         if (to == address(0)) to = address(this);
2241         if (to == address(1)) to = desc.to;
2242         if (route.toToken == pair.token0()) {
2243             pair.swap(amountOut, 0, to, '');
2244         } else {
2245             pair.swap(0, amountOut, to, '');
2246         }
2247     }
2248 
2249     function _tradeDfyn(
2250         TradeRoute memory route,
2251         uint256 amountIn,
2252         TradeDescription memory desc,
2253         TradeData memory data
2254     ) internal {
2255         if (route.fromToken == _WETH_DFYN_) {
2256             _unwrapEther(_WETH_, amountIn);
2257             _wrapEther(_WETH_DFYN_, amountIn);
2258         }
2259         _tradeUniswapV2(route, amountIn, desc, data);
2260         if (route.toToken == _WETH_DFYN_) {
2261             uint256 amountOut = IERC20(_WETH_DFYN_).balanceOf(address(this));
2262             _unwrapEther(_WETH_DFYN_, amountOut);
2263             _wrapEther(_WETH_, amountOut);
2264         }
2265     }
2266 
2267     function _tradeBakery(
2268         TradeRoute memory route,
2269         uint256 amountIn,
2270         TradeDescription memory desc,
2271         TradeData memory data
2272     ) internal {
2273         if (route.from == address(0)) {
2274             IERC20(route.fromToken).safeTransfer(route.lpAddress, amountIn);
2275         } else if (route.from == address(1)) {
2276             _transferFromSender(
2277                 route.fromToken,
2278                 route.lpAddress,
2279                 amountIn,
2280                 desc.srcToken,
2281                 data
2282             );
2283         }
2284         IBakeryPair pair = IBakeryPair(route.lpAddress);
2285         (uint256 reserve0, uint256 reserve1, ) = pair.getReserves();
2286         (uint256 reserveFrom, uint256 reserveTo) = route.fromToken ==
2287             pair.token0()
2288             ? (reserve0, reserve1)
2289             : (reserve1, reserve0);
2290         amountIn =
2291             IERC20(route.fromToken).balanceOf(route.lpAddress) -
2292             reserveFrom;
2293         uint256 amountOut = UniswapV2Library.getAmountOut(
2294             amountIn,
2295             reserveFrom,
2296             reserveTo,
2297             route.amountAfterFee
2298         );
2299         address to = route.to;
2300         if (to == address(0)) to = address(this);
2301         if (to == address(1)) to = desc.to;
2302         if (route.toToken == pair.token0()) {
2303             pair.swap(amountOut, 0, to);
2304         } else {
2305             pair.swap(0, amountOut, to);
2306         }
2307     }
2308 
2309     function _tradeUniswapV3(
2310         TradeRoute memory route,
2311         uint256 amountIn,
2312         TradeDescription memory desc
2313     ) internal {
2314         require(route.from == address(0), 'route.from should be zero address');
2315         IUniswapV3Pool pool = IUniswapV3Pool(route.lpAddress);
2316         bool zeroForOne = pool.token0() == route.fromToken;
2317         address to = route.to;
2318         if (to == address(0)) to = address(this);
2319         if (to == address(1)) to = desc.to;
2320         pool.swap(
2321             to,
2322             zeroForOne,
2323             int256(amountIn),
2324             zeroForOne ? MIN_SQRT_RATIO : MAX_SQRT_RATIO,
2325             abi.encode(
2326                 UniswapV3CallbackData({
2327                     token0: pool.token0(),
2328                     token1: pool.token1(),
2329                     fee: pool.fee()
2330                 })
2331             )
2332         );
2333     }
2334 
2335     function _tradeDODOV2(
2336         TradeRoute memory route,
2337         uint256 amountIn,
2338         TradeDescription memory desc,
2339         TradeData memory data
2340     ) internal {
2341         if (route.from == address(0)) {
2342             IERC20(route.fromToken).safeTransfer(route.lpAddress, amountIn);
2343         } else if (route.from == address(1)) {
2344             _transferFromSender(
2345                 route.fromToken,
2346                 route.lpAddress,
2347                 amountIn,
2348                 desc.srcToken,
2349                 data
2350             );
2351         }
2352         address to = route.to;
2353         if (to == address(0)) to = address(this);
2354         if (to == address(1)) to = desc.to;
2355         if (IDODOV2(route.lpAddress)._BASE_TOKEN_() == route.fromToken) {
2356             IDODOV2(route.lpAddress).sellBase(to);
2357         } else {
2358             IDODOV2(route.lpAddress).sellQuote(to);
2359         }
2360     }
2361 
2362     function _tradeDODOV1(TradeRoute memory route, uint256 amountIn) internal {
2363         require(route.from == address(0), 'route.from should be zero address');
2364         _increaseAllowance(route.fromToken, _DODO_APPROVE_ADDR_, amountIn);
2365         address[] memory dodoPairs = new address[](1);
2366         dodoPairs[0] = route.lpAddress;
2367         IDODOV2Proxy(route.routerAddress).dodoSwapV1(
2368             route.fromToken,
2369             route.toToken,
2370             amountIn,
2371             1,
2372             dodoPairs,
2373             route.direction,
2374             false,
2375             _DEADLINE_
2376         );
2377     }
2378 
2379     function _tradeVyper(TradeRoute memory route, uint256 amountIn) internal {
2380         require(route.from == address(0), 'route.from should be zero address');
2381         _increaseAllowance(route.fromToken, route.routerAddress, amountIn);
2382         IVyperSwap(route.routerAddress).exchange(
2383             route.fromTokenIndex,
2384             route.toTokenIndex,
2385             amountIn,
2386             0
2387         );
2388     }
2389 
2390     function _tradeVyperUnderlying(TradeRoute memory route, uint256 amountIn)
2391         internal
2392     {
2393         require(route.from == address(0), 'route.from should be zero address');
2394         _increaseAllowance(route.fromToken, route.routerAddress, amountIn);
2395         IVyperUnderlyingSwap(route.routerAddress).exchange_underlying(
2396             route.fromTokenIndex,
2397             route.toTokenIndex,
2398             amountIn,
2399             0
2400         );
2401     }
2402 
2403     function _tradeSaddle(TradeRoute memory route, uint256 amountIn) internal {
2404         require(route.from == address(0), 'route.from should be zero address');
2405         _increaseAllowance(route.fromToken, route.routerAddress, amountIn);
2406         ISaddleDex dex = ISaddleDex(route.routerAddress);
2407         uint8 tokenIndexFrom = dex.getTokenIndex(route.fromToken);
2408         uint8 tokenIndexTo = dex.getTokenIndex(route.toToken);
2409         dex.swap(tokenIndexFrom, tokenIndexTo, amountIn, 0, _DEADLINE_);
2410     }
2411 
2412     function _tradeBalancer(TradeRoute memory route, uint256 amountIn)
2413         internal
2414     {
2415         require(route.from == address(0), 'route.from should be zero address');
2416         _increaseAllowance(route.fromToken, route.routerAddress, amountIn);
2417         IBalancerRouter(route.routerAddress).swap(
2418             Balancer.SingleSwap({
2419                 poolId: IBalancerPool(route.lpAddress).getPoolId(),
2420                 kind: Balancer.SwapKind.GIVEN_IN,
2421                 assetIn: IAsset(route.fromToken),
2422                 assetOut: IAsset(route.toToken),
2423                 amount: amountIn,
2424                 userData: '0x'
2425             }),
2426             Balancer.FundManagement({
2427                 sender: address(this),
2428                 fromInternalBalance: false,
2429                 recipient: payable(this),
2430                 toInternalBalance: false
2431             }),
2432             0,
2433             _DEADLINE_
2434         );
2435     }
2436 
2437     function uniswapV3SwapCallback(
2438         int256 amount0Delta,
2439         int256 amount1Delta,
2440         bytes calldata _data
2441     ) external {
2442         UniswapV3CallbackData memory data = abi.decode(
2443             _data,
2444             (UniswapV3CallbackData)
2445         );
2446         IUniswapV3Pool pool = UniswapV3CallbackValidation.verifyCallback(
2447             _UNISWAP_V3_FACTORY_,
2448             data.token0,
2449             data.token1,
2450             data.fee
2451         );
2452         require(
2453             address(pool) == msg.sender,
2454             'UV3Callback: msg.sender is not UniswapV3 Pool'
2455         );
2456         if (amount0Delta > 0) {
2457             IERC20(data.token0).safeTransfer(msg.sender, uint256(amount0Delta));
2458         } else if (amount1Delta > 0) {
2459             IERC20(data.token1).safeTransfer(msg.sender, uint256(amount1Delta));
2460         }
2461     }
2462 
2463     /*
2464 
2465     █▀▀ █▀█ █░░ █░░ █▀▀ █▀▀ ▀█▀   █▀▀ █▀▀ █▀▀
2466     █▄▄ █▄█ █▄▄ █▄▄ ██▄ █▄▄ ░█░   █▀░ ██▄ ██▄
2467 
2468     */
2469 
2470     function _collectFee(uint256 amount, address token)
2471         internal
2472         returns (uint256 remainingAmount)
2473     {
2474         uint256 fee = _calculateFee(amount);
2475         require(fee < amount, 'Fee exceeds amount');
2476         remainingAmount = amount - fee;
2477         if (_ETH_ == token) {
2478             (bool sent, ) = _FEE_WALLET_ADDR_.call{value: fee}('');
2479             require(sent, 'Failed to send Ether too fee');
2480         } else {
2481             IERC20(token).safeTransfer(_FEE_WALLET_ADDR_, fee);
2482         }
2483     }
2484 
2485     function _calculateFee(uint256 amount) internal pure returns (uint256 fee) {
2486         return amount / 1000;
2487     }
2488 
2489     // internal functions
2490 
2491     function _transferFromSender(
2492         address token,
2493         address to,
2494         uint256 amount,
2495         address srcToken,
2496         TradeData memory data
2497     ) internal {
2498         data.amountIn = data.amountIn - amount;
2499         if (srcToken != _ETH_) {
2500             IArkenApprove(_ARKEN_APPROVE_).transferToken(
2501                 address(token),
2502                 msg.sender,
2503                 to,
2504                 amount
2505             );
2506         } else {
2507             _wrapEther(_WETH_, amount);
2508             if (to != address(this)) {
2509                 IERC20(_WETH_).safeTransfer(to, amount);
2510             }
2511         }
2512     }
2513 
2514     function _wrapEther(address weth, uint256 amount) internal {
2515         IWETH(weth).deposit{value: amount}();
2516     }
2517 
2518     function _unwrapEther(address weth, uint256 amount) internal {
2519         IWETH(weth).withdraw(amount);
2520     }
2521 
2522     function _increaseAllowance(
2523         address token,
2524         address spender,
2525         uint256 amount
2526     ) internal {
2527         uint256 allowance = IERC20(token).allowance(address(this), spender);
2528         if (amount > allowance) {
2529             uint256 increaseAmount = MAX_INT - allowance;
2530             IERC20(token).safeIncreaseAllowance(spender, increaseAmount);
2531         }
2532     }
2533 
2534     function _getBalance(address token, address account)
2535         internal
2536         view
2537         returns (uint256)
2538     {
2539         if (_ETH_ == token) {
2540             return account.balance;
2541         } else {
2542             return IERC20(token).balanceOf(account);
2543         }
2544     }
2545 
2546     /*™
2547 
2548     █▀▄ █▀▀ █░█
2549     █▄▀ ██▄ ▀▄▀
2550 
2551     */
2552     function testTransfer(TradeDescription memory desc)
2553         external
2554         payable
2555         returns (uint256 returnAmount)
2556     {
2557         IERC20 dstToken = IERC20(desc.dstToken);
2558         returnAmount = _trade(desc);
2559         uint256 beforeAmount = dstToken.balanceOf(desc.to);
2560         dstToken.safeTransfer(desc.to, returnAmount);
2561         uint256 afterAmount = dstToken.balanceOf(desc.to);
2562         uint256 got = afterAmount - beforeAmount;
2563         require(got == returnAmount, 'ArkenTester: Has Tax');
2564     }
2565 }