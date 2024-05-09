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
19 pragma solidity ^ 0.4 .17;
20 
21 
22 /**
23  * @title Ownable
24  * @dev The Ownable contract has an owner address, and provides basic authorization control
25  * functions, this simplifies the implementation of "user permissions".
26  */
27 contract Ownable {
28   address public owner;
29 
30 
31   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32 
33 
34   /**
35    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36    * account.
37    */
38   function Ownable() public {
39     owner = msg.sender;
40   }
41 
42 
43   /**
44    * @dev Throws if called by any account other than the owner.
45    */
46   modifier onlyOwner() {
47     require(msg.sender == owner);
48     _;
49   }
50 
51 
52   /**
53    * @dev Allows the current owner to transfer control of the contract to a newOwner.
54    * @param newOwner The address to transfer ownership to.
55    */
56   function transferOwnership(address newOwner) public onlyOwner {
57     require(newOwner != address(0));
58     OwnershipTransferred(owner, newOwner);
59     owner = newOwner;
60   }
61 
62 }
63 
64 contract mortal is Ownable {
65 	address owner;
66 
67 	function mortal() {
68 		owner = msg.sender;
69 	}
70 
71 	function kill() internal {
72 		suicide(owner);
73 	}
74 }
75 
76 contract Token {
77 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
78 	function transfer(address _to, uint256 _value) public returns (bool success) {}
79 	function balanceOf(address who) public view returns (uint256);
80 }
81 
82 contract DragonKing is mortal {
83 
84 	struct Character {
85 		uint8 characterType;
86 		uint128 value;
87 		address owner;
88 	}
89 
90 	/** array holding ids of the curret characters*/
91 	uint32[] public ids;
92 	/** the id to be given to the next character **/
93 	uint32 public nextId;
94 	/** the id of the oldest character */
95 	uint32 public oldest;
96 	/** the character belonging to a given id */
97 	mapping(uint32 => Character) characters;
98 	/** teleported knights **/
99 	mapping(uint32 => bool) teleported;
100 	/** the cost of each character type */
101 	uint128[] public costs;
102 	/** the value of each character type (cost - fee), so it's not necessary to compute it each time*/
103 	uint128[] public values;
104 	/** the fee to be paid each time an character is bought in percent*/
105 	uint8 fee;
106 	/** the number of dragon types **/
107 	uint8 constant public numDragonTypes = 6;
108 	/* the number of balloons types */
109 	uint8 constant public numOfBalloonsTypes = 3;
110 	/** constant used to signal that there is no King at the moment **/
111 	uint32 constant public noKing = ~uint32(0);
112 
113 	/** total number of characters in the game  */
114 	uint16 public numCharacters;
115 	/** The maximum of characters allowed in the game */
116 	uint16 public maxCharacters;
117 	/** number of characters per type */
118 	mapping(uint8 => uint16) public numCharactersXType;
119 
120 
121 	/** the amount of time that should pass since last eruption **/
122 	uint public eruptionThreshold;
123 	/** timestampt of the last eruption event **/
124 	uint256 public lastEruptionTimestamp;
125 	/** how many characters to kill in %, e.g. 20 will stand for 20%, should be < 100 **/
126 	uint8 public percentageToKill;
127 
128 	/** knight cooldown. contains the timestamp of the earliest possible moment to start a fight */
129 	mapping(uint32 => uint) public cooldown;
130 	uint256 public constant CooldownThreshold = 1 days;
131 	/** fight factor, used to compute extra probability in fight **/
132 	uint8 public fightFactor;
133 
134 	/** the teleport token contract used to send knights to the game scene */
135 	Token teleportToken;
136 	/** the price for teleportation*/
137 	uint public teleportPrice;
138 	/** the neverdue token contract used to purchase protection from eruptions and fights */
139 	Token neverdieToken;
140 	/** the price for protection */
141 	uint public protectionPrice;
142 	/** tells the number of times a character is protected */
143 	mapping(uint32 => uint8) public protection;
144 
145 	/** the SKL token contract **/
146 	Token sklToken;
147 	/** the XP token contract **/
148 	Token xperToken;
149 
150 	// EVENTS
151 
152 	/** is fired when new characters are purchased (who bought how many characters of which type?) */
153 	event NewPurchase(address player, uint8 characterType, uint16 amount, uint32 startId);
154 	/** is fired when a player leaves the game */
155 	event NewExit(address player, uint256 totalBalance, uint32[] removedCharacters);
156 	/** is fired when an eruption occurs */
157 	event NewEruption(uint32[] hitCharacters, uint128 value, uint128 gasCost);
158 	/** is fired when a single character is sold **/
159 	event NewSell(uint32 characterId, address player, uint256 value);
160 	/** is fired when a knight fights a dragon **/
161 	event NewFight(uint32 winnerID, uint32 loserID, uint256 value, uint16 probability, uint16 dice);
162 	/** is fired when a knight is teleported to the field **/
163 	event NewTeleport(uint32 characterId);
164 	/** is fired when a protection is purchased **/
165 	event NewProtection(uint32 characterId, uint8 lifes);
166 
167 	/** initializes the contract parameters	 */
168 	function DragonKing(address teleportTokenAddress,
169 											address neverdieTokenAddress,
170 											address sklTokenAddress,
171 											address xperTokenAddress,
172 											uint8 eruptionThresholdInHours,
173 											uint8 percentageOfCharactersToKill,
174 											uint8 characterFee,
175 											uint16[] charactersCosts,
176 											uint16[] balloonsCosts) public onlyOwner {
177 		fee = characterFee;
178 		for (uint8 i = 0; i < charactersCosts.length * 2; i++) {
179 			costs.push(uint128(charactersCosts[i % numDragonTypes]) * 1 finney);
180 			values.push(costs[i] - costs[i] / 100 * fee);
181 		}
182 		uint256 balloonsIndex = charactersCosts.length * 2;
183 		for (uint8 j = 0; j < balloonsCosts.length; j++) {
184 			costs.push(uint128(balloonsCosts[j]) * 1 finney);
185 			values.push(costs[balloonsIndex + j] - costs[balloonsIndex + j] / 100 * fee);
186 		}
187 		eruptionThreshold = uint(eruptionThresholdInHours) * 60 * 60; // convert to seconds
188 		percentageToKill = percentageOfCharactersToKill;
189 		maxCharacters = 600;
190 		nextId = 1;
191 		teleportToken = Token(teleportTokenAddress);
192 		teleportPrice = 1000000000000000000;
193 		neverdieToken = Token(neverdieTokenAddress);
194 		protectionPrice = 1000000000000000000;
195 		fightFactor = 4;
196 		sklToken = Token(sklTokenAddress);
197 		xperToken = Token(xperTokenAddress);
198 	}
199 
200 	/**
201 	 * buys as many characters as possible with the transfered value of the given type
202 	 * @param characterType the type of the character
203 	 */
204 	function addCharacters(uint8 characterType) payable public {
205 		uint16 amount = uint16(msg.value / costs[characterType]);
206 		uint16 nchars = numCharacters;
207 		if (characterType >= costs.length || msg.value < costs[characterType] || nchars + amount > maxCharacters) revert();
208 		uint32 nid = nextId;
209 		//if type exists, enough ether was transferred and there are less than maxCharacters characters in the game
210 		if (characterType < numDragonTypes) {
211 			//dragons enter the game directly
212 			if (oldest == 0 || oldest == noKing)
213 				oldest = nid;
214 			for (uint8 i = 0; i < amount; i++) {
215 				addCharacter(nid + i, nchars + i);
216 				characters[nid + i] = Character(characterType, values[characterType], msg.sender);
217 			}
218 			numCharactersXType[characterType] += amount;
219 			numCharacters += amount;
220 		}
221 		else {
222 			// to enter game knights should be teleported later
223 			for (uint8 j = 0; j < amount; j++) {
224 				characters[nid + j] = Character(characterType, values[characterType], msg.sender);
225 			}
226 		}
227 		nextId = nid + amount;
228 		NewPurchase(msg.sender, characterType, amount, nid);
229 	}
230 
231 
232 
233 	/**
234 	 * adds a single dragon of the given type to the ids array, which is used to iterate over all characters
235 	 * @param nId the id the character is about to receive
236 	 * @param nchars the number of characters currently in the game
237 	 */
238 	function addCharacter(uint32 nId, uint16 nchars) internal {
239 		if (nchars < ids.length)
240 			ids[nchars] = nId;
241 		else
242 			ids.push(nId);
243 	}
244 
245 	/**
246 	 * leave the game.
247 	 * pays out the sender's balance and removes him and his characters from the game
248 	 * */
249 	function exit() public {
250 		uint32[] memory removed = new uint32[](50);
251 		uint8 count;
252 		uint32 lastId;
253 		uint playerBalance;
254 		uint16 nchars = numCharacters;
255 		for (uint16 i = 0; i < nchars; i++) {
256 			if (characters[ids[i]].owner == msg.sender && characters[ids[i]].characterType < 2*numDragonTypes) {
257 				//first delete all characters at the end of the array
258 				while (nchars > 0 && characters[ids[nchars - 1]].owner == msg.sender && characters[ids[nchars - 1]].characterType < 2*numDragonTypes) {
259 					nchars--;
260 					lastId = ids[nchars];
261 					numCharactersXType[characters[lastId].characterType]--;
262 					playerBalance += characters[lastId].value;
263 					removed[count] = lastId;
264 					count++;
265 					if (lastId == oldest) oldest = 0;
266 					delete characters[lastId];
267 				}
268 				//replace the players character by the last one
269 				if (nchars > i + 1) {
270 					playerBalance += characters[ids[i]].value;
271 					removed[count] = ids[i];
272 					count++;
273 					nchars--;
274 					replaceCharacter(i, nchars);
275 				}
276 			}
277 		}
278 		numCharacters = nchars;
279 		NewExit(msg.sender, playerBalance, removed); //fire the event to notify the client
280 		msg.sender.transfer(playerBalance);
281 		if (oldest == 0)
282 			findOldest();
283 	}
284 
285 	/**
286 	 * Replaces the character with the given id with the last character in the array
287 	 * @param index the index of the character in the id array
288 	 * @param nchars the number of characters
289 	 * */
290 	function replaceCharacter(uint16 index, uint16 nchars) internal {
291 		uint32 characterId = ids[index];
292 		numCharactersXType[characters[characterId].characterType]--;
293 		if (characterId == oldest) oldest = 0;
294 		delete characters[characterId];
295 		ids[index] = ids[nchars];
296 		delete ids[nchars];
297 	}
298 
299 	/**
300 	 * The volcano eruption can be triggered by anybody but only if enough time has passed since the last eription.
301 	 * The volcano hits up to a certain percentage of characters, but at least one.
302 	 * The percantage is specified in 'percentageToKill'
303 	 * */
304 
305 	function triggerVolcanoEruption() public {
306 		require(now >= lastEruptionTimestamp + eruptionThreshold);
307 		require(numCharacters>0);
308 		lastEruptionTimestamp = now;
309 		uint128 pot;
310 		uint128 value;
311 		uint16 random;
312 		uint32 nextHitId;
313 		uint16 nchars = numCharacters;
314 		uint32 howmany = nchars * percentageToKill / 100;
315 		uint128 neededGas = 80000 + 10000 * uint32(nchars);
316 		if(howmany == 0) howmany = 1;//hit at least 1
317 		uint32[] memory hitCharacters = new uint32[](howmany);
318 		for (uint8 i = 0; i < howmany; i++) {
319 			random = uint16(generateRandomNumber(lastEruptionTimestamp + i) % nchars);
320 			nextHitId = ids[random];
321 			hitCharacters[i] = nextHitId;
322 			value = hitCharacter(random, nchars);
323 			if (value > 0) {
324 				nchars--;
325 			}
326 			pot += value;
327 		}
328 		uint128 gasCost = uint128(neededGas * tx.gasprice);
329 		numCharacters = nchars;
330 		if (pot > gasCost){
331 			distribute(pot - gasCost); //distribute the pot minus the oraclize gas costs
332 			NewEruption(hitCharacters, pot - gasCost, gasCost);
333 		}
334 		else
335 			NewEruption(hitCharacters, 0, gasCost);
336 	}
337 
338 	/**
339 	 * A knight may attack a dragon, but not choose which one.
340 	 * The value of the loser is transfered to the winner.
341 	 * @param knightID the ID of the knight to perfrom the attack
342 	 * @param knightIndex the index of the knight in the ids-array. Just needed to save gas costs.
343 	 *						In case it's unknown or incorrect, the index is looked up in the array.
344 	 * */
345 	function fight(uint32 knightID, uint16 knightIndex) public {
346 		if (knightID != ids[knightIndex])
347 			knightIndex = getCharacterIndex(knightID);
348 		Character storage knight = characters[knightID];
349 		require(cooldown[knightID] + CooldownThreshold <= now);
350 		require(knight.owner == msg.sender);
351 		require(knight.characterType < 2*numDragonTypes); // knight is not a balloon
352 		require(knight.characterType >= numDragonTypes);
353 		uint16 dragonIndex = getRandomDragon(knightID);
354 		assert(dragonIndex < maxCharacters);
355 		uint32 dragonID = ids[dragonIndex];
356 		Character storage dragon = characters[dragonID];
357 		uint128 value;
358 		uint16 base_probability;
359 		uint16 dice = uint16(generateRandomNumber(knightID) % 100);
360 		uint256 knightPower = sklToken.balanceOf(knight.owner) / 10**15 + xperToken.balanceOf(knight.owner);
361 		uint256 dragonPower = sklToken.balanceOf(dragon.owner) / 10**15 + xperToken.balanceOf(dragon.owner);
362 		if (knight.value == dragon.value) {
363 				base_probability = 50;
364 			if (knightPower > dragonPower) {
365 				base_probability += uint16(100 / fightFactor);
366 			} else if (dragonPower > knightPower) {
367 				base_probability -= uint16(100 / fightFactor);
368 			}
369 		} else if (knight.value > dragon.value) {
370 			base_probability = 100;
371 			if (dragonPower > knightPower) {
372 				base_probability -= uint16((100 * dragon.value) / knight.value / fightFactor);
373 			}
374 		} else if (knightPower > dragonPower) {
375 				base_probability += uint16((100 * knight.value) / dragon.value / fightFactor);
376 		}
377   
378 		if (dice >= base_probability) {
379 			// dragon won
380 			value = hitCharacter(knightIndex, numCharacters);
381 			if (value > 0) {
382 				numCharacters--;
383 			}
384 			dragon.value += value;
385 			NewFight(dragonID, knightID, value, base_probability, dice);
386 		} else {
387 			// knight won
388 			value = hitCharacter(dragonIndex, numCharacters);
389 			if (value > 0) {
390 				numCharacters--;
391 			}
392 			knight.value += value;
393 			cooldown[knightID] = now;
394 			if (oldest == 0) findOldest();
395 			NewFight(knightID, dragonID, value, base_probability, dice);
396 		}
397 	}
398 
399 	/**
400 	 * pick a random dragon.
401 	 * @param nonce a nonce to make sure there's not always the same dragon chosen in a single block.
402 	 * @return the index of a random dragon
403 	 * */
404 	function getRandomDragon(uint256 nonce) internal view returns(uint16) {
405 		uint16 randomIndex = uint16(generateRandomNumber(nonce) % numCharacters);
406 		//use 7, 11 or 13 as step size. scales for up to 1000 characters
407 		uint16 stepSize = numCharacters % 7 == 0 ? (numCharacters % 11 == 0 ? 13 : 11) : 7;
408 		uint16 i = randomIndex;
409 		//if the picked character is a knight or belongs to the sender, look at the character + stepSizes ahead in the array (modulo the total number)
410 		//will at some point return to the startingPoint if no character is suited
411 		do {
412 			if (characters[ids[i]].characterType < numDragonTypes && characters[ids[i]].owner != msg.sender) return i;
413 			i = (i + stepSize) % numCharacters;
414 		} while (i != randomIndex);
415 		return maxCharacters + 1; //there is none
416 	}
417 
418 	/**
419 	 * generate a random number.
420 	 * @param nonce a nonce to make sure there's not always the same number returned in a single block.
421 	 * @return the random number
422 	 * */
423 	function generateRandomNumber(uint256 nonce) internal view returns(uint) {
424 		return uint(keccak256(block.blockhash(block.number - 1), now, numCharacters, nonce));
425 	}
426 
427 	/**
428 	 * Hits the character of the given type at the given index.
429 	 * @param index the index of the character
430 	 * @param nchars the number of characters
431 	 * @return the value gained from hitting the characters (zero is the character was protected)
432 	 * */
433 	function hitCharacter(uint16 index, uint16 nchars) internal returns(uint128 characterValue) {
434 		uint32 id = ids[index];
435 		if (protection[id] > 0) {
436 			protection[id]--;
437 			return 0;
438 		}
439 		characterValue = characters[ids[index]].value;
440 		nchars--;
441 		replaceCharacter(index, nchars);
442 	}
443 
444 	/**
445 	 * finds the oldest character
446 	 * */
447 	function findOldest() public {
448 		uint32 newOldest = noKing;
449 		for (uint16 i = 0; i < numCharacters; i++) {
450 			if (ids[i] < newOldest && characters[ids[i]].characterType < numDragonTypes)
451 				newOldest = ids[i];
452 		}
453 		oldest = newOldest;
454 	}
455 
456 	/**
457 	* distributes the given amount among the surviving characters
458 	* @param totalAmount nthe amount to distribute
459 	*/
460 	function distribute(uint128 totalAmount) internal {
461 		uint128 amount;
462 		if (oldest == 0)
463 			findOldest();
464 		if (oldest != noKing) {
465 			//pay 10% to the oldest dragon
466 			characters[oldest].value += totalAmount / 10;
467 			amount	= totalAmount / 10 * 9;
468 		} else {
469 			amount	= totalAmount;
470 		}
471 		//distribute the rest according to their type
472 		uint128 valueSum;
473 		uint8 size = 2 * numDragonTypes;
474 		uint128[] memory shares = new uint128[](size);
475 		for (uint8 v = 0; v < size; v++) {
476 			if (numCharactersXType[v] > 0) valueSum += values[v];
477 		}
478 		for (uint8 m = 0; m < size; m++) {
479 			if (numCharactersXType[m] > 0)
480 				shares[m] = amount * values[m] / valueSum / numCharactersXType[m];
481 		}
482 		uint8 cType;
483 		for (uint16 i = 0; i < numCharacters; i++) {
484 			cType = characters[ids[i]].characterType;
485 			if(cType < size)
486 				characters[ids[i]].value += shares[characters[ids[i]].characterType];
487 		}
488 	}
489 
490 	/**
491 	 * allows the owner to collect the accumulated fees
492 	 * sends the given amount to the owner's address if the amount does not exceed the
493 	 * fees (cannot touch the players' balances) minus 100 finney (ensure that oraclize fees can be paid)
494 	 * @param amount the amount to be collected
495 	 * */
496 	function collectFees(uint128 amount) public onlyOwner {
497 		uint collectedFees = getFees();
498 		if (amount + 100 finney < collectedFees) {
499 			owner.transfer(amount);
500 		}
501 	}
502 
503 	/**
504 	* withdraw NDC and TPT tokens
505 	*/
506 	function withdraw() public onlyOwner {
507 		uint256 ndcBalance = neverdieToken.balanceOf(this);
508 		assert(neverdieToken.transfer(owner, ndcBalance));
509 		uint256 tptBalance = teleportToken.balanceOf(this);
510 		assert(teleportToken.transfer(owner, tptBalance));
511 	}
512 
513 	/**
514 	 * pays out the players.
515 	 * */
516 	function payOut() public onlyOwner {
517 		for (uint16 i = 0; i < numCharacters; i++) {
518 			characters[ids[i]].owner.transfer(characters[ids[i]].value);
519 			delete characters[ids[i]];
520 		}
521 		delete ids;
522 		numCharacters = 0;
523 	}
524 
525 	/**
526 	 * pays out the players and kills the game.
527 	 * */
528 	function stop() public onlyOwner {
529 		withdraw();
530 		payOut();
531 		kill();
532 	}
533 
534 	/**
535 	 * sell the character of the given id
536 	 * throws an exception in case of a knight not yet teleported to the game
537 	 * @param characterId the id of the character
538 	 * */
539 	function sellCharacter(uint32 characterId) public {
540 		require(msg.sender == characters[characterId].owner);
541 		require(characters[characterId].characterType < 2*numDragonTypes);
542 		uint128 val = characters[characterId].value;
543 		numCharacters--;
544 		replaceCharacter(getCharacterIndex(characterId), numCharacters);
545 		msg.sender.transfer(val);
546 		if (oldest == 0)
547 			findOldest();
548 		NewSell(characterId, msg.sender, val);
549 	}
550 
551 	/**
552 	 * receive approval to spend some tokens.
553 	 * used for teleport and protection.
554 	 * @param sender the sender address
555 	 * @param value the transferred value
556 	 * @param tokenContract the address of the token contract
557 	 * @param callData the data passed by the token contract
558 	 * */
559 	function receiveApproval(address sender, uint256 value, address tokenContract, bytes callData) public {
560 		uint32 id;
561 		uint256 price;
562 		if (msg.sender == address(teleportToken)) {
563 			id = toUint32(callData);
564 			price = teleportPrice * (characters[id].characterType/numDragonTypes);//double price in case of balloon
565 			require(value >= price);
566 			assert(teleportToken.transferFrom(sender, this, price));
567 			teleportKnight(id);
568 		}
569 		else if (msg.sender == address(neverdieToken)) {
570 			id = toUint32(callData);
571 			// user can purchase extra lifes only right after character purchaes
572 			// in other words, user value should be equal the initial value
573 			uint8 cType = characters[id].characterType;
574 			require(characters[id].value == values[cType]);
575 
576 			// calc how many lifes user can actually buy
577 			// the formula is the following:
578 
579 			uint256 lifePrice;
580 			uint8 max;
581 			if(cType < 2 * numDragonTypes){
582 				lifePrice = ((cType % numDragonTypes) + 1) * protectionPrice;
583 				max = 3;
584 			}
585 			else {
586 				lifePrice = (((cType+3) % numDragonTypes) + 1) * protectionPrice * 2;
587 				max = 6;
588 			}
589 
590 			price = 0;
591 			uint8 i = protection[id];
592 			for (i; i < max && value >= price + lifePrice * (i + 1); i++) {
593 				price += lifePrice * (i + 1);
594 			}
595 			assert(neverdieToken.transferFrom(sender, this, price));
596 			protectCharacter(id, i);
597 		}
598 		else
599 			revert();
600 	}
601 
602 	/**
603 	 * knights are only entering the game completely, when they are teleported to the scene
604 	 * @param id the character id
605 	 * */
606 	function teleportKnight(uint32 id) internal {
607 		// ensure we do not teleport twice
608 		require(teleported[id] == false);
609 		teleported[id] = true;
610 		Character storage knight = characters[id];
611 		require(knight.characterType >= numDragonTypes); //this also makes calls with non-existent ids fail
612 		addCharacter(id, numCharacters);
613 		numCharacters++;
614 		numCharactersXType[knight.characterType]++;
615 		NewTeleport(id);
616 	}
617 
618 	/**
619 	 * adds protection to a character
620 	 * @param id the character id
621 	 * @param lifes the number of protections
622 	 * */
623 	function protectCharacter(uint32 id, uint8 lifes) internal {
624 		protection[id] = lifes;
625 		NewProtection(id, lifes);
626 	}
627 
628 
629 	/****************** GETTERS *************************/
630 
631 	/**
632 	 * returns the character of the given id
633 	 * @param characterId the character id
634 	 * @return the type, value and owner of the character
635 	 * */
636 	function getCharacter(uint32 characterId) constant public returns(uint8, uint128, address) {
637 		return (characters[characterId].characterType, characters[characterId].value, characters[characterId].owner);
638 	}
639 
640 	/**
641 	 * returns the index of a character of the given id
642 	 * @param characterId the character id
643 	 * @return the character id
644 	 * */
645 	function getCharacterIndex(uint32 characterId) constant public returns(uint16) {
646 		for (uint16 i = 0; i < ids.length; i++) {
647 			if (ids[i] == characterId) {
648 				return i;
649 			}
650 		}
651 		revert();
652 	}
653 
654 	/**
655 	 * returns 10 characters starting from a certain indey
656 	 * @param startIndex the index to start from
657 	 * @return 4 arrays containing the ids, types, values and owners of the characters
658 	 * */
659 	function get10Characters(uint16 startIndex) constant public returns(uint32[10] characterIds, uint8[10] types, uint128[10] values, address[10] owners) {
660 		uint32 endIndex = startIndex + 10 > numCharacters ? numCharacters : startIndex + 10;
661 		uint8 j = 0;
662 		uint32 id;
663 		for (uint16 i = startIndex; i < endIndex; i++) {
664 			id = ids[i];
665 			characterIds[j] = id;
666 			types[j] = characters[id].characterType;
667 			values[j] = characters[id].value;
668 			owners[j] = characters[id].owner;
669 			j++;
670 		}
671 
672 	}
673 
674 	/**
675 	 * returns the number of dragons in the game
676 	 * @return the number of dragons
677 	 * */
678 	function getNumDragons() constant public returns(uint16 numDragons) {
679 		for (uint8 i = 0; i < numDragonTypes; i++)
680 			numDragons += numCharactersXType[i];
681 	}
682 
683 	/**
684 	 * returns the number of knights in the game
685 	 * @return the number of knights
686 	 * */
687 	function getNumKnights() constant public returns(uint16 numKnights) {
688 		for (uint8 i = numDragonTypes; i < 2 * numDragonTypes; i++)
689 			numKnights += numCharactersXType[i];
690 	}
691 
692 	/**
693 	 * @return the accumulated fees
694 	 * */
695 	function getFees() constant public returns(uint) {
696 		uint reserved = 0;
697 		for (uint16 j = 0; j < numCharacters; j++)
698 			reserved += characters[ids[j]].value;
699 		return address(this).balance - reserved;
700 	}
701 
702 
703 	/****************** SETTERS *************************/
704 
705 	/**
706 	 * sets the prices of the character types
707 	 * @param prices the prices in finney
708 	 * */
709 	function setPrices(uint16[] prices) public onlyOwner {
710 		for (uint8 i = 0; i < prices.length; i++) {
711 			costs[i] = uint128(prices[i]) * 1 finney;
712 			values[i] = costs[i] - costs[i] / 100 * fee;
713 		}
714 	}
715 
716 	/**
717 	 * sets the fight factor
718 	 * @param _factor the new fight factor
719 	 * */
720 	function setFightFactor(uint8 _factor) public onlyOwner {
721 		fightFactor = _factor;
722 	}
723 
724 	/**
725 	 * sets the fee to charge on each purchase
726 	 * @param _fee the new fee
727 	 * */
728 	function setFee(uint8 _fee) public onlyOwner {
729 		fee = _fee;
730 	}
731 
732 	/**
733 	 * sets the maximum number of characters allowed in the game
734 	 * @param number the new maximum
735 	 * */
736 	function setMaxCharacters(uint16 number) public onlyOwner {
737 		maxCharacters = number;
738 	}
739 
740 	/**
741 	 * sets the teleport price
742 	 * @param price the price in tokens
743 	 * */
744 	function setTeleportPrice(uint price) public onlyOwner {
745 		teleportPrice = price;
746 	}
747 
748 	/**
749 	 * sets the protection price
750 	 * @param price the price in tokens
751 	 * */
752 	function setProtectionPrice(uint price) public onlyOwner {
753 		protectionPrice = price;
754 	}
755 
756 	/**
757 	 * sets the eruption threshold
758 	 * @param et the new eruption threshold in seconds
759 	 * */
760 	function setEruptionThreshold(uint et) public onlyOwner {
761 		eruptionThreshold = et;
762 	}
763 
764   function setPercentageToKill(uint8 percentage) public onlyOwner {
765     percentageToKill = percentage;
766   }
767 
768 	/************* HELPERS ****************/
769 
770 	/**
771 	 * only works for bytes of length < 32
772 	 * @param b the byte input
773 	 * @return the uint
774 	 * */
775 	function toUint32(bytes b) internal pure returns(uint32) {
776 		bytes32 newB;
777 		assembly {
778 			newB: = mload(0x80)
779 		}
780 		return uint32(newB);
781 	}
782 
783 }