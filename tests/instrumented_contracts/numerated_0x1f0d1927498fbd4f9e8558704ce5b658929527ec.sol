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
21 ///@notice This contract swaps and bridges ETH/Tokens to Matic/Polygon
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
149     /**
150      * @dev Returns the amount of tokens in existence.
151      */
152     function totalSupply() external view returns (uint256);
153 
154     /**
155      * @dev Returns the amount of tokens owned by `account`.
156      */
157     function balanceOf(address account) external view returns (uint256);
158 
159     /**
160      * @dev Moves `amount` tokens from the caller's account to `recipient`.
161      *
162      * Returns a boolean value indicating whether the operation succeeded.
163      *
164      * Emits a {Transfer} event.
165      */
166     function transfer(address recipient, uint256 amount)
167         external
168         returns (bool);
169 
170     /**
171      * @dev Returns the remaining number of tokens that `spender` will be
172      * allowed to spend on behalf of `owner` through {transferFrom}. This is
173      * zero by default.
174      *
175      * This value changes when {approve} or {transferFrom} are called.
176      */
177     function allowance(address owner, address spender)
178         external
179         view
180         returns (uint256);
181 
182     /**
183      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
184      *
185      * Returns a boolean value indicating whether the operation succeeded.
186      *
187      * IMPORTANT: Beware that changing an allowance with this method brings the risk
188      * that someone may use both the old and the new allowance by unfortunate
189      * transaction ordering. One possible solution to mitigate this race
190      * condition is to first reduce the spender's allowance to 0 and set the
191      * desired value afterwards:
192      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
193      *
194      * Emits an {Approval} event.
195      */
196     function approve(address spender, uint256 amount) external returns (bool);
197 
198     /**
199      * @dev Moves `amount` tokens from `sender` to `recipient` using the
200      * allowance mechanism. `amount` is then deducted from the caller's
201      * allowance.
202      *
203      * Returns a boolean value indicating whether the operation succeeded.
204      *
205      * Emits a {Transfer} event.
206      */
207     function transferFrom(
208         address sender,
209         address recipient,
210         uint256 amount
211     ) external returns (bool);
212 
213     /**
214      * @dev Emitted when `value` tokens are moved from one account (`from`) to
215      * another (`to`).
216      *
217      * Note that `value` may be zero.
218      */
219     event Transfer(address indexed from, address indexed to, uint256 value);
220 
221     /**
222      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
223      * a call to {approve}. `value` is the new allowance.
224      */
225     event Approval(
226         address indexed owner,
227         address indexed spender,
228         uint256 value
229     );
230 }
231 
232 // File: contracts/oz/math/SafeMath.sol
233 
234 pragma solidity ^0.5.0;
235 
236 /**
237  * @dev Wrappers over Solidity's arithmetic operations with added overflow
238  * checks.
239  *
240  * Arithmetic operations in Solidity wrap on overflow. This can easily result
241  * in bugs, because programmers usually assume that an overflow raises an
242  * error, which is the standard behavior in high level programming languages.
243  * `SafeMath` restores this intuition by reverting the transaction when an
244  * operation overflows.
245  *
246  * Using this library instead of the unchecked operations eliminates an entire
247  * class of bugs, so it's recommended to use it always.
248  */
249 library SafeMath {
250     /**
251      * @dev Returns the addition of two unsigned integers, reverting on
252      * overflow.
253      *
254      * Counterpart to Solidity's `+` operator.
255      *
256      * Requirements:
257      * - Addition cannot overflow.
258      */
259     function add(uint256 a, uint256 b) internal pure returns (uint256) {
260         uint256 c = a + b;
261         require(c >= a, "SafeMath: addition overflow");
262 
263         return c;
264     }
265 
266     /**
267      * @dev Returns the subtraction of two unsigned integers, reverting on
268      * overflow (when the result is negative).
269      *
270      * Counterpart to Solidity's `-` operator.
271      *
272      * Requirements:
273      * - Subtraction cannot overflow.
274      */
275     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
276         return sub(a, b, "SafeMath: subtraction overflow");
277     }
278 
279     /**
280      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
281      * overflow (when the result is negative).
282      *
283      * Counterpart to Solidity's `-` operator.
284      *
285      * Requirements:
286      * - Subtraction cannot overflow.
287      *
288      * _Available since v2.4.0._
289      */
290     function sub(
291         uint256 a,
292         uint256 b,
293         string memory errorMessage
294     ) internal pure returns (uint256) {
295         require(b <= a, errorMessage);
296         uint256 c = a - b;
297 
298         return c;
299     }
300 
301     /**
302      * @dev Returns the multiplication of two unsigned integers, reverting on
303      * overflow.
304      *
305      * Counterpart to Solidity's `*` operator.
306      *
307      * Requirements:
308      * - Multiplication cannot overflow.
309      */
310     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
311         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
312         // benefit is lost if 'b' is also tested.
313         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
314         if (a == 0) {
315             return 0;
316         }
317 
318         uint256 c = a * b;
319         require(c / a == b, "SafeMath: multiplication overflow");
320 
321         return c;
322     }
323 
324     /**
325      * @dev Returns the integer division of two unsigned integers. Reverts on
326      * division by zero. The result is rounded towards zero.
327      *
328      * Counterpart to Solidity's `/` operator. Note: this function uses a
329      * `revert` opcode (which leaves remaining gas untouched) while Solidity
330      * uses an invalid opcode to revert (consuming all remaining gas).
331      *
332      * Requirements:
333      * - The divisor cannot be zero.
334      */
335     function div(uint256 a, uint256 b) internal pure returns (uint256) {
336         return div(a, b, "SafeMath: division by zero");
337     }
338 
339     /**
340      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
341      * division by zero. The result is rounded towards zero.
342      *
343      * Counterpart to Solidity's `/` operator. Note: this function uses a
344      * `revert` opcode (which leaves remaining gas untouched) while Solidity
345      * uses an invalid opcode to revert (consuming all remaining gas).
346      *
347      * Requirements:
348      * - The divisor cannot be zero.
349      *
350      * _Available since v2.4.0._
351      */
352     function div(
353         uint256 a,
354         uint256 b,
355         string memory errorMessage
356     ) internal pure returns (uint256) {
357         // Solidity only automatically asserts when dividing by 0
358         require(b > 0, errorMessage);
359         uint256 c = a / b;
360         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
361 
362         return c;
363     }
364 
365     /**
366      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
367      * Reverts when dividing by zero.
368      *
369      * Counterpart to Solidity's `%` operator. This function uses a `revert`
370      * opcode (which leaves remaining gas untouched) while Solidity uses an
371      * invalid opcode to revert (consuming all remaining gas).
372      *
373      * Requirements:
374      * - The divisor cannot be zero.
375      */
376     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
377         return mod(a, b, "SafeMath: modulo by zero");
378     }
379 
380     /**
381      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
382      * Reverts with custom message when dividing by zero.
383      *
384      * Counterpart to Solidity's `%` operator. This function uses a `revert`
385      * opcode (which leaves remaining gas untouched) while Solidity uses an
386      * invalid opcode to revert (consuming all remaining gas).
387      *
388      * Requirements:
389      * - The divisor cannot be zero.
390      *
391      * _Available since v2.4.0._
392      */
393     function mod(
394         uint256 a,
395         uint256 b,
396         string memory errorMessage
397     ) internal pure returns (uint256) {
398         require(b != 0, errorMessage);
399         return a % b;
400     }
401 }
402 
403 // File: contracts/oz/utils/Address.sol
404 
405 pragma solidity ^0.5.5;
406 
407 /**
408  * @dev Collection of functions related to the address type
409  */
410 library Address {
411     /**
412      * @dev Returns true if `account` is a contract.
413      *
414      * [IMPORTANT]
415      * ====
416      * It is unsafe to assume that an address for which this function returns
417      * false is an externally-owned account (EOA) and not a contract.
418      *
419      * Among others, `isContract` will return false for the following
420      * types of addresses:
421      *
422      *  - an externally-owned account
423      *  - a contract in construction
424      *  - an address where a contract will be created
425      *  - an address where a contract lived, but was destroyed
426      * ====
427      */
428     function isContract(address account) internal view returns (bool) {
429         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
430         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
431         // for accounts without code, i.e. `keccak256('')`
432         bytes32 codehash;
433 
434 
435             bytes32 accountHash
436          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
437         // solhint-disable-next-line no-inline-assembly
438         assembly {
439             codehash := extcodehash(account)
440         }
441         return (codehash != accountHash && codehash != 0x0);
442     }
443 
444     /**
445      * @dev Converts an `address` into `address payable`. Note that this is
446      * simply a type cast: the actual underlying value is not changed.
447      *
448      * _Available since v2.4.0._
449      */
450     function toPayable(address account)
451         internal
452         pure
453         returns (address payable)
454     {
455         return address(uint160(account));
456     }
457 
458     /**
459      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
460      * `recipient`, forwarding all available gas and reverting on errors.
461      *
462      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
463      * of certain opcodes, possibly making contracts go over the 2300 gas limit
464      * imposed by `transfer`, making them unable to receive funds via
465      * `transfer`. {sendValue} removes this limitation.
466      *
467      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
468      *
469      * IMPORTANT: because control is transferred to `recipient`, care must be
470      * taken to not create reentrancy vulnerabilities. Consider using
471      * {ReentrancyGuard} or the
472      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
473      *
474      * _Available since v2.4.0._
475      */
476     function sendValue(address payable recipient, uint256 amount) internal {
477         require(
478             address(this).balance >= amount,
479             "Address: insufficient balance"
480         );
481 
482         // solhint-disable-next-line avoid-call-value
483         (bool success, ) = recipient.call.value(amount)("");
484         require(
485             success,
486             "Address: unable to send value, recipient may have reverted"
487         );
488     }
489 }
490 
491 // File: contracts/oz/token/ERC20/SafeERC20.sol
492 
493 pragma solidity ^0.5.0;
494 
495 /**
496  * @title SafeERC20
497  * @dev Wrappers around ERC20 operations that throw on failure (when the token
498  * contract returns false). Tokens that return no value (and instead revert or
499  * throw on failure) are also supported, non-reverting calls are assumed to be
500  * successful.
501  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
502  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
503  */
504 library SafeERC20 {
505     using SafeMath for uint256;
506     using Address for address;
507 
508     function safeTransfer(
509         IERC20 token,
510         address to,
511         uint256 value
512     ) internal {
513         callOptionalReturn(
514             token,
515             abi.encodeWithSelector(token.transfer.selector, to, value)
516         );
517     }
518 
519     function safeTransferFrom(
520         IERC20 token,
521         address from,
522         address to,
523         uint256 value
524     ) internal {
525         callOptionalReturn(
526             token,
527             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
528         );
529     }
530 
531     function safeApprove(
532         IERC20 token,
533         address spender,
534         uint256 value
535     ) internal {
536         // safeApprove should only be called when setting an initial allowance,
537         // or when resetting it to zero. To increase and decrease it, use
538         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
539         // solhint-disable-next-line max-line-length
540         require(
541             (value == 0) || (token.allowance(address(this), spender) == 0),
542             "SafeERC20: approve from non-zero to non-zero allowance"
543         );
544         callOptionalReturn(
545             token,
546             abi.encodeWithSelector(token.approve.selector, spender, value)
547         );
548     }
549 
550     function safeIncreaseAllowance(
551         IERC20 token,
552         address spender,
553         uint256 value
554     ) internal {
555         uint256 newAllowance = token.allowance(address(this), spender).add(
556             value
557         );
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
573         uint256 newAllowance = token.allowance(address(this), spender).sub(
574             value,
575             "SafeERC20: decreased allowance below zero"
576         );
577         callOptionalReturn(
578             token,
579             abi.encodeWithSelector(
580                 token.approve.selector,
581                 spender,
582                 newAllowance
583             )
584         );
585     }
586 
587     /**
588      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
589      * on the return value: the return value is optional (but if data is returned, it must not be false).
590      * @param token The token targeted by the call.
591      * @param data The call data (encoded using abi.encode or one of its variants).
592      */
593     function callOptionalReturn(IERC20 token, bytes memory data) private {
594         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
595         // we're implementing it ourselves.
596 
597         // A Solidity high level call has three parts:
598         //  1. The target address is checked to verify it contains contract code
599         //  2. The call itself is made, and success asserted
600         //  3. The return value is decoded, which in turn checks the size of the returned data.
601         // solhint-disable-next-line max-line-length
602         require(address(token).isContract(), "SafeERC20: call to non-contract");
603 
604         // solhint-disable-next-line avoid-low-level-calls
605         (bool success, bytes memory returndata) = address(token).call(data);
606         require(success, "SafeERC20: low-level call failed");
607 
608         if (returndata.length > 0) {
609             // Return data is optional
610             // solhint-disable-next-line max-line-length
611             require(
612                 abi.decode(returndata, (bool)),
613                 "SafeERC20: ERC20 operation did not succeed"
614             );
615         }
616     }
617 }
618 
619 // File: contracts/_base/ZapBaseV1.sol
620 
621 pragma solidity ^0.5.7;
622 
623 contract ZapBaseV1 is Ownable {
624     using SafeMath for uint256;
625     using SafeERC20 for IERC20;
626     bool public stopped = false;
627 
628     // if true, goodwill is not deducted
629     mapping(address => bool) public feeWhitelist;
630 
631     uint256 public goodwill;
632     // % share of goodwill (0-100 %)
633     uint256 affiliateSplit;
634     // restrict affiliates
635     mapping(address => bool) public affiliates;
636     // affiliate => token => amount
637     mapping(address => mapping(address => uint256)) public affiliateBalance;
638     // token => amount
639     mapping(address => uint256) public totalAffiliateBalance;
640 
641     address
642         internal constant ETHAddress = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
643 
644     constructor(uint256 _goodwill, uint256 _affiliateSplit) public {
645         goodwill = _goodwill;
646         affiliateSplit = _affiliateSplit;
647     }
648 
649     // circuit breaker modifiers
650     modifier stopInEmergency {
651         if (stopped) {
652             revert("Temporarily Paused");
653         } else {
654             _;
655         }
656     }
657 
658     function _getBalance(address token)
659         internal
660         view
661         returns (uint256 balance)
662     {
663         if (token == address(0)) {
664             balance = address(this).balance;
665         } else {
666             balance = IERC20(token).balanceOf(address(this));
667         }
668     }
669 
670     function _approveToken(address token, address spender) internal {
671         IERC20 _token = IERC20(token);
672         if (_token.allowance(address(this), spender) > 0) return;
673         else {
674             _token.safeApprove(spender, uint256(-1));
675         }
676     }
677 
678     // - to Pause the contract
679     function toggleContractActive() public onlyOwner {
680         stopped = !stopped;
681     }
682 
683     function set_feeWhitelist(address zapAddress, bool status)
684         external
685         onlyOwner
686     {
687         feeWhitelist[zapAddress] = status;
688     }
689 
690     function set_new_goodwill(uint256 _new_goodwill) public onlyOwner {
691         require(
692             _new_goodwill >= 0 && _new_goodwill <= 100,
693             "GoodWill Value not allowed"
694         );
695         goodwill = _new_goodwill;
696     }
697 
698     function set_new_affiliateSplit(uint256 _new_affiliateSplit)
699         external
700         onlyOwner
701     {
702         require(
703             _new_affiliateSplit <= 100,
704             "Affiliate Split Value not allowed"
705         );
706         affiliateSplit = _new_affiliateSplit;
707     }
708 
709     function set_affiliate(address _affiliate, bool _status)
710         external
711         onlyOwner
712     {
713         affiliates[_affiliate] = _status;
714     }
715 
716     ///@notice Withdraw goodwill share, retaining affilliate share
717     function withdrawTokens(address[] calldata tokens) external onlyOwner {
718         for (uint256 i = 0; i < tokens.length; i++) {
719             uint256 qty;
720 
721             if (tokens[i] == ETHAddress) {
722                 qty = address(this).balance.sub(
723                     totalAffiliateBalance[tokens[i]]
724                 );
725                 Address.sendValue(Address.toPayable(owner()), qty);
726             } else {
727                 qty = IERC20(tokens[i]).balanceOf(address(this)).sub(
728                     totalAffiliateBalance[tokens[i]]
729                 );
730                 IERC20(tokens[i]).safeTransfer(owner(), qty);
731             }
732         }
733     }
734 
735     ///@notice Withdraw affilliate share, retaining goodwill share
736     function affilliateWithdraw(address[] calldata tokens) external {
737         uint256 tokenBal;
738         for (uint256 i = 0; i < tokens.length; i++) {
739             tokenBal = affiliateBalance[msg.sender][tokens[i]];
740             affiliateBalance[msg.sender][tokens[i]] = 0;
741             totalAffiliateBalance[tokens[i]] = totalAffiliateBalance[tokens[i]]
742                 .sub(tokenBal);
743 
744             if (tokens[i] == ETHAddress) {
745                 Address.sendValue(msg.sender, tokenBal);
746             } else {
747                 IERC20(tokens[i]).safeTransfer(msg.sender, tokenBal);
748             }
749         }
750     }
751 
752     function() external payable {
753         require(msg.sender != tx.origin, "Do not send ETH directly");
754     }
755 }
756 
757 // File: contracts/MaticBridge/Zapper_Matic_Bridge_V1.sol
758 
759 pragma solidity ^0.5.7;
760 pragma experimental ABIEncoderV2;
761 
762 // PoS Bridge
763 interface IRootChainManager {
764     function depositEtherFor(address user) external payable;
765 
766     function depositFor(
767         address user,
768         address rootToken,
769         bytes calldata depositData
770     ) external;
771 
772     function tokenToType(address) external returns (bytes32);
773 
774     function typeToPredicate(bytes32) external returns (address);
775 }
776 
777 // Plasma Bridge
778 interface IDepositManager {
779     function depositERC20ForUser(
780         address _token,
781         address _user,
782         uint256 _amount
783     ) external;
784 }
785 
786 contract Zapper_Matic_Bridge_V1_2 is ZapBaseV1 {
787     IRootChainManager public rootChainManager;
788     IDepositManager public depositManager;
789 
790     address
791         private constant maticAddress = 0x7D1AfA7B718fb893dB30A3aBc0Cfc608AaCfeBB0;
792 
793     constructor(uint256 _goodwill, uint256 _affiliateSplit)
794         public
795         ZapBaseV1(_goodwill, _affiliateSplit)
796     {
797         rootChainManager = IRootChainManager(
798             0xA0c68C638235ee32657e8f720a23ceC1bFc77C77
799         );
800         depositManager = IDepositManager(
801             0x401F6c983eA34274ec46f84D70b31C151321188b
802         );
803         IERC20(maticAddress).approve(address(depositManager), uint256(-1));
804     }
805 
806     /**
807     @notice Bridge from Ethereum to Matic
808     @notice Use index 0 for primary swap and index 1 for matic swap
809     @param fromToken Address of the token to swap from
810     @param toToken Address of the token to bridge
811     @param swapAmounts Quantites of fromToken to swap to toToken and matic
812     @param minTokensRec Minimum acceptable quantity of swapped tokens and/or matic
813     @param swapTargets Execution targets for swaps
814     @param swapData DEX swap data
815     @param affiliate Affiliate address
816     */
817     function ZapBridge(
818         address fromToken,
819         address toToken,
820         uint256[2] calldata swapAmounts,
821         uint256[2] calldata minTokensRec,
822         address[2] calldata swapTargets,
823         bytes[2] calldata swapData,
824         address affiliate
825     ) external payable {
826         uint256[2] memory toInvest = _pullTokens(
827             fromToken,
828             swapAmounts,
829             affiliate
830         );
831 
832         if (swapAmounts[0] > 0) {
833             // Token swap
834             uint256 toTokenAmt = _fillQuote(
835                 fromToken,
836                 toInvest[0],
837                 toToken,
838                 swapTargets[0],
839                 swapData[0]
840             );
841             require(toTokenAmt >= minTokensRec[0], "ERR: High Slippage 1");
842 
843             _bridgeToken(toToken, toTokenAmt);
844         }
845 
846         // Matic swap
847         if (swapAmounts[1] > 0) {
848             uint256 maticAmount = _fillQuote(
849                 fromToken,
850                 toInvest[1],
851                 maticAddress,
852                 swapTargets[1],
853                 swapData[1]
854             );
855             require(maticAmount >= minTokensRec[1], "ERR: High Slippage 2");
856 
857             _bridgeMatic(maticAmount);
858         }
859     }
860 
861     function _bridgeToken(address toToken, uint256 toTokenAmt) internal {
862         if (toToken == address(0)) {
863             rootChainManager.depositEtherFor.value(toTokenAmt)(msg.sender);
864         } else {
865             bytes32 tokenType = rootChainManager.tokenToType(toToken);
866             address predicate = rootChainManager.typeToPredicate(tokenType);
867             _approveToken(toToken, predicate);
868             rootChainManager.depositFor(
869                 msg.sender,
870                 toToken,
871                 abi.encode(toTokenAmt)
872             );
873         }
874     }
875 
876     function _bridgeMatic(uint256 maticAmount) internal {
877         depositManager.depositERC20ForUser(
878             maticAddress,
879             msg.sender,
880             maticAmount
881         );
882     }
883 
884     // 0x Swap
885     function _fillQuote(
886         address fromToken,
887         uint256 amount,
888         address toToken,
889         address swapTarget,
890         bytes memory swapCallData
891     ) internal returns (uint256 amtBought) {
892         uint256 valueToSend;
893 
894         if (fromToken == toToken) {
895             return amount;
896         }
897 
898         if (fromToken == address(0)) {
899             valueToSend = amount;
900         } else {
901             _approveToken(fromToken, swapTarget);
902         }
903 
904         uint256 iniBal = _getBalance(toToken);
905         (bool success, ) = swapTarget.call.value(valueToSend)(swapCallData);
906         require(success, "Error Swapping Tokens");
907         uint256 finalBal = _getBalance(toToken);
908 
909         amtBought = finalBal.sub(iniBal);
910     }
911 
912     function _pullTokens(
913         address fromToken,
914         uint256[2] memory swapAmounts,
915         address affiliate
916     ) internal returns (uint256[2] memory toInvest) {
917         if (fromToken == address(0)) {
918             require(msg.value > 0, "No eth sent");
919             require(
920                 swapAmounts[0].add(swapAmounts[1]) == msg.value,
921                 "msg.value != fromTokenAmounts"
922             );
923         } else {
924             require(msg.value == 0, "Eth sent with token");
925 
926             // transfer token
927             IERC20(fromToken).safeTransferFrom(
928                 msg.sender,
929                 address(this),
930                 swapAmounts[0].add(swapAmounts[1])
931             );
932         }
933 
934         if (swapAmounts[0] > 0) {
935             toInvest[0] = swapAmounts[0].sub(
936                 _subtractGoodwill(fromToken, swapAmounts[0], affiliate)
937             );
938         }
939 
940         if (swapAmounts[1] > 0) {
941             toInvest[1] = swapAmounts[1].sub(
942                 _subtractGoodwill(fromToken, swapAmounts[1], affiliate)
943             );
944         }
945     }
946 
947     function _subtractGoodwill(
948         address token,
949         uint256 amount,
950         address affiliate
951     ) internal returns (uint256 totalGoodwillPortion) {
952         bool whitelisted = feeWhitelist[msg.sender];
953         if (!whitelisted && goodwill > 0) {
954             totalGoodwillPortion = SafeMath.div(
955                 SafeMath.mul(amount, goodwill),
956                 10000
957             );
958 
959             if (affiliates[affiliate]) {
960                 if (token == address(0)) {
961                     token = ETHAddress;
962                 }
963 
964                 uint256 affiliatePortion = totalGoodwillPortion
965                     .mul(affiliateSplit)
966                     .div(100);
967                 affiliateBalance[affiliate][token] = affiliateBalance[affiliate][token]
968                     .add(affiliatePortion);
969                 totalAffiliateBalance[token] = totalAffiliateBalance[token].add(
970                     affiliatePortion
971                 );
972             }
973         }
974     }
975 }