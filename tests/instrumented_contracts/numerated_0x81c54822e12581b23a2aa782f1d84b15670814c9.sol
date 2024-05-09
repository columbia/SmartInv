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
212 contract DungeonRunAlpha is Pausable, Destructible {
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
265     uint public entranceFee = 0.02 ether; // TODO: change to 0.04 ether
266 
267     /// @dev 0.1 ether is provided as the initial jackpot.
268     uint public jackpot = 0.1 ether;
269 
270     /**
271      * @dev The dungeon run entrance fee will first be deposited to a pool first, when the hero is defeated
272      *  by a monster, then the fee will be added to the jackpot.
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
299     event LogAttack(uint timestamp, address indexed player, uint indexed heroId, uint indexed monsterLevel, uint damage, bool isMonsterDefeated, uint rewards);
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
421         bool dungeonRunEnded;
422 
423         // To start a run, the player need to pay an entrance fee.
424         if (currentLevel == 0) {
425             // Throws if not enough fee, and any exceeding fee will be transferred back to the player.
426             require(msg.value >= entranceFee);
427             entranceFeePool += entranceFee;
428             
429             // Create level 1 monster, initial health is 1 * monsterHealth.
430             heroIdToMonster[_heroId] = Monster(uint64(now), 1, monsterHealth, monsterHealth);
431             monster = heroIdToMonster[_heroId];
432 
433             // Set the hero initial health to storage.
434             heroIdToHealth[_heroId] = heroInitialHealth;
435             heroCurrentHealth = heroInitialHealth;
436 
437             // Refund exceeding fee.
438             if (msg.value > entranceFee) {
439                 msg.sender.transfer(msg.value - entranceFee);
440             }
441         } else {
442             // If the hero health is 0, the dungeon run ends.
443             require(heroCurrentHealth > 0);
444     
445             // If a hero failed to damage a monster before it flee, the dungeon run ends,
446             // regardless of the remaining hero health.
447             dungeonRunEnded = now > monster.creationTime + monsterFleeTime * 2 ||
448                 (monster.health == monster.initialHealth && now > monster.creationTime + monsterFleeTime);
449 
450             if (dungeonRunEnded) {
451                 // Add the non-refunded fee to jackpot.
452                 uint addToJackpot = entranceFee - heroIdToRefundedFee[_heroId];
453                 jackpot += addToJackpot;
454                 entranceFeePool -= addToJackpot;
455 
456                 // Sanity check.
457                 assert(addToJackpot <= entranceFee);
458             }
459             
460             // Future attack do not require any fee, so refund all ether sent with the transaction.
461             msg.sender.transfer(msg.value);
462         }
463 
464         if (!dungeonRunEnded) {
465             // All pre-conditions passed, call the internal attack function.
466             _attack(_heroId, genes, heroStrength, heroCurrentHealth);
467         }
468     }
469 
470 
471     /*=======================================
472     =           SETTER FUNCTIONS            =
473     =======================================*/
474 
475     function setEdCoreContract(address _newEdCoreContract) onlyOwner external {
476         edCoreContract = EDCoreInterface(_newEdCoreContract);
477     }
478 
479     function setEntranceFee(uint _newEntranceFee) onlyOwner external {
480         entranceFee = _newEntranceFee;
481     }
482 
483 
484     /*=======================================
485     =      INTERNAL/PRIVATE FUNCTIONS       =
486     =======================================*/
487 
488     /// @dev Internal function of attack, assume all parameter checking is done.
489     function _attack(uint _heroId, uint _genes, uint _heroStrength, uint _heroCurrentHealth) internal {
490         Monster storage monster = heroIdToMonster[_heroId];
491         uint8 currentLevel = monster.level;
492 
493         // Get the hero power.
494         uint heroPower;
495         (heroPower,,,,) = edCoreContract.getHeroPower(_genes, dungeonDifficulty);
496 
497         // Determine if the monster has fled due to hero failed to attack within flee period.
498         if (now > monster.creationTime + monsterFleeTime) {
499             // When a monster flees, the monster will attack the hero and flee.
500             // The damage is calculated by monster level + monsterStrength.
501             uint damageByMonster = currentLevel + monsterStrength;
502 
503             // Check if hero is defeated.
504             if (damageByMonster >= _heroCurrentHealth) {
505                 // Hero is defeated, the dungeon run ends.
506                 heroIdToHealth[_heroId] = 0;
507 
508                 // Added the non-refunded fee to jackpot.
509                 uint addToJackpot = entranceFee - heroIdToRefundedFee[_heroId];
510                 jackpot += addToJackpot;
511                 entranceFeePool -= addToJackpot;
512 
513                 // Sanity check.
514                 assert(addToJackpot <= entranceFee);
515             } else {
516                 // Hero is damanged but didn't defeated, game continues with a new monster.
517                 heroIdToHealth[_heroId] -= damageByMonster;
518 
519                 // Create next level monster, the health of a monster is level * monsterHealth.
520                 currentLevel++;
521                 heroIdToMonster[_heroId] = Monster(uint64(monster.creationTime + monsterFleeTime),
522                     currentLevel, currentLevel * monsterHealth, currentLevel * monsterHealth);
523                 monster = heroIdToMonster[_heroId];
524             }
525         }
526 
527         // The damage formula is [[strength / gas + power / (10 * rand)]],
528         // where rand is a random integer from 1 to 5.
529         uint damage = _heroStrength * 1e9 / tx.gasprice + heroPower / (10 * (1 + _getRandomNumber(5)));
530         bool isMonsterDefeated = damage >= monster.health;
531         uint rewards;
532 
533         if (isMonsterDefeated) {
534             // Monster is defeated, game continues with a new monster.
535             // Create next level monster, the health of a monster is level * monsterHealth.
536             uint8 newLevel = currentLevel + 1;
537             heroIdToMonster[_heroId] = Monster(uint64(now), newLevel, newLevel * monsterHealth, newLevel * monsterHealth);
538             monster = heroIdToMonster[_heroId];
539 
540             // Determine the rewards based on current level.
541             if (currentLevel == checkpointLevel) {
542                 // By defeating the checkPointLevel, half of the entranceFee is refunded.
543                 rewards = entranceFee / 2;
544                 heroIdToRefundedFee[_heroId] += rewards;
545                 entranceFeePool -= rewards;
546             } else if (currentLevel == breakevenLevel) {
547                 // By defeating the breakevenLevel, another half of the entranceFee is refunded.
548                 rewards = entranceFee / 2;
549                 heroIdToRefundedFee[_heroId] += rewards;
550                 entranceFeePool -= rewards;
551             } else if (currentLevel == jackpotLevel) {
552                 // By defeating the jackpotLevel, the player win the entire jackpot.
553                 rewards = jackpot;
554                 jackpot = 0;
555             }
556 
557             msg.sender.transfer(rewards);
558         } else {
559             // Monster is damanged but not defeated, hurry up!
560             monster.health -= uint8(damage);
561         }
562 
563         // Emit LogAttack event.
564         LogAttack(now, msg.sender, _heroId, currentLevel, damage, isMonsterDefeated, rewards);
565     }
566 
567     /// @dev Return a pseudo random uint smaller than _upper bounds.
568     function _getRandomNumber(uint _upper) private returns (uint) {
569         _seed = uint(keccak256(
570             _seed,
571             block.blockhash(block.number - 1),
572             block.coinbase,
573             block.difficulty
574         ));
575 
576         return _seed % _upper;
577     }
578 
579 
580     /*==============================
581     =           MODIFIERS          =
582     ==============================*/
583 
584     /// @dev Throws if the caller address is a contract.
585     modifier onlyHumanAddress() {
586         address addr = msg.sender;
587         uint size;
588         assembly { size := extcodesize(addr) }
589         require(size == 0);
590         _;
591     }
592 
593 }