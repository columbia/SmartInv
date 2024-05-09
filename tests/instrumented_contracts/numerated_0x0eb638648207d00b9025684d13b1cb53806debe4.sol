1 /**                                                                                
2 _________________________________
3 |   __  __    _____    ___      |
4 |   | \| |    |_ _|    | |      |
5 |   | .` |     | |     | |__    |
6 |   |_|\_|    |___|    |____|   |
7 |_||"""""""|_|"""""|_|"""""""||_|
8 |_______________________________|
9 
10  */
11 
12 /**
13  *Submitted for verification at Etherscan.io on 2021-12-28
14  */
15 
16 pragma solidity ^0.8.9;
17 
18 // SPDX-License-Identifier: Unlicensed
19 interface IERC20 {
20     function totalSupply() external view returns (uint256);
21 
22     /**
23      * @dev Returns the amount of tokens owned by `account`.
24      */
25     function balanceOf(address account) external view returns (uint256);
26 
27     /**
28      * @dev Moves `amount` tokens from the caller's account to `recipient`.
29      *
30      * Returns a boolean value indicating whether the operation succeeded.
31      *
32      * Emits a {Transfer} event.
33      */
34     function transfer(address recipient, uint256 amount)
35         external
36         returns (bool);
37 
38     /**
39      * @dev Returns the remaining number of tokens that `spender` will be
40      * allowed to spend on behalf of `owner` through {transferFrom}. This is
41      * zero by default.
42      *
43      * This value changes when {approve} or {transferFrom} are called.
44      */
45     function allowance(address owner, address spender)
46         external
47         view
48         returns (uint256);
49 
50     /**
51      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * IMPORTANT: Beware that changing an allowance with this method brings the risk
56      * that someone may use both the old and the new allowance by unfortunate
57      * transaction ordering. One possible solution to mitigate this race
58      * condition is to first reduce the spender's allowance to 0 and set the
59      * desired value afterwards:
60      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
61      *
62      * Emits an {Approval} event.
63      */
64     function approve(address spender, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Moves `amount` tokens from `sender` to `recipient` using the
68      * allowance mechanism. `amount` is then deducted from the caller's
69      * allowance.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * Emits a {Transfer} event.
74      */
75     function transferFrom(
76         address sender,
77         address recipient,
78         uint256 amount
79     ) external returns (bool);
80 
81     /**
82      * @dev Emitted when `value` tokens are moved from one account (`from`) to
83      * another (`to`).
84      *
85      * Note that `value` may be zero.
86      */
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 
89     /**
90      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
91      * a call to {approve}. `value` is the new allowance.
92      */
93     event Approval(
94         address indexed owner,
95         address indexed spender,
96         uint256 value
97     );
98 }
99 
100 /**
101  * @dev Wrappers over Solidity's arithmetic operations with added overflow
102  * checks.
103  *
104  * Arithmetic operations in Solidity wrap on overflow. This can easily result
105  * in bugs, because programmers usually assume that an overflow raises an
106  * error, which is the standard behavior in high level programming languages.
107  * `SafeMath` restores this intuition by reverting the transaction when an
108  * operation overflows.
109  *
110  * Using this library instead of the unchecked operations eliminates an entire
111  * class of bugs, so it's recommended to use it always.
112  */
113 
114 library SafeMath {
115     /**
116      * @dev Returns the addition of two unsigned integers, reverting on
117      * overflow.
118      *
119      * Counterpart to Solidity's `+` operator.
120      *
121      * Requirements:
122      *
123      * - Addition cannot overflow.
124      */
125     function add(uint256 a, uint256 b) internal pure returns (uint256) {
126         uint256 c = a + b;
127         require(c >= a, "SafeMath: addition overflow");
128 
129         return c;
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting on
134      * overflow (when the result is negative).
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      *
140      * - Subtraction cannot overflow.
141      */
142     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
143         return sub(a, b, "SafeMath: subtraction overflow");
144     }
145 
146     /**
147      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
148      * overflow (when the result is negative).
149      *
150      * Counterpart to Solidity's `-` operator.
151      *
152      * Requirements:
153      *
154      * - Subtraction cannot overflow.
155      */
156     function sub(
157         uint256 a,
158         uint256 b,
159         string memory errorMessage
160     ) internal pure returns (uint256) {
161         require(b <= a, errorMessage);
162         uint256 c = a - b;
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the multiplication of two unsigned integers, reverting on
169      * overflow.
170      *
171      * Counterpart to Solidity's `*` operator.
172      *
173      * Requirements:
174      *
175      * - Multiplication cannot overflow.
176      */
177     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
178         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
179         // benefit is lost if 'b' is also tested.
180         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
181         if (a == 0) {
182             return 0;
183         }
184 
185         uint256 c = a * b;
186         require(c / a == b, "SafeMath: multiplication overflow");
187 
188         return c;
189     }
190 
191     /**
192      * @dev Returns the integer division of two unsigned integers. Reverts on
193      * division by zero. The result is rounded towards zero.
194      *
195      * Counterpart to Solidity's `/` operator. Note: this function uses a
196      * `revert` opcode (which leaves remaining gas untouched) while Solidity
197      * uses an invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      *
201      * - The divisor cannot be zero.
202      */
203     function div(uint256 a, uint256 b) internal pure returns (uint256) {
204         return div(a, b, "SafeMath: division by zero");
205     }
206 
207     /**
208      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
209      * division by zero. The result is rounded towards zero.
210      *
211      * Counterpart to Solidity's `/` operator. Note: this function uses a
212      * `revert` opcode (which leaves remaining gas untouched) while Solidity
213      * uses an invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function div(
220         uint256 a,
221         uint256 b,
222         string memory errorMessage
223     ) internal pure returns (uint256) {
224         require(b > 0, errorMessage);
225         uint256 c = a / b;
226         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
227 
228         return c;
229     }
230 
231     /**
232      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
233      * Reverts when dividing by zero.
234      *
235      * Counterpart to Solidity's `%` operator. This function uses a `revert`
236      * opcode (which leaves remaining gas untouched) while Solidity uses an
237      * invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      *
241      * - The divisor cannot be zero.
242      */
243     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
244         return mod(a, b, "SafeMath: modulo by zero");
245     }
246 
247     /**
248      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
249      * Reverts with custom message when dividing by zero.
250      *
251      * Counterpart to Solidity's `%` operator. This function uses a `revert`
252      * opcode (which leaves remaining gas untouched) while Solidity uses an
253      * invalid opcode to revert (consuming all remaining gas).
254      *
255      * Requirements:
256      *
257      * - The divisor cannot be zero.
258      */
259     function mod(
260         uint256 a,
261         uint256 b,
262         string memory errorMessage
263     ) internal pure returns (uint256) {
264         require(b != 0, errorMessage);
265         return a % b;
266     }
267 }
268 
269 abstract contract Context {
270     //function _msgSender() internal view virtual returns (address payable) {
271     function _msgSender() internal view virtual returns (address) {
272         return msg.sender;
273     }
274 
275     function _msgData() internal view virtual returns (bytes memory) {
276         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
277         return msg.data;
278     }
279 }
280 
281 /**
282  * @dev Collection of functions related to the address type
283  */
284 library Address {
285     /**
286      * @dev Returns true if `account` is a contract.
287      *
288      * [IMPORTANT]
289      * ====
290      * It is unsafe to assume that an address for which this function returns
291      * false is an externally-owned account (EOA) and not a contract.
292      *
293      * Among others, `isContract` will return false for the following
294      * types of addresses:
295      *
296      *  - an externally-owned account
297      *  - a contract in construction
298      *  - an address where a contract will be created
299      *  - an address where a contract lived, but was destroyed
300      * ====
301      */
302     function isContract(address account) internal view returns (bool) {
303         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
304         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
305         // for accounts without code, i.e. `keccak256('')`
306         bytes32 codehash;
307         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
308         // solhint-disable-next-line no-inline-assembly
309         assembly {
310             codehash := extcodehash(account)
311         }
312         return (codehash != accountHash && codehash != 0x0);
313     }
314 
315     /**
316      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
317      * `recipient`, forwarding all available gas and reverting on errors.
318      *
319      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
320      * of certain opcodes, possibly making contracts go over the 2300 gas limit
321      * imposed by `transfer`, making them unable to receive funds via
322      * `transfer`. {sendValue} removes this limitation.
323      *
324      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
325      *
326      * IMPORTANT: because control is transferred to `recipient`, care must be
327      * taken to not create reentrancy vulnerabilities. Consider using
328      * {ReentrancyGuard} or the
329      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
330      */
331     function sendValue(address payable recipient, uint256 amount) internal {
332         require(
333             address(this).balance >= amount,
334             "Address: insufficient balance"
335         );
336 
337         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
338         (bool success, ) = recipient.call{value: amount}("");
339         require(
340             success,
341             "Address: unable to send value, recipient may have reverted"
342         );
343     }
344 
345     /**
346      * @dev Performs a Solidity function call using a low level `call`. A
347      * plain`call` is an unsafe replacement for a function call: use this
348      * function instead.
349      *
350      * If `target` reverts with a revert reason, it is bubbled up by this
351      * function (like regular Solidity function calls).
352      *
353      * Returns the raw returned data. To convert to the expected return value,
354      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
355      *
356      * Requirements:
357      *
358      * - `target` must be a contract.
359      * - calling `target` with `data` must not revert.
360      *
361      * _Available since v3.1._
362      */
363     function functionCall(address target, bytes memory data)
364         internal
365         returns (bytes memory)
366     {
367         return functionCall(target, data, "Address: low-level call failed");
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
372      * `errorMessage` as a fallback revert reason when `target` reverts.
373      *
374      * _Available since v3.1._
375      */
376     function functionCall(
377         address target,
378         bytes memory data,
379         string memory errorMessage
380     ) internal returns (bytes memory) {
381         return _functionCallWithValue(target, data, 0, errorMessage);
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
386      * but also transferring `value` wei to `target`.
387      *
388      * Requirements:
389      *
390      * - the calling contract must have an ETH balance of at least `value`.
391      * - the called Solidity function must be `payable`.
392      *
393      * _Available since v3.1._
394      */
395     function functionCallWithValue(
396         address target,
397         bytes memory data,
398         uint256 value
399     ) internal returns (bytes memory) {
400         return
401             functionCallWithValue(
402                 target,
403                 data,
404                 value,
405                 "Address: low-level call with value failed"
406             );
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
411      * with `errorMessage` as a fallback revert reason when `target` reverts.
412      *
413      * _Available since v3.1._
414      */
415     function functionCallWithValue(
416         address target,
417         bytes memory data,
418         uint256 value,
419         string memory errorMessage
420     ) internal returns (bytes memory) {
421         require(
422             address(this).balance >= value,
423             "Address: insufficient balance for call"
424         );
425         return _functionCallWithValue(target, data, value, errorMessage);
426     }
427 
428     function _functionCallWithValue(
429         address target,
430         bytes memory data,
431         uint256 weiValue,
432         string memory errorMessage
433     ) private returns (bytes memory) {
434         require(isContract(target), "Address: call to non-contract");
435 
436         // solhint-disable-next-line avoid-low-level-calls
437         (bool success, bytes memory returndata) = target.call{value: weiValue}(
438             data
439         );
440         if (success) {
441             return returndata;
442         } else {
443             // Look for revert reason and bubble it up if present
444             if (returndata.length > 0) {
445                 // The easiest way to bubble the revert reason is using memory via assembly
446 
447                 // solhint-disable-next-line no-inline-assembly
448                 assembly {
449                     let returndata_size := mload(returndata)
450                     revert(add(32, returndata), returndata_size)
451                 }
452             } else {
453                 revert(errorMessage);
454             }
455         }
456     }
457 }
458 
459 /**
460  * @dev Contract module which provides a basic access control mechanism, where
461  * there is an account (an owner) that can be granted exclusive access to
462  * specific functions.
463  *
464  * By default, the owner account will be the one that deploys the contract. This
465  * can later be changed with {transferOwnership}.
466  *
467  * This module is used through inheritance. It will make available the modifier
468  * `onlyOwner`, which can be applied to your functions to restrict their use to
469  * the owner.
470  */
471 contract Ownable is Context {
472     address private _owner;
473     address private _previousOwner;
474     uint256 private _lockTime;
475 
476     event OwnershipTransferred(
477         address indexed previousOwner,
478         address indexed newOwner
479     );
480 
481     /**
482      * @dev Initializes the contract setting the deployer as the initial owner.
483      */
484     constructor() {
485         address msgSender = _msgSender();
486         _owner = msgSender;
487         emit OwnershipTransferred(address(0), msgSender);
488     }
489 
490     /**
491      * @dev Returns the address of the current owner.
492      */
493     function owner() public view returns (address) {
494         return _owner;
495     }
496 
497     /**
498      * @dev Throws if called by any account other than the owner.
499      */
500     modifier onlyOwner() {
501         require(_owner == _msgSender(), "Ownable: caller is not the owner");
502         _;
503     }
504 
505     /**
506      * @dev Leaves the contract without owner. It will not be possible to call
507      * `onlyOwner` functions anymore. Can only be called by the current owner.
508      *
509      * NOTE: Renouncing ownership will leave the contract without an owner,
510      * thereby removing any functionality that is only available to the owner.
511      */
512     function renounceOwnership() public virtual onlyOwner {
513         emit OwnershipTransferred(_owner, address(0));
514         _owner = address(0);
515     }
516 
517     /**
518      * @dev Transfers ownership of the contract to a new account (`newOwner`).
519      * Can only be called by the current owner.
520      */
521     function transferOwnership(address newOwner) public virtual onlyOwner {
522         require(
523             newOwner != address(0),
524             "Ownable: new owner is the zero address"
525         );
526         emit OwnershipTransferred(_owner, newOwner);
527         _owner = newOwner;
528     }
529 
530     function geUnlockTime() public view returns (uint256) {
531         return _lockTime;
532     }
533 
534     //Locks the contract for owner for the amount of time provided
535     function lock(uint256 time) public virtual onlyOwner {
536         _previousOwner = _owner;
537         _owner = address(0);
538         _lockTime = block.timestamp + time;
539         emit OwnershipTransferred(_owner, address(0));
540     }
541 
542     //Unlocks the contract for owner when _lockTime is exceeds
543     function unlock() public virtual {
544         require(
545             _previousOwner == msg.sender,
546             "You don't have permission to unlock"
547         );
548         require(block.timestamp > _lockTime, "Contract is locked until 7 days");
549         emit OwnershipTransferred(_owner, _previousOwner);
550         _owner = _previousOwner;
551     }
552 }
553 
554 interface IUniswapV2Factory {
555     event PairCreated(
556         address indexed token0,
557         address indexed token1,
558         address pair,
559         uint256
560     );
561 
562     function feeTo() external view returns (address);
563 
564     function feeToSetter() external view returns (address);
565 
566     function getPair(address tokenA, address tokenB)
567         external
568         view
569         returns (address pair);
570 
571     function allPairs(uint256) external view returns (address pair);
572 
573     function allPairsLength() external view returns (uint256);
574 
575     function createPair(address tokenA, address tokenB)
576         external
577         returns (address pair);
578 
579     function setFeeTo(address) external;
580 
581     function setFeeToSetter(address) external;
582 }
583 
584 interface IUniswapV2Pair {
585     event Approval(
586         address indexed owner,
587         address indexed spender,
588         uint256 value
589     );
590     event Transfer(address indexed from, address indexed to, uint256 value);
591 
592     function name() external pure returns (string memory);
593 
594     function symbol() external pure returns (string memory);
595 
596     function decimals() external pure returns (uint8);
597 
598     function totalSupply() external view returns (uint256);
599 
600     function balanceOf(address owner) external view returns (uint256);
601 
602     function allowance(address owner, address spender)
603         external
604         view
605         returns (uint256);
606 
607     function approve(address spender, uint256 value) external returns (bool);
608 
609     function transfer(address to, uint256 value) external returns (bool);
610 
611     function transferFrom(
612         address from,
613         address to,
614         uint256 value
615     ) external returns (bool);
616 
617     function DOMAIN_SEPARATOR() external view returns (bytes32);
618 
619     function PERMIT_TYPEHASH() external pure returns (bytes32);
620 
621     function nonces(address owner) external view returns (uint256);
622 
623     function permit(
624         address owner,
625         address spender,
626         uint256 value,
627         uint256 deadline,
628         uint8 v,
629         bytes32 r,
630         bytes32 s
631     ) external;
632 
633     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
634     event Burn(
635         address indexed sender,
636         uint256 amount0,
637         uint256 amount1,
638         address indexed to
639     );
640     event Swap(
641         address indexed sender,
642         uint256 amount0In,
643         uint256 amount1In,
644         uint256 amount0Out,
645         uint256 amount1Out,
646         address indexed to
647     );
648     event Sync(uint112 reserve0, uint112 reserve1);
649 
650     function MINIMUM_LIQUIDITY() external pure returns (uint256);
651 
652     function factory() external view returns (address);
653 
654     function token0() external view returns (address);
655 
656     function token1() external view returns (address);
657 
658     function getReserves()
659         external
660         view
661         returns (
662             uint112 reserve0,
663             uint112 reserve1,
664             uint32 blockTimestampLast
665         );
666 
667     function price0CumulativeLast() external view returns (uint256);
668 
669     function price1CumulativeLast() external view returns (uint256);
670 
671     function kLast() external view returns (uint256);
672 
673     function mint(address to) external returns (uint256 liquidity);
674 
675     function burn(address to)
676         external
677         returns (uint256 amount0, uint256 amount1);
678 
679     function swap(
680         uint256 amount0Out,
681         uint256 amount1Out,
682         address to,
683         bytes calldata data
684     ) external;
685 
686     function skim(address to) external;
687 
688     function sync() external;
689 
690     function initialize(address, address) external;
691 }
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
899 interface IAirdrop {
900     function airdrop(address recipient, uint256 amount) external;
901 }
902 
903 contract NIL is Context, IERC20, Ownable {
904     using SafeMath for uint256;
905     using Address for address;
906 
907     mapping(address => uint256) private _rOwned;
908     mapping(address => uint256) private _tOwned;
909     mapping(address => mapping(address => uint256)) private _allowances;
910 
911     mapping(address => bool) private _isExcludedFromFee;
912 
913     mapping(address => uint256) private lockedAmount;
914     mapping(address => uint256) private lockedTime;
915     mapping(address => string) private lockedReason;
916 
917     mapping(address => bool) private _isExcluded;
918     address[] private _excluded;
919 
920     mapping(address => bool) public whitelist;
921     bool public canTrade = false;
922 
923     uint256 private constant MAX = ~uint256(0);
924     uint256 private _tTotal = 1000000000 * 10**3 * 10**8;
925     uint256 private _rTotal = (MAX - (MAX % _tTotal));
926     uint256 private _tFeeTotal;
927 
928     address public burnAddress = 0x000000000000000000000000000000000000dEaD;
929     address public marketingWallet = 0x83F2fDC5414B85E9703a89588600e097032B58dc;
930 
931     string private _name = "NIL Coin";
932     string private _symbol = "NIL";
933     uint8 private _decimals = 8;
934 
935     uint256 public _taxFee = 5;
936     uint256 private _previousTaxFee = _taxFee;
937 
938     uint256 public _burnFee = 2;
939     uint256 private _previousBurnFee = _burnFee;
940 
941     uint256 public _liquidityFee = 5;
942     uint256 private _previousLiquidityFee = _liquidityFee;
943 
944     uint256 public _marketingFee = 3;
945     uint256 private _previousMarketingFee = _marketingFee;
946 
947     IUniswapV2Router02 public immutable uniswapV2Router;
948     address public immutable uniswapV2Pair;
949 
950     bool internal inSwapAndLiquify;
951     bool public swapAndLiquifyEnabled = true;
952 
953     uint256 public _maxTxAmount = 2000000 * 10**3 * 10**8;
954     uint256 public numTokensSellToAddToLiquidity = 1000000 * 10**3 * 10**8;
955 
956     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
957     event SwapAndLiquifyEnabledUpdated(bool enabled);
958     event SwapAndLiquify(
959         uint256 tokensSwapped,
960         uint256 ethReceived,
961         uint256 tokensIntoLiqudity
962     );
963 
964     modifier lockTheSwap() {
965         inSwapAndLiquify = true;
966         _;
967         inSwapAndLiquify = false;
968     }
969 
970     constructor() {
971         _rOwned[_msgSender()] = _rTotal;
972 
973         //IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E); //Mainnet BSC
974         //IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3); //Testnet BSC
975         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
976             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
977         ); //Mainnet & Testnet ETH
978         // Create a uniswap pair for this new token
979         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
980             .createPair(address(this), _uniswapV2Router.WETH());
981 
982         // set the rest of the contract variables
983         uniswapV2Router = _uniswapV2Router;
984 
985         //exclude owner and this contract from fee
986         _isExcludedFromFee[owner()] = true;
987         _isExcludedFromFee[address(this)] = true;
988 
989         emit Transfer(address(0), _msgSender(), _tTotal);
990     }
991 
992     function name() public view returns (string memory) {
993         return _name;
994     }
995 
996     function symbol() public view returns (string memory) {
997         return _symbol;
998     }
999 
1000     function decimals() public view returns (uint8) {
1001         return _decimals;
1002     }
1003 
1004     function totalSupply() public view override returns (uint256) {
1005         return _tTotal;
1006     }
1007 
1008     function balanceOf(address account) public view override returns (uint256) {
1009         if (_isExcluded[account]) return _tOwned[account];
1010         return tokenFromReflection(_rOwned[account]);
1011     }
1012 
1013     function transfer(address recipient, uint256 amount)
1014         public
1015         override
1016         returns (bool)
1017     {
1018         _transfer(_msgSender(), recipient, amount);
1019         return true;
1020     }
1021 
1022     function allowance(address owner, address spender)
1023         public
1024         view
1025         override
1026         returns (uint256)
1027     {
1028         return _allowances[owner][spender];
1029     }
1030 
1031     function approve(address spender, uint256 amount)
1032         public
1033         override
1034         returns (bool)
1035     {
1036         _approve(_msgSender(), spender, amount);
1037         return true;
1038     }
1039 
1040     function transferFrom(
1041         address sender,
1042         address recipient,
1043         uint256 amount
1044     ) public override returns (bool) {
1045         _transfer(sender, recipient, amount);
1046         _approve(
1047             sender,
1048             _msgSender(),
1049             _allowances[sender][_msgSender()].sub(
1050                 amount,
1051                 "ERC20: transfer amount exceeds allowance"
1052             )
1053         );
1054         return true;
1055     }
1056 
1057     function increaseAllowance(address spender, uint256 addedValue)
1058         public
1059         virtual
1060         returns (bool)
1061     {
1062         _approve(
1063             _msgSender(),
1064             spender,
1065             _allowances[_msgSender()][spender].add(addedValue)
1066         );
1067         return true;
1068     }
1069 
1070     function decreaseAllowance(address spender, uint256 subtractedValue)
1071         public
1072         virtual
1073         returns (bool)
1074     {
1075         _approve(
1076             _msgSender(),
1077             spender,
1078             _allowances[_msgSender()][spender].sub(
1079                 subtractedValue,
1080                 "ERC20: decreased allowance below zero"
1081             )
1082         );
1083         return true;
1084     }
1085 
1086     function isExcludedFromReward(address account) public view returns (bool) {
1087         return _isExcluded[account];
1088     }
1089 
1090     function totalFees() public view returns (uint256) {
1091         return _tFeeTotal;
1092     }
1093 
1094     function airdrop(address recipient, uint256 amount) external onlyOwner {
1095         removeAllFee();
1096         _transfer(_msgSender(), recipient, amount * 10**8);
1097         restoreAllFee();
1098     }
1099 
1100     function deliver(uint256 tAmount) public {
1101         address sender = _msgSender();
1102         require(
1103             !_isExcluded[sender],
1104             "Excluded addresses cannot call this function"
1105         );
1106         (uint256 rAmount, , , , , ) = _getValues(tAmount);
1107         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1108         _rTotal = _rTotal.sub(rAmount);
1109         _tFeeTotal = _tFeeTotal.add(tAmount);
1110     }
1111 
1112     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
1113         public
1114         view
1115         returns (uint256)
1116     {
1117         require(tAmount <= _tTotal, "Amount must be less than supply");
1118         if (!deductTransferFee) {
1119             (uint256 rAmount, , , , , ) = _getValues(tAmount);
1120             return rAmount;
1121         } else {
1122             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
1123             return rTransferAmount;
1124         }
1125     }
1126 
1127     function tokenFromReflection(uint256 rAmount)
1128         public
1129         view
1130         returns (uint256)
1131     {
1132         require(
1133             rAmount <= _rTotal,
1134             "Amount must be less than total reflections"
1135         );
1136         uint256 currentRate = _getRate();
1137         return rAmount.div(currentRate);
1138     }
1139 
1140     function excludeFromReward(address account) public onlyOwner {
1141         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
1142         require(!_isExcluded[account], "Account is already excluded");
1143         if (_rOwned[account] > 0) {
1144             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1145         }
1146         _isExcluded[account] = true;
1147         _excluded.push(account);
1148     }
1149 
1150     function includeInReward(address account) external onlyOwner {
1151         require(_isExcluded[account], "Account is already excluded");
1152         for (uint256 i = 0; i < _excluded.length; i++) {
1153             if (_excluded[i] == account) {
1154                 _excluded[i] = _excluded[_excluded.length - 1];
1155                 _tOwned[account] = 0;
1156                 _isExcluded[account] = false;
1157                 _excluded.pop();
1158                 break;
1159             }
1160         }
1161     }
1162 
1163     function _transferBothExcluded(
1164         address sender,
1165         address recipient,
1166         uint256 tAmount
1167     ) private {
1168         (
1169             uint256 rAmount,
1170             uint256 rTransferAmount,
1171             uint256 rFee,
1172             uint256 tTransferAmount,
1173             uint256 tFee,
1174             uint256 tLiquidity
1175         ) = _getValues(tAmount);
1176         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1177         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1178         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1179         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1180         _takeLiquidity(tLiquidity);
1181         _reflectFee(rFee, tFee);
1182         emit Transfer(sender, recipient, tTransferAmount);
1183     }
1184 
1185     function includeInWhitelist(address account) external onlyOwner {
1186         whitelist[account] = true;
1187         _isExcludedFromFee[account] = true;
1188     }
1189 
1190     function excludeFromWhitelist(address account) external onlyOwner {
1191         whitelist[account] = false;
1192         _isExcludedFromFee[account] = false;
1193     }
1194 
1195     function excludeFromFee(address account) public onlyOwner {
1196         _isExcludedFromFee[account] = true;
1197     }
1198 
1199     function includeInFee(address account) public onlyOwner {
1200         _isExcludedFromFee[account] = false;
1201     }
1202 
1203     function setBurnFeePercent(uint256 fee) public onlyOwner {
1204         require(fee < 20, "Burn fee cannot be more than 20% of tx amount");
1205         _burnFee = fee;
1206     }
1207 
1208     function setTaxFeePercent(uint256 taxFee) external onlyOwner {
1209         require(taxFee < 20, "Tax fee cannot be more than 20%");
1210         _taxFee = taxFee;
1211     }
1212 
1213     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner {
1214         _liquidityFee = liquidityFee;
1215     }
1216 
1217     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner {
1218         _maxTxAmount = maxTxAmount * 10**8;
1219     }
1220 
1221     function setMarketingFeePercent(uint256 marketingFee) external onlyOwner {
1222         _marketingFee = marketingFee;
1223     }
1224 
1225     function setSwapThresholdAmount(uint256 SwapThresholdAmount)
1226         external
1227         onlyOwner
1228     {
1229         numTokensSellToAddToLiquidity = SwapThresholdAmount * 10**8;
1230     }
1231 
1232     function setMarketingWallet(address marketingAddress)
1233         external
1234         onlyOwner
1235     {
1236         require(marketingAddress != address(0), "Marketing Address cannot be zero address");
1237         marketingWallet = marketingAddress;
1238     }
1239 
1240     function claimOtherTokens(IERC20 tokenAddress, address walletaddress)
1241         external
1242         onlyOwner
1243     {
1244         tokenAddress.transfer(
1245             walletaddress,
1246             tokenAddress.balanceOf(address(this))
1247         );
1248     }
1249 
1250     function clearStuckBalance(address payable walletaddress)
1251         external
1252         onlyOwner
1253     {
1254         walletaddress.transfer(address(this).balance);
1255     }
1256 
1257     function allowtrading() external onlyOwner {
1258         canTrade = true;
1259     }
1260 
1261     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1262         swapAndLiquifyEnabled = _enabled;
1263         emit SwapAndLiquifyEnabledUpdated(_enabled);
1264     }
1265 
1266     //to recieve ETH from uniswapV2Router when swaping
1267     receive() external payable {}
1268 
1269     function _reflectFee(uint256 rFee, uint256 tFee) private {
1270         _rTotal = _rTotal.sub(rFee);
1271         _tFeeTotal = _tFeeTotal.add(tFee);
1272     }
1273 
1274     function _getValues(uint256 tAmount)
1275         private
1276         view
1277         returns (
1278             uint256,
1279             uint256,
1280             uint256,
1281             uint256,
1282             uint256,
1283             uint256
1284         )
1285     {
1286         (
1287             uint256 tTransferAmount,
1288             uint256 tFee,
1289             uint256 tLiquidity
1290         ) = _getTValues(tAmount);
1291         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1292             tAmount,
1293             tFee,
1294             tLiquidity,
1295             _getRate()
1296         );
1297         return (
1298             rAmount,
1299             rTransferAmount,
1300             rFee,
1301             tTransferAmount,
1302             tFee,
1303             tLiquidity
1304         );
1305     }
1306 
1307     function _getTValues(uint256 tAmount)
1308         private
1309         view
1310         returns (
1311             uint256,
1312             uint256,
1313             uint256
1314         )
1315     {
1316         uint256 tFee = calculateTaxFee(tAmount);
1317         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1318         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1319         return (tTransferAmount, tFee, tLiquidity);
1320     }
1321 
1322     function _getRValues(
1323         uint256 tAmount,
1324         uint256 tFee,
1325         uint256 tLiquidity,
1326         uint256 currentRate
1327     )
1328         private
1329         pure
1330         returns (
1331             uint256,
1332             uint256,
1333             uint256
1334         )
1335     {
1336         uint256 rAmount = tAmount.mul(currentRate);
1337         uint256 rFee = tFee.mul(currentRate);
1338         uint256 rLiquidity = tLiquidity.mul(currentRate);
1339         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1340         return (rAmount, rTransferAmount, rFee);
1341     }
1342 
1343     function _getRate() private view returns (uint256) {
1344         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1345         return rSupply.div(tSupply);
1346     }
1347 
1348     function _getCurrentSupply() private view returns (uint256, uint256) {
1349         uint256 rSupply = _rTotal;
1350         uint256 tSupply = _tTotal;
1351         for (uint256 i = 0; i < _excluded.length; i++) {
1352             if (
1353                 _rOwned[_excluded[i]] > rSupply ||
1354                 _tOwned[_excluded[i]] > tSupply
1355             ) return (_rTotal, _tTotal);
1356             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1357             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1358         }
1359         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1360         return (rSupply, tSupply);
1361     }
1362 
1363     function _takeLiquidity(uint256 tLiquidity) private {
1364         uint256 currentRate = _getRate();
1365         uint256 rLiquidity = tLiquidity.mul(currentRate);
1366         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1367         if (_isExcluded[address(this)])
1368             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1369     }
1370 
1371     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1372         return _amount.mul(_taxFee).div(10**2);
1373     }
1374 
1375     function calculateLiquidityFee(uint256 _amount)
1376         private
1377         view
1378         returns (uint256)
1379     {
1380         return _amount.mul(_liquidityFee + _burnFee + _marketingFee).div(10**2);
1381     }
1382 
1383     function removeAllFee() private {
1384         if (_taxFee == 0 && _liquidityFee == 0 && _burnFee == 0 && _marketingFee == 0) return;
1385 
1386         _previousTaxFee = _taxFee;
1387         _previousLiquidityFee = _liquidityFee;
1388         _previousBurnFee = _burnFee;
1389         _previousMarketingFee = _marketingFee;
1390 
1391         _taxFee = 0;
1392         _liquidityFee = 0;
1393         _burnFee = 0;
1394         _marketingFee = 0;
1395     }
1396 
1397     function restoreAllFee() private {
1398         _taxFee = _previousTaxFee;
1399         _liquidityFee = _previousLiquidityFee;
1400         _burnFee = _previousBurnFee;
1401         _marketingFee = _previousMarketingFee;
1402     }
1403 
1404     function isExcludedFromFee(address account) public view returns (bool) {
1405         return _isExcludedFromFee[account];
1406     }
1407 
1408     function _approve(
1409         address owner,
1410         address spender,
1411         uint256 amount
1412     ) private {
1413         require(owner != address(0), "ERC20: approve from the zero address");
1414         require(spender != address(0), "ERC20: approve to the zero address");
1415 
1416         _allowances[owner][spender] = amount;
1417         emit Approval(owner, spender, amount);
1418     }
1419 
1420     function _transfer(
1421         address from,
1422         address to,
1423         uint256 amount
1424     ) private transactionPossible(from, amount) {
1425         require(from != address(0), "ERC20: transfer from the zero address");
1426         require(to != address(0), "ERC20: transfer to the zero address");
1427         require(amount > 0, "Transfer amount must be greater than zero");
1428         if (from != owner() && to != owner() && from != uniswapV2Pair)
1429             require(
1430                 amount <= _maxTxAmount,
1431                 "Transfer amount exceeds the maxTxAmount."
1432             );
1433 
1434         // is the token balance of this contract address over the min number of
1435         // tokens that we need to initiate a swap + liquidity lock?
1436         // also, don't get caught in a circular liquidity event.
1437         // also, don't swap & liquify if sender is uniswap pair.
1438         uint256 contractTokenBalance = balanceOf(address(this));
1439 
1440         if (contractTokenBalance >= _maxTxAmount) {
1441             contractTokenBalance = _maxTxAmount;
1442         }
1443 
1444         bool overMinTokenBalance = contractTokenBalance >=
1445             numTokensSellToAddToLiquidity;
1446         if (
1447             overMinTokenBalance &&
1448             !inSwapAndLiquify &&
1449             from != uniswapV2Pair &&
1450             swapAndLiquifyEnabled
1451         ) {
1452             contractTokenBalance = numTokensSellToAddToLiquidity;
1453             //add liquidity
1454             swapAndLiquify(contractTokenBalance);
1455         }
1456 
1457         //indicates if fee should be deducted from transfer
1458         bool takeFee = true;
1459 
1460         //if any account belongs to _isExcludedFromFee account then remove the fee
1461         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1462             takeFee = false;
1463         }
1464 
1465         //transfer amount, it will take tax, burn, liquidity fee
1466         _tokenTransfer(from, to, amount, takeFee);
1467     }
1468 
1469     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1470         // split the contract balance to burnAmt and liquifyAmt
1471         uint256 totalFee = _liquidityFee + _burnFee + _marketingFee;
1472         uint256 burnAmt = contractTokenBalance.mul(_burnFee).div(totalFee);
1473         uint256 liquifyAmt = contractTokenBalance.mul(_liquidityFee).div(totalFee).div(2);
1474         uint256 swapForEthAmt = contractTokenBalance.sub(burnAmt).sub(liquifyAmt);
1475         // transfer burnAmt to burnAddress
1476         if (burnAmt > 0) {
1477             removeAllFee();
1478             _transferStandard(address(this), burnAddress, burnAmt);
1479             restoreAllFee();
1480         }
1481         // capture the contract's current ETH balance.
1482         // this is so that we can capture exactly the amount of ETH that the
1483         // swap creates, and not make the liquidity event include any ETH that
1484         // has been manually sent to the contract
1485         uint256 initialBalance = address(this).balance;
1486 
1487         // swap tokens for ETH
1488         swapTokensForEth(swapForEthAmt); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1489 
1490         // how much ETH did we just swap into?
1491         uint256 newBalance = address(this).balance.sub(initialBalance);
1492         uint256 marketingBalance = newBalance.mul(_marketingFee * 10).div(_marketingFee * 10 + _liquidityFee * 10 / 2);
1493         uint256 liquifyBalance = newBalance.sub(marketingBalance);
1494 
1495         // add liquidity to uniswap
1496         addLiquidity(liquifyAmt, liquifyBalance);
1497         
1498         // send to marketing wallet
1499         payable(marketingWallet).transfer(marketingBalance);
1500 
1501         emit SwapAndLiquify(liquifyAmt, liquifyBalance, swapForEthAmt);
1502     }
1503 
1504     function swapTokensForEth(uint256 tokenAmount) private {
1505         // generate the uniswap pair path of token -> weth
1506         address[] memory path = new address[](2);
1507         path[0] = address(this);
1508         path[1] = uniswapV2Router.WETH();
1509 
1510         _approve(address(this), address(uniswapV2Router), tokenAmount);
1511 
1512         // make the swap
1513         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1514             tokenAmount,
1515             0, // accept any amount of ETH
1516             path,
1517             address(this),
1518             block.timestamp
1519         );
1520     }
1521 
1522     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1523         // approve token transfer to cover all possible scenarios
1524         _approve(address(this), address(uniswapV2Router), tokenAmount);
1525 
1526         // add the liquidity
1527         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1528             address(this),
1529             tokenAmount,
1530             0, // slippage is unavoidable
1531             0, // slippage is unavoidable
1532             owner(),
1533             block.timestamp
1534         );
1535     }
1536 
1537     //this method is responsible for taking all fee, if takeFee is true
1538     function _tokenTransfer(
1539         address sender,
1540         address recipient,
1541         uint256 amount,
1542         bool takeFee
1543     ) private {
1544         if (!canTrade) {
1545             // only whitelisted accounts buy or sender can trade
1546             if (!(whitelist[sender] || whitelist[recipient])) {
1547                 require(sender == owner());
1548             }
1549         }
1550 
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
1588     function _transferToExcluded(
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
1601         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1602         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1603         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1604         _takeLiquidity(tLiquidity);
1605         _reflectFee(rFee, tFee);
1606         emit Transfer(sender, recipient, tTransferAmount);
1607     }
1608 
1609     function _transferFromExcluded(
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
1622         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1623         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1624         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1625         _takeLiquidity(tLiquidity);
1626         _reflectFee(rFee, tFee);
1627         emit Transfer(sender, recipient, tTransferAmount);
1628     }
1629 
1630     modifier lockPossible(address target, uint256 value) {
1631         require(balanceOf(target) >= value, 'Nil: the lock amount exceeds balance');
1632         _;
1633     }
1634 
1635     modifier transactionPossible(address sender, uint256 value) {
1636         uint256 locked;
1637         if(block.timestamp < lockedTime[sender]) {
1638             if(balanceOf(sender) > lockedAmount[sender])
1639                 locked = balanceOf(sender) - lockedAmount[sender];
1640             else
1641                 locked = 0;
1642         }
1643         else
1644             locked = balanceOf(sender);
1645         require(locked >= value, 'Nil: the transfer amount exceeds unlocked amount');
1646         _;
1647     }
1648 
1649     function timeLockAddress(address target, uint256 amount, string memory reason, uint256 duration) external onlyOwner lockPossible(target, amount) returns (bool) {
1650         lockedAmount[target] = amount;
1651         lockedReason[target] = reason;
1652         lockedTime[target] = block.timestamp + duration * 1 days;
1653         return true;
1654     }
1655 
1656     function timeUnlockAddress(address target) external onlyOwner returns (bool) {
1657         lockedAmount[target] = 0;
1658         lockedReason[target] = '';
1659         lockedTime[target] = block.timestamp;
1660         return true;
1661     }
1662 
1663     function updateLockedAmount(address target, uint256 amount) external onlyOwner lockPossible(target, amount) returns (bool) {
1664         lockedAmount[target] = amount;
1665         return true;
1666     }
1667 
1668     function updateLockedTime(address target, uint256 duration) external onlyOwner returns (bool) {
1669         lockedTime[target] = block.timestamp + duration * 1 days;
1670         return true;
1671     }
1672 
1673     function getLockedReason(address target) external view returns (string memory) {
1674         return lockedReason[target];
1675     }
1676 
1677     function getLockedAmount(address target) external view returns (uint256) {
1678         return lockedAmount[target];
1679     }
1680 
1681     function getLockedTime(address target) external view returns (uint256) {
1682         return lockedTime[target];
1683     }
1684 }