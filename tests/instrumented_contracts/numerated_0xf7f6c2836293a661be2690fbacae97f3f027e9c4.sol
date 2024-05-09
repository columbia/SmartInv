1 pragma solidity ^0.4.18;
2 
3 /// @title Interface for contracts conforming to ERC-721: Deed Standard
4 /// @author William Entriken (https://phor.net), et. al.
5 /// @dev Specification at https://github.com/ethereum/eips/XXXFinalUrlXXX
6 interface ERC721 {
7 
8     // COMPLIANCE WITH ERC-165 (DRAFT) /////////////////////////////////////////
9 
10     /// @dev ERC-165 (draft) interface signature for itself
11     // bytes4 internal constant INTERFACE_SIGNATURE_ERC165 = // 0x01ffc9a7
12     //     bytes4(keccak256('supportsInterface(bytes4)'));
13 
14     /// @dev ERC-165 (draft) interface signature for ERC721
15     // bytes4 internal constant INTERFACE_SIGNATURE_ERC721 = // 0xda671b9b
16     //     bytes4(keccak256('ownerOf(uint256)')) ^
17     //     bytes4(keccak256('countOfDeeds()')) ^
18     //     bytes4(keccak256('countOfDeedsByOwner(address)')) ^
19     //     bytes4(keccak256('deedOfOwnerByIndex(address,uint256)')) ^
20     //     bytes4(keccak256('approve(address,uint256)')) ^
21     //     bytes4(keccak256('takeOwnership(uint256)'));
22 
23     /// @notice Query a contract to see if it supports a certain interface
24     /// @dev Returns `true` the interface is supported and `false` otherwise,
25     ///  returns `true` for INTERFACE_SIGNATURE_ERC165 and
26     ///  INTERFACE_SIGNATURE_ERC721, see ERC-165 for other interface signatures.
27     function supportsInterface(bytes4 _interfaceID) external pure returns (bool);
28 
29     // PUBLIC QUERY FUNCTIONS //////////////////////////////////////////////////
30 
31     /// @notice Find the owner of a deed
32     /// @param _deedId The identifier for a deed we are inspecting
33     /// @dev Deeds assigned to zero address are considered invalid, and
34     ///  queries about them do throw.
35     /// @return The non-zero address of the owner of deed `_deedId`, or `throw`
36     ///  if deed `_deedId` is not tracked by this contract
37     function ownerOf(uint256 _deedId) external view returns (address _owner);
38 
39     /// @notice Count deeds tracked by this contract
40     /// @return A count of valid deeds tracked by this contract, where each one of
41     ///  them has an assigned and queryable owner not equal to the zero address
42     function countOfDeeds() external view returns (uint256 _count);
43 
44     /// @notice Count all deeds assigned to an owner
45     /// @dev Throws if `_owner` is the zero address, representing invalid deeds.
46     /// @param _owner An address where we are interested in deeds owned by them
47     /// @return The number of deeds owned by `_owner`, possibly zero
48     function countOfDeedsByOwner(address _owner) external view returns (uint256 _count);
49 
50     /// @notice Enumerate deeds assigned to an owner
51     /// @dev Throws if `_index` >= `countOfDeedsByOwner(_owner)` or if
52     ///  `_owner` is the zero address, representing invalid deeds.
53     /// @param _owner An address where we are interested in deeds owned by them
54     /// @param _index A counter less than `countOfDeedsByOwner(_owner)`
55     /// @return The identifier for the `_index`th deed assigned to `_owner`,
56     ///   (sort order not specified)
57     function deedOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 _deedId);
58 
59     // TRANSFER MECHANISM //////////////////////////////////////////////////////
60 
61     /// @dev This event emits when ownership of any deed changes by any
62     ///  mechanism. This event emits when deeds are created (`from` == 0) and
63     ///  destroyed (`to` == 0). Exception: during contract creation, any
64     ///  transfers may occur without emitting `Transfer`. At the time of any transfer,
65     ///  the "approved taker" is implicitly reset to the zero address.
66     event Transfer(address indexed from, address indexed to, uint256 indexed deedId);
67 
68     /// @dev The Approve event emits to log the "approved taker" for a deed -- whether
69     ///  set for the first time, reaffirmed by setting the same value, or setting to
70     ///  a new value. The "approved taker" is the zero address if nobody can take the
71     ///  deed now or it is an address if that address can call `takeOwnership` to attempt
72     ///  taking the deed. Any change to the "approved taker" for a deed SHALL cause
73     ///  Approve to emit. However, an exception, the Approve event will not emit when
74     ///  Transfer emits, this is because Transfer implicitly denotes the "approved taker"
75     ///  is reset to the zero address.
76     event Approval(address indexed owner, address indexed approved, uint256 indexed deedId);
77 
78     /// @notice Set the "approved taker" for your deed, or revoke approval by
79     ///  setting the zero address. You may `approve` any number of times while
80     ///  the deed is assigned to you, only the most recent approval matters. Emits
81     ///  an Approval event.
82     /// @dev Throws if `msg.sender` does not own deed `_deedId` or if `_to` ==
83     ///  `msg.sender` or if `_deedId` is not a valid deed.
84     /// @param _deedId The deed for which you are granting approval
85     function approve(address _to, uint256 _deedId) external payable;
86 
87     /// @notice Become owner of a deed for which you are currently approved
88     /// @dev Throws if `msg.sender` is not approved to become the owner of
89     ///  `deedId` or if `msg.sender` currently owns `_deedId` or if `_deedId is not a
90     ///  valid deed.
91     /// @param _deedId The deed that is being transferred
92     function takeOwnership(uint256 _deedId) external payable;
93 }
94 
95 contract Ownable {
96     address public owner;
97 
98     /**
99     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
100     * account.
101     */
102     function Ownable() public {
103         owner = msg.sender;
104     }
105 
106     /**
107     * @dev Throws if called by any account other than the owner.
108     */
109     modifier onlyOwner() {
110         require(msg.sender == owner);
111         _;
112     }
113 
114     /**
115     * @dev Allows the current owner to transfer control of the contract to a newOwner.
116     * @param newOwner The address to transfer ownership to.
117     */
118     function transferOwnership(address newOwner) public onlyOwner {
119         if (newOwner != address(0)) {
120             owner = newOwner;
121         }
122     }
123 }
124 
125 contract MonsterAccessControl {
126     event ContractUpgrade(address newContract);
127 
128      // The addresses of the accounts (or contracts) that can execute actions within each roles.
129     address public adminAddress;
130 
131     /// @dev Access modifier for CEO-only functionality
132     modifier onlyAdmin() {
133         require(msg.sender == adminAddress);
134         _;
135     }
136 }
137 
138 // This contract stores all data on the blockchain
139 // only our other contracts can interact with this
140 // the data here will be valid for all eternity even if other contracts get updated
141 // this way we can make sure that our Monsters have a hard-coded value attached to them
142 // that no one including us can change(!)
143 contract MonstersData {
144     address coreContract;
145 
146     struct Monster {
147         // timestamp of block when this monster was spawned/created
148         uint64 birthTime;
149 
150         // generation number
151         // gen0 is the very first generation - the later monster spawn the less likely they are to have
152         // special attributes and stats
153         uint16 generation;
154 
155         uint16 mID; // this id (from 1 to 151) is responsible for everything visually like showing the real deal!
156         bool tradeable;
157 
158         // breeding
159         bool female;
160 
161         // is this monster exceptionally rare?
162         bool shiny;
163     }
164 
165     // lv1 base stats
166     struct MonsterBaseStats {
167         uint16 hp;
168         uint16 attack;
169         uint16 defense;
170         uint16 spAttack;
171         uint16 spDefense;
172         uint16 speed;
173     }
174 
175     struct Trainer {
176         // timestamp of block when this player/trainer was created
177         uint64 birthTime;
178 
179         // add username
180         string username;
181 
182         // current area in the "world"
183         uint16 currArea;
184 
185         address owner;
186     }
187 
188     // take timestamp of block this game was created on the blockchain
189     uint64 creationBlock = uint64(now);
190 }
191 
192 contract MonstersBase is MonsterAccessControl, MonstersData {
193     /// @dev Transfer event as defined in current draft of ERC721. Emitted every time a monster
194     ///  ownership is assigned, including births.
195     event Transfer(address from, address to, uint256 tokenId);
196 
197     bool lockedMonsterCreator = false;
198 
199     MonsterAuction public monsterAuction;
200     MonsterCreatorInterface public monsterCreator;
201 
202     function setMonsterCreatorAddress(address _address) external onlyAdmin {
203         // only set this once so we (the devs) can't cheat!
204         require(!lockedMonsterCreator);
205         MonsterCreatorInterface candidateContract = MonsterCreatorInterface(_address);
206 
207         monsterCreator = candidateContract;
208         lockedMonsterCreator = true;
209     }
210 
211     // An approximation of currently how many seconds are in between blocks.
212     uint256 public secondsPerBlock = 15;
213 
214     // array containing all monsters in existence
215     Monster[] monsters;
216 
217     uint8[] areas;
218     uint8 areaIndex = 0;
219 
220     mapping(address => Trainer) public addressToTrainer;
221     /// @dev A mapping from monster IDs to the address that owns them. All monster have
222     ///  some valid owner address, even gen0 monster are created with a non-zero owner.
223     mapping (uint256 => address) public monsterIndexToOwner;
224     // @dev A mapping from owner address to count of tokens that address owns.
225     // Used internally inside balanceOf() to resolve ownership count.
226     mapping (address => uint256) ownershipTokenCount;
227     mapping (uint256 => address) public monsterIndexToApproved;
228     mapping (uint256 => string) public monsterIdToNickname;
229     mapping (uint256 => bool) public monsterIdToTradeable;
230     mapping (uint256 => uint256) public monsterIdToGeneration;
231     
232     mapping (uint256 => uint8[7]) public monsterIdToIVs;
233 
234     // adds new area to world
235     function _createArea() internal {
236         areaIndex++;
237         areas.push(areaIndex);
238     }
239 
240     function _createMonster(uint256 _generation, address _owner, uint256 _mID, bool _tradeable,
241         bool _female, bool _shiny) internal returns (uint)
242     {
243 
244         Monster memory _monster = Monster({
245             generation: uint16(_generation),
246             birthTime: uint64(now),
247             mID: uint16(_mID),
248             tradeable: _tradeable,
249             female: _female,
250             shiny: _shiny
251         });
252 
253         uint256 newMonsterId = monsters.push(_monster) - 1;
254 
255         require(newMonsterId == uint256(uint32(newMonsterId)));
256 
257         monsterIdToNickname[newMonsterId] = "";
258 
259         _transfer(0, _owner, newMonsterId);
260 
261         return newMonsterId;
262     }
263 
264     function _createTrainer(string _username, uint16 _starterId, address _owner) internal returns (uint mon) {
265         Trainer memory _trainer = Trainer({
266             birthTime: uint64(now),
267             username: string(_username),
268              // sets to first area!,
269             currArea: uint16(1),
270             owner: address(_owner)
271         });
272 
273         addressToTrainer[_owner] = _trainer;
274 
275         bool gender = monsterCreator.getMonsterGender();
276 
277         // starters cannot be traded and are not shiny
278         if (_starterId == 1) {
279             mon = _createMonster(0, _owner, 1, false, gender, false);
280         } else if (_starterId == 2) {
281             mon = _createMonster(0, _owner, 4, false, gender, false);
282         } else if (_starterId == 3) {
283             mon = _createMonster(0, _owner, 7, false, gender, false);
284         }
285     }
286 
287     function _moveToArea(uint16 _newArea, address player) internal {
288         addressToTrainer[player].currArea = _newArea;
289     }
290 
291     // assigns ownership of monster to address
292     function _transfer(address _from, address _to, uint256 _tokenId) internal {
293         ownershipTokenCount[_to]++;
294         monsterIndexToOwner[_tokenId] = _to;
295 
296         if (_from != address(0)) {
297             ownershipTokenCount[_from]--;
298 
299             // clear any previously approved ownership exchange
300             delete monsterIndexToApproved[_tokenId];
301         }
302 
303         // Emit Transfer event
304         Transfer(_from, _to, _tokenId);
305     }
306 
307     // Only admin can fix how many seconds per blocks are currently observed.
308     function setSecondsPerBlock(uint256 secs) external onlyAdmin {
309         //require(secs < cooldowns[0]);
310         secondsPerBlock = secs;
311     }
312 }
313 
314 contract MonsterOwnership is MonstersBase, ERC721 {
315     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
316         return monsterIndexToOwner[_tokenId] == _claimant;
317     }
318 
319     function _isTradeable(uint256 _tokenId) public view returns (bool) {
320         return monsterIdToTradeable[_tokenId];
321     }
322 
323     /// @dev Checks if a given address currently has transferApproval for a particular monster.
324     /// @param _claimant the address we are confirming monster is approved for.
325     /// @param _tokenId monster id, only valid when > 0
326     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
327         return monsterIndexToApproved[_tokenId] == _claimant;
328     }
329 
330     function balanceOf(address _owner) public view returns (uint256 count) {
331         return ownershipTokenCount[_owner];
332     }
333 
334     function transfer(address _to, uint256 _tokenId) public payable {
335         transferFrom(msg.sender, _to, _tokenId);
336     }
337 
338     function transferFrom(address _from, address _to, uint256 _tokenId) public payable {
339         require(monsterIdToTradeable[_tokenId]);
340         // Safety check to prevent against an unexpected 0x0 default.
341         require(_to != address(0));
342         // Disallow transfers to this contract to prevent accidental misuse.
343         // The contract should never own any monsters (except very briefly
344         // after a gen0 monster is created and before it goes on auction).
345         require(_to != address(this));
346         // Check for approval and valid ownership
347         
348         require(_owns(_from, _tokenId));
349         // checks if _to was aproved
350         require(_from == msg.sender || msg.sender == address(monsterAuction) || _approvedFor(_to, _tokenId));
351 
352         // Reassign ownership (also clears pending approvals and emits Transfer event).
353         _transfer(_from, _to, _tokenId);
354     }
355 
356     function totalSupply() public view returns (uint) {
357         return monsters.length;
358     }
359 
360     function tokensOfOwner(address _owner) public view returns (uint256[] ownerTokens) {
361         uint256 tokenCount = balanceOf(_owner);
362 
363         if (tokenCount > 0) {
364             uint256[] memory result = new uint256[](tokenCount);
365             uint256 totalMonsters = totalSupply();
366             uint256 resultIndex = 0;
367 
368             uint256 monsterId;
369 
370             for (monsterId = 0; monsterId <= totalMonsters; monsterId++) {
371                 if (monsterIndexToOwner[monsterId] == _owner) {
372                     result[resultIndex] = monsterId;
373                     resultIndex++;
374                 }
375             }
376 
377             return result;
378         }
379 
380         return new uint256[](0);
381     }
382 
383     bytes4 internal constant INTERFACE_SIGNATURE_ERC165 =
384         bytes4(keccak256("supportsInterface(bytes4)"));
385 
386     bytes4 internal constant INTERFACE_SIGNATURE_ERC721 =
387         bytes4(keccak256("ownerOf(uint256)")) ^
388         bytes4(keccak256("countOfDeeds()")) ^
389         bytes4(keccak256("countOfDeedsByOwner(address)")) ^
390         bytes4(keccak256("deedOfOwnerByIndex(address,uint256)")) ^
391         bytes4(keccak256("approve(address,uint256)")) ^
392         bytes4(keccak256("takeOwnership(uint256)"));
393 
394     function supportsInterface(bytes4 _interfaceID) external pure returns (bool) {
395         return _interfaceID == INTERFACE_SIGNATURE_ERC165 || _interfaceID == INTERFACE_SIGNATURE_ERC721;
396     }
397 
398     function ownerOf(uint256 _deedId) external view returns (address _owner) {
399         var owner = monsterIndexToOwner[_deedId];
400         require(owner != address(0));
401         return owner;
402     }
403 
404     function _approve(uint256 _tokenId, address _approved) internal {
405         monsterIndexToApproved[_tokenId] = _approved;
406     }
407 
408     function countOfDeeds() external view returns (uint256 _count) {
409         return totalSupply();
410     }
411 
412     function countOfDeedsByOwner(address _owner) external view returns (uint256 _count) {
413         var arr = tokensOfOwner(_owner);
414         return arr.length;
415     }
416 
417     function deedOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 _deedId) {
418         return tokensOfOwner(_owner)[_index];
419     }
420 
421     function approve(address _to, uint256 _tokenId) external payable {
422         // Only an owner can grant transfer approval.
423         require(_owns(msg.sender, _tokenId));
424 
425         // Register the approval (replacing any previous approval).
426         monsterIndexToApproved[_tokenId] = _to;
427 
428         // Emit approval event.
429         Approval(msg.sender, _to, _tokenId);
430     }
431 
432     function takeOwnership(uint256 _deedId) external payable {
433         transferFrom(this.ownerOf(_deedId), msg.sender, _deedId);
434     }
435 }
436 
437 contract MonsterAuctionBase {
438 
439     // Reference to contract tracking NFT ownership
440     MonsterOwnership public nonFungibleContract;
441     ChainMonstersCore public core;
442 
443     struct Auction {
444         // current owner
445         address seller;
446         // price in wei
447         uint256 price;
448         // time when auction started
449         uint64 startedAt;
450         uint256 id;
451     }
452 
453     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
454     // Values 0-10,000 map to 0%-100%
455     uint256 public ownerCut;
456 
457     // Map from token ID to their corresponding auction.
458     mapping(uint256 => Auction) tokenIdToAuction;
459     mapping(uint256 => address) public auctionIdToSeller;
460     mapping (address => uint256) public ownershipAuctionCount;
461 
462     event AuctionCreated(uint256 tokenId, uint256 price, uint256 uID, address seller);
463     event AuctionSuccessful(uint256 tokenId, uint256 price, address newOwner, uint256 uID);
464     event AuctionCancelled(uint256 tokenId, uint256 uID);
465 
466     function _transfer(address _receiver, uint256 _tokenId) internal {
467         // it will throw if transfer fails
468         nonFungibleContract.transfer(_receiver, _tokenId);
469     }
470 
471     function _addAuction(uint256 _tokenId, Auction _auction) internal {
472         tokenIdToAuction[_tokenId] = _auction;
473 
474         AuctionCreated(
475             uint256(_tokenId),
476             uint256(_auction.price),
477             uint256(_auction.id),
478             address(_auction.seller)
479         );
480     }
481 
482     function _cancelAuction(uint256 _tokenId, address _seller) internal {
483         Auction storage _auction = tokenIdToAuction[_tokenId];
484 
485         uint256 uID = _auction.id;
486 
487         _removeAuction(_tokenId);
488         ownershipAuctionCount[_seller]--;
489         _transfer(_seller, _tokenId);
490 
491         AuctionCancelled(_tokenId, uID);
492     }
493 
494     function _buy(uint256 _tokenId, uint256 _bidAmount) internal returns (uint256) {
495         Auction storage auction = tokenIdToAuction[_tokenId];
496 
497         require(_isOnAuction(auction));
498 
499         uint256 price = auction.price;
500         require(_bidAmount >= price);
501 
502         address seller = auction.seller;
503         uint256 uID = auction.id;
504 
505         // Auction Bid looks fine! so remove
506         _removeAuction(_tokenId);
507 
508         ownershipAuctionCount[seller]--;
509 
510         if (price > 0) {
511             uint256 auctioneerCut = _computeCut(price);
512             uint256 sellerProceeds = price - auctioneerCut;
513 
514             // NOTE: Doing a transfer() in the middle of a complex
515             // method like this is generally discouraged because of
516             // reentrancy attacks and DoS attacks if the seller is
517             // a contract with an invalid fallback function. We explicitly
518             // guard against reentrancy attacks by removing the auction
519             // before calling transfer(), and the only thing the seller
520             // can DoS is the sale of their own asset! (And if it's an
521             // accident, they can call cancelAuction(). )
522             if (seller != address(core)) {
523                 seller.transfer(sellerProceeds);
524             }
525         }
526 
527         // Calculate any excess funds included with the bid. If the excess
528         // is anything worth worrying about, transfer it back to bidder.
529         // NOTE: We checked above that the bid amount is greater than or
530         // equal to the price so this cannot underflow.
531         uint256 bidExcess = _bidAmount - price;
532 
533         // Return the funds. Similar to the previous transfer, this is
534         // not susceptible to a re-entry attack because the auction is
535         // removed before any transfers occur.
536         msg.sender.transfer(bidExcess);
537 
538         // Tell the world!
539         AuctionSuccessful(_tokenId, price, msg.sender, uID);
540 
541         return price;
542     }
543 
544     function _removeAuction(uint256 _tokenId) internal {
545         delete tokenIdToAuction[_tokenId];
546     }
547 
548     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
549         return (_auction.startedAt > 0);
550     }
551 
552      function _computeCut(uint256 _price) internal view returns (uint256) {
553         // NOTE: We don't use SafeMath (or similar) in this function because
554         //  all of our entry functions carefully cap the maximum values for
555         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
556         //  statement in the ClockAuction constructor). The result of this
557         //  function is always guaranteed to be <= _price.
558         return _price * ownerCut / 10000;
559     }
560 }
561 
562 contract MonsterAuction is  MonsterAuctionBase, Ownable {
563     bool public isMonsterAuction = true;
564     uint256 public auctionIndex = 0;
565 
566     function MonsterAuction(address _nftAddress, uint256 _cut) public {
567         require(_cut <= 10000);
568         ownerCut = _cut;
569 
570         var candidateContract = MonsterOwnership(_nftAddress);
571 
572         nonFungibleContract = candidateContract;
573         ChainMonstersCore candidateCoreContract = ChainMonstersCore(_nftAddress);
574         core = candidateCoreContract;
575     }
576 
577     // only possible to decrease ownerCut!
578     function setOwnerCut(uint256 _cut) external onlyOwner {
579         require(_cut <= ownerCut);
580         ownerCut = _cut;
581     }
582 
583     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
584         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
585     }
586 
587     function _escrow(address _owner, uint256 _tokenId) internal {
588         // it will throw if transfer fails
589         nonFungibleContract.transferFrom(_owner, this, _tokenId);
590     }
591 
592     function withdrawBalance() external onlyOwner {
593         uint256 balance = this.balance;
594         owner.transfer(balance);
595     }
596 
597     function tokensInAuctionsOfOwner(address _owner) external view returns(uint256[] auctionTokens) {
598         uint256 numAuctions = ownershipAuctionCount[_owner];
599 
600         uint256[] memory result = new uint256[](numAuctions);
601         uint256 totalAuctions = core.totalSupply();
602         uint256 resultIndex = 0;
603 
604         uint256 auctionId;
605 
606         for (auctionId = 0; auctionId <= totalAuctions; auctionId++) {
607             Auction storage auction = tokenIdToAuction[auctionId];
608             if (auction.seller == _owner) {
609                 result[resultIndex] = auctionId;
610                 resultIndex++;
611             }
612         }
613 
614         return result;
615     }
616 
617     function createAuction(uint256 _tokenId, uint256 _price, address _seller) external {
618         require(_seller != address(0));
619         require(_price == uint256(_price));
620         require(core._isTradeable(_tokenId));
621         require(_owns(msg.sender, _tokenId));
622 
623         
624         _escrow(msg.sender, _tokenId);
625 
626         Auction memory auction = Auction(
627             _seller,
628             uint256(_price),
629             uint64(now),
630             uint256(auctionIndex)
631         );
632 
633         auctionIdToSeller[auctionIndex] = _seller;
634         ownershipAuctionCount[_seller]++;
635 
636         auctionIndex++;
637         _addAuction(_tokenId, auction);
638     }
639 
640     function buy(uint256 _tokenId) external payable {
641         //delete auctionIdToSeller[_tokenId];
642         // buy will throw if the bid or funds transfer fails
643         _buy (_tokenId, msg.value);
644         _transfer(msg.sender, _tokenId);
645     }
646 
647     function cancelAuction(uint256 _tokenId) external {
648         Auction storage auction = tokenIdToAuction[_tokenId];
649         require(_isOnAuction(auction));
650 
651         address seller = auction.seller;
652         require(msg.sender == seller);
653 
654         _cancelAuction(_tokenId, seller);
655     }
656 
657     function getAuction(uint256 _tokenId) external view returns (address seller, uint256 price, uint256 startedAt) {
658         Auction storage auction = tokenIdToAuction[_tokenId];
659         require(_isOnAuction(auction));
660 
661         return (
662             auction.seller,
663             auction.price,
664             auction.startedAt
665         );
666     }
667 
668     function getPrice(uint256 _tokenId) external view returns (uint256) {
669         Auction storage auction = tokenIdToAuction[_tokenId];
670         require(_isOnAuction(auction));
671         return auction.price;
672     }
673 }
674 
675 contract ChainMonstersAuction is MonsterOwnership {
676     bool lockedMonsterAuction = false;
677 
678     function setMonsterAuctionAddress(address _address) external onlyAdmin {
679         require(!lockedMonsterAuction);
680         MonsterAuction candidateContract = MonsterAuction(_address);
681 
682         require(candidateContract.isMonsterAuction());
683 
684         monsterAuction = candidateContract;
685         lockedMonsterAuction = true;
686     }
687 
688     uint256 public constant PROMO_CREATION_LIMIT = 5000;
689     uint256 public constant GEN0_CREATION_LIMIT = 5000;
690 
691     // Counts the number of monster the contract owner has created.
692     uint256 public promoCreatedCount;
693     uint256 public gen0CreatedCount;
694 
695     // its stats are completely dependent on the spawn alghorithm
696     function createPromoMonster(uint256 _mId, address _owner) external onlyAdmin {
697         // during generation we have to keep in mind that we have only 10,000 tokens available
698         // which have to be divided by 151 monsters, some rarer than others
699         // see WhitePaper for gen0/promo monster plan
700         
701         // sanity check that this monster ID is actually in game yet
702         require(monsterCreator.baseStats(_mId, 1) > 0);
703         
704         require(promoCreatedCount < PROMO_CREATION_LIMIT);
705 
706         promoCreatedCount++;
707 
708         uint8[7] memory ivs = uint8[7](monsterCreator.getGen0IVs());
709 
710         bool gender = monsterCreator.getMonsterGender();
711         
712         bool shiny = false;
713         if (ivs[6] == 1) {
714             shiny = true;
715         }
716         uint256 monsterId = _createMonster(0, _owner, _mId, true, gender, shiny);
717         monsterIdToTradeable[monsterId] = true;
718 
719         monsterIdToIVs[monsterId] = ivs;
720     }
721 
722     function createGen0Auction(uint256 _mId, uint256 price) external onlyAdmin {
723          // sanity check that this monster ID is actually in game yet
724         require(monsterCreator.baseStats(_mId, 1) > 0);
725         
726         require(gen0CreatedCount < GEN0_CREATION_LIMIT);
727 
728         uint8[7] memory ivs = uint8[7](monsterCreator.getGen0IVs());
729 
730         bool gender = monsterCreator.getMonsterGender();
731         
732         bool shiny = false;
733         if (ivs[6] == 1) {
734             shiny = true;
735         }
736         
737         uint256 monsterId = _createMonster(0, this, _mId, true, gender, shiny);
738         monsterIdToTradeable[monsterId] = true;
739 
740         _approve(monsterId, monsterAuction);
741 
742         monsterIdToIVs[monsterId] = ivs;
743 
744         monsterAuction.createAuction(monsterId, price, address(this));
745 
746         gen0CreatedCount++;
747     }
748 }
749 
750 // used during launch for world championship
751 // can and will be upgraded during development with new battle system!
752 // this is just to give players something to do and test their monsters
753 // also demonstrates how we can build up more mechanics on top of our locked core contract!
754 contract MonsterChampionship is Ownable {
755 
756     bool public isMonsterChampionship = true;
757 
758     ChainMonstersCore core;
759 
760     // list of top ten
761     address[10] topTen;
762 
763     // holds the address current "world" champion
764     address public currChampion;
765 
766     mapping (address => uint256) public addressToPowerlevel;
767     mapping (uint256 => address) public rankToAddress;
768 
769     // try to beat every other player in the top10 with your strongest monster!
770     // effectively looping through all top10 players, beating them one by one
771     // and if strong enough placing your in the top10 as well
772     function contestChampion(uint256 _tokenId) external {
773         uint maxIndex = 9;
774 
775         // fail tx if player is already champion!
776         // in theory players could increase their powerlevel by contesting themselves but
777         // this check stops that from happening so other players have the chance to
778         // become the temporary champion!
779         if (currChampion == msg.sender) {
780             revert();
781         }
782 
783         require(core.isTrainer(msg.sender));
784         require(core.monsterIndexToOwner(_tokenId) == msg.sender);
785 
786         uint myPowerlevel = 10; // todo add calculation method to this contract!
787 
788         // checks if this transaction is useless
789         // since we can't fight against ourself!
790         // also stops reentrancy attacks
791         require(myPowerlevel > addressToPowerlevel[msg.sender]);
792 
793         uint myRank = 0;
794 
795         for (uint i = 0; i <= maxIndex; i++) {
796             if (myPowerlevel > addressToPowerlevel[topTen[i]]) {
797                 // you have beaten this one so increase temporary rank
798                 myRank = i;
799 
800                 if (myRank == maxIndex) {
801                     currChampion = msg.sender;
802                 }
803             }
804         }
805 
806         addressToPowerlevel[msg.sender] = myPowerlevel;
807 
808         address[10] storage newTopTen = topTen;
809 
810         if (currChampion == msg.sender) {
811             for (uint j = 0; j < maxIndex; j++) {
812                 // remove ourselves from this list in case
813                 if (newTopTen[j] == msg.sender) {
814                     newTopTen[j] = 0x0;
815                     break;
816                 }
817             }
818         }
819 
820         for (uint x = 0; x <= myRank; x++) {
821             if (x == myRank) {
822                 newTopTen[x] = msg.sender;
823             } else {
824                 if (x < maxIndex)
825                     newTopTen[x] = topTen[x+1];
826             }
827         }
828 
829         topTen = newTopTen;
830     }
831 
832     function getTopPlayers() external view returns (address[10] players) {
833         players = topTen;
834     }
835 
836     function MonsterChampionship(address coreContract) public {
837         core = ChainMonstersCore(coreContract);
838     }
839 
840     function withdrawBalance() external onlyOwner {
841         uint256 balance = this.balance;
842         owner.transfer(balance);
843     }
844 }
845 
846 
847 // where the not-so-much "hidden" magic happens
848 contract MonsterCreatorInterface is Ownable {
849     uint8 public lockedMonsterStatsCount = 0;
850     uint nonce = 0;
851 
852     function rand(uint16 min, uint16 max) public returns (uint16) {
853         nonce++;
854         uint16 result = (uint16(keccak256(block.blockhash(block.number-1), nonce))%max);
855 
856         if (result < min) {
857             result = result+min;
858         }
859 
860         return result;
861     }
862 
863     mapping(uint256 => uint8[8]) public baseStats;
864 
865     function addBaseStats(uint256 _mId, uint8[8] data) external onlyOwner {
866         // lock" the stats down forever
867         // since hp is never going to be 0 this is a valid check
868         // so we have to be extra careful when adding new baseStats!
869         require(data[0] > 0);
870         require(baseStats[_mId][0] == 0);
871         baseStats[_mId] = data;
872     }
873 
874     function _addBaseStats(uint256 _mId, uint8[8] data) internal {
875         baseStats[_mId] = data;
876         lockedMonsterStatsCount++;
877     }
878 
879     function MonsterCreatorInterface() public {
880        // these monsters are already down and "locked" down stats/design wise
881         _addBaseStats(1, [45, 49, 49, 65, 65, 45, 12, 4]);
882         _addBaseStats(2, [60, 62, 63, 80, 80, 60, 12, 4]);
883         _addBaseStats(3, [80, 82, 83, 100, 100, 80, 12, 4]);
884         _addBaseStats(4, [39, 52, 43, 60, 50, 65, 10, 6]);
885         _addBaseStats(5, [58, 64, 58, 80, 65, 80, 10, 6]);
886         _addBaseStats(6, [78, 84, 78, 109, 85, 100, 10, 6]);
887         _addBaseStats(7, [44, 48, 65, 50, 64, 43, 11, 14]);
888         _addBaseStats(8, [59, 63, 80, 65, 80, 58, 11, 14]);
889         _addBaseStats(9, [79, 83, 100, 85, 105, 78, 11, 14]);
890         _addBaseStats(10, [40, 35, 30, 20, 20, 50, 7, 4]);
891 
892         _addBaseStats(149, [55, 50, 45, 135, 95, 120, 8, 14]);
893         _addBaseStats(150, [91, 134, 95, 100, 100, 80, 2, 5]);
894         _addBaseStats(151, [100, 100, 100, 100, 100, 100, 5, 19]);
895     }
896 
897     // this serves as a lookup for new monsters to be generated since all monsters
898     // of the same id share the base stats
899     // also makes it possible to only store the monsterId on core and change this one
900     // during evolution process to save gas and additional transactions
901     function getMonsterStats( uint256 _mID) external constant returns(uint8[8] stats) {
902         stats[0] = baseStats[_mID][0];
903         stats[1] = baseStats[_mID][1];
904         stats[2] = baseStats[_mID][2];
905         stats[3] = baseStats[_mID][3];
906         stats[4] = baseStats[_mID][4];
907         stats[5] = baseStats[_mID][5];
908         stats[6] = baseStats[_mID][6];
909         stats[7] = baseStats[_mID][7];
910     }
911 
912     function getMonsterGender () external returns(bool female) {
913         uint16 femaleChance = rand(0, 100);
914 
915         if (femaleChance >= 50) {
916             female = true;
917         }
918     }
919 
920     // generates randomized IVs for a new monster
921     function getMonsterIVs() external returns(uint8[7] ivs) {
922         bool shiny = false;
923 
924         uint16 chance = rand(1, 8192);
925 
926         if (chance == 42) {
927             shiny = true;
928         }
929 
930         // IVs range between 0 and 31
931         // stat range modified for shiny monsters!
932         if (shiny) {
933             ivs[0] = uint8(rand(10, 31));
934             ivs[1] = uint8(rand(10, 31));
935             ivs[2] = uint8(rand(10, 31));
936             ivs[3] = uint8(rand(10, 31));
937             ivs[4] = uint8(rand(10, 31));
938             ivs[5] = uint8(rand(10, 31));
939             ivs[6] = 1;
940 
941         } else {
942             ivs[0] = uint8(rand(0, 31));
943             ivs[1] = uint8(rand(0, 31));
944             ivs[2] = uint8(rand(0, 31));
945             ivs[3] = uint8(rand(0, 31));
946             ivs[4] = uint8(rand(0, 31));
947             ivs[5] = uint8(rand(0, 31));
948             ivs[6] = 0;
949         }
950     }
951 
952     // gen0 monsters profit from shiny boost while shiny gen0s have potentially even higher IVs!
953     // further increasing the rarity by also doubling the shiny chance!
954     function getGen0IVs() external returns (uint8[7] ivs) {
955         bool shiny = false;
956 
957         uint16 chance = rand(1, 4096);
958 
959         if (chance == 42) {
960             shiny = true;
961         }
962 
963         if (shiny) {
964             ivs[0] = uint8(rand(15, 31));
965             ivs[1] = uint8(rand(15, 31));
966             ivs[2] = uint8(rand(15, 31));
967             ivs[3] = uint8(rand(15, 31));
968             ivs[4] = uint8(rand(15, 31));
969             ivs[5] = uint8(rand(15, 31));
970             ivs[6] = 1;
971         } else {
972             ivs[0] = uint8(rand(10, 31));
973             ivs[1] = uint8(rand(10, 31));
974             ivs[2] = uint8(rand(10, 31));
975             ivs[3] = uint8(rand(10, 31));
976             ivs[4] = uint8(rand(10, 31));
977             ivs[5] = uint8(rand(10, 31));
978             ivs[6] = 0;
979         }
980     }
981 
982     function withdrawBalance() external onlyOwner {
983         uint256 balance = this.balance;
984         owner.transfer(balance);
985     }
986 }
987 
988 contract GameLogicContract {
989     bool public isGameLogicContract = true;
990 
991     function GameLogicContract() public {
992 
993     }
994 }
995 
996 
997 contract OmegaContract {
998     bool public isOmegaContract = true;
999 
1000     function OmegaContract() public {
1001 
1002     }
1003 }
1004 
1005 contract ChainMonstersCore is ChainMonstersAuction, Ownable {
1006     // using a bool to enable us to prepare the game
1007     bool hasLaunched = false;
1008 
1009     // this address will hold future gamelogic in place
1010     address gameContract;
1011 
1012     // this contract
1013     address omegaContract;
1014 
1015     function ChainMonstersCore() public {
1016         adminAddress = msg.sender;
1017 
1018         _createArea(); // area 1
1019         _createArea(); // area 2
1020     }
1021 
1022     // we don't know the exact interfaces yet so use the lockedMonsterStats value to determine if the game is "ready"
1023     // see WhitePaper for explaination for our upgrade and development roadmap
1024     function setGameLogicContract(address _candidateContract) external onlyOwner {
1025         require(monsterCreator.lockedMonsterStatsCount() == 151);
1026 
1027         require(GameLogicContract(_candidateContract).isGameLogicContract());
1028 
1029         gameContract = _candidateContract;
1030     }
1031 
1032     function setOmegaContract(address _candidateContract) external onlyOwner {
1033         require(OmegaContract(_candidateContract).isOmegaContract());
1034         omegaContract = _candidateContract;
1035     }
1036 
1037     // omega contract takes care of all neccessary checks so assume that this is correct(!)
1038     function evolveMonster(uint256 _tokenId, uint16 _toMonsterId) external {
1039         require(msg.sender == omegaContract);
1040 
1041         // retrieve current monster struct
1042         Monster storage mon = monsters[_tokenId];
1043 
1044         // evolving only changes monster ID since this is responsible for base Stats
1045         // an evolved monster keeps its gender, generation, IVs and EVs
1046         mon.mID = _toMonsterId;
1047     }
1048 
1049     // only callable by gameContract after the full game is launched
1050     // since all additional monsters after the promo/gen0 ones need to use this coreContract
1051     // contract as well we have to prepare this core for our future updates where
1052     // players can freely roam the world and hunt ChainMonsters thus generating more
1053     function spawnMonster(uint256 _mId, address _owner) external {
1054         require(msg.sender == gameContract);
1055 
1056         uint8[7] memory ivs = uint8[7](monsterCreator.getMonsterIVs());
1057 
1058         bool gender = monsterCreator.getMonsterGender();
1059 
1060         bool shiny = false;
1061         if (ivs[6] == 1) {
1062             shiny = true;
1063         }
1064         
1065         // important to note that the IV generators do not use Gen0 methods and are Generation 1
1066         // this means there won't be more than the 10,000 Gen0 monsters sold during the development through the marketplace
1067         uint256 monsterId = _createMonster(1, _owner, _mId, false, gender, shiny);
1068         monsterIdToTradeable[monsterId] = true;
1069 
1070         monsterIdToIVs[monsterId] = ivs;
1071     }
1072 
1073     // used to add playable content to the game
1074     // monsters will only spawn in certain areas so some are locked on release
1075     // due to the game being in active development on "launch"
1076     // each monster has a maximum number of 3 areas where it can appear
1077     function createArea() public onlyAdmin {
1078         _createArea();
1079     }
1080 
1081     function createTrainer(string _username, uint16 _starterId) public {
1082         require(hasLaunched);
1083 
1084         // only one trainer/account per ethereum address
1085         require(addressToTrainer[msg.sender].owner == 0);
1086 
1087         // valid input check
1088         require(_starterId == 1 || _starterId == 2 || _starterId == 3);
1089 
1090         uint256 mon = _createTrainer(_username, _starterId, msg.sender);
1091 
1092         // due to stack limitations we have to assign the IVs here:
1093         monsterIdToIVs[mon] = monsterCreator.getMonsterIVs();
1094     }
1095 
1096     function changeUsername(string _name) public {
1097         require(addressToTrainer[msg.sender].owner == msg.sender);
1098         addressToTrainer[msg.sender].username = _name;
1099     }
1100 
1101     function changeMonsterNickname(uint256 _tokenId, string _name) public {
1102         // users won't be able to rename a monster that is part of an auction
1103         require(_owns(msg.sender, _tokenId));
1104 
1105         // some string checks...?
1106         monsterIdToNickname[_tokenId] = _name;
1107     }
1108 
1109     function moveToArea(uint16 _newArea) public {
1110         require(addressToTrainer[msg.sender].currArea > 0);
1111 
1112         // never allow anyone to move to area 0 or below since this is used
1113         // to determine if a trainer profile exists in another method!
1114         require(_newArea > 0);
1115 
1116         // make sure that this area exists yet!
1117         require(areas.length >= _newArea);
1118 
1119         // when player is not stuck doing something else he can move freely!
1120         _moveToArea(_newArea, msg.sender);
1121     }
1122 
1123     // to be changed to retrieve current stats!
1124     function getMonster(uint256 _id) external view returns (
1125         uint256 birthTime, uint256 generation, uint8[8] stats,
1126         uint256 mID, bool tradeable, uint256 uID)
1127     {
1128         Monster storage mon = monsters[_id];
1129         birthTime = uint256(mon.birthTime);
1130         generation = mon.generation; // hardcoding due to stack too deep error
1131         mID = uint256(mon.mID);
1132         tradeable = bool(mon.tradeable);
1133 
1134         // these values are retrieved from monsterCreator
1135         stats = uint8[8](monsterCreator.getMonsterStats(uint256(mon.mID)));
1136 
1137         // hack to overcome solidity's stack limitation in monster struct....
1138         uID = _id;
1139     }
1140 
1141     function isTrainer(address _check) external view returns (bool isTrainer) {
1142         Trainer storage trainer = addressToTrainer[_check];
1143 
1144         return (trainer.currArea > 0);
1145     }
1146 
1147     function withdrawBalance() external onlyOwner {
1148         uint256 balance = this.balance;
1149 
1150         owner.transfer(balance);
1151     }
1152 
1153     // after we have setup everything we can unlock the game
1154     // for public
1155     function launchGame() external onlyOwner {
1156         hasLaunched = true;
1157     }
1158 }