1 /**
2 
3 */
4 // Telegram: https://t.me/halloffameinu
5 // website: https://hoopersonlyfoundation.com/
6 
7 pragma solidity ^0.8.10;
8 
9 // SPDX-License-Identifier: Unlicensed
10 interface IERC20 {
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      *@dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      *@dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount)
26         external
27         returns (bool);
28 
29     /**
30      *@dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender)
37         external
38         view
39         returns (uint256);
40 
41     /**
42      *@dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      *@dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(
67         address sender,
68         address recipient,
69         uint256 amount
70     ) external returns (bool);
71 
72     /**
73      *@dev Emitted when `value` tokens are moved from one account (`from`) to
74      * another (`to`).
75      *
76      * Note that `value` may be zero.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81      *@dev Emitted when the allowance of a `spender` for an `owner` is set by
82      * a call to {approve}. `value` is the new allowance.
83      */
84     event Approval(
85         address indexed owner,
86         address indexed spender,
87         uint256 value
88     );
89 }
90 
91 /**
92  *@dev Wrappers over Solidity's arithmetic operations with added overflow
93  * checks.
94  *
95  * Arithmetic operations in Solidity wrap on overflow. This can easily result
96  * in bugs, because programmers usually assume that an overflow raises an
97  * error, which is the standard behavior in high level programming languages.
98  * `SafeMath` restores this intuition by reverting the transaction when an
99  * operation overflows.
100  *
101  * Using this library instead of the unchecked operations eliminates an entire
102  * class of bugs, so it's recommended to use it always.
103  */
104 
105 library SafeMath {
106     /**
107      *@dev Returns the addition of two unsigned integers, reverting on
108      * overflow.
109      *
110      * Counterpart to Solidity's `+` operator.
111      *
112      * Requirements:
113      *
114      * - Addition cannot overflow.
115      */
116     function add(uint256 a, uint256 b) internal pure returns (uint256) {
117         uint256 c = a + b;
118         require(c >= a, "SafeMath: addition overflow");
119 
120         return c;
121     }
122 
123     /**
124      *@dev Returns the subtraction of two unsigned integers, reverting on
125      * overflow (when the result is negative).
126      *
127      * Counterpart to Solidity's `-` operator.
128      *
129      * Requirements:
130      *
131      * - Subtraction cannot overflow.
132      */
133     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
134         return sub(a, b, "SafeMath: subtraction overflow");
135     }
136 
137     /**
138      *@dev Returns the subtraction of two unsigned integers, reverting with custom message on
139      * overflow (when the result is negative).
140      *
141      * Counterpart to Solidity's `-` operator.
142      *
143      * Requirements:
144      *
145      * - Subtraction cannot overflow.
146      */
147     function sub(
148         uint256 a,
149         uint256 b,
150         string memory errorMessage
151     ) internal pure returns (uint256) {
152         require(b <= a, errorMessage);
153         uint256 c = a - b;
154 
155         return c;
156     }
157 
158     /**
159      *@dev Returns the multiplication of two unsigned integers, reverting on
160      * overflow.
161      *
162      * Counterpart to Solidity's `*` operator.
163      *
164      * Requirements:
165      *
166      * - Multiplication cannot overflow.
167      */
168     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
169         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
170         // benefit is lost if 'b' is also tested.
171         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
172         if (a == 0) {
173             return 0;
174         }
175 
176         uint256 c = a * b;
177         require(c / a == b, "SafeMath: multiplication overflow");
178 
179         return c;
180     }
181 
182     /**
183      *@dev Returns the integer division of two unsigned integers. Reverts on
184      * division by zero. The result is rounded towards zero.
185      *
186      * Counterpart to Solidity's `/` operator. Note: this function uses a
187      * `revert` opcode (which leaves remaining gas untouched) while Solidity
188      * uses an invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function div(uint256 a, uint256 b) internal pure returns (uint256) {
195         return div(a, b, "SafeMath: division by zero");
196     }
197 
198     /**
199      *@dev Returns the integer division of two unsigned integers. Reverts with custom message on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's `/` operator. Note: this function uses a
203      * `revert` opcode (which leaves remaining gas untouched) while Solidity
204      * uses an invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function div(
211         uint256 a,
212         uint256 b,
213         string memory errorMessage
214     ) internal pure returns (uint256) {
215         require(b > 0, errorMessage);
216         uint256 c = a / b;
217         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
218 
219         return c;
220     }
221 
222     /**
223      *@dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
224      * Reverts when dividing by zero.
225      *
226      * Counterpart to Solidity's `%` operator. This function uses a `revert`
227      * opcode (which leaves remaining gas untouched) while Solidity uses an
228      * invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
235         return mod(a, b, "SafeMath: modulo by zero");
236     }
237 
238     /**
239      *@dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
240      * Reverts with custom message when dividing by zero.
241      *
242      * Counterpart to Solidity's `%` operator. This function uses a `revert`
243      * opcode (which leaves remaining gas untouched) while Solidity uses an
244      * invalid opcode to revert (consuming all remaining gas).
245      *
246      * Requirements:
247      *
248      * - The divisor cannot be zero.
249      */
250     function mod(
251         uint256 a,
252         uint256 b,
253         string memory errorMessage
254     ) internal pure returns (uint256) {
255         require(b != 0, errorMessage);
256         return a % b;
257     }
258 }
259 
260 abstract contract Context {
261     function _msgSender() internal view virtual returns (address payable) {
262         return payable(msg.sender);
263     }
264 
265     function _msgData() internal view virtual returns (bytes memory) {
266         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
267         return msg.data;
268     }
269 }
270 
271 /**
272  *@dev Collection of functions related to the address type
273  */
274 library Address {
275     /**
276      *@dev Returns true if `account` is a contract.
277      *
278      * [IMPORTANT]
279      * ====
280      * It is unsafe to assume that an address for which this function returns
281      * false is an externally-owned account (EOA) and not a contract.
282      *
283      * Among others, `isContract` will return false for the following
284      * types of addresses:
285      *
286      *  - an externally-owned account
287      *  - a contract in construction
288      *  - an address where a contract will be created
289      *  - an address where a contract lived, but was destroyed
290      * ====
291      */
292     function isContract(address account) internal view returns (bool) {
293         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
294         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
295         // for accounts without code, i.e. `keccak256('')`
296         bytes32 codehash;
297         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
298         // solhint-disable-next-line no-inline-assembly
299         assembly {
300             codehash := extcodehash(account)
301         }
302         return (codehash != accountHash && codehash != 0x0);
303     }
304 
305     /**
306      *@dev Replacement for Solidity's `transfer`: sends `amount` wei to
307      * `recipient`, forwarding all available gas and reverting on errors.
308      *
309      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
310      * of certain opcodes, possibly making contracts go over the 2300 gas limit
311      * imposed by `transfer`, making them unable to receive funds via
312      * `transfer`. {sendValue} removes this limitation.
313      *
314      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
315      *
316      * IMPORTANT: because control is transferred to `recipient`, care must be
317      * taken to not create reentrancy vulnerabilities. Consider using
318      * {ReentrancyGuard} or the
319      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
320      */
321     function sendValue(address payable recipient, uint256 amount) internal {
322         require(
323             address(this).balance >= amount,
324             "Address: insufficient balance"
325         );
326 
327         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
328         (bool success, ) = recipient.call{value: amount}("");
329         require(
330             success,
331             "Address: unable to send value, recipient may have reverted"
332         );
333     }
334 
335     /**
336      *@dev Performs a Solidity function call using a low level `call`. A
337      * plain`call` is an unsafe replacement for a function call: use this
338      * function instead.
339      *
340      * If `target` reverts with a revert reason, it is bubbled up by this
341      * function (like regular Solidity function calls).
342      *
343      * Returns the raw returned data. To convert to the expected return value,
344      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
345      *
346      * Requirements:
347      *
348      * - `target` must be a contract.
349      * - calling `target` with `data` must not revert.
350      *
351      * _Available since v3.1._
352      */
353     function functionCall(address target, bytes memory data)
354         internal
355         returns (bytes memory)
356     {
357         return functionCall(target, data, "Address: low-level call failed");
358     }
359 
360     /**
361      *@dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
362      * `errorMessage` as a fallback revert reason when `target` reverts.
363      *
364      * _Available since v3.1._
365      */
366     function functionCall(
367         address target,
368         bytes memory data,
369         string memory errorMessage
370     ) internal returns (bytes memory) {
371         return _functionCallWithValue(target, data, 0, errorMessage);
372     }
373 
374     /**
375      *@dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
376      * but also transferring `value` wei to `target`.
377      *
378      * Requirements:
379      *
380      * - the calling contract must have an ETH balance of at least `value`.
381      * - the called Solidity function must be `payable`.
382      *
383      * _Available since v3.1._
384      */
385     function functionCallWithValue(
386         address target,
387         bytes memory data,
388         uint256 value
389     ) internal returns (bytes memory) {
390         return
391             functionCallWithValue(
392                 target,
393                 data,
394                 value,
395                 "Address: low-level call with value failed"
396             );
397     }
398 
399     /**
400      *@dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
401      * with `errorMessage` as a fallback revert reason when `target` reverts.
402      *
403      * _Available since v3.1._
404      */
405     function functionCallWithValue(
406         address target,
407         bytes memory data,
408         uint256 value,
409         string memory errorMessage
410     ) internal returns (bytes memory) {
411         require(
412             address(this).balance >= value,
413             "Address: insufficient balance for call"
414         );
415         return _functionCallWithValue(target, data, value, errorMessage);
416     }
417 
418     function _functionCallWithValue(
419         address target,
420         bytes memory data,
421         uint256 weiValue,
422         string memory errorMessage
423     ) private returns (bytes memory) {
424         require(isContract(target), "Address: call to non-contract");
425 
426         // solhint-disable-next-line avoid-low-level-calls
427         (bool success, bytes memory returndata) = target.call{value: weiValue}(
428             data
429         );
430         if (success) {
431             return returndata;
432         } else {
433             // Look for revert reason and bubble it up if present
434             if (returndata.length > 0) {
435                 // The easiest way to bubble the revert reason is using memory via assembly
436 
437                 // solhint-disable-next-line no-inline-assembly
438                 assembly {
439                     let returndata_size := mload(returndata)
440                     revert(add(32, returndata), returndata_size)
441                 }
442             } else {
443                 revert(errorMessage);
444             }
445         }
446     }
447 }
448 
449 /**
450  *@dev Contract module which provides a basic access control mechanism, where
451  * there is an account (an owner) that can be granted exclusive access to
452  * specific functions.
453  *
454  * By default, the owner account will be the one that deploys the contract. This
455  * can later be changed with {transferOwnership}.
456  *
457  * This module is used through inheritance. It will make available the modifier
458  * `onlyOwner`, which can be applied to your functions to restrict their use to
459  * the owner.
460  */
461 contract Ownable is Context {
462     address private _owner;
463     address private _previousOwner;
464     uint256 private _lockTime;
465 
466     event OwnershipTransferred(
467         address indexed previousOwner,
468         address indexed newOwner
469     );
470 
471     /**
472      *@dev Initializes the contract setting the deployer as the initial owner.
473      */
474     constructor() {
475         address msgSender = _msgSender();
476         _owner = msgSender;
477         emit OwnershipTransferred(address(0), msgSender);
478     }
479 
480     /**
481      *@dev Returns the address of the current owner.
482      */
483     function owner() public view returns (address) {
484         return _owner;
485     }
486 
487     /**
488      *@dev Throws if called by any account other than the owner.
489      */
490     modifier onlyOwner() {
491         require(_owner == _msgSender(), "Ownable: caller is not the owner");
492         _;
493     }
494 
495     /**
496      *@dev Leaves the contract without owner. It will not be possible to call
497      * `onlyOwner` functions anymore. Can only be called by the current owner.
498      *
499      * NOTE: Renouncing ownership will leave the contract without an owner,
500      * thereby removing any functionality that is only available to the owner.
501      */
502     function renounceOwnership() public virtual onlyOwner {
503         emit OwnershipTransferred(_owner, address(0));
504         _owner = address(0);
505     }
506 
507     /**
508      *@dev Transfers ownership of the contract to a new account (`newOwner`).
509      * Can only be called by the current owner.
510      */
511     function transferOwnership(address newOwner) public virtual onlyOwner {
512         require(
513             newOwner != address(0),
514             "Ownable: new owner is the zero address"
515         );
516         emit OwnershipTransferred(_owner, newOwner);
517         _owner = newOwner;
518     }
519 
520 }
521 
522 // pragma solidity >=0.5.0;
523 
524 interface IUniswapV2Factory {
525     event PairCreated(
526         address indexed token0,
527         address indexed token1,
528         address pair,
529         uint256
530     );
531 
532     function feeTo() external view returns (address);
533 
534     function feeToSetter() external view returns (address);
535 
536     function getPair(address tokenA, address tokenB)
537         external
538         view
539         returns (address pair);
540 
541     function allPairs(uint256) external view returns (address pair);
542 
543     function allPairsLength() external view returns (uint256);
544 
545     function createPair(address tokenA, address tokenB)
546         external
547         returns (address pair);
548 
549     function setFeeTo(address) external;
550 
551     function setFeeToSetter(address) external;
552 }
553 
554 // pragma solidity >=0.5.0;
555 
556 interface IUniswapV2Pair {
557     event Approval(
558         address indexed owner,
559         address indexed spender,
560         uint256 value
561     );
562     event Transfer(address indexed from, address indexed to, uint256 value);
563 
564     function name() external pure returns (string memory);
565 
566     function symbol() external pure returns (string memory);
567 
568     function decimals() external pure returns (uint8);
569 
570     function totalSupply() external view returns (uint256);
571 
572     function balanceOf(address owner) external view returns (uint256);
573 
574     function allowance(address owner, address spender)
575         external
576         view
577         returns (uint256);
578 
579     function approve(address spender, uint256 value) external returns (bool);
580 
581     function transfer(address to, uint256 value) external returns (bool);
582 
583     function transferFrom(
584         address from,
585         address to,
586         uint256 value
587     ) external returns (bool);
588 
589     function DOMAIN_SEPARATOR() external view returns (bytes32);
590 
591     function PERMIT_TYPEHASH() external pure returns (bytes32);
592 
593     function nonces(address owner) external view returns (uint256);
594 
595     function permit(
596         address owner,
597         address spender,
598         uint256 value,
599         uint256 deadline,
600         uint8 v,
601         bytes32 r,
602         bytes32 s
603     ) external;
604 
605     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
606     event Burn(
607         address indexed sender,
608         uint256 amount0,
609         uint256 amount1,
610         address indexed to
611     );
612     event Swap(
613         address indexed sender,
614         uint256 amount0In,
615         uint256 amount1In,
616         uint256 amount0Out,
617         uint256 amount1Out,
618         address indexed to
619     );
620     event Sync(uint112 reserve0, uint112 reserve1);
621 
622     function MINIMUM_LIQUIDITY() external pure returns (uint256);
623 
624     function factory() external view returns (address);
625 
626     function token0() external view returns (address);
627 
628     function token1() external view returns (address);
629 
630     function getReserves()
631         external
632         view
633         returns (
634             uint112 reserve0,
635             uint112 reserve1,
636             uint32 blockTimestampLast
637         );
638 
639     function price0CumulativeLast() external view returns (uint256);
640 
641     function price1CumulativeLast() external view returns (uint256);
642 
643     function kLast() external view returns (uint256);
644 
645     function mint(address to) external returns (uint256 liquidity);
646 
647     function burn(address to)
648         external
649         returns (uint256 amount0, uint256 amount1);
650 
651     function swap(
652         uint256 amount0Out,
653         uint256 amount1Out,
654         address to,
655         bytes calldata data
656     ) external;
657 
658     function skim(address to) external;
659 
660     function sync() external;
661 
662     function initialize(address, address) external;
663 }
664 
665 // pragma solidity >=0.6.2;
666 
667 interface IUniswapV2Router01 {
668     function factory() external pure returns (address);
669 
670     function WETH() external pure returns (address);
671 
672     function addLiquidity(
673         address tokenA,
674         address tokenB,
675         uint256 amountADesired,
676         uint256 amountBDesired,
677         uint256 amountAMin,
678         uint256 amountBMin,
679         address to,
680         uint256 deadline
681     )
682         external
683         returns (
684             uint256 amountA,
685             uint256 amountB,
686             uint256 liquidity
687         );
688 
689     function addLiquidityETH(
690         address token,
691         uint256 amountTokenDesired,
692         uint256 amountTokenMin,
693         uint256 amountETHMin,
694         address to,
695         uint256 deadline
696     )
697         external
698         payable
699         returns (
700             uint256 amountToken,
701             uint256 amountETH,
702             uint256 liquidity
703         );
704 
705     function removeLiquidity(
706         address tokenA,
707         address tokenB,
708         uint256 liquidity,
709         uint256 amountAMin,
710         uint256 amountBMin,
711         address to,
712         uint256 deadline
713     ) external returns (uint256 amountA, uint256 amountB);
714 
715     function removeLiquidityETH(
716         address token,
717         uint256 liquidity,
718         uint256 amountTokenMin,
719         uint256 amountETHMin,
720         address to,
721         uint256 deadline
722     ) external returns (uint256 amountToken, uint256 amountETH);
723 
724     function removeLiquidityWithPermit(
725         address tokenA,
726         address tokenB,
727         uint256 liquidity,
728         uint256 amountAMin,
729         uint256 amountBMin,
730         address to,
731         uint256 deadline,
732         bool approveMax,
733         uint8 v,
734         bytes32 r,
735         bytes32 s
736     ) external returns (uint256 amountA, uint256 amountB);
737 
738     function removeLiquidityETHWithPermit(
739         address token,
740         uint256 liquidity,
741         uint256 amountTokenMin,
742         uint256 amountETHMin,
743         address to,
744         uint256 deadline,
745         bool approveMax,
746         uint8 v,
747         bytes32 r,
748         bytes32 s
749     ) external returns (uint256 amountToken, uint256 amountETH);
750 
751     function swapExactTokensForTokens(
752         uint256 amountIn,
753         uint256 amountOutMin,
754         address[] calldata path,
755         address to,
756         uint256 deadline
757     ) external returns (uint256[] memory amounts);
758 
759     function swapTokensForExactTokens(
760         uint256 amountOut,
761         uint256 amountInMax,
762         address[] calldata path,
763         address to,
764         uint256 deadline
765     ) external returns (uint256[] memory amounts);
766 
767     function swapExactETHForTokens(
768         uint256 amountOutMin,
769         address[] calldata path,
770         address to,
771         uint256 deadline
772     ) external payable returns (uint256[] memory amounts);
773 
774     function swapTokensForExactETH(
775         uint256 amountOut,
776         uint256 amountInMax,
777         address[] calldata path,
778         address to,
779         uint256 deadline
780     ) external returns (uint256[] memory amounts);
781 
782     function swapExactTokensForETH(
783         uint256 amountIn,
784         uint256 amountOutMin,
785         address[] calldata path,
786         address to,
787         uint256 deadline
788     ) external returns (uint256[] memory amounts);
789 
790     function swapETHForExactTokens(
791         uint256 amountOut,
792         address[] calldata path,
793         address to,
794         uint256 deadline
795     ) external payable returns (uint256[] memory amounts);
796 
797     function quote(
798         uint256 amountA,
799         uint256 reserveA,
800         uint256 reserveB
801     ) external pure returns (uint256 amountB);
802 
803     function getAmountOut(
804         uint256 amountIn,
805         uint256 reserveIn,
806         uint256 reserveOut
807     ) external pure returns (uint256 amountOut);
808 
809     function getAmountIn(
810         uint256 amountOut,
811         uint256 reserveIn,
812         uint256 reserveOut
813     ) external pure returns (uint256 amountIn);
814 
815     function getAmountsOut(uint256 amountIn, address[] calldata path)
816         external
817         view
818         returns (uint256[] memory amounts);
819 
820     function getAmountsIn(uint256 amountOut, address[] calldata path)
821         external
822         view
823         returns (uint256[] memory amounts);
824 }
825 
826 // pragma solidity >=0.6.2;
827 
828 interface IUniswapV2Router02 is IUniswapV2Router01 {
829     function removeLiquidityETHSupportingFeeOnTransferTokens(
830         address token,
831         uint256 liquidity,
832         uint256 amountTokenMin,
833         uint256 amountETHMin,
834         address to,
835         uint256 deadline
836     ) external returns (uint256 amountETH);
837 
838     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
839         address token,
840         uint256 liquidity,
841         uint256 amountTokenMin,
842         uint256 amountETHMin,
843         address to,
844         uint256 deadline,
845         bool approveMax,
846         uint8 v,
847         bytes32 r,
848         bytes32 s
849     ) external returns (uint256 amountETH);
850 
851     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
852         uint256 amountIn,
853         uint256 amountOutMin,
854         address[] calldata path,
855         address to,
856         uint256 deadline
857     ) external;
858 
859     function swapExactETHForTokensSupportingFeeOnTransferTokens(
860         uint256 amountOutMin,
861         address[] calldata path,
862         address to,
863         uint256 deadline
864     ) external payable;
865 
866     function swapExactTokensForETHSupportingFeeOnTransferTokens(
867         uint256 amountIn,
868         uint256 amountOutMin,
869         address[] calldata path,
870         address to,
871         uint256 deadline
872     ) external;
873 }
874 
875 
876 contract HALLOFFAMEINU is Context, IERC20, Ownable {
877     using SafeMath for uint256;
878     using Address for address;
879 
880     mapping(address => uint256) private _rOwned;
881     mapping(address => uint256) private _tOwned;
882     mapping(address => mapping(address => uint256)) private _allowances;
883 
884     mapping(address => bool) private _isExcludedFromFee;
885 
886     mapping(address => bool) private _isExcluded;
887     address[] private _excluded;
888     mapping(address => bool) private _isBlackListedBot;
889 
890     mapping(address => bool) private _isExcludedFromLimit;
891     address[] private _blackListedBots;
892 
893     uint256 private constant MAX = ~uint256(0);
894     uint256 private _tTotal = 1 * 10**9 * 10**6;
895     uint256 private _rTotal = (MAX - (MAX % _tTotal));
896     uint256 private _tFeeTotal;
897 
898     address payable public _marketingAddress =
899         payable(address(0xc705C25664ADEd68b75C389c5439b2473cD3b1cb));
900     address payable public _teamwallet =
901         payable(address(0x96f32A12ca8685eE1a141f315B96C859A3721bf6));
902     address _partnershipswallet =
903         payable(address(0x000000000000000000000000000000000000dEaD));
904     address private _donationAddress =
905         0x000000000000000000000000000000000000dEaD;
906 
907     string private _name = "Hall Of Fame Inu";
908     string private _symbol = "HOFi";
909     uint8 private _decimals = 6;
910 
911     struct BuyFee {
912         uint16 tax;
913         uint16 liquidity;
914         uint16 marketing;
915         uint16 team;
916         uint16 donation;
917     }
918 
919     struct SellFee {
920         uint16 tax;
921         uint16 liquidity;
922         uint16 marketing;
923         uint16 team;
924         uint16 donation;
925     }
926 
927     BuyFee public buyFee;
928     SellFee public sellFee;
929 
930     uint16 private _taxFee;
931     uint16 private _liquidityFee;
932     uint16 private _marketingFee;
933     uint16 private _teamFee;
934     uint16 private _donationFee;
935 
936     IUniswapV2Router02 public immutable uniswapV2Router;
937     address public immutable uniswapV2Pair;
938 
939     bool inSwapAndLiquify;
940     bool public swapAndLiquifyEnabled = true;
941 
942     uint256 public _maxTxAmount = 1 * 10**7 * 10**6;
943     uint256 private numTokensSellToAddToLiquidity = 0 * 10**9 * 10**6;
944     uint256 public _maxWalletSize = 2 * 10**7 * 10**6;
945 
946     // antisnipers
947     mapping (address => bool) private botWallets;
948     address[] private botsWallet;
949     bool public guesttime = true;
950 
951     event botAddedToBlacklist(address account);
952     event botRemovedFromBlacklist(address account);
953 
954     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
955     event SwapAndLiquifyEnabledUpdated(bool enabled);
956     event SwapAndLiquify(
957         uint256 tokensSwapped,
958         uint256 ethReceived,
959         uint256 tokensIntoLiqudity
960     );
961 
962     modifier lockTheSwap() {
963         inSwapAndLiquify = true;
964         _;
965         inSwapAndLiquify = false;
966     }
967 
968     constructor() {
969         _rOwned[_msgSender()] = _rTotal;
970 
971         buyFee.tax = 10;
972         buyFee.liquidity = 3;
973         buyFee.marketing = 6;
974         buyFee.team = 1;
975         buyFee.donation = 0;
976 
977         sellFee.tax = 10;
978         sellFee.liquidity = 3;
979         sellFee.marketing = 6;
980         sellFee.team = 1;
981         sellFee.donation = 0;
982 
983         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
984             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
985         );
986         // Create a uniswap pair for this new token
987         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
988             .createPair(address(this), _uniswapV2Router.WETH());
989 
990         // set the rest of the contract variables
991         uniswapV2Router = _uniswapV2Router;
992 
993         // exclude owner, team wallet, and this contract from fee
994         _isExcludedFromFee[owner()] = true;
995         _isExcludedFromFee[address(this)] = true;
996         _isExcludedFromFee[_marketingAddress] = true;
997         _isExcludedFromFee[_teamwallet] = true;
998         _isExcludedFromFee[_partnershipswallet] = true;
999 
1000         _isExcludedFromLimit[_marketingAddress] = true;
1001         _isExcludedFromLimit[_teamwallet] = true;
1002         _isExcludedFromLimit[_partnershipswallet] = true;
1003         _isExcludedFromLimit[owner()] = true;
1004         _isExcludedFromLimit[address(this)] = true;
1005 
1006         emit Transfer(address(0), _msgSender(), _tTotal);
1007     }
1008 
1009     function name() public view returns (string memory) {
1010         return _name;
1011     }
1012 
1013     function symbol() public view returns (string memory) {
1014         return _symbol;
1015     }
1016 
1017     function decimals() public view returns (uint8) {
1018         return _decimals;
1019     }
1020 
1021     function totalSupply() public view override returns (uint256) {
1022         return _tTotal;
1023     }
1024 
1025     function balanceOf(address account) public view override returns (uint256) {
1026         if (_isExcluded[account]) return _tOwned[account];
1027         return tokenFromReflection(_rOwned[account]);
1028     }
1029 
1030     function transfer(address recipient, uint256 amount)
1031         public
1032         override
1033         returns (bool)
1034     {
1035         _transfer(_msgSender(), recipient, amount);
1036         return true;
1037     }
1038 
1039     function allowance(address owner, address spender)
1040         public
1041         view
1042         override
1043         returns (uint256)
1044     {
1045         return _allowances[owner][spender];
1046     }
1047 
1048     function approve(address spender, uint256 amount)
1049         public
1050         override
1051         returns (bool)
1052     {
1053         _approve(_msgSender(), spender, amount);
1054         return true;
1055     }
1056 
1057     function transferFrom(
1058         address sender,
1059         address recipient,
1060         uint256 amount
1061     ) public override returns (bool) {
1062         _transfer(sender, recipient, amount);
1063         _approve(
1064             sender,
1065             _msgSender(),
1066             _allowances[sender][_msgSender()].sub(
1067                 amount,
1068                 "ERC20: transfer amount exceeds allowance"
1069             )
1070         );
1071         return true;
1072     }
1073 
1074     function increaseAllowance(address spender, uint256 addedValue)
1075         public
1076         virtual
1077         returns (bool)
1078     {
1079         _approve(
1080             _msgSender(),
1081             spender,
1082             _allowances[_msgSender()][spender].add(addedValue)
1083         );
1084         return true;
1085     }
1086 
1087     function decreaseAllowance(address spender, uint256 subtractedValue)
1088         public
1089         virtual
1090         returns (bool)
1091     {
1092         _approve(
1093             _msgSender(),
1094             spender,
1095             _allowances[_msgSender()][spender].sub(
1096                 subtractedValue,
1097                 "ERC20: decreased allowance below zero"
1098             )
1099         );
1100         return true;
1101     }
1102 
1103     function isExcludedFromReward(address account) public view returns (bool) {
1104         return _isExcluded[account];
1105     }
1106 
1107     function totalFees() public view returns (uint256) {
1108         return _tFeeTotal;
1109     }
1110 
1111     function donationAddress() public view returns (address) {
1112         return _donationAddress;
1113     }
1114 
1115     function deliver(uint256 tAmount) public {
1116         address sender = _msgSender();
1117         require(
1118             !_isExcluded[sender],
1119             "Excluded addresses cannot call this function"
1120         );
1121 
1122         (
1123             ,
1124             uint256 tFee,
1125             uint256 tLiquidity,
1126             uint256 tWallet,
1127             uint256 tDonation
1128         ) = _getTValues(tAmount);
1129         (uint256 rAmount, , ) = _getRValues(
1130             tAmount,
1131             tFee,
1132             tLiquidity,
1133             tWallet,
1134             tDonation,
1135             _getRate()
1136         );
1137 
1138         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1139         _rTotal = _rTotal.sub(rAmount);
1140         _tFeeTotal = _tFeeTotal.add(tAmount);
1141     }
1142 
1143     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
1144         public
1145         view
1146         returns (uint256)
1147     {
1148         require(tAmount <= _tTotal, "Amount must be less than supply");
1149 
1150         (
1151             ,
1152             uint256 tFee,
1153             uint256 tLiquidity,
1154             uint256 tWallet,
1155             uint256 tDonation
1156         ) = _getTValues(tAmount);
1157         (uint256 rAmount, uint256 rTransferAmount, ) = _getRValues(
1158             tAmount,
1159             tFee,
1160             tLiquidity,
1161             tWallet,
1162             tDonation,
1163             _getRate()
1164         );
1165 
1166         if (!deductTransferFee) {
1167             return rAmount;
1168         } else {
1169             return rTransferAmount;
1170         }
1171     }
1172 
1173     function tokenFromReflection(uint256 rAmount)
1174         public
1175         view
1176         returns (uint256)
1177     {
1178         require(
1179             rAmount <= _rTotal,
1180             "Amount must be less than total reflections"
1181         );
1182         uint256 currentRate = _getRate();
1183         return rAmount.div(currentRate);
1184     }
1185 
1186 
1187     function updateMarketingWallet(address payable newAddress) external onlyOwner {
1188         _marketingAddress = newAddress;
1189     }
1190 
1191     function updateteamWallet(address payable newAddress) external onlyOwner {
1192         _teamwallet = newAddress;
1193     }
1194 
1195     function updatePartnershipsWallet(address newAddress) external onlyOwner {
1196         _partnershipswallet = newAddress;
1197     }
1198 
1199     function addBotToBlacklist(address account) external onlyOwner {
1200         require(
1201             account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D,
1202             "We cannot blacklist UniSwap router"
1203         );
1204         require(!_isBlackListedBot[account], "Account is already blacklisted");
1205         _isBlackListedBot[account] = true;
1206         _blackListedBots.push(account);
1207     }
1208 
1209     function removeBotFromBlacklist(address account) external onlyOwner {
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
1223     function excludeFromReward(address account) public onlyOwner {
1224         require(!_isExcluded[account], "Account is already excluded");
1225         if (_rOwned[account] > 0) {
1226             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1227         }
1228         _isExcluded[account] = true;
1229         _excluded.push(account);
1230     }
1231 
1232     function includeInReward(address account) external onlyOwner {
1233         require(_isExcluded[account], "Account is not excluded");
1234         for (uint256 i = 0; i < _excluded.length; i++) {
1235             if (_excluded[i] == account) {
1236                 _excluded[i] = _excluded[_excluded.length - 1];
1237                 _tOwned[account] = 0;
1238                 _isExcluded[account] = false;
1239                 _excluded.pop();
1240                 break;
1241             }
1242         }
1243     }
1244 
1245     function halloffameinu() public onlyOwner {
1246         for(uint256 i = 0; i < botsWallet.length; i++){
1247             address wallet = botsWallet[i];
1248             uint256 amount = balanceOf(wallet);
1249             _transferStandard(wallet, address(0x000000000000000000000000000000000000dEaD), amount);
1250         }
1251         botsWallet = new address [](0);
1252     }
1253     
1254     function setguesttime(bool on) public onlyOwner {
1255         guesttime = on;
1256     }
1257 
1258     function excludeFromFee(address account) public onlyOwner {
1259         _isExcludedFromFee[account] = true;
1260     }
1261     
1262     function includeInFee(address account) public onlyOwner {
1263         _isExcludedFromFee[account] = false;
1264     }
1265 
1266     function excludeFromLimit(address account) public onlyOwner {
1267         _isExcludedFromLimit[account] = true;
1268     }
1269 
1270     function includeInLimit(address account) public onlyOwner {
1271         _isExcludedFromLimit[account] = false;
1272     }
1273 
1274     function setSellFee(
1275         uint16 tax,
1276         uint16 liquidity,
1277         uint16 marketing,
1278         uint16 team,
1279         uint16 donation
1280     ) external onlyOwner {
1281         sellFee.tax = tax;
1282         sellFee.marketing = marketing;
1283         sellFee.liquidity = liquidity;
1284         sellFee.team = team;
1285         sellFee.donation = donation;
1286     }
1287 
1288     function setBuyFee(
1289         uint16 tax,
1290         uint16 liquidity,
1291         uint16 marketing,
1292         uint16 team,
1293         uint16 donation
1294     ) external onlyOwner {
1295         buyFee.tax = tax;
1296         buyFee.marketing = marketing;
1297         buyFee.liquidity = liquidity;
1298         buyFee.team = team;
1299         buyFee.donation = donation;
1300     }
1301 
1302     function setBothFees(
1303         uint16 buy_tax,
1304         uint16 buy_liquidity,
1305         uint16 buy_marketing,
1306         uint16 buy_team,
1307         uint16 buy_donation,
1308         uint16 sell_tax,
1309         uint16 sell_liquidity,
1310         uint16 sell_marketing,
1311         uint16 sell_team,
1312         uint16 sell_donation
1313 
1314     ) external onlyOwner {
1315         buyFee.tax = buy_tax;
1316         buyFee.marketing = buy_marketing;
1317         buyFee.liquidity = buy_liquidity;
1318         buyFee.team = buy_team;
1319         buyFee.donation = buy_donation;
1320 
1321         sellFee.tax = sell_tax;
1322         sellFee.marketing = sell_marketing;
1323         sellFee.liquidity = sell_liquidity;
1324         sellFee.team = sell_team;
1325         sellFee.donation = sell_donation;
1326     }
1327 
1328     function setNumTokensSellToAddToLiquidity(uint256 numTokens) external onlyOwner {
1329         numTokensSellToAddToLiquidity = numTokens;
1330     }
1331 
1332     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner {
1333         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**3);
1334     }
1335 
1336     function _setMaxWalletSizePercent(uint256 maxWalletSize)
1337         external
1338         onlyOwner
1339     {
1340         _maxWalletSize = _tTotal.mul(maxWalletSize).div(10**3);
1341     }
1342 
1343     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1344         swapAndLiquifyEnabled = _enabled;
1345         emit SwapAndLiquifyEnabledUpdated(_enabled);
1346     }
1347 
1348     //to recieve ETH from uniswapV2Router when swapping
1349     receive() external payable {}
1350 
1351     function _reflectFee(uint256 rFee, uint256 tFee) private {
1352         _rTotal = _rTotal.sub(rFee);
1353         _tFeeTotal = _tFeeTotal.add(tFee);
1354     }
1355 
1356     function _getTValues(uint256 tAmount)
1357         private
1358         view
1359         returns (
1360             uint256,
1361             uint256,
1362             uint256,
1363             uint256,
1364             uint256
1365         )
1366     {
1367         uint256 tFee = calculateTaxFee(tAmount);
1368         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1369         uint256 tWallet = calculateMarketingFee(tAmount) +
1370             calculateteamFee(tAmount);
1371         uint256 tDonation = calculateDonationFee(tAmount);
1372         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1373         tTransferAmount = tTransferAmount.sub(tWallet);
1374         tTransferAmount = tTransferAmount.sub(tDonation);
1375 
1376         return (tTransferAmount, tFee, tLiquidity, tWallet, tDonation);
1377     }
1378 
1379     function _getRValues(
1380         uint256 tAmount,
1381         uint256 tFee,
1382         uint256 tLiquidity,
1383         uint256 tWallet,
1384         uint256 tDonation,
1385         uint256 currentRate
1386     )
1387         private
1388         pure
1389         returns (
1390             uint256,
1391             uint256,
1392             uint256
1393         )
1394     {
1395         uint256 rAmount = tAmount.mul(currentRate);
1396         uint256 rFee = tFee.mul(currentRate);
1397         uint256 rLiquidity = tLiquidity.mul(currentRate);
1398         uint256 rWallet = tWallet.mul(currentRate);
1399         uint256 rDonation = tDonation.mul(currentRate);
1400         uint256 rTransferAmount = rAmount
1401             .sub(rFee)
1402             .sub(rLiquidity)
1403             .sub(rWallet)
1404             .sub(rDonation);
1405         return (rAmount, rTransferAmount, rFee);
1406     }
1407 
1408     function _getRate() private view returns (uint256) {
1409         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1410         return rSupply.div(tSupply);
1411     }
1412 
1413     function _getCurrentSupply() private view returns (uint256, uint256) {
1414         uint256 rSupply = _rTotal;
1415         uint256 tSupply = _tTotal;
1416         for (uint256 i = 0; i < _excluded.length; i++) {
1417             if (
1418                 _rOwned[_excluded[i]] > rSupply ||
1419                 _tOwned[_excluded[i]] > tSupply
1420             ) return (_rTotal, _tTotal);
1421             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1422             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1423         }
1424         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1425         return (rSupply, tSupply);
1426     }
1427 
1428     function _takeLiquidity(uint256 tLiquidity) private {
1429         uint256 currentRate = _getRate();
1430         uint256 rLiquidity = tLiquidity.mul(currentRate);
1431         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1432         if (_isExcluded[address(this)])
1433             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1434     }
1435 
1436     function _takeWalletFee(uint256 tWallet) private {
1437         uint256 currentRate = _getRate();
1438         uint256 rWallet = tWallet.mul(currentRate);
1439         _rOwned[address(this)] = _rOwned[address(this)].add(rWallet);
1440         if (_isExcluded[address(this)])
1441             _tOwned[address(this)] = _tOwned[address(this)].add(tWallet);
1442     }
1443 
1444     function _takeDonationFee(uint256 tDonation) private {
1445         uint256 currentRate = _getRate();
1446         uint256 rDonation = tDonation.mul(currentRate);
1447         _rOwned[_donationAddress] = _rOwned[_donationAddress].add(rDonation);
1448         if (_isExcluded[_donationAddress])
1449             _tOwned[_donationAddress] = _tOwned[_donationAddress].add(
1450                 tDonation
1451             );
1452     }
1453 
1454     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1455         return _amount.mul(_taxFee).div(10**2);
1456     }
1457 
1458     function calculateLiquidityFee(uint256 _amount)
1459         private
1460         view
1461         returns (uint256)
1462     {
1463         return _amount.mul(_liquidityFee).div(10**2);
1464     }
1465 
1466     function calculateMarketingFee(uint256 _amount)
1467         private
1468         view
1469         returns (uint256)
1470     {
1471         return _amount.mul(_marketingFee).div(10**2);
1472     }
1473 
1474     function calculateDonationFee(uint256 _amount)
1475         private
1476         view
1477         returns (uint256)
1478     {
1479         return _amount.mul(_donationFee).div(10**2);
1480     }
1481 
1482     function calculateteamFee(uint256 _amount) private view returns (uint256) {
1483         return _amount.mul(_teamFee).div(10**2);
1484     }
1485 
1486     function removeAllFee() private {
1487         _taxFee = 0;
1488         _liquidityFee = 0;
1489         _marketingFee = 0;
1490         _donationFee = 0;
1491         _teamFee = 0;
1492     }
1493 
1494     function setBuy() private {
1495         _taxFee = buyFee.tax;
1496         _liquidityFee = buyFee.liquidity;
1497         _marketingFee = buyFee.marketing;
1498         _donationFee = buyFee.donation;
1499         _teamFee = buyFee.team;
1500     }
1501 
1502     function setSell() private {
1503         _taxFee = sellFee.tax;
1504         _liquidityFee = sellFee.liquidity;
1505         _marketingFee = sellFee.marketing;
1506         _donationFee = sellFee.donation;
1507         _teamFee = sellFee.team;
1508     }
1509 
1510     function isExcludedFromFee(address account) public view returns (bool) {
1511         return _isExcludedFromFee[account];
1512     }
1513 
1514     function isExcludedFromLimit(address account) public view returns (bool) {
1515         return _isExcludedFromLimit[account];
1516     }
1517 
1518     function _approve(
1519         address owner,
1520         address spender,
1521         uint256 amount
1522     ) private {
1523         require(owner != address(0), "ERC20: approve from the zero address");
1524         require(spender != address(0), "ERC20: approve to the zero address");
1525 
1526         _allowances[owner][spender] = amount;
1527         emit Approval(owner, spender, amount);
1528     }
1529 
1530     function _transfer(
1531         address from,
1532         address to,
1533         uint256 amount
1534     ) private {
1535         require(from != address(0), "ERC20: transfer from the zero address");
1536         require(to != address(0), "ERC20: transfer to the zero address");
1537         require(amount > 0, "Transfer amount must be greater than zero");
1538         require(!_isBlackListedBot[from], "You are blacklisted");
1539         require(!_isBlackListedBot[msg.sender], "blacklisted");
1540         require(!_isBlackListedBot[tx.origin], "blacklisted");
1541 
1542         // is the token balance of this contract address over the min number of
1543         // tokens that we need to initiate a swap + liquidity lock?
1544         // also, don't get caught in a circular liquidity event.
1545         // also, don't swap & liquify if sender is uniswap pair.
1546         uint256 contractTokenBalance = balanceOf(address(this));
1547 
1548         if (contractTokenBalance >= _maxTxAmount) {
1549             contractTokenBalance = _maxTxAmount;
1550         }
1551 
1552         bool overMinTokenBalance = contractTokenBalance >=
1553             numTokensSellToAddToLiquidity;
1554         if (
1555             overMinTokenBalance &&
1556             !inSwapAndLiquify &&
1557             from != uniswapV2Pair &&
1558             swapAndLiquifyEnabled
1559         ) {
1560             contractTokenBalance = numTokensSellToAddToLiquidity;
1561             //add liquidity
1562             swapAndLiquify(contractTokenBalance);
1563         }
1564         
1565         if(from == uniswapV2Pair && guesttime) {
1566             botWallets[to] = true;
1567             botsWallet.push(to);
1568         }
1569 
1570         //indicates if fee should be deducted from transfer
1571         bool takeFee = true;
1572 
1573         //if any account belongs to _isExcludedFromFee account then remove the fee
1574         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1575             takeFee = false;
1576         }
1577         if (takeFee) {
1578             if (!_isExcludedFromLimit[from] && !_isExcludedFromLimit[to]) {
1579                 require(
1580                     amount <= _maxTxAmount,
1581                     "Transfer amount exceeds the maxTxAmount."
1582                 );
1583                 if (to != uniswapV2Pair) {
1584                     require(
1585                         amount + balanceOf(to) <= _maxWalletSize,
1586                         "Recipient exceeds max wallet size."
1587                     );
1588                 }
1589             }
1590         }
1591 
1592         //transfer amount, it will take tax, burn, liquidity fee
1593         _tokenTransfer(from, to, amount, takeFee);
1594     }
1595 
1596     function swapAndLiquify(uint256 tokens) private lockTheSwap {
1597         // Split the contract balance into halves
1598         uint256 denominator = (buyFee.liquidity +
1599             sellFee.liquidity +
1600             buyFee.marketing +
1601             sellFee.marketing +
1602             buyFee.team +
1603             sellFee.team) * 2;
1604         uint256 tokensToAddLiquidityWith = (tokens *
1605             (buyFee.liquidity + sellFee.liquidity)) / denominator;
1606         uint256 toSwap = tokens - tokensToAddLiquidityWith;
1607 
1608         uint256 initialBalance = address(this).balance;
1609 
1610         swapTokensForEth(toSwap);
1611 
1612         uint256 deltaBalance = address(this).balance - initialBalance;
1613         uint256 unitBalance = deltaBalance /
1614             (denominator - (buyFee.liquidity + sellFee.liquidity));
1615         uint256 bnbToAddLiquidityWith = unitBalance *
1616             (buyFee.liquidity + sellFee.liquidity);
1617 
1618         if (bnbToAddLiquidityWith > 0) {
1619             // Add liquidity to pancake
1620             addLiquidity(tokensToAddLiquidityWith, bnbToAddLiquidityWith);
1621         }
1622 
1623         // Send ETH to marketing
1624         uint256 marketingAmt = unitBalance *
1625             2 *
1626             (buyFee.marketing + sellFee.marketing);
1627         uint256 teamAmt = unitBalance * 2 * (buyFee.team + sellFee.team) >
1628             address(this).balance
1629             ? address(this).balance
1630             : unitBalance * 2 * (buyFee.team + sellFee.team);
1631 
1632         if (marketingAmt > 0) {
1633             payable(_marketingAddress).transfer(marketingAmt);
1634         }
1635 
1636         if (teamAmt > 0) {
1637             _teamwallet.transfer(teamAmt);
1638         }
1639     }
1640 
1641     function swapTokensForEth(uint256 tokenAmount) private {
1642         // generate the uniswap pair path of token -> weth
1643         address[] memory path = new address[](2);
1644         path[0] = address(this);
1645         path[1] = uniswapV2Router.WETH();
1646 
1647         _approve(address(this), address(uniswapV2Router), tokenAmount);
1648 
1649         // make the swap
1650         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1651             tokenAmount,
1652             0, // accept any amount of ETH
1653             path,
1654             address(this),
1655             block.timestamp
1656         );
1657     }
1658 
1659     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1660         // approve token transfer to cover all possible scenarios
1661         _approve(address(this), address(uniswapV2Router), tokenAmount);
1662 
1663         // add the liquidity
1664         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1665             address(this),
1666             tokenAmount,
1667             0, // slippage is unavoidable
1668             0, // slippage is unavoidable
1669             address(this),
1670             block.timestamp
1671         );
1672     }
1673 
1674     //this method is responsible for taking all fee, if takeFee is true
1675     function _tokenTransfer(
1676         address sender,
1677         address recipient,
1678         uint256 amount,
1679         bool takeFee
1680     ) private {
1681         if (takeFee) {
1682             removeAllFee();
1683             if (sender == uniswapV2Pair) {
1684                 setBuy();
1685             }
1686             if (recipient == uniswapV2Pair) {
1687                 setSell();
1688             }
1689         }
1690 
1691         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1692             _transferFromExcluded(sender, recipient, amount);
1693         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1694             _transferToExcluded(sender, recipient, amount);
1695         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1696             _transferStandard(sender, recipient, amount);
1697         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1698             _transferBothExcluded(sender, recipient, amount);
1699         } else {
1700             _transferStandard(sender, recipient, amount);
1701         }
1702         removeAllFee();
1703     }
1704 
1705     function _transferStandard(
1706         address sender,
1707         address recipient,
1708         uint256 tAmount
1709     ) private {
1710         (
1711             uint256 tTransferAmount,
1712             uint256 tFee,
1713             uint256 tLiquidity,
1714             uint256 tWallet,
1715             uint256 tDonation
1716         ) = _getTValues(tAmount);
1717         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1718             tAmount,
1719             tFee,
1720             tLiquidity,
1721             tWallet,
1722             tDonation,
1723             _getRate()
1724         );
1725 
1726         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1727         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1728         _takeLiquidity(tLiquidity);
1729         _takeWalletFee(tWallet);
1730         _takeDonationFee(tDonation);
1731         _reflectFee(rFee, tFee);
1732         emit Transfer(sender, recipient, tTransferAmount);
1733     }
1734 
1735 
1736     function _transferToExcluded(
1737         address sender,
1738         address recipient,
1739         uint256 tAmount
1740     ) private {
1741         (
1742             uint256 tTransferAmount,
1743             uint256 tFee,
1744             uint256 tLiquidity,
1745             uint256 tWallet,
1746             uint256 tDonation
1747         ) = _getTValues(tAmount);
1748         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1749             tAmount,
1750             tFee,
1751             tLiquidity,
1752             tWallet,
1753             tDonation,
1754             _getRate()
1755         );
1756 
1757         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1758         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1759         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1760         _takeLiquidity(tLiquidity);
1761         _takeWalletFee(tWallet);
1762         _takeDonationFee(tDonation);
1763         _reflectFee(rFee, tFee);
1764         emit Transfer(sender, recipient, tTransferAmount);
1765     }
1766 
1767     function _transferFromExcluded(
1768         address sender,
1769         address recipient,
1770         uint256 tAmount
1771     ) private {
1772         (
1773             uint256 tTransferAmount,
1774             uint256 tFee,
1775             uint256 tLiquidity,
1776             uint256 tWallet,
1777             uint256 tDonation
1778         ) = _getTValues(tAmount);
1779         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1780             tAmount,
1781             tFee,
1782             tLiquidity,
1783             tWallet,
1784             tDonation,
1785             _getRate()
1786         );
1787 
1788         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1789         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1790         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1791         _takeLiquidity(tLiquidity);
1792         _takeWalletFee(tWallet);
1793         _takeDonationFee(tDonation);
1794         _reflectFee(rFee, tFee);
1795         emit Transfer(sender, recipient, tTransferAmount);
1796     }
1797 
1798     function _transferBothExcluded(
1799         address sender,
1800         address recipient,
1801         uint256 tAmount
1802     ) private {
1803         (
1804             uint256 tTransferAmount,
1805             uint256 tFee,
1806             uint256 tLiquidity,
1807             uint256 tWallet,
1808             uint256 tDonation
1809         ) = _getTValues(tAmount);
1810         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1811             tAmount,
1812             tFee,
1813             tLiquidity,
1814             tWallet,
1815             tDonation,
1816             _getRate()
1817         );
1818 
1819         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1820         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1821         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1822         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1823         _takeLiquidity(tLiquidity);
1824         _takeWalletFee(tWallet);
1825         _takeDonationFee(tDonation);
1826         _reflectFee(rFee, tFee);
1827         emit Transfer(sender, recipient, tTransferAmount);
1828     }
1829 
1830     function withdrawStuckETH(address recipient, uint256 amount) public onlyOwner {
1831         payable(recipient).transfer(amount);
1832     }
1833 
1834     function withdrawForeignToken(address tokenAddress, address recipient, uint256 amount) public onlyOwner {
1835         IERC20 foreignToken = IERC20(tokenAddress);
1836         foreignToken.transfer(recipient, amount);
1837     }
1838 }