1 /*
2  _______                  ___________     __                  
3  \      \ ___.__.___  ___ \__    ___/___ |  | __ ____   ____  
4  /   |   <   |  |\  \/  /   |    | /  _ \|  |/ // __ \ /    \ 
5 /    |    \___  | >    <    |    |(  <_> )    <\  ___/|   |  \
6 \____|__  / ____|/__/\_ \   |____| \____/|__|_ \\___  >___|  /
7         \/\/           \/                     \/    \/     \/                                           
8 */
9 
10 
11 pragma solidity 0.8.7;
12 /**
13  * @dev Collection of functions related to the address type
14  */
15 library Address {
16     /**
17      * @dev Returns true if `account` is a contract.
18      *
19      * [IMPORTANT]
20      * ====
21      * It is unsafe to assume that an address for which this function returns
22      * false is an externally-owned account (EOA) and not a contract.
23      *
24      * Among others, `isContract` will return false for the following
25      * types of addresses:
26      *
27      *  - an externally-owned account
28      *  - a contract in construction
29      *  - an address where a contract will be created
30      *  - an address where a contract lived, but was destroyed
31      * ====
32      */
33     function isContract(address account) internal view returns (bool) {
34         // This method relies on extcodesize, which returns 0 for contracts in
35         // construction, since the code is only stored at the end of the
36         // constructor execution.
37 
38         uint256 size;
39         assembly {
40             size := extcodesize(account)
41         }
42         return size > 0;
43     }
44 
45     /**
46      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
47      * `recipient`, forwarding all available gas and reverting on errors.
48      *
49      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
50      * of certain opcodes, possibly making contracts go over the 2300 gas limit
51      * imposed by `transfer`, making them unable to receive funds via
52      * `transfer`. {sendValue} removes this limitation.
53      *
54      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
55      *
56      * IMPORTANT: because control is transferred to `recipient`, care must be
57      * taken to not create reentrancy vulnerabilities. Consider using
58      * {ReentrancyGuard} or the
59      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
60      */
61     function sendValue(address payable recipient, uint256 amount) internal {
62         require(address(this).balance >= amount, "Address: insufficient balance");
63 
64         (bool success, ) = recipient.call{value: amount}("");
65         require(success, "Address: unable to send value, recipient may have reverted");
66     }
67 
68     /**
69      * @dev Performs a Solidity function call using a low level `call`. A
70      * plain `call` is an unsafe replacement for a function call: use this
71      * function instead.
72      *
73      * If `target` reverts with a revert reason, it is bubbled up by this
74      * function (like regular Solidity function calls).
75      *
76      * Returns the raw returned data. To convert to the expected return value,
77      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
78      *
79      * Requirements:
80      *
81      * - `target` must be a contract.
82      * - calling `target` with `data` must not revert.
83      *
84      * _Available since v3.1._
85      */
86     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
87         return functionCall(target, data, "Address: low-level call failed");
88     }
89 
90     /**
91      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
92      * `errorMessage` as a fallback revert reason when `target` reverts.
93      *
94      * _Available since v3.1._
95      */
96     function functionCall(
97         address target,
98         bytes memory data,
99         string memory errorMessage
100     ) internal returns (bytes memory) {
101         return functionCallWithValue(target, data, 0, errorMessage);
102     }
103 
104     /**
105      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
106      * but also transferring `value` wei to `target`.
107      *
108      * Requirements:
109      *
110      * - the calling contract must have an ETH balance of at least `value`.
111      * - the called Solidity function must be `payable`.
112      *
113      * _Available since v3.1._
114      */
115     function functionCallWithValue(
116         address target,
117         bytes memory data,
118         uint256 value
119     ) internal returns (bytes memory) {
120         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
121     }
122 
123     /**
124      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
125      * with `errorMessage` as a fallback revert reason when `target` reverts.
126      *
127      * _Available since v3.1._
128      */
129     function functionCallWithValue(
130         address target,
131         bytes memory data,
132         uint256 value,
133         string memory errorMessage
134     ) internal returns (bytes memory) {
135         require(address(this).balance >= value, "Address: insufficient balance for call");
136         require(isContract(target), "Address: call to non-contract");
137 
138         (bool success, bytes memory returndata) = target.call{value: value}(data);
139         return verifyCallResult(success, returndata, errorMessage);
140     }
141 
142     /**
143      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
144      * but performing a static call.
145      *
146      * _Available since v3.3._
147      */
148     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
149         return functionStaticCall(target, data, "Address: low-level static call failed");
150     }
151 
152     /**
153      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
154      * but performing a static call.
155      *
156      * _Available since v3.3._
157      */
158     function functionStaticCall(
159         address target,
160         bytes memory data,
161         string memory errorMessage
162     ) internal view returns (bytes memory) {
163         require(isContract(target), "Address: static call to non-contract");
164 
165         (bool success, bytes memory returndata) = target.staticcall(data);
166         return verifyCallResult(success, returndata, errorMessage);
167     }
168 
169     /**
170      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
171      * but performing a delegate call.
172      *
173      * _Available since v3.4._
174      */
175     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
176         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
177     }
178 
179     /**
180      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
181      * but performing a delegate call.
182      *
183      * _Available since v3.4._
184      */
185     function functionDelegateCall(
186         address target,
187         bytes memory data,
188         string memory errorMessage
189     ) internal returns (bytes memory) {
190         require(isContract(target), "Address: delegate call to non-contract");
191 
192         (bool success, bytes memory returndata) = target.delegatecall(data);
193         return verifyCallResult(success, returndata, errorMessage);
194     }
195 
196     /**
197      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
198      * revert reason using the provided one.
199      *
200      * _Available since v4.3._
201      */
202     function verifyCallResult(
203         bool success,
204         bytes memory returndata,
205         string memory errorMessage
206     ) internal pure returns (bytes memory) {
207         if (success) {
208             return returndata;
209         } else {
210             // Look for revert reason and bubble it up if present
211             if (returndata.length > 0) {
212                 // The easiest way to bubble the revert reason is using memory via assembly
213 
214                 assembly {
215                     let returndata_size := mload(returndata)
216                     revert(add(32, returndata), returndata_size)
217                 }
218             } else {
219                 revert(errorMessage);
220             }
221         }
222     }
223 }
224 
225 // File: @openzeppelin/contracts/utils/Context.sol
226 
227 
228 
229 pragma solidity 0.8.7;
230 /**
231  * @dev Provides information about the current execution context, including the
232  * sender of the transaction and its data. While these are generally available
233  * via msg.sender and msg.data, they should not be accessed in such a direct
234  * manner, since when dealing with meta-transactions the account sending and
235  * paying for execution may not be the actual sender (as far as an application
236  * is concerned).
237  *
238  * This contract is only required for intermediate, library-like contracts.
239  */
240 abstract contract Context {
241     function _msgSender() internal view virtual returns (address) {
242         return msg.sender;
243     }
244 
245     function _msgData() internal view virtual returns (bytes calldata) {
246         return msg.data;
247     }
248 }
249 
250 // File: @openzeppelin/contracts/access/Ownable.sol
251 
252 
253 
254 pragma solidity 0.8.7;
255 
256 /**
257  * @dev Contract module which provides a basic access control mechanism, where
258  * there is an account (an owner) that can be granted exclusive access to
259  * specific functions.
260  *
261  * By default, the owner account will be the one that deploys the contract. This
262  * can later be changed with {transferOwnership}.
263  *
264  * This module is used through inheritance. It will make available the modifier
265  * `onlyOwner`, which can be applied to your functions to restrict their use to
266  * the owner.
267  */
268 abstract contract Ownable is Context {
269     address private _owner;
270 
271     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
272 
273     /**
274      * @dev Initializes the contract setting the deployer as the initial owner.
275      */
276     constructor() {
277         _setOwner(_msgSender());
278     }
279 
280     /**
281      * @dev Returns the address of the current owner.
282      */
283     function owner() public view virtual returns (address) {
284         return _owner;
285     }
286 
287     /**
288      * @dev Throws if called by any account other than the owner.
289      */
290     modifier onlyOwner() {
291         require(owner() == _msgSender(), "Ownable: caller is not the owner");
292         _;
293     }
294 
295     /**
296      * @dev Leaves the contract without owner. It will not be possible to call
297      * `onlyOwner` functions anymore. Can only be called by the current owner.
298      *
299      * NOTE: Renouncing ownership will leave the contract without an owner,
300      * thereby removing any functionality that is only available to the owner.
301      */
302     function renounceOwnership() public virtual onlyOwner {
303         _setOwner(address(0));
304     }
305 
306     /**
307      * @dev Transfers ownership of the contract to a new account (`newOwner`).
308      * Can only be called by the current owner.
309      */
310     function transferOwnership(address newOwner) public virtual onlyOwner {
311         require(newOwner != address(0), "Ownable: new owner is the zero address");
312         _setOwner(newOwner);
313     }
314 
315     function _setOwner(address newOwner) private {
316         address oldOwner = _owner;
317         _owner = newOwner;
318         emit OwnershipTransferred(oldOwner, newOwner);
319     }
320 }
321 
322 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
323 
324 
325 
326 pragma solidity 0.8.7;
327 /**
328  * @dev Interface of the ERC20 standard as defined in the EIP.
329  */
330 interface IERC20 {
331     /**
332      * @dev Returns the amount of tokens in existence.
333      */
334     function totalSupply() external view returns (uint256);
335 
336     /**
337      * @dev Returns the amount of tokens owned by `account`.
338      */
339     function balanceOf(address account) external view returns (uint256);
340 
341     /**
342      * @dev Moves `amount` tokens from the caller's account to `recipient`.
343      *
344      * Returns a boolean value indicating whether the operation succeeded.
345      *
346      * Emits a {Transfer} event.
347      */
348     function transfer(address recipient, uint256 amount) external returns (bool);
349 
350     /**
351      * @dev Returns the remaining number of tokens that `spender` will be
352      * allowed to spend on behalf of `owner` through {transferFrom}. This is
353      * zero by default.
354      *
355      * This value changes when {approve} or {transferFrom} are called.
356      */
357     function allowance(address owner, address spender) external view returns (uint256);
358 
359     /**
360      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
361      *
362      * Returns a boolean value indicating whether the operation succeeded.
363      *
364      * IMPORTANT: Beware that changing an allowance with this method brings the risk
365      * that someone may use both the old and the new allowance by unfortunate
366      * transaction ordering. One possible solution to mitigate this race
367      * condition is to first reduce the spender's allowance to 0 and set the
368      * desired value afterwards:
369      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
370      *
371      * Emits an {Approval} event.
372      */
373     function approve(address spender, uint256 amount) external returns (bool);
374 
375     /**
376      * @dev Moves `amount` tokens from `sender` to `recipient` using the
377      * allowance mechanism. `amount` is then deducted from the caller's
378      * allowance.
379      *
380      * Returns a boolean value indicating whether the operation succeeded.
381      *
382      * Emits a {Transfer} event.
383      */
384     function transferFrom(
385         address sender,
386         address recipient,
387         uint256 amount
388     ) external returns (bool);
389 
390     /**
391      * @dev Emitted when `value` tokens are moved from one account (`from`) to
392      * another (`to`).
393      *
394      * Note that `value` may be zero.
395      */
396     event Transfer(address indexed from, address indexed to, uint256 value);
397 
398     /**
399      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
400      * a call to {approve}. `value` is the new allowance.
401      */
402     event Approval(address indexed owner, address indexed spender, uint256 value);
403 }
404 
405 // File: token.sol
406 
407 
408 pragma solidity 0.8.7;
409 
410 interface IUniswapV2Factory {
411     event PairCreated(
412         address indexed token0,
413         address indexed token1,
414         address pair,
415         uint256
416     );
417 
418     function feeTo() external view returns (address);
419 
420     function feeToSetter() external view returns (address);
421 
422     function getPair(address tokenA, address tokenB)
423         external
424         view
425         returns (address pair);
426 
427     function allPairs(uint256) external view returns (address pair);
428 
429     function allPairsLength() external view returns (uint256);
430 
431     function createPair(address tokenA, address tokenB)
432         external
433         returns (address pair);
434 
435     function setFeeTo(address) external;
436 
437     function setFeeToSetter(address) external;
438 }
439 
440 interface IUniswapV2Pair {
441     event Approval(
442         address indexed owner,
443         address indexed spender,
444         uint256 value
445     );
446     event Transfer(address indexed from, address indexed to, uint256 value);
447 
448     function name() external pure returns (string memory);
449 
450     function symbol() external pure returns (string memory);
451 
452     function decimals() external pure returns (uint8);
453 
454     function totalSupply() external view returns (uint256);
455 
456     function balanceOf(address owner) external view returns (uint256);
457 
458     function allowance(address owner, address spender)
459         external
460         view
461         returns (uint256);
462 
463     function approve(address spender, uint256 value) external returns (bool);
464 
465     function transfer(address to, uint256 value) external returns (bool);
466 
467     function transferFrom(
468         address from,
469         address to,
470         uint256 value
471     ) external returns (bool);
472 
473     function DOMAIN_SEPARATOR() external view returns (bytes32);
474 
475     function PERMIT_TYPEHASH() external pure returns (bytes32);
476 
477     function nonces(address owner) external view returns (uint256);
478 
479     function permit(
480         address owner,
481         address spender,
482         uint256 value,
483         uint256 deadline,
484         uint8 v,
485         bytes32 r,
486         bytes32 s
487     ) external;
488 
489     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
490     event Burn(
491         address indexed sender,
492         uint256 amount0,
493         uint256 amount1,
494         address indexed to
495     );
496     event Swap(
497         address indexed sender,
498         uint256 amount0In,
499         uint256 amount1In,
500         uint256 amount0Out,
501         uint256 amount1Out,
502         address indexed to
503     );
504     event Sync(uint112 reserve0, uint112 reserve1);
505 
506     function MINIMUM_LIQUIDITY() external pure returns (uint256);
507 
508     function factory() external view returns (address);
509 
510     function token0() external view returns (address);
511 
512     function token1() external view returns (address);
513 
514     function getReserves()
515         external
516         view
517         returns (
518             uint112 reserve0,
519             uint112 reserve1,
520             uint32 blockTimestampLast
521         );
522 
523     function price0CumulativeLast() external view returns (uint256);
524 
525     function price1CumulativeLast() external view returns (uint256);
526 
527     function kLast() external view returns (uint256);
528 
529     function mint(address to) external returns (uint256 liquidity);
530 
531     function burn(address to)
532         external
533         returns (uint256 amount0, uint256 amount1);
534 
535     function swap(
536         uint256 amount0Out,
537         uint256 amount1Out,
538         address to,
539         bytes calldata data
540     ) external;
541 
542     function skim(address to) external;
543 
544     function sync() external;
545 
546     function initialize(address, address) external;
547 }
548 
549 interface IUniswapV2Router01 {
550     function factory() external pure returns (address);
551 
552     function WETH() external pure returns (address);
553 
554     function addLiquidity(
555         address tokenA,
556         address tokenB,
557         uint256 amountADesired,
558         uint256 amountBDesired,
559         uint256 amountAMin,
560         uint256 amountBMin,
561         address to,
562         uint256 deadline
563     )
564         external
565         returns (
566             uint256 amountA,
567             uint256 amountB,
568             uint256 liquidity
569         );
570 
571     function addLiquidityETH(
572         address token,
573         uint256 amountTokenDesired,
574         uint256 amountTokenMin,
575         uint256 amountETHMin,
576         address to,
577         uint256 deadline
578     )
579         external
580         payable
581         returns (
582             uint256 amountToken,
583             uint256 amountETH,
584             uint256 liquidity
585         );
586 
587     function removeLiquidity(
588         address tokenA,
589         address tokenB,
590         uint256 liquidity,
591         uint256 amountAMin,
592         uint256 amountBMin,
593         address to,
594         uint256 deadline
595     ) external returns (uint256 amountA, uint256 amountB);
596 
597     function removeLiquidityETH(
598         address token,
599         uint256 liquidity,
600         uint256 amountTokenMin,
601         uint256 amountETHMin,
602         address to,
603         uint256 deadline
604     ) external returns (uint256 amountToken, uint256 amountETH);
605 
606     function removeLiquidityWithPermit(
607         address tokenA,
608         address tokenB,
609         uint256 liquidity,
610         uint256 amountAMin,
611         uint256 amountBMin,
612         address to,
613         uint256 deadline,
614         bool approveMax,
615         uint8 v,
616         bytes32 r,
617         bytes32 s
618     ) external returns (uint256 amountA, uint256 amountB);
619 
620     function removeLiquidityETHWithPermit(
621         address token,
622         uint256 liquidity,
623         uint256 amountTokenMin,
624         uint256 amountETHMin,
625         address to,
626         uint256 deadline,
627         bool approveMax,
628         uint8 v,
629         bytes32 r,
630         bytes32 s
631     ) external returns (uint256 amountToken, uint256 amountETH);
632 
633     function swapExactTokensForTokens(
634         uint256 amountIn,
635         uint256 amountOutMin,
636         address[] calldata path,
637         address to,
638         uint256 deadline
639     ) external returns (uint256[] memory amounts);
640 
641     function swapTokensForExactTokens(
642         uint256 amountOut,
643         uint256 amountInMax,
644         address[] calldata path,
645         address to,
646         uint256 deadline
647     ) external returns (uint256[] memory amounts);
648 
649     function swapExactETHForTokens(
650         uint256 amountOutMin,
651         address[] calldata path,
652         address to,
653         uint256 deadline
654     ) external payable returns (uint256[] memory amounts);
655 
656     function swapTokensForExactETH(
657         uint256 amountOut,
658         uint256 amountInMax,
659         address[] calldata path,
660         address to,
661         uint256 deadline
662     ) external returns (uint256[] memory amounts);
663 
664     function swapExactTokensForETH(
665         uint256 amountIn,
666         uint256 amountOutMin,
667         address[] calldata path,
668         address to,
669         uint256 deadline
670     ) external returns (uint256[] memory amounts);
671 
672     function swapETHForExactTokens(
673         uint256 amountOut,
674         address[] calldata path,
675         address to,
676         uint256 deadline
677     ) external payable returns (uint256[] memory amounts);
678 
679     function quote(
680         uint256 amountA,
681         uint256 reserveA,
682         uint256 reserveB
683     ) external pure returns (uint256 amountB);
684 
685     function getAmountOut(
686         uint256 amountIn,
687         uint256 reserveIn,
688         uint256 reserveOut
689     ) external pure returns (uint256 amountOut);
690 
691     function getAmountIn(
692         uint256 amountOut,
693         uint256 reserveIn,
694         uint256 reserveOut
695     ) external pure returns (uint256 amountIn);
696 
697     function getAmountsOut(uint256 amountIn, address[] calldata path)
698         external
699         view
700         returns (uint256[] memory amounts);
701 
702     function getAmountsIn(uint256 amountOut, address[] calldata path)
703         external
704         view
705         returns (uint256[] memory amounts);
706 }
707 
708 interface IUniswapV2Router02 is IUniswapV2Router01 {
709     function removeLiquidityETHSupportingFeeOnTransferTokens(
710         address token,
711         uint256 liquidity,
712         uint256 amountTokenMin,
713         uint256 amountETHMin,
714         address to,
715         uint256 deadline
716     ) external returns (uint256 amountETH);
717 
718     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
719         address token,
720         uint256 liquidity,
721         uint256 amountTokenMin,
722         uint256 amountETHMin,
723         address to,
724         uint256 deadline,
725         bool approveMax,
726         uint8 v,
727         bytes32 r,
728         bytes32 s
729     ) external returns (uint256 amountETH);
730 
731     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
732         uint256 amountIn,
733         uint256 amountOutMin,
734         address[] calldata path,
735         address to,
736         uint256 deadline
737     ) external;
738 
739     function swapExactETHForTokensSupportingFeeOnTransferTokens(
740         uint256 amountOutMin,
741         address[] calldata path,
742         address to,
743         uint256 deadline
744     ) external payable;
745 
746     function swapExactTokensForETHSupportingFeeOnTransferTokens(
747         uint256 amountIn,
748         uint256 amountOutMin,
749         address[] calldata path,
750         address to,
751         uint256 deadline
752     ) external;
753 }
754 
755 contract NyxToken is Context, IERC20, Ownable {
756     using Address for address;
757 
758     mapping(address => uint256) private _rOwned;
759     mapping(address => uint256) private _tOwned;
760     mapping(address => mapping(address => uint256)) private _allowances;
761 
762     mapping(address => bool) private _isExcludedFromFee;
763     mapping(address => bool) private _isExcluded;
764     address[] private _excluded;
765 
766     // Liquidity Pairs
767     mapping(address => bool) public _isPair;
768 
769     // Banned contracts
770     mapping(address => bool) public _isBanned;
771 
772     uint256 private constant MAX = ~uint256(0);
773     uint256 public constant _tTotal = 1e15 * 10**9;
774     uint256 private _rTotal = (MAX - (MAX % _tTotal));
775     uint256 private _tFeeTotal;
776 
777     string private constant _name = "Nyx Token";
778     string private constant _symbol = "NYXT";
779     uint8 private constant _decimals = 9;
780 
781     // Wallets
782     address public _marketingWalletAddress;
783     address public _msWalletAddress; // Multiple Sclerosis wallet
784     address public _vetWalletAddress; // Veterans wallet
785     address public constant _deadAddress =
786         0x000000000000000000000000000000000000dEaD;
787 
788     uint256 public _taxFee = 20; // also is fee for ms & vet funds
789     uint256 public _marketingFee = 10;
790     uint256 public _burnFee = 10;
791 
792     bool public _contractFeesEnabled = true;
793 
794     IUniswapV2Router02 public uniswapV2Router;
795     address public uniswapV2Pair;
796 
797     bool public swapEnabled = true;
798 
799     uint256 public _maxTxAmount = _tTotal;
800 
801     event SetContractFeesEnabled(bool _bool);
802     event SetIsPair(address _address, bool _bool);
803     event SetIsBanned(address _address, bool _bool);
804     event SetSwapEnabled(bool enabled);
805     event SetMarketingWalletAddress(address _address);
806     event WithdrawalETH(uint256 _amount, address to);
807     event WithdrawalToken(address _tokenAddr, uint256 _amount, address to);
808     event ExcludeFromReward(address _address);
809     event IncludeInReward(address _address);
810     event ExcludeFromFee(address _address);
811     event IncludeInFee(address _address);
812     event SetMaxTxPercent(uint256 _amount);
813     event SetMSWalletAddress(address _address);
814     event SetVetWalletAddress(address _address);
815 
816     /*
817      * mainnet params
818      * uniswap router - 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
819      * dev wallet - 0x18ACa07DB9807c173B11eFF42f9e7f1c2B676c53
820      * veterans wallet - 0xc11b9a1e6119f6ae93b3eec1d8178e149bf57bad
821      * ms wallet - 0xd93d81650dE684532d6F76F618Bb66621Be17E8c
822      */
823     constructor(
824         address router,
825         address marketingWallet,
826         address msWallet,
827         address vetWallet
828     ) {
829         _rOwned[owner()] = _rTotal;
830 
831         _setRouter(router);
832         _marketingWalletAddress = marketingWallet;
833         _msWalletAddress = msWallet;
834         _vetWalletAddress = vetWallet;
835 
836         // Exclude owner, dev wallet, liq wallet, and this contract from fee
837         _isExcludedFromFee[owner()] = true;
838         _isExcludedFromFee[_marketingWalletAddress] = true;
839         _isExcludedFromFee[_msWalletAddress] = true;
840         _isExcludedFromFee[_vetWalletAddress] = true;
841         _isExcludedFromFee[address(this)] = true;
842 
843         emit Transfer(address(0), owner(), _tTotal);
844     }
845 
846     function name() external pure returns (string memory) {
847         return _name;
848     }
849 
850     function symbol() external pure returns (string memory) {
851         return _symbol;
852     }
853 
854     function decimals() external pure returns (uint8) {
855         return _decimals;
856     }
857 
858     function totalSupply() external pure override returns (uint256) {
859         return _tTotal;
860     }
861 
862     function balanceOf(address account) public view override returns (uint256) {
863         if (_isExcluded[account]) return _tOwned[account];
864         return tokenFromReflection(_rOwned[account]);
865     }
866 
867     function transfer(address recipient, uint256 amount)
868         external
869         override
870         returns (bool)
871     {
872         _transfer(_msgSender(), recipient, amount);
873         return true;
874     }
875 
876     function allowance(address owner, address spender)
877         external
878         view
879         override
880         returns (uint256)
881     {
882         return _allowances[owner][spender];
883     }
884 
885     function approve(address spender, uint256 amount)
886         external
887         override
888         returns (bool)
889     {
890         _approve(_msgSender(), spender, amount);
891         return true;
892     }
893 
894     function transferFrom(
895         address sender,
896         address recipient,
897         uint256 amount
898     ) external override returns (bool) {
899         _transfer(sender, recipient, amount);
900         _approve(
901             sender,
902             _msgSender(),
903             _allowances[sender][_msgSender()] - amount
904         );
905         return true;
906     }
907 
908     function increaseAllowance(address spender, uint256 addedValue)
909         external
910         virtual
911         returns (bool)
912     {
913         _approve(
914             _msgSender(),
915             spender,
916             _allowances[_msgSender()][spender] + addedValue
917         );
918         return true;
919     }
920 
921     function decreaseAllowance(address spender, uint256 subtractedValue)
922         external
923         virtual
924         returns (bool)
925     {
926         _approve(
927             _msgSender(),
928             spender,
929             _allowances[_msgSender()][spender] - subtractedValue
930         );
931         return true;
932     }
933 
934     function isExcludedFromReward(address account)
935         external
936         view
937         returns (bool)
938     {
939         return _isExcluded[account];
940     }
941 
942     function totalFees() external view returns (uint256) {
943         return _tFeeTotal;
944     }
945 
946     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
947         external
948         view
949         returns (uint256)
950     {
951         require(tAmount <= _tTotal, "Amount must be less than supply");
952         if (!deductTransferFee) {
953             (uint256 rAmount, , , , , , ) = _getValues(tAmount);
954             return rAmount;
955         } else {
956             (, uint256 rTransferAmount, , , , , ) = _getValues(tAmount);
957             return rTransferAmount;
958         }
959     }
960 
961     function tokenFromReflection(uint256 rAmount)
962         public
963         view
964         returns (uint256)
965     {
966         require(
967             rAmount <= _rTotal,
968             "Amount must be less than total reflections"
969         );
970         uint256 currentRate = _getRate();
971         return rAmount / (currentRate);
972     }
973 
974     function excludeFromReward(address account) external onlyOwner {
975         require(!_isExcluded[account], "Account is not excluded");
976         if (_rOwned[account] > 0) {
977             _tOwned[account] = tokenFromReflection(_rOwned[account]);
978         }
979         _isExcluded[account] = true;
980         _excluded.push(account);
981         emit ExcludeFromReward(account);
982     }
983 
984     function includeInReward(address account) external onlyOwner {
985         require(_isExcluded[account], "Account is already included");
986         for (uint256 i = 0; i < _excluded.length; i++) {
987             if (_excluded[i] == account) {
988                 _excluded[i] = _excluded[_excluded.length - 1];
989                 _tOwned[account] = 0;
990                 _isExcluded[account] = false;
991                 _excluded.pop();
992                 break;
993             }
994         }
995         emit IncludeInReward(account);
996     }
997 
998     function _transferBothExcluded(
999         address sender,
1000         address recipient,
1001         uint256 tAmount
1002     ) private {
1003         (
1004             uint256 rAmount,
1005             uint256 rTransferAmount,
1006             uint256 rFee,
1007             uint256 tTransferAmount,
1008             uint256 tFee,
1009             uint256 tMarketing,
1010             uint256 tBurn
1011         ) = _getValues(tAmount);
1012         _tOwned[sender] = _tOwned[sender] - (tAmount);
1013         _rOwned[sender] = _rOwned[sender] - (rAmount);
1014         _tOwned[recipient] = _tOwned[recipient] + (tTransferAmount);
1015         _rOwned[recipient] = _rOwned[recipient] + (rTransferAmount);
1016         _takeMS(tFee);
1017         _takeVet(tFee);
1018         _takeMarketing(tMarketing);
1019         _takeBurn(tBurn);
1020         _reflectFee(rFee, tFee);
1021         emit Transfer(sender, recipient, tTransferAmount);
1022     }
1023 
1024     function excludeFromFee(address account) external onlyOwner {
1025         _isExcludedFromFee[account] = true;
1026         emit ExcludeFromFee(account);
1027     }
1028 
1029     function includeInFee(address account) external onlyOwner {
1030         _isExcludedFromFee[account] = false;
1031         emit IncludeInFee(account);
1032     }
1033 
1034     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner {
1035         _maxTxAmount = (_tTotal * (maxTxPercent)) / (10**2);
1036         emit SetMaxTxPercent(maxTxPercent);
1037     }
1038 
1039     function setSwapEnabled(bool _enabled) external onlyOwner {
1040         swapEnabled = _enabled;
1041         emit SetSwapEnabled(_enabled);
1042     }
1043 
1044     function setMarketingWalletAddress(address _address) external onlyOwner {
1045         require(
1046             _address != address(0),
1047             "Error: devWallet address cannot be zero address"
1048         );
1049         _marketingWalletAddress = _address;
1050         emit SetMarketingWalletAddress(_address);
1051     }
1052 
1053     function setMSWalletAddress(address _address) external onlyOwner {
1054         require(
1055             _address != address(0),
1056             "Error: msWallet address cannot be zero address"
1057         );
1058         _msWalletAddress = _address;
1059         emit SetMSWalletAddress(_address);
1060     }
1061 
1062     function setVetWalletAddress(address _address) external onlyOwner {
1063         require(
1064             _address != address(0),
1065             "Error: vetWallet address cannot be zero address"
1066         );
1067         _vetWalletAddress = _address;
1068         emit SetVetWalletAddress(_address);
1069     }
1070 
1071     function setContractFeesEnabled(bool _bool) external onlyOwner {
1072         _contractFeesEnabled = _bool;
1073         emit SetContractFeesEnabled(_bool);
1074     }
1075 
1076     function _setRouter(address _router) private {
1077         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(_router);
1078         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(
1079             address(this),
1080             _uniswapV2Router.WETH()
1081         );
1082         if (uniswapV2Pair == address(0))
1083             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1084                 .createPair(address(this), _uniswapV2Router.WETH());
1085         uniswapV2Router = _uniswapV2Router;
1086         setIsPair(uniswapV2Pair, true);
1087     }
1088 
1089     // to receive ETH from uniswapV2Router when swapping
1090     receive() external payable {}
1091 
1092     // static reflection
1093     function _reflectFee(uint256 rFee, uint256 tFee) private {
1094         _rTotal = _rTotal - (rFee);
1095         _tFeeTotal = _tFeeTotal + (tFee);
1096     }
1097 
1098     function _getValues(uint256 tAmount)
1099         private
1100         view
1101         returns (
1102             uint256,
1103             uint256,
1104             uint256,
1105             uint256,
1106             uint256,
1107             uint256,
1108             uint256
1109         )
1110     {
1111         (
1112             uint256 tTransferAmount,
1113             uint256 tFee,
1114             uint256 tMarketing,
1115             uint256 tBurn
1116         ) = _getTValues(tAmount);
1117         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1118             tAmount,
1119             tFee,
1120             tMarketing,
1121             tBurn,
1122             _getRate()
1123         );
1124         return (
1125             rAmount,
1126             rTransferAmount,
1127             rFee,
1128             tTransferAmount,
1129             tFee,
1130             tMarketing,
1131             tBurn
1132         );
1133     }
1134 
1135     function _getTValues(uint256 tAmount)
1136         private
1137         view
1138         returns (
1139             uint256,
1140             uint256,
1141             uint256,
1142             uint256
1143         )
1144     {
1145         uint256 tFee = calculateReflectFee(tAmount);
1146         uint256 tMarketing = calculateMarketingFee(tAmount);
1147         uint256 tBurn = calculateBurnFee(tAmount);
1148         uint256 tTransferAmount = tAmount - (3 * tFee) - tMarketing - tBurn;
1149         return (tTransferAmount, tFee, tMarketing, tBurn);
1150     }
1151 
1152     function _getRValues(
1153         uint256 tAmount,
1154         uint256 tFee,
1155         uint256 tMarketing,
1156         uint256 tBurn,
1157         uint256 currentRate
1158     )
1159         private
1160         pure
1161         returns (
1162             uint256,
1163             uint256,
1164             uint256
1165         )
1166     {
1167         uint256 rAmount = tAmount * (currentRate);
1168         uint256 rFee = tFee * (currentRate);
1169         uint256 rMarketing = tMarketing * (currentRate);
1170         uint256 rBurn = tBurn * (currentRate);
1171 
1172         uint256 rTransferAmount = rAmount - (3 * rFee) - rMarketing - rBurn;
1173         return (rAmount, rTransferAmount, rFee);
1174     }
1175 
1176     function _getRate() private view returns (uint256) {
1177         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1178         return rSupply / (tSupply);
1179     }
1180 
1181     function _getCurrentSupply() private view returns (uint256, uint256) {
1182         uint256 rSupply = _rTotal;
1183         uint256 tSupply = _tTotal;
1184         for (uint256 i = 0; i < _excluded.length; i++) {
1185             if (
1186                 _rOwned[_excluded[i]] > rSupply ||
1187                 _tOwned[_excluded[i]] > tSupply
1188             ) return (_rTotal, _tTotal);
1189             rSupply = rSupply - (_rOwned[_excluded[i]]);
1190             tSupply = tSupply - (_tOwned[_excluded[i]]);
1191         }
1192         if (rSupply < _rTotal / (_tTotal)) return (_rTotal, _tTotal);
1193         return (rSupply, tSupply);
1194     }
1195 
1196     function _takeMarketing(uint256 tMarketing) private {
1197         uint256 currentRate = _getRate();
1198         uint256 rMarketing = tMarketing * (currentRate);
1199         _rOwned[_marketingWalletAddress] =
1200             _rOwned[_marketingWalletAddress] +
1201             (rMarketing);
1202         if (_isExcluded[_marketingWalletAddress])
1203             _tOwned[_marketingWalletAddress] =
1204                 _tOwned[_marketingWalletAddress] +
1205                 (tMarketing);
1206     }
1207 
1208     function _takeBurn(uint256 tBurn) private {
1209         uint256 currentRate = _getRate();
1210         uint256 rBurn = tBurn * (currentRate);
1211         _rOwned[_deadAddress] = _rOwned[_deadAddress] + (rBurn);
1212         if (_isExcluded[_deadAddress])
1213             _tOwned[_deadAddress] = _tOwned[_deadAddress] + (tBurn);
1214     }
1215 
1216     // addition - take MS cut
1217     // 2%
1218     function _takeMS(uint256 tMS) private {
1219         uint256 currentRate = _getRate();
1220         uint256 rMS = tMS * (currentRate);
1221         _rOwned[_msWalletAddress] = _rOwned[_msWalletAddress] + (rMS);
1222         if (_isExcluded[_msWalletAddress])
1223             _tOwned[_msWalletAddress] = _tOwned[_msWalletAddress] + (tMS);
1224     }
1225 
1226     // addition - take vet cut
1227     // 2%
1228     function _takeVet(uint256 tVet) private {
1229         uint256 currentRate = _getRate();
1230         uint256 rVet = tVet * (currentRate);
1231         _rOwned[_vetWalletAddress] = _rOwned[_vetWalletAddress] + (rVet);
1232         if (_isExcluded[_vetWalletAddress])
1233             _tOwned[_vetWalletAddress] = _tOwned[_vetWalletAddress] + (tVet);
1234     }
1235 
1236     function calculateReflectFee(uint256 _amount)
1237         private
1238         view
1239         returns (uint256)
1240     {
1241         return (_amount * (_taxFee)) / (10**3);
1242     }
1243 
1244     function calculateMarketingFee(uint256 _amount)
1245         private
1246         view
1247         returns (uint256)
1248     {
1249         return (_amount * (_marketingFee)) / (10**3);
1250     }
1251 
1252     function calculateBurnFee(uint256 _amount) private view returns (uint256) {
1253         return (_amount * (_burnFee)) / (10**3);
1254     }
1255 
1256     function removeAllFee() private {
1257         _taxFee = 0;
1258         _burnFee = 0;
1259         _marketingFee = 0;
1260     }
1261 
1262     function addAllFee() private {
1263         _taxFee = 20;
1264         _burnFee = 10;
1265         _marketingFee = 10;
1266     }
1267 
1268     function isExcludedFromFee(address account) external view returns (bool) {
1269         return _isExcludedFromFee[account];
1270     }
1271 
1272     function _approve(
1273         address owner,
1274         address spender,
1275         uint256 amount
1276     ) private {
1277         require(owner != address(0), "ERC20: approve from the zero address");
1278         require(spender != address(0), "ERC20: approve to the zero address");
1279 
1280         _allowances[owner][spender] = amount;
1281         emit Approval(owner, spender, amount);
1282     }
1283 
1284     function _transfer(
1285         address from,
1286         address to,
1287         uint256 amount
1288     ) private {
1289         require(from != address(0), "ERC20: transfer from the zero address");
1290         require(to != address(0), "ERC20: transfer to the zero address");
1291         require(amount > 0, "Transfer amount must be greater than zero");
1292         if (from != owner() && to != owner())
1293             require(
1294                 amount <= _maxTxAmount,
1295                 "Transfer amount exceeds the maxTxAmount."
1296             );
1297 
1298         if (!swapEnabled && (_isPair[to] || _isPair[from]))
1299             revert("Buying and selling is disabled");
1300 
1301         if (_isBanned[from] || _isBanned[to]) {
1302             revert("Address is banned");
1303         }
1304 
1305         // Indicates if fee should be deducted from transfer
1306         bool takeFee = true;
1307 
1308         // Remove fees except for buying and selling
1309         if (!_isPair[from] && !_isPair[to]) {
1310             takeFee = false;
1311         }
1312 
1313         // Enable fees if contract fees are enabled and to or from is a contract
1314         if (_contractFeesEnabled && (from.isContract() || to.isContract())) {
1315             takeFee = true;
1316         }
1317 
1318         // If any account belongs to _isExcludedFromFee account then remove the fee
1319         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1320             takeFee = false;
1321         }
1322 
1323         if (takeFee) addAllFee();
1324 
1325         // Transfer amount, it will take tax, burn, liquidity fee
1326         _tokenTransfer(from, to, amount, takeFee);
1327     }
1328 
1329     //this method is responsible for taking all fee, if takeFee is true
1330     function _tokenTransfer(
1331         address sender,
1332         address recipient,
1333         uint256 amount,
1334         bool takeFee
1335     ) private {
1336         if (!takeFee) removeAllFee();
1337 
1338         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1339             _transferFromExcluded(sender, recipient, amount);
1340         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1341             _transferToExcluded(sender, recipient, amount);
1342         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1343             _transferBothExcluded(sender, recipient, amount);
1344         } else {
1345             _transferStandard(sender, recipient, amount);
1346         }
1347     }
1348 
1349     function _transferStandard(
1350         address sender,
1351         address recipient,
1352         uint256 tAmount
1353     ) private {
1354         (
1355             uint256 rAmount,
1356             uint256 rTransferAmount,
1357             uint256 rFee,
1358             uint256 tTransferAmount,
1359             uint256 tFee,
1360             uint256 tMarketing,
1361             uint256 tBurn
1362         ) = _getValues(tAmount);
1363         _rOwned[sender] = _rOwned[sender] - (rAmount);
1364         _rOwned[recipient] = _rOwned[recipient] + (rTransferAmount);
1365         _takeMarketing(tMarketing);
1366         _takeBurn(tBurn);
1367         _takeMS(tFee);
1368         _takeVet(tFee);
1369         _reflectFee(rFee, tFee);
1370         emit Transfer(sender, recipient, tTransferAmount);
1371     }
1372 
1373     function _transferToExcluded(
1374         address sender,
1375         address recipient,
1376         uint256 tAmount
1377     ) private {
1378         (
1379             uint256 rAmount,
1380             uint256 rTransferAmount,
1381             uint256 rFee,
1382             uint256 tTransferAmount,
1383             uint256 tFee,
1384             uint256 tMarketing,
1385             uint256 tBurn
1386         ) = _getValues(tAmount);
1387         _rOwned[sender] = _rOwned[sender] - (rAmount);
1388         _tOwned[recipient] = _tOwned[recipient] + (tTransferAmount);
1389         _rOwned[recipient] = _rOwned[recipient] + (rTransferAmount);
1390         _takeMarketing(tMarketing);
1391         _takeMS(tFee);
1392         _takeBurn(tBurn);
1393         _takeVet(tFee);
1394         _reflectFee(rFee, tFee);
1395         emit Transfer(sender, recipient, tTransferAmount);
1396     }
1397 
1398     function _transferFromExcluded(
1399         address sender,
1400         address recipient,
1401         uint256 tAmount
1402     ) private {
1403         (
1404             uint256 rAmount,
1405             uint256 rTransferAmount,
1406             uint256 rFee,
1407             uint256 tTransferAmount,
1408             uint256 tFee,
1409             uint256 tMarketing,
1410             uint256 tBurn
1411         ) = _getValues(tAmount);
1412         _tOwned[sender] = _tOwned[sender] - (tAmount);
1413         _rOwned[sender] = _rOwned[sender] - (rAmount);
1414         _rOwned[recipient] = _rOwned[recipient] + (rTransferAmount);
1415         _takeMarketing(tMarketing);
1416         _takeMS(tFee);
1417         _takeBurn(tBurn);
1418         _takeVet(tFee);
1419         _reflectFee(rFee, tFee);
1420         emit Transfer(sender, recipient, tTransferAmount);
1421     }
1422 
1423     function setIsPair(address _address, bool value) public onlyOwner {
1424         _isPair[_address] = value;
1425         emit SetIsPair(_address, value);
1426     }
1427 
1428     function setIsBanned(address _address, bool value) external onlyOwner {
1429         require(
1430             _address.isContract(),
1431             "Error: Can only ban or unban contract addresses"
1432         );
1433         _isBanned[_address] = value;
1434         emit SetIsBanned(_address, value);
1435     }
1436 
1437     function withdrawalToken(
1438         address _tokenAddr,
1439         uint256 _amount,
1440         address to
1441     ) external onlyOwner {
1442         IERC20 token = IERC20(_tokenAddr);
1443         token.transfer(to, _amount);
1444         emit WithdrawalToken(_tokenAddr, _amount, to);
1445     }
1446 
1447     function withdrawalETH(uint256 _amount, address to) external onlyOwner {
1448         require(address(this).balance >= _amount);
1449         payable(to).transfer(_amount);
1450         emit WithdrawalETH(_amount, to);
1451     }
1452 }