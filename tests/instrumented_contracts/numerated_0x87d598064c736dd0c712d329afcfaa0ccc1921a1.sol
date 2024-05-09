1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 /**
44  * @title Pausable
45  * @dev Base contract which allows children to implement an emergency stop mechanism.
46  */
47 contract Pausable is Ownable {
48   event Pause();
49   event Unpause();
50 
51   bool public paused = false;
52 
53 
54   /**
55    * @dev Modifier to make a function callable only when the contract is not paused.
56    */
57   modifier whenNotPaused() {
58     require(!paused);
59     _;
60   }
61 
62   /**
63    * @dev Modifier to make a function callable only when the contract is paused.
64    */
65   modifier whenPaused() {
66     require(paused);
67     _;
68   }
69 
70   /**
71    * @dev called by the owner to pause, triggers stopped state
72    */
73   function pause() onlyOwner whenNotPaused public {
74     paused = true;
75     Pause();
76   }
77 
78   /**
79    * @dev called by the owner to unpause, returns to normal state
80    */
81   function unpause() onlyOwner whenPaused public {
82     paused = false;
83     Unpause();
84   }
85 }
86 /// @title Auction Core
87 /// @dev Contains models, variables, and internal methods for the auction.
88 contract ClockAuctionBase {
89 
90     // Represents an auction on an NFT
91     struct Auction {
92         // Current owner of NFT
93         address seller;
94         // Price (in wei) at beginning of auction
95         uint128 startingPrice;
96         // Price (in wei) at end of auction
97         uint128 endingPrice;
98         // Duration (in seconds) of auction
99         uint64 duration;
100         // Time when auction started
101         // NOTE: 0 if this auction has been concluded
102         uint64 startedAt;
103     }
104 
105     // Reference to contract tracking NFT ownership
106     ERC721 public nonFungibleContract;
107 
108     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
109     // Values 0-10,000 map to 0%-100%
110     uint256 public ownerCut;
111 
112     // Map from token ID to their corresponding auction.
113     mapping (uint256 => Auction) tokenIdToAuction;
114 
115     event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
116     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
117     event AuctionCancelled(uint256 tokenId);
118 
119     /// @dev DON'T give me your money.
120     function() external {}
121 
122     // Modifiers to check that inputs can be safely stored with a certain
123     // number of bits. We use constants and multiple modifiers to save gas.
124     modifier canBeStoredWith64Bits(uint256 _value) {
125         require(_value <= 18446744073709551615);
126         _;
127     }
128 
129     modifier canBeStoredWith128Bits(uint256 _value) {
130         require(_value < 340282366920938463463374607431768211455);
131         _;
132     }
133 
134     /// @dev Returns true if the claimant owns the token.
135     /// @param _claimant - Address claiming to own the token.
136     /// @param _tokenId - ID of token whose ownership to verify.
137     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
138         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
139     }
140 
141     /// @dev Escrows the NFT, assigning ownership to this contract.
142     /// Throws if the escrow fails.
143     /// @param _owner - Current owner address of token to escrow.
144     /// @param _tokenId - ID of token whose approval to verify.
145     function _escrow(address _owner, uint256 _tokenId) internal {
146         // it will throw if transfer fails
147         nonFungibleContract.transferFrom(_owner, this, _tokenId);
148     }
149 
150     /// @dev Transfers an NFT owned by this contract to another address.
151     /// Returns true if the transfer succeeds.
152     /// @param _receiver - Address to transfer NFT to.
153     /// @param _tokenId - ID of token to transfer.
154     function _transfer(address _receiver, uint256 _tokenId) internal {
155         // it will throw if transfer fails
156         nonFungibleContract.transfer(_receiver, _tokenId);
157     }
158 
159     /// @dev Adds an auction to the list of open auctions. Also fires the
160     ///  AuctionCreated event.
161     /// @param _tokenId The ID of the token to be put on auction.
162     /// @param _auction Auction to add.
163     function _addAuction(uint256 _tokenId, Auction _auction) internal {
164         // Require that all auctions have a duration of
165         // at least one minute. (Keeps our math from getting hairy!)
166         require(_auction.duration >= 1 minutes);
167 
168         tokenIdToAuction[_tokenId] = _auction;
169         
170         AuctionCreated(
171             uint256(_tokenId),
172             uint256(_auction.startingPrice),
173             uint256(_auction.endingPrice),
174             uint256(_auction.duration)
175         );
176     }
177 
178     /// @dev Cancels an auction unconditionally.
179     function _cancelAuction(uint256 _tokenId, address _seller) internal {
180         _removeAuction(_tokenId);
181         _transfer(_seller, _tokenId);
182         AuctionCancelled(_tokenId);
183     }
184 
185     /// @dev Computes the price and transfers winnings.
186     /// Does NOT transfer ownership of token.
187     function _bid(uint256 _tokenId, uint256 _bidAmount)
188         internal
189         returns (uint256)
190     {
191         // Get a reference to the auction struct
192         Auction storage auction = tokenIdToAuction[_tokenId];
193 
194         // Explicitly check that this auction is currently live.
195         // (Because of how Ethereum mappings work, we can't just count
196         // on the lookup above failing. An invalid _tokenId will just
197         // return an auction object that is all zeros.)
198         require(_isOnAuction(auction));
199 
200         // Check that the incoming bid is higher than the current
201         // price
202         uint256 price = _currentPrice(auction);
203         require(_bidAmount >= price);
204 
205         // Grab a reference to the seller before the auction struct
206         // gets deleted.
207         address seller = auction.seller;
208 
209         // The bid is good! Remove the auction before sending the fees
210         // to the sender so we can't have a reentrancy attack.
211         _removeAuction(_tokenId);
212 
213         // Transfer proceeds to seller (if there are any!)
214         if (price > 0) {
215             //  Calculate the auctioneer's cut.
216             // (NOTE: _computeCut() is guaranteed to return a
217             //  value <= price, so this subtraction can't go negative.)
218             uint256 auctioneerCut = _computeCut(price);
219             uint256 sellerProceeds = price - auctioneerCut;
220 
221             // NOTE: Doing a transfer() in the middle of a complex
222             // method like this is generally discouraged because of
223             // reentrancy attacks and DoS attacks if the seller is
224             // a contract with an invalid fallback function. We explicitly
225             // guard against reentrancy attacks by removing the auction
226             // before calling transfer(), and the only thing the seller
227             // can DoS is the sale of their own asset! (And if it's an
228             // accident, they can call cancelAuction(). )
229             seller.transfer(sellerProceeds);
230         }
231 
232         // Tell the world!
233         AuctionSuccessful(_tokenId, price, msg.sender);
234 
235         return price;
236     }
237 
238     /// @dev Removes an auction from the list of open auctions.
239     /// @param _tokenId - ID of NFT on auction.
240     function _removeAuction(uint256 _tokenId) internal {
241         delete tokenIdToAuction[_tokenId];
242     }
243 
244     /// @dev Returns true if the NFT is on auction.
245     /// @param _auction - Auction to check.
246     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
247         return (_auction.startedAt > 0);
248     }
249 
250     /// @dev Returns current price of an NFT on auction. Broken into two
251     ///  functions (this one, that computes the duration from the auction
252     ///  structure, and the other that does the price computation) so we
253     ///  can easily test that the price computation works correctly.
254     function _currentPrice(Auction storage _auction)
255         internal
256         view
257         returns (uint256)
258     {
259         uint256 secondsPassed = 0;
260         
261         // A bit of insurance against negative values (or wraparound).
262         // Probably not necessary (since Ethereum guarnatees that the
263         // now variable doesn't ever go backwards).
264         if (now > _auction.startedAt) {
265             secondsPassed = now - _auction.startedAt;
266         }
267 
268         return _computeCurrentPrice(
269             _auction.startingPrice,
270             _auction.endingPrice,
271             _auction.duration,
272             secondsPassed
273         );
274     }
275 
276     /// @dev Computes the current price of an auction. Factored out
277     ///  from _currentPrice so we can run extensive unit tests.
278     ///  When testing, make this function public and turn on
279     ///  `Current price computation` test suite.
280     function _computeCurrentPrice(
281         uint256 _startingPrice,
282         uint256 _endingPrice,
283         uint256 _duration,
284         uint256 _secondsPassed
285     )
286         internal
287         pure
288         returns (uint256)
289     {
290         // NOTE: We don't use SafeMath (or similar) in this function because
291         //  all of our public functions carefully cap the maximum values for
292         //  time (at 64-bits) and currency (at 128-bits). _duration is
293         //  also known to be non-zero (see the require() statement in
294         //  _addAuction())
295         if (_secondsPassed >= _duration) {
296             // We've reached the end of the dynamic pricing portion
297             // of the auction, just return the end price.
298             return _endingPrice;
299         } else {
300             // Starting price can be higher than ending price (and often is!), so
301             // this delta can be negative.
302             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
303             
304             // This multiplication can't overflow, _secondsPassed will easily fit within
305             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
306             // will always fit within 256-bits.
307             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
308             
309             // currentPriceChange can be negative, but if so, will have a magnitude
310             // less that _startingPrice. Thus, this result will always end up positive.
311             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
312             
313             return uint256(currentPrice);
314         }
315     }
316 
317     /// @dev Computes owner's cut of a sale.
318     /// @param _price - Sale price of NFT.
319     function _computeCut(uint256 _price) internal view returns (uint256) {
320         // NOTE: We don't use SafeMath (or similar) in this function because
321         //  all of our entry functions carefully cap the maximum values for
322         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
323         //  statement in the ClockAuction constructor). The result of this
324         //  function is always guaranteed to be <= _price.
325         return _price * ownerCut / 10000;
326     }
327 
328 }
329 
330 
331 /// @title Clock auction for non-fungible tokens.
332 contract ClockAuction is Pausable, ClockAuctionBase {
333 
334     /// @dev Constructor creates a reference to the NFT ownership contract
335     ///  and verifies the owner cut is in the valid range.
336     /// @param _nftAddress - address of a deployed contract implementing
337     ///  the Nonfungible Interface.
338     /// @param _cut - percent cut the owner takes on each auction, must be
339     ///  between 0-10,000.
340     function ClockAuction(address _nftAddress, uint256 _cut) public {
341         require(_cut <= 10000);
342         ownerCut = _cut;
343         
344         ERC721 candidateContract = ERC721(_nftAddress);
345         require(candidateContract.implementsERC721());
346         nonFungibleContract = candidateContract;
347     }
348 
349     /// @dev Remove all Ether from the contract, which is the owner's cuts
350     ///  as well as any Ether sent directly to the contract address.
351     ///  Always transfers to the NFT contract, but can be called either by
352     ///  the owner or the NFT contract.
353     function withdrawBalance() external {
354         address nftAddress = address(nonFungibleContract);
355 
356         require(
357             msg.sender == owner ||
358             msg.sender == nftAddress
359         );
360         nftAddress.transfer(this.balance);
361     }
362 
363     /// @dev Creates and begins a new auction.
364     /// @param _tokenId - ID of token to auction, sender must be owner.
365     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
366     /// @param _endingPrice - Price of item (in wei) at end of auction.
367     /// @param _duration - Length of time to move between starting
368     ///  price and ending price (in seconds).
369     /// @param _seller - Seller, if not the message sender
370     function createAuction(
371         uint256 _tokenId,
372         uint256 _startingPrice,
373         uint256 _endingPrice,
374         uint256 _duration,
375         address _seller
376     )
377         public
378         whenNotPaused
379         canBeStoredWith128Bits(_startingPrice)
380         canBeStoredWith128Bits(_endingPrice)
381         canBeStoredWith64Bits(_duration)
382     {
383         require(_owns(msg.sender, _tokenId));
384         _escrow(msg.sender, _tokenId);
385         Auction memory auction = Auction(
386             _seller,
387             uint128(_startingPrice),
388             uint128(_endingPrice),
389             uint64(_duration),
390             uint64(now)
391         );
392         _addAuction(_tokenId, auction);
393     }
394 
395     /// @dev Bids on an open auction, completing the auction and transferring
396     ///  ownership of the NFT if enough Ether is supplied.
397     /// @param _tokenId - ID of token to bid on.
398     function bid(uint256 _tokenId)
399         public
400         payable
401         whenNotPaused
402     {
403         // _bid will throw if the bid or funds transfer fails
404         _bid(_tokenId, msg.value);
405         _transfer(msg.sender, _tokenId);
406     }
407 
408     /// @dev Cancels an auction that hasn't been won yet.
409     ///  Returns the NFT to original owner.
410     /// @notice This is a state-modifying function that can
411     ///  be called while the contract is paused.
412     /// @param _tokenId - ID of token on auction
413     function cancelAuction(uint256 _tokenId)
414         public
415     {
416         Auction storage auction = tokenIdToAuction[_tokenId];
417         require(_isOnAuction(auction));
418         address seller = auction.seller;
419         require(msg.sender == seller);
420         _cancelAuction(_tokenId, seller);
421     }
422 
423     /// @dev Cancels an auction when the contract is paused.
424     ///  Only the owner may do this, and NFTs are returned to
425     ///  the seller. This should only be used in emergencies.
426     /// @param _tokenId - ID of the NFT on auction to cancel.
427     function cancelAuctionWhenPaused(uint256 _tokenId)
428         whenPaused
429         onlyOwner
430         public
431     {
432         Auction storage auction = tokenIdToAuction[_tokenId];
433         require(_isOnAuction(auction));
434         _cancelAuction(_tokenId, auction.seller);
435     }
436 
437     /// @dev Returns auction info for an NFT on auction.
438     /// @param _tokenId - ID of NFT on auction.
439     function getAuction(uint256 _tokenId)
440         public
441         view
442         returns
443     (
444         address seller,
445         uint256 startingPrice,
446         uint256 endingPrice,
447         uint256 duration,
448         uint256 startedAt
449     ) {
450         Auction storage auction = tokenIdToAuction[_tokenId];
451         require(_isOnAuction(auction));
452         return (
453             auction.seller,
454             auction.startingPrice,
455             auction.endingPrice,
456             auction.duration,
457             auction.startedAt
458         );
459     }
460 
461     /// @dev Returns the current price of an auction.
462     /// @param _tokenId - ID of the token price we are checking.
463     function getCurrentPrice(uint256 _tokenId)
464         public
465         view
466         returns (uint256)
467     {
468         Auction storage auction = tokenIdToAuction[_tokenId];
469         require(_isOnAuction(auction));
470         return _currentPrice(auction);
471     }
472 
473 }
474 
475 
476 /// @title Clock auction modified for sale of fighters
477 contract SaleClockAuction is ClockAuction {
478 
479     // @dev Sanity check that allows us to ensure that we are pointing to the
480     //  right auction in our setSaleAuctionAddress() call.
481     bool public isSaleClockAuction = true;
482     
483     // Tracks last 4 sale price of gen0 fighter sales
484     uint256 public gen0SaleCount;
485     uint256[4] public lastGen0SalePrices;
486 
487     // Delegate constructor
488     function SaleClockAuction(address _nftAddr, uint256 _cut) public
489         ClockAuction(_nftAddr, _cut) {}
490 
491     /// @dev Creates and begins a new auction.
492     /// @param _tokenId - ID of token to auction, sender must be owner.
493     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
494     /// @param _endingPrice - Price of item (in wei) at end of auction.
495     /// @param _duration - Length of auction (in seconds).
496     /// @param _seller - Seller, if not the message sender
497     function createAuction(
498         uint256 _tokenId,
499         uint256 _startingPrice,
500         uint256 _endingPrice,
501         uint256 _duration,
502         address _seller
503     )
504         public
505         canBeStoredWith128Bits(_startingPrice)
506         canBeStoredWith128Bits(_endingPrice)
507         canBeStoredWith64Bits(_duration)
508     {
509         require(msg.sender == address(nonFungibleContract));
510         _escrow(_seller, _tokenId);
511         Auction memory auction = Auction(
512             _seller,
513             uint128(_startingPrice),
514             uint128(_endingPrice),
515             uint64(_duration),
516             uint64(now)
517         );
518         _addAuction(_tokenId, auction);
519     }
520 
521     /// @dev Updates lastSalePrice if seller is the nft contract
522     /// Otherwise, works the same as default bid method.
523     function bid(uint256 _tokenId)
524         public
525         payable
526     {
527         // _bid verifies token ID size
528         address seller = tokenIdToAuction[_tokenId].seller;
529         uint256 price = _bid(_tokenId, msg.value);
530         _transfer(msg.sender, _tokenId);
531 
532         // If not a gen0 auction, exit
533         if (seller == address(nonFungibleContract)) {
534             // Track gen0 sale prices
535             lastGen0SalePrices[gen0SaleCount % 4] = price;
536             gen0SaleCount++;
537         }
538     }
539 
540     function averageGen0SalePrice() public view returns (uint256) {
541         uint256 sum = 0;
542         for (uint256 i = 0; i < 4; i++) {
543             sum += lastGen0SalePrices[i];
544         }
545         return sum / 4;
546     }
547 
548 }
549 
550 
551 /// @title A facet of FighterCore that manages special access privileges.
552 contract FighterAccessControl {
553     /// @dev Emited when contract is upgraded
554     event ContractUpgrade(address newContract);
555 
556     address public ceoAddress;
557     address public cfoAddress;
558     address public cooAddress;
559 
560     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
561     bool public paused = false;
562 
563     modifier onlyCEO() {
564         require(msg.sender == ceoAddress);
565         _;
566     }
567 
568     modifier onlyCFO() {
569         require(msg.sender == cfoAddress);
570         _;
571     }
572 
573     modifier onlyCOO() {
574         require(msg.sender == cooAddress);
575         _;
576     }
577 
578     modifier onlyCLevel() {
579         require(
580             msg.sender == cooAddress ||
581             msg.sender == ceoAddress ||
582             msg.sender == cfoAddress
583         );
584         _;
585     }
586 
587     function setCEO(address _newCEO) public onlyCEO {
588         require(_newCEO != address(0));
589 
590         ceoAddress = _newCEO;
591     }
592 
593     function setCFO(address _newCFO) public onlyCEO {
594         require(_newCFO != address(0));
595 
596         cfoAddress = _newCFO;
597     }
598 
599     function setCOO(address _newCOO) public onlyCEO {
600         require(_newCOO != address(0));
601 
602         cooAddress = _newCOO;
603     }
604 
605     function withdrawBalance() external onlyCFO {
606         cfoAddress.transfer(this.balance);
607     }
608 
609 
610     /*** Pausable functionality adapted from OpenZeppelin ***/
611 
612     /// @dev Modifier to allow actions only when the contract IS NOT paused
613     modifier whenNotPaused() {
614         require(!paused);
615         _;
616     }
617 
618     /// @dev Modifier to allow actions only when the contract IS paused
619     modifier whenPaused {
620         require(paused);
621         _;
622     }
623 
624     function pause() public onlyCLevel whenNotPaused {
625         paused = true;
626     }
627 
628     function unpause() public onlyCEO whenPaused {
629         // can't unpause if contract was upgraded
630         paused = false;
631     }
632 }
633 
634 
635 /// @title Base contract for CryptoFighters. Holds all common structs, events and base variables.
636 contract FighterBase is FighterAccessControl {
637     /*** EVENTS ***/
638 
639     event FighterCreated(address indexed owner, uint256 fighterId, uint256 genes);
640 
641     /// @dev Transfer event as defined in current draft of ERC721. Emitted every time a fighter
642     ///  ownership is assigned, including newly created fighters.
643     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
644 
645     /*** DATA TYPES ***/
646 
647     /// @dev The main Fighter struct. Every fighter in CryptoFighters is represented by a copy
648     ///  of this structure.
649     struct Fighter {
650         // The Fighter's genetic code is packed into these 256-bits.
651         // A fighter's genes never change.
652         uint256 genes;
653 
654         // The minimum timestamp after which this fighter can win a prize fighter again
655         uint64 prizeCooldownEndTime;
656 
657         // The minimum timestamp after which this fighter can engage in battle again
658         uint64 battleCooldownEndTime;
659 
660         // battle experience
661         uint32 experience;
662 
663         // Set to the index that represents the current cooldown duration for this Fighter.
664         // Incremented by one for each successful prize won in battle
665         uint16 prizeCooldownIndex;
666 
667         uint16 battlesFought;
668         uint16 battlesWon;
669 
670         // The "generation number" of this fighter. Fighters minted by the CF contract
671         // for sale are called "gen0" and have a generation number of 0.
672         uint16 generation;
673 
674         uint8 dexterity;
675         uint8 strength;
676         uint8 vitality;
677         uint8 luck;
678     }
679 
680     /*** STORAGE ***/
681 
682     /// @dev An array containing the Fighter struct for all Fighters in existence. The ID
683     ///  of each fighter is actually an index into this array. Note that ID 0 is a negafighter.
684     ///  Fighter ID 0 is invalid.
685     Fighter[] fighters;
686 
687     /// @dev A mapping from fighter IDs to the address that owns them. All fighters have
688     ///  some valid owner address, even gen0 fighters are created with a non-zero owner.
689     mapping (uint256 => address) public fighterIndexToOwner;
690 
691     // @dev A mapping from owner address to count of tokens that address owns.
692     //  Used internally inside balanceOf() to resolve ownership count.
693     mapping (address => uint256) ownershipTokenCount;
694 
695     /// @dev A mapping from FighterIDs to an address that has been approved to call
696     ///  transferFrom(). A zero value means no approval is outstanding.
697     mapping (uint256 => address) public fighterIndexToApproved;
698     
699     function _transfer(address _from, address _to, uint256 _tokenId) internal {
700         // since the number of fighters is capped to 2^32
701         // there is no way to overflow this
702         ownershipTokenCount[_to]++;
703         fighterIndexToOwner[_tokenId] = _to;
704 
705         if (_from != address(0)) {
706             ownershipTokenCount[_from]--;
707             delete fighterIndexToApproved[_tokenId];
708         }
709 
710         Transfer(_from, _to, _tokenId);
711     }
712 
713     // Will generate both a FighterCreated event
714     function _createFighter(
715         uint16 _generation,
716         uint256 _genes,
717         uint8 _dexterity,
718         uint8 _strength,
719         uint8 _vitality,
720         uint8 _luck,
721         address _owner
722     )
723         internal
724         returns (uint)
725     {
726         Fighter memory _fighter = Fighter({
727             genes: _genes,
728             prizeCooldownEndTime: 0,
729             battleCooldownEndTime: 0,
730             prizeCooldownIndex: 0,
731             battlesFought: 0,
732             battlesWon: 0,
733             experience: 0,
734             generation: _generation,
735             dexterity: _dexterity,
736             strength: _strength,
737             vitality: _vitality,
738             luck: _luck
739         });
740         uint256 newFighterId = fighters.push(_fighter) - 1;
741 
742         require(newFighterId <= 4294967295);
743 
744         FighterCreated(_owner, newFighterId, _fighter.genes);
745 
746         _transfer(0, _owner, newFighterId);
747 
748         return newFighterId;
749     }
750 }
751 
752 
753 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
754 contract ERC721 {
755     function implementsERC721() public pure returns (bool);
756     function totalSupply() public view returns (uint256 total);
757     function balanceOf(address _owner) public view returns (uint256 balance);
758     function ownerOf(uint256 _tokenId) public view returns (address owner);
759     function approve(address _to, uint256 _tokenId) public;
760     function transferFrom(address _from, address _to, uint256 _tokenId) public;
761     function transfer(address _to, uint256 _tokenId) public;
762     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
763     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
764 
765     // Optional
766     // function name() public view returns (string name);
767     // function symbol() public view returns (string symbol);
768     // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
769     // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
770 }
771 
772 /// @title The facet of the CryptoFighters core contract that manages ownership, ERC-721 (draft) compliant.
773 contract FighterOwnership is FighterBase, ERC721 {
774     string public name = "CryptoFighters";
775     string public symbol = "CF";
776 
777     function implementsERC721() public pure returns (bool)
778     {
779         return true;
780     }
781     
782     /// @dev Checks if a given address is the current owner of a particular Fighter.
783     /// @param _claimant the address we are validating against.
784     /// @param _tokenId fighter id, only valid when > 0
785     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
786         return fighterIndexToOwner[_tokenId] == _claimant;
787     }
788 
789     /// @dev Checks if a given address currently has transferApproval for a particular Fighter.
790     /// @param _claimant the address we are confirming fighter is approved for.
791     /// @param _tokenId fighter id, only valid when > 0
792     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
793         return fighterIndexToApproved[_tokenId] == _claimant;
794     }
795 
796     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
797     ///  approval. Setting _approved to address(0) clears all transfer approval.
798     ///  NOTE: _approve() does NOT send the Approval event.
799     function _approve(uint256 _tokenId, address _approved) internal {
800         fighterIndexToApproved[_tokenId] = _approved;
801     }
802 
803     /// @dev Transfers a fighter owned by this contract to the specified address.
804     ///  Used to rescue lost fighters. (There is no "proper" flow where this contract
805     ///  should be the owner of any Fighter. This function exists for us to reassign
806     ///  the ownership of Fighters that users may have accidentally sent to our address.)
807     /// @param _fighterId - ID of fighter
808     /// @param _recipient - Address to send the fighter to
809     function rescueLostFighter(uint256 _fighterId, address _recipient) public onlyCOO whenNotPaused {
810         require(_owns(this, _fighterId));
811         _transfer(this, _recipient, _fighterId);
812     }
813 
814     /// @notice Returns the number of Fighters owned by a specific address.
815     /// @param _owner The owner address to check.
816     function balanceOf(address _owner) public view returns (uint256 count) {
817         return ownershipTokenCount[_owner];
818     }
819 
820     /// @notice Transfers a Fighter to another address. If transferring to a smart
821     ///  contract be VERY CAREFUL to ensure that it is aware of ERC-721 (or
822     ///  CryptoFighters specifically) or your Fighter may be lost forever. Seriously.
823     /// @param _to The address of the recipient, can be a user or contract.
824     /// @param _tokenId The ID of the Fighter to transfer.
825     function transfer(
826         address _to,
827         uint256 _tokenId
828     )
829         public
830         whenNotPaused
831     {
832         require(_to != address(0));
833         require(_owns(msg.sender, _tokenId));
834 
835         _transfer(msg.sender, _to, _tokenId);
836     }
837 
838     /// @notice Grant another address the right to transfer a specific Fighter via
839     ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
840     /// @param _to The address to be granted transfer approval. Pass address(0) to
841     ///  clear all approvals.
842     /// @param _tokenId The ID of the Fighter that can be transferred if this call succeeds.
843     function approve(
844         address _to,
845         uint256 _tokenId
846     )
847         public
848         whenNotPaused
849     {
850         require(_owns(msg.sender, _tokenId));
851 
852         _approve(_tokenId, _to);
853 
854         Approval(msg.sender, _to, _tokenId);
855     }
856 
857     /// @notice Transfer a Fighter owned by another address, for which the calling address
858     ///  has previously been granted transfer approval by the owner.
859     /// @param _from The address that owns the Fighter to be transfered.
860     /// @param _to The address that should take ownership of the Fighter. Can be any address,
861     ///  including the caller.
862     /// @param _tokenId The ID of the Fighter to be transferred.
863     function transferFrom(
864         address _from,
865         address _to,
866         uint256 _tokenId
867     )
868         public
869         whenNotPaused
870     {
871         require(_approvedFor(msg.sender, _tokenId));
872         require(_owns(_from, _tokenId));
873 
874         _transfer(_from, _to, _tokenId);
875     }
876 
877     function totalSupply() public view returns (uint) {
878         return fighters.length - 1;
879     }
880 
881     function ownerOf(uint256 _tokenId)
882         public
883         view
884         returns (address owner)
885     {
886         owner = fighterIndexToOwner[_tokenId];
887 
888         require(owner != address(0));
889     }
890 
891     /// @notice Returns the nth Fighter assigned to an address, with n specified by the
892     ///  _index argument.
893     /// @param _owner The owner whose Fighters we are interested in.
894     /// @param _index The zero-based index of the fighter within the owner's list of fighters.
895     ///  Must be less than balanceOf(_owner).
896     /// @dev This method MUST NEVER be called by smart contract code. It will almost
897     ///  certainly blow past the block gas limit once there are a large number of
898     ///  Fighters in existence. Exists only to allow off-chain queries of ownership.
899     ///  Optional method for ERC-721.
900     function tokensOfOwnerByIndex(address _owner, uint256 _index)
901         external
902         view
903         returns (uint256 tokenId)
904     {
905         uint256 count = 0;
906         for (uint256 i = 1; i <= totalSupply(); i++) {
907             if (fighterIndexToOwner[i] == _owner) {
908                 if (count == _index) {
909                     return i;
910                 } else {
911                     count++;
912                 }
913             }
914         }
915         revert();
916     }
917 }
918 
919 
920 // this helps with battle functionality
921 // it gives the ability to an external contract to do the following:
922 // * create fighters as rewards
923 // * update fighter stats
924 // * update cooldown data for next prize/battle
925 contract FighterBattle is FighterOwnership {
926     event FighterUpdated(uint256 fighterId);
927     
928     /// @dev The address of the sibling contract that handles battles
929     address public battleContractAddress;
930 
931     /// @dev If set to false the `battleContractAddress` can never be updated again
932     bool public battleContractAddressCanBeUpdated = true;
933     
934     function setBattleAddress(address _address) public onlyCEO {
935         require(battleContractAddressCanBeUpdated == true);
936 
937         battleContractAddress = _address;
938     }
939 
940     function foreverBlockBattleAddressUpdate() public onlyCEO {
941         battleContractAddressCanBeUpdated = false;
942     }
943     
944     modifier onlyBattleContract() {
945         require(msg.sender == battleContractAddress);
946         _;
947     }
948     
949     function createPrizeFighter(
950         uint16 _generation,
951         uint256 _genes,
952         uint8 _dexterity,
953         uint8 _strength,
954         uint8 _vitality,
955         uint8 _luck,
956         address _owner
957     ) public onlyBattleContract {
958         require(_generation > 0);
959         
960         _createFighter(_generation, _genes, _dexterity, _strength, _vitality, _luck, _owner);
961     }
962     
963     // Update fighter functions
964     
965     // The logic for creating so many different functions is that it will be
966     // easier to optimise for gas costs having all these available to us.
967     // The contract deployment will be more expensive, but future costs can be
968     // cheaper.
969     function updateFighter(
970         uint256 _fighterId,
971         uint8 _dexterity,
972         uint8 _strength,
973         uint8 _vitality,
974         uint8 _luck,
975         uint32 _experience,
976         uint64 _prizeCooldownEndTime,
977         uint16 _prizeCooldownIndex,
978         uint64 _battleCooldownEndTime,
979         uint16 _battlesFought,
980         uint16 _battlesWon
981     )
982         public onlyBattleContract
983     {
984         Fighter storage fighter = fighters[_fighterId];
985         
986         fighter.dexterity = _dexterity;
987         fighter.strength = _strength;
988         fighter.vitality = _vitality;
989         fighter.luck = _luck;
990         fighter.experience = _experience;
991         
992         fighter.prizeCooldownEndTime = _prizeCooldownEndTime;
993         fighter.prizeCooldownIndex = _prizeCooldownIndex;
994         fighter.battleCooldownEndTime = _battleCooldownEndTime;
995         fighter.battlesFought = _battlesFought;
996         fighter.battlesWon = _battlesWon;
997         
998         FighterUpdated(_fighterId);
999     }
1000     
1001     function updateFighterStats(
1002         uint256 _fighterId,
1003         uint8 _dexterity,
1004         uint8 _strength,
1005         uint8 _vitality,
1006         uint8 _luck,
1007         uint32 _experience
1008     )
1009         public onlyBattleContract
1010     {
1011         Fighter storage fighter = fighters[_fighterId];
1012         
1013         fighter.dexterity = _dexterity;
1014         fighter.strength = _strength;
1015         fighter.vitality = _vitality;
1016         fighter.luck = _luck;
1017         fighter.experience = _experience;
1018         
1019         FighterUpdated(_fighterId);
1020     }
1021     
1022     function updateFighterBattleStats(
1023         uint256 _fighterId,
1024         uint64 _prizeCooldownEndTime,
1025         uint16 _prizeCooldownIndex,
1026         uint64 _battleCooldownEndTime,
1027         uint16 _battlesFought,
1028         uint16 _battlesWon
1029     )
1030         public onlyBattleContract
1031     {
1032         Fighter storage fighter = fighters[_fighterId];
1033         
1034         fighter.prizeCooldownEndTime = _prizeCooldownEndTime;
1035         fighter.prizeCooldownIndex = _prizeCooldownIndex;
1036         fighter.battleCooldownEndTime = _battleCooldownEndTime;
1037         fighter.battlesFought = _battlesFought;
1038         fighter.battlesWon = _battlesWon;
1039         
1040         FighterUpdated(_fighterId);
1041     }
1042     
1043     function updateDexterity(uint256 _fighterId, uint8 _dexterity) public onlyBattleContract {
1044         fighters[_fighterId].dexterity = _dexterity;
1045         FighterUpdated(_fighterId);
1046     }
1047     
1048     function updateStrength(uint256 _fighterId, uint8 _strength) public onlyBattleContract {
1049         fighters[_fighterId].strength = _strength;
1050         FighterUpdated(_fighterId);
1051     }
1052     
1053     function updateVitality(uint256 _fighterId, uint8 _vitality) public onlyBattleContract {
1054         fighters[_fighterId].vitality = _vitality;
1055         FighterUpdated(_fighterId);
1056     }
1057     
1058     function updateLuck(uint256 _fighterId, uint8 _luck) public onlyBattleContract {
1059         fighters[_fighterId].luck = _luck;
1060         FighterUpdated(_fighterId);
1061     }
1062     
1063     function updateExperience(uint256 _fighterId, uint32 _experience) public onlyBattleContract {
1064         fighters[_fighterId].experience = _experience;
1065         FighterUpdated(_fighterId);
1066     }
1067 }
1068 
1069 /// @title Handles creating auctions for sale of fighters.
1070 ///  This wrapper of ReverseAuction exists only so that users can create
1071 ///  auctions with only one transaction.
1072 contract FighterAuction is FighterBattle {
1073     SaleClockAuction public saleAuction;
1074 
1075     function setSaleAuctionAddress(address _address) public onlyCEO {
1076         SaleClockAuction candidateContract = SaleClockAuction(_address);
1077 
1078         require(candidateContract.isSaleClockAuction());
1079 
1080         saleAuction = candidateContract;
1081     }
1082 
1083     function createSaleAuction(
1084         uint256 _fighterId,
1085         uint256 _startingPrice,
1086         uint256 _endingPrice,
1087         uint256 _duration
1088     )
1089         public
1090         whenNotPaused
1091     {
1092         // Auction contract checks input sizes
1093         // If fighter is already on any auction, this will throw
1094         // because it will be owned by the auction contract.
1095         require(_owns(msg.sender, _fighterId));
1096         _approve(_fighterId, saleAuction);
1097         // Sale auction throws if inputs are invalid and clears
1098         // transfer approval after escrowing the fighter.
1099         saleAuction.createAuction(
1100             _fighterId,
1101             _startingPrice,
1102             _endingPrice,
1103             _duration,
1104             msg.sender
1105         );
1106     }
1107 
1108     /// @dev Transfers the balance of the sale auction contract
1109     /// to the FighterCore contract. We use two-step withdrawal to
1110     /// prevent two transfer calls in the auction bid function.
1111     function withdrawAuctionBalances() external onlyCOO {
1112         saleAuction.withdrawBalance();
1113     }
1114 }
1115 
1116 
1117 /// @title all functions related to creating fighters
1118 contract FighterMinting is FighterAuction {
1119 
1120     // Limits the number of fighters the contract owner can ever create.
1121     uint256 public promoCreationLimit = 5000;
1122     uint256 public gen0CreationLimit = 25000;
1123 
1124     // Constants for gen0 auctions.
1125     uint256 public gen0StartingPrice = 500 finney;
1126     uint256 public gen0EndingPrice = 10 finney;
1127     uint256 public gen0AuctionDuration = 1 days;
1128 
1129     // Counts the number of fighters the contract owner has created.
1130     uint256 public promoCreatedCount;
1131     uint256 public gen0CreatedCount;
1132 
1133     /// @dev we can create promo fighters, up to a limit
1134     function createPromoFighter(
1135         uint256 _genes,
1136         uint8 _dexterity,
1137         uint8 _strength,
1138         uint8 _vitality,
1139         uint8 _luck,
1140         address _owner
1141     ) public onlyCOO {
1142         if (_owner == address(0)) {
1143              _owner = cooAddress;
1144         }
1145         require(promoCreatedCount < promoCreationLimit);
1146         require(gen0CreatedCount < gen0CreationLimit);
1147 
1148         promoCreatedCount++;
1149         gen0CreatedCount++;
1150         
1151         _createFighter(0, _genes, _dexterity, _strength, _vitality, _luck, _owner);
1152     }
1153 
1154     /// @dev Creates a new gen0 fighter with the given genes and
1155     ///  creates an auction for it.
1156     function createGen0Auction(
1157         uint256 _genes,
1158         uint8 _dexterity,
1159         uint8 _strength,
1160         uint8 _vitality,
1161         uint8 _luck
1162     ) public onlyCOO {
1163         require(gen0CreatedCount < gen0CreationLimit);
1164 
1165         uint256 fighterId = _createFighter(0, _genes, _dexterity, _strength, _vitality, _luck, address(this));
1166         
1167         _approve(fighterId, saleAuction);
1168 
1169         saleAuction.createAuction(
1170             fighterId,
1171             _computeNextGen0Price(),
1172             gen0EndingPrice,
1173             gen0AuctionDuration,
1174             address(this)
1175         );
1176 
1177         gen0CreatedCount++;
1178     }
1179 
1180     /// @dev Computes the next gen0 auction starting price, given
1181     ///  the average of the past 4 prices + 50%.
1182     function _computeNextGen0Price() internal view returns (uint256) {
1183         uint256 avePrice = saleAuction.averageGen0SalePrice();
1184 
1185         // sanity check to ensure we don't overflow arithmetic (this big number is 2^128-1).
1186         require(avePrice < 340282366920938463463374607431768211455);
1187 
1188         uint256 nextPrice = avePrice + (avePrice / 2);
1189 
1190         // We never auction for less than starting price
1191         if (nextPrice < gen0StartingPrice) {
1192             nextPrice = gen0StartingPrice;
1193         }
1194 
1195         return nextPrice;
1196     }
1197 }
1198 
1199 
1200 /// @title CryptoFighters: Collectible, battlable fighters on the Ethereum blockchain.
1201 /// @dev The main CryptoFighters contract
1202 contract FighterCore is FighterMinting {
1203 
1204     // This is the main CryptoFighters contract. We have several seperately-instantiated sibling contracts
1205     // that handle auctions, battles and the creation of new fighters. By keeping
1206     // them in their own contracts, we can upgrade them without disrupting the main contract that tracks
1207     // fighter ownership.
1208     //
1209     //      - FighterBase: This is where we define the most fundamental code shared throughout the core
1210     //             functionality. This includes our main data storage, constants and data types, plus
1211     //             internal functions for managing these items.
1212     //
1213     //      - FighterAccessControl: This contract manages the various addresses and constraints for operations
1214     //             that can be executed only by specific roles. Namely CEO, CFO and COO.
1215     //
1216     //      - FighterOwnership: This provides the methods required for basic non-fungible token
1217     //             transactions, following the draft ERC-721 spec (https://github.com/ethereum/EIPs/issues/721).
1218     //
1219     //      - FighterBattle: This file contains the methods necessary to allow a separate contract to handle battles
1220     //             allowing it to reward new prize fighters as well as update fighter stats.
1221     //
1222     //      - FighterAuction: Here we have the public methods for auctioning or bidding on fighters.
1223     //             The actual auction functionality is handled in a sibling sales contract,
1224     //             while auction creation and bidding is mostly mediated through this facet of the core contract.
1225     //
1226     //      - FighterMinting: This final facet contains the functionality we use for creating new gen0 fighters.
1227     //             We can make up to 5000 "promo" fighters that can be given away, and all others can only be created and then immediately put up
1228     //             for auction via an algorithmically determined starting price. Regardless of how they
1229     //             are created, there is a hard limit of 25,000 gen0 fighters.
1230 
1231     // Set in case the core contract is broken and an upgrade is required
1232     address public newContractAddress;
1233 
1234     function FighterCore() public {
1235         paused = true;
1236 
1237         ceoAddress = msg.sender;
1238         cooAddress = msg.sender;
1239         cfoAddress = msg.sender;
1240 
1241         // start with the mythical fighter 0
1242         _createFighter(0, uint256(-1), uint8(-1), uint8(-1), uint8(-1), uint8(-1),  address(0));
1243     }
1244 
1245     /// @dev Used to mark the smart contract as upgraded, in case there is a serious
1246     ///  breaking bug. This method does nothing but keep track of the new contract and
1247     ///  emit a message indicating that the new address is set. It's up to clients of this
1248     ///  contract to update to the new contract address in that case. (This contract will
1249     ///  be paused indefinitely if such an upgrade takes place.)
1250     /// @param _v2Address new address
1251     function setNewAddress(address _v2Address) public onlyCEO whenPaused {
1252         newContractAddress = _v2Address;
1253         ContractUpgrade(_v2Address);
1254     }
1255 
1256     /// @notice No tipping!
1257     /// @dev Reject all Ether from being sent here, unless it's from one of the
1258     ///  two auction contracts. (Hopefully, we can prevent user accidents.)
1259     function() external payable {
1260         require(msg.sender == address(saleAuction));
1261     }
1262 
1263     /// @param _id The ID of the fighter of interest.
1264     function getFighter(uint256 _id)
1265         public
1266         view
1267         returns (
1268         uint256 prizeCooldownEndTime,
1269         uint256 battleCooldownEndTime,
1270         uint256 prizeCooldownIndex,
1271         uint256 battlesFought,
1272         uint256 battlesWon,
1273         uint256 generation,
1274         uint256 genes,
1275         uint256 dexterity,
1276         uint256 strength,
1277         uint256 vitality,
1278         uint256 luck,
1279         uint256 experience
1280     ) {
1281         Fighter storage fighter = fighters[_id];
1282 
1283         prizeCooldownEndTime = fighter.prizeCooldownEndTime;
1284         battleCooldownEndTime = fighter.battleCooldownEndTime;
1285         prizeCooldownIndex = fighter.prizeCooldownIndex;
1286         battlesFought = fighter.battlesFought;
1287         battlesWon = fighter.battlesWon;
1288         generation = fighter.generation;
1289         genes = fighter.genes;
1290         dexterity = fighter.dexterity;
1291         strength = fighter.strength;
1292         vitality = fighter.vitality;
1293         luck = fighter.luck;
1294         experience = fighter.experience;
1295     }
1296 
1297     /// @dev Override unpause so it requires all external contract addresses
1298     ///  to be set before contract can be unpaused. Also, we can't have
1299     ///  newContractAddress set either, because then the contract was upgraded.
1300     function unpause() public onlyCEO whenPaused {
1301         require(saleAuction != address(0));
1302         require(newContractAddress == address(0));
1303 
1304         super.unpause();
1305     }
1306 }