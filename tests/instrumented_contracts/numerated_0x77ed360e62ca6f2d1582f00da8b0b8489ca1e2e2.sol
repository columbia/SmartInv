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
23 // File: contracts/oz/GSN/Context.sol
24 
25 pragma solidity ^0.5.0;
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
53 
54 // File: contracts/oz/ownership/Ownable.sol
55 
56 pragma solidity ^0.5.0;
57 
58 /**
59  * @dev Contract module which provides a basic access control mechanism, where
60  * there is an account (an owner) that can be granted exclusive access to
61  * specific functions.
62  *
63  * This module is used through inheritance. It will make available the modifier
64  * `onlyOwner`, which can be applied to your functions to restrict their use to
65  * the owner.
66  */
67 contract Ownable is Context {
68     address private _owner;
69 
70     event OwnershipTransferred(
71         address indexed previousOwner,
72         address indexed newOwner
73     );
74 
75     /**
76      * @dev Initializes the contract setting the deployer as the initial owner.
77      */
78     constructor() internal {
79         address msgSender = _msgSender();
80         _owner = msgSender;
81         emit OwnershipTransferred(address(0), msgSender);
82     }
83 
84     /**
85      * @dev Returns the address of the current owner.
86      */
87     function owner() public view returns (address) {
88         return _owner;
89     }
90 
91     /**
92      * @dev Throws if called by any account other than the owner.
93      */
94     modifier onlyOwner() {
95         require(isOwner(), "Ownable: caller is not the owner");
96         _;
97     }
98 
99     /**
100      * @dev Returns true if the caller is the current owner.
101      */
102     function isOwner() public view returns (bool) {
103         return _msgSender() == _owner;
104     }
105 
106     /**
107      * @dev Leaves the contract without owner. It will not be possible to call
108      * `onlyOwner` functions anymore. Can only be called by the current owner.
109      *
110      * NOTE: Renouncing ownership will leave the contract without an owner,
111      * thereby removing any functionality that is only available to the owner.
112      */
113     function renounceOwnership() public onlyOwner {
114         emit OwnershipTransferred(_owner, address(0));
115         _owner = address(0);
116     }
117 
118     /**
119      * @dev Transfers ownership of the contract to a new account (`newOwner`).
120      * Can only be called by the current owner.
121      */
122     function transferOwnership(address newOwner) public onlyOwner {
123         _transferOwnership(newOwner);
124     }
125 
126     /**
127      * @dev Transfers ownership of the contract to a new account (`newOwner`).
128      */
129     function _transferOwnership(address newOwner) internal {
130         require(
131             newOwner != address(0),
132             "Ownable: new owner is the zero address"
133         );
134         emit OwnershipTransferred(_owner, newOwner);
135         _owner = newOwner;
136     }
137 }
138 
139 // File: contracts/oz/token/ERC20/IERC20.sol
140 
141 pragma solidity ^0.5.0;
142 
143 /**
144  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
145  * the optional functions; to access them see {ERC20Detailed}.
146  */
147 interface IERC20 {
148     function decimals() external view returns (uint8);
149 
150     /**
151      * @dev Returns the amount of tokens in existence.
152      */
153     function totalSupply() external view returns (uint256);
154 
155     /**
156      * @dev Returns the amount of tokens owned by `account`.
157      */
158     function balanceOf(address account) external view returns (uint256);
159 
160     /**
161      * @dev Moves `amount` tokens from the caller's account to `recipient`.
162      *
163      * Returns a boolean value indicating whether the operation succeeded.
164      *
165      * Emits a {Transfer} event.
166      */
167     function transfer(address recipient, uint256 amount)
168         external
169         returns (bool);
170 
171     /**
172      * @dev Returns the remaining number of tokens that `spender` will be
173      * allowed to spend on behalf of `owner` through {transferFrom}. This is
174      * zero by default.
175      *
176      * This value changes when {approve} or {transferFrom} are called.
177      */
178     function allowance(address owner, address spender)
179         external
180         view
181         returns (uint256);
182 
183     /**
184      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
185      *
186      * Returns a boolean value indicating whether the operation succeeded.
187      *
188      * IMPORTANT: Beware that changing an allowance with this method brings the risk
189      * that someone may use both the old and the new allowance by unfortunate
190      * transaction ordering. One possible solution to mitigate this race
191      * condition is to first reduce the spender's allowance to 0 and set the
192      * desired value afterwards:
193      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
194      *
195      * Emits an {Approval} event.
196      */
197     function approve(address spender, uint256 amount) external returns (bool);
198 
199     /**
200      * @dev Moves `amount` tokens from `sender` to `recipient` using the
201      * allowance mechanism. `amount` is then deducted from the caller's
202      * allowance.
203      *
204      * Returns a boolean value indicating whether the operation succeeded.
205      *
206      * Emits a {Transfer} event.
207      */
208     function transferFrom(
209         address sender,
210         address recipient,
211         uint256 amount
212     ) external returns (bool);
213 
214     /**
215      * @dev Emitted when `value` tokens are moved from one account (`from`) to
216      * another (`to`).
217      *
218      * Note that `value` may be zero.
219      */
220     event Transfer(address indexed from, address indexed to, uint256 value);
221 
222     /**
223      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
224      * a call to {approve}. `value` is the new allowance.
225      */
226     event Approval(
227         address indexed owner,
228         address indexed spender,
229         uint256 value
230     );
231 }
232 
233 // File: contracts/oz/math/SafeMath.sol
234 
235 pragma solidity ^0.5.0;
236 
237 /**
238  * @dev Wrappers over Solidity's arithmetic operations with added overflow
239  * checks.
240  *
241  * Arithmetic operations in Solidity wrap on overflow. This can easily result
242  * in bugs, because programmers usually assume that an overflow raises an
243  * error, which is the standard behavior in high level programming languages.
244  * `SafeMath` restores this intuition by reverting the transaction when an
245  * operation overflows.
246  *
247  * Using this library instead of the unchecked operations eliminates an entire
248  * class of bugs, so it's recommended to use it always.
249  */
250 library SafeMath {
251     /**
252      * @dev Returns the addition of two unsigned integers, reverting on
253      * overflow.
254      *
255      * Counterpart to Solidity's `+` operator.
256      *
257      * Requirements:
258      * - Addition cannot overflow.
259      */
260     function add(uint256 a, uint256 b) internal pure returns (uint256) {
261         uint256 c = a + b;
262         require(c >= a, "SafeMath: addition overflow");
263 
264         return c;
265     }
266 
267     /**
268      * @dev Returns the subtraction of two unsigned integers, reverting on
269      * overflow (when the result is negative).
270      *
271      * Counterpart to Solidity's `-` operator.
272      *
273      * Requirements:
274      * - Subtraction cannot overflow.
275      */
276     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
277         return sub(a, b, "SafeMath: subtraction overflow");
278     }
279 
280     /**
281      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
282      * overflow (when the result is negative).
283      *
284      * Counterpart to Solidity's `-` operator.
285      *
286      * Requirements:
287      * - Subtraction cannot overflow.
288      *
289      * _Available since v2.4.0._
290      */
291     function sub(
292         uint256 a,
293         uint256 b,
294         string memory errorMessage
295     ) internal pure returns (uint256) {
296         require(b <= a, errorMessage);
297         uint256 c = a - b;
298 
299         return c;
300     }
301 
302     /**
303      * @dev Returns the multiplication of two unsigned integers, reverting on
304      * overflow.
305      *
306      * Counterpart to Solidity's `*` operator.
307      *
308      * Requirements:
309      * - Multiplication cannot overflow.
310      */
311     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
312         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
313         // benefit is lost if 'b' is also tested.
314         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
315         if (a == 0) {
316             return 0;
317         }
318 
319         uint256 c = a * b;
320         require(c / a == b, "SafeMath: multiplication overflow");
321 
322         return c;
323     }
324 
325     /**
326      * @dev Returns the integer division of two unsigned integers. Reverts on
327      * division by zero. The result is rounded towards zero.
328      *
329      * Counterpart to Solidity's `/` operator. Note: this function uses a
330      * `revert` opcode (which leaves remaining gas untouched) while Solidity
331      * uses an invalid opcode to revert (consuming all remaining gas).
332      *
333      * Requirements:
334      * - The divisor cannot be zero.
335      */
336     function div(uint256 a, uint256 b) internal pure returns (uint256) {
337         return div(a, b, "SafeMath: division by zero");
338     }
339 
340     /**
341      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
342      * division by zero. The result is rounded towards zero.
343      *
344      * Counterpart to Solidity's `/` operator. Note: this function uses a
345      * `revert` opcode (which leaves remaining gas untouched) while Solidity
346      * uses an invalid opcode to revert (consuming all remaining gas).
347      *
348      * Requirements:
349      * - The divisor cannot be zero.
350      *
351      * _Available since v2.4.0._
352      */
353     function div(
354         uint256 a,
355         uint256 b,
356         string memory errorMessage
357     ) internal pure returns (uint256) {
358         // Solidity only automatically asserts when dividing by 0
359         require(b > 0, errorMessage);
360         uint256 c = a / b;
361         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
362 
363         return c;
364     }
365 
366     /**
367      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
368      * Reverts when dividing by zero.
369      *
370      * Counterpart to Solidity's `%` operator. This function uses a `revert`
371      * opcode (which leaves remaining gas untouched) while Solidity uses an
372      * invalid opcode to revert (consuming all remaining gas).
373      *
374      * Requirements:
375      * - The divisor cannot be zero.
376      */
377     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
378         return mod(a, b, "SafeMath: modulo by zero");
379     }
380 
381     /**
382      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
383      * Reverts with custom message when dividing by zero.
384      *
385      * Counterpart to Solidity's `%` operator. This function uses a `revert`
386      * opcode (which leaves remaining gas untouched) while Solidity uses an
387      * invalid opcode to revert (consuming all remaining gas).
388      *
389      * Requirements:
390      * - The divisor cannot be zero.
391      *
392      * _Available since v2.4.0._
393      */
394     function mod(
395         uint256 a,
396         uint256 b,
397         string memory errorMessage
398     ) internal pure returns (uint256) {
399         require(b != 0, errorMessage);
400         return a % b;
401     }
402 }
403 
404 // File: contracts/oz/utils/Address.sol
405 
406 pragma solidity ^0.5.5;
407 
408 /**
409  * @dev Collection of functions related to the address type
410  */
411 library Address {
412     /**
413      * @dev Returns true if `account` is a contract.
414      *
415      * [IMPORTANT]
416      * ====
417      * It is unsafe to assume that an address for which this function returns
418      * false is an externally-owned account (EOA) and not a contract.
419      *
420      * Among others, `isContract` will return false for the following
421      * types of addresses:
422      *
423      *  - an externally-owned account
424      *  - a contract in construction
425      *  - an address where a contract will be created
426      *  - an address where a contract lived, but was destroyed
427      * ====
428      */
429     function isContract(address account) internal view returns (bool) {
430         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
431         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
432         // for accounts without code, i.e. `keccak256('')`
433         bytes32 codehash;
434 
435 
436             bytes32 accountHash
437          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
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
556         uint256 newAllowance = token.allowance(address(this), spender).add(
557             value
558         );
559         callOptionalReturn(
560             token,
561             abi.encodeWithSelector(
562                 token.approve.selector,
563                 spender,
564                 newAllowance
565             )
566         );
567     }
568 
569     function safeDecreaseAllowance(
570         IERC20 token,
571         address spender,
572         uint256 value
573     ) internal {
574         uint256 newAllowance = token.allowance(address(this), spender).sub(
575             value,
576             "SafeERC20: decreased allowance below zero"
577         );
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
642     address
643         internal constant ETHAddress = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
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
819                 uint256 affiliatePortion = totalGoodwillPortion
820                     .mul(affiliateSplit)
821                     .div(100);
822                 affiliateBalance[affiliate][token] = affiliateBalance[affiliate][token]
823                     .add(affiliatePortion);
824                 totalAffiliateBalance[token] = totalAffiliateBalance[token].add(
825                     affiliatePortion
826                 );
827             }
828         }
829     }
830 }
831 
832 // File: contracts/Curve/Curve_ZapIn_General_V3.sol
833 
834 pragma solidity ^0.5.7;
835 
836 interface ICurveSwap {
837     function coins(int128 arg0) external view returns (address);
838 
839     function underlying_coins(int128 arg0) external view returns (address);
840 
841     function add_liquidity(uint256[4] calldata amounts, uint256 min_mint_amount)
842         external;
843 
844     function add_liquidity(
845         uint256[4] calldata amounts,
846         uint256 min_mint_amount,
847         bool addUnderlying
848     ) external;
849 
850     function add_liquidity(uint256[3] calldata amounts, uint256 min_mint_amount)
851         external;
852 
853     function add_liquidity(
854         uint256[3] calldata amounts,
855         uint256 min_mint_amount,
856         bool addUnderlying
857     ) external;
858 
859     function add_liquidity(uint256[2] calldata amounts, uint256 min_mint_amount)
860         external;
861 
862     function add_liquidity(
863         uint256[2] calldata amounts,
864         uint256 min_mint_amount,
865         bool addUnderlying
866     ) external;
867 }
868 
869 interface ICurveEthSwap {
870     function add_liquidity(uint256[2] calldata amounts, uint256 min_mint_amount)
871         external
872         payable
873         returns (uint256);
874 }
875 
876 interface ICurveRegistry {
877     function getSwapAddress(address tokenAddress)
878         external
879         view
880         returns (address swapAddress);
881 
882     function getTokenAddress(address swapAddress)
883         external
884         view
885         returns (address tokenAddress);
886 
887     function getDepositAddress(address swapAddress)
888         external
889         view
890         returns (address depositAddress);
891 
892     function getPoolTokens(address swapAddress)
893         external
894         view
895         returns (address[4] memory poolTokens);
896 
897     function shouldAddUnderlying(address swapAddress)
898         external
899         view
900         returns (bool);
901 
902     function getNumTokens(address swapAddress)
903         external
904         view
905         returns (uint8 numTokens);
906 
907     function isBtcPool(address swapAddress) external view returns (bool);
908 
909     function isEthPool(address swapAddress) external view returns (bool);
910 
911     function isUnderlyingToken(
912         address swapAddress,
913         address tokenContractAddress
914     ) external view returns (bool, uint8);
915 }
916 
917 contract Curve_ZapIn_General_V3_1_1 is ZapInBaseV1 {
918     ICurveRegistry public curveReg;
919 
920     constructor(
921         ICurveRegistry _curveRegistry,
922         uint16 _goodwill,
923         uint16 _affiliateSplit
924     ) public ZapBaseV1(_goodwill, _affiliateSplit) {
925         curveReg = _curveRegistry;
926         goodwill = _goodwill;
927         affiliateSplit = _affiliateSplit;
928     }
929 
930     event zapIn(address sender, address pool, uint256 tokensRec);
931 
932     /**
933     @notice This function adds liquidity to a Curve pool with ETH or ERC20 tokens
934     @param _fromTokenAddress The token used for entry (address(0) if ether)
935     @param _toTokenAddress The intermediate ERC20 token to swap to
936     @param _swapAddress Curve swap address for the pool
937     @param _incomingTokenQty The amount of fromToken to invest
938     @param _minPoolTokens The minimum acceptable quantity of Curve LP to receive. Reverts otherwise
939     @param _swapTarget Excecution target for the first swap
940     @param _swapCallData DEX quote data
941     @param affiliate Affiliate address
942     @return crvTokensBought- Quantity of Curve LP tokens received
943      */
944     function ZapIn(
945         address _fromTokenAddress,
946         address _toTokenAddress,
947         address _swapAddress,
948         uint256 _incomingTokenQty,
949         uint256 _minPoolTokens,
950         address _swapTarget,
951         bytes calldata _swapCallData,
952         address affiliate
953     ) external payable stopInEmergency returns (uint256 crvTokensBought) {
954         uint256 toInvest = _pullTokens(
955             _fromTokenAddress,
956             _incomingTokenQty,
957             affiliate
958         );
959         if (_fromTokenAddress == address(0)) {
960             _fromTokenAddress = ETHAddress;
961         }
962 
963         // perform zapIn
964         crvTokensBought = _performZapIn(
965             _fromTokenAddress,
966             _toTokenAddress,
967             _swapAddress,
968             toInvest,
969             _swapTarget,
970             _swapCallData
971         );
972 
973         require(
974             crvTokensBought > _minPoolTokens,
975             "Received less than minPoolTokens"
976         );
977 
978         address poolTokenAddress = curveReg.getTokenAddress(_swapAddress);
979 
980         emit zapIn(msg.sender, poolTokenAddress, crvTokensBought);
981 
982         IERC20(poolTokenAddress).transfer(msg.sender, crvTokensBought);
983     }
984 
985     function _performZapIn(
986         address _fromTokenAddress,
987         address _toTokenAddress,
988         address _swapAddress,
989         uint256 toInvest,
990         address _swapTarget,
991         bytes memory _swapCallData
992     ) internal returns (uint256 crvTokensBought) {
993         (bool isUnderlying, uint8 underlyingIndex) = curveReg.isUnderlyingToken(
994             _swapAddress,
995             _fromTokenAddress
996         );
997 
998         if (isUnderlying) {
999             crvTokensBought = _enterCurve(
1000                 _swapAddress,
1001                 toInvest,
1002                 underlyingIndex
1003             );
1004         } else {
1005             //swap tokens using 0x swap
1006             uint256 tokensBought = _fillQuote(
1007                 _fromTokenAddress,
1008                 _toTokenAddress,
1009                 toInvest,
1010                 _swapTarget,
1011                 _swapCallData
1012             );
1013             if (_toTokenAddress == address(0)) _toTokenAddress = ETHAddress;
1014 
1015             //get underlying token index
1016             (isUnderlying, underlyingIndex) = curveReg.isUnderlyingToken(
1017                 _swapAddress,
1018                 _toTokenAddress
1019             );
1020 
1021             if (isUnderlying) {
1022                 crvTokensBought = _enterCurve(
1023                     _swapAddress,
1024                     tokensBought,
1025                     underlyingIndex
1026                 );
1027             } else {
1028                 (uint256 tokens, uint8 metaIndex) = _enterMetaPool(
1029                     _swapAddress,
1030                     _toTokenAddress,
1031                     tokensBought
1032                 );
1033 
1034                 crvTokensBought = _enterCurve(_swapAddress, tokens, metaIndex);
1035             }
1036         }
1037     }
1038 
1039     function _pullTokens(
1040         address token,
1041         uint256 amount,
1042         address affiliate
1043     ) internal returns (uint256) {
1044         uint256 totalGoodwillPortion;
1045 
1046         if (token == address(0)) {
1047             require(msg.value > 0, "No eth sent");
1048 
1049             // subtract goodwill
1050             totalGoodwillPortion = _subtractGoodwill(
1051                 ETHAddress,
1052                 msg.value,
1053                 affiliate
1054             );
1055 
1056             return msg.value.sub(totalGoodwillPortion);
1057         }
1058         require(amount > 0, "Invalid token amount");
1059         require(msg.value == 0, "Eth sent with token");
1060 
1061         //transfer token
1062         IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
1063 
1064         // subtract goodwill
1065         totalGoodwillPortion = _subtractGoodwill(token, amount, affiliate);
1066 
1067         return amount.sub(totalGoodwillPortion);
1068     }
1069 
1070     function _subtractGoodwill(
1071         address token,
1072         uint256 amount,
1073         address affiliate
1074     ) internal returns (uint256 totalGoodwillPortion) {
1075         bool whitelisted = feeWhitelist[msg.sender];
1076         if (!whitelisted && goodwill > 0) {
1077             totalGoodwillPortion = SafeMath.div(
1078                 SafeMath.mul(amount, goodwill),
1079                 10000
1080             );
1081 
1082             if (affiliates[affiliate]) {
1083                 uint256 affiliatePortion = totalGoodwillPortion
1084                     .mul(affiliateSplit)
1085                     .div(100);
1086                 affiliateBalance[affiliate][token] = affiliateBalance[affiliate][token]
1087                     .add(affiliatePortion);
1088                 totalAffiliateBalance[token] = totalAffiliateBalance[token].add(
1089                     affiliatePortion
1090                 );
1091             }
1092         }
1093     }
1094 
1095     /**
1096     @notice This function gets adds the liquidity for meta pools and returns the token index and swap tokens
1097     @param _swapAddress Curve swap address for the pool
1098     @param _toTokenAddress The ERC20 token to which from token to be convert
1099     @param  swapTokens amount of toTokens to invest
1100     @return tokensBought- quantity of curve LP acquired
1101     @return index- index of LP token in _swapAddress whose pool tokens were acquired
1102      */
1103     function _enterMetaPool(
1104         address _swapAddress,
1105         address _toTokenAddress,
1106         uint256 swapTokens
1107     ) internal returns (uint256 tokensBought, uint8 index) {
1108         address[4] memory poolTokens = curveReg.getPoolTokens(_swapAddress);
1109         for (uint8 i = 0; i < 4; i++) {
1110             address intermediateSwapAddress = curveReg.getSwapAddress(
1111                 poolTokens[i]
1112             );
1113             if (intermediateSwapAddress != address(0)) {
1114                 (, index) = curveReg.isUnderlyingToken(
1115                     intermediateSwapAddress,
1116                     _toTokenAddress
1117                 );
1118 
1119                 tokensBought = _enterCurve(
1120                     intermediateSwapAddress,
1121                     swapTokens,
1122                     index
1123                 );
1124 
1125                 return (tokensBought, i);
1126             }
1127         }
1128     }
1129 
1130     function _fillQuote(
1131         address _fromTokenAddress,
1132         address _toTokenAddress,
1133         uint256 _amount,
1134         address _swapTarget,
1135         bytes memory _swapCallData
1136     ) internal returns (uint256 amountBought) {
1137         uint256 valueToSend;
1138 
1139         if (_fromTokenAddress == _toTokenAddress) {
1140             return _amount;
1141         }
1142         if (_fromTokenAddress == ETHAddress) {
1143             valueToSend = _amount;
1144         } else {
1145             IERC20 fromToken = IERC20(_fromTokenAddress);
1146 
1147             require(
1148                 fromToken.balanceOf(address(this)) >= _amount,
1149                 "Insufficient Balance"
1150             );
1151 
1152             _approveToken(address(fromToken), _swapTarget);
1153         }
1154 
1155         uint256 initialBalance = _toTokenAddress == address(0)
1156             ? address(this).balance
1157             : IERC20(_toTokenAddress).balanceOf(address(this));
1158 
1159         (bool success, ) = _swapTarget.call.value(valueToSend)(_swapCallData);
1160         require(success, "Error Swapping Tokens");
1161 
1162         amountBought = _toTokenAddress == address(0)
1163             ? (address(this).balance).sub(initialBalance)
1164             : IERC20(_toTokenAddress).balanceOf(address(this)).sub(
1165                 initialBalance
1166             );
1167 
1168         require(amountBought > 0, "Swapped To Invalid Intermediate");
1169     }
1170 
1171     /**
1172     @notice This function adds liquidity to a curve pool
1173     @param _swapAddress Curve swap address for the pool
1174     @param amount The quantity of tokens being added as liquidity
1175     @param index The token index for the add_liquidity call
1176     @return crvTokensBought- the quantity of curve LP tokens received
1177     */
1178     function _enterCurve(
1179         address _swapAddress,
1180         uint256 amount,
1181         uint8 index
1182     ) internal returns (uint256 crvTokensBought) {
1183         address tokenAddress = curveReg.getTokenAddress(_swapAddress);
1184         address depositAddress = curveReg.getDepositAddress(_swapAddress);
1185         uint256 initialBalance = IERC20(tokenAddress).balanceOf(address(this));
1186         address entryToken = curveReg.getPoolTokens(_swapAddress)[index];
1187         if (entryToken != ETHAddress) {
1188             IERC20(entryToken).safeIncreaseAllowance(
1189                 address(depositAddress),
1190                 amount
1191             );
1192         }
1193 
1194         uint256 numTokens = curveReg.getNumTokens(_swapAddress);
1195         bool addUnderlying = curveReg.shouldAddUnderlying(_swapAddress);
1196 
1197         if (numTokens == 4) {
1198             uint256[4] memory amounts;
1199             amounts[index] = amount;
1200             if (addUnderlying) {
1201                 ICurveSwap(depositAddress).add_liquidity(amounts, 0, true);
1202             } else {
1203                 ICurveSwap(depositAddress).add_liquidity(amounts, 0);
1204             }
1205         } else if (numTokens == 3) {
1206             uint256[3] memory amounts;
1207             amounts[index] = amount;
1208             if (addUnderlying) {
1209                 ICurveSwap(depositAddress).add_liquidity(amounts, 0, true);
1210             } else {
1211                 ICurveSwap(depositAddress).add_liquidity(amounts, 0);
1212             }
1213         } else {
1214             uint256[2] memory amounts;
1215             amounts[index] = amount;
1216             if (curveReg.isEthPool(depositAddress)) {
1217                 ICurveEthSwap(depositAddress).add_liquidity.value(amount)(
1218                     amounts,
1219                     0
1220                 );
1221             } else if (addUnderlying) {
1222                 ICurveSwap(depositAddress).add_liquidity(amounts, 0, true);
1223             } else {
1224                 ICurveSwap(depositAddress).add_liquidity(amounts, 0);
1225             }
1226         }
1227         crvTokensBought = (IERC20(tokenAddress).balanceOf(address(this))).sub(
1228             initialBalance
1229         );
1230     }
1231 
1232     function updateCurveRegistry(ICurveRegistry newCurveRegistry)
1233         external
1234         onlyOwner
1235     {
1236         require(newCurveRegistry != curveReg, "Already using this Registry");
1237         curveReg = newCurveRegistry;
1238     }
1239 }