1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.6.12;
3 
4 // Polkadoge $pdoge
5 
6 interface Token {
7     function transferFrom(address, address, uint) external returns (bool);
8     function transfer(address, uint) external returns (bool);
9 }
10 
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount)
27         external
28         returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender)
38         external
39         view
40         returns (uint256);
41 
42     /**
43      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * IMPORTANT: Beware that changing an allowance with this method brings the risk
48      * that someone may use both the old and the new allowance by unfortunate
49      * transaction ordering. One possible solution to mitigate this race
50      * condition is to first reduce the spender's allowance to 0 and set the
51      * desired value afterwards:
52      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
53      *
54      * Emits an {Approval} event.
55      */
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Moves `amount` tokens from `sender` to `recipient` using the
60      * allowance mechanism. `amount` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(
68         address sender,
69         address recipient,
70         uint256 amount
71     ) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to {approve}. `value` is the new allowance.
84      */
85     event Approval(
86         address indexed owner,
87         address indexed spender,
88         uint256 value
89     );
90 }
91 
92 /**
93  * @dev Wrappers over Solidity's arithmetic operations with added overflow
94  * checks.
95  *
96  * Arithmetic operations in Solidity wrap on overflow. This can easily result
97  * in bugs, because programmers usually assume that an overflow raises an
98  * error, which is the standard behavior in high level programming languages.
99  * `SafeMath` restores this intuition by reverting the transaction when an
100  * operation overflows.
101  *
102  * Using this library instead of the unchecked operations eliminates an entire
103  * class of bugs, so it's recommended to use it always.
104  */
105 
106 library SafeMath {
107     /**
108      * @dev Returns the addition of two unsigned integers, reverting on
109      * overflow.
110      *
111      * Counterpart to Solidity's `+` operator.
112      *
113      * Requirements:
114      *
115      * - Addition cannot overflow.
116      */
117     function add(uint256 a, uint256 b) internal pure returns (uint256) {
118         uint256 c = a + b;
119         require(c >= a, "SafeMath: addition overflow");
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the subtraction of two unsigned integers, reverting on
126      * overflow (when the result is negative).
127      *
128      * Counterpart to Solidity's `-` operator.
129      *
130      * Requirements:
131      *
132      * - Subtraction cannot overflow.
133      */
134     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
135         return sub(a, b, "SafeMath: subtraction overflow");
136     }
137 
138     /**
139      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
140      * overflow (when the result is negative).
141      *
142      * Counterpart to Solidity's `-` operator.
143      *
144      * Requirements:
145      *
146      * - Subtraction cannot overflow.
147      */
148     function sub(
149         uint256 a,
150         uint256 b,
151         string memory errorMessage
152     ) internal pure returns (uint256) {
153         require(b <= a, errorMessage);
154         uint256 c = a - b;
155 
156         return c;
157     }
158 
159     /**
160      * @dev Returns the multiplication of two unsigned integers, reverting on
161      * overflow.
162      *
163      * Counterpart to Solidity's `*` operator.
164      *
165      * Requirements:
166      *
167      * - Multiplication cannot overflow.
168      */
169     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
170         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
171         // benefit is lost if 'b' is also tested.
172         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
173         if (a == 0) {
174             return 0;
175         }
176 
177         uint256 c = a * b;
178         require(c / a == b, "SafeMath: multiplication overflow");
179 
180         return c;
181     }
182 
183     /**
184      * @dev Returns the integer division of two unsigned integers. Reverts on
185      * division by zero. The result is rounded towards zero.
186      *
187      * Counterpart to Solidity's `/` operator. Note: this function uses a
188      * `revert` opcode (which leaves remaining gas untouched) while Solidity
189      * uses an invalid opcode to revert (consuming all remaining gas).
190      *
191      * Requirements:
192      *
193      * - The divisor cannot be zero.
194      */
195     function div(uint256 a, uint256 b) internal pure returns (uint256) {
196         return div(a, b, "SafeMath: division by zero");
197     }
198 
199     /**
200      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
201      * division by zero. The result is rounded towards zero.
202      *
203      * Counterpart to Solidity's `/` operator. Note: this function uses a
204      * `revert` opcode (which leaves remaining gas untouched) while Solidity
205      * uses an invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      *
209      * - The divisor cannot be zero.
210      */
211     function div(
212         uint256 a,
213         uint256 b,
214         string memory errorMessage
215     ) internal pure returns (uint256) {
216         require(b > 0, errorMessage);
217         uint256 c = a / b;
218         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
219 
220         return c;
221     }
222 
223     /**
224      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
225      * Reverts when dividing by zero.
226      *
227      * Counterpart to Solidity's `%` operator. This function uses a `revert`
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
236         return mod(a, b, "SafeMath: modulo by zero");
237     }
238 
239     /**
240      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
241      * Reverts with custom message when dividing by zero.
242      *
243      * Counterpart to Solidity's `%` operator. This function uses a `revert`
244      * opcode (which leaves remaining gas untouched) while Solidity uses an
245      * invalid opcode to revert (consuming all remaining gas).
246      *
247      * Requirements:
248      *
249      * - The divisor cannot be zero.
250      */
251     function mod(
252         uint256 a,
253         uint256 b,
254         string memory errorMessage
255     ) internal pure returns (uint256) {
256         require(b != 0, errorMessage);
257         return a % b;
258     }
259 }
260 
261 abstract contract Context {
262     function _msgSender() internal view virtual returns (address payable) {
263         return msg.sender;
264     }
265 
266     function _msgData() internal view virtual returns (bytes memory) {
267         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
268         return msg.data;
269     }
270 }
271 
272 /**
273  * @dev Collection of functions related to the address type
274  */
275 library Address {
276     /**
277      * @dev Returns true if `account` is a contract.
278      *
279      * [IMPORTANT]
280      * ====
281      * It is unsafe to assume that an address for which this function returns
282      * false is an externally-owned account (EOA) and not a contract.
283      *
284      * Among others, `isContract` will return false for the following
285      * types of addresses:
286      *
287      *  - an externally-owned account
288      *  - a contract in construction
289      *  - an address where a contract will be created
290      *  - an address where a contract lived, but was destroyed
291      * ====
292      */
293     function isContract(address account) internal view returns (bool) {
294         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
295         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
296         // for accounts without code, i.e. `keccak256('')`
297         bytes32 codehash;
298         bytes32 accountHash =
299             0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
300         // solhint-disable-next-line no-inline-assembly
301         assembly {
302             codehash := extcodehash(account)
303         }
304         return (codehash != accountHash && codehash != 0x0);
305     }
306 
307     /**
308      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
309      * `recipient`, forwarding all available gas and reverting on errors.
310      *
311      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
312      * of certain opcodes, possibly making contracts go over the 2300 gas limit
313      * imposed by `transfer`, making them unable to receive funds via
314      * `transfer`. {sendValue} removes this limitation.
315      *
316      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
317      *
318      * IMPORTANT: because control is transferred to `recipient`, care must be
319      * taken to not create reentrancy vulnerabilities. Consider using
320      * {ReentrancyGuard} or the
321      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
322      */
323     function sendValue(address payable recipient, uint256 amount) internal {
324         require(
325             address(this).balance >= amount,
326             "Address: insufficient balance"
327         );
328 
329         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
330         (bool success, ) = recipient.call{value: amount}("");
331         require(
332             success,
333             "Address: unable to send value, recipient may have reverted"
334         );
335     }
336 
337     /**
338      * @dev Performs a Solidity function call using a low level `call`. A
339      * plain`call` is an unsafe replacement for a function call: use this
340      * function instead.
341      *
342      * If `target` reverts with a revert reason, it is bubbled up by this
343      * function (like regular Solidity function calls).
344      *
345      * Returns the raw returned data. To convert to the expected return value,
346      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
347      *
348      * Requirements:
349      *
350      * - `target` must be a contract.
351      * - calling `target` with `data` must not revert.
352      *
353      * _Available since v3.1._
354      */
355     function functionCall(address target, bytes memory data)
356         internal
357         returns (bytes memory)
358     {
359         return functionCall(target, data, "Address: low-level call failed");
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
364      * `errorMessage` as a fallback revert reason when `target` reverts.
365      *
366      * _Available since v3.1._
367      */
368     function functionCall(
369         address target,
370         bytes memory data,
371         string memory errorMessage
372     ) internal returns (bytes memory) {
373         return _functionCallWithValue(target, data, 0, errorMessage);
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
378      * but also transferring `value` wei to `target`.
379      *
380      * Requirements:
381      *
382      * - the calling contract must have an ETH balance of at least `value`.
383      * - the called Solidity function must be `payable`.
384      *
385      * _Available since v3.1._
386      */
387     function functionCallWithValue(
388         address target,
389         bytes memory data,
390         uint256 value
391     ) internal returns (bytes memory) {
392         return
393             functionCallWithValue(
394                 target,
395                 data,
396                 value,
397                 "Address: low-level call with value failed"
398             );
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
403      * with `errorMessage` as a fallback revert reason when `target` reverts.
404      *
405      * _Available since v3.1._
406      */
407     function functionCallWithValue(
408         address target,
409         bytes memory data,
410         uint256 value,
411         string memory errorMessage
412     ) internal returns (bytes memory) {
413         require(
414             address(this).balance >= value,
415             "Address: insufficient balance for call"
416         );
417         return _functionCallWithValue(target, data, value, errorMessage);
418     }
419 
420     function _functionCallWithValue(
421         address target,
422         bytes memory data,
423         uint256 weiValue,
424         string memory errorMessage
425     ) private returns (bytes memory) {
426         require(isContract(target), "Address: call to non-contract");
427 
428         // solhint-disable-next-line avoid-low-level-calls
429         (bool success, bytes memory returndata) =
430             target.call{value: weiValue}(data);
431         if (success) {
432             return returndata;
433         } else {
434             // Look for revert reason and bubble it up if present
435             if (returndata.length > 0) {
436                 // The easiest way to bubble the revert reason is using memory via assembly
437 
438                 // solhint-disable-next-line no-inline-assembly
439                 assembly {
440                     let returndata_size := mload(returndata)
441                     revert(add(32, returndata), returndata_size)
442                 }
443             } else {
444                 revert(errorMessage);
445             }
446         }
447     }
448 }
449 
450 /**
451  * @dev Contract module which provides a basic access control mechanism, where
452  * there is an account (an owner) that can be granted exclusive access to
453  * specific functions.
454  *
455  * By default, the owner account will be the one that deploys the contract. This
456  * can later be changed with {transferOwnership}.
457  *
458  * This module is used through inheritance. It will make available the modifier
459  * `onlyOwner`, which can be applied to your functions to restrict their use to
460  * the owner.
461  */
462 contract Ownable is Context {
463     address private _owner;
464     address private _previousOwner;
465     uint256 private _lockTime;
466 
467     event OwnershipTransferred(
468         address indexed previousOwner,
469         address indexed newOwner
470     );
471 
472     /**
473      * @dev Initializes the contract setting the deployer as the initial owner.
474      */
475     constructor() internal {
476         address msgSender = _msgSender();
477         _owner = msgSender;
478         emit OwnershipTransferred(address(0), msgSender);
479     }
480 
481     /**
482      * @dev Returns the address of the current owner.
483      */
484     function owner() public view returns (address) {
485         return _owner;
486     }
487 
488     /**
489      * @dev Throws if called by any account other than the owner.
490      */
491     modifier onlyOwner() {
492         require(_owner == _msgSender(), "Ownable: caller is not the owner");
493         _;
494     }
495 
496     /**
497      * @dev Leaves the contract without owner. It will not be possible to call
498      * `onlyOwner` functions anymore. Can only be called by the current owner.
499      *
500      * NOTE: Renouncing ownership will leave the contract without an owner,
501      * thereby removing any functionality that is only available to the owner.
502      */
503     function renounceOwnership() public virtual onlyOwner {
504         emit OwnershipTransferred(_owner, address(0));
505         _owner = address(0);
506     }
507 
508     /**
509      * @dev Transfers ownership of the contract to a new account (`newOwner`).
510      * Can only be called by the current owner.
511      */
512     function transferOwnership(address newOwner) public virtual onlyOwner {
513         require(
514             newOwner != address(0),
515             "Ownable: new owner is the zero address"
516         );
517         emit OwnershipTransferred(_owner, newOwner);
518         _owner = newOwner;
519     }
520 
521     function geUnlockTime() public view returns (uint256) {
522         return _lockTime;
523     }
524 }
525 
526 interface IUniswapV2Factory {
527     event PairCreated(
528         address indexed token0,
529         address indexed token1,
530         address pair,
531         uint256
532     );
533 
534     function feeTo() external view returns (address);
535 
536     function feeToSetter() external view returns (address);
537 
538     function getPair(address tokenA, address tokenB)
539         external
540         view
541         returns (address pair);
542 
543     function allPairs(uint256) external view returns (address pair);
544 
545     function allPairsLength() external view returns (uint256);
546 
547     function createPair(address tokenA, address tokenB)
548         external
549         returns (address pair);
550 
551     function setFeeTo(address) external;
552 
553     function setFeeToSetter(address) external;
554 }
555 
556 interface IUniswapV2Pair {
557     event Approval(
558         address indexed owner,
559         address indexed spender,
560         uint256 value
561     );
562     event Transfer(address indexed from, address indexed to, uint256 value);
563 
564     function name() external pure returns (string memory);
565 
566     function symbol() external pure returns (string memory);
567 
568     function decimals() external pure returns (uint8);
569 
570     function totalSupply() external view returns (uint256);
571 
572     function balanceOf(address owner) external view returns (uint256);
573 
574     function allowance(address owner, address spender)
575         external
576         view
577         returns (uint256);
578 
579     function approve(address spender, uint256 value) external returns (bool);
580 
581     function transfer(address to, uint256 value) external returns (bool);
582 
583     function transferFrom(
584         address from,
585         address to,
586         uint256 value
587     ) external returns (bool);
588 
589     function DOMAIN_SEPARATOR() external view returns (bytes32);
590 
591     function PERMIT_TYPEHASH() external pure returns (bytes32);
592 
593     function nonces(address owner) external view returns (uint256);
594 
595     function permit(
596         address owner,
597         address spender,
598         uint256 value,
599         uint256 deadline,
600         uint8 v,
601         bytes32 r,
602         bytes32 s
603     ) external;
604 
605     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
606     event Burn(
607         address indexed sender,
608         uint256 amount0,
609         uint256 amount1,
610         address indexed to
611     );
612     event Swap(
613         address indexed sender,
614         uint256 amount0In,
615         uint256 amount1In,
616         uint256 amount0Out,
617         uint256 amount1Out,
618         address indexed to
619     );
620     event Sync(uint112 reserve0, uint112 reserve1);
621 
622     function MINIMUM_LIQUIDITY() external pure returns (uint256);
623 
624     function factory() external view returns (address);
625 
626     function token0() external view returns (address);
627 
628     function token1() external view returns (address);
629 
630     function getReserves()
631         external
632         view
633         returns (
634             uint112 reserve0,
635             uint112 reserve1,
636             uint32 blockTimestampLast
637         );
638 
639     function price0CumulativeLast() external view returns (uint256);
640 
641     function price1CumulativeLast() external view returns (uint256);
642 
643     function kLast() external view returns (uint256);
644 
645     function mint(address to) external returns (uint256 liquidity);
646 
647     function burn(address to)
648         external
649         returns (uint256 amount0, uint256 amount1);
650 
651     function swap(
652         uint256 amount0Out,
653         uint256 amount1Out,
654         address to,
655         bytes calldata data
656     ) external;
657 
658     function skim(address to) external;
659 
660     function sync() external;
661 
662     function initialize(address, address) external;
663 }
664 
665 // pragma solidity >=0.6.2;
666 
667 interface IUniswapV2Router01 {
668     function factory() external pure returns (address);
669 
670     function WETH() external pure returns (address);
671 
672     function addLiquidity(
673         address tokenA,
674         address tokenB,
675         uint256 amountADesired,
676         uint256 amountBDesired,
677         uint256 amountAMin,
678         uint256 amountBMin,
679         address to,
680         uint256 deadline
681     )
682         external
683         returns (
684             uint256 amountA,
685             uint256 amountB,
686             uint256 liquidity
687         );
688 
689     function addLiquidityETH(
690         address token,
691         uint256 amountTokenDesired,
692         uint256 amountTokenMin,
693         uint256 amountETHMin,
694         address to,
695         uint256 deadline
696     )
697         external
698         payable
699         returns (
700             uint256 amountToken,
701             uint256 amountETH,
702             uint256 liquidity
703         );
704 
705     function removeLiquidity(
706         address tokenA,
707         address tokenB,
708         uint256 liquidity,
709         uint256 amountAMin,
710         uint256 amountBMin,
711         address to,
712         uint256 deadline
713     ) external returns (uint256 amountA, uint256 amountB);
714 
715     function removeLiquidityETH(
716         address token,
717         uint256 liquidity,
718         uint256 amountTokenMin,
719         uint256 amountETHMin,
720         address to,
721         uint256 deadline
722     ) external returns (uint256 amountToken, uint256 amountETH);
723 
724     function removeLiquidityWithPermit(
725         address tokenA,
726         address tokenB,
727         uint256 liquidity,
728         uint256 amountAMin,
729         uint256 amountBMin,
730         address to,
731         uint256 deadline,
732         bool approveMax,
733         uint8 v,
734         bytes32 r,
735         bytes32 s
736     ) external returns (uint256 amountA, uint256 amountB);
737 
738     function removeLiquidityETHWithPermit(
739         address token,
740         uint256 liquidity,
741         uint256 amountTokenMin,
742         uint256 amountETHMin,
743         address to,
744         uint256 deadline,
745         bool approveMax,
746         uint8 v,
747         bytes32 r,
748         bytes32 s
749     ) external returns (uint256 amountToken, uint256 amountETH);
750 
751     function swapExactTokensForTokens(
752         uint256 amountIn,
753         uint256 amountOutMin,
754         address[] calldata path,
755         address to,
756         uint256 deadline
757     ) external returns (uint256[] memory amounts);
758 
759     function swapTokensForExactTokens(
760         uint256 amountOut,
761         uint256 amountInMax,
762         address[] calldata path,
763         address to,
764         uint256 deadline
765     ) external returns (uint256[] memory amounts);
766 
767     function swapExactETHForTokens(
768         uint256 amountOutMin,
769         address[] calldata path,
770         address to,
771         uint256 deadline
772     ) external payable returns (uint256[] memory amounts);
773 
774     function swapTokensForExactETH(
775         uint256 amountOut,
776         uint256 amountInMax,
777         address[] calldata path,
778         address to,
779         uint256 deadline
780     ) external returns (uint256[] memory amounts);
781 
782     function swapExactTokensForETH(
783         uint256 amountIn,
784         uint256 amountOutMin,
785         address[] calldata path,
786         address to,
787         uint256 deadline
788     ) external returns (uint256[] memory amounts);
789 
790     function swapETHForExactTokens(
791         uint256 amountOut,
792         address[] calldata path,
793         address to,
794         uint256 deadline
795     ) external payable returns (uint256[] memory amounts);
796 
797     function quote(
798         uint256 amountA,
799         uint256 reserveA,
800         uint256 reserveB
801     ) external pure returns (uint256 amountB);
802 
803     function getAmountOut(
804         uint256 amountIn,
805         uint256 reserveIn,
806         uint256 reserveOut
807     ) external pure returns (uint256 amountOut);
808 
809     function getAmountIn(
810         uint256 amountOut,
811         uint256 reserveIn,
812         uint256 reserveOut
813     ) external pure returns (uint256 amountIn);
814 
815     function getAmountsOut(uint256 amountIn, address[] calldata path)
816         external
817         view
818         returns (uint256[] memory amounts);
819 
820     function getAmountsIn(uint256 amountOut, address[] calldata path)
821         external
822         view
823         returns (uint256[] memory amounts);
824 }
825 
826 // pragma solidity >=0.6.2;
827 
828 interface IUniswapV2Router02 is IUniswapV2Router01 {
829     function removeLiquidityETHSupportingFeeOnTransferTokens(
830         address token,
831         uint256 liquidity,
832         uint256 amountTokenMin,
833         uint256 amountETHMin,
834         address to,
835         uint256 deadline
836     ) external returns (uint256 amountETH);
837 
838     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
839         address token,
840         uint256 liquidity,
841         uint256 amountTokenMin,
842         uint256 amountETHMin,
843         address to,
844         uint256 deadline,
845         bool approveMax,
846         uint8 v,
847         bytes32 r,
848         bytes32 s
849     ) external returns (uint256 amountETH);
850 
851     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
852         uint256 amountIn,
853         uint256 amountOutMin,
854         address[] calldata path,
855         address to,
856         uint256 deadline
857     ) external;
858 
859     function swapExactETHForTokensSupportingFeeOnTransferTokens(
860         uint256 amountOutMin,
861         address[] calldata path,
862         address to,
863         uint256 deadline
864     ) external payable;
865 
866     function swapExactTokensForETHSupportingFeeOnTransferTokens(
867         uint256 amountIn,
868         uint256 amountOutMin,
869         address[] calldata path,
870         address to,
871         uint256 deadline
872     ) external;
873 }
874 
875 contract PolkaDoge is Context, IERC20, Ownable {
876     using SafeMath for uint256;
877     using Address for address;
878 
879     mapping(address => uint256) private _rOwned;
880     mapping(address => uint256) private _tOwned;
881     mapping(address => mapping(address => uint256)) private _allowances;
882 
883     mapping(address => bool) private _isExcludedFromFee;
884 
885     mapping(address => bool) private _isExcluded;
886     address[] private _excluded;
887 
888     mapping(address => bool) public bannedUsers;
889 
890     uint256 private constant MAX = ~uint256(0);
891     uint256 private _tTotal = 1000000000 * 10**6 * 10**9;
892     uint256 private _rTotal = (MAX - (MAX % _tTotal));
893     uint256 private _tFeeTotal;
894 
895     string private _name = "PolkaDoge";
896     string private _symbol = "PDOGE";
897     uint8 private _decimals = 9;
898 
899     uint256 public _taxFee = 100;
900     uint256 private _previousTaxFee = _taxFee;
901 
902     uint256 public _liquidityFee = 300;
903     uint256 private _previousLiquidityFee = _liquidityFee;
904 
905     IUniswapV2Router02 public immutable uniswapV2Router;
906     address public immutable uniswapV2Pair;
907 
908     bool inSwapAndLiquify;
909     bool public swapAndLiquifyEnabled = false; // Disable by default
910 
911     uint256 public _maxTxAmount = 100000000 * 10**3 * 10**9;
912     uint256 private numTokensSellToAddToLiquidity = 1250000000 * 10**3 * 10**9;
913 
914     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
915     event SwapAndLiquifyEnabledUpdated(bool enabled);
916     event SwapAndLiquify(
917         uint256 tokensSwapped,
918         uint256 ethReceived,
919         uint256 tokensIntoLiqudity
920     );
921     event WalletBanStatusUpdated(address user, bool banned);
922 
923     modifier lockTheSwap {
924         inSwapAndLiquify = true;
925         _;
926         inSwapAndLiquify = false;
927     }
928 
929     constructor() public {
930         _rOwned[_msgSender()] = _rTotal;
931 
932         IUniswapV2Router02 _uniswapV2Router =
933        IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
934         // Create a Uniswappair for this new token
935         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
936             .createPair(address(this), _uniswapV2Router.WETH());
937 
938         // set the rest of the contract variables
939         uniswapV2Router = _uniswapV2Router;
940 
941         //exclude owner and this contract from fee
942         _isExcludedFromFee[owner()] = true;
943         _isExcludedFromFee[address(this)] = true;
944 
945         emit Transfer(address(0), _msgSender(), _tTotal);
946     }
947 
948     function name() public view returns (string memory) {
949         return _name;
950     }
951 
952     function symbol() public view returns (string memory) {
953         return _symbol;
954     }
955 
956     function decimals() public view returns (uint8) {
957         return _decimals;
958     }
959 
960     function totalSupply() public view override returns (uint256) {
961         return _tTotal;
962     }
963 
964     function balanceOf(address account) public view override returns (uint256) {
965         if (_isExcluded[account]) return _tOwned[account];
966         return tokenFromReflection(_rOwned[account]);
967     }
968 
969     function transfer(address recipient, uint256 amount)
970         public
971         override
972         returns (bool)
973     {
974         _transfer(_msgSender(), recipient, amount);
975         return true;
976     }
977 
978     function allowance(address owner, address spender)
979         public
980         view
981         override
982         returns (uint256)
983     {
984         return _allowances[owner][spender];
985     }
986 
987     function approve(address spender, uint256 amount)
988         public
989         override
990         returns (bool)
991     {
992         _approve(_msgSender(), spender, amount);
993         return true;
994     }
995 
996     function transferFrom(
997         address sender,
998         address recipient,
999         uint256 amount
1000     ) public override returns (bool) {
1001         _transfer(sender, recipient, amount);
1002         _approve(
1003             sender,
1004             _msgSender(),
1005             _allowances[sender][_msgSender()].sub(
1006                 amount,
1007                 "ERC20: transfer amount exceeds allowance"
1008             )
1009         );
1010         return true;
1011     }
1012 
1013     function increaseAllowance(address spender, uint256 addedValue)
1014         public
1015         virtual
1016         returns (bool)
1017     {
1018         _approve(
1019             _msgSender(),
1020             spender,
1021             _allowances[_msgSender()][spender].add(addedValue)
1022         );
1023         return true;
1024     }
1025 
1026     function decreaseAllowance(address spender, uint256 subtractedValue)
1027         public
1028         virtual
1029         returns (bool)
1030     {
1031         _approve(
1032             _msgSender(),
1033             spender,
1034             _allowances[_msgSender()][spender].sub(
1035                 subtractedValue,
1036                 "ERC20: decreased allowance below zero"
1037             )
1038         );
1039         return true;
1040     }
1041 
1042     function isExcludedFromReward(address account) public view returns (bool) {
1043         return _isExcluded[account];
1044     }
1045 
1046     function totalFees() public view returns (uint256) {
1047         return _tFeeTotal;
1048     }
1049 
1050     function deliver(uint256 tAmount) public {
1051         address sender = _msgSender();
1052         require(
1053             !_isExcluded[sender],
1054             "Excluded addresses cannot call this function"
1055         );
1056         (uint256 rAmount, , , , , ) = _getValues(tAmount);
1057         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1058         _rTotal = _rTotal.sub(rAmount);
1059         _tFeeTotal = _tFeeTotal.add(tAmount);
1060     }
1061 
1062     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
1063         public
1064         view
1065         returns (uint256)
1066     {
1067         require(tAmount <= _tTotal, "Amount must be less than supply");
1068         if (!deductTransferFee) {
1069             (uint256 rAmount, , , , , ) = _getValues(tAmount);
1070             return rAmount;
1071         } else {
1072             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
1073             return rTransferAmount;
1074         }
1075     }
1076 
1077     function tokenFromReflection(uint256 rAmount)
1078         public
1079         view
1080         returns (uint256)
1081     {
1082         require(
1083             rAmount <= _rTotal,
1084             "Amount must be less than total reflections"
1085         );
1086         uint256 currentRate = _getRate();
1087         return rAmount.div(currentRate);
1088     }
1089 
1090     function excludeFromReward(address account) public onlyOwner() {
1091         require(!_isExcluded[account], "Account is already excluded");
1092         if (_rOwned[account] > 0) {
1093             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1094         }
1095         _isExcluded[account] = true;
1096         _excluded.push(account);
1097     }
1098 
1099     function includeInReward(address account) external onlyOwner() {
1100         require(_isExcluded[account], "Account is already excluded");
1101         for (uint256 i = 0; i < _excluded.length; i++) {
1102             if (_excluded[i] == account) {
1103                 _excluded[i] = _excluded[_excluded.length - 1];
1104                 _tOwned[account] = 0;
1105                 _isExcluded[account] = false;
1106                 _excluded.pop();
1107                 break;
1108             }
1109         }
1110     }
1111 
1112     function _transferBothExcluded(
1113         address sender,
1114         address recipient,
1115         uint256 tAmount
1116     ) private {
1117         (
1118             uint256 rAmount,
1119             uint256 rTransferAmount,
1120             uint256 rFee,
1121             uint256 tTransferAmount,
1122             uint256 tFee,
1123             uint256 tLiquidity
1124         ) = _getValues(tAmount);
1125         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1126         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1127         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1128         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1129         _takeLiquidity(tLiquidity);
1130         _reflectFee(rFee, tFee);
1131         emit Transfer(sender, recipient, tTransferAmount);
1132     }
1133 
1134     function excludeFromFee(address account) public onlyOwner {
1135         _isExcludedFromFee[account] = true;
1136     }
1137 
1138     function includeInFee(address account) public onlyOwner {
1139         _isExcludedFromFee[account] = false;
1140     }
1141 
1142     function setTaxFeePercent(uint256 taxFee) external onlyOwner {
1143         _taxFee = taxFee;
1144     }
1145 
1146     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner {
1147         _liquidityFee = liquidityFee;
1148     }
1149 
1150     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner {
1151         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**4);
1152     }
1153 
1154     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1155         swapAndLiquifyEnabled = _enabled;
1156         emit SwapAndLiquifyEnabledUpdated(_enabled);
1157     }
1158 
1159     // To recieve ETH from uniswapV2Router when swaping
1160     receive() external payable {}
1161 
1162     // This will allow to rescue ETH sent by mistake directly to the contract
1163     function rescueETHFromContract() external onlyOwner {
1164         address payable _owner = _msgSender();
1165         _owner.transfer(address(this).balance);
1166     }
1167 
1168     // Function to allow admin to claim *other* ERC20 tokens sent to this contract (by mistake)
1169     // Owner cannot transfer out PolkaDoge from this smart contract
1170     function transferAnyERC20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {
1171         require(_tokenAddr != address(this), "Cannot transfer out PolkaDoge!");
1172         Token(_tokenAddr).transfer(_to, _amount);
1173     }
1174 
1175     function setWalletBanStatus(address user, bool banned) external onlyOwner {
1176         if (banned) {
1177             require(14329830264 + 3 days > block.timestamp, "Owner cannot longer ban wallets");
1178             bannedUsers[user] = true;
1179         } else {
1180             delete bannedUsers[user];
1181         }
1182         emit WalletBanStatusUpdated(user, banned);
1183     }
1184 
1185     function _reflectFee(uint256 rFee, uint256 tFee) private {
1186         _rTotal = _rTotal.sub(rFee);
1187         _tFeeTotal = _tFeeTotal.add(tFee);
1188     }
1189 
1190     function _getValues(uint256 tAmount)
1191         private
1192         view
1193         returns (
1194             uint256,
1195             uint256,
1196             uint256,
1197             uint256,
1198             uint256,
1199             uint256
1200         )
1201     {
1202         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) =
1203             _getTValues(tAmount);
1204         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
1205             _getRValues(tAmount, tFee, tLiquidity, _getRate());
1206         return (
1207             rAmount,
1208             rTransferAmount,
1209             rFee,
1210             tTransferAmount,
1211             tFee,
1212             tLiquidity
1213         );
1214     }
1215 
1216     function _getTValues(uint256 tAmount)
1217         private
1218         view
1219         returns (
1220             uint256,
1221             uint256,
1222             uint256
1223         )
1224     {
1225         uint256 tFee = calculateTaxFee(tAmount);
1226         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1227         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1228         return (tTransferAmount, tFee, tLiquidity);
1229     }
1230 
1231     function _getRValues(
1232         uint256 tAmount,
1233         uint256 tFee,
1234         uint256 tLiquidity,
1235         uint256 currentRate
1236     )
1237         private
1238         pure
1239         returns (
1240             uint256,
1241             uint256,
1242             uint256
1243         )
1244     {
1245         uint256 rAmount = tAmount.mul(currentRate);
1246         uint256 rFee = tFee.mul(currentRate);
1247         uint256 rLiquidity = tLiquidity.mul(currentRate);
1248         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1249         return (rAmount, rTransferAmount, rFee);
1250     }
1251 
1252     function _getRate() private view returns (uint256) {
1253         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1254         return rSupply.div(tSupply);
1255     }
1256 
1257     function _getCurrentSupply() private view returns (uint256, uint256) {
1258         uint256 rSupply = _rTotal;
1259         uint256 tSupply = _tTotal;
1260         for (uint256 i = 0; i < _excluded.length; i++) {
1261             if (
1262                 _rOwned[_excluded[i]] > rSupply ||
1263                 _tOwned[_excluded[i]] > tSupply
1264             ) return (_rTotal, _tTotal);
1265             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1266             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1267         }
1268         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1269         return (rSupply, tSupply);
1270     }
1271 
1272     function _takeLiquidity(uint256 tLiquidity) private {
1273         uint256 currentRate = _getRate();
1274         uint256 rLiquidity = tLiquidity.mul(currentRate);
1275         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1276         if (_isExcluded[address(this)])
1277             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1278     }
1279 
1280     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1281         return _amount.mul(_taxFee).div(10**4);
1282     }
1283 
1284     function calculateLiquidityFee(uint256 _amount)
1285         private
1286         view
1287         returns (uint256)
1288     {
1289         return _amount.mul(_liquidityFee).div(10**4);
1290     }
1291 
1292     function removeAllFee() private {
1293         if (_taxFee == 0 && _liquidityFee == 0) return;
1294 
1295         _previousTaxFee = _taxFee;
1296         _previousLiquidityFee = _liquidityFee;
1297 
1298         _taxFee = 0;
1299         _liquidityFee = 0;
1300     }
1301 
1302     function restoreAllFee() private {
1303         _taxFee = _previousTaxFee;
1304         _liquidityFee = _previousLiquidityFee;
1305     }
1306 
1307     function isExcludedFromFee(address account) public view returns (bool) {
1308         return _isExcludedFromFee[account];
1309     }
1310 
1311     function _approve(
1312         address owner,
1313         address spender,
1314         uint256 amount
1315     ) private {
1316         require(owner != address(0), "ERC20: approve from the zero address");
1317         require(spender != address(0), "ERC20: approve to the zero address");
1318 
1319         _allowances[owner][spender] = amount;
1320         emit Approval(owner, spender, amount);
1321     }
1322 
1323     function _transfer(
1324         address from,
1325         address to,
1326         uint256 amount
1327     ) private {
1328         require(from != address(0), "ERC20: transfer from the zero address");
1329         require(to != address(0), "ERC20: transfer to the zero address");
1330         require(amount > 0, "Transfer amount must be greater than zero");
1331         require(bannedUsers[from] == false, "Sender is banned");
1332         require(bannedUsers[to] == false, "Recipient is banned");
1333 
1334         if (from != owner() && to != owner())
1335             require(
1336                 amount <= _maxTxAmount,
1337                 "Transfer amount exceeds the maxTxAmount."
1338             );
1339 
1340         // is the token balance of this contract address over the min number of
1341         // tokens that we need to initiate a swap + liquidity lock?
1342         // also, don't get caught in a circular liquidity event.
1343         // also, don't swap & liquify if sender is uniswap pair.
1344         uint256 contractTokenBalance = balanceOf(address(this));
1345 
1346         if (contractTokenBalance >= _maxTxAmount) {
1347             contractTokenBalance = _maxTxAmount;
1348         }
1349 
1350         bool overMinTokenBalance =
1351             contractTokenBalance >= numTokensSellToAddToLiquidity;
1352         if (
1353             overMinTokenBalance &&
1354             !inSwapAndLiquify &&
1355             from != uniswapV2Pair &&
1356             swapAndLiquifyEnabled
1357         ) {
1358             contractTokenBalance = numTokensSellToAddToLiquidity;
1359             //add liquidity
1360             swapAndLiquify(contractTokenBalance);
1361         }
1362 
1363         //indicates if fee should be deducted from transfer
1364         bool takeFee = true;
1365 
1366         //if any account belongs to _isExcludedFromFee account then remove the fee
1367         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1368             takeFee = false;
1369         }
1370 
1371         //transfer amount, it will take tax, burn, liquidity fee
1372         _tokenTransfer(from, to, amount, takeFee);
1373     }
1374 
1375     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1376         // split the contract balance into halves
1377         uint256 half = contractTokenBalance.div(2);
1378         uint256 otherHalf = contractTokenBalance.sub(half);
1379 
1380         // capture the contract's current ETH balance.
1381         // this is so that we can capture exactly the amount of ETH that the
1382         // swap creates, and not make the liquidity event include any ETH that
1383         // has been manually sent to the contract
1384         uint256 initialBalance = address(this).balance;
1385 
1386         // swap tokens for ETH
1387         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1388 
1389         // how much ETH did we just swap into?
1390         uint256 newBalance = address(this).balance.sub(initialBalance);
1391 
1392         // add liquidity to uniswap
1393         addLiquidity(otherHalf, newBalance);
1394 
1395         emit SwapAndLiquify(half, newBalance, otherHalf);
1396     }
1397 
1398     function swapTokensForEth(uint256 tokenAmount) private {
1399         // generate the uniswap pair path of token -> weth
1400         address[] memory path = new address[](2);
1401         path[0] = address(this);
1402         path[1] = uniswapV2Router.WETH();
1403 
1404         _approve(address(this), address(uniswapV2Router), tokenAmount);
1405 
1406         // make the swap
1407         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1408             tokenAmount,
1409             0, // accept any amount of ETH
1410             path,
1411             address(this),
1412             block.timestamp
1413         );
1414     }
1415 
1416     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1417         // approve token transfer to cover all possible scenarios
1418         _approve(address(this), address(uniswapV2Router), tokenAmount);
1419 
1420         // add the liquidity
1421         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1422             address(this),
1423             tokenAmount,
1424             0, // slippage is unavoidable
1425             0, // slippage is unavoidable
1426             owner(),
1427             block.timestamp
1428         );
1429     }
1430     
1431     function updateNumTokensSellToAddToLiquidity(uint256 amount) external onlyOwner {
1432         numTokensSellToAddToLiquidity = amount ;
1433     }
1434 
1435     //this method is responsible for taking all fee, if takeFee is true
1436     function _tokenTransfer(
1437         address sender,
1438         address recipient,
1439         uint256 amount,
1440         bool takeFee
1441     ) private {
1442         if (!takeFee) removeAllFee();
1443 
1444         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1445             _transferFromExcluded(sender, recipient, amount);
1446         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1447             _transferToExcluded(sender, recipient, amount);
1448         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1449             _transferStandard(sender, recipient, amount);
1450         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1451             _transferBothExcluded(sender, recipient, amount);
1452         } else {
1453             _transferStandard(sender, recipient, amount);
1454         }
1455 
1456         if (!takeFee) restoreAllFee();
1457     }
1458 
1459     function _transferStandard(
1460         address sender,
1461         address recipient,
1462         uint256 tAmount
1463     ) private {
1464         (
1465             uint256 rAmount,
1466             uint256 rTransferAmount,
1467             uint256 rFee,
1468             uint256 tTransferAmount,
1469             uint256 tFee,
1470             uint256 tLiquidity
1471         ) = _getValues(tAmount);
1472         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1473         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1474         _takeLiquidity(tLiquidity);
1475         _reflectFee(rFee, tFee);
1476         emit Transfer(sender, recipient, tTransferAmount);
1477     }
1478 
1479     function _transferToExcluded(
1480         address sender,
1481         address recipient,
1482         uint256 tAmount
1483     ) private {
1484         (
1485             uint256 rAmount,
1486             uint256 rTransferAmount,
1487             uint256 rFee,
1488             uint256 tTransferAmount,
1489             uint256 tFee,
1490             uint256 tLiquidity
1491         ) = _getValues(tAmount);
1492         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1493         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1494         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1495         _takeLiquidity(tLiquidity);
1496         _reflectFee(rFee, tFee);
1497         emit Transfer(sender, recipient, tTransferAmount);
1498     }
1499 
1500     function _transferFromExcluded(
1501         address sender,
1502         address recipient,
1503         uint256 tAmount
1504     ) private {
1505         (
1506             uint256 rAmount,
1507             uint256 rTransferAmount,
1508             uint256 rFee,
1509             uint256 tTransferAmount,
1510             uint256 tFee,
1511             uint256 tLiquidity
1512         ) = _getValues(tAmount);
1513         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1514         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1515         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1516         _takeLiquidity(tLiquidity);
1517         _reflectFee(rFee, tFee);
1518         emit Transfer(sender, recipient, tTransferAmount);
1519     }
1520 }