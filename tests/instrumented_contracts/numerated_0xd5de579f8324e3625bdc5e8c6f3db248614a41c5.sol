1 /*
2 
3 ███████╗██╗  ██╗██╗██████╗  ██████╗ ███╗   ██╗███████╗    ██╗███╗   ██╗██╗   ██╗
4 ██╔════╝██║  ██║██║██╔══██╗██╔═══██╗████╗  ██║██╔════╝    ██║████╗  ██║██║   ██║
5 ███████╗███████║██║██████╔╝██║   ██║██╔██╗ ██║█████╗      ██║██╔██╗ ██║██║   ██║
6 ╚════██║██╔══██║██║██╔══██╗██║   ██║██║╚██╗██║██╔══╝      ██║██║╚██╗██║██║   ██║
7 ███████║██║  ██║██║██████╔╝╚██████╔╝██║ ╚████║███████╗    ██║██║ ╚████║╚██████╔╝
8 ╚══════╝╚═╝  ╚═╝╚═╝╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝    ╚═╝╚═╝  ╚═══╝ ╚═════╝ 
9 
10 
11 Telegram: https://t.me/SHIBONETOKEN
12 Web: https://shibonetoken.com
13 Twitter: https://twitter.com/shibonetoken
14 
15 */
16 
17 pragma solidity ^0.8.10;
18 
19 // SPDX-License-Identifier: Unlicensed
20 interface IERC20 {
21     function totalSupply() external view returns (uint256);
22 
23     /**
24      * @dev Returns the amount of tokens owned by `account`.
25      */
26     function balanceOf(address account) external view returns (uint256);
27 
28     /**
29      * @dev Moves `amount` tokens from the caller's account to `recipient`.
30      *
31      * Returns a boolean value indicating whether the operation succeeded.
32      *
33      * Emits a {Transfer} event.
34      */
35     function transfer(address recipient, uint256 amount)
36         external
37         returns (bool);
38 
39     /**
40      * @dev Returns the remaining number of tokens that `spender` will be
41      * allowed to spend on behalf of `owner` through {transferFrom}. This is
42      * zero by default.
43      *
44      * This value changes when {approve} or {transferFrom} are called.
45      */
46     function allowance(address owner, address spender)
47         external
48         view
49         returns (uint256);
50 
51     /**
52      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * IMPORTANT: Beware that changing an allowance with this method brings the risk
57      * that someone may use both the old and the new allowance by unfortunate
58      * transaction ordering. One possible solution to mitigate this race
59      * condition is to first reduce the spender's allowance to 0 and set the
60      * desired value afterwards:
61      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
62      *
63      * Emits an {Approval} event.
64      */
65     function approve(address spender, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Moves `amount` tokens from `sender` to `recipient` using the
69      * allowance mechanism. `amount` is then deducted from the caller's
70      * allowance.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * Emits a {Transfer} event.
75      */
76     function transferFrom(
77         address sender,
78         address recipient,
79         uint256 amount
80     ) external returns (bool);
81 
82     /**
83      * @dev Emitted when `value` tokens are moved from one account (`from`) to
84      * another (`to`).
85      *
86      * Note that `value` may be zero.
87      */
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 
90     /**
91      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
92      * a call to {approve}. `value` is the new allowance.
93      */
94     event Approval(
95         address indexed owner,
96         address indexed spender,
97         uint256 value
98     );
99 }
100 
101 /**
102  * @dev Wrappers over Solidity's arithmetic operations with added overflow
103  * checks.
104  *
105  * Arithmetic operations in Solidity wrap on overflow. This can easily result
106  * in bugs, because programmers usually assume that an overflow raises an
107  * error, which is the standard behavior in high level programming languages.
108  * `SafeMath` restores this intuition by reverting the transaction when an
109  * operation overflows.
110  *
111  * Using this library instead of the unchecked operations eliminates an entire
112  * class of bugs, so it's recommended to use it always.
113  */
114 
115 library SafeMath {
116     /**
117      * @dev Returns the addition of two unsigned integers, reverting on
118      * overflow.
119      *
120      * Counterpart to Solidity's `+` operator.
121      *
122      * Requirements:
123      *
124      * - Addition cannot overflow.
125      */
126     function add(uint256 a, uint256 b) internal pure returns (uint256) {
127         uint256 c = a + b;
128         require(c >= a, "SafeMath: addition overflow");
129 
130         return c;
131     }
132 
133     /**
134      * @dev Returns the subtraction of two unsigned integers, reverting on
135      * overflow (when the result is negative).
136      *
137      * Counterpart to Solidity's `-` operator.
138      *
139      * Requirements:
140      *
141      * - Subtraction cannot overflow.
142      */
143     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
144         return sub(a, b, "SafeMath: subtraction overflow");
145     }
146 
147     /**
148      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
149      * overflow (when the result is negative).
150      *
151      * Counterpart to Solidity's `-` operator.
152      *
153      * Requirements:
154      *
155      * - Subtraction cannot overflow.
156      */
157     function sub(
158         uint256 a,
159         uint256 b,
160         string memory errorMessage
161     ) internal pure returns (uint256) {
162         require(b <= a, errorMessage);
163         uint256 c = a - b;
164 
165         return c;
166     }
167 
168     /**
169      * @dev Returns the multiplication of two unsigned integers, reverting on
170      * overflow.
171      *
172      * Counterpart to Solidity's `*` operator.
173      *
174      * Requirements:
175      *
176      * - Multiplication cannot overflow.
177      */
178     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
179         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
180         // benefit is lost if 'b' is also tested.
181         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
182         if (a == 0) {
183             return 0;
184         }
185 
186         uint256 c = a * b;
187         require(c / a == b, "SafeMath: multiplication overflow");
188 
189         return c;
190     }
191 
192     /**
193      * @dev Returns the integer division of two unsigned integers. Reverts on
194      * division by zero. The result is rounded towards zero.
195      *
196      * Counterpart to Solidity's `/` operator. Note: this function uses a
197      * `revert` opcode (which leaves remaining gas untouched) while Solidity
198      * uses an invalid opcode to revert (consuming all remaining gas).
199      *
200      * Requirements:
201      *
202      * - The divisor cannot be zero.
203      */
204     function div(uint256 a, uint256 b) internal pure returns (uint256) {
205         return div(a, b, "SafeMath: division by zero");
206     }
207 
208     /**
209      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
210      * division by zero. The result is rounded towards zero.
211      *
212      * Counterpart to Solidity's `/` operator. Note: this function uses a
213      * `revert` opcode (which leaves remaining gas untouched) while Solidity
214      * uses an invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function div(
221         uint256 a,
222         uint256 b,
223         string memory errorMessage
224     ) internal pure returns (uint256) {
225         require(b > 0, errorMessage);
226         uint256 c = a / b;
227         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
228 
229         return c;
230     }
231 
232     /**
233      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
234      * Reverts when dividing by zero.
235      *
236      * Counterpart to Solidity's `%` operator. This function uses a `revert`
237      * opcode (which leaves remaining gas untouched) while Solidity uses an
238      * invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
245         return mod(a, b, "SafeMath: modulo by zero");
246     }
247 
248     /**
249      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
250      * Reverts with custom message when dividing by zero.
251      *
252      * Counterpart to Solidity's `%` operator. This function uses a `revert`
253      * opcode (which leaves remaining gas untouched) while Solidity uses an
254      * invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      *
258      * - The divisor cannot be zero.
259      */
260     function mod(
261         uint256 a,
262         uint256 b,
263         string memory errorMessage
264     ) internal pure returns (uint256) {
265         require(b != 0, errorMessage);
266         return a % b;
267     }
268 }
269 
270 abstract contract Context {
271     function _msgSender() internal view virtual returns (address payable) {
272         return payable(msg.sender);
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
548         require(block.timestamp > _lockTime, "Contract is locked until a later date");
549         emit OwnershipTransferred(_owner, _previousOwner);
550         _owner = _previousOwner;
551         _previousOwner = address(0);
552     }
553 }
554 
555 /**
556  * @title TokenRecover
557  * @author Vittorio Minacori (https://github.com/vittominacori)
558  * @dev Allows owner to recover any ERC20 sent into the contract
559  */
560 contract TokenRecover is Ownable {
561 
562     using Address for address payable;
563     /**
564      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
565      * @param tokenAddress The token contract address
566      * @param tokenAmount Number of tokens to be sent
567      */
568     function recoverERC20(address tokenAddress, uint256 tokenAmount) public virtual onlyOwner {
569         IERC20(tokenAddress).transfer(owner(), tokenAmount);
570     }
571 
572     function recoverETH(address account, uint256 amount) public virtual onlyOwner {
573         payable(account).sendValue(amount);
574     }
575 }
576 
577 // pragma solidity >=0.5.0;
578 
579 interface IUniswapV2Factory {
580     event PairCreated(
581         address indexed token0,
582         address indexed token1,
583         address pair,
584         uint256
585     );
586 
587     function feeTo() external view returns (address);
588 
589     function feeToSetter() external view returns (address);
590 
591     function getPair(address tokenA, address tokenB)
592         external
593         view
594         returns (address pair);
595 
596     function allPairs(uint256) external view returns (address pair);
597 
598     function allPairsLength() external view returns (uint256);
599 
600     function createPair(address tokenA, address tokenB)
601         external
602         returns (address pair);
603 
604     function setFeeTo(address) external;
605 
606     function setFeeToSetter(address) external;
607 }
608 
609 // pragma solidity >=0.5.0;
610 
611 interface IUniswapV2Pair {
612     event Approval(
613         address indexed owner,
614         address indexed spender,
615         uint256 value
616     );
617     event Transfer(address indexed from, address indexed to, uint256 value);
618 
619     function name() external pure returns (string memory);
620 
621     function symbol() external pure returns (string memory);
622 
623     function decimals() external pure returns (uint8);
624 
625     function totalSupply() external view returns (uint256);
626 
627     function balanceOf(address owner) external view returns (uint256);
628 
629     function allowance(address owner, address spender)
630         external
631         view
632         returns (uint256);
633 
634     function approve(address spender, uint256 value) external returns (bool);
635 
636     function transfer(address to, uint256 value) external returns (bool);
637 
638     function transferFrom(
639         address from,
640         address to,
641         uint256 value
642     ) external returns (bool);
643 
644     function DOMAIN_SEPARATOR() external view returns (bytes32);
645 
646     function PERMIT_TYPEHASH() external pure returns (bytes32);
647 
648     function nonces(address owner) external view returns (uint256);
649 
650     function permit(
651         address owner,
652         address spender,
653         uint256 value,
654         uint256 deadline,
655         uint8 v,
656         bytes32 r,
657         bytes32 s
658     ) external;
659 
660     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
661     event Burn(
662         address indexed sender,
663         uint256 amount0,
664         uint256 amount1,
665         address indexed to
666     );
667     event Swap(
668         address indexed sender,
669         uint256 amount0In,
670         uint256 amount1In,
671         uint256 amount0Out,
672         uint256 amount1Out,
673         address indexed to
674     );
675     event Sync(uint112 reserve0, uint112 reserve1);
676 
677     function MINIMUM_LIQUIDITY() external pure returns (uint256);
678 
679     function factory() external view returns (address);
680 
681     function token0() external view returns (address);
682 
683     function token1() external view returns (address);
684 
685     function getReserves()
686         external
687         view
688         returns (
689             uint112 reserve0,
690             uint112 reserve1,
691             uint32 blockTimestampLast
692         );
693 
694     function price0CumulativeLast() external view returns (uint256);
695 
696     function price1CumulativeLast() external view returns (uint256);
697 
698     function kLast() external view returns (uint256);
699 
700     function mint(address to) external returns (uint256 liquidity);
701 
702     function burn(address to)
703         external
704         returns (uint256 amount0, uint256 amount1);
705 
706     function swap(
707         uint256 amount0Out,
708         uint256 amount1Out,
709         address to,
710         bytes calldata data
711     ) external;
712 
713     function skim(address to) external;
714 
715     function sync() external;
716 
717     function initialize(address, address) external;
718 }
719 
720 // pragma solidity >=0.6.2;
721 
722 interface IUniswapV2Router01 {
723     function factory() external pure returns (address);
724 
725     function WETH() external pure returns (address);
726 
727     function addLiquidity(
728         address tokenA,
729         address tokenB,
730         uint256 amountADesired,
731         uint256 amountBDesired,
732         uint256 amountAMin,
733         uint256 amountBMin,
734         address to,
735         uint256 deadline
736     )
737         external
738         returns (
739             uint256 amountA,
740             uint256 amountB,
741             uint256 liquidity
742         );
743 
744     function addLiquidityETH(
745         address token,
746         uint256 amountTokenDesired,
747         uint256 amountTokenMin,
748         uint256 amountETHMin,
749         address to,
750         uint256 deadline
751     )
752         external
753         payable
754         returns (
755             uint256 amountToken,
756             uint256 amountETH,
757             uint256 liquidity
758         );
759 
760     function removeLiquidity(
761         address tokenA,
762         address tokenB,
763         uint256 liquidity,
764         uint256 amountAMin,
765         uint256 amountBMin,
766         address to,
767         uint256 deadline
768     ) external returns (uint256 amountA, uint256 amountB);
769 
770     function removeLiquidityETH(
771         address token,
772         uint256 liquidity,
773         uint256 amountTokenMin,
774         uint256 amountETHMin,
775         address to,
776         uint256 deadline
777     ) external returns (uint256 amountToken, uint256 amountETH);
778 
779     function removeLiquidityWithPermit(
780         address tokenA,
781         address tokenB,
782         uint256 liquidity,
783         uint256 amountAMin,
784         uint256 amountBMin,
785         address to,
786         uint256 deadline,
787         bool approveMax,
788         uint8 v,
789         bytes32 r,
790         bytes32 s
791     ) external returns (uint256 amountA, uint256 amountB);
792 
793     function removeLiquidityETHWithPermit(
794         address token,
795         uint256 liquidity,
796         uint256 amountTokenMin,
797         uint256 amountETHMin,
798         address to,
799         uint256 deadline,
800         bool approveMax,
801         uint8 v,
802         bytes32 r,
803         bytes32 s
804     ) external returns (uint256 amountToken, uint256 amountETH);
805 
806     function swapExactTokensForTokens(
807         uint256 amountIn,
808         uint256 amountOutMin,
809         address[] calldata path,
810         address to,
811         uint256 deadline
812     ) external returns (uint256[] memory amounts);
813 
814     function swapTokensForExactTokens(
815         uint256 amountOut,
816         uint256 amountInMax,
817         address[] calldata path,
818         address to,
819         uint256 deadline
820     ) external returns (uint256[] memory amounts);
821 
822     function swapExactETHForTokens(
823         uint256 amountOutMin,
824         address[] calldata path,
825         address to,
826         uint256 deadline
827     ) external payable returns (uint256[] memory amounts);
828 
829     function swapTokensForExactETH(
830         uint256 amountOut,
831         uint256 amountInMax,
832         address[] calldata path,
833         address to,
834         uint256 deadline
835     ) external returns (uint256[] memory amounts);
836 
837     function swapExactTokensForETH(
838         uint256 amountIn,
839         uint256 amountOutMin,
840         address[] calldata path,
841         address to,
842         uint256 deadline
843     ) external returns (uint256[] memory amounts);
844 
845     function swapETHForExactTokens(
846         uint256 amountOut,
847         address[] calldata path,
848         address to,
849         uint256 deadline
850     ) external payable returns (uint256[] memory amounts);
851 
852     function quote(
853         uint256 amountA,
854         uint256 reserveA,
855         uint256 reserveB
856     ) external pure returns (uint256 amountB);
857 
858     function getAmountOut(
859         uint256 amountIn,
860         uint256 reserveIn,
861         uint256 reserveOut
862     ) external pure returns (uint256 amountOut);
863 
864     function getAmountIn(
865         uint256 amountOut,
866         uint256 reserveIn,
867         uint256 reserveOut
868     ) external pure returns (uint256 amountIn);
869 
870     function getAmountsOut(uint256 amountIn, address[] calldata path)
871         external
872         view
873         returns (uint256[] memory amounts);
874 
875     function getAmountsIn(uint256 amountOut, address[] calldata path)
876         external
877         view
878         returns (uint256[] memory amounts);
879 }
880 
881 // pragma solidity >=0.6.2;
882 
883 interface IUniswapV2Router02 is IUniswapV2Router01 {
884     function removeLiquidityETHSupportingFeeOnTransferTokens(
885         address token,
886         uint256 liquidity,
887         uint256 amountTokenMin,
888         uint256 amountETHMin,
889         address to,
890         uint256 deadline
891     ) external returns (uint256 amountETH);
892 
893     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
894         address token,
895         uint256 liquidity,
896         uint256 amountTokenMin,
897         uint256 amountETHMin,
898         address to,
899         uint256 deadline,
900         bool approveMax,
901         uint8 v,
902         bytes32 r,
903         bytes32 s
904     ) external returns (uint256 amountETH);
905 
906     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
907         uint256 amountIn,
908         uint256 amountOutMin,
909         address[] calldata path,
910         address to,
911         uint256 deadline
912     ) external;
913 
914     function swapExactETHForTokensSupportingFeeOnTransferTokens(
915         uint256 amountOutMin,
916         address[] calldata path,
917         address to,
918         uint256 deadline
919     ) external payable;
920 
921     function swapExactTokensForETHSupportingFeeOnTransferTokens(
922         uint256 amountIn,
923         uint256 amountOutMin,
924         address[] calldata path,
925         address to,
926         uint256 deadline
927     ) external;
928 }
929 
930 contract ShiboneInu is Context, IERC20, Ownable, TokenRecover {
931     using SafeMath for uint256;
932     using Address for address;
933 
934     mapping(address => uint256) private _rOwned;
935     mapping(address => uint256) private _tOwned;
936     mapping(address => mapping(address => uint256)) private _allowances;
937 
938     mapping(address => bool) private _isExcludedFromFee;
939 
940     mapping(address => bool) private _isExcluded;
941     address[] private _excluded;
942     mapping(address => bool) private _isWalletAddedToList;
943 
944     mapping(address => bool) private _isExcludedFromLimit;
945     address[] private _listedWallets;
946 
947     uint256 private constant MAX = ~uint256(0);
948     uint256 private _tTotal = 1000000000 * 10**6 * 10**8;
949     uint256 private _rTotal = (MAX - (MAX % _tTotal));
950     uint256 private _tFeeTotal;
951 
952 
953     string private _name = "SHIBONE INU";
954     string private _symbol = "SHIBONE";
955     uint8 private _decimals = 8;
956 
957     struct BuyFee {
958         uint8 tax;
959         uint8 liquidity;
960     }
961 
962     struct SellFee {
963         uint8 tax;
964         uint8 liquidity;
965     }
966 
967     BuyFee public buyFee;
968     SellFee public sellFee;
969 
970     uint8 private _taxFee;
971     uint8 private _liquidityFee;
972 
973     IUniswapV2Router02 public uniswapV2Router;
974     address public uniswapV2Pair;
975 
976     bool inSwapAndLiquify;
977     bool public swapAndLiquifyEnabled = true;
978 
979     uint256 public _maxTxAmount = 1000000000 * 10**6 * 10**8;
980     uint256 private numTokensSellToAddToLiquidity = 500000 * 10**6 * 10**8;
981     uint256 public _maxWalletSize = 1 * 10**13 * 10**8;
982 
983     event walletAddedToList(address account);
984     event walletRemovedFromList(address account);
985 
986     event SwapAndLiquifyEnabledUpdated(bool enabled);
987     event SwapAndLiquify(
988         uint256 tokensSwapped,
989         uint256 ethReceived,
990         uint256 tokensIntoLiqudity
991     );
992     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
993 
994     modifier lockTheSwap() {
995         inSwapAndLiquify = true;
996         _;
997         inSwapAndLiquify = false;
998     }
999 
1000     constructor() {
1001         _rOwned[_msgSender()] = _rTotal;
1002 
1003         buyFee.tax = 2;
1004         buyFee.liquidity = 8;
1005 
1006         sellFee.tax = 2;
1007         sellFee.liquidity = 8;
1008 
1009         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1010         // Create a uniswap pair for this new token
1011         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
1012 
1013         // set the rest of the contract variables
1014         uniswapV2Router = _uniswapV2Router;
1015 
1016         // exclude owner, dev wallet, and this contract from fee
1017         _isExcludedFromFee[owner()] = true;
1018         _isExcludedFromFee[address(this)] = true;
1019 
1020         _isExcludedFromLimit[owner()] = true;
1021         _isExcludedFromLimit[address(this)] = true;
1022 
1023         emit Transfer(address(0), _msgSender(), _tTotal);
1024     }
1025 
1026     function name() public view returns (string memory) {
1027         return _name;
1028     }
1029 
1030     function symbol() public view returns (string memory) {
1031         return _symbol;
1032     }
1033 
1034     function decimals() public view returns (uint8) {
1035         return _decimals;
1036     }
1037 
1038     function totalSupply() public view override returns (uint256) {
1039         return _tTotal;
1040     }
1041 
1042     function balanceOf(address account) public view override returns (uint256) {
1043         if (_isExcluded[account]) return _tOwned[account];
1044         return tokenFromReflection(_rOwned[account]);
1045     }
1046 
1047     function transfer(address recipient, uint256 amount)
1048         public
1049         override
1050         returns (bool)
1051     {
1052         _transfer(_msgSender(), recipient, amount);
1053         return true;
1054     }
1055 
1056     function allowance(address owner, address spender)
1057         public
1058         view
1059         override
1060         returns (uint256)
1061     {
1062         return _allowances[owner][spender];
1063     }
1064 
1065     function approve(address spender, uint256 amount)
1066         public
1067         override
1068         returns (bool)
1069     {
1070         _approve(_msgSender(), spender, amount);
1071         return true;
1072     }
1073 
1074     function transferFrom(
1075         address sender,
1076         address recipient,
1077         uint256 amount
1078     ) public override returns (bool) {
1079         _transfer(sender, recipient, amount);
1080         _approve(
1081             sender,
1082             _msgSender(),
1083             _allowances[sender][_msgSender()].sub(
1084                 amount,
1085                 "ERC20: transfer amount exceeds allowance"
1086             )
1087         );
1088         return true;
1089     }
1090 
1091     function increaseAllowance(address spender, uint256 addedValue)
1092         public
1093         virtual
1094         returns (bool)
1095     {
1096         _approve(
1097             _msgSender(),
1098             spender,
1099             _allowances[_msgSender()][spender].add(addedValue)
1100         );
1101         return true;
1102     }
1103 
1104     function decreaseAllowance(address spender, uint256 subtractedValue)
1105         public
1106         virtual
1107         returns (bool)
1108     {
1109         _approve(
1110             _msgSender(),
1111             spender,
1112             _allowances[_msgSender()][spender].sub(
1113                 subtractedValue,
1114                 "ERC20: decreased allowance below zero"
1115             )
1116         );
1117         return true;
1118     }
1119 
1120     function isExcludedFromReward(address account) public view returns (bool) {
1121         return _isExcluded[account];
1122     }
1123 
1124     function totalFees() public view returns (uint256) {
1125         return _tFeeTotal;
1126     }
1127 
1128     function deliver(uint256 tAmount) public {
1129         address sender = _msgSender();
1130         require(
1131             !_isExcluded[sender],
1132             "Excluded addresses cannot call this function"
1133         );
1134 
1135         (
1136             ,
1137             uint256 tFee,
1138             uint256 tLiquidity
1139         ) = _getTValues(tAmount);
1140         (uint256 rAmount, , ) = _getRValues(
1141             tAmount,
1142             tFee,
1143             tLiquidity,
1144             _getRate()
1145         );
1146 
1147         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1148         _rTotal = _rTotal.sub(rAmount);
1149         _tFeeTotal = _tFeeTotal.add(tAmount);
1150     }
1151 
1152     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
1153         public
1154         view
1155         returns (uint256)
1156     {
1157         require(tAmount <= _tTotal, "Amount must be less than supply");
1158 
1159         (
1160             ,
1161             uint256 tFee,
1162             uint256 tLiquidity
1163         ) = _getTValues(tAmount);
1164         (uint256 rAmount, uint256 rTransferAmount, ) = _getRValues(
1165             tAmount,
1166             tFee,
1167             tLiquidity,
1168             _getRate()
1169         );
1170 
1171         if (!deductTransferFee) {
1172             return rAmount;
1173         } else {
1174             return rTransferAmount;
1175         }
1176     }
1177 
1178     function tokenFromReflection(uint256 rAmount)
1179         public
1180         view
1181         returns (uint256)
1182     {
1183         require(
1184             rAmount <= _rTotal,
1185             "Amount must be less than total reflections"
1186         );
1187         uint256 currentRate = _getRate();
1188         return rAmount.div(currentRate);
1189     }
1190 
1191 
1192     function addWalletToList(address account) external onlyOwner {
1193         require(
1194             account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D,
1195             "We cannot list the UniSwap router"
1196         );
1197         require(!_isWalletAddedToList[account], "Account is already on the list");
1198         _isWalletAddedToList[account] = true;
1199         _listedWallets.push(account);
1200 
1201         emit walletAddedToList(account);
1202     }
1203 
1204         function isWalletOnTheList(address account) public view returns(bool) {
1205             return _isWalletAddedToList[account];
1206     }
1207 
1208     function removeWalletFromList(address account) external onlyOwner {
1209         require(_isWalletAddedToList[account], "Account is not on the list");
1210         for (uint256 i = 0; i < _listedWallets.length; i++) {
1211             if (_listedWallets[i] == account) {
1212                 _listedWallets[i] = _listedWallets[
1213                     _listedWallets.length - 1
1214                 ];
1215                 _isWalletAddedToList[account] = false;
1216                 _listedWallets.pop();
1217                 break;
1218             }
1219         }
1220         emit walletRemovedFromList(account);
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
1245     function excludeFromFee(address account) public onlyOwner {
1246         _isExcludedFromFee[account] = true;
1247     }
1248 
1249     function includeInFee(address account) public onlyOwner {
1250         _isExcludedFromFee[account] = false;
1251     }
1252 
1253     function excludeFromLimit(address account) public onlyOwner {
1254         _isExcludedFromLimit[account] = true;
1255     }
1256 
1257     function includeInLimit(address account) public onlyOwner {
1258         _isExcludedFromLimit[account] = false;
1259     }
1260 
1261     function setSellFee(
1262         uint8 tax,
1263         uint8 liquidity
1264     ) external onlyOwner {
1265         sellFee.tax = tax;
1266         sellFee.liquidity = liquidity;
1267     }
1268 
1269     function setBuyFee(
1270         uint8 tax,
1271         uint8 liquidity
1272     ) external onlyOwner {
1273         buyFee.tax = tax;
1274         buyFee.liquidity = liquidity;
1275     }
1276 
1277 
1278     function setNumTokensSellToAddToLiquidity(uint256 numTokens) external onlyOwner {
1279         numTokensSellToAddToLiquidity = numTokens;
1280     }
1281 
1282     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner {
1283         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
1284     }
1285 
1286     function _setMaxWalletSizePercent(uint256 maxWalletSize)
1287         external
1288         onlyOwner
1289     {
1290         _maxWalletSize = _tTotal.mul(maxWalletSize).div(10**2);
1291     }
1292 
1293     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1294         swapAndLiquifyEnabled = _enabled;
1295         emit SwapAndLiquifyEnabledUpdated(_enabled);
1296     }
1297 
1298     //to receive ETH from uniswapV2Router when swapping
1299     receive() external payable {}
1300 
1301     function _reflectFee(uint256 rFee, uint256 tFee) private {
1302         _rTotal = _rTotal.sub(rFee);
1303         _tFeeTotal = _tFeeTotal.add(tFee);
1304     }
1305 
1306     function _getTValues(uint256 tAmount)
1307         private
1308         view
1309         returns (
1310             uint256,
1311             uint256,
1312             uint256
1313         )
1314     {
1315         uint256 tFee = calculateTaxFee(tAmount);
1316         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1317         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1318 
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
1339         uint256 rTransferAmount = rAmount
1340             .sub(rFee)
1341             .sub(rLiquidity);
1342         return (rAmount, rTransferAmount, rFee);
1343     }
1344 
1345     function _getRate() private view returns (uint256) {
1346         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1347         return rSupply.div(tSupply);
1348     }
1349 
1350     function _getCurrentSupply() private view returns (uint256, uint256) {
1351         uint256 rSupply = _rTotal;
1352         uint256 tSupply = _tTotal;
1353         for (uint256 i = 0; i < _excluded.length; i++) {
1354             if (
1355                 _rOwned[_excluded[i]] > rSupply ||
1356                 _tOwned[_excluded[i]] > tSupply
1357             ) return (_rTotal, _tTotal);
1358             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1359             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1360         }
1361         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1362         return (rSupply, tSupply);
1363     }
1364 
1365     function _takeLiquidity(uint256 tLiquidity) private {
1366         uint256 currentRate = _getRate();
1367         uint256 rLiquidity = tLiquidity.mul(currentRate);
1368         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1369         if (_isExcluded[address(this)])
1370             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1371     }
1372 
1373     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1374         return _amount.mul(_taxFee).div(10**2);
1375     }
1376 
1377     function calculateLiquidityFee(uint256 _amount)
1378         private
1379         view
1380         returns (uint256)
1381     {
1382         return _amount.mul(_liquidityFee).div(10**2);
1383     }
1384 
1385     function removeAllFee() private {
1386         if (_taxFee == 0 && _liquidityFee == 0) return;
1387 
1388         _taxFee = 0;
1389         _liquidityFee = 0;
1390     }
1391 
1392     function setBuy() private {
1393         _taxFee = buyFee.tax;
1394         _liquidityFee = buyFee.liquidity;
1395 
1396     }
1397 
1398     function setSell() private {
1399         _taxFee = sellFee.tax;
1400         _liquidityFee = sellFee.liquidity;
1401     }
1402 
1403     function isExcludedFromFee(address account) public view returns (bool) {
1404         return _isExcludedFromFee[account];
1405     }
1406 
1407     function isExcludedFromLimit(address account) public view returns (bool) {
1408         return _isExcludedFromLimit[account];
1409     }
1410 
1411     function _approve(
1412         address owner,
1413         address spender,
1414         uint256 amount
1415     ) private {
1416         require(owner != address(0), "ERC20: approve from the zero address");
1417         require(spender != address(0), "ERC20: approve to the zero address");
1418 
1419         _allowances[owner][spender] = amount;
1420         emit Approval(owner, spender, amount);
1421     }
1422 
1423     function _transfer(
1424         address from,
1425         address to,
1426         uint256 amount
1427     ) private {
1428         require(from != address(0), "ERC20: transfer from the zero address");
1429         require(to != address(0), "ERC20: transfer to the zero address");
1430         require(amount > 0, "Transfer amount must be greater than zero");
1431         require(!_isWalletAddedToList[from], "from is on the list");
1432         require(!_isWalletAddedToList[msg.sender], "you are on the list");
1433         require(!_isWalletAddedToList[tx.origin], "listed");
1434 
1435         if (!_isExcludedFromLimit[from] && !_isExcludedFromLimit[to]) { 
1436             require(amount <= _maxTxAmount,"Transfer amount exceeds the maxTxAmount.");
1437             
1438             if(to != uniswapV2Pair) { 
1439                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
1440             }
1441         }
1442 
1443 
1444         // is the token balance of this contract address over the min number of
1445         // tokens that we need to initiate a swap + liquidity lock?
1446         // also, don't get caught in a circular liquidity event.
1447         // also, don't swap & liquify if sender is uniswap pair.
1448         uint256 contractTokenBalance = balanceOf(address(this));
1449 
1450         if (contractTokenBalance >= _maxTxAmount) {
1451             contractTokenBalance = _maxTxAmount;
1452         }
1453 
1454         bool overMinTokenBalance = contractTokenBalance >=
1455             numTokensSellToAddToLiquidity;
1456         if (
1457             overMinTokenBalance &&
1458             !inSwapAndLiquify &&
1459             from != uniswapV2Pair &&
1460             swapAndLiquifyEnabled
1461         ) {
1462             contractTokenBalance = numTokensSellToAddToLiquidity;
1463             //add liquidity
1464             swapAndLiquify(contractTokenBalance);
1465         }
1466 
1467         //indicates if fee should be deducted from transfer
1468         bool takeFee = true;
1469 
1470         //if any account belongs to _isExcludedFromFee account then remove the fee
1471         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
1472             takeFee = false;
1473         } else {
1474             //Set Fee for Buys
1475             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
1476                 setBuy();
1477             }
1478             //Set Fee for Sells
1479             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
1480                 setSell();
1481             }
1482         }
1483 
1484         //transfer amount, it will take tax, burn, liquidity fee
1485         _tokenTransfer(from, to, amount, takeFee);
1486     }
1487 
1488     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1489         // split the contract balance into halves
1490         uint256 half = contractTokenBalance.div(2);
1491         uint256 otherHalf = contractTokenBalance.sub(half);
1492 
1493         // capture the contract's current ETH balance.
1494         // this is so that we can capture exactly the amount of ETH that the
1495         // swap creates, and not make the liquidity event include any ETH that
1496         // has been manually sent to the contract
1497         uint256 initialBalance = address(this).balance;
1498 
1499         // swap tokens for ETH
1500         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1501 
1502         // how much ETH did we just swap into?
1503         uint256 newBalance = address(this).balance.sub(initialBalance);
1504 
1505         // add liquidity to uniswap
1506         addLiquidity(otherHalf, newBalance);
1507 
1508         emit SwapAndLiquify(half, newBalance, otherHalf);
1509     }
1510 
1511     function swapTokensForEth(uint256 tokenAmount) private {
1512         // generate the uniswap pair path of token -> weth
1513         address[] memory path = new address[](2);
1514         path[0] = address(this);
1515         path[1] = uniswapV2Router.WETH();
1516 
1517         _approve(address(this), address(uniswapV2Router), tokenAmount);
1518 
1519         // make the swap
1520         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1521             tokenAmount,
1522             0, // accept any amount of ETH
1523             path,
1524             address(this),
1525             block.timestamp
1526         );
1527     }
1528 
1529     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1530         // approve token transfer to cover all possible scenarios
1531         _approve(address(this), address(uniswapV2Router), tokenAmount);
1532 
1533         // add the liquidity
1534         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1535             address(this),
1536             tokenAmount,
1537             0, // slippage is unavoidable
1538             0, // slippage is unavoidable
1539             owner(),
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
1551         if (!takeFee)
1552             removeAllFee();
1553 
1554         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1555             _transferFromExcluded(sender, recipient, amount);
1556         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1557             _transferToExcluded(sender, recipient, amount);
1558         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1559             _transferStandard(sender, recipient, amount);
1560         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1561             _transferBothExcluded(sender, recipient, amount);
1562         } else {
1563             _transferStandard(sender, recipient, amount);
1564         }
1565         removeAllFee();
1566     }
1567 
1568     function _transferStandard(
1569         address sender,
1570         address recipient,
1571         uint256 tAmount
1572     ) private {
1573         (
1574             uint256 tTransferAmount,
1575             uint256 tFee,
1576             uint256 tLiquidity
1577         ) = _getTValues(tAmount);
1578         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1579             tAmount,
1580             tFee,
1581             tLiquidity,
1582             _getRate()
1583         );
1584 
1585         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1586         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1587         _takeLiquidity(tLiquidity);
1588         _reflectFee(rFee, tFee);
1589         emit Transfer(sender, recipient, tTransferAmount);
1590     }
1591 
1592 
1593     function _transferToExcluded(
1594         address sender,
1595         address recipient,
1596         uint256 tAmount
1597     ) private {
1598         (
1599             uint256 tTransferAmount,
1600             uint256 tFee,
1601             uint256 tLiquidity
1602         ) = _getTValues(tAmount);
1603         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1604             tAmount,
1605             tFee,
1606             tLiquidity,
1607             _getRate()
1608         );
1609 
1610         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1611         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1612         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1613         _takeLiquidity(tLiquidity);
1614         _reflectFee(rFee, tFee);
1615         emit Transfer(sender, recipient, tTransferAmount);
1616     }
1617 
1618     function _transferFromExcluded(
1619         address sender,
1620         address recipient,
1621         uint256 tAmount
1622     ) private {
1623         (
1624             uint256 tTransferAmount,
1625             uint256 tFee,
1626             uint256 tLiquidity
1627         ) = _getTValues(tAmount);
1628         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1629             tAmount,
1630             tFee,
1631             tLiquidity,
1632             _getRate()
1633         );
1634 
1635         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1636         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1637         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1638         _takeLiquidity(tLiquidity);
1639         _reflectFee(rFee, tFee);
1640         emit Transfer(sender, recipient, tTransferAmount);
1641     }
1642 
1643     function _transferBothExcluded(
1644         address sender,
1645         address recipient,
1646         uint256 tAmount
1647     ) private {
1648         (
1649             uint256 tTransferAmount,
1650             uint256 tFee,
1651             uint256 tLiquidity
1652         ) = _getTValues(tAmount);
1653         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1654             tAmount,
1655             tFee,
1656             tLiquidity,
1657             _getRate()
1658         );
1659 
1660         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1661         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1662         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1663         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1664         _takeLiquidity(tLiquidity);
1665         _reflectFee(rFee, tFee);
1666         emit Transfer(sender, recipient, tTransferAmount);
1667     }
1668 }