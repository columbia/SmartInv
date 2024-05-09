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
19 pragma solidity ^0.4.17;
20 
21 contract Ownable {
22   address public owner;
23 
24 
25   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26 
27 
28   /**
29    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
30    * account.
31    */
32   function Ownable() public {
33     owner = msg.sender;
34   }
35 
36 
37   /**
38    * @dev Throws if called by any account other than the owner.
39    */
40   modifier onlyOwner() {
41     require(msg.sender == owner);
42     _;
43   }
44 
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address newOwner) public onlyOwner {
51     require(newOwner != address(0));
52     OwnershipTransferred(owner, newOwner);
53     owner = newOwner;
54   }
55 
56 }
57 
58 contract mortal is Ownable {
59 	address owner;
60 
61 	function mortal() {
62 		owner = msg.sender;
63 	}
64 
65 	function kill() internal {
66 		suicide(owner);
67 	}
68 }
69 
70 contract Token {
71 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
72 	function transfer(address _to, uint256 _value) public returns (bool success) {}
73 	function balanceOf(address who) public view returns (uint256);
74 }
75 
76 contract DragonKing is mortal {
77 
78 	struct Character {
79 		uint8 characterType;
80 		uint128 value;
81 		address owner;
82 		uint64 purchaseTimestamp;
83 	}
84 
85 	/** array holding ids of the curret characters*/
86 	uint32[] public ids;
87 	/** the id to be given to the next character **/
88 	uint32 public nextId;
89 	/** the id of the oldest character */
90 	uint32 public oldest;
91 	/** the character belonging to a given id */
92 	mapping(uint32 => Character) characters;
93 	/** teleported knights **/
94 	mapping(uint32 => bool) teleported;
95 	/** the cost of each character type */
96 	uint128[] public costs;
97 	/** the value of each character type (cost - fee), so it's not necessary to compute it each time*/
98 	uint128[] public values;
99 	/** the fee to be paid each time an character is bought in percent*/
100 	uint8 fee;
101 	/** the number of dragon types **/
102 	uint8 constant public numDragonTypes = 6;
103 	/* the number of balloons types */
104 	uint8 constant public numOfBalloonsTypes = 3;
105 	/** constant used to signal that there is no King at the moment **/
106 	uint32 constant public noKing = ~uint32(0);
107 
108 	/** total number of characters in the game  */
109 	uint16 public numCharacters;
110 	/** The maximum of characters allowed in the game */
111 	uint16 public maxCharacters;
112 	/** number of characters per type */
113 	mapping(uint8 => uint16) public numCharactersXType;
114 
115 
116 	/** the amount of time that should pass since last eruption **/
117 	uint public eruptionThreshold;
118 	/** timestampt of the last eruption event **/
119 	uint256 public lastEruptionTimestamp;
120 	/** how many characters to kill in %, e.g. 20 will stand for 20%, should be < 100 **/
121 	uint8 public percentageToKill;
122 
123 	/** knight cooldown. contains the timestamp of the earliest possible moment to start a fight */
124 	mapping(uint32 => uint) public cooldown;
125 	uint256 public constant CooldownThreshold = 1 days;
126 	/** fight factor, used to compute extra probability in fight **/
127 	uint8 public fightFactor;
128 
129 	/** the teleport token contract used to send knights to the game scene */
130 	Token teleportToken;
131 	/** the price for teleportation*/
132 	uint public teleportPrice;
133 	/** the neverdue token contract used to purchase protection from eruptions and fights */
134 	Token neverdieToken;
135 	/** the price for protection */
136 	uint public protectionPrice;
137 	/** tells the number of times a character is protected */
138 	mapping(uint32 => uint8) public protection;
139 
140 	/** the SKL token contract **/
141 	Token sklToken;
142 	/** the XP token contract **/
143 	Token xperToken;
144 
145 	// EVENTS
146 
147 	/** is fired when new characters are purchased (who bought how many characters of which type?) */
148 	event NewPurchase(address player, uint8 characterType, uint16 amount, uint32 startId);
149 	/** is fired when a player leaves the game */
150 	event NewExit(address player, uint256 totalBalance, uint32[] removedCharacters);
151 	/** is fired when an eruption occurs */
152 	event NewEruption(uint32[] hitCharacters, uint128 value, uint128 gasCost);
153 	/** is fired when a single character is sold **/
154 	event NewSell(uint32 characterId, address player, uint256 value);
155 	/** is fired when a knight fights a dragon **/
156 	event NewFight(uint32 winnerID, uint32 loserID, uint256 value, uint16 probability, uint16 dice);
157 	/** is fired when a knight is teleported to the field **/
158 	event NewTeleport(uint32 characterId);
159 	/** is fired when a protection is purchased **/
160 	event NewProtection(uint32 characterId, uint8 lifes);
161 
162 	/** initializes the contract parameters	 */
163 	function DragonKing(address teleportTokenAddress,
164 											address neverdieTokenAddress,
165 											address sklTokenAddress,
166 											address xperTokenAddress,
167 											uint8 eruptionThresholdInHours,
168 											uint8 percentageOfCharactersToKill,
169 											uint8 characterFee,
170 											uint16[] charactersCosts,
171 											uint16[] balloonsCosts) public onlyOwner {
172 		fee = characterFee;
173 		for (uint8 i = 0; i < charactersCosts.length * 2; i++) {
174 			costs.push(uint128(charactersCosts[i % numDragonTypes]) * 1 finney);
175 			values.push(costs[i] - costs[i] / 100 * fee);
176 		}
177 		uint256 balloonsIndex = charactersCosts.length * 2;
178 		for (uint8 j = 0; j < balloonsCosts.length; j++) {
179 			costs.push(uint128(balloonsCosts[j]) * 1 finney);
180 			values.push(costs[balloonsIndex + j] - costs[balloonsIndex + j] / 100 * fee);
181 		}
182 		eruptionThreshold = eruptionThresholdInHours * 60 * 60; // convert to seconds
183 		percentageToKill = percentageOfCharactersToKill;
184 		maxCharacters = 600;
185 		nextId = 1;
186 		teleportToken = Token(teleportTokenAddress);
187 		teleportPrice = 1000000000000000000;
188 		neverdieToken = Token(neverdieTokenAddress);
189 		protectionPrice = 1000000000000000000;
190 		fightFactor = 4;
191 		sklToken = Token(sklTokenAddress);
192 		xperToken = Token(xperTokenAddress);
193 	}
194 
195 	/**
196 	 * buys as many characters as possible with the transfered value of the given type
197 	 * @param characterType the type of the character
198 	 */
199 	function addCharacters(uint8 characterType) payable public {
200 		require(tx.origin == msg.sender);
201 		uint16 amount = uint16(msg.value / costs[characterType]);
202 		uint16 nchars = numCharacters;
203 		if (characterType >= costs.length || msg.value < costs[characterType] || nchars + amount > maxCharacters) revert();
204 		uint32 nid = nextId;
205 		//if type exists, enough ether was transferred and there are less than maxCharacters characters in the game
206 		if (characterType < numDragonTypes) {
207 			//dragons enter the game directly
208 			if (oldest == 0 || oldest == noKing)
209 				oldest = nid;
210 			for (uint8 i = 0; i < amount; i++) {
211 				addCharacter(nid + i, nchars + i);
212 				characters[nid + i] = Character(characterType, values[characterType], msg.sender, uint64(now));
213 			}
214 			numCharactersXType[characterType] += amount;
215 			numCharacters += amount;
216 		}
217 		else {
218 			// to enter game knights should be teleported later
219 			for (uint8 j = 0; j < amount; j++) {
220 				characters[nid + j] = Character(characterType, values[characterType], msg.sender, uint64(now));
221 			}
222 		}
223 		nextId = nid + amount;
224 		NewPurchase(msg.sender, characterType, amount, nid);
225 	}
226 
227 
228 
229 	/**
230 	 * adds a single dragon of the given type to the ids array, which is used to iterate over all characters
231 	 * @param nId the id the character is about to receive
232 	 * @param nchars the number of characters currently in the game
233 	 */
234 	function addCharacter(uint32 nId, uint16 nchars) internal {
235 		if (nchars < ids.length)
236 			ids[nchars] = nId;
237 		else
238 			ids.push(nId);
239 	}
240 
241 	/**
242 	 * leave the game.
243 	 * pays out the sender's balance and removes him and his characters from the game
244 	 * */
245 	function exit() public {
246 		uint32[] memory removed = new uint32[](50);
247 		uint8 count;
248 		uint32 lastId;
249 		uint playerBalance;
250 		uint16 nchars = numCharacters;
251 		for (uint16 i = 0; i < nchars; i++) {
252 			if (characters[ids[i]].owner == msg.sender 
253 					&& characters[ids[i]].purchaseTimestamp + 1 days < now
254 					&& characters[ids[i]].characterType < 2*numDragonTypes) {
255 				//first delete all characters at the end of the array
256 				while (nchars > 0 
257 						&& characters[ids[nchars - 1]].owner == msg.sender 
258 						&& characters[ids[nchars - 1]].purchaseTimestamp + 1 days < now
259 						&& characters[ids[nchars - 1]].characterType < 2*numDragonTypes) {
260 					nchars--;
261 					lastId = ids[nchars];
262 					numCharactersXType[characters[lastId].characterType]--;
263 					playerBalance += characters[lastId].value;
264 					removed[count] = lastId;
265 					count++;
266 					if (lastId == oldest) oldest = 0;
267 					delete characters[lastId];
268 				}
269 				//replace the players character by the last one
270 				if (nchars > i + 1) {
271 					playerBalance += characters[ids[i]].value;
272 					removed[count] = ids[i];
273 					count++;
274 					nchars--;
275 					replaceCharacter(i, nchars);
276 				}
277 			}
278 		}
279 		numCharacters = nchars;
280 		NewExit(msg.sender, playerBalance, removed); //fire the event to notify the client
281 		msg.sender.transfer(playerBalance);
282 		if (oldest == 0)
283 			findOldest();
284 	}
285 
286 	/**
287 	 * Replaces the character with the given id with the last character in the array
288 	 * @param index the index of the character in the id array
289 	 * @param nchars the number of characters
290 	 * */
291 	function replaceCharacter(uint16 index, uint16 nchars) internal {
292 		uint32 characterId = ids[index];
293 		numCharactersXType[characters[characterId].characterType]--;
294 		if (characterId == oldest) oldest = 0;
295 		delete characters[characterId];
296 		ids[index] = ids[nchars];
297 		delete ids[nchars];
298 	}
299 
300 	/**
301 	 * The volcano eruption can be triggered by anybody but only if enough time has passed since the last eription.
302 	 * The volcano hits up to a certain percentage of characters, but at least one.
303 	 * The percantage is specified in 'percentageToKill'
304 	 * */
305 
306 	function triggerVolcanoEruption() public {
307 		require(now >= lastEruptionTimestamp + eruptionThreshold);
308 		require(numCharacters>0);
309 		lastEruptionTimestamp = now;
310 		uint128 pot;
311 		uint128 value;
312 		uint16 random;
313 		uint32 nextHitId;
314 		uint16 nchars = numCharacters;
315 		uint32 howmany = nchars * percentageToKill / 100;
316 		uint128 neededGas = 80000 + 10000 * uint32(nchars);
317 		if(howmany == 0) howmany = 1;//hit at least 1
318 		uint32[] memory hitCharacters = new uint32[](howmany);
319 		for (uint8 i = 0; i < howmany; i++) {
320 			random = uint16(generateRandomNumber(lastEruptionTimestamp + i) % nchars);
321 			nextHitId = ids[random];
322 			hitCharacters[i] = nextHitId;
323 			value = hitCharacter(random, nchars);
324 			if (value > 0) {
325 				nchars--;
326 			}
327 			pot += value;
328 		}
329 		uint128 gasCost = uint128(neededGas * tx.gasprice);
330 		numCharacters = nchars;
331 		if (pot > gasCost){
332 			distribute(pot - gasCost); //distribute the pot minus the oraclize gas costs
333 			NewEruption(hitCharacters, pot - gasCost, gasCost);
334 		}
335 		else
336 			NewEruption(hitCharacters, 0, gasCost);
337 	}
338 
339 	/**
340 	 * A knight may attack a dragon, but not choose which one.
341 	 * The value of the loser is transfered to the winner.
342 	 * @param knightID the ID of the knight to perfrom the attack
343 	 * @param knightIndex the index of the knight in the ids-array. Just needed to save gas costs.
344 	 *						In case it's unknown or incorrect, the index is looked up in the array.
345 	 * */
346 	function fight(uint32 knightID, uint16 knightIndex) public {
347 		require(tx.origin == msg.sender);
348 		if (knightID != ids[knightIndex])
349 			knightIndex = getCharacterIndex(knightID);
350 		Character storage knight = characters[knightID];
351 		require(cooldown[knightID] + CooldownThreshold <= now);
352 		require(knight.owner == msg.sender);
353 		require(knight.characterType < 2*numDragonTypes); // knight is not a balloon
354 		require(knight.characterType >= numDragonTypes);
355 		uint16 dragonIndex = getRandomDragon(knightID);
356 		assert(dragonIndex < maxCharacters);
357 		uint32 dragonID = ids[dragonIndex];
358 		Character storage dragon = characters[dragonID];
359 		uint128 value;
360 		uint16 base_probability;
361 		uint16 dice = uint16(generateRandomNumber(knightID) % 100);
362 		uint256 knightPower = sklToken.balanceOf(knight.owner) / 10**15 + xperToken.balanceOf(knight.owner);
363 		uint256 dragonPower = sklToken.balanceOf(dragon.owner) / 10**15 + xperToken.balanceOf(dragon.owner);
364 		if (knight.value == dragon.value) {
365 				base_probability = 50;
366 			if (knightPower > dragonPower) {
367 				base_probability += uint16(100 / fightFactor);
368 			} else if (dragonPower > knightPower) {
369 				base_probability -= uint16(100 / fightFactor);
370 			}
371 		} else if (knight.value > dragon.value) {
372 			base_probability = 100;
373 			if (dragonPower > knightPower) {
374 				base_probability -= uint16((100 * dragon.value) / knight.value / fightFactor);
375 			}
376 		} else if (knightPower > dragonPower) {
377 				base_probability += uint16((100 * knight.value) / dragon.value / fightFactor);
378 		}
379   
380 		cooldown[knightID] = now;
381 		if (dice >= base_probability) {
382 			// dragon won
383 			value = hitCharacter(knightIndex, numCharacters);
384 			if (value > 0) {
385 				numCharacters--;
386 			}
387 			dragon.value += value;
388 			NewFight(dragonID, knightID, value, base_probability, dice);
389 		} else {
390 			// knight won
391 			value = hitCharacter(dragonIndex, numCharacters);
392 			if (value > 0) {
393 				numCharacters--;
394 			}
395 			knight.value += value;
396 			if (oldest == 0) findOldest();
397 			NewFight(knightID, dragonID, value, base_probability, dice);
398 		}
399 	}
400 
401 	/**
402 	 * pick a random dragon.
403 	 * @param nonce a nonce to make sure there's not always the same dragon chosen in a single block.
404 	 * @return the index of a random dragon
405 	 * */
406 	function getRandomDragon(uint256 nonce) internal view returns(uint16) {
407 		uint16 randomIndex = uint16(generateRandomNumber(nonce) % numCharacters);
408 		//use 7, 11 or 13 as step size. scales for up to 1000 characters
409 		uint16 stepSize = numCharacters % 7 == 0 ? (numCharacters % 11 == 0 ? 13 : 11) : 7;
410 		uint16 i = randomIndex;
411 		//if the picked character is a knight or belongs to the sender, look at the character + stepSizes ahead in the array (modulo the total number)
412 		//will at some point return to the startingPoint if no character is suited
413 		do {
414 			if (characters[ids[i]].characterType < numDragonTypes && characters[ids[i]].owner != msg.sender) return i;
415 			i = (i + stepSize) % numCharacters;
416 		} while (i != randomIndex);
417 		return maxCharacters + 1; //there is none
418 	}
419 
420 	/**
421 	 * generate a random number.
422 	 * @param nonce a nonce to make sure there's not always the same number returned in a single block.
423 	 * @return the random number
424 	 * */
425 	function generateRandomNumber(uint256 nonce) internal view returns(uint) {
426 		return uint(keccak256(block.blockhash(block.number - 1), now, numCharacters, nonce));
427 	}
428 
429 	/**
430 	 * Hits the character of the given type at the given index.
431 	 * @param index the index of the character
432 	 * @param nchars the number of characters
433 	 * @return the value gained from hitting the characters (zero is the character was protected)
434 	 * */
435 	function hitCharacter(uint16 index, uint16 nchars) internal returns(uint128 characterValue) {
436 		uint32 id = ids[index];
437 		if (protection[id] > 0) {
438 			protection[id]--;
439 			return 0;
440 		}
441 		characterValue = characters[ids[index]].value;
442 		nchars--;
443 		replaceCharacter(index, nchars);
444 	}
445 
446 	/**
447 	 * finds the oldest character
448 	 * */
449 	function findOldest() public {
450 		uint32 newOldest = noKing;
451 		for (uint16 i = 0; i < numCharacters; i++) {
452 			if (ids[i] < newOldest && characters[ids[i]].characterType < numDragonTypes)
453 				newOldest = ids[i];
454 		}
455 		oldest = newOldest;
456 	}
457 
458 	/**
459 	* distributes the given amount among the surviving characters
460 	* @param totalAmount nthe amount to distribute
461 	*/
462 	function distribute(uint128 totalAmount) internal {
463 		uint128 amount;
464 		if (oldest == 0)
465 			findOldest();
466 		if (oldest != noKing) {
467 			//pay 10% to the oldest dragon
468 			characters[oldest].value += totalAmount / 10;
469 			amount	= totalAmount / 10 * 9;
470 		} else {
471 			amount	= totalAmount;
472 		}
473 		//distribute the rest according to their type
474 		uint128 valueSum;
475 		uint8 size = 2 * numDragonTypes;
476 		uint128[] memory shares = new uint128[](size);
477 		for (uint8 v = 0; v < size; v++) {
478 			if (numCharactersXType[v] > 0) valueSum += values[v];
479 		}
480 		for (uint8 m = 0; m < size; m++) {
481 			if (numCharactersXType[m] > 0)
482 				shares[m] = amount * values[m] / valueSum / numCharactersXType[m];
483 		}
484 		uint8 cType;
485 		for (uint16 i = 0; i < numCharacters; i++) {
486 			cType = characters[ids[i]].characterType;
487 			if(cType < size)
488 				characters[ids[i]].value += shares[characters[ids[i]].characterType];
489 		}
490 	}
491 
492 	/**
493 	 * allows the owner to collect the accumulated fees
494 	 * sends the given amount to the owner's address if the amount does not exceed the
495 	 * fees (cannot touch the players' balances) minus 100 finney (ensure that oraclize fees can be paid)
496 	 * @param amount the amount to be collected
497 	 * */
498 	function collectFees(uint128 amount) public onlyOwner {
499 		uint collectedFees = getFees();
500 		if (amount + 100 finney < collectedFees) {
501 			owner.transfer(amount);
502 		}
503 	}
504 
505 	/**
506 	* withdraw NDC and TPT tokens
507 	*/
508 	function withdraw() public onlyOwner {
509 		uint256 ndcBalance = neverdieToken.balanceOf(this);
510 		assert(neverdieToken.transfer(owner, ndcBalance));
511 		uint256 tptBalance = teleportToken.balanceOf(this);
512 		assert(teleportToken.transfer(owner, tptBalance));
513 	}
514 
515 	/**
516 	 * pays out the players.
517 	 * */
518 	function payOut() public onlyOwner {
519 		for (uint16 i = 0; i < numCharacters; i++) {
520 			characters[ids[i]].owner.transfer(characters[ids[i]].value);
521 			delete characters[ids[i]];
522 		}
523 		delete ids;
524 		numCharacters = 0;
525 	}
526 
527 	/**
528 	 * pays out the players and kills the game.
529 	 * */
530 	function stop() public onlyOwner {
531 		withdraw();
532 		payOut();
533 		kill();
534 	}
535 
536 	/**
537 	 * sell the character of the given id
538 	 * throws an exception in case of a knight not yet teleported to the game
539 	 * @param characterId the id of the character
540 	 * */
541 	function sellCharacter(uint32 characterId) public {
542 		require(tx.origin == msg.sender);
543 		require(msg.sender == characters[characterId].owner);
544 		require(characters[characterId].characterType < 2*numDragonTypes);
545 		require(characters[characterId].purchaseTimestamp + 1 days < now);
546 		uint128 val = characters[characterId].value;
547 		numCharacters--;
548 		replaceCharacter(getCharacterIndex(characterId), numCharacters);
549 		msg.sender.transfer(val);
550 		if (oldest == 0)
551 			findOldest();
552 		NewSell(characterId, msg.sender, val);
553 	}
554 
555 	/**
556 	 * receive approval to spend some tokens.
557 	 * used for teleport and protection.
558 	 * @param sender the sender address
559 	 * @param value the transferred value
560 	 * @param tokenContract the address of the token contract
561 	 * @param callData the data passed by the token contract
562 	 * */
563 	function receiveApproval(address sender, uint256 value, address tokenContract, bytes callData) public {
564 		uint32 id;
565 		uint256 price;
566 		if (msg.sender == address(teleportToken)) {
567 			id = toUint32(callData);
568 			price = teleportPrice * (characters[id].characterType/numDragonTypes);//double price in case of balloon
569 			require(value >= price);
570 			assert(teleportToken.transferFrom(sender, this, price));
571 			teleportKnight(id);
572 		}
573 		else if (msg.sender == address(neverdieToken)) {
574 			id = toUint32(callData);
575 			// user can purchase extra lifes only right after character purchaes
576 			// in other words, user value should be equal the initial value
577 			uint8 cType = characters[id].characterType;
578 			require(characters[id].value == values[cType]);
579 
580 			// calc how many lifes user can actually buy
581 			// the formula is the following:
582 
583 			uint256 lifePrice;
584 			uint8 max;
585 			if(cType < 2 * numDragonTypes){
586 				lifePrice = ((cType % numDragonTypes) + 1) * protectionPrice;
587 				max = 3;
588 			}
589 			else {
590 				lifePrice = (((cType+3) % numDragonTypes) + 1) * protectionPrice * 2;
591 				max = 6;
592 			}
593 
594 			price = 0;
595 			uint8 i = protection[id];
596 			for (i; i < max && value >= price + lifePrice * (i + 1); i++) {
597 				price += lifePrice * (i + 1);
598 			}
599 			assert(neverdieToken.transferFrom(sender, this, price));
600 			protectCharacter(id, i);
601 		}
602 		else
603 			revert();
604 	}
605 
606 	/**
607 	 * knights are only entering the game completely, when they are teleported to the scene
608 	 * @param id the character id
609 	 * */
610 	function teleportKnight(uint32 id) internal {
611 		// ensure we do not teleport twice
612 		require(teleported[id] == false);
613 		teleported[id] = true;
614 		Character storage knight = characters[id];
615 		require(knight.characterType >= numDragonTypes); //this also makes calls with non-existent ids fail
616 		addCharacter(id, numCharacters);
617 		numCharacters++;
618 		numCharactersXType[knight.characterType]++;
619 		NewTeleport(id);
620 	}
621 
622 	/**
623 	 * adds protection to a character
624 	 * @param id the character id
625 	 * @param lifes the number of protections
626 	 * */
627 	function protectCharacter(uint32 id, uint8 lifes) internal {
628 		protection[id] = lifes;
629 		NewProtection(id, lifes);
630 	}
631 
632 
633 	/****************** GETTERS *************************/
634 
635 	/**
636 	 * returns the character of the given id
637 	 * @param characterId the character id
638 	 * @return the type, value and owner of the character
639 	 * */
640 	function getCharacter(uint32 characterId) constant public returns(uint8, uint128, address) {
641 		return (characters[characterId].characterType, characters[characterId].value, characters[characterId].owner);
642 	}
643 
644 	/**
645 	 * returns the index of a character of the given id
646 	 * @param characterId the character id
647 	 * @return the character id
648 	 * */
649 	function getCharacterIndex(uint32 characterId) constant public returns(uint16) {
650 		for (uint16 i = 0; i < ids.length; i++) {
651 			if (ids[i] == characterId) {
652 				return i;
653 			}
654 		}
655 		revert();
656 	}
657 
658 	/**
659 	 * returns 10 characters starting from a certain indey
660 	 * @param startIndex the index to start from
661 	 * @return 4 arrays containing the ids, types, values and owners of the characters
662 	 * */
663 	function get10Characters(uint16 startIndex) constant public returns(uint32[10] characterIds, uint8[10] types, uint128[10] values, address[10] owners) {
664 		uint32 endIndex = startIndex + 10 > numCharacters ? numCharacters : startIndex + 10;
665 		uint8 j = 0;
666 		uint32 id;
667 		for (uint16 i = startIndex; i < endIndex; i++) {
668 			id = ids[i];
669 			characterIds[j] = id;
670 			types[j] = characters[id].characterType;
671 			values[j] = characters[id].value;
672 			owners[j] = characters[id].owner;
673 			j++;
674 		}
675 
676 	}
677 
678 	/**
679 	 * returns the number of dragons in the game
680 	 * @return the number of dragons
681 	 * */
682 	function getNumDragons() constant public returns(uint16 numDragons) {
683 		for (uint8 i = 0; i < numDragonTypes; i++)
684 			numDragons += numCharactersXType[i];
685 	}
686 
687 	/**
688 	 * returns the number of knights in the game
689 	 * @return the number of knights
690 	 * */
691 	function getNumKnights() constant public returns(uint16 numKnights) {
692 		for (uint8 i = numDragonTypes; i < 2 * numDragonTypes; i++)
693 			numKnights += numCharactersXType[i];
694 	}
695 
696 	/**
697 	 * @return the accumulated fees
698 	 * */
699 	function getFees() constant public returns(uint) {
700 		uint reserved = 0;
701 		for (uint16 j = 0; j < numCharacters; j++)
702 			reserved += characters[ids[j]].value;
703 		return address(this).balance - reserved;
704 	}
705 
706 
707 	/****************** SETTERS *************************/
708 
709 	/**
710 	 * sets the prices of the character types
711 	 * @param prices the prices in finney
712 	 * */
713 	function setPrices(uint16[] prices) public onlyOwner {
714 		for (uint8 i = 0; i < prices.length; i++) {
715 			costs[i] = uint128(prices[i]) * 1 finney;
716 			values[i] = costs[i] - costs[i] / 100 * fee;
717 		}
718 	}
719 
720 	/**
721 	 * sets the fight factor
722 	 * @param _factor the new fight factor
723 	 * */
724 	function setFightFactor(uint8 _factor) public onlyOwner {
725 		fightFactor = _factor;
726 	}
727 
728 	/**
729 	 * sets the fee to charge on each purchase
730 	 * @param _fee the new fee
731 	 * */
732 	function setFee(uint8 _fee) public onlyOwner {
733 		fee = _fee;
734 	}
735 
736 	/**
737 	 * sets the maximum number of characters allowed in the game
738 	 * @param number the new maximum
739 	 * */
740 	function setMaxCharacters(uint16 number) public onlyOwner {
741 		maxCharacters = number;
742 	}
743 
744 	/**
745 	 * sets the teleport price
746 	 * @param price the price in tokens
747 	 * */
748 	function setTeleportPrice(uint price) public onlyOwner {
749 		teleportPrice = price;
750 	}
751 
752 	/**
753 	 * sets the protection price
754 	 * @param price the price in tokens
755 	 * */
756 	function setProtectionPrice(uint price) public onlyOwner {
757 		protectionPrice = price;
758 	}
759 
760 	/**
761 	 * sets the eruption threshold
762 	 * @param et the new eruption threshold in seconds
763 	 * */
764 	function setEruptionThreshold(uint et) public onlyOwner {
765 		eruptionThreshold = et;
766 	}
767 
768   function setPercentageToKill(uint8 percentage) public onlyOwner {
769     percentageToKill = percentage;
770   }
771 
772 	/************* HELPERS ****************/
773 
774 	/**
775 	 * only works for bytes of length < 32
776 	 * @param b the byte input
777 	 * @return the uint
778 	 * */
779 	function toUint32(bytes b) internal pure returns(uint32) {
780 		bytes32 newB;
781 		assembly {
782 			newB: = mload(0x80)
783 		}
784 		return uint32(newB);
785 	}
786 
787 }