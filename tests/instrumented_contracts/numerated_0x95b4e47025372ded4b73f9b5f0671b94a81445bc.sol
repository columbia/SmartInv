1 /** 
2 
3 Telegram Portal: https://t.me/infinityxplay_portal
4 Website: infinitygaming.io
5 Twitter: https://twitter.com/infinityxplay
6 
7 */
8 
9 
10 pragma solidity ^0.8.10;
11 
12 // SPDX-License-Identifier: Unlicensed
13 interface IERC20 {
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount)
29         external
30         returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender)
40         external
41         view
42         returns (uint256);
43 
44     /**
45      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * IMPORTANT: Beware that changing an allowance with this method brings the risk
50      * that someone may use both the old and the new allowance by unfortunate
51      * transaction ordering. One possible solution to mitigate this race
52      * condition is to first reduce the spender's allowance to 0 and set the
53      * desired value afterwards:
54      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
55      *
56      * Emits an {Approval} event.
57      */
58     function approve(address spender, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Moves `amount` tokens from `sender` to `recipient` using the
62      * allowance mechanism. `amount` is then deducted from the caller's
63      * allowance.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transferFrom(
70         address sender,
71         address recipient,
72         uint256 amount
73     ) external returns (bool);
74 
75     /**
76      * @dev Emitted when `value` tokens are moved from one account (`from`) to
77      * another (`to`).
78      *
79      * Note that `value` may be zero.
80      */
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     /**
84      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
85      * a call to {approve}. `value` is the new allowance.
86      */
87     event Approval(
88         address indexed owner,
89         address indexed spender,
90         uint256 value
91     );
92 }
93 
94 /**
95  * @dev Wrappers over Solidity's arithmetic operations with added overflow
96  * checks.
97  *
98  * Arithmetic operations in Solidity wrap on overflow. This can easily result
99  * in bugs, because programmers usually assume that an overflow raises an
100  * error, which is the standard behavior in high level programming languages.
101  * `SafeMath` restores this intuition by reverting the transaction when an
102  * operation overflows.
103  *
104  * Using this library instead of the unchecked operations eliminates an entire
105  * class of bugs, so it's recommended to use it always.
106  */
107 
108 library SafeMath {
109     /**
110      * @dev Returns the addition of two unsigned integers, reverting on
111      * overflow.
112      *
113      * Counterpart to Solidity's `+` operator.
114      *
115      * Requirements:
116      *
117      * - Addition cannot overflow.
118      */
119     function add(uint256 a, uint256 b) internal pure returns (uint256) {
120         uint256 c = a + b;
121         require(c >= a, "SafeMath: addition overflow");
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the subtraction of two unsigned integers, reverting on
128      * overflow (when the result is negative).
129      *
130      * Counterpart to Solidity's `-` operator.
131      *
132      * Requirements:
133      *
134      * - Subtraction cannot overflow.
135      */
136     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
137         return sub(a, b, "SafeMath: subtraction overflow");
138     }
139 
140     /**
141      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
142      * overflow (when the result is negative).
143      *
144      * Counterpart to Solidity's `-` operator.
145      *
146      * Requirements:
147      *
148      * - Subtraction cannot overflow.
149      */
150     function sub(
151         uint256 a,
152         uint256 b,
153         string memory errorMessage
154     ) internal pure returns (uint256) {
155         require(b <= a, errorMessage);
156         uint256 c = a - b;
157 
158         return c;
159     }
160 
161     /**
162      * @dev Returns the multiplication of two unsigned integers, reverting on
163      * overflow.
164      *
165      * Counterpart to Solidity's `*` operator.
166      *
167      * Requirements:
168      *
169      * - Multiplication cannot overflow.
170      */
171     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
172         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
173         // benefit is lost if 'b' is also tested.
174         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
175         if (a == 0) {
176             return 0;
177         }
178 
179         uint256 c = a * b;
180         require(c / a == b, "SafeMath: multiplication overflow");
181 
182         return c;
183     }
184 
185     /**
186      * @dev Returns the integer division of two unsigned integers. Reverts on
187      * division by zero. The result is rounded towards zero.
188      *
189      * Counterpart to Solidity's `/` operator. Note: this function uses a
190      * `revert` opcode (which leaves remaining gas untouched) while Solidity
191      * uses an invalid opcode to revert (consuming all remaining gas).
192      *
193      * Requirements:
194      *
195      * - The divisor cannot be zero.
196      */
197     function div(uint256 a, uint256 b) internal pure returns (uint256) {
198         return div(a, b, "SafeMath: division by zero");
199     }
200 
201     /**
202      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
203      * division by zero. The result is rounded towards zero.
204      *
205      * Counterpart to Solidity's `/` operator. Note: this function uses a
206      * `revert` opcode (which leaves remaining gas untouched) while Solidity
207      * uses an invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function div(
214         uint256 a,
215         uint256 b,
216         string memory errorMessage
217     ) internal pure returns (uint256) {
218         require(b > 0, errorMessage);
219         uint256 c = a / b;
220         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
221 
222         return c;
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * Reverts when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
238         return mod(a, b, "SafeMath: modulo by zero");
239     }
240 
241     /**
242      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
243      * Reverts with custom message when dividing by zero.
244      *
245      * Counterpart to Solidity's `%` operator. This function uses a `revert`
246      * opcode (which leaves remaining gas untouched) while Solidity uses an
247      * invalid opcode to revert (consuming all remaining gas).
248      *
249      * Requirements:
250      *
251      * - The divisor cannot be zero.
252      */
253     function mod(
254         uint256 a,
255         uint256 b,
256         string memory errorMessage
257     ) internal pure returns (uint256) {
258         require(b != 0, errorMessage);
259         return a % b;
260     }
261 }
262 
263 abstract contract Context {
264     function _msgSender() internal view virtual returns (address payable) {
265         return payable(msg.sender);
266     }
267 
268     function _msgData() internal view virtual returns (bytes memory) {
269         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
270         return msg.data;
271     }
272 }
273 
274 /**
275  * @dev Collection of functions related to the address type
276  */
277 library Address {
278     /**
279      * @dev Returns true if `account` is a contract.
280      *
281      * [IMPORTANT]
282      * ====
283      * It is unsafe to assume that an address for which this function returns
284      * false is an externally-owned account (EOA) and not a contract.
285      *
286      * Among others, `isContract` will return false for the following
287      * types of addresses:
288      *
289      *  - an externally-owned account
290      *  - a contract in construction
291      *  - an address where a contract will be created
292      *  - an address where a contract lived, but was destroyed
293      * ====
294      */
295     function isContract(address account) internal view returns (bool) {
296         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
297         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
298         // for accounts without code, i.e. `keccak256('')`
299         bytes32 codehash;
300         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
301         // solhint-disable-next-line no-inline-assembly
302         assembly {
303             codehash := extcodehash(account)
304         }
305         return (codehash != accountHash && codehash != 0x0);
306     }
307 
308     /**
309      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
310      * `recipient`, forwarding all available gas and reverting on errors.
311      *
312      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
313      * of certain opcodes, possibly making contracts go over the 2300 gas limit
314      * imposed by `transfer`, making them unable to receive funds via
315      * `transfer`. {sendValue} removes this limitation.
316      *
317      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
318      *
319      * IMPORTANT: because control is transferred to `recipient`, care must be
320      * taken to not create reentrancy vulnerabilities. Consider using
321      * {ReentrancyGuard} or the
322      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
323      */
324     function sendValue(address payable recipient, uint256 amount) internal {
325         require(
326             address(this).balance >= amount,
327             "Address: insufficient balance"
328         );
329 
330         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
331         (bool success, ) = recipient.call{value: amount}("");
332         require(
333             success,
334             "Address: unable to send value, recipient may have reverted"
335         );
336     }
337 
338     /**
339      * @dev Performs a Solidity function call using a low level `call`. A
340      * plain`call` is an unsafe replacement for a function call: use this
341      * function instead.
342      *
343      * If `target` reverts with a revert reason, it is bubbled up by this
344      * function (like regular Solidity function calls).
345      *
346      * Returns the raw returned data. To convert to the expected return value,
347      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
348      *
349      * Requirements:
350      *
351      * - `target` must be a contract.
352      * - calling `target` with `data` must not revert.
353      *
354      * _Available since v3.1._
355      */
356     function functionCall(address target, bytes memory data)
357         internal
358         returns (bytes memory)
359     {
360         return functionCall(target, data, "Address: low-level call failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
365      * `errorMessage` as a fallback revert reason when `target` reverts.
366      *
367      * _Available since v3.1._
368      */
369     function functionCall(
370         address target,
371         bytes memory data,
372         string memory errorMessage
373     ) internal returns (bytes memory) {
374         return _functionCallWithValue(target, data, 0, errorMessage);
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
379      * but also transferring `value` wei to `target`.
380      *
381      * Requirements:
382      *
383      * - the calling contract must have an ETH balance of at least `value`.
384      * - the called Solidity function must be `payable`.
385      *
386      * _Available since v3.1._
387      */
388     function functionCallWithValue(
389         address target,
390         bytes memory data,
391         uint256 value
392     ) internal returns (bytes memory) {
393         return
394             functionCallWithValue(
395                 target,
396                 data,
397                 value,
398                 "Address: low-level call with value failed"
399             );
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
404      * with `errorMessage` as a fallback revert reason when `target` reverts.
405      *
406      * _Available since v3.1._
407      */
408     function functionCallWithValue(
409         address target,
410         bytes memory data,
411         uint256 value,
412         string memory errorMessage
413     ) internal returns (bytes memory) {
414         require(
415             address(this).balance >= value,
416             "Address: insufficient balance for call"
417         );
418         return _functionCallWithValue(target, data, value, errorMessage);
419     }
420 
421     function _functionCallWithValue(
422         address target,
423         bytes memory data,
424         uint256 weiValue,
425         string memory errorMessage
426     ) private returns (bytes memory) {
427         require(isContract(target), "Address: call to non-contract");
428 
429         // solhint-disable-next-line avoid-low-level-calls
430         (bool success, bytes memory returndata) = target.call{value: weiValue}(
431             data
432         );
433         if (success) {
434             return returndata;
435         } else {
436             // Look for revert reason and bubble it up if present
437             if (returndata.length > 0) {
438                 // The easiest way to bubble the revert reason is using memory via assembly
439 
440                 // solhint-disable-next-line no-inline-assembly
441                 assembly {
442                     let returndata_size := mload(returndata)
443                     revert(add(32, returndata), returndata_size)
444                 }
445             } else {
446                 revert(errorMessage);
447             }
448         }
449     }
450 }
451 
452 /**
453  * @dev Contract module which provides a basic access control mechanism, where
454  * there is an account (an owner) that can be granted exclusive access to
455  * specific functions.
456  *
457  * By default, the owner account will be the one that deploys the contract. This
458  * can later be changed with {transferOwnership}.
459  *
460  * This module is used through inheritance. It will make available the modifier
461  * `onlyOwner`, which can be applied to your functions to restrict their use to
462  * the owner.
463  */
464 contract Ownable is Context {
465     address private _owner;
466     address private _previousOwner;
467     uint256 private _lockTime;
468 
469     event OwnershipTransferred(
470         address indexed previousOwner,
471         address indexed newOwner
472     );
473 
474     /**
475      * @dev Initializes the contract setting the deployer as the initial owner.
476      */
477     constructor() {
478         address msgSender = _msgSender();
479         _owner = msgSender;
480         emit OwnershipTransferred(address(0), msgSender);
481     }
482 
483     /**
484      * @dev Returns the address of the current owner.
485      */
486     function owner() public view returns (address) {
487         return _owner;
488     }
489 
490     /**
491      * @dev Throws if called by any account other than the owner.
492      */
493     modifier onlyOwner() {
494         require(_owner == _msgSender(), "Ownable: caller is not the owner");
495         _;
496     }
497 
498     /**
499      * @dev Leaves the contract without owner. It will not be possible to call
500      * `onlyOwner` functions anymore. Can only be called by the current owner.
501      *
502      * NOTE: Renouncing ownership will leave the contract without an owner,
503      * thereby removing any functionality that is only available to the owner.
504      */
505     function renounceOwnership() public virtual onlyOwner {
506         emit OwnershipTransferred(_owner, address(0));
507         _owner = address(0);
508     }
509 
510     /**
511      * @dev Transfers ownership of the contract to a new account (`newOwner`).
512      * Can only be called by the current owner.
513      */
514     function transferOwnership(address newOwner) public virtual onlyOwner {
515         require(
516             newOwner != address(0),
517             "Ownable: new owner is the zero address"
518         );
519         emit OwnershipTransferred(_owner, newOwner);
520         _owner = newOwner;
521     }
522 
523     function geUnlockTime() public view returns (uint256) {
524         return _lockTime;
525     }
526 
527     //Locks the contract for owner for the amount of time provided
528     function lock(uint256 time) public virtual onlyOwner {
529         _previousOwner = _owner;
530         _owner = address(0);
531         _lockTime = block.timestamp + time;
532         emit OwnershipTransferred(_owner, address(0));
533     }
534 
535     //Unlocks the contract for owner when _lockTime is exceeds
536     function unlock() public virtual {
537         require(
538             _previousOwner == msg.sender,
539             "You don't have permission to unlock"
540         );
541         require(block.timestamp > _lockTime, "Contract is locked until a later date");
542         emit OwnershipTransferred(_owner, _previousOwner);
543         _owner = _previousOwner;
544         _previousOwner = address(0);
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
852 // pragma solidity >=0.6.2;
853 
854 interface IUniswapV2Router02 is IUniswapV2Router01 {
855     function removeLiquidityETHSupportingFeeOnTransferTokens(
856         address token,
857         uint256 liquidity,
858         uint256 amountTokenMin,
859         uint256 amountETHMin,
860         address to,
861         uint256 deadline
862     ) external returns (uint256 amountETH);
863 
864     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
865         address token,
866         uint256 liquidity,
867         uint256 amountTokenMin,
868         uint256 amountETHMin,
869         address to,
870         uint256 deadline,
871         bool approveMax,
872         uint8 v,
873         bytes32 r,
874         bytes32 s
875     ) external returns (uint256 amountETH);
876 
877     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
878         uint256 amountIn,
879         uint256 amountOutMin,
880         address[] calldata path,
881         address to,
882         uint256 deadline
883     ) external;
884 
885     function swapExactETHForTokensSupportingFeeOnTransferTokens(
886         uint256 amountOutMin,
887         address[] calldata path,
888         address to,
889         uint256 deadline
890     ) external payable;
891 
892     function swapExactTokensForETHSupportingFeeOnTransferTokens(
893         uint256 amountIn,
894         uint256 amountOutMin,
895         address[] calldata path,
896         address to,
897         uint256 deadline
898     ) external;
899 }
900 
901 contract InfinityGaming is Context, IERC20, Ownable {
902     using SafeMath for uint256;
903     using Address for address;
904 
905     mapping(address => uint256) private _rOwned;
906     mapping(address => uint256) private _tOwned;
907     mapping(address => mapping(address => uint256)) private _allowances;
908 
909     mapping(address => bool) private _isExcludedFromFee;
910 
911     mapping(address => bool) private _isExcluded;
912     address[] private _excluded;
913     mapping(address => bool) private _isBlackListedBot;
914 
915     mapping(address => bool) private _isExcludedFromLimit;
916     address[] private _blackListedBots;
917 
918     uint256 private constant MAX = ~uint256(0);
919     uint256 private _tTotal = 1000000 * 10**6 * 10**9;
920     uint256 private _rTotal = (MAX - (MAX % _tTotal));
921     uint256 private _tFeeTotal;
922 
923     address payable public _marketingAddress =
924         payable(address(0xAa6242ec31AC72CC5929a3939ACA7c38d73906e7));
925     address payable public _devwallet =
926         payable(address(0xF834fF81B492615E4d0Cd5Cf4B6089F8A0E4222c));
927     address public _exchangewallet =
928         payable(address(0x9448Bc5e6D09270d8E31e24991B3941Ea88d9604));
929     address _partnershipswallet =
930         payable(address(0x3fcaC6ecC2d0365EDD177a3F34a460d9266E6C50));
931     address private _donationAddress =
932         0x000000000000000000000000000000000000dEaD;
933 
934     string private _name = "InfinityGaming";
935     string private _symbol = "PLAY";
936     uint8 private _decimals = 9;
937 
938     struct BuyFee {
939         uint16 tax;
940         uint16 liquidity;
941         uint16 marketing;
942         uint16 dev;
943         uint16 donation;
944     }
945 
946     struct SellFee {
947         uint16 tax;
948         uint16 liquidity;
949         uint16 marketing;
950         uint16 dev;
951         uint16 donation;
952     }
953 
954     BuyFee public buyFee;
955     SellFee public sellFee;
956 
957     uint16 private _taxFee;
958     uint16 private _liquidityFee;
959     uint16 private _marketingFee;
960     uint16 private _devFee;
961     uint16 private _donationFee;
962 
963     IUniswapV2Router02 public immutable uniswapV2Router;
964     address public immutable uniswapV2Pair;
965 
966     bool inSwapAndLiquify;
967     bool public swapAndLiquifyEnabled = true;
968 
969     uint256 public _maxTxAmount = 3000 * 10**6 * 10**9;
970     uint256 private numTokensSellToAddToLiquidity = 5000 * 10**6 * 10**9;
971     uint256 public _maxWalletSize = 15000 * 10**6 * 10**9;
972 
973     event botAddedToBlacklist(address account);
974     event botRemovedFromBlacklist(address account);
975 
976     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
977     event SwapAndLiquifyEnabledUpdated(bool enabled);
978     event SwapAndLiquify(
979         uint256 tokensSwapped,
980         uint256 ethReceived,
981         uint256 tokensIntoLiqudity
982     );
983 
984     modifier lockTheSwap() {
985         inSwapAndLiquify = true;
986         _;
987         inSwapAndLiquify = false;
988     }
989 
990     constructor() {
991         _rOwned[_msgSender()] = _rTotal;
992 
993         buyFee.tax = 78;
994         buyFee.liquidity = 10;
995         buyFee.marketing = 10;
996         buyFee.dev = 0;
997         buyFee.donation = 0;
998 
999         sellFee.tax = 78;
1000         sellFee.liquidity = 10;
1001         sellFee.marketing = 10;
1002         sellFee.dev = 0;
1003         sellFee.donation = 0;
1004 
1005         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1006             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1007         );
1008         // Create a uniswap pair for this new token
1009         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1010             .createPair(address(this), _uniswapV2Router.WETH());
1011 
1012         // set the rest of the contract variables
1013         uniswapV2Router = _uniswapV2Router;
1014 
1015         // exclude owner, dev wallet, and this contract from fee
1016         _isExcludedFromFee[owner()] = true;
1017         _isExcludedFromFee[address(this)] = true;
1018         _isExcludedFromFee[_marketingAddress] = true;
1019         _isExcludedFromFee[_devwallet] = true;
1020         _isExcludedFromFee[_exchangewallet] = true;
1021         _isExcludedFromFee[_partnershipswallet] = true;
1022 
1023         _isExcludedFromLimit[_marketingAddress] = true;
1024         _isExcludedFromLimit[_devwallet] = true;
1025         _isExcludedFromLimit[_exchangewallet] = true;
1026         _isExcludedFromLimit[_partnershipswallet] = true;
1027         _isExcludedFromLimit[owner()] = true;
1028         _isExcludedFromLimit[address(this)] = true;
1029 
1030         emit Transfer(address(0), _msgSender(), _tTotal);
1031     }
1032 
1033     function name() public view returns (string memory) {
1034         return _name;
1035     }
1036 
1037     function symbol() public view returns (string memory) {
1038         return _symbol;
1039     }
1040 
1041     function decimals() public view returns (uint8) {
1042         return _decimals;
1043     }
1044 
1045     function totalSupply() public view override returns (uint256) {
1046         return _tTotal;
1047     }
1048 
1049     function balanceOf(address account) public view override returns (uint256) {
1050         if (_isExcluded[account]) return _tOwned[account];
1051         return tokenFromReflection(_rOwned[account]);
1052     }
1053 
1054     function transfer(address recipient, uint256 amount)
1055         public
1056         override
1057         returns (bool)
1058     {
1059         _transfer(_msgSender(), recipient, amount);
1060         return true;
1061     }
1062 
1063     function allowance(address owner, address spender)
1064         public
1065         view
1066         override
1067         returns (uint256)
1068     {
1069         return _allowances[owner][spender];
1070     }
1071 
1072     function approve(address spender, uint256 amount)
1073         public
1074         override
1075         returns (bool)
1076     {
1077         _approve(_msgSender(), spender, amount);
1078         return true;
1079     }
1080 
1081     function transferFrom(
1082         address sender,
1083         address recipient,
1084         uint256 amount
1085     ) public override returns (bool) {
1086         _transfer(sender, recipient, amount);
1087         _approve(
1088             sender,
1089             _msgSender(),
1090             _allowances[sender][_msgSender()].sub(
1091                 amount,
1092                 "ERC20: transfer amount exceeds allowance"
1093             )
1094         );
1095         return true;
1096     }
1097 
1098     function increaseAllowance(address spender, uint256 addedValue)
1099         public
1100         virtual
1101         returns (bool)
1102     {
1103         _approve(
1104             _msgSender(),
1105             spender,
1106             _allowances[_msgSender()][spender].add(addedValue)
1107         );
1108         return true;
1109     }
1110 
1111     function decreaseAllowance(address spender, uint256 subtractedValue)
1112         public
1113         virtual
1114         returns (bool)
1115     {
1116         _approve(
1117             _msgSender(),
1118             spender,
1119             _allowances[_msgSender()][spender].sub(
1120                 subtractedValue,
1121                 "ERC20: decreased allowance below zero"
1122             )
1123         );
1124         return true;
1125     }
1126 
1127     function isExcludedFromReward(address account) public view returns (bool) {
1128         return _isExcluded[account];
1129     }
1130 
1131     function totalFees() public view returns (uint256) {
1132         return _tFeeTotal;
1133     }
1134 
1135     function donationAddress() public view returns (address) {
1136         return _donationAddress;
1137     }
1138 
1139     function deliver(uint256 tAmount) public {
1140         address sender = _msgSender();
1141         require(
1142             !_isExcluded[sender],
1143             "Excluded addresses cannot call this function"
1144         );
1145 
1146         (
1147             ,
1148             uint256 tFee,
1149             uint256 tLiquidity,
1150             uint256 tWallet,
1151             uint256 tDonation
1152         ) = _getTValues(tAmount);
1153         (uint256 rAmount, , ) = _getRValues(
1154             tAmount,
1155             tFee,
1156             tLiquidity,
1157             tWallet,
1158             tDonation,
1159             _getRate()
1160         );
1161 
1162         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1163         _rTotal = _rTotal.sub(rAmount);
1164         _tFeeTotal = _tFeeTotal.add(tAmount);
1165     }
1166 
1167     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
1168         public
1169         view
1170         returns (uint256)
1171     {
1172         require(tAmount <= _tTotal, "Amount must be less than supply");
1173 
1174         (
1175             ,
1176             uint256 tFee,
1177             uint256 tLiquidity,
1178             uint256 tWallet,
1179             uint256 tDonation
1180         ) = _getTValues(tAmount);
1181         (uint256 rAmount, uint256 rTransferAmount, ) = _getRValues(
1182             tAmount,
1183             tFee,
1184             tLiquidity,
1185             tWallet,
1186             tDonation,
1187             _getRate()
1188         );
1189 
1190         if (!deductTransferFee) {
1191             return rAmount;
1192         } else {
1193             return rTransferAmount;
1194         }
1195     }
1196 
1197     function tokenFromReflection(uint256 rAmount)
1198         public
1199         view
1200         returns (uint256)
1201     {
1202         require(
1203             rAmount <= _rTotal,
1204             "Amount must be less than total reflections"
1205         );
1206         uint256 currentRate = _getRate();
1207         return rAmount.div(currentRate);
1208     }
1209 
1210 
1211     function updateMarketingWallet(address payable newAddress) external onlyOwner {
1212         _marketingAddress = newAddress;
1213     }
1214 
1215     function updateDevWallet(address payable newAddress) external onlyOwner {
1216         _devwallet = newAddress;
1217     }
1218 
1219     function updateExchangeWallet(address newAddress) external onlyOwner {
1220         _exchangewallet = newAddress;
1221     }
1222 
1223     function updatePartnershipsWallet(address newAddress) external onlyOwner {
1224         _partnershipswallet = newAddress;
1225     }
1226 
1227     function addBotToBlacklist(address account) external onlyOwner {
1228         require(
1229             account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D,
1230             "We cannot blacklist UniSwap router"
1231         );
1232         require(!_isBlackListedBot[account], "Account is already blacklisted");
1233         _isBlackListedBot[account] = true;
1234         _blackListedBots.push(account);
1235     }
1236 
1237     function removeBotFromBlacklist(address account) external onlyOwner {
1238         require(_isBlackListedBot[account], "Account is not blacklisted");
1239         for (uint256 i = 0; i < _blackListedBots.length; i++) {
1240             if (_blackListedBots[i] == account) {
1241                 _blackListedBots[i] = _blackListedBots[
1242                     _blackListedBots.length - 1
1243                 ];
1244                 _isBlackListedBot[account] = false;
1245                 _blackListedBots.pop();
1246                 break;
1247             }
1248         }
1249     }
1250 
1251     function excludeFromReward(address account) public onlyOwner {
1252         require(!_isExcluded[account], "Account is already excluded");
1253         if (_rOwned[account] > 0) {
1254             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1255         }
1256         _isExcluded[account] = true;
1257         _excluded.push(account);
1258     }
1259 
1260     function includeInReward(address account) external onlyOwner {
1261         require(_isExcluded[account], "Account is not excluded");
1262         for (uint256 i = 0; i < _excluded.length; i++) {
1263             if (_excluded[i] == account) {
1264                 _excluded[i] = _excluded[_excluded.length - 1];
1265                 _tOwned[account] = 0;
1266                 _isExcluded[account] = false;
1267                 _excluded.pop();
1268                 break;
1269             }
1270         }
1271     }
1272 
1273     function excludeFromFee(address account) public onlyOwner {
1274         _isExcludedFromFee[account] = true;
1275     }
1276 
1277     function includeInFee(address account) public onlyOwner {
1278         _isExcludedFromFee[account] = false;
1279     }
1280 
1281     function excludeFromLimit(address account) public onlyOwner {
1282         _isExcludedFromLimit[account] = true;
1283     }
1284 
1285     function includeInLimit(address account) public onlyOwner {
1286         _isExcludedFromLimit[account] = false;
1287     }
1288 
1289     function setSellFee(
1290         uint16 tax,
1291         uint16 liquidity,
1292         uint16 marketing,
1293         uint16 dev,
1294         uint16 donation
1295     ) external onlyOwner {
1296         sellFee.tax = tax;
1297         sellFee.marketing = marketing;
1298         sellFee.liquidity = liquidity;
1299         sellFee.dev = dev;
1300         sellFee.donation = donation;
1301     }
1302 
1303     function setBuyFee(
1304         uint16 tax,
1305         uint16 liquidity,
1306         uint16 marketing,
1307         uint16 dev,
1308         uint16 donation
1309     ) external onlyOwner {
1310         buyFee.tax = tax;
1311         buyFee.marketing = marketing;
1312         buyFee.liquidity = liquidity;
1313         buyFee.dev = dev;
1314         buyFee.donation = donation;
1315     }
1316 
1317     function setBothFees(
1318         uint16 buy_tax,
1319         uint16 buy_liquidity,
1320         uint16 buy_marketing,
1321         uint16 buy_dev,
1322         uint16 buy_donation,
1323         uint16 sell_tax,
1324         uint16 sell_liquidity,
1325         uint16 sell_marketing,
1326         uint16 sell_dev,
1327         uint16 sell_donation
1328 
1329     ) external onlyOwner {
1330         buyFee.tax = buy_tax;
1331         buyFee.marketing = buy_marketing;
1332         buyFee.liquidity = buy_liquidity;
1333         buyFee.dev = buy_dev;
1334         buyFee.donation = buy_donation;
1335 
1336         sellFee.tax = sell_tax;
1337         sellFee.marketing = sell_marketing;
1338         sellFee.liquidity = sell_liquidity;
1339         sellFee.dev = sell_dev;
1340         sellFee.donation = sell_donation;
1341     }
1342 
1343     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner {
1344         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**3);
1345     }
1346 
1347     function _setMaxWalletSizePercent(uint256 maxWalletSize)
1348         external
1349         onlyOwner
1350     {
1351         _maxWalletSize = _tTotal.mul(maxWalletSize).div(10**3);
1352     }
1353 
1354     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1355         swapAndLiquifyEnabled = _enabled;
1356         emit SwapAndLiquifyEnabledUpdated(_enabled);
1357     }
1358 
1359     //to recieve ETH from uniswapV2Router when swapping
1360     receive() external payable {}
1361 
1362     function _reflectFee(uint256 rFee, uint256 tFee) private {
1363         _rTotal = _rTotal.sub(rFee);
1364         _tFeeTotal = _tFeeTotal.add(tFee);
1365     }
1366 
1367     function _getTValues(uint256 tAmount)
1368         private
1369         view
1370         returns (
1371             uint256,
1372             uint256,
1373             uint256,
1374             uint256,
1375             uint256
1376         )
1377     {
1378         uint256 tFee = calculateTaxFee(tAmount);
1379         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1380         uint256 tWallet = calculateMarketingFee(tAmount) +
1381             calculateDevFee(tAmount);
1382         uint256 tDonation = calculateDonationFee(tAmount);
1383         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1384         tTransferAmount = tTransferAmount.sub(tWallet);
1385         tTransferAmount = tTransferAmount.sub(tDonation);
1386 
1387         return (tTransferAmount, tFee, tLiquidity, tWallet, tDonation);
1388     }
1389 
1390     function _getRValues(
1391         uint256 tAmount,
1392         uint256 tFee,
1393         uint256 tLiquidity,
1394         uint256 tWallet,
1395         uint256 tDonation,
1396         uint256 currentRate
1397     )
1398         private
1399         pure
1400         returns (
1401             uint256,
1402             uint256,
1403             uint256
1404         )
1405     {
1406         uint256 rAmount = tAmount.mul(currentRate);
1407         uint256 rFee = tFee.mul(currentRate);
1408         uint256 rLiquidity = tLiquidity.mul(currentRate);
1409         uint256 rWallet = tWallet.mul(currentRate);
1410         uint256 rDonation = tDonation.mul(currentRate);
1411         uint256 rTransferAmount = rAmount
1412             .sub(rFee)
1413             .sub(rLiquidity)
1414             .sub(rWallet)
1415             .sub(rDonation);
1416         return (rAmount, rTransferAmount, rFee);
1417     }
1418 
1419     function _getRate() private view returns (uint256) {
1420         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1421         return rSupply.div(tSupply);
1422     }
1423 
1424     function _getCurrentSupply() private view returns (uint256, uint256) {
1425         uint256 rSupply = _rTotal;
1426         uint256 tSupply = _tTotal;
1427         for (uint256 i = 0; i < _excluded.length; i++) {
1428             if (
1429                 _rOwned[_excluded[i]] > rSupply ||
1430                 _tOwned[_excluded[i]] > tSupply
1431             ) return (_rTotal, _tTotal);
1432             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1433             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1434         }
1435         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1436         return (rSupply, tSupply);
1437     }
1438 
1439     function _takeLiquidity(uint256 tLiquidity) private {
1440         uint256 currentRate = _getRate();
1441         uint256 rLiquidity = tLiquidity.mul(currentRate);
1442         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1443         if (_isExcluded[address(this)])
1444             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1445     }
1446 
1447     function _takeWalletFee(uint256 tWallet) private {
1448         uint256 currentRate = _getRate();
1449         uint256 rWallet = tWallet.mul(currentRate);
1450         _rOwned[address(this)] = _rOwned[address(this)].add(rWallet);
1451         if (_isExcluded[address(this)])
1452             _tOwned[address(this)] = _tOwned[address(this)].add(tWallet);
1453     }
1454 
1455     function _takeDonationFee(uint256 tDonation) private {
1456         uint256 currentRate = _getRate();
1457         uint256 rDonation = tDonation.mul(currentRate);
1458         _rOwned[_donationAddress] = _rOwned[_donationAddress].add(rDonation);
1459         if (_isExcluded[_donationAddress])
1460             _tOwned[_donationAddress] = _tOwned[_donationAddress].add(
1461                 tDonation
1462             );
1463     }
1464 
1465     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1466         return _amount.mul(_taxFee).div(10**2);
1467     }
1468 
1469     function calculateLiquidityFee(uint256 _amount)
1470         private
1471         view
1472         returns (uint256)
1473     {
1474         return _amount.mul(_liquidityFee).div(10**2);
1475     }
1476 
1477     function calculateMarketingFee(uint256 _amount)
1478         private
1479         view
1480         returns (uint256)
1481     {
1482         return _amount.mul(_marketingFee).div(10**2);
1483     }
1484 
1485     function calculateDonationFee(uint256 _amount)
1486         private
1487         view
1488         returns (uint256)
1489     {
1490         return _amount.mul(_donationFee).div(10**2);
1491     }
1492 
1493     function calculateDevFee(uint256 _amount) private view returns (uint256) {
1494         return _amount.mul(_devFee).div(10**2);
1495     }
1496 
1497     function removeAllFee() private {
1498         _taxFee = 0;
1499         _liquidityFee = 0;
1500         _marketingFee = 0;
1501         _donationFee = 0;
1502         _devFee = 0;
1503     }
1504 
1505     function setBuy() private {
1506         _taxFee = buyFee.tax;
1507         _liquidityFee = buyFee.liquidity;
1508         _marketingFee = buyFee.marketing;
1509         _donationFee = buyFee.donation;
1510         _devFee = buyFee.dev;
1511     }
1512 
1513     function setSell() private {
1514         _taxFee = sellFee.tax;
1515         _liquidityFee = sellFee.liquidity;
1516         _marketingFee = sellFee.marketing;
1517         _donationFee = sellFee.donation;
1518         _devFee = sellFee.dev;
1519     }
1520 
1521     function isExcludedFromFee(address account) public view returns (bool) {
1522         return _isExcludedFromFee[account];
1523     }
1524 
1525     function isExcludedFromLimit(address account) public view returns (bool) {
1526         return _isExcludedFromLimit[account];
1527     }
1528 
1529     function _approve(
1530         address owner,
1531         address spender,
1532         uint256 amount
1533     ) private {
1534         require(owner != address(0), "ERC20: approve from the zero address");
1535         require(spender != address(0), "ERC20: approve to the zero address");
1536 
1537         _allowances[owner][spender] = amount;
1538         emit Approval(owner, spender, amount);
1539     }
1540 
1541     function _transfer(
1542         address from,
1543         address to,
1544         uint256 amount
1545     ) private {
1546         require(from != address(0), "ERC20: transfer from the zero address");
1547         require(to != address(0), "ERC20: transfer to the zero address");
1548         require(amount > 0, "Transfer amount must be greater than zero");
1549         require(!_isBlackListedBot[from], "You are blacklisted");
1550         require(!_isBlackListedBot[msg.sender], "blacklisted");
1551         require(!_isBlackListedBot[tx.origin], "blacklisted");
1552 
1553         // is the token balance of this contract address over the min number of
1554         // tokens that we need to initiate a swap + liquidity lock?
1555         // also, don't get caught in a circular liquidity event.
1556         // also, don't swap & liquify if sender is uniswap pair.
1557         uint256 contractTokenBalance = balanceOf(address(this));
1558 
1559         if (contractTokenBalance >= _maxTxAmount) {
1560             contractTokenBalance = _maxTxAmount;
1561         }
1562 
1563         bool overMinTokenBalance = contractTokenBalance >=
1564             numTokensSellToAddToLiquidity;
1565         if (
1566             overMinTokenBalance &&
1567             !inSwapAndLiquify &&
1568             from != uniswapV2Pair &&
1569             swapAndLiquifyEnabled
1570         ) {
1571             contractTokenBalance = numTokensSellToAddToLiquidity;
1572             //add liquidity
1573             swapAndLiquify(contractTokenBalance);
1574         }
1575 
1576         //indicates if fee should be deducted from transfer
1577         bool takeFee = true;
1578 
1579         //if any account belongs to _isExcludedFromFee account then remove the fee
1580         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1581             takeFee = false;
1582         }
1583         if (takeFee) {
1584             if (!_isExcludedFromLimit[from] && !_isExcludedFromLimit[to]) {
1585                 require(
1586                     amount <= _maxTxAmount,
1587                     "Transfer amount exceeds the maxTxAmount."
1588                 );
1589                 if (to != uniswapV2Pair) {
1590                     require(
1591                         amount + balanceOf(to) <= _maxWalletSize,
1592                         "Recipient exceeds max wallet size."
1593                     );
1594                 }
1595             }
1596         }
1597 
1598         //transfer amount, it will take tax, burn, liquidity fee
1599         _tokenTransfer(from, to, amount, takeFee);
1600     }
1601 
1602     function swapAndLiquify(uint256 tokens) private lockTheSwap {
1603         // Split the contract balance into halves
1604         uint256 denominator = (buyFee.liquidity +
1605             sellFee.liquidity +
1606             buyFee.marketing +
1607             sellFee.marketing +
1608             buyFee.dev +
1609             sellFee.dev) * 2;
1610         uint256 tokensToAddLiquidityWith = (tokens *
1611             (buyFee.liquidity + sellFee.liquidity)) / denominator;
1612         uint256 toSwap = tokens - tokensToAddLiquidityWith;
1613 
1614         uint256 initialBalance = address(this).balance;
1615 
1616         swapTokensForEth(toSwap);
1617 
1618         uint256 deltaBalance = address(this).balance - initialBalance;
1619         uint256 unitBalance = deltaBalance /
1620             (denominator - (buyFee.liquidity + sellFee.liquidity));
1621         uint256 bnbToAddLiquidityWith = unitBalance *
1622             (buyFee.liquidity + sellFee.liquidity);
1623 
1624         if (bnbToAddLiquidityWith > 0) {
1625             // Add liquidity to pancake
1626             addLiquidity(tokensToAddLiquidityWith, bnbToAddLiquidityWith);
1627         }
1628 
1629         // Send ETH to marketing
1630         uint256 marketingAmt = unitBalance *
1631             2 *
1632             (buyFee.marketing + sellFee.marketing);
1633         uint256 devAmt = unitBalance * 2 * (buyFee.dev + sellFee.dev) >
1634             address(this).balance
1635             ? address(this).balance
1636             : unitBalance * 2 * (buyFee.dev + sellFee.dev);
1637 
1638         if (marketingAmt > 0) {
1639             payable(_marketingAddress).transfer(marketingAmt);
1640         }
1641 
1642         if (devAmt > 0) {
1643             _devwallet.transfer(devAmt);
1644         }
1645     }
1646 
1647     function swapTokensForEth(uint256 tokenAmount) private {
1648         // generate the uniswap pair path of token -> weth
1649         address[] memory path = new address[](2);
1650         path[0] = address(this);
1651         path[1] = uniswapV2Router.WETH();
1652 
1653         _approve(address(this), address(uniswapV2Router), tokenAmount);
1654 
1655         // make the swap
1656         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1657             tokenAmount,
1658             0, // accept any amount of ETH
1659             path,
1660             address(this),
1661             block.timestamp
1662         );
1663     }
1664 
1665     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1666         // approve token transfer to cover all possible scenarios
1667         _approve(address(this), address(uniswapV2Router), tokenAmount);
1668 
1669         // add the liquidity
1670         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1671             address(this),
1672             tokenAmount,
1673             0, // slippage is unavoidable
1674             0, // slippage is unavoidable
1675             address(this),
1676             block.timestamp
1677         );
1678     }
1679 
1680     //this method is responsible for taking all fee, if takeFee is true
1681     function _tokenTransfer(
1682         address sender,
1683         address recipient,
1684         uint256 amount,
1685         bool takeFee
1686     ) private {
1687         if (takeFee) {
1688             removeAllFee();
1689             if (sender == uniswapV2Pair) {
1690                 setBuy();
1691             }
1692             if (recipient == uniswapV2Pair) {
1693                 setSell();
1694             }
1695         }
1696 
1697         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1698             _transferFromExcluded(sender, recipient, amount);
1699         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1700             _transferToExcluded(sender, recipient, amount);
1701         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1702             _transferStandard(sender, recipient, amount);
1703         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1704             _transferBothExcluded(sender, recipient, amount);
1705         } else {
1706             _transferStandard(sender, recipient, amount);
1707         }
1708         removeAllFee();
1709     }
1710 
1711     function _transferStandard(
1712         address sender,
1713         address recipient,
1714         uint256 tAmount
1715     ) private {
1716         (
1717             uint256 tTransferAmount,
1718             uint256 tFee,
1719             uint256 tLiquidity,
1720             uint256 tWallet,
1721             uint256 tDonation
1722         ) = _getTValues(tAmount);
1723         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1724             tAmount,
1725             tFee,
1726             tLiquidity,
1727             tWallet,
1728             tDonation,
1729             _getRate()
1730         );
1731 
1732         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1733         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1734         _takeLiquidity(tLiquidity);
1735         _takeWalletFee(tWallet);
1736         _takeDonationFee(tDonation);
1737         _reflectFee(rFee, tFee);
1738         emit Transfer(sender, recipient, tTransferAmount);
1739     }
1740 
1741 
1742     function _transferToExcluded(
1743         address sender,
1744         address recipient,
1745         uint256 tAmount
1746     ) private {
1747         (
1748             uint256 tTransferAmount,
1749             uint256 tFee,
1750             uint256 tLiquidity,
1751             uint256 tWallet,
1752             uint256 tDonation
1753         ) = _getTValues(tAmount);
1754         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1755             tAmount,
1756             tFee,
1757             tLiquidity,
1758             tWallet,
1759             tDonation,
1760             _getRate()
1761         );
1762 
1763         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1764         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1765         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1766         _takeLiquidity(tLiquidity);
1767         _takeWalletFee(tWallet);
1768         _takeDonationFee(tDonation);
1769         _reflectFee(rFee, tFee);
1770         emit Transfer(sender, recipient, tTransferAmount);
1771     }
1772 
1773     function _transferFromExcluded(
1774         address sender,
1775         address recipient,
1776         uint256 tAmount
1777     ) private {
1778         (
1779             uint256 tTransferAmount,
1780             uint256 tFee,
1781             uint256 tLiquidity,
1782             uint256 tWallet,
1783             uint256 tDonation
1784         ) = _getTValues(tAmount);
1785         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1786             tAmount,
1787             tFee,
1788             tLiquidity,
1789             tWallet,
1790             tDonation,
1791             _getRate()
1792         );
1793 
1794         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1795         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1796         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1797         _takeLiquidity(tLiquidity);
1798         _takeWalletFee(tWallet);
1799         _takeDonationFee(tDonation);
1800         _reflectFee(rFee, tFee);
1801         emit Transfer(sender, recipient, tTransferAmount);
1802     }
1803 
1804     function _transferBothExcluded(
1805         address sender,
1806         address recipient,
1807         uint256 tAmount
1808     ) private {
1809         (
1810             uint256 tTransferAmount,
1811             uint256 tFee,
1812             uint256 tLiquidity,
1813             uint256 tWallet,
1814             uint256 tDonation
1815         ) = _getTValues(tAmount);
1816         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1817             tAmount,
1818             tFee,
1819             tLiquidity,
1820             tWallet,
1821             tDonation,
1822             _getRate()
1823         );
1824 
1825         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1826         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1827         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1828         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1829         _takeLiquidity(tLiquidity);
1830         _takeWalletFee(tWallet);
1831         _takeDonationFee(tDonation);
1832         _reflectFee(rFee, tFee);
1833         emit Transfer(sender, recipient, tTransferAmount);
1834     }
1835 }