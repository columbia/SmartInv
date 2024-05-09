1 pragma solidity ^0.4.19;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32     /**
33     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41     * @dev Adds two numbers, throws on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57     address public owner;
58 
59     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61     /**
62      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63      * account.
64      */
65     function Ownable() public {
66         owner = msg.sender;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(msg.sender == owner);
74         _;
75     }
76 
77     /**
78      * @dev Allows the current owner to transfer control of the contract to a newOwner.
79      * @param newOwner The address to transfer ownership to.
80      */
81     function transferOwnership(address newOwner) public onlyOwner {
82         require(newOwner != address(0));
83         OwnershipTransferred(owner, newOwner);
84         owner = newOwner;
85     }
86 
87 }
88 
89 
90 /**
91  * @title Pausable
92  * @dev Base contract which allows children to implement an emergency stop mechanism.
93  */
94 contract Pausable is Ownable {
95     event Pause();
96     event Unpause();
97 
98     bool public paused = false;
99 
100     /**
101      * @dev modifier to allow actions only when the contract IS paused
102      */
103     modifier whenNotPaused() {
104         require(!paused);
105         _;
106     }
107 
108     /**
109      * @dev modifier to allow actions only when the contract IS NOT paused
110      */
111     modifier whenPaused {
112         require(paused);
113         _;
114     }
115 
116     /**
117      * @dev called by the owner to pause, triggers stopped state
118      */
119     function pause()
120         public
121         onlyOwner
122         whenNotPaused
123         returns (bool)
124     {
125         paused = true;
126         Pause();
127         return true;
128     }
129 
130     /**
131      * @dev called by the owner to unpause, returns to normal state
132      */
133     function unpause()
134         public
135         onlyOwner
136         whenPaused
137         returns (bool)
138     {
139         paused = false;
140         Unpause();
141         return true;
142     }
143 }
144 
145 
146 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
147 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
148 contract ERC721 {
149     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
150     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
151 
152     // Required methods for ERC-721 Compatibility.
153     function approve(address _to, uint256 _tokenId) external;
154     function transfer(address _to, uint256 _tokenId) external;
155     function transferFrom(address _from, address _to, uint256 _tokenId) external;
156     function ownerOf(uint256 _tokenId) external view returns (address _owner);
157 
158     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
159     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
160 
161     function totalSupply() public view returns (uint256 total);
162     function balanceOf(address _owner) public view returns (uint256 _balance);
163 }
164 
165 
166 contract MasterpieceAccessControl {
167     /// - CEO: The CEO can reassign other roles, change the addresses of dependent smart contracts,
168     /// and pause/unpause the MasterpieceCore contract.
169     /// - CFO: The CFO can withdraw funds from its auction and sale contracts.
170     /// - Curator: The Curator can mint regular and promo Masterpieces.
171 
172     /// @dev The addresses of the accounts (or contracts) that can execute actions within each role.
173     address public ceoAddress;
174     address public cfoAddress;
175     address public curatorAddress;
176 
177     /// @dev Keeps track whether the contract is paused. When that is true, most actions are blocked.
178     bool public paused = false;
179 
180     /// @dev Event is fired when contract is forked.
181     event ContractFork(address newContract);
182 
183     /// @dev Access-modifier for CEO-only functionality.
184     modifier onlyCEO() {
185         require(msg.sender == ceoAddress);
186         _;
187     }
188 
189     /// @dev Access-modifier for CFO-only functionality.
190     modifier onlyCFO() {
191         require(msg.sender == cfoAddress);
192         _;
193     }
194 
195     /// @dev Access-modifier for Curator-only functionality.
196     modifier onlyCurator() {
197         require(msg.sender == curatorAddress);
198         _;
199     }
200 
201     /// @dev Access-modifier for C-level-only functionality.
202     modifier onlyCLevel() {
203         require(
204             msg.sender == ceoAddress ||
205             msg.sender == cfoAddress ||
206             msg.sender == curatorAddress
207         );
208         _;
209     }
210 
211     /// Assigns a new address to the CEO role. Only available to the current CEO.
212     /// @param _newCEO The address of the new CEO
213     function setCEO(address _newCEO) external onlyCEO {
214         require(_newCEO != address(0));
215 
216         ceoAddress = _newCEO;
217     }
218 
219     /// Assigns a new address to act as the CFO. Only available to the current CEO.
220     /// @param _newCFO The address of the new CFO
221     function setCFO(address _newCFO) external onlyCEO {
222         require(_newCFO != address(0));
223 
224         cfoAddress = _newCFO;
225     }
226 
227     /// Assigns a new address to the Curator role. Only available to the current CEO.
228     /// @param _newCurator The address of the new Curator
229     function setCurator(address _newCurator) external onlyCEO {
230         require(_newCurator != address(0));
231 
232         curatorAddress = _newCurator;
233     }
234 
235     /*** Pausable functionality adapted from OpenZeppelin ***/
236     /// @dev Modifier to allow actions only when the contract IS NOT paused
237     modifier whenNotPaused() {
238         require(!paused);
239         _;
240     }
241 
242     /// @dev Modifier to allow actions only when the contract IS paused
243     modifier whenPaused {
244         require(paused);
245         _;
246     }
247 
248     /// @dev Called by any "C-level" role to pause the contract. Used only when
249     ///  a bug or exploit is detected and we need to limit damage.
250     function pause()
251         external
252         onlyCLevel
253         whenNotPaused
254     {
255         paused = true;
256     }
257 
258     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
259     ///  one reason we may pause the contract is when CFO or COO accounts are
260     ///  compromised.
261     /// @notice This is public rather than external so it can be called by
262     ///  derived contracts.
263     function unpause()
264         public
265         onlyCEO
266         whenPaused
267     {
268         // can't unpause if contract was forked
269         paused = false;
270     }
271 
272 }
273 
274 
275 /// Core functionality for CrytpoMasterpieces.
276 contract MasterpieceBase is MasterpieceAccessControl {
277 
278     /*** DATA TYPES ***/
279     /// The main masterpiece struct.
280     struct Masterpiece {
281         /// Name of the masterpiece
282         string name;
283         /// Name of the artist who created the masterpiece
284         string artist;
285         // The timestamp from the block when this masterpiece was created
286         uint64 birthTime;
287     }
288 
289     /*** EVENTS ***/
290     /// The Birth event is fired whenever a new masterpiece comes into existence.
291     event Birth(address owner, uint256 tokenId, uint256 snatchWindow, string name, string artist);
292     /// Transfer event as defined in current draft of ERC721. Fired every time masterpiece ownership
293     /// is assigned, including births.
294     event TransferToken(address from, address to, uint256 tokenId);
295     /// The TokenSold event is fired whenever a token is sold.
296     event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 price, address prevOwner, address owner, string name);
297 
298     /*** STORAGE ***/
299     /// An array containing all Masterpieces in existence. The id of each masterpiece
300     /// is an index in this array.
301     Masterpiece[] masterpieces;
302 
303     /// @dev The address of the ClockAuction contract that handles sale auctions
304     /// for Masterpieces that users want to sell for less than or equal to the
305     /// next price, which is automatically set by the contract.
306     SaleClockAuction public saleAuction;
307 
308     /// @dev A mapping from masterpiece ids to the address that owns them.
309     mapping (uint256 => address) public masterpieceToOwner;
310 
311     /// @dev A mapping from masterpiece ids to their snatch window.
312     mapping (uint256 => uint256) public masterpieceToSnatchWindow;
313 
314     /// @dev A mapping from owner address to count of masterpieces that address owns.
315     /// Used internally inside balanceOf() to resolve ownership count.
316     mapping (address => uint256) public ownerMasterpieceCount;
317 
318     /// @dev A mapping from masterpiece ids to an address that has been approved to call
319     ///  transferFrom(). Each masterpiece can only have 1 approved address for transfer
320     ///  at any time. A 0 value means no approval is outstanding.
321     mapping (uint256 => address) public masterpieceToApproved;
322 
323     // @dev A mapping from masterpiece ids to their price.
324     mapping (uint256 => uint256) public masterpieceToPrice;
325 
326     // @dev Returns the snatch window of the given token.
327     function snatchWindowOf(uint256 _tokenId)
328         public
329         view
330         returns (uint256 price)
331     {
332         return masterpieceToSnatchWindow[_tokenId];
333     }
334 
335     /// @dev Assigns ownership of a specific masterpiece to an address.
336     function _transfer(address _from, address _to, uint256 _tokenId) internal {
337         // Transfer ownership and update owner masterpiece counts.
338         ownerMasterpieceCount[_to]++;
339         masterpieceToOwner[_tokenId] = _to;
340         // When creating new tokens _from is 0x0, but we can't account that address.
341         if (_from != address(0)) {
342             ownerMasterpieceCount[_from]--;
343             // clear any previously approved ownership exchange
344             delete masterpieceToApproved[_tokenId];
345         }
346         // Fire the transfer event.
347         TransferToken(_from, _to, _tokenId);
348     }
349 
350     /// @dev An internal method that creates a new masterpiece and stores it.
351     /// @param _name The name of the masterpiece, e.g. Mona Lisa
352     /// @param _artist The artist who created this masterpiece, e.g. Leonardo Da Vinci
353     /// @param _owner The initial owner of this masterpiece
354     function _createMasterpiece(
355         string _name,
356         string _artist,
357         uint256 _price,
358         uint256 _snatchWindow,
359         address _owner
360     )
361         internal
362         returns (uint)
363     {
364         Masterpiece memory _masterpiece = Masterpiece({
365             name: _name,
366             artist: _artist,
367             birthTime: uint64(now)
368         });
369         uint256 newMasterpieceId = masterpieces.push(_masterpiece) - 1;
370 
371         // Fire the birth event.
372         Birth(
373             _owner,
374             newMasterpieceId,
375             _snatchWindow,
376             _masterpiece.name,
377             _masterpiece.artist
378         );
379 
380         // Set the price for the masterpiece.
381         masterpieceToPrice[newMasterpieceId] = _price;
382 
383         // Set the snatch window for the masterpiece.
384         masterpieceToSnatchWindow[newMasterpieceId] = _snatchWindow;
385 
386         // This will assign ownership, and also fire the Transfer event as per ERC-721 draft.
387         _transfer(0, _owner, newMasterpieceId);
388 
389         return newMasterpieceId;
390     }
391 
392 }
393 
394 
395 /// Pricing logic for CrytpoMasterpieces.
396 contract MasterpiecePricing is MasterpieceBase {
397 
398     /*** CONSTANTS ***/
399     // Pricing steps.
400     uint128 private constant FIRST_STEP_LIMIT = 0.05 ether;
401     uint128 private constant SECOND_STEP_LIMIT = 0.5 ether;
402     uint128 private constant THIRD_STEP_LIMIT = 2.0 ether;
403     uint128 private constant FOURTH_STEP_LIMIT = 5.0 ether;
404 
405     /// @dev Computes the next listed price.
406     /// @notice This contract doesn't handle setting the Masterpiece's next listing price.
407     /// This next price is only used from inside bid() in MasterpieceAuction and inside
408     /// purchase() in MasterpieceSale to set the next listed price.
409     function setNextPriceOf(uint256 tokenId, uint256 salePrice)
410         external
411         whenNotPaused
412     {
413         // The next price of any token can only be set by the sale auction contract.
414         // To set the next price for a token sold through the regular sale, use only
415         // computeNextPrice and directly update the mapping.
416         require(msg.sender == address(saleAuction));
417         masterpieceToPrice[tokenId] = computeNextPrice(salePrice);
418     }
419 
420     /// @dev Computes next price of token given the current sale price.
421     function computeNextPrice(uint256 salePrice)
422         internal
423         pure
424         returns (uint256)
425     {
426         if (salePrice < FIRST_STEP_LIMIT) {
427             return SafeMath.div(SafeMath.mul(salePrice, 200), 95);
428         } else if (salePrice < SECOND_STEP_LIMIT) {
429             return SafeMath.div(SafeMath.mul(salePrice, 135), 96);
430         } else if (salePrice < THIRD_STEP_LIMIT) {
431             return SafeMath.div(SafeMath.mul(salePrice, 125), 97);
432         } else if (salePrice < FOURTH_STEP_LIMIT) {
433             return SafeMath.div(SafeMath.mul(salePrice, 120), 97);
434         } else {
435             return SafeMath.div(SafeMath.mul(salePrice, 115), 98);
436         }
437     }
438 
439     /// @dev Computes the payment for the token, which is the sale price of the token
440     /// minus the house's cut.
441     function computePayment(uint256 salePrice)
442         internal
443         pure
444         returns (uint256)
445     {
446         if (salePrice < FIRST_STEP_LIMIT) {
447             return SafeMath.div(SafeMath.mul(salePrice, 95), 100);
448         } else if (salePrice < SECOND_STEP_LIMIT) {
449             return SafeMath.div(SafeMath.mul(salePrice, 96), 100);
450         } else if (salePrice < FOURTH_STEP_LIMIT) {
451             return SafeMath.div(SafeMath.mul(salePrice, 97), 100);
452         } else {
453             return SafeMath.div(SafeMath.mul(salePrice, 98), 100);
454         }
455     }
456 
457 }
458 
459 
460 /// Methods required for Non-Fungible Token Transactions in adherence to ERC721.
461 contract MasterpieceOwnership is MasterpiecePricing, ERC721 {
462 
463     /// Name of the collection of NFTs managed by this contract, as defined in ERC721.
464     string public constant NAME = "Masterpieces";
465     /// Symbol referencing the entire collection of NFTs managed in this contract, as
466     /// defined in ERC721.
467     string public constant SYMBOL = "CMP";
468 
469     bytes4 public constant INTERFACE_SIGNATURE_ERC165 =
470     bytes4(keccak256("supportsInterface(bytes4)"));
471 
472     bytes4 public constant INTERFACE_SIGNATURE_ERC721 =
473     bytes4(keccak256("name()")) ^
474     bytes4(keccak256("symbol()")) ^
475     bytes4(keccak256("totalSupply()")) ^
476     bytes4(keccak256("balanceOf(address)")) ^
477     bytes4(keccak256("ownerOf(uint256)")) ^
478     bytes4(keccak256("approve(address,uint256)")) ^
479     bytes4(keccak256("transfer(address,uint256)")) ^
480     bytes4(keccak256("transferFrom(address,address,uint256)")) ^
481     bytes4(keccak256("tokensOfOwner(address)")) ^
482     bytes4(keccak256("tokenMetadata(uint256,string)"));
483 
484     /// @dev Grant another address the right to transfer a specific Masterpiece via
485     ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
486     /// @param _to The address to be granted transfer approval. Pass address(0) to
487     ///  clear all approvals.
488     /// @param _tokenId The ID of the Masterpiece that can be transferred if this call succeeds.
489     /// @notice Required for ERC-20 and ERC-721 compliance.
490     function approve(address _to, uint256 _tokenId)
491         external
492         whenNotPaused
493     {
494         // Only an owner can grant transfer approval.
495         require(_owns(msg.sender, _tokenId));
496 
497         // Register the approval (replacing any previous approval).
498         _approve(_tokenId, _to);
499 
500         // Fire approval event upon successful approval.
501         Approval(msg.sender, _to, _tokenId);
502     }
503 
504     /// @dev Transfers a Masterpiece to another address. If transferring to a smart
505     ///  contract be VERY CAREFUL to ensure that it is aware of ERC-721 or else your
506     /// Masterpiece may be lost forever.
507     /// @param _to The address of the recipient, can be a user or contract.
508     /// @param _tokenId The ID of the Masterpiece to transfer.
509     /// @notice Required for ERC-20 and ERC-721 compliance.
510     function transfer(address _to, uint256 _tokenId)
511         external
512         whenNotPaused
513     {
514         // Safety check to prevent against an unexpected 0x0 default.
515         require(_to != address(0));
516         // Disallow transfers to this contract to prevent accidental misuse.
517         // The contract should never own any Masterpieces (except very briefly
518         // after a Masterpiece is created.
519         require(_to != address(this));
520         // Disallow transfers to the auction contract to prevent accidental
521         // misuse. Auction contracts should only take ownership of Masterpieces
522         // through the approve and transferFrom flow.
523         require(_to != address(saleAuction));
524         // You can only send your own Masterpiece.
525         require(_owns(msg.sender, _tokenId));
526 
527         // Reassign ownership, clear pending approvals, fire Transfer event.
528         _transfer(msg.sender, _to, _tokenId);
529     }
530 
531     /// @dev Transfer a Masterpiece owned by another address, for which the calling address
532     ///  has previously been granted transfer approval by the owner.
533     /// @param _from The address that owns the Masterpiece to be transfered.
534     /// @param _to The address that should take ownership of the Masterpiece. Can be any
535     /// address, including the caller.
536     /// @param _tokenId The ID of the Masterpiece to be transferred.
537     /// @notice Required for ERC-20 and ERC-721 compliance.
538     function transferFrom(address _from, address _to, uint256 _tokenId)
539         external
540         whenNotPaused
541     {
542         // Safety check to prevent against an unexpected 0x0 default.
543         require(_to != address(0));
544         // Check for approval and valid ownership
545         require(_approvedFor(msg.sender, _tokenId));
546         require(_owns(_from, _tokenId));
547 
548         // Reassign ownership (also clears pending approvals and fires Transfer event).
549         _transfer(_from, _to, _tokenId);
550     }
551 
552     /// @dev Returns a list of all Masterpiece IDs assigned to an address.
553     /// @param _owner The owner whose Masterpieces we are interested in.
554     ///  This method MUST NEVER be called by smart contract code. First, it is fairly
555     ///  expensive (it walks the entire Masterpiece array looking for Masterpieces belonging
556     /// to owner), but it also returns a dynamic array, which is only supported for web3
557     /// calls, and not contract-to-contract calls. Thus, this method is external rather
558     /// than public.
559     function tokensOfOwner(address _owner)
560         external
561         view
562         returns(uint256[] ownerTokens)
563     {
564         uint256 tokenCount = balanceOf(_owner);
565 
566         if (tokenCount == 0) {
567             // Returns an empty array
568             return new uint256[](0);
569         } else {
570             uint256[] memory result = new uint256[](tokenCount);
571             uint256 totalMasterpieces = totalSupply();
572             uint256 resultIndex = 0;
573 
574             uint256 masterpieceId;
575             for (masterpieceId = 0; masterpieceId <= totalMasterpieces; masterpieceId++) {
576                 if (masterpieceToOwner[masterpieceId] == _owner) {
577                     result[resultIndex] = masterpieceId;
578                     resultIndex++;
579                 }
580             }
581 
582             return result;
583         }
584     }
585 
586     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
587     ///  Returns true for any standardized interfaces implemented by this contract. We implement
588     ///  ERC-165 (obviously!) and ERC-721.
589     function supportsInterface(bytes4 _interfaceID)
590         external
591         view
592         returns (bool)
593     {
594         return ((_interfaceID == INTERFACE_SIGNATURE_ERC165) || (_interfaceID == INTERFACE_SIGNATURE_ERC721));
595     }
596 
597     // @notice Optional for ERC-20 compliance.
598     function name() external pure returns (string) {
599         return NAME;
600     }
601 
602     // @notice Optional for ERC-20 compliance.
603     function symbol() external pure returns (string) {
604         return SYMBOL;
605     }
606 
607     /// @dev Returns the address currently assigned ownership of a given Masterpiece.
608     /// @notice Required for ERC-721 compliance.
609     function ownerOf(uint256 _tokenId)
610         external
611         view
612         returns (address owner)
613     {
614         owner = masterpieceToOwner[_tokenId];
615         require(owner != address(0));
616     }
617 
618     /// @dev Returns the total number of Masterpieces currently in existence.
619     /// @notice Required for ERC-20 and ERC-721 compliance.
620     function totalSupply() public view returns (uint) {
621         return masterpieces.length;
622     }
623 
624     /// @dev Returns the number of Masterpieces owned by a specific address.
625     /// @param _owner The owner address to check.
626     /// @notice Required for ERC-20 and ERC-721 compliance.
627     function balanceOf(address _owner)
628         public
629         view
630         returns (uint256 count)
631     {
632         return ownerMasterpieceCount[_owner];
633     }
634 
635     /// @dev Checks if a given address is the current owner of a particular Masterpiece.
636     /// @param _claimant the address we are validating against.
637     /// @param _tokenId Masterpiece id, only valid when > 0
638     function _owns(address _claimant, uint256 _tokenId)
639         internal
640         view
641         returns (bool)
642     {
643         return masterpieceToOwner[_tokenId] == _claimant;
644     }
645 
646     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
647     /// approval. Setting _approved to address(0) clears all transfer approval.
648     /// NOTE: _approve() does NOT send the Approval event. This is intentional because
649     /// _approve() and transferFrom() are used together for putting Masterpieces on auction, and
650     /// there is no value in spamming the log with Approval events in that case.
651     function _approve(uint256 _tokenId, address _approved) internal {
652         masterpieceToApproved[_tokenId] = _approved;
653     }
654 
655     /// @dev Checks if a given address currently has transferApproval for a particular Masterpiece.
656     /// @param _claimant the address we are confirming Masterpiece is approved for.
657     /// @param _tokenId Masterpiece id, only valid when > 0
658     function _approvedFor(address _claimant, uint256 _tokenId)
659         internal
660         view
661         returns (bool)
662     {
663         return masterpieceToApproved[_tokenId] == _claimant;
664     }
665 
666     /// Safety check on _to address to prevent against an unexpected 0x0 default.
667     function _addressNotNull(address _to) internal pure returns (bool) {
668         return _to != address(0);
669     }
670 }
671 
672 
673 /// @title Auction Core
674 /// @dev Contains models, variables, and internal methods for the auction.
675 /// @notice We omit a fallback function to prevent accidental sends to this contract.
676 contract ClockAuctionBase {
677 
678     // Represents an auction on an NFT
679     struct Auction {
680         // Current owner of NFT
681         address seller;
682         // Price (in wei) at beginning of auction
683         uint128 startingPrice;
684         // Price (in wei) at end of auction
685         uint128 endingPrice;
686         // Duration (in seconds) of auction
687         uint64 duration;
688         // Time when auction started
689         // NOTE: 0 if this auction has been concluded
690         uint64 startedAt;
691     }
692 
693     // Reference to contract tracking NFT ownership
694     MasterpieceOwnership public nonFungibleContract;
695 
696     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
697     // Values 0-10,000 map to 0%-100%
698     uint256 public ownerCut;
699 
700     // Map from token ID to their corresponding auction.
701     mapping (uint256 => Auction) public tokenIdToAuction;
702 
703     event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
704     event AuctionSuccessful(uint256 tokenId, uint256 price, address winner);
705     event AuctionCancelled(uint256 tokenId);
706 
707     /// @dev Returns true if the claimant owns the token.
708     /// @param _claimant - Address claiming to own the token.
709     /// @param _tokenId - ID of token whose ownership to verify.
710     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
711         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
712     }
713 
714     /// @dev Escrows the NFT, assigning ownership to this contract.
715     /// Throws if the escrow fails.
716     /// @param _owner - Current owner address of token to escrow.
717     /// @param _tokenId - ID of token whose approval to verify.
718     function _escrow(address _owner, uint256 _tokenId) internal {
719         // it will throw if transfer fails
720         nonFungibleContract.transferFrom(_owner, this, _tokenId);
721     }
722 
723     /// @dev Transfers an NFT owned by this contract to another address.
724     /// Returns true if the transfer succeeds.
725     /// @param _receiver - Address to transfer NFT to.
726     /// @param _tokenId - ID of token to transfer.
727     function _transfer(address _receiver, uint256 _tokenId) internal {
728         // it will throw if transfer fails
729         nonFungibleContract.transfer(_receiver, _tokenId);
730     }
731 
732     /// @dev Adds an auction to the list of open auctions. Also fires the
733     ///  AuctionCreated event.
734     /// @param _tokenId The ID of the token to be put on auction.
735     /// @param _auction Auction to add.
736     function _addAuction(uint256 _tokenId, Auction _auction) internal {
737         // Require that all auctions have a duration of
738         // at least one minute. (Keeps our math from getting hairy!)
739         require(_auction.duration >= 1 minutes);
740 
741         tokenIdToAuction[_tokenId] = _auction;
742 
743         AuctionCreated(
744             uint256(_tokenId),
745             uint256(_auction.startingPrice),
746             uint256(_auction.endingPrice),
747             uint256(_auction.duration)
748         );
749     }
750 
751     /// @dev Cancels an auction unconditionally.
752     function _cancelAuction(uint256 _tokenId, address _seller) internal {
753         _removeAuction(_tokenId);
754         _transfer(_seller, _tokenId);
755         AuctionCancelled(_tokenId);
756     }
757 
758     /// @dev Computes the price and transfers winnings.
759     /// Does NOT transfer ownership of token.
760     function _bid(uint256 _tokenId, uint256 _bidAmount)
761         internal
762         returns (uint256)
763     {
764         // Get a reference to the auction struct
765         Auction storage auction = tokenIdToAuction[_tokenId];
766         // Explicitly check that this auction is currently live.
767         // (Because of how Ethereum mappings work, we can't just count
768         // on the lookup above failing. An invalid _tokenId will just
769         // return an auction object that is all zeros.)
770         require(_isOnAuction(auction));
771         // Check that the bid is greater than or equal to the current price
772         uint256 price = _currentPrice(auction);
773         require(_bidAmount >= price);
774         // Grab a reference to the seller before the auction struct gets deleted.
775         address seller = auction.seller;
776         // Remove the auction before sending the fees to the sender so we can't have a reentrancy attack.
777         _removeAuction(_tokenId);
778         if (price > 0) {
779             // Calculate the auctioneer's cut.
780             uint256 auctioneerCut = _computeCut(price);
781             uint256 sellerProceeds = price - auctioneerCut;
782             // NOTE: Doing a transfer() in the middle of a complex
783             // method like this is generally discouraged because of
784             // reentrancy attacks and DoS attacks if the seller is
785             // a contract with an invalid fallback function. We explicitly
786             // guard against reentrancy attacks by removing the auction
787             // before calling transfer(), and the only thing the seller
788             // can DoS is the sale of their own asset! (And if it's an
789             // accident, they can call cancelAuction(). )
790             seller.transfer(sellerProceeds);
791             _transfer(msg.sender, _tokenId);
792             // Update the next listing price of the token.
793             nonFungibleContract.setNextPriceOf(_tokenId, price);
794         }
795 
796         // Calculate any excess funds included with the bid. If the excess
797         // is anything worth worrying about, transfer it back to bidder.
798         // NOTE: We checked above that the bid amount is greater than or
799         // equal to the price so this cannot underflow.
800         uint256 bidExcess = _bidAmount - price;
801 
802         // Return the funds. Similar to the previous transfer, this is
803         // not susceptible to a re-entry attack because the auction is
804         // removed before any transfers occur.
805         msg.sender.transfer(bidExcess);
806 
807         // Tell the world!
808         AuctionSuccessful(_tokenId, price, msg.sender);
809 
810         return price;
811     }
812 
813     /// @dev Removes an auction from the list of open auctions.
814     /// @param _tokenId - ID of NFT on auction.
815     function _removeAuction(uint256 _tokenId) internal {
816         delete tokenIdToAuction[_tokenId];
817     }
818 
819     /// @dev Returns true if the NFT is on auction.
820     /// @param _auction - Auction to check.
821     function _isOnAuction(Auction storage _auction)
822         internal
823         view
824         returns (bool)
825     {
826         return (_auction.startedAt > 0);
827     }
828 
829     /// @dev Returns current price of an NFT on auction. Broken into two
830     ///  functions (this one, that computes the duration from the auction
831     ///  structure, and the other that does the price computation) so we
832     ///  can easily test that the price computation works correctly.
833     function _currentPrice(Auction storage _auction)
834         internal
835         view
836         returns (uint256)
837     {
838         uint256 secondsPassed = 0;
839 
840         // A bit of insurance against negative values (or wraparound).
841         // Probably not necessary (since Ethereum guarnatees that the
842         // now variable doesn't ever go backwards).
843         if (now > _auction.startedAt) {
844             secondsPassed = now - _auction.startedAt;
845         }
846 
847         return _computeCurrentPrice(
848             _auction.startingPrice,
849             _auction.endingPrice,
850             _auction.duration,
851             secondsPassed
852         );
853     }
854 
855     /// @dev Computes the current price of an auction. Factored out
856     ///  from _currentPrice so we can run extensive unit tests.
857     ///  When testing, make this function public and turn on
858     ///  `Current price computation` test suite.
859     function _computeCurrentPrice(
860         uint256 _startingPrice,
861         uint256 _endingPrice,
862         uint256 _duration,
863         uint256 _secondsPassed
864     )
865         internal
866         pure
867         returns (uint256)
868     {
869         // NOTE: We don't use SafeMath (or similar) in this function because
870         //  all of our public functions carefully cap the maximum values for
871         //  time (at 64-bits) and currency (at 128-bits). _duration is
872         //  also known to be non-zero (see the require() statement in
873         //  _addAuction())
874         if (_secondsPassed >= _duration) {
875             // We've reached the end of the dynamic pricing portion
876             // of the auction, just return the end price.
877             return _endingPrice;
878         } else {
879             // Starting price can be higher than ending price (and often is!), so
880             // this delta can be negative.
881             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
882 
883             // This multiplication can't overflow, _secondsPassed will easily fit within
884             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
885             // will always fit within 256-bits.
886             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
887 
888             // currentPriceChange can be negative, but if so, will have a magnitude
889             // less that _startingPrice. Thus, this result will always end up positive.
890             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
891 
892             return uint256(currentPrice);
893         }
894     }
895 
896     /// @dev Computes owner's cut of a sale.
897     /// @param _price - Sale price of NFT.
898     function _computeCut(uint256 _price) internal view returns (uint256) {
899         // NOTE: We don't use SafeMath (or similar) in this function because
900         //  all of our entry functions carefully cap the maximum values for
901         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
902         //  statement in the ClockAuction constructor). The result of this
903         //  function is always guaranteed to be <= _price.
904         return _price * ownerCut / 10000;
905     }
906 
907 }
908 
909 
910 /// @title Clock auction for non-fungible tokens.
911 /// @notice We omit a fallback function to prevent accidental sends to this contract.
912 contract ClockAuction is Pausable, ClockAuctionBase {
913 
914     /// @dev The ERC-165 interface signature for ERC-721.
915     ///  Ref: https://github.com/ethereum/EIPs/issues/165
916     ///  Ref: https://github.com/ethereum/EIPs/issues/721
917     bytes4 public constant INTERFACE_SIGNATURE_ERC721 = bytes4(0x9a20483d);
918 
919     /// @dev Constructor creates a reference to the NFT ownership contract
920     ///  and verifies the owner cut is in the valid range.
921     /// @param _nftAddress - address of a deployed contract implementing
922     ///  the Nonfungible Interface.
923     /// @param _cut - percent cut the owner takes on each auction, must be
924     ///  between 0-10,000.
925     function ClockAuction(address _nftAddress, uint256 _cut) public {
926         require(_cut <= 10000);
927         ownerCut = _cut;
928 
929         MasterpieceOwnership candidateContract = MasterpieceOwnership(_nftAddress);
930         require(candidateContract.supportsInterface(INTERFACE_SIGNATURE_ERC721));
931         nonFungibleContract = candidateContract;
932     }
933 
934     /// @dev Remove all Ether from the contract, which is the owner's cuts
935     ///  as well as any Ether sent directly to the contract address.
936     ///  Always transfers to the NFT contract, but can be called either by
937     ///  the owner or the NFT contract.
938     function withdrawBalance() external {
939         address nftAddress = address(nonFungibleContract);
940 
941         require(
942             msg.sender == owner ||
943             msg.sender == nftAddress
944         );
945         // We are using this boolean method to make sure that even if one fails it will still work
946         bool res = nftAddress.send(this.balance);
947     }
948 
949     /// @dev Creates and begins a new auction.
950     /// @param _tokenId - ID of token to auction, sender must be owner.
951     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
952     /// @param _endingPrice - Price of item (in wei) at end of auction.
953     /// @param _duration - Length of time to move between starting
954     ///  price and ending price (in seconds).
955     /// @param _seller - Seller, if not the message sender
956     function createAuction(
957         uint256 _tokenId,
958         uint256 _startingPrice,
959         uint256 _endingPrice,
960         uint256 _duration,
961         address _seller
962     )
963         external
964         whenNotPaused
965     {
966         // Sanity check that no inputs overflow how many bits we've allocated
967         // to store them in the auction struct.
968         require(_startingPrice == uint256(uint128(_startingPrice)));
969         require(_endingPrice == uint256(uint128(_endingPrice)));
970         require(_duration == uint256(uint64(_duration)));
971 
972         require(_owns(msg.sender, _tokenId));
973         _escrow(msg.sender, _tokenId);
974         Auction memory auction = Auction(
975             _seller,
976             uint128(_startingPrice),
977             uint128(_endingPrice),
978             uint64(_duration),
979             uint64(now)
980         );
981         _addAuction(_tokenId, auction);
982     }
983 
984     /// @dev Bids on an open auction, completing the auction and transferring
985     ///  ownership of the NFT if enough Ether is supplied.
986     /// @param _tokenId - ID of token to bid on.
987     function bid(uint256 _tokenId)
988         external
989         payable
990         whenNotPaused
991     {
992         // _bid will throw if the bid or funds transfer fails
993         _bid(_tokenId, msg.value);
994     }
995 
996     /// @dev Cancels an auction that hasn't been won yet.
997     ///  Returns the NFT to original owner.
998     /// @notice This is a state-modifying function that can
999     ///  be called while the contract is paused.
1000     /// @param _tokenId - ID of token on auction
1001     function cancelAuction(uint256 _tokenId)
1002         external
1003     {
1004         Auction storage auction = tokenIdToAuction[_tokenId];
1005         require(_isOnAuction(auction));
1006         address seller = auction.seller;
1007         require(msg.sender == seller);
1008         _cancelAuction(_tokenId, seller);
1009     }
1010 
1011     /// @dev Cancels an auction when the contract is paused.
1012     ///  Only the owner may do this, and NFTs are returned to
1013     ///  the seller. This should only be used in emergencies.
1014     /// @param _tokenId - ID of the NFT on auction to cancel.
1015     function cancelAuctionWhenPaused(uint256 _tokenId)
1016         external
1017         whenPaused
1018         onlyOwner
1019     {
1020         Auction storage auction = tokenIdToAuction[_tokenId];
1021         require(_isOnAuction(auction));
1022         _cancelAuction(_tokenId, auction.seller);
1023     }
1024 
1025     /// @dev Returns auction info for an NFT on auction.
1026     /// @param _tokenId - ID of NFT on auction.
1027     function getAuction(uint256 _tokenId)
1028         external
1029         view
1030         returns
1031     (
1032         address seller,
1033         uint256 startingPrice,
1034         uint256 endingPrice,
1035         uint256 duration,
1036         uint256 startedAt
1037     ) {
1038             Auction storage auction = tokenIdToAuction[_tokenId];
1039             require(_isOnAuction(auction));
1040             return (
1041                 auction.seller,
1042                 auction.startingPrice,
1043                 auction.endingPrice,
1044                 auction.duration,
1045                 auction.startedAt
1046             );
1047         }
1048 
1049     /// @dev Returns the current price of an auction.
1050     /// @param _tokenId - ID of the token price we are checking.
1051     function getCurrentPrice(uint256 _tokenId)
1052         external
1053         view
1054         returns (uint256)
1055     {
1056         Auction storage auction = tokenIdToAuction[_tokenId];
1057         require(_isOnAuction(auction));
1058         return _currentPrice(auction);
1059     }
1060 
1061 }
1062 
1063 
1064 /// @title Clock auction
1065 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1066 contract SaleClockAuction is ClockAuction {
1067 
1068     // @dev Sanity check that allows us to ensure that we are pointing to the
1069     //  right auction in our setSaleAuctionAddress() call.
1070     bool public isSaleClockAuction = true;
1071 
1072     // Delegate constructor
1073     function SaleClockAuction(address _nftAddr, uint256 _cut) public
1074         ClockAuction(_nftAddr, _cut) {}
1075 
1076     /// @dev Creates and begins a new auction.
1077     /// @param _tokenId - ID of token to auction, sender must be owner.
1078     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
1079     /// @param _endingPrice - Price of item (in wei) at end of auction.
1080     /// @param _duration - Length of auction (in seconds).
1081     /// @param _seller - Seller, if not the message sender
1082     function createAuction(
1083         uint256 _tokenId,
1084         uint256 _startingPrice,
1085         uint256 _endingPrice,
1086         uint256 _duration,
1087         address _seller
1088     )
1089         external
1090     {
1091         // Sanity check that no inputs overflow how many bits we've allocated
1092         // to store them in the auction struct.
1093         require(_startingPrice == uint256(uint128(_startingPrice)));
1094         require(_endingPrice == uint256(uint128(_endingPrice)));
1095         require(_duration == uint256(uint64(_duration)));
1096 
1097         require(msg.sender == address(nonFungibleContract));
1098         _escrow(_seller, _tokenId);
1099         Auction memory auction = Auction(
1100             _seller,
1101             uint128(_startingPrice),
1102             uint128(_endingPrice),
1103             uint64(_duration),
1104             uint64(now)
1105         );
1106         _addAuction(_tokenId, auction);
1107     }
1108 
1109     /// @dev Places a bid for the Masterpiece. Requires the sender
1110     /// is the Masterpiece Core contract because all bid methods
1111     /// should be wrapped.
1112     function bid(uint256 _tokenId)
1113         external
1114         payable
1115     {
1116         /* require(msg.sender == address(nonFungibleContract)); */
1117         // _bid checks that token ID is valid and will throw if bid fails
1118         _bid(_tokenId, msg.value);
1119     }
1120 }
1121 
1122 
1123 contract MasterpieceAuction is MasterpieceOwnership {
1124 
1125     /// @dev Transfers the balance of the sale auction contract
1126     /// to the MasterpieceCore contract. We use two-step withdrawal to
1127     /// prevent two transfer calls in the auction bid function.
1128     function withdrawAuctionBalances()
1129         external
1130         onlyCLevel
1131     {
1132         saleAuction.withdrawBalance();
1133     }
1134 
1135     /// @notice The auction contract variable (saleAuction) is defined in MasterpieceBase
1136     /// to allow us to refer to them in MasterpieceOwnership to prevent accidental transfers.
1137     /// @dev Sets the reference to the sale auction.
1138     /// @param _address - Address of sale contract.
1139     function setSaleAuctionAddress(address _address)
1140         external
1141         onlyCEO
1142     {
1143         SaleClockAuction candidateContract = SaleClockAuction(_address);
1144 
1145         // NOTE: verify that a contract is what we expect -
1146         // https://github.com/Lunyr/crowdsale-contracts/blob/
1147         // cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
1148         require(candidateContract.isSaleClockAuction());
1149 
1150         // Set the new contract address
1151         saleAuction = candidateContract;
1152     }
1153 
1154     /// @dev The owner of a Masterpiece can put it up for auction.
1155     function createSaleAuction(
1156         uint256 _tokenId,
1157         uint256 _startingPrice,
1158         uint256 _endingPrice,
1159         uint256 _duration
1160     )
1161         external
1162         whenNotPaused
1163     {
1164         // Check that the Masterpiece to be put on an auction sale is owned by
1165         // its current owner. If it's already in an auction, this validation
1166         // will fail because the MasterpieceAuction contract owns the
1167         // Masterpiece once it is put on an auction sale.
1168         require(_owns(msg.sender, _tokenId));
1169         _approve(_tokenId, saleAuction);
1170         // Sale auction throws if inputs are invalid and clears
1171         // transfer approval after escrow
1172         saleAuction.createAuction(
1173             _tokenId,
1174             _startingPrice,
1175             _endingPrice,
1176             _duration,
1177             msg.sender
1178         );
1179     }
1180 
1181 }
1182 
1183 
1184 contract MasterpieceSale is MasterpieceAuction {
1185 
1186     // Allows someone to send ether and obtain the token
1187     function purchase(uint256 _tokenId)
1188         public
1189         payable
1190         whenNotPaused
1191     {
1192         address newOwner = msg.sender;
1193         address oldOwner = masterpieceToOwner[_tokenId];
1194         uint256 salePrice = masterpieceToPrice[_tokenId];
1195 
1196         // Require that the masterpiece is either currently owned by the Masterpiece
1197         // Core contract or was born within the snatch window.
1198         require(
1199             (oldOwner == address(this)) ||
1200             (now - masterpieces[_tokenId].birthTime <= masterpieceToSnatchWindow[_tokenId])
1201         );
1202 
1203         // Require that the owner of the token is not sending to self.
1204         require(oldOwner != newOwner);
1205 
1206         // Require that the Masterpiece is not in an auction by checking that
1207         // the Sale Clock Auction contract is not the owner.
1208         require(address(oldOwner) != address(saleAuction));
1209 
1210         // Safety check to prevent against an unexpected 0x0 default.
1211         require(_addressNotNull(newOwner));
1212 
1213         // Check that sent amount is greater than or equal to the sale price
1214         require(msg.value >= salePrice);
1215 
1216         uint256 payment = uint256(computePayment(salePrice));
1217         uint256 purchaseExcess = SafeMath.sub(msg.value, salePrice);
1218 
1219         // Set next listing price.
1220         masterpieceToPrice[_tokenId] = computeNextPrice(salePrice);
1221 
1222         // Transfer the Masterpiece to the buyer.
1223         _transfer(oldOwner, newOwner, _tokenId);
1224 
1225         // Pay seller of the Masterpiece if they are not this contract.
1226         if (oldOwner != address(this)) {
1227             oldOwner.transfer(payment);
1228         }
1229 
1230         TokenSold(_tokenId, salePrice, masterpieceToPrice[_tokenId], oldOwner, newOwner, masterpieces[_tokenId].name);
1231 
1232         // Reimburse the buyer of any excess paid.
1233         msg.sender.transfer(purchaseExcess);
1234     }
1235 
1236     function priceOf(uint256 _tokenId)
1237         public
1238         view
1239         returns (uint256 price)
1240     {
1241         return masterpieceToPrice[_tokenId];
1242     }
1243 
1244 }
1245 
1246 
1247 contract MasterpieceMinting is MasterpieceSale {
1248 
1249     /*** CONSTANTS ***/
1250     /// @dev Starting price of a regular Masterpiece.
1251     uint128 private constant STARTING_PRICE = 0.001 ether;
1252     /// @dev Limit of number of promo masterpieces that can be created.
1253     uint16 private constant PROMO_CREATION_LIMIT = 10000;
1254 
1255     /// @dev Counts the number of Promotional Masterpieces the contract owner has created.
1256     uint16 public promoMasterpiecesCreatedCount;
1257     /// @dev Reference to contract tracking Non Fungible Token ownership
1258     ERC721 public nonFungibleContract;
1259 
1260     /// @dev Creates a new Masterpiece with the given name and artist.
1261     function createMasterpiece(
1262         string _name,
1263         string _artist,
1264         uint256 _snatchWindow
1265     )
1266         public
1267         onlyCurator
1268         returns (uint)
1269     {
1270         uint256 masterpieceId = _createMasterpiece(_name, _artist, STARTING_PRICE, _snatchWindow, address(this));
1271         return masterpieceId;
1272     }
1273 
1274     /// @dev Creates a new promotional Masterpiece with the given name, artist, starting
1275     /// price, and owner. If the owner or the price is not set, we default them to the
1276     /// curator's address and the starting price for all masterpieces.
1277     function createPromoMasterpiece(
1278         string _name,
1279         string _artist,
1280         uint256 _snatchWindow,
1281         uint256 _price,
1282         address _owner
1283     )
1284         public
1285         onlyCurator
1286         returns (uint)
1287     {
1288         require(promoMasterpiecesCreatedCount < PROMO_CREATION_LIMIT);
1289 
1290         address masterpieceOwner = _owner;
1291         if (masterpieceOwner == address(0)) {
1292             masterpieceOwner = curatorAddress;
1293         }
1294 
1295         if (_price <= 0) {
1296             _price = STARTING_PRICE;
1297         }
1298 
1299         uint256 masterpieceId = _createMasterpiece(_name, _artist, _price, _snatchWindow, masterpieceOwner);
1300         promoMasterpiecesCreatedCount++;
1301         return masterpieceId;
1302     }
1303 
1304 }
1305 
1306 
1307 /// CryptoMasterpieces: Collectible fine art masterpieces on the Ethereum blockchain.
1308 contract MasterpieceCore is MasterpieceMinting {
1309 
1310     // - MasterpieceAccessControl: This contract defines which users are granted the given roles that are
1311     // required to execute specific operations.
1312     //
1313     // - MasterpieceBase: This contract inherits from the MasterpieceAccessControl contract and defines
1314     // the core functionality of CryptoMasterpieces, including the data types, storage, and constants.
1315     //
1316     // - MasterpiecePricing: This contract inherits from the MasterpieceBase contract and defines
1317     // the pricing logic for CryptoMasterpieces. With every purchase made through the Core contract or
1318     // through a sale auction, the next listed price will multiply based on 5 price tiers. This ensures
1319     // that the Masterpiece bought through CryptoMasterpieces will always be adjusted to its fair market
1320     // value.
1321     //
1322     // - MasterpieceOwnership: This contract inherits from the MasterpiecePricing contract and the ERC-721
1323     // (https://github.com/ethereum/EIPs/issues/721) contract and implements the methods required for
1324     //  Non-Fungible Token Transactions.
1325     //
1326     // - MasterpieceAuction: This contract inherits from the MasterpieceOwnership contract. It defines
1327     // the Dutch "clock" auction mechanism for owners of a masterpiece to place it on sale. The auction
1328     // starts off at the automatically generated next price and until it is sold, decrements the price
1329     // as time passes. The owner of the masterpiece can cancel the auction at any point and the price
1330     // cannot go lower than the price that the owner bought the masterpiece for.
1331     //
1332     // - MasterpieceSale: This contract inherits from the MasterpieceAuction contract. It defines the
1333     // tiered pricing logic and handles all sales. It also checks that a Masterpiece is not in an
1334     // auction before approving a purchase.
1335     //
1336     // - MasterpieceMinting: This contract inherits from the MasterpieceSale contract. It defines the
1337     // creation of new regular and promotional masterpieces.
1338 
1339     // Set in case the core contract is broken and a fork is required
1340     address public newContractAddress;
1341 
1342     function MasterpieceCore() public {
1343         // Starts paused.
1344         paused = true;
1345 
1346         // The creator of the contract is the initial CEO
1347         ceoAddress = msg.sender;
1348 
1349         // The creator of the contract is also the initial Curator
1350         curatorAddress = msg.sender;
1351     }
1352 
1353     /// @dev Used to mark the smart contract as upgraded, in case there is a serious
1354     ///  breaking bug. This method does nothing but keep track of the new contract and
1355     ///  emit a message indicating that the new address is set. It's up to clients of this
1356     ///  contract to update to the new contract address in that case. (This contract will
1357     ///  be paused indefinitely if such an upgrade takes place.)
1358     /// @param _v2Address new address
1359     function setNewAddress(address _v2Address)
1360         external
1361         onlyCEO
1362         whenPaused
1363     {
1364         // See README.md for updgrade plan
1365         newContractAddress = _v2Address;
1366         ContractFork(_v2Address);
1367     }
1368 
1369     /// @dev Withdraw all Ether from the contract. This includes the fee on every
1370     /// masterpiece sold and any Ether sent directly to the contract address.
1371     /// Only the CFO can withdraw the balance or specify the address to send
1372     /// the balance to.
1373     function withdrawBalance(address _to) external onlyCFO {
1374         // We are using this boolean method to make sure that even if one fails it will still work
1375         if (_to == address(0)) {
1376             cfoAddress.transfer(this.balance);
1377         } else {
1378             _to.transfer(this.balance);
1379         }
1380     }
1381 
1382     /// @notice Returns all the relevant information about a specific masterpiece.
1383     /// @param _tokenId The tokenId of the masterpiece of interest.
1384     function getMasterpiece(uint256 _tokenId) external view returns (
1385         string name,
1386         string artist,
1387         uint256 birthTime,
1388         uint256 snatchWindow,
1389         uint256 sellingPrice,
1390         address owner
1391     ) {
1392         Masterpiece storage masterpiece = masterpieces[_tokenId];
1393         name = masterpiece.name;
1394         artist = masterpiece.artist;
1395         birthTime = uint256(masterpiece.birthTime);
1396         snatchWindow = masterpieceToSnatchWindow[_tokenId];
1397         sellingPrice = masterpieceToPrice[_tokenId];
1398         owner = masterpieceToOwner[_tokenId];
1399     }
1400 
1401     /// @dev Override unpause so it requires all external contract addresses
1402     ///  to be set before contract can be unpaused. Also, we can't have
1403     ///  newContractAddress set either, because then the contract was upgraded.
1404     /// @notice This is public rather than external so we can call super.unpause
1405     ///  without using an expensive call.
1406     function unpause()
1407         public
1408         onlyCEO
1409         whenPaused
1410     {
1411         require(saleAuction != address(0));
1412         require(newContractAddress == address(0));
1413 
1414         // Actually unpause the contract.
1415         super.unpause();
1416     }
1417 
1418 }