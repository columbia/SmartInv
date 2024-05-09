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
19 
20 ///@author Zapper
21 ///@notice This contract removes liquidity from Curve pools
22 // SPDX-License-Identifier: GPL-2.0
23 
24 // File contracts/oz/GSN/Context.sol
25 
26 pragma solidity ^0.5.0;
27 
28 /*
29  * @dev Provides information about the current execution context, including the
30  * sender of the transaction and its data. While these are generally available
31  * via msg.sender and msg.data, they should not be accessed in such a direct
32  * manner, since when dealing with GSN meta-transactions the account sending and
33  * paying for execution may not be the actual sender (as far as an application
34  * is concerned).
35  *
36  * This contract is only required for intermediate, library-like contracts.
37  */
38 contract Context {
39     // Empty internal constructor, to prevent people from mistakenly deploying
40     // an instance of this contract, which should be used via inheritance.
41     constructor() internal {}
42 
43     // solhint-disable-previous-line no-empty-blocks
44 
45     function _msgSender() internal view returns (address payable) {
46         return msg.sender;
47     }
48 
49     function _msgData() internal view returns (bytes memory) {
50         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
51         return msg.data;
52     }
53 }
54 
55 // File contracts/oz/ownership/Ownable.sol
56 
57 pragma solidity ^0.5.0;
58 
59 /**
60  * @dev Contract module which provides a basic access control mechanism, where
61  * there is an account (an owner) that can be granted exclusive access to
62  * specific functions.
63  *
64  * This module is used through inheritance. It will make available the modifier
65  * `onlyOwner`, which can be applied to your functions to restrict their use to
66  * the owner.
67  */
68 contract Ownable is Context {
69     address private _owner;
70 
71     event OwnershipTransferred(
72         address indexed previousOwner,
73         address indexed newOwner
74     );
75 
76     /**
77      * @dev Initializes the contract setting the deployer as the initial owner.
78      */
79     constructor() internal {
80         address msgSender = _msgSender();
81         _owner = msgSender;
82         emit OwnershipTransferred(address(0), msgSender);
83     }
84 
85     /**
86      * @dev Returns the address of the current owner.
87      */
88     function owner() public view returns (address) {
89         return _owner;
90     }
91 
92     /**
93      * @dev Throws if called by any account other than the owner.
94      */
95     modifier onlyOwner() {
96         require(isOwner(), "Ownable: caller is not the owner");
97         _;
98     }
99 
100     /**
101      * @dev Returns true if the caller is the current owner.
102      */
103     function isOwner() public view returns (bool) {
104         return _msgSender() == _owner;
105     }
106 
107     /**
108      * @dev Leaves the contract without owner. It will not be possible to call
109      * `onlyOwner` functions anymore. Can only be called by the current owner.
110      *
111      * NOTE: Renouncing ownership will leave the contract without an owner,
112      * thereby removing any functionality that is only available to the owner.
113      */
114     function renounceOwnership() public onlyOwner {
115         emit OwnershipTransferred(_owner, address(0));
116         _owner = address(0);
117     }
118 
119     /**
120      * @dev Transfers ownership of the contract to a new account (`newOwner`).
121      * Can only be called by the current owner.
122      */
123     function transferOwnership(address newOwner) public onlyOwner {
124         _transferOwnership(newOwner);
125     }
126 
127     /**
128      * @dev Transfers ownership of the contract to a new account (`newOwner`).
129      */
130     function _transferOwnership(address newOwner) internal {
131         require(
132             newOwner != address(0),
133             "Ownable: new owner is the zero address"
134         );
135         emit OwnershipTransferred(_owner, newOwner);
136         _owner = newOwner;
137     }
138 }
139 
140 // File contracts/oz/token/ERC20/IERC20.sol
141 
142 pragma solidity ^0.5.0;
143 
144 /**
145  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
146  * the optional functions; to access them see {ERC20Detailed}.
147  */
148 interface IERC20 {
149     function decimals() external view returns (uint8);
150 
151     /**
152      * @dev Returns the amount of tokens in existence.
153      */
154     function totalSupply() external view returns (uint256);
155 
156     /**
157      * @dev Returns the amount of tokens owned by `account`.
158      */
159     function balanceOf(address account) external view returns (uint256);
160 
161     /**
162      * @dev Moves `amount` tokens from the caller's account to `recipient`.
163      *
164      * Returns a boolean value indicating whether the operation succeeded.
165      *
166      * Emits a {Transfer} event.
167      */
168     function transfer(address recipient, uint256 amount)
169         external
170         returns (bool);
171 
172     /**
173      * @dev Returns the remaining number of tokens that `spender` will be
174      * allowed to spend on behalf of `owner` through {transferFrom}. This is
175      * zero by default.
176      *
177      * This value changes when {approve} or {transferFrom} are called.
178      */
179     function allowance(address owner, address spender)
180         external
181         view
182         returns (uint256);
183 
184     /**
185      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
186      *
187      * Returns a boolean value indicating whether the operation succeeded.
188      *
189      * IMPORTANT: Beware that changing an allowance with this method brings the risk
190      * that someone may use both the old and the new allowance by unfortunate
191      * transaction ordering. One possible solution to mitigate this race
192      * condition is to first reduce the spender's allowance to 0 and set the
193      * desired value afterwards:
194      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195      *
196      * Emits an {Approval} event.
197      */
198     function approve(address spender, uint256 amount) external returns (bool);
199 
200     /**
201      * @dev Moves `amount` tokens from `sender` to `recipient` using the
202      * allowance mechanism. `amount` is then deducted from the caller's
203      * allowance.
204      *
205      * Returns a boolean value indicating whether the operation succeeded.
206      *
207      * Emits a {Transfer} event.
208      */
209     function transferFrom(
210         address sender,
211         address recipient,
212         uint256 amount
213     ) external returns (bool);
214 
215     /**
216      * @dev Emitted when `value` tokens are moved from one account (`from`) to
217      * another (`to`).
218      *
219      * Note that `value` may be zero.
220      */
221     event Transfer(address indexed from, address indexed to, uint256 value);
222 
223     /**
224      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
225      * a call to {approve}. `value` is the new allowance.
226      */
227     event Approval(
228         address indexed owner,
229         address indexed spender,
230         uint256 value
231     );
232 }
233 
234 // File contracts/oz/math/SafeMath.sol
235 
236 pragma solidity ^0.5.0;
237 
238 /**
239  * @dev Wrappers over Solidity's arithmetic operations with added overflow
240  * checks.
241  *
242  * Arithmetic operations in Solidity wrap on overflow. This can easily result
243  * in bugs, because programmers usually assume that an overflow raises an
244  * error, which is the standard behavior in high level programming languages.
245  * `SafeMath` restores this intuition by reverting the transaction when an
246  * operation overflows.
247  *
248  * Using this library instead of the unchecked operations eliminates an entire
249  * class of bugs, so it's recommended to use it always.
250  */
251 library SafeMath {
252     /**
253      * @dev Returns the addition of two unsigned integers, reverting on
254      * overflow.
255      *
256      * Counterpart to Solidity's `+` operator.
257      *
258      * Requirements:
259      * - Addition cannot overflow.
260      */
261     function add(uint256 a, uint256 b) internal pure returns (uint256) {
262         uint256 c = a + b;
263         require(c >= a, "SafeMath: addition overflow");
264 
265         return c;
266     }
267 
268     /**
269      * @dev Returns the subtraction of two unsigned integers, reverting on
270      * overflow (when the result is negative).
271      *
272      * Counterpart to Solidity's `-` operator.
273      *
274      * Requirements:
275      * - Subtraction cannot overflow.
276      */
277     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
278         return sub(a, b, "SafeMath: subtraction overflow");
279     }
280 
281     /**
282      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
283      * overflow (when the result is negative).
284      *
285      * Counterpart to Solidity's `-` operator.
286      *
287      * Requirements:
288      * - Subtraction cannot overflow.
289      *
290      * _Available since v2.4.0._
291      */
292     function sub(
293         uint256 a,
294         uint256 b,
295         string memory errorMessage
296     ) internal pure returns (uint256) {
297         require(b <= a, errorMessage);
298         uint256 c = a - b;
299 
300         return c;
301     }
302 
303     /**
304      * @dev Returns the multiplication of two unsigned integers, reverting on
305      * overflow.
306      *
307      * Counterpart to Solidity's `*` operator.
308      *
309      * Requirements:
310      * - Multiplication cannot overflow.
311      */
312     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
313         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
314         // benefit is lost if 'b' is also tested.
315         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
316         if (a == 0) {
317             return 0;
318         }
319 
320         uint256 c = a * b;
321         require(c / a == b, "SafeMath: multiplication overflow");
322 
323         return c;
324     }
325 
326     /**
327      * @dev Returns the integer division of two unsigned integers. Reverts on
328      * division by zero. The result is rounded towards zero.
329      *
330      * Counterpart to Solidity's `/` operator. Note: this function uses a
331      * `revert` opcode (which leaves remaining gas untouched) while Solidity
332      * uses an invalid opcode to revert (consuming all remaining gas).
333      *
334      * Requirements:
335      * - The divisor cannot be zero.
336      */
337     function div(uint256 a, uint256 b) internal pure returns (uint256) {
338         return div(a, b, "SafeMath: division by zero");
339     }
340 
341     /**
342      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
343      * division by zero. The result is rounded towards zero.
344      *
345      * Counterpart to Solidity's `/` operator. Note: this function uses a
346      * `revert` opcode (which leaves remaining gas untouched) while Solidity
347      * uses an invalid opcode to revert (consuming all remaining gas).
348      *
349      * Requirements:
350      * - The divisor cannot be zero.
351      *
352      * _Available since v2.4.0._
353      */
354     function div(
355         uint256 a,
356         uint256 b,
357         string memory errorMessage
358     ) internal pure returns (uint256) {
359         // Solidity only automatically asserts when dividing by 0
360         require(b > 0, errorMessage);
361         uint256 c = a / b;
362         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
363 
364         return c;
365     }
366 
367     /**
368      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
369      * Reverts when dividing by zero.
370      *
371      * Counterpart to Solidity's `%` operator. This function uses a `revert`
372      * opcode (which leaves remaining gas untouched) while Solidity uses an
373      * invalid opcode to revert (consuming all remaining gas).
374      *
375      * Requirements:
376      * - The divisor cannot be zero.
377      */
378     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
379         return mod(a, b, "SafeMath: modulo by zero");
380     }
381 
382     /**
383      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
384      * Reverts with custom message when dividing by zero.
385      *
386      * Counterpart to Solidity's `%` operator. This function uses a `revert`
387      * opcode (which leaves remaining gas untouched) while Solidity uses an
388      * invalid opcode to revert (consuming all remaining gas).
389      *
390      * Requirements:
391      * - The divisor cannot be zero.
392      *
393      * _Available since v2.4.0._
394      */
395     function mod(
396         uint256 a,
397         uint256 b,
398         string memory errorMessage
399     ) internal pure returns (uint256) {
400         require(b != 0, errorMessage);
401         return a % b;
402     }
403 }
404 
405 // File contracts/oz/utils/Address.sol
406 
407 pragma solidity ^0.5.5;
408 
409 /**
410  * @dev Collection of functions related to the address type
411  */
412 library Address {
413     /**
414      * @dev Returns true if `account` is a contract.
415      *
416      * [IMPORTANT]
417      * ====
418      * It is unsafe to assume that an address for which this function returns
419      * false is an externally-owned account (EOA) and not a contract.
420      *
421      * Among others, `isContract` will return false for the following
422      * types of addresses:
423      *
424      *  - an externally-owned account
425      *  - a contract in construction
426      *  - an address where a contract will be created
427      *  - an address where a contract lived, but was destroyed
428      * ====
429      */
430     function isContract(address account) internal view returns (bool) {
431         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
432         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
433         // for accounts without code, i.e. `keccak256('')`
434         bytes32 codehash;
435 
436         bytes32 accountHash =
437             0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
438         // solhint-disable-next-line no-inline-assembly
439         assembly {
440             codehash := extcodehash(account)
441         }
442         return (codehash != accountHash && codehash != 0x0);
443     }
444 
445     /**
446      * @dev Converts an `address` into `address payable`. Note that this is
447      * simply a type cast: the actual underlying value is not changed.
448      *
449      * _Available since v2.4.0._
450      */
451     function toPayable(address account)
452         internal
453         pure
454         returns (address payable)
455     {
456         return address(uint160(account));
457     }
458 
459     /**
460      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
461      * `recipient`, forwarding all available gas and reverting on errors.
462      *
463      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
464      * of certain opcodes, possibly making contracts go over the 2300 gas limit
465      * imposed by `transfer`, making them unable to receive funds via
466      * `transfer`. {sendValue} removes this limitation.
467      *
468      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
469      *
470      * IMPORTANT: because control is transferred to `recipient`, care must be
471      * taken to not create reentrancy vulnerabilities. Consider using
472      * {ReentrancyGuard} or the
473      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
474      *
475      * _Available since v2.4.0._
476      */
477     function sendValue(address payable recipient, uint256 amount) internal {
478         require(
479             address(this).balance >= amount,
480             "Address: insufficient balance"
481         );
482 
483         // solhint-disable-next-line avoid-call-value
484         (bool success, ) = recipient.call.value(amount)("");
485         require(
486             success,
487             "Address: unable to send value, recipient may have reverted"
488         );
489     }
490 }
491 
492 // File contracts/oz/token/ERC20/SafeERC20.sol
493 
494 pragma solidity ^0.5.0;
495 
496 /**
497  * @title SafeERC20
498  * @dev Wrappers around ERC20 operations that throw on failure (when the token
499  * contract returns false). Tokens that return no value (and instead revert or
500  * throw on failure) are also supported, non-reverting calls are assumed to be
501  * successful.
502  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
503  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
504  */
505 library SafeERC20 {
506     using SafeMath for uint256;
507     using Address for address;
508 
509     function safeTransfer(
510         IERC20 token,
511         address to,
512         uint256 value
513     ) internal {
514         callOptionalReturn(
515             token,
516             abi.encodeWithSelector(token.transfer.selector, to, value)
517         );
518     }
519 
520     function safeTransferFrom(
521         IERC20 token,
522         address from,
523         address to,
524         uint256 value
525     ) internal {
526         callOptionalReturn(
527             token,
528             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
529         );
530     }
531 
532     function safeApprove(
533         IERC20 token,
534         address spender,
535         uint256 value
536     ) internal {
537         // safeApprove should only be called when setting an initial allowance,
538         // or when resetting it to zero. To increase and decrease it, use
539         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
540         // solhint-disable-next-line max-line-length
541         require(
542             (value == 0) || (token.allowance(address(this), spender) == 0),
543             "SafeERC20: approve from non-zero to non-zero allowance"
544         );
545         callOptionalReturn(
546             token,
547             abi.encodeWithSelector(token.approve.selector, spender, value)
548         );
549     }
550 
551     function safeIncreaseAllowance(
552         IERC20 token,
553         address spender,
554         uint256 value
555     ) internal {
556         uint256 newAllowance =
557             token.allowance(address(this), spender).add(value);
558         callOptionalReturn(
559             token,
560             abi.encodeWithSelector(
561                 token.approve.selector,
562                 spender,
563                 newAllowance
564             )
565         );
566     }
567 
568     function safeDecreaseAllowance(
569         IERC20 token,
570         address spender,
571         uint256 value
572     ) internal {
573         uint256 newAllowance =
574             token.allowance(address(this), spender).sub(
575                 value,
576                 "SafeERC20: decreased allowance below zero"
577             );
578         callOptionalReturn(
579             token,
580             abi.encodeWithSelector(
581                 token.approve.selector,
582                 spender,
583                 newAllowance
584             )
585         );
586     }
587 
588     /**
589      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
590      * on the return value: the return value is optional (but if data is returned, it must not be false).
591      * @param token The token targeted by the call.
592      * @param data The call data (encoded using abi.encode or one of its variants).
593      */
594     function callOptionalReturn(IERC20 token, bytes memory data) private {
595         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
596         // we're implementing it ourselves.
597 
598         // A Solidity high level call has three parts:
599         //  1. The target address is checked to verify it contains contract code
600         //  2. The call itself is made, and success asserted
601         //  3. The return value is decoded, which in turn checks the size of the returned data.
602         // solhint-disable-next-line max-line-length
603         require(address(token).isContract(), "SafeERC20: call to non-contract");
604 
605         // solhint-disable-next-line avoid-low-level-calls
606         (bool success, bytes memory returndata) = address(token).call(data);
607         require(success, "SafeERC20: low-level call failed");
608 
609         if (returndata.length > 0) {
610             // Return data is optional
611             // solhint-disable-next-line max-line-length
612             require(
613                 abi.decode(returndata, (bool)),
614                 "SafeERC20: ERC20 operation did not succeed"
615             );
616         }
617     }
618 }
619 
620 // File contracts/_base/ZapBaseV1.sol
621 
622 pragma solidity ^0.5.7;
623 
624 contract ZapBaseV1 is Ownable {
625     using SafeMath for uint256;
626     using SafeERC20 for IERC20;
627     bool public stopped = false;
628 
629     // if true, goodwill is not deducted
630     mapping(address => bool) public feeWhitelist;
631 
632     uint256 public goodwill;
633     // % share of goodwill (0-100 %)
634     uint256 affiliateSplit;
635     // restrict affiliates
636     mapping(address => bool) public affiliates;
637     // affiliate => token => amount
638     mapping(address => mapping(address => uint256)) public affiliateBalance;
639     // token => amount
640     mapping(address => uint256) public totalAffiliateBalance;
641 
642     address internal constant ETHAddress =
643         0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
644 
645     constructor(uint256 _goodwill, uint256 _affiliateSplit) public {
646         goodwill = _goodwill;
647         affiliateSplit = _affiliateSplit;
648     }
649 
650     // circuit breaker modifiers
651     modifier stopInEmergency {
652         if (stopped) {
653             revert("Temporarily Paused");
654         } else {
655             _;
656         }
657     }
658 
659     function _getBalance(address token)
660         internal
661         view
662         returns (uint256 balance)
663     {
664         if (token == address(0)) {
665             balance = address(this).balance;
666         } else {
667             balance = IERC20(token).balanceOf(address(this));
668         }
669     }
670 
671     function _approveToken(address token, address spender) internal {
672         IERC20 _token = IERC20(token);
673         if (_token.allowance(address(this), spender) > 0) return;
674         else {
675             _token.safeApprove(spender, uint256(-1));
676         }
677     }
678 
679     function _approveToken(
680         address token,
681         address spender,
682         uint256 amount
683     ) internal {
684         IERC20 _token = IERC20(token);
685         _token.safeApprove(spender, 0);
686         _token.safeApprove(spender, amount);
687     }
688 
689     // - to Pause the contract
690     function toggleContractActive() public onlyOwner {
691         stopped = !stopped;
692     }
693 
694     function set_feeWhitelist(address zapAddress, bool status)
695         external
696         onlyOwner
697     {
698         feeWhitelist[zapAddress] = status;
699     }
700 
701     function set_new_goodwill(uint256 _new_goodwill) public onlyOwner {
702         require(
703             _new_goodwill >= 0 && _new_goodwill <= 100,
704             "GoodWill Value not allowed"
705         );
706         goodwill = _new_goodwill;
707     }
708 
709     function set_new_affiliateSplit(uint256 _new_affiliateSplit)
710         external
711         onlyOwner
712     {
713         require(
714             _new_affiliateSplit <= 100,
715             "Affiliate Split Value not allowed"
716         );
717         affiliateSplit = _new_affiliateSplit;
718     }
719 
720     function set_affiliate(address _affiliate, bool _status)
721         external
722         onlyOwner
723     {
724         affiliates[_affiliate] = _status;
725     }
726 
727     ///@notice Withdraw goodwill share, retaining affilliate share
728     function withdrawTokens(address[] calldata tokens) external onlyOwner {
729         for (uint256 i = 0; i < tokens.length; i++) {
730             uint256 qty;
731 
732             if (tokens[i] == ETHAddress) {
733                 qty = address(this).balance.sub(
734                     totalAffiliateBalance[tokens[i]]
735                 );
736                 Address.sendValue(Address.toPayable(owner()), qty);
737             } else {
738                 qty = IERC20(tokens[i]).balanceOf(address(this)).sub(
739                     totalAffiliateBalance[tokens[i]]
740                 );
741                 IERC20(tokens[i]).safeTransfer(owner(), qty);
742             }
743         }
744     }
745 
746     ///@notice Withdraw affilliate share, retaining goodwill share
747     function affilliateWithdraw(address[] calldata tokens) external {
748         uint256 tokenBal;
749         for (uint256 i = 0; i < tokens.length; i++) {
750             tokenBal = affiliateBalance[msg.sender][tokens[i]];
751             affiliateBalance[msg.sender][tokens[i]] = 0;
752             totalAffiliateBalance[tokens[i]] = totalAffiliateBalance[tokens[i]]
753                 .sub(tokenBal);
754 
755             if (tokens[i] == ETHAddress) {
756                 Address.sendValue(msg.sender, tokenBal);
757             } else {
758                 IERC20(tokens[i]).safeTransfer(msg.sender, tokenBal);
759             }
760         }
761     }
762 
763     function() external payable {
764         require(msg.sender != tx.origin, "Do not send ETH directly");
765     }
766 }
767 
768 // File contracts/_base/ZapOutBaseV2.sol
769 
770 pragma solidity ^0.5.7;
771 
772 contract ZapOutBaseV2_1 is ZapBaseV1 {
773     /**
774     @dev Transfer tokens from msg.sender to this contract
775     @param token The ERC20 token to transfer to this contract
776     @param shouldSellEntireBalance If True transfers entrire allowable amount from another contract
777     @return Quantity of tokens transferred to this contract
778      */
779     function _pullTokens(
780         address token,
781         uint256 amount,
782         bool shouldSellEntireBalance
783     ) internal returns (uint256) {
784         if (shouldSellEntireBalance) {
785             require(
786                 Address.isContract(msg.sender),
787                 "ERR: shouldSellEntireBalance is true for EOA"
788             );
789 
790             IERC20 _token = IERC20(token);
791             uint256 allowance = _token.allowance(msg.sender, address(this));
792             _token.safeTransferFrom(msg.sender, address(this), allowance);
793 
794             return allowance;
795         } else {
796             IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
797 
798             return amount;
799         }
800     }
801 
802     function _subtractGoodwill(
803         address token,
804         uint256 amount,
805         address affiliate,
806         bool enableGoodwill
807     ) internal returns (uint256 totalGoodwillPortion) {
808         bool whitelisted = feeWhitelist[msg.sender];
809         if (enableGoodwill && !whitelisted && goodwill > 0) {
810             totalGoodwillPortion = SafeMath.div(
811                 SafeMath.mul(amount, goodwill),
812                 10000
813             );
814 
815             if (affiliates[affiliate]) {
816                 if (token == address(0)) {
817                     token = ETHAddress;
818                 }
819 
820                 uint256 affiliatePortion =
821                     totalGoodwillPortion.mul(affiliateSplit).div(100);
822                 affiliateBalance[affiliate][token] = affiliateBalance[
823                     affiliate
824                 ][token]
825                     .add(affiliatePortion);
826                 totalAffiliateBalance[token] = totalAffiliateBalance[token].add(
827                     affiliatePortion
828                 );
829             }
830         }
831     }
832 }
833 
834 // File contracts/Curve/Curve_Registry_V2.sol
835 
836 // ███████╗░█████╗░██████╗░██████╗░███████╗██████╗░░░░███████╗██╗
837 // ╚════██║██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗░░░██╔════╝██║
838 // ░░███╔═╝███████║██████╔╝██████╔╝█████╗░░██████╔╝░░░█████╗░░██║
839 // ██╔══╝░░██╔══██║██╔═══╝░██╔═══╝░██╔══╝░░██╔══██╗░░░██╔══╝░░██║
840 // ███████╗██║░░██║██║░░░░░██║░░░░░███████╗██║░░██║██╗██║░░░░░██║
841 // ╚══════╝╚═╝░░╚═╝╚═╝░░░░░╚═╝░░░░░╚══════╝╚═╝░░╚═╝╚═╝╚═╝░░░░░╚═╝
842 // Copyright (C) 2020 zapper
843 
844 // This program is free software: you can redistribute it and/or modify
845 // it under the terms of the GNU Affero General Public License as published by
846 // the Free Software Foundation, either version 2 of the License, or
847 // (at your option) any later version.
848 //
849 // This program is distributed in the hope that it will be useful,
850 // but WITHOUT ANY WARRANTY; without even the implied warranty of
851 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
852 // GNU Affero General Public License for more details.
853 //
854 
855 ///@author Zapper
856 ///@notice Registry for Curve Pools with Utility functions.
857 
858 pragma solidity ^0.5.7;
859 
860 interface ICurveAddressProvider {
861     function get_registry() external view returns (address);
862 
863     function get_address(uint256 _id) external view returns (address);
864 }
865 
866 interface ICurveRegistry {
867     function get_pool_from_lp_token(address lpToken)
868         external
869         view
870         returns (address);
871 
872     function get_lp_token(address swapAddress) external view returns (address);
873 
874     function get_n_coins(address _pool)
875         external
876         view
877         returns (uint256[2] memory);
878 
879     function get_coins(address _pool) external view returns (address[8] memory);
880 
881     function get_underlying_coins(address _pool)
882         external
883         view
884         returns (address[8] memory);
885 }
886 
887 interface ICurveFactoryRegistry {
888     function get_n_coins(address _pool)
889         external
890         view
891         returns (uint256, uint256);
892 
893     function get_coins(address _pool) external view returns (address[2] memory);
894 
895     function get_underlying_coins(address _pool)
896         external
897         view
898         returns (address[8] memory);
899 }
900 
901 contract Curve_Registry_V2 is Ownable {
902     using SafeMath for uint256;
903     using SafeERC20 for IERC20;
904 
905     ICurveAddressProvider private constant CurveAddressProvider =
906         ICurveAddressProvider(0x0000000022D53366457F9d5E68Ec105046FC4383);
907     ICurveRegistry public CurveRegistry;
908 
909     ICurveFactoryRegistry public FactoryRegistry;
910 
911     address private constant wbtcToken =
912         0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
913     address private constant sbtcCrvToken =
914         0x075b1bb99792c9E1041bA13afEf80C91a1e70fB3;
915     address internal constant ETHAddress =
916         0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
917 
918     mapping(address => bool) public shouldAddUnderlying;
919     mapping(address => address) private depositAddresses;
920 
921     constructor() public {
922         CurveRegistry = ICurveRegistry(CurveAddressProvider.get_registry());
923         FactoryRegistry = ICurveFactoryRegistry(
924             CurveAddressProvider.get_address(3)
925         );
926     }
927 
928     function isCurvePool(address swapAddress) public view returns (bool) {
929         if (CurveRegistry.get_lp_token(swapAddress) != address(0)) {
930             return true;
931         }
932         return false;
933     }
934 
935     function isFactoryPool(address swapAddress) public view returns (bool) {
936         if (FactoryRegistry.get_coins(swapAddress)[0] != address(0)) {
937             return true;
938         }
939         return false;
940     }
941 
942     /**
943     @notice This function is used to get the curve pool deposit address
944     @notice The deposit address is used for pools with wrapped (c, y) tokens
945     @param swapAddress Curve swap address for the pool
946     @return curve pool deposit address or the swap address not mapped
947     */
948     function getDepositAddress(address swapAddress)
949         external
950         view
951         returns (address depositAddress)
952     {
953         depositAddress = depositAddresses[swapAddress];
954         if (depositAddress == address(0)) return swapAddress;
955     }
956 
957     /**
958     @notice This function is used to get the curve pool swap address
959     @notice The token and swap address is the same for metapool factory pools
960     @param swapAddress Curve swap address for the pool
961     @return curve pool swap address or address(0) if pool doesnt exist
962     */
963     function getSwapAddress(address tokenAddress)
964         external
965         view
966         returns (address swapAddress)
967     {
968         swapAddress = CurveRegistry.get_pool_from_lp_token(tokenAddress);
969         if (swapAddress != address(0)) {
970             return swapAddress;
971         }
972         if (isFactoryPool(swapAddress)) {
973             return tokenAddress;
974         }
975         return address(0);
976     }
977 
978     /**
979     @notice This function is used to check the curve pool token address
980     @notice The token and swap address is the same for metapool factory pools
981     @param swapAddress Curve swap address for the pool
982     @return curve pool token address or address(0) if pool doesnt exist
983     */
984     function getTokenAddress(address swapAddress)
985         external
986         view
987         returns (address tokenAddress)
988     {
989         tokenAddress = CurveRegistry.get_lp_token(swapAddress);
990         if (tokenAddress != address(0)) {
991             return tokenAddress;
992         }
993         if (isFactoryPool(swapAddress)) {
994             return swapAddress;
995         }
996         return address(0);
997     }
998 
999     /**
1000     @notice Checks the number of non-underlying tokens in a pool
1001     @param swapAddress Curve swap address for the pool
1002     @return number of underlying tokens in the pool
1003     */
1004     function getNumTokens(address swapAddress) public view returns (uint256) {
1005         if (isCurvePool(swapAddress)) {
1006             return CurveRegistry.get_n_coins(swapAddress)[0];
1007         } else {
1008             (uint256 numTokens, ) = FactoryRegistry.get_n_coins(swapAddress);
1009             return numTokens;
1010         }
1011     }
1012 
1013     /**
1014     @notice This function is used to check if the curve pool is a metapool
1015     @notice all factory pools are metapools
1016     @param swapAddress Curve swap address for the pool
1017     @return true if the pool is a metapool, false otherwise
1018     */
1019     function isMetaPool(address swapAddress) public view returns (bool) {
1020         if (isCurvePool(swapAddress)) {
1021             uint256[2] memory poolTokenCounts =
1022                 CurveRegistry.get_n_coins(swapAddress);
1023             if (poolTokenCounts[0] == poolTokenCounts[1]) return false;
1024             else return true;
1025         }
1026         if (isFactoryPool(swapAddress)) return true;
1027     }
1028 
1029     /**
1030     @notice This function returns an array of underlying pool token addresses
1031     @param swapAddress Curve swap address for the pool
1032     @return returns 4 element array containing the addresses of the pool tokens (0 address if pool contains < 4 tokens)
1033     */
1034     function getPoolTokens(address swapAddress)
1035         public
1036         view
1037         returns (address[4] memory poolTokens)
1038     {
1039         if (isMetaPool(swapAddress)) {
1040             if (isFactoryPool(swapAddress)) {
1041                 address[2] memory poolUnderlyingCoins =
1042                     FactoryRegistry.get_coins(swapAddress);
1043                 for (uint256 i = 0; i < 2; i++) {
1044                     poolTokens[i] = poolUnderlyingCoins[i];
1045                 }
1046             } else {
1047                 address[8] memory poolUnderlyingCoins =
1048                     CurveRegistry.get_coins(swapAddress);
1049                 for (uint256 i = 0; i < 2; i++) {
1050                     poolTokens[i] = poolUnderlyingCoins[i];
1051                 }
1052             }
1053 
1054             return poolTokens;
1055         } else {
1056             address[8] memory poolUnderlyingCoins;
1057             if (isBtcPool(swapAddress) && !isMetaPool(swapAddress)) {
1058                 poolUnderlyingCoins = CurveRegistry.get_coins(swapAddress);
1059             } else {
1060                 poolUnderlyingCoins = CurveRegistry.get_underlying_coins(
1061                     swapAddress
1062                 );
1063             }
1064             for (uint256 i = 0; i < 4; i++) {
1065                 poolTokens[i] = poolUnderlyingCoins[i];
1066             }
1067         }
1068     }
1069 
1070     /**
1071     @notice This function checks if the curve pool contains WBTC
1072     @param swapAddress Curve swap address for the pool
1073     @return true if the pool contains WBTC, false otherwise
1074     */
1075     function isBtcPool(address swapAddress) public view returns (bool) {
1076         address[8] memory poolTokens = CurveRegistry.get_coins(swapAddress);
1077         for (uint256 i = 0; i < 4; i++) {
1078             if (poolTokens[i] == wbtcToken || poolTokens[i] == sbtcCrvToken)
1079                 return true;
1080         }
1081         return false;
1082     }
1083 
1084     /**
1085     @notice This function checks if the curve pool contains ETH
1086     @param swapAddress Curve swap address for the pool
1087     @return true if the pool contains ETH, false otherwise
1088     */
1089     function isEthPool(address swapAddress) external view returns (bool) {
1090         address[8] memory poolTokens = CurveRegistry.get_coins(swapAddress);
1091         for (uint256 i = 0; i < 4; i++) {
1092             if (poolTokens[i] == ETHAddress) {
1093                 return true;
1094             }
1095         }
1096         return false;
1097     }
1098 
1099     /**
1100     @notice This function is used to check if the pool contains the token
1101     @param swapAddress Curve swap address for the pool
1102     @param tokenContractAddress contract address of the token
1103     @return true if the pool contains the token, false otherwise
1104     @return index of the token in the pool, 0 if pool does not contain the token
1105     */
1106     function isUnderlyingToken(
1107         address swapAddress,
1108         address tokenContractAddress
1109     ) external view returns (bool, uint256) {
1110         address[4] memory poolTokens = getPoolTokens(swapAddress);
1111         for (uint256 i = 0; i < 4; i++) {
1112             if (poolTokens[i] == address(0)) return (false, 0);
1113             if (poolTokens[i] == tokenContractAddress) return (true, i);
1114         }
1115     }
1116 
1117     /**
1118     @notice Updates to the latest curve registry from the address provider
1119     */
1120     function update_curve_registry() external onlyOwner {
1121         address new_address = CurveAddressProvider.get_registry();
1122 
1123         require(address(CurveRegistry) != new_address, "Already updated");
1124 
1125         CurveRegistry = ICurveRegistry(new_address);
1126     }
1127 
1128     /**
1129     @notice Updates to the latest curve registry from the address provider
1130     */
1131     function update_factory_registry() external onlyOwner {
1132         address new_address = CurveAddressProvider.get_address(3);
1133 
1134         require(address(FactoryRegistry) != new_address, "Already updated");
1135 
1136         FactoryRegistry = ICurveFactoryRegistry(new_address);
1137     }
1138 
1139     /**
1140     @notice Add new pools which use the _use_underlying bool
1141     @param swapAddresses Curve swap addresses for the pool
1142     @param addUnderlying True if underlying tokens are always added
1143     */
1144     function updateShouldAddUnderlying(
1145         address[] calldata swapAddresses,
1146         bool[] calldata addUnderlying
1147     ) external onlyOwner {
1148         require(
1149             swapAddresses.length == addUnderlying.length,
1150             "Mismatched arrays"
1151         );
1152         for (uint256 i = 0; i < swapAddresses.length; i++) {
1153             shouldAddUnderlying[swapAddresses[i]] = addUnderlying[i];
1154         }
1155     }
1156 
1157     /**
1158     @notice Add new pools which use uamounts for add_liquidity
1159     @param swapAddresses Curve swap addresses to map from
1160     @param _depositAddresses Curve deposit addresses to map to
1161     */
1162     function updateDepositAddresses(
1163         address[] calldata swapAddresses,
1164         address[] calldata _depositAddresses
1165     ) external onlyOwner {
1166         require(
1167             swapAddresses.length == _depositAddresses.length,
1168             "Mismatched arrays"
1169         );
1170         for (uint256 i = 0; i < swapAddresses.length; i++) {
1171             depositAddresses[swapAddresses[i]] = _depositAddresses[i];
1172         }
1173     }
1174 
1175     /**
1176     //@notice Add new pools which use the _use_underlying bool
1177     */
1178     function withdrawTokens(address[] calldata tokens) external onlyOwner {
1179         for (uint256 i = 0; i < tokens.length; i++) {
1180             uint256 qty;
1181 
1182             if (tokens[i] == ETHAddress) {
1183                 qty = address(this).balance;
1184                 Address.sendValue(Address.toPayable(owner()), qty);
1185             } else {
1186                 qty = IERC20(tokens[i]).balanceOf(address(this));
1187                 IERC20(tokens[i]).safeTransfer(owner(), qty);
1188             }
1189         }
1190     }
1191 }
1192 
1193 // File contracts/Curve/Curve_ZapOut_General_V4_1.sol
1194 
1195 pragma solidity ^0.5.7;
1196 
1197 interface ICurveSwap {
1198     function remove_liquidity_one_coin(
1199         uint256 _token_amount,
1200         int128 i,
1201         uint256 min_amount
1202     ) external;
1203 
1204     function remove_liquidity_one_coin(
1205         uint256 _token_amount,
1206         int128 i,
1207         uint256 min_amount,
1208         bool removeUnderlying
1209     ) external;
1210 
1211     function calc_withdraw_one_coin(uint256 tokenAmount, int128 index)
1212         external
1213         view
1214         returns (uint256);
1215 }
1216 
1217 interface IWETH {
1218     function withdraw(uint256 wad) external;
1219 }
1220 
1221 contract Curve_ZapOut_General_V4_1 is ZapOutBaseV2_1 {
1222     using SafeMath for uint256;
1223     using SafeERC20 for IERC20;
1224 
1225     address private constant wethTokenAddress =
1226         address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
1227 
1228     Curve_Registry_V2 public curveReg;
1229 
1230     mapping(address => bool) public approvedTargets;
1231 
1232     constructor(
1233         Curve_Registry_V2 _curveRegistry,
1234         uint256 _goodwill,
1235         uint256 _affiliateSplit
1236     ) public ZapBaseV1(_goodwill, _affiliateSplit) {
1237         approvedTargets[0xDef1C0ded9bec7F1a1670819833240f027b25EfF] = true;
1238         curveReg = _curveRegistry;
1239     }
1240 
1241     event zapOut(
1242         address sender,
1243         address pool,
1244         address token,
1245         uint256 tokensRec
1246     );
1247 
1248     /**
1249     @notice This method removes the liquidity from curve pools to ETH/ERC tokens
1250     @param swapAddress indicates Curve swap address for the pool
1251     @param incomingCrv indicates the amount of lp tokens to remove
1252     @param intermediateToken specifies in which token to exit the curve pool
1253     @param toToken indicates the ETH/ERC token to which tokens to convert
1254     @param minToTokens indicates the minimum amount of toTokens to receive
1255     @param _swapTarget Excecution target for the first swap
1256     @param _swapCallData DEX quote data
1257     @param affiliate Affiliate address to share fees
1258     @param shouldSellEntireBalance True if incomingCrv is determined at execution time (i.e. contract is caller)
1259     @return ToTokensBought- indicates the amount of toTokens received
1260      */
1261     function ZapOut(
1262         address swapAddress,
1263         uint256 incomingCrv,
1264         address intermediateToken,
1265         address toToken,
1266         uint256 minToTokens,
1267         address _swapTarget,
1268         bytes calldata _swapCallData,
1269         address affiliate,
1270         bool shouldSellEntireBalance
1271     ) external stopInEmergency returns (uint256 ToTokensBought) {
1272         address poolTokenAddress = curveReg.getTokenAddress(swapAddress);
1273 
1274         // get lp tokens
1275         incomingCrv = _pullTokens(
1276             poolTokenAddress,
1277             incomingCrv,
1278             shouldSellEntireBalance
1279         );
1280 
1281         if (intermediateToken == address(0)) {
1282             intermediateToken = ETHAddress;
1283         }
1284 
1285         // perform zapOut
1286         ToTokensBought = _zapOut(
1287             swapAddress,
1288             incomingCrv,
1289             intermediateToken,
1290             toToken,
1291             _swapTarget,
1292             _swapCallData
1293         );
1294         require(ToTokensBought >= minToTokens, "High Slippage");
1295 
1296         uint256 totalGoodwillPortion;
1297 
1298         // Transfer tokens
1299         if (toToken == address(0)) {
1300             totalGoodwillPortion = _subtractGoodwill(
1301                 ETHAddress,
1302                 ToTokensBought,
1303                 affiliate,
1304                 true
1305             );
1306             Address.sendValue(
1307                 msg.sender,
1308                 ToTokensBought.sub(totalGoodwillPortion)
1309             );
1310         } else {
1311             totalGoodwillPortion = _subtractGoodwill(
1312                 toToken,
1313                 ToTokensBought,
1314                 affiliate,
1315                 true
1316             );
1317 
1318             IERC20(toToken).safeTransfer(
1319                 msg.sender,
1320                 ToTokensBought.sub(totalGoodwillPortion)
1321             );
1322         }
1323 
1324         emit zapOut(msg.sender, swapAddress, toToken, ToTokensBought);
1325 
1326         return ToTokensBought.sub(totalGoodwillPortion);
1327     }
1328 
1329     function _zapOut(
1330         address swapAddress,
1331         uint256 incomingCrv,
1332         address intermediateToken,
1333         address toToken,
1334         address _swapTarget,
1335         bytes memory _swapCallData
1336     ) internal returns (uint256 ToTokensBought) {
1337         (bool isUnderlying, uint256 underlyingIndex) =
1338             curveReg.isUnderlyingToken(swapAddress, intermediateToken);
1339 
1340         // not metapool
1341         if (isUnderlying) {
1342             uint256 intermediateBought =
1343                 _exitCurve(
1344                     swapAddress,
1345                     incomingCrv,
1346                     underlyingIndex,
1347                     intermediateToken
1348                 );
1349 
1350             if (intermediateToken == ETHAddress) intermediateToken = address(0);
1351 
1352             ToTokensBought = _fillQuote(
1353                 intermediateToken,
1354                 toToken,
1355                 intermediateBought,
1356                 _swapTarget,
1357                 _swapCallData
1358             );
1359         } else {
1360             // from metapool
1361             address[4] memory poolTokens = curveReg.getPoolTokens(swapAddress);
1362             address intermediateSwapAddress;
1363             uint8 i;
1364             for (; i < 4; i++) {
1365                 if (curveReg.getSwapAddress(poolTokens[i]) != address(0)) {
1366                     intermediateSwapAddress = curveReg.getSwapAddress(
1367                         poolTokens[i]
1368                     );
1369                     break;
1370                 }
1371             }
1372             // _exitCurve to intermediateSwapAddress Token
1373             uint256 intermediateCrvBought =
1374                 _exitMetaCurve(swapAddress, incomingCrv, i, poolTokens[i]);
1375             // _performZapOut: fromPool = intermediateSwapAddress
1376             ToTokensBought = _zapOut(
1377                 intermediateSwapAddress,
1378                 intermediateCrvBought,
1379                 intermediateToken,
1380                 toToken,
1381                 _swapTarget,
1382                 _swapCallData
1383             );
1384         }
1385     }
1386 
1387     /**
1388     @notice This method removes the liquidity from meta curve pools
1389     @param swapAddress indicates the curve pool address from which liquidity to be removed.
1390     @param incomingCrv indicates the amount of liquidity to be removed from the pool
1391     @param index indicates the index of underlying token of the pool in which liquidity will be removed. 
1392     @return tokensReceived- indicates the amount of reserve tokens received 
1393     */
1394     function _exitMetaCurve(
1395         address swapAddress,
1396         uint256 incomingCrv,
1397         uint256 index,
1398         address exitTokenAddress
1399     ) internal returns (uint256 tokensReceived) {
1400         require(incomingCrv > 0, "Insufficient lp tokens");
1401 
1402         address tokenAddress = curveReg.getTokenAddress(swapAddress);
1403         _approveToken(tokenAddress, swapAddress);
1404 
1405         uint256 iniTokenBal = IERC20(exitTokenAddress).balanceOf(address(this));
1406         ICurveSwap(swapAddress).remove_liquidity_one_coin(
1407             incomingCrv,
1408             int128(index),
1409             0
1410         );
1411         tokensReceived = (IERC20(exitTokenAddress).balanceOf(address(this)))
1412             .sub(iniTokenBal);
1413 
1414         require(tokensReceived > 0, "Could not receive reserve tokens");
1415     }
1416 
1417     /**
1418     @notice This method removes the liquidity from given curve pool
1419     @param swapAddress indicates the curve pool address from which liquidity to be removed.
1420     @param incomingCrv indicates the amount of liquidity to be removed from the pool
1421     @param index indicates the index of underlying token of the pool in which liquidity will be removed. 
1422     @return tokensReceived- indicates the amount of reserve tokens received 
1423     */
1424     function _exitCurve(
1425         address swapAddress,
1426         uint256 incomingCrv,
1427         uint256 index,
1428         address exitTokenAddress
1429     ) internal returns (uint256 tokensReceived) {
1430         require(incomingCrv > 0, "Insufficient lp tokens");
1431 
1432         address depositAddress = curveReg.getDepositAddress(swapAddress);
1433 
1434         address tokenAddress = curveReg.getTokenAddress(swapAddress);
1435         _approveToken(tokenAddress, depositAddress);
1436 
1437         address balanceToken =
1438             exitTokenAddress == ETHAddress ? address(0) : exitTokenAddress;
1439 
1440         uint256 iniTokenBal = _getBalance(balanceToken);
1441 
1442         if (curveReg.shouldAddUnderlying(swapAddress)) {
1443             // aave
1444             ICurveSwap(depositAddress).remove_liquidity_one_coin(
1445                 incomingCrv,
1446                 int128(index),
1447                 0,
1448                 true
1449             );
1450         } else {
1451             ICurveSwap(depositAddress).remove_liquidity_one_coin(
1452                 incomingCrv,
1453                 int128(index),
1454                 0
1455             );
1456         }
1457 
1458         tokensReceived = _getBalance(balanceToken).sub(iniTokenBal);
1459 
1460         require(tokensReceived > 0, "Could not receive reserve tokens");
1461     }
1462 
1463     /**
1464     @notice This method swaps the fromToken to toToken using the 0x swap
1465     @param _fromTokenAddress indicates the ETH/ERC20 token
1466     @param _toTokenAddress indicates the ETH/ERC20 token
1467     @param _amount indicates the amount of from tokens to swap
1468     @param _swapTarget Excecution target for the first swap
1469     @param _swapCallData DEX quote data
1470     */
1471     function _fillQuote(
1472         address _fromTokenAddress,
1473         address _toTokenAddress,
1474         uint256 _amount,
1475         address _swapTarget,
1476         bytes memory _swapCallData
1477     ) internal returns (uint256 amountBought) {
1478         if (_fromTokenAddress == _toTokenAddress) return _amount;
1479         if (_swapTarget == wethTokenAddress) {
1480             IWETH(wethTokenAddress).withdraw(_amount);
1481             return _amount;
1482         }
1483         uint256 valueToSend;
1484         if (_fromTokenAddress == ETHAddress || _fromTokenAddress == address(0))
1485             valueToSend = _amount;
1486         else _approveToken(_fromTokenAddress, _swapTarget);
1487 
1488         uint256 iniBal = _getBalance(_toTokenAddress);
1489         require(approvedTargets[_swapTarget], "Target not Authorized");
1490         (bool success, ) = _swapTarget.call.value(valueToSend)(_swapCallData);
1491         require(success, "Error Swapping Tokens");
1492         uint256 finalBal = _getBalance(_toTokenAddress);
1493 
1494         amountBought = finalBal.sub(iniBal);
1495 
1496         require(amountBought > 0, "Swapped To Invalid Intermediate");
1497     }
1498 
1499     /**
1500     @notice Utility function to determine the quantity and address of a token being removed
1501     @param swapAddress indicates the curve pool address from which liquidity to be removed
1502     @param tokenAddress token to be removed
1503     @param liquidity Quantity of LP tokens to remove.
1504     @return  amount Quantity of token removed
1505     */
1506     function removeLiquidityReturn(
1507         address swapAddress,
1508         address tokenAddress,
1509         uint256 liquidity
1510     ) external view returns (uint256 amount) {
1511         if (tokenAddress == address(0)) tokenAddress = ETHAddress;
1512         (bool underlying, uint256 index) =
1513             curveReg.isUnderlyingToken(swapAddress, tokenAddress);
1514         if (underlying) {
1515             return
1516                 ICurveSwap(curveReg.getDepositAddress(swapAddress))
1517                     .calc_withdraw_one_coin(liquidity, int128(index));
1518         } else {
1519             address[4] memory poolTokens = curveReg.getPoolTokens(swapAddress);
1520             address intermediateSwapAddress;
1521             for (uint256 i = 0; i < 4; i++) {
1522                 intermediateSwapAddress = curveReg.getSwapAddress(
1523                     poolTokens[i]
1524                 );
1525                 if (intermediateSwapAddress != address(0)) break;
1526             }
1527             uint256 metaTokensRec =
1528                 ICurveSwap(swapAddress).calc_withdraw_one_coin(liquidity, 1);
1529 
1530             (, index) = curveReg.isUnderlyingToken(
1531                 intermediateSwapAddress,
1532                 tokenAddress
1533             );
1534 
1535             return
1536                 ICurveSwap(intermediateSwapAddress).calc_withdraw_one_coin(
1537                     metaTokensRec,
1538                     int128(index)
1539                 );
1540         }
1541     }
1542 
1543     function updateCurveRegistry(Curve_Registry_V2 newCurveRegistry)
1544         external
1545         onlyOwner
1546     {
1547         require(newCurveRegistry != curveReg, "Already using this Registry");
1548         curveReg = newCurveRegistry;
1549     }
1550 
1551     function setApprovedTargets(
1552         address[] calldata targets,
1553         bool[] calldata isApproved
1554     ) external onlyOwner {
1555         require(targets.length == isApproved.length, "Invalid Input length");
1556 
1557         for (uint256 i = 0; i < targets.length; i++) {
1558             approvedTargets[targets[i]] = isApproved[i];
1559         }
1560     }
1561 }