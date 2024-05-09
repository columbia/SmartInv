1 // File: openzeppelin-solidity/contracts/access/rbac/Roles.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title Roles
8  * @author Francisco Giordano (@frangio)
9  * @dev Library for managing addresses assigned to a Role.
10  * See RBAC.sol for example usage.
11  */
12 library Roles {
13   struct Role {
14     mapping (address => bool) bearer;
15   }
16 
17   /**
18    * @dev give an address access to this role
19    */
20   function add(Role storage _role, address _addr)
21     internal
22   {
23     _role.bearer[_addr] = true;
24   }
25 
26   /**
27    * @dev remove an address' access to this role
28    */
29   function remove(Role storage _role, address _addr)
30     internal
31   {
32     _role.bearer[_addr] = false;
33   }
34 
35   /**
36    * @dev check if an address has this role
37    * // reverts
38    */
39   function check(Role storage _role, address _addr)
40     internal
41     view
42   {
43     require(has(_role, _addr));
44   }
45 
46   /**
47    * @dev check if an address has this role
48    * @return bool
49    */
50   function has(Role storage _role, address _addr)
51     internal
52     view
53     returns (bool)
54   {
55     return _role.bearer[_addr];
56   }
57 }
58 
59 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
60 
61 pragma solidity ^0.4.24;
62 
63 
64 /**
65  * @title Ownable
66  * @dev The Ownable contract has an owner address, and provides basic authorization control
67  * functions, this simplifies the implementation of "user permissions".
68  */
69 contract Ownable {
70   address public owner;
71 
72 
73   event OwnershipRenounced(address indexed previousOwner);
74   event OwnershipTransferred(
75     address indexed previousOwner,
76     address indexed newOwner
77   );
78 
79 
80   /**
81    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
82    * account.
83    */
84   constructor() public {
85     owner = msg.sender;
86   }
87 
88   /**
89    * @dev Throws if called by any account other than the owner.
90    */
91   modifier onlyOwner() {
92     require(msg.sender == owner);
93     _;
94   }
95 
96   /**
97    * @dev Allows the current owner to relinquish control of the contract.
98    * @notice Renouncing to ownership will leave the contract without an owner.
99    * It will not be possible to call the functions with the `onlyOwner`
100    * modifier anymore.
101    */
102   function renounceOwnership() public onlyOwner {
103     emit OwnershipRenounced(owner);
104     owner = address(0);
105   }
106 
107   /**
108    * @dev Allows the current owner to transfer control of the contract to a newOwner.
109    * @param _newOwner The address to transfer ownership to.
110    */
111   function transferOwnership(address _newOwner) public onlyOwner {
112     _transferOwnership(_newOwner);
113   }
114 
115   /**
116    * @dev Transfers control of the contract to a newOwner.
117    * @param _newOwner The address to transfer ownership to.
118    */
119   function _transferOwnership(address _newOwner) internal {
120     require(_newOwner != address(0));
121     emit OwnershipTransferred(owner, _newOwner);
122     owner = _newOwner;
123   }
124 }
125 
126 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
127 
128 pragma solidity ^0.4.24;
129 
130 
131 
132 /**
133  * @title Pausable
134  * @dev Base contract which allows children to implement an emergency stop mechanism.
135  */
136 contract Pausable is Ownable {
137   event Pause();
138   event Unpause();
139 
140   bool public paused = false;
141 
142 
143   /**
144    * @dev Modifier to make a function callable only when the contract is not paused.
145    */
146   modifier whenNotPaused() {
147     require(!paused);
148     _;
149   }
150 
151   /**
152    * @dev Modifier to make a function callable only when the contract is paused.
153    */
154   modifier whenPaused() {
155     require(paused);
156     _;
157   }
158 
159   /**
160    * @dev called by the owner to pause, triggers stopped state
161    */
162   function pause() public onlyOwner whenNotPaused {
163     paused = true;
164     emit Pause();
165   }
166 
167   /**
168    * @dev called by the owner to unpause, returns to normal state
169    */
170   function unpause() public onlyOwner whenPaused {
171     paused = false;
172     emit Unpause();
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
431 // File: contracts/v2/marketplace/ITokenMarketplace.sol
432 
433 pragma solidity ^0.4.24;
434 
435 interface ITokenMarketplace {
436 
437   event BidPlaced(
438     uint256 indexed _tokenId,
439     address indexed _currentOwner,
440     address indexed _bidder,
441     uint256 _amount
442   );
443 
444   event BidWithdrawn(
445     uint256 indexed _tokenId,
446     address indexed _bidder
447   );
448 
449   event BidAccepted(
450     uint256 indexed _tokenId,
451     address indexed _currentOwner,
452     address indexed _bidder,
453     uint256 _amount
454   );
455 
456   event BidRejected(
457     uint256 indexed _tokenId,
458     address indexed _currentOwner,
459     address indexed _bidder,
460     uint256 _amount
461   );
462 
463   event AuctionEnabled(
464     uint256 indexed _tokenId,
465     address indexed _auctioneer
466   );
467 
468   event AuctionDisabled(
469     uint256 indexed _tokenId,
470     address indexed _auctioneer
471   );
472 
473   function placeBid(uint256 _tokenId) payable external returns (bool success);
474 
475   function withdrawBid(uint256 _tokenId) external returns (bool success);
476 
477   function acceptBid(uint256 _tokenId) external returns (uint256 tokenId);
478 
479   function rejectBid(uint256 _tokenId) external returns (bool success);
480 
481   function enableAuction(uint256 _tokenId) external returns (bool success);
482 
483   function disableAuction(uint256 _tokenId) external returns (bool success);
484 }
485 
486 // File: contracts/v2/marketplace/TokenMarketplace.sol
487 
488 pragma solidity ^0.4.24;
489 
490 
491 
492 
493 
494 
495 interface IKODAV2 {
496   function ownerOf(uint256 _tokenId) external view returns (address _owner);
497 
498   function exists(uint256 _tokenId) external view returns (bool _exists);
499 
500   function editionOfTokenId(uint256 _tokenId) external view returns (uint256 tokenId);
501 
502   function artistCommission(uint256 _tokenId) external view returns (address _artistAccount, uint256 _artistCommission);
503 
504   function editionOptionalCommission(uint256 _tokenId) external view returns (uint256 _rate, address _recipient);
505 
506   function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
507 }
508 
509 contract TokenMarketplace is Whitelist, Pausable, ITokenMarketplace {
510   using SafeMath for uint256;
511 
512   event UpdatePlatformPercentageFee(uint256 _oldPercentage, uint256 _newPercentage);
513   event UpdateRoyaltyPercentageFee(uint256 _oldPercentage, uint256 _newPercentage);
514 
515   struct Offer {
516     address bidder;
517     uint256 offer;
518   }
519 
520   // Min increase in bid amount
521   uint256 public minBidAmount = 0.04 ether;
522 
523   // Interface into the KODA world
524   IKODAV2 public kodaAddress;
525 
526   // KO account which can receive commission
527   address public koCommissionAccount;
528 
529   uint256 public artistRoyaltyPercentage = 50;
530   uint256 public platformFeePercentage = 30;
531 
532   // Token ID to Offer mapping
533   mapping(uint256 => Offer) offers;
534 
535   // Explicitly disable sales for specific tokens
536   mapping(uint256 => bool) disabledTokens;
537 
538   ///////////////
539   // Modifiers //
540   ///////////////
541 
542   modifier onlyWhenOfferOwner(uint256 _tokenId) {
543     require(offers[_tokenId].bidder == msg.sender, "Not offer maker");
544     _;
545   }
546 
547   modifier onlyWhenTokenExists(uint256 _tokenId) {
548     require(kodaAddress.exists(_tokenId), "Token does not exist");
549     _;
550   }
551 
552   modifier onlyWhenBidOverMinAmount(uint256 _tokenId) {
553     require(msg.value >= offers[_tokenId].offer.add(minBidAmount), "Offer not enough");
554     _;
555   }
556 
557   modifier onlyWhenTokenAuctionEnabled(uint256 _tokenId) {
558     require(!disabledTokens[_tokenId], "Token not enabled for offers");
559     _;
560   }
561 
562   /////////////////
563   // Constructor //
564   /////////////////
565 
566   // Set the caller as the default KO account
567   constructor(IKODAV2 _kodaAddress, address _koCommissionAccount) public {
568     kodaAddress = _kodaAddress;
569     koCommissionAccount = _koCommissionAccount;
570     super.addAddressToWhitelist(msg.sender);
571   }
572 
573   //////////////////
574   // User Actions //
575   //////////////////
576 
577   function placeBid(uint256 _tokenId)
578   public
579   payable
580   whenNotPaused
581   onlyWhenTokenExists(_tokenId)
582   onlyWhenBidOverMinAmount(_tokenId)
583   onlyWhenTokenAuctionEnabled(_tokenId)
584   {
585     _refundHighestBidder(_tokenId);
586 
587     offers[_tokenId] = Offer(msg.sender, msg.value);
588 
589     address currentOwner = kodaAddress.ownerOf(_tokenId);
590 
591     emit BidPlaced(_tokenId, currentOwner, msg.sender, msg.value);
592   }
593 
594   function withdrawBid(uint256 _tokenId)
595   public
596   whenNotPaused
597   onlyWhenTokenExists(_tokenId)
598   onlyWhenOfferOwner(_tokenId)
599   {
600     _refundHighestBidder(_tokenId);
601 
602     emit BidWithdrawn(_tokenId, msg.sender);
603   }
604 
605   function rejectBid(uint256 _tokenId)
606   public
607   whenNotPaused
608   {
609     address currentOwner = kodaAddress.ownerOf(_tokenId);
610     require(currentOwner == msg.sender, "Not token owner");
611 
612     uint256 currentHighestBiddersAmount = offers[_tokenId].offer;
613     require(currentHighestBiddersAmount > 0, "No offer open");
614 
615     address currentHighestBidder = offers[_tokenId].bidder;
616 
617     _refundHighestBidder(_tokenId);
618 
619     emit BidRejected(_tokenId, currentOwner, currentHighestBidder, currentHighestBiddersAmount);
620   }
621 
622   function acceptBid(uint256 _tokenId)
623   public
624   whenNotPaused
625   {
626     address currentOwner = kodaAddress.ownerOf(_tokenId);
627     require(currentOwner == msg.sender, "Not token owner");
628 
629     uint256 winningOffer = offers[_tokenId].offer;
630     require(winningOffer > 0, "No offer open");
631 
632     address winningBidder = offers[_tokenId].bidder;
633 
634     delete offers[_tokenId];
635 
636     // Get edition no.
637     uint256 editionNumber = kodaAddress.editionOfTokenId(_tokenId);
638 
639     _handleFunds(editionNumber, winningOffer, currentOwner);
640 
641     kodaAddress.safeTransferFrom(msg.sender, winningBidder, _tokenId);
642 
643     emit BidAccepted(_tokenId, currentOwner, winningBidder, winningOffer);
644 
645   }
646 
647   function _refundHighestBidder(uint256 _tokenId) internal {
648     // Get current highest bidder
649     address currentHighestBidder = offers[_tokenId].bidder;
650 
651     // Get current highest bid amount
652     uint256 currentHighestBiddersAmount = offers[_tokenId].offer;
653 
654     if (currentHighestBidder != address(0) && currentHighestBiddersAmount > 0) {
655 
656       // Clear out highest bidder
657       delete offers[_tokenId];
658 
659       // Refund it
660       currentHighestBidder.transfer(currentHighestBiddersAmount);
661     }
662   }
663 
664   function _handleFunds(uint256 _editionNumber, uint256 _offer, address _currentOwner) internal {
665 
666     // Get existing artist commission
667     (address artistAccount, uint256 artistCommissionRate) = kodaAddress.artistCommission(_editionNumber);
668 
669     // Get existing optional commission
670     (uint256 optionalCommissionRate, address optionalCommissionRecipient) = kodaAddress.editionOptionalCommission(_editionNumber);
671 
672     _splitFunds(artistAccount, artistCommissionRate, optionalCommissionRecipient, optionalCommissionRate, _offer, _currentOwner);
673   }
674 
675   function _splitFunds(
676     address _artistAccount,
677     uint256 _artistCommissionRate,
678     address _optionalCommissionRecipient,
679     uint256 _optionalCommissionRate,
680     uint256 _offer,
681     address _currentOwner
682   ) internal {
683 
684     // Work out total % of royalties to payout = creator royalties + KO commission
685     uint256 totalCommissionPercentageToPay = platformFeePercentage.add(artistRoyaltyPercentage);
686 
687     // Send current owner majority share of the offer
688     uint256 totalToSendToOwner = _offer.sub(
689       _offer.div(1000).mul(totalCommissionPercentageToPay)
690     );
691     _currentOwner.transfer(totalToSendToOwner);
692 
693     // Send % to KO
694     uint256 koCommission = _offer.div(1000).mul(platformFeePercentage);
695     koCommissionAccount.transfer(koCommission);
696 
697     // Send to seller minus royalties and commission
698     uint256 remainingRoyalties = _offer.sub(koCommission).sub(totalToSendToOwner);
699 
700     if (_optionalCommissionRecipient == address(0)) {
701       // After KO and Seller - send the rest to the original artist
702       _artistAccount.transfer(remainingRoyalties);
703     } else {
704       _handleOptionalSplits(_artistAccount, _artistCommissionRate, _optionalCommissionRecipient, _optionalCommissionRate, remainingRoyalties);
705     }
706   }
707 
708   function _handleOptionalSplits(
709     address _artistAccount,
710     uint256 _artistCommissionRate,
711     address _optionalCommissionRecipient,
712     uint256 _optionalCommissionRate,
713     uint256 _remainingRoyalties
714   ) internal {
715     uint256 _totalCollaboratorsRate = _artistCommissionRate.add(_optionalCommissionRate);
716     uint256 _scaledUpCommission = _artistCommissionRate.mul(10 ** 18);
717 
718     // work out % of royalties total to split e.g. 43 / 85 = 50.5882353%
719     uint256 primaryArtistPercentage = _scaledUpCommission.div(_totalCollaboratorsRate);
720 
721     uint256 totalPrimaryRoyaltiesToArtist = _remainingRoyalties.mul(primaryArtistPercentage).div(10 ** 18);
722     _artistAccount.transfer(totalPrimaryRoyaltiesToArtist);
723 
724     uint256 remainingRoyaltiesToCollaborator = _remainingRoyalties.sub(totalPrimaryRoyaltiesToArtist);
725     _optionalCommissionRecipient.transfer(remainingRoyaltiesToCollaborator);
726   }
727 
728   ///////////////////
729   // Query Methods //
730   ///////////////////
731 
732   function tokenOffer(uint256 _tokenId) external view returns (address _bidder, uint256 _offer, address _owner, bool _enabled, bool _paused) {
733     Offer memory offer = offers[_tokenId];
734     return (
735     offer.bidder,
736     offer.offer,
737     kodaAddress.ownerOf(_tokenId),
738     !disabledTokens[_tokenId],
739     paused
740     );
741   }
742 
743   function determineSaleValues(uint256 _tokenId) external view returns (uint256 _sellerTotal, uint256 _platformFee, uint256 _royaltyFee) {
744     Offer memory offer = offers[_tokenId];
745     uint256 offerValue = offer.offer;
746     uint256 fee = offerValue.div(1000).mul(platformFeePercentage);
747     uint256 royalties = offerValue.div(1000).mul(artistRoyaltyPercentage);
748 
749     return (
750     offer.offer.sub(fee).sub(royalties),
751     fee,
752     royalties
753     );
754   }
755 
756   ///////////////////
757   // Admin Actions //
758   ///////////////////
759 
760   function disableAuction(uint256 _tokenId)
761   public
762   onlyIfWhitelisted(msg.sender)
763   {
764     _refundHighestBidder(_tokenId);
765 
766     disabledTokens[_tokenId] = true;
767 
768     emit AuctionDisabled(_tokenId, msg.sender);
769   }
770 
771   function enableAuction(uint256 _tokenId)
772   public
773   onlyIfWhitelisted(msg.sender)
774   {
775     _refundHighestBidder(_tokenId);
776 
777     disabledTokens[_tokenId] = false;
778 
779     emit AuctionEnabled(_tokenId, msg.sender);
780   }
781 
782   function setMinBidAmount(uint256 _minBidAmount) onlyIfWhitelisted(msg.sender) public {
783     minBidAmount = _minBidAmount;
784   }
785 
786   function setKodavV2(IKODAV2 _kodaAddress) onlyIfWhitelisted(msg.sender) public {
787     kodaAddress = _kodaAddress;
788   }
789 
790   function setKoCommissionAccount(address _koCommissionAccount) public onlyIfWhitelisted(msg.sender) {
791     require(_koCommissionAccount != address(0), "Invalid address");
792     koCommissionAccount = _koCommissionAccount;
793   }
794 
795   function setArtistRoyaltyPercentage(uint256 _artistRoyaltyPercentage) public onlyIfWhitelisted(msg.sender) {
796     emit UpdateRoyaltyPercentageFee(artistRoyaltyPercentage, _artistRoyaltyPercentage);
797     artistRoyaltyPercentage = _artistRoyaltyPercentage;
798   }
799 
800   function setPlatformPercentage(uint256 _platformFeePercentage) public onlyIfWhitelisted(msg.sender) {
801     emit UpdatePlatformPercentageFee(platformFeePercentage, _platformFeePercentage);
802     platformFeePercentage = _platformFeePercentage;
803   }
804 }