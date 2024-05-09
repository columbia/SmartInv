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
14 // DragonKing v2.0 2e59d4
15 
16 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() public {
35     owner = msg.sender;
36   }
37 
38 
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address newOwner) public onlyOwner {
53     require(newOwner != address(0));
54     OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 
58 }
59 
60 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
61 
62 /**
63  * @title ERC20Basic
64  * @dev Simpler version of ERC20 interface
65  * @dev see https://github.com/ethereum/EIPs/issues/179
66  */
67 contract ERC20Basic {
68   uint256 public totalSupply;
69   function balanceOf(address who) public view returns (uint256);
70   function transfer(address to, uint256 value) public returns (bool);
71   event Transfer(address indexed from, address indexed to, uint256 value);
72 }
73 
74 // File: zeppelin-solidity/contracts/token/ERC20.sol
75 
76 /**
77  * @title ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/20
79  */
80 contract ERC20 is ERC20Basic {
81   function allowance(address owner, address spender) public view returns (uint256);
82   function transferFrom(address from, address to, uint256 value) public returns (bool);
83   function approve(address spender, uint256 value) public returns (bool);
84   event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 
88 /**
89  * @title Destructible
90  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
91  */
92 contract Destructible is Ownable {
93 
94   function Destructible() public payable { }
95 
96   /**
97    * @dev Transfers the current balance to the owner and terminates the contract.
98    */
99   function destroy() onlyOwner public {
100     selfdestruct(owner);
101   }
102 
103   function destroyAndSend(address _recipient) onlyOwner public {
104     selfdestruct(_recipient);
105   }
106 }
107 
108 contract DragonKingConfig is Ownable {
109 
110 
111   /** the Gift token contract **/
112   ERC20 public giftToken;
113   /** amount of gift tokens to send **/
114   uint256 public giftTokenAmount;
115   /** the cost of each character type */
116   uint128[] public costs;
117   /** the value of each character type (cost - fee), so it's not necessary to compute it each time*/
118   uint128[] public values;
119   /** the fee to be paid each time an character is bought in percent*/
120   uint8 fee;
121   /** The maximum of characters allowed in the game */
122   uint16 public maxCharacters;
123   /** the amount of time that should pass since last eruption **/
124   uint256 public eruptionThreshold;
125   /** the amount of time that should pass ince last castle loot distribution **/
126   uint256 public castleLootDistributionThreshold;
127   /** how many characters to kill in %, e.g. 20 will stand for 20%, should be < 100 **/
128   uint8 public percentageToKill;
129   /* Cooldown threshold */
130   uint256 public constant CooldownThreshold = 1 days;
131   /** fight factor, used to compute extra probability in fight **/
132   uint8 public fightFactor;
133 
134   /** the price for teleportation*/
135   uint256 public teleportPrice;
136   /** the price for protection */
137   uint256 public protectionPrice;
138   /** the luck threshold */
139   uint256 public luckThreshold;
140 
141   function hasEnoughTokensToPurchase(address buyer, uint8 characterType) external returns (bool canBuy);
142 }
143 
144 contract DragonKing is Destructible {
145 
146   /**
147    * @dev Throws if called by contract not a user 
148    */
149   modifier onlyUser() {
150     require(msg.sender == tx.origin, 
151             "contracts cannot execute this method"
152            );
153     _;
154   }
155 
156 
157   struct Character {
158     uint8 characterType;
159     uint128 value;
160     address owner;
161     uint64 purchaseTimestamp;
162     uint8 fightCount;
163   }
164 
165   DragonKingConfig public config;
166 
167   /** the neverdie token contract used to purchase protection from eruptions and fights */
168   ERC20 neverdieToken;
169   /** the teleport token contract used to send knights to the game scene */
170   ERC20 teleportToken;
171   /** the luck token contract **/
172   ERC20 luckToken;
173   /** the SKL token contract **/
174   ERC20 sklToken;
175   /** the XP token contract **/
176   ERC20 xperToken;
177   
178 
179   /** array holding ids of the curret characters **/
180   uint32[] public ids;
181   /** the id to be given to the next character **/
182   uint32 public nextId;
183   /** non-existant character **/
184   uint16 public constant INVALID_CHARACTER_INDEX = ~uint16(0);
185 
186   /** the castle treasury **/
187   uint128 public castleTreasury;
188   /** the id of the oldest character **/
189   uint32 public oldest;
190   /** the character belonging to a given id **/
191   mapping(uint32 => Character) characters;
192   /** teleported knights **/
193   mapping(uint32 => bool) teleported;
194 
195   /** constant used to signal that there is no King at the moment **/
196   uint32 constant public noKing = ~uint32(0);
197 
198   /** total number of characters in the game **/
199   uint16 public numCharacters;
200   /** number of characters per type **/
201   mapping(uint8 => uint16) public numCharactersXType;
202 
203   /** timestamp of the last eruption event **/
204   uint256 public lastEruptionTimestamp;
205   /** timestamp of the last castle loot distribution **/
206   uint256 public lastCastleLootDistributionTimestamp;
207 
208   /** character type range constants **/
209   uint8 public constant DRAGON_MIN_TYPE = 0;
210   uint8 public constant DRAGON_MAX_TYPE = 5;
211 
212   uint8 public constant KNIGHT_MIN_TYPE = 6;
213   uint8 public constant KNIGHT_MAX_TYPE = 11;
214 
215   uint8 public constant BALLOON_MIN_TYPE = 12;
216   uint8 public constant BALLOON_MAX_TYPE = 14;
217 
218   uint8 public constant WIZARD_MIN_TYPE = 15;
219   uint8 public constant WIZARD_MAX_TYPE = 20;
220 
221   uint8 public constant ARCHER_MIN_TYPE = 21;
222   uint8 public constant ARCHER_MAX_TYPE = 26;
223 
224   uint8 public constant NUMBER_OF_LEVELS = 6;
225 
226   uint8 public constant INVALID_CHARACTER_TYPE = 27;
227 
228     /** knight cooldown. contains the timestamp of the earliest possible moment to start a fight */
229   mapping(uint32 => uint) public cooldown;
230 
231     /** tells the number of times a character is protected */
232   mapping(uint32 => uint8) public protection;
233 
234   // EVENTS
235 
236   /** is fired when new characters are purchased (who bought how many characters of which type?) */
237   event NewPurchase(address player, uint8 characterType, uint16 amount, uint32 startId);
238   /** is fired when a player leaves the game */
239   event NewExit(address player, uint256 totalBalance, uint32[] removedCharacters);
240   /** is fired when an eruption occurs */
241   event NewEruption(uint32[] hitCharacters, uint128 value, uint128 gasCost);
242   /** is fired when a single character is sold **/
243   event NewSell(uint32 characterId, address player, uint256 value);
244   /** is fired when a knight fights a dragon **/
245   event NewFight(uint32 winnerID, uint32 loserID, uint256 value, uint16 probability, uint16 dice);
246   /** is fired when a knight is teleported to the field **/
247   event NewTeleport(uint32 characterId);
248   /** is fired when a protection is purchased **/
249   event NewProtection(uint32 characterId, uint8 lifes);
250   /** is fired when a castle loot distribution occurs**/
251   event NewDistributionCastleLoot(uint128 castleLoot);
252 
253   /* initializes the contract parameter */
254   constructor(address tptAddress, address ndcAddress, address sklAddress, address xperAddress, address luckAddress, address _configAddress) public {
255     nextId = 1;
256     teleportToken = ERC20(tptAddress);
257     neverdieToken = ERC20(ndcAddress);
258     sklToken = ERC20(sklAddress);
259     xperToken = ERC20(xperAddress);
260     luckToken = ERC20(luckAddress);
261     config = DragonKingConfig(_configAddress);
262   }
263 
264   /** 
265     * gifts one character
266     * @param receiver gift character owner
267     * @param characterType type of the character to create as a gift
268     */
269   function giftCharacter(address receiver, uint8 characterType) payable public onlyUser {
270     _addCharacters(receiver, characterType);
271     assert(config.giftToken().transfer(receiver, config.giftTokenAmount()));
272   }
273 
274   /**
275    * buys as many characters as possible with the transfered value of the given type
276    * @param characterType the type of the character
277    */
278   function addCharacters(uint8 characterType) payable public onlyUser {
279     _addCharacters(msg.sender, characterType);
280   }
281 
282   function _addCharacters(address receiver, uint8 characterType) internal {
283     uint16 amount = uint16(msg.value / config.costs(characterType));
284     require(
285       amount > 0,
286       "insufficient amount of ether to purchase a given type of character");
287     uint16 nchars = numCharacters;
288     require(
289       config.hasEnoughTokensToPurchase(receiver, characterType),
290       "insufficinet amount of tokens to purchase a given type of character"
291     );
292     if (characterType >= INVALID_CHARACTER_TYPE || msg.value < config.costs(characterType) || nchars + amount > config.maxCharacters()) revert();
293     uint32 nid = nextId;
294     //if type exists, enough ether was transferred and there are less than maxCharacters characters in the game
295     if (characterType <= DRAGON_MAX_TYPE) {
296       //dragons enter the game directly
297       if (oldest == 0 || oldest == noKing)
298         oldest = nid;
299       for (uint8 i = 0; i < amount; i++) {
300         addCharacter(nid + i, nchars + i);
301         characters[nid + i] = Character(characterType, config.values(characterType), receiver, uint64(now), 0);
302       }
303       numCharactersXType[characterType] += amount;
304       numCharacters += amount;
305     }
306     else {
307       // to enter game knights, mages, and archers should be teleported later
308       for (uint8 j = 0; j < amount; j++) {
309         characters[nid + j] = Character(characterType, config.values(characterType), receiver, uint64(now), 0);
310       }
311     }
312     nextId = nid + amount;
313     emit NewPurchase(receiver, characterType, amount, nid);
314   }
315 
316 
317 
318   /**
319    * adds a single dragon of the given type to the ids array, which is used to iterate over all characters
320    * @param nId the id the character is about to receive
321    * @param nchars the number of characters currently in the game
322    */
323   function addCharacter(uint32 nId, uint16 nchars) internal {
324     if (nchars < ids.length)
325       ids[nchars] = nId;
326     else
327       ids.push(nId);
328   }
329 
330   /**
331    * leave the game.
332    * pays out the sender's balance and removes him and his characters from the game
333    * */
334   function exit() public {
335     uint32[] memory removed = new uint32[](50);
336     uint8 count;
337     uint32 lastId;
338     uint playerBalance;
339     uint16 nchars = numCharacters;
340     for (uint16 i = 0; i < nchars; i++) {
341       if (characters[ids[i]].owner == msg.sender 
342           && characters[ids[i]].purchaseTimestamp + 1 days < now
343           && (characters[ids[i]].characterType < BALLOON_MIN_TYPE || characters[ids[i]].characterType > BALLOON_MAX_TYPE)) {
344         //first delete all characters at the end of the array
345         while (nchars > 0 
346             && characters[ids[nchars - 1]].owner == msg.sender 
347             && characters[ids[nchars - 1]].purchaseTimestamp + 1 days < now
348             && (characters[ids[i]].characterType < BALLOON_MIN_TYPE || characters[ids[i]].characterType > BALLOON_MAX_TYPE)) {
349           nchars--;
350           lastId = ids[nchars];
351           numCharactersXType[characters[lastId].characterType]--;
352           playerBalance += characters[lastId].value;
353           removed[count] = lastId;
354           count++;
355           if (lastId == oldest) oldest = 0;
356           delete characters[lastId];
357         }
358         //replace the players character by the last one
359         if (nchars > i + 1) {
360           playerBalance += characters[ids[i]].value;
361           removed[count] = ids[i];
362           count++;
363           nchars--;
364           replaceCharacter(i, nchars);
365         }
366       }
367     }
368     numCharacters = nchars;
369     emit NewExit(msg.sender, playerBalance, removed); //fire the event to notify the client
370     msg.sender.transfer(playerBalance);
371     if (oldest == 0)
372       findOldest();
373   }
374 
375   /**
376    * Replaces the character with the given id with the last character in the array
377    * @param index the index of the character in the id array
378    * @param nchars the number of characters
379    * */
380   function replaceCharacter(uint16 index, uint16 nchars) internal {
381     uint32 characterId = ids[index];
382     numCharactersXType[characters[characterId].characterType]--;
383     if (characterId == oldest) oldest = 0;
384     delete characters[characterId];
385     ids[index] = ids[nchars];
386     delete ids[nchars];
387   }
388 
389   /**
390    * The volcano eruption can be triggered by anybody but only if enough time has passed since the last eription.
391    * The volcano hits up to a certain percentage of characters, but at least one.
392    * The percantage is specified in 'percentageToKill'
393    * */
394 
395   function triggerVolcanoEruption() public onlyUser {
396     require(now >= lastEruptionTimestamp + config.eruptionThreshold(),
397            "not enough time passed since last eruption");
398     require(numCharacters > 0,
399            "there are no characters in the game");
400     lastEruptionTimestamp = now;
401     uint128 pot;
402     uint128 value;
403     uint16 random;
404     uint32 nextHitId;
405     uint16 nchars = numCharacters;
406     uint32 howmany = nchars * config.percentageToKill() / 100;
407     uint128 neededGas = 80000 + 10000 * uint32(nchars);
408     if(howmany == 0) howmany = 1;//hit at least 1
409     uint32[] memory hitCharacters = new uint32[](howmany);
410     bool[] memory alreadyHit = new bool[](nextId);
411     uint16 i = 0;
412     uint16 j = 0;
413     while (i < howmany) {
414       j++;
415       random = uint16(generateRandomNumber(lastEruptionTimestamp + j) % nchars);
416       nextHitId = ids[random];
417       if (!alreadyHit[nextHitId]) {
418         alreadyHit[nextHitId] = true;
419         hitCharacters[i] = nextHitId;
420         value = hitCharacter(random, nchars, 0);
421         if (value > 0) {
422           nchars--;
423         }
424         pot += value;
425         i++;
426       }
427     }
428     uint128 gasCost = uint128(neededGas * tx.gasprice);
429     numCharacters = nchars;
430     if (pot > gasCost){
431       distribute(pot - gasCost); //distribute the pot minus the oraclize gas costs
432       emit NewEruption(hitCharacters, pot - gasCost, gasCost);
433     }
434     else
435       emit NewEruption(hitCharacters, 0, gasCost);
436   }
437 
438   /**
439    * Knight can attack a dragon.
440    * Archer can attack only a balloon.
441    * Dragon can attack wizards and archers.
442    * Wizard can attack anyone, except balloon.
443    * Balloon cannot attack.
444    * The value of the loser is transfered to the winner.
445    * @param characterID the ID of the knight to perfrom the attack
446    * @param characterIndex the index of the knight in the ids-array. Just needed to save gas costs.
447    *            In case it's unknown or incorrect, the index is looked up in the array.
448    * */
449   function fight(uint32 characterID, uint16 characterIndex) public onlyUser {
450     if (characterID != ids[characterIndex])
451       characterIndex = getCharacterIndex(characterID);
452     Character storage character = characters[characterID];
453     require(cooldown[characterID] + config.CooldownThreshold() <= now,
454             "not enough time passed since the last fight of this character");
455     require(character.owner == msg.sender,
456             "only owner can initiate a fight for this character");
457 
458     uint8 ctype = character.characterType;
459     require(ctype < BALLOON_MIN_TYPE || ctype > BALLOON_MAX_TYPE,
460             "balloons cannot fight");
461 
462     uint16 adversaryIndex = getRandomAdversary(characterID, ctype);
463     assert(adversaryIndex != INVALID_CHARACTER_INDEX);
464     uint32 adversaryID = ids[adversaryIndex];
465 
466     Character storage adversary = characters[adversaryID];
467     uint128 value;
468     uint16 base_probability;
469     uint16 dice = uint16(generateRandomNumber(characterID) % 100);
470     if (luckToken.balanceOf(msg.sender) >= config.luckThreshold()) {
471       base_probability = uint16(generateRandomNumber(dice) % 100);
472       if (base_probability < dice) {
473         dice = base_probability;
474       }
475       base_probability = 0;
476     }
477     uint256 characterPower = sklToken.balanceOf(character.owner) / 10**15 + xperToken.balanceOf(character.owner);
478     uint256 adversaryPower = sklToken.balanceOf(adversary.owner) / 10**15 + xperToken.balanceOf(adversary.owner);
479     
480     if (character.value == adversary.value) {
481         base_probability = 50;
482       if (characterPower > adversaryPower) {
483         base_probability += uint16(100 / config.fightFactor());
484       } else if (adversaryPower > characterPower) {
485         base_probability -= uint16(100 / config.fightFactor());
486       }
487     } else if (character.value > adversary.value) {
488       base_probability = 100;
489       if (adversaryPower > characterPower) {
490         base_probability -= uint16((100 * adversary.value) / character.value / config.fightFactor());
491       }
492     } else if (characterPower > adversaryPower) {
493         base_probability += uint16((100 * character.value) / adversary.value / config.fightFactor());
494     }
495 
496     if (dice >= base_probability) {
497       // adversary won
498       if (adversary.characterType < BALLOON_MIN_TYPE || adversary.characterType > BALLOON_MAX_TYPE) {
499         value = hitCharacter(characterIndex, numCharacters, adversary.characterType);
500         if (value > 0) {
501           numCharacters--;
502         } else {
503           cooldown[characterID] = now;
504           if (characters[characterID].fightCount < 3) {
505             characters[characterID].fightCount++;
506           }
507         }
508         if (adversary.characterType >= ARCHER_MIN_TYPE && adversary.characterType <= ARCHER_MAX_TYPE) {
509           castleTreasury += value;
510         } else {
511           adversary.value += value;
512         }
513         emit NewFight(adversaryID, characterID, value, base_probability, dice);
514       } else {
515         emit NewFight(adversaryID, characterID, 0, base_probability, dice); // balloons do not hit back
516       }
517     } else {
518       // character won
519       cooldown[characterID] = now;
520       if (characters[characterID].fightCount < 3) {
521         characters[characterID].fightCount++;
522       }
523       value = hitCharacter(adversaryIndex, numCharacters, character.characterType);
524       if (value > 0) {
525         numCharacters--;
526       }
527       if (character.characterType >= ARCHER_MIN_TYPE && character.characterType <= ARCHER_MAX_TYPE) {
528         castleTreasury += value;
529       } else {
530         character.value += value;
531       }
532       if (oldest == 0) findOldest();
533       emit NewFight(characterID, adversaryID, value, base_probability, dice);
534     }
535   }
536 
537   
538   /*
539   * @param characterType
540   * @param adversaryType
541   * @return whether adversaryType is a valid type of adversary for a given character
542   */
543   function isValidAdversary(uint8 characterType, uint8 adversaryType) pure returns (bool) {
544     if (characterType >= KNIGHT_MIN_TYPE && characterType <= KNIGHT_MAX_TYPE) { // knight
545       return (adversaryType <= DRAGON_MAX_TYPE);
546     } else if (characterType >= WIZARD_MIN_TYPE && characterType <= WIZARD_MAX_TYPE) { // wizard
547       return (adversaryType < BALLOON_MIN_TYPE || adversaryType > BALLOON_MAX_TYPE);
548     } else if (characterType >= DRAGON_MIN_TYPE && characterType <= DRAGON_MAX_TYPE) { // dragon
549       return (adversaryType >= WIZARD_MIN_TYPE);
550     } else if (characterType >= ARCHER_MIN_TYPE && characterType <= ARCHER_MAX_TYPE) { // archer
551       return ((adversaryType >= BALLOON_MIN_TYPE && adversaryType <= BALLOON_MAX_TYPE)
552              || (adversaryType >= KNIGHT_MIN_TYPE && adversaryType <= KNIGHT_MAX_TYPE));
553  
554     }
555     return false;
556   }
557 
558   /**
559    * pick a random adversary.
560    * @param nonce a nonce to make sure there's not always the same adversary chosen in a single block.
561    * @return the index of a random adversary character
562    * */
563   function getRandomAdversary(uint256 nonce, uint8 characterType) internal view returns(uint16) {
564     uint16 randomIndex = uint16(generateRandomNumber(nonce) % numCharacters);
565     // use 7, 11 or 13 as step size. scales for up to 1000 characters
566     uint16 stepSize = numCharacters % 7 == 0 ? (numCharacters % 11 == 0 ? 13 : 11) : 7;
567     uint16 i = randomIndex;
568     //if the picked character is a knight or belongs to the sender, look at the character + stepSizes ahead in the array (modulo the total number)
569     //will at some point return to the startingPoint if no character is suited
570     do {
571       if (isValidAdversary(characterType, characters[ids[i]].characterType) && characters[ids[i]].owner != msg.sender) {
572         return i;
573       }
574       i = (i + stepSize) % numCharacters;
575     } while (i != randomIndex);
576 
577     return INVALID_CHARACTER_INDEX;
578   }
579 
580 
581   /**
582    * generate a random number.
583    * @param nonce a nonce to make sure there's not always the same number returned in a single block.
584    * @return the random number
585    * */
586   function generateRandomNumber(uint256 nonce) internal view returns(uint) {
587     return uint(keccak256(block.blockhash(block.number - 1), now, numCharacters, nonce));
588   }
589 
590 	/**
591    * Hits the character of the given type at the given index.
592    * Wizards can knock off two protections. Other characters can do only one.
593    * @param index the index of the character
594    * @param nchars the number of characters
595    * @return the value gained from hitting the characters (zero is the character was protected)
596    * */
597   function hitCharacter(uint16 index, uint16 nchars, uint8 characterType) internal returns(uint128 characterValue) {
598     uint32 id = ids[index];
599     uint8 knockOffProtections = 1;
600     if (characterType >= WIZARD_MIN_TYPE && characterType <= WIZARD_MAX_TYPE) {
601       knockOffProtections = 2;
602     }
603     if (protection[id] >= knockOffProtections) {
604       protection[id] = protection[id] - knockOffProtections;
605       return 0;
606     }
607     characterValue = characters[ids[index]].value;
608     nchars--;
609     replaceCharacter(index, nchars);
610   }
611 
612   /**
613    * finds the oldest character
614    * */
615   function findOldest() public {
616     uint32 newOldest = noKing;
617     for (uint16 i = 0; i < numCharacters; i++) {
618       if (ids[i] < newOldest && characters[ids[i]].characterType <= DRAGON_MAX_TYPE)
619         newOldest = ids[i];
620     }
621     oldest = newOldest;
622   }
623 
624   /**
625   * distributes the given amount among the surviving characters
626   * @param totalAmount nthe amount to distribute
627   */
628   function distribute(uint128 totalAmount) internal {
629     uint128 amount;
630     if (oldest == 0)
631       findOldest();
632     if (oldest != noKing) {
633       //pay 10% to the oldest dragon
634       characters[oldest].value += totalAmount / 10;
635       amount  = totalAmount / 10 * 9;
636     } else {
637       amount  = totalAmount;
638     }
639     //distribute the rest according to their type
640     uint128 valueSum;
641     uint8 size = ARCHER_MAX_TYPE + 1;
642     uint128[] memory shares = new uint128[](size);
643     for (uint8 v = 0; v < size; v++) {
644       if ((v < BALLOON_MIN_TYPE || v > BALLOON_MAX_TYPE) && numCharactersXType[v] > 0) {
645            valueSum += config.values(v);
646       }
647     }
648     for (uint8 m = 0; m < size; m++) {
649       if ((v < BALLOON_MIN_TYPE || v > BALLOON_MAX_TYPE) && numCharactersXType[m] > 0) {
650         shares[m] = amount * config.values(m) / valueSum / numCharactersXType[m];
651       }
652     }
653     uint8 cType;
654     for (uint16 i = 0; i < numCharacters; i++) {
655       cType = characters[ids[i]].characterType;
656       if (cType < BALLOON_MIN_TYPE || cType > BALLOON_MAX_TYPE)
657         characters[ids[i]].value += shares[characters[ids[i]].characterType];
658     }
659   }
660 
661   /**
662    * allows the owner to collect the accumulated fees
663    * sends the given amount to the owner's address if the amount does not exceed the
664    * fees (cannot touch the players' balances) minus 100 finney (ensure that oraclize fees can be paid)
665    * @param amount the amount to be collected
666    * */
667   function collectFees(uint128 amount) public onlyOwner {
668     uint collectedFees = getFees();
669     if (amount + 100 finney < collectedFees) {
670       owner.transfer(amount);
671     }
672   }
673 
674   /**
675   * withdraw NDC and TPT tokens
676   */
677   function withdraw() public onlyOwner {
678     uint256 ndcBalance = neverdieToken.balanceOf(this);
679     assert(neverdieToken.transfer(owner, ndcBalance));
680     uint256 tptBalance = teleportToken.balanceOf(this);
681     assert(teleportToken.transfer(owner, tptBalance));
682   }
683 
684   /**
685    * pays out the players.
686    * */
687   function payOut() public onlyOwner {
688     for (uint16 i = 0; i < numCharacters; i++) {
689       characters[ids[i]].owner.transfer(characters[ids[i]].value);
690       delete characters[ids[i]];
691     }
692     delete ids;
693     numCharacters = 0;
694   }
695 
696   /**
697    * pays out the players and kills the game.
698    * */
699   function stop() public onlyOwner {
700     withdraw();
701     payOut();
702     destroy();
703   }
704 
705   function generateLuckFactor(uint128 nonce) internal view returns(uint128) {
706     uint128 sum = 0;
707     uint128 inc = 1;
708     for (uint128 i = 49; i >= 5; i--) {
709       if (sum > nonce) {
710           return i+2;
711       }
712       sum += inc;
713       if (i != 40 && i != 8) {
714           inc += 1;
715       }
716     }
717     return 5;
718   }
719 
720   /* @dev distributes castle loot among archers */
721   function distributeCastleLoot() external onlyUser {
722     require(now >= lastCastleLootDistributionTimestamp + config.castleLootDistributionThreshold(),
723             "not enough time passed since the last castle loot distribution");
724     lastCastleLootDistributionTimestamp = now;
725     uint128 luckFactor = generateLuckFactor(uint128(now % 1000));
726     if (luckFactor < 5) {
727       luckFactor = 5;
728     }
729     uint128 amount = castleTreasury * luckFactor / 100; 
730     uint128 valueSum;
731     uint128[] memory shares = new uint128[](NUMBER_OF_LEVELS);
732     uint16 archersCount;
733     uint32[] memory archers = new uint32[](numCharacters);
734 
735     uint8 cType;
736     for (uint8 i = 0; i < ids.length; i++) {
737       cType = characters[ids[i]].characterType; 
738       if ((cType >= ARCHER_MIN_TYPE && cType <= ARCHER_MAX_TYPE) 
739         && (characters[ids[i]].fightCount >= 3)
740         && (now - characters[ids[i]].purchaseTimestamp >= 7 days)) {
741         valueSum += config.values(cType);
742         archers[archersCount] = ids[i];
743         archersCount++;
744       }
745     }
746 
747     if (valueSum > 0) {
748       for (uint8 j = 0; j < NUMBER_OF_LEVELS; j++) {
749           shares[j] = amount * config.values(ARCHER_MIN_TYPE + j) / valueSum;
750       }
751 
752       for (uint16 k = 0; k < archersCount; k++) {
753         characters[archers[k]].value += shares[characters[archers[k]].characterType - ARCHER_MIN_TYPE];
754       }
755       castleTreasury -= amount;
756       emit NewDistributionCastleLoot(amount);
757     } else {
758       emit NewDistributionCastleLoot(0);
759     }
760   }
761 
762   /**
763    * sell the character of the given id
764    * throws an exception in case of a knight not yet teleported to the game
765    * @param characterId the id of the character
766    * */
767   function sellCharacter(uint32 characterId) public onlyUser {
768     require(msg.sender == characters[characterId].owner,
769             "only owners can sell their characters");
770     require(characters[characterId].characterType < BALLOON_MIN_TYPE || characters[characterId].characterType > BALLOON_MAX_TYPE,
771             "balloons are not sellable");
772     require(characters[characterId].purchaseTimestamp + 1 days < now,
773             "character can be sold only 1 day after the purchase");
774     uint128 val = characters[characterId].value;
775     numCharacters--;
776     replaceCharacter(getCharacterIndex(characterId), numCharacters);
777     msg.sender.transfer(val);
778     if (oldest == 0)
779       findOldest();
780     emit NewSell(characterId, msg.sender, val);
781   }
782 
783   /**
784    * receive approval to spend some tokens.
785    * used for teleport and protection.
786    * @param sender the sender address
787    * @param value the transferred value
788    * @param tokenContract the address of the token contract
789    * @param callData the data passed by the token contract
790    * */
791   function receiveApproval(address sender, uint256 value, address tokenContract, bytes callData) public {
792     uint32 id;
793     uint256 price;
794     if (msg.sender == address(teleportToken)) {
795       id = toUint32(callData);
796       price = config.teleportPrice();
797       if (characters[id].characterType >= BALLOON_MIN_TYPE && characters[id].characterType <= WIZARD_MAX_TYPE) {
798         price *= 2;
799       }
800       require(value >= price,
801               "insufficinet amount of tokens to teleport this character");
802       assert(teleportToken.transferFrom(sender, this, price));
803       teleportCharacter(id);
804     } else if (msg.sender == address(neverdieToken)) {
805       id = toUint32(callData);
806       // user can purchase extra lifes only right after character purchaes
807       // in other words, user value should be equal the initial value
808       uint8 cType = characters[id].characterType;
809       require(characters[id].value == config.values(cType),
810               "protection could be bought only before the first fight and before the first volcano eruption");
811 
812       // calc how many lifes user can actually buy
813       // the formula is the following:
814 
815       uint256 lifePrice;
816       uint8 max;
817       if(cType <= KNIGHT_MAX_TYPE ){
818         lifePrice = ((cType % NUMBER_OF_LEVELS) + 1) * config.protectionPrice();
819         max = 3;
820       } else if (cType >= BALLOON_MIN_TYPE && cType <= BALLOON_MAX_TYPE) {
821         lifePrice = (((cType+3) % NUMBER_OF_LEVELS) + 1) * config.protectionPrice() * 2;
822         max = 6;
823       } else if (cType >= WIZARD_MIN_TYPE && cType <= WIZARD_MAX_TYPE) {
824         lifePrice = (((cType+3) % NUMBER_OF_LEVELS) + 1) * config.protectionPrice() * 2;
825         max = 3;
826       } else if (cType >= ARCHER_MIN_TYPE && cType <= ARCHER_MAX_TYPE) {
827         lifePrice = (((cType+3) % NUMBER_OF_LEVELS) + 1) * config.protectionPrice();
828         max = 3;
829       }
830 
831       price = 0;
832       uint8 i = protection[id];
833       for (i; i < max && value >= price + lifePrice * (i + 1); i++) {
834         price += lifePrice * (i + 1);
835       }
836       assert(neverdieToken.transferFrom(sender, this, price));
837       protectCharacter(id, i);
838     } else {
839       revert("Should be either from Neverdie or Teleport tokens");
840     }
841   }
842 
843   /**
844    * Knights, balloons, wizards, and archers are only entering the game completely, when they are teleported to the scene
845    * @param id the character id
846    * */
847   function teleportCharacter(uint32 id) internal {
848     // ensure we do not teleport twice
849     require(teleported[id] == false,
850            "already teleported");
851     teleported[id] = true;
852     Character storage character = characters[id];
853     require(character.characterType > DRAGON_MAX_TYPE,
854            "dragons do not need to be teleported"); //this also makes calls with non-existent ids fail
855     addCharacter(id, numCharacters);
856     numCharacters++;
857     numCharactersXType[character.characterType]++;
858     emit NewTeleport(id);
859   }
860 
861   /**
862    * adds protection to a character
863    * @param id the character id
864    * @param lifes the number of protections
865    * */
866   function protectCharacter(uint32 id, uint8 lifes) internal {
867     protection[id] = lifes;
868     emit NewProtection(id, lifes);
869   }
870 
871 
872   /****************** GETTERS *************************/
873 
874   /**
875    * returns the character of the given id
876    * @param characterId the character id
877    * @return the type, value and owner of the character
878    * */
879   function getCharacter(uint32 characterId) public view returns(uint8, uint128, address) {
880     return (characters[characterId].characterType, characters[characterId].value, characters[characterId].owner);
881   }
882 
883   /**
884    * returns the index of a character of the given id
885    * @param characterId the character id
886    * @return the character id
887    * */
888   function getCharacterIndex(uint32 characterId) constant public returns(uint16) {
889     for (uint16 i = 0; i < ids.length; i++) {
890       if (ids[i] == characterId) {
891         return i;
892       }
893     }
894     revert();
895   }
896 
897   /**
898    * returns 10 characters starting from a certain indey
899    * @param startIndex the index to start from
900    * @return 4 arrays containing the ids, types, values and owners of the characters
901    * */
902   function get10Characters(uint16 startIndex) constant public returns(uint32[10] characterIds, uint8[10] types, uint128[10] values, address[10] owners) {
903     uint32 endIndex = startIndex + 10 > numCharacters ? numCharacters : startIndex + 10;
904     uint8 j = 0;
905     uint32 id;
906     for (uint16 i = startIndex; i < endIndex; i++) {
907       id = ids[i];
908       characterIds[j] = id;
909       types[j] = characters[id].characterType;
910       values[j] = characters[id].value;
911       owners[j] = characters[id].owner;
912       j++;
913     }
914 
915   }
916 
917   /**
918    * returns the number of dragons in the game
919    * @return the number of dragons
920    * */
921   function getNumDragons() constant public returns(uint16 numDragons) {
922     for (uint8 i = DRAGON_MIN_TYPE; i <= DRAGON_MAX_TYPE; i++)
923       numDragons += numCharactersXType[i];
924   }
925 
926   /**
927    * returns the number of wizards in the game
928    * @return the number of wizards
929    * */
930   function getNumWizards() constant public returns(uint16 numWizards) {
931     for (uint8 i = WIZARD_MIN_TYPE; i <= WIZARD_MAX_TYPE; i++)
932       numWizards += numCharactersXType[i];
933   }
934   /**
935    * returns the number of archers in the game
936    * @return the number of archers
937    * */
938   function getNumArchers() constant public returns(uint16 numArchers) {
939     for (uint8 i = ARCHER_MIN_TYPE; i <= ARCHER_MAX_TYPE; i++)
940       numArchers += numCharactersXType[i];
941   }
942 
943   /**
944    * returns the number of knights in the game
945    * @return the number of knights
946    * */
947   function getNumKnights() constant public returns(uint16 numKnights) {
948     for (uint8 i = KNIGHT_MIN_TYPE; i <= KNIGHT_MAX_TYPE; i++)
949       numKnights += numCharactersXType[i];
950   }
951 
952   /**
953    * @return the accumulated fees
954    * */
955   function getFees() constant public returns(uint) {
956     uint reserved = 0;
957     for (uint16 j = 0; j < numCharacters; j++)
958       reserved += characters[ids[j]].value;
959     return address(this).balance - reserved;
960   }
961 
962   /************* SETTERS ****************/
963 
964   /**
965    * sets DragonKingConfig
966    * */
967   function setConfig(address _value) public onlyOwner {
968     config = DragonKingConfig(_value);
969   }
970 
971 
972   /************* HELPERS ****************/
973 
974   /**
975    * only works for bytes of length < 32
976    * @param b the byte input
977    * @return the uint
978    * */
979   function toUint32(bytes b) internal pure returns(uint32) {
980     bytes32 newB;
981     assembly {
982       newB: = mload(0xa0)
983     }
984     return uint32(newB);
985   }
986 }