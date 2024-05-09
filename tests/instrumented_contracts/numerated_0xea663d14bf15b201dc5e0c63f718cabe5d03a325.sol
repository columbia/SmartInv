1 // solium-disable linebreak-style
2 pragma solidity ^0.5.0;
3 
4 contract CryptoTycoonsVIPLib{
5     
6     address payable public owner;
7 
8     mapping (address => uint) userExpPool;
9     mapping (address => bool) public callerMap;
10     modifier onlyOwner {
11         require(msg.sender == owner, "OnlyOwner methods called by non-owner.");
12         _;
13     }
14 
15     modifier onlyCaller {
16         bool isCaller = callerMap[msg.sender];
17         require(isCaller, "onlyCaller methods called by non-caller.");
18         _;
19     }
20 
21     constructor() public{
22         owner = msg.sender;
23         callerMap[owner] = true;
24     }
25 
26     function kill() external onlyOwner {
27         selfdestruct(owner);
28     }
29 
30     function addCaller(address caller) public onlyOwner{
31         bool isCaller = callerMap[caller];
32         if (isCaller == false){
33             callerMap[caller] = true;
34         }
35     }
36 
37     function deleteCaller(address caller) external onlyOwner {
38         bool isCaller = callerMap[caller];
39         if (isCaller == true) {
40             callerMap[caller] = false;
41         }
42     }
43 
44     function addUserExp(address addr, uint256 amount) public onlyCaller{
45         uint exp = userExpPool[addr];
46         exp = exp + amount;
47         userExpPool[addr] = exp;
48     }
49 
50     function getUserExp(address addr) public view returns(uint256 exp){
51         return userExpPool[addr];
52     }
53 
54     function getVIPLevel(address user) public view returns (uint256 level) {
55         uint exp = userExpPool[user];
56 
57         if(exp >= 30 ether && exp < 150 ether){
58             level = 1;
59         } else if(exp >= 150 ether && exp < 300 ether){
60             level = 2;
61         } else if(exp >= 300 ether && exp < 1500 ether){
62             level = 3;
63         } else if(exp >= 1500 ether && exp < 3000 ether){
64             level = 4;
65         } else if(exp >= 3000 ether && exp < 15000 ether){
66             level = 5;
67         } else if(exp >= 15000 ether && exp < 30000 ether){
68             level = 6;
69         } else if(exp >= 30000 ether && exp < 150000 ether){
70             level = 7;
71         } else if(exp >= 150000 ether){
72             level = 8;
73         } else{
74             level = 0;
75         }
76 
77         return level;
78     }
79 
80     function getVIPBounusRate(address user) public view returns (uint256 rate){
81         uint level = getVIPLevel(user);
82 
83         if(level == 1){
84             rate = 1;
85         } else if(level == 2){
86             rate = 2;
87         } else if(level == 3){
88             rate = 3;
89         } else if(level == 4){
90             rate = 4;
91         } else if(level == 5){
92             rate = 5;
93         } else if(level == 6){
94             rate = 7;
95         } else if(level == 7){
96             rate = 9;
97         } else if(level == 8){
98             rate = 11;
99         } else if(level == 9){
100             rate = 13;
101         } else if(level == 10){
102             rate = 15;
103         } else{
104             rate = 0;
105         }
106     }
107 }
108 
109 contract AceDice {
110     /// *** Constants section
111 
112     // Each bet is deducted 1% in favour of the house, but no less than some minimum.
113     // The lower bound is dictated by gas costs of the settleBet transaction, providing
114     // headroom for up to 10 Gwei prices.
115     uint constant HOUSE_EDGE_PERCENT = 1;
116     uint constant HOUSE_EDGE_MINIMUM_AMOUNT = 0.0004 ether;
117 
118     // Bets lower than this amount do not participate in jackpot rolls (and are
119     // not deducted JACKPOT_FEE).
120     uint constant MIN_JACKPOT_BET = 0.1 ether;
121 
122     // Chance to win jackpot (currently 0.1%) and fee deducted into jackpot fund.
123     uint constant JACKPOT_MODULO = 1000;
124     uint constant JACKPOT_FEE = 0.001 ether;
125 
126     // There is minimum and maximum bets.
127     uint constant MIN_BET = 0.01 ether;
128     uint constant MAX_AMOUNT = 300000 ether;
129 
130     // Modulo is a number of equiprobable outcomes in a game:
131     // - 2 for coin flip
132     // - 6 for dice
133     // - 6*6 = 36 for double dice
134     // - 100 for etheroll
135     // - 37 for roulette
136     // etc.
137     // It's called so because 256-bit entropy is treated like a huge integer and
138     // the remainder of its division by modulo is considered bet outcome.
139     // uint constant MAX_MODULO = 100;
140 
141     // For modulos below this threshold rolls are checked against a bit mask,
142     // thus allowing betting on any combination of outcomes. For example, given
143     // modulo 6 for dice, 101000 mask (base-2, big endian) means betting on
144     // 4 and 6; for games with modulos higher than threshold (Etheroll), a simple
145     // limit is used, allowing betting on any outcome in [0, N) range.
146     //
147     // The specific value is dictated by the fact that 256-bit intermediate
148     // multiplication result allows implementing population count efficiently
149     // for numbers that are up to 42 bits, and 40 is the highest multiple of
150     // eight below 42.
151     uint constant MAX_MASK_MODULO = 40;
152 
153     // This is a check on bet mask overflow.
154     uint constant MAX_BET_MASK = 2 ** MAX_MASK_MODULO;
155 
156     // EVM BLOCKHASH opcode can query no further than 256 blocks into the
157     // past. Given that settleBet uses block hash of placeBet as one of
158     // complementary entropy sources, we cannot process bets older than this
159     // threshold. On rare occasions AceDice croupier may fail to invoke
160     // settleBet in this timespan due to technical issues or extreme Ethereum
161     // congestion; such bets can be refunded via invoking refundBet.
162     uint constant BET_EXPIRATION_BLOCKS = 250;
163 
164     // Some deliberately invalid address to initialize the secret signer with.
165     // Forces maintainers to invoke setSecretSigner before processing any bets.
166     address constant DUMMY_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
167 
168     // Standard contract ownership transfer.
169     address payable public owner;
170     address payable private nextOwner;
171 
172     // Adjustable max bet profit. Used to cap bets against dynamic odds.
173     uint public maxProfit;
174 
175     // The address corresponding to a private key used to sign placeBet commits.
176     address public secretSigner;
177 
178     // Accumulated jackpot fund.
179     uint128 public jackpotSize;
180 
181     uint public todaysRewardSize;
182 
183     // Funds that are locked in potentially winning bets. Prevents contract from
184     // committing to bets it cannot pay out.
185     uint128 public lockedInBets;
186 
187     // A structure representing a single bet.
188     struct Bet {
189         // Wager amount in wei.
190         uint amount;
191         // Modulo of a game.
192         // uint8 modulo;
193         // Number of winning outcomes, used to compute winning payment (* modulo/rollUnder),
194         // and used instead of mask for games with modulo > MAX_MASK_MODULO.
195         uint8 rollUnder;
196         // Block number of placeBet tx.
197         uint40 placeBlockNumber;
198         // Bit mask representing winning bet outcomes (see MAX_MASK_MODULO comment).
199         uint40 mask;
200         // Address of a gambler, used to pay out winning bets.
201         address payable gambler;
202         // Address of inviter
203         address payable inviter;
204     }
205 
206     struct Profile{
207         // picture index of profile avatar
208         uint avatarIndex;
209         // nickname of user
210         bytes32 nickName;
211     }
212 
213     // Mapping from commits to all currently active & processed bets.
214     mapping (uint => Bet) bets;
215 
216     mapping (address => Profile) profiles;
217 
218     // Croupier account.
219     mapping (address => bool ) croupierMap;
220 
221     address public VIPLibraryAddress;
222 
223     // Events that are issued to make statistic recovery easier.
224     event FailedPayment(address indexed beneficiary, uint amount);
225     event Payment(address indexed beneficiary, uint amount, uint dice, uint rollUnder, uint betAmount);
226     event JackpotPayment(address indexed beneficiary, uint amount, uint dice, uint rollUnder, uint betAmount);
227     event VIPPayback(address indexed beneficiary, uint amount);
228 
229     // This event is emitted in placeBet to record commit in the logs.
230     event Commit(uint commit);
231 
232     // 오늘의 랭킹 보상 지급 이벤트
233     event TodaysRankingPayment(address indexed beneficiary, uint amount);
234 
235     // Constructor. Deliberately does not take any parameters.
236     constructor () public {
237         owner = msg.sender;
238         secretSigner = DUMMY_ADDRESS;
239     }
240 
241     // Standard modifier on methods invokable only by contract owner.
242     modifier onlyOwner {
243         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
244         _;
245     }
246 
247     // Standard modifier on methods invokable only by contract owner.
248     modifier onlyCroupier {
249     bool isCroupier = croupierMap[msg.sender];
250         require(isCroupier, "OnlyCroupier methods called by non-croupier.");
251         _;
252     }
253 
254     // Standard contract ownership transfer implementation,
255     function approveNextOwner(address payable _nextOwner) external onlyOwner {
256         require (_nextOwner != owner, "Cannot approve current owner.");
257         nextOwner = _nextOwner;
258     }
259 
260     function acceptNextOwner() external {
261         require (msg.sender == nextOwner, "Can only accept preapproved new owner.");
262         owner = nextOwner;
263     }
264 
265     // Fallback function deliberately left empty. It's primary use case
266     // is to top up the bank roll.
267     function () external payable {
268     }
269 
270     // See comment for "secretSigner" variable.
271     function setSecretSigner(address newSecretSigner) external onlyOwner {
272         secretSigner = newSecretSigner;
273     }
274 
275     function getSecretSigner() external onlyOwner view returns(address){
276         return secretSigner;
277     }
278 
279     function addCroupier(address newCroupier) external onlyOwner {
280         bool isCroupier = croupierMap[newCroupier];
281         if (isCroupier == false) {
282             croupierMap[newCroupier] = true;
283         }
284     }
285     
286     function deleteCroupier(address newCroupier) external onlyOwner {
287         bool isCroupier = croupierMap[newCroupier];
288         if (isCroupier == true) {
289             croupierMap[newCroupier] = false;
290         }
291     }
292 
293     function setVIPLibraryAddress(address addr) external onlyOwner{
294         VIPLibraryAddress = addr;
295     }
296 
297     // Change max bet reward. Setting this to zero effectively disables betting.
298     function setMaxProfit(uint _maxProfit) public onlyOwner {
299         require (_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
300         maxProfit = _maxProfit;
301     }
302 
303     // This function is used to bump up the jackpot fund. Cannot be used to lower it.
304     function increaseJackpot(uint increaseAmount) external onlyOwner {
305         require (increaseAmount <= address(this).balance, "Increase amount larger than balance.");
306         require (jackpotSize + lockedInBets + increaseAmount <= address(this).balance, "Not enough funds.");
307         jackpotSize += uint128(increaseAmount);
308     }
309 
310     // Funds withdrawal to cover costs of AceDice operation.
311     function withdrawFunds(address payable beneficiary, uint withdrawAmount) external onlyOwner {
312         require (withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
313         require (jackpotSize + lockedInBets + withdrawAmount <= address(this).balance, "Not enough funds.");
314         sendFunds(beneficiary, withdrawAmount, withdrawAmount, 0, 0, 0);
315     }
316 
317     function kill() external onlyOwner {
318         require (lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
319         selfdestruct(owner);
320     }
321 
322     function encodePacketCommit(uint commitLastBlock, uint commit) private pure returns(bytes memory){
323         return abi.encodePacked(uint40(commitLastBlock), commit);
324     }
325 
326     function verifyCommit(uint commitLastBlock, uint commit, uint8 v, bytes32 r, bytes32 s) private view {
327         // Check that commit is valid - it has not expired and its signature is valid.
328         require (block.number <= commitLastBlock, "Commit has expired.");
329         //bytes32 signatureHash = keccak256(abi.encodePacked(commitLastBlock, commit));
330         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
331         bytes memory message = encodePacketCommit(commitLastBlock, commit);
332         bytes32 messageHash = keccak256(abi.encodePacked(prefix, keccak256(message)));
333         require (secretSigner == ecrecover(messageHash, v, r, s), "ECDSA signature is not valid.");
334     }
335 
336     function placeBet(uint betMask, uint commitLastBlock, uint commit, uint8 v, bytes32 r, bytes32 s) external payable {
337         // Check that the bet is in 'clean' state.
338         Bet storage bet = bets[commit];
339         require (bet.gambler == address(0), "Bet should be in a 'clean' state.");
340 
341         // Validate input data ranges.
342         uint amount = msg.value;
343         //require (modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
344         require (amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
345         require (betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
346 
347         verifyCommit(commitLastBlock, commit, v, r, s);
348 
349         // uint rollUnder;
350         uint mask;
351 
352         // if (modulo <= MAX_MASK_MODULO) {
353         //   // Small modulo games specify bet outcomes via bit mask.
354         //   // rollUnder is a number of 1 bits in this mask (population count).
355         //   // This magic looking formula is an efficient way to compute population
356         //   // count on EVM for numbers below 2**40. For detailed proof consult
357         //   // the AceDice whitepaper.
358         //   rollUnder = ((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
359         //   mask = betMask;
360         //   } else {
361         // Larger modulos specify the right edge of half-open interval of
362         // winning bet outcomes.
363         require (betMask > 0 && betMask <= 100, "High modulo range, betMask larger than modulo.");
364         // rollUnder = betMask;
365         // }
366 
367         // Winning amount and jackpot increase.
368         uint possibleWinAmount;
369         uint jackpotFee;
370 
371         (possibleWinAmount, jackpotFee) = getDiceWinAmount(amount, betMask);
372 
373         // Enforce max profit limit.
374         require (possibleWinAmount <= amount + maxProfit, "maxProfit limit violation. ");
375 
376         // Lock funds.
377         lockedInBets += uint128(possibleWinAmount);
378         jackpotSize += uint128(jackpotFee);
379 
380         // Check whether contract has enough funds to process this bet.
381         require (jackpotSize + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
382 
383         // Record commit in logs.
384         emit Commit(commit);
385 
386         // Store bet parameters on blockchain.
387         bet.amount = amount;
388         // bet.modulo = uint8(modulo);
389         bet.rollUnder = uint8(betMask);
390         bet.placeBlockNumber = uint40(block.number);
391         bet.mask = uint40(mask);
392         bet.gambler = msg.sender;
393 
394         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
395         vipLib.addUserExp(msg.sender, amount);
396     }
397 
398     function applyVIPLevel(address payable gambler, uint amount) private {
399         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
400         uint rate = vipLib.getVIPBounusRate(gambler);
401         // uint accuAmount = accuBetAmount[gambler];
402         // uint rate;
403         // if(accuAmount >= 30 ether && accuAmount < 150 ether){
404         //     rate = 1;
405         // } else if(accuAmount >= 150 ether && accuAmount < 300 ether){
406         //     rate = 2;
407         // } else if(accuAmount >= 300 ether && accuAmount < 1500 ether){
408         //     rate = 4;
409         // } else if(accuAmount >= 1500 ether && accuAmount < 3000 ether){
410         //     rate = 6;
411         // } else if(accuAmount >= 3000 ether && accuAmount < 15000 ether){
412         //     rate = 8;
413         // } else if(accuAmount >= 15000 ether && accuAmount < 30000 ether){
414         //     rate = 10;
415         // } else if(accuAmount >= 30000 ether && accuAmount < 150000 ether){
416         //     rate = 12;
417         // } else if(accuAmount >= 150000 ether){
418         //     rate = 15;
419         // } else{
420         //     return;
421         // }
422         if (rate <= 0)
423             return;
424 
425         uint vipPayback = amount * rate / 10000;
426         if(gambler.send(vipPayback)){
427             emit VIPPayback(gambler, vipPayback);
428         }
429     }
430 
431     function placeBetWithInviter(uint betMask, uint commitLastBlock, uint commit, uint8 v, bytes32 r, bytes32 s, address payable inviter) external payable {
432         // Check that the bet is in 'clean' state.
433         Bet storage bet = bets[commit];
434         require (bet.gambler == address(0), "Bet should be in a 'clean' state.");
435 
436         // Validate input data ranges.
437         uint amount = msg.value;
438         // require (modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
439         require (amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
440         require (betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
441         require (address(this) != inviter && inviter != address(0), "cannot invite mysql");
442 
443         verifyCommit(commitLastBlock, commit, v, r, s);
444 
445         // uint rollUnder;
446         uint mask;
447 
448         // if (modulo <= MAX_MASK_MODULO) {
449         //   // Small modulo games specify bet outcomes via bit mask.
450         //   // rollUnder is a number of 1 bits in this mask (population count).
451         //   // This magic looking formula is an efficient way to compute population
452         //   // count on EVM for numbers below 2**40. For detailed proof consult
453         //   // the AceDice whitepaper.
454         //   rollUnder = ((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
455         //   mask = betMask;
456         // } else {
457         // Larger modulos specify the right edge of half-open interval of
458         // winning bet outcomes.
459         require (betMask > 0 && betMask <= 100, "High modulo range, betMask larger than modulo.");
460         // rollUnder = betMask;
461         // }
462 
463         // Winning amount and jackpot increase.
464         uint possibleWinAmount;
465         uint jackpotFee;
466 
467         (possibleWinAmount, jackpotFee) = getDiceWinAmount(amount, betMask);
468 
469         // Enforce max profit limit.
470         require (possibleWinAmount <= amount + maxProfit, "maxProfit limit violation. ");
471 
472         // Lock funds.
473         lockedInBets += uint128(possibleWinAmount);
474         jackpotSize += uint128(jackpotFee);
475 
476         // Check whether contract has enough funds to process this bet.
477         require (jackpotSize + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
478 
479         // Record commit in logs.
480         emit Commit(commit);
481 
482         // Store bet parameters on blockchain.
483         bet.amount = amount;
484         // bet.modulo = uint8(modulo);
485         bet.rollUnder = uint8(betMask);
486         bet.placeBlockNumber = uint40(block.number);
487         bet.mask = uint40(mask);
488         bet.gambler = msg.sender;
489         bet.inviter = inviter;
490 
491         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
492         vipLib.addUserExp(msg.sender, amount);
493     }
494 
495     function getMyAccuAmount() external view returns (uint){
496         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
497         return vipLib.getUserExp(msg.sender);
498     }
499 
500     // This is the method used to settle 99% of bets. To process a bet with a specific
501     // "commit", settleBet should supply a "reveal" number that would Keccak256-hash to
502     // "commit". "blockHash" is the block hash of placeBet block as seen by croupier; it
503     // is additionally asserted to prevent changing the bet outcomes on Ethereum reorgs.
504     function settleBet(uint reveal, bytes32 blockHash) external onlyCroupier {
505         uint commit = uint(keccak256(abi.encodePacked(reveal)));
506 
507         Bet storage bet = bets[commit];
508         uint placeBlockNumber = bet.placeBlockNumber;
509 
510         // Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
511         require (block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
512         require (block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
513         require (blockhash(placeBlockNumber) == blockHash);
514 
515         // Settle bet using reveal and blockHash as entropy sources.
516         settleBetCommon(bet, reveal, blockHash);
517     }
518 
519         // Common settlement code for settleBet & settleBetUncleMerkleProof.
520     function settleBetCommon(Bet storage bet, uint reveal, bytes32 entropyBlockHash) private {
521         // Fetch bet parameters into local variables (to save gas).
522         uint amount = bet.amount;
523         // uint modulo = bet.modulo;
524         uint rollUnder = bet.rollUnder;
525         address payable gambler = bet.gambler;
526 
527         // Check that bet is in 'active' state.
528         require (amount != 0, "Bet should be in an 'active' state");
529 
530         applyVIPLevel(gambler, amount);
531 
532         // Move bet into 'processed' state already.
533         bet.amount = 0;
534 
535         // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
536         // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
537         // preimage is intractable), and house is unable to alter the "reveal" after
538         // placeBet have been mined (as Keccak256 collision finding is also intractable).
539         bytes32 entropy = keccak256(abi.encodePacked(reveal, entropyBlockHash));
540 
541         // Do a roll by taking a modulo of entropy. Compute winning amount.
542         uint modulo = 100;
543         uint dice = uint(entropy) % modulo;
544 
545         uint diceWinAmount;
546         uint _jackpotFee;
547         (diceWinAmount, _jackpotFee) = getDiceWinAmount(amount, rollUnder);
548 
549         uint diceWin = 0;
550         uint jackpotWin = 0;
551 
552         // Determine dice outcome.
553         if (modulo <= MAX_MASK_MODULO) {
554             // For small modulo games, check the outcome against a bit mask.
555             if ((2 ** dice) & bet.mask != 0) {
556                 diceWin = diceWinAmount;
557             }
558 
559         } else {
560             // For larger modulos, check inclusion into half-open interval.
561             if (dice < rollUnder) {
562                 diceWin = diceWinAmount;
563             }
564 
565         }
566 
567         // Unlock the bet amount, regardless of the outcome.
568         lockedInBets -= uint128(diceWinAmount);
569 
570         // Roll for a jackpot (if eligible).
571         if (amount >= MIN_JACKPOT_BET) {
572             // The second modulo, statistically independent from the "main" dice roll.
573             // Effectively you are playing two games at once!
574             // uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;
575 
576             // Bingo!
577             if ((uint(entropy) / modulo) % JACKPOT_MODULO == 0) {
578                 jackpotWin = jackpotSize;
579                 jackpotSize = 0;
580             }
581         }
582 
583         // Log jackpot win.
584         if (jackpotWin > 0) {
585             emit JackpotPayment(gambler, jackpotWin, dice, rollUnder, amount);
586         }
587 
588         if(bet.inviter != address(0)){
589             // 친구 초대하면 친구한대 15% 때어줌
590             // uint inviterFee = amount * HOUSE_EDGE_PERCENT / 100 * 15 /100;
591             bet.inviter.transfer(amount * HOUSE_EDGE_PERCENT / 100 * 10 /100);
592         }
593         todaysRewardSize += amount * HOUSE_EDGE_PERCENT / 100 * 9 /100;
594         // Send the funds to gambler.
595         sendFunds(gambler, diceWin + jackpotWin == 0 ? 1 wei : diceWin + jackpotWin, diceWin, dice, rollUnder, amount);
596     }
597 
598     // Refund transaction - return the bet amount of a roll that was not processed in a
599     // due timeframe. Processing such blocks is not possible due to EVM limitations (see
600     // BET_EXPIRATION_BLOCKS comment above for details). In case you ever find yourself
601     // in a situation like this, just contact the AceDice support, however nothing
602     // precludes you from invoking this method yourself.
603     function refundBet(uint commit) external {
604         // Check that bet is in 'active' state.
605         Bet storage bet = bets[commit];
606         uint amount = bet.amount;
607 
608         require (amount != 0, "Bet should be in an 'active' state");
609 
610         // Check that bet has already expired.
611         require (block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
612 
613         // Move bet into 'processed' state, release funds.
614         bet.amount = 0;
615 
616         uint diceWinAmount;
617         uint jackpotFee;
618         (diceWinAmount, jackpotFee) = getDiceWinAmount(amount, bet.rollUnder);
619 
620         lockedInBets -= uint128(diceWinAmount);
621         jackpotSize -= uint128(jackpotFee);
622 
623         // Send the refund.
624         sendFunds(bet.gambler, amount, amount, 0, 0, 0);
625     }
626 
627     // Get the expected win amount after house edge is subtracted.
628     function getDiceWinAmount(uint amount, uint rollUnder) private pure returns (uint winAmount, uint jackpotFee) {
629         require (0 < rollUnder && rollUnder <= 100, "Win probability out of range.");
630 
631         jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
632 
633         uint houseEdge = amount * HOUSE_EDGE_PERCENT / 100;
634 
635         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
636         houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
637         }
638 
639         require (houseEdge + jackpotFee <= amount, "Bet doesn't even cover house edge.");
640         winAmount = (amount - houseEdge - jackpotFee) * 100 / rollUnder;
641     }
642 
643     // Helper routine to process the payment.
644     function sendFunds(address payable beneficiary, uint amount, uint successLogAmount, uint dice, uint rollUnder, uint betAmount) private {
645         if (beneficiary.send(amount)) {
646             emit Payment(beneficiary, successLogAmount, dice, rollUnder, betAmount);
647         } else {
648             emit FailedPayment(beneficiary, amount);
649         }
650     }
651 
652     function thisBalance() public view returns(uint) {
653         return address(this).balance;
654     }
655 
656     function setAvatarIndex(uint index) external{
657         require (index >=0 && index <= 100, "avatar index should be in range");
658         Profile storage profile = profiles[msg.sender];
659         profile.avatarIndex = index;
660     }
661 
662     function setNickName(bytes32 nickName) external{
663         Profile storage profile = profiles[msg.sender];
664         profile.nickName = nickName;
665     }
666 
667     function getProfile() external view returns(uint, bytes32){
668         Profile storage profile = profiles[msg.sender];
669         return (profile.avatarIndex, profile.nickName);
670     }
671 
672     function payTodayReward(address payable to) external onlyOwner {
673         uint prize = todaysRewardSize / 2;
674         todaysRewardSize = todaysRewardSize - prize;
675         if(to.send(prize)){
676             emit TodaysRankingPayment(to, prize);
677         }
678     }
679 }