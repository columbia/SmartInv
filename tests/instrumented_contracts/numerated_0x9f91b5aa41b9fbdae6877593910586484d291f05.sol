1 pragma solidity ^0.4.24;
2 
3 // * fairhouse.io - Fair and transparent entertainment games. Version 1.
4 //
5 // * Ethereum smart contract.
6 //
7 // * Uses hybrid commit-reveal + block hash random number generation that is immune
8 //   to tampering by players, house and miners. Apart from being fully transparent,
9 //   this also allows arbitrarily high bets.
10 //
11 contract FairHouse {
12 
13     using SafeMath for uint256;
14     using NameFilter for string;
15 
16     /// *** Constants section
17 
18     // Each bet is deducted 1% in favour of the house, but no less than some minimum.
19     // The lower bound is dictated by gas costs of the settleBet transaction, providing
20     // headroom for up to 10 Gwei prices.
21     uint constant HOUSE_EDGE_PERCENT = 1;
22     uint constant HOUSE_EDGE_MINIMUM_AMOUNT = 0.0003 ether;
23 
24     // If there is a recommendation,
25     // each bet is deducted from the house 50% to the recommender,
26     // but the house no less than HOUSE_EDGE_MINIMUM_AMOUNT.
27     uint constant RECOMMENDER_PERCENT = 50;
28 
29     // Bets lower than this amount do not participate in jackpot rolls (and are
30     // not deducted JACKPOT_FEE).
31     uint constant MIN_JACKPOT_BET = 0.1 ether;
32 
33     // Chance to win jackpot (currently 0.1%) and fee deducted into jackpot fund.
34     uint constant JACKPOT_MODULO = 1000;
35     uint constant JACKPOT_FEE = 0.001 ether;
36 
37     // There is minimum and maximum bets.
38     uint constant MIN_BET = 0.01 ether;
39     uint constant MAX_AMOUNT = 300000 ether;
40 
41     // Modulo is a number of equiprobable outcomes in a game:
42     //  - 2 for coin flip
43     //  - 6 for dice
44     //  - 6*6 = 36 for double dice
45     //  - 100 for etheroll
46     //  - 37 for roulette
47     //  etc.
48     // It's called so because 256-bit entropy is treated like a huge integer and
49     // the remainder of its division by modulo is considered bet outcome.
50     uint constant MAX_MODULO = 100;
51 
52     // For modulos below this threshold rolls are checked against a bit mask,
53     // thus allowing betting on any combination of outcomes. For example, given
54     // modulo 6 for dice, 101000 mask (base-2, big endian) means betting on
55     // 4 and 6; for games with modulos higher than threshold (Etheroll), a simple
56     // limit is used, allowing betting on any outcome in [0, N) range.
57     //
58     // The specific value is dictated by the fact that 256-bit intermediate
59     // multiplication result allows implementing population count efficiently
60     // for numbers that are up to 42 bits, and 40 is the highest multiple of
61     // eight below 42.
62     uint constant MAX_MASK_MODULO = 40;
63 
64     // This is a check on bet mask overflow.
65     uint constant MAX_BET_MASK = 2 ** MAX_MASK_MODULO;
66 
67     // EVM BLOCKHASH opcode can query no further than 256 blocks into the
68     // past. Given that settleBet uses block hash of placeBet as one of
69     // complementary entropy sources, we cannot process bets older than this
70     // threshold. On rare occasions fairhouse.io croupier may fail to invoke
71     // settleBet in this timespan due to technical issues or extreme Ethereum
72     // congestion; such bets can be refunded via invoking refundBet.
73     uint constant BET_EXPIRATION_BLOCKS = 250;
74 
75     // Some deliberately invalid address to initialize the secret signer with.
76     // Forces maintainers to invoke setSecretSigner before processing any bets.
77     address constant DUMMY_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
78 
79     // Standard contract ownership transfer.
80     address public owner;
81     address private nextOwner;
82 
83     // Adjustable max bet profit. Used to cap bets against dynamic odds.
84     uint public maxProfit;
85 
86     // The address corresponding to a private key used to sign placeBet commits.
87     address public secretSigner;
88 
89     // Accumulated jackpot fund.
90     uint public jackpotSize;
91 
92     // Funds that are locked in potentially winning bets. Prevents contract from
93     // committing to bets it cannot pay out.
94     uint public lockedInBets;
95 
96     // A structure representing a single bet.
97     struct Bet {
98         // Wager amount in wei.
99         uint amount;
100         // Modulo of a game.
101         uint8 modulo;
102         // Number of winning outcomes, used to compute winning payment (* modulo/rollUnder),
103         // and used instead of mask for games with modulo > MAX_MASK_MODULO.
104         uint8 rollUnder;
105         // Block number of placeBet tx.
106         uint placeBlockNumber;
107         // Bit mask representing winning bet outcomes (see MAX_MASK_MODULO comment).
108         uint40 mask;
109         // Address of a gambler, used to pay out winning bets.
110         address gambler;
111     }
112 
113     // Mapping from commits to all currently active & processed bets.
114     mapping (uint => Bet) bets;
115 
116     // Croupier account.
117     address public croupier;
118 
119     // Price to register a name
120     uint constant REGISTRATION_FEE = 0.05 ether;
121 
122     // Total number of players
123     uint playerId = 0;
124 
125     struct Player {
126         address addr;
127         bytes32 name;
128         uint recPid;
129     }
130 
131     mapping (address => uint256) pidXaddr;
132     mapping (bytes32 => uint256) pidXname;
133     mapping (uint256 => Player) playerXpid;
134 
135     // Events that are issued to make statistic recovery easier.
136     event FailedPayment(address indexed beneficiary, uint amount);
137     event Payment(address indexed beneficiary, uint amount);
138     event RecommendPayment(address indexed beneficiary, uint amount);
139     event JackpotPayment(address indexed beneficiary, uint amount);
140     event OnRegisterName(uint indexed pid, bytes32 indexed pname, address indexed paddr, uint recPid, bytes32 recPname, address recPaddr, uint amountPaid, bool isNewPlayer, uint timeStamp);
141 
142     // This event is emitted in placeBet to record commit in the logs.
143     event Commit(uint commit);
144 
145     // Constructor. Deliberately does not take any parameters.
146     constructor () public {
147         owner = msg.sender;
148         secretSigner = DUMMY_ADDRESS;
149         croupier = DUMMY_ADDRESS;
150     }
151 
152     // Standard modifier on methods invokable only by contract owner.
153     modifier onlyOwner {
154         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
155         _;
156     }
157 
158     // Standard modifier on methods invokable only by contract owner.
159     modifier onlyCroupier {
160         require (msg.sender == croupier, "OnlyCroupier methods called by non-croupier.");
161         _;
162     }
163 
164     // Standard contract ownership transfer implementation,
165     function approveNextOwner(address _nextOwner) external onlyOwner {
166         require (_nextOwner != owner, "Cannot approve current owner.");
167         nextOwner = _nextOwner;
168     }
169 
170     function acceptNextOwner() external {
171         require (msg.sender == nextOwner, "Can only accept preapproved new owner.");
172         owner = nextOwner;
173     }
174 
175     // Fallback function deliberately left empty. It's primary use case
176     // is to top up the bank roll.
177     function () public payable {
178     }
179 
180     // See comment for "secretSigner" variable.
181     function setSecretSigner(address newSecretSigner) external onlyOwner {
182         secretSigner = newSecretSigner;
183     }
184 
185     // Change the croupier address.
186     function setCroupier(address newCroupier) external onlyOwner {
187         croupier = newCroupier;
188     }
189 
190     // Change max bet reward. Setting this to zero effectively disables betting.
191     function setMaxProfit(uint _maxProfit) public onlyOwner {
192         require (_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
193         maxProfit = _maxProfit;
194     }
195 
196     // This function is used to bump up the jackpot fund. Cannot be used to lower it.
197     function increaseJackpot(uint increaseAmount) external onlyOwner {
198         require (increaseAmount <= address(this).balance, "Increase amount larger than balance.");
199         require (jackpotSize.add(lockedInBets).add(increaseAmount) <= address(this).balance, "Not enough funds.");
200         jackpotSize = jackpotSize.add(increaseAmount);
201     }
202 
203     // Funds withdrawal to cover costs of fairhouse.io operation.
204     function withdrawFunds(address beneficiary, uint withdrawAmount) external onlyOwner {
205         require (withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
206         require (jackpotSize.add(lockedInBets).add(withdrawAmount) <= address(this).balance, "Not enough funds.");
207         sendFunds(beneficiary, withdrawAmount, withdrawAmount);
208     }
209 
210     // Contract may be destroyed only when there are no ongoing bets,
211     // either settled or refunded. All funds are transferred to contract owner.
212     function kill() external onlyOwner {
213         require (lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
214         selfdestruct(owner);
215     }
216 
217     /// *** Betting logic
218 
219     // Bet states:
220     //  amount == 0 && gambler == 0 - 'clean' (can place a bet)
221     //  amount != 0 && gambler != 0 - 'active' (can be settled or refunded)
222     //  amount == 0 && gambler != 0 - 'processed' (can clean storage)
223     //
224     //  NOTE: Storage cleaning is not implemented in this contract version; it will be added
225     //        with the next upgrade to prevent polluting Ethereum state with expired bets.
226 
227     // Bet placing transaction - issued by the player.
228     //  betMask         - bet outcomes bit mask for modulo <= MAX_MASK_MODULO,
229     //                    [0, betMask) for larger modulos.
230     //  modulo          - game modulo.
231     //  commitLastBlock - number of the maximum block where "commit" is still considered valid.
232     //  commit          - Keccak256 hash of some secret "reveal" random number, to be supplied
233     //                    by the fairhouse.io croupier bot in the settleBet transaction. Supplying
234     //                    "commit" ensures that "reveal" cannot be changed behind the scenes
235     //                    after placeBet have been mined.
236     //  recCode         - recommendation code. Record only the first recommendation relationship.
237     //  r, s            - components of ECDSA signature of (commitLastBlock, commit). v is
238     //                    guaranteed to always equal 27.
239     //
240     // Commit, being essentially random 256-bit number, is used as a unique bet identifier in
241     // the 'bets' mapping.
242     //
243     // Commits are signed with a block limit to ensure that they are used at most once - otherwise
244     // it would be possible for a miner to place a bet with a known commit/reveal pair and tamper
245     // with the blockhash. Croupier guarantees that commitLastBlock will always be not greater than
246     // placeBet block number plus BET_EXPIRATION_BLOCKS. See whitepaper for details.
247     function placeBet(uint betMask, uint modulo, uint commitLastBlock, uint commit, bytes32 recCode, bytes32 r, bytes32 s) external payable {
248         // Check that the bet is in 'clean' state.
249         Bet storage bet = bets[commit];
250         require (bet.gambler == address(0), "Bet should be in a 'clean' state.");
251 
252         // Validate input data ranges.
253         require (modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
254         require (msg.value >= MIN_BET && msg.value <= MAX_AMOUNT, "Amount should be within range.");
255         require (betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
256 
257         // Check that commit is valid - it has not expired and its signature is valid.
258         require (block.number <= commitLastBlock && commitLastBlock <= block.number.add(BET_EXPIRATION_BLOCKS), "Commit has expired.");
259         // bytes32 signatureHash = keccak256(abi.encodePacked(uint40(commitLastBlock), commit));
260         // require (secretSigner == ecrecover(signatureHash, 27, r, s), "ECDSA signature is not valid.");
261         require (secretSigner == ecrecover(keccak256(abi.encodePacked(uint40(commitLastBlock), commit)), 27, r, s), "ECDSA signature is not valid.");
262 
263         uint rollUnder;
264         //uint mask;
265 
266         if (modulo <= MAX_MASK_MODULO) {
267             // Small modulo games specify bet outcomes via bit mask.
268             // rollUnder is a number of 1 bits in this mask (population count).
269             // This magic looking formula is an efficient way to compute population
270             // count on EVM for numbers below 2**40.
271             rollUnder = ((betMask.mul(POPCNT_MULT)) & POPCNT_MASK).mod(POPCNT_MODULO);
272             //mask = betMask;
273             bet.mask = uint40(betMask);
274         } else {
275             // Larger modulos specify the right edge of half-open interval of
276             // winning bet outcomes.
277             require (betMask > 0 && betMask <= modulo, "High modulo range, betMask larger than modulo.");
278             rollUnder = betMask;
279         }
280 
281         // Winning amount and jackpot increase.
282         uint possibleWinAmount;
283         uint jackpotFee;
284 
285         (possibleWinAmount, jackpotFee) = getDiceWinAmount(msg.value, modulo, rollUnder);
286 
287         // Enforce max profit limit.
288         require (possibleWinAmount <= msg.value.add(maxProfit), "maxProfit limit violation.");
289 
290         // Lock funds.
291         lockedInBets = lockedInBets.add(possibleWinAmount);
292         jackpotSize = jackpotSize.add(jackpotFee);
293 
294         // Check whether contract has enough funds to process this bet.
295         require (jackpotSize.add(lockedInBets) <= address(this).balance, "Cannot afford to lose this bet.");
296 
297         // Record commit in logs.
298         emit Commit(commit);
299 
300         // Store bet parameters on blockchain.
301         bet.amount = msg.value;
302         bet.modulo = uint8(modulo);
303         bet.rollUnder = uint8(rollUnder);
304         bet.placeBlockNumber = block.number;
305         //bet.mask = uint40(mask);
306         bet.gambler = msg.sender;
307 
308         // Binding recommendation relationship
309         placeBetBindCore(msg.sender, recCode);
310     }
311 
312     // This is the method used to settle 99% of bets. To process a bet with a specific
313     // "commit", settleBet should supply a "reveal" number that would Keccak256-hash to
314     // "commit". "blockHash" is the block hash of placeBet block as seen by croupier; it
315     // is additionally asserted to prevent changing the bet outcomes on Ethereum reorgs.
316     function settleBet(uint reveal, bytes32 blockHash) external onlyCroupier {
317         uint commit = uint(keccak256(abi.encodePacked(reveal)));
318 
319         Bet storage bet = bets[commit];
320 
321         // Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
322         require (block.number > bet.placeBlockNumber, "settleBet in the same block as placeBet, or before.");
323         require (block.number <= bet.placeBlockNumber.add(BET_EXPIRATION_BLOCKS), "Blockhash can't be queried by EVM.");
324         require (blockhash(bet.placeBlockNumber) == blockHash);
325 
326         // Settle bet using reveal and blockHash as entropy sources.
327         settleBetCommon(bet, reveal, blockHash);
328     }
329 
330     // This method is used to settle a bet that was mined into an uncle block. At this
331     // point the player was shown some bet outcome, but the blockhash at placeBet height
332     // is different because of Ethereum chain reorg. We supply a full merkle proof of the
333     // placeBet transaction receipt to provide untamperable evidence that uncle block hash
334     // indeed was present on-chain at some point.
335     function settleBetUncleMerkleProof(uint reveal, uint canonicalBlockNumber) external onlyCroupier {
336         // "commit" for bet settlement can only be obtained by hashing a "reveal".
337         uint commit = uint(keccak256(abi.encodePacked(reveal)));
338 
339         Bet storage bet = bets[commit];
340 
341         // Check that canonical block hash can still be verified.
342         require (block.number <= canonicalBlockNumber.add(BET_EXPIRATION_BLOCKS), "Blockhash can't be queried by EVM.");
343 
344         // Verify placeBet receipt.
345         requireCorrectReceipt(4 + 32 + 32 + 4);
346 
347         // Reconstruct canonical & uncle block hashes from a receipt merkle proof, verify them.
348         bytes32 canonicalHash;
349         bytes32 uncleHash;
350         (canonicalHash, uncleHash) = verifyMerkleProof(commit, 4 + 32 + 32);
351         require (blockhash(canonicalBlockNumber) == canonicalHash);
352 
353         // Settle bet using reveal and uncleHash as entropy sources.
354         settleBetCommon(bet, reveal, uncleHash);
355     }
356 
357     // Common settlement code for settleBet & settleBetUncleMerkleProof.
358     function settleBetCommon(Bet storage bet, uint reveal, bytes32 entropyBlockHash) private {
359         // Fetch bet parameters into local variables (to save gas).
360         uint amount = bet.amount;
361         uint modulo = bet.modulo;
362         uint rollUnder = bet.rollUnder;
363         address gambler = bet.gambler;
364 
365         // Check that bet is in 'active' state.
366         require (amount != 0, "Bet should be in an 'active' state");
367 
368         // Move bet into 'processed' state already.
369         bet.amount = 0;
370 
371         // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
372         // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
373         // preimage is intractable), and house is unable to alter the "reveal" after
374         // placeBet have been mined (as Keccak256 collision finding is also intractable).
375         bytes32 entropy = keccak256(abi.encodePacked(reveal, entropyBlockHash));
376 
377         // Do a roll by taking a modulo of entropy. Compute winning amount.
378         uint dice = uint(entropy).mod(modulo);
379 
380         uint diceWinAmount;
381         uint _jackpotFee;
382         (diceWinAmount, _jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
383 
384         uint diceWin = 0;
385         uint jackpotWin = 0;
386 
387         // Determine dice outcome.
388         if (modulo <= MAX_MASK_MODULO) {
389             // For small modulo games, check the outcome against a bit mask.
390             if ((2 ** dice) & bet.mask != 0) {
391                 diceWin = diceWinAmount;
392             }
393 
394         } else {
395             // For larger modulos, check inclusion into half-open interval.
396             if (dice < rollUnder) {
397                 diceWin = diceWinAmount;
398             }
399 
400         }
401 
402         // Unlock the bet amount, regardless of the outcome.
403         lockedInBets = lockedInBets.sub(diceWinAmount);
404 
405         // Roll for a jackpot (if eligible).
406         if (amount >= MIN_JACKPOT_BET) {
407             // The second modulo, statistically independent from the "main" dice roll.
408             // Effectively you are playing two games at once!
409             uint jackpotRng = (uint(entropy).div(modulo)).mod(JACKPOT_MODULO);
410 
411             // Bingo!
412             if (jackpotRng == 0) {
413                 jackpotWin = jackpotSize;
414                 jackpotSize = 0;
415             }
416         }
417 
418         // Log jackpot win.
419         if (jackpotWin > 0) {
420             emit JackpotPayment(gambler, jackpotWin);
421         }
422 
423         // Settle to recommender
424         settleToRecommender(gambler, amount);
425 
426         // Send the funds to gambler.
427         sendFunds(gambler, diceWin.add(jackpotWin) == 0 ? 1 wei : diceWin.add(jackpotWin), diceWin);
428     }
429 
430     // Refund transaction - return the bet amount of a roll that was not processed in a
431     // due timeframe. Processing such blocks is not possible due to EVM limitations (see
432     // BET_EXPIRATION_BLOCKS comment above for details). In case you ever find yourself
433     // in a situation like this, just contact the fairhouse.io support, however nothing
434     // precludes you from invoking this method yourself.
435     function refundBet(uint commit) external {
436         // Check that bet is in 'active' state.
437         Bet storage bet = bets[commit];
438         uint amount = bet.amount;
439 
440         require (amount != 0, "Bet should be in an 'active' state");
441 
442         // Check that bet has already expired.
443         require (block.number > bet.placeBlockNumber.add(BET_EXPIRATION_BLOCKS), "Blockhash can't be queried by EVM.");
444 
445         // Move bet into 'processed' state, release funds.
446         bet.amount = 0;
447 
448         uint diceWinAmount;
449         uint jackpotFee;
450         (diceWinAmount, jackpotFee) = getDiceWinAmount(amount, bet.modulo, bet.rollUnder);
451 
452         lockedInBets = lockedInBets.sub(diceWinAmount);
453         jackpotSize = jackpotSize.sub(jackpotFee);
454 
455         // Send the refund.
456         sendFunds(bet.gambler, amount, amount);
457     }
458 
459     // Settle to recommender
460     function settleToRecommender(address gambler, uint amount) private {
461         // fetch player id
462         uint pid = pidXaddr[gambler];
463         Player storage _gambler = playerXpid[pid];
464         if (_gambler.recPid > 0) {
465             Player storage _recommender = playerXpid[_gambler.recPid];
466             //
467             uint houseEdge = amount.mul(HOUSE_EDGE_PERCENT).div(100);
468 
469             // If it is too small, it will not be distributed
470             if (houseEdge > HOUSE_EDGE_MINIMUM_AMOUNT) {
471 
472                 uint recFee = houseEdge.mul(RECOMMENDER_PERCENT).div(100);
473 
474                 // Send the funds to recommender.
475                 sendRecommendFunds(_recommender.addr, recFee);
476             }
477         }
478     }
479 
480     // Register a name, get recommended code
481     function registerName(string nameStr, bytes32 recCode) external payable returns(bool, uint256) {
482         // Make sure name fees paid
483         require (msg.value >= REGISTRATION_FEE, "You have to pay the name fee");
484 
485         // Filter name + condition checks
486         bytes32 name = NameFilter.nameFilter(nameStr);
487         require(pidXname[name] == 0, "Sorry that name already taken");
488 
489         // Set up address
490         address addr = msg.sender;
491 
492         // Set up our tx event data and determine if player is new or not
493         bool isNewPlayer = determinePid(addr);
494 
495         // Fetch player id
496         uint pid = pidXaddr[addr];
497         pidXname[name] = pid;
498         playerXpid[pid].name = name;
499 
500         uint recPid;
501 
502         // Must be a new player
503         if (isNewPlayer && recCode != "" && recCode != name) {
504             // Get recommender ID from recommend code
505             recPid = pidXname[recCode];
506 
507             bindRecommender(pid, recPid);
508         }
509 
510         Player storage recPlayer = playerXpid[recPid];
511         emit OnRegisterName(pid, name, addr, recPid, recPlayer.name, recPlayer.addr, msg.value, isNewPlayer, now);
512 
513         return(isNewPlayer, recPid);
514     }
515 
516     function getRegisterName(address addr) external view returns(bytes32) {
517         return (playerXpid[pidXaddr[addr]].name);
518     }
519 
520     function placeBetBindCore(address addr, bytes32 recCode) private {
521         bool isNewPlayer = determinePid(addr);
522 
523         // Must be a new player
524         if (isNewPlayer && recCode != "") {
525             // Fetch player id
526             uint pid = pidXaddr[addr];
527 
528             // recCode is not self
529             if (recCode != playerXpid[pid].name) {
530                 // Manage affiliate residuals
531                 uint recPid = pidXname[recCode];
532 
533                 // Get recommender ID from recommend code
534                 bindRecommender(pid, recPid);
535             }
536         }
537     }
538 
539     // Get the expected win amount after house edge is subtracted.
540     function getDiceWinAmount(uint amount, uint modulo, uint rollUnder) private pure returns (uint winAmount, uint jackpotFee) {
541         require (0 < rollUnder && rollUnder <= modulo, "Win probability out of range.");
542 
543         jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
544 
545         uint houseEdge = amount.mul(HOUSE_EDGE_PERCENT).div(100);
546 
547         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
548             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
549         }
550 
551         require (houseEdge.add(jackpotFee) <= amount, "Bet doesn't even cover house edge.");
552         winAmount = amount.sub(houseEdge).sub(jackpotFee).mul(modulo).div(rollUnder);
553     }
554 
555     // Helper routine to process the payment.
556     function sendFunds(address beneficiary, uint amount, uint successLogAmount) private {
557         if (beneficiary.send(amount)) {
558             emit Payment(beneficiary, successLogAmount);
559         } else {
560             emit FailedPayment(beneficiary, amount);
561         }
562     }
563 
564     function sendRecommendFunds(address beneficiary, uint amount) private {
565         if (beneficiary.send(amount)) {
566             emit RecommendPayment(beneficiary, amount);
567         } else {
568             emit FailedPayment(beneficiary, amount);
569         }
570     }
571 
572     function determinePid(address addr) private returns (bool) {
573         if (pidXaddr[addr] == 0) {
574             playerId++;
575             pidXaddr[addr] = playerId;
576             playerXpid[playerId].addr = addr;
577 
578             // set the new player bool to true
579             return (true);
580         } else {
581             return (false);
582         }
583     }
584 
585     function bindRecommender(uint256 pid, uint256 recPid) private {
586         // bind only once
587         if (recPid != 0 && playerXpid[pid].recPid == 0 && playerXpid[pid].recPid != recPid) {
588             playerXpid[pid].recPid = recPid;
589         }
590     }
591 
592     // This are some constants making O(1) population count in placeBet possible.
593     // See whitepaper for intuition and proofs behind it.
594     uint constant POPCNT_MULT = 0x0000000000002000000000100000000008000000000400000000020000000001;
595     uint constant POPCNT_MASK = 0x0001041041041041041041041041041041041041041041041041041041041041;
596     uint constant POPCNT_MODULO = 0x3F;
597 
598     // *** Merkle proofs.
599 
600     // This helpers are used to verify cryptographic proofs of placeBet inclusion into
601     // uncle blocks. They are used to prevent bet outcome changing on Ethereum reorgs without
602     // compromising the security of the smart contract. Proof data is appended to the input data
603     // in a simple prefix length format and does not adhere to the ABI.
604     // Invariants checked:
605     //  - receipt trie entry contains a (1) successful transaction (2) directed at this smart
606     //    contract (3) containing commit as a payload.
607     //  - receipt trie entry is a part of a valid merkle proof of a block header
608     //  - the block header is a part of uncle list of some block on canonical chain
609     // The implementation is optimized for gas cost and relies on the specifics of Ethereum internal data structures.
610     // Read the whitepaper for details.
611 
612     // Helper to verify a full merkle proof starting from some seedHash (usually commit). "offset" is the location of the proof
613     // beginning in the calldata.
614     function verifyMerkleProof(uint seedHash, uint offset) pure private returns (bytes32 blockHash, bytes32 uncleHash) {
615         // (Safe) assumption - nobody will write into RAM during this method invocation.
616         uint scratchBuf1;  assembly { scratchBuf1 := mload(0x40) }
617 
618         uint uncleHeaderLength; uint blobLength; uint shift; uint hashSlot;
619 
620         // Verify merkle proofs up to uncle block header. Calldata layout is:
621         //  - 2 byte big-endian slice length
622         //  - 2 byte big-endian offset to the beginning of previous slice hash within the current slice (should be zeroed)
623         //  - followed by the current slice verbatim
624         for (;; offset += blobLength) {
625             assembly { blobLength := and(calldataload(sub(offset, 30)), 0xffff) }
626             if (blobLength == 0) {
627                 // Zero slice length marks the end of uncle proof.
628                 break;
629             }
630 
631             assembly { shift := and(calldataload(sub(offset, 28)), 0xffff) }
632             require (shift + 32 <= blobLength, "Shift bounds check.");
633 
634             offset += 4;
635             assembly { hashSlot := calldataload(add(offset, shift)) }
636             require (hashSlot == 0, "Non-empty hash slot.");
637 
638             assembly {
639                 calldatacopy(scratchBuf1, offset, blobLength)
640                 mstore(add(scratchBuf1, shift), seedHash)
641                 seedHash := sha3(scratchBuf1, blobLength)
642                 uncleHeaderLength := blobLength
643             }
644         }
645 
646         // At this moment the uncle hash is known.
647         uncleHash = bytes32(seedHash);
648 
649         // Construct the uncle list of a canonical block.
650         uint scratchBuf2 = scratchBuf1 + uncleHeaderLength;
651         uint unclesLength; assembly { unclesLength := and(calldataload(sub(offset, 28)), 0xffff) }
652         uint unclesShift;  assembly { unclesShift := and(calldataload(sub(offset, 26)), 0xffff) }
653         require (unclesShift + uncleHeaderLength <= unclesLength, "Shift bounds check.");
654 
655         offset += 6;
656         assembly { calldatacopy(scratchBuf2, offset, unclesLength) }
657         memcpy(scratchBuf2 + unclesShift, scratchBuf1, uncleHeaderLength);
658 
659         assembly { seedHash := sha3(scratchBuf2, unclesLength) }
660 
661         offset += unclesLength;
662 
663         // Verify the canonical block header using the computed sha3Uncles.
664         assembly {
665             blobLength := and(calldataload(sub(offset, 30)), 0xffff)
666             shift := and(calldataload(sub(offset, 28)), 0xffff)
667         }
668         require (shift + 32 <= blobLength, "Shift bounds check.");
669 
670         offset += 4;
671         assembly { hashSlot := calldataload(add(offset, shift)) }
672         require (hashSlot == 0, "Non-empty hash slot.");
673 
674         assembly {
675             calldatacopy(scratchBuf1, offset, blobLength)
676             mstore(add(scratchBuf1, shift), seedHash)
677 
678         // At this moment the canonical block hash is known.
679             blockHash := sha3(scratchBuf1, blobLength)
680         }
681     }
682 
683     // Helper to check the placeBet receipt. "offset" is the location of the proof beginning in the calldata.
684     // RLP layout: [triePath, str([status, cumGasUsed, bloomFilter, [[address, [topics], data]])]
685     function requireCorrectReceipt(uint offset) view private {
686         uint leafHeaderByte; assembly { leafHeaderByte := byte(0, calldataload(offset)) }
687 
688         require (leafHeaderByte >= 0xf7, "Receipt leaf longer than 55 bytes.");
689         offset += leafHeaderByte - 0xf6;
690 
691         uint pathHeaderByte; assembly { pathHeaderByte := byte(0, calldataload(offset)) }
692 
693         if (pathHeaderByte <= 0x7f) {
694             offset += 1;
695 
696         } else {
697             require (pathHeaderByte >= 0x80 && pathHeaderByte <= 0xb7, "Path is an RLP string.");
698             offset += pathHeaderByte - 0x7f;
699         }
700 
701         uint receiptStringHeaderByte; assembly { receiptStringHeaderByte := byte(0, calldataload(offset)) }
702         require (receiptStringHeaderByte == 0xb9, "Receipt string is always at least 256 bytes long, but less than 64k.");
703         offset += 3;
704 
705         uint receiptHeaderByte; assembly { receiptHeaderByte := byte(0, calldataload(offset)) }
706         require (receiptHeaderByte == 0xf9, "Receipt is always at least 256 bytes long, but less than 64k.");
707         offset += 3;
708 
709         uint statusByte; assembly { statusByte := byte(0, calldataload(offset)) }
710         require (statusByte == 0x1, "Status should be success.");
711         offset += 1;
712 
713         uint cumGasHeaderByte; assembly { cumGasHeaderByte := byte(0, calldataload(offset)) }
714         if (cumGasHeaderByte <= 0x7f) {
715             offset += 1;
716 
717         } else {
718             require (cumGasHeaderByte >= 0x80 && cumGasHeaderByte <= 0xb7, "Cumulative gas is an RLP string.");
719             offset += cumGasHeaderByte - 0x7f;
720         }
721 
722         uint bloomHeaderByte; assembly { bloomHeaderByte := byte(0, calldataload(offset)) }
723         require (bloomHeaderByte == 0xb9, "Bloom filter is always 256 bytes long.");
724         offset += 256 + 3;
725 
726         uint logsListHeaderByte; assembly { logsListHeaderByte := byte(0, calldataload(offset)) }
727         require (logsListHeaderByte == 0xf8, "Logs list is less than 256 bytes long.");
728         offset += 2;
729 
730         uint logEntryHeaderByte; assembly { logEntryHeaderByte := byte(0, calldataload(offset)) }
731         require (logEntryHeaderByte == 0xf8, "Log entry is less than 256 bytes long.");
732         offset += 2;
733 
734         uint addressHeaderByte; assembly { addressHeaderByte := byte(0, calldataload(offset)) }
735         require (addressHeaderByte == 0x94, "Address is 20 bytes long.");
736 
737         uint logAddress; assembly { logAddress := and(calldataload(sub(offset, 11)), 0xffffffffffffffffffffffffffffffffffffffff) }
738         require (logAddress == uint(address(this)));
739     }
740 
741     // Memory copy.
742     function memcpy(uint dest, uint src, uint len) pure private {
743         // Full 32 byte words
744         for(; len >= 32; len -= 32) {
745             assembly { mstore(dest, mload(src)) }
746             dest += 32; src += 32;
747         }
748 
749         // Remaining bytes
750         uint mask = 256 ** (32 - len) - 1;
751         assembly {
752             let srcpart := and(mload(src), not(mask))
753             let destpart := and(mload(dest), mask)
754             mstore(dest, or(destpart, srcpart))
755         }
756     }
757 }
758 
759 /**
760  * @title SafeMath
761  * @dev Math operations with safety checks that revert on error
762  */
763 library SafeMath {
764 
765     /**
766     * @dev Multiplies two numbers, reverts on overflow.
767     */
768     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
769         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
770         // benefit is lost if 'b' is also tested.
771         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
772         if (a == 0) {
773             return 0;
774         }
775 
776         uint256 c = a * b;
777         require(c / a == b);
778 
779         return c;
780     }
781 
782     /**
783     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
784     */
785     function div(uint256 a, uint256 b) internal pure returns (uint256) {
786         require(b > 0); // Solidity only automatically asserts when dividing by 0
787         uint256 c = a / b;
788         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
789 
790         return c;
791     }
792 
793     /**
794     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
795     */
796     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
797         require(b <= a);
798         uint256 c = a - b;
799 
800         return c;
801     }
802 
803     /**
804     * @dev Adds two numbers, reverts on overflow.
805     */
806     function add(uint256 a, uint256 b) internal pure returns (uint256) {
807         uint256 c = a + b;
808         require(c >= a);
809 
810         return c;
811     }
812 
813     /**
814     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
815     * reverts when dividing by zero.
816     */
817     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
818         require(b != 0);
819         return a % b;
820     }
821 }
822 
823 library NameFilter {
824 
825     /**
826      * filters name strings
827      * -converts uppercase to lower case.
828      * -makes sure it does not start/end with a space
829      * -cannot be only numbers
830      * -cannot start with 0x
831      * -restricts characters to A-Z, a-z, 0-9.
832      * @return reprocessed string in bytes32 format
833      */
834     function nameFilter(string _input)
835     internal
836     pure
837     returns(bytes32)
838     {
839         bytes memory _temp = bytes(_input);
840         uint256 _length = _temp.length;
841 
842         //sorry limited to 32 characters
843         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
844         // make sure it doesnt start with or end with space
845         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
846         // make sure first two characters are not 0x
847         if (_temp[0] == 0x30)
848         {
849             require(_temp[1] != 0x78, "string cannot start with 0x");
850             require(_temp[1] != 0x58, "string cannot start with 0X");
851         }
852 
853         // create a bool to track if we have a non number character
854         bool _hasNonNumber;
855 
856         // convert & check
857         for (uint256 i = 0; i < _length; i++)
858         {
859             // if its uppercase A-Z
860             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
861             {
862                 // convert to lower case a-z
863                 _temp[i] = byte(uint(_temp[i]) + 32);
864 
865                 // we have a non number
866                 if (_hasNonNumber == false)
867                     _hasNonNumber = true;
868             } else {
869                 require
870                 (
871                 // require character is a lowercase a-z
872                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
873                     // or 0-9
874                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
875                     "string contains invalid characters"
876                 );
877                 // make sure theres not 2x spaces in a row
878                 if (_temp[i] == 0x20)
879                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
880 
881                 // see if we have a character other than a number
882                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
883                     _hasNonNumber = true;
884             }
885         }
886 
887         require(_hasNonNumber == true, "string cannot be only numbers");
888 
889         bytes32 _ret;
890         assembly {
891             _ret := mload(add(_temp, 32))
892         }
893         return (_ret);
894     }
895 }