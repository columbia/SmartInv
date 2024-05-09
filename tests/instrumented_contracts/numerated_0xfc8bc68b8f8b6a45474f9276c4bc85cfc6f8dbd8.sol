1 pragma solidity ^0.4.24;
2 
3 contract EthRoll {
4     /// *** Constants section
5 
6     // Each bet is deducted 1.5% in favour of the house, but no less than some minimum.
7     // The lower bound is dictated by gas costs of the settleBet transaction, providing
8     // headroom for up to 10 Gwei prices.
9     uint constant HOUSE_EDGE_PERCENT = 15;
10     uint constant HOUSE_EDGE_MINIMUM_AMOUNT = 0.00045 ether;
11 
12     // Bets lower than this amount do not participate in jackpot rolls (and are
13     // not deducted JACKPOT_FEE).
14     uint constant MIN_JACKPOT_BET = 0.1 ether;
15 
16     // Chance to win jackpot (currently 0.1%) and fee deducted into jackpot fund.
17     uint constant JACKPOT_MODULO = 1000;
18     uint constant JACKPOT_FEE = 0.001 ether;
19 
20     // There is minimum and maximum bets.
21     uint constant MIN_BET = 0.01 ether;
22     uint constant MAX_AMOUNT = 300000 ether;
23 
24     // Modulo is a number of equiprobable outcomes in a game:
25     //  - 2 for coin flip
26     //  - 6 for dice
27     //  - 6*6 = 36 for double dice
28     //  - 100 for etheroll
29     //  - 37 for roulette
30     //  etc.
31     // It's called so because 256-bit entropy is treated like a huge integer and
32     // the remainder of its division by modulo is considered bet outcome.
33     uint constant MAX_MODULO = 100;
34 
35     // For modulos below this threshold rolls are checked against a bit mask,
36     // thus allowing betting on any combination of outcomes. For example, given
37     // modulo 6 for dice, 101000 mask (base-2, big endian) means betting on
38     // 4 and 6; for games with modulos higher than threshold (Etheroll), a simple
39     // limit is used, allowing betting on any outcome in [0, N) range.
40     //
41     // The specific value is dictated by the fact that 256-bit intermediate
42     // multiplication result allows implementing population count efficiently
43     // for numbers that are up to 42 bits, and 40 is the highest multiple of
44     // eight below 42.
45     uint constant MAX_MASK_MODULO = 40;
46 
47     // This is a check on bet mask overflow.
48     uint constant MAX_BET_MASK = 2 ** MAX_MASK_MODULO;
49 
50     // EVM BLOCKHASH opcode can query no further than 256 blocks into the
51     // past. Given that settleBet uses block hash of placeBet as one of
52     // complementary entropy sources, we cannot process bets older than this
53     // threshold. On rare occasions EthRoll croupier may fail to invoke
54     // settleBet in this timespan due to technical issues or extreme Ethereum
55     // congestion; such bets can be refunded via invoking refundBet.
56     uint constant BET_EXPIRATION_BLOCKS = 250;
57 
58     // Some deliberately invalid address to initialize the secret signer with.
59     // Forces maintainers to invoke setSecretSigner before processing any bets.
60     address constant DUMMY_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
61 
62     // Standard contract ownership transfer.
63     address public owner;
64     address private nextOwner;
65 
66     // Adjustable max bet profit. Used to cap bets against dynamic odds.
67     uint public maxProfit;
68 
69     // The address corresponding to a private key used to sign placeBet commits.
70     address public secretSigner;
71 
72     // Accumulated jackpot fund.
73     uint128 public jackpotSize;
74 
75     // Funds that are locked in potentially winning bets. Prevents contract from
76     // committing to bets it cannot pay out.
77     uint128 public lockedInBets;
78 
79     address public beneficiary_ = 0x360f9b23ea114bb1a1e5fdd52fcb92837011ff65;
80     // A structure representing a single bet.
81     struct Bet {
82         // Wager amount in wei.
83         uint amount;
84         // Modulo of a game.
85         uint8 modulo;
86         // Number of winning outcomes, used to compute winning payment (* modulo/rollUnder),
87         // and used instead of mask for games with modulo > MAX_MASK_MODULO.
88         uint8 rollUnder;
89         // Block number of placeBet tx.
90         uint40 placeBlockNumber;
91         // Bit mask representing winning bet outcomes (see MAX_MASK_MODULO comment).
92         uint40 mask;
93         // Address of a gambler, used to pay out winning bets.
94         address gambler;
95     }
96 
97     // Mapping from commits to all currently active & processed bets.
98     mapping (uint => Bet) bets;
99 
100     // Croupier account.
101     address public croupier;
102 
103     // Events that are issued to make statistic recovery easier.
104     event FailedPayment(address indexed beneficiary, uint amount);
105     event Payment(address indexed beneficiary, uint amount);
106     event JackpotPayment(address indexed beneficiary, uint amount);
107 
108     // This event is emitted in placeBet to record commit in the logs.
109     event Commit(uint commit);
110 
111     // Constructor. Deliberately does not take any parameters.
112     constructor () public {
113         owner = msg.sender;
114         secretSigner = DUMMY_ADDRESS;
115         croupier = DUMMY_ADDRESS;
116     }
117 
118     // Standard modifier on methods invokable only by contract owner.
119     modifier onlyOwner {
120         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
121         _;
122     }
123 
124     // Standard modifier on methods invokable only by contract owner.
125     modifier onlyCroupier {
126         require (msg.sender == croupier, "OnlyCroupier methods called by non-croupier.");
127         _;
128     }
129 
130     // Standard contract ownership transfer implementation,
131     function approveNextOwner(address _nextOwner) external onlyOwner {
132         require (_nextOwner != owner, "Cannot approve current owner.");
133         nextOwner = _nextOwner;
134     }
135 
136     function acceptNextOwner() external {
137         require (msg.sender == nextOwner, "Can only accept preapproved new owner.");
138         owner = nextOwner;
139     }
140 
141     // Fallback function deliberately left empty. It's primary use case
142     // is to top up the bank roll.
143     function () public payable {
144     }
145 
146     // See comment for "secretSigner" variable.
147     function setSecretSigner(address newSecretSigner) external onlyOwner {
148         secretSigner = newSecretSigner;
149     }
150 
151     // Change the croupier address.
152     function setCroupier(address newCroupier) external onlyOwner {
153         croupier = newCroupier;
154     }
155 
156     // Change max bet reward. Setting this to zero effectively disables betting.
157     function setMaxProfit(uint _maxProfit) public onlyOwner {
158         require (_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
159         maxProfit = _maxProfit;
160     }
161 
162     // This function is used to bump up the jackpot fund. Cannot be used to lower it.
163     function increaseJackpot(uint increaseAmount) external onlyOwner {
164         require (increaseAmount <= address(this).balance, "Increase amount larger than balance.");
165         require (jackpotSize + lockedInBets + increaseAmount <= address(this).balance, "Not enough funds.");
166         jackpotSize += uint128(increaseAmount);
167     }
168 
169     // Funds withdrawal to cover costs of EthRoll operation.
170     function withdrawFunds(uint withdrawAmount) external onlyOwner {
171         require (withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
172         require (jackpotSize + lockedInBets + withdrawAmount <= address(this).balance, "Not enough funds.");
173         sendFunds(beneficiary_, withdrawAmount, withdrawAmount);
174     }
175 
176     // Contract may be destroyed only when there are no ongoing bets,
177     // either settled or refunded. All funds are transferred to contract owner.
178     function kill() external onlyOwner {
179         require (lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
180         selfdestruct(owner);
181     }
182 
183     /// *** Betting logic
184 
185     // Bet states:
186     //  amount == 0 && gambler == 0 - 'clean' (can place a bet)
187     //  amount != 0 && gambler != 0 - 'active' (can be settled or refunded)
188     //  amount == 0 && gambler != 0 - 'processed' (can clean storage)
189     //
190     //  NOTE: Storage cleaning is not implemented in this contract version; it will be added
191     //        with the next upgrade to prevent polluting Ethereum state with expired bets.
192 
193     // Bet placing transaction - issued by the player.
194     //  betMask         - bet outcomes bit mask for modulo <= MAX_MASK_MODULO,
195     //                    [0, betMask) for larger modulos.
196     //  modulo          - game modulo.
197     //  commitLastBlock - number of the maximum block where "commit" is still considered valid.
198     //  commit          - Keccak256 hash of some secret "reveal" random number, to be supplied
199     //                    by the EthRoll croupier bot in the settleBet transaction. Supplying
200     //                    "commit" ensures that "reveal" cannot be changed behind the scenes
201     //                    after placeBet have been mined.
202     //  r, s            - components of ECDSA signature of (commitLastBlock, commit). v is
203     //                    guaranteed to always equal 27.
204     //
205     // Commit, being essentially random 256-bit number, is used as a unique bet identifier in
206     // the 'bets' mapping.
207     //
208     // Commits are signed with a block limit to ensure that they are used at most once - otherwise
209     // it would be possible for a miner to place a bet with a known commit/reveal pair and tamper
210     // with the blockhash. Croupier guarantees that commitLastBlock will always be not greater than
211     // placeBet block number plus BET_EXPIRATION_BLOCKS. See whitepaper for details.
212     function placeBet(uint betMask, uint modulo, uint commitLastBlock, uint commit, bytes32 r, bytes32 s) external payable {
213         // Check that the bet is in 'clean' state.
214         Bet storage bet = bets[commit];
215         require (bet.gambler == address(0), "Bet should be in a 'clean' state.");
216 
217         // Validate input data ranges.
218         uint amount = msg.value;
219         require (modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
220         require (amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
221         require (betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
222 
223         // Check that commit is valid - it has not expired and its signature is valid.
224         require (block.number <= commitLastBlock, "Commit has expired.");
225         bytes32 signatureHash = keccak256(abi.encodePacked(uint40(commitLastBlock), commit));
226         require (secretSigner == ecrecover(signatureHash, 27, r, s), "ECDSA signature is not valid.");
227 
228         uint rollUnder;
229         uint mask;
230 
231         if (modulo <= MAX_MASK_MODULO) {
232             // Small modulo games specify bet outcomes via bit mask.
233             // rollUnder is a number of 1 bits in this mask (population count).
234             // This magic looking formula is an efficient way to compute population
235             // count on EVM for numbers below 2**40. For detailed proof consult
236             // the EthRoll whitepaper.
237             rollUnder = ((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
238             mask = betMask;
239         } else {
240             // Larger modulos specify the right edge of half-open interval of
241             // winning bet outcomes.
242             require (betMask > 0 && betMask <= modulo, "High modulo range, betMask larger than modulo.");
243             rollUnder = betMask;
244         }
245 
246         // Winning amount and jackpot increase.
247         uint possibleWinAmount;
248         uint jackpotFee;
249 
250         (possibleWinAmount, jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
251 
252         // Enforce max profit limit.
253         require (possibleWinAmount <= amount + maxProfit, "maxProfit limit violation.");
254 
255         // Lock funds.
256         lockedInBets += uint128(possibleWinAmount);
257         jackpotSize += uint128(jackpotFee);
258 
259         // Check whether contract has enough funds to process this bet.
260         require (jackpotSize + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
261 
262         // Record commit in logs.
263         emit Commit(commit);
264 
265         // Store bet parameters on blockchain.
266         bet.amount = amount;
267         bet.modulo = uint8(modulo);
268         bet.rollUnder = uint8(rollUnder);
269         bet.placeBlockNumber = uint40(block.number);
270         bet.mask = uint40(mask);
271         bet.gambler = msg.sender;
272     }
273 
274     // This is the method used to settle 99% of bets. To process a bet with a specific
275     // "commit", settleBet should supply a "reveal" number that would Keccak256-hash to
276     // "commit". "blockHash" is the block hash of placeBet block as seen by croupier; it
277     // is additionally asserted to prevent changing the bet outcomes on Ethereum reorgs.
278     function settleBet(uint reveal, bytes32 blockHash) external onlyCroupier {
279         uint commit = uint(keccak256(abi.encodePacked(reveal)));
280 
281         Bet storage bet = bets[commit];
282         uint placeBlockNumber = bet.placeBlockNumber;
283 
284         // Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
285         require (block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
286         require (block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
287         require (blockhash(placeBlockNumber) == blockHash);
288 
289         // Settle bet using reveal and blockHash as entropy sources.
290         settleBetCommon(bet, reveal, blockHash);
291     }
292 
293     // This method is used to settle a bet that was mined into an uncle block. At this
294     // point the player was shown some bet outcome, but the blockhash at placeBet height
295     // is different because of Ethereum chain reorg. We supply a full merkle proof of the
296     // placeBet transaction receipt to provide untamperable evidence that uncle block hash
297     // indeed was present on-chain at some point.
298     function settleBetUncleMerkleProof(uint reveal, uint40 canonicalBlockNumber) external onlyCroupier {
299         // "commit" for bet settlement can only be obtained by hashing a "reveal".
300         uint commit = uint(keccak256(abi.encodePacked(reveal)));
301 
302         Bet storage bet = bets[commit];
303 
304         // Check that canonical block hash can still be verified.
305         require (block.number <= canonicalBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
306 
307         // Verify placeBet receipt.
308         requireCorrectReceipt(4 + 32 + 32 + 4);
309 
310         // Reconstruct canonical & uncle block hashes from a receipt merkle proof, verify them.
311         bytes32 canonicalHash;
312         bytes32 uncleHash;
313         (canonicalHash, uncleHash) = verifyMerkleProof(commit, 4 + 32 + 32);
314         require (blockhash(canonicalBlockNumber) == canonicalHash);
315 
316         // Settle bet using reveal and uncleHash as entropy sources.
317         settleBetCommon(bet, reveal, uncleHash);
318     }
319 
320     // Common settlement code for settleBet & settleBetUncleMerkleProof.
321     function settleBetCommon(Bet storage bet, uint reveal, bytes32 entropyBlockHash) private {
322         // Fetch bet parameters into local variables (to save gas).
323         uint amount = bet.amount;
324         uint modulo = bet.modulo;
325         uint rollUnder = bet.rollUnder;
326         address gambler = bet.gambler;
327 
328         // Check that bet is in 'active' state.
329         require (amount != 0, "Bet should be in an 'active' state");
330 
331         // Move bet into 'processed' state already.
332         bet.amount = 0;
333 
334         // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
335         // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
336         // preimage is intractable), and house is unable to alter the "reveal" after
337         // placeBet have been mined (as Keccak256 collision finding is also intractable).
338         bytes32 entropy = keccak256(abi.encodePacked(reveal, entropyBlockHash));
339 
340         // Do a roll by taking a modulo of entropy. Compute winning amount.
341         uint dice = uint(entropy) % modulo;
342 
343         uint diceWinAmount;
344         uint _jackpotFee;
345         (diceWinAmount, _jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
346 
347         uint diceWin = 0;
348         uint jackpotWin = 0;
349 
350         // Determine dice outcome.
351         if (modulo <= MAX_MASK_MODULO) {
352             // For small modulo games, check the outcome against a bit mask.
353             if ((2 ** dice) & bet.mask != 0) {
354                 diceWin = diceWinAmount;
355             }
356 
357         } else {
358             // For larger modulos, check inclusion into half-open interval.
359             if (dice < rollUnder) {
360                 diceWin = diceWinAmount;
361             }
362 
363         }
364 
365         // Unlock the bet amount, regardless of the outcome.
366         lockedInBets -= uint128(diceWinAmount);
367 
368         // Roll for a jackpot (if eligible).
369         if (amount >= MIN_JACKPOT_BET) {
370             // The second modulo, statistically independent from the "main" dice roll.
371             // Effectively you are playing two games at once!
372             uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;
373 
374             // Bingo!
375             if (jackpotRng == 0) {
376                 jackpotWin = jackpotSize;
377                 jackpotSize = 0;
378             }
379         }
380 
381         // Log jackpot win.
382         if (jackpotWin > 0) {
383             emit JackpotPayment(gambler, jackpotWin);
384         }
385 
386         // Send the funds to gambler.
387         sendFunds(gambler, diceWin + jackpotWin == 0 ? 1 wei : diceWin + jackpotWin, diceWin);
388     }
389 
390     // Refund transaction - return the bet amount of a roll that was not processed in a
391     // due timeframe. Processing such blocks is not possible due to EVM limitations (see
392     // BET_EXPIRATION_BLOCKS comment above for details). In case you ever find yourself
393     // in a situation like this, just contact the EthRoll support, however nothing
394     // precludes you from invoking this method yourself.
395     function refundBet(uint commit) external {
396         // Check that bet is in 'active' state.
397         Bet storage bet = bets[commit];
398         uint amount = bet.amount;
399 
400         require (amount != 0, "Bet should be in an 'active' state");
401 
402         // Check that bet has already expired.
403         require (block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
404 
405         // Move bet into 'processed' state, release funds.
406         bet.amount = 0;
407 
408         uint diceWinAmount;
409         uint jackpotFee;
410         (diceWinAmount, jackpotFee) = getDiceWinAmount(amount, bet.modulo, bet.rollUnder);
411 
412         lockedInBets -= uint128(diceWinAmount);
413         jackpotSize -= uint128(jackpotFee);
414 
415         // Send the refund.
416         sendFunds(bet.gambler, amount, amount);
417     }
418 
419     // Get the expected win amount after house edge is subtracted.
420     function getDiceWinAmount(uint amount, uint modulo, uint rollUnder) private pure returns (uint winAmount, uint jackpotFee) {
421         require (0 < rollUnder && rollUnder <= modulo, "Win probability out of range.");
422 
423         jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
424 
425         uint houseEdge = amount * HOUSE_EDGE_PERCENT / 1000;
426 
427         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
428             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
429         }
430 
431         require (houseEdge + jackpotFee <= amount, "Bet doesn't even cover house edge.");
432         winAmount = (amount - houseEdge - jackpotFee) * modulo / rollUnder;
433     }
434 
435     // Helper routine to process the payment.
436     function sendFunds(address beneficiary, uint amount, uint successLogAmount) private {
437         if (beneficiary.call.value(amount)()) {
438             emit Payment(beneficiary, successLogAmount);
439         } else {
440             emit FailedPayment(beneficiary, amount);
441         }
442     }
443 
444     // This are some constants making O(1) population count in placeBet possible.
445     // See whitepaper for intuition and proofs behind it.
446     uint constant POPCNT_MULT = 0x0000000000002000000000100000000008000000000400000000020000000001;
447     uint constant POPCNT_MASK = 0x0001041041041041041041041041041041041041041041041041041041041041;
448     uint constant POPCNT_MODULO = 0x3F;
449 
450     // *** Merkle proofs.
451 
452     // This helpers are used to verify cryptographic proofs of placeBet inclusion into
453     // uncle blocks. They are used to prevent bet outcome changing on Ethereum reorgs without
454     // compromising the security of the smart contract. Proof data is appended to the input data
455     // in a simple prefix length format and does not adhere to the ABI.
456     // Invariants checked:
457     //  - receipt trie entry contains a (1) successful transaction (2) directed at this smart
458     //    contract (3) containing commit as a payload.
459     //  - receipt trie entry is a part of a valid merkle proof of a block header
460     //  - the block header is a part of uncle list of some block on canonical chain
461     // The implementation is optimized for gas cost and relies on the specifics of Ethereum internal data structures.
462     // Read the whitepaper for details.
463 
464     // Helper to verify a full merkle proof starting from some seedHash (usually commit). "offset" is the location of the proof
465     // beginning in the calldata.
466     function verifyMerkleProof(uint seedHash, uint offset) pure private returns (bytes32 blockHash, bytes32 uncleHash) {
467         // (Safe) assumption - nobody will write into RAM during this method invocation.
468         uint scratchBuf1;  assembly { scratchBuf1 := mload(0x40) }
469 
470         uint uncleHeaderLength; uint blobLength; uint shift; uint hashSlot;
471 
472         // Verify merkle proofs up to uncle block header. Calldata layout is:
473         //  - 2 byte big-endian slice length
474         //  - 2 byte big-endian offset to the beginning of previous slice hash within the current slice (should be zeroed)
475         //  - followed by the current slice verbatim
476         for (;; offset += blobLength) {
477             assembly { blobLength := and(calldataload(sub(offset, 30)), 0xffff) }
478             if (blobLength == 0) {
479                 // Zero slice length marks the end of uncle proof.
480                 break;
481             }
482 
483             assembly { shift := and(calldataload(sub(offset, 28)), 0xffff) }
484             require (shift + 32 <= blobLength, "Shift bounds check.");
485 
486             offset += 4;
487             assembly { hashSlot := calldataload(add(offset, shift)) }
488             require (hashSlot == 0, "Non-empty hash slot.");
489 
490             assembly {
491                 calldatacopy(scratchBuf1, offset, blobLength)
492                 mstore(add(scratchBuf1, shift), seedHash)
493                 seedHash := sha3(scratchBuf1, blobLength)
494                 uncleHeaderLength := blobLength
495             }
496         }
497 
498         // At this moment the uncle hash is known.
499         uncleHash = bytes32(seedHash);
500 
501         // Construct the uncle list of a canonical block.
502         uint scratchBuf2 = scratchBuf1 + uncleHeaderLength;
503         uint unclesLength; assembly { unclesLength := and(calldataload(sub(offset, 28)), 0xffff) }
504         uint unclesShift;  assembly { unclesShift := and(calldataload(sub(offset, 26)), 0xffff) }
505         require (unclesShift + uncleHeaderLength <= unclesLength, "Shift bounds check.");
506 
507         offset += 6;
508         assembly { calldatacopy(scratchBuf2, offset, unclesLength) }
509         memcpy(scratchBuf2 + unclesShift, scratchBuf1, uncleHeaderLength);
510 
511         assembly { seedHash := sha3(scratchBuf2, unclesLength) }
512 
513         offset += unclesLength;
514 
515         // Verify the canonical block header using the computed sha3Uncles.
516         assembly {
517             blobLength := and(calldataload(sub(offset, 30)), 0xffff)
518             shift := and(calldataload(sub(offset, 28)), 0xffff)
519         }
520         require (shift + 32 <= blobLength, "Shift bounds check.");
521 
522         offset += 4;
523         assembly { hashSlot := calldataload(add(offset, shift)) }
524         require (hashSlot == 0, "Non-empty hash slot.");
525 
526         assembly {
527             calldatacopy(scratchBuf1, offset, blobLength)
528             mstore(add(scratchBuf1, shift), seedHash)
529 
530             // At this moment the canonical block hash is known.
531             blockHash := sha3(scratchBuf1, blobLength)
532         }
533     }
534 
535     // Helper to check the placeBet receipt. "offset" is the location of the proof beginning in the calldata.
536     // RLP layout: [triePath, str([status, cumGasUsed, bloomFilter, [[address, [topics], data]])]
537     function requireCorrectReceipt(uint offset) view private {
538         uint leafHeaderByte; assembly { leafHeaderByte := byte(0, calldataload(offset)) }
539 
540         require (leafHeaderByte >= 0xf7, "Receipt leaf longer than 55 bytes.");
541         offset += leafHeaderByte - 0xf6;
542 
543         uint pathHeaderByte; assembly { pathHeaderByte := byte(0, calldataload(offset)) }
544 
545         if (pathHeaderByte <= 0x7f) {
546             offset += 1;
547 
548         } else {
549             require (pathHeaderByte >= 0x80 && pathHeaderByte <= 0xb7, "Path is an RLP string.");
550             offset += pathHeaderByte - 0x7f;
551         }
552 
553         uint receiptStringHeaderByte; assembly { receiptStringHeaderByte := byte(0, calldataload(offset)) }
554         require (receiptStringHeaderByte == 0xb9, "Receipt string is always at least 256 bytes long, but less than 64k.");
555         offset += 3;
556 
557         uint receiptHeaderByte; assembly { receiptHeaderByte := byte(0, calldataload(offset)) }
558         require (receiptHeaderByte == 0xf9, "Receipt is always at least 256 bytes long, but less than 64k.");
559         offset += 3;
560 
561         uint statusByte; assembly { statusByte := byte(0, calldataload(offset)) }
562         require (statusByte == 0x1, "Status should be success.");
563         offset += 1;
564 
565         uint cumGasHeaderByte; assembly { cumGasHeaderByte := byte(0, calldataload(offset)) }
566         if (cumGasHeaderByte <= 0x7f) {
567             offset += 1;
568 
569         } else {
570             require (cumGasHeaderByte >= 0x80 && cumGasHeaderByte <= 0xb7, "Cumulative gas is an RLP string.");
571             offset += cumGasHeaderByte - 0x7f;
572         }
573 
574         uint bloomHeaderByte; assembly { bloomHeaderByte := byte(0, calldataload(offset)) }
575         require (bloomHeaderByte == 0xb9, "Bloom filter is always 256 bytes long.");
576         offset += 256 + 3;
577 
578         uint logsListHeaderByte; assembly { logsListHeaderByte := byte(0, calldataload(offset)) }
579         require (logsListHeaderByte == 0xf8, "Logs list is less than 256 bytes long.");
580         offset += 2;
581 
582         uint logEntryHeaderByte; assembly { logEntryHeaderByte := byte(0, calldataload(offset)) }
583         require (logEntryHeaderByte == 0xf8, "Log entry is less than 256 bytes long.");
584         offset += 2;
585 
586         uint addressHeaderByte; assembly { addressHeaderByte := byte(0, calldataload(offset)) }
587         require (addressHeaderByte == 0x94, "Address is 20 bytes long.");
588 
589         uint logAddress; assembly { logAddress := and(calldataload(sub(offset, 11)), 0xffffffffffffffffffffffffffffffffffffffff) }
590         require (logAddress == uint(address(this)));
591     }
592 
593     // Memory copy.
594     function memcpy(uint dest, uint src, uint len) pure private {
595         // Full 32 byte words
596         for(; len >= 32; len -= 32) {
597             assembly { mstore(dest, mload(src)) }
598             dest += 32; src += 32;
599         }
600 
601         // Remaining bytes
602         uint mask = 256 ** (32 - len) - 1;
603         assembly {
604             let srcpart := and(mload(src), not(mask))
605             let destpart := and(mload(dest), mask)
606             mstore(dest, or(destpart, srcpart))
607         }
608     }
609 }