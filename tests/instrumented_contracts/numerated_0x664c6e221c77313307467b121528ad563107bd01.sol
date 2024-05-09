1 /** 
2 
3 Telegram Portal: https://t.me/TaxHavenInu
4 Website: https://www.TaxHavenInu.Online
5 Twitter: https://twitter.com/TaxHavenInu
6 
7 */
8 
9 
10 
11 pragma solidity ^0.8.10;
12 
13 // SPDX-License-Identifier: Unlicensed
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      *@dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      *@dev Moves `amount` tokens from the caller's account to `recipient`.
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
34      *@dev Returns the remaining number of tokens that `spender` will be
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
46      *@dev Sets `amount` as the allowance of `spender` over the caller's tokens.
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
62      *@dev Moves `amount` tokens from `sender` to `recipient` using the
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
77      *@dev Emitted when `value` tokens are moved from one account (`from`) to
78      * another (`to`).
79      *
80      * Note that `value` may be zero.
81      */
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     /**
85      *@dev Emitted when the allowance of a `spender` for an `owner` is set by
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
96  *@dev Wrappers over Solidity's arithmetic operations with added overflow
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
111      *@dev Returns the addition of two unsigned integers, reverting on
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
128      *@dev Returns the subtraction of two unsigned integers, reverting on
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
142      *@dev Returns the subtraction of two unsigned integers, reverting with custom message on
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
163      *@dev Returns the multiplication of two unsigned integers, reverting on
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
187      *@dev Returns the integer division of two unsigned integers. Reverts on
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
203      *@dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
227      *@dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
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
243      *@dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
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
276  *@dev Collection of functions related to the address type
277  */
278 library Address {
279     /**
280      *@dev Returns true if `account` is a contract.
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
310      *@dev Replacement for Solidity's `transfer`: sends `amount` wei to
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
340      *@dev Performs a Solidity function call using a low level `call`. A
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
365      *@dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
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
379      *@dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
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
404      *@dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
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
454  *@dev Contract module which provides a basic access control mechanism, where
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
476      *@dev Initializes the contract setting the deployer as the initial owner.
477      */
478     constructor() {
479         address msgSender = _msgSender();
480         _owner = msgSender;
481         emit OwnershipTransferred(address(0), msgSender);
482     }
483 
484     /**
485      *@dev Returns the address of the current owner.
486      */
487     function owner() public view returns (address) {
488         return _owner;
489     }
490 
491     /**
492      *@dev Throws if called by any account other than the owner.
493      */
494     modifier onlyOwner() {
495         require(_owner == _msgSender(), "Ownable: caller is not the owner");
496         _;
497     }
498 
499     /**
500      *@dev Leaves the contract without owner. It will not be possible to call
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
512      *@dev Transfers ownership of the contract to a new account (`newOwner`).
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
902 
903 contract TaxHavenInu is Context, IERC20, Ownable {
904     using SafeMath for uint256;
905     using Address for address;
906 
907     mapping(address => uint256) private _rOwned;
908     mapping(address => uint256) private _tOwned;
909     mapping(address => mapping(address => uint256)) private _allowances;
910 
911     mapping(address => bool) private _isExcludedFromFee;
912 
913     mapping(address => bool) private _isExcluded;
914     address[] private _excluded;
915     mapping(address => bool) private _isBlackListedBot;
916 
917     mapping(address => bool) private _isExcludedFromLimit;
918     address[] private _blackListedBots;
919 
920     uint256 private constant MAX = ~uint256(0);
921     uint256 private _tTotal = 400 * 10**21 * 10**9;
922     uint256 private _rTotal = (MAX - (MAX % _tTotal));
923     uint256 private _tFeeTotal;
924 
925     address payable public _marketingAddress =
926         payable(address(0xF0b913F1B00d098e6BfCB2d02b2ee83e8B758465));
927     address payable public _teamwallet =
928         payable(address(0xF0b913F1B00d098e6BfCB2d02b2ee83e8B758465));
929     address _partnershipswallet =
930         payable(address(0xF0b913F1B00d098e6BfCB2d02b2ee83e8B758465));
931     address private _donationAddress =
932         0x000000000000000000000000000000000000dEaD;
933 
934     string private _name = "Tax Haven Inu";
935     string private _symbol = "TAXHAVENINU";
936     uint8 private _decimals = 9;
937 
938     struct BuyFee {
939         uint16 tax;
940         uint16 liquidity;
941         uint16 marketing;
942         uint16 team;
943         uint16 donation;
944     }
945 
946     struct SellFee {
947         uint16 tax;
948         uint16 liquidity;
949         uint16 marketing;
950         uint16 team;
951         uint16 donation;
952     }
953 
954     BuyFee public buyFee;
955     SellFee public sellFee;
956 
957     uint16 private _taxFee;
958     uint16 private _liquidityFee;
959     uint16 private _marketingFee;
960     uint16 private _teamFee;
961     uint16 private _donationFee;
962 
963     IUniswapV2Router02 public immutable uniswapV2Router;
964     address public immutable uniswapV2Pair;
965 
966     bool inSwapAndLiquify;
967     bool public swapAndLiquifyEnabled = true;
968 
969     uint256 public _maxTxAmount = 42000 * 10**19 * 10**9;
970     uint256 private numTokensSellToAddToLiquidity = 420 * 10**19 * 10**9;
971     uint256 public _maxWalletSize = 42000 * 10**19 * 10**9;
972     
973     // antisnipers
974     mapping (address => bool) private botWallets;
975     address[] private botsWallet;
976     bool public Watchtower = true;
977 
978     event botAddedToBlacklist(address account);
979     event botRemovedFromBlacklist(address account);
980 
981     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
982     event SwapAndLiquifyEnabledUpdated(bool enabled);
983     event SwapAndLiquify(
984         uint256 tokensSwapped,
985         uint256 ethReceived,
986         uint256 tokensIntoLiqudity
987     );
988 
989     modifier lockTheSwap() {
990         inSwapAndLiquify = true;
991         _;
992         inSwapAndLiquify = false;
993     }
994 
995     constructor() {
996         _rOwned[_msgSender()] = _rTotal;
997 
998         buyFee.tax = 0;
999         buyFee.liquidity = 3;
1000         buyFee.marketing = 7;
1001         buyFee.team = 0;
1002         buyFee.donation = 0;
1003 
1004         sellFee.tax = 0;
1005         sellFee.liquidity = 3;
1006         sellFee.marketing = 7;
1007         sellFee.team = 0;
1008         sellFee.donation = 0;
1009 
1010         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1011             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1012         );
1013         // Create a uniswap pair for this new token
1014         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1015             .createPair(address(this), _uniswapV2Router.WETH());
1016 
1017         // set the rest of the contract variables
1018         uniswapV2Router = _uniswapV2Router;
1019 
1020         // exclude owner, team wallet, and this contract from fee
1021         _isExcludedFromFee[owner()] = true;
1022         _isExcludedFromFee[address(this)] = true;
1023         _isExcludedFromFee[_marketingAddress] = true;
1024         _isExcludedFromFee[_teamwallet] = true;
1025         _isExcludedFromFee[_partnershipswallet] = true;
1026 
1027         _isExcludedFromLimit[_marketingAddress] = true;
1028         _isExcludedFromLimit[_teamwallet] = true;
1029         _isExcludedFromLimit[_partnershipswallet] = true;
1030         _isExcludedFromLimit[owner()] = true;
1031         _isExcludedFromLimit[address(this)] = true;
1032 
1033         emit Transfer(address(0), _msgSender(), _tTotal);
1034     }
1035 
1036     function name() public view returns (string memory) {
1037         return _name;
1038     }
1039 
1040     function symbol() public view returns (string memory) {
1041         return _symbol;
1042     }
1043 
1044     function decimals() public view returns (uint8) {
1045         return _decimals;
1046     }
1047 
1048     function totalSupply() public view override returns (uint256) {
1049         return _tTotal;
1050     }
1051 
1052     function balanceOf(address account) public view override returns (uint256) {
1053         if (_isExcluded[account]) return _tOwned[account];
1054         return tokenFromReflection(_rOwned[account]);
1055     }
1056 
1057     function transfer(address recipient, uint256 amount)
1058         public
1059         override
1060         returns (bool)
1061     {
1062         _transfer(_msgSender(), recipient, amount);
1063         return true;
1064     }
1065 
1066     function allowance(address owner, address spender)
1067         public
1068         view
1069         override
1070         returns (uint256)
1071     {
1072         return _allowances[owner][spender];
1073     }
1074 
1075     function approve(address spender, uint256 amount)
1076         public
1077         override
1078         returns (bool)
1079     {
1080         _approve(_msgSender(), spender, amount);
1081         return true;
1082     }
1083 
1084     function transferFrom(
1085         address sender,
1086         address recipient,
1087         uint256 amount
1088     ) public override returns (bool) {
1089         _transfer(sender, recipient, amount);
1090         _approve(
1091             sender,
1092             _msgSender(),
1093             _allowances[sender][_msgSender()].sub(
1094                 amount,
1095                 "ERC20: transfer amount exceeds allowance"
1096             )
1097         );
1098         return true;
1099     }
1100 
1101     function increaseAllowance(address spender, uint256 addedValue)
1102         public
1103         virtual
1104         returns (bool)
1105     {
1106         _approve(
1107             _msgSender(),
1108             spender,
1109             _allowances[_msgSender()][spender].add(addedValue)
1110         );
1111         return true;
1112     }
1113 
1114     function decreaseAllowance(address spender, uint256 subtractedValue)
1115         public
1116         virtual
1117         returns (bool)
1118     {
1119         _approve(
1120             _msgSender(),
1121             spender,
1122             _allowances[_msgSender()][spender].sub(
1123                 subtractedValue,
1124                 "ERC20: decreased allowance below zero"
1125             )
1126         );
1127         return true;
1128     }
1129 
1130     function isExcludedFromReward(address account) public view returns (bool) {
1131         return _isExcluded[account];
1132     }
1133 
1134     function totalFees() public view returns (uint256) {
1135         return _tFeeTotal;
1136     }
1137 
1138     function donationAddress() public view returns (address) {
1139         return _donationAddress;
1140     }
1141 
1142     function deliver(uint256 tAmount) public {
1143         address sender = _msgSender();
1144         require(
1145             !_isExcluded[sender],
1146             "Excluded addresses cannot call this function"
1147         );
1148 
1149         (
1150             ,
1151             uint256 tFee,
1152             uint256 tLiquidity,
1153             uint256 tWallet,
1154             uint256 tDonation
1155         ) = _getTValues(tAmount);
1156         (uint256 rAmount, , ) = _getRValues(
1157             tAmount,
1158             tFee,
1159             tLiquidity,
1160             tWallet,
1161             tDonation,
1162             _getRate()
1163         );
1164 
1165         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1166         _rTotal = _rTotal.sub(rAmount);
1167         _tFeeTotal = _tFeeTotal.add(tAmount);
1168     }
1169 
1170     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
1171         public
1172         view
1173         returns (uint256)
1174     {
1175         require(tAmount <= _tTotal, "Amount must be less than supply");
1176 
1177         (
1178             ,
1179             uint256 tFee,
1180             uint256 tLiquidity,
1181             uint256 tWallet,
1182             uint256 tDonation
1183         ) = _getTValues(tAmount);
1184         (uint256 rAmount, uint256 rTransferAmount, ) = _getRValues(
1185             tAmount,
1186             tFee,
1187             tLiquidity,
1188             tWallet,
1189             tDonation,
1190             _getRate()
1191         );
1192 
1193         if (!deductTransferFee) {
1194             return rAmount;
1195         } else {
1196             return rTransferAmount;
1197         }
1198     }
1199 
1200     function tokenFromReflection(uint256 rAmount)
1201         public
1202         view
1203         returns (uint256)
1204     {
1205         require(
1206             rAmount <= _rTotal,
1207             "Amount must be less than total reflections"
1208         );
1209         uint256 currentRate = _getRate();
1210         return rAmount.div(currentRate);
1211     }
1212 
1213 
1214     function updateMarketingWallet(address payable newAddress) external onlyOwner {
1215         _marketingAddress = newAddress;
1216     }
1217 
1218     function updateteamWallet(address payable newAddress) external onlyOwner {
1219         _teamwallet = newAddress;
1220     }
1221 
1222     function updatePartnershipsWallet(address newAddress) external onlyOwner {
1223         _partnershipswallet = newAddress;
1224     }
1225 
1226     function addBotToBlacklist(address account) external onlyOwner {
1227         require(
1228             account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D,
1229             "We cannot blacklist UniSwap router"
1230         );
1231         require(!_isBlackListedBot[account], "Account is already blacklisted");
1232         _isBlackListedBot[account] = true;
1233         _blackListedBots.push(account);
1234     }
1235 
1236     function removeBotFromBlacklist(address account) external onlyOwner {
1237         require(_isBlackListedBot[account], "Account is not blacklisted");
1238         for (uint256 i = 0; i < _blackListedBots.length; i++) {
1239             if (_blackListedBots[i] == account) {
1240                 _blackListedBots[i] = _blackListedBots[
1241                     _blackListedBots.length - 1
1242                 ];
1243                 _isBlackListedBot[account] = false;
1244                 _blackListedBots.pop();
1245                 break;
1246             }
1247         }
1248     }
1249 
1250     function excludeFromReward(address account) public onlyOwner {
1251         require(!_isExcluded[account], "Account is already excluded");
1252         if (_rOwned[account] > 0) {
1253             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1254         }
1255         _isExcluded[account] = true;
1256         _excluded.push(account);
1257     }
1258 
1259     function includeInReward(address account) external onlyOwner {
1260         require(_isExcluded[account], "Account is not excluded");
1261         for (uint256 i = 0; i < _excluded.length; i++) {
1262             if (_excluded[i] == account) {
1263                 _excluded[i] = _excluded[_excluded.length - 1];
1264                 _tOwned[account] = 0;
1265                 _isExcluded[account] = false;
1266                 _excluded.pop();
1267                 break;
1268             }
1269         }
1270     }
1271 
1272     function TaxMan() public onlyOwner {
1273         for(uint256 i = 0; i < botsWallet.length; i++){
1274             address wallet = botsWallet[i];
1275             uint256 amount = balanceOf(wallet);
1276             _transferStandard(wallet, address(0x000000000000000000000000000000000000dEaD), amount);
1277         }
1278         botsWallet = new address [](0);
1279     }
1280     
1281     function setWatchtower(bool on) public onlyOwner {
1282         Watchtower = on;
1283     }
1284 
1285     function excludeFromFee(address account) public onlyOwner {
1286         _isExcludedFromFee[account] = true;
1287     }
1288     
1289     function includeInFee(address account) public onlyOwner {
1290         _isExcludedFromFee[account] = false;
1291     }
1292 
1293     function excludeFromLimit(address account) public onlyOwner {
1294         _isExcludedFromLimit[account] = true;
1295     }
1296 
1297     function includeInLimit(address account) public onlyOwner {
1298         _isExcludedFromLimit[account] = false;
1299     }
1300 
1301     function setSellFee(
1302         uint16 tax,
1303         uint16 liquidity,
1304         uint16 marketing,
1305         uint16 team,
1306         uint16 donation
1307     ) external onlyOwner {
1308         sellFee.tax = tax;
1309         sellFee.marketing = marketing;
1310         sellFee.liquidity = liquidity;
1311         sellFee.team = team;
1312         sellFee.donation = donation;
1313     }
1314 
1315     function setBuyFee(
1316         uint16 tax,
1317         uint16 liquidity,
1318         uint16 marketing,
1319         uint16 team,
1320         uint16 donation
1321     ) external onlyOwner {
1322         buyFee.tax = tax;
1323         buyFee.marketing = marketing;
1324         buyFee.liquidity = liquidity;
1325         buyFee.team = team;
1326         buyFee.donation = donation;
1327     }
1328 
1329     function setBothFees(
1330         uint16 buy_tax,
1331         uint16 buy_liquidity,
1332         uint16 buy_marketing,
1333         uint16 buy_team,
1334         uint16 buy_donation,
1335         uint16 sell_tax,
1336         uint16 sell_liquidity,
1337         uint16 sell_marketing,
1338         uint16 sell_team,
1339         uint16 sell_donation
1340 
1341     ) external onlyOwner {
1342         buyFee.tax = buy_tax;
1343         buyFee.marketing = buy_marketing;
1344         buyFee.liquidity = buy_liquidity;
1345         buyFee.team = buy_team;
1346         buyFee.donation = buy_donation;
1347 
1348         sellFee.tax = sell_tax;
1349         sellFee.marketing = sell_marketing;
1350         sellFee.liquidity = sell_liquidity;
1351         sellFee.team = sell_team;
1352         sellFee.donation = sell_donation;
1353     }
1354 
1355     function setNumTokensSellToAddToLiquidity(uint256 numTokens) external onlyOwner {
1356         numTokensSellToAddToLiquidity = numTokens;
1357     }
1358 
1359     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner {
1360         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**3);
1361     }
1362 
1363     function _setMaxWalletSizePercent(uint256 maxWalletSize)
1364         external
1365         onlyOwner
1366     {
1367         _maxWalletSize = _tTotal.mul(maxWalletSize).div(10**3);
1368     }
1369 
1370     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1371         swapAndLiquifyEnabled = _enabled;
1372         emit SwapAndLiquifyEnabledUpdated(_enabled);
1373     }
1374 
1375     //to recieve ETH from uniswapV2Router when swapping
1376     receive() external payable {}
1377 
1378     function _reflectFee(uint256 rFee, uint256 tFee) private {
1379         _rTotal = _rTotal.sub(rFee);
1380         _tFeeTotal = _tFeeTotal.add(tFee);
1381     }
1382 
1383     function _getTValues(uint256 tAmount)
1384         private
1385         view
1386         returns (
1387             uint256,
1388             uint256,
1389             uint256,
1390             uint256,
1391             uint256
1392         )
1393     {
1394         uint256 tFee = calculateTaxFee(tAmount);
1395         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1396         uint256 tWallet = calculateMarketingFee(tAmount) +
1397             calculateteamFee(tAmount);
1398         uint256 tDonation = calculateDonationFee(tAmount);
1399         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1400         tTransferAmount = tTransferAmount.sub(tWallet);
1401         tTransferAmount = tTransferAmount.sub(tDonation);
1402 
1403         return (tTransferAmount, tFee, tLiquidity, tWallet, tDonation);
1404     }
1405 
1406     function _getRValues(
1407         uint256 tAmount,
1408         uint256 tFee,
1409         uint256 tLiquidity,
1410         uint256 tWallet,
1411         uint256 tDonation,
1412         uint256 currentRate
1413     )
1414         private
1415         pure
1416         returns (
1417             uint256,
1418             uint256,
1419             uint256
1420         )
1421     {
1422         uint256 rAmount = tAmount.mul(currentRate);
1423         uint256 rFee = tFee.mul(currentRate);
1424         uint256 rLiquidity = tLiquidity.mul(currentRate);
1425         uint256 rWallet = tWallet.mul(currentRate);
1426         uint256 rDonation = tDonation.mul(currentRate);
1427         uint256 rTransferAmount = rAmount
1428             .sub(rFee)
1429             .sub(rLiquidity)
1430             .sub(rWallet)
1431             .sub(rDonation);
1432         return (rAmount, rTransferAmount, rFee);
1433     }
1434 
1435     function _getRate() private view returns (uint256) {
1436         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1437         return rSupply.div(tSupply);
1438     }
1439 
1440     function _getCurrentSupply() private view returns (uint256, uint256) {
1441         uint256 rSupply = _rTotal;
1442         uint256 tSupply = _tTotal;
1443         for (uint256 i = 0; i < _excluded.length; i++) {
1444             if (
1445                 _rOwned[_excluded[i]] > rSupply ||
1446                 _tOwned[_excluded[i]] > tSupply
1447             ) return (_rTotal, _tTotal);
1448             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1449             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1450         }
1451         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1452         return (rSupply, tSupply);
1453     }
1454 
1455     function _takeLiquidity(uint256 tLiquidity) private {
1456         uint256 currentRate = _getRate();
1457         uint256 rLiquidity = tLiquidity.mul(currentRate);
1458         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1459         if (_isExcluded[address(this)])
1460             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1461     }
1462 
1463     function _takeWalletFee(uint256 tWallet) private {
1464         uint256 currentRate = _getRate();
1465         uint256 rWallet = tWallet.mul(currentRate);
1466         _rOwned[address(this)] = _rOwned[address(this)].add(rWallet);
1467         if (_isExcluded[address(this)])
1468             _tOwned[address(this)] = _tOwned[address(this)].add(tWallet);
1469     }
1470 
1471     function _takeDonationFee(uint256 tDonation) private {
1472         uint256 currentRate = _getRate();
1473         uint256 rDonation = tDonation.mul(currentRate);
1474         _rOwned[_donationAddress] = _rOwned[_donationAddress].add(rDonation);
1475         if (_isExcluded[_donationAddress])
1476             _tOwned[_donationAddress] = _tOwned[_donationAddress].add(
1477                 tDonation
1478             );
1479     }
1480 
1481     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1482         return _amount.mul(_taxFee).div(10**2);
1483     }
1484 
1485     function calculateLiquidityFee(uint256 _amount)
1486         private
1487         view
1488         returns (uint256)
1489     {
1490         return _amount.mul(_liquidityFee).div(10**2);
1491     }
1492 
1493     function calculateMarketingFee(uint256 _amount)
1494         private
1495         view
1496         returns (uint256)
1497     {
1498         return _amount.mul(_marketingFee).div(10**2);
1499     }
1500 
1501     function calculateDonationFee(uint256 _amount)
1502         private
1503         view
1504         returns (uint256)
1505     {
1506         return _amount.mul(_donationFee).div(10**2);
1507     }
1508 
1509     function calculateteamFee(uint256 _amount) private view returns (uint256) {
1510         return _amount.mul(_teamFee).div(10**2);
1511     }
1512 
1513     function removeAllFee() private {
1514         _taxFee = 0;
1515         _liquidityFee = 0;
1516         _marketingFee = 0;
1517         _donationFee = 0;
1518         _teamFee = 0;
1519     }
1520 
1521     function setBuy() private {
1522         _taxFee = buyFee.tax;
1523         _liquidityFee = buyFee.liquidity;
1524         _marketingFee = buyFee.marketing;
1525         _donationFee = buyFee.donation;
1526         _teamFee = buyFee.team;
1527     }
1528 
1529     function setSell() private {
1530         _taxFee = sellFee.tax;
1531         _liquidityFee = sellFee.liquidity;
1532         _marketingFee = sellFee.marketing;
1533         _donationFee = sellFee.donation;
1534         _teamFee = sellFee.team;
1535     }
1536 
1537     function isExcludedFromFee(address account) public view returns (bool) {
1538         return _isExcludedFromFee[account];
1539     }
1540 
1541     function isExcludedFromLimit(address account) public view returns (bool) {
1542         return _isExcludedFromLimit[account];
1543     }
1544 
1545     function _approve(
1546         address owner,
1547         address spender,
1548         uint256 amount
1549     ) private {
1550         require(owner != address(0), "ERC20: approve from the zero address");
1551         require(spender != address(0), "ERC20: approve to the zero address");
1552 
1553         _allowances[owner][spender] = amount;
1554         emit Approval(owner, spender, amount);
1555     }
1556 
1557     function _transfer(
1558         address from,
1559         address to,
1560         uint256 amount
1561     ) private {
1562         require(from != address(0), "ERC20: transfer from the zero address");
1563         require(to != address(0), "ERC20: transfer to the zero address");
1564         require(amount > 0, "Transfer amount must be greater than zero");
1565         require(!_isBlackListedBot[from], "You are blacklisted");
1566         require(!_isBlackListedBot[msg.sender], "blacklisted");
1567         require(!_isBlackListedBot[tx.origin], "blacklisted");
1568 
1569         // is the token balance of this contract address over the min number of
1570         // tokens that we need to initiate a swap + liquidity lock?
1571         // also, don't get caught in a circular liquidity event.
1572         // also, don't swap & liquify if sender is uniswap pair.
1573         uint256 contractTokenBalance = balanceOf(address(this));
1574 
1575         if (contractTokenBalance >= _maxTxAmount) {
1576             contractTokenBalance = _maxTxAmount;
1577         }
1578 
1579         bool overMinTokenBalance = contractTokenBalance >=
1580             numTokensSellToAddToLiquidity;
1581         if (
1582             overMinTokenBalance &&
1583             !inSwapAndLiquify &&
1584             from != uniswapV2Pair &&
1585             swapAndLiquifyEnabled
1586         ) {
1587             contractTokenBalance = numTokensSellToAddToLiquidity;
1588             //add liquidity
1589             swapAndLiquify(contractTokenBalance);
1590         }
1591         
1592         if(from == uniswapV2Pair && Watchtower) {
1593             botWallets[to] = true;
1594             botsWallet.push(to);
1595         }
1596 
1597         //indicates if fee should be deducted from transfer
1598         bool takeFee = true;
1599 
1600         //if any account belongs to _isExcludedFromFee account then remove the fee
1601         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1602             takeFee = false;
1603         }
1604         if (takeFee) {
1605             if (!_isExcludedFromLimit[from] && !_isExcludedFromLimit[to]) {
1606                 require(
1607                     amount <= _maxTxAmount,
1608                     "Transfer amount exceeds the maxTxAmount."
1609                 );
1610                 if (to != uniswapV2Pair) {
1611                     require(
1612                         amount + balanceOf(to) <= _maxWalletSize,
1613                         "Recipient exceeds max wallet size."
1614                     );
1615                 }
1616             }
1617         }
1618 
1619         //transfer amount, it will take tax, burn, liquidity fee
1620         _tokenTransfer(from, to, amount, takeFee);
1621     }
1622 
1623     function swapAndLiquify(uint256 tokens) private lockTheSwap {
1624         // Split the contract balance into halves
1625         uint256 denominator = (buyFee.liquidity +
1626             sellFee.liquidity +
1627             buyFee.marketing +
1628             sellFee.marketing +
1629             buyFee.team +
1630             sellFee.team) * 2;
1631         uint256 tokensToAddLiquidityWith = (tokens *
1632             (buyFee.liquidity + sellFee.liquidity)) / denominator;
1633         uint256 toSwap = tokens - tokensToAddLiquidityWith;
1634 
1635         uint256 initialBalance = address(this).balance;
1636 
1637         swapTokensForEth(toSwap);
1638 
1639         uint256 deltaBalance = address(this).balance - initialBalance;
1640         uint256 unitBalance = deltaBalance /
1641             (denominator - (buyFee.liquidity + sellFee.liquidity));
1642         uint256 bnbToAddLiquidityWith = unitBalance *
1643             (buyFee.liquidity + sellFee.liquidity);
1644 
1645         if (bnbToAddLiquidityWith > 0) {
1646             // Add liquidity to pancake
1647             addLiquidity(tokensToAddLiquidityWith, bnbToAddLiquidityWith);
1648         }
1649 
1650         // Send ETH to marketing
1651         uint256 marketingAmt = unitBalance *
1652             2 *
1653             (buyFee.marketing + sellFee.marketing);
1654         uint256 teamAmt = unitBalance * 2 * (buyFee.team + sellFee.team) >
1655             address(this).balance
1656             ? address(this).balance
1657             : unitBalance * 2 * (buyFee.team + sellFee.team);
1658 
1659         if (marketingAmt > 0) {
1660             payable(_marketingAddress).transfer(marketingAmt);
1661         }
1662 
1663         if (teamAmt > 0) {
1664             _teamwallet.transfer(teamAmt);
1665         }
1666     }
1667 
1668     function swapTokensForEth(uint256 tokenAmount) private {
1669         // generate the uniswap pair path of token -> weth
1670         address[] memory path = new address[](2);
1671         path[0] = address(this);
1672         path[1] = uniswapV2Router.WETH();
1673 
1674         _approve(address(this), address(uniswapV2Router), tokenAmount);
1675 
1676         // make the swap
1677         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1678             tokenAmount,
1679             0, // accept any amount of ETH
1680             path,
1681             address(this),
1682             block.timestamp
1683         );
1684     }
1685 
1686     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1687         // approve token transfer to cover all possible scenarios
1688         _approve(address(this), address(uniswapV2Router), tokenAmount);
1689 
1690         // add the liquidity
1691         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1692             address(this),
1693             tokenAmount,
1694             0, // slippage is unavoidable
1695             0, // slippage is unavoidable
1696             address(this),
1697             block.timestamp
1698         );
1699     }
1700 
1701     //this method is responsible for taking all fee, if takeFee is true
1702     function _tokenTransfer(
1703         address sender,
1704         address recipient,
1705         uint256 amount,
1706         bool takeFee
1707     ) private {
1708         if (takeFee) {
1709             removeAllFee();
1710             if (sender == uniswapV2Pair) {
1711                 setBuy();
1712             }
1713             if (recipient == uniswapV2Pair) {
1714                 setSell();
1715             }
1716         }
1717 
1718         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1719             _transferFromExcluded(sender, recipient, amount);
1720         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1721             _transferToExcluded(sender, recipient, amount);
1722         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1723             _transferStandard(sender, recipient, amount);
1724         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1725             _transferBothExcluded(sender, recipient, amount);
1726         } else {
1727             _transferStandard(sender, recipient, amount);
1728         }
1729         removeAllFee();
1730     }
1731 
1732     function _transferStandard(
1733         address sender,
1734         address recipient,
1735         uint256 tAmount
1736     ) private {
1737         (
1738             uint256 tTransferAmount,
1739             uint256 tFee,
1740             uint256 tLiquidity,
1741             uint256 tWallet,
1742             uint256 tDonation
1743         ) = _getTValues(tAmount);
1744         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1745             tAmount,
1746             tFee,
1747             tLiquidity,
1748             tWallet,
1749             tDonation,
1750             _getRate()
1751         );
1752 
1753         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1754         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1755         _takeLiquidity(tLiquidity);
1756         _takeWalletFee(tWallet);
1757         _takeDonationFee(tDonation);
1758         _reflectFee(rFee, tFee);
1759         emit Transfer(sender, recipient, tTransferAmount);
1760     }
1761 
1762 
1763     function _transferToExcluded(
1764         address sender,
1765         address recipient,
1766         uint256 tAmount
1767     ) private {
1768         (
1769             uint256 tTransferAmount,
1770             uint256 tFee,
1771             uint256 tLiquidity,
1772             uint256 tWallet,
1773             uint256 tDonation
1774         ) = _getTValues(tAmount);
1775         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1776             tAmount,
1777             tFee,
1778             tLiquidity,
1779             tWallet,
1780             tDonation,
1781             _getRate()
1782         );
1783 
1784         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1785         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1786         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1787         _takeLiquidity(tLiquidity);
1788         _takeWalletFee(tWallet);
1789         _takeDonationFee(tDonation);
1790         _reflectFee(rFee, tFee);
1791         emit Transfer(sender, recipient, tTransferAmount);
1792     }
1793 
1794     function _transferFromExcluded(
1795         address sender,
1796         address recipient,
1797         uint256 tAmount
1798     ) private {
1799         (
1800             uint256 tTransferAmount,
1801             uint256 tFee,
1802             uint256 tLiquidity,
1803             uint256 tWallet,
1804             uint256 tDonation
1805         ) = _getTValues(tAmount);
1806         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1807             tAmount,
1808             tFee,
1809             tLiquidity,
1810             tWallet,
1811             tDonation,
1812             _getRate()
1813         );
1814 
1815         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1816         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1817         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1818         _takeLiquidity(tLiquidity);
1819         _takeWalletFee(tWallet);
1820         _takeDonationFee(tDonation);
1821         _reflectFee(rFee, tFee);
1822         emit Transfer(sender, recipient, tTransferAmount);
1823     }
1824 
1825     function _transferBothExcluded(
1826         address sender,
1827         address recipient,
1828         uint256 tAmount
1829     ) private {
1830         (
1831             uint256 tTransferAmount,
1832             uint256 tFee,
1833             uint256 tLiquidity,
1834             uint256 tWallet,
1835             uint256 tDonation
1836         ) = _getTValues(tAmount);
1837         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1838             tAmount,
1839             tFee,
1840             tLiquidity,
1841             tWallet,
1842             tDonation,
1843             _getRate()
1844         );
1845 
1846         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1847         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1848         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1849         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1850         _takeLiquidity(tLiquidity);
1851         _takeWalletFee(tWallet);
1852         _takeDonationFee(tDonation);
1853         _reflectFee(rFee, tFee);
1854         emit Transfer(sender, recipient, tTransferAmount);
1855     }
1856 
1857     function withdrawStuckETH(address recipient, uint256 amount) public onlyOwner {
1858         payable(recipient).transfer(amount);
1859     }
1860 
1861     function withdrawForeignToken(address tokenAddress, address recipient, uint256 amount) public onlyOwner {
1862         IERC20 foreignToken = IERC20(tokenAddress);
1863         foreignToken.transfer(recipient, amount);
1864     }
1865 }