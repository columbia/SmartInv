1 // SPDX-License-Identifier: Unlicensed
2 // Inspired by https://reflect.finance/
3 pragma solidity 0.8.0;
4 
5 
6 
7 library SafeMath {
8     /**
9      * @dev Returns the addition of two unsigned integers, reverting on
10      * overflow.
11      *
12      * Counterpart to Solidity's `+` operator.
13      *
14      * Requirements:
15      *
16      * - Addition cannot overflow.
17      */
18     function add(uint256 a, uint256 b) internal pure returns (uint256) {
19         uint256 c = a + b;
20         require(c >= a, "SafeMath: addition overflow");
21 
22         return c;
23     }
24 
25     /**
26      * @dev Returns the subtraction of two unsigned integers, reverting on
27      * overflow (when the result is negative).
28      *
29      * Counterpart to Solidity's `-` operator.
30      *
31      * Requirements:
32      *
33      * - Subtraction cannot overflow.
34      */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         return sub(a, b, "SafeMath: subtraction overflow");
37     }
38 
39     /**
40      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
41      * overflow (when the result is negative).
42      *
43      * Counterpart to Solidity's `-` operator.
44      *
45      * Requirements:
46      *
47      * - Subtraction cannot overflow.
48      */
49     function sub(
50         uint256 a,
51         uint256 b,
52         string memory errorMessage
53     ) internal pure returns (uint256) {
54         require(b <= a, errorMessage);
55         uint256 c = a - b;
56 
57         return c;
58     }
59 
60     /**
61      * @dev Returns the multiplication of two unsigned integers, reverting on
62      * overflow.
63      *
64      * Counterpart to Solidity's `*` operator.
65      *
66      * Requirements:
67      *
68      * - Multiplication cannot overflow.
69      */
70     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
71         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
72         // benefit is lost if 'b' is also tested.
73         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
74         if (a == 0) {
75             return 0;
76         }
77 
78         uint256 c = a * b;
79         require(c / a == b, "SafeMath: multiplication overflow");
80 
81         return c;
82     }
83 
84     /**
85      * @dev Returns the integer division of two unsigned integers. Reverts on
86      * division by zero. The result is rounded towards zero.
87      *
88      * Counterpart to Solidity's `/` operator. Note: this function uses a
89      * `revert` opcode (which leaves remaining gas untouched) while Solidity
90      * uses an invalid opcode to revert (consuming all remaining gas).
91      *
92      * Requirements:
93      *
94      * - The divisor cannot be zero.
95      */
96     function div(uint256 a, uint256 b) internal pure returns (uint256) {
97         return div(a, b, "SafeMath: division by zero");
98     }
99 
100     /**
101      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
102      * division by zero. The result is rounded towards zero.
103      *
104      * Counterpart to Solidity's `/` operator. Note: this function uses a
105      * `revert` opcode (which leaves remaining gas untouched) while Solidity
106      * uses an invalid opcode to revert (consuming all remaining gas).
107      *
108      * Requirements:
109      *
110      * - The divisor cannot be zero.
111      */
112     function div(
113         uint256 a,
114         uint256 b,
115         string memory errorMessage
116     ) internal pure returns (uint256) {
117         require(b > 0, errorMessage);
118         uint256 c = a / b;
119         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
126      * Reverts when dividing by zero.
127      *
128      * Counterpart to Solidity's `%` operator. This function uses a `revert`
129      * opcode (which leaves remaining gas untouched) while Solidity uses an
130      * invalid opcode to revert (consuming all remaining gas).
131      *
132      * Requirements:
133      *
134      * - The divisor cannot be zero.
135      */
136     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
137         return mod(a, b, "SafeMath: modulo by zero");
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * Reverts with custom message when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      *
150      * - The divisor cannot be zero.
151      */
152     function mod(
153         uint256 a,
154         uint256 b,
155         string memory errorMessage
156     ) internal pure returns (uint256) {
157         require(b != 0, errorMessage);
158         return a % b;
159     }
160 }
161 
162 abstract contract Context {
163     function _msgSender() internal view virtual returns (address) {
164         return msg.sender;
165     }
166 
167     function _msgData() internal view virtual returns (bytes calldata) {
168         return msg.data;
169     }
170 }
171 
172 library Address {
173     /**
174      * @dev Returns true if `account` is a contract.
175      *
176      * [IMPORTANT]
177      * ====
178      * It is unsafe to assume that an address for which this function returns
179      * false is an externally-owned account (EOA) and not a contract.
180      *
181      * Among others, `isContract` will return false for the following
182      * types of addresses:
183      *
184      *  - an externally-owned account
185      *  - a contract in construction
186      *  - an address where a contract will be created
187      *  - an address where a contract lived, but was destroyed
188      * ====
189      */
190     function isContract(address account) internal view returns (bool) {
191         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
192         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
193         // for accounts without code, i.e. `keccak256('')`
194         bytes32 codehash;
195         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
196         // solhint-disable-next-line no-inline-assembly
197         assembly {
198             codehash := extcodehash(account)
199         }
200         return (codehash != accountHash && codehash != 0x0);
201     }
202 
203     /**
204      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
205      * `recipient`, forwarding all available gas and reverting on errors.
206      *
207      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
208      * of certain opcodes, possibly making contracts go over the 2300 gas limit
209      * imposed by `transfer`, making them unable to receive funds via
210      * `transfer`. {sendValue} removes this limitation.
211      *
212      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
213      *
214      * IMPORTANT: because control is transferred to `recipient`, care must be
215      * taken to not create reentrancy vulnerabilities. Consider using
216      * {ReentrancyGuard} or the
217      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
218      */
219     function sendValue(address payable recipient, uint256 amount) internal {
220         require(
221             address(this).balance >= amount,
222             "Address: insufficient balance"
223         );
224 
225         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
226         (bool success, ) = recipient.call{value: amount}("");
227         require(
228             success,
229             "Address: unable to send value, recipient may have reverted"
230         );
231     }
232 
233     /**
234      * @dev Performs a Solidity function call using a low level `call`. A
235      * plain`call` is an unsafe replacement for a function call: use this
236      * function instead.
237      *
238      * If `target` reverts with a revert reason, it is bubbled up by this
239      * function (like regular Solidity function calls).
240      *
241      * Returns the raw returned data. To convert to the expected return value,
242      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
243      *
244      * Requirements:
245      *
246      * - `target` must be a contract.
247      * - calling `target` with `data` must not revert.
248      *
249      * _Available since v3.1._
250      */
251     function functionCall(address target, bytes memory data)
252         internal
253         returns (bytes memory)
254     {
255         return functionCall(target, data, "Address: low-level call failed");
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
260      * `errorMessage` as a fallback revert reason when `target` reverts.
261      *
262      * _Available since v3.1._
263      */
264     function functionCall(
265         address target,
266         bytes memory data,
267         string memory errorMessage
268     ) internal returns (bytes memory) {
269         return _functionCallWithValue(target, data, 0, errorMessage);
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
274      * but also transferring `value` wei to `target`.
275      *
276      * Requirements:
277      *
278      * - the calling contract must have an ETH balance of at least `value`.
279      * - the called Solidity function must be `payable`.
280      *
281      * _Available since v3.1._
282      */
283     function functionCallWithValue(
284         address target,
285         bytes memory data,
286         uint256 value
287     ) internal returns (bytes memory) {
288         return
289             functionCallWithValue(
290                 target,
291                 data,
292                 value,
293                 "Address: low-level call with value failed"
294             );
295     }
296 
297     /**
298      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
299      * with `errorMessage` as a fallback revert reason when `target` reverts.
300      *
301      * _Available since v3.1._
302      */
303     function functionCallWithValue(
304         address target,
305         bytes memory data,
306         uint256 value,
307         string memory errorMessage
308     ) internal returns (bytes memory) {
309         require(
310             address(this).balance >= value,
311             "Address: insufficient balance for call"
312         );
313         return _functionCallWithValue(target, data, value, errorMessage);
314     }
315 
316     function _functionCallWithValue(
317         address target,
318         bytes memory data,
319         uint256 weiValue,
320         string memory errorMessage
321     ) private returns (bytes memory) {
322         require(isContract(target), "Address: call to non-contract");
323 
324         // solhint-disable-next-line avoid-low-level-calls
325         (bool success, bytes memory returndata) = target.call{value: weiValue}(
326             data
327         );
328         if (success) {
329             return returndata;
330         } else {
331             // Look for revert reason and bubble it up if present
332             if (returndata.length > 0) {
333                 // The easiest way to bubble the revert reason is using memory via assembly
334 
335                 // solhint-disable-next-line no-inline-assembly
336                 assembly {
337                     let returndata_size := mload(returndata)
338                     revert(add(32, returndata), returndata_size)
339                 }
340             } else {
341                 revert(errorMessage);
342             }
343         }
344     }
345 }
346 
347 interface IERC20 {
348     function totalSupply() external view returns (uint256);
349 
350     function balanceOf(address account) external view returns (uint256);
351 
352     function transfer(address recipient, uint256 amount)
353         external
354         returns (bool);
355 
356     function allowance(address owner, address spender)
357         external
358         view
359         returns (uint256);
360 
361     function approve(address spender, uint256 amount) external returns (bool);
362 
363     function transferFrom(
364         address sender,
365         address recipient,
366         uint256 amount
367     ) external returns (bool);
368 
369     event Transfer(address indexed from, address indexed to, uint256 value);
370     event Approval(
371         address indexed owner,
372         address indexed spender,
373         uint256 value
374     );
375 }
376 
377 /**
378  * @dev Contract module which provides a basic access control mechanism, where
379  * there is an account (an owner) that can be granted exclusive access to
380  * specific functions.
381  *
382  * By default, the owner account will be the one that deploys the contract. This
383  * can later be changed with {transferOwnership}.
384  *
385  * This module is used through inheritance. It will make available the modifier
386  * `onlyOwner`, which can be applied to your functions to restrict their use to
387  * the owner.
388  */
389 abstract contract Ownable is Context {
390     address private _owner;
391 
392     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
393 
394     /**
395      * @dev Initializes the contract setting the deployer as the initial owner.
396      */
397     constructor() {
398         _transferOwnership(_msgSender());
399     }
400 
401     /**
402      * @dev Returns the address of the current owner.
403      */
404     function owner() public view virtual returns (address) {
405         return _owner;
406     }
407 
408     /**
409      * @dev Throws if called by any account other than the owner.
410      */
411     modifier onlyOwner() {
412         require(owner() == _msgSender(), "Ownable: caller is not the owner");
413         _;
414     }
415 
416     /**
417      * @dev Leaves the contract without owner. It will not be possible to call
418      * `onlyOwner` functions anymore. Can only be called by the current owner.
419      *
420      * NOTE: Renouncing ownership will leave the contract without an owner,
421      * thereby removing any functionality that is only available to the owner.
422      */
423     function renounceOwnership() public virtual onlyOwner {
424         _transferOwnership(address(0));
425     }
426 
427     /**
428      * @dev Transfers ownership of the contract to a new account (`newOwner`).
429      * Can only be called by the current owner.
430      */
431     function transferOwnership(address newOwner) public virtual onlyOwner {
432         require(newOwner != address(0), "Ownable: new owner is the zero address");
433         _transferOwnership(newOwner);
434     }
435 
436     /**
437      * @dev Transfers ownership of the contract to a new account (`newOwner`).
438      * Internal function without access restriction.
439      */
440     function _transferOwnership(address newOwner) internal virtual {
441         address oldOwner = _owner;
442         _owner = newOwner;
443         emit OwnershipTransferred(oldOwner, newOwner);
444     }
445 }
446 
447 /**
448  * @dev Contract module that helps prevent reentrant calls to a function.
449  *
450  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
451  * available, which can be applied to functions to make sure there are no nested
452  * (reentrant) calls to them.
453  *
454  * Note that because there is a single `nonReentrant` guard, functions marked as
455  * `nonReentrant` may not call one another. This can be worked around by making
456  * those functions `private`, and then adding `external` `nonReentrant` entry
457  * points to them.
458  *
459  * TIP: If you would like to learn more about reentrancy and alternative ways
460  * to protect against it, check out our blog post
461  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
462  */
463 abstract contract ReentrancyGuard {
464     // Booleans are more expensive than uint256 or any type that takes up a full
465     // word because each write operation emits an extra SLOAD to first read the
466     // slot's contents, replace the bits taken up by the boolean, and then write
467     // back. This is the compiler's defense against contract upgrades and
468     // pointer aliasing, and it cannot be disabled.
469 
470     // The values being non-zero value makes deployment a bit more expensive,
471     // but in exchange the refund on every call to nonReentrant will be lower in
472     // amount. Since refunds are capped to a percentage of the total
473     // transaction's gas, it is best to keep them low in cases like this one, to
474     // increase the likelihood of the full refund coming into effect.
475     uint256 private constant _NOT_ENTERED = 1;
476     uint256 private constant _ENTERED = 2;
477 
478     uint256 private _status;
479 
480     constructor() {
481         _status = _NOT_ENTERED;
482     }
483 
484     /**
485      * @dev Prevents a contract from calling itself, directly or indirectly.
486      * Calling a `nonReentrant` function from another `nonReentrant`
487      * function is not supported. It is possible to prevent this from happening
488      * by making the `nonReentrant` function external, and making it call a
489      * `private` function that does the actual work.
490      */
491     modifier nonReentrant() {
492         // On the first call to nonReentrant, _notEntered will be true
493         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
494 
495         // Any calls to nonReentrant after this point will fail
496         _status = _ENTERED;
497 
498         _;
499 
500         // By storing the original value once again, a refund is triggered (see
501         // https://eips.ethereum.org/EIPS/eip-2200)
502         _status = _NOT_ENTERED;
503     }
504 }
505 
506 interface IUniswapV2Router01 {
507     function factory() external pure returns (address);
508 
509     function WETH() external pure returns (address);
510 
511     function addLiquidity(
512         address tokenA,
513         address tokenB,
514         uint256 amountADesired,
515         uint256 amountBDesired,
516         uint256 amountAMin,
517         uint256 amountBMin,
518         address to,
519         uint256 deadline
520     )
521         external
522         returns (
523             uint256 amountA,
524             uint256 amountB,
525             uint256 liquidity
526         );
527 
528     function addLiquidityETH(
529         address token,
530         uint256 amountTokenDesired,
531         uint256 amountTokenMin,
532         uint256 amountETHMin,
533         address to,
534         uint256 deadline
535     )
536         external
537         payable
538         returns (
539             uint256 amountToken,
540             uint256 amountETH,
541             uint256 liquidity
542         );
543 
544     function removeLiquidity(
545         address tokenA,
546         address tokenB,
547         uint256 liquidity,
548         uint256 amountAMin,
549         uint256 amountBMin,
550         address to,
551         uint256 deadline
552     ) external returns (uint256 amountA, uint256 amountB);
553 
554     function removeLiquidityETH(
555         address token,
556         uint256 liquidity,
557         uint256 amountTokenMin,
558         uint256 amountETHMin,
559         address to,
560         uint256 deadline
561     ) external returns (uint256 amountToken, uint256 amountETH);
562 
563     function removeLiquidityWithPermit(
564         address tokenA,
565         address tokenB,
566         uint256 liquidity,
567         uint256 amountAMin,
568         uint256 amountBMin,
569         address to,
570         uint256 deadline,
571         bool approveMax,
572         uint8 v,
573         bytes32 r,
574         bytes32 s
575     ) external returns (uint256 amountA, uint256 amountB);
576 
577     function removeLiquidityETHWithPermit(
578         address token,
579         uint256 liquidity,
580         uint256 amountTokenMin,
581         uint256 amountETHMin,
582         address to,
583         uint256 deadline,
584         bool approveMax,
585         uint8 v,
586         bytes32 r,
587         bytes32 s
588     ) external returns (uint256 amountToken, uint256 amountETH);
589 
590     function swapExactTokensForTokens(
591         uint256 amountIn,
592         uint256 amountOutMin,
593         address[] calldata path,
594         address to,
595         uint256 deadline
596     ) external returns (uint256[] memory amounts);
597 
598     function swapTokensForExactTokens(
599         uint256 amountOut,
600         uint256 amountInMax,
601         address[] calldata path,
602         address to,
603         uint256 deadline
604     ) external returns (uint256[] memory amounts);
605 
606     function swapExactETHForTokens(
607         uint256 amountOutMin,
608         address[] calldata path,
609         address to,
610         uint256 deadline
611     ) external payable returns (uint256[] memory amounts);
612 
613     function swapTokensForExactETH(
614         uint256 amountOut,
615         uint256 amountInMax,
616         address[] calldata path,
617         address to,
618         uint256 deadline
619     ) external returns (uint256[] memory amounts);
620 
621     function swapExactTokensForETH(
622         uint256 amountIn,
623         uint256 amountOutMin,
624         address[] calldata path,
625         address to,
626         uint256 deadline
627     ) external returns (uint256[] memory amounts);
628 
629     function swapETHForExactTokens(
630         uint256 amountOut,
631         address[] calldata path,
632         address to,
633         uint256 deadline
634     ) external payable returns (uint256[] memory amounts);
635 
636     function quote(
637         uint256 amountA,
638         uint256 reserveA,
639         uint256 reserveB
640     ) external pure returns (uint256 amountB);
641 
642     function getAmountOut(
643         uint256 amountIn,
644         uint256 reserveIn,
645         uint256 reserveOut
646     ) external pure returns (uint256 amountOut);
647 
648     function getAmountIn(
649         uint256 amountOut,
650         uint256 reserveIn,
651         uint256 reserveOut
652     ) external pure returns (uint256 amountIn);
653 
654     function getAmountsOut(uint256 amountIn, address[] calldata path)
655         external
656         view
657         returns (uint256[] memory amounts);
658 
659     function getAmountsIn(uint256 amountOut, address[] calldata path)
660         external
661         view
662         returns (uint256[] memory amounts);
663 }
664 
665 interface IUniswapV2Router02 is IUniswapV2Router01 {
666     function removeLiquidityETHSupportingFeeOnTransferTokens(
667         address token,
668         uint256 liquidity,
669         uint256 amountTokenMin,
670         uint256 amountETHMin,
671         address to,
672         uint256 deadline
673     ) external returns (uint256 amountETH);
674 
675     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
676         address token,
677         uint256 liquidity,
678         uint256 amountTokenMin,
679         uint256 amountETHMin,
680         address to,
681         uint256 deadline,
682         bool approveMax,
683         uint8 v,
684         bytes32 r,
685         bytes32 s
686     ) external returns (uint256 amountETH);
687 
688     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
689         uint256 amountIn,
690         uint256 amountOutMin,
691         address[] calldata path,
692         address to,
693         uint256 deadline
694     ) external;
695 
696     function swapExactETHForTokensSupportingFeeOnTransferTokens(
697         uint256 amountOutMin,
698         address[] calldata path,
699         address to,
700         uint256 deadline
701     ) external payable;
702 
703     function swapExactTokensForETHSupportingFeeOnTransferTokens(
704         uint256 amountIn,
705         uint256 amountOutMin,
706         address[] calldata path,
707         address to,
708         uint256 deadline
709     ) external;
710 }
711 
712 contract TIA is Context, IERC20, Ownable, ReentrancyGuard {
713     using SafeMath for uint256;
714     using Address for address;
715 
716     struct Fees {
717         uint256 reflectFee;
718         uint256 rebalanceFee;
719         uint256 burnFee;
720     }
721 
722     address private TiamondsAddress;
723     address private immutable LCX; 
724 
725     IUniswapV2Router02 public immutable UniswapV2Router;
726     // IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
727 
728     mapping(address => uint256) private _rOwned;
729     mapping(address => uint256) private _tOwned;
730     mapping(address => mapping(address => uint256)) private _allowances;
731     mapping(address => bool) private _isExcludedFromFee;
732     mapping(address => bool) private _isExcluded;
733     address[] private _excluded;
734 
735     address private constant deadWallet = 0x000000000000000000000000000000000000dEaD;
736 
737     uint256 private constant MAX = ~uint256(0);
738     uint256 private constant _tTotal = 1.01e18;
739     uint256 private _rTotal = (MAX - (MAX % _tTotal));
740     uint256 private _tFeeTotal;
741 
742     string private constant _name = "Tia Token";
743     string private constant _symbol = "TIA";
744     uint8 private constant _decimals = 9;
745 
746     uint256 private _reflectionFee = 50;
747     uint256 private _rebalancingFee = 25;
748     uint256 private _burningFee = 25;
749 
750     event RebalanceAndBurn(uint256, uint256, uint256);
751     event SetTiamondsAddress(address);
752     event ApproveTiamondsAddress(address, address, uint256);
753     event ExcludeAccount(address);
754     event IncludeAccount(address);
755     event ChangeReflectionFee(uint256);
756     event ChangeReBalancingFee(uint256);
757     event ChangeBurnFee(uint256);
758     event ExcludeFromFee(address);
759     event IncludeInFee(address);
760 
761     constructor(address _lcxAddress, address _uniswapV2Address) {
762         require(_lcxAddress != address(0), "Address should not be zero address");
763         require(_uniswapV2Address != address(0), "Address should not be zero address");
764         LCX = _lcxAddress;
765         UniswapV2Router = IUniswapV2Router02(_uniswapV2Address);
766         _rOwned[owner()] = _rTotal;
767         _isExcludedFromFee[owner()] = true;
768         _isExcludedFromFee[address(this)] = true;
769         _isExcludedFromFee[_uniswapV2Address] = true;
770         emit Transfer(address(0), owner(), _tTotal);
771     }
772 
773     function name() external pure returns (string memory) {
774         return _name;
775     }
776 
777     function symbol() external pure returns (string memory) {
778         return _symbol;
779     }
780 
781     function decimals() external pure returns (uint8) {
782         return _decimals;
783     }
784 
785     function totalSupply() external pure override returns (uint256) {
786         return _tTotal;
787     }
788 
789     function balanceOf(address account) public view override returns (uint256) {
790         if (_isExcluded[account]) return _tOwned[account];
791         return tokenFromReflection(_rOwned[account]);
792     }
793 
794     function transfer(address recipient, uint256 amount)
795         external
796         override
797         returns (bool)
798     {   
799         _transfer(_msgSender(), recipient, amount);
800         return true;
801     }
802 
803     function allowance(address owner, address spender)
804         external
805         view
806         override
807         returns (uint256)
808     {
809         return _allowances[owner][spender];
810     }
811 
812     function approve(address spender, uint256 amount)
813         external
814         override
815         returns (bool)
816     {
817         _approve(_msgSender(), spender, amount);
818         return true;
819     }
820 
821     function setTiamondsAddress(address _tiamonds) external onlyOwner {
822         require(_tiamonds != address(0), "Address should not be zero address");
823         TiamondsAddress = address(_tiamonds);
824         emit SetTiamondsAddress(_tiamonds);
825     }
826 
827     function approveTiamondSC() external onlyOwner returns (bool) {
828         _approve(msg.sender, TiamondsAddress, _tTotal);
829         emit ApproveTiamondsAddress(msg.sender, TiamondsAddress, _tTotal);
830         return true;
831     }
832 
833     function transferFrom(
834         address sender,
835         address recipient,
836         uint256 amount
837     ) external override returns (bool) {
838         _transfer(sender, recipient, amount);
839         _approve(
840             sender,
841             _msgSender(),
842             _allowances[sender][_msgSender()].sub(
843                 amount,
844                 "ERC20: transfer amount exceeds allowance"
845             )
846         );
847         return true;
848     }
849 
850     function increaseAllowance(address spender, uint256 addedValue)
851         external
852         virtual
853         returns (bool)
854     {
855         _approve(
856             _msgSender(),
857             spender,
858             _allowances[_msgSender()][spender].add(addedValue)
859         );
860         return true;
861     }
862 
863     function decreaseAllowance(address spender, uint256 subtractedValue)
864         external
865         virtual
866         returns (bool)
867     {
868         _approve(
869             _msgSender(),
870             spender,
871             _allowances[_msgSender()][spender].sub(
872                 subtractedValue,
873                 "ERC20: decreased allowance below zero"
874             )
875         );
876         return true;
877     }
878 
879     function isExcluded(address account) external view returns (bool) {
880         return _isExcluded[account];
881     }
882 
883     function totalFees() external view returns (uint256) {
884         return _tFeeTotal;
885     }
886 
887     function reflect(uint256 tAmount) external {
888         address sender = _msgSender();
889         require(
890             !_isExcluded[sender],
891             "Excluded addresses cannot call this function"
892         );
893         (uint256 rAmount, , , , ) = _getValues(tAmount);
894         _rOwned[sender] = _rOwned[sender].sub(rAmount);
895         _rTotal = _rTotal.sub(rAmount);
896         _tFeeTotal = _tFeeTotal.add(tAmount);
897     }
898 
899     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
900         external
901         view
902         returns (uint256)
903     {
904         require(tAmount <= _tTotal, "Amount must be less than supply");
905         if (!deductTransferFee) {
906             (uint256 rAmount, , , , ) = _getValues(tAmount);
907             return rAmount;
908         } else {
909             (, uint256 rTransferAmount, , , ) = _getValues(tAmount);
910             return rTransferAmount;
911         }
912     }
913 
914     function tokenFromReflection(uint256 rAmount)
915         public
916         view
917         returns (uint256)
918     {
919         require(
920             rAmount <= _rTotal,
921             "Amount must be less than total reflections"
922         );
923         uint256 currentRate = _getRate();
924         return rAmount.div(currentRate);
925     }
926 
927     function excludeAccount(address account) external onlyOwner {
928         require(!_isExcluded[account], "Account is already excluded");
929         if (_rOwned[account] > 0) {
930             _tOwned[account] = tokenFromReflection(_rOwned[account]);
931         }
932         _isExcluded[account] = true;
933         _excluded.push(account);
934         emit ExcludeAccount(account);
935     }
936 
937     function includeAccount(address account) external onlyOwner {
938         require(_isExcluded[account], "Account is not excluded");
939         for (uint256 i = 0; i < _excluded.length; i++) {
940             if (_excluded[i] == account) {
941                 _excluded[i] = _excluded[_excluded.length - 1];
942                 _tOwned[account] = 0;
943                 _isExcluded[account] = false;
944                 _excluded.pop();
945                 break;
946             }
947         }
948         emit IncludeAccount(account);
949     }
950 
951     function _approve(
952         address owner,
953         address spender,
954         uint256 amount
955     ) private {
956         require(owner != address(0), "ERC20: approve from the zero address");
957         require(spender != address(0), "ERC20: approve to the zero address");
958 
959         _allowances[owner][spender] = amount;
960         emit Approval(owner, spender, amount);
961     }
962 
963     function _transfer(
964         address sender,
965         address recipient,
966         uint256 amount
967     ) private {
968         require(sender != address(0), "ERC20: transfer from the zero address");
969         require(recipient != address(0), "ERC20: transfer to the zero address");
970         require(amount > 0, "Transfer amount must be greater than zero");
971         uint256 currentReflectionFee = _reflectionFee;
972         uint256 currentRebalancingFee = _rebalancingFee;
973         uint256 currentBurningFee = _burningFee;
974         if (_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) {
975             _reflectionFee = 0;
976             _rebalancingFee = 0;
977             _burningFee = 0;
978         }
979 
980         if (_isExcluded[sender] && !_isExcluded[recipient]) {
981             _transferFromExcluded(sender, recipient, amount);
982         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
983             _transferToExcluded(sender, recipient, amount);
984         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
985             _transferBothExcluded(sender, recipient, amount);
986         } else {
987             _transferStandard(sender, recipient, amount);
988         }
989 
990         if (_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) {
991             _reflectionFee = currentReflectionFee;
992             _rebalancingFee = currentRebalancingFee;
993             _burningFee = currentBurningFee;
994         }
995     }
996 
997     function _transferStandard(
998         address sender,
999         address recipient,
1000         uint256 tAmount
1001     ) private {
1002         (
1003             uint256 rAmount,
1004             uint256 rTransferAmount,
1005             Fees memory rFees,
1006             uint256 tTransferAmount,
1007             Fees memory tFees
1008         ) = _getValues(tAmount);
1009         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1010         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1011         _reflectFee(rFees.reflectFee, tFees.reflectFee);
1012         _reBalanceFee(rFees.rebalanceFee, tFees.rebalanceFee);
1013         _burnFee(rFees.burnFee, tFees.burnFee);
1014         emit Transfer(sender, recipient, tTransferAmount);
1015     }
1016 
1017     function _transferToExcluded(
1018         address sender,
1019         address recipient,
1020         uint256 tAmount
1021     ) private {
1022         (
1023             uint256 rAmount,
1024             uint256 rTransferAmount,
1025             Fees memory rFees,
1026             uint256 tTransferAmount,
1027             Fees memory tFees
1028         ) = _getValues(tAmount);
1029         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1030         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1031         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1032         _reflectFee(rFees.reflectFee, tFees.reflectFee);
1033         _reBalanceFee(rFees.rebalanceFee, tFees.rebalanceFee);
1034         _burnFee(rFees.burnFee, tFees.burnFee);
1035         emit Transfer(sender, recipient, tTransferAmount);
1036     }
1037 
1038     function _transferFromExcluded(
1039         address sender,
1040         address recipient,
1041         uint256 tAmount
1042     ) private {
1043         (
1044             uint256 rAmount,
1045             uint256 rTransferAmount,
1046             Fees memory rFees,
1047             uint256 tTransferAmount,
1048             Fees memory tFees
1049         ) = _getValues(tAmount);
1050         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1051         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1052         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1053         _reflectFee(rFees.reflectFee, tFees.reflectFee);
1054         _reBalanceFee(rFees.rebalanceFee, tFees.rebalanceFee);
1055         _burnFee(rFees.burnFee, tFees.burnFee);
1056         emit Transfer(sender, recipient, tTransferAmount);
1057     }
1058 
1059     function _transferBothExcluded(
1060         address sender,
1061         address recipient,
1062         uint256 tAmount
1063     ) private {
1064         (
1065             uint256 rAmount,
1066             uint256 rTransferAmount,
1067             Fees memory rFees,
1068             uint256 tTransferAmount,
1069             Fees memory tFees
1070         ) = _getValues(tAmount);
1071         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1072         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1073         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1074         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1075         _reflectFee(rFees.reflectFee, tFees.reflectFee);
1076         _reBalanceFee(rFees.rebalanceFee, tFees.rebalanceFee);
1077         _burnFee(rFees.burnFee, tFees.burnFee);
1078         emit Transfer(sender, recipient, tTransferAmount);
1079     }
1080 
1081     function _reflectFee(uint256 rReflectFee, uint256 tReflectFee) private {
1082         _rTotal = _rTotal.sub(rReflectFee);
1083         _tFeeTotal = _tFeeTotal.add(tReflectFee);
1084     }
1085 
1086     function _reBalanceFee(uint256 rRebalanceFee, uint256 tRebalanceFee)
1087         private
1088     {
1089         _rOwned[address(this)] = _rOwned[address(this)].add(rRebalanceFee);
1090         if (_isExcluded[address(this)])
1091             _tOwned[address(this)] = _tOwned[address(this)].add(tRebalanceFee);
1092     }
1093 
1094     function _burnFee(uint256 rBurnFee, uint256 tBurnFee) private {
1095         _rOwned[address(this)] = _rOwned[address(this)].add(rBurnFee);
1096         if (_isExcluded[address(this)])
1097             _tOwned[address(this)] = _tOwned[address(this)].add(tBurnFee);
1098     }
1099 
1100     function _getValues(uint256 tAmount)
1101         private
1102         view
1103         returns (
1104             uint256,
1105             uint256,
1106             Fees memory,
1107             uint256,
1108             Fees memory
1109         )
1110     {
1111         (uint256 tTransferAmount, Fees memory tFees) = _getTValues(tAmount);
1112         uint256 currentRate = _getRate();
1113         (
1114             uint256 rAmount,
1115             uint256 rTransferAmount,
1116             Fees memory rFees
1117         ) = _getRValues(tAmount, tFees, currentRate);
1118         return (rAmount, rTransferAmount, rFees, tTransferAmount, tFees);
1119     }
1120 
1121     function _getTValues(uint256 tAmount)
1122         private
1123         view
1124         returns (uint256, Fees memory)
1125     {
1126         Fees memory tFees;
1127         tFees.reflectFee = tAmount.mul(_reflectionFee).div(1000);
1128         tFees.rebalanceFee = tAmount.mul(_rebalancingFee).div(1000);
1129         tFees.burnFee = tAmount.mul(_burningFee).div(1000);
1130         uint256 tTransferAmount = tAmount
1131             .sub(tFees.reflectFee)
1132             .sub(tFees.rebalanceFee)
1133             .sub(tFees.burnFee);
1134         return (tTransferAmount, tFees);
1135     }
1136 
1137     function _getRValues(
1138         uint256 tAmount,
1139         Fees memory tFees,
1140         uint256 currentRate
1141     )
1142         private
1143         pure
1144         returns (
1145             uint256,
1146             uint256,
1147             Fees memory
1148         )
1149     {
1150         Fees memory rFees;
1151         uint256 rAmount = tAmount.mul(currentRate);
1152         rFees.reflectFee = tFees.reflectFee.mul(currentRate);
1153         rFees.rebalanceFee = tFees.rebalanceFee.mul(currentRate);
1154         rFees.burnFee = tFees.burnFee.mul(currentRate);
1155         uint256 rTransferAmount = rAmount
1156             .sub(rFees.reflectFee)
1157             .sub(rFees.rebalanceFee)
1158             .sub(rFees.burnFee);
1159         return (rAmount, rTransferAmount, rFees);
1160     }
1161 
1162     function _getRate() private view returns (uint256) {
1163         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1164         return rSupply.div(tSupply);
1165     }
1166 
1167     function _getCurrentSupply() private view returns (uint256, uint256) {
1168         uint256 rSupply = _rTotal;
1169         uint256 tSupply = _tTotal;
1170         for (uint256 i = 0; i < _excluded.length; i++) {
1171             if (
1172                 _rOwned[_excluded[i]] > rSupply ||
1173                 _tOwned[_excluded[i]] > tSupply
1174             ) return (_rTotal, _tTotal);
1175             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1176             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1177         }
1178         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1179         return (rSupply, tSupply);
1180     }
1181 
1182     function reflectionFee() external view returns (uint256) {
1183         return _reflectionFee;
1184     }
1185 
1186     function changeReflectionFee(uint256 _newFee)
1187         external
1188         onlyOwner
1189         returns (bool)
1190     {
1191         _reflectionFee = _newFee;
1192         emit ChangeReflectionFee(_newFee);
1193         return true;
1194     }
1195 
1196     function rebalancingFee() external view returns (uint256) {
1197         return _rebalancingFee;
1198     }
1199 
1200     function changeReBalancingFee(uint256 _newFee)
1201         external
1202         onlyOwner
1203         returns (bool)
1204     {
1205         _rebalancingFee = _newFee;
1206         emit ChangeReBalancingFee(_newFee);
1207         return true;
1208     }
1209 
1210     function burningFee() external view returns (uint256) {
1211         return _burningFee;
1212     }
1213 
1214     function changeBurnFee(uint256 _newFee) external onlyOwner returns (bool) {
1215         _burningFee = _newFee;
1216         emit ChangeBurnFee(_newFee);
1217         return true;
1218     }
1219 
1220     function excludeFromFee(address account) external onlyOwner returns (bool) {
1221         require(account != address(0), "ERC20: account is the zero address");
1222         _isExcludedFromFee[account] = true;
1223         emit ExcludeFromFee(account);
1224         return true;
1225     }
1226 
1227     function includeInFee(address account) external onlyOwner returns (bool) {
1228         require(account != address(0), "ERC20: account is the zero address");
1229         _isExcludedFromFee[account] = false;
1230         emit IncludeInFee(account);
1231         return true;
1232     }
1233 
1234     function rebalanceAndBurn() external nonReentrant returns (bool) {
1235         uint256 balanceInContract = balanceOf(address(this));
1236         uint256 rebalanceAmount = balanceInContract.mul(
1237             _rebalancingFee).div(_rebalancingFee.add(_burningFee));
1238         uint256 burnAmount = balanceInContract.mul(
1239             _burningFee).div(_rebalancingFee.add(_burningFee));
1240         emit RebalanceAndBurn(balanceInContract, rebalanceAmount, burnAmount);
1241         _swap(rebalanceAmount);
1242         _burn(burnAmount);
1243         return true;
1244     }
1245 
1246     function _swap(uint256 rebalanceAmount) internal {
1247         address[] memory path = new address[](2);
1248         path[0] = address(this);
1249         path[1] = LCX;
1250         _approve(address(this), address(UniswapV2Router), rebalanceAmount);
1251         UniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1252             rebalanceAmount,
1253             0, // Accept any amount
1254             path,
1255             owner(),
1256             block.timestamp
1257         );
1258     }
1259 
1260     function _burn(uint256 burnAmount) internal {
1261         _transfer(address(this), deadWallet, burnAmount);
1262         emit Transfer(address(this), deadWallet, burnAmount);
1263     }
1264 }