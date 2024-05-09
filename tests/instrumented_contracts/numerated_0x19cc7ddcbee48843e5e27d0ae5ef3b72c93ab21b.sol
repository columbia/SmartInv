1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     if (a == 0) {
10       return 0;
11     }
12     c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     // uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return a / b;
25   }
26 
27   /**
28   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
39     c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 
46  /**
47  * @title Ownable
48  * @dev The Ownable contract has an owner address, and provides basic authorization control
49  * functions, this simplifies the implementation of "user permissions".
50  */
51 contract Ownable {
52   address public owner;
53 
54   
55   event OwnershipTransferred(
56     address indexed previousOwner,
57     address indexed newOwner
58   );
59 
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   constructor() public {
66     owner = msg.sender;
67   }
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) public onlyOwner {
82     require(newOwner != address(0));
83     emit OwnershipTransferred(owner, newOwner);
84     owner = newOwner;
85   }
86 
87 }
88 
89 
90 /**
91  * @title Pausable
92  * @dev Base contract which allows children to implement an emergency stop mechanism.
93  */
94 contract Pausable is Ownable {
95   event Pause();
96   event Unpause();
97 
98   bool public paused = false;
99 
100 
101   /**
102    * @dev Modifier to make a function callable only when the contract is not paused.
103    */
104   modifier whenNotPaused() {
105     require(!paused);
106     _;
107   }
108 
109   /**
110    * @dev Modifier to make a function callable only when the contract is paused.
111    */
112   modifier whenPaused() {
113     require(paused);
114     _;
115   }
116 
117   /**
118    * @dev called by the owner to pause, triggers stopped state
119    */
120   function pause() onlyOwner whenNotPaused public {
121     paused = true;
122     emit Pause();
123   }
124 
125   /**
126    * @dev called by the owner to unpause, returns to normal state
127    */
128   function unpause() onlyOwner whenPaused public {
129     paused = false;
130     emit Unpause();
131   }
132 }
133 
134 
135 
136 contract BattleBase is Ownable {
137 	 using SafeMath for uint256;
138 	 
139 	/***********************************************************************************/
140 	/* EVENTS
141 	/***********************************************************************************/
142 	
143 	/**
144 	* History sequence will be represented by uint256, in other words the max round is 256 (rounds more than this will decide on hp left or draw)
145 	*  1 is challenger attack
146 	*  2 is defender attack
147 	*  3 is challenger attack with critical
148 	*  4 is defender attack with critical
149 	*/
150 	event BattleHistory(
151 		uint256 historyId,
152 		uint8 winner, // 0 - challenger; 1 - defender; 2 - draw;
153 		uint64 battleTime,
154 		uint256 sequence,
155 		uint256 blockNumber,
156 		uint256 tokensGained);
157 	
158 	event BattleHistoryChallenger(
159 		uint256 historyId,
160 		uint256 cardId,
161 		uint8 element,
162 		uint16 level,
163 		uint32 attack,
164 		uint32 defense,
165 		uint32 hp,
166 		uint32 speed,
167 		uint32 criticalRate,
168 		uint256 rank);
169 		
170 	event BattleHistoryDefender(
171 		uint256 historyId,
172 		uint256 cardId,
173 		uint8 element,
174 		uint16 level,
175 		uint32 attack,
176 		uint32 defense,
177 		uint32 hp,
178 		uint32 speed,
179 		uint16 criticalRate,
180 		uint256 rank);
181 	
182 	event RejectChallenge(
183 		uint256 challengerId,
184 		uint256 defenderId,
185 		uint256 defenderRank,
186 		uint8 rejectCode,
187 		uint256 blockNumber);
188 		
189 	event HashUpdated(
190 		uint256 cardId, 
191 		uint256 cardHash);
192 		
193 	event LevelUp(uint256 cardId);
194 	
195 	event CardCreated(address owner, uint256 cardId);
196 	
197 	
198 	/***********************************************************************************/
199 	/* CONST DATA
200 	/***********************************************************************************/		
201 	uint32[] expToNextLevelArr = [0,103,103,207,207,207,414,414,414,414,724,724,724,828,828,931,931,1035,1035,1138,1138,1242,1242,1345,1345,1449,1449,1552,1552,1656,1656,1759,1759,1863,1863,1966,1966,2070,2070,2173,2173,2173,2277,2277,2380,2380,2484,2484,2587,2587,2691,2691,2794,2794,2898,2898,3001,3001,3105,3105,3208,3208,3312,3312,3415,3415,3519,3519,3622,3622,3622,3726,3726,3829,3829,3933,3933,4036,4036,4140,4140,4243,4243,4347,4347,4450,4450,4554,4554,4657,4657,4761,4761,4864,4864,4968,4968,5071,5071,5175];
202 	
203 	uint32[] activeWinExp = [10,11,14,19,26,35,46,59,74,91,100,103,108,116,125,135,146,158,171,185,200,215,231,248,265,283,302,321,341,361,382];
204 	
205 	
206 	/***********************************************************************************/
207 	/* DATA VARIABLES
208 	/***********************************************************************************/		
209 	//Card structure that holds all information for battle
210 	struct Card {
211 		uint8 element; // 1 - fire; 2 - water; 3 - wood;    8 - light; 9 - dark;
212 		uint16 level; //"unlimited" level bound to uint16 Max level is 65535
213 		uint32 attack;
214 		uint32 defense;
215 		uint32 hp;
216 		uint32 speed;
217 		uint16 criticalRate; //max 8000
218 		uint32 flexiGems;
219 		uint256 cardHash;
220 		uint32 currentExp;
221 		uint32 expToNextLevel;
222 		uint64 createdDatetime;
223 
224 		uint256 rank; //rank is n-1 (need to add 1 for display);
225 
226 		//uint8 passiveSkill; //TBC
227 	}
228 	
229 	// Mapping from tokenId to Card Struct
230 	mapping (uint256 => Card) public cards;
231 	
232 	uint256[] ranking; //stores the token id according to array position starts from 0 (rank 1)
233 	
234 	// Mapping from rank to amount held in that rank (challenge tokens)
235 	mapping (uint256 => uint256) public rankTokens;
236 	
237 	uint8 public currentElement = 0; //start with 0 as +1 will become fire
238 	
239 	uint256 public historyId = 0;
240 	
241 	/***********************************************************************************/
242 	/* CONFIGURATIONS
243 	/***********************************************************************************/
244 	/// @dev The address of the HogSmashToken
245 	HogSmashToken public hogsmashToken;
246 	
247 	/// @dev The address of the Marketplace
248 	Marketplace public marketplace;
249 			
250 	// Challenge fee changes on ranking difference
251 	uint256 public challengeFee;
252 
253 	// Upgrade fee
254 	uint256 public upgradeFee;
255 	
256 	// Avatar fee
257 	uint256 public avatarFee;
258 	
259 	// Referrer fee in % (x10000)
260 	uint256 public referrerFee;
261 	
262 	// Developer Cut in % (x10000)
263 	uint256 public developerCut;
264 	
265 	uint256 internal totalDeveloperCut;
266 
267 	// Price for each card draw (in wei)
268 	uint256 public cardDrawPrice;
269 
270 	// Gems provided for upgrade every level up
271 	uint8 public upgradeGems; //
272 	// Gems provided for upgrade every 10 level up
273 	uint8 public upgradeGemsSpecial;
274 	// 1 Gem to attack conversion
275 	uint16 public gemAttackConversion;
276 	// 1 Gem to defense conversion
277 	uint16 public gemDefenseConversion;
278 	// 1 Gem to hp conversion
279 	uint16 public gemHpConversion;
280 	// 1 Gem to speed conversion
281 	uint16 public gemSpeedConversion;
282 	// 1 Gem to critical rate conversion divided by 100, eg 25 = 0.25
283 	uint16 public gemCriticalRateConversion;
284 	
285 	//% to get a gold card, 0 to 100
286 	uint8 public goldPercentage;
287 	
288 	//% to get a silver card, 0 to 100
289 	uint8 public silverPercentage;
290  	
291 	//Range of event card number 1-99999999
292 	uint32 public eventCardRangeMin;
293 	
294 	//Range of event card number 1-99999999
295 	uint32 public eventCardRangeMax;
296 	
297 	// Maximum rounds of battle, cannot exceed 128
298 	uint8 public maxBattleRounds; //
299 		
300 	// Record how much tokens are held as rank tokens
301 	uint256 internal totalRankTokens;
302 	
303 	// Flag for start fighting
304 	bool internal battleStart;
305 	
306 	//Flag for starter pack sale
307 	bool internal starterPackOnSale;
308 	
309 	uint256 public starterPackPrice; //price of starter pack
310 	
311 	uint16 public starterPackCardLevel; //card level from starter pack
312 	
313 	
314 	/***********************************************************************************/
315 	/* ADMIN FUNCTIONS FOR SETTING CONFIGS
316 	/***********************************************************************************/		
317 	/// @dev Sets the reference to the marketplace.
318 	/// @param _address - Address of marketplace.
319 	function setMarketplaceAddress(address _address) external onlyOwner {
320 		Marketplace candidateContract = Marketplace(_address);
321 
322 		require(candidateContract.isMarketplace(),"needs to be marketplace");
323 
324 		// Set the new contract address
325 		marketplace = candidateContract;
326 	}
327 		
328 	/**
329 	* @dev set upgrade gems for each level up and each 10 level up
330 	* @param _upgradeGems upgrade gems for normal levels
331 	* @param _upgradeGemsSpecial upgrade gems for every n levels
332 	* @param _gemAttackConversion gem to attack conversion
333 	* @param _gemDefenseConversion gem to defense conversion
334 	* @param _gemHpConversion gem to hp conversion
335 	* @param _gemSpeedConversion gem to speed conversion
336 	* @param _gemCriticalRateConversion gem to critical rate conversion
337 	* @param _goldPercentage percentage to get gold card
338 	* @param _silverPercentage percentage to get silver card
339 	* @param _eventCardRangeMin event card hash range start (inclusive)
340 	* @param _eventCardRangeMax event card hash range end (inclusive)	
341 	* @param _newMaxBattleRounds maximum battle rounds
342 	*/
343 	function setSettingValues(  uint8 _upgradeGems,
344 	uint8 _upgradeGemsSpecial,
345 	uint16 _gemAttackConversion,
346 	uint16 _gemDefenseConversion,
347 	uint16 _gemHpConversion,
348 	uint16 _gemSpeedConversion,
349 	uint16 _gemCriticalRateConversion,
350 	uint8 _goldPercentage,
351 	uint8 _silverPercentage,
352 	uint32 _eventCardRangeMin,
353 	uint32 _eventCardRangeMax,
354 	uint8 _newMaxBattleRounds) external onlyOwner {
355 		require(_eventCardRangeMax >= _eventCardRangeMin, "range max must be larger or equals range min" );
356 		require(_eventCardRangeMax<100000000, "range max cannot exceed 99999999");
357 		require((_newMaxBattleRounds <= 128) && (_newMaxBattleRounds >0), "battle rounds must be between 0 and 128");
358 		upgradeGems = _upgradeGems;
359 		upgradeGemsSpecial = _upgradeGemsSpecial;
360 		gemAttackConversion = _gemAttackConversion;
361 		gemDefenseConversion = _gemDefenseConversion;
362 		gemHpConversion = _gemHpConversion;
363 		gemSpeedConversion = _gemSpeedConversion;
364 		gemCriticalRateConversion = _gemCriticalRateConversion;
365 		goldPercentage = _goldPercentage;
366 		silverPercentage = _silverPercentage;
367 		eventCardRangeMin = _eventCardRangeMin;
368 		eventCardRangeMax = _eventCardRangeMax;
369 		maxBattleRounds = _newMaxBattleRounds;
370 	}
371 	
372 	
373 	// @dev function to allow contract owner to change the price (in wei) per card draw
374 	function setStarterPack(uint256 _newStarterPackPrice, uint16 _newStarterPackCardLevel) external onlyOwner {
375 		require(_newStarterPackCardLevel<=20, "starter pack level cannot exceed 20"); //starter pack level cannot exceed 20
376 		starterPackPrice = _newStarterPackPrice;
377 		starterPackCardLevel = _newStarterPackCardLevel;		
378 	} 	
379 	
380 	// @dev function to allow contract owner to enable/disable starter pack sale
381 	function setStarterPackOnSale(bool _newStarterPackOnSale) external onlyOwner {
382 		starterPackOnSale = _newStarterPackOnSale;
383 	}
384 	
385 	// @dev function to allow contract owner to start/stop the battle
386 	function setBattleStart(bool _newBattleStart) external onlyOwner {
387 		battleStart = _newBattleStart;
388 	}
389 	
390 	// @dev function to allow contract owner to change the price (in wei) per card draw
391 	function setCardDrawPrice(uint256 _newCardDrawPrice) external onlyOwner {
392 		cardDrawPrice = _newCardDrawPrice;
393 	}
394 	
395 	// @dev function to allow contract owner to change the referrer fee (in %, eg 3.75% is 375)
396 	function setReferrerFee(uint256 _newReferrerFee) external onlyOwner {
397 		referrerFee = _newReferrerFee;
398 	}
399 
400 	// @dev function to allow contract owner to change the challenge fee (in wei)
401 	function setChallengeFee(uint256 _newChallengeFee) external onlyOwner {
402 		challengeFee = _newChallengeFee;
403 	}
404 
405 	// @dev function to allow contract owner to change the upgrade fee (in wei)
406 	function setUpgradeFee(uint256 _newUpgradeFee) external onlyOwner {
407 		upgradeFee = _newUpgradeFee;
408 	}
409 	
410 	// @dev function to allow contract owner to change the avatar fee (in wei)
411 	function setAvatarFee(uint256 _newAvatarFee) external onlyOwner {
412 		avatarFee = _newAvatarFee;
413 	}
414 	
415 	// @dev function to allow contract owner to change the developer cut (%) divide by 100
416 	function setDeveloperCut(uint256 _newDeveloperCut) external onlyOwner {
417 		developerCut = _newDeveloperCut;
418 	}
419 		
420 	function getTotalDeveloperCut() external view onlyOwner returns (uint256) {
421 		return totalDeveloperCut;
422 	}
423 		
424 	function getTotalRankTokens() external view returns (uint256) {
425 		return totalRankTokens;
426 	}
427 	
428 	
429 	/***********************************************************************************/
430 	/* GET SETTINGS FUNCTION
431 	/***********************************************************************************/	
432 	/**
433 	* @dev get upgrade gems and conversion ratios of each field
434 	* @return _upgradeGems upgrade gems for normal levels
435 	* @return _upgradeGemsSpecial upgrade gems for every n levels
436 	* @return _gemAttackConversion gem to attack conversion
437 	* @return _gemDefenseConversion gem to defense conversion
438 	* @return _gemHpConversion gem to hp conversion
439 	* @return _gemSpeedConversion gem to speed conversion
440 	* @return _gemCriticalRateConversion gem to critical rate conversion
441 	*/
442 	function getSettingValues() external view returns(  uint8 _upgradeGems,
443 															uint8 _upgradeGemsSpecial,
444 															uint16 _gemAttackConversion,
445 															uint16 _gemDefenseConversion,
446 															uint16 _gemHpConversion,
447 															uint16 _gemSpeedConversion,
448 															uint16 _gemCriticalRateConversion,
449 															uint8 _maxBattleRounds)
450 	{
451 		_upgradeGems = uint8(upgradeGems);
452 		_upgradeGemsSpecial = uint8(upgradeGemsSpecial);
453 		_gemAttackConversion = uint16(gemAttackConversion);
454 		_gemDefenseConversion = uint16(gemDefenseConversion);
455 		_gemHpConversion = uint16(gemHpConversion);
456 		_gemSpeedConversion = uint16(gemSpeedConversion);
457 		_gemCriticalRateConversion = uint16(gemCriticalRateConversion);
458 		_maxBattleRounds = uint8(maxBattleRounds);
459 	}
460 		
461 
462 }
463 
464 /***********************************************************************************/
465 /* RANDOM GENERATOR
466 /***********************************************************************************/
467 contract Random {
468 	uint private pSeed = block.number;
469 
470 	function getRandom() internal returns(uint256) {
471 		return (pSeed = uint(keccak256(abi.encodePacked(pSeed,
472 		blockhash(block.number - 1),
473 		blockhash(block.number - 3),
474 		blockhash(block.number - 5),
475 		blockhash(block.number - 7))
476 		)));
477 	}
478 }
479 
480 /***********************************************************************************/
481 /* CORE BATTLE CONTRACT
482 /***********************************************************************************/
483 /**
484 * Omits fallback to prevent accidentally sending ether to this contract
485 */
486 contract Battle is BattleBase, Random, Pausable {
487 
488 	/***********************************************************************************/
489 	/* CONSTRUCTOR
490 	/***********************************************************************************/
491 	// @dev Contructor for Battle Contract
492 	constructor(address _tokenAddress) public {
493 		HogSmashToken candidateContract = HogSmashToken(_tokenAddress);
494 		// Set the new contract address
495 		hogsmashToken = candidateContract;
496 		
497 		starterPackPrice = 30000000000000000;
498 		starterPackCardLevel = 5;
499 		starterPackOnSale = true; // start by selling starter pack
500 		
501 		challengeFee = 10000000000000000;
502 		
503 		upgradeFee = 10000000000000000;
504 		
505 		avatarFee = 50000000000000000;
506 		
507 		developerCut = 375;
508 		
509 		referrerFee = 2000;
510 		
511 		cardDrawPrice = 15000000000000000;
512  		
513 		battleStart = true;
514  		
515 		paused = false; //default contract paused
516 				
517 		totalDeveloperCut = 0; //init to 0
518 	}
519 	
520 	/***********************************************************************************/
521 	/* MODIFIER
522 	/***********************************************************************************/
523 	/**
524 	* @dev Guarantees msg.sender is owner of the given token
525 	* @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
526 	*/
527 	modifier onlyOwnerOf(uint256 _tokenId) {
528 		require(hogsmashToken.ownerOf(_tokenId) == msg.sender, "must be owner of token");
529 		_;
530 	}
531 		
532 	
533 	/***********************************************************************************/
534 	/* GAME FUNCTIONS
535 	/***********************************************************************************/
536 	/**
537 	* @dev External function for getting info of card
538 	* @param _id card id of target query card
539 	* @return information of the card
540 	*/
541 	function getCard(uint256 _id) external view returns (
542 	uint256 cardId,
543 	address owner,
544 	uint8 element,
545 	uint16 level,
546 	uint32[] stats,
547 	uint32 currentExp,
548 	uint32 expToNextLevel,
549 	uint256 cardHash,
550 	uint64 createdDatetime,
551 	uint256 rank
552 	) {
553 		cardId = _id;
554 		
555 		owner = hogsmashToken.ownerOf(_id);
556 		
557 		Card storage card = cards[_id];
558 		
559 		uint32[] memory tempStats = new uint32[](6);
560 
561 		element = uint8(card.element);
562 		level = uint16(card.level);
563 		tempStats[0] = uint32(card.attack);
564 		tempStats[1] = uint32(card.defense);
565 		tempStats[2] = uint32(card.hp);
566 		tempStats[3] = uint32(card.speed);
567 		tempStats[4] = uint16(card.criticalRate);
568 		tempStats[5] = uint32(card.flexiGems);
569 		stats = tempStats;
570 		currentExp = uint32(card.currentExp);
571 		expToNextLevel = uint32(card.expToNextLevel);
572 		cardHash = uint256(card.cardHash);
573 		createdDatetime = uint64(card.createdDatetime);
574 		rank = uint256(card.rank);
575 	}
576 	
577 	
578 	/**
579 	* @dev External function for querying card Id at rank (zero based)
580 	* @param _rank zero based rank of the card
581 	* @return id of the card at the rank
582 	*/
583 	function getCardIdByRank(uint256 _rank) external view returns(uint256 cardId) {
584 		return ranking[_rank];
585 	}
586 	
587 
588 	/**
589 	* @dev External function for drafting new card
590 	* @return uint of cardId
591 	*/
592 	function draftNewCard() external payable whenNotPaused returns (uint256) {
593 		require(msg.value == cardDrawPrice, "fee must be equal to draw price"); //make sure the fee is enough for drafting a new card`
594 				
595 		require(address(marketplace) != address(0), "marketplace not set"); //need to set up marketplace before drafting new cards is allowed
596 				
597 		hogsmashToken.setApprovalForAllByContract(msg.sender, marketplace, true); //let marketplace have approval for escrow if the card goes on sale
598 		
599 		totalDeveloperCut = totalDeveloperCut.add(cardDrawPrice);
600 		
601 		return _createCard(msg.sender, 1); //level 1 cards
602 	}
603 	
604 	/**
605 	* @dev External function for drafting new card
606 	* @return uint of cardId
607 	*/
608 	function draftNewCardWithReferrer(address referrer) external payable whenNotPaused returns (uint256 cardId) {
609 		require(msg.value == cardDrawPrice, "fee must be equal to draw price"); //make sure the fee is enough for drafting a new card`
610 				
611 		require(address(marketplace) != address(0), "marketplace not set"); //need to set up marketplace before drafting new cards is allowed
612 				
613 		hogsmashToken.setApprovalForAllByContract(msg.sender, marketplace, true); //let marketplace have approval for escrow if the card goes on sale
614 		
615 		cardId = _createCard(msg.sender, 1); //level 1 cards
616 		
617 		if ((referrer != address(0)) && (referrerFee!=0) && (referrer!=msg.sender) && (hogsmashToken.balanceOf(referrer)>0)) {
618 			uint256 referrerCut = msg.value.mul(referrerFee)/10000;
619 			require(referrerCut<=msg.value, "referre cut cannot be larger than fee");
620 			referrer.transfer(referrerCut);
621 			totalDeveloperCut = totalDeveloperCut.add(cardDrawPrice.sub(referrerCut));
622 		} else {
623 			totalDeveloperCut = totalDeveloperCut.add(cardDrawPrice);
624 		}		
625 	}
626 	
627 
628 	/**
629 	* @dev External function for leveling up
630 	* @param _id card id of target query card
631 	* @param _attackLevelUp gems allocated to each attribute for upgrade
632 	* @param _defenseLevelUp gems allocated to each attribute for upgrade
633 	* @param _hpLevelUp gems allocated to each attribute for upgrade
634 	* @param _speedLevelUp gems allocated to each attribute for upgrade
635 	* @param _criticalRateLevelUp gems allocated to each attribute for upgrade
636 	* @param _flexiGemsLevelUp are gems allocated to each attribute for upgrade
637 	*/
638 	function levelUp( 	uint256 _id,
639 						uint16 _attackLevelUp,
640 						uint16 _defenseLevelUp,
641 						uint16 _hpLevelUp,
642 						uint16 _speedLevelUp,
643 						uint16 _criticalRateLevelUp,
644 						uint16 _flexiGemsLevelUp) external payable whenNotPaused onlyOwnerOf(_id) {
645 		require(
646 		_attackLevelUp >= 0        &&
647 		_defenseLevelUp >= 0       &&
648 		_hpLevelUp >= 0            &&
649 		_speedLevelUp >= 0         &&
650 		_criticalRateLevelUp >= 0  &&
651 		_flexiGemsLevelUp >= 0, "level up attributes must be more than 0"
652 		); //make sure all upgrade attributes will not be negative
653 
654 		require(msg.value == upgradeFee, "fee must be equals to upgrade price"); //make sure the fee is enough for upgrade
655 
656 		Card storage card = cards[_id];		
657 		require(card.currentExp==card.expToNextLevel, "exp is not max yet for level up"); //reject if currentexp not maxed out
658 		
659 		require(card.level < 65535, "card level maximum has reached"); //make sure level is not maxed out, although not likely
660 		
661 		require((card.criticalRate + (_criticalRateLevelUp * gemCriticalRateConversion))<=7000, "critical rate max of 70 has reached"); //make sure criticalrate is not upgraded when it reaches 70 to prevent waste
662 
663 		uint totalInputGems = _attackLevelUp + _defenseLevelUp + _hpLevelUp;
664 		totalInputGems += _speedLevelUp + _criticalRateLevelUp + _flexiGemsLevelUp;
665 		
666 		uint16 numOfSpecials = 0;
667 				
668 		//Cater for initial high level cards but have not leveled up before
669 		if ((card.level > 1) && (card.attack==1) && (card.defense==1) && (card.hp==3) && (card.speed==1) && (card.criticalRate==25) && (card.flexiGems==1)) {
670 			numOfSpecials = (card.level+1)/5; //auto floor to indicate how many Ns for upgradeGemsSpecial; cardlevel +1 is the new level
671 			uint totalGems = (numOfSpecials * upgradeGemsSpecial) + (((card.level) - numOfSpecials) * upgradeGems);
672 			require(totalInputGems==totalGems, "upgrade gems not used up"); //must use up all gems when upgrade
673 		} else {
674 			if (((card.level+1)%5)==0) { //special gem every 5 levels
675 				require(totalInputGems==upgradeGemsSpecial, "upgrade gems not used up"); //must use up all gems when upgrade	
676 				numOfSpecials = 1;
677 			} else {
678 				require(totalInputGems==upgradeGems, "upgrade gems not used up"); //must use up all gems when upgrade
679 			}
680 		}
681 		
682 		totalDeveloperCut = totalDeveloperCut.add(upgradeFee);
683 		
684 		//start level up process
685 		_upgradeLevel(_id, _attackLevelUp, _defenseLevelUp, _hpLevelUp, _speedLevelUp, _criticalRateLevelUp, _flexiGemsLevelUp, numOfSpecials);
686 								
687 		emit LevelUp(_id);
688 	}
689 
690 	function _upgradeLevel( uint256 _id,
691 							uint16 _attackLevelUp,
692 							uint16 _defenseLevelUp,
693 							uint16 _hpLevelUp,
694 							uint16 _speedLevelUp,
695 							uint16 _criticalRateLevelUp,
696 							uint16 _flexiGemsLevelUp,
697 							uint16 numOfSpecials) private {
698 		Card storage card = cards[_id];
699 		uint16[] memory extraStats = new uint16[](5); //attack, defense, hp, speed, flexigem
700 		if (numOfSpecials>0) { //special gem every 5 levels
701 			if (card.cardHash%100 >= 70) { //6* or 7* cards
702 				uint cardType = (uint(card.cardHash/10000000000))%100; //0-99
703 				if (cardType < 20) {
704 					extraStats[0]+=numOfSpecials;
705 				} else if (cardType < 40) {
706 					extraStats[1]+=numOfSpecials;
707 				} else if (cardType < 60) {
708 					extraStats[2]+=numOfSpecials;
709 				} else if (cardType < 80) {
710 					extraStats[3]+=numOfSpecials;
711 				} else {
712 					extraStats[4]+=numOfSpecials;
713 				}
714 				
715 				if (card.cardHash%100 >=90) { //7* cards			
716 					uint cardTypeInner = cardType%10; //0-9
717 					if (cardTypeInner < 2) {
718 						extraStats[0]+=numOfSpecials;
719 					} else if (cardTypeInner < 4) {
720 						extraStats[1]+=numOfSpecials;
721 					} else if (cardTypeInner < 6) {
722 						extraStats[2]+=numOfSpecials;
723 					} else if (cardTypeInner < 8) {
724 						extraStats[3]+=numOfSpecials;
725 					} else {
726 						extraStats[4]+=numOfSpecials;
727 					}
728 				}
729 			}
730 		}
731 		card.attack += (_attackLevelUp + extraStats[0]) * gemAttackConversion;
732 		card.defense += (_defenseLevelUp + extraStats[1]) * gemDefenseConversion;
733 		card.hp += (_hpLevelUp + extraStats[2]) * gemHpConversion;
734 		card.speed += (_speedLevelUp + extraStats[3]) * gemSpeedConversion;		
735 		card.criticalRate += uint16(_criticalRateLevelUp * gemCriticalRateConversion);
736 		card.flexiGems += _flexiGemsLevelUp + extraStats[4]; // turn Gem into FlexiGem
737 		card.level += 1; //level + 1
738 
739 		card.currentExp = 0; //reset exp
740 		//card.expToNextLevel = card.level*100 + max(0,card.level-8) * (1045/1000)**card.level;
741 		uint256 tempExpLevel = card.level;
742 		if (tempExpLevel > expToNextLevelArr.length) {
743 			tempExpLevel = expToNextLevelArr.length; //cap it at max level exp
744 		}
745 		card.expToNextLevel = expToNextLevelArr[tempExpLevel];
746 	}
747 
748 	function max(uint a, uint b) private pure returns (uint) {
749 		return a > b ? a : b;
750 	}
751 
752 	function challenge( uint256 _challengerCardId,
753 						uint32[5] _statUp, //0-attack, 1-defense, 2-hp, 3-speed, 4-criticalrate
754 						uint256 _defenderCardId,						
755 						uint256 _defenderRank,
756 						uint16 _defenderLevel) external payable whenNotPaused onlyOwnerOf(_challengerCardId) {
757 		require(battleStart != false, "battle has not started"); //make sure the battle has started
758 		require(msg.sender != hogsmashToken.ownerOf(_defenderCardId), "cannot challenge own cards"); //make sure user doesn't attack his own cards
759 		Card storage challenger = cards[_challengerCardId];		
760 		require((_statUp[0] + _statUp[1] + _statUp[2] + _statUp[3] + _statUp[4])==challenger.flexiGems, "flexi gems not used up"); //flexi points must be exactly used, not more not less
761 		
762 		Card storage defender = cards[_defenderCardId];
763 		
764 		if (defender.rank != _defenderRank) {
765 			emit RejectChallenge(_challengerCardId, _defenderCardId, _defenderRank, 1, uint256(block.number));
766 			(msg.sender).transfer(msg.value);		
767 			return;
768 		}
769 		
770 		if (defender.level != _defenderLevel) {
771 			emit RejectChallenge(_challengerCardId, _defenderCardId, _defenderRank, 2, uint256(block.number));
772 			(msg.sender).transfer(msg.value);
773 			return;
774 		}
775 		
776 		uint256 requiredChallengeFee = challengeFee;
777 		if (defender.rank <150) { //0-149 rank within 150
778 			requiredChallengeFee = requiredChallengeFee.mul(2);
779 		}
780 		require(msg.value == requiredChallengeFee, "fee must be equals to challenge price"); //challenge fee to challenge defender
781 		
782 		uint256 developerFee = 0;
783 		if (msg.value > 0) {
784 			developerFee = _calculateFee(msg.value);
785 		}
786 		
787 		uint256[] memory stats = new uint256[](14); //challengerattack, challengerdefense, challengerhp, challengerspeed, challengercritical, defendercritical, defenderhp, finalWinner
788 
789 		stats[0] = challenger.attack + (_statUp[0] * gemAttackConversion);
790 		stats[1] = challenger.defense + (_statUp[1] * gemDefenseConversion);
791 		stats[2] = challenger.hp + (_statUp[2] * gemHpConversion);
792 		stats[3] = challenger.speed + (_statUp[3] * gemSpeedConversion);
793 		stats[4] = challenger.criticalRate + (_statUp[4] * gemCriticalRateConversion);
794 		stats[5] = defender.criticalRate;
795 		stats[6] = defender.hp;
796 		stats[8] = challenger.hp + (_statUp[2] * gemHpConversion); //challenger hp for record purpose
797 		stats[9] = challenger.rank; //for looting
798 		stats[10] = defender.rank; //for looting
799 		stats[11] = 0; //tokensGained
800 		stats[12] = _challengerCardId;
801 		stats[13] = _defenderCardId;
802 
803 		//check challenger critical rate
804 		if (stats[4]>7000) {
805 			stats[4] = 7000; //hard cap at 70 critical rate
806 		}
807 
808 		//check defender critical rate
809 		if (stats[5]>7000) {
810 			stats[5] = 7000; //hard cap at 70 critical rate
811 		}
812 
813 		// 1 - fire; 2 - water; 3 - wood;    8 - light; 9 - dark;
814 		if (((challenger.element-1) == defender.element) || ((challenger.element==1) && (defender.element==3)) || ((challenger.element==8) && (defender.element==9))) {
815 			stats[4] += 3000; //30% critical rate increase for challenger
816 			if (stats[4]>8000) {
817 				stats[4] = 8000; //hard cap at 80 critical rate for element advantage
818 			}
819 		}
820 
821 		if (((defender.element-1) == challenger.element) || ((defender.element==1) && (challenger.element==3)) || ((defender.element==8) && (challenger.element==9))) {
822 			stats[5] += 3000; //30% critical rate increase for defender
823 			if (stats[5]>8000) {
824 				stats[5] = 8000; //hard cap at 80 critical rate for element advantage
825 			}
826 		}
827 		
828 		uint256 battleSequence = _simulateBattle(challenger, defender, stats);
829 		
830 		stats[11] = _transferFees(_challengerCardId, stats, developerFee);	
831 		
832 		
833 		emit BattleHistory(
834 			historyId,
835 			uint8(stats[7]),
836 			uint64(now),
837 			uint256(battleSequence),
838 			uint256(block.number),
839 			uint256(stats[11])
840 		);
841 		
842 		emit BattleHistoryChallenger(
843 			historyId,
844 			uint256(_challengerCardId),
845 			uint8(challenger.element),
846 			uint16(challenger.level),
847 			uint32(stats[0]),
848 			uint32(stats[1]),
849 			uint32(stats[8]),
850 			uint32(stats[3]),
851 			uint16(stats[4]), //pretty sure trimming down the uint won't affect the number as max is just 80000
852 			uint256(stats[9])
853 		);
854 			
855 		emit BattleHistoryDefender(	
856 			historyId,
857 			uint256(_defenderCardId),
858 			uint8(defender.element),
859 			uint16(defender.level),
860 			uint32(defender.attack),
861 			uint32(defender.defense),
862 			uint32(defender.hp),
863 			uint32(defender.speed),
864 			uint16(stats[5]),
865 			uint256(stats[10])
866 		);
867 		
868 		historyId = historyId.add(1); //add one for next history
869 	}
870 	
871 	function _addBattleSequence(uint8 attackType, uint8 rounds, uint256 battleSequence) private pure returns (uint256) {
872 		// Assumed rounds 0-based; attackType is 0xB (B:0,1,2,3), i.e. the last 2 bits is the value with other bits zeros
873 		uint256 mask = 0x3;
874 		mask = ~(mask << 2*rounds);
875 		uint256 newSeq = battleSequence & mask;
876 
877 		newSeq = newSeq | (uint256(attackType) << 2*rounds);
878 
879 		return newSeq;
880 	}
881 
882 
883 	function _simulateBattle(Card storage challenger, Card storage defender, uint[] memory stats) private returns (uint256 battleSequence) {
884 	
885 		bool continueBattle = true;
886 		uint8 currentAttacker = 0; //0 challenger, 1 defender
887 		uint256 tempAttackStrength;
888 		uint8 battleRound = 0;
889 		if (!_isChallengerAttackFirst(stats[3], defender.speed)){
890 			currentAttacker = 1;
891 		}
892 		while (continueBattle) {
893 			if (currentAttacker==0) { //challenger attack
894 				if (_rollCriticalDice() <= stats[4]){
895 					tempAttackStrength = stats[0] * 2; //critical hit
896 					battleSequence = _addBattleSequence(2, battleRound, battleSequence); //move sequence to left and add record
897 				} else {
898 					tempAttackStrength = stats[0]; //normal hit
899 					battleSequence = _addBattleSequence(0, battleRound, battleSequence); //move sequence to left and add record
900 				}
901 				if (tempAttackStrength <= defender.defense) {
902 					tempAttackStrength = 1; //at least deduct 1 hp
903 				} else {
904 					tempAttackStrength -= defender.defense;
905 				}
906 				if (stats[6] <= tempAttackStrength) {
907 					stats[6] = 0; //do not let it overflow
908 				} else {
909 					stats[6] -= tempAttackStrength; //defender hp
910 				}
911 				currentAttacker = 1; //defender turn up next
912 			} else if (currentAttacker==1) { //defender attack
913 				if (_rollCriticalDice() <= stats[5]){
914 					tempAttackStrength = defender.attack * 2; //critical hit
915 					battleSequence = _addBattleSequence(3, battleRound, battleSequence); //move sequence to left and add record
916 				} else {
917 					tempAttackStrength = defender.attack; //normal hit
918 					battleSequence = _addBattleSequence(1, battleRound, battleSequence); //move sequence to left and add record
919 				}
920 				if (tempAttackStrength <= stats[1]) {
921 					tempAttackStrength = 1; //at least deduct 1 hp
922 				} else {
923 					tempAttackStrength -= stats[1];
924 				}
925 				if (stats[2] <= tempAttackStrength) {
926 					stats[2] = 0; //do not let it overflow
927 				} else {
928 					stats[2] -= tempAttackStrength; //challenger hp
929 				}
930 				currentAttacker = 0; //challenger turn up next
931 			}
932 			battleRound ++;
933 
934 			if ((battleRound>=maxBattleRounds) || (stats[6]<=0) || (stats[2]<=0)){
935 				continueBattle = false; //end battle
936 			}
937 		}
938 
939 		uint32 challengerGainExp = 0;
940 		uint32 defenderGainExp = 0;
941 
942 		//calculate Exp
943 		if (challenger.level == defender.level) { //challenging a same level card
944 			challengerGainExp = activeWinExp[10];
945 		} else if (challenger.level > defender.level) { //challenging a lower level card
946 			if ((challenger.level - defender.level) >= 11) {
947 				challengerGainExp = 1; //defender too weak, grant only 1 exp
948 			} else {
949 				//challengerGainExp = (((1 + ((defender.level - challenger.level)/10))**2) + (1/10)) * baseExp;
950 				challengerGainExp = activeWinExp[10 + defender.level - challenger.level]; //0 - 9
951 			}
952 		} else if (challenger.level < defender.level) { //challenging a higher level card
953 			//challengerGainExp = ((1 + ((defender.level - challenger.level)/10)**(3/2))) * baseExp;
954 			uint256 levelDiff = defender.level - challenger.level;
955 			if (levelDiff > 20) {
956 				levelDiff = 20; //limit level difference to 20 as max exp gain
957 			}
958 			challengerGainExp = activeWinExp[10+levelDiff];
959 		}
960 		
961 		if (stats[2] == stats[6]) { //challenger hp = defender hp
962 			stats[7] = 2; //draw
963 			//No EXP when draw
964 		} else if (stats[2] > stats[6]) { //challenger hp > defender hp
965 			stats[7] = 0; //challenger wins
966 			if (defender.rank < challenger.rank) { //swap ranks
967 				ranking[defender.rank] = stats[12]; //update ranking table position
968 				ranking[challenger.rank] = stats[13]; //update ranking table position
969 				uint256 tempRank = defender.rank;
970 				defender.rank = challenger.rank; //update rank on card
971 				challenger.rank = tempRank; //update rank on card
972 			}
973 
974 			//award Exp
975 			//active win
976 			challenger.currentExp += challengerGainExp;
977 			if (challenger.currentExp > challenger.expToNextLevel) {
978 				challenger.currentExp = challenger.expToNextLevel; //cap it at max exp for level up
979 			}
980 
981 			//passive lose
982 			//defenderGainExp = challengerGainExp*35/100*30/100 + (5/10);
983 			defenderGainExp = ((challengerGainExp*105/100) + 5)/10; // 30% of 35% + round up
984 			if (defenderGainExp <= 0) {
985 				defenderGainExp = 1; //at least 1 Exp
986 			}
987 			defender.currentExp += defenderGainExp;
988 			if (defender.currentExp > defender.expToNextLevel) {
989 				defender.currentExp = defender.expToNextLevel; //cap it at max exp for level up
990 			}
991 
992 		} else if (stats[6] > stats[2]) { //defender hp > challenger hp
993 			stats[7] = 1; //defender wins
994 			//award Exp
995 			//active lose
996 			uint32 tempChallengerGain = challengerGainExp*35/100; //35% of winning
997 			if (tempChallengerGain <= 0) {
998 				tempChallengerGain = 1; //at least 1 Exp
999 			}
1000 			challenger.currentExp += tempChallengerGain; //35% of winning
1001 			if (challenger.currentExp > challenger.expToNextLevel) {
1002 				challenger.currentExp = challenger.expToNextLevel; //cap it at max exp for level up
1003 			}
1004 
1005 			//passive win
1006 			defenderGainExp = challengerGainExp*30/100;
1007 			if (defenderGainExp <= 0) {
1008 				defenderGainExp = 1; //at least 1 Exp
1009 			}
1010 			defender.currentExp += defenderGainExp;
1011 			if (defender.currentExp > defender.expToNextLevel) {
1012 				defender.currentExp = defender.expToNextLevel; //cap it at max exp for level up
1013 			}
1014 		}
1015 		
1016 		return battleSequence;
1017 	}
1018 	
1019 	
1020 	
1021 	function _transferFees(uint256 _challengerCardId, uint[] stats, uint256 developerFee) private returns (uint256 totalGained) {
1022 		totalDeveloperCut = totalDeveloperCut.add(developerFee);		
1023 		uint256 remainFee = msg.value.sub(developerFee); //minus developer fee
1024 		totalGained = 0;
1025 		if (stats[7] == 1) { //challenger loses			
1026 			// put all of challenger fee in rankTokens (minus developerfee of course)			
1027 			rankTokens[stats[10]] = rankTokens[stats[10]].add(remainFee);
1028 			totalRankTokens = totalRankTokens.add(remainFee);
1029 		} else { //draw or challenger wins
1030 			address challengerAddress = hogsmashToken.ownerOf(_challengerCardId); //get address of card owner
1031 			if (stats[7] == 0) { //challenger wins				
1032 				if (stats[9] > stats[10]) { //challenging a higher ranking defender					
1033 					//1. get tokens from defender rank if defender rank is higher
1034 					if (rankTokens[stats[10]] > 0) {
1035 						totalGained = totalGained.add(rankTokens[stats[10]]);
1036 						totalRankTokens = totalRankTokens.sub(rankTokens[stats[10]]);
1037 						rankTokens[stats[10]] = 0;						
1038 					}
1039 					//2. get self rank tokens if moved to higher rank
1040 					if (rankTokens[stats[9]] > 0) {
1041 						totalGained = totalGained.add(rankTokens[stats[9]]);
1042 						totalRankTokens = totalRankTokens.sub(rankTokens[stats[9]]);
1043 						rankTokens[stats[9]] = 0;
1044 					}					
1045 				} else { //challenging a lower ranking defender					
1046 					if (stats[9]<50) { //rank 1-50 gets to get self rank tokens and lower rank (within 150) tokens if win
1047 						if ((stats[10] < 150) && (rankTokens[stats[10]] > 0)) { // can get defender rank tokens if defender rank within top 150 (0-149)
1048 							totalGained = totalGained.add(rankTokens[stats[10]]);
1049 							totalRankTokens = totalRankTokens.sub(rankTokens[stats[10]]);
1050 							rankTokens[stats[10]] = 0;
1051 						}
1052 						
1053 						if ((stats[10] < 150) && (rankTokens[stats[9]] > 0)) { //can get self rank tokens if defender rank within top 150
1054 							totalGained = totalGained.add(rankTokens[stats[9]]);
1055 							totalRankTokens = totalRankTokens.sub(rankTokens[stats[9]]);
1056 							rankTokens[stats[9]] = 0;
1057 						}
1058 					}
1059 				}
1060 				challengerAddress.transfer(totalGained.add(remainFee)); //give back challenge fee untouched + total gained				
1061 			} else { //draw
1062 				challengerAddress.transfer(remainFee); //give back challenge fee untouched
1063 			} 
1064 		}			
1065 	}
1066 	
1067 
1068 	function _rollCriticalDice() private returns (uint16 result){
1069 		return uint16((getRandom() % 10000) + 1); //get 1 to 10000
1070 	}
1071 
1072 	function _isChallengerAttackFirst(uint _challengerSpeed, uint _defenderSpeed ) private returns (bool){
1073 		uint8 randResult = uint8((getRandom() % 100) + 1); //get 1 to 100
1074 		uint challengerChance = (((_challengerSpeed * 10 ** 3) / (_challengerSpeed + _defenderSpeed))+5) / 10;//round
1075 		if (randResult <= challengerChance) {
1076 			return true;
1077 		} else {
1078 			return false;
1079 		}
1080 	}
1081 
1082 	
1083 	/// @dev function to buy starter package, with card and tokens directly from contract
1084 	function buyStarterPack() external payable whenNotPaused returns (uint256){
1085 		require(starterPackOnSale==true, "starter pack is not on sale");
1086 		require(msg.value==starterPackPrice, "fee must be equals to starter pack price");
1087 		require(address(marketplace) != address(0), "marketplace not set"); //need to set up marketplace before drafting new cards is allowed
1088 		
1089 		totalDeveloperCut = totalDeveloperCut.add(starterPackPrice);
1090 				
1091 		hogsmashToken.setApprovalForAllByContract(msg.sender, marketplace, true); //let marketplace have approval for escrow if the card goes on sale
1092 		
1093 		return _createCard(msg.sender, starterPackCardLevel); //level n cards
1094 	}
1095 		
1096 	/**
1097 	* @dev Create card function
1098 	* @param _to The address that will own the minted card
1099 	* @param _initLevel The level to start with, usually 1
1100 	* @return uint256 ID of the new card
1101 	*/
1102 	function _createCard(address _to, uint16 _initLevel) private returns (uint256) {
1103 		require(_to != address(0), "cannot create card for unknown address"); //check if address is not 0 (the origin address)
1104 
1105 		currentElement+= 1;
1106 		if (currentElement==4) {
1107 			currentElement = 8;
1108 		}
1109 		if (currentElement == 10) {
1110 			currentElement = 1;
1111 		}
1112 		uint256 tempExpLevel = _initLevel;
1113 		if (tempExpLevel > expToNextLevelArr.length) {
1114 			tempExpLevel = expToNextLevelArr.length; //cap it at max level exp
1115 		}
1116 		
1117 		uint32 tempCurrentExp = 0;
1118 		if (_initLevel>1) { //let exp max out so that user can level up the card according to preference
1119 			tempCurrentExp = expToNextLevelArr[tempExpLevel];
1120 		}
1121 		
1122 		uint256 tokenId = hogsmashToken.mint(_to);
1123 		
1124 		// use memory as this is a temporary variable, cheaper and will not be stored since cards store all of them
1125 		Card memory _card = Card({
1126 			element: currentElement, // 1 - fire; 2 - water; 3 - wood;    8 - light; 9 - dark;
1127 			level: _initLevel, // level
1128 			attack: 1, // attack,
1129 			defense: 1, // defense,
1130 			hp: 3, // hp,
1131 			speed: 1, // speed,
1132 			criticalRate: 25, // criticalRate
1133 			flexiGems: 1, // flexiGems,
1134 			currentExp: tempCurrentExp, // currentExp,
1135 			expToNextLevel: expToNextLevelArr[tempExpLevel], // expToNextLevel,
1136 			cardHash: generateHash(),
1137 			createdDatetime :uint64(now),
1138 			rank: tokenId // rank
1139 		});
1140 		
1141 		cards[tokenId] = _card;
1142 		ranking.push(tokenId); //push to ranking mapping
1143 		
1144 		emit CardCreated(msg.sender, tokenId);
1145 
1146 		return tokenId;
1147 	}
1148 	
1149 	function generateHash() private returns (uint256 hash){
1150 		hash = uint256((getRandom()%1000000000000)/10000000000);		
1151 		hash = hash.mul(10000000000);
1152 		
1153 		uint256 tempHash = ((getRandom()%(eventCardRangeMax-eventCardRangeMin+1))+eventCardRangeMin)*100;
1154 		hash = hash.add(tempHash);
1155 		
1156 		tempHash = getRandom()%100;
1157 		
1158 		if (tempHash < goldPercentage) {
1159 			hash = hash.add(90);
1160 		} else if (tempHash < (goldPercentage+silverPercentage)) {
1161 			hash = hash.add(70);
1162 		} else {
1163 			hash = hash.add(50);
1164 		}
1165 	}
1166 	
1167 	/// @dev function to update avatar hash 
1168 	function updateAvatar(uint256 _cardId, uint256 avatarHash) external payable whenNotPaused onlyOwnerOf(_cardId) {
1169 		require(msg.value==avatarFee, "fee must be equals to avatar price");
1170 				
1171 		Card storage card = cards[_cardId];
1172 		
1173 		uint256 tempHash = card.cardHash%1000000000000; //retain hash fixed section
1174 		
1175 		card.cardHash = tempHash.add(avatarHash.mul(1000000000000));
1176 		
1177 		emit HashUpdated(_cardId, card.cardHash);		
1178 	}
1179 		
1180 	
1181 	/// @dev Compute developer's fee
1182 	/// @param _challengeFee - transaction fee
1183 	function _calculateFee(uint256 _challengeFee) internal view returns (uint256) {
1184 		return developerCut.mul(_challengeFee/10000);
1185 	}
1186 	
1187 	
1188 	/***********************************************************************************/
1189 	/* ADMIN FUNCTIONS
1190 	/***********************************************************************************/	
1191 	/**
1192 	* @dev External function for drafting new card for Owner, for promotional purposes
1193 	* @param _cardLevel initial level of card created, must be less or equals to 20
1194 	* @return uint of cardId
1195 	*/
1196 	function generateInitialCard(uint16 _cardLevel) external whenNotPaused onlyOwner returns (uint256) {
1197 		require(address(marketplace) != address(0), "marketplace not set"); //need to set up marketplace before drafting new cards is allowed
1198 		require(_cardLevel<=20, "maximum level cannot exceed 20"); //set maximum level at 20 that Owner can generate
1199 		
1200 		hogsmashToken.setApprovalForAllByContract(msg.sender, marketplace, true); //let marketplace have approval for escrow if the card goes on sale
1201 
1202 		return _createCard(msg.sender, _cardLevel); //level 1 cards
1203 	}
1204 	
1205 	/// @dev Function for contract owner to put tokens into ranks for events
1206 	function distributeTokensToRank(uint[] ranks, uint256 tokensPerRank) external payable onlyOwner {
1207 		require(msg.value == (tokensPerRank*ranks.length), "tokens must be enough to distribute among ranks");
1208 		uint i;
1209 		for (i=0; i<ranks.length; i++) {
1210 			rankTokens[ranks[i]] = rankTokens[ranks[i]].add(tokensPerRank);
1211 			totalRankTokens = totalRankTokens.add(tokensPerRank);
1212 		}
1213 	}
1214 	
1215 	
1216 	// @dev Allows contract owner to withdraw the all developer cut from the contract
1217 	function withdrawBalance() external onlyOwner {
1218 		address thisAddress = this;
1219 		uint256 balance = thisAddress.balance;
1220 		uint256 withdrawalSum = totalDeveloperCut;
1221 
1222 		if (balance >= withdrawalSum) {
1223 			totalDeveloperCut = 0;
1224 			owner.transfer(withdrawalSum);
1225 		}
1226 	}
1227 }
1228 
1229 /***********************************************************************************/
1230 /* INTERFACES
1231 /***********************************************************************************/
1232 interface Marketplace {
1233 	function isMarketplace() external returns (bool);
1234 }
1235 
1236 interface HogSmashToken {
1237 	function ownerOf(uint256 _tokenId) external view returns (address);
1238 	function balanceOf(address _owner) external view returns (uint256);
1239 	function tokensOf(address _owner) external view returns (uint256[]);
1240 	function mint(address _to) external returns (uint256 _tokenId);
1241 	function setTokenURI(uint256 _tokenId, string _uri) external;
1242 	function setApprovalForAllByContract(address _sender, address _to, bool _approved) external;
1243 }