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
136 contract AceDice {
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
155     uint constant MAX_AMOUNT = 300000 ether;
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
213         // Modulo of a game.
214         // uint8 modulo;
215         // Number of winning outcomes, used to compute winning payment (* modulo/rollUnder),
216         // and used instead of mask for games with modulo > MAX_MASK_MODULO.
217         uint8 rollUnder;
218         // Block number of placeBet tx.
219         uint40 placeBlockNumber;
220         // Bit mask representing winning bet outcomes (see MAX_MASK_MODULO comment).
221         uint40 mask;
222         // Address of a gambler, used to pay out winning bets.
223         address payable gambler;
224         // Address of inviter
225         address payable inviter;
226     }
227 
228     struct Profile{
229         // picture index of profile avatar
230         uint avatarIndex;
231         // nickname of user
232         bytes32 nickName;
233     }
234 
235     // Mapping from commits to all currently active & processed bets.
236     mapping (uint => Bet) bets;
237 
238     mapping (address => Profile) profiles;
239 
240     // Croupier account.
241     mapping (address => bool ) croupierMap;
242 
243     address payable public VIPLibraryAddress;
244 
245     // Events that are issued to make statistic recovery easier.
246     event FailedPayment(address indexed beneficiary, uint amount);
247     event Payment(address indexed beneficiary, uint amount, uint dice, uint rollUnder, uint betAmount);
248     event JackpotPayment(address indexed beneficiary, uint amount, uint dice, uint rollUnder, uint betAmount);
249     event VIPPayback(address indexed beneficiary, uint amount);
250 
251     // This event is emitted in placeBet to record commit in the logs.
252     event Commit(uint commit);
253 
254     // Constructor. Deliberately does not take any parameters.
255     constructor () public {
256         owner = msg.sender;
257         secretSigner = DUMMY_ADDRESS;
258     }
259 
260     // Standard modifier on methods invokable only by contract owner.
261     modifier onlyOwner {
262         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
263         _;
264     }
265 
266     // Standard modifier on methods invokable only by contract owner.
267     modifier onlyCroupier {
268     bool isCroupier = croupierMap[msg.sender];
269         require(isCroupier, "OnlyCroupier methods called by non-croupier.");
270         _;
271     }
272 
273     // Standard contract ownership transfer implementation,
274     function approveNextOwner(address payable _nextOwner) external onlyOwner {
275         require (_nextOwner != owner, "Cannot approve current owner.");
276         nextOwner = _nextOwner;
277     }
278 
279     function acceptNextOwner() external {
280         require (msg.sender == nextOwner, "Can only accept preapproved new owner.");
281         owner = nextOwner;
282     }
283 
284     // Fallback function deliberately left empty. It's primary use case
285     // is to top up the bank roll.
286     function () external payable {
287     }
288 
289     // See comment for "secretSigner" variable.
290     function setSecretSigner(address newSecretSigner) external onlyOwner {
291         secretSigner = newSecretSigner;
292     }
293 
294     function getSecretSigner() external onlyOwner view returns(address){
295         return secretSigner;
296     }
297 
298     function addCroupier(address newCroupier) external onlyOwner {
299         bool isCroupier = croupierMap[newCroupier];
300         if (isCroupier == false) {
301             croupierMap[newCroupier] = true;
302         }
303     }
304     
305     function deleteCroupier(address newCroupier) external onlyOwner {
306         bool isCroupier = croupierMap[newCroupier];
307         if (isCroupier == true) {
308             croupierMap[newCroupier] = false;
309         }
310     }
311 
312     function setVIPLibraryAddress(address payable addr) external onlyOwner{
313         VIPLibraryAddress = addr;
314     }
315 
316     // Change max bet reward. Setting this to zero effectively disables betting.
317     function setMaxProfit(uint _maxProfit) public onlyOwner {
318         require (_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
319         maxProfit = _maxProfit;
320     }
321 
322     // Funds withdrawal to cover costs of AceDice operation.
323     function withdrawFunds(address payable beneficiary, uint withdrawAmount) external onlyOwner {
324         require (withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
325         require (lockedInBets + withdrawAmount <= address(this).balance, "Not enough funds.");
326         sendFunds(beneficiary, withdrawAmount, withdrawAmount, 0, 0, 0);
327     }
328 
329     function kill() external onlyOwner {
330         require (lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
331         selfdestruct(owner);
332     }
333 
334     function encodePacketCommit(uint commitLastBlock, uint commit) private pure returns(bytes memory){
335         return abi.encodePacked(uint40(commitLastBlock), commit);
336     }
337 
338     function verifyCommit(uint commitLastBlock, uint commit, uint8 v, bytes32 r, bytes32 s) private view {
339         // Check that commit is valid - it has not expired and its signature is valid.
340         require (block.number <= commitLastBlock, "Commit has expired.");
341         //bytes32 signatureHash = keccak256(abi.encodePacked(commitLastBlock, commit));
342         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
343         bytes memory message = encodePacketCommit(commitLastBlock, commit);
344         bytes32 messageHash = keccak256(abi.encodePacked(prefix, keccak256(message)));
345         require (secretSigner == ecrecover(messageHash, v, r, s), "ECDSA signature is not valid.");
346     }
347 
348     function placeBet(uint betMask, uint commitLastBlock, uint commit, uint8 v, bytes32 r, bytes32 s) external payable {
349         // Check that the bet is in 'clean' state.
350         Bet storage bet = bets[commit];
351         require (bet.gambler == address(0), "Bet should be in a 'clean' state.");
352 
353         // Validate input data ranges.
354         uint amount = msg.value;
355         //require (modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
356         require (amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
357         require (betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
358 
359         verifyCommit(commitLastBlock, commit, v, r, s);
360 
361         // uint rollUnder;
362         uint mask;
363 
364         // if (modulo <= MAX_MASK_MODULO) {
365         //   // Small modulo games specify bet outcomes via bit mask.
366         //   // rollUnder is a number of 1 bits in this mask (population count).
367         //   // This magic looking formula is an efficient way to compute population
368         //   // count on EVM for numbers below 2**40. For detailed proof consult
369         //   // the AceDice whitepaper.
370         //   rollUnder = ((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
371         //   mask = betMask;
372         //   } else {
373         // Larger modulos specify the right edge of half-open interval of
374         // winning bet outcomes.
375         require (betMask > 0 && betMask <= 100, "High modulo range, betMask larger than modulo.");
376         // rollUnder = betMask;
377         // }
378 
379         // Winning amount and jackpot increase.
380         uint possibleWinAmount;
381         uint jackpotFee;
382 
383         (possibleWinAmount, jackpotFee) = getDiceWinAmount(amount, betMask);
384 
385         // Enforce max profit limit.
386         require (possibleWinAmount <= amount + maxProfit, "maxProfit limit violation. ");
387 
388         // Lock funds.
389         lockedInBets += uint128(possibleWinAmount);
390 
391         // Check whether contract has enough funds to process this bet.
392         require (jackpotFee + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
393 
394         // Record commit in logs.
395         emit Commit(commit);
396 
397         // Store bet parameters on blockchain.
398         bet.amount = amount;
399         // bet.modulo = uint8(modulo);
400         bet.rollUnder = uint8(betMask);
401         bet.placeBlockNumber = uint40(block.number);
402         bet.mask = uint40(mask);
403         bet.gambler = msg.sender;
404 
405         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
406         vipLib.addUserExp(msg.sender, amount);
407     }
408 
409     function placeBetWithInviter(uint betMask, uint commitLastBlock, uint commit, uint8 v, bytes32 r, bytes32 s, address payable inviter) external payable {
410         // Check that the bet is in 'clean' state.
411         Bet storage bet = bets[commit];
412         require (bet.gambler == address(0), "Bet should be in a 'clean' state.");
413 
414         // Validate input data ranges.
415         uint amount = msg.value;
416         // require (modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
417         require (amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
418         require (betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
419         require (address(this) != inviter && inviter != address(0), "cannot invite mysql");
420 
421         verifyCommit(commitLastBlock, commit, v, r, s);
422 
423         // uint rollUnder;
424         uint mask;
425 
426         // if (modulo <= MAX_MASK_MODULO) {
427         //   // Small modulo games specify bet outcomes via bit mask.
428         //   // rollUnder is a number of 1 bits in this mask (population count).
429         //   // This magic looking formula is an efficient way to compute population
430         //   // count on EVM for numbers below 2**40. For detailed proof consult
431         //   // the AceDice whitepaper.
432         //   rollUnder = ((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
433         //   mask = betMask;
434         // } else {
435         // Larger modulos specify the right edge of half-open interval of
436         // winning bet outcomes.
437         require (betMask > 0 && betMask <= 100, "High modulo range, betMask larger than modulo.");
438         // rollUnder = betMask;
439         // }
440 
441         // Winning amount and jackpot increase.
442         uint possibleWinAmount;
443         uint jackpotFee;
444 
445         (possibleWinAmount, jackpotFee) = getDiceWinAmount(amount, betMask);
446 
447         // Enforce max profit limit.
448         require (possibleWinAmount <= amount + maxProfit, "maxProfit limit violation. ");
449 
450         // Lock funds.
451         lockedInBets += uint128(possibleWinAmount);
452         // jackpotSize += uint128(jackpotFee);
453 
454         // Check whether contract has enough funds to process this bet.
455         require (jackpotFee + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
456 
457         // Record commit in logs.
458         emit Commit(commit);
459 
460         // Store bet parameters on blockchain.
461         bet.amount = amount;
462         // bet.modulo = uint8(modulo);
463         bet.rollUnder = uint8(betMask);
464         bet.placeBlockNumber = uint40(block.number);
465         bet.mask = uint40(mask);
466         bet.gambler = msg.sender;
467         bet.inviter = inviter;
468 
469         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
470         vipLib.addUserExp(msg.sender, amount);
471     }
472     
473     function applyVIPLevel(address payable gambler, uint amount) private {
474         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
475         uint rate = vipLib.getVIPBounusRate(gambler);
476 
477         if (rate <= 0)
478             return;
479 
480         uint vipPayback = amount * rate / 10000;
481         if(gambler.send(vipPayback)){
482             emit VIPPayback(gambler, vipPayback);
483         }
484     }
485 
486     function getMyAccuAmount() external view returns (uint){
487         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
488         return vipLib.getUserExp(msg.sender);
489     }
490 
491     function getJackpotSize() external view returns (uint){
492         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
493         return vipLib.getJackpotSize();
494     }
495 
496     // This is the method used to settle 99% of bets. To process a bet with a specific
497     // "commit", settleBet should supply a "reveal" number that would Keccak256-hash to
498     // "commit". "blockHash" is the block hash of placeBet block as seen by croupier; it
499     // is additionally asserted to prevent changing the bet outcomes on Ethereum reorgs.
500     function settleBet(uint reveal, bytes32 blockHash) external onlyCroupier {
501         uint commit = uint(keccak256(abi.encodePacked(reveal)));
502 
503         Bet storage bet = bets[commit];
504         uint placeBlockNumber = bet.placeBlockNumber;
505 
506         // Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
507         require (block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
508         require (block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
509         require (blockhash(placeBlockNumber) == blockHash);
510 
511         // Settle bet using reveal and blockHash as entropy sources.
512         settleBetCommon(bet, reveal, blockHash);
513     }
514 
515         // Common settlement code for settleBet & settleBetUncleMerkleProof.
516     function settleBetCommon(Bet storage bet, uint reveal, bytes32 entropyBlockHash) private {
517         // Fetch bet parameters into local variables (to save gas).
518         uint amount = bet.amount;
519         // uint modulo = bet.modulo;
520         uint rollUnder = bet.rollUnder;
521         address payable gambler = bet.gambler;
522 
523         // Check that bet is in 'active' state.
524         require (amount != 0, "Bet should be in an 'active' state");
525 
526         applyVIPLevel(gambler, amount);
527 
528         // Move bet into 'processed' state already.
529         bet.amount = 0;
530 
531         // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
532         // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
533         // preimage is intractable), and house is unable to alter the "reveal" after
534         // placeBet have been mined (as Keccak256 collision finding is also intractable).
535         bytes32 entropy = keccak256(abi.encodePacked(reveal, entropyBlockHash));
536 
537         // Do a roll by taking a modulo of entropy. Compute winning amount.
538         uint dice = uint(entropy) % 100;
539 
540         uint diceWinAmount;
541         uint _jackpotFee;
542         (diceWinAmount, _jackpotFee) = getDiceWinAmount(amount, rollUnder);
543 
544         uint diceWin = 0;
545         uint jackpotWin = 0;
546 
547 
548         if (dice < rollUnder) {
549             diceWin = diceWinAmount;
550         }
551 
552         // Unlock the bet amount, regardless of the outcome.
553         lockedInBets -= uint128(diceWinAmount);
554         
555         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
556                 
557         // Roll for a jackpot (if eligible).
558         if (amount >= MIN_JACKPOT_BET) {
559             
560             VIPLibraryAddress.transfer(_jackpotFee);
561             vipLib.increaseJackpot(_jackpotFee);
562 
563             // The second modulo, statistically independent from the "main" dice roll.
564             // Effectively you are playing two games at once!
565             // uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;
566 
567             // Bingo!
568             if ((uint(entropy) / 100) % JACKPOT_MODULO == 0) {
569                 jackpotWin = vipLib.getJackpotSize();
570                 vipLib.payJackpotReward(gambler);
571             }
572         }
573 
574         // Log jackpot win.
575         if (jackpotWin > 0) {
576             emit JackpotPayment(gambler, jackpotWin, dice, rollUnder, amount);
577         }
578 
579         if(bet.inviter != address(0)){
580             // pay 10% of house edge to inviter
581             bet.inviter.transfer(amount * HOUSE_EDGE_PERCENT / 100 * 7 /100);
582         }
583 
584         // uint128 rankingRewardFee = uint128(amount * HOUSE_EDGE_PERCENT / 100 * 9 /100);
585         VIPLibraryAddress.transfer(uint128(amount * HOUSE_EDGE_PERCENT / 100 * 7 /100));
586         vipLib.increaseRankingReward(uint128(amount * HOUSE_EDGE_PERCENT / 100 * 7 /100));
587 
588         // Send the funds to gambler.
589         sendFunds(gambler, diceWin == 0 ? 1 wei : diceWin, diceWin, dice, rollUnder, amount);
590     }
591 
592     // Refund transaction - return the bet amount of a roll that was not processed in a
593     // due timeframe. Processing such blocks is not possible due to EVM limitations (see
594     // BET_EXPIRATION_BLOCKS comment above for details). In case you ever find yourself
595     // in a situation like this, just contact the AceDice support, however nothing
596     // precludes you from invoking this method yourself.
597     function refundBet(uint commit) external {
598         // Check that bet is in 'active' state.
599         Bet storage bet = bets[commit];
600         uint amount = bet.amount;
601 
602         require (amount != 0, "Bet should be in an 'active' state");
603 
604         // Check that bet has already expired.
605         require (block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
606 
607         // Move bet into 'processed' state, release funds.
608         bet.amount = 0;
609 
610         uint diceWinAmount;
611         uint jackpotFee;
612         (diceWinAmount, jackpotFee) = getDiceWinAmount(amount, bet.rollUnder);
613 
614         lockedInBets -= uint128(diceWinAmount);
615 
616         // Send the refund.
617         sendFunds(bet.gambler, amount, amount, 0, 0, 0);
618     }
619 
620     // Get the expected win amount after house edge is subtracted.
621     function getDiceWinAmount(uint amount, uint rollUnder) private pure returns (uint winAmount, uint jackpotFee) {
622         require (0 < rollUnder && rollUnder <= 100, "Win probability out of range.");
623 
624         jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
625 
626         uint houseEdge = amount * HOUSE_EDGE_PERCENT / 100;
627 
628         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
629         houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
630         }
631 
632         require (houseEdge + jackpotFee <= amount, "Bet doesn't even cover house edge.");
633         winAmount = (amount - houseEdge - jackpotFee) * 100 / rollUnder;
634     }
635 
636     // Helper routine to process the payment.
637     function sendFunds(address payable beneficiary, uint amount, uint successLogAmount, uint dice, uint rollUnder, uint betAmount) private {
638         if (beneficiary.send(amount)) {
639             emit Payment(beneficiary, successLogAmount, dice, rollUnder, betAmount);
640         } else {
641             emit FailedPayment(beneficiary, amount);
642         }
643     }
644 
645     function thisBalance() public view returns(uint) {
646         return address(this).balance;
647     }
648 
649     function setAvatarIndex(uint index) external{
650         require (index >=0 && index <= 100, "avatar index should be in range");
651         Profile storage profile = profiles[msg.sender];
652         profile.avatarIndex = index;
653     }
654 
655     function setNickName(bytes32 nickName) external{
656         Profile storage profile = profiles[msg.sender];
657         profile.nickName = nickName;
658     }
659 
660     function getProfile() external view returns(uint, bytes32){
661         Profile storage profile = profiles[msg.sender];
662         return (profile.avatarIndex, profile.nickName);
663     }
664 
665     function payTodayReward(address payable to) external onlyOwner {
666         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
667         vipLib.payRankingReward(to);
668     }
669 
670     function getRankingRewardSize() external view returns (uint128) {
671         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
672         return vipLib.getRankingRewardSize();
673     }
674 }