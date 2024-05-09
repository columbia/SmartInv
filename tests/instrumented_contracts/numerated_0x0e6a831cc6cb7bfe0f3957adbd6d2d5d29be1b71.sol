1 pragma solidity 0.4.19;
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
44  * @title Pausable
45  * @dev Base contract which allows children to implement an emergency stop mechanism.
46  */
47 contract Pausable is Ownable {
48 
49   event Pause();
50   event Unpause();
51 
52   bool public paused = false;
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
85 
86 }
87 
88 
89 /**
90  * @title Destructible
91  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
92  */
93 contract Destructible is Ownable {
94 
95   function Destructible() public payable { }
96 
97   /**
98    * @dev Transfers the current balance to the owner and terminates the contract.
99    */
100   function destroy() onlyOwner public {
101     selfdestruct(owner);
102   }
103 
104   function destroyAndSend(address _recipient) onlyOwner public {
105     selfdestruct(_recipient);
106   }
107 
108 }
109 
110 
111 /// @dev Interface to the Core Contract of Ether Dungeon.
112 contract EDCoreInterface {
113 
114     /// @dev The external function to get all the game settings in one call.
115     function getGameSettings() external view returns (
116         uint _recruitHeroFee,
117         uint _transportationFeeMultiplier,
118         uint _noviceDungeonId,
119         uint _consolationRewardsRequiredFaith,
120         uint _challengeFeeMultiplier,
121         uint _dungeonPreparationTime,
122         uint _trainingFeeMultiplier,
123         uint _equipmentTrainingFeeMultiplier,
124         uint _preparationPeriodTrainingFeeMultiplier,
125         uint _preparationPeriodEquipmentTrainingFeeMultiplier
126     );
127 
128     /**
129      * @dev The external function to get all the relevant information about a specific player by its address.
130      * @param _address The address of the player.
131      */
132     function getPlayerDetails(address _address) external view returns (
133         uint dungeonId,
134         uint payment,
135         uint dungeonCount,
136         uint heroCount,
137         uint faith,
138         bool firstHeroRecruited
139     );
140 
141     /**
142      * @dev The external function to get all the relevant information about a specific dungeon by its ID.
143      * @param _id The ID of the dungeon.
144      */
145     function getDungeonDetails(uint _id) external view returns (
146         uint creationTime,
147         uint status,
148         uint difficulty,
149         uint capacity,
150         address owner,
151         bool isReady,
152         uint playerCount
153     );
154 
155     /**
156      * @dev Split floor related details out of getDungeonDetails, just to avoid Stack Too Deep error.
157      * @param _id The ID of the dungeon.
158      */
159     function getDungeonFloorDetails(uint _id) external view returns (
160         uint floorNumber,
161         uint floorCreationTime,
162         uint rewards,
163         uint seedGenes,
164         uint floorGenes
165     );
166 
167     /**
168      * @dev The external function to get all the relevant information about a specific hero by its ID.
169      * @param _id The ID of the hero.
170      */
171     function getHeroDetails(uint _id) external view returns (
172         uint creationTime,
173         uint cooldownStartTime,
174         uint cooldownIndex,
175         uint genes,
176         address owner,
177         bool isReady,
178         uint cooldownRemainingTime
179     );
180 
181     /// @dev Get the attributes (equipments + stats) of a hero from its gene.
182     function getHeroAttributes(uint _genes) public pure returns (uint[]);
183 
184     /// @dev Calculate the power of a hero from its gene, it calculates the equipment power, stats power, and super hero boost.
185     function getHeroPower(uint _genes, uint _dungeonDifficulty) public pure returns (
186         uint totalPower,
187         uint equipmentPower,
188         uint statsPower,
189         bool isSuper,
190         uint superRank,
191         uint superBoost
192     );
193 
194     /// @dev Calculate the power of a dungeon floor.
195     function getDungeonPower(uint _genes) public pure returns (uint);
196 
197     /**
198      * @dev Calculate the sum of top 5 heroes power a player owns.
199      *  The gas usage increased with the number of heroes a player owned, roughly 500 x hero count.
200      *  This is used in transport function only to calculate the required tranport fee.
201      */
202     function calculateTop5HeroesPower(address _address, uint _dungeonId) public view returns (uint);
203 
204 }
205 
206 
207 /**
208  * @title Core Contract of "Dungeon Run" event game of the ED (Ether Dungeon) Platform.
209  * @dev Dungeon Run is a single-player game mode added to the Ether Dungeon platform.
210  *  The objective of Dungeon Run is to defeat as many monsters as possible.
211  */
212 contract DungeonRunCore is Pausable, Destructible {
213 
214     /*=================================
215     =             STRUCTS             =
216     =================================*/
217 
218     struct Monster {
219         uint64 creationTime;
220         uint8 level;
221         uint16 initialHealth;
222         uint16 health;
223     }
224 
225 
226     /*=================================
227     =            CONTRACTS            =
228     =================================*/
229 
230     /// @dev The address of the EtherDungeonCore contract.
231     EDCoreInterface public edCoreContract = EDCoreInterface(0xf7eD56c1AC4d038e367a987258b86FC883b960a1);
232 
233 
234     /*=================================
235     =            CONSTANTS            =
236     =================================*/
237 
238     /// @dev By defeating the checkPointLevel, half of the entranceFee is refunded.
239     uint8 public constant checkpointLevel = 5;
240 
241     /// @dev By defeating the breakevenLevel, another half of the entranceFee is refunded.
242     uint8 public constant breakevenLevel = 10;
243 
244     /// @dev By defeating the jackpotLevel, the player win the entire jackpot.
245     uint8 public constant jackpotLevel = 12;
246 
247     /// @dev Dungeon difficulty to be used when calculating super hero power boost, 3 is 64 power boost.
248     uint public constant dungeonDifficulty = 3;
249 
250     /// @dev The health of a monster is level * monsterHealth;
251     uint16 public monsterHealth = 10;
252 
253     /// @dev When a monster flees, the hero health is reduced by monster level + monsterStrength.
254     uint public monsterStrength = 4;
255 
256     /// @dev After a certain period of time, the monster will attack the hero and flee.
257     uint64 public monsterFleeTime = 8 minutes;
258 
259 
260     /*=================================
261     =            SETTINGS             =
262     =================================*/
263 
264     /// @dev To start a run, a player need to pay an entrance fee.
265     uint public entranceFee = 0.04 ether;
266 
267     /// @dev Fee required to reset a run for a given hero, the fee will go to the jackpot.
268     uint public reviveFee = 0.02 ether;
269 
270     /// @dev 0.1 ether is provided as the initial jackpot.
271     uint public jackpot = 0.1 ether;
272 
273     /**
274      * @dev The dungeon run entrance fee will first be deposited to a pool first, when the hero is
275      *  defeated by a monster, then the fee will be added to the jackpot.
276      */
277     uint public entranceFeePool;
278 
279     /// @dev Private seed for the PRNG used for calculating damage amount.
280     uint _seed;
281 
282 
283     /*=================================
284     =         STATE VARIABLES         =
285     =================================*/
286 
287     /// @dev A mapping from hero ID to the current run monster, a 0 value indicates no current run.
288     mapping(uint => Monster) public heroIdToMonster;
289 
290     /// @dev A mapping from hero ID to its current health.
291     mapping(uint => uint) public heroIdToHealth;
292 
293     /// @dev A mapping from hero ID to the refunded fee.
294     mapping(uint => uint) public heroIdToRefundedFee;
295 
296 
297     /*==============================
298     =            EVENTS            =
299     ==============================*/
300 
301     /// @dev The LogAttack event is fired whenever a hero attack a monster.
302     event LogAttack(uint timestamp, address indexed player, uint indexed heroId, uint indexed monsterLevel, uint damageByHero, uint damageByMonster, bool isMonsterDefeated, uint rewards);
303 
304     function DungeonRunAlpha() public payable {}
305 
306     /*=======================================
307     =       PUBLIC/EXTERNAL FUNCTIONS       =
308     =======================================*/
309 
310     /// @dev The external function to get all the game settings in one call.
311     function getGameSettings() external view returns (
312         uint _checkpointLevel,
313         uint _breakevenLevel,
314         uint _jackpotLevel,
315         uint _dungeonDifficulty,
316         uint _monsterHealth,
317         uint _monsterStrength,
318         uint _monsterFleeTime,
319         uint _entranceFee,
320         uint _reviveFee
321     ) {
322         _checkpointLevel = checkpointLevel;
323         _breakevenLevel = breakevenLevel;
324         _jackpotLevel = jackpotLevel;
325         _dungeonDifficulty = dungeonDifficulty;
326         _monsterHealth = monsterHealth;
327         _monsterStrength = monsterStrength;
328         _monsterFleeTime = monsterFleeTime;
329         _entranceFee = entranceFee;
330         _reviveFee = reviveFee;
331     }
332 
333     /// @dev The external function to get the dungeon run details in one call.
334     function getRunDetails(uint _heroId) external view returns (
335         uint _heroPower,
336         uint _heroStrength,
337         uint _heroInitialHealth,
338         uint _heroHealth,
339         uint _monsterCreationTime,
340         uint _monsterLevel,
341         uint _monsterInitialHealth,
342         uint _monsterHealth,
343         uint _gameState // 0: NotStarted | 1: NewMonster | 2: Active | 3: RunEnded
344     ) {
345         uint genes;
346         address owner;
347         (,,, genes, owner,,) = edCoreContract.getHeroDetails(_heroId);
348         (_heroPower,,,,) = edCoreContract.getHeroPower(genes, dungeonDifficulty);
349         _heroStrength = (genes / (32 ** 8)) % 32 + 1;
350         _heroInitialHealth = (genes / (32 ** 12)) % 32 + 1;
351         _heroHealth = heroIdToHealth[_heroId];
352 
353         Monster memory monster = heroIdToMonster[_heroId];
354         _monsterCreationTime = monster.creationTime;
355 
356         // Dungeon run is ended if either hero is defeated (health exhausted),
357         // or hero failed to damage a monster before it flee.
358         bool _dungeonRunEnded = monster.level > 0 && (
359             _heroHealth == 0 || 
360             now > _monsterCreationTime + monsterFleeTime * 2 ||
361             (monster.health == monster.initialHealth && now > monster.creationTime + monsterFleeTime)
362         );
363 
364         // Calculate hero and monster stats based on different game state.
365         if (monster.level == 0) {
366             // Dungeon run not started yet.
367             _heroHealth = _heroInitialHealth;
368             _monsterLevel = 1;
369             _monsterInitialHealth = monsterHealth;
370             _monsterHealth = _monsterInitialHealth;
371             _gameState = 0;
372         } else if (_dungeonRunEnded) {
373             // Dungeon run ended.
374             _monsterLevel = monster.level;
375             _monsterInitialHealth = monster.initialHealth;
376             _monsterHealth = monster.health;
377             _gameState = 3;
378         } else if (now > _monsterCreationTime + monsterFleeTime) {
379             // Previous monster just fled, new monster awaiting.
380             if (monster.level + monsterStrength > _heroHealth) {
381                 _heroHealth = 0;
382                 _monsterLevel = monster.level;
383                 _monsterInitialHealth = monster.initialHealth;
384                 _monsterHealth = monster.health;
385                 _gameState = 2;
386             } else {
387                 _heroHealth -= monster.level + monsterStrength;
388                 _monsterCreationTime += monsterFleeTime;
389                 _monsterLevel = monster.level + 1;
390                 _monsterInitialHealth = _monsterLevel * monsterHealth;
391                 _monsterHealth = _monsterInitialHealth;
392                 _gameState = 1;
393             }
394         } else {
395             // Active monster.
396             _monsterLevel = monster.level;
397             _monsterInitialHealth = monster.initialHealth;
398             _monsterHealth = monster.health;
399             _gameState = 2;
400         }
401     }
402 
403     /**
404      * @dev To start a dungeon run, player need to call the attack function with an entranceFee.
405      *  Future attcks required no fee, player just need to send a free transaction
406      *  to the contract, before the monster flee. The lower the gas price, the larger the damage.
407      *  This function is prevented from being called by a contract, using the onlyHumanAddress modifier.
408      *  Note that each hero can only perform one dungeon run.
409      */
410     function attack(uint _heroId) whenNotPaused onlyHumanAddress external payable {
411         uint genes;
412         address owner;
413         (,,, genes, owner,,) = edCoreContract.getHeroDetails(_heroId);
414 
415         // Throws if the hero is not owned by the player.
416         require(msg.sender == owner);
417 
418         // Get the health and strength of the hero.
419         uint heroInitialHealth = (genes / (32 ** 12)) % 32 + 1;
420         uint heroStrength = (genes / (32 ** 8)) % 32 + 1;
421 
422         // Get the current monster and hero current health.
423         Monster memory monster = heroIdToMonster[_heroId];
424         uint currentLevel = monster.level;
425         uint heroCurrentHealth = heroIdToHealth[_heroId];
426 
427         // A flag determine whether the dungeon run has ended.
428         bool dungeonRunEnded;
429 
430         // To start a run, the player need to pay an entrance fee.
431         if (currentLevel == 0) {
432             // Throws if not enough fee, and any exceeding fee will be transferred back to the player.
433             require(msg.value >= entranceFee);
434             entranceFeePool += entranceFee;
435 
436             // Create level 1 monster, initial health is 1 * monsterHealth.
437             heroIdToMonster[_heroId] = Monster(uint64(now), 1, monsterHealth, monsterHealth);
438             monster = heroIdToMonster[_heroId];
439 
440             // Set the hero initial health to storage.
441             heroIdToHealth[_heroId] = heroInitialHealth;
442             heroCurrentHealth = heroInitialHealth;
443 
444             // Refund exceeding fee.
445             if (msg.value > entranceFee) {
446                 msg.sender.transfer(msg.value - entranceFee);
447             }
448         } else {
449             // If the hero health is 0, the dungeon run has ended.
450             require(heroCurrentHealth > 0);
451     
452             // If a hero failed to damage a monster before it flee, the dungeon run ends,
453             // regardless of the remaining hero health.
454             dungeonRunEnded = now > monster.creationTime + monsterFleeTime * 2 ||
455                 (monster.health == monster.initialHealth && now > monster.creationTime + monsterFleeTime);
456 
457             if (dungeonRunEnded) {
458                 // Add the non-refunded fee to jackpot.
459                 uint addToJackpot = entranceFee - heroIdToRefundedFee[_heroId];
460             
461                 if (addToJackpot > 0) {
462                     jackpot += addToJackpot;
463                     entranceFeePool -= addToJackpot;
464                     heroIdToRefundedFee[_heroId] += addToJackpot;
465                 }
466 
467                 // Sanity check.
468                 assert(addToJackpot <= entranceFee);
469             }
470             
471             // Future attack do not require any fee, so refund all ether sent with the transaction.
472             msg.sender.transfer(msg.value);
473         }
474 
475         if (!dungeonRunEnded) {
476             // All pre-conditions passed, call the internal attack function.
477             _attack(_heroId, genes, heroStrength, heroCurrentHealth);
478         }
479     }
480     
481     /**
482      * @dev Reset a dungeon run for a given hero.
483      */
484     function revive(uint _heroId) whenNotPaused external payable {
485         // Throws if not enough fee, and any exceeding fee will be transferred back to the player.
486         require(msg.value >= reviveFee);
487         
488         // The revive fee will do directly to jackpot.
489         jackpot += reviveFee;
490         
491         // Reset the dungeon run.
492         delete heroIdToHealth[_heroId];
493         delete heroIdToMonster[_heroId];
494         delete heroIdToRefundedFee[_heroId];
495     
496         // Refund exceeding fee.
497         if (msg.value > reviveFee) {
498             msg.sender.transfer(msg.value - reviveFee);
499         }
500     }
501 
502 
503     /*=======================================
504     =           SETTER FUNCTIONS            =
505     =======================================*/
506 
507     function setEdCoreContract(address _newEdCoreContract) onlyOwner external {
508         edCoreContract = EDCoreInterface(_newEdCoreContract);
509     }
510 
511     function setEntranceFee(uint _newEntranceFee) onlyOwner external {
512         entranceFee = _newEntranceFee;
513     }
514 
515     function setReviveFee(uint _newReviveFee) onlyOwner external {
516         reviveFee = _newReviveFee;
517     }
518 
519 
520     /*=======================================
521     =      INTERNAL/PRIVATE FUNCTIONS       =
522     =======================================*/
523 
524     /// @dev Internal function of attack, assume all parameter checking is done.
525     function _attack(uint _heroId, uint _genes, uint _heroStrength, uint _heroCurrentHealth) internal {
526         Monster storage monster = heroIdToMonster[_heroId];
527         uint8 currentLevel = monster.level;
528 
529         // Get the hero power.
530         uint heroPower;
531         (heroPower,,,,) = edCoreContract.getHeroPower(_genes, dungeonDifficulty);
532         
533         uint damageByMonster;
534         uint damageByHero;
535 
536         // Calculate the damage by hero first.
537         // The damage formula is (strength + power / (10 * rand)) / gasprice,
538         // where rand is a random integer from 1 to 5.
539         damageByHero = (_heroStrength * 1e9 + heroPower * 1e9 / (10 * (1 + _getRandomNumber(5)))) / (tx.gasprice >= 0.5 * 1e9 ? tx.gasprice : 0.5 * 1e9);
540         bool isMonsterDefeated = damageByHero >= monster.health;
541 
542         if (isMonsterDefeated) {
543             uint rewards;
544 
545             // Monster is defeated, game continues with a new monster.
546             // Create next level monster.
547             uint8 newLevel = currentLevel + 1;
548             heroIdToMonster[_heroId] = Monster(uint64(now), newLevel, newLevel * monsterHealth, newLevel * monsterHealth);
549             monster = heroIdToMonster[_heroId];
550 
551             // Determine the rewards based on current level.
552             if (currentLevel == checkpointLevel) {
553                 // By defeating the checkPointLevel boss, half of the entranceFee is refunded.
554                 rewards = entranceFee / 2;
555                 heroIdToRefundedFee[_heroId] += rewards;
556                 entranceFeePool -= rewards;
557             } else if (currentLevel == breakevenLevel) {
558                 // By defeating the breakevenLevel boss, another half of the entranceFee is refunded.
559                 rewards = entranceFee / 2;
560                 heroIdToRefundedFee[_heroId] += rewards;
561                 entranceFeePool -= rewards;
562             } else if (currentLevel == jackpotLevel) {
563                 // By defeating the jackpotLevel, the player win the entire jackpot.
564                 rewards = jackpot / 2;
565                 jackpot -= rewards;
566             }
567 
568             msg.sender.transfer(rewards);
569         } else {
570             // Monster is damanged but not defeated, hurry up!
571             monster.health -= uint8(damageByHero);
572 
573             // Calculate the damage by monster only if it is not defeated.
574             // Determine if the monster has fled due to hero failed to attack within flee period.
575             if (now > monster.creationTime + monsterFleeTime) {
576                 // When a monster flees, the monster will attack the hero and flee.
577                 // The damage is calculated by monster level + monsterStrength.
578                 damageByMonster = currentLevel + monsterStrength;
579             } else {
580                 // When a monster attack back the hero, the damage will be less than monster level / 2.
581                 if (currentLevel >= 2) {
582                     damageByMonster = _getRandomNumber(currentLevel / 2);
583                 }
584             }
585         }
586 
587         // Check if hero is defeated.
588         if (damageByMonster >= _heroCurrentHealth) {
589             // Hero is defeated, the dungeon run ends.
590             heroIdToHealth[_heroId] = 0;
591 
592             // Add the non-refunded fee to jackpot.
593             uint addToJackpot = entranceFee - heroIdToRefundedFee[_heroId];
594             
595             if (addToJackpot > 0) {
596                 jackpot += addToJackpot;
597                 entranceFeePool -= addToJackpot;
598                 heroIdToRefundedFee[_heroId] += addToJackpot;
599             }
600 
601             // Sanity check.
602             assert(addToJackpot <= entranceFee);
603         } else {
604             // Hero is damanged but didn't defeated, game continues with a new monster.
605             if (damageByMonster > 0) {
606                 heroIdToHealth[_heroId] -= damageByMonster;
607             }
608 
609             // If monser fled, create next level monster.
610             if (now > monster.creationTime + monsterFleeTime) {
611                 currentLevel++;
612                 heroIdToMonster[_heroId] = Monster(uint64(monster.creationTime + monsterFleeTime),
613                     currentLevel, currentLevel * monsterHealth, currentLevel * monsterHealth);
614                 monster = heroIdToMonster[_heroId];
615             }
616         }
617 
618         // Emit LogAttack event.
619         LogAttack(now, msg.sender, _heroId, currentLevel, damageByHero, damageByMonster, isMonsterDefeated, rewards);
620     }
621 
622     /// @dev Return a pseudo random uint smaller than _upper bounds.
623     function _getRandomNumber(uint _upper) private returns (uint) {
624         _seed = uint(keccak256(
625             _seed,
626             block.blockhash(block.number - 1),
627             block.coinbase,
628             block.difficulty
629         ));
630 
631         return _seed % _upper;
632     }
633 
634 
635     /*==============================
636     =           MODIFIERS          =
637     ==============================*/
638     
639     /// @dev Throws if the caller address is a contract.
640     modifier onlyHumanAddress() {
641         address addr = msg.sender;
642         uint size;
643         assembly { size := extcodesize(addr) }
644         require(size == 0);
645         _;
646     }
647 
648 }