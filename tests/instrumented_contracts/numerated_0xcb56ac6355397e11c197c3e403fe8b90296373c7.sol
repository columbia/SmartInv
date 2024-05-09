1 pragma solidity ^0.4.11;
2 
3 
4 
5 contract Ownable {
6   address public owner;
7 
8 
9   /**
10    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
11    * account.
12    */
13   function Ownable() public {
14     owner = msg.sender;
15   }
16 
17 
18   /**
19    * @dev Throws if called by any account other than the owner.
20    */
21   modifier onlyOwner() {
22     require(msg.sender == owner);
23     _;
24   }
25 
26 
27   /**
28    * @dev Allows the current owner to transfer control of the contract to a newOwner.
29    * @param newOwner The address to transfer ownership to.
30    */
31   function transferOwnership(address newOwner) public onlyOwner {
32     if (newOwner != address(0)) {
33       owner = newOwner;
34     }
35   }
36 
37 }
38 
39 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
40 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
41 contract ERC721 {
42     // Required methods
43     function totalSupply() public view returns (uint256 total);
44     function balanceOf(address _owner) public view returns (uint256 balance);
45     function ownerOf(uint256 _tokenId) external view returns (address owner);
46     function approve(address _to, uint256 _tokenId) external;
47     function transfer(address _to, uint256 _tokenId) external;
48     function transferFrom(address _from, address _to, uint256 _tokenId) external;
49 
50     // Events
51     event Transfer(address from, address to, uint256 tokenId);
52     event Approval(address owner, address approved, uint256 tokenId);
53 
54     // Optional
55     // function name() public view returns (string name);
56     // function symbol() public view returns (string symbol);
57     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
58     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
59 
60     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
61     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
62 }
63 
64 
65 
66 
67 
68 
69 
70 
71 
72 
73 
74 contract MonsterAccessControl {
75 
76     event ContractUpgrade(address newContract);
77 
78      // The addresses of the accounts (or contracts) that can execute actions within each roles.
79     address public adminAddress;
80     
81 
82   
83 
84     /// @dev Access modifier for CEO-only functionality
85     modifier onlyAdmin() {
86         require(msg.sender == adminAddress);
87         _;
88     }
89 
90   
91 
92     
93 }
94 
95 // This contract stores all data on the blockchain
96 // only our other contracts can interact with this
97 // the data here will be valid for all eternity even if other contracts get updated
98 // this way we can make sure that our Monsters have a hard-coded value attached to them
99 // that no one including us can change(!)
100 contract MonstersData {
101 
102     address coreContract; // 
103     
104 
105 
106     struct Monster {
107         // timestamp of block when this monster was spawned/created
108         uint64 birthTime;
109 
110         // generation number
111         // gen0 is the very first generation - the later monster spawn the less likely they are to have
112         // special attributes and stats
113        // uint16 generation;
114 
115         uint16 hp; // health points 
116         uint16 attack; // attack points
117         uint16 defense; // defense points
118         uint16 spAttack; // special attack
119         uint16 spDefense; // special defense
120         uint16 speed; // speed responsible of who attacks first(!)
121         
122 
123         uint16 typeOne;
124         uint16 typeTwo;
125 
126         uint16 mID; // this id (from 1 to 151) is responsible for everything visually like showing the real deal!
127         bool tradeable;
128         //uint16 uID; // unique id
129         
130         // These attributes are handled by mappings since they would overflow the maximum stack
131         //bool female
132         // string nickname
133         
134 
135     }
136 
137     // lv1 base stats
138     struct MonsterBaseStats {
139         uint16 hp;
140         uint16 attack;
141         uint16 defense;
142         uint16 spAttack;
143         uint16 spDefense;
144         uint16 speed;
145         
146     }
147 
148     // lomonsterion struct used for travelling around the "world"
149     // 
150     struct Area {
151         // areaID used in-engine to determine world position
152        
153              
154         // minimum level to enter this area...
155         uint16 minLevel;
156     }
157 
158     struct Trainer {
159         // timestamp of block when this player/trainer was created
160         uint64 birthTime;
161         
162         // add username
163         string username;
164        
165         
166         // current area in the "world"
167         uint16 currArea;
168         
169         address owner;
170         
171        
172         
173     }
174 
175 
176    
177 
178 
179     // take timestamp of block this game was created on the blockchain
180     uint64 creationBlock = uint64(now);
181    
182    
183 
184    
185   
186     
187 
188 
189     
190   
191         
192 
193 
194 }
195 
196 
197 
198 
199 contract MonstersBase is MonsterAccessControl, MonstersData {
200 
201     /// @dev Transfer event as defined in current draft of ERC721. Emitted every time a monster
202     ///  ownership is assigned, including births.
203     event Transfer(address from, address to, uint256 tokenId);
204 
205     bool lockedMonsterCreator = false;
206 
207     MonsterAuction public monsterAuction;
208 
209     MonsterCreatorInterface public monsterCreator;
210 
211 
212     function setMonsterCreatorAddress(address _address) external onlyAdmin {
213         // only set this once so we (the devs) can't cheat!
214         require(!lockedMonsterCreator);
215         MonsterCreatorInterface candidateContract = MonsterCreatorInterface(_address);
216 
217        
218 
219         monsterCreator = candidateContract;
220         lockedMonsterCreator = true;
221 
222     }
223     
224     // An approximation of currently how many seconds are in between blocks.
225     uint256 public secondsPerBlock = 15;
226   
227 
228     // array containing all monsters in existence
229     Monster[] monsters;
230 
231     uint8[] areas;
232 
233     uint8 areaIndex = 0;
234     
235 
236 
237       mapping(address => Trainer) public addressToTrainer;
238     
239 
240     /// @dev A mapping from monster IDs to the address that owns them. All monster have
241     ///  some valid owner address, even gen0 monster are created with a non-zero owner.
242     mapping (uint256 => address) public monsterIndexToOwner;
243 
244     // @dev A mapping from owner address to count of tokens that address owns.
245     //  Used internally inside balanceOf() to resolve ownership count.
246     mapping (address => uint256) ownershipTokenCount;
247 
248 
249     mapping (uint256 => address) public monsterIndexToApproved;
250     
251     mapping (uint256 => string) public monsterIdToNickname;
252     
253     mapping (uint256 => bool) public monsterIdToTradeable;
254     
255     mapping (uint256 => uint256) public monsterIdToGeneration;
256 
257 
258      mapping (uint256 => MonsterBaseStats) public baseStats;
259 
260      mapping (uint256 => uint8[7]) public monsterIdToIVs;
261     
262 
263 
264     // adds new area to world 
265     function _createArea() internal {
266             
267             areaIndex++;
268             areas.push(areaIndex);
269             
270             
271         }
272 
273     
274 
275 
276     function _createMonster(
277         uint256 _generation,
278         uint256 _hp,
279         uint256 _attack,
280         uint256 _defense,
281         uint256 _spAttack,
282         uint256 _spDefense,
283         uint256 _speed,
284         uint256 _typeOne,
285         uint256 _typeTwo,
286         address _owner,
287         uint256 _mID,
288         bool tradeable
289         
290     )
291         internal
292         returns (uint)
293         {
294            
295 
296             Monster memory _monster = Monster({
297                 birthTime: uint64(now),
298                 hp: uint16(_hp),
299                 attack: uint16(_attack),
300                 defense: uint16(_defense),
301                 spAttack: uint16(_spAttack),
302                 spDefense: uint16(_spDefense),
303                 speed: uint16(_speed),
304                 typeOne: uint16(_typeOne),
305                 typeTwo: uint16(_typeTwo),
306                 mID: uint16(_mID),
307                 tradeable: tradeable
308                 
309 
310 
311             });
312             uint256 newMonsterId = monsters.push(_monster) - 1;
313             monsterIdToTradeable[newMonsterId] = tradeable;
314             monsterIdToGeneration[newMonsterId] = _generation;
315            
316 
317             require(newMonsterId == uint256(uint32(newMonsterId)));
318             
319            
320           
321             
322              monsterIdToNickname[newMonsterId] = "";
323 
324             _transfer(0, _owner, newMonsterId);
325 
326             return newMonsterId;
327 
328 
329         }
330     
331     function _createTrainer(string _username, uint16 _starterId, address _owner)
332         internal
333         returns (uint mon)
334         {
335             
336            
337             Trainer memory _trainer = Trainer({
338                
339                 birthTime: uint64(now),
340                 username: string(_username),
341                 currArea: uint16(1), // sets to first area!,
342                 owner: address(_owner)
343                 
344             });
345             addressToTrainer[_owner] = _trainer;
346             
347             // starter stats are hardcoded!
348             if (_starterId == 1) {
349                 uint8[8] memory Stats = uint8[8](monsterCreator.getMonsterStats(1));
350                 mon = _createMonster(0, Stats[0], Stats[1], Stats[2], Stats[3], Stats[4], Stats[5], Stats[6], Stats[7], _owner, 1, false);
351                
352             } else if (_starterId == 2) {
353                 uint8[8] memory Stats2 = uint8[8](monsterCreator.getMonsterStats(4));
354                 mon = _createMonster(0, Stats2[0], Stats2[1], Stats2[2], Stats2[3], Stats2[4], Stats2[5], Stats2[6], Stats2[7], _owner, 4, false);
355                 
356             } else if (_starterId == 3) {
357                 uint8[8] memory Stats3 = uint8[8](monsterCreator.getMonsterStats(7));
358                 mon = _createMonster(0, Stats3[0], Stats3[1], Stats3[2], Stats3[3], Stats3[4], Stats3[5], Stats3[6], Stats3[7], _owner, 7, false);
359                 
360             }
361             
362         }
363 
364 
365     function _moveToArea(uint16 _newArea, address player) internal {
366             
367             addressToTrainer[player].currArea = _newArea;
368           
369         }   
370         
371     
372      
373 
374     
375     // assigns ownership of monster to address
376     function _transfer(address _from, address _to, uint256 _tokenId) internal {
377         ownershipTokenCount[_to]++;
378         monsterIndexToOwner[_tokenId] = _to;
379 
380         if (_from != address(0)) {
381             ownershipTokenCount[_from]--;
382 
383             // clear any previously approved ownership exchange
384             delete monsterIndexToApproved[_tokenId];
385         }
386 
387         // Emit Transfer event
388         Transfer(_from, _to, _tokenId);
389     }
390 
391 
392     // Only admin can fix how many seconds per blocks are currently observed.
393     function setSecondsPerBlock(uint256 secs) external onlyAdmin {
394         //require(secs < cooldowns[0]);
395         secondsPerBlock = secs;
396     }
397 
398 
399     
400 
401 
402 }
403 
404 /// @title The external contract that is responsible for generating metadata for the monsters,
405 ///  it has one function that will return the data as bytes.
406 contract ERC721Metadata {
407     /// @dev Given a token Id, returns a byte array that is supposed to be converted into string.
408     function getMetadata(uint256 _tokenId, string) public view returns (bytes32[4] buffer, uint256 count) {
409         if (_tokenId == 1) {
410             buffer[0] = "Hello World! :D";
411             count = 15;
412         } else if (_tokenId == 2) {
413             buffer[0] = "I would definitely choose a medi";
414             buffer[1] = "um length string.";
415             count = 49;
416         } else if (_tokenId == 3) {
417             buffer[0] = "Lorem ipsum dolor sit amet, mi e";
418             buffer[1] = "st accumsan dapibus augue lorem,";
419             buffer[2] = " tristique vestibulum id, libero";
420             buffer[3] = " suscipit varius sapien aliquam.";
421             count = 128;
422         }
423     }
424 }
425 
426 
427 contract MonsterOwnership is MonstersBase, ERC721 {
428 
429     string public constant name = "ChainMonsters";
430     string public constant symbol = "CHMO";
431 
432 
433     // The contract that will return monster metadata
434     ERC721Metadata public erc721Metadata;
435 
436     bytes4 constant InterfaceSignature_ERC165 =
437         bytes4(keccak256('supportsInterface(bytes4)'));
438 
439 
440 
441 
442     bytes4 constant InterfaceSignature_ERC721 =
443         bytes4(keccak256('name()')) ^
444         bytes4(keccak256('symbol()')) ^
445         bytes4(keccak256('totalSupply()')) ^
446         bytes4(keccak256('balanceOf(address)')) ^
447         bytes4(keccak256('ownerOf(uint256)')) ^
448         bytes4(keccak256('approve(address,uint256)')) ^
449         bytes4(keccak256('transfer(address,uint256)')) ^
450         bytes4(keccak256('transferFrom(address,address,uint256)')) ^
451         bytes4(keccak256('tokensOfOwner(address)')) ^
452         bytes4(keccak256('tokenMetadata(uint256,string)'));
453 
454 
455 
456 
457     function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
458         // DEBUG ONLY
459         //require((InterfaceSignature_ERC165 == 0x01ffc9a7) && (InterfaceSignature_ERC721 == 0x9a20483d));
460 
461         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
462     }
463 
464     /// @dev Set the address of the sibling contract that tracks metadata.
465     ///  CEO only.
466     function setMetadataAddress(address _contractAddress) public onlyAdmin {
467         erc721Metadata = ERC721Metadata(_contractAddress);
468     }
469 
470     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
471         return monsterIndexToOwner[_tokenId] == _claimant;
472     }
473     
474     function _isTradeable(uint256 _tokenId) external view returns (bool) {
475         return monsterIdToTradeable[_tokenId];
476     }
477     
478     
479     /// @dev Checks if a given address currently has transferApproval for a particular monster.
480     /// @param _claimant the address we are confirming monster is approved for.
481     /// @param _tokenId monster id, only valid when > 0
482     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
483         return monsterIndexToApproved[_tokenId] == _claimant;
484     }
485 
486     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
487     ///  approval. Setting _approved to address(0) clears all transfer approval.
488     ///  NOTE: _approve() does NOT send the Approval event. This is intentional because
489     ///  _approve() and transferFrom() are used together for putting monsters on auction, and
490     ///  there is no value in spamming the log with Approval events in that case.
491     function _approve(uint256 _tokenId, address _approved) internal {
492         monsterIndexToApproved[_tokenId] = _approved;
493     }
494     
495     
496     function balanceOf(address _owner) public view returns (uint256 count) {
497         return ownershipTokenCount[_owner];
498     }
499 
500 
501     function transfer (address _to, uint256 _tokenId) external {
502         // Safety check to prevent against an unexpected 0x0 default.
503         require(_to != address(0));
504         // Disallow transfers to this contract to prevent accidental misuse.
505         // The contract should never own any monsters (except very briefly
506         // after a gen0 monster is created and before it goes on auction).
507         require(_to != address(this));
508         
509 
510         // You can only send your own monster.
511         require(_owns(msg.sender, _tokenId));
512 
513         // Reassign ownership, clear pending approvals, emit Transfer event.
514         _transfer(msg.sender, _to, _tokenId);
515     }
516 
517     
518     
519 
520 /// @notice Grant another address the right to transfer a specific monster via
521     ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
522     /// @param _to The address to be granted transfer approval. Pass address(0) to
523     ///  clear all approvals.
524     /// @param _tokenId The ID of the monster that can be transferred if this call succeeds.
525     /// @dev Required for ERC-721 compliance.
526     function approve(address _to, uint256 _tokenId ) external {
527         // Only an owner can grant transfer approval.
528         require(_owns(msg.sender, _tokenId));
529 
530         // Register the approval (replacing any previous approval).
531         _approve(_tokenId, _to);
532 
533         // Emit approval event.
534         Approval(msg.sender, _to, _tokenId);
535     }
536 
537     /// @notice Transfer a monster owned by another address, for which the calling address
538     ///  has previously been granted transfer approval by the owner.
539     /// @param _from The address that owns the monster to be transfered.
540     /// @param _to The address that should take ownership of the monster. Can be any address,
541     ///  including the caller.
542     /// @param _tokenId The ID of the monster to be transferred.
543     /// @dev Required for ERC-721 compliance.
544     function transferFrom (address _from, address _to, uint256 _tokenId ) external {
545         // Safety check to prevent against an unexpected 0x0 default.
546         require(_to != address(0));
547         // Disallow transfers to this contract to prevent accidental misuse.
548         // The contract should never own any monsters (except very briefly
549         // after a gen0 monster is created and before it goes on auction).
550         require(_to != address(this));
551         // Check for approval and valid ownership
552         //require(_approvedFor(msg.sender, _tokenId));
553         require(_owns(_from, _tokenId));
554 
555         // Reassign ownership (also clears pending approvals and emits Transfer event).
556         _transfer(_from, _to, _tokenId);
557     }
558 
559     function totalSupply() public view returns (uint) {
560         return monsters.length;
561     }
562 
563 
564     function ownerOf(uint256 _tokenId)
565             external
566             view
567             returns (address owner)
568         {
569             owner = monsterIndexToOwner[_tokenId];
570 
571             require(owner != address(0));
572         }
573 
574      function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
575         uint256 tokenCount = balanceOf(_owner);
576 
577         if (tokenCount == 0) {
578             // Return an empty array
579             return new uint256[](0);
580         } else {
581             uint256[] memory result = new uint256[](tokenCount);
582             uint256 totalMonsters = totalSupply();
583             uint256 resultIndex = 0;
584 
585             
586             uint256 monsterId;
587 
588             for (monsterId = 0; monsterId <= totalMonsters; monsterId++) {
589                 if (monsterIndexToOwner[monsterId] == _owner) {
590                     result[resultIndex] = monsterId;
591                     resultIndex++;
592                 }
593             }
594 
595             return result;
596         }
597     }
598 
599 
600    
601 
602     /// @dev Adapted from memcpy() by @arachnid (Nick Johnson <arachnid@notdot.net>)
603     ///  This method is licenced under the Apache License.
604     ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
605     function _memcpy(uint _dest, uint _src, uint _len) private view {
606         // Copy word-length chunks while possible
607         for(; _len >= 32; _len -= 32) {
608             assembly {
609                 mstore(_dest, mload(_src))
610             }
611             _dest += 32;
612             _src += 32;
613         }
614 
615         // Copy remaining bytes
616         uint256 mask = 256 ** (32 - _len) - 1;
617         assembly {
618             let srcpart := and(mload(_src), not(mask))
619             let destpart := and(mload(_dest), mask)
620             mstore(_dest, or(destpart, srcpart))
621         }
622     }
623 
624     /// @dev Adapted from toString(slice) by @arachnid (Nick Johnson <arachnid@notdot.net>)
625     ///  This method is licenced under the Apache License.
626     ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
627     function _toString(bytes32[4] _rawBytes, uint256 _stringLength) private view returns (string) {
628         var outputString = new string(_stringLength);
629         uint256 outputPtr;
630         uint256 bytesPtr;
631 
632         assembly {
633             outputPtr := add(outputString, 32)
634             bytesPtr := _rawBytes
635         }
636 
637         _memcpy(outputPtr, bytesPtr, _stringLength);
638 
639         return outputString;
640     }
641 
642     /// @notice Returns a URI pointing to a metadata package for this token conforming to
643     ///  ERC-721 (https://github.com/ethereum/EIPs/issues/721)
644     /// @param _tokenId The ID number of the monster whose metadata should be returned.
645     function tokenMetadata(uint256 _tokenId, string _preferredTransport) external view returns (string infoUrl) {
646         require(erc721Metadata != address(0));
647         bytes32[4] memory buffer;
648         uint256 count;
649         (buffer, count) = erc721Metadata.getMetadata(_tokenId, _preferredTransport);
650 
651         return _toString(buffer, count);
652     }
653 
654 }
655 
656 contract MonsterAuctionBase {
657     
658     
659     // Reference to contract tracking NFT ownership
660     ERC721 public nonFungibleContract;
661     ChainMonstersCore public core;
662     
663     struct Auction {
664 
665         // current owner
666         address seller;
667 
668         // price in wei
669         uint256 price;
670 
671         // time when auction started
672         uint64 startedAt;
673 
674         uint256 id;
675     }
676 
677   
678 
679     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
680     // Values 0-10,000 map to 0%-100%
681     uint256 public ownerCut;
682 
683     // Map from token ID to their corresponding auction.
684     mapping(uint256 => Auction) tokenIdToAuction;
685 
686     mapping(uint256 => address) public auctionIdToSeller;
687     
688     mapping (address => uint256) public ownershipAuctionCount;
689 
690 
691     event AuctionCreated(uint256 tokenId, uint256 price, uint256 uID, address seller);
692     event AuctionSuccessful(uint256 tokenId, uint256 price, address newOwner, uint256 uID);
693     event AuctionCancelled(uint256 tokenId, uint256 uID);
694 
695 
696     function _transfer(address _receiver, uint256 _tokenId) internal {
697         // it will throw if transfer fails
698         nonFungibleContract.transfer(_receiver, _tokenId);
699     }
700 
701 
702     function _addAuction(uint256 _tokenId, Auction _auction) internal {
703         
704         tokenIdToAuction[_tokenId] = _auction;
705 
706         AuctionCreated(
707             uint256(_tokenId),
708             uint256(_auction.price),
709             uint256(_auction.id),
710             address(_auction.seller)
711         );
712        
713     }
714 
715 
716     function _cancelAuction(uint256 _tokenId, address _seller) internal {
717         
718         Auction storage _auction = tokenIdToAuction[_tokenId];
719 
720         uint256 uID = _auction.id;
721         
722         _removeAuction(_tokenId);
723         ownershipAuctionCount[_seller]--;
724         _transfer(_seller, _tokenId);
725         
726         AuctionCancelled(_tokenId, uID);
727     }
728 
729 
730     function _buy(uint256 _tokenId, uint256 _bidAmount)
731         internal
732         returns (uint256)
733         {
734             Auction storage auction = tokenIdToAuction[_tokenId];
735         
736 
737         require(_isOnAuction(auction));
738 
739         uint256 price = auction.price;
740         require(_bidAmount >= price);
741 
742         address seller = auction.seller;
743 
744         uint256 uID = auction.id;
745         // Auction Bid looks fine! so remove
746         _removeAuction(_tokenId);
747         ownershipAuctionCount[seller]--;
748 
749         if (price > 0) {
750 
751             uint256 auctioneerCut = _computeCut(price);
752             uint256 sellerProceeds = price - auctioneerCut;
753 
754             // NOTE: Doing a transfer() in the middle of a complex
755             // method like this is generally discouraged because of
756             // reentrancy attacks and DoS attacks if the seller is
757             // a contract with an invalid fallback function. We explicitly
758             // guard against reentrancy attacks by removing the auction
759             // before calling transfer(), and the only thing the seller
760             // can DoS is the sale of their own asset! (And if it's an
761             // accident, they can call cancelAuction(). )
762             if(seller != address(core)) {
763                 seller.transfer(sellerProceeds);
764             }
765         }
766 
767         // Calculate any excess funds included with the bid. If the excess
768         // is anything worth worrying about, transfer it back to bidder.
769         // NOTE: We checked above that the bid amount is greater than or
770         // equal to the price so this cannot underflow.
771         uint256 bidExcess = _bidAmount - price;
772 
773         // Return the funds. Similar to the previous transfer, this is
774         // not susceptible to a re-entry attack because the auction is
775         // removed before any transfers occur.
776         msg.sender.transfer(bidExcess);
777 
778         // Tell the world!
779         AuctionSuccessful(_tokenId, price, msg.sender, uID);
780 
781         return price;
782 
783 
784     }
785 
786     function _removeAuction(uint256 _tokenId) internal {
787         delete tokenIdToAuction[_tokenId];
788     }
789 
790     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
791         return (_auction.startedAt > 0);
792     }
793 
794      function _computeCut(uint256 _price) internal view returns (uint256) {
795         // NOTE: We don't use SafeMath (or similar) in this function because
796         //  all of our entry functions carefully cap the maximum values for
797         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
798         //  statement in the ClockAuction constructor). The result of this
799         //  function is always guaranteed to be <= _price.
800         return _price * ownerCut / 10000;
801     }
802 
803     
804 
805 }
806 
807 
808 contract MonsterAuction is  MonsterAuctionBase, Ownable {
809 
810 
811     bool public isMonsterAuction = true;
812      uint256 public auctionIndex = 0;
813 
814     /// @dev The ERC-165 interface signature for ERC-721.
815     ///  Ref: https://github.com/ethereum/EIPs/issues/165
816     ///  Ref: https://github.com/ethereum/EIPs/issues/721
817     bytes4 constant InterfaceSignature_ERC721 = bytes4(0x9a20483d);
818 
819     function MonsterAuction(address _nftAddress, uint256 _cut) public {
820         require(_cut <= 10000);
821         ownerCut = _cut;
822 
823         ERC721 candidateContract = ERC721(_nftAddress);
824         
825         nonFungibleContract = candidateContract;
826         ChainMonstersCore candidateCoreContract = ChainMonstersCore(_nftAddress);
827         core = candidateCoreContract;
828 
829         
830     }
831     
832     // only possible to decrease ownerCut!
833     function setOwnerCut(uint256 _cut) external onlyOwner {
834         require(_cut <= ownerCut);
835         ownerCut = _cut;
836     }
837     
838     
839     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
840         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
841     }
842     
843     function _escrow(address _owner, uint256 _tokenId) internal {
844         // it will throw if transfer fails
845         nonFungibleContract.transferFrom(_owner, this, _tokenId);
846     }
847 
848     function withdrawBalance() external onlyOwner {
849        
850        
851        uint256 balance = this.balance;
852        
853        
854         owner.transfer(balance);
855 
856         
857        
858     }
859 
860     
861     function tokensInAuctionsOfOwner(address _owner) external view returns(uint256[] auctionTokens) {
862         
863            uint256 numAuctions = ownershipAuctionCount[_owner];
864 
865             
866         
867             uint256[] memory result = new uint256[](numAuctions);
868             uint256 totalAuctions = core.totalSupply();
869             uint256 resultIndex = 0;
870 
871             
872             uint256 auctionId;
873 
874             for (auctionId = 0; auctionId <= totalAuctions; auctionId++) {
875                 
876                 Auction storage auction = tokenIdToAuction[auctionId];
877                 if (auction.seller == _owner) {
878                     
879                     result[resultIndex] = auctionId;
880                     resultIndex++;
881                 }
882             }
883 
884             return result;
885         
886         
887     }
888 
889 
890 
891 
892     function createAuction(uint256 _tokenId, uint256 _price, address _seller) external {
893              require(_price == uint256(_price));
894             require(core._isTradeable(_tokenId));
895              require(_owns(msg.sender, _tokenId));
896              _escrow(msg.sender, _tokenId);
897 
898             
899 
900             
901              Auction memory auction = Auction(
902                  _seller,
903                  uint256(_price),
904                  uint64(now),
905                  uint256(auctionIndex)
906              );
907 
908             auctionIdToSeller[auctionIndex] = _seller;
909             ownershipAuctionCount[_seller]++;
910             
911              auctionIndex++;
912              _addAuction(_tokenId, auction);
913         }
914 
915     function buy(uint256 _tokenId) external payable {
916             //delete auctionIdToSeller[_tokenId];
917             // buy will throw if the bid or funds transfer fails
918             _buy (_tokenId, msg.value);
919             _transfer(msg.sender, _tokenId);
920             
921             
922         }
923 
924     
925     function cancelAuction(uint256 _tokenId) external {
926             Auction storage auction = tokenIdToAuction[_tokenId];
927             require(_isOnAuction(auction));
928 
929             address seller = auction.seller;
930             require(msg.sender == seller);
931             
932             
933             _cancelAuction(_tokenId, seller);
934         }
935 
936     
937     function getAuction(uint256 _tokenId)
938         external
939         view
940         returns
941         (
942             address seller,
943             uint256 price,
944             uint256 startedAt
945         ) {
946             Auction storage auction = tokenIdToAuction[_tokenId];
947             require(_isOnAuction(auction));
948 
949             return (
950                 auction.seller,
951                 auction.price,
952                 auction.startedAt
953             );
954         }
955 
956 
957     function getPrice(uint256 _tokenId)
958         external
959         view
960         returns (uint256)
961         {
962             Auction storage auction = tokenIdToAuction[_tokenId];
963             require(_isOnAuction(auction));
964             return auction.price;
965         }
966 }
967 
968 
969 contract ChainMonstersAuction is MonsterOwnership {
970 
971   
972 
973 
974     function setMonsterAuctionAddress(address _address) external onlyAdmin {
975         MonsterAuction candidateContract = MonsterAuction(_address);
976 
977         require(candidateContract.isMonsterAuction());
978 
979         monsterAuction = candidateContract;
980     }
981 
982 
983 
984     uint256 public constant PROMO_CREATION_LIMIT = 5000;
985 
986     uint256 public constant GEN0_CREATION_LIMIT = 5000;
987 
988     // Counts the number of monster the contract owner has created.
989     uint256 public promoCreatedCount;
990     uint256 public gen0CreatedCount;
991 
992 
993     
994     // its stats are completely dependent on the spawn alghorithm
995     function createPromoMonster(uint256 _mId, address _owner) external onlyAdmin {
996        
997 
998        // during generation we have to keep in mind that we have only 10,000 tokens available
999        // which have to be divided by 151 monsters, some rarer than others
1000        // see WhitePaper for gen0/promo monster plan
1001         
1002         require(promoCreatedCount < PROMO_CREATION_LIMIT);
1003 
1004         promoCreatedCount++;
1005         uint8[8] memory Stats = uint8[8](monsterCreator.getMonsterStats(uint256(_mId)));
1006         uint8[7] memory IVs = uint8[7](monsterCreator.getGen0IVs());
1007         
1008         uint256 monsterId = _createMonster(0, Stats[0], Stats[1], Stats[2], Stats[3], Stats[4], Stats[5], Stats[6], Stats[7], _owner, _mId, true);
1009         monsterIdToTradeable[monsterId] = true;
1010 
1011         monsterIdToIVs[monsterId] = IVs;
1012         
1013        
1014     }
1015 
1016    
1017 
1018 
1019     function createGen0Auction(uint256 _mId, uint256 price) external onlyAdmin {
1020         require(gen0CreatedCount < GEN0_CREATION_LIMIT);
1021 
1022         uint8[8] memory Stats = uint8[8](monsterCreator.getMonsterStats(uint256(_mId)));
1023         uint8[7] memory IVs = uint8[7](monsterCreator.getGen0IVs());
1024         uint256 monsterId = _createMonster(0, Stats[0], Stats[1], Stats[2], Stats[3], Stats[4], Stats[5], Stats[6], Stats[7], this, _mId, true);
1025         monsterIdToTradeable[monsterId] = true;
1026 
1027         monsterIdToIVs[monsterId] = IVs;
1028 
1029         monsterAuction.createAuction(monsterId, price, address(this));
1030 
1031 
1032         gen0CreatedCount++;
1033         
1034     }
1035 
1036     
1037 }
1038 
1039 
1040 // used during launch for world championship
1041 // can and will be upgraded during development with new battle system!
1042 // this is just to give players something to do and test their monsters
1043 // also demonstrates how we can build up more mechanics on top of our locked core contract!
1044 contract MonsterChampionship is Ownable {
1045 
1046     bool public isMonsterChampionship = true;
1047     
1048     ChainMonstersCore core;
1049     
1050     // list of top ten 
1051     address[10] topTen;
1052 
1053     // holds the address current "world" champion
1054     address public currChampion;
1055     
1056     
1057     mapping (address => uint256) public addressToPowerlevel;
1058     mapping (uint256 => address) public rankToAddress;
1059     
1060 
1061    
1062     
1063     
1064      // try to beat every other player in the top10 with your strongest monster!
1065     // effectively looping through all top10 players, beating them one by one 
1066     // and if strong enough placing your in the top10 as well
1067     function contestChampion(uint256 _tokenId) external {
1068             uint maxIndex = 9;
1069             
1070            
1071             
1072            
1073             
1074             // fail tx if player is already champion!
1075             // in theory players could increase their powerlevel by contesting themselves but
1076             // this check stops that from happening so other players have the chance to
1077             // become the temporary champion!
1078             if (currChampion == msg.sender)
1079                 revert();
1080                 
1081             
1082            require(core.isTrainer(msg.sender));        
1083            require(core.monsterIndexToOwner(_tokenId) == msg.sender);
1084             
1085            
1086            uint myPowerlevel = core.getMonsterPowerLevel(_tokenId);
1087 
1088            
1089            // checks if this transaction is useless
1090            // since we can't fight against ourself!
1091            // also stops reentrancy attacks
1092            require(myPowerlevel > addressToPowerlevel[msg.sender]);
1093            
1094           
1095            uint myRank = 0;
1096             
1097             for (uint i=0; i<=maxIndex; i++) {
1098                 //if (addres)
1099                 if ( myPowerlevel > addressToPowerlevel[topTen[i]] ) {
1100                     // you have beaten this one so increase temporary rank
1101                     myRank = i;
1102                     
1103                     if (myRank == maxIndex) {
1104                         currChampion = msg.sender;
1105                     }
1106                     
1107                     
1108                     
1109                     
1110                 }
1111                
1112                 
1113                 
1114                
1115                
1116             }
1117             
1118             addressToPowerlevel[msg.sender] = myPowerlevel;
1119             
1120             address[10] storage newTopTen = topTen;
1121             
1122             if (currChampion == msg.sender) {
1123                 for (uint j=0; j<maxIndex; j++) {
1124                     // remove ourselves from this list in case 
1125                     if (newTopTen[j] == msg.sender) {
1126                         newTopTen[j] = 0x0;
1127                         break;
1128                     }
1129                     
1130                 }
1131             }
1132             
1133             
1134             for (uint x=0; x<=myRank; x++) {
1135                 if (x == myRank) {
1136                     
1137                    
1138                     newTopTen[x] = msg.sender;
1139                 } else {
1140                     if (x < maxIndex)
1141                         newTopTen[x] = topTen[x+1];    
1142                 }
1143                 
1144                 
1145             }
1146             
1147             
1148             topTen = newTopTen;
1149             
1150         }
1151     
1152     
1153     
1154     function getTopPlayers()
1155         external
1156         view
1157         returns (
1158             address[10] players
1159         ) {
1160             players = topTen;
1161         }
1162     
1163 
1164 
1165 
1166     
1167     
1168     
1169     
1170     function MonsterChampionship(address coreContract) public {
1171        core = ChainMonstersCore(coreContract);
1172     }
1173     
1174     function withdrawBalance() external onlyOwner {
1175        
1176         uint256 balance = this.balance;
1177        
1178        
1179         owner.transfer(balance);
1180         
1181     }
1182 
1183 
1184 
1185 
1186 }
1187 
1188 
1189 // where the not-so-much "hidden" magic happens
1190 contract MonsterCreatorInterface is Ownable {
1191 
1192     uint8 public lockedMonsterStatsCount = 0;
1193     uint nonce = 0;
1194 
1195     function rand(uint8 min, uint8 max) public returns (uint8) {
1196         nonce++;
1197         uint8 result = (uint8(sha3(block.blockhash(block.number-1), nonce ))%max);
1198         
1199         if (result < min)
1200         {
1201             result = result+min;
1202         }
1203         return result;
1204     }
1205     
1206     
1207 
1208 
1209     function shinyRand(uint16 min, uint16 max) public returns (uint16) {
1210         nonce++;
1211         uint16 result = (uint16(sha3(block.blockhash(block.number-1), nonce ))%max);
1212         
1213         if (result < min)
1214         {
1215             result = result+min;
1216         }
1217         return result;
1218     }
1219     
1220     
1221     
1222     mapping(uint256 => uint8[8]) public baseStats;
1223 
1224     function addBaseStats(uint256 _mId, uint8[8] data) external onlyOwner {
1225         // lock" the stats down forever
1226         // since hp is never going to be 0 this is a valid check
1227         // so we have to be extra careful when adding new baseStats!
1228         require(data[0] > 0);
1229         require(baseStats[_mId][0] == 0);
1230         baseStats[_mId] = data;
1231     }
1232     
1233     function _addBaseStats(uint256 _mId, uint8[8] data) internal {
1234         
1235         
1236         baseStats[_mId] = data;
1237         lockedMonsterStatsCount++;
1238     }
1239 
1240 
1241     
1242 
1243 
1244     
1245     function MonsterCreatorInterface() public {
1246         
1247        // these monsters are already down and "locked" down stats/design wise
1248         _addBaseStats(1, [45, 49, 49, 65, 65, 45, 12, 4]);
1249         _addBaseStats(2, [60, 62, 63, 80, 80, 60, 12, 4]);
1250         _addBaseStats(3, [80, 82, 83, 100, 100, 80, 12, 4]);
1251         _addBaseStats(4, [39, 52, 43, 60, 50, 65, 10, 6]);
1252         _addBaseStats(5, [58, 64, 58, 80, 65, 80, 10, 6]);
1253         _addBaseStats(6, [78, 84, 78, 109, 85, 100, 10, 6]);
1254         _addBaseStats(7, [44, 48, 65, 50, 64, 43, 11, 14]);
1255         _addBaseStats(8, [59, 63, 80, 65, 80, 58, 11, 14]);
1256         _addBaseStats(9, [79, 83, 100, 85, 105, 78, 11, 14]);
1257         _addBaseStats(10, [40, 35, 30, 20, 20, 50, 7, 4]);
1258         
1259         _addBaseStats(149, [55, 50, 45, 135, 95, 120, 8, 14]);
1260         _addBaseStats(150, [91, 134, 95, 100, 100, 80, 2, 5]);
1261         _addBaseStats(151, [100, 100, 100, 100, 100, 100, 5, 19]);
1262     }
1263     
1264     // this serves as a lookup for new monsters to be generated since all monsters 
1265     // of the same id share the base stats
1266     function getMonsterStats( uint256 _mID) external constant returns(uint8[8] stats) {
1267            stats[0] = baseStats[_mID][0];
1268            stats[1] = baseStats[_mID][1];
1269            stats[2] = baseStats[_mID][2];
1270            stats[3] = baseStats[_mID][3];
1271            stats[4] = baseStats[_mID][4];
1272            stats[5] = baseStats[_mID][5];
1273            stats[6] = baseStats[_mID][6];
1274            stats[7] = baseStats[_mID][7];
1275            
1276           
1277 
1278         }
1279 
1280         // generates randomized IVs for a new monster
1281         function getMonsterIVs() external returns(uint8[7] ivs) {
1282 
1283             bool shiny = false;
1284 
1285             uint16 chance = shinyRand(1, 8192);
1286 
1287             if (chance == 42) {
1288                 shiny = true;
1289             }
1290 
1291             // IVs range between 0 and 31
1292             // stat range modified for shiny monsters!
1293             if (shiny == true) {
1294                 ivs[0] = uint8(rand(10, 31));
1295                 ivs[1] = uint8(rand(10, 31));
1296                 ivs[2] = uint8(rand(10, 31));
1297                 ivs[3] = uint8(rand(10, 31));
1298                 ivs[4] = uint8(rand(10, 31));
1299                 ivs[5] = uint8(rand(10, 31));
1300                 ivs[6] = 1;
1301                 
1302             } else {
1303                 ivs[0] = uint8(rand(0, 31));
1304                 ivs[1] = uint8(rand(0, 31));
1305                 ivs[2] = uint8(rand(0, 31));
1306                 ivs[3] = uint8(rand(0, 31));
1307                 ivs[4] = uint8(rand(0, 31));
1308                 ivs[5] = uint8(rand(0, 31));
1309                 ivs[6] = 0;
1310             }
1311 
1312             
1313 
1314         }
1315 
1316 
1317         // gen0 monsters profit from shiny boost while shiny gen0s have potentially even higher IVs!
1318         // further increasing the rarity by also doubling the shiny chance!
1319         function getGen0IVs() external returns (uint8[7] ivs) {
1320             
1321             bool shiny = false;
1322 
1323             uint16 chance = shinyRand(1, 4096);
1324 
1325             if (chance == 42) {
1326                 shiny = true;
1327             }
1328             
1329             if (shiny) {
1330                  ivs[0] = uint8(rand(15, 31));
1331                 ivs[1] = uint8(rand(15, 31));
1332                 ivs[2] = uint8(rand(15, 31));
1333                 ivs[3] = uint8(rand(15, 31));
1334                 ivs[4] = uint8(rand(15, 31));
1335                 ivs[5] = uint8(rand(15, 31));
1336                 ivs[6] = 1;
1337                 
1338             } else {
1339                 ivs[0] = uint8(rand(10, 31));
1340                 ivs[1] = uint8(rand(10, 31));
1341                 ivs[2] = uint8(rand(10, 31));
1342                 ivs[3] = uint8(rand(10, 31));
1343                 ivs[4] = uint8(rand(10, 31));
1344                 ivs[5] = uint8(rand(10, 31));
1345                 ivs[6] = 0;
1346             }
1347             
1348         }
1349         
1350         function withdrawBalance() external onlyOwner {
1351        
1352         uint256 balance = this.balance;
1353        
1354        
1355         owner.transfer(balance);
1356         
1357     }
1358 }
1359 
1360 contract GameLogicContract {
1361     
1362     bool public isGameLogicContract = true;
1363     
1364     function GameLogicContract() public {
1365         
1366     }
1367 }
1368 
1369 contract ChainMonstersCore is ChainMonstersAuction, Ownable {
1370 
1371 
1372    // using a bool to enable us to prepare the game 
1373    bool hasLaunched = false;
1374 
1375 
1376     // this address will hold future gamelogic in place
1377     address gameContract;
1378     
1379 
1380     function ChainMonstersCore() public {
1381 
1382         adminAddress = msg.sender;
1383         
1384 
1385         _createArea(); // area 1
1386         _createArea(); // area 2
1387         
1388     
1389 
1390         
1391     }
1392     
1393     // we don't know the exact interfaces yet so use the lockedMonsterStats value to determine if the game is "ready"
1394     // see WhitePaper for explaination for our upgrade and development roadmap
1395     function setGameLogicContract(address _candidateContract) external onlyOwner {
1396         require(monsterCreator.lockedMonsterStatsCount() == 151);
1397         
1398         require(GameLogicContract(_candidateContract).isGameLogicContract());
1399         gameContract = _candidateContract;
1400     }
1401 
1402     // only callable by gameContract after the full game is launched
1403     // since all additional monsters after the promo/gen0 ones need to use this coreContract
1404     // contract as well we have to prepare this core for our future updates where
1405     // players can freely roam the world and hunt ChainMonsters thus generating more
1406     function spawnMonster(uint256 _mId, address _owner) external {
1407          
1408         require(msg.sender == gameContract);
1409         
1410         uint8[8] memory Stats = uint8[8](monsterCreator.getMonsterStats(uint256(_mId)));
1411         uint8[7] memory IVs = uint8[7](monsterCreator.getMonsterIVs());
1412         
1413         // important to note that the IV generators do not use Gen0 methods and are Generation 1 
1414         // this means there won't be more than the 10,000 Gen0 monsters sold during the development through the marketplace
1415         uint256 monsterId = _createMonster(1, Stats[0], Stats[1], Stats[2], Stats[3], Stats[4], Stats[5], Stats[6], Stats[7], _owner, _mId, true);
1416         monsterIdToTradeable[monsterId] = true;
1417 
1418         monsterIdToIVs[monsterId] = IVs;
1419     }
1420     
1421     
1422     // used to add playable content to the game 
1423     // monsters will only spawn in certain areas so some are locked on release
1424     // due to the game being in active development on "launch"
1425     // each monster has a maximum number of 3 areas where it can appear
1426     // 
1427      function createArea() public onlyAdmin {
1428             _createArea();
1429         }
1430 
1431     function createTrainer(string _username, uint16 _starterId) public {
1432             
1433             require(hasLaunched);
1434 
1435             // only one trainer/account per ethereum address
1436             require(addressToTrainer[msg.sender].owner == 0);
1437            
1438            // valid input check
1439             require(_starterId == 1 || _starterId == 2 || _starterId == 3 );
1440             
1441             uint256 mon = _createTrainer(_username, _starterId, msg.sender);
1442             
1443             // due to stack limitations we have to assign the IVs here:
1444             uint8[7] memory IVs = uint8[7](monsterCreator.getMonsterIVs());
1445             monsterIdToIVs[mon] = IVs;
1446             
1447         }
1448         
1449         
1450     function changeUsername(string _name) public {
1451             require(addressToTrainer[msg.sender].owner == msg.sender);
1452             
1453             
1454             addressToTrainer[msg.sender].username = _name;
1455         }
1456         
1457     function changeMonsterNickname(uint256 _tokenId, string _name) public {
1458             // users won't be able to rename a monster that is part of an auction
1459             require(_owns(msg.sender, _tokenId));
1460             
1461             
1462             // some string checks...?
1463             monsterIdToNickname[_tokenId] = _name;
1464         }
1465 
1466     function moveToArea(uint16 _newArea) public {
1467            
1468             // never allow anyone to move to area 0 or below since this is used
1469             // to determine if a trainer profile exists in another method!
1470             require(_newArea > 0);
1471             
1472             // make sure that this area exists yet!
1473             require(areas.length >= _newArea);
1474              
1475             // when player is not stuck doing something else he can move freely!
1476             _moveToArea(_newArea, msg.sender);
1477         }
1478 
1479     
1480     // to be changed to retrieve current stats!
1481     function getMonster(uint256 _id) external view returns (
1482         uint256 birthTime,
1483         uint256 generation,
1484         uint256 hp,
1485         uint256 attack,
1486         uint256 defense,
1487         uint256 spAttack,
1488         uint256 spDefense,
1489         uint256 speed,
1490         uint256 typeOne,
1491         uint256 typeTwo,
1492         
1493         uint256 mID,
1494         bool tradeable, 
1495         uint256 uID
1496         
1497             
1498         ) {    
1499        Monster storage mon = monsters[_id];
1500         birthTime = uint256(mon.birthTime);
1501         generation = 0; // hardcoding due to stack too deep error
1502         hp = uint256(mon.hp);
1503         attack = uint256(mon.attack);
1504         defense = uint256(mon.defense);
1505         spAttack = uint256(mon.spAttack);
1506         spDefense = uint256(mon.spDefense);
1507         speed = uint256(mon.speed);
1508         typeOne = uint256(mon.typeOne);
1509         typeTwo = uint256(mon.typeTwo);
1510         mID = uint256(mon.mID);
1511         tradeable = bool(mon.tradeable);
1512         
1513         // hack to overcome solidity's stack limitation in monster struct....
1514         uID = _id;
1515             
1516         }
1517         
1518         // this method only returns the "base" powerlevel of a monster which will be used
1519         // in more advanced fighting calculations later on
1520     function getMonsterPowerLevel(uint256 _tokenId) external view returns (
1521             uint256 powerlevel
1522         ) {
1523             Monster storage mon = monsters[_tokenId];
1524             uint8[7] storage IVs = monsterIdToIVs[_tokenId];
1525 
1526             
1527             powerlevel = mon.hp + IVs[0] + mon.attack + IVs[1] + mon.defense + IVs[2] + mon.spAttack + IVs[3] + mon.spDefense + IVs[4] + mon.speed + IVs[5];
1528         }
1529         
1530         
1531         
1532 
1533    
1534     
1535     function isTrainer(address _check)
1536     external 
1537     view 
1538     returns (
1539         bool isTrainer
1540     ) {
1541         Trainer storage trainer = addressToTrainer[_check];
1542 
1543         if (trainer.currArea > 0)
1544             return true;
1545         else
1546             return false;
1547     }
1548    
1549 
1550     
1551    
1552    
1553     function withdrawBalance() external onlyOwner {
1554        
1555         uint256 balance = this.balance;
1556        
1557        
1558         owner.transfer(balance);
1559         
1560     }
1561 
1562     // after we have setup everything we can unlock the game
1563     // for public
1564     function launchGame() external onlyOwner {
1565         hasLaunched = true;
1566     }
1567 }