1 pragma solidity ^0.5.0;
2 
3 // * playeth.net - fair games that pay Ether. Version 1.
4 //
5 // * Uses hybrid commit-reveal + block hash random number generation that is immune
6 //   to tampering by players, house and miners. Apart from being fully transparent,
7 //   this also allows arbitrarily high bets.
8 //
9 // * Refer to https://playeth.net/whitepaper.pdf for detailed description and proofs.
10 contract PlayEth{
11 
12     // Each bet is deducted 1% in favour of the house, but no less than some minimum.
13     uint constant HOUSE_EDGE_PERCENT = 1;
14     uint constant HOUSE_EDGE_MINIMUM_AMOUNT = 0.0003 ether;
15 
16     // Bets lower than this amount do not participate in jackpot rolls (and are not deducted JACKPOT_FEE).
17     uint constant MIN_JACKPOT_BET = 0.1 ether;
18 
19     // Chance to win jackpot (currently 0.1%) and fee deducted into jackpot fund.
20     uint constant JACKPOT_MODULO = 1000;
21     uint constant JACKPOT_FEE = 0.001 ether;
22 
23     // There is minimum and maximum bets.
24     uint constant MIN_BET = 0.01 ether;
25     uint constant MAX_AMOUNT = 300000 ether;
26 
27     // Modulo is a number of equiprobable outcomes in a game:
28     //  - 2 for coin flip
29     //  - 6 for dice
30     //  - 6*6 = 36 for double dice
31     //  - 100 for etheroll
32     //  - 37 for roulette
33     //  etc.
34     // It's called so because 256-bit entropy is treated like a huge integer and
35     // the remainder of its division by modulo is considered bet outcome.
36     uint constant MAX_MODULO = 100;
37     
38     // The specific value is dictated by the fact that 256-bit intermediate
39     // multiplication result allows implementing population count efficiently
40     // for numbers that are up to 42 bits, and 40 is the highest multiple of
41     // eight below 42.
42     uint constant MAX_MASK_MODULO = 40;
43 
44     // This is a check on bet mask overflow.
45     uint constant MAX_BET_MASK = 2 ** MAX_MASK_MODULO;
46 
47     // EVM BLOCKHASH opcode can query no further than 256 blocks into the
48     // past. Given that settleBet uses block hash of placeBet as one of
49     // complementary entropy sources, we cannot process bets older than this
50     // threshold. On rare occasions playeth.net croupier may fail to invoke
51     // settleBet in this timespan due to technical issues or extreme Ethereum
52     // congestion; such bets can be refunded via invoking refundBet.
53     uint constant BET_EXPIRATION_BLOCKS = 250;
54 
55     // Some deliberately invalid address to initialize the secret signer with.
56     // Forces maintainers to invoke setSecretSigner before processing any bets.
57     address constant DUMMY_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
58 
59     // Standard contract ownership transfer.
60     address payable public owner;
61     address payable private nextOwner;
62 
63     // Adjustable max bet profit. Used to cap bets against dynamic odds.
64     uint public maxProfit;
65 
66     // The address corresponding to a private key used to sign placeBet commits.
67     address public secretSigner;
68 
69     // Accumulated jackpot fund.
70     uint128 public jackpotSize;
71 
72     // Funds that are locked in potentially winning bets. Prevents contract from
73     // committing to bets it cannot pay out.
74     uint128 public lockedInBets;
75 
76     // A structure representing a single bet.
77     struct Bet {
78         // Wager amount in wei.
79         uint amount;
80         // Modulo of a game.
81         uint8 modulo;
82         // Number of winning outcomes, used to compute winning payment (* modulo/rollUnder),
83         // and used instead of mask for games with modulo > MAX_MASK_MODULO.
84         uint8 rollUnder;
85         // Block number of placeBet tx.
86         uint40 placeBlockNumber;
87         // Bit mask representing winning bet outcomes (see MAX_MASK_MODULO comment).
88         uint40 mask;
89         // Address of a gambler, used to pay out winning bets.
90         address payable gambler;
91     }
92 
93     // Mapping from commits to all currently active & processed bets.
94     mapping (uint => Bet) bets;
95 
96     // Croupier account.
97     address public croupier;
98 
99     // Events that are issued to make statistic recovery easier.
100     event FailedPayment(address indexed beneficiary, uint amount);
101     event Payment(address indexed beneficiary, uint amount);
102     event JackpotPayment(address indexed beneficiary, uint amount);
103 
104     // This event is emitted in placeBet to record commit in the logs.
105     event Commit(uint commit);
106 
107     // Constructor. Deliberately does not take any parameters.
108     constructor () public {
109         owner = msg.sender;
110         secretSigner = DUMMY_ADDRESS;
111         croupier = DUMMY_ADDRESS;
112     }
113 
114     // Standard modifier on methods invokable only by contract owner.
115     modifier onlyOwner {
116         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
117         _;
118     }
119 
120     // Standard modifier on methods invokable only by contract owner.
121     modifier onlyCroupier {
122         require (msg.sender == croupier, "OnlyCroupier methods called by non-croupier.");
123         _;
124     }
125 
126     // Standard contract ownership transfer implementation,
127     function approveNextOwner(address payable _nextOwner) external onlyOwner {
128         require (_nextOwner != owner, "Cannot approve current owner.");
129         nextOwner = _nextOwner;
130     }
131 
132     function acceptNextOwner() external {
133         require (msg.sender == nextOwner, "Can only accept preapproved new owner.");
134         owner = nextOwner;
135     }
136 
137     // Fallback function deliberately left empty. It's primary use case
138     // is to top up the bank roll.
139     function () external payable {
140     }
141 
142     // See comment for "secretSigner" variable.
143     function setSecretSigner(address newSecretSigner) external onlyOwner {
144         secretSigner = newSecretSigner;
145     }
146 
147     // Change the croupier address.
148     function setCroupier(address newCroupier) external onlyOwner {
149         croupier = newCroupier;
150     }
151 
152     // Change max bet reward. Setting this to zero effectively disables betting.
153     function setMaxProfit(uint _maxProfit) public onlyOwner {
154         require (_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
155         maxProfit = _maxProfit;
156     }
157 
158     // This function is used to bump up the jackpot fund. Cannot be used to lower it.
159     function increaseJackpot(uint increaseAmount) external onlyOwner {
160         require (increaseAmount <= address(this).balance, "Increase amount larger than balance.");
161         require (jackpotSize + lockedInBets + increaseAmount <= address(this).balance, "Not enough funds.");
162         jackpotSize += uint128(increaseAmount);
163     }
164 
165     // Funds withdrawal to cover costs of playeth.net operation.
166     function withdrawFunds(address payable beneficiary, uint withdrawAmount) external onlyOwner {
167         require (withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
168         require (jackpotSize + lockedInBets + withdrawAmount <= address(this).balance, "Not enough funds.");
169         sendFunds(beneficiary, withdrawAmount, withdrawAmount);
170     }
171 
172     // Contract may be destroyed only when there are no ongoing bets,
173     // either settled or refunded. All funds are transferred to contract owner.
174     function kill() external onlyOwner {
175         require (lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
176         selfdestruct(owner);
177     }
178 
179     /// *** Betting logic
180 
181     // Bet states:
182     //  amount == 0 && gambler == 0 - 'clean' (can place a bet)
183     //  amount != 0 && gambler != 0 - 'active' (can be settled or refunded)
184     //  amount == 0 && gambler != 0 - 'processed' (can clean storage)
185     //
186     //  NOTE: Storage cleaning is not implemented in this contract version; it will be added
187     //        with the next upgrade to prevent polluting Ethereum state with expired bets.
188 
189     // Bet placing transaction - issued by the player.
190     //  betMask         - bet outcomes bit mask for modulo <= MAX_MASK_MODULO,
191     //                    [0, betMask) for larger modulos.
192     //  modulo          - game modulo.
193     //  commitLastBlock - number of the maximum block where "commit" is still considered valid.
194     //  commit          - Keccak256 hash of some secret "reveal" random number, to be supplied
195     //                    by the playeth.net croupier bot in the settleBet transaction. Supplying
196     //                    "commit" ensures that "reveal" cannot be changed behind the scenes
197     //                    after placeBet have been mined.
198     //  r, s            - components of ECDSA signature of (commitLastBlock, commit). v is
199     //                    guaranteed to always equal 27.
200     //
201     // Commit, being essentially random 256-bit number, is used as a unique bet identifier in
202     // the 'bets' mapping.
203     //
204     // Commits are signed with a block limit to ensure that they are used at most once - otherwise
205     // it would be possible for a miner to place a bet with a known commit/reveal pair and tamper
206     // with the blockhash. Croupier guarantees that commitLastBlock will always be not greater than
207     // placeBet block number plus BET_EXPIRATION_BLOCKS. See whitepaper for details.
208     function placeBet(uint betMask, uint modulo, uint commitLastBlock, uint commit, uint8 v, bytes32 r, bytes32 s) external payable {
209         // Check that the bet is in 'clean' state.
210         Bet storage bet = bets[commit];
211         require (bet.gambler == address(0), "Bet should be in a 'clean' state.");
212 
213         // Validate input data ranges.
214         uint amount = msg.value;
215         require (modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
216         require (amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
217         require (betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
218 
219         // Check that commit is valid - it has not expired and its signature is valid.
220         require (block.number <= commitLastBlock, "Commit has expired.");
221         bytes32 signatureHash = keccak256(abi.encodePacked(commitLastBlock, commit));
222         require (secretSigner == ecrecover(signatureHash, v, r, s), "ECDSA signature is not valid.");
223 
224         uint rollUnder;
225         uint mask;
226 
227         if (modulo <= MAX_MASK_MODULO) {
228             // Small modulo games specify bet outcomes via bit mask.
229             // rollUnder is a number of 1 bits in this mask (population count).
230             // This magic looking formula is an efficient way to compute population
231             // count on EVM for numbers below 2**40. For detailed proof consult
232             // the playeth.net whitepaper.
233             rollUnder = ((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
234             mask = betMask;
235         } else {
236             // Larger modulos specify the right edge of half-open interval of
237             // winning bet outcomes.
238             require (betMask > 0 && betMask <= modulo, "High modulo range, betMask larger than modulo.");
239             rollUnder = betMask;
240         }
241 
242         // Winning amount and jackpot increase.
243         uint possibleWinAmount;
244         uint jackpotFee;
245 
246         (possibleWinAmount, jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
247 
248         // Enforce max profit limit.
249         require (possibleWinAmount <= amount + maxProfit, "maxProfit limit violation.");
250 
251         // Lock funds.
252         lockedInBets += uint128(possibleWinAmount);
253         jackpotSize += uint128(jackpotFee);
254 
255         // Check whether contract has enough funds to process this bet.
256         require (jackpotSize + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
257 
258         // Record commit in logs.
259         emit Commit(commit);
260 
261         // Store bet parameters on blockchain.
262         bet.amount = amount;
263         bet.modulo = uint8(modulo);
264         bet.rollUnder = uint8(rollUnder);
265         bet.placeBlockNumber = uint40(block.number);
266         bet.mask = uint40(mask);
267         bet.gambler = msg.sender;
268     }
269 
270     // This is the method used to settle 99% of bets. To process a bet with a specific
271     // "commit", settleBet should supply a "reveal" number that would Keccak256-hash to
272     // "commit". "blockHash" is the block hash of placeBet block as seen by croupier; it
273     // is additionally asserted to prevent changing the bet outcomes on Ethereum reorgs.
274     function settleBet(uint reveal, bytes32 blockHash) external onlyCroupier {
275         uint commit = uint(keccak256(abi.encodePacked(reveal)));
276 
277         Bet storage bet = bets[commit];
278         uint placeBlockNumber = bet.placeBlockNumber;
279 
280         // Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
281         require (block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
282         require (block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
283         require (blockhash(placeBlockNumber) == blockHash);
284 
285         // Settle bet using reveal and blockHash as entropy sources.
286         settleBetCommon(bet, reveal, blockHash);
287     }
288 
289     // This method is used to settle a bet that was mined into an uncle block. At this
290     // point the player was shown some bet outcome, but the blockhash at placeBet height
291     // is different because of Ethereum chain reorg. We supply a full merkle proof of the
292     // placeBet transaction receipt to provide untamperable evidence that uncle block hash
293     // indeed was present on-chain at some point.
294     function settleBetUncleMerkleProof(uint reveal, uint40 canonicalBlockNumber) external onlyCroupier {
295         // "commit" for bet settlement can only be obtained by hashing a "reveal".
296         uint commit = uint(keccak256(abi.encodePacked(reveal)));
297 
298         Bet storage bet = bets[commit];
299 
300         // Check that canonical block hash can still be verified.
301         require (block.number <= canonicalBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
302 
303         // Verify placeBet receipt.
304         requireCorrectReceipt(4 + 32 + 32 + 4);
305 
306         // Reconstruct canonical & uncle block hashes from a receipt merkle proof, verify them.
307         bytes32 canonicalHash;
308         bytes32 uncleHash;
309         (canonicalHash, uncleHash) = verifyMerkleProof(commit, 4 + 32 + 32);
310         require (blockhash(canonicalBlockNumber) == canonicalHash);
311 
312         // Settle bet using reveal and uncleHash as entropy sources.
313         settleBetCommon(bet, reveal, uncleHash);
314     }
315 
316     // Common settlement code for settleBet & settleBetUncleMerkleProof.
317     function settleBetCommon(Bet storage bet, uint reveal, bytes32 entropyBlockHash) private {
318         // Fetch bet parameters into local variables (to save gas).
319         uint amount = bet.amount;
320         uint modulo = bet.modulo;
321         uint rollUnder = bet.rollUnder;
322         address payable gambler = bet.gambler;
323 
324         // Check that bet is in 'active' state.
325         require (amount != 0, "Bet should be in an 'active' state");
326 
327         // Move bet into 'processed' state already.
328         bet.amount = 0;
329 
330         // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
331         // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
332         // preimage is intractable), and house is unable to alter the "reveal" after
333         // placeBet have been mined (as Keccak256 collision finding is also intractable).
334         bytes32 entropy = keccak256(abi.encodePacked(reveal, entropyBlockHash));
335 
336         // Do a roll by taking a modulo of entropy. Compute winning amount.
337         uint dice = uint(entropy) % modulo;
338 
339         uint diceWinAmount;
340         uint _jackpotFee;
341         (diceWinAmount, _jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
342 
343         uint diceWin = 0;
344         uint jackpotWin = 0;
345 
346         // Determine dice outcome.
347         if (modulo <= MAX_MASK_MODULO) {
348             // For small modulo games, check the outcome against a bit mask.
349             if ((2 ** dice) & bet.mask != 0) {
350                 diceWin = diceWinAmount;
351             }
352 
353         } else {
354             // For larger modulos, check inclusion into half-open interval.
355             if (dice < rollUnder) {
356                 diceWin = diceWinAmount;
357             }
358 
359         }
360 
361         // Unlock the bet amount, regardless of the outcome.
362         lockedInBets -= uint128(diceWinAmount);
363 
364         // Roll for a jackpot (if eligible).
365         if (amount >= MIN_JACKPOT_BET) {
366             // The second modulo, statistically independent from the "main" dice roll.
367             // Effectively you are playing two games at once!
368             uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;
369 
370             // Bingo!
371             if (jackpotRng == 0) {
372                 jackpotWin = jackpotSize;
373                 jackpotSize = 0;
374             }
375         }
376 
377         // Log jackpot win.
378         if (jackpotWin > 0) {
379             emit JackpotPayment(gambler, jackpotWin);
380         }
381 
382         // Send the funds to gambler.
383         sendFunds(gambler, diceWin + jackpotWin == 0 ? 1 wei : diceWin + jackpotWin, diceWin);
384     }
385 
386     // Refund transaction - return the bet amount of a roll that was not processed in a
387     // due timeframe. Processing such blocks is not possible due to EVM limitations (see
388     // BET_EXPIRATION_BLOCKS comment above for details). In case you ever find yourself
389     // in a situation like this, just contact the playeth.net support, however nothing
390     // precludes you from invoking this method yourself.
391     function refundBet(uint commit) external {
392         // Check that bet is in 'active' state.
393         Bet storage bet = bets[commit];
394         uint amount = bet.amount;
395 
396         require (amount != 0, "Bet should be in an 'active' state");
397 
398         // Check that bet has already expired.
399         require (block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
400 
401         // Move bet into 'processed' state, release funds.
402         bet.amount = 0;
403 
404         uint diceWinAmount;
405         uint jackpotFee;
406         (diceWinAmount, jackpotFee) = getDiceWinAmount(amount, bet.modulo, bet.rollUnder);
407 
408         lockedInBets -= uint128(diceWinAmount);
409         jackpotSize -= uint128(jackpotFee);
410 
411         // Send the refund.
412         sendFunds(bet.gambler, amount, amount);
413     }
414 
415     // Get the expected win amount after house edge is subtracted.
416     function getDiceWinAmount(uint amount, uint modulo, uint rollUnder) private pure returns (uint winAmount, uint jackpotFee) {
417         require (0 < rollUnder && rollUnder <= modulo, "Win probability out of range.");
418 
419         jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
420 
421         uint houseEdge = amount * HOUSE_EDGE_PERCENT / 100;
422 
423         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
424             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
425         }
426 
427         require (houseEdge + jackpotFee <= amount, "Bet doesn't even cover house edge.");
428         winAmount = (amount - houseEdge - jackpotFee) * modulo / rollUnder;
429     }
430 
431     // Helper routine to process the payment.
432     function sendFunds(address payable beneficiary, uint amount, uint successLogAmount) private {
433         if (beneficiary.send(amount)) {
434             emit Payment(beneficiary, successLogAmount);
435         } else {
436             emit FailedPayment(beneficiary, amount);
437         }
438     }
439 
440     // This are some constants making O(1) population count in placeBet possible.
441     // See whitepaper for intuition and proofs behind it.
442     uint constant POPCNT_MULT = 0x0000000000002000000000100000000008000000000400000000020000000001;
443     uint constant POPCNT_MASK = 0x0001041041041041041041041041041041041041041041041041041041041041;
444     uint constant POPCNT_MODULO = 0x3F;
445     
446     // Helper to verify a full merkle proof starting from some seedHash (usually commit). "offset" is the location of the proof
447     // beginning in the calldata.
448     function verifyMerkleProof(uint seedHash, uint offset) pure private returns (bytes32 blockHash, bytes32 uncleHash) {
449         // (Safe) assumption - nobody will write into RAM during this method invocation.
450         uint scratchBuf1;  assembly { scratchBuf1 := mload(0x40) }
451 
452         uint uncleHeaderLength; uint blobLength; uint shift; uint hashSlot;
453 
454         // Verify merkle proofs up to uncle block header. Calldata layout is:
455         for (;; offset += blobLength) {
456             assembly { blobLength := and(calldataload(sub(offset, 30)), 0xffff) }
457             if (blobLength == 0) {
458                 // Zero slice length marks the end of uncle proof.
459                 break;
460             }
461 
462             assembly { shift := and(calldataload(sub(offset, 28)), 0xffff) }
463             require (shift + 32 <= blobLength, "Shift bounds check.");
464 
465             offset += 4;
466             assembly { hashSlot := calldataload(add(offset, shift)) }
467             require (hashSlot == 0, "Non-empty hash slot.");
468 
469             assembly {
470                 calldatacopy(scratchBuf1, offset, blobLength)
471                 mstore(add(scratchBuf1, shift), seedHash)
472                 seedHash := keccak256(scratchBuf1, blobLength)
473                 uncleHeaderLength := blobLength
474             }
475         }
476 
477         // At this moment the uncle hash is known.
478         uncleHash = bytes32(seedHash);
479 
480         // Construct the uncle list of a canonical block.
481         uint scratchBuf2 = scratchBuf1 + uncleHeaderLength;
482         uint unclesLength; assembly { unclesLength := and(calldataload(sub(offset, 28)), 0xffff) }
483         uint unclesShift;  assembly { unclesShift := and(calldataload(sub(offset, 26)), 0xffff) }
484         require (unclesShift + uncleHeaderLength <= unclesLength, "Shift bounds check.");
485 
486         offset += 6;
487         assembly { calldatacopy(scratchBuf2, offset, unclesLength) }
488         memcpy(scratchBuf2 + unclesShift, scratchBuf1, uncleHeaderLength);
489 
490         assembly { seedHash := keccak256(scratchBuf2, unclesLength) }
491 
492         offset += unclesLength;
493 
494         // Verify the canonical block header using the computed sha3Uncles.
495         assembly {
496             blobLength := and(calldataload(sub(offset, 30)), 0xffff)
497             shift := and(calldataload(sub(offset, 28)), 0xffff)
498         }
499         require (shift + 32 <= blobLength, "Shift bounds check.");
500 
501         offset += 4;
502         assembly { hashSlot := calldataload(add(offset, shift)) }
503         require (hashSlot == 0, "Non-empty hash slot.");
504 
505         assembly {
506             calldatacopy(scratchBuf1, offset, blobLength)
507             mstore(add(scratchBuf1, shift), seedHash)
508 
509         // At this moment the canonical block hash is known.
510             blockHash := keccak256(scratchBuf1, blobLength)
511         }
512     }
513 
514     // Helper to check the placeBet receipt. "offset" is the location of the proof beginning in the calldata.
515     function requireCorrectReceipt(uint offset) view private {
516         uint leafHeaderByte; assembly { leafHeaderByte := byte(0, calldataload(offset)) }
517 
518         require (leafHeaderByte >= 0xf7, "Receipt leaf longer than 55 bytes.");
519         offset += leafHeaderByte - 0xf6;
520 
521         uint pathHeaderByte; assembly { pathHeaderByte := byte(0, calldataload(offset)) }
522 
523         if (pathHeaderByte <= 0x7f) {
524             offset += 1;
525 
526         } else {
527             require (pathHeaderByte >= 0x80 && pathHeaderByte <= 0xb7, "Path is an RLP string.");
528             offset += pathHeaderByte - 0x7f;
529         }
530 
531         uint receiptStringHeaderByte; assembly { receiptStringHeaderByte := byte(0, calldataload(offset)) }
532         require (receiptStringHeaderByte == 0xb9, "Receipt string is always at least 256 bytes long, but less than 64k.");
533         offset += 3;
534 
535         uint receiptHeaderByte; assembly { receiptHeaderByte := byte(0, calldataload(offset)) }
536         require (receiptHeaderByte == 0xf9, "Receipt is always at least 256 bytes long, but less than 64k.");
537         offset += 3;
538 
539         uint statusByte; assembly { statusByte := byte(0, calldataload(offset)) }
540         require (statusByte == 0x1, "Status should be success.");
541         offset += 1;
542 
543         uint cumGasHeaderByte; assembly { cumGasHeaderByte := byte(0, calldataload(offset)) }
544         if (cumGasHeaderByte <= 0x7f) {
545             offset += 1;
546 
547         } else {
548             require (cumGasHeaderByte >= 0x80 && cumGasHeaderByte <= 0xb7, "Cumulative gas is an RLP string.");
549             offset += cumGasHeaderByte - 0x7f;
550         }
551 
552         uint bloomHeaderByte; assembly { bloomHeaderByte := byte(0, calldataload(offset)) }
553         require (bloomHeaderByte == 0xb9, "Bloom filter is always 256 bytes long.");
554         offset += 256 + 3;
555 
556         uint logsListHeaderByte; assembly { logsListHeaderByte := byte(0, calldataload(offset)) }
557         require (logsListHeaderByte == 0xf8, "Logs list is less than 256 bytes long.");
558         offset += 2;
559 
560         uint logEntryHeaderByte; assembly { logEntryHeaderByte := byte(0, calldataload(offset)) }
561         require (logEntryHeaderByte == 0xf8, "Log entry is less than 256 bytes long.");
562         offset += 2;
563 
564         uint addressHeaderByte; assembly { addressHeaderByte := byte(0, calldataload(offset)) }
565         require (addressHeaderByte == 0x94, "Address is 20 bytes long.");
566 
567         uint logAddress; assembly { logAddress := and(calldataload(sub(offset, 11)), 0xffffffffffffffffffffffffffffffffffffffff) }
568         require (logAddress == uint(address(this)));
569     }
570 
571     // Memory copy.
572     function memcpy(uint dest, uint src, uint len) pure private {
573         // Full 32 byte words
574         for(; len >= 32; len -= 32) {
575             assembly { mstore(dest, mload(src)) }
576             dest += 32; src += 32;
577         }
578 
579         // Remaining bytes
580         uint mask = 256 ** (32 - len) - 1;
581         assembly {
582             let srcpart := and(mload(src), not(mask))
583             let destpart := and(mload(dest), mask)
584             mstore(dest, or(destpart, srcpart))
585         }
586     }
587 }