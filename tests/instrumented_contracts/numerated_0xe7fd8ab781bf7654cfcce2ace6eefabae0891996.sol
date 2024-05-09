1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.6.12;
4 
5 interface IERC20 {
6     function totalSupply() external view returns (uint256);
7 
8     /**
9      * @dev Returns the amount of tokens owned by `account`.
10      */
11     function balanceOf(address account) external view returns (uint256);
12 
13     /**
14      * @dev Moves `amount` tokens from the caller's account to `recipient`.
15      *
16      * Returns a boolean value indicating whether the operation succeeded.
17      *
18      * Emits a {Transfer} event.
19      */
20     function transfer(address recipient, uint256 amount)
21         external
22         returns (bool);
23 
24     /**
25      * @dev Returns the remaining number of tokens that `spender` will be
26      * allowed to spend on behalf of `owner` through {transferFrom}. This is
27      * zero by default.
28      *
29      * This value changes when {approve} or {transferFrom} are called.
30      */
31     function allowance(address owner, address spender)
32         external
33         view
34         returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * IMPORTANT: Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an {Approval} event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transferFrom(
62         address sender,
63         address recipient,
64         uint256 amount
65     ) external returns (bool);
66 
67     /**
68      * @dev Emitted when `value` tokens are moved from one account (`from`) to
69      * another (`to`).
70      *
71      * Note that `value` may be zero.
72      */
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     /**
76      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
77      * a call to {approve}. `value` is the new allowance.
78      */
79     event Approval(
80         address indexed owner,
81         address indexed spender,
82         uint256 value
83     );
84 }
85 
86 /**
87  * @dev Wrappers over Solidity's arithmetic operations with added overflow
88  * checks.
89  *
90  * Arithmetic operations in Solidity wrap on overflow. This can easily result
91  * in bugs, because programmers usually assume that an overflow raises an
92  * error, which is the standard behavior in high level programming languages.
93  * `SafeMath` restores this intuition by reverting the transaction when an
94  * operation overflows.
95  *
96  * Using this library instead of the unchecked operations eliminates an entire
97  * class of bugs, so it's recommended to use it always.
98  */
99 
100 library SafeMath {
101     /**
102      * @dev Returns the addition of two unsigned integers, reverting on
103      * overflow.
104      *
105      * Counterpart to Solidity's `+` operator.
106      *
107      * Requirements:
108      *
109      * - Addition cannot overflow.
110      */
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         uint256 c = a + b;
113         require(c >= a, "SafeMath: addition overflow");
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the subtraction of two unsigned integers, reverting on
120      * overflow (when the result is negative).
121      *
122      * Counterpart to Solidity's `-` operator.
123      *
124      * Requirements:
125      *
126      * - Subtraction cannot overflow.
127      */
128     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129         return sub(a, b, "SafeMath: subtraction overflow");
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
134      * overflow (when the result is negative).
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      *
140      * - Subtraction cannot overflow.
141      */
142     function sub(
143         uint256 a,
144         uint256 b,
145         string memory errorMessage
146     ) internal pure returns (uint256) {
147         require(b <= a, errorMessage);
148         uint256 c = a - b;
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the multiplication of two unsigned integers, reverting on
155      * overflow.
156      *
157      * Counterpart to Solidity's `*` operator.
158      *
159      * Requirements:
160      *
161      * - Multiplication cannot overflow.
162      */
163     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
164         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
165         // benefit is lost if 'b' is also tested.
166         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
167         if (a == 0) {
168             return 0;
169         }
170 
171         uint256 c = a * b;
172         require(c / a == b, "SafeMath: multiplication overflow");
173 
174         return c;
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers. Reverts on
179      * division by zero. The result is rounded towards zero.
180      *
181      * Counterpart to Solidity's `/` operator. Note: this function uses a
182      * `revert` opcode (which leaves remaining gas untouched) while Solidity
183      * uses an invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      *
187      * - The divisor cannot be zero.
188      */
189     function div(uint256 a, uint256 b) internal pure returns (uint256) {
190         return div(a, b, "SafeMath: division by zero");
191     }
192 
193     /**
194      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
195      * division by zero. The result is rounded towards zero.
196      *
197      * Counterpart to Solidity's `/` operator. Note: this function uses a
198      * `revert` opcode (which leaves remaining gas untouched) while Solidity
199      * uses an invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      *
203      * - The divisor cannot be zero.
204      */
205     function div(
206         uint256 a,
207         uint256 b,
208         string memory errorMessage
209     ) internal pure returns (uint256) {
210         require(b > 0, errorMessage);
211         uint256 c = a / b;
212         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
213 
214         return c;
215     }
216 
217     /**
218      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219      * Reverts when dividing by zero.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
230         return mod(a, b, "SafeMath: modulo by zero");
231     }
232 
233     /**
234      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
235      * Reverts with custom message when dividing by zero.
236      *
237      * Counterpart to Solidity's `%` operator. This function uses a `revert`
238      * opcode (which leaves remaining gas untouched) while Solidity uses an
239      * invalid opcode to revert (consuming all remaining gas).
240      *
241      * Requirements:
242      *
243      * - The divisor cannot be zero.
244      */
245     function mod(
246         uint256 a,
247         uint256 b,
248         string memory errorMessage
249     ) internal pure returns (uint256) {
250         require(b != 0, errorMessage);
251         return a % b;
252     }
253 }
254 
255 abstract contract Context {
256     function _msgSender() internal view virtual returns (address payable) {
257         return msg.sender;
258     }
259 
260     function _msgData() internal view virtual returns (bytes memory) {
261         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
262         return msg.data;
263     }
264 }
265 
266 /**
267  * @dev Collection of functions related to the address type
268  */
269 library Address {
270     /**
271      * @dev Returns true if `account` is a contract.
272      *
273      * [IMPORTANT]
274      * ====
275      * It is unsafe to assume that an address for which this function returns
276      * false is an externally-owned account (EOA) and not a contract.
277      *
278      * Among others, `isContract` will return false for the following
279      * types of addresses:
280      *
281      *  - an externally-owned account
282      *  - a contract in construction
283      *  - an address where a contract will be created
284      *  - an address where a contract lived, but was destroyed
285      * ====
286      */
287     function isContract(address account) internal view returns (bool) {
288         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
289         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
290         // for accounts without code, i.e. `keccak256('')`
291         bytes32 codehash;
292         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
293         // solhint-disable-next-line no-inline-assembly
294         assembly {
295             codehash := extcodehash(account)
296         }
297         return (codehash != accountHash && codehash != 0x0);
298     }
299 
300     /**
301      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
302      * `recipient`, forwarding all available gas and reverting on errors.
303      *
304      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
305      * of certain opcodes, possibly making contracts go over the 2300 gas limit
306      * imposed by `transfer`, making them unable to receive funds via
307      * `transfer`. {sendValue} removes this limitation.
308      *
309      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
310      *
311      * IMPORTANT: because control is transferred to `recipient`, care must be
312      * taken to not create reentrancy vulnerabilities. Consider using
313      * {ReentrancyGuard} or the
314      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
315      */
316     function sendValue(address payable recipient, uint256 amount) internal {
317         require(
318             address(this).balance >= amount,
319             "Address: insufficient balance"
320         );
321 
322         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
323         (bool success, ) = recipient.call{value: amount}("");
324         require(
325             success,
326             "Address: unable to send value, recipient may have reverted"
327         );
328     }
329 
330     /**
331      * @dev Performs a Solidity function call using a low level `call`. A
332      * plain`call` is an unsafe replacement for a function call: use this
333      * function instead.
334      *
335      * If `target` reverts with a revert reason, it is bubbled up by this
336      * function (like regular Solidity function calls).
337      *
338      * Returns the raw returned data. To convert to the expected return value,
339      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
340      *
341      * Requirements:
342      *
343      * - `target` must be a contract.
344      * - calling `target` with `data` must not revert.
345      *
346      * _Available since v3.1._
347      */
348     function functionCall(address target, bytes memory data)
349         internal
350         returns (bytes memory)
351     {
352         return functionCall(target, data, "Address: low-level call failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
357      * `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCall(
362         address target,
363         bytes memory data,
364         string memory errorMessage
365     ) internal returns (bytes memory) {
366         return _functionCallWithValue(target, data, 0, errorMessage);
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
371      * but also transferring `value` wei to `target`.
372      *
373      * Requirements:
374      *
375      * - the calling contract must have an ETH balance of at least `value`.
376      * - the called Solidity function must be `payable`.
377      *
378      * _Available since v3.1._
379      */
380     function functionCallWithValue(
381         address target,
382         bytes memory data,
383         uint256 value
384     ) internal returns (bytes memory) {
385         return
386             functionCallWithValue(
387                 target,
388                 data,
389                 value,
390                 "Address: low-level call with value failed"
391             );
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
396      * with `errorMessage` as a fallback revert reason when `target` reverts.
397      *
398      * _Available since v3.1._
399      */
400     function functionCallWithValue(
401         address target,
402         bytes memory data,
403         uint256 value,
404         string memory errorMessage
405     ) internal returns (bytes memory) {
406         require(
407             address(this).balance >= value,
408             "Address: insufficient balance for call"
409         );
410         return _functionCallWithValue(target, data, value, errorMessage);
411     }
412 
413     function _functionCallWithValue(
414         address target,
415         bytes memory data,
416         uint256 weiValue,
417         string memory errorMessage
418     ) private returns (bytes memory) {
419         require(isContract(target), "Address: call to non-contract");
420 
421         // solhint-disable-next-line avoid-low-level-calls
422         (bool success, bytes memory returndata) = target.call{value: weiValue}(
423             data
424         );
425         if (success) {
426             return returndata;
427         } else {
428             // Look for revert reason and bubble it up if present
429             if (returndata.length > 0) {
430                 // The easiest way to bubble the revert reason is using memory via assembly
431 
432                 // solhint-disable-next-line no-inline-assembly
433                 assembly {
434                     let returndata_size := mload(returndata)
435                     revert(add(32, returndata), returndata_size)
436                 }
437             } else {
438                 revert(errorMessage);
439             }
440         }
441     }
442 }
443 
444 /**
445  * @dev Contract module which provides a basic access control mechanism, where
446  * there is an account (an owner) that can be granted exclusive access to
447  * specific functions.
448  *
449  * By default, the owner account will be the one that deploys the contract. This
450  * can later be changed with {transferOwnership}.
451  *
452  * This module is used through inheritance. It will make available the modifier
453  * `onlyOwner`, which can be applied to your functions to restrict their use to
454  * the owner.
455  */
456 contract Ownable is Context {
457     address private _owner;
458     address private _previousOwner;
459     uint256 private _lockTime;
460 
461     event OwnershipTransferred(
462         address indexed previousOwner,
463         address indexed newOwner
464     );
465 
466     /**
467      * @dev Initializes the contract setting the deployer as the initial owner.
468      */
469     constructor() internal {
470         address msgSender = _msgSender();
471         _owner = msgSender;
472         emit OwnershipTransferred(address(0), msgSender);
473     }
474 
475     /**
476      * @dev Returns the address of the current owner.
477      */
478     function owner() public view returns (address) {
479         return _owner;
480     }
481 
482     /**
483      * @dev Throws if called by any account other than the owner.
484      */
485     modifier onlyOwner() {
486         require(_owner == _msgSender(), "Ownable: caller is not the owner");
487         _;
488     }
489 
490     /**
491      * @dev Leaves the contract without owner. It will not be possible to call
492      * `onlyOwner` functions anymore. Can only be called by the current owner.
493      *
494      * NOTE: Renouncing ownership will leave the contract without an owner,
495      * thereby removing any functionality that is only available to the owner.
496      */
497     function renounceOwnership() public virtual onlyOwner {
498         emit OwnershipTransferred(_owner, address(0));
499         _owner = address(0);
500     }
501 
502     /**
503      * @dev Transfers ownership of the contract to a new account (`newOwner`).
504      * Can only be called by the current owner.
505      */
506     function transferOwnership(address newOwner) public virtual onlyOwner {
507         require(
508             newOwner != address(0),
509             "Ownable: new owner is the zero address"
510         );
511         emit OwnershipTransferred(_owner, newOwner);
512         _owner = newOwner;
513     }
514 
515     function geUnlockTime() public view returns (uint256) {
516         return _lockTime;
517     }
518 
519     //Locks the contract for owner for the amount of time provided
520     function lock(uint256 time) public virtual onlyOwner {
521         _previousOwner = _owner;
522         _owner = address(0);
523         _lockTime = now + time;
524         emit OwnershipTransferred(_owner, address(0));
525     }
526 
527     //Unlocks the contract for owner when _lockTime is exceeds
528     function unlock() public virtual {
529         require(
530             _previousOwner == msg.sender,
531             "You don't have permission to unlock"
532         );
533         require(now > _lockTime, "Contract is locked until 7 days");
534         emit OwnershipTransferred(_owner, _previousOwner);
535         _owner = _previousOwner;
536     }
537 }
538 
539 // pragma solidity >=0.5.0;
540 
541 interface IUniswapV2Factory {
542     event PairCreated(
543         address indexed token0,
544         address indexed token1,
545         address pair,
546         uint256
547     );
548 
549     function feeTo() external view returns (address);
550 
551     function feeToSetter() external view returns (address);
552 
553     function getPair(address tokenA, address tokenB)
554         external
555         view
556         returns (address pair);
557 
558     function allPairs(uint256) external view returns (address pair);
559 
560     function allPairsLength() external view returns (uint256);
561 
562     function createPair(address tokenA, address tokenB)
563         external
564         returns (address pair);
565 
566     function setFeeTo(address) external;
567 
568     function setFeeToSetter(address) external;
569 }
570 
571 // pragma solidity >=0.5.0;
572 
573 interface IUniswapV2Pair {
574     event Approval(
575         address indexed owner,
576         address indexed spender,
577         uint256 value
578     );
579     event Transfer(address indexed from, address indexed to, uint256 value);
580 
581     function name() external pure returns (string memory);
582 
583     function symbol() external pure returns (string memory);
584 
585     function decimals() external pure returns (uint8);
586 
587     function totalSupply() external view returns (uint256);
588 
589     function balanceOf(address owner) external view returns (uint256);
590 
591     function allowance(address owner, address spender)
592         external
593         view
594         returns (uint256);
595 
596     function approve(address spender, uint256 value) external returns (bool);
597 
598     function transfer(address to, uint256 value) external returns (bool);
599 
600     function transferFrom(
601         address from,
602         address to,
603         uint256 value
604     ) external returns (bool);
605 
606     function DOMAIN_SEPARATOR() external view returns (bytes32);
607 
608     function PERMIT_TYPEHASH() external pure returns (bytes32);
609 
610     function nonces(address owner) external view returns (uint256);
611 
612     function permit(
613         address owner,
614         address spender,
615         uint256 value,
616         uint256 deadline,
617         uint8 v,
618         bytes32 r,
619         bytes32 s
620     ) external;
621 
622     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
623     event Burn(
624         address indexed sender,
625         uint256 amount0,
626         uint256 amount1,
627         address indexed to
628     );
629     event Swap(
630         address indexed sender,
631         uint256 amount0In,
632         uint256 amount1In,
633         uint256 amount0Out,
634         uint256 amount1Out,
635         address indexed to
636     );
637     event Sync(uint112 reserve0, uint112 reserve1);
638 
639     function MINIMUM_LIQUIDITY() external pure returns (uint256);
640 
641     function factory() external view returns (address);
642 
643     function token0() external view returns (address);
644 
645     function token1() external view returns (address);
646 
647     function getReserves()
648         external
649         view
650         returns (
651             uint112 reserve0,
652             uint112 reserve1,
653             uint32 blockTimestampLast
654         );
655 
656     function price0CumulativeLast() external view returns (uint256);
657 
658     function price1CumulativeLast() external view returns (uint256);
659 
660     function kLast() external view returns (uint256);
661 
662     function mint(address to) external returns (uint256 liquidity);
663 
664     function burn(address to)
665         external
666         returns (uint256 amount0, uint256 amount1);
667 
668     function swap(
669         uint256 amount0Out,
670         uint256 amount1Out,
671         address to,
672         bytes calldata data
673     ) external;
674 
675     function skim(address to) external;
676 
677     function sync() external;
678 
679     function initialize(address, address) external;
680 }
681 
682 // pragma solidity >=0.6.2;
683 
684 interface IUniswapV2Router01 {
685     function factory() external pure returns (address);
686 
687     function WETH() external pure returns (address);
688 
689     function addLiquidity(
690         address tokenA,
691         address tokenB,
692         uint256 amountADesired,
693         uint256 amountBDesired,
694         uint256 amountAMin,
695         uint256 amountBMin,
696         address to,
697         uint256 deadline
698     )
699         external
700         returns (
701             uint256 amountA,
702             uint256 amountB,
703             uint256 liquidity
704         );
705 
706     function addLiquidityETH(
707         address token,
708         uint256 amountTokenDesired,
709         uint256 amountTokenMin,
710         uint256 amountETHMin,
711         address to,
712         uint256 deadline
713     )
714         external
715         payable
716         returns (
717             uint256 amountToken,
718             uint256 amountETH,
719             uint256 liquidity
720         );
721 
722     function removeLiquidity(
723         address tokenA,
724         address tokenB,
725         uint256 liquidity,
726         uint256 amountAMin,
727         uint256 amountBMin,
728         address to,
729         uint256 deadline
730     ) external returns (uint256 amountA, uint256 amountB);
731 
732     function removeLiquidityETH(
733         address token,
734         uint256 liquidity,
735         uint256 amountTokenMin,
736         uint256 amountETHMin,
737         address to,
738         uint256 deadline
739     ) external returns (uint256 amountToken, uint256 amountETH);
740 
741     function removeLiquidityWithPermit(
742         address tokenA,
743         address tokenB,
744         uint256 liquidity,
745         uint256 amountAMin,
746         uint256 amountBMin,
747         address to,
748         uint256 deadline,
749         bool approveMax,
750         uint8 v,
751         bytes32 r,
752         bytes32 s
753     ) external returns (uint256 amountA, uint256 amountB);
754 
755     function removeLiquidityETHWithPermit(
756         address token,
757         uint256 liquidity,
758         uint256 amountTokenMin,
759         uint256 amountETHMin,
760         address to,
761         uint256 deadline,
762         bool approveMax,
763         uint8 v,
764         bytes32 r,
765         bytes32 s
766     ) external returns (uint256 amountToken, uint256 amountETH);
767 
768     function swapExactTokensForTokens(
769         uint256 amountIn,
770         uint256 amountOutMin,
771         address[] calldata path,
772         address to,
773         uint256 deadline
774     ) external returns (uint256[] memory amounts);
775 
776     function swapTokensForExactTokens(
777         uint256 amountOut,
778         uint256 amountInMax,
779         address[] calldata path,
780         address to,
781         uint256 deadline
782     ) external returns (uint256[] memory amounts);
783 
784     function swapExactETHForTokens(
785         uint256 amountOutMin,
786         address[] calldata path,
787         address to,
788         uint256 deadline
789     ) external payable returns (uint256[] memory amounts);
790 
791     function swapTokensForExactETH(
792         uint256 amountOut,
793         uint256 amountInMax,
794         address[] calldata path,
795         address to,
796         uint256 deadline
797     ) external returns (uint256[] memory amounts);
798 
799     function swapExactTokensForETH(
800         uint256 amountIn,
801         uint256 amountOutMin,
802         address[] calldata path,
803         address to,
804         uint256 deadline
805     ) external returns (uint256[] memory amounts);
806 
807     function swapETHForExactTokens(
808         uint256 amountOut,
809         address[] calldata path,
810         address to,
811         uint256 deadline
812     ) external payable returns (uint256[] memory amounts);
813 
814     function quote(
815         uint256 amountA,
816         uint256 reserveA,
817         uint256 reserveB
818     ) external pure returns (uint256 amountB);
819 
820     function getAmountOut(
821         uint256 amountIn,
822         uint256 reserveIn,
823         uint256 reserveOut
824     ) external pure returns (uint256 amountOut);
825 
826     function getAmountIn(
827         uint256 amountOut,
828         uint256 reserveIn,
829         uint256 reserveOut
830     ) external pure returns (uint256 amountIn);
831 
832     function getAmountsOut(uint256 amountIn, address[] calldata path)
833         external
834         view
835         returns (uint256[] memory amounts);
836 
837     function getAmountsIn(uint256 amountOut, address[] calldata path)
838         external
839         view
840         returns (uint256[] memory amounts);
841 }
842 
843 // pragma solidity >=0.6.2;
844 
845 interface IUniswapV2Router02 is IUniswapV2Router01 {
846     function removeLiquidityETHSupportingFeeOnTransferTokens(
847         address token,
848         uint256 liquidity,
849         uint256 amountTokenMin,
850         uint256 amountETHMin,
851         address to,
852         uint256 deadline
853     ) external returns (uint256 amountETH);
854 
855     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
856         address token,
857         uint256 liquidity,
858         uint256 amountTokenMin,
859         uint256 amountETHMin,
860         address to,
861         uint256 deadline,
862         bool approveMax,
863         uint8 v,
864         bytes32 r,
865         bytes32 s
866     ) external returns (uint256 amountETH);
867 
868     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
869         uint256 amountIn,
870         uint256 amountOutMin,
871         address[] calldata path,
872         address to,
873         uint256 deadline
874     ) external;
875 
876     function swapExactETHForTokensSupportingFeeOnTransferTokens(
877         uint256 amountOutMin,
878         address[] calldata path,
879         address to,
880         uint256 deadline
881     ) external payable;
882 
883     function swapExactTokensForETHSupportingFeeOnTransferTokens(
884         uint256 amountIn,
885         uint256 amountOutMin,
886         address[] calldata path,
887         address to,
888         uint256 deadline
889     ) external;
890 }
891 
892 contract VIBE is Context, IERC20, Ownable {
893     using SafeMath for uint256;
894     using Address for address;
895 
896     mapping(address => uint256) private _rOwned;
897     mapping(address => uint256) private _tOwned;
898     mapping(address => mapping(address => uint256)) private _allowances;
899 
900     mapping(address => bool) private _isExcludedFromFee;
901 
902     mapping(address => bool) private _isExcluded;
903     address[] private _excluded;
904 
905     uint256 private constant MAX = ~uint256(0);
906     uint256 private _tTotal = 100000000000 * 10**1 * 10**9;
907     uint256 private _rTotal = (MAX - (MAX % _tTotal));
908     uint256 private _tFeeTotal;
909 
910     string private _name = "vibe";
911     string private _symbol = "vibe";
912     uint8 private _decimals = 9;
913 
914     uint256 public _taxFee = 2;
915     uint256 private _previousTaxFee = _taxFee;
916 
917     uint256 public _liquidityFee = 8;
918     uint256 private _previousLiquidityFee = _liquidityFee;
919 
920     IUniswapV2Router02 public immutable uniswapV2Router;
921     address public immutable uniswapV2Pair;
922     address payable public _daoWalletAddress;
923 
924     bool inSwapAndLiquify;
925     bool public swapAndLiquifyEnabled = true;
926 
927     uint256 public _maxTxAmount = 1000000000 * 10**1 * 10**9;
928     uint256 private numTokensSellToAddToLiquidity = 300000000 * 10**1 * 10**9;
929 
930     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
931     event SwapAndLiquifyEnabledUpdated(bool enabled);
932     event SwapAndLiquify(
933         uint256 tokensSwapped,
934         uint256 ethReceived,
935         uint256 tokensIntoLiqudity
936     );
937 
938     modifier lockTheSwap() {
939         inSwapAndLiquify = true;
940         _;
941         inSwapAndLiquify = false;
942     }
943 
944     constructor(address payable daoWalletAddress) public {
945         _daoWalletAddress = daoWalletAddress;
946         _rOwned[_msgSender()] = _rTotal;
947 
948         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
949             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
950         );
951         // Create a uniswap pair for this new token
952         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
953             .createPair(address(this), _uniswapV2Router.WETH());
954 
955         // set the rest of the contract variables
956         uniswapV2Router = _uniswapV2Router;
957 
958         //exclude owner and this contract from fee
959         _isExcludedFromFee[owner()] = true;
960         _isExcludedFromFee[address(this)] = true;
961 
962         emit Transfer(address(0), _msgSender(), _tTotal);
963     }
964 
965     function name() public view returns (string memory) {
966         return _name;
967     }
968 
969     function symbol() public view returns (string memory) {
970         return _symbol;
971     }
972 
973     function decimals() public view returns (uint8) {
974         return _decimals;
975     }
976 
977     function totalSupply() public view override returns (uint256) {
978         return _tTotal;
979     }
980 
981     function balanceOf(address account) public view override returns (uint256) {
982         if (_isExcluded[account]) return _tOwned[account];
983         return tokenFromReflection(_rOwned[account]);
984     }
985 
986     function transfer(address recipient, uint256 amount)
987         public
988         override
989         returns (bool)
990     {
991         _transfer(_msgSender(), recipient, amount);
992         return true;
993     }
994 
995     function allowance(address owner, address spender)
996         public
997         view
998         override
999         returns (uint256)
1000     {
1001         return _allowances[owner][spender];
1002     }
1003 
1004     function approve(address spender, uint256 amount)
1005         public
1006         override
1007         returns (bool)
1008     {
1009         _approve(_msgSender(), spender, amount);
1010         return true;
1011     }
1012 
1013     function transferFrom(
1014         address sender,
1015         address recipient,
1016         uint256 amount
1017     ) public override returns (bool) {
1018         _transfer(sender, recipient, amount);
1019         _approve(
1020             sender,
1021             _msgSender(),
1022             _allowances[sender][_msgSender()].sub(
1023                 amount,
1024                 "ERC20: transfer amount exceeds allowance"
1025             )
1026         );
1027         return true;
1028     }
1029 
1030     function increaseAllowance(address spender, uint256 addedValue)
1031         public
1032         virtual
1033         returns (bool)
1034     {
1035         _approve(
1036             _msgSender(),
1037             spender,
1038             _allowances[_msgSender()][spender].add(addedValue)
1039         );
1040         return true;
1041     }
1042 
1043     function decreaseAllowance(address spender, uint256 subtractedValue)
1044         public
1045         virtual
1046         returns (bool)
1047     {
1048         _approve(
1049             _msgSender(),
1050             spender,
1051             _allowances[_msgSender()][spender].sub(
1052                 subtractedValue,
1053                 "ERC20: decreased allowance below zero"
1054             )
1055         );
1056         return true;
1057     }
1058 
1059     function isExcludedFromReward(address account) public view returns (bool) {
1060         return _isExcluded[account];
1061     }
1062 
1063     function totalFees() public view returns (uint256) {
1064         return _tFeeTotal;
1065     }
1066 
1067     function deliver(uint256 tAmount) public {
1068         address sender = _msgSender();
1069         require(
1070             !_isExcluded[sender],
1071             "Excluded addresses cannot call this function"
1072         );
1073         (uint256 rAmount, , , , , ) = _getValues(tAmount);
1074         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1075         _rTotal = _rTotal.sub(rAmount);
1076         _tFeeTotal = _tFeeTotal.add(tAmount);
1077     }
1078 
1079     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
1080         public
1081         view
1082         returns (uint256)
1083     {
1084         require(tAmount <= _tTotal, "Amount must be less than supply");
1085         if (!deductTransferFee) {
1086             (uint256 rAmount, , , , , ) = _getValues(tAmount);
1087             return rAmount;
1088         } else {
1089             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
1090             return rTransferAmount;
1091         }
1092     }
1093 
1094     function tokenFromReflection(uint256 rAmount)
1095         public
1096         view
1097         returns (uint256)
1098     {
1099         require(
1100             rAmount <= _rTotal,
1101             "Amount must be less than total reflections"
1102         );
1103         uint256 currentRate = _getRate();
1104         return rAmount.div(currentRate);
1105     }
1106 
1107     function excludeFromReward(address account) public onlyOwner {
1108         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
1109         require(!_isExcluded[account], "Account is already excluded");
1110         if (_rOwned[account] > 0) {
1111             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1112         }
1113         _isExcluded[account] = true;
1114         _excluded.push(account);
1115     }
1116 
1117     function includeInReward(address account) external onlyOwner {
1118         require(_isExcluded[account], "Account is already excluded");
1119         for (uint256 i = 0; i < _excluded.length; i++) {
1120             if (_excluded[i] == account) {
1121                 _excluded[i] = _excluded[_excluded.length - 1];
1122                 _tOwned[account] = 0;
1123                 _isExcluded[account] = false;
1124                 _excluded.pop();
1125                 break;
1126             }
1127         }
1128     }
1129 
1130     function _transferBothExcluded(
1131         address sender,
1132         address recipient,
1133         uint256 tAmount
1134     ) private {
1135         (
1136             uint256 rAmount,
1137             uint256 rTransferAmount,
1138             uint256 rFee,
1139             uint256 tTransferAmount,
1140             uint256 tFee,
1141             uint256 tLiquidity
1142         ) = _getValues(tAmount);
1143         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1144         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1145         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1146         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1147         _takeLiquidity(tLiquidity);
1148         _reflectFee(rFee, tFee);
1149         emit Transfer(sender, recipient, tTransferAmount);
1150     }
1151 
1152     function excludeFromFee(address account) public onlyOwner {
1153         _isExcludedFromFee[account] = true;
1154     }
1155 
1156     function includeInFee(address account) public onlyOwner {
1157         _isExcludedFromFee[account] = false;
1158     }
1159 
1160     function setTaxFeePercent(uint256 taxFee) external onlyOwner {
1161         _taxFee = taxFee;
1162     }
1163 
1164     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner {
1165         _liquidityFee = liquidityFee;
1166     }
1167 
1168     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner {
1169         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
1170     }
1171 
1172     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1173         swapAndLiquifyEnabled = _enabled;
1174         emit SwapAndLiquifyEnabledUpdated(_enabled);
1175     }
1176 
1177     //to recieve ETH from uniswapV2Router when swaping
1178     receive() external payable {}
1179 
1180     function _reflectFee(uint256 rFee, uint256 tFee) private {
1181         _rTotal = _rTotal.sub(rFee);
1182         _tFeeTotal = _tFeeTotal.add(tFee);
1183     }
1184 
1185     function _getValues(uint256 tAmount)
1186         private
1187         view
1188         returns (
1189             uint256,
1190             uint256,
1191             uint256,
1192             uint256,
1193             uint256,
1194             uint256
1195         )
1196     {
1197         (
1198             uint256 tTransferAmount,
1199             uint256 tFee,
1200             uint256 tLiquidity
1201         ) = _getTValues(tAmount);
1202         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1203             tAmount,
1204             tFee,
1205             tLiquidity,
1206             _getRate()
1207         );
1208         return (
1209             rAmount,
1210             rTransferAmount,
1211             rFee,
1212             tTransferAmount,
1213             tFee,
1214             tLiquidity
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
1227         uint256 tFee = calculateTaxFee(tAmount);
1228         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1229         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1230         return (tTransferAmount, tFee, tLiquidity);
1231     }
1232 
1233     function _getRValues(
1234         uint256 tAmount,
1235         uint256 tFee,
1236         uint256 tLiquidity,
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
1248         uint256 rFee = tFee.mul(currentRate);
1249         uint256 rLiquidity = tLiquidity.mul(currentRate);
1250         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1251         return (rAmount, rTransferAmount, rFee);
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
1274     function _takeLiquidity(uint256 tLiquidity) private {
1275         uint256 currentRate = _getRate();
1276         uint256 rLiquidity = tLiquidity.mul(currentRate);
1277         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1278         if (_isExcluded[address(this)])
1279             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1280     }
1281 
1282     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1283         return _amount.mul(_taxFee).div(10**2);
1284     }
1285 
1286     function calculateLiquidityFee(uint256 _amount)
1287         private
1288         view
1289         returns (uint256)
1290     {
1291         return _amount.mul(_liquidityFee).div(10**2);
1292     }
1293 
1294     function removeAllFee() private {
1295         if (_taxFee == 0 && _liquidityFee == 0) return;
1296 
1297         _previousTaxFee = _taxFee;
1298         _previousLiquidityFee = _liquidityFee;
1299 
1300         _taxFee = 0;
1301         _liquidityFee = 0;
1302     }
1303 
1304     function restoreAllFee() private {
1305         _taxFee = _previousTaxFee;
1306         _liquidityFee = _previousLiquidityFee;
1307     }
1308 
1309     function isExcludedFromFee(address account) public view returns (bool) {
1310         return _isExcludedFromFee[account];
1311     }
1312 
1313     function sendETHtoDAO(uint256 amount) private {
1314         swapTokensForEth(amount);
1315         _daoWalletAddress.transfer(address(this).balance);
1316     }
1317 
1318     function _setdaoWallet(address payable daoWalletAddress)
1319         external
1320         onlyOwner
1321     {
1322         _daoWalletAddress = daoWalletAddress;
1323     }
1324 
1325     function _approve(
1326         address owner,
1327         address spender,
1328         uint256 amount
1329     ) private {
1330         require(owner != address(0), "ERC20: approve from the zero address");
1331         require(spender != address(0), "ERC20: approve to the zero address");
1332 
1333         _allowances[owner][spender] = amount;
1334         emit Approval(owner, spender, amount);
1335     }
1336 
1337     function _transfer(
1338         address from,
1339         address to,
1340         uint256 amount
1341     ) private {
1342         require(from != address(0), "ERC20: transfer from the zero address");
1343         require(to != address(0), "ERC20: transfer to the zero address");
1344         require(amount > 0, "Transfer amount must be greater than zero");
1345         if (from != owner() && to != owner())
1346             require(
1347                 amount <= _maxTxAmount,
1348                 "Transfer amount exceeds the maxTxAmount."
1349             );
1350 
1351         // is the token balance of this contract address over the min number of
1352         // tokens that we need to initiate a swap + liquidity lock?
1353         // also, don't get caught in a circular liquidity event.
1354         // also, don't swap & liquify if sender is uniswap pair.
1355         uint256 contractTokenBalance = balanceOf(address(this));
1356 
1357         if (contractTokenBalance >= _maxTxAmount) {
1358             contractTokenBalance = _maxTxAmount;
1359         }
1360 
1361         bool overMinTokenBalance = contractTokenBalance >=
1362             numTokensSellToAddToLiquidity;
1363         if (
1364             overMinTokenBalance &&
1365             !inSwapAndLiquify &&
1366             from != uniswapV2Pair &&
1367             swapAndLiquifyEnabled
1368         ) {
1369             contractTokenBalance = numTokensSellToAddToLiquidity;
1370             //add liquidity
1371             swapAndLiquify(contractTokenBalance);
1372         }
1373 
1374         //indicates if fee should be deducted from transfer
1375         bool takeFee = true;
1376 
1377         //if any account belongs to _isExcludedFromFee account then remove the fee
1378         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1379             takeFee = false;
1380         }
1381 
1382         //transfer amount, it will take tax, burn, liquidity fee
1383         _tokenTransfer(from, to, amount, takeFee);
1384     }
1385 
1386     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1387         // split the contract balance into thirds
1388         uint256 halfOfLiquify = contractTokenBalance.div(4);
1389         uint256 otherHalfOfLiquify = contractTokenBalance.div(4);
1390         uint256 portionForFees = contractTokenBalance.sub(halfOfLiquify).sub(
1391             otherHalfOfLiquify
1392         );
1393 
1394         // capture the contract's current ETH balance.
1395         // this is so that we can capture exactly the amount of ETH that the
1396         // swap creates, and not make the liquidity event include any ETH that
1397         // has been manually sent to the contract
1398         uint256 initialBalance = address(this).balance;
1399 
1400         // swap tokens for ETH
1401         swapTokensForEth(halfOfLiquify); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1402 
1403         // how much ETH did we just swap into?
1404         uint256 newBalance = address(this).balance.sub(initialBalance);
1405 
1406         // add liquidity to uniswap
1407         addLiquidity(otherHalfOfLiquify, newBalance);
1408         sendETHtoDAO(portionForFees);
1409 
1410         emit SwapAndLiquify(halfOfLiquify, newBalance, otherHalfOfLiquify);
1411     }
1412 
1413     function swapTokensForEth(uint256 tokenAmount) private {
1414         // generate the uniswap pair path of token -> weth
1415         address[] memory path = new address[](2);
1416         path[0] = address(this);
1417         path[1] = uniswapV2Router.WETH();
1418 
1419         _approve(address(this), address(uniswapV2Router), tokenAmount);
1420 
1421         // make the swap
1422         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1423             tokenAmount,
1424             0, // accept any amount of ETH
1425             path,
1426             address(this),
1427             block.timestamp
1428         );
1429     }
1430 
1431     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1432         // approve token transfer to cover all possible scenarios
1433         _approve(address(this), address(uniswapV2Router), tokenAmount);
1434 
1435         // add the liquidity
1436         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1437             address(this),
1438             tokenAmount,
1439             0, // slippage is unavoidable
1440             0, // slippage is unavoidable
1441             owner(),
1442             block.timestamp
1443         );
1444     }
1445 
1446     //this method is responsible for taking all fee, if takeFee is true
1447     function _tokenTransfer(
1448         address sender,
1449         address recipient,
1450         uint256 amount,
1451         bool takeFee
1452     ) private {
1453         if (!takeFee) removeAllFee();
1454 
1455         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1456             _transferFromExcluded(sender, recipient, amount);
1457         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1458             _transferToExcluded(sender, recipient, amount);
1459         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1460             _transferStandard(sender, recipient, amount);
1461         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1462             _transferBothExcluded(sender, recipient, amount);
1463         } else {
1464             _transferStandard(sender, recipient, amount);
1465         }
1466 
1467         if (!takeFee) restoreAllFee();
1468     }
1469 
1470     function _transferStandard(
1471         address sender,
1472         address recipient,
1473         uint256 tAmount
1474     ) private {
1475         (
1476             uint256 rAmount,
1477             uint256 rTransferAmount,
1478             uint256 rFee,
1479             uint256 tTransferAmount,
1480             uint256 tFee,
1481             uint256 tLiquidity
1482         ) = _getValues(tAmount);
1483         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1484         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1485         _takeLiquidity(tLiquidity);
1486         _reflectFee(rFee, tFee);
1487         emit Transfer(sender, recipient, tTransferAmount);
1488     }
1489 
1490     function _transferToExcluded(
1491         address sender,
1492         address recipient,
1493         uint256 tAmount
1494     ) private {
1495         (
1496             uint256 rAmount,
1497             uint256 rTransferAmount,
1498             uint256 rFee,
1499             uint256 tTransferAmount,
1500             uint256 tFee,
1501             uint256 tLiquidity
1502         ) = _getValues(tAmount);
1503         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1504         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1505         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1506         _takeLiquidity(tLiquidity);
1507         _reflectFee(rFee, tFee);
1508         emit Transfer(sender, recipient, tTransferAmount);
1509     }
1510 
1511     function _transferFromExcluded(
1512         address sender,
1513         address recipient,
1514         uint256 tAmount
1515     ) private {
1516         (
1517             uint256 rAmount,
1518             uint256 rTransferAmount,
1519             uint256 rFee,
1520             uint256 tTransferAmount,
1521             uint256 tFee,
1522             uint256 tLiquidity
1523         ) = _getValues(tAmount);
1524         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1525         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1526         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1527         _takeLiquidity(tLiquidity);
1528         _reflectFee(rFee, tFee);
1529         emit Transfer(sender, recipient, tTransferAmount);
1530     }
1531 }