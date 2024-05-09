1 // File: contracts/lib/RandomNumber.sol
2 
3 pragma solidity 0.8.2;
4 
5 library RandomNumber {
6     function randomNum(uint256 seed) internal returns (uint256) {
7         uint256 _number =
8             (uint256(
9                 keccak256(abi.encodePacked(blockhash(block.number - 1), seed))
10             ) % 100);
11         if (_number <= 0) {
12             _number = 1;
13         }
14 
15         return _number;
16     }
17 
18     function rand1To10(uint256 seed) internal returns (uint256) {
19         uint256 _number =
20             (uint256(
21                 keccak256(abi.encodePacked(blockhash(block.number - 1), seed))
22             ) % 10);
23         if (_number <= 0) {
24             _number = 10;
25         }
26 
27         return _number;
28     }
29 
30     function randDecimal(uint256 seed) internal returns (uint256) {
31         return (rand1To10(seed) / 10);
32     }
33 
34     function randomNumberToMax(uint256 seed, uint256 max)
35         internal
36         returns (uint256)
37     {
38         return (uint256(
39             keccak256(abi.encodePacked(blockhash(block.number - 1), seed))
40         ) % max);
41     }
42 
43     function randomNumber1ToMax(uint256 seed, uint256 max)
44         internal
45         returns (uint256)
46     {
47         uint256 _number =
48             (uint256(
49                 keccak256(abi.encodePacked(blockhash(block.number - 1), seed))
50             ) % max);
51         if (_number <= 0) {
52             _number = max;
53         }
54 
55         return _number;
56     }
57 }
58 
59 // File: contracts/base/Ownable.sol
60 
61 pragma solidity 0.8.2;
62 
63 contract Ownable {
64     address public owner;
65 
66     constructor() {
67         owner = msg.sender;
68     }
69 
70     modifier onlyOwner() {
71         require(msg.sender == owner);
72         _;
73     }
74 
75     function transferOwnership(address newOwner) external onlyOwner {
76         if (newOwner != address(0)) {
77             owner = newOwner;
78         }
79     }
80 }
81 
82 // File: contracts/fighter/FighterConfig.sol
83 
84 pragma solidity 0.8.2;
85 
86 
87 contract FighterConfig is Ownable {
88     uint256 public currentFighterCost = 50000000000000000 wei;
89 
90     string public constant LEGENDARY = "legendary";
91     string public constant EPIC = "epic";
92     string public constant RARE = "rare";
93     string public constant UNCOMMON = "uncommon";
94     string public constant COMMON = "common";
95 
96     // actually 1 higher than real life because of the issue with a 0 index fighter
97     uint256 public maxFighters = 6561;
98     uint256 public maxLegendaryFighters = 1;
99     uint256 public maxEpicFighters = 5;
100     uint256 public maxRareFighters = 25;
101     uint256 public maxUncommonFighters = 125;
102     uint256 public maxCommonFighters = 500;
103     uint256 public maxFightersPerChar = 656;
104     string public tokenMetadataEndpoint =
105         "https://cryptobrawle.rs/api/getFighterInfo/";
106     bool public isTrainingEnabled = false;
107 
108     uint256 public trainingFactor = 3;
109     uint256 public trainingCost = 5000000000000000 wei; // cost of training in wei
110 
111     function setTrainingFactor(uint256 newFactor) external onlyOwner {
112         trainingFactor = newFactor;
113     }
114 
115     function setNewTrainingCost(uint256 newCost) external onlyOwner {
116         trainingCost = newCost;
117     }
118 
119     function enableTraining() external onlyOwner {
120         isTrainingEnabled = true;
121     }
122 }
123 
124 // File: contracts/fighter/FighterBase.sol
125 
126 pragma solidity 0.8.2;
127 
128 
129 contract FighterBase is FighterConfig {
130     /*** EVENTS ***/
131     event Transfer(
132         address indexed from,
133         address indexed to,
134         uint256 indexed tokenId
135     );
136     event Creation(
137         address owner,
138         uint256 fighterId,
139         uint256 maxHealth,
140         uint256 speed,
141         uint256 strength,
142         string rarity,
143         string name,
144         string imageHash,
145         uint256 mintNum
146     );
147     event AttributeIncrease(
148         address owner,
149         uint256 fighterId,
150         string attribute,
151         uint256 increaseValue
152     );
153     event Healed(address owner, uint256 fighterId, uint256 maxHealth);
154 
155     struct Fighter {
156         uint256 maxHealth;
157         uint256 health;
158         uint256 speed;
159         uint256 strength;
160         string name;
161         string rarity;
162         string image;
163         uint256 mintNum;
164     }
165 
166     /*** STORAGE ***/
167 
168     Fighter[] fighters;
169     mapping(uint256 => address) public fighterIdToOwner; // lookup for owner of a specific fighter
170     mapping(uint256 => address) public fighterIdToApproved; // Shows appoved address for sending of fighters, Needed for ERC721
171     mapping(address => address[]) public ownerToOperators;
172     mapping(address => uint256) internal ownedFightersCount;
173 
174     string[] public availableFighterNames;
175     mapping(string => uint256) public indexOfAvailableFighterName;
176 
177     mapping(string => uint256) public rarityToSkillBuff;
178     mapping(string => uint256) public fighterNameToMintedCount;
179     mapping(string => mapping(string => string))
180         public fighterNameToRarityImageHashes;
181     mapping(string => mapping(string => uint256))
182         public fighterNameToRarityCounts;
183 
184     function getMintedCountForFighterRarity(
185         string memory _fighterName,
186         string memory _fighterRarity
187     ) external view returns (uint256 mintedCount) {
188         return fighterNameToRarityCounts[_fighterName][_fighterRarity];
189     }
190 
191     function addFighterCharacter(
192         string memory newName,
193         string memory legendaryImageHash,
194         string memory epicImageHash,
195         string memory rareImageHash,
196         string memory uncommonImageHash,
197         string memory commonImageHash
198     ) external onlyOwner {
199         indexOfAvailableFighterName[newName] = availableFighterNames.length;
200         availableFighterNames.push(newName);
201         fighterNameToMintedCount[newName] = 0;
202 
203         fighterNameToRarityImageHashes[newName][LEGENDARY] = legendaryImageHash;
204         fighterNameToRarityImageHashes[newName][EPIC] = epicImageHash;
205         fighterNameToRarityImageHashes[newName][RARE] = rareImageHash;
206         fighterNameToRarityImageHashes[newName][UNCOMMON] = uncommonImageHash;
207         fighterNameToRarityImageHashes[newName][COMMON] = commonImageHash;
208 
209         fighterNameToRarityCounts[newName][LEGENDARY] = 0;
210         fighterNameToRarityCounts[newName][EPIC] = 0;
211         fighterNameToRarityCounts[newName][RARE] = 0;
212         fighterNameToRarityCounts[newName][UNCOMMON] = 0;
213         fighterNameToRarityCounts[newName][COMMON] = 0;
214     }
215 
216     /// @dev Checks if a given address is the current owner of a particular fighter.
217     /// @param _claimant the address we are validating against.
218     /// @param _tokenId fighter id, only valid when > 0
219     function _owns(address _claimant, uint256 _tokenId)
220         internal
221         view
222         returns (bool)
223     {
224         return fighterIdToOwner[_tokenId] == _claimant;
225     }
226 
227     function _transfer(
228         address _from,
229         address _to,
230         uint256 _fighterId
231     ) internal {
232         fighterIdToOwner[_fighterId] = _to;
233         ownedFightersCount[_to]++;
234 
235         // Check that it isn't a newly created fighter before messing with ownership values
236         if (_from != address(0)) {
237             // Remove any existing approvals for the token
238             fighterIdToApproved[_fighterId] = address(0);
239             ownedFightersCount[_from]--;
240         }
241         // Emit the transfer event.
242         emit Transfer(_from, _to, _fighterId);
243     }
244 
245     function _createFighter(
246         uint256 _maxHealth,
247         uint256 _speed,
248         uint256 _strength,
249         address _owner,
250         string memory _rarity,
251         string memory _name,
252         uint256 _mintNum
253     ) internal returns (uint256) {
254         string memory _fighterImage =
255             fighterNameToRarityImageHashes[_name][_rarity];
256         Fighter memory _fighter =
257             Fighter({
258                 maxHealth: _maxHealth,
259                 health: _maxHealth, // Fighters are always created with maximum health
260                 speed: _speed,
261                 strength: _strength,
262                 name: _name,
263                 rarity: _rarity,
264                 image: _fighterImage,
265                 mintNum: _mintNum
266             });
267 
268         uint256 newFighterId = fighters.length;
269         fighters.push(_fighter);
270 
271         emit Creation(
272             _owner,
273             newFighterId,
274             _maxHealth,
275             _speed,
276             _strength,
277             _rarity,
278             _name,
279             _fighterImage,
280             _mintNum
281         );
282 
283         // This will assign ownership, and also emit the Transfer event as
284         // per ERC721 draft
285         _transfer(address(0), _owner, newFighterId);
286 
287         return newFighterId;
288     }
289 
290     function _updateFighterInStorage(
291         Fighter memory _updatedFighter,
292         uint256 _fighterId
293     ) internal {
294         fighters[_fighterId] = _updatedFighter;
295     }
296 
297     function _trainSpeed(
298         uint256 _fighterId,
299         uint256 _attributeIncrease,
300         address _owner
301     ) internal {
302         Fighter memory _fighter = fighters[_fighterId];
303         _fighter.speed += _attributeIncrease;
304         _updateFighterInStorage(_fighter, _fighterId);
305 
306         emit AttributeIncrease(_owner, _fighterId, "speed", _attributeIncrease);
307     }
308 
309     function _trainStrength(
310         uint256 _fighterId,
311         uint256 _attributeIncrease,
312         address _owner
313     ) internal {
314         Fighter memory _fighter = fighters[_fighterId];
315         _fighter.strength += _attributeIncrease;
316         _updateFighterInStorage(_fighter, _fighterId);
317 
318         emit AttributeIncrease(
319             _owner,
320             _fighterId,
321             "strength",
322             _attributeIncrease
323         );
324     }
325 }
326 
327 // File: contracts/marketplace/MarketplaceConfig.sol
328 
329 pragma solidity 0.8.2;
330 
331 
332 
333 contract MarketplaceConfig is Ownable, FighterBase {
334     uint256 public marketplaceCut = 5;
335     struct Combatant {
336         uint256 fighterId;
337         Fighter fighter;
338         uint256 damageModifier;
339     }
340 
341     struct Sale {
342         uint256 fighterId;
343         uint256 price;
344     }
345 
346     mapping(uint256 => Sale) public fighterIdToSale; // Storing of figher Ids against their sale Struct
347     mapping(uint256 => uint256) public fighterIdToBrawl; // Map of fighter Ids to their max health
348 
349     event PurchaseSuccess(
350         address buyer,
351         uint256 price,
352         uint256 fighterId,
353         address seller
354     );
355     event FightComplete(
356         address winner,
357         uint256 winnerId,
358         address loser,
359         uint256 loserId
360     );
361 
362     event MarketplaceRemoval(address owner, uint256 fighterId);
363     event ArenaRemoval(address owner, uint256 fighterId);
364 
365     event MarketplaceAdd(address owner, uint256 fighterId, uint256 price);
366     event ArenaAdd(address owner, uint256 fighterId);
367 
368     function setNewMarketplaceCut(uint256 _newCut) external onlyOwner {
369         marketplaceCut = _newCut;
370     }
371 
372     function withdrawBalance() external onlyOwner {
373         payable(owner).transfer(address(this).balance);
374     }
375 
376     function withdrawBalanceToAddress(address _recipient) external onlyOwner {
377         payable(_recipient).transfer(address(this).balance);
378     }
379 
380     function killContract() external onlyOwner {
381         selfdestruct(payable(owner));
382     }
383 
384     function _calculateCut(uint256 _totalPrice) internal returns (uint256) {
385         return ((_totalPrice / 100) * marketplaceCut);
386     }
387 
388     function _fighterIsForSale(uint256 _fighterId) internal returns (bool) {
389         return (fighterIdToSale[_fighterId].price > 0);
390     }
391 
392     function _fighterIsForBrawl(uint256 _fighterId) internal returns (bool) {
393         return (fighterIdToBrawl[_fighterId] > 0);
394     }
395 
396     function _removeFighterFromSale(uint256 _fighterId) internal {
397         delete fighterIdToSale[_fighterId];
398     }
399 
400     function _removeFighterFromArena(uint256 _fighterId) internal {
401         delete fighterIdToBrawl[_fighterId];
402     }
403 }
404 
405 // File: contracts/marketplace/Marketplace.sol
406 
407 pragma solidity 0.8.2;
408 
409 
410 
411 contract Marketplace is MarketplaceConfig {
412     function getPriceForFighter(uint256 _fighterId) external returns (uint256) {
413         return fighterIdToSale[_fighterId].price;
414     }
415 
416     function removeFighterFromSale(uint256 _fighterId) external {
417         require(_owns(msg.sender, _fighterId));
418         // Just double check we can actually remove a fighter before we go any further
419         require(_fighterIsForSale(_fighterId));
420 
421         _removeFighterFromSale(_fighterId);
422         emit MarketplaceRemoval(msg.sender, _fighterId);
423     }
424 
425     function removeFighterFromArena(uint256 _fighterId) external {
426         require(_owns(msg.sender, _fighterId));
427         // Just double check we can actually remove a fighter before we go any further
428         require(_fighterIsForBrawl(_fighterId));
429 
430         _removeFighterFromArena(_fighterId);
431         emit ArenaRemoval(msg.sender, _fighterId);
432     }
433 
434     function makeFighterAvailableForSale(uint256 _fighterId, uint256 _price)
435         external
436     {
437         require(_owns(msg.sender, _fighterId));
438         // Fighters can't be both for sale and open for brawling
439         require(!_fighterIsForBrawl(_fighterId));
440         require(_price > 0);
441 
442         // Double check there is not an existing third party transfer approval
443         require(fighterIdToApproved[_fighterId] == address(0));
444 
445         fighterIdToSale[_fighterId] = Sale({
446             fighterId: _fighterId,
447             price: _price
448         });
449         emit MarketplaceAdd(msg.sender, _fighterId, _price);
450     }
451 
452     function makeFighterAvailableForBrawl(uint256 _fighterId) external {
453         require(_owns(msg.sender, _fighterId));
454         // Fighters can't be both for sale and open for brawling
455         require(!_fighterIsForSale(_fighterId));
456         // We don't want fighters being added twice
457         require(!_fighterIsForBrawl(_fighterId));
458 
459         // Double check there is not an existing third party transfer approval
460         require(fighterIdToApproved[_fighterId] == address(0));
461 
462         fighterIdToBrawl[_fighterId] = _fighterId;
463         emit ArenaAdd(msg.sender, _fighterId);
464     }
465 
466     function buyFighter(uint256 _fighterId) external payable {
467         address _seller = fighterIdToOwner[_fighterId];
468         _makePurchase(_fighterId, msg.value);
469         _transfer(_seller, msg.sender, _fighterId);
470 
471         emit PurchaseSuccess(msg.sender, msg.value, _fighterId, _seller);
472     }
473 
474     function _strike(
475         uint256 _attackerId,
476         uint256 _defenderId,
477         uint256 _attackerStrength,
478         uint256 _defenderStrength,
479         uint256 _seed
480     ) internal returns (bool) {
481         uint256 _attackerAttackRoll =
482             RandomNumber.randomNumber1ToMax(_seed, 20) + _attackerStrength;
483         uint256 _defenderDefenseRoll =
484             RandomNumber.randomNumber1ToMax(_seed * 3, 20) + _defenderStrength;
485 
486         if (_attackerAttackRoll >= _defenderDefenseRoll) {
487             return true;
488         }
489 
490         return false;
491     }
492 
493     function _performFight(
494         uint256 _attackerId,
495         uint256 _defenderId,
496         Fighter memory _attacker,
497         Fighter memory _defender,
498         uint256 _seed
499     ) internal returns (uint256 winnerId, uint256 loserId) {
500         uint256 _generatedSeed =
501             RandomNumber.randomNumber1ToMax(_seed, 99999999);
502         uint256 _totalSpeed = _attacker.speed + _defender.speed;
503         uint256 _attackerSpeedRoll =
504             RandomNumber.randomNumber1ToMax(_seed, 20) + _attacker.speed;
505         uint256 _defenderSpeedRoll =
506             RandomNumber.randomNumber1ToMax(_generatedSeed, 20) +
507                 _defender.speed;
508 
509         bool _attackerIsStrikingFirst =
510             _attackerSpeedRoll >= _defenderSpeedRoll;
511 
512         if (_attackerIsStrikingFirst) {
513             if (
514                 _strike(
515                     _attackerId,
516                     _defenderId,
517                     _attacker.strength,
518                     _defender.strength,
519                     _seed * 2
520                 )
521             ) {
522                 return (_attackerId, _defenderId);
523             }
524         } else {
525             if (
526                 _strike(
527                     _defenderId,
528                     _attackerId,
529                     _defender.strength,
530                     _attacker.strength,
531                     _generatedSeed * 2
532                 )
533             ) {
534                 return (_defenderId, _attackerId);
535             }
536         }
537 
538         if (_attackerIsStrikingFirst) {
539             if (
540                 _strike(
541                     _defenderId,
542                     _attackerId,
543                     _defender.strength,
544                     _attacker.strength,
545                     _generatedSeed * 3
546                 )
547             ) {
548                 return (_defenderId, _attackerId);
549             }
550         } else {
551             if (
552                 _strike(
553                     _attackerId,
554                     _defenderId,
555                     _attacker.strength,
556                     _defender.strength,
557                     _seed * 3
558                 )
559             ) {
560                 return (_attackerId, _defenderId);
561             }
562         }
563 
564         uint256 _defenderEndCheck =
565             _defender.speed +
566                 _defender.strength +
567                 RandomNumber.randomNumber1ToMax(_generatedSeed, 20);
568         uint256 _attackerEndCheck =
569             _attacker.speed +
570                 _attacker.strength +
571                 RandomNumber.randomNumber1ToMax(_seed, 20);
572 
573         if (_defenderEndCheck >= _attackerEndCheck) {
574             return (_defenderId, _attackerId);
575         }
576         return (_attackerId, _defenderId);
577     }
578 
579     function fight(
580         uint256 _attackerId,
581         uint256 _defenderId,
582         uint256 _seed
583     ) external {
584         Fighter memory _attacker = fighters[_attackerId];
585         Fighter memory _defender = fighters[_defenderId];
586         // fighter actually in the arena is always the defender
587         require(_fighterIsForBrawl(_defenderId));
588         // Make sure the challenger is actually sending the transaction
589         require(_owns(msg.sender, _attackerId));
590         // Also make sure that the challenger is not attacking his own fighter
591         require(!_owns(msg.sender, _defenderId));
592         // Ensure that a 'stronger' fighter is not attacking a 'weaker' fighter
593         require(
594             (_attacker.speed + _attacker.strength) <=
595                 (_defender.speed + _defender.strength)
596         );
597 
598         (uint256 _winnerId, uint256 _loserId) =
599             _performFight(
600                 _attackerId,
601                 _defenderId,
602                 _attacker,
603                 _defender,
604                 _seed
605             );
606 
607         if (_fighterIsForBrawl(_winnerId)) {
608             _removeFighterFromArena(_winnerId);
609         } else {
610             _removeFighterFromArena(_loserId);
611         }
612         address _winnerAddress = fighterIdToOwner[_winnerId];
613         address _loserAddress = fighterIdToOwner[_loserId];
614 
615         _transfer(_loserAddress, _winnerAddress, _loserId);
616         emit FightComplete(_winnerAddress, _winnerId, _loserAddress, _loserId);
617     }
618 
619     function _makePurchase(uint256 _fighterId, uint256 _price) internal {
620         require(!_owns(msg.sender, _fighterId));
621         require(_fighterIsForSale(_fighterId));
622         require(_price >= fighterIdToSale[_fighterId].price);
623 
624         address sellerAddress = fighterIdToOwner[_fighterId];
625         _removeFighterFromSale(_fighterId);
626 
627         uint256 saleCut = _calculateCut(_price);
628         uint256 totalSale = _price - saleCut;
629         payable(sellerAddress).transfer(totalSale);
630     }
631 }
632 
633 // File: contracts/lib/Integers.sol
634 
635 pragma solidity 0.8.2;
636 
637 library Integers {
638     function toString(uint256 value) internal pure returns (string memory) {
639         if (value == 0) {
640             return "0";
641         }
642         uint256 temp = value;
643         uint256 digits;
644         while (temp != 0) {
645             digits++;
646             temp /= 10;
647         }
648         bytes memory buffer = new bytes(digits);
649         while (value != 0) {
650             digits -= 1;
651             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
652             value /= 10;
653         }
654         return string(buffer);
655     }
656 }
657 
658 // File: contracts/base/ERC721.sol
659 
660 pragma solidity 0.8.2;
661 
662 abstract contract ERC721 {
663     // Required methods
664     function totalSupply() public view virtual returns (uint256 total) {}
665 
666     function balanceOf(address _owner)
667         public
668         view
669         virtual
670         returns (uint256 balance)
671     {}
672 
673     function ownerOf(uint256 _tokenId)
674         external
675         view
676         virtual
677         returns (address owner)
678     {}
679 
680     function approve(address _to, uint256 _tokenId) external virtual {}
681 
682     function transfer(address _to, uint256 _tokenId) external virtual {}
683 
684     function tokenURI(uint256 _tokenId)
685         external
686         view
687         virtual
688         returns (string memory _tokenURI)
689     {}
690 
691     function baseURI() external view virtual returns (string memory _baseURI) {}
692 
693     function transferFrom(
694         address _from,
695         address _to,
696         uint256 _tokenId
697     ) external virtual {}
698 
699     function getApproved(uint256 _tokenId)
700         external
701         virtual
702         returns (address _approvedAddress)
703     {}
704 
705     function setApprovalForAll(address _to, bool approved) external virtual {}
706 
707     function isApprovedForAll(address _owner, address _operator)
708         external
709         virtual
710         returns (bool isApproved)
711     {}
712 
713     function safeTransferFrom(
714         address _from,
715         address _to,
716         uint256 _tokenId
717     ) external virtual {}
718 
719     function safeTransferFrom(
720         address _from,
721         address _to,
722         uint256 _tokenId,
723         bytes calldata _data
724     ) external virtual {}
725 
726     // Events
727     event Approval(
728         address indexed owner,
729         address indexed approved,
730         uint256 indexed tokenId
731     );
732     event ApprovalForAll(
733         address indexed owner,
734         address indexed operator,
735         bool approved
736     );
737 
738     function _isContract(address _addr)
739         internal
740         view
741         returns (bool isContract)
742     {
743         uint32 size;
744         assembly {
745             size := extcodesize(_addr)
746         }
747         return (size > 0);
748     }
749 
750     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
751     function supportsInterface(bytes4 _interfaceID)
752         external
753         view
754         virtual
755         returns (bool)
756     {}
757 
758     /// @notice Handle the receipt of an NFT
759     /// @dev The ERC721 smart contract calls this function on the
760     /// recipient after a `transfer`. This function MAY throw to revert and reject the transfer. Return
761     /// of other than the magic value MUST result in the transaction being reverted.
762     /// @notice The contract address is always the message sender.
763     /// @param _operator The address which called `safeTransferFrom` function
764     /// @param _from The address which previously owned the token
765     /// @param _tokenId The NFT identifier which is being transferred
766     /// @param _data Additional data with no specified format
767     /// @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
768     /// unless throwing
769     function onERC721Received(
770         address _operator,
771         address _from,
772         uint256 _tokenId,
773         bytes calldata _data
774     ) external virtual returns (bytes4) {}
775 }
776 
777 // File: contracts/base/Priced.sol
778 
779 pragma solidity 0.8.2;
780 
781 contract Priced {
782     modifier costs(uint256 price) {
783         if (msg.value >= price) {
784             _;
785         }
786     }
787 }
788 
789 // File: contracts/base/Pausable.sol
790 
791 pragma solidity 0.8.2;
792 
793 
794 contract Pausable is Ownable {
795     bool public isPaused = false;
796 
797     modifier whenNotPaused() {
798         require(!isPaused);
799         _;
800     }
801 
802     function pause() external onlyOwner {
803         isPaused = true;
804     }
805 
806     function unPause() external onlyOwner {
807         isPaused = false;
808     }
809 }
810 
811 // File: contracts/base/IERC721Receiver.sol
812 
813 pragma solidity ^0.8.2;
814 
815 /**
816  * @title ERC721 token receiver interface
817  * @dev Interface for any contract that wants to support safeTransfers
818  * from ERC721 asset contracts.
819  */
820 interface IERC721Receiver {
821     /**
822      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
823      * by `operator` from `from`, this function is called.
824      *
825      * It must return its Solidity selector to confirm the token transfer.
826      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
827      *
828      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
829      */
830     function onERC721Received(
831         address operator,
832         address from,
833         uint256 tokenId,
834         bytes calldata data
835     ) external returns (bytes4);
836 }
837 
838 // File: contracts/fighter/FighterTraining.sol
839 
840 pragma solidity 0.8.2;
841 
842 
843 contract FighterTraining is FighterBase {
844     function _train(
845         uint256 _fighterId,
846         string memory _attribute,
847         uint256 _attributeIncrease
848     ) internal {
849         if (
850             keccak256(abi.encodePacked(_attribute)) ==
851             keccak256(abi.encodePacked("strength"))
852         ) {
853             _trainStrength(_fighterId, _attributeIncrease, msg.sender);
854         } else if (
855             keccak256(abi.encodePacked(_attribute)) ==
856             keccak256(abi.encodePacked("speed"))
857         ) {
858             _trainSpeed(_fighterId, _attributeIncrease, msg.sender);
859         }
860     }
861 }
862 
863 // File: contracts/fighter/FighterOwnership.sol
864 
865 pragma solidity 0.8.2;
866 
867 
868 
869 
870 
871 
872 
873 
874 
875 
876 
877 contract FighterOwnership is
878     FighterConfig,
879     FighterBase,
880     FighterTraining,
881     ERC721,
882     Priced,
883     Pausable,
884     MarketplaceConfig
885 {
886     using Integers for uint256;
887     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
888     string public constant name = "CryptoBrawlers";
889     string public constant symbol = "BRAWLER";
890     bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
891 
892     bytes4 constant InterfaceSignature_ERC165 =
893         bytes4(keccak256("supportsInterface(bytes4)"));
894     /*
895      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
896      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
897      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
898      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
899      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
900      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
901      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
902      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
903      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
904      *
905      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
906      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
907      */
908     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
909     /*
910      *     bytes4(keccak256('name()')) == 0x06fdde03
911      *     bytes4(keccak256('symbol()')) == 0x95d89b41
912      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
913      *
914      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
915      */
916     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
917 
918     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
919     ///  Returns true for any standardized interfaces implemented by this contract. We implement
920     ///  ERC-165 (obviously!) and ERC-721.
921     function supportsInterface(bytes4 _interfaceID)
922         external
923         view
924         override
925         returns (bool)
926     {
927         return ((_interfaceID == InterfaceSignature_ERC165) ||
928             (_interfaceID == _INTERFACE_ID_ERC721) ||
929             (_interfaceID == _INTERFACE_ID_ERC721_METADATA));
930     }
931 
932     function onERC721Received(
933         address _operator,
934         address _from,
935         uint256 _tokenId,
936         bytes calldata _data
937     ) external pure override returns (bytes4) {
938         revert();
939     }
940 
941     // Internal utility functions: These functions all assume that their input arguments
942     // are valid. We leave it to public methods to sanitize their inputs and follow
943     // the required logic.
944 
945     /// @dev Checks if a given address currently has transferApproval for a particular fighter.
946     /// @param _claimant the address we are confirming brawler is approved for.
947     /// @param _tokenId fighter id, only valid when > 0
948     function _approvedFor(address _claimant, uint256 _tokenId)
949         internal
950         view
951         returns (bool)
952     {
953         if (fighterIdToApproved[_tokenId] == _claimant) {
954             return true;
955         }
956 
957         bool _senderIsOperator = false;
958         address _owner = fighterIdToOwner[_tokenId];
959         address[] memory _validOperators = ownerToOperators[_owner];
960 
961         uint256 _operatorIndex;
962         for (
963             _operatorIndex = 0;
964             _operatorIndex < _validOperators.length;
965             _operatorIndex++
966         ) {
967             if (_validOperators[_operatorIndex] == _claimant) {
968                 _senderIsOperator = true;
969                 break;
970             }
971         }
972 
973         return _senderIsOperator;
974     }
975 
976     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
977     ///  approval. Setting _approved to address(0) clears all transfer approval.
978     ///  NOTE: _approve() does NOT send the Approval event.
979     function _approve(uint256 _tokenId, address _approved) internal {
980         fighterIdToApproved[_tokenId] = _approved;
981     }
982 
983     /// @notice Returns the number of Fighters owned by a specific address.
984     /// @param _owner The owner address to check.
985     /// @dev Required for ERC-721 compliance
986     function balanceOf(address _owner)
987         public
988         view
989         override
990         returns (uint256 count)
991     {
992         require(_owner != address(0));
993         return ownedFightersCount[_owner];
994     }
995 
996     /// @notice Transfers a Fighter to another address. If transferring to a smart
997     /// contract be VERY CAREFUL to ensure that it is aware of ERC-721.
998     /// @param _to The address of the recipient, can be a user or contract.
999     /// @param _tokenId The ID of the fighter to transfer.
1000     /// @dev Required for ERC-721 compliance.
1001     function transfer(address _to, uint256 _tokenId) external override {
1002         // Safety check to prevent against an unexpected 0x0 default.
1003         require(_to != address(0));
1004         // Disallow transfers to this contract to prevent accidental misuse.
1005         require(_to != address(this));
1006         // You can only send your own fighter.
1007         require(_owns(msg.sender, _tokenId));
1008         // If transferring we can't keep a fighter in the arena...
1009         if (_fighterIsForBrawl(_tokenId)) {
1010             _removeFighterFromArena(_tokenId);
1011             emit ArenaRemoval(msg.sender, _tokenId);
1012         }
1013 
1014         // ...nor can they be in our marketplace.
1015         if (_fighterIsForSale(_tokenId)) {
1016             _removeFighterFromSale(_tokenId);
1017             emit MarketplaceRemoval(msg.sender, _tokenId);
1018         }
1019 
1020         // Reassign ownership, clear pending approvals, emit Transfer event.
1021         _transfer(msg.sender, _to, _tokenId);
1022     }
1023 
1024     /// @notice Grant another address the right to transfer a specific fighter via
1025     ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
1026     /// @param _to The address to be granted transfer approval. Pass address(0) to
1027     ///  clear all approvals.
1028     /// @param _tokenId The ID of the fighter that can be transferred if this call succeeds.
1029     /// @dev Required for ERC-721 compliance.
1030     function approve(address _to, uint256 _tokenId) external override {
1031         // Only an owner can grant transfer approval.
1032         require(_owns(msg.sender, _tokenId));
1033 
1034         // If selling on an external marketplace we can't keep a fighter in the arena...
1035         if (_fighterIsForBrawl(_tokenId)) {
1036             _removeFighterFromArena(_tokenId);
1037             emit ArenaRemoval(msg.sender, _tokenId);
1038         }
1039 
1040         // ...nor can they be in our marketplace.
1041         if (_fighterIsForSale(_tokenId)) {
1042             _removeFighterFromSale(_tokenId);
1043             emit MarketplaceRemoval(msg.sender, _tokenId);
1044         }
1045         // Register the approval (replacing any previous approval).
1046         _approve(_tokenId, _to);
1047 
1048         // Emit approval event.
1049         emit Approval(msg.sender, _to, _tokenId);
1050     }
1051 
1052     /// @notice Transfer a fighter owned by another address, for which the calling address
1053     ///  has previously been granted transfer approval by the owner.
1054     /// @param _from The address that owns the fighter to be transfered.
1055     /// @param _to The address that should take ownership of the fighter. Can be any address,
1056     ///  including the caller.
1057     /// @param _tokenId The ID of the fighter to be transferred.
1058     /// @dev Required for ERC-721 compliance.
1059     function transferFrom(
1060         address _from,
1061         address _to,
1062         uint256 _tokenId
1063     ) external override {
1064         // Safety check to prevent against an unexpected 0x0 default.
1065         require(_to != address(0));
1066         // Disallow transfers to this contract to prevent accidental misuse.
1067         require(_to != address(this));
1068         // Check for approval and valid ownership
1069         require(_approvedFor(msg.sender, _tokenId));
1070         require(_owns(_from, _tokenId));
1071 
1072         // This should never be the case, but might as well check
1073         if (_fighterIsForBrawl(_tokenId)) {
1074             _removeFighterFromArena(_tokenId);
1075             emit ArenaRemoval(msg.sender, _tokenId);
1076         }
1077 
1078         // ...nor can they be in our marketplace.
1079         if (_fighterIsForSale(_tokenId)) {
1080             _removeFighterFromSale(_tokenId);
1081             emit MarketplaceRemoval(msg.sender, _tokenId);
1082         }
1083 
1084         // Reassign ownership (also clears pending approvals and emits Transfer event).
1085         _transfer(_from, _to, _tokenId);
1086         // Remove an existing external approval to move the fighter.
1087         _approve(_tokenId, address(0));
1088     }
1089 
1090     function _safeTransferFrom(
1091         address _from,
1092         address _to,
1093         uint256 _tokenId
1094     ) internal {
1095         // This should never be the case, but might as well check
1096         if (_fighterIsForBrawl(_tokenId)) {
1097             _removeFighterFromArena(_tokenId);
1098             emit ArenaRemoval(msg.sender, _tokenId);
1099         }
1100 
1101         // ...nor can they be in our marketplace.
1102         if (_fighterIsForSale(_tokenId)) {
1103             _removeFighterFromSale(_tokenId);
1104             emit MarketplaceRemoval(msg.sender, _tokenId);
1105         }
1106 
1107         // Reassign ownership (also clears pending approvals and emits Transfer event).
1108         _transfer(_from, _to, _tokenId);
1109         // Remove an existing external approval to move the fighter.
1110         _approve(_tokenId, address(0));
1111     }
1112 
1113     function safeTransferFrom(
1114         address _from,
1115         address _to,
1116         uint256 _tokenId
1117     ) external override {
1118         // Safety check to prevent against an unexpected 0x0 default.
1119         require(_to != address(0));
1120         // Disallow transfers to this contract to prevent accidental misuse.
1121         require(_to != address(this));
1122         // Check for approval and valid ownership
1123         require(_approvedFor(msg.sender, _tokenId));
1124         require(_owns(_from, _tokenId));
1125 
1126         _safeTransferFrom(_from, _to, _tokenId);
1127 
1128         if (_isContract(_to)) {
1129             bytes4 retval =
1130                 IERC721Receiver(_to).onERC721Received(_from, _to, _tokenId, "");
1131             require(ERC721_RECEIVED == retval);
1132         }
1133     }
1134 
1135     function safeTransferFrom(
1136         address _from,
1137         address _to,
1138         uint256 _tokenId,
1139         bytes calldata _data
1140     ) external override {
1141         // Safety check to prevent against an unexpected 0x0 default.
1142         require(_to != address(0));
1143         // Disallow transfers to this contract to prevent accidental misuse.
1144         require(_to != address(this));
1145         // Check for approval and valid ownership
1146         require(_approvedFor(msg.sender, _tokenId));
1147         require(_owns(_from, _tokenId));
1148 
1149         _safeTransferFrom(_from, _to, _tokenId);
1150 
1151         if (_isContract(_to)) {
1152             bytes4 retval =
1153                 IERC721Receiver(_to).onERC721Received(
1154                     _from,
1155                     _to,
1156                     _tokenId,
1157                     _data
1158                 );
1159             require(ERC721_RECEIVED == retval);
1160         }
1161     }
1162 
1163     function getApproved(uint256 _tokenId)
1164         external
1165         view
1166         override
1167         returns (address _approvedAddress)
1168     {
1169         return fighterIdToApproved[_tokenId];
1170     }
1171 
1172     function setApprovalForAll(address _to, bool _approved) external override {
1173         address[] memory _operatorsForSender = ownerToOperators[msg.sender];
1174         if (_approved) {
1175             ownerToOperators[msg.sender].push(_to);
1176         }
1177 
1178         if (!_approved) {
1179             if (ownerToOperators[msg.sender].length == 0) {
1180                 emit ApprovalForAll(msg.sender, _to, false);
1181                 return;
1182             }
1183 
1184             uint256 _operatorIndex;
1185             for (
1186                 _operatorIndex = 0;
1187                 _operatorIndex < _operatorsForSender.length;
1188                 _operatorIndex++
1189             ) {
1190                 if (ownerToOperators[msg.sender][_operatorIndex] == _to) {
1191                     ownerToOperators[msg.sender][
1192                         _operatorIndex
1193                     ] = ownerToOperators[msg.sender][
1194                         ownerToOperators[msg.sender].length - 1
1195                     ];
1196                     ownerToOperators[msg.sender].pop();
1197                     break;
1198                 }
1199             }
1200         }
1201 
1202         emit ApprovalForAll(msg.sender, _to, _approved);
1203     }
1204 
1205     function isApprovedForAll(address _owner, address _operator)
1206         external
1207         view
1208         override
1209         returns (bool isApproved)
1210     {
1211         address[] memory _operatorsForSender = ownerToOperators[_owner];
1212 
1213         if (_operatorsForSender.length == 0) {
1214             return false;
1215         }
1216         bool _isApproved = true;
1217         uint256 _operatorIndex;
1218         for (
1219             _operatorIndex = 0;
1220             _operatorIndex < _operatorsForSender.length;
1221             _operatorIndex++
1222         ) {
1223             if (_operatorsForSender[_operatorIndex] != _operator) {
1224                 _isApproved = false;
1225                 break;
1226             }
1227         }
1228 
1229         return _isApproved;
1230     }
1231 
1232     /// @notice Returns the total number of fighters currently in existence.
1233     /// @dev Required for ERC-721 compliance.
1234     function totalSupply() public view override returns (uint256) {
1235         return fighters.length - 1; // -1 because of the phantom 0 index fighter that doesn't play nicely
1236     }
1237 
1238     /// @notice Returns the address currently assigned ownership of a given fighter.
1239     /// @dev Required for ERC-721 compliance.
1240     function ownerOf(uint256 _tokenId)
1241         external
1242         view
1243         override
1244         returns (address owner)
1245     {
1246         owner = fighterIdToOwner[_tokenId];
1247         require(owner != address(0));
1248 
1249         return owner;
1250     }
1251 
1252     function tokenURI(uint256 _tokenId)
1253         external
1254         view
1255         override
1256         returns (string memory)
1257     {
1258         return
1259             string(
1260                 abi.encodePacked(tokenMetadataEndpoint, _tokenId.toString())
1261             );
1262     }
1263 
1264     function baseURI() external view override returns (string memory) {
1265         return tokenMetadataEndpoint;
1266     }
1267 
1268     modifier currentFighterPrice() {
1269         require(msg.value >= currentFighterCost);
1270         _;
1271     }
1272 
1273     function trainFighter(
1274         uint256 _fighterId,
1275         string memory _attribute,
1276         uint256 _seed
1277     ) external payable costs(trainingCost) returns (uint256 _increaseValue) {
1278         require(isTrainingEnabled);
1279         require(_owns(msg.sender, _fighterId));
1280         uint256 _attributeIncrease =
1281             (RandomNumber.rand1To10(_seed) / trainingFactor);
1282         if (_attributeIncrease == 0) {
1283             _attributeIncrease = 1;
1284         }
1285 
1286         _train(_fighterId, _attribute, _attributeIncrease);
1287         return _attributeIncrease;
1288     }
1289 
1290     function _getFighterRarity(uint256 _seed, string memory _fighterName)
1291         internal
1292         returns (string memory)
1293     {
1294         uint256 _rarityRoll =
1295             RandomNumber.randomNumber1ToMax(_seed, maxFightersPerChar);
1296         uint256 _minEpicRoll =
1297             maxFightersPerChar - (maxEpicFighters + maxLegendaryFighters);
1298         uint256 _minRareRoll =
1299             maxFightersPerChar -
1300                 (maxRareFighters + maxEpicFighters + maxLegendaryFighters);
1301         uint256 _minUncommonRoll =
1302             maxFightersPerChar -
1303                 (maxUncommonFighters +
1304                     maxRareFighters +
1305                     maxEpicFighters +
1306                     maxLegendaryFighters);
1307 
1308         if (
1309             fighterNameToRarityCounts[_fighterName][LEGENDARY] <
1310             maxLegendaryFighters &&
1311             _rarityRoll == maxFightersPerChar
1312         ) {
1313             return LEGENDARY;
1314         }
1315         if (
1316             fighterNameToRarityCounts[_fighterName][EPIC] < maxEpicFighters &&
1317             _rarityRoll >= _minEpicRoll
1318         ) {
1319             return EPIC;
1320         }
1321         if (
1322             fighterNameToRarityCounts[_fighterName][RARE] < maxRareFighters &&
1323             _rarityRoll >= _minRareRoll
1324         ) {
1325             return RARE;
1326         }
1327         if (
1328             fighterNameToRarityCounts[_fighterName][UNCOMMON] <
1329             maxUncommonFighters &&
1330             _rarityRoll >= _minUncommonRoll
1331         ) {
1332             return UNCOMMON;
1333         }
1334         if (
1335             fighterNameToRarityCounts[_fighterName][COMMON] <
1336             maxCommonFighters &&
1337             _rarityRoll >= 1
1338         ) {
1339             return COMMON;
1340         }
1341 
1342         string[] memory _leftoverRarities;
1343         if (
1344             fighterNameToRarityCounts[_fighterName][LEGENDARY] <
1345             maxLegendaryFighters
1346         ) {
1347             _leftoverRarities[_leftoverRarities.length] = LEGENDARY;
1348         }
1349         if (fighterNameToRarityCounts[_fighterName][EPIC] < maxEpicFighters) {
1350             _leftoverRarities[_leftoverRarities.length] = EPIC;
1351         }
1352         if (fighterNameToRarityCounts[_fighterName][RARE] < maxRareFighters) {
1353             _leftoverRarities[_leftoverRarities.length] = RARE;
1354         }
1355         if (
1356             fighterNameToRarityCounts[_fighterName][UNCOMMON] <
1357             maxUncommonFighters
1358         ) {
1359             _leftoverRarities[_leftoverRarities.length] = UNCOMMON;
1360         }
1361         if (
1362             fighterNameToRarityCounts[_fighterName][COMMON] < maxCommonFighters
1363         ) {
1364             _leftoverRarities[_leftoverRarities.length] = COMMON;
1365         }
1366 
1367         if (_leftoverRarities.length == 1) {
1368             return _leftoverRarities[0];
1369         }
1370 
1371         uint256 _leftoverRoll =
1372             RandomNumber.randomNumberToMax(_seed, _leftoverRarities.length);
1373         return _leftoverRarities[_leftoverRoll];
1374     }
1375 
1376     function _getFighterName(uint256 _seed)
1377         internal
1378         returns (string memory _fighterName)
1379     {
1380         uint256 _nameIndex =
1381             RandomNumber.randomNumberToMax(_seed, availableFighterNames.length); // Use the whole array length because the random max number does not include the top end
1382         return availableFighterNames[_nameIndex];
1383     }
1384 
1385     function _removeNameFromAvailableNamesArray(string memory _fighterName)
1386         internal
1387     {
1388         uint256 _nameIndex = indexOfAvailableFighterName[_fighterName];
1389         require(
1390             keccak256(abi.encodePacked(availableFighterNames[_nameIndex])) ==
1391                 keccak256(abi.encodePacked(_fighterName))
1392         ); // double check something wiggly hasn't happened
1393 
1394         if (availableFighterNames.length > 1) {
1395             availableFighterNames[_nameIndex] = availableFighterNames[
1396                 availableFighterNames.length - 1
1397             ];
1398         }
1399         availableFighterNames.pop();
1400     }
1401 
1402     function searchForFighter(uint256 _seed)
1403         external
1404         payable
1405         currentFighterPrice
1406         whenNotPaused()
1407         returns (uint256 newFighterId)
1408     {
1409         require(fighters.length < maxFighters);
1410         string memory _fighterName = _getFighterName(_seed);
1411         string memory _fighterRarity = _getFighterRarity(_seed, _fighterName);
1412         uint256 _speed =
1413             RandomNumber.rand1To10(_seed) + rarityToSkillBuff[_fighterRarity];
1414         uint256 _strength =
1415             RandomNumber.rand1To10(_speed + _seed) +
1416                 rarityToSkillBuff[_fighterRarity];
1417 
1418         fighterNameToMintedCount[_fighterName] += 1;
1419         fighterNameToRarityCounts[_fighterName][_fighterRarity] += 1;
1420 
1421         uint256 _fighterId =
1422             _createFighter(
1423                 10,
1424                 _speed,
1425                 _strength,
1426                 msg.sender,
1427                 _fighterRarity,
1428                 _fighterName,
1429                 fighterNameToRarityCounts[_fighterName][_fighterRarity]
1430             );
1431 
1432         if (fighterNameToMintedCount[_fighterName] >= maxFightersPerChar) {
1433             _removeNameFromAvailableNamesArray(_fighterName);
1434         }
1435 
1436         uint256 _fighterCost = _getFighterCost();
1437         if (_fighterCost > currentFighterCost) {
1438             currentFighterCost = _fighterCost;
1439         }
1440 
1441         return _fighterId;
1442     }
1443 
1444     function _getFighterCost() internal returns (uint256 _cost) {
1445         uint256 currentTotalFighters = fighters.length - 1;
1446 
1447         if (currentTotalFighters < 500) {
1448             return 50000000000000000 wei;
1449         }
1450         if (currentTotalFighters >= 500 && currentTotalFighters < 1000) {
1451             return 100000000000000000 wei;
1452         }
1453         if (currentTotalFighters >= 1000 && currentTotalFighters < 1500) {
1454             return 150000000000000000 wei;
1455         }
1456         if (currentTotalFighters >= 1500 && currentTotalFighters < 2000) {
1457             return 200000000000000000 wei;
1458         }
1459         if (currentTotalFighters >= 2000 && currentTotalFighters < 2500) {
1460             return 250000000000000000 wei;
1461         }
1462         if (currentTotalFighters >= 2500 && currentTotalFighters < 3000) {
1463             return 300000000000000000 wei;
1464         }
1465         if (currentTotalFighters >= 3000 && currentTotalFighters < 3500) {
1466             return 350000000000000000 wei;
1467         }
1468         if (currentTotalFighters >= 3500 && currentTotalFighters < 4000) {
1469             return 400000000000000000 wei;
1470         }
1471         if (currentTotalFighters >= 4000 && currentTotalFighters < 4500) {
1472             return 450000000000000000 wei;
1473         }
1474         if (currentTotalFighters >= 4500 && currentTotalFighters < 5000) {
1475             return 500000000000000000 wei;
1476         }
1477         if (currentTotalFighters >= 5000 && currentTotalFighters < 5500) {
1478             return 550000000000000000 wei;
1479         }
1480         if (currentTotalFighters >= 5500 && currentTotalFighters < 6000) {
1481             return 600000000000000000 wei;
1482         }
1483         if (currentTotalFighters >= 6000) {
1484             return 650000000000000000 wei;
1485         }
1486         return 650000000000000000 wei;
1487     }
1488 }
1489 
1490 // File: contracts/CryptoBrawlers.sol
1491 
1492 pragma solidity 0.8.2;
1493 
1494 
1495 
1496 contract CryptoBrawlers is Marketplace, FighterOwnership {
1497     constructor() {
1498         rarityToSkillBuff[LEGENDARY] = 10;
1499         rarityToSkillBuff[EPIC] = 5;
1500         rarityToSkillBuff[RARE] = 3;
1501         rarityToSkillBuff[UNCOMMON] = 1;
1502         rarityToSkillBuff[COMMON] = 0;
1503 
1504         fighters.push(); // phantom 0 index element in the fighters array to begin
1505     }
1506 
1507     function getInfoForFighter(uint256 _fighterId)
1508         external
1509         returns (
1510             uint256 health,
1511             uint256 speed,
1512             uint256 strength,
1513             string memory fighterName,
1514             string memory image,
1515             string memory rarity,
1516             uint256 mintNum
1517         )
1518     {
1519         Fighter memory _fighter = fighters[_fighterId];
1520         return (
1521             _fighter.health,
1522             _fighter.speed,
1523             _fighter.strength,
1524             _fighter.name,
1525             _fighter.image,
1526             _fighter.rarity,
1527             _fighter.mintNum
1528         );
1529     }
1530 }