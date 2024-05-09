1 pragma solidity 0.5.6;
2 
3 // * xether.io - is a gambling ecosystem, which makes a difference by caring about its users.
4 // It’s our passion for perfection, as well as finding and creating neat solutions,
5 // that keeps us driven towards our goals.
6 //
7 // * Uses hybrid commit-reveal + block hash random number generation that is immune
8 //   to tampering by players, house and miners. Apart from being fully transparent,
9 //   this also allows arbitrarily high bets.
10 
11 
12 interface xEtherTokensContractInterface {
13   function ecosystemDividends() external payable;
14 }
15 
16 contract XetherGames {
17     uint256 constant HOUSE_EDGE_MINIMUM_AMOUNT = 0.0003 ether;
18     uint256 constant MIN_JACKPOT_BET = 0.1 ether;
19     uint16 constant JACKPOT_MODULO = 1000;
20     uint256 constant JACKPOT_FEE = 0.001 ether;
21     uint256 constant MIN_BET = 0.01 ether;
22     uint256 constant MAX_AMOUNT = 300000 ether;
23     uint8 constant MAX_MODULO = 100;
24     uint8 constant MAX_MASK_MODULO = 40;
25     uint256 constant MAX_BET_MASK = 2 ** uint256(MAX_MASK_MODULO);
26     uint8 constant BET_EXPIRATION_BLOCKS = 250;
27     uint256 public DIVIDENDS_LIMIT = 1 ether;
28     uint16 constant PERCENTAGES_BASE = 1000;
29     address constant DUMMY_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
30     uint16 public luckyNumber = 777;
31 
32     uint8 public DIVIDENDS_PERCENT = 10; // 1% example: 15 will be 1.5%
33     uint8 public ADVERTISE_PERCENT = 0; // 0%
34     uint8 public HOUSE_EDGE_PERCENT = 10; // 1%
35 
36     uint8 constant ROULETTE_ID = 37;
37     uint8 constant ROULETTE_STAKES_LIMIT = 36;
38     uint8 public rouletteSkipComission = 1;
39     uint256 public rouletteTableLimit = 1.8 ether;
40     uint8 public ROULETTE_PERCENT = 10;
41 
42     uint8 constant PLINKO_BYTES = 16;
43     uint256 constant PLINKO_ID = 2 ** uint256(PLINKO_BYTES);
44     uint16[17] PLINKO1Ratios = [1000,800,600,300,200,130,100,80,50,80,100,130,200,300,600,800,1000];
45     uint16[17] PLINKO2Ratios = [2000,700,500,300,200,110,100,60,100,60,100,110,200,300,500,700,2000];
46     uint16[17] PLINKO3Ratios = [5000,800,300,200,140,120,110,100,40,100,110,120,140,200,300,800,5000];
47     uint8 public plinkoSkipComission = 2;
48     uint8 public PLINKO_PERCENT = HOUSE_EDGE_PERCENT;
49 
50     uint16 constant SLOTS_ID = 999;
51     uint8 constant SLOTS_COUNT = 5;
52     uint16[] SLOTSWinsRatios = [0, 50, 120, 200, 1500];
53     uint32[] SLOTSWildRatios = [0, 110, 250, 400, 3000, 10000];
54 
55     xEtherTokensContractInterface public xEtherTokensContract;
56 
57     address payable public owner;
58     address payable private nextOwner;
59 
60     uint256 public totalDividends = 0;
61     uint256 public totalAdvertise = 0;
62 
63     uint256 public maxProfit = 5 ether;
64     uint256 public maxProfitPlinko = 10 ether;
65     uint256 public maxProfitRoulette = 3.6 ether;
66 
67     address public secretSigner;
68     address public moderator;
69     address public croupier;
70     uint128 public jackpotSize;
71     uint128 public lockedInBets;
72 
73     struct Bet {
74         uint256 amount;
75         uint128 locked;
76         uint32 modulo;
77         uint8 rollUnder;
78         uint40 placeBlockNumber;
79         uint256 clientSeed;
80         uint40 mask;
81         address payable gambler;
82     }
83 
84     struct BetRoulette {
85       uint256 totalBetAmount;
86       uint128 locked;
87       mapping (uint8 => uint256) amount;
88       mapping (uint8 => uint8) rollUnder;
89       uint40 placeBlockNumber;
90       uint256 clientSeed;
91       mapping (uint8 => uint40) mask;
92       address payable gambler;
93       uint8 betsCount;
94     }
95 
96     mapping (uint => Bet) bets;
97     mapping (uint => BetRoulette) betsRoulette;
98     mapping (address => uint256) public bonusProgrammAccumulated;
99 
100     event FailedPayment(address beneficiary, uint commit, uint amount, string paymentType);
101     event Payment(address beneficiary, uint commit, uint amount, string paymentType);
102     event JackpotPayment(address indexed beneficiary, uint commit, uint amount);
103 
104     event PayDividendsSuccess(uint time, uint amount);
105     event PayDividendsFailed(uint time, uint amount);
106 
107     event Commit(uint commit, uint clietSeed, uint amount);
108 
109     constructor () public {
110         owner = msg.sender;
111         secretSigner = DUMMY_ADDRESS;
112         croupier = DUMMY_ADDRESS;
113     }
114 
115     modifier onlyOwner {
116         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
117         _;
118     }
119 
120     modifier onlyModeration {
121         require (msg.sender == owner || msg.sender == moderator, "Moderation methods called by non-moderator.");
122         _;
123     }
124 
125     modifier onlyCroupier {
126         require (msg.sender == croupier, "OnlyCroupier methods called by non-croupier.");
127         _;
128     }
129 
130     function approveNextOwner(address payable _nextOwner) external onlyOwner {
131         require (_nextOwner != owner, "Cannot approve current owner.");
132         nextOwner = _nextOwner;
133     }
134 
135     function acceptNextOwner() external {
136         require (msg.sender == nextOwner, "Can only accept preapproved new owner.");
137         owner = nextOwner;
138     }
139 
140     function () external payable {
141     }
142 
143     function setNewPercents(
144       uint8 newHouseEdgePercent,
145       uint8 newDividendsPercent,
146       uint8 newAdvertPercent
147     ) external onlyOwner {
148         // We guarantee that dividends will be minimum 0.5%
149         require(newDividendsPercent >= 5);
150         // Total percentages not greater then 3%
151         require(newHouseEdgePercent + newDividendsPercent + newAdvertPercent <= 30);
152 
153         HOUSE_EDGE_PERCENT = newHouseEdgePercent;
154         ADVERTISE_PERCENT = newAdvertPercent;
155         DIVIDENDS_PERCENT = newDividendsPercent;
156     }
157 
158     function setNewRoulettePercents(uint8 newRoulettePercent) external onlyModeration {
159         require(0 <= newRoulettePercent && newRoulettePercent <= 10);
160         ROULETTE_PERCENT = newRoulettePercent;
161     }
162 
163     function setNewPlinkoPercents(uint8 newPlinkoPercent) external onlyModeration {
164         require(0 <= newPlinkoPercent && newPlinkoPercent <= 10);
165         PLINKO_PERCENT = newPlinkoPercent;
166     }
167 
168     function setXEtherContract(address payable xEtherContract) external onlyOwner{
169         xEtherTokensContract = xEtherTokensContractInterface(xEtherContract);
170     }
171 
172     function setAddresses(address newCroupier, address newSecretSigner, address newModerator) external onlyOwner {
173         secretSigner = newSecretSigner;
174         croupier = newCroupier;
175         moderator = newModerator;
176     }
177 
178     function changeDividendsLimit(uint _newDividendsLimit) public onlyModeration {
179         DIVIDENDS_LIMIT = _newDividendsLimit;
180     }
181 
182     function setMaxProfit(uint _maxProfit) public onlyModeration {
183         require (_maxProfit < MAX_AMOUNT, "maxProfit cant be great then top limit.");
184         maxProfit = _maxProfit;
185     }
186 
187     function setMaxProfitPlinko(uint _maxProfitPlinko) public onlyModeration {
188         require (_maxProfitPlinko < MAX_AMOUNT, "maxProfitPlinko cant be great then top limit.");
189         maxProfitPlinko = _maxProfitPlinko;
190     }
191 
192     function setMaxProfitRoulette(uint _maxProfitRoulette) public onlyModeration {
193         require (_maxProfitRoulette < MAX_AMOUNT, "maxProfitRoulette cant be great then top limit.");
194         maxProfitRoulette = _maxProfitRoulette;
195     }
196 
197     function setRouletteTableLimit(uint _newRouletteTableLimit) public onlyModeration {
198         require (_newRouletteTableLimit < MAX_AMOUNT, "roultteTableLimit cant be great then top limit.");
199         rouletteTableLimit = _newRouletteTableLimit;
200     }
201 
202     function setComissionState(uint8 _newRouletteState, uint8 _newPlinkoState) public onlyModeration {
203         rouletteSkipComission = _newRouletteState;
204         plinkoSkipComission = _newPlinkoState;
205     }
206 
207     function releaseLockedInBetAmount() external onlyModeration {
208         lockedInBets = 0;
209     }
210 
211     function increaseJackpot(uint increaseAmount) external onlyModeration {
212         require (increaseAmount <= address(this).balance, "Increase amount larger than balance.");
213         require (jackpotSize + lockedInBets + increaseAmount <= address(this).balance, "Not enough funds.");
214         jackpotSize += uint128(increaseAmount);
215     }
216 
217     function withdrawFunds(address payable beneficiary, uint withdrawAmount) external onlyOwner {
218         require (withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
219         require (jackpotSize + lockedInBets + withdrawAmount <= address(this).balance, "Not enough funds.");
220         sendFunds(beneficiary, withdrawAmount, withdrawAmount, 0, 'withdraw');
221     }
222 
223     function withdrawAdvertiseFunds(address payable beneficiary, uint withdrawAmount) external onlyOwner {
224         require (withdrawAmount <= totalAdvertise, "Increase amount larger than balance.");
225         totalAdvertise -= withdrawAmount;
226         sendFunds(beneficiary, withdrawAmount, withdrawAmount, 0, 'withdraw');
227     }
228 
229     function getBonusProgrammLevel(address gambler) public view returns (uint8 discount) {
230       uint accumulated = bonusProgrammAccumulated[gambler];
231       discount = 0;
232 
233       if (accumulated >= 20 ether && accumulated < 100 ether) {
234         discount = 1;
235       } else if (accumulated >= 100 ether && accumulated < 500 ether) {
236         discount = 2;
237       } else if (accumulated >= 500 ether && accumulated < 1000 ether) {
238         discount = 3;
239       } else if (accumulated >= 1000 ether && accumulated < 5000 ether) {
240         discount = 4;
241       } else if (accumulated >= 5000 ether) {
242         discount = 5;
243       }
244     }
245 
246     function kill() external onlyOwner {
247         require (lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
248         selfdestruct(owner);
249     }
250 
251     function sendDividends() public payable {
252         if (address(xEtherTokensContract) != address(0)) {
253             uint tmpDividends = totalDividends;
254             xEtherTokensContract.ecosystemDividends.value(tmpDividends)();
255             totalDividends = 0;
256 
257             emit PayDividendsSuccess(now, tmpDividends);
258         }
259     }
260 
261     function placeBet(
262         uint betMask,
263         uint32 modulo,
264         uint commitLastBlock,
265         uint commit, uint256 clientSeed,
266         bytes32 r, bytes32 s
267     ) external payable {
268         Bet storage bet = bets[commit];
269         require (bet.gambler == address(0), "Bet should be in a 'clean' state.");
270 
271         uint amount = msg.value;
272         if (modulo > MAX_MODULO) {
273             require (modulo == PLINKO_ID || modulo == SLOTS_ID, "Modulo should be within range.");
274         } else {
275             require (modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
276         }
277 
278         require (amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
279         require (betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
280         require (block.number <= commitLastBlock, "Commit has expired.");
281         require (
282           secretSigner == ecrecover(keccak256(abi.encodePacked(uint40(commitLastBlock), commit)), 27, r, s) ||
283           secretSigner == ecrecover(keccak256(abi.encodePacked(uint40(commitLastBlock), commit)), 28, r, s),
284           "ECDSA signature is not valid."
285         );
286 
287         if (totalDividends >= DIVIDENDS_LIMIT) {
288           sendDividends();
289         }
290 
291         uint rollUnder;
292         uint mask;
293 
294         (mask, rollUnder, bet.locked) = prepareBet(betMask, modulo, amount, commit, clientSeed, msg.sender);
295 
296         bet.amount = amount;
297         bet.modulo = uint32(modulo);
298         bet.rollUnder = uint8(rollUnder);
299         bet.placeBlockNumber = uint40(block.number);
300         bet.mask = uint40(mask);
301         bet.clientSeed = clientSeed;
302         bet.gambler = msg.sender;
303     }
304 
305     function placeBetRoulette(
306         uint[] calldata betMask,
307         uint[] calldata betAmount,
308         uint commitLastBlock,
309         uint commit, uint256 clientSeed,
310         bytes32 r, bytes32 s
311     ) external payable {
312         BetRoulette storage betRoulette = betsRoulette[commit];
313 
314         require(msg.value <= rouletteTableLimit, "Bets sum must be LTE table limit");
315         betRoulette.betsCount = uint8(betMask.length);
316 
317         require (betRoulette.gambler == address(0), "Bet should be in a 'clean' state.");
318         require (block.number <= commitLastBlock, "Commit has expired.");
319         require (
320           secretSigner == ecrecover(keccak256(abi.encodePacked(uint40(commitLastBlock), commit)), 27, r, s) ||
321           secretSigner == ecrecover(keccak256(abi.encodePacked(uint40(commitLastBlock), commit)), 28, r, s),
322           "ECDSA signature is not valid."
323         );
324 
325         if (totalDividends >= DIVIDENDS_LIMIT) {
326           sendDividends();
327         }
328 
329         (betRoulette.betsCount, betRoulette.locked) = placeBetRouletteProcess(commit, betMask, betAmount);
330 
331         lockedInBets += betRoulette.locked;
332         require (lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
333 
334         if (rouletteSkipComission != 1) {
335           bonusProgrammAccumulated[msg.sender] += msg.value;
336         }
337 
338         betRoulette.totalBetAmount = msg.value;
339         betRoulette.placeBlockNumber = uint40(block.number);
340         betRoulette.clientSeed = clientSeed;
341         betRoulette.gambler = msg.sender;
342 
343         jackpotSize += msg.value >= MIN_JACKPOT_BET ? uint128(JACKPOT_FEE) : 0;
344 
345         emit Commit(commit, clientSeed, msg.value);
346     }
347 
348     function placeBetRouletteProcess (
349       uint commit, uint[] memory betMask, uint[] memory betAmount
350     ) internal returns (uint8 betsCount, uint128 locked) {
351       BetRoulette storage betRoulette = betsRoulette[commit];
352       betsCount = 0;
353       uint totalBetAmount = 0;
354       uint8 addBets = betRoulette.betsCount;
355       uint8 tmpBetCount = betRoulette.betsCount - 1;
356       uint128 curLocked = 0;
357       uint128 tmpLocked = 0;
358       bool numIsAlredyLocked = false;
359       uint8 bonuses = getBonusProgrammLevel(betRoulette.gambler);
360 
361       while (0 <= tmpBetCount) {
362         require (betMask[tmpBetCount] > 0 && betMask[tmpBetCount] < MAX_BET_MASK, "Mask should be within range.");
363 
364         // Check track sectors bets
365         if (betMask[tmpBetCount] == 38721851401) {  // Jeu 0
366           require (betAmount[tmpBetCount] >= MIN_BET * 4 && betAmount[tmpBetCount] <= MAX_AMOUNT, "Amount should be within range.");
367 
368           totalBetAmount += betAmount[tmpBetCount];
369           require (totalBetAmount <= msg.value, "Total bets amount should be LTE amount");
370 
371           // 12/15
372           (betRoulette.mask[tmpBetCount], betRoulette.rollUnder[tmpBetCount], curLocked) = prepareBetRoulette(36864, betAmount[tmpBetCount] / 4, bonuses);
373           betRoulette.amount[tmpBetCount] = betAmount[tmpBetCount] / 4;
374 
375           // 35/32
376           (betRoulette.mask[addBets], betRoulette.rollUnder[addBets], tmpLocked) = prepareBetRoulette(38654705664, betAmount[tmpBetCount] / 4, bonuses);
377           betRoulette.amount[addBets] = betAmount[tmpBetCount] / 4;
378           curLocked = (tmpLocked > curLocked) ? tmpLocked : curLocked;
379 
380           // 3/0
381           addBets += 1;
382           (betRoulette.mask[addBets], betRoulette.rollUnder[addBets], tmpLocked) = prepareBetRoulette(9, betAmount[tmpBetCount] / 4, bonuses);
383           betRoulette.amount[addBets] = betAmount[tmpBetCount] / 4;
384           curLocked = (tmpLocked > curLocked) ? tmpLocked : curLocked;
385 
386           // 26
387           addBets += 1;
388           (betRoulette.mask[addBets], betRoulette.rollUnder[addBets], tmpLocked) = prepareBetRoulette(67108864, betAmount[tmpBetCount] / 4, bonuses);
389           betRoulette.amount[addBets] = betAmount[tmpBetCount] / 4;
390           curLocked = (tmpLocked > curLocked) ? tmpLocked : curLocked;
391 
392           locked += curLocked;
393 
394           addBets += 1;
395           betsCount += 4;
396         } else if (betMask[tmpBetCount] == 39567790237) { // Voisins mask
397           require (betAmount[tmpBetCount] >= MIN_BET * 9 && betAmount[tmpBetCount] <= MAX_AMOUNT, "Amount should be within range.");
398 
399           totalBetAmount += betAmount[tmpBetCount];
400           require (totalBetAmount <= msg.value, "Total bets amount should be LTE amount");
401 
402           // 4/7
403           (betRoulette.mask[tmpBetCount], betRoulette.rollUnder[tmpBetCount], curLocked) = prepareBetRoulette(
404             144, betAmount[tmpBetCount] / 9, bonuses);
405           betRoulette.amount[tmpBetCount] = betAmount[tmpBetCount] / 9;
406 
407           // 12/15
408           (betRoulette.mask[addBets], betRoulette.rollUnder[addBets], tmpLocked) = prepareBetRoulette(
409             36864, betAmount[tmpBetCount] / 9, bonuses);
410           betRoulette.amount[addBets] = betAmount[tmpBetCount] / 9;
411           curLocked = (tmpLocked > curLocked) ? tmpLocked : curLocked;
412 
413           // 18/21
414           addBets += 1;
415           (betRoulette.mask[addBets], betRoulette.rollUnder[addBets], tmpLocked) = prepareBetRoulette(
416             2359296, betAmount[tmpBetCount] / 9, bonuses);
417           betRoulette.amount[addBets] = betAmount[tmpBetCount] / 9;
418           curLocked = (tmpLocked > curLocked) ? tmpLocked : curLocked;
419 
420           // 19/22
421           addBets += 1;
422           (betRoulette.mask[addBets], betRoulette.rollUnder[addBets], tmpLocked) = prepareBetRoulette(
423             4718592, betAmount[tmpBetCount] / 9, bonuses);
424           betRoulette.amount[addBets] = betAmount[tmpBetCount] / 9;
425           curLocked = (tmpLocked > curLocked) ? tmpLocked : curLocked;
426 
427           // 35/32
428           addBets += 1;
429           (betRoulette.mask[addBets], betRoulette.rollUnder[addBets], tmpLocked) = prepareBetRoulette(
430             38654705664, betAmount[tmpBetCount] / 9, bonuses);
431           betRoulette.amount[addBets] = betAmount[tmpBetCount] / 9;
432           curLocked = (tmpLocked > curLocked) ? tmpLocked : curLocked;
433 
434           // 25/26/28/29 (x2)
435           addBets += 1;
436           (betRoulette.mask[addBets], betRoulette.rollUnder[addBets], tmpLocked) = prepareBetRoulette(
437             905969664, betAmount[tmpBetCount] * 2 / 9, bonuses);
438           betRoulette.amount[addBets] = betAmount[tmpBetCount] * 2 / 9;
439           curLocked = (tmpLocked > curLocked) ? tmpLocked : curLocked;
440 
441           // 0/2/3 (x2)
442           addBets += 1;
443           (betRoulette.mask[addBets], betRoulette.rollUnder[addBets], tmpLocked) = prepareBetRoulette(
444             13, betAmount[tmpBetCount] * 2 / 9, bonuses);
445           betRoulette.amount[addBets] = betAmount[tmpBetCount] * 2 / 9;
446           curLocked = (tmpLocked > curLocked) ? tmpLocked : curLocked;
447 
448           locked += curLocked;
449 
450           addBets += 1;
451           betsCount += 7;
452         } else if (betMask[tmpBetCount] == 19328549442) { // Orphelins mask
453           require (betAmount[tmpBetCount] >= MIN_BET * 5 && betAmount[tmpBetCount] <= MAX_AMOUNT, "Amount should be within range.");
454 
455           totalBetAmount += betAmount[tmpBetCount];
456           require (totalBetAmount <= msg.value, "Total bets amount should be LTE amount");
457 
458           // 14/17
459           (betRoulette.mask[addBets], betRoulette.rollUnder[addBets], curLocked) = prepareBetRoulette(
460             147456, betAmount[tmpBetCount] / 5, bonuses);
461           betRoulette.amount[addBets] = betAmount[tmpBetCount] / 5;
462 
463           // 17/20
464           addBets += 1;
465           (betRoulette.mask[addBets], betRoulette.rollUnder[addBets], tmpLocked) = prepareBetRoulette(
466             1179648, betAmount[tmpBetCount] / 5, bonuses);
467           betRoulette.amount[addBets] = betAmount[tmpBetCount] / 5;
468           curLocked += tmpLocked;
469 
470           // 6/9
471           (betRoulette.mask[tmpBetCount], betRoulette.rollUnder[tmpBetCount], tmpLocked) = prepareBetRoulette(
472             576, betAmount[tmpBetCount] / 5, bonuses);
473           betRoulette.amount[tmpBetCount] = betAmount[tmpBetCount] / 5;
474           curLocked = (tmpLocked > curLocked) ? tmpLocked : curLocked;
475 
476           // 31/34
477           addBets += 1;
478           (betRoulette.mask[addBets], betRoulette.rollUnder[addBets], tmpLocked) = prepareBetRoulette(
479             19327352832, betAmount[tmpBetCount] / 5, bonuses);
480           betRoulette.amount[addBets] = betAmount[tmpBetCount] / 5;
481           curLocked = (tmpLocked > curLocked) ? tmpLocked : curLocked;
482 
483           // 1
484           addBets += 1;
485           (betRoulette.mask[addBets], betRoulette.rollUnder[addBets], tmpLocked) = prepareBetRoulette(
486             2, betAmount[tmpBetCount] / 5, bonuses);
487           betRoulette.amount[addBets] = betAmount[tmpBetCount] / 5;
488           curLocked = (tmpLocked > curLocked) ? tmpLocked : curLocked;
489 
490           locked += curLocked;
491 
492           addBets += 1;
493           betsCount += 5;
494         } else if (betMask[tmpBetCount] == 78542613792) { // Tier mask
495           require (betAmount[tmpBetCount] >= MIN_BET * 6 && betAmount[tmpBetCount] <= MAX_AMOUNT, "Amount should be within range.");
496 
497           totalBetAmount += betAmount[tmpBetCount];
498           require (totalBetAmount <= msg.value, "Total bets amount should be LTE amount");
499 
500           // 5/8
501           (betRoulette.mask[tmpBetCount], betRoulette.rollUnder[tmpBetCount], curLocked) = prepareBetRoulette(
502             288, betAmount[tmpBetCount] / 6, bonuses);
503           betRoulette.amount[tmpBetCount] = betAmount[tmpBetCount] / 6;
504 
505           // 10/11
506           (betRoulette.mask[addBets], betRoulette.rollUnder[addBets], tmpLocked) = prepareBetRoulette(
507             3072, betAmount[tmpBetCount] / 6, bonuses);
508           betRoulette.amount[addBets] = betAmount[tmpBetCount] / 6;
509           curLocked = (tmpLocked > curLocked) ? tmpLocked : curLocked;
510 
511           // 13/16
512           addBets += 1;
513           (betRoulette.mask[addBets], betRoulette.rollUnder[addBets], tmpLocked) = prepareBetRoulette(
514             73728, betAmount[tmpBetCount] / 6, bonuses);
515           betRoulette.amount[addBets] = betAmount[tmpBetCount] / 6;
516           curLocked = (tmpLocked > curLocked) ? tmpLocked : curLocked;
517 
518           // 23/24
519           addBets += 1;
520           (betRoulette.mask[addBets], betRoulette.rollUnder[addBets], tmpLocked) = prepareBetRoulette(
521             25165824, betAmount[tmpBetCount] / 6, bonuses);
522           betRoulette.amount[addBets] = betAmount[tmpBetCount] / 6;
523           curLocked = (tmpLocked > curLocked) ? tmpLocked : curLocked;
524 
525           // 27/30
526           addBets += 1;
527           (betRoulette.mask[addBets], betRoulette.rollUnder[addBets], tmpLocked) = prepareBetRoulette(
528             1207959552, betAmount[tmpBetCount] / 6, bonuses);
529           betRoulette.amount[addBets] = betAmount[tmpBetCount] / 6;
530           curLocked = (tmpLocked > curLocked) ? tmpLocked : curLocked;
531 
532           // 33/36
533           addBets += 1;
534           (betRoulette.mask[addBets], betRoulette.rollUnder[addBets], tmpLocked) = prepareBetRoulette(
535             77309411328, betAmount[tmpBetCount] / 6, bonuses);
536           betRoulette.amount[addBets] = betAmount[tmpBetCount] / 6;
537           curLocked = (tmpLocked > curLocked) ? tmpLocked : curLocked;
538 
539           locked += curLocked;
540 
541           addBets += 1;
542           betsCount += 6;
543         } else {
544           require (betAmount[tmpBetCount] >= MIN_BET && betAmount[tmpBetCount] <= MAX_AMOUNT, "Amount should be within range.");
545           totalBetAmount += betAmount[tmpBetCount];
546           require (totalBetAmount <= msg.value, "Total bets amount should be LTE amount");
547           (betRoulette.mask[tmpBetCount], betRoulette.rollUnder[tmpBetCount], tmpLocked) = prepareBetRoulette(
548             betMask[tmpBetCount], betAmount[tmpBetCount], bonuses);
549 
550           if (uint8(((betRoulette.mask[tmpBetCount] * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO) != 1) {
551             locked += tmpLocked;
552           } else {
553             if (!numIsAlredyLocked) {
554               numIsAlredyLocked = true;
555               locked += tmpLocked;
556             }
557           }
558 
559           betRoulette.amount[tmpBetCount] = betAmount[tmpBetCount];
560           betsCount += 1;
561         }
562 
563         if (tmpBetCount == 0) break;
564         tmpBetCount -= 1;
565       }
566     }
567 
568     function prepareBet(uint betMask, uint32 modulo, uint amount, uint commit, uint clientSeed, address gambler) private returns (uint mask, uint8 rollUnder, uint128 possibleWinAmount) {
569         if (modulo <= MAX_MASK_MODULO) {
570             rollUnder = uint8(((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO);
571             mask = betMask;
572         } else {
573             require (betMask > 0 && betMask <= modulo, "High modulo range, betMask larger than modulo.");
574             rollUnder = uint8(betMask);
575         }
576 
577         uint jackpotFee;
578 
579         (possibleWinAmount, jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder, gambler, true);
580         require (possibleWinAmount <= amount + maxProfitPlinko, "maxProfitPlinko limit violation.");
581 
582         bonusProgrammAccumulated[gambler] += amount;
583         lockedInBets += uint128(possibleWinAmount);
584         jackpotSize += uint128(jackpotFee);
585 
586         require (jackpotSize + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
587 
588         emit Commit(commit, clientSeed, amount);
589     }
590 
591     function prepareBetRoulette(uint betMask, uint amount, uint8 bonuses) private returns (uint40 retMask, uint8 retRollUnder, uint128 possibleWinAmount) {
592         uint8 rollUnder = uint8(((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO);
593         uint mask = betMask;
594 
595         possibleWinAmount = getRouletteWinAmount(amount, 36, rollUnder, bonuses, true);
596         require (possibleWinAmount <= amount + maxProfitRoulette, "maxProfitRoulette limit violation.");
597 
598         retMask = uint40(mask);
599         retRollUnder = rollUnder;
600     }
601 
602     function settleBet(uint reveal) external onlyCroupier {
603         uint commit = uint(keccak256(abi.encodePacked(reveal)));
604 
605         Bet storage bet = bets[commit];
606         uint placeBlockNumber = bet.placeBlockNumber;
607 
608         require (block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
609         require (block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Can't be queried by EVM.");
610 
611         if (bet.modulo == PLINKO_ID) {
612             settleBetPlinko(bet, reveal);
613         } else if (bet.modulo == SLOTS_ID) {
614             settleBetSlots(bet, reveal);
615         } else {
616             settleBetCommon(bet, reveal);
617         }
618 
619     }
620 
621     function settleBetRoulette(uint reveal) external onlyCroupier {
622         uint commit = uint(keccak256(abi.encodePacked(reveal)));
623 
624         BetRoulette storage betRoulette = betsRoulette[commit];
625         uint placeBlockNumber = betRoulette.placeBlockNumber;
626 
627         require (betRoulette.totalBetAmount > 0, "Bet already processed");
628         require (block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
629         require (block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Can't be queried by EVM.");
630 
631         settleBetRoulette(betRoulette, reveal);
632     }
633 
634     // Common bets
635     function settleBetCommon(Bet storage bet, uint reveal) private {
636         uint amount = bet.amount;
637         uint8 rollUnder = bet.rollUnder;
638 
639         require (amount != 0, "Bet should be in an 'active' state");
640 
641         bet.amount = 0;
642         bytes32 entropy = keccak256(abi.encodePacked(reveal, bet.clientSeed));
643         uint dice = uint(entropy) % bet.modulo;
644         uint diceWinAmount;
645         uint _jackpotFee;
646         uint diceWin;
647 
648         if (bet.modulo <= MAX_MASK_MODULO) {
649             if ((2 ** dice) & bet.mask != 0) {
650                 (diceWinAmount, _jackpotFee) = getDiceWinAmount(amount, bet.modulo, rollUnder, bet.gambler, false);
651                 diceWin = diceWinAmount;
652             }
653         } else {
654             if (dice < rollUnder) {
655                 (diceWinAmount, _jackpotFee) = getDiceWinAmount(amount, bet.modulo, rollUnder, bet.gambler, false);
656                 diceWin = diceWinAmount;
657             }
658         }
659 
660         lockedInBets -= uint128(bet.locked);
661 
662         uint jackpotWin = checkJackPotWin(entropy, amount, bet.modulo);
663         if (jackpotWin > 0) {
664             emit JackpotPayment(bet.gambler, uint(keccak256(abi.encodePacked(reveal))), jackpotWin);
665         }
666 
667         sendFunds(
668           bet.gambler,
669           diceWin + jackpotWin == 0 ? 1 wei : diceWin + jackpotWin,
670           diceWin,
671           uint(keccak256(abi.encodePacked(reveal))),
672           'payment'
673         );
674     }
675 
676     // Plinko
677     function settleBetPlinko(Bet storage bet, uint reveal) private {
678         uint amount = bet.amount;
679         uint rollUnder = bet.rollUnder;
680 
681         require (amount != 0, "Bet should be in an 'active' state");
682 
683         bet.amount = 0;
684         bytes32 entropy = keccak256(abi.encodePacked(reveal, bet.clientSeed));
685         uint dice = uint(entropy) % bet.modulo;
686         uint diceWin = _plinkoGetDiceWin(dice, amount, rollUnder, bet.gambler);
687 
688         lockedInBets -= uint128(bet.locked);
689 
690         uint jackpotWin = checkJackPotWin(entropy, amount, bet.modulo);
691         if (jackpotWin > 0) {
692             emit JackpotPayment(bet.gambler, uint(keccak256(abi.encodePacked(reveal))), jackpotWin);
693         }
694 
695         sendFunds(
696           bet.gambler,
697           diceWin + jackpotWin == 0 ? 1 wei : diceWin + jackpotWin,
698           diceWin,
699           uint(keccak256(abi.encodePacked(reveal))),
700           'payment'
701         );
702     }
703 
704     function _plinkoGetDiceWin(uint dice, uint amount, uint rollUnder, address gambler) internal view returns (uint) {
705         uint bytesCount = 0;
706         uint diceWin = 1;
707 
708         for (uint byteNum = 0; byteNum < PLINKO_BYTES; byteNum += 1) {
709             if ((2 ** byteNum) & dice != 0) {
710                 bytesCount += 1;
711             }
712         }
713 
714         uint inCellRatio = _getPlinkoCellRatio(rollUnder, bytesCount);
715         uint jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
716         uint totalPercentages;
717 
718         if (plinkoSkipComission == 2) {
719           totalPercentages = PLINKO_PERCENT + ADVERTISE_PERCENT + DIVIDENDS_PERCENT;
720         } else {
721           totalPercentages = HOUSE_EDGE_PERCENT + ADVERTISE_PERCENT + DIVIDENDS_PERCENT;
722         }
723 
724         uint houseEdge = amount * (totalPercentages - getBonusProgrammLevel(gambler)) / PERCENTAGES_BASE;
725         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
726             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
727         }
728 
729         diceWin = (amount - houseEdge - jackpotFee) * inCellRatio / 100;
730 
731         return diceWin;
732     }
733 
734     function _getPlinkoCellRatio(uint plinkoNum, uint cell) internal view returns (uint cellRatio) {
735       if (plinkoNum == 1) {
736         cellRatio = PLINKO1Ratios[cell];
737       } else if (plinkoNum == 2) {
738         cellRatio = PLINKO2Ratios[cell];
739       } else {
740         cellRatio = PLINKO3Ratios[cell];
741       }
742     }
743 
744     // Slots
745     function settleBetSlots(Bet storage bet, uint reveal) private {
746         uint amount = bet.amount;
747         uint modulo = bet.modulo;
748 
749         require (amount != 0, "Bet should be in an 'active' state");
750 
751         bet.amount = 0;
752         bytes32 entropy = keccak256(abi.encodePacked(reveal, bet.clientSeed));
753         uint diceWin = _slotsWinAmount(entropy, amount, bet.gambler);
754 
755         lockedInBets -= uint128(bet.locked);
756 
757         uint jackpotWin = checkJackPotWin(entropy, amount, modulo);
758         if (jackpotWin > 0) {
759             emit JackpotPayment(bet.gambler, uint(keccak256(abi.encodePacked(reveal))), jackpotWin);
760         }
761 
762         sendFunds(
763           bet.gambler,
764           diceWin + jackpotWin == 0 ? 1 wei : diceWin + jackpotWin,
765           diceWin,
766           uint(keccak256(abi.encodePacked(reveal))),
767           'payment'
768         );
769     }
770 
771     function _slotsWinAmount(bytes32 entropy, uint amount, address gambler) internal view returns (uint winAmount) {
772         uint8 wins;
773         uint8 wild;
774 
775         (wins, wild) = _slotsCheckWin(entropy);
776 
777         winAmount = 0;
778 
779         uint jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
780         uint totalPercentages = HOUSE_EDGE_PERCENT + ADVERTISE_PERCENT + DIVIDENDS_PERCENT;
781         uint houseEdge = amount * (totalPercentages - getBonusProgrammLevel(gambler)) / PERCENTAGES_BASE;
782 
783         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
784             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
785         }
786 
787         winAmount = (amount - houseEdge - jackpotFee) / 100 * SLOTSWinsRatios[wins];
788         winAmount += (amount - houseEdge - jackpotFee) / 100 * SLOTSWildRatios[wild];
789     }
790 
791     function _slotsCheckWin(bytes32 slots) internal pure returns(uint8 wins, uint8 wild) {
792         uint curNum;
793         uint prevNum;
794         bytes1 charAtPos;
795         uint8 firstNums;
796         uint8 prevWins = 0;
797         uint8 curWins = 0;
798 
799         wins = 0;
800         wild = 0;
801 
802         for(uint8 i = 0; i < SLOTS_COUNT; i++) {
803             charAtPos = charAt(slots, i + 2);
804             firstNums = getLastN(charAtPos, 4);
805             curNum = uint(firstNums);
806 
807             if (curNum > 8) {
808                 curNum = 16 - curNum;
809             }
810 
811             if (curNum == 7) wild += 1;
812 
813             if (i == 0) {
814                 prevNum = curNum;
815                 continue;
816             }
817 
818             if (prevNum == curNum) {
819                 curWins += 1;
820             } else {
821                 prevWins = (curWins > prevWins) ? curWins : prevWins;
822                 curWins = 0;
823             }
824 
825             prevNum = curNum;
826         }
827 
828         wins = (curWins > prevWins) ? curWins : prevWins;
829     }
830 
831     function settleBetRoulette(BetRoulette storage betRoulette, uint reveal) private {
832         require (betRoulette.totalBetAmount != 0, "Bet should be in an 'active' state");
833         address payable gambler = betRoulette.gambler;
834         bytes32 entropy = keccak256(abi.encodePacked(reveal, betRoulette.clientSeed));
835         uint diceWin = 0;
836         uint diceWinAmount;
837         uint feeToJP = betRoulette.totalBetAmount >= MIN_JACKPOT_BET ? JACKPOT_FEE / betRoulette.betsCount : 0;
838 
839         uint dice = uint(entropy) % ROULETTE_ID;
840 
841         uint8 bonuses = getBonusProgrammLevel(betRoulette.gambler);
842 
843         for(uint8 index = 0; index < betRoulette.betsCount; index += 1) {
844           if ((2 ** dice) & betRoulette.mask[index] != 0) {
845               diceWinAmount = getRouletteWinAmount(betRoulette.amount[index] - feeToJP, ROULETTE_ID - 1, betRoulette.rollUnder[index], bonuses, false);
846               diceWin += diceWinAmount;
847           }
848         }
849 
850         lockedInBets -= betRoulette.locked;
851 
852         uint jackpotWin = checkJackPotWin(entropy, betRoulette.totalBetAmount, ROULETTE_ID);
853         if (jackpotWin > 0) {
854             emit JackpotPayment(gambler, uint(keccak256(abi.encodePacked(reveal))), jackpotWin);
855         }
856 
857         sendFunds(
858           gambler,
859           diceWin + jackpotWin == 0 ? 1 wei : diceWin + jackpotWin,
860           diceWin,
861           uint(keccak256(abi.encodePacked(reveal))),
862           'payment'
863         );
864 
865         betRoulette.totalBetAmount = 0;
866     }
867 
868     function refundBet(uint commit) external {
869         Bet storage bet = bets[commit];
870         uint amount = bet.amount;
871 
872         require (amount != 0, "Bet should be in an 'active' state");
873         require (block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
874 
875         bet.amount = 0;
876         lockedInBets -= uint128(bet.locked);
877 
878         if (amount >= MIN_JACKPOT_BET && jackpotSize > JACKPOT_FEE) {
879           jackpotSize -= uint128(JACKPOT_FEE);
880         }
881 
882         sendFunds(bet.gambler, amount, amount, commit, 'refund');
883     }
884 
885     function refundBetRoulette(uint commit) external {
886         BetRoulette storage betRoulette = betsRoulette[commit];
887         uint amount = betRoulette.totalBetAmount;
888 
889         require (amount != 0, "Bet should be in an 'active' state");
890         require (block.number > betRoulette.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
891 
892         betRoulette.totalBetAmount = 0;
893 
894         for(uint8 index = 0; index < betRoulette.betsCount; index += 1) {
895           betRoulette.amount[index] = 0;
896         }
897 
898         lockedInBets -= betRoulette.locked;
899 
900         if (amount >= MIN_JACKPOT_BET && jackpotSize > JACKPOT_FEE) {
901           jackpotSize -= uint128(JACKPOT_FEE);
902         }
903 
904         sendFunds(betRoulette.gambler, amount, amount, commit, 'refund');
905     }
906 
907     function getDiceWinAmount(uint amount, uint32 modulo, uint8 rollUnder, address gambler, bool init) private returns (uint128 winAmount, uint jackpotFee) {
908         require (0 < rollUnder && rollUnder <= modulo, "Win probability out of range.");
909 
910         jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
911         uint8 totalPercentages;
912 
913         if (plinkoSkipComission == 2) { // Plinko
914           totalPercentages = PLINKO_PERCENT + ADVERTISE_PERCENT + DIVIDENDS_PERCENT;
915         } else { // All other games
916           totalPercentages = HOUSE_EDGE_PERCENT + ADVERTISE_PERCENT + DIVIDENDS_PERCENT;
917         }
918 
919         uint houseEdge = amount * (totalPercentages - getBonusProgrammLevel(gambler)) / PERCENTAGES_BASE;
920         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
921             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
922         }
923 
924         require (houseEdge + jackpotFee <= amount, "Bet doesn't even cover house edge.");
925 
926         if (init) {
927           totalDividends += amount * DIVIDENDS_PERCENT / PERCENTAGES_BASE;
928           totalAdvertise += amount * ADVERTISE_PERCENT / PERCENTAGES_BASE;
929         }
930 
931         if (modulo == PLINKO_ID) {
932           // We lock maximum for selected plinko row
933           if (rollUnder == 1) {
934             modulo = 10; // equal to  PLINKO1Ratios[0] / 100
935           } else if (rollUnder == 2) {
936             modulo = 20; // equal to  PLINKO2Ratios[0] / 100
937           } else {
938             modulo = 50; // equal to  PLINKO3Ratios[0] / 100
939           }
940 
941           rollUnder = 1;
942         }
943 
944         if (modulo == SLOTS_ID) {
945           modulo = 5; // We lock x5 for slots
946           rollUnder = 1;
947         }
948 
949         winAmount = uint128((amount - houseEdge - jackpotFee) * modulo / rollUnder);
950     }
951 
952     function getRouletteWinAmount(uint amount, uint32 modulo, uint8 rollUnder, uint8 bonuses, bool init) private returns (uint128 winAmount) {
953         require (0 < rollUnder && rollUnder <= modulo, "Win probability out of range.");
954         uint houseEdge;
955 
956         if (rouletteSkipComission == 1) { // Roulette
957           houseEdge = amount * ROULETTE_PERCENT / PERCENTAGES_BASE;
958         } else {
959           if (init) {
960             totalDividends += amount * DIVIDENDS_PERCENT / PERCENTAGES_BASE;
961             totalAdvertise += amount * ADVERTISE_PERCENT / PERCENTAGES_BASE;
962           }
963 
964           houseEdge = amount * (HOUSE_EDGE_PERCENT + ADVERTISE_PERCENT + DIVIDENDS_PERCENT - bonuses) / PERCENTAGES_BASE;
965         }
966 
967         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
968             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
969         }
970         require (houseEdge <= amount, "Bet doesn't even cover house edge.");
971 
972         winAmount = uint128((amount - houseEdge) * modulo / rollUnder);
973     }
974 
975     function sendFunds(address payable beneficiary, uint amount, uint successLogAmount, uint commit, string memory paymentType) private {
976         if (beneficiary.send(amount)) {
977             emit Payment(beneficiary, commit, successLogAmount, paymentType);
978         } else {
979             emit FailedPayment(beneficiary, commit, amount, paymentType);
980         }
981     }
982 
983     function checkJackPotWin(bytes32 entropy, uint amount, uint modulo) internal returns (uint jackpotWin) {
984         jackpotWin = 0;
985         if (amount >= MIN_JACKPOT_BET) {
986             uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;
987 
988             if (jackpotRng == luckyNumber) {
989                 jackpotWin = jackpotSize;
990                 jackpotSize = 0;
991             }
992         }
993     }
994 
995     uint constant POPCNT_MULT = 0x0000000000002000000000100000000008000000000400000000020000000001;
996     uint constant POPCNT_MASK = 0x0001041041041041041041041041041041041041041041041041041041041041;
997     uint constant POPCNT_MODULO = 0x3F;
998 
999     function charAt(bytes32 b, uint char) private pure returns (bytes1) {
1000         return bytes1(uint8(uint(b) / (2**((31 - char) * 8))));
1001     }
1002 
1003     function getLastN(bytes1 a, uint8 n) private pure returns (uint8) {
1004         uint8 lastN = uint8(a) % uint8(2) ** n;
1005         return lastN;
1006     }
1007 }