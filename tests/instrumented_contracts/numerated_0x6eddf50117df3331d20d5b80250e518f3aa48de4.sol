1 // File: contracts/utils/SafeMath.sol
2 // SPDX-License-Identifier: MIT
3 
4 
5 pragma solidity ^0.8.0;
6 
7 // CAUTION
8 // This version of SafeMath should only be used with Solidity 0.8 or later,
9 // because it relies on the compiler's built in overflow checks.
10 
11 /**
12  * @dev Wrappers over Solidity's arithmetic operations.
13  *
14  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
15  * now has built in overflow checking.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, with an overflow flag.
20      *
21      * _Available since v3.4._
22      */
23     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
24             uint256 c = a + b;
25             if (c < a) return (false, 0);
26             return (true, c);
27     }
28 
29     /**
30      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
31      *
32      * _Available since v3.4._
33      */
34     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
35             if (b > a) return (false, 0);
36             return (true, a - b);
37     }
38 
39     /**
40      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
41      *
42      * _Available since v3.4._
43      */
44     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
45             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
46             // benefit is lost if 'b' is also tested.
47             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
48             if (a == 0) return (true, 0);
49             uint256 c = a * b;
50             if (c / a != b) return (false, 0);
51             return (true, c);
52     }
53 
54     /**
55      * @dev Returns the division of two unsigned integers, with a division by zero flag.
56      *
57      * _Available since v3.4._
58      */
59     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
60             if (b == 0) return (false, 0);
61             return (true, a / b);
62     }
63 
64     /**
65      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
66      *
67      * _Available since v3.4._
68      */
69     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
70             if (b == 0) return (false, 0);
71             return (true, a % b);
72     }
73 
74     /**
75      * @dev Returns the addition of two unsigned integers, reverting on
76      * overflow.
77      *
78      * Counterpart to Solidity's `+` operator.
79      *
80      * Requirements:
81      *
82      * - Addition cannot overflow.
83      */
84     function add(uint256 a, uint256 b) internal pure returns (uint256) {
85         return a + b;
86     }
87 
88     /**
89      * @dev Returns the subtraction of two unsigned integers, reverting on
90      * overflow (when the result is negative).
91      *
92      * Counterpart to Solidity's `-` operator.
93      *
94      * Requirements:
95      *
96      * - Subtraction cannot overflow.
97      */
98     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
99         return a - b;
100     }
101 
102     /**
103      * @dev Returns the multiplication of two unsigned integers, reverting on
104      * overflow.
105      *
106      * Counterpart to Solidity's `*` operator.
107      *
108      * Requirements:
109      *
110      * - Multiplication cannot overflow.
111      */
112     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
113         return a * b;
114     }
115 
116     /**
117      * @dev Returns the integer division of two unsigned integers, reverting on
118      * division by zero. The result is rounded towards zero.
119      *
120      * Counterpart to Solidity's `/` operator.
121      *
122      * Requirements:
123      *
124      * - The divisor cannot be zero.
125      */
126     function div(uint256 a, uint256 b) internal pure returns (uint256) {
127         return a / b;
128     }
129 
130     /**
131      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
132      * reverting when dividing by zero.
133      *
134      * Counterpart to Solidity's `%` operator. This function uses a `revert`
135      * opcode (which leaves remaining gas untouched) while Solidity uses an
136      * invalid opcode to revert (consuming all remaining gas).
137      *
138      * Requirements:
139      *
140      * - The divisor cannot be zero.
141      */
142     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
143         return a % b;
144     }
145 
146     /**
147      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
148      * overflow (when the result is negative).
149      *
150      * CAUTION: This function is deprecated because it requires allocating memory for the error
151      * message unnecessarily. For custom revert reasons use {trySub}.
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      *
157      * - Subtraction cannot overflow.
158      */
159     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
160             require(b <= a, errorMessage);
161             return a - b;
162     }
163 
164     /**
165      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
166      * division by zero. The result is rounded towards zero.
167      *
168      * Counterpart to Solidity's `%` operator. This function uses a `revert`
169      * opcode (which leaves remaining gas untouched) while Solidity uses an
170      * invalid opcode to revert (consuming all remaining gas).
171      *
172      * Counterpart to Solidity's `/` operator. Note: this function uses a
173      * `revert` opcode (which leaves remaining gas untouched) while Solidity
174      * uses an invalid opcode to revert (consuming all remaining gas).
175      *
176      * Requirements:
177      *
178      * - The divisor cannot be zero.
179      */
180     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
181             require(b > 0, errorMessage);
182             return a / b;
183     }
184 
185     /**
186      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
187      * reverting with custom message when dividing by zero.
188      *
189      * CAUTION: This function is deprecated because it requires allocating memory for the error
190      * message unnecessarily. For custom revert reasons use {tryMod}.
191      *
192      * Counterpart to Solidity's `%` operator. This function uses a `revert`
193      * opcode (which leaves remaining gas untouched) while Solidity uses an
194      * invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      *
198      * - The divisor cannot be zero.
199      */
200     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
201             require(b > 0, errorMessage);
202             return a % b;
203     }
204 }
205 
206 // File: contracts/IBabyDinosNFTToken.sol
207 
208 
209 pragma experimental ABIEncoderV2;
210 
211 pragma solidity ^0.8.0;
212 
213 /**
214  * @dev Required interface of an ERC721 compliant contract.
215  */
216 interface IBabyDinosNFTToken {
217     /**
218      * @dev Returns the number of tokens in ``owner``'s account.
219      */
220     function balanceOf(address owner) external view returns (uint256 balance);
221  
222     function transferOwnership(address newOwner) external;
223 
224     function renounceMinter() external;
225 
226     /**
227      * @dev Returns the owner of the `tokenId` token.
228      *
229      * Requirements:
230      *
231      * - `tokenId` must exist.
232      */
233     function ownerOf(uint256 tokenId) external view returns (address owner);
234 
235     function mint(address recipient, uint256 mintAmount) external returns (bool);
236 }
237 
238 // File: @openzeppelin/contracts/utils/Context.sol
239 
240 
241 
242 pragma solidity ^0.8.0;
243 
244 /*
245  * @dev Provides information about the current execution context, including the
246  * sender of the transaction and its data. While these are generally available
247  * via msg.sender and msg.data, they should not be accessed in such a direct
248  * manner, since when dealing with meta-transactions the account sending and
249  * paying for execution may not be the actual sender (as far as an application
250  * is concerned).
251  *
252  * This contract is only required for intermediate, library-like contracts.
253  */
254 abstract contract Context {
255     function _msgSender() internal view virtual returns (address) {
256         return msg.sender;
257     }
258 
259     function _msgData() internal view virtual returns (bytes calldata) {
260         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
261         return msg.data;
262     }
263 }
264 
265 // File: @openzeppelin/contracts/access/Ownable.sol
266 
267 
268 
269 pragma solidity ^0.8.0;
270 
271 /**
272  * @dev Contract module which provides a basic access control mechanism, where
273  * there is an account (an owner) that can be granted exclusive access to
274  * specific functions.
275  *
276  * By default, the owner account will be the one that deploys the contract. This
277  * can later be changed with {transferOwnership}.
278  *
279  * This module is used through inheritance. It will make available the modifier
280  * `onlyOwner`, which can be applied to your functions to restrict their use to
281  * the owner.
282  */
283 abstract contract Ownable is Context {
284     address private _owner;
285 
286     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
287 
288     /**
289      * @dev Initializes the contract setting the deployer as the initial owner.
290      */
291     constructor () {
292         address msgSender = _msgSender();
293         _owner = msgSender;
294         emit OwnershipTransferred(address(0), msgSender);
295     }
296 
297     /**
298      * @dev Returns the address of the current owner.
299      */
300     function owner() public view virtual returns (address) {
301         return _owner;
302     }
303 
304     /**
305      * @dev Throws if called by any account other than the owner.
306      */
307     modifier onlyOwner() {
308         require(owner() == _msgSender(), "Ownable: caller is not the owner");
309         _;
310     }
311 
312     /**
313      * @dev Leaves the contract without owner. It will not be possible to call
314      * `onlyOwner` functions anymore. Can only be called by the current owner.
315      *
316      * NOTE: Renouncing ownership will leave the contract without an owner,
317      * thereby removing any functionality that is only available to the owner.
318      */
319     function renounceOwnership() public virtual onlyOwner {
320         emit OwnershipTransferred(_owner, address(0));
321         _owner = address(0);
322     }
323 
324     /**
325      * @dev Transfers ownership of the contract to a new account (`newOwner`).
326      * Can only be called by the current owner.
327      */
328     function transferOwnership(address newOwner) public virtual onlyOwner {
329         require(newOwner != address(0), "Ownable: new owner is the zero address");
330         emit OwnershipTransferred(_owner, newOwner);
331         _owner = newOwner;
332     }
333 }
334 
335 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
336 
337 
338 
339 pragma solidity ^0.8.0;
340 
341 /**
342  * @dev Contract module that helps prevent reentrant calls to a function.
343  *
344  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
345  * available, which can be applied to functions to make sure there are no nested
346  * (reentrant) calls to them.
347  *
348  * Note that because there is a single `nonReentrant` guard, functions marked as
349  * `nonReentrant` may not call one another. This can be worked around by making
350  * those functions `private`, and then adding `external` `nonReentrant` entry
351  * points to them.
352  *
353  * TIP: If you would like to learn more about reentrancy and alternative ways
354  * to protect against it, check out our blog post
355  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
356  */
357 abstract contract ReentrancyGuard {
358     // Booleans are more expensive than uint256 or any type that takes up a full
359     // word because each write operation emits an extra SLOAD to first read the
360     // slot's contents, replace the bits taken up by the boolean, and then write
361     // back. This is the compiler's defense against contract upgrades and
362     // pointer aliasing, and it cannot be disabled.
363 
364     // The values being non-zero value makes deployment a bit more expensive,
365     // but in exchange the refund on every call to nonReentrant will be lower in
366     // amount. Since refunds are capped to a percentage of the total
367     // transaction's gas, it is best to keep them low in cases like this one, to
368     // increase the likelihood of the full refund coming into effect.
369     uint256 private constant _NOT_ENTERED = 1;
370     uint256 private constant _ENTERED = 2;
371 
372     uint256 private _status;
373 
374     constructor () {
375         _status = _NOT_ENTERED;
376     }
377 
378     /**
379      * @dev Prevents a contract from calling itself, directly or indirectly.
380      * Calling a `nonReentrant` function from another `nonReentrant`
381      * function is not supported. It is possible to prevent this from happening
382      * by making the `nonReentrant` function external, and make it call a
383      * `private` function that does the actual work.
384      */
385     modifier nonReentrant() {
386         // On the first call to nonReentrant, _notEntered will be true
387         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
388 
389         // Any calls to nonReentrant after this point will fail
390         _status = _ENTERED;
391 
392         _;
393 
394         // By storing the original value once again, a refund is triggered (see
395         // https://eips.ethereum.org/EIPS/eip-2200)
396         _status = _NOT_ENTERED;
397     }
398 }
399 
400 // File: contracts/crowdsale/Crowdsale.sol
401 
402 pragma solidity ^0.8.0;
403 
404 
405 
406 
407 
408 /**
409  * @title Crowdsale
410  * @dev Crowdsale is a base contract for managing a token crowdsale,
411  * allowing investors to purchase tokens with ether. This contract implements
412  * such functionality in its most fundamental form and can be extended to provide additional
413  * functionality and/or custom behavior.
414  * The external interface represents the basic interface for purchasing tokens, and conforms
415  * the base architecture for crowdsales. It is *not* intended to be modified / overridden.
416  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
417  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
418  * behavior.
419  */
420 contract Crowdsale is Context, ReentrancyGuard  {
421     using SafeMath for uint256;
422 
423     // The token being sold
424     IBabyDinosNFTToken private _token;
425 
426     // Amount of wei raised
427     uint256 private _weiRaised;
428 
429     // Address where funds are collected
430     address payable private _wallet;
431 
432     // Private Sale price is 0.05ETH
433     uint256 internal _rate = 50000000000000000;
434 
435     /**
436      * Event for token purchase logging
437      * @param purchaser who paid for the tokens
438      * @param beneficiary who got the tokens
439      */
440     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 mintAmount);
441 
442     /**
443      * @param __wallet Address where collected funds will be forwarded to
444      * @param __token Address of the token being sold
445      */
446     constructor (address payable __wallet, IBabyDinosNFTToken __token) public {
447         require(__wallet != address(0), "Crowdsale: wallet is the zero address");
448         require(address(__token) != address(0), "Crowdsale: token is the zero address");
449 
450         _wallet = __wallet;
451         _token = __token;
452     }
453 
454     /**
455      * @return the token being sold.
456      */
457     function token() public view virtual returns (IBabyDinosNFTToken) {
458         return _token;
459     }
460 
461     /**
462      * @return the address where funds are collected.
463      */
464     function wallet() public view virtual returns (address payable) {
465         return _wallet;
466     }
467 
468     /**
469      * @return the number of token units a buyer gets per wei.
470      */
471     function rate() public view virtual returns (uint256) {
472         return _rate;
473     }
474 
475     /**
476      * @return the amount of wei raised.
477      */
478     function weiRaised() public view virtual returns (uint256) {
479         return _weiRaised;
480     }
481 
482     /**
483      * @dev low level token purchase ***DO NOT OVERRIDE***
484      * This function has a non-reentrancy guard, so it shouldn't be called by
485      * another `nonReentrant` function.
486      * @param beneficiary Recipient of the token purchase
487     **/
488     function buyNFT(address beneficiary, uint256 mintAmount) public nonReentrant payable {
489         uint256 weiAmount = msg.value;
490         _preValidatePurchase(beneficiary, mintAmount, weiAmount);
491 
492         // update state ETH Amount
493         _weiRaised = _weiRaised.add(weiAmount);
494 
495         _processPurchase(beneficiary, mintAmount);
496         emit TokensPurchased(_msgSender(), beneficiary, mintAmount);
497 
498         _updatePurchasingState(beneficiary, weiAmount);
499 
500         _forwardFunds(beneficiary, weiAmount);
501         _postValidatePurchase(beneficiary, weiAmount);
502     }
503 
504     /**
505      * @dev Override for extensions that require an internal state to check for validity (current user contributions,
506      * etc.)
507      * @param beneficiary Address receiving the tokens
508      * @param mintAmount total no of tokens to be minted
509      * @param weiAmount no of ETH sent
510      */
511     function _preValidatePurchase(address beneficiary, uint256 mintAmount, uint256 weiAmount) internal virtual {
512         // solhint-disable-previous-line no-empty-blocks
513     }
514 
515     /**
516      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
517      * tokens.
518      * @param beneficiary Address receiving the tokens
519      * @param mintAmount Total mint tokens
520      */
521     function _processPurchase(address beneficiary, uint256 mintAmount) internal virtual {
522         _deliverTokens(beneficiary, mintAmount);
523     }
524 
525     /**
526      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
527      * its tokens.
528      * @param beneficiary Address performing the token purchase
529      * @param mintAmount Total mint tokens
530      */
531     function _deliverTokens(address beneficiary, uint256 mintAmount) internal {
532          
533          /*********** COMMENTED REQUIRE BECAUSE IT WAS RETURNING BOOLEAN AND WE WERE LISTENING FROM THE INTERFACE THAT IT WILL RETURN BOOLEAN BUT IT REVERTS OUR TRANSACTION**************** */
534          // Potentially dangerous assumption about the type of the token.
535         require(
536             token().mint(beneficiary, mintAmount)
537             , "Crowdsale: transfer failed"
538         );
539     }
540 
541     /**
542      * @dev Override for extensions that require an internal state to check for validity (current user contributions,
543      * etc.)
544      * @param beneficiary Address receiving the tokens
545      * @param weiAmount Value in wei involved in the purchase
546      */
547     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal virtual {
548         // solhint-disable-previous-line no-empty-blocks
549     }
550 
551     /**
552      * @dev Determines how ETH is stored/forwarded on purchases.
553      */
554     function _forwardFunds(address /*beneficiary*/, uint256 /*weiAmount*/) internal virtual {
555         _wallet.transfer(msg.value);
556     }
557 
558     /**
559      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
560      * conditions are not met.
561      * @param beneficiary Address performing the token purchase
562      * @param weiAmount Value in wei involved in the purchase
563      */
564     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view virtual {
565         // solhint-disable-previous-line no-empty-blocks
566     }
567 }
568 
569 // File: contracts/crowdsale/validation/TimedCrowdsale.sol
570 
571 pragma solidity ^0.8.0;
572 
573 
574 
575 /**
576  * @title TimedCrowdsale
577  * @dev Crowdsale accepting contributions only within a time frame.
578  */
579 abstract contract TimedCrowdsale is Crowdsale {
580     using SafeMath for uint256;
581 
582     uint256 internal _openingTime;
583     uint256 private _closingTime;
584 
585     /**
586      * Event for crowdsale extending
587      * @param newClosingTime new closing time
588      * @param prevClosingTime old closing time
589      */
590     event TimedCrowdsaleExtended(uint256 prevClosingTime, uint256 newClosingTime);
591 
592     /**
593      * @dev Reverts if not in crowdsale time range.
594      */
595     modifier onlyWhileOpen {
596         require(isOpen(), "TimedCrowdsale: not open");
597         _;
598     }
599 
600     /**
601      * @dev Constructor, takes crowdsale opening and closing times.
602      * @param __openingTime Crowdsale opening time
603      * @param __closingTime Crowdsale closing time
604      */
605     constructor (uint256 __openingTime, uint256 __closingTime) {
606         // solhint-disable-next-line not-rely-on-time
607         require(__openingTime >= block.timestamp, "TimedCrowdsale: opening time is before current time");
608         // solhint-disable-next-line max-line-length
609         require(__closingTime > __openingTime, "TimedCrowdsale: opening time is not before closing time");
610 
611         _openingTime = __openingTime;
612         _closingTime = __closingTime;
613     }
614 
615     /**
616      * @return the crowdsale opening time.
617      */
618     function openingTime() public view virtual returns (uint256) {
619         return _openingTime;
620     }
621 
622     /**
623      * @return the crowdsale closing time.
624      */
625     function closingTime() public view virtual returns (uint256) {
626         return _closingTime;
627     }
628    
629     /**
630      * @return true if the crowdsale is open, false otherwise.
631      */
632     function isOpen() public view virtual returns (bool) {
633         // solhint-disable-next-line not-rely-on-time
634         return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
635     }
636     /**
637      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
638      * @return Whether crowdsale period has elapsed
639      */
640     function hasClosed() public view virtual returns (bool) {
641         // solhint-disable-next-line not-rely-on-time
642         return block.timestamp > _closingTime;
643     }
644 
645     /**
646      * @dev Extend crowdsale.
647      * @param newClosingTime Crowdsale closing time
648      */
649     function _extendTime(uint256 newClosingTime) internal virtual {
650         require(!hasClosed(), "TimedCrowdsale: already closed");
651         // solhint-disable-next-line max-line-length
652         require(newClosingTime > _closingTime, "TimedCrowdsale: new closing time is before current closing time");
653 
654         emit TimedCrowdsaleExtended(_closingTime, newClosingTime);
655         _closingTime = newClosingTime;
656     }
657 }
658 
659 // File: contracts/crowdsale/validation/CappedCrowdsale.sol
660 
661 pragma solidity ^0.8.0;
662 
663 
664 
665 /**
666  * @title CappedCrowdsale
667  * @dev Crowdsale with a limit for total contributions.
668  */
669 abstract contract CappedCrowdsale is Crowdsale {
670     using SafeMath for uint256;
671 
672     uint256 internal _cap;
673     uint256 internal _minted;
674 
675     /**
676      * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
677      * @param cap Max amount of wei to be contributed
678      */
679     constructor (uint256 cap) {
680         require(cap > 0, "CappedCrowdsale: cap is 0");
681         _cap = cap;
682     }
683 
684     /**
685      * @return the cap of the crowdsale.
686      */
687     function cap() public view returns (uint256) {
688         return _cap;
689     }
690 
691     /**
692      * @return the minted of the crowdsale.
693      */
694     function minted() public view returns (uint256) {
695         return _minted;
696     }
697 
698     /**
699      * @dev Checks whether the cap has been reached.
700      * @return Whether the cap was reached
701      */
702     function capReached() public view returns (bool) {
703         return _minted >= _cap;
704     }
705 
706     function incrementMinted(uint256 amountOfTokens) internal virtual {
707         _minted +=  amountOfTokens;
708     }
709 
710     function currentMinted() public view returns (uint256) {
711         return _minted;
712     }
713 }
714 
715 // File: contracts/BabyDinosNFTICO.sol
716 
717 pragma solidity ^0.8.0;
718 
719 contract BabyDinosNFTICO is
720     Crowdsale,
721     CappedCrowdsale,
722     TimedCrowdsale,
723     Ownable
724     {
725     using SafeMath for uint256;
726 
727     /* Track investor contributions */
728     uint256 public investorHardCap = 50; // 10 NFT
729     mapping(address => uint256) public contributions;
730 
731     constructor(
732         address payable _wallet,
733         IBabyDinosNFTToken _token,
734         uint256 _cap,
735         uint256 _openingTime,
736         uint256 _closingTime
737     )
738         public
739         Crowdsale(_wallet, _token)
740         CappedCrowdsale(_cap)
741         TimedCrowdsale(_openingTime, _closingTime)
742     {}
743 
744     /**
745      * @dev Returns the amount contributed so far by a sepecific user.
746      * @param _beneficiary Address of contributor
747      * @return User contribution so far
748      */
749     function getUserContribution(address _beneficiary)
750         public
751         view
752         returns (uint256)
753     {
754         return contributions[_beneficiary];
755     }
756 
757     /**
758      * @dev Extend parent behavior requiring purchase to respect investor min/max funding cap.
759      * @param _beneficiary Token purchaser
760      */
761     function _preValidatePurchase(
762         address _beneficiary,
763         uint256 mintAmount,
764         uint256 weiAmount
765     ) internal virtual override onlyWhileOpen {
766 
767         // Check how many NFT are minted
768         incrementMinted(mintAmount);
769         require(currentMinted() <= _cap, "BabyDinosNFTICO: cap exceeded");
770         require(
771             weiAmount.div(mintAmount) == rate(),
772             "BabyDinosNFTICO: Invalid ETH Amount"
773         );
774 
775         // Validate inputs
776         require(weiAmount != 0, "BabyDinosNFTICO: ETH sent 0");
777         require(
778             _beneficiary != address(0),
779             "BabyDinosNFTICO: beneficiary zero address"
780         );
781         
782 
783         // Check max minting limit
784         uint256 _existingContribution = contributions[_beneficiary];
785         uint256 _newContribution = _existingContribution.add(mintAmount);
786         require(
787             _newContribution <= investorHardCap,
788             "BabyDinosNFTICO: No of Mint MaxCap"
789         );
790         contributions[_beneficiary] = _newContribution;
791     }
792 
793     function extendTime(uint256 closingTime) public virtual onlyOwner {
794         _extendTime(closingTime);
795     }
796 
797     /**
798      * @dev If goal is Reached then change to change to ICO Stage
799      * etc.)
800      * @param _beneficiary Address receiving the tokens
801      * @param _weiAmount Value in wei involved in the purchase
802      */
803     function _updatePurchasingState(address _beneficiary, uint256 _weiAmount)
804         internal
805         virtual
806         override
807     {    
808         super._updatePurchasingState(_beneficiary, _weiAmount);
809     }
810 
811     /**
812      * @dev enables token transfers, called when owner calls finalize()
813      */
814     function finalization() public onlyOwner {
815         token().renounceMinter();
816     }
817 }