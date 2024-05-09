1 pragma solidity ^0.4.24;
2 
3 // * Ethflipper.com
4 //
5 // * Credits: Originally forked from dice2.win, Version 5
6 
7 contract EthFlipper {
8     /// *** Constants section
9 
10     // Each bet is deducted 2% in favour of the house, but no less than some minimum.
11     // The lower bound is dictated by gas costs of the settleBet transaction, providing
12     // headroom for up to 10 Gwei prices.
13     // Change: Raised
14     uint constant HOUSE_EDGE_PERCENT = 2;
15     uint constant HOUSE_EDGE_MINIMUM_AMOUNT = 0.0006 ether;
16 
17     // Bets lower than this amount do not participate in jackpot rolls (and are
18     // not deducted JACKPOT_FEE).
19     // Change: Lowered.
20     uint constant MIN_JACKPOT_BET = 0.05 ether;
21 
22     // Chance to win jackpot (currently 0.1%) and fee deducted into jackpot fund.
23     // Changed: Raised fee.
24     uint constant JACKPOT_MODULO = 1000;
25     uint constant JACKPOT_FEE = 0.002 ether;
26 
27     // There is minimum and maximum bets.
28     // Change: Max lowered
29     uint constant MIN_BET = 0.01 ether;
30     uint constant MAX_AMOUNT = 300 ether;
31 
32     // Modulo is a number of equiprobable outcomes in a game:
33     //  - 2 for coin flip
34     //  - 6 for dice
35     //  - 6*6 = 36 for double dice
36     //  - 100 for etheroll
37     //  - 37 for roulette
38     //  etc.
39     // It's called so because 256-bit entropy is treated like a huge integer and
40     // the remainder of its division by modulo is considered bet outcome.
41     uint constant MAX_MODULO = 100;
42 
43     // For modulos below this threshold rolls are checked against a bit mask,
44     // thus allowing betting on any combination of outcomes. For example, given
45     // modulo 6 for dice, 101000 mask (base-2, big endian) means betting on
46     // 4 and 6; for games with modulos higher than threshold (Etheroll), a simple
47     // limit is used, allowing betting on any outcome in [0, N) range.
48     //
49     // The specific value is dictated by the fact that 256-bit intermediate
50     // multiplication result allows implementing population count efficiently
51     // for numbers that are up to 42 bits, and 40 is the highest multiple of
52     // eight below 42.
53     uint constant MAX_MASK_MODULO = 40;
54 
55     // This is a check on bet mask overflow.
56     uint constant MAX_BET_MASK = 2 ** MAX_MASK_MODULO;
57 
58     // EVM BLOCKHASH opcode can query no further than 256 blocks into the
59     // past. Given that settleBet uses block hash of placeBet as one of
60     // complementary entropy sources, we cannot process bets older than this
61     // threshold. On rare occasions our croupier may fail to invoke
62     // settleBet in this timespan due to technical issues or extreme Ethereum
63     // congestion; such bets can be refunded via invoking refundBet.
64     uint constant BET_EXPIRATION_BLOCKS = 250;
65 
66     // Forces maintainers to invoke setSecretSigner before processing any bets.
67     address constant DUMMY_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
68 
69     // Standard contract ownership transfer.
70     address public owner;
71     address private nextOwner;
72 
73     // Adjustable max bet profit. Used to cap bets against dynamic odds.
74     uint public maxProfit;
75 
76     // The address corresponding to a private key used to sign placeBet commits.
77     address public secretSigner;
78     
79     // Croupier account.
80     address public croupier;
81     
82     // Accumulated jackpot fund.
83     uint128 public jackpotSize;
84 
85     // Funds that are locked in potentially winning bets. Prevents contract from
86     // committing to bets it cannot pay out.
87     uint128 public lockedInBets;
88 
89     // A structure representing a single bet.
90     struct Bet {
91         // Wager amount in wei.
92         uint amount;
93         // Modulo of a game.
94         uint8 modulo;
95         // Number of winning outcomes, used to compute winning payment (* modulo/rollUnder),
96         // and used instead of mask for games with modulo > MAX_MASK_MODULO.
97         uint8 rollUnder;
98         // Block number of placeBet tx.
99         uint40 placeBlockNumber;
100         // Bit mask representing winning bet outcomes (see MAX_MASK_MODULO comment).
101         uint40 mask;
102         // Address of a player, used to pay out winning bets.
103         address player;
104     }
105 
106     // Mapping from commits to all currently active & processed bets.
107     mapping (uint => Bet) bets;
108 
109 
110     event Calculations(uint result, uint entropy, uint dice, uint modulo, uint rollUnder);
111 
112     // Events that are issued to make statistic recovery easier.
113     event FailedPayment(address indexed beneficiary, uint amount);
114     event Payment(address indexed beneficiary, uint amount);
115     event JackpotPayment(address indexed beneficiary, uint amount);
116 
117     // This event is emitted in placeBet to record commit in the logs.
118     event Commit(uint commit);
119 
120     // Constructor. Deliberately does not take any parameters.
121     constructor () public {
122         owner = msg.sender;
123         secretSigner = DUMMY_ADDRESS;
124         croupier = DUMMY_ADDRESS;
125     }
126 
127     // Standard modifier on methods invokable only by contract owner.
128     modifier onlyOwner {
129         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
130         _;
131     }
132 
133     // Standard modifier on methods invokable only by contract owner.
134     modifier onlyCroupier {
135         require (msg.sender == croupier, "OnlyCroupier methods called by non-croupier.");
136         _;
137     }
138 
139     // Standard contract ownership transfer implementation,
140     function approveNextOwner(address _nextOwner) external onlyOwner {
141         require (_nextOwner != owner, "Cannot approve current owner.");
142         nextOwner = _nextOwner;
143     }
144 
145     function acceptNextOwner() external {
146         require (msg.sender == nextOwner, "Can only accept preapproved new owner.");
147         owner = nextOwner;
148     }
149 
150     // Fallback function deliberately left empty. It's primary use case
151     // is to top up the bank roll.
152     function () public payable {
153     }
154 
155     // See comment for "secretSigner" variable.
156     function setSecretSigner(address newSecretSigner) external onlyOwner {
157         secretSigner = newSecretSigner;
158     }
159 
160     // Change the croupier address.
161     function setCroupier(address newCroupier) external onlyOwner {
162         croupier = newCroupier;
163     }
164 
165     // Change max bet reward. Setting this to zero effectively disables betting.
166     function setMaxProfit(uint _maxProfit) public onlyOwner {
167         require (_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
168         maxProfit = _maxProfit;
169     }
170 
171     // This function is used to bump up the jackpot fund. Cannot be used to lower it.
172     function increaseJackpot(uint increaseAmount) external onlyOwner {
173         require (increaseAmount <= address(this).balance, "Increase amount larger than balance.");
174         require (jackpotSize + lockedInBets + increaseAmount <= address(this).balance, "Not enough funds.");
175         jackpotSize += uint128(increaseAmount);
176     }
177 
178     // Funds withdrawal
179     function withdrawFunds(address beneficiary, uint withdrawAmount) external onlyOwner {
180         require (withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
181         require (jackpotSize + lockedInBets + withdrawAmount <= address(this).balance, "Not enough funds.");
182         sendFunds(beneficiary, withdrawAmount, withdrawAmount);
183     }
184 
185     // Contract may be destroyed only when there are no ongoing bets,
186     // either settled or refunded. All funds are transferred to contract owner.
187     function kill() external onlyOwner {
188         require (lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
189         selfdestruct(owner);
190     }
191 
192     /// *** Betting logic
193 
194     // Bet states:
195     //  amount == 0 && player == 0 - 'clean' (can place a bet)
196     //  amount != 0 && player != 0 - 'active' (can be settled or refunded)
197     //  amount == 0 && player != 0 - 'processed' (can clean storage)
198     //
199     //  NOTE: Storage cleaning is not implemented in this contract version; it will be added
200     //        with the next upgrade to prevent polluting Ethereum state with expired bets.
201 
202     // Bet placing transaction - issued by the player.
203     //  betMask         - bet outcomes bit mask for modulo <= MAX_MASK_MODULO,
204     //                    [0, betMask) for larger modulos.
205     //  modulo          - game modulo.
206     //  commitLastBlock - number of the maximum block where "commit" is still considered valid.
207     //  commit          - Keccak256 hash of some secret "reveal" random number, to be supplied
208     //                    by the our croupier bot in the settleBet transaction. Supplying
209     //                    "commit" ensures that "reveal" cannot be changed behind the scenes
210     //                    after placeBet have been mined.
211     //  r, s            - components of ECDSA signature of (commitLastBlock, commit). v is
212     //                    guaranteed to always equal 27.
213     //
214     // Commit, being essentially random 256-bit number, is used as a unique bet identifier in
215     // the 'bets' mapping.
216     //
217     // Commits are signed with a block limit to ensure that they are used at most once - otherwise
218     // it would be possible for a miner to place a bet with a known commit/reveal pair and tamper
219     // with the blockhash. Croupier guarantees that commitLastBlock will always be not greater than
220     // placeBet block number plus BET_EXPIRATION_BLOCKS. See whitepaper for details.
221     function placeBet(uint betMask, uint modulo, uint commitLastBlock, uint commit, bytes32 r, bytes32 s) external payable {
222         // Check that the bet is in 'clean' state.
223         Bet storage bet = bets[commit];
224         require (bet.player == address(0), "Bet should be in a 'clean' state.");
225 
226         // Validate input data ranges.
227         uint amount = msg.value;
228         require (modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
229         require (amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
230         require (betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
231 
232         // Check that commit is valid - it has not expired and its signature is valid.
233         require (block.number <= commitLastBlock, "Commit has expired.");
234         // bytes32 signatureHash = keccak256(abi.encodePacked(uint40(commitLastBlock), commit));
235         bytes32 p = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32",keccak256(abi.encodePacked(uint40(commitLastBlock), commit))));
236 
237         require (secretSigner == ecrecover(p, 27, r, s), "ECDSA signature is not valid.");
238 
239         uint rollUnder;
240         uint mask;
241 
242         if (modulo <= MAX_MASK_MODULO) {
243             // Small modulo games specify bet outcomes via bit mask.
244             // rollUnder is a number of 1 bits in this mask (population count).
245             // This magic looking formula is an efficient way to compute population
246             // count on EVM for numbers below 2**40.
247             rollUnder = ((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
248             mask = betMask;
249         } else {
250             // Larger modulos specify the right edge of half-open interval of
251             // winning bet outcomes.
252             require (betMask > 0 && betMask <= modulo, "High modulo range, betMask larger than modulo.");
253             rollUnder = betMask;
254         }
255 
256         // Winning amount and jackpot increase.
257         uint possibleWinAmount;
258         uint jackpotFee;
259 
260         (possibleWinAmount, jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
261 
262         // Enforce max profit limit.
263         require (possibleWinAmount <= amount + maxProfit, "maxProfit limit violation.");
264 
265         // Lock funds.
266         lockedInBets += uint128(possibleWinAmount);
267         jackpotSize += uint128(jackpotFee);
268 
269         // Check whether contract has enough funds to process this bet.
270         require (jackpotSize + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
271 
272         // Record commit in logs.
273         emit Commit(commit);
274 
275         // Store bet parameters on blockchain.
276         bet.amount = amount;
277         bet.modulo = uint8(modulo);
278         bet.rollUnder = uint8(rollUnder);
279         bet.placeBlockNumber = uint40(block.number);
280         bet.mask = uint40(mask);
281         bet.player = msg.sender;
282     }
283 
284     // This is the method used to settle 99% of bets. To process a bet with a specific
285     // "commit", settleBet should supply a "reveal" number that would Keccak256-hash to
286     // "commit". "blockHash" is the block hash of placeBet block as seen by croupier; it
287     // is additionally asserted to prevent changing the bet outcomes on Ethereum reorgs.
288     function settleBet(uint reveal, bytes32 blockHash) external onlyCroupier {
289         uint commit = uint(keccak256(abi.encodePacked(reveal)));
290 
291         Bet storage bet = bets[commit];
292         uint placeBlockNumber = bet.placeBlockNumber;
293 
294         // Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
295         require (block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
296         require (block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
297         require (blockhash(placeBlockNumber) == blockHash, "Blockhash it not equal to placeBlockNumber");
298 
299         // Settle bet using reveal and blockHash as entropy sources.
300         settleBetCommon(bet, reveal, blockHash);
301     }
302 
303     // This method is used to settle a bet that was mined into an uncle block. At this
304     // point the player was shown some bet outcome, but the blockhash at placeBet height
305     // is different because of Ethereum chain reorg. We supply a full merkle proof of the
306     // placeBet transaction receipt to provide untamperable evidence that uncle block hash
307     // indeed was present on-chain at some point.
308     function settleBetUncleMerkleProof(uint reveal, uint40 canonicalBlockNumber) external onlyCroupier {
309         // "commit" for bet settlement can only be obtained by hashing a "reveal".
310         uint commit = uint(keccak256(abi.encodePacked(reveal)));
311 
312         Bet storage bet = bets[commit];
313 
314         // Check that canonical block hash can still be verified.
315         require (block.number <= canonicalBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
316 
317         // Verify placeBet receipt.
318         requireCorrectReceipt(4 + 32 + 32 + 4);
319 
320         // Reconstruct canonical & uncle block hashes from a receipt merkle proof, verify them.
321         bytes32 canonicalHash;
322         bytes32 uncleHash;
323         (canonicalHash, uncleHash) = verifyMerkleProof(commit, 4 + 32 + 32);
324         require (blockhash(canonicalBlockNumber) == canonicalHash);
325 
326         // Settle bet using reveal and uncleHash as entropy sources.
327         settleBetCommon(bet, reveal, uncleHash);
328     }
329 
330     // Common settlement code for settleBet & settleBetUncleMerkleProof.
331     function settleBetCommon(Bet storage bet, uint reveal, bytes32 entropyBlockHash) private {
332         // Fetch bet parameters into local variables (to save gas).
333         uint amount = bet.amount;
334         uint modulo = bet.modulo;
335         uint rollUnder = bet.rollUnder;
336         address player = bet.player;
337 
338         // Check that bet is in 'active' state.
339         require (amount != 0, "Bet should be in an 'active' state");
340 
341         // Move bet into 'processed' state already.
342         bet.amount = 0;
343 
344         // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
345         // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
346         // preimage is intractable), and house is unable to alter the "reveal" after
347         // placeBet have been mined (as Keccak256 collision finding is also intractable).
348         bytes32 entropy = keccak256(abi.encodePacked(reveal, entropyBlockHash));
349 
350         // Do a roll by taking a modulo of entropy. Compute winning amount.
351         uint dice = uint(entropy) % modulo;
352         uint result = (2 ** dice);
353         emit Calculations(result, uint(entropy), dice, modulo, rollUnder);
354 
355 
356         uint diceWinAmount;
357         uint _jackpotFee;
358         (diceWinAmount, _jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
359 
360         uint diceWin = 0;
361         uint jackpotWin = 0;
362 
363         // Determine dice outcome.
364         if (modulo <= MAX_MASK_MODULO) {
365             // For small modulo games, check the outcome against a bit mask.
366             if ((2 ** dice) & bet.mask != 0) {
367                 diceWin = diceWinAmount;
368             }
369 
370         } else {
371             // For larger modulos, check inclusion into half-open interval.
372             if (dice < rollUnder) {
373                 diceWin = diceWinAmount;
374             }
375 
376         }
377 
378         // Unlock the bet amount, regardless of the outcome.
379         lockedInBets -= uint128(diceWinAmount);
380 
381         // Roll for a jackpot (if eligible).
382         if (amount >= MIN_JACKPOT_BET) {
383             // The second modulo, statistically independent from the "main" dice roll.
384             // Effectively you are playing two games at once!
385             uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;
386 
387             // Bingo!
388             if (jackpotRng == 0) {
389                 jackpotWin = jackpotSize;
390                 jackpotSize = 0;
391             }
392         }
393 
394         // Log jackpot win.
395         if (jackpotWin > 0) {
396             emit JackpotPayment(player, jackpotWin);
397         }
398 
399         // Send the funds to player.
400         sendFunds(player, diceWin + jackpotWin == 0 ? 1 wei : diceWin + jackpotWin, diceWin);
401     }
402 
403     // Refund transaction - return the bet amount of a roll that was not processed in a
404     // due timeframe. Processing such blocks is not possible due to EVM limitations (see
405     // BET_EXPIRATION_BLOCKS comment above for details). In case you ever find yourself
406     // in a situation like this, contact support, however nothing
407     // precludes you from invoking this method yourself.
408     function refundBet(uint commit) external {
409         // Check that bet is in 'active' state.
410         Bet storage bet = bets[commit];
411         uint amount = bet.amount;
412 
413         require (amount != 0, "Bet should be in an 'active' state");
414 
415         // Check that bet has already expired.
416         require (block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
417 
418         // Move bet into 'processed' state, release funds.
419         bet.amount = 0;
420 
421         uint diceWinAmount;
422         uint jackpotFee;
423         (diceWinAmount, jackpotFee) = getDiceWinAmount(amount, bet.modulo, bet.rollUnder);
424 
425         lockedInBets -= uint128(diceWinAmount);
426         jackpotSize -= uint128(jackpotFee);
427 
428         // Send the refund.
429         sendFunds(bet.player, amount, amount);
430     }
431 
432     // Get the expected win amount after house edge is subtracted.
433     function getDiceWinAmount(uint amount, uint modulo, uint rollUnder) private pure returns (uint winAmount, uint jackpotFee) {
434         require (0 < rollUnder && rollUnder <= modulo, "Win probability out of range.");
435 
436         jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
437 
438         uint houseEdge = amount * HOUSE_EDGE_PERCENT / 100;
439 
440         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
441             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
442         }
443 
444         require (houseEdge + jackpotFee <= amount, "Bet do not cover house edge and jackpot fee.");
445         winAmount = (amount - houseEdge - jackpotFee) * modulo / rollUnder;
446     }
447 
448     // Helper routine to process the payment.
449     function sendFunds(address beneficiary, uint amount, uint successLogAmount) private {
450         if (beneficiary.send(amount)) {
451             emit Payment(beneficiary, successLogAmount);
452         } else {
453             emit FailedPayment(beneficiary, amount);
454         }
455     }
456 
457     // This are some constants making O(1) population count in placeBet possible.
458     // See whitepaper for intuition and proofs behind it.
459     uint constant POPCNT_MULT = 0x0000000000002000000000100000000008000000000400000000020000000001;
460     uint constant POPCNT_MASK = 0x0001041041041041041041041041041041041041041041041041041041041041;
461     uint constant POPCNT_MODULO = 0x3F;
462 
463     // *** Merkle proofs.
464 
465     // This helpers are used to verify cryptographic proofs of placeBet inclusion into
466     // uncle blocks. They are used to prevent bet outcome changing on Ethereum reorgs without
467     // compromising the security of the smart contract. Proof data is appended to the input data
468     // in a simple prefix length format and does not adhere to the ABI.
469     // Invariants checked:
470     //  - receipt trie entry contains a (1) successful transaction (2) directed at this smart
471     //    contract (3) containing commit as a payload.
472     //  - receipt trie entry is a part of a valid merkle proof of a block header
473     //  - the block header is a part of uncle list of some block on canonical chain
474     // The implementation is optimized for gas cost and relies on the specifics of Ethereum internal data structures.
475     // Read the whitepaper for details.
476 
477     // Helper to verify a full merkle proof starting from some seedHash (usually commit). "offset" is the location of the proof
478     // beginning in the calldata.
479     function verifyMerkleProof(uint seedHash, uint offset) pure private returns (bytes32 blockHash, bytes32 uncleHash) {
480         // (Safe) assumption - nobody will write into RAM during this method invocation.
481         uint scratchBuf1;  assembly { scratchBuf1 := mload(0x40) }
482 
483         uint uncleHeaderLength; uint blobLength; uint shift; uint hashSlot;
484 
485         // Verify merkle proofs up to uncle block header. Calldata layout is:
486         //  - 2 byte big-endian slice length
487         //  - 2 byte big-endian offset to the beginning of previous slice hash within the current slice (should be zeroed)
488         //  - followed by the current slice verbatim
489         for (;; offset += blobLength) {
490             assembly { blobLength := and(calldataload(sub(offset, 30)), 0xffff) }
491             if (blobLength == 0) {
492                 // Zero slice length marks the end of uncle proof.
493                 break;
494             }
495 
496             assembly { shift := and(calldataload(sub(offset, 28)), 0xffff) }
497             require (shift + 32 <= blobLength, "Shift bounds check.");
498 
499             offset += 4;
500             assembly { hashSlot := calldataload(add(offset, shift)) }
501             require (hashSlot == 0, "Non-empty hash slot.");
502 
503             assembly {
504                 calldatacopy(scratchBuf1, offset, blobLength)
505                 mstore(add(scratchBuf1, shift), seedHash)
506                 seedHash := sha3(scratchBuf1, blobLength)
507                 uncleHeaderLength := blobLength
508             }
509         }
510 
511         // At this moment the uncle hash is known.
512         uncleHash = bytes32(seedHash);
513 
514         // Construct the uncle list of a canonical block.
515         uint scratchBuf2 = scratchBuf1 + uncleHeaderLength;
516         uint unclesLength; assembly { unclesLength := and(calldataload(sub(offset, 28)), 0xffff) }
517         uint unclesShift;  assembly { unclesShift := and(calldataload(sub(offset, 26)), 0xffff) }
518         require (unclesShift + uncleHeaderLength <= unclesLength, "Shift bounds check.");
519 
520         offset += 6;
521         assembly { calldatacopy(scratchBuf2, offset, unclesLength) }
522         memcpy(scratchBuf2 + unclesShift, scratchBuf1, uncleHeaderLength);
523 
524         assembly { seedHash := sha3(scratchBuf2, unclesLength) }
525 
526         offset += unclesLength;
527 
528         // Verify the canonical block header using the computed sha3Uncles.
529         assembly {
530             blobLength := and(calldataload(sub(offset, 30)), 0xffff)
531             shift := and(calldataload(sub(offset, 28)), 0xffff)
532         }
533         require (shift + 32 <= blobLength, "Shift bounds check.");
534 
535         offset += 4;
536         assembly { hashSlot := calldataload(add(offset, shift)) }
537         require (hashSlot == 0, "Non-empty hash slot.");
538 
539         assembly {
540             calldatacopy(scratchBuf1, offset, blobLength)
541             mstore(add(scratchBuf1, shift), seedHash)
542 
543             // At this moment the canonical block hash is known.
544             blockHash := sha3(scratchBuf1, blobLength)
545         }
546     }
547 
548     // Helper to check the placeBet receipt. "offset" is the location of the proof beginning in the calldata.
549     // RLP layout: [triePath, str([status, cumGasUsed, bloomFilter, [[address, [topics], data]])]
550     function requireCorrectReceipt(uint offset) view private {
551         uint leafHeaderByte; assembly { leafHeaderByte := byte(0, calldataload(offset)) }
552 
553         require (leafHeaderByte >= 0xf7, "Receipt leaf longer than 55 bytes.");
554         offset += leafHeaderByte - 0xf6;
555 
556         uint pathHeaderByte; assembly { pathHeaderByte := byte(0, calldataload(offset)) }
557 
558         if (pathHeaderByte <= 0x7f) {
559             offset += 1;
560 
561         } else {
562             require (pathHeaderByte >= 0x80 && pathHeaderByte <= 0xb7, "Path is an RLP string.");
563             offset += pathHeaderByte - 0x7f;
564         }
565 
566         uint receiptStringHeaderByte; assembly { receiptStringHeaderByte := byte(0, calldataload(offset)) }
567         require (receiptStringHeaderByte == 0xb9, "Receipt string is always at least 256 bytes long, but less than 64k.");
568         offset += 3;
569 
570         uint receiptHeaderByte; assembly { receiptHeaderByte := byte(0, calldataload(offset)) }
571         require (receiptHeaderByte == 0xf9, "Receipt is always at least 256 bytes long, but less than 64k.");
572         offset += 3;
573 
574         uint statusByte; assembly { statusByte := byte(0, calldataload(offset)) }
575         require (statusByte == 0x1, "Status should be success.");
576         offset += 1;
577 
578         uint cumGasHeaderByte; assembly { cumGasHeaderByte := byte(0, calldataload(offset)) }
579         if (cumGasHeaderByte <= 0x7f) {
580             offset += 1;
581 
582         } else {
583             require (cumGasHeaderByte >= 0x80 && cumGasHeaderByte <= 0xb7, "Cumulative gas is an RLP string.");
584             offset += cumGasHeaderByte - 0x7f;
585         }
586 
587         uint bloomHeaderByte; assembly { bloomHeaderByte := byte(0, calldataload(offset)) }
588         require (bloomHeaderByte == 0xb9, "Bloom filter is always 256 bytes long.");
589         offset += 256 + 3;
590 
591         uint logsListHeaderByte; assembly { logsListHeaderByte := byte(0, calldataload(offset)) }
592         require (logsListHeaderByte == 0xf8, "Logs list is less than 256 bytes long.");
593         offset += 2;
594 
595         uint logEntryHeaderByte; assembly { logEntryHeaderByte := byte(0, calldataload(offset)) }
596         require (logEntryHeaderByte == 0xf8, "Log entry is less than 256 bytes long.");
597         offset += 2;
598 
599         uint addressHeaderByte; assembly { addressHeaderByte := byte(0, calldataload(offset)) }
600         require (addressHeaderByte == 0x94, "Address is 20 bytes long.");
601 
602         uint logAddress; assembly { logAddress := and(calldataload(sub(offset, 11)), 0xffffffffffffffffffffffffffffffffffffffff) }
603         require (logAddress == uint(address(this)));
604     }
605 
606     // Memory copy.
607     function memcpy(uint dest, uint src, uint len) pure private {
608         // Full 32 byte words
609         for(; len >= 32; len -= 32) {
610             assembly { mstore(dest, mload(src)) }
611             dest += 32; src += 32;
612         }
613 
614         // Remaining bytes
615         uint mask = 256 ** (32 - len) - 1;
616         assembly {
617             let srcpart := and(mload(src), not(mask))
618             let destpart := and(mload(dest), mask)
619             mstore(dest, or(destpart, srcpart))
620         }
621     }
622 }