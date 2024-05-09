1 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
2 
3 pragma solidity ^0.5.5;
4 
5 /**
6  * @dev Collection of functions related to the address type
7  */
8 library Address {
9     /**
10      * @dev Returns true if `account` is a contract.
11      *
12      * [IMPORTANT]
13      * ====
14      * It is unsafe to assume that an address for which this function returns
15      * false is an externally-owned account (EOA) and not a contract.
16      *
17      * Among others, `isContract` will return false for the following 
18      * types of addresses:
19      *
20      *  - an externally-owned account
21      *  - a contract in construction
22      *  - an address where a contract will be created
23      *  - an address where a contract lived, but was destroyed
24      * ====
25      */
26     function isContract(address account) internal view returns (bool) {
27         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
28         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
29         // for accounts without code, i.e. `keccak256('')`
30         bytes32 codehash;
31         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
32         // solhint-disable-next-line no-inline-assembly
33         assembly { codehash := extcodehash(account) }
34         return (codehash != accountHash && codehash != 0x0);
35     }
36 
37     /**
38      * @dev Converts an `address` into `address payable`. Note that this is
39      * simply a type cast: the actual underlying value is not changed.
40      *
41      * _Available since v2.4.0._
42      */
43     function toPayable(address account) internal pure returns (address payable) {
44         return address(uint160(account));
45     }
46 
47     /**
48      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
49      * `recipient`, forwarding all available gas and reverting on errors.
50      *
51      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
52      * of certain opcodes, possibly making contracts go over the 2300 gas limit
53      * imposed by `transfer`, making them unable to receive funds via
54      * `transfer`. {sendValue} removes this limitation.
55      *
56      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
57      *
58      * IMPORTANT: because control is transferred to `recipient`, care must be
59      * taken to not create reentrancy vulnerabilities. Consider using
60      * {ReentrancyGuard} or the
61      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
62      *
63      * _Available since v2.4.0._
64      */
65     function sendValue(address payable recipient, uint256 amount) internal {
66         require(address(this).balance >= amount, "Address: insufficient balance");
67 
68         // solhint-disable-next-line avoid-call-value
69         (bool success, ) = recipient.call.value(amount)("");
70         require(success, "Address: unable to send value, recipient may have reverted");
71     }
72 }
73 
74 // File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
75 
76 pragma solidity ^0.5.0;
77 
78 /**
79  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
80  * the optional functions; to access them see {ERC20Detailed}.
81  */
82 interface IERC20 {
83     /**
84      * @dev Returns the amount of tokens in existence.
85      */
86     function totalSupply() external view returns (uint256);
87 
88     /**
89      * @dev Returns the amount of tokens owned by `account`.
90      */
91     function balanceOf(address account) external view returns (uint256);
92 
93     /**
94      * @dev Moves `amount` tokens from the caller's account to `recipient`.
95      *
96      * Returns a boolean value indicating whether the operation succeeded.
97      *
98      * Emits a {Transfer} event.
99      */
100     function transfer(address recipient, uint256 amount) external returns (bool);
101 
102     /**
103      * @dev Returns the remaining number of tokens that `spender` will be
104      * allowed to spend on behalf of `owner` through {transferFrom}. This is
105      * zero by default.
106      *
107      * This value changes when {approve} or {transferFrom} are called.
108      */
109     function allowance(address owner, address spender) external view returns (uint256);
110 
111     /**
112      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
113      *
114      * Returns a boolean value indicating whether the operation succeeded.
115      *
116      * IMPORTANT: Beware that changing an allowance with this method brings the risk
117      * that someone may use both the old and the new allowance by unfortunate
118      * transaction ordering. One possible solution to mitigate this race
119      * condition is to first reduce the spender's allowance to 0 and set the
120      * desired value afterwards:
121      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
122      *
123      * Emits an {Approval} event.
124      */
125     function approve(address spender, uint256 amount) external returns (bool);
126 
127     /**
128      * @dev Moves `amount` tokens from `sender` to `recipient` using the
129      * allowance mechanism. `amount` is then deducted from the caller's
130      * allowance.
131      *
132      * Returns a boolean value indicating whether the operation succeeded.
133      *
134      * Emits a {Transfer} event.
135      */
136     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
137 
138     /**
139      * @dev Emitted when `value` tokens are moved from one account (`from`) to
140      * another (`to`).
141      *
142      * Note that `value` may be zero.
143      */
144     event Transfer(address indexed from, address indexed to, uint256 value);
145 
146     /**
147      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
148      * a call to {approve}. `value` is the new allowance.
149      */
150     event Approval(address indexed owner, address indexed spender, uint256 value);
151 }
152 
153 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
154 
155 pragma solidity ^0.5.0;
156 
157 /*
158  * @dev Provides information about the current execution context, including the
159  * sender of the transaction and its data. While these are generally available
160  * via msg.sender and msg.data, they should not be accessed in such a direct
161  * manner, since when dealing with GSN meta-transactions the account sending and
162  * paying for execution may not be the actual sender (as far as an application
163  * is concerned).
164  *
165  * This contract is only required for intermediate, library-like contracts.
166  */
167 contract Context {
168     // Empty internal constructor, to prevent people from mistakenly deploying
169     // an instance of this contract, which should be used via inheritance.
170     constructor () internal { }
171     // solhint-disable-previous-line no-empty-blocks
172 
173     function _msgSender() internal view returns (address payable) {
174         return msg.sender;
175     }
176 
177     function _msgData() internal view returns (bytes memory) {
178         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
179         return msg.data;
180     }
181 }
182 
183 // File: node_modules\@openzeppelin\contracts\ownership\Ownable.sol
184 
185 pragma solidity ^0.5.0;
186 
187 /**
188  * @dev Contract module which provides a basic access control mechanism, where
189  * there is an account (an owner) that can be granted exclusive access to
190  * specific functions.
191  *
192  * This module is used through inheritance. It will make available the modifier
193  * `onlyOwner`, which can be applied to your functions to restrict their use to
194  * the owner.
195  */
196 contract Ownable is Context {
197     address private _owner;
198 
199     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
200 
201     /**
202      * @dev Initializes the contract setting the deployer as the initial owner.
203      */
204     constructor () internal {
205         address msgSender = _msgSender();
206         _owner = msgSender;
207         emit OwnershipTransferred(address(0), msgSender);
208     }
209 
210     /**
211      * @dev Returns the address of the current owner.
212      */
213     function owner() public view returns (address) {
214         return _owner;
215     }
216 
217     /**
218      * @dev Throws if called by any account other than the owner.
219      */
220     modifier onlyOwner() {
221         require(isOwner(), "Ownable: caller is not the owner");
222         _;
223     }
224 
225     /**
226      * @dev Returns true if the caller is the current owner.
227      */
228     function isOwner() public view returns (bool) {
229         return _msgSender() == _owner;
230     }
231 
232     /**
233      * @dev Leaves the contract without owner. It will not be possible to call
234      * `onlyOwner` functions anymore. Can only be called by the current owner.
235      *
236      * NOTE: Renouncing ownership will leave the contract without an owner,
237      * thereby removing any functionality that is only available to the owner.
238      */
239     function renounceOwnership() public onlyOwner {
240         emit OwnershipTransferred(_owner, address(0));
241         _owner = address(0);
242     }
243 
244     /**
245      * @dev Transfers ownership of the contract to a new account (`newOwner`).
246      * Can only be called by the current owner.
247      */
248     function transferOwnership(address newOwner) public onlyOwner {
249         _transferOwnership(newOwner);
250     }
251 
252     /**
253      * @dev Transfers ownership of the contract to a new account (`newOwner`).
254      */
255     function _transferOwnership(address newOwner) internal {
256         require(newOwner != address(0), "Ownable: new owner is the zero address");
257         emit OwnershipTransferred(_owner, newOwner);
258         _owner = newOwner;
259     }
260 }
261 
262 // File: node_modules\@openzeppelin\contracts\utils\ReentrancyGuard.sol
263 
264 pragma solidity ^0.5.0;
265 
266 /**
267  * @dev Contract module that helps prevent reentrant calls to a function.
268  *
269  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
270  * available, which can be applied to functions to make sure there are no nested
271  * (reentrant) calls to them.
272  *
273  * Note that because there is a single `nonReentrant` guard, functions marked as
274  * `nonReentrant` may not call one another. This can be worked around by making
275  * those functions `private`, and then adding `external` `nonReentrant` entry
276  * points to them.
277  *
278  * TIP: If you would like to learn more about reentrancy and alternative ways
279  * to protect against it, check out our blog post
280  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
281  *
282  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
283  * metering changes introduced in the Istanbul hardfork.
284  */
285 contract ReentrancyGuard {
286     bool private _notEntered;
287 
288     constructor () internal {
289         // Storing an initial non-zero value makes deployment a bit more
290         // expensive, but in exchange the refund on every call to nonReentrant
291         // will be lower in amount. Since refunds are capped to a percetange of
292         // the total transaction's gas, it is best to keep them low in cases
293         // like this one, to increase the likelihood of the full refund coming
294         // into effect.
295         _notEntered = true;
296     }
297 
298     /**
299      * @dev Prevents a contract from calling itself, directly or indirectly.
300      * Calling a `nonReentrant` function from another `nonReentrant`
301      * function is not supported. It is possible to prevent this from happening
302      * by making the `nonReentrant` function external, and make it call a
303      * `private` function that does the actual work.
304      */
305     modifier nonReentrant() {
306         // On the first call to nonReentrant, _notEntered will be true
307         require(_notEntered, "ReentrancyGuard: reentrant call");
308 
309         // Any calls to nonReentrant after this point will fail
310         _notEntered = false;
311 
312         _;
313 
314         // By storing the original value once again, a refund is triggered (see
315         // https://eips.ethereum.org/EIPS/eip-2200)
316         _notEntered = true;
317     }
318 }
319 
320 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
321 
322 pragma solidity ^0.5.0;
323 
324 /**
325  * @dev Wrappers over Solidity's arithmetic operations with added overflow
326  * checks.
327  *
328  * Arithmetic operations in Solidity wrap on overflow. This can easily result
329  * in bugs, because programmers usually assume that an overflow raises an
330  * error, which is the standard behavior in high level programming languages.
331  * `SafeMath` restores this intuition by reverting the transaction when an
332  * operation overflows.
333  *
334  * Using this library instead of the unchecked operations eliminates an entire
335  * class of bugs, so it's recommended to use it always.
336  */
337 library SafeMath {
338     /**
339      * @dev Returns the addition of two unsigned integers, reverting on
340      * overflow.
341      *
342      * Counterpart to Solidity's `+` operator.
343      *
344      * Requirements:
345      * - Addition cannot overflow.
346      */
347     function add(uint256 a, uint256 b) internal pure returns (uint256) {
348         uint256 c = a + b;
349         require(c >= a, "SafeMath: addition overflow");
350 
351         return c;
352     }
353 
354     /**
355      * @dev Returns the subtraction of two unsigned integers, reverting on
356      * overflow (when the result is negative).
357      *
358      * Counterpart to Solidity's `-` operator.
359      *
360      * Requirements:
361      * - Subtraction cannot overflow.
362      */
363     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
364         return sub(a, b, "SafeMath: subtraction overflow");
365     }
366 
367     /**
368      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
369      * overflow (when the result is negative).
370      *
371      * Counterpart to Solidity's `-` operator.
372      *
373      * Requirements:
374      * - Subtraction cannot overflow.
375      *
376      * _Available since v2.4.0._
377      */
378     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
379         require(b <= a, errorMessage);
380         uint256 c = a - b;
381 
382         return c;
383     }
384 
385     /**
386      * @dev Returns the multiplication of two unsigned integers, reverting on
387      * overflow.
388      *
389      * Counterpart to Solidity's `*` operator.
390      *
391      * Requirements:
392      * - Multiplication cannot overflow.
393      */
394     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
395         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
396         // benefit is lost if 'b' is also tested.
397         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
398         if (a == 0) {
399             return 0;
400         }
401 
402         uint256 c = a * b;
403         require(c / a == b, "SafeMath: multiplication overflow");
404 
405         return c;
406     }
407 
408     /**
409      * @dev Returns the integer division of two unsigned integers. Reverts on
410      * division by zero. The result is rounded towards zero.
411      *
412      * Counterpart to Solidity's `/` operator. Note: this function uses a
413      * `revert` opcode (which leaves remaining gas untouched) while Solidity
414      * uses an invalid opcode to revert (consuming all remaining gas).
415      *
416      * Requirements:
417      * - The divisor cannot be zero.
418      */
419     function div(uint256 a, uint256 b) internal pure returns (uint256) {
420         return div(a, b, "SafeMath: division by zero");
421     }
422 
423     /**
424      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
425      * division by zero. The result is rounded towards zero.
426      *
427      * Counterpart to Solidity's `/` operator. Note: this function uses a
428      * `revert` opcode (which leaves remaining gas untouched) while Solidity
429      * uses an invalid opcode to revert (consuming all remaining gas).
430      *
431      * Requirements:
432      * - The divisor cannot be zero.
433      *
434      * _Available since v2.4.0._
435      */
436     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
437         // Solidity only automatically asserts when dividing by 0
438         require(b > 0, errorMessage);
439         uint256 c = a / b;
440         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
441 
442         return c;
443     }
444 
445     /**
446      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
447      * Reverts when dividing by zero.
448      *
449      * Counterpart to Solidity's `%` operator. This function uses a `revert`
450      * opcode (which leaves remaining gas untouched) while Solidity uses an
451      * invalid opcode to revert (consuming all remaining gas).
452      *
453      * Requirements:
454      * - The divisor cannot be zero.
455      */
456     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
457         return mod(a, b, "SafeMath: modulo by zero");
458     }
459 
460     /**
461      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
462      * Reverts with custom message when dividing by zero.
463      *
464      * Counterpart to Solidity's `%` operator. This function uses a `revert`
465      * opcode (which leaves remaining gas untouched) while Solidity uses an
466      * invalid opcode to revert (consuming all remaining gas).
467      *
468      * Requirements:
469      * - The divisor cannot be zero.
470      *
471      * _Available since v2.4.0._
472      */
473     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
474         require(b != 0, errorMessage);
475         return a % b;
476     }
477 }
478 
479 // File: contracts\Curve\Curve_General_Zapout_V1_2.sol
480 
481 // ███████╗░█████╗░██████╗░██████╗░███████╗██████╗░░░░███████╗██╗
482 // ╚════██║██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗░░░██╔════╝██║
483 // ░░███╔═╝███████║██████╔╝██████╔╝█████╗░░██████╔╝░░░█████╗░░██║
484 // ██╔══╝░░██╔══██║██╔═══╝░██╔═══╝░██╔══╝░░██╔══██╗░░░██╔══╝░░██║
485 // ███████╗██║░░██║██║░░░░░██║░░░░░███████╗██║░░██║██╗██║░░░░░██║
486 // ╚══════╝╚═╝░░╚═╝╚═╝░░░░░╚═╝░░░░░╚══════╝╚═╝░░╚═╝╚═╝╚═╝░░░░░╚═╝
487 // Copyright (C) 2020 zapper, nodarjanashia, suhailg, apoorvlathey, seb, sumit
488 
489 // This program is free software: you can redistribute it and/or modify
490 // it under the terms of the GNU Affero General Public License as published by
491 // the Free Software Foundation, either version 2 of the License, or
492 // (at your option) any later version.
493 //
494 // This program is distributed in the hope that it will be useful,
495 // but WITHOUT ANY WARRANTY; without even the implied warranty of
496 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
497 // GNU Affero General Public License for more details.
498 //
499 // Visit <https://www.gnu.org/licenses/>for a copy of the GNU Affero General Public License
500 
501 ///@author Zapper
502 ///@notice this contract implements one click ZapOut from Curve Pools
503 
504 pragma solidity 0.5.12;
505 
506 
507 
508 
509 
510 
511 /**
512  * @title SafeERC20
513  * @dev Wrappers around ERC20 operations that throw on failure (when the token
514  * contract returns false). Tokens that return no value (and instead revert or
515  * throw on failure) are also supported, non-reverting calls are assumed to be
516  * successful.
517  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
518  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
519  */
520 library SafeERC20 {
521     using SafeMath for uint256;
522     using Address for address;
523 
524     function safeTransfer(
525         IERC20 token,
526         address to,
527         uint256 value
528     ) internal {
529         callOptionalReturn(
530             token,
531             abi.encodeWithSelector(token.transfer.selector, to, value)
532         );
533     }
534 
535     function safeTransferFrom(
536         IERC20 token,
537         address from,
538         address to,
539         uint256 value
540     ) internal {
541         callOptionalReturn(
542             token,
543             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
544         );
545     }
546 
547     function safeApprove(
548         IERC20 token,
549         address spender,
550         uint256 value
551     ) internal {
552         // safeApprove should only be called when setting an initial allowance,
553         // or when resetting it to zero. To increase and decrease it, use
554         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
555         // solhint-disable-next-line max-line-length
556         require(
557             (value == 0) || (token.allowance(address(this), spender) == 0),
558             "SafeERC20: approve from non-zero to non-zero allowance"
559         );
560         callOptionalReturn(
561             token,
562             abi.encodeWithSelector(token.approve.selector, spender, value)
563         );
564     }
565 
566     function safeIncreaseAllowance(
567         IERC20 token,
568         address spender,
569         uint256 value
570     ) internal {
571         uint256 newAllowance = token.allowance(address(this), spender).add(
572             value
573         );
574         callOptionalReturn(
575             token,
576             abi.encodeWithSelector(
577                 token.approve.selector,
578                 spender,
579                 newAllowance
580             )
581         );
582     }
583 
584     function safeDecreaseAllowance(
585         IERC20 token,
586         address spender,
587         uint256 value
588     ) internal {
589         uint256 newAllowance = token.allowance(address(this), spender).sub(
590             value,
591             "SafeERC20: decreased allowance below zero"
592         );
593         callOptionalReturn(
594             token,
595             abi.encodeWithSelector(
596                 token.approve.selector,
597                 spender,
598                 newAllowance
599             )
600         );
601     }
602 
603     /**
604      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
605      * on the return value: the return value is optional (but if data is returned, it must not be false).
606      * @param token The token targeted by the call.
607      * @param data The call data (encoded using abi.encode or one of its variants).
608      */
609     function callOptionalReturn(IERC20 token, bytes memory data) private {
610         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
611         // we're implementing it ourselves.
612 
613         // A Solidity high level call has three parts:
614         //  1. The target address is checked to verify it contains contract code
615         //  2. The call itself is made, and success asserted
616         //  3. The return value is decoded, which in turn checks the size of the returned data.
617         // solhint-disable-next-line max-line-length
618         require(address(token).isContract(), "SafeERC20: call to non-contract");
619 
620         // solhint-disable-next-line avoid-low-level-calls
621         (bool success, bytes memory returndata) = address(token).call(data);
622         require(success, "SafeERC20: low-level call failed");
623 
624         if (returndata.length > 0) {
625             // Return data is optional
626             // solhint-disable-next-line max-line-length
627             require(
628                 abi.decode(returndata, (bool)),
629                 "SafeERC20: ERC20 operation did not succeed"
630             );
631         }
632     }
633 }
634 
635 // interface
636 interface ICurveExchange {
637     // function coins() external view returns (address[] memory);
638     function coins(int128 arg0) external view returns (address);
639 
640     function underlying_coins(int128 arg0) external view returns (address);
641 
642     function balances(int128 arg0) external view returns (uint256);
643 
644     function remove_liquidity(uint256 _amount, uint256[4] calldata min_amounts)
645         external;
646 
647     function remove_liquidity_one_coin(
648         uint256 _token_amount,
649         int128 i,
650         uint256 min_amount,
651         bool donate_dust
652     ) external;
653 
654     function exchange(
655         int128 from,
656         int128 to,
657         uint256 _from_amount,
658         uint256 _min_to_amount
659     ) external;
660 
661     function exchange_underlying(
662         int128 from,
663         int128 to,
664         uint256 _from_amount,
665         uint256 _min_to_amount
666     ) external;
667 
668     function calc_withdraw_one_coin(uint256 _token_amount, int128 i)
669         external
670         returns (uint256);
671 }
672 
673 interface ICurveExchangeBTC {
674     function remove_liquidity_one_coin(
675         uint256 _token_amount,
676         int128 i,
677         uint256 min_amount
678     ) external;
679 }
680 
681 interface ICurveExchangeSBTC {
682     function remove_liquidity(uint256 _amount, uint256[3] calldata min_amounts)
683         external;
684 }
685 
686 interface ICurveExchangeRenBTC {
687     function remove_liquidity(uint256 _amount, uint256[2] calldata min_amounts)
688         external;
689 }
690 
691 interface IuniswapFactory {
692     function getExchange(address token)
693         external
694         view
695         returns (address exchange);
696 }
697 
698 interface IuniswapExchange {
699     // converting ERC20 to ERC20 and transfer
700     function tokenToTokenTransferInput(
701         uint256 tokens_sold,
702         uint256 min_tokens_bought,
703         uint256 min_eth_bought,
704         uint256 deadline,
705         address recipient,
706         address token_addr
707     ) external returns (uint256 tokens_bought);
708 
709     function getEthToTokenInputPrice(uint256 eth_sold)
710         external
711         view
712         returns (uint256 tokens_bought);
713 
714     function getEthToTokenOutputPrice(uint256 tokens_bought)
715         external
716         view
717         returns (uint256 eth_sold);
718 
719     function getTokenToEthInputPrice(uint256 tokens_sold)
720         external
721         view
722         returns (uint256 eth_bought);
723 
724     function getTokenToEthOutputPrice(uint256 eth_bought)
725         external
726         view
727         returns (uint256 tokens_sold);
728 
729     function tokenToEthTransferInput(
730         uint256 tokens_sold,
731         uint256 min_eth,
732         uint256 deadline,
733         address recipient
734     ) external returns (uint256 eth_bought);
735 
736     function balanceOf(address _owner) external view returns (uint256);
737 
738     function transfer(address _to, uint256 _value) external returns (bool);
739 
740     function transferFrom(
741         address from,
742         address to,
743         uint256 tokens
744     ) external returns (bool success);
745 }
746 
747 interface IWETH {
748     function deposit() external payable;
749 
750     function withdraw(uint256) external;
751 }
752 
753 interface cERC20 {
754     function redeem(uint256) external returns (uint256);
755 }
756 
757 interface yERC20 {
758     function withdraw(uint256 _amount) external;
759 }
760 
761 interface IUniswapRouter02 {
762     //get estimated amountOut
763     function getAmountsOut(uint256 amountIn, address[] calldata path)
764         external
765         view
766         returns (uint256[] memory amounts);
767 
768     function getAmountsIn(uint256 amountOut, address[] calldata path)
769         external
770         view
771         returns (uint256[] memory amounts);
772 
773     //token 2 token
774     function swapExactTokensForTokens(
775         uint256 amountIn,
776         uint256 amountOutMin,
777         address[] calldata path,
778         address to,
779         uint256 deadline
780     ) external returns (uint256[] memory amounts);
781 
782     function swapTokensForExactTokens(
783         uint256 amountOut,
784         uint256 amountInMax,
785         address[] calldata path,
786         address to,
787         uint256 deadline
788     ) external returns (uint256[] memory amounts);
789 
790     //eth 2 token
791     function swapExactETHForTokens(
792         uint256 amountOutMin,
793         address[] calldata path,
794         address to,
795         uint256 deadline
796     ) external payable returns (uint256[] memory amounts);
797 
798     function swapETHForExactTokens(
799         uint256 amountOut,
800         address[] calldata path,
801         address to,
802         uint256 deadline
803     ) external payable returns (uint256[] memory amounts);
804 
805     //token 2 eth
806     function swapTokensForExactETH(
807         uint256 amountOut,
808         uint256 amountInMax,
809         address[] calldata path,
810         address to,
811         uint256 deadline
812     ) external returns (uint256[] memory amounts);
813 
814     function swapExactTokensForETH(
815         uint256 amountIn,
816         uint256 amountOutMin,
817         address[] calldata path,
818         address to,
819         uint256 deadline
820     ) external returns (uint256[] memory amounts);
821 }
822 
823 interface IBalancer {
824     function swapExactAmountIn(
825         address tokenIn,
826         uint tokenAmountIn,
827         address tokenOut,
828         uint minAmountOut,
829         uint maxPrice
830     ) external returns (uint tokenAmountOut, uint spotPriceAfter);
831 }
832 
833 contract Curve_General_ZapOut_V2 is ReentrancyGuard, Ownable {
834     using SafeMath for uint256;
835     using SafeERC20 for IERC20;
836     using Address for address;
837     bool private stopped = false;
838     uint16 public goodwill;
839     address public dzgoodwillAddress;
840     
841     IBalancer private constant BalWBTCPool = IBalancer(0x294de1cdE8b04bf6d25F98f1d547052F8080A177);
842 
843     IuniswapFactory private constant UniSwapFactoryAddress = IuniswapFactory(
844         0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95
845     );
846     IUniswapRouter02 private constant uniswapRouter = IUniswapRouter02(
847         0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
848     );
849 
850     address private constant wethTokenAddress = address(
851         0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
852     );
853     address private constant WBTCTokenAddress = address(
854         0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599
855     );
856     address private constant DaiTokenAddress = address(
857         0x6B175474E89094C44Da98b954EedeAC495271d0F
858     );
859     address private constant UsdcTokenAddress = address(
860         0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
861     );
862     address private constant UsdtTokenAddress = address(
863         0xdAC17F958D2ee523a2206206994597C13D831ec7
864     );
865     address public sUsdTokenAddress = address(
866         0x57Ab1ec28D129707052df4dF418D58a2D46d5f51
867     );
868 
869     address private constant bUsdTokenAddress = address(
870         0x4Fabb145d64652a948d72533023f6E7A623C7C53
871     );
872 
873     address private constant sUSDCurveExchangeAddress = address(
874         0xFCBa3E75865d2d561BE8D220616520c171F12851
875     );
876     address private constant sUSDCurvePoolTokenAddress = address(
877         0xC25a3A3b969415c80451098fa907EC722572917F
878     );
879     address private constant yCurveExchangeAddress = address(
880         0xbBC81d23Ea2c3ec7e56D39296F0cbB648873a5d3
881     );
882     address private constant yCurvePoolTokenAddress = address(
883         0xdF5e0e81Dff6FAF3A7e52BA697820c5e32D806A8
884     );
885     address private constant bUSDCurveExchangeAddress = address(
886         0xb6c057591E073249F2D9D88Ba59a46CFC9B59EdB
887     );
888     address private constant bUSDCurvePoolTokenAddress = address(
889         0x3B3Ac5386837Dc563660FB6a0937DFAa5924333B
890     );
891     address private constant paxCurveExchangeAddress = address(
892         0xA50cCc70b6a011CffDdf45057E39679379187287
893     );
894     address private constant paxCurvePoolTokenAddress = address(
895         0xD905e2eaeBe188fc92179b6350807D8bd91Db0D8
896     );
897     address private constant renCurvePoolTokenAddress = address(
898         0x49849C98ae39Fff122806C06791Fa73784FB3675
899     );
900     address private constant sbtcCurvePoolTokenAddress = address(
901         0x075b1bb99792c9E1041bA13afEf80C91a1e70fB3
902     );
903 
904     address private constant renCurveExchangeAddress = address(
905         0x93054188d876f558f4a66B2EF1d97d16eDf0895B
906     );
907 
908     address private constant sbtcCurveExchangeAddress = address(
909         0x7fC77b5c7614E1533320Ea6DDc2Eb61fa00A9714
910     );
911 
912     address private constant yDAI = address(0xC2cB1040220768554cf699b0d863A3cd4324ce32);
913     address private constant yUSDC = address(0xd6aD7a6750A7593E092a9B218d66C0A814a3436e);
914     address private constant yUSDT = address(0x83f798e925BcD4017Eb265844FDDAbb448f1707D);
915     address private constant yBUSD = address(0x04bC0Ab673d88aE9dbC9DA2380cB6B79C4BCa9aE);
916     address private constant yTUSD = address(0x73a052500105205d34Daf004eAb301916DA8190f);
917 
918     address private constant ycDAI = address(0x99d1Fa417f94dcD62BfE781a1213c092a47041Bc);
919     address private constant ycUSDC = address(0x9777d7E2b60bB01759D0E2f8be2095df444cb07E);
920     address private constant ycUSDT = address(0x1bE5d71F2dA660BFdee8012dDc58D024448A0A59);
921 
922     mapping(address => address) public exchange2Token;
923     mapping(address => address) public cToken;
924     mapping(address => address) public yToken;
925 
926     constructor(
927         uint16 _goodwill,
928         address _dzgoodwillAddress
929     ) public {
930         goodwill = _goodwill;
931         dzgoodwillAddress = _dzgoodwillAddress;
932         approveToken();
933         setCRVTokenAddresses();
934         setcTokens();
935         setyTokens();
936     }
937 
938     function approveToken() public {
939         IERC20(sUSDCurvePoolTokenAddress).approve(
940             sUSDCurveExchangeAddress,
941             uint256(-1)
942         );
943         IERC20(yCurvePoolTokenAddress).approve(
944             yCurveExchangeAddress,
945             uint256(-1)
946         );
947         IERC20(bUSDCurvePoolTokenAddress).approve(
948             bUSDCurveExchangeAddress,
949             uint256(-1)
950         );
951         IERC20(paxCurvePoolTokenAddress).approve(
952             paxCurveExchangeAddress,
953             uint256(-1)
954         );
955         IERC20(renCurvePoolTokenAddress).approve(
956             renCurveExchangeAddress,
957             uint256(-1)
958         );
959         IERC20(sbtcCurvePoolTokenAddress).approve(
960             sbtcCurveExchangeAddress,
961             uint256(-1)
962         );
963     }
964 
965     function setcTokens() public onlyOwner {
966         cToken[address(
967             0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643
968         )] = DaiTokenAddress;
969         cToken[address(
970             0x39AA39c021dfbaE8faC545936693aC917d5E7563
971         )] = UsdcTokenAddress;
972         cToken[address(
973             0xf650C3d88D12dB855b8bf7D11Be6C55A4e07dCC9
974         )] = UsdtTokenAddress;
975         cToken[address(
976             0xC11b1268C1A384e55C48c2391d8d480264A3A7F4
977         )] = WBTCTokenAddress;
978     }
979 
980     function setyTokens() public onlyOwner {
981         //y tokens
982         yToken[yDAI] = DaiTokenAddress;
983         yToken[yUSDC] = UsdcTokenAddress;
984         yToken[yUSDT] = UsdtTokenAddress;
985         yToken[yBUSD] = bUsdTokenAddress;
986 
987         //yc tokens
988         yToken[ycDAI] = DaiTokenAddress;
989         yToken[ycUSDC] = UsdcTokenAddress;
990         yToken[ycUSDT] = UsdtTokenAddress;
991     }
992 
993     function setCRVTokenAddresses() public onlyOwner {
994         exchange2Token[sUSDCurveExchangeAddress] = sUSDCurvePoolTokenAddress;
995         exchange2Token[yCurveExchangeAddress] = yCurvePoolTokenAddress;
996         exchange2Token[bUSDCurveExchangeAddress] = bUSDCurvePoolTokenAddress;
997         exchange2Token[paxCurveExchangeAddress] = paxCurvePoolTokenAddress;
998         exchange2Token[renCurveExchangeAddress] = renCurvePoolTokenAddress;
999         exchange2Token[sbtcCurveExchangeAddress] = sbtcCurvePoolTokenAddress;
1000     }
1001 
1002     function addCRVToken(address _exchangeAddress, address _crvTokenAddress)
1003         public
1004         onlyOwner
1005     {
1006         exchange2Token[_exchangeAddress] = _crvTokenAddress;
1007     }
1008 
1009     function addCToken(address _cToken, address _underlyingToken)
1010         public
1011         onlyOwner
1012     {
1013         cToken[_cToken] = _underlyingToken;
1014     }
1015 
1016     function addYToken(address _yToken, address _underlyingToken)
1017         public
1018         onlyOwner
1019     {
1020         yToken[_yToken] = _underlyingToken;
1021     }
1022 
1023     function set_new_sUSDTokenAddress(address _new_sUSDTokenAddress)
1024         public
1025         onlyOwner
1026     {
1027         sUsdTokenAddress = _new_sUSDTokenAddress;
1028     }
1029 
1030     // circuit breaker modifiers
1031     modifier stopInEmergency {
1032         if (stopped) {
1033             revert("Temporarily Paused");
1034         } else {
1035             _;
1036         }
1037     }
1038 
1039     function ZapoutToUnderlying(
1040         address _toWhomToIssue,
1041         address _curveExchangeAddress,
1042         uint256 _IncomingCRV,
1043         uint256 _tokenCount
1044     ) public stopInEmergency {
1045         require(
1046             _curveExchangeAddress == sUSDCurveExchangeAddress ||
1047                 _curveExchangeAddress == yCurveExchangeAddress ||
1048                 _curveExchangeAddress == bUSDCurveExchangeAddress ||
1049                 _curveExchangeAddress == paxCurveExchangeAddress ||
1050                 _curveExchangeAddress == renCurveExchangeAddress ||
1051                 _curveExchangeAddress == sbtcCurveExchangeAddress,
1052             "Invalid Curve Pool Address"
1053         );
1054 
1055         uint256 goodwillPortion = SafeMath.div(
1056             SafeMath.mul(_IncomingCRV, goodwill),
1057             10000
1058         );
1059 
1060         require(
1061             IERC20(exchange2Token[_curveExchangeAddress]).transferFrom(
1062                 msg.sender,
1063                 dzgoodwillAddress,
1064                 goodwillPortion
1065             ),
1066             "Error transferring goodwill"
1067         );
1068 
1069         require(
1070             IERC20(exchange2Token[_curveExchangeAddress]).transferFrom(
1071                 msg.sender,
1072                 address(this),
1073                 SafeMath.sub(_IncomingCRV, goodwillPortion)
1074             ),
1075             "Error transferring CRV"
1076         );
1077         require(SafeMath.sub(_IncomingCRV, goodwillPortion) > 0, "Here");
1078         address[] memory coins;
1079         if (
1080             (_curveExchangeAddress == renCurveExchangeAddress ||
1081                 _curveExchangeAddress == sbtcCurveExchangeAddress)
1082         ) {
1083             coins = getCoins(_curveExchangeAddress, _tokenCount);
1084         } else {
1085             coins = getUnderlyingCoins(_curveExchangeAddress, _tokenCount);
1086         }
1087 
1088         if (_tokenCount == 4) {
1089             ICurveExchange(_curveExchangeAddress).remove_liquidity(
1090                 SafeMath.sub(_IncomingCRV, goodwillPortion),
1091                 [uint256(0), 0, 0, 0]
1092             );
1093         } else if (_tokenCount == 3) {
1094             ICurveExchangeSBTC(_curveExchangeAddress).remove_liquidity(
1095                 SafeMath.sub(_IncomingCRV, goodwillPortion),
1096                 [uint256(0), 0, 0]
1097             );
1098         } else if (_tokenCount == 2) {
1099             ICurveExchangeRenBTC(_curveExchangeAddress).remove_liquidity(
1100                 SafeMath.sub(_IncomingCRV, goodwillPortion),
1101                 [uint256(0), 0]
1102             );
1103         }
1104 
1105         for (uint256 index = 0; index < _tokenCount; index++) {
1106             uint256 tokenReceived = IERC20(coins[index]).balanceOf(
1107                 address(this)
1108             );
1109             if (tokenReceived > 0)
1110                 SafeERC20.safeTransfer(
1111                     IERC20(coins[index]),
1112                     _toWhomToIssue,
1113                     tokenReceived
1114                 );
1115         }
1116     }
1117 
1118     function ZapOut(
1119         address payable _toWhomToIssue,
1120         address _curveExchangeAddress,
1121         uint256 _tokenCount,
1122         uint256 _IncomingCRV,
1123         address _ToTokenAddress,
1124         uint256 _minToTokens
1125     ) public stopInEmergency returns (uint256 ToTokensBought) {
1126         require(
1127             _curveExchangeAddress == sUSDCurveExchangeAddress ||
1128                 _curveExchangeAddress == yCurveExchangeAddress ||
1129                 _curveExchangeAddress == bUSDCurveExchangeAddress ||
1130                 _curveExchangeAddress == paxCurveExchangeAddress ||
1131                 _curveExchangeAddress == renCurveExchangeAddress ||
1132                 _curveExchangeAddress == sbtcCurveExchangeAddress,
1133             "Invalid Curve Pool Address"
1134         );
1135 
1136         uint256 goodwillPortion = SafeMath.div(
1137             SafeMath.mul(_IncomingCRV, goodwill),
1138             10000
1139         );
1140 
1141         require(
1142             IERC20(exchange2Token[_curveExchangeAddress]).transferFrom(
1143                 msg.sender,
1144                 dzgoodwillAddress,
1145                 goodwillPortion
1146             ),
1147             "Error transferring goodwill"
1148         );
1149 
1150         require(
1151             IERC20(exchange2Token[_curveExchangeAddress]).transferFrom(
1152                 msg.sender,
1153                 address(this),
1154                 SafeMath.sub(_IncomingCRV, goodwillPortion)
1155             ),
1156             "Error transferring CRV"
1157         );
1158 
1159         (bool flag, uint256 i) = _getIntermediateToken(
1160             _ToTokenAddress,
1161             _curveExchangeAddress,
1162             _tokenCount
1163         );
1164 
1165         if (
1166             flag &&
1167             (_curveExchangeAddress == renCurveExchangeAddress ||
1168                 _curveExchangeAddress == sbtcCurveExchangeAddress)
1169         ) {
1170             uint256 tokenBought = _exitCurve(
1171                 _curveExchangeAddress,
1172                 i,
1173                 SafeMath.sub(_IncomingCRV, goodwillPortion)
1174             );
1175             require(tokenBought > 0, "No liquidity removed");
1176             ToTokensBought = _swap(
1177                 _ToTokenAddress,
1178                 WBTCTokenAddress,
1179                 _toWhomToIssue,
1180                 tokenBought
1181             );
1182         } else if (flag) {
1183             uint256 tokenBought = _exitCurve(
1184                 _curveExchangeAddress,
1185                 i,
1186                 SafeMath.sub(_IncomingCRV, goodwillPortion)
1187             );
1188             require(tokenBought > 0, "No liquidity removed");
1189             // if wbtc, coin else underlying coin
1190             ToTokensBought = _swap(
1191                 _ToTokenAddress,
1192                 ICurveExchange(_curveExchangeAddress).underlying_coins(
1193                     int128(i)
1194                 ),
1195                 _toWhomToIssue,
1196                 tokenBought
1197             );
1198         } else {
1199             //split CRV tokens received
1200             uint256 _crv = (_IncomingCRV.sub(goodwillPortion)).div(2);
1201             uint256 tokenBought = _exitCurve(
1202                 _curveExchangeAddress,
1203                 0,
1204                 _crv
1205             );
1206             require(tokenBought > 0, "No liquidity removed");
1207             //swap dai
1208             ToTokensBought = _swap(
1209                 _ToTokenAddress,
1210                 ICurveExchange(_curveExchangeAddress).underlying_coins(
1211                     int128(0)
1212                 ),
1213                 _toWhomToIssue,
1214                 tokenBought
1215             );
1216             tokenBought = _exitCurve(
1217                 _curveExchangeAddress,
1218                 1,
1219                 (_IncomingCRV.sub(goodwillPortion)).sub(_crv)
1220             );
1221             require(tokenBought > 0, "No liquidity removed");
1222             //swap usdc
1223             ToTokensBought += _swap(
1224                 _ToTokenAddress,
1225                 ICurveExchange(_curveExchangeAddress).underlying_coins(
1226                     int128(1)
1227                 ),
1228                 _toWhomToIssue,
1229                 tokenBought
1230             );
1231         }
1232 
1233         require(ToTokensBought >= _minToTokens, "ERR: High Slippage");
1234     }
1235 
1236     function _exitCurve(
1237         address _curveExchangeAddress,
1238         uint256 i,
1239         uint256 _IncomingCRV
1240     ) internal returns (uint256 tokenReceived) {
1241         // Withdraw to intermediate token from Curve
1242         if (
1243             _curveExchangeAddress == renCurveExchangeAddress ||
1244             _curveExchangeAddress == sbtcCurveExchangeAddress
1245         ) {
1246             ICurveExchangeBTC(_curveExchangeAddress).remove_liquidity_one_coin(
1247                 _IncomingCRV,
1248                 int128(i),
1249                 0
1250             );
1251             tokenReceived = IERC20(
1252                 ICurveExchange(_curveExchangeAddress).coins(int128(i))
1253             )
1254                 .balanceOf(address(this));
1255         } else {
1256             ICurveExchange(_curveExchangeAddress).remove_liquidity_one_coin(
1257                 _IncomingCRV,
1258                 int128(i),
1259                 0,
1260                 false
1261             );
1262             tokenReceived = IERC20(
1263                 ICurveExchange(_curveExchangeAddress).underlying_coins(
1264                     int128(i)
1265                 )
1266             )
1267                 .balanceOf(address(this));
1268         }
1269         require(tokenReceived > 0, "No token received");
1270     }
1271 
1272     function _swap(
1273         address _toToken,
1274         address _fromToken,
1275         address payable _toWhomToIssue,
1276         uint256 _amount
1277     ) internal returns (uint256) {
1278         if (_toToken == _fromToken) {
1279             SafeERC20.safeTransfer(IERC20(_fromToken), _toWhomToIssue, _amount);
1280             return _amount;
1281         } else if (_toToken == address(0)) {
1282             return
1283                 _token2Eth(_fromToken, _amount, _toWhomToIssue);
1284         } else {
1285             return
1286                 _token2Token(
1287                     _fromToken,
1288                     _toWhomToIssue,
1289                     _toToken,
1290                     _amount
1291                 );
1292         }
1293     }
1294 
1295     function _getIntermediateToken(
1296         address _ToTokenAddress,
1297         address _curveExchangeAddress,
1298         uint256 _tokenCount
1299     ) public view returns (bool, uint256) {
1300         address[] memory coins = getCoins(_curveExchangeAddress, _tokenCount);
1301         address[] memory underlyingCoins = getUnderlyingCoins(
1302             _curveExchangeAddress,
1303             _tokenCount
1304         );
1305 
1306         //check if toToken is coin
1307         (bool isCurveToken, uint256 index) = isBound(_ToTokenAddress, coins);
1308         if (isCurveToken) return (true, index);
1309 
1310         ////check if toToken is underlying coin
1311         (isCurveToken, index) = isBound(_ToTokenAddress, underlyingCoins);
1312         if (isCurveToken) return (true, index);
1313 
1314         if (
1315             _curveExchangeAddress == renCurveExchangeAddress ||
1316             _curveExchangeAddress == sbtcCurveExchangeAddress
1317         ) {
1318             //return wbtc for renBTC & sBTC pools
1319             return (true, 1);
1320         } else return (false, 0);
1321     }
1322 
1323     function isBound(address _token, address[] memory coins)
1324         internal
1325         pure
1326         returns (bool, uint256)
1327     {
1328         if (_token == address(0)) return (false, 0);
1329         for (uint256 i = 0; i < coins.length; i++) {
1330             if (_token == coins[i]) {
1331                 return (true, i);
1332             }
1333         }
1334         return (false, 0);
1335     }
1336 
1337     function getUnderlyingCoins(
1338         address _curveExchangeAddress,
1339         uint256 _tokenCount
1340     ) public view returns (address[] memory) {
1341         if (
1342             _curveExchangeAddress == renCurveExchangeAddress ||
1343             _curveExchangeAddress == sbtcCurveExchangeAddress
1344         ) {
1345             return new address[](_tokenCount);
1346         }
1347         address[] memory coins = new address[](_tokenCount);
1348         for (uint256 i = 0; i < _tokenCount; i++) {
1349             address coin = ICurveExchange(_curveExchangeAddress)
1350                 .underlying_coins(int128(i));
1351             coins[i] = coin;
1352         }
1353         return coins;
1354     }
1355 
1356     function getCoins(address _curveExchangeAddress, uint256 _tokenCount)
1357         public
1358         view
1359         returns (address[] memory)
1360     {
1361         address[] memory coins = new address[](_tokenCount);
1362         for (uint256 i = 0; i < _tokenCount; i++) {
1363             address coin = ICurveExchange(_curveExchangeAddress).coins(
1364                 int128(i)
1365             );
1366             coins[i] = coin;
1367         }
1368         return coins;
1369     }
1370 
1371     function _token2Eth(
1372         address _FromTokenContractAddress,
1373         uint256 tokens2Trade,
1374         address payable _toWhomToIssue
1375     ) public returns (uint256) {
1376         if (_FromTokenContractAddress == wethTokenAddress) {
1377             IWETH(wethTokenAddress).withdraw(tokens2Trade);
1378             _toWhomToIssue.transfer(tokens2Trade);
1379             return tokens2Trade;
1380         }
1381         if(_FromTokenContractAddress == WBTCTokenAddress) {
1382             IERC20(WBTCTokenAddress).approve(
1383                 address(BalWBTCPool),
1384                 tokens2Trade
1385             );
1386             (uint256 wethBought, ) = BalWBTCPool.swapExactAmountIn(
1387                                         WBTCTokenAddress,
1388                                         tokens2Trade,
1389                                         wethTokenAddress,
1390                                         0,
1391                                         uint(-1)
1392                                     );
1393             IWETH(wethTokenAddress).withdraw(wethBought);
1394             (bool success, ) = _toWhomToIssue.call.value(wethBought)("");
1395             require(success, "ETH Transfer failed.");
1396             
1397             return wethBought;
1398         }
1399 
1400         //unwrap
1401         (uint256 tokensUnwrapped, address fromToken) = _unwrap(
1402             _FromTokenContractAddress,
1403             tokens2Trade
1404         );
1405 
1406         IERC20(fromToken).approve(
1407             address(uniswapRouter),
1408             tokensUnwrapped
1409         );
1410 
1411         address[] memory path = new address[](2);
1412         path[0] = _FromTokenContractAddress;
1413         path[1] = wethTokenAddress;
1414         uint256 ethBought = uniswapRouter.swapExactTokensForETH(
1415                             tokensUnwrapped,
1416                             1,
1417                             path,
1418                             _toWhomToIssue,
1419                             now + 60
1420                         )[path.length - 1];
1421         
1422         require(ethBought > 0, "Error in swapping Eth: 1");
1423         return ethBought;
1424     }
1425 
1426     /**
1427     @notice This function is used to swap tokens
1428     @param _FromTokenContractAddress The token address to swap from
1429     @param _ToWhomToIssue The address to transfer after swap
1430     @param _ToTokenContractAddress The token address to swap to
1431     @param tokens2Trade The quantity of tokens to swap
1432     @return The amount of tokens returned after swap
1433      */
1434     function _token2Token(
1435         address _FromTokenContractAddress,
1436         address _ToWhomToIssue,
1437         address _ToTokenContractAddress,
1438         uint256 tokens2Trade
1439     ) public returns (uint256 tokenBought) {
1440         //unwrap
1441         (uint256 tokensUnwrapped, address fromToken) = _unwrap(
1442             _FromTokenContractAddress,
1443             tokens2Trade
1444         );
1445 
1446         IERC20(fromToken).approve(
1447             address(uniswapRouter),
1448             tokensUnwrapped
1449         );
1450 
1451         address[] memory path = new address[](3);
1452         path[0] = _FromTokenContractAddress;
1453         path[1] = wethTokenAddress;
1454         path[2] = _ToTokenContractAddress;
1455         tokenBought = uniswapRouter.swapExactTokensForTokens(
1456                             tokensUnwrapped,
1457                             1,
1458                             path,
1459                             _ToWhomToIssue,
1460                             now + 60
1461                         )[path.length - 1];
1462         
1463         require(tokenBought > 0, "Error in swapping ERC: 1");
1464     }
1465 
1466     function _unwrap(address _FromTokenContractAddress, uint256 tokens2Trade)
1467         internal
1468         returns (uint256 tokensUnwrapped, address toToken)
1469     {
1470         if (cToken[_FromTokenContractAddress] != address(0)) {
1471             require(
1472                 cERC20(_FromTokenContractAddress).redeem(tokens2Trade) == 0,
1473                 "Error in unwrapping"
1474             );
1475             toToken = cToken[_FromTokenContractAddress];
1476         } else if (yToken[_FromTokenContractAddress] != address(0)) {
1477             yERC20(_FromTokenContractAddress).withdraw(tokens2Trade);
1478             toToken = yToken[_FromTokenContractAddress];
1479         } else {
1480             toToken = _FromTokenContractAddress;
1481         }
1482         tokensUnwrapped = IERC20(toToken).balanceOf(address(this));
1483     }
1484 
1485     function set_new_goodwill(uint16 _new_goodwill) public onlyOwner {
1486         require(
1487             _new_goodwill >= 0 && _new_goodwill < 10000,
1488             "GoodWill Value not allowed"
1489         );
1490         goodwill = _new_goodwill;
1491     }
1492 
1493     function set_new_dzgoodwillAddress(address _new_dzgoodwillAddress)
1494         public
1495         onlyOwner
1496     {
1497         dzgoodwillAddress = _new_dzgoodwillAddress;
1498     }
1499 
1500     function inCaseTokengetsStuck(IERC20 _TokenAddress) public onlyOwner {
1501         uint256 qty = _TokenAddress.balanceOf(address(this));
1502         _TokenAddress.transfer(owner(), qty);
1503     }
1504 
1505     // - to Pause the contract
1506     function toggleContractActive() public onlyOwner {
1507         stopped = !stopped;
1508     }
1509 
1510     // - to withdraw any ETH balance sitting in the contract
1511     function withdraw() public onlyOwner {
1512         uint256 contractBalance = address(this).balance;
1513         address payable _to = owner().toPayable();
1514         _to.transfer(contractBalance);
1515     }
1516 
1517     function() external payable {}
1518 }