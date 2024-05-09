1 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13 
14 
15   event OwnershipRenounced(address indexed previousOwner);
16   event OwnershipTransferred(
17     address indexed previousOwner,
18     address indexed newOwner
19   );
20 
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   constructor() public {
27     owner = msg.sender;
28   }
29 
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38   /**
39    * @dev Allows the current owner to relinquish control of the contract.
40    * @notice Renouncing to ownership will leave the contract without an owner.
41    * It will not be possible to call the functions with the `onlyOwner`
42    * modifier anymore.
43    */
44   function renounceOwnership() public onlyOwner {
45     emit OwnershipRenounced(owner);
46     owner = address(0);
47   }
48 
49   /**
50    * @dev Allows the current owner to transfer control of the contract to a newOwner.
51    * @param _newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address _newOwner) public onlyOwner {
54     _transferOwnership(_newOwner);
55   }
56 
57   /**
58    * @dev Transfers control of the contract to a newOwner.
59    * @param _newOwner The address to transfer ownership to.
60    */
61   function _transferOwnership(address _newOwner) internal {
62     require(_newOwner != address(0));
63     emit OwnershipTransferred(owner, _newOwner);
64     owner = _newOwner;
65   }
66 }
67 
68 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
69 
70 pragma solidity ^0.4.24;
71 
72 
73 
74 /**
75  * @title Pausable
76  * @dev Base contract which allows children to implement an emergency stop mechanism.
77  */
78 contract Pausable is Ownable {
79   event Pause();
80   event Unpause();
81 
82   bool public paused = false;
83 
84 
85   /**
86    * @dev Modifier to make a function callable only when the contract is not paused.
87    */
88   modifier whenNotPaused() {
89     require(!paused);
90     _;
91   }
92 
93   /**
94    * @dev Modifier to make a function callable only when the contract is paused.
95    */
96   modifier whenPaused() {
97     require(paused);
98     _;
99   }
100 
101   /**
102    * @dev called by the owner to pause, triggers stopped state
103    */
104   function pause() public onlyOwner whenNotPaused {
105     paused = true;
106     emit Pause();
107   }
108 
109   /**
110    * @dev called by the owner to unpause, returns to normal state
111    */
112   function unpause() public onlyOwner whenPaused {
113     paused = false;
114     emit Unpause();
115   }
116 }
117 
118 // File: openzeppelin-solidity/contracts/access/rbac/Roles.sol
119 
120 pragma solidity ^0.4.24;
121 
122 
123 /**
124  * @title Roles
125  * @author Francisco Giordano (@frangio)
126  * @dev Library for managing addresses assigned to a Role.
127  * See RBAC.sol for example usage.
128  */
129 library Roles {
130   struct Role {
131     mapping (address => bool) bearer;
132   }
133 
134   /**
135    * @dev give an address access to this role
136    */
137   function add(Role storage _role, address _addr)
138     internal
139   {
140     _role.bearer[_addr] = true;
141   }
142 
143   /**
144    * @dev remove an address' access to this role
145    */
146   function remove(Role storage _role, address _addr)
147     internal
148   {
149     _role.bearer[_addr] = false;
150   }
151 
152   /**
153    * @dev check if an address has this role
154    * // reverts
155    */
156   function check(Role storage _role, address _addr)
157     internal
158     view
159   {
160     require(has(_role, _addr));
161   }
162 
163   /**
164    * @dev check if an address has this role
165    * @return bool
166    */
167   function has(Role storage _role, address _addr)
168     internal
169     view
170     returns (bool)
171   {
172     return _role.bearer[_addr];
173   }
174 }
175 
176 // File: openzeppelin-solidity/contracts/access/rbac/RBAC.sol
177 
178 pragma solidity ^0.4.24;
179 
180 
181 
182 /**
183  * @title RBAC (Role-Based Access Control)
184  * @author Matt Condon (@Shrugs)
185  * @dev Stores and provides setters and getters for roles and addresses.
186  * Supports unlimited numbers of roles and addresses.
187  * See //contracts/mocks/RBACMock.sol for an example of usage.
188  * This RBAC method uses strings to key roles. It may be beneficial
189  * for you to write your own implementation of this interface using Enums or similar.
190  */
191 contract RBAC {
192   using Roles for Roles.Role;
193 
194   mapping (string => Roles.Role) private roles;
195 
196   event RoleAdded(address indexed operator, string role);
197   event RoleRemoved(address indexed operator, string role);
198 
199   /**
200    * @dev reverts if addr does not have role
201    * @param _operator address
202    * @param _role the name of the role
203    * // reverts
204    */
205   function checkRole(address _operator, string _role)
206     public
207     view
208   {
209     roles[_role].check(_operator);
210   }
211 
212   /**
213    * @dev determine if addr has role
214    * @param _operator address
215    * @param _role the name of the role
216    * @return bool
217    */
218   function hasRole(address _operator, string _role)
219     public
220     view
221     returns (bool)
222   {
223     return roles[_role].has(_operator);
224   }
225 
226   /**
227    * @dev add a role to an address
228    * @param _operator address
229    * @param _role the name of the role
230    */
231   function addRole(address _operator, string _role)
232     internal
233   {
234     roles[_role].add(_operator);
235     emit RoleAdded(_operator, _role);
236   }
237 
238   /**
239    * @dev remove a role from an address
240    * @param _operator address
241    * @param _role the name of the role
242    */
243   function removeRole(address _operator, string _role)
244     internal
245   {
246     roles[_role].remove(_operator);
247     emit RoleRemoved(_operator, _role);
248   }
249 
250   /**
251    * @dev modifier to scope access to a single role (uses msg.sender as addr)
252    * @param _role the name of the role
253    * // reverts
254    */
255   modifier onlyRole(string _role)
256   {
257     checkRole(msg.sender, _role);
258     _;
259   }
260 
261   /**
262    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
263    * @param _roles the names of the roles to scope access to
264    * // reverts
265    *
266    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
267    *  see: https://github.com/ethereum/solidity/issues/2467
268    */
269   // modifier onlyRoles(string[] _roles) {
270   //     bool hasAnyRole = false;
271   //     for (uint8 i = 0; i < _roles.length; i++) {
272   //         if (hasRole(msg.sender, _roles[i])) {
273   //             hasAnyRole = true;
274   //             break;
275   //         }
276   //     }
277 
278   //     require(hasAnyRole);
279 
280   //     _;
281   // }
282 }
283 
284 // File: openzeppelin-solidity/contracts/access/Whitelist.sol
285 
286 pragma solidity ^0.4.24;
287 
288 
289 
290 
291 /**
292  * @title Whitelist
293  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
294  * This simplifies the implementation of "user permissions".
295  */
296 contract Whitelist is Ownable, RBAC {
297   string public constant ROLE_WHITELISTED = "whitelist";
298 
299   /**
300    * @dev Throws if operator is not whitelisted.
301    * @param _operator address
302    */
303   modifier onlyIfWhitelisted(address _operator) {
304     checkRole(_operator, ROLE_WHITELISTED);
305     _;
306   }
307 
308   /**
309    * @dev add an address to the whitelist
310    * @param _operator address
311    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
312    */
313   function addAddressToWhitelist(address _operator)
314     public
315     onlyOwner
316   {
317     addRole(_operator, ROLE_WHITELISTED);
318   }
319 
320   /**
321    * @dev getter to determine if address is in whitelist
322    */
323   function whitelist(address _operator)
324     public
325     view
326     returns (bool)
327   {
328     return hasRole(_operator, ROLE_WHITELISTED);
329   }
330 
331   /**
332    * @dev add addresses to the whitelist
333    * @param _operators addresses
334    * @return true if at least one address was added to the whitelist,
335    * false if all addresses were already in the whitelist
336    */
337   function addAddressesToWhitelist(address[] _operators)
338     public
339     onlyOwner
340   {
341     for (uint256 i = 0; i < _operators.length; i++) {
342       addAddressToWhitelist(_operators[i]);
343     }
344   }
345 
346   /**
347    * @dev remove an address from the whitelist
348    * @param _operator address
349    * @return true if the address was removed from the whitelist,
350    * false if the address wasn't in the whitelist in the first place
351    */
352   function removeAddressFromWhitelist(address _operator)
353     public
354     onlyOwner
355   {
356     removeRole(_operator, ROLE_WHITELISTED);
357   }
358 
359   /**
360    * @dev remove addresses from the whitelist
361    * @param _operators addresses
362    * @return true if at least one address was removed from the whitelist,
363    * false if all addresses weren't in the whitelist in the first place
364    */
365   function removeAddressesFromWhitelist(address[] _operators)
366     public
367     onlyOwner
368   {
369     for (uint256 i = 0; i < _operators.length; i++) {
370       removeAddressFromWhitelist(_operators[i]);
371     }
372   }
373 
374 }
375 
376 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
377 
378 pragma solidity ^0.4.24;
379 
380 
381 /**
382  * @title SafeMath
383  * @dev Math operations with safety checks that throw on error
384  */
385 library SafeMath {
386 
387   /**
388   * @dev Multiplies two numbers, throws on overflow.
389   */
390   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
391     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
392     // benefit is lost if 'b' is also tested.
393     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
394     if (_a == 0) {
395       return 0;
396     }
397 
398     c = _a * _b;
399     assert(c / _a == _b);
400     return c;
401   }
402 
403   /**
404   * @dev Integer division of two numbers, truncating the quotient.
405   */
406   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
407     // assert(_b > 0); // Solidity automatically throws when dividing by 0
408     // uint256 c = _a / _b;
409     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
410     return _a / _b;
411   }
412 
413   /**
414   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
415   */
416   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
417     assert(_b <= _a);
418     return _a - _b;
419   }
420 
421   /**
422   * @dev Adds two numbers, throws on overflow.
423   */
424   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
425     c = _a + _b;
426     assert(c >= _a);
427     return c;
428   }
429 }
430 
431 // File: contracts/v2/ReentrancyGuard.sol
432 
433 pragma solidity ^0.4.24;
434 
435 /**
436  * @dev Contract module that helps prevent reentrant calls to a function.
437  *
438  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
439  * available, which can be applied to functions to make sure there are no nested
440  * (reentrant) calls to them.
441  *
442  * Note that because there is a single `nonReentrant` guard, functions marked as
443  * `nonReentrant` may not call one another. This can be worked around by making
444  * those functions `private`, and then adding `external` `nonReentrant` entry
445  * points to them.
446  *
447  * TIP: If you would like to learn more about reentrancy and alternative ways
448  * to protect against it, check out our blog post
449  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
450  */
451 contract ReentrancyGuard {
452   bool private _notEntered = true;
453 
454   /**
455    * @dev Prevents a contract from calling itself, directly or indirectly.
456    * Calling a `nonReentrant` function from another `nonReentrant`
457    * function is not supported. It is possible to prevent this from happening
458    * by making the `nonReentrant` function external, and make it call a
459    * `private` function that does the actual work.
460    */
461   modifier nonReentrant() {
462     // On the first call to nonReentrant, _notEntered will be true
463     require(_notEntered, "ReentrancyGuard: reentrant call");
464 
465     // Any calls to nonReentrant after this point will fail
466     _notEntered = false;
467 
468     _;
469 
470     // By storing the original value once again, a refund is triggered (see
471     // https://eips.ethereum.org/EIPS/eip-2200)
472     _notEntered = true;
473   }
474 }
475 
476 // File: contracts/v2/marketplace/TokenMarketplaceV2.sol
477 
478 pragma solidity ^0.4.24;
479 
480 
481 
482 
483 
484 interface IKODAV2Methods {
485   function ownerOf(uint256 _tokenId) external view returns (address _owner);
486 
487   function exists(uint256 _tokenId) external view returns (bool _exists);
488 
489   function editionOfTokenId(uint256 _tokenId) external view returns (uint256 tokenId);
490 
491   function artistCommission(uint256 _tokenId) external view returns (address _artistAccount, uint256 _artistCommission);
492 
493   function editionOptionalCommission(uint256 _tokenId) external view returns (uint256 _rate, address _recipient);
494 
495   function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
496 }
497 
498 // Based on ITokenMarketplace.sol
499 contract TokenMarketplaceV2 is Whitelist, Pausable, ReentrancyGuard {
500   using SafeMath for uint256;
501 
502   event UpdatePlatformPercentageFee(uint256 _oldPercentage, uint256 _newPercentage);
503   event UpdateRoyaltyPercentageFee(uint256 _oldPercentage, uint256 _newPercentage);
504   event UpdateMinBidAmount(uint256 minBidAmount);
505 
506   event TokenListed(
507     uint256 indexed _tokenId,
508     address indexed _seller,
509     uint256 _price
510   );
511 
512   event TokenDeListed(
513     uint256 indexed _tokenId
514   );
515 
516   event TokenPurchased(
517     uint256 indexed _tokenId,
518     address indexed _buyer,
519     address indexed _seller,
520     uint256 _price
521   );
522 
523   event BidPlaced(
524     uint256 indexed _tokenId,
525     address indexed _currentOwner,
526     address indexed _bidder,
527     uint256 _amount
528   );
529 
530   event BidWithdrawn(
531     uint256 indexed _tokenId,
532     address indexed _bidder
533   );
534 
535   event BidAccepted(
536     uint256 indexed _tokenId,
537     address indexed _currentOwner,
538     address indexed _bidder,
539     uint256 _amount
540   );
541 
542   event BidRejected(
543     uint256 indexed _tokenId,
544     address indexed _currentOwner,
545     address indexed _bidder,
546     uint256 _amount
547   );
548 
549   event AuctionEnabled(
550     uint256 indexed _tokenId,
551     address indexed _auctioneer
552   );
553 
554   event AuctionDisabled(
555     uint256 indexed _tokenId,
556     address indexed _auctioneer
557   );
558 
559   event ListingEnabled(
560     uint256 indexed _tokenId
561   );
562 
563   event ListingDisabled(
564     uint256 indexed _tokenId
565   );
566 
567   struct Offer {
568     address bidder;
569     uint256 offer;
570   }
571 
572   struct Listing {
573     uint256 price;
574     address seller;
575   }
576 
577   // Min increase in bid/list amount
578   uint256 public minBidAmount = 0.04 ether;
579 
580   // Interface into the KODA world
581   IKODAV2Methods public kodaAddress;
582 
583   // KO account which can receive commission
584   address public koCommissionAccount;
585 
586   uint256 public artistRoyaltyPercentage = 100;
587   uint256 public platformFeePercentage = 25;
588 
589   // Token ID to Offer mapping
590   mapping(uint256 => Offer) public offers;
591 
592   // Token ID to Listing
593   mapping(uint256 => Listing) public listings;
594 
595   // Explicitly disable sales for specific tokens
596   mapping(uint256 => bool) public disabledTokens;
597 
598   // Explicitly disable listings for specific tokens
599   mapping(uint256 => bool) public disabledListings;
600 
601   ///////////////
602   // Modifiers //
603   ///////////////
604 
605   modifier onlyWhenOfferOwner(uint256 _tokenId) {
606     require(offers[_tokenId].bidder == msg.sender, "Not offer maker");
607     _;
608   }
609 
610   modifier onlyWhenTokenExists(uint256 _tokenId) {
611     require(kodaAddress.exists(_tokenId), "Token does not exist");
612     _;
613   }
614 
615   modifier onlyWhenBidOverMinAmount(uint256 _tokenId) {
616     require(msg.value >= offers[_tokenId].offer.add(minBidAmount), "Offer not enough");
617     _;
618   }
619 
620   modifier onlyWhenTokenAuctionEnabled(uint256 _tokenId) {
621     require(!disabledTokens[_tokenId], "Token not enabled for offers");
622     _;
623   }
624 
625   /////////////////
626   // Constructor //
627   /////////////////
628 
629   // Set the caller as the default KO account
630   constructor(IKODAV2Methods _kodaAddress, address _koCommissionAccount) public {
631     kodaAddress = _kodaAddress;
632     koCommissionAccount = _koCommissionAccount;
633     super.addAddressToWhitelist(msg.sender);
634   }
635 
636   //////////////////////////
637   // User Bidding Actions //
638   //////////////////////////
639 
640   function placeBid(uint256 _tokenId)
641   public
642   payable
643   whenNotPaused
644   nonReentrant
645   onlyWhenTokenExists(_tokenId)
646   onlyWhenBidOverMinAmount(_tokenId)
647   onlyWhenTokenAuctionEnabled(_tokenId)
648   {
649     require(!isContract(msg.sender), "Unable to place a bid as a contract");
650     _refundHighestBidder(_tokenId);
651 
652     offers[_tokenId] = Offer({bidder : msg.sender, offer : msg.value});
653 
654     address currentOwner = kodaAddress.ownerOf(_tokenId);
655 
656     emit BidPlaced(_tokenId, currentOwner, msg.sender, msg.value);
657   }
658 
659   function withdrawBid(uint256 _tokenId)
660   public
661   whenNotPaused
662   nonReentrant
663   onlyWhenTokenExists(_tokenId)
664   onlyWhenOfferOwner(_tokenId)
665   {
666     _refundHighestBidder(_tokenId);
667 
668     emit BidWithdrawn(_tokenId, msg.sender);
669   }
670 
671   function rejectBid(uint256 _tokenId)
672   public
673   whenNotPaused
674   nonReentrant
675   {
676     address currentOwner = kodaAddress.ownerOf(_tokenId);
677     require(currentOwner == msg.sender, "Not token owner");
678 
679     uint256 currentHighestBiddersAmount = offers[_tokenId].offer;
680     require(currentHighestBiddersAmount > 0, "No offer open");
681 
682     address currentHighestBidder = offers[_tokenId].bidder;
683 
684     _refundHighestBidder(_tokenId);
685 
686     emit BidRejected(_tokenId, currentOwner, currentHighestBidder, currentHighestBiddersAmount);
687   }
688 
689   function acceptBid(uint256 _tokenId, uint256 _acceptedAmount)
690   public
691   whenNotPaused
692   nonReentrant
693   {
694     address currentOwner = kodaAddress.ownerOf(_tokenId);
695     require(currentOwner == msg.sender, "Not token owner");
696 
697     Offer storage offer = offers[_tokenId];
698 
699     uint256 winningOffer = offer.offer;
700 
701     // Check valid offer and offer not replaced whilst inflight
702     require(winningOffer > 0 && _acceptedAmount >= winningOffer, "Offer amount not satisfied");
703 
704     address winningBidder = offer.bidder;
705 
706     delete offers[_tokenId];
707 
708     // Get edition no.
709     uint256 editionNumber = kodaAddress.editionOfTokenId(_tokenId);
710 
711     _handleFunds(editionNumber, winningOffer, currentOwner);
712 
713     kodaAddress.safeTransferFrom(msg.sender, winningBidder, _tokenId);
714 
715     emit BidAccepted(_tokenId, currentOwner, winningBidder, winningOffer);
716   }
717 
718   function _refundHighestBidder(uint256 _tokenId) internal {
719     // Get current highest bidder
720     address currentHighestBidder = offers[_tokenId].bidder;
721 
722     if (currentHighestBidder != address(0)) {
723 
724       // Get current highest bid amount
725       uint256 currentHighestBiddersAmount = offers[_tokenId].offer;
726 
727       if (currentHighestBiddersAmount > 0) {
728 
729         // Clear out highest bidder
730         delete offers[_tokenId];
731 
732         // Refund it
733         currentHighestBidder.transfer(currentHighestBiddersAmount);
734       }
735     }
736   }
737 
738   //////////////////////////
739   // User Listing Actions //
740   //////////////////////////
741 
742   function listToken(uint256 _tokenId, uint256 _listingPrice)
743   public
744   whenNotPaused {
745     require(!disabledListings[_tokenId], "Listing disabled");
746 
747     // Check ownership before listing
748     address tokenOwner = kodaAddress.ownerOf(_tokenId);
749     require(tokenOwner == msg.sender, "Not token owner");
750 
751     // Check price over min bid
752     require(_listingPrice >= minBidAmount, "Listing price not enough");
753 
754     // List the token
755     listings[_tokenId] = Listing({
756     price : _listingPrice,
757     seller : msg.sender
758     });
759 
760     emit TokenListed(_tokenId, msg.sender, _listingPrice);
761   }
762 
763   function delistToken(uint256 _tokenId)
764   public
765   whenNotPaused {
766 
767     // check listing found
768     require(listings[_tokenId].seller != address(0), "No listing found");
769 
770     // check owner is msg.sender
771     require(kodaAddress.ownerOf(_tokenId) == msg.sender, "Only the current owner can delist");
772 
773     _delistToken(_tokenId);
774   }
775 
776   function buyToken(uint256 _tokenId)
777   public
778   payable
779   nonReentrant
780   whenNotPaused {
781     Listing storage listing = listings[_tokenId];
782 
783     // check token is listed
784     require(listing.seller != address(0), "No listing found");
785 
786     // check current owner is the lister as it may have changed hands
787     address currentOwner = kodaAddress.ownerOf(_tokenId);
788     require(listing.seller == currentOwner, "Listing not valid, token owner has changed");
789 
790     // check listing satisfied
791     uint256 listingPrice = listing.price;
792     require(msg.value == listingPrice, "List price not satisfied");
793 
794     // Get edition no.
795     uint256 editionNumber = kodaAddress.editionOfTokenId(_tokenId);
796 
797     // refund any open offers on it
798     Offer storage offer = offers[_tokenId];
799     _refundHighestBidder(_tokenId);
800 
801     // split funds
802     _handleFunds(editionNumber, listingPrice, currentOwner);
803 
804     // transfer token to buyer
805     kodaAddress.safeTransferFrom(currentOwner, msg.sender, _tokenId);
806 
807     // de-list the token
808     _delistToken(_tokenId);
809 
810     // Fire confirmation event
811     emit TokenPurchased(_tokenId, msg.sender, currentOwner, listingPrice);
812   }
813 
814   function _delistToken(uint256 _tokenId) private {
815     delete listings[_tokenId];
816 
817     emit TokenDeListed(_tokenId);
818   }
819 
820   ////////////////////
821   // Funds handling //
822   ////////////////////
823 
824   function _handleFunds(uint256 _editionNumber, uint256 _offer, address _currentOwner) internal {
825 
826     // Get existing artist commission
827     (address artistAccount, uint256 artistCommissionRate) = kodaAddress.artistCommission(_editionNumber);
828 
829     // Get existing optional commission
830     (uint256 optionalCommissionRate, address optionalCommissionRecipient) = kodaAddress.editionOptionalCommission(_editionNumber);
831 
832     _splitFunds(artistAccount, artistCommissionRate, optionalCommissionRecipient, optionalCommissionRate, _offer, _currentOwner);
833   }
834 
835   function _splitFunds(
836     address _artistAccount,
837     uint256 _artistCommissionRate,
838     address _optionalCommissionRecipient,
839     uint256 _optionalCommissionRate,
840     uint256 _offer,
841     address _currentOwner
842   ) internal {
843 
844     // Work out total % of royalties to payout = creator royalties + KO commission
845     uint256 totalCommissionPercentageToPay = platformFeePercentage.add(artistRoyaltyPercentage);
846 
847     // Send current owner majority share of the offer
848     uint256 totalToSendToOwner = _offer.sub(
849       _offer.div(1000).mul(totalCommissionPercentageToPay)
850     );
851     _currentOwner.transfer(totalToSendToOwner);
852 
853     // Send % to KO
854     uint256 koCommission = _offer.div(1000).mul(platformFeePercentage);
855     koCommissionAccount.transfer(koCommission);
856 
857     // Send to seller minus royalties and commission
858     uint256 remainingRoyalties = _offer.sub(koCommission).sub(totalToSendToOwner);
859 
860     if (_optionalCommissionRecipient == address(0)) {
861       // After KO and Seller - send the rest to the original artist
862       _artistAccount.transfer(remainingRoyalties);
863     } else {
864       _handleOptionalSplits(_artistAccount, _artistCommissionRate, _optionalCommissionRecipient, _optionalCommissionRate, remainingRoyalties);
865     }
866   }
867 
868   function _handleOptionalSplits(
869     address _artistAccount,
870     uint256 _artistCommissionRate,
871     address _optionalCommissionRecipient,
872     uint256 _optionalCommissionRate,
873     uint256 _remainingRoyalties
874   ) internal {
875     uint256 _totalCollaboratorsRate = _artistCommissionRate.add(_optionalCommissionRate);
876     uint256 _scaledUpCommission = _artistCommissionRate.mul(10 ** 18);
877 
878     // work out % of royalties total to split e.g. 43 / 85 = 50.5882353%
879     uint256 primaryArtistPercentage = _scaledUpCommission.div(_totalCollaboratorsRate);
880 
881     uint256 totalPrimaryRoyaltiesToArtist = _remainingRoyalties.mul(primaryArtistPercentage).div(10 ** 18);
882     _artistAccount.transfer(totalPrimaryRoyaltiesToArtist);
883 
884     uint256 remainingRoyaltiesToCollaborator = _remainingRoyalties.sub(totalPrimaryRoyaltiesToArtist);
885     _optionalCommissionRecipient.transfer(remainingRoyaltiesToCollaborator);
886   }
887 
888   ///////////////////
889   // Query Methods //
890   ///////////////////
891 
892   function tokenOffer(uint256 _tokenId) external view returns (address _bidder, uint256 _offer, address _owner, bool _enabled, bool _paused) {
893     Offer memory offer = offers[_tokenId];
894     return (
895     offer.bidder,
896     offer.offer,
897     kodaAddress.ownerOf(_tokenId),
898     !disabledTokens[_tokenId],
899     paused
900     );
901   }
902 
903   function determineSaleValues(uint256 _tokenId) external view returns (uint256 _sellerTotal, uint256 _platformFee, uint256 _royaltyFee) {
904     Offer memory offer = offers[_tokenId];
905     uint256 offerValue = offer.offer;
906     uint256 fee = offerValue.div(1000).mul(platformFeePercentage);
907     uint256 royalties = offerValue.div(1000).mul(artistRoyaltyPercentage);
908 
909     return (
910     offer.offer.sub(fee).sub(royalties),
911     fee,
912     royalties
913     );
914   }
915 
916   function tokenListingDetails(uint256 _tokenId) external view returns (uint256 _price, address _lister, address _currentOwner) {
917     Listing memory listing = listings[_tokenId];
918     return (
919     listing.price,
920     listing.seller,
921     kodaAddress.ownerOf(_tokenId)
922     );
923   }
924 
925   function isContract(address account) internal view returns (bool) {
926     // This method relies in extcodesize, which returns 0 for contracts in
927     // construction, since the code is only stored at the end of the
928     // constructor execution.
929     uint256 size;
930     // solhint-disable-next-line no-inline-assembly
931     assembly {size := extcodesize(account)}
932     return size > 0;
933   }
934 
935   ///////////////////
936   // Admin Actions //
937   ///////////////////
938 
939   function disableAuction(uint256 _tokenId)
940   public
941   onlyIfWhitelisted(msg.sender)
942   {
943     _refundHighestBidder(_tokenId);
944 
945     disabledTokens[_tokenId] = true;
946 
947     emit AuctionDisabled(_tokenId, msg.sender);
948   }
949 
950   function enableAuction(uint256 _tokenId)
951   public
952   onlyIfWhitelisted(msg.sender)
953   {
954     _refundHighestBidder(_tokenId);
955 
956     disabledTokens[_tokenId] = false;
957 
958     emit AuctionEnabled(_tokenId, msg.sender);
959   }
960 
961   function disableListing(uint256 _tokenId)
962   public
963   onlyIfWhitelisted(msg.sender)
964   {
965     _delistToken(_tokenId);
966 
967     disabledListings[_tokenId] = true;
968 
969     emit ListingDisabled(_tokenId);
970   }
971 
972   function enableListing(uint256 _tokenId)
973   public
974   onlyIfWhitelisted(msg.sender)
975   {
976     disabledListings[_tokenId] = false;
977 
978     emit ListingEnabled(_tokenId);
979   }
980 
981   function setMinBidAmount(uint256 _minBidAmount) onlyIfWhitelisted(msg.sender) public {
982     minBidAmount = _minBidAmount;
983     emit UpdateMinBidAmount(minBidAmount);
984   }
985 
986   function setKodavV2(IKODAV2Methods _kodaAddress) onlyIfWhitelisted(msg.sender) public {
987     kodaAddress = _kodaAddress;
988   }
989 
990   function setKoCommissionAccount(address _koCommissionAccount) public onlyIfWhitelisted(msg.sender) {
991     require(_koCommissionAccount != address(0), "Invalid address");
992     koCommissionAccount = _koCommissionAccount;
993   }
994 
995   function setArtistRoyaltyPercentage(uint256 _artistRoyaltyPercentage) public onlyIfWhitelisted(msg.sender) {
996     emit UpdateRoyaltyPercentageFee(artistRoyaltyPercentage, _artistRoyaltyPercentage);
997     artistRoyaltyPercentage = _artistRoyaltyPercentage;
998   }
999 
1000   function setPlatformPercentage(uint256 _platformFeePercentage) public onlyIfWhitelisted(msg.sender) {
1001     emit UpdatePlatformPercentageFee(platformFeePercentage, _platformFeePercentage);
1002     platformFeePercentage = _platformFeePercentage;
1003   }
1004 }