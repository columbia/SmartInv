1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.8.19;
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
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16 
17     function balanceOf(address account) external view returns (uint256);
18 
19     function transfer(address recipient, uint256 amount)
20         external
21         returns (bool);
22 
23     function allowance(address owner, address spender)
24         external
25         view
26         returns (uint256);
27 
28     function approve(address spender, uint256 amount) external returns (bool);
29 
30     function transferFrom(
31         address sender,
32         address recipient,
33         uint256 amount
34     ) external returns (bool);
35 
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(
38         address indexed owner,
39         address indexed spender,
40         uint256 value
41     );
42 }
43 
44 /**
45  * @dev Collection of functions related to the address type
46  */
47 library Address {
48     /**
49      * @dev Returns true if `account` is a contract.
50      *
51      * [IMPORTANT]
52      * ====
53      * It is unsafe to assume that an address for which this function returns
54      * false is an externally-owned account (EOA) and not a contract.
55      *
56      * Among others, `isContract` will return false for the following
57      * types of addresses:
58      *
59      *  - an externally-owned account
60      *  - a contract in construction
61      *  - an address where a contract will be created
62      *  - an address where a contract lived, but was destroyed
63      * ====
64      *
65      * [IMPORTANT]
66      * ====
67      * You shouldn't rely on `isContract` to protect against flash loan attacks!
68      *
69      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
70      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
71      * constructor.
72      * ====
73      */
74     function isContract(address account) internal view returns (bool) {
75         // This method relies on extcodesize/address.code.length, which returns 0
76         // for contracts in construction, since the code is only stored at the end
77         // of the constructor execution.
78 
79         return account.code.length > 0;
80     }
81 
82     /**
83      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
84      * `recipient`, forwarding all available gas and reverting on errors.
85      *
86      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
87      * of certain opcodes, possibly making contracts go over the 2300 gas limit
88      * imposed by `transfer`, making them unable to receive funds via
89      * `transfer`. {sendValue} removes this limitation.
90      *
91      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
92      *
93      * IMPORTANT: because control is transferred to `recipient`, care must be
94      * taken to not create reentrancy vulnerabilities. Consider using
95      * {ReentrancyGuard} or the
96      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
97      */
98     function sendValue(address payable recipient, uint256 amount) internal {
99         require(
100             address(this).balance >= amount,
101             "Address: insufficient balance"
102         );
103 
104         (bool success, ) = recipient.call{value: amount}("");
105         require(
106             success,
107             "Address: unable to send value, recipient may have reverted"
108         );
109     }
110 
111     /**
112      * @dev Performs a Solidity function call using a low level `call`. A
113      * plain `call` is an unsafe replacement for a function call: use this
114      * function instead.
115      *
116      * If `target` reverts with a revert reason, it is bubbled up by this
117      * function (like regular Solidity function calls).
118      *
119      * Returns the raw returned data. To convert to the expected return value,
120      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
121      *
122      * Requirements:
123      *
124      * - `target` must be a contract.
125      * - calling `target` with `data` must not revert.
126      *
127      * _Available since v3.1._
128      */
129     function functionCall(address target, bytes memory data)
130         internal
131         returns (bytes memory)
132     {
133         return
134             functionCallWithValue(
135                 target,
136                 data,
137                 0,
138                 "Address: low-level call failed"
139             );
140     }
141 
142     /**
143      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
144      * `errorMessage` as a fallback revert reason when `target` reverts.
145      *
146      * _Available since v3.1._
147      */
148     function functionCall(
149         address target,
150         bytes memory data,
151         string memory errorMessage
152     ) internal returns (bytes memory) {
153         return functionCallWithValue(target, data, 0, errorMessage);
154     }
155 
156     /**
157      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
158      * but also transferring `value` wei to `target`.
159      *
160      * Requirements:
161      *
162      * - the calling contract must have an ETH balance of at least `value`.
163      * - the called Solidity function must be `payable`.
164      *
165      * _Available since v3.1._
166      */
167     function functionCallWithValue(
168         address target,
169         bytes memory data,
170         uint256 value
171     ) internal returns (bytes memory) {
172         return
173             functionCallWithValue(
174                 target,
175                 data,
176                 value,
177                 "Address: low-level call with value failed"
178             );
179     }
180 
181     /**
182      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
183      * with `errorMessage` as a fallback revert reason when `target` reverts.
184      *
185      * _Available since v3.1._
186      */
187     function functionCallWithValue(
188         address target,
189         bytes memory data,
190         uint256 value,
191         string memory errorMessage
192     ) internal returns (bytes memory) {
193         require(
194             address(this).balance >= value,
195             "Address: insufficient balance for call"
196         );
197         (bool success, bytes memory returndata) = target.call{value: value}(
198             data
199         );
200         return
201             verifyCallResultFromTarget(
202                 target,
203                 success,
204                 returndata,
205                 errorMessage
206             );
207     }
208 
209     /**
210      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
211      * but performing a static call.
212      *
213      * _Available since v3.3._
214      */
215     function functionStaticCall(address target, bytes memory data)
216         internal
217         view
218         returns (bytes memory)
219     {
220         return
221             functionStaticCall(
222                 target,
223                 data,
224                 "Address: low-level static call failed"
225             );
226     }
227 
228     /**
229      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
230      * but performing a static call.
231      *
232      * _Available since v3.3._
233      */
234     function functionStaticCall(
235         address target,
236         bytes memory data,
237         string memory errorMessage
238     ) internal view returns (bytes memory) {
239         (bool success, bytes memory returndata) = target.staticcall(data);
240         return
241             verifyCallResultFromTarget(
242                 target,
243                 success,
244                 returndata,
245                 errorMessage
246             );
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
251      * but performing a delegate call.
252      *
253      * _Available since v3.4._
254      */
255     function functionDelegateCall(address target, bytes memory data)
256         internal
257         returns (bytes memory)
258     {
259         return
260             functionDelegateCall(
261                 target,
262                 data,
263                 "Address: low-level delegate call failed"
264             );
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
269      * but performing a delegate call.
270      *
271      * _Available since v3.4._
272      */
273     function functionDelegateCall(
274         address target,
275         bytes memory data,
276         string memory errorMessage
277     ) internal returns (bytes memory) {
278         (bool success, bytes memory returndata) = target.delegatecall(data);
279         return
280             verifyCallResultFromTarget(
281                 target,
282                 success,
283                 returndata,
284                 errorMessage
285             );
286     }
287 
288     /**
289      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
290      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
291      *
292      * _Available since v4.8._
293      */
294     function verifyCallResultFromTarget(
295         address target,
296         bool success,
297         bytes memory returndata,
298         string memory errorMessage
299     ) internal view returns (bytes memory) {
300         if (success) {
301             if (returndata.length == 0) {
302                 // only check isContract if the call was successful and the return data is empty
303                 // otherwise we already know that it was a contract
304                 require(isContract(target), "Address: call to non-contract");
305             }
306             return returndata;
307         } else {
308             _revert(returndata, errorMessage);
309         }
310     }
311 
312     /**
313      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
314      * revert reason or using the provided one.
315      *
316      * _Available since v4.3._
317      */
318     function verifyCallResult(
319         bool success,
320         bytes memory returndata,
321         string memory errorMessage
322     ) internal pure returns (bytes memory) {
323         if (success) {
324             return returndata;
325         } else {
326             _revert(returndata, errorMessage);
327         }
328     }
329 
330     function _revert(bytes memory returndata, string memory errorMessage)
331         private
332         pure
333     {
334         // Look for revert reason and bubble it up if present
335         if (returndata.length > 0) {
336             // The easiest way to bubble the revert reason is using memory via assembly
337             /// @solidity memory-safe-assembly
338             assembly {
339                 let returndata_size := mload(returndata)
340                 revert(add(32, returndata), returndata_size)
341             }
342         } else {
343             revert(errorMessage);
344         }
345     }
346 }
347 
348 /**
349  * @dev Contract module which provides a basic access control mechanism, where
350  * there is an account (an owner) that can be granted exclusive access to
351  * specific functions.
352  *
353  * By default, the owner account will be the one that deploys the contract. This
354  * can later be changed with {transferOwnership}.
355  *
356  * This module is used through inheritance. It will make available the modifier
357  * `onlyOwner`, which can be applied to your functions to restrict their use to
358  * the owner.
359  */
360 abstract contract Ownable is Context {
361     address private _owner;
362 
363     event OwnershipTransferred(
364         address indexed previousOwner,
365         address indexed newOwner
366     );
367 
368     /**
369      * @dev Initializes the contract setting the deployer as the initial owner.
370      */
371     constructor() {
372         _transferOwnership(_msgSender());
373     }
374 
375     /**
376      * @dev Throws if called by any account other than the owner.
377      */
378     modifier onlyOwner() {
379         _checkOwner();
380         _;
381     }
382 
383     /**
384      * @dev Returns the address of the current owner.
385      */
386     function owner() public view virtual returns (address) {
387         return _owner;
388     }
389 
390     /**
391      * @dev Throws if the sender is not the owner.
392      */
393     function _checkOwner() internal view virtual {
394         require(owner() == _msgSender(), "Ownable: caller is not the owner");
395     }
396 
397     /**
398      * @dev Leaves the contract without owner. It will not be possible to call
399      * `onlyOwner` functions anymore. Can only be called by the current owner.
400      *
401      * NOTE: Renouncing ownership will leave the contract without an owner,
402      * thereby removing any functionality that is only available to the owner.
403      */
404     function renounceOwnership() public virtual onlyOwner {
405         _transferOwnership(address(0));
406     }
407 
408     /**
409      * @dev Transfers ownership of the contract to a new account (`newOwner`).
410      * Can only be called by the current owner.
411      */
412     function transferOwnership(address newOwner) public virtual onlyOwner {
413         require(
414             newOwner != address(0),
415             "Ownable: new owner is the zero address"
416         );
417         _transferOwnership(newOwner);
418     }
419 
420     /**
421      * @dev Transfers ownership of the contract to a new account (`newOwner`).
422      * Internal function without access restriction.
423      */
424     function _transferOwnership(address newOwner) internal virtual {
425         address oldOwner = _owner;
426         _owner = newOwner;
427         emit OwnershipTransferred(oldOwner, newOwner);
428     }
429 }
430 
431 interface IUniswapV2Factory {
432     event PairCreated(
433         address indexed token0,
434         address indexed token1,
435         address pair,
436         uint256
437     );
438 
439     function feeTo() external view returns (address);
440 
441     function feeToSetter() external view returns (address);
442 
443     function getPair(address tokenA, address tokenB)
444         external
445         view
446         returns (address pair);
447 
448     function allPairs(uint256) external view returns (address pair);
449 
450     function allPairsLength() external view returns (uint256);
451 
452     function createPair(address tokenA, address tokenB)
453         external
454         returns (address pair);
455 
456     function setFeeTo(address) external;
457 
458     function setFeeToSetter(address) external;
459 }
460 
461 interface IUniswapV2Pair {
462     event Approval(
463         address indexed owner,
464         address indexed spender,
465         uint256 value
466     );
467     event Transfer(address indexed from, address indexed to, uint256 value);
468 
469     function name() external pure returns (string memory);
470 
471     function symbol() external pure returns (string memory);
472 
473     function decimals() external pure returns (uint8);
474 
475     function totalSupply() external view returns (uint256);
476 
477     function balanceOf(address owner) external view returns (uint256);
478 
479     function allowance(address owner, address spender)
480         external
481         view
482         returns (uint256);
483 
484     function approve(address spender, uint256 value) external returns (bool);
485 
486     function transfer(address to, uint256 value) external returns (bool);
487 
488     function transferFrom(
489         address from,
490         address to,
491         uint256 value
492     ) external returns (bool);
493 
494     function DOMAIN_SEPARATOR() external view returns (bytes32);
495 
496     function PERMIT_TYPEHASH() external pure returns (bytes32);
497 
498     function nonces(address owner) external view returns (uint256);
499 
500     function permit(
501         address owner,
502         address spender,
503         uint256 value,
504         uint256 deadline,
505         uint8 v,
506         bytes32 r,
507         bytes32 s
508     ) external;
509 
510     event Burn(
511         address indexed sender,
512         uint256 amount0,
513         uint256 amount1,
514         address indexed to
515     );
516     event Swap(
517         address indexed sender,
518         uint256 amount0In,
519         uint256 amount1In,
520         uint256 amount0Out,
521         uint256 amount1Out,
522         address indexed to
523     );
524     event Sync(uint112 reserve0, uint112 reserve1);
525 
526     function MINIMUM_LIQUIDITY() external pure returns (uint256);
527 
528     function factory() external view returns (address);
529 
530     function token0() external view returns (address);
531 
532     function token1() external view returns (address);
533 
534     function getReserves()
535         external
536         view
537         returns (
538             uint112 reserve0,
539             uint112 reserve1,
540             uint32 blockTimestampLast
541         );
542 
543     function price0CumulativeLast() external view returns (uint256);
544 
545     function price1CumulativeLast() external view returns (uint256);
546 
547     function kLast() external view returns (uint256);
548 
549     function burn(address to)
550         external
551         returns (uint256 amount0, uint256 amount1);
552 
553     function swap(
554         uint256 amount0Out,
555         uint256 amount1Out,
556         address to,
557         bytes calldata data
558     ) external;
559 
560     function skim(address to) external;
561 
562     function sync() external;
563 
564     function initialize(address, address) external;
565 }
566 
567 interface IUniswapV2Router01 {
568     function factory() external pure returns (address);
569 
570     function WETH() external pure returns (address);
571 
572     function addLiquidity(
573         address tokenA,
574         address tokenB,
575         uint256 amountADesired,
576         uint256 amountBDesired,
577         uint256 amountAMin,
578         uint256 amountBMin,
579         address to,
580         uint256 deadline
581     )
582         external
583         returns (
584             uint256 amountA,
585             uint256 amountB,
586             uint256 liquidity
587         );
588 
589     function addLiquidityETH(
590         address token,
591         uint256 amountTokenDesired,
592         uint256 amountTokenMin,
593         uint256 amountETHMin,
594         address to,
595         uint256 deadline
596     )
597         external
598         payable
599         returns (
600             uint256 amountToken,
601             uint256 amountETH,
602             uint256 liquidity
603         );
604 
605     function removeLiquidity(
606         address tokenA,
607         address tokenB,
608         uint256 liquidity,
609         uint256 amountAMin,
610         uint256 amountBMin,
611         address to,
612         uint256 deadline
613     ) external returns (uint256 amountA, uint256 amountB);
614 
615     function removeLiquidityETH(
616         address token,
617         uint256 liquidity,
618         uint256 amountTokenMin,
619         uint256 amountETHMin,
620         address to,
621         uint256 deadline
622     ) external returns (uint256 amountToken, uint256 amountETH);
623 
624     function removeLiquidityWithPermit(
625         address tokenA,
626         address tokenB,
627         uint256 liquidity,
628         uint256 amountAMin,
629         uint256 amountBMin,
630         address to,
631         uint256 deadline,
632         bool approveMax,
633         uint8 v,
634         bytes32 r,
635         bytes32 s
636     ) external returns (uint256 amountA, uint256 amountB);
637 
638     function removeLiquidityETHWithPermit(
639         address token,
640         uint256 liquidity,
641         uint256 amountTokenMin,
642         uint256 amountETHMin,
643         address to,
644         uint256 deadline,
645         bool approveMax,
646         uint8 v,
647         bytes32 r,
648         bytes32 s
649     ) external returns (uint256 amountToken, uint256 amountETH);
650 
651     function swapExactTokensForTokens(
652         uint256 amountIn,
653         uint256 amountOutMin,
654         address[] calldata path,
655         address to,
656         uint256 deadline
657     ) external returns (uint256[] memory amounts);
658 
659     function swapTokensForExactTokens(
660         uint256 amountOut,
661         uint256 amountInMax,
662         address[] calldata path,
663         address to,
664         uint256 deadline
665     ) external returns (uint256[] memory amounts);
666 
667     function swapExactETHForTokens(
668         uint256 amountOutMin,
669         address[] calldata path,
670         address to,
671         uint256 deadline
672     ) external payable returns (uint256[] memory amounts);
673 
674     function swapTokensForExactETH(
675         uint256 amountOut,
676         uint256 amountInMax,
677         address[] calldata path,
678         address to,
679         uint256 deadline
680     ) external returns (uint256[] memory amounts);
681 
682     function swapExactTokensForETH(
683         uint256 amountIn,
684         uint256 amountOutMin,
685         address[] calldata path,
686         address to,
687         uint256 deadline
688     ) external returns (uint256[] memory amounts);
689 
690     function swapETHForExactTokens(
691         uint256 amountOut,
692         address[] calldata path,
693         address to,
694         uint256 deadline
695     ) external payable returns (uint256[] memory amounts);
696 
697     function quote(
698         uint256 amountA,
699         uint256 reserveA,
700         uint256 reserveB
701     ) external pure returns (uint256 amountB);
702 
703     function getAmountOut(
704         uint256 amountIn,
705         uint256 reserveIn,
706         uint256 reserveOut
707     ) external pure returns (uint256 amountOut);
708 
709     function getAmountIn(
710         uint256 amountOut,
711         uint256 reserveIn,
712         uint256 reserveOut
713     ) external pure returns (uint256 amountIn);
714 
715     function getAmountsOut(uint256 amountIn, address[] calldata path)
716         external
717         view
718         returns (uint256[] memory amounts);
719 
720     function getAmountsIn(uint256 amountOut, address[] calldata path)
721         external
722         view
723         returns (uint256[] memory amounts);
724 }
725 
726 interface IUniswapV2Router02 is IUniswapV2Router01 {
727     function removeLiquidityETHSupportingFeeOnTransferTokens(
728         address token,
729         uint256 liquidity,
730         uint256 amountTokenMin,
731         uint256 amountETHMin,
732         address to,
733         uint256 deadline
734     ) external returns (uint256 amountETH);
735 
736     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
737         address token,
738         uint256 liquidity,
739         uint256 amountTokenMin,
740         uint256 amountETHMin,
741         address to,
742         uint256 deadline,
743         bool approveMax,
744         uint8 v,
745         bytes32 r,
746         bytes32 s
747     ) external returns (uint256 amountETH);
748 
749     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
750         uint256 amountIn,
751         uint256 amountOutMin,
752         address[] calldata path,
753         address to,
754         uint256 deadline
755     ) external;
756 
757     function swapExactETHForTokensSupportingFeeOnTransferTokens(
758         uint256 amountOutMin,
759         address[] calldata path,
760         address to,
761         uint256 deadline
762     ) external payable;
763 
764     function swapExactTokensForETHSupportingFeeOnTransferTokens(
765         uint256 amountIn,
766         uint256 amountOutMin,
767         address[] calldata path,
768         address to,
769         uint256 deadline
770     ) external;
771 }
772 
773 interface IDistributor {
774 
775     function getMinHoldingAmount() external view returns (uint256);
776 
777     function createShareHolder(address _address) external;
778 
779     function removeShareHolder(address _address) external;
780 }
781 
782 contract JEETS is Context, IERC20, Ownable {
783     using Address for address;
784 
785     //Marketing or team wallet.
786     address payable public marketingWallet =
787         payable(0x124842f0ba72c26D2f6aF22EEf6ffA41784734b9);
788 
789     //Dead Wallet
790     address public constant deadWallet =
791         0x000000000000000000000000000000000000dEaD;
792 
793     //Mapping section for better tracking.
794     mapping(address => uint256) private _tOwned;
795 
796     mapping(address => mapping(address => uint256)) private _allowances;
797 
798     mapping(address => bool) private _isExcludedFromFee;
799 
800     //Loging and Event Information for better troubleshooting.
801     event Log(string, uint256);
802 
803     event AuditLog(string, address);
804 
805     event RewardLiquidityProviders(uint256 tokenAmount);
806 
807     event SwapAndLiquifyEnabledUpdated(bool enabled);
808 
809     event SwapAndLiquify(
810         uint256 tokensSwapped,
811         uint256 ethReceived,
812         uint256 tokensIntoLiqudity
813     );
814 
815     event SwapTokensForETH(uint256 amountIn, address[] path);
816 
817     //Supply Definition.
818     uint256 private theTotalSupply = 100_000_000 ether;
819 
820     uint256 private _tFeeTotal;
821 
822     //Token Definition.
823     string public constant name = "Jeets Bot";
824     string public constant symbol = "JEETS";
825     uint8 public constant decimals = 18;
826     //Taxes Definition.
827     uint256 public buyFee = 4;
828 
829     uint256 public sellFee = 4;
830 
831     uint256 public minimumTokensBeforeSwap = 10_000 ether;
832 
833     //Oracle Price Update, Manual Process.
834     uint256 public swapOutput = 0;
835 
836     //Router and Pair Configuration.
837     IUniswapV2Router02 public immutable uniswapV2Router;
838     address public  uniswapV2Pair;
839     address private immutable WETH;
840     //Tracking of Automatic Swap vs Manual Swap.
841     bool public inSwapAndLiquify;
842     bool public swapAndLiquifyEnabled = false;
843 
844     bool public normalTransfer = true;
845 
846     bool public rewardEnabled = true;
847 
848     IDistributor public Distributor;
849 
850     bool public removeHolderByASell = true;
851 
852     modifier lockTheSwap() {
853         inSwapAndLiquify = true;
854         _;
855         inSwapAndLiquify = false;
856     }
857 
858     constructor(address _Distributor) {
859         _tOwned[_msgSender()] = theTotalSupply;
860 
861         address currentRouter;
862 
863         currentRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; //Router
864 
865         Distributor = IDistributor(_Distributor);
866 
867         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(currentRouter);
868 
869         WETH = _uniswapV2Router.WETH();
870 
871         uniswapV2Router = _uniswapV2Router;
872 
873         _isExcludedFromFee[owner()] = true;
874 
875         _isExcludedFromFee[address(this)] = true;
876 
877         _isExcludedFromFee[currentRouter] = true;
878 
879         emit Transfer(address(0), _msgSender(), theTotalSupply);
880     }
881 
882     //Readable Functions.
883     function totalSupply() public view override returns (uint256) {
884         return theTotalSupply;
885     }
886 
887     function balanceOf(address account) public view override returns (uint256) {
888         return _tOwned[account];
889     }
890 
891     //ERC 20 Standard Transfer Functions
892     function transfer(address recipient, uint256 amount)
893         public
894         override
895         returns (bool)
896     {
897         _transfer(_msgSender(), recipient, amount);
898         return true;
899     }
900 
901     //ERC 20 Standard Allowance Function
902     function allowance(address _owner, address spender)
903         public
904         view
905         override
906         returns (uint256)
907     {
908         return _allowances[_owner][spender];
909     }
910 
911     //ERC 20 Standard Approve Function
912     function approve(address spender, uint256 amount)
913         public
914         override
915         returns (bool)
916     {
917         _approve(_msgSender(), spender, amount);
918         return true;
919     }
920 
921     //ERC 20 Standard Transfer From
922     function transferFrom(
923         address sender,
924         address recipient,
925         uint256 amount
926     ) public override returns (bool) {
927         uint256 currentAllowance = _allowances[sender][_msgSender()];
928         require(
929             currentAllowance >= amount,
930             "ERC20: transfer amount exceeds allowance"
931         );
932         _transfer(sender, recipient, amount);
933         _approve(sender, _msgSender(), currentAllowance - amount);
934         return true;
935     }
936 
937     //ERC 20 Standard increase Allowance
938     function increaseAllowance(address spender, uint256 addedValue)
939         public
940         virtual
941         returns (bool)
942     {
943         _approve(
944             _msgSender(),
945             spender,
946             _allowances[_msgSender()][spender] + addedValue
947         );
948         return true;
949     }
950 
951     //ERC 20 Standard decrease Allowance
952     function decreaseAllowance(address spender, uint256 subtractedValue)
953         public
954         virtual
955         returns (bool)
956     {
957         _approve(
958             _msgSender(),
959             spender,
960             _allowances[_msgSender()][spender] - subtractedValue
961         );
962         return true;
963     }
964 
965     //Approve Function
966     function _approve(
967         address _owner,
968         address spender,
969         uint256 amount
970     ) private {
971         require(_owner != address(0), "ERC20: approve from the zero address");
972         require(spender != address(0), "ERC20: approve to the zero address");
973 
974         _allowances[_owner][spender] = amount;
975         emit Approval(_owner, spender, amount);
976     }
977 
978     function _transfer(
979         address from,
980         address to,
981         uint256 amount
982     ) private {
983         require(from != address(0), "ERC20: transfer from the zero address");
984         require(to != address(0), "ERC20: transfer to the zero address");
985         require(amount > 0, "Transfer amount must be greater than zero");
986         require(
987             _tOwned[from] >= amount,
988             "ERC20: transfer amount exceeds balance"
989         );
990 
991         if (
992             to != uniswapV2Pair &&
993             from != uniswapV2Pair &&
994             normalTransfer == true
995         ) {
996             return _tokenTransfer(from, to, amount);
997         }
998 
999         uint256 contractTokenBalance = balanceOf(address(this));
1000 
1001         bool overMinimumTokenBalance = contractTokenBalance >=
1002             minimumTokensBeforeSwap;
1003         uint256 fee = 0;
1004 
1005         if (
1006             !inSwapAndLiquify &&
1007             from != uniswapV2Pair &&
1008             overMinimumTokenBalance &&
1009             swapAndLiquifyEnabled
1010         ) {
1011             swapAndLiquify();
1012         }
1013         if (to == uniswapV2Pair && !_isExcludedFromFee[from]) {
1014             fee = (sellFee * amount) / 100;
1015         }
1016         if (from == uniswapV2Pair && !_isExcludedFromFee[to]) {
1017             fee = (buyFee * amount) / 100;
1018         }
1019         amount -= fee;
1020         if (fee > 0) {
1021             _tokenTransfer(from, address(this), fee);
1022         }
1023         processShareHolder(from, to, amount);
1024         _tokenTransfer(from, to, amount);
1025     }
1026 
1027     function setPair() external onlyOwner{
1028      
1029         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
1030         
1031     }
1032 
1033     function processShareHolder(
1034         address _from,
1035         address _to,
1036         uint256 _amount
1037     ) internal {
1038         if (rewardEnabled) {
1039             //is buying
1040             if (_from == uniswapV2Pair) {
1041                 uint256 userBalance = balanceOf(_to) + _amount;
1042 
1043                 if (userBalance >= Distributor.getMinHoldingAmount()) {
1044                     Distributor.createShareHolder(_to);
1045                 }
1046             }
1047 
1048             //is selling
1049             if (_to == uniswapV2Pair) {
1050                 uint256 userBalance = balanceOf(_from) - _amount;
1051 
1052                 if (removeHolderByASell == true) {
1053                     Distributor.removeShareHolder(_from);
1054                 } else if (
1055                     removeHolderByASell == false &&
1056                     userBalance < Distributor.getMinHoldingAmount()
1057                 ) {
1058                     Distributor.removeShareHolder(_from);
1059                 }
1060             }
1061         }
1062     }
1063 
1064     function swapAndLiquify() public lockTheSwap {
1065 
1066         uint256 totalTokens = balanceOf(address(this));
1067 
1068         swapTokensForEth(totalTokens);
1069 
1070         uint256 ethBalance = address(this).balance;
1071 
1072         transferToAddressETH(marketingWallet, ethBalance);
1073     }
1074 
1075     function swapTokensForEth(uint256 tokenAmount) private {
1076        
1077         address[] memory path = new address[](2);
1078         path[0] = address(this);
1079         path[1] = WETH;
1080         _approve(address(this), address(uniswapV2Router), tokenAmount);
1081 
1082         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1083             tokenAmount,
1084             0, 
1085             path,
1086             address(this),
1087             block.timestamp
1088         );
1089 
1090         emit SwapTokensForETH(tokenAmount, path);
1091     }
1092 
1093     function _tokenTransfer(
1094         address sender,
1095         address recipient,
1096         uint256 amount
1097     ) private {
1098         _tOwned[sender] -= amount;
1099         _tOwned[recipient] += amount;
1100 
1101         emit Transfer(sender, recipient, amount);
1102     }
1103 
1104     function isExcludedFromFee(address account) external view returns (bool) {
1105         return _isExcludedFromFee[account];
1106     }
1107 
1108     function excludeFromFee(address account, bool _status) external onlyOwner {
1109         _isExcludedFromFee[account] = _status;
1110 
1111     }
1112 
1113     function setTokensToSwap(uint256 _minimumTokensBeforeSwap)
1114         external
1115         onlyOwner
1116     {
1117         require(
1118             _minimumTokensBeforeSwap >= 100 ether,
1119             "You need to enter more than 100 tokens."
1120         );
1121         minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
1122     }
1123 
1124     function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner {
1125         require(swapAndLiquifyEnabled != _enabled, "Value already set");
1126         swapAndLiquifyEnabled = _enabled;
1127     }
1128 
1129     function setMarketingWallet(address _marketingWallet) external onlyOwner {
1130         require(_marketingWallet != address(0), "setmarketingWallet: ZERO");
1131         marketingWallet = payable(_marketingWallet);
1132     }
1133 
1134     function removeHolderBySell(bool _status) external onlyOwner {
1135         removeHolderByASell = _status;
1136     }
1137 
1138     function setNormalTransfer(bool _status) external onlyOwner {
1139         normalTransfer = _status;
1140     }
1141 
1142     function setRewardEnabled(bool _status) external onlyOwner {
1143         rewardEnabled = _status;
1144     }
1145 
1146     function setDistributor(address _distributor) external onlyOwner {
1147         Distributor = IDistributor(_distributor);
1148     }
1149 
1150     function transferToAddressETH(address payable recipient, uint256 amount)
1151         private
1152     {
1153         (bool succ, ) = recipient.call{value: amount}("");
1154         require(succ, "Transfer failed.");
1155     }
1156 
1157     receive() external payable {}
1158 
1159     // Withdraw ETH that's potentially stuck in the Contract
1160     function recoverETHfromContract() external onlyOwner {
1161         uint256 ethBalance = address(this).balance;
1162         (bool succ, ) = payable(marketingWallet).call{value: ethBalance}("");
1163         require(succ, "Transfer failed");
1164     }
1165 
1166     // Withdraw ERC20 tokens that are potentially stuck in Contract
1167     function recoverTokensFromContract(address _tokenAddress, uint256 _amount)
1168         external
1169         onlyOwner
1170     {
1171         bool succ = IERC20(_tokenAddress).transfer(marketingWallet, _amount);
1172         require(succ, "Transfer failed");
1173     }
1174 }