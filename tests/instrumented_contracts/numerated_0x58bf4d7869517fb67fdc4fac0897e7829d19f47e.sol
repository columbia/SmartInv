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
12 pragma solidity ^ 0.4 .17;
13 
14 contract Ownable {
15   address public owner;
16 
17 
18   event OwnershipRenounced(address indexed previousOwner);
19   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   function Ownable() public {
27     owner = msg.sender;
28   }
29 
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38   /**
39    * @dev Allows the current owner to transfer control of the contract to a newOwner.
40    * @param newOwner The address to transfer ownership to.
41    */
42   function transferOwnership(address newOwner) public onlyOwner {
43     require(newOwner != address(0));
44     emit OwnershipTransferred(owner, newOwner);
45     owner = newOwner;
46   }
47 
48   /**
49    * @dev Allows the current owner to relinquish control of the contract.
50    */
51   function renounceOwnership() public onlyOwner {
52     emit OwnershipRenounced(owner);
53     owner = address(0);
54   }
55 }
56 
57 contract mortal is Ownable{
58 
59 	function mortal() public {
60 	}
61 
62 	function kill() internal {
63 		selfdestruct(owner);
64 	}
65 }
66 
67 
68 contract Token {
69 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
70 	function transfer(address _to, uint256 _value) public returns (bool success) {}
71 	function balanceOf(address who) public view returns (uint256);
72 }
73 
74 contract DragonKing is mortal {
75 
76 	struct Character {
77 		uint8 characterType;
78 		uint128 value;
79 		address owner;
80 	}
81 
82 	/** array holding ids of the curret characters*/
83 	uint32[] public ids;
84 	/** the id to be given to the next character **/
85 	uint32 public nextId;
86 	/** the id of the oldest character */
87 	uint32 public oldest;
88 	/** the character belonging to a given id */
89 	mapping(uint32 => Character) characters;
90 	/** teleported knights **/
91 	mapping(uint32 => bool) teleported;
92 	/** the cost of each character type */
93 	uint128[] public costs;
94 	/** the value of each character type (cost - fee), so it's not necessary to compute it each time*/
95 	uint128[] public values;
96 	/** the fee to be paid each time an character is bought in percent*/
97 	uint8 fee;
98 	/** the number of dragon types **/
99 	uint8 constant public numDragonTypes = 6;
100 	/* the number of balloons types */
101 	uint8 constant public numOfBalloonsTypes = 3;
102 	/** constant used to signal that there is no King at the moment **/
103 	uint32 constant public noKing = ~uint32(0);
104 
105 	/** total number of characters in the game  */
106 	uint16 public numCharacters;
107 	/** The maximum of characters allowed in the game */
108 	uint16 public maxCharacters;
109 	/** number of characters per type */
110 	mapping(uint8 => uint16) public numCharactersXType;
111 
112 
113 	/** the amount of time that should pass since last eruption **/
114 	uint public eruptionThreshold;
115 	/** timestampt of the last eruption event **/
116 	uint256 public lastEruptionTimestamp;
117 	/** how many characters to kill in %, e.g. 20 will stand for 20%, should be < 100 **/
118 	uint8 public percentageToKill;
119 
120 	/** knight cooldown. contains the timestamp of the earliest possible moment to start a fight */
121 	mapping(uint32 => uint) public cooldown;
122 	uint256 public constant CooldownThreshold = 1 days;
123 
124 	/** the teleport token contract used to send knights to the game scene */
125 	Token teleportToken;
126 	/** the price for teleportation*/
127 	uint public teleportPrice;
128 	/** the neverdue token contract used to purchase protection from eruptions and fights */
129 	Token neverdieToken;
130 	/** the price for protection */
131 	uint public protectionPrice;
132 	/** tells the number of times a character is protected */
133 	mapping(uint32 => uint8) public protection;
134 
135 	// MODIFIER
136 
137 	/** is fired when new characters are purchased (who bought how many characters of which type?) */
138 	event NewPurchase(address player, uint8 characterType, uint8 amount, uint32 startId);
139 	/** is fired when a player leaves the game */
140 	event NewExit(address player, uint256 totalBalance, uint32[] removedCharacters);
141 	/** is fired when an eruption occurs */
142 	event NewEruption(uint32[] hitCharacters, uint128 value, uint128 gasCost);
143 	/** is fired when a single character is sold **/
144 	event NewSell(uint32 characterId, address player, uint256 value);
145 	/** is fired when a knight fights a dragon **/
146 	event NewFight(uint32 winnerID, uint32 loserID, uint256 value);
147 	/** is fired when a knight is teleported to the field **/
148 	event NewTeleport(uint32 characterId);
149 	/** is fired when a protection is purchased **/
150 	event NewProtection(uint32 characterId, uint8 lifes);
151 
152 	/** initializes the contract parameters	 */
153 	function DragonKing(address teleportTokenAddress, address neverdieTokenAddress, uint8 eruptionThresholdInHours, uint8 percentageOfCharactersToKill, uint8 characterFee, uint16[] charactersCosts, uint16[] balloonsCosts) public onlyOwner {
154 		fee = characterFee;
155 		for (uint8 i = 0; i < charactersCosts.length * 2; i++) {
156 			costs.push(uint128(charactersCosts[i % numDragonTypes]) * 1 finney);
157 			values.push(costs[i] - costs[i] / 100 * fee);
158 		}
159 		uint256 balloonsIndex = charactersCosts.length * 2;
160 		for (uint8 j = 0; j < balloonsCosts.length; j++) {
161 			costs.push(uint128(balloonsCosts[j]) * 1 finney);
162 			values.push(costs[balloonsIndex + j] - costs[balloonsIndex + j] / 100 * fee);
163 		}
164 		eruptionThreshold = eruptionThresholdInHours * 60 * 60; // convert to seconds
165 		percentageToKill = percentageOfCharactersToKill;
166 		maxCharacters = 600;
167 		nextId = 1;
168 		teleportToken = Token(teleportTokenAddress);
169 		teleportPrice = 1000000000000000000;
170 		neverdieToken = Token(neverdieTokenAddress);
171 		protectionPrice = 1000000000000000000;
172 	}
173 
174 	/**
175 	 * buys as many characters as possible with the transfered value of the given type
176 	 * @param characterType the type of the character
177 	 */
178 	function addCharacters(uint8 characterType) payable public {
179 		uint8 amount = uint8(msg.value / costs[characterType]);
180 		uint16 nchars = numCharacters;
181 		if (characterType >= costs.length || msg.value < costs[characterType] || nchars + amount > maxCharacters) revert();
182 		uint32 nid = nextId;
183 		//if type exists, enough ether was transferred and there are less than maxCharacters characters in the game
184 		if (characterType < numDragonTypes) {
185 			//dragons enter the game directly
186 			if (oldest == 0 || oldest == noKing)
187 				oldest = nid;
188 			for (uint8 i = 0; i < amount; i++) {
189 				addCharacter(nid + i, nchars + i);
190 				characters[nid + i] = Character(characterType, values[characterType], msg.sender);
191 			}
192 			numCharactersXType[characterType] += amount;
193 			numCharacters += amount;
194 		}
195 		else {
196 			// to enter game knights should be teleported later
197 			for (uint8 j = 0; j < amount; j++) {
198 				characters[nid + j] = Character(characterType, values[characterType], msg.sender);
199 			}
200 		}
201 		nextId = nid + amount;
202 		NewPurchase(msg.sender, characterType, amount, nid);
203 	}
204 
205 
206 
207 	/**
208 	 * adds a single dragon of the given type to the ids array, which is used to iterate over all characters
209 	 * @param nId the id the character is about to receive
210 	 * @param nchars the number of characters currently in the game
211 	 */
212 	function addCharacter(uint32 nId, uint16 nchars) internal {
213 		if (nchars < ids.length)
214 			ids[nchars] = nId;
215 		else
216 			ids.push(nId);
217 	}
218 
219 	/**
220 	 * leave the game.
221 	 * pays out the sender's balance and removes him and his characters from the game
222 	 * */
223 	function exit() public {
224 		uint32[] memory removed = new uint32[](50);
225 		uint8 count;
226 		uint32 lastId;
227 		uint playerBalance;
228 		uint16 nchars = numCharacters;
229 		for (uint16 i = 0; i < nchars; i++) {
230 			if (characters[ids[i]].owner == msg.sender) {
231 				//first delete all characters at the end of the array
232 				while (nchars > 0 && characters[ids[nchars - 1]].owner == msg.sender) {
233 					nchars--;
234 					lastId = ids[nchars];
235 					numCharactersXType[characters[lastId].characterType]--;
236 					playerBalance += characters[lastId].value;
237 					removed[count] = lastId;
238 					count++;
239 					if (lastId == oldest) oldest = 0;
240 					delete characters[lastId];
241 				}
242 				//if the last character does not belong to the player, replace the players character by this last one
243 				if (nchars > i + 1) {
244 					playerBalance += characters[ids[i]].value;
245 					removed[count] = ids[i];
246 					count++;
247 					nchars--;
248 					replaceCharacter(i, nchars);
249 				}
250 			}
251 		}
252 		numCharacters = nchars;
253 		NewExit(msg.sender, playerBalance, removed); //fire the event to notify the client
254 		msg.sender.transfer(playerBalance);
255 		if (oldest == 0)
256 			findOldest();
257 	}
258 
259 	/**
260 	 * Replaces the character with the given id with the last character in the array
261 	 * @param index the index of the character in the id array
262 	 * @param nchars the number of characters
263 	 * */
264 	function replaceCharacter(uint16 index, uint16 nchars) internal {
265 		uint32 characterId = ids[index];
266 		numCharactersXType[characters[characterId].characterType]--;
267 		if (characterId == oldest) oldest = 0;
268 		delete characters[characterId];
269 		ids[index] = ids[nchars];
270 		delete ids[nchars];
271 	}
272 
273 	/**
274 	 * The volcano eruption can be triggered by anybody but only if enough time has passed since the last eription.
275 	 * The volcano hits up to a certain percentage of characters, but at least one.
276 	 * The percantage is specified in 'percentageToKill'
277 	 * */
278 
279 	function triggerVolcanoEruption() public {
280 		require(now >= lastEruptionTimestamp + eruptionThreshold);
281 		require(numCharacters>0);
282 		lastEruptionTimestamp = now;
283 		uint128 pot;
284 		uint128 value;
285 		uint16 random;
286 		uint32 nextHitId;
287 		uint16 nchars = numCharacters;
288 		uint32 howmany = nchars * percentageToKill / 100;
289 		uint128 neededGas = 80000 + 10000 * uint32(nchars);
290 		if(howmany == 0) howmany = 1;//hit at least 1
291 		uint32[] memory hitCharacters = new uint32[](howmany);
292 		for (uint8 i = 0; i < howmany; i++) {
293 			random = uint16(generateRandomNumber(lastEruptionTimestamp + i) % nchars);
294 			nextHitId = ids[random];
295 			hitCharacters[i] = nextHitId;
296 			value = hitCharacter(random, nchars);
297 			if (value > 0) {
298 				nchars--;
299 			}
300 			pot += value;
301 		}
302 		uint128 gasCost = uint128(neededGas * tx.gasprice);
303 		numCharacters = nchars;
304 		if (pot > gasCost){
305 			distribute(pot - gasCost); //distribute the pot minus the oraclize gas costs
306 			NewEruption(hitCharacters, pot - gasCost, gasCost);
307 		}
308 		else
309 			NewEruption(hitCharacters, 0, gasCost);
310 	}
311 
312 
313 	/**
314 	 * A knight may attack a dragon, but not choose which one.
315 	 * The creature with the higher level wins. The level is determined by characterType % numDragonTypes.
316 	 * The value of the loser is transfered to the winner. In case of a the same level, the winner is chosen randomly.
317 	 * @param knightID the ID of the knight to perfrom the attack
318 	 * @param knightIndex the index of the knight in the ids-array. Just needed to save gas costs.
319 	 *					  In case it's unknown or incorrect, the index is looked up in the array.
320 	 * */
321 	function fight(uint32 knightID, uint16 knightIndex) public {
322 		if (knightID != ids[knightIndex])
323 			knightID = getCharacterIndex(knightID);
324 		Character storage knight = characters[knightID];
325 		require(cooldown[knightID] + CooldownThreshold <= now);
326 		require(knight.owner == msg.sender);
327 		require(knight.characterType < 2*numDragonTypes); // knight is not a balloon
328 		require(knight.characterType >= numDragonTypes);
329 		uint16 dragonIndex = getRandomDragon(knightID);
330 		assert(dragonIndex < maxCharacters);
331 		uint32 dragonID = ids[dragonIndex];
332 		Character storage dragon = characters[dragonID];
333 		uint16 tieBreaker = uint16(now % 2);
334 		uint128 value;
335 		if (knight.characterType - numDragonTypes > dragon.characterType || (knight.characterType - numDragonTypes == dragon.characterType && tieBreaker == 0)) {
336 			value = hitCharacter(dragonIndex, numCharacters);
337 			if (value > 0) {
338 				numCharacters--;
339 			}
340 			knight.value += value;
341 			cooldown[knightID] = now;
342 			if (oldest == 0) findOldest();
343 			NewFight(knightID, dragonID, value);
344 		}
345 		else {
346 			value = hitCharacter(knightIndex, numCharacters);
347 			if (value > 0) {
348 				numCharacters--;
349 			}
350 			dragon.value += value;
351 			NewFight(dragonID, knightID, value);
352 		}
353 	}
354 
355 	/**
356 	 * pick a random dragon.
357 	 * @param nonce a nonce to make sure there's not always the same dragon chosen in a single block.
358 	 * @return the index of a random dragon
359 	 * */
360 	function getRandomDragon(uint256 nonce) internal view returns(uint16) {
361 		uint16 randomIndex = uint16(generateRandomNumber(nonce) % numCharacters);
362 		//use 7, 11 or 13 as step size. scales for up to 1000 characters
363 		uint16 stepSize = numCharacters % 7 == 0 ? (numCharacters % 11 == 0 ? 13 : 11) : 7;
364 		uint16 i = randomIndex;
365 		//if the picked character is a knight or belongs to the sender, look at the character + stepSizes ahead in the array (modulo the total number)
366 		//will at some point return to the startingPoint if no character is suited
367 		do {
368 			if (characters[ids[i]].characterType < numDragonTypes && characters[ids[i]].owner != msg.sender) return i;
369 			i = (i + stepSize) % numCharacters;
370 		} while (i != randomIndex);
371 		return maxCharacters + 1; //there is none
372 	}
373 
374 	/**
375 	 * generate a random number.
376 	 * @param nonce a nonce to make sure there's not always the same number returned in a single block.
377 	 * @return the random number
378 	 * */
379 	function generateRandomNumber(uint256 nonce) internal view returns(uint) {
380 		return uint(keccak256(block.blockhash(block.number - 1), now, numCharacters, nonce));
381 	}
382 
383 	/**
384 	 * Hits the character of the given type at the given index.
385 	 * @param index the index of the character
386 	 * @param nchars the number of characters
387 	 * @return the value gained from hitting the characters (zero is the character was protected)
388 	 * */
389 	function hitCharacter(uint16 index, uint16 nchars) internal returns(uint128 characterValue) {
390 		uint32 id = ids[index];
391 		if (protection[id] > 0) {
392 			protection[id]--;
393 			return 0;
394 		}
395 		characterValue = characters[ids[index]].value;
396 		nchars--;
397 		replaceCharacter(index, nchars);
398 	}
399 
400 	/**
401 	 * finds the oldest character
402 	 * */
403 	function findOldest() public {
404 		uint32 newOldest = noKing;
405 		for (uint16 i = 0; i < numCharacters; i++) {
406 			if (ids[i] < newOldest && characters[ids[i]].characterType < numDragonTypes)
407 				newOldest = ids[i];
408 		}
409 		oldest = newOldest;
410 	}
411 
412 	/**
413 	* distributes the given amount among the surviving characters
414 	* @param totalAmount nthe amount to distribute
415 	*/
416 	function distribute(uint128 totalAmount) internal {
417 		uint128 amount;
418 		if (oldest == 0)
419 			findOldest();
420 		if (oldest != noKing) {
421 			//pay 10% to the oldest dragon
422 			characters[oldest].value += totalAmount / 10;
423 			amount	= totalAmount / 10 * 9;
424 		} else {
425 			amount	= totalAmount;
426 		}
427 		//distribute the rest according to their type
428 		uint128 valueSum;
429 		uint8 size = 2 * numDragonTypes;
430 		uint128[] memory shares = new uint128[](size);
431 		for (uint8 v = 0; v < size; v++) {
432 			if (numCharactersXType[v] > 0) valueSum += values[v];
433 		}
434 		for (uint8 m = 0; m < size; m++) {
435 			if (numCharactersXType[m] > 0)
436 				shares[m] = amount * values[m] / valueSum / numCharactersXType[m];
437 		}
438 		uint8 cType;
439 		for (uint16 i = 0; i < numCharacters; i++) {
440 			cType = characters[ids[i]].characterType;
441 			if(cType < size)
442 				characters[ids[i]].value += shares[characters[ids[i]].characterType];
443 		}
444 	}
445 
446 	/**
447 	 * allows the owner to collect the accumulated fees
448 	 * sends the given amount to the owner's address if the amount does not exceed the
449 	 * fees (cannot touch the players' balances) minus 100 finney (ensure that oraclize fees can be paid)
450 	 * @param amount the amount to be collected
451 	 * */
452 	function collectFees(uint128 amount) public onlyOwner {
453 		uint collectedFees = getFees();
454 		if (amount + 100 finney < collectedFees) {
455 			owner.transfer(amount);
456 		}
457 	}
458 
459 	/**
460 	* withdraw NDC and TPT tokens
461 	*/
462 	function withdraw() public onlyOwner {
463 		uint256 ndcBalance = neverdieToken.balanceOf(this);
464 		assert(neverdieToken.transfer(owner, ndcBalance));
465 		uint256 tptBalance = teleportToken.balanceOf(this);
466 		assert(teleportToken.transfer(owner, tptBalance));
467 	}
468 
469 	/**
470 	 * pays out the players and kills the game.
471 	 * */
472 	function stop() public onlyOwner {
473 		withdraw();
474 		for (uint16 i = 0; i < numCharacters; i++) {
475 			characters[ids[i]].owner.transfer(characters[ids[i]].value);
476 		}
477 		kill();
478 	}
479 
480 	/**
481 	 * sell the character of the given id
482 	 * throws an exception in case of a knight not yet teleported to the game
483 	 * @param characterId the id of the character
484 	 * */
485 	function sellCharacter(uint32 characterId) public {
486 		require(msg.sender == characters[characterId].owner);
487 		require(characters[characterId].characterType < 2*numDragonTypes);
488 		uint128 val = characters[characterId].value;
489 		numCharacters--;
490 		replaceCharacter(getCharacterIndex(characterId), numCharacters);
491 		msg.sender.transfer(val);
492 		if (oldest == 0)
493 			findOldest();
494 		NewSell(characterId, msg.sender, val);
495 	}
496 
497 	/**
498 	 * receive approval to spend some tokens.
499 	 * used for teleport and protection.
500 	 * @param sender the sender address
501 	 * @param value the transferred value
502 	 * @param tokenContract the address of the token contract
503 	 * @param callData the data passed by the token contract
504 	 * */
505 	function receiveApproval(address sender, uint256 value, address tokenContract, bytes callData) public {
506 		uint32 id;
507 		uint256 price;
508 		if (msg.sender == address(teleportToken)) {
509 			id = toUint32(callData);
510 			price = teleportPrice * (characters[id].characterType/numDragonTypes);//double price in case of balloon
511 			require(value >= price);
512 			assert(teleportToken.transferFrom(sender, this, price));
513 			teleportKnight(id);
514 		}
515 		else if (msg.sender == address(neverdieToken)) {
516 			id = toUint32(callData);
517 			// user can purchase extra lifes only right after character purchaes
518 			// in other words, user value should be equal the initial value
519 			uint8 cType = characters[id].characterType;
520 			require(characters[id].value == values[cType]);
521 
522 			// calc how many lifes user can actually buy
523 			// the formula is the following:
524 
525 			uint256 lifePrice;
526 			uint8 max;
527 			if(cType < 2 * numDragonTypes){
528 				lifePrice = ((cType % numDragonTypes) + 1) * protectionPrice;
529 				max = 3;
530 			}
531 			else {
532 				lifePrice = (((cType+3) % numDragonTypes) + 1) * protectionPrice * 2;
533 				max = 6;
534 			}
535 
536 			price = 0;
537 			uint8 i = protection[id];
538 			for (i; i < max && value >= price + lifePrice * (i + 1); i++) {
539 				price += lifePrice * (i + 1);
540 			}
541 			assert(neverdieToken.transferFrom(sender, this, price));
542 			protectCharacter(id, i);
543 		}
544 		else
545 			revert();
546 	}
547 
548 	/**
549 	 * knights are only entering the game completely, when they are teleported to the scene
550 	 * @param id the character id
551 	 * */
552 	function teleportKnight(uint32 id) internal {
553 		// ensure we do not teleport twice
554 		require(teleported[id] == false);
555 		teleported[id] = true;
556 		Character storage knight = characters[id];
557 		require(knight.characterType >= numDragonTypes); //this also makes calls with non-existent ids fail
558 		addCharacter(id, numCharacters);
559 		numCharacters++;
560 		numCharactersXType[knight.characterType]++;
561 		NewTeleport(id);
562 	}
563 
564 	/**
565 	 * adds protection to a character
566 	 * @param id the character id
567 	 * @param lifes the number of protections
568 	 * */
569 	function protectCharacter(uint32 id, uint8 lifes) internal {
570 		protection[id] = lifes;
571 		NewProtection(id, lifes);
572 	}
573 
574 
575 	/****************** GETTERS *************************/
576 
577 	/**
578 	 * returns the character of the given id
579 	 * @param characterId the character id
580 	 * @return the type, value and owner of the character
581 	 * */
582 	function getCharacter(uint32 characterId) constant public returns(uint8, uint128, address) {
583 		return (characters[characterId].characterType, characters[characterId].value, characters[characterId].owner);
584 	}
585 
586 	/**
587 	 * returns the index of a character of the given id
588 	 * @param characterId the character id
589 	 * @return the character id
590 	 * */
591 	function getCharacterIndex(uint32 characterId) constant public returns(uint16) {
592 		for (uint16 i = 0; i < ids.length; i++) {
593 			if (ids[i] == characterId) {
594 				return i;
595 			}
596 		}
597 		revert();
598 	}
599 
600 	/**
601 	 * returns 10 characters starting from a certain indey
602 	 * @param startIndex the index to start from
603 	 * @return 4 arrays containing the ids, types, values and owners of the characters
604 	 * */
605 	function get10Characters(uint16 startIndex) constant public returns(uint32[10] characterIds, uint8[10] types, uint128[10] values, address[10] owners) {
606 		uint32 endIndex = startIndex + 10 > numCharacters ? numCharacters : startIndex + 10;
607 		uint8 j = 0;
608 		uint32 id;
609 		for (uint16 i = startIndex; i < endIndex; i++) {
610 			id = ids[i];
611 			characterIds[j] = id;
612 			types[j] = characters[id].characterType;
613 			values[j] = characters[id].value;
614 			owners[j] = characters[id].owner;
615 			j++;
616 		}
617 
618 	}
619 
620 	/**
621 	 * returns the number of dragons in the game
622 	 * @return the number of dragons
623 	 * */
624 	function getNumDragons() constant public returns(uint16 numDragons) {
625 		for (uint8 i = 0; i < numDragonTypes; i++)
626 			numDragons += numCharactersXType[i];
627 	}
628 
629 	/**
630 	 * returns the number of knights in the game
631 	 * @return the number of knights
632 	 * */
633 	function getNumKnights() constant public returns(uint16 numKnights) {
634 		for (uint8 i = numDragonTypes; i < 2 * numDragonTypes; i++)
635 			numKnights += numCharactersXType[i];
636 	}
637 
638 	/**
639 	 * @return the accumulated fees
640 	 * */
641 	function getFees() constant public returns(uint) {
642 		uint reserved = 0;
643 		for (uint16 j = 0; j < numCharacters; j++)
644 			reserved += characters[ids[j]].value;
645 		return address(this).balance - reserved;
646 	}
647 
648 
649 	/****************** SETTERS *************************/
650 
651 	/**
652 	 * sets the prices of the character types
653 	 * @param prices the prices in finney
654 	 * */
655 	function setPrices(uint16[] prices) public onlyOwner {
656 		for (uint8 i = 0; i < prices.length * 2; i++) {
657 			costs[i] = uint128(prices[i % numDragonTypes]) * 1 finney;
658 			values[i] = costs[i] - costs[i] / 100 * fee;
659 		}
660 	}
661 
662 	/**
663 	 * sets the fee to charge on each purchase
664 	 * @param _fee the new fee
665 	 * */
666 	function setFee(uint8 _fee) public onlyOwner {
667 		fee = _fee;
668 	}
669 
670 	/**
671 	 * sets the maximum number of characters allowed in the game
672 	 * @param number the new maximum
673 	 * */
674 	function setMaxCharacters(uint16 number) public onlyOwner {
675 		maxCharacters = number;
676 	}
677 
678 	/**
679 	 * sets the teleport price
680 	 * @param price the price in tokens
681 	 * */
682 	function setTeleportPrice(uint price) public onlyOwner {
683 		teleportPrice = price;
684 	}
685 
686 	/**
687 	 * sets the protection price
688 	 * @param price the price in tokens
689 	 * */
690 	function setProtectionPrice(uint price) public onlyOwner {
691 		protectionPrice = price;
692 	}
693 	
694 	/**
695 	 * sets the eruption threshold
696 	 * @param et the new eruption threshold in seconds
697 	 * */
698 	function setEruptionThreshold(uint et) public onlyOwner {
699 		eruptionThreshold = et;
700 	}
701 
702 
703 	/************* HELPERS ****************/
704 
705 	/**
706 	 * only works for bytes of length < 32
707 	 * @param b the byte input
708 	 * @return the uint
709 	 * */
710 	function toUint32(bytes b) internal pure returns(uint32) {
711 		bytes32 newB;
712 		assembly {
713 			newB: = mload(0x80)
714 		}
715 		return uint32(newB);
716 	}
717 
718 }