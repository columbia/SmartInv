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
21 ///@notice This contract adds liquidity to Curve stablecoin and BTC liquidity pools in one transaction with ETH or ERC tokens.
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
668 interface IUniswapV2Factory {
669     function getPair(address tokenA, address tokenB)
670         external
671         view
672         returns (address);
673 }
674 
675 interface IUniswapRouter02 {
676     //get estimated amountOut
677     function getAmountsOut(uint256 amountIn, address[] calldata path)
678         external
679         view
680         returns (uint256[] memory amounts);
681 
682     function getAmountsIn(uint256 amountOut, address[] calldata path)
683         external
684         view
685         returns (uint256[] memory amounts);
686 
687     //token 2 token
688     function swapExactTokensForTokens(
689         uint256 amountIn,
690         uint256 amountOutMin,
691         address[] calldata path,
692         address to,
693         uint256 deadline
694     ) external returns (uint256[] memory amounts);
695 
696     function swapTokensForExactTokens(
697         uint256 amountOut,
698         uint256 amountInMax,
699         address[] calldata path,
700         address to,
701         uint256 deadline
702     ) external returns (uint256[] memory amounts);
703 
704     //eth 2 token
705     function swapExactETHForTokens(
706         uint256 amountOutMin,
707         address[] calldata path,
708         address to,
709         uint256 deadline
710     ) external payable returns (uint256[] memory amounts);
711 
712     function swapETHForExactTokens(
713         uint256 amountOut,
714         address[] calldata path,
715         address to,
716         uint256 deadline
717     ) external payable returns (uint256[] memory amounts);
718 
719     //token 2 eth
720     function swapTokensForExactETH(
721         uint256 amountOut,
722         uint256 amountInMax,
723         address[] calldata path,
724         address to,
725         uint256 deadline
726     ) external returns (uint256[] memory amounts);
727 
728     function swapExactTokensForETH(
729         uint256 amountIn,
730         uint256 amountOutMin,
731         address[] calldata path,
732         address to,
733         uint256 deadline
734     ) external returns (uint256[] memory amounts);
735 }
736 
737 interface ICurveSwap {
738     function coins(int128 arg0) external view returns (address);
739 
740     function underlying_coins(int128 arg0) external view returns (address);
741 
742     function add_liquidity(uint256[4] calldata amounts, uint256 min_mint_amount)
743         external;
744 
745     function add_liquidity(uint256[3] calldata amounts, uint256 min_mint_amount)
746         external;
747 
748     function add_liquidity(uint256[2] calldata amounts, uint256 min_mint_amount)
749         external;
750 }
751 
752 interface yERC20 {
753     function deposit(uint256 _amount) external;
754 }
755 
756 interface IWETH {
757     function deposit() external payable;
758 
759     function transfer(address to, uint256 value) external returns (bool);
760 
761     function withdraw(uint256) external;
762 }
763 
764 interface ICurveRegistry {
765     function metaPools(address tokenAddress)
766         external
767         view
768         returns (address swapAddress);
769 
770     function getTokenAddress(address swapAddress)
771         external
772         view
773         returns (address tokenAddress);
774 
775     function getPoolTokens(address swapAddress)
776         external
777         view
778         returns (address[4] memory poolTokens);
779 
780     function isMetaPool(address swapAddress) external view returns (bool);
781 
782     function getNumTokens(address swapAddress)
783         external
784         view
785         returns (uint8 numTokens);
786 
787     function isBtcPool(address swapAddress) external view returns (bool);
788 
789     function isUnderlyingToken(
790         address swapAddress,
791         address tokenContractAddress
792     ) external view returns (bool, uint8);
793 }
794 
795 contract Curve_ZapIn_General_V1_10 is ReentrancyGuard, Ownable {
796     using SafeMath for uint256;
797     using SafeERC20 for IERC20;
798     bool public stopped = false;
799     uint16 public goodwill = 0;
800     address
801         public zgoodwillAddress = 0x3CE37278de6388532C3949ce4e886F365B14fB56;
802 
803     IUniswapV2Factory
804         private constant UniSwapV2FactoryAddress = IUniswapV2Factory(
805         0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
806     );
807     IUniswapRouter02 private constant uniswapRouter = IUniswapRouter02(
808         0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
809     );
810 
811     ICurveRegistry public curveReg;
812 
813     address
814         private constant wethToken = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
815 
816     address
817         private constant wbtcToken = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
818 
819     address
820         public intermediateStable = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
821 
822     uint256
823         private constant deadline = 0xf000000000000000000000000000000000000000000000000000000000000000;
824 
825     // circuit breaker modifiers
826     modifier stopInEmergency {
827         if (stopped) {
828             revert("Temporarily Paused");
829         } else {
830             _;
831         }
832     }
833 
834     constructor(ICurveRegistry _curveRegistry) public {
835         curveReg = _curveRegistry;
836     }
837 
838     /**
839     @notice This function adds liquidity to a Curve pool with ETH or ERC20 tokens
840     @param toWhomToIssue The address to return the Curve LP tokens to
841     @param fromToken The ERC20 token used for investment (address(0x00) if ether)
842     @param swapAddress Curve swap address for the pool
843     @param incomingTokenQty The amount of fromToken to invest
844     @param minPoolTokens The minimum acceptable quantity of tokens to receive. Reverts otherwise
845     @return Amount of Curve LP tokens received
846      */
847     function ZapIn(
848         address toWhomToIssue,
849         address fromToken,
850         address swapAddress,
851         uint256 incomingTokenQty,
852         uint256 minPoolTokens
853     )
854         external
855         payable
856         stopInEmergency
857         nonReentrant
858         returns (uint256 crvTokensBought)
859     {
860         uint256 toInvest;
861         if (fromToken == address(0)) {
862             require(msg.value > 0, "Error: ETH not sent");
863             toInvest = msg.value;
864         } else {
865             require(msg.value == 0, "Error: ETH sent");
866             require(incomingTokenQty > 0, "Error: Invalid ERC amount");
867             IERC20(fromToken).safeTransferFrom(
868                 msg.sender,
869                 address(this),
870                 incomingTokenQty
871             );
872             toInvest = incomingTokenQty;
873         }
874         (bool isUnderlying, uint8 underlyingIndex) = curveReg.isUnderlyingToken(
875             swapAddress,
876             fromToken
877         );
878         if (isUnderlying) {
879             crvTokensBought = _enterCurve(
880                 swapAddress,
881                 toInvest,
882                 underlyingIndex
883             );
884         } else {
885             (uint256 tokensBought, uint8 index) = _getIntermediate(
886                 swapAddress,
887                 fromToken,
888                 toInvest
889             );
890             crvTokensBought = _enterCurve(swapAddress, tokensBought, index);
891         }
892         require(
893             crvTokensBought > minPoolTokens,
894             "Received less than minPoolTokens"
895         );
896 
897         address poolTokenAddress = curveReg.getTokenAddress(swapAddress);
898         uint256 goodwillPortion;
899         if (goodwill > 0) {
900             goodwillPortion = SafeMath.div(
901                 SafeMath.mul(crvTokensBought, goodwill),
902                 10000
903             );
904             IERC20(poolTokenAddress).safeTransfer(
905                 zgoodwillAddress,
906                 goodwillPortion
907             );
908         }
909         IERC20(poolTokenAddress).transfer(
910             toWhomToIssue,
911             SafeMath.sub(crvTokensBought, goodwillPortion)
912         );
913 
914         return SafeMath.sub(crvTokensBought, goodwillPortion);
915     }
916 
917     /**
918     @notice This function swaps to an appropriate intermediate token to be used to add liquidity
919     @param swapAddress Curve swap address for the pool
920     @param fromToken The ERC20 token used for investment (address(0x00) if ether)
921     @param amount The amount of fromToken to invest
922     @return Amount of tokens (or LP) bought, token index for add_liquidity call
923      */
924     function _getIntermediate(
925         address swapAddress,
926         address fromToken,
927         uint256 amount
928     ) internal returns (uint256 tokensBought, uint8 index) {
929         address[4] memory poolTokens = curveReg.getPoolTokens(swapAddress);
930         if (curveReg.isMetaPool(swapAddress)) {
931             for (uint8 i = 0; i < 4; i++) {
932                 if (curveReg.metaPools(poolTokens[i]) != address(0)) {
933                     address intermediateSwapAddress = curveReg.metaPools(
934                         poolTokens[i]
935                     );
936                     (bool isUnderlying, uint8 underlyingIndex) = curveReg
937                         .isUnderlyingToken(intermediateSwapAddress, fromToken);
938                     if (isUnderlying) {
939                         tokensBought = _enterCurve(
940                             intermediateSwapAddress,
941                             amount,
942                             underlyingIndex
943                         );
944                         return (tokensBought, i);
945                     }
946                     uint256 intermediateTokenBought;
947                     if (curveReg.isBtcPool(intermediateSwapAddress)) {
948                         intermediateTokenBought = _token2Token(
949                             fromToken,
950                             wbtcToken,
951                             amount
952                         );
953                         (, index) = curveReg.isUnderlyingToken(
954                             intermediateSwapAddress,
955                             wbtcToken
956                         );
957                     } else {
958                         intermediateTokenBought = _token2Token(
959                             fromToken,
960                             intermediateStable,
961                             amount
962                         );
963                         (, index) = curveReg.isUnderlyingToken(
964                             intermediateSwapAddress,
965                             intermediateStable
966                         );
967                     }
968                     tokensBought = _enterCurve(
969                         intermediateSwapAddress,
970                         intermediateTokenBought,
971                         index
972                     );
973                     return (tokensBought, i);
974                 }
975             }
976         } else {
977             if (curveReg.isBtcPool(swapAddress)) {
978                 tokensBought = _token2Token(fromToken, wbtcToken, amount);
979                 (, index) = curveReg.isUnderlyingToken(swapAddress, wbtcToken);
980                 return (tokensBought, index);
981             }
982             tokensBought = _token2Token(fromToken, intermediateStable, amount);
983             (, index) = curveReg.isUnderlyingToken(
984                 swapAddress,
985                 intermediateStable
986             );
987         }
988     }
989 
990     /**
991     @notice This function is used to swap ETH/ERC20 <> ETH/ERC20
992     @param fromToken The token address to swap from. (0x00 for ETH)
993     @param toToken The token address to swap to. (0x00 for ETH)
994     @param tokens2Trade The amount of tokens to swap
995     @return tokenBought The quantity of tokens bought
996     */
997     function _token2Token(
998         address fromToken,
999         address toToken,
1000         uint256 tokens2Trade
1001     ) internal returns (uint256 tokenBought) {
1002         if (fromToken == address(0)) {
1003             address[] memory path = new address[](2);
1004             path[0] = wethToken;
1005             path[1] = toToken;
1006             tokenBought = uniswapRouter.swapExactETHForTokens.value(
1007                 tokens2Trade
1008             )(1, path, address(this), deadline)[path.length - 1];
1009         } else {
1010             IERC20(fromToken).safeIncreaseAllowance(
1011                 address(uniswapRouter),
1012                 tokens2Trade
1013             );
1014             if (fromToken != wethToken) {
1015                 // check output via tokenA -> tokenB
1016                 address pairA = UniSwapV2FactoryAddress.getPair(
1017                     fromToken,
1018                     toToken
1019                 );
1020                 address[] memory pathA = new address[](2);
1021                 pathA[0] = fromToken;
1022                 pathA[1] = toToken;
1023                 uint256 amtA;
1024                 if (pairA != address(0)) {
1025                     amtA = uniswapRouter.getAmountsOut(tokens2Trade, pathA)[1];
1026                 }
1027 
1028                 // check output via tokenA -> weth -> tokenB
1029                 address[] memory pathB = new address[](3);
1030                 pathB[0] = fromToken;
1031                 pathB[1] = wethToken;
1032                 pathB[2] = toToken;
1033 
1034                 uint256 amtB = uniswapRouter.getAmountsOut(
1035                     tokens2Trade,
1036                     pathB
1037                 )[2];
1038 
1039                 if (amtA >= amtB) {
1040                     tokenBought = uniswapRouter.swapExactTokensForTokens(
1041                         tokens2Trade,
1042                         1,
1043                         pathA,
1044                         address(this),
1045                         deadline
1046                     )[pathA.length - 1];
1047                 } else {
1048                     tokenBought = uniswapRouter.swapExactTokensForTokens(
1049                         tokens2Trade,
1050                         1,
1051                         pathB,
1052                         address(this),
1053                         deadline
1054                     )[pathB.length - 1];
1055                 }
1056             } else {
1057                 address[] memory path = new address[](2);
1058                 path[0] = wethToken;
1059                 path[1] = toToken;
1060                 tokenBought = uniswapRouter.swapExactTokensForTokens(
1061                     tokens2Trade,
1062                     1,
1063                     path,
1064                     address(this),
1065                     deadline
1066                 )[path.length - 1];
1067             }
1068         }
1069         require(tokenBought > 0, "Error Swapping Tokens");
1070     }
1071 
1072     /**
1073     @notice This function adds liquidity to a curve pool
1074     @param swapAddress Curve swap address for the pool
1075     @param amount The quantity of tokens being added as liquidity
1076     @param index The token index for the add_liquidity call
1077     @return tokenBought The quantity of curve LP tokens received
1078     */
1079     function _enterCurve(
1080         address swapAddress,
1081         uint256 amount,
1082         uint8 index
1083     ) internal returns (uint256 crvTokensBought) {
1084         address tokenAddress = curveReg.getTokenAddress(swapAddress);
1085         uint256 iniTokenBal = IERC20(tokenAddress).balanceOf(address(this));
1086         address entryToken = curveReg.getPoolTokens(swapAddress)[index];
1087         IERC20(entryToken).safeIncreaseAllowance(address(swapAddress), amount);
1088         uint256 numTokens = curveReg.getNumTokens(swapAddress);
1089         if (numTokens == 4) {
1090             uint256[4] memory amounts;
1091             amounts[index] = amount;
1092             ICurveSwap(swapAddress).add_liquidity(amounts, 0);
1093         } else if (numTokens == 3) {
1094             uint256[3] memory amounts;
1095             amounts[index] = amount;
1096             ICurveSwap(swapAddress).add_liquidity(amounts, 0);
1097         } else {
1098             uint256[2] memory amounts;
1099             amounts[index] = amount;
1100             ICurveSwap(swapAddress).add_liquidity(amounts, 0);
1101         }
1102         crvTokensBought = (IERC20(tokenAddress).balanceOf(address(this))).sub(
1103             iniTokenBal
1104         );
1105     }
1106 
1107     function inCaseTokengetsStuck(IERC20 _TokenAddress) external onlyOwner {
1108         uint256 qty = _TokenAddress.balanceOf(address(this));
1109         IERC20(_TokenAddress).safeTransfer(_owner, qty);
1110     }
1111 
1112     function set_new_goodwill(uint16 _new_goodwill) external onlyOwner {
1113         require(
1114             _new_goodwill >= 0 && _new_goodwill < 10000,
1115             "GoodWill Value not allowed"
1116         );
1117         goodwill = _new_goodwill;
1118     }
1119 
1120     function set_new_zgoodwillAddress(address _new_zgoodwillAddress)
1121         external
1122         onlyOwner
1123     {
1124         zgoodwillAddress = _new_zgoodwillAddress;
1125     }
1126 
1127     function updateIntermediateStable(address newIntermediate)
1128         external
1129         onlyOwner
1130     {
1131         require(
1132             newIntermediate != intermediateStable,
1133             "Already using this intermediate"
1134         );
1135         intermediateStable = newIntermediate;
1136     }
1137 
1138     function updateCurveRegistry(ICurveRegistry newCurveRegistry)
1139         external
1140         onlyOwner
1141     {
1142         require(newCurveRegistry != curveReg, "Already using this Registry");
1143         curveReg = newCurveRegistry;
1144     }
1145 
1146     // - to Pause the contract
1147     function toggleContractActive() external onlyOwner {
1148         stopped = !stopped;
1149     }
1150 
1151     // - to withdraw any ETH balance sitting in the contract
1152     function withdraw() external onlyOwner {
1153         _owner.transfer(address(this).balance);
1154     }
1155 
1156     function() external payable {
1157         require(msg.sender != tx.origin, "Do not send ETH directly");
1158     }
1159 }