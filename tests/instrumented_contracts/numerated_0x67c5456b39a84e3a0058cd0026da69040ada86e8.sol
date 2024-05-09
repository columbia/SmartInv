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
345             
346             // starter stats are hardcoded!
347             if (_starterId == 1) {
348                 uint8[8] memory Stats = uint8[8](monsterCreator.getMonsterStats(1));
349                 mon = _createMonster(0, Stats[0], Stats[1], Stats[2], Stats[3], Stats[4], Stats[5], Stats[6], Stats[7], _owner, 1, false);
350                
351             } else if (_starterId == 2) {
352                 uint8[8] memory Stats2 = uint8[8](monsterCreator.getMonsterStats(4));
353                 mon = _createMonster(0, Stats2[0], Stats2[1], Stats2[2], Stats2[3], Stats2[4], Stats2[5], Stats2[6], Stats2[7], _owner, 4, false);
354                 
355             } else if (_starterId == 3) {
356                 uint8[8] memory Stats3 = uint8[8](monsterCreator.getMonsterStats(7));
357                 mon = _createMonster(0, Stats3[0], Stats3[1], Stats3[2], Stats3[3], Stats3[4], Stats3[5], Stats3[6], Stats3[7], _owner, 7, false);
358                 
359             }
360             
361         }
362 
363 
364     function _moveToArea(uint16 _newArea, address player) internal {
365             
366             addressToTrainer[player].currArea = _newArea;
367           
368         }   
369         
370     
371      
372 
373     
374     // assigns ownership of monster to address
375     function _transfer(address _from, address _to, uint256 _tokenId) internal {
376         ownershipTokenCount[_to]++;
377         monsterIndexToOwner[_tokenId] = _to;
378 
379         if (_from != address(0)) {
380             ownershipTokenCount[_from]--;
381 
382             // clear any previously approved ownership exchange
383             delete monsterIndexToApproved[_tokenId];
384         }
385 
386         // Emit Transfer event
387         Transfer(_from, _to, _tokenId);
388     }
389 
390 
391     // Only admin can fix how many seconds per blocks are currently observed.
392     function setSecondsPerBlock(uint256 secs) external onlyAdmin {
393         //require(secs < cooldowns[0]);
394         secondsPerBlock = secs;
395     }
396 
397 
398     
399 
400 
401 }
402 
403 /// @title The external contract that is responsible for generating metadata for the monsters,
404 ///  it has one function that will return the data as bytes.
405 contract ERC721Metadata {
406     /// @dev Given a token Id, returns a byte array that is supposed to be converted into string.
407     function getMetadata(uint256 _tokenId, string) public view returns (bytes32[4] buffer, uint256 count) {
408         if (_tokenId == 1) {
409             buffer[0] = "Hello World! :D";
410             count = 15;
411         } else if (_tokenId == 2) {
412             buffer[0] = "I would definitely choose a medi";
413             buffer[1] = "um length string.";
414             count = 49;
415         } else if (_tokenId == 3) {
416             buffer[0] = "Lorem ipsum dolor sit amet, mi e";
417             buffer[1] = "st accumsan dapibus augue lorem,";
418             buffer[2] = " tristique vestibulum id, libero";
419             buffer[3] = " suscipit varius sapien aliquam.";
420             count = 128;
421         }
422     }
423 }
424 
425 
426 contract MonsterOwnership is MonstersBase, ERC721 {
427 
428     string public constant name = "ChainMonsters";
429     string public constant symbol = "CHMO";
430 
431 
432     // The contract that will return monster metadata
433     ERC721Metadata public erc721Metadata;
434 
435     bytes4 constant InterfaceSignature_ERC165 =
436         bytes4(keccak256('supportsInterface(bytes4)'));
437 
438 
439 
440 
441     bytes4 constant InterfaceSignature_ERC721 =
442         bytes4(keccak256('name()')) ^
443         bytes4(keccak256('symbol()')) ^
444         bytes4(keccak256('totalSupply()')) ^
445         bytes4(keccak256('balanceOf(address)')) ^
446         bytes4(keccak256('ownerOf(uint256)')) ^
447         bytes4(keccak256('approve(address,uint256)')) ^
448         bytes4(keccak256('transfer(address,uint256)')) ^
449         bytes4(keccak256('transferFrom(address,address,uint256)')) ^
450         bytes4(keccak256('tokensOfOwner(address)')) ^
451         bytes4(keccak256('tokenMetadata(uint256,string)'));
452 
453 
454 
455 
456     function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
457         // DEBUG ONLY
458         //require((InterfaceSignature_ERC165 == 0x01ffc9a7) && (InterfaceSignature_ERC721 == 0x9a20483d));
459 
460         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
461     }
462 
463     /// @dev Set the address of the sibling contract that tracks metadata.
464     ///  CEO only.
465     function setMetadataAddress(address _contractAddress) public onlyAdmin {
466         erc721Metadata = ERC721Metadata(_contractAddress);
467     }
468 
469     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
470         return monsterIndexToOwner[_tokenId] == _claimant;
471     }
472     
473     function _isTradeable(uint256 _tokenId) external view returns (bool) {
474         return monsterIdToTradeable[_tokenId];
475     }
476     
477     
478     /// @dev Checks if a given address currently has transferApproval for a particular monster.
479     /// @param _claimant the address we are confirming monster is approved for.
480     /// @param _tokenId monster id, only valid when > 0
481     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
482         return monsterIndexToApproved[_tokenId] == _claimant;
483     }
484 
485     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
486     ///  approval. Setting _approved to address(0) clears all transfer approval.
487     ///  NOTE: _approve() does NOT send the Approval event. This is intentional because
488     ///  _approve() and transferFrom() are used together for putting monsters on auction, and
489     ///  there is no value in spamming the log with Approval events in that case.
490     function _approve(uint256 _tokenId, address _approved) internal {
491         monsterIndexToApproved[_tokenId] = _approved;
492     }
493     
494     
495     function balanceOf(address _owner) public view returns (uint256 count) {
496         return ownershipTokenCount[_owner];
497     }
498 
499 
500     function transfer (address _to, uint256 _tokenId) external {
501         // Safety check to prevent against an unexpected 0x0 default.
502         require(_to != address(0));
503         // Disallow transfers to this contract to prevent accidental misuse.
504         // The contract should never own any monsters (except very briefly
505         // after a gen0 monster is created and before it goes on auction).
506         require(_to != address(this));
507         
508 
509         // You can only send your own monster.
510         require(_owns(msg.sender, _tokenId));
511 
512         // Reassign ownership, clear pending approvals, emit Transfer event.
513         _transfer(msg.sender, _to, _tokenId);
514     }
515 
516     
517     
518 
519 /// @notice Grant another address the right to transfer a specific monster via
520     ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
521     /// @param _to The address to be granted transfer approval. Pass address(0) to
522     ///  clear all approvals.
523     /// @param _tokenId The ID of the monster that can be transferred if this call succeeds.
524     /// @dev Required for ERC-721 compliance.
525     function approve(address _to, uint256 _tokenId ) external {
526         // Only an owner can grant transfer approval.
527         require(_owns(msg.sender, _tokenId));
528 
529         // Register the approval (replacing any previous approval).
530         _approve(_tokenId, _to);
531 
532         // Emit approval event.
533         Approval(msg.sender, _to, _tokenId);
534     }
535 
536     /// @notice Transfer a monster owned by another address, for which the calling address
537     ///  has previously been granted transfer approval by the owner.
538     /// @param _from The address that owns the monster to be transfered.
539     /// @param _to The address that should take ownership of the monster. Can be any address,
540     ///  including the caller.
541     /// @param _tokenId The ID of the monster to be transferred.
542     /// @dev Required for ERC-721 compliance.
543     function transferFrom (address _from, address _to, uint256 _tokenId ) external {
544         // Safety check to prevent against an unexpected 0x0 default.
545         require(_to != address(0));
546         // Disallow transfers to this contract to prevent accidental misuse.
547         // The contract should never own any monsters (except very briefly
548         // after a gen0 monster is created and before it goes on auction).
549         require(_to != address(this));
550         // Check for approval and valid ownership
551         //require(_approvedFor(msg.sender, _tokenId));
552         require(_owns(_from, _tokenId));
553 
554         // Reassign ownership (also clears pending approvals and emits Transfer event).
555         _transfer(_from, _to, _tokenId);
556     }
557 
558     function totalSupply() public view returns (uint) {
559         return monsters.length;
560     }
561 
562 
563     function ownerOf(uint256 _tokenId)
564             external
565             view
566             returns (address owner)
567         {
568             owner = monsterIndexToOwner[_tokenId];
569 
570             require(owner != address(0));
571         }
572 
573      function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
574         uint256 tokenCount = balanceOf(_owner);
575 
576         if (tokenCount == 0) {
577             // Return an empty array
578             return new uint256[](0);
579         } else {
580             uint256[] memory result = new uint256[](tokenCount);
581             uint256 totalMonsters = totalSupply();
582             uint256 resultIndex = 0;
583 
584             
585             uint256 monsterId;
586 
587             for (monsterId = 0; monsterId <= totalMonsters; monsterId++) {
588                 if (monsterIndexToOwner[monsterId] == _owner) {
589                     result[resultIndex] = monsterId;
590                     resultIndex++;
591                 }
592             }
593 
594             return result;
595         }
596     }
597 
598 
599    
600 
601     /// @dev Adapted from memcpy() by @arachnid (Nick Johnson <arachnid@notdot.net>)
602     ///  This method is licenced under the Apache License.
603     ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
604     function _memcpy(uint _dest, uint _src, uint _len) private view {
605         // Copy word-length chunks while possible
606         for(; _len >= 32; _len -= 32) {
607             assembly {
608                 mstore(_dest, mload(_src))
609             }
610             _dest += 32;
611             _src += 32;
612         }
613 
614         // Copy remaining bytes
615         uint256 mask = 256 ** (32 - _len) - 1;
616         assembly {
617             let srcpart := and(mload(_src), not(mask))
618             let destpart := and(mload(_dest), mask)
619             mstore(_dest, or(destpart, srcpart))
620         }
621     }
622 
623     /// @dev Adapted from toString(slice) by @arachnid (Nick Johnson <arachnid@notdot.net>)
624     ///  This method is licenced under the Apache License.
625     ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
626     function _toString(bytes32[4] _rawBytes, uint256 _stringLength) private view returns (string) {
627         var outputString = new string(_stringLength);
628         uint256 outputPtr;
629         uint256 bytesPtr;
630 
631         assembly {
632             outputPtr := add(outputString, 32)
633             bytesPtr := _rawBytes
634         }
635 
636         _memcpy(outputPtr, bytesPtr, _stringLength);
637 
638         return outputString;
639     }
640 
641     /// @notice Returns a URI pointing to a metadata package for this token conforming to
642     ///  ERC-721 (https://github.com/ethereum/EIPs/issues/721)
643     /// @param _tokenId The ID number of the monster whose metadata should be returned.
644     function tokenMetadata(uint256 _tokenId, string _preferredTransport) external view returns (string infoUrl) {
645         require(erc721Metadata != address(0));
646         bytes32[4] memory buffer;
647         uint256 count;
648         (buffer, count) = erc721Metadata.getMetadata(_tokenId, _preferredTransport);
649 
650         return _toString(buffer, count);
651     }
652 
653 }
654 
655 contract MonsterAuctionBase {
656     
657     
658     // Reference to contract tracking NFT ownership
659     ERC721 public nonFungibleContract;
660     ChainMonstersCore public core;
661     
662     struct Auction {
663 
664         // current owner
665         address seller;
666 
667         // price in wei
668         uint256 price;
669 
670         // time when auction started
671         uint64 startedAt;
672 
673         uint256 id;
674     }
675 
676   
677 
678     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
679     // Values 0-10,000 map to 0%-100%
680     uint256 public ownerCut;
681 
682     // Map from token ID to their corresponding auction.
683     mapping(uint256 => Auction) tokenIdToAuction;
684 
685     mapping(uint256 => address) public auctionIdToSeller;
686     
687     mapping (address => uint256) public ownershipAuctionCount;
688 
689 
690     event AuctionCreated(uint256 tokenId, uint256 price, uint256 uID, address seller);
691     event AuctionSuccessful(uint256 tokenId, uint256 price, address newOwner, uint256 uID);
692     event AuctionCancelled(uint256 tokenId, uint256 uID);
693 
694 
695     function _transfer(address _receiver, uint256 _tokenId) internal {
696         // it will throw if transfer fails
697         nonFungibleContract.transfer(_receiver, _tokenId);
698     }
699 
700 
701     function _addAuction(uint256 _tokenId, Auction _auction) internal {
702         
703         tokenIdToAuction[_tokenId] = _auction;
704 
705         AuctionCreated(
706             uint256(_tokenId),
707             uint256(_auction.price),
708             uint256(_auction.id),
709             address(_auction.seller)
710         );
711        
712     }
713 
714 
715     function _cancelAuction(uint256 _tokenId, address _seller) internal {
716         
717         Auction storage _auction = tokenIdToAuction[_tokenId];
718 
719         uint256 uID = _auction.id;
720         
721         _removeAuction(_tokenId);
722         ownershipAuctionCount[_seller]--;
723         _transfer(_seller, _tokenId);
724         
725         AuctionCancelled(_tokenId, uID);
726     }
727 
728 
729     function _buy(uint256 _tokenId, uint256 _bidAmount)
730         internal
731         returns (uint256)
732         {
733             Auction storage auction = tokenIdToAuction[_tokenId];
734         
735 
736         require(_isOnAuction(auction));
737 
738         uint256 price = auction.price;
739         require(_bidAmount >= price);
740 
741         address seller = auction.seller;
742 
743         uint256 uID = auction.id;
744         // Auction Bid looks fine! so remove
745         _removeAuction(_tokenId);
746         ownershipAuctionCount[seller]--;
747 
748         if (price > 0) {
749 
750             uint256 auctioneerCut = _computeCut(price);
751             uint256 sellerProceeds = price - auctioneerCut;
752 
753             // NOTE: Doing a transfer() in the middle of a complex
754             // method like this is generally discouraged because of
755             // reentrancy attacks and DoS attacks if the seller is
756             // a contract with an invalid fallback function. We explicitly
757             // guard against reentrancy attacks by removing the auction
758             // before calling transfer(), and the only thing the seller
759             // can DoS is the sale of their own asset! (And if it's an
760             // accident, they can call cancelAuction(). )
761             if(seller != address(core)) {
762                 seller.transfer(sellerProceeds);
763             }
764         }
765 
766         // Calculate any excess funds included with the bid. If the excess
767         // is anything worth worrying about, transfer it back to bidder.
768         // NOTE: We checked above that the bid amount is greater than or
769         // equal to the price so this cannot underflow.
770         uint256 bidExcess = _bidAmount - price;
771 
772         // Return the funds. Similar to the previous transfer, this is
773         // not susceptible to a re-entry attack because the auction is
774         // removed before any transfers occur.
775         msg.sender.transfer(bidExcess);
776 
777         // Tell the world!
778         AuctionSuccessful(_tokenId, price, msg.sender, uID);
779 
780         return price;
781 
782 
783     }
784 
785     function _removeAuction(uint256 _tokenId) internal {
786         delete tokenIdToAuction[_tokenId];
787     }
788 
789     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
790         return (_auction.startedAt > 0);
791     }
792 
793      function _computeCut(uint256 _price) internal view returns (uint256) {
794         // NOTE: We don't use SafeMath (or similar) in this function because
795         //  all of our entry functions carefully cap the maximum values for
796         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
797         //  statement in the ClockAuction constructor). The result of this
798         //  function is always guaranteed to be <= _price.
799         return _price * ownerCut / 10000;
800     }
801 
802     
803 
804 }
805 
806 
807 contract MonsterAuction is  MonsterAuctionBase, Ownable {
808 
809 
810     bool public isMonsterAuction = true;
811      uint256 public auctionIndex = 0;
812 
813     /// @dev The ERC-165 interface signature for ERC-721.
814     ///  Ref: https://github.com/ethereum/EIPs/issues/165
815     ///  Ref: https://github.com/ethereum/EIPs/issues/721
816     bytes4 constant InterfaceSignature_ERC721 = bytes4(0x9a20483d);
817 
818     function MonsterAuction(address _nftAddress, uint256 _cut) public {
819         require(_cut <= 10000);
820         ownerCut = _cut;
821 
822         ERC721 candidateContract = ERC721(_nftAddress);
823         
824         nonFungibleContract = candidateContract;
825         ChainMonstersCore candidateCoreContract = ChainMonstersCore(_nftAddress);
826         core = candidateCoreContract;
827 
828         
829     }
830     
831     // only possible to decrease ownerCut!
832     function setOwnerCut(uint256 _cut) external onlyOwner {
833         require(_cut <= ownerCut);
834         ownerCut = _cut;
835     }
836     
837     
838     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
839         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
840     }
841     
842     function _escrow(address _owner, uint256 _tokenId) internal {
843         // it will throw if transfer fails
844         nonFungibleContract.transferFrom(_owner, this, _tokenId);
845     }
846 
847     function withdrawBalance() external onlyOwner {
848        
849        
850        uint256 balance = this.balance;
851        
852        
853         owner.transfer(balance);
854 
855         
856        
857     }
858 
859     
860     function tokensInAuctionsOfOwner(address _owner) external view returns(uint256[] auctionTokens) {
861         
862            uint256 numAuctions = ownershipAuctionCount[_owner];
863 
864             
865         
866             uint256[] memory result = new uint256[](numAuctions);
867             uint256 totalAuctions = core.totalSupply();
868             uint256 resultIndex = 0;
869 
870             
871             uint256 auctionId;
872 
873             for (auctionId = 0; auctionId <= totalAuctions; auctionId++) {
874                 
875                 Auction storage auction = tokenIdToAuction[auctionId];
876                 if (auction.seller == _owner) {
877                     
878                     result[resultIndex] = auctionId;
879                     resultIndex++;
880                 }
881             }
882 
883             return result;
884         
885         
886     }
887 
888 
889 
890 
891     function createAuction(uint256 _tokenId, uint256 _price, address _seller) external {
892              require(_price == uint256(_price));
893             require(core._isTradeable(_tokenId));
894              require(_owns(msg.sender, _tokenId));
895              _escrow(msg.sender, _tokenId);
896 
897             
898 
899             
900              Auction memory auction = Auction(
901                  _seller,
902                  uint256(_price),
903                  uint64(now),
904                  uint256(auctionIndex)
905              );
906 
907             auctionIdToSeller[auctionIndex] = _seller;
908             ownershipAuctionCount[_seller]++;
909             
910              auctionIndex++;
911              _addAuction(_tokenId, auction);
912         }
913 
914     function buy(uint256 _tokenId) external payable {
915             //delete auctionIdToSeller[_tokenId];
916             // buy will throw if the bid or funds transfer fails
917             _buy (_tokenId, msg.value);
918             _transfer(msg.sender, _tokenId);
919             
920             
921         }
922 
923     
924     function cancelAuction(uint256 _tokenId) external {
925             Auction storage auction = tokenIdToAuction[_tokenId];
926             require(_isOnAuction(auction));
927 
928             address seller = auction.seller;
929             require(msg.sender == seller);
930             
931             
932             _cancelAuction(_tokenId, seller);
933         }
934 
935     
936     function getAuction(uint256 _tokenId)
937         external
938         view
939         returns
940         (
941             address seller,
942             uint256 price,
943             uint256 startedAt
944         ) {
945             Auction storage auction = tokenIdToAuction[_tokenId];
946             require(_isOnAuction(auction));
947 
948             return (
949                 auction.seller,
950                 auction.price,
951                 auction.startedAt
952             );
953         }
954 
955 
956     function getPrice(uint256 _tokenId)
957         external
958         view
959         returns (uint256)
960         {
961             Auction storage auction = tokenIdToAuction[_tokenId];
962             require(_isOnAuction(auction));
963             return auction.price;
964         }
965 }
966 
967 
968 contract ChainMonstersAuction is MonsterOwnership {
969 
970   
971 
972 
973     function setMonsterAuctionAddress(address _address) external onlyAdmin {
974         MonsterAuction candidateContract = MonsterAuction(_address);
975 
976         require(candidateContract.isMonsterAuction());
977 
978         monsterAuction = candidateContract;
979     }
980 
981 
982 
983     uint256 public constant PROMO_CREATION_LIMIT = 5000;
984 
985     uint256 public constant GEN0_CREATION_LIMIT = 5000;
986 
987     // Counts the number of monster the contract owner has created.
988     uint256 public promoCreatedCount;
989     uint256 public gen0CreatedCount;
990 
991 
992     
993     // its stats are completely dependent on the spawn alghorithm
994     function createPromoMonster(uint256 _mId, address _owner) external onlyAdmin {
995        
996 
997        // during generation we have to keep in mind that we have only 10,000 tokens available
998        // which have to be divided by 151 monsters, some rarer than others
999        // see WhitePaper for gen0/promo monster plan
1000         
1001         require(promoCreatedCount < PROMO_CREATION_LIMIT);
1002 
1003         promoCreatedCount++;
1004         uint8[8] memory Stats = uint8[8](monsterCreator.getMonsterStats(uint256(_mId)));
1005         uint8[7] memory IVs = uint8[7](monsterCreator.getGen0IVs());
1006         
1007         uint256 monsterId = _createMonster(0, Stats[0], Stats[1], Stats[2], Stats[3], Stats[4], Stats[5], Stats[6], Stats[7], _owner, _mId, true);
1008         monsterIdToTradeable[monsterId] = true;
1009 
1010         monsterIdToIVs[monsterId] = IVs;
1011         
1012        
1013     }
1014 
1015    
1016 
1017 
1018     function createGen0Auction(uint256 _mId, uint256 price) external onlyAdmin {
1019         require(gen0CreatedCount < GEN0_CREATION_LIMIT);
1020 
1021         uint8[8] memory Stats = uint8[8](monsterCreator.getMonsterStats(uint256(_mId)));
1022         uint8[7] memory IVs = uint8[7](monsterCreator.getGen0IVs());
1023         uint256 monsterId = _createMonster(0, Stats[0], Stats[1], Stats[2], Stats[3], Stats[4], Stats[5], Stats[6], Stats[7], this, _mId, true);
1024         monsterIdToTradeable[monsterId] = true;
1025 
1026         monsterIdToIVs[monsterId] = IVs;
1027 
1028         monsterAuction.createAuction(monsterId, price, address(this));
1029 
1030 
1031         gen0CreatedCount++;
1032         
1033     }
1034 
1035     
1036 }
1037 
1038 
1039 // used during launch for world championship
1040 // can and will be upgraded during development with new battle system!
1041 // this is just to give players something to do and test their monsters
1042 // also demonstrates how we can build up more mechanics on top of our locked core contract!
1043 contract MonsterChampionship is Ownable {
1044 
1045     bool public isMonsterChampionship = true;
1046     
1047     ChainMonstersCore core;
1048     
1049     // list of top ten 
1050     address[10] topTen;
1051 
1052     // holds the address current "world" champion
1053     address public currChampion;
1054     
1055     
1056     mapping (address => uint256) public addressToPowerlevel;
1057     mapping (uint256 => address) public rankToAddress;
1058     
1059 
1060    
1061     
1062     
1063      // try to beat every other player in the top10 with your strongest monster!
1064     // effectively looping through all top10 players, beating them one by one 
1065     // and if strong enough placing your in the top10 as well
1066     function contestChampion(uint256 _tokenId) external {
1067             uint maxIndex = 9;
1068             
1069            
1070             
1071            
1072             
1073             // fail tx if player is already champion!
1074             // in theory players could increase their powerlevel by contesting themselves but
1075             // this check stops that from happening so other players have the chance to
1076             // become the temporary champion!
1077             if (currChampion == msg.sender)
1078                 revert();
1079                 
1080             
1081            require(core.isTrainer(msg.sender));        
1082            require(core.monsterIndexToOwner(_tokenId) == msg.sender);
1083             
1084            
1085            uint myPowerlevel = core.getMonsterPowerLevel(_tokenId);
1086 
1087            
1088            // checks if this transaction is useless
1089            // since we can't fight against ourself!
1090            // also stops reentrancy attacks
1091            require(myPowerlevel > addressToPowerlevel[msg.sender]);
1092            
1093           
1094            uint myRank = 0;
1095             
1096             for (uint i=0; i<=maxIndex; i++) {
1097                 //if (addres)
1098                 if ( myPowerlevel > addressToPowerlevel[topTen[i]] ) {
1099                     // you have beaten this one so increase temporary rank
1100                     myRank = i;
1101                     
1102                     if (myRank == maxIndex) {
1103                         currChampion = msg.sender;
1104                     }
1105                     
1106                     
1107                     
1108                     
1109                 }
1110                
1111                 
1112                 
1113                
1114                
1115             }
1116             
1117             addressToPowerlevel[msg.sender] = myPowerlevel;
1118             
1119             address[10] storage newTopTen = topTen;
1120             
1121             if (currChampion == msg.sender) {
1122                 for (uint j=0; j<maxIndex; j++) {
1123                     // remove ourselves from this list in case 
1124                     if (newTopTen[j] == msg.sender) {
1125                         newTopTen[j] = 0x0;
1126                         break;
1127                     }
1128                     
1129                 }
1130             }
1131             
1132             
1133             for (uint x=0; x<=myRank; x++) {
1134                 if (x == myRank) {
1135                     
1136                    
1137                     newTopTen[x] = msg.sender;
1138                 } else {
1139                     if (x < maxIndex)
1140                         newTopTen[x] = topTen[x+1];    
1141                 }
1142                 
1143                 
1144             }
1145             
1146             
1147             topTen = newTopTen;
1148             
1149         }
1150     
1151     
1152     
1153     function getTopPlayers()
1154         external
1155         view
1156         returns (
1157             address[10] players
1158         ) {
1159             players = topTen;
1160         }
1161     
1162 
1163 
1164 
1165     
1166     
1167     
1168     
1169     function MonsterChampionship(address coreContract) public {
1170        core = ChainMonstersCore(coreContract);
1171     }
1172     
1173     function withdrawBalance() external onlyOwner {
1174        
1175         uint256 balance = this.balance;
1176        
1177        
1178         owner.transfer(balance);
1179         
1180     }
1181 
1182 
1183 
1184 
1185 }
1186 
1187 
1188 // where the not-so-much "hidden" magic happens
1189 contract MonsterCreatorInterface is Ownable {
1190 
1191     uint8 public lockedMonsterStatsCount = 0;
1192     uint nonce = 0;
1193 
1194     function rand(uint8 min, uint8 max) public returns (uint8) {
1195         nonce++;
1196         uint8 result = (uint8(sha3(block.blockhash(block.number-1), nonce ))%max);
1197         
1198         if (result < min)
1199         {
1200             result = result+min;
1201         }
1202         return result;
1203     }
1204     
1205     
1206 
1207 
1208     function shinyRand(uint16 min, uint16 max) public returns (uint16) {
1209         nonce++;
1210         uint16 result = (uint16(sha3(block.blockhash(block.number-1), nonce ))%max);
1211         
1212         if (result < min)
1213         {
1214             result = result+min;
1215         }
1216         return result;
1217     }
1218     
1219     
1220     
1221     mapping(uint256 => uint8[8]) public baseStats;
1222 
1223     function addBaseStats(uint256 _mId, uint8[8] data) external onlyOwner {
1224         // lock" the stats down forever
1225         // since hp is never going to be 0 this is a valid check
1226         // so we have to be extra careful when adding new baseStats!
1227         require(data[0] > 0);
1228         require(baseStats[_mId][0] == 0);
1229         baseStats[_mId] = data;
1230     }
1231     
1232     function _addBaseStats(uint256 _mId, uint8[8] data) internal {
1233         
1234         
1235         baseStats[_mId] = data;
1236         lockedMonsterStatsCount++;
1237     }
1238 
1239 
1240     
1241 
1242 
1243     
1244     function MonsterCreatorInterface() public {
1245         
1246        // these monsters are already down and "locked" down stats/design wise
1247         _addBaseStats(1, [45, 49, 49, 65, 65, 45, 12, 4]);
1248         _addBaseStats(2, [60, 62, 63, 80, 80, 60, 12, 4]);
1249         _addBaseStats(3, [80, 82, 83, 100, 100, 80, 12, 4]);
1250         _addBaseStats(4, [39, 52, 43, 60, 50, 65, 10, 6]);
1251         _addBaseStats(5, [58, 64, 58, 80, 65, 80, 10, 6]);
1252         _addBaseStats(6, [78, 84, 78, 109, 85, 100, 10, 6]);
1253         _addBaseStats(7, [44, 48, 65, 50, 64, 43, 11, 14]);
1254         _addBaseStats(8, [59, 63, 80, 65, 80, 58, 11, 14]);
1255         _addBaseStats(9, [79, 83, 100, 85, 105, 78, 11, 14]);
1256         _addBaseStats(10, [40, 35, 30, 20, 20, 50, 7, 4]);
1257         
1258         _addBaseStats(149, [55, 50, 45, 135, 95, 120, 8, 14]);
1259         _addBaseStats(150, [91, 134, 95, 100, 100, 80, 2, 5]);
1260         _addBaseStats(151, [100, 100, 100, 100, 100, 100, 5, 19]);
1261     }
1262     
1263     // this serves as a lookup for new monsters to be generated since all monsters 
1264     // of the same id share the base stats
1265     function getMonsterStats( uint256 _mID) external constant returns(uint8[8] stats) {
1266            stats[0] = baseStats[_mID][0];
1267            stats[1] = baseStats[_mID][1];
1268            stats[2] = baseStats[_mID][2];
1269            stats[3] = baseStats[_mID][3];
1270            stats[4] = baseStats[_mID][4];
1271            stats[5] = baseStats[_mID][5];
1272            stats[6] = baseStats[_mID][6];
1273            stats[7] = baseStats[_mID][7];
1274            
1275           
1276 
1277         }
1278 
1279         // generates randomized IVs for a new monster
1280         function getMonsterIVs() external returns(uint8[7] ivs) {
1281 
1282             bool shiny = false;
1283 
1284             uint16 chance = shinyRand(1, 8192);
1285 
1286             if (chance == 42) {
1287                 shiny = true;
1288             }
1289 
1290             // IVs range between 0 and 31
1291             // stat range modified for shiny monsters!
1292             if (shiny == true) {
1293                 ivs[0] = uint8(rand(10, 31));
1294                 ivs[1] = uint8(rand(10, 31));
1295                 ivs[2] = uint8(rand(10, 31));
1296                 ivs[3] = uint8(rand(10, 31));
1297                 ivs[4] = uint8(rand(10, 31));
1298                 ivs[5] = uint8(rand(10, 31));
1299                 ivs[6] = 1;
1300                 
1301             } else {
1302                 ivs[0] = uint8(rand(0, 31));
1303                 ivs[1] = uint8(rand(0, 31));
1304                 ivs[2] = uint8(rand(0, 31));
1305                 ivs[3] = uint8(rand(0, 31));
1306                 ivs[4] = uint8(rand(0, 31));
1307                 ivs[5] = uint8(rand(0, 31));
1308                 ivs[6] = 0;
1309             }
1310 
1311             
1312 
1313         }
1314 
1315 
1316         // gen0 monsters profit from shiny boost while shiny gen0s have potentially even higher IVs!
1317         // further increasing the rarity by also doubling the shiny chance!
1318         function getGen0IVs() external returns (uint8[7] ivs) {
1319             
1320             bool shiny = false;
1321 
1322             uint16 chance = shinyRand(1, 4096);
1323 
1324             if (chance == 42) {
1325                 shiny = true;
1326             }
1327             
1328             if (shiny) {
1329                  ivs[0] = uint8(rand(15, 31));
1330                 ivs[1] = uint8(rand(15, 31));
1331                 ivs[2] = uint8(rand(15, 31));
1332                 ivs[3] = uint8(rand(15, 31));
1333                 ivs[4] = uint8(rand(15, 31));
1334                 ivs[5] = uint8(rand(15, 31));
1335                 ivs[6] = 1;
1336                 
1337             } else {
1338                 ivs[0] = uint8(rand(10, 31));
1339                 ivs[1] = uint8(rand(10, 31));
1340                 ivs[2] = uint8(rand(10, 31));
1341                 ivs[3] = uint8(rand(10, 31));
1342                 ivs[4] = uint8(rand(10, 31));
1343                 ivs[5] = uint8(rand(10, 31));
1344                 ivs[6] = 0;
1345             }
1346             
1347         }
1348         
1349         function withdrawBalance() external onlyOwner {
1350        
1351         uint256 balance = this.balance;
1352        
1353        
1354         owner.transfer(balance);
1355         
1356     }
1357 }
1358 
1359 contract GameLogicContract {
1360     
1361     bool public isGameLogicContract = true;
1362     
1363     function GameLogicContract() public {
1364         
1365     }
1366 }
1367 
1368 contract ChainMonstersCore is ChainMonstersAuction, Ownable {
1369 
1370 
1371    // using a bool to enable us to prepare the game 
1372    bool hasLaunched = false;
1373 
1374 
1375     // this address will hold future gamelogic in place
1376     address gameContract;
1377     
1378 
1379     function ChainMonstersCore() public {
1380 
1381         adminAddress = msg.sender;
1382         
1383 
1384         _createArea(); // area 1
1385         _createArea(); // area 2
1386         
1387     
1388 
1389         
1390     }
1391     
1392     // we don't know the exact interfaces yet so use the lockedMonsterStats value to determine if the game is "ready"
1393     // see WhitePaper for explaination for our upgrade and development roadmap
1394     function setGameLogicContract(address _candidateContract) external onlyOwner {
1395         require(monsterCreator.lockedMonsterStatsCount() == 151);
1396         
1397         require(GameLogicContract(_candidateContract).isGameLogicContract());
1398         gameContract = _candidateContract;
1399     }
1400 
1401     // only callable by gameContract after the full game is launched
1402     // since all additional monsters after the promo/gen0 ones need to use this coreContract
1403     // contract as well we have to prepare this core for our future updates where
1404     // players can freely roam the world and hunt ChainMonsters thus generating more
1405     function spawnMonster(uint256 _mId, address _owner) external {
1406          
1407         require(msg.sender == gameContract);
1408         
1409         uint8[8] memory Stats = uint8[8](monsterCreator.getMonsterStats(uint256(_mId)));
1410         uint8[7] memory IVs = uint8[7](monsterCreator.getMonsterIVs());
1411         
1412         // important to note that the IV generators do not use Gen0 methods and are Generation 1 
1413         // this means there won't be more than the 10,000 Gen0 monsters sold during the development through the marketplace
1414         uint256 monsterId = _createMonster(1, Stats[0], Stats[1], Stats[2], Stats[3], Stats[4], Stats[5], Stats[6], Stats[7], _owner, _mId, true);
1415         monsterIdToTradeable[monsterId] = true;
1416 
1417         monsterIdToIVs[monsterId] = IVs;
1418     }
1419     
1420     
1421     // used to add playable content to the game 
1422     // monsters will only spawn in certain areas so some are locked on release
1423     // due to the game being in active development on "launch"
1424     // each monster has a maximum number of 3 areas where it can appear
1425     // 
1426      function createArea() public onlyAdmin {
1427             _createArea();
1428         }
1429 
1430     function createTrainer(string _username, uint16 _starterId) public {
1431             
1432             require(hasLaunched);
1433 
1434             // only one trainer/account per ethereum address
1435             require(addressToTrainer[msg.sender].owner == 0);
1436            
1437            // valid input check
1438             require(_starterId == 1 || _starterId == 2 || _starterId == 3 );
1439             
1440             uint256 mon = _createTrainer(_username, _starterId, msg.sender);
1441             
1442             // due to stack limitations we have to assign the IVs here:
1443             uint8[7] memory IVs = uint8[7](monsterCreator.getMonsterIVs());
1444             monsterIdToIVs[mon] = IVs;
1445             
1446         }
1447         
1448         
1449     function changeUsername(string _name) public {
1450             require(addressToTrainer[msg.sender].owner == msg.sender);
1451             
1452             
1453             addressToTrainer[msg.sender].username = _name;
1454         }
1455         
1456     function changeMonsterNickname(uint256 _tokenId, string _name) public {
1457             // users won't be able to rename a monster that is part of an auction
1458             require(_owns(msg.sender, _tokenId));
1459             
1460             
1461             // some string checks...?
1462             monsterIdToNickname[_tokenId] = _name;
1463         }
1464 
1465     function moveToArea(uint16 _newArea) public {
1466            
1467             // never allow anyone to move to area 0 or below since this is used
1468             // to determine if a trainer profile exists in another method!
1469             require(_newArea > 0);
1470             
1471             // make sure that this area exists yet!
1472             require(areas.length >= _newArea);
1473              
1474             // when player is not stuck doing something else he can move freely!
1475             _moveToArea(_newArea, msg.sender);
1476         }
1477 
1478     
1479     // to be changed to retrieve current stats!
1480     function getMonster(uint256 _id) external view returns (
1481         uint256 birthTime,
1482         uint256 generation,
1483         uint256 hp,
1484         uint256 attack,
1485         uint256 defense,
1486         uint256 spAttack,
1487         uint256 spDefense,
1488         uint256 speed,
1489         uint256 typeOne,
1490         uint256 typeTwo,
1491         
1492         uint256 mID,
1493         bool tradeable, 
1494         uint256 uID
1495         
1496             
1497         ) {    
1498        Monster storage mon = monsters[_id];
1499         birthTime = uint256(mon.birthTime);
1500         generation = 0; // hardcoding due to stack too deep error
1501         hp = uint256(mon.hp);
1502         attack = uint256(mon.attack);
1503         defense = uint256(mon.defense);
1504         spAttack = uint256(mon.spAttack);
1505         spDefense = uint256(mon.spDefense);
1506         speed = uint256(mon.speed);
1507         typeOne = uint256(mon.typeOne);
1508         typeTwo = uint256(mon.typeTwo);
1509         mID = uint256(mon.mID);
1510         tradeable = bool(mon.tradeable);
1511         
1512         // hack to overcome solidity's stack limitation in monster struct....
1513         uID = _id;
1514             
1515         }
1516 
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