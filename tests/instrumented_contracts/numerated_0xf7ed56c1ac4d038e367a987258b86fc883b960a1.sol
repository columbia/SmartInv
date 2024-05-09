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
44  * @title EjectableOwnable
45  * @dev The EjectableOwnable contract provides the function to remove the ownership of the contract.
46  */
47 contract EjectableOwnable is Ownable {
48     
49     /**
50      * @dev Remove the ownership by setting the owner address to null, 
51      * after calling this function, all onlyOwner function will be be able to be called by anyone anymore, 
52      * the contract will achieve truly decentralisation.
53     */
54     function removeOwnership() onlyOwner public {
55         owner = 0x0;
56     }
57     
58 }
59 
60 
61 /**
62  * @title Pausable
63  * @dev Base contract which allows children to implement an emergency stop mechanism.
64  */
65 contract Pausable is Ownable {
66     
67   event Pause();
68   event Unpause();
69 
70   bool public paused = false;
71 
72   /**
73    * @dev Modifier to make a function callable only when the contract is not paused.
74    */
75   modifier whenNotPaused() {
76     require(!paused);
77     _;
78   }
79 
80   /**
81    * @dev Modifier to make a function callable only when the contract is paused.
82    */
83   modifier whenPaused() {
84     require(paused);
85     _;
86   }
87 
88   /**
89    * @dev called by the owner to pause, triggers stopped state
90    */
91   function pause() onlyOwner whenNotPaused public {
92     paused = true;
93     Pause();
94   }
95 
96   /**
97    * @dev called by the owner to unpause, returns to normal state
98    */
99   function unpause() onlyOwner whenPaused public {
100     paused = false;
101     Unpause();
102   }
103   
104 }
105 
106 
107 /**
108  * @title SafeMath
109  * @dev Math operations with safety checks that throw on error
110  */
111 library SafeMath {
112 
113   /**
114   * @dev Multiplies two numbers, throws on overflow.
115   */
116   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
117     if (a == 0) {
118       return 0;
119     }
120     uint256 c = a * b;
121     assert(c / a == b);
122     return c;
123   }
124 
125   /**
126   * @dev Integer division of two numbers, truncating the quotient.
127   */
128   function div(uint256 a, uint256 b) internal pure returns (uint256) {
129     // assert(b > 0); // Solidity automatically throws when dividing by 0
130     uint256 c = a / b;
131     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
132     return c;
133   }
134 
135   /**
136   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
137   */
138   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
139     assert(b <= a);
140     return a - b;
141   }
142 
143   /**
144   * @dev Adds two numbers, throws on overflow.
145   */
146   function add(uint256 a, uint256 b) internal pure returns (uint256) {
147     uint256 c = a + b;
148     assert(c >= a);
149     return c;
150   }
151   
152 }
153 
154 
155 /**
156  * @title PullPayment
157  * @dev Base contract supporting async send for pull payments. Inherit from this
158  * contract and use asyncSend instead of send.
159  */
160 contract PullPayment {
161     
162   using SafeMath for uint256;
163 
164   mapping(address => uint256) public payments;
165   uint256 public totalPayments;
166 
167   /**
168    * @dev withdraw accumulated balance, called by payee.
169    */
170   function withdrawPayments() public {
171     address payee = msg.sender;
172     uint256 payment = payments[payee];
173 
174     require(payment != 0);
175     require(this.balance >= payment);
176 
177     totalPayments = totalPayments.sub(payment);
178     payments[payee] = 0;
179 
180     assert(payee.send(payment));
181   }
182 
183   /**
184    * @dev Called by the payer to store the sent amount as credit to be pulled.
185    * @param dest The destination address of the funds.
186    * @param amount The amount to transfer.
187    */
188   function asyncSend(address dest, uint256 amount) internal {
189     payments[dest] = payments[dest].add(amount);
190     totalPayments = totalPayments.add(amount);
191   }
192   
193 }
194 
195 
196 /**
197  * @title Destructible
198  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
199  */
200 contract Destructible is Ownable {
201 
202   function Destructible() public payable { }
203 
204   /**
205    * @dev Transfers the current balance to the owner and terminates the contract.
206    */
207   function destroy() onlyOwner public {
208     selfdestruct(owner);
209   }
210 
211   function destroyAndSend(address _recipient) onlyOwner public {
212     selfdestruct(_recipient);
213   }
214   
215 }
216 
217 
218 contract EDStructs {
219     
220     /**
221      * @dev The main Dungeon struct. Every dungeon in the game is represented by this structure.
222      * A dungeon is consists of an unlimited number of floors for your heroes to challenge, 
223      * the power level of a dungeon is encoded in the floorGenes. Some dungeons are in fact more "challenging" than others,
224      * the secret formula for that is left for user to find out.
225      * 
226      * Each dungeon also has a "training area", heroes can perform trainings and upgrade their stat,
227      * and some dungeons are more effective in the training, which is also a secret formula!
228      * 
229      * When player challenge or do training in a dungeon, the fee will be collected as the dungeon rewards,
230      * which will be rewarded to the player who successfully challenged the current floor.
231      * 
232      * Each dungeon fits in fits into three 256-bit words.
233      */
234     struct Dungeon {
235         
236         // Each dungeon has an ID which is the index in the storage array.
237 
238         // The timestamp of the block when this dungeon is created.
239         uint32 creationTime;
240         
241         // The status of the dungeon, each dungeon can have 5 status, namely:
242         // 0: Active | 1: Transport Only | 2: Challenge Only | 3: Train Only | 4: InActive
243         uint8 status;
244         
245         // The dungeon's difficulty, the higher the difficulty, 
246         // normally, the "rarer" the seedGenes, the higher the diffculty,
247         // and the higher the contribution fee it is to challenge, train, and transport to the dungeon,
248         // the formula for the contribution fee is in DungeonChallenge and DungeonTraining contracts.
249         // A dungeon's difficulty never change.
250         uint8 difficulty;
251         
252         // The dungeon's capacity, maximum number of players allowed to stay on this dungeon.
253         // The capacity of the newbie dungeon (Holyland) is set at 0 (which is infinity).
254         // Using 16-bit unsigned integers can have a maximum of 65535 in capacity.
255         // A dungeon's capacity never change.
256         uint16 capacity;
257         
258         // The current floor number, a dungeon is consists of an umlimited number of floors,
259         // when there is heroes successfully challenged a floor, the next floor will be
260         // automatically generated. Using 32-bit unsigned integer can have a maximum of 4 billion floors.
261         uint32 floorNumber;
262         
263         // The timestamp of the block when the current floor is generated.
264         uint32 floorCreationTime;
265         
266         // Current accumulated rewards, successful challenger will get a large proportion of it.
267         uint128 rewards;
268         
269         // The seed genes of the dungeon, it is used as the base gene for first floor, 
270         // some dungeons are rarer and some are more common, the exact details are, 
271         // of course, top secret of the game! 
272         // A dungeon's seedGenes never change.
273         uint seedGenes;
274         
275         // The genes for current floor, it encodes the difficulty level of the current floor.
276         // We considered whether to store the entire array of genes for all floors, but
277         // in order to save some precious gas we're willing to sacrifice some functionalities with that.
278         uint floorGenes;
279         
280     }
281     
282     /**
283      * @dev The main Hero struct. Every hero in the game is represented by this structure.
284      */
285     struct Hero {
286 
287         // Each hero has an ID which is the index in the storage array.
288         
289         // The timestamp of the block when this dungeon is created.
290         uint64 creationTime;
291         
292         // The timestamp of the block where a challenge is performed, used to calculate when a hero is allowed to engage in another challenge.
293         uint64 cooldownStartTime;
294         
295         // Every time a hero challenge a dungeon, its cooldown index will be incremented by one.
296         uint32 cooldownIndex;
297         
298         // The seed of the hero, the gene encodes the power level of the hero.
299         // This is another top secret of the game! Hero's gene can be upgraded via
300         // training in a dungeon.
301         uint genes;
302         
303     }
304     
305 }
306 
307 
308 /**
309  * @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens.
310  */
311 contract ERC721 {
312     
313     // Events
314     event Transfer(address indexed from, address indexed to, uint indexed tokenId);
315     event Approval(address indexed owner, address indexed approved, uint indexed tokenId);
316     
317     // ERC20 compatible functions.
318     // function name() public constant returns (string);
319     // function symbol() public constant returns (string);
320     function totalSupply() public view returns (uint);
321     function balanceOf(address _owner) public view returns (uint);
322     
323     // Functions that define ownership.
324     function ownerOf(uint _tokenId) external view returns (address);
325     function transfer(address _to, uint _tokenId) external;
326     
327     // Approval related functions, mainly used in auction contracts.
328     function approve(address _to, uint _tokenId) external;
329     function approvedFor(uint _tokenId) external view returns (address);
330     function transferFrom(address _from, address _to, uint _tokenId) external;
331     
332     /**
333      * @dev Each non-fungible token owner can own more than one token at one time. 
334      * Because each token is referenced by its unique ID, however, 
335      * it can get difficult to keep track of the individual tokens that a user may own. 
336      * To do this, the contract keeps a record of the IDs of each token that each user owns.
337      */
338     mapping(address => uint[]) public ownerTokens;
339 
340 }
341 
342 
343 contract DungeonTokenInterface is ERC721, EDStructs {
344 
345     /**
346      * @notice Limits the number of dungeons the contract owner can ever create.
347      */
348     uint public constant DUNGEON_CREATION_LIMIT = 1024;
349     
350     /**
351      * @dev Name of token.
352      */
353     string public constant name = "Dungeon";
354     
355     /**
356      * @dev Symbol of token.
357      */
358     string public constant symbol = "DUNG";
359     
360     /**
361      * @dev An array containing the Dungeon struct, which contains all the dungeons in existance.
362      *  The ID for each dungeon is the index of this array.
363      */ 
364     Dungeon[] public dungeons;
365 
366     /**
367      * @dev The external function that creates a new dungeon and stores it, only contract owners
368      *  can create new token, and will be restricted by the DUNGEON_CREATION_LIMIT.
369      *  Will generate a Mint event, a  NewDungeonFloor event, and a Transfer event.
370      */ 
371     function createDungeon(uint _difficulty, uint _capacity, uint _floorNumber, uint _seedGenes, uint _floorGenes, address _owner) external returns (uint);
372     
373     /**
374      * @dev The external function to set dungeon status by its ID, 
375      *  refer to DungeonStructs for more information about dungeon status.
376      *  Only contract owners can alter dungeon state.
377      */ 
378     function setDungeonStatus(uint _id, uint _newStatus) external;
379     
380     /**
381      * @dev The external function to add additional dungeon rewards by its ID, 
382      *  only contract owners can alter dungeon state.
383      */ 
384     function addDungeonRewards(uint _id, uint _additinalRewards) external;
385     
386     /**
387      * @dev The external function to add another dungeon floor by its ID, 
388      *  only contract owners can alter dungeon state.
389      */ 
390     function addDungeonNewFloor(uint _id, uint _newRewards, uint _newFloorGenes) external;
391     
392 }
393 
394 
395 contract HeroTokenInterface is ERC721, EDStructs {
396     
397     /**
398      * @dev Name of token.
399      */
400     string public constant name = "Hero";
401     
402     /**
403      * @dev Symbol of token.
404      */
405     string public constant symbol = "HERO";
406 
407     /**
408      * @dev An array containing the Hero struct, which contains all the heroes in existance.
409      *  The ID for each hero is the index of this array.
410      */ 
411     Hero[] public heroes;
412 
413     /**
414      * @dev An external function that creates a new hero and stores it,
415      *  only contract owners can create new token.
416      *  method doesn't do any checking and should only be called when the
417      *  input data is known to be valid.
418      * @param _genes The gene of the new hero.
419      * @param _owner The inital owner of this hero.
420      * @return The hero ID of the new hero.
421      */
422     function createHero(uint _genes, address _owner) external returns (uint);
423     
424     /**
425      * @dev The external function to set the hero genes by its ID, 
426      *  only contract owners can alter hero state.
427      */ 
428     function setHeroGenes(uint _id, uint _newGenes) external;
429 
430     /**
431      * @dev Set the cooldownStartTime for the given hero. Also increments the cooldownIndex.
432      */
433     function triggerCooldown(uint _id) external;
434     
435 }
436 
437 
438 /**
439  * SECRET
440  */
441 contract ChallengeFormulaInterface {
442     
443     /**
444      * @dev given genes of current floor and dungeon seed, return a genetic combination - may have a random factor.
445      * @param _floorGenes Genes of floor.
446      * @param _seedGenes Seed genes of dungeon.
447      * @return The resulting genes.
448      */
449     function calculateResult(uint _floorGenes, uint _seedGenes) external returns (uint);
450     
451 }
452 
453 
454 /**
455  * SECRET
456  */
457 contract TrainingFormulaInterface {
458     
459     /**
460      * @dev given genes of hero and current floor, return a genetic combination - may have a random factor.
461      * @param _heroGenes Genes of hero.
462      * @param _floorGenes Genes of current floor.
463      * @param _equipmentId Equipment index to train for, 0 is train all attributes.
464      * @return The resulting genes.
465      */
466     function calculateResult(uint _heroGenes, uint _floorGenes, uint _equipmentId) external returns (uint);
467     
468 }
469 
470 
471 /**
472  * @title EDBase
473  * @dev Base contract for Ether Dungeon. It implements all necessary sub-classes,
474  *  holds all the contracts, constants, game settings, storage variables, events, and some commonly used functions.
475  */
476 contract EDBase is EjectableOwnable, Pausable, PullPayment, EDStructs {
477     
478     /* ======== CONTRACTS ======== */
479     
480     /// @dev The address of the ERC721 token contract managing all Dungeon tokens.
481     DungeonTokenInterface public dungeonTokenContract;
482     
483     /// @dev The address of the ERC721 token contract managing all Hero tokens.
484     HeroTokenInterface public heroTokenContract;
485     
486     /// @dev The address of the ChallengeFormula contract that handles the floor generation mechanics after challenge success.
487     ChallengeFormulaInterface challengeFormulaContract;
488     
489     /// @dev The address of the TrainingFormula contract that handles the hero training mechanics.
490     TrainingFormulaInterface trainingFormulaContract;
491     
492     
493     /* ======== CONSTANTS / GAME SETTINGS (all variables are set to constant in order to save gas) ======== */
494     
495     // 1 finney = 0.001 ether
496     // 1 szabo = 0.001 finney
497     
498     /// @dev Super Hero (full set of same-themed Rare Equipments, there are 8 in total)
499     uint public constant SUPER_HERO_MULTIPLIER = 32;
500     
501     /// @dev Ultra Hero (full set of same-themed Epic Equipments, there are 4 in total)
502     uint public constant ULTRA_HERO_MULTIPLIER = 64;
503     
504     /**
505      * @dev Mega Hero (full set of same-themed Legendary Equipments, there are 2 in total)
506      *  There are also 2 Ultimate Hero/Demon, Pangu and Chaos, which will use the MEGA_HERO_MULTIPLIER.
507      */
508     uint public constant MEGA_HERO_MULTIPLIER = 96;
509     
510     /// @dev The fee for recruiting a hero. The payment is accumulated to the rewards of the origin dungeon.
511     uint public recruitHeroFee = 2 finney;
512     
513     /**
514      * @dev The actual fee contribution required to call transport() is calculated by this feeMultiplier,
515      *  times the dungeon difficulty of destination dungeon. The payment is accumulated to the rewards of the origin dungeon,
516      *  and a large proportion will be claimed by whoever successfully challenged the floor.
517      */
518     uint public transportationFeeMultiplier = 250 szabo;
519     
520     ///@dev All hero starts in the novice dungeon, also hero can only be recruited in novice dungoen.
521     uint public noviceDungeonId = 31; // < dungeon ID 31 = Abyss
522     
523     /// @dev Amount of faith required to claim a portion of the grandConsolationRewards.
524     uint public consolationRewardsRequiredFaith = 100;
525     
526     /// @dev The percentage for which when a player can get from the grandConsolationRewards when meeting the faith requirement.
527     uint public consolationRewardsClaimPercent = 50;
528     
529     /**
530      * @dev The actual fee contribution required to call challenge() is calculated by this feeMultiplier,
531      *  times the dungeon difficulty. The payment is accumulated to the dungeon rewards, 
532      *  and a large proportion will be claimed by whoever successfully challenged the floor.
533      */
534     uint public constant challengeFeeMultiplier = 1 finney;
535     
536     /**
537      * @dev The percentage for which successful challenger be rewarded of the dungeons' accumulated rewards.
538      *  The remaining rewards subtract dungeon master rewards and consolation rewards will be used as the base rewards for new floor.
539      */
540     uint public constant challengeRewardsPercent = 45;
541     
542     /**
543      * @dev The developer fee for dungeon master (owner of the dungeon token).
544      *  Note that when Ether Dungeon becomes truly decentralised, contract ownership will be ejected,
545      *  and the master rewards will be rewarded to the dungeon owner (Dungeon Masters).
546      */
547     uint public constant masterRewardsPercent = 8;
548     
549     /// @dev The percentage for which the challenge rewards is added to the grandConsolationRewards.
550     uint public consolationRewardsPercent = 2;
551     
552     /// @dev The preparation time period where a new dungeon is created, before it can be challenged.
553     uint public dungeonPreparationTime = 60 minutes;
554     
555     /// @dev The challenge rewards percentage used right after the preparation period.
556     uint public constant rushTimeChallengeRewardsPercent = 22;
557     
558     /// @dev The number of floor in which the rushTimeChallengeRewardsPercent be applied.
559     uint public constant rushTimeFloorCount = 30;
560     
561     /**
562      * @dev The actual fee contribution required to call trainX() is calculated by this feeMultiplier,
563      *  times the dungeon difficulty, times training times. The payment is accumulated to the dungeon rewards, 
564      *  and a large proportion will be claimed by whoever successfully challenged the floor.
565      */
566     uint public trainingFeeMultiplier = 2 finney;
567     
568     /**
569      * @dev The actual fee contribution required to call trainEquipment() is calculated by this feeMultiplier,
570      *  times the dungeon difficulty. The payment is accumulated to the dungeon rewards.
571      *  (No preparation period discount on equipment training.)
572      */
573     uint public equipmentTrainingFeeMultiplier = 8 finney;
574     
575     /// @dev The discounted training fee multiplier to be used during preparation period.
576     uint public constant preparationPeriodTrainingFeeMultiplier = 1600 szabo;
577     
578     /// @dev The discounted equipment training fee multiplier to be used during preparation period.
579     uint public constant preparationPeriodEquipmentTrainingFeeMultiplier = 6400 szabo;
580     
581     
582     /* ======== STATE VARIABLES ======== */
583     
584     /**
585      * @dev After each successful training, do not update Hero immediately to avoid exploit.
586      *  The hero power will be auto updated during next challenge/training for any player.
587      *  Or calling the setTempHeroPower() public function directly.
588      */
589     mapping(address => uint) playerToLastActionBlockNumber;
590     uint tempSuccessTrainingHeroId;
591     uint tempSuccessTrainingNewHeroGenes = 1; // value 1 is used as no pending update
592     
593     /// @dev The total accumulated consolidation jackpot / rewards amount.
594     uint public grandConsolationRewards = 168203010964693559; // < migrated from previous contract
595     
596     /// @dev A mapping from token IDs to the address that owns them, the value can get by getPlayerDetails.
597     mapping(address => uint) playerToDungeonID;
598     
599     /// @dev A mapping from player address to the player's faith value, the value can get by getPlayerDetails.
600     mapping(address => uint) playerToFaith;
601 
602     /**
603      * @dev A mapping from owner address to a boolean flag of whether the player recruited the first hero.
604      *  Note that transferring a hero from other address do not count, the value can get by getPlayerDetails.
605      */
606     mapping(address => bool) playerToFirstHeroRecruited;
607 
608     /// @dev A mapping from owner address to count of tokens that address owns, the value can get by getDungeonDetails.
609     mapping(uint => uint) dungeonIdToPlayerCount;
610     
611     
612     /* ======== EVENTS ======== */
613     
614     /// @dev The PlayerTransported event is fired when user transported to another dungeon.
615     event PlayerTransported(uint timestamp, address indexed playerAddress, uint indexed originDungeonId, uint indexed destinationDungeonId);
616     
617     /// @dev The DungeonChallenged event is fired when user finished a dungeon challenge.
618     event DungeonChallenged(uint timestamp, address indexed playerAddress, uint indexed dungeonId, uint indexed heroId, uint heroGenes, uint floorNumber, uint floorGenes, bool success, uint newFloorGenes, uint successRewards, uint masterRewards);
619   
620     /// @dev The DungeonChallenged event is fired when user finished a dungeon challenge.
621     event ConsolationRewardsClaimed(uint timestamp, address indexed playerAddress, uint consolationRewards);
622   
623     /// @dev The HeroTrained event is fired when user finished a training.
624     event HeroTrained(uint timestamp, address indexed playerAddress, uint indexed dungeonId, uint indexed heroId, uint heroGenes, uint floorNumber, uint floorGenes, bool success, uint newHeroGenes);
625     
626     
627     /* ======== PUBLIC/EXTERNAL FUNCTIONS ======== */
628     
629     /**
630      * @dev Get the attributes (equipments + stats) of a hero from its gene.
631      */
632     function getHeroAttributes(uint _genes) public pure returns (uint[]) {
633         uint[] memory attributes = new uint[](12);
634         
635         for (uint i = 0; i < 12; i++) {
636             attributes[11 - i] = _genes % 32;
637             _genes /= 32 ** 4;
638         }
639         
640         return attributes;
641     }
642     
643     /**
644      * @dev Calculate the power of a hero from its gene,
645      *  it calculates the equipment power, stats power, and super hero boost.
646      */
647     function getHeroPower(uint _genes, uint _dungeonDifficulty) public pure returns (
648         uint totalPower, 
649         uint equipmentPower, 
650         uint statsPower, 
651         bool isSuper, 
652         uint superRank,
653         uint superBoost
654     ) {
655         // Individual power of each equipment.
656         // DUPLICATE CODE with _getDungeonPower: Constant array variable is not yet implemented,
657         // so need to put it here in order to save gas.
658         uint16[32] memory EQUIPMENT_POWERS = [
659             1, 2, 4, 5, 16, 17, 32, 33, // [Holy] Normal Equipments
660             8, 16, 16, 32, 32, 48, 64, 96, // [Myth] Normal Equipments
661             
662             4, 16, 32, 64, // [Holy] Rare Equipments
663             32, 48, 80, 128, // [Myth] Rare Equipments
664             
665             32, 96, // [Holy] Epic Equipments
666             80, 192, // [Myth] Epic Equipments
667             
668             192, // [Holy] Legendary Equipments
669             288, // [Myth] Legendary Equipments
670             
671             // Pangu / Chaos Legendary Equipments are reserved for far future use.
672             // Their existence is still a mystery.
673             384, // [Pangu] Legendary Equipments
674             512 // [Chaos] Legendary Equipments
675         ];
676         
677         uint[] memory attributes = getHeroAttributes(_genes);
678         
679         // Calculate total equipment power.
680         superRank = attributes[0];
681         
682         for (uint i = 0; i < 8; i++) {
683             uint equipment = attributes[i];
684             equipmentPower += EQUIPMENT_POWERS[equipment];
685             
686             // If any equipment is of difference index, set superRank to 0.
687             if (superRank != equipment) {
688                 superRank = 0;
689             }
690         }
691         
692         // Calculate total stats power.
693         for (uint j = 8; j < 12; j++) {
694             // Stat power is gene number + 1.
695             statsPower += attributes[j] + 1;
696         }
697         
698         // Calculate Super/Ultra/Mega Power Boost.
699         isSuper = superRank >= 16;
700         
701         if (superRank >= 28) { // Mega Hero
702             superBoost = (_dungeonDifficulty - 1) * MEGA_HERO_MULTIPLIER;
703         } else if (superRank >= 24) { // Ultra Hero
704             superBoost = (_dungeonDifficulty - 1) * ULTRA_HERO_MULTIPLIER;
705         } else if (superRank >= 16) { // Super Hero
706             superBoost = (_dungeonDifficulty - 1) * SUPER_HERO_MULTIPLIER;
707         }
708         
709         totalPower = statsPower + equipmentPower + superBoost;
710     }
711     
712     /**
713      * @dev Calculate the power of a dungeon floor.
714      */
715     function getDungeonPower(uint _genes) public pure returns (uint) {
716         // Individual power of each equipment.
717         // DUPLICATE CODE with getHeroPower
718         uint16[32] memory EQUIPMENT_POWERS = [
719             1, 2, 4, 5, 16, 17, 32, 33, // [Holy] Normal Equipments
720             8, 16, 16, 32, 32, 48, 64, 96, // [Myth] Normal Equipments
721             
722             4, 16, 32, 64, // [Holy] Rare Equipments
723             32, 48, 80, 128, // [Myth] Rare Equipments
724             
725             32, 96, // [Holy] Epic Equipments
726             80, 192, // [Myth] Epic Equipments
727             
728             192, // [Holy] Legendary Equipments
729             288, // [Myth] Legendary Equipments
730             
731             // Pangu / Chaos Legendary Equipments are reserved for far future use.
732             // Their existence is still a mystery.
733             384, // [Pangu] Legendary Equipments
734             512 // [Chaos] Legendary Equipments
735         ];
736         
737         // Calculate total dungeon power.
738         uint dungeonPower;
739         
740         for (uint j = 0; j < 12; j++) {
741             dungeonPower += EQUIPMENT_POWERS[_genes % 32];
742             _genes /= 32 ** 4;
743         }
744         
745         return dungeonPower;
746     }
747     
748     /**
749      * @dev Calculate the sum of top 5 heroes power a player owns.
750      *  The gas usage increased with the number of heroes a player owned, roughly 500 x hero count.
751      *  This is used in transport function only to calculate the required tranport fee.
752      */
753     function calculateTop5HeroesPower(address _address, uint _dungeonId) public view returns (uint) {
754         uint heroCount = heroTokenContract.balanceOf(_address);
755         
756         if (heroCount == 0) {
757             return 0;
758         }
759         
760         // Get the dungeon difficulty to factor in the super power boost when calculating hero power.
761         uint difficulty;
762         (,, difficulty,,,,,,) = dungeonTokenContract.dungeons(_dungeonId);
763         
764         // Compute all hero powers for further calculation.
765         uint[] memory heroPowers = new uint[](heroCount);
766         
767         for (uint i = 0; i < heroCount; i++) {
768             uint heroId = heroTokenContract.ownerTokens(_address, i);
769             uint genes;
770             (,,, genes) = heroTokenContract.heroes(heroId);
771             (heroPowers[i],,,,,) = getHeroPower(genes, difficulty);
772         }
773         
774         // Calculate the top 5 heroes power.
775         uint result;
776         uint curMax;
777         uint curMaxIndex;
778         
779         for (uint j; j < 5; j++) {
780             for (uint k = 0; k < heroPowers.length; k++) {
781                 if (heroPowers[k] > curMax) {
782                     curMax = heroPowers[k];
783                     curMaxIndex = k;
784                 }
785             }
786             
787             result += curMax;
788             heroPowers[curMaxIndex] = 0;
789             curMax = 0;
790             curMaxIndex = 0;
791         }
792         
793         return result;
794     }
795     
796     /// @dev Set the previously temp stored upgraded hero genes. Can only be called by contract owner.
797     function setTempHeroPower() onlyOwner public {
798        _setTempHeroPower();
799     }
800     
801     
802     /* ======== SETTER FUNCTIONS ======== */
803     
804     /// @dev Set the address of the dungeon token contract.
805     function setDungeonTokenContract(address _newDungeonTokenContract) onlyOwner external {
806         dungeonTokenContract = DungeonTokenInterface(_newDungeonTokenContract);
807     }
808     
809     /// @dev Set the address of the hero token contract.
810     function setHeroTokenContract(address _newHeroTokenContract) onlyOwner external {
811         heroTokenContract = HeroTokenInterface(_newHeroTokenContract);
812     }
813     
814     /// @dev Set the address of the secret dungeon challenge formula contract.
815     function setChallengeFormulaContract(address _newChallengeFormulaAddress) onlyOwner external {
816         challengeFormulaContract = ChallengeFormulaInterface(_newChallengeFormulaAddress);
817     }
818     
819     /// @dev Set the address of the secret hero training formula contract.
820     function setTrainingFormulaContract(address _newTrainingFormulaAddress) onlyOwner external {
821         trainingFormulaContract = TrainingFormulaInterface(_newTrainingFormulaAddress);
822     }
823     
824     /// @dev Updates the fee for calling recruitHero().
825     function setRecruitHeroFee(uint _newRecruitHeroFee) onlyOwner external {
826         recruitHeroFee = _newRecruitHeroFee;
827     }
828     
829     /// @dev Updates the fee contribution multiplier required for calling transport().
830     function setTransportationFeeMultiplier(uint _newTransportationFeeMultiplier) onlyOwner external {
831         transportationFeeMultiplier = _newTransportationFeeMultiplier;
832     }
833     
834     /// @dev Updates the novice dungeon ID.
835     function setNoviceDungeonId(uint _newNoviceDungeonId) onlyOwner external {
836         noviceDungeonId = _newNoviceDungeonId;
837     }
838     
839     /// @dev Updates the required amount of faith to get a portion of the consolation rewards.
840     function setConsolationRewardsRequiredFaith(uint _newConsolationRewardsRequiredFaith) onlyOwner external {
841         consolationRewardsRequiredFaith = _newConsolationRewardsRequiredFaith;
842     }
843     
844     /// @dev Updates the percentage portion of consolation rewards a player get when meeting the faith requirement.
845     function setConsolationRewardsClaimPercent(uint _newConsolationRewardsClaimPercent) onlyOwner external {
846         consolationRewardsClaimPercent = _newConsolationRewardsClaimPercent;
847     }
848     
849     /// @dev Updates the consolation rewards percentage.
850     function setConsolationRewardsPercent(uint _newConsolationRewardsPercent) onlyOwner external {
851         consolationRewardsPercent = _newConsolationRewardsPercent;
852     }
853     
854     /// @dev Updates the challenge cooldown time.
855     function setDungeonPreparationTime(uint _newDungeonPreparationTime) onlyOwner external {
856         dungeonPreparationTime = _newDungeonPreparationTime;
857     }
858     
859     /// @dev Updates the fee contribution multiplier required for calling trainX().
860     function setTrainingFeeMultiplier(uint _newTrainingFeeMultiplier) onlyOwner external {
861         trainingFeeMultiplier = _newTrainingFeeMultiplier;
862     }
863 
864     /// @dev Updates the fee contribution multiplier required for calling trainEquipment().
865     function setEquipmentTrainingFeeMultiplier(uint _newEquipmentTrainingFeeMultiplier) onlyOwner external {
866         equipmentTrainingFeeMultiplier = _newEquipmentTrainingFeeMultiplier;
867     }
868     
869     
870     /* ======== INTERNAL/PRIVATE FUNCTIONS ======== */
871     
872     /**
873      * @dev Internal function to set the previously temp stored upgraded hero genes. 
874      * Every challenge/training will first call this function.
875      */
876     function _setTempHeroPower() internal {
877         // Genes of 1 is used as no pending update.
878         if (tempSuccessTrainingNewHeroGenes != 1) {
879             // ** STORAGE UPDATE **
880             heroTokenContract.setHeroGenes(tempSuccessTrainingHeroId, tempSuccessTrainingNewHeroGenes);
881             
882             // Reset the variables to indicate no pending update.
883             tempSuccessTrainingNewHeroGenes = 1;
884         }
885     }
886     
887     
888     /* ======== MODIFIERS ======== */
889     
890     /**
891      * @dev Throws if _dungeonId is not created yet.
892      */
893     modifier dungeonExists(uint _dungeonId) {
894         require(_dungeonId < dungeonTokenContract.totalSupply());
895         _;
896     }
897     
898 }
899 
900 
901 contract EDTransportation is EDBase {
902 
903     /* ======== PUBLIC/EXTERNAL FUNCTIONS ======== */
904     
905     /// @dev Recruit a new novice hero with no attributes (gene = 0).
906     function recruitHero() whenNotPaused external payable returns (uint) {
907         // Only allow recruiting hero in the novice dungeon, or first time recruiting hero.
908         require(playerToDungeonID[msg.sender] == noviceDungeonId || !playerToFirstHeroRecruited[msg.sender]);
909         
910         // Checks for payment, any exceeding funds will be transferred back to the player.
911         require(msg.value >= recruitHeroFee);
912         
913         // ** STORAGE UPDATE **
914         // Increment the accumulated rewards for the dungeon, 
915         // since player can only recruit hero in the novice dungeon, rewards is added there.
916         dungeonTokenContract.addDungeonRewards(noviceDungeonId, recruitHeroFee);
917 
918         // Calculate any excess funds and make it available to be withdrawed by the player.
919         asyncSend(msg.sender, msg.value - recruitHeroFee);
920         
921         // If it is the first time recruiting a hero, set the player's location to the novice dungeon.
922         if (!playerToFirstHeroRecruited[msg.sender]) {
923             // ** STORAGE UPDATE **
924             dungeonIdToPlayerCount[noviceDungeonId]++;
925             playerToDungeonID[msg.sender] = noviceDungeonId;
926             playerToFirstHeroRecruited[msg.sender] = true;
927         }
928         
929         return heroTokenContract.createHero(0, msg.sender);
930     }
931     
932     /**
933      * @dev The main external function to call when a player transport to another dungeon.
934      *  Will generate a PlayerTransported event.
935      *  Player must have at least one hero in order to perform
936      */
937     function transport(uint _destinationDungeonId) whenNotPaused dungeonCanTransport(_destinationDungeonId) playerAllowedToTransport() external payable {
938         uint originDungeonId = playerToDungeonID[msg.sender];
939         
940         // Disallow transport to the same dungeon.
941         require(_destinationDungeonId != originDungeonId);
942         
943         // Get the dungeon details from the token contract.
944         uint difficulty;
945         (,, difficulty,,,,,,) = dungeonTokenContract.dungeons(_destinationDungeonId);
946         
947         // Disallow weaker user to transport to "difficult" dungeon.
948         uint top5HeroesPower = calculateTop5HeroesPower(msg.sender, _destinationDungeonId);
949         require(top5HeroesPower >= difficulty * 12);
950         
951         // Checks for payment, any exceeding funds will be transferred back to the player.
952         // The transportation fee is calculated by a base fee from transportationFeeMultiplier,
953         // plus an additional fee increased with the total power of top 5 heroes owned.
954         uint baseFee = difficulty * transportationFeeMultiplier;
955         uint additionalFee = top5HeroesPower / 64 * transportationFeeMultiplier;
956         uint requiredFee = baseFee + additionalFee;
957         require(msg.value >= requiredFee);
958         
959         // ** STORAGE UPDATE **
960         // Increment the accumulated rewards for the dungeon.
961         dungeonTokenContract.addDungeonRewards(originDungeonId, requiredFee);
962 
963         // Calculate any excess funds and make it available to be withdrawed by the player.
964         asyncSend(msg.sender, msg.value - requiredFee);
965 
966         _transport(originDungeonId, _destinationDungeonId);
967     }
968     
969     
970     /* ======== INTERNAL/PRIVATE FUNCTIONS ======== */
971     
972     /// @dev Internal function to assigns location of a player.
973     function _transport(uint _originDungeonId, uint _destinationDungeonId) internal {
974         // ** STORAGE UPDATE **
975         // Update the dungeons' player count.
976         // Normally the player count of original dungeon will already be > 0,
977         // perform checking to avoid unexpected overflow
978         if (dungeonIdToPlayerCount[_originDungeonId] > 0) {
979             dungeonIdToPlayerCount[_originDungeonId]--;
980         }
981         
982         dungeonIdToPlayerCount[_destinationDungeonId]++;
983         
984         // ** STORAGE UPDATE **
985         // Update player location.
986         playerToDungeonID[msg.sender] = _destinationDungeonId;
987             
988         // Emit the DungeonChallenged event.
989         PlayerTransported(now, msg.sender, _originDungeonId, _destinationDungeonId);
990     }
991     
992     
993     /* ======== MODIFIERS ======== */
994     
995     /**
996      * @dev Throws if dungeon status do not allow transportation, also check for dungeon existence.
997      *  Also check if the capacity of the destination dungeon is reached.
998      */
999     modifier dungeonCanTransport(uint _destinationDungeonId) {
1000         require(_destinationDungeonId < dungeonTokenContract.totalSupply());
1001         
1002         uint status;
1003         uint capacity;
1004         (, status,, capacity,,,,,) = dungeonTokenContract.dungeons(_destinationDungeonId);
1005         require(status == 0 || status == 1);
1006         
1007         // Check if the capacity of the destination dungeon is reached.
1008         // Capacity 0 = Infinity
1009         require(capacity == 0 || dungeonIdToPlayerCount[_destinationDungeonId] < capacity);
1010         _;
1011     }
1012     
1013     /// @dev Throws if player did recruit first hero yet.
1014     modifier playerAllowedToTransport() {
1015         // Note that we check playerToFirstHeroRecruited instead of heroTokenContract.balanceOf
1016         // in order to prevent "capacity attack".
1017         require(playerToFirstHeroRecruited[msg.sender]);
1018         _;
1019     }
1020     
1021 }
1022 
1023 
1024 contract EDChallenge is EDTransportation {
1025     
1026     /* ======== PUBLIC/EXTERNAL FUNCTIONS ======== */
1027     
1028     /**
1029      * @dev The main external function to call when a player challenge a dungeon,
1030      *  it determines whether if the player successfully challenged the current floor.
1031      *  Will generate a DungeonChallenged event.
1032      */
1033     function challenge(uint _dungeonId, uint _heroId) whenNotPaused dungeonCanChallenge(_dungeonId) heroAllowedToChallenge(_heroId) external payable {
1034         // Set the last action block number, disallow player to perform another train or challenge in the same block.
1035         playerToLastActionBlockNumber[msg.sender] = block.number;
1036         
1037         // Set the previously temp stored upgraded hero genes.
1038         _setTempHeroPower();
1039         
1040         // Get the dungeon details from the token contract.
1041         uint difficulty;
1042         uint seedGenes;
1043         (,, difficulty,,,,, seedGenes,) = dungeonTokenContract.dungeons(_dungeonId);
1044         
1045         // Checks for payment, any exceeding funds will be transferred back to the player.
1046         uint requiredFee = difficulty * challengeFeeMultiplier;
1047         require(msg.value >= requiredFee);
1048         
1049         // ** STORAGE UPDATE **
1050         // Increment the accumulated rewards for the dungeon.
1051         dungeonTokenContract.addDungeonRewards(_dungeonId, requiredFee);
1052 
1053         // Calculate any excess funds and make it available to be withdrawed by the player.
1054         asyncSend(msg.sender, msg.value - requiredFee);
1055         
1056         // Split the challenge function into multiple parts because of stack too deep error.
1057         _challengePart2(_dungeonId, difficulty, _heroId);
1058     }
1059     
1060     
1061     /* ======== INTERNAL/PRIVATE FUNCTIONS ======== */
1062     
1063     /// @dev Compute the remaining time for which the hero can perform a challenge again.
1064     function _computeCooldownRemainingTime(uint _heroId) internal view returns (uint) {
1065         uint cooldownStartTime;
1066         uint cooldownIndex;
1067         (, cooldownStartTime, cooldownIndex,) = heroTokenContract.heroes(_heroId);
1068         
1069         // Cooldown period is FLOOR(challenge count / 2) ^ 2 minutes
1070         uint cooldownPeriod = (cooldownIndex / 2) ** 2 * 1 minutes;
1071         
1072         if (cooldownPeriod > 100 minutes) {
1073             cooldownPeriod = 100 minutes;
1074         }
1075         
1076         uint cooldownEndTime = cooldownStartTime + cooldownPeriod;
1077         
1078         if (cooldownEndTime <= now) {
1079             return 0;
1080         } else {
1081             return cooldownEndTime - now;
1082         }
1083     }
1084     
1085     /// @dev Split the challenge function into multiple parts because of stack too deep error.
1086     function _challengePart2(uint _dungeonId, uint _dungeonDifficulty, uint _heroId) private {
1087         uint floorNumber;
1088         uint rewards;
1089         uint floorGenes;
1090         (,,,, floorNumber,, rewards,, floorGenes) = dungeonTokenContract.dungeons(_dungeonId);
1091         
1092         // Get the hero gene.
1093         uint heroGenes;
1094         (,,, heroGenes) = heroTokenContract.heroes(_heroId);
1095         
1096         bool success = _getChallengeSuccess(heroGenes, _dungeonDifficulty, floorGenes);
1097         
1098         uint newFloorGenes;
1099         uint masterRewards;
1100         uint consolationRewards;
1101         uint successRewards;
1102         uint newRewards;
1103         
1104         // Whether a challenge is success or not is determined by a simple comparison between hero power and floor power.
1105         if (success) {
1106             newFloorGenes = _getNewFloorGene(_dungeonId);
1107             
1108             masterRewards = rewards * masterRewardsPercent / 100;
1109             
1110             consolationRewards = rewards * consolationRewardsPercent / 100;
1111             
1112             if (floorNumber < rushTimeFloorCount) { // rush time right after prepration period
1113                 successRewards = rewards * rushTimeChallengeRewardsPercent / 100;
1114                 
1115                 // The dungeon rewards for new floor as total rewards - challenge rewards - devleoper fee.
1116                 newRewards = rewards * (100 - rushTimeChallengeRewardsPercent - masterRewardsPercent - consolationRewardsPercent) / 100;
1117             } else {
1118                 successRewards = rewards * challengeRewardsPercent / 100;
1119                 newRewards = rewards * (100 - challengeRewardsPercent - masterRewardsPercent - consolationRewardsPercent) / 100;
1120             }
1121             
1122             // TRIPLE CONFIRM sanity check.
1123             require(successRewards + masterRewards + consolationRewards + newRewards <= rewards);
1124             
1125             // ** STORAGE UPDATE **
1126             // Add the consolation rewards to grandConsolationRewards.
1127             grandConsolationRewards += consolationRewards;
1128             
1129             // Add new floor with the new floor genes and new rewards.
1130             dungeonTokenContract.addDungeonNewFloor(_dungeonId, newRewards, newFloorGenes);
1131             
1132             // Mark the challenge rewards available to be withdrawed by the player.
1133             asyncSend(msg.sender, successRewards);
1134             
1135             // Mark the master rewards available to be withdrawed by the dungeon master.
1136             asyncSend(dungeonTokenContract.ownerOf(_dungeonId), masterRewards);
1137         }
1138         
1139         // ** STORAGE UPDATE **
1140         // Trigger the cooldown for the hero.
1141         heroTokenContract.triggerCooldown(_heroId);
1142             
1143         // Emit the DungeonChallenged event.
1144         DungeonChallenged(now, msg.sender, _dungeonId, _heroId, heroGenes, floorNumber, floorGenes, success, newFloorGenes, successRewards, masterRewards);
1145     }
1146     
1147     /// @dev Split the challenge function into multiple parts because of stack too deep error.
1148     function _getChallengeSuccess(uint _heroGenes, uint _dungeonDifficulty, uint _floorGenes) private pure returns (bool) {
1149         // Determine if the player challenge successfuly the dungeon or not.
1150         uint heroPower;
1151         (heroPower,,,,,) = getHeroPower(_heroGenes, _dungeonDifficulty);
1152         
1153         uint floorPower = getDungeonPower(_floorGenes);
1154         
1155         return heroPower > floorPower;
1156     }
1157     
1158     /// @dev Split the challenge function into multiple parts because of stack too deep error.
1159     function _getNewFloorGene(uint _dungeonId) private returns (uint) {
1160         uint seedGenes;
1161         uint floorGenes;
1162         (,,,,,, seedGenes, floorGenes) = dungeonTokenContract.dungeons(_dungeonId);
1163         
1164         // Calculate the new floor gene.
1165         uint floorPower = getDungeonPower(floorGenes);
1166         
1167         // Call the external closed source secret function that determines the resulting floor "genes".
1168         uint newFloorGenes = challengeFormulaContract.calculateResult(floorGenes, seedGenes);
1169         uint newFloorPower = getDungeonPower(newFloorGenes);
1170         
1171         // If the power decreased, rollback to the current floor genes.
1172         if (newFloorPower < floorPower) {
1173             newFloorGenes = floorGenes;
1174         }
1175         
1176         return newFloorGenes;
1177     }
1178     
1179     
1180     /* ======== MODIFIERS ======== */
1181     
1182     /**
1183      * @dev Throws if dungeon status do not allow challenge, also check for dungeon existence.
1184      *  Also check if the user is in the dungeon.
1185      *  Also check if the dungeon is not in preparation period.
1186      */
1187     modifier dungeonCanChallenge(uint _dungeonId) {
1188         require(_dungeonId < dungeonTokenContract.totalSupply());
1189         
1190         uint creationTime;
1191         uint status;
1192         (creationTime, status,,,,,,,) = dungeonTokenContract.dungeons(_dungeonId);
1193         require(status == 0 || status == 2);
1194         
1195         // Check if the user is in the dungeon.
1196         require(playerToDungeonID[msg.sender] == _dungeonId);
1197         
1198         // Check if the dungeon is not in preparation period.
1199         require(creationTime + dungeonPreparationTime <= now);
1200         _;
1201     }
1202     
1203     /**
1204      * @dev Throws if player does not own the hero, or the hero is still in cooldown period,
1205      *  and no pending power update.
1206      */
1207     modifier heroAllowedToChallenge(uint _heroId) {
1208         // You can only challenge with your own hero.
1209         require(heroTokenContract.ownerOf(_heroId) == msg.sender);
1210         
1211         // Hero must not be in cooldown period
1212         uint cooldownRemainingTime = _computeCooldownRemainingTime(_heroId);
1213         require(cooldownRemainingTime == 0);
1214         
1215         // Prevent player to perform training and challenge in the same block to avoid bot exploit.
1216         require(block.number > playerToLastActionBlockNumber[msg.sender]);
1217         _;
1218     }
1219     
1220 }
1221 
1222 
1223 contract EDTraining is EDChallenge {
1224     
1225     /* ======== PUBLIC/EXTERNAL FUNCTIONS ======== */
1226     
1227     /**
1228      * @dev The external function to call when a hero train with a dungeon,
1229      *  it determines whether whether a training is successfully, and the resulting genes.
1230      *  Will generate a DungeonChallenged event.
1231      */
1232     function train1(uint _dungeonId, uint _heroId) whenNotPaused dungeonCanTrain(_dungeonId) heroAllowedToTrain(_heroId) external payable {
1233         _train(_dungeonId, _heroId, 0, 1);
1234     }
1235     
1236     function train2(uint _dungeonId, uint _heroId) whenNotPaused dungeonCanTrain(_dungeonId) heroAllowedToTrain(_heroId) external payable {
1237         _train(_dungeonId, _heroId, 0, 2);
1238     }
1239     
1240     function train3(uint _dungeonId, uint _heroId) whenNotPaused dungeonCanTrain(_dungeonId) heroAllowedToTrain(_heroId) external payable {
1241         _train(_dungeonId, _heroId, 0, 3);
1242     }
1243     
1244     /**
1245      * @dev The external function to call when a hero train a particular equipment with a dungeon,
1246      *  it determines whether whether a training is successfully, and the resulting genes.
1247      *  Will generate a DungeonChallenged event.
1248      *  _equipmentIndex is the index of equipment: 0 is train all attributes, including equipments and stats.
1249      *  1: weapon | 2: shield | 3: armor | 4: shoe | 5: helmet | 6: gloves | 7: belt | 8: shawl
1250      */
1251     function trainEquipment(uint _dungeonId, uint _heroId, uint _equipmentIndex) whenNotPaused dungeonCanTrain(_dungeonId) heroAllowedToTrain(_heroId) external payable {
1252         require(_equipmentIndex <= 8);
1253         
1254         _train(_dungeonId, _heroId, _equipmentIndex, 1);
1255     }
1256     
1257     
1258     /* ======== INTERNAL/PRIVATE FUNCTIONS ======== */
1259     
1260     /**
1261      * @dev An internal function of a hero train with dungeon,
1262      *  it determines whether whether a training is successfully, and the resulting genes.
1263      *  Will generate a DungeonChallenged event.
1264      */
1265     function _train(uint _dungeonId, uint _heroId, uint _equipmentIndex, uint _trainingTimes) private {
1266         // Set the last action block number, disallow player to perform another train or challenge in the same block.
1267         playerToLastActionBlockNumber[msg.sender] = block.number;
1268         
1269         // Set the previously temp stored upgraded hero genes.
1270         _setTempHeroPower();
1271         
1272         // Get the dungeon details from the token contract.
1273         uint creationTime;
1274         uint difficulty;
1275         uint floorNumber;
1276         uint rewards;
1277         uint seedGenes;
1278         uint floorGenes;
1279         (creationTime,, difficulty,, floorNumber,, rewards, seedGenes, floorGenes) = dungeonTokenContract.dungeons(_dungeonId);
1280         
1281         // Check for _trainingTimes abnormality, we probably won't have any feature that train a hero 10 times with a single call.
1282         require(_trainingTimes < 10);
1283         
1284         // Checks for payment, any exceeding funds will be transferred back to the player.
1285         uint requiredFee;
1286         
1287         // Calculate the required training fee.
1288         if (now < creationTime + dungeonPreparationTime) {
1289             // Apply preparation period discount. 
1290             if (_equipmentIndex > 0) { // train specific equipments
1291                 requiredFee = difficulty * preparationPeriodEquipmentTrainingFeeMultiplier * _trainingTimes;
1292             } else { // train all attributes
1293                 requiredFee = difficulty * preparationPeriodTrainingFeeMultiplier * _trainingTimes;
1294             }
1295         } else {
1296             if (_equipmentIndex > 0) { // train specific equipments
1297                 requiredFee = difficulty * equipmentTrainingFeeMultiplier * _trainingTimes;
1298             } else { // train all attributes
1299                 requiredFee = difficulty * trainingFeeMultiplier * _trainingTimes;
1300             }
1301         }
1302         
1303         require(msg.value >= requiredFee);
1304         
1305         // Get the hero gene.
1306         uint heroGenes;
1307         (,,, heroGenes) = heroTokenContract.heroes(_heroId);
1308         
1309         // ** STORAGE UPDATE **
1310         // Increment the accumulated rewards for the dungeon.
1311         dungeonTokenContract.addDungeonRewards(_dungeonId, requiredFee);
1312 
1313         // Calculate any excess funds and make it available to be withdrawed by the player.
1314         asyncSend(msg.sender, msg.value - requiredFee);
1315         
1316         // Split the _train function into multiple parts because of stack too deep error.
1317         _trainPart2(_dungeonId, _heroId, _equipmentIndex, _trainingTimes, difficulty, floorNumber, floorGenes, heroGenes);
1318     }
1319     
1320     /// @dev Split the _train function into multiple parts because of Stack Too Deep error.
1321     function _trainPart2(
1322         uint _dungeonId,
1323         uint _heroId,
1324         uint _equipmentIndex,
1325         uint _trainingTimes,
1326         uint _dungeonDifficulty,
1327         uint _floorNumber,
1328         uint _floorGenes,
1329         uint _heroGenes
1330     ) private {
1331         // Determine if the hero training is successful or not, and the resulting genes.
1332         uint heroPower;
1333         bool isSuper;
1334         (heroPower,,, isSuper,,) = getHeroPower(_heroGenes, _dungeonDifficulty);
1335         
1336         uint newHeroGenes;
1337         uint newHeroPower;
1338         (newHeroGenes, newHeroPower) = _calculateNewHeroPower(_dungeonDifficulty, _heroGenes, _equipmentIndex, _trainingTimes, heroPower, isSuper, _floorGenes);
1339 
1340         // Set the new hero genes if updated (sometimes there is no power increase during equipment forging).
1341         if (newHeroGenes != _heroGenes) {
1342             if (newHeroPower >= 256) {
1343                 // Do not update immediately to prevent deterministic training exploit.
1344                 tempSuccessTrainingHeroId = _heroId;
1345                 tempSuccessTrainingNewHeroGenes = newHeroGenes;
1346             } else {
1347                 // Immediately update the genes for small power hero.
1348                 // ** STORAGE UPDATE **
1349                 heroTokenContract.setHeroGenes(_heroId, newHeroGenes);
1350             }
1351         }
1352         
1353         // Training is successful only when power increase, changing another equipment with same power is considered failure
1354         // and faith will be given accordingly.
1355         bool success = newHeroPower > heroPower;
1356         
1357         if (!success) {
1358             // Handle training failure - consolation rewards mechanics.
1359             _handleTrainingFailure(_equipmentIndex, _trainingTimes, _dungeonDifficulty);
1360         }
1361         
1362         // Emit the HeroTrained event.
1363         HeroTrained(now, msg.sender, _dungeonId, _heroId, _heroGenes, _floorNumber, _floorGenes, success, newHeroGenes);
1364     }
1365     
1366     /// @dev Determine if the hero training is successful or not, and the resulting genes and power.
1367     function _calculateNewHeroPower(
1368         uint _dungeonDifficulty, 
1369         uint _heroGenes, 
1370         uint _equipmentIndex, 
1371         uint _trainingTimes, 
1372         uint _heroPower, 
1373         bool _isSuper, 
1374         uint _floorGenes
1375     ) private returns (uint newHeroGenes, uint newHeroPower) {
1376         newHeroGenes = _heroGenes;
1377         newHeroPower = _heroPower;
1378         bool newIsSuper = _isSuper;
1379         
1380         // Train the hero multiple times according to _trainingTimes, 
1381         // each time if the resulting power is larger, update new hero power.
1382         for (uint i = 0; i < _trainingTimes; i++) {
1383             // Call the external closed source secret function that determines the resulting hero "genes".
1384             uint tmpHeroGenes = trainingFormulaContract.calculateResult(newHeroGenes, _floorGenes, _equipmentIndex);
1385             
1386             uint tmpHeroPower;
1387             bool tmpIsSuper;
1388             (tmpHeroPower,,, tmpIsSuper,,) = getHeroPower(tmpHeroGenes, _dungeonDifficulty);
1389             
1390             if (tmpHeroPower > newHeroPower) {
1391                 // Prevent Super Hero downgrade.
1392                 if (!(newIsSuper && !tmpIsSuper)) {
1393                     newHeroGenes = tmpHeroGenes;
1394                     newHeroPower = tmpHeroPower;
1395                 }
1396             } else if (_equipmentIndex > 0 && tmpHeroPower == newHeroPower && tmpHeroGenes != newHeroGenes) {
1397                 // Allow Equipment Forging to replace current requipemnt with a same power equipment.
1398                 // The training is considered failed (faith will be given, but the equipment will change).
1399                 newHeroGenes = tmpHeroGenes;
1400                 newHeroPower = tmpHeroPower;
1401             }
1402         }
1403     }
1404     
1405     /// @dev Calculate and assign the appropriate faith value to the player.
1406     function _handleTrainingFailure(uint _equipmentIndex, uint _trainingTimes, uint _dungeonDifficulty) private {
1407         // Failed training in a dungeon will add to player's faith value.
1408         uint faith = playerToFaith[msg.sender];
1409         uint faithEarned;
1410         
1411         if (_equipmentIndex == 0) { // Hero Training
1412             // The faith earned is proportional to the training fee, i.e. _difficulty * _trainingTimes.
1413             faithEarned = _dungeonDifficulty * _trainingTimes;
1414         } else { // Equipment Forging
1415             // Equipment Forging faith earned is only 2 times normal training, not proportional to forging fee.
1416             faithEarned = _dungeonDifficulty * _trainingTimes * 2;
1417         }
1418         
1419         uint newFaith = faith + faithEarned;
1420         
1421         // Hitting the required amount in faith will get a proportion of grandConsolationRewards
1422         if (newFaith >= consolationRewardsRequiredFaith) {
1423             uint consolationRewards = grandConsolationRewards * consolationRewardsClaimPercent / 100;
1424             
1425             // ** STORAGE UPDATE **
1426             grandConsolationRewards -= consolationRewards;
1427             
1428             // Mark the consolation rewards available to be withdrawed by the player.
1429             asyncSend(msg.sender, consolationRewards);
1430             
1431             // Reset the faith value.
1432             newFaith -= consolationRewardsRequiredFaith;
1433             
1434             ConsolationRewardsClaimed(now, msg.sender, consolationRewards);
1435         }
1436         
1437         // ** STORAGE UPDATE **
1438         playerToFaith[msg.sender] = newFaith;
1439     }
1440     
1441     
1442     /* ======== MODIFIERS ======== */
1443     
1444     /**
1445      * @dev Throws if dungeon status do not allow training, also check for dungeon existence.
1446      *  Also check if the user is in the dungeon.
1447      */
1448     modifier dungeonCanTrain(uint _dungeonId) {
1449         require(_dungeonId < dungeonTokenContract.totalSupply());
1450         uint status;
1451         (,status,,,,,,,) = dungeonTokenContract.dungeons(_dungeonId);
1452         require(status == 0 || status == 3);
1453         
1454         // Also check if the user is in the dungeon.
1455         require(playerToDungeonID[msg.sender] == _dungeonId);
1456         _;
1457     }
1458     
1459     /**
1460      * @dev Throws if player does not own the hero, and no pending power update.
1461      */
1462     modifier heroAllowedToTrain(uint _heroId) {
1463         require(heroTokenContract.ownerOf(_heroId) == msg.sender);
1464         
1465         // Prevent player to perform training and challenge in the same block to avoid bot exploit.
1466         require(block.number > playerToLastActionBlockNumber[msg.sender]);
1467         _;
1468     }
1469     
1470 }
1471 
1472 
1473 /**
1474  * @title EDCoreVersion1
1475  * @dev Core Contract of Ether Dungeon.
1476  *  When Version 2 launches, EDCoreVersion2 contract will be deployed and EDCoreVersion1 will be destroyed.
1477  *  Since all dungeons and heroes are stored as tokens in external contracts, they remains immutable.
1478  */
1479 contract EDCoreVersion1 is Destructible, EDTraining {
1480     
1481     /**
1482      * Initialize the EDCore contract with all the required contract addresses.
1483      */
1484     function EDCoreVersion1(
1485         address _dungeonTokenAddress,
1486         address _heroTokenAddress,
1487         address _challengeFormulaAddress, 
1488         address _trainingFormulaAddress
1489     ) public payable {
1490         dungeonTokenContract = DungeonTokenInterface(_dungeonTokenAddress);
1491         heroTokenContract = HeroTokenInterface(_heroTokenAddress);
1492         challengeFormulaContract = ChallengeFormulaInterface(_challengeFormulaAddress);
1493         trainingFormulaContract = TrainingFormulaInterface(_trainingFormulaAddress);
1494     }
1495 
1496     
1497     /* ======== PUBLIC/EXTERNAL FUNCTIONS ======== */
1498     
1499     /// @dev The external function to get all the game settings in one call.
1500     function getGameSettings() external view returns (
1501         uint _recruitHeroFee,
1502         uint _transportationFeeMultiplier,
1503         uint _noviceDungeonId,
1504         uint _consolationRewardsRequiredFaith,
1505         uint _challengeFeeMultiplier,
1506         uint _dungeonPreparationTime,
1507         uint _trainingFeeMultiplier,
1508         uint _equipmentTrainingFeeMultiplier,
1509         uint _preparationPeriodTrainingFeeMultiplier,
1510         uint _preparationPeriodEquipmentTrainingFeeMultiplier
1511     ) {
1512         _recruitHeroFee = recruitHeroFee;
1513         _transportationFeeMultiplier = transportationFeeMultiplier;
1514         _noviceDungeonId = noviceDungeonId;
1515         _consolationRewardsRequiredFaith = consolationRewardsRequiredFaith;
1516         _challengeFeeMultiplier = challengeFeeMultiplier;
1517         _dungeonPreparationTime = dungeonPreparationTime;
1518         _trainingFeeMultiplier = trainingFeeMultiplier;
1519         _equipmentTrainingFeeMultiplier = equipmentTrainingFeeMultiplier;
1520         _preparationPeriodTrainingFeeMultiplier = preparationPeriodTrainingFeeMultiplier;
1521         _preparationPeriodEquipmentTrainingFeeMultiplier = preparationPeriodEquipmentTrainingFeeMultiplier;
1522     }
1523     
1524     /**
1525      * @dev The external function to get all the relevant information about a specific player by its address.
1526      * @param _address The address of the player.
1527      */
1528     function getPlayerDetails(address _address) external view returns (
1529         uint dungeonId, 
1530         uint payment, 
1531         uint dungeonCount, 
1532         uint heroCount, 
1533         uint faith,
1534         bool firstHeroRecruited
1535     ) {
1536         payment = payments[_address];
1537         dungeonCount = dungeonTokenContract.balanceOf(_address);
1538         heroCount = heroTokenContract.balanceOf(_address);
1539         faith = playerToFaith[_address];
1540         firstHeroRecruited = playerToFirstHeroRecruited[_address];
1541         
1542         // If a player didn't recruit any hero yet, consider the player is in novice dungeon
1543         if (firstHeroRecruited) {
1544             dungeonId = playerToDungeonID[_address];
1545         } else {
1546             dungeonId = noviceDungeonId;
1547         }
1548     }
1549     
1550     /**
1551      * @dev The external function to get all the relevant information about a specific dungeon by its ID.
1552      * @param _id The ID of the dungeon.
1553      */
1554     function getDungeonDetails(uint _id) external view returns (
1555         uint creationTime, 
1556         uint status, 
1557         uint difficulty, 
1558         uint capacity, 
1559         address owner, 
1560         bool isReady, 
1561         uint playerCount
1562     ) {
1563         require(_id < dungeonTokenContract.totalSupply());
1564         
1565         // Didn't get the "floorCreationTime" because of Stack Too Deep error.
1566         (creationTime, status, difficulty, capacity,,,,,) = dungeonTokenContract.dungeons(_id);
1567         
1568         // Dungeon is ready to be challenged (not in preparation mode).
1569         owner = dungeonTokenContract.ownerOf(_id);
1570         isReady = creationTime + dungeonPreparationTime <= now;
1571         playerCount = dungeonIdToPlayerCount[_id];
1572     }
1573     
1574     /**
1575      * @dev Split floor related details out of getDungeonDetails, just to avoid Stack Too Deep error.
1576      * @param _id The ID of the dungeon.
1577      */
1578     function getDungeonFloorDetails(uint _id) external view returns (
1579         uint floorNumber, 
1580         uint floorCreationTime, 
1581         uint rewards, 
1582         uint seedGenes, 
1583         uint floorGenes
1584     ) {
1585         require(_id < dungeonTokenContract.totalSupply());
1586         
1587         // Didn't get the "floorCreationTime" because of Stack Too Deep error.
1588         (,,,, floorNumber, floorCreationTime, rewards, seedGenes, floorGenes) = dungeonTokenContract.dungeons(_id);
1589     }
1590 
1591     /**
1592      * @dev The external function to get all the relevant information about a specific hero by its ID.
1593      * @param _id The ID of the hero.
1594      */
1595     function getHeroDetails(uint _id) external view returns (
1596         uint creationTime, 
1597         uint cooldownStartTime, 
1598         uint cooldownIndex, 
1599         uint genes, 
1600         address owner, 
1601         bool isReady, 
1602         uint cooldownRemainingTime
1603     ) {
1604         require(_id < heroTokenContract.totalSupply());
1605 
1606         (creationTime, cooldownStartTime, cooldownIndex, genes) = heroTokenContract.heroes(_id);
1607         
1608         // Hero is ready to challenge (not in cooldown mode).
1609         owner = heroTokenContract.ownerOf(_id);
1610         cooldownRemainingTime = _computeCooldownRemainingTime(_id);
1611         isReady = cooldownRemainingTime == 0;
1612     }
1613     
1614     
1615     /* ======== MIGRATION FUNCTIONS ======== */
1616     
1617     /**
1618      * @dev Since the DungeonToken contract is re-deployed due to optimization.
1619      *  We need to migrate all dungeons from Beta token contract to Version 1.
1620      */
1621     function migrateDungeon(uint _id, uint _playerCount) external {
1622         // Migration will be finished before maintenance period ends, tx.origin is used within a short period only.
1623         require(now < 1520694000 && tx.origin == 0x47169f78750Be1e6ec2DEb2974458ac4F8751714);
1624         
1625         dungeonIdToPlayerCount[_id] = _playerCount;
1626     }
1627     
1628     /**
1629      * @dev We need to migrate all player location from Beta token contract to Version 1.
1630      */
1631     function migratePlayer(address _address, uint _ownerDungeonId, uint _payment, uint _faith) external {
1632         // Migration will be finished before maintenance period ends, tx.origin is used within a short period only.
1633         require(now < 1520694000 && tx.origin == 0x47169f78750Be1e6ec2DEb2974458ac4F8751714);
1634         
1635         playerToDungeonID[_address] = _ownerDungeonId;
1636         
1637         if (_payment > 0) {
1638             asyncSend(_address, _payment);
1639         }
1640         
1641         if (_faith > 0) {
1642             playerToFaith[_address] = _faith;
1643         }
1644         
1645         playerToFirstHeroRecruited[_address] = true;
1646     }
1647     
1648 }