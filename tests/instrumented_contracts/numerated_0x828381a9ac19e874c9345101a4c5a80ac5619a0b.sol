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
69         if(exp >= 30 ether && exp < 150 ether){
70             level = 1;
71         } else if(exp >= 150 ether && exp < 300 ether){
72             level = 2;
73         } else if(exp >= 300 ether && exp < 1500 ether){
74             level = 3;
75         } else if(exp >= 1500 ether && exp < 3000 ether){
76             level = 4;
77         } else if(exp >= 3000 ether && exp < 15000 ether){
78             level = 5;
79         } else if(exp >= 15000 ether && exp < 30000 ether){
80             level = 6;
81         } else if(exp >= 30000 ether && exp < 150000 ether){
82             level = 7;
83         } else if(exp >= 150000 ether){
84             level = 8;
85         } else{
86             level = 0;
87         }
88 
89         return level;
90     }
91 
92     function getVIPBounusRate(address user) public view returns (uint256 rate){
93         uint level = getVIPLevel(user);
94 
95         if(level == 1){
96             rate = 1;
97         } else if(level == 2){
98             rate = 2;
99         } else if(level == 3){
100             rate = 3;
101         } else if(level == 4){
102             rate = 4;
103         } else if(level == 5){
104             rate = 5;
105         } else if(level == 6){
106             rate = 7;
107         } else if(level == 7){
108             rate = 9;
109         } else if(level == 8){
110             rate = 11;
111         } else if(level == 9){
112             rate = 13;
113         } else if(level == 10){
114             rate = 15;
115         } else{
116             rate = 0;
117         }
118     }
119 
120     // This function is used to bump up the jackpot fund. Cannot be used to lower it.
121     function increaseJackpot(uint increaseAmount) external onlyCaller {
122         require (increaseAmount <= address(this).balance, "Increase amount larger than balance.");
123         require (jackpotSize + increaseAmount <= address(this).balance, "Not enough funds.");
124         jackpotSize += uint128(increaseAmount);
125     }
126 
127     function payJackpotReward(address payable to) external onlyCaller{
128         to.transfer(jackpotSize);
129         jackpotSize = 0;
130     }
131 
132     function getJackpotSize() external view returns (uint256){
133         return jackpotSize;
134     }
135 
136     function increaseRankingReward(uint amount) public onlyCaller{
137         require (amount <= address(this).balance, "Increase amount larger than balance.");
138         require (rankingRewardSize + amount <= address(this).balance, "Not enough funds.");
139         rankingRewardSize += uint128(amount);
140     }
141 
142     function payRankingReward(address payable to) external onlyCaller {
143         uint128 prize = rankingRewardSize / 2;
144         rankingRewardSize = rankingRewardSize - prize;
145         if(to.send(prize)){
146             emit RankingRewardPayment(to, prize);
147         }
148     }
149 
150     function getRankingRewardSize() external view returns (uint128){
151         return rankingRewardSize;
152     }
153 }
154 
155 contract AceDice {
156     /// *** Constants section
157 
158     // Each bet is deducted 1% in favour of the house, but no less than some minimum.
159     // The lower bound is dictated by gas costs of the settleBet transaction, providing
160     // headroom for up to 10 Gwei prices.
161     uint constant HOUSE_EDGE_PERCENT = 1;
162     uint constant HOUSE_EDGE_MINIMUM_AMOUNT = 0.0004 ether;
163 
164     // Bets lower than this amount do not participate in jackpot rolls (and are
165     // not deducted JACKPOT_FEE).
166     uint constant MIN_JACKPOT_BET = 0.1 ether;
167 
168     // Chance to win jackpot (currently 0.1%) and fee deducted into jackpot fund.
169     uint constant JACKPOT_MODULO = 1000;
170     uint constant JACKPOT_FEE = 0.001 ether;
171 
172     // There is minimum and maximum bets.
173     uint constant MIN_BET = 0.01 ether;
174     uint constant MAX_AMOUNT = 300000 ether;
175 
176     // Modulo is a number of equiprobable outcomes in a game:
177     // - 2 for coin flip
178     // - 6 for dice
179     // - 6*6 = 36 for double dice
180     // - 100 for etheroll
181     // - 37 for roulette
182     // etc.
183     // It's called so because 256-bit entropy is treated like a huge integer and
184     // the remainder of its division by modulo is considered bet outcome.
185     // uint constant MAX_MODULO = 100;
186 
187     // For modulos below this threshold rolls are checked against a bit mask,
188     // thus allowing betting on any combination of outcomes. For example, given
189     // modulo 6 for dice, 101000 mask (base-2, big endian) means betting on
190     // 4 and 6; for games with modulos higher than threshold (Etheroll), a simple
191     // limit is used, allowing betting on any outcome in [0, N) range.
192     //
193     // The specific value is dictated by the fact that 256-bit intermediate
194     // multiplication result allows implementing population count efficiently
195     // for numbers that are up to 42 bits, and 40 is the highest multiple of
196     // eight below 42.
197     uint constant MAX_MASK_MODULO = 40;
198 
199     // This is a check on bet mask overflow.
200     uint constant MAX_BET_MASK = 2 ** MAX_MASK_MODULO;
201 
202     // EVM BLOCKHASH opcode can query no further than 256 blocks into the
203     // past. Given that settleBet uses block hash of placeBet as one of
204     // complementary entropy sources, we cannot process bets older than this
205     // threshold. On rare occasions AceDice croupier may fail to invoke
206     // settleBet in this timespan due to technical issues or extreme Ethereum
207     // congestion; such bets can be refunded via invoking refundBet.
208     uint constant BET_EXPIRATION_BLOCKS = 250;
209 
210     // Some deliberately invalid address to initialize the secret signer with.
211     // Forces maintainers to invoke setSecretSigner before processing any bets.
212     address constant DUMMY_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
213 
214     // Standard contract ownership transfer.
215     address payable public owner;
216     address payable private nextOwner;
217 
218     // Adjustable max bet profit. Used to cap bets against dynamic odds.
219     uint public maxProfit;
220 
221     // The address corresponding to a private key used to sign placeBet commits.
222     address public secretSigner;
223 
224     // Funds that are locked in potentially winning bets. Prevents contract from
225     // committing to bets it cannot pay out.
226     uint128 public lockedInBets;
227 
228     // A structure representing a single bet.
229     struct Bet {
230         // Wager amount in wei.
231         uint amount;
232         // Modulo of a game.
233         // uint8 modulo;
234         // Number of winning outcomes, used to compute winning payment (* modulo/rollUnder),
235         // and used instead of mask for games with modulo > MAX_MASK_MODULO.
236         uint8 rollUnder;
237         // Block number of placeBet tx.
238         uint40 placeBlockNumber;
239         // Bit mask representing winning bet outcomes (see MAX_MASK_MODULO comment).
240         uint40 mask;
241         // Address of a gambler, used to pay out winning bets.
242         address payable gambler;
243         // Address of inviter
244         address payable inviter;
245     }
246 
247     struct Profile{
248         // picture index of profile avatar
249         uint avatarIndex;
250         // nickname of user
251         bytes32 nickName;
252     }
253 
254     // Mapping from commits to all currently active & processed bets.
255     mapping (uint => Bet) bets;
256 
257     mapping (address => Profile) profiles;
258 
259     // Croupier account.
260     mapping (address => bool ) croupierMap;
261 
262     address payable public VIPLibraryAddress;
263 
264     // Events that are issued to make statistic recovery easier.
265     event FailedPayment(address indexed beneficiary, uint amount);
266     event Payment(address indexed beneficiary, uint amount, uint dice, uint rollUnder, uint betAmount);
267     event JackpotPayment(address indexed beneficiary, uint amount, uint dice, uint rollUnder, uint betAmount);
268     event VIPPayback(address indexed beneficiary, uint amount);
269 
270     // This event is emitted in placeBet to record commit in the logs.
271     event Commit(uint commit);
272 
273     // Constructor. Deliberately does not take any parameters.
274     constructor () public {
275         owner = msg.sender;
276         secretSigner = DUMMY_ADDRESS;
277     }
278 
279     // Standard modifier on methods invokable only by contract owner.
280     modifier onlyOwner {
281         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
282         _;
283     }
284 
285     // Standard modifier on methods invokable only by contract owner.
286     modifier onlyCroupier {
287     bool isCroupier = croupierMap[msg.sender];
288         require(isCroupier, "OnlyCroupier methods called by non-croupier.");
289         _;
290     }
291 
292     // Standard contract ownership transfer implementation,
293     function approveNextOwner(address payable _nextOwner) external onlyOwner {
294         require (_nextOwner != owner, "Cannot approve current owner.");
295         nextOwner = _nextOwner;
296     }
297 
298     function acceptNextOwner() external {
299         require (msg.sender == nextOwner, "Can only accept preapproved new owner.");
300         owner = nextOwner;
301     }
302 
303     // Fallback function deliberately left empty. It's primary use case
304     // is to top up the bank roll.
305     function () external payable {
306     }
307 
308     // See comment for "secretSigner" variable.
309     function setSecretSigner(address newSecretSigner) external onlyOwner {
310         secretSigner = newSecretSigner;
311     }
312 
313     function getSecretSigner() external onlyOwner view returns(address){
314         return secretSigner;
315     }
316 
317     function addCroupier(address newCroupier) external onlyOwner {
318         bool isCroupier = croupierMap[newCroupier];
319         if (isCroupier == false) {
320             croupierMap[newCroupier] = true;
321         }
322     }
323     
324     function deleteCroupier(address newCroupier) external onlyOwner {
325         bool isCroupier = croupierMap[newCroupier];
326         if (isCroupier == true) {
327             croupierMap[newCroupier] = false;
328         }
329     }
330 
331     function setVIPLibraryAddress(address payable addr) external onlyOwner{
332         VIPLibraryAddress = addr;
333     }
334 
335     // Change max bet reward. Setting this to zero effectively disables betting.
336     function setMaxProfit(uint _maxProfit) public onlyOwner {
337         require (_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
338         maxProfit = _maxProfit;
339     }
340 
341     // Funds withdrawal to cover costs of AceDice operation.
342     function withdrawFunds(address payable beneficiary, uint withdrawAmount) external onlyOwner {
343         require (withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
344         require (lockedInBets + withdrawAmount <= address(this).balance, "Not enough funds.");
345         sendFunds(beneficiary, withdrawAmount, withdrawAmount, 0, 0, 0);
346     }
347 
348     function kill() external onlyOwner {
349         require (lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
350         selfdestruct(owner);
351     }
352 
353     function encodePacketCommit(uint commitLastBlock, uint commit) private pure returns(bytes memory){
354         return abi.encodePacked(uint40(commitLastBlock), commit);
355     }
356 
357     function verifyCommit(uint commitLastBlock, uint commit, uint8 v, bytes32 r, bytes32 s) private view {
358         // Check that commit is valid - it has not expired and its signature is valid.
359         require (block.number <= commitLastBlock, "Commit has expired.");
360         //bytes32 signatureHash = keccak256(abi.encodePacked(commitLastBlock, commit));
361         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
362         bytes memory message = encodePacketCommit(commitLastBlock, commit);
363         bytes32 messageHash = keccak256(abi.encodePacked(prefix, keccak256(message)));
364         require (secretSigner == ecrecover(messageHash, v, r, s), "ECDSA signature is not valid.");
365     }
366 
367     function placeBet(uint betMask, uint commitLastBlock, uint commit, uint8 v, bytes32 r, bytes32 s) external payable {
368         // Check that the bet is in 'clean' state.
369         Bet storage bet = bets[commit];
370         require (bet.gambler == address(0), "Bet should be in a 'clean' state.");
371 
372         // Validate input data ranges.
373         uint amount = msg.value;
374         //require (modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
375         require (amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
376         require (betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
377 
378         verifyCommit(commitLastBlock, commit, v, r, s);
379 
380         // uint rollUnder;
381         uint mask;
382 
383         // if (modulo <= MAX_MASK_MODULO) {
384         //   // Small modulo games specify bet outcomes via bit mask.
385         //   // rollUnder is a number of 1 bits in this mask (population count).
386         //   // This magic looking formula is an efficient way to compute population
387         //   // count on EVM for numbers below 2**40. For detailed proof consult
388         //   // the AceDice whitepaper.
389         //   rollUnder = ((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
390         //   mask = betMask;
391         //   } else {
392         // Larger modulos specify the right edge of half-open interval of
393         // winning bet outcomes.
394         require (betMask > 0 && betMask <= 100, "High modulo range, betMask larger than modulo.");
395         // rollUnder = betMask;
396         // }
397 
398         // Winning amount and jackpot increase.
399         uint possibleWinAmount;
400         uint jackpotFee;
401 
402         (possibleWinAmount, jackpotFee) = getDiceWinAmount(amount, betMask);
403 
404         // Enforce max profit limit.
405         require (possibleWinAmount <= amount + maxProfit, "maxProfit limit violation. ");
406 
407         // Lock funds.
408         lockedInBets += uint128(possibleWinAmount);
409 
410         // Check whether contract has enough funds to process this bet.
411         require (jackpotFee + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
412 
413         // Record commit in logs.
414         emit Commit(commit);
415 
416         // Store bet parameters on blockchain.
417         bet.amount = amount;
418         // bet.modulo = uint8(modulo);
419         bet.rollUnder = uint8(betMask);
420         bet.placeBlockNumber = uint40(block.number);
421         bet.mask = uint40(mask);
422         bet.gambler = msg.sender;
423 
424         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
425         vipLib.addUserExp(msg.sender, amount);
426 
427         if (jackpotFee > 0){
428             VIPLibraryAddress.transfer(jackpotFee);
429             vipLib.increaseJackpot(jackpotFee);
430         }
431     }
432 
433     function placeBetWithInviter(uint betMask, uint commitLastBlock, uint commit, uint8 v, bytes32 r, bytes32 s, address payable inviter) external payable {
434         // Check that the bet is in 'clean' state.
435         Bet storage bet = bets[commit];
436         require (bet.gambler == address(0), "Bet should be in a 'clean' state.");
437 
438         // Validate input data ranges.
439         uint amount = msg.value;
440         // require (modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
441         require (amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
442         require (betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
443         require (address(this) != inviter && inviter != address(0), "cannot invite mysql");
444 
445         verifyCommit(commitLastBlock, commit, v, r, s);
446 
447         // uint rollUnder;
448         uint mask;
449 
450         // if (modulo <= MAX_MASK_MODULO) {
451         //   // Small modulo games specify bet outcomes via bit mask.
452         //   // rollUnder is a number of 1 bits in this mask (population count).
453         //   // This magic looking formula is an efficient way to compute population
454         //   // count on EVM for numbers below 2**40. For detailed proof consult
455         //   // the AceDice whitepaper.
456         //   rollUnder = ((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
457         //   mask = betMask;
458         // } else {
459         // Larger modulos specify the right edge of half-open interval of
460         // winning bet outcomes.
461         require (betMask > 0 && betMask <= 100, "High modulo range, betMask larger than modulo.");
462         // rollUnder = betMask;
463         // }
464 
465         // Winning amount and jackpot increase.
466         uint possibleWinAmount;
467         uint jackpotFee;
468 
469         (possibleWinAmount, jackpotFee) = getDiceWinAmount(amount, betMask);
470 
471         // Enforce max profit limit.
472         require (possibleWinAmount <= amount + maxProfit, "maxProfit limit violation. ");
473 
474         // Lock funds.
475         lockedInBets += uint128(possibleWinAmount);
476         // jackpotSize += uint128(jackpotFee);
477 
478         // Check whether contract has enough funds to process this bet.
479         require (jackpotFee + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
480 
481         // Record commit in logs.
482         emit Commit(commit);
483 
484         // Store bet parameters on blockchain.
485         bet.amount = amount;
486         // bet.modulo = uint8(modulo);
487         bet.rollUnder = uint8(betMask);
488         bet.placeBlockNumber = uint40(block.number);
489         bet.mask = uint40(mask);
490         bet.gambler = msg.sender;
491         bet.inviter = inviter;
492 
493         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
494         vipLib.addUserExp(msg.sender, amount);
495 
496         if (jackpotFee > 0){
497             VIPLibraryAddress.transfer(jackpotFee);
498             vipLib.increaseJackpot(jackpotFee);
499         }
500     }
501     
502     function applyVIPLevel(address payable gambler, uint amount) private {
503         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
504         uint rate = vipLib.getVIPBounusRate(gambler);
505 
506         if (rate <= 0)
507             return;
508 
509         uint vipPayback = amount * rate / 10000;
510         if(gambler.send(vipPayback)){
511             emit VIPPayback(gambler, vipPayback);
512         }
513     }
514 
515     function getMyAccuAmount() external view returns (uint){
516         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
517         return vipLib.getUserExp(msg.sender);
518     }
519 
520     function getJackpotSize() external view returns (uint){
521         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
522         return vipLib.getJackpotSize();
523     }
524 
525     // This is the method used to settle 99% of bets. To process a bet with a specific
526     // "commit", settleBet should supply a "reveal" number that would Keccak256-hash to
527     // "commit". "blockHash" is the block hash of placeBet block as seen by croupier; it
528     // is additionally asserted to prevent changing the bet outcomes on Ethereum reorgs.
529     function settleBet(uint reveal, bytes32 blockHash) external onlyCroupier {
530         uint commit = uint(keccak256(abi.encodePacked(reveal)));
531 
532         Bet storage bet = bets[commit];
533         uint placeBlockNumber = bet.placeBlockNumber;
534 
535         // Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
536         require (block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
537         require (block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
538         require (blockhash(placeBlockNumber) == blockHash);
539 
540         // Settle bet using reveal and blockHash as entropy sources.
541         settleBetCommon(bet, reveal, blockHash);
542     }
543 
544         // Common settlement code for settleBet & settleBetUncleMerkleProof.
545     function settleBetCommon(Bet storage bet, uint reveal, bytes32 entropyBlockHash) private {
546         // Fetch bet parameters into local variables (to save gas).
547         uint amount = bet.amount;
548         // uint modulo = bet.modulo;
549         uint rollUnder = bet.rollUnder;
550         address payable gambler = bet.gambler;
551 
552         // Check that bet is in 'active' state.
553         require (amount != 0, "Bet should be in an 'active' state");
554 
555         applyVIPLevel(gambler, amount);
556 
557         // Move bet into 'processed' state already.
558         bet.amount = 0;
559 
560         // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
561         // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
562         // preimage is intractable), and house is unable to alter the "reveal" after
563         // placeBet have been mined (as Keccak256 collision finding is also intractable).
564         bytes32 entropy = keccak256(abi.encodePacked(reveal, entropyBlockHash));
565 
566         // Do a roll by taking a modulo of entropy. Compute winning amount.
567         uint dice = uint(entropy) % 100;
568 
569         uint diceWinAmount;
570         uint _jackpotFee;
571         (diceWinAmount, _jackpotFee) = getDiceWinAmount(amount, rollUnder);
572 
573         uint diceWin = 0;
574         uint jackpotWin = 0;
575 
576 
577         if (dice < rollUnder) {
578             diceWin = diceWinAmount;
579         }
580 
581         // Unlock the bet amount, regardless of the outcome.
582         lockedInBets -= uint128(diceWinAmount);
583         
584         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
585         
586         // Roll for a jackpot (if eligible).
587         if (amount >= MIN_JACKPOT_BET) {
588             // The second modulo, statistically independent from the "main" dice roll.
589             // Effectively you are playing two games at once!
590             // uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;
591 
592             // Bingo!
593             if ((uint(entropy) / 100) % JACKPOT_MODULO == 0) {
594                 jackpotWin = vipLib.getJackpotSize();
595                 vipLib.payJackpotReward(gambler);
596             }
597         }
598 
599         // Log jackpot win.
600         if (jackpotWin > 0) {
601             emit JackpotPayment(gambler, jackpotWin, dice, rollUnder, amount);
602         }
603 
604         if(bet.inviter != address(0)){
605             // pay 10% of house edge to inviter
606             bet.inviter.transfer(amount * HOUSE_EDGE_PERCENT / 100 * 10 /100);
607         }
608 
609         // uint128 rankingRewardFee = uint128(amount * HOUSE_EDGE_PERCENT / 100 * 9 /100);
610         VIPLibraryAddress.transfer(uint128(amount * HOUSE_EDGE_PERCENT / 100 * 9 /100));
611         vipLib.increaseRankingReward(uint128(amount * HOUSE_EDGE_PERCENT / 100 * 9 /100));
612 
613         // Send the funds to gambler.
614         sendFunds(gambler, diceWin == 0 ? 1 wei : diceWin, diceWin, dice, rollUnder, amount);
615     }
616 
617     // Refund transaction - return the bet amount of a roll that was not processed in a
618     // due timeframe. Processing such blocks is not possible due to EVM limitations (see
619     // BET_EXPIRATION_BLOCKS comment above for details). In case you ever find yourself
620     // in a situation like this, just contact the AceDice support, however nothing
621     // precludes you from invoking this method yourself.
622     function refundBet(uint commit) external {
623         // Check that bet is in 'active' state.
624         Bet storage bet = bets[commit];
625         uint amount = bet.amount;
626 
627         require (amount != 0, "Bet should be in an 'active' state");
628 
629         // Check that bet has already expired.
630         require (block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
631 
632         // Move bet into 'processed' state, release funds.
633         bet.amount = 0;
634 
635         uint diceWinAmount;
636         uint jackpotFee;
637         (diceWinAmount, jackpotFee) = getDiceWinAmount(amount, bet.rollUnder);
638 
639         lockedInBets -= uint128(diceWinAmount);
640         // jackpotSize -= uint128(jackpotFee);
641         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
642         vipLib.increaseJackpot(-jackpotFee);
643 
644         // Send the refund.
645         sendFunds(bet.gambler, amount, amount, 0, 0, 0);
646     }
647 
648     // Get the expected win amount after house edge is subtracted.
649     function getDiceWinAmount(uint amount, uint rollUnder) private pure returns (uint winAmount, uint jackpotFee) {
650         require (0 < rollUnder && rollUnder <= 100, "Win probability out of range.");
651 
652         jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
653 
654         uint houseEdge = amount * HOUSE_EDGE_PERCENT / 100;
655 
656         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
657         houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
658         }
659 
660         require (houseEdge + jackpotFee <= amount, "Bet doesn't even cover house edge.");
661         winAmount = (amount - houseEdge - jackpotFee) * 100 / rollUnder;
662     }
663 
664     // Helper routine to process the payment.
665     function sendFunds(address payable beneficiary, uint amount, uint successLogAmount, uint dice, uint rollUnder, uint betAmount) private {
666         if (beneficiary.send(amount)) {
667             emit Payment(beneficiary, successLogAmount, dice, rollUnder, betAmount);
668         } else {
669             emit FailedPayment(beneficiary, amount);
670         }
671     }
672 
673     function thisBalance() public view returns(uint) {
674         return address(this).balance;
675     }
676 
677     function setAvatarIndex(uint index) external{
678         require (index >=0 && index <= 100, "avatar index should be in range");
679         Profile storage profile = profiles[msg.sender];
680         profile.avatarIndex = index;
681     }
682 
683     function setNickName(bytes32 nickName) external{
684         Profile storage profile = profiles[msg.sender];
685         profile.nickName = nickName;
686     }
687 
688     function getProfile() external view returns(uint, bytes32){
689         Profile storage profile = profiles[msg.sender];
690         return (profile.avatarIndex, profile.nickName);
691     }
692 
693     function payTodayReward(address payable to) external onlyOwner {
694         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
695         vipLib.payRankingReward(to);
696     }
697 
698     function getRankingRewardSize() external view returns (uint128) {
699         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
700         return vipLib.getRankingRewardSize();
701     }
702 }