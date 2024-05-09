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
21 ///@notice This contract adds liquidity to Yearn Vaults using ETH or ERC20 Tokens.
22 // SPDX-License-Identifier: GPLv2
23 
24 // File: contracts/oz/GSN/Context.sol
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
55 // File: contracts/oz/ownership/Ownable.sol
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
140 // File: contracts/oz/token/ERC20/IERC20.sol
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
234 // File: contracts/oz/math/SafeMath.sol
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
405 // File: contracts/oz/utils/Address.sol
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
492 // File: contracts/oz/token/ERC20/SafeERC20.sol
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
620 // File: contracts/_base/ZapBaseV1.sol
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
679     // - to Pause the contract
680     function toggleContractActive() public onlyOwner {
681         stopped = !stopped;
682     }
683 
684     function set_feeWhitelist(address zapAddress, bool status)
685         external
686         onlyOwner
687     {
688         feeWhitelist[zapAddress] = status;
689     }
690 
691     function set_new_goodwill(uint256 _new_goodwill) public onlyOwner {
692         require(
693             _new_goodwill >= 0 && _new_goodwill <= 100,
694             "GoodWill Value not allowed"
695         );
696         goodwill = _new_goodwill;
697     }
698 
699     function set_new_affiliateSplit(uint256 _new_affiliateSplit)
700         external
701         onlyOwner
702     {
703         require(
704             _new_affiliateSplit <= 100,
705             "Affiliate Split Value not allowed"
706         );
707         affiliateSplit = _new_affiliateSplit;
708     }
709 
710     function set_affiliate(address _affiliate, bool _status)
711         external
712         onlyOwner
713     {
714         affiliates[_affiliate] = _status;
715     }
716 
717     ///@notice Withdraw goodwill share, retaining affilliate share
718     function withdrawTokens(address[] calldata tokens) external onlyOwner {
719         for (uint256 i = 0; i < tokens.length; i++) {
720             uint256 qty;
721 
722             if (tokens[i] == ETHAddress) {
723                 qty = address(this).balance.sub(
724                     totalAffiliateBalance[tokens[i]]
725                 );
726                 Address.sendValue(Address.toPayable(owner()), qty);
727             } else {
728                 qty = IERC20(tokens[i]).balanceOf(address(this)).sub(
729                     totalAffiliateBalance[tokens[i]]
730                 );
731                 IERC20(tokens[i]).safeTransfer(owner(), qty);
732             }
733         }
734     }
735 
736     ///@notice Withdraw affilliate share, retaining goodwill share
737     function affilliateWithdraw(address[] calldata tokens) external {
738         uint256 tokenBal;
739         for (uint256 i = 0; i < tokens.length; i++) {
740             tokenBal = affiliateBalance[msg.sender][tokens[i]];
741             affiliateBalance[msg.sender][tokens[i]] = 0;
742             totalAffiliateBalance[tokens[i]] = totalAffiliateBalance[tokens[i]]
743                 .sub(tokenBal);
744 
745             if (tokens[i] == ETHAddress) {
746                 Address.sendValue(msg.sender, tokenBal);
747             } else {
748                 IERC20(tokens[i]).safeTransfer(msg.sender, tokenBal);
749             }
750         }
751     }
752 
753     function() external payable {
754         require(msg.sender != tx.origin, "Do not send ETH directly");
755     }
756 }
757 
758 // File: contracts/_base/ZapInBaseV1.sol
759 
760 pragma solidity ^0.5.7;
761 
762 contract ZapInBaseV1 is ZapBaseV1 {
763     function _pullTokens(
764         address token,
765         uint256 amount,
766         address affiliate,
767         bool enableGoodwill
768     ) internal returns (uint256 value) {
769         uint256 totalGoodwillPortion;
770 
771         if (token == address(0)) {
772             require(msg.value > 0, "No eth sent");
773 
774             // subtract goodwill
775             totalGoodwillPortion = _subtractGoodwill(
776                 ETHAddress,
777                 msg.value,
778                 affiliate,
779                 enableGoodwill
780             );
781 
782             return msg.value.sub(totalGoodwillPortion);
783         }
784         require(amount > 0, "Invalid token amount");
785         require(msg.value == 0, "Eth sent with token");
786 
787         //transfer token
788         IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
789 
790         // subtract goodwill
791         totalGoodwillPortion = _subtractGoodwill(
792             token,
793             amount,
794             affiliate,
795             enableGoodwill
796         );
797 
798         return amount.sub(totalGoodwillPortion);
799     }
800 
801     function _subtractGoodwill(
802         address token,
803         uint256 amount,
804         address affiliate,
805         bool enableGoodwill
806     ) internal returns (uint256 totalGoodwillPortion) {
807         bool whitelisted = feeWhitelist[msg.sender];
808         if (enableGoodwill && !whitelisted && goodwill > 0) {
809             totalGoodwillPortion = SafeMath.div(
810                 SafeMath.mul(amount, goodwill),
811                 10000
812             );
813 
814             if (affiliates[affiliate]) {
815                 if (token == address(0)) {
816                     token = ETHAddress;
817                 }
818 
819                 uint256 affiliatePortion =
820                     totalGoodwillPortion.mul(affiliateSplit).div(100);
821                 affiliateBalance[affiliate][token] = affiliateBalance[
822                     affiliate
823                 ][token]
824                     .add(affiliatePortion);
825                 totalAffiliateBalance[token] = totalAffiliateBalance[token].add(
826                     affiliatePortion
827                 );
828             }
829         }
830     }
831 }
832 
833 // File: contracts/yEarn/yVault_ZapIn_V3.sol
834 
835 pragma solidity ^0.5.7;
836 
837 interface IYVault {
838     function deposit(uint256) external;
839 
840     function withdraw(uint256) external;
841 
842     function getPricePerFullShare() external view returns (uint256);
843 
844     function token() external view returns (address);
845 
846     // V2
847     function pricePerShare() external view returns (uint256);
848 }
849 
850 // -- Aave --
851 interface IAaveLendingPoolAddressesProvider {
852     function getLendingPool() external view returns (address);
853 
854     function getLendingPoolCore() external view returns (address payable);
855 }
856 
857 interface IAaveLendingPoolCore {
858     function getReserveATokenAddress(address _reserve)
859         external
860         view
861         returns (address);
862 }
863 
864 interface IAaveLendingPool {
865     function deposit(
866         address _reserve,
867         uint256 _amount,
868         uint16 _referralCode
869     ) external payable;
870 }
871 
872 contract yVault_ZapIn_V3 is ZapInBaseV1 {
873     // calldata only accepted for approved zap contracts
874     mapping(address => bool) public approvedTargets;
875 
876     IAaveLendingPoolAddressesProvider
877         private constant lendingPoolAddressProvider =
878         IAaveLendingPoolAddressesProvider(
879             0x24a42fD28C976A61Df5D00D0599C34c4f90748c8
880         );
881 
882     event zapIn(address sender, address pool, uint256 tokensRec);
883 
884     constructor(
885         address _curveZapIn,
886         uint256 _goodwill,
887         uint256 _affiliateSplit
888     ) public ZapBaseV1(_goodwill, _affiliateSplit) {}
889 
890     /**
891     @notice This function adds liquidity to a Yearn vaults with ETH or ERC20 tokens
892     @param fromToken The token used for entry (address(0) if ether)
893     @param amountIn The amount of fromToken to invest
894     @param toVault Yearn vault address
895     @param superVault Super vault to depoist toVault tokens into (address(0) if none)
896     @param isAaveUnderlying True if vault contains aave token
897     @param minYVTokens The minimum acceptable quantity vault tokens to receive. Reverts otherwise
898     @param intermediateToken Token to swap fromToken to before entering vault
899     @param swapTarget Excecution target for the swap or Zap
900     @param swapData DEX quote or Zap data
901     @param affiliate Affiliate address
902     @return tokensReceived- Quantity of Vault tokens received
903      */
904     function ZapIn(
905         address fromToken,
906         uint256 amountIn,
907         address toVault,
908         address superVault,
909         bool isAaveUnderlying,
910         uint256 minYVTokens,
911         address intermediateToken,
912         address swapTarget,
913         bytes calldata swapData,
914         address affiliate
915     ) external payable stopInEmergency returns (uint256 tokensReceived) {
916         require(
917             approvedTargets[swapTarget] || swapTarget == address(0),
918             "Target not Authorized"
919         );
920 
921         // get incoming tokens
922         uint256 toInvest = _pullTokens(fromToken, amountIn, affiliate, true);
923 
924         // get intermediate token
925         uint256 intermediateAmt =
926             _fillQuote(
927                 fromToken,
928                 intermediateToken,
929                 toInvest,
930                 swapTarget,
931                 swapData
932             );
933 
934         // get 'aIntermediateToken'
935         if (isAaveUnderlying) {
936             address aaveLendingPoolCore =
937                 lendingPoolAddressProvider.getLendingPoolCore();
938             _approveToken(intermediateToken, aaveLendingPoolCore);
939 
940             IAaveLendingPool(lendingPoolAddressProvider.getLendingPool())
941                 .deposit(intermediateToken, intermediateAmt, 0);
942 
943             intermediateToken = IAaveLendingPoolCore(aaveLendingPoolCore)
944                 .getReserveATokenAddress(intermediateToken);
945         }
946 
947         return
948             _zapIn(
949                 toVault,
950                 superVault,
951                 minYVTokens,
952                 intermediateToken,
953                 intermediateAmt
954             );
955     }
956 
957     function _zapIn(
958         address toVault,
959         address superVault,
960         uint256 minYVTokens,
961         address intermediateToken,
962         uint256 intermediateAmt
963     ) internal returns (uint256 tokensReceived) {
964         // Deposit to Vault
965         if (superVault == address(0)) {
966             tokensReceived = _vaultDeposit(
967                 intermediateToken,
968                 intermediateAmt,
969                 toVault,
970                 minYVTokens,
971                 true
972             );
973         } else {
974             uint256 intermediateYVTokens =
975                 _vaultDeposit(
976                     intermediateToken,
977                     intermediateAmt,
978                     toVault,
979                     0,
980                     false
981                 );
982             // deposit to super vault
983             tokensReceived = _vaultDeposit(
984                 IYVault(superVault).token(),
985                 intermediateYVTokens,
986                 superVault,
987                 minYVTokens,
988                 true
989             );
990         }
991     }
992 
993     function _vaultDeposit(
994         address underlyingVaultToken,
995         uint256 amount,
996         address toVault,
997         uint256 minTokensRec,
998         bool shouldTransfer
999     ) internal returns (uint256 tokensReceived) {
1000         _approveToken(underlyingVaultToken, toVault);
1001 
1002         uint256 iniYVaultBal = IERC20(toVault).balanceOf(address(this));
1003         IYVault(toVault).deposit(amount);
1004         tokensReceived = IERC20(toVault).balanceOf(address(this)).sub(
1005             iniYVaultBal
1006         );
1007         require(tokensReceived >= minTokensRec, "Err: High Slippage");
1008 
1009         if (shouldTransfer) {
1010             IERC20(toVault).safeTransfer(msg.sender, tokensReceived);
1011             emit zapIn(msg.sender, toVault, tokensReceived);
1012         }
1013     }
1014 
1015     function _fillQuote(
1016         address _fromTokenAddress,
1017         address toToken,
1018         uint256 _amount,
1019         address _swapTarget,
1020         bytes memory swapCallData
1021     ) internal returns (uint256 amtBought) {
1022         uint256 valueToSend;
1023 
1024         if (_fromTokenAddress == toToken) {
1025             return _amount;
1026         }
1027 
1028         if (_fromTokenAddress == address(0)) {
1029             valueToSend = _amount;
1030         } else {
1031             _approveToken(_fromTokenAddress, _swapTarget);
1032         }
1033 
1034         uint256 iniBal = _getBalance(toToken);
1035         (bool success, ) = _swapTarget.call.value(valueToSend)(swapCallData);
1036         require(success, "Error Swapping Tokens 1");
1037         uint256 finalBal = _getBalance(toToken);
1038 
1039         amtBought = finalBal.sub(iniBal);
1040     }
1041 
1042     function setApprovedTargets(
1043         address[] calldata targets,
1044         bool[] calldata isApproved
1045     ) external onlyOwner {
1046         require(targets.length == isApproved.length, "Invalid Input length");
1047 
1048         for (uint256 i = 0; i < targets.length; i++) {
1049             approvedTargets[targets[i]] = isApproved[i];
1050         }
1051     }
1052 }