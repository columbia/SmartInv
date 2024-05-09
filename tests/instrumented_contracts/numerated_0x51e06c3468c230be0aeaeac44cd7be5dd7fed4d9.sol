1 pragma solidity 0.7.6;
2 // SPDX-License-Identifier: Unlicensed
3 pragma experimental ABIEncoderV2;
4 
5 interface IERC20 {
6     function decimals() external view returns (uint8);
7 
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
259         return msg.sender;
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
472         //internal
473         address msgSender = _msgSender();
474         _owner = msgSender;
475         emit OwnershipTransferred(address(0), msgSender);
476     }
477 
478     /**
479      * @dev Returns the address of the current owner.
480      */
481     function owner() public view returns (address) {
482         return _owner;
483     }
484 
485     /**
486      * @dev Throws if called by any account other than the owner.
487      */
488     modifier onlyOwner() {
489         require(_owner == _msgSender(), "Ownable: caller is not the owner");
490         _;
491     }
492 
493     /**
494      * @dev Leaves the contract without owner. It will not be possible to call
495      * `onlyOwner` functions anymore. Can only be called by the current owner.
496      *
497      * NOTE: Renouncing ownership will leave the contract without an owner,
498      * thereby removing any functionality that is only available to the owner.
499      */
500     function renounceOwnership() public virtual onlyOwner {
501         emit OwnershipTransferred(_owner, address(0));
502         _owner = address(0);
503     }
504 
505     /**
506      * @dev Transfers ownership of the contract to a new account (`newOwner`).
507      * Can only be called by the current owner.
508      */
509     function transferOwnership(address newOwner) public virtual onlyOwner {
510         require(
511             newOwner != address(0),
512             "Ownable: new owner is the zero address"
513         );
514         emit OwnershipTransferred(_owner, newOwner);
515         _owner = newOwner;
516     }
517 
518     function geUnlockTime() public view returns (uint256) {
519         return _lockTime;
520     }
521 
522     //Locks the contract for owner for the amount of time provided
523     function lock(uint256 time) public virtual onlyOwner {
524         _previousOwner = _owner;
525         _owner = address(0);
526         _lockTime = block.timestamp + time;
527         emit OwnershipTransferred(_owner, address(0));
528     }
529 
530     //Unlocks the contract for owner when _lockTime is exceeds
531     function unlock() public virtual {
532         require(
533             _previousOwner == msg.sender,
534             "You don't have permission to unlock"
535         );
536         require(block.timestamp > _lockTime, "Contract is locked until 7 days");
537         emit OwnershipTransferred(_owner, _previousOwner);
538         _owner = _previousOwner;
539     }
540 }
541 
542 // pragma solidity >=0.5.0;
543 
544 interface IUniswapV2Factory {
545     event PairCreated(
546         address indexed token0,
547         address indexed token1,
548         address pair,
549         uint256
550     );
551 
552     function feeTo() external view returns (address);
553 
554     function feeToSetter() external view returns (address);
555 
556     function getPair(address tokenA, address tokenB)
557         external
558         view
559         returns (address pair);
560 
561     function allPairs(uint256) external view returns (address pair);
562 
563     function allPairsLength() external view returns (uint256);
564 
565     function createPair(address tokenA, address tokenB)
566         external
567         returns (address pair);
568 
569     function setFeeTo(address) external;
570 
571     function setFeeToSetter(address) external;
572 }
573 
574 // pragma solidity >=0.5.0;
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
685 // pragma solidity >=0.6.2;
686 
687 interface IUniswapV2Router01 {
688     function factory() external pure returns (address);
689 
690     function WETH() external pure returns (address);
691 
692     function addLiquidity(
693         address tokenA,
694         address tokenB,
695         uint256 amountADesired,
696         uint256 amountBDesired,
697         uint256 amountAMin,
698         uint256 amountBMin,
699         address to,
700         uint256 deadline
701     )
702         external
703         returns (
704             uint256 amountA,
705             uint256 amountB,
706             uint256 liquidity
707         );
708 
709     function addLiquidityETH(
710         address token,
711         uint256 amountTokenDesired,
712         uint256 amountTokenMin,
713         uint256 amountETHMin,
714         address to,
715         uint256 deadline
716     )
717         external
718         payable
719         returns (
720             uint256 amountToken,
721             uint256 amountETH,
722             uint256 liquidity
723         );
724 
725     function removeLiquidity(
726         address tokenA,
727         address tokenB,
728         uint256 liquidity,
729         uint256 amountAMin,
730         uint256 amountBMin,
731         address to,
732         uint256 deadline
733     ) external returns (uint256 amountA, uint256 amountB);
734 
735     function removeLiquidityETH(
736         address token,
737         uint256 liquidity,
738         uint256 amountTokenMin,
739         uint256 amountETHMin,
740         address to,
741         uint256 deadline
742     ) external returns (uint256 amountToken, uint256 amountETH);
743 
744     function removeLiquidityWithPermit(
745         address tokenA,
746         address tokenB,
747         uint256 liquidity,
748         uint256 amountAMin,
749         uint256 amountBMin,
750         address to,
751         uint256 deadline,
752         bool approveMax,
753         uint8 v,
754         bytes32 r,
755         bytes32 s
756     ) external returns (uint256 amountA, uint256 amountB);
757 
758     function removeLiquidityETHWithPermit(
759         address token,
760         uint256 liquidity,
761         uint256 amountTokenMin,
762         uint256 amountETHMin,
763         address to,
764         uint256 deadline,
765         bool approveMax,
766         uint8 v,
767         bytes32 r,
768         bytes32 s
769     ) external returns (uint256 amountToken, uint256 amountETH);
770 
771     function swapExactTokensForTokens(
772         uint256 amountIn,
773         uint256 amountOutMin,
774         address[] calldata path,
775         address to,
776         uint256 deadline
777     ) external returns (uint256[] memory amounts);
778 
779     function swapTokensForExactTokens(
780         uint256 amountOut,
781         uint256 amountInMax,
782         address[] calldata path,
783         address to,
784         uint256 deadline
785     ) external returns (uint256[] memory amounts);
786 
787     function swapExactETHForTokens(
788         uint256 amountOutMin,
789         address[] calldata path,
790         address to,
791         uint256 deadline
792     ) external payable returns (uint256[] memory amounts);
793 
794     function swapTokensForExactETH(
795         uint256 amountOut,
796         uint256 amountInMax,
797         address[] calldata path,
798         address to,
799         uint256 deadline
800     ) external returns (uint256[] memory amounts);
801 
802     function swapExactTokensForETH(
803         uint256 amountIn,
804         uint256 amountOutMin,
805         address[] calldata path,
806         address to,
807         uint256 deadline
808     ) external returns (uint256[] memory amounts);
809 
810     function swapETHForExactTokens(
811         uint256 amountOut,
812         address[] calldata path,
813         address to,
814         uint256 deadline
815     ) external payable returns (uint256[] memory amounts);
816 
817     function quote(
818         uint256 amountA,
819         uint256 reserveA,
820         uint256 reserveB
821     ) external pure returns (uint256 amountB);
822 
823     function getAmountOut(
824         uint256 amountIn,
825         uint256 reserveIn,
826         uint256 reserveOut
827     ) external pure returns (uint256 amountOut);
828 
829     function getAmountIn(
830         uint256 amountOut,
831         uint256 reserveIn,
832         uint256 reserveOut
833     ) external pure returns (uint256 amountIn);
834 
835     function getAmountsOut(uint256 amountIn, address[] calldata path)
836         external
837         view
838         returns (uint256[] memory amounts);
839 
840     function getAmountsIn(uint256 amountOut, address[] calldata path)
841         external
842         view
843         returns (uint256[] memory amounts);
844 }
845 
846 // pragma solidity >=0.6.2;
847 
848 interface IUniswapV2Router02 is IUniswapV2Router01 {
849     function removeLiquidityETHSupportingFeeOnTransferTokens(
850         address token,
851         uint256 liquidity,
852         uint256 amountTokenMin,
853         uint256 amountETHMin,
854         address to,
855         uint256 deadline
856     ) external returns (uint256 amountETH);
857 
858     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
859         address token,
860         uint256 liquidity,
861         uint256 amountTokenMin,
862         uint256 amountETHMin,
863         address to,
864         uint256 deadline,
865         bool approveMax,
866         uint8 v,
867         bytes32 r,
868         bytes32 s
869     ) external returns (uint256 amountETH);
870 
871     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
872         uint256 amountIn,
873         uint256 amountOutMin,
874         address[] calldata path,
875         address to,
876         uint256 deadline
877     ) external;
878 
879     function swapExactETHForTokensSupportingFeeOnTransferTokens(
880         uint256 amountOutMin,
881         address[] calldata path,
882         address to,
883         uint256 deadline
884     ) external payable;
885 
886     function swapExactTokensForETHSupportingFeeOnTransferTokens(
887         uint256 amountIn,
888         uint256 amountOutMin,
889         address[] calldata path,
890         address to,
891         uint256 deadline
892     ) external;
893 }
894 
895 /// @title Wallphy Token Contract
896 
897 contract Wallphy is Context, IERC20, Ownable {
898     using SafeMath for uint256;
899     using Address for address;
900 
901     mapping(address => uint256) private _tOwned;
902     mapping(address => mapping(address => uint256)) private _allowances;
903     mapping(address => bool) private _isExcludedFromFee;
904     uint256 private _tTotal = 1000000000000000 * 10**18;
905     string private _name = "Wallphy";
906     string private _symbol = "Wallphy";
907     uint8 private _decimals = 18;
908     uint256 public _taxFee = 12;
909     uint256 public _liquidityFee = 3;
910     uint256 public _additionalTax = 10;
911     /// @notice Above this amount, the additionalTax will be charged on transfers
912     uint256 public _additionalTaxThreshold = _tTotal.mul(25).div(10000); 
913     address public devFeeWallet = 0x67a76c888fA3576984142227D2ea31091739853F;
914     mapping(address => bool) private transferBlacklist;
915     /// @notice Token transfers associated with trades on a DEX (Uniswap) are taxed
916     bool public taxOnlyDex = true;
917     uint256 public _maxTxAmount = _tTotal.mul(1).div(100);
918     uint256 public taxYetToBeSentToDev;
919     uint256 private minimumDevTaxDistributionThreshold = 0;
920     uint256 public taxYetToBeLiquified;
921     uint256 private numTokensSellToAddToLiquidity = 0;
922 
923     IUniswapV2Router02 public uniswapV2Router;
924     address public uniswapV2Pair;
925     bool private inSwapAndLiquify;
926     bool public swapAndLiquifyEnabled = true;
927     bool private inSwapAndSendDev;
928     bool public swapAndSendDevEnabled = true;
929     bool public isAirdropCompleted = false;
930 
931     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
932     event SwapAndLiquifyEnabledUpdated(bool enabled);
933     event SwapAndSendDevEnabledUpdated(bool enabled);
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
945     modifier lockSendDev() {
946         inSwapAndSendDev = true;
947         _;
948         inSwapAndSendDev = false;
949     }
950 
951     constructor() {
952         //manually set owner balance so owner can provide liquidity before conducting the airdrop. Value is calculated prior to deployment and is the amount of tokens after subtracting airdrop allocations
953         _tOwned[msg.sender] = 211032861142177000000000000000000;
954         _tOwned[address(this)]=_tTotal.sub(_tOwned[msg.sender]);
955         setRouterAddress(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Uniswap V2 router
956         _isExcludedFromFee[owner()] = true;
957         _isExcludedFromFee[address(this)] = true;
958     }
959 
960     /// @notice Returns the token's name
961     function name() public view returns (string memory) {
962         return _name;
963     }
964 
965     /// @notice Returns the token's symbol
966     function symbol() public view returns (string memory) {
967         return _symbol;
968     }
969 
970     /// @notice Returns the token's decimal precision
971     function decimals() public view override returns (uint8) {
972         return _decimals;
973     }
974 
975     /// @notice Returns the token's total supply
976     function totalSupply() public view override returns (uint256) {
977         return _tTotal;
978     }
979 
980     /// @notice Returns the token balance of an address
981     /// @param account address to query
982     function balanceOf(address account) public view override returns (uint256) {
983         return _tOwned[account];
984     }
985 
986     /// @notice Transfers tokens while implementing customized tax logic
987     /// @param _to Recipient address
988     /// @param _value amount of tokens to transfer
989     function transfer(address _to, uint256 _value)
990         public
991         override
992         returns (bool)
993     {
994         require(_value > 0, "Value Too Low");
995         require(transferBlacklist[msg.sender] == false, "Sender Blacklisted");
996         require(transferBlacklist[_to] == false, "Recipient Blacklisted");
997         require(_tOwned[msg.sender] >= _value, "Balance Too Low");
998 
999         if (
1000             _isExcludedFromFee[msg.sender] == true ||
1001             _isExcludedFromFee[_to] == true
1002         ) {
1003             _tOwned[msg.sender] = _tOwned[msg.sender].sub(_value);
1004             _tOwned[_to] = _tOwned[_to].add(_value);
1005             emit Transfer(msg.sender, _to, _value);
1006         } else if (
1007             taxOnlyDex == true &&
1008             (_msgSender() == uniswapV2Pair || _to == uniswapV2Pair)
1009         ) {
1010             //Taxes direct transfers to/from LP pair
1011             _transfer(_msgSender(), _to, _value);
1012         } else {
1013             //transfers between regular wallets are not taxed
1014             _tOwned[msg.sender] = _tOwned[msg.sender].sub(_value);
1015             _tOwned[_to] = _tOwned[_to].add(_value);
1016             emit Transfer(msg.sender, _to, _value);
1017         }
1018         return true;
1019     }
1020 
1021     /// @notice Checks how many tokens an address can transfer on behalf of another address
1022     /// @param owner address that owns the tokens
1023     /// @param spender address that is allowed to transfer tokens on behalf of owner
1024     function allowance(address owner, address spender)
1025         public
1026         view
1027         override
1028         returns (uint256)
1029     {
1030         return _allowances[owner][spender];
1031     }
1032 
1033     /// @notice Sets the amount of tokens an address can transfer on behalf of another address
1034     /// @param _spender address that is allowed to transfer tokens on behalf of the function caller
1035     /// @param _value amount of tokens that _spender is allowed to transfer
1036     function approve(address _spender, uint256 _value)
1037         public
1038         override
1039         returns (bool)
1040     {
1041         _approve(_msgSender(), _spender, _value);
1042         return true;
1043     }
1044 
1045     /// @notice Allows caller to transfer tokens on behalf of an address
1046     /// @param _from Address that sends the tokens
1047     /// @param _to Address that receives the tokens
1048     /// @param _value amount of tokens to transfer
1049     function transferFrom(
1050         address _from,
1051         address _to,
1052         uint256 _value
1053     ) public override returns (bool) {
1054         require(_value > 0, "Value Too Low");
1055         require(transferBlacklist[_from] == false, "Sender Blacklisted");
1056         require(transferBlacklist[_to] == false, "Recipient Blacklisted");
1057         require(_value <= _tOwned[_from], "Balance Too Low");
1058         require(_value <= _allowances[_from][msg.sender], "Approval Too Low");
1059 
1060         if (
1061             _isExcludedFromFee[_from] == true || _isExcludedFromFee[_to] == true
1062         ) {
1063             _tOwned[_from] = _tOwned[_from].sub(_value);
1064             _tOwned[_to] = _tOwned[_to].add(_value);
1065             _allowances[_from][msg.sender] = _allowances[_from][msg.sender].sub(
1066                 _value
1067             );
1068 
1069             emit Transfer(_from, _to, _value);
1070         } else {
1071             _transfer(_from, _to, _value);
1072             _approve(
1073                 _from,
1074                 _msgSender(),
1075                 _allowances[_from][_msgSender()].sub(
1076                     _value,
1077                     "ERC20: transfer amount exceeds allowance"
1078                 )
1079             );
1080         }
1081         return true;
1082     }
1083 
1084 
1085     /// @notice Conducts airdrop to an array of users
1086     /// @param supportersAddresses Array of users
1087     /// @param supportersAmounts Airdrop amount corresponding to each user
1088     function conductAirdrop(address[] memory supportersAddresses, uint256[] memory supportersAmounts) public onlyOwner{
1089         require(isAirdropCompleted==false, "Airdrop Already Finished");
1090         isAirdropCompleted=true;
1091 
1092         for (uint8 i = 0; i < supportersAddresses.length; i++) {
1093             _tOwned[address(this)]=_tOwned[address(this)].sub(supportersAmounts[i]);
1094             _tOwned[supportersAddresses[i]] = _tOwned[supportersAddresses[i]].add(supportersAmounts[i]);
1095             emit Transfer(address(this), supportersAddresses[i], supportersAmounts[i]);
1096         }
1097         
1098     }
1099 
1100     /// @notice This function is used in case you want to migrate liquidity to another DEX, which is why using Uniswap V2 is ideal, b/c most other Dexes are forks of V2
1101     /// @param newRouter DEX router address
1102     function setRouterAddress(address newRouter) public onlyOwner {
1103         IUniswapV2Router02 _newPancakeRouter = IUniswapV2Router02(newRouter);
1104         uniswapV2Pair = IUniswapV2Factory(_newPancakeRouter.factory())
1105             .createPair(address(this), _newPancakeRouter.WETH());
1106         uniswapV2Router = _newPancakeRouter;
1107     }
1108 
1109     /// @notice Exclude an address from being charged a tax on token transfer
1110     /// @param account Address to exclude
1111     function excludeFromFee(address account) public onlyOwner {
1112         _isExcludedFromFee[account] = true;
1113     }
1114 
1115     /// @notice Include an address to be charged a tax on token transfer
1116     /// @param account Address to include
1117     function includeInFee(address account) public onlyOwner {
1118         _isExcludedFromFee[account] = false;
1119     }
1120 
1121     /// @notice Blacklist/unblacklist an address from being able to send and receive tokens
1122     /// @param account Account to modify setting for
1123     /// @param yesOrNo Blacklist or unblacklist
1124     function setBlacklist(address account, bool yesOrNo) public onlyOwner {
1125         transferBlacklist[account] = yesOrNo;
1126     }
1127 
1128     /// @notice Set the tax rate for the Dev tax, which is sent to the Dev Wallet
1129     function setTaxFeePercent(uint256 taxFee) external onlyOwner {
1130          require (taxFee + _liquidityFee + _additionalTax <=25, "25 is Max Tax Threshold");
1131         _taxFee = taxFee;
1132     }
1133 
1134     /// @notice Set the tax rate for the liquidity tax, which is used to provide liquidity for the token
1135     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner {
1136         require (_taxFee + liquidityFee + _additionalTax <=25, "25 is Max Tax Threshold");
1137         _liquidityFee = liquidityFee;
1138     }
1139 
1140     /// @notice Set the tax rate for the additional tax, which is charged when the token transfer amount is above a certain threshold
1141     function setAdditionalTax(uint256 additionalTax) external onlyOwner {
1142         require (_taxFee + _liquidityFee + additionalTax <=25, "25 is Max Tax Threshold");
1143         _additionalTax = additionalTax;
1144     }
1145 
1146     /// @notice Set the token amount, above which the _additionalTax will be charged on transfers
1147     function setAdditionalTaxThreshold(uint256 additionalTaxThreshold)
1148         external
1149         onlyOwner
1150     {
1151         _additionalTaxThreshold = additionalTaxThreshold;
1152     }
1153 
1154     /// @notice Set the max transaction amount, in basis points relative to the total supply, above which token transfers will be rejected
1155     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner {
1156         uint newMaxTxAmount = _tTotal.mul(maxTxPercent).div(10000);
1157         require(newMaxTxAmount > _tTotal.mul(5).div(10000), "MaxTxAmount Tow Low");
1158         _maxTxAmount = newMaxTxAmount;
1159     }
1160 
1161     /// @notice Enable or disable the process of providing liquidity with the tokens collected by the liquidity tax
1162     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1163         swapAndLiquifyEnabled = _enabled;
1164         emit SwapAndLiquifyEnabledUpdated(_enabled);
1165     }
1166 
1167     /// @notice Enable or disable the process of converting the tokens collected by the Dev tax and sending it to the Dev wallet
1168     function setSwapAndSendDevEnabled(bool _enabled) public onlyOwner {
1169         swapAndSendDevEnabled = _enabled;
1170         emit SwapAndSendDevEnabledUpdated(_enabled);
1171     }
1172 
1173     /// @notice To receive ETH from uniswapV2Router when swapping
1174     receive() external payable {}
1175 
1176     /// @notice Calculates tax values
1177     /// @param tAmount Amount to transfer before taxes
1178     /// @param from address to transfer from
1179     /// @return tTransferAmount total token amount to transfer after subtracting the tax fees
1180     /// @return tFee total amount that goes towards the Devs
1181     /// @return tLiquidity total ammount that goes towards providing liquidity
1182     function _getTValues(uint256 tAmount, address from)
1183         private
1184         view
1185         returns (
1186             uint256,
1187             uint256,
1188             uint256
1189         )
1190     {
1191         uint256 tFee = calculateTaxFee(tAmount, from); 
1192         uint256 tLiquidity = calculateLiquidityFee(tAmount); 
1193         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity); 
1194         return (tTransferAmount, tFee, tLiquidity);
1195     }
1196 
1197     /// @notice Calculates Dev tax amount
1198     /// @param _amount Amount to transfer before taxes
1199     /// @param _from address to transfer from
1200     function calculateTaxFee(uint256 _amount, address _from)
1201         private
1202         view
1203         returns (uint256)
1204     {
1205         if (_amount > _additionalTaxThreshold && _from != uniswapV2Pair) {
1206             // additional tax on SELL orders if amount is > threshold
1207             uint256 higherTax = _taxFee.add(_additionalTax);
1208             return _amount.mul(higherTax).div(10**2);
1209         } else {
1210             return _amount.mul(_taxFee).div(10**2);
1211         }
1212     }
1213 
1214     /// @notice Calculates liquidity tax amount
1215     /// @param _amount Amount to transfer before taxes
1216     function calculateLiquidityFee(uint256 _amount)
1217         private
1218         view
1219         returns (uint256)
1220     {
1221         return _amount.mul(_liquidityFee).div(10**2);
1222     }
1223 
1224     /// @notice Checks if an address is excluded from being taxed on token transfers
1225     /// @param account Account to check
1226     function isExcludedFromFee(address account) public view returns (bool) {
1227         return _isExcludedFromFee[account];
1228     }
1229 
1230     /// @notice Sets the amount of tokens an address can transfer on behalf of another address
1231     /// @param owner address that owns the tokens
1232     /// @param spender address that is allowed to transfer tokens on behalf of owner
1233     /// @param amount amount of tokens that spender is allowed to transfer
1234     function _approve(
1235         address owner,
1236         address spender,
1237         uint256 amount
1238     ) private {
1239         require(owner != address(0), "ERC20: approve from the zero address");
1240         require(spender != address(0), "ERC20: approve to the zero address");
1241 
1242         _allowances[owner][spender] = amount;
1243         emit Approval(owner, spender, amount);
1244     }
1245 
1246     /// @notice Internal token transfer logic that takes care of calculating and collecting taxes
1247     /// @param from address that is sending the tokens
1248     /// @param to address that is receiving the tokens
1249     /// @param amount amount of tokens that is being sent
1250     function _transfer(
1251         address from,
1252         address to,
1253         uint256 amount
1254     ) private {
1255         require(from != address(0), "ERC20: transfer from the zero address");
1256         require(to != address(0), "ERC20: transfer to the zero address");
1257         require(amount > 0, "Transfer amount must be greater than zero");
1258         if (from != owner() && to != owner())
1259             require(
1260                 amount <= _maxTxAmount,
1261                 "Transfer amount exceeds the maxTxAmount."
1262             );
1263 
1264         (
1265             uint256 tTransferAmount,
1266             uint256 tFee,
1267             uint256 tLiquidity
1268         ) = _getTValues(amount, from);
1269 
1270         //add the liquidity fee into the balance of this contract address, b/c will need to use to swap later
1271         _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity); 
1272         taxYetToBeLiquified = taxYetToBeLiquified.add(tLiquidity);
1273 
1274         if (taxYetToBeLiquified >= numTokensSellToAddToLiquidity) {
1275             // only liquify if above a certain threshold
1276             // also, don't get caught in a circular liquidity event.
1277             // also, don't swap & liquify if sender is uniswap pair.
1278             if (
1279                 !inSwapAndLiquify &&
1280                 from != uniswapV2Pair &&
1281                 swapAndLiquifyEnabled
1282             ) {
1283                 //add liquidity
1284                 swapAndLiquify(taxYetToBeLiquified);
1285                 taxYetToBeLiquified = 0;
1286             }
1287         }
1288 
1289         //add the dev fee into the balance of this contract address, b/c will need to use to swap later
1290         _tOwned[address(this)] = _tOwned[address(this)].add(tFee); 
1291         taxYetToBeSentToDev = taxYetToBeSentToDev.add(tFee);
1292 
1293         if (
1294             taxYetToBeSentToDev >= minimumDevTaxDistributionThreshold
1295         ) {
1296             if (
1297                 !inSwapAndSendDev &&
1298                 from != uniswapV2Pair &&
1299                 swapAndSendDevEnabled
1300             ) {
1301                 //convert to ETH and send to Dev
1302                 swapAndSendToDev(taxYetToBeSentToDev);
1303                 taxYetToBeSentToDev = 0;
1304             }
1305         }
1306 
1307         _tOwned[from] = _tOwned[from].sub(amount);
1308         _tOwned[to] = _tOwned[to].add(tTransferAmount);
1309         emit Transfer(from, to, tTransferAmount);
1310     }
1311 
1312     /// @notice Converts tokens into ETH and sends to Dev wallet
1313     /// @param tokenAmount amount of tokens to convert to ETH
1314     function swapAndSendToDev(uint256 tokenAmount) private lockSendDev {
1315         uint256 initialBalance = address(this).balance;
1316         swapTokensForEth(tokenAmount);
1317         uint256 newBalance = address(this).balance.sub(initialBalance);
1318         bool sent = payable(devFeeWallet).send(newBalance);
1319         require(sent, "ETH transfer failed");
1320     }
1321 
1322     /// @notice Uses tokens to provide liquidty by first selling half to obtain ETH
1323     /// @param _numTokensSellToAddToLiquidity amount of tokens to use to provide liquidity
1324     function swapAndLiquify(uint256 _numTokensSellToAddToLiquidity)
1325         private
1326         lockTheSwap
1327     {
1328         // split the contract balance into halves
1329         uint256 half = _numTokensSellToAddToLiquidity.div(2);
1330         uint256 otherHalf = _numTokensSellToAddToLiquidity.sub(half);
1331 
1332         // capture the contract's current ETH balance.
1333         // this is so that we can capture exactly the amount of ETH that the
1334         // swap creates, and not make the liquidity event include any ETH that
1335         // has been manually sent to the contract
1336         uint256 initialBalance = address(this).balance;
1337 
1338         // swap tokens for ETH
1339         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1340 
1341         // how much ETH did we just swap into?
1342         uint256 newBalance = address(this).balance.sub(initialBalance);
1343 
1344         // add liquidity to uniswap
1345         addLiquidity(otherHalf, newBalance);
1346 
1347         emit SwapAndLiquify(half, newBalance, otherHalf);
1348     }
1349 
1350     /// @notice Converts tokens to ETH via the DEX router
1351     /// @param tokenAmount amount of tokens to convert into ETH
1352     function swapTokensForEth(uint256 tokenAmount) private {
1353         // generate the uniswap pair path of token -> weth
1354         address[] memory path = new address[](2);
1355         path[0] = address(this);
1356         path[1] = uniswapV2Router.WETH();
1357 
1358         _approve(address(this), address(uniswapV2Router), tokenAmount);
1359 
1360         // make the swap
1361         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1362             tokenAmount,
1363             0, // accept any amount of ETH
1364             path,
1365             address(this),
1366             block.timestamp
1367         );
1368     }
1369 
1370     /// @notice Add liquidity for the token via the DEX router
1371     /// @param tokenAmount amount of tokens to use to provide liquidity
1372     /// @param ethAmount amount of tokens to use to provide liquidity
1373     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1374         // approve token transfer to cover all possible scenarios
1375         _approve(address(this), address(uniswapV2Router), tokenAmount);
1376 
1377         // add the liquidity
1378         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1379             address(this),
1380             tokenAmount,
1381             0, // slippage is unavoidable
1382             0, // slippage is unavoidable
1383             owner(),
1384             block.timestamp
1385         );
1386     }
1387 
1388     /// @notice Sets the address that the Dev tax is sent to
1389     function setDevWallet(address _devWallet) external onlyOwner {
1390         devFeeWallet = _devWallet;
1391     }
1392 
1393     /// @notice Sets whether token transfers associated with trades on a DEX (Uniswap) are taxed
1394     function setTaxOnlyDex(bool _taxOnlyDex) external onlyOwner {
1395         taxOnlyDex = _taxOnlyDex;
1396     }
1397 }