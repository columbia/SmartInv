1 pragma solidity ^0.4.19;
2 
3 contract Limitless {
4 
5     // Each bet is deducted 1% in favour of the house, but no less than some minimum.
6     // The lower bound is dictated by gas costs of the settleBet transaction, providing
7     // headroom for up to 10 Gwei prices.
8     uint constant HOUSE_EDGE_PERCENT = 1;
9     uint constant HOUSE_EDGE_MINIMUM_AMOUNT = 0.0003 ether;
10 
11     // Bets lower than this amount do not participate in jackpot rolls (and are
12     // not deducted JACKPOT_FEE).
13     uint constant MIN_JACKPOT_BET = 0.1 ether;
14 
15     // Chance to win jackpot (currently 0.1%) and fee deducted into jackpot fund.
16     uint constant JACKPOT_MODULO = 1000;
17     uint constant JACKPOT_FEE = 0.001 ether;
18 
19     // There is minimum and maximum bets.
20     uint constant MIN_BET = 0.01 ether;
21     uint constant MAX_AMOUNT = 300000 ether;
22 
23     // Modulo is a number of equiprobable outcomes in a game:
24     //  - 2 for coin flip
25     //  - 6 for dice
26     //  - 6*6 = 36 for double dice
27     //  - 100 for etheroll
28     //  - 37 for roulette
29     //  etc.
30     // It's called so because 256-bit entropy is treated like a huge integer and
31     // the remainder of its division by modulo is considered bet outcome.
32     uint constant MAX_MODULO = 100;
33 
34     // For modulos below this threshold rolls are checked against a bit mask,
35     // thus allowing betting on any combination of outcomes. For example, given
36     // modulo 6 for dice, 101000 mask (base-2, big endian) means betting on
37     // 4 and 6; for games with modulos higher than threshold (Etheroll), a simple
38     // limit is used, allowing betting on any outcome in [0, N) range.
39     //
40     // The specific value is dictated by the fact that 256-bit intermediate
41     // multiplication result allows implementing population count efficiently
42     // for numbers that are up to 42 bits, and 40 is the highest multiple of
43     // eight below 42.
44     uint constant MAX_MASK_MODULO = 40;
45 
46     // This is a check on bet mask overflow.
47     uint constant MAX_BET_MASK = 2 ** MAX_MASK_MODULO;
48 
49     // EVM BLOCKHASH opcode can query no further than 256 blocks into the
50     // past. Given that settleBet uses block hash of placeBet as one of
51     // complementary entropy sources, we cannot process bets older than this
52     // threshold. On rare occasions dice2.win croupier may fail to invoke
53     // settleBet in this timespan due to technical issues or extreme Ethereum
54     // congestion; such bets can be refunded via invoking refundBet.
55     uint constant BET_EXPIRATION_BLOCKS = 250;
56 
57     // Some deliberately invalid address to initialize the secret signer with.
58     // Forces maintainers to invoke setSecretSigner before processing any bets.
59     address constant DUMMY_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
60 
61     // Standard contract ownership transfer.
62     address public owner;
63     address private nextOwner;
64 
65     // Adjustable max bet profit. Used to cap bets against dynamic odds.
66     uint public maxProfit;
67 
68     // The address corresponding to a private key used to sign placeBet commits.
69     address public secretSigner;
70 
71     // Accumulated jackpot fund.
72     uint128 public jackpotSize;
73 
74     // Funds that are locked in potentially winning bets. Prevents contract from
75     // committing to bets it cannot pay out.
76     uint128 public lockedInBets;
77 
78     // A structure representing a single bet.
79     struct Bet {
80         // Wager amount in wei.
81         uint amount;
82         // Modulo of a game.
83         uint8 modulo;
84         // Number of winning outcomes, used to compute winning payment (* modulo/rollUnder),
85         // and used instead of mask for games with modulo > MAX_MASK_MODULO.
86         uint8 rollUnder;
87         // Block number of placeBet tx.
88         uint40 placeBlockNumber;
89         // Bit mask representing winning bet outcomes (see MAX_MASK_MODULO comment).
90         uint40 mask;
91         // Address of a gambler, used to pay out winning bets.
92         address gambler;
93     }
94 
95     // Mapping from commits to all currently active & processed bets.
96     mapping (uint => Bet) bets;
97 
98     // Croupier account.
99     address public croupier;
100 
101     // Events that are issued to make statistic recovery easier.
102     event FailedPayment(address indexed beneficiary, uint amount);
103     event Payment(address indexed beneficiary, uint amount);
104     event JackpotPayment(address indexed beneficiary, uint amount);
105 
106     // This event is emitted in placeBet to record commit in the logs.
107     event Commit(uint commit);
108 
109     constructor() public {
110         owner = msg.sender;
111         secretSigner = DUMMY_ADDRESS;
112         croupier = DUMMY_ADDRESS;
113     }
114 
115     // Standard modifier on methods invokable only by contract owner.
116     modifier onlyOwner {
117         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
118         _;
119     }
120 
121     // Standard modifier on methods invokable only by contract owner.
122     modifier onlyCroupier {
123         require (msg.sender == croupier, "OnlyCroupier methods called by non-croupier.");
124         _;
125     }
126 
127     // Standard contract ownership transfer implementation,
128     function approveNextOwner(address _nextOwner) external onlyOwner {
129         require (_nextOwner != owner, "Cannot approve current owner.");
130         nextOwner = _nextOwner;
131     }
132 
133     function acceptNextOwner() external {
134         require (msg.sender == nextOwner, "Can only accept preapproved new owner.");
135         owner = nextOwner;
136     }
137 
138     // Fallback function deliberately left empty. It's primary use case
139     // is to top up the bank roll.
140     function () public payable {
141     }
142 
143     // See comment for "secretSigner" variable.
144     function setSecretSigner(address newSecretSigner) external onlyOwner {
145         secretSigner = newSecretSigner;
146     }
147 
148     // Change the croupier address.
149     function setCroupier(address newCroupier) external onlyOwner {
150         croupier = newCroupier;
151     }
152 
153     // Change max bet reward. Setting this to zero effectively disables betting.
154     function setMaxProfit(uint _maxProfit) public onlyOwner {
155         require (_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
156         maxProfit = _maxProfit;
157     }
158 
159     // This function is used to bump up the jackpot fund. Cannot be used to lower it.
160     function increaseJackpot(uint increaseAmount) external onlyOwner {
161         require (increaseAmount <= address(this).balance, "Increase amount larger than balance.");
162         require (jackpotSize + lockedInBets + increaseAmount <= address(this).balance, "Not enough funds.");
163         jackpotSize += uint128(increaseAmount);
164     }
165 
166     // Funds withdrawal to cover costs of dice2.win operation.
167     function withdrawFunds(address beneficiary, uint withdrawAmount) external onlyOwner {
168         require (withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
169         require (jackpotSize + lockedInBets + withdrawAmount <= address(this).balance, "Not enough funds.");
170         sendFunds(beneficiary, withdrawAmount, withdrawAmount);
171     }
172 
173     // Contract may be destroyed only when there are no ongoing bets,
174     // either settled or refunded. All funds are transferred to contract owner.
175     function kill() external onlyOwner {
176         require (lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
177         selfdestruct(owner);
178     }
179 
180     // Bet states:
181     //  amount == 0 && gambler == 0 - 'clean' (can place a bet)
182     //  amount != 0 && gambler != 0 - 'active' (can be settled or refunded)
183     //  amount == 0 && gambler != 0 - 'processed' (can clean storage)
184     //
185     //  NOTE: Storage cleaning is not implemented in this contract version; it will be added
186     //        with the next upgrade to prevent polluting Ethereum state with expired bets.
187 
188     // Bet placing transaction - issued by the player.
189     //  betMask         - bet outcomes bit mask for modulo <= MAX_MASK_MODULO,
190     //                    [0, betMask) for larger modulos.
191     //  modulo          - game modulo.
192     //  commitLastBlock - number of the maximum block where "commit" is still considered valid.
193     //  commit          - Keccak256 hash of some secret "reveal" random number, to be supplied
194     //                    by the dice2.win croupier bot in the settleBet transaction. Supplying
195     //                    "commit" ensures that "reveal" cannot be changed behind the scenes
196     //                    after placeBet have been mined.
197     //  r, s            - components of ECDSA signature of (commitLastBlock, commit). v is
198     //                    guaranteed to always equal 27.
199     //
200     // Commit, being essentially random 256-bit number, is used as a unique bet identifier in
201     // the 'bets' mapping.
202     //
203     // Commits are signed with a block limit to ensure that they are used at most once - otherwise
204     // it would be possible for a miner to place a bet with a known commit/reveal pair and tamper
205     // with the blockhash. Croupier guarantees that commitLastBlock will always be not greater than
206     // placeBet block number plus BET_EXPIRATION_BLOCKS. See whitepaper for details.
207     function placeBet(uint betMask, uint modulo, uint commitLastBlock, uint commit, bytes32 r, bytes32 s) external payable {
208 
209         // Check that the bet is in 'clean' state.
210         Bet storage bet = bets[commit];
211         require (bet.gambler == address(0), "Bet should be in a 'clean' state.");
212 
213         // Validate input data ranges.
214         uint amount = msg.value;
215         require (modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
216         require (amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
217 
218         require (betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
219 
220         // Check that commit is valid - it has not expired and its signature is valid.
221         require (block.number <= commitLastBlock, "Commit has expired.");
222         bytes32 signatureHash = keccak256(abi.encodePacked(uint40(commitLastBlock), commit));
223         require (secretSigner == ecrecover(signatureHash, 27, r, s), "ECDSA signature is not valid.");
224 
225         uint rollUnder;
226         uint mask;
227 
228         if (modulo <= MAX_MASK_MODULO) {
229             rollUnder = ((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
230             mask = betMask;
231         } else {
232             require (betMask > 0 && betMask <= modulo, "High modulo range, betMask larger than modulo.");
233             rollUnder = betMask;
234         }
235 
236         // Winning amount and jackpot increase.
237         uint possibleWinAmount;
238         uint jackpotFee;
239 
240         (possibleWinAmount, jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
241 
242         // Enforce max profit limit.
243         require (possibleWinAmount <= amount + maxProfit, "maxProfit limit violation.");
244 
245         // Lock funds.
246         lockedInBets += uint128(possibleWinAmount);
247         jackpotSize += uint128(jackpotFee);
248 
249         // Check whether contract has enough funds to process this bet.
250         require (jackpotSize + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
251 
252         // Record commit in logs.
253         emit Commit(commit);
254 
255         // Store bet parameters on blockchain.
256         bet.amount = amount;
257         bet.modulo = uint8(modulo);
258         bet.rollUnder = uint8(rollUnder);
259         bet.placeBlockNumber = uint40(block.number);
260         bet.mask = uint40(mask);
261         bet.gambler = msg.sender;
262     }
263 
264     // This is the method used to settle 99% of bets. To process a bet with a specific
265     // "commit", settleBet should supply a "reveal" number that would Keccak256-hash to
266     // "commit". "blockHash" is the block hash of placeBet block as seen by croupier; it
267     // is additionally asserted to prevent changing the bet outcomes on Ethereum reorgs.
268     function settleBet(uint reveal, bytes32 blockHash) external onlyCroupier {
269         uint commit = uint(keccak256(abi.encodePacked(reveal)));
270 
271         Bet storage bet = bets[commit];
272         uint placeBlockNumber = bet.placeBlockNumber;
273 
274         // Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
275         require (block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
276         require (block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
277         require (blockhash(placeBlockNumber) == blockHash);
278 
279         // Settle bet using reveal and blockHash as entropy sources.
280         settleBetCommon(bet, reveal, blockHash);
281     }
282 
283     // This method is used to settle a bet that was mined into an uncle block. At this
284     // point the player was shown some bet outcome, but the blockhash at placeBet height
285     // is different because of Ethereum chain reorg. We supply a full merkle proof of the
286     // placeBet transaction receipt to provide untamperable evidence that uncle block hash
287     // indeed was present on-chain at some point.
288     function settleBetUncleMerkleProof(uint reveal, uint40 canonicalBlockNumber) external onlyCroupier {
289         // "commit" for bet settlement can only be obtained by hashing a "reveal".
290         uint commit = uint(keccak256(abi.encodePacked(reveal)));
291 
292         Bet storage bet = bets[commit];
293 
294         // Check that canonical block hash can still be verified.
295         require (block.number <= canonicalBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
296 
297         // Verify placeBet receipt.
298         requireCorrectReceipt(4 + 32 + 32 + 4);
299 
300         // Reconstruct canonical & uncle block hashes from a receipt merkle proof, verify them.
301         bytes32 canonicalHash;
302         bytes32 uncleHash;
303         (canonicalHash, uncleHash) = verifyMerkleProof(commit, 4 + 32 + 32);
304         require (blockhash(canonicalBlockNumber) == canonicalHash);
305 
306         // Settle bet using reveal and uncleHash as entropy sources.
307         settleBetCommon(bet, reveal, uncleHash);
308     }
309 
310     // Common settlement code for settleBet & settleBetUncleMerkleProof.
311     function settleBetCommon(Bet storage bet, uint reveal, bytes32 entropyBlockHash) private {
312         // Fetch bet parameters into local variables (to save gas).
313         uint amount = bet.amount;
314         uint modulo = bet.modulo;
315         uint rollUnder = bet.rollUnder;
316         address gambler = bet.gambler;
317 
318         // Check that bet is in 'active' state.
319         require (amount != 0, "Bet should be in an 'active' state");
320 
321         // Move bet into 'processed' state already.
322         bet.amount = 0;
323 
324         // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
325         // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
326         // preimage is intractable), and house is unable to alter the "reveal" after
327         // placeBet have been mined (as Keccak256 collision finding is also intractable).
328         bytes32 entropy = keccak256(abi.encodePacked(reveal, entropyBlockHash));
329 
330         // Do a roll by taking a modulo of entropy. Compute winning amount.
331         uint dice = uint(entropy) % modulo;
332 
333         uint diceWinAmount;
334         uint _jackpotFee;
335         (diceWinAmount, _jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
336 
337         uint diceWin = 0;
338         uint jackpotWin = 0;
339 
340         // Determine dice outcome.
341         if (modulo <= MAX_MASK_MODULO) {
342             // For small modulo games, check the outcome against a bit mask.
343             if ((2 ** dice) & bet.mask != 0) {
344                 diceWin = diceWinAmount;
345             }
346 
347         } else {
348             // For larger modulos, check inclusion into half-open interval.
349             if (dice < rollUnder) {
350                 diceWin = diceWinAmount;
351             }
352 
353         }
354 
355         // Unlock the bet amount, regardless of the outcome.
356         lockedInBets -= uint128(diceWinAmount);
357 
358         // Roll for a jackpot (if eligible).
359         if (amount >= MIN_JACKPOT_BET) {
360             // The second modulo, statistically independent from the "main" dice roll.
361             // Effectively you are playing two games at once!
362             uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;
363 
364             // Bingo!
365             if (jackpotRng == 0) {
366                 jackpotWin = jackpotSize;
367                 jackpotSize = 0;
368             }
369         }
370 
371         // Log jackpot win.
372         if (jackpotWin > 0) {
373             emit JackpotPayment(gambler, jackpotWin);
374         }
375 
376         // Send the funds to gambler.
377         sendFunds(gambler, diceWin + jackpotWin == 0 ? 1 wei : diceWin + jackpotWin, diceWin);
378     }
379 
380     // Refund transaction - return the bet amount of a roll that was not processed in a
381     // due timeframe. Processing such blocks is not possible due to EVM limitations (see
382     // BET_EXPIRATION_BLOCKS comment above for details). In case you ever find yourself
383     // in a situation like this, just contact the dice2.win support, however nothing
384     // precludes you from invoking this method yourself.
385     function refundBet(uint commit) external {
386         // Check that bet is in 'active' state.
387         Bet storage bet = bets[commit];
388         uint amount = bet.amount;
389 
390         require (amount != 0, "Bet should be in an 'active' state");
391 
392         // Check that bet has already expired.
393         require (block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
394 
395         // Move bet into 'processed' state, release funds.
396         bet.amount = 0;
397 
398         uint diceWinAmount;
399         uint jackpotFee;
400         (diceWinAmount, jackpotFee) = getDiceWinAmount(amount, bet.modulo, bet.rollUnder);
401 
402         lockedInBets -= uint128(diceWinAmount);
403         jackpotSize -= uint128(jackpotFee);
404 
405         // Send the refund.
406         sendFunds(bet.gambler, amount, amount);
407     }
408 
409     // Get the expected win amount after house edge is subtracted.
410     function getDiceWinAmount(uint amount, uint modulo, uint rollUnder) private pure returns (uint winAmount, uint jackpotFee) {
411         require (0 < rollUnder && rollUnder <= modulo, "Win probability out of range.");
412 
413         jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
414 
415         uint houseEdge = amount * HOUSE_EDGE_PERCENT / 100;
416 
417         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
418             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
419         }
420 
421         require (houseEdge + jackpotFee <= amount, "Bet doesn't even cover house edge.");
422         winAmount = (amount - houseEdge - jackpotFee) * modulo / rollUnder;
423     }
424 
425     // Helper routine to process the payment.
426     function sendFunds(address beneficiary, uint amount, uint successLogAmount) private {
427         if (beneficiary.send(amount)) {
428             emit Payment(beneficiary, successLogAmount);
429         } else {
430             emit FailedPayment(beneficiary, amount);
431         }
432     }
433 
434     // This are some constants making O(1) population count in placeBet possible.
435     // See whitepaper for intuition and proofs behind it.
436     uint constant POPCNT_MULT = 0x0000000000002000000000100000000008000000000400000000020000000001;
437     uint constant POPCNT_MASK = 0x0001041041041041041041041041041041041041041041041041041041041041;
438     uint constant POPCNT_MODULO = 0x3F;
439 
440     // Helper to verify a full merkle proof starting from some seedHash (usually commit). "offset" is the location of the proof
441     // beginning in the calldata.
442     function verifyMerkleProof(uint seedHash, uint offset) pure private returns (bytes32 blockHash, bytes32 uncleHash) {
443         // (Safe) assumption - nobody will write into RAM during this method invocation.
444         uint scratchBuf1;  assembly { scratchBuf1 := mload(0x40) }
445 
446         uint uncleHeaderLength; uint blobLength; uint shift; uint hashSlot;
447 
448         // Verify merkle proofs up to uncle block header. Calldata layout is:
449         //  - 2 byte big-endian slice length
450         //  - 2 byte big-endian offset to the beginning of previous slice hash within the current slice (should be zeroed)
451         //  - followed by the current slice verbatim
452         for (;; offset += blobLength) {
453             assembly { blobLength := and(calldataload(sub(offset, 30)), 0xffff) }
454             if (blobLength == 0) {
455                 // Zero slice length marks the end of uncle proof.
456                 break;
457             }
458 
459             assembly { shift := and(calldataload(sub(offset, 28)), 0xffff) }
460             require (shift + 32 <= blobLength, "Shift bounds check.");
461 
462             offset += 4;
463             assembly { hashSlot := calldataload(add(offset, shift)) }
464             require (hashSlot == 0, "Non-empty hash slot.");
465 
466             assembly {
467                 calldatacopy(scratchBuf1, offset, blobLength)
468                 mstore(add(scratchBuf1, shift), seedHash)
469                 seedHash := sha3(scratchBuf1, blobLength)
470                 uncleHeaderLength := blobLength
471             }
472         }
473 
474         // At this moment the uncle hash is known.
475         uncleHash = bytes32(seedHash);
476 
477         // Construct the uncle list of a canonical block.
478         uint scratchBuf2 = scratchBuf1 + uncleHeaderLength;
479         uint unclesLength; assembly { unclesLength := and(calldataload(sub(offset, 28)), 0xffff) }
480         uint unclesShift;  assembly { unclesShift := and(calldataload(sub(offset, 26)), 0xffff) }
481         require (unclesShift + uncleHeaderLength <= unclesLength, "Shift bounds check.");
482 
483         offset += 6;
484         assembly { calldatacopy(scratchBuf2, offset, unclesLength) }
485         memcpy(scratchBuf2 + unclesShift, scratchBuf1, uncleHeaderLength);
486 
487         assembly { seedHash := sha3(scratchBuf2, unclesLength) }
488 
489         offset += unclesLength;
490 
491         // Verify the canonical block header using the computed sha3Uncles.
492         assembly {
493             blobLength := and(calldataload(sub(offset, 30)), 0xffff)
494             shift := and(calldataload(sub(offset, 28)), 0xffff)
495         }
496         require (shift + 32 <= blobLength, "Shift bounds check.");
497 
498         offset += 4;
499         assembly { hashSlot := calldataload(add(offset, shift)) }
500         require (hashSlot == 0, "Non-empty hash slot.");
501 
502         assembly {
503             calldatacopy(scratchBuf1, offset, blobLength)
504             mstore(add(scratchBuf1, shift), seedHash)
505 
506             // At this moment the canonical block hash is known.
507             blockHash := sha3(scratchBuf1, blobLength)
508         }
509     }
510 
511     // Helper to check the placeBet receipt. "offset" is the location of the proof beginning in the calldata.
512     // RLP layout: [triePath, str([status, cumGasUsed, bloomFilter, [[address, [topics], data]])]
513     function requireCorrectReceipt(uint offset) view private {
514         uint leafHeaderByte; assembly { leafHeaderByte := byte(0, calldataload(offset)) }
515 
516         require (leafHeaderByte >= 0xf7, "Receipt leaf longer than 55 bytes.");
517         offset += leafHeaderByte - 0xf6;
518 
519         uint pathHeaderByte; assembly { pathHeaderByte := byte(0, calldataload(offset)) }
520 
521         if (pathHeaderByte <= 0x7f) {
522             offset += 1;
523 
524         } else {
525             require (pathHeaderByte >= 0x80 && pathHeaderByte <= 0xb7, "Path is an RLP string.");
526             offset += pathHeaderByte - 0x7f;
527         }
528 
529         uint receiptStringHeaderByte; assembly { receiptStringHeaderByte := byte(0, calldataload(offset)) }
530         require (receiptStringHeaderByte == 0xb9, "Receipt string is always at least 256 bytes long, but less than 64k.");
531         offset += 3;
532 
533         uint receiptHeaderByte; assembly { receiptHeaderByte := byte(0, calldataload(offset)) }
534         require (receiptHeaderByte == 0xf9, "Receipt is always at least 256 bytes long, but less than 64k.");
535         offset += 3;
536 
537         uint statusByte; assembly { statusByte := byte(0, calldataload(offset)) }
538         require (statusByte == 0x1, "Status should be success.");
539         offset += 1;
540 
541         uint cumGasHeaderByte; assembly { cumGasHeaderByte := byte(0, calldataload(offset)) }
542         if (cumGasHeaderByte <= 0x7f) {
543             offset += 1;
544 
545         } else {
546             require (cumGasHeaderByte >= 0x80 && cumGasHeaderByte <= 0xb7, "Cumulative gas is an RLP string.");
547             offset += cumGasHeaderByte - 0x7f;
548         }
549 
550         uint bloomHeaderByte; assembly { bloomHeaderByte := byte(0, calldataload(offset)) }
551         require (bloomHeaderByte == 0xb9, "Bloom filter is always 256 bytes long.");
552         offset += 256 + 3;
553 
554         uint logsListHeaderByte; assembly { logsListHeaderByte := byte(0, calldataload(offset)) }
555         require (logsListHeaderByte == 0xf8, "Logs list is less than 256 bytes long.");
556         offset += 2;
557 
558         uint logEntryHeaderByte; assembly { logEntryHeaderByte := byte(0, calldataload(offset)) }
559         require (logEntryHeaderByte == 0xf8, "Log entry is less than 256 bytes long.");
560         offset += 2;
561 
562         uint addressHeaderByte; assembly { addressHeaderByte := byte(0, calldataload(offset)) }
563         require (addressHeaderByte == 0x94, "Address is 20 bytes long.");
564 
565         uint logAddress; assembly { logAddress := and(calldataload(sub(offset, 11)), 0xffffffffffffffffffffffffffffffffffffffff) }
566         require (logAddress == uint(address(this)));
567     }
568 
569     // Memory copy.
570     function memcpy(uint dest, uint src, uint len) pure private {
571         // Full 32 byte words
572         for(; len >= 32; len -= 32) {
573             assembly { mstore(dest, mload(src)) }
574             dest += 32; src += 32;
575         }
576 
577         // Remaining bytes
578         uint mask = 256 ** (32 - len) - 1;
579         assembly {
580             let srcpart := and(mload(src), not(mask))
581             let destpart := and(mload(dest), mask)
582             mstore(dest, or(destpart, srcpart))
583         }
584     }
585 }