1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.8.9;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         return msg.data;
11     }
12 }
13 //  MIT
14 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
15 
16 pragma solidity ^0.8.0;
17 
18 /**
19  * @dev Interface of the ERC20 standard as defined in the EIP.
20  */
21 interface IERC20 {
22     /**
23      * @dev Emitted when `value` tokens are moved from one account (`from`) to
24      * another (`to`).
25      *
26      * Note that `value` may be zero.
27      */
28     event Transfer(address indexed from, address indexed to, uint256 value);
29 
30     /**
31      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
32      * a call to {approve}. `value` is the new allowance.
33      */
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35 
36     /**
37      * @dev Returns the amount of tokens in existence.
38      */
39     function totalSupply() external view returns (uint256);
40 
41     /**
42      * @dev Returns the amount of tokens owned by `account`.
43      */
44     function balanceOf(address account) external view returns (uint256);
45 
46     /**
47      * @dev Moves `amount` tokens from the caller's account to `to`.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * Emits a {Transfer} event.
52      */
53     function transfer(address to, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Returns the remaining number of tokens that `spender` will be
57      * allowed to spend on behalf of `owner` through {transferFrom}. This is
58      * zero by default.
59      *
60      * This value changes when {approve} or {transferFrom} are called.
61      */
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     /**
65      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * IMPORTANT: Beware that changing an allowance with this method brings the risk
70      * that someone may use both the old and the new allowance by unfortunate
71      * transaction ordering. One possible solution to mitigate this race
72      * condition is to first reduce the spender's allowance to 0 and set the
73      * desired value afterwards:
74      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75      *
76      * Emits an {Approval} event.
77      */
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Moves `amount` tokens from `from` to `to` using the
82      * allowance mechanism. `amount` is then deducted from the caller's
83      * allowance.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * Emits a {Transfer} event.
88      */
89     function transferFrom(
90         address from,
91         address to,
92         uint256 amount
93     ) external returns (bool);
94 }
95 //  MIT
96 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
97 
98 pragma solidity ^0.8.1;
99 
100 /**
101  * @dev Collection of functions related to the address type
102  */
103 library Address {
104     /**
105      * @dev Returns true if `account` is a contract.
106      *
107      * [IMPORTANT]
108      * ====
109      * It is unsafe to assume that an address for which this function returns
110      * false is an externally-owned account (EOA) and not a contract.
111      *
112      * Among others, `isContract` will return false for the following
113      * types of addresses:
114      *
115      *  - an externally-owned account
116      *  - a contract in construction
117      *  - an address where a contract will be created
118      *  - an address where a contract lived, but was destroyed
119      * ====
120      *
121      * [IMPORTANT]
122      * ====
123      * You shouldn't rely on `isContract` to protect against flash loan attacks!
124      *
125      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
126      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
127      * constructor.
128      * ====
129      */
130     function isContract(address account) internal view returns (bool) {
131         // This method relies on extcodesize/address.code.length, which returns 0
132         // for contracts in construction, since the code is only stored at the end
133         // of the constructor execution.
134 
135         return account.code.length > 0;
136     }
137 
138     /**
139      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
140      * `recipient`, forwarding all available gas and reverting on errors.
141      *
142      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
143      * of certain opcodes, possibly making contracts go over the 2300 gas limit
144      * imposed by `transfer`, making them unable to receive funds via
145      * `transfer`. {sendValue} removes this limitation.
146      *
147      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
148      *
149      * IMPORTANT: because control is transferred to `recipient`, care must be
150      * taken to not create reentrancy vulnerabilities. Consider using
151      * {ReentrancyGuard} or the
152      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
153      */
154     function sendValue(address payable recipient, uint256 amount) internal {
155         require(address(this).balance >= amount, "Address: insufficient balance");
156 
157         (bool success, ) = recipient.call{value: amount}("");
158         require(success, "Address: unable to send value, recipient may have reverted");
159     }
160 
161     /**
162      * @dev Performs a Solidity function call using a low level `call`. A
163      * plain `call` is an unsafe replacement for a function call: use this
164      * function instead.
165      *
166      * If `target` reverts with a revert reason, it is bubbled up by this
167      * function (like regular Solidity function calls).
168      *
169      * Returns the raw returned data. To convert to the expected return value,
170      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
171      *
172      * Requirements:
173      *
174      * - `target` must be a contract.
175      * - calling `target` with `data` must not revert.
176      *
177      * _Available since v3.1._
178      */
179     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
180         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
185      * `errorMessage` as a fallback revert reason when `target` reverts.
186      *
187      * _Available since v3.1._
188      */
189     function functionCall(
190         address target,
191         bytes memory data,
192         string memory errorMessage
193     ) internal returns (bytes memory) {
194         return functionCallWithValue(target, data, 0, errorMessage);
195     }
196 
197     /**
198      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
199      * but also transferring `value` wei to `target`.
200      *
201      * Requirements:
202      *
203      * - the calling contract must have an ETH balance of at least `value`.
204      * - the called Solidity function must be `payable`.
205      *
206      * _Available since v3.1._
207      */
208     function functionCallWithValue(
209         address target,
210         bytes memory data,
211         uint256 value
212     ) internal returns (bytes memory) {
213         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
214     }
215 
216     /**
217      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
218      * with `errorMessage` as a fallback revert reason when `target` reverts.
219      *
220      * _Available since v3.1._
221      */
222     function functionCallWithValue(
223         address target,
224         bytes memory data,
225         uint256 value,
226         string memory errorMessage
227     ) internal returns (bytes memory) {
228         require(address(this).balance >= value, "Address: insufficient balance for call");
229         (bool success, bytes memory returndata) = target.call{value: value}(data);
230         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
231     }
232 
233     /**
234      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
235      * but performing a static call.
236      *
237      * _Available since v3.3._
238      */
239     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
240         return functionStaticCall(target, data, "Address: low-level static call failed");
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
245      * but performing a static call.
246      *
247      * _Available since v3.3._
248      */
249     function functionStaticCall(
250         address target,
251         bytes memory data,
252         string memory errorMessage
253     ) internal view returns (bytes memory) {
254         (bool success, bytes memory returndata) = target.staticcall(data);
255         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
260      * but performing a delegate call.
261      *
262      * _Available since v3.4._
263      */
264     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
265         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
266     }
267 
268     /**
269      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
270      * but performing a delegate call.
271      *
272      * _Available since v3.4._
273      */
274     function functionDelegateCall(
275         address target,
276         bytes memory data,
277         string memory errorMessage
278     ) internal returns (bytes memory) {
279         (bool success, bytes memory returndata) = target.delegatecall(data);
280         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
281     }
282 
283     /**
284      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
285      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
286      *
287      * _Available since v4.8._
288      */
289     function verifyCallResultFromTarget(
290         address target,
291         bool success,
292         bytes memory returndata,
293         string memory errorMessage
294     ) internal view returns (bytes memory) {
295         if (success) {
296             if (returndata.length == 0) {
297                 // only check isContract if the call was successful and the return data is empty
298                 // otherwise we already know that it was a contract
299                 require(isContract(target), "Address: call to non-contract");
300             }
301             return returndata;
302         } else {
303             _revert(returndata, errorMessage);
304         }
305     }
306 
307     /**
308      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
309      * revert reason or using the provided one.
310      *
311      * _Available since v4.3._
312      */
313     function verifyCallResult(
314         bool success,
315         bytes memory returndata,
316         string memory errorMessage
317     ) internal pure returns (bytes memory) {
318         if (success) {
319             return returndata;
320         } else {
321             _revert(returndata, errorMessage);
322         }
323     }
324 
325     function _revert(bytes memory returndata, string memory errorMessage) private pure {
326         // Look for revert reason and bubble it up if present
327         if (returndata.length > 0) {
328             // The easiest way to bubble the revert reason is using memory via assembly
329             /// @solidity memory-safe-assembly
330             assembly {
331                 let returndata_size := mload(returndata)
332                 revert(add(32, returndata), returndata_size)
333             }
334         } else {
335             revert(errorMessage);
336         }
337     }
338 }
339 //  MIT
340 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
341 
342 pragma solidity ^0.8.0;
343 
344 
345 /**
346  * @dev Contract module which provides a basic access control mechanism, where
347  * there is an account (an owner) that can be granted exclusive access to
348  * specific functions.
349  *
350  * By default, the owner account will be the one that deploys the contract. This
351  * can later be changed with {transferOwnership}.
352  *
353  * This module is used through inheritance. It will make available the modifier
354  * `onlyOwner`, which can be applied to your functions to restrict their use to
355  * the owner.
356  */
357 abstract contract Ownable is Context {
358     address private _owner;
359 
360     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
361 
362     /**
363      * @dev Initializes the contract setting the deployer as the initial owner.
364      */
365     constructor() {
366         _transferOwnership(_msgSender());
367     }
368 
369     /**
370      * @dev Throws if called by any account other than the owner.
371      */
372     modifier onlyOwner() {
373         _checkOwner();
374         _;
375     }
376 
377     /**
378      * @dev Returns the address of the current owner.
379      */
380     function owner() public view virtual returns (address) {
381         return _owner;
382     }
383 
384     /**
385      * @dev Throws if the sender is not the owner.
386      */
387     function _checkOwner() internal view virtual {
388         require(owner() == _msgSender(), "Ownable: caller is not the owner");
389     }
390 
391     /**
392      * @dev Leaves the contract without owner. It will not be possible to call
393      * `onlyOwner` functions anymore. Can only be called by the current owner.
394      *
395      * NOTE: Renouncing ownership will leave the contract without an owner,
396      * thereby removing any functionality that is only available to the owner.
397      */
398     function renounceOwnership() public virtual onlyOwner {
399         _transferOwnership(address(0));
400     }
401 
402     /**
403      * @dev Transfers ownership of the contract to a new account (`newOwner`).
404      * Can only be called by the current owner.
405      */
406     function transferOwnership(address newOwner) public virtual onlyOwner {
407         require(newOwner != address(0), "Ownable: new owner is the zero address");
408         _transferOwnership(newOwner);
409     }
410 
411     /**
412      * @dev Transfers ownership of the contract to a new account (`newOwner`).
413      * Internal function without access restriction.
414      */
415     function _transferOwnership(address newOwner) internal virtual {
416         address oldOwner = _owner;
417         _owner = newOwner;
418         emit OwnershipTransferred(oldOwner, newOwner);
419     }
420 }
421 
422 pragma solidity >=0.6.2;
423 
424 pragma solidity >=0.6.2;
425 
426 interface IUniswapV2Router01 {
427     function factory() external pure returns (address);
428     function WETH() external pure returns (address);
429 
430     function addLiquidity(
431         address tokenA,
432         address tokenB,
433         uint amountADesired,
434         uint amountBDesired,
435         uint amountAMin,
436         uint amountBMin,
437         address to,
438         uint deadline
439     ) external returns (uint amountA, uint amountB, uint liquidity);
440     function addLiquidityETH(
441         address token,
442         uint amountTokenDesired,
443         uint amountTokenMin,
444         uint amountETHMin,
445         address to,
446         uint deadline
447     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
448     function removeLiquidity(
449         address tokenA,
450         address tokenB,
451         uint liquidity,
452         uint amountAMin,
453         uint amountBMin,
454         address to,
455         uint deadline
456     ) external returns (uint amountA, uint amountB);
457     function removeLiquidityETH(
458         address token,
459         uint liquidity,
460         uint amountTokenMin,
461         uint amountETHMin,
462         address to,
463         uint deadline
464     ) external returns (uint amountToken, uint amountETH);
465     function removeLiquidityWithPermit(
466         address tokenA,
467         address tokenB,
468         uint liquidity,
469         uint amountAMin,
470         uint amountBMin,
471         address to,
472         uint deadline,
473         bool approveMax, uint8 v, bytes32 r, bytes32 s
474     ) external returns (uint amountA, uint amountB);
475     function removeLiquidityETHWithPermit(
476         address token,
477         uint liquidity,
478         uint amountTokenMin,
479         uint amountETHMin,
480         address to,
481         uint deadline,
482         bool approveMax, uint8 v, bytes32 r, bytes32 s
483     ) external returns (uint amountToken, uint amountETH);
484     function swapExactTokensForTokens(
485         uint amountIn,
486         uint amountOutMin,
487         address[] calldata path,
488         address to,
489         uint deadline
490     ) external returns (uint[] memory amounts);
491     function swapTokensForExactTokens(
492         uint amountOut,
493         uint amountInMax,
494         address[] calldata path,
495         address to,
496         uint deadline
497     ) external returns (uint[] memory amounts);
498     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
499         external
500         payable
501         returns (uint[] memory amounts);
502     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
503         external
504         returns (uint[] memory amounts);
505     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
506         external
507         returns (uint[] memory amounts);
508     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
509         external
510         payable
511         returns (uint[] memory amounts);
512 
513     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
514     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
515     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
516     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
517     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
518 }
519 
520 interface IUniswapV2Router02 is IUniswapV2Router01 {
521     function removeLiquidityETHSupportingFeeOnTransferTokens(
522         address token,
523         uint liquidity,
524         uint amountTokenMin,
525         uint amountETHMin,
526         address to,
527         uint deadline
528     ) external returns (uint amountETH);
529     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
530         address token,
531         uint liquidity,
532         uint amountTokenMin,
533         uint amountETHMin,
534         address to,
535         uint deadline,
536         bool approveMax, uint8 v, bytes32 r, bytes32 s
537     ) external returns (uint amountETH);
538 
539     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
540         uint amountIn,
541         uint amountOutMin,
542         address[] calldata path,
543         address to,
544         uint deadline
545     ) external;
546     function swapExactETHForTokensSupportingFeeOnTransferTokens(
547         uint amountOutMin,
548         address[] calldata path,
549         address to,
550         uint deadline
551     ) external payable;
552     function swapExactTokensForETHSupportingFeeOnTransferTokens(
553         uint amountIn,
554         uint amountOutMin,
555         address[] calldata path,
556         address to,
557         uint deadline
558     ) external;
559 }
560 pragma solidity >=0.5.0;
561 
562 interface IUniswapV2Factory {
563     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
564 
565     function feeTo() external view returns (address);
566     function feeToSetter() external view returns (address);
567 
568     function getPair(address tokenA, address tokenB) external view returns (address pair);
569     function allPairs(uint) external view returns (address pair);
570     function allPairsLength() external view returns (uint);
571 
572     function createPair(address tokenA, address tokenB) external returns (address pair);
573 
574     function setFeeTo(address) external;
575     function setFeeToSetter(address) external;
576 }
577 
578 contract BullRunFeeHandler is Ownable {
579 
580     IUniswapV2Router02 public immutable uniswapV2Router;
581     IERC20 public usdc;
582     IERC20 public brlToken;
583 
584     address public marketingWallet;
585     address public opsWallet;
586     address public farmWallet;
587 
588     event SwapAndLiquify(uint256 tokensSwapped,uint256 ethReceived,uint256 tokensIntoLiqudity);
589 
590     constructor(address _brlToken, address _marketingWallet, address _opsWallet, address _farmWallet) {
591         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
592 
593         uniswapV2Router = _uniswapV2Router;
594 
595         brlToken = IERC20(_brlToken);
596         marketingWallet = _marketingWallet;
597         opsWallet = _opsWallet;
598         farmWallet = _farmWallet;
599 
600         usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
601         IERC20(usdc).approve(address(_uniswapV2Router), type(uint256).max);
602 
603     }
604 
605     function processFees(uint256 liquidityTokens, uint256 opsTokens, uint256 marketingTokens, uint256 farmTokens) external onlyOwner {
606 
607         uint256 half = liquidityTokens / 2;
608         uint256 otherHalf = liquidityTokens - half;
609 
610         uint256 total = half + opsTokens + marketingTokens + farmTokens;
611 
612         IERC20(brlToken).approve(address(uniswapV2Router), total + otherHalf);
613 
614         address[] memory path = new address[](2);
615         path[0] = address(brlToken);
616         path[1] = address(usdc);
617 
618         // make the swap
619         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
620             total,
621             0, // accept any amount of USDC
622             path,
623             address(this),
624             block.timestamp
625         );
626 
627         uint256 usdcBalance = IERC20(usdc).balanceOf(address(this));
628         uint256 liquidity = usdcBalance * half / total;
629         uint256 marketing = usdcBalance * marketingTokens / total;
630         uint256 ops = usdcBalance * opsTokens / total;
631         uint256 farm = usdcBalance - liquidity - marketing - ops;
632 
633         uniswapV2Router.addLiquidity(
634             address(brlToken),
635             address(usdc),
636             otherHalf,
637             liquidity,
638             0,
639             0,
640             address(0xdead),
641             block.timestamp
642         );
643 
644         emit SwapAndLiquify(half, liquidity, otherHalf);
645 
646         usdc.transfer(marketingWallet, marketing);
647         usdc.transfer(opsWallet, ops);
648         usdc.transfer(farmWallet, farm);
649 
650     }
651 
652     function updateMarketingWallet(address newWallet) external onlyOwner {
653         marketingWallet = newWallet;
654     }
655 
656     function updateOpsWallet(address newWallet) external onlyOwner {
657         opsWallet = newWallet;
658     }
659 
660     function updateFarmWallet(address newWallet) external onlyOwner {
661         farmWallet = newWallet;
662     }
663 
664 }
665 
666 error InsufficientAllowance();
667 error InvalidInput();
668 error InvalidTransfer(address from, address to);
669 error TransferDelayEnabled(uint256 currentBlock, uint256 enabledBlock);
670 error ExceedsMaxTxAmount(uint256 attempt, uint256 max);
671 error ExceedsMaxWalletAmount(uint256 attempt, uint256 max);
672 error InvalidPairAddress();
673 error InvalidConfiguration();
674 
675 contract BullRun is Context, IERC20, Ownable {
676     using Address for address;
677 
678     mapping (address => uint256) private _rOwned;
679     mapping (address => uint256) private _tOwned;
680     mapping (address => mapping (address => uint256)) private _allowances;
681 
682     mapping (address => bool) private _isExcludedFromFees;
683     mapping (address => bool) public _isExcludedMaxTransactionAmount;
684 
685     mapping (address => bool) private _isExcluded;
686     address[] private _excluded;
687 
688     uint256 private constant MAX = ~uint256(0);
689     uint256 private _tTotal = 10**6 * 10**18; //1 million
690     uint256 private _rTotal = (MAX - (MAX % _tTotal));
691     uint256 private _tFeeTotal;
692 
693     string private _name = "BullRun";
694     string private _symbol = "BRL";
695     uint8 private _decimals = 18;
696 
697     IUniswapV2Router02 public immutable uniswapV2Router;
698     address public immutable uniswapV2Pair;
699 
700     BullRunFeeHandler public brlFeeHandler;
701 
702     mapping (address => bool) public automatedMarketMakerPairs;
703 
704     IERC20 public usdc;
705 
706     bool private swapping;
707     bool public swapEnabled;
708 
709     uint256 public tokensForLiquidity;
710     uint256 public tokensForOps;
711     uint256 public tokensForMarketing;
712     uint256 public tokensForFarmRewards;
713 
714     mapping(address => uint256) private _holderLastTransferTimestamp;
715 
716     uint256 public maxTransactionAmount = 5000 * 10**18; //0.5% of total supply
717     uint256 public swapTokensAtAmount = 500 * 10**18; //0.05% of total supply
718     uint256 public maxWallet = 10000 * 10**18; //1% of total supply;
719 
720     uint256 public delay = 5;
721 
722     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
723     event SwapAndLiquifyEnabledUpdated(bool enabled);
724     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
725     event UpdateFeeHandler(address indexed newAddress, address indexed oldAddress);
726 
727     constructor (address _marketingWallet, address _opsWallet, address _farmWallet) {
728         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
729 
730         excludeFromMaxTransaction(address(_uniswapV2Router), true);
731         uniswapV2Router = _uniswapV2Router;
732 
733         usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
734 
735         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
736             .createPair(address(this), address(usdc));
737 
738         excludeFromMaxTransaction(address(uniswapV2Pair), true);
739         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
740 
741         brlFeeHandler = new BullRunFeeHandler(address(this), _marketingWallet, _opsWallet, _farmWallet);
742 
743         _isExcludedFromFees[owner()] = true;
744         _isExcludedFromFees[address(this)] = true;
745         _isExcludedFromFees[address(brlFeeHandler)] = true;
746         _isExcludedFromFees[address(0xdead)] = true;
747 
748         _isExcludedMaxTransactionAmount[owner()] = true;
749         _isExcludedMaxTransactionAmount[address(this)] = true;
750         _isExcludedMaxTransactionAmount[address(brlFeeHandler)] = true;
751         _isExcludedMaxTransactionAmount[address(0xdead)] = true;
752 
753         _approve(address(this), address(uniswapV2Router), type(uint256).max);
754         _rOwned[_msgSender()] = _rTotal;
755 
756         emit Transfer(address(0), _msgSender(), _tTotal);
757     }
758 
759     function name() public view returns (string memory) {
760         return _name;
761     }
762 
763     function symbol() public view returns (string memory) {
764         return _symbol;
765     }
766 
767     function decimals() public view returns (uint8) {
768         return _decimals;
769     }
770 
771     function totalSupply() public view override returns (uint256) {
772         return _tTotal;
773     }
774 
775     function balanceOf(address account) public view override returns (uint256) {
776         if (_isExcluded[account]) return _tOwned[account];
777         return tokenFromReflection(_rOwned[account]);
778     }
779 
780     function transfer(address recipient, uint256 amount) public override returns (bool) {
781         _transfer(_msgSender(), recipient, amount);
782         return true;
783     }
784 
785     function allowance(address owner, address spender) public view override returns (uint256) {
786         return _allowances[owner][spender];
787     }
788 
789     function approve(address spender, uint256 amount) public override returns (bool) {
790         _approve(_msgSender(), spender, amount);
791         return true;
792     }
793 
794     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
795         address spender = _msgSender();
796         uint256 currentAllowance = _allowances[sender][spender];
797         if (currentAllowance != type(uint256).max) {
798             if (currentAllowance < amount) {
799                 revert InsufficientAllowance();
800             }
801             unchecked {
802                 _approve(sender, spender, currentAllowance - amount);
803             }
804         }
805         _transfer(sender, recipient, amount);
806         return true;
807     }
808 
809     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
810         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
811         return true;
812     }
813 
814     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
815         address owner = _msgSender();
816         uint256 currentAllowance = _allowances[_msgSender()][spender];
817         if (currentAllowance < subtractedValue) {
818             revert InvalidInput();
819         }
820         unchecked {
821           _approve(owner, spender, currentAllowance - subtractedValue);
822         }
823         return true;
824     }
825 
826     function isExcludedFromReward(address account) public view returns (bool) {
827         return _isExcluded[account];
828     }
829 
830     function totalFees() public view returns (uint256) {
831         return _tFeeTotal;
832     }
833 
834     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
835         if (rAmount > _rTotal) {
836             revert InvalidInput();
837         }
838         uint256 currentRate =  _getRate();
839         return rAmount / currentRate;
840     }
841 
842     function excludeFromReward(address account) public onlyOwner() {
843         if (_isExcluded[account]) {
844             revert InvalidInput();
845         }
846         if(_rOwned[account] > 0) {
847             _tOwned[account] = tokenFromReflection(_rOwned[account]);
848         }
849         _isExcluded[account] = true;
850         _excluded.push(account);
851     }
852 
853     function includeInReward(address account) public onlyOwner() {
854         if (!_isExcluded[account]) {
855             revert InvalidInput();
856         }
857         for (uint256 i = 0; i < _excluded.length; i++) {
858             if (_excluded[i] == account) {
859                 _excluded[i] = _excluded[_excluded.length - 1];
860                 _tOwned[account] = 0;
861                 _isExcluded[account] = false;
862                 _excluded.pop();
863                 break;
864             }
865         }
866     }
867 
868     function excludeFromFees(address account) public onlyOwner {
869         _isExcludedFromFees[account] = true;
870     }
871 
872     function includeInFees(address account) public onlyOwner {
873         _isExcludedFromFees[account] = false;
874     }
875 
876     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
877         maxTransactionAmount = _tTotal * maxTxPercent / 100;
878     }
879 
880     function setMaxWalletSize(uint256 maxWalletPercent) external onlyOwner() {
881         maxWallet = _tTotal * maxWalletPercent / 100;
882     }
883 
884     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
885         swapEnabled = _enabled;
886         emit SwapAndLiquifyEnabledUpdated(_enabled);
887     }
888 
889     function _getRate() private view returns(uint256) {
890         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
891         return rSupply / tSupply;
892     }
893 
894     function _getCurrentSupply() private view returns(uint256, uint256) {
895         uint256 rSupply = _rTotal;
896         uint256 tSupply = _tTotal;
897         for (uint256 i = 0; i < _excluded.length; i++) {
898             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
899             rSupply -= _rOwned[_excluded[i]];
900             tSupply -= _tOwned[_excluded[i]];
901         }
902         if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
903         return (rSupply, tSupply);
904     }
905 
906     function isExcludedFromFees(address account) public view returns(bool) {
907         return _isExcludedFromFees[account];
908     }
909 
910     function _approve(address owner, address spender, uint256 amount) private {
911         if (owner == address(0) || spender == address(0)) {
912             revert InvalidInput();
913         }
914 
915         _allowances[owner][spender] = amount;
916         emit Approval(owner, spender, amount);
917     }
918 
919     function _transfer(
920         address from,
921         address to,
922         uint256 amount
923     ) private {
924         if (from == address(0) || to == address(0)) {
925             revert InvalidTransfer(from, to);
926         }
927 
928         if(amount == 0) {
929            emit Transfer(from, to, amount);
930            return;
931         }
932 
933         if (
934             from != owner() &&
935             to != owner() &&
936             to != address(0) &&
937             to != address(0xdead) &&
938             !swapping
939         ){
940 
941             if (automatedMarketMakerPairs[from] || automatedMarketMakerPairs[to]) {
942                 uint256 delayedUntil = _holderLastTransferTimestamp[tx.origin];
943                 if (delayedUntil > block.number) {
944                     revert TransferDelayEnabled(block.number, delayedUntil);
945                 }
946                 _holderLastTransferTimestamp[tx.origin] = block.number + delay;
947             }
948 
949             if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) { //buys
950                 if (amount > maxTransactionAmount) {
951                     revert ExceedsMaxTxAmount(amount, maxTransactionAmount);
952                 }
953                 uint256 potentialBalance = amount + balanceOf(to);
954                 if (potentialBalance > maxWallet) {
955                     revert ExceedsMaxWalletAmount(potentialBalance, maxWallet);
956                 }
957 
958             } else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) { //sells
959                 if (amount > maxTransactionAmount) {
960                     revert ExceedsMaxTxAmount(amount, maxTransactionAmount);
961                 }
962             } else if(!_isExcludedMaxTransactionAmount[to]){
963                 uint256 potentialBalance = amount + balanceOf(to);
964                 if (potentialBalance > maxWallet) {
965                     revert ExceedsMaxWalletAmount(potentialBalance, maxWallet);
966                 }
967             }
968         }
969 
970         bool canSwap = balanceOf(address(brlFeeHandler)) >= swapTokensAtAmount;
971 
972         if (
973             canSwap &&
974             !swapping &&
975             swapEnabled &&
976             !automatedMarketMakerPairs[from] &&
977             !_isExcludedFromFees[from] &&
978             !_isExcludedFromFees[to]
979         ) {
980             swapping = true;
981 
982             brlFeeHandler.processFees(tokensForLiquidity, tokensForOps, tokensForMarketing, tokensForFarmRewards);
983 
984             tokensForLiquidity = 0;
985             tokensForMarketing = 0;
986             tokensForOps = 0;
987             tokensForFarmRewards = 0;
988 
989             swapping = false;
990 
991         }
992 
993         uint256 currentRate = _getRate();
994         uint256 rAmount = amount * currentRate;
995         uint256 rTransferAmount = rAmount;
996         uint256 tTransferAmount = amount;
997 
998         if (!_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
999             uint256 rBurn;
1000             uint256 rRewards;
1001 
1002             uint256 tRewards;
1003             uint256 tBurn;
1004             uint256 tRemainingFees;
1005 
1006             if (automatedMarketMakerPairs[to]) { //sell
1007                 tRewards = amount / 25;
1008                 tBurn = amount / 25;
1009                 tRemainingFees = amount * 2 / 25;
1010                 tokensForLiquidity += tRemainingFees / 4;
1011                 tokensForOps += tRemainingFees * 3 / 8;
1012                 tokensForMarketing += tRemainingFees / 4;
1013                 tokensForFarmRewards += tRemainingFees / 8;
1014 
1015             } else if (automatedMarketMakerPairs[from]) { //buy
1016                 tRewards = amount * 3 / 100;
1017                 tBurn = amount * 3 / 100;
1018                 tRemainingFees = amount * 3 / 50;
1019                 tokensForLiquidity += tRemainingFees / 6;
1020                 tokensForOps += tRemainingFees / 3;
1021                 tokensForMarketing += tRemainingFees / 3;
1022                 tokensForFarmRewards += tRemainingFees / 6;
1023             }
1024 
1025             if (tRemainingFees > 0) {
1026 
1027                 //platform fees
1028                 uint256 rRemainingFees = tRemainingFees * currentRate;
1029                 _rOwned[address(brlFeeHandler)] += rRemainingFees;
1030                 if(_isExcluded[address(brlFeeHandler)])
1031                     _tOwned[address(brlFeeHandler)] += tRemainingFees;
1032 
1033                 emit Transfer(from, address(brlFeeHandler), tRemainingFees);
1034 
1035                 //burn fee
1036                 rBurn = tBurn * currentRate;
1037                 _rTotal -= rBurn;
1038                 _tTotal -= tBurn;
1039 
1040                 emit Transfer(from, address(0xdead), tBurn);
1041 
1042                 rRewards = tRewards * _getRate();
1043                 _rTotal -= rRewards;
1044                 _tFeeTotal += tRewards;
1045                 rTransferAmount -= (rRewards + rBurn + rRemainingFees);
1046                 tTransferAmount -= (tRewards + tBurn + tRemainingFees);
1047 
1048             }
1049 
1050         }
1051 
1052         _rOwned[from] -= rAmount;
1053         _rOwned[to] += rTransferAmount;
1054 
1055         if (_isExcluded[from]) {
1056             _tOwned[from] -= amount;
1057         }
1058         if (_isExcluded[to]) {
1059             _tOwned[to] += tTransferAmount;
1060         }
1061 
1062         emit Transfer(from, to, tTransferAmount);
1063 
1064     }
1065 
1066     function updateDelayTime(uint256 newNum) external onlyOwner{
1067         delay = newNum;
1068     }
1069 
1070     function setSwapAtAmount(uint256 amount) external onlyOwner {
1071         swapTokensAtAmount = amount;
1072     }
1073 
1074     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1075         _isExcludedMaxTransactionAmount[updAds] = isEx;
1076     }
1077 
1078     function updateMarketingWallet(address newWallet) external onlyOwner {
1079         brlFeeHandler.updateMarketingWallet(newWallet);
1080     }
1081 
1082     function updateOpsWallet(address newWallet) external onlyOwner {
1083         brlFeeHandler.updateOpsWallet(newWallet);
1084     }
1085 
1086     function updateFarmWallet(address newWallet) external onlyOwner {
1087         brlFeeHandler.updateFarmWallet(newWallet);
1088     }
1089 
1090     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1091         if (pair == uniswapV2Pair) {
1092             revert InvalidPairAddress();
1093         }
1094 
1095         _setAutomatedMarketMakerPair(pair, value);
1096     }
1097 
1098     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1099         automatedMarketMakerPairs[pair] = value;
1100         if (value) excludeFromReward(pair);
1101         else includeInReward(pair);
1102         _isExcludedMaxTransactionAmount[pair] = value;
1103         emit SetAutomatedMarketMakerPair(pair, value);
1104     }
1105 
1106     function updateFeeHandler(address newAddress) public onlyOwner {
1107         if (newAddress == address(brlFeeHandler)) {
1108             revert InvalidConfiguration();
1109         }
1110 
1111         BullRunFeeHandler newFeeHandler = BullRunFeeHandler(payable(newAddress));
1112 
1113         if (newFeeHandler.owner() != address(this)) {
1114             revert InvalidConfiguration();
1115         }
1116 
1117         excludeFromMaxTransaction(address(newFeeHandler), true);
1118         excludeFromFees(address(newFeeHandler));
1119 
1120         brlFeeHandler = newFeeHandler;
1121 
1122         emit UpdateFeeHandler(newAddress, address(brlFeeHandler));
1123     }
1124 
1125 }