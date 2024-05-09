1 // solium-disable linebreak-style
2 pragma solidity ^0.5.0;
3 
4 contract CryptoTycoonsVIPLib{
5     
6     address payable public owner;
7     
8     // Accumulated jackpot fund.
9     uint128 public jackpotSize;
10     uint128 public rankingRewardSize;
11     
12     mapping (address => uint) userExpPool;
13     mapping (address => bool) public callerMap;
14 
15     event RankingRewardPayment(address indexed beneficiary, uint amount);
16 
17     modifier onlyOwner {
18         require(msg.sender == owner, "OnlyOwner methods called by non-owner.");
19         _;
20     }
21 
22     modifier onlyCaller {
23         bool isCaller = callerMap[msg.sender];
24         require(isCaller, "onlyCaller methods called by non-caller.");
25         _;
26     }
27 
28     constructor() public{
29         owner = msg.sender;
30         callerMap[owner] = true;
31     }
32 
33     // Fallback function deliberately left empty. It's primary use case
34     // is to top up the bank roll.
35     function () external payable {
36     }
37 
38     function kill() external onlyOwner {
39         selfdestruct(owner);
40     }
41 
42     function addCaller(address caller) public onlyOwner{
43         bool isCaller = callerMap[caller];
44         if (isCaller == false){
45             callerMap[caller] = true;
46         }
47     }
48 
49     function deleteCaller(address caller) external onlyOwner {
50         bool isCaller = callerMap[caller];
51         if (isCaller == true) {
52             callerMap[caller] = false;
53         }
54     }
55 
56     function addUserExp(address addr, uint256 amount) public onlyCaller{
57         uint exp = userExpPool[addr];
58         exp = exp + amount;
59         userExpPool[addr] = exp;
60     }
61 
62     function getUserExp(address addr) public view returns(uint256 exp){
63         return userExpPool[addr];
64     }
65 
66     function getVIPLevel(address user) public view returns (uint256 level) {
67         uint exp = userExpPool[user];
68 
69         if(exp >= 25 ether && exp < 125 ether){
70             level = 1;
71         } else if(exp >= 125 ether && exp < 250 ether){
72             level = 2;
73         } else if(exp >= 250 ether && exp < 1250 ether){
74             level = 3;
75         } else if(exp >= 1250 ether && exp < 2500 ether){
76             level = 4;
77         } else if(exp >= 2500 ether && exp < 12500 ether){
78             level = 5;
79         } else if(exp >= 12500 ether && exp < 25000 ether){
80             level = 6;
81         } else if(exp >= 25000 ether && exp < 125000 ether){
82             level = 7;
83         } else if(exp >= 125000 ether && exp < 250000 ether){
84             level = 8;
85         } else if(exp >= 250000 ether && exp < 1250000 ether){
86             level = 9;
87         } else if(exp >= 1250000 ether){
88             level = 10;
89         } else{
90             level = 0;
91         }
92 
93         return level;
94     }
95 
96     function getVIPBounusRate(address user) public view returns (uint256 rate){
97         uint level = getVIPLevel(user);
98         return level;
99     }
100 
101     // This function is used to bump up the jackpot fund. Cannot be used to lower it.
102     function increaseJackpot(uint increaseAmount) external onlyCaller {
103         require (increaseAmount <= address(this).balance, "Increase amount larger than balance.");
104         require (jackpotSize + increaseAmount <= address(this).balance, "Not enough funds.");
105         jackpotSize += uint128(increaseAmount);
106     }
107 
108     function payJackpotReward(address payable to) external onlyCaller{
109         to.transfer(jackpotSize);
110         jackpotSize = 0;
111     }
112 
113     function getJackpotSize() external view returns (uint256){
114         return jackpotSize;
115     }
116 
117     function increaseRankingReward(uint amount) public onlyCaller{
118         require (amount <= address(this).balance, "Increase amount larger than balance.");
119         require (rankingRewardSize + amount <= address(this).balance, "Not enough funds.");
120         rankingRewardSize += uint128(amount);
121     }
122 
123     function payRankingReward(address payable to) external onlyCaller {
124         uint128 prize = rankingRewardSize / 2;
125         rankingRewardSize = rankingRewardSize - prize;
126         if(to.send(prize)){
127             emit RankingRewardPayment(to, prize);
128         }
129     }
130 
131     function getRankingRewardSize() external view returns (uint128){
132         return rankingRewardSize;
133     }
134 }
135 
136 contract CardRPS {
137     /// *** Constants section
138 
139     // Each bet is deducted 1% in favour of the house, but no less than some minimum.
140     // The lower bound is dictated by gas costs of the settleBet transaction, providing
141     // headroom for up to 10 Gwei prices.
142     uint constant HOUSE_EDGE_PERCENT = 1;
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
155     uint constant MAX_AMOUNT = 2 ether;
156 
157     // Modulo is a number of equiprobable outcomes in a game:
158     // - 2 for coin flip
159     // - 6 for dice
160     // - 6*6 = 36 for double dice
161     // - 100 for etheroll
162     // - 37 for roulette
163     // etc.
164     // It's called so because 256-bit entropy is treated like a huge integer and
165     // the remainder of its division by modulo is considered bet outcome.
166     // uint constant MAX_MODULO = 100;
167 
168     // For modulos below this threshold rolls are checked against a bit mask,
169     // thus allowing betting on any combination of outcomes. For example, given
170     // modulo 6 for dice, 101000 mask (base-2, big endian) means betting on
171     // 4 and 6; for games with modulos higher than threshold (Etheroll), a simple
172     // limit is used, allowing betting on any outcome in [0, N) range.
173     //
174     // The specific value is dictated by the fact that 256-bit intermediate
175     // multiplication result allows implementing population count efficiently
176     // for numbers that are up to 42 bits, and 40 is the highest multiple of
177     // eight below 42.
178     uint constant MAX_MASK_MODULO = 40;
179 
180     // This is a check on bet mask overflow.
181     uint constant MAX_BET_MASK = 2 ** MAX_MASK_MODULO;
182 
183     // EVM BLOCKHASH opcode can query no further than 256 blocks into the
184     // past. Given that settleBet uses block hash of placeBet as one of
185     // complementary entropy sources, we cannot process bets older than this
186     // threshold. On rare occasions AceDice croupier may fail to invoke
187     // settleBet in this timespan due to technical issues or extreme Ethereum
188     // congestion; such bets can be refunded via invoking refundBet.
189     uint constant BET_EXPIRATION_BLOCKS = 250;
190 
191     // Some deliberately invalid address to initialize the secret signer with.
192     // Forces maintainers to invoke setSecretSigner before processing any bets.
193     address constant DUMMY_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
194 
195     // Standard contract ownership transfer.
196     address payable public owner;
197     address payable private nextOwner;
198 
199     // Adjustable max bet profit. Used to cap bets against dynamic odds.
200     uint public maxProfit;
201 
202     // The address corresponding to a private key used to sign placeBet commits.
203     address public secretSigner;
204 
205     // Funds that are locked in potentially winning bets. Prevents contract from
206     // committing to bets it cannot pay out.
207     uint128 public lockedInBets;
208 
209     // A structure representing a single bet.
210     struct Bet {
211         // Wager amount in wei.
212         uint amount;
213         // Block number of placeBet tx.
214         uint40 placeBlockNumber;
215         // Address of a gambler, used to pay out winning bets.
216         address payable gambler;
217         // Address of inviter
218         address payable inviter;
219     }
220 
221     struct RandomNumber{
222         uint8 playerNum1;
223         uint8 playerNum2;
224         uint8 npcNum1;
225         uint8 npcNum2;
226         uint8 rouletteIndex;
227     }
228 
229     // Mapping from commits to all currently active & processed bets.
230     mapping (uint => Bet) bets;
231 
232     // Croupier account.
233     mapping (address => bool ) croupierMap;
234 
235     address payable public VIPLibraryAddress;
236 
237     // Events that are issued to make statistic recovery easier.
238     event FailedPayment(address indexed beneficiary, uint amount);
239     event Payment(address indexed beneficiary, uint amount, uint playerNum1, uint playerNum2, uint npcNum1, uint npcNum2, uint betAmount);
240     event JackpotPayment(address indexed beneficiary, uint amount, uint playerNum1, uint playerNum2, uint npcNum1, uint npcNum2, uint betAmount);
241     event VIPPayback(address indexed beneficiary, uint amount);
242 
243     // This event is emitted in placeBet to record commit in the logs.
244     event Commit(uint commit);
245 
246     // Constructor. Deliberately does not take any parameters.
247     constructor () public {
248         owner = msg.sender;
249         secretSigner = DUMMY_ADDRESS;
250     }
251 
252     // Standard modifier on methods invokable only by contract owner.
253     modifier onlyOwner {
254         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
255         _;
256     }
257 
258     // Standard modifier on methods invokable only by contract owner.
259     modifier onlyCroupier {
260     bool isCroupier = croupierMap[msg.sender];
261         require(isCroupier, "OnlyCroupier methods called by non-croupier.");
262         _;
263     }
264 
265     // Standard contract ownership transfer implementation,
266     function approveNextOwner(address payable _nextOwner) external onlyOwner {
267         require (_nextOwner != owner, "Cannot approve current owner.");
268         nextOwner = _nextOwner;
269     }
270 
271     function acceptNextOwner() external {
272         require (msg.sender == nextOwner, "Can only accept preapproved new owner.");
273         owner = nextOwner;
274     }
275 
276     // Fallback function deliberately left empty. It's primary use case
277     // is to top up the bank roll.
278     function () external payable {
279     }
280 
281     // See comment for "secretSigner" variable.
282     function setSecretSigner(address newSecretSigner) external onlyOwner {
283         secretSigner = newSecretSigner;
284     }
285 
286     function getSecretSigner() external onlyOwner view returns(address){
287         return secretSigner;
288     }
289 
290     function addCroupier(address newCroupier) external onlyOwner {
291         bool isCroupier = croupierMap[newCroupier];
292         if (isCroupier == false) {
293             croupierMap[newCroupier] = true;
294         }
295     }
296     
297     function deleteCroupier(address newCroupier) external onlyOwner {
298         bool isCroupier = croupierMap[newCroupier];
299         if (isCroupier == true) {
300             croupierMap[newCroupier] = false;
301         }
302     }
303 
304     function setVIPLibraryAddress(address payable addr) external onlyOwner{
305         VIPLibraryAddress = addr;
306     }
307 
308     // Change max bet reward. Setting this to zero effectively disables betting.
309     function setMaxProfit(uint _maxProfit) public onlyOwner {
310         require (_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
311         maxProfit = _maxProfit;
312     }
313 
314     // Funds withdrawal to cover costs of AceDice operation.
315     function withdrawFunds(address payable beneficiary, uint withdrawAmount) external onlyOwner {
316         require (withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
317         require (lockedInBets + withdrawAmount <= address(this).balance, "Not enough funds.");
318         sendFunds(beneficiary, withdrawAmount, withdrawAmount, 0, 0, 0, 0, 0);
319     }
320 
321     function kill() external onlyOwner {
322         require (lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
323         selfdestruct(owner);
324     }
325 
326     function encodePacketCommit(uint commitLastBlock, uint commit) private pure returns(bytes memory){
327         return abi.encodePacked(uint40(commitLastBlock), commit);
328     }
329 
330     function verifyCommit(uint commitLastBlock, uint commit, uint8 v, bytes32 r, bytes32 s) private view {
331         // Check that commit is valid - it has not expired and its signature is valid.
332         require (block.number <= commitLastBlock, "Commit has expired.");
333         //bytes32 signatureHash = keccak256(abi.encodePacked(commitLastBlock, commit));
334         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
335         bytes memory message = encodePacketCommit(commitLastBlock, commit);
336         bytes32 messageHash = keccak256(abi.encodePacked(prefix, keccak256(message)));
337         require (secretSigner == ecrecover(messageHash, v, r, s), "ECDSA signature is not valid.");
338     }
339 
340     function placeBet(uint betMask, uint commitLastBlock, uint commit, uint8 v, bytes32 r, bytes32 s) external payable {
341         // Check that the bet is in 'clean' state.
342         Bet storage bet = bets[commit];
343         require (bet.gambler == address(0), "Bet should be in a 'clean' state.");
344 
345         // Validate input data ranges.
346         uint amount = msg.value;
347         //require (modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
348         require (amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
349         require (betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
350 
351         verifyCommit(commitLastBlock, commit, v, r, s);
352 
353         // Winning amount and jackpot increase.
354         uint possibleWinAmount = amount * 5;
355         uint jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
356 
357         // Enforce max profit limit.
358         require (possibleWinAmount <= amount + maxProfit, "maxProfit limit violation. ");
359 
360         // Lock funds.
361         lockedInBets += uint128(possibleWinAmount);
362 
363         // Check whether contract has enough funds to process this bet.
364         require (jackpotFee + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
365 
366         // Record commit in logs.
367         emit Commit(commit);
368 
369         // Store bet parameters on blockchain.
370         bet.amount = amount;
371         bet.placeBlockNumber = uint40(block.number);
372         bet.gambler = msg.sender;
373 
374         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
375         vipLib.addUserExp(msg.sender, amount);
376     }
377 
378     function placeBetWithInviter(uint betMask, uint commitLastBlock, uint commit, uint8 v, bytes32 r, bytes32 s, address payable inviter) external payable {
379         // Check that the bet is in 'clean' state.
380         Bet storage bet = bets[commit];
381         require (bet.gambler == address(0), "Bet should be in a 'clean' state.");
382 
383         // Validate input data ranges.
384         uint amount = msg.value;
385         // require (modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
386         require (amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
387         require (betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
388         require (address(this) != inviter && inviter != address(0), "cannot invite mysql");
389 
390         verifyCommit(commitLastBlock, commit, v, r, s);
391 
392         // Winning amount and jackpot increase.
393         uint possibleWinAmount = amount * 5;
394         uint jackpotFee  = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
395 
396         // Enforce max profit limit.
397         require (possibleWinAmount <= amount + maxProfit, "maxProfit limit violation. ");
398 
399         // Lock funds.
400         lockedInBets += uint128(possibleWinAmount);
401         // jackpotSize += uint128(jackpotFee);
402 
403         // Check whether contract has enough funds to process this bet.
404         require (jackpotFee + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
405 
406         // Record commit in logs.
407         emit Commit(commit);
408 
409         // Store bet parameters on blockchain.
410         bet.amount = amount;
411         // bet.modulo = uint8(modulo);
412         //bet.rollUnder = uint8(betMask);
413         bet.placeBlockNumber = uint40(block.number);
414         //bet.mask = uint40(mask);
415         bet.gambler = msg.sender;
416         bet.inviter = inviter;
417 
418         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
419         vipLib.addUserExp(msg.sender, amount);
420     }
421     
422     function applyVIPLevel(address payable gambler, uint amount) private {
423         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
424         uint rate = vipLib.getVIPBounusRate(gambler);
425 
426         if (rate <= 0)
427             return;
428 
429         uint vipPayback = amount * rate / 10000;
430         if(gambler.send(vipPayback)){
431             emit VIPPayback(gambler, vipPayback);
432         }
433     }
434 
435     function getMyAccuAmount() external view returns (uint){
436         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
437         return vipLib.getUserExp(msg.sender);
438     }
439 
440     function getJackpotSize() external view returns (uint){
441         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
442         return vipLib.getJackpotSize();
443     }
444 
445     // This is the method used to settle 99% of bets. To process a bet with a specific
446     // "commit", settleBet should supply a "reveal" number that would Keccak256-hash to
447     // "commit". "blockHash" is the block hash of placeBet block as seen by croupier; it
448     // is additionally asserted to prevent changing the bet outcomes on Ethereum reorgs.
449     function settleBet(uint reveal, bytes32 blockHash) external onlyCroupier {
450         uint commit = uint(keccak256(abi.encodePacked(reveal)));
451 
452         Bet storage bet = bets[commit];
453         uint placeBlockNumber = bet.placeBlockNumber;
454 
455         // Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
456         require (block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
457         require (block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
458         require (blockhash(placeBlockNumber) == blockHash);
459 
460         // Settle bet using reveal and blockHash as entropy sources.
461         settleBetCommon(bet, reveal, blockHash);
462     }
463 
464         // Common settlement code for settleBet & settleBetUncleMerkleProof.
465     function settleBetCommon(Bet storage bet, uint reveal, bytes32 entropyBlockHash) private {
466         // Fetch bet parameters into local variables (to save gas).
467         uint amount = bet.amount;
468         // uint modulo = bet.modulo;
469         //uint rollUnder = bet.rollUnder;
470         // address payable gambler = bet.gambler;
471 
472         // Check that bet is in 'active' state.
473         require (amount != 0, "Bet should be in an 'active' state");
474 
475         applyVIPLevel(bet.gambler, amount);
476 
477         // Move bet into 'processed' state already.
478         bet.amount = 0;
479 
480         // Unlock the bet amount, regardless of the outcome.
481         lockedInBets -= uint128(amount * 5);
482 
483         // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
484         // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
485         // preimage is intractable), and house is unable to alter the "reveal" after
486         // placeBet have been mined (as Keccak256 collision finding is also intractable).
487         uint entropy = uint(keccak256(abi.encodePacked(reveal, entropyBlockHash)));
488         uint seed = entropy;
489         // Do a roll by taking a modulo of entropy. Compute winning amount.
490 
491         RandomNumber memory randomNumber = RandomNumber(0, 0, 0, 0, 0);
492         // uint mask = 2 ** 8;
493         randomNumber.playerNum1 = uint8(seed % 3);
494         seed = seed / 2 ** 8;
495         
496         randomNumber.playerNum2 = uint8(seed % 3);        
497         seed = seed / 2 ** 8;
498 
499         randomNumber.npcNum1 = uint8(seed % 3);
500         seed = seed / 2 ** 8;
501 
502         randomNumber.npcNum2 = uint8(seed % 3);
503         seed = seed / 2 ** 8;
504 
505         randomNumber.rouletteIndex = uint8(seed % 12);
506         seed = seed / 2 ** 8;
507 
508         uint jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
509 
510         uint houseEdge = amount * HOUSE_EDGE_PERCENT / 100;
511 
512         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
513             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
514         }
515         amount = amount - houseEdge - jackpotFee;
516 
517         uint8 winValue = calculateWinValue(randomNumber); // 0 -> draw, 1 -> user win, 2 -> npc win
518 
519         uint winAmount;
520 
521         if (winValue == 0) {
522             // draw
523             winAmount = amount;
524         } else if (winValue == 1) {
525             // user win
526             winAmount = amount * getRouletteRate(randomNumber.rouletteIndex) / 10;
527         } else {
528 
529         }
530 
531         if(bet.inviter != address(0)){
532             // pay 10% of house edge to inviter
533             bet.inviter.transfer(amount * HOUSE_EDGE_PERCENT / 100 * 7 /100);
534         }
535         
536         processVIPAndJackpotLogic(bet, amount, houseEdge, randomNumber, seed, jackpotFee);
537 
538         // Send the funds to gambler.
539         sendFunds(bet.gambler, winAmount == 0 ? 1 wei : winAmount, winAmount, 
540                     randomNumber.playerNum1, 
541                     randomNumber.playerNum2, 
542                     randomNumber.npcNum1, 
543                     randomNumber.npcNum2, 
544                     amount);
545     }
546 
547     function processVIPAndJackpotLogic(Bet memory bet, uint amount, uint houseEdge, RandomNumber memory randomNumber, uint entropy, uint jackpotFee) private{
548         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
549         
550         if (jackpotFee > 0){
551             VIPLibraryAddress.transfer(jackpotFee);
552             vipLib.increaseJackpot(jackpotFee);
553         }
554 
555         handleJackpotStatus(bet, amount, randomNumber, entropy, vipLib);
556 
557         // uint128 rankingRewardFee = uint128(amount * HOUSE_EDGE_PERCENT / 100 * 9 /100);
558         VIPLibraryAddress.transfer(uint128(houseEdge * 7 /100));
559         vipLib.increaseRankingReward(uint128(houseEdge * 7 /100));
560     }
561 
562     function handleJackpotStatus(Bet memory bet, uint amount, RandomNumber memory randomNumber, uint seed, CryptoTycoonsVIPLib vipLib) private {
563         uint jackpotWin = 0;
564         // Roll for a jackpot (if eligible).
565         if (amount >= MIN_JACKPOT_BET) {
566             // The second modulo, statistically independent from the "main" dice roll.
567             // Effectively you are playing two games at once!
568             // uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;
569 
570             // Bingo!
571             if (seed % JACKPOT_MODULO == 0) {
572                 jackpotWin = vipLib.getJackpotSize();
573                 vipLib.payJackpotReward(bet.gambler);
574             }
575         }
576 
577         // Log jackpot win.
578         if (jackpotWin > 0) {
579             emit JackpotPayment(bet.gambler, 
580                     jackpotWin, 
581                     randomNumber.playerNum1, 
582                     randomNumber.playerNum2, 
583                     randomNumber.npcNum1, 
584                     randomNumber.npcNum2, 
585                     amount);
586         }
587     }
588 
589     function calculateWinValue(RandomNumber memory randomNumber) private pure returns (uint8){
590         uint8 playerNum1 = randomNumber.playerNum1;
591         uint8 playerNum2 = randomNumber.playerNum2;
592         uint8 npcNum1 = randomNumber.npcNum1;
593         uint8 npcNum2 = randomNumber.npcNum2;
594 
595         uint8 winValue = 0;
596         if (playerNum1 == npcNum1){ // num 0 -> scissors, 1 -> rock, 2 -> papper
597             if (playerNum2 == npcNum2){
598                 winValue = 0;
599             } else if(playerNum2 == 0 && npcNum2 == 2){
600                 winValue = 1; // user win
601             } else if(playerNum2 == 1 && npcNum2 == 0){
602                 winValue = 1; // user win
603             } else if(playerNum2 == 2 && npcNum2 == 1){
604                 winValue = 1; // user win
605             } else{
606                 winValue = 2; // npc win
607             }
608         } else if(playerNum1 == 0 && npcNum1 == 2){
609             winValue = 1; // user win
610         } else if(playerNum1 == 1 && npcNum1 == 0){
611             winValue = 1; // user win
612         } else if(playerNum1 == 2 && npcNum1 == 1){
613             winValue = 1; // user win
614         } else{
615             winValue = 2; // npc win
616         } 
617         return winValue;
618     }
619 
620     function getRouletteRate(uint index) private pure returns (uint8){
621         uint8 rate = 11;
622         if (index == 0){
623             rate = 50;
624         } else if(index== 1){
625             rate = 11;
626         } else if(index== 2){
627             rate = 20;
628         } else if(index== 3){
629             rate = 15;
630         } else if(index== 4){
631             rate = 20;
632         } else if(index== 5){
633             rate = 11;
634         } else if(index== 6){
635             rate = 20;
636         } else if(index== 7){
637             rate = 15;
638         } else if(index== 8){
639             rate = 20;
640         } else if(index== 9){
641             rate = 11;
642         } else if(index== 10){
643             rate = 20;
644         } else if(index== 11){
645             rate = 15;
646         }
647         return rate;
648     }
649 
650     // Refund transaction - return the bet amount of a roll that was not processed in a
651     // due timeframe. Processing such blocks is not possible due to EVM limitations (see
652     // BET_EXPIRATION_BLOCKS comment above for details). In case you ever find yourself
653     // in a situation like this, just contact the AceDice support, however nothing
654     // precludes you from invoking this method yourself.
655     function refundBet(uint commit) external {
656         // Check that bet is in 'active' state.
657         Bet storage bet = bets[commit];
658         uint amount = bet.amount;
659 
660         require (amount != 0, "Bet should be in an 'active' state");
661 
662         // Check that bet has already expired.
663         require (block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
664 
665         // Move bet into 'processed' state, release funds.
666         bet.amount = 0;
667 
668         uint diceWinAmount = amount * 5;
669 
670         lockedInBets -= uint128(diceWinAmount);
671 
672         // Send the refund.
673         sendFunds(bet.gambler, amount, amount, 0,0, 0, 0, 0);
674     }
675 
676     // Get the expected win amount after house edge is subtracted.
677     // function getDiceWinAmount(uint amount, uint rollUnder) private pure returns (uint jackpotFee) {
678     //     require (0 < rollUnder && rollUnder <= 100, "Win probability out of range.");
679 
680     //     jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
681 
682     //     uint houseEdge = amount * HOUSE_EDGE_PERCENT / 100;
683 
684     //     if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
685     //     houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
686     //     }
687 
688     //     // require (houseEdge + jackpotFee <= amount, "Bet doesn't even cover house edge.");
689     //     // winAmount = (amount - houseEdge - jackpotFee) * 100 / rollUnder;
690     // }
691 
692     // Helper routine to process the payment.
693     function sendFunds(address payable beneficiary, uint amount, uint successLogAmount, uint playerNum1, uint playerNum2, uint npcNum1, uint npcNum2, uint betAmount) private {
694         if (beneficiary.send(amount)) {
695             emit Payment(beneficiary, successLogAmount, playerNum1, playerNum2, npcNum1, npcNum2, betAmount);
696         } else {
697             emit FailedPayment(beneficiary, amount);
698         }
699     }
700 
701     function thisBalance() public view returns(uint) {
702         return address(this).balance;
703     }
704 
705     function payTodayReward(address payable to) external onlyOwner {
706         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
707         vipLib.payRankingReward(to);
708     }
709 
710     function getRankingRewardSize() external view returns (uint128) {
711         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
712         return vipLib.getRankingRewardSize();
713     }
714 }