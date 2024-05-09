1 // ███████╗░█████╗░██████╗░██████╗░███████╗██████╗░░░░███████╗██╗
2 // ╚════██║██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗░░░██╔════╝██║
3 // ░░███╔═╝███████║██████╔╝██████╔╝█████╗░░██████╔╝░░░█████╗░░██║
4 // ██╔══╝░░██╔══██║██╔═══╝░██╔═══╝░██╔══╝░░██╔══██╗░░░██╔══╝░░██║
5 // ███████╗██║░░██║██║░░░░░██║░░░░░███████╗██║░░██║██╗██║░░░░░██║
6 // ╚══════╝╚═╝░░╚═╝╚═╝░░░░░╚═╝░░░░░╚══════╝╚═╝░░╚═╝╚═╝╚═╝░░░░░╚═╝
7 // Copyright (C) 2020 zapper, nodar, suhail, seb, apoorv, sumit
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
22 ///@notice this contract implements one click removal of liquidity from Sushiswap pools, receiving ETH, ERC tokens or both.
23 
24 pragma solidity ^0.5.0;
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
676     function factory() external pure returns (address);
677 
678     function WETH() external pure returns (address);
679 
680     function addLiquidity(
681         address tokenA,
682         address tokenB,
683         uint256 amountADesired,
684         uint256 amountBDesired,
685         uint256 amountAMin,
686         uint256 amountBMin,
687         address to,
688         uint256 deadline
689     )
690         external
691         returns (
692             uint256 amountA,
693             uint256 amountB,
694             uint256 liquidity
695         );
696 
697     function addLiquidityETH(
698         address token,
699         uint256 amountTokenDesired,
700         uint256 amountTokenMin,
701         uint256 amountETHMin,
702         address to,
703         uint256 deadline
704     )
705         external
706         payable
707         returns (
708             uint256 amountToken,
709             uint256 amountETH,
710             uint256 liquidity
711         );
712 
713     function removeLiquidity(
714         address tokenA,
715         address tokenB,
716         uint256 liquidity,
717         uint256 amountAMin,
718         uint256 amountBMin,
719         address to,
720         uint256 deadline
721     ) external returns (uint256 amountA, uint256 amountB);
722 
723     function removeLiquidityETH(
724         address token,
725         uint256 liquidity,
726         uint256 amountTokenMin,
727         uint256 amountETHMin,
728         address to,
729         uint256 deadline
730     ) external returns (uint256 amountToken, uint256 amountETH);
731 
732     function removeLiquidityWithPermit(
733         address tokenA,
734         address tokenB,
735         uint256 liquidity,
736         uint256 amountAMin,
737         uint256 amountBMin,
738         address to,
739         uint256 deadline,
740         bool approveMax,
741         uint8 v,
742         bytes32 r,
743         bytes32 s
744     ) external returns (uint256 amountA, uint256 amountB);
745 
746     function removeLiquidityETHWithPermit(
747         address token,
748         uint256 liquidity,
749         uint256 amountTokenMin,
750         uint256 amountETHMin,
751         address to,
752         uint256 deadline,
753         bool approveMax,
754         uint8 v,
755         bytes32 r,
756         bytes32 s
757     ) external returns (uint256 amountToken, uint256 amountETH);
758 
759     function swapExactTokensForTokens(
760         uint256 amountIn,
761         uint256 amountOutMin,
762         address[] calldata path,
763         address to,
764         uint256 deadline
765     ) external returns (uint256[] memory amounts);
766 
767     function swapTokensForExactTokens(
768         uint256 amountOut,
769         uint256 amountInMax,
770         address[] calldata path,
771         address to,
772         uint256 deadline
773     ) external returns (uint256[] memory amounts);
774 
775     function swapExactETHForTokens(
776         uint256 amountOutMin,
777         address[] calldata path,
778         address to,
779         uint256 deadline
780     ) external payable returns (uint256[] memory amounts);
781 
782     function swapTokensForExactETH(
783         uint256 amountOut,
784         uint256 amountInMax,
785         address[] calldata path,
786         address to,
787         uint256 deadline
788     ) external returns (uint256[] memory amounts);
789 
790     function swapExactTokensForETH(
791         uint256 amountIn,
792         uint256 amountOutMin,
793         address[] calldata path,
794         address to,
795         uint256 deadline
796     ) external returns (uint256[] memory amounts);
797 
798     function swapETHForExactTokens(
799         uint256 amountOut,
800         address[] calldata path,
801         address to,
802         uint256 deadline
803     ) external payable returns (uint256[] memory amounts);
804 
805     function removeLiquidityETHSupportingFeeOnTransferTokens(
806         address token,
807         uint256 liquidity,
808         uint256 amountTokenMin,
809         uint256 amountETHMin,
810         address to,
811         uint256 deadline
812     ) external returns (uint256 amountETH);
813 
814     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
815         address token,
816         uint256 liquidity,
817         uint256 amountTokenMin,
818         uint256 amountETHMin,
819         address to,
820         uint256 deadline,
821         bool approveMax,
822         uint8 v,
823         bytes32 r,
824         bytes32 s
825     ) external returns (uint256 amountETH);
826 
827     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
828         uint256 amountIn,
829         uint256 amountOutMin,
830         address[] calldata path,
831         address to,
832         uint256 deadline
833     ) external;
834 
835     function swapExactETHForTokensSupportingFeeOnTransferTokens(
836         uint256 amountOutMin,
837         address[] calldata path,
838         address to,
839         uint256 deadline
840     ) external payable;
841 
842     function swapExactTokensForETHSupportingFeeOnTransferTokens(
843         uint256 amountIn,
844         uint256 amountOutMin,
845         address[] calldata path,
846         address to,
847         uint256 deadline
848     ) external;
849 
850     function quote(
851         uint256 amountA,
852         uint256 reserveA,
853         uint256 reserveB
854     ) external pure returns (uint256 amountB);
855 
856     function getAmountOut(
857         uint256 amountIn,
858         uint256 reserveIn,
859         uint256 reserveOut
860     ) external pure returns (uint256 amountOut);
861 
862     function getAmountIn(
863         uint256 amountOut,
864         uint256 reserveIn,
865         uint256 reserveOut
866     ) external pure returns (uint256 amountIn);
867 
868     function getAmountsOut(uint256 amountIn, address[] calldata path)
869         external
870         view
871         returns (uint256[] memory amounts);
872 
873     function getAmountsIn(uint256 amountOut, address[] calldata path)
874         external
875         view
876         returns (uint256[] memory amounts);
877 }
878 
879 interface Iuniswap {
880     // converting ERC20 to ERC20 and transfer
881     function tokenToTokenTransferInput(
882         uint256 tokens_sold,
883         uint256 min_tokens_bought,
884         uint256 min_eth_bought,
885         uint256 deadline,
886         address recipient,
887         address token_addr
888     ) external returns (uint256 tokens_bought);
889 
890     function tokenToTokenSwapInput(
891         uint256 tokens_sold,
892         uint256 min_tokens_bought,
893         uint256 min_eth_bought,
894         uint256 deadline,
895         address token_addr
896     ) external returns (uint256 tokens_bought);
897 
898     function getTokenToEthInputPrice(uint256 tokens_sold)
899         external
900         view
901         returns (uint256 eth_bought);
902 
903     function tokenToEthTransferInput(
904         uint256 tokens_sold,
905         uint256 min_eth,
906         uint256 deadline,
907         address recipient
908     ) external returns (uint256 eth_bought);
909 
910     function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline)
911         external
912         payable
913         returns (uint256 tokens_bought);
914 
915     function ethToTokenTransferInput(
916         uint256 min_tokens,
917         uint256 deadline,
918         address recipient
919     ) external payable returns (uint256 tokens_bought);
920 
921     function balanceOf(address _owner) external view returns (uint256);
922 
923     function transfer(address _to, uint256 _value) external returns (bool);
924 
925     function transferFrom(
926         address from,
927         address to,
928         uint256 tokens
929     ) external returns (bool success);
930 }
931 
932 interface IUniswapV2Pair {
933     function token0() external pure returns (address);
934 
935     function token1() external pure returns (address);
936 
937     function totalSupply() external view returns (uint256);
938 
939     function getReserves()
940         external
941         view
942         returns (
943             uint112 _reserve0,
944             uint112 _reserve1,
945             uint32 _blockTimestampLast
946         );
947 
948     function permit(
949         address owner,
950         address spender,
951         uint256 value,
952         uint256 deadline,
953         uint8 v,
954         bytes32 r,
955         bytes32 s
956     ) external;
957 }
958 
959 interface IWETH {
960     function deposit() external payable;
961 
962     function transfer(address to, uint256 value) external returns (bool);
963 
964     function withdraw(uint256) external;
965 }
966 
967 interface IUniswapV2Factory {
968     function getPair(address tokenA, address tokenB)
969         external
970         view
971         returns (address);
972 }
973 
974 contract Sushiswap_ZapOut_General_V1 is ReentrancyGuard, Ownable {
975     using SafeMath for uint256;
976     using SafeERC20 for IERC20;
977     using Address for address;
978     bool public stopped = false;
979     uint16 public goodwill;
980     address
981         private constant zgoodwillAddress = 0xE737b6AfEC2320f616297e59445b60a11e3eF75F;
982 
983     uint256
984         private constant deadline = 0xf000000000000000000000000000000000000000000000000000000000000000;
985 
986     IUniswapV2Router02 private constant uniswapV2Router = IUniswapV2Router02(
987         0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
988     );
989     IUniswapV2Factory
990         private constant UniSwapV2FactoryAddress = IUniswapV2Factory(
991         0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
992     );
993 
994     // sushiSwap
995     IUniswapV2Router02 private constant sushiSwapRouter = IUniswapV2Router02(
996         0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F
997     );
998     IUniswapV2Factory
999         private constant sushiSwapFactoryAddress = IUniswapV2Factory(
1000         0xC0AEe478e3658e2610c5F7A4A2E1777cE9e4f2Ac
1001     );
1002 
1003     address private constant wethTokenAddress = address(
1004         0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
1005     );
1006 
1007     constructor(uint16 _goodwill) public {
1008         goodwill = _goodwill;
1009     }
1010 
1011     // circuit breaker modifiers
1012     modifier stopInEmergency {
1013         if (stopped) {
1014             revert("Temporarily Paused");
1015         } else {
1016             _;
1017         }
1018     }
1019 
1020     /**
1021     @notice This function is used to zapout of given SushiSwap pair in the bounded tokens
1022     @param _FromSushiPoolAddress The sushiSwap pair address to zapout
1023     @param _IncomingLP The amount of LP
1024     @return the amount of pair tokens received after zapout
1025      */
1026     function ZapOut2PairToken(
1027         address _FromSushiPoolAddress,
1028         uint256 _IncomingLP
1029     )
1030         public
1031         nonReentrant
1032         stopInEmergency
1033         returns (uint256 amountA, uint256 amountB)
1034     {
1035         IUniswapV2Pair pair = IUniswapV2Pair(_FromSushiPoolAddress);
1036 
1037         require(
1038             address(pair) != address(0),
1039             "Error: Invalid Sushipool Address"
1040         );
1041 
1042         //get reserves
1043         address token0 = pair.token0();
1044         address token1 = pair.token1();
1045 
1046         IERC20(_FromSushiPoolAddress).safeTransferFrom(
1047             msg.sender,
1048             address(this),
1049             _IncomingLP
1050         );
1051 
1052         uint256 goodwillPortion = _transferGoodwill(
1053             _FromSushiPoolAddress,
1054             _IncomingLP
1055         );
1056 
1057         IERC20(_FromSushiPoolAddress).safeApprove(
1058             address(sushiSwapRouter),
1059             SafeMath.sub(_IncomingLP, goodwillPortion)
1060         );
1061 
1062         if (token0 == wethTokenAddress || token1 == wethTokenAddress) {
1063             address _token = token0 == wethTokenAddress ? token1 : token0;
1064             (amountA, amountB) = sushiSwapRouter.removeLiquidityETH(
1065                 _token,
1066                 SafeMath.sub(_IncomingLP, goodwillPortion),
1067                 1,
1068                 1,
1069                 msg.sender,
1070                 deadline
1071             );
1072         } else {
1073             (amountA, amountB) = sushiSwapRouter.removeLiquidity(
1074                 token0,
1075                 token1,
1076                 SafeMath.sub(_IncomingLP, goodwillPortion),
1077                 1,
1078                 1,
1079                 msg.sender,
1080                 deadline
1081             );
1082         }
1083     }
1084 
1085     /**
1086     @notice This function is used to zapout of given Sushiswap pair in ETH/ERC20 Tokens
1087     @param _ToTokenContractAddress The ERC20 token to zapout in (address(0x00) if ether)
1088     @param _FromSushiPoolAddress The sushiswap pair address to zapout from
1089     @param _IncomingLP The amount of LP
1090     @return the amount of eth/tokens received after zapout
1091      */
1092     function ZapOut(
1093         address _ToTokenContractAddress,
1094         address _FromSushiPoolAddress,
1095         uint256 _IncomingLP,
1096         uint256 _minTokensRec
1097     ) public nonReentrant stopInEmergency returns (uint256) {
1098         IUniswapV2Pair pair = IUniswapV2Pair(_FromSushiPoolAddress);
1099 
1100         require(
1101             address(pair) != address(0),
1102             "Error: Invalid Sushipool Address"
1103         );
1104 
1105         //get pair tokens
1106         address token0 = pair.token0();
1107         address token1 = pair.token1();
1108 
1109         IERC20(_FromSushiPoolAddress).safeTransferFrom(
1110             msg.sender,
1111             address(this),
1112             _IncomingLP
1113         );
1114 
1115         uint256 goodwillPortion = _transferGoodwill(
1116             _FromSushiPoolAddress,
1117             _IncomingLP
1118         );
1119 
1120         IERC20(_FromSushiPoolAddress).safeApprove(
1121             address(sushiSwapRouter),
1122             SafeMath.sub(_IncomingLP, goodwillPortion)
1123         );
1124 
1125         (uint256 amountA, uint256 amountB) = sushiSwapRouter.removeLiquidity(
1126             token0,
1127             token1,
1128             SafeMath.sub(_IncomingLP, goodwillPortion),
1129             1,
1130             1,
1131             address(this),
1132             deadline
1133         );
1134 
1135         uint256 tokenBought;
1136         if (
1137             canSwapFromV2(_ToTokenContractAddress, token0) &&
1138             canSwapFromV2(_ToTokenContractAddress, token1)
1139         ) {
1140             tokenBought = swapFromV2(token0, _ToTokenContractAddress, amountA);
1141             tokenBought += swapFromV2(token1, _ToTokenContractAddress, amountB);
1142         } else if (canSwapFromV2(_ToTokenContractAddress, token0)) {
1143             uint256 token0Bought = swapFromV2(token1, token0, amountB);
1144             tokenBought = swapFromV2(
1145                 token0,
1146                 _ToTokenContractAddress,
1147                 token0Bought.add(amountA)
1148             );
1149         } else if (canSwapFromV2(_ToTokenContractAddress, token1)) {
1150             uint256 token1Bought = swapFromV2(token0, token1, amountA);
1151             tokenBought = swapFromV2(
1152                 token1,
1153                 _ToTokenContractAddress,
1154                 token1Bought.add(amountB)
1155             );
1156         }
1157 
1158         require(tokenBought >= _minTokensRec, "High slippage");
1159 
1160         if (_ToTokenContractAddress == address(0)) {
1161             msg.sender.transfer(tokenBought);
1162         } else {
1163             IERC20(_ToTokenContractAddress).safeTransfer(
1164                 msg.sender,
1165                 tokenBought
1166             );
1167         }
1168 
1169         return tokenBought;
1170     }
1171 
1172     function ZapOut2PairTokenWithPermit(
1173         address _FromSushiPoolAddress,
1174         uint256 _IncomingLP,
1175         uint256 _approvalAmount,
1176         uint256 _deadline,
1177         uint8 v,
1178         bytes32 r,
1179         bytes32 s
1180     ) external stopInEmergency returns (uint256 amountA, uint256 amountB) {
1181         // permit
1182         IUniswapV2Pair(_FromSushiPoolAddress).permit(
1183             msg.sender,
1184             address(this),
1185             _approvalAmount,
1186             _deadline,
1187             v,
1188             r,
1189             s
1190         );
1191         (amountA, amountB) = ZapOut2PairToken(
1192             _FromSushiPoolAddress,
1193             _IncomingLP
1194         );
1195     }
1196 
1197     function ZapOutWithPermit(
1198         address _ToTokenContractAddress,
1199         address _FromSushiPoolAddress,
1200         uint256 _IncomingLP,
1201         uint256 _minTokensRec,
1202         uint256 _approvalAmount,
1203         uint256 _deadline,
1204         uint8 v,
1205         bytes32 r,
1206         bytes32 s
1207     ) external stopInEmergency returns (uint256) {
1208         // permit
1209         IUniswapV2Pair(_FromSushiPoolAddress).permit(
1210             msg.sender,
1211             address(this),
1212             _approvalAmount,
1213             _deadline,
1214             v,
1215             r,
1216             s
1217         );
1218 
1219         return (
1220             ZapOut(
1221                 _ToTokenContractAddress,
1222                 _FromSushiPoolAddress,
1223                 _IncomingLP,
1224                 _minTokensRec
1225             )
1226         );
1227     }
1228 
1229     //swaps _fromToken for _toToken
1230     //for eth, address(0) otherwise ERC token address
1231     function swapFromV2(
1232         address _fromToken,
1233         address _toToken,
1234         uint256 amount
1235     ) internal returns (uint256) {
1236         require(
1237             _fromToken != address(0) || _toToken != address(0),
1238             "Invalid Exchange values"
1239         );
1240         if (_fromToken == _toToken) return amount;
1241 
1242         require(canSwapFromV2(_fromToken, _toToken), "Cannot be exchanged");
1243         require(amount > 0, "Invalid amount");
1244 
1245         if (_fromToken == address(0)) {
1246             if (_toToken == wethTokenAddress) {
1247                 IWETH(wethTokenAddress).deposit.value(amount)();
1248                 return amount;
1249             }
1250             address[] memory path = new address[](2);
1251             path[0] = wethTokenAddress;
1252             path[1] = _toToken;
1253             uint256 minTokens = uniswapV2Router.getAmountsOut(amount, path)[1];
1254             minTokens = SafeMath.div(
1255                 SafeMath.mul(minTokens, SafeMath.sub(10000, 200)),
1256                 10000
1257             );
1258             uint256[] memory amounts = uniswapV2Router
1259                 .swapExactETHForTokens
1260                 .value(amount)(minTokens, path, address(this), deadline);
1261             return amounts[1];
1262         } else if (_toToken == address(0)) {
1263             if (_fromToken == wethTokenAddress) {
1264                 IWETH(wethTokenAddress).withdraw(amount);
1265                 return amount;
1266             }
1267             address[] memory path = new address[](2);
1268             IERC20(_fromToken).safeApprove(address(uniswapV2Router), amount);
1269             path[0] = _fromToken;
1270             path[1] = wethTokenAddress;
1271             uint256 minTokens = uniswapV2Router.getAmountsOut(amount, path)[1];
1272             minTokens = SafeMath.div(
1273                 SafeMath.mul(minTokens, SafeMath.sub(10000, 200)),
1274                 10000
1275             );
1276             uint256[] memory amounts = uniswapV2Router.swapExactTokensForETH(
1277                 amount,
1278                 minTokens,
1279                 path,
1280                 address(this),
1281                 deadline
1282             );
1283             return amounts[1];
1284         } else {
1285             IERC20(_fromToken).safeApprove(address(uniswapV2Router), amount);
1286             uint256 returnedAmount = _swapTokenToTokenV2(
1287                 _fromToken,
1288                 _toToken,
1289                 amount
1290             );
1291             require(returnedAmount > 0, "Error in swap");
1292             return returnedAmount;
1293         }
1294     }
1295 
1296     //swaps 2 ERC tokens (UniV2)
1297     function _swapTokenToTokenV2(
1298         address _fromToken,
1299         address _toToken,
1300         uint256 amount
1301     ) internal returns (uint256) {
1302         IUniswapV2Pair pair1 = IUniswapV2Pair(
1303             UniSwapV2FactoryAddress.getPair(_fromToken, wethTokenAddress)
1304         );
1305         IUniswapV2Pair pair2 = IUniswapV2Pair(
1306             UniSwapV2FactoryAddress.getPair(_toToken, wethTokenAddress)
1307         );
1308         IUniswapV2Pair pair3 = IUniswapV2Pair(
1309             UniSwapV2FactoryAddress.getPair(_fromToken, _toToken)
1310         );
1311 
1312         uint256[] memory amounts;
1313 
1314         if (_haveReserve(pair3)) {
1315             address[] memory path = new address[](2);
1316             path[0] = _fromToken;
1317             path[1] = _toToken;
1318             uint256 minTokens = uniswapV2Router.getAmountsOut(amount, path)[1];
1319             minTokens = SafeMath.div(
1320                 SafeMath.mul(minTokens, SafeMath.sub(10000, 200)),
1321                 10000
1322             );
1323             amounts = uniswapV2Router.swapExactTokensForTokens(
1324                 amount,
1325                 minTokens,
1326                 path,
1327                 address(this),
1328                 deadline
1329             );
1330             return amounts[1];
1331         } else if (_haveReserve(pair1) && _haveReserve(pair2)) {
1332             address[] memory path = new address[](3);
1333             path[0] = _fromToken;
1334             path[1] = wethTokenAddress;
1335             path[2] = _toToken;
1336             uint256 minTokens = uniswapV2Router.getAmountsOut(amount, path)[2];
1337             minTokens = SafeMath.div(
1338                 SafeMath.mul(minTokens, SafeMath.sub(10000, 200)),
1339                 10000
1340             );
1341             amounts = uniswapV2Router.swapExactTokensForTokens(
1342                 amount,
1343                 minTokens,
1344                 path,
1345                 address(this),
1346                 deadline
1347             );
1348             return amounts[2];
1349         }
1350         return 0;
1351     }
1352 
1353     function canSwapFromV2(address _fromToken, address _toToken)
1354         internal
1355         view
1356         returns (bool)
1357     {
1358         require(
1359             _fromToken != address(0) || _toToken != address(0),
1360             "Invalid Exchange values"
1361         );
1362 
1363         if (_fromToken == _toToken) return true;
1364 
1365         if (_fromToken == address(0) || _fromToken == wethTokenAddress) {
1366             if (_toToken == wethTokenAddress || _toToken == address(0))
1367                 return true;
1368             IUniswapV2Pair pair = IUniswapV2Pair(
1369                 UniSwapV2FactoryAddress.getPair(_toToken, wethTokenAddress)
1370             );
1371             if (_haveReserve(pair)) return true;
1372         } else if (_toToken == address(0) || _toToken == wethTokenAddress) {
1373             if (_fromToken == wethTokenAddress || _fromToken == address(0))
1374                 return true;
1375             IUniswapV2Pair pair = IUniswapV2Pair(
1376                 UniSwapV2FactoryAddress.getPair(_fromToken, wethTokenAddress)
1377             );
1378             if (_haveReserve(pair)) return true;
1379         } else {
1380             IUniswapV2Pair pair1 = IUniswapV2Pair(
1381                 UniSwapV2FactoryAddress.getPair(_fromToken, wethTokenAddress)
1382             );
1383             IUniswapV2Pair pair2 = IUniswapV2Pair(
1384                 UniSwapV2FactoryAddress.getPair(_toToken, wethTokenAddress)
1385             );
1386             IUniswapV2Pair pair3 = IUniswapV2Pair(
1387                 UniSwapV2FactoryAddress.getPair(_fromToken, _toToken)
1388             );
1389             if (_haveReserve(pair1) && _haveReserve(pair2)) return true;
1390             if (_haveReserve(pair3)) return true;
1391         }
1392         return false;
1393     }
1394 
1395     //checks if the UNI v2 contract have reserves to swap tokens
1396     function _haveReserve(IUniswapV2Pair pair) internal view returns (bool) {
1397         if (address(pair) != address(0)) {
1398             uint256 totalSupply = pair.totalSupply();
1399             if (totalSupply > 0) return true;
1400         }
1401     }
1402 
1403     /**
1404     @notice This function is used to calculate and transfer goodwill
1405     @param _tokenContractAddress Token in which goodwill is deducted
1406     @param tokens2Trade The total amount of tokens to be zapped in
1407     @return The quantity of goodwill deducted
1408      */
1409     function _transferGoodwill(
1410         address _tokenContractAddress,
1411         uint256 tokens2Trade
1412     ) internal returns (uint256 goodwillPortion) {
1413         if (goodwill == 0) {
1414             return 0;
1415         }
1416 
1417         goodwillPortion = SafeMath.div(
1418             SafeMath.mul(tokens2Trade, goodwill),
1419             10000
1420         );
1421 
1422         IERC20(_tokenContractAddress).safeTransfer(
1423             zgoodwillAddress,
1424             goodwillPortion
1425         );
1426     }
1427 
1428     function set_new_goodwill(uint16 _new_goodwill) public onlyOwner {
1429         require(
1430             _new_goodwill >= 0 && _new_goodwill < 10000,
1431             "GoodWill Value not allowed"
1432         );
1433         goodwill = _new_goodwill;
1434     }
1435 
1436     function inCaseTokengetsStuck(IERC20 _TokenAddress) public onlyOwner {
1437         uint256 qty = _TokenAddress.balanceOf(address(this));
1438         _TokenAddress.safeTransfer(owner(), qty);
1439     }
1440 
1441     // - to Pause the contract
1442     function toggleContractActive() public onlyOwner {
1443         stopped = !stopped;
1444     }
1445 
1446     // - to withdraw any ETH balance sitting in the contract
1447     function withdraw() public onlyOwner {
1448         uint256 contractBalance = address(this).balance;
1449         address payable _to = owner().toPayable();
1450         _to.transfer(contractBalance);
1451     }
1452 
1453     function() external payable {
1454         require(msg.sender != tx.origin, "Do not send ETH directly");
1455     }
1456 }