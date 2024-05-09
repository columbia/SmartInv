1 /**
2  * Note for the truffle testversion:
3  * DragonKingTest inherits from DragonKing and adds one more function for testing the volcano from truffle.
4  * For deployment on ropsten or mainnet, just deploy the DragonKing contract and remove this comment before verifying on
5  * etherscan.
6  * */
7 
8  /**
9   * Dragonking is a blockchain game in which players may purchase dragons and knights of different levels and values.
10   * Once every period of time the volcano erupts and wipes a few of them from the board. The value of the killed characters
11   * gets distributed amongst all of the survivors. The dragon king receive a bigger share than the others.
12   * In contrast to dragons, knights need to be teleported to the battlefield first with the use of teleport tokens.
13   * Additionally, they may attack a dragon once per period.
14   * Both character types can be protected from death up to three times.
15   * Take a look at dragonking.io for more detailed information.
16   * @author: Julia Altenried, Yuriy Kashnikov
17   * */
18 
19 pragma solidity ^0.4.24;
20 
21 
22 
23 /**
24  * @title Ownable
25  * @dev The Ownable contract has an owner address, and provides basic authorization control
26  * functions, this simplifies the implementation of "user permissions".
27  */
28 contract Ownable {
29   address public owner;
30 
31 
32   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34 
35   /**
36    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
37    * account.
38    */
39   function Ownable() public {
40     owner = msg.sender;
41   }
42 
43 
44   /**
45    * @dev Throws if called by any account other than the owner.
46    */
47   modifier onlyOwner() {
48     require(msg.sender == owner);
49     _;
50   }
51 
52 
53   /**
54    * @dev Allows the current owner to transfer control of the contract to a newOwner.
55    * @param newOwner The address to transfer ownership to.
56    */
57   function transferOwnership(address newOwner) public onlyOwner {
58     require(newOwner != address(0));
59     OwnershipTransferred(owner, newOwner);
60     owner = newOwner;
61   }
62 
63 }
64 
65 
66 /**
67  * @title Destructible
68  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
69  */
70 contract Destructible is Ownable {
71 
72   function Destructible() public payable { }
73 
74   /**
75    * @dev Transfers the current balance to the owner and terminates the contract.
76    */
77   function destroy() onlyOwner public {
78     selfdestruct(owner);
79   }
80 
81   function destroyAndSend(address _recipient) onlyOwner public {
82     selfdestruct(_recipient);
83   }
84 }
85 
86 contract DragonKingConfig {
87 
88 
89   /** the cost of each character type */
90   uint128[] public costs;
91   /** the value of each character type (cost - fee), so it's not necessary to compute it each time*/
92   uint128[] public values;
93   /** the fee to be paid each time an character is bought in percent*/
94   uint8 fee;
95   /** The maximum of characters allowed in the game */
96   uint16 public maxCharacters;
97   /** the amount of time that should pass since last eruption **/
98   uint256 public eruptionThreshold;
99   /** the amount of time that should pass ince last castle loot distribution **/
100   uint256 public castleLootDistributionThreshold;
101   /** how many characters to kill in %, e.g. 20 will stand for 20%, should be < 100 **/
102   uint8 public percentageToKill;
103   /* Cooldown threshold */
104   uint256 public constant CooldownThreshold = 1 days;
105   /** fight factor, used to compute extra probability in fight **/
106   uint8 public fightFactor;
107 
108   /** the price for teleportation*/
109   uint256 public teleportPrice;
110   /** the price for protection */
111   uint256 public protectionPrice;
112 
113 }
114 
115 interface Token {
116   function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
117   function transfer(address _to, uint256 _value) external returns (bool success);
118   function balanceOf(address who) external view returns (uint256);
119 }
120 
121 
122 contract DragonKing is Destructible {
123 
124   /**
125    * @dev Throws if called by contract not a user 
126    */
127   modifier onlyUser() {
128     require(msg.sender == tx.origin, 
129             "contracts cannot execute this method"
130            );
131     _;
132   }
133 
134 
135   struct Character {
136     uint8 characterType;
137     uint128 value;
138     address owner;
139     uint64 purchaseTimestamp;
140   }
141 
142   DragonKingConfig public config;
143 
144   /** the neverdue token contract used to purchase protection from eruptions and fights */
145   Token public neverdieToken;
146   /** the teleport token contract used to send knights to the game scene */
147   Token public teleportToken;
148 
149   /** the SKL token contract **/
150   Token public sklToken;
151   /** the XP token contract **/
152   Token public xperToken;
153   
154 
155   /** array holding ids of the curret characters **/
156   uint32[] public ids;
157   /** the id to be given to the next character **/
158   uint32 public nextId;
159   /** non-existant character **/
160   uint16 public constant INVALID_CHARACTER_INDEX = ~uint16(0);
161 
162   /** the castle treasury **/
163   uint128 public castleTreasury;
164   /** the id of the oldest character **/
165   uint32 public oldest;
166   /** the character belonging to a given id **/
167   mapping(uint32 => Character) characters;
168   /** teleported knights **/
169   mapping(uint32 => bool) teleported;
170 
171   /** constant used to signal that there is no King at the moment **/
172   uint32 constant public noKing = ~uint32(0);
173 
174   /** total number of characters in the game **/
175   uint16 public numCharacters;
176   /** number of characters per type **/
177   mapping(uint8 => uint16) public numCharactersXType;
178 
179   /** timestampt of the last eruption event **/
180   uint256 public lastEruptionTimestamp;
181   /** timestampt of the last castle loot distribution **/
182   uint256 public lastCastleLootDistributionTimestamp;
183 
184   /** character type range constants **/
185   uint8 public constant DRAGON_MIN_TYPE = 0;
186   uint8 public constant DRAGON_MAX_TYPE = 5;
187 
188   uint8 public constant KNIGHT_MIN_TYPE = 6;
189   uint8 public constant KNIGHT_MAX_TYPE = 11;
190 
191   uint8 public constant BALLOON_MIN_TYPE = 12;
192   uint8 public constant BALLOON_MAX_TYPE = 14;
193 
194   uint8 public constant WIZARD_MIN_TYPE = 15;
195   uint8 public constant WIZARD_MAX_TYPE = 20;
196 
197   uint8 public constant ARCHER_MIN_TYPE = 21;
198   uint8 public constant ARCHER_MAX_TYPE = 26;
199 
200   uint8 public constant NUMBER_OF_LEVELS = 6;
201 
202   uint8 public constant INVALID_CHARACTER_TYPE = 27;
203 
204   /** minimum amount of XPER and SKL to purchase wizards **/
205   uint8 public MIN_XPER_AMOUNT_TO_PURCHASE_WIZARD = 100;
206   uint8 public MIN_SKL_AMOUNT_TO_PURCHASE_WIZARD = 50;
207 
208   /** minimum amount of XPER and SKL to purchase archer **/
209   uint8 public MIN_XPER_AMOUNT_TO_PURCHASE_ARCHER = 10;
210   uint8 public MIN_SKL_AMOUNT_TO_PURCHASE_ARCHER = 5;
211 
212     /** knight cooldown. contains the timestamp of the earliest possible moment to start a fight */
213   mapping(uint32 => uint) public cooldown;
214 
215     /** tells the number of times a character is protected */
216   mapping(uint32 => uint8) public protection;
217 
218   // EVENTS
219 
220   /** is fired when new characters are purchased (who bought how many characters of which type?) */
221   event NewPurchase(address player, uint8 characterType, uint16 amount, uint32 startId);
222   /** is fired when a player leaves the game */
223   event NewExit(address player, uint256 totalBalance, uint32[] removedCharacters);
224   /** is fired when an eruption occurs */
225   event NewEruption(uint32[] hitCharacters, uint128 value, uint128 gasCost);
226   /** is fired when a single character is sold **/
227   event NewSell(uint32 characterId, address player, uint256 value);
228   /** is fired when a knight fights a dragon **/
229   event NewFight(uint32 winnerID, uint32 loserID, uint256 value, uint16 probability, uint16 dice);
230   /** is fired when a knight is teleported to the field **/
231   event NewTeleport(uint32 characterId);
232   /** is fired when a protection is purchased **/
233   event NewProtection(uint32 characterId, uint8 lifes);
234   /** is fired when a castle loot distribution occurs**/
235   event NewDistributionCastleLoot(uint128 castleLoot);
236 
237   /** initializes the contract parameters  */
238   constructor(address tptAddress, address ndcAddress, address sklAddress, address xperAddress, address _configAddress) public {
239     nextId = 1;
240     teleportToken = Token(tptAddress);
241     neverdieToken = Token(ndcAddress);
242     sklToken = Token(sklAddress);
243     xperToken = Token(xperAddress);
244     config = DragonKingConfig(_configAddress);
245   }
246 
247   /**
248    * buys as many characters as possible with the transfered value of the given type
249    * @param characterType the type of the character
250    */
251   function addCharacters(uint8 characterType) payable public onlyUser {
252     uint16 amount = uint16(msg.value / config.costs(characterType));
253     uint16 nchars = numCharacters;
254     if (characterType >= INVALID_CHARACTER_TYPE || msg.value < config.costs(characterType) || nchars + amount > config.maxCharacters()) revert();
255     uint32 nid = nextId;
256     //if type exists, enough ether was transferred and there are less than maxCharacters characters in the game
257     if (characterType <= DRAGON_MAX_TYPE) {
258       //dragons enter the game directly
259       if (oldest == 0 || oldest == noKing)
260         oldest = nid;
261       for (uint8 i = 0; i < amount; i++) {
262         addCharacter(nid + i, nchars + i);
263         characters[nid + i] = Character(characterType, config.values(characterType), msg.sender, uint64(now));
264       }
265       numCharactersXType[characterType] += amount;
266       numCharacters += amount;
267     }
268     else {
269       uint256 amountSKL = sklToken.balanceOf(msg.sender);
270       uint256 amountXPER = xperToken.balanceOf(msg.sender);
271       if (characterType >= WIZARD_MIN_TYPE && characterType <= WIZARD_MAX_TYPE) {
272         require( amountSKL >= MIN_SKL_AMOUNT_TO_PURCHASE_WIZARD && amountXPER >= MIN_XPER_AMOUNT_TO_PURCHASE_WIZARD, 
273                 "insufficient amount of SKL and XPER tokens"
274                );
275       }
276       if (characterType >= ARCHER_MIN_TYPE && characterType <= ARCHER_MAX_TYPE) {
277         require( amountSKL >= MIN_SKL_AMOUNT_TO_PURCHASE_ARCHER && amountXPER >= MIN_XPER_AMOUNT_TO_PURCHASE_ARCHER, 
278                 "insufficient amount of SKL and XPER tokens" 
279                );
280       }
281       // to enter game knights, mages, and archers should be teleported later
282       for (uint8 j = 0; j < amount; j++) {
283         characters[nid + j] = Character(characterType, config.values(characterType), msg.sender, uint64(now));
284       }
285     }
286     nextId = nid + amount;
287     emit NewPurchase(msg.sender, characterType, amount, nid);
288   }
289 
290 
291 
292   /**
293    * adds a single dragon of the given type to the ids array, which is used to iterate over all characters
294    * @param nId the id the character is about to receive
295    * @param nchars the number of characters currently in the game
296    */
297   function addCharacter(uint32 nId, uint16 nchars) internal {
298     if (nchars < ids.length)
299       ids[nchars] = nId;
300     else
301       ids.push(nId);
302   }
303 
304   /**
305    * leave the game.
306    * pays out the sender's balance and removes him and his characters from the game
307    * */
308   function exit() public {
309     uint32[] memory removed = new uint32[](50);
310     uint8 count;
311     uint32 lastId;
312     uint playerBalance;
313     uint16 nchars = numCharacters;
314     for (uint16 i = 0; i < nchars; i++) {
315       if (characters[ids[i]].owner == msg.sender 
316           && characters[ids[i]].purchaseTimestamp + 1 days < now
317           && (characters[ids[i]].characterType < BALLOON_MIN_TYPE || characters[ids[i]].characterType > BALLOON_MAX_TYPE)) {
318         //first delete all characters at the end of the array
319         while (nchars > 0 
320             && characters[ids[nchars - 1]].owner == msg.sender 
321             && characters[ids[nchars - 1]].purchaseTimestamp + 1 days < now
322             && (characters[ids[i]].characterType < BALLOON_MIN_TYPE || characters[ids[i]].characterType > BALLOON_MAX_TYPE)) {
323           nchars--;
324           lastId = ids[nchars];
325           numCharactersXType[characters[lastId].characterType]--;
326           playerBalance += characters[lastId].value;
327           removed[count] = lastId;
328           count++;
329           if (lastId == oldest) oldest = 0;
330           delete characters[lastId];
331         }
332         //replace the players character by the last one
333         if (nchars > i + 1) {
334           playerBalance += characters[ids[i]].value;
335           removed[count] = ids[i];
336           count++;
337           nchars--;
338           replaceCharacter(i, nchars);
339         }
340       }
341     }
342     numCharacters = nchars;
343     emit NewExit(msg.sender, playerBalance, removed); //fire the event to notify the client
344     msg.sender.transfer(playerBalance);
345     if (oldest == 0)
346       findOldest();
347   }
348 
349   /**
350    * Replaces the character with the given id with the last character in the array
351    * @param index the index of the character in the id array
352    * @param nchars the number of characters
353    * */
354   function replaceCharacter(uint16 index, uint16 nchars) internal {
355     uint32 characterId = ids[index];
356     numCharactersXType[characters[characterId].characterType]--;
357     if (characterId == oldest) oldest = 0;
358     delete characters[characterId];
359     ids[index] = ids[nchars];
360     delete ids[nchars];
361   }
362 
363   /**
364    * The volcano eruption can be triggered by anybody but only if enough time has passed since the last eription.
365    * The volcano hits up to a certain percentage of characters, but at least one.
366    * The percantage is specified in 'percentageToKill'
367    * */
368 
369   function triggerVolcanoEruption() public onlyUser {
370     require(now >= lastEruptionTimestamp + config.eruptionThreshold(),
371            "not enough time passed since last eruption");
372     require(numCharacters > 0,
373            "there are no characters in the game");
374     lastEruptionTimestamp = now;
375     uint128 pot;
376     uint128 value;
377     uint16 random;
378     uint32 nextHitId;
379     uint16 nchars = numCharacters;
380     uint32 howmany = nchars * config.percentageToKill() / 100;
381     uint128 neededGas = 80000 + 10000 * uint32(nchars);
382     if(howmany == 0) howmany = 1;//hit at least 1
383     uint32[] memory hitCharacters = new uint32[](howmany);
384     bool[] memory alreadyHit = new bool[](nextId);
385     uint8 i = 0;
386     uint16 j = 0;
387     while (i < howmany) {
388       j++;
389       random = uint16(generateRandomNumber(lastEruptionTimestamp + j) % nchars);
390       nextHitId = ids[random];
391       if (!alreadyHit[nextHitId]) {
392         alreadyHit[nextHitId] = true;
393         hitCharacters[i] = nextHitId;
394         value = hitCharacter(random, nchars, 0);
395         if (value > 0) {
396           nchars--;
397         }
398         pot += value;
399         i++;
400       }
401     }
402     uint128 gasCost = uint128(neededGas * tx.gasprice);
403     numCharacters = nchars;
404     if (pot > gasCost){
405       distribute(pot - gasCost); //distribute the pot minus the oraclize gas costs
406       emit NewEruption(hitCharacters, pot - gasCost, gasCost);
407     }
408     else
409       emit NewEruption(hitCharacters, 0, gasCost);
410   }
411 
412   /**
413    * Knight can attack a dragon.
414    * Archer can attack only a balloon.
415    * Dragon can attack wizards and archers.
416    * Wizard can attack anyone, except balloon.
417    * Balloon cannot attack.
418    * The value of the loser is transfered to the winner.
419    * @param characterID the ID of the knight to perfrom the attack
420    * @param characterIndex the index of the knight in the ids-array. Just needed to save gas costs.
421    *            In case it's unknown or incorrect, the index is looked up in the array.
422    * */
423   function fight(uint32 characterID, uint16 characterIndex) public onlyUser {
424     if (characterID != ids[characterIndex])
425       characterIndex = getCharacterIndex(characterID);
426     Character storage character = characters[characterID];
427     require(cooldown[characterID] + config.CooldownThreshold() <= now,
428             "not enough time passed since the last fight of this character");
429     require(character.owner == msg.sender,
430             "only owner can initiate a fight for this character");
431 
432     uint8 ctype = character.characterType;
433     require(ctype < BALLOON_MIN_TYPE || ctype > BALLOON_MAX_TYPE,
434             "balloons cannot fight");
435 
436     uint16 adversaryIndex = getRandomAdversary(characterID, ctype);
437     assert(adversaryIndex != INVALID_CHARACTER_INDEX);
438     uint32 adversaryID = ids[adversaryIndex];
439 
440     Character storage adversary = characters[adversaryID];
441     uint128 value;
442     uint16 base_probability;
443     uint16 dice = uint16(generateRandomNumber(characterID) % 100);
444     uint256 characterPower = sklToken.balanceOf(character.owner) / 10**15 + xperToken.balanceOf(character.owner);
445     uint256 adversaryPower = sklToken.balanceOf(adversary.owner) / 10**15 + xperToken.balanceOf(adversary.owner);
446     
447     if (character.value == adversary.value) {
448         base_probability = 50;
449       if (characterPower > adversaryPower) {
450         base_probability += uint16(100 / config.fightFactor());
451       } else if (adversaryPower > characterPower) {
452         base_probability -= uint16(100 / config.fightFactor());
453       }
454     } else if (character.value > adversary.value) {
455       base_probability = 100;
456       if (adversaryPower > characterPower) {
457         base_probability -= uint16((100 * adversary.value) / character.value / config.fightFactor());
458       }
459     } else if (characterPower > adversaryPower) {
460         base_probability += uint16((100 * character.value) / adversary.value / config.fightFactor());
461     }
462 
463     if (dice >= base_probability) {
464       // adversary won
465       if (adversary.characterType < BALLOON_MIN_TYPE || adversary.characterType > BALLOON_MAX_TYPE) {
466         value = hitCharacter(characterIndex, numCharacters, adversary.characterType);
467         if (value > 0) {
468           numCharacters--;
469         }
470         if (adversary.characterType >= ARCHER_MIN_TYPE && adversary.characterType <= ARCHER_MAX_TYPE) {
471           castleTreasury += value;
472         } else {
473           adversary.value += value;
474         }
475         emit NewFight(adversaryID, characterID, value, base_probability, dice);
476       } else {
477         emit NewFight(adversaryID, characterID, 0, base_probability, dice); // balloons do not hit back
478       }
479     } else {
480       // character won
481       value = hitCharacter(adversaryIndex, numCharacters, character.characterType);
482       if (value > 0) {
483         numCharacters--;
484       }
485       if (character.characterType >= ARCHER_MIN_TYPE && character.characterType <= ARCHER_MAX_TYPE) {
486         castleTreasury += value;
487       } else {
488         character.value += value;
489       }
490       if (oldest == 0) findOldest();
491       emit NewFight(characterID, adversaryID, value, base_probability, dice);
492     }
493     cooldown[characterID] = now;
494   }
495 
496   /*
497   * @param characterType
498   * @param adversaryType
499   * @return whether adversaryType is a valid type of adversary for a given character
500   */
501   function isValidAdversary(uint8 characterType, uint8 adversaryType) pure returns (bool) {
502     if (characterType >= KNIGHT_MIN_TYPE && characterType <= KNIGHT_MAX_TYPE) { // knight
503       return (adversaryType <= DRAGON_MAX_TYPE);
504     } else if (characterType >= WIZARD_MIN_TYPE && characterType <= WIZARD_MAX_TYPE) { // wizard
505       return (adversaryType < BALLOON_MIN_TYPE || adversaryType > BALLOON_MAX_TYPE);
506     } else if (characterType >= DRAGON_MIN_TYPE && characterType <= DRAGON_MAX_TYPE) { // dragon
507       return (adversaryType >= WIZARD_MIN_TYPE);
508     } else if (characterType >= ARCHER_MIN_TYPE && characterType <= ARCHER_MAX_TYPE) { // archer
509       return ((adversaryType >= BALLOON_MIN_TYPE && adversaryType <= BALLOON_MAX_TYPE)
510              || (adversaryType >= KNIGHT_MIN_TYPE && adversaryType <= KNIGHT_MAX_TYPE));
511  
512     }
513     return false;
514   }
515 
516   /**
517    * pick a random adversary.
518    * @param nonce a nonce to make sure there's not always the same adversary chosen in a single block.
519    * @return the index of a random adversary character
520    * */
521   function getRandomAdversary(uint256 nonce, uint8 characterType) internal view returns(uint16) {
522     uint16 randomIndex = uint16(generateRandomNumber(nonce) % numCharacters);
523     // use 7, 11 or 13 as step size. scales for up to 1000 characters
524     uint16 stepSize = numCharacters % 7 == 0 ? (numCharacters % 11 == 0 ? 13 : 11) : 7;
525     uint16 i = randomIndex;
526     //if the picked character is a knight or belongs to the sender, look at the character + stepSizes ahead in the array (modulo the total number)
527     //will at some point return to the startingPoint if no character is suited
528     do {
529       if (isValidAdversary(characterType, characters[ids[i]].characterType) && characters[ids[i]].owner != msg.sender) {
530         return i;
531       }
532       i = (i + stepSize) % numCharacters;
533     } while (i != randomIndex);
534 
535     return INVALID_CHARACTER_INDEX;
536   }
537 
538 
539   /**
540    * generate a random number.
541    * @param nonce a nonce to make sure there's not always the same number returned in a single block.
542    * @return the random number
543    * */
544   function generateRandomNumber(uint256 nonce) internal view returns(uint) {
545     return uint(keccak256(block.blockhash(block.number - 1), now, numCharacters, nonce));
546   }
547 
548 	/**
549    * Hits the character of the given type at the given index.
550    * Wizards can knock off two protections. Other characters can do only one.
551    * @param index the index of the character
552    * @param nchars the number of characters
553    * @return the value gained from hitting the characters (zero is the character was protected)
554    * */
555   function hitCharacter(uint16 index, uint16 nchars, uint8 characterType) internal returns(uint128 characterValue) {
556     uint32 id = ids[index];
557     uint8 knockOffProtections = 1;
558     if (characterType >= WIZARD_MIN_TYPE && characterType <= WIZARD_MAX_TYPE) {
559       knockOffProtections = 2;
560     }
561     if (protection[id] >= knockOffProtections) {
562       protection[id] = protection[id] - knockOffProtections;
563       return 0;
564     }
565     characterValue = characters[ids[index]].value;
566     nchars--;
567     replaceCharacter(index, nchars);
568   }
569 
570   /**
571    * finds the oldest character
572    * */
573   function findOldest() public {
574     uint32 newOldest = noKing;
575     for (uint16 i = 0; i < numCharacters; i++) {
576       if (ids[i] < newOldest && characters[ids[i]].characterType <= DRAGON_MAX_TYPE)
577         newOldest = ids[i];
578     }
579     oldest = newOldest;
580   }
581 
582   /**
583   * distributes the given amount among the surviving characters
584   * @param totalAmount nthe amount to distribute
585   */
586   function distribute(uint128 totalAmount) internal {
587     uint128 amount;
588     if (oldest == 0)
589       findOldest();
590     if (oldest != noKing) {
591       //pay 10% to the oldest dragon
592       characters[oldest].value += totalAmount / 10;
593       amount  = totalAmount / 10 * 9;
594     } else {
595       amount  = totalAmount;
596     }
597     //distribute the rest according to their type
598     uint128 valueSum;
599     uint8 size = ARCHER_MAX_TYPE;
600     uint128[] memory shares = new uint128[](size);
601     for (uint8 v = 0; v < size; v++) {
602       if ((v < BALLOON_MIN_TYPE || v > BALLOON_MAX_TYPE) && numCharactersXType[v] > 0) {
603            valueSum += config.values(v);
604       }
605     }
606     for (uint8 m = 0; m < size; m++) {
607       if ((v < BALLOON_MIN_TYPE || v > BALLOON_MAX_TYPE) && numCharactersXType[m] > 0) {
608         shares[m] = amount * config.values(m) / valueSum / numCharactersXType[m];
609       }
610     }
611     uint8 cType;
612     for (uint16 i = 0; i < numCharacters; i++) {
613       cType = characters[ids[i]].characterType;
614       if (cType < BALLOON_MIN_TYPE || cType > BALLOON_MAX_TYPE)
615         characters[ids[i]].value += shares[characters[ids[i]].characterType];
616     }
617   }
618 
619   /**
620    * allows the owner to collect the accumulated fees
621    * sends the given amount to the owner's address if the amount does not exceed the
622    * fees (cannot touch the players' balances) minus 100 finney (ensure that oraclize fees can be paid)
623    * @param amount the amount to be collected
624    * */
625   function collectFees(uint128 amount) public onlyOwner {
626     uint collectedFees = getFees();
627     if (amount + 100 finney < collectedFees) {
628       owner.transfer(amount);
629     }
630   }
631 
632   /**
633   * withdraw NDC and TPT tokens
634   */
635   function withdraw() public onlyOwner {
636     uint256 ndcBalance = neverdieToken.balanceOf(this);
637     assert(neverdieToken.transfer(owner, ndcBalance));
638     uint256 tptBalance = teleportToken.balanceOf(this);
639     assert(teleportToken.transfer(owner, tptBalance));
640   }
641 
642   /**
643    * pays out the players.
644    * */
645   function payOut() public onlyOwner {
646     for (uint16 i = 0; i < numCharacters; i++) {
647       characters[ids[i]].owner.transfer(characters[ids[i]].value);
648       delete characters[ids[i]];
649     }
650     delete ids;
651     numCharacters = 0;
652   }
653 
654   /**
655    * pays out the players and kills the game.
656    * */
657   function stop() public onlyOwner {
658     withdraw();
659     payOut();
660     destroy();
661   }
662 
663   /* @dev distributes castle loot among archers */
664   function distributeCastleLoot() external onlyUser {
665     require(now >= lastCastleLootDistributionTimestamp + config.castleLootDistributionThreshold(),
666             "not enough time passed since the last castle loot distribution");
667     lastCastleLootDistributionTimestamp = now;
668     uint128 luckFactor = uint128(generateRandomNumber(now) % 51);
669     if (luckFactor < 5) {
670       luckFactor = 5;
671     }
672     uint128 amount = castleTreasury * luckFactor / 100; 
673     uint128 valueSum;
674     uint128[] memory shares = new uint128[](NUMBER_OF_LEVELS);
675     uint16 archersCount;
676     uint32[] memory archers = new uint32[](numCharacters);
677 
678     uint8 cType;
679     for (uint8 i = 0; i < ids.length; i++) {
680       cType = characters[ids[i]].characterType; 
681       if ((cType >= ARCHER_MIN_TYPE && cType <= ARCHER_MAX_TYPE) && (((uint64(now) - characters[ids[i]].purchaseTimestamp) / config.eruptionThreshold()) >= 7)) {
682         valueSum += config.values(cType);
683         archers[archersCount] = ids[i];
684         archersCount++;
685       }
686     }
687 
688     if (valueSum > 0) {
689       for (uint8 j = 0; j < NUMBER_OF_LEVELS; j++) {
690           shares[j] = amount * config.values(ARCHER_MIN_TYPE + j) / valueSum;
691       }
692 
693       for (uint16 k = 0; k < archersCount; k++) {
694         characters[archers[k]].value += shares[characters[archers[k]].characterType - ARCHER_MIN_TYPE];
695       }
696       castleTreasury -= amount;
697       emit NewDistributionCastleLoot(amount);
698     } else {
699       emit NewDistributionCastleLoot(0);
700     }
701   }
702 
703   /**
704    * sell the character of the given id
705    * throws an exception in case of a knight not yet teleported to the game
706    * @param characterId the id of the character
707    * */
708   function sellCharacter(uint32 characterId) public onlyUser {
709     require(msg.sender == characters[characterId].owner,
710             "only owners can sell their characters");
711     require(characters[characterId].characterType < BALLOON_MIN_TYPE || characters[characterId].characterType > BALLOON_MAX_TYPE,
712             "balloons are not sellable");
713     require(characters[characterId].purchaseTimestamp + 1 days < now,
714             "character can be sold only 1 day after the purchase");
715     uint128 val = characters[characterId].value;
716     numCharacters--;
717     replaceCharacter(getCharacterIndex(characterId), numCharacters);
718     msg.sender.transfer(val);
719     if (oldest == 0)
720       findOldest();
721     emit NewSell(characterId, msg.sender, val);
722   }
723 
724   /**
725    * receive approval to spend some tokens.
726    * used for teleport and protection.
727    * @param sender the sender address
728    * @param value the transferred value
729    * @param tokenContract the address of the token contract
730    * @param callData the data passed by the token contract
731    * */
732   function receiveApproval(address sender, uint256 value, address tokenContract, bytes callData) public {
733     uint32 id;
734     uint256 price;
735     if (msg.sender == address(teleportToken)) {
736       id = toUint32(callData);
737       price = config.teleportPrice();
738       if (characters[id].characterType >= BALLOON_MIN_TYPE && characters[id].characterType <= WIZARD_MAX_TYPE) {
739         price *= 2;
740       }
741       require(value >= price,
742               "insufficinet amount of tokens to teleport this character");
743       assert(teleportToken.transferFrom(sender, this, price));
744       teleportCharacter(id);
745     } else if (msg.sender == address(neverdieToken)) {
746       id = toUint32(callData);
747       // user can purchase extra lifes only right after character purchaes
748       // in other words, user value should be equal the initial value
749       uint8 cType = characters[id].characterType;
750       require(characters[id].value == config.values(cType),
751               "protection could be bought only before the first fight and before the first volcano eruption");
752 
753       // calc how many lifes user can actually buy
754       // the formula is the following:
755 
756       uint256 lifePrice;
757       uint8 max;
758       if(cType <= KNIGHT_MAX_TYPE || (cType >= ARCHER_MIN_TYPE && cType <= ARCHER_MAX_TYPE)){
759         lifePrice = ((cType % NUMBER_OF_LEVELS) + 1) * config.protectionPrice();
760         max = 3;
761       } else if (cType >= BALLOON_MIN_TYPE && cType <= BALLOON_MAX_TYPE) {
762         lifePrice = (((cType+3) % NUMBER_OF_LEVELS) + 1) * config.protectionPrice() * 2;
763         max = 6;
764       } else if (cType >= WIZARD_MIN_TYPE && cType <= WIZARD_MAX_TYPE) {
765         lifePrice = (((cType+3) % NUMBER_OF_LEVELS) + 1) * config.protectionPrice() * 2;
766         max = 3;
767       }
768 
769       price = 0;
770       uint8 i = protection[id];
771       for (i; i < max && value >= price + lifePrice * (i + 1); i++) {
772         price += lifePrice * (i + 1);
773       }
774       assert(neverdieToken.transferFrom(sender, this, price));
775       protectCharacter(id, i);
776     } else {
777       revert("Should be either from Neverdie or Teleport tokens");
778     }
779   }
780 
781   /**
782    * Knights, balloons, wizards, and archers are only entering the game completely, when they are teleported to the scene
783    * @param id the character id
784    * */
785   function teleportCharacter(uint32 id) internal {
786     // ensure we do not teleport twice
787     require(teleported[id] == false,
788            "already teleported");
789     teleported[id] = true;
790     Character storage character = characters[id];
791     require(character.characterType > DRAGON_MAX_TYPE,
792            "dragons do not need to be teleported"); //this also makes calls with non-existent ids fail
793     addCharacter(id, numCharacters);
794     numCharacters++;
795     numCharactersXType[character.characterType]++;
796     emit NewTeleport(id);
797   }
798 
799   /**
800    * adds protection to a character
801    * @param id the character id
802    * @param lifes the number of protections
803    * */
804   function protectCharacter(uint32 id, uint8 lifes) internal {
805     protection[id] = lifes;
806     emit NewProtection(id, lifes);
807   }
808 
809 
810   /****************** GETTERS *************************/
811 
812   /**
813    * returns the character of the given id
814    * @param characterId the character id
815    * @return the type, value and owner of the character
816    * */
817   function getCharacter(uint32 characterId) public view returns(uint8, uint128, address) {
818     return (characters[characterId].characterType, characters[characterId].value, characters[characterId].owner);
819   }
820 
821   /**
822    * returns the index of a character of the given id
823    * @param characterId the character id
824    * @return the character id
825    * */
826   function getCharacterIndex(uint32 characterId) constant public returns(uint16) {
827     for (uint16 i = 0; i < ids.length; i++) {
828       if (ids[i] == characterId) {
829         return i;
830       }
831     }
832     revert();
833   }
834 
835   /**
836    * returns 10 characters starting from a certain indey
837    * @param startIndex the index to start from
838    * @return 4 arrays containing the ids, types, values and owners of the characters
839    * */
840   function get10Characters(uint16 startIndex) constant public returns(uint32[10] characterIds, uint8[10] types, uint128[10] values, address[10] owners) {
841     uint32 endIndex = startIndex + 10 > numCharacters ? numCharacters : startIndex + 10;
842     uint8 j = 0;
843     uint32 id;
844     for (uint16 i = startIndex; i < endIndex; i++) {
845       id = ids[i];
846       characterIds[j] = id;
847       types[j] = characters[id].characterType;
848       values[j] = characters[id].value;
849       owners[j] = characters[id].owner;
850       j++;
851     }
852 
853   }
854 
855   /**
856    * returns the number of dragons in the game
857    * @return the number of dragons
858    * */
859   function getNumDragons() constant public returns(uint16 numDragons) {
860     for (uint8 i = DRAGON_MIN_TYPE; i <= DRAGON_MAX_TYPE; i++)
861       numDragons += numCharactersXType[i];
862   }
863 
864   /**
865    * returns the number of wizards in the game
866    * @return the number of wizards
867    * */
868   function getNumWizards() constant public returns(uint16 numWizards) {
869     for (uint8 i = WIZARD_MIN_TYPE; i <= WIZARD_MAX_TYPE; i++)
870       numWizards += numCharactersXType[i];
871   }
872   /**
873    * returns the number of archers in the game
874    * @return the number of archers
875    * */
876   function getNumArchers() constant public returns(uint16 numArchers) {
877     for (uint8 i = ARCHER_MIN_TYPE; i <= ARCHER_MAX_TYPE; i++)
878       numArchers += numCharactersXType[i];
879   }
880 
881   /**
882    * returns the number of knights in the game
883    * @return the number of knights
884    * */
885   function getNumKnights() constant public returns(uint16 numKnights) {
886     for (uint8 i = KNIGHT_MIN_TYPE; i <= KNIGHT_MAX_TYPE; i++)
887       numKnights += numCharactersXType[i];
888   }
889 
890   /**
891    * @return the accumulated fees
892    * */
893   function getFees() constant public returns(uint) {
894     uint reserved = 0;
895     for (uint16 j = 0; j < numCharacters; j++)
896       reserved += characters[ids[j]].value;
897     return address(this).balance - reserved;
898   }
899 
900 
901   /************* HELPERS ****************/
902 
903   /**
904    * only works for bytes of length < 32
905    * @param b the byte input
906    * @return the uint
907    * */
908   function toUint32(bytes b) internal pure returns(uint32) {
909     bytes32 newB;
910     assembly {
911       newB: = mload(0xa0)
912     }
913     return uint32(newB);
914   }
915 }