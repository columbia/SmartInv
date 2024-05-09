1 // File: contracts/IWoofpackNFTToken.sol
2 // SPDX-License-Identifier: MIT
3 
4 
5 pragma experimental ABIEncoderV2;
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Required interface of an ERC721 compliant contract.
11  */
12 interface IWoofpackNFTToken {
13     /**
14      * @dev Returns the number of tokens in ``owner``'s account.
15      */
16     function balanceOf(address owner) external view returns (uint256 balance);
17  
18     function transferOwnership(address newOwner) external;
19     function renounceMinter() external;
20 
21     /**
22      * @dev Returns the owner of the `tokenId` token.
23      *
24      * Requirements:
25      *
26      * - `tokenId` must exist.
27      */
28     function ownerOf(uint256 tokenId) external view returns (address owner);
29 
30     function mint(address recipient, uint256 mintAmount) external returns (bool);
31 }
32 
33 // File: @openzeppelin/contracts/utils/Context.sol
34 
35 
36 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
37 
38 pragma solidity ^0.8.0;
39 
40 /**
41  * @dev Provides information about the current execution context, including the
42  * sender of the transaction and its data. While these are generally available
43  * via msg.sender and msg.data, they should not be accessed in such a direct
44  * manner, since when dealing with meta-transactions the account sending and
45  * paying for execution may not be the actual sender (as far as an application
46  * is concerned).
47  *
48  * This contract is only required for intermediate, library-like contracts.
49  */
50 abstract contract Context {
51     function _msgSender() internal view virtual returns (address) {
52         return msg.sender;
53     }
54 
55     function _msgData() internal view virtual returns (bytes calldata) {
56         return msg.data;
57     }
58 }
59 
60 // File: @openzeppelin/contracts/access/Ownable.sol
61 
62 
63 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
64 
65 pragma solidity ^0.8.0;
66 
67 
68 /**
69  * @dev Contract module which provides a basic access control mechanism, where
70  * there is an account (an owner) that can be granted exclusive access to
71  * specific functions.
72  *
73  * By default, the owner account will be the one that deploys the contract. This
74  * can later be changed with {transferOwnership}.
75  *
76  * This module is used through inheritance. It will make available the modifier
77  * `onlyOwner`, which can be applied to your functions to restrict their use to
78  * the owner.
79  */
80 abstract contract Ownable is Context {
81     address private _owner;
82 
83     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
84 
85     /**
86      * @dev Initializes the contract setting the deployer as the initial owner.
87      */
88     constructor() {
89         _transferOwnership(_msgSender());
90     }
91 
92     /**
93      * @dev Returns the address of the current owner.
94      */
95     function owner() public view virtual returns (address) {
96         return _owner;
97     }
98 
99     /**
100      * @dev Throws if called by any account other than the owner.
101      */
102     modifier onlyOwner() {
103         require(owner() == _msgSender(), "Ownable: caller is not the owner");
104         _;
105     }
106 
107     /**
108      * @dev Leaves the contract without owner. It will not be possible to call
109      * `onlyOwner` functions anymore. Can only be called by the current owner.
110      *
111      * NOTE: Renouncing ownership will leave the contract without an owner,
112      * thereby removing any functionality that is only available to the owner.
113      */
114     function renounceOwnership() public virtual onlyOwner {
115         _transferOwnership(address(0));
116     }
117 
118     /**
119      * @dev Transfers ownership of the contract to a new account (`newOwner`).
120      * Can only be called by the current owner.
121      */
122     function transferOwnership(address newOwner) public virtual onlyOwner {
123         require(newOwner != address(0), "Ownable: new owner is the zero address");
124         _transferOwnership(newOwner);
125     }
126 
127     /**
128      * @dev Transfers ownership of the contract to a new account (`newOwner`).
129      * Internal function without access restriction.
130      */
131     function _transferOwnership(address newOwner) internal virtual {
132         address oldOwner = _owner;
133         _owner = newOwner;
134         emit OwnershipTransferred(oldOwner, newOwner);
135     }
136 }
137 
138 // File: contracts/utils/SafeMath.sol
139 
140 
141 
142 pragma solidity ^0.8.0;
143 
144 // CAUTION
145 // This version of SafeMath should only be used with Solidity 0.8 or later,
146 // because it relies on the compiler's built in overflow checks.
147 
148 /**
149  * @dev Wrappers over Solidity's arithmetic operations.
150  *
151  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
152  * now has built in overflow checking.
153  */
154 library SafeMath {
155     /**
156      * @dev Returns the addition of two unsigned integers, with an overflow flag.
157      *
158      * _Available since v3.4._
159      */
160     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
161             uint256 c = a + b;
162             if (c < a) return (false, 0);
163             return (true, c);
164     }
165 
166     /**
167      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
168      *
169      * _Available since v3.4._
170      */
171     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
172             if (b > a) return (false, 0);
173             return (true, a - b);
174     }
175 
176     /**
177      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
178      *
179      * _Available since v3.4._
180      */
181     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
182             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
183             // benefit is lost if 'b' is also tested.
184             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
185             if (a == 0) return (true, 0);
186             uint256 c = a * b;
187             if (c / a != b) return (false, 0);
188             return (true, c);
189     }
190 
191     /**
192      * @dev Returns the division of two unsigned integers, with a division by zero flag.
193      *
194      * _Available since v3.4._
195      */
196     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
197             if (b == 0) return (false, 0);
198             return (true, a / b);
199     }
200 
201     /**
202      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
203      *
204      * _Available since v3.4._
205      */
206     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
207             if (b == 0) return (false, 0);
208             return (true, a % b);
209     }
210 
211     /**
212      * @dev Returns the addition of two unsigned integers, reverting on
213      * overflow.
214      *
215      * Counterpart to Solidity's `+` operator.
216      *
217      * Requirements:
218      *
219      * - Addition cannot overflow.
220      */
221     function add(uint256 a, uint256 b) internal pure returns (uint256) {
222         return a + b;
223     }
224 
225     /**
226      * @dev Returns the subtraction of two unsigned integers, reverting on
227      * overflow (when the result is negative).
228      *
229      * Counterpart to Solidity's `-` operator.
230      *
231      * Requirements:
232      *
233      * - Subtraction cannot overflow.
234      */
235     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
236         return a - b;
237     }
238 
239     /**
240      * @dev Returns the multiplication of two unsigned integers, reverting on
241      * overflow.
242      *
243      * Counterpart to Solidity's `*` operator.
244      *
245      * Requirements:
246      *
247      * - Multiplication cannot overflow.
248      */
249     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
250         return a * b;
251     }
252 
253     /**
254      * @dev Returns the integer division of two unsigned integers, reverting on
255      * division by zero. The result is rounded towards zero.
256      *
257      * Counterpart to Solidity's `/` operator.
258      *
259      * Requirements:
260      *
261      * - The divisor cannot be zero.
262      */
263     function div(uint256 a, uint256 b) internal pure returns (uint256) {
264         return a / b;
265     }
266 
267     /**
268      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
269      * reverting when dividing by zero.
270      *
271      * Counterpart to Solidity's `%` operator. This function uses a `revert`
272      * opcode (which leaves remaining gas untouched) while Solidity uses an
273      * invalid opcode to revert (consuming all remaining gas).
274      *
275      * Requirements:
276      *
277      * - The divisor cannot be zero.
278      */
279     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
280         return a % b;
281     }
282 
283     /**
284      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
285      * overflow (when the result is negative).
286      *
287      * CAUTION: This function is deprecated because it requires allocating memory for the error
288      * message unnecessarily. For custom revert reasons use {trySub}.
289      *
290      * Counterpart to Solidity's `-` operator.
291      *
292      * Requirements:
293      *
294      * - Subtraction cannot overflow.
295      */
296     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
297             require(b <= a, errorMessage);
298             return a - b;
299     }
300 
301     /**
302      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
303      * division by zero. The result is rounded towards zero.
304      *
305      * Counterpart to Solidity's `%` operator. This function uses a `revert`
306      * opcode (which leaves remaining gas untouched) while Solidity uses an
307      * invalid opcode to revert (consuming all remaining gas).
308      *
309      * Counterpart to Solidity's `/` operator. Note: this function uses a
310      * `revert` opcode (which leaves remaining gas untouched) while Solidity
311      * uses an invalid opcode to revert (consuming all remaining gas).
312      *
313      * Requirements:
314      *
315      * - The divisor cannot be zero.
316      */
317     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
318             require(b > 0, errorMessage);
319             return a / b;
320     }
321 
322     /**
323      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
324      * reverting with custom message when dividing by zero.
325      *
326      * CAUTION: This function is deprecated because it requires allocating memory for the error
327      * message unnecessarily. For custom revert reasons use {tryMod}.
328      *
329      * Counterpart to Solidity's `%` operator. This function uses a `revert`
330      * opcode (which leaves remaining gas untouched) while Solidity uses an
331      * invalid opcode to revert (consuming all remaining gas).
332      *
333      * Requirements:
334      *
335      * - The divisor cannot be zero.
336      */
337     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
338             require(b > 0, errorMessage);
339             return a % b;
340     }
341 }
342 
343 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
344 
345 
346 // OpenZeppelin Contracts v4.4.0 (security/ReentrancyGuard.sol)
347 
348 pragma solidity ^0.8.0;
349 
350 /**
351  * @dev Contract module that helps prevent reentrant calls to a function.
352  *
353  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
354  * available, which can be applied to functions to make sure there are no nested
355  * (reentrant) calls to them.
356  *
357  * Note that because there is a single `nonReentrant` guard, functions marked as
358  * `nonReentrant` may not call one another. This can be worked around by making
359  * those functions `private`, and then adding `external` `nonReentrant` entry
360  * points to them.
361  *
362  * TIP: If you would like to learn more about reentrancy and alternative ways
363  * to protect against it, check out our blog post
364  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
365  */
366 abstract contract ReentrancyGuard {
367     // Booleans are more expensive than uint256 or any type that takes up a full
368     // word because each write operation emits an extra SLOAD to first read the
369     // slot's contents, replace the bits taken up by the boolean, and then write
370     // back. This is the compiler's defense against contract upgrades and
371     // pointer aliasing, and it cannot be disabled.
372 
373     // The values being non-zero value makes deployment a bit more expensive,
374     // but in exchange the refund on every call to nonReentrant will be lower in
375     // amount. Since refunds are capped to a percentage of the total
376     // transaction's gas, it is best to keep them low in cases like this one, to
377     // increase the likelihood of the full refund coming into effect.
378     uint256 private constant _NOT_ENTERED = 1;
379     uint256 private constant _ENTERED = 2;
380 
381     uint256 private _status;
382 
383     constructor() {
384         _status = _NOT_ENTERED;
385     }
386 
387     /**
388      * @dev Prevents a contract from calling itself, directly or indirectly.
389      * Calling a `nonReentrant` function from another `nonReentrant`
390      * function is not supported. It is possible to prevent this from happening
391      * by making the `nonReentrant` function external, and making it call a
392      * `private` function that does the actual work.
393      */
394     modifier nonReentrant() {
395         // On the first call to nonReentrant, _notEntered will be true
396         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
397 
398         // Any calls to nonReentrant after this point will fail
399         _status = _ENTERED;
400 
401         _;
402 
403         // By storing the original value once again, a refund is triggered (see
404         // https://eips.ethereum.org/EIPS/eip-2200)
405         _status = _NOT_ENTERED;
406     }
407 }
408 
409 // File: contracts/crowdsale/Crowdsale.sol
410 
411 pragma solidity ^0.8.0;
412 
413 
414 
415 // import "@openzeppelin/contracts/utils/math/SafeMath.sol";
416 
417 
418 
419 /**
420  * @title Crowdsale
421  * @dev Crowdsale is a base contract for managing a token crowdsale,
422  * allowing investors to purchase tokens with ether. This contract implements
423  * such functionality in its most fundamental form and can be extended to provide additional
424  * functionality and/or custom behavior.
425  * The external interface represents the basic interface for purchasing tokens, and conforms
426  * the base architecture for crowdsales. It is *not* intended to be modified / overridden.
427  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
428  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
429  * behavior.
430  */
431 contract Crowdsale is Context, ReentrancyGuard  {
432     using SafeMath for uint256;
433 
434     // The token being sold
435     IWoofpackNFTToken private _token;
436 
437     // Amount of wei raised
438     uint256 private _weiRaised;
439 
440     // Address where funds are collected
441     address payable private _wallet;
442 
443     // Private Sale price is 0.06 ETH
444     uint256 internal _rate = 60000000000000000;
445 
446     /**
447      * Event for token purchase logging
448      * @param purchaser who paid for the tokens
449      * @param beneficiary who got the tokens
450      */
451     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 mintAmount);
452 
453     /**
454      * @param __wallet Address where collected funds will be forwarded to
455      * @param __token Address of the token being sold
456      */
457     constructor (address payable __wallet, IWoofpackNFTToken __token) public {
458         require(__wallet != address(0), "Crowdsale: wallet is the zero address");
459         require(address(__token) != address(0), "Crowdsale: token is the zero address");
460 
461         _wallet = __wallet;
462         _token = __token;
463     }
464 
465     /**
466      * @return the token being sold.
467      */
468     function token() public view virtual returns (IWoofpackNFTToken) {
469         return _token;
470     }
471 
472     /**
473      * @return the address where funds are collected.
474      */
475     function wallet() public view virtual returns (address payable) {
476         return _wallet;
477     }
478 
479     /**
480      * @return the number of token units a buyer gets per wei.
481      */
482     function rate() public view virtual returns (uint256) {
483         return _rate;
484     }
485 
486     /**
487      * @return the amount of wei raised.
488      */
489     function weiRaised() public view virtual returns (uint256) {
490         return _weiRaised;
491     }
492 
493     /**
494      * @dev low level token purchase ***DO NOT OVERRIDE***
495      * This function has a non-reentrancy guard, so it shouldn't be called by
496      * another `nonReentrant` function.
497      * @param beneficiary Recipient of the token purchase
498     **/
499     function buyNFT(address beneficiary, uint256 mintAmount) public nonReentrant payable {
500         uint256 weiAmount = msg.value;
501         _preValidatePurchase(beneficiary, mintAmount, weiAmount);
502 
503         // update state ETH Amount
504         _weiRaised = _weiRaised.add(weiAmount);
505 
506         _processPurchase(beneficiary, mintAmount);
507         emit TokensPurchased(_msgSender(), beneficiary, mintAmount);
508 
509         _updatePurchasingState(beneficiary, weiAmount);
510 
511         _forwardFunds(beneficiary, weiAmount);
512         _postValidatePurchase(beneficiary, weiAmount);
513     }
514 
515     /**
516      * @dev Override for extensions that require an internal state to check for validity (current user contributions,
517      * etc.)
518      * @param beneficiary Address receiving the tokens
519      * @param mintAmount total no of tokens to be minted
520      * @param weiAmount no of ETH sent
521      */
522     function _preValidatePurchase(address beneficiary, uint256 mintAmount, uint256 weiAmount) internal virtual {
523         // solhint-disable-previous-line no-empty-blocks
524     }
525 
526     /**
527      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
528      * tokens.
529      * @param beneficiary Address receiving the tokens
530      * @param mintAmount Total mint tokens
531      */
532     function _processPurchase(address beneficiary, uint256 mintAmount) internal virtual {
533         _deliverTokens(beneficiary, mintAmount);
534     }
535 
536     /**
537      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
538      * its tokens.
539      * @param beneficiary Address performing the token purchase
540      * @param mintAmount Total mint tokens
541      */
542     function _deliverTokens(address beneficiary, uint256 mintAmount) internal {
543          
544          /*********** COMMENTED REQUIRE BECAUSE IT WAS RETURNING BOOLEAN AND WE WERE LISTENING FROM THE INTERFACE THAT IT WILL RETURN BOOLEAN BUT IT REVERTS OUR TRANSACTION**************** */
545          // Potentially dangerous assumption about the type of the token.
546         require(
547             token().mint(beneficiary, mintAmount)
548             , "Crowdsale: transfer failed"
549         );
550     }
551 
552     /**
553      * @dev Override for extensions that require an internal state to check for validity (current user contributions,
554      * etc.)
555      * @param beneficiary Address receiving the tokens
556      * @param weiAmount Value in wei involved in the purchase
557      */
558     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal virtual {
559         // solhint-disable-previous-line no-empty-blocks
560     }
561 
562     /**
563      * @dev Determines how ETH is stored/forwarded on purchases.
564      */
565     function _forwardFunds(address /*beneficiary*/, uint256 /*weiAmount*/) internal virtual {
566         _wallet.transfer(msg.value);
567     }
568 
569     /**
570      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
571      * conditions are not met.
572      * @param beneficiary Address performing the token purchase
573      * @param weiAmount Value in wei involved in the purchase
574      */
575     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view virtual {
576         // solhint-disable-previous-line no-empty-blocks
577     }
578 }
579 
580 // File: contracts/roles/Roles.sol
581 
582 // pragma solidity ^0.5.0;
583 pragma solidity ^0.8.0;
584 
585 
586 /**
587  * @title Roles
588  * @dev Library for managing addresses assigned to a Role.
589  */
590 library Roles {
591     struct Role {
592         mapping (address => bool) bearer;
593     }
594 
595     /**
596      * @dev Give an account access to this role.
597      */
598     function add(Role storage role, address account) internal {
599         require(!has(role, account), "Roles: account already has role");
600         role.bearer[account] = true;
601     }
602 
603     /**
604      * @dev Remove an account's access to this role.
605      */
606     function remove(Role storage role, address account) internal {
607         require(has(role, account), "Roles: account does not have role");
608         role.bearer[account] = false;
609     }
610 
611     /**
612      * @dev Check if an account has this role.
613      * @return bool
614      */
615     function has(Role storage role, address account) internal view returns (bool) {
616         require(account != address(0), "Roles: account is the zero address");
617         return role.bearer[account];
618     }
619 }
620 
621 // File: contracts/roles/WhitelistAdminRole.sol
622 
623 pragma solidity ^0.8.0;
624 
625 
626 
627 /**
628  * @title WhitelistAdminRole
629  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
630  */
631 abstract contract WhitelistAdminRole is Context {
632     using Roles for Roles.Role;
633 
634     event WhitelistAdminAdded(address indexed account);
635     event WhitelistAdminRemoved(address indexed account);
636 
637     Roles.Role private _whitelistAdmins;
638 
639     constructor () internal {
640         _addWhitelistAdmin(_msgSender());
641     }
642 
643     modifier onlyWhitelistAdmin() {
644         require(isWhitelistAdmin(_msgSender()), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
645         _;
646     }
647 
648     function isWhitelistAdmin(address account) public view returns (bool) {
649         return _whitelistAdmins.has(account);
650     }
651 
652     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
653         _addWhitelistAdmin(account);
654     }
655 
656     function renounceWhitelistAdmin() public {
657         _removeWhitelistAdmin(_msgSender());
658     }
659 
660     function _addWhitelistAdmin(address account) internal {
661         _whitelistAdmins.add(account);
662         emit WhitelistAdminAdded(account);
663     }
664 
665     function _removeWhitelistAdmin(address account) internal {
666         _whitelistAdmins.remove(account);
667         emit WhitelistAdminRemoved(account);
668     }
669 }
670 
671 // File: contracts/roles/WhitelistedRole.sol
672 
673 pragma solidity ^0.8.0;
674 
675 
676 
677 
678 /**
679  * @title WhitelistedRole
680  * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
681  * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
682  * it), and not Whitelisteds themselves.
683  */
684 contract WhitelistedRole is Context, WhitelistAdminRole {
685     using Roles for Roles.Role;
686 
687     event WhitelistedAdded(address indexed account);
688     event WhitelistedRemoved(address indexed account);
689 
690     Roles.Role private _whitelisteds;
691 
692     modifier onlyWhitelisted() {
693         require(isWhitelisted(_msgSender()), "WhitelistedRole: caller does not have the Whitelisted role");
694         _;
695     }
696 
697     function isWhitelisted(address account) public view returns (bool) {
698         return _whitelisteds.has(account);
699     }
700 
701     function addWhitelisted(address account) public onlyWhitelistAdmin {
702         _addWhitelisted(account);
703     }
704 
705     function removeWhitelisted(address account) public onlyWhitelistAdmin {
706         _removeWhitelisted(account);
707     }
708 
709     function renounceWhitelisted() public {
710         _removeWhitelisted(_msgSender());
711     }
712 
713     function _addWhitelisted(address account) internal {
714         _whitelisteds.add(account);
715         emit WhitelistedAdded(account);
716     }
717 
718     function _removeWhitelisted(address account) internal {
719         _whitelisteds.remove(account);
720         emit WhitelistedRemoved(account);
721     }
722 }
723 
724 // File: contracts/crowdsale/validation/TimedCrowdsale.sol
725 
726 pragma solidity ^0.8.0;
727 
728 // import "@openzeppelin/contracts/utils/math/SafeMath.sol";
729 
730 
731 /**
732  * @title TimedCrowdsale
733  * @dev Crowdsale accepting contributions only within a time frame.
734  */
735 abstract contract TimedCrowdsale is Crowdsale {
736     using SafeMath for uint256;
737 
738     uint256 internal _openingTime;
739     uint256 private _closingTime;
740     uint256 private _secondarySaleTime;
741 
742     /**
743      * Event for crowdsale extending
744      * @param newClosingTime new closing time
745      * @param prevClosingTime old closing time
746      */
747     event TimedCrowdsaleExtended(uint256 prevClosingTime, uint256 newClosingTime);
748 
749     /**
750      * @dev Reverts if not in crowdsale time range.
751      */
752     modifier onlyWhileOpen {
753         require(isOpen(), "TimedCrowdsale: not open");
754         _;
755     }
756 
757     /**
758      * @dev Constructor, takes crowdsale opening and closing times.
759      * @param __openingTime Crowdsale opening time
760      * @param __closingTime Crowdsale closing time
761      * @param __secondarySaleTime Crowdsale secondary time
762      */
763     constructor (uint256 __openingTime, uint256 __secondarySaleTime, uint256 __closingTime) {
764         // solhint-disable-next-line not-rely-on-time
765         require(__openingTime >= block.timestamp, "TimedCrowdsale: opening time is before current time");
766         // solhint-disable-next-line max-line-length
767         require(__secondarySaleTime > __openingTime, "TimedCrowdsale: opening time is not before secondary sale time");
768         // solhint-disable-next-line max-line-length
769         require(__closingTime > __secondarySaleTime, "TimedCrowdsale: secondary sale time is not before closing time");
770 
771         _openingTime = __openingTime;
772         _closingTime = __closingTime;
773         _secondarySaleTime = __secondarySaleTime;
774     }
775 
776     /**
777      * @return the crowdsale opening time.
778      */
779     function openingTime() public view virtual returns (uint256) {
780         return _openingTime;
781     }
782 
783     /**
784      * @return the crowdsale closing time.
785      */
786     function closingTime() public view virtual returns (uint256) {
787         return _closingTime;
788     }
789 
790     /**
791      * @return the crowdsale secondary sale time.
792      */
793     function secondaryTime() public view virtual returns (uint256) {
794         return _secondarySaleTime;
795     }
796 
797     /**
798      * @return true if the crowdsale is open, false otherwise.
799      */
800     function isOpen() public view virtual returns (bool) {
801         // solhint-disable-next-line not-rely-on-time
802         return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
803     }
804 
805     /**
806      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
807      * @return Whether crowdsale period has elapsed
808      */
809     function hasClosed() public view virtual returns (bool) {
810         // solhint-disable-next-line not-rely-on-time
811         return block.timestamp > _closingTime;
812     }
813 
814     /**
815      * @dev Extend crowdsale.
816      * @param newClosingTime Crowdsale closing time
817      */
818     function _extendTime(uint256 newClosingTime) internal virtual {
819         require(!hasClosed(), "TimedCrowdsale: already closed");
820         // solhint-disable-next-line max-line-length
821         require(newClosingTime > _closingTime, "TimedCrowdsale: new closing time is before current closing time");
822 
823         emit TimedCrowdsaleExtended(_closingTime, newClosingTime);
824         _closingTime = newClosingTime;
825     }
826 }
827 
828 // File: contracts/crowdsale/validation/CappedCrowdsale.sol
829 
830 pragma solidity ^0.8.0;
831 
832 // import "@openzeppelin/contracts/utils/math/SafeMath.sol";
833 
834 
835 /**
836  * @title CappedCrowdsale
837  * @dev Crowdsale with a limit for total contributions.
838  */
839 abstract contract CappedCrowdsale is Crowdsale {
840     using SafeMath for uint256;
841 
842     uint256 internal _cap;
843     uint256 internal _minted;
844 
845     /**
846      * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
847      * @param cap Max amount of wei to be contributed
848      */
849     constructor (uint256 cap) {
850         require(cap > 0, "CappedCrowdsale: cap is 0");
851         _cap = cap;
852     }
853 
854     /**
855      * @return the cap of the crowdsale.
856      */
857     function cap() public view returns (uint256) {
858         return _cap;
859     }
860 
861     /**
862      * @return the minted of the crowdsale.
863      */
864     function minted() public view returns (uint256) {
865         return _minted;
866     }
867 
868     /**
869      * @dev Checks whether the cap has been reached.
870      * @return Whether the cap was reached
871      */
872     function capReached() public view returns (bool) {
873         return _minted >= _cap;
874     }
875 
876     function incrementMinted(uint256 amountOfTokens) internal virtual {
877         _minted +=  amountOfTokens;
878     }
879 
880     function currentMinted() public view returns (uint256) {
881         return _minted;
882     }
883 }
884 
885 // File: contracts/WoofpackNFTICO.sol
886 
887 
888 pragma solidity ^0.8.0;
889 
890 
891 
892 
893 
894 
895 // import "@openzeppelin/contracts/utils/math/SafeMath.sol";
896 
897 
898 contract WoofpackNFTICO is
899     Crowdsale,
900     CappedCrowdsale,
901     TimedCrowdsale,
902     Ownable,
903     WhitelistedRole
904     {
905     using SafeMath for uint256;
906   
907     /* Track investor contributions */
908     uint256 public investorHardCap = 7; // 7 NFT
909     mapping(address => uint256) public contributions;
910 
911     /* Crowdsale Stages */
912     enum CrowdsaleStage {
913         PreICO,
914         ICO
915     }
916 
917     /* Default to presale stage */
918     CrowdsaleStage public stage = CrowdsaleStage.PreICO;
919 
920     constructor(
921         address payable _wallet,
922         IWoofpackNFTToken _token,
923         uint256 _cap,
924         uint256 _openingTime,
925         uint256 _secondarySaleTime,
926         uint256 _closingTime
927     )
928         public
929         Crowdsale(_wallet, _token)
930         CappedCrowdsale(_cap)
931         TimedCrowdsale(_openingTime, _secondarySaleTime, _closingTime)  
932     {}
933 
934     /**
935      * @dev Returns the amount contributed so far by a sepecific user.
936      * @param _beneficiary Address of contributor
937      * @return User contribution so far
938      */
939     function getUserContribution(address _beneficiary)
940         public
941         view
942         returns (uint256)
943     {
944         return contributions[_beneficiary];
945     }
946 
947 
948     /**
949      * @dev Extend parent behavior requiring purchase to respect investor min/max funding cap.
950      * @param _beneficiary Token purchaser
951      */
952     function _preValidatePurchase(address _beneficiary, uint256 mintAmount, uint256 weiAmount)
953         internal virtual override onlyWhileOpen
954     {
955         // Check how many NFT are minted
956         incrementMinted(mintAmount);
957         require(currentMinted() <= _cap, "WoofpackNFTICO: cap exceeded");
958         require(weiAmount.div(mintAmount) == rate(), "WoofpackNFTICO: Invalid ETH Amount");
959 
960         // Validate inputs
961         require(weiAmount != 0, "WoofpackNFTICO: ETH sent 0");
962         require(_beneficiary != address(0), "WoofpackNFTICO: beneficiary zero address");
963 
964          if (stage == CrowdsaleStage.PreICO) {
965             require(
966                 isWhitelisted(_msgSender()),
967                 "WoofpackNFTICO: Wallet Address is not WhiteListed"
968             );
969         }
970 
971         // Check max minting limit
972         uint256 _existingContribution = contributions[_beneficiary];
973         uint256 _newContribution = _existingContribution.add(mintAmount);
974         require(
975             _newContribution <= investorHardCap,
976             "WoofpackNFTICO: No of Mint MaxCap"
977         );
978         contributions[_beneficiary] = _newContribution;
979     }
980 
981     function extendTime(uint256 closingTime) public virtual onlyOwner {
982         _extendTime(closingTime);
983     }
984 
985     /**
986      * @dev If goal is Reached then change to change to ICO Stage
987      * etc.)
988      * @param _beneficiary Address receiving the tokens
989      * @param _weiAmount Value in wei involved in the purchase
990      */
991     function _updatePurchasingState(address _beneficiary, uint256 _weiAmount)
992         internal virtual override
993     {
994         if (block.timestamp >= secondaryTime() &&  stage == CrowdsaleStage.PreICO ) {
995             stage = CrowdsaleStage.ICO;
996             _rate = 70000000000000000;         // 0.08ETH
997             _openingTime = secondaryTime();     // Set opening time to secondary time
998         }
999         super._updatePurchasingState(_beneficiary, _weiAmount);
1000     }
1001 
1002     /**
1003      * @dev enables token transfers, called when owner calls finalize()
1004      */
1005     function finalization() public onlyOwner {
1006         token().renounceMinter();
1007     }
1008 }