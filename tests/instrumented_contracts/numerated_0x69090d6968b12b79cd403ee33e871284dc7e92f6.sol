1 // ███████╗░█████╗░██████╗░██████╗░███████╗██████╗░░░░███████╗██╗
2 // ╚════██║██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗░░░██╔════╝██║
3 // ░░███╔═╝███████║██████╔╝██████╔╝█████╗░░██████╔╝░░░█████╗░░██║
4 // ██╔══╝░░██╔══██║██╔═══╝░██╔═══╝░██╔══╝░░██╔══██╗░░░██╔══╝░░██║
5 // ███████╗██║░░██║██║░░░░░██║░░░░░███████╗██║░░██║██╗██║░░░░░██║
6 // ╚══════╝╚═╝░░╚═╝╚═╝░░░░░╚═╝░░░░░╚══════╝╚═╝░░╚═╝╚═╝╚═╝░░░░░╚═╝
7 // Copyright (C) 2021 zapper
8 
9 // This program is free software: you can redistribute it and/or modify
10 // it under the terms of the GNU Affero General Public License as published by
11 // the Free Software Foundation, either version 2 of the License, or
12 // (at your option) any later version.
13 //
14 // This program is distributed in the hope that it will be useful,
15 // but WITHOUT ANY WARRANTY; without even the implied warranty of
16 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
17 // GNU Affero General Public License for more details.
18 //
19 // Visit <https://www.gnu.org/licenses/>for a copy of the GNU Affero General Public License
20 
21 ///@author Zapper
22 ///@notice this contract implements one click removal of liquidity from Uniswap V2 pools, receiving ETH, ERC tokens or both.
23 
24 pragma solidity ^0.5.7;
25 
26 /**
27  * @dev Wrappers over Solidity's arithmetic operations with added overflow
28  * checks.
29  *
30  * Arithmetic operations in Solidity wrap on overflow. This can easily result
31  * in bugs, because programmers usually assume that an overflow raises an
32  * error, which is the standard behavior in high level programming languages.
33  * `SafeMath` restores this intuition by reverting the transaction when an
34  * operation overflows.
35  *
36  * Using this library instead of the unchecked operations eliminates an entire
37  * class of bugs, so it's recommended to use it always.
38  */
39 library SafeMath {
40     /**
41      * @dev Returns the addition of two unsigned integers, reverting on
42      * overflow.
43      *
44      * Counterpart to Solidity's `+` operator.
45      *
46      * Requirements:
47      * - Addition cannot overflow.
48      */
49     function add(uint256 a, uint256 b) internal pure returns (uint256) {
50         uint256 c = a + b;
51         require(c >= a, "SafeMath: addition overflow");
52 
53         return c;
54     }
55 
56     /**
57      * @dev Returns the subtraction of two unsigned integers, reverting on
58      * overflow (when the result is negative).
59      *
60      * Counterpart to Solidity's `-` operator.
61      *
62      * Requirements:
63      * - Subtraction cannot overflow.
64      */
65     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66         return sub(a, b, "SafeMath: subtraction overflow");
67     }
68 
69     /**
70      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
71      * overflow (when the result is negative).
72      *
73      * Counterpart to Solidity's `-` operator.
74      *
75      * Requirements:
76      * - Subtraction cannot overflow.
77      *
78      * _Available since v2.4.0._
79      */
80     function sub(
81         uint256 a,
82         uint256 b,
83         string memory errorMessage
84     ) internal pure returns (uint256) {
85         require(b <= a, errorMessage);
86         uint256 c = a - b;
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the multiplication of two unsigned integers, reverting on
93      * overflow.
94      *
95      * Counterpart to Solidity's `*` operator.
96      *
97      * Requirements:
98      * - Multiplication cannot overflow.
99      */
100     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
101         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
102         // benefit is lost if 'b' is also tested.
103         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
104         if (a == 0) {
105             return 0;
106         }
107 
108         uint256 c = a * b;
109         require(c / a == b, "SafeMath: multiplication overflow");
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the integer division of two unsigned integers. Reverts on
116      * division by zero. The result is rounded towards zero.
117      *
118      * Counterpart to Solidity's `/` operator. Note: this function uses a
119      * `revert` opcode (which leaves remaining gas untouched) while Solidity
120      * uses an invalid opcode to revert (consuming all remaining gas).
121      *
122      * Requirements:
123      * - The divisor cannot be zero.
124      */
125     function div(uint256 a, uint256 b) internal pure returns (uint256) {
126         return div(a, b, "SafeMath: division by zero");
127     }
128 
129     /**
130      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
131      * division by zero. The result is rounded towards zero.
132      *
133      * Counterpart to Solidity's `/` operator. Note: this function uses a
134      * `revert` opcode (which leaves remaining gas untouched) while Solidity
135      * uses an invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      * - The divisor cannot be zero.
139      *
140      * _Available since v2.4.0._
141      */
142     function div(
143         uint256 a,
144         uint256 b,
145         string memory errorMessage
146     ) internal pure returns (uint256) {
147         // Solidity only automatically asserts when dividing by 0
148         require(b > 0, errorMessage);
149         uint256 c = a / b;
150         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
151 
152         return c;
153     }
154 
155     /**
156      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
157      * Reverts when dividing by zero.
158      *
159      * Counterpart to Solidity's `%` operator. This function uses a `revert`
160      * opcode (which leaves remaining gas untouched) while Solidity uses an
161      * invalid opcode to revert (consuming all remaining gas).
162      *
163      * Requirements:
164      * - The divisor cannot be zero.
165      */
166     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
167         return mod(a, b, "SafeMath: modulo by zero");
168     }
169 
170     /**
171      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
172      * Reverts with custom message when dividing by zero.
173      *
174      * Counterpart to Solidity's `%` operator. This function uses a `revert`
175      * opcode (which leaves remaining gas untouched) while Solidity uses an
176      * invalid opcode to revert (consuming all remaining gas).
177      *
178      * Requirements:
179      * - The divisor cannot be zero.
180      *
181      * _Available since v2.4.0._
182      */
183     function mod(
184         uint256 a,
185         uint256 b,
186         string memory errorMessage
187     ) internal pure returns (uint256) {
188         require(b != 0, errorMessage);
189         return a % b;
190     }
191 }
192 
193 // File: @openzeppelin/contracts/GSN/Context.sol
194 
195 pragma solidity ^0.5.0;
196 
197 /*
198  * @dev Provides information about the current execution context, including the
199  * sender of the transaction and its data. While these are generally available
200  * via msg.sender and msg.data, they should not be accessed in such a direct
201  * manner, since when dealing with GSN meta-transactions the account sending and
202  * paying for execution may not be the actual sender (as far as an application
203  * is concerned).
204  *
205  * This contract is only required for intermediate, library-like contracts.
206  */
207 contract Context {
208     // Empty internal constructor, to prevent people from mistakenly deploying
209     // an instance of this contract, which should be used via inheritance.
210     constructor() internal {}
211 
212     // solhint-disable-previous-line no-empty-blocks
213 
214     function _msgSender() internal view returns (address payable) {
215         return msg.sender;
216     }
217 
218     function _msgData() internal view returns (bytes memory) {
219         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
220         return msg.data;
221     }
222 }
223 
224 // File: @openzeppelin/contracts/ownership/Ownable.sol
225 
226 pragma solidity ^0.5.0;
227 
228 /**
229  * @dev Contract module which provides a basic access control mechanism, where
230  * there is an account (an owner) that can be granted exclusive access to
231  * specific functions.
232  *
233  * This module is used through inheritance. It will make available the modifier
234  * `onlyOwner`, which can be applied to your functions to restrict their use to
235  * the owner.
236  */
237 contract Ownable is Context {
238     address private _owner;
239 
240     event OwnershipTransferred(
241         address indexed previousOwner,
242         address indexed newOwner
243     );
244 
245     /**
246      * @dev Initializes the contract setting the deployer as the initial owner.
247      */
248     constructor() internal {
249         address msgSender = _msgSender();
250         _owner = msgSender;
251         emit OwnershipTransferred(address(0), msgSender);
252     }
253 
254     /**
255      * @dev Returns the address of the current owner.
256      */
257     function owner() public view returns (address) {
258         return _owner;
259     }
260 
261     /**
262      * @dev Throws if called by any account other than the owner.
263      */
264     modifier onlyOwner() {
265         require(isOwner(), "Ownable: caller is not the owner");
266         _;
267     }
268 
269     /**
270      * @dev Returns true if the caller is the current owner.
271      */
272     function isOwner() public view returns (bool) {
273         return _msgSender() == _owner;
274     }
275 
276     /**
277      * @dev Leaves the contract without owner. It will not be possible to call
278      * `onlyOwner` functions anymore. Can only be called by the current owner.
279      *
280      * NOTE: Renouncing ownership will leave the contract without an owner,
281      * thereby removing any functionality that is only available to the owner.
282      */
283     function renounceOwnership() public onlyOwner {
284         emit OwnershipTransferred(_owner, address(0));
285         _owner = address(0);
286     }
287 
288     /**
289      * @dev Transfers ownership of the contract to a new account (`newOwner`).
290      * Can only be called by the current owner.
291      */
292     function transferOwnership(address newOwner) public onlyOwner {
293         _transferOwnership(newOwner);
294     }
295 
296     /**
297      * @dev Transfers ownership of the contract to a new account (`newOwner`).
298      */
299     function _transferOwnership(address newOwner) internal {
300         require(
301             newOwner != address(0),
302             "Ownable: new owner is the zero address"
303         );
304         emit OwnershipTransferred(_owner, newOwner);
305         _owner = newOwner;
306     }
307 }
308 
309 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
310 
311 pragma solidity ^0.5.0;
312 
313 /**
314  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
315  * the optional functions; to access them see {ERC20Detailed}.
316  */
317 interface IERC20 {
318     /**
319      * @dev Returns the amount of tokens in existence.
320      */
321     function totalSupply() external view returns (uint256);
322 
323     /**
324      * @dev Returns the amount of tokens owned by `account`.
325      */
326     function balanceOf(address account) external view returns (uint256);
327 
328     /**
329      * @dev Moves `amount` tokens from the caller's account to `recipient`.
330      *
331      * Returns a boolean value indicating whether the operation succeeded.
332      *
333      * Emits a {Transfer} event.
334      */
335     function transfer(address recipient, uint256 amount)
336         external
337         returns (bool);
338 
339     /**
340      * @dev Returns the remaining number of tokens that `spender` will be
341      * allowed to spend on behalf of `owner` through {transferFrom}. This is
342      * zero by default.
343      *
344      * This value changes when {approve} or {transferFrom} are called.
345      */
346     function allowance(address owner, address spender)
347         external
348         view
349         returns (uint256);
350 
351     /**
352      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
353      *
354      * Returns a boolean value indicating whether the operation succeeded.
355      *
356      * IMPORTANT: Beware that changing an allowance with this method brings the risk
357      * that someone may use both the old and the new allowance by unfortunate
358      * transaction ordering. One possible solution to mitigate this race
359      * condition is to first reduce the spender's allowance to 0 and set the
360      * desired value afterwards:
361      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
362      *
363      * Emits an {Approval} event.
364      */
365     function approve(address spender, uint256 amount) external returns (bool);
366 
367     /**
368      * @dev Moves `amount` tokens from `sender` to `recipient` using the
369      * allowance mechanism. `amount` is then deducted from the caller's
370      * allowance.
371      *
372      * Returns a boolean value indicating whether the operation succeeded.
373      *
374      * Emits a {Transfer} event.
375      */
376     function transferFrom(
377         address sender,
378         address recipient,
379         uint256 amount
380     ) external returns (bool);
381 
382     /**
383      * @dev Emitted when `value` tokens are moved from one account (`from`) to
384      * another (`to`).
385      *
386      * Note that `value` may be zero.
387      */
388     event Transfer(address indexed from, address indexed to, uint256 value);
389 
390     /**
391      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
392      * a call to {approve}. `value` is the new allowance.
393      */
394     event Approval(
395         address indexed owner,
396         address indexed spender,
397         uint256 value
398     );
399 }
400 
401 // File: @openzeppelin/contracts/utils/Address.sol
402 
403 pragma solidity ^0.5.5;
404 
405 /**
406  * @dev Collection of functions related to the address type
407  */
408 library Address {
409     /**
410      * @dev Returns true if `account` is a contract.
411      *
412      * [IMPORTANT]
413      * ====
414      * It is unsafe to assume that an address for which this function returns
415      * false is an externally-owned account (EOA) and not a contract.
416      *
417      * Among others, `isContract` will return false for the following
418      * types of addresses:
419      *
420      *  - an externally-owned account
421      *  - a contract in construction
422      *  - an address where a contract will be created
423      *  - an address where a contract lived, but was destroyed
424      * ====
425      */
426     function isContract(address account) internal view returns (bool) {
427         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
428         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
429         // for accounts without code, i.e. `keccak256('')`
430         bytes32 codehash;
431 
432 
433             bytes32 accountHash
434          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
435         // solhint-disable-next-line no-inline-assembly
436         assembly {
437             codehash := extcodehash(account)
438         }
439         return (codehash != accountHash && codehash != 0x0);
440     }
441 
442     /**
443      * @dev Converts an `address` into `address payable`. Note that this is
444      * simply a type cast: the actual underlying value is not changed.
445      *
446      * _Available since v2.4.0._
447      */
448     function toPayable(address account)
449         internal
450         pure
451         returns (address payable)
452     {
453         return address(uint160(account));
454     }
455 
456     /**
457      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
458      * `recipient`, forwarding all available gas and reverting on errors.
459      *
460      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
461      * of certain opcodes, possibly making contracts go over the 2300 gas limit
462      * imposed by `transfer`, making them unable to receive funds via
463      * `transfer`. {sendValue} removes this limitation.
464      *
465      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
466      *
467      * IMPORTANT: because control is transferred to `recipient`, care must be
468      * taken to not create reentrancy vulnerabilities. Consider using
469      * {ReentrancyGuard} or the
470      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
471      *
472      * _Available since v2.4.0._
473      */
474     function sendValue(address payable recipient, uint256 amount) internal {
475         require(
476             address(this).balance >= amount,
477             "Address: insufficient balance"
478         );
479 
480         // solhint-disable-next-line avoid-call-value
481         (bool success, ) = recipient.call.value(amount)("");
482         require(
483             success,
484             "Address: unable to send value, recipient may have reverted"
485         );
486     }
487 }
488 
489 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
490 
491 pragma solidity ^0.5.0;
492 
493 /**
494  * @dev Contract module that helps prevent reentrant calls to a function.
495  *
496  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
497  * available, which can be applied to functions to make sure there are no nested
498  * (reentrant) calls to them.
499  *
500  * Note that because there is a single `nonReentrant` guard, functions marked as
501  * `nonReentrant` may not call one another. This can be worked around by making
502  * those functions `private`, and then adding `external` `nonReentrant` entry
503  * points to them.
504  *
505  * TIP: If you would like to learn more about reentrancy and alternative ways
506  * to protect against it, check out our blog post
507  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
508  *
509  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
510  * metering changes introduced in the Istanbul hardfork.
511  */
512 contract ReentrancyGuard {
513     bool private _notEntered;
514 
515     constructor() internal {
516         // Storing an initial non-zero value makes deployment a bit more
517         // expensive, but in exchange the refund on every call to nonReentrant
518         // will be lower in amount. Since refunds are capped to a percetange of
519         // the total transaction's gas, it is best to keep them low in cases
520         // like this one, to increase the likelihood of the full refund coming
521         // into effect.
522         _notEntered = true;
523     }
524 
525     /**
526      * @dev Prevents a contract from calling itself, directly or indirectly.
527      * Calling a `nonReentrant` function from another `nonReentrant`
528      * function is not supported. It is possible to prevent this from happening
529      * by making the `nonReentrant` function external, and make it call a
530      * `private` function that does the actual work.
531      */
532     modifier nonReentrant() {
533         // On the first call to nonReentrant, _notEntered will be true
534         require(_notEntered, "ReentrancyGuard: reentrant call");
535 
536         // Any calls to nonReentrant after this point will fail
537         _notEntered = false;
538 
539         _;
540 
541         // By storing the original value once again, a refund is triggered (see
542         // https://eips.ethereum.org/EIPS/eip-2200)
543         _notEntered = true;
544     }
545 }
546 
547 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
548 
549 pragma solidity ^0.5.0;
550 
551 /**
552  * @title SafeERC20
553  * @dev Wrappers around ERC20 operations that throw on failure (when the token
554  * contract returns false). Tokens that return no value (and instead revert or
555  * throw on failure) are also supported, non-reverting calls are assumed to be
556  * successful.
557  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
558  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
559  */
560 library SafeERC20 {
561     using SafeMath for uint256;
562     using Address for address;
563 
564     function safeTransfer(
565         IERC20 token,
566         address to,
567         uint256 value
568     ) internal {
569         callOptionalReturn(
570             token,
571             abi.encodeWithSelector(token.transfer.selector, to, value)
572         );
573     }
574 
575     function safeTransferFrom(
576         IERC20 token,
577         address from,
578         address to,
579         uint256 value
580     ) internal {
581         callOptionalReturn(
582             token,
583             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
584         );
585     }
586 
587     function safeApprove(
588         IERC20 token,
589         address spender,
590         uint256 value
591     ) internal {
592         // safeApprove should only be called when setting an initial allowance,
593         // or when resetting it to zero. To increase and decrease it, use
594         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
595         // solhint-disable-next-line max-line-length
596         require(
597             (value == 0) || (token.allowance(address(this), spender) == 0),
598             "SafeERC20: approve from non-zero to non-zero allowance"
599         );
600         callOptionalReturn(
601             token,
602             abi.encodeWithSelector(token.approve.selector, spender, value)
603         );
604     }
605 
606     function safeIncreaseAllowance(
607         IERC20 token,
608         address spender,
609         uint256 value
610     ) internal {
611         uint256 newAllowance = token.allowance(address(this), spender).add(
612             value
613         );
614         callOptionalReturn(
615             token,
616             abi.encodeWithSelector(
617                 token.approve.selector,
618                 spender,
619                 newAllowance
620             )
621         );
622     }
623 
624     function safeDecreaseAllowance(
625         IERC20 token,
626         address spender,
627         uint256 value
628     ) internal {
629         uint256 newAllowance = token.allowance(address(this), spender).sub(
630             value,
631             "SafeERC20: decreased allowance below zero"
632         );
633         callOptionalReturn(
634             token,
635             abi.encodeWithSelector(
636                 token.approve.selector,
637                 spender,
638                 newAllowance
639             )
640         );
641     }
642 
643     /**
644      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
645      * on the return value: the return value is optional (but if data is returned, it must not be false).
646      * @param token The token targeted by the call.
647      * @param data The call data (encoded using abi.encode or one of its variants).
648      */
649     function callOptionalReturn(IERC20 token, bytes memory data) private {
650         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
651         // we're implementing it ourselves.
652 
653         // A Solidity high level call has three parts:
654         //  1. The target address is checked to verify it contains contract code
655         //  2. The call itself is made, and success asserted
656         //  3. The return value is decoded, which in turn checks the size of the returned data.
657         // solhint-disable-next-line max-line-length
658         require(address(token).isContract(), "SafeERC20: call to non-contract");
659 
660         // solhint-disable-next-line avoid-low-level-calls
661         (bool success, bytes memory returndata) = address(token).call(data);
662         require(success, "SafeERC20: low-level call failed");
663 
664         if (returndata.length > 0) {
665             // Return data is optional
666             // solhint-disable-next-line max-line-length
667             require(
668                 abi.decode(returndata, (bool)),
669                 "SafeERC20: ERC20 operation did not succeed"
670             );
671         }
672     }
673 }
674 
675 interface IUniswapV2Router02 {
676     function WETH() external pure returns (address);
677 
678     function removeLiquidity(
679         address tokenA,
680         address tokenB,
681         uint256 liquidity,
682         uint256 amountAMin,
683         uint256 amountBMin,
684         address to,
685         uint256 deadline
686     ) external returns (uint256 amountA, uint256 amountB);
687 
688     function removeLiquidityETH(
689         address token,
690         uint256 liquidity,
691         uint256 amountTokenMin,
692         uint256 amountETHMin,
693         address to,
694         uint256 deadline
695     ) external returns (uint256 amountToken, uint256 amountETH);
696 }
697 
698 interface IUniswapV2Pair {
699     function token0() external pure returns (address);
700 
701     function token1() external pure returns (address);
702 
703     function balanceOf(address user) external view returns (uint256);
704 
705     function totalSupply() external view returns (uint256);
706 
707     function getReserves()
708         external
709         view
710         returns (
711             uint112 _reserve0,
712             uint112 _reserve1,
713             uint32 _blockTimestampLast
714         );
715 
716     function permit(
717         address owner,
718         address spender,
719         uint256 value,
720         uint256 deadline,
721         uint8 v,
722         bytes32 r,
723         bytes32 s
724     ) external;
725 }
726 
727 interface IWETH {
728     function withdraw(uint256 wad) external;
729 }
730 
731 contract UniswapV2_ZapOut_General_V3_0_1 is ReentrancyGuard, Ownable {
732     using SafeMath for uint256;
733     using SafeERC20 for IERC20;
734     using Address for address;
735 
736     bool public stopped = false;
737     uint256 public goodwill;
738 
739     // if true, goodwill is not deducted
740     mapping(address => bool) public feeWhitelist;
741 
742     // % share of goodwill (0-100 %)
743     uint256 affiliateSplit;
744     // restrict affiliates
745     mapping(address => bool) public affiliates;
746     // affiliate => token => amount
747     mapping(address => mapping(address => uint256)) public affiliateBalance;
748     // token => amount
749     mapping(address => uint256) public totalAffiliateBalance;
750 
751     address
752         private constant ETHAddress = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
753 
754     uint256
755         private constant deadline = 0xf000000000000000000000000000000000000000000000000000000000000000;
756 
757     IUniswapV2Router02 private constant uniswapV2Router = IUniswapV2Router02(
758         0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
759     );
760 
761     address private constant wethTokenAddress = address(
762         0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
763     );
764 
765     constructor(uint256 _goodwill, uint256 _affiliateSplit) public {
766         goodwill = _goodwill;
767         affiliateSplit = _affiliateSplit;
768     }
769 
770     // circuit breaker modifiers
771     modifier stopInEmergency {
772         if (stopped) {
773             revert("Temporarily Paused");
774         } else {
775             _;
776         }
777     }
778 
779     event zapOut(
780         address sender,
781         address pool,
782         address token,
783         uint256 tokensRec
784     );
785 
786     /**
787     @notice Zap out in both tokens
788     @param FromUniPoolAddress Pool from which to remove liquidity
789     @param IncomingLP Quantity of LP to remove from pool
790     @param affiliate Affiliate address
791     @return Quantity of tokens received after zapout
792     */
793     function ZapOut2PairToken(
794         address FromUniPoolAddress,
795         uint256 IncomingLP,
796         address affiliate
797     )
798         public
799         nonReentrant
800         stopInEmergency
801         returns (uint256 amountA, uint256 amountB)
802     {
803         IUniswapV2Pair pair = IUniswapV2Pair(FromUniPoolAddress);
804 
805         require(address(pair) != address(0), "Error: Invalid Unipool Address");
806 
807         // get reserves
808         address token0 = pair.token0();
809         address token1 = pair.token1();
810 
811         IERC20 uniPool = IERC20(FromUniPoolAddress);
812 
813         uniPool.safeTransferFrom(msg.sender, address(this), IncomingLP);
814 
815         uniPool.safeApprove(address(uniswapV2Router), IncomingLP);
816 
817         if (token0 == wethTokenAddress || token1 == wethTokenAddress) {
818             address _token = token0 == wethTokenAddress ? token1 : token0;
819             (amountA, amountB) = uniswapV2Router.removeLiquidityETH(
820                 _token,
821                 IncomingLP,
822                 1,
823                 1,
824                 address(this),
825                 deadline
826             );
827 
828             // subtract goodwill
829             uint256 tokenGoodwill = _subtractGoodwill(
830                 _token,
831                 amountA,
832                 affiliate
833             );
834             uint256 ethGoodwill = _subtractGoodwill(
835                 ETHAddress,
836                 amountB,
837                 affiliate
838             );
839 
840             // send tokens
841             IERC20(_token).safeTransfer(msg.sender, amountA.sub(tokenGoodwill));
842             Address.sendValue(msg.sender, amountB.sub(ethGoodwill));
843         } else {
844             (amountA, amountB) = uniswapV2Router.removeLiquidity(
845                 token0,
846                 token1,
847                 IncomingLP,
848                 1,
849                 1,
850                 address(this),
851                 deadline
852             );
853 
854             // subtract goodwill
855             uint256 tokenAGoodwill = _subtractGoodwill(
856                 token0,
857                 amountA,
858                 affiliate
859             );
860             uint256 tokenBGoodwill = _subtractGoodwill(
861                 token1,
862                 amountB,
863                 affiliate
864             );
865 
866             // send tokens
867             IERC20(token0).safeTransfer(
868                 msg.sender,
869                 amountA.sub(tokenAGoodwill)
870             );
871             IERC20(token1).safeTransfer(
872                 msg.sender,
873                 amountB.sub(tokenBGoodwill)
874             );
875         }
876         emit zapOut(msg.sender, FromUniPoolAddress, token0, amountA);
877         emit zapOut(msg.sender, FromUniPoolAddress, token1, amountB);
878     }
879 
880     /**
881     @notice Zap out in a single token
882     @param ToTokenContractAddress Address of desired token
883     @param FromUniPoolAddress Pool from which to remove liquidity
884     @param IncomingLP Quantity of LP to remove from pool
885     @param minTokensRec Minimum quantity of tokens to receive
886     @param swapTargets Execution targets for swaps
887     @param swap1Data DEX swap data
888     @param swap2Data DEX swap data
889     @param affiliate Affiliate address
890     */
891     function ZapOut(
892         address ToTokenContractAddress,
893         address FromUniPoolAddress,
894         uint256 IncomingLP,
895         uint256 minTokensRec,
896         address[] memory swapTargets,
897         bytes memory swap1Data,
898         bytes memory swap2Data,
899         address affiliate
900     ) public nonReentrant stopInEmergency returns (uint256 tokensRec) {
901         (uint256 amountA, uint256 amountB) = _removeLiquidity(
902             FromUniPoolAddress,
903             IncomingLP
904         );
905 
906         //swaps tokens to token
907         tokensRec = _swapTokens(
908             FromUniPoolAddress,
909             amountA,
910             amountB,
911             ToTokenContractAddress,
912             swapTargets,
913             swap1Data,
914             swap2Data
915         );
916         require(tokensRec >= minTokensRec, "High slippage");
917 
918         uint256 totalGoodwillPortion;
919 
920         // transfer toTokens to sender
921         if (ToTokenContractAddress == address(0)) {
922             totalGoodwillPortion = _subtractGoodwill(
923                 ETHAddress,
924                 tokensRec,
925                 affiliate
926             );
927 
928             msg.sender.transfer(tokensRec.sub(totalGoodwillPortion));
929         } else {
930             totalGoodwillPortion = _subtractGoodwill(
931                 ToTokenContractAddress,
932                 tokensRec,
933                 affiliate
934             );
935 
936             IERC20(ToTokenContractAddress).safeTransfer(
937                 msg.sender,
938                 tokensRec.sub(totalGoodwillPortion)
939             );
940         }
941 
942         tokensRec = tokensRec.sub(totalGoodwillPortion);
943 
944         emit zapOut(
945             msg.sender,
946             FromUniPoolAddress,
947             ToTokenContractAddress,
948             tokensRec
949         );
950 
951         return tokensRec;
952     }
953 
954     /**
955     @notice Zap out in both tokens with permit
956     @param FromUniPoolAddress Pool from which to remove liquidity
957     @param IncomingLP Quantity of LP to remove from pool
958     @param affiliate Affiliate address to share fees
959     @param permitData Encoded permit data, which contains owner, spender, value, deadline, r,s,v values 
960     @return  amountA, amountB - Quantity of tokens received 
961     */
962     function ZapOut2PairTokenWithPermit(
963         address FromUniPoolAddress,
964         uint256 IncomingLP,
965         address affiliate,
966         bytes calldata permitData
967     ) external stopInEmergency returns (uint256 amountA, uint256 amountB) {
968         // permit
969         (bool success, ) = FromUniPoolAddress.call(permitData);
970         require(success, "Could Not Permit");
971 
972         (amountA, amountB) = ZapOut2PairToken(
973             FromUniPoolAddress,
974             IncomingLP,
975             affiliate
976         );
977     }
978 
979     /**
980     @notice Zap out in a signle token with permit
981     @param ToTokenContractAddress indicates the toToken address to which tokens to convert.
982     @param FromUniPoolAddress indicates the liquidity pool
983     @param IncomingLP indicates the amount of LP to remove from pool
984     @param minTokensRec indicatest the minimum amount of toTokens to receive
985     @param permitData indicates the encoded permit data, which contains owner, spender, value, deadline, v,r,s values. 
986     @param swapTargets indicates the execution target for swap.
987     @param swap1Data DEX swap data
988     @param swap2Data DEX swap data
989     @param affiliate Affiliate address
990     */
991     function ZapOutWithPermit(
992         address ToTokenContractAddress,
993         address FromUniPoolAddress,
994         uint256 IncomingLP,
995         uint256 minTokensRec,
996         bytes memory permitData,
997         address[] memory swapTargets,
998         bytes memory swap1Data,
999         bytes memory swap2Data,
1000         address affiliate
1001     ) public stopInEmergency returns (uint256) {
1002         // permit
1003         (bool success, ) = FromUniPoolAddress.call(permitData);
1004         require(success, "Could Not Permit");
1005 
1006         return (
1007             ZapOut(
1008                 ToTokenContractAddress,
1009                 FromUniPoolAddress,
1010                 IncomingLP,
1011                 minTokensRec,
1012                 swapTargets,
1013                 swap1Data,
1014                 swap2Data,
1015                 affiliate
1016             )
1017         );
1018     }
1019 
1020     function _removeLiquidity(address FromUniPoolAddress, uint256 IncomingLP)
1021         internal
1022         returns (uint256 amountA, uint256 amountB)
1023     {
1024         IUniswapV2Pair pair = IUniswapV2Pair(FromUniPoolAddress);
1025 
1026         require(address(pair) != address(0), "Error: Invalid Unipool Address");
1027 
1028         address token0 = pair.token0();
1029         address token1 = pair.token1();
1030 
1031         IERC20(FromUniPoolAddress).safeTransferFrom(
1032             msg.sender,
1033             address(this),
1034             IncomingLP
1035         );
1036 
1037         IERC20(FromUniPoolAddress).safeApprove(
1038             address(uniswapV2Router),
1039             IncomingLP
1040         );
1041 
1042         (amountA, amountB) = uniswapV2Router.removeLiquidity(
1043             token0,
1044             token1,
1045             IncomingLP,
1046             1,
1047             1,
1048             address(this),
1049             deadline
1050         );
1051         require(amountA > 0 && amountB > 0, "Removed insufficient Liquidity");
1052     }
1053 
1054     function _swapTokens(
1055         address FromUniPoolAddress,
1056         uint256 amountA,
1057         uint256 amountB,
1058         address toToken,
1059         address[] memory swapTargets,
1060         bytes memory swap1Data,
1061         bytes memory swap2Data
1062     ) internal returns (uint256 tokensBought) {
1063         address token0 = IUniswapV2Pair(FromUniPoolAddress).token0();
1064         address token1 = IUniswapV2Pair(FromUniPoolAddress).token1();
1065 
1066         //swap token0 to toToken
1067         if (token0 == toToken) {
1068             tokensBought = tokensBought.add(amountA);
1069         } else {
1070             //swap token using 0x swap
1071             tokensBought = tokensBought.add(
1072                 _fillQuote(token0, toToken, amountA, swapTargets[0], swap1Data)
1073             );
1074         }
1075 
1076         //swap token1 to toToken
1077         if (token1 == toToken) {
1078             tokensBought = tokensBought.add(amountB);
1079         } else {
1080             //swap token using 0x swap
1081             tokensBought = tokensBought.add(
1082                 _fillQuote(token1, toToken, amountB, swapTargets[1], swap2Data)
1083             );
1084         }
1085     }
1086 
1087     function _fillQuote(
1088         address fromTokenAddress,
1089         address toToken,
1090         uint256 amount,
1091         address swapTarget,
1092         bytes memory swapData
1093     ) internal returns (uint256) {
1094         uint256 valueToSend;
1095 
1096         if (fromTokenAddress == wethTokenAddress && toToken == address(0)) {
1097             IWETH(wethTokenAddress).withdraw(amount);
1098             return amount;
1099         }
1100 
1101         if (fromTokenAddress == address(0)) {
1102             valueToSend = amount;
1103         } else {
1104             IERC20 fromToken = IERC20(fromTokenAddress);
1105             fromToken.safeApprove(address(swapTarget), 0);
1106             fromToken.safeApprove(address(swapTarget), amount);
1107         }
1108 
1109         uint256 initialBalance = toToken == address(0)
1110             ? address(this).balance
1111             : IERC20(toToken).balanceOf(address(this));
1112 
1113         (bool success, ) = swapTarget.call.value(valueToSend)(swapData);
1114         require(success, "Error Swapping Tokens");
1115 
1116         uint256 finalBalance = toToken == address(0)
1117             ? (address(this).balance).sub(initialBalance)
1118             : IERC20(toToken).balanceOf(address(this)).sub(initialBalance);
1119 
1120         require(finalBalance > 0, "Swapped to Invalid Intermediate");
1121 
1122         return finalBalance;
1123     }
1124 
1125     /**
1126     @notice Utility function to determine quantity and addresses of tokens being removed
1127     @param FromUniPoolAddress Pool from which to remove liquidity
1128     @param liquidity Quantity of LP tokens to remove.
1129     @return  amountA- amountB- Quantity of token0 and token1 removed
1130     @return  token0- token1- Addresses of the underlying tokens to be removed
1131     */
1132     function removeLiquidityReturn(
1133         address FromUniPoolAddress,
1134         uint256 liquidity
1135     )
1136         external
1137         view
1138         returns (
1139             uint256 amountA,
1140             uint256 amountB,
1141             address token0,
1142             address token1
1143         )
1144     {
1145         IUniswapV2Pair pair = IUniswapV2Pair(FromUniPoolAddress);
1146         token0 = pair.token0();
1147         token1 = pair.token1();
1148 
1149         uint256 balance0 = IERC20(token0).balanceOf(FromUniPoolAddress);
1150         uint256 balance1 = IERC20(token1).balanceOf(FromUniPoolAddress);
1151 
1152         uint256 _totalSupply = pair.totalSupply();
1153 
1154         amountA = liquidity.mul(balance0) / _totalSupply;
1155         amountB = liquidity.mul(balance1) / _totalSupply;
1156     }
1157 
1158     function _subtractGoodwill(
1159         address token,
1160         uint256 amount,
1161         address affiliate
1162     ) internal returns (uint256 totalGoodwillPortion) {
1163         bool whitelisted = feeWhitelist[msg.sender];
1164         if (!whitelisted && goodwill > 0) {
1165             totalGoodwillPortion = SafeMath.div(
1166                 SafeMath.mul(amount, goodwill),
1167                 10000
1168             );
1169 
1170             if (affiliates[affiliate]) {
1171                 uint256 affiliatePortion = totalGoodwillPortion
1172                     .mul(affiliateSplit)
1173                     .div(100);
1174                 affiliateBalance[affiliate][token] = affiliateBalance[affiliate][token]
1175                     .add(affiliatePortion);
1176                 totalAffiliateBalance[token] = totalAffiliateBalance[token].add(
1177                     affiliatePortion
1178                 );
1179             }
1180         }
1181     }
1182 
1183     // - to Pause the contract
1184     function toggleContractActive() public onlyOwner {
1185         stopped = !stopped;
1186     }
1187 
1188     function set_new_goodwill(uint256 new_goodwill) public onlyOwner {
1189         require(
1190             new_goodwill >= 0 && new_goodwill <= 100,
1191             "GoodWill Value not allowed"
1192         );
1193         goodwill = new_goodwill;
1194     }
1195 
1196     function set_feeWhitelist(address zapAddress, bool status)
1197         external
1198         onlyOwner
1199     {
1200         feeWhitelist[zapAddress] = status;
1201     }
1202 
1203     function set_new_affiliateSplit(uint256 new_affiliateSplit)
1204         external
1205         onlyOwner
1206     {
1207         require(new_affiliateSplit <= 100, "Affiliate Split Value not allowed");
1208         affiliateSplit = new_affiliateSplit;
1209     }
1210 
1211     function set_affiliate(address affiliate, bool status) external onlyOwner {
1212         affiliates[affiliate] = status;
1213     }
1214 
1215     ///@notice Withdraw goodwill share, retaining affilliate share
1216     function withdrawTokens(address[] calldata tokens) external onlyOwner {
1217         for (uint256 i = 0; i < tokens.length; i++) {
1218             uint256 qty;
1219 
1220             if (tokens[i] == ETHAddress) {
1221                 qty = address(this).balance.sub(
1222                     totalAffiliateBalance[tokens[i]]
1223                 );
1224                 Address.sendValue(Address.toPayable(owner()), qty);
1225             } else {
1226                 qty = IERC20(tokens[i]).balanceOf(address(this)).sub(
1227                     totalAffiliateBalance[tokens[i]]
1228                 );
1229                 IERC20(tokens[i]).safeTransfer(owner(), qty);
1230             }
1231         }
1232     }
1233 
1234     ///@notice Withdraw affilliate share, retaining goodwill share
1235     function affilliateWithdraw(address[] calldata tokens) external {
1236         uint256 tokenBal;
1237         for (uint256 i = 0; i < tokens.length; i++) {
1238             tokenBal = affiliateBalance[msg.sender][tokens[i]];
1239             affiliateBalance[msg.sender][tokens[i]] = 0;
1240             totalAffiliateBalance[tokens[i]] = totalAffiliateBalance[tokens[i]]
1241                 .sub(tokenBal);
1242 
1243             if (tokens[i] == ETHAddress) {
1244                 Address.sendValue(msg.sender, tokenBal);
1245             } else {
1246                 IERC20(tokens[i]).safeTransfer(msg.sender, tokenBal);
1247             }
1248         }
1249     }
1250 
1251     function() external payable {
1252         require(msg.sender != tx.origin, "Do not send ETH directly");
1253     }
1254 }