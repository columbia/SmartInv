1 /**
2   * Dragonking is a blockchain game in which players may purchase dragons and knights of different levels and values.
3   * Once every period of time the volcano erupts and wipes a few of them from the board. The value of the killed characters
4   * gets distributed amongst all of the survivors. The dragon king receive a bigger share than the others.
5   * In contrast to dragons, knights need to be teleported to the battlefield first with the use of teleport tokens.
6   * Additionally, they may attack a dragon once per period.
7   * Both character types can be protected from death up to three times.
8   * Take a look at dragonking.io for more detailed information.
9   * @author: Julia Altenried, Yuriy Kashnikov
10   * */
11 
12 pragma solidity ^0.4.24;
13 
14 contract ERC20Basic {
15   function totalSupply() public view returns (uint256);
16   function balanceOf(address _who) public view returns (uint256);
17   function transfer(address _to, uint256 _value) public returns (bool);
18   event Transfer(address indexed from, address indexed to, uint256 value);
19 }
20 
21 contract ERC20 is ERC20Basic {
22   function allowance(address _owner, address _spender)
23     public view returns (uint256);
24 
25   function transferFrom(address _from, address _to, uint256 _value)
26     public returns (bool);
27 
28   function approve(address _spender, uint256 _value) public returns (bool);
29   event Approval(
30     address indexed owner,
31     address indexed spender,
32     uint256 value
33   );
34 }
35 
36 
37 
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44   address public owner;
45 
46   event OwnershipTransferred(
47     address indexed previousOwner,
48     address indexed newOwner
49   );
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   constructor() public {
57     owner = msg.sender;
58   }
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param _newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address _newOwner) public onlyOwner {
73     _transferOwnership(_newOwner);
74   }
75 
76   /**
77    * @dev Transfers control of the contract to a newOwner.
78    * @param _newOwner The address to transfer ownership to.
79    */
80   function _transferOwnership(address _newOwner) internal {
81     require(_newOwner != address(0));
82     emit OwnershipTransferred(owner, _newOwner);
83     owner = _newOwner;
84   }
85 }
86 
87 /**
88  * @title Destructible
89  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
90  */
91 contract Destructible is Ownable {
92   /**
93    * @dev Transfers the current balance to the owner and terminates the contract.
94    */
95   function destroy() public onlyOwner {
96     selfdestruct(owner);
97   }
98 
99   function destroyAndSend(address _recipient) public onlyOwner {
100     selfdestruct(_recipient);
101   }
102 }
103 
104 /**
105  * DragonKing game configuration contract
106 **/
107 
108 contract DragonKingConfig is Ownable {
109 
110   struct PurchaseRequirement {
111     address[] tokens;
112     uint256[] amounts;
113   }
114 
115   /** the Gift token contract **/
116   ERC20 public giftToken;
117   /** amount of gift tokens to send **/
118   uint256 public giftTokenAmount;
119   /** purchase requirements for each type of character **/
120   PurchaseRequirement[30] purchaseRequirements; 
121   /** the cost of each character type */
122   uint128[] public costs;
123   /** the value of each character type (cost - fee), so it's not necessary to compute it each time*/
124   uint128[] public values;
125   /** the fee to be paid each time an character is bought in percent*/
126   uint8 fee;
127   /** The maximum of characters allowed in the game */
128   uint16 public maxCharacters;
129   /** the amount of time that should pass since last eruption **/
130   uint256 public eruptionThreshold;
131   /** the amount of time that should pass ince last castle loot distribution **/
132   uint256 public castleLootDistributionThreshold;
133   /** how many characters to kill in %, e.g. 20 will stand for 20%, should be < 100 **/
134   uint8 public percentageToKill;
135   /* Cooldown threshold */
136   uint256 public constant CooldownThreshold = 1 days;
137   /** fight factor, used to compute extra probability in fight **/
138   uint8 public fightFactor;
139 
140   /** the price for teleportation*/
141   uint256 public teleportPrice;
142   /** the price for protection */
143   uint256 public protectionPrice;
144   /** the luck threshold */
145   uint256 public luckThreshold;
146 
147   function hasEnoughTokensToPurchase(address buyer, uint8 characterType) external returns (bool canBuy) {
148     for (uint256 i = 0; i < purchaseRequirements[characterType].tokens.length; i++) {
149       if (ERC20(purchaseRequirements[characterType].tokens[i]).balanceOf(buyer) < purchaseRequirements[characterType].amounts[i]) {
150         return false;
151       }
152     }
153     return true;
154   }
155 
156 
157   function getPurchaseRequirements(uint8 characterType) view external returns (address[] tokens, uint256[] amounts) {
158     tokens = purchaseRequirements[characterType].tokens;
159     amounts = purchaseRequirements[characterType].amounts;
160   }
161 
162 
163 }
164 
165 
166 contract DragonKing is Destructible {
167 
168   /**
169    * @dev Throws if called by contract not a user 
170    */
171   modifier onlyUser() {
172     require(msg.sender == tx.origin, 
173             "contracts cannot execute this method"
174            );
175     _;
176   }
177 
178 
179   struct Character {
180     uint8 characterType;
181     uint128 value;
182     address owner;
183     uint64 purchaseTimestamp;
184     uint8 fightCount;
185   }
186 
187   DragonKingConfig public config;
188 
189   /** the neverdie token contract used to purchase protection from eruptions and fights */
190   ERC20 neverdieToken;
191   /** the teleport token contract used to send knights to the game scene */
192   ERC20 teleportToken;
193   /** the luck token contract **/
194   ERC20 luckToken;
195   /** the SKL token contract **/
196   ERC20 sklToken;
197   /** the XP token contract **/
198   ERC20 xperToken;
199   
200 
201   /** array holding ids of the curret characters **/
202   uint32[] public ids;
203   /** the id to be given to the next character **/
204   uint32 public nextId;
205   /** non-existant character **/
206   uint16 public constant INVALID_CHARACTER_INDEX = ~uint16(0);
207 
208   /** the castle treasury **/
209   uint128 public castleTreasury;
210   /** the castle loot distribution factor **/
211   uint8 public luckRounds = 2;
212   /** the id of the oldest character **/
213   uint32 public oldest;
214   /** the character belonging to a given id **/
215   mapping(uint32 => Character) characters;
216   /** teleported knights **/
217   mapping(uint32 => bool) teleported;
218 
219   /** constant used to signal that there is no King at the moment **/
220   uint32 constant public noKing = ~uint32(0);
221 
222   /** total number of characters in the game **/
223   uint16 public numCharacters;
224   /** number of characters per type **/
225   mapping(uint8 => uint16) public numCharactersXType;
226 
227   /** timestamp of the last eruption event **/
228   uint256 public lastEruptionTimestamp;
229   /** timestamp of the last castle loot distribution **/
230   mapping(uint32 => uint256) public lastCastleLootDistributionTimestamp;
231 
232   /** character type range constants **/
233   uint8 public constant DRAGON_MIN_TYPE = 0;
234   uint8 public constant DRAGON_MAX_TYPE = 5;
235 
236   uint8 public constant KNIGHT_MIN_TYPE = 6;
237   uint8 public constant KNIGHT_MAX_TYPE = 11;
238 
239   uint8 public constant BALLOON_MIN_TYPE = 12;
240   uint8 public constant BALLOON_MAX_TYPE = 14;
241 
242   uint8 public constant WIZARD_MIN_TYPE = 15;
243   uint8 public constant WIZARD_MAX_TYPE = 20;
244 
245   uint8 public constant ARCHER_MIN_TYPE = 21;
246   uint8 public constant ARCHER_MAX_TYPE = 26;
247 
248   uint8 public constant NUMBER_OF_LEVELS = 6;
249 
250   uint8 public constant INVALID_CHARACTER_TYPE = 27;
251 
252     /** knight cooldown. contains the timestamp of the earliest possible moment to start a fight */
253   mapping(uint32 => uint) public cooldown;
254 
255     /** tells the number of times a character is protected */
256   mapping(uint32 => uint8) public protection;
257 
258   // EVENTS
259 
260   /** is fired when new characters are purchased (who bought how many characters of which type?) */
261   event NewPurchase(address player, uint8 characterType, uint16 amount, uint32 startId);
262   /** is fired when a player leaves the game */
263   event NewExit(address player, uint256 totalBalance, uint32[] removedCharacters);
264   /** is fired when an eruption occurs */
265   event NewEruption(uint32[] hitCharacters, uint128 value, uint128 gasCost);
266   /** is fired when a single character is sold **/
267   event NewSell(uint32 characterId, address player, uint256 value);
268   /** is fired when a knight fights a dragon **/
269   event NewFight(uint32 winnerID, uint32 loserID, uint256 value, uint16 probability, uint16 dice);
270   /** is fired when a knight is teleported to the field **/
271   event NewTeleport(uint32 characterId);
272   /** is fired when a protection is purchased **/
273   event NewProtection(uint32 characterId, uint8 lifes);
274   /** is fired when a castle loot distribution occurs**/
275   event NewDistributionCastleLoot(uint128 castleLoot, uint32 characterId, uint128 luckFactor);
276 
277   /* initializes the contract parameter */
278   constructor(address tptAddress, address ndcAddress, address sklAddress, address xperAddress, address luckAddress, address _configAddress) public {
279     nextId = 1;
280     teleportToken = ERC20(tptAddress);
281     neverdieToken = ERC20(ndcAddress);
282     sklToken = ERC20(sklAddress);
283     xperToken = ERC20(xperAddress);
284     luckToken = ERC20(luckAddress);
285     config = DragonKingConfig(_configAddress);
286   }
287 
288   /** 
289     * gifts one character
290     * @param receiver gift character owner
291     * @param characterType type of the character to create as a gift
292     */
293   function giftCharacter(address receiver, uint8 characterType) payable public onlyUser {
294     _addCharacters(receiver, characterType);
295     assert(config.giftToken().transfer(receiver, config.giftTokenAmount()));
296   }
297 
298   /**
299    * buys as many characters as possible with the transfered value of the given type
300    * @param characterType the type of the character
301    */
302   function addCharacters(uint8 characterType) payable public onlyUser {
303     _addCharacters(msg.sender, characterType);
304   }
305 
306   function _addCharacters(address receiver, uint8 characterType) internal {
307     uint16 amount = uint16(msg.value / config.costs(characterType));
308     require(
309       amount > 0,
310       "insufficient amount of ether to purchase a given type of character");
311     uint16 nchars = numCharacters;
312     require(
313       config.hasEnoughTokensToPurchase(receiver, characterType),
314       "insufficinet amount of tokens to purchase a given type of character"
315     );
316     if (characterType >= INVALID_CHARACTER_TYPE || msg.value < config.costs(characterType) || nchars + amount > config.maxCharacters()) revert();
317     uint32 nid = nextId;
318     //if type exists, enough ether was transferred and there are less than maxCharacters characters in the game
319     if (characterType <= DRAGON_MAX_TYPE) {
320       //dragons enter the game directly
321       if (oldest == 0 || oldest == noKing)
322         oldest = nid;
323       for (uint8 i = 0; i < amount; i++) {
324         addCharacter(nid + i, nchars + i);
325         characters[nid + i] = Character(characterType, config.values(characterType), receiver, uint64(now), 0);
326       }
327       numCharactersXType[characterType] += amount;
328       numCharacters += amount;
329     }
330     else {
331       // to enter game knights, mages, and archers should be teleported later
332       for (uint8 j = 0; j < amount; j++) {
333         characters[nid + j] = Character(characterType, config.values(characterType), receiver, uint64(now), 0);
334       }
335     }
336     nextId = nid + amount;
337     emit NewPurchase(receiver, characterType, amount, nid);
338   }
339 
340 
341 
342   /**
343    * adds a single dragon of the given type to the ids array, which is used to iterate over all characters
344    * @param nId the id the character is about to receive
345    * @param nchars the number of characters currently in the game
346    */
347   function addCharacter(uint32 nId, uint16 nchars) internal {
348     if (nchars < ids.length)
349       ids[nchars] = nId;
350     else
351       ids.push(nId);
352   }
353 
354   /**
355    * leave the game.
356    * pays out the sender's balance and removes him and his characters from the game
357    * */
358   function exit() public {
359     uint32[] memory removed = new uint32[](50);
360     uint8 count;
361     uint32 lastId;
362     uint playerBalance;
363     uint16 nchars = numCharacters;
364     for (uint16 i = 0; i < nchars; i++) {
365       if (characters[ids[i]].owner == msg.sender 
366           && characters[ids[i]].purchaseTimestamp + 1 days < now
367           && (characters[ids[i]].characterType < BALLOON_MIN_TYPE || characters[ids[i]].characterType > BALLOON_MAX_TYPE)) {
368         //first delete all characters at the end of the array
369         while (nchars > 0 
370             && characters[ids[nchars - 1]].owner == msg.sender 
371             && characters[ids[nchars - 1]].purchaseTimestamp + 1 days < now
372             && (characters[ids[i]].characterType < BALLOON_MIN_TYPE || characters[ids[i]].characterType > BALLOON_MAX_TYPE)) {
373           nchars--;
374           lastId = ids[nchars];
375           numCharactersXType[characters[lastId].characterType]--;
376           playerBalance += characters[lastId].value;
377           removed[count] = lastId;
378           count++;
379           if (lastId == oldest) oldest = 0;
380           delete characters[lastId];
381         }
382         //replace the players character by the last one
383         if (nchars > i + 1) {
384           playerBalance += characters[ids[i]].value;
385           removed[count] = ids[i];
386           count++;
387           nchars--;
388           replaceCharacter(i, nchars);
389         }
390       }
391     }
392     numCharacters = nchars;
393     emit NewExit(msg.sender, playerBalance, removed); //fire the event to notify the client
394     msg.sender.transfer(playerBalance);
395     if (oldest == 0)
396       findOldest();
397   }
398 
399   /**
400    * Replaces the character with the given id with the last character in the array
401    * @param index the index of the character in the id array
402    * @param nchars the number of characters
403    * */
404   function replaceCharacter(uint16 index, uint16 nchars) internal {
405     uint32 characterId = ids[index];
406     numCharactersXType[characters[characterId].characterType]--;
407     if (characterId == oldest) oldest = 0;
408     delete characters[characterId];
409     ids[index] = ids[nchars];
410     delete ids[nchars];
411   }
412 
413   /**
414    * The volcano eruption can be triggered by anybody but only if enough time has passed since the last eription.
415    * The volcano hits up to a certain percentage of characters, but at least one.
416    * The percantage is specified in 'percentageToKill'
417    * */
418 
419   function triggerVolcanoEruption() public onlyUser {
420     require(now >= lastEruptionTimestamp + config.eruptionThreshold(),
421            "not enough time passed since last eruption");
422     require(numCharacters > 0,
423            "there are no characters in the game");
424     lastEruptionTimestamp = now;
425     uint128 pot;
426     uint128 value;
427     uint16 random;
428     uint32 nextHitId;
429     uint16 nchars = numCharacters;
430     uint32 howmany = nchars * config.percentageToKill() / 100;
431     uint128 neededGas = 80000 + 10000 * uint32(nchars);
432     if(howmany == 0) howmany = 1;//hit at least 1
433     uint32[] memory hitCharacters = new uint32[](howmany);
434     bool[] memory alreadyHit = new bool[](nextId);
435     uint16 i = 0;
436     uint16 j = 0;
437     while (i < howmany) {
438       j++;
439       random = uint16(generateRandomNumber(lastEruptionTimestamp + j) % nchars);
440       nextHitId = ids[random];
441       if (!alreadyHit[nextHitId]) {
442         alreadyHit[nextHitId] = true;
443         hitCharacters[i] = nextHitId;
444         value = hitCharacter(random, nchars, 0);
445         if (value > 0) {
446           nchars--;
447         }
448         pot += value;
449         i++;
450       }
451     }
452     uint128 gasCost = uint128(neededGas * tx.gasprice);
453     numCharacters = nchars;
454     if (pot > gasCost){
455       distribute(pot - gasCost); //distribute the pot minus the oraclize gas costs
456       emit NewEruption(hitCharacters, pot - gasCost, gasCost);
457     }
458     else
459       emit NewEruption(hitCharacters, 0, gasCost);
460   }
461 
462   /**
463    * Knight can attack a dragon.
464    * Archer can attack only a balloon.
465    * Dragon can attack wizards and archers.
466    * Wizard can attack anyone, except balloon.
467    * Balloon cannot attack.
468    * The value of the loser is transfered to the winner.
469    * @param characterID the ID of the knight to perfrom the attack
470    * @param characterIndex the index of the knight in the ids-array. Just needed to save gas costs.
471    *            In case it's unknown or incorrect, the index is looked up in the array.
472    * */
473   function fight(uint32 characterID, uint16 characterIndex) public onlyUser {
474     if (characterIndex >= numCharacters || characterID != ids[characterIndex])
475       characterIndex = getCharacterIndex(characterID);
476     Character storage character = characters[characterID];
477     require(cooldown[characterID] + config.CooldownThreshold() <= now,
478             "not enough time passed since the last fight of this character");
479     require(character.owner == msg.sender,
480             "only owner can initiate a fight for this character");
481 
482     uint8 ctype = character.characterType;
483     require(ctype < BALLOON_MIN_TYPE || ctype > BALLOON_MAX_TYPE,
484             "balloons cannot fight");
485 
486     uint16 adversaryIndex = getRandomAdversary(characterID, ctype);
487     require(adversaryIndex != INVALID_CHARACTER_INDEX);
488     uint32 adversaryID = ids[adversaryIndex];
489 
490     Character storage adversary = characters[adversaryID];
491     uint128 value;
492     uint16 base_probability;
493     uint16 dice = uint16(generateRandomNumber(characterID) % 100);
494     if (luckToken.balanceOf(msg.sender) >= config.luckThreshold()) {
495       base_probability = uint16(generateRandomNumber(dice) % 100);
496       if (base_probability < dice) {
497         dice = base_probability;
498       }
499       base_probability = 0;
500     }
501     uint256 characterPower = sklToken.balanceOf(character.owner) / 10**15 + xperToken.balanceOf(character.owner);
502     uint256 adversaryPower = sklToken.balanceOf(adversary.owner) / 10**15 + xperToken.balanceOf(adversary.owner);
503     
504     if (character.value == adversary.value) {
505         base_probability = 50;
506       if (characterPower > adversaryPower) {
507         base_probability += uint16(100 / config.fightFactor());
508       } else if (adversaryPower > characterPower) {
509         base_probability -= uint16(100 / config.fightFactor());
510       }
511     } else if (character.value > adversary.value) {
512       base_probability = 100;
513       if (adversaryPower > characterPower) {
514         base_probability -= uint16((100 * adversary.value) / character.value / config.fightFactor());
515       }
516     } else if (characterPower > adversaryPower) {
517         base_probability += uint16((100 * character.value) / adversary.value / config.fightFactor());
518     }
519     
520     if (characters[characterID].fightCount < 3) {
521       characters[characterID].fightCount++;
522     }
523     
524     if (dice >= base_probability) {
525       // adversary won
526       if (adversary.characterType < BALLOON_MIN_TYPE || adversary.characterType > BALLOON_MAX_TYPE) {
527         value = hitCharacter(characterIndex, numCharacters, adversary.characterType);
528         if (value > 0) {
529           numCharacters--;
530         } else {
531           cooldown[characterID] = now;
532         }
533         if (adversary.characterType >= ARCHER_MIN_TYPE && adversary.characterType <= ARCHER_MAX_TYPE) {
534           castleTreasury += value;
535         } else {
536           adversary.value += value;
537         }
538         emit NewFight(adversaryID, characterID, value, base_probability, dice);
539       } else {
540         emit NewFight(adversaryID, characterID, 0, base_probability, dice); // balloons do not hit back
541       }
542     } else {
543       // character won
544       cooldown[characterID] = now;
545       value = hitCharacter(adversaryIndex, numCharacters, character.characterType);
546       if (value > 0) {
547         numCharacters--;
548       }
549       if (character.characterType >= ARCHER_MIN_TYPE && character.characterType <= ARCHER_MAX_TYPE) {
550         castleTreasury += value;
551       } else {
552         character.value += value;
553       }
554       if (oldest == 0) findOldest();
555       emit NewFight(characterID, adversaryID, value, base_probability, dice);
556     }
557   }
558 
559   
560   /*
561   * @param characterType
562   * @param adversaryType
563   * @return whether adversaryType is a valid type of adversary for a given character
564   */
565   function isValidAdversary(uint8 characterType, uint8 adversaryType) pure returns (bool) {
566     if (characterType >= KNIGHT_MIN_TYPE && characterType <= KNIGHT_MAX_TYPE) { // knight
567       return (adversaryType <= DRAGON_MAX_TYPE);
568     } else if (characterType >= WIZARD_MIN_TYPE && characterType <= WIZARD_MAX_TYPE) { // wizard
569       return (adversaryType < BALLOON_MIN_TYPE || adversaryType > BALLOON_MAX_TYPE);
570     } else if (characterType >= DRAGON_MIN_TYPE && characterType <= DRAGON_MAX_TYPE) { // dragon
571       return (adversaryType >= WIZARD_MIN_TYPE);
572     } else if (characterType >= ARCHER_MIN_TYPE && characterType <= ARCHER_MAX_TYPE) { // archer
573       return ((adversaryType >= BALLOON_MIN_TYPE && adversaryType <= BALLOON_MAX_TYPE)
574              || (adversaryType >= KNIGHT_MIN_TYPE && adversaryType <= KNIGHT_MAX_TYPE));
575  
576     }
577     return false;
578   }
579 
580   /**
581    * pick a random adversary.
582    * @param nonce a nonce to make sure there's not always the same adversary chosen in a single block.
583    * @return the index of a random adversary character
584    * */
585   function getRandomAdversary(uint256 nonce, uint8 characterType) internal view returns(uint16) {
586     uint16 randomIndex = uint16(generateRandomNumber(nonce) % numCharacters);
587     // use 7, 11 or 13 as step size. scales for up to 1000 characters
588     uint16 stepSize = numCharacters % 7 == 0 ? (numCharacters % 11 == 0 ? 13 : 11) : 7;
589     uint16 i = randomIndex;
590     //if the picked character is a knight or belongs to the sender, look at the character + stepSizes ahead in the array (modulo the total number)
591     //will at some point return to the startingPoint if no character is suited
592     do {
593       if (isValidAdversary(characterType, characters[ids[i]].characterType) && characters[ids[i]].owner != msg.sender) {
594         return i;
595       }
596       i = (i + stepSize) % numCharacters;
597     } while (i != randomIndex);
598 
599     return INVALID_CHARACTER_INDEX;
600   }
601 
602 
603   /**
604    * generate a random number.
605    * @param nonce a nonce to make sure there's not always the same number returned in a single block.
606    * @return the random number
607    * */
608   function generateRandomNumber(uint256 nonce) internal view returns(uint) {
609     return uint(keccak256(block.blockhash(block.number - 1), now, numCharacters, nonce));
610   }
611 
612 	/**
613    * Hits the character of the given type at the given index.
614    * Wizards can knock off two protections. Other characters can do only one.
615    * @param index the index of the character
616    * @param nchars the number of characters
617    * @return the value gained from hitting the characters (zero is the character was protected)
618    * */
619   function hitCharacter(uint16 index, uint16 nchars, uint8 characterType) internal returns(uint128 characterValue) {
620     uint32 id = ids[index];
621     uint8 knockOffProtections = 1;
622     if (characterType >= WIZARD_MIN_TYPE && characterType <= WIZARD_MAX_TYPE) {
623       knockOffProtections = 2;
624     }
625     if (protection[id] >= knockOffProtections) {
626       protection[id] = protection[id] - knockOffProtections;
627       return 0;
628     }
629     characterValue = characters[ids[index]].value;
630     nchars--;
631     replaceCharacter(index, nchars);
632   }
633 
634   /**
635    * finds the oldest character
636    * */
637   function findOldest() public {
638     uint32 newOldest = noKing;
639     for (uint16 i = 0; i < numCharacters; i++) {
640       if (ids[i] < newOldest && characters[ids[i]].characterType <= DRAGON_MAX_TYPE)
641         newOldest = ids[i];
642     }
643     oldest = newOldest;
644   }
645 
646   /**
647   * distributes the given amount among the surviving characters
648   * @param totalAmount nthe amount to distribute
649   */
650   function distribute(uint128 totalAmount) internal {
651     uint128 amount;
652     castleTreasury += totalAmount / 20; //5% into castle treasury
653     if (oldest == 0)
654       findOldest();
655     if (oldest != noKing) {
656       //pay 10% to the oldest dragon
657       characters[oldest].value += totalAmount / 10;
658       amount  = totalAmount / 100 * 85;
659     } else {
660       amount  = totalAmount / 100 * 95;
661     }
662     //distribute the rest according to their type
663     uint128 valueSum;
664     uint8 size = ARCHER_MAX_TYPE + 1;
665     uint128[] memory shares = new uint128[](size);
666     for (uint8 v = 0; v < size; v++) {
667       if ((v < BALLOON_MIN_TYPE || v > BALLOON_MAX_TYPE) && numCharactersXType[v] > 0) {
668            valueSum += config.values(v);
669       }
670     }
671     for (uint8 m = 0; m < size; m++) {
672       if ((v < BALLOON_MIN_TYPE || v > BALLOON_MAX_TYPE) && numCharactersXType[m] > 0) {
673         shares[m] = amount * config.values(m) / valueSum / numCharactersXType[m];
674       }
675     }
676     uint8 cType;
677     for (uint16 i = 0; i < numCharacters; i++) {
678       cType = characters[ids[i]].characterType;
679       if (cType < BALLOON_MIN_TYPE || cType > BALLOON_MAX_TYPE)
680         characters[ids[i]].value += shares[characters[ids[i]].characterType];
681     }
682   }
683 
684   /**
685    * allows the owner to collect the accumulated fees
686    * sends the given amount to the owner's address if the amount does not exceed the
687    * fees (cannot touch the players' balances) minus 100 finney (ensure that oraclize fees can be paid)
688    * @param amount the amount to be collected
689    * */
690   function collectFees(uint128 amount) public onlyOwner {
691     uint collectedFees = getFees();
692     if (amount + 100 finney < collectedFees) {
693       owner.transfer(amount);
694     }
695   }
696 
697   /**
698   * withdraw NDC and TPT tokens
699   */
700   function withdraw() public onlyOwner {
701     uint256 ndcBalance = neverdieToken.balanceOf(this);
702     if(ndcBalance > 0)
703       assert(neverdieToken.transfer(owner, ndcBalance));
704     uint256 tptBalance = teleportToken.balanceOf(this);
705     if(tptBalance > 0)
706       assert(teleportToken.transfer(owner, tptBalance));
707   }
708 
709   /**
710    * pays out the players.
711    * */
712   function payOut() public onlyOwner {
713     for (uint16 i = 0; i < numCharacters; i++) {
714       characters[ids[i]].owner.transfer(characters[ids[i]].value);
715       delete characters[ids[i]];
716     }
717     delete ids;
718     numCharacters = 0;
719   }
720 
721   /**
722    * pays out the players and kills the game.
723    * */
724   function stop() public onlyOwner {
725     withdraw();
726     payOut();
727     destroy();
728   }
729 
730   function generateLuckFactor(uint128 nonce) internal view returns(uint128 luckFactor) {
731     uint128 f;
732     luckFactor = 50;
733     for(uint8 i = 0; i < luckRounds; i++){
734       f = roll(uint128(generateRandomNumber(nonce+i*7)%1000));
735       if(f < luckFactor) luckFactor = f;
736     }
737   }
738   
739   function roll(uint128 nonce) internal view returns(uint128) {
740     uint128 sum = 0;
741     uint128 inc = 1;
742     for (uint128 i = 45; i >= 3; i--) {
743       if (sum > nonce) {
744           return i;
745       }
746       sum += inc;
747       if (i != 35) {
748           inc += 1;
749       }
750     }
751     return 3;
752   }
753   
754   function distributeCastleLootMulti(uint32[] characterIds) external onlyUser {
755     require(characterIds.length <= 50);
756     for(uint i = 0; i < characterIds.length; i++){
757       distributeCastleLoot(characterIds[i]);
758     }
759   }
760 
761   /* @dev distributes castle loot among archers */
762   function distributeCastleLoot(uint32 characterId) public onlyUser {
763     require(castleTreasury > 0, "empty treasury");
764     Character archer = characters[characterId];
765     require(archer.characterType >= ARCHER_MIN_TYPE && archer.characterType <= ARCHER_MAX_TYPE, "only archers can access the castle treasury");
766     if(lastCastleLootDistributionTimestamp[characterId] == 0) 
767       require(now - archer.purchaseTimestamp >= config.castleLootDistributionThreshold(), 
768             "not enough time has passed since the purchase");
769     else 
770       require(now >= lastCastleLootDistributionTimestamp[characterId] + config.castleLootDistributionThreshold(),
771             "not enough time passed since the last castle loot distribution");
772     require(archer.fightCount >= 3, "need to fight 3 times");
773     lastCastleLootDistributionTimestamp[characterId] = now;
774     archer.fightCount = 0;
775     
776     uint128 luckFactor = generateLuckFactor(uint128(generateRandomNumber(characterId) % 1000));
777     if (luckFactor < 3) {
778       luckFactor = 3;
779     }
780     assert(luckFactor <= 50);
781     uint128 amount = castleTreasury * luckFactor / 100; 
782     archer.value += amount;
783     castleTreasury -= amount;
784     emit NewDistributionCastleLoot(amount, characterId, luckFactor);
785 
786   }
787 
788   /**
789    * sell the character of the given id
790    * throws an exception in case of a knight not yet teleported to the game
791    * @param characterId the id of the character
792    * */
793   function sellCharacter(uint32 characterId, uint16 characterIndex) public onlyUser {
794     if (characterIndex >= numCharacters || characterId != ids[characterIndex])
795       characterIndex = getCharacterIndex(characterId);
796     Character storage char = characters[characterId];
797     require(msg.sender == char.owner,
798             "only owners can sell their characters");
799     require(char.characterType < BALLOON_MIN_TYPE || char.characterType > BALLOON_MAX_TYPE,
800             "balloons are not sellable");
801     require(char.purchaseTimestamp + 1 days < now,
802             "character can be sold only 1 day after the purchase");
803     uint128 val = char.value;
804     numCharacters--;
805     replaceCharacter(characterIndex, numCharacters);
806     msg.sender.transfer(val);
807     if (oldest == 0)
808       findOldest();
809     emit NewSell(characterId, msg.sender, val);
810   }
811 
812   /**
813    * receive approval to spend some tokens.
814    * used for teleport and protection.
815    * @param sender the sender address
816    * @param value the transferred value
817    * @param tokenContract the address of the token contract
818    * @param callData the data passed by the token contract
819    * */
820   function receiveApproval(address sender, uint256 value, address tokenContract, bytes callData) public {
821     require(tokenContract == address(teleportToken), "everything is paid with teleport tokens");
822     bool forProtection = secondToUint32(callData) == 1 ? true : false;
823     uint32 id;
824     uint256 price;
825     if (!forProtection) {
826       id = toUint32(callData);
827       price = config.teleportPrice();
828       if (characters[id].characterType >= BALLOON_MIN_TYPE && characters[id].characterType <= WIZARD_MAX_TYPE) {
829         price *= 2;
830       }
831       require(value >= price,
832               "insufficinet amount of tokens to teleport this character");
833       assert(teleportToken.transferFrom(sender, this, price));
834       teleportCharacter(id);
835     } else {
836       id = toUint32(callData);
837       // user can purchase extra lifes only right after character purchaes
838       // in other words, user value should be equal the initial value
839       uint8 cType = characters[id].characterType;
840       require(characters[id].value == config.values(cType),
841               "protection could be bought only before the first fight and before the first volcano eruption");
842 
843       // calc how many lifes user can actually buy
844       // the formula is the following:
845 
846       uint256 lifePrice;
847       uint8 max;
848       if(cType <= KNIGHT_MAX_TYPE ){
849         lifePrice = ((cType % NUMBER_OF_LEVELS) + 1) * config.protectionPrice();
850         max = 3;
851       } else if (cType >= BALLOON_MIN_TYPE && cType <= BALLOON_MAX_TYPE) {
852         lifePrice = (((cType+3) % NUMBER_OF_LEVELS) + 1) * config.protectionPrice() * 2;
853         max = 6;
854       } else if (cType >= WIZARD_MIN_TYPE && cType <= WIZARD_MAX_TYPE) {
855         lifePrice = (((cType+3) % NUMBER_OF_LEVELS) + 1) * config.protectionPrice() * 2;
856         max = 3;
857       } else if (cType >= ARCHER_MIN_TYPE && cType <= ARCHER_MAX_TYPE) {
858         lifePrice = (((cType+3) % NUMBER_OF_LEVELS) + 1) * config.protectionPrice();
859         max = 3;
860       }
861 
862       price = 0;
863       uint8 i = protection[id];
864       for (i; i < max && value >= price + lifePrice * (i + 1); i++) {
865         price += lifePrice * (i + 1);
866       }
867       assert(teleportToken.transferFrom(sender, this, price));
868       protectCharacter(id, i);
869     } 
870   }
871 
872   /**
873    * Knights, balloons, wizards, and archers are only entering the game completely, when they are teleported to the scene
874    * @param id the character id
875    * */
876   function teleportCharacter(uint32 id) internal {
877     // ensure we do not teleport twice
878     require(teleported[id] == false,
879            "already teleported");
880     teleported[id] = true;
881     Character storage character = characters[id];
882     require(character.characterType > DRAGON_MAX_TYPE,
883            "dragons do not need to be teleported"); //this also makes calls with non-existent ids fail
884     addCharacter(id, numCharacters);
885     numCharacters++;
886     numCharactersXType[character.characterType]++;
887     emit NewTeleport(id);
888   }
889 
890   /**
891    * adds protection to a character
892    * @param id the character id
893    * @param lifes the number of protections
894    * */
895   function protectCharacter(uint32 id, uint8 lifes) internal {
896     protection[id] = lifes;
897     emit NewProtection(id, lifes);
898   }
899   
900   /**
901    * set the castle loot factor (percent of the luck factor being distributed)
902    * */
903   function setLuckRound(uint8 rounds) public onlyOwner{
904     require(rounds >= 1 && rounds <= 100);
905     luckRounds = rounds;
906   }
907 
908 
909   /****************** GETTERS *************************/
910 
911   /**
912    * returns the character of the given id
913    * @param characterId the character id
914    * @return the type, value and owner of the character
915    * */
916   function getCharacter(uint32 characterId) public view returns(uint8, uint128, address) {
917     return (characters[characterId].characterType, characters[characterId].value, characters[characterId].owner);
918   }
919 
920   /**
921    * returns the index of a character of the given id
922    * @param characterId the character id
923    * @return the character id
924    * */
925   function getCharacterIndex(uint32 characterId) constant public returns(uint16) {
926     for (uint16 i = 0; i < ids.length; i++) {
927       if (ids[i] == characterId) {
928         return i;
929       }
930     }
931     revert();
932   }
933 
934   /**
935    * returns 10 characters starting from a certain indey
936    * @param startIndex the index to start from
937    * @return 4 arrays containing the ids, types, values and owners of the characters
938    * */
939   function get10Characters(uint16 startIndex) constant public returns(uint32[10] characterIds, uint8[10] types, uint128[10] values, address[10] owners) {
940     uint32 endIndex = startIndex + 10 > numCharacters ? numCharacters : startIndex + 10;
941     uint8 j = 0;
942     uint32 id;
943     for (uint16 i = startIndex; i < endIndex; i++) {
944       id = ids[i];
945       characterIds[j] = id;
946       types[j] = characters[id].characterType;
947       values[j] = characters[id].value;
948       owners[j] = characters[id].owner;
949       j++;
950     }
951 
952   }
953 
954   /**
955    * returns the number of dragons in the game
956    * @return the number of dragons
957    * */
958   function getNumDragons() constant public returns(uint16 numDragons) {
959     for (uint8 i = DRAGON_MIN_TYPE; i <= DRAGON_MAX_TYPE; i++)
960       numDragons += numCharactersXType[i];
961   }
962 
963   /**
964    * returns the number of wizards in the game
965    * @return the number of wizards
966    * */
967   function getNumWizards() constant public returns(uint16 numWizards) {
968     for (uint8 i = WIZARD_MIN_TYPE; i <= WIZARD_MAX_TYPE; i++)
969       numWizards += numCharactersXType[i];
970   }
971   /**
972    * returns the number of archers in the game
973    * @return the number of archers
974    * */
975   function getNumArchers() constant public returns(uint16 numArchers) {
976     for (uint8 i = ARCHER_MIN_TYPE; i <= ARCHER_MAX_TYPE; i++)
977       numArchers += numCharactersXType[i];
978   }
979 
980   /**
981    * returns the number of knights in the game
982    * @return the number of knights
983    * */
984   function getNumKnights() constant public returns(uint16 numKnights) {
985     for (uint8 i = KNIGHT_MIN_TYPE; i <= KNIGHT_MAX_TYPE; i++)
986       numKnights += numCharactersXType[i];
987   }
988 
989   /**
990    * @return the accumulated fees
991    * */
992   function getFees() constant public returns(uint) {
993     uint reserved = castleTreasury;
994     for (uint16 j = 0; j < numCharacters; j++)
995       reserved += characters[ids[j]].value;
996     return address(this).balance - reserved;
997   }
998 
999 
1000   /************* HELPERS ****************/
1001 
1002   /**
1003    * only works for bytes of length < 32
1004    * @param b the byte input
1005    * @return the uint
1006    * */
1007   function toUint32(bytes b) internal pure returns(uint32) {
1008     bytes32 newB;
1009     assembly {
1010       newB: = mload(0xa0)
1011     }
1012     return uint32(newB);
1013   }
1014   
1015   function secondToUint32(bytes b) internal pure returns(uint32){
1016     bytes32 newB;
1017     assembly {
1018       newB: = mload(0xc0)
1019     }
1020     return uint32(newB);
1021   }
1022 }