1 pragma solidity ^0.4.18;
2 
3 contract PoP{
4 	using SafeMath for uint256;
5 	using SafeInt for int256;
6 	using Player for Player.Data;
7 	using BettingRecordArray for BettingRecordArray.Data;
8 	using WrappedArray for WrappedArray.Data;
9 	using FixedPoint for FixedPoint.Data;
10 
11 	// Contract Info
12 	string public name;
13   	string public symbol;
14   	uint8 public decimals;
15   	address private author;
16 	
17   	// Events for Game
18   	event Bet(address player, uint256 betAmount, uint256 betNumber, uint256 gameNumber);
19 	event Withdraw(address player, uint256 amount, uint256 numberOfRecordsProcessed);
20 	event EndGame(uint256 currentGameNumber);	
21 
22 	// Events for Coin
23 	event Transfer(address indexed from, address indexed to, uint256 value);
24 	event Approval(address indexed owner, address indexed spender, uint256 value);
25 	event Burn(address indexed burner, uint256 value);
26 	event Mined(address indexed miner, uint256 value);
27 
28 	// Init
29 	function PoP() public {
30 		name = "PopCoin"; 
31     	symbol = "PoP"; 
32     	decimals = 18;
33     	author = msg.sender;
34     	totalSupply_ = 10000000 * 10 ** uint256(decimals);
35     	lastBetBlockNumber = 0;
36     	currentGameNumber = 0;
37     	currentPot = 0;
38     	initialSeed = 0;
39 		minimumWager = kBaseMinBetSize.toUInt256Raw();
40     	minimumNumberOfBlocksToEndGame = kLowerBoundBlocksTillGameEnd.add(kUpperBoundBlocksTillGameEnd).toUInt256Raw();
41     	gameHasStarted = false;
42     	currentMiningDifficulty = FixedPoint.fromInt256(kStartingGameMiningDifficulty);
43 		unPromisedSupplyAtStartOfCurrentGame_ = totalSupply_;
44 		currentPotSplit = 1000;
45 
46 		nextGameMaxBlock = kUpperBoundBlocksTillGameEnd;
47 		nextGameMinBlock = kLowerBoundBlocksTillGameEnd;
48     	currentGameInitialMinBetSize = kBaseMinBetSize;
49     	nextGameInitialMinBetSize = currentGameInitialMinBetSize;
50 
51     	nextFrontWindowAdjustmentRatio = frontWindowAdjustmentRatio;
52     	nextBackWindowAdjustmentRatio = backWindowAdjustmentRatio;
53     	nextGameSeedPercent = percentToTakeAsSeed;
54     	nextGameRakePercent = percentToTakeAsRake;
55     	nextGameDeveloperMiningPower = developerMiningPower;
56     	nextGamePotSplit = currentPotSplit;
57 
58     	// Initialize Dev Permissions
59     	canUpdateNextGameInitalMinBetSize = true;
60 		canUpdateFrontWindowAdjustmentRatio = true;
61 		canUpdateBackWindowAdjustmentRatio = true;
62 		canUpdateNextGamePotSplit = true;
63 		canUpdatePercentToTakeAsSeed = true;
64 		canUpdateNextGameMinAndMaxBlockUntilGameEnd = true;
65 		canUpdateAmountToTakeAsRake = true;
66 		canUpdateDeveloperMiningPower = true;
67 	}
68 
69 
70 	// Constants
71 	FixedPoint.Data _2pi = FixedPoint.Data({val: 26986075409});
72 	FixedPoint.Data _pi = FixedPoint.Data({val: 13493037704});
73 	FixedPoint.Data kBackPayoutEndPointInitial = FixedPoint.fromFraction(1, 2);
74 	FixedPoint.Data kFrontPayoutStartPointInitial = FixedPoint.fromFraction(1, 2);
75 	uint256 public percentToTakeAsRake = 500; // MC
76 	uint256 public percentToTakeAsSeed = 900; // MC
77 	uint256 public developerMiningPower = 3000; // MC
78 	uint256 constant kTotalPercent = 10000; 
79 	uint8 constant kStartingGameMiningDifficulty = 1;
80 	uint256 potSplitMax = 2000;
81 	uint8 constant kDifficultyWindow = 10; // MC
82 	FixedPoint.Data kDifficultyDropOffFactor = FixedPoint.fromFraction(8, 10); // MC
83 	uint256 constant kWeiConstant = 10 ** 18;
84 	FixedPoint.Data kExpectedFirstGameSize = FixedPoint.fromInt256(Int256(10 * kWeiConstant));
85 	FixedPoint.Data kExpectedPopCoinToBePromisedPercent = FixedPoint.fromFraction(1, 1000); // MC
86 	FixedPoint.Data kLowerBoundBlocksTillGameEnd = FixedPoint.fromInt256(6); // MC
87 	FixedPoint.Data kUpperBoundBlocksTillGameEnd = FixedPoint.fromInt256(80); // MC
88 	FixedPoint.Data kBaseMinBetSize = FixedPoint.fromInt256(Int256(kWeiConstant/1000)); 
89 	FixedPoint.Data kMaxPopMiningPotMultiple = FixedPoint.fromFraction(118709955, 1000000); // MC
90 
91 
92 	// Public Variables
93 	uint256 public lastBetBlockNumber;
94 	uint256 public minimumNumberOfBlocksToEndGame;
95 	uint256 public currentPot;
96 	uint256 public currentGameNumber;
97 	FixedPoint.Data currentMiningDifficulty;
98 	uint256 public initialSeed;
99 	uint256 public bonusSeed;
100 	uint256 public minimumWager;
101 	uint256 public currentBetNumber;
102 	uint256 public nextGameSeedPercent;
103 	uint256 public nextGameRakePercent;
104 	uint256 public nextGameDeveloperMiningPower;
105 	uint256 public currentPotSplit;
106 	uint256 public nextGamePotSplit;
107 
108 	// Game Private Variables
109 	mapping (address => Player.Data) playerCollection;
110 	BettingRecordArray.Data currentGameBettingRecords;
111 	WrappedArray.Data gameMetaData;
112 	mapping (address => uint256) playerInternalWallet;
113 	FixedPoint.Data public initialBankrollGrowthAmount; // This is what the current pot will be compared to
114 	FixedPoint.Data public nextGameInitialMinBetSize;
115 	FixedPoint.Data currentGameInitialMinBetSize;
116 	FixedPoint.Data public nextGameMaxBlock;
117 	FixedPoint.Data public nextGameMinBlock;
118 
119 	FixedPoint.Data public frontWindowAdjustmentRatio = FixedPoint.fromFraction(13, 10); // MC: 
120 	FixedPoint.Data public backWindowAdjustmentRatio = FixedPoint.fromFraction(175, 100); // MC: 
121 	FixedPoint.Data public nextFrontWindowAdjustmentRatio;
122 	FixedPoint.Data public nextBackWindowAdjustmentRatio;
123 
124 	// Coin Private Variables
125 	mapping(address => uint256) popBalances;
126 	mapping (address => mapping (address => uint256)) internal allowed;
127 	uint256 totalSupply_;
128 	uint256 supplyMined_;
129 	uint256 supplyBurned_;
130 	uint256 unPromisedSupplyAtStartOfCurrentGame_;
131 	bool gameHasStarted;
132 
133 
134 	// Dev Permission Control over Game Variables
135 	bool public canUpdateNextGameInitalMinBetSize;
136 	bool public canUpdateFrontWindowAdjustmentRatio;
137 	bool public canUpdateBackWindowAdjustmentRatio;
138 	bool public canUpdateNextGamePotSplit;
139 	bool public canUpdatePercentToTakeAsSeed;
140 	bool public canUpdateNextGameMinAndMaxBlockUntilGameEnd;
141 	bool public canUpdateAmountToTakeAsRake;
142 	bool public canUpdateDeveloperMiningPower;
143 
144 	function turnOffCanUpdateNextGameInitalMinBetSize () public {
145 		require (msg.sender == author);
146 		require (canUpdateNextGameInitalMinBetSize == true);
147 		canUpdateNextGameInitalMinBetSize = false;
148 	}
149 
150 	function turnOffCanUpdateFrontWindowAdjustmentRatio () public {
151 		require (msg.sender == author);
152 		require (canUpdateFrontWindowAdjustmentRatio == true);
153 		canUpdateFrontWindowAdjustmentRatio = false;
154 	}
155 
156 	function turnOffCanUpdateBackWindowAdjustmentRatio () public {
157 		require (msg.sender == author);
158 		require (canUpdateBackWindowAdjustmentRatio == true);
159 		canUpdateBackWindowAdjustmentRatio = false;
160 	}
161 
162 	function turnOffCanUpdateNextGamePotSplit () public {
163 		require (msg.sender == author);
164 		require (canUpdateNextGamePotSplit == true);
165 		canUpdateNextGamePotSplit = false;
166 	}
167 
168 	function turnOffCanUpdatePercentToTakeAsSeed () public {
169 		require (msg.sender == author);
170 		require (canUpdatePercentToTakeAsSeed == true);
171 		canUpdatePercentToTakeAsSeed = false;
172 	}
173 
174 	function turnOffCanUpdateNextGameMinAndMaxBlockUntilGameEnd () public {
175 		require (msg.sender == author);
176 		require (canUpdateNextGameMinAndMaxBlockUntilGameEnd == true);
177 		canUpdateNextGameMinAndMaxBlockUntilGameEnd = false;
178 	}
179 
180 	function turnOffCanUpdateAmountToTakeAsRake () public {
181 		require (msg.sender == author);
182 		require (canUpdateAmountToTakeAsRake == true);
183 		canUpdateAmountToTakeAsRake = false;
184 	}
185 
186 	function turnOffCanUpdateDeveloperMiningPower () public {
187 		require (msg.sender == author);
188 		require (canUpdateDeveloperMiningPower == true);
189 		canUpdateDeveloperMiningPower = false;
190 	}
191 	
192 	
193 	function balanceOfContract () public constant returns(uint256 res)   {
194 		return address(this).balance;
195 	}
196 
197 	function getCurrentGameInitialMinBetSize () public view returns(uint256 res)  {
198 		return currentGameInitialMinBetSize.toUInt256Raw();
199 	}
200 	
201 
202 	function startGame () payable public {
203 		require (msg.sender == author);
204 		require (msg.value > 0);
205 		require (gameHasStarted == false);
206 		
207 		initialSeed = initialSeed.add(msg.value);
208 		currentPot = initialSeed;
209 		gameHasStarted = true;
210 	}
211 	
212 	function updateNextGameInitalMinBetSize (uint256 nextGameMinBetSize) public {
213 		require (msg.sender == author);
214 		require (canUpdateNextGameInitalMinBetSize == true);
215 		require (nextGameMinBetSize > 0);
216 		FixedPoint.Data memory nextMinBet = FixedPoint.fromInt256(Int256(nextGameMinBetSize));
217 
218 		// Cant change the min bet too much in between games
219 		require(nextMinBet.cmp(currentGameInitialMinBetSize.mul(FixedPoint.fromInt256(2))) != 1);
220 		require(nextMinBet.cmp(currentGameInitialMinBetSize.div(FixedPoint.fromInt256(2))) != -1);
221 		
222 		nextGameInitialMinBetSize = FixedPoint.fromInt256(Int256(nextGameMinBetSize));
223 	}
224 
225 	function updateNextWindowAdjustmentRatio (int256 numerator, bool updateFront) public {
226 		require (msg.sender == author);
227 		require (numerator >= 1000);
228 		require (numerator <= 2718);
229 		require ((updateFront && canUpdateFrontWindowAdjustmentRatio) || (!updateFront && canUpdateBackWindowAdjustmentRatio));
230 
231 		if(updateFront == true) {
232 			nextFrontWindowAdjustmentRatio = FixedPoint.fromFraction(numerator, 1000);
233 		} else {
234 			nextBackWindowAdjustmentRatio = FixedPoint.fromFraction(numerator, 1000);
235 		}
236 	}
237 
238 	function updateNextGamePotSplit (uint256 potSplit ) public {
239 		require (msg.sender == author);
240 		require (canUpdateNextGamePotSplit);
241 		require (potSplit <= 2000);
242 		nextGamePotSplit = potSplit;
243 	}
244 
245 	function updatePercentToTakeAsSeed (uint256 value) public {
246 		require (msg.sender == author);
247 		require (canUpdatePercentToTakeAsSeed);
248 		require (value < 10000);
249 		if (value > percentToTakeAsSeed){
250 			require (value / percentToTakeAsSeed == 1);
251 		} else {
252 			require (percentToTakeAsSeed / value == 1);
253 		}
254 
255 		nextGameSeedPercent = value;
256 	}
257 
258 	function updateNextGameMinAndMaxBlockUntilGameEnd (uint256 maxBlocks, uint256 minBlocks) public {
259 		require (msg.sender == author);
260 		require (canUpdateNextGameMinAndMaxBlockUntilGameEnd);
261 		require (maxBlocks > 0);
262 		require (minBlocks > 0);
263 		FixedPoint.Data memory nextMaxBlock = FixedPoint.fromInt256(Int256(maxBlocks));
264 		FixedPoint.Data memory nextMinBlock = FixedPoint.fromInt256(Int256(minBlocks));
265 		require(nextMaxBlock.cmp(kUpperBoundBlocksTillGameEnd.mul(FixedPoint.fromInt256(2))) != 1);
266 		require(nextMaxBlock.cmp(kUpperBoundBlocksTillGameEnd.div(FixedPoint.fromInt256(2))) != -1);
267 		require(nextMinBlock.cmp(kLowerBoundBlocksTillGameEnd.mul(FixedPoint.fromInt256(2))) != 1);
268 		require(nextMaxBlock.cmp(kLowerBoundBlocksTillGameEnd.div(FixedPoint.fromInt256(2))) != -1);
269 
270 		nextGameMaxBlock = FixedPoint.fromInt256(Int256(maxBlocks));
271 		nextGameMinBlock = FixedPoint.fromInt256(Int256(minBlocks));
272 	}
273 
274 	function getUpperBoundBlocksTillGameEnd() public view returns(uint256) {
275 		return kUpperBoundBlocksTillGameEnd.toUInt256Raw();
276 
277 	}
278 
279 	function getLowerBoundBlocksTillGameEnd() public view returns(uint256) {
280 		return kLowerBoundBlocksTillGameEnd.toUInt256Raw();
281 	}
282 
283 	function addToRakePool () public payable{
284 		assert (msg.value > 0);
285 		playerInternalWallet[this] = playerInternalWallet[this].add(msg.value);
286 	}
287 
288 	// Public API
289 	function bet () payable public {
290 		// require bet be large enough
291 		require(msg.value >= minimumWager); 
292 		require(gameHasStarted);
293 
294 		uint256 betAmount = msg.value;
295 
296 		// take rake
297 		betAmount = betAmountAfterRakeHasBeenWithdrawnAndProcessed(betAmount);
298 
299 		if((block.number.sub(lastBetBlockNumber) >= minimumNumberOfBlocksToEndGame) && (lastBetBlockNumber != 0)) {
300 			processEndGame(betAmount);
301 		} else if (lastBetBlockNumber == 0) {
302 			initialBankrollGrowthAmount = FixedPoint.fromInt256(Int256(betAmount.add(initialSeed)));
303 		}
304 
305 		emit Bet(msg.sender, betAmount, currentBetNumber, currentGameNumber);
306 
307 		Player.BettingRecord memory newBetRecord = Player.BettingRecord(msg.sender, currentGameNumber, betAmount, currentBetNumber, currentPot.sub(initialSeed), 0, 0, true); 
308 
309 		Player.Data storage currentPlayer = playerCollection[msg.sender];
310 
311 		currentPlayer.insertBettingRecord(newBetRecord);
312 
313 		Player.BettingRecord memory oldGameUnprocessedBettingRecord = currentGameBettingRecords.getNextRecord();
314 
315 		currentGameBettingRecords.pushRecord(newBetRecord);
316 
317 		if(oldGameUnprocessedBettingRecord.isActive == true) {
318 			processBettingRecord(oldGameUnprocessedBettingRecord);
319 		}
320 
321 		currentPot = currentPot.add(betAmount);
322 		currentBetNumber = currentBetNumber.add(1);
323 		lastBetBlockNumber = block.number;
324 		FixedPoint.Data memory currentGameSize = FixedPoint.fromInt256(Int256(currentPot));
325 		FixedPoint.Data memory expectedGameSize = currentMiningDifficulty.mul(kExpectedFirstGameSize);
326 		minimumNumberOfBlocksToEndGame = calcNumberOfBlocksUntilGameEnds(currentGameSize, expectedGameSize).toUInt256Raw();
327 		minimumWager = calcMinimumBetSize(currentGameSize, expectedGameSize).toUInt256Raw();
328 	}
329 
330 	function getMyBetRecordCount() public view returns(uint256) {
331 		Player.Data storage currentPlayer = playerCollection[msg.sender];
332 		return currentPlayer.unprocessedBettingRecordCount();
333 	}
334 
335 	function getDeveloperMiningPowerForGameId (uint256 gameId) private view returns(uint256 res) {
336 		if(gameId == currentGameNumber) {
337 			return developerMiningPower;
338 		} else {
339 			WrappedArray.GameMetaDataElement memory elem = gameMetaData.itemAtIndex(gameId);
340 			return elem.developerMiningPower;
341 		}
342 	}
343 
344 	function playerPopMining(uint256 recordIndex, bool onlyCurrentGame) public view returns(uint256) {
345 		Player.Data storage currentPlayer = playerCollection[msg.sender];
346 		Player.BettingRecord memory playerBettingRecord = currentPlayer.getBettingRecordAtIndex(recordIndex);
347 		return computeAmountToMineForBettingRecord(playerBettingRecord, onlyCurrentGame).mul(kTotalPercent - getDeveloperMiningPowerForGameId(playerBettingRecord.gameId)).div(kTotalPercent);
348 	}
349 
350 	function getBetRecord(uint256 recordIndex) public view returns(uint256, uint256, uint256) {
351 		Player.Data storage currentPlayer = playerCollection[msg.sender];
352 		Player.BettingRecord memory bettingRecord = currentPlayer.getBettingRecordAtIndex(recordIndex);
353 		return (bettingRecord.gamePotBeforeBet, bettingRecord.wagerAmount, bettingRecord.gameId);
354 	}
355 
356 	function withdraw (uint256 withdrawCount) public returns(bool res) {
357 		Player.Data storage currentPlayer = playerCollection[msg.sender];
358 
359 		uint256 playerBettingRecordCount = currentPlayer.unprocessedBettingRecordCount();
360 		uint256 numberOfIterations = withdrawCount < playerBettingRecordCount ? withdrawCount : playerBettingRecordCount;
361 		numberOfIterations = numberOfIterations == 0 ? 0 : numberOfIterations.add(1);
362 
363 		for (uint256 i = 0 ; i < numberOfIterations; i = i.add(1)) {
364 			Player.BettingRecord memory unprocessedRecord = currentPlayer.getNextRecord();
365 			processBettingRecord(unprocessedRecord);
366 		}
367 
368 		uint256 playerBalance = playerInternalWallet[msg.sender];
369 
370 		playerInternalWallet[msg.sender] = 0;
371 
372 		if(playerBalance == 0) {
373 			return true;
374 		}
375 
376 		emit Withdraw(msg.sender, playerBalance, numberOfIterations);
377 
378 		if(!msg.sender.send(playerBalance)) {
379 			//If money shipment fails store money back in the container
380 			playerInternalWallet[msg.sender] = playerBalance;
381 			return false;
382 		}
383 		return true;
384 	}
385 
386 
387 	function getCurrentMiningDifficulty() public view returns(uint256){
388 		return UInt256(currentMiningDifficulty.toInt256());
389 	}
390 
391 	function getPlayerInternalWallet() public view returns(uint256) {
392 		return playerInternalWallet[msg.sender];
393 	}
394 
395 	function getWinningsForRecordId(uint256 recordIndex, bool onlyWithdrawable, bool onlyCurrentGame) public view returns(uint256) {
396 		Player.Data storage currentPlayer = playerCollection[msg.sender];
397 		Player.BettingRecord memory record = currentPlayer.getBettingRecordAtIndex(recordIndex);
398 		if(onlyCurrentGame && record.gameId != currentGameNumber) {
399 			return 0;
400 		}
401 		return getWinningsForRecord(record, onlyWithdrawable);
402 	}
403 
404 	function getWinningsForRecord(Player.BettingRecord record, bool onlyWithdrawable) private view returns(uint256) {
405 
406 		if(onlyWithdrawable && recordIsTooNewToProcess(record)) {
407 			return 0;
408 		}
409 
410 		uint256 payout = getPayoutForPlayer(record).toUInt256Raw();
411 		uint256 seedPercentForGame = getSeedPercentageForGameId(record.gameId);
412 		payout = payout.sub(amountToSeedNextRound(payout, seedPercentForGame));
413 		return payout.sub(record.withdrawnAmount);
414 
415 	}
416 
417 	function totalAmountRaked ()  public constant returns(uint256 res) {
418 		return playerInternalWallet[this];
419 	}
420 
421 	function betAmountAfterRakeHasBeenWithdrawnAndProcessed (uint256 betAmount) private returns(uint256 betLessRake){
422 		uint256 amountToRake = amountToTakeAsRake(betAmount);
423 		playerInternalWallet[this] = playerInternalWallet[this].add(amountToRake);
424 		return betAmount.sub(amountToRake);
425 	}
426 
427 	function getSeedPercentageForGameId (uint256 gameId) private view returns(uint256 res) {
428 		if(gameId == currentGameNumber) {
429 			return percentToTakeAsSeed;
430 		} else {
431 			WrappedArray.GameMetaDataElement memory elem = gameMetaData.itemAtIndex(gameId);
432 			return elem.percentToTakeAsSeed;
433 		}
434 	}
435 
436 	function amountToSeedNextRound (uint256 value, uint256 seedPercent) private pure returns(uint256 res) {
437 		return value.mul(seedPercent).div(kTotalPercent);
438 	}
439 
440 	function addToBonusSeed () public payable {
441 		require (msg.value > 0);
442 		bonusSeed = bonusSeed.add(msg.value);
443 	}
444 
445 	function updateAmountToTakeAsRake(uint256 value) public {
446 		require (msg.sender == author);
447 		require (canUpdateAmountToTakeAsRake);
448 		require (value < 10000);
449 		if(percentToTakeAsRake > value) {
450 			require(percentToTakeAsRake - value <= 100);
451 		} else {
452 			require(value - percentToTakeAsRake <= 100);
453 		}
454 
455 		nextGameRakePercent = value;
456 	}
457 
458 	function updateDeveloperMiningPower(uint256 value) public {
459 		require (msg.sender == author);
460 		require (canUpdateDeveloperMiningPower);
461 		require (value <= 3000);
462 		nextGameDeveloperMiningPower = value;
463 	}
464 
465 	function amountToTakeAsRake (uint256 value) private view returns(uint256 res) {
466 		return value.mul(percentToTakeAsRake).div(kTotalPercent);
467 	}
468 	
469 	function processEndGame (uint256 lastBetAmount) private {
470 		// The order of these function calls are dependent on each other
471 		// Beware when changing order or modifying code 
472 		emit EndGame(currentGameNumber);
473 		// Store game meta Data
474 		gameMetaData.push(WrappedArray.GameMetaDataElement(currentPot, initialSeed, initialBankrollGrowthAmount.toUInt256Raw(), unPromisedSupplyAtStartOfCurrentGame_, developerMiningPower, percentToTakeAsSeed, percentToTakeAsRake, currentPotSplit, currentMiningDifficulty, frontWindowAdjustmentRatio, backWindowAdjustmentRatio, true)); // totalPotAmount, seedAmount, initialBet, popremaining, miningDifficulty, isActive
475 
476 		frontWindowAdjustmentRatio = nextFrontWindowAdjustmentRatio;
477 		backWindowAdjustmentRatio = nextBackWindowAdjustmentRatio;
478 
479 		currentGameInitialMinBetSize = nextGameInitialMinBetSize;
480 		kUpperBoundBlocksTillGameEnd = nextGameMaxBlock;
481 		kLowerBoundBlocksTillGameEnd = nextGameMinBlock;
482 
483 		unPromisedSupplyAtStartOfCurrentGame_ = unPromisedPop();
484 
485 		initialSeed = amountToSeedNextRound(currentPot, percentToTakeAsSeed).add(bonusSeed);
486 		bonusSeed = 0;
487 		currentPot = initialSeed;
488 		currentMiningDifficulty = calcDifficulty();
489 		percentToTakeAsSeed = nextGameSeedPercent;
490 		percentToTakeAsRake = nextGameRakePercent;
491 		developerMiningPower = nextGameDeveloperMiningPower;
492 		currentPotSplit = nextGamePotSplit;
493 		// Set initial bet which will calculate the growth factor 
494 		initialBankrollGrowthAmount = FixedPoint.fromInt256(Int256(lastBetAmount.add(initialSeed)));
495 
496 		// Reset current game array 
497 		currentGameBettingRecords.resetIndex();
498 
499 		// increment game number
500 		currentGameNumber = currentGameNumber.add(1);
501 	}
502 
503 	function processBettingRecord (Player.BettingRecord record) private {
504 		Player.Data storage currentPlayer = playerCollection[record.playerAddress];
505 		if(currentPlayer.containsBettingRecordFromId(record.bettingRecordId) == false) {
506 			return;
507 		}
508 		// Refetch record as player might have withdrawn part
509 		Player.BettingRecord memory bettingRecord = currentPlayer.getBettingRecordForId(record.bettingRecordId);
510 
511 		currentPlayer.deleteBettingRecordForId(bettingRecord.bettingRecordId);
512 
513 		// this assumes compute for value returns total value of record less withdrawnAmount
514 		uint256 bettingRecordValue = getWinningsForRecord(bettingRecord, true);
515 		uint256 amountToMineForBettingRecord = computeAmountToMineForBettingRecord(bettingRecord, false);
516 
517 		// If it is current game we need to not remove the record as it's value might increase but amend it and re-insert
518 		if(bettingRecord.gameId == currentGameNumber) {
519 			bettingRecord.withdrawnAmount = bettingRecord.withdrawnAmount.add(bettingRecordValue);
520 			bettingRecord.withdrawnPopAmount = bettingRecord.withdrawnPopAmount.add(amountToMineForBettingRecord);
521 			currentPlayer.insertBettingRecord(bettingRecord);
522 		}
523 		minePoP(bettingRecord.playerAddress, amountToMineForBettingRecord, bettingRecord.gameId);
524 		playerInternalWallet[bettingRecord.playerAddress] = playerInternalWallet[bettingRecord.playerAddress].add(bettingRecordValue);
525 	}
526 
527 	
528 	function recordIsTooNewToProcess (Player.BettingRecord record) private view returns(bool res) {
529 
530 		if(record.gameId == currentGameNumber) {
531 			return true;
532 		}
533 		return false;
534 	}
535 
536 	function UInt256 (int256 elem) private pure returns(uint256 res) {
537 		assert(elem >= 0);
538 		return uint256(elem);
539 	}
540 	
541 	function Int256 (uint256 elem) private pure returns(int256 res) {
542 		assert(int256(elem) >= 0);
543 		return int256(elem);
544 	}
545 	
546 	function getBankRollGrowthForGameId (uint256 gameId) private view returns(FixedPoint.Data res) {
547 		if(gameId == currentGameNumber) {
548 			return FixedPoint.fromInt256(Int256(currentPot)).div(initialBankrollGrowthAmount);
549 		} else {
550 			WrappedArray.GameMetaDataElement memory elem = gameMetaData.itemAtIndex(gameId);
551 			return FixedPoint.fromInt256(Int256(elem.totalPotAmount)).div(FixedPoint.fromInt256(Int256(elem.initialBet)));
552 		}
553 	}
554 
555 	function getSeedAmountForGameId (uint256 gameId) private view returns(FixedPoint.Data res) {
556 		if(gameId == currentGameNumber) {
557 			return FixedPoint.fromInt256(Int256(initialSeed));
558 		} else {
559 			WrappedArray.GameMetaDataElement memory elem = gameMetaData.itemAtIndex(gameId);
560 			return FixedPoint.fromInt256(Int256(elem.seedAmount));
561 		}
562 	}
563 
564 	function getWindowAdjRatioForGameId (uint256 gameId, bool isFront) internal view returns(FixedPoint.Data) {
565 		if(gameId == currentGameNumber) {
566 			return isFront == true ? frontWindowAdjustmentRatio : backWindowAdjustmentRatio;
567 		} else {
568 			WrappedArray.GameMetaDataElement memory elem = gameMetaData.itemAtIndex(gameId);
569 			return isFront == true ? elem.frontWindowAdjustmentRatio : elem.backWindowAdjustmentRatio;
570 		}
571 	}
572 
573 	function getSplitPotAsFixedPointForGameId (uint256 gameId, bool isFront) internal view returns (FixedPoint.Data) {
574 		if(gameId == currentGameNumber) {
575 			if(isFront){
576 				return FixedPoint.fromFraction(Int256(currentPotSplit), 1000);
577 			} else {
578 				return FixedPoint.fromFraction(Int256(potSplitMax.sub(currentPotSplit)), 1000);
579 			}
580 		} else {
581 			WrappedArray.GameMetaDataElement memory elem = gameMetaData.itemAtIndex(gameId);
582 			if(isFront){
583 				return FixedPoint.fromFraction(Int256(elem.potSplit), 1000);
584 			} else {
585 				return FixedPoint.fromFraction(Int256(potSplitMax.sub(elem.potSplit)), 1000);
586 			}
587 		}
588 	}
589 
590 	function getAdjustedPotAsFixedPointForGameId (uint256 gameId, bool isFront) internal view returns (FixedPoint.Data) {
591 		return getPotAsFixedPointForGameId(gameId).mul(getSplitPotAsFixedPointForGameId(gameId, isFront));
592 	}
593 
594 	function getPayoutForPlayer(Player.BettingRecord playerRecord) internal view returns (FixedPoint.Data) {
595 
596 		FixedPoint.Data memory frontWindowAdjustment = getWindowAdjustmentForGameIdAndRatio(playerRecord.gameId, getWindowAdjRatioForGameId(playerRecord.gameId, true));
597 		FixedPoint.Data memory backWindowAdjustment = getWindowAdjustmentForGameIdAndRatio(playerRecord.gameId, getWindowAdjRatioForGameId(playerRecord.gameId, false));
598 		FixedPoint.Data memory backPayoutEndPoint = kBackPayoutEndPointInitial.div(backWindowAdjustment);
599 		FixedPoint.Data memory frontPayoutSizePercent = kFrontPayoutStartPointInitial.div(frontWindowAdjustment);
600         FixedPoint.Data memory frontPayoutStartPoint = FixedPoint.fromInt256(1).sub(frontPayoutSizePercent);
601 
602 		FixedPoint.Data memory frontPercent = FixedPoint.fromInt256(0);
603 		if(playerRecord.gamePotBeforeBet != 0) {
604 			frontPercent = FixedPoint.fromInt256(Int256(playerRecord.gamePotBeforeBet)).div(getPotAsFixedPointForGameId(playerRecord.gameId).sub(getSeedAmountForGameId(playerRecord.gameId)));
605 		}
606 
607 		FixedPoint.Data memory backPercent = FixedPoint.fromInt256(Int256(playerRecord.gamePotBeforeBet)).add(FixedPoint.fromInt256(Int256(playerRecord.wagerAmount))).div(getPotAsFixedPointForGameId(playerRecord.gameId).sub(getSeedAmountForGameId(playerRecord.gameId)));
608 
609 		if(frontPercent.val < backPayoutEndPoint.val) {
610 		    if(backPercent.val <= backPayoutEndPoint.val) {
611 		    	// Bet started in left half of curve and ended left half of curve 
612 		        return calcWinnings(frontPercent.div(backPayoutEndPoint), backPercent.div(backPayoutEndPoint), backWindowAdjustment, FixedPoint.fromInt256(0), playerRecord.gameId, false);
613 		    } else if (backPercent.val <= frontPayoutStartPoint.val) {
614 		    	// Bet started in left half of curve and ended in deadzone between curves
615 		        return calcWinnings(frontPercent.div(backPayoutEndPoint), backPayoutEndPoint.div(backPayoutEndPoint), backWindowAdjustment, FixedPoint.fromInt256(0), playerRecord.gameId, false);
616 		    } else {
617 		    	// Bet started in left half of curve and ended right half of curve 
618 		        return calcWinnings(frontPercent.div(backPayoutEndPoint), backPayoutEndPoint.div(backPayoutEndPoint), backWindowAdjustment, FixedPoint.fromInt256(0), playerRecord.gameId, false).add(calcWinnings(FixedPoint.fromInt256(0), backPercent.sub(frontPayoutStartPoint).div(frontPayoutSizePercent), frontWindowAdjustment, _pi.div(frontWindowAdjustment), playerRecord.gameId, true));
619 		    }
620 		} else if (frontPercent.val < frontPayoutStartPoint.val) {
621 		    if (backPercent.val <= frontPayoutStartPoint.val) {
622 		    	// Bet started in dead zone and ended in dead zone
623 		        return FixedPoint.fromInt256(0);
624 		    } else {
625 		    	// Bet started in deadzone and ended in right hand of curve
626 		        return calcWinnings(FixedPoint.fromInt256(0), backPercent.sub(frontPayoutStartPoint).div(frontPayoutSizePercent), frontWindowAdjustment, _pi.div(frontWindowAdjustment), playerRecord.gameId, true);
627 		    }
628 		} else {
629 			// Bet started in right hand of curve and of course ended in right hand of curve
630 		    return calcWinnings(frontPercent.sub(frontPayoutStartPoint).div(frontPayoutSizePercent), backPercent.sub(frontPayoutStartPoint).div(frontPayoutSizePercent), frontWindowAdjustment, _pi.div(frontWindowAdjustment), playerRecord.gameId, true);
631 		}
632 	}
633 
634 	function getWindowAdjustmentForGameIdAndRatio(uint256 gameId, FixedPoint.Data adjustmentRatio) internal view returns (FixedPoint.Data) {
635 		FixedPoint.Data memory growth = getBankRollGrowthForGameId(gameId);//FixedPoint.Data({val: brGrowth});
636 		FixedPoint.Data memory logGrowthRate = growth.ln();
637 		return growth.div(adjustmentRatio.pow(logGrowthRate));
638 	}
639 
640 	function integrate(FixedPoint.Data x, FixedPoint.Data a, FixedPoint.Data y) internal pure returns (FixedPoint.Data) {
641 		return a.mul(x).sin().div(a).add(x).sub(a.mul(y).sin().div(a).add(y));
642 	}
643 
644 	function calcWinnings(FixedPoint.Data playerFrontPercent, FixedPoint.Data playerBackPercent, FixedPoint.Data windowAdjustment, FixedPoint.Data sectionOffset, uint256 gameId, bool isFront) internal view returns (FixedPoint.Data) {
645 		FixedPoint.Data memory potSize = getAdjustedPotAsFixedPointForGameId(gameId, isFront);
646 		FixedPoint.Data memory startIntegrationPoint = sectionOffset.add(playerFrontPercent.mul(_pi.div(windowAdjustment)));
647 		FixedPoint.Data memory endIntegrationPoint = sectionOffset.add(playerBackPercent.mul(_pi.div(windowAdjustment)));
648 		return integrate(endIntegrationPoint, windowAdjustment, startIntegrationPoint).mul(potSize).mul(windowAdjustment).div(_2pi);
649 	}
650 
651     function computeAmountToMineForBettingRecord (Player.BettingRecord record, bool onlyCurrentGame) internal view returns(uint256 value) {
652 		if(onlyCurrentGame && record.gameId != currentGameNumber){
653 			return 0;
654 		}
655 
656 		uint256 payout = getPopPayoutForRecord(record).toUInt256Raw();
657 		return payout.sub(record.withdrawnPopAmount);
658     }
659 
660     function getPopPayoutForRecord(Player.BettingRecord record) private view returns(FixedPoint.Data value) {
661     	
662     	if(record.isActive == false) {
663     		return FixedPoint.fromInt256(0);
664     	}
665 
666     	return totalTokenPayout(getPotAsFixedPointForGameId(record.gameId).sub(getInitialSeedAsFixedPointForGameId(record.gameId)), getDifficultyAsFixedPointForGameId(record.gameId), getPopRemainingAsFixedPointForGameId(record.gameId), record.wagerAmount, record.gamePotBeforeBet); //uint256 gameId, uint256 wagerAmount, uint256 previousPotSize
667     }
668 
669     function unMinedPop () private view returns(uint256 res) {
670     	return totalSupply_.sub(supplyMined_);
671     }
672 
673     function promisedPop () private view returns(uint256) {
674     	FixedPoint.Data memory curPot = getPotAsFixedPointForGameId(currentGameNumber);
675     	FixedPoint.Data memory seed = getInitialSeedAsFixedPointForGameId(currentGameNumber);
676     	FixedPoint.Data memory difficulty = getDifficultyAsFixedPointForGameId(currentGameNumber);
677     	FixedPoint.Data memory unpromised = getPopRemainingAsFixedPointForGameId(currentGameNumber);
678 
679     	uint256 promisedPopThisGame = totalTokenPayout(curPot.sub(seed), difficulty, unpromised, currentPot.sub(seed.toUInt256Raw()), 0).toUInt256Raw(); 
680     	return totalSupply_.sub(unPromisedSupplyAtStartOfCurrentGame_).add(promisedPopThisGame);
681     }
682 
683     function unPromisedPop () private view returns(uint256 res) {
684     	return totalSupply_.sub(promisedPop());
685     }
686     
687     function potentiallyCirculatingPop () public view returns(uint256 res) {
688     	return promisedPop().sub(supplyBurned_);
689     }
690     
691     function minePoP(address target, uint256 amountToMine, uint256 gameId) private {
692     	if(supplyMined_ >= totalSupply_) { 
693     		return;
694     	}
695 
696     	uint256 remainingPop = unMinedPop();
697     	if(amountToMine == 0 || remainingPop == 0) {
698     		return;
699     	}
700 
701     	if(remainingPop < amountToMine) {
702     		amountToMine = remainingPop;
703     	}
704     	uint256 developerMined = amountToMine.mul(getDeveloperMiningPowerForGameId(gameId)).div(kTotalPercent);
705     	uint256 playerMined = amountToMine.sub(developerMined);
706 
707     	supplyMined_ = supplyMined_.add(amountToMine);
708     	
709         popBalances[target] = popBalances[target].add(playerMined);
710         popBalances[author] = popBalances[author].add(developerMined);
711 
712         emit Mined(target, playerMined);
713         emit Transfer(0, target, playerMined);
714         emit Mined(author, developerMined);
715         emit Transfer(0, author, developerMined);
716     }
717 
718     function redeemPop (uint256 popToRedeem) public returns(bool res) {
719     	require(popBalances[msg.sender] >= popToRedeem);
720     	require(popToRedeem != 0);
721 
722     	uint256 potentiallyAllocatedPop = potentiallyCirculatingPop();
723 
724     	FixedPoint.Data memory redeemRatio = popToRedeem < potentiallyAllocatedPop ? FixedPoint.fromFraction(Int256(popToRedeem), Int256(potentiallyAllocatedPop)) :  FixedPoint.fromInt256(1);
725     	FixedPoint.Data memory ethPayoutAmount = redeemRatio.mul(FixedPoint.fromInt256(Int256(totalAmountRaked())));
726     	uint256 payout = ethPayoutAmount.toUInt256Raw();
727     	require(payout<=totalAmountRaked());
728     	require(payout <= address(this).balance);
729     	
730     	burn(popToRedeem);
731     	playerInternalWallet[this] = playerInternalWallet[this].sub(payout);
732     	playerInternalWallet[msg.sender] = playerInternalWallet[msg.sender].add(payout);
733 
734     	return true;
735     }
736 
737     // Coin Functions
738     function totalSupply() public view returns (uint256) {
739 	    return promisedPop();
740 	}
741 
742 	function balanceOf(address _owner) public view returns (uint256 balance) {
743 		return popBalances[_owner];
744 	}
745 
746 	function transfer(address _to, uint256 _value) public returns (bool) {
747 	    require(_to != address(0));
748 	    require(_value <= popBalances[msg.sender]);
749 
750 	    // SafeMath.sub will throw if there is not enough balance.
751 	    popBalances[msg.sender] = popBalances[msg.sender].sub(_value);
752 	    popBalances[_to] = popBalances[_to].add(_value);
753 	    emit Transfer(msg.sender, _to, _value);
754 	    return true;
755 	}
756 
757 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
758 	    require(_to != address(0));
759 	    require(_value <= popBalances[_from]);
760 	    require(_value <= allowed[_from][msg.sender]);
761 
762 	    popBalances[_from] = popBalances[_from].sub(_value);
763 	    popBalances[_to] = popBalances[_to].add(_value);
764 	    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
765 	    emit Transfer(_from, _to, _value);
766 	    return true;
767 	}
768 
769 	function approve(address _spender, uint256 _value) public returns (bool) {
770 	    allowed[msg.sender][_spender] = _value;
771 	    emit Approval(msg.sender, _spender, _value);
772 	    return true;
773 	}
774 
775 	function allowance(address _owner, address _spender) public view returns (uint256) {
776 	    return allowed[_owner][_spender];
777 	}
778 
779 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
780 	    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
781 	    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
782 	    return true;
783 	}
784 
785 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
786 	    uint oldValue = allowed[msg.sender][_spender];
787 	    if (_subtractedValue > oldValue) {
788 	      allowed[msg.sender][_spender] = 0;
789 	    } else {
790 	      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
791 	    }
792 	    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
793 	    return true;
794 	}
795 
796 	function burn(uint256 _value) public {
797 	    require (popBalances[msg.sender] >= _value);
798 	    
799 	    address burner = msg.sender;
800 	    supplyBurned_ = supplyBurned_.add(_value);
801 	    popBalances[burner] = popBalances[burner].sub(_value);
802 	    emit Burn(burner, _value);
803 	}
804 
805 	function getInitialSeedAsFixedPointForGameId (uint256 gameId) private view returns(FixedPoint.Data res) {
806 		if(gameId == currentGameNumber) {
807 			return FixedPoint.fromInt256(Int256(initialSeed));
808 		} else {
809 			WrappedArray.GameMetaDataElement memory elem = gameMetaData.itemAtIndex(gameId);
810 			return FixedPoint.fromInt256(Int256(elem.seedAmount));
811 		}
812 	}
813 
814 	function getPotAsFixedPointForGameId (uint256 gameId) private view returns(FixedPoint.Data res) {
815 		if(gameId == currentGameNumber) {
816 			return FixedPoint.fromInt256(Int256(currentPot));
817 		} else {
818 			WrappedArray.GameMetaDataElement memory elem = gameMetaData.itemAtIndex(gameId);
819 			return FixedPoint.fromInt256(Int256(elem.totalPotAmount));
820 		}
821 	}
822 
823 	function getPopRemainingAsFixedPointForGameId (uint256 gameId) private view returns(FixedPoint.Data res) {
824 		if(gameId == currentGameNumber) {
825 			return FixedPoint.fromInt256(Int256(unPromisedSupplyAtStartOfCurrentGame_));
826 		} else {
827 			WrappedArray.GameMetaDataElement memory elem = gameMetaData.itemAtIndex(gameId);
828 			return FixedPoint.fromInt256(Int256(elem.coinsRemaining));
829 		}
830 	}
831 	
832 	function getDifficultyAsFixedPointForGameId (uint256 gameId) private view returns(FixedPoint.Data res) {
833 		if(gameId == currentGameNumber) {
834 			return currentMiningDifficulty;
835 		} else {
836 			WrappedArray.GameMetaDataElement memory elem = gameMetaData.itemAtIndex(gameId);
837 			return elem.miningDifficulty;
838 		}
839 	}
840 
841 	function calcDifficulty() private view returns (FixedPoint.Data) {
842 		FixedPoint.Data memory total = FixedPoint.fromInt256(0);
843 		FixedPoint.Data memory count = FixedPoint.fromInt256(0);
844 		uint256 j = 0;
845 		for(uint256 i=gameMetaData.length().sub(1) ; i>=0 && j<kDifficultyWindow; i = i.sub(1)){
846 			WrappedArray.GameMetaDataElement memory thisGame = gameMetaData.itemAtIndex(i);
847 			FixedPoint.Data memory thisGamePotSize = FixedPoint.fromInt256(Int256(thisGame.totalPotAmount));
848 			FixedPoint.Data memory thisCount = kDifficultyDropOffFactor.pow(FixedPoint.fromInt256(Int256(j)));
849 			total = total.add(thisCount.mul(thisGamePotSize));
850 			count = count.add(thisCount);
851 			j = j.add(1);
852 			if(i == 0) {
853 				break;
854 			}
855 		}
856 		
857 		return total.div(count).div(kExpectedFirstGameSize);
858 	}
859 
860 	function getBrAdj(FixedPoint.Data currentPotValue, FixedPoint.Data expectedGameSize) private pure returns (FixedPoint.Data) {
861 		if(currentPotValue.cmp(expectedGameSize) == -1) {
862 		    return expectedGameSize.div(currentPotValue).log10().neg();
863 		} else {
864 		    return currentPotValue.div(expectedGameSize).log10();
865 		}
866 	}
867 
868 	function getMiningRateAtPoint(FixedPoint.Data point, FixedPoint.Data difficulty, FixedPoint.Data currentPotValue, FixedPoint.Data coins_tbi) private view returns (FixedPoint.Data) {
869 		assert (point.cmp(currentPotValue) != 1);
870         FixedPoint.Data memory expectedGameSize = kExpectedFirstGameSize.mul(difficulty);
871 		FixedPoint.Data memory depositRatio = point.div(currentPotValue);
872 		FixedPoint.Data memory brAdj = getBrAdj(currentPotValue, expectedGameSize);
873 		if(brAdj.cmp(FixedPoint.fromInt256(0)) == -1) {
874 			return coins_tbi.mul(FixedPoint.fromInt256(1).div(FixedPoint.fromInt256(2).pow(brAdj.neg()))).mul(FixedPoint.fromInt256(2).sub(depositRatio));
875 		} else {
876 			return coins_tbi.mul(FixedPoint.fromInt256(2).pow(brAdj)).mul(FixedPoint.fromInt256(2).sub(depositRatio));
877 		}
878 	}
879 
880     function getExpectedGameSize() external view returns (int256) {
881         return kExpectedFirstGameSize.toInt256();
882     }
883 
884 	function totalTokenPayout(FixedPoint.Data currentPotValue, FixedPoint.Data difficulty, FixedPoint.Data unpromisedPopAtStartOfGame, uint256 wagerAmount, uint256 previousPotSize) private view returns (FixedPoint.Data) {
885 		FixedPoint.Data memory maxPotSize = kExpectedFirstGameSize.mul(difficulty).mul(kMaxPopMiningPotMultiple);
886 		FixedPoint.Data memory startPoint = FixedPoint.fromInt256(Int256(previousPotSize));
887 		if(startPoint.cmp(maxPotSize) != -1){ // startPoint >= maxPotSize
888 			return FixedPoint.fromInt256(0);
889 		}
890 		FixedPoint.Data memory endPoint = FixedPoint.fromInt256(Int256(previousPotSize + wagerAmount));
891 		if(endPoint.cmp(maxPotSize) != -1){
892 			endPoint = maxPotSize;
893 			wagerAmount = maxPotSize.sub(startPoint).toUInt256Raw();
894 		}
895 		if(currentPotValue.cmp(maxPotSize) != -1){
896 			currentPotValue = maxPotSize;
897 		}
898 
899 		FixedPoint.Data memory betSizePercent = FixedPoint.fromInt256(Int256(wagerAmount)).div(kExpectedFirstGameSize.mul(difficulty));
900 		FixedPoint.Data memory expectedCoinsToBeIssuedTwoThirds = FixedPoint.fromFraction(2, 3).mul(unpromisedPopAtStartOfGame.mul(kExpectedPopCoinToBePromisedPercent));
901 		return getMiningRateAtPoint(startPoint.add(endPoint).div(FixedPoint.fromInt256(2)), difficulty, currentPotValue, expectedCoinsToBeIssuedTwoThirds).mul(betSizePercent);
902 	}
903 
904 	function calcNumberOfBlocksUntilGameEnds(FixedPoint.Data currentGameSize, FixedPoint.Data targetGameSize) internal view returns (FixedPoint.Data) {
905 		return kLowerBoundBlocksTillGameEnd.add(kUpperBoundBlocksTillGameEnd.mul(FixedPoint.fromInt256(1).div(currentGameSize.div(targetGameSize).exp())));
906 	}
907 
908 	function calcMinimumBetSize(FixedPoint.Data currentGameSize, FixedPoint.Data targetGameSize) internal view returns (FixedPoint.Data) {
909 		return currentGameInitialMinBetSize.mul(FixedPoint.fromInt256(2).pow(FixedPoint.fromInt256(1).add(currentGameSize.div(targetGameSize)).log10()));
910 	}
911 }
912 
913 
914 
915 
916 
917 library SafeMath {
918 
919   /**
920   * @dev Multiplies two numbers, throws on overflow.
921   */
922   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
923     if (a == 0) {
924       return 0;
925     }
926     uint256 c = a * b;
927     assert(c / a == b);
928     return c;
929   }
930 
931   /**
932   * @dev Integer division of two numbers, truncating the quotient.
933   */
934   function div(uint256 a, uint256 b) internal pure returns (uint256) {
935     // assert(b > 0); // Solidity automatically throws when dividing by 0
936     uint256 c = a / b;
937     return c;
938   }
939 
940   /**
941   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
942   */
943   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
944     assert(b <= a);
945     return a - b;
946   }
947 
948   /**
949   * @dev Adds two numbers, throws on overflow.
950   */
951   function add(uint256 a, uint256 b) internal pure returns (uint256) {
952     uint256 c = a + b;
953     assert(c >= a);
954     return c;
955   }
956 }
957 
958 library SafeInt {
959 
960   /**
961   * @dev Multiplies two numbers, throws on overflow.
962   */
963   function mul(int256 a, int256 b) internal pure returns (int256) {
964     if (a == 0) {
965       return 0;
966     }
967     int256 c = a * b;
968     assert(c / a == b);
969     return c;
970   }
971 
972   /**
973   * @dev Integer division of two numbers, truncating the quotient.
974   */
975   function div(int256 a, int256 b) internal pure returns (int256) {
976    	// assert(b > 0); // Solidity automatically throws when dividing by 0
977     int256 c = a / b;
978     return c;
979   }
980 
981   /**
982   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
983   */
984   function sub(int256 a, int256 b) internal pure returns (int256) {
985     int256 c = a - b;
986     if(a>0 && b<0) {
987     	assert (c > a);	
988     } else if(a<0 && b>0) {
989     	assert (c < a);
990     }
991    	return c;
992   }
993 
994   /**
995   * @dev Adds two numbers, throws on overflow.
996   */
997   function add(int256 a, int256 b) internal pure returns (int256) {
998     int256 c = a + b;
999     if(a>0 && b>0) {
1000     	assert(c > a);
1001     } else if (a < 0 && b < 0) {
1002     	assert(c < a);
1003     }
1004     return c;
1005   }
1006 }
1007 
1008 library WrappedArray {
1009 	using SafeMath for uint256;
1010 	using FixedPoint for FixedPoint.Data;
1011 
1012 	struct GameMetaDataElement {
1013 		uint256 totalPotAmount;
1014 		uint256 seedAmount;
1015 		uint256 initialBet;
1016 		uint256 coinsRemaining;
1017 		uint256 developerMiningPower;
1018 		uint256 percentToTakeAsSeed;
1019 		uint256 percentToTakeAsRake;
1020 		uint256 potSplit;
1021 		FixedPoint.Data miningDifficulty;
1022 		FixedPoint.Data frontWindowAdjustmentRatio;
1023 		FixedPoint.Data backWindowAdjustmentRatio;
1024 		bool isActive;
1025 	}
1026 
1027 	struct Data {
1028 		GameMetaDataElement[] array;
1029 	}
1030 	
1031 	/* Push adds element as last item in array */
1032 	function push (Data storage self, GameMetaDataElement element) internal  {
1033 		self.array.length = self.array.length.add(1);
1034 		self.array[self.array.length.sub(1)] = element;
1035 	}
1036 
1037 	/* ItemAtIndex returns the item at index */
1038 	function itemAtIndex (Data storage self, uint256 index) internal view returns(GameMetaDataElement elem) {
1039 		/* Can't access something outside of scope of array */
1040 		assert(index < self.array.length); 
1041 		return self.array[index];
1042 	}
1043 	
1044 	/* Returns the length of the array */
1045 	function length (Data storage self) internal view returns(uint256 len) {
1046 		return self.array.length;
1047 	}
1048 }
1049 
1050 
1051 library CompactArray {
1052 	using SafeMath for uint256;
1053 
1054 	struct Element {
1055 		uint256 elem;
1056 	}
1057 	
1058 	struct Data {
1059 		Element[] array;
1060 		uint256 len;
1061 		uint256 popNextIndex;
1062 	}
1063 
1064 	/* Push adds element as last item in array and returns the index it was inserted at */
1065 	function push (Data storage self, Element element) internal returns(uint256 index)  {
1066 		if(self.array.length == self.len) {
1067 			self.array.length = self.array.length.add(1);
1068 		}
1069 		self.array[self.len] = element;
1070 		self.len = self.len.add(1);
1071 		return self.len.sub(1);
1072 	}
1073 
1074 	/* Replaces item at index with last item in array and resizes array accordingly */
1075 	function removeItemAtIndex (Data storage self, uint256 index) internal {
1076 		/* Can't remove something outside of scope of array */
1077 		assert(index < self.len);
1078 
1079 		/* Deleting the last element in array is same as length - 1 */
1080 		if(index == self.len.sub(1)) {
1081 			self.len = self.len.sub(1);
1082 			return;
1083 		}
1084 
1085 		/* Swap last element in array for this index */
1086 		Element storage temp = self.array[self.len.sub(1)];
1087 		self.array[index] = temp;
1088 		self.len = self.len.sub(1);
1089 	}
1090 	
1091 	/* Pop returns last element of array and deletes it from array */
1092 	function pop (Data storage self) internal returns(Element elem) {
1093 		assert(self.len > 0);
1094 
1095 		// Decrement size 
1096 		self.len = self.len.sub(1);
1097 
1098 		// return last item
1099 		return self.array[self.len];
1100 	}
1101 
1102 	/* PopNext keeps track of an index that loops through the array and pops the next item so that push pop doesn't necessarily return the item you pushed */
1103 	function getNext (Data storage self) internal returns(Element elem) {
1104 		assert(self.len > 0);
1105 			
1106 		if(self.popNextIndex >= self.len) {
1107 			// If there were regular pops inbetween
1108 			self.popNextIndex = self.len.sub(1);
1109 		}
1110 		Element memory nextElement = itemAtIndex(self, self.popNextIndex);
1111 		
1112 		if(self.popNextIndex == 0) {
1113 			self.popNextIndex = self.len.sub(1);
1114 		} else {
1115 			self.popNextIndex = self.popNextIndex.sub(1);
1116 		}
1117 		return nextElement;
1118 	}
1119 	
1120 	/* ItemAtIndex returns the item at index */
1121 	function itemAtIndex (Data storage self, uint256 index) internal view returns(Element elem) {
1122 		/* Can't access something outside of scope of array */
1123 		assert(index < self.len);
1124 			
1125 		return self.array[index];
1126 	}
1127 	
1128 	/* Returns the length of the array */
1129 	function length (Data storage self) internal view returns(uint256 len) {
1130 		return self.len;
1131 	}
1132 	
1133 }
1134 
1135 
1136 library UIntSet {
1137 	using CompactArray for CompactArray.Data;
1138 
1139 	struct SetEntry {
1140 		uint256 index;
1141 		bool active; // because the index can be zero we need another way to tell if we have the entry
1142 	}
1143 	
1144 	struct Data {
1145 		CompactArray.Data compactArray;
1146 		mapping (uint256 => SetEntry) storedValues;
1147 	}
1148 
1149 	/* Returns whether item is contained in dict */
1150 	function contains (Data storage self, uint256 element) internal view returns(bool res) {
1151 		return self.storedValues[element].active;
1152 	}
1153 
1154 	/* Adds an item to the set */
1155 	function insert (Data storage self, uint256 element) internal {
1156 		// Don't need to insert element if entry already exists
1157 		if(contains(self, element)) {
1158 			return;
1159 		}
1160 		// Create new entry for compact array
1161 		CompactArray.Element memory newElem = CompactArray.Element(element);
1162 
1163 		// Insert new entry into compact array and get where it was inserted
1164 		uint256 index = self.compactArray.push(newElem);
1165 
1166 		// Insert index of entry in compact array into our set
1167 		SetEntry memory entry = SetEntry(index, true);
1168 
1169 		self.storedValues[element] = entry;
1170 	}
1171 	
1172 	
1173 	/* Remove an item from the set */
1174 	function removeElement (Data storage self, uint256 element) internal {
1175 		// If nothing is stored can return
1176 		if(contains(self, element) == false) {
1177 			return;
1178 		}
1179 
1180 		// Get index of where element entry is stored in array
1181 		uint256 index = self.storedValues[element].index;
1182 
1183 		// Delete entry from array
1184 		self.compactArray.removeItemAtIndex(index);
1185 
1186 		// Delete entry from mapping
1187 		self.storedValues[element].active = false;
1188 
1189 		// If array still has elements we need to update mapping with new index
1190 		if(index < self.compactArray.length()) {
1191 			// Get new element stored at deleted index
1192 			CompactArray.Element memory swappedElem = self.compactArray.itemAtIndex(index);
1193 			
1194 			// Update mapping to reflect new index
1195 			self.storedValues[swappedElem.elem] = SetEntry(index, true);
1196 			
1197 		}
1198 	}
1199 
1200 	/* This utilized compact arrays popnext function to have a rotating pop */
1201 	function getNext (Data storage self) internal returns(CompactArray.Element) {
1202 		// If nothing is stored can return
1203 		return self.compactArray.getNext();
1204 	}
1205 
1206 	/* Returns the current number of items in the set */
1207 	function size (Data storage self) internal view returns(uint256 res) {
1208 		return self.compactArray.length();
1209 	}
1210 
1211 	function getItemAtIndex (Data storage self, uint256 index) internal view returns(CompactArray.Element) {
1212 		return self.compactArray.itemAtIndex(index);
1213 	}
1214 	
1215 }
1216 
1217 library Player {
1218 	using UIntSet for UIntSet.Data;
1219 	using CompactArray for CompactArray.Data;
1220 
1221 	struct BettingRecord {
1222 		address playerAddress;
1223 		uint256 gameId;
1224 		uint256 wagerAmount;
1225 		uint256 bettingRecordId;
1226 		uint256 gamePotBeforeBet;
1227 		uint256 withdrawnAmount;
1228 		uint256 withdrawnPopAmount;
1229 		bool isActive;
1230 	}
1231 	
1232 	struct Data {
1233 		UIntSet.Data bettingRecordIds;
1234 		mapping (uint256 => BettingRecord) bettingRecordMapping;
1235 	}
1236 	
1237 	/* Contains betting record for a betting record id */
1238 	function containsBettingRecordFromId (Data storage self, uint256 bettingRecordId) internal view returns(bool containsBettingRecord) {
1239 		return self.bettingRecordIds.contains(bettingRecordId);
1240 	}
1241 	
1242 
1243 	/* Function that returns a betting record for a betting record id */
1244 	function getBettingRecordForId (Data storage self, uint256 bettingRecordId) internal view returns(BettingRecord record) {
1245 		if(containsBettingRecordFromId(self, bettingRecordId) == false) {
1246 			return ;//BettingRecord(0x0,0,0,0,0,0,false);
1247 		}
1248 		return self.bettingRecordMapping[bettingRecordId];
1249 	}
1250 	
1251 
1252 	/* Insert Betting Record into storage */
1253 	function insertBettingRecord (Data storage self, BettingRecord record) internal {
1254 		// If inserting a record with the same id will override old record
1255 		self.bettingRecordMapping[record.bettingRecordId] = record;
1256 		self.bettingRecordIds.insert(record.bettingRecordId);
1257 	}
1258 	
1259 	/* Retrieve the next betting record */
1260 	function getNextRecord (Data storage self) internal returns(BettingRecord record) {
1261 		if(self.bettingRecordIds.size() == 0) {
1262 			return ;//BettingRecord(0x0,0,0,0,0,0,false);
1263 		}
1264 		CompactArray.Element memory bettingRecordIdEntry = self.bettingRecordIds.getNext();
1265 		return self.bettingRecordMapping[bettingRecordIdEntry.elem];
1266 	}
1267 
1268     function getBettingRecordAtIndex (Data storage self, uint256 index) internal view returns(BettingRecord record) {
1269     	return self.bettingRecordMapping[self.bettingRecordIds.getItemAtIndex(index).elem];
1270     }
1271     
1272 
1273 	/* Delete Betting Record */
1274 	function deleteBettingRecordForId (Data storage self, uint256 bettingRecordId) internal {
1275 		self.bettingRecordIds.removeElement(bettingRecordId);
1276 	}
1277 
1278 	/* Returns the number of betting records left to be processed */
1279 	function unprocessedBettingRecordCount (Data storage self) internal view returns(uint256 size) {
1280 		return self.bettingRecordIds.size();
1281 	}
1282 }
1283 
1284 library BettingRecordArray {
1285 	using Player for Player.Data;
1286 	using SafeMath for uint256;
1287 
1288 	struct Data {
1289 		Player.BettingRecord[] array;
1290 		uint256 len;
1291 	}
1292 
1293 	function resetIndex (Data storage self) internal {
1294 		self.len = 0;
1295 	}
1296 	
1297 	function pushRecord (Data storage self, Player.BettingRecord record) internal {
1298 		if(self.array.length == self.len) {
1299 			self.array.length = self.array.length.add(1);
1300 		}
1301 		self.array[self.len] = record;
1302 		self.len = self.len.add(1);
1303 	}
1304 
1305 	function getNextRecord (Data storage self) internal view returns(Player.BettingRecord record) {
1306 		if(self.array.length == self.len) {
1307 			return;
1308 		}
1309 		return self.array[self.len];
1310 	}	
1311 }
1312 
1313 
1314 library FixedPoint {
1315 	using SafeMath for uint256;
1316 	using SafeInt for int256;
1317 
1318 	int256 constant fracBits = 32;
1319 	int256 constant scale = 1 << 32;
1320 	int256 constant halfScale = scale >> 1;
1321     int256 constant precision = 1000000;
1322 	int256 constant e = 11674931554;
1323 	int256 constant pi = 13493037704;
1324 	int256 constant _2pi = 26986075409;
1325 
1326 	struct Data {
1327 		int256 val;
1328 	}
1329 
1330 	function fromInt256(int256 n) internal pure returns (Data) {
1331 		return Data({val: n.mul(scale)});
1332 	}
1333 
1334 	function fromFraction(int256 numerator, int256 denominator) internal pure returns (Data) {
1335 		return Data ({
1336 			val: numerator.mul(scale).div(denominator)
1337 		});
1338 	}
1339 
1340 	function toInt256(Data n) internal pure returns (int256) {
1341 		return (n.val * precision) >> fracBits;
1342 	}
1343 
1344 	function toUInt256Raw(Data a) internal pure returns (uint256) {
1345 		return uint256(a.val >> fracBits);
1346 	}
1347 
1348 	function add(Data a, Data b) internal pure returns (Data) {
1349 		return Data({val: a.val.add(b.val)});
1350 	}
1351 
1352 	function sub(Data a, Data b) internal pure returns (Data) {
1353 		return Data({val: a.val.sub(b.val)});
1354 	}
1355 
1356 	function mul(Data a, Data b) internal pure returns (Data) {
1357 		int256 result = a.val.mul(b.val).div(scale);
1358 		return Data({val: result});
1359 	}
1360 
1361 	function div(Data a, Data b) internal pure returns (Data) {
1362 		int256 num = a.val.mul(scale);
1363 		return Data({val: num.div(b.val)});
1364 	}
1365 
1366     function neg(Data a) internal pure returns (Data) {
1367         return Data({val: -a.val});
1368     }
1369 
1370 	function mod(Data a, Data b) internal pure returns (Data) {
1371 		return Data({val: a.val % b.val});
1372 	}
1373 
1374 	function expBySquaring(Data x, Data n) internal pure returns (Data) {
1375 		if(n.val == 0) { // exp == 0
1376 			return Data({val: scale});
1377 		}
1378 		Data memory extra = Data({val: scale});
1379 		while(true) {
1380 			if(n.val == scale) { // exp == 1
1381 				return mul(x, extra);
1382 			} else if (n.val % (2*scale) != 0) {
1383 				extra = mul(extra, x);
1384 				n = sub(n, fromInt256(1));
1385 			}
1386 			x = mul(x, x);
1387 			n = div(n, fromInt256(2));
1388 		}
1389 	}
1390 
1391 	function sin(Data x) internal pure returns (Data) {
1392 		int256 val = x.val % _2pi;
1393 
1394 		if(val < -pi) {
1395 			val += _2pi;
1396 		} else if (val > pi) {
1397 			val -= _2pi;
1398 		}
1399         Data memory result;
1400 		if(val < 0) {
1401 			result = add(mul(Data({val: 5468522184}), Data({val: val})), mul(Data({val: 1740684682}), mul(Data({val: val}), Data({val: val}))));
1402 			if(result.val < 0) {
1403 				result = add(mul(Data({val: 966367641}), sub(mul(result, neg(result)), result)), result);
1404 			} else {
1405 				result = add(mul(Data({val: 966367641}), sub(mul(result, result), result)), result);
1406 			}
1407 			return result;
1408 		} else {
1409 			result = sub(mul(Data({val: 5468522184}), Data({val: val})), mul(Data({val: 1740684682}), mul(Data({val: val}), Data({val: val})))); 
1410 			if(result.val < 0) {
1411 				result = add(mul(Data({val: 966367641}), sub(mul(result, neg(result)), result)), result);
1412 			} else {
1413 				result = add(mul(Data({val: 966367641}), sub(mul(result, result), result)), result);
1414 			}
1415 			return result;
1416 		}
1417 	}
1418 
1419 	function cmp(Data a, Data b) internal pure returns (int256) {
1420 		if(a.val > b.val) {
1421 			return 1;
1422 		} else if(a.val < b.val) {
1423 			return -1;
1424 		} else {
1425 			return 0;
1426 		}
1427 	}
1428 
1429 	function log10(Data a) internal pure returns (Data) {
1430 	    return div(ln(a), ln(fromInt256(10)));
1431 	}
1432 
1433 	function ln(Data a) internal pure returns (Data) {
1434 		int256 LOG = 0;
1435 		int256 prec = 1000000;
1436 		int256 x = a.val.mul(prec) >> fracBits;
1437 
1438 		while(x >= 1500000) {
1439 			LOG = LOG.add(405465);
1440 			x = x.mul(2).div(3);
1441 		}
1442 		x = x.sub(prec);
1443         int256 y = x;
1444         int256 i = 1;
1445         while (i < 10){
1446             LOG = LOG.add(y.div(i));
1447             i = i.add(1);
1448             y = x.mul(y).div(prec);
1449             LOG = LOG.sub(y.div(i));
1450             i = i.add(1);
1451             y = x.mul(y).div(prec);
1452         }
1453         LOG = LOG.mul(scale);
1454         LOG = LOG.div(prec);
1455         return Data({val: LOG});
1456 	}
1457 
1458 	function expRaw(Data a) internal pure returns (Data) {
1459 		int256 l1 = scale.add(a.val.div(4));
1460 		int256 l2 = scale.add(a.val.div(3).mul(l1).div(scale));
1461 		int256 l3 = scale.add(a.val.div(2).mul(l2).div(scale));
1462 		int256 l4 = scale.add(a.val.mul(l3).div(scale));
1463 
1464 		return Data({val: l4});
1465 	}
1466 
1467 	function exp(Data a) internal pure returns (Data) {
1468 		int256 pwr = a.val >> fracBits;
1469 		int256 frac = a.val.sub(pwr << fracBits);
1470 
1471 		return mul(expRaw(Data({val: frac})), expBySquaring(Data({val: e}), fromInt256(pwr)));
1472 	}
1473 
1474 	function pow(Data base, Data power) internal pure returns (Data) {
1475 		int256 intpwr = power.val >> 32;
1476 		int256 frac = power.val.sub(intpwr << fracBits);
1477 		return mul(expRaw(mul(Data({val:frac}), ln(base))), expBySquaring(base, fromInt256(intpwr)));
1478 	}
1479 }