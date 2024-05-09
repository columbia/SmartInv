1 pragma solidity 0.4.24;
2 
3 contract InterbetCore {
4 
5 	/* Global constants */
6 	uint constant oddsDecimals = 2; // Max. decimal places of odds
7 	uint constant feeRateDecimals = 1; // Max. decimal places of fee rate
8 
9 	uint public minMakerBetFund = 100 * 1 finney; // Minimum fund of a maker bet
10 
11 	uint public maxAllowedTakerBetsPerMakerBet = 100; // Limit the number of taker-bets in 1 maker-bet
12 	uint public minAllowedStakeInPercentage = 1; // 100 ÷ maxAllowedTakerBetsPerMakerBet
13 
14 	uint public baseVerifierFee = 1 finney; // Ensure verifier has some minimal profit to cover their gas cost at least
15 
16 	/* Owner and admins */
17 	address private owner;
18 	mapping(address => bool) private admins;
19 
20 	modifier onlyOwner() {
21 		require(msg.sender == owner);
22 		_;
23 	}
24 
25 	function changeOwner(address newOwner) external onlyOwner {
26 		owner = newOwner;
27 	}
28 
29 	function addAdmin(address addr) external onlyOwner {
30 		admins[addr] = true;
31 	}
32 
33 	function removeAdmin(address addr) external onlyOwner {
34 		admins[addr] = false;
35 	}
36 
37 	modifier onlyAdmin() {
38 		require(admins[msg.sender] == true);
39 		_;
40 	}
41 
42 	function changeMinMakerBetFund(uint weis) external onlyAdmin {
43 		minMakerBetFund = mul(weis, 1 wei);
44 	}
45 
46 	function changeAllowedTakerBetsPerMakerBet(uint maxCount, uint minPercentage) external onlyAdmin {
47 		maxAllowedTakerBetsPerMakerBet = maxCount;
48 		minAllowedStakeInPercentage = minPercentage;
49 	}
50 
51 	function changeBaseVerifierFee(uint weis) external onlyAdmin {
52 		baseVerifierFee = mul(weis, 1 wei);
53 	}
54 
55 	/* Events */
56 	event LogUpdateVerifier(address indexed addr, uint oldFeeRate, uint newFeeRate);
57 	event LogMakeBet(uint indexed makerBetId, address indexed maker);
58 	event LogAddFund(uint indexed makerBetId, address indexed maker, uint oldTotalFund, uint newTotalFund);
59 	event LogUpdateOdds(uint indexed makerBetId, address indexed maker, uint oldOdds, uint newOdds);
60 	event LogPauseBet(uint indexed makerBetId, address indexed maker);
61 	event LogReopenBet(uint indexed makerBetId, address indexed maker);
62 	event LogCloseBet(uint indexed makerBetId, address indexed maker);
63 	event LogTakeBet(uint indexed makerBetId, address indexed maker, uint indexed takerBetId, address taker);
64 	event LogSettleBet(uint indexed makerBetId, address indexed maker);
65 	event LogWithdraw(uint indexed makerBetId, address indexed maker, address indexed addr);
66 
67 	/* Betting Core */
68 	enum BetStatus {
69 		Open, 
70 		Paused, 
71 		Closed, 
72 		Settled
73 	}
74 
75 	enum BetOutcome {
76 		NotSettled,
77 		MakerWin,
78 		TakerWin,
79 		Draw,
80 		Canceled
81 	}
82 
83 	struct MakerBet {
84 		uint makerBetId;
85 		address maker;
86 		uint odds;
87 		uint totalFund;
88 		Verifier trustedVerifier;
89 		uint expiry;
90 		BetStatus status;
91 		uint reservedFund;
92 		uint takerBetsCount;
93 		uint totalStake;
94 		TakerBet[] takerBets;
95 		BetOutcome outcome;
96 		bool makerFundWithdrawn;
97 		bool trustedVerifierFeeSent;
98 	}
99 
100 	struct TakerBet {
101 		uint takerBetId;
102 		address taker;
103 		uint odds;
104 		uint stake;
105         bool settled;
106 	}
107 
108 	struct Verifier {
109 		address addr;
110 		uint feeRate;
111 	}
112 
113 	uint public makerBetsCount;
114 	mapping(uint => mapping(address => MakerBet)) private makerBets;
115 
116 	mapping(address => Verifier) private verifiers;
117 
118 	constructor() public {
119 		owner = msg.sender;
120 		makerBetsCount = 0;
121 	}
122 
123 	function () external payable {
124 		revert();
125 	}
126 
127 	/// Update verifier's data
128 	function updateVerifier(uint feeRate) external {
129 		require(feeRate >= 0 && feeRate <= ((10 ** feeRateDecimals) * 100));
130 
131 		Verifier storage verifier = verifiers[msg.sender];
132 
133 		uint oldFeeRate = verifier.feeRate;
134 
135 		verifier.addr = msg.sender;
136 		verifier.feeRate = feeRate;
137 
138 		emit LogUpdateVerifier(msg.sender, oldFeeRate, feeRate);
139 	}
140 
141 	/// Make a bet
142 	function makeBet(uint makerBetId, uint odds, address trustedVerifier, uint trustedVerifierFeeRate, uint expiry) external payable {
143 		uint fund = sub(msg.value, baseVerifierFee);
144 
145 		require(fund >= minMakerBetFund);
146 		require(odds > (10 ** oddsDecimals) && odds < ((10 ** 8) * (10 ** oddsDecimals)));
147 		require(expiry > now);
148 
149         MakerBet storage makerBet = makerBets[makerBetId][msg.sender];
150 
151         require(makerBet.makerBetId == 0);
152 
153         Verifier memory verifier = verifiers[trustedVerifier];
154 
155         require(verifier.addr != address(0x0));
156         require(trustedVerifierFeeRate == verifier.feeRate);
157 
158 		makerBet.makerBetId = makerBetId;
159 		makerBet.maker = msg.sender;
160 		makerBet.odds = odds;
161 		makerBet.totalFund = fund;
162 		makerBet.trustedVerifier = Verifier(verifier.addr, verifier.feeRate);
163 		makerBet.expiry = expiry;
164 		makerBet.status = BetStatus.Open;
165 		makerBet.reservedFund = 0;
166 		makerBet.takerBetsCount = 0;
167 		makerBet.totalStake = 0;
168 
169 		makerBetsCount++;
170 
171 		emit LogMakeBet(makerBetId, msg.sender);
172 	}
173 
174 	/// Increase total fund of a bet
175     function addFund(uint makerBetId) external payable {
176     	MakerBet storage makerBet = makerBets[makerBetId][msg.sender];
177 		require(makerBet.makerBetId != 0);
178 
179     	require(now < makerBet.expiry);
180 
181     	require(makerBet.status == BetStatus.Open || makerBet.status == BetStatus.Paused);
182 
183     	require(msg.sender == makerBet.maker);
184 
185 		require(msg.value > 0);
186 
187 		uint oldTotalFund = makerBet.totalFund;
188 
189     	makerBet.totalFund = add(makerBet.totalFund, msg.value);
190 
191     	emit LogAddFund(makerBetId, msg.sender, oldTotalFund, makerBet.totalFund);
192     }
193 
194     /// Update odds of a bet
195     function updateOdds(uint makerBetId, uint odds) external {
196     	require(odds > (10 ** oddsDecimals) && odds < ((10 ** 8) * (10 ** oddsDecimals)));
197 
198 		MakerBet storage makerBet = makerBets[makerBetId][msg.sender];
199 		require(makerBet.makerBetId != 0);
200 
201 		require(now < makerBet.expiry);
202 
203     	require(makerBet.status == BetStatus.Open || makerBet.status == BetStatus.Paused);
204 
205     	require(msg.sender == makerBet.maker);
206 
207     	require(odds != makerBet.odds);
208 
209     	uint oldOdds = makerBet.odds;
210 
211     	makerBet.odds = odds;
212 
213     	emit LogUpdateOdds(makerBetId, msg.sender, oldOdds, makerBet.odds);
214     }
215 
216     /// Pause a bet
217     function pauseBet(uint makerBetId) external {
218     	MakerBet storage makerBet = makerBets[makerBetId][msg.sender];
219 		require(makerBet.makerBetId != 0);
220 
221     	require(makerBet.status == BetStatus.Open);
222 
223     	require(msg.sender == makerBet.maker);
224 
225 		makerBet.status = BetStatus.Paused;
226 
227 		emit LogPauseBet(makerBetId, msg.sender);
228     }
229 
230     /// Reopen a bet
231     function reopenBet(uint makerBetId) external {
232     	MakerBet storage makerBet = makerBets[makerBetId][msg.sender];
233 		require(makerBet.makerBetId != 0);
234 
235     	require(makerBet.status == BetStatus.Paused);
236 
237     	require(msg.sender == makerBet.maker);
238 
239 		makerBet.status = BetStatus.Open;
240 
241 		emit LogReopenBet(makerBetId, msg.sender);
242     }
243 
244     /// Close a bet and withdraw unused fund
245     function closeBet(uint makerBetId) external {
246     	MakerBet storage makerBet = makerBets[makerBetId][msg.sender];
247 		require(makerBet.makerBetId != 0);
248 
249     	require(makerBet.status == BetStatus.Open || makerBet.status == BetStatus.Paused);
250 
251     	require(msg.sender == makerBet.maker);
252 
253 		makerBet.status = BetStatus.Closed;
254 
255 		// refund unused fund to maker
256 		uint unusedFund = sub(makerBet.totalFund, makerBet.reservedFund);
257 
258 		if (unusedFund > 0) {
259 			makerBet.totalFund = makerBet.reservedFund;
260 
261 			uint refundAmount = unusedFund;
262 			if (makerBet.totalStake == 0) {
263 				refundAmount = add(refundAmount, baseVerifierFee); // Refund base verifier fee too if no taker-bets, because verifier do not need to settle the bet with no takers
264 				makerBet.makerFundWithdrawn = true;
265 			}
266 
267 			if (!makerBet.maker.send(refundAmount)) {
268 				makerBet.totalFund = add(makerBet.totalFund, unusedFund);
269 	            makerBet.status = BetStatus.Paused;
270 	            makerBet.makerFundWithdrawn = false;
271 	        } else {
272 	        	emit LogCloseBet(makerBetId, msg.sender);
273 	        }
274 		} else {
275 			emit LogCloseBet(makerBetId, msg.sender);
276 		}
277     }
278 
279     /// Take a bet
280 	function takeBet(uint makerBetId, address maker, uint odds, uint takerBetId) external payable {
281 		require(msg.sender != maker);
282 
283 		require(msg.value > 0);
284 
285 		MakerBet storage makerBet = makerBets[makerBetId][maker];
286 		require(makerBet.makerBetId != 0);
287 
288 		require(msg.sender != makerBet.trustedVerifier.addr);
289 
290 		require(now < makerBet.expiry);
291 
292 		require(makerBet.status == BetStatus.Open);
293 
294 		require(makerBet.odds == odds);
295 
296 		// Avoid too many taker-bets in one maker-bet
297 		require(makerBet.takerBetsCount < maxAllowedTakerBetsPerMakerBet);
298 
299 		// Avoid too many tiny bets
300 		uint minAllowedStake = mul(mul(makerBet.totalFund, (10 ** oddsDecimals)), minAllowedStakeInPercentage) / sub(odds, (10 ** oddsDecimals)) / 100;
301 		uint maxAvailableStake = mul(sub(makerBet.totalFund, makerBet.reservedFund), (10 ** oddsDecimals)) / sub(odds, (10 ** oddsDecimals));
302 		if (maxAvailableStake >= minAllowedStake) {
303 			require(msg.value >= minAllowedStake);
304 		} else {
305 			require(msg.value >= sub(maxAvailableStake, (maxAvailableStake / 10)) && msg.value <= maxAvailableStake);
306 		}
307 
308         // If remaining fund is not enough, send the money back.
309 		require(msg.value <= maxAvailableStake);
310 
311         makerBet.takerBets.length++;
312 		makerBet.takerBets[makerBet.takerBetsCount] = TakerBet(takerBetId, msg.sender, odds, msg.value, false);
313 		makerBet.reservedFund = add(makerBet.reservedFund, mul(msg.value, sub(odds, (10 ** oddsDecimals))) / (10 ** oddsDecimals));   
314 		makerBet.totalStake = add(makerBet.totalStake, msg.value);
315 		makerBet.takerBetsCount++;
316 
317 		emit LogTakeBet(makerBetId, maker, takerBetId, msg.sender);
318 	}
319 
320 	/// Payout to maker
321 	function payMaker(MakerBet storage makerBet) private returns (bool fullyWithdrawn) {
322 		fullyWithdrawn = false;
323 
324 		if (!makerBet.makerFundWithdrawn) {
325 			makerBet.makerFundWithdrawn = true;
326 
327 			uint payout = 0;
328 			if (makerBet.outcome == BetOutcome.MakerWin) {
329 				uint trustedVerifierFeeMakerWin = mul(makerBet.totalStake, makerBet.trustedVerifier.feeRate) / ((10 ** feeRateDecimals) * 100);
330 				payout = sub(add(makerBet.totalFund, makerBet.totalStake), trustedVerifierFeeMakerWin);
331 			} else if (makerBet.outcome == BetOutcome.TakerWin) {
332 				payout = sub(makerBet.totalFund, makerBet.reservedFund);
333 			} else if (makerBet.outcome == BetOutcome.Draw || makerBet.outcome == BetOutcome.Canceled) {
334 				payout = makerBet.totalFund;
335 			}
336 
337 			if (payout > 0) {
338 				fullyWithdrawn = true;
339 
340 				if (!makerBet.maker.send(payout)) {
341 	                makerBet.makerFundWithdrawn = false;
342 	                fullyWithdrawn = false;
343 	            }
344 	        }
345         }
346 
347         return fullyWithdrawn;
348 	}
349 
350 	/// Payout to taker
351 	function payTaker(MakerBet storage makerBet, address taker) private returns (bool fullyWithdrawn) {
352 		fullyWithdrawn = false;
353 
354 		uint payout = 0;
355 
356 		for (uint betIndex = 0; betIndex < makerBet.takerBetsCount; betIndex++) {
357 			if (makerBet.takerBets[betIndex].taker == taker) {
358 				if (!makerBet.takerBets[betIndex].settled) {
359 					makerBet.takerBets[betIndex].settled = true;
360 
361 					if (makerBet.outcome == BetOutcome.MakerWin) {
362 						continue;
363 					} else if (makerBet.outcome == BetOutcome.TakerWin) {
364 						uint netProfit = mul(mul(makerBet.takerBets[betIndex].stake, sub(makerBet.takerBets[betIndex].odds, (10 ** oddsDecimals))), sub(((10 ** feeRateDecimals) * 100), makerBet.trustedVerifier.feeRate)) / (10 ** oddsDecimals) / ((10 ** feeRateDecimals) * 100);
365 						payout = add(payout, add(makerBet.takerBets[betIndex].stake, netProfit));
366 					} else if (makerBet.outcome == BetOutcome.Draw || makerBet.outcome == BetOutcome.Canceled) {
367 						payout = add(payout, makerBet.takerBets[betIndex].stake);
368 					}
369 				}
370 			}
371 		}
372 
373 		if (payout > 0) {
374 			fullyWithdrawn = true;
375 
376 			if (!taker.send(payout)) {
377 				fullyWithdrawn = false;
378 
379 				for (uint betIndex2 = 0; betIndex2 < makerBet.takerBetsCount; betIndex2++) {
380 					if (makerBet.takerBets[betIndex2].taker == taker) {
381 						if (makerBet.takerBets[betIndex2].settled) {
382 							makerBet.takerBets[betIndex2].settled = false;
383 						}
384 					}
385 				}
386             }
387         }
388 
389 		return fullyWithdrawn;
390 	}
391 
392 	/// Payout to verifier
393 	function payVerifier(MakerBet storage makerBet) private returns (bool fullyWithdrawn) {
394 		fullyWithdrawn = false;
395 
396 		if (!makerBet.trustedVerifierFeeSent) {
397 	    	makerBet.trustedVerifierFeeSent = true;
398 
399 	    	uint payout = 0;
400 			if (makerBet.outcome == BetOutcome.MakerWin) {
401 				uint trustedVerifierFeeMakerWin = mul(makerBet.totalStake, makerBet.trustedVerifier.feeRate) / ((10 ** feeRateDecimals) * 100);
402 				payout = add(baseVerifierFee, trustedVerifierFeeMakerWin);
403 			} else if (makerBet.outcome == BetOutcome.TakerWin) {
404 				uint trustedVerifierFeeTakerWin = mul(makerBet.reservedFund, makerBet.trustedVerifier.feeRate) / ((10 ** feeRateDecimals) * 100);
405 				payout = add(baseVerifierFee, trustedVerifierFeeTakerWin);
406 			} else if (makerBet.outcome == BetOutcome.Draw || makerBet.outcome == BetOutcome.Canceled) {
407 				payout = baseVerifierFee;
408 			}
409 
410 			if (payout > 0) {
411 				fullyWithdrawn = true;
412 
413 		    	if (!makerBet.trustedVerifier.addr.send(payout)) {
414 		    		makerBet.trustedVerifierFeeSent = false;
415 		    		fullyWithdrawn = false;
416 		    	}
417 	    	}
418 	    }
419 
420 	    return fullyWithdrawn;
421 	}
422 
423 	/// Settle a bet by trusted verifier
424 	function settleBet(uint makerBetId, address maker, uint outcome) external {
425 		require(outcome == 1 || outcome == 2 || outcome == 3 || outcome == 4);
426 
427 		MakerBet storage makerBet = makerBets[makerBetId][maker];
428 		require(makerBet.makerBetId != 0);
429 
430 		require(msg.sender == makerBet.trustedVerifier.addr);
431 
432 		require(makerBet.totalStake > 0);
433 
434 		require(makerBet.status != BetStatus.Settled);
435 
436 		BetOutcome betOutcome = BetOutcome(outcome);
437 		makerBet.outcome = betOutcome;
438 		makerBet.status = BetStatus.Settled;
439 
440 		payMaker(makerBet);
441 		payVerifier(makerBet);
442 
443 		emit LogSettleBet(makerBetId, maker);
444 	}
445 
446 	/// Manual withdraw fund from a bet after outcome is set
447 	function withdraw(uint makerBetId, address maker) external {
448 		MakerBet storage makerBet = makerBets[makerBetId][maker];
449 		require(makerBet.makerBetId != 0);
450 
451 		require(makerBet.outcome != BetOutcome.NotSettled);
452 
453 		require(makerBet.status == BetStatus.Settled);
454 
455 		bool fullyWithdrawn = false;
456 
457 		if (msg.sender == maker) {
458 			fullyWithdrawn = payMaker(makerBet);
459 		} else if (msg.sender == makerBet.trustedVerifier.addr) {
460 			fullyWithdrawn = payVerifier(makerBet);
461 		} else {
462 			fullyWithdrawn = payTaker(makerBet, msg.sender);
463 		}
464 
465 		if (fullyWithdrawn) {
466 			emit LogWithdraw(makerBetId, maker, msg.sender);
467 		}
468 	}
469 
470     /* External views */
471     function getOwner() external view returns(address) {
472         return owner;
473     }
474 
475     function isAdmin(address addr) external view returns(bool) {
476         return admins[addr];
477     }
478 
479     function getVerifier(address addr) external view returns(address, uint) {
480     	Verifier memory verifier = verifiers[addr];
481     	return (verifier.addr, verifier.feeRate);
482     }
483 
484     function getMakerBetBasicInfo(uint makerBetId, address maker) external view returns(uint, address, address, uint, uint) {
485     	MakerBet memory makerBet = makerBets[makerBetId][maker];
486     	return (makerBet.makerBetId, makerBet.maker, makerBet.trustedVerifier.addr, makerBet.trustedVerifier.feeRate, makerBet.expiry);
487     }
488 
489     function getMakerBetDetails(uint makerBetId, address maker) external view returns(uint, BetStatus, uint, uint, uint, uint, uint, BetOutcome, bool, bool) {
490 		MakerBet memory makerBet = makerBets[makerBetId][maker];
491     	return (makerBet.makerBetId, makerBet.status, makerBet.odds, makerBet.totalFund, makerBet.reservedFund, makerBet.takerBetsCount, makerBet.totalStake, makerBet.outcome, makerBet.makerFundWithdrawn, makerBet.trustedVerifierFeeSent);
492     }
493 
494     function getTakerBet(uint makerBetId, address maker, uint takerBetId, address taker) external view returns(uint, address, uint, uint, bool) {
495     	MakerBet memory makerBet = makerBets[makerBetId][maker];
496     	for (uint betIndex = 0; betIndex < makerBet.takerBetsCount; betIndex++) {
497 			TakerBet memory takerBet = makerBet.takerBets[betIndex];
498 
499 			if (takerBet.takerBetId == takerBetId && takerBet.taker == taker) {
500 				return (takerBet.takerBetId, takerBet.taker, takerBet.odds, takerBet.stake, takerBet.settled);
501 			}
502 		}
503     }
504 
505 	/* Math utilities */
506 	function mul(uint256 _a, uint256 _b) private pure returns(uint256 c) {
507 	    if (_a == 0) {
508 	      return 0;
509 	    }
510 
511 	    c = _a * _b;
512 	    assert(c / _a == _b);
513 	    return c;
514   	}
515 
516   	function sub(uint256 _a, uint256 _b) private pure returns(uint256) {
517     	assert(_b <= _a);
518     	return _a - _b;
519   	}
520 
521   	function add(uint256 _a, uint256 _b) private pure returns(uint256 c) {
522    		c = _a + _b;
523     	assert(c >= _a);
524     	return c;
525   	}
526 
527 }