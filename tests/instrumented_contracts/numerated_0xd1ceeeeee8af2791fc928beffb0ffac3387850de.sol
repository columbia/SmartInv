1 pragma solidity ^0.4.24;
2 
3 // * dice2.win - fair games that pay Ether. Version 4.
4 //
5 // * Ethereum smart contract, deployed at 0xD1CEeeeee8aF2791fC928beFfB0FFaC3387850DE.
6 //
7 // * Uses hybrid commit-reveal + block hash random number generation that is immune
8 //   to tampering by players, house and miners. Apart from being fully transparent,
9 //   this also allows arbitrarily high bets.
10 //
11 // * Refer to https://dice2.win/whitepaper.pdf for detailed description and proofs.
12 
13 contract Dice2Win {
14     /// *** Constants section
15 
16     // Each bet is deducted 1% in favour of the house, but no less than some minimum.
17     // The lower bound is dictated by gas costs of the settleBet transaction, providing
18     // headroom for up to 10 Gwei prices.
19     uint constant HOUSE_EDGE_PERCENT = 1;
20     uint constant HOUSE_EDGE_MINIMUM_AMOUNT = 0.0003 ether;
21 
22     // Bets lower than this amount do not participate in jackpot rolls (and are
23     // not deducted JACKPOT_FEE).
24     uint constant MIN_JACKPOT_BET = 0.1 ether;
25 
26     // Chance to win jackpot (currently 0.1%) and fee deducted into jackpot fund.
27     uint constant JACKPOT_MODULO = 1000;
28     uint constant JACKPOT_FEE = 0.001 ether;
29 
30     // There is minimum and maximum bets.
31     uint constant MIN_BET = 0.01 ether;
32     uint constant MAX_AMOUNT = 300000 ether;
33 
34     // Modulo is a number of equiprobable outcomes in a game:
35     //  - 2 for coin flip
36     //  - 6 for dice
37     //  - 6*6 = 36 for double dice
38     //  - 100 for etheroll
39     //  - 37 for roulette
40     //  etc.
41     // It's called so because 256-bit entropy is treated like a huge integer and
42     // the remainder of its division by modulo is considered bet outcome.
43     uint constant MAX_MODULO = 100;
44 
45     // For modulos below this threshold rolls are checked against a bit mask,
46     // thus allowing betting on any combination of outcomes. For example, given
47     // modulo 6 for dice, 101000 mask (base-2, big endian) means betting on
48     // 4 and 6; for games with modulos higher than threshold (Etheroll), a simple
49     // limit is used, allowing betting on any outcome in [0, N) range.
50     //
51     // The specific value is dictated by the fact that 256-bit intermediate
52     // multiplication result allows implementing population count efficiently
53     // for numbers that are up to 42 bits, and 40 is the highest multiple of
54     // eight below 42.
55     uint constant MAX_MASK_MODULO = 40;
56 
57     // This is a check on bet mask overflow.
58     uint constant MAX_BET_MASK = 2 ** MAX_MASK_MODULO;
59 
60     // EVM BLOCKHASH opcode can query no further than 256 blocks into the
61     // past. Given that settleBet uses block hash of placeBet as one of
62     // complementary entropy sources, we cannot process bets older than this
63     // threshold. On rare occasions dice2.win croupier may fail to invoke
64     // settleBet in this timespan due to technical issues or extreme Ethereum
65     // congestion; such bets can be refunded via invoking refundBet.
66     uint constant BET_EXPIRATION_BLOCKS = 250;
67 
68     // Some deliberately invalid address to initialize the secret signer with.
69     // Forces maintainers to invoke setSecretSigner before processing any bets.
70     address constant DUMMY_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
71 
72     // Standard contract ownership transfer.
73     address public owner;
74     address private nextOwner;
75 
76     // Adjustable max bet profit. Used to cap bets against dynamic odds.
77     uint public maxProfit;
78 
79     // The address corresponding to a private key used to sign placeBet commits.
80     address public secretSigner;
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
102         // Address of a gambler, used to pay out winning bets.
103         address gambler;
104     }
105 
106     // Mapping from commits to all currently active & processed bets.
107     mapping (uint => Bet) bets;
108 
109     // Events that are issued to make statistic recovery easier.
110     event FailedPayment(address indexed beneficiary, uint amount);
111     event Payment(address indexed beneficiary, uint amount);
112     event JackpotPayment(address indexed beneficiary, uint amount);
113 
114     // This event is emitted in placeBet to record commit in the logs.
115     event Commit(uint commit);
116 
117     // Constructor. Deliberately does not take any parameters.
118     constructor () public {
119         owner = msg.sender;
120         secretSigner = DUMMY_ADDRESS;
121     }
122 
123     // Standard modifier on methods invokable only by contract owner.
124     modifier onlyOwner {
125         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
126         _;
127     }
128 
129     // Standard contract ownership transfer implementation,
130     function approveNextOwner(address _nextOwner) external onlyOwner {
131         require (_nextOwner != owner, "Cannot approve current owner.");
132         nextOwner = _nextOwner;
133     }
134 
135     function acceptNextOwner() external {
136         require (msg.sender == nextOwner, "Can only accept preapproved new owner.");
137         owner = nextOwner;
138     }
139 
140     // Fallback function deliberately left empty. It's primary use case
141     // is to top up the bank roll.
142     function () public payable {
143     }
144 
145     // See comment for "secretSigner" variable.
146     function setSecretSigner(address newSecretSigner) external onlyOwner {
147         secretSigner = newSecretSigner;
148     }
149 
150     // Change max bet reward. Setting this to zero effectively disables betting.
151     function setMaxProfit(uint _maxProfit) public onlyOwner {
152         require (_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
153         maxProfit = _maxProfit;
154     }
155 
156     // This function is used to bump up the jackpot fund. Cannot be used to lower it.
157     function increaseJackpot(uint increaseAmount) external onlyOwner {
158         require (increaseAmount <= address(this).balance, "Increase amount larger than balance.");
159         require (jackpotSize + lockedInBets + increaseAmount <= address(this).balance, "Not enough funds.");
160         jackpotSize += uint128(increaseAmount);
161     }
162 
163     // Funds withdrawal to cover costs of dice2.win operation.
164     function withdrawFunds(address beneficiary, uint withdrawAmount) external onlyOwner {
165         require (withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
166         require (jackpotSize + lockedInBets + withdrawAmount <= address(this).balance, "Not enough funds.");
167         sendFunds(beneficiary, withdrawAmount, withdrawAmount);
168     }
169 
170     // Contract may be destroyed only when there are no ongoing bets,
171     // either settled or refunded. All funds are transferred to contract owner.
172     function kill() external onlyOwner {
173         require (lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
174         selfdestruct(owner);
175     }
176 
177     /// *** Betting logic
178 
179     // Bet states:
180     //  amount == 0 && gambler == 0 - 'clean' (can place a bet)
181     //  amount != 0 && gambler != 0 - 'active' (can be settled or refunded)
182     //  amount == 0 && gambler != 0 - 'processed' (can clean storage)
183     //
184     //  NOTE: Storage cleaning is not implemented in this contract version; it will be added
185     //        with the next upgrade to prevent polluting Ethereum state with expired bets.
186 
187     // Bet placing transaction - issued by the player.
188     //  betMask         - bet outcomes bit mask for modulo <= MAX_MASK_MODULO,
189     //                    [0, betMask) for larger modulos.
190     //  modulo          - game modulo.
191     //  commitLastBlock - number of the maximum block where "commit" is still considered valid.
192     //  commit          - Keccak256 hash of some secret "reveal" random number, to be supplied
193     //                    by the dice2.win croupier bot in the settleBet transaction. Supplying
194     //                    "commit" ensures that "reveal" cannot be changed behind the scenes
195     //                    after placeBet have been mined.
196     //  r, s            - components of ECDSA signature of (commitLastBlock, commit). v is
197     //                    guaranteed to always equal 27.
198     //
199     // Commit, being essentially random 256-bit number, is used as a unique bet identifier in
200     // the 'bets' mapping.
201     //
202     // Commits are signed with a block limit to ensure that they are used at most once - otherwise
203     // it would be possible for a miner to place a bet with a known commit/reveal pair and tamper
204     // with the blockhash. Croupier guarantees that commitLastBlock will always be not greater than
205     // placeBet block number plus BET_EXPIRATION_BLOCKS. See whitepaper for details.
206     function placeBet(uint betMask, uint modulo, uint commitLastBlock, uint commit, bytes32 r, bytes32 s) external payable {
207         // Check that the bet is in 'clean' state.
208         Bet storage bet = bets[commit];
209         require (bet.gambler == address(0), "Bet should be in a 'clean' state.");
210 
211         // Validate input data ranges.
212         uint amount = msg.value;
213         require (modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
214         require (amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
215         require (betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
216 
217         // Check that commit is valid - it has not expired and its signature is valid.
218         require (block.number <= commitLastBlock, "Commit has expired.");
219         bytes32 signatureHash = keccak256(abi.encodePacked(uint40(commitLastBlock), commit));
220         require (secretSigner == ecrecover(signatureHash, 27, r, s), "ECDSA signature is not valid.");
221 
222         uint rollUnder;
223         uint mask;
224 
225         if (modulo <= MAX_MASK_MODULO) {
226             // Small modulo games specify bet outcomes via bit mask.
227             // rollUnder is a number of 1 bits in this mask (population count).
228             // This magic looking formula is an efficient way to compute population
229             // count on EVM for numbers below 2**40. For detailed proof consult
230             // the dice2.win whitepaper.
231             rollUnder = ((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
232             mask = betMask;
233         } else {
234             // Larger modulos specify the right edge of half-open interval of
235             // winning bet outcomes.
236             require (betMask > 0 && betMask <= modulo, "High modulo range, betMask larger than modulo.");
237             rollUnder = betMask;
238         }
239 
240         // Winning amount and jackpot increase.
241         uint possibleWinAmount;
242         uint jackpotFee;
243 
244         (possibleWinAmount, jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
245 
246         // Enforce max profit limit.
247         require (possibleWinAmount <= amount + maxProfit, "maxProfit limit violation.");
248 
249         // Lock funds.
250         lockedInBets += uint128(possibleWinAmount);
251         jackpotSize += uint128(jackpotFee);
252 
253         // Check whether contract has enough funds to process this bet.
254         require (jackpotSize + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
255 
256         // Record commit in logs.
257         emit Commit(commit);
258 
259         // Store bet parameters on blockchain.
260         bet.amount = amount;
261         bet.modulo = uint8(modulo);
262         bet.rollUnder = uint8(rollUnder);
263         bet.placeBlockNumber = uint40(block.number);
264         bet.mask = uint40(mask);
265         bet.gambler = msg.sender;
266     }
267 
268     // Settlement transaction - can in theory be issued by anyone, but is designed to be
269     // handled by the dice2.win croupier bot. To settle a bet with a specific "commit",
270     // settleBet should supply a "reveal" number that would Keccak256-hash to
271     // "commit". "blockHash" is the block hash of placeBet block as seen by croupier; it
272     // is additionally asserted to prevent changing the bet outcomes on Ethereum reorgs.
273     function settleBet(uint reveal, bytes32 blockHash) external {
274         uint commit = uint(keccak256(abi.encodePacked(reveal)));
275 
276         Bet storage bet = bets[commit];
277         uint placeBlockNumber = bet.placeBlockNumber;
278 
279         // Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
280         require (block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
281         require (block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
282         require (blockhash(placeBlockNumber) == blockHash);
283 
284         // Settle bet using reveal and blockHash as entropy sources.
285         settleBetCommon(bet, reveal, blockHash);
286     }
287 
288     // This method is used to settle a bet that was mined into an uncle block. At this
289     // point the player was shown some bet outcome, but the blockhash at placeBet height
290     // is different because of Ethereum chain reorg. We supply a full merkle proof of the
291     // placeBet transaction receipt to provide untamperable evidence that uncle block hash
292     // indeed was present on-chain at some point.
293     function settleBetUncleMerkleProof(uint reveal, uint40 canonicalBlockNumber) external {
294         // "commit" for bet settlement can only be obtained by hashing a "reveal".
295         uint commit = uint(keccak256(abi.encodePacked(reveal)));
296 
297         Bet storage bet = bets[commit];
298 
299         // Check that canonical block hash can still be verified.
300         require (block.number <= canonicalBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
301 
302         // Verify placeBet receipt.
303         requireCorrectReceipt(4 + 32 + 32 + 4);
304 
305         // Reconstruct canonical & uncle block hashes from a receipt merkle proof, verify them.
306         bytes32 canonicalHash;
307         bytes32 uncleHash;
308         (canonicalHash, uncleHash) = verifyMerkleProof(commit, 4 + 32 + 32);
309         require (blockhash(canonicalBlockNumber) == canonicalHash);
310 
311         // Settle bet using reveal and uncleHash as entropy sources.
312         settleBetCommon(bet, reveal, uncleHash);
313     }
314 
315     // Common settlement code for settleBet & settleBetUncleMerkleProof.
316     function settleBetCommon(Bet storage bet, uint reveal, bytes32 entropyBlockHash) private {
317         // Fetch bet parameters into local variables (to save gas).
318         uint amount = bet.amount;
319         uint modulo = bet.modulo;
320         uint rollUnder = bet.rollUnder;
321         address gambler = bet.gambler;
322 
323         // Check that bet is in 'active' state.
324         require (amount != 0, "Bet should be in an 'active' state");
325 
326         // Move bet into 'processed' state already.
327         bet.amount = 0;
328 
329         // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
330         // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
331         // preimage is intractable), and house is unable to alter the "reveal" after
332         // placeBet have been mined (as Keccak256 collision finding is also intractable).
333         bytes32 entropy = keccak256(abi.encodePacked(reveal, entropyBlockHash));
334 
335         // Do a roll by taking a modulo of entropy. Compute winning amount.
336         uint dice = uint(entropy) % modulo;
337 
338         uint diceWinAmount;
339         uint _jackpotFee;
340         (diceWinAmount, _jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
341 
342         uint diceWin = 0;
343         uint jackpotWin = 0;
344 
345         // Determine dice outcome.
346         if (modulo <= MAX_MASK_MODULO) {
347             // For small modulo games, check the outcome against a bit mask.
348             if ((2 ** dice) & bet.mask != 0) {
349                 diceWin = diceWinAmount;
350             }
351 
352         } else {
353             // For larger modulos, check inclusion into half-open interval.
354             if (dice < rollUnder) {
355                 diceWin = diceWinAmount;
356             }
357 
358         }
359 
360         // Unlock the bet amount, regardless of the outcome.
361         lockedInBets -= uint128(diceWinAmount);
362 
363         // Roll for a jackpot (if eligible).
364         if (amount >= MIN_JACKPOT_BET) {
365             // The second modulo, statistically independent from the "main" dice roll.
366             // Effectively you are playing two games at once!
367             uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;
368 
369             // Bingo!
370             if (jackpotRng == 0) {
371                 jackpotWin = jackpotSize;
372                 jackpotSize = 0;
373             }
374         }
375 
376         // Log jackpot win.
377         if (jackpotWin > 0) {
378             emit JackpotPayment(gambler, jackpotWin);
379         }
380 
381         // Send the funds to gambler.
382         sendFunds(gambler, diceWin + jackpotWin == 0 ? 1 wei : diceWin + jackpotWin, diceWin);
383     }
384 
385     // Refund transaction - return the bet amount of a roll that was not processed in a
386     // due timeframe. Processing such blocks is not possible due to EVM limitations (see
387     // BET_EXPIRATION_BLOCKS comment above for details). In case you ever find yourself
388     // in a situation like this, just contact the dice2.win support, however nothing
389     // precludes you from invoking this method yourself.
390     function refundBet(uint commit) external {
391         // Check that bet is in 'active' state.
392         Bet storage bet = bets[commit];
393         uint amount = bet.amount;
394 
395         require (amount != 0, "Bet should be in an 'active' state");
396 
397         // Check that bet has already expired.
398         require (block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
399 
400         // Move bet into 'processed' state, release funds.
401         bet.amount = 0;
402 
403         uint diceWinAmount;
404         uint jackpotFee;
405         (diceWinAmount, jackpotFee) = getDiceWinAmount(amount, bet.modulo, bet.rollUnder);
406 
407         lockedInBets -= uint128(diceWinAmount);
408         jackpotSize -= uint128(jackpotFee);
409 
410         // Send the refund.
411         sendFunds(bet.gambler, amount, amount);
412     }
413 
414     // Get the expected win amount after house edge is subtracted.
415     function getDiceWinAmount(uint amount, uint modulo, uint rollUnder) private pure returns (uint winAmount, uint jackpotFee) {
416         require (0 < rollUnder && rollUnder <= modulo, "Win probability out of range.");
417 
418         jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
419 
420         uint houseEdge = amount * HOUSE_EDGE_PERCENT / 100;
421 
422         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
423             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
424         }
425 
426         require (houseEdge + jackpotFee <= amount, "Bet doesn't even cover house edge.");
427         winAmount = (amount - houseEdge - jackpotFee) * modulo / rollUnder;
428     }
429 
430     // Helper routine to process the payment.
431     function sendFunds(address beneficiary, uint amount, uint successLogAmount) private {
432         if (beneficiary.send(amount)) {
433             emit Payment(beneficiary, successLogAmount);
434         } else {
435             emit FailedPayment(beneficiary, amount);
436         }
437     }
438 
439     // This are some constants making O(1) population count in placeBet possible.
440     // See whitepaper for intuition and proofs behind it.
441     uint constant POPCNT_MULT = 0x0000000000002000000000100000000008000000000400000000020000000001;
442     uint constant POPCNT_MASK = 0x0001041041041041041041041041041041041041041041041041041041041041;
443     uint constant POPCNT_MODULO = 0x3F;
444 
445     // *** Merkle proofs.
446 
447     // This helpers are used to verify cryptographic proofs of placeBet inclusion into
448     // uncle blocks. They are used to prevent bet outcome changing on Ethereum reorgs without
449     // compromising the security of the smart contract. Proof data is appended to the input data
450     // in a simple prefix length format and does not adhere to the ABI.
451     // Invariants checked:
452     //  - receipt trie entry contains a (1) successful transaction (2) directed at this smart
453     //    contract (3) containing commit as a payload.
454     //  - receipt trie entry is a part of a valid merkle proof of a block header
455     //  - the block header is a part of uncle list of some block on canonical chain
456     // The implementation is optimized for gas cost and relies on the specifics of Ethereum internal data structures.
457     // Read the whitepaper for details.
458 
459     // Helper to verify a full merkle proof starting from some seedHash (usually commit). "offset" is the location of the proof
460     // beginning in the calldata.
461     function verifyMerkleProof(uint seedHash, uint offset) pure private returns (bytes32 blockHash, bytes32 uncleHash) {
462         // (Safe) assumption - nobody will write into RAM during this method invocation.
463         uint scratchBuf1;  assembly { scratchBuf1 := mload(0x40) }
464 
465         uint uncleHeaderLength; uint blobLength; uint shift; uint hashSlot;
466 
467         // Verify merkle proofs up to uncle block header. Calldata layout is:
468         //  - 2 byte big-endian slice length
469         //  - 2 byte big-endian offset to the beginning of previous slice hash within the current slice (should be zeroed)
470         //  - followed by the current slice verbatim
471         for (;; offset += blobLength) {
472             assembly { blobLength := and(calldataload(sub(offset, 30)), 0xffff) }
473             if (blobLength == 0) {
474                 // Zero slice length marks the end of uncle proof.
475                 break;
476             }
477 
478             assembly { shift := and(calldataload(sub(offset, 28)), 0xffff) }
479             require (shift < blobLength, "Shift bounds check.");
480 
481             offset += 4;
482             assembly { hashSlot := calldataload(add(offset, shift)) }
483             require (hashSlot == 0, "Non-empty hash slot.");
484 
485             assembly {
486                 calldatacopy(scratchBuf1, offset, blobLength)
487                 mstore(add(scratchBuf1, shift), seedHash)
488                 seedHash := sha3(scratchBuf1, blobLength)
489                 uncleHeaderLength := blobLength
490             }
491         }
492 
493         // At this moment the uncle hash is known.
494         uncleHash = bytes32(seedHash);
495 
496         // Construct the uncle list of a canonical block.
497         uint scratchBuf2 = scratchBuf1 + uncleHeaderLength;
498         uint unclesLength; assembly { unclesLength := and(calldataload(sub(offset, 28)), 0xffff) }
499         uint unclesShift;  assembly { unclesShift := and(calldataload(sub(offset, 26)), 0xffff) }
500         require (unclesShift < unclesLength, "Shift bounds check.");
501 
502         offset += 6;
503         assembly { calldatacopy(scratchBuf2, offset, unclesLength) }
504         memcpy(scratchBuf2 + unclesShift, scratchBuf1, uncleHeaderLength);
505 
506         assembly { seedHash := sha3(scratchBuf2, unclesLength) }
507 
508         offset += unclesLength;
509 
510         // Verify the canonical block header using the computed sha3Uncles.
511         assembly {
512             blobLength := and(calldataload(sub(offset, 30)), 0xffff)
513             shift := and(calldataload(sub(offset, 28)), 0xffff)
514         }
515         require (shift < blobLength, "Shift bounds check.");
516 
517         offset += 4;
518         assembly { hashSlot := calldataload(add(offset, shift)) }
519         require (hashSlot == 0, "Non-empty hash slot.");
520 
521         assembly {
522             calldatacopy(scratchBuf1, offset, blobLength)
523             mstore(add(scratchBuf1, shift), seedHash)
524 
525             // At this moment the canonical block hash is known.
526             blockHash := sha3(scratchBuf1, blobLength)
527         }
528     }
529 
530     // Helper to check the placeBet receipt. "offset" is the location of the proof beginning in the calldata.
531     // RLP layout: [triePath, str([status, cumGasUsed, bloomFilter, [[address, [topics], data]])]
532     function requireCorrectReceipt(uint offset) view private {
533         uint leafHeaderByte; assembly { leafHeaderByte := byte(0, calldataload(offset)) }
534 
535         require (leafHeaderByte >= 0xf7, "Receipt leaf longer than 55 bytes.");
536         offset += leafHeaderByte - 0xf6;
537 
538         uint pathHeaderByte; assembly { pathHeaderByte := byte(0, calldataload(offset)) }
539 
540         if (pathHeaderByte <= 0x7f) {
541             offset += 1;
542 
543         } else {
544             require (pathHeaderByte >= 0x80 && pathHeaderByte <= 0xb7, "Path is an RLP string.");
545             offset += pathHeaderByte - 0x7f;
546         }
547 
548         uint receiptStringHeaderByte; assembly { receiptStringHeaderByte := byte(0, calldataload(offset)) }
549         require (receiptStringHeaderByte == 0xb9, "Receipt string is always at least 256 bytes long, but less than 64k.");
550         offset += 3;
551 
552         uint receiptHeaderByte; assembly { receiptHeaderByte := byte(0, calldataload(offset)) }
553         require (receiptHeaderByte == 0xf9, "Receipt is always at least 256 bytes long, but less than 64k.");
554         offset += 3;
555 
556         uint statusByte; assembly { statusByte := byte(0, calldataload(offset)) }
557         require (statusByte == 0x1, "Status should be success.");
558         offset += 1;
559 
560         uint cumGasHeaderByte; assembly { cumGasHeaderByte := byte(0, calldataload(offset)) }
561         if (cumGasHeaderByte <= 0x7f) {
562             offset += 1;
563 
564         } else {
565             require (cumGasHeaderByte >= 0x80 && cumGasHeaderByte <= 0xb7, "Cumulative gas is an RLP string.");
566             offset += cumGasHeaderByte - 0x7f;
567         }
568 
569         uint bloomHeaderByte; assembly { bloomHeaderByte := byte(0, calldataload(offset)) }
570         require (bloomHeaderByte == 0xb9, "Bloom filter is always 256 bytes long.");
571         offset += 256 + 3;
572 
573         uint logsListHeaderByte; assembly { logsListHeaderByte := byte(0, calldataload(offset)) }
574         require (logsListHeaderByte == 0xf8, "Logs list is less than 256 bytes long.");
575         offset += 2;
576 
577         uint logEntryHeaderByte; assembly { logEntryHeaderByte := byte(0, calldataload(offset)) }
578         require (logEntryHeaderByte == 0xf8, "Log entry is less than 256 bytes long.");
579         offset += 2;
580 
581         uint addressHeaderByte; assembly { addressHeaderByte := byte(0, calldataload(offset)) }
582         require (addressHeaderByte == 0x94, "Address is 20 bytes long.");
583 
584         uint logAddress; assembly { logAddress := and(calldataload(sub(offset, 11)), 0xffffffffffffffffffffffffffffffffffffffff) }
585         require (logAddress == uint(address(this)));
586     }
587 
588     // Memory copy.
589     function memcpy(uint dest, uint src, uint len) pure private {
590         // Full 32 byte words
591         for(; len >= 32; len -= 32) {
592             assembly { mstore(dest, mload(src)) }
593             dest += 32; src += 32;
594         }
595 
596         // Remaining bytes
597         uint mask = 256 ** (32 - len) - 1;
598         assembly {
599             let srcpart := and(mload(src), not(mask))
600             let destpart := and(mload(dest), mask)
601             mstore(dest, or(destpart, srcpart))
602         }
603     }
604 }