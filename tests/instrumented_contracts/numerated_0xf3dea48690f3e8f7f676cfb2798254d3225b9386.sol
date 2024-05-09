1 /**
2      Grind Token 2021
3 
4 	grindtoken.io
5      */
6 
7 pragma solidity ^0.6.12;
8 
9 
10 // SPDX-License-Identifier: Unlicensed
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
298 
299 
300             bytes32 accountHash
301          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
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
478     constructor() internal {
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
532         _lockTime = now + time;
533         emit OwnershipTransferred(_owner, address(0));
534     }
535 
536     //Unlocks the contract for owner when _lockTime is exceeds
537     function unlock() public virtual {
538         require(
539             _previousOwner == msg.sender,
540             "You don't have permission to unlock"
541         );
542         require(now > _lockTime, "Contract is locked until 7 days");
543         emit OwnershipTransferred(_owner, _previousOwner);
544         _owner = _previousOwner;
545     }
546 }
547 
548 // pragma solidity >=0.5.0;
549 
550 interface IUniswapV2Factory {
551     event PairCreated(
552         address indexed token0,
553         address indexed token1,
554         address pair,
555         uint256
556     );
557 
558     function feeTo() external view returns (address);
559 
560     function feeToSetter() external view returns (address);
561 
562     function getPair(address tokenA, address tokenB)
563         external
564         view
565         returns (address pair);
566 
567     function allPairs(uint256) external view returns (address pair);
568 
569     function allPairsLength() external view returns (uint256);
570 
571     function createPair(address tokenA, address tokenB)
572         external
573         returns (address pair);
574 
575     function setFeeTo(address) external;
576 
577     function setFeeToSetter(address) external;
578 }
579 
580 // pragma solidity >=0.5.0;
581 
582 interface IUniswapV2Pair {
583     event Approval(
584         address indexed owner,
585         address indexed spender,
586         uint256 value
587     );
588     event Transfer(address indexed from, address indexed to, uint256 value);
589 
590     function name() external pure returns (string memory);
591 
592     function symbol() external pure returns (string memory);
593 
594     function decimals() external pure returns (uint8);
595 
596     function totalSupply() external view returns (uint256);
597 
598     function balanceOf(address owner) external view returns (uint256);
599 
600     function allowance(address owner, address spender)
601         external
602         view
603         returns (uint256);
604 
605     function approve(address spender, uint256 value) external returns (bool);
606 
607     function transfer(address to, uint256 value) external returns (bool);
608 
609     function transferFrom(
610         address from,
611         address to,
612         uint256 value
613     ) external returns (bool);
614 
615     function DOMAIN_SEPARATOR() external view returns (bytes32);
616 
617     function PERMIT_TYPEHASH() external pure returns (bytes32);
618 
619     function nonces(address owner) external view returns (uint256);
620 
621     function permit(
622         address owner,
623         address spender,
624         uint256 value,
625         uint256 deadline,
626         uint8 v,
627         bytes32 r,
628         bytes32 s
629     ) external;
630 
631     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
632     event Burn(
633         address indexed sender,
634         uint256 amount0,
635         uint256 amount1,
636         address indexed to
637     );
638     event Swap(
639         address indexed sender,
640         uint256 amount0In,
641         uint256 amount1In,
642         uint256 amount0Out,
643         uint256 amount1Out,
644         address indexed to
645     );
646     event Sync(uint112 reserve0, uint112 reserve1);
647 
648     function MINIMUM_LIQUIDITY() external pure returns (uint256);
649 
650     function factory() external view returns (address);
651 
652     function token0() external view returns (address);
653 
654     function token1() external view returns (address);
655 
656     function getReserves()
657         external
658         view
659         returns (
660             uint112 reserve0,
661             uint112 reserve1,
662             uint32 blockTimestampLast
663         );
664 
665     function price0CumulativeLast() external view returns (uint256);
666 
667     function price1CumulativeLast() external view returns (uint256);
668 
669     function kLast() external view returns (uint256);
670 
671     function mint(address to) external returns (uint256 liquidity);
672 
673     function burn(address to)
674         external
675         returns (uint256 amount0, uint256 amount1);
676 
677     function swap(
678         uint256 amount0Out,
679         uint256 amount1Out,
680         address to,
681         bytes calldata data
682     ) external;
683 
684     function skim(address to) external;
685 
686     function sync() external;
687 
688     function initialize(address, address) external;
689 }
690 
691 // pragma solidity >=0.6.2;
692 
693 interface IUniswapV2Router01 {
694     function factory() external pure returns (address);
695 
696     function WETH() external pure returns (address);
697 
698     function addLiquidity(
699         address tokenA,
700         address tokenB,
701         uint256 amountADesired,
702         uint256 amountBDesired,
703         uint256 amountAMin,
704         uint256 amountBMin,
705         address to,
706         uint256 deadline
707     )
708         external
709         returns (
710             uint256 amountA,
711             uint256 amountB,
712             uint256 liquidity
713         );
714 
715     function addLiquidityETH(
716         address token,
717         uint256 amountTokenDesired,
718         uint256 amountTokenMin,
719         uint256 amountETHMin,
720         address to,
721         uint256 deadline
722     )
723         external
724         payable
725         returns (
726             uint256 amountToken,
727             uint256 amountETH,
728             uint256 liquidity
729         );
730 
731     function removeLiquidity(
732         address tokenA,
733         address tokenB,
734         uint256 liquidity,
735         uint256 amountAMin,
736         uint256 amountBMin,
737         address to,
738         uint256 deadline
739     ) external returns (uint256 amountA, uint256 amountB);
740 
741     function removeLiquidityETH(
742         address token,
743         uint256 liquidity,
744         uint256 amountTokenMin,
745         uint256 amountETHMin,
746         address to,
747         uint256 deadline
748     ) external returns (uint256 amountToken, uint256 amountETH);
749 
750     function removeLiquidityWithPermit(
751         address tokenA,
752         address tokenB,
753         uint256 liquidity,
754         uint256 amountAMin,
755         uint256 amountBMin,
756         address to,
757         uint256 deadline,
758         bool approveMax,
759         uint8 v,
760         bytes32 r,
761         bytes32 s
762     ) external returns (uint256 amountA, uint256 amountB);
763 
764     function removeLiquidityETHWithPermit(
765         address token,
766         uint256 liquidity,
767         uint256 amountTokenMin,
768         uint256 amountETHMin,
769         address to,
770         uint256 deadline,
771         bool approveMax,
772         uint8 v,
773         bytes32 r,
774         bytes32 s
775     ) external returns (uint256 amountToken, uint256 amountETH);
776 
777     function swapExactTokensForTokens(
778         uint256 amountIn,
779         uint256 amountOutMin,
780         address[] calldata path,
781         address to,
782         uint256 deadline
783     ) external returns (uint256[] memory amounts);
784 
785     function swapTokensForExactTokens(
786         uint256 amountOut,
787         uint256 amountInMax,
788         address[] calldata path,
789         address to,
790         uint256 deadline
791     ) external returns (uint256[] memory amounts);
792 
793     function swapExactETHForTokens(
794         uint256 amountOutMin,
795         address[] calldata path,
796         address to,
797         uint256 deadline
798     ) external payable returns (uint256[] memory amounts);
799 
800     function swapTokensForExactETH(
801         uint256 amountOut,
802         uint256 amountInMax,
803         address[] calldata path,
804         address to,
805         uint256 deadline
806     ) external returns (uint256[] memory amounts);
807 
808     function swapExactTokensForETH(
809         uint256 amountIn,
810         uint256 amountOutMin,
811         address[] calldata path,
812         address to,
813         uint256 deadline
814     ) external returns (uint256[] memory amounts);
815 
816     function swapETHForExactTokens(
817         uint256 amountOut,
818         address[] calldata path,
819         address to,
820         uint256 deadline
821     ) external payable returns (uint256[] memory amounts);
822 
823     function quote(
824         uint256 amountA,
825         uint256 reserveA,
826         uint256 reserveB
827     ) external pure returns (uint256 amountB);
828 
829     function getAmountOut(
830         uint256 amountIn,
831         uint256 reserveIn,
832         uint256 reserveOut
833     ) external pure returns (uint256 amountOut);
834 
835     function getAmountIn(
836         uint256 amountOut,
837         uint256 reserveIn,
838         uint256 reserveOut
839     ) external pure returns (uint256 amountIn);
840 
841     function getAmountsOut(uint256 amountIn, address[] calldata path)
842         external
843         view
844         returns (uint256[] memory amounts);
845 
846     function getAmountsIn(uint256 amountOut, address[] calldata path)
847         external
848         view
849         returns (uint256[] memory amounts);
850 }
851 
852 interface IUniswapV2Router02 is IUniswapV2Router01 {
853     function removeLiquidityETHSupportingFeeOnTransferTokens(
854         address token,
855         uint256 liquidity,
856         uint256 amountTokenMin,
857         uint256 amountETHMin,
858         address to,
859         uint256 deadline
860     ) external returns (uint256 amountETH);
861 
862     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
863         address token,
864         uint256 liquidity,
865         uint256 amountTokenMin,
866         uint256 amountETHMin,
867         address to,
868         uint256 deadline,
869         bool approveMax,
870         uint8 v,
871         bytes32 r,
872         bytes32 s
873     ) external returns (uint256 amountETH);
874 
875     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
876         uint256 amountIn,
877         uint256 amountOutMin,
878         address[] calldata path,
879         address to,
880         uint256 deadline
881     ) external;
882 
883     function swapExactETHForTokensSupportingFeeOnTransferTokens(
884         uint256 amountOutMin,
885         address[] calldata path,
886         address to,
887         uint256 deadline
888     ) external payable;
889 
890     function swapExactTokensForETHSupportingFeeOnTransferTokens(
891         uint256 amountIn,
892         uint256 amountOutMin,
893         address[] calldata path,
894         address to,
895         uint256 deadline
896     ) external;
897 }
898 
899 /**
900  * @title Pausable
901  * @dev Base contract which allows children to implement an emergency stop mechanism.
902  */
903 contract Pausable is Ownable {
904     event Pause();
905     event Unpause();
906 
907     bool public paused = false;
908 
909     /**
910      * @dev Modifier to make a function callable only when the contract is not paused.
911      */
912     modifier whenNotPaused() {
913         require(!paused);
914         _;
915     }
916 
917     /**
918      * @dev Modifier to make a function callable only when the contract is paused.
919      */
920     modifier whenPaused() {
921         require(paused);
922         _;
923     }
924 
925     /**
926      * @dev called by the owner to pause, triggers stopped state
927      */
928     function pause() public onlyOwner whenNotPaused {
929         paused = true;
930         emit Pause();
931     }
932 
933     /**
934      * @dev called by the owner to unpause, returns to normal state
935      */
936     function unpause() public onlyOwner whenPaused {
937         paused = false;
938         emit Unpause();
939     }
940 }
941 
942 contract GRIND is Context, IERC20, Ownable, Pausable {
943     using SafeMath for uint256;
944     using Address for address;
945 
946     mapping(address => uint256) private _rOwned;
947     mapping(address => uint256) private _tOwned;
948     mapping(address => mapping(address => uint256)) private _allowances;
949 
950     mapping(address => bool) private _isExcludedFromFee;
951 
952     mapping(address => bool) private _isExcluded;
953     address[] private _excluded;
954     mapping(address => bool) private _isBlackListedBot;
955     address[] private _blackListedBots;
956 
957     uint256 private constant MAX = ~uint256(0);
958     uint256 private _tTotal = 15 * 10**9 * 10**9;
959     uint256 private _rTotal = (MAX - (MAX % _tTotal));
960     uint256 private _tFeeTotal;
961 
962     string private _name = "Grind Token";
963     string private _symbol = "GRIND";
964     uint8 private _decimals = 9;
965 
966     uint256 public _taxFee = 4;
967     uint256 private _previousTaxFee = _taxFee;
968 
969     uint256 public _liquidityFee = 2;
970     uint256 private _previousLiquidityFee = _liquidityFee;
971 
972     IUniswapV2Router02 public uniswapV2Router;
973     address public uniswapV2Pair;
974     address payable public _charityWalletAddress;
975     address payable public _marketingWalletAddress;
976     address payable public _devWalletAddress;
977 
978     bool inSwapAndLiquify;
979     bool public swapAndLiquifyEnabled = true;
980 
981     uint256 public _maxTxAmount = 4 * 10**9 * 10**9;    
982     uint256 private numTokensSellToAddToLiquidity = 4 * 10**7 * 10**9;
983 
984     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
985     event SwapAndLiquifyEnabledUpdated(bool enabled);
986     event DistributeRewards(
987         uint256 charityPercentage,
988         uint256 mmPercentage,
989         uint256 devPercentage
990     );
991 
992     modifier lockTheSwap {
993         inSwapAndLiquify = true;
994         _;
995         inSwapAndLiquify = false;
996     }
997 
998     constructor(
999         address payable charityWalletAddress,
1000         address payable marketingWalletAddress,
1001         address payable devWalletAddress
1002     ) public {
1003         _charityWalletAddress = charityWalletAddress;
1004         _marketingWalletAddress = marketingWalletAddress;
1005         _devWalletAddress = devWalletAddress;
1006         _rOwned[_msgSender()] = _rTotal;
1007 
1008         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1009             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1010         );
1011         // Create a uniswap pair for this new token
1012         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1013         .createPair(address(this), _uniswapV2Router.WETH());
1014 
1015         // set the rest of the contract variables
1016         uniswapV2Router = _uniswapV2Router;
1017 
1018         //exclude owner and this contract from fee
1019         _isExcludedFromFee[owner()] = true;
1020         _isExcludedFromFee[address(this)] = true;
1021 
1022         //blacklist bots
1023 
1024         _isBlackListedBot[
1025             address(0x3DAd8cf200799F82fD8eb68f608220d8f3eBF8De)
1026         ] = true;
1027         _blackListedBots.push(
1028             address(0x3DAd8cf200799F82fD8eb68f608220d8f3eBF8De)
1029         );
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
1136     function deliver(uint256 tAmount) public {
1137         address sender = _msgSender();
1138         require(
1139             !_isExcluded[sender],
1140             "Excluded addresses cannot call this function"
1141         );
1142         (uint256 rAmount, , , , , ) = _getValues(tAmount);
1143         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1144         _rTotal = _rTotal.sub(rAmount);
1145         _tFeeTotal = _tFeeTotal.add(tAmount);
1146     }
1147 
1148     function excludeFromReward(address account) public onlyOwner() {
1149         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
1150         require(!_isExcluded[account], "Account is already excluded");
1151         if (_rOwned[account] > 0) {
1152             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1153         }
1154         _isExcluded[account] = true;
1155         _excluded.push(account);
1156     }
1157 
1158     function includeInReward(address account) external onlyOwner() {
1159         require(_isExcluded[account], "Account is already excluded");
1160         for (uint256 i = 0; i < _excluded.length; i++) {
1161             if (_excluded[i] == account) {
1162                 _excluded[i] = _excluded[_excluded.length - 1];
1163                 _tOwned[account] = 0;
1164                 _isExcluded[account] = false;
1165                 _excluded.pop();
1166                 break;
1167             }
1168         }
1169     }
1170 
1171     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
1172         public
1173         view
1174         returns (uint256)
1175     {
1176         require(tAmount <= _tTotal, "Amount must be less than supply");
1177         if (!deductTransferFee) {
1178             (uint256 rAmount, , , , , ) = _getValues(tAmount);
1179             return rAmount;
1180         } else {
1181             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
1182             return rTransferAmount;
1183         }
1184     }
1185 
1186     function tokenFromReflection(uint256 rAmount)
1187         public
1188         view
1189         returns (uint256)
1190     {
1191         require(
1192             rAmount <= _rTotal,
1193             "Amount must be less than total reflections"
1194         );
1195         uint256 currentRate = _getRate();
1196         return rAmount.div(currentRate);
1197     }
1198 
1199     function addBotToBlacklist(address account) external onlyOwner() {
1200         require(
1201             account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D,
1202             "We cannot blacklist UniSwap router"
1203         );
1204         require(!_isBlackListedBot[account], "Account is already blacklisted");
1205         _isBlackListedBot[account] = true;
1206         _blackListedBots.push(account);
1207     }
1208 
1209     function removeBotFromBlacklist(address account) external onlyOwner() {
1210         require(_isBlackListedBot[account], "Account is not blacklisted");
1211         for (uint256 i = 0; i < _blackListedBots.length; i++) {
1212             if (_blackListedBots[i] == account) {
1213                 _blackListedBots[i] = _blackListedBots[
1214                     _blackListedBots.length - 1
1215                 ];
1216                 _isBlackListedBot[account] = false;
1217                 _blackListedBots.pop();
1218                 break;
1219             }
1220         }
1221     }
1222 
1223     function setRouterAddress(address newRouter) public onlyOwner() {
1224         IUniswapV2Router02 _newUniswapRouter = IUniswapV2Router02(newRouter);
1225         uniswapV2Pair = IUniswapV2Factory(_newUniswapRouter.factory())
1226         .createPair(address(this), _newUniswapRouter.WETH());
1227         uniswapV2Router = _newUniswapRouter;
1228     }
1229 
1230     function excludeFromFee(address account) public onlyOwner {
1231         _isExcludedFromFee[account] = true;
1232     }
1233 
1234     function _transferBothExcluded(
1235         address sender,
1236         address recipient,
1237         uint256 tAmount
1238     ) private {
1239         (
1240             uint256 rAmount,
1241             uint256 rTransferAmount,
1242             uint256 rFee,
1243             uint256 tTransferAmount,
1244             uint256 tFee,
1245             uint256 tLiquidity
1246         ) = _getValues(tAmount);
1247         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1248         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1249         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1250         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1251         _takeLiquidity(tLiquidity);
1252         _reflectFee(rFee, tFee);
1253         emit Transfer(sender, recipient, tTransferAmount);
1254     }
1255 
1256     function includeInFee(address account) public onlyOwner {
1257         _isExcludedFromFee[account] = false;
1258     }
1259 
1260     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1261         _taxFee = taxFee;
1262     }
1263 
1264     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
1265         _liquidityFee = liquidityFee;
1266     }
1267 
1268     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
1269         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
1270     }
1271 
1272     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1273         swapAndLiquifyEnabled = _enabled;
1274         emit SwapAndLiquifyEnabledUpdated(_enabled);
1275     }
1276 
1277     //to recieve ETH from uniswapV2Router when swaping
1278     receive() external payable {}
1279 
1280     function _reflectFee(uint256 rFee, uint256 tFee) private {
1281         _rTotal = _rTotal.sub(rFee);
1282         _tFeeTotal = _tFeeTotal.add(tFee);
1283     }
1284 
1285     function _getValues(uint256 tAmount)
1286         private
1287         view
1288         returns (
1289             uint256,
1290             uint256,
1291             uint256,
1292             uint256,
1293             uint256,
1294             uint256
1295         )
1296     {
1297         (
1298             uint256 tTransferAmount,
1299             uint256 tFee,
1300             uint256 tLiquidity
1301         ) = _getTValues(tAmount);
1302         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1303             tAmount,
1304             tFee,
1305             tLiquidity,
1306             _getRate()
1307         );
1308         return (
1309             rAmount,
1310             rTransferAmount,
1311             rFee,
1312             tTransferAmount,
1313             tFee,
1314             tLiquidity
1315         );
1316     }
1317 
1318     function _getTValues(uint256 tAmount)
1319         private
1320         view
1321         returns (
1322             uint256,
1323             uint256,
1324             uint256
1325         )
1326     {
1327         uint256 tFee = calculateTaxFee(tAmount);
1328         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1329         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1330         return (tTransferAmount, tFee, tLiquidity);
1331     }
1332 
1333     function _getRValues(
1334         uint256 tAmount,
1335         uint256 tFee,
1336         uint256 tLiquidity,
1337         uint256 currentRate
1338     )
1339         private
1340         pure
1341         returns (
1342             uint256,
1343             uint256,
1344             uint256
1345         )
1346     {
1347         uint256 rAmount = tAmount.mul(currentRate);
1348         uint256 rFee = tFee.mul(currentRate);
1349         uint256 rLiquidity = tLiquidity.mul(currentRate);
1350         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1351         return (rAmount, rTransferAmount, rFee);
1352     }
1353 
1354     function _getRate() private view returns (uint256) {
1355         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1356         return rSupply.div(tSupply);
1357     }
1358 
1359     function _getCurrentSupply() private view returns (uint256, uint256) {
1360         uint256 rSupply = _rTotal;
1361         uint256 tSupply = _tTotal;
1362         for (uint256 i = 0; i < _excluded.length; i++) {
1363             if (
1364                 _rOwned[_excluded[i]] > rSupply ||
1365                 _tOwned[_excluded[i]] > tSupply
1366             ) return (_rTotal, _tTotal);
1367             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1368             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1369         }
1370         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1371         return (rSupply, tSupply);
1372     }
1373 
1374     function _takeLiquidity(uint256 tLiquidity) private {
1375         uint256 currentRate = _getRate();
1376         uint256 rLiquidity = tLiquidity.mul(currentRate);
1377         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1378         if (_isExcluded[address(this)])
1379             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1380     }
1381 
1382     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1383         return _amount.mul(_taxFee).div(10**2);
1384     }
1385 
1386     function calculateLiquidityFee(uint256 _amount)
1387         private
1388         view
1389         returns (uint256)
1390     {
1391         return _amount.mul(_liquidityFee).div(10**2);
1392     }
1393 
1394     function removeAllFee() private {
1395         if (_taxFee == 0 && _liquidityFee == 0) return;
1396 
1397         _previousTaxFee = _taxFee;
1398         _previousLiquidityFee = _liquidityFee;
1399 
1400         _taxFee = 0;
1401         _liquidityFee = 0;
1402     }
1403 
1404     function restoreAllFee() private {
1405         _taxFee = _previousTaxFee;
1406         _liquidityFee = _previousLiquidityFee;
1407     }
1408 
1409     function isExcludedFromFee(address account) public view returns (bool) {
1410         return _isExcludedFromFee[account];
1411     }
1412 
1413     function _setCharityWallet(address payable charityWalletAddress)
1414         external
1415         onlyOwner()
1416     {
1417         _charityWalletAddress = charityWalletAddress;
1418     }
1419 
1420     function sendETHToCharity(uint256 amount) private {
1421         swapTokensForEth(amount);
1422         _charityWalletAddress.transfer(address(this).balance);
1423     }
1424 
1425     function _setMarketingWallet(address payable marketingWalletAddress)
1426         external
1427         onlyOwner()
1428     {
1429         _marketingWalletAddress = marketingWalletAddress;
1430     }
1431 
1432     function sendETHToMarketing(uint256 amount) private {
1433         swapTokensForEth(amount);
1434         _marketingWalletAddress.transfer(address(this).balance);
1435     }
1436 
1437     function _setDevWallet(address payable devWalletAddress)
1438         external
1439         onlyOwner()
1440     {
1441         _devWalletAddress = devWalletAddress;
1442     }
1443 
1444     function sendETHToDev(uint256 amount) private {
1445         swapTokensForEth(amount);
1446         _devWalletAddress.transfer(address(this).balance);
1447     }
1448 
1449     function _approve(
1450         address owner,
1451         address spender,
1452         uint256 amount
1453     ) private {
1454         require(owner != address(0), "ERC20: approve from the zero address");
1455         require(spender != address(0), "ERC20: approve to the zero address");
1456 
1457         _allowances[owner][spender] = amount;
1458         emit Approval(owner, spender, amount);
1459     }
1460 
1461     function _transfer(
1462         address from,
1463         address to,
1464         uint256 amount
1465     ) private {
1466         require(from != address(0), "ERC20: transfer from the zero address");
1467         require(to != address(0), "ERC20: transfer to the zero address");
1468         require(amount > 0, "Transfer amount must be greater than zero");
1469         require(!_isBlackListedBot[to], "You are blacklisted");
1470         require(!_isBlackListedBot[msg.sender], "You are blacklisted");
1471         require(!_isBlackListedBot[tx.origin], "You are blacklisted");
1472         if (from != owner() && to != owner())
1473             require(
1474                 amount <= _maxTxAmount,
1475                 "Transfer amount exceeds the maxTxAmount."
1476             );
1477 
1478         // is the token balance of this contract address over the min number of
1479         // tokens that we need to initiate a swap + liquidity lock?
1480         // also, don't get caught in a circular liquidity event.
1481         // also, don't swap & liquify if sender is uniswap pair.
1482         uint256 contractTokenBalance = balanceOf(address(this));
1483 
1484         if (contractTokenBalance >= _maxTxAmount) {
1485             contractTokenBalance = _maxTxAmount;
1486         }
1487 
1488         bool overMinTokenBalance = contractTokenBalance >=
1489             numTokensSellToAddToLiquidity;
1490         if (
1491             overMinTokenBalance &&
1492             !inSwapAndLiquify &&
1493             from != uniswapV2Pair &&
1494             swapAndLiquifyEnabled
1495         ) {
1496             contractTokenBalance = numTokensSellToAddToLiquidity;
1497             //add liquidity
1498             swapAndLiquify(contractTokenBalance);
1499         }
1500 
1501         //indicates if fee should be deducted from transfer
1502         bool takeFee = true;
1503 
1504         //if any account belongs to _isExcludedFromFee account then remove the fee
1505         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1506             takeFee = false;
1507         }
1508 
1509         //transfer amount, it will take tax, burn, liquidity fee
1510         _tokenTransfer(from, to, amount, takeFee);
1511     }
1512 
1513     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1514         uint256 charityPercentage = contractTokenBalance.div(10000).mul(1875);
1515         uint256 devPercentage = contractTokenBalance.div(1000).mul(375);
1516         uint256 mmPercentage = contractTokenBalance.div(10000).mul(4375);
1517 
1518         //send ETH to specified wallets
1519         sendETHToCharity(charityPercentage);
1520         sendETHToMarketing(mmPercentage);
1521         sendETHToDev(devPercentage);
1522 
1523         emit DistributeRewards(charityPercentage, mmPercentage, devPercentage);
1524     }
1525 
1526     function swapTokensForEth(uint256 tokenAmount) private {
1527         // generate the uniswap pair path of token -> weth
1528         address[] memory path = new address[](2);
1529         path[0] = address(this);
1530         path[1] = uniswapV2Router.WETH();
1531 
1532         _approve(address(this), address(uniswapV2Router), tokenAmount);
1533 
1534         // make the swap
1535         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1536             tokenAmount,
1537             0,
1538             path,
1539             address(this),
1540             block.timestamp
1541         );
1542     }
1543 
1544     //this method is responsible for taking all fee, if takeFee is true
1545     function _tokenTransfer(
1546         address sender,
1547         address recipient,
1548         uint256 amount,
1549         bool takeFee
1550     ) private {
1551         if (!takeFee) removeAllFee();
1552 
1553         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1554             _transferFromExcluded(sender, recipient, amount);
1555         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1556             _transferToExcluded(sender, recipient, amount);
1557         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1558             _transferStandard(sender, recipient, amount);
1559         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1560             _transferBothExcluded(sender, recipient, amount);
1561         } else {
1562             _transferStandard(sender, recipient, amount);
1563         }
1564 
1565         if (!takeFee) restoreAllFee();
1566     }
1567 
1568     function _transferStandard(
1569         address sender,
1570         address recipient,
1571         uint256 tAmount
1572     ) private {
1573         (
1574             uint256 rAmount,
1575             uint256 rTransferAmount,
1576             uint256 rFee,
1577             uint256 tTransferAmount,
1578             uint256 tFee,
1579             uint256 tLiquidity
1580         ) = _getValues(tAmount);
1581         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1582         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1583         _takeLiquidity(tLiquidity);
1584         _reflectFee(rFee, tFee);
1585         emit Transfer(sender, recipient, tTransferAmount);
1586     }
1587 
1588     function _transferFromExcluded(
1589         address sender,
1590         address recipient,
1591         uint256 tAmount
1592     ) private {
1593         (
1594             uint256 rAmount,
1595             uint256 rTransferAmount,
1596             uint256 rFee,
1597             uint256 tTransferAmount,
1598             uint256 tFee,
1599             uint256 tLiquidity
1600         ) = _getValues(tAmount);
1601         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1602         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1603         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1604         _takeLiquidity(tLiquidity);
1605         _reflectFee(rFee, tFee);
1606         emit Transfer(sender, recipient, tTransferAmount);
1607     }
1608 
1609     function _transferToExcluded(
1610         address sender,
1611         address recipient,
1612         uint256 tAmount
1613     ) private {
1614         (
1615             uint256 rAmount,
1616             uint256 rTransferAmount,
1617             uint256 rFee,
1618             uint256 tTransferAmount,
1619             uint256 tFee,
1620             uint256 tLiquidity
1621         ) = _getValues(tAmount);
1622         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1623         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1624         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1625         _takeLiquidity(tLiquidity);
1626         _reflectFee(rFee, tFee);
1627         emit Transfer(sender, recipient, tTransferAmount);
1628     }
1629 }