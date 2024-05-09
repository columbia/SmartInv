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
212 contract DungeonRunBeta is Pausable, Destructible {
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
239     uint8 public constant checkpointLevel = 4;
240 
241     /// @dev By defeating the breakevenLevel, another half of the entranceFee is refunded.
242     uint8 public constant breakevenLevel = 8;
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
267     /// @dev 0.1 ether is provided as the initial jackpot.
268     uint public jackpot = 0.16 ether;
269 
270     /**
271      * @dev The dungeon run entrance fee will first be deposited to a pool first, when the hero is
272      *  defeated by a monster, then the fee will be added to the jackpot.
273      */
274     uint public entranceFeePool;
275 
276     /// @dev Private seed for the PRNG used for calculating damage amount.
277     uint _seed;
278 
279 
280     /*=================================
281     =         STATE VARIABLES         =
282     =================================*/
283 
284     /// @dev A mapping from hero ID to the current run monster, a 0 value indicates no current run.
285     mapping(uint => Monster) public heroIdToMonster;
286 
287     /// @dev A mapping from hero ID to its current health.
288     mapping(uint => uint) public heroIdToHealth;
289 
290     /// @dev A mapping from hero ID to the refunded fee.
291     mapping(uint => uint) public heroIdToRefundedFee;
292 
293 
294     /*==============================
295     =            EVENTS            =
296     ==============================*/
297 
298     /// @dev The LogAttack event is fired whenever a hero attack a monster.
299     event LogAttack(uint timestamp, address indexed player, uint indexed heroId, uint indexed monsterLevel, uint damageByHero, uint damageByMonster, bool isMonsterDefeated, uint rewards);
300 
301     function DungeonRunAlpha() public payable {}
302 
303     /*=======================================
304     =       PUBLIC/EXTERNAL FUNCTIONS       =
305     =======================================*/
306 
307     /// @dev The external function to get all the game settings in one call.
308     function getGameSettings() external view returns (
309         uint _checkpointLevel,
310         uint _breakevenLevel,
311         uint _jackpotLevel,
312         uint _dungeonDifficulty,
313         uint _monsterHealth,
314         uint _monsterStrength,
315         uint _monsterFleeTime,
316         uint _entranceFee
317     ) {
318         _checkpointLevel = checkpointLevel;
319         _breakevenLevel = breakevenLevel;
320         _jackpotLevel = jackpotLevel;
321         _dungeonDifficulty = dungeonDifficulty;
322         _monsterHealth = monsterHealth;
323         _monsterStrength = monsterStrength;
324         _monsterFleeTime = monsterFleeTime;
325         _entranceFee = entranceFee;
326     }
327 
328     /// @dev The external function to get the dungeon run details in one call.
329     function getRunDetails(uint _heroId) external view returns (
330         uint _heroPower,
331         uint _heroStrength,
332         uint _heroInitialHealth,
333         uint _heroHealth,
334         uint _monsterCreationTime,
335         uint _monsterLevel,
336         uint _monsterInitialHealth,
337         uint _monsterHealth,
338         uint _gameState // 0: NotStarted | 1: NewMonster | 2: Active | 3: RunEnded
339     ) {
340         uint genes;
341         address owner;
342         (,,, genes, owner,,) = edCoreContract.getHeroDetails(_heroId);
343         (_heroPower,,,,) = edCoreContract.getHeroPower(genes, dungeonDifficulty);
344         _heroStrength = (genes / (32 ** 8)) % 32 + 1;
345         _heroInitialHealth = (genes / (32 ** 12)) % 32 + 1;
346         _heroHealth = heroIdToHealth[_heroId];
347 
348         Monster memory monster = heroIdToMonster[_heroId];
349         _monsterCreationTime = monster.creationTime;
350 
351         // Dungeon run is ended if either hero is defeated (health exhausted),
352         // or hero failed to damage a monster before it flee.
353         bool _dungeonRunEnded = monster.level > 0 && (
354             _heroHealth == 0 || 
355             now > _monsterCreationTime + monsterFleeTime * 2 ||
356             (monster.health == monster.initialHealth && now > monster.creationTime + monsterFleeTime)
357         );
358 
359         // Calculate hero and monster stats based on different game state.
360         if (monster.level == 0) {
361             // Dungeon run not started yet.
362             _heroHealth = _heroInitialHealth;
363             _monsterLevel = 1;
364             _monsterInitialHealth = monsterHealth;
365             _monsterHealth = _monsterInitialHealth;
366             _gameState = 0;
367         } else if (_dungeonRunEnded) {
368             // Dungeon run ended.
369             _monsterLevel = monster.level;
370             _monsterInitialHealth = monster.initialHealth;
371             _monsterHealth = monster.health;
372             _gameState = 3;
373         } else if (now > _monsterCreationTime + monsterFleeTime) {
374             // Previous monster just fled, new monster awaiting.
375             if (monster.level + monsterStrength > _heroHealth) {
376                 _heroHealth = 0;
377                 _monsterLevel = monster.level;
378                 _monsterInitialHealth = monster.initialHealth;
379                 _monsterHealth = monster.health;
380                 _gameState = 2;
381             } else {
382                 _heroHealth -= monster.level + monsterStrength;
383                 _monsterCreationTime += monsterFleeTime;
384                 _monsterLevel = monster.level + 1;
385                 _monsterInitialHealth = _monsterLevel * monsterHealth;
386                 _monsterHealth = _monsterInitialHealth;
387                 _gameState = 1;
388             }
389         } else {
390             // Active monster.
391             _monsterLevel = monster.level;
392             _monsterInitialHealth = monster.initialHealth;
393             _monsterHealth = monster.health;
394             _gameState = 2;
395         }
396     }
397 
398     /**
399      * @dev To start a dungeon run, player need to call the attack function with an entranceFee.
400      *  Future attcks required no fee, player just need to send a free transaction
401      *  to the contract, before the monster flee. The lower the gas price, the larger the damage.
402      *  This function is prevented from being called by a contract, using the onlyHumanAddress modifier.
403      *  Note that each hero can only perform one dungeon run.
404      */
405     function attack(uint _heroId) whenNotPaused onlyHumanAddress external payable {
406         uint genes;
407         address owner;
408         (,,, genes, owner,,) = edCoreContract.getHeroDetails(_heroId);
409 
410         // Throws if the hero is not owned by the player.
411         require(msg.sender == owner);
412 
413         // Get the health and strength of the hero.
414         uint heroInitialHealth = (genes / (32 ** 12)) % 32 + 1;
415         uint heroStrength = (genes / (32 ** 8)) % 32 + 1;
416 
417         // Get the current monster and hero current health.
418         Monster memory monster = heroIdToMonster[_heroId];
419         uint currentLevel = monster.level;
420         uint heroCurrentHealth = heroIdToHealth[_heroId];
421 
422         // A flag determine whether the dungeon run has ended.
423         bool dungeonRunEnded;
424 
425         // To start a run, the player need to pay an entrance fee.
426         if (currentLevel == 0) {
427             // Throws if not enough fee, and any exceeding fee will be transferred back to the player.
428             require(msg.value >= entranceFee);
429             entranceFeePool += entranceFee;
430             
431             // Create level 1 monster, initial health is 1 * monsterHealth.
432             heroIdToMonster[_heroId] = Monster(uint64(now), 1, monsterHealth, monsterHealth);
433             monster = heroIdToMonster[_heroId];
434 
435             // Set the hero initial health to storage.
436             heroIdToHealth[_heroId] = heroInitialHealth;
437             heroCurrentHealth = heroInitialHealth;
438 
439             // Refund exceeding fee.
440             if (msg.value > entranceFee) {
441                 msg.sender.transfer(msg.value - entranceFee);
442             }
443         } else {
444             // If the hero health is 0, the dungeon run has ended.
445             require(heroCurrentHealth > 0);
446     
447             // If a hero failed to damage a monster before it flee, the dungeon run ends,
448             // regardless of the remaining hero health.
449             dungeonRunEnded = now > monster.creationTime + monsterFleeTime * 2 ||
450                 (monster.health == monster.initialHealth && now > monster.creationTime + monsterFleeTime);
451 
452             if (dungeonRunEnded) {
453                 // Add the non-refunded fee to jackpot.
454                 uint addToJackpot = entranceFee - heroIdToRefundedFee[_heroId];
455             
456                 if (addToJackpot > 0) {
457                     jackpot += addToJackpot;
458                     entranceFeePool -= addToJackpot;
459                     heroIdToRefundedFee[_heroId] += addToJackpot;
460                 }
461 
462                 // Sanity check.
463                 assert(addToJackpot <= entranceFee);
464             }
465             
466             // Future attack do not require any fee, so refund all ether sent with the transaction.
467             msg.sender.transfer(msg.value);
468         }
469 
470         if (!dungeonRunEnded) {
471             // All pre-conditions passed, call the internal attack function.
472             _attack(_heroId, genes, heroStrength, heroCurrentHealth);
473         }
474     }
475 
476 
477     /*=======================================
478     =           SETTER FUNCTIONS            =
479     =======================================*/
480 
481     function setEdCoreContract(address _newEdCoreContract) onlyOwner external {
482         edCoreContract = EDCoreInterface(_newEdCoreContract);
483     }
484 
485     function setEntranceFee(uint _newEntranceFee) onlyOwner external {
486         entranceFee = _newEntranceFee;
487     }
488 
489 
490     /*=======================================
491     =      INTERNAL/PRIVATE FUNCTIONS       =
492     =======================================*/
493 
494     /// @dev Internal function of attack, assume all parameter checking is done.
495     function _attack(uint _heroId, uint _genes, uint _heroStrength, uint _heroCurrentHealth) internal {
496         Monster storage monster = heroIdToMonster[_heroId];
497         uint8 currentLevel = monster.level;
498 
499         // Get the hero power.
500         uint heroPower;
501         (heroPower,,,,) = edCoreContract.getHeroPower(_genes, dungeonDifficulty);
502         
503         uint damageByMonster;
504         uint damageByHero;
505 
506         // Calculate the damage by monster.
507         // Determine if the monster has fled due to hero failed to attack within flee period.
508         if (now > monster.creationTime + monsterFleeTime) {
509             // When a monster flees, the monster will attack the hero and flee.
510             // The damage is calculated by monster level + monsterStrength.
511             damageByMonster = currentLevel + monsterStrength;
512         } else {
513             // When a monster attack back the hero, the damage will be less than monster level / 2.
514             if (currentLevel >= 2) {
515                 damageByMonster = _getRandomNumber(currentLevel / 2);
516             }
517         }
518 
519         // Check if hero is defeated.
520         if (damageByMonster >= _heroCurrentHealth) {
521             // Hero is defeated, the dungeon run ends.
522             heroIdToHealth[_heroId] = 0;
523 
524             // Add the non-refunded fee to jackpot.
525             uint addToJackpot = entranceFee - heroIdToRefundedFee[_heroId];
526             
527             if (addToJackpot > 0) {
528                 jackpot += addToJackpot;
529                 entranceFeePool -= addToJackpot;
530                 heroIdToRefundedFee[_heroId] += addToJackpot;
531             }
532 
533             // Sanity check.
534             assert(addToJackpot <= entranceFee);
535         } else {
536             // Hero is damanged but didn't defeated, game continues with a new monster.
537             heroIdToHealth[_heroId] -= damageByMonster;
538 
539             // If monser fled, create next level monster.
540             if (now > monster.creationTime + monsterFleeTime) {
541                 currentLevel++;
542                 heroIdToMonster[_heroId] = Monster(uint64(monster.creationTime + monsterFleeTime),
543                     currentLevel, currentLevel * monsterHealth, currentLevel * monsterHealth);
544                 monster = heroIdToMonster[_heroId];
545             }
546 
547             // Calculate the damage by hero.
548             // The damage formula is (strength + power / (10 * rand)) / gasprice,
549             // where rand is a random integer from 1 to 5.
550             damageByHero = (_heroStrength * 1e9 + heroPower * 1e9 / (10 * (1 + _getRandomNumber(5)))) / tx.gasprice;
551             bool isMonsterDefeated = damageByHero >= monster.health;
552     
553             if (isMonsterDefeated) {
554                 uint rewards;
555 
556                 // Monster is defeated, game continues with a new monster.
557                 // Create next level monster.
558                 uint8 newLevel = currentLevel + 1;
559                 heroIdToMonster[_heroId] = Monster(uint64(now), newLevel, newLevel * monsterHealth, newLevel * monsterHealth);
560                 monster = heroIdToMonster[_heroId];
561     
562                 // Determine the rewards based on current level.
563                 if (currentLevel == checkpointLevel) {
564                     // By defeating the checkPointLevel boss, half of the entranceFee is refunded.
565                     rewards = entranceFee / 2;
566                     heroIdToRefundedFee[_heroId] += rewards;
567                     entranceFeePool -= rewards;
568                 } else if (currentLevel == breakevenLevel) {
569                     // By defeating the breakevenLevel boss, another half of the entranceFee is refunded.
570                     rewards = entranceFee / 2;
571                     heroIdToRefundedFee[_heroId] += rewards;
572                     entranceFeePool -= rewards;
573                 } else if (currentLevel == jackpotLevel) {
574                     // By defeating the jackpotLevel, the player win the entire jackpot.
575                     rewards = jackpot / 2;
576                     jackpot -= rewards;
577                 }
578     
579                 msg.sender.transfer(rewards);
580             } else {
581                 // Monster is damanged but not defeated, hurry up!
582                 monster.health -= uint8(damageByHero);
583             }
584         }
585 
586         // Emit LogAttack event.
587         LogAttack(now, msg.sender, _heroId, currentLevel, damageByHero, damageByMonster, isMonsterDefeated, rewards);
588     }
589 
590     /// @dev Return a pseudo random uint smaller than _upper bounds.
591     function _getRandomNumber(uint _upper) private returns (uint) {
592         _seed = uint(keccak256(
593             _seed,
594             block.blockhash(block.number - 1),
595             block.coinbase,
596             block.difficulty
597         ));
598 
599         return _seed % _upper;
600     }
601 
602 
603     /*==============================
604     =           MODIFIERS          =
605     ==============================*/
606     
607     /// @dev Throws if the caller address is a contract.
608     modifier onlyHumanAddress() {
609         address addr = msg.sender;
610         uint size;
611         assembly { size := extcodesize(addr) }
612         require(size == 0);
613         _;
614     }
615 
616 }