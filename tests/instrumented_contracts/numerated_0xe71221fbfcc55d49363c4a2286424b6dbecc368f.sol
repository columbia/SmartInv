1 /**
2  *Submitted for verification at BscScan.com on 2021-04-29
3  */
4 // SPDX-License-Identifier: Unlicensed
5 pragma solidity ^0.8.0;
6 
7 interface IERC20 {
8     function totalSupply() external view returns (uint256);
9 
10     /**
11      * @dev Returns the amount of tokens owned by `account`.
12      */
13     function balanceOf(address account) external view returns (uint256);
14 
15     /**
16      * @dev Moves `amount` tokens from the caller's account to `recipient`.
17      *
18      * Returns a boolean value indicating whether the operation succeeded.
19      *
20      * Emits a {Transfer} event.
21      */
22     function transfer(address recipient, uint256 amount)
23         external
24         returns (bool);
25 
26     /**
27      * @dev Returns the remaining number of tokens that `spender` will be
28      * allowed to spend on behalf of `owner` through {transferFrom}. This is
29      * zero by default.
30      *
31      * This value changes when {approve} or {transferFrom} are called.
32      */
33     function allowance(address owner, address spender)
34         external
35         view
36         returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(
64         address sender,
65         address recipient,
66         uint256 amount
67     ) external returns (bool);
68 
69     /**
70      * @dev Emitted when `value` tokens are moved from one account (`from`) to
71      * another (`to`).
72      *
73      * Note that `value` may be zero.
74      */
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 
77     /**
78      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
79      * a call to {approve}. `value` is the new allowance.
80      */
81     event Approval(
82         address indexed owner,
83         address indexed spender,
84         uint256 value
85     );
86 }
87 
88 /**
89  * @dev Wrappers over Solidity's arithmetic operations with added overflow
90  * checks.
91  *
92  * Arithmetic operations in Solidity wrap on overflow. This can easily result
93  * in bugs, because programmers usually assume that an overflow raises an
94  * error, which is the standard behavior in high level programming languages.
95  * `SafeMath` restores this intuition by reverting the transaction when an
96  * operation overflows.
97  *
98  * Using this library instead of the unchecked operations eliminates an entire
99  * class of bugs, so it's recommended to use it always.
100  */
101 
102 library SafeMath {
103     /**
104      * @dev Returns the addition of two unsigned integers, reverting on
105      * overflow.
106      *
107      * Counterpart to Solidity's `+` operator.
108      *
109      * Requirements:
110      *
111      * - Addition cannot overflow.
112      */
113     function add(uint256 a, uint256 b) internal pure returns (uint256) {
114         uint256 c = a + b;
115         require(c >= a, "SafeMath: addition overflow");
116 
117         return c;
118     }
119 
120     /**
121      * @dev Returns the subtraction of two unsigned integers, reverting on
122      * overflow (when the result is negative).
123      *
124      * Counterpart to Solidity's `-` operator.
125      *
126      * Requirements:
127      *
128      * - Subtraction cannot overflow.
129      */
130     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
131         return sub(a, b, "SafeMath: subtraction overflow");
132     }
133 
134     /**
135      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
136      * overflow (when the result is negative).
137      *
138      * Counterpart to Solidity's `-` operator.
139      *
140      * Requirements:
141      *
142      * - Subtraction cannot overflow.
143      */
144     function sub(
145         uint256 a,
146         uint256 b,
147         string memory errorMessage
148     ) internal pure returns (uint256) {
149         require(b <= a, errorMessage);
150         uint256 c = a - b;
151 
152         return c;
153     }
154 
155     /**
156      * @dev Returns the multiplication of two unsigned integers, reverting on
157      * overflow.
158      *
159      * Counterpart to Solidity's `*` operator.
160      *
161      * Requirements:
162      *
163      * - Multiplication cannot overflow.
164      */
165     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
166         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
167         // benefit is lost if 'b' is also tested.
168         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
169         if (a == 0) {
170             return 0;
171         }
172 
173         uint256 c = a * b;
174         require(c / a == b, "SafeMath: multiplication overflow");
175 
176         return c;
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers. Reverts on
181      * division by zero. The result is rounded towards zero.
182      *
183      * Counterpart to Solidity's `/` operator. Note: this function uses a
184      * `revert` opcode (which leaves remaining gas untouched) while Solidity
185      * uses an invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      *
189      * - The divisor cannot be zero.
190      */
191     function div(uint256 a, uint256 b) internal pure returns (uint256) {
192         return div(a, b, "SafeMath: division by zero");
193     }
194 
195     /**
196      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
207     function div(
208         uint256 a,
209         uint256 b,
210         string memory errorMessage
211     ) internal pure returns (uint256) {
212         require(b > 0, errorMessage);
213         uint256 c = a / b;
214         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
215 
216         return c;
217     }
218 
219     /**
220      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
221      * Reverts when dividing by zero.
222      *
223      * Counterpart to Solidity's `%` operator. This function uses a `revert`
224      * opcode (which leaves remaining gas untouched) while Solidity uses an
225      * invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
232         return mod(a, b, "SafeMath: modulo by zero");
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * Reverts with custom message when dividing by zero.
238      *
239      * Counterpart to Solidity's `%` operator. This function uses a `revert`
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      *
245      * - The divisor cannot be zero.
246      */
247     function mod(
248         uint256 a,
249         uint256 b,
250         string memory errorMessage
251     ) internal pure returns (uint256) {
252         require(b != 0, errorMessage);
253         return a % b;
254     }
255 }
256 
257 abstract contract Context {
258     function _msgSender() internal view virtual returns (address payable) {
259         return payable(msg.sender);
260     }
261 
262     function _msgData() internal view virtual returns (bytes memory) {
263         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
264         return msg.data;
265     }
266 }
267 
268 /**
269  * @dev Collection of functions related to the address type
270  */
271 library Address {
272     /**
273      * @dev Returns true if `account` is a contract.
274      *
275      * [IMPORTANT]
276      * ====
277      * It is unsafe to assume that an address for which this function returns
278      * false is an externally-owned account (EOA) and not a contract.
279      *
280      * Among others, `isContract` will return false for the following
281      * types of addresses:
282      *
283      *  - an externally-owned account
284      *  - a contract in construction
285      *  - an address where a contract will be created
286      *  - an address where a contract lived, but was destroyed
287      * ====
288      */
289     function isContract(address account) internal view returns (bool) {
290         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
291         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
292         // for accounts without code, i.e. `keccak256('')`
293         bytes32 codehash;
294         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
295         // solhint-disable-next-line no-inline-assembly
296         assembly {
297             codehash := extcodehash(account)
298         }
299         return (codehash != accountHash && codehash != 0x0);
300     }
301 
302     /**
303      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
304      * `recipient`, forwarding all available gas and reverting on errors.
305      *
306      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
307      * of certain opcodes, possibly making contracts go over the 2300 gas limit
308      * imposed by `transfer`, making them unable to receive funds via
309      * `transfer`. {sendValue} removes this limitation.
310      *
311      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
312      *
313      * IMPORTANT: because control is transferred to `recipient`, care must be
314      * taken to not create reentrancy vulnerabilities. Consider using
315      * {ReentrancyGuard} or the
316      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
317      */
318     function sendValue(address payable recipient, uint256 amount) internal {
319         require(
320             address(this).balance >= amount,
321             "Address: insufficient balance"
322         );
323 
324         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
325         (bool success, ) = recipient.call{value: amount}("");
326         require(
327             success,
328             "Address: unable to send value, recipient may have reverted"
329         );
330     }
331 
332     /**
333      * @dev Performs a Solidity function call using a low level `call`. A
334      * plain`call` is an unsafe replacement for a function call: use this
335      * function instead.
336      *
337      * If `target` reverts with a revert reason, it is bubbled up by this
338      * function (like regular Solidity function calls).
339      *
340      * Returns the raw returned data. To convert to the expected return value,
341      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
342      *
343      * Requirements:
344      *
345      * - `target` must be a contract.
346      * - calling `target` with `data` must not revert.
347      *
348      * _Available since v3.1._
349      */
350     function functionCall(address target, bytes memory data)
351         internal
352         returns (bytes memory)
353     {
354         return functionCall(target, data, "Address: low-level call failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
359      * `errorMessage` as a fallback revert reason when `target` reverts.
360      *
361      * _Available since v3.1._
362      */
363     function functionCall(
364         address target,
365         bytes memory data,
366         string memory errorMessage
367     ) internal returns (bytes memory) {
368         return _functionCallWithValue(target, data, 0, errorMessage);
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
373      * but also transferring `value` wei to `target`.
374      *
375      * Requirements:
376      *
377      * - the calling contract must have an ETH balance of at least `value`.
378      * - the called Solidity function must be `payable`.
379      *
380      * _Available since v3.1._
381      */
382     function functionCallWithValue(
383         address target,
384         bytes memory data,
385         uint256 value
386     ) internal returns (bytes memory) {
387         return
388             functionCallWithValue(
389                 target,
390                 data,
391                 value,
392                 "Address: low-level call with value failed"
393             );
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
398      * with `errorMessage` as a fallback revert reason when `target` reverts.
399      *
400      * _Available since v3.1._
401      */
402     function functionCallWithValue(
403         address target,
404         bytes memory data,
405         uint256 value,
406         string memory errorMessage
407     ) internal returns (bytes memory) {
408         require(
409             address(this).balance >= value,
410             "Address: insufficient balance for call"
411         );
412         return _functionCallWithValue(target, data, value, errorMessage);
413     }
414 
415     function _functionCallWithValue(
416         address target,
417         bytes memory data,
418         uint256 weiValue,
419         string memory errorMessage
420     ) private returns (bytes memory) {
421         require(isContract(target), "Address: call to non-contract");
422 
423         // solhint-disable-next-line avoid-low-level-calls
424         (bool success, bytes memory returndata) = target.call{value: weiValue}(
425             data
426         );
427         if (success) {
428             return returndata;
429         } else {
430             // Look for revert reason and bubble it up if present
431             if (returndata.length > 0) {
432                 // The easiest way to bubble the revert reason is using memory via assembly
433 
434                 // solhint-disable-next-line no-inline-assembly
435                 assembly {
436                     let returndata_size := mload(returndata)
437                     revert(add(32, returndata), returndata_size)
438                 }
439             } else {
440                 revert(errorMessage);
441             }
442         }
443     }
444 }
445 
446 /**
447  * @dev Contract module which provides a basic access control mechanism, where
448  * there is an account (an owner) that can be granted exclusive access to
449  * specific functions.
450  *
451  * By default, the owner account will be the one that deploys the contract. This
452  * can later be changed with {transferOwnership}.
453  *
454  * This module is used through inheritance. It will make available the modifier
455  * `onlyOwner`, which can be applied to your functions to restrict their use to
456  * the owner.
457  */
458 contract Ownable is Context {
459     address private _owner;
460     address private _previousOwner;
461     uint256 private _lockTime;
462 
463     event OwnershipTransferred(
464         address indexed previousOwner,
465         address indexed newOwner
466     );
467 
468     /**
469      * @dev Initializes the contract setting the deployer as the initial owner.
470      */
471     constructor() {
472         address msgSender = _msgSender();
473         _owner = msgSender;
474         emit OwnershipTransferred(address(0), msgSender);
475     }
476 
477     /**
478      * @dev Returns the address of the current owner.
479      */
480     function owner() public view returns (address) {
481         return _owner;
482     }
483 
484     /**
485      * @dev Throws if called by any account other than the owner.
486      */
487     modifier onlyOwner() {
488         require(_owner == _msgSender(), "Ownable: caller is not the owner");
489         _;
490     }
491 
492     /**
493      * @dev Leaves the contract without owner. It will not be possible to call
494      * `onlyOwner` functions anymore. Can only be called by the current owner.
495      *
496      * NOTE: Renouncing ownership will leave the contract without an owner,
497      * thereby removing any functionality that is only available to the owner.
498      */
499     function renounceOwnership() public virtual onlyOwner {
500         emit OwnershipTransferred(_owner, address(0));
501         _owner = address(0);
502     }
503 
504     /**
505      * @dev Transfers ownership of the contract to a new account (`newOwner`).
506      * Can only be called by the current owner.
507      */
508     function transferOwnership(address newOwner) public virtual onlyOwner {
509         require(
510             newOwner != address(0),
511             "Ownable: new owner is the zero address"
512         );
513         emit OwnershipTransferred(_owner, newOwner);
514         _owner = newOwner;
515     }
516 
517     function geUnlockTime() public view returns (uint256) {
518         return _lockTime;
519     }
520 
521     //Locks the contract for owner for the amount of time provided
522     function lock(uint256 time) public virtual onlyOwner {
523         _previousOwner = _owner;
524         _owner = address(0);
525         _lockTime = block.timestamp + time;
526         emit OwnershipTransferred(_owner, address(0));
527     }
528 
529     //Unlocks the contract for owner when _lockTime is exceeds
530     function unlock() public virtual {
531         require(
532             _previousOwner == msg.sender,
533             "You don't have permission to unlock"
534         );
535         require(block.timestamp > _lockTime, "Contract is locked until 7 days");
536         emit OwnershipTransferred(_owner, _previousOwner);
537         _owner = _previousOwner;
538     }
539 }
540 
541 // pragma solidity >=0.5.0;
542 
543 interface IUniswapV2Factory {
544     event PairCreated(
545         address indexed token0,
546         address indexed token1,
547         address pair,
548         uint256
549     );
550 
551     function feeTo() external view returns (address);
552 
553     function feeToSetter() external view returns (address);
554 
555     function getPair(address tokenA, address tokenB)
556         external
557         view
558         returns (address pair);
559 
560     function allPairs(uint256) external view returns (address pair);
561 
562     function allPairsLength() external view returns (uint256);
563 
564     function createPair(address tokenA, address tokenB)
565         external
566         returns (address pair);
567 
568     function setReflectionFeeTo(address) external;
569 
570     function setReflectionFeeToSetter(address) external;
571 }
572 
573 // pragma solidity >=0.5.0;
574 
575 interface IUniswapV2Pair {
576     event Approval(
577         address indexed owner,
578         address indexed spender,
579         uint256 value
580     );
581     event Transfer(address indexed from, address indexed to, uint256 value);
582 
583     function name() external pure returns (string memory);
584 
585     function symbol() external pure returns (string memory);
586 
587     function decimals() external pure returns (uint8);
588 
589     function totalSupply() external view returns (uint256);
590 
591     function balanceOf(address owner) external view returns (uint256);
592 
593     function allowance(address owner, address spender)
594         external
595         view
596         returns (uint256);
597 
598     function approve(address spender, uint256 value) external returns (bool);
599 
600     function transfer(address to, uint256 value) external returns (bool);
601 
602     function transferFrom(
603         address from,
604         address to,
605         uint256 value
606     ) external returns (bool);
607 
608     function DOMAIN_SEPARATOR() external view returns (bytes32);
609 
610     function PERMIT_TYPEHASH() external pure returns (bytes32);
611 
612     function nonces(address owner) external view returns (uint256);
613 
614     function permit(
615         address owner,
616         address spender,
617         uint256 value,
618         uint256 deadline,
619         uint8 v,
620         bytes32 r,
621         bytes32 s
622     ) external;
623 
624     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
625     event Burn(
626         address indexed sender,
627         uint256 amount0,
628         uint256 amount1,
629         address indexed to
630     );
631     event Swap(
632         address indexed sender,
633         uint256 amount0In,
634         uint256 amount1In,
635         uint256 amount0Out,
636         uint256 amount1Out,
637         address indexed to
638     );
639     event Sync(uint112 reserve0, uint112 reserve1);
640 
641     function MINIMUM_LIQUIDITY() external pure returns (uint256);
642 
643     function factory() external view returns (address);
644 
645     function token0() external view returns (address);
646 
647     function token1() external view returns (address);
648 
649     function getReserves()
650         external
651         view
652         returns (
653             uint112 reserve0,
654             uint112 reserve1,
655             uint32 blockTimestampLast
656         );
657 
658     function price0CumulativeLast() external view returns (uint256);
659 
660     function price1CumulativeLast() external view returns (uint256);
661 
662     function kLast() external view returns (uint256);
663 
664     function mint(address to) external returns (uint256 liquidity);
665 
666     function burn(address to)
667         external
668         returns (uint256 amount0, uint256 amount1);
669 
670     function swap(
671         uint256 amount0Out,
672         uint256 amount1Out,
673         address to,
674         bytes calldata data
675     ) external;
676 
677     function skim(address to) external;
678 
679     function sync() external;
680 
681     function initialize(address, address) external;
682 }
683 
684 // pragma solidity >=0.6.2;
685 
686 interface IUniswapV2Router01 {
687     function factory() external pure returns (address);
688 
689     function WETH() external pure returns (address);
690 
691     function addLiquidity(
692         address tokenA,
693         address tokenB,
694         uint256 amountADesired,
695         uint256 amountBDesired,
696         uint256 amountAMin,
697         uint256 amountBMin,
698         address to,
699         uint256 deadline
700     )
701         external
702         returns (
703             uint256 amountA,
704             uint256 amountB,
705             uint256 liquidity
706         );
707 
708     function addLiquidityETH(
709         address token,
710         uint256 amountTokenDesired,
711         uint256 amountTokenMin,
712         uint256 amountETHMin,
713         address to,
714         uint256 deadline
715     )
716         external
717         payable
718         returns (
719             uint256 amountToken,
720             uint256 amountETH,
721             uint256 liquidity
722         );
723 
724     function removeLiquidity(
725         address tokenA,
726         address tokenB,
727         uint256 liquidity,
728         uint256 amountAMin,
729         uint256 amountBMin,
730         address to,
731         uint256 deadline
732     ) external returns (uint256 amountA, uint256 amountB);
733 
734     function removeLiquidityETH(
735         address token,
736         uint256 liquidity,
737         uint256 amountTokenMin,
738         uint256 amountETHMin,
739         address to,
740         uint256 deadline
741     ) external returns (uint256 amountToken, uint256 amountETH);
742 
743     function removeLiquidityWithPermit(
744         address tokenA,
745         address tokenB,
746         uint256 liquidity,
747         uint256 amountAMin,
748         uint256 amountBMin,
749         address to,
750         uint256 deadline,
751         bool approveMax,
752         uint8 v,
753         bytes32 r,
754         bytes32 s
755     ) external returns (uint256 amountA, uint256 amountB);
756 
757     function removeLiquidityETHWithPermit(
758         address token,
759         uint256 liquidity,
760         uint256 amountTokenMin,
761         uint256 amountETHMin,
762         address to,
763         uint256 deadline,
764         bool approveMax,
765         uint8 v,
766         bytes32 r,
767         bytes32 s
768     ) external returns (uint256 amountToken, uint256 amountETH);
769 
770     function swapExactTokensForTokens(
771         uint256 amountIn,
772         uint256 amountOutMin,
773         address[] calldata path,
774         address to,
775         uint256 deadline
776     ) external returns (uint256[] memory amounts);
777 
778     function swapTokensForExactTokens(
779         uint256 amountOut,
780         uint256 amountInMax,
781         address[] calldata path,
782         address to,
783         uint256 deadline
784     ) external returns (uint256[] memory amounts);
785 
786     function swapExactETHForTokens(
787         uint256 amountOutMin,
788         address[] calldata path,
789         address to,
790         uint256 deadline
791     ) external payable returns (uint256[] memory amounts);
792 
793     function swapTokensForExactETH(
794         uint256 amountOut,
795         uint256 amountInMax,
796         address[] calldata path,
797         address to,
798         uint256 deadline
799     ) external returns (uint256[] memory amounts);
800 
801     function swapExactTokensForETH(
802         uint256 amountIn,
803         uint256 amountOutMin,
804         address[] calldata path,
805         address to,
806         uint256 deadline
807     ) external returns (uint256[] memory amounts);
808 
809     function swapETHForExactTokens(
810         uint256 amountOut,
811         address[] calldata path,
812         address to,
813         uint256 deadline
814     ) external payable returns (uint256[] memory amounts);
815 
816     function quote(
817         uint256 amountA,
818         uint256 reserveA,
819         uint256 reserveB
820     ) external pure returns (uint256 amountB);
821 
822     function getAmountOut(
823         uint256 amountIn,
824         uint256 reserveIn,
825         uint256 reserveOut
826     ) external pure returns (uint256 amountOut);
827 
828     function getAmountIn(
829         uint256 amountOut,
830         uint256 reserveIn,
831         uint256 reserveOut
832     ) external pure returns (uint256 amountIn);
833 
834     function getAmountsOut(uint256 amountIn, address[] calldata path)
835         external
836         view
837         returns (uint256[] memory amounts);
838 
839     function getAmountsIn(uint256 amountOut, address[] calldata path)
840         external
841         view
842         returns (uint256[] memory amounts);
843 }
844 
845 // pragma solidity >=0.6.2;
846 
847 interface IUniswapV2Router02 is IUniswapV2Router01 {
848     function removeLiquidityETHSupportingFeeOnTransferTokens(
849         address token,
850         uint256 liquidity,
851         uint256 amountTokenMin,
852         uint256 amountETHMin,
853         address to,
854         uint256 deadline
855     ) external returns (uint256 amountETH);
856 
857     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
858         address token,
859         uint256 liquidity,
860         uint256 amountTokenMin,
861         uint256 amountETHMin,
862         address to,
863         uint256 deadline,
864         bool approveMax,
865         uint8 v,
866         bytes32 r,
867         bytes32 s
868     ) external returns (uint256 amountETH);
869 
870     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
871         uint256 amountIn,
872         uint256 amountOutMin,
873         address[] calldata path,
874         address to,
875         uint256 deadline
876     ) external;
877 
878     function swapExactETHForTokensSupportingFeeOnTransferTokens(
879         uint256 amountOutMin,
880         address[] calldata path,
881         address to,
882         uint256 deadline
883     ) external payable;
884 
885     function swapExactTokensForETHSupportingFeeOnTransferTokens(
886         uint256 amountIn,
887         uint256 amountOutMin,
888         address[] calldata path,
889         address to,
890         uint256 deadline
891     ) external;
892 }
893 
894 contract MewInu is Context, IERC20, Ownable {
895     using SafeMath for uint256;
896     using Address for address;
897 
898     mapping(address => uint256) private _rOwned;
899     mapping(address => uint256) private _tOwned;
900     mapping(address => mapping(address => uint256)) private _allowances;
901 
902     mapping(address => bool) private _isExcludedFromFee;
903 
904     mapping(address => bool) private _isExcluded;
905     address[] private _excluded;
906 
907 	mapping(address => bool) public blackList;
908 
909     uint256 private constant MAX = ~uint256(0);
910     uint256 private _tTotal = 70000000000 * 10**18;
911     uint256 private _rTotal = (MAX - (MAX % _tTotal));
912     uint256 private _tReflectionFeeTotal;
913 
914     string private _name = "Mew Inu";
915     string private _symbol = "MEW";
916     uint8 private _decimals = 18;
917 
918     uint256 public reflectionFee = 1;
919     uint256 private _previousReflectionFee = reflectionFee;
920 
921     uint256 public txFee = 5;
922     uint256 private _previousTxFee = txFee;
923     address public feeRecipient;
924 
925     IUniswapV2Router02 public uniswapV2Router;
926     address public uniswapV2Pair;
927 
928     bool inSwapAndWithdraw;
929     bool public swapAndWithdrawEnabled = true;
930 
931     uint256 public maxTxAmount = 5000000 * 10**18;
932     uint256 public numTokensToSwap = 5000 * 10**18;
933 
934     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
935     event SwapAndWithdrawEnabledUpdated(bool enabled);
936 
937     modifier lockTheSwap() {
938         inSwapAndWithdraw = true;
939         _;
940         inSwapAndWithdraw = false;
941     }
942 
943     constructor() public {
944         _rOwned[_msgSender()] = _rTotal;
945 
946         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
947             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
948         );
949         // Create a uniswap pair for this new token
950         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
951             .createPair(address(this), _uniswapV2Router.WETH());
952 
953         // set the rest of the contract variables
954         uniswapV2Router = _uniswapV2Router;
955 
956         //exclude owner and this contract from fee
957         _isExcludedFromFee[owner()] = true;
958         _isExcludedFromFee[address(this)] = true;
959         feeRecipient = msg.sender;
960 
961         emit Transfer(address(0), _msgSender(), _tTotal);
962     }
963 
964     function name() public view returns (string memory) {
965         return _name;
966     }
967 
968     function symbol() public view returns (string memory) {
969         return _symbol;
970     }
971 
972     function decimals() public view returns (uint8) {
973         return _decimals;
974     }
975 
976     function totalSupply() public view override returns (uint256) {
977         return _tTotal;
978     }
979 
980     function balanceOf(address account) public view override returns (uint256) {
981         if (_isExcluded[account]) return _tOwned[account];
982         return tokenFromReflection(_rOwned[account]);
983     }
984 
985     function transfer(address recipient, uint256 amount)
986         public
987         override
988         returns (bool)
989     {
990         _transfer(_msgSender(), recipient, amount);
991         return true;
992     }
993 
994     function allowance(address owner, address spender)
995         public
996         view
997         override
998         returns (uint256)
999     {
1000         return _allowances[owner][spender];
1001     }
1002 
1003     function approve(address spender, uint256 amount)
1004         public
1005         override
1006         returns (bool)
1007     {
1008         _approve(_msgSender(), spender, amount);
1009         return true;
1010     }
1011 
1012     function transferFrom(
1013         address sender,
1014         address recipient,
1015         uint256 amount
1016     ) public override returns (bool) {
1017         _transfer(sender, recipient, amount);
1018         _approve(
1019             sender,
1020             _msgSender(),
1021             _allowances[sender][_msgSender()].sub(
1022                 amount,
1023                 "ERC20: transfer amount exceeds allowance"
1024             )
1025         );
1026         return true;
1027     }
1028 
1029     function increaseAllowance(address spender, uint256 addedValue)
1030         public
1031         virtual
1032         returns (bool)
1033     {
1034         _approve(
1035             _msgSender(),
1036             spender,
1037             _allowances[_msgSender()][spender].add(addedValue)
1038         );
1039         return true;
1040     }
1041 
1042     function decreaseAllowance(address spender, uint256 subtractedValue)
1043         public
1044         virtual
1045         returns (bool)
1046     {
1047         _approve(
1048             _msgSender(),
1049             spender,
1050             _allowances[_msgSender()][spender].sub(
1051                 subtractedValue,
1052                 "ERC20: decreased allowance below zero"
1053             )
1054         );
1055         return true;
1056     }
1057 
1058     function isExcludedFromReward(address account) public view returns (bool) {
1059         return _isExcluded[account];
1060     }
1061 
1062     function totalReflectionFees() public view returns (uint256) {
1063         return _tReflectionFeeTotal;
1064     }
1065 
1066     function deliver(uint256 tAmount) public {
1067         address sender = _msgSender();
1068         require(
1069             !_isExcluded[sender],
1070             "Excluded addresses cannot call this function"
1071         );
1072         (uint256 rAmount, , , , , ) = _getValues(tAmount);
1073         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1074         _rTotal = _rTotal.sub(rAmount);
1075         _tReflectionFeeTotal = _tReflectionFeeTotal.add(tAmount);
1076     }
1077 
1078     function reflectionFromToken(
1079         uint256 tAmount,
1080         bool deductTransferReflectionFee
1081     ) public view returns (uint256) {
1082         require(tAmount <= _tTotal, "Amount must be less than supply");
1083         if (!deductTransferReflectionFee) {
1084             (uint256 rAmount, , , , , ) = _getValues(tAmount);
1085             return rAmount;
1086         } else {
1087             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
1088             return rTransferAmount;
1089         }
1090     }
1091 
1092     function tokenFromReflection(uint256 rAmount)
1093         public
1094         view
1095         returns (uint256)
1096     {
1097         require(
1098             rAmount <= _rTotal,
1099             "Amount must be less than total reflections"
1100         );
1101         uint256 currentRate = _getRate();
1102         return rAmount.div(currentRate);
1103     }
1104 
1105     function excludeFromReward(address account) public onlyOwner {
1106         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
1107         require(!_isExcluded[account], "Account is already excluded");
1108         if (_rOwned[account] > 0) {
1109             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1110         }
1111         _isExcluded[account] = true;
1112         _excluded.push(account);
1113     }
1114 
1115     function includeInReward(address account) external onlyOwner {
1116         require(_isExcluded[account], "Account is already included");
1117         for (uint256 i = 0; i < _excluded.length; i++) {
1118             if (_excluded[i] == account) {
1119                 _excluded[i] = _excluded[_excluded.length - 1];
1120                 _tOwned[account] = 0;
1121                 _isExcluded[account] = false;
1122                 _excluded.pop();
1123                 break;
1124             }
1125         }
1126     }
1127 
1128     function _transferBothExcluded(
1129         address sender,
1130         address recipient,
1131         uint256 tAmount
1132     ) private {
1133         (
1134             uint256 rAmount,
1135             uint256 rTransferAmount,
1136             uint256 rReflectionFee,
1137             uint256 tTransferAmount,
1138             uint256 tReflectionFee,
1139             uint256 tTxFee
1140         ) = _getValues(tAmount);
1141         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1142         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1143         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1144         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1145         _takeTxFee(tTxFee);
1146         _reflectReflectionFee(rReflectionFee, tReflectionFee);
1147         emit Transfer(sender, recipient, tTransferAmount);
1148     }
1149 
1150     function excludeFromFee(address account) public onlyOwner {
1151         _isExcludedFromFee[account] = true;
1152     }
1153 
1154     function includeInFee(address account) public onlyOwner {
1155         _isExcludedFromFee[account] = false;
1156     }
1157 
1158     function setReflectionFeePercent(uint256 _reflectionFee) external onlyOwner {
1159         reflectionFee = _reflectionFee;
1160     }
1161 
1162     function setTxFeePercent(uint256 _txFee) external onlyOwner {
1163         txFee = _txFee;
1164     }
1165 
1166     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner {
1167         maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
1168     }
1169 
1170     function setSwapAndWithdrawEnabled(bool _enabled) public onlyOwner {
1171         swapAndWithdrawEnabled = _enabled;
1172         emit SwapAndWithdrawEnabledUpdated(_enabled);
1173     }
1174 
1175     //to recieve ETH from uniswapV2Router when swaping
1176     receive() external payable {}
1177 
1178     function _reflectReflectionFee(
1179         uint256 rReflectionFee,
1180         uint256 tReflectionFee
1181     ) private {
1182         _rTotal = _rTotal.sub(rReflectionFee);
1183         _tReflectionFeeTotal = _tReflectionFeeTotal.add(tReflectionFee);
1184     }
1185 
1186     function _getValues(uint256 tAmount)
1187         private
1188         view
1189         returns (
1190             uint256,
1191             uint256,
1192             uint256,
1193             uint256,
1194             uint256,
1195             uint256
1196         )
1197     {
1198         (
1199             uint256 tTransferAmount,
1200             uint256 tReflectionFee,
1201             uint256 tTxFee
1202         ) = _getTValues(tAmount);
1203         (
1204             uint256 rAmount,
1205             uint256 rTransferAmount,
1206             uint256 rReflectionFee
1207         ) = _getRValues(tAmount, tReflectionFee, tTxFee, _getRate());
1208         return (
1209             rAmount,
1210             rTransferAmount,
1211             rReflectionFee,
1212             tTransferAmount,
1213             tReflectionFee,
1214             tTxFee
1215         );
1216     }
1217 
1218     function _getTValues(uint256 tAmount)
1219         private
1220         view
1221         returns (
1222             uint256,
1223             uint256,
1224             uint256
1225         )
1226     {
1227         uint256 tReflectionFee = calculateReflectionTxFee(tAmount);
1228         uint256 tTxFee = calculateTxFee(tAmount);
1229         uint256 tTransferAmount = tAmount.sub(tReflectionFee).sub(tTxFee);
1230         return (tTransferAmount, tReflectionFee, tTxFee);
1231     }
1232 
1233     function _getRValues(
1234         uint256 tAmount,
1235         uint256 tReflectionFee,
1236         uint256 tTxFee,
1237         uint256 currentRate
1238     )
1239         private
1240         pure
1241         returns (
1242             uint256,
1243             uint256,
1244             uint256
1245         )
1246     {
1247         uint256 rAmount = tAmount.mul(currentRate);
1248         uint256 rReflectionFee = tReflectionFee.mul(currentRate);
1249         uint256 rTxFee = tTxFee.mul(currentRate);
1250         uint256 rTransferAmount = rAmount.sub(rReflectionFee).sub(rTxFee);
1251         return (rAmount, rTransferAmount, rReflectionFee);
1252     }
1253 
1254     function _getRate() private view returns (uint256) {
1255         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1256         return rSupply.div(tSupply);
1257     }
1258 
1259     function _getCurrentSupply() private view returns (uint256, uint256) {
1260         uint256 rSupply = _rTotal;
1261         uint256 tSupply = _tTotal;
1262         for (uint256 i = 0; i < _excluded.length; i++) {
1263             if (
1264                 _rOwned[_excluded[i]] > rSupply ||
1265                 _tOwned[_excluded[i]] > tSupply
1266             ) return (_rTotal, _tTotal);
1267             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1268             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1269         }
1270         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1271         return (rSupply, tSupply);
1272     }
1273 
1274     function _takeTxFee(uint256 tTxFee) private {
1275         uint256 currentRate = _getRate();
1276         uint256 rTxFee = tTxFee.mul(currentRate);
1277         _rOwned[address(this)] = _rOwned[address(this)].add(rTxFee);
1278         if (_isExcluded[address(this)])
1279             _tOwned[address(this)] = _tOwned[address(this)].add(tTxFee);
1280     }
1281 
1282     function calculateReflectionTxFee(uint256 _amount)
1283         private
1284         view
1285         returns (uint256)
1286     {
1287         return _amount.mul(reflectionFee).div(10**2);
1288     }
1289 
1290     function calculateTxFee(uint256 _amount) private view returns (uint256) {
1291         return _amount.mul(txFee).div(10**2);
1292     }
1293 
1294     function removeAllFee() private {
1295         if (reflectionFee == 0 && txFee == 0) return;
1296 
1297         _previousReflectionFee = reflectionFee;
1298         _previousTxFee = txFee;
1299 
1300         reflectionFee = 0;
1301         txFee = 0;
1302     }
1303 
1304     function restoreAllFee() private {
1305         reflectionFee = _previousReflectionFee;
1306         txFee = _previousTxFee;
1307     }
1308 
1309     function isExcludedFromFee(address account) public view returns (bool) {
1310         return _isExcludedFromFee[account];
1311     }
1312 
1313     function _approve(
1314         address owner,
1315         address spender,
1316         uint256 amount
1317     ) private {
1318         require(owner != address(0), "ERC20: approve from the zero address");
1319         require(spender != address(0), "ERC20: approve to the zero address");
1320 
1321         _allowances[owner][spender] = amount;
1322         emit Approval(owner, spender, amount);
1323     }
1324 
1325     function _transfer(
1326         address from,
1327         address to,
1328         uint256 amount
1329     ) private {
1330         require(from != address(0), "ERC20: transfer from the zero address");
1331         require(to != address(0), "ERC20: transfer to the zero address");
1332         require(amount > 0, "Transfer amount must be greater than zero");
1333 		require(
1334             !blackList[from] && !blackList[to],
1335             "sender or Recipient wallet is dead."
1336         );
1337         if (from != owner() && to != owner())
1338             require(
1339                 amount <= maxTxAmount,
1340                 "Transfer amount exceeds the maxTxAmount."
1341             );
1342 
1343         // is the token balance of this contract address over the min number of
1344         // tokens that we need to initiate a swap + liquidity lock?
1345         // also, don't get caught in a circular liquidity event.
1346         // also, don't swap & liquify if sender is uniswap pair.
1347         uint256 contractTokenBalance = balanceOf(address(this));
1348 
1349         if (contractTokenBalance >= maxTxAmount) {
1350             contractTokenBalance = maxTxAmount;
1351         }
1352 
1353         bool overMinTokenBalance = contractTokenBalance >=
1354             numTokensToSwap;
1355         if (
1356             overMinTokenBalance &&
1357             !inSwapAndWithdraw &&
1358             from != uniswapV2Pair &&
1359             swapAndWithdrawEnabled
1360         ) {
1361             contractTokenBalance = numTokensToSwap;
1362             //withdraw
1363             swapAndWithdraw(contractTokenBalance);
1364         }
1365 
1366         //indicates if fee should be deducted from transfer
1367         bool takeFee = true;
1368 
1369         //if any account belongs to _isExcludedFromFee account then remove the fee
1370         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1371             takeFee = false;
1372         }
1373 
1374         //transfer amount, it will take tax, burn, liquidity fee
1375         _tokenTransfer(from, to, amount, takeFee);
1376     }
1377 
1378     function swapAndWithdraw(uint256 contractTokenBalance) private lockTheSwap {
1379         // swap tokens for ETH
1380         swapTokensForEth(contractTokenBalance);
1381 
1382 		// withdraw to fee recipient
1383         payable(feeRecipient).transfer(address(this).balance);
1384     }
1385 
1386     function swapTokensForEth(uint256 tokenAmount) private {
1387         // generate the uniswap pair path of token -> weth
1388         address[] memory path = new address[](2);
1389         path[0] = address(this);
1390         path[1] = uniswapV2Router.WETH();
1391 
1392         _approve(address(this), address(uniswapV2Router), tokenAmount);
1393 
1394         // make the swap
1395         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1396             tokenAmount,
1397             0, // accept any amount of ETH
1398             path,
1399             address(this),
1400             block.timestamp
1401         );
1402     }
1403 
1404     //this method is responsible for taking all fee, if takeFee is true
1405     function _tokenTransfer(
1406         address sender,
1407         address recipient,
1408         uint256 amount,
1409         bool takeFee
1410     ) private {
1411         if (!takeFee) removeAllFee();
1412 
1413         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1414             _transferFromExcluded(sender, recipient, amount);
1415         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1416             _transferToExcluded(sender, recipient, amount);
1417         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1418             _transferStandard(sender, recipient, amount);
1419         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1420             _transferBothExcluded(sender, recipient, amount);
1421         } else {
1422             _transferStandard(sender, recipient, amount);
1423         }
1424 
1425         if (!takeFee) restoreAllFee();
1426     }
1427 
1428     function _transferStandard(
1429         address sender,
1430         address recipient,
1431         uint256 tAmount
1432     ) private {
1433         (
1434             uint256 rAmount,
1435             uint256 rTransferAmount,
1436             uint256 rReflectionFee,
1437             uint256 tTransferAmount,
1438             uint256 tReflectionFee,
1439             uint256 tTxFee
1440         ) = _getValues(tAmount);
1441         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1442         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1443         _takeTxFee(tTxFee);
1444         _reflectReflectionFee(rReflectionFee, tReflectionFee);
1445         emit Transfer(sender, recipient, tTransferAmount);
1446     }
1447 
1448     function _transferToExcluded(
1449         address sender,
1450         address recipient,
1451         uint256 tAmount
1452     ) private {
1453         (
1454             uint256 rAmount,
1455             uint256 rTransferAmount,
1456             uint256 rReflectionFee,
1457             uint256 tTransferAmount,
1458             uint256 tReflectionFee,
1459             uint256 tTxFee
1460         ) = _getValues(tAmount);
1461         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1462         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1463         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1464         _takeTxFee(tTxFee);
1465         _reflectReflectionFee(rReflectionFee, tReflectionFee);
1466         emit Transfer(sender, recipient, tTransferAmount);
1467     }
1468 
1469     function _transferFromExcluded(
1470         address sender,
1471         address recipient,
1472         uint256 tAmount
1473     ) private {
1474         (
1475             uint256 rAmount,
1476             uint256 rTransferAmount,
1477             uint256 rReflectionFee,
1478             uint256 tTransferAmount,
1479             uint256 tReflectionFee,
1480             uint256 tTxFee
1481         ) = _getValues(tAmount);
1482         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1483         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1484         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1485         _takeTxFee(tTxFee);
1486         _reflectReflectionFee(rReflectionFee, tReflectionFee);
1487         emit Transfer(sender, recipient, tTransferAmount);
1488     }
1489 
1490     function setFeeRecipient(address _recipient) external {
1491         require(feeRecipient == msg.sender, "!fee recipient");
1492         feeRecipient = _recipient;
1493     }
1494 
1495     function updateUniRouter(address _router) external onlyOwner {
1496         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(_router);
1497         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(
1498             address(this),
1499             _uniswapV2Router.WETH()
1500         );
1501         if (uniswapV2Pair == address(0)) {
1502             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1503                 .createPair(address(this), _uniswapV2Router.WETH());
1504         }
1505         // set the rest of the contract variables
1506         uniswapV2Router = _uniswapV2Router;
1507     }
1508     
1509 	function removeFromBlackList(address _addr) public onlyOwner {
1510         blackList[_addr] = false;
1511     }
1512 
1513     function addToBlackList(address _addr) public onlyOwner {
1514         blackList[_addr] = true;
1515     }
1516 
1517 	function setMinimunTokenAmountToSwap(uint _amount) external onlyOwner {
1518 		numTokensToSwap = _amount;
1519 	}
1520 }