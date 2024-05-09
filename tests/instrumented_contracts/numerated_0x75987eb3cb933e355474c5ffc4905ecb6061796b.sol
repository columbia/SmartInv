1 // ███████╗░█████╗░██████╗░██████╗░███████╗██████╗░░░░███████╗██╗
2 // ╚════██║██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗░░░██╔════╝██║
3 // ░░███╔═╝███████║██████╔╝██████╔╝█████╗░░██████╔╝░░░█████╗░░██║
4 // ██╔══╝░░██╔══██║██╔═══╝░██╔═══╝░██╔══╝░░██╔══██╗░░░██╔══╝░░██║
5 // ███████╗██║░░██║██║░░░░░██║░░░░░███████╗██║░░██║██╗██║░░░░░██║
6 // ╚══════╝╚═╝░░╚═╝╚═╝░░░░░╚═╝░░░░░╚══════╝╚═╝░░╚═╝╚═╝╚═╝░░░░░╚═╝
7 // Copyright (C) 2020 zapper
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
19 
20 ///@author Zapper
21 ///@notice This contract adds liquidity to Curve pools in one transaction with ETH or ERC tokens.
22 
23 // File: Context.sol
24 
25 pragma solidity ^0.5.5;
26 
27 /*
28  * @dev Provides information about the current execution context, including the
29  * sender of the transaction and its data. While these are generally available
30  * via msg.sender and msg.data, they should not be accessed in such a direct
31  * manner, since when dealing with GSN meta-transactions the account sending and
32  * paying for execution may not be the actual sender (as far as an application
33  * is concerned).
34  *
35  * This contract is only required for intermediate, library-like contracts.
36  */
37 contract Context {
38     // Empty internal constructor, to prevent people from mistakenly deploying
39     // an instance of this contract, which should be used via inheritance.
40     constructor() internal {}
41 
42     // solhint-disable-previous-line no-empty-blocks
43 
44     function _msgSender() internal view returns (address payable) {
45         return msg.sender;
46     }
47 
48     function _msgData() internal view returns (bytes memory) {
49         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
50         return msg.data;
51     }
52 }
53 // File: OpenZepplinOwnable.sol
54 
55 pragma solidity ^0.5.0;
56 
57 /**
58  * @dev Contract module which provides a basic access control mechanism, where
59  * there is an account (an owner) that can be granted exclusive access to
60  * specific functions.
61  *
62  * This module is used through inheritance. It will make available the modifier
63  * `onlyOwner`, which can be applied to your functions to restrict their use to
64  * the owner.
65  */
66 contract Ownable is Context {
67     address payable public _owner;
68 
69     event OwnershipTransferred(
70         address indexed previousOwner,
71         address indexed newOwner
72     );
73 
74     /**
75      * @dev Initializes the contract setting the deployer as the initial owner.
76      */
77     constructor() internal {
78         address payable msgSender = _msgSender();
79         _owner = msgSender;
80         emit OwnershipTransferred(address(0), msgSender);
81     }
82 
83     /**
84      * @dev Returns the address of the current owner.
85      */
86     function owner() public view returns (address) {
87         return _owner;
88     }
89 
90     /**
91      * @dev Throws if called by any account other than the owner.
92      */
93     modifier onlyOwner() {
94         require(isOwner(), "Ownable: caller is not the owner");
95         _;
96     }
97 
98     /**
99      * @dev Returns true if the caller is the current owner.
100      */
101     function isOwner() public view returns (bool) {
102         return _msgSender() == _owner;
103     }
104 
105     /**
106      * @dev Leaves the contract without owner. It will not be possible to call
107      * `onlyOwner` functions anymore. Can only be called by the current owner.
108      *
109      * NOTE: Renouncing ownership will leave the contract without an owner,
110      * thereby removing any functionality that is only available to the owner.
111      */
112     function renounceOwnership() public onlyOwner {
113         emit OwnershipTransferred(_owner, address(0));
114         _owner = address(0);
115     }
116 
117     /**
118      * @dev Transfers ownership of the contract to a new account (`newOwner`).
119      * Can only be called by the current owner.
120      */
121     function transferOwnership(address payable newOwner) public onlyOwner {
122         _transferOwnership(newOwner);
123     }
124 
125     /**
126      * @dev Transfers ownership of the contract to a new account (`newOwner`).
127      */
128     function _transferOwnership(address payable newOwner) internal {
129         require(
130             newOwner != address(0),
131             "Ownable: new owner is the zero address"
132         );
133         emit OwnershipTransferred(_owner, newOwner);
134         _owner = newOwner;
135     }
136 }
137 // File: OpenZepplinSafeMath.sol
138 
139 pragma solidity ^0.5.0;
140 
141 /**
142  * @dev Wrappers over Solidity's arithmetic operations with added overflow
143  * checks.
144  *
145  * Arithmetic operations in Solidity wrap on overflow. This can easily result
146  * in bugs, because programmers usually assume that an overflow raises an
147  * error, which is the standard behavior in high level programming languages.
148  * `SafeMath` restores this intuition by reverting the transaction when an
149  * operation overflows.
150  *
151  * Using this library instead of the unchecked operations eliminates an entire
152  * class of bugs, so it's recommended to use it always.
153  */
154 library SafeMath {
155     /**
156      * @dev Returns the addition of two unsigned integers, reverting on
157      * overflow.
158      *
159      * Counterpart to Solidity's `+` operator.
160      *
161      * Requirements:
162      * - Addition cannot overflow.
163      */
164     function add(uint256 a, uint256 b) internal pure returns (uint256) {
165         uint256 c = a + b;
166         require(c >= a, "SafeMath: addition overflow");
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the subtraction of two unsigned integers, reverting on
173      * overflow (when the result is negative).
174      *
175      * Counterpart to Solidity's `-` operator.
176      *
177      * Requirements:
178      * - Subtraction cannot overflow.
179      */
180     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
181         return sub(a, b, "SafeMath: subtraction overflow");
182     }
183 
184     /**
185      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
186      * overflow (when the result is negative).
187      *
188      * Counterpart to Solidity's `-` operator.
189      *
190      * Requirements:
191      * - Subtraction cannot overflow.
192      *
193      * _Available since v2.4.0._
194      */
195     function sub(
196         uint256 a,
197         uint256 b,
198         string memory errorMessage
199     ) internal pure returns (uint256) {
200         require(b <= a, errorMessage);
201         uint256 c = a - b;
202 
203         return c;
204     }
205 
206     /**
207      * @dev Returns the multiplication of two unsigned integers, reverting on
208      * overflow.
209      *
210      * Counterpart to Solidity's `*` operator.
211      *
212      * Requirements:
213      * - Multiplication cannot overflow.
214      */
215     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
216         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
217         // benefit is lost if 'b' is also tested.
218         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
219         if (a == 0) {
220             return 0;
221         }
222 
223         uint256 c = a * b;
224         require(c / a == b, "SafeMath: multiplication overflow");
225 
226         return c;
227     }
228 
229     /**
230      * @dev Returns the integer division of two unsigned integers. Reverts on
231      * division by zero. The result is rounded towards zero.
232      *
233      * Counterpart to Solidity's `/` operator. Note: this function uses a
234      * `revert` opcode (which leaves remaining gas untouched) while Solidity
235      * uses an invalid opcode to revert (consuming all remaining gas).
236      *
237      * Requirements:
238      * - The divisor cannot be zero.
239      */
240     function div(uint256 a, uint256 b) internal pure returns (uint256) {
241         return div(a, b, "SafeMath: division by zero");
242     }
243 
244     /**
245      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
246      * division by zero. The result is rounded towards zero.
247      *
248      * Counterpart to Solidity's `/` operator. Note: this function uses a
249      * `revert` opcode (which leaves remaining gas untouched) while Solidity
250      * uses an invalid opcode to revert (consuming all remaining gas).
251      *
252      * Requirements:
253      * - The divisor cannot be zero.
254      *
255      * _Available since v2.4.0._
256      */
257     function div(
258         uint256 a,
259         uint256 b,
260         string memory errorMessage
261     ) internal pure returns (uint256) {
262         // Solidity only automatically asserts when dividing by 0
263         require(b > 0, errorMessage);
264         uint256 c = a / b;
265         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
266 
267         return c;
268     }
269 
270     /**
271      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
272      * Reverts when dividing by zero.
273      *
274      * Counterpart to Solidity's `%` operator. This function uses a `revert`
275      * opcode (which leaves remaining gas untouched) while Solidity uses an
276      * invalid opcode to revert (consuming all remaining gas).
277      *
278      * Requirements:
279      * - The divisor cannot be zero.
280      */
281     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
282         return mod(a, b, "SafeMath: modulo by zero");
283     }
284 
285     /**
286      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
287      * Reverts with custom message when dividing by zero.
288      *
289      * Counterpart to Solidity's `%` operator. This function uses a `revert`
290      * opcode (which leaves remaining gas untouched) while Solidity uses an
291      * invalid opcode to revert (consuming all remaining gas).
292      *
293      * Requirements:
294      * - The divisor cannot be zero.
295      *
296      * _Available since v2.4.0._
297      */
298     function mod(
299         uint256 a,
300         uint256 b,
301         string memory errorMessage
302     ) internal pure returns (uint256) {
303         require(b != 0, errorMessage);
304         return a % b;
305     }
306 }
307 // File: OpenZepplinIERC20.sol
308 
309 pragma solidity ^0.5.0;
310 
311 /**
312  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
313  * the optional functions; to access them see {ERC20Detailed}.
314  */
315 interface IERC20 {
316     /**
317      * @dev Returns the amount of tokens in existence.
318      */
319     function totalSupply() external view returns (uint256);
320 
321     /**
322      * @dev Returns the amount of tokens owned by `account`.
323      */
324     function balanceOf(address account) external view returns (uint256);
325 
326     /**
327      * @dev Moves `amount` tokens from the caller's account to `recipient`.
328      *
329      * Returns a boolean value indicating whether the operation succeeded.
330      *
331      * Emits a {Transfer} event.
332      */
333     function transfer(address recipient, uint256 amount)
334         external
335         returns (bool);
336 
337     /**
338      * @dev Returns the remaining number of tokens that `spender` will be
339      * allowed to spend on behalf of `owner` through {transferFrom}. This is
340      * zero by default.
341      *
342      * This value changes when {approve} or {transferFrom} are called.
343      */
344     function allowance(address owner, address spender)
345         external
346         view
347         returns (uint256);
348 
349     /**
350      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
351      *
352      * Returns a boolean value indicating whether the operation succeeded.
353      *
354      * IMPORTANT: Beware that changing an allowance with this method brings the risk
355      * that someone may use both the old and the new allowance by unfortunate
356      * transaction ordering. One possible solution to mitigate this race
357      * condition is to first reduce the spender's allowance to 0 and set the
358      * desired value afterwards:
359      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
360      *
361      * Emits an {Approval} event.
362      */
363     function approve(address spender, uint256 amount) external returns (bool);
364 
365     /**
366      * @dev Moves `amount` tokens from `sender` to `recipient` using the
367      * allowance mechanism. `amount` is then deducted from the caller's
368      * allowance.
369      *
370      * Returns a boolean value indicating whether the operation succeeded.
371      *
372      * Emits a {Transfer} event.
373      */
374     function transferFrom(
375         address sender,
376         address recipient,
377         uint256 amount
378     ) external returns (bool);
379 
380     /**
381      * @dev Emitted when `value` tokens are moved from one account (`from`) to
382      * another (`to`).
383      *
384      * Note that `value` may be zero.
385      */
386     event Transfer(address indexed from, address indexed to, uint256 value);
387 
388     /**
389      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
390      * a call to {approve}. `value` is the new allowance.
391      */
392     event Approval(
393         address indexed owner,
394         address indexed spender,
395         uint256 value
396     );
397 }
398 // File: OpenZepplinReentrancyGuard.sol
399 
400 pragma solidity ^0.5.0;
401 
402 /**
403  * @dev Contract module that helps prevent reentrant calls to a function.
404  *
405  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
406  * available, which can be applied to functions to make sure there are no nested
407  * (reentrant) calls to them.
408  *
409  * Note that because there is a single `nonReentrant` guard, functions marked as
410  * `nonReentrant` may not call one another. This can be worked around by making
411  * those functions `private`, and then adding `external` `nonReentrant` entry
412  * points to them.
413  *
414  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
415  * metering changes introduced in the Istanbul hardfork.
416  */
417 contract ReentrancyGuard {
418     bool private _notEntered;
419 
420     constructor() internal {
421         // Storing an initial non-zero value makes deployment a bit more
422         // expensive, but in exchange the refund on every call to nonReentrant
423         // will be lower in amount. Since refunds are capped to a percetange of
424         // the total transaction's gas, it is best to keep them low in cases
425         // like this one, to increase the likelihood of the full refund coming
426         // into effect.
427         _notEntered = true;
428     }
429 
430     /**
431      * @dev Prevents a contract from calling itself, directly or indirectly.
432      * Calling a `nonReentrant` function from another `nonReentrant`
433      * function is not supported. It is possible to prevent this from happening
434      * by making the `nonReentrant` function external, and make it call a
435      * `private` function that does the actual work.
436      */
437     modifier nonReentrant() {
438         // On the first call to nonReentrant, _notEntered will be true
439         require(_notEntered, "ReentrancyGuard: reentrant call");
440 
441         // Any calls to nonReentrant after this point will fail
442         _notEntered = false;
443 
444         _;
445 
446         // By storing the original value once again, a refund is triggered (see
447         // https://eips.ethereum.org/EIPS/eip-2200)
448         _notEntered = true;
449     }
450 }
451 
452 // File: @openzeppelin/contracts/utils/Address.sol
453 
454 pragma solidity ^0.5.5;
455 
456 /**
457  * @dev Collection of functions related to the address type
458  */
459 library Address {
460     /**
461      * @dev Returns true if `account` is a contract.
462      *
463      * [IMPORTANT]
464      * ====
465      * It is unsafe to assume that an address for which this function returns
466      * false is an externally-owned account (EOA) and not a contract.
467      *
468      * Among others, `isContract` will return false for the following
469      * types of addresses:
470      *
471      *  - an externally-owned account
472      *  - a contract in construction
473      *  - an address where a contract will be created
474      *  - an address where a contract lived, but was destroyed
475      * ====
476      */
477     function isContract(address account) internal view returns (bool) {
478         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
479         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
480         // for accounts without code, i.e. `keccak256('')`
481         bytes32 codehash;
482 
483 
484             bytes32 accountHash
485          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
486         // solhint-disable-next-line no-inline-assembly
487         assembly {
488             codehash := extcodehash(account)
489         }
490         return (codehash != accountHash && codehash != 0x0);
491     }
492 
493     /**
494      * @dev Converts an `address` into `address payable`. Note that this is
495      * simply a type cast: the actual underlying value is not changed.
496      *
497      * _Available since v2.4.0._
498      */
499     function toPayable(address account)
500         internal
501         pure
502         returns (address payable)
503     {
504         return address(uint160(account));
505     }
506 
507     /**
508      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
509      * `recipient`, forwarding all available gas and reverting on errors.
510      *
511      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
512      * of certain opcodes, possibly making contracts go over the 2300 gas limit
513      * imposed by `transfer`, making them unable to receive funds via
514      * `transfer`. {sendValue} removes this limitation.
515      *
516      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
517      *
518      * IMPORTANT: because control is transferred to `recipient`, care must be
519      * taken to not create reentrancy vulnerabilities. Consider using
520      * {ReentrancyGuard} or the
521      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
522      *
523      * _Available since v2.4.0._
524      */
525     function sendValue(address payable recipient, uint256 amount) internal {
526         require(
527             address(this).balance >= amount,
528             "Address: insufficient balance"
529         );
530 
531         // solhint-disable-next-line avoid-call-value
532         (bool success, ) = recipient.call.value(amount)("");
533         require(
534             success,
535             "Address: unable to send value, recipient may have reverted"
536         );
537     }
538 }
539 
540 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
541 
542 pragma solidity ^0.5.0;
543 
544 /**
545  * @title SafeERC20
546  * @dev Wrappers around ERC20 operations that throw on failure (when the token
547  * contract returns false). Tokens that return no value (and instead revert or
548  * throw on failure) are also supported, non-reverting calls are assumed to be
549  * successful.
550  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
551  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
552  */
553 library SafeERC20 {
554     using SafeMath for uint256;
555     using Address for address;
556 
557     function safeTransfer(
558         IERC20 token,
559         address to,
560         uint256 value
561     ) internal {
562         callOptionalReturn(
563             token,
564             abi.encodeWithSelector(token.transfer.selector, to, value)
565         );
566     }
567 
568     function safeTransferFrom(
569         IERC20 token,
570         address from,
571         address to,
572         uint256 value
573     ) internal {
574         callOptionalReturn(
575             token,
576             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
577         );
578     }
579 
580     function safeApprove(
581         IERC20 token,
582         address spender,
583         uint256 value
584     ) internal {
585         // safeApprove should only be called when setting an initial allowance,
586         // or when resetting it to zero. To increase and decrease it, use
587         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
588         // solhint-disable-next-line max-line-length
589         require(
590             (value == 0) || (token.allowance(address(this), spender) == 0),
591             "SafeERC20: approve from non-zero to non-zero allowance"
592         );
593         callOptionalReturn(
594             token,
595             abi.encodeWithSelector(token.approve.selector, spender, value)
596         );
597     }
598 
599     function safeIncreaseAllowance(
600         IERC20 token,
601         address spender,
602         uint256 value
603     ) internal {
604         uint256 newAllowance = token.allowance(address(this), spender).add(
605             value
606         );
607         callOptionalReturn(
608             token,
609             abi.encodeWithSelector(
610                 token.approve.selector,
611                 spender,
612                 newAllowance
613             )
614         );
615     }
616 
617     function safeDecreaseAllowance(
618         IERC20 token,
619         address spender,
620         uint256 value
621     ) internal {
622         uint256 newAllowance = token.allowance(address(this), spender).sub(
623             value,
624             "SafeERC20: decreased allowance below zero"
625         );
626         callOptionalReturn(
627             token,
628             abi.encodeWithSelector(
629                 token.approve.selector,
630                 spender,
631                 newAllowance
632             )
633         );
634     }
635 
636     /**
637      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
638      * on the return value: the return value is optional (but if data is returned, it must not be false).
639      * @param token The token targeted by the call.
640      * @param data The call data (encoded using abi.encode or one of its variants).
641      */
642     function callOptionalReturn(IERC20 token, bytes memory data) private {
643         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
644         // we're implementing it ourselves.
645 
646         // A Solidity high level call has three parts:
647         //  1. The target address is checked to verify it contains contract code
648         //  2. The call itself is made, and success asserted
649         //  3. The return value is decoded, which in turn checks the size of the returned data.
650         // solhint-disable-next-line max-line-length
651         require(address(token).isContract(), "SafeERC20: call to non-contract");
652 
653         // solhint-disable-next-line avoid-low-level-calls
654         (bool success, bytes memory returndata) = address(token).call(data);
655         require(success, "SafeERC20: low-level call failed");
656 
657         if (returndata.length > 0) {
658             // Return data is optional
659             // solhint-disable-next-line max-line-length
660             require(
661                 abi.decode(returndata, (bool)),
662                 "SafeERC20: ERC20 operation did not succeed"
663             );
664         }
665     }
666 }
667 
668 interface ICurveSwap {
669     function coins(int128 arg0) external view returns (address);
670 
671     function underlying_coins(int128 arg0) external view returns (address);
672 
673     function add_liquidity(uint256[4] calldata amounts, uint256 min_mint_amount)
674         external;
675 
676     function add_liquidity(uint256[3] calldata amounts, uint256 min_mint_amount)
677         external;
678 
679     function add_liquidity(
680         uint256[3] calldata amounts,
681         uint256 min_mint_amount,
682         bool isUnderLying
683     ) external;
684 
685     function add_liquidity(uint256[2] calldata amounts, uint256 min_mint_amount)
686         external;
687 }
688 
689 interface ICurveEthSwap {
690     function add_liquidity(uint256[2] calldata amounts, uint256 min_mint_amount)
691         external
692         payable
693         returns (uint256);
694 }
695 
696 interface yERC20 {
697     function deposit(uint256 _amount) external;
698 }
699 
700 interface IWETH {
701     function deposit() external payable;
702 
703     function transfer(address to, uint256 value) external returns (bool);
704 
705     function withdraw(uint256) external;
706 }
707 
708 interface ICurveRegistry {
709     function metaPools(address tokenAddress)
710         external
711         view
712         returns (address swapAddress);
713 
714     function getTokenAddress(address swapAddress)
715         external
716         view
717         returns (address tokenAddress);
718 
719     function getPoolTokens(address swapAddress)
720         external
721         view
722         returns (address[4] memory poolTokens);
723 
724     function isMetaPool(address swapAddress) external view returns (bool);
725 
726     function getNumTokens(address swapAddress)
727         external
728         view
729         returns (uint8 numTokens);
730 
731     function isBtcPool(address swapAddress) external view returns (bool);
732 
733     function isUnderlyingToken(
734         address swapAddress,
735         address tokenContractAddress
736     ) external view returns (bool, uint8);
737 }
738 
739 contract Curve_ZapIn_General_V3 is ReentrancyGuard, Ownable {
740     using SafeMath for uint256;
741     using SafeERC20 for IERC20;
742     bool public stopped = false;
743     uint16 public goodwill;
744 
745     // if true, goodwill is not deducted
746     mapping(address => bool) public feeWhitelist;
747 
748     // % share of goodwill (0-100 %)
749     uint16 affiliateSplit;
750     // restrict affiliates
751     mapping(address => bool) public affiliates;
752     // affiliate => token => amount
753     mapping(address => mapping(address => uint256)) public affiliateBalance;
754     // token => amount
755     mapping(address => uint256) public totalAffiliateBalance;
756 
757     address
758         private constant ETHAddress = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
759 
760     ICurveRegistry public curveReg;
761 
762     address private Aave = 0xDeBF20617708857ebe4F679508E7b7863a8A8EeE;
763 
764     // circuit breaker modifiers
765     modifier stopInEmergency {
766         if (stopped) {
767             revert("Temporarily Paused");
768         } else {
769             _;
770         }
771     }
772 
773     constructor(
774         ICurveRegistry _curveRegistry,
775         uint16 _goodwill,
776         uint16 _affiliateSplit
777     ) public {
778         curveReg = _curveRegistry;
779         goodwill = _goodwill;
780         affiliateSplit = _affiliateSplit;
781     }
782 
783     event zapIn(address sender, address pool, uint256 crvTokens);
784 
785     /**
786     @notice This function adds liquidity to a Curve pool with ETH or ERC20 tokens
787     @param _fromTokenAddress The token used for entry (address(0) if ether)
788     @param _toTokenAddress The intermediate ERC20 token to swap to
789     @param _swapAddress Curve swap address for the pool
790     @param _incomingTokenQty The amount of fromToken to invest
791     @param _minPoolTokens The minimum acceptable quantity of Curve LP to receive. Reverts otherwise
792     @param _swapTarget Excecution target for the first swap
793     @param _swapCallData DEX quote data
794     @param affiliate Affiliate address
795     @return crvTokensBought- Quantity of Curve LP tokens received
796      */
797     function ZapIn(
798         address _fromTokenAddress,
799         address _toTokenAddress,
800         address _swapAddress,
801         uint256 _incomingTokenQty,
802         uint256 _minPoolTokens,
803         address _swapTarget,
804         bytes calldata _swapCallData,
805         address affiliate
806     )
807         external
808         payable
809         stopInEmergency
810         nonReentrant
811         returns (uint256 crvTokensBought)
812     {
813         uint256 toInvest = _pullTokens(
814             _fromTokenAddress,
815             _incomingTokenQty,
816             affiliate
817         );
818         if (_fromTokenAddress == address(0)) {
819             _fromTokenAddress = ETHAddress;
820         }
821 
822         // perform zapIn
823         crvTokensBought = _performZapIn(
824             _fromTokenAddress,
825             _toTokenAddress,
826             _swapAddress,
827             toInvest,
828             _swapTarget,
829             _swapCallData
830         );
831 
832         require(
833             crvTokensBought > _minPoolTokens,
834             "Received less than minPoolTokens"
835         );
836 
837         address poolTokenAddress = curveReg.getTokenAddress(_swapAddress);
838 
839         emit zapIn(msg.sender, poolTokenAddress, crvTokensBought);
840 
841         // transfer crvTokens to msg.sender
842         IERC20(poolTokenAddress).transfer(msg.sender, crvTokensBought);
843     }
844 
845     function _performZapIn(
846         address _fromTokenAddress,
847         address _toTokenAddress,
848         address _swapAddress,
849         uint256 toInvest,
850         address _swapTarget,
851         bytes memory _swapCallData
852     ) internal returns (uint256 crvTokensBought) {
853         (bool isUnderlying, uint8 underlyingIndex) = curveReg.isUnderlyingToken(
854             _swapAddress,
855             _fromTokenAddress
856         );
857 
858         if (isUnderlying) {
859             crvTokensBought = _enterCurve(
860                 _swapAddress,
861                 toInvest,
862                 underlyingIndex
863             );
864         } else {
865             //swap tokens using 0x swap
866             uint256 tokensBought = _fillQuote(
867                 _fromTokenAddress,
868                 _toTokenAddress,
869                 toInvest,
870                 _swapTarget,
871                 _swapCallData
872             );
873             if (_toTokenAddress == address(0)) _toTokenAddress = ETHAddress;
874 
875             //get underlying token index
876             (isUnderlying, underlyingIndex) = curveReg.isUnderlyingToken(
877                 _swapAddress,
878                 _toTokenAddress
879             );
880 
881             if (isUnderlying) {
882                 crvTokensBought = _enterCurve(
883                     _swapAddress,
884                     tokensBought,
885                     underlyingIndex
886                 );
887             } else {
888                 (uint256 tokens, uint8 metaIndex) = _enterMetaPool(
889                     _swapAddress,
890                     _toTokenAddress,
891                     tokensBought
892                 );
893 
894                 crvTokensBought = _enterCurve(_swapAddress, tokens, metaIndex);
895             }
896         }
897     }
898 
899     function _pullTokens(
900         address token,
901         uint256 amount,
902         address affiliate
903     ) internal returns (uint256) {
904         uint256 totalGoodwillPortion;
905 
906         if (token == address(0)) {
907             require(msg.value > 0, "No eth sent");
908 
909             // subtract goodwill
910             totalGoodwillPortion = _subtractGoodwill(
911                 ETHAddress,
912                 msg.value,
913                 affiliate
914             );
915 
916             return msg.value.sub(totalGoodwillPortion);
917         }
918         require(amount > 0, "Invalid token amount");
919         require(msg.value == 0, "Eth sent with token");
920 
921         //transfer token
922         IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
923 
924         // subtract goodwill
925         totalGoodwillPortion = _subtractGoodwill(token, amount, affiliate);
926 
927         return amount.sub(totalGoodwillPortion);
928     }
929 
930     function _subtractGoodwill(
931         address token,
932         uint256 amount,
933         address affiliate
934     ) internal returns (uint256 totalGoodwillPortion) {
935         bool whitelisted = feeWhitelist[msg.sender];
936         if (!whitelisted && goodwill > 0) {
937             totalGoodwillPortion = SafeMath.div(
938                 SafeMath.mul(amount, goodwill),
939                 10000
940             );
941 
942             if (affiliates[affiliate]) {
943                 uint256 affiliatePortion = totalGoodwillPortion
944                     .mul(affiliateSplit)
945                     .div(100);
946                 affiliateBalance[affiliate][token] = affiliateBalance[affiliate][token]
947                     .add(affiliatePortion);
948                 totalAffiliateBalance[token] = totalAffiliateBalance[token].add(
949                     affiliatePortion
950                 );
951             }
952         }
953     }
954 
955     /**
956     @notice This function gets adds the liquidity for meta pools and returns the token index and swap tokens
957     @param _swapAddress Curve swap address for the pool
958     @param _toTokenAddress The ERC20 token to which from token to be convert
959     @param  swapTokens amount of toTokens to invest
960     @return tokensBought- quantity of curve LP acquired
961     @return index- index of LP token in _swapAddress whose pool tokens were acquired
962      */
963     function _enterMetaPool(
964         address _swapAddress,
965         address _toTokenAddress,
966         uint256 swapTokens
967     ) internal returns (uint256 tokensBought, uint8 index) {
968         address[4] memory poolTokens = curveReg.getPoolTokens(_swapAddress);
969         for (uint8 i = 0; i < 4; i++) {
970             address intermediateSwapAddress = curveReg.metaPools(poolTokens[i]);
971             if (intermediateSwapAddress != address(0)) {
972                 (, index) = curveReg.isUnderlyingToken(
973                     intermediateSwapAddress,
974                     _toTokenAddress
975                 );
976 
977                 tokensBought = _enterCurve(
978                     intermediateSwapAddress,
979                     swapTokens,
980                     index
981                 );
982 
983                 return (tokensBought, i);
984             }
985         }
986     }
987 
988     function _fillQuote(
989         address _fromTokenAddress,
990         address _toTokenAddress,
991         uint256 _amount,
992         address _swapTarget,
993         bytes memory _swapCallData
994     ) internal returns (uint256 amountBought) {
995         uint256 valueToSend;
996 
997         if (_fromTokenAddress == _toTokenAddress) {
998             return _amount;
999         }
1000         if (_fromTokenAddress == ETHAddress) {
1001             valueToSend = _amount;
1002         } else {
1003             IERC20 fromToken = IERC20(_fromTokenAddress);
1004 
1005             require(
1006                 fromToken.balanceOf(address(this)) >= _amount,
1007                 "Insufficient Balance"
1008             );
1009 
1010             fromToken.safeApprove(address(_swapTarget), 0);
1011             fromToken.safeApprove(address(_swapTarget), _amount);
1012         }
1013 
1014         uint256 initialBalance = _toTokenAddress == address(0)
1015             ? address(this).balance
1016             : IERC20(_toTokenAddress).balanceOf(address(this));
1017 
1018         (bool success, ) = _swapTarget.call.value(valueToSend)(_swapCallData);
1019         require(success, "Error Swapping Tokens");
1020 
1021         amountBought = _toTokenAddress == address(0)
1022             ? (address(this).balance).sub(initialBalance)
1023             : IERC20(_toTokenAddress).balanceOf(address(this)).sub(
1024                 initialBalance
1025             );
1026 
1027         require(amountBought > 0, "Swapped To Invalid Intermediate");
1028     }
1029 
1030     /**
1031     @notice This function adds liquidity to a curve pool
1032     @param _swapAddress Curve swap address for the pool
1033     @param amount The quantity of tokens being added as liquidity
1034     @param index The token index for the add_liquidity call
1035     @return crvTokensBought- the quantity of curve LP tokens received
1036     */
1037     function _enterCurve(
1038         address _swapAddress,
1039         uint256 amount,
1040         uint8 index
1041     ) internal returns (uint256 crvTokensBought) {
1042         address tokenAddress = curveReg.getTokenAddress(_swapAddress);
1043         uint256 initialBalance = IERC20(tokenAddress).balanceOf(address(this));
1044         address entryToken = curveReg.getPoolTokens(_swapAddress)[index];
1045         if (entryToken != ETHAddress) {
1046             IERC20(entryToken).safeIncreaseAllowance(
1047                 address(_swapAddress),
1048                 amount
1049             );
1050         }
1051         uint256 numTokens = curveReg.getNumTokens(_swapAddress);
1052         if (numTokens == 4) {
1053             uint256[4] memory amounts;
1054             amounts[index] = amount;
1055             ICurveSwap(_swapAddress).add_liquidity(amounts, 0);
1056         } else if (numTokens == 3) {
1057             uint256[3] memory amounts;
1058             amounts[index] = amount;
1059             if (_swapAddress == Aave) {
1060                 ICurveSwap(_swapAddress).add_liquidity(amounts, 0, true);
1061             } else {
1062                 ICurveSwap(_swapAddress).add_liquidity(amounts, 0);
1063             }
1064         } else {
1065             uint256[2] memory amounts;
1066             amounts[index] = amount;
1067             if (isETHUnderlying(_swapAddress)) {
1068                 ICurveEthSwap(_swapAddress).add_liquidity.value(amount)(
1069                     amounts,
1070                     0
1071                 );
1072             } else {
1073                 ICurveSwap(_swapAddress).add_liquidity(amounts, 0);
1074             }
1075         }
1076         crvTokensBought = (IERC20(tokenAddress).balanceOf(address(this))).sub(
1077             initialBalance
1078         );
1079     }
1080 
1081     function isETHUnderlying(address _swapAddress)
1082         internal
1083         view
1084         returns (bool)
1085     {
1086         address[4] memory poolTokens = curveReg.getPoolTokens(_swapAddress);
1087         for (uint8 i = 0; i < 4; i++) {
1088             if (poolTokens[i] == ETHAddress) {
1089                 return true;
1090             }
1091         }
1092         return false;
1093     }
1094 
1095     function updateAaveAddress(address _newAddress) external onlyOwner {
1096         require(_newAddress != address(0), "Zero Address");
1097         Aave = _newAddress;
1098     }
1099 
1100     function set_new_goodwill(uint16 _new_goodwill) external onlyOwner {
1101         require(
1102             _new_goodwill >= 0 && _new_goodwill < 100,
1103             "GoodWill Value not allowed"
1104         );
1105         goodwill = _new_goodwill;
1106     }
1107 
1108     function set_feeWhitelist(address zapAddress, bool status)
1109         external
1110         onlyOwner
1111     {
1112         feeWhitelist[zapAddress] = status;
1113     }
1114 
1115     function updateCurveRegistry(ICurveRegistry newCurveRegistry)
1116         external
1117         onlyOwner
1118     {
1119         require(newCurveRegistry != curveReg, "Already using this Registry");
1120         curveReg = newCurveRegistry;
1121     }
1122 
1123     // - to Pause the contract
1124     function toggleContractActive() external onlyOwner {
1125         stopped = !stopped;
1126     }
1127 
1128     function set_new_affiliateSplit(uint16 _new_affiliateSplit)
1129         external
1130         onlyOwner
1131     {
1132         require(
1133             _new_affiliateSplit <= 100,
1134             "Affiliate Split Value not allowed"
1135         );
1136         affiliateSplit = _new_affiliateSplit;
1137     }
1138 
1139     function set_affiliate(address _affiliate, bool _status)
1140         external
1141         onlyOwner
1142     {
1143         affiliates[_affiliate] = _status;
1144     }
1145 
1146     ///@notice Withdraw goodwill share, retaining affilliate share
1147     function ownerWithdraw(address[] calldata tokens) external onlyOwner {
1148         for (uint256 i = 0; i < tokens.length; i++) {
1149             uint256 qty;
1150 
1151             if (tokens[i] == ETHAddress) {
1152                 qty = address(this).balance.sub(
1153                     totalAffiliateBalance[tokens[i]]
1154                 );
1155                 Address.sendValue(Address.toPayable(owner()), qty);
1156             } else {
1157                 qty = IERC20(tokens[i]).balanceOf(address(this)).sub(
1158                     totalAffiliateBalance[tokens[i]]
1159                 );
1160                 IERC20(tokens[i]).safeTransfer(owner(), qty);
1161             }
1162         }
1163     }
1164 
1165     ///@notice Withdraw affilliate share, retaining goodwill share
1166     function affilliateWithdraw(address[] calldata tokens) external {
1167         uint256 tokenBal;
1168         for (uint256 i = 0; i < tokens.length; i++) {
1169             tokenBal = affiliateBalance[msg.sender][tokens[i]];
1170             affiliateBalance[msg.sender][tokens[i]] = 0;
1171             totalAffiliateBalance[tokens[i]] = totalAffiliateBalance[tokens[i]]
1172                 .sub(tokenBal);
1173 
1174             if (tokens[i] == ETHAddress) {
1175                 Address.sendValue(msg.sender, tokenBal);
1176             } else {
1177                 IERC20(tokens[i]).safeTransfer(msg.sender, tokenBal);
1178             }
1179         }
1180     }
1181 
1182     function() external payable {
1183         require(msg.sender != tx.origin, "Do not send ETH directly");
1184     }
1185 }