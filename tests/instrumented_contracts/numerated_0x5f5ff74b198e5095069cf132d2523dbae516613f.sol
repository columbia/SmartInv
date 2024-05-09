1 pragma solidity ^0.4.23;
2 
3 /// @title A facet of MonsterCore that manages special access privileges.
4 /// @dev See the MonsterCore contract documentation to understand how the various contract facets are arranged.
5 contract MonsterAccessControl {
6     // This facet controls access control for MonsterBit. There are four roles managed here:
7     //
8     //     - The CEO: The CEO can reassign other roles and change the addresses of our dependent smart
9     //         contracts. It is also the only role that can unpause the smart contract. It is initially
10     //         set to the address that created the smart contract in the MonsterCore constructor.
11     //
12     //     - The CFO: The CFO can withdraw funds from MonsterCore and its auction contracts.
13     //
14     //     - The COO: The COO can release gen0 monsters to auction, and mint promo monsters.
15     //
16     // It should be noted that these roles are distinct without overlap in their access abilities, the
17     // abilities listed for each role above are exhaustive. In particular, while the CEO can assign any
18     // address to any role, the CEO address itself doesn't have the ability to act in those roles. This
19     // restriction is intentional so that we aren't tempted to use the CEO address frequently out of
20     // convenience. The less we use an address, the less likely it is that we somehow compromise the
21     // account.
22 
23     /// @dev Emited when contract is upgraded - See README.md for updgrade plan
24     event ContractUpgrade(address newContract);
25 
26     // The addresses of the accounts (or contracts) that can execute actions within each roles.
27     address public ceoAddress;
28     address public cfoAddress;
29     address public cooAddress;
30     address ceoBackupAddress;
31 
32     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
33     bool public paused = false;
34 
35     /// @dev Access modifier for CEO-only functionality
36     modifier onlyCEO() {
37         require(msg.sender == ceoAddress || msg.sender == ceoBackupAddress);
38         _;
39     }
40 
41     /// @dev Access modifier for CFO-only functionality
42     modifier onlyCFO() {
43         require(msg.sender == cfoAddress);
44         _;
45     }
46 
47     /// @dev Access modifier for COO-only functionality
48     modifier onlyCOO() {
49         require(msg.sender == cooAddress);
50         _;
51     }
52 
53     modifier onlyCLevel() {
54         require(
55             msg.sender == cooAddress ||
56             msg.sender == ceoAddress ||
57             msg.sender == cfoAddress ||
58             msg.sender == ceoBackupAddress
59         );
60         _;
61     }
62 
63     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
64     /// @param _newCEO The address of the new CEO
65     function setCEO(address _newCEO) external onlyCEO {
66         require(_newCEO != address(0));
67 
68         ceoAddress = _newCEO;
69     }
70 
71     /// @dev Assigns a new address to act as the CFO. Only available to the current CEO.
72     /// @param _newCFO The address of the new CFO
73     function setCFO(address _newCFO) external onlyCEO {
74         require(_newCFO != address(0));
75 
76         cfoAddress = _newCFO;
77     }
78 
79     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
80     /// @param _newCOO The address of the new COO
81     function setCOO(address _newCOO) external onlyCEO {
82         require(_newCOO != address(0));
83 
84         cooAddress = _newCOO;
85     }
86 
87     /*** Pausable functionality adapted from OpenZeppelin ***/
88 
89     /// @dev Modifier to allow actions only when the contract IS NOT paused
90     modifier whenNotPaused() {
91         require(!paused);
92         _;
93     }
94 
95     /// @dev Modifier to allow actions only when the contract IS paused
96     modifier whenPaused {
97         require(paused);
98         _;
99     }
100 
101     /// @dev Called by any "C-level" role to pause the contract. Used only when
102     ///  a bug or exploit is detected and we need to limit damage.
103     function pause() external onlyCLevel whenNotPaused {
104         paused = true;
105     }
106 
107     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
108     ///  one reason we may pause the contract is when CFO or COO accounts are
109     ///  compromised.
110     /// @notice This is public rather than external so it can be called by
111     ///  derived contracts.
112     function unpause() public onlyCEO whenPaused {
113         // can't unpause if contract was upgraded
114         paused = false;
115     }
116 }
117 
118 interface SaleClockAuction {
119     function isSaleClockAuction() external view returns (bool);
120     function createAuction(uint, uint, uint, uint, address) external;
121     function withdrawBalance() external;
122 }
123 interface SiringClockAuction {
124     function isSiringClockAuction() external view returns (bool);
125     function createAuction(uint, uint, uint, uint, address) external;
126     function withdrawBalance() external;
127     function getCurrentPrice(uint256) external view returns (uint256);
128     function bid(uint256) external payable;
129 }
130 interface MonsterBattles {
131     function isBattleContract() external view returns (bool);
132     function prepareForBattle(address, uint, uint, uint) external payable returns(uint);
133     function withdrawFromBattle(address, uint, uint, uint) external returns(uint);
134     function finishBattle(address, uint, uint, uint) external returns(uint, uint, uint);
135     function withdrawBalance() external;
136 }
137 interface MonsterFood {
138     function isMonsterFood() external view returns (bool);
139     function feedMonster(address, uint, uint, uint, uint) external payable  returns(uint, uint, uint);
140     function withdrawBalance() external;
141 }
142 // interface MonsterStorage {
143 //     function isMonsterStorage() external view returns (bool);
144 //     function ownershipTokenCount(address) external view returns (uint);
145 //     function setOwnershipTokenCount(address, uint) external;
146 //     function setActionCooldown(uint, uint, uint, uint, uint, uint) external;
147 //     function createMonster(uint, uint, uint) external returns (uint);
148 //     function getMonsterBits(uint) external view returns(uint, uint, uint);
149 //     function monsterIndexToOwner(uint256) external view returns(address);
150 //     function setMonsterIndexToOwner(uint, address) external;
151 //     function monsterIndexToApproved(uint256) external view returns(address);
152 //     function setMonsterIndexToApproved(uint, address) external;
153 //     function getMonstersCount() external view returns(uint);
154 //     function sireAllowedToAddress(uint256) external view returns(address);
155 //     function setSireAllowedToAddress(uint, address) external;
156 //     function setSiringWith(uint, uint) external;
157     
158 // }
159 interface MonsterConstants {
160     function isMonsterConstants() external view returns (bool);
161     function actionCooldowns(uint) external view returns (uint32);
162     function actionCooldownsLength() external view returns(uint);
163     
164     function growCooldowns(uint) external view returns (uint32);
165     function genToGrowCdIndex(uint) external view returns (uint8);
166     function genToGrowCdIndexLength() external view returns(uint);
167     
168 }
169 contract MonsterGeneticsInterface {
170     /// @dev simply a boolean to indicate this is the contract we expect to be
171     function isMonsterGenetics() public pure returns (bool);
172 
173     /// @dev given genes of monster 1 & 2, return a genetic combination - may have a random factor
174     /// @param genesMatron genes of mom
175     /// @param genesSire genes of sire
176     /// @return the genes that are supposed to be passed down the child
177     function mixGenes(uint256 genesMatron, uint256 genesSire, uint256 targetBlock) public view returns (uint256 _result);
178     
179     function mixBattleGenes(uint256 genesMatron, uint256 genesSire, uint256 targetBlock) public view returns (uint256 _result);
180 }
181 
182 library MonsterLib {
183     
184     //max uint constant for bit operations
185     uint constant UINT_MAX = uint(2) ** 256 - 1;
186     
187     function getBits(uint256 source, uint offset, uint count) public pure returns(uint256 bits_)
188     {
189         uint256 mask = (uint(2) ** count - 1) * uint(2) ** offset;
190         return (source & mask) / uint(2) ** offset;
191     }
192     
193     function setBits(uint target, uint bits, uint size, uint offset) public pure returns(uint)
194     {
195         //ensure bits do not exccess declared size
196         uint256 truncateMask = uint(2) ** size - 1;
197         bits = bits & truncateMask;
198         
199         //shift in place
200         bits = bits * uint(2) ** offset;
201         
202         uint clearMask = ((uint(2) ** size - 1) * (uint(2) ** offset)) ^ UINT_MAX;
203         target = target & clearMask;
204         target = target | bits;
205         return target;
206         
207     }
208     
209     /// @dev The main Monster struct. Every monster in MonsterBit is represented by a copy
210     ///  of this structure, so great care was taken to ensure that it fits neatly into
211     ///  exactly two 256-bit words. Note that the order of the members in this structure
212     ///  is important because of the byte-packing rules used by Ethereum.
213     ///  Ref: http://solidity.readthedocs.io/en/develop/miscellaneous.html
214     struct Monster {
215         // The Monster's genetic code is packed into these 256-bits, the format is
216         // sooper-sekret! A monster's genes never change.
217         uint256 genes;
218         
219         // The timestamp from the block when this monster came into existence.
220         uint64 birthTime;
221         
222         // The "generation number" of this monster. Monsters minted by the CK contract
223         // for sale are called "gen0" and have a generation number of 0. The
224         // generation number of all other monsters is the larger of the two generation
225         // numbers of their parents, plus one.
226         // (i.e. max(matron.generation, sire.generation) + 1)
227         uint16 generation;
228         
229         // The minimum timestamp after which this monster can engage in breeding
230         // activities again. This same timestamp is used for the pregnancy
231         // timer (for matrons) as well as the siring cooldown.
232         uint64 cooldownEndTimestamp;
233         
234         // The ID of the parents of this monster, set to 0 for gen0 monsters.
235         // Note that using 32-bit unsigned integers limits us to a "mere"
236         // 4 billion monsters. This number might seem small until you realize
237         // that Ethereum currently has a limit of about 500 million
238         // transactions per year! So, this definitely won't be a problem
239         // for several years (even as Ethereum learns to scale).
240         uint32 matronId;
241         uint32 sireId;
242         
243         // Set to the ID of the sire monster for matrons that are pregnant,
244         // zero otherwise. A non-zero value here is how we know a monster
245         // is pregnant. Used to retrieve the genetic material for the new
246         // monster when the birth transpires.
247         uint32 siringWithId;
248         
249         // Set to the index in the cooldown array (see below) that represents
250         // the current cooldown duration for this monster. This starts at zero
251         // for gen0 cats, and is initialized to floor(generation/2) for others.
252         // Incremented by one for each successful breeding action, regardless
253         // of whether this monster is acting as matron or sire.
254         uint16 cooldownIndex;
255         
256         // Monster genetic code for battle attributes
257         uint64 battleGenes;
258         
259         uint8 activeGrowCooldownIndex;
260         uint8 activeRestCooldownIndex;
261         
262         uint8 level;
263         
264         uint8 potionEffect;
265         uint64 potionExpire;
266         
267         uint64 cooldownStartTimestamp;
268         
269         uint8 battleCounter;
270     }
271     
272 
273     function encodeMonsterBits(Monster mon) internal pure returns(uint p1, uint p2, uint p3)
274     {
275         p1 = mon.genes;
276         
277         p2 = 0;
278         p2 = setBits(p2, mon.cooldownEndTimestamp, 64, 0);
279         p2 = setBits(p2, mon.potionExpire, 64, 64);
280         p2 = setBits(p2, mon.cooldownStartTimestamp, 64, 128);
281         p2 = setBits(p2, mon.birthTime, 64, 192);
282         
283         p3 = 0;
284         p3 = setBits(p3, mon.generation, 16, 0);
285         p3 = setBits(p3, mon.matronId, 32, 16);
286         p3 = setBits(p3, mon.sireId, 32, 48);
287         p3 = setBits(p3, mon.siringWithId, 32, 80);
288         p3 = setBits(p3, mon.cooldownIndex, 16, 112);
289         p3 = setBits(p3, mon.battleGenes, 64, 128);
290         p3 = setBits(p3, mon.activeGrowCooldownIndex, 8, 192);
291         p3 = setBits(p3, mon.activeRestCooldownIndex, 8, 200);
292         p3 = setBits(p3, mon.level, 8, 208);
293         p3 = setBits(p3, mon.potionEffect, 8, 216);
294         p3 = setBits(p3, mon.battleCounter, 8, 224);
295     }
296     
297     function decodeMonsterBits(uint p1, uint p2, uint p3) internal pure returns(Monster mon)
298     {
299         mon = MonsterLib.Monster({
300             genes: 0,
301             birthTime: 0,
302             cooldownEndTimestamp: 0,
303             matronId: 0,
304             sireId: 0,
305             siringWithId: 0,
306             cooldownIndex: 0,
307             generation: 0,
308             battleGenes: 0,
309             level: 0,
310             activeGrowCooldownIndex: 0,
311             activeRestCooldownIndex: 0,
312             potionEffect: 0,
313             potionExpire: 0,
314             cooldownStartTimestamp: 0,
315             battleCounter: 0
316         });
317         
318         mon.genes = p1;
319         
320         mon.cooldownEndTimestamp = uint64(getBits(p2, 0, 64));
321         mon.potionExpire = uint64(getBits(p2, 64, 64));
322         mon.cooldownStartTimestamp = uint64(getBits(p2, 128, 64));
323         mon.birthTime = uint64(getBits(p2, 192, 64));
324         mon.generation = uint16(getBits(p3, 0, 16));
325         mon.matronId = uint32(getBits(p3, 16, 32));
326         mon.sireId = uint32(getBits(p3, 48, 32));
327         mon.siringWithId = uint32(getBits(p3, 80, 32));
328         mon.cooldownIndex = uint16(getBits(p3, 112, 16));
329         mon.battleGenes = uint64(getBits(p3, 128, 64));
330         mon.activeGrowCooldownIndex = uint8(getBits(p3, 192, 8));
331         mon.activeRestCooldownIndex = uint8(getBits(p3, 200, 8));
332         mon.level = uint8(getBits(p3, 208, 8));
333         mon.potionEffect = uint8(getBits(p3, 216, 8));
334         mon.battleCounter = uint8(getBits(p3, 224, 8));
335     }
336 }
337 
338 /**
339  * @title Ownable
340  * @dev The Ownable contract has an owner address, and provides basic authorization control
341  * functions, this simplifies the implementation of "user permissions".
342  */
343 contract Ownable {
344   address public owner;
345 
346 
347   /**
348    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
349    * account.
350    */
351   constructor() public {
352     owner = msg.sender;
353   }
354 
355 
356   /**
357    * @dev Throws if called by any account other than the owner.
358    */
359   modifier onlyOwner() {
360     require(msg.sender == owner);
361     _;
362   }
363 
364 
365   /**
366    * @dev Allows the current owner to transfer control of the contract to a newOwner.
367    * @param newOwner The address to transfer ownership to.
368    */
369   function transferOwnership(address newOwner) public onlyOwner {
370     if (newOwner != address(0)) {
371       owner = newOwner;
372     }
373   }
374 
375 }
376 
377 
378 contract MonsterStorage is Ownable
379 {
380     ERC721 public nonFungibleContract;
381     
382     bool public isMonsterStorage = true;
383     
384     constructor(address _nftAddress) public
385     {
386         ERC721 candidateContract = ERC721(_nftAddress);
387         nonFungibleContract = candidateContract;
388         MonsterLib.Monster memory mon = MonsterLib.decodeMonsterBits(uint(-1), 0, 0);
389         _createMonster(mon);
390         monsterIndexToOwner[0] = address(0);
391     }
392     
393     function setTokenContract(address _nftAddress) external onlyOwner
394     {
395         ERC721 candidateContract = ERC721(_nftAddress);
396         nonFungibleContract = candidateContract;
397     }
398     
399     modifier onlyCore() {
400         require(msg.sender != address(0) && msg.sender == address(nonFungibleContract));
401         _;
402     }
403     
404     /*** STORAGE ***/
405 
406     /// @dev An array containing the Monster struct for all Monsters in existence. The ID
407     ///  of each monster is actually an index into this array. Note that ID 0 is a negamonster,
408     ///  the unMonster, the mythical beast that is the parent of all gen0 monsters. A bizarre
409     ///  creature that is both matron and sire... to itself! Has an invalid genetic code.
410     ///  In other words, monster ID 0 is invalid... ;-)
411     MonsterLib.Monster[] monsters;
412     
413     uint256 public pregnantMonsters;
414     
415     function setPregnantMonsters(uint newValue) onlyCore public
416     {
417         pregnantMonsters = newValue;
418     }
419     
420     function getMonstersCount() public view returns(uint) 
421     {
422         return monsters.length;
423     }
424     
425     
426     /// @dev A mapping from monster IDs to the address that owns them. All monsters have
427     ///  some valid owner address, even gen0 monsters are created with a non-zero owner.
428     mapping (uint256 => address) public monsterIndexToOwner;
429     
430     function setMonsterIndexToOwner(uint index, address owner) onlyCore public
431     {
432         monsterIndexToOwner[index] = owner;
433     }
434 
435     // @dev A mapping from owner address to count of tokens that address owns.
436     //  Used internally inside balanceOf() to resolve ownership count.
437     mapping (address => uint256) public ownershipTokenCount;
438     
439     function setOwnershipTokenCount(address owner, uint count) onlyCore public
440     {
441         ownershipTokenCount[owner] = count;
442     }
443 
444     /// @dev A mapping from MonsterIDs to an address that has been approved to call
445     ///  transferFrom(). Each Monster can only have one approved address for transfer
446     ///  at any time. A zero value means no approval is outstanding.
447     mapping (uint256 => address) public monsterIndexToApproved;
448     
449     function setMonsterIndexToApproved(uint index, address approved) onlyCore public
450     {
451         if(approved == address(0))
452         {
453             delete monsterIndexToApproved[index];
454         }
455         else
456         {
457             monsterIndexToApproved[index] = approved;
458         }
459     }
460     
461     /// @dev A mapping from MonsterIDs to an address that has been approved to use
462     ///  this monster for siring via breedWith(). Each monster can only have one approved
463     ///  address for siring at any time. A zero value means no approval is outstanding.
464     mapping (uint256 => address) public sireAllowedToAddress;
465     
466     function setSireAllowedToAddress(uint index, address allowed) onlyCore public
467     {
468         if(allowed == address(0))
469         {
470             delete sireAllowedToAddress[index];
471         }
472         else 
473         {
474             sireAllowedToAddress[index] = allowed;
475         }
476     }
477     
478     /// @dev An internal method that creates a new monster and stores it. This
479     ///  method doesn't do any checking and should only be called when the
480     ///  input data is known to be valid. Will generate both a Birth event
481     ///  and a Transfer event.
482 
483     function createMonster(uint p1, uint p2, uint p3)
484         onlyCore
485         public
486         returns (uint)
487     {
488 
489         MonsterLib.Monster memory mon = MonsterLib.decodeMonsterBits(p1, p2, p3);
490 
491 
492         uint256 newMonsterId = _createMonster(mon);
493 
494         // It's probably never going to happen, 4 billion monsters is A LOT, but
495         // let's just be 100% sure we never let this happen.
496         require(newMonsterId == uint256(uint32(newMonsterId)));
497 
498         return newMonsterId;
499     }
500     
501     function _createMonster(MonsterLib.Monster mon) internal returns(uint)
502     {
503         uint256 newMonsterId = monsters.push(mon) - 1;
504         
505         return newMonsterId;
506     }
507     
508     function setLevel(uint monsterId, uint level) onlyCore public
509     {
510         MonsterLib.Monster storage mon = monsters[monsterId];
511         mon.level = uint8(level);
512     }
513     
514     function setPotion(uint monsterId, uint potionEffect, uint potionExpire) onlyCore public
515     {
516         MonsterLib.Monster storage mon = monsters[monsterId];
517         mon.potionEffect = uint8(potionEffect);
518         mon.potionExpire = uint64(potionExpire);
519     }
520     
521 
522     function setBattleCounter(uint monsterId, uint battleCounter) onlyCore public
523     {
524         MonsterLib.Monster storage mon = monsters[monsterId];
525         mon.battleCounter = uint8(battleCounter);
526     }
527     
528     function setActionCooldown(uint monsterId, 
529     uint cooldownIndex, 
530     uint cooldownEndTimestamp, 
531     uint cooldownStartTimestamp,
532     uint activeGrowCooldownIndex, 
533     uint activeRestCooldownIndex) onlyCore public
534     {
535         MonsterLib.Monster storage mon = monsters[monsterId];
536         mon.cooldownIndex = uint16(cooldownIndex);
537         mon.cooldownEndTimestamp = uint64(cooldownEndTimestamp);
538         mon.cooldownStartTimestamp = uint64(cooldownStartTimestamp);
539         mon.activeRestCooldownIndex = uint8(activeRestCooldownIndex);
540         mon.activeGrowCooldownIndex = uint8(activeGrowCooldownIndex);
541     }
542     
543     function setSiringWith(uint monsterId, uint siringWithId) onlyCore public
544     {
545         MonsterLib.Monster storage mon = monsters[monsterId];
546         if(siringWithId == 0)
547         {
548             delete mon.siringWithId;
549         }
550         else
551         {
552             mon.siringWithId = uint32(siringWithId);
553         }
554     }
555     
556     
557     function getMonsterBits(uint monsterId) public view returns(uint p1, uint p2, uint p3)
558     {
559         MonsterLib.Monster storage mon = monsters[monsterId];
560         (p1, p2, p3) = MonsterLib.encodeMonsterBits(mon);
561     }
562     
563     function setMonsterBits(uint monsterId, uint p1, uint p2, uint p3) onlyCore public
564     {
565         MonsterLib.Monster storage mon = monsters[monsterId];
566         MonsterLib.Monster memory mon2 = MonsterLib.decodeMonsterBits(p1, p2, p3);
567         mon.cooldownIndex = mon2.cooldownIndex;
568         mon.siringWithId = mon2.siringWithId;
569         mon.activeGrowCooldownIndex = mon2.activeGrowCooldownIndex;
570         mon.activeRestCooldownIndex = mon2.activeRestCooldownIndex;
571         mon.level = mon2.level;
572         mon.potionEffect = mon2.potionEffect;
573         mon.cooldownEndTimestamp = mon2.cooldownEndTimestamp;
574         mon.potionExpire = mon2.potionExpire;
575         mon.cooldownStartTimestamp = mon2.cooldownStartTimestamp;
576         mon.battleCounter = mon2.battleCounter;
577         
578     }
579     
580     function setMonsterBitsFull(uint monsterId, uint p1, uint p2, uint p3) onlyCore public
581     {
582         MonsterLib.Monster storage mon = monsters[monsterId];
583         MonsterLib.Monster memory mon2 = MonsterLib.decodeMonsterBits(p1, p2, p3);
584         mon.birthTime = mon2.birthTime;
585         mon.generation = mon2.generation;
586         mon.genes = mon2.genes;
587         mon.battleGenes = mon2.battleGenes;
588         mon.cooldownIndex = mon2.cooldownIndex;
589         mon.matronId = mon2.matronId;
590         mon.sireId = mon2.sireId;
591         mon.siringWithId = mon2.siringWithId;
592         mon.activeGrowCooldownIndex = mon2.activeGrowCooldownIndex;
593         mon.activeRestCooldownIndex = mon2.activeRestCooldownIndex;
594         mon.level = mon2.level;
595         mon.potionEffect = mon2.potionEffect;
596         mon.cooldownEndTimestamp = mon2.cooldownEndTimestamp;
597         mon.potionExpire = mon2.potionExpire;
598         mon.cooldownStartTimestamp = mon2.cooldownStartTimestamp;
599         mon.battleCounter = mon2.battleCounter;
600         
601     }
602 }
603 
604 
605 /// @title Base contract for MonsterBit. Holds all common structs, events and base variables.
606 /// @dev See the MonsterCore contract documentation to understand how the various contract facets are arranged.
607 contract MonsterBase is MonsterAccessControl {
608     /*** EVENTS ***/
609 
610     /// @dev The Birth event is fired whenever a new monster comes into existence. This obviously
611     ///  includes any time a monster is created through the giveBirth method, but it is also called
612     ///  when a new gen0 monster is created.
613     event Birth(address owner, uint256 monsterId, uint256 genes);
614 
615     /// @dev Transfer event as defined in current draft of ERC721. Emitted every time a monster
616     ///  ownership is assigned, including births.
617     event Transfer(address from, address to, uint256 tokenId);
618 
619 
620     /// @dev The address of the ClockAuction contract that handles sales of Monsters. This
621     ///  same contract handles both peer-to-peer sales as well as the gen0 sales which are
622     ///  initiated every 15 minutes.
623     SaleClockAuction public saleAuction;
624     SiringClockAuction public siringAuction;
625     MonsterBattles public battlesContract;
626     MonsterFood public monsterFood;
627     MonsterStorage public monsterStorage;
628     MonsterConstants public monsterConstants;
629     
630     /// @dev The address of the sibling contract that is used to implement the sooper-sekret
631     ///  genetic combination algorithm.
632     MonsterGeneticsInterface public geneScience;
633     
634     function setMonsterStorageAddress(address _address) external onlyCEO {
635         MonsterStorage candidateContract = MonsterStorage(_address);
636 
637         // NOTE: verify that a contract is what we expect
638         require(candidateContract.isMonsterStorage());
639 
640         // Set the new contract address
641         monsterStorage = candidateContract;
642     }
643     
644     function setMonsterConstantsAddress(address _address) external onlyCEO {
645         MonsterConstants candidateContract = MonsterConstants(_address);
646 
647         // NOTE: verify that a contract is what we expect
648         require(candidateContract.isMonsterConstants());
649 
650         // Set the new contract address
651         monsterConstants = candidateContract;
652     }
653     
654     /// @dev Sets the reference to the battles contract.
655     /// @param _address - Address of battles contract.
656     function setBattlesAddress(address _address) external onlyCEO {
657         MonsterBattles candidateContract = MonsterBattles(_address);
658 
659         // NOTE: verify that a contract is what we expect
660         require(candidateContract.isBattleContract());
661 
662         // Set the new contract address
663         battlesContract = candidateContract;
664     }
665 
666 
667     /// @dev Assigns ownership of a specific Monster to an address.
668     function _transfer(address _from, address _to, uint256 _tokenId) internal {
669         // Since the number of monsters is capped to 2^32 we can't overflow this
670         uint count = monsterStorage.ownershipTokenCount(_to);
671         monsterStorage.setOwnershipTokenCount(_to, count + 1);
672         
673         // transfer ownership
674         monsterStorage.setMonsterIndexToOwner(_tokenId, _to);
675         // When creating new monsters _from is 0x0, but we can't account that address.
676         if (_from != address(0)) {
677             count =  monsterStorage.ownershipTokenCount(_from);
678             monsterStorage.setOwnershipTokenCount(_from, count - 1);
679             // clear any previously approved ownership exchange
680             monsterStorage.setMonsterIndexToApproved(_tokenId, address(0));
681         }
682         
683         if(_from == address(saleAuction))
684         {
685             MonsterLib.Monster memory monster = readMonster(_tokenId);
686             if(monster.level == 0)
687             {
688                 monsterStorage.setActionCooldown(_tokenId, 
689                     monster.cooldownIndex, 
690                     uint64(now + monsterConstants.growCooldowns(monster.activeGrowCooldownIndex)), 
691                     now,
692                     monster.activeGrowCooldownIndex, 
693                     monster.activeRestCooldownIndex);
694             }
695         }
696         // Emit the transfer event.
697         emit Transfer(_from, _to, _tokenId);
698     }
699 
700     /// @dev An internal method that creates a new monster and stores it. This
701     ///  method doesn't do any checking and should only be called when the
702     ///  input data is known to be valid. Will generate both a Birth event
703     ///  and a Transfer event.
704     /// @param _generation The generation number of this monster, must be computed by caller.
705     /// @param _genes The monster's genetic code.
706     /// @param _owner The inital owner of this monster, must be non-zero (except for the unMonster, ID 0)
707     function _createMonster(
708         uint256 _matronId,
709         uint256 _sireId,
710         uint256 _generation,
711         uint256 _genes,
712         uint256 _battleGenes,
713         uint256 _level,
714         address _owner
715     )
716         internal
717         returns (uint)
718     {
719         require(_matronId == uint256(uint32(_matronId)));
720         require(_sireId == uint256(uint32(_sireId)));
721         require(_generation == uint256(uint16(_generation)));
722         
723         
724         
725         MonsterLib.Monster memory _monster = MonsterLib.Monster({
726             genes: _genes,
727             birthTime: uint64(now),
728             cooldownEndTimestamp: 0,
729             matronId: uint32(_matronId),
730             sireId: uint32(_sireId),
731             siringWithId: uint32(0),
732             cooldownIndex: uint16(0),
733             generation: uint16(_generation),
734             battleGenes: uint64(_battleGenes),
735             level: uint8(_level),
736             activeGrowCooldownIndex: uint8(0),
737             activeRestCooldownIndex: uint8(0),
738             potionEffect: uint8(0),
739             potionExpire: uint64(0),
740             cooldownStartTimestamp: 0,
741             battleCounter: uint8(0)
742         });
743         
744         
745         setMonsterGrow(_monster);
746         (uint p1, uint p2, uint p3) = MonsterLib.encodeMonsterBits(_monster);
747         
748         uint monsterId = monsterStorage.createMonster(p1, p2, p3);
749 
750         // emit the birth event
751         emit Birth(
752             _owner,
753             monsterId,
754             _genes
755         );
756 
757         // This will assign ownership, and also emit the Transfer event as
758         // per ERC721 draft
759         _transfer(0, _owner, monsterId);
760 
761         return monsterId;
762     }
763     
764     function setMonsterGrow(MonsterLib.Monster monster) internal view
765     {
766          //New monster starts with the same cooldown as parent gen/2
767         uint16 cooldownIndex = uint16(monster.generation / 2);
768         if (cooldownIndex > 13) {
769             cooldownIndex = 13;
770         }
771         
772         monster.cooldownIndex = uint16(cooldownIndex);
773         
774         if(monster.level == 0)
775         {
776             uint gen = monster.generation;
777             if(gen > monsterConstants.genToGrowCdIndexLength())
778             {
779                 gen = monsterConstants.genToGrowCdIndexLength();
780             }
781             
782             monster.activeGrowCooldownIndex = monsterConstants.genToGrowCdIndex(gen);
783             monster.cooldownEndTimestamp = uint64(now + monsterConstants.growCooldowns(monster.activeGrowCooldownIndex));
784             monster.cooldownStartTimestamp = uint64(now);
785         }
786     }
787     
788     function readMonster(uint monsterId) internal view returns(MonsterLib.Monster)
789     {
790         (uint p1, uint p2, uint p3) = monsterStorage.getMonsterBits(monsterId);
791        
792         MonsterLib.Monster memory mon = MonsterLib.decodeMonsterBits(p1, p2, p3);
793          
794         return mon;
795     }
796 }
797 
798 
799 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
800 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
801 contract ERC721 {
802     // Required methods
803     function totalSupply() public view returns (uint256 total);
804     function balanceOf(address _owner) public view returns (uint256 balance);
805     function ownerOf(uint256 _tokenId) external view returns (address owner);
806     function approve(address _to, uint256 _tokenId) external;
807     function transfer(address _to, uint256 _tokenId) external;
808     function transferFrom(address _from, address _to, uint256 _tokenId) external;
809 
810     // Events
811     event Transfer(address from, address to, uint256 tokenId);
812     event Approval(address owner, address approved, uint256 tokenId);
813 }
814 
815 /// @title The facet of the MonsterBit core contract that manages ownership, ERC-721 (draft) compliant.
816 /// @dev Ref: https://github.com/ethereum/EIPs/issues/721
817 ///  See the MonsterCore contract documentation to understand how the various contract facets are arranged.
818 contract MonsterOwnership is MonsterBase, ERC721 {
819 
820     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
821     string public constant name = "MonsterBit";
822     string public constant symbol = "MB";
823 
824     /// @dev Checks if a given address is the current owner of a particular Monster.
825     /// @param _claimant the address we are validating against.
826     /// @param _tokenId monster id, only valid when > 0
827     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
828         return monsterStorage.monsterIndexToOwner(_tokenId) == _claimant;
829     }
830 
831     /// @dev Checks if a given address currently has transferApproval for a particular Monster.
832     /// @param _claimant the address we are confirming monster is approved for.
833     /// @param _tokenId monster id, only valid when > 0
834     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
835         return monsterStorage.monsterIndexToApproved(_tokenId) == _claimant;
836     }
837 
838     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
839     ///  approval. Setting _approved to address(0) clears all transfer approval.
840     ///  NOTE: _approve() does NOT send the Approval event. This is intentional because
841     ///  _approve() and transferFrom() are used together for putting Monsters on auction, and
842     ///  there is no value in spamming the log with Approval events in that case.
843     function _approve(uint256 _tokenId, address _approved) internal {
844         monsterStorage.setMonsterIndexToApproved(_tokenId, _approved);
845     }
846 
847     /// @notice Returns the number of Monsters owned by a specific address.
848     /// @param _owner The owner address to check.
849     /// @dev Required for ERC-721 compliance
850     function balanceOf(address _owner) public view returns (uint256 count) {
851         return monsterStorage.ownershipTokenCount(_owner);
852     }
853 
854     /// @notice Transfers a Monster to another address. If transferring to a smart
855     ///  contract be VERY CAREFUL to ensure that it is aware of ERC-721 (or
856     ///  MonsterBit specifically) or your Monster may be lost forever. Seriously.
857     /// @param _to The address of the recipient, can be a user or contract.
858     /// @param _tokenId The ID of the Monster to transfer.
859     /// @dev Required for ERC-721 compliance.
860     function transfer(
861         address _to,
862         uint256 _tokenId
863     )
864         external
865         whenNotPaused
866     {
867         // Safety check to prevent against an unexpected 0x0 default.
868         require(_to != address(0));
869         // Disallow transfers to this contract to prevent accidental misuse.
870         // The contract should never own any monsters (except very briefly
871         // after a gen0 monster is created and before it goes on auction).
872         require(_to != address(this));
873         // Disallow transfers to the auction contracts to prevent accidental
874         // misuse. Auction contracts should only take ownership of monsters
875         // through the allow + transferFrom flow.
876         require(_to != address(saleAuction));
877 
878         // You can only send your own monster.
879         require(_owns(msg.sender, _tokenId));
880 
881         // Reassign ownership, clear pending approvals, emit Transfer event.
882         _transfer(msg.sender, _to, _tokenId);
883     }
884 
885     /// @notice Grant another address the right to transfer a specific Monster via
886     ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
887     /// @param _to The address to be granted transfer approval. Pass address(0) to
888     ///  clear all approvals.
889     /// @param _tokenId The ID of the Monster that can be transferred if this call succeeds.
890     /// @dev Required for ERC-721 compliance.
891     function approve(
892         address _to,
893         uint256 _tokenId
894     )
895         external
896         whenNotPaused
897     {
898         // Only an owner can grant transfer approval.
899         require(_owns(msg.sender, _tokenId));
900 
901         // Register the approval (replacing any previous approval).
902         _approve(_tokenId, _to);
903 
904         // Emit approval event.
905         emit Approval(msg.sender, _to, _tokenId);
906     }
907 
908     /// @notice Transfer a Monster owned by another address, for which the calling address
909     ///  has previously been granted transfer approval by the owner.
910     /// @param _from The address that owns the Monster to be transfered.
911     /// @param _to The address that should take ownership of the Monster. Can be any address,
912     ///  including the caller.
913     /// @param _tokenId The ID of the Monster to be transferred.
914     /// @dev Required for ERC-721 compliance.
915     function transferFrom(
916         address _from,
917         address _to,
918         uint256 _tokenId
919     )
920         external
921         whenNotPaused
922     {
923         // Safety check to prevent against an unexpected 0x0 default.
924         require(_to != address(0));
925         // Disallow transfers to this contract to prevent accidental misuse.
926         // The contract should never own any monsters (except very briefly
927         // after a gen0 monster is created and before it goes on auction).
928         require(_to != address(this));
929         // Check for approval and valid ownership
930         require(_approvedFor(msg.sender, _tokenId));
931         require(_owns(_from, _tokenId));
932 
933         // Reassign ownership (also clears pending approvals and emits Transfer event).
934         _transfer(_from, _to, _tokenId);
935     }
936 
937     /// @notice Returns the total number of Monsters currently in existence.
938     /// @dev Required for ERC-721 compliance.
939     function totalSupply() public view returns (uint) {
940         return monsterStorage.getMonstersCount() - 1;
941     }
942 
943     /// @notice Returns the address currently assigned ownership of a given Monster.
944     /// @dev Required for ERC-721 compliance.
945     function ownerOf(uint256 _tokenId)
946         external
947         view
948         returns (address owner)
949     {
950         owner = monsterStorage.monsterIndexToOwner(_tokenId);
951 
952         require(owner != address(0));
953     }
954 
955     /// @notice Returns a list of all Monster IDs assigned to an address.
956     /// @param _owner The owner whose Monsters we are interested in.
957     /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
958     ///  expensive (it walks the entire Monster array looking for monsters belonging to owner),
959     ///  but it also returns a dynamic array, which is only supported for web3 calls, and
960     ///  not contract-to-contract calls.
961     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
962         uint256 tokenCount = balanceOf(_owner);
963 
964         if (tokenCount == 0) {
965             // Return an empty array
966             return new uint256[](0);
967         } else {
968             uint256[] memory result = new uint256[](tokenCount);
969             uint256 totalMonsters = totalSupply();
970             uint256 resultIndex = 0;
971 
972             // We count on the fact that all monsters have IDs starting at 1 and increasing
973             // sequentially up to the totalMonsters count.
974             uint256 monsterId;
975 
976             for (monsterId = 1; monsterId <= totalMonsters; monsterId++) {
977                 if (monsterStorage.monsterIndexToOwner(monsterId) == _owner) {
978                     result[resultIndex] = monsterId;
979                     resultIndex++;
980                 }
981             }
982 
983             return result;
984         }
985     }
986 }
987 
988 /// @title A facet of MosterBitCore that manages Monster siring, gestation, and birth.
989 contract MonsterBreeding is MonsterOwnership {
990 
991     /// @dev The Pregnant event is fired when two monster successfully breed and the pregnancy
992     ///  timer begins for the matron.
993     event Pregnant(address owner, uint256 matronId, uint256 sireId, uint256 cooldownEndTimestamp);
994 
995     /// @notice The minimum payment required to use breedWithAuto(). This fee goes towards
996     ///  the gas cost paid by whatever calls giveBirth(), and can be dynamically updated by
997     ///  the COO role as the gas price changes.
998     uint256 public autoBirthFee = 2 finney;
999     uint256 public birthCommission = 5 finney;
1000     
1001     
1002 
1003     
1004 
1005     /// @dev Update the address of the genetic contract, can only be called by the CEO.
1006     /// @param _address An address of a GeneScience contract instance to be used from this point forward.
1007     function setGeneScienceAddress(address _address) external onlyCEO {
1008         MonsterGeneticsInterface candidateContract = MonsterGeneticsInterface(_address);
1009 
1010         // NOTE: verify that a contract is what we expect
1011         require(candidateContract.isMonsterGenetics());
1012 
1013         // Set the new contract address
1014         geneScience = candidateContract;
1015     }
1016     
1017     function setSiringAuctionAddress(address _address) external onlyCEO {
1018         SiringClockAuction candidateContract = SiringClockAuction(_address);
1019 
1020         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
1021         require(candidateContract.isSiringClockAuction());
1022 
1023         // Set the new contract address
1024         siringAuction = candidateContract;
1025     }
1026 
1027     /// @dev Checks that a given monster is able to breed. Requires that the
1028     ///  current cooldown is finished (for sires) and also checks that there is
1029     ///  no pending pregnancy.
1030     function _isReadyToBreed(MonsterLib.Monster _monster) internal view returns (bool) {
1031         // In addition to checking the cooldownEndTimestamp, we also need to check to see if
1032         // the cat has a pending birth; there can be some period of time between the end
1033         // of the pregnacy timer and the birth event.
1034         return (_monster.siringWithId == 0) && (_monster.cooldownEndTimestamp <= uint64(now) && (_monster.level >= 1));
1035     }
1036 
1037     /// @dev Check if a sire has authorized breeding with this matron. True if both sire
1038     ///  and matron have the same owner, or if the sire has given siring permission to
1039     ///  the matron's owner (via approveSiring()).
1040     function _isSiringPermitted(uint256 _sireId, uint256 _matronId) internal view returns (bool) {
1041         address matronOwner = monsterStorage.monsterIndexToOwner(_matronId);
1042         address sireOwner = monsterStorage.monsterIndexToOwner(_sireId);
1043 
1044         // Siring is okay if they have same owner, or if the matron's owner was given
1045         // permission to breed with this sire.
1046         return (matronOwner == sireOwner || monsterStorage.sireAllowedToAddress(_sireId) == matronOwner);
1047     }
1048 
1049     /// @dev Set the cooldownEndTime for the given monster, based on its current cooldownIndex.
1050     ///  Also increments the cooldownIndex (unless it has hit the cap).
1051     /// @param _monster A reference to the monster in storage which needs its timer started.
1052     function _triggerCooldown(uint monsterId, MonsterLib.Monster _monster, uint increaseIndex) internal {
1053 
1054         uint activeRestCooldownIndex = _monster.cooldownIndex;
1055         uint cooldownEndTimestamp = uint64(monsterConstants.actionCooldowns(activeRestCooldownIndex) + now);
1056         uint newCooldownIndex = _monster.cooldownIndex;
1057         // Increment the breeding count, clamping it at 13, which is the length of the
1058         // cooldowns array. We could check the array size dynamically, but hard-coding
1059         // this as a constant saves gas. Yay, Solidity!
1060         if(increaseIndex > 0)
1061         {
1062             if (newCooldownIndex + 1 < monsterConstants.actionCooldownsLength()) {
1063                 newCooldownIndex += 1;
1064             }
1065         }
1066         
1067         monsterStorage.setActionCooldown(monsterId, newCooldownIndex, cooldownEndTimestamp, now, 0, activeRestCooldownIndex);
1068     }
1069     
1070     
1071 
1072     /// @notice Grants approval to another user to sire with one of your monsters.
1073     /// @param _addr The address that will be able to sire with your monster. Set to
1074     ///  address(0) to clear all siring approvals for this monster.
1075     /// @param _sireId A monster that you own that _addr will now be able to sire with.
1076     function approveSiring(address _addr, uint256 _sireId)
1077         external
1078         whenNotPaused
1079     {
1080         require(_owns(msg.sender, _sireId));
1081         monsterStorage.setSireAllowedToAddress(_sireId, _addr);
1082     }
1083 
1084     /// @dev Updates the minimum payment required for calling giveBirthAuto(). Can only
1085     ///  be called by the COO address. (This fee is used to offset the gas cost incurred
1086     ///  by the autobirth daemon).
1087     function setAutoBirthFee(uint256 val) external onlyCOO {
1088         autoBirthFee = val;
1089     }
1090     
1091     function setBirthCommission(uint val) external onlyCOO{
1092         birthCommission = val;
1093     }
1094 
1095     /// @dev Checks to see if a given monster is pregnant and (if so) if the gestation
1096     ///  period has passed.
1097     function _isReadyToGiveBirth(MonsterLib.Monster _matron) private view returns (bool) {
1098         return (_matron.siringWithId != 0) && (_matron.cooldownEndTimestamp <= now);
1099     }
1100 
1101     /// @notice Checks that a given monster is able to breed (i.e. it is not pregnant or
1102     ///  in the middle of a siring cooldown).
1103     /// @param _monsterId reference the id of the monster, any user can inquire about it
1104     function isReadyToBreed(uint256 _monsterId)
1105         public
1106         view
1107         returns (bool)
1108     {
1109         require(_monsterId > 0);
1110         MonsterLib.Monster memory monster = readMonster(_monsterId);
1111         return _isReadyToBreed(monster);
1112     }
1113     
1114     /// @dev Internal check to see if a given sire and matron are a valid mating pair. DOES NOT
1115     ///  check ownership permissions (that is up to the caller).
1116     /// @param _matron A reference to the monster struct of the potential matron.
1117     /// @param _matronId The matron's ID.
1118     /// @param _sire A reference to the monster struct of the potential sire.
1119     /// @param _sireId The sire's ID
1120     function _isValidMatingPair(
1121         MonsterLib.Monster _matron,
1122         uint256 _matronId,
1123         MonsterLib.Monster _sire,
1124         uint256 _sireId
1125     )
1126         internal
1127         pure
1128         returns(bool)
1129     {
1130         // A monster can't breed with itself!
1131         if (_matronId == _sireId) {
1132             return false;
1133         }
1134 
1135         // monsters can't breed with their parents.
1136         if (_matron.matronId == _sireId || _matron.sireId == _sireId) {
1137             return false;
1138         }
1139         if (_sire.matronId == _matronId || _sire.sireId == _matronId) {
1140             return false;
1141         }
1142 
1143         // We can short circuit the sibling check (below) if either cat is
1144         // gen zero (has a matron ID of zero).
1145         if (_sire.matronId == 0 || _matron.matronId == 0) {
1146             return true;
1147         }
1148 
1149         // monster can't breed with full or half siblings.
1150         if (_sire.matronId == _matron.matronId || _sire.matronId == _matron.sireId) {
1151             return false;
1152         }
1153         if (_sire.sireId == _matron.matronId || _sire.sireId == _matron.sireId) {
1154             return false;
1155         }
1156 
1157         // Everything seems cool! Let's get DTF.
1158         return true;
1159     }
1160 
1161     /// @dev Checks whether a monster is currently pregnant.
1162     /// @param _monsterId reference the id of the monster, any user can inquire about it
1163     function isPregnant(uint256 _monsterId)
1164         public
1165         view
1166         returns (bool)
1167     {
1168         require(_monsterId > 0);
1169         // A monster is pregnant if and only if this field is set
1170         MonsterLib.Monster memory monster = readMonster(_monsterId);
1171         return monster.siringWithId != 0;
1172     }
1173 
1174     
1175 
1176     /// @dev Internal check to see if a given sire and matron are a valid mating pair for
1177     ///  breeding via auction (i.e. skips ownership and siring approval checks).
1178     function _canBreedWithViaAuction(uint256 _matronId, uint256 _sireId)
1179         internal
1180         view
1181         returns (bool)
1182     {
1183         MonsterLib.Monster memory matron = readMonster(_matronId);
1184         MonsterLib.Monster memory sire = readMonster(_sireId);
1185         return _isValidMatingPair(matron, _matronId, sire, _sireId);
1186     }
1187 
1188     /// @notice Checks to see if two monsters can breed together, including checks for
1189     ///  ownership and siring approvals. Does NOT check that both cats are ready for
1190     ///  breeding (i.e. breedWith could still fail until the cooldowns are finished).
1191     /// @param _matronId The ID of the proposed matron.
1192     /// @param _sireId The ID of the proposed sire.
1193     function canBreedWith(uint256 _matronId, uint256 _sireId)
1194         external
1195         view
1196         returns(bool)
1197     {
1198         require(_matronId > 0);
1199         require(_sireId > 0);
1200         MonsterLib.Monster memory matron = readMonster(_matronId);
1201         MonsterLib.Monster memory sire = readMonster(_sireId);
1202         return _isValidMatingPair(matron, _matronId, sire, _sireId) &&
1203             _isSiringPermitted(_sireId, _matronId);
1204     }
1205 
1206     /// @dev Internal utility function to initiate breeding, assumes that all breeding
1207     ///  requirements have been checked.
1208     function _breedWith(uint256 _matronId, uint256 _sireId) internal {
1209         // Grab a reference to the Kitties from storage.
1210         MonsterLib.Monster memory sire = readMonster(_sireId);
1211         MonsterLib.Monster memory matron = readMonster(_matronId);
1212 
1213         // Mark the matron as pregnant, keeping track of who the sire is.
1214         monsterStorage.setSiringWith(_matronId, _sireId);
1215         
1216 
1217         // Trigger the cooldown for both parents.
1218         _triggerCooldown(_sireId, sire, 1);
1219         _triggerCooldown(_matronId, matron, 1);
1220 
1221         // Clear siring permission for both parents. This may not be strictly necessary
1222         // but it's likely to avoid confusion!
1223         monsterStorage.setSireAllowedToAddress(_matronId, address(0));
1224         monsterStorage.setSireAllowedToAddress(_sireId, address(0));
1225 
1226         uint pregnantMonsters = monsterStorage.pregnantMonsters();
1227         monsterStorage.setPregnantMonsters(pregnantMonsters + 1);
1228 
1229         // Emit the pregnancy event.
1230         emit Pregnant(monsterStorage.monsterIndexToOwner(_matronId), _matronId, _sireId, matron.cooldownEndTimestamp);
1231     }
1232 
1233     /// @notice Breed a monster you own (as matron) with a sire that you own, or for which you
1234     ///  have previously been given Siring approval. Will either make your monster pregnant, or will
1235     ///  fail entirely. Requires a pre-payment of the fee given out to the first caller of giveBirth()
1236     /// @param _matronId The ID of the monster acting as matron (will end up pregnant if successful)
1237     /// @param _sireId The ID of the monster acting as sire (will begin its siring cooldown if successful)
1238     function breedWithAuto(uint256 _matronId, uint256 _sireId)
1239         external
1240         payable
1241         whenNotPaused
1242     {
1243         // Checks for payment.
1244         require(msg.value >= autoBirthFee + birthCommission);
1245 
1246         // Caller must own the matron.
1247         require(_owns(msg.sender, _matronId));
1248 
1249         // Neither sire nor matron are allowed to be on auction during a normal
1250         // breeding operation, but we don't need to check that explicitly.
1251         // For matron: The caller of this function can't be the owner of the matron
1252         //   because the owner of a Kitty on auction is the auction house, and the
1253         //   auction house will never call breedWith().
1254         // For sire: Similarly, a sire on auction will be owned by the auction house
1255         //   and the act of transferring ownership will have cleared any oustanding
1256         //   siring approval.
1257         // Thus we don't need to spend gas explicitly checking to see if either cat
1258         // is on auction.
1259 
1260         // Check that matron and sire are both owned by caller, or that the sire
1261         // has given siring permission to caller (i.e. matron's owner).
1262         // Will fail for _sireId = 0
1263         require(_isSiringPermitted(_sireId, _matronId));
1264 
1265         // Grab a reference to the potential matron
1266         MonsterLib.Monster memory matron = readMonster(_matronId);
1267 
1268         // Make sure matron isn't pregnant, or in the middle of a siring cooldown
1269         require(_isReadyToBreed(matron));
1270 
1271         // Grab a reference to the potential sire
1272         MonsterLib.Monster memory sire = readMonster(_sireId);
1273 
1274         // Make sure sire isn't pregnant, or in the middle of a siring cooldown
1275         require(_isReadyToBreed(sire));
1276 
1277         // Test that these cats are a valid mating pair.
1278         require(_isValidMatingPair(
1279             matron,
1280             _matronId,
1281             sire,
1282             _sireId
1283         ));
1284 
1285         // All checks passed, kitty gets pregnant!
1286         _breedWith(_matronId, _sireId);
1287     }
1288 
1289     /// @notice Have a pregnant monster give birth!
1290     /// @param _matronId A monster ready to give birth.
1291     /// @return The monster ID of the new monster.
1292     /// @dev Looks at a given monster and, if pregnant and if the gestation period has passed,
1293     ///  combines the genes of the two parents to create a new monster. The new monster is assigned
1294     ///  to the current owner of the matron. Upon successful completion, both the matron and the
1295     ///  new monster will be ready to breed again. Note that anyone can call this function (if they
1296     ///  are willing to pay the gas!), but the new monster always goes to the mother's owner.
1297     function giveBirth(uint256 _matronId)
1298         external
1299         whenNotPaused
1300         returns(uint256)
1301     {
1302         // Grab a reference to the matron in storage.
1303         MonsterLib.Monster memory matron = readMonster(_matronId);
1304 
1305         // Check that the matron is a valid cat.
1306         require(matron.birthTime != 0);
1307 
1308         // Check that the matron is pregnant, and that its time has come!
1309         require(_isReadyToGiveBirth(matron));
1310 
1311         // Grab a reference to the sire in storage.
1312         uint256 sireId = matron.siringWithId;
1313         MonsterLib.Monster memory sire = readMonster(sireId);
1314 
1315         // Determine the higher generation number of the two parents
1316         uint16 parentGen = matron.generation;
1317         if (sire.generation > matron.generation) {
1318             parentGen = sire.generation;
1319         }
1320 
1321         // Call the sooper-sekret gene mixing operation.
1322         uint256 childGenes = geneScience.mixGenes(matron.genes, sire.genes, block.number - 1);
1323         uint256 childBattleGenes = geneScience.mixBattleGenes(matron.battleGenes, sire.battleGenes, block.number - 1);
1324 
1325         // Make the new kitten!
1326         address owner = monsterStorage.monsterIndexToOwner(_matronId);
1327         uint256 monsterId = _createMonster(_matronId, matron.siringWithId, parentGen + 1, childGenes, childBattleGenes, 0, owner);
1328 
1329         // Clear the reference to sire from the matron (REQUIRED! Having siringWithId
1330         // set is what marks a matron as being pregnant.)
1331         monsterStorage.setSiringWith(_matronId, 0);
1332 
1333         uint pregnantMonsters = monsterStorage.pregnantMonsters();
1334         monsterStorage.setPregnantMonsters(pregnantMonsters - 1);
1335 
1336         
1337         // Send the balance fee to the person who made birth happen.
1338         msg.sender.transfer(autoBirthFee);
1339 
1340         // return the new kitten's ID
1341         return monsterId;
1342     }
1343 }
1344 
1345 
1346 contract MonsterFeeding is MonsterBreeding {
1347     
1348     event MonsterFed(uint monsterId, uint growScore);
1349     
1350     
1351     function setMonsterFoodAddress(address _address) external onlyCEO {
1352         MonsterFood candidateContract = MonsterFood(_address);
1353 
1354         // NOTE: verify that a contract is what we expect
1355         require(candidateContract.isMonsterFood());
1356 
1357         // Set the new contract address
1358         monsterFood = candidateContract;
1359     }
1360     
1361     function feedMonster(uint _monsterId, uint _foodCode) external payable{
1362 
1363         (uint p1, uint p2, uint p3) = monsterStorage.getMonsterBits(_monsterId);
1364         
1365         (p1, p2, p3) = monsterFood.feedMonster.value(msg.value)( msg.sender, _foodCode, p1, p2, p3);
1366         
1367         monsterStorage.setMonsterBits(_monsterId, p1, p2, p3);
1368 
1369         emit MonsterFed(_monsterId, 0);
1370         
1371     }
1372 }
1373 
1374 /// @title Handles creating auctions for sale and siring of monsters.
1375 contract MonsterFighting is MonsterFeeding {
1376     
1377     
1378       function prepareForBattle(uint _param1, uint _param2, uint _param3) external payable returns(uint){
1379         require(_param1 > 0);
1380         require(_param2 > 0);
1381         require(_param3 > 0);
1382         
1383         for(uint i = 0; i < 5; i++){
1384             uint monsterId = MonsterLib.getBits(_param1, uint8(i * 32), uint8(32));
1385             require(_owns(msg.sender, monsterId));
1386             _approve(monsterId, address(battlesContract));
1387         }
1388         
1389         return battlesContract.prepareForBattle.value(msg.value)(msg.sender, _param1, _param2, _param3);
1390     }
1391     
1392     function withdrawFromBattle(uint _param1, uint _param2, uint _param3) external returns(uint){
1393         return battlesContract.withdrawFromBattle(msg.sender, _param1, _param2, _param3);
1394     }
1395     
1396     function finishBattle(uint _param1, uint _param2, uint _param3) external returns(uint) {
1397         (uint return1, uint return2, uint return3) = battlesContract.finishBattle(msg.sender, _param1, _param2, _param3);
1398         uint[10] memory monsterIds;
1399         uint i;
1400         uint monsterId;
1401         
1402         require(return3>=0);
1403         
1404         for(i = 0; i < 8; i++){
1405             monsterId = MonsterLib.getBits(return1, uint8(i * 32), uint8(32));
1406             monsterIds[i] = monsterId;
1407         }
1408         
1409         for(i = 0; i < 2; i++){
1410             monsterId = MonsterLib.getBits(return2, uint8(i * 32), uint8(32));
1411             monsterIds[i+8] = monsterId;
1412         }
1413         
1414         for(i = 0; i < 10; i++){
1415             monsterId = monsterIds[i];
1416             MonsterLib.Monster memory monster = readMonster(monsterId);
1417             uint bc = monster.battleCounter + 1;
1418             uint increaseIndex = 0;
1419             if(bc >= 10)
1420             {
1421                 bc = 0;
1422                 increaseIndex = 1;
1423             }
1424             monster.battleCounter = uint8(bc);
1425             _triggerCooldown(monsterId, monster, increaseIndex);
1426         }
1427         
1428         
1429     }
1430 }
1431 
1432 /// @title Handles creating auctions for sale and siring of monsters.
1433 ///  This wrapper of ReverseAuction exists only so that users can create
1434 ///  auctions with only one transaction.
1435 contract MonsterAuction is MonsterFighting {
1436 
1437     // @notice The auction contract variables are defined in MonsterBase to allow
1438     //  us to refer to them in MonsterOwnership to prevent accidental transfers.
1439     // `saleAuction` refers to the auction for gen0 and p2p sale of monsters.
1440     // `siringAuction` refers to the auction for siring rights of monsters.
1441 
1442     /// @dev Sets the reference to the sale auction.
1443     /// @param _address - Address of sale contract.
1444     function setSaleAuctionAddress(address _address) external onlyCEO {
1445         SaleClockAuction candidateContract = SaleClockAuction(_address);
1446 
1447         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
1448         require(candidateContract.isSaleClockAuction());
1449 
1450         // Set the new contract address
1451         saleAuction = candidateContract;
1452     }
1453 
1454 
1455     /// @dev Put a monster up for auction.
1456     ///  Does some ownership trickery to create auctions in one tx.
1457     function createSaleAuction(
1458         uint256 _monsterId,
1459         uint256 _startingPrice,
1460         uint256 _endingPrice,
1461         uint256 _duration
1462     )
1463         external
1464         whenNotPaused
1465     {
1466         // Auction contract checks input sizes
1467         // If monster is already on any auction, this will throw
1468         // because it will be owned by the auction contract.
1469         require(_owns(msg.sender, _monsterId));
1470         // Ensure the monster is not pregnant to prevent the auction
1471         // contract accidentally receiving ownership of the child.
1472         // NOTE: the monster IS allowed to be in a cooldown.
1473         require(!isPregnant(_monsterId));
1474         _approve(_monsterId, saleAuction);
1475         // Sale auction throws if inputs are invalid and clears
1476         // transfer and sire approval after escrowing the monster.
1477         saleAuction.createAuction(
1478             _monsterId,
1479             _startingPrice,
1480             _endingPrice,
1481             _duration,
1482             msg.sender
1483         );
1484     }
1485     
1486     /// @dev Put a monster up for auction to be sire.
1487     ///  Performs checks to ensure the monster can be sired, then
1488     ///  delegates to reverse auction.
1489     function createSiringAuction(
1490         uint256 _monsterId,
1491         uint256 _startingPrice,
1492         uint256 _endingPrice,
1493         uint256 _duration
1494     )
1495         external
1496         whenNotPaused
1497     {
1498         // Auction contract checks input sizes
1499         // If monster is already on any auction, this will throw
1500         // because it will be owned by the auction contract.
1501         require(_owns(msg.sender, _monsterId));
1502         require(isReadyToBreed(_monsterId));
1503         _approve(_monsterId, siringAuction);
1504         // Siring auction throws if inputs are invalid and clears
1505         // transfer and sire approval after escrowing the kitty.
1506         siringAuction.createAuction(
1507             _monsterId,
1508             _startingPrice,
1509             _endingPrice,
1510             _duration,
1511             msg.sender
1512         );
1513     }
1514     
1515     /// @dev Completes a siring auction by bidding.
1516     ///  Immediately breeds the winning matron with the sire on auction.
1517     /// @param _sireId - ID of the sire on auction.
1518     /// @param _matronId - ID of the matron owned by the bidder.
1519     function bidOnSiringAuction(
1520         uint256 _sireId,
1521         uint256 _matronId
1522     )
1523         external
1524         payable
1525         whenNotPaused
1526     {
1527         // Auction contract checks input sizes
1528         require(_owns(msg.sender, _matronId));
1529         require(isReadyToBreed(_matronId));
1530         require(_canBreedWithViaAuction(_matronId, _sireId));
1531 
1532         // Define the current price of the auction.
1533         uint256 currentPrice = siringAuction.getCurrentPrice(_sireId);
1534         require(msg.value >= currentPrice + autoBirthFee);
1535 
1536         // Siring auction will throw if the bid fails.
1537         siringAuction.bid.value(msg.value - autoBirthFee)(_sireId);
1538         _breedWith(uint32(_matronId), uint32(_sireId));
1539     }
1540 
1541 
1542     
1543 }
1544 
1545 /// @title all functions related to creating monsters
1546 contract MonsterMinting is MonsterAuction {
1547 
1548     // Limits the number of monsters the contract owner can ever create.
1549     uint256 public constant PROMO_CREATION_LIMIT = 1000;
1550     uint256 public constant GEN0_CREATION_LIMIT = 45000;
1551 
1552     uint256 public constant GEN0_STARTING_PRICE = 1 ether;
1553     uint256 public constant GEN0_ENDING_PRICE = 0.1 ether;
1554     uint256 public constant GEN0_AUCTION_DURATION = 30 days;
1555 
1556 
1557     // Counts the number of monsters the contract owner has created.
1558     uint256 public promoCreatedCount;
1559     uint256 public gen0CreatedCount;
1560 
1561 
1562     /// @dev we can create promo monsters, up to a limit. Only callable by COO
1563     /// @param _genes the encoded genes of the monster to be created, any value is accepted
1564     /// @param _owner the future owner of the created monsters. Default to contract COO
1565     function createPromoMonster(uint256 _genes, uint256 _battleGenes, uint256 _level, address _owner) external onlyCOO {
1566         address monsterOwner = _owner;
1567         if (monsterOwner == address(0)) {
1568              monsterOwner = cooAddress;
1569         }
1570         require(promoCreatedCount < PROMO_CREATION_LIMIT);
1571 
1572         promoCreatedCount++;
1573         _createMonster(0, 0, 0, _genes, _battleGenes, _level, monsterOwner);
1574     }
1575     
1576     /// @dev Creates a new gen0 monster with the given genes and
1577     ///  creates an auction for it.
1578     function createGen0AuctionCustom(uint _genes, uint _battleGenes, uint _level, uint _startingPrice, uint _endingPrice, uint _duration) external onlyCOO {
1579         require(gen0CreatedCount < GEN0_CREATION_LIMIT);
1580 
1581         uint256 monsterId = _createMonster(0, 0, 0, _genes, _battleGenes, _level, address(this));
1582         _approve(monsterId, saleAuction);
1583 
1584         saleAuction.createAuction(
1585             monsterId,
1586             _startingPrice,
1587             _endingPrice,
1588             _duration,
1589             address(this)
1590         );
1591 
1592         gen0CreatedCount++;
1593     }
1594 }
1595 
1596 /// @title MonsterBit: Collectible, breedable, and monsters on the Ethereum blockchain.
1597 /// @dev The main MonsterBit contract, keeps track of monsters so they don't wander around and get lost.
1598 contract MonsterCore is MonsterMinting {
1599 
1600     // This is the main MonsterBit contract. In order to keep our code seperated into logical sections,
1601     // we've broken it up in two ways. First, we have several seperately-instantiated sibling contracts
1602     // that handle auctions and our super-top-secret genetic combination algorithm. The auctions are
1603     // seperate since their logic is somewhat complex and there's always a risk of subtle bugs. By keeping
1604     // them in their own contracts, we can upgrade them without disrupting the main contract that tracks
1605     // monster ownership. The genetic combination algorithm is kept seperate so we can open-source all of
1606     // the rest of our code without making it _too_ easy for folks to figure out how the genetics work.
1607     // Don't worry, I'm sure someone will reverse engineer it soon enough!
1608     //
1609     // Secondly, we break the core contract into multiple files using inheritence, one for each major
1610     // facet of functionality of CK. This allows us to keep related code bundled together while still
1611     // avoiding a single giant file with everything in it. The breakdown is as follows:
1612     //
1613     //      - MonsterBase: This is where we define the most fundamental code shared throughout the core
1614     //             functionality. This includes our main data storage, constants and data types, plus
1615     //             internal functions for managing these items.
1616     //
1617     //      - MonsterAccessControl: This contract manages the various addresses and constraints for operations
1618     //             that can be executed only by specific roles. Namely CEO, CFO and COO.
1619     //
1620     //      - MonsterOwnership: This provides the methods required for basic non-fungible token
1621     //             transactions, following the draft ERC-721 spec (https://github.com/ethereum/EIPs/issues/721).
1622     //
1623     //      - MonsterBreeding: This file contains the methods necessary to breed monsters together, including
1624     //             keeping track of siring offers, and relies on an external genetic combination contract.
1625     //
1626     //      - MonsterAuctions: Here we have the public methods for auctioning or bidding on monsters or siring
1627     //             services. The actual auction functionality is handled in two sibling contracts (one
1628     //             for sales and one for siring), while auction creation and bidding is mostly mediated
1629     //             through this facet of the core contract.
1630     //
1631     //      - MonsterMinting: This final facet contains the functionality we use for creating new gen0 monsters.
1632     //             We can make up to 5000 "promo" monsters that can be given away (especially important when
1633     //             the community is new), and all others can only be created and then immediately put up
1634     //             for auction via an algorithmically determined starting price. Regardless of how they
1635     //             are created, there is a hard limit of 50k gen0 monsters. After that, it's all up to the
1636     //             community to breed, breed, breed!
1637 
1638     // Set in case the core contract is broken and an upgrade is required
1639     address public newContractAddress;
1640 
1641     /// @notice Creates the main MonsterBit smart contract instance.
1642     constructor(address _ceoBackupAddress) public {
1643         require(_ceoBackupAddress != address(0));
1644         // Starts paused.
1645         paused = true;
1646 
1647         // the creator of the contract is the initial CEO
1648         ceoAddress = msg.sender;
1649         ceoBackupAddress = _ceoBackupAddress;
1650 
1651         // the creator of the contract is also the initial COO
1652         cooAddress = msg.sender;
1653     }
1654 
1655     /// @dev Used to mark the smart contract as upgraded, in case there is a serious
1656     ///  breaking bug. This method does nothing but keep track of the new contract and
1657     ///  emit a message indicating that the new address is set. It's up to clients of this
1658     ///  contract to update to the new contract address in that case. (This contract will
1659     ///  be paused indefinitely if such an upgrade takes place.)
1660     /// @param _v2Address new address
1661     function setNewAddress(address _v2Address) external onlyCEO whenPaused {
1662         // See README.md for updgrade plan
1663         newContractAddress = _v2Address;
1664         emit ContractUpgrade(_v2Address);
1665     }
1666 
1667     /// @notice No tipping!
1668     /// @dev Reject all Ether from being sent here, unless it's from one of the
1669     ///  two auction contracts. (Hopefully, we can prevent user accidents.)
1670     function() external payable {
1671         require(
1672             msg.sender == address(saleAuction)
1673             ||
1674             msg.sender == address(siringAuction)
1675             ||
1676             msg.sender == address(battlesContract)
1677             ||
1678             msg.sender == address(monsterFood)
1679         );
1680     }
1681 
1682     /// @dev Override unpause so it requires all external contract addresses
1683     ///  to be set before contract can be unpaused. Also, we can't have
1684     ///  newContractAddress set either, because then the contract was upgraded.
1685     /// @notice This is public rather than external so we can call super.unpause
1686     ///  without using an expensive CALL.
1687     function unpause() public onlyCEO whenPaused {
1688         require(saleAuction != address(0));
1689         require(siringAuction != address(0));
1690         require(monsterFood != address(0));
1691         require(battlesContract != address(0));
1692         require(geneScience != address(0));
1693         require(monsterStorage != address(0));
1694         require(monsterConstants != address(0));
1695         require(newContractAddress == address(0));
1696 
1697         // Actually unpause the contract.
1698         super.unpause();
1699     }
1700 
1701     // @dev Allows the CFO to capture the balance available to the contract.
1702     function withdrawBalance() external onlyCFO {
1703         uint256 balance = address(this).balance;
1704         
1705         uint256 subtractFees = (monsterStorage.pregnantMonsters() + 1) * autoBirthFee;
1706 
1707         if (balance > subtractFees) {
1708             cfoAddress.transfer(balance - subtractFees);
1709         }
1710 
1711     }
1712     
1713     /// @dev Transfers the balance of the sale auction contract
1714     /// to the MonsterCore contract. We use two-step withdrawal to
1715     /// prevent two transfer calls in the auction bid function.
1716     function withdrawDependentBalances() external onlyCLevel {
1717         saleAuction.withdrawBalance();
1718         siringAuction.withdrawBalance();
1719         battlesContract.withdrawBalance();
1720         monsterFood.withdrawBalance();
1721     }
1722 }