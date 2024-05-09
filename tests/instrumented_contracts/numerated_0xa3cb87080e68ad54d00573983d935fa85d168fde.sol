1 // SPDX-License-Identifier: AGPL-3.0-only
2 // v2.0.03200148
3 
4 /*
5   _____        __ _       _ _         ____  _ _         _
6  |_   _|      / _(_)     (_) |       |  _ \(_) |       (_)
7    | |  _ __ | |_ _ _ __  _| |_ _   _| |_) |_| |_       _  ___
8    | | | '_ \|  _| | '_ \| | __| | | |  _ <| | __|     | |/ _ \
9   _| |_| | | | | | | | | | | |_| |_| | |_) | | |_   _  | | (_) |
10  |_____|_| |_|_| |_|_| |_|_|\__|\__, |____/|_|\__| (_) |_|\___/
11                                  __/ |
12                                 |___/
13   v2
14 */
15 // InfinityBit Token (IBIT) - v2
16 // https://infinitybit.io
17 // TG: https://t.me/infinitybit_io
18 // Twitter: https://twitter.com/infinitybit_io
19 
20 pragma solidity 0.8.18;
21 
22 
23 // License: MIT
24 // pragma solidity ^0.8.0;
25 /**
26  * @dev Collection of functions related to the address type
27  */
28 library Address {
29     function isContract(address account) internal view returns (bool) {
30         // This method relies on extcodesize/address.code.length, which returns 0
31         // for contracts in construction, since the code is only stored at the end
32         // of the constructor execution.
33 
34         return account.code.length > 0;
35     }
36 
37     /**
38      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
39      * `recipient`, forwarding all available gas and reverting on errors.
40      *
41      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
42      * of certain opcodes, possibly making contracts go over the 2300 gas limit
43      * imposed by `transfer`, making them unable to receive funds via
44      * `transfer`. {sendValue} removes this limitation.
45      *
46      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
47      *
48      * IMPORTANT: because control is transferred to `recipient`, care must be
49      * taken to not create reentrancy vulnerabilities. Consider using
50      * {ReentrancyGuard} or the
51      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
52      */
53     function sendValue(address payable recipient, uint256 amount) internal {
54         require(address(this).balance >= amount, "Address: insufficient balance");
55 
56         (bool success, ) = recipient.call{value: amount}("");
57         require(success, "Address: unable to send value, recipient may have reverted");
58     }
59 
60     /**
61      * @dev Performs a Solidity function call using a low level `call`. A
62      * plain `call` is an unsafe replacement for a function call: use this
63      * function instead.
64      *
65      * If `target` reverts with a revert reason, it is bubbled up by this
66      * function (like regular Solidity function calls).
67      *
68      * Returns the raw returned data. To convert to the expected return value,
69      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
70      *
71      * Requirements:
72      *
73      * - `target` must be a contract.
74      * - calling `target` with `data` must not revert.
75      *
76      * _Available since v3.1._
77      */
78     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
79         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
80     }
81 
82     /**
83      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
84      * `errorMessage` as a fallback revert reason when `target` reverts.
85      *
86      * _Available since v3.1._
87      */
88     function functionCall(
89         address target,
90         bytes memory data,
91         string memory errorMessage
92     ) internal returns (bytes memory) {
93         return functionCallWithValue(target, data, 0, errorMessage);
94     }
95 
96     /**
97      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
98      * but also transferring `value` wei to `target`.
99      *
100      * Requirements:
101      *
102      * - the calling contract must have an ETH balance of at least `value`.
103      * - the called Solidity function must be `payable`.
104      *
105      * _Available since v3.1._
106      */
107     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
108         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
109     }
110 
111     /**
112      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
113      * with `errorMessage` as a fallback revert reason when `target` reverts.
114      *
115      * _Available since v3.1._
116      */
117     function functionCallWithValue(
118         address target,
119         bytes memory data,
120         uint256 value,
121         string memory errorMessage
122     ) internal returns (bytes memory) {
123         require(address(this).balance >= value, "Address: insufficient balance for call");
124         (bool success, bytes memory returndata) = target.call{value: value}(data);
125         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
126     }
127 
128     /**
129      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
130      * but performing a static call.
131      *
132      * _Available since v3.3._
133      */
134     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
135         return functionStaticCall(target, data, "Address: low-level static call failed");
136     }
137 
138     /**
139      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
140      * but performing a static call.
141      *
142      * _Available since v3.3._
143      */
144     function functionStaticCall(
145         address target,
146         bytes memory data,
147         string memory errorMessage
148     ) internal view returns (bytes memory) {
149         (bool success, bytes memory returndata) = target.staticcall(data);
150         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
155      * but performing a delegate call.
156      *
157      * _Available since v3.4._
158      */
159     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
160         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
161     }
162 
163     /**
164      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
165      * but performing a delegate call.
166      *
167      * _Available since v3.4._
168      */
169     function functionDelegateCall(
170         address target,
171         bytes memory data,
172         string memory errorMessage
173     ) internal returns (bytes memory) {
174         (bool success, bytes memory returndata) = target.delegatecall(data);
175         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
176     }
177 
178     /**
179      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
180      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
181      *
182      * _Available since v4.8._
183      */
184     function verifyCallResultFromTarget(
185         address target,
186         bool success,
187         bytes memory returndata,
188         string memory errorMessage
189     ) internal view returns (bytes memory) {
190         if (success) {
191             if (returndata.length == 0) {
192                 // only check isContract if the call was successful and the return data is empty
193                 // otherwise we already know that it was a contract
194                 require(isContract(target), "Address: call to non-contract");
195             }
196             return returndata;
197         } else {
198             _revert(returndata, errorMessage);
199         }
200     }
201 
202     /**
203      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
204      * revert reason or using the provided one.
205      *
206      * _Available since v4.3._
207      */
208     function verifyCallResult(
209         bool success,
210         bytes memory returndata,
211         string memory errorMessage
212     ) internal pure returns (bytes memory) {
213         if (success) {
214             return returndata;
215         } else {
216             _revert(returndata, errorMessage);
217         }
218     }
219 
220     function _revert(bytes memory returndata, string memory errorMessage) private pure {
221         // Look for revert reason and bubble it up if present
222         if (returndata.length > 0) {
223             // The easiest way to bubble the revert reason is using memory via assembly
224             /// @solidity memory-safe-assembly
225             assembly {
226                 let returndata_size := mload(returndata)
227                 revert(add(32, returndata), returndata_size)
228             }
229         } else {
230             revert(errorMessage);
231         }
232     }
233 }
234 
235 /**
236  * @dev Provides information about the current execution context, including the
237  * sender of the transaction and its data. While these are generally available
238  * via msg.sender and msg.data, they should not be accessed in such a direct
239  * manner, since when dealing with meta-transactions the account sending and
240  * paying for execution may not be the actual sender (as far as an application
241  * is concerned).
242  *
243  * This contract is only required for intermediate, library-like contracts.
244  */
245 abstract contract Context {
246     function _msgSender() internal view virtual returns (address) {
247         return msg.sender;
248     }
249 
250     function _msgData() internal view virtual returns (bytes calldata) {
251         return msg.data;
252     }
253 }
254 
255 /**
256  * @dev Contract module which provides a basic access control mechanism, where
257  * there is an account (an owner) that can be granted exclusive access to
258  * specific functions.
259  *
260  * By default, the owner account will be the one that deploys the contract. This
261  * can later be changed with {transferOwnership}.
262  *
263  * This module is used through inheritance. It will make available the modifier
264  * `onlyOwner`, which can be applied to your functions to restrict their use to
265  * the owner.
266  */
267 abstract contract Ownable is Context {
268     address private _owner;
269 
270     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
271 
272     /**
273      * @dev Initializes the contract setting the deployer as the initial owner.
274      */
275     constructor() {
276         _transferOwnership(_msgSender());
277     }
278 
279     /**
280      * @dev Throws if called by any account other than the owner.
281      */
282     modifier onlyOwner() {
283         _checkOwner();
284         _;
285     }
286 
287     /**
288      * @dev Returns the address of the current owner.
289      */
290     function owner() public view virtual returns (address) {
291         return _owner;
292     }
293 
294     /**
295      * @dev Throws if the sender is not the owner.
296      */
297     function _checkOwner() internal view virtual {
298         require(owner() == _msgSender(), "Ownable: caller is not the owner");
299     }
300 
301     /**
302      * @dev Leaves the contract without owner. It will not be possible to call
303      * `onlyOwner` functions. Can only be called by the current owner.
304      *
305      * NOTE: Renouncing ownership will leave the contract without an owner,
306      * thereby disabling any functionality that is only available to the owner.
307      */
308     function renounceOwnership() public virtual onlyOwner {
309         _transferOwnership(address(0));
310     }
311 
312     /**
313      * @dev Transfers ownership of the contract to a new account (`newOwner`).
314      * Can only be called by the current owner.
315      */
316     function transferOwnership(address newOwner) public virtual onlyOwner {
317         require(newOwner != address(0), "Ownable: new owner is the zero address");
318         _transferOwnership(newOwner);
319     }
320 
321     /**
322      * @dev Transfers ownership of the contract to a new account (`newOwner`).
323      * Internal function without access restriction.
324      */
325     function _transferOwnership(address newOwner) internal virtual {
326         address oldOwner = _owner;
327         _owner = newOwner;
328         emit OwnershipTransferred(oldOwner, newOwner);
329     }
330 }
331 
332 /**
333  * @dev Interface of the ERC20 standard as defined in the EIP.
334  */
335 interface IERC20 {
336     /**
337      * @dev Emitted when `value` tokens are moved from one account (`from`) to
338      * another (`to`).
339      *
340      * Note that `value` may be zero.
341      */
342     event Transfer(address indexed from, address indexed to, uint256 value);
343 
344     /**
345      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
346      * a call to {approve}. `value` is the new allowance.
347      */
348     event Approval(address indexed owner, address indexed spender, uint256 value);
349 
350     /**
351      * @dev Returns the amount of tokens in existence.
352      */
353     function totalSupply() external view returns (uint256);
354 
355     /**
356      * @dev Returns the amount of tokens owned by `account`.
357      */
358     function balanceOf(address account) external view returns (uint256);
359 
360     /**
361      * @dev Moves `amount` tokens from the caller's account to `to`.
362      *
363      * Returns a boolean value indicating whether the operation succeeded.
364      *
365      * Emits a {Transfer} event.
366      */
367     function transfer(address to, uint256 amount) external returns (bool);
368 
369     /**
370      * @dev Returns the remaining number of tokens that `spender` will be
371      * allowed to spend on behalf of `owner` through {transferFrom}. This is
372      * zero by default.
373      *
374      * This value changes when {approve} or {transferFrom} are called.
375      */
376     function allowance(address owner, address spender) external view returns (uint256);
377 
378     /**
379      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
380      *
381      * Returns a boolean value indicating whether the operation succeeded.
382      *
383      * IMPORTANT: Beware that changing an allowance with this method brings the risk
384      * that someone may use both the old and the new allowance by unfortunate
385      * transaction ordering. One possible solution to mitigate this race
386      * condition is to first reduce the spender's allowance to 0 and set the
387      * desired value afterwards:
388      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
389      *
390      * Emits an {Approval} event.
391      */
392     function approve(address spender, uint256 amount) external returns (bool);
393 
394     /**
395      * @dev Moves `amount` tokens from `from` to `to` using the
396      * allowance mechanism. `amount` is then deducted from the caller's
397      * allowance.
398      *
399      * Returns a boolean value indicating whether the operation succeeded.
400      *
401      * Emits a {Transfer} event.
402      */
403     function transferFrom(address from, address to, uint256 amount) external returns (bool);
404 }
405 
406 // License: GPL-3.0
407 // https://github.com/Uniswap
408 
409 // pragma solidity ^0.8.0;
410 
411 interface IUniswapV2Router01 {
412     function factory() external pure returns (address);
413     function WETH() external pure returns (address);
414 
415     function addLiquidity(
416         address tokenA,
417         address tokenB,
418         uint amountADesired,
419         uint amountBDesired,
420         uint amountAMin,
421         uint amountBMin,
422         address to,
423         uint deadline
424     ) external returns (uint amountA, uint amountB, uint liquidity);
425     function addLiquidityETH(
426         address token,
427         uint amountTokenDesired,
428         uint amountTokenMin,
429         uint amountETHMin,
430         address to,
431         uint deadline
432     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
433     function removeLiquidity(
434         address tokenA,
435         address tokenB,
436         uint liquidity,
437         uint amountAMin,
438         uint amountBMin,
439         address to,
440         uint deadline
441     ) external returns (uint amountA, uint amountB);
442     function removeLiquidityETH(
443         address token,
444         uint liquidity,
445         uint amountTokenMin,
446         uint amountETHMin,
447         address to,
448         uint deadline
449     ) external returns (uint amountToken, uint amountETH);
450     function removeLiquidityWithPermit(
451         address tokenA,
452         address tokenB,
453         uint liquidity,
454         uint amountAMin,
455         uint amountBMin,
456         address to,
457         uint deadline,
458         bool approveMax, uint8 v, bytes32 r, bytes32 s
459     ) external returns (uint amountA, uint amountB);
460     function removeLiquidityETHWithPermit(
461         address token,
462         uint liquidity,
463         uint amountTokenMin,
464         uint amountETHMin,
465         address to,
466         uint deadline,
467         bool approveMax, uint8 v, bytes32 r, bytes32 s
468     ) external returns (uint amountToken, uint amountETH);
469     function swapExactTokensForTokens(
470         uint amountIn,
471         uint amountOutMin,
472         address[] calldata path,
473         address to,
474         uint deadline
475     ) external returns (uint[] memory amounts);
476     function swapTokensForExactTokens(
477         uint amountOut,
478         uint amountInMax,
479         address[] calldata path,
480         address to,
481         uint deadline
482     ) external returns (uint[] memory amounts);
483     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
484     external
485     payable
486     returns (uint[] memory amounts);
487     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
488     external
489     returns (uint[] memory amounts);
490     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
491     external
492     returns (uint[] memory amounts);
493     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
494     external
495     payable
496     returns (uint[] memory amounts);
497 
498     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
499     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
500     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
501     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
502     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
503 }
504 
505 interface IUniswapV2Router02 is IUniswapV2Router01 {
506     function removeLiquidityETHSupportingFeeOnTransferTokens(
507         address token,
508         uint liquidity,
509         uint amountTokenMin,
510         uint amountETHMin,
511         address to,
512         uint deadline
513     ) external returns (uint amountETH);
514     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
515         address token,
516         uint liquidity,
517         uint amountTokenMin,
518         uint amountETHMin,
519         address to,
520         uint deadline,
521         bool approveMax, uint8 v, bytes32 r, bytes32 s
522     ) external returns (uint amountETH);
523 
524     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
525         uint amountIn,
526         uint amountOutMin,
527         address[] calldata path,
528         address to,
529         uint deadline
530     ) external;
531     function swapExactETHForTokensSupportingFeeOnTransferTokens(
532         uint amountOutMin,
533         address[] calldata path,
534         address to,
535         uint deadline
536     ) external payable;
537     function swapExactTokensForETHSupportingFeeOnTransferTokens(
538         uint amountIn,
539         uint amountOutMin,
540         address[] calldata path,
541         address to,
542         uint deadline
543     ) external;
544 }
545 
546 
547 // License: GPL-3.0
548 // https://github.com/Uniswap
549 
550 // pragma solidity ^0.8.0;
551 
552 interface IUniswapV2Factory {
553     event PairCreated(
554         address indexed token0,
555         address indexed token1,
556         address pair,
557         uint256
558     );
559 
560     function feeTo() external view returns (address);
561 
562     function feeToSetter() external view returns (address);
563 
564     function getPair(address tokenA, address tokenB)
565     external
566     view
567     returns (address pair);
568 
569     function allPairs(uint256) external view returns (address pair);
570 
571     function allPairsLength() external view returns (uint256);
572 
573     function createPair(address tokenA, address tokenB)
574     external
575     returns (address pair);
576 
577     function setFeeTo(address) external;
578 
579     function setFeeToSetter(address) external;
580 }
581 
582 
583 // License: GPL-3.0
584 // https://github.com/Uniswap
585 
586 // pragma solidity >=0.8.0;
587 
588 interface IUniswapV2Pair {
589     event Approval(address indexed owner, address indexed spender, uint value);
590     event Transfer(address indexed from, address indexed to, uint value);
591 
592     function name() external pure returns (string memory);
593     function symbol() external pure returns (string memory);
594     function decimals() external pure returns (uint8);
595     function totalSupply() external view returns (uint);
596     function balanceOf(address owner) external view returns (uint);
597     function allowance(address owner, address spender) external view returns (uint);
598 
599     function approve(address spender, uint value) external returns (bool);
600     function transfer(address to, uint value) external returns (bool);
601     function transferFrom(address from, address to, uint value) external returns (bool);
602 
603     function DOMAIN_SEPARATOR() external view returns (bytes32);
604     function PERMIT_TYPEHASH() external pure returns (bytes32);
605     function nonces(address owner) external view returns (uint);
606 
607     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
608 
609     event Mint(address indexed sender, uint amount0, uint amount1);
610     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
611     event Swap(
612         address indexed sender,
613         uint amount0In,
614         uint amount1In,
615         uint amount0Out,
616         uint amount1Out,
617         address indexed to
618     );
619     event Sync(uint112 reserve0, uint112 reserve1);
620 
621     function MINIMUM_LIQUIDITY() external pure returns (uint);
622     function factory() external view returns (address);
623     function token0() external view returns (address);
624     function token1() external view returns (address);
625     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
626     function price0CumulativeLast() external view returns (uint);
627     function price1CumulativeLast() external view returns (uint);
628     function kLast() external view returns (uint);
629 
630     function mint(address to) external returns (uint liquidity);
631     function burn(address to) external returns (uint amount0, uint amount1);
632     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
633     function skim(address to) external;
634     function sync() external;
635 
636     function initialize(address, address) external;
637 }
638 
639 //
640 // InfinityBit Token v2
641 //
642 // License: AGPL-3.0-only
643 
644 // pragma solidity 0.8.18;
645 
646 contract InfinityBitTokenV2 is IERC20, Ownable {
647     using Address for address;
648 
649     event TaxesAutoswap(uint256 amount_eth);
650 
651     mapping(address => uint256) private _balances;
652     mapping(address => mapping(address => uint256)) private _allowances;
653 
654     uint256 private _totalSupply;
655 
656     string private _name;
657     string private _symbol;
658     uint8 private _decimals = 8;
659     uint256 private _deployHeight;
660     address private _contractDeployer;
661 
662     // flags
663     bool private _maxWalletEnabled = true;
664     bool public _autoSwapTokens = true;
665     bool public _transfersEnabled = false;
666     bool public _sellFromTaxWallets = true;
667 
668     // Maximum Supply is 5,700,000,000. This is immutable and cannot be changed.
669     uint256 private immutable _maxSupply = 5_700_000_000 * (10 ** uint256(_decimals));
670 
671     // Maximum total tax rate. This is immutable and cannot be changed.
672     uint8 private immutable _maxTax = 50; // 5%
673     // Maximum wallet. This is immutable and cannot be changed.
674     uint256 private immutable _maxWallet = 125000000 * (10 ** uint256(_decimals));
675 
676     // Marketing Tax - has one decimal.
677     uint8 private _marketingTax = 30; // 3%
678     address payable private _marketingWallet = payable(0xd1CB9007D51FB812805d80618A97418Fd388B0C5);
679     address payable immutable private _legacyMarketingWallet = payable(0xA6e18D5F6b20dFA84d7d245bb656561f1f9aff69);
680 
681     // Developer Tax
682     uint8 private _devTax = 18; // 1.8%
683     address payable private _devWallet = payable(0x02DAb704810C40C87374eBD85927c3D8a9815Eb0);
684     address payable immutable private _legacyDevWallet = payable(0x9d0D8E5e651Ab7d54Af5B0F655b3978504E67E0C);
685 
686     // LP Tax
687     uint8 private _lpTax = 0; // 0%
688 
689     // Burn Address
690     address private immutable _burnAddress = 0x000000000000000000000000000000000000D34d;
691 
692     // Deadline in seconds for UniswapV2 autoswap
693     uint8 private _autoSwapDeadlineSeconds = 0;
694 
695     // Taxless Allow-List
696     //  This is a list of wallets which are exempt from taxes.
697     mapping(address=>bool) TaxlessAllowList;
698 
699     // IgnoreMaxWallet Allow-List
700     //  This is a list of wallets which are exempt from the maximum wallet.
701     mapping(address=>bool) IgnoreMaxWalletAllowList;
702 
703     // SwapThreshold - Amount that will be autoswapped- has one decimal.
704     uint8 public _swapLimit = 25; // 2.5%
705     uint8 public immutable _swapLimitMax = 50; // 5% hardcoded max
706     uint8 public _swapThreshold = 10; // 1%
707     uint8 public immutable _swapThresholdMax = 50; // 5% hardcoded max
708 
709     // Required to recieve ETH from UniswapV2Router on automated token swaps
710     receive() external payable {}
711 
712     // Uniswap V2
713     IUniswapV2Router02 public _uniswapV2Router;
714     address private _uniswapV2RouterAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
715     address private _uniswapUniversalRouter = 0x4648a43B2C14Da09FdF82B161150d3F634f40491;
716     address private _uniswapV2PairAddress;
717     IUniswapV2Factory public _uniswapV2Factory;
718 
719     constructor() payable {
720         _name = "InfinityBit Token";
721         _symbol = "IBIT";
722         _decimals = 8;
723 
724         IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(_uniswapV2RouterAddress);
725         _uniswapV2Router = uniswapV2Router;
726 
727         // Create Uniswap V2 Pair
728         _uniswapV2Factory = IUniswapV2Factory(_uniswapV2Router.factory());
729         _uniswapV2PairAddress = _uniswapV2Factory.createPair(address(this), _uniswapV2Router.WETH());
730         _uniswapV2Router = uniswapV2Router;
731 
732         // Mint Supply
733         _mint(msg.sender, _maxSupply);
734         _totalSupply = _maxSupply;
735 
736         // IgnoreMaxWallet Allowlist
737         IgnoreMaxWalletAllowList[_uniswapUniversalRouter] = true;
738         IgnoreMaxWalletAllowList[_uniswapV2RouterAddress] = true;
739         IgnoreMaxWalletAllowList[_uniswapV2PairAddress] = true;
740         IgnoreMaxWalletAllowList[_marketingWallet] = true;
741         IgnoreMaxWalletAllowList[_devWallet] = true;
742         IgnoreMaxWalletAllowList[_legacyMarketingWallet] = true;
743         IgnoreMaxWalletAllowList[_legacyDevWallet] = true;
744         IgnoreMaxWalletAllowList[address(owner())] = true;
745 
746         // Taxless Allowlist
747         TaxlessAllowList[_uniswapUniversalRouter] = true;
748         TaxlessAllowList[_uniswapV2RouterAddress] = true;
749         TaxlessAllowList[_marketingWallet] = true;
750         TaxlessAllowList[_devWallet] = true;
751         TaxlessAllowList[address(owner())] = true;
752     }
753 
754     //
755     //
756     //
757 
758     function name() public view returns (string memory) {
759         return _name;
760     }
761     function symbol() public view returns (string memory) {
762         return _symbol;
763     }
764     function decimals() public view returns (uint8) {
765         return _decimals;
766     }
767     function totalSupply() public view returns (uint256) {
768         return _totalSupply;
769     }
770     function balanceOf(address account) public view returns (uint256) {
771         return _balances[account];
772     }
773     function transfer(address to, uint256 amount) public returns (bool) {
774         _transfer(msg.sender, to, amount);
775         return true;
776     }
777     function _approve(address from, address spender, uint256 amount) internal virtual {
778         require(from != address(0), "ERC20: approve from the zero address");
779         require(spender != address(0), "ERC20: approve to the zero address");
780 
781         _allowances[from][spender] = amount;
782         emit Approval(from, spender, amount);
783     }
784     function _spendAllowance(address from, address spender, uint256 amount) internal virtual {
785         uint256 currentAllowance = allowance(from, spender);
786         if (currentAllowance != type(uint256).max) {
787             require(currentAllowance >= amount, "ERC20: insufficient allowance");
788         unchecked {
789             _approve(from, spender, currentAllowance - amount);
790         }
791         }
792     }
793     function allowance(address owner, address spender) public view virtual override returns (uint256) {
794         return _allowances[owner][spender];
795     }
796     function approve(address spender, uint256 amount) public virtual override returns (bool) {
797         address owner = _msgSender();
798         _approve(owner, spender, amount);
799         return true;
800     }
801     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
802         address spender = _msgSender();
803         _spendAllowance(from, spender, amount);
804         _transfer(from, to, amount);
805         return true;
806     }
807     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
808         _approve(msg.sender, spender, allowance(msg.sender, spender) + addedValue);
809         return true;
810     }
811     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
812         uint256 currentAllowance = allowance(msg.sender, spender);
813         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
814     unchecked {
815         _approve(msg.sender, spender, currentAllowance - subtractedValue);
816     }
817 
818         return true;
819     }
820 
821 
822     //
823     //
824     //
825 
826 
827     function _mint(address to, uint value) internal {
828         _totalSupply = _totalSupply+value;
829         _balances[to] = _balances[to] + value;
830         emit Transfer(address(0), to, value);
831     }
832 
833     // Once transfers are enabled, they cannot be disabled.
834     function enableTransfers() public onlyOwner() {
835         _transfersEnabled = true;
836     }
837 
838     // Set the Dev Wallet Address
839     function setDevWallet(address devWallet) public onlyOwner {
840         require(devWallet != address(0), "IBIT: cannot set to the zero address");
841         _devWallet = payable(devWallet);
842     }
843 
844     // Set the Marketing Wallet Address
845     function setMarketingWallet(address marketingWallet) public onlyOwner {
846         require(marketingWallet != address(0), "IBIT: cannot set to the zero address");
847         _marketingWallet = payable(marketingWallet);
848     }
849 
850     function isSell(address sender, address recipient) private view returns (bool) {
851         if(sender == _uniswapV2RouterAddress || sender == _uniswapV2PairAddress || sender == _uniswapUniversalRouter) {
852             return false;
853         }
854 
855         if(recipient == _uniswapV2PairAddress || recipient == address(_uniswapV2Router)) {
856             return true;
857         }
858 
859         return false;
860     }
861 
862     function isBuy(address sender) private view returns (bool) {
863         return sender == _uniswapV2PairAddress || sender == address(_uniswapV2Router);
864     }
865 
866     event AutoswapFailed(uint256 amount);
867 
868     function _swapTokensForETH(uint256 amount) private {
869         if(amount == 0) {
870             return;
871         }
872 
873         address[] memory path = new address[](2);
874         path[0] = address(this);
875         path[1] = _uniswapV2Router.WETH();
876 
877         _approve(address(this), address(_uniswapV2Router), amount);
878 
879         try _uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
880             amount,
881             0,
882             path,
883             address(this),
884             block.timestamp+_autoSwapDeadlineSeconds
885         ) {
886 
887         } catch {
888             emit AutoswapFailed(amount);
889         }
890     }
891 
892     function addLiquidity(uint256 amount_tokens, uint256 amount_eth) private returns (bool) {
893         if(amount_tokens == 0 || amount_eth == 0) {
894             return true;
895         }
896 
897         _approve(address(this), address(_uniswapV2Router), amount_tokens);
898         try _uniswapV2Router.addLiquidityETH{value: amount_eth}(
899             address(this),
900             amount_tokens,
901             0,
902             0,
903             owner(),
904             block.timestamp
905         ) {
906             return true;
907         } catch {
908             return false;
909         }
910     }
911 
912     function getDevTax() public view returns (uint8) {
913         return _devTax;
914     }
915 
916     function toggleAutoSwapTokens(bool enable) public onlyOwner {
917         _autoSwapTokens = enable;
918     }
919 
920     function getLpTax() public view returns (uint8) {
921         return _lpTax;
922     }
923 
924     function getMarketingTax() public view returns (uint8) {
925         return _marketingTax;
926     }
927 
928     function setDevTax(uint8 tax) public onlyOwner {
929         require(_lpTax+_marketingTax+tax <= _maxTax, "IBIT: total tax cannot exceed max tax");
930         _devTax = tax;
931     }
932 
933     function setLpTax(uint8 tax) public onlyOwner {
934         require((_devTax+_marketingTax+tax) <= _maxTax, "IBIT: total tax cannot exceed max tax");
935         _lpTax = tax;
936     }
937 
938     function setMarketingTax(uint8 tax) public onlyOwner {
939         require(_devTax+_lpTax+tax <= _maxTax, "IBIT: total tax cannot exceed max tax");
940         _marketingTax = tax;
941     }
942 
943     function setAutoswapDeadline(uint8 deadline_seconds) public onlyOwner {
944         _autoSwapDeadlineSeconds = deadline_seconds;
945     }
946 
947     function DetectMaxWalletEnabled() public view returns (bool) {
948         return _maxWalletEnabled;
949     }
950 
951     function ToggleMaxWallet(bool _enable) public onlyOwner {
952         _maxWalletEnabled = _enable;
953     }
954 
955     function SetUniswapV2Pair(address _w) public onlyOwner {
956         _uniswapV2PairAddress = _w;
957     }
958 
959     function GetUniswapV2Pair() public view returns (address) {
960         return _uniswapV2PairAddress;
961     }
962 
963     // Add a wallet address to the taxless allow-list.
964     function SetTaxlessAllowList(address _w) public onlyOwner {
965         TaxlessAllowList[_w] = true;
966     }
967 
968     // Remove a wallet address from the taxless allow-list.
969     function UnsetTaxlessAllowList(address _w) public onlyOwner {
970         TaxlessAllowList[_w] = false;
971     }
972 
973     // Add a wallet address to the max wallet allow-list.
974     function SetMaxWalletAllowList(address _w) public onlyOwner {
975         IgnoreMaxWalletAllowList[_w] = true;
976     }
977 
978     // Remove a wallet address from the max wallet allow-list.
979     function UnsetMaxWalletAllowList(address _w) public onlyOwner {
980         IgnoreMaxWalletAllowList[_w] = false;
981     }
982 
983     // Returns true if the provided address is tax-exempt, otherwise returns false.
984     function isTaxExempt(address from, address to) public view returns(bool) {
985         if(TaxlessAllowList[from] || TaxlessAllowList[to])
986         {
987             return true;
988         }
989 
990         if(from == owner() || to == owner())
991         {
992             return true;
993         }
994 
995         return false;
996     }
997 
998     // Returns true if the provided address is maxWallet-exempt, otherwise returns false.
999     function isMaxWalletExempt(address _w) public view returns (bool) {
1000         if(_w == address(owner()))
1001         {
1002             return true;
1003         }
1004 
1005         return IgnoreMaxWalletAllowList[_w];
1006     }
1007 
1008     // Returns the total tax %
1009     function totalTax() public view returns (uint8) {
1010         return _lpTax+_devTax+_marketingTax;
1011     }
1012 
1013     // Sends Ether to specified 'to' address
1014     function sendEther(address payable to, uint256 amount) private returns (bool) {
1015         return to.send(amount);
1016     }
1017 
1018     // Returns the amount of IBIT tokens in the Liquidity Pool
1019     function getLiquidityIBIT() public view returns (uint256) {
1020         return _balances[_uniswapV2PairAddress];
1021     }
1022 
1023     // Limit the maximum autoswap based on _swapLimit percent
1024     function getMaxAutoswap() public view returns (uint256 max_autoswap_limit) {
1025         return (_swapLimit * getLiquidityIBIT()) / 1000;
1026     }
1027 
1028     // Returns the autoswap limit (ie, the maximum which will be autoswapped) as a percent with one decimal, i.e. 50 = 5%
1029     function getAutoswapLimit() public view returns (uint8 autoswap_limit_percent) {
1030         return _swapLimit;
1031     }
1032 
1033     function setAutoswapLimit(uint8 swapLimit) public onlyOwner {
1034         require(swapLimit < _swapLimitMax, "IBIT: swapLimit exceeds max");
1035         _swapLimit = swapLimit;
1036     }
1037 
1038     // Returns the autoswap threshold,  the minimum tokens which must be
1039     // reached before an autoswap will occur. expressed as a percent with one decimal, i.e. 50 = 5%
1040     function getAutoswapThreshold() public view returns (uint8 autoswap_threshold_percent) {
1041         return _swapThreshold;
1042     }
1043 
1044     function setAutoswapThreshold(uint8 swapThreshold) public onlyOwner {
1045         require(_swapThreshold < _swapThresholdMax, "IBIT: swapThreshold exceeds max");
1046         _swapThreshold = swapThreshold;
1047     }
1048 
1049     event AutoLiquidityFailed(uint256 token_amount, uint256 eth_amount, uint256 tokens_collected, uint256 tokens_swapped, uint256 eth_collected);
1050     event AutoLiquiditySuccess(uint256 token_amount, uint256 eth_amount, uint256 tokens_collected, uint256 tokens_swapped, uint256 eth_collected);
1051     event DeductTaxes(uint256 dev_tax_amount, uint256 marketing_tax_amount, uint256 lp_tax_amount);
1052 
1053     // Returns the maximum amount which can be autoswapped if everything is sold
1054     function autoswapTotalTokensAvailable(uint256 amount) public view returns (uint256) {
1055         return _calcLpTaxAmount(amount)/2 + _calcDevTaxAmount(amount) + _calcMarketingTaxAmount(amount) + _balances[_devWallet] + _balances[_marketingWallet];
1056     }
1057 
1058     function calcAutoswapAmount(uint256 sell_amount) public view returns (uint256) {
1059         uint256 lp_tokens = _calcLpTaxAmount(sell_amount)/2;
1060         return lp_tokens + _calcDevTaxAmount(sell_amount) + _calcMarketingTaxAmount(sell_amount);
1061     }
1062 
1063     function _transfer(address from, address to, uint256 amount) private {
1064         require(from != address(0), "ERC20: transfer from the zero address");
1065         require(to != address(0), "ERC20: transfer to the zero address");
1066         require(_balances[from] >= amount, "ERC20: transfer amount exceeds balance");
1067 
1068         if(!_transfersEnabled) {
1069             require(from == owner() || to == owner(), "IBIT: transfers disabled until initial LP");
1070         }
1071 
1072         uint256 tax_amount;
1073 
1074         // Begin Tax Check
1075         if(isTaxExempt(from, to))
1076         {
1077             tax_amount = 0;
1078         }
1079         else
1080         {
1081             tax_amount = _calcTaxes(amount);
1082         }
1083 
1084         uint256 transfer_amount = amount - tax_amount;
1085 
1086         // Begin Max Wallet Check, owner always ignores max wallet check.
1087         if(!isMaxWalletExempt(to) && from != owner() && _maxWalletEnabled)
1088         {
1089             require((balanceOf(to) + transfer_amount) <= _maxWallet, "IBIT: maximum wallet cannot be exceeded");
1090         }
1091 
1092         if(tax_amount == 0)
1093         {
1094             _taxlessTransfer(from, to, amount);
1095             return;
1096         }
1097 
1098         // Take taxes
1099         _takeTaxes(from, tax_amount);
1100         emit DeductTaxes(_calcDevTaxAmount(amount), _calcMarketingTaxAmount(amount), _calcLpTaxAmount(amount));
1101 
1102         if(autoSwapConditionCheck(from, to, amount))
1103         {
1104             _autoSwapTaxForEth(from, to, amount);
1105         }
1106         else
1107         {
1108             // Distribute Taxes (Tokens)
1109             _balances[_devWallet] += _calcDevTaxAmount(amount);
1110             _balances[_marketingWallet] += _calcMarketingTaxAmount(amount);
1111             _balances[address(this)] += _calcLpTaxAmount(amount);
1112         }
1113 
1114         // Emit
1115         _taxlessTransfer(from, to, transfer_amount);
1116     }
1117 
1118     function _autoSwapTaxForEth(address from, address to, uint256 amount) private {
1119         uint256 autoswap_amount = calcAutoswapAmount(amount);
1120 
1121         if(autoswap_amount == 0)
1122         {
1123             return;
1124         }
1125 
1126         uint256 max_autoswap = getMaxAutoswap();
1127 
1128         if(autoswap_amount < max_autoswap)
1129         {
1130             // Take tokens from marketing and dev wallets
1131             uint256 max_extra_autoswap = max_autoswap-autoswap_amount;
1132             autoswap_amount += _takeTokensFromMarketingAndDevWallets(max_extra_autoswap);
1133         }
1134         else if(autoswap_amount > max_autoswap)
1135         {
1136             autoswap_amount = max_autoswap;
1137         }
1138 
1139         // Execute autoswap
1140         uint256 startingBalance = address(this).balance;
1141         _swapTokensForETH(autoswap_amount);
1142         uint256 ethCollected = address(this).balance - startingBalance;
1143         emit TaxesAutoswap(ethCollected);
1144 
1145         // Auto Liquidity (LP Tax)
1146         if(_lpTax > 0 && !isTaxExempt(from, to))
1147         {
1148             uint256 tax_amount = _calcTaxes(amount);
1149             uint256 lp_tokens = _calcLpTaxAmount(amount)/2;
1150             if(to == _uniswapV2PairAddress && from != _uniswapV2RouterAddress && from != _uniswapUniversalRouter)
1151             {
1152                 uint256 lp_tax_eth = _calcTaxDistribution(ethCollected, _lpTax);
1153                 if(!addLiquidity(lp_tokens, lp_tax_eth)) {
1154                     emit AutoLiquidityFailed(lp_tokens, lp_tax_eth, tax_amount, autoswap_amount, ethCollected);
1155                 } else {
1156                     emit AutoLiquiditySuccess(lp_tokens, lp_tax_eth, tax_amount, autoswap_amount, ethCollected);
1157                 }
1158             }
1159         }
1160 
1161         // Distribute Taxes (ETH)
1162         uint256 marketing_tax_eth = _calcTaxDistribution(ethCollected, _marketingTax);
1163         uint256 dev_tax_eth = _calcTaxDistribution(ethCollected, _devTax);
1164 
1165         if(marketing_tax_eth > 0) {
1166             sendEther(_marketingWallet, marketing_tax_eth);
1167         }
1168 
1169         if(dev_tax_eth > 0) {
1170             sendEther(_devWallet, dev_tax_eth);
1171         }
1172     }
1173 
1174     // Returns true if the conditions are met for an autoswap, otherwise returns false.
1175     function autoSwapConditionCheck(address from, address to, uint256 amount) public view returns (bool) {
1176         if(!_autoSwapTokens) {
1177             return false;
1178         }
1179 
1180         if(!isSell(from, to)) {
1181             return false;
1182         }
1183 
1184         if(_swapThreshold == 0) {
1185             return true;
1186         }
1187 
1188         uint256 swapThresholdAmountTokens = (getLiquidityIBIT() * _swapThreshold)/1000;
1189         if(autoswapTotalTokensAvailable(amount) >= swapThresholdAmountTokens) {
1190             return true;
1191         }
1192 
1193         return false;
1194     }
1195 
1196     function toggleSellFromTaxWallets(bool enable) public onlyOwner {
1197         _sellFromTaxWallets = enable;
1198     }
1199 
1200     function takeTokensFromTaxWallets(uint256 max_amount) public onlyOwner returns (uint256 amount_taken) {
1201         return _takeTokensFromMarketingAndDevWallets(max_amount);
1202     }
1203 
1204     // Try to take max_extra_autoswap from marketing and dev wallets
1205     function _takeTokensFromMarketingAndDevWallets(uint256 max_extra_autoswap) private returns (uint256 amount_taken) {
1206         if(_sellFromTaxWallets == false) {
1207             return 0;
1208         }
1209 
1210         // Don't take tokens unless there are at least 100K
1211         if(_balances[_marketingWallet] + _balances[_devWallet] < 10000000000000)
1212         {
1213             return 0;
1214         }
1215 
1216         uint256 extra_amount_taken = 0;
1217 
1218         if(_balances[_marketingWallet] >= max_extra_autoswap)
1219         {
1220             unchecked {
1221                 _balances[_marketingWallet] -= max_extra_autoswap;
1222                 _balances[address(this)] += max_extra_autoswap;
1223             }
1224             return max_extra_autoswap;
1225         }
1226 
1227         if(_balances[_devWallet] >= max_extra_autoswap)
1228         {
1229             unchecked {
1230                 _balances[_devWallet] -= max_extra_autoswap;
1231                 _balances[address(this)] += max_extra_autoswap;
1232             }
1233             return max_extra_autoswap;
1234         }
1235 
1236         extra_amount_taken = _balances[_devWallet];
1237 
1238         unchecked {
1239             _balances[_devWallet] = 0;
1240             _balances[address(this)] += extra_amount_taken;
1241         }
1242 
1243         if(extra_amount_taken >= max_extra_autoswap)
1244         {
1245             return max_extra_autoswap;
1246         }
1247 
1248         uint256 mwBalance;
1249         if(extra_amount_taken + _balances[_marketingWallet] <= max_extra_autoswap)
1250         {
1251             mwBalance = _balances[_marketingWallet];
1252 
1253             unchecked {
1254                 _balances[address(this)] += mwBalance;
1255                 _balances[_marketingWallet] = 0;
1256             }
1257             return extra_amount_taken + mwBalance;
1258         }
1259 
1260         uint256 left_to_take = max_extra_autoswap - amount_taken;
1261         if(_balances[_marketingWallet] >= left_to_take)
1262         {
1263             unchecked {
1264                 _balances[_marketingWallet] -= left_to_take;
1265                 _balances[address(this)] += left_to_take;
1266             }
1267             return max_extra_autoswap;
1268         }
1269 
1270         mwBalance = _balances[_marketingWallet];
1271         unchecked {
1272             _balances[_marketingWallet] = 0;
1273             _balances[address(this)] += mwBalance;
1274         }
1275         return extra_amount_taken + mwBalance;
1276     }
1277 
1278     function _calcTaxDistribution(uint256 eth_collected, uint256 tax_rate) private view returns(uint256 distribution_eth)
1279     {
1280         // Equivilent to (eth_collected * (tax_rate/totalTax))
1281         return (eth_collected * tax_rate) / totalTax();
1282     }
1283 
1284     function _calcLpTaxAmount(uint256 amount) private view returns(uint256 tax)
1285     {
1286         return (amount * _lpTax) / 1000;
1287     }
1288     function _calcDevTaxAmount(uint256 amount) private view returns(uint256 tax)
1289     {
1290         return (amount * _devTax) / 1000;
1291     }
1292     function _calcMarketingTaxAmount(uint256 amount) private view returns(uint256 tax)
1293     {
1294         return (amount * _marketingTax) / 1000;
1295     }
1296 
1297     // Given an amount, calculate the taxes which would be collected. Excludes LP tax.
1298     function _calcTaxes(uint256 amount) public view returns (uint256 tax_to_collect) {
1299         return _calcDevTaxAmount(amount) + _calcMarketingTaxAmount(amount) + _calcLpTaxAmount(amount);
1300     }
1301 
1302     // Taxes taxes as specified by 'tax_amount'
1303     function _takeTaxes(address from, uint256 tax_amount) private {
1304         if(tax_amount == 0 || totalTax() == 0)
1305         {
1306             return;
1307         }
1308 
1309         // Remove tokens from sender
1310     unchecked {
1311         _balances[from] -= tax_amount;
1312     }
1313 
1314         // Collect taxes
1315     unchecked {
1316         _balances[address(this)] += tax_amount;
1317     }
1318     }
1319 
1320     function _taxlessTransfer(address from, address to, uint256 amount) private {
1321     unchecked {
1322         _balances[from] -= amount;
1323         _balances[to] += amount;
1324     }
1325         emit Transfer(from, to, amount);
1326     }
1327 
1328     // Migrate from Legacy
1329     address[] _legacyHolders;
1330     mapping(address=>uint256) _legacyHoldersBalances;
1331 
1332     bool _holdersAirdropped = false;
1333 
1334     function setLegacyHolder(address _w, uint256 balance) private {
1335         if(_legacyHoldersBalances[_w] != 0) {
1336             return; // duplicate
1337         }
1338 
1339         if(balance == 0) {
1340             return;
1341         }
1342 
1343         _legacyHolders.push(_w);
1344         _legacyHoldersBalances[_w] = balance;
1345     }
1346 
1347     // Airdrop Legacy Holders
1348     function initialAirdrop() public onlyOwner {
1349         require(_holdersAirdropped == false, "IBIT: Holders can only be airdropped once");
1350         _holdersAirdropped = true;
1351 
1352         setLegacyBalancesFromSnapshot();
1353 
1354         for(uint i = 0; i < _legacyHolders.length; i++) {
1355             address to = _legacyHolders[i];
1356             uint256 balance = _legacyHoldersBalances[to];
1357 
1358             _taxlessTransfer(owner(), to, balance);
1359         }
1360     }
1361 
1362     function setLegacyBalancesFromSnapshot() private {
1363 
1364         // NULS Partnership
1365         // 0x649Fd8b99b1d61d8FE7A9C7eec86dcfF829633F0, 14210000100000000); // 142,100,001 IBIT
1366         _taxlessTransfer(owner(), _legacyMarketingWallet, 14210000100000000);
1367 
1368         // These wallets completed migration from legacy
1369         setLegacyHolder(0x89Abd93CaBa3657919674a663D55E1C185A4CA25, 5000000000000000); // 50,000,000 IBIT
1370         setLegacyHolder(0x2e9EdC685510F3B6B92B5aA8B14E66a18707F5aB, 5000000000000000); // 50,000,000 IBIT
1371         setLegacyHolder(0xDB1C0B51328D40c11ebE5C9C7098477B88551e8d, 2500000000000000); // 25,000,000 IBIT
1372         setLegacyHolder(0x52747Fd7866eF249b015bB99E95a3169B9eC4497, 10490511753749771); // 104,905,118 IBIT
1373         setLegacyHolder(0xb2C91Cf2Fd763F2cC4558ed3cEDE401Fc1d1B675, 4000000000000000); // 40,000,000 IBIT
1374         setLegacyHolder(0x2E64b76130819f30bE2df0A0740D990d706B9926, 9317247665468201); // 93,172,477 IBIT
1375         setLegacyHolder(0x1E69003E5267E945962ae38578a76222CA408584, 5000000000000000); // 50,000,000 IBIT
1376         setLegacyHolder(0x16F39f8ff59caead81bC680e6cd663069Eb978BE, 10100000000000000); // 101,000,000 IBIT
1377         setLegacyHolder(0x6d102206CB3F043E22A62B4b7ecC83b877f85d9A, 5001685678902763); // 50,016,857 IBIT
1378         setLegacyHolder(0xEC61A284Df18c4937B50880F70EB181d38fe86Bb, 1660752476400742); // 16,607,525 IBIT
1379         setLegacyHolder(0x4C999827Bc4b51fbd6911f066d8b82baaC286a9b, 3500000000000000); // 35,000,000 IBIT
1380         setLegacyHolder(0x5415672D7334F8d2798022242675829B16bf94db, 1441870099079523); // 14,418,701 IBIT
1381         setLegacyHolder(0xdF10d9688528b5b60957D1727a70A30450cE9604, 5000000000000000); // 50,000,000 IBIT
1382         setLegacyHolder(0x831114051c0edDe239ae672EdcC4c63371deC82b, 3869772286660397); // 38,697,723 IBIT
1383         setLegacyHolder(0x1d9c8Ae02d75db48dF0d13424cF7fb188dfa4B6E, 2112190583266945); // 21,121,906 IBIT
1384         setLegacyHolder(0x6e7182cFe90cC9AaD11f7082cC4c462dbFD2D73C, 1083000000000000); // 10,830,000 IBIT
1385         setLegacyHolder(0x287044c98a99F08764d681eD898aECb68A5543BC, 2320032256026266); // 23,200,323 IBIT
1386         setLegacyHolder(0x5159cD8087B040E3E5F95e1489ce1018E186795C, 2250000000000000); // 22,500,000 IBIT
1387         setLegacyHolder(0x5eD277Af83D32fa421091244Fa802e90FE8e896d, 5464909136753054); // 54,649,091 IBIT
1388         setLegacyHolder(0x7aBc57C6f67853D16a4400685d18eE53980A3F4F, 7697889041792168); // 76,978,890 IBIT
1389         setLegacyHolder(0x09b3a9Ea542713dcC182728F9DebBdfCB1a0112F, 5000000000000000); // 50,000,000 IBIT
1390         setLegacyHolder(0xF3598aD305Bbd8b40A480947e00a5dc3E29dC5a5, 4875000000000000); // 48,750,000 IBIT
1391         setLegacyHolder(0x2Aeda0568E111Da6A465bb735D912899A15015c2, 10782747817992883); // 107,827,478 IBIT
1392         setLegacyHolder(0xb578B5157Bcc9Fd2e73AcACf7E853FD9F861F55d, 2000000000000000); // 20,000,000 IBIT
1393         setLegacyHolder(0x16C73eaFAA9c6f915d9026D3C2d1b6E9407d2F73, 5159396904718724); // 51,593,969 IBIT
1394         setLegacyHolder(0x3140dD4B65C557Fda703B081C475CE4945EaaCa3, 5000000000000000); // 50,000,000 IBIT
1395         setLegacyHolder(0xe632450E74165110459fEf989bc11E90Ee9029D1, 9350739929318052); // 93,507,399 IBIT
1396         setLegacyHolder(0xF6E82162D8938D91b44EFd4C307DBa91EcBD6950, 2907543953360030); // 29,075,440 IBIT
1397         setLegacyHolder(0x33AF2064Be09C34302C4cA8B8529A0E659243016, 660000000000000); // 6,600,000 IBIT
1398         setLegacyHolder(0xAA9d9D742b5c915D65649C636fb2D485911ece4D, 1318142836424375); // 13,181,428 IBIT
1399         setLegacyHolder(0x5507F5a1076742e3299cE8199fEEd98079ECeE34, 2500000000000000); // 25,000,000 IBIT
1400         setLegacyHolder(0x5e75d35893200849889DD98a50fce78E3D5641F3, 3263084246964091); // 32,630,842 IBIT
1401         setLegacyHolder(0x0665d03bDDFd7bA36b1bDC7aDdB26C48273111c8, 500000000000000); // 5,000,000 IBIT
1402         setLegacyHolder(0x8A541f614A14B00366d92dCe6e927bF550f1c897, 5000000000000000); // 50,000,000 IBIT
1403         setLegacyHolder(0xC8aFB078896B5780bD7b7174429AF2DAff61199b, 6139352996536699); // 61,393,530 IBIT
1404         setLegacyHolder(0xffa25D69EF4909454825904904A2D876eA43E437, 2968750000000000); // 29,687,500 IBIT
1405         setLegacyHolder(0xCd0951939b77e22e497895820Ea7BD3AeF480E1C, 121526011734471); // 1,215,260 IBIT
1406         setLegacyHolder(0x1ca92Baf56A806527952Ebe610d06A66B54Bf5f1, 800000000000000); // 8,000,000 IBIT
1407         setLegacyHolder(0xa51670db54Edf9Dd5D5E3570f619FF46535E3679, 9500000000000); // 95,000 IBIT
1408         setLegacyHolder(0xdd30235DC68011F4de01A5c4059fC20145D5c874, 2509039665732949); // 25,090,397 IBIT
1409         setLegacyHolder(0x9161c6B026e65Ba6B583fE8F552FA26b6D39eA89, 1425000000000000); // 14,250,000 IBIT
1410         setLegacyHolder(0xDa85C4A66eBea97aa48a6e1741EC0E639fFe1783, 3138834219770145); // 31,388,342 IBIT
1411         setLegacyHolder(0xCEe85e997E80B724c69a1474a9489dBFA4cF5d2C, 484424921158839); // 4,844,249 IBIT
1412         setLegacyHolder(0x79D6F80D880f1bc1671b6fe3f88977D09eAe4DAA, 1814845856095380); // 18,148,459 IBIT
1413         setLegacyHolder(0x6D9e1352e1F8f66F96669CC28FDCfE8e7FCF5524, 3200000000000000); // 32,000,000 IBIT
1414         setLegacyHolder(0xA6e18D5F6b20dFA84d7d245bb656561f1f9aff69, 11246699192462885); // 112,466,992 IBIT
1415         setLegacyHolder(0x9d0D8E5e651Ab7d54Af5B0F655b3978504E67E0C, 11031132794975236); // 110,311,328 IBIT
1416         setLegacyHolder(0x141278EF1F894a60cBC8637871E4d19c3f2a7336, 5000000000000000); // 50,000,000 IBIT
1417         setLegacyHolder(0x8AefCE4e323DbB2eCD5818869acF90e5415559C5, 5000000000000000); // 50,000,000 IBIT
1418         setLegacyHolder(0x5ea0c07ADa402b67F1a9467d008EC11eD9Ca1127, 5000000000000000); // 50,000,000 IBIT
1419         setLegacyHolder(0x2B09aCED766f8290de1F5E4E0d3B3B8915C49189, 5000000000000000); // 50,000,000 IBIT
1420         setLegacyHolder(0xFb1BAD0Dc29a9a485F08F4FE6bFBFEdeba10ad8d, 12125000000000000); // 121,250,000 IBIT
1421         setLegacyHolder(0x56be74F547b1c3b01E97f87461E2f3C75902374A, 1124603943161942); // 11,246,039 IBIT
1422         setLegacyHolder(0x4A9381E176D676A07DD17A83d8BFd1287b342c77, 4810000000000000); // 48,100,000 IBIT
1423         setLegacyHolder(0xFCe082295b4db70097c4135Ca254B13B070800E7, 10000000000000000); // 100,000,000 IBIT
1424         setLegacyHolder(0x7ea69F87f9836FFc6797B6B2D045c11e0881b740, 5000000000000000); // 50,000,000 IBIT
1425         setLegacyHolder(0x1cC4A2522c3847687aF45AcdA2b5d6EbB64490A9, 402527671912807); // 4,025,277 IBIT
1426         setLegacyHolder(0x89E364598BDa1f96B6618EBE5D9879F070066358, 4750000000000000); // 47,500,000 IBIT
1427 
1428         // These wallets did not migrate. 50% penalty as decided by the community.
1429         setLegacyHolder(0x7FF0373F706E07eE326d538f6a6B2Cf8F7397e77, uint256(uint256(1250924993795650) / 2));
1430         setLegacyHolder(0x5F7425396747897F91b68149915826aFc2C14c16, uint256(uint256(1097767093335720) / 2));
1431         setLegacyHolder(0xa9b809Cfe8d95EdbDD61603Ba40081Ba6da4F24b, uint256(uint256(711944117144372) / 2));
1432         setLegacyHolder(0x817271eA29E0297D26e87c0fCae5d7086c06ae94, uint256(uint256(263389054436059) / 2));
1433         setLegacyHolder(0x15Cd32F5e9C286FaD0c6E6F40D1fc07c2c1a8584, uint256(uint256(130033069564332) / 2));
1434         setLegacyHolder(0x90a71A274Cf69c0AD430481241206cd8fec7a1ED, uint256(uint256(117107416670239) / 2));
1435         setLegacyHolder(0xC5DcAdf158Dc6DE2D6Bc1dDBB40Fb03572000D32, uint256(uint256(45488054291697) / 2));
1436     }
1437 }