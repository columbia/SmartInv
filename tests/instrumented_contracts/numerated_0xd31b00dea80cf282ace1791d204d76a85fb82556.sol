1 /**
2  *Submitted for verification at Etherscan.io on 2021-11-24
3  */
4 
5 /**                                                                                
6 _________________________________
7 |   __  __    _____    ___      |
8 |   | \| |    |_ _|    | |      |
9 |   | .` |     | |     | |__    |
10 |   |_|\_|    |___|    |____|   |
11 |_||"""""""|_|"""""|_|"""""""||_|
12 |_______________________________|
13 
14  */
15 
16 /**
17  *Submitted for verification at Etherscan.io on 2021-11-24
18  */
19 
20 pragma solidity ^0.8.9;
21 
22 // SPDX-License-Identifier: Unlicensed
23 interface IERC20 {
24     function totalSupply() external view returns (uint256);
25 
26     /**
27      * @dev Returns the amount of tokens owned by `account`.
28      */
29     function balanceOf(address account) external view returns (uint256);
30 
31     /**
32      * @dev Moves `amount` tokens from the caller's account to `recipient`.
33      *
34      * Returns a boolean value indicating whether the operation succeeded.
35      *
36      * Emits a {Transfer} event.
37      */
38     function transfer(address recipient, uint256 amount)
39         external
40         returns (bool);
41 
42     /**
43      * @dev Returns the remaining number of tokens that `spender` will be
44      * allowed to spend on behalf of `owner` through {transferFrom}. This is
45      * zero by default.
46      *
47      * This value changes when {approve} or {transferFrom} are called.
48      */
49     function allowance(address owner, address spender)
50         external
51         view
52         returns (uint256);
53 
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `sender` to `recipient` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(
80         address sender,
81         address recipient,
82         uint256 amount
83     ) external returns (bool);
84 
85     /**
86      * @dev Emitted when `value` tokens are moved from one account (`from`) to
87      * another (`to`).
88      *
89      * Note that `value` may be zero.
90      */
91     event Transfer(address indexed from, address indexed to, uint256 value);
92 
93     /**
94      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
95      * a call to {approve}. `value` is the new allowance.
96      */
97     event Approval(
98         address indexed owner,
99         address indexed spender,
100         uint256 value
101     );
102 }
103 
104 /**
105  * @dev Wrappers over Solidity's arithmetic operations with added overflow
106  * checks.
107  *
108  * Arithmetic operations in Solidity wrap on overflow. This can easily result
109  * in bugs, because programmers usually assume that an overflow raises an
110  * error, which is the standard behavior in high level programming languages.
111  * `SafeMath` restores this intuition by reverting the transaction when an
112  * operation overflows.
113  *
114  * Using this library instead of the unchecked operations eliminates an entire
115  * class of bugs, so it's recommended to use it always.
116  */
117 
118 library SafeMath {
119     /**
120      * @dev Returns the addition of two unsigned integers, reverting on
121      * overflow.
122      *
123      * Counterpart to Solidity's `+` operator.
124      *
125      * Requirements:
126      *
127      * - Addition cannot overflow.
128      */
129     function add(uint256 a, uint256 b) internal pure returns (uint256) {
130         uint256 c = a + b;
131         require(c >= a, "SafeMath: addition overflow");
132 
133         return c;
134     }
135 
136     /**
137      * @dev Returns the subtraction of two unsigned integers, reverting on
138      * overflow (when the result is negative).
139      *
140      * Counterpart to Solidity's `-` operator.
141      *
142      * Requirements:
143      *
144      * - Subtraction cannot overflow.
145      */
146     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
147         return sub(a, b, "SafeMath: subtraction overflow");
148     }
149 
150     /**
151      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
152      * overflow (when the result is negative).
153      *
154      * Counterpart to Solidity's `-` operator.
155      *
156      * Requirements:
157      *
158      * - Subtraction cannot overflow.
159      */
160     function sub(
161         uint256 a,
162         uint256 b,
163         string memory errorMessage
164     ) internal pure returns (uint256) {
165         require(b <= a, errorMessage);
166         uint256 c = a - b;
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the multiplication of two unsigned integers, reverting on
173      * overflow.
174      *
175      * Counterpart to Solidity's `*` operator.
176      *
177      * Requirements:
178      *
179      * - Multiplication cannot overflow.
180      */
181     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
182         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
183         // benefit is lost if 'b' is also tested.
184         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
185         if (a == 0) {
186             return 0;
187         }
188 
189         uint256 c = a * b;
190         require(c / a == b, "SafeMath: multiplication overflow");
191 
192         return c;
193     }
194 
195     /**
196      * @dev Returns the integer division of two unsigned integers. Reverts on
197      * division by zero. The result is rounded towards zero.
198      *
199      * Counterpart to Solidity's `/` operator. Note: this function uses a
200      * `revert` opcode (which leaves remaining gas untouched) while Solidity
201      * uses an invalid opcode to revert (consuming all remaining gas).
202      *
203      * Requirements:
204      *
205      * - The divisor cannot be zero.
206      */
207     function div(uint256 a, uint256 b) internal pure returns (uint256) {
208         return div(a, b, "SafeMath: division by zero");
209     }
210 
211     /**
212      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
213      * division by zero. The result is rounded towards zero.
214      *
215      * Counterpart to Solidity's `/` operator. Note: this function uses a
216      * `revert` opcode (which leaves remaining gas untouched) while Solidity
217      * uses an invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      *
221      * - The divisor cannot be zero.
222      */
223     function div(
224         uint256 a,
225         uint256 b,
226         string memory errorMessage
227     ) internal pure returns (uint256) {
228         require(b > 0, errorMessage);
229         uint256 c = a / b;
230         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * Reverts when dividing by zero.
238      *
239      * Counterpart to Solidity's `%` operator. This function uses a `revert`
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      *
245      * - The divisor cannot be zero.
246      */
247     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
248         return mod(a, b, "SafeMath: modulo by zero");
249     }
250 
251     /**
252      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
253      * Reverts with custom message when dividing by zero.
254      *
255      * Counterpart to Solidity's `%` operator. This function uses a `revert`
256      * opcode (which leaves remaining gas untouched) while Solidity uses an
257      * invalid opcode to revert (consuming all remaining gas).
258      *
259      * Requirements:
260      *
261      * - The divisor cannot be zero.
262      */
263     function mod(
264         uint256 a,
265         uint256 b,
266         string memory errorMessage
267     ) internal pure returns (uint256) {
268         require(b != 0, errorMessage);
269         return a % b;
270     }
271 }
272 
273 abstract contract Context {
274     //function _msgSender() internal view virtual returns (address payable) {
275     function _msgSender() internal view virtual returns (address) {
276         return msg.sender;
277     }
278 
279     function _msgData() internal view virtual returns (bytes memory) {
280         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
281         return msg.data;
282     }
283 }
284 
285 /**
286  * @dev Collection of functions related to the address type
287  */
288 library Address {
289     /**
290      * @dev Returns true if `account` is a contract.
291      *
292      * [IMPORTANT]
293      * ====
294      * It is unsafe to assume that an address for which this function returns
295      * false is an externally-owned account (EOA) and not a contract.
296      *
297      * Among others, `isContract` will return false for the following
298      * types of addresses:
299      *
300      *  - an externally-owned account
301      *  - a contract in construction
302      *  - an address where a contract will be created
303      *  - an address where a contract lived, but was destroyed
304      * ====
305      */
306     function isContract(address account) internal view returns (bool) {
307         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
308         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
309         // for accounts without code, i.e. `keccak256('')`
310         bytes32 codehash;
311         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
312         // solhint-disable-next-line no-inline-assembly
313         assembly {
314             codehash := extcodehash(account)
315         }
316         return (codehash != accountHash && codehash != 0x0);
317     }
318 
319     /**
320      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
321      * `recipient`, forwarding all available gas and reverting on errors.
322      *
323      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
324      * of certain opcodes, possibly making contracts go over the 2300 gas limit
325      * imposed by `transfer`, making them unable to receive funds via
326      * `transfer`. {sendValue} removes this limitation.
327      *
328      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
329      *
330      * IMPORTANT: because control is transferred to `recipient`, care must be
331      * taken to not create reentrancy vulnerabilities. Consider using
332      * {ReentrancyGuard} or the
333      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
334      */
335     function sendValue(address payable recipient, uint256 amount) internal {
336         require(
337             address(this).balance >= amount,
338             "Address: insufficient balance"
339         );
340 
341         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
342         (bool success, ) = recipient.call{value: amount}("");
343         require(
344             success,
345             "Address: unable to send value, recipient may have reverted"
346         );
347     }
348 
349     /**
350      * @dev Performs a Solidity function call using a low level `call`. A
351      * plain`call` is an unsafe replacement for a function call: use this
352      * function instead.
353      *
354      * If `target` reverts with a revert reason, it is bubbled up by this
355      * function (like regular Solidity function calls).
356      *
357      * Returns the raw returned data. To convert to the expected return value,
358      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
359      *
360      * Requirements:
361      *
362      * - `target` must be a contract.
363      * - calling `target` with `data` must not revert.
364      *
365      * _Available since v3.1._
366      */
367     function functionCall(address target, bytes memory data)
368         internal
369         returns (bytes memory)
370     {
371         return functionCall(target, data, "Address: low-level call failed");
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
376      * `errorMessage` as a fallback revert reason when `target` reverts.
377      *
378      * _Available since v3.1._
379      */
380     function functionCall(
381         address target,
382         bytes memory data,
383         string memory errorMessage
384     ) internal returns (bytes memory) {
385         return _functionCallWithValue(target, data, 0, errorMessage);
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
390      * but also transferring `value` wei to `target`.
391      *
392      * Requirements:
393      *
394      * - the calling contract must have an ETH balance of at least `value`.
395      * - the called Solidity function must be `payable`.
396      *
397      * _Available since v3.1._
398      */
399     function functionCallWithValue(
400         address target,
401         bytes memory data,
402         uint256 value
403     ) internal returns (bytes memory) {
404         return
405             functionCallWithValue(
406                 target,
407                 data,
408                 value,
409                 "Address: low-level call with value failed"
410             );
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
415      * with `errorMessage` as a fallback revert reason when `target` reverts.
416      *
417      * _Available since v3.1._
418      */
419     function functionCallWithValue(
420         address target,
421         bytes memory data,
422         uint256 value,
423         string memory errorMessage
424     ) internal returns (bytes memory) {
425         require(
426             address(this).balance >= value,
427             "Address: insufficient balance for call"
428         );
429         return _functionCallWithValue(target, data, value, errorMessage);
430     }
431 
432     function _functionCallWithValue(
433         address target,
434         bytes memory data,
435         uint256 weiValue,
436         string memory errorMessage
437     ) private returns (bytes memory) {
438         require(isContract(target), "Address: call to non-contract");
439 
440         // solhint-disable-next-line avoid-low-level-calls
441         (bool success, bytes memory returndata) = target.call{value: weiValue}(
442             data
443         );
444         if (success) {
445             return returndata;
446         } else {
447             // Look for revert reason and bubble it up if present
448             if (returndata.length > 0) {
449                 // The easiest way to bubble the revert reason is using memory via assembly
450 
451                 // solhint-disable-next-line no-inline-assembly
452                 assembly {
453                     let returndata_size := mload(returndata)
454                     revert(add(32, returndata), returndata_size)
455                 }
456             } else {
457                 revert(errorMessage);
458             }
459         }
460     }
461 }
462 
463 /**
464  * @dev Contract module which provides a basic access control mechanism, where
465  * there is an account (an owner) that can be granted exclusive access to
466  * specific functions.
467  *
468  * By default, the owner account will be the one that deploys the contract. This
469  * can later be changed with {transferOwnership}.
470  *
471  * This module is used through inheritance. It will make available the modifier
472  * `onlyOwner`, which can be applied to your functions to restrict their use to
473  * the owner.
474  */
475 contract Ownable is Context {
476     address private _owner;
477     address private _previousOwner;
478     uint256 private _lockTime;
479 
480     event OwnershipTransferred(
481         address indexed previousOwner,
482         address indexed newOwner
483     );
484 
485     /**
486      * @dev Initializes the contract setting the deployer as the initial owner.
487      */
488     constructor() {
489         address msgSender = _msgSender();
490         _owner = msgSender;
491         emit OwnershipTransferred(address(0), msgSender);
492     }
493 
494     /**
495      * @dev Returns the address of the current owner.
496      */
497     function owner() public view returns (address) {
498         return _owner;
499     }
500 
501     /**
502      * @dev Throws if called by any account other than the owner.
503      */
504     modifier onlyOwner() {
505         require(_owner == _msgSender(), "Ownable: caller is not the owner");
506         _;
507     }
508 
509     /**
510      * @dev Leaves the contract without owner. It will not be possible to call
511      * `onlyOwner` functions anymore. Can only be called by the current owner.
512      *
513      * NOTE: Renouncing ownership will leave the contract without an owner,
514      * thereby removing any functionality that is only available to the owner.
515      */
516     function renounceOwnership() public virtual onlyOwner {
517         emit OwnershipTransferred(_owner, address(0));
518         _owner = address(0);
519     }
520 
521     /**
522      * @dev Transfers ownership of the contract to a new account (`newOwner`).
523      * Can only be called by the current owner.
524      */
525     function transferOwnership(address newOwner) public virtual onlyOwner {
526         require(
527             newOwner != address(0),
528             "Ownable: new owner is the zero address"
529         );
530         emit OwnershipTransferred(_owner, newOwner);
531         _owner = newOwner;
532     }
533 
534     function geUnlockTime() public view returns (uint256) {
535         return _lockTime;
536     }
537 
538     //Locks the contract for owner for the amount of time provided
539     function lock(uint256 time) public virtual onlyOwner {
540         _previousOwner = _owner;
541         _owner = address(0);
542         _lockTime = block.timestamp + time;
543         emit OwnershipTransferred(_owner, address(0));
544     }
545 
546     //Unlocks the contract for owner when _lockTime is exceeds
547     function unlock() public virtual {
548         require(
549             _previousOwner == msg.sender,
550             "You don't have permission to unlock"
551         );
552         require(block.timestamp > _lockTime, "Contract is locked until 7 days");
553         emit OwnershipTransferred(_owner, _previousOwner);
554         _owner = _previousOwner;
555     }
556 }
557 
558 interface IUniswapV2Factory {
559     event PairCreated(
560         address indexed token0,
561         address indexed token1,
562         address pair,
563         uint256
564     );
565 
566     function feeTo() external view returns (address);
567 
568     function feeToSetter() external view returns (address);
569 
570     function getPair(address tokenA, address tokenB)
571         external
572         view
573         returns (address pair);
574 
575     function allPairs(uint256) external view returns (address pair);
576 
577     function allPairsLength() external view returns (uint256);
578 
579     function createPair(address tokenA, address tokenB)
580         external
581         returns (address pair);
582 
583     function setFeeTo(address) external;
584 
585     function setFeeToSetter(address) external;
586 }
587 
588 interface IUniswapV2Pair {
589     event Approval(
590         address indexed owner,
591         address indexed spender,
592         uint256 value
593     );
594     event Transfer(address indexed from, address indexed to, uint256 value);
595 
596     function name() external pure returns (string memory);
597 
598     function symbol() external pure returns (string memory);
599 
600     function decimals() external pure returns (uint8);
601 
602     function totalSupply() external view returns (uint256);
603 
604     function balanceOf(address owner) external view returns (uint256);
605 
606     function allowance(address owner, address spender)
607         external
608         view
609         returns (uint256);
610 
611     function approve(address spender, uint256 value) external returns (bool);
612 
613     function transfer(address to, uint256 value) external returns (bool);
614 
615     function transferFrom(
616         address from,
617         address to,
618         uint256 value
619     ) external returns (bool);
620 
621     function DOMAIN_SEPARATOR() external view returns (bytes32);
622 
623     function PERMIT_TYPEHASH() external pure returns (bytes32);
624 
625     function nonces(address owner) external view returns (uint256);
626 
627     function permit(
628         address owner,
629         address spender,
630         uint256 value,
631         uint256 deadline,
632         uint8 v,
633         bytes32 r,
634         bytes32 s
635     ) external;
636 
637     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
638     event Burn(
639         address indexed sender,
640         uint256 amount0,
641         uint256 amount1,
642         address indexed to
643     );
644     event Swap(
645         address indexed sender,
646         uint256 amount0In,
647         uint256 amount1In,
648         uint256 amount0Out,
649         uint256 amount1Out,
650         address indexed to
651     );
652     event Sync(uint112 reserve0, uint112 reserve1);
653 
654     function MINIMUM_LIQUIDITY() external pure returns (uint256);
655 
656     function factory() external view returns (address);
657 
658     function token0() external view returns (address);
659 
660     function token1() external view returns (address);
661 
662     function getReserves()
663         external
664         view
665         returns (
666             uint112 reserve0,
667             uint112 reserve1,
668             uint32 blockTimestampLast
669         );
670 
671     function price0CumulativeLast() external view returns (uint256);
672 
673     function price1CumulativeLast() external view returns (uint256);
674 
675     function kLast() external view returns (uint256);
676 
677     function mint(address to) external returns (uint256 liquidity);
678 
679     function burn(address to)
680         external
681         returns (uint256 amount0, uint256 amount1);
682 
683     function swap(
684         uint256 amount0Out,
685         uint256 amount1Out,
686         address to,
687         bytes calldata data
688     ) external;
689 
690     function skim(address to) external;
691 
692     function sync() external;
693 
694     function initialize(address, address) external;
695 }
696 
697 interface IUniswapV2Router01 {
698     function factory() external pure returns (address);
699 
700     function WETH() external pure returns (address);
701 
702     function addLiquidity(
703         address tokenA,
704         address tokenB,
705         uint256 amountADesired,
706         uint256 amountBDesired,
707         uint256 amountAMin,
708         uint256 amountBMin,
709         address to,
710         uint256 deadline
711     )
712         external
713         returns (
714             uint256 amountA,
715             uint256 amountB,
716             uint256 liquidity
717         );
718 
719     function addLiquidityETH(
720         address token,
721         uint256 amountTokenDesired,
722         uint256 amountTokenMin,
723         uint256 amountETHMin,
724         address to,
725         uint256 deadline
726     )
727         external
728         payable
729         returns (
730             uint256 amountToken,
731             uint256 amountETH,
732             uint256 liquidity
733         );
734 
735     function removeLiquidity(
736         address tokenA,
737         address tokenB,
738         uint256 liquidity,
739         uint256 amountAMin,
740         uint256 amountBMin,
741         address to,
742         uint256 deadline
743     ) external returns (uint256 amountA, uint256 amountB);
744 
745     function removeLiquidityETH(
746         address token,
747         uint256 liquidity,
748         uint256 amountTokenMin,
749         uint256 amountETHMin,
750         address to,
751         uint256 deadline
752     ) external returns (uint256 amountToken, uint256 amountETH);
753 
754     function removeLiquidityWithPermit(
755         address tokenA,
756         address tokenB,
757         uint256 liquidity,
758         uint256 amountAMin,
759         uint256 amountBMin,
760         address to,
761         uint256 deadline,
762         bool approveMax,
763         uint8 v,
764         bytes32 r,
765         bytes32 s
766     ) external returns (uint256 amountA, uint256 amountB);
767 
768     function removeLiquidityETHWithPermit(
769         address token,
770         uint256 liquidity,
771         uint256 amountTokenMin,
772         uint256 amountETHMin,
773         address to,
774         uint256 deadline,
775         bool approveMax,
776         uint8 v,
777         bytes32 r,
778         bytes32 s
779     ) external returns (uint256 amountToken, uint256 amountETH);
780 
781     function swapExactTokensForTokens(
782         uint256 amountIn,
783         uint256 amountOutMin,
784         address[] calldata path,
785         address to,
786         uint256 deadline
787     ) external returns (uint256[] memory amounts);
788 
789     function swapTokensForExactTokens(
790         uint256 amountOut,
791         uint256 amountInMax,
792         address[] calldata path,
793         address to,
794         uint256 deadline
795     ) external returns (uint256[] memory amounts);
796 
797     function swapExactETHForTokens(
798         uint256 amountOutMin,
799         address[] calldata path,
800         address to,
801         uint256 deadline
802     ) external payable returns (uint256[] memory amounts);
803 
804     function swapTokensForExactETH(
805         uint256 amountOut,
806         uint256 amountInMax,
807         address[] calldata path,
808         address to,
809         uint256 deadline
810     ) external returns (uint256[] memory amounts);
811 
812     function swapExactTokensForETH(
813         uint256 amountIn,
814         uint256 amountOutMin,
815         address[] calldata path,
816         address to,
817         uint256 deadline
818     ) external returns (uint256[] memory amounts);
819 
820     function swapETHForExactTokens(
821         uint256 amountOut,
822         address[] calldata path,
823         address to,
824         uint256 deadline
825     ) external payable returns (uint256[] memory amounts);
826 
827     function quote(
828         uint256 amountA,
829         uint256 reserveA,
830         uint256 reserveB
831     ) external pure returns (uint256 amountB);
832 
833     function getAmountOut(
834         uint256 amountIn,
835         uint256 reserveIn,
836         uint256 reserveOut
837     ) external pure returns (uint256 amountOut);
838 
839     function getAmountIn(
840         uint256 amountOut,
841         uint256 reserveIn,
842         uint256 reserveOut
843     ) external pure returns (uint256 amountIn);
844 
845     function getAmountsOut(uint256 amountIn, address[] calldata path)
846         external
847         view
848         returns (uint256[] memory amounts);
849 
850     function getAmountsIn(uint256 amountOut, address[] calldata path)
851         external
852         view
853         returns (uint256[] memory amounts);
854 }
855 
856 interface IUniswapV2Router02 is IUniswapV2Router01 {
857     function removeLiquidityETHSupportingFeeOnTransferTokens(
858         address token,
859         uint256 liquidity,
860         uint256 amountTokenMin,
861         uint256 amountETHMin,
862         address to,
863         uint256 deadline
864     ) external returns (uint256 amountETH);
865 
866     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
867         address token,
868         uint256 liquidity,
869         uint256 amountTokenMin,
870         uint256 amountETHMin,
871         address to,
872         uint256 deadline,
873         bool approveMax,
874         uint8 v,
875         bytes32 r,
876         bytes32 s
877     ) external returns (uint256 amountETH);
878 
879     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
880         uint256 amountIn,
881         uint256 amountOutMin,
882         address[] calldata path,
883         address to,
884         uint256 deadline
885     ) external;
886 
887     function swapExactETHForTokensSupportingFeeOnTransferTokens(
888         uint256 amountOutMin,
889         address[] calldata path,
890         address to,
891         uint256 deadline
892     ) external payable;
893 
894     function swapExactTokensForETHSupportingFeeOnTransferTokens(
895         uint256 amountIn,
896         uint256 amountOutMin,
897         address[] calldata path,
898         address to,
899         uint256 deadline
900     ) external;
901 }
902 
903 interface IAirdrop {
904     function airdrop(address recipient, uint256 amount) external;
905 }
906 
907 contract NIL is Context, IERC20, Ownable {
908     using SafeMath for uint256;
909     using Address for address;
910 
911     mapping(address => uint256) private _rOwned;
912     mapping(address => uint256) private _tOwned;
913     mapping(address => mapping(address => uint256)) private _allowances;
914 
915     mapping(address => bool) private _isExcludedFromFee;
916 
917     mapping(address => bool) private _isExcluded;
918     address[] private _excluded;
919 
920     mapping(address => bool) public whitelist;
921 
922     bool public canTrade = false;
923 
924     uint256 private constant MAX = ~uint256(0);
925     uint256 private _tTotal = 1000000000 * 10**3 * 10**8;
926     uint256 private _rTotal = (MAX - (MAX % _tTotal));
927     uint256 private _tFeeTotal;
928 
929     address public burnAddress = 0x000000000000000000000000000000000000dEaD;
930 
931     string private _name = "NIL Coin";
932     string private _symbol = "NIL";
933     uint8 private _decimals = 8;
934 
935     uint256 public _taxFee = 5;
936     uint256 private _previousTaxFee = _taxFee;
937 
938     uint256 public _burnFee = 5;
939     uint256 private _previousBurnFee = _burnFee;
940 
941     uint256 public _liquidityFee = 5;
942     uint256 private _previousLiquidityFee = _liquidityFee;
943 
944     IUniswapV2Router02 public immutable uniswapV2Router;
945     address public immutable uniswapV2Pair;
946 
947     bool internal inSwapAndLiquify;
948     bool public swapAndLiquifyEnabled = true;
949 
950     uint256 public _maxTxAmount = 2000000 * 10**3 * 10**8;
951     uint256 public numTokensSellToAddToLiquidity = 1000000 * 10**3 * 10**8;
952 
953     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
954     event SwapAndLiquifyEnabledUpdated(bool enabled);
955     event SwapAndLiquify(
956         uint256 tokensSwapped,
957         uint256 ethReceived,
958         uint256 tokensIntoLiqudity
959     );
960 
961     modifier lockTheSwap() {
962         inSwapAndLiquify = true;
963         _;
964         inSwapAndLiquify = false;
965     }
966 
967     constructor() {
968         _rOwned[_msgSender()] = _rTotal;
969 
970         //IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E); //Mainnet BSC
971         //IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3); //Testnet BSC
972         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
973             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
974         ); //Mainnet & Testnet ETH
975         // Create a uniswap pair for this new token
976         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
977             .createPair(address(this), _uniswapV2Router.WETH());
978 
979         // set the rest of the contract variables
980         uniswapV2Router = _uniswapV2Router;
981 
982         //exclude owner and this contract from fee
983         _isExcludedFromFee[owner()] = true;
984         _isExcludedFromFee[address(this)] = true;
985 
986         emit Transfer(address(0), _msgSender(), _tTotal);
987     }
988 
989     function name() public view returns (string memory) {
990         return _name;
991     }
992 
993     function symbol() public view returns (string memory) {
994         return _symbol;
995     }
996 
997     function decimals() public view returns (uint8) {
998         return _decimals;
999     }
1000 
1001     function totalSupply() public view override returns (uint256) {
1002         return _tTotal;
1003     }
1004 
1005     function balanceOf(address account) public view override returns (uint256) {
1006         if (_isExcluded[account]) return _tOwned[account];
1007         return tokenFromReflection(_rOwned[account]);
1008     }
1009 
1010     function transfer(address recipient, uint256 amount)
1011         public
1012         override
1013         returns (bool)
1014     {
1015         _transfer(_msgSender(), recipient, amount);
1016         return true;
1017     }
1018 
1019     function allowance(address owner, address spender)
1020         public
1021         view
1022         override
1023         returns (uint256)
1024     {
1025         return _allowances[owner][spender];
1026     }
1027 
1028     function approve(address spender, uint256 amount)
1029         public
1030         override
1031         returns (bool)
1032     {
1033         _approve(_msgSender(), spender, amount);
1034         return true;
1035     }
1036 
1037     function transferFrom(
1038         address sender,
1039         address recipient,
1040         uint256 amount
1041     ) public override returns (bool) {
1042         _transfer(sender, recipient, amount);
1043         _approve(
1044             sender,
1045             _msgSender(),
1046             _allowances[sender][_msgSender()].sub(
1047                 amount,
1048                 "ERC20: transfer amount exceeds allowance"
1049             )
1050         );
1051         return true;
1052     }
1053 
1054     function increaseAllowance(address spender, uint256 addedValue)
1055         public
1056         virtual
1057         returns (bool)
1058     {
1059         _approve(
1060             _msgSender(),
1061             spender,
1062             _allowances[_msgSender()][spender].add(addedValue)
1063         );
1064         return true;
1065     }
1066 
1067     function decreaseAllowance(address spender, uint256 subtractedValue)
1068         public
1069         virtual
1070         returns (bool)
1071     {
1072         _approve(
1073             _msgSender(),
1074             spender,
1075             _allowances[_msgSender()][spender].sub(
1076                 subtractedValue,
1077                 "ERC20: decreased allowance below zero"
1078             )
1079         );
1080         return true;
1081     }
1082 
1083     function isExcludedFromReward(address account) public view returns (bool) {
1084         return _isExcluded[account];
1085     }
1086 
1087     function totalFees() public view returns (uint256) {
1088         return _tFeeTotal;
1089     }
1090 
1091     function airdrop(address recipient, uint256 amount) external onlyOwner {
1092         removeAllFee();
1093         _transfer(_msgSender(), recipient, amount * 10**8);
1094         restoreAllFee();
1095     }
1096 
1097     function airdropInternal(address recipient, uint256 amount) internal {
1098         removeAllFee();
1099         _transfer(_msgSender(), recipient, amount);
1100         restoreAllFee();
1101     }
1102 
1103     function airdropArray(
1104         address[] calldata newholders,
1105         uint256[] calldata amounts
1106     ) external onlyOwner {
1107         uint256 iterator = 0;
1108         require(newholders.length == amounts.length, "must be the same length");
1109         while (iterator < newholders.length) {
1110             airdropInternal(newholders[iterator], amounts[iterator] * 10**8);
1111             iterator += 1;
1112         }
1113     }
1114 
1115     function deliver(uint256 tAmount) public {
1116         address sender = _msgSender();
1117         require(
1118             !_isExcluded[sender],
1119             "Excluded addresses cannot call this function"
1120         );
1121         (uint256 rAmount, , , , , ) = _getValues(tAmount);
1122         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1123         _rTotal = _rTotal.sub(rAmount);
1124         _tFeeTotal = _tFeeTotal.add(tAmount);
1125     }
1126 
1127     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
1128         public
1129         view
1130         returns (uint256)
1131     {
1132         require(tAmount <= _tTotal, "Amount must be less than supply");
1133         if (!deductTransferFee) {
1134             (uint256 rAmount, , , , , ) = _getValues(tAmount);
1135             return rAmount;
1136         } else {
1137             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
1138             return rTransferAmount;
1139         }
1140     }
1141 
1142     function tokenFromReflection(uint256 rAmount)
1143         public
1144         view
1145         returns (uint256)
1146     {
1147         require(
1148             rAmount <= _rTotal,
1149             "Amount must be less than total reflections"
1150         );
1151         uint256 currentRate = _getRate();
1152         return rAmount.div(currentRate);
1153     }
1154 
1155     function excludeFromReward(address account) public onlyOwner {
1156         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
1157         require(!_isExcluded[account], "Account is already excluded");
1158         if (_rOwned[account] > 0) {
1159             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1160         }
1161         _isExcluded[account] = true;
1162         _excluded.push(account);
1163     }
1164 
1165     function includeInReward(address account) external onlyOwner {
1166         require(_isExcluded[account], "Account is already excluded");
1167         for (uint256 i = 0; i < _excluded.length; i++) {
1168             if (_excluded[i] == account) {
1169                 _excluded[i] = _excluded[_excluded.length - 1];
1170                 _tOwned[account] = 0;
1171                 _isExcluded[account] = false;
1172                 _excluded.pop();
1173                 break;
1174             }
1175         }
1176     }
1177 
1178     function _transferBothExcluded(
1179         address sender,
1180         address recipient,
1181         uint256 tAmount
1182     ) private {
1183         (
1184             uint256 rAmount,
1185             uint256 rTransferAmount,
1186             uint256 rFee,
1187             uint256 tTransferAmount,
1188             uint256 tFee,
1189             uint256 tLiquidity
1190         ) = _getValues(tAmount);
1191         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1192         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1193         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1194         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1195         _takeLiquidity(tLiquidity);
1196         _reflectFee(rFee, tFee);
1197         emit Transfer(sender, recipient, tTransferAmount);
1198     }
1199 
1200     function includeInWhitelist(address account) external onlyOwner {
1201         whitelist[account] = true;
1202         _isExcludedFromFee[account] = true;
1203     }
1204 
1205     function excludeFromWhitelist(address account) external onlyOwner {
1206         whitelist[account] = false;
1207         _isExcludedFromFee[account] = false;
1208     }
1209 
1210     function excludeFromFee(address account) public onlyOwner {
1211         _isExcludedFromFee[account] = true;
1212     }
1213 
1214     function includeInFee(address account) public onlyOwner {
1215         _isExcludedFromFee[account] = false;
1216     }
1217 
1218     function setBurnFeePercent(uint256 fee) public onlyOwner {
1219         require(fee < 20, "Burn fee cannot be more than 20% of tx amount");
1220         _burnFee = fee;
1221     }
1222 
1223     function setTaxFeePercent(uint256 taxFee) external onlyOwner {
1224         require(taxFee < 20, "Tax fee cannot be more than 20%");
1225         _taxFee = taxFee;
1226     }
1227 
1228     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner {
1229         _liquidityFee = liquidityFee;
1230     }
1231 
1232     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner {
1233         require(
1234             maxTxAmount > 10000000,
1235             "Max Tx Amount cannot be less than 10,000,000"
1236         );
1237         _maxTxAmount = maxTxAmount * 10**8;
1238     }
1239 
1240     function setSwapThresholdAmount(uint256 SwapThresholdAmount)
1241         external
1242         onlyOwner
1243     {
1244         require(
1245             SwapThresholdAmount > 100000000,
1246             "Swap Threshold Amount cannot be less than 100,000,000"
1247         );
1248         numTokensSellToAddToLiquidity = SwapThresholdAmount * 10**8;
1249     }
1250 
1251     function claimTokens(address walletAddress) public onlyOwner {
1252         // make sure we capture all ETH that may or may not be sent to this contract
1253         payable(walletAddress).transfer(address(this).balance);
1254     }
1255 
1256     function claimOtherTokens(IERC20 tokenAddress, address walletaddress)
1257         external
1258         onlyOwner
1259     {
1260         tokenAddress.transfer(
1261             walletaddress,
1262             tokenAddress.balanceOf(address(this))
1263         );
1264     }
1265 
1266     function clearStuckBalance(address payable walletaddress)
1267         external
1268         onlyOwner
1269     {
1270         walletaddress.transfer(address(this).balance);
1271     }
1272 
1273     function allowtrading() external onlyOwner {
1274         canTrade = true;
1275     }
1276 
1277     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1278         swapAndLiquifyEnabled = _enabled;
1279         emit SwapAndLiquifyEnabledUpdated(_enabled);
1280     }
1281 
1282     //to recieve ETH from uniswapV2Router when swaping
1283     receive() external payable {}
1284 
1285     function _reflectFee(uint256 rFee, uint256 tFee) private {
1286         _rTotal = _rTotal.sub(rFee);
1287         _tFeeTotal = _tFeeTotal.add(tFee);
1288     }
1289 
1290     function _getValues(uint256 tAmount)
1291         private
1292         view
1293         returns (
1294             uint256,
1295             uint256,
1296             uint256,
1297             uint256,
1298             uint256,
1299             uint256
1300         )
1301     {
1302         (
1303             uint256 tTransferAmount,
1304             uint256 tFee,
1305             uint256 tLiquidity
1306         ) = _getTValues(tAmount);
1307         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1308             tAmount,
1309             tFee,
1310             tLiquidity,
1311             _getRate()
1312         );
1313         return (
1314             rAmount,
1315             rTransferAmount,
1316             rFee,
1317             tTransferAmount,
1318             tFee,
1319             tLiquidity
1320         );
1321     }
1322 
1323     function _getTValues(uint256 tAmount)
1324         private
1325         view
1326         returns (
1327             uint256,
1328             uint256,
1329             uint256
1330         )
1331     {
1332         uint256 tFee = calculateTaxFee(tAmount);
1333         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1334         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1335         return (tTransferAmount, tFee, tLiquidity);
1336     }
1337 
1338     function _getRValues(
1339         uint256 tAmount,
1340         uint256 tFee,
1341         uint256 tLiquidity,
1342         uint256 currentRate
1343     )
1344         private
1345         pure
1346         returns (
1347             uint256,
1348             uint256,
1349             uint256
1350         )
1351     {
1352         uint256 rAmount = tAmount.mul(currentRate);
1353         uint256 rFee = tFee.mul(currentRate);
1354         uint256 rLiquidity = tLiquidity.mul(currentRate);
1355         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1356         return (rAmount, rTransferAmount, rFee);
1357     }
1358 
1359     function _getRate() private view returns (uint256) {
1360         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1361         return rSupply.div(tSupply);
1362     }
1363 
1364     function _getCurrentSupply() private view returns (uint256, uint256) {
1365         uint256 rSupply = _rTotal;
1366         uint256 tSupply = _tTotal;
1367         for (uint256 i = 0; i < _excluded.length; i++) {
1368             if (
1369                 _rOwned[_excluded[i]] > rSupply ||
1370                 _tOwned[_excluded[i]] > tSupply
1371             ) return (_rTotal, _tTotal);
1372             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1373             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1374         }
1375         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1376         return (rSupply, tSupply);
1377     }
1378 
1379     function _takeLiquidity(uint256 tLiquidity) private {
1380         uint256 currentRate = _getRate();
1381         uint256 rLiquidity = tLiquidity.mul(currentRate);
1382         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1383         if (_isExcluded[address(this)])
1384             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1385     }
1386 
1387     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1388         return _amount.mul(_taxFee).div(10**2);
1389     }
1390 
1391     function calculateLiquidityFee(uint256 _amount)
1392         private
1393         view
1394         returns (uint256)
1395     {
1396         return _amount.mul(_liquidityFee + _burnFee).div(10**2);
1397     }
1398 
1399     function removeAllFee() private {
1400         if (_taxFee == 0 && _liquidityFee == 0 && _burnFee == 0) return;
1401 
1402         _previousTaxFee = _taxFee;
1403         _previousLiquidityFee = _liquidityFee;
1404         _previousBurnFee = _burnFee;
1405 
1406         _taxFee = 0;
1407         _liquidityFee = 0;
1408         _burnFee = 0;
1409     }
1410 
1411     function restoreAllFee() private {
1412         _taxFee = _previousTaxFee;
1413         _liquidityFee = _previousLiquidityFee;
1414         _burnFee = _previousBurnFee;
1415     }
1416 
1417     function isExcludedFromFee(address account) public view returns (bool) {
1418         return _isExcludedFromFee[account];
1419     }
1420 
1421     function _approve(
1422         address owner,
1423         address spender,
1424         uint256 amount
1425     ) private {
1426         require(owner != address(0), "ERC20: approve from the zero address");
1427         require(spender != address(0), "ERC20: approve to the zero address");
1428 
1429         _allowances[owner][spender] = amount;
1430         emit Approval(owner, spender, amount);
1431     }
1432 
1433     function _transfer(
1434         address from,
1435         address to,
1436         uint256 amount
1437     ) private {
1438         require(from != address(0), "ERC20: transfer from the zero address");
1439         require(to != address(0), "ERC20: transfer to the zero address");
1440         require(amount > 0, "Transfer amount must be greater than zero");
1441         if (from != owner() && to != owner())
1442             require(
1443                 amount <= _maxTxAmount,
1444                 "Transfer amount exceeds the maxTxAmount."
1445             );
1446 
1447         // is the token balance of this contract address over the min number of
1448         // tokens that we need to initiate a swap + liquidity lock?
1449         // also, don't get caught in a circular liquidity event.
1450         // also, don't swap & liquify if sender is uniswap pair.
1451         uint256 contractTokenBalance = balanceOf(address(this));
1452 
1453         if (contractTokenBalance >= _maxTxAmount) {
1454             contractTokenBalance = _maxTxAmount;
1455         }
1456 
1457         bool overMinTokenBalance = contractTokenBalance >=
1458             numTokensSellToAddToLiquidity;
1459         if (
1460             overMinTokenBalance &&
1461             !inSwapAndLiquify &&
1462             from != uniswapV2Pair &&
1463             swapAndLiquifyEnabled
1464         ) {
1465             contractTokenBalance = numTokensSellToAddToLiquidity;
1466             //add liquidity
1467             swapAndLiquify(contractTokenBalance);
1468         }
1469 
1470         //indicates if fee should be deducted from transfer
1471         bool takeFee = true;
1472 
1473         //if any account belongs to _isExcludedFromFee account then remove the fee
1474         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1475             takeFee = false;
1476         }
1477 
1478         //transfer amount, it will take tax, burn, liquidity fee
1479         _tokenTransfer(from, to, amount, takeFee);
1480     }
1481 
1482     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1483         // split the contract balance to burnAmt and liquifyAmt
1484         uint256 totalFee = _liquidityFee + _burnFee;
1485         uint256 burnAmt = contractTokenBalance.mul(_burnFee).div(totalFee);
1486         uint256 liquifyAmt = contractTokenBalance.sub(burnAmt);
1487 
1488         // transfer burnAmt to burnAddress
1489         if (burnAmt > 0) {
1490             removeAllFee();
1491             _transferStandard(address(this), burnAddress, burnAmt);
1492             restoreAllFee();
1493         }
1494 
1495         // split the liquify balance into halves
1496         uint256 half = liquifyAmt.div(2);
1497         uint256 otherHalf = liquifyAmt.sub(half);
1498 
1499         // capture the contract's current ETH balance.
1500         // this is so that we can capture exactly the amount of ETH that the
1501         // swap creates, and not make the liquidity event include any ETH that
1502         // has been manually sent to the contract
1503         uint256 initialBalance = address(this).balance;
1504 
1505         // swap tokens for ETH
1506         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1507 
1508         // how much ETH did we just swap into?
1509         uint256 newBalance = address(this).balance.sub(initialBalance);
1510 
1511         // add liquidity to uniswap
1512         addLiquidity(otherHalf, newBalance);
1513 
1514         emit SwapAndLiquify(half, newBalance, otherHalf);
1515     }
1516 
1517     function swapTokensForEth(uint256 tokenAmount) private {
1518         // generate the uniswap pair path of token -> weth
1519         address[] memory path = new address[](2);
1520         path[0] = address(this);
1521         path[1] = uniswapV2Router.WETH();
1522 
1523         _approve(address(this), address(uniswapV2Router), tokenAmount);
1524 
1525         // make the swap
1526         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1527             tokenAmount,
1528             0, // accept any amount of ETH
1529             path,
1530             address(this),
1531             block.timestamp
1532         );
1533     }
1534 
1535     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1536         // approve token transfer to cover all possible scenarios
1537         _approve(address(this), address(uniswapV2Router), tokenAmount);
1538 
1539         // add the liquidity
1540         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1541             address(this),
1542             tokenAmount,
1543             0, // slippage is unavoidable
1544             0, // slippage is unavoidable
1545             owner(),
1546             block.timestamp
1547         );
1548     }
1549 
1550     //this method is responsible for taking all fee, if takeFee is true
1551     function _tokenTransfer(
1552         address sender,
1553         address recipient,
1554         uint256 amount,
1555         bool takeFee
1556     ) private {
1557         if (!canTrade) {
1558             // only whitelisted accounts buy or sender can trade
1559             if (!(whitelist[sender] || whitelist[recipient])) {
1560                 require(sender == owner());
1561             }
1562         }
1563 
1564         if (!takeFee) removeAllFee();
1565 
1566         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1567             _transferFromExcluded(sender, recipient, amount);
1568         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1569             _transferToExcluded(sender, recipient, amount);
1570         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1571             _transferStandard(sender, recipient, amount);
1572         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1573             _transferBothExcluded(sender, recipient, amount);
1574         } else {
1575             _transferStandard(sender, recipient, amount);
1576         }
1577 
1578         if (!takeFee) restoreAllFee();
1579     }
1580 
1581     function _transferStandard(
1582         address sender,
1583         address recipient,
1584         uint256 tAmount
1585     ) private {
1586         (
1587             uint256 rAmount,
1588             uint256 rTransferAmount,
1589             uint256 rFee,
1590             uint256 tTransferAmount,
1591             uint256 tFee,
1592             uint256 tLiquidity
1593         ) = _getValues(tAmount);
1594         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1595         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1596         _takeLiquidity(tLiquidity);
1597         _reflectFee(rFee, tFee);
1598         emit Transfer(sender, recipient, tTransferAmount);
1599     }
1600 
1601     function _transferToExcluded(
1602         address sender,
1603         address recipient,
1604         uint256 tAmount
1605     ) private {
1606         (
1607             uint256 rAmount,
1608             uint256 rTransferAmount,
1609             uint256 rFee,
1610             uint256 tTransferAmount,
1611             uint256 tFee,
1612             uint256 tLiquidity
1613         ) = _getValues(tAmount);
1614         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1615         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1616         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1617         _takeLiquidity(tLiquidity);
1618         _reflectFee(rFee, tFee);
1619         emit Transfer(sender, recipient, tTransferAmount);
1620     }
1621 
1622     function _transferFromExcluded(
1623         address sender,
1624         address recipient,
1625         uint256 tAmount
1626     ) private {
1627         (
1628             uint256 rAmount,
1629             uint256 rTransferAmount,
1630             uint256 rFee,
1631             uint256 tTransferAmount,
1632             uint256 tFee,
1633             uint256 tLiquidity
1634         ) = _getValues(tAmount);
1635         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1636         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1637         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1638         _takeLiquidity(tLiquidity);
1639         _reflectFee(rFee, tFee);
1640         emit Transfer(sender, recipient, tTransferAmount);
1641     }
1642 }