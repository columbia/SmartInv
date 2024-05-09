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
22 ///@notice this contract implements one click removal of liquidity from Uniswap V2 pools, receiving ETH, ERC tokens or both.
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
974 contract UniswapV2_ZapOut_General_V2_1 is ReentrancyGuard, Ownable {
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
989 
990     IUniswapV2Factory
991         private constant UniSwapV2FactoryAddress = IUniswapV2Factory(
992         0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
993     );
994 
995     address private constant wethTokenAddress = address(
996         0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
997     );
998 
999     constructor(uint16 _goodwill) public {
1000         goodwill = _goodwill;
1001     }
1002 
1003     // circuit breaker modifiers
1004     modifier stopInEmergency {
1005         if (stopped) {
1006             revert("Temporarily Paused");
1007         } else {
1008             _;
1009         }
1010     }
1011 
1012     /**
1013     @notice This function is used to zapout of given Uniswap pair in the bounded tokens
1014     @param _FromUniPoolAddress The uniswap pair address to zapout
1015     @param _IncomingLP The amount of LP
1016     @return the amount of pair tokens received after zapout
1017      */
1018     function ZapOut2PairToken(address _FromUniPoolAddress, uint256 _IncomingLP)
1019         public
1020         nonReentrant
1021         stopInEmergency
1022         returns (uint256 amountA, uint256 amountB)
1023     {
1024         IUniswapV2Pair pair = IUniswapV2Pair(_FromUniPoolAddress);
1025 
1026         require(address(pair) != address(0), "Error: Invalid Unipool Address");
1027 
1028         //get reserves
1029         address token0 = pair.token0();
1030         address token1 = pair.token1();
1031 
1032         IERC20(_FromUniPoolAddress).safeTransferFrom(
1033             msg.sender,
1034             address(this),
1035             _IncomingLP
1036         );
1037 
1038         uint256 goodwillPortion = _transferGoodwill(
1039             _FromUniPoolAddress,
1040             _IncomingLP
1041         );
1042 
1043         IERC20(_FromUniPoolAddress).safeApprove(
1044             address(uniswapV2Router),
1045             SafeMath.sub(_IncomingLP, goodwillPortion)
1046         );
1047 
1048         if (token0 == wethTokenAddress || token1 == wethTokenAddress) {
1049             address _token = token0 == wethTokenAddress ? token1 : token0;
1050             (amountA, amountB) = uniswapV2Router.removeLiquidityETH(
1051                 _token,
1052                 SafeMath.sub(_IncomingLP, goodwillPortion),
1053                 1,
1054                 1,
1055                 msg.sender,
1056                 deadline
1057             );
1058         } else {
1059             (amountA, amountB) = uniswapV2Router.removeLiquidity(
1060                 token0,
1061                 token1,
1062                 SafeMath.sub(_IncomingLP, goodwillPortion),
1063                 1,
1064                 1,
1065                 msg.sender,
1066                 deadline
1067             );
1068         }
1069     }
1070 
1071     /**
1072     @notice This function is used to zapout of given Uniswap pair in ETH/ERC20 Tokens
1073     @param _ToTokenContractAddress The ERC20 token to zapout in (address(0x00) if ether)
1074     @param _FromUniPoolAddress The uniswap pair address to zapout from
1075     @param _IncomingLP The amount of LP
1076     @return the amount of eth/tokens received after zapout
1077      */
1078     function ZapOut(
1079         address _ToTokenContractAddress,
1080         address _FromUniPoolAddress,
1081         uint256 _IncomingLP,
1082         uint256 _minTokensRec
1083     ) public nonReentrant stopInEmergency returns (uint256) {
1084         IUniswapV2Pair pair = IUniswapV2Pair(_FromUniPoolAddress);
1085 
1086         require(address(pair) != address(0), "Error: Invalid Unipool Address");
1087 
1088         //get pair tokens
1089         address token0 = pair.token0();
1090         address token1 = pair.token1();
1091 
1092         IERC20(_FromUniPoolAddress).safeTransferFrom(
1093             msg.sender,
1094             address(this),
1095             _IncomingLP
1096         );
1097 
1098         uint256 goodwillPortion = _transferGoodwill(
1099             _FromUniPoolAddress,
1100             _IncomingLP
1101         );
1102 
1103         IERC20(_FromUniPoolAddress).safeApprove(
1104             address(uniswapV2Router),
1105             SafeMath.sub(_IncomingLP, goodwillPortion)
1106         );
1107 
1108         (uint256 amountA, uint256 amountB) = uniswapV2Router.removeLiquidity(
1109             token0,
1110             token1,
1111             SafeMath.sub(_IncomingLP, goodwillPortion),
1112             1,
1113             1,
1114             address(this),
1115             deadline
1116         );
1117 
1118         uint256 tokenBought;
1119         if (
1120             canSwapFromV2(_ToTokenContractAddress, token0) &&
1121             canSwapFromV2(_ToTokenContractAddress, token1)
1122         ) {
1123             tokenBought = swapFromV2(token0, _ToTokenContractAddress, amountA);
1124             tokenBought += swapFromV2(token1, _ToTokenContractAddress, amountB);
1125         } else if (canSwapFromV2(_ToTokenContractAddress, token0)) {
1126             uint256 token0Bought = swapFromV2(token1, token0, amountB);
1127             tokenBought = swapFromV2(
1128                 token0,
1129                 _ToTokenContractAddress,
1130                 token0Bought.add(amountA)
1131             );
1132         } else if (canSwapFromV2(_ToTokenContractAddress, token1)) {
1133             uint256 token1Bought = swapFromV2(token0, token1, amountA);
1134             tokenBought = swapFromV2(
1135                 token1,
1136                 _ToTokenContractAddress,
1137                 token1Bought.add(amountB)
1138             );
1139         }
1140 
1141         require(tokenBought >= _minTokensRec, "High slippage");
1142 
1143         if (_ToTokenContractAddress == address(0)) {
1144             msg.sender.transfer(tokenBought);
1145         } else {
1146             IERC20(_ToTokenContractAddress).safeTransfer(
1147                 msg.sender,
1148                 tokenBought
1149             );
1150         }
1151 
1152         return tokenBought;
1153     }
1154 
1155     function ZapOut2PairTokenWithPermit(
1156         address _FromUniPoolAddress,
1157         uint256 _IncomingLP,
1158         uint256 _approvalAmount,
1159         uint256 _deadline,
1160         uint8 v,
1161         bytes32 r,
1162         bytes32 s
1163     ) external stopInEmergency returns (uint256 amountA, uint256 amountB) {
1164         // permit
1165         IUniswapV2Pair(_FromUniPoolAddress).permit(
1166             msg.sender,
1167             address(this),
1168             _approvalAmount,
1169             _deadline,
1170             v,
1171             r,
1172             s
1173         );
1174         (amountA, amountB) = ZapOut2PairToken(_FromUniPoolAddress, _IncomingLP);
1175     }
1176 
1177     function ZapOutWithPermit(
1178         address _ToTokenContractAddress,
1179         address _FromUniPoolAddress,
1180         uint256 _IncomingLP,
1181         uint256 _minTokensRec,
1182         uint256 _approvalAmount,
1183         uint256 _deadline,
1184         uint8 v,
1185         bytes32 r,
1186         bytes32 s
1187     ) external stopInEmergency returns (uint256) {
1188         // permit
1189         IUniswapV2Pair(_FromUniPoolAddress).permit(
1190             msg.sender,
1191             address(this),
1192             _approvalAmount,
1193             _deadline,
1194             v,
1195             r,
1196             s
1197         );
1198 
1199         return (
1200             ZapOut(
1201                 _ToTokenContractAddress,
1202                 _FromUniPoolAddress,
1203                 _IncomingLP,
1204                 _minTokensRec
1205             )
1206         );
1207     }
1208 
1209     //swaps _fromToken for _toToken
1210     //for eth, address(0) otherwise ERC token address
1211     function swapFromV2(
1212         address _fromToken,
1213         address _toToken,
1214         uint256 amount
1215     ) internal returns (uint256) {
1216         require(
1217             _fromToken != address(0) || _toToken != address(0),
1218             "Invalid Exchange values"
1219         );
1220         if (_fromToken == _toToken) return amount;
1221 
1222         require(canSwapFromV2(_fromToken, _toToken), "Cannot be exchanged");
1223         require(amount > 0, "Invalid amount");
1224 
1225         if (_fromToken == address(0)) {
1226             if (_toToken == wethTokenAddress) {
1227                 IWETH(wethTokenAddress).deposit.value(amount)();
1228                 return amount;
1229             }
1230             address[] memory path = new address[](2);
1231             path[0] = wethTokenAddress;
1232             path[1] = _toToken;
1233             uint256 minTokens = uniswapV2Router.getAmountsOut(amount, path)[1];
1234             minTokens = SafeMath.div(
1235                 SafeMath.mul(minTokens, SafeMath.sub(10000, 200)),
1236                 10000
1237             );
1238             uint256[] memory amounts = uniswapV2Router
1239                 .swapExactETHForTokens
1240                 .value(amount)(minTokens, path, address(this), deadline);
1241             return amounts[1];
1242         } else if (_toToken == address(0)) {
1243             if (_fromToken == wethTokenAddress) {
1244                 IWETH(wethTokenAddress).withdraw(amount);
1245                 return amount;
1246             }
1247             address[] memory path = new address[](2);
1248             IERC20(_fromToken).safeApprove(address(uniswapV2Router), amount);
1249             path[0] = _fromToken;
1250             path[1] = wethTokenAddress;
1251             uint256 minTokens = uniswapV2Router.getAmountsOut(amount, path)[1];
1252             minTokens = SafeMath.div(
1253                 SafeMath.mul(minTokens, SafeMath.sub(10000, 200)),
1254                 10000
1255             );
1256             uint256[] memory amounts = uniswapV2Router.swapExactTokensForETH(
1257                 amount,
1258                 minTokens,
1259                 path,
1260                 address(this),
1261                 deadline
1262             );
1263             return amounts[1];
1264         } else {
1265             IERC20(_fromToken).safeApprove(address(uniswapV2Router), amount);
1266             uint256 returnedAmount = _swapTokenToTokenV2(
1267                 _fromToken,
1268                 _toToken,
1269                 amount
1270             );
1271             require(returnedAmount > 0, "Error in swap");
1272             return returnedAmount;
1273         }
1274     }
1275 
1276     //swaps 2 ERC tokens (UniV2)
1277     function _swapTokenToTokenV2(
1278         address _fromToken,
1279         address _toToken,
1280         uint256 amount
1281     ) internal returns (uint256) {
1282         IUniswapV2Pair pair1 = IUniswapV2Pair(
1283             UniSwapV2FactoryAddress.getPair(_fromToken, wethTokenAddress)
1284         );
1285         IUniswapV2Pair pair2 = IUniswapV2Pair(
1286             UniSwapV2FactoryAddress.getPair(_toToken, wethTokenAddress)
1287         );
1288         IUniswapV2Pair pair3 = IUniswapV2Pair(
1289             UniSwapV2FactoryAddress.getPair(_fromToken, _toToken)
1290         );
1291 
1292         uint256[] memory amounts;
1293 
1294         if (_haveReserve(pair3)) {
1295             address[] memory path = new address[](2);
1296             path[0] = _fromToken;
1297             path[1] = _toToken;
1298             uint256 minTokens = uniswapV2Router.getAmountsOut(amount, path)[1];
1299             minTokens = SafeMath.div(
1300                 SafeMath.mul(minTokens, SafeMath.sub(10000, 200)),
1301                 10000
1302             );
1303             amounts = uniswapV2Router.swapExactTokensForTokens(
1304                 amount,
1305                 minTokens,
1306                 path,
1307                 address(this),
1308                 deadline
1309             );
1310             return amounts[1];
1311         } else if (_haveReserve(pair1) && _haveReserve(pair2)) {
1312             address[] memory path = new address[](3);
1313             path[0] = _fromToken;
1314             path[1] = wethTokenAddress;
1315             path[2] = _toToken;
1316             uint256 minTokens = uniswapV2Router.getAmountsOut(amount, path)[2];
1317             minTokens = SafeMath.div(
1318                 SafeMath.mul(minTokens, SafeMath.sub(10000, 200)),
1319                 10000
1320             );
1321             amounts = uniswapV2Router.swapExactTokensForTokens(
1322                 amount,
1323                 minTokens,
1324                 path,
1325                 address(this),
1326                 deadline
1327             );
1328             return amounts[2];
1329         }
1330         return 0;
1331     }
1332 
1333     function canSwapFromV2(address _fromToken, address _toToken)
1334         public
1335         view
1336         returns (bool)
1337     {
1338         require(
1339             _fromToken != address(0) || _toToken != address(0),
1340             "Invalid Exchange values"
1341         );
1342 
1343         if (_fromToken == _toToken) return true;
1344 
1345         if (_fromToken == address(0) || _fromToken == wethTokenAddress) {
1346             if (_toToken == wethTokenAddress || _toToken == address(0))
1347                 return true;
1348             IUniswapV2Pair pair = IUniswapV2Pair(
1349                 UniSwapV2FactoryAddress.getPair(_toToken, wethTokenAddress)
1350             );
1351             if (_haveReserve(pair)) return true;
1352         } else if (_toToken == address(0) || _toToken == wethTokenAddress) {
1353             if (_fromToken == wethTokenAddress || _fromToken == address(0))
1354                 return true;
1355             IUniswapV2Pair pair = IUniswapV2Pair(
1356                 UniSwapV2FactoryAddress.getPair(_fromToken, wethTokenAddress)
1357             );
1358             if (_haveReserve(pair)) return true;
1359         } else {
1360             IUniswapV2Pair pair1 = IUniswapV2Pair(
1361                 UniSwapV2FactoryAddress.getPair(_fromToken, wethTokenAddress)
1362             );
1363             IUniswapV2Pair pair2 = IUniswapV2Pair(
1364                 UniSwapV2FactoryAddress.getPair(_toToken, wethTokenAddress)
1365             );
1366             IUniswapV2Pair pair3 = IUniswapV2Pair(
1367                 UniSwapV2FactoryAddress.getPair(_fromToken, _toToken)
1368             );
1369             if (_haveReserve(pair1) && _haveReserve(pair2)) return true;
1370             if (_haveReserve(pair3)) return true;
1371         }
1372         return false;
1373     }
1374 
1375     //checks if the UNI v2 contract have reserves to swap tokens
1376     function _haveReserve(IUniswapV2Pair pair) internal view returns (bool) {
1377         if (address(pair) != address(0)) {
1378             uint256 totalSupply = pair.totalSupply();
1379             if (totalSupply > 0) return true;
1380         }
1381     }
1382 
1383     /**
1384     @notice This function is used to calculate and transfer goodwill
1385     @param _tokenContractAddress Token in which goodwill is deducted
1386     @param tokens2Trade The total amount of tokens to be zapped in
1387     @return The quantity of goodwill deducted
1388      */
1389     function _transferGoodwill(
1390         address _tokenContractAddress,
1391         uint256 tokens2Trade
1392     ) internal returns (uint256 goodwillPortion) {
1393         if (goodwill == 0) {
1394             return 0;
1395         }
1396 
1397         goodwillPortion = SafeMath.div(
1398             SafeMath.mul(tokens2Trade, goodwill),
1399             10000
1400         );
1401 
1402         IERC20(_tokenContractAddress).safeTransfer(
1403             zgoodwillAddress,
1404             goodwillPortion
1405         );
1406     }
1407 
1408     function set_new_goodwill(uint16 _new_goodwill) public onlyOwner {
1409         require(
1410             _new_goodwill >= 0 && _new_goodwill < 10000,
1411             "GoodWill Value not allowed"
1412         );
1413         goodwill = _new_goodwill;
1414     }
1415 
1416     function inCaseTokengetsStuck(IERC20 _TokenAddress) public onlyOwner {
1417         uint256 qty = _TokenAddress.balanceOf(address(this));
1418         _TokenAddress.safeTransfer(owner(), qty);
1419     }
1420 
1421     // - to Pause the contract
1422     function toggleContractActive() public onlyOwner {
1423         stopped = !stopped;
1424     }
1425 
1426     // - to withdraw any ETH balance sitting in the contract
1427     function withdraw() public onlyOwner {
1428         uint256 contractBalance = address(this).balance;
1429         address payable _to = owner().toPayable();
1430         _to.transfer(contractBalance);
1431     }
1432 
1433     function() external payable {
1434         require(msg.sender != tx.origin, "Do not send ETH directly");
1435     }
1436 }