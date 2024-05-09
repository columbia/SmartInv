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
441 contract DungeonTokenInterface is ERC721, EDStructs {
442 
443     /**
444      * @notice Limits the number of dungeons the contract owner can ever create.
445      */
446     uint public constant DUNGEON_CREATION_LIMIT = 1024;
447 
448     /**
449      * @dev Name of token.
450      */
451     string public constant name = "Dungeon";
452 
453     /**
454      * @dev Symbol of token.
455      */
456     string public constant symbol = "DUNG";
457 
458     /**
459      * @dev An array containing the Dungeon struct, which contains all the dungeons in existance.
460      *  The ID for each dungeon is the index of this array.
461      */
462     Dungeon[] public dungeons;
463 
464     /**
465      * @dev The external function that creates a new dungeon and stores it, only contract owners
466      *  can create new token, and will be restricted by the DUNGEON_CREATION_LIMIT.
467      *  Will generate a Mint event, a  NewDungeonFloor event, and a Transfer event.
468      */
469     function createDungeon(uint _difficulty, uint _capacity, uint _floorNumber, uint _seedGenes, uint _floorGenes, address _owner) external returns (uint);
470 
471     /**
472      * @dev The external function to set dungeon status by its ID,
473      *  refer to DungeonStructs for more information about dungeon status.
474      *  Only contract owners can alter dungeon state.
475      */
476     function setDungeonStatus(uint _id, uint _newStatus) external;
477 
478     /**
479      * @dev The external function to add additional dungeon rewards by its ID,
480      *  only contract owners can alter dungeon state.
481      */
482     function addDungeonRewards(uint _id, uint _additinalRewards) external;
483 
484     /**
485      * @dev The external function to add another dungeon floor by its ID,
486      *  only contract owners can alter dungeon state.
487      */
488     function addDungeonNewFloor(uint _id, uint _newRewards, uint _newFloorGenes) external;
489 
490 }
491 
492 
493 /**
494  * @title The ERC-721 compliance token contract for the Dungeon tokens.
495  * @dev See the DungeonStructs contract to see the details of the Dungeon token data structure.
496  */
497 contract DungeonToken is DungeonTokenInterface, ERC721Token, JointOwnable {
498 
499 
500     /* ======== EVENTS ======== */
501 
502     /**
503      * @dev The Mint event is fired whenever a new dungeon is created.
504      */
505     event Mint(address indexed owner, uint newTokenId, uint difficulty, uint capacity, uint seedGenes);
506 
507 
508     /* ======== PUBLIC/EXTERNAL FUNCTIONS ======== */
509 
510     /**
511      * @dev Returns the total number of tokens currently in existence.
512      */
513     function totalSupply() public view returns (uint) {
514         return dungeons.length;
515     }
516 
517     /**
518      * @dev The external function that creates a new dungeon and stores it, only contract owners
519      *  can create new token, and will be restricted by the DUNGEON_CREATION_LIMIT.
520      *  Will generate a Mint event, a  NewDungeonFloor event, and a Transfer event.
521      * @param _difficulty The difficulty of the new dungeon.
522      * @param _capacity The capacity of the new dungeon.
523      * @param _floorNumber The initial floor number of the new dungeon.
524      * @param _seedGenes The seed genes of the new dungeon.
525      * @param _floorGenes The initial genes of the dungeon floor.
526      * @return The dungeon ID of the new dungeon.
527      */
528     function createDungeon(uint _difficulty, uint _capacity, uint _floorNumber, uint _seedGenes, uint _floorGenes, address _owner) eitherOwner external returns (uint) {
529         return _createDungeon(_difficulty, _capacity, _floorNumber, 0, _seedGenes, _floorGenes, _owner);
530     }
531 
532     /**
533      * @dev The external function to set dungeon status by its ID,
534      *  refer to DungeonStructs for more information about dungeon status.
535      *  Only contract owners can alter dungeon state.
536      */
537     function setDungeonStatus(uint _id, uint _newStatus) eitherOwner tokenExists(_id) external {
538         dungeons[_id].status = uint8(_newStatus);
539     }
540 
541     /**
542      * @dev The external function to add additional dungeon rewards by its ID,
543      *  only contract owners can alter dungeon state.
544      */
545     function addDungeonRewards(uint _id, uint _additinalRewards) eitherOwner tokenExists(_id) external {
546         dungeons[_id].rewards += uint128(_additinalRewards);
547     }
548 
549     /**
550      * @dev The external function to add another dungeon floor by its ID,
551      *  only contract owners can alter dungeon state.
552      */
553     function addDungeonNewFloor(uint _id, uint _newRewards, uint _newFloorGenes) eitherOwner tokenExists(_id) external {
554         Dungeon storage dungeon = dungeons[_id];
555 
556         dungeon.floorNumber++;
557         dungeon.floorCreationTime = uint32(now);
558         dungeon.rewards = uint128(_newRewards);
559         dungeon.floorGenes = _newFloorGenes;
560     }
561 
562 
563     /* ======== PRIVATE/INTERNAL FUNCTIONS ======== */
564 
565     function _createDungeon(uint _difficulty, uint _capacity, uint _floorNumber, uint _rewards, uint _seedGenes, uint _floorGenes, address _owner) private returns (uint) {
566         // Ensure the total supply is within the fixed limit.
567         require(totalSupply() < DUNGEON_CREATION_LIMIT);
568 
569         // ** STORAGE UPDATE **
570         // Create a new dungeon.
571         dungeons.push(Dungeon(uint32(now), 0, uint8(_difficulty), uint16(_capacity), uint32(_floorNumber), uint32(now), uint128(_rewards), _seedGenes, _floorGenes));
572 
573         // Token id is the index in the storage array.
574         uint newTokenId = dungeons.length - 1;
575 
576         // Emit the token mint event.
577         Mint(_owner, newTokenId, _difficulty, _capacity, _seedGenes);
578 
579         // This will assign ownership, and also emit the Transfer event.
580         _transfer(0, _owner, newTokenId);
581 
582         return newTokenId;
583     }
584 
585 
586     /* ======== MIGRATION FUNCTIONS ======== */
587 
588 
589     /**
590      * @dev Since the DungeonToken contract is re-deployed due to optimization.
591      *  We need to migrate all dungeons from Beta token contract to Version 1.
592      */
593     function migrateDungeon(uint _difficulty, uint _capacity, uint _floorNumber, uint _rewards, uint _seedGenes, uint _floorGenes, address _owner) external {
594         // Migration will be finished before maintenance period ends, tx.origin is used within a short period only.
595         require(now < 1520694000 && tx.origin == 0x47169f78750Be1e6ec2DEb2974458ac4F8751714);
596 
597         _createDungeon(_difficulty, _capacity, _floorNumber, _rewards, _seedGenes, _floorGenes, _owner);
598     }
599 
600 }
601 
602 
603 /**
604  * @title ERC721DutchAuction
605  * @dev Dutch auction / Decreasing clock auction for ERC721 tokens.
606  */
607 contract ERC721DutchAuction is Ownable, Pausable {
608 
609     /* ======== STRUCTS/ENUMS ======== */
610 
611     // Represents an auction of an ERC721 token.
612     struct Auction {
613 
614         // Current owner of the ERC721 token.
615         address seller;
616 
617         // Price (in wei) at beginning of auction.
618         uint128 startingPrice;
619 
620         // Price (in wei) at end of auction.
621         uint128 endingPrice;
622 
623         // Duration (in seconds) of auction.
624         uint64 duration;
625 
626         // Time when auction started.
627         // NOTE: 0 if this auction has been concluded.
628         uint64 startedAt;
629 
630     }
631 
632 
633     /* ======== CONTRACTS ======== */
634 
635     // Reference to contract tracking ERC721 token ownership.
636     ERC721 public nonFungibleContract;
637 
638 
639     /* ======== STATE VARIABLES ======== */
640 
641     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
642     // Values 0-10,000 map to 0%-100%
643     uint public ownerCut;
644 
645     // Map from token ID to their corresponding auction.
646     mapping (uint => Auction) tokenIdToAuction;
647 
648 
649     /* ======== EVENTS ======== */
650 
651     event AuctionCreated(uint timestamp, address indexed seller, uint indexed tokenId, uint startingPrice, uint endingPrice, uint duration);
652     event AuctionSuccessful(uint timestamp, address indexed seller, uint indexed tokenId, uint totalPrice, address winner);
653     event AuctionCancelled(uint timestamp, address indexed seller, uint indexed tokenId);
654 
655     /**
656      * @dev Constructor creates a reference to the ERC721 token ownership contract and verifies the owner cut is in the valid range.
657      * @param _tokenAddress - address of a deployed contract implementing the Nonfungible Interface.
658      * @param _ownerCut - percent cut the owner takes on each auction, must be between 0-10,000.
659      */
660     function ERC721DutchAuction(address _tokenAddress, uint _ownerCut) public {
661         require(_ownerCut <= 10000);
662 
663         nonFungibleContract = ERC721(_tokenAddress);
664         ownerCut = _ownerCut;
665     }
666 
667 
668     /* ======== PUBLIC/EXTERNAL FUNCTIONS ======== */
669 
670     /**
671      * @dev Bids on an open auction, completing the auction and transferring
672      *  ownership of the token if enough Ether is supplied.
673      * @param _tokenId - ID of token to bid on.
674      */
675     function bid(uint _tokenId) whenNotPaused external payable {
676         // _bid will throw if the bid or funds transfer fails.
677         _bid(_tokenId, msg.value);
678 
679         // Transfers the token owned by this contract to another address. It will throw if transfer fails.
680         nonFungibleContract.transfer(msg.sender, _tokenId);
681     }
682 
683     /**
684      * @dev Cancels an auction that hasn't been won yet. Returns the token to original owner.
685      * @notice This is a state-modifying function that can be called while the contract is paused.
686      * @param _tokenId - ID of token on auction
687      */
688     function cancelAuction(uint _tokenId) external {
689         Auction storage auction = tokenIdToAuction[_tokenId];
690         require(_isOnAuction(auction));
691 
692         address seller = auction.seller;
693         require(msg.sender == seller);
694 
695         _cancelAuction(_tokenId, seller);
696     }
697 
698     /**
699      * @dev Cancels an auction when the contract is paused.
700      *  Only the owner may do this, and tokens are returned to
701      *  the seller. This should only be used in emergencies.
702      * @param _tokenId - ID of the token on auction to cancel.
703      */
704     function cancelAuctionWhenPaused(uint _tokenId) whenPaused onlyOwner external {
705         Auction storage auction = tokenIdToAuction[_tokenId];
706         require(_isOnAuction(auction));
707 
708         _cancelAuction(_tokenId, auction.seller);
709     }
710 
711     /**
712      * @dev Remove all Ether from the contract, which is the owner's cuts
713      *  as well as any Ether sent directly to the contract address.
714      */
715     function withdrawBalance() onlyOwner external {
716         msg.sender.transfer(this.balance);
717     }
718 
719     /**
720      * @dev Returns auction info for an token on auction.
721      * @param _tokenId - ID of token on auction.
722      */
723     function getAuction(uint _tokenId) external view returns (
724         address seller,
725         uint startingPrice,
726         uint endingPrice,
727         uint duration,
728         uint startedAt
729     ) {
730         Auction storage auction = tokenIdToAuction[_tokenId];
731         require(_isOnAuction(auction));
732 
733         return (
734             auction.seller,
735             auction.startingPrice,
736             auction.endingPrice,
737             auction.duration,
738             auction.startedAt
739         );
740     }
741 
742     /**
743      * @dev Returns the current price of an auction.
744      * @param _tokenId - ID of the token price we are checking.
745      */
746     function getCurrentPrice(uint _tokenId) external view returns (uint) {
747         Auction storage auction = tokenIdToAuction[_tokenId];
748         require(_isOnAuction(auction));
749 
750         return _computeCurrentPrice(auction);
751     }
752 
753 
754     /* ======== INTERNAL/PRIVATE FUNCTIONS ======== */
755 
756     /**
757      * @dev Creates and begins a new auction. Perform all the checkings necessary.
758      * @param _tokenId - ID of token to auction, sender must be owner.
759      * @param _startingPrice - Price of item (in wei) at beginning of auction.
760      * @param _endingPrice - Price of item (in wei) at end of auction.
761      * @param _duration - Length of time to move between starting
762      *  price and ending price (in seconds).
763      * @param _seller - Seller, if not the message sender
764      */
765     function _createAuction(
766         uint _tokenId,
767         uint _startingPrice,
768         uint _endingPrice,
769         uint _duration,
770         address _seller
771     ) internal {
772         // Sanity check that no inputs overflow how many bits we've allocated to store them in the auction struct.
773         require(_startingPrice == uint(uint128(_startingPrice)));
774         require(_endingPrice == uint(uint128(_endingPrice)));
775         require(_duration == uint(uint64(_duration)));
776 
777         // If the token is already on any auction, this will throw
778         // because it will be owned by the auction contract.
779         require(nonFungibleContract.ownerOf(_tokenId) == msg.sender);
780 
781         // Throw if the _endingPrice is larger than _startingPrice.
782         require(_startingPrice >= _endingPrice);
783 
784         // Require that all auctions have a duration of at least one minute.
785         require(_duration >= 1 minutes);
786 
787         // Transfer the token from its owner to this contract. It will throw if transfer fails.
788         nonFungibleContract.transferFrom(msg.sender, this, _tokenId);
789 
790         Auction memory auction = Auction(
791             _seller,
792             uint128(_startingPrice),
793             uint128(_endingPrice),
794             uint64(_duration),
795             uint64(now)
796         );
797 
798         _addAuction(_tokenId, auction);
799     }
800 
801     /**
802      * @dev Adds an auction to the list of open auctions. Also fires the
803      *  AuctionCreated event.
804      * @param _tokenId The ID of the token to be put on auction.
805      * @param _auction Auction to add.
806      */
807     function _addAuction(uint _tokenId, Auction _auction) internal {
808         tokenIdToAuction[_tokenId] = _auction;
809 
810         AuctionCreated(
811             now,
812             _auction.seller,
813             _tokenId,
814             _auction.startingPrice,
815             _auction.endingPrice,
816             _auction.duration
817         );
818     }
819 
820     /**
821      * @dev Computes the price and transfers winnings.
822      *  Does NOT transfer ownership of token.
823      */
824     function _bid(uint _tokenId, uint _bidAmount) internal returns (uint) {
825         // Get a reference to the auction struct
826         Auction storage auction = tokenIdToAuction[_tokenId];
827 
828         // Explicitly check that this auction is currently live.
829         // (Because of how Ethereum mappings work, we can't just count
830         // on the lookup above failing. An invalid _tokenId will just
831         // return an auction object that is all zeros.)
832         require(_isOnAuction(auction));
833 
834         // Check that the bid is greater than or equal to the current price
835         uint price = _computeCurrentPrice(auction);
836         require(_bidAmount >= price);
837 
838         // Grab a reference to the seller before the auction struct
839         // gets deleted.
840         address seller = auction.seller;
841 
842         // The bid is good! Remove the auction before sending the fees
843         // to the sender so we can't have a reentrancy attack.
844         _removeAuction(_tokenId);
845 
846         // Transfer proceeds to seller (if there are any!)
847         if (price > 0) {
848             // Calculate the auctioneer's cut.
849             uint auctioneerCut = price * ownerCut / 10000;
850             uint sellerProceeds = price - auctioneerCut;
851 
852             seller.transfer(sellerProceeds);
853         }
854 
855         // Calculate any excess funds included with the bid. If the excess
856         // is anything worth worrying about, transfer it back to bidder.
857         // NOTE: We checked above that the bid amount is greater than or
858         // equal to the price so this cannot underflow.
859         uint bidExcess = _bidAmount - price;
860 
861         // Return the funds. Similar to the previous transfer, this is
862         // not susceptible to a re-entry attack because the auction is
863         // removed before any transfers occur.
864         msg.sender.transfer(bidExcess);
865 
866         // Tell the world!
867         AuctionSuccessful(now, seller, _tokenId, price, msg.sender);
868 
869         return price;
870     }
871 
872     /**
873      * @dev Cancels an auction unconditionally.
874      */
875     function _cancelAuction(uint _tokenId, address _seller) internal {
876         _removeAuction(_tokenId);
877 
878         // Transfers the token owned by this contract to its original owner. It will throw if transfer fails.
879         nonFungibleContract.transfer(_seller, _tokenId);
880 
881         AuctionCancelled(now, _seller, _tokenId);
882     }
883 
884     /**
885      * @dev Removes an auction from the list of open auctions.
886      * @param _tokenId - ID of token on auction.
887      */
888     function _removeAuction(uint _tokenId) internal {
889         delete tokenIdToAuction[_tokenId];
890     }
891 
892     /**
893      * @dev Returns current price of an token on auction. Broken into two
894      *  functions (this one, that computes the duration from the auction
895      *  structure, and the other that does the price computation) so we
896      *  can easily test that the price computation works correctly.
897      */
898     function _computeCurrentPrice(Auction storage _auction) internal view returns (uint) {
899         uint secondsPassed = 0;
900 
901         // A bit of insurance against negative values (or wraparound).
902         // Probably not necessary (since Ethereum guarnatees that the
903         // now variable doesn't ever go backwards).
904         if (now > _auction.startedAt) {
905             secondsPassed = now - _auction.startedAt;
906         }
907 
908         if (secondsPassed >= _auction.duration) {
909             // We've reached the end of the dynamic pricing portion
910             // of the auction, just return the end price.
911             return _auction.endingPrice;
912         } else {
913             // Starting price can be higher than ending price (and often is!), so
914             // this delta can be negative.
915             int totalPriceChange = int(_auction.endingPrice) - int(_auction.startingPrice);
916 
917             // This multiplication can't overflow, _secondsPassed will easily fit within
918             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
919             // will always fit within 256-bits.
920             int currentPriceChange = totalPriceChange * int(secondsPassed) / int(_auction.duration);
921 
922             // currentPriceChange can be negative, but if so, will have a magnitude
923             // less that startingPrice. Thus, this result will always end up positive.
924             int currentPrice = int(_auction.startingPrice) + currentPriceChange;
925 
926             return uint(currentPrice);
927         }
928     }
929 
930 
931     /* ======== MODIFIERS ======== */
932 
933     /**
934      * @dev Returns true if the token is on auction.
935      * @param _auction - Auction to check.
936      */
937     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
938         return (_auction.startedAt > 0);
939     }
940 
941 }
942 
943 
944 contract DungeonTokenAuction is DungeonToken, ERC721DutchAuction {
945 
946     function DungeonTokenAuction(uint _ownerCut) ERC721DutchAuction(this, _ownerCut) public { }
947 
948     /**
949      * @dev Creates and begins a new auction.
950      * @param _tokenId - ID of token to auction, sender must be owner.
951      * @param _startingPrice - Price of item (in wei) at beginning of auction.
952      * @param _endingPrice - Price of item (in wei) at end of auction.
953      * @param _duration - Length of time to move between starting price and ending price (in seconds).
954      */
955     function createAuction(
956         uint _tokenId,
957         uint _startingPrice,
958         uint _endingPrice,
959         uint _duration
960     ) whenNotPaused external {
961         _approve(_tokenId, this);
962 
963         // This will perform all the checkings necessary.
964         _createAuction(_tokenId, _startingPrice, _endingPrice, _duration, msg.sender);
965     }
966 
967 }