1 /** 
2 
3 Telegram Portal: https://t.me/ShibVader
4 Website: www.ShibVader.Space
5 
6 */
7 
8 
9 pragma solidity ^0.8.10;
10 
11 // SPDX-License-Identifier: Unlicensed
12 interface IERC20 {
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      *@dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      *@dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount)
28         external
29         returns (bool);
30 
31     /**
32      *@dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender)
39         external
40         view
41         returns (uint256);
42 
43     /**
44      *@dev Sets `amount` as the allowance of `spender` over the caller's tokens.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * IMPORTANT: Beware that changing an allowance with this method brings the risk
49      * that someone may use both the old and the new allowance by unfortunate
50      * transaction ordering. One possible solution to mitigate this race
51      * condition is to first reduce the spender's allowance to 0 and set the
52      * desired value afterwards:
53      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
54      *
55      * Emits an {Approval} event.
56      */
57     function approve(address spender, uint256 amount) external returns (bool);
58 
59     /**
60      *@dev Moves `amount` tokens from `sender` to `recipient` using the
61      * allowance mechanism. `amount` is then deducted from the caller's
62      * allowance.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * Emits a {Transfer} event.
67      */
68     function transferFrom(
69         address sender,
70         address recipient,
71         uint256 amount
72     ) external returns (bool);
73 
74     /**
75      *@dev Emitted when `value` tokens are moved from one account (`from`) to
76      * another (`to`).
77      *
78      * Note that `value` may be zero.
79      */
80     event Transfer(address indexed from, address indexed to, uint256 value);
81 
82     /**
83      *@dev Emitted when the allowance of a `spender` for an `owner` is set by
84      * a call to {approve}. `value` is the new allowance.
85      */
86     event Approval(
87         address indexed owner,
88         address indexed spender,
89         uint256 value
90     );
91 }
92 
93 /**
94  *@dev Wrappers over Solidity's arithmetic operations with added overflow
95  * checks.
96  *
97  * Arithmetic operations in Solidity wrap on overflow. This can easily result
98  * in bugs, because programmers usually assume that an overflow raises an
99  * error, which is the standard behavior in high level programming languages.
100  * `SafeMath` restores this intuition by reverting the transaction when an
101  * operation overflows.
102  *
103  * Using this library instead of the unchecked operations eliminates an entire
104  * class of bugs, so it's recommended to use it always.
105  */
106 
107 library SafeMath {
108     /**
109      *@dev Returns the addition of two unsigned integers, reverting on
110      * overflow.
111      *
112      * Counterpart to Solidity's `+` operator.
113      *
114      * Requirements:
115      *
116      * - Addition cannot overflow.
117      */
118     function add(uint256 a, uint256 b) internal pure returns (uint256) {
119         uint256 c = a + b;
120         require(c >= a, "SafeMath: addition overflow");
121 
122         return c;
123     }
124 
125     /**
126      *@dev Returns the subtraction of two unsigned integers, reverting on
127      * overflow (when the result is negative).
128      *
129      * Counterpart to Solidity's `-` operator.
130      *
131      * Requirements:
132      *
133      * - Subtraction cannot overflow.
134      */
135     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
136         return sub(a, b, "SafeMath: subtraction overflow");
137     }
138 
139     /**
140      *@dev Returns the subtraction of two unsigned integers, reverting with custom message on
141      * overflow (when the result is negative).
142      *
143      * Counterpart to Solidity's `-` operator.
144      *
145      * Requirements:
146      *
147      * - Subtraction cannot overflow.
148      */
149     function sub(
150         uint256 a,
151         uint256 b,
152         string memory errorMessage
153     ) internal pure returns (uint256) {
154         require(b <= a, errorMessage);
155         uint256 c = a - b;
156 
157         return c;
158     }
159 
160     /**
161      *@dev Returns the multiplication of two unsigned integers, reverting on
162      * overflow.
163      *
164      * Counterpart to Solidity's `*` operator.
165      *
166      * Requirements:
167      *
168      * - Multiplication cannot overflow.
169      */
170     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
171         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
172         // benefit is lost if 'b' is also tested.
173         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
174         if (a == 0) {
175             return 0;
176         }
177 
178         uint256 c = a * b;
179         require(c / a == b, "SafeMath: multiplication overflow");
180 
181         return c;
182     }
183 
184     /**
185      *@dev Returns the integer division of two unsigned integers. Reverts on
186      * division by zero. The result is rounded towards zero.
187      *
188      * Counterpart to Solidity's `/` operator. Note: this function uses a
189      * `revert` opcode (which leaves remaining gas untouched) while Solidity
190      * uses an invalid opcode to revert (consuming all remaining gas).
191      *
192      * Requirements:
193      *
194      * - The divisor cannot be zero.
195      */
196     function div(uint256 a, uint256 b) internal pure returns (uint256) {
197         return div(a, b, "SafeMath: division by zero");
198     }
199 
200     /**
201      *@dev Returns the integer division of two unsigned integers. Reverts with custom message on
202      * division by zero. The result is rounded towards zero.
203      *
204      * Counterpart to Solidity's `/` operator. Note: this function uses a
205      * `revert` opcode (which leaves remaining gas untouched) while Solidity
206      * uses an invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function div(
213         uint256 a,
214         uint256 b,
215         string memory errorMessage
216     ) internal pure returns (uint256) {
217         require(b > 0, errorMessage);
218         uint256 c = a / b;
219         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
220 
221         return c;
222     }
223 
224     /**
225      *@dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
226      * Reverts when dividing by zero.
227      *
228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
237         return mod(a, b, "SafeMath: modulo by zero");
238     }
239 
240     /**
241      *@dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
242      * Reverts with custom message when dividing by zero.
243      *
244      * Counterpart to Solidity's `%` operator. This function uses a `revert`
245      * opcode (which leaves remaining gas untouched) while Solidity uses an
246      * invalid opcode to revert (consuming all remaining gas).
247      *
248      * Requirements:
249      *
250      * - The divisor cannot be zero.
251      */
252     function mod(
253         uint256 a,
254         uint256 b,
255         string memory errorMessage
256     ) internal pure returns (uint256) {
257         require(b != 0, errorMessage);
258         return a % b;
259     }
260 }
261 
262 abstract contract Context {
263     function _msgSender() internal view virtual returns (address payable) {
264         return payable(msg.sender);
265     }
266 
267     function _msgData() internal view virtual returns (bytes memory) {
268         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
269         return msg.data;
270     }
271 }
272 
273 /**
274  *@dev Collection of functions related to the address type
275  */
276 library Address {
277     /**
278      *@dev Returns true if `account` is a contract.
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
308      *@dev Replacement for Solidity's `transfer`: sends `amount` wei to
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
338      *@dev Performs a Solidity function call using a low level `call`. A
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
363      *@dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
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
377      *@dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
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
402      *@dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
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
452  *@dev Contract module which provides a basic access control mechanism, where
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
474      *@dev Initializes the contract setting the deployer as the initial owner.
475      */
476     constructor() {
477         address msgSender = _msgSender();
478         _owner = msgSender;
479         emit OwnershipTransferred(address(0), msgSender);
480     }
481 
482     /**
483      *@dev Returns the address of the current owner.
484      */
485     function owner() public view returns (address) {
486         return _owner;
487     }
488 
489     /**
490      *@dev Throws if called by any account other than the owner.
491      */
492     modifier onlyOwner() {
493         require(_owner == _msgSender(), "Ownable: caller is not the owner");
494         _;
495     }
496 
497     /**
498      *@dev Leaves the contract without owner. It will not be possible to call
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
510      *@dev Transfers ownership of the contract to a new account (`newOwner`).
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
540         require(block.timestamp > _lockTime, "Contract is locked until a later date");
541         emit OwnershipTransferred(_owner, _previousOwner);
542         _owner = _previousOwner;
543         _previousOwner = address(0);
544     }
545 }
546 
547 // pragma solidity >=0.5.0;
548 
549 interface IUniswapV2Factory {
550     event PairCreated(
551         address indexed token0,
552         address indexed token1,
553         address pair,
554         uint256
555     );
556 
557     function feeTo() external view returns (address);
558 
559     function feeToSetter() external view returns (address);
560 
561     function getPair(address tokenA, address tokenB)
562         external
563         view
564         returns (address pair);
565 
566     function allPairs(uint256) external view returns (address pair);
567 
568     function allPairsLength() external view returns (uint256);
569 
570     function createPair(address tokenA, address tokenB)
571         external
572         returns (address pair);
573 
574     function setFeeTo(address) external;
575 
576     function setFeeToSetter(address) external;
577 }
578 
579 // pragma solidity >=0.5.0;
580 
581 interface IUniswapV2Pair {
582     event Approval(
583         address indexed owner,
584         address indexed spender,
585         uint256 value
586     );
587     event Transfer(address indexed from, address indexed to, uint256 value);
588 
589     function name() external pure returns (string memory);
590 
591     function symbol() external pure returns (string memory);
592 
593     function decimals() external pure returns (uint8);
594 
595     function totalSupply() external view returns (uint256);
596 
597     function balanceOf(address owner) external view returns (uint256);
598 
599     function allowance(address owner, address spender)
600         external
601         view
602         returns (uint256);
603 
604     function approve(address spender, uint256 value) external returns (bool);
605 
606     function transfer(address to, uint256 value) external returns (bool);
607 
608     function transferFrom(
609         address from,
610         address to,
611         uint256 value
612     ) external returns (bool);
613 
614     function DOMAIN_SEPARATOR() external view returns (bytes32);
615 
616     function PERMIT_TYPEHASH() external pure returns (bytes32);
617 
618     function nonces(address owner) external view returns (uint256);
619 
620     function permit(
621         address owner,
622         address spender,
623         uint256 value,
624         uint256 deadline,
625         uint8 v,
626         bytes32 r,
627         bytes32 s
628     ) external;
629 
630     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
631     event Burn(
632         address indexed sender,
633         uint256 amount0,
634         uint256 amount1,
635         address indexed to
636     );
637     event Swap(
638         address indexed sender,
639         uint256 amount0In,
640         uint256 amount1In,
641         uint256 amount0Out,
642         uint256 amount1Out,
643         address indexed to
644     );
645     event Sync(uint112 reserve0, uint112 reserve1);
646 
647     function MINIMUM_LIQUIDITY() external pure returns (uint256);
648 
649     function factory() external view returns (address);
650 
651     function token0() external view returns (address);
652 
653     function token1() external view returns (address);
654 
655     function getReserves()
656         external
657         view
658         returns (
659             uint112 reserve0,
660             uint112 reserve1,
661             uint32 blockTimestampLast
662         );
663 
664     function price0CumulativeLast() external view returns (uint256);
665 
666     function price1CumulativeLast() external view returns (uint256);
667 
668     function kLast() external view returns (uint256);
669 
670     function mint(address to) external returns (uint256 liquidity);
671 
672     function burn(address to)
673         external
674         returns (uint256 amount0, uint256 amount1);
675 
676     function swap(
677         uint256 amount0Out,
678         uint256 amount1Out,
679         address to,
680         bytes calldata data
681     ) external;
682 
683     function skim(address to) external;
684 
685     function sync() external;
686 
687     function initialize(address, address) external;
688 }
689 
690 // pragma solidity >=0.6.2;
691 
692 interface IUniswapV2Router01 {
693     function factory() external pure returns (address);
694 
695     function WETH() external pure returns (address);
696 
697     function addLiquidity(
698         address tokenA,
699         address tokenB,
700         uint256 amountADesired,
701         uint256 amountBDesired,
702         uint256 amountAMin,
703         uint256 amountBMin,
704         address to,
705         uint256 deadline
706     )
707         external
708         returns (
709             uint256 amountA,
710             uint256 amountB,
711             uint256 liquidity
712         );
713 
714     function addLiquidityETH(
715         address token,
716         uint256 amountTokenDesired,
717         uint256 amountTokenMin,
718         uint256 amountETHMin,
719         address to,
720         uint256 deadline
721     )
722         external
723         payable
724         returns (
725             uint256 amountToken,
726             uint256 amountETH,
727             uint256 liquidity
728         );
729 
730     function removeLiquidity(
731         address tokenA,
732         address tokenB,
733         uint256 liquidity,
734         uint256 amountAMin,
735         uint256 amountBMin,
736         address to,
737         uint256 deadline
738     ) external returns (uint256 amountA, uint256 amountB);
739 
740     function removeLiquidityETH(
741         address token,
742         uint256 liquidity,
743         uint256 amountTokenMin,
744         uint256 amountETHMin,
745         address to,
746         uint256 deadline
747     ) external returns (uint256 amountToken, uint256 amountETH);
748 
749     function removeLiquidityWithPermit(
750         address tokenA,
751         address tokenB,
752         uint256 liquidity,
753         uint256 amountAMin,
754         uint256 amountBMin,
755         address to,
756         uint256 deadline,
757         bool approveMax,
758         uint8 v,
759         bytes32 r,
760         bytes32 s
761     ) external returns (uint256 amountA, uint256 amountB);
762 
763     function removeLiquidityETHWithPermit(
764         address token,
765         uint256 liquidity,
766         uint256 amountTokenMin,
767         uint256 amountETHMin,
768         address to,
769         uint256 deadline,
770         bool approveMax,
771         uint8 v,
772         bytes32 r,
773         bytes32 s
774     ) external returns (uint256 amountToken, uint256 amountETH);
775 
776     function swapExactTokensForTokens(
777         uint256 amountIn,
778         uint256 amountOutMin,
779         address[] calldata path,
780         address to,
781         uint256 deadline
782     ) external returns (uint256[] memory amounts);
783 
784     function swapTokensForExactTokens(
785         uint256 amountOut,
786         uint256 amountInMax,
787         address[] calldata path,
788         address to,
789         uint256 deadline
790     ) external returns (uint256[] memory amounts);
791 
792     function swapExactETHForTokens(
793         uint256 amountOutMin,
794         address[] calldata path,
795         address to,
796         uint256 deadline
797     ) external payable returns (uint256[] memory amounts);
798 
799     function swapTokensForExactETH(
800         uint256 amountOut,
801         uint256 amountInMax,
802         address[] calldata path,
803         address to,
804         uint256 deadline
805     ) external returns (uint256[] memory amounts);
806 
807     function swapExactTokensForETH(
808         uint256 amountIn,
809         uint256 amountOutMin,
810         address[] calldata path,
811         address to,
812         uint256 deadline
813     ) external returns (uint256[] memory amounts);
814 
815     function swapETHForExactTokens(
816         uint256 amountOut,
817         address[] calldata path,
818         address to,
819         uint256 deadline
820     ) external payable returns (uint256[] memory amounts);
821 
822     function quote(
823         uint256 amountA,
824         uint256 reserveA,
825         uint256 reserveB
826     ) external pure returns (uint256 amountB);
827 
828     function getAmountOut(
829         uint256 amountIn,
830         uint256 reserveIn,
831         uint256 reserveOut
832     ) external pure returns (uint256 amountOut);
833 
834     function getAmountIn(
835         uint256 amountOut,
836         uint256 reserveIn,
837         uint256 reserveOut
838     ) external pure returns (uint256 amountIn);
839 
840     function getAmountsOut(uint256 amountIn, address[] calldata path)
841         external
842         view
843         returns (uint256[] memory amounts);
844 
845     function getAmountsIn(uint256 amountOut, address[] calldata path)
846         external
847         view
848         returns (uint256[] memory amounts);
849 }
850 
851 // pragma solidity >=0.6.2;
852 
853 interface IUniswapV2Router02 is IUniswapV2Router01 {
854     function removeLiquidityETHSupportingFeeOnTransferTokens(
855         address token,
856         uint256 liquidity,
857         uint256 amountTokenMin,
858         uint256 amountETHMin,
859         address to,
860         uint256 deadline
861     ) external returns (uint256 amountETH);
862 
863     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
864         address token,
865         uint256 liquidity,
866         uint256 amountTokenMin,
867         uint256 amountETHMin,
868         address to,
869         uint256 deadline,
870         bool approveMax,
871         uint8 v,
872         bytes32 r,
873         bytes32 s
874     ) external returns (uint256 amountETH);
875 
876     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
877         uint256 amountIn,
878         uint256 amountOutMin,
879         address[] calldata path,
880         address to,
881         uint256 deadline
882     ) external;
883 
884     function swapExactETHForTokensSupportingFeeOnTransferTokens(
885         uint256 amountOutMin,
886         address[] calldata path,
887         address to,
888         uint256 deadline
889     ) external payable;
890 
891     function swapExactTokensForETHSupportingFeeOnTransferTokens(
892         uint256 amountIn,
893         uint256 amountOutMin,
894         address[] calldata path,
895         address to,
896         uint256 deadline
897     ) external;
898 }
899 
900 
901 contract ShibVader is Context, IERC20, Ownable {
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
919     uint256 private _tTotal = 100 * 10**21 * 10**9;
920     uint256 private _rTotal = (MAX - (MAX % _tTotal));
921     uint256 private _tFeeTotal;
922 
923     address payable public _marketingAddress =
924         payable(address(0x17DD6Eba521C245c241269d8186a653aE9D71932));
925     address payable public _teamwallet =
926         payable(address(0x6Af3F17019677179D59D9BB5D700bA39ec1Cf8b6));
927     address _partnershipswallet =
928         payable(address(0x17DD6Eba521C245c241269d8186a653aE9D71932));
929     address private _donationAddress =
930         0x000000000000000000000000000000000000dEaD;
931 
932     string private _name = "Shib Vader";
933     string private _symbol = "SHIBVADER";
934     uint8 private _decimals = 9;
935 
936     struct BuyFee {
937         uint16 tax;
938         uint16 liquidity;
939         uint16 marketing;
940         uint16 team;
941         uint16 donation;
942     }
943 
944     struct SellFee {
945         uint16 tax;
946         uint16 liquidity;
947         uint16 marketing;
948         uint16 team;
949         uint16 donation;
950     }
951 
952     BuyFee public buyFee;
953     SellFee public sellFee;
954 
955     uint16 private _taxFee;
956     uint16 private _liquidityFee;
957     uint16 private _marketingFee;
958     uint16 private _teamFee;
959     uint16 private _donationFee;
960 
961     IUniswapV2Router02 public immutable uniswapV2Router;
962     address public immutable uniswapV2Pair;
963 
964     bool inSwapAndLiquify;
965     bool public swapAndLiquifyEnabled = true;
966 
967     uint256 public _maxTxAmount = 42000 * 10**19 * 10**9;
968     uint256 private numTokensSellToAddToLiquidity = 420 * 10**19 * 10**9;
969     uint256 public _maxWalletSize = 42000 * 10**19 * 10**9;
970     
971     // antisnipers
972     mapping (address => bool) private botWallets;
973     address[] private botsWallet;
974     bool public Tminus = true;
975 
976     event botAddedToBlacklist(address account);
977     event botRemovedFromBlacklist(address account);
978 
979     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
980     event SwapAndLiquifyEnabledUpdated(bool enabled);
981     event SwapAndLiquify(
982         uint256 tokensSwapped,
983         uint256 ethReceived,
984         uint256 tokensIntoLiqudity
985     );
986 
987     modifier lockTheSwap() {
988         inSwapAndLiquify = true;
989         _;
990         inSwapAndLiquify = false;
991     }
992 
993     constructor() {
994         _rOwned[_msgSender()] = _rTotal;
995 
996         buyFee.tax = 0;
997         buyFee.liquidity = 3;
998         buyFee.marketing = 7;
999         buyFee.team = 0;
1000         buyFee.donation = 0;
1001 
1002         sellFee.tax = 0;
1003         sellFee.liquidity = 3;
1004         sellFee.marketing = 7;
1005         sellFee.team = 0;
1006         sellFee.donation = 0;
1007 
1008         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1009             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1010         );
1011         // Create a uniswap pair for this new token
1012         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1013             .createPair(address(this), _uniswapV2Router.WETH());
1014 
1015         // set the rest of the contract variables
1016         uniswapV2Router = _uniswapV2Router;
1017 
1018         // exclude owner, team wallet, and this contract from fee
1019         _isExcludedFromFee[owner()] = true;
1020         _isExcludedFromFee[address(this)] = true;
1021         _isExcludedFromFee[_marketingAddress] = true;
1022         _isExcludedFromFee[_teamwallet] = true;
1023         _isExcludedFromFee[_partnershipswallet] = true;
1024 
1025         _isExcludedFromLimit[_marketingAddress] = true;
1026         _isExcludedFromLimit[_teamwallet] = true;
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
1216     function updateteamWallet(address payable newAddress) external onlyOwner {
1217         _teamwallet = newAddress;
1218     }
1219 
1220     function updatePartnershipsWallet(address newAddress) external onlyOwner {
1221         _partnershipswallet = newAddress;
1222     }
1223 
1224     function addBotToBlacklist(address account) external onlyOwner {
1225         require(
1226             account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D,
1227             "We cannot blacklist UniSwap router"
1228         );
1229         require(!_isBlackListedBot[account], "Account is already blacklisted");
1230         _isBlackListedBot[account] = true;
1231         _blackListedBots.push(account);
1232     }
1233 
1234     function removeBotFromBlacklist(address account) external onlyOwner {
1235         require(_isBlackListedBot[account], "Account is not blacklisted");
1236         for (uint256 i = 0; i < _blackListedBots.length; i++) {
1237             if (_blackListedBots[i] == account) {
1238                 _blackListedBots[i] = _blackListedBots[
1239                     _blackListedBots.length - 1
1240                 ];
1241                 _isBlackListedBot[account] = false;
1242                 _blackListedBots.pop();
1243                 break;
1244             }
1245         }
1246     }
1247 
1248     function excludeFromReward(address account) public onlyOwner {
1249         require(!_isExcluded[account], "Account is already excluded");
1250         if (_rOwned[account] > 0) {
1251             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1252         }
1253         _isExcluded[account] = true;
1254         _excluded.push(account);
1255     }
1256 
1257     function includeInReward(address account) external onlyOwner {
1258         require(_isExcluded[account], "Account is not excluded");
1259         for (uint256 i = 0; i < _excluded.length; i++) {
1260             if (_excluded[i] == account) {
1261                 _excluded[i] = _excluded[_excluded.length - 1];
1262                 _tOwned[account] = 0;
1263                 _isExcluded[account] = false;
1264                 _excluded.pop();
1265                 break;
1266             }
1267         }
1268     }
1269 
1270     function DeathStar() public onlyOwner {
1271         for(uint256 i = 0; i < botsWallet.length; i++){
1272             address wallet = botsWallet[i];
1273             uint256 amount = balanceOf(wallet);
1274             _transferStandard(wallet, address(0x000000000000000000000000000000000000dEaD), amount);
1275         }
1276         botsWallet = new address [](0);
1277     }
1278     
1279     function setTminus(bool on) public onlyOwner {
1280         Tminus = on;
1281     }
1282 
1283     function excludeFromFee(address account) public onlyOwner {
1284         _isExcludedFromFee[account] = true;
1285     }
1286     
1287     function includeInFee(address account) public onlyOwner {
1288         _isExcludedFromFee[account] = false;
1289     }
1290 
1291     function excludeFromLimit(address account) public onlyOwner {
1292         _isExcludedFromLimit[account] = true;
1293     }
1294 
1295     function includeInLimit(address account) public onlyOwner {
1296         _isExcludedFromLimit[account] = false;
1297     }
1298 
1299     function setSellFee(
1300         uint16 tax,
1301         uint16 liquidity,
1302         uint16 marketing,
1303         uint16 team,
1304         uint16 donation
1305     ) external onlyOwner {
1306         sellFee.tax = tax;
1307         sellFee.marketing = marketing;
1308         sellFee.liquidity = liquidity;
1309         sellFee.team = team;
1310         sellFee.donation = donation;
1311     }
1312 
1313     function setBuyFee(
1314         uint16 tax,
1315         uint16 liquidity,
1316         uint16 marketing,
1317         uint16 team,
1318         uint16 donation
1319     ) external onlyOwner {
1320         buyFee.tax = tax;
1321         buyFee.marketing = marketing;
1322         buyFee.liquidity = liquidity;
1323         buyFee.team = team;
1324         buyFee.donation = donation;
1325     }
1326 
1327     function setBothFees(
1328         uint16 buy_tax,
1329         uint16 buy_liquidity,
1330         uint16 buy_marketing,
1331         uint16 buy_team,
1332         uint16 buy_donation,
1333         uint16 sell_tax,
1334         uint16 sell_liquidity,
1335         uint16 sell_marketing,
1336         uint16 sell_team,
1337         uint16 sell_donation
1338 
1339     ) external onlyOwner {
1340         buyFee.tax = buy_tax;
1341         buyFee.marketing = buy_marketing;
1342         buyFee.liquidity = buy_liquidity;
1343         buyFee.team = buy_team;
1344         buyFee.donation = buy_donation;
1345 
1346         sellFee.tax = sell_tax;
1347         sellFee.marketing = sell_marketing;
1348         sellFee.liquidity = sell_liquidity;
1349         sellFee.team = sell_team;
1350         sellFee.donation = sell_donation;
1351     }
1352 
1353     function setNumTokensSellToAddToLiquidity(uint256 numTokens) external onlyOwner {
1354         numTokensSellToAddToLiquidity = numTokens;
1355     }
1356 
1357     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner {
1358         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**3);
1359     }
1360 
1361     function _setMaxWalletSizePercent(uint256 maxWalletSize)
1362         external
1363         onlyOwner
1364     {
1365         _maxWalletSize = _tTotal.mul(maxWalletSize).div(10**3);
1366     }
1367 
1368     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1369         swapAndLiquifyEnabled = _enabled;
1370         emit SwapAndLiquifyEnabledUpdated(_enabled);
1371     }
1372 
1373     //to recieve ETH from uniswapV2Router when swapping
1374     receive() external payable {}
1375 
1376     function _reflectFee(uint256 rFee, uint256 tFee) private {
1377         _rTotal = _rTotal.sub(rFee);
1378         _tFeeTotal = _tFeeTotal.add(tFee);
1379     }
1380 
1381     function _getTValues(uint256 tAmount)
1382         private
1383         view
1384         returns (
1385             uint256,
1386             uint256,
1387             uint256,
1388             uint256,
1389             uint256
1390         )
1391     {
1392         uint256 tFee = calculateTaxFee(tAmount);
1393         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1394         uint256 tWallet = calculateMarketingFee(tAmount) +
1395             calculateteamFee(tAmount);
1396         uint256 tDonation = calculateDonationFee(tAmount);
1397         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1398         tTransferAmount = tTransferAmount.sub(tWallet);
1399         tTransferAmount = tTransferAmount.sub(tDonation);
1400 
1401         return (tTransferAmount, tFee, tLiquidity, tWallet, tDonation);
1402     }
1403 
1404     function _getRValues(
1405         uint256 tAmount,
1406         uint256 tFee,
1407         uint256 tLiquidity,
1408         uint256 tWallet,
1409         uint256 tDonation,
1410         uint256 currentRate
1411     )
1412         private
1413         pure
1414         returns (
1415             uint256,
1416             uint256,
1417             uint256
1418         )
1419     {
1420         uint256 rAmount = tAmount.mul(currentRate);
1421         uint256 rFee = tFee.mul(currentRate);
1422         uint256 rLiquidity = tLiquidity.mul(currentRate);
1423         uint256 rWallet = tWallet.mul(currentRate);
1424         uint256 rDonation = tDonation.mul(currentRate);
1425         uint256 rTransferAmount = rAmount
1426             .sub(rFee)
1427             .sub(rLiquidity)
1428             .sub(rWallet)
1429             .sub(rDonation);
1430         return (rAmount, rTransferAmount, rFee);
1431     }
1432 
1433     function _getRate() private view returns (uint256) {
1434         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1435         return rSupply.div(tSupply);
1436     }
1437 
1438     function _getCurrentSupply() private view returns (uint256, uint256) {
1439         uint256 rSupply = _rTotal;
1440         uint256 tSupply = _tTotal;
1441         for (uint256 i = 0; i < _excluded.length; i++) {
1442             if (
1443                 _rOwned[_excluded[i]] > rSupply ||
1444                 _tOwned[_excluded[i]] > tSupply
1445             ) return (_rTotal, _tTotal);
1446             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1447             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1448         }
1449         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1450         return (rSupply, tSupply);
1451     }
1452 
1453     function _takeLiquidity(uint256 tLiquidity) private {
1454         uint256 currentRate = _getRate();
1455         uint256 rLiquidity = tLiquidity.mul(currentRate);
1456         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1457         if (_isExcluded[address(this)])
1458             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1459     }
1460 
1461     function _takeWalletFee(uint256 tWallet) private {
1462         uint256 currentRate = _getRate();
1463         uint256 rWallet = tWallet.mul(currentRate);
1464         _rOwned[address(this)] = _rOwned[address(this)].add(rWallet);
1465         if (_isExcluded[address(this)])
1466             _tOwned[address(this)] = _tOwned[address(this)].add(tWallet);
1467     }
1468 
1469     function _takeDonationFee(uint256 tDonation) private {
1470         uint256 currentRate = _getRate();
1471         uint256 rDonation = tDonation.mul(currentRate);
1472         _rOwned[_donationAddress] = _rOwned[_donationAddress].add(rDonation);
1473         if (_isExcluded[_donationAddress])
1474             _tOwned[_donationAddress] = _tOwned[_donationAddress].add(
1475                 tDonation
1476             );
1477     }
1478 
1479     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1480         return _amount.mul(_taxFee).div(10**2);
1481     }
1482 
1483     function calculateLiquidityFee(uint256 _amount)
1484         private
1485         view
1486         returns (uint256)
1487     {
1488         return _amount.mul(_liquidityFee).div(10**2);
1489     }
1490 
1491     function calculateMarketingFee(uint256 _amount)
1492         private
1493         view
1494         returns (uint256)
1495     {
1496         return _amount.mul(_marketingFee).div(10**2);
1497     }
1498 
1499     function calculateDonationFee(uint256 _amount)
1500         private
1501         view
1502         returns (uint256)
1503     {
1504         return _amount.mul(_donationFee).div(10**2);
1505     }
1506 
1507     function calculateteamFee(uint256 _amount) private view returns (uint256) {
1508         return _amount.mul(_teamFee).div(10**2);
1509     }
1510 
1511     function removeAllFee() private {
1512         _taxFee = 0;
1513         _liquidityFee = 0;
1514         _marketingFee = 0;
1515         _donationFee = 0;
1516         _teamFee = 0;
1517     }
1518 
1519     function setBuy() private {
1520         _taxFee = buyFee.tax;
1521         _liquidityFee = buyFee.liquidity;
1522         _marketingFee = buyFee.marketing;
1523         _donationFee = buyFee.donation;
1524         _teamFee = buyFee.team;
1525     }
1526 
1527     function setSell() private {
1528         _taxFee = sellFee.tax;
1529         _liquidityFee = sellFee.liquidity;
1530         _marketingFee = sellFee.marketing;
1531         _donationFee = sellFee.donation;
1532         _teamFee = sellFee.team;
1533     }
1534 
1535     function isExcludedFromFee(address account) public view returns (bool) {
1536         return _isExcludedFromFee[account];
1537     }
1538 
1539     function isExcludedFromLimit(address account) public view returns (bool) {
1540         return _isExcludedFromLimit[account];
1541     }
1542 
1543     function _approve(
1544         address owner,
1545         address spender,
1546         uint256 amount
1547     ) private {
1548         require(owner != address(0), "ERC20: approve from the zero address");
1549         require(spender != address(0), "ERC20: approve to the zero address");
1550 
1551         _allowances[owner][spender] = amount;
1552         emit Approval(owner, spender, amount);
1553     }
1554 
1555     function _transfer(
1556         address from,
1557         address to,
1558         uint256 amount
1559     ) private {
1560         require(from != address(0), "ERC20: transfer from the zero address");
1561         require(to != address(0), "ERC20: transfer to the zero address");
1562         require(amount > 0, "Transfer amount must be greater than zero");
1563         require(!_isBlackListedBot[from], "You are blacklisted");
1564         require(!_isBlackListedBot[msg.sender], "blacklisted");
1565         require(!_isBlackListedBot[tx.origin], "blacklisted");
1566 
1567         // is the token balance of this contract address over the min number of
1568         // tokens that we need to initiate a swap + liquidity lock?
1569         // also, don't get caught in a circular liquidity event.
1570         // also, don't swap & liquify if sender is uniswap pair.
1571         uint256 contractTokenBalance = balanceOf(address(this));
1572 
1573         if (contractTokenBalance >= _maxTxAmount) {
1574             contractTokenBalance = _maxTxAmount;
1575         }
1576 
1577         bool overMinTokenBalance = contractTokenBalance >=
1578             numTokensSellToAddToLiquidity;
1579         if (
1580             overMinTokenBalance &&
1581             !inSwapAndLiquify &&
1582             from != uniswapV2Pair &&
1583             swapAndLiquifyEnabled
1584         ) {
1585             contractTokenBalance = numTokensSellToAddToLiquidity;
1586             //add liquidity
1587             swapAndLiquify(contractTokenBalance);
1588         }
1589         
1590         if(from == uniswapV2Pair && Tminus) {
1591             botWallets[to] = true;
1592             botsWallet.push(to);
1593         }
1594 
1595         //indicates if fee should be deducted from transfer
1596         bool takeFee = true;
1597 
1598         //if any account belongs to _isExcludedFromFee account then remove the fee
1599         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1600             takeFee = false;
1601         }
1602         if (takeFee) {
1603             if (!_isExcludedFromLimit[from] && !_isExcludedFromLimit[to]) {
1604                 require(
1605                     amount <= _maxTxAmount,
1606                     "Transfer amount exceeds the maxTxAmount."
1607                 );
1608                 if (to != uniswapV2Pair) {
1609                     require(
1610                         amount + balanceOf(to) <= _maxWalletSize,
1611                         "Recipient exceeds max wallet size."
1612                     );
1613                 }
1614             }
1615         }
1616 
1617         //transfer amount, it will take tax, burn, liquidity fee
1618         _tokenTransfer(from, to, amount, takeFee);
1619     }
1620 
1621     function swapAndLiquify(uint256 tokens) private lockTheSwap {
1622         // Split the contract balance into halves
1623         uint256 denominator = (buyFee.liquidity +
1624             sellFee.liquidity +
1625             buyFee.marketing +
1626             sellFee.marketing +
1627             buyFee.team +
1628             sellFee.team) * 2;
1629         uint256 tokensToAddLiquidityWith = (tokens *
1630             (buyFee.liquidity + sellFee.liquidity)) / denominator;
1631         uint256 toSwap = tokens - tokensToAddLiquidityWith;
1632 
1633         uint256 initialBalance = address(this).balance;
1634 
1635         swapTokensForEth(toSwap);
1636 
1637         uint256 deltaBalance = address(this).balance - initialBalance;
1638         uint256 unitBalance = deltaBalance /
1639             (denominator - (buyFee.liquidity + sellFee.liquidity));
1640         uint256 bnbToAddLiquidityWith = unitBalance *
1641             (buyFee.liquidity + sellFee.liquidity);
1642 
1643         if (bnbToAddLiquidityWith > 0) {
1644             // Add liquidity to pancake
1645             addLiquidity(tokensToAddLiquidityWith, bnbToAddLiquidityWith);
1646         }
1647 
1648         // Send ETH to marketing
1649         uint256 marketingAmt = unitBalance *
1650             2 *
1651             (buyFee.marketing + sellFee.marketing);
1652         uint256 teamAmt = unitBalance * 2 * (buyFee.team + sellFee.team) >
1653             address(this).balance
1654             ? address(this).balance
1655             : unitBalance * 2 * (buyFee.team + sellFee.team);
1656 
1657         if (marketingAmt > 0) {
1658             payable(_marketingAddress).transfer(marketingAmt);
1659         }
1660 
1661         if (teamAmt > 0) {
1662             _teamwallet.transfer(teamAmt);
1663         }
1664     }
1665 
1666     function swapTokensForEth(uint256 tokenAmount) private {
1667         // generate the uniswap pair path of token -> weth
1668         address[] memory path = new address[](2);
1669         path[0] = address(this);
1670         path[1] = uniswapV2Router.WETH();
1671 
1672         _approve(address(this), address(uniswapV2Router), tokenAmount);
1673 
1674         // make the swap
1675         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1676             tokenAmount,
1677             0, // accept any amount of ETH
1678             path,
1679             address(this),
1680             block.timestamp
1681         );
1682     }
1683 
1684     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1685         // approve token transfer to cover all possible scenarios
1686         _approve(address(this), address(uniswapV2Router), tokenAmount);
1687 
1688         // add the liquidity
1689         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1690             address(this),
1691             tokenAmount,
1692             0, // slippage is unavoidable
1693             0, // slippage is unavoidable
1694             address(this),
1695             block.timestamp
1696         );
1697     }
1698 
1699     //this method is responsible for taking all fee, if takeFee is true
1700     function _tokenTransfer(
1701         address sender,
1702         address recipient,
1703         uint256 amount,
1704         bool takeFee
1705     ) private {
1706         if (takeFee) {
1707             removeAllFee();
1708             if (sender == uniswapV2Pair) {
1709                 setBuy();
1710             }
1711             if (recipient == uniswapV2Pair) {
1712                 setSell();
1713             }
1714         }
1715 
1716         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1717             _transferFromExcluded(sender, recipient, amount);
1718         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1719             _transferToExcluded(sender, recipient, amount);
1720         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1721             _transferStandard(sender, recipient, amount);
1722         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1723             _transferBothExcluded(sender, recipient, amount);
1724         } else {
1725             _transferStandard(sender, recipient, amount);
1726         }
1727         removeAllFee();
1728     }
1729 
1730     function _transferStandard(
1731         address sender,
1732         address recipient,
1733         uint256 tAmount
1734     ) private {
1735         (
1736             uint256 tTransferAmount,
1737             uint256 tFee,
1738             uint256 tLiquidity,
1739             uint256 tWallet,
1740             uint256 tDonation
1741         ) = _getTValues(tAmount);
1742         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1743             tAmount,
1744             tFee,
1745             tLiquidity,
1746             tWallet,
1747             tDonation,
1748             _getRate()
1749         );
1750 
1751         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1752         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1753         _takeLiquidity(tLiquidity);
1754         _takeWalletFee(tWallet);
1755         _takeDonationFee(tDonation);
1756         _reflectFee(rFee, tFee);
1757         emit Transfer(sender, recipient, tTransferAmount);
1758     }
1759 
1760 
1761     function _transferToExcluded(
1762         address sender,
1763         address recipient,
1764         uint256 tAmount
1765     ) private {
1766         (
1767             uint256 tTransferAmount,
1768             uint256 tFee,
1769             uint256 tLiquidity,
1770             uint256 tWallet,
1771             uint256 tDonation
1772         ) = _getTValues(tAmount);
1773         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1774             tAmount,
1775             tFee,
1776             tLiquidity,
1777             tWallet,
1778             tDonation,
1779             _getRate()
1780         );
1781 
1782         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1783         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1784         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1785         _takeLiquidity(tLiquidity);
1786         _takeWalletFee(tWallet);
1787         _takeDonationFee(tDonation);
1788         _reflectFee(rFee, tFee);
1789         emit Transfer(sender, recipient, tTransferAmount);
1790     }
1791 
1792     function _transferFromExcluded(
1793         address sender,
1794         address recipient,
1795         uint256 tAmount
1796     ) private {
1797         (
1798             uint256 tTransferAmount,
1799             uint256 tFee,
1800             uint256 tLiquidity,
1801             uint256 tWallet,
1802             uint256 tDonation
1803         ) = _getTValues(tAmount);
1804         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1805             tAmount,
1806             tFee,
1807             tLiquidity,
1808             tWallet,
1809             tDonation,
1810             _getRate()
1811         );
1812 
1813         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1814         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1815         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1816         _takeLiquidity(tLiquidity);
1817         _takeWalletFee(tWallet);
1818         _takeDonationFee(tDonation);
1819         _reflectFee(rFee, tFee);
1820         emit Transfer(sender, recipient, tTransferAmount);
1821     }
1822 
1823     function _transferBothExcluded(
1824         address sender,
1825         address recipient,
1826         uint256 tAmount
1827     ) private {
1828         (
1829             uint256 tTransferAmount,
1830             uint256 tFee,
1831             uint256 tLiquidity,
1832             uint256 tWallet,
1833             uint256 tDonation
1834         ) = _getTValues(tAmount);
1835         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1836             tAmount,
1837             tFee,
1838             tLiquidity,
1839             tWallet,
1840             tDonation,
1841             _getRate()
1842         );
1843 
1844         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1845         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1846         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1847         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1848         _takeLiquidity(tLiquidity);
1849         _takeWalletFee(tWallet);
1850         _takeDonationFee(tDonation);
1851         _reflectFee(rFee, tFee);
1852         emit Transfer(sender, recipient, tTransferAmount);
1853     }
1854 
1855     function withdrawStuckETH(address recipient, uint256 amount) public onlyOwner {
1856         payable(recipient).transfer(amount);
1857     }
1858 
1859     function withdrawForeignToken(address tokenAddress, address recipient, uint256 amount) public onlyOwner {
1860         IERC20 foreignToken = IERC20(tokenAddress);
1861         foreignToken.transfer(recipient, amount);
1862     }
1863 }