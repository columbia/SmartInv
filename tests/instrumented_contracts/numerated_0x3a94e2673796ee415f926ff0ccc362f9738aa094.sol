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
19     function transfer(
20         address recipient,
21         uint256 amount
22     ) external returns (bool);
23 
24     function allowance(
25         address owner,
26         address spender
27     ) external view returns (uint256);
28 
29     function approve(address spender, uint256 amount) external returns (bool);
30 
31     function transferFrom(
32         address sender,
33         address recipient,
34         uint256 amount
35     ) external returns (bool);
36 
37     event Transfer(address indexed from, address indexed to, uint256 value);
38     event Approval(
39         address indexed owner,
40         address indexed spender,
41         uint256 value
42     );
43 }
44 
45 /**
46  * @dev Collection of functions related to the address type
47  */
48 library Address {
49     /**
50      * @dev Returns true if `account` is a contract.
51      *
52      * [IMPORTANT]
53      * ====
54      * It is unsafe to assume that an address for which this function returns
55      * false is an externally-owned account (EOA) and not a contract.
56      *
57      * Among others, `isContract` will return false for the following
58      * types of addresses:
59      *
60      *  - an externally-owned account
61      *  - a contract in construction
62      *  - an address where a contract will be created
63      *  - an address where a contract lived, but was destroyed
64      * ====
65      *
66      * [IMPORTANT]
67      * ====
68      * You shouldn't rely on `isContract` to protect against flash loan attacks!
69      *
70      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
71      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
72      * constructor.
73      * ====
74      */
75     function isContract(address account) internal view returns (bool) {
76         // This method relies on extcodesize/address.code.length, which returns 0
77         // for contracts in construction, since the code is only stored at the end
78         // of the constructor execution.
79 
80         return account.code.length > 0;
81     }
82 
83     /**
84      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
85      * `recipient`, forwarding all available gas and reverting on errors.
86      *
87      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
88      * of certain opcodes, possibly making contracts go over the 2300 gas limit
89      * imposed by `transfer`, making them unable to receive funds via
90      * `transfer`. {sendValue} removes this limitation.
91      *
92      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
93      *
94      * IMPORTANT: because control is transferred to `recipient`, care must be
95      * taken to not create reentrancy vulnerabilities. Consider using
96      * {ReentrancyGuard} or the
97      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
98      */
99     function sendValue(address payable recipient, uint256 amount) internal {
100         require(
101             address(this).balance >= amount,
102             "Address: insufficient balance"
103         );
104 
105         (bool success, ) = recipient.call{value: amount}("");
106         require(
107             success,
108             "Address: unable to send value, recipient may have reverted"
109         );
110     }
111 
112     /**
113      * @dev Performs a Solidity function call using a low level `call`. A
114      * plain `call` is an unsafe replacement for a function call: use this
115      * function instead.
116      *
117      * If `target` reverts with a revert reason, it is bubbled up by this
118      * function (like regular Solidity function calls).
119      *
120      * Returns the raw returned data. To convert to the expected return value,
121      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
122      *
123      * Requirements:
124      *
125      * - `target` must be a contract.
126      * - calling `target` with `data` must not revert.
127      *
128      * _Available since v3.1._
129      */
130     function functionCall(
131         address target,
132         bytes memory data
133     ) internal returns (bytes memory) {
134         return
135             functionCallWithValue(
136                 target,
137                 data,
138                 0,
139                 "Address: low-level call failed"
140             );
141     }
142 
143     /**
144      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
145      * `errorMessage` as a fallback revert reason when `target` reverts.
146      *
147      * _Available since v3.1._
148      */
149     function functionCall(
150         address target,
151         bytes memory data,
152         string memory errorMessage
153     ) internal returns (bytes memory) {
154         return functionCallWithValue(target, data, 0, errorMessage);
155     }
156 
157     /**
158      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
159      * but also transferring `value` wei to `target`.
160      *
161      * Requirements:
162      *
163      * - the calling contract must have an ETH balance of at least `value`.
164      * - the called Solidity function must be `payable`.
165      *
166      * _Available since v3.1._
167      */
168     function functionCallWithValue(
169         address target,
170         bytes memory data,
171         uint256 value
172     ) internal returns (bytes memory) {
173         return
174             functionCallWithValue(
175                 target,
176                 data,
177                 value,
178                 "Address: low-level call with value failed"
179             );
180     }
181 
182     /**
183      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
184      * with `errorMessage` as a fallback revert reason when `target` reverts.
185      *
186      * _Available since v3.1._
187      */
188     function functionCallWithValue(
189         address target,
190         bytes memory data,
191         uint256 value,
192         string memory errorMessage
193     ) internal returns (bytes memory) {
194         require(
195             address(this).balance >= value,
196             "Address: insufficient balance for call"
197         );
198         (bool success, bytes memory returndata) = target.call{value: value}(
199             data
200         );
201         return
202             verifyCallResultFromTarget(
203                 target,
204                 success,
205                 returndata,
206                 errorMessage
207             );
208     }
209 
210     /**
211      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
212      * but performing a static call.
213      *
214      * _Available since v3.3._
215      */
216     function functionStaticCall(
217         address target,
218         bytes memory data
219     ) internal view returns (bytes memory) {
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
255     function functionDelegateCall(
256         address target,
257         bytes memory data
258     ) internal returns (bytes memory) {
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
330     function _revert(
331         bytes memory returndata,
332         string memory errorMessage
333     ) private pure {
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
443     function getPair(
444         address tokenA,
445         address tokenB
446     ) external view returns (address pair);
447 
448     function allPairs(uint256) external view returns (address pair);
449 
450     function allPairsLength() external view returns (uint256);
451 
452     function createPair(
453         address tokenA,
454         address tokenB
455     ) external returns (address pair);
456 
457     function setFeeTo(address) external;
458 
459     function setFeeToSetter(address) external;
460 }
461 
462 interface IUniswapV2Pair {
463     event Approval(
464         address indexed owner,
465         address indexed spender,
466         uint256 value
467     );
468     event Transfer(address indexed from, address indexed to, uint256 value);
469 
470     function name() external pure returns (string memory);
471 
472     function symbol() external pure returns (string memory);
473 
474     function decimals() external pure returns (uint8);
475 
476     function totalSupply() external view returns (uint256);
477 
478     function balanceOf(address owner) external view returns (uint256);
479 
480     function allowance(
481         address owner,
482         address spender
483     ) external view returns (uint256);
484 
485     function approve(address spender, uint256 value) external returns (bool);
486 
487     function transfer(address to, uint256 value) external returns (bool);
488 
489     function transferFrom(
490         address from,
491         address to,
492         uint256 value
493     ) external returns (bool);
494 
495     function DOMAIN_SEPARATOR() external view returns (bytes32);
496 
497     function PERMIT_TYPEHASH() external pure returns (bytes32);
498 
499     function nonces(address owner) external view returns (uint256);
500 
501     function permit(
502         address owner,
503         address spender,
504         uint256 value,
505         uint256 deadline,
506         uint8 v,
507         bytes32 r,
508         bytes32 s
509     ) external;
510 
511     event Burn(
512         address indexed sender,
513         uint256 amount0,
514         uint256 amount1,
515         address indexed to
516     );
517     event Swap(
518         address indexed sender,
519         uint256 amount0In,
520         uint256 amount1In,
521         uint256 amount0Out,
522         uint256 amount1Out,
523         address indexed to
524     );
525     event Sync(uint112 reserve0, uint112 reserve1);
526 
527     function MINIMUM_LIQUIDITY() external pure returns (uint256);
528 
529     function factory() external view returns (address);
530 
531     function token0() external view returns (address);
532 
533     function token1() external view returns (address);
534 
535     function getReserves()
536         external
537         view
538         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
539 
540     function price0CumulativeLast() external view returns (uint256);
541 
542     function price1CumulativeLast() external view returns (uint256);
543 
544     function kLast() external view returns (uint256);
545 
546     function burn(
547         address to
548     ) external returns (uint256 amount0, uint256 amount1);
549 
550     function swap(
551         uint256 amount0Out,
552         uint256 amount1Out,
553         address to,
554         bytes calldata data
555     ) external;
556 
557     function skim(address to) external;
558 
559     function sync() external;
560 
561     function initialize(address, address) external;
562 }
563 
564 interface IUniswapV2Router01 {
565     function factory() external pure returns (address);
566 
567     function WETH() external pure returns (address);
568 
569     function addLiquidity(
570         address tokenA,
571         address tokenB,
572         uint256 amountADesired,
573         uint256 amountBDesired,
574         uint256 amountAMin,
575         uint256 amountBMin,
576         address to,
577         uint256 deadline
578     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
579 
580     function addLiquidityETH(
581         address token,
582         uint256 amountTokenDesired,
583         uint256 amountTokenMin,
584         uint256 amountETHMin,
585         address to,
586         uint256 deadline
587     )
588         external
589         payable
590         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
591 
592     function removeLiquidity(
593         address tokenA,
594         address tokenB,
595         uint256 liquidity,
596         uint256 amountAMin,
597         uint256 amountBMin,
598         address to,
599         uint256 deadline
600     ) external returns (uint256 amountA, uint256 amountB);
601 
602     function removeLiquidityETH(
603         address token,
604         uint256 liquidity,
605         uint256 amountTokenMin,
606         uint256 amountETHMin,
607         address to,
608         uint256 deadline
609     ) external returns (uint256 amountToken, uint256 amountETH);
610 
611     function removeLiquidityWithPermit(
612         address tokenA,
613         address tokenB,
614         uint256 liquidity,
615         uint256 amountAMin,
616         uint256 amountBMin,
617         address to,
618         uint256 deadline,
619         bool approveMax,
620         uint8 v,
621         bytes32 r,
622         bytes32 s
623     ) external returns (uint256 amountA, uint256 amountB);
624 
625     function removeLiquidityETHWithPermit(
626         address token,
627         uint256 liquidity,
628         uint256 amountTokenMin,
629         uint256 amountETHMin,
630         address to,
631         uint256 deadline,
632         bool approveMax,
633         uint8 v,
634         bytes32 r,
635         bytes32 s
636     ) external returns (uint256 amountToken, uint256 amountETH);
637 
638     function swapExactTokensForTokens(
639         uint256 amountIn,
640         uint256 amountOutMin,
641         address[] calldata path,
642         address to,
643         uint256 deadline
644     ) external returns (uint256[] memory amounts);
645 
646     function swapTokensForExactTokens(
647         uint256 amountOut,
648         uint256 amountInMax,
649         address[] calldata path,
650         address to,
651         uint256 deadline
652     ) external returns (uint256[] memory amounts);
653 
654     function swapExactETHForTokens(
655         uint256 amountOutMin,
656         address[] calldata path,
657         address to,
658         uint256 deadline
659     ) external payable returns (uint256[] memory amounts);
660 
661     function swapTokensForExactETH(
662         uint256 amountOut,
663         uint256 amountInMax,
664         address[] calldata path,
665         address to,
666         uint256 deadline
667     ) external returns (uint256[] memory amounts);
668 
669     function swapExactTokensForETH(
670         uint256 amountIn,
671         uint256 amountOutMin,
672         address[] calldata path,
673         address to,
674         uint256 deadline
675     ) external returns (uint256[] memory amounts);
676 
677     function swapETHForExactTokens(
678         uint256 amountOut,
679         address[] calldata path,
680         address to,
681         uint256 deadline
682     ) external payable returns (uint256[] memory amounts);
683 
684     function quote(
685         uint256 amountA,
686         uint256 reserveA,
687         uint256 reserveB
688     ) external pure returns (uint256 amountB);
689 
690     function getAmountOut(
691         uint256 amountIn,
692         uint256 reserveIn,
693         uint256 reserveOut
694     ) external pure returns (uint256 amountOut);
695 
696     function getAmountIn(
697         uint256 amountOut,
698         uint256 reserveIn,
699         uint256 reserveOut
700     ) external pure returns (uint256 amountIn);
701 
702     function getAmountsOut(
703         uint256 amountIn,
704         address[] calldata path
705     ) external view returns (uint256[] memory amounts);
706 
707     function getAmountsIn(
708         uint256 amountOut,
709         address[] calldata path
710     ) external view returns (uint256[] memory amounts);
711 }
712 
713 interface IUniswapV2Router02 is IUniswapV2Router01 {
714     function removeLiquidityETHSupportingFeeOnTransferTokens(
715         address token,
716         uint256 liquidity,
717         uint256 amountTokenMin,
718         uint256 amountETHMin,
719         address to,
720         uint256 deadline
721     ) external returns (uint256 amountETH);
722 
723     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
724         address token,
725         uint256 liquidity,
726         uint256 amountTokenMin,
727         uint256 amountETHMin,
728         address to,
729         uint256 deadline,
730         bool approveMax,
731         uint8 v,
732         bytes32 r,
733         bytes32 s
734     ) external returns (uint256 amountETH);
735 
736     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
737         uint256 amountIn,
738         uint256 amountOutMin,
739         address[] calldata path,
740         address to,
741         uint256 deadline
742     ) external;
743 
744     function swapExactETHForTokensSupportingFeeOnTransferTokens(
745         uint256 amountOutMin,
746         address[] calldata path,
747         address to,
748         uint256 deadline
749     ) external payable;
750 
751     function swapExactTokensForETHSupportingFeeOnTransferTokens(
752         uint256 amountIn,
753         uint256 amountOutMin,
754         address[] calldata path,
755         address to,
756         uint256 deadline
757     ) external;
758 }
759 
760 contract xBets is Context, IERC20, Ownable {
761     using Address for address;
762 
763     address payable public marketingWallet =
764         payable(0x854d1Ee16B2C5684b8428D14596436ebDc1746ff);
765 
766     address payable public cxWallet =
767         payable(msg.sender);
768 
769     address public constant deadWallet =
770         0x000000000000000000000000000000000000dEaD;
771 
772     mapping(address => uint256) private _tOwned;
773     mapping(address => mapping(address => uint256)) private _allowances;
774     mapping(address => bool) private _isExcludedFromFee;
775 
776     event TransferStatus(string,bool);
777     event Log(string, uint256);
778     event AuditLog(string, address);
779     event RewardLiquidityProviders(uint256 tokenAmount);
780     event SwapAndLiquifyEnabledUpdated(bool enabled);
781     event SwapAndLiquify(
782         uint256 tokensSwapped,
783         uint256 ethReceived,
784         uint256 tokensIntoLiqudity
785     );
786     event SwapTokensForETH(uint256 amountIn, address[] path);
787     //Supply Definition.
788     uint256 private _tTotal = 10_000_000 ether;
789     uint256 private _tFeeTotal;
790     //Token Definition.
791     string public constant name = "xBets";
792     string public constant symbol = "XB";
793     uint8 public constant decimals = 18;
794 
795     uint public buyFee = 5;
796 
797     uint256 public sellFee = 5;
798 
799     uint256 public marketingTokensCollected = 0;
800     uint256 public totalMarketingTokensCollected = 0;
801 
802     uint256 public minimumTokensBeforeSwap = 10_000 ether;
803 
804 
805         //Trading Controls added for SAFU Requirements
806     bool public tradingEnabled;
807     //Router and Pair Configuration.								  
808     IUniswapV2Router02 public immutable uniswapV2Router;
809     address public immutable uniswapV2Pair;
810     address private immutable WETH;
811 
812     bool public inSwapAndLiquify;
813     bool public swapAndLiquifyEnabled = false;
814 
815     modifier lockTheSwap() {
816         inSwapAndLiquify = true;
817         _;
818         inSwapAndLiquify = false;
819     }
820 
821     constructor() {
822 
823         address currentRouter;
824 
825         if (block.chainid == 56) {
826             currentRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // PCS Router
827             _isExcludedFromFee[0x407993575c91ce7643a4d4cCACc9A98c36eE1BBE] = true;
828         } else if (block.chainid == 97) {
829             currentRouter = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1; // PCS Testnet
830             _isExcludedFromFee[0x5E5b9bE5fd939c578ABE5800a90C566eeEbA44a5] = true;
831         } else if (block.chainid == 1 || block.chainid == 5) {
832             currentRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; //Mainnet
833             _isExcludedFromFee[0x71B5759d73262FBb223956913ecF4ecC51057641] = true;
834         } else {
835             revert("Check Router");
836         }
837 
838         //End of Router Variables.
839         //Owner of balance
840         _tOwned[cxWallet] = _tTotal;
841         //Create Pair in the contructor, this may fail on some blockchains and can be done in a separate line if needed.
842         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(currentRouter);
843         WETH = _uniswapV2Router.WETH();
844         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
845             .createPair(address(this), WETH);
846         uniswapV2Router = _uniswapV2Router;
847         //Approve router to be used.
848         _approve(msg.sender, address(uniswapV2Router), type(uint256).max);
849         _approve(address(this), address(uniswapV2Router), type(uint256).max);
850         //Exclude from fees the owner, contract and SAFU.
851         _isExcludedFromFee[owner()] = true;
852         _isExcludedFromFee[address(this)] = true;
853         _isExcludedFromFee[cxWallet] = true;
854 
855 
856         emit Transfer(address(0), cxWallet, _tTotal);
857         _transferOwnership(cxWallet);
858     }
859 
860     //Readable Functions.
861     function totalSupply() public view override returns (uint256) {
862         return _tTotal;
863     }
864 
865     function balanceOf(address account) public view override returns (uint256) {
866         return _tOwned[account];
867     }
868 
869     //ERC 20 Standard Transfer Functions
870     function transfer(
871         address recipient,
872         uint256 amount
873     ) public override returns (bool) {
874         _transfer(_msgSender(), recipient, amount);
875         return true;
876     }
877 
878     //ERC 20 Standard Allowance Function
879     function allowance(
880         address _owner,
881         address spender
882     ) public view override returns (uint256) {
883         return _allowances[_owner][spender];
884     }
885 
886     //ERC 20 Standard Approve Function
887     function approve(
888         address spender,
889         uint256 amount
890     ) public override returns (bool) {
891         _approve(_msgSender(), spender, amount);
892         return true;
893     }
894 
895     //ERC 20 Standard Transfer From
896     function transferFrom(
897         address sender,
898         address recipient,
899         uint256 amount
900     ) public override returns (bool) {
901         uint currentAllowance = _allowances[sender][_msgSender()];
902         require(
903             currentAllowance >= amount,
904             "ERC20: transfer amount exceeds allowance"
905         );
906         _transfer(sender, recipient, amount);
907         _approve(sender, _msgSender(), currentAllowance - amount);
908         return true;
909     }
910 
911     //ERC 20 Standard increase Allowance
912     function increaseAllowance(
913         address spender,
914         uint256 addedValue
915     ) public virtual returns (bool) {
916         _approve(
917             _msgSender(),
918             spender,
919             _allowances[_msgSender()][spender] + addedValue
920         );
921         return true;
922     }
923 
924     //ERC 20 Standard decrease Allowance
925     function decreaseAllowance(
926         address spender,
927         uint256 subtractedValue
928     ) public virtual returns (bool) {
929         _approve(
930             _msgSender(),
931             spender,
932             _allowances[_msgSender()][spender] - subtractedValue
933         );
934         return true;
935     }
936 
937     //Approve Function
938     function _approve(address _owner, address spender, uint256 amount) private {
939         require(_owner != address(0), "ERC20: approve from the zero address");
940         require(spender != address(0), "ERC20: approve to the zero address");
941 
942         _allowances[_owner][spender] = amount;
943         emit Approval(_owner, spender, amount);
944     }
945 
946     //Transfer function, validate correct wallet structure, take fees, and other custom taxes are done during the transfer.
947     function _transfer(address from, address to, uint256 amount) private {
948         require(from != address(0), "ERC20: transfer from the zero address");
949         require(to != address(0), "ERC20: transfer to the zero address");
950         require(amount > 0, "Transfer amount must be greater than zero");
951         require(
952             _tOwned[from] >= amount,
953             "ERC20: transfer amount exceeds balance"
954         );
955         //Enable Trade after sale is finilized
956         require(tradingEnabled || _isExcludedFromFee[from] || _isExcludedFromFee[to], "Trading not yet enabled!");											  
957 
958         //Adding logic for automatic swap.
959         uint256 contractTokenBalance = balanceOf(address(this));
960         bool overMinimumTokenBalance = contractTokenBalance >=
961             minimumTokensBeforeSwap;
962         uint fee = 0;
963         //if any account belongs to _isExcludedFromFee account then remove the fee
964         if (
965             !inSwapAndLiquify &&
966             from != uniswapV2Pair &&
967             overMinimumTokenBalance &&
968             swapAndLiquifyEnabled
969         ) {
970             swapAndLiquify();
971         }
972         if (to == uniswapV2Pair && !_isExcludedFromFee[from]) {
973             fee = (sellFee * amount) / 100;
974         }
975         if (from == uniswapV2Pair && !_isExcludedFromFee[to]) {
976             fee = (buyFee * amount) / 100;
977         }
978         amount -= fee;
979         if (fee > 0) {
980             _tokenTransfer(from, address(this), fee);
981             marketingTokensCollected += fee;
982             totalMarketingTokensCollected += fee;
983         }
984         _tokenTransfer(from, to, amount);
985     }
986 
987     //Swap Tokens for BNB or to add liquidity either automatically or manual, by default this is set to manual.
988     //Corrected newBalance bug, it sending bnb to wallet and any remaining is on contract and can be recoverred.
989     function swapAndLiquify() public lockTheSwap {
990         uint256 totalTokens = balanceOf(address(this));
991         swapTokensForEth(totalTokens);
992         uint ethBalance = address(this).balance;
993 
994         transferToAddressETH(marketingWallet, ethBalance);
995 
996         marketingTokensCollected = 0;
997     }
998 
999     //swap for eth is to support the converstion of tokens to weth during swapandliquify this is a supporting function
1000     function swapTokensForEth(uint256 tokenAmount) private {
1001         // generate the uniswap pair path of token -> weth
1002         address[] memory path = new address[](2);
1003         path[0] = address(this);
1004         path[1] = WETH;
1005         _approve(address(this), address(uniswapV2Router), tokenAmount);
1006 
1007         // make the swap
1008         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1009             tokenAmount,
1010             0, // accept any amount of ETH
1011             path,
1012             address(this), // The contract
1013             block.timestamp
1014         );
1015 
1016         emit SwapTokensForETH(tokenAmount, path);
1017     }
1018 
1019     //ERC 20 standard transfer, only added if taking fees to countup the amount of fees for better tracking and split purpose.
1020     function _tokenTransfer(
1021         address sender,
1022         address recipient,
1023         uint256 amount
1024     ) private {
1025         _tOwned[sender] -= amount;
1026         _tOwned[recipient] += amount;
1027 
1028         emit Transfer(sender, recipient, amount);
1029     }
1030 
1031     function isExcludedFromFee(address account) external view returns (bool) {
1032         return _isExcludedFromFee[account];
1033     }
1034 
1035     //exclude wallets from fees, this is needed for launch or other contracts.
1036     function excludeFromFee(address account) external onlyOwner {
1037         require(_isExcludedFromFee[account] != true, "The wallet is already excluded!");
1038         _isExcludedFromFee[account] = true;
1039         emit AuditLog(
1040             "We have excluded the following walled in fees:",
1041             account
1042         );
1043     }
1044 
1045     //include wallet back in fees.
1046     function includeInFee(address account) external onlyOwner {
1047         require(_isExcludedFromFee[account] != false, "The wallet is already included!");
1048         _isExcludedFromFee[account] = false;
1049         emit AuditLog(
1050             "We have including the following walled in fees:",
1051             account
1052         );
1053     }
1054 
1055     //Automatic Swap Configuration.
1056     function setTokensToSwap(
1057         uint256 _minimumTokensBeforeSwap
1058     ) external onlyOwner {
1059         require(
1060             _minimumTokensBeforeSwap >= 100 ether,
1061             "You need to enter more than 100 tokens."
1062         );
1063         minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
1064         emit Log(
1065             "We have updated minimunTokensBeforeSwap to:",
1066             minimumTokensBeforeSwap
1067         );
1068     }
1069 
1070     function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner {
1071         require(swapAndLiquifyEnabled != _enabled, "Value already set");
1072         swapAndLiquifyEnabled = _enabled;
1073         emit SwapAndLiquifyEnabledUpdated(_enabled);
1074     }
1075 
1076     //set a new marketing wallet.
1077     function setmarketingWallet(address _marketingWallet) external onlyOwner {
1078         require(_marketingWallet != address(0), "setmarketingWallet: ZERO");
1079         marketingWallet = payable(_marketingWallet);
1080         emit AuditLog("We have Updated the MarketingWallet:", marketingWallet);
1081     }
1082 
1083     function setBuyFee(uint256 _buyFee) external onlyOwner {
1084         require(_buyFee <= 10, "Buy Fee cannot be more than 10%");
1085         buyFee = _buyFee;
1086         emit Log("We have updated the buy fee to:", buyFee);
1087     }
1088 
1089     function setSellFee(uint256 _sellFee) external onlyOwner {
1090         require(_sellFee <= 10, "Sell Fee cannot be more than 10%");
1091         sellFee = _sellFee;
1092         emit Log("We have updated the sell fee to:", sellFee);
1093     }
1094 
1095 function transferToAddressETH(
1096         address payable recipient,
1097         uint256 amount
1098     ) private {
1099         if (amount == 0) return;
1100         (bool succ, ) = recipient.call{value: amount}("");
1101         emit TransferStatus("Transfer Status",succ );
1102     }
1103 
1104     //to recieve ETH from uniswapV2Router when swaping
1105     receive() external payable {}
1106 
1107     /////---fallback--////
1108     //This cannot be removed as is a fallback to the swapAndLiquify
1109     event SwapETHForTokens(uint256 amountIn, address[] path);
1110 
1111     function swapETHForTokens(uint256 amount) private {
1112         // generate the uniswap pair path of token -> weth
1113         address[] memory path = new address[](2);
1114         path[0] = WETH;
1115         path[1] = address(this);
1116         // make the swap
1117         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{
1118             value: amount
1119         }(
1120             0, // accept any amount of Tokens
1121             path,
1122             deadWallet, // Burn address
1123             block.timestamp + 300
1124         );
1125         emit SwapETHForTokens(amount, path);
1126     }
1127 
1128     // Withdraw ETH that's potentially stuck in the Contract
1129     function recoverETHfromContract() external onlyOwner {
1130         uint ethBalance = address(this).balance;
1131         (bool succ, ) = payable(marketingWallet).call{value: ethBalance}("");
1132         require(succ, "Transfer failed");
1133         emit AuditLog(
1134             "We have recover the stuck eth from contract.",
1135             marketingWallet
1136         );
1137     }
1138 
1139     // Withdraw ERC20 tokens that are potentially stuck in Contract
1140     function recoverTokensFromContract(
1141         address _tokenAddress,
1142         uint256 _amount
1143     ) external onlyOwner {
1144         require(
1145             _tokenAddress != address(this),
1146             "Owner can't claim contract's balance of its own tokens"
1147         );
1148         bool succ = IERC20(_tokenAddress).transfer(marketingWallet, _amount);
1149         require(succ, "Transfer failed");
1150         emit Log("We have recovered tokens from contract:", _amount);
1151     }
1152         //Trading Controls for SAFU Contract
1153         function enableTrading() external onlyOwner{
1154         require(!tradingEnabled, "Trading already enabled.");
1155         tradingEnabled = true;
1156         swapAndLiquifyEnabled = true;
1157         emit AuditLog("We have Enable Trading and Automatic Swaps:", msg.sender);
1158     }
1159     //Updated code to enable swapAndLiquify at the time of enable trade.
1160 }