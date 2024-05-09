1 pragma solidity ^0.4.19;
2 
3 // DopeRaider Narcos Contract
4 // by gasmasters.io
5 // contact: team@doperaider.com
6 
7 contract DistrictsCoreInterface {
8   // callable by other contracts to control economy
9   function isDopeRaiderDistrictsCore() public pure returns (bool);
10   function increaseDistrictWeed(uint256 _district, uint256 _quantity) public;
11   function increaseDistrictCoke(uint256 _district, uint256 _quantity) public;
12   function distributeRevenue(uint256 _district , uint8 _splitW, uint8 _splitC) public payable;
13   function getNarcoLocation(uint256 _narcoId) public view returns (uint8 location);
14 }
15 
16 /// @title sale clock auction interface
17 contract SaleClockAuction {
18   function isSaleClockAuction() public pure returns (bool);
19   function createAuction(uint256 _tokenId,  uint256 _startingPrice,uint256 _endingPrice,uint256 _duration,address _seller)public;
20   function withdrawBalance() public;
21   function averageGen0SalePrice() public view returns (uint256);
22 
23 }
24 
25 
26 //// @title A facet of NarcoCore that manages special access privileges.
27 contract NarcoAccessControl {
28     /// @dev Emited when contract is upgraded
29     event ContractUpgrade(address newContract);
30 
31     address public ceoAddress;
32     address public cooAddress;
33 
34     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
35     bool public paused = false;
36 
37     modifier onlyCEO() {
38         require(msg.sender == ceoAddress);
39         _;
40     }
41 
42     modifier onlyCLevel() {
43         require(
44             msg.sender == cooAddress ||
45             msg.sender == ceoAddress
46         );
47         _;
48     }
49 
50     function setCEO(address _newCEO) public onlyCEO {
51         require(_newCEO != address(0));
52 
53         ceoAddress = _newCEO;
54     }
55 
56     function setCOO(address _newCOO) public onlyCEO {
57         require(_newCOO != address(0));
58 
59         cooAddress = _newCOO;
60     }
61 
62     function withdrawBalance() external onlyCLevel {
63         msg.sender.transfer(address(this).balance);
64     }
65 
66 
67     /*** Pausable functionality adapted from OpenZeppelin ***/
68 
69     /// @dev Modifier to allow actions only when the contract IS NOT paused
70     modifier whenNotPaused() {
71         require(!paused);
72         _;
73     }
74 
75     /// @dev Modifier to allow actions only when the contract IS paused
76     modifier whenPaused {
77         require(paused);
78         _;
79     }
80 
81     function pause() public onlyCLevel whenNotPaused {
82         paused = true;
83     }
84 
85     function unpause() public onlyCLevel whenPaused {
86         // can't unpause if contract was upgraded
87         paused = false;
88     }
89 
90     /// @dev The address of the calling contract
91     address public districtContractAddress;
92 
93     DistrictsCoreInterface public districtsCore;
94 
95     function setDistrictAddress(address _address) public onlyCLevel {
96         _setDistrictAddresss(_address);
97     }
98 
99     function _setDistrictAddresss(address _address) internal {
100       DistrictsCoreInterface candidateContract = DistrictsCoreInterface(_address);
101       require(candidateContract.isDopeRaiderDistrictsCore());
102       districtsCore = candidateContract;
103       districtContractAddress = _address;
104     }
105 
106 
107     modifier onlyDopeRaiderContract() {
108         require(msg.sender == districtContractAddress);
109         _;
110     }
111 
112 
113 
114 
115 }
116 
117 /// @title Base contract for DopeRaider. Holds all common structs, events and base variables.
118 contract NarcoBase is NarcoAccessControl {
119     /*** EVENTS ***/
120 
121     event NarcoCreated(address indexed owner, uint256 narcoId, string genes);
122 
123     /// @dev Transfer event as defined in current draft of ERC721. Emitted every time a narcos
124     ///  ownership is assigned, including newly created narcos.
125     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
126 
127 
128  /*** DATA TYPES ***/
129 
130     // consumable indexes
131     /*
132     uint constant gasIndex = 0;
133     uint constant seedsIndex = 1;
134     uint constant chemicalsIndex = 2;
135     uint constant ammoIndex = 3;
136 
137     // skills indexes  - each skill can range from 1 - 10 in level
138     uint constant speedIndex = 0; // speed of travel
139     uint constant growIndex = 1; // speed/yield of grow
140     uint constant refineIndex = 2; // refine coke
141     uint constant attackIndex = 3; // attack
142     uint constant defenseIndex = 4; // defense
143     uint constant capacityIndex = 5; // how many items can be carried.
144 
145     // stat indexes
146     uint constant dealsCompleted = 0; // dealsCompleted
147     uint constant weedGrowCompleted = 1; // weedGrowCompleted
148     uint constant cokeRefineCompleted = 2; // refineCompleted
149     uint constant attacksSucceeded = 3; // attacksSucceeded
150     uint constant defendedSuccessfully = 4; defendedSuccessfully
151     uint constant raidsCompleted = 5; // raidsCompleted
152     uint constant escapeHijack = 6; // escapeHijack
153     uint constant travelling = 7; // traveller
154     uint constant recruited = 8; // recruitment
155 */
156 
157 
158     /// @dev The main Narco struct. Every narco in DopeRaider is represented by a copy
159     ///  of this structure.
160     struct Narco {
161         // The Narco's genetic code is packed into these 256-bits.
162         string genes; // represents his avatar
163         string narcoName;
164         // items making level
165         uint16 [9] stats;
166         // inventory totals
167         uint16 weedTotal;
168         uint16 cokeTotal;
169         uint8 [4] consumables; // gas, seeds, chemicals, ammo
170         uint16 [6] skills;   // travel time, grow, refine, attack, defend carry
171         uint256 [6] cooldowns; // skill cooldown periods speed, grow, refine, attack, others if needed
172         uint8 homeLocation;
173     }
174 
175     /*** STORAGE ***/
176 
177     /// @dev An array containing the Narco struct for all Narcos in existence. The ID
178     ///  of each narco is actually an index into this array.
179     Narco[] narcos;
180 
181     /// @dev A mapping from  narco IDs to the address that owns them. All  narcos have
182     ///  some valid owner address, even gen0  narcos are created with a non-zero owner.
183     mapping (uint256 => address) public narcoIndexToOwner;
184 
185     // @dev A mapping from owner address to count of tokens that address owns.
186     //  Used internally inside balanceOf() to resolve ownership count.
187     mapping (address => uint256) ownershipTokenCount;
188 
189     /// @dev A mapping from NarcoIDs to an address that has been approved to call
190     ///  transferFrom(). A zero value means no approval is outstanding.
191     mapping (uint256 => address) public  narcoIndexToApproved;
192 
193     function _transfer(address _from, address _to, uint256 _tokenId) internal {
194         // since the number of  narcos is capped to 2^32
195         // there is no way to overflow this
196         ownershipTokenCount[_to]++;
197         narcoIndexToOwner[_tokenId] = _to;
198 
199         if (_from != address(0)) {
200             ownershipTokenCount[_from]--;
201             delete narcoIndexToApproved[_tokenId];
202         }
203 
204         Transfer(_from, _to, _tokenId);
205     }
206 
207     // Will generate a new Narco and generate the event
208     function _createNarco(
209         string _genes,
210         string _name,
211         address _owner
212     )
213         internal
214         returns (uint)
215     {
216 
217         uint16[6] memory randomskills= [
218             uint16(random(9)+1),
219             uint16(random(9)+1),
220             uint16(random(9)+1),
221             uint16(random(9)+1),
222             uint16(random(9)+1),
223             uint16(random(9)+31)
224         ];
225 
226         uint256[6] memory cools;
227         uint16[9] memory nostats;
228 
229         Narco memory _narco = Narco({
230             genes: _genes,
231             narcoName: _name,
232             cooldowns: cools,
233             stats: nostats,
234             weedTotal: 0,
235             cokeTotal: 0,
236             consumables: [4,6,2,1],
237             skills: randomskills,
238             homeLocation: uint8(random(6)+1)
239         });
240 
241         uint256 newNarcoId = narcos.push(_narco) - 1;
242         require(newNarcoId <= 4294967295);
243 
244         // raid character (token 0) live in 7 and have random special skills
245         if (newNarcoId==0){
246             narcos[0].homeLocation=7; // in vice island
247             narcos[0].skills[4]=800; // defense
248             narcos[0].skills[5]=65535; // carry
249         }
250 
251         NarcoCreated(_owner, newNarcoId, _narco.genes);
252         _transfer(0, _owner, newNarcoId);
253 
254 
255         return newNarcoId;
256     }
257 
258     function subToZero(uint256 a, uint256 b) internal pure returns (uint256) {
259         if (b <= a){
260           return a - b;
261         }else{
262           return 0;
263         }
264       }
265 
266     function getRemainingCapacity(uint256 _narcoId) public view returns (uint16 capacity){
267         uint256 usedCapacity = narcos[_narcoId].weedTotal + narcos[_narcoId].cokeTotal + narcos[_narcoId].consumables[0]+narcos[_narcoId].consumables[1]+narcos[_narcoId].consumables[2]+narcos[_narcoId].consumables[3];
268         capacity = uint16(subToZero(uint256(narcos[_narcoId].skills[5]), usedCapacity));
269     }
270 
271     // respect it's called now
272     function getLevel(uint256 _narcoId) public view returns (uint16 rank){
273 
274     /*
275       dealsCompleted = 0; // dealsCompleted
276       weedGrowCompleted = 1; // weedGrowCompleted
277       cokeRefineCompleted = 2; // refineCompleted
278       attacksSucceeded = 3; // attacksSucceeded
279       defendedSuccessfully = 4; defendedSuccessfully
280       raidsCompleted = 5; // raidsCompleted
281       escapeHijack = 6; // escapeHijack
282       travel = 7; // travelling
283     */
284 
285         rank =  (narcos[_narcoId].stats[0]/12)+
286                  (narcos[_narcoId].stats[1]/4)+
287                  (narcos[_narcoId].stats[2]/4)+
288                  (narcos[_narcoId].stats[3]/6)+
289                  (narcos[_narcoId].stats[4]/6)+
290                  (narcos[_narcoId].stats[5]/1)+
291                  (narcos[_narcoId].stats[7]/12)
292                  ;
293     }
294 
295     // pseudo random - but does that matter?
296     uint64 _seed = 0;
297     function random(uint64 upper) private returns (uint64 randomNumber) {
298        _seed = uint64(keccak256(keccak256(block.blockhash(block.number-1), _seed), now));
299        return _seed % upper;
300      }
301 
302 
303     // never call this from a contract
304     /// @param _owner The owner whose tokens we are interested in.
305     function narcosByOwner(address _owner) public view returns(uint256[] ownedNarcos) {
306        uint256 tokenCount = ownershipTokenCount[_owner];
307         uint256 totalNarcos = narcos.length - 1;
308         uint256[] memory result = new uint256[](tokenCount);
309         uint256 narcoId;
310         uint256 resultIndex=0;
311         for (narcoId = 0; narcoId <= totalNarcos; narcoId++) {
312           if (narcoIndexToOwner[narcoId] == _owner) {
313             result[resultIndex] = narcoId;
314             resultIndex++;
315           }
316         }
317         return result;
318     }
319 
320 
321 }
322 
323 
324 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
325 contract ERC721 {
326     function implementsERC721() public pure returns (bool);
327     function totalSupply() public view returns (uint256 total);
328     function balanceOf(address _owner) public view returns (uint256 balance);
329     function ownerOf(uint256 _tokenId) public view returns (address owner);
330     function approve(address _to, uint256 _tokenId) public;
331     function transferFrom(address _from, address _to, uint256 _tokenId) public;
332     function transfer(address _to, uint256 _tokenId) public;
333     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
334     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
335 
336     // Optional
337     // function name() public view returns (string name);
338     // function symbol() public view returns (string symbol);
339     // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
340     // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
341 }
342 
343 /// @title The facet of the DopeRaider core contract that manages ownership, ERC-721 (draft) compliant.
344 contract NarcoOwnership is NarcoBase, ERC721 {
345     string public name = "DopeRaider";
346     string public symbol = "DOPR";
347 
348     function implementsERC721() public pure returns (bool)
349     {
350         return true;
351     }
352 
353     /// @dev Checks if a given address is the current owner of a particular narco.
354     /// @param _claimant the address we are validating against.
355     /// @param _tokenId narco id, only valid when > 0
356     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
357         return narcoIndexToOwner[_tokenId] == _claimant;
358     }
359 
360     /// @dev Checks if a given address currently has transferApproval for a particular narco.
361     /// @param _claimant the address we are confirming narco is approved for.
362     /// @param _tokenId narco id, only valid when > 0
363     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
364         return narcoIndexToApproved[_tokenId] == _claimant;
365     }
366 
367     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
368     ///  approval. Setting _approved to address(0) clears all transfer approval.
369     ///  NOTE: _approve() does NOT send the Approval event.
370     function _approve(uint256 _tokenId, address _approved) internal {
371         narcoIndexToApproved[_tokenId] = _approved;
372     }
373 
374 
375     /// @notice Returns the number of narcos owned by a specific address.
376     /// @param _owner The owner address to check.
377     function balanceOf(address _owner) public view returns (uint256 count) {
378         return ownershipTokenCount[_owner];
379     }
380 
381     /// @notice Transfers a narco to another address. If transferring to a smart
382     ///  contract be VERY CAREFUL to ensure that it is aware of ERC-721 (or
383     ///  DopeRaider specifically) or your narco may be lost forever. Seriously.
384     /// @param _to The address of the recipient, can be a user or contract.
385     /// @param _tokenId The ID of the narco to transfer.
386     function transfer(
387         address _to,
388         uint256 _tokenId
389     )
390         public
391 
392     {
393         require(_to != address(0));
394         require(_owns(msg.sender, _tokenId));
395 
396         _transfer(msg.sender, _to, _tokenId);
397     }
398 
399     /// @notice Grant another address the right to transfer a specific narco via
400     ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
401     /// @param _to The address to be granted transfer approval. Pass address(0) to
402     ///  clear all approvals.
403     /// @param _tokenId The ID of the narco that can be transferred if this call succeeds.
404     function approve(
405         address _to,
406         uint256 _tokenId
407     )
408         public
409 
410     {
411         require(_owns(msg.sender, _tokenId));
412 
413         _approve(_tokenId, _to);
414 
415         Approval(msg.sender, _to, _tokenId);
416     }
417 
418     /// @notice Transfer a narco owned by another address, for which the calling address
419     ///  has previously been granted transfer approval by the owner.
420     /// @param _from The address that owns the narco to be transfered.
421     /// @param _to The address that should take ownership of the narco. Can be any address,
422     ///  including the caller.
423     /// @param _tokenId The ID of the narco to be transferred.
424     function transferFrom(
425         address _from,
426         address _to,
427         uint256 _tokenId
428     )
429         public
430 
431     {
432         require(_approvedFor(msg.sender, _tokenId));
433         require(_owns(_from, _tokenId));
434         require(_to != address(0));
435 
436         _transfer(_from, _to, _tokenId);
437     }
438 
439     function totalSupply() public view returns (uint) {
440         return narcos.length - 1;
441     }
442 
443     function ownerOf(uint256 _tokenId)
444         public
445         view
446         returns (address owner)
447     {
448         owner = narcoIndexToOwner[_tokenId];
449 
450         require(owner != address(0));
451     }
452 
453 
454 
455 }
456 
457 
458 // this helps with district functionality
459 // it gives the ability to an external contract to do the following:
460 // * update narcos stats
461 contract NarcoUpdates is NarcoOwnership {
462 
463     function updateWeedTotal(uint256 _narcoId, bool _add, uint16 _total) public onlyDopeRaiderContract {
464       if(_add==true){
465         narcos[_narcoId].weedTotal+= _total;
466       }else{
467         narcos[_narcoId].weedTotal-= _total;
468       }
469     }
470 
471     function updateCokeTotal(uint256 _narcoId, bool _add, uint16 _total) public onlyDopeRaiderContract {
472        if(_add==true){
473         narcos[_narcoId].cokeTotal+= _total;
474       }else{
475         narcos[_narcoId].cokeTotal-= _total;
476       }
477     }
478 
479     function updateConsumable(uint256 _narcoId, uint256 _index, uint8 _new) public onlyDopeRaiderContract  {
480       narcos[_narcoId].consumables[_index] = _new;
481     }
482 
483     function updateSkill(uint256 _narcoId, uint256 _index, uint16 _new) public onlyDopeRaiderContract  {
484       narcos[_narcoId].skills[_index] = _new;
485     }
486 
487     function incrementStat(uint256 _narcoId , uint256 _index) public onlyDopeRaiderContract  {
488       narcos[_narcoId].stats[_index]++;
489     }
490 
491     function setCooldown(uint256 _narcoId , uint256 _index , uint256 _new) public onlyDopeRaiderContract  {
492       narcos[_narcoId].cooldowns[_index]=_new;
493     }
494 
495 }
496 
497 /// @title Handles creating auctions for sale of narcos.
498 ///  This wrapper of ReverseAuction exists only so that users can create
499 ///  auctions with only one transaction.
500 contract NarcoAuction is NarcoUpdates {
501     SaleClockAuction public saleAuction;
502 
503     function setSaleAuctionAddress(address _address) public onlyCLevel {
504         SaleClockAuction candidateContract = SaleClockAuction(_address);
505         require(candidateContract.isSaleClockAuction());
506         saleAuction = candidateContract;
507     }
508 
509     function createSaleAuction(
510         uint256 _narcoId,
511         uint256 _startingPrice,
512         uint256 _endingPrice,
513         uint256 _duration
514     )
515         public
516         whenNotPaused
517     {
518         // Auction contract checks input sizes
519         // If narco is already on any auction, this will throw
520         // because it will be owned by the auction contract
521         require(_owns(msg.sender, _narcoId));
522         _approve(_narcoId, saleAuction);
523         // Sale auction throws if inputs are invalid and clears
524         // transfer approval after escrowing the narco.
525         saleAuction.createAuction(
526             _narcoId,
527             _startingPrice,
528             _endingPrice,
529             _duration,
530             msg.sender
531         );
532     }
533 
534     /// @dev Transfers the balance of the sale auction contract
535     /// to the DopeRaiderCore contract. We use two-step withdrawal to
536     /// prevent two transfer calls in the auction bid function.
537     function withdrawAuctionBalances() external onlyCLevel {
538         saleAuction.withdrawBalance();
539     }
540 }
541 
542 
543 /// @title all functions related to creating narcos
544 contract NarcoMinting is NarcoAuction {
545 
546     // Limits the number of narcos the contract owner can ever create.
547     uint256 public promoCreationLimit = 200;
548     uint256 public gen0CreationLimit = 5000;
549 
550     // Constants for gen0 auctions.
551     uint256 public gen0StartingPrice = 1 ether;
552     uint256 public gen0EndingPrice = 20 finney;
553     uint256 public gen0AuctionDuration = 1 days;
554 
555     // Counts the number of narcos the contract owner has created.
556     uint256 public promoCreatedCount;
557     uint256 public gen0CreatedCount;
558 
559     /// @dev we can create promo narco, up to a limit
560     function createPromoNarco(
561         string _genes,
562         string _name,
563         address _owner
564     ) public onlyCLevel {
565         if (_owner == address(0)) {
566              _owner = cooAddress;
567         }
568         require(promoCreatedCount < promoCreationLimit);
569         require(gen0CreatedCount < gen0CreationLimit);
570 
571         promoCreatedCount++;
572         gen0CreatedCount++;
573 
574         _createNarco(_genes, _name, _owner);
575     }
576 
577     /// @dev Creates a new gen0 narco with the given genes and
578     ///  creates an auction for it.
579     function createGen0Auction(
580        string _genes,
581         string _name
582     ) public onlyCLevel {
583         require(gen0CreatedCount < gen0CreationLimit);
584 
585         uint256 narcoId = _createNarco(_genes,_name,address(this));
586 
587         _approve(narcoId, saleAuction);
588 
589         saleAuction.createAuction(
590             narcoId,
591             _computeNextGen0Price(),
592             gen0EndingPrice,
593             gen0AuctionDuration,
594             address(this)
595         );
596 
597         gen0CreatedCount++;
598     }
599 
600     /// @dev Computes the next gen0 auction starting price, given
601     ///  the average of the past 4 prices + 50%.
602     function _computeNextGen0Price() internal view returns (uint256) {
603         uint256 avePrice = saleAuction.averageGen0SalePrice();
604 
605         // sanity check to ensure we don't overflow arithmetic (this big number is 2^128-1).
606         require(avePrice < 340282366920938463463374607431768211455);
607 
608         uint256 nextPrice = avePrice + (avePrice / 2);
609 
610         // We never auction for less than starting price
611         if (nextPrice < gen0StartingPrice) {
612             nextPrice = gen0StartingPrice;
613         }
614 
615         return nextPrice;
616     }
617 }
618 
619 
620 /// @title DopeRaider: Collectible, narcos on the Ethereum blockchain.
621 /// @dev The main DopeRaider contract
622 contract DopeRaiderCore is NarcoMinting {
623 
624     // This is the main DopeRaider contract. We have several seperately-instantiated  contracts
625     // that handle auctions, districts and the creation of new narcos. By keeping
626     // them in their own contracts, we can upgrade them without disrupting the main contract that tracks
627     // narco ownership.
628     //
629     //      - NarcoBase: This is where we define the most fundamental code shared throughout the core
630     //             functionality. This includes our main data storage, constants and data types, plus
631     //             internal functions for managing these items.
632     //
633     //      - NarcoAccessControl: This contract manages the various addresses and constraints for operations
634     //             that can be executed only by specific roles. Namely CEO, CFO and COO.
635     //
636     //      - NarcoOwnership: This provides the methods required for basic non-fungible token
637     //             transactions, following the draft ERC-721 spec (https://github.com/ethereum/EIPs/issues/721).
638     //
639     //      - NarcoUpdates: This file contains the methods necessary to allow a separate contract to update narco stats
640     //
641     //      - NarcoAuction: Here we have the public methods for auctioning or bidding on narcos.
642     //             The actual auction functionality is handled in a sibling sales contract,
643     //             while auction creation and bidding is mostly mediated through this facet of the core contract.
644     //
645     //      - NarcoMinting: This final facet contains the functionality we use for creating new gen0 narcos.
646     //             We can make up to 4096 "promo" narcos
647 
648     // Set in case the core contract is broken and an upgrade is required
649     address public newContractAddress;
650 
651     bool public gamePaused = true;
652 
653     modifier whenGameNotPaused() {
654         require(!gamePaused);
655         _;
656     }
657 
658     /// @dev Modifier to allow actions only when the contract IS paused
659     modifier whenGamePaused {
660         require(gamePaused);
661         _;
662     }
663 
664     function pause() public onlyCLevel whenGameNotPaused {
665         gamePaused = true;
666     }
667 
668     function unpause() public onlyCLevel whenGamePaused {
669         // can't unpause if contract was upgraded
670         gamePaused = false;
671     }
672 
673 
674     // EVENTS
675     event GrowWeedCompleted(uint256 indexed narcoId, uint yield);
676     event RefineCokeCompleted(uint256 indexed narcoId, uint yield);
677 
678     function DopeRaiderCore() public {
679         ceoAddress = msg.sender;
680         cooAddress = msg.sender;
681     }
682 
683     /// @dev Used to mark the smart contract as upgraded, in case there is a serious
684     ///  breaking bug. This method does nothing but keep track of the new contract and
685     ///  emit a message indicating that the new address is set. It's up to clients of this
686     ///  contract to update to the new contract address in that case. (This contract will
687     ///  be paused indefinitely if such an upgrade takes place.)
688     /// @param _v2Address new address
689     function setNewAddress(address _v2Address) public onlyCLevel whenPaused {
690         newContractAddress = _v2Address;
691         ContractUpgrade(_v2Address);
692     }
693 
694     /// @notice No tipping!
695     /// @dev Reject all Ether from being sent here, unless it's from one of the
696     ///  two auction contracts. (Hopefully, we can prevent user accidents.)
697     function() external payable {
698         require(msg.sender == address(saleAuction));
699     }
700 
701     /// @param _id The ID of the narco of interest.
702 
703    function getNarco(uint256 _id)
704         public
705         view
706         returns (
707         string  narcoName,
708         uint256 weedTotal,
709         uint256 cokeTotal,
710         uint16[6] skills,
711         uint8[4] consumables,
712         string genes,
713         uint8 homeLocation,
714         uint16 level,
715         uint256[6] cooldowns,
716         uint256 id,
717         uint16 [9] stats
718     ) {
719         Narco storage narco = narcos[_id];
720         narcoName = narco.narcoName;
721         weedTotal = narco.weedTotal;
722         cokeTotal = narco.cokeTotal;
723         skills = narco.skills;
724         consumables = narco.consumables;
725         genes = narco.genes;
726         homeLocation = narco.homeLocation;
727         level = getLevel(_id);
728         cooldowns = narco.cooldowns;
729         id = _id;
730         stats = narco.stats;
731     }
732 
733     uint256 public changeIdentityNarcoRespect = 30;
734     function setChangeIdentityNarcoRespect(uint256 _respect) public onlyCLevel {
735       changeIdentityNarcoRespect=_respect;
736     }
737 
738     uint256 public personalisationCost = 0.01 ether; // pimp my narco
739     function setPersonalisationCost(uint256 _cost) public onlyCLevel {
740       personalisationCost=_cost;
741     }
742     function updateNarco(uint256 _narcoId, string _genes, string _name) public payable whenGameNotPaused {
743        require(getLevel(_narcoId)>=changeIdentityNarcoRespect); // minimum level to recruit a narco
744        require(msg.sender==narcoIndexToOwner[_narcoId]); // can't be moving other peoples narcos about
745        require(msg.value>=personalisationCost);
746        narcos[_narcoId].genes = _genes;
747        narcos[_narcoId].narcoName = _name;
748     }
749 
750     uint256 public respectRequiredToRecruit = 150;
751 
752     function setRespectRequiredToRecruit(uint256 _respect) public onlyCLevel {
753       respectRequiredToRecruit=_respect;
754     }
755 
756     function recruitNarco(uint256 _narcoId, string _genes, string _name) public whenGameNotPaused {
757        require(msg.sender==narcoIndexToOwner[_narcoId]); // can't be moving other peoples narcos about
758        require(getLevel(_narcoId)>=respectRequiredToRecruit); // minimum level to recruit a narco
759        require(narcos[_narcoId].stats[8]<getLevel(_narcoId)/respectRequiredToRecruit); // must have recruited < respect / required reqpect (times)
760       _createNarco(_genes,_name, msg.sender);
761       narcos[_narcoId].stats[8]+=1; // increase number recruited
762     }
763 
764    // crafting section
765     uint256 public growCost = 0.003 ether;
766     function setGrowCost(uint256 _cost) public onlyCLevel{
767       growCost=_cost;
768     }
769 
770     function growWeed(uint256 _narcoId) public payable whenGameNotPaused{
771          require(msg.sender==narcoIndexToOwner[_narcoId]); // can't be moving other peoples narcos about
772          require(msg.value>=growCost);
773          require(now>narcos[_narcoId].cooldowns[1]); //cooldown must have expired
774          uint16 growSkillLevel = narcos[_narcoId].skills[1]; // grow
775          uint16 maxYield = 9 + growSkillLevel; // max amount can be grown based on skill
776          uint yield = min(narcos[_narcoId].consumables[1],maxYield);
777          require(yield>0); // gotta produce something
778 
779          // must be home location
780          uint8 district = districtsCore.getNarcoLocation(_narcoId);
781          require(district==narcos[_narcoId].homeLocation);
782 
783          // do the crafting
784          uint256 cooldown = now + ((910-(10*growSkillLevel))* 1 seconds); //calculate cooldown switch to minutes later
785 
786          narcos[_narcoId].cooldowns[1]=cooldown;
787          // use all available  - for now , maybe later make optional
788          narcos[_narcoId].consumables[1]=uint8(subToZero(uint256(narcos[_narcoId].consumables[1]),yield));
789          narcos[_narcoId].weedTotal+=uint8(yield);
790 
791          narcos[_narcoId].stats[1]+=1; // update the statistic for grow
792          districtsCore.increaseDistrictWeed(district , yield);
793          districtsCore.distributeRevenue.value(growCost)(uint256(district),50,50); // distribute the revenue to districts pots
794          GrowWeedCompleted(_narcoId, yield); // notification event
795     }
796 
797 
798     uint256 public refineCost = 0.003 ether;
799     function setRefineCost(uint256 _cost) public onlyCLevel{
800       refineCost=_cost;
801     }
802 
803     function refineCoke(uint256 _narcoId) public payable whenGameNotPaused{
804          require(msg.sender==narcoIndexToOwner[_narcoId]); // can't be moving other peoples narcos about
805          require(msg.value>=refineCost);
806          require(now>narcos[_narcoId].cooldowns[2]); //cooldown must have expired
807          uint16 refineSkillLevel = narcos[_narcoId].skills[2]; // refine
808          uint16 maxYield = 3+(refineSkillLevel/3); // max amount can be grown based on skill
809          uint yield = min(narcos[_narcoId].consumables[2],maxYield);
810          require(yield>0); // gotta produce something
811 
812          // must be home location
813          uint8 district = districtsCore.getNarcoLocation(_narcoId);
814          require(district==narcos[_narcoId].homeLocation);
815 
816          // do the crafting
817         // uint256 cooldown = now + min(3 minutes,((168-(2*refineSkillLevel))* 1 seconds)); // calculate cooldown
818          uint256 cooldown = now + ((910-(10*refineSkillLevel))* 1 seconds); // calculate cooldown
819 
820          narcos[_narcoId].cooldowns[2]=cooldown;
821          // use all available  - for now , maybe later make optional
822          narcos[_narcoId].consumables[2]=uint8(subToZero(uint256(narcos[_narcoId].consumables[2]),yield));
823          narcos[_narcoId].cokeTotal+=uint8(yield);
824 
825          narcos[_narcoId].stats[2]+=1;
826          districtsCore.increaseDistrictCoke(district, yield);
827          districtsCore.distributeRevenue.value(refineCost)(uint256(district),50,50); // distribute the revenue to districts pots
828          RefineCokeCompleted(_narcoId, yield); // notification event
829 
830     }
831 
832 
833     function min(uint a, uint b) private pure returns (uint) {
834              return a < b ? a : b;
835     }
836 
837 }