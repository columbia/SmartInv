1 pragma solidity ^0.4.24;
2 
3 contract InterbetCore {
4 
5     /* Global constants */
6     uint constant oddsDecimals = 2; // Max. decimal places of odds
7     uint constant feeRateDecimals = 1; // Max. decimal places of fee rate
8 
9     uint public minMakerBetFund = 100 * 1 finney; // Minimum fund of a maker bet
10 
11     uint public maxAllowedTakerBetsPerMakerBet = 100; // Limit the number of taker-bets in 1 maker-bet
12     uint public minAllowedStakeInPercentage = 1; // 100 ÷ maxAllowedTakerBetsPerMakerBet
13 
14     /* Owner and admins */
15     address private owner;
16     mapping(address => bool) private admins;
17 
18     modifier onlyOwner() {
19         require(msg.sender == owner);
20         _;
21     }
22 
23     function changeOwner(address newOwner) external onlyOwner {
24         owner = newOwner;
25     }
26 
27     function addAdmin(address addr) external onlyOwner {
28         admins[addr] = true;
29     }
30 
31     function removeAdmin(address addr) external onlyOwner {
32         admins[addr] = false;
33     }
34 
35     modifier onlyAdmin() {
36         require(admins[msg.sender] == true);
37         _;
38     }
39 
40     function changeMinMakerBetFund(uint weis) external onlyAdmin {
41         minMakerBetFund = mul(weis, 1 wei);
42     }
43 
44     function changeTakerBetConstraints(uint maxCount, uint minPercentage) external onlyAdmin {
45         maxAllowedTakerBetsPerMakerBet = maxCount;
46         minAllowedStakeInPercentage = minPercentage;
47     }
48 
49     /* Events */
50     event LogUpdateVerifier(address indexed addr, uint oldFeeRate, uint newFeeRate, uint oldBaseFee, uint newBaseFee);
51     event LogMakeBet(uint indexed makerBetId, address indexed maker);
52     event LogAddFund(uint indexed makerBetId, address indexed maker, uint oldTotalFund, uint newTotalFund);
53     event LogUpdateOdds(uint indexed makerBetId, address indexed maker, uint oldOdds, uint newOdds);
54     event LogPauseBet(uint indexed makerBetId, address indexed maker);
55     event LogReopenBet(uint indexed makerBetId, address indexed maker);
56     event LogCloseBet(uint indexed makerBetId, address indexed maker);
57     event LogTakeBet(uint indexed makerBetId, address indexed maker, uint indexed takerBetId, address taker);
58     event LogSettleBet(uint indexed makerBetId, address indexed maker);
59     event LogWithdraw(uint indexed makerBetId, address indexed maker, address indexed addr);
60 
61     /* Betting Core */
62     enum BetStatus {
63         Open, 
64         Paused, 
65         Closed, 
66         Settled
67     }
68 
69     enum BetOutcome {
70         NotSettled,
71         MakerWin,
72         TakerWin,
73         Draw,
74         Canceled
75     }
76 
77     struct MakerBet {
78         uint makerBetId;
79         address maker;
80         uint odds;
81         uint totalFund;
82         Verifier trustedVerifier;
83         uint expiry;
84         BetStatus status;
85         uint reservedFund;
86         uint takerBetsCount;
87         uint totalStake;
88         TakerBet[] takerBets;
89         BetOutcome outcome;
90         bool makerFundWithdrawn;
91         bool trustedVerifierFeeSent;
92     }
93 
94     struct TakerBet {
95         uint takerBetId;
96         address taker;
97         uint odds;
98         uint stake;
99         bool settled;
100     }
101 
102     struct Verifier {
103         address addr;
104         uint feeRate;
105         uint baseFee;
106     }
107 
108     uint public makerBetsCount;
109     mapping(uint => mapping(address => MakerBet)) private makerBets;
110 
111     mapping(address => Verifier) private verifiers;
112 
113     constructor() public {
114         owner = msg.sender;
115         makerBetsCount = 0;
116     }
117 
118     function() external payable {
119         revert();
120     }
121 
122     /// Update verifier's data
123     function updateVerifier(uint feeRate, uint baseFee) external {
124         require(feeRate >= 0 && feeRate <= ((10 ** feeRateDecimals) * 100));
125         require(baseFee >= 0 && baseFee <= 100000000 * 1 ether);
126 
127         Verifier storage verifier = verifiers[msg.sender];
128 
129         uint oldFeeRate = verifier.feeRate;
130         uint oldBaseFee = verifier.baseFee;
131 
132         verifier.addr = msg.sender;
133         verifier.feeRate = feeRate;
134         verifier.baseFee = baseFee;
135 
136         emit LogUpdateVerifier(msg.sender, oldFeeRate, feeRate, oldBaseFee, baseFee);
137     }
138 
139     /// Make a bet
140     function makeBet(uint makerBetId, uint odds, address trustedVerifier, uint trustedVerifierFeeRate, uint trustedVerifierBaseFee, uint expiry) external payable {
141         require(odds > (10 ** oddsDecimals) && odds < ((10 ** 8) * (10 ** oddsDecimals)));
142         require(expiry > now);
143 
144         MakerBet storage makerBet = makerBets[makerBetId][msg.sender];
145 
146         require(makerBet.makerBetId == 0);
147 
148         Verifier memory verifier = verifiers[trustedVerifier];
149 
150         require(verifier.addr != address(0x0));
151         require(trustedVerifierFeeRate == verifier.feeRate);
152         require(trustedVerifierBaseFee == verifier.baseFee);
153 
154         uint fund = sub(msg.value, trustedVerifierBaseFee);
155         require(fund >= minMakerBetFund);
156 
157         makerBet.makerBetId = makerBetId;
158         makerBet.maker = msg.sender;
159         makerBet.odds = odds;
160         makerBet.totalFund = fund;
161         makerBet.trustedVerifier = Verifier(verifier.addr, verifier.feeRate, verifier.baseFee);
162         makerBet.expiry = expiry;
163         makerBet.status = BetStatus.Open;
164         makerBet.reservedFund = 0;
165         makerBet.takerBetsCount = 0;
166         makerBet.totalStake = 0;
167 
168         makerBetsCount++;
169 
170         emit LogMakeBet(makerBetId, msg.sender);
171     }
172 
173     /// Increase total fund of a bet
174     function addFund(uint makerBetId) external payable {
175         MakerBet storage makerBet = makerBets[makerBetId][msg.sender];
176         require(makerBet.makerBetId != 0);
177 
178         require(now < makerBet.expiry);
179 
180         require(makerBet.status == BetStatus.Open || makerBet.status == BetStatus.Paused);
181 
182         require(msg.sender == makerBet.maker);
183 
184         require(msg.value > 0);
185 
186         uint oldTotalFund = makerBet.totalFund;
187 
188         makerBet.totalFund = add(makerBet.totalFund, msg.value);
189 
190         emit LogAddFund(makerBetId, msg.sender, oldTotalFund, makerBet.totalFund);
191     }
192 
193     /// Update odds of a bet
194     function updateOdds(uint makerBetId, uint odds) external {
195         require(odds > (10 ** oddsDecimals) && odds < ((10 ** 8) * (10 ** oddsDecimals)));
196 
197         MakerBet storage makerBet = makerBets[makerBetId][msg.sender];
198         require(makerBet.makerBetId != 0);
199 
200         require(now < makerBet.expiry);
201 
202         require(makerBet.status == BetStatus.Open || makerBet.status == BetStatus.Paused);
203 
204         require(msg.sender == makerBet.maker);
205 
206         require(odds != makerBet.odds);
207 
208         uint oldOdds = makerBet.odds;
209 
210         makerBet.odds = odds;
211 
212         emit LogUpdateOdds(makerBetId, msg.sender, oldOdds, makerBet.odds);
213     }
214 
215     /// Pause a bet
216     function pauseBet(uint makerBetId) external {
217         MakerBet storage makerBet = makerBets[makerBetId][msg.sender];
218         require(makerBet.makerBetId != 0);
219 
220         require(makerBet.status == BetStatus.Open);
221 
222         require(msg.sender == makerBet.maker);
223 
224         makerBet.status = BetStatus.Paused;
225 
226         emit LogPauseBet(makerBetId, msg.sender);
227     }
228 
229     /// Reopen a bet
230     function reopenBet(uint makerBetId) external {
231         MakerBet storage makerBet = makerBets[makerBetId][msg.sender];
232         require(makerBet.makerBetId != 0);
233 
234         require(makerBet.status == BetStatus.Paused);
235 
236         require(msg.sender == makerBet.maker);
237 
238         makerBet.status = BetStatus.Open;
239 
240         emit LogReopenBet(makerBetId, msg.sender);
241     }
242 
243     /// Close a bet and withdraw unused fund
244     function closeBet(uint makerBetId) external {
245         MakerBet storage makerBet = makerBets[makerBetId][msg.sender];
246         require(makerBet.makerBetId != 0);
247 
248         require(makerBet.status == BetStatus.Open || makerBet.status == BetStatus.Paused);
249 
250         require(msg.sender == makerBet.maker);
251 
252         makerBet.status = BetStatus.Closed;
253 
254         // refund unused fund to maker
255         uint unusedFund = sub(makerBet.totalFund, makerBet.reservedFund);
256 
257         if (unusedFund > 0) {
258             makerBet.totalFund = makerBet.reservedFund;
259 
260             uint refundAmount = unusedFund;
261             if (makerBet.totalStake == 0) {
262                 refundAmount = add(refundAmount, makerBet.trustedVerifier.baseFee); // Refund base verifier fee too if no taker-bets, because verifier do not need to settle the bet with no takers
263                 makerBet.makerFundWithdrawn = true;
264             }
265 
266             if (!makerBet.maker.send(refundAmount)) {
267                 makerBet.totalFund = add(makerBet.totalFund, unusedFund);
268                 makerBet.status = BetStatus.Paused;
269                 makerBet.makerFundWithdrawn = false;
270             } else {
271                 emit LogCloseBet(makerBetId, msg.sender);
272             }
273         } else {
274             emit LogCloseBet(makerBetId, msg.sender);
275         }
276     }
277 
278     /// Take a bet
279     function takeBet(uint makerBetId, address maker, uint odds, uint takerBetId) external payable {
280         require(msg.sender != maker);
281 
282         require(msg.value > 0);
283 
284         MakerBet storage makerBet = makerBets[makerBetId][maker];
285         require(makerBet.makerBetId != 0);
286 
287         require(msg.sender != makerBet.trustedVerifier.addr);
288 
289         require(now < makerBet.expiry);
290 
291         require(makerBet.status == BetStatus.Open);
292 
293         require(makerBet.odds == odds);
294 
295         // Avoid too many taker-bets in one maker-bet
296         require(makerBet.takerBetsCount < maxAllowedTakerBetsPerMakerBet);
297 
298         // Avoid too many tiny bets
299         uint minAllowedStake = mul(mul(makerBet.totalFund, (10 ** oddsDecimals)), minAllowedStakeInPercentage) / sub(odds, (10 ** oddsDecimals)) / 100;
300         uint maxAvailableStake = mul(sub(makerBet.totalFund, makerBet.reservedFund), (10 ** oddsDecimals)) / sub(odds, (10 ** oddsDecimals));
301         if (maxAvailableStake >= minAllowedStake) {
302             require(msg.value >= minAllowedStake);
303         } else {
304             require(msg.value >= sub(maxAvailableStake, (maxAvailableStake / 10)) && msg.value <= maxAvailableStake);
305         }
306 
307         // If remaining fund is not enough, send the money back.
308         require(msg.value <= maxAvailableStake);
309 
310         makerBet.takerBets.length++;
311         makerBet.takerBets[makerBet.takerBetsCount] = TakerBet(takerBetId, msg.sender, odds, msg.value, false);
312         makerBet.reservedFund = add(makerBet.reservedFund, mul(msg.value, sub(odds, (10 ** oddsDecimals))) / (10 ** oddsDecimals));   
313         makerBet.totalStake = add(makerBet.totalStake, msg.value);
314         makerBet.takerBetsCount++;
315 
316         emit LogTakeBet(makerBetId, maker, takerBetId, msg.sender);
317     }
318 
319     /// Settle a bet by trusted verifier
320     function settleBet(uint makerBetId, address maker, uint outcome) external {
321         require(outcome == 1 || outcome == 2 || outcome == 3 || outcome == 4);
322 
323         MakerBet storage makerBet = makerBets[makerBetId][maker];
324         require(makerBet.makerBetId != 0);
325 
326         require(msg.sender == makerBet.trustedVerifier.addr);
327 
328         require(makerBet.totalStake > 0);
329 
330         require(makerBet.status != BetStatus.Settled);
331 
332         BetOutcome betOutcome = BetOutcome(outcome);
333         makerBet.outcome = betOutcome;
334         makerBet.status = BetStatus.Settled;
335 
336         payMaker(makerBet);
337         payVerifier(makerBet);
338 
339         emit LogSettleBet(makerBetId, maker);
340     }
341 
342     /// Manual withdraw fund from a bet after outcome is set
343     function withdraw(uint makerBetId, address maker) external {
344         MakerBet storage makerBet = makerBets[makerBetId][maker];
345         require(makerBet.makerBetId != 0);
346 
347         require(makerBet.outcome != BetOutcome.NotSettled);
348 
349         require(makerBet.status == BetStatus.Settled);
350 
351         bool fullyWithdrawn = false;
352 
353         if (msg.sender == maker) {
354             fullyWithdrawn = payMaker(makerBet);
355         } else if (msg.sender == makerBet.trustedVerifier.addr) {
356             fullyWithdrawn = payVerifier(makerBet);
357         } else {
358             fullyWithdrawn = payTaker(makerBet, msg.sender);
359         }
360 
361         if (fullyWithdrawn) {
362             emit LogWithdraw(makerBetId, maker, msg.sender);
363         }
364     }
365 
366     /// Payout to maker
367     function payMaker(MakerBet storage makerBet) private returns (bool fullyWithdrawn) {
368         fullyWithdrawn = false;
369 
370         if (!makerBet.makerFundWithdrawn) {
371             makerBet.makerFundWithdrawn = true;
372 
373             uint payout = 0;
374             if (makerBet.outcome == BetOutcome.MakerWin) {
375                 uint trustedVerifierFeeMakerWin = mul(makerBet.totalStake, makerBet.trustedVerifier.feeRate) / ((10 ** feeRateDecimals) * 100);
376                 payout = sub(add(makerBet.totalFund, makerBet.totalStake), trustedVerifierFeeMakerWin);
377             } else if (makerBet.outcome == BetOutcome.TakerWin) {
378                 payout = sub(makerBet.totalFund, makerBet.reservedFund);
379             } else if (makerBet.outcome == BetOutcome.Draw || makerBet.outcome == BetOutcome.Canceled) {
380                 payout = makerBet.totalFund;
381             }
382 
383             if (payout > 0) {
384                 fullyWithdrawn = true;
385 
386                 if (!makerBet.maker.send(payout)) {
387                     makerBet.makerFundWithdrawn = false;
388                     fullyWithdrawn = false;
389                 }
390             }
391         }
392 
393         return fullyWithdrawn;
394     }
395 
396     /// Payout to taker
397     function payTaker(MakerBet storage makerBet, address taker) private returns (bool fullyWithdrawn) {
398         fullyWithdrawn = false;
399 
400         uint payout = 0;
401 
402         for (uint betIndex = 0; betIndex < makerBet.takerBetsCount; betIndex++) {
403             if (makerBet.takerBets[betIndex].taker == taker) {
404                 if (!makerBet.takerBets[betIndex].settled) {
405                     makerBet.takerBets[betIndex].settled = true;
406 
407                     if (makerBet.outcome == BetOutcome.MakerWin) {
408                         continue;
409                     } else if (makerBet.outcome == BetOutcome.TakerWin) {
410                         uint netProfit = mul(mul(makerBet.takerBets[betIndex].stake, sub(makerBet.takerBets[betIndex].odds, (10 ** oddsDecimals))), sub(((10 ** feeRateDecimals) * 100), makerBet.trustedVerifier.feeRate)) / (10 ** oddsDecimals) / ((10 ** feeRateDecimals) * 100);
411                         payout = add(payout, add(makerBet.takerBets[betIndex].stake, netProfit));
412                     } else if (makerBet.outcome == BetOutcome.Draw || makerBet.outcome == BetOutcome.Canceled) {
413                         payout = add(payout, makerBet.takerBets[betIndex].stake);
414                     }
415                 }
416             }
417         }
418 
419         if (payout > 0) {
420             fullyWithdrawn = true;
421 
422             if (!taker.send(payout)) {
423                 fullyWithdrawn = false;
424 
425                 for (uint betIndex2 = 0; betIndex2 < makerBet.takerBetsCount; betIndex2++) {
426                     if (makerBet.takerBets[betIndex2].taker == taker) {
427                         if (makerBet.takerBets[betIndex2].settled) {
428                             makerBet.takerBets[betIndex2].settled = false;
429                         }
430                     }
431                 }
432             }
433         }
434 
435         return fullyWithdrawn;
436     }
437 
438     /// Payout to verifier
439     function payVerifier(MakerBet storage makerBet) private returns (bool fullyWithdrawn) {
440         fullyWithdrawn = false;
441 
442         if (!makerBet.trustedVerifierFeeSent) {
443             makerBet.trustedVerifierFeeSent = true;
444 
445             uint payout = 0;
446             if (makerBet.outcome == BetOutcome.MakerWin) {
447                 uint trustedVerifierFeeMakerWin = mul(makerBet.totalStake, makerBet.trustedVerifier.feeRate) / ((10 ** feeRateDecimals) * 100);
448                 payout = add(makerBet.trustedVerifier.baseFee, trustedVerifierFeeMakerWin);
449             } else if (makerBet.outcome == BetOutcome.TakerWin) {
450                 uint trustedVerifierFeeTakerWin = mul(makerBet.reservedFund, makerBet.trustedVerifier.feeRate) / ((10 ** feeRateDecimals) * 100);
451                 payout = add(makerBet.trustedVerifier.baseFee, trustedVerifierFeeTakerWin);
452             } else if (makerBet.outcome == BetOutcome.Draw || makerBet.outcome == BetOutcome.Canceled) {
453                 payout = makerBet.trustedVerifier.baseFee;
454             }
455 
456             if (payout > 0) {
457                 fullyWithdrawn = true;
458 
459                 if (!makerBet.trustedVerifier.addr.send(payout)) {
460                     makerBet.trustedVerifierFeeSent = false;
461                     fullyWithdrawn = false;
462                 }
463             }
464         }
465 
466         return fullyWithdrawn;
467     }
468 
469     /* External views */
470     function getOwner() external view returns(address) {
471         return owner;
472     }
473 
474     function isAdmin(address addr) external view returns(bool) {
475         return admins[addr];
476     }
477 
478     function getVerifier(address addr) external view returns(address, uint, uint) {
479         Verifier memory verifier = verifiers[addr];
480         return (verifier.addr, verifier.feeRate, verifier.baseFee);
481     }
482 
483     function getMakerBetBasicInfo(uint makerBetId, address maker) external view returns(uint, address, address, uint, uint, uint) {
484         MakerBet memory makerBet = makerBets[makerBetId][maker];
485         return (makerBet.makerBetId, makerBet.maker, makerBet.trustedVerifier.addr, makerBet.trustedVerifier.feeRate, makerBet.trustedVerifier.baseFee, makerBet.expiry);
486     }
487 
488     function getMakerBetDetails(uint makerBetId, address maker) external view returns(uint, BetStatus, uint, uint, uint, uint, uint, BetOutcome, bool, bool) {
489         MakerBet memory makerBet = makerBets[makerBetId][maker];
490         return (makerBet.makerBetId, makerBet.status, makerBet.odds, makerBet.totalFund, makerBet.reservedFund, makerBet.takerBetsCount, makerBet.totalStake, makerBet.outcome, makerBet.makerFundWithdrawn, makerBet.trustedVerifierFeeSent);
491     }
492 
493     function getTakerBet(uint makerBetId, address maker, uint takerBetId, address taker) external view returns(uint, address, uint, uint, bool) {
494         MakerBet memory makerBet = makerBets[makerBetId][maker];
495         for (uint betIndex = 0; betIndex < makerBet.takerBetsCount; betIndex++) {
496             TakerBet memory takerBet = makerBet.takerBets[betIndex];
497 
498             if (takerBet.takerBetId == takerBetId && takerBet.taker == taker) {
499                 return (takerBet.takerBetId, takerBet.taker, takerBet.odds, takerBet.stake, takerBet.settled);
500             }
501         }
502     }
503 
504     /* Math utilities */
505     function mul(uint256 _a, uint256 _b) private pure returns(uint256 c) {
506         if (_a == 0) {
507             return 0;
508         }
509 
510         c = _a * _b;
511         assert(c / _a == _b);
512         return c;
513     }
514 
515     function sub(uint256 _a, uint256 _b) private pure returns(uint256) {
516         assert(_b <= _a);
517         return _a - _b;
518     }
519 
520     function add(uint256 _a, uint256 _b) private pure returns(uint256 c) {
521         c = _a + _b;
522         assert(c >= _a);
523         return c;
524     }
525 
526 }