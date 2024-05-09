1 /** 
2 
3 Telegram Portal: https://t.me/ShibaDoge_Portal
4 Website: realshibadoge.com
5 Twitter: https://twitter.com/RealShibaDoge
6 Medium: https://medium.com/@contact_86398/shibdoge-bringing-together-mortal-enemies-e6d3cc1eeba0
7 
8 */
9 
10 
11 pragma solidity ^0.8.10;
12 
13 // SPDX-License-Identifier: Unlicensed
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `recipient`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address recipient, uint256 amount)
30         external
31         returns (bool);
32 
33     /**
34      * @dev Returns the remaining number of tokens that `spender` will be
35      * allowed to spend on behalf of `owner` through {transferFrom}. This is
36      * zero by default.
37      *
38      * This value changes when {approve} or {transferFrom} are called.
39      */
40     function allowance(address owner, address spender)
41         external
42         view
43         returns (uint256);
44 
45     /**
46      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * IMPORTANT: Beware that changing an allowance with this method brings the risk
51      * that someone may use both the old and the new allowance by unfortunate
52      * transaction ordering. One possible solution to mitigate this race
53      * condition is to first reduce the spender's allowance to 0 and set the
54      * desired value afterwards:
55      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
56      *
57      * Emits an {Approval} event.
58      */
59     function approve(address spender, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Moves `amount` tokens from `sender` to `recipient` using the
63      * allowance mechanism. `amount` is then deducted from the caller's
64      * allowance.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transferFrom(
71         address sender,
72         address recipient,
73         uint256 amount
74     ) external returns (bool);
75 
76     /**
77      * @dev Emitted when `value` tokens are moved from one account (`from`) to
78      * another (`to`).
79      *
80      * Note that `value` may be zero.
81      */
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     /**
85      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
86      * a call to {approve}. `value` is the new allowance.
87      */
88     event Approval(
89         address indexed owner,
90         address indexed spender,
91         uint256 value
92     );
93 }
94 
95 /**
96  * @dev Wrappers over Solidity's arithmetic operations with added overflow
97  * checks.
98  *
99  * Arithmetic operations in Solidity wrap on overflow. This can easily result
100  * in bugs, because programmers usually assume that an overflow raises an
101  * error, which is the standard behavior in high level programming languages.
102  * `SafeMath` restores this intuition by reverting the transaction when an
103  * operation overflows.
104  *
105  * Using this library instead of the unchecked operations eliminates an entire
106  * class of bugs, so it's recommended to use it always.
107  */
108 
109 library SafeMath {
110     /**
111      * @dev Returns the addition of two unsigned integers, reverting on
112      * overflow.
113      *
114      * Counterpart to Solidity's `+` operator.
115      *
116      * Requirements:
117      *
118      * - Addition cannot overflow.
119      */
120     function add(uint256 a, uint256 b) internal pure returns (uint256) {
121         uint256 c = a + b;
122         require(c >= a, "SafeMath: addition overflow");
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the subtraction of two unsigned integers, reverting on
129      * overflow (when the result is negative).
130      *
131      * Counterpart to Solidity's `-` operator.
132      *
133      * Requirements:
134      *
135      * - Subtraction cannot overflow.
136      */
137     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
138         return sub(a, b, "SafeMath: subtraction overflow");
139     }
140 
141     /**
142      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
143      * overflow (when the result is negative).
144      *
145      * Counterpart to Solidity's `-` operator.
146      *
147      * Requirements:
148      *
149      * - Subtraction cannot overflow.
150      */
151     function sub(
152         uint256 a,
153         uint256 b,
154         string memory errorMessage
155     ) internal pure returns (uint256) {
156         require(b <= a, errorMessage);
157         uint256 c = a - b;
158 
159         return c;
160     }
161 
162     /**
163      * @dev Returns the multiplication of two unsigned integers, reverting on
164      * overflow.
165      *
166      * Counterpart to Solidity's `*` operator.
167      *
168      * Requirements:
169      *
170      * - Multiplication cannot overflow.
171      */
172     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
173         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
174         // benefit is lost if 'b' is also tested.
175         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
176         if (a == 0) {
177             return 0;
178         }
179 
180         uint256 c = a * b;
181         require(c / a == b, "SafeMath: multiplication overflow");
182 
183         return c;
184     }
185 
186     /**
187      * @dev Returns the integer division of two unsigned integers. Reverts on
188      * division by zero. The result is rounded towards zero.
189      *
190      * Counterpart to Solidity's `/` operator. Note: this function uses a
191      * `revert` opcode (which leaves remaining gas untouched) while Solidity
192      * uses an invalid opcode to revert (consuming all remaining gas).
193      *
194      * Requirements:
195      *
196      * - The divisor cannot be zero.
197      */
198     function div(uint256 a, uint256 b) internal pure returns (uint256) {
199         return div(a, b, "SafeMath: division by zero");
200     }
201 
202     /**
203      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
204      * division by zero. The result is rounded towards zero.
205      *
206      * Counterpart to Solidity's `/` operator. Note: this function uses a
207      * `revert` opcode (which leaves remaining gas untouched) while Solidity
208      * uses an invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function div(
215         uint256 a,
216         uint256 b,
217         string memory errorMessage
218     ) internal pure returns (uint256) {
219         require(b > 0, errorMessage);
220         uint256 c = a / b;
221         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
222 
223         return c;
224     }
225 
226     /**
227      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228      * Reverts when dividing by zero.
229      *
230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
239         return mod(a, b, "SafeMath: modulo by zero");
240     }
241 
242     /**
243      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244      * Reverts with custom message when dividing by zero.
245      *
246      * Counterpart to Solidity's `%` operator. This function uses a `revert`
247      * opcode (which leaves remaining gas untouched) while Solidity uses an
248      * invalid opcode to revert (consuming all remaining gas).
249      *
250      * Requirements:
251      *
252      * - The divisor cannot be zero.
253      */
254     function mod(
255         uint256 a,
256         uint256 b,
257         string memory errorMessage
258     ) internal pure returns (uint256) {
259         require(b != 0, errorMessage);
260         return a % b;
261     }
262 }
263 
264 abstract contract Context {
265     function _msgSender() internal view virtual returns (address payable) {
266         return payable(msg.sender);
267     }
268 
269     function _msgData() internal view virtual returns (bytes memory) {
270         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
271         return msg.data;
272     }
273 }
274 
275 /**
276  * @dev Collection of functions related to the address type
277  */
278 library Address {
279     /**
280      * @dev Returns true if `account` is a contract.
281      *
282      * [IMPORTANT]
283      * ====
284      * It is unsafe to assume that an address for which this function returns
285      * false is an externally-owned account (EOA) and not a contract.
286      *
287      * Among others, `isContract` will return false for the following
288      * types of addresses:
289      *
290      *  - an externally-owned account
291      *  - a contract in construction
292      *  - an address where a contract will be created
293      *  - an address where a contract lived, but was destroyed
294      * ====
295      */
296     function isContract(address account) internal view returns (bool) {
297         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
298         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
299         // for accounts without code, i.e. `keccak256('')`
300         bytes32 codehash;
301         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
302         // solhint-disable-next-line no-inline-assembly
303         assembly {
304             codehash := extcodehash(account)
305         }
306         return (codehash != accountHash && codehash != 0x0);
307     }
308 
309     /**
310      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
311      * `recipient`, forwarding all available gas and reverting on errors.
312      *
313      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
314      * of certain opcodes, possibly making contracts go over the 2300 gas limit
315      * imposed by `transfer`, making them unable to receive funds via
316      * `transfer`. {sendValue} removes this limitation.
317      *
318      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
319      *
320      * IMPORTANT: because control is transferred to `recipient`, care must be
321      * taken to not create reentrancy vulnerabilities. Consider using
322      * {ReentrancyGuard} or the
323      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
324      */
325     function sendValue(address payable recipient, uint256 amount) internal {
326         require(
327             address(this).balance >= amount,
328             "Address: insufficient balance"
329         );
330 
331         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
332         (bool success, ) = recipient.call{value: amount}("");
333         require(
334             success,
335             "Address: unable to send value, recipient may have reverted"
336         );
337     }
338 
339     /**
340      * @dev Performs a Solidity function call using a low level `call`. A
341      * plain`call` is an unsafe replacement for a function call: use this
342      * function instead.
343      *
344      * If `target` reverts with a revert reason, it is bubbled up by this
345      * function (like regular Solidity function calls).
346      *
347      * Returns the raw returned data. To convert to the expected return value,
348      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
349      *
350      * Requirements:
351      *
352      * - `target` must be a contract.
353      * - calling `target` with `data` must not revert.
354      *
355      * _Available since v3.1._
356      */
357     function functionCall(address target, bytes memory data)
358         internal
359         returns (bytes memory)
360     {
361         return functionCall(target, data, "Address: low-level call failed");
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
366      * `errorMessage` as a fallback revert reason when `target` reverts.
367      *
368      * _Available since v3.1._
369      */
370     function functionCall(
371         address target,
372         bytes memory data,
373         string memory errorMessage
374     ) internal returns (bytes memory) {
375         return _functionCallWithValue(target, data, 0, errorMessage);
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
380      * but also transferring `value` wei to `target`.
381      *
382      * Requirements:
383      *
384      * - the calling contract must have an ETH balance of at least `value`.
385      * - the called Solidity function must be `payable`.
386      *
387      * _Available since v3.1._
388      */
389     function functionCallWithValue(
390         address target,
391         bytes memory data,
392         uint256 value
393     ) internal returns (bytes memory) {
394         return
395             functionCallWithValue(
396                 target,
397                 data,
398                 value,
399                 "Address: low-level call with value failed"
400             );
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
405      * with `errorMessage` as a fallback revert reason when `target` reverts.
406      *
407      * _Available since v3.1._
408      */
409     function functionCallWithValue(
410         address target,
411         bytes memory data,
412         uint256 value,
413         string memory errorMessage
414     ) internal returns (bytes memory) {
415         require(
416             address(this).balance >= value,
417             "Address: insufficient balance for call"
418         );
419         return _functionCallWithValue(target, data, value, errorMessage);
420     }
421 
422     function _functionCallWithValue(
423         address target,
424         bytes memory data,
425         uint256 weiValue,
426         string memory errorMessage
427     ) private returns (bytes memory) {
428         require(isContract(target), "Address: call to non-contract");
429 
430         // solhint-disable-next-line avoid-low-level-calls
431         (bool success, bytes memory returndata) = target.call{value: weiValue}(
432             data
433         );
434         if (success) {
435             return returndata;
436         } else {
437             // Look for revert reason and bubble it up if present
438             if (returndata.length > 0) {
439                 // The easiest way to bubble the revert reason is using memory via assembly
440 
441                 // solhint-disable-next-line no-inline-assembly
442                 assembly {
443                     let returndata_size := mload(returndata)
444                     revert(add(32, returndata), returndata_size)
445                 }
446             } else {
447                 revert(errorMessage);
448             }
449         }
450     }
451 }
452 
453 /**
454  * @dev Contract module which provides a basic access control mechanism, where
455  * there is an account (an owner) that can be granted exclusive access to
456  * specific functions.
457  *
458  * By default, the owner account will be the one that deploys the contract. This
459  * can later be changed with {transferOwnership}.
460  *
461  * This module is used through inheritance. It will make available the modifier
462  * `onlyOwner`, which can be applied to your functions to restrict their use to
463  * the owner.
464  */
465 contract Ownable is Context {
466     address private _owner;
467     address private _previousOwner;
468     uint256 private _lockTime;
469 
470     event OwnershipTransferred(
471         address indexed previousOwner,
472         address indexed newOwner
473     );
474 
475     /**
476      * @dev Initializes the contract setting the deployer as the initial owner.
477      */
478     constructor() {
479         address msgSender = _msgSender();
480         _owner = msgSender;
481         emit OwnershipTransferred(address(0), msgSender);
482     }
483 
484     /**
485      * @dev Returns the address of the current owner.
486      */
487     function owner() public view returns (address) {
488         return _owner;
489     }
490 
491     /**
492      * @dev Throws if called by any account other than the owner.
493      */
494     modifier onlyOwner() {
495         require(_owner == _msgSender(), "Ownable: caller is not the owner");
496         _;
497     }
498 
499     /**
500      * @dev Leaves the contract without owner. It will not be possible to call
501      * `onlyOwner` functions anymore. Can only be called by the current owner.
502      *
503      * NOTE: Renouncing ownership will leave the contract without an owner,
504      * thereby removing any functionality that is only available to the owner.
505      */
506     function renounceOwnership() public virtual onlyOwner {
507         emit OwnershipTransferred(_owner, address(0));
508         _owner = address(0);
509     }
510 
511     /**
512      * @dev Transfers ownership of the contract to a new account (`newOwner`).
513      * Can only be called by the current owner.
514      */
515     function transferOwnership(address newOwner) public virtual onlyOwner {
516         require(
517             newOwner != address(0),
518             "Ownable: new owner is the zero address"
519         );
520         emit OwnershipTransferred(_owner, newOwner);
521         _owner = newOwner;
522     }
523 
524     function geUnlockTime() public view returns (uint256) {
525         return _lockTime;
526     }
527 
528     //Locks the contract for owner for the amount of time provided
529     function lock(uint256 time) public virtual onlyOwner {
530         _previousOwner = _owner;
531         _owner = address(0);
532         _lockTime = block.timestamp + time;
533         emit OwnershipTransferred(_owner, address(0));
534     }
535 
536     //Unlocks the contract for owner when _lockTime is exceeds
537     function unlock() public virtual {
538         require(
539             _previousOwner == msg.sender,
540             "You don't have permission to unlock"
541         );
542         require(block.timestamp > _lockTime, "Contract is locked until a later date");
543         emit OwnershipTransferred(_owner, _previousOwner);
544         _owner = _previousOwner;
545         _previousOwner = address(0);
546     }
547 }
548 
549 // pragma solidity >=0.5.0;
550 
551 interface IUniswapV2Factory {
552     event PairCreated(
553         address indexed token0,
554         address indexed token1,
555         address pair,
556         uint256
557     );
558 
559     function feeTo() external view returns (address);
560 
561     function feeToSetter() external view returns (address);
562 
563     function getPair(address tokenA, address tokenB)
564         external
565         view
566         returns (address pair);
567 
568     function allPairs(uint256) external view returns (address pair);
569 
570     function allPairsLength() external view returns (uint256);
571 
572     function createPair(address tokenA, address tokenB)
573         external
574         returns (address pair);
575 
576     function setFeeTo(address) external;
577 
578     function setFeeToSetter(address) external;
579 }
580 
581 // pragma solidity >=0.5.0;
582 
583 interface IUniswapV2Pair {
584     event Approval(
585         address indexed owner,
586         address indexed spender,
587         uint256 value
588     );
589     event Transfer(address indexed from, address indexed to, uint256 value);
590 
591     function name() external pure returns (string memory);
592 
593     function symbol() external pure returns (string memory);
594 
595     function decimals() external pure returns (uint8);
596 
597     function totalSupply() external view returns (uint256);
598 
599     function balanceOf(address owner) external view returns (uint256);
600 
601     function allowance(address owner, address spender)
602         external
603         view
604         returns (uint256);
605 
606     function approve(address spender, uint256 value) external returns (bool);
607 
608     function transfer(address to, uint256 value) external returns (bool);
609 
610     function transferFrom(
611         address from,
612         address to,
613         uint256 value
614     ) external returns (bool);
615 
616     function DOMAIN_SEPARATOR() external view returns (bytes32);
617 
618     function PERMIT_TYPEHASH() external pure returns (bytes32);
619 
620     function nonces(address owner) external view returns (uint256);
621 
622     function permit(
623         address owner,
624         address spender,
625         uint256 value,
626         uint256 deadline,
627         uint8 v,
628         bytes32 r,
629         bytes32 s
630     ) external;
631 
632     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
633     event Burn(
634         address indexed sender,
635         uint256 amount0,
636         uint256 amount1,
637         address indexed to
638     );
639     event Swap(
640         address indexed sender,
641         uint256 amount0In,
642         uint256 amount1In,
643         uint256 amount0Out,
644         uint256 amount1Out,
645         address indexed to
646     );
647     event Sync(uint112 reserve0, uint112 reserve1);
648 
649     function MINIMUM_LIQUIDITY() external pure returns (uint256);
650 
651     function factory() external view returns (address);
652 
653     function token0() external view returns (address);
654 
655     function token1() external view returns (address);
656 
657     function getReserves()
658         external
659         view
660         returns (
661             uint112 reserve0,
662             uint112 reserve1,
663             uint32 blockTimestampLast
664         );
665 
666     function price0CumulativeLast() external view returns (uint256);
667 
668     function price1CumulativeLast() external view returns (uint256);
669 
670     function kLast() external view returns (uint256);
671 
672     function mint(address to) external returns (uint256 liquidity);
673 
674     function burn(address to)
675         external
676         returns (uint256 amount0, uint256 amount1);
677 
678     function swap(
679         uint256 amount0Out,
680         uint256 amount1Out,
681         address to,
682         bytes calldata data
683     ) external;
684 
685     function skim(address to) external;
686 
687     function sync() external;
688 
689     function initialize(address, address) external;
690 }
691 
692 // pragma solidity >=0.6.2;
693 
694 interface IUniswapV2Router01 {
695     function factory() external pure returns (address);
696 
697     function WETH() external pure returns (address);
698 
699     function addLiquidity(
700         address tokenA,
701         address tokenB,
702         uint256 amountADesired,
703         uint256 amountBDesired,
704         uint256 amountAMin,
705         uint256 amountBMin,
706         address to,
707         uint256 deadline
708     )
709         external
710         returns (
711             uint256 amountA,
712             uint256 amountB,
713             uint256 liquidity
714         );
715 
716     function addLiquidityETH(
717         address token,
718         uint256 amountTokenDesired,
719         uint256 amountTokenMin,
720         uint256 amountETHMin,
721         address to,
722         uint256 deadline
723     )
724         external
725         payable
726         returns (
727             uint256 amountToken,
728             uint256 amountETH,
729             uint256 liquidity
730         );
731 
732     function removeLiquidity(
733         address tokenA,
734         address tokenB,
735         uint256 liquidity,
736         uint256 amountAMin,
737         uint256 amountBMin,
738         address to,
739         uint256 deadline
740     ) external returns (uint256 amountA, uint256 amountB);
741 
742     function removeLiquidityETH(
743         address token,
744         uint256 liquidity,
745         uint256 amountTokenMin,
746         uint256 amountETHMin,
747         address to,
748         uint256 deadline
749     ) external returns (uint256 amountToken, uint256 amountETH);
750 
751     function removeLiquidityWithPermit(
752         address tokenA,
753         address tokenB,
754         uint256 liquidity,
755         uint256 amountAMin,
756         uint256 amountBMin,
757         address to,
758         uint256 deadline,
759         bool approveMax,
760         uint8 v,
761         bytes32 r,
762         bytes32 s
763     ) external returns (uint256 amountA, uint256 amountB);
764 
765     function removeLiquidityETHWithPermit(
766         address token,
767         uint256 liquidity,
768         uint256 amountTokenMin,
769         uint256 amountETHMin,
770         address to,
771         uint256 deadline,
772         bool approveMax,
773         uint8 v,
774         bytes32 r,
775         bytes32 s
776     ) external returns (uint256 amountToken, uint256 amountETH);
777 
778     function swapExactTokensForTokens(
779         uint256 amountIn,
780         uint256 amountOutMin,
781         address[] calldata path,
782         address to,
783         uint256 deadline
784     ) external returns (uint256[] memory amounts);
785 
786     function swapTokensForExactTokens(
787         uint256 amountOut,
788         uint256 amountInMax,
789         address[] calldata path,
790         address to,
791         uint256 deadline
792     ) external returns (uint256[] memory amounts);
793 
794     function swapExactETHForTokens(
795         uint256 amountOutMin,
796         address[] calldata path,
797         address to,
798         uint256 deadline
799     ) external payable returns (uint256[] memory amounts);
800 
801     function swapTokensForExactETH(
802         uint256 amountOut,
803         uint256 amountInMax,
804         address[] calldata path,
805         address to,
806         uint256 deadline
807     ) external returns (uint256[] memory amounts);
808 
809     function swapExactTokensForETH(
810         uint256 amountIn,
811         uint256 amountOutMin,
812         address[] calldata path,
813         address to,
814         uint256 deadline
815     ) external returns (uint256[] memory amounts);
816 
817     function swapETHForExactTokens(
818         uint256 amountOut,
819         address[] calldata path,
820         address to,
821         uint256 deadline
822     ) external payable returns (uint256[] memory amounts);
823 
824     function quote(
825         uint256 amountA,
826         uint256 reserveA,
827         uint256 reserveB
828     ) external pure returns (uint256 amountB);
829 
830     function getAmountOut(
831         uint256 amountIn,
832         uint256 reserveIn,
833         uint256 reserveOut
834     ) external pure returns (uint256 amountOut);
835 
836     function getAmountIn(
837         uint256 amountOut,
838         uint256 reserveIn,
839         uint256 reserveOut
840     ) external pure returns (uint256 amountIn);
841 
842     function getAmountsOut(uint256 amountIn, address[] calldata path)
843         external
844         view
845         returns (uint256[] memory amounts);
846 
847     function getAmountsIn(uint256 amountOut, address[] calldata path)
848         external
849         view
850         returns (uint256[] memory amounts);
851 }
852 
853 // pragma solidity >=0.6.2;
854 
855 interface IUniswapV2Router02 is IUniswapV2Router01 {
856     function removeLiquidityETHSupportingFeeOnTransferTokens(
857         address token,
858         uint256 liquidity,
859         uint256 amountTokenMin,
860         uint256 amountETHMin,
861         address to,
862         uint256 deadline
863     ) external returns (uint256 amountETH);
864 
865     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
866         address token,
867         uint256 liquidity,
868         uint256 amountTokenMin,
869         uint256 amountETHMin,
870         address to,
871         uint256 deadline,
872         bool approveMax,
873         uint8 v,
874         bytes32 r,
875         bytes32 s
876     ) external returns (uint256 amountETH);
877 
878     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
879         uint256 amountIn,
880         uint256 amountOutMin,
881         address[] calldata path,
882         address to,
883         uint256 deadline
884     ) external;
885 
886     function swapExactETHForTokensSupportingFeeOnTransferTokens(
887         uint256 amountOutMin,
888         address[] calldata path,
889         address to,
890         uint256 deadline
891     ) external payable;
892 
893     function swapExactTokensForETHSupportingFeeOnTransferTokens(
894         uint256 amountIn,
895         uint256 amountOutMin,
896         address[] calldata path,
897         address to,
898         uint256 deadline
899     ) external;
900 }
901 
902 contract ShibaDoge is Context, IERC20, Ownable {
903     using SafeMath for uint256;
904     using Address for address;
905 
906     mapping(address => uint256) private _rOwned;
907     mapping(address => uint256) private _tOwned;
908     mapping(address => mapping(address => uint256)) private _allowances;
909 
910     mapping(address => bool) private _isExcludedFromFee;
911 
912     mapping(address => bool) private _isExcluded;
913     address[] private _excluded;
914     mapping(address => bool) private _isBlackListedBot;
915 
916     mapping(address => bool) private _isExcludedFromLimit;
917     address[] private _blackListedBots;
918 
919     uint256 private constant MAX = ~uint256(0);
920     uint256 private _tTotal = 420 * 10**21 * 10**9;
921     uint256 private _rTotal = (MAX - (MAX % _tTotal));
922     uint256 private _tFeeTotal;
923 
924     address payable public _marketingAddress =
925         payable(address(0x61E7210AE22cCfaBd5B9289208EA65a8718b04B1));
926     address payable public _devwallet =
927         payable(address(0xb5491FaB852331bA26ef8Ec51CC48E78Aa788626));
928     address public _exchangewallet =
929         payable(address(0x34f6695d10A29dFB8B94e5bacDfB872E5Be8B6D2));
930     address _partnershipswallet =
931         payable(address(0x36930bB214526522aa2195bBC29e71De78d9B68a));
932     address private _donationAddress =
933         0x000000000000000000000000000000000000dEaD;
934 
935     string private _name = "ShibaDoge";
936     string private _symbol = "ShibDoge";
937     uint8 private _decimals = 9;
938 
939     struct BuyFee {
940         uint16 tax;
941         uint16 liquidity;
942         uint16 marketing;
943         uint16 dev;
944         uint16 donation;
945     }
946 
947     struct SellFee {
948         uint16 tax;
949         uint16 liquidity;
950         uint16 marketing;
951         uint16 dev;
952         uint16 donation;
953     }
954 
955     BuyFee public buyFee;
956     SellFee public sellFee;
957 
958     uint16 private _taxFee;
959     uint16 private _liquidityFee;
960     uint16 private _marketingFee;
961     uint16 private _devFee;
962     uint16 private _donationFee;
963 
964     IUniswapV2Router02 public immutable uniswapV2Router;
965     address public immutable uniswapV2Pair;
966 
967     bool inSwapAndLiquify;
968     bool public swapAndLiquifyEnabled = true;
969 
970     uint256 public _maxTxAmount = 210 * 10**19 * 10**9;
971     uint256 private numTokensSellToAddToLiquidity = 210 * 10**19 * 10**9;
972     uint256 public _maxWalletSize = 420 * 10**19 * 10**9;
973 
974     event botAddedToBlacklist(address account);
975     event botRemovedFromBlacklist(address account);
976 
977     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
978     event SwapAndLiquifyEnabledUpdated(bool enabled);
979     event SwapAndLiquify(
980         uint256 tokensSwapped,
981         uint256 ethReceived,
982         uint256 tokensIntoLiqudity
983     );
984 
985     modifier lockTheSwap() {
986         inSwapAndLiquify = true;
987         _;
988         inSwapAndLiquify = false;
989     }
990 
991     constructor() {
992         _rOwned[_msgSender()] = _rTotal;
993 
994         buyFee.tax = 0;
995         buyFee.liquidity = 47;
996         buyFee.marketing = 48;
997         buyFee.dev = 0;
998         buyFee.donation = 0;
999 
1000         sellFee.tax = 0;
1001         sellFee.liquidity = 47;
1002         sellFee.marketing = 48;
1003         sellFee.dev = 0;
1004         sellFee.donation = 0;
1005 
1006         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1007             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1008         );
1009         // Create a uniswap pair for this new token
1010         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1011             .createPair(address(this), _uniswapV2Router.WETH());
1012 
1013         // set the rest of the contract variables
1014         uniswapV2Router = _uniswapV2Router;
1015 
1016         // exclude owner, dev wallet, and this contract from fee
1017         _isExcludedFromFee[owner()] = true;
1018         _isExcludedFromFee[address(this)] = true;
1019         _isExcludedFromFee[_marketingAddress] = true;
1020         _isExcludedFromFee[_devwallet] = true;
1021         _isExcludedFromFee[_exchangewallet] = true;
1022         _isExcludedFromFee[_partnershipswallet] = true;
1023 
1024         _isExcludedFromLimit[_marketingAddress] = true;
1025         _isExcludedFromLimit[_devwallet] = true;
1026         _isExcludedFromLimit[_exchangewallet] = true;
1027         _isExcludedFromLimit[_partnershipswallet] = true;
1028         _isExcludedFromLimit[owner()] = true;
1029         _isExcludedFromLimit[address(this)] = true;
1030 
1031         emit Transfer(address(0), _msgSender(), _tTotal);
1032     }
1033 
1034     function name() public view returns (string memory) {
1035         return _name;
1036     }
1037 
1038     function symbol() public view returns (string memory) {
1039         return _symbol;
1040     }
1041 
1042     function decimals() public view returns (uint8) {
1043         return _decimals;
1044     }
1045 
1046     function totalSupply() public view override returns (uint256) {
1047         return _tTotal;
1048     }
1049 
1050     function balanceOf(address account) public view override returns (uint256) {
1051         if (_isExcluded[account]) return _tOwned[account];
1052         return tokenFromReflection(_rOwned[account]);
1053     }
1054 
1055     function transfer(address recipient, uint256 amount)
1056         public
1057         override
1058         returns (bool)
1059     {
1060         _transfer(_msgSender(), recipient, amount);
1061         return true;
1062     }
1063 
1064     function allowance(address owner, address spender)
1065         public
1066         view
1067         override
1068         returns (uint256)
1069     {
1070         return _allowances[owner][spender];
1071     }
1072 
1073     function approve(address spender, uint256 amount)
1074         public
1075         override
1076         returns (bool)
1077     {
1078         _approve(_msgSender(), spender, amount);
1079         return true;
1080     }
1081 
1082     function transferFrom(
1083         address sender,
1084         address recipient,
1085         uint256 amount
1086     ) public override returns (bool) {
1087         _transfer(sender, recipient, amount);
1088         _approve(
1089             sender,
1090             _msgSender(),
1091             _allowances[sender][_msgSender()].sub(
1092                 amount,
1093                 "ERC20: transfer amount exceeds allowance"
1094             )
1095         );
1096         return true;
1097     }
1098 
1099     function increaseAllowance(address spender, uint256 addedValue)
1100         public
1101         virtual
1102         returns (bool)
1103     {
1104         _approve(
1105             _msgSender(),
1106             spender,
1107             _allowances[_msgSender()][spender].add(addedValue)
1108         );
1109         return true;
1110     }
1111 
1112     function decreaseAllowance(address spender, uint256 subtractedValue)
1113         public
1114         virtual
1115         returns (bool)
1116     {
1117         _approve(
1118             _msgSender(),
1119             spender,
1120             _allowances[_msgSender()][spender].sub(
1121                 subtractedValue,
1122                 "ERC20: decreased allowance below zero"
1123             )
1124         );
1125         return true;
1126     }
1127 
1128     function isExcludedFromReward(address account) public view returns (bool) {
1129         return _isExcluded[account];
1130     }
1131 
1132     function totalFees() public view returns (uint256) {
1133         return _tFeeTotal;
1134     }
1135 
1136     function donationAddress() public view returns (address) {
1137         return _donationAddress;
1138     }
1139 
1140     function deliver(uint256 tAmount) public {
1141         address sender = _msgSender();
1142         require(
1143             !_isExcluded[sender],
1144             "Excluded addresses cannot call this function"
1145         );
1146 
1147         (
1148             ,
1149             uint256 tFee,
1150             uint256 tLiquidity,
1151             uint256 tWallet,
1152             uint256 tDonation
1153         ) = _getTValues(tAmount);
1154         (uint256 rAmount, , ) = _getRValues(
1155             tAmount,
1156             tFee,
1157             tLiquidity,
1158             tWallet,
1159             tDonation,
1160             _getRate()
1161         );
1162 
1163         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1164         _rTotal = _rTotal.sub(rAmount);
1165         _tFeeTotal = _tFeeTotal.add(tAmount);
1166     }
1167 
1168     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
1169         public
1170         view
1171         returns (uint256)
1172     {
1173         require(tAmount <= _tTotal, "Amount must be less than supply");
1174 
1175         (
1176             ,
1177             uint256 tFee,
1178             uint256 tLiquidity,
1179             uint256 tWallet,
1180             uint256 tDonation
1181         ) = _getTValues(tAmount);
1182         (uint256 rAmount, uint256 rTransferAmount, ) = _getRValues(
1183             tAmount,
1184             tFee,
1185             tLiquidity,
1186             tWallet,
1187             tDonation,
1188             _getRate()
1189         );
1190 
1191         if (!deductTransferFee) {
1192             return rAmount;
1193         } else {
1194             return rTransferAmount;
1195         }
1196     }
1197 
1198     function tokenFromReflection(uint256 rAmount)
1199         public
1200         view
1201         returns (uint256)
1202     {
1203         require(
1204             rAmount <= _rTotal,
1205             "Amount must be less than total reflections"
1206         );
1207         uint256 currentRate = _getRate();
1208         return rAmount.div(currentRate);
1209     }
1210 
1211 
1212     function updateMarketingWallet(address payable newAddress) external onlyOwner {
1213         _marketingAddress = newAddress;
1214     }
1215 
1216     function updateDevWallet(address payable newAddress) external onlyOwner {
1217         _devwallet = newAddress;
1218     }
1219 
1220     function updateExchangeWallet(address newAddress) external onlyOwner {
1221         _exchangewallet = newAddress;
1222     }
1223 
1224     function updatePartnershipsWallet(address newAddress) external onlyOwner {
1225         _partnershipswallet = newAddress;
1226     }
1227 
1228     function addBotToBlacklist(address account) external onlyOwner {
1229         require(
1230             account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D,
1231             "We cannot blacklist UniSwap router"
1232         );
1233         require(!_isBlackListedBot[account], "Account is already blacklisted");
1234         _isBlackListedBot[account] = true;
1235         _blackListedBots.push(account);
1236     }
1237 
1238     function removeBotFromBlacklist(address account) external onlyOwner {
1239         require(_isBlackListedBot[account], "Account is not blacklisted");
1240         for (uint256 i = 0; i < _blackListedBots.length; i++) {
1241             if (_blackListedBots[i] == account) {
1242                 _blackListedBots[i] = _blackListedBots[
1243                     _blackListedBots.length - 1
1244                 ];
1245                 _isBlackListedBot[account] = false;
1246                 _blackListedBots.pop();
1247                 break;
1248             }
1249         }
1250     }
1251 
1252     function excludeFromReward(address account) public onlyOwner {
1253         require(!_isExcluded[account], "Account is already excluded");
1254         if (_rOwned[account] > 0) {
1255             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1256         }
1257         _isExcluded[account] = true;
1258         _excluded.push(account);
1259     }
1260 
1261     function includeInReward(address account) external onlyOwner {
1262         require(_isExcluded[account], "Account is not excluded");
1263         for (uint256 i = 0; i < _excluded.length; i++) {
1264             if (_excluded[i] == account) {
1265                 _excluded[i] = _excluded[_excluded.length - 1];
1266                 _tOwned[account] = 0;
1267                 _isExcluded[account] = false;
1268                 _excluded.pop();
1269                 break;
1270             }
1271         }
1272     }
1273 
1274     function excludeFromFee(address account) public onlyOwner {
1275         _isExcludedFromFee[account] = true;
1276     }
1277 
1278     function includeInFee(address account) public onlyOwner {
1279         _isExcludedFromFee[account] = false;
1280     }
1281 
1282     function excludeFromLimit(address account) public onlyOwner {
1283         _isExcludedFromLimit[account] = true;
1284     }
1285 
1286     function includeInLimit(address account) public onlyOwner {
1287         _isExcludedFromLimit[account] = false;
1288     }
1289 
1290     function setSellFee(
1291         uint16 tax,
1292         uint16 liquidity,
1293         uint16 marketing,
1294         uint16 dev,
1295         uint16 donation
1296     ) external onlyOwner {
1297         sellFee.tax = tax;
1298         sellFee.marketing = marketing;
1299         sellFee.liquidity = liquidity;
1300         sellFee.dev = dev;
1301         sellFee.donation = donation;
1302     }
1303 
1304     function setBuyFee(
1305         uint16 tax,
1306         uint16 liquidity,
1307         uint16 marketing,
1308         uint16 dev,
1309         uint16 donation
1310     ) external onlyOwner {
1311         buyFee.tax = tax;
1312         buyFee.marketing = marketing;
1313         buyFee.liquidity = liquidity;
1314         buyFee.dev = dev;
1315         buyFee.donation = donation;
1316     }
1317 
1318     function setBothFees(
1319         uint16 buy_tax,
1320         uint16 buy_liquidity,
1321         uint16 buy_marketing,
1322         uint16 buy_dev,
1323         uint16 buy_donation,
1324         uint16 sell_tax,
1325         uint16 sell_liquidity,
1326         uint16 sell_marketing,
1327         uint16 sell_dev,
1328         uint16 sell_donation
1329 
1330     ) external onlyOwner {
1331         buyFee.tax = buy_tax;
1332         buyFee.marketing = buy_marketing;
1333         buyFee.liquidity = buy_liquidity;
1334         buyFee.dev = buy_dev;
1335         buyFee.donation = buy_donation;
1336 
1337         sellFee.tax = sell_tax;
1338         sellFee.marketing = sell_marketing;
1339         sellFee.liquidity = sell_liquidity;
1340         sellFee.dev = sell_dev;
1341         sellFee.donation = sell_donation;
1342     }
1343 
1344     function setNumTokensSellToAddToLiquidity(uint256 numTokens) external onlyOwner {
1345         numTokensSellToAddToLiquidity = numTokens;
1346     }
1347 
1348     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner {
1349         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**3);
1350     }
1351 
1352     function _setMaxWalletSizePercent(uint256 maxWalletSize)
1353         external
1354         onlyOwner
1355     {
1356         _maxWalletSize = _tTotal.mul(maxWalletSize).div(10**3);
1357     }
1358 
1359     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1360         swapAndLiquifyEnabled = _enabled;
1361         emit SwapAndLiquifyEnabledUpdated(_enabled);
1362     }
1363 
1364     //to recieve ETH from uniswapV2Router when swapping
1365     receive() external payable {}
1366 
1367     function _reflectFee(uint256 rFee, uint256 tFee) private {
1368         _rTotal = _rTotal.sub(rFee);
1369         _tFeeTotal = _tFeeTotal.add(tFee);
1370     }
1371 
1372     function _getTValues(uint256 tAmount)
1373         private
1374         view
1375         returns (
1376             uint256,
1377             uint256,
1378             uint256,
1379             uint256,
1380             uint256
1381         )
1382     {
1383         uint256 tFee = calculateTaxFee(tAmount);
1384         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1385         uint256 tWallet = calculateMarketingFee(tAmount) +
1386             calculateDevFee(tAmount);
1387         uint256 tDonation = calculateDonationFee(tAmount);
1388         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1389         tTransferAmount = tTransferAmount.sub(tWallet);
1390         tTransferAmount = tTransferAmount.sub(tDonation);
1391 
1392         return (tTransferAmount, tFee, tLiquidity, tWallet, tDonation);
1393     }
1394 
1395     function _getRValues(
1396         uint256 tAmount,
1397         uint256 tFee,
1398         uint256 tLiquidity,
1399         uint256 tWallet,
1400         uint256 tDonation,
1401         uint256 currentRate
1402     )
1403         private
1404         pure
1405         returns (
1406             uint256,
1407             uint256,
1408             uint256
1409         )
1410     {
1411         uint256 rAmount = tAmount.mul(currentRate);
1412         uint256 rFee = tFee.mul(currentRate);
1413         uint256 rLiquidity = tLiquidity.mul(currentRate);
1414         uint256 rWallet = tWallet.mul(currentRate);
1415         uint256 rDonation = tDonation.mul(currentRate);
1416         uint256 rTransferAmount = rAmount
1417             .sub(rFee)
1418             .sub(rLiquidity)
1419             .sub(rWallet)
1420             .sub(rDonation);
1421         return (rAmount, rTransferAmount, rFee);
1422     }
1423 
1424     function _getRate() private view returns (uint256) {
1425         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1426         return rSupply.div(tSupply);
1427     }
1428 
1429     function _getCurrentSupply() private view returns (uint256, uint256) {
1430         uint256 rSupply = _rTotal;
1431         uint256 tSupply = _tTotal;
1432         for (uint256 i = 0; i < _excluded.length; i++) {
1433             if (
1434                 _rOwned[_excluded[i]] > rSupply ||
1435                 _tOwned[_excluded[i]] > tSupply
1436             ) return (_rTotal, _tTotal);
1437             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1438             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1439         }
1440         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1441         return (rSupply, tSupply);
1442     }
1443 
1444     function _takeLiquidity(uint256 tLiquidity) private {
1445         uint256 currentRate = _getRate();
1446         uint256 rLiquidity = tLiquidity.mul(currentRate);
1447         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1448         if (_isExcluded[address(this)])
1449             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1450     }
1451 
1452     function _takeWalletFee(uint256 tWallet) private {
1453         uint256 currentRate = _getRate();
1454         uint256 rWallet = tWallet.mul(currentRate);
1455         _rOwned[address(this)] = _rOwned[address(this)].add(rWallet);
1456         if (_isExcluded[address(this)])
1457             _tOwned[address(this)] = _tOwned[address(this)].add(tWallet);
1458     }
1459 
1460     function _takeDonationFee(uint256 tDonation) private {
1461         uint256 currentRate = _getRate();
1462         uint256 rDonation = tDonation.mul(currentRate);
1463         _rOwned[_donationAddress] = _rOwned[_donationAddress].add(rDonation);
1464         if (_isExcluded[_donationAddress])
1465             _tOwned[_donationAddress] = _tOwned[_donationAddress].add(
1466                 tDonation
1467             );
1468     }
1469 
1470     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1471         return _amount.mul(_taxFee).div(10**2);
1472     }
1473 
1474     function calculateLiquidityFee(uint256 _amount)
1475         private
1476         view
1477         returns (uint256)
1478     {
1479         return _amount.mul(_liquidityFee).div(10**2);
1480     }
1481 
1482     function calculateMarketingFee(uint256 _amount)
1483         private
1484         view
1485         returns (uint256)
1486     {
1487         return _amount.mul(_marketingFee).div(10**2);
1488     }
1489 
1490     function calculateDonationFee(uint256 _amount)
1491         private
1492         view
1493         returns (uint256)
1494     {
1495         return _amount.mul(_donationFee).div(10**2);
1496     }
1497 
1498     function calculateDevFee(uint256 _amount) private view returns (uint256) {
1499         return _amount.mul(_devFee).div(10**2);
1500     }
1501 
1502     function removeAllFee() private {
1503         _taxFee = 0;
1504         _liquidityFee = 0;
1505         _marketingFee = 0;
1506         _donationFee = 0;
1507         _devFee = 0;
1508     }
1509 
1510     function setBuy() private {
1511         _taxFee = buyFee.tax;
1512         _liquidityFee = buyFee.liquidity;
1513         _marketingFee = buyFee.marketing;
1514         _donationFee = buyFee.donation;
1515         _devFee = buyFee.dev;
1516     }
1517 
1518     function setSell() private {
1519         _taxFee = sellFee.tax;
1520         _liquidityFee = sellFee.liquidity;
1521         _marketingFee = sellFee.marketing;
1522         _donationFee = sellFee.donation;
1523         _devFee = sellFee.dev;
1524     }
1525 
1526     function isExcludedFromFee(address account) public view returns (bool) {
1527         return _isExcludedFromFee[account];
1528     }
1529 
1530     function isExcludedFromLimit(address account) public view returns (bool) {
1531         return _isExcludedFromLimit[account];
1532     }
1533 
1534     function _approve(
1535         address owner,
1536         address spender,
1537         uint256 amount
1538     ) private {
1539         require(owner != address(0), "ERC20: approve from the zero address");
1540         require(spender != address(0), "ERC20: approve to the zero address");
1541 
1542         _allowances[owner][spender] = amount;
1543         emit Approval(owner, spender, amount);
1544     }
1545 
1546     function _transfer(
1547         address from,
1548         address to,
1549         uint256 amount
1550     ) private {
1551         require(from != address(0), "ERC20: transfer from the zero address");
1552         require(to != address(0), "ERC20: transfer to the zero address");
1553         require(amount > 0, "Transfer amount must be greater than zero");
1554         require(!_isBlackListedBot[from], "You are blacklisted");
1555         require(!_isBlackListedBot[msg.sender], "blacklisted");
1556         require(!_isBlackListedBot[tx.origin], "blacklisted");
1557 
1558         // is the token balance of this contract address over the min number of
1559         // tokens that we need to initiate a swap + liquidity lock?
1560         // also, don't get caught in a circular liquidity event.
1561         // also, don't swap & liquify if sender is uniswap pair.
1562         uint256 contractTokenBalance = balanceOf(address(this));
1563 
1564         if (contractTokenBalance >= _maxTxAmount) {
1565             contractTokenBalance = _maxTxAmount;
1566         }
1567 
1568         bool overMinTokenBalance = contractTokenBalance >=
1569             numTokensSellToAddToLiquidity;
1570         if (
1571             overMinTokenBalance &&
1572             !inSwapAndLiquify &&
1573             from != uniswapV2Pair &&
1574             swapAndLiquifyEnabled
1575         ) {
1576             contractTokenBalance = numTokensSellToAddToLiquidity;
1577             //add liquidity
1578             swapAndLiquify(contractTokenBalance);
1579         }
1580 
1581         //indicates if fee should be deducted from transfer
1582         bool takeFee = true;
1583 
1584         //if any account belongs to _isExcludedFromFee account then remove the fee
1585         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1586             takeFee = false;
1587         }
1588         if (takeFee) {
1589             if (!_isExcludedFromLimit[from] && !_isExcludedFromLimit[to]) {
1590                 require(
1591                     amount <= _maxTxAmount,
1592                     "Transfer amount exceeds the maxTxAmount."
1593                 );
1594                 if (to != uniswapV2Pair) {
1595                     require(
1596                         amount + balanceOf(to) <= _maxWalletSize,
1597                         "Recipient exceeds max wallet size."
1598                     );
1599                 }
1600             }
1601         }
1602 
1603         //transfer amount, it will take tax, burn, liquidity fee
1604         _tokenTransfer(from, to, amount, takeFee);
1605     }
1606 
1607     function swapAndLiquify(uint256 tokens) private lockTheSwap {
1608         // Split the contract balance into halves
1609         uint256 denominator = (buyFee.liquidity +
1610             sellFee.liquidity +
1611             buyFee.marketing +
1612             sellFee.marketing +
1613             buyFee.dev +
1614             sellFee.dev) * 2;
1615         uint256 tokensToAddLiquidityWith = (tokens *
1616             (buyFee.liquidity + sellFee.liquidity)) / denominator;
1617         uint256 toSwap = tokens - tokensToAddLiquidityWith;
1618 
1619         uint256 initialBalance = address(this).balance;
1620 
1621         swapTokensForEth(toSwap);
1622 
1623         uint256 deltaBalance = address(this).balance - initialBalance;
1624         uint256 unitBalance = deltaBalance /
1625             (denominator - (buyFee.liquidity + sellFee.liquidity));
1626         uint256 bnbToAddLiquidityWith = unitBalance *
1627             (buyFee.liquidity + sellFee.liquidity);
1628 
1629         if (bnbToAddLiquidityWith > 0) {
1630             // Add liquidity to pancake
1631             addLiquidity(tokensToAddLiquidityWith, bnbToAddLiquidityWith);
1632         }
1633 
1634         // Send ETH to marketing
1635         uint256 marketingAmt = unitBalance *
1636             2 *
1637             (buyFee.marketing + sellFee.marketing);
1638         uint256 devAmt = unitBalance * 2 * (buyFee.dev + sellFee.dev) >
1639             address(this).balance
1640             ? address(this).balance
1641             : unitBalance * 2 * (buyFee.dev + sellFee.dev);
1642 
1643         if (marketingAmt > 0) {
1644             payable(_marketingAddress).transfer(marketingAmt);
1645         }
1646 
1647         if (devAmt > 0) {
1648             _devwallet.transfer(devAmt);
1649         }
1650     }
1651 
1652     function swapTokensForEth(uint256 tokenAmount) private {
1653         // generate the uniswap pair path of token -> weth
1654         address[] memory path = new address[](2);
1655         path[0] = address(this);
1656         path[1] = uniswapV2Router.WETH();
1657 
1658         _approve(address(this), address(uniswapV2Router), tokenAmount);
1659 
1660         // make the swap
1661         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1662             tokenAmount,
1663             0, // accept any amount of ETH
1664             path,
1665             address(this),
1666             block.timestamp
1667         );
1668     }
1669 
1670     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1671         // approve token transfer to cover all possible scenarios
1672         _approve(address(this), address(uniswapV2Router), tokenAmount);
1673 
1674         // add the liquidity
1675         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1676             address(this),
1677             tokenAmount,
1678             0, // slippage is unavoidable
1679             0, // slippage is unavoidable
1680             address(this),
1681             block.timestamp
1682         );
1683     }
1684 
1685     //this method is responsible for taking all fee, if takeFee is true
1686     function _tokenTransfer(
1687         address sender,
1688         address recipient,
1689         uint256 amount,
1690         bool takeFee
1691     ) private {
1692         if (takeFee) {
1693             removeAllFee();
1694             if (sender == uniswapV2Pair) {
1695                 setBuy();
1696             }
1697             if (recipient == uniswapV2Pair) {
1698                 setSell();
1699             }
1700         }
1701 
1702         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1703             _transferFromExcluded(sender, recipient, amount);
1704         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1705             _transferToExcluded(sender, recipient, amount);
1706         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1707             _transferStandard(sender, recipient, amount);
1708         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1709             _transferBothExcluded(sender, recipient, amount);
1710         } else {
1711             _transferStandard(sender, recipient, amount);
1712         }
1713         removeAllFee();
1714     }
1715 
1716     function _transferStandard(
1717         address sender,
1718         address recipient,
1719         uint256 tAmount
1720     ) private {
1721         (
1722             uint256 tTransferAmount,
1723             uint256 tFee,
1724             uint256 tLiquidity,
1725             uint256 tWallet,
1726             uint256 tDonation
1727         ) = _getTValues(tAmount);
1728         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1729             tAmount,
1730             tFee,
1731             tLiquidity,
1732             tWallet,
1733             tDonation,
1734             _getRate()
1735         );
1736 
1737         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1738         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1739         _takeLiquidity(tLiquidity);
1740         _takeWalletFee(tWallet);
1741         _takeDonationFee(tDonation);
1742         _reflectFee(rFee, tFee);
1743         emit Transfer(sender, recipient, tTransferAmount);
1744     }
1745 
1746 
1747     function _transferToExcluded(
1748         address sender,
1749         address recipient,
1750         uint256 tAmount
1751     ) private {
1752         (
1753             uint256 tTransferAmount,
1754             uint256 tFee,
1755             uint256 tLiquidity,
1756             uint256 tWallet,
1757             uint256 tDonation
1758         ) = _getTValues(tAmount);
1759         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1760             tAmount,
1761             tFee,
1762             tLiquidity,
1763             tWallet,
1764             tDonation,
1765             _getRate()
1766         );
1767 
1768         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1769         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1770         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1771         _takeLiquidity(tLiquidity);
1772         _takeWalletFee(tWallet);
1773         _takeDonationFee(tDonation);
1774         _reflectFee(rFee, tFee);
1775         emit Transfer(sender, recipient, tTransferAmount);
1776     }
1777 
1778     function _transferFromExcluded(
1779         address sender,
1780         address recipient,
1781         uint256 tAmount
1782     ) private {
1783         (
1784             uint256 tTransferAmount,
1785             uint256 tFee,
1786             uint256 tLiquidity,
1787             uint256 tWallet,
1788             uint256 tDonation
1789         ) = _getTValues(tAmount);
1790         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1791             tAmount,
1792             tFee,
1793             tLiquidity,
1794             tWallet,
1795             tDonation,
1796             _getRate()
1797         );
1798 
1799         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1800         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1801         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1802         _takeLiquidity(tLiquidity);
1803         _takeWalletFee(tWallet);
1804         _takeDonationFee(tDonation);
1805         _reflectFee(rFee, tFee);
1806         emit Transfer(sender, recipient, tTransferAmount);
1807     }
1808 
1809     function _transferBothExcluded(
1810         address sender,
1811         address recipient,
1812         uint256 tAmount
1813     ) private {
1814         (
1815             uint256 tTransferAmount,
1816             uint256 tFee,
1817             uint256 tLiquidity,
1818             uint256 tWallet,
1819             uint256 tDonation
1820         ) = _getTValues(tAmount);
1821         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1822             tAmount,
1823             tFee,
1824             tLiquidity,
1825             tWallet,
1826             tDonation,
1827             _getRate()
1828         );
1829 
1830         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1831         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1832         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1833         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1834         _takeLiquidity(tLiquidity);
1835         _takeWalletFee(tWallet);
1836         _takeDonationFee(tDonation);
1837         _reflectFee(rFee, tFee);
1838         emit Transfer(sender, recipient, tTransferAmount);
1839     }
1840 }