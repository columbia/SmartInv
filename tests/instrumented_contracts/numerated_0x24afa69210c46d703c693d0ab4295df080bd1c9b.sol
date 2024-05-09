1 /**
2  * Dragonking is a blockchain game in which players may purchase dragons and knights of different levels and values.
3  * Once every period of time the volcano erupts and wipes a few of them from the board. The value of the killed characters
4  * gets distributed amongst all of the survivors. The dragon king receive a bigger share than the others.
5  * In contrast to dragons, knights need to be teleported to the battlefield first with the use of teleport tokens.
6  * Additionally, they may attack a dragon once per period.
7  * Both character types can be protected from death up to three times.
8  * Take a look at dragonking.io for more detailed information.
9  * @author: Julia Altenried, Yuriy Kashnikov
10  * */
11 
12 pragma solidity ^ 0.4.17;
13 
14 
15 /**
16 * @title Ownable
17 * @dev The Ownable contract has an owner address, and provides basic authorization control
18 * functions, this simplifies the implementation of "user permissions".
19 */
20 contract Ownable {
21  address public owner;
22 
23 
24  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25 
26 
27  /**
28   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
29   * account.
30   */
31  function Ownable() public {
32    owner = msg.sender;
33  }
34 
35  /**
36   * @dev Throws if called by any account other than the owner.
37   */
38  modifier onlyOwner() {
39    require(msg.sender == owner);
40    _;
41  }
42 
43  /**
44   * @dev Allows the current owner to transfer control of the contract to a newOwner.
45   * @param newOwner The address to transfer ownership to.
46   */
47  function transferOwnership(address newOwner) public onlyOwner {
48    require(newOwner != address(0));
49    emit OwnershipTransferred(owner, newOwner);
50    owner = newOwner;
51  }
52 
53 }
54 
55 contract mortal is Ownable{
56 
57  function mortal() public {
58  }
59 
60  function kill() internal {
61    selfdestruct(owner);
62  }
63 }
64 
65 
66 
67 contract Token {
68  function transferFrom(address _from, address _to, uint256 _value) public returns(bool success);
69 }
70 
71 contract DragonKing is mortal {
72 
73  struct Character {
74    uint8 characterType;
75    uint128 value;
76    address owner;
77  }
78 
79  /** array holding ids of the curret characters*/
80  uint32[] public ids;
81  /** the id to be given to the next character **/
82  uint32 public nextId;
83  /** the id of the oldest character */
84  uint32 public oldest;
85  /** the character belonging to a given id */
86  mapping(uint32 => Character) characters;
87  /** teleported knights **/
88  mapping(uint32 => bool) teleported;
89  /** the cost of each character type */
90  uint128[] public costs;
91  /** the value of each character type (cost - fee), so it's not necessary to compute it each time*/
92  uint128[] public values;
93  /** the fee to be paid each time an character is bought in percent*/
94  uint8 fee;
95  /** the number of dragon types **/
96  uint8 constant public numDragonTypes = 6;
97 
98 
99  /** total number of characters in the game  */
100  uint16 public numCharacters;
101  /** The maximum of characters allowed in the game */
102  uint16 public maxCharacters;
103  /** number of characters per type */
104  mapping(uint8 => uint16) public numCharactersXType;
105 
106 
107  /** the amount of time that should pass since last eruption **/
108  uint8 public eruptionThreshold;
109  /** timestampt of the last eruption event **/
110  uint256 public lastEruptionTimestamp;
111  /** how many characters to kill in %, e.g. 20 will stand for 20%, should be < 100 **/
112  uint8 public percentageToKill;
113 
114  /** knight cooldown. contains the timestamp of the earliest possible moment to start a fight */
115  mapping(uint32 => uint) public cooldown;
116  uint256 public constant CooldownThreshold = 1 days;
117 
118  /** the teleport token contract used to send knights to the game scene */
119  Token teleportToken;
120  /** the price for teleportation*/
121  uint public teleportPrice;
122  /** the neverdue token contract used to purchase protection from eruptions and fights */
123  Token neverdieToken;
124  /** the price for protection */
125  uint public protectionPrice;
126  /** tells the number of times a character is protected */
127  mapping(uint32 => uint8) public protection;
128 
129  // MODIFIER
130 
131  /** is fired when new characters are purchased (who bought how many characters of which type?) */
132  event NewPurchase(address player, uint8 characterType, uint8 amount, uint32 startId);
133  /** is fired when a player leaves the game */
134  event NewExit(address player, uint256 totalBalance, uint32[] removedCharacters);
135  /** is fired when an eruption occurs */
136  event NewEruption(uint32[] hitCharacters, uint128 value, uint128 gasCost);
137  /** is fired when a single character is sold **/
138  event NewSell(uint32 characterId, address player, uint256 value);
139  /** is fired when a knight fights a dragon **/
140  event NewFight(uint32 winnerID, uint32 loserID, uint256 value);
141  /** is fired when a knight is teleported to the field **/
142  event NewTeleport(uint32 characterId);
143  /** is fired when a protection is purchased **/
144  event NewProtection(uint32 characterId, uint8 lifes);
145 
146  /** initializes the contract parameters	 */
147  function DragonKing(address teleportTokenAddress, address neverdieTokenAddress, uint8 eruptionThresholdInHours, uint8 percentageOfCharactersToKill, uint8 characterFee, uint16[] charactersCosts) public onlyOwner {
148    fee = characterFee;
149    for (uint8 i = 0; i < charactersCosts.length * 2; i++) {
150      costs.push(uint128(charactersCosts[i % numDragonTypes]) * 1 finney);
151      values.push(costs[i] - costs[i] / 100 * fee);
152    }
153    eruptionThreshold = eruptionThresholdInHours * 60 * 60; // convert to seconds
154    percentageToKill = percentageOfCharactersToKill;
155    maxCharacters = 600;
156    nextId = 1;
157    teleportToken = Token(teleportTokenAddress);
158    teleportPrice = 1;
159    neverdieToken = Token(neverdieTokenAddress);
160    protectionPrice = 1;
161  }
162 
163  /**
164   * buys as many characters as possible with the transfered value of the given type
165   * @param characterType the type of the character
166   */
167  function addCharacters(uint8 characterType) payable public {
168    uint8 amount = uint8(msg.value / costs[characterType]);
169    uint16 nchars = numCharacters;
170    if (characterType >= costs.length || msg.value < costs[characterType] || nchars + amount > maxCharacters) revert();
171    //if type exists, enough ether was transferred and there are less than maxCharacters characters in the game
172    bool isDragon = characterType < numDragonTypes;
173    uint32 nid = nextId;
174    if (isDragon) {
175      //dragons enter the game directly
176      for (uint8 i = 0; i < amount; i++) {
177        addCharacter(nid + i, nchars + i);
178        characters[nid + i] = Character(characterType, values[characterType], msg.sender);
179      }
180      numCharactersXType[characterType] += amount;
181      numCharacters += amount;
182    }
183    else {
184      for (uint8 j = 0; j < amount; j++) {
185        characters[nid + j] = Character(characterType, values[characterType], msg.sender);
186      }
187    }
188    nextId = nid + amount;
189    NewPurchase(msg.sender, characterType, amount, nid);
190  }
191 
192 
193 
194  /**
195   * adds a single dragon of the given type to the ids array, which is used to iterate over all characters
196   * @param nId the id the character is about to receive
197   * @param nchars the number of characters currently in the game
198   */
199  function addCharacter(uint32 nId, uint16 nchars) internal {
200    if (nchars < ids.length)
201      ids[nchars] = nId;
202    else
203      ids.push(nId);
204  }
205 
206  /**
207   * leave the game.
208   * pays out the sender's balance and removes him and his characters from the game
209   * */
210  function exit() public {
211    uint32[] memory removed = new uint32[](50);
212    uint8 count;
213    uint32 lastId;
214    uint playerBalance;
215    uint16 nchars = numCharacters;
216    for (uint16 i = 0; i < nchars; i++) {
217      if (characters[ids[i]].owner == msg.sender) {
218        //first delete all characters at the end of the array
219        while (nchars > 0 && characters[ids[nchars - 1]].owner == msg.sender) {
220          nchars--;
221          lastId = ids[nchars];
222          numCharactersXType[characters[lastId].characterType]--;
223          playerBalance += characters[lastId].value;
224          removed[count] = lastId;
225          count++;
226          if (lastId == oldest) oldest = 0;
227          delete characters[lastId];
228        }
229        //if the last character does not belong to the player, replace the players character by this last one
230        if (nchars > i + 1) {
231          playerBalance += characters[ids[i]].value;
232          removed[count] = ids[i];
233          count++;
234          nchars--;
235          replaceCharacter(i, nchars);
236        }
237      }
238    }
239    numCharacters = nchars;
240    NewExit(msg.sender, playerBalance, removed); //fire the event to notify the client
241    msg.sender.transfer(playerBalance);
242  }
243 
244  /**
245   * Replaces the character with the given id with the last character in the array
246   * @param index the index of the character in the id array
247   * @param nchars the number of characters
248   * */
249  function replaceCharacter(uint16 index, uint16 nchars) internal {
250    uint32 characterId = ids[index];
251    numCharactersXType[characters[characterId].characterType]--;
252    if (characterId == oldest) oldest = 0;
253    delete characters[characterId];
254    ids[index] = ids[nchars];
255    delete ids[nchars];
256  }
257 
258  /**
259   * The volcano eruption can be triggered by anybody but only if enough time has passed since the last eription.
260   * The volcano hits up to a certain percentage of characters, but at least one.
261   * The percantage is specified in 'percentageToKill'
262   * */
263 
264  function triggerVolcanoEruption() public {
265    require(now >= lastEruptionTimestamp + eruptionThreshold);
266    require(numCharacters>0);
267    lastEruptionTimestamp = now;
268    uint128 pot;
269    uint128 value;
270    uint16 random;
271    uint32 nextHitId;
272    uint16 nchars = numCharacters;
273    uint32 howmany = nchars * percentageToKill / 100;
274    uint128 neededGas = 80000 + 10000 * uint32(nchars);
275    if(howmany == 0) howmany = 1;//hit at least 1
276    uint32[] memory hitCharacters = new uint32[](howmany);
277    for (uint8 i = 0; i < howmany; i++) {
278      random = uint16(generateRandomNumber(lastEruptionTimestamp + i) % nchars);
279      nextHitId = ids[random];
280      hitCharacters[i] = nextHitId;
281      value = hitCharacter(random, nchars);
282      if (value > 0) {
283        nchars--;
284      }
285      pot += value;
286    }
287    uint128 gasCost = uint128(neededGas * tx.gasprice);
288    numCharacters = nchars;
289    if (pot > gasCost){
290      distribute(pot - gasCost); //distribute the pot minus the oraclize gas costs
291      NewEruption(hitCharacters, pot - gasCost, gasCost);
292    }
293    else
294      NewEruption(hitCharacters, 0, gasCost);
295  }
296 
297 
298  /**
299   * A knight may attack a dragon, but not choose which one.
300   * The creature with the higher level wins. The level is determined by characterType % numDragonTypes.
301   * The value of the loser is transfered to the winner. In case of a the same level, the winner is chosen randomly.
302   * @param knightID the ID of the knight to perfrom the attack
303   * @param knightIndex the index of the knight in the ids-array. Just needed to save gas costs.
304   *					  In case it's unknown or incorrect, the index is looked up in the array.
305   * */
306  function fight(uint32 knightID, uint16 knightIndex) public {
307    if (knightID != ids[knightIndex])
308      knightID = getCharacterIndex(knightID);
309    Character storage knight = characters[knightID];
310    require(cooldown[knightID] + CooldownThreshold <= now);
311    require(knight.owner == msg.sender);
312    require(knight.characterType >= numDragonTypes);
313    uint16 dragonIndex = getRandomDragon(knightID);
314    assert(dragonIndex < maxCharacters);
315    uint32 dragonID = ids[dragonIndex];
316    Character storage dragon = characters[dragonID];
317    uint16 tieBreaker = uint16(now % 2);
318    uint128 value;
319    if (knight.characterType - numDragonTypes > dragon.characterType || (knight.characterType - numDragonTypes == dragon.characterType && tieBreaker == 0)) {
320      value = hitCharacter(dragonIndex, numCharacters);
321      if (value > 0) {
322        numCharacters--;
323      }
324      knight.value += value;
325      cooldown[knightID] = now;
326      if (oldest == 0) findOldest();
327      NewFight(knightID, dragonID, value);
328    }
329    else {
330      value = hitCharacter(knightIndex, numCharacters);
331      if (value > 0) {
332        numCharacters--;
333      }
334      dragon.value += value;
335      NewFight(dragonID, knightID, value);
336    }
337  }
338 
339  /**
340   * pick a random dragon.
341   * @param nonce a nonce to make sure there's not always the same dragon chosen in a single block.
342   * @return the index of a random dragon
343   * */
344  function getRandomDragon(uint256 nonce) internal view returns(uint16) {
345    uint16 randomIndex = uint16(generateRandomNumber(nonce) % numCharacters);
346    //use 7, 11 or 13 as step size. scales for up to 1000 characters
347    uint16 stepSize = numCharacters % 7 == 0 ? (numCharacters % 11 == 0 ? 13 : 11) : 7;
348    uint16 i = randomIndex;
349    //if the picked character is a knight or belongs to the sender, look at the character + stepSizes ahead in the array (modulo the total number)
350    //will at some point return to the startingPoint if no character is suited
351    do {
352      if (characters[ids[i]].characterType < numDragonTypes && characters[ids[i]].owner != msg.sender) return i;
353      i = (i + stepSize) % numCharacters;
354    } while (i != randomIndex);
355    return maxCharacters + 1; //there is none
356  }
357 
358  /**
359   * generate a random number.
360   * @param nonce a nonce to make sure there's not always the same number returned in a single block.
361   * @return the random number
362   * */
363  function generateRandomNumber(uint256 nonce) internal view returns(uint) {
364    return uint(keccak256(block.blockhash(block.number - 1), now, numCharacters, nonce));
365  }
366 
367  /**
368   * Hits the character of the given type at the given index.
369   * @param index the index of the character
370   * @param nchars the number of characters
371   * @return the value gained from hitting the characters (zero is the character was protected)
372   * */
373  function hitCharacter(uint16 index, uint16 nchars) internal returns(uint128 characterValue) {
374    uint32 id = ids[index];
375    if (protection[id] > 0) {
376      protection[id]--;
377      return 0;
378    }
379    characterValue = characters[ids[index]].value;
380    nchars--;
381    replaceCharacter(index, nchars);
382  }
383 
384  /**
385   * finds the oldest character
386   * */
387  function findOldest() public {
388    oldest = ids[0];
389    for (uint16 i = 1; i < numCharacters; i++) {
390      if (ids[i] < oldest && characters[ids[i]].characterType < numDragonTypes) //the oldest character has the lowest id -todo
391        oldest = ids[i];
392    }
393  }
394 
395  /**
396  * distributes the given amount among the surviving characters
397  * @param totalAmount nthe amount to distribute
398  */
399  function distribute(uint128 totalAmount) internal {
400    //pay 10% to the oldest dragon
401    if (oldest == 0)
402      findOldest();
403    characters[oldest].value += totalAmount / 10;
404    uint128 amount = totalAmount / 10 * 9;
405    //distribute the rest according to their type
406    uint128 valueSum;
407    uint128[] memory shares = new uint128[](values.length);
408    for (uint8 v = 0; v < values.length; v++) {
409      if (numCharactersXType[v] > 0) valueSum += values[v];
410    }
411    for (uint8 m = 0; m < values.length; m++) {
412      if (numCharactersXType[m] > 0)
413        shares[m] = amount * values[m] / valueSum / numCharactersXType[m];
414    }
415    for (uint16 i = 0; i < numCharacters; i++) {
416      characters[ids[i]].value += shares[characters[ids[i]].characterType];
417    }
418  }
419 
420  /**
421   * allows the owner to collect the accumulated fees
422   * sends the given amount to the owner's address if the amount does not exceed the
423   * fees (cannot touch the players' balances) minus 100 finney (ensure that oraclize fees can be paid)
424   * @param amount the amount to be collected
425   * */
426  function collectFees(uint128 amount) public onlyOwner {
427    uint collectedFees = getFees();
428    if (amount + 100 finney < collectedFees) {
429      owner.transfer(amount);
430    }
431  }
432 
433  /**
434   * pays out the players and kills the game.
435   * */
436  function stop() public onlyOwner {
437    for (uint16 i = 0; i < numCharacters; i++) {
438      if (!characters[ids[i]].owner.send(characters[ids[i]].value)) revert();
439    }
440    kill();
441  }
442 
443  /**
444   * sell the character of the given id
445   * throws an exception in case of a knight not yet teleported to the game
446   * @param characterId the id of the character
447   * */
448  function sellCharacter(uint32 characterId) public {
449    require(msg.sender == characters[characterId].owner);
450    uint128 val = characters[characterId].value;
451    numCharacters--;
452    replaceCharacter(getCharacterIndex(characterId), numCharacters);
453    msg.sender.transfer(val);
454    NewSell(characterId, msg.sender, val);
455  }
456 
457  /**
458   * receive approval to spend some tokens.
459   * used for teleport and protection.
460   * @param sender the sender address
461   * @param value the transferred value
462   * @param tokenContract the address of the token contract
463   * @param callData the data passed by the token contract
464   * */
465  function receiveApproval(address sender, uint256 value, address tokenContract, bytes callData) public {
466    if (msg.sender == address(teleportToken)) {
467      require(value >= teleportPrice);
468      assert(teleportToken.transferFrom(sender, this, teleportPrice));
469      teleportKnight(toUint32(callData));
470    }
471    else if (msg.sender == address(neverdieToken)) {
472      uint32 id = toUint32(callData);
473      // user can purchase extra lifes only right after character purchaes
474      // in other words, user value should be equal the initial value
475      require(characters[id].value == values[characters[id].characterType]);
476 
477      // calc how many lifes user can actually buy
478      // the formula is the following:
479      uint256 lifePrice = ((characters[id].characterType % numDragonTypes) + 1) * protectionPrice;
480      uint256 price = 0;
481      uint8 i = protection[id];
482      require(i <= 3);
483      for (i; i < 3 && value >= price + lifePrice * (i + 1); i++) {
484        price += lifePrice * (i + 1);
485      }
486      assert(neverdieToken.transferFrom(sender, this, price));
487      protectCharacter(id, i);
488    }
489    else
490      revert();
491  }
492 
493  /**
494   * knights are only entering the game completely, when they are teleported to the scene
495   * @param id the character id
496   * */
497  function teleportKnight(uint32 id) internal {
498    // ensure we do not teleport twice
499    require(teleported[id] == false);
500    teleported[id] = true;
501    Character storage knight = characters[id];
502    assert(knight.characterType >= numDragonTypes); //this also makes calls with non-existent ids fail
503    addCharacter(id, numCharacters);
504    numCharacters++;
505    numCharactersXType[knight.characterType]++;
506    NewTeleport(id);
507  }
508 
509  /**
510   * adds protection to a character
511   * @param id the character id
512   * @param lifes the number of protections
513   * */
514  function protectCharacter(uint32 id, uint8 lifes) internal {
515    protection[id] = lifes;
516    NewProtection(id, lifes);
517  }
518 
519 
520  /****************** GETTERS *************************/
521 
522  /**
523   * returns the character of the given id
524   * @param characterId the character id
525   * @return the type, value and owner of the character
526   * */
527  function getCharacter(uint32 characterId) constant public returns(uint8, uint128, address) {
528    return (characters[characterId].characterType, characters[characterId].value, characters[characterId].owner);
529  }
530 
531  /**
532   * returns the index of a character of the given id
533   * @param characterId the character id
534   * @return the character id
535   * */
536  function getCharacterIndex(uint32 characterId) constant public returns(uint16) {
537    for (uint16 i = 0; i < ids.length; i++) {
538      if (ids[i] == characterId) {
539        return i;
540      }
541    }
542    revert();
543  }
544 
545  /**
546   * returns 10 characters starting from a certain indey
547   * @param startIndex the index to start from
548   * @return 4 arrays containing the ids, types, values and owners of the characters
549   * */
550  function get10Characters(uint16 startIndex) constant public returns(uint32[10] characterIds, uint8[10] types, uint128[10] values, address[10] owners) {
551    uint32 endIndex = startIndex + 10 > numCharacters ? numCharacters : startIndex + 10;
552    uint8 j = 0;
553    uint32 id;
554    for (uint16 i = startIndex; i < endIndex; i++) {
555      id = ids[i];
556      characterIds[j] = id;
557      types[j] = characters[id].characterType;
558      values[j] = characters[id].value;
559      owners[j] = characters[id].owner;
560      j++;
561    }
562 
563  }
564 
565  /**
566   * returns the number of dragons in the game
567   * @return the number of dragons
568   * */
569  function getNumDragons() constant public returns(uint16 numDragons) {
570    for (uint8 i = 0; i < numDragonTypes; i++)
571      numDragons += numCharactersXType[i];
572  }
573 
574  /**
575   * returns the number of knights in the game
576   * @return the number of knights
577   * */
578  function getNumKnights() constant public returns(uint16 numKnights) {
579    for (uint8 i = numDragonTypes; i < costs.length; i++)
580      numKnights += numCharactersXType[i];
581  }
582 
583  /**
584   * @return the accumulated fees
585   * */
586  function getFees() constant public returns(uint) {
587    uint reserved = 0;
588    for (uint16 j = 0; j < numCharacters; j++)
589      reserved += characters[ids[j]].value;
590    return address(this).balance - reserved;
591  }
592 
593 
594  /****************** SETTERS *************************/
595 
596  /**
597   * sets the prices of the character types
598   * @param prices the prices in finney
599   * */
600  function setPrices(uint16[] prices) public onlyOwner {
601    for (uint8 i = 0; i < prices.length * 2; i++) {
602      costs[i] = uint128(prices[i % numDragonTypes]) * 1 finney;
603      values[i] = costs[i] - costs[i] / 100 * fee;
604    }
605  }
606 
607  /**
608   * sets the fee to charge on each purchase
609   * @param _fee the new fee
610   * */
611  function setFee(uint8 _fee) public onlyOwner {
612    fee = _fee;
613  }
614 
615  /**
616   * sets the maximum number of characters allowed in the game
617   * @param number the new maximum
618   * */
619  function setMaxCharacters(uint16 number) public onlyOwner {
620    maxCharacters = number;
621  }
622 
623  /**
624   * sets the teleport price
625   * @param price the price in tokens
626   * */
627  function setTeleportPrice(uint price) public onlyOwner {
628    teleportPrice = price;
629  }
630 
631  /**
632   * sets the protection price
633   * @param price the price in tokens
634   * */
635  function setProtectionPrice(uint price) public onlyOwner {
636    protectionPrice = price;
637  }
638 
639 
640  /************* HELPERS ****************/
641 
642  /**
643   * only works for bytes of length < 32
644   * @param b the byte input
645   * @return the uint
646   * */
647  function toUint32(bytes b) internal pure returns(uint32) {
648    bytes32 newB;
649    assembly {
650      newB: = mload(0x80)
651    }
652    return uint32(newB);
653  }
654 
655 }