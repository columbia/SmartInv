1 pragma solidity ^0.5.0;
2 
3 contract CryptoTycoonsVIPLib{
4     
5     address payable public owner;
6     
7     // Accumulated jackpot fund.
8     uint128 public jackpotSize;
9     uint128 public rankingRewardSize;
10     
11     mapping (address => uint) userExpPool;
12     mapping (address => bool) public callerMap;
13 
14     event RankingRewardPayment(address indexed beneficiary, uint amount);
15 
16     modifier onlyOwner {
17         require(msg.sender == owner, "OnlyOwner methods called by non-owner.");
18         _;
19     }
20 
21     modifier onlyCaller {
22         bool isCaller = callerMap[msg.sender];
23         require(isCaller, "onlyCaller methods called by non-caller.");
24         _;
25     }
26 
27     constructor() public{
28         owner = msg.sender;
29         callerMap[owner] = true;
30     }
31 
32     // Fallback function deliberately left empty. It's primary use case
33     // is to top up the bank roll.
34     function () external payable {
35     }
36 
37     function kill() external onlyOwner {
38         selfdestruct(owner);
39     }
40 
41     function addCaller(address caller) public onlyOwner{
42         bool isCaller = callerMap[caller];
43         if (isCaller == false){
44             callerMap[caller] = true;
45         }
46     }
47 
48     function deleteCaller(address caller) external onlyOwner {
49         bool isCaller = callerMap[caller];
50         if (isCaller == true) {
51             callerMap[caller] = false;
52         }
53     }
54 
55     function addUserExp(address addr, uint256 amount) public onlyCaller{
56         uint exp = userExpPool[addr];
57         exp = exp + amount;
58         userExpPool[addr] = exp;
59     }
60 
61     function getUserExp(address addr) public view returns(uint256 exp){
62         return userExpPool[addr];
63     }
64 
65     function getVIPLevel(address user) public view returns (uint256 level) {
66         uint exp = userExpPool[user];
67 
68         if(exp >= 25 ether && exp < 125 ether){
69             level = 1;
70         } else if(exp >= 125 ether && exp < 250 ether){
71             level = 2;
72         } else if(exp >= 250 ether && exp < 1250 ether){
73             level = 3;
74         } else if(exp >= 1250 ether && exp < 2500 ether){
75             level = 4;
76         } else if(exp >= 2500 ether && exp < 12500 ether){
77             level = 5;
78         } else if(exp >= 12500 ether && exp < 25000 ether){
79             level = 6;
80         } else if(exp >= 25000 ether && exp < 125000 ether){
81             level = 7;
82         } else if(exp >= 125000 ether && exp < 250000 ether){
83             level = 8;
84         } else if(exp >= 250000 ether && exp < 1250000 ether){
85             level = 9;
86         } else if(exp >= 1250000 ether){
87             level = 10;
88         } else{
89             level = 0;
90         }
91 
92         return level;
93     }
94 
95     function getVIPBounusRate(address user) public view returns (uint256 rate){
96         uint level = getVIPLevel(user);
97         return level;
98     }
99 
100     // This function is used to bump up the jackpot fund. Cannot be used to lower it.
101     function increaseJackpot(uint increaseAmount) external onlyCaller {
102         require (increaseAmount <= address(this).balance, "Increase amount larger than balance.");
103         require (jackpotSize + increaseAmount <= address(this).balance, "Not enough funds.");
104         jackpotSize += uint128(increaseAmount);
105     }
106 
107     function payJackpotReward(address payable to) external onlyCaller{
108         to.transfer(jackpotSize);
109         jackpotSize = 0;
110     }
111 
112     function getJackpotSize() external view returns (uint256){
113         return jackpotSize;
114     }
115 
116     function increaseRankingReward(uint amount) public onlyCaller{
117         require (amount <= address(this).balance, "Increase amount larger than balance.");
118         require (rankingRewardSize + amount <= address(this).balance, "Not enough funds.");
119         rankingRewardSize += uint128(amount);
120     }
121 
122     function payRankingReward(address payable to) external onlyCaller {
123         uint128 prize = rankingRewardSize / 2;
124         rankingRewardSize = rankingRewardSize - prize;
125         if(to.send(prize)){
126             emit RankingRewardPayment(to, prize);
127         }
128     }
129 
130     function getRankingRewardSize() external view returns (uint128){
131         return rankingRewardSize;
132     }
133 }
134 contract CryptoTycoonsConstants{
135     /// *** Constants section
136 
137     // Each bet is deducted 1% in favour of the house, but no less than some minimum.
138     // The lower bound is dictated by gas costs of the settleBet transaction, providing
139     // headroom for up to 10 Gwei prices.
140     uint constant HOUSE_EDGE_PERCENT = 1;
141     uint constant RANK_FUNDS_PERCENT = 7;
142     uint constant INVITER_BENEFIT_PERCENT = 7;
143     uint constant HOUSE_EDGE_MINIMUM_AMOUNT = 0.0004 ether;
144 
145     // Bets lower than this amount do not participate in jackpot rolls (and are
146     // not deducted JACKPOT_FEE).
147     uint constant MIN_JACKPOT_BET = 0.1 ether;
148 
149     // Chance to win jackpot (currently 0.1%) and fee deducted into jackpot fund.
150     uint constant JACKPOT_MODULO = 1000;
151     uint constant JACKPOT_FEE = 0.001 ether;
152 
153     // There is minimum and maximum bets.
154     uint constant MIN_BET = 0.01 ether;
155     uint constant MAX_AMOUNT = 10 ether;
156 
157     // Standard contract ownership transfer.
158     address payable public owner;
159     address payable private nextOwner;
160 
161     // Croupier account.
162     mapping (address => bool ) croupierMap;
163 
164     // Adjustable max bet profit. Used to cap bets against dynamic odds.
165     uint public maxProfit;
166 
167     address payable public VIPLibraryAddress;
168 
169     // The address corresponding to a private key used to sign placeBet commits.
170     address public secretSigner;
171 
172     // Events that are issued to make statistic recovery easier.
173     event FailedPayment(address indexed beneficiary, uint amount);
174     event VIPPayback(address indexed beneficiary, uint amount);
175     event WithdrawFunds(address indexed beneficiary, uint amount);
176 
177     constructor (uint _maxProfit) public {
178         owner = msg.sender;
179         secretSigner = owner;
180         maxProfit = _maxProfit;
181         croupierMap[owner] = true;
182     }
183 
184     // Standard modifier on methods invokable only by contract owner.
185     modifier onlyOwner {
186         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
187         _;
188     }
189 
190     // Standard modifier on methods invokable only by contract owner.
191     modifier onlyCroupier {
192         bool isCroupier = croupierMap[msg.sender];
193         require(isCroupier, "OnlyCroupier methods called by non-croupier.");
194         _;
195     }
196 
197 
198     // Fallback function deliberately left empty. It's primary use case
199     // is to top up the bank roll.
200     function () external payable {
201 
202     }
203 
204     // Standard contract ownership transfer implementation,
205     function approveNextOwner(address payable _nextOwner) external onlyOwner {
206         require (_nextOwner != owner, "Cannot approve current owner.");
207         nextOwner = _nextOwner;
208     }
209 
210     function acceptNextOwner() external {
211         require (msg.sender == nextOwner, "Can only accept preapproved new owner.");
212         owner = nextOwner;
213     }
214 
215     // See comment for "secretSigner" variable.
216     function setSecretSigner(address newSecretSigner) external onlyOwner {
217         secretSigner = newSecretSigner;
218     }
219 
220     function getSecretSigner() external onlyOwner view returns(address){
221         return secretSigner;
222     }
223 
224     function addCroupier(address newCroupier) external onlyOwner {
225         bool isCroupier = croupierMap[newCroupier];
226         if (isCroupier == false) {
227             croupierMap[newCroupier] = true;
228         }
229     }
230     
231     function deleteCroupier(address newCroupier) external onlyOwner {
232         bool isCroupier = croupierMap[newCroupier];
233         if (isCroupier == true) {
234             croupierMap[newCroupier] = false;
235         }
236     }
237 
238     function setVIPLibraryAddress(address payable addr) external onlyOwner{
239         VIPLibraryAddress = addr;
240     }
241 
242     // Change max bet reward. Setting this to zero effectively disables betting.
243     function setMaxProfit(uint _maxProfit) public onlyOwner {
244         require (_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
245         maxProfit = _maxProfit;
246     }
247     
248     // Funds withdrawal to cover costs of AceDice operation.
249     function withdrawFunds(address payable beneficiary, uint withdrawAmount) external onlyOwner {
250         require (withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
251         if (beneficiary.send(withdrawAmount)){
252             emit WithdrawFunds(beneficiary, withdrawAmount);
253         }
254     }
255 
256     function kill() external onlyOwner {
257         // require (lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
258         selfdestruct(owner);
259     }
260 
261     function thisBalance() public view returns(uint) {
262         return address(this).balance;
263     }
264 
265     function payTodayReward(address payable to) external onlyOwner {
266         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
267         vipLib.payRankingReward(to);
268     }
269 
270     function getRankingRewardSize() external view returns (uint128) {
271         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
272         return vipLib.getRankingRewardSize();
273     }
274         
275     function handleVIPPaybackAndExp(CryptoTycoonsVIPLib vipLib, address payable gambler, uint amount) internal returns(uint vipPayback) {
276         // CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
277         vipLib.addUserExp(gambler, amount);
278 
279         uint rate = vipLib.getVIPBounusRate(gambler);
280 
281         if (rate <= 0)
282             return 0;
283 
284         vipPayback = amount * rate / 10000;
285         if(vipPayback > 0){
286             emit VIPPayback(gambler, vipPayback);
287         }
288     }
289 
290     function increaseRankingFund(CryptoTycoonsVIPLib vipLib, uint amount) internal{
291         uint rankingFunds = uint128(amount * HOUSE_EDGE_PERCENT / 100 * RANK_FUNDS_PERCENT /100);
292         // uint128 rankingRewardFee = uint128(amount * HOUSE_EDGE_PERCENT / 100 * 9 /100);
293         VIPLibraryAddress.transfer(rankingFunds);
294         vipLib.increaseRankingReward(rankingFunds);
295     }
296 
297     function getMyAccuAmount() external view returns (uint){
298         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
299         return vipLib.getUserExp(msg.sender);
300     }
301 
302     function getJackpotSize() external view returns (uint){
303         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
304         return vipLib.getJackpotSize();
305     }
306    
307     function verifyCommit(uint commit, uint8 v, bytes32 r, bytes32 s) internal view {
308         // Check that commit is valid - it has not expired and its signature is valid.
309         // require (block.number <= commitLastBlock, "Commit has expired.");
310         //bytes32 signatureHash = keccak256(abi.encodePacked(commitLastBlock, commit));
311         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
312         bytes memory message = abi.encodePacked(commit);
313         bytes32 messageHash = keccak256(abi.encodePacked(prefix, keccak256(message)));
314         require (secretSigner == ecrecover(messageHash, v, r, s), "ECDSA signature is not valid.");
315     }
316 
317     function calcHouseEdge(uint amount) public pure returns (uint houseEdge) {
318         // 0.02
319         houseEdge = amount * HOUSE_EDGE_PERCENT / 100;
320         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
321             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
322         }
323     }
324 
325     function calcJackpotFee(uint amount) internal pure returns (uint jackpotFee) {
326         // 0.001
327         if (amount >= MIN_JACKPOT_BET) {
328             jackpotFee = JACKPOT_FEE;
329         }
330     }
331 
332     function calcRankFundsFee(uint amount) internal pure returns (uint rankFundsFee) {
333         // 0.01 * 0.07
334         rankFundsFee = amount * RANK_FUNDS_PERCENT / 10000;
335     }
336 
337     function calcInviterBenefit(uint amount) internal pure returns (uint invitationFee) {
338         // 0.01 * 0.07
339         invitationFee = amount * INVITER_BENEFIT_PERCENT / 10000;
340     }
341 
342     function processBet(
343         uint betMask, uint reveal, 
344         uint8 v, bytes32 r, bytes32 s, address payable inviter) 
345     external payable;
346 }
347 contract CardRPS is CryptoTycoonsConstants(10 ether)  {
348 
349     event FailedPayment(address indexed beneficiary, uint amount);
350     event Payment(address indexed beneficiary, uint amount, uint playerNum1, uint playerNum2, uint npcNum1, uint npcNum2, uint betAmount, uint rouletteIndex);
351     event JackpotPayment(address indexed beneficiary, uint amount, uint playerNum1, uint playerNum2, uint npcNum1, uint npcNum2, uint betAmount);
352     
353     struct RandomNumber{
354         uint8 playerNum1;
355         uint8 playerNum2;
356         uint8 npcNum1;
357         uint8 npcNum2;
358         uint8 rouletteIndex;
359     }
360 
361     function processBet(
362         uint betMask, uint reveal, 
363         uint8 v, bytes32 r, bytes32 s, address payable inviter) 
364         external payable {
365 
366         address payable gambler = msg.sender;
367 
368         // Validate input data ranges.
369         uint amount = msg.value;
370         // require (modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
371         require (amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
372 
373         if (inviter != address(0)){
374             require(gambler != inviter, "cannot invite myself");
375         }
376         uint commit = uint(keccak256(abi.encodePacked(reveal)));
377         verifyCommit(commit, v, r, s);
378 
379 
380         bytes32 entropy = keccak256(abi.encodePacked(reveal, blockhash(block.number)));
381 
382         processReward(gambler, amount, entropy, inviter);
383     }
384 
385     function processReward(
386         address payable gambler, uint amount, 
387         bytes32 entropy, address payable inviter) internal{
388 
389         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
390         // 1. increate vip exp
391         uint _vipPayback = handleVIPPaybackAndExp(vipLib, msg.sender, amount);
392 
393         // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
394         // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
395         // preimage is intractable), and house is unable to alter the "reveal" after
396         // placeBet have been mined (as Keccak256 collision finding is also intractable).
397         uint seed = uint(entropy);
398         // Do a roll by taking a modulo of entropy. Compute winning amount.
399 
400         RandomNumber memory randomNumber = RandomNumber(0, 0, 0, 0, 0);
401         // uint mask = 2 ** 8;
402         randomNumber.playerNum1 = uint8(seed % 3);
403         seed = seed / 2 ** 8;
404         
405         randomNumber.playerNum2 = uint8(seed % 3);        
406         seed = seed / 2 ** 8;
407 
408         randomNumber.npcNum1 = uint8(seed % 3);
409         seed = seed / 2 ** 8;
410 
411         randomNumber.npcNum2 = uint8(seed % 3);
412         seed = seed / 2 ** 8;
413 
414         randomNumber.rouletteIndex = uint8(seed % 12);
415         seed = seed / 2 ** 8;
416 
417         uint jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
418 
419         uint houseEdge = amount * HOUSE_EDGE_PERCENT / 100;
420 
421         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
422             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
423         }
424 
425         handleJackpotReward(vipLib, randomNumber, entropy, gambler, jackpotFee, amount);
426 
427         if(inviter != address(0)){
428             // pay 10% of house edge to inviter
429             inviter.transfer(amount * HOUSE_EDGE_PERCENT / 100 * 7 /100);
430         }
431 
432         
433         payBettingReward(gambler, randomNumber, amount, houseEdge, jackpotFee, _vipPayback);
434 
435 
436         increaseRankingFund(vipLib, amount);
437     }
438 
439     function handleJackpotReward(
440         CryptoTycoonsVIPLib vipLib, 
441         RandomNumber memory randomNumber, 
442         bytes32 entropy,
443         address payable gambler, uint jackpotFee, uint amount) private {
444 
445         uint jackpotWin = 0;
446         // Roll for a jackpot (if eligible).
447         if (amount >= MIN_JACKPOT_BET) {
448                         
449             VIPLibraryAddress.transfer(jackpotFee);
450             vipLib.increaseJackpot(jackpotFee);
451 
452             // The second modulo, statistically independent from the "main" dice roll.
453             // Effectively you are playing two games at once!
454             // uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;
455 
456             // Bingo!
457             if ((uint(entropy) / 100) % JACKPOT_MODULO == 0) {
458                 jackpotWin = vipLib.getJackpotSize();
459                 vipLib.payJackpotReward(gambler);
460             }
461         }
462         
463         // Log jackpot win.
464         if (jackpotWin > 0) {
465             emit JackpotPayment(gambler, 
466                     jackpotWin, 
467                     randomNumber.playerNum1, 
468                     randomNumber.playerNum2, 
469                     randomNumber.npcNum1, 
470                     randomNumber.npcNum2, 
471                     amount);
472         }
473     }
474 
475     function payBettingReward(
476         address payable gambler, 
477         RandomNumber memory randomNumber, 
478         uint amount, uint houseEdge, uint jackpotFee,
479         uint vipPayback) private {
480         uint8 winValue = calculateWinValue(randomNumber); // 0 -> draw, 1 -> user win, 2 -> npc win
481 
482         uint winAmount = 0;
483 
484         if (winValue == 0) {
485             // draw
486             winAmount = amount - houseEdge - jackpotFee;
487         } else if (winValue == 1) {
488             // user win
489             winAmount = (amount - houseEdge - jackpotFee) 
490                             * getRouletteRate(randomNumber.rouletteIndex) / 10;
491         } else {
492 
493         }
494 
495         winAmount += vipPayback;
496         if(winAmount > 0){
497             if (gambler.send(winAmount)) {
498                 emit Payment(gambler, winAmount, 
499                     randomNumber.playerNum1, 
500                     randomNumber.playerNum2, 
501                     randomNumber.npcNum1, 
502                     randomNumber.npcNum2,
503                     amount, randomNumber.rouletteIndex);
504             } else {
505                 emit FailedPayment(gambler, amount);
506             }
507         }else{
508             emit Payment(gambler, winAmount, 
509                 randomNumber.playerNum1, 
510                 randomNumber.playerNum2, 
511                 randomNumber.npcNum1, 
512                 randomNumber.npcNum2,
513                 amount, randomNumber.rouletteIndex);
514         }
515         
516         // Send the funds to gambler.
517         // sendFunds(gambler, winAmount == 0 ? 1 wei : winAmount, winAmount, 
518         //             randomNumber.playerNum1, 
519         //             randomNumber.playerNum2, 
520         //             randomNumber.npcNum1, 
521         //             randomNumber.npcNum2, 
522         //             amount,
523         //             randomNumber.rouletteIndex);
524     }
525 
526     function calculateWinValue(RandomNumber memory randomNumber) private pure returns (uint8){
527         uint8 playerNum1 = randomNumber.playerNum1;
528         uint8 playerNum2 = randomNumber.playerNum2;
529         uint8 npcNum1 = randomNumber.npcNum1;
530         uint8 npcNum2 = randomNumber.npcNum2;
531 
532         uint8 winValue = 0;
533         if (playerNum1 == npcNum1){ // num 0 -> scissors, 1 -> rock, 2 -> papper
534             if (playerNum2 == npcNum2){
535                 winValue = 0;
536             } else if(playerNum2 == 0 && npcNum2 == 2){
537                 winValue = 1; // user win
538             } else if(playerNum2 == 1 && npcNum2 == 0){
539                 winValue = 1; // user win
540             } else if(playerNum2 == 2 && npcNum2 == 1){
541                 winValue = 1; // user win
542             } else{
543                 winValue = 2; // npc win
544             }
545         } else if(playerNum1 == 0 && npcNum1 == 2){
546             winValue = 1; // user win
547         } else if(playerNum1 == 1 && npcNum1 == 0){
548             winValue = 1; // user win
549         } else if(playerNum1 == 2 && npcNum1 == 1){
550             winValue = 1; // user win
551         } else{
552             winValue = 2; // npc win
553         } 
554         return winValue;
555     }
556 
557     function getRouletteRate(uint index) private pure returns (uint8){
558         uint8 rate = 11;
559         if (index == 0){
560             rate = 50;
561         } else if(index== 1){
562             rate = 11;
563         } else if(index== 2){
564             rate = 20;
565         } else if(index== 3){
566             rate = 15;
567         } else if(index== 4){
568             rate = 20;
569         } else if(index== 5){
570             rate = 11;
571         } else if(index== 6){
572             rate = 20;
573         } else if(index== 7){
574             rate = 15;
575         } else if(index== 8){
576             rate = 20;
577         } else if(index== 9){
578             rate = 11;
579         } else if(index== 10){
580             rate = 20;
581         } else if(index== 11){
582             rate = 15;
583         }
584         return rate;
585     }
586 }