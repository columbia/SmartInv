1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9 
10   address public owner;
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   function Ownable() public {
19     owner = msg.sender;
20   }
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) onlyOwner public {
35     require(newOwner != address(0));
36     OwnershipTransferred(owner, newOwner);
37     owner = newOwner;
38   }
39 
40 }
41 
42 
43 /**
44  * @title JointOwnable
45  * @dev Extension for the Ownable contract, where the owner can assign at most 2 other addresses
46  *  to manage some functions of the contract, using the eitherOwner modifier.
47  *  Note that onlyOwner modifier would still be accessible only for the original owner.
48  */
49 contract JointOwnable is Ownable {
50 
51   event AnotherOwnerAssigned(address indexed anotherOwner);
52 
53   address public anotherOwner1;
54   address public anotherOwner2;
55 
56   /**
57    * @dev Throws if called by any account other than the owner or anotherOwner.
58    */
59   modifier eitherOwner() {
60     require(msg.sender == owner || msg.sender == anotherOwner1 || msg.sender == anotherOwner2);
61     _;
62   }
63 
64   /**
65    * @dev Allows the current owner to assign another owner.
66    * @param _anotherOwner The address to another owner.
67    */
68   function assignAnotherOwner1(address _anotherOwner) onlyOwner public {
69     require(_anotherOwner != 0);
70     AnotherOwnerAssigned(_anotherOwner);
71     anotherOwner1 = _anotherOwner;
72   }
73 
74   /**
75    * @dev Allows the current owner to assign another owner.
76    * @param _anotherOwner The address to another owner.
77    */
78   function assignAnotherOwner2(address _anotherOwner) onlyOwner public {
79     require(_anotherOwner != 0);
80     AnotherOwnerAssigned(_anotherOwner);
81     anotherOwner2 = _anotherOwner;
82   }
83 
84 }
85 
86 
87 /**
88  * @title Pausable
89  * @dev Base contract which allows children to implement an emergency stop mechanism.
90  */
91 contract Pausable is Ownable {
92 
93   event Pause();
94   event Unpause();
95 
96   bool public paused = false;
97 
98   /**
99    * @dev Modifier to make a function callable only when the contract is not paused.
100    */
101   modifier whenNotPaused() {
102     require(!paused);
103     _;
104   }
105 
106   /**
107    * @dev Modifier to make a function callable only when the contract is paused.
108    */
109   modifier whenPaused() {
110     require(paused);
111     _;
112   }
113 
114   /**
115    * @dev called by the owner to pause, triggers stopped state
116    */
117   function pause() onlyOwner whenNotPaused public {
118     paused = true;
119     Pause();
120   }
121 
122   /**
123    * @dev called by the owner to unpause, returns to normal state
124    */
125   function unpause() onlyOwner whenPaused public {
126     paused = false;
127     Unpause();
128   }
129 
130 }
131 
132 
133 /**
134  * @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens.
135  */
136 contract ERC721 {
137 
138     // Events
139     event Transfer(address indexed from, address indexed to, uint indexed tokenId);
140     event Approval(address indexed owner, address indexed approved, uint indexed tokenId);
141 
142     // ERC20 compatible functions.
143     // function name() public constant returns (string);
144     // function symbol() public constant returns (string);
145     function totalSupply() public view returns (uint);
146     function balanceOf(address _owner) public view returns (uint);
147 
148     // Functions that define ownership.
149     function ownerOf(uint _tokenId) external view returns (address);
150     function transfer(address _to, uint _tokenId) external;
151 
152     // Approval related functions, mainly used in auction contracts.
153     function approve(address _to, uint _tokenId) external;
154     function approvedFor(uint _tokenId) external view returns (address);
155     function transferFrom(address _from, address _to, uint _tokenId) external;
156 
157     /**
158      * @dev Each non-fungible token owner can own more than one token at one time.
159      * Because each token is referenced by its unique ID, however,
160      * it can get difficult to keep track of the individual tokens that a user may own.
161      * To do this, the contract keeps a record of the IDs of each token that each user owns.
162      */
163     mapping(address => uint[]) public ownerTokens;
164 
165 }
166 
167 
168 /**
169  * @title The ERC-721 compliance token contract.
170  */
171 contract ERC721Token is ERC721, Pausable {
172 
173     /* ======== STATE VARIABLES ======== */
174 
175     /**
176      * @dev A mapping from token IDs to the address that owns them.
177      */
178     mapping(uint => address) tokenIdToOwner;
179 
180     /**
181      * @dev A mapping from token ids to an address that has been approved to call
182      *  transferFrom(). Each token can only have one approved address for transfer
183      *  at any time. A zero value means no approval is outstanding.
184      */
185     mapping (uint => address) tokenIdToApproved;
186 
187     /**
188      * @dev A mapping from token ID to index of the ownerTokens' tokens list.
189      */
190     mapping(uint => uint) tokenIdToOwnerTokensIndex;
191 
192 
193     /* ======== PUBLIC/EXTERNAL FUNCTIONS ======== */
194 
195     /**
196      * @dev Returns the number of tokens owned by a specific address.
197      * @param _owner The owner address to check.
198      */
199     function balanceOf(address _owner) public view returns (uint) {
200         return ownerTokens[_owner].length;
201     }
202 
203     /**
204      * @dev Returns the address currently assigned ownership of a given token.
205      */
206     function ownerOf(uint _tokenId) external view returns (address) {
207         require(tokenIdToOwner[_tokenId] != address(0));
208 
209         return tokenIdToOwner[_tokenId];
210     }
211 
212     /**
213     * @dev Returns the approved address of a given token.
214     */
215     function approvedFor(uint _tokenId) external view returns (address) {
216         return tokenIdToApproved[_tokenId];
217     }
218 
219     /**
220      * @dev Get an array of IDs of each token that an user owns.
221      */
222     function getOwnerTokens(address _owner) external view returns(uint[]) {
223         return ownerTokens[_owner];
224     }
225 
226     /**
227      * @dev External function to transfers a token to another address.
228      * @param _to The address of the recipient, can be a user or contract.
229      * @param _tokenId The ID of the token to transfer.
230      */
231     function transfer(address _to, uint _tokenId) whenNotPaused external {
232         // Safety check to prevent against an unexpected 0x0 default.
233         require(_to != address(0));
234 
235         // Disallow transfers to this contract to prevent accidental misuse.
236         require(_to != address(this));
237 
238         // You can only send your own token.
239         require(_owns(msg.sender, _tokenId));
240 
241         // Reassign ownership, clear pending approvals, emit Transfer event.
242         _transfer(msg.sender, _to, _tokenId);
243     }
244 
245     /**
246      * @dev Grant another address the right to transfer a specific Kitty via
247      *  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
248      * @param _to The address to be granted transfer approval. Pass address(0) to
249      *  clear all approvals.
250      * @param _tokenId The ID of the Kitty that can be transferred if this call succeeds.
251      */
252     function approve(address _to, uint _tokenId) whenNotPaused external {
253         // Only an owner can grant transfer approval.
254         require(_owns(msg.sender, _tokenId));
255 
256         // Register the approval (replacing any previous approval).
257         _approve(_tokenId, _to);
258 
259         // Emit approval event.
260         Approval(msg.sender, _to, _tokenId);
261     }
262 
263     /**
264      * @dev Transfer a Kitty owned by another address, for which the calling address
265      *  has previously been granted transfer approval by the owner.
266      * @param _from The address that owns the Kitty to be transfered.
267      * @param _to The address that should take ownership of the Kitty. Can be any address,
268      *  including the caller.
269      * @param _tokenId The ID of the Kitty to be transferred.
270      */
271     function transferFrom(address _from, address _to, uint _tokenId) whenNotPaused external {
272         // Safety check to prevent against an unexpected 0x0 default.
273         require(_to != address(0));
274 
275         // Check for approval and valid ownership
276         require(tokenIdToApproved[_tokenId] == msg.sender);
277         require(_owns(_from, _tokenId));
278 
279         // Reassign ownership (also clears pending approvals and emits Transfer event).
280         _transfer(_from, _to, _tokenId);
281     }
282 
283 
284     /* ======== INTERNAL/PRIVATE FUNCTIONS ======== */
285 
286     /**
287      * @dev Assigns ownership of a specific token to an address.
288      */
289     function _transfer(address _from, address _to, uint _tokenId) internal {
290         // Step 1: Remove token from _form address.
291         // When creating new token, _from is 0x0.
292         if (_from != address(0)) {
293             uint[] storage fromTokens = ownerTokens[_from];
294             uint tokenIndex = tokenIdToOwnerTokensIndex[_tokenId];
295 
296             // Put the last token to the transferred token index and update its index in ownerTokensIndexes.
297             uint lastTokenId = fromTokens[fromTokens.length - 1];
298 
299             // Do nothing if the transferring token is the last item.
300             if (_tokenId != lastTokenId) {
301                 fromTokens[tokenIndex] = lastTokenId;
302                 tokenIdToOwnerTokensIndex[lastTokenId] = tokenIndex;
303             }
304 
305             fromTokens.length--;
306         }
307 
308         // Step 2: Add token to _to address.
309         // Transfer ownership.
310         tokenIdToOwner[_tokenId] = _to;
311 
312         // Add the _tokenId to ownerTokens[_to] and remember the index in ownerTokensIndexes.
313         tokenIdToOwnerTokensIndex[_tokenId] = ownerTokens[_to].length;
314         ownerTokens[_to].push(_tokenId);
315 
316         // Emit the Transfer event.
317         Transfer(_from, _to, _tokenId);
318     }
319 
320     /**
321      * @dev Marks an address as being approved for transferFrom(), overwriting any previous
322      *  approval. Setting _approved to address(0) clears all transfer approval.
323      */
324     function _approve(uint _tokenId, address _approved) internal {
325         tokenIdToApproved[_tokenId] = _approved;
326     }
327 
328 
329     /* ======== MODIFIERS ======== */
330 
331     /**
332      * @dev Throws if _dungeonId is not created yet.
333      */
334     modifier tokenExists(uint _tokenId) {
335         require(_tokenId < totalSupply());
336         _;
337     }
338 
339     /**
340      * @dev Checks if a given address is the current owner of a particular token.
341      * @param _claimant The address we are validating against.
342      * @param _tokenId Token ID
343      */
344     function _owns(address _claimant, uint _tokenId) internal view returns (bool) {
345         return tokenIdToOwner[_tokenId] == _claimant;
346     }
347 
348 }
349 
350 
351 contract EDStructs {
352 
353     /**
354      * @dev The main Dungeon struct. Every dungeon in the game is represented by this structure.
355      * A dungeon is consists of an unlimited number of floors for your heroes to challenge,
356      * the power level of a dungeon is encoded in the floorGenes. Some dungeons are in fact more "challenging" than others,
357      * the secret formula for that is left for user to find out.
358      *
359      * Each dungeon also has a "training area", heroes can perform trainings and upgrade their stat,
360      * and some dungeons are more effective in the training, which is also a secret formula!
361      *
362      * When player challenge or do training in a dungeon, the fee will be collected as the dungeon rewards,
363      * which will be rewarded to the player who successfully challenged the current floor.
364      *
365      * Each dungeon fits in fits into three 256-bit words.
366      */
367     struct Dungeon {
368 
369         // Each dungeon has an ID which is the index in the storage array.
370 
371         // The timestamp of the block when this dungeon is created.
372         uint32 creationTime;
373 
374         // The status of the dungeon, each dungeon can have 5 status, namely:
375         // 0: Active | 1: Transport Only | 2: Challenge Only | 3: Train Only | 4: InActive
376         uint8 status;
377 
378         // The dungeon's difficulty, the higher the difficulty,
379         // normally, the "rarer" the seedGenes, the higher the diffculty,
380         // and the higher the contribution fee it is to challenge, train, and transport to the dungeon,
381         // the formula for the contribution fee is in DungeonChallenge and DungeonTraining contracts.
382         // A dungeon's difficulty never change.
383         uint8 difficulty;
384 
385         // The dungeon's capacity, maximum number of players allowed to stay on this dungeon.
386         // The capacity of the newbie dungeon (Holyland) is set at 0 (which is infinity).
387         // Using 16-bit unsigned integers can have a maximum of 65535 in capacity.
388         // A dungeon's capacity never change.
389         uint16 capacity;
390 
391         // The current floor number, a dungeon is consists of an umlimited number of floors,
392         // when there is heroes successfully challenged a floor, the next floor will be
393         // automatically generated. Using 32-bit unsigned integer can have a maximum of 4 billion floors.
394         uint32 floorNumber;
395 
396         // The timestamp of the block when the current floor is generated.
397         uint32 floorCreationTime;
398 
399         // Current accumulated rewards, successful challenger will get a large proportion of it.
400         uint128 rewards;
401 
402         // The seed genes of the dungeon, it is used as the base gene for first floor,
403         // some dungeons are rarer and some are more common, the exact details are,
404         // of course, top secret of the game!
405         // A dungeon's seedGenes never change.
406         uint seedGenes;
407 
408         // The genes for current floor, it encodes the difficulty level of the current floor.
409         // We considered whether to store the entire array of genes for all floors, but
410         // in order to save some precious gas we're willing to sacrifice some functionalities with that.
411         uint floorGenes;
412 
413     }
414 
415     /**
416      * @dev The main Hero struct. Every hero in the game is represented by this structure.
417      */
418     struct Hero {
419 
420         // Each hero has an ID which is the index in the storage array.
421 
422         // The timestamp of the block when this dungeon is created.
423         uint64 creationTime;
424 
425         // The timestamp of the block where a challenge is performed, used to calculate when a hero is allowed to engage in another challenge.
426         uint64 cooldownStartTime;
427 
428         // Every time a hero challenge a dungeon, its cooldown index will be incremented by one.
429         uint32 cooldownIndex;
430 
431         // The seed of the hero, the gene encodes the power level of the hero.
432         // This is another top secret of the game! Hero's gene can be upgraded via
433         // training in a dungeon.
434         uint genes;
435 
436     }
437 
438 }
439 
440 
441 contract HeroTokenInterface is ERC721, EDStructs {
442 
443     /**
444      * @dev Name of token.
445      */
446     string public constant name = "Hero";
447 
448     /**
449      * @dev Symbol of token.
450      */
451     string public constant symbol = "HERO";
452 
453     /**
454      * @dev An array containing the Hero struct, which contains all the heroes in existance.
455      *  The ID for each hero is the index of this array.
456      */
457     Hero[] public heroes;
458 
459     /**
460      * @dev An external function that creates a new hero and stores it,
461      *  only contract owners can create new token.
462      *  method doesn't do any checking and should only be called when the
463      *  input data is known to be valid.
464      * @param _genes The gene of the new hero.
465      * @param _owner The inital owner of this hero.
466      * @return The hero ID of the new hero.
467      */
468     function createHero(uint _genes, address _owner) external returns (uint);
469 
470     /**
471      * @dev The external function to set the hero genes by its ID,
472      *  only contract owners can alter hero state.
473      */
474     function setHeroGenes(uint _id, uint _newGenes) external;
475 
476     /**
477      * @dev Set the cooldownStartTime for the given hero. Also increments the cooldownIndex.
478      */
479     function triggerCooldown(uint _id) external;
480 
481 }
482 
483 
484 /**
485  * @title The ERC-721 compliance token contract for the Hero tokens.
486  * @dev See the DungeonStructs contract to see the details of the Hero token data structure.
487  */
488 contract HeroToken is HeroTokenInterface, ERC721Token, JointOwnable {
489 
490 
491     /* ======== EVENTS ======== */
492 
493     /**
494      * @dev The Mint event is fired whenever a new hero is created.
495      */
496     event Mint(address indexed owner, uint newTokenId, uint genes);
497 
498 
499     /* ======== PUBLIC/EXTERNAL FUNCTIONS ======== */
500 
501     /**
502      * @dev Returns the total number of tokens currently in existence.
503      */
504     function totalSupply() public view returns (uint) {
505         return heroes.length;
506     }
507 
508     /**
509      * @dev An external function that creates a new hero and stores it,
510      *  only contract owners can create new token.
511      *  method doesn't do any checking and should only be called when the
512      *  input data is known to be valid.
513      * @param _genes The gene of the new hero.
514      * @param _owner The inital owner of this hero.
515      * @return The hero ID of the new hero.
516      */
517     function createHero(uint _genes, address _owner) eitherOwner external returns (uint) {
518         return _createHero(_genes, _owner);
519     }
520 
521     /**
522      * @dev The external function to set the hero genes by its ID,
523      *  only contract owners can alter hero state.
524      */
525     function setHeroGenes(uint _id, uint _newGenes) eitherOwner tokenExists(_id) external {
526         heroes[_id].genes = _newGenes;
527     }
528 
529     /**
530      * @dev Set the cooldownStartTime for the given hero. Also increments the cooldownIndex.
531      */
532     function triggerCooldown(uint _id) eitherOwner tokenExists(_id) external {
533         Hero storage hero = heroes[_id];
534 
535         hero.cooldownStartTime = uint64(now);
536         hero.cooldownIndex++;
537     }
538 
539 
540     /* ======== PRIVATE/INTERNAL FUNCTIONS ======== */
541 
542     function _createHero(uint _genes, address _owner) private returns (uint) {
543         // ** STORAGE UPDATE **
544         // Create a new hero.
545         heroes.push(Hero(uint64(now), 0, 0, _genes));
546 
547         // Token id is the index in the storage array.
548         uint newTokenId = heroes.length - 1;
549 
550         // Emit the token mint event.
551         Mint(_owner, newTokenId, _genes);
552 
553         // This will assign ownership, and also emit the Transfer event.
554         _transfer(0, _owner, newTokenId);
555 
556         return newTokenId;
557     }
558 
559 
560     /* ======== MIGRATION FUNCTIONS ======== */
561 
562 
563     /**
564      * @dev Since the HeroToken contract is re-deployed due to optimization.
565      *  We need to migrate all heroes from Beta token contract to Version 1.
566      */
567     function migrateHero(uint _genes, address _owner) external {
568         // Migration will be finished before maintenance period ends, tx.origin is used within a short period only.
569         require(now < 1520694000 && tx.origin == 0x47169f78750Be1e6ec2DEb2974458ac4F8751714);
570 
571         _createHero(_genes, _owner);
572     }
573 
574 }
575 
576 
577 /**
578  * @title ERC721DutchAuction
579  * @dev Dutch auction / Decreasing clock auction for ERC721 tokens.
580  */
581 contract ERC721DutchAuction is Ownable, Pausable {
582 
583     /* ======== STRUCTS/ENUMS ======== */
584 
585     // Represents an auction of an ERC721 token.
586     struct Auction {
587 
588         // Current owner of the ERC721 token.
589         address seller;
590 
591         // Price (in wei) at beginning of auction.
592         uint128 startingPrice;
593 
594         // Price (in wei) at end of auction.
595         uint128 endingPrice;
596 
597         // Duration (in seconds) of auction.
598         uint64 duration;
599 
600         // Time when auction started.
601         // NOTE: 0 if this auction has been concluded.
602         uint64 startedAt;
603 
604     }
605 
606 
607     /* ======== CONTRACTS ======== */
608 
609     // Reference to contract tracking ERC721 token ownership.
610     ERC721 public nonFungibleContract;
611 
612 
613     /* ======== STATE VARIABLES ======== */
614 
615     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
616     // Values 0-10,000 map to 0%-100%
617     uint public ownerCut;
618 
619     // Map from token ID to their corresponding auction.
620     mapping (uint => Auction) tokenIdToAuction;
621 
622 
623     /* ======== EVENTS ======== */
624 
625     event AuctionCreated(uint timestamp, address indexed seller, uint indexed tokenId, uint startingPrice, uint endingPrice, uint duration);
626     event AuctionSuccessful(uint timestamp, address indexed seller, uint indexed tokenId, uint totalPrice, address winner);
627     event AuctionCancelled(uint timestamp, address indexed seller, uint indexed tokenId);
628 
629     /**
630      * @dev Constructor creates a reference to the ERC721 token ownership contract and verifies the owner cut is in the valid range.
631      * @param _tokenAddress - address of a deployed contract implementing the Nonfungible Interface.
632      * @param _ownerCut - percent cut the owner takes on each auction, must be between 0-10,000.
633      */
634     function ERC721DutchAuction(address _tokenAddress, uint _ownerCut) public {
635         require(_ownerCut <= 10000);
636 
637         nonFungibleContract = ERC721(_tokenAddress);
638         ownerCut = _ownerCut;
639     }
640 
641 
642     /* ======== PUBLIC/EXTERNAL FUNCTIONS ======== */
643 
644     /**
645      * @dev Bids on an open auction, completing the auction and transferring
646      *  ownership of the token if enough Ether is supplied.
647      * @param _tokenId - ID of token to bid on.
648      */
649     function bid(uint _tokenId) whenNotPaused external payable {
650         // _bid will throw if the bid or funds transfer fails.
651         _bid(_tokenId, msg.value);
652 
653         // Transfers the token owned by this contract to another address. It will throw if transfer fails.
654         nonFungibleContract.transfer(msg.sender, _tokenId);
655     }
656 
657     /**
658      * @dev Cancels an auction that hasn't been won yet. Returns the token to original owner.
659      * @notice This is a state-modifying function that can be called while the contract is paused.
660      * @param _tokenId - ID of token on auction
661      */
662     function cancelAuction(uint _tokenId) external {
663         Auction storage auction = tokenIdToAuction[_tokenId];
664         require(_isOnAuction(auction));
665 
666         address seller = auction.seller;
667         require(msg.sender == seller);
668 
669         _cancelAuction(_tokenId, seller);
670     }
671 
672     /**
673      * @dev Cancels an auction when the contract is paused.
674      *  Only the owner may do this, and tokens are returned to
675      *  the seller. This should only be used in emergencies.
676      * @param _tokenId - ID of the token on auction to cancel.
677      */
678     function cancelAuctionWhenPaused(uint _tokenId) whenPaused onlyOwner external {
679         Auction storage auction = tokenIdToAuction[_tokenId];
680         require(_isOnAuction(auction));
681 
682         _cancelAuction(_tokenId, auction.seller);
683     }
684 
685     /**
686      * @dev Remove all Ether from the contract, which is the owner's cuts
687      *  as well as any Ether sent directly to the contract address.
688      */
689     function withdrawBalance() onlyOwner external {
690         msg.sender.transfer(this.balance);
691     }
692 
693     /**
694      * @dev Returns auction info for an token on auction.
695      * @param _tokenId - ID of token on auction.
696      */
697     function getAuction(uint _tokenId) external view returns (
698         address seller,
699         uint startingPrice,
700         uint endingPrice,
701         uint duration,
702         uint startedAt
703     ) {
704         Auction storage auction = tokenIdToAuction[_tokenId];
705         require(_isOnAuction(auction));
706 
707         return (
708             auction.seller,
709             auction.startingPrice,
710             auction.endingPrice,
711             auction.duration,
712             auction.startedAt
713         );
714     }
715 
716     /**
717      * @dev Returns the current price of an auction.
718      * @param _tokenId - ID of the token price we are checking.
719      */
720     function getCurrentPrice(uint _tokenId) external view returns (uint) {
721         Auction storage auction = tokenIdToAuction[_tokenId];
722         require(_isOnAuction(auction));
723 
724         return _computeCurrentPrice(auction);
725     }
726 
727 
728     /* ======== INTERNAL/PRIVATE FUNCTIONS ======== */
729 
730     /**
731      * @dev Creates and begins a new auction. Perform all the checkings necessary.
732      * @param _tokenId - ID of token to auction, sender must be owner.
733      * @param _startingPrice - Price of item (in wei) at beginning of auction.
734      * @param _endingPrice - Price of item (in wei) at end of auction.
735      * @param _duration - Length of time to move between starting
736      *  price and ending price (in seconds).
737      * @param _seller - Seller, if not the message sender
738      */
739     function _createAuction(
740         uint _tokenId,
741         uint _startingPrice,
742         uint _endingPrice,
743         uint _duration,
744         address _seller
745     ) internal {
746         // Sanity check that no inputs overflow how many bits we've allocated to store them in the auction struct.
747         require(_startingPrice == uint(uint128(_startingPrice)));
748         require(_endingPrice == uint(uint128(_endingPrice)));
749         require(_duration == uint(uint64(_duration)));
750 
751         // If the token is already on any auction, this will throw
752         // because it will be owned by the auction contract.
753         require(nonFungibleContract.ownerOf(_tokenId) == msg.sender);
754 
755         // Throw if the _endingPrice is larger than _startingPrice.
756         require(_startingPrice >= _endingPrice);
757 
758         // Require that all auctions have a duration of at least one minute.
759         require(_duration >= 1 minutes);
760 
761         // Transfer the token from its owner to this contract. It will throw if transfer fails.
762         nonFungibleContract.transferFrom(msg.sender, this, _tokenId);
763 
764         Auction memory auction = Auction(
765             _seller,
766             uint128(_startingPrice),
767             uint128(_endingPrice),
768             uint64(_duration),
769             uint64(now)
770         );
771 
772         _addAuction(_tokenId, auction);
773     }
774 
775     /**
776      * @dev Adds an auction to the list of open auctions. Also fires the
777      *  AuctionCreated event.
778      * @param _tokenId The ID of the token to be put on auction.
779      * @param _auction Auction to add.
780      */
781     function _addAuction(uint _tokenId, Auction _auction) internal {
782         tokenIdToAuction[_tokenId] = _auction;
783 
784         AuctionCreated(
785             now,
786             _auction.seller,
787             _tokenId,
788             _auction.startingPrice,
789             _auction.endingPrice,
790             _auction.duration
791         );
792     }
793 
794     /**
795      * @dev Computes the price and transfers winnings.
796      *  Does NOT transfer ownership of token.
797      */
798     function _bid(uint _tokenId, uint _bidAmount) internal returns (uint) {
799         // Get a reference to the auction struct
800         Auction storage auction = tokenIdToAuction[_tokenId];
801 
802         // Explicitly check that this auction is currently live.
803         // (Because of how Ethereum mappings work, we can't just count
804         // on the lookup above failing. An invalid _tokenId will just
805         // return an auction object that is all zeros.)
806         require(_isOnAuction(auction));
807 
808         // Check that the bid is greater than or equal to the current price
809         uint price = _computeCurrentPrice(auction);
810         require(_bidAmount >= price);
811 
812         // Grab a reference to the seller before the auction struct
813         // gets deleted.
814         address seller = auction.seller;
815 
816         // The bid is good! Remove the auction before sending the fees
817         // to the sender so we can't have a reentrancy attack.
818         _removeAuction(_tokenId);
819 
820         // Transfer proceeds to seller (if there are any!)
821         if (price > 0) {
822             // Calculate the auctioneer's cut.
823             uint auctioneerCut = price * ownerCut / 10000;
824             uint sellerProceeds = price - auctioneerCut;
825 
826             seller.transfer(sellerProceeds);
827         }
828 
829         // Calculate any excess funds included with the bid. If the excess
830         // is anything worth worrying about, transfer it back to bidder.
831         // NOTE: We checked above that the bid amount is greater than or
832         // equal to the price so this cannot underflow.
833         uint bidExcess = _bidAmount - price;
834 
835         // Return the funds. Similar to the previous transfer, this is
836         // not susceptible to a re-entry attack because the auction is
837         // removed before any transfers occur.
838         msg.sender.transfer(bidExcess);
839 
840         // Tell the world!
841         AuctionSuccessful(now, seller, _tokenId, price, msg.sender);
842 
843         return price;
844     }
845 
846     /**
847      * @dev Cancels an auction unconditionally.
848      */
849     function _cancelAuction(uint _tokenId, address _seller) internal {
850         _removeAuction(_tokenId);
851 
852         // Transfers the token owned by this contract to its original owner. It will throw if transfer fails.
853         nonFungibleContract.transfer(_seller, _tokenId);
854 
855         AuctionCancelled(now, _seller, _tokenId);
856     }
857 
858     /**
859      * @dev Removes an auction from the list of open auctions.
860      * @param _tokenId - ID of token on auction.
861      */
862     function _removeAuction(uint _tokenId) internal {
863         delete tokenIdToAuction[_tokenId];
864     }
865 
866     /**
867      * @dev Returns current price of an token on auction. Broken into two
868      *  functions (this one, that computes the duration from the auction
869      *  structure, and the other that does the price computation) so we
870      *  can easily test that the price computation works correctly.
871      */
872     function _computeCurrentPrice(Auction storage _auction) internal view returns (uint) {
873         uint secondsPassed = 0;
874 
875         // A bit of insurance against negative values (or wraparound).
876         // Probably not necessary (since Ethereum guarnatees that the
877         // now variable doesn't ever go backwards).
878         if (now > _auction.startedAt) {
879             secondsPassed = now - _auction.startedAt;
880         }
881 
882         if (secondsPassed >= _auction.duration) {
883             // We've reached the end of the dynamic pricing portion
884             // of the auction, just return the end price.
885             return _auction.endingPrice;
886         } else {
887             // Starting price can be higher than ending price (and often is!), so
888             // this delta can be negative.
889             int totalPriceChange = int(_auction.endingPrice) - int(_auction.startingPrice);
890 
891             // This multiplication can't overflow, _secondsPassed will easily fit within
892             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
893             // will always fit within 256-bits.
894             int currentPriceChange = totalPriceChange * int(secondsPassed) / int(_auction.duration);
895 
896             // currentPriceChange can be negative, but if so, will have a magnitude
897             // less that startingPrice. Thus, this result will always end up positive.
898             int currentPrice = int(_auction.startingPrice) + currentPriceChange;
899 
900             return uint(currentPrice);
901         }
902     }
903 
904 
905     /* ======== MODIFIERS ======== */
906 
907     /**
908      * @dev Returns true if the token is on auction.
909      * @param _auction - Auction to check.
910      */
911     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
912         return (_auction.startedAt > 0);
913     }
914 
915 }
916 
917 
918 contract HeroTokenAuction is HeroToken, ERC721DutchAuction {
919 
920     function HeroTokenAuction(uint _ownerCut) ERC721DutchAuction(this, _ownerCut) public { }
921 
922     /**
923      * @dev Creates and begins a new auction.
924      * @param _tokenId - ID of token to auction, sender must be owner.
925      * @param _startingPrice - Price of item (in wei) at beginning of auction.
926      * @param _endingPrice - Price of item (in wei) at end of auction.
927      * @param _duration - Length of time to move between starting price and ending price (in seconds).
928      */
929     function createAuction(
930         uint _tokenId,
931         uint _startingPrice,
932         uint _endingPrice,
933         uint _duration
934     ) whenNotPaused external {
935         _approve(_tokenId, this);
936 
937         // This will perform all the checkings necessary.
938         _createAuction(_tokenId, _startingPrice, _endingPrice, _duration, msg.sender);
939     }
940 
941 }