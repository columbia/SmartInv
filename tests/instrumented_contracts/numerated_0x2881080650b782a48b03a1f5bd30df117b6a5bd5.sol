1 /*
2     senator karen - the projectoooor. hates cryptoooor. believes in US dollooooor. she will call the managooor.
3     https://t.me/senatorkaren
4     https://senatorkaren.com
5 */
6 
7 // SPDX-License-Identifier: Unlicensed
8 
9 pragma solidity ^0.8.9;
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
262     //function _msgSender() internal view virtual returns (address payable) {
263     function _msgSender() internal view virtual returns (address) {
264         return msg.sender;
265     }
266 
267     function _msgData() internal view virtual returns (bytes memory) {
268         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
269         return msg.data;
270     }
271 }
272 
273 /**
274  * @dev Collection of functions related to the address type
275  */
276 library Address {
277     /**
278      * @dev Returns true if `account` is a contract.
279      *
280      * [IMPORTANT]
281      * ====
282      * It is unsafe to assume that an address for which this function returns
283      * false is an externally-owned account (EOA) and not a contract.
284      *
285      * Among others, `isContract` will return false for the following
286      * types of addresses:
287      *
288      *  - an externally-owned account
289      *  - a contract in construction
290      *  - an address where a contract will be created
291      *  - an address where a contract lived, but was destroyed
292      * ====
293      */
294     function isContract(address account) internal view returns (bool) {
295         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
296         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
297         // for accounts without code, i.e. `keccak256('')`
298         bytes32 codehash;
299         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
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
429         (bool success, bytes memory returndata) = target.call{value: weiValue}(
430             data
431         );
432         if (success) {
433             return returndata;
434         } else {
435             // Look for revert reason and bubble it up if present
436             if (returndata.length > 0) {
437                 // The easiest way to bubble the revert reason is using memory via assembly
438 
439                 // solhint-disable-next-line no-inline-assembly
440                 assembly {
441                     let returndata_size := mload(returndata)
442                     revert(add(32, returndata), returndata_size)
443                 }
444             } else {
445                 revert(errorMessage);
446             }
447         }
448     }
449 }
450 
451 /**
452  * @dev Contract module which provides a basic access control mechanism, where
453  * there is an account (an owner) that can be granted exclusive access to
454  * specific functions.
455  *
456  * By default, the owner account will be the one that deploys the contract. This
457  * can later be changed with {transferOwnership}.
458  *
459  * This module is used through inheritance. It will make available the modifier
460  * `onlyOwner`, which can be applied to your functions to restrict their use to
461  * the owner.
462  */
463 contract Ownable is Context {
464     address private _owner;
465     address private _previousOwner;
466     uint256 private _lockTime;
467 
468     event OwnershipTransferred(
469         address indexed previousOwner,
470         address indexed newOwner
471     );
472 
473     /**
474      * @dev Initializes the contract setting the deployer as the initial owner.
475      */
476     constructor() {
477         address msgSender = _msgSender();
478         _owner = msgSender;
479         emit OwnershipTransferred(address(0), msgSender);
480     }
481 
482     /**
483      * @dev Returns the address of the current owner.
484      */
485     function owner() public view returns (address) {
486         return _owner;
487     }
488 
489     /**
490      * @dev Throws if called by any account other than the owner.
491      */
492     modifier onlyOwner() {
493         require(_owner == _msgSender(), "Ownable: caller is not the owner");
494         _;
495     }
496 
497     /**
498      * @dev Leaves the contract without owner. It will not be possible to call
499      * `onlyOwner` functions anymore. Can only be called by the current owner.
500      *
501      * NOTE: Renouncing ownership will leave the contract without an owner,
502      * thereby removing any functionality that is only available to the owner.
503      */
504     function renounceOwnership() public virtual onlyOwner {
505         emit OwnershipTransferred(_owner, address(0));
506         _owner = address(0);
507     }
508 
509     /**
510      * @dev Transfers ownership of the contract to a new account (`newOwner`).
511      * Can only be called by the current owner.
512      */
513     function transferOwnership(address newOwner) public virtual onlyOwner {
514         require(
515             newOwner != address(0),
516             "Ownable: new owner is the zero address"
517         );
518         emit OwnershipTransferred(_owner, newOwner);
519         _owner = newOwner;
520     }
521 
522     function geUnlockTime() public view returns (uint256) {
523         return _lockTime;
524     }
525 
526     //Locks the contract for owner for the amount of time provided
527     function lock(uint256 time) public virtual onlyOwner {
528         _previousOwner = _owner;
529         _owner = address(0);
530         _lockTime = block.timestamp + time;
531         emit OwnershipTransferred(_owner, address(0));
532     }
533 
534     //Unlocks the contract for owner when _lockTime is exceeds
535     function unlock() public virtual {
536         require(
537             _previousOwner == msg.sender,
538             "You don't have permission to unlock"
539         );
540         require(block.timestamp > _lockTime, "Contract is locked until 7 days");
541         emit OwnershipTransferred(_owner, _previousOwner);
542         _owner = _previousOwner;
543     }
544 }
545 
546 interface IUniswapV2Factory {
547     event PairCreated(
548         address indexed token0,
549         address indexed token1,
550         address pair,
551         uint256
552     );
553 
554     function feeTo() external view returns (address);
555 
556     function feeToSetter() external view returns (address);
557 
558     function getPair(address tokenA, address tokenB)
559         external
560         view
561         returns (address pair);
562 
563     function allPairs(uint256) external view returns (address pair);
564 
565     function allPairsLength() external view returns (uint256);
566 
567     function createPair(address tokenA, address tokenB)
568         external
569         returns (address pair);
570 
571     function setFeeTo(address) external;
572 
573     function setFeeToSetter(address) external;
574 }
575 
576 interface IUniswapV2Pair {
577     event Approval(
578         address indexed owner,
579         address indexed spender,
580         uint256 value
581     );
582     event Transfer(address indexed from, address indexed to, uint256 value);
583 
584     function name() external pure returns (string memory);
585 
586     function symbol() external pure returns (string memory);
587 
588     function decimals() external pure returns (uint8);
589 
590     function totalSupply() external view returns (uint256);
591 
592     function balanceOf(address owner) external view returns (uint256);
593 
594     function allowance(address owner, address spender)
595         external
596         view
597         returns (uint256);
598 
599     function approve(address spender, uint256 value) external returns (bool);
600 
601     function transfer(address to, uint256 value) external returns (bool);
602 
603     function transferFrom(
604         address from,
605         address to,
606         uint256 value
607     ) external returns (bool);
608 
609     function DOMAIN_SEPARATOR() external view returns (bytes32);
610 
611     function PERMIT_TYPEHASH() external pure returns (bytes32);
612 
613     function nonces(address owner) external view returns (uint256);
614 
615     function permit(
616         address owner,
617         address spender,
618         uint256 value,
619         uint256 deadline,
620         uint8 v,
621         bytes32 r,
622         bytes32 s
623     ) external;
624 
625     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
626     event Burn(
627         address indexed sender,
628         uint256 amount0,
629         uint256 amount1,
630         address indexed to
631     );
632     event Swap(
633         address indexed sender,
634         uint256 amount0In,
635         uint256 amount1In,
636         uint256 amount0Out,
637         uint256 amount1Out,
638         address indexed to
639     );
640     event Sync(uint112 reserve0, uint112 reserve1);
641 
642     function MINIMUM_LIQUIDITY() external pure returns (uint256);
643 
644     function factory() external view returns (address);
645 
646     function token0() external view returns (address);
647 
648     function token1() external view returns (address);
649 
650     function getReserves()
651         external
652         view
653         returns (
654             uint112 reserve0,
655             uint112 reserve1,
656             uint32 blockTimestampLast
657         );
658 
659     function price0CumulativeLast() external view returns (uint256);
660 
661     function price1CumulativeLast() external view returns (uint256);
662 
663     function kLast() external view returns (uint256);
664 
665     function mint(address to) external returns (uint256 liquidity);
666 
667     function burn(address to)
668         external
669         returns (uint256 amount0, uint256 amount1);
670 
671     function swap(
672         uint256 amount0Out,
673         uint256 amount1Out,
674         address to,
675         bytes calldata data
676     ) external;
677 
678     function skim(address to) external;
679 
680     function sync() external;
681 
682     function initialize(address, address) external;
683 }
684 
685 interface IUniswapV2Router01 {
686     function factory() external pure returns (address);
687 
688     function WETH() external pure returns (address);
689 
690     function addLiquidity(
691         address tokenA,
692         address tokenB,
693         uint256 amountADesired,
694         uint256 amountBDesired,
695         uint256 amountAMin,
696         uint256 amountBMin,
697         address to,
698         uint256 deadline
699     )
700         external
701         returns (
702             uint256 amountA,
703             uint256 amountB,
704             uint256 liquidity
705         );
706 
707     function addLiquidityETH(
708         address token,
709         uint256 amountTokenDesired,
710         uint256 amountTokenMin,
711         uint256 amountETHMin,
712         address to,
713         uint256 deadline
714     )
715         external
716         payable
717         returns (
718             uint256 amountToken,
719             uint256 amountETH,
720             uint256 liquidity
721         );
722 
723     function removeLiquidity(
724         address tokenA,
725         address tokenB,
726         uint256 liquidity,
727         uint256 amountAMin,
728         uint256 amountBMin,
729         address to,
730         uint256 deadline
731     ) external returns (uint256 amountA, uint256 amountB);
732 
733     function removeLiquidityETH(
734         address token,
735         uint256 liquidity,
736         uint256 amountTokenMin,
737         uint256 amountETHMin,
738         address to,
739         uint256 deadline
740     ) external returns (uint256 amountToken, uint256 amountETH);
741 
742     function removeLiquidityWithPermit(
743         address tokenA,
744         address tokenB,
745         uint256 liquidity,
746         uint256 amountAMin,
747         uint256 amountBMin,
748         address to,
749         uint256 deadline,
750         bool approveMax,
751         uint8 v,
752         bytes32 r,
753         bytes32 s
754     ) external returns (uint256 amountA, uint256 amountB);
755 
756     function removeLiquidityETHWithPermit(
757         address token,
758         uint256 liquidity,
759         uint256 amountTokenMin,
760         uint256 amountETHMin,
761         address to,
762         uint256 deadline,
763         bool approveMax,
764         uint8 v,
765         bytes32 r,
766         bytes32 s
767     ) external returns (uint256 amountToken, uint256 amountETH);
768 
769     function swapExactTokensForTokens(
770         uint256 amountIn,
771         uint256 amountOutMin,
772         address[] calldata path,
773         address to,
774         uint256 deadline
775     ) external returns (uint256[] memory amounts);
776 
777     function swapTokensForExactTokens(
778         uint256 amountOut,
779         uint256 amountInMax,
780         address[] calldata path,
781         address to,
782         uint256 deadline
783     ) external returns (uint256[] memory amounts);
784 
785     function swapExactETHForTokens(
786         uint256 amountOutMin,
787         address[] calldata path,
788         address to,
789         uint256 deadline
790     ) external payable returns (uint256[] memory amounts);
791 
792     function swapTokensForExactETH(
793         uint256 amountOut,
794         uint256 amountInMax,
795         address[] calldata path,
796         address to,
797         uint256 deadline
798     ) external returns (uint256[] memory amounts);
799 
800     function swapExactTokensForETH(
801         uint256 amountIn,
802         uint256 amountOutMin,
803         address[] calldata path,
804         address to,
805         uint256 deadline
806     ) external returns (uint256[] memory amounts);
807 
808     function swapETHForExactTokens(
809         uint256 amountOut,
810         address[] calldata path,
811         address to,
812         uint256 deadline
813     ) external payable returns (uint256[] memory amounts);
814 
815     function quote(
816         uint256 amountA,
817         uint256 reserveA,
818         uint256 reserveB
819     ) external pure returns (uint256 amountB);
820 
821     function getAmountOut(
822         uint256 amountIn,
823         uint256 reserveIn,
824         uint256 reserveOut
825     ) external pure returns (uint256 amountOut);
826 
827     function getAmountIn(
828         uint256 amountOut,
829         uint256 reserveIn,
830         uint256 reserveOut
831     ) external pure returns (uint256 amountIn);
832 
833     function getAmountsOut(uint256 amountIn, address[] calldata path)
834         external
835         view
836         returns (uint256[] memory amounts);
837 
838     function getAmountsIn(uint256 amountOut, address[] calldata path)
839         external
840         view
841         returns (uint256[] memory amounts);
842 }
843 
844 interface IUniswapV2Router02 is IUniswapV2Router01 {
845     function removeLiquidityETHSupportingFeeOnTransferTokens(
846         address token,
847         uint256 liquidity,
848         uint256 amountTokenMin,
849         uint256 amountETHMin,
850         address to,
851         uint256 deadline
852     ) external returns (uint256 amountETH);
853 
854     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
855         address token,
856         uint256 liquidity,
857         uint256 amountTokenMin,
858         uint256 amountETHMin,
859         address to,
860         uint256 deadline,
861         bool approveMax,
862         uint8 v,
863         bytes32 r,
864         bytes32 s
865     ) external returns (uint256 amountETH);
866 
867     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
868         uint256 amountIn,
869         uint256 amountOutMin,
870         address[] calldata path,
871         address to,
872         uint256 deadline
873     ) external;
874 
875     function swapExactETHForTokensSupportingFeeOnTransferTokens(
876         uint256 amountOutMin,
877         address[] calldata path,
878         address to,
879         uint256 deadline
880     ) external payable;
881 
882     function swapExactTokensForETHSupportingFeeOnTransferTokens(
883         uint256 amountIn,
884         uint256 amountOutMin,
885         address[] calldata path,
886         address to,
887         uint256 deadline
888     ) external;
889 }
890 
891 contract KAREN is Context, IERC20, Ownable {
892     using SafeMath for uint256;
893     using Address for address;
894 
895     mapping(address => uint256) private _rOwned;
896     mapping(address => uint256) private _tOwned;
897     mapping(address => mapping(address => uint256)) private _allowances;
898 
899     mapping(address => bool) private _isExcludedFromFee;
900 
901     mapping(address => bool) private _isExcluded;
902     address[] private _excluded;
903 
904     bool public canTrade = false;
905 
906     uint256 private constant MAX = ~uint256(0);
907     uint256 private _tTotal = 6942069420 * 10**9;
908     uint256 private _rTotal = (MAX - (MAX % _tTotal));
909     uint256 private _tFeeTotal;
910     address public marketingWallet;
911 
912     string private _name = "Senator Karen Coin";
913     string private _symbol = "KAREN";
914     uint8 private _decimals = 9;
915 
916     uint256 public _taxFee = 1;
917     uint256 private _previousTaxFee = _taxFee;
918 
919     uint256 public _liquidityFee = 12;
920     uint256 private _previousLiquidityFee = _liquidityFee;
921 
922     IUniswapV2Router02 public immutable uniswapV2Router;
923     address public immutable uniswapV2Pair;
924 
925     bool inSwapAndLiquify;
926     bool public swapAndLiquifyEnabled = true;
927 
928     uint256 public _maxTxAmount = 69420000 * 10**9;
929     uint256 public numTokensSellToAddToLiquidity =
930         69420000 * 10**9;
931 
932     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
933     event SwapAndLiquifyEnabledUpdated(bool enabled);
934     event SwapAndLiquify(
935         uint256 tokensSwapped,
936         uint256 ethReceived,
937         uint256 tokensIntoLiqudity
938     );
939 
940     modifier lockTheSwap() {
941         inSwapAndLiquify = true;
942         _;
943         inSwapAndLiquify = false;
944     }
945 
946     constructor() {
947         _rOwned[_msgSender()] = _rTotal;
948 
949         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
950             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
951         ); //Mainnet & Testnet ETH
952         // Create a uniswap pair for this new token
953         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
954             .createPair(address(this), _uniswapV2Router.WETH());
955 
956         // set the rest of the contract variables
957         uniswapV2Router = _uniswapV2Router;
958 
959         //exclude owner and this contract from fee
960         _isExcludedFromFee[owner()] = true;
961         _isExcludedFromFee[address(this)] = true;
962 
963         emit Transfer(address(0), _msgSender(), _tTotal);
964     }
965 
966     function name() public view returns (string memory) {
967         return _name;
968     }
969 
970     function symbol() public view returns (string memory) {
971         return _symbol;
972     }
973 
974     function decimals() public view returns (uint8) {
975         return _decimals;
976     }
977 
978     function totalSupply() public view override returns (uint256) {
979         return _tTotal;
980     }
981 
982     function balanceOf(address account) public view override returns (uint256) {
983         if (_isExcluded[account]) return _tOwned[account];
984         return tokenFromReflection(_rOwned[account]);
985     }
986 
987     function transfer(address recipient, uint256 amount)
988         public
989         override
990         returns (bool)
991     {
992         _transfer(_msgSender(), recipient, amount);
993         return true;
994     }
995 
996     function allowance(address owner, address spender)
997         public
998         view
999         override
1000         returns (uint256)
1001     {
1002         return _allowances[owner][spender];
1003     }
1004 
1005     function approve(address spender, uint256 amount)
1006         public
1007         override
1008         returns (bool)
1009     {
1010         _approve(_msgSender(), spender, amount);
1011         return true;
1012     }
1013 
1014     function transferFrom(
1015         address sender,
1016         address recipient,
1017         uint256 amount
1018     ) public override returns (bool) {
1019         _transfer(sender, recipient, amount);
1020         _approve(
1021             sender,
1022             _msgSender(),
1023             _allowances[sender][_msgSender()].sub(
1024                 amount,
1025                 "ERC20: transfer amount exceeds allowance"
1026             )
1027         );
1028         return true;
1029     }
1030 
1031     function increaseAllowance(address spender, uint256 addedValue)
1032         public
1033         virtual
1034         returns (bool)
1035     {
1036         _approve(
1037             _msgSender(),
1038             spender,
1039             _allowances[_msgSender()][spender].add(addedValue)
1040         );
1041         return true;
1042     }
1043 
1044     function decreaseAllowance(address spender, uint256 subtractedValue)
1045         public
1046         virtual
1047         returns (bool)
1048     {
1049         _approve(
1050             _msgSender(),
1051             spender,
1052             _allowances[_msgSender()][spender].sub(
1053                 subtractedValue,
1054                 "ERC20: decreased allowance below zero"
1055             )
1056         );
1057         return true;
1058     }
1059 
1060     function isExcludedFromReward(address account) public view returns (bool) {
1061         return _isExcluded[account];
1062     }
1063 
1064     function totalFees() public view returns (uint256) {
1065         return _tFeeTotal;
1066     }
1067 
1068     function deliver(uint256 tAmount) public {
1069         address sender = _msgSender();
1070         require(
1071             !_isExcluded[sender],
1072             "Excluded addresses cannot call this function"
1073         );
1074         (uint256 rAmount, , , , , ) = _getValues(tAmount);
1075         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1076         _rTotal = _rTotal.sub(rAmount);
1077         _tFeeTotal = _tFeeTotal.add(tAmount);
1078     }
1079 
1080     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
1081         public
1082         view
1083         returns (uint256)
1084     {
1085         require(tAmount <= _tTotal, "Amount must be less than supply");
1086         if (!deductTransferFee) {
1087             (uint256 rAmount, , , , , ) = _getValues(tAmount);
1088             return rAmount;
1089         } else {
1090             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
1091             return rTransferAmount;
1092         }
1093     }
1094 
1095     function tokenFromReflection(uint256 rAmount)
1096         public
1097         view
1098         returns (uint256)
1099     {
1100         require(
1101             rAmount <= _rTotal,
1102             "Amount must be less than total reflections"
1103         );
1104         uint256 currentRate = _getRate();
1105         return rAmount.div(currentRate);
1106     }
1107 
1108     function excludeFromReward(address account) public onlyOwner {
1109         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
1110         require(!_isExcluded[account], "Account is already excluded");
1111         if (_rOwned[account] > 0) {
1112             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1113         }
1114         _isExcluded[account] = true;
1115         _excluded.push(account);
1116     }
1117 
1118     function includeInReward(address account) external onlyOwner {
1119         require(_isExcluded[account], "Account is already excluded");
1120         for (uint256 i = 0; i < _excluded.length; i++) {
1121             if (_excluded[i] == account) {
1122                 _excluded[i] = _excluded[_excluded.length - 1];
1123                 _tOwned[account] = 0;
1124                 _isExcluded[account] = false;
1125                 _excluded.pop();
1126                 break;
1127             }
1128         }
1129     }
1130 
1131     function _transferBothExcluded(
1132         address sender,
1133         address recipient,
1134         uint256 tAmount
1135     ) private {
1136         (
1137             uint256 rAmount,
1138             uint256 rTransferAmount,
1139             uint256 rFee,
1140             uint256 tTransferAmount,
1141             uint256 tFee,
1142             uint256 tLiquidity
1143         ) = _getValues(tAmount);
1144         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1145         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1146         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1147         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1148         _takeLiquidity(tLiquidity);
1149         _reflectFee(rFee, tFee);
1150         emit Transfer(sender, recipient, tTransferAmount);
1151     }
1152 
1153     function excludeFromFee(address account) public onlyOwner {
1154         _isExcludedFromFee[account] = true;
1155     }
1156 
1157     function includeInFee(address account) public onlyOwner {
1158         _isExcludedFromFee[account] = false;
1159     }
1160 
1161     function setMarketingWallet(address walletAddress) public onlyOwner {
1162         marketingWallet = walletAddress;
1163     }
1164 
1165     function upliftTxAmount() external onlyOwner {
1166         _maxTxAmount = 69420000 * 10**9;
1167     }
1168 
1169     function setSwapThresholdAmount(uint256 SwapThresholdAmount)
1170         external
1171         onlyOwner
1172     {
1173         require(
1174             SwapThresholdAmount > 69420000,
1175             "Swap Threshold Amount cannot be less than 69 Million"
1176         );
1177         numTokensSellToAddToLiquidity = SwapThresholdAmount * 10**9;
1178     }
1179 
1180     function claimTokens() public onlyOwner {
1181         payable(marketingWallet).transfer(address(this).balance);
1182     }
1183 
1184     function claimOtherTokens(IERC20 tokenAddress, address walletaddress)
1185         external
1186         onlyOwner
1187     {
1188         tokenAddress.transfer(
1189             walletaddress,
1190             tokenAddress.balanceOf(address(this))
1191         );
1192     }
1193 
1194     function clearStuckBalance(address payable walletaddress)
1195         external
1196         onlyOwner
1197     {
1198         walletaddress.transfer(address(this).balance);
1199     }
1200 
1201     function allowtrading() external onlyOwner {
1202         canTrade = true;
1203     }
1204 
1205     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1206         swapAndLiquifyEnabled = _enabled;
1207         emit SwapAndLiquifyEnabledUpdated(_enabled);
1208     }
1209 
1210     //to recieve ETH from uniswapV2Router when swaping
1211     receive() external payable {}
1212 
1213     function _reflectFee(uint256 rFee, uint256 tFee) private {
1214         _rTotal = _rTotal.sub(rFee);
1215         _tFeeTotal = _tFeeTotal.add(tFee);
1216     }
1217 
1218     function _getValues(uint256 tAmount)
1219         private
1220         view
1221         returns (
1222             uint256,
1223             uint256,
1224             uint256,
1225             uint256,
1226             uint256,
1227             uint256
1228         )
1229     {
1230         (
1231             uint256 tTransferAmount,
1232             uint256 tFee,
1233             uint256 tLiquidity
1234         ) = _getTValues(tAmount);
1235         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1236             tAmount,
1237             tFee,
1238             tLiquidity,
1239             _getRate()
1240         );
1241         return (
1242             rAmount,
1243             rTransferAmount,
1244             rFee,
1245             tTransferAmount,
1246             tFee,
1247             tLiquidity
1248         );
1249     }
1250 
1251     function _getTValues(uint256 tAmount)
1252         private
1253         view
1254         returns (
1255             uint256,
1256             uint256,
1257             uint256
1258         )
1259     {
1260         uint256 tFee = calculateTaxFee(tAmount);
1261         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1262         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1263         return (tTransferAmount, tFee, tLiquidity);
1264     }
1265 
1266     function _getRValues(
1267         uint256 tAmount,
1268         uint256 tFee,
1269         uint256 tLiquidity,
1270         uint256 currentRate
1271     )
1272         private
1273         pure
1274         returns (
1275             uint256,
1276             uint256,
1277             uint256
1278         )
1279     {
1280         uint256 rAmount = tAmount.mul(currentRate);
1281         uint256 rFee = tFee.mul(currentRate);
1282         uint256 rLiquidity = tLiquidity.mul(currentRate);
1283         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1284         return (rAmount, rTransferAmount, rFee);
1285     }
1286 
1287     function _getRate() private view returns (uint256) {
1288         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1289         return rSupply.div(tSupply);
1290     }
1291 
1292     function _getCurrentSupply() private view returns (uint256, uint256) {
1293         uint256 rSupply = _rTotal;
1294         uint256 tSupply = _tTotal;
1295         for (uint256 i = 0; i < _excluded.length; i++) {
1296             if (
1297                 _rOwned[_excluded[i]] > rSupply ||
1298                 _tOwned[_excluded[i]] > tSupply
1299             ) return (_rTotal, _tTotal);
1300             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1301             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1302         }
1303         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1304         return (rSupply, tSupply);
1305     }
1306 
1307     function _takeLiquidity(uint256 tLiquidity) private {
1308         uint256 currentRate = _getRate();
1309         uint256 rLiquidity = tLiquidity.mul(currentRate);
1310         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1311         if (_isExcluded[address(this)])
1312             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1313     }
1314 
1315     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1316         return _amount.mul(_taxFee).div(10**2);
1317     }
1318 
1319     function calculateLiquidityFee(uint256 _amount)
1320         private
1321         view
1322         returns (uint256)
1323     {
1324         return _amount.mul(_liquidityFee).div(10**2);
1325     }
1326 
1327     function removeAllFee() private {
1328         if (_taxFee == 0 && _liquidityFee == 0) return;
1329 
1330         _previousTaxFee = _taxFee;
1331         _previousLiquidityFee = _liquidityFee;
1332 
1333         _taxFee = 0;
1334         _liquidityFee = 0;
1335     }
1336 
1337     function restoreAllFee() private {
1338         _taxFee = _previousTaxFee;
1339         _liquidityFee = _previousLiquidityFee;
1340     }
1341 
1342     function isExcludedFromFee(address account) public view returns (bool) {
1343         return _isExcludedFromFee[account];
1344     }
1345 
1346     function _approve(
1347         address owner,
1348         address spender,
1349         uint256 amount
1350     ) private {
1351         require(owner != address(0), "ERC20: approve from the zero address");
1352         require(spender != address(0), "ERC20: approve to the zero address");
1353 
1354         _allowances[owner][spender] = amount;
1355         emit Approval(owner, spender, amount);
1356     }
1357 
1358     function _transfer(
1359         address from,
1360         address to,
1361         uint256 amount
1362     ) private {
1363         require(from != address(0), "ERC20: transfer from the zero address");
1364         require(to != address(0), "ERC20: transfer to the zero address");
1365         require(amount > 0, "Transfer amount must be greater than zero");
1366         if (from != owner() && to != owner())
1367             require(
1368                 amount <= _maxTxAmount,
1369                 "Transfer amount exceeds the maxTxAmount."
1370             );
1371 
1372         // is the token balance of this contract address over the min number of
1373         // tokens that we need to initiate a swap + liquidity lock?
1374         // also, don't get caught in a circular liquidity event.
1375         // also, don't swap & liquify if sender is uniswap pair.
1376         uint256 contractTokenBalance = balanceOf(address(this));
1377 
1378         if (contractTokenBalance >= _maxTxAmount) {
1379             contractTokenBalance = _maxTxAmount;
1380         }
1381 
1382         bool overMinTokenBalance = contractTokenBalance >=
1383             numTokensSellToAddToLiquidity;
1384         if (
1385             overMinTokenBalance &&
1386             !inSwapAndLiquify &&
1387             from != uniswapV2Pair &&
1388             swapAndLiquifyEnabled
1389         ) {
1390             contractTokenBalance = numTokensSellToAddToLiquidity;
1391             //add liquidity
1392             swapAndLiquify(contractTokenBalance);
1393         }
1394 
1395         //indicates if fee should be deducted from transfer
1396         bool takeFee = true;
1397 
1398         //if any account belongs to _isExcludedFromFee account then remove the fee
1399         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1400             takeFee = false;
1401         }
1402 
1403         //transfer amount, it will take tax, burn, liquidity fee
1404         _tokenTransfer(from, to, amount, takeFee);
1405     }
1406 
1407     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1408         // split the contract balance into halves
1409         // add the marketing wallet
1410         uint256 half = contractTokenBalance.div(2);
1411         uint256 otherHalf = contractTokenBalance.sub(half);
1412 
1413         // capture the contract's current ETH balance.
1414         // this is so that we can capture exactly the amount of ETH that the
1415         // swap creates, and not make the liquidity event include any ETH that
1416         // has been manually sent to the contract
1417         uint256 initialBalance = address(this).balance;
1418 
1419         // swap tokens for ETH
1420         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1421 
1422         // how much ETH did we just swap into?
1423         uint256 newBalance = address(this).balance.sub(initialBalance);
1424         uint256 marketingshare = newBalance.mul(75).div(100);
1425         payable(marketingWallet).transfer(marketingshare);
1426         newBalance -= marketingshare;
1427         // add liquidity to uniswap
1428         addLiquidity(otherHalf, newBalance);
1429 
1430         emit SwapAndLiquify(half, newBalance, otherHalf);
1431     }
1432 
1433     function swapTokensForEth(uint256 tokenAmount) private {
1434         // generate the uniswap pair path of token -> weth
1435         address[] memory path = new address[](2);
1436         path[0] = address(this);
1437         path[1] = uniswapV2Router.WETH();
1438 
1439         _approve(address(this), address(uniswapV2Router), tokenAmount);
1440 
1441         // make the swap
1442         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1443             tokenAmount,
1444             0, // accept any amount of ETH
1445             path,
1446             address(this),
1447             block.timestamp
1448         );
1449     }
1450 
1451     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1452         // approve token transfer to cover all possible scenarios
1453         _approve(address(this), address(uniswapV2Router), tokenAmount);
1454 
1455         // add the liquidity
1456         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1457             address(this),
1458             tokenAmount,
1459             0, // slippage is unavoidable
1460             0, // slippage is unavoidable
1461             owner(),
1462             block.timestamp
1463         );
1464     }
1465 
1466     //this method is responsible for taking all fee, if takeFee is true
1467     function _tokenTransfer(
1468         address sender,
1469         address recipient,
1470         uint256 amount,
1471         bool takeFee
1472     ) private {
1473         if (!canTrade) {
1474             require(sender == owner()); // only owner allowed to trade or add liquidity
1475         }
1476 
1477 
1478         if (!takeFee) removeAllFee();
1479 
1480         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1481             _transferFromExcluded(sender, recipient, amount);
1482         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1483             _transferToExcluded(sender, recipient, amount);
1484         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1485             _transferStandard(sender, recipient, amount);
1486         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1487             _transferBothExcluded(sender, recipient, amount);
1488         } else {
1489             _transferStandard(sender, recipient, amount);
1490         }
1491 
1492         if (!takeFee) restoreAllFee();
1493     }
1494 
1495     function _transferStandard(
1496         address sender,
1497         address recipient,
1498         uint256 tAmount
1499     ) private {
1500         (
1501             uint256 rAmount,
1502             uint256 rTransferAmount,
1503             uint256 rFee,
1504             uint256 tTransferAmount,
1505             uint256 tFee,
1506             uint256 tLiquidity
1507         ) = _getValues(tAmount);
1508         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1509         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1510         _takeLiquidity(tLiquidity);
1511         _reflectFee(rFee, tFee);
1512         emit Transfer(sender, recipient, tTransferAmount);
1513     }
1514 
1515     function _transferToExcluded(
1516         address sender,
1517         address recipient,
1518         uint256 tAmount
1519     ) private {
1520         (
1521             uint256 rAmount,
1522             uint256 rTransferAmount,
1523             uint256 rFee,
1524             uint256 tTransferAmount,
1525             uint256 tFee,
1526             uint256 tLiquidity
1527         ) = _getValues(tAmount);
1528         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1529         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1530         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1531         _takeLiquidity(tLiquidity);
1532         _reflectFee(rFee, tFee);
1533         emit Transfer(sender, recipient, tTransferAmount);
1534     }
1535 
1536     function _transferFromExcluded(
1537         address sender,
1538         address recipient,
1539         uint256 tAmount
1540     ) private {
1541         (
1542             uint256 rAmount,
1543             uint256 rTransferAmount,
1544             uint256 rFee,
1545             uint256 tTransferAmount,
1546             uint256 tFee,
1547             uint256 tLiquidity
1548         ) = _getValues(tAmount);
1549         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1550         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1551         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1552         _takeLiquidity(tLiquidity);
1553         _reflectFee(rFee, tFee);
1554         emit Transfer(sender, recipient, tTransferAmount);
1555     }
1556 }