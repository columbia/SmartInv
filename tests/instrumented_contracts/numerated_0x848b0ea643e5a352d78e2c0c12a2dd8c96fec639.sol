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
68 // File: openzeppelin-solidity/contracts/access/rbac/Roles.sol
69 
70 pragma solidity ^0.4.24;
71 
72 
73 /**
74  * @title Roles
75  * @author Francisco Giordano (@frangio)
76  * @dev Library for managing addresses assigned to a Role.
77  * See RBAC.sol for example usage.
78  */
79 library Roles {
80   struct Role {
81     mapping (address => bool) bearer;
82   }
83 
84   /**
85    * @dev give an address access to this role
86    */
87   function add(Role storage _role, address _addr)
88     internal
89   {
90     _role.bearer[_addr] = true;
91   }
92 
93   /**
94    * @dev remove an address' access to this role
95    */
96   function remove(Role storage _role, address _addr)
97     internal
98   {
99     _role.bearer[_addr] = false;
100   }
101 
102   /**
103    * @dev check if an address has this role
104    * // reverts
105    */
106   function check(Role storage _role, address _addr)
107     internal
108     view
109   {
110     require(has(_role, _addr));
111   }
112 
113   /**
114    * @dev check if an address has this role
115    * @return bool
116    */
117   function has(Role storage _role, address _addr)
118     internal
119     view
120     returns (bool)
121   {
122     return _role.bearer[_addr];
123   }
124 }
125 
126 // File: openzeppelin-solidity/contracts/access/rbac/RBAC.sol
127 
128 pragma solidity ^0.4.24;
129 
130 
131 
132 /**
133  * @title RBAC (Role-Based Access Control)
134  * @author Matt Condon (@Shrugs)
135  * @dev Stores and provides setters and getters for roles and addresses.
136  * Supports unlimited numbers of roles and addresses.
137  * See //contracts/mocks/RBACMock.sol for an example of usage.
138  * This RBAC method uses strings to key roles. It may be beneficial
139  * for you to write your own implementation of this interface using Enums or similar.
140  */
141 contract RBAC {
142   using Roles for Roles.Role;
143 
144   mapping (string => Roles.Role) private roles;
145 
146   event RoleAdded(address indexed operator, string role);
147   event RoleRemoved(address indexed operator, string role);
148 
149   /**
150    * @dev reverts if addr does not have role
151    * @param _operator address
152    * @param _role the name of the role
153    * // reverts
154    */
155   function checkRole(address _operator, string _role)
156     public
157     view
158   {
159     roles[_role].check(_operator);
160   }
161 
162   /**
163    * @dev determine if addr has role
164    * @param _operator address
165    * @param _role the name of the role
166    * @return bool
167    */
168   function hasRole(address _operator, string _role)
169     public
170     view
171     returns (bool)
172   {
173     return roles[_role].has(_operator);
174   }
175 
176   /**
177    * @dev add a role to an address
178    * @param _operator address
179    * @param _role the name of the role
180    */
181   function addRole(address _operator, string _role)
182     internal
183   {
184     roles[_role].add(_operator);
185     emit RoleAdded(_operator, _role);
186   }
187 
188   /**
189    * @dev remove a role from an address
190    * @param _operator address
191    * @param _role the name of the role
192    */
193   function removeRole(address _operator, string _role)
194     internal
195   {
196     roles[_role].remove(_operator);
197     emit RoleRemoved(_operator, _role);
198   }
199 
200   /**
201    * @dev modifier to scope access to a single role (uses msg.sender as addr)
202    * @param _role the name of the role
203    * // reverts
204    */
205   modifier onlyRole(string _role)
206   {
207     checkRole(msg.sender, _role);
208     _;
209   }
210 
211   /**
212    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
213    * @param _roles the names of the roles to scope access to
214    * // reverts
215    *
216    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
217    *  see: https://github.com/ethereum/solidity/issues/2467
218    */
219   // modifier onlyRoles(string[] _roles) {
220   //     bool hasAnyRole = false;
221   //     for (uint8 i = 0; i < _roles.length; i++) {
222   //         if (hasRole(msg.sender, _roles[i])) {
223   //             hasAnyRole = true;
224   //             break;
225   //         }
226   //     }
227 
228   //     require(hasAnyRole);
229 
230   //     _;
231   // }
232 }
233 
234 // File: openzeppelin-solidity/contracts/access/Whitelist.sol
235 
236 pragma solidity ^0.4.24;
237 
238 
239 
240 
241 /**
242  * @title Whitelist
243  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
244  * This simplifies the implementation of "user permissions".
245  */
246 contract Whitelist is Ownable, RBAC {
247   string public constant ROLE_WHITELISTED = "whitelist";
248 
249   /**
250    * @dev Throws if operator is not whitelisted.
251    * @param _operator address
252    */
253   modifier onlyIfWhitelisted(address _operator) {
254     checkRole(_operator, ROLE_WHITELISTED);
255     _;
256   }
257 
258   /**
259    * @dev add an address to the whitelist
260    * @param _operator address
261    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
262    */
263   function addAddressToWhitelist(address _operator)
264     public
265     onlyOwner
266   {
267     addRole(_operator, ROLE_WHITELISTED);
268   }
269 
270   /**
271    * @dev getter to determine if address is in whitelist
272    */
273   function whitelist(address _operator)
274     public
275     view
276     returns (bool)
277   {
278     return hasRole(_operator, ROLE_WHITELISTED);
279   }
280 
281   /**
282    * @dev add addresses to the whitelist
283    * @param _operators addresses
284    * @return true if at least one address was added to the whitelist,
285    * false if all addresses were already in the whitelist
286    */
287   function addAddressesToWhitelist(address[] _operators)
288     public
289     onlyOwner
290   {
291     for (uint256 i = 0; i < _operators.length; i++) {
292       addAddressToWhitelist(_operators[i]);
293     }
294   }
295 
296   /**
297    * @dev remove an address from the whitelist
298    * @param _operator address
299    * @return true if the address was removed from the whitelist,
300    * false if the address wasn't in the whitelist in the first place
301    */
302   function removeAddressFromWhitelist(address _operator)
303     public
304     onlyOwner
305   {
306     removeRole(_operator, ROLE_WHITELISTED);
307   }
308 
309   /**
310    * @dev remove addresses from the whitelist
311    * @param _operators addresses
312    * @return true if at least one address was removed from the whitelist,
313    * false if all addresses weren't in the whitelist in the first place
314    */
315   function removeAddressesFromWhitelist(address[] _operators)
316     public
317     onlyOwner
318   {
319     for (uint256 i = 0; i < _operators.length; i++) {
320       removeAddressFromWhitelist(_operators[i]);
321     }
322   }
323 
324 }
325 
326 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
327 
328 pragma solidity ^0.4.24;
329 
330 
331 
332 /**
333  * @title Pausable
334  * @dev Base contract which allows children to implement an emergency stop mechanism.
335  */
336 contract Pausable is Ownable {
337   event Pause();
338   event Unpause();
339 
340   bool public paused = false;
341 
342 
343   /**
344    * @dev Modifier to make a function callable only when the contract is not paused.
345    */
346   modifier whenNotPaused() {
347     require(!paused);
348     _;
349   }
350 
351   /**
352    * @dev Modifier to make a function callable only when the contract is paused.
353    */
354   modifier whenPaused() {
355     require(paused);
356     _;
357   }
358 
359   /**
360    * @dev called by the owner to pause, triggers stopped state
361    */
362   function pause() public onlyOwner whenNotPaused {
363     paused = true;
364     emit Pause();
365   }
366 
367   /**
368    * @dev called by the owner to unpause, returns to normal state
369    */
370   function unpause() public onlyOwner whenPaused {
371     paused = false;
372     emit Unpause();
373   }
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
431 // File: contracts/v2/auctions/IKODAV2.sol
432 
433 /**
434 * Minimal interface definition for KODA V2 contract calls
435 *
436 * https://www.knownorigin.io/
437 */
438 interface IKODAV2 {
439   function mint(address _to, uint256 _editionNumber) external returns (uint256);
440 
441   function editionExists(uint256 _editionNumber) external returns (bool);
442 
443   function totalRemaining(uint256 _editionNumber) external view returns (uint256);
444 
445   function artistCommission(uint256 _editionNumber) external view returns (address _artistAccount, uint256 _artistCommission);
446 
447   function editionOptionalCommission(uint256 _editionNumber) external view returns (uint256 _rate, address _recipient);
448 }
449 
450 // File: contracts/v2/auctions/ArtistAcceptingBidsV2.sol
451 
452 pragma solidity 0.4.24;
453 
454 
455 
456 
457 
458 /**
459 * Auction V2 interface definition - event and method definitions
460 *
461 * https://www.knownorigin.io/
462 */
463 interface IAuctionV2 {
464 
465   event BidPlaced(
466     address indexed _bidder,
467     uint256 indexed _editionNumber,
468     uint256 _amount
469   );
470 
471   event BidIncreased(
472     address indexed _bidder,
473     uint256 indexed _editionNumber,
474     uint256 _amount
475   );
476 
477   event BidWithdrawn(
478     address indexed _bidder,
479     uint256 indexed _editionNumber
480   );
481 
482   event BidAccepted(
483     address indexed _bidder,
484     uint256 indexed _editionNumber,
485     uint256 indexed _tokenId,
486     uint256 _amount
487   );
488 
489   event BidRejected(
490     address indexed _caller,
491     address indexed _bidder,
492     uint256 indexed _editionNumber,
493     uint256 _amount
494   );
495 
496   event BidderRefunded(
497     uint256 indexed _editionNumber,
498     address indexed _bidder,
499     uint256 _amount
500   );
501 
502   event AuctionCancelled(
503     uint256 indexed _editionNumber
504   );
505 
506   event AuctionEnabled(
507     uint256 indexed _editionNumber,
508     address indexed _auctioneer
509   );
510 
511   event AuctionDisabled(
512     uint256 indexed _editionNumber,
513     address indexed _auctioneer
514   );
515 
516   function placeBid(uint256 _editionNumber) payable external returns (bool success);
517 
518   function increaseBid(uint256 _editionNumber) payable external returns (bool success);
519 
520   function withdrawBid(uint256 _editionNumber) external returns (bool success);
521 
522   function acceptBid(uint256 _editionNumber) external returns (uint256 tokenId);
523 
524   function rejectBid(uint256 _editionNumber) external returns (bool success);
525 
526   function cancelAuction(uint256 _editionNumber) external returns (bool success);
527 }
528 
529 /**
530 * @title Artists accepting bidding contract for KnownOrigin (KODA)
531 *
532 * Rules:
533 * Can only bid for an edition which is enabled
534 * Can only add new bids higher than previous highest bid plus minimum bid amount
535 * Can increase your bid, only if you are the top current bidder
536 * Once outbid, original bidder has ETH returned
537 * Cannot double bid once you are already the highest bidder, can only call increaseBid()
538 * Only the defined controller address can accept the bid
539 * If a bid is revoked, the auction remains open however no highest bid exists
540 * If the contract is Paused, no public actions can happen e.g. bids, increases, withdrawals
541 * Managers of contract have full control over it act as a fallback in-case funds go missing or errors are found
542 * On accepting of any bid, funds are split to KO and Artists - optional 3rd party split not currently supported
543 * If an edition is sold out, the auction is stopped, manual refund required by bidder or whitelisted
544 * Upon cancelling a bid which is in flight, funds are returned and contract stops further bids on the edition
545 * Artists commissions and address are pulled from the KODA contract and are not based on the controller address
546 *
547 * Scenario:
548 * 1) Config artist (Dave) & edition (1000)
549 * 2) Bob places a bid on edition 1000 for 1 ETH
550 * 3) Alice places a higher bid of 1.5ETH, overriding Bobs position as the leader, sends Bobs 1 ETH back and taking 1st place
551 * 4) Dave accepts Alice's bid
552 * 5) KODA token generated and transferred to Alice, funds are split between KO and Artist
553 *
554 * https://www.knownorigin.io/
555 *
556 * BE ORIGINAL. BUY ORIGINAL.
557 */
558 contract ArtistAcceptingBidsV2 is Whitelist, Pausable, IAuctionV2 {
559   using SafeMath for uint256;
560 
561   // A mapping of the controller address to the edition number
562   mapping(uint256 => address) public editionNumberToArtistControlAddress;
563 
564   // Enabled/disable the auction for the edition number
565   mapping(uint256 => bool) public enabledEditions;
566 
567   // Edition to current highest bidders address
568   mapping(uint256 => address) public editionHighestBid;
569 
570   // Mapping for edition -> bidder -> bid amount
571   mapping(uint256 => mapping(address => uint256)) internal editionBids;
572 
573   // A simple list of editions which have been once added to this contract
574   uint256[] public editionsOnceEnabledForAuctions;
575 
576   // Min increase in bid amount
577   uint256 public minBidAmount = 0.01 ether;
578 
579   // Interface into the KODA world
580   IKODAV2 public kodaAddress;
581 
582   // KO account which can receive commission
583   address public koCommissionAccount;
584 
585   ///////////////
586   // Modifiers //
587   ///////////////
588 
589   // Checks the auction is enabled
590   modifier whenAuctionEnabled(uint256 _editionNumber) {
591     require(enabledEditions[_editionNumber], "Edition is not enabled for auctions");
592     _;
593   }
594 
595   // Checks the msg.sender is the artists control address or the auction whitelisted
596   modifier whenCallerIsController(uint256 _editionNumber) {
597     require(editionNumberToArtistControlAddress[_editionNumber] == msg.sender || whitelist(msg.sender), "Edition not managed by calling address");
598     _;
599   }
600 
601   // Checks the bid is higher than the current amount + min bid
602   modifier whenPlacedBidIsAboveMinAmount(uint256 _editionNumber) {
603     address currentHighestBidder = editionHighestBid[_editionNumber];
604     uint256 currentHighestBidderAmount = editionBids[_editionNumber][currentHighestBidder];
605     require(currentHighestBidderAmount.add(minBidAmount) <= msg.value, "Bids must be higher than previous bids plus minimum bid");
606     _;
607   }
608 
609   // Checks the bid is higher than the min bid
610   modifier whenBidIncreaseIsAboveMinAmount() {
611     require(minBidAmount <= msg.value, "Bids must be higher than minimum bid amount");
612     _;
613   }
614 
615   // Check the caller in not already the highest bidder
616   modifier whenCallerNotAlreadyTheHighestBidder(uint256 _editionNumber) {
617     address currentHighestBidder = editionHighestBid[_editionNumber];
618     require(currentHighestBidder != msg.sender, "Cant bid anymore, you are already the current highest");
619     _;
620   }
621 
622   // Checks msg.sender is the highest bidder
623   modifier whenCallerIsHighestBidder(uint256 _editionNumber) {
624     require(editionHighestBid[_editionNumber] == msg.sender, "Can only withdraw a bid if you are the highest bidder");
625     _;
626   }
627 
628   // Only when editions are not sold out in KODA
629   modifier whenEditionNotSoldOut(uint256 _editionNumber) {
630     uint256 totalRemaining = kodaAddress.totalRemaining(_editionNumber);
631     require(totalRemaining > 0, "Unable to accept any more bids, edition is sold out");
632     _;
633   }
634 
635   // Only when edition exists in KODA
636   modifier whenEditionExists(uint256 _editionNumber) {
637     bool editionExists = kodaAddress.editionExists(_editionNumber);
638     require(editionExists, "Edition does not exist");
639     _;
640   }
641 
642   /////////////////
643   // Constructor //
644   /////////////////
645 
646   // Set the caller as the default KO account
647   constructor(IKODAV2 _kodaAddress) public {
648     kodaAddress = _kodaAddress;
649     koCommissionAccount = msg.sender;
650     super.addAddressToWhitelist(msg.sender);
651   }
652 
653   //////////////////////////
654   // Core Auction Methods //
655   //////////////////////////
656 
657   /**
658    * @dev Public method for placing a bid, reverts if:
659    * - Contract is Paused
660    * - Edition provided is not valid
661    * - Edition provided is not configured for auctions
662    * - Edition provided is sold out
663    * - msg.sender is already the highest bidder
664    * - msg.value is not greater than highest bid + minimum amount
665    * @dev refunds the previous bidders ether if the bid is overwritten
666    * @return true on success
667    */
668   function placeBid(uint256 _editionNumber)
669   public
670   payable
671   whenNotPaused
672   whenEditionExists(_editionNumber)
673   whenAuctionEnabled(_editionNumber)
674   whenPlacedBidIsAboveMinAmount(_editionNumber)
675   whenCallerNotAlreadyTheHighestBidder(_editionNumber)
676   whenEditionNotSoldOut(_editionNumber)
677   returns (bool success)
678   {
679     // Grab the previous holders bid so we can refund it
680     _refundHighestBidder(_editionNumber);
681 
682     // Keep a record of the current users bid (previous bidder has been refunded)
683     editionBids[_editionNumber][msg.sender] = msg.value;
684 
685     // Update the highest bid to be the latest bidder
686     editionHighestBid[_editionNumber] = msg.sender;
687 
688     // Emit event
689     emit BidPlaced(msg.sender, _editionNumber, msg.value);
690 
691     return true;
692   }
693 
694   /**
695    * @dev Public method for increasing your bid, reverts if:
696    * - Contract is Paused
697    * - Edition provided is not valid
698    * - Edition provided is not configured for auctions
699    * - Edition provided is sold out
700    * - msg.sender is not the current highest bidder
701    * @return true on success
702    */
703   function increaseBid(uint256 _editionNumber)
704   public
705   payable
706   whenNotPaused
707   whenBidIncreaseIsAboveMinAmount
708   whenEditionExists(_editionNumber)
709   whenAuctionEnabled(_editionNumber)
710   whenEditionNotSoldOut(_editionNumber)
711   whenCallerIsHighestBidder(_editionNumber)
712   returns (bool success)
713   {
714     // Bump the current highest bid by provided amount
715     editionBids[_editionNumber][msg.sender] = editionBids[_editionNumber][msg.sender].add(msg.value);
716 
717     // Emit event
718     emit BidIncreased(msg.sender, _editionNumber, editionBids[_editionNumber][msg.sender]);
719 
720     return true;
721   }
722 
723   /**
724    * @dev Public method for withdrawing your bid, reverts if:
725    * - Contract is Paused
726    * - msg.sender is not the current highest bidder
727    * @dev removes current highest bid so there is no current highest bidder
728    * @return true on success
729    */
730   function withdrawBid(uint256 _editionNumber)
731   public
732   whenNotPaused
733   whenEditionExists(_editionNumber)
734   whenCallerIsHighestBidder(_editionNumber)
735   returns (bool success)
736   {
737     // get current highest bid and refund it
738     _refundHighestBidder(_editionNumber);
739 
740     // Fire event
741     emit BidWithdrawn(msg.sender, _editionNumber);
742 
743     return true;
744   }
745 
746   /**
747    * @dev Method for cancelling an auction, only called from contract whitelist
748    * @dev refunds previous highest bidders bid
749    * @dev removes current highest bid so there is no current highest bidder
750    * @return true on success
751    */
752   function cancelAuction(uint256 _editionNumber)
753   public
754   onlyIfWhitelisted(msg.sender)
755   whenEditionExists(_editionNumber)
756   returns (bool success)
757   {
758     // get current highest bid and refund it
759     _refundHighestBidder(_editionNumber);
760 
761     // Disable the auction
762     enabledEditions[_editionNumber] = false;
763 
764     // Fire event
765     emit AuctionCancelled(_editionNumber);
766 
767     return true;
768   }
769 
770   /**
771    * @dev Public method for increasing your bid, reverts if:
772    * - Contract is Paused
773    * - Edition provided is not valid
774    * - Edition provided is not configured for auctions
775    * - Edition provided is sold out
776    * - msg.sender is not the current highest bidder
777    * @return true on success
778    */
779   function rejectBid(uint256 _editionNumber)
780   public
781   whenNotPaused
782   whenEditionExists(_editionNumber)
783   whenCallerIsController(_editionNumber) // Checks only the controller can call this
784   whenAuctionEnabled(_editionNumber) // Checks auction is still enabled
785   returns (bool success)
786   {
787     address rejectedBidder = editionHighestBid[_editionNumber];
788     uint256 rejectedBidAmount = editionBids[_editionNumber][rejectedBidder];
789 
790     // get current highest bid and refund it
791     _refundHighestBidder(_editionNumber);
792 
793     emit BidRejected(msg.sender, rejectedBidder, _editionNumber, rejectedBidAmount);
794 
795     return true;
796   }
797 
798   /**
799    * @dev Method for accepting the highest bid, only called by edition creator, reverts if:
800    * - Contract is Paused
801    * - msg.sender is not the edition controller
802    * - Edition provided is not valid
803    * @dev Mints a new token in KODA contract
804    * @dev Splits bid amount to KO and Artist, based on KODA contract defined values
805    * @dev Removes current highest bid so there is no current highest bidder
806    * @dev If no more editions are available the auction is stopped
807    * @return the generated tokenId on success
808    */
809   function acceptBid(uint256 _editionNumber)
810   public
811   whenNotPaused
812   whenCallerIsController(_editionNumber) // Checks only the controller can call this
813   whenAuctionEnabled(_editionNumber) // Checks auction is still enabled
814   returns (uint256 tokenId)
815   {
816     // Get total remaining here so we can use it below
817     uint256 totalRemaining = kodaAddress.totalRemaining(_editionNumber);
818     require(totalRemaining > 0, "Unable to accept bid, edition is sold out");
819 
820     // Get the winner of the bidding action
821     address winningAccount = editionHighestBid[_editionNumber];
822     require(winningAccount != address(0), "Cannot win an auction when there is no highest bidder");
823 
824     uint256 winningBidAmount = editionBids[_editionNumber][winningAccount];
825     require(winningBidAmount >= 0, "Cannot win an auction when no bid amount set");
826 
827     // Mint a new token to the winner
828     uint256 _tokenId = kodaAddress.mint(winningAccount, _editionNumber);
829     require(_tokenId != 0, "Failed to mint new token");
830 
831     // Split the monies
832     _handleFunds(_editionNumber, winningBidAmount);
833 
834     // Clear out highest bidder for this auction
835     delete editionHighestBid[_editionNumber];
836 
837     // If the edition is sold out, disable the auction
838     if (totalRemaining.sub(1) == 0) {
839       enabledEditions[_editionNumber] = false;
840     }
841 
842     // Fire event
843     emit BidAccepted(winningAccount, _editionNumber, _tokenId, winningBidAmount);
844 
845     return _tokenId;
846   }
847 
848   /**
849    * Handle all splitting of funds to the artist, any optional split and KO
850    */
851   function _handleFunds(uint256 _editionNumber, uint256 _winningBidAmount) internal {
852 
853     // Get the commission and split bid amount accordingly
854     (address artistAccount, uint256 artistCommission) = kodaAddress.artistCommission(_editionNumber);
855 
856     // Extract the artists commission and send it
857     uint256 artistPayment = _winningBidAmount.div(100).mul(artistCommission);
858     artistAccount.transfer(artistPayment);
859 
860     // Optional Commission Splits
861     (uint256 optionalCommissionRate, address optionalCommissionRecipient) = kodaAddress.editionOptionalCommission(_editionNumber);
862 
863     // Apply optional commission structure if we have one
864     if (optionalCommissionRate > 0) {
865       uint256 rateSplit = _winningBidAmount.div(100).mul(optionalCommissionRate);
866       optionalCommissionRecipient.transfer(rateSplit);
867     }
868 
869     // Send KO remaining amount
870     uint256 remainingCommission = _winningBidAmount.sub(artistPayment).sub(rateSplit);
871     koCommissionAccount.transfer(remainingCommission);
872   }
873 
874   /**
875    * Returns funds of the previous highest bidder back to them if present
876    */
877   function _refundHighestBidder(uint256 _editionNumber) internal {
878     // Get current highest bidder
879     address currentHighestBidder = editionHighestBid[_editionNumber];
880 
881     // Get current highest bid amount
882     uint256 currentHighestBiddersAmount = editionBids[_editionNumber][currentHighestBidder];
883 
884     if (currentHighestBidder != address(0) && currentHighestBiddersAmount > 0) {
885 
886       // Clear out highest bidder as there is no long one
887       delete editionHighestBid[_editionNumber];
888 
889       // Refund it
890       currentHighestBidder.transfer(currentHighestBiddersAmount);
891 
892       // Emit event
893       emit BidderRefunded(_editionNumber, currentHighestBidder, currentHighestBiddersAmount);
894     }
895   }
896 
897   ///////////////////////////////
898   // Public management methods //
899   ///////////////////////////////
900 
901   /**
902    * @dev Enables the edition for auctions in a single call
903    * @dev Only callable from whitelisted account or KODA edition artists
904    */
905   function enableEditionForArtist(uint256 _editionNumber)
906   public
907   whenNotPaused
908   whenEditionExists(_editionNumber)
909   returns (bool)
910   {
911     // Ensure caller is whitelisted or artists
912     (address artistAccount, uint256 artistCommission) = kodaAddress.artistCommission(_editionNumber);
913     require(whitelist(msg.sender) || msg.sender == artistAccount, "Cannot enable when not the edition artist");
914 
915     // Ensure not already setup
916     require(!enabledEditions[_editionNumber], "Edition already enabled");
917 
918     // Enable the auction
919     enabledEditions[_editionNumber] = true;
920 
921     // keep track of the edition
922     editionsOnceEnabledForAuctions.push(_editionNumber);
923 
924     // Setup the controller address to be the artist
925     editionNumberToArtistControlAddress[_editionNumber] = artistAccount;
926 
927     emit AuctionEnabled(_editionNumber, msg.sender);
928 
929     return true;
930   }
931 
932   /**
933    * @dev Enables the edition for auctions
934    * @dev Only callable from whitelist
935    */
936   function enableEdition(uint256 _editionNumber)
937   onlyIfWhitelisted(msg.sender)
938   public returns (bool) {
939     enabledEditions[_editionNumber] = true;
940     emit AuctionEnabled(_editionNumber, msg.sender);
941     return true;
942   }
943 
944   /**
945    * @dev Disables the edition for auctions
946    * @dev Only callable from whitelist
947    */
948   function disableEdition(uint256 _editionNumber)
949   onlyIfWhitelisted(msg.sender)
950   public returns (bool) {
951     enabledEditions[_editionNumber] = false;
952     emit AuctionDisabled(_editionNumber, msg.sender);
953     return true;
954   }
955 
956   /**
957    * @dev Sets the edition artist control address
958    * @dev Only callable from whitelist
959    */
960   function setArtistsControlAddress(uint256 _editionNumber, address _address)
961   onlyIfWhitelisted(msg.sender)
962   public returns (bool) {
963     editionNumberToArtistControlAddress[_editionNumber] = _address;
964     return true;
965   }
966 
967   /**
968    * @dev Sets the edition artist control address and enables the edition for auction
969    * @dev Only callable from whitelist
970    */
971   function setArtistsControlAddressAndEnabledEdition(uint256 _editionNumber, address _address)
972   onlyIfWhitelisted(msg.sender)
973   public returns (bool) {
974     require(!enabledEditions[_editionNumber], "Edition already enabled");
975 
976     // Enable the edition
977     enabledEditions[_editionNumber] = true;
978 
979     // Setup the artist address for this edition
980     editionNumberToArtistControlAddress[_editionNumber] = _address;
981 
982     // keep track of the edition
983     editionsOnceEnabledForAuctions.push(_editionNumber);
984 
985     emit AuctionEnabled(_editionNumber, _address);
986 
987     return true;
988   }
989 
990   /**
991    * @dev Sets the minimum bid amount
992    * @dev Only callable from whitelist
993    */
994   function setMinBidAmount(uint256 _minBidAmount) onlyIfWhitelisted(msg.sender) public {
995     minBidAmount = _minBidAmount;
996   }
997 
998   /**
999    * @dev Sets the KODA address
1000    * @dev Only callable from whitelist
1001    */
1002   function setKodavV2(IKODAV2 _kodaAddress) onlyIfWhitelisted(msg.sender) public {
1003     kodaAddress = _kodaAddress;
1004   }
1005 
1006   /**
1007    * @dev Sets the KODA address
1008    * @dev Only callable from whitelist
1009    */
1010   function setKoCommissionAccount(address _koCommissionAccount) public onlyIfWhitelisted(msg.sender) {
1011     require(_koCommissionAccount != address(0), "Invalid address");
1012     koCommissionAccount = _koCommissionAccount;
1013   }
1014 
1015   /////////////////////////////
1016   // Manual Override methods //
1017   /////////////////////////////
1018 
1019   /**
1020    * @dev Allows for the ability to extract ether so we can distribute to the correct bidders accordingly
1021    * @dev Only callable from whitelist
1022    */
1023   function withdrawStuckEther(address _withdrawalAccount)
1024   onlyIfWhitelisted(msg.sender)
1025   public {
1026     require(_withdrawalAccount != address(0), "Invalid address provided");
1027     require(address(this).balance != 0, "No more ether to withdraw");
1028     _withdrawalAccount.transfer(address(this).balance);
1029   }
1030 
1031   /**
1032    * @dev Allows for the ability to extract specific ether amounts so we can distribute to the correct bidders accordingly
1033    * @dev Only callable from whitelist
1034    */
1035   function withdrawStuckEtherOfAmount(address _withdrawalAccount, uint256 _amount)
1036   onlyIfWhitelisted(msg.sender)
1037   public {
1038     require(_withdrawalAccount != address(0), "Invalid address provided");
1039     require(_amount != 0, "Invalid amount to withdraw");
1040     require(address(this).balance >= _amount, "No more ether to withdraw");
1041     _withdrawalAccount.transfer(_amount);
1042   }
1043 
1044   /**
1045    * @dev Manual override method for setting edition highest bid & the highest bidder to the provided address
1046    * @dev Only callable from whitelist
1047    */
1048   function manualOverrideEditionHighestBidAndBidder(uint256 _editionNumber, address _bidder, uint256 _amount)
1049   onlyIfWhitelisted(msg.sender)
1050   public returns (bool) {
1051     editionBids[_editionNumber][_bidder] = _amount;
1052     editionHighestBid[_editionNumber] = _bidder;
1053     return true;
1054   }
1055 
1056   /**
1057    * @dev Manual override method removing bidding values
1058    * @dev Only callable from whitelist
1059    */
1060   function manualDeleteEditionBids(uint256 _editionNumber, address _bidder)
1061   onlyIfWhitelisted(msg.sender)
1062   public returns (bool) {
1063     delete editionHighestBid[_editionNumber];
1064     delete editionBids[_editionNumber][_bidder];
1065     return true;
1066   }
1067 
1068   //////////////////////////
1069   // Public query methods //
1070   //////////////////////////
1071 
1072   /**
1073    * @dev Look up all the known data about the latest edition bidding round
1074    * @dev Returns zeros for all values when not valid
1075    */
1076   function auctionDetails(uint256 _editionNumber) public view returns (bool _enabled, address _bidder, uint256 _value, address _controller) {
1077     address highestBidder = editionHighestBid[_editionNumber];
1078     uint256 bidValue = editionBids[_editionNumber][highestBidder];
1079     address controlAddress = editionNumberToArtistControlAddress[_editionNumber];
1080     return (
1081     enabledEditions[_editionNumber],
1082     highestBidder,
1083     bidValue,
1084     controlAddress
1085     );
1086   }
1087 
1088   /**
1089    * @dev Look up all the current highest bidder for the latest edition
1090    * @dev Returns zeros for all values when not valid
1091    */
1092   function highestBidForEdition(uint256 _editionNumber) public view returns (address _bidder, uint256 _value) {
1093     address highestBidder = editionHighestBid[_editionNumber];
1094     uint256 bidValue = editionBids[_editionNumber][highestBidder];
1095     return (highestBidder, bidValue);
1096   }
1097 
1098   /**
1099    * @dev Check an edition is enabled for auction
1100    */
1101   function isEditionEnabled(uint256 _editionNumber) public view returns (bool) {
1102     return enabledEditions[_editionNumber];
1103   }
1104 
1105   /**
1106    * @dev Check which address can action a bid for the given edition
1107    */
1108   function editionController(uint256 _editionNumber) public view returns (address) {
1109     return editionNumberToArtistControlAddress[_editionNumber];
1110   }
1111 
1112   /**
1113    * @dev Returns the array of edition numbers
1114    */
1115   function addedEditions() public view returns (uint256[]) {
1116     return editionsOnceEnabledForAuctions;
1117   }
1118 
1119 }