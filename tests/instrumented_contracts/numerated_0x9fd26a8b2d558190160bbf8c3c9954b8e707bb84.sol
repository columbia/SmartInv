1 /**
2 The answers you are looking for are right in front of you
3 
4 */
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.0;
7 
8 /*
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 
29 // File contracts/Ownable.sol
30 
31 pragma solidity ^0.8.0;
32 
33 /**
34  * @dev Contract module which provides a basic access control mechanism, where
35  * there is an account (an owner) that can be granted exclusive access to
36  * specific functions.
37  *
38  * By default, the owner account will be the one that deploys the contract. This
39  * can later be changed with {transferOwnership}.
40  *
41  * This module is used through inheritance. It will make available the modifier
42  * `onlyOwner`, which can be applied to your functions to restrict their use to
43  * the owner.
44  */
45 abstract contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor() {
54         _setOwner(_msgSender());
55     }
56 
57     /**
58      * @dev Returns the address of the current owner.
59      */
60     function owner() public view virtual returns (address) {
61         return _owner;
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(owner() == _msgSender(), "Ownable: caller is not the owner");
69         _;
70     }
71 
72     /**
73      * @dev Leaves the contract without owner. It will not be possible to call
74      * `onlyOwner` functions anymore. Can only be called by the current owner.
75      *
76      * NOTE: Renouncing ownership will leave the contract without an owner,
77      * thereby removing any functionality that is only available to the owner.
78      */
79     function renounceOwnership() public virtual onlyOwner {
80         _setOwner(address(0));
81     }
82 
83     /**
84      * @dev Transfers ownership of the contract to a new account (`newOwner`).
85      * Can only be called by the current owner.
86      */
87     function transferOwnership(address newOwner) public virtual onlyOwner {
88         require(newOwner != address(0), "Ownable: new owner is the zero address");
89         _setOwner(newOwner);
90     }
91 
92     function _setOwner(address newOwner) private {
93         address oldOwner = _owner;
94         _owner = newOwner;
95         emit OwnershipTransferred(oldOwner, newOwner);
96     }
97 }
98 
99 
100 // File contracts/IERC20.sol
101 
102 pragma solidity ^0.8.0;
103 
104 /**
105  * @dev Interface of the ERC20 standard as defined in the EIP.
106  */
107 interface IERC20 {
108     /**
109      * @dev Returns the amount of tokens in existence.
110      */
111     function totalSupply() external view returns (uint256);
112 
113     /**
114      * @dev Returns the amount of tokens owned by `account`.
115      */
116     function balanceOf(address account) external view returns (uint256);
117 
118     /**
119      * @dev Moves `amount` tokens from the caller's account to `recipient`.
120      *
121      * Returns a boolean value indicating whether the operation succeeded.
122      *
123      * Emits a {Transfer} event.
124      */
125     function transfer(address recipient, uint256 amount) external returns (bool);
126 
127     /**
128      * @dev Returns the remaining number of tokens that `spender` will be
129      * allowed to spend on behalf of `owner` through {transferFrom}. This is
130      * zero by default.
131      *
132      * This value changes when {approve} or {transferFrom} are called.
133      */
134     function allowance(address owner, address spender) external view returns (uint256);
135 
136     /**
137      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
138      *
139      * Returns a boolean value indicating whether the operation succeeded.
140      *
141      * IMPORTANT: Beware that changing an allowance with this method brings the risk
142      * that someone may use both the old and the new allowance by unfortunate
143      * transaction ordering. One possible solution to mitigate this race
144      * condition is to first reduce the spender's allowance to 0 and set the
145      * desired value afterwards:
146      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
147      *
148      * Emits an {Approval} event.
149      */
150     function approve(address spender, uint256 amount) external returns (bool);
151 
152     /**
153      * @dev Moves `amount` tokens from `sender` to `recipient` using the
154      * allowance mechanism. `amount` is then deducted from the caller's
155      * allowance.
156      *
157      * Returns a boolean value indicating whether the operation succeeded.
158      *
159      * Emits a {Transfer} event.
160      */
161     function transferFrom(
162         address sender,
163         address recipient,
164         uint256 amount
165     ) external returns (bool);
166 
167     /**
168      * @dev Emitted when `value` tokens are moved from one account (`from`) to
169      * another (`to`).
170      *
171      * Note that `value` may be zero.
172      */
173     event Transfer(address indexed from, address indexed to, uint256 value);
174 
175     /**
176      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
177      * a call to {approve}. `value` is the new allowance.
178      */
179     event Approval(address indexed owner, address indexed spender, uint256 value);
180 }
181 
182 
183 // File contracts/IUniswapV2Router01.sol
184 
185 pragma solidity >=0.6.2;
186 
187 interface IUniswapV2Router01 {
188     function factory() external pure returns (address);
189     function WETH() external pure returns (address);
190 
191     function addLiquidity(
192         address tokenA,
193         address tokenB,
194         uint amountADesired,
195         uint amountBDesired,
196         uint amountAMin,
197         uint amountBMin,
198         address to,
199         uint deadline
200     ) external returns (uint amountA, uint amountB, uint liquidity);
201     function addLiquidityETH(
202         address token,
203         uint amountTokenDesired,
204         uint amountTokenMin,
205         uint amountETHMin,
206         address to,
207         uint deadline
208     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
209     function removeLiquidity(
210         address tokenA,
211         address tokenB,
212         uint liquidity,
213         uint amountAMin,
214         uint amountBMin,
215         address to,
216         uint deadline
217     ) external returns (uint amountA, uint amountB);
218     function removeLiquidityETH(
219         address token,
220         uint liquidity,
221         uint amountTokenMin,
222         uint amountETHMin,
223         address to,
224         uint deadline
225     ) external returns (uint amountToken, uint amountETH);
226     function removeLiquidityWithPermit(
227         address tokenA,
228         address tokenB,
229         uint liquidity,
230         uint amountAMin,
231         uint amountBMin,
232         address to,
233         uint deadline,
234         bool approveMax, uint8 v, bytes32 r, bytes32 s
235     ) external returns (uint amountA, uint amountB);
236     function removeLiquidityETHWithPermit(
237         address token,
238         uint liquidity,
239         uint amountTokenMin,
240         uint amountETHMin,
241         address to,
242         uint deadline,
243         bool approveMax, uint8 v, bytes32 r, bytes32 s
244     ) external returns (uint amountToken, uint amountETH);
245     function swapExactTokensForTokens(
246         uint amountIn,
247         uint amountOutMin,
248         address[] calldata path,
249         address to,
250         uint deadline
251     ) external returns (uint[] memory amounts);
252     function swapTokensForExactTokens(
253         uint amountOut,
254         uint amountInMax,
255         address[] calldata path,
256         address to,
257         uint deadline
258     ) external returns (uint[] memory amounts);
259     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
260         external
261         payable
262         returns (uint[] memory amounts);
263     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
264         external
265         returns (uint[] memory amounts);
266     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
267         external
268         returns (uint[] memory amounts);
269     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
270         external
271         payable
272         returns (uint[] memory amounts);
273 
274     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
275     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
276     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
277     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
278     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
279 }
280 
281 
282 // File contracts/IUniswapV2Router02.sol
283 
284 pragma solidity >=0.6.2;
285 
286 interface IUniswapV2Router02 is IUniswapV2Router01 {
287     function removeLiquidityETHSupportingFeeOnTransferTokens(
288         address token,
289         uint liquidity,
290         uint amountTokenMin,
291         uint amountETHMin,
292         address to,
293         uint deadline
294     ) external returns (uint amountETH);
295     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
296         address token,
297         uint liquidity,
298         uint amountTokenMin,
299         uint amountETHMin,
300         address to,
301         uint deadline,
302         bool approveMax, uint8 v, bytes32 r, bytes32 s
303     ) external returns (uint amountETH);
304 
305     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
306         uint amountIn,
307         uint amountOutMin,
308         address[] calldata path,
309         address to,
310         uint deadline
311     ) external;
312     function swapExactETHForTokensSupportingFeeOnTransferTokens(
313         uint amountOutMin,
314         address[] calldata path,
315         address to,
316         uint deadline
317     ) external payable;
318     function swapExactTokensForETHSupportingFeeOnTransferTokens(
319         uint amountIn,
320         uint amountOutMin,
321         address[] calldata path,
322         address to,
323         uint deadline
324     ) external;
325 }
326 
327 
328 // File contracts/IUniswapV2Factory.sol
329 
330 pragma solidity >=0.5.0;
331 
332 interface IUniswapV2Factory {
333     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
334 
335     function feeTo() external view returns (address);
336     function feeToSetter() external view returns (address);
337 
338     function getPair(address tokenA, address tokenB) external view returns (address pair);
339     function allPairs(uint) external view returns (address pair);
340     function allPairsLength() external view returns (uint);
341 
342     function createPair(address tokenA, address tokenB) external returns (address pair);
343 
344     function setFeeTo(address) external;
345     function setFeeToSetter(address) external;
346 }
347 
348 
349 // File contracts/Address.sol
350 
351 pragma solidity ^0.8.0;
352 
353 /**
354  * @dev Collection of functions related to the address type
355  */
356 library Address {
357     /**
358      * @dev Returns true if `account` is a contract.
359      *
360      * [IMPORTANT]
361      * ====
362      * It is unsafe to assume that an address for which this function returns
363      * false is an externally-owned account (EOA) and not a contract.
364      *
365      * Among others, `isContract` will return false for the following
366      * types of addresses:
367      *
368      *  - an externally-owned account
369      *  - a contract in construction
370      *  - an address where a contract will be created
371      *  - an address where a contract lived, but was destroyed
372      * ====
373      */
374     function isContract(address account) internal view returns (bool) {
375         // This method relies on extcodesize, which returns 0 for contracts in
376         // construction, since the code is only stored at the end of the
377         // constructor execution.
378 
379         uint256 size;
380         assembly {
381             size := extcodesize(account)
382         }
383         return size > 0;
384     }
385 
386     /**
387      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
388      * `recipient`, forwarding all available gas and reverting on errors.
389      *
390      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
391      * of certain opcodes, possibly making contracts go over the 2300 gas limit
392      * imposed by `transfer`, making them unable to receive funds via
393      * `transfer`. {sendValue} removes this limitation.
394      *
395      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
396      *
397      * IMPORTANT: because control is transferred to `recipient`, care must be
398      * taken to not create reentrancy vulnerabilities. Consider using
399      * {ReentrancyGuard} or the
400      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
401      */
402     function sendValue(address payable recipient, uint256 amount) internal {
403         require(address(this).balance >= amount, "Address: insufficient balance");
404 
405         (bool success, ) = recipient.call{value: amount}("");
406         require(success, "Address: unable to send value, recipient may have reverted");
407     }
408 
409     /**
410      * @dev Performs a Solidity function call using a low level `call`. A
411      * plain `call` is an unsafe replacement for a function call: use this
412      * function instead.
413      *
414      * If `target` reverts with a revert reason, it is bubbled up by this
415      * function (like regular Solidity function calls).
416      *
417      * Returns the raw returned data. To convert to the expected return value,
418      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
419      *
420      * Requirements:
421      *
422      * - `target` must be a contract.
423      * - calling `target` with `data` must not revert.
424      *
425      * _Available since v3.1._
426      */
427     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
428         return functionCall(target, data, "Address: low-level call failed");
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
433      * `errorMessage` as a fallback revert reason when `target` reverts.
434      *
435      * _Available since v3.1._
436      */
437     function functionCall(
438         address target,
439         bytes memory data,
440         string memory errorMessage
441     ) internal returns (bytes memory) {
442         return functionCallWithValue(target, data, 0, errorMessage);
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
447      * but also transferring `value` wei to `target`.
448      *
449      * Requirements:
450      *
451      * - the calling contract must have an ETH balance of at least `value`.
452      * - the called Solidity function must be `payable`.
453      *
454      * _Available since v3.1._
455      */
456     function functionCallWithValue(
457         address target,
458         bytes memory data,
459         uint256 value
460     ) internal returns (bytes memory) {
461         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
462     }
463 
464     /**
465      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
466      * with `errorMessage` as a fallback revert reason when `target` reverts.
467      *
468      * _Available since v3.1._
469      */
470     function functionCallWithValue(
471         address target,
472         bytes memory data,
473         uint256 value,
474         string memory errorMessage
475     ) internal returns (bytes memory) {
476         require(address(this).balance >= value, "Address: insufficient balance for call");
477         require(isContract(target), "Address: call to non-contract");
478 
479         (bool success, bytes memory returndata) = target.call{value: value}(data);
480         return verifyCallResult(success, returndata, errorMessage);
481     }
482 
483     /**
484      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
485      * but performing a static call.
486      *
487      * _Available since v3.3._
488      */
489     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
490         return functionStaticCall(target, data, "Address: low-level static call failed");
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
495      * but performing a static call.
496      *
497      * _Available since v3.3._
498      */
499     function functionStaticCall(
500         address target,
501         bytes memory data,
502         string memory errorMessage
503     ) internal view returns (bytes memory) {
504         require(isContract(target), "Address: static call to non-contract");
505 
506         (bool success, bytes memory returndata) = target.staticcall(data);
507         return verifyCallResult(success, returndata, errorMessage);
508     }
509 
510     /**
511      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
512      * but performing a delegate call.
513      *
514      * _Available since v3.4._
515      */
516     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
517         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
522      * but performing a delegate call.
523      *
524      * _Available since v3.4._
525      */
526     function functionDelegateCall(
527         address target,
528         bytes memory data,
529         string memory errorMessage
530     ) internal returns (bytes memory) {
531         require(isContract(target), "Address: delegate call to non-contract");
532 
533         (bool success, bytes memory returndata) = target.delegatecall(data);
534         return verifyCallResult(success, returndata, errorMessage);
535     }
536 
537     /**
538      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
539      * revert reason using the provided one.
540      *
541      * _Available since v4.3._
542      */
543     function verifyCallResult(
544         bool success,
545         bytes memory returndata,
546         string memory errorMessage
547     ) internal pure returns (bytes memory) {
548         if (success) {
549             return returndata;
550         } else {
551             // Look for revert reason and bubble it up if present
552             if (returndata.length > 0) {
553                 // The easiest way to bubble the revert reason is using memory via assembly
554 
555                 assembly {
556                     let returndata_size := mload(returndata)
557                     revert(add(32, returndata), returndata_size)
558                 }
559             } else {
560                 revert(errorMessage);
561             }
562         }
563     }
564 }
565 
566 
567 // File contracts
568 pragma solidity ^0.8.0;
569 
570 contract Rokurokubi is Context, IERC20, Ownable {
571     
572     using Address for address payable;
573     mapping(address => uint256) private _rOwned;
574     mapping(address => uint256) private _tOwned;
575     mapping(address => mapping(address => uint256)) private _allowances;
576     mapping(address => bool) private _isExcludedFromFee;
577     mapping(address => bool) private _isExcluded;
578     mapping(address => bool) private _isExcludedFromMaxWallet;
579 
580 
581     mapping(address => bool) public isBot;
582 
583     address[] private _excluded;
584 
585     uint8 private constant _decimals = 9;
586     uint256 private constant MAX = ~uint256(0);
587 
588     uint256 private _tTotal = 1_000_000_000 * 10**_decimals;
589     uint256 private _rTotal = (MAX - (MAX % _tTotal));
590 
591     uint256 public maxTxAmountBuy = _tTotal / 50; // 2% of supply
592     uint256 public maxTxAmountSell = _tTotal / 50; // 2% of supply
593     uint256 public maxWalletAmount = _tTotal / 50; // 2% of supply
594     uint256 public tokenstosell = 0;
595 
596     //antisnipers
597     uint256 public liqAddedBlockNumber;
598     uint256 public blocksToWait = 0;
599 
600     address payable public treasuryAddress;
601     address payable public devAddress;
602     mapping(address => bool) public isAutomatedMarketMakerPair;
603 
604     string private constant _name = "Rokurokubi";
605     string private constant _symbol = "$ROKU";
606     bool private inSwapAndLiquify;
607 
608     IUniswapV2Router02 public UniswapV2Router;
609     address public uniswapPair;
610     bool public swapAndLiquifyEnabled = true;
611     uint256 public numTokensSellToAddToLiquidity = _tTotal * 3 / 1000; //0.3%
612 
613     struct feeRatesStruct {
614         uint8 rfi;
615         uint8 treasury;
616         uint8 dev;
617         uint8 lp;
618         uint8 toSwap;
619     }
620 
621     // Max Tax at launch to avoid snipers & bots. Changed when officially launch
622     feeRatesStruct public buyRates =
623         feeRatesStruct({
624             rfi: 0, //  RFI rate, in %
625             dev: 0, // dev team fee in %
626             treasury: 0, // treasury fee in %
627             lp: 0, // lp rate in %
628             toSwap: 0 // treasury + dev + lp
629         });
630 
631     feeRatesStruct public sellRates =
632         feeRatesStruct({
633             rfi: 0, //  RFI rate, in %
634             dev: 0, // dev team fee in %
635             treasury: 0, // treasury fee in %
636             lp: 0, // lp rate in %
637             toSwap: 0 // treasury + dev + lp
638         });
639 
640     feeRatesStruct private appliedRates = buyRates;
641 
642     struct TotFeesPaidStruct {
643         uint256 rfi;
644         uint256 toSwap;
645     }
646     TotFeesPaidStruct public totFeesPaid;
647 
648     struct valuesFromGetValues {
649         uint256 rAmount;
650         uint256 rTransferAmount;
651         uint256 rRfi;
652         uint256 rToSwap;
653         uint256 tTransferAmount;
654         uint256 tRfi;
655         uint256 tToSwap;
656     }
657 
658     event SwapAndLiquifyEnabledUpdated(bool enabled);
659     event SwapAndLiquify(
660         uint256 tokensSwapped,
661         uint256 ETHReceived,
662         uint256 tokensIntotoSwap
663     );
664     event LiquidityAdded(uint256 tokenAmount, uint256 ETHAmount);
665     event TreasuryAndDevFeesAdded(uint256 devFee, uint256 treasuryFee);
666     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
667     event BlacklistedUser(address botAddress, bool indexed value);
668     event MaxWalletAmountUpdated(uint256 amount);
669     event ExcludeFromMaxWallet(address account, bool indexed isExcluded);
670 
671     modifier lockTheSwap() {
672         inSwapAndLiquify = true;
673         _;
674         inSwapAndLiquify = false;
675     }
676 
677     constructor() {
678         IUniswapV2Router02 _UniswapV2Router = IUniswapV2Router02(
679             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
680         );
681         uniswapPair = IUniswapV2Factory(_UniswapV2Router.factory()).createPair(address(this), _UniswapV2Router.WETH());
682         isAutomatedMarketMakerPair[uniswapPair] = true;
683         emit SetAutomatedMarketMakerPair(uniswapPair, true);
684         UniswapV2Router = _UniswapV2Router;
685         _rOwned[owner()] = _rTotal;
686         treasuryAddress = payable(msg.sender);
687         devAddress = payable(msg.sender);
688         _isExcludedFromFee[owner()] = true;
689         _isExcludedFromFee[treasuryAddress] = true;
690         _isExcludedFromFee[devAddress] = true;
691         _isExcludedFromFee[address(this)] = true;
692 
693         _isExcludedFromMaxWallet[owner()] = true;
694         _isExcludedFromMaxWallet[treasuryAddress] = true;
695         _isExcludedFromMaxWallet[devAddress] = true;
696         _isExcludedFromMaxWallet[address(this)] = true;
697 
698         _isExcludedFromMaxWallet[uniswapPair] = true;
699 
700         emit Transfer(address(0), owner(), _tTotal);
701     }
702 
703     //std ERC20:
704     function name() public pure returns (string memory) {
705         return _name;
706     }
707 
708     function symbol() public pure returns (string memory) {
709         return _symbol;
710     }
711 
712     function decimals() public pure returns (uint8) {
713         return _decimals;
714     }
715 
716     //override ERC20:
717     function totalSupply() public view override returns (uint256) {
718         return _tTotal;
719     }
720 
721     function balanceOf(address account) public view override returns (uint256) {
722         if (_isExcluded[account]) return _tOwned[account];
723         return tokenFromReflection(_rOwned[account]);
724     }
725 
726     function transfer(address recipient, uint256 amount)
727         public
728         override
729         returns (bool)
730     {
731         _transfer(_msgSender(), recipient, amount);
732         return true;
733     }
734 
735     function allowance(address owner, address spender)
736         public
737         view
738         override
739         returns (uint256)
740     {
741         return _allowances[owner][spender];
742     }
743 
744     function approve(address spender, uint256 amount)
745         public
746         override
747         returns (bool)
748     {
749         _approve(_msgSender(), spender, amount);
750         return true;
751     }
752 
753     function transferFrom(
754         address sender,
755         address recipient,
756         uint256 amount
757     ) public override returns (bool) {
758         _transfer(sender, recipient, amount);
759 
760         uint256 currentAllowance = _allowances[sender][_msgSender()];
761         require(
762             currentAllowance >= amount,
763             "ERC20: transfer amount exceeds allowance"
764         );
765         unchecked {
766             _approve(sender, _msgSender(), currentAllowance - amount);
767         }
768 
769         return true;
770     }
771 
772     function increaseAllowance(address spender, uint256 addedValue)
773         public
774         virtual
775         returns (bool)
776     {
777         _approve(
778             _msgSender(),
779             spender,
780             _allowances[_msgSender()][spender] + addedValue
781         );
782         return true;
783     }
784 
785     function decreaseAllowance(address spender, uint256 subtractedValue)
786         public
787         virtual
788         returns (bool)
789     {
790         uint256 currentAllowance = _allowances[_msgSender()][spender];
791         require(
792             currentAllowance >= subtractedValue,
793             "ERC20: decreased allowance below zero"
794         );
795         unchecked {
796             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
797         }
798 
799         return true;
800     }
801 
802     function isExcludedFromReward(address account) public view returns (bool) {
803         return _isExcluded[account];
804     }
805 
806     function reflectionFromToken(uint256 tAmount, bool deductTransferRfi)
807         public
808         view
809         returns (uint256)
810     {
811         require(tAmount <= _tTotal, "Amount must be less than supply");
812         if (!deductTransferRfi) {
813             valuesFromGetValues memory s = _getValues(tAmount, true);
814             return s.rAmount;
815         } else {
816             valuesFromGetValues memory s = _getValues(tAmount, true);
817             return s.rTransferAmount;
818         }
819     }
820 
821     function tokenFromReflection(uint256 rAmount)
822         public
823         view
824         returns (uint256)
825     {
826         require(
827             rAmount <= _rTotal,
828             "Amount must be less than total reflections"
829         );
830         uint256 currentRate = _getRate();
831         return rAmount / currentRate;
832     }
833 
834     //No current rfi - Tiered Rewarding Feature Applied at APP Launch
835     function excludeFromReward(address account) external onlyOwner {
836         require(!_isExcluded[account], "Account is already excluded");
837         if (_rOwned[account] > 0) {
838             _tOwned[account] = tokenFromReflection(_rOwned[account]);
839         }
840         _isExcluded[account] = true;
841         _excluded.push(account);
842     }
843 
844     function includeInReward(address account) external onlyOwner {
845         require(_isExcluded[account], "Account is not excluded");
846         for (uint256 i = 0; i < _excluded.length; i++) {
847             if (_excluded[i] == account) {
848                 _excluded[i] = _excluded[_excluded.length - 1];
849                 _tOwned[account] = 0;
850                 _isExcluded[account] = false;
851                 _excluded.pop();
852                 break;
853             }
854         }
855     }
856 
857     function excludeFromFee(address account) external onlyOwner {
858         _isExcludedFromFee[account] = true;
859     }
860 
861 
862     function includeInFee(address account) external onlyOwner {
863         _isExcludedFromFee[account] = false;
864     }
865 
866     function isExcludedFromFee(address account) public view returns (bool) {
867         return _isExcludedFromFee[account];
868     }
869 
870     function isExcludedFromMaxWallet(address account)
871         public
872         view
873         returns (bool)
874     {
875         return _isExcludedFromMaxWallet[account];
876     }
877 
878     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
879         swapAndLiquifyEnabled = _enabled;
880         emit SwapAndLiquifyEnabledUpdated(_enabled);
881     }
882 
883     //  @dev receive ETH from UniswapV2Router when swapping
884     receive() external payable {}
885 
886     function _reflectRfi(uint256 rRfi, uint256 tRfi) private {
887         _rTotal -= rRfi;
888         totFeesPaid.rfi += tRfi;
889     }
890 
891     function _takeToSwap(uint256 rToSwap, uint256 tToSwap) private {
892         _rOwned[address(this)] += rToSwap;
893         if (_isExcluded[address(this)]) _tOwned[address(this)] += tToSwap;
894         totFeesPaid.toSwap += tToSwap;
895     }
896 
897     function _getValues(uint256 tAmount, bool takeFee)
898         private
899         view
900         returns (valuesFromGetValues memory to_return)
901     {
902         to_return = _getTValues(tAmount, takeFee);
903         (
904             to_return.rAmount,
905             to_return.rTransferAmount,
906             to_return.rRfi,
907             to_return.rToSwap
908         ) = _getRValues(to_return, tAmount, takeFee, _getRate());
909         return to_return;
910     }
911 
912     function _getTValues(uint256 tAmount, bool takeFee)
913         private
914         view
915         returns (valuesFromGetValues memory s)
916     {
917         if (!takeFee) {
918             s.tTransferAmount = tAmount;
919             return s;
920         }
921         s.tRfi = (tAmount * appliedRates.rfi) / 100;
922         s.tToSwap = (tAmount * appliedRates.toSwap) / 100;
923         s.tTransferAmount = tAmount - s.tRfi - s.tToSwap;
924         return s;
925     }
926 
927     function _getRValues(
928         valuesFromGetValues memory s,
929         uint256 tAmount,
930         bool takeFee,
931         uint256 currentRate
932     )
933         private
934         pure
935         returns (
936             uint256 rAmount,
937             uint256 rTransferAmount,
938             uint256 rRfi,
939             uint256 rToSwap
940         )
941     {
942         rAmount = tAmount * currentRate;
943 
944         if (!takeFee) {
945             return (rAmount, rAmount, 0, 0);
946         }
947 
948         rRfi = s.tRfi * currentRate;
949         rToSwap = s.tToSwap * currentRate;
950         rTransferAmount = rAmount - rRfi - rToSwap;
951         return (rAmount, rTransferAmount, rRfi, rToSwap);
952     }
953 
954     function _getRate() private view returns (uint256) {
955         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
956         return rSupply / tSupply;
957     }
958 
959     function _getCurrentSupply() private view returns (uint256, uint256) {
960         uint256 rSupply = _rTotal;
961         uint256 tSupply = _tTotal;
962         for (uint256 i = 0; i < _excluded.length; i++) {
963             if (
964                 _rOwned[_excluded[i]] > rSupply ||
965                 _tOwned[_excluded[i]] > tSupply
966             ) return (_rTotal, _tTotal);
967             rSupply -= _rOwned[_excluded[i]];
968             tSupply -= _tOwned[_excluded[i]];
969         }
970         if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
971         return (rSupply, tSupply);
972     }
973 
974     function _approve(
975         address owner,
976         address spender,
977         uint256 amount
978     ) private {
979         require(owner != address(0), "ERC20: approve from the zero address");
980         require(spender != address(0), "ERC20: approve to the zero address");
981         _allowances[owner][spender] = amount;
982         emit Approval(owner, spender, amount);
983     }
984 
985     function _transfer(
986         address from,
987         address to,
988         uint256 amount
989     ) private {
990         if (liqAddedBlockNumber == 0 && isAutomatedMarketMakerPair[to]) {
991             liqAddedBlockNumber = block.number;
992         }
993 
994         require(from != address(0), "ERC20: transfer from the zero address");
995         require(to != address(0), "ERC20: transfer to the zero address");
996         require(!isBot[from], "ERC20: address blacklisted (bot)");
997         require(amount > 0, "Transfer amount must be greater than zero");
998         require(
999             amount <= balanceOf(from),
1000             "You are trying to transfer more than your balance"
1001         );
1002         bool takeFee = !(_isExcludedFromFee[from] || _isExcludedFromFee[to]);
1003 
1004         if (takeFee) {
1005             if (isAutomatedMarketMakerPair[from]) {
1006                 if (block.number < liqAddedBlockNumber + blocksToWait) {
1007                     isBot[to] = true;
1008                     emit BlacklistedUser(to, true);
1009                 }
1010 
1011                 appliedRates = buyRates;
1012                 require(
1013                     amount <= maxTxAmountBuy,
1014                     "amount must be <= maxTxAmountBuy"
1015                 );
1016             } else {
1017                 appliedRates = sellRates;
1018                 require(
1019                     amount <= maxTxAmountSell,
1020                     "amount must be <= maxTxAmountSell"
1021                 );
1022             }
1023         }
1024 
1025         if (
1026             balanceOf(address(this)) >= numTokensSellToAddToLiquidity &&
1027             !inSwapAndLiquify &&
1028             !isAutomatedMarketMakerPair[from] &&
1029             swapAndLiquifyEnabled
1030         ) {
1031             //add liquidity
1032             swapAndLiquify(numTokensSellToAddToLiquidity);
1033         }
1034 
1035         _tokenTransfer(from, to, amount, takeFee);
1036     }
1037 
1038     //this method is responsible for taking all fee, if takeFee is true
1039     function _tokenTransfer(
1040         address sender,
1041         address recipient,
1042         uint256 tAmount,
1043         bool takeFee
1044     ) private {
1045         valuesFromGetValues memory s = _getValues(tAmount, takeFee);
1046 
1047         if (_isExcluded[sender]) {
1048             _tOwned[sender] -= tAmount;
1049         }
1050         if (_isExcluded[recipient]) {
1051             _tOwned[recipient] += s.tTransferAmount;
1052         }
1053 
1054         _rOwned[sender] -= s.rAmount;
1055         _rOwned[recipient] += s.rTransferAmount;
1056         if (takeFee) {
1057             _reflectRfi(s.rRfi, s.tRfi);
1058             _takeToSwap(s.rToSwap, s.tToSwap);
1059             emit Transfer(sender, address(this), s.tToSwap);
1060         }
1061         require(
1062             _isExcludedFromMaxWallet[recipient] ||
1063                 balanceOf(recipient) <= maxWalletAmount,
1064             "Recipient cannot hold more than maxWalletAmount"
1065         );
1066         emit Transfer(sender, recipient, s.tTransferAmount);
1067     }
1068 
1069     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1070         uint256 denominator = appliedRates.toSwap * 2;
1071         uint256 tokensToAddLiquidityWith = (contractTokenBalance *
1072             appliedRates.lp) / denominator;
1073         uint256 toSwap = contractTokenBalance - tokensToAddLiquidityWith;
1074 
1075         uint256 initialBalance = address(this).balance;
1076 
1077         // swap tokens for ETH
1078         swapTokensForETH(toSwap);
1079 
1080         uint256 deltaBalance = address(this).balance - initialBalance;
1081         uint256 ETHToAddLiquidityWith = (deltaBalance * appliedRates.lp) /
1082             (denominator - appliedRates.lp);
1083 
1084         // add liquidity
1085         addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith);
1086 
1087         // we give the remaining tax to dev & treasury wallets
1088         uint256 remainingBalance = address(this).balance;
1089         uint256 devFee = (remainingBalance * appliedRates.dev) /
1090             (denominator - appliedRates.dev);
1091         uint256 treasuryFee = (remainingBalance * appliedRates.treasury) /
1092             (denominator - appliedRates.treasury);
1093         devAddress.sendValue(devFee);
1094         treasuryAddress.sendValue(treasuryFee);
1095     }
1096 
1097     function swapTokensForETH(uint256 tokenAmount) private {
1098         // generate the pair path of token
1099         address[] memory path = new address[](2);
1100         path[0] = address(this);
1101         path[1] = UniswapV2Router.WETH();
1102 
1103         if (allowance(address(this), address(UniswapV2Router)) < tokenAmount) {
1104             _approve(address(this), address(UniswapV2Router), ~uint256(0));
1105         }
1106 
1107         // make the swap
1108         UniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1109             tokenAmount,
1110             0, // accept any amount of ETH
1111             path,
1112             address(this),
1113             block.timestamp
1114         );
1115     }
1116 
1117     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
1118         // add the liquidity
1119         UniswapV2Router.addLiquidityETH{value: ETHAmount}(
1120             address(this),
1121             tokenAmount,
1122             0, // slippage is unavoidable
1123             0, // slippage is unavoidable
1124             devAddress,
1125             block.timestamp
1126         );
1127         emit LiquidityAdded(tokenAmount, ETHAmount);
1128     }
1129 
1130     function setAutomatedMarketMakerPair(address _pair, bool value)
1131         external
1132         onlyOwner
1133     {
1134         require(
1135             isAutomatedMarketMakerPair[_pair] != value,
1136             "Automated market maker pair is already set to that value"
1137         );
1138         isAutomatedMarketMakerPair[_pair] = value;
1139         if (value) {
1140             _isExcludedFromMaxWallet[_pair] = true;
1141             emit ExcludeFromMaxWallet(_pair, value);
1142         }
1143         emit SetAutomatedMarketMakerPair(_pair, value);
1144     }
1145 
1146     function setBuyFees(
1147         uint8 _rfi,
1148         uint8 _treasury,
1149         uint8 _dev,
1150         uint8 _lp
1151     ) external onlyOwner {
1152         buyRates.rfi = _rfi;
1153         buyRates.treasury = _treasury;
1154         buyRates.dev = _dev;
1155         buyRates.lp = _lp;
1156         buyRates.toSwap = _treasury + _dev + _lp;
1157     }
1158 
1159     function setSellFees(
1160         uint8 _rfi,
1161         uint8 _treasury,
1162         uint8 _dev,
1163         uint8 _lp
1164     ) external onlyOwner {
1165         sellRates.rfi = _rfi;
1166         sellRates.treasury = _treasury;
1167         sellRates.dev = _dev;
1168         sellRates.lp = _lp;
1169         sellRates.toSwap = _treasury + _dev + _lp;
1170     }
1171 
1172     function setMaxTransactionAmount(
1173         uint256 _maxTxAmountBuyPct,
1174         uint256 _maxTxAmountSellPct
1175     ) external onlyOwner {
1176         maxTxAmountBuy = _tTotal / _maxTxAmountBuyPct; // 100 = 1%, 50 = 2% etc.
1177         maxTxAmountSell = _tTotal / _maxTxAmountSellPct; // 100 = 1%, 50 = 2% etc.
1178     }
1179 
1180     function setNumTokensSellToAddToLiq(uint256 amountTokens)
1181         external
1182         onlyOwner
1183     {
1184         numTokensSellToAddToLiquidity = amountTokens * 10**_decimals;
1185     }
1186 
1187     function setTreasuryAddress(address payable _treasuryAddress)
1188         external
1189         onlyOwner
1190     {
1191         treasuryAddress = _treasuryAddress;
1192     }
1193 
1194     function setDevAddress(address payable _devAddress) external onlyOwner {
1195         devAddress = _devAddress;
1196     }
1197 
1198     function manualSwapAll() external onlyOwner {
1199         swapAndLiquify(balanceOf(address(this)));
1200     }
1201 
1202     //Manual swap percent of outstanding token
1203     function manualSwapPercentage(uint256 tokenpercentage) external onlyOwner {
1204         tokenstosell = (balanceOf(address(this))*tokenpercentage)/1000;
1205   	    swapTokensForETH(tokenstosell);
1206         payable(devAddress).sendValue(address(this).balance);
1207     }
1208      //Use this in case ETH are sent to the contract by mistake
1209     function rescueETH() external {
1210         devAddress.sendValue(address(this).balance);
1211     }
1212     
1213     function rescueAnyERC20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {
1214         IERC20(_tokenAddr).transfer(_to, _amount);
1215     }
1216 
1217     // To exclude bots & snipers
1218     function isBots(address botAddress, bool isban) external onlyOwner {      
1219         isBot[botAddress] = isban;
1220     }
1221 
1222     function setMaxWalletAmount(uint256 _maxWalletAmountPct) external onlyOwner {
1223         maxWalletAmount = _tTotal / _maxWalletAmountPct; // 100 = 1%, 50 = 2% etc.
1224         emit MaxWalletAmountUpdated(maxWalletAmount);
1225     }
1226 
1227     function excludeFromMaxWallet(address account, bool excluded)
1228         external
1229         onlyOwner
1230     {
1231         require(
1232             _isExcludedFromMaxWallet[account] != excluded,
1233             "_isExcludedFromMaxWallet already set to that value"
1234         );
1235         _isExcludedFromMaxWallet[account] = excluded;
1236 
1237         emit ExcludeFromMaxWallet(account, excluded);
1238     }
1239 }