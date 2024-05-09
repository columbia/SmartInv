1 // SAUDI SHIBA INU Ethereum
2 // Telegram: https://t.me/SAUDISHIBAINU
3 // Web: https://saudishibatoken.com/
4 // Twitter: https://twitter.com/saudishibtoken
5 
6 pragma solidity ^0.8.10;
7 
8 // SPDX-License-Identifier: Unlicensed
9 interface IERC20 {
10     function totalSupply() external view returns (uint256);
11 
12     /**
13      * @dev Returns the amount of tokens owned by `account`.
14      */
15     function balanceOf(address account) external view returns (uint256);
16 
17     /**
18      * @dev Moves `amount` tokens from the caller's account to `recipient`.
19      *
20      * Returns a boolean value indicating whether the operation succeeded.
21      *
22      * Emits a {Transfer} event.
23      */
24     function transfer(address recipient, uint256 amount)
25         external
26         returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender)
36         external
37         view
38         returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(
66         address sender,
67         address recipient,
68         uint256 amount
69     ) external returns (bool);
70 
71     /**
72      * @dev Emitted when `value` tokens are moved from one account (`from`) to
73      * another (`to`).
74      *
75      * Note that `value` may be zero.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81      * a call to {approve}. `value` is the new allowance.
82      */
83     event Approval(
84         address indexed owner,
85         address indexed spender,
86         uint256 value
87     );
88 }
89 
90 /**
91  * @dev Wrappers over Solidity's arithmetic operations with added overflow
92  * checks.
93  *
94  * Arithmetic operations in Solidity wrap on overflow. This can easily result
95  * in bugs, because programmers usually assume that an overflow raises an
96  * error, which is the standard behavior in high level programming languages.
97  * `SafeMath` restores this intuition by reverting the transaction when an
98  * operation overflows.
99  *
100  * Using this library instead of the unchecked operations eliminates an entire
101  * class of bugs, so it's recommended to use it always.
102  */
103 
104 library SafeMath {
105     /**
106      * @dev Returns the addition of two unsigned integers, reverting on
107      * overflow.
108      *
109      * Counterpart to Solidity's `+` operator.
110      *
111      * Requirements:
112      *
113      * - Addition cannot overflow.
114      */
115     function add(uint256 a, uint256 b) internal pure returns (uint256) {
116         uint256 c = a + b;
117         require(c >= a, "SafeMath: addition overflow");
118 
119         return c;
120     }
121 
122     /**
123      * @dev Returns the subtraction of two unsigned integers, reverting on
124      * overflow (when the result is negative).
125      *
126      * Counterpart to Solidity's `-` operator.
127      *
128      * Requirements:
129      *
130      * - Subtraction cannot overflow.
131      */
132     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
133         return sub(a, b, "SafeMath: subtraction overflow");
134     }
135 
136     /**
137      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
138      * overflow (when the result is negative).
139      *
140      * Counterpart to Solidity's `-` operator.
141      *
142      * Requirements:
143      *
144      * - Subtraction cannot overflow.
145      */
146     function sub(
147         uint256 a,
148         uint256 b,
149         string memory errorMessage
150     ) internal pure returns (uint256) {
151         require(b <= a, errorMessage);
152         uint256 c = a - b;
153 
154         return c;
155     }
156 
157     /**
158      * @dev Returns the multiplication of two unsigned integers, reverting on
159      * overflow.
160      *
161      * Counterpart to Solidity's `*` operator.
162      *
163      * Requirements:
164      *
165      * - Multiplication cannot overflow.
166      */
167     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
168         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
169         // benefit is lost if 'b' is also tested.
170         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
171         if (a == 0) {
172             return 0;
173         }
174 
175         uint256 c = a * b;
176         require(c / a == b, "SafeMath: multiplication overflow");
177 
178         return c;
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers. Reverts on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(uint256 a, uint256 b) internal pure returns (uint256) {
194         return div(a, b, "SafeMath: division by zero");
195     }
196 
197     /**
198      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
199      * division by zero. The result is rounded towards zero.
200      *
201      * Counterpart to Solidity's `/` operator. Note: this function uses a
202      * `revert` opcode (which leaves remaining gas untouched) while Solidity
203      * uses an invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      *
207      * - The divisor cannot be zero.
208      */
209     function div(
210         uint256 a,
211         uint256 b,
212         string memory errorMessage
213     ) internal pure returns (uint256) {
214         require(b > 0, errorMessage);
215         uint256 c = a / b;
216         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
217 
218         return c;
219     }
220 
221     /**
222      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223      * Reverts when dividing by zero.
224      *
225      * Counterpart to Solidity's `%` operator. This function uses a `revert`
226      * opcode (which leaves remaining gas untouched) while Solidity uses an
227      * invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
234         return mod(a, b, "SafeMath: modulo by zero");
235     }
236 
237     /**
238      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
239      * Reverts with custom message when dividing by zero.
240      *
241      * Counterpart to Solidity's `%` operator. This function uses a `revert`
242      * opcode (which leaves remaining gas untouched) while Solidity uses an
243      * invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      *
247      * - The divisor cannot be zero.
248      */
249     function mod(
250         uint256 a,
251         uint256 b,
252         string memory errorMessage
253     ) internal pure returns (uint256) {
254         require(b != 0, errorMessage);
255         return a % b;
256     }
257 }
258 
259 abstract contract Context {
260     function _msgSender() internal view virtual returns (address payable) {
261         return payable(msg.sender);
262     }
263 
264     function _msgData() internal view virtual returns (bytes memory) {
265         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
266         return msg.data;
267     }
268 }
269 
270 /**
271  * @dev Collection of functions related to the address type
272  */
273 library Address {
274     /**
275      * @dev Returns true if `account` is a contract.
276      *
277      * [IMPORTANT]
278      * ====
279      * It is unsafe to assume that an address for which this function returns
280      * false is an externally-owned account (EOA) and not a contract.
281      *
282      * Among others, `isContract` will return false for the following
283      * types of addresses:
284      *
285      *  - an externally-owned account
286      *  - a contract in construction
287      *  - an address where a contract will be created
288      *  - an address where a contract lived, but was destroyed
289      * ====
290      */
291     function isContract(address account) internal view returns (bool) {
292         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
293         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
294         // for accounts without code, i.e. `keccak256('')`
295         bytes32 codehash;
296         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
297         // solhint-disable-next-line no-inline-assembly
298         assembly {
299             codehash := extcodehash(account)
300         }
301         return (codehash != accountHash && codehash != 0x0);
302     }
303 
304     /**
305      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
306      * `recipient`, forwarding all available gas and reverting on errors.
307      *
308      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
309      * of certain opcodes, possibly making contracts go over the 2300 gas limit
310      * imposed by `transfer`, making them unable to receive funds via
311      * `transfer`. {sendValue} removes this limitation.
312      *
313      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
314      *
315      * IMPORTANT: because control is transferred to `recipient`, care must be
316      * taken to not create reentrancy vulnerabilities. Consider using
317      * {ReentrancyGuard} or the
318      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
319      */
320     function sendValue(address payable recipient, uint256 amount) internal {
321         require(
322             address(this).balance >= amount,
323             "Address: insufficient balance"
324         );
325 
326         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
327         (bool success, ) = recipient.call{value: amount}("");
328         require(
329             success,
330             "Address: unable to send value, recipient may have reverted"
331         );
332     }
333 
334     /**
335      * @dev Performs a Solidity function call using a low level `call`. A
336      * plain`call` is an unsafe replacement for a function call: use this
337      * function instead.
338      *
339      * If `target` reverts with a revert reason, it is bubbled up by this
340      * function (like regular Solidity function calls).
341      *
342      * Returns the raw returned data. To convert to the expected return value,
343      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
344      *
345      * Requirements:
346      *
347      * - `target` must be a contract.
348      * - calling `target` with `data` must not revert.
349      *
350      * _Available since v3.1._
351      */
352     function functionCall(address target, bytes memory data)
353         internal
354         returns (bytes memory)
355     {
356         return functionCall(target, data, "Address: low-level call failed");
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
361      * `errorMessage` as a fallback revert reason when `target` reverts.
362      *
363      * _Available since v3.1._
364      */
365     function functionCall(
366         address target,
367         bytes memory data,
368         string memory errorMessage
369     ) internal returns (bytes memory) {
370         return _functionCallWithValue(target, data, 0, errorMessage);
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
375      * but also transferring `value` wei to `target`.
376      *
377      * Requirements:
378      *
379      * - the calling contract must have an ETH balance of at least `value`.
380      * - the called Solidity function must be `payable`.
381      *
382      * _Available since v3.1._
383      */
384     function functionCallWithValue(
385         address target,
386         bytes memory data,
387         uint256 value
388     ) internal returns (bytes memory) {
389         return
390             functionCallWithValue(
391                 target,
392                 data,
393                 value,
394                 "Address: low-level call with value failed"
395             );
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
400      * with `errorMessage` as a fallback revert reason when `target` reverts.
401      *
402      * _Available since v3.1._
403      */
404     function functionCallWithValue(
405         address target,
406         bytes memory data,
407         uint256 value,
408         string memory errorMessage
409     ) internal returns (bytes memory) {
410         require(
411             address(this).balance >= value,
412             "Address: insufficient balance for call"
413         );
414         return _functionCallWithValue(target, data, value, errorMessage);
415     }
416 
417     function _functionCallWithValue(
418         address target,
419         bytes memory data,
420         uint256 weiValue,
421         string memory errorMessage
422     ) private returns (bytes memory) {
423         require(isContract(target), "Address: call to non-contract");
424 
425         // solhint-disable-next-line avoid-low-level-calls
426         (bool success, bytes memory returndata) = target.call{value: weiValue}(
427             data
428         );
429         if (success) {
430             return returndata;
431         } else {
432             // Look for revert reason and bubble it up if present
433             if (returndata.length > 0) {
434                 // The easiest way to bubble the revert reason is using memory via assembly
435 
436                 // solhint-disable-next-line no-inline-assembly
437                 assembly {
438                     let returndata_size := mload(returndata)
439                     revert(add(32, returndata), returndata_size)
440                 }
441             } else {
442                 revert(errorMessage);
443             }
444         }
445     }
446 }
447 
448 /**
449  * @dev Contract module which provides a basic access control mechanism, where
450  * there is an account (an owner) that can be granted exclusive access to
451  * specific functions.
452  *
453  * By default, the owner account will be the one that deploys the contract. This
454  * can later be changed with {transferOwnership}.
455  *
456  * This module is used through inheritance. It will make available the modifier
457  * `onlyOwner`, which can be applied to your functions to restrict their use to
458  * the owner.
459  */
460 contract Ownable is Context {
461     address private _owner;
462     address private _previousOwner;
463     uint256 private _lockTime;
464 
465     event OwnershipTransferred(
466         address indexed previousOwner,
467         address indexed newOwner
468     );
469 
470     /**
471      * @dev Initializes the contract setting the deployer as the initial owner.
472      */
473     constructor() {
474         address msgSender = _msgSender();
475         _owner = msgSender;
476         emit OwnershipTransferred(address(0), msgSender);
477     }
478 
479     /**
480      * @dev Returns the address of the current owner.
481      */
482     function owner() public view returns (address) {
483         return _owner;
484     }
485 
486     /**
487      * @dev Throws if called by any account other than the owner.
488      */
489     modifier onlyOwner() {
490         require(_owner == _msgSender(), "Ownable: caller is not the owner");
491         _;
492     }
493 
494     /**
495      * @dev Leaves the contract without owner. It will not be possible to call
496      * `onlyOwner` functions anymore. Can only be called by the current owner.
497      *
498      * NOTE: Renouncing ownership will leave the contract without an owner,
499      * thereby removing any functionality that is only available to the owner.
500      */
501     function renounceOwnership() public virtual onlyOwner {
502         emit OwnershipTransferred(_owner, address(0));
503         _owner = address(0);
504     }
505 
506     /**
507      * @dev Transfers ownership of the contract to a new account (`newOwner`).
508      * Can only be called by the current owner.
509      */
510     function transferOwnership(address newOwner) public virtual onlyOwner {
511         require(
512             newOwner != address(0),
513             "Ownable: new owner is the zero address"
514         );
515         emit OwnershipTransferred(_owner, newOwner);
516         _owner = newOwner;
517     }
518 
519     function geUnlockTime() public view returns (uint256) {
520         return _lockTime;
521     }
522 
523     //Locks the contract for owner for the amount of time provided
524     function lock(uint256 time) public virtual onlyOwner {
525         _previousOwner = _owner;
526         _owner = address(0);
527         _lockTime = block.timestamp + time;
528         emit OwnershipTransferred(_owner, address(0));
529     }
530 
531     //Unlocks the contract for owner when _lockTime is exceeds
532     function unlock() public virtual {
533         require(
534             _previousOwner == msg.sender,
535             "You don't have permission to unlock"
536         );
537         require(block.timestamp > _lockTime, "Contract is locked until a later date");
538         emit OwnershipTransferred(_owner, _previousOwner);
539         _owner = _previousOwner;
540         _previousOwner = address(0);
541     }
542 }
543 
544 /**
545  * @title TokenRecover
546  * @author Vittorio Minacori (https://github.com/vittominacori)
547  * @dev Allows owner to recover any ERC20 sent into the contract
548  */
549 contract TokenRecover is Ownable {
550 
551     using Address for address payable;
552     /**
553      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
554      * @param tokenAddress The token contract address
555      * @param tokenAmount Number of tokens to be sent
556      */
557     function recoverERC20(address tokenAddress, uint256 tokenAmount) public virtual onlyOwner {
558         IERC20(tokenAddress).transfer(owner(), tokenAmount);
559     }
560 
561     function recoverETH(address account, uint256 amount) public virtual onlyOwner {
562         payable(account).sendValue(amount);
563     }
564 }
565 
566 // pragma solidity >=0.5.0;
567 
568 interface IUniswapV2Factory {
569     event PairCreated(
570         address indexed token0,
571         address indexed token1,
572         address pair,
573         uint256
574     );
575 
576     function feeTo() external view returns (address);
577 
578     function feeToSetter() external view returns (address);
579 
580     function getPair(address tokenA, address tokenB)
581         external
582         view
583         returns (address pair);
584 
585     function allPairs(uint256) external view returns (address pair);
586 
587     function allPairsLength() external view returns (uint256);
588 
589     function createPair(address tokenA, address tokenB)
590         external
591         returns (address pair);
592 
593     function setFeeTo(address) external;
594 
595     function setFeeToSetter(address) external;
596 }
597 
598 // pragma solidity >=0.5.0;
599 
600 interface IUniswapV2Pair {
601     event Approval(
602         address indexed owner,
603         address indexed spender,
604         uint256 value
605     );
606     event Transfer(address indexed from, address indexed to, uint256 value);
607 
608     function name() external pure returns (string memory);
609 
610     function symbol() external pure returns (string memory);
611 
612     function decimals() external pure returns (uint8);
613 
614     function totalSupply() external view returns (uint256);
615 
616     function balanceOf(address owner) external view returns (uint256);
617 
618     function allowance(address owner, address spender)
619         external
620         view
621         returns (uint256);
622 
623     function approve(address spender, uint256 value) external returns (bool);
624 
625     function transfer(address to, uint256 value) external returns (bool);
626 
627     function transferFrom(
628         address from,
629         address to,
630         uint256 value
631     ) external returns (bool);
632 
633     function DOMAIN_SEPARATOR() external view returns (bytes32);
634 
635     function PERMIT_TYPEHASH() external pure returns (bytes32);
636 
637     function nonces(address owner) external view returns (uint256);
638 
639     function permit(
640         address owner,
641         address spender,
642         uint256 value,
643         uint256 deadline,
644         uint8 v,
645         bytes32 r,
646         bytes32 s
647     ) external;
648 
649     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
650     event Burn(
651         address indexed sender,
652         uint256 amount0,
653         uint256 amount1,
654         address indexed to
655     );
656     event Swap(
657         address indexed sender,
658         uint256 amount0In,
659         uint256 amount1In,
660         uint256 amount0Out,
661         uint256 amount1Out,
662         address indexed to
663     );
664     event Sync(uint112 reserve0, uint112 reserve1);
665 
666     function MINIMUM_LIQUIDITY() external pure returns (uint256);
667 
668     function factory() external view returns (address);
669 
670     function token0() external view returns (address);
671 
672     function token1() external view returns (address);
673 
674     function getReserves()
675         external
676         view
677         returns (
678             uint112 reserve0,
679             uint112 reserve1,
680             uint32 blockTimestampLast
681         );
682 
683     function price0CumulativeLast() external view returns (uint256);
684 
685     function price1CumulativeLast() external view returns (uint256);
686 
687     function kLast() external view returns (uint256);
688 
689     function mint(address to) external returns (uint256 liquidity);
690 
691     function burn(address to)
692         external
693         returns (uint256 amount0, uint256 amount1);
694 
695     function swap(
696         uint256 amount0Out,
697         uint256 amount1Out,
698         address to,
699         bytes calldata data
700     ) external;
701 
702     function skim(address to) external;
703 
704     function sync() external;
705 
706     function initialize(address, address) external;
707 }
708 
709 // pragma solidity >=0.6.2;
710 
711 interface IUniswapV2Router01 {
712     function factory() external pure returns (address);
713 
714     function WETH() external pure returns (address);
715 
716     function addLiquidity(
717         address tokenA,
718         address tokenB,
719         uint256 amountADesired,
720         uint256 amountBDesired,
721         uint256 amountAMin,
722         uint256 amountBMin,
723         address to,
724         uint256 deadline
725     )
726         external
727         returns (
728             uint256 amountA,
729             uint256 amountB,
730             uint256 liquidity
731         );
732 
733     function addLiquidityETH(
734         address token,
735         uint256 amountTokenDesired,
736         uint256 amountTokenMin,
737         uint256 amountETHMin,
738         address to,
739         uint256 deadline
740     )
741         external
742         payable
743         returns (
744             uint256 amountToken,
745             uint256 amountETH,
746             uint256 liquidity
747         );
748 
749     function removeLiquidity(
750         address tokenA,
751         address tokenB,
752         uint256 liquidity,
753         uint256 amountAMin,
754         uint256 amountBMin,
755         address to,
756         uint256 deadline
757     ) external returns (uint256 amountA, uint256 amountB);
758 
759     function removeLiquidityETH(
760         address token,
761         uint256 liquidity,
762         uint256 amountTokenMin,
763         uint256 amountETHMin,
764         address to,
765         uint256 deadline
766     ) external returns (uint256 amountToken, uint256 amountETH);
767 
768     function removeLiquidityWithPermit(
769         address tokenA,
770         address tokenB,
771         uint256 liquidity,
772         uint256 amountAMin,
773         uint256 amountBMin,
774         address to,
775         uint256 deadline,
776         bool approveMax,
777         uint8 v,
778         bytes32 r,
779         bytes32 s
780     ) external returns (uint256 amountA, uint256 amountB);
781 
782     function removeLiquidityETHWithPermit(
783         address token,
784         uint256 liquidity,
785         uint256 amountTokenMin,
786         uint256 amountETHMin,
787         address to,
788         uint256 deadline,
789         bool approveMax,
790         uint8 v,
791         bytes32 r,
792         bytes32 s
793     ) external returns (uint256 amountToken, uint256 amountETH);
794 
795     function swapExactTokensForTokens(
796         uint256 amountIn,
797         uint256 amountOutMin,
798         address[] calldata path,
799         address to,
800         uint256 deadline
801     ) external returns (uint256[] memory amounts);
802 
803     function swapTokensForExactTokens(
804         uint256 amountOut,
805         uint256 amountInMax,
806         address[] calldata path,
807         address to,
808         uint256 deadline
809     ) external returns (uint256[] memory amounts);
810 
811     function swapExactETHForTokens(
812         uint256 amountOutMin,
813         address[] calldata path,
814         address to,
815         uint256 deadline
816     ) external payable returns (uint256[] memory amounts);
817 
818     function swapTokensForExactETH(
819         uint256 amountOut,
820         uint256 amountInMax,
821         address[] calldata path,
822         address to,
823         uint256 deadline
824     ) external returns (uint256[] memory amounts);
825 
826     function swapExactTokensForETH(
827         uint256 amountIn,
828         uint256 amountOutMin,
829         address[] calldata path,
830         address to,
831         uint256 deadline
832     ) external returns (uint256[] memory amounts);
833 
834     function swapETHForExactTokens(
835         uint256 amountOut,
836         address[] calldata path,
837         address to,
838         uint256 deadline
839     ) external payable returns (uint256[] memory amounts);
840 
841     function quote(
842         uint256 amountA,
843         uint256 reserveA,
844         uint256 reserveB
845     ) external pure returns (uint256 amountB);
846 
847     function getAmountOut(
848         uint256 amountIn,
849         uint256 reserveIn,
850         uint256 reserveOut
851     ) external pure returns (uint256 amountOut);
852 
853     function getAmountIn(
854         uint256 amountOut,
855         uint256 reserveIn,
856         uint256 reserveOut
857     ) external pure returns (uint256 amountIn);
858 
859     function getAmountsOut(uint256 amountIn, address[] calldata path)
860         external
861         view
862         returns (uint256[] memory amounts);
863 
864     function getAmountsIn(uint256 amountOut, address[] calldata path)
865         external
866         view
867         returns (uint256[] memory amounts);
868 }
869 
870 // pragma solidity >=0.6.2;
871 
872 interface IUniswapV2Router02 is IUniswapV2Router01 {
873     function removeLiquidityETHSupportingFeeOnTransferTokens(
874         address token,
875         uint256 liquidity,
876         uint256 amountTokenMin,
877         uint256 amountETHMin,
878         address to,
879         uint256 deadline
880     ) external returns (uint256 amountETH);
881 
882     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
883         address token,
884         uint256 liquidity,
885         uint256 amountTokenMin,
886         uint256 amountETHMin,
887         address to,
888         uint256 deadline,
889         bool approveMax,
890         uint8 v,
891         bytes32 r,
892         bytes32 s
893     ) external returns (uint256 amountETH);
894 
895     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
896         uint256 amountIn,
897         uint256 amountOutMin,
898         address[] calldata path,
899         address to,
900         uint256 deadline
901     ) external;
902 
903     function swapExactETHForTokensSupportingFeeOnTransferTokens(
904         uint256 amountOutMin,
905         address[] calldata path,
906         address to,
907         uint256 deadline
908     ) external payable;
909 
910     function swapExactTokensForETHSupportingFeeOnTransferTokens(
911         uint256 amountIn,
912         uint256 amountOutMin,
913         address[] calldata path,
914         address to,
915         uint256 deadline
916     ) external;
917 }
918 
919 contract SaudiShibaInu is Context, IERC20, Ownable, TokenRecover {
920     using SafeMath for uint256;
921     using Address for address;
922 
923     mapping(address => uint256) private _rOwned;
924     mapping(address => uint256) private _tOwned;
925     mapping(address => mapping(address => uint256)) private _allowances;
926 
927     mapping(address => bool) private _isExcludedFromFee;
928 
929     mapping(address => bool) private _isExcluded;
930     address[] private _excluded;
931     mapping(address => bool) private _isBlackListedBot;
932 
933     mapping(address => bool) private _isExcludedFromLimit;
934     address[] private _blackListedBots;
935 
936     uint256 private constant MAX = ~uint256(0);
937     uint256 private _tTotal = 1000000000 * 10**6 * 10**8;
938     uint256 private _rTotal = (MAX - (MAX % _tTotal));
939     uint256 private _tFeeTotal;
940 
941 
942     string private _name = "SAUDI SHIBA INU";
943     string private _symbol = "SAUDISHIB";
944     uint8 private _decimals = 8;
945 
946     struct BuyFee {
947         uint8 tax;
948         uint8 liquidity;
949     }
950 
951     struct SellFee {
952         uint8 tax;
953         uint8 liquidity;
954     }
955 
956     BuyFee public buyFee;
957     SellFee public sellFee;
958 
959     uint8 private _taxFee;
960     uint8 private _liquidityFee;
961 
962     IUniswapV2Router02 public uniswapV2Router;
963     address public uniswapV2Pair;
964 
965     bool inSwapAndLiquify;
966     bool public swapAndLiquifyEnabled = true;
967 
968     uint256 public _maxTxAmount = 1000000000 * 10**6 * 10**8;
969     uint256 private numTokensSellToAddToLiquidity = 500000 * 10**6 * 10**8;
970     uint256 public _maxWalletSize = 1 * 10**13 * 10**8;
971 
972     event botAddedToBlacklist(address account);
973     event botRemovedFromBlacklist(address account);
974 
975     event SwapAndLiquifyEnabledUpdated(bool enabled);
976     event SwapAndLiquify(
977         uint256 tokensSwapped,
978         uint256 ethReceived,
979         uint256 tokensIntoLiqudity
980     );
981     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
982 
983     modifier lockTheSwap() {
984         inSwapAndLiquify = true;
985         _;
986         inSwapAndLiquify = false;
987     }
988 
989     constructor() {
990         _rOwned[_msgSender()] = _rTotal;
991 
992         buyFee.tax = 2;
993         buyFee.liquidity = 8;
994 
995         sellFee.tax = 2;
996         sellFee.liquidity = 8;
997 
998         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
999         // Create a uniswap pair for this new token
1000         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
1001 
1002         // set the rest of the contract variables
1003         uniswapV2Router = _uniswapV2Router;
1004 
1005         // exclude owner, dev wallet, and this contract from fee
1006         _isExcludedFromFee[owner()] = true;
1007         _isExcludedFromFee[address(this)] = true;
1008 
1009         _isExcludedFromLimit[owner()] = true;
1010         _isExcludedFromLimit[address(this)] = true;
1011 
1012         emit Transfer(address(0), _msgSender(), _tTotal);
1013     }
1014 
1015     function name() public view returns (string memory) {
1016         return _name;
1017     }
1018 
1019     function symbol() public view returns (string memory) {
1020         return _symbol;
1021     }
1022 
1023     function decimals() public view returns (uint8) {
1024         return _decimals;
1025     }
1026 
1027     function totalSupply() public view override returns (uint256) {
1028         return _tTotal;
1029     }
1030 
1031     function balanceOf(address account) public view override returns (uint256) {
1032         if (_isExcluded[account]) return _tOwned[account];
1033         return tokenFromReflection(_rOwned[account]);
1034     }
1035 
1036     function transfer(address recipient, uint256 amount)
1037         public
1038         override
1039         returns (bool)
1040     {
1041         _transfer(_msgSender(), recipient, amount);
1042         return true;
1043     }
1044 
1045     function allowance(address owner, address spender)
1046         public
1047         view
1048         override
1049         returns (uint256)
1050     {
1051         return _allowances[owner][spender];
1052     }
1053 
1054     function approve(address spender, uint256 amount)
1055         public
1056         override
1057         returns (bool)
1058     {
1059         _approve(_msgSender(), spender, amount);
1060         return true;
1061     }
1062 
1063     function transferFrom(
1064         address sender,
1065         address recipient,
1066         uint256 amount
1067     ) public override returns (bool) {
1068         _transfer(sender, recipient, amount);
1069         _approve(
1070             sender,
1071             _msgSender(),
1072             _allowances[sender][_msgSender()].sub(
1073                 amount,
1074                 "ERC20: transfer amount exceeds allowance"
1075             )
1076         );
1077         return true;
1078     }
1079 
1080     function increaseAllowance(address spender, uint256 addedValue)
1081         public
1082         virtual
1083         returns (bool)
1084     {
1085         _approve(
1086             _msgSender(),
1087             spender,
1088             _allowances[_msgSender()][spender].add(addedValue)
1089         );
1090         return true;
1091     }
1092 
1093     function decreaseAllowance(address spender, uint256 subtractedValue)
1094         public
1095         virtual
1096         returns (bool)
1097     {
1098         _approve(
1099             _msgSender(),
1100             spender,
1101             _allowances[_msgSender()][spender].sub(
1102                 subtractedValue,
1103                 "ERC20: decreased allowance below zero"
1104             )
1105         );
1106         return true;
1107     }
1108 
1109     function isExcludedFromReward(address account) public view returns (bool) {
1110         return _isExcluded[account];
1111     }
1112 
1113     function totalFees() public view returns (uint256) {
1114         return _tFeeTotal;
1115     }
1116 
1117     function deliver(uint256 tAmount) public {
1118         address sender = _msgSender();
1119         require(
1120             !_isExcluded[sender],
1121             "Excluded addresses cannot call this function"
1122         );
1123 
1124         (
1125             ,
1126             uint256 tFee,
1127             uint256 tLiquidity
1128         ) = _getTValues(tAmount);
1129         (uint256 rAmount, , ) = _getRValues(
1130             tAmount,
1131             tFee,
1132             tLiquidity,
1133             _getRate()
1134         );
1135 
1136         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1137         _rTotal = _rTotal.sub(rAmount);
1138         _tFeeTotal = _tFeeTotal.add(tAmount);
1139     }
1140 
1141     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
1142         public
1143         view
1144         returns (uint256)
1145     {
1146         require(tAmount <= _tTotal, "Amount must be less than supply");
1147 
1148         (
1149             ,
1150             uint256 tFee,
1151             uint256 tLiquidity
1152         ) = _getTValues(tAmount);
1153         (uint256 rAmount, uint256 rTransferAmount, ) = _getRValues(
1154             tAmount,
1155             tFee,
1156             tLiquidity,
1157             _getRate()
1158         );
1159 
1160         if (!deductTransferFee) {
1161             return rAmount;
1162         } else {
1163             return rTransferAmount;
1164         }
1165     }
1166 
1167     function tokenFromReflection(uint256 rAmount)
1168         public
1169         view
1170         returns (uint256)
1171     {
1172         require(
1173             rAmount <= _rTotal,
1174             "Amount must be less than total reflections"
1175         );
1176         uint256 currentRate = _getRate();
1177         return rAmount.div(currentRate);
1178     }
1179 
1180 
1181     function addBotToBlacklist(address account) external onlyOwner {
1182         require(
1183             account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D,
1184             "We cannot blacklist UniSwap router"
1185         );
1186         require(!_isBlackListedBot[account], "Account is already blacklisted");
1187         _isBlackListedBot[account] = true;
1188         _blackListedBots.push(account);
1189 
1190         emit botAddedToBlacklist(account);
1191     }
1192 
1193         function isBotBlacklisted(address account) public view returns(bool) {
1194             return _isBlackListedBot[account];
1195     }
1196 
1197     function removeBotFromBlacklist(address account) external onlyOwner {
1198         require(_isBlackListedBot[account], "Account is not blacklisted");
1199         for (uint256 i = 0; i < _blackListedBots.length; i++) {
1200             if (_blackListedBots[i] == account) {
1201                 _blackListedBots[i] = _blackListedBots[
1202                     _blackListedBots.length - 1
1203                 ];
1204                 _isBlackListedBot[account] = false;
1205                 _blackListedBots.pop();
1206                 break;
1207             }
1208         }
1209         emit botRemovedFromBlacklist(account);
1210     }
1211 
1212     function excludeFromReward(address account) public onlyOwner {
1213         require(!_isExcluded[account], "Account is already excluded");
1214         if (_rOwned[account] > 0) {
1215             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1216         }
1217         _isExcluded[account] = true;
1218         _excluded.push(account);
1219     }
1220 
1221     function includeInReward(address account) external onlyOwner {
1222         require(_isExcluded[account], "Account is not excluded");
1223         for (uint256 i = 0; i < _excluded.length; i++) {
1224             if (_excluded[i] == account) {
1225                 _excluded[i] = _excluded[_excluded.length - 1];
1226                 _tOwned[account] = 0;
1227                 _isExcluded[account] = false;
1228                 _excluded.pop();
1229                 break;
1230             }
1231         }
1232     }
1233 
1234     function excludeFromFee(address account) public onlyOwner {
1235         _isExcludedFromFee[account] = true;
1236     }
1237 
1238     function includeInFee(address account) public onlyOwner {
1239         _isExcludedFromFee[account] = false;
1240     }
1241 
1242     function excludeFromLimit(address account) public onlyOwner {
1243         _isExcludedFromLimit[account] = true;
1244     }
1245 
1246     function includeInLimit(address account) public onlyOwner {
1247         _isExcludedFromLimit[account] = false;
1248     }
1249 
1250     function setSellFee(
1251         uint8 tax,
1252         uint8 liquidity
1253     ) external onlyOwner {
1254         sellFee.tax = tax;
1255         sellFee.liquidity = liquidity;
1256     }
1257 
1258     function setBuyFee(
1259         uint8 tax,
1260         uint8 liquidity
1261     ) external onlyOwner {
1262         buyFee.tax = tax;
1263         buyFee.liquidity = liquidity;
1264     }
1265 
1266 
1267     function setNumTokensSellToAddToLiquidity(uint256 numTokens) external onlyOwner {
1268         numTokensSellToAddToLiquidity = numTokens;
1269     }
1270 
1271     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner {
1272         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
1273     }
1274 
1275     function _setMaxWalletSizePercent(uint256 maxWalletSize)
1276         external
1277         onlyOwner
1278     {
1279         _maxWalletSize = _tTotal.mul(maxWalletSize).div(10**2);
1280     }
1281 
1282     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1283         swapAndLiquifyEnabled = _enabled;
1284         emit SwapAndLiquifyEnabledUpdated(_enabled);
1285     }
1286 
1287     //to receive ETH from uniswapV2Router when swapping
1288     receive() external payable {}
1289 
1290     function _reflectFee(uint256 rFee, uint256 tFee) private {
1291         _rTotal = _rTotal.sub(rFee);
1292         _tFeeTotal = _tFeeTotal.add(tFee);
1293     }
1294 
1295     function _getTValues(uint256 tAmount)
1296         private
1297         view
1298         returns (
1299             uint256,
1300             uint256,
1301             uint256
1302         )
1303     {
1304         uint256 tFee = calculateTaxFee(tAmount);
1305         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1306         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1307 
1308         return (tTransferAmount, tFee, tLiquidity);
1309     }
1310 
1311     function _getRValues(
1312         uint256 tAmount,
1313         uint256 tFee,
1314         uint256 tLiquidity,
1315         uint256 currentRate
1316     )
1317         private
1318         pure
1319         returns (
1320             uint256,
1321             uint256,
1322             uint256
1323         )
1324     {
1325         uint256 rAmount = tAmount.mul(currentRate);
1326         uint256 rFee = tFee.mul(currentRate);
1327         uint256 rLiquidity = tLiquidity.mul(currentRate);
1328         uint256 rTransferAmount = rAmount
1329             .sub(rFee)
1330             .sub(rLiquidity);
1331         return (rAmount, rTransferAmount, rFee);
1332     }
1333 
1334     function _getRate() private view returns (uint256) {
1335         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1336         return rSupply.div(tSupply);
1337     }
1338 
1339     function _getCurrentSupply() private view returns (uint256, uint256) {
1340         uint256 rSupply = _rTotal;
1341         uint256 tSupply = _tTotal;
1342         for (uint256 i = 0; i < _excluded.length; i++) {
1343             if (
1344                 _rOwned[_excluded[i]] > rSupply ||
1345                 _tOwned[_excluded[i]] > tSupply
1346             ) return (_rTotal, _tTotal);
1347             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1348             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1349         }
1350         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1351         return (rSupply, tSupply);
1352     }
1353 
1354     function _takeLiquidity(uint256 tLiquidity) private {
1355         uint256 currentRate = _getRate();
1356         uint256 rLiquidity = tLiquidity.mul(currentRate);
1357         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1358         if (_isExcluded[address(this)])
1359             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1360     }
1361 
1362     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1363         return _amount.mul(_taxFee).div(10**2);
1364     }
1365 
1366     function calculateLiquidityFee(uint256 _amount)
1367         private
1368         view
1369         returns (uint256)
1370     {
1371         return _amount.mul(_liquidityFee).div(10**2);
1372     }
1373 
1374     function removeAllFee() private {
1375         if (_taxFee == 0 && _liquidityFee == 0) return;
1376 
1377         _taxFee = 0;
1378         _liquidityFee = 0;
1379     }
1380 
1381     function setBuy() private {
1382         _taxFee = buyFee.tax;
1383         _liquidityFee = buyFee.liquidity;
1384 
1385     }
1386 
1387     function setSell() private {
1388         _taxFee = sellFee.tax;
1389         _liquidityFee = sellFee.liquidity;
1390     }
1391 
1392     function isExcludedFromFee(address account) public view returns (bool) {
1393         return _isExcludedFromFee[account];
1394     }
1395 
1396     function isExcludedFromLimit(address account) public view returns (bool) {
1397         return _isExcludedFromLimit[account];
1398     }
1399 
1400     function _approve(
1401         address owner,
1402         address spender,
1403         uint256 amount
1404     ) private {
1405         require(owner != address(0), "ERC20: approve from the zero address");
1406         require(spender != address(0), "ERC20: approve to the zero address");
1407 
1408         _allowances[owner][spender] = amount;
1409         emit Approval(owner, spender, amount);
1410     }
1411 
1412     function _transfer(
1413         address from,
1414         address to,
1415         uint256 amount
1416     ) private {
1417         require(from != address(0), "ERC20: transfer from the zero address");
1418         require(to != address(0), "ERC20: transfer to the zero address");
1419         require(amount > 0, "Transfer amount must be greater than zero");
1420         require(!_isBlackListedBot[from], "from is blacklisted");
1421         require(!_isBlackListedBot[msg.sender], "you are blacklisted");
1422         require(!_isBlackListedBot[tx.origin], "blacklisted");
1423 
1424         if (!_isExcludedFromLimit[from] && !_isExcludedFromLimit[to]) { 
1425             require(amount <= _maxTxAmount,"Transfer amount exceeds the maxTxAmount.");
1426             
1427             if(to != uniswapV2Pair) { 
1428                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
1429             }
1430         }
1431 
1432 
1433         // is the token balance of this contract address over the min number of
1434         // tokens that we need to initiate a swap + liquidity lock?
1435         // also, don't get caught in a circular liquidity event.
1436         // also, don't swap & liquify if sender is uniswap pair.
1437         uint256 contractTokenBalance = balanceOf(address(this));
1438 
1439         if (contractTokenBalance >= _maxTxAmount) {
1440             contractTokenBalance = _maxTxAmount;
1441         }
1442 
1443         bool overMinTokenBalance = contractTokenBalance >=
1444             numTokensSellToAddToLiquidity;
1445         if (
1446             overMinTokenBalance &&
1447             !inSwapAndLiquify &&
1448             from != uniswapV2Pair &&
1449             swapAndLiquifyEnabled
1450         ) {
1451             contractTokenBalance = numTokensSellToAddToLiquidity;
1452             //add liquidity
1453             swapAndLiquify(contractTokenBalance);
1454         }
1455 
1456         //indicates if fee should be deducted from transfer
1457         bool takeFee = true;
1458 
1459         //if any account belongs to _isExcludedFromFee account then remove the fee
1460         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
1461             takeFee = false;
1462         } else {
1463             //Set Fee for Buys
1464             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
1465                 setBuy();
1466             }
1467             //Set Fee for Sells
1468             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
1469                 setSell();
1470             }
1471         }
1472 
1473         //transfer amount, it will take tax, burn, liquidity fee
1474         _tokenTransfer(from, to, amount, takeFee);
1475     }
1476 
1477     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1478         // split the contract balance into halves
1479         uint256 half = contractTokenBalance.div(2);
1480         uint256 otherHalf = contractTokenBalance.sub(half);
1481 
1482         // capture the contract's current ETH balance.
1483         // this is so that we can capture exactly the amount of ETH that the
1484         // swap creates, and not make the liquidity event include any ETH that
1485         // has been manually sent to the contract
1486         uint256 initialBalance = address(this).balance;
1487 
1488         // swap tokens for ETH
1489         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1490 
1491         // how much ETH did we just swap into?
1492         uint256 newBalance = address(this).balance.sub(initialBalance);
1493 
1494         // add liquidity to uniswap
1495         addLiquidity(otherHalf, newBalance);
1496 
1497         emit SwapAndLiquify(half, newBalance, otherHalf);
1498     }
1499 
1500     function swapTokensForEth(uint256 tokenAmount) private {
1501         // generate the uniswap pair path of token -> weth
1502         address[] memory path = new address[](2);
1503         path[0] = address(this);
1504         path[1] = uniswapV2Router.WETH();
1505 
1506         _approve(address(this), address(uniswapV2Router), tokenAmount);
1507 
1508         // make the swap
1509         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1510             tokenAmount,
1511             0, // accept any amount of ETH
1512             path,
1513             address(this),
1514             block.timestamp
1515         );
1516     }
1517 
1518     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1519         // approve token transfer to cover all possible scenarios
1520         _approve(address(this), address(uniswapV2Router), tokenAmount);
1521 
1522         // add the liquidity
1523         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1524             address(this),
1525             tokenAmount,
1526             0, // slippage is unavoidable
1527             0, // slippage is unavoidable
1528             owner(),
1529             block.timestamp
1530         );
1531     }
1532 
1533     //this method is responsible for taking all fee, if takeFee is true
1534     function _tokenTransfer(
1535         address sender,
1536         address recipient,
1537         uint256 amount,
1538         bool takeFee
1539     ) private {
1540         if (!takeFee)
1541             removeAllFee();
1542 
1543         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1544             _transferFromExcluded(sender, recipient, amount);
1545         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1546             _transferToExcluded(sender, recipient, amount);
1547         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1548             _transferStandard(sender, recipient, amount);
1549         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1550             _transferBothExcluded(sender, recipient, amount);
1551         } else {
1552             _transferStandard(sender, recipient, amount);
1553         }
1554         removeAllFee();
1555     }
1556 
1557     function _transferStandard(
1558         address sender,
1559         address recipient,
1560         uint256 tAmount
1561     ) private {
1562         (
1563             uint256 tTransferAmount,
1564             uint256 tFee,
1565             uint256 tLiquidity
1566         ) = _getTValues(tAmount);
1567         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1568             tAmount,
1569             tFee,
1570             tLiquidity,
1571             _getRate()
1572         );
1573 
1574         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1575         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1576         _takeLiquidity(tLiquidity);
1577         _reflectFee(rFee, tFee);
1578         emit Transfer(sender, recipient, tTransferAmount);
1579     }
1580 
1581 
1582     function _transferToExcluded(
1583         address sender,
1584         address recipient,
1585         uint256 tAmount
1586     ) private {
1587         (
1588             uint256 tTransferAmount,
1589             uint256 tFee,
1590             uint256 tLiquidity
1591         ) = _getTValues(tAmount);
1592         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1593             tAmount,
1594             tFee,
1595             tLiquidity,
1596             _getRate()
1597         );
1598 
1599         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1600         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1601         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1602         _takeLiquidity(tLiquidity);
1603         _reflectFee(rFee, tFee);
1604         emit Transfer(sender, recipient, tTransferAmount);
1605     }
1606 
1607     function _transferFromExcluded(
1608         address sender,
1609         address recipient,
1610         uint256 tAmount
1611     ) private {
1612         (
1613             uint256 tTransferAmount,
1614             uint256 tFee,
1615             uint256 tLiquidity
1616         ) = _getTValues(tAmount);
1617         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1618             tAmount,
1619             tFee,
1620             tLiquidity,
1621             _getRate()
1622         );
1623 
1624         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1625         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1626         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1627         _takeLiquidity(tLiquidity);
1628         _reflectFee(rFee, tFee);
1629         emit Transfer(sender, recipient, tTransferAmount);
1630     }
1631 
1632     function _transferBothExcluded(
1633         address sender,
1634         address recipient,
1635         uint256 tAmount
1636     ) private {
1637         (
1638             uint256 tTransferAmount,
1639             uint256 tFee,
1640             uint256 tLiquidity
1641         ) = _getTValues(tAmount);
1642         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1643             tAmount,
1644             tFee,
1645             tLiquidity,
1646             _getRate()
1647         );
1648 
1649         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1650         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1651         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1652         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1653         _takeLiquidity(tLiquidity);
1654         _reflectFee(rFee, tFee);
1655         emit Transfer(sender, recipient, tTransferAmount);
1656     }
1657 }