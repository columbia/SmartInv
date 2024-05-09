1 pragma solidity ^0.4.23;
2 
3 contract LotteryFactory {
4 
5 	// contract profit
6 	uint public commissionSum;
7 	// default lottery params
8 	Params public defaultParams;
9 	// lotteries
10 	Lottery[] public lotteries;
11 	// lotteries count
12 	uint public lotteryCount;
13 	// contract owner address
14 	address public owner;
15 
16 	struct Lottery {
17 		mapping(address => uint) ownerTokenCount;
18 		mapping(address => uint) ownerTokenCountToSell;
19 		mapping(address => uint) sellerId;
20 		address[] sellingAddresses;
21 		uint[] sellingAmounts;
22 		uint createdAt;
23 		uint tokenCount;
24 		uint tokenCountToSell;
25 		uint winnerSum;
26 		bool prizeRedeemed;
27 		address winner;
28 		address[] participants;
29 		Params params;
30 	}
31 
32 	// lottery params
33 	struct Params {
34 		uint gameDuration;
35 		uint initialTokenPrice; 
36 		uint durationToTokenPriceUp; 
37 		uint tokenPriceIncreasePercent; 
38 		uint tradeCommission; 
39 		uint winnerCommission;
40 	}
41 
42 	// event fired on purchase error, when user tries to buy a token from a seller
43 	event PurchaseError(address oldOwner, uint amount);
44 
45 	/**
46 	 * Throws if called by account different from the owner account
47 	 */
48 	modifier onlyOwner() {
49 		require(msg.sender == owner);
50 		_;
51 	}
52 
53 	/**
54 	 * @dev Sets owner and default lottery params
55 	 */
56 	constructor() public {
57 		// set owner
58 		owner = msg.sender;
59 		// set default params
60 		updateParams(4 hours, 0.01 ether, 15 minutes, 10, 1, 10);
61 		// create a new lottery
62 		_createNewLottery();
63 	}
64 
65 	/**
66 	 * @dev Approves tokens for selling
67 	 * @param _tokenCount amount of tokens to place for selling
68 	 */
69 	function approveToSell(uint _tokenCount) public {
70 		Lottery storage lottery = lotteries[lotteryCount - 1];
71 		// check that user has enough tokens to sell
72 		require(lottery.ownerTokenCount[msg.sender] - lottery.ownerTokenCountToSell[msg.sender] >= _tokenCount);
73 		// if there are no sales or this is user's first sale
74 		if(lottery.sellingAddresses.length == 0 || lottery.sellerId[msg.sender] == 0 && lottery.sellingAddresses[0] != msg.sender) {
75 			uint sellingAddressesCount = lottery.sellingAddresses.push(msg.sender);
76 			uint sellingAmountsCount = lottery.sellingAmounts.push(_tokenCount);
77 			assert(sellingAddressesCount == sellingAmountsCount);
78 			lottery.sellerId[msg.sender] = sellingAddressesCount - 1;
79 		} else {
80 			// seller exists and placed at least 1 sale
81 			uint sellerIndex = lottery.sellerId[msg.sender];
82 			lottery.sellingAmounts[sellerIndex] += _tokenCount;
83 		}
84 		// update global lottery variables
85 		lottery.ownerTokenCountToSell[msg.sender] += _tokenCount;
86 		lottery.tokenCountToSell += _tokenCount;
87 	}
88 
89 	/**
90 	 * @dev Returns token balance by user address
91 	 * @param _user user address
92 	 * @return token acount on the user balance
93 	 */
94 	function balanceOf(address _user) public view returns(uint) {
95 		Lottery storage lottery = lotteries[lotteryCount - 1];
96 		return lottery.ownerTokenCount[_user];
97 	}
98 
99 	/**
100 	 * @dev Returns selling token balance by user address
101 	 * @param _user user address
102 	 * @return token acount selling by user
103 	 */
104 	function balanceSellingOf(address _user) public view returns(uint) {
105 		Lottery storage lottery = lotteries[lotteryCount - 1];
106 		return lottery.ownerTokenCountToSell[_user];
107 	}
108 
109 	/**
110 	 * @dev Buys tokens
111 	 */
112 	function buyTokens() public payable {
113 		if(_isNeededNewLottery()) _createNewLottery();
114 		// get latest lottery
115 		Lottery storage lottery = lotteries[lotteryCount - 1];
116 		// get token count to buy
117 		uint price = _getCurrentTokenPrice();
118 		uint tokenCountToBuy = msg.value / price;
119 		// any extra eth added to winner sum
120 		uint rest = msg.value - tokenCountToBuy * price;
121 		if( rest > 0 ){
122 		    lottery.winnerSum = lottery.winnerSum + rest;
123 		}
124 		// check that user wants to buy at least 1 token
125 		require(tokenCountToBuy > 0);
126 		// buy tokens from sellers
127 		uint tokenCountToBuyFromSeller = _getTokenCountToBuyFromSeller(tokenCountToBuy);
128 		if(tokenCountToBuyFromSeller > 0) {
129 		 	_buyTokensFromSeller(tokenCountToBuyFromSeller);
130 		}
131 		// buy tokens from system
132 		uint tokenCountToBuyFromSystem = tokenCountToBuy - tokenCountToBuyFromSeller;
133 		if(tokenCountToBuyFromSystem > 0) {
134 			_buyTokensFromSystem(tokenCountToBuyFromSystem);
135 		}
136 		// add sender to participants
137 		_addToParticipants(msg.sender);
138 		// update winner values
139 		lottery.winnerSum += tokenCountToBuyFromSystem * price;
140 		lottery.winner = _getWinner();
141 	}
142 
143 	/**
144 	 * @dev Removes tokens from selling
145 	 * @param _tokenCount amount of tokens to remove from selling
146 	 */
147 	function disapproveToSell(uint _tokenCount) public {
148 		Lottery storage lottery = lotteries[lotteryCount - 1];
149 		// check that user has enough tokens to cancel selling
150 		require(lottery.ownerTokenCountToSell[msg.sender] >= _tokenCount);
151 		// remove tokens from selling
152 		uint sellerIndex = lottery.sellerId[msg.sender];
153 		lottery.sellingAmounts[sellerIndex] -= _tokenCount;
154 		// update global lottery variables
155 		lottery.ownerTokenCountToSell[msg.sender] -= _tokenCount;
156 		lottery.tokenCountToSell -= _tokenCount;
157 	}
158 
159 	/**
160 	 * @dev Returns lottery details by index
161 	 * @param _index lottery index
162 	 * @return lottery details
163 	 */
164 	function getLotteryAtIndex(uint _index) public view returns(
165 		uint createdAt,
166 		uint tokenCount,
167 		uint tokenCountToSell,
168 		uint winnerSum,
169 		address winner,
170 		bool prizeRedeemed,
171 		address[] participants,
172 		uint paramGameDuration,
173 		uint paramInitialTokenPrice,
174 		uint paramDurationToTokenPriceUp,
175 		uint paramTokenPriceIncreasePercent,
176 		uint paramTradeCommission,
177 		uint paramWinnerCommission
178 	) {
179 		// check that lottery exists
180 		require(_index < lotteryCount);
181 		// return lottery details
182 		Lottery memory lottery = lotteries[_index];
183 		createdAt = lottery.createdAt;
184 		tokenCount = lottery.tokenCount;
185 		tokenCountToSell = lottery.tokenCountToSell;
186 		winnerSum = lottery.winnerSum;
187 		winner = lottery.winner;
188 		prizeRedeemed = lottery.prizeRedeemed;
189 		participants = lottery.participants;
190 		paramGameDuration = lottery.params.gameDuration;
191 		paramInitialTokenPrice = lottery.params.initialTokenPrice;
192 		paramDurationToTokenPriceUp = lottery.params.durationToTokenPriceUp;
193 		paramTokenPriceIncreasePercent = lottery.params.tokenPriceIncreasePercent;
194 		paramTradeCommission = lottery.params.tradeCommission;
195 		paramWinnerCommission = lottery.params.winnerCommission;
196 	}
197 
198 	/**
199 	 * @dev Returns arrays of addresses who sell tokens and corresponding amounts
200 	 * @return array of addresses who sell tokens and array of amounts
201 	 */
202 	function getSales() public view returns(address[], uint[]) {
203 		// get latest lottery
204 		Lottery memory lottery = lotteries[lotteryCount - 1];
205 		// return array of addresses who sell tokens and amounts
206 		return (lottery.sellingAddresses, lottery.sellingAmounts);
207 	}
208 
209 	/**
210 	 * @dev Returns top users by balances for current lottery
211 	 * @param _n number of top users to find
212 	 * @return array of addresses and array of balances sorted in balance descend
213 	 */
214 	function getTop(uint _n) public view returns(address[], uint[]) {
215 		// check that n > 0
216 		require(_n > 0);
217 		// get latest lottery
218 		Lottery memory lottery = lotteries[lotteryCount - 1];
219 		// find top n users with highest token balances
220 		address[] memory resultAddresses = new address[](_n);
221 		uint[] memory resultBalances = new uint[](_n);
222 		for(uint i = 0; i < _n; i++) {
223 			// if current iteration is more than number of participants then continue
224 			if(i > lottery.participants.length - 1) continue;
225 			// if 1st iteration then set 0 values
226 			uint prevMaxBalance = i == 0 ? 0 : resultBalances[i-1];
227 			address prevAddressWithMax = i == 0 ? address(0) : resultAddresses[i-1];
228 			uint currentMaxBalance = 0;
229 			address currentAddressWithMax = address(0);
230 			for(uint j = 0; j < lottery.participants.length; j++) {
231 				uint balance = balanceOf(lottery.participants[j]);
232 				// if first iteration then simply find max
233 				if(i == 0) {
234 					if(balance > currentMaxBalance) {
235 						currentMaxBalance = balance;
236 						currentAddressWithMax = lottery.participants[j];
237 					}
238 				} else {
239 					// find balance that is less or equal to the prev max
240 					if(prevMaxBalance >= balance && balance > currentMaxBalance && lottery.participants[j] != prevAddressWithMax) {
241 						currentMaxBalance = balance;
242 						currentAddressWithMax = lottery.participants[j];
243 					}
244 				}
245 			}
246 			resultAddresses[i] = currentAddressWithMax;
247 			resultBalances[i] = currentMaxBalance;
248 		}
249 		return(resultAddresses, resultBalances);
250 	}
251 
252 	/**
253 	 * @dev Returns seller id by user address
254 	 * @param _user user address
255 	 * @return seller id/index
256 	 */
257 	function sellerIdOf(address _user) public view returns(uint) {
258 		Lottery storage lottery = lotteries[lotteryCount - 1];
259 		return lottery.sellerId[_user];
260 	}
261 
262 	/**
263 	 * @dev Updates lottery parameters
264 	 * @param _gameDuration duration of the lottery in seconds
265 	 * @param _initialTokenPrice initial price for 1 token in wei
266 	 * @param _durationToTokenPriceUp how many seconds should pass to increase token price
267 	 * @param _tokenPriceIncreasePercent percentage of token increase. ex: 2 will increase token price by 2% each time interval
268 	 * @param _tradeCommission commission in percentage for trading tokens. When user1 sells token to user2 for 1.15 eth then commision applied
269 	 * @param _winnerCommission commission in percentage for winning sum
270 	 */
271 	function updateParams(
272 		uint _gameDuration,
273 		uint _initialTokenPrice,
274 		uint _durationToTokenPriceUp,
275 		uint _tokenPriceIncreasePercent,
276 		uint _tradeCommission,
277 		uint _winnerCommission
278 	) public onlyOwner {
279 		Params memory params;
280 		params.gameDuration = _gameDuration;
281 		params.initialTokenPrice = _initialTokenPrice;
282 		params.durationToTokenPriceUp = _durationToTokenPriceUp;
283 		params.tokenPriceIncreasePercent = _tokenPriceIncreasePercent;
284 		params.tradeCommission = _tradeCommission;
285 		params.winnerCommission = _winnerCommission;
286 		defaultParams = params;
287 	}
288 
289 	/**
290 	 * @dev Withdraws commission sum to the owner
291 	 */
292 	function withdraw() public onlyOwner {
293 		// check that commision > 0
294 		require(commissionSum > 0);
295 		// save commission for later transfer and reset
296 		uint commissionSumToTransfer = commissionSum;
297 		commissionSum = 0;
298 		// transfer commission to owner
299 		owner.transfer(commissionSumToTransfer);
300 	}
301 
302 	/**
303 	 * @dev Withdraws ether for winner
304 	 * @param _lotteryIndex lottery index
305 	 */
306 	function withdrawForWinner(uint _lotteryIndex) public {
307 		// check that lottery exists
308 		require(lotteries.length > _lotteryIndex);
309 		// check that sender is winner
310 		Lottery storage lottery = lotteries[_lotteryIndex];
311 		require(lottery.winner == msg.sender);
312 		// check that lottery is over
313 		require(now > lottery.createdAt + lottery.params.gameDuration);
314 		// check that prize is not redeemed
315 		require(!lottery.prizeRedeemed);
316 		// update contract commission sum and winner sum
317 		uint winnerCommissionSum = _getValuePartByPercent(lottery.winnerSum, lottery.params.winnerCommission);
318 		commissionSum += winnerCommissionSum;
319 		uint winnerSum = lottery.winnerSum - winnerCommissionSum;
320 		// mark lottery as redeemed
321 		lottery.prizeRedeemed = true;
322 		// send winner his prize
323 		lottery.winner.transfer(winnerSum);
324 	}
325 
326 	/**
327 	 * @dev Disallow users to send ether directly to the contract
328 	 */
329 	function() public payable {
330 		revert();
331 	}
332 
333 	/**
334 	 * @dev Adds user address to participants
335 	 * @param _user user address
336 	 */
337 	function _addToParticipants(address _user) internal {
338 		// check that user is not in participants
339 		Lottery storage lottery = lotteries[lotteryCount - 1];
340 		bool isParticipant = false;
341 		for(uint i = 0; i < lottery.participants.length; i++) {
342 			if(lottery.participants[i] == _user) {
343 				isParticipant = true;
344 				break;
345 			}
346 		}
347 		if(!isParticipant) {
348 			lottery.participants.push(_user);
349 		}
350 	}
351 
352 	/**
353 	 * @dev Buys tokens from sellers
354 	 * @param _tokenCountToBuy amount of tokens to buy from sellers
355 	 */
356 	function _buyTokensFromSeller(uint _tokenCountToBuy) internal {
357 		// check that token count is not 0
358 		require(_tokenCountToBuy > 0);
359 		// get latest lottery
360 		Lottery storage lottery = lotteries[lotteryCount - 1];
361 		// get current token price and commission sum
362 		uint currentTokenPrice = _getCurrentTokenPrice();
363 		uint currentCommissionSum = _getValuePartByPercent(currentTokenPrice, lottery.params.tradeCommission);
364 		uint purchasePrice = currentTokenPrice - currentCommissionSum;
365 		// foreach selling amount
366 		uint tokensLeftToBuy = _tokenCountToBuy;
367 		for(uint i = 0; i < lottery.sellingAmounts.length; i++) {
368 			// if amount != 0 and buyer does not purchase his own tokens
369 			if(lottery.sellingAmounts[i] != 0 && lottery.sellingAddresses[i] != msg.sender) {
370 				address oldOwner = lottery.sellingAddresses[i];
371 				// find how many tokens to substitute
372 				uint tokensToSubstitute;
373 				if(tokensLeftToBuy < lottery.sellingAmounts[i]) {
374 					tokensToSubstitute = tokensLeftToBuy;
375 				} else {
376 					tokensToSubstitute = lottery.sellingAmounts[i];
377 				}
378 				// update old owner balance and send him ether
379 				lottery.sellingAmounts[i] -= tokensToSubstitute;
380 				lottery.ownerTokenCount[oldOwner] -= tokensToSubstitute;
381 				lottery.ownerTokenCountToSell[oldOwner] -= tokensToSubstitute;
382 				uint purchaseSum = purchasePrice * tokensToSubstitute;
383 				if(!oldOwner.send(purchaseSum)) {
384 					emit PurchaseError(oldOwner, purchaseSum);
385 				}
386 				// check if user bought enough
387 				tokensLeftToBuy -= tokensToSubstitute;
388 				if(tokensLeftToBuy == 0) break;
389 			}
390 		}
391 		// update contract variables
392 		commissionSum += _tokenCountToBuy * purchasePrice;
393 		lottery.ownerTokenCount[msg.sender] += _tokenCountToBuy;
394 		lottery.tokenCountToSell -= _tokenCountToBuy;
395 	}
396 
397 	/**
398 	 * @dev Buys tokens from system(mint) for sender
399 	 * @param _tokenCountToBuy token count to buy
400 	 */
401 	function _buyTokensFromSystem(uint _tokenCountToBuy) internal {
402 		// check that token count is not 0
403 		require(_tokenCountToBuy > 0);
404 		// get latest lottery
405 		Lottery storage lottery = lotteries[lotteryCount - 1];
406 		// mint tokens for buyer
407 		lottery.ownerTokenCount[msg.sender] += _tokenCountToBuy;
408 		// update lottery values
409 		lottery.tokenCount += _tokenCountToBuy;
410 	}
411 
412 	/**
413 	 * @dev Creates a new lottery
414 	 */
415 	function _createNewLottery() internal {
416 		Lottery memory lottery;
417 		lottery.createdAt = _getNewLotteryCreatedAt();
418 		lottery.params = defaultParams;
419 		lotteryCount = lotteries.push(lottery);
420 	}
421 
422 	/**
423 	 * @dev Returns current price for 1 token
424 	 * @return token price
425 	 */
426 	function _getCurrentTokenPrice() internal view returns(uint) {
427 		Lottery memory lottery = lotteries[lotteryCount - 1];
428 		uint diffInSec = now - lottery.createdAt;
429 		uint stageCount = diffInSec / lottery.params.durationToTokenPriceUp;
430 		uint price = lottery.params.initialTokenPrice;
431 		for(uint i = 0; i < stageCount; i++) {
432 			price += _getValuePartByPercent(price, lottery.params.tokenPriceIncreasePercent);
433 		}
434 		return price;
435 	}
436 
437 	/**
438 	 * @dev Returns new lottery created at. 
439 	 * Ex: latest lottery started at 0:00 and finished at 6:00. Now it is 7:00. User buys token. New lottery createdAt will be 06:00:01.
440 	 * @return new lottery created at timestamp
441 	 */
442 	function _getNewLotteryCreatedAt() internal view returns(uint) {
443 		// if there are no lotteries then return now
444 		if(lotteries.length == 0) return now;
445 		// else loop while new created at time is not found
446 		// get latest lottery end time
447 		uint latestEndAt = lotteries[lotteryCount - 1].createdAt + lotteries[lotteryCount - 1].params.gameDuration;
448 		// get next lottery end time
449 		uint nextEndAt = latestEndAt + defaultParams.gameDuration;
450 		while(now > nextEndAt) {
451 			nextEndAt += defaultParams.gameDuration;
452 		}
453 		return nextEndAt - defaultParams.gameDuration;
454 	}
455 
456 	/**
457 	 * @dev Returns number of tokens that can be bought from seller
458 	 * @param _tokenCountToBuy token count to buy
459 	 * @return number of tokens that can be bought from seller
460 	 */
461 	function _getTokenCountToBuyFromSeller(uint _tokenCountToBuy) internal view returns(uint) {
462 		// check that token count is not 0
463 		require(_tokenCountToBuy > 0);
464 		// get latest lottery
465 		Lottery storage lottery = lotteries[lotteryCount - 1];
466 		// check that total token count on sale is more that user has
467 		require(lottery.tokenCountToSell >= lottery.ownerTokenCountToSell[msg.sender]);
468 		// substitute user's token on sale count from total count
469 		uint tokenCountToSell = lottery.tokenCountToSell - lottery.ownerTokenCountToSell[msg.sender];
470 		// if there are no tokens to sell then return 0
471 		if(tokenCountToSell == 0) return 0;
472 		// if there are less tokens to sell than we need
473 		if(tokenCountToSell < _tokenCountToBuy) {
474 			return tokenCountToSell;
475 		} else {
476 			// contract has all tokens to buy from sellers
477 			return _tokenCountToBuy;
478 		}
479 	}
480 
481 	/**
482 	 * @dev Returns part of number by percent. Ex: (200, 1) => 2
483 	 * @param _initialValue initial number
484 	 * @param _percent percentage
485 	 * @return part of number by percent
486 	 */
487 	function _getValuePartByPercent(uint _initialValue, uint _percent) internal pure returns(uint) {
488 		uint onePercentValue = _initialValue / 100;
489 		return onePercentValue * _percent;
490 	}
491 
492 	/**
493 	 * @dev Returns winner address
494 	 * @return winner address
495 	 */
496 	function _getWinner() internal view returns(address) {
497 		Lottery storage lottery = lotteries[lotteryCount - 1];
498 		// if there are no participants then return 0x00 address
499 		if(lottery.participants.length == 0) return address(0);
500 		// set the 1st participant as winner
501 		address winner = lottery.participants[0];
502 		uint maxTokenCount = 0;
503 		// loop through all participants to find winner
504 		for(uint i = 0; i < lottery.participants.length; i++) {
505 			uint currentTokenCount = lottery.ownerTokenCount[lottery.participants[i]];
506 			if(currentTokenCount > maxTokenCount) {
507 				winner = lottery.participants[i];
508 				maxTokenCount = currentTokenCount; 
509 			}
510 		}
511 		return winner;
512 	}
513 
514 	/**
515 	 * @dev Checks whether new lottery should be created
516 	 * @return true if new lottery needs to be created false otherwise
517 	 */
518 	function _isNeededNewLottery() internal view returns(bool) {
519 		// if there are no lotteries then return true
520 		if(lotteries.length == 0) return true;
521 		// if now is more than lottery end time then return true else false
522 		Lottery memory lottery = lotteries[lotteries.length - 1];
523 		return now > lottery.createdAt + defaultParams.gameDuration;
524 	}
525 
526 }