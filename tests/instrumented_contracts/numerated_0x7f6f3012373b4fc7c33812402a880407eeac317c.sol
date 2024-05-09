1 pragma solidity ^0.4.24;
2 
3 // * Uses hybrid commit-reveal + block hash random number generation that is immune
4 //   to tampering by players, house and miners. Apart from being fully transparent,
5 //   this also allows arbitrarily high bets.
6 
7 contract FairWin {
8     /// *** Constants section
9 
10     // Each bet is deducted 1% in favour of the house, but no less than some minimum.
11     // The lower bound is dictated by gas costs of the settleBet transaction, providing
12     // headroom for up to 10 Gwei prices.
13     uint constant HOUSE_EDGE_PERCENT = 1;
14     uint constant HOUSE_EDGE_MINIMUM_AMOUNT = 0.0003 ether;
15 
16     // Bets lower than this amount do not participate in jackpot rolls (and are
17     // not deducted JACKPOT_FEE).
18     uint constant MIN_JACKPOT_BET = 0.1 ether;
19 
20     // Chance to win jackpot (currently 0.1%) and fee deducted into jackpot fund.
21     uint constant JACKPOT_MODULO = 1000;
22     uint constant JACKPOT_FEE = 0.001 ether;
23 
24     // There is minimum and maximum bets.
25     uint constant MIN_BET = 0.01 ether;
26     uint constant MAX_AMOUNT = 300000 ether;
27 
28     // Modulo is a number of equiprobable outcomes in a game:
29     //  - 2 for coin flip
30     //  - 6 for dice
31     //  - 6*6 = 36 for double dice
32     //  - 100 for etheroll
33     //  - 37 for roulette
34     //  etc.
35     // It's called so because 256-bit entropy is treated like a huge integer and
36     // the remainder of its division by modulo is considered bet outcome.
37     uint constant MAX_MODULO = 100;
38 
39     // For modulos below this threshold rolls are checked against a bit mask,
40     // thus allowing betting on any combination of outcomes. For example, given
41     // modulo 6 for dice, 101000 mask (base-2, big endian) means betting on
42     // 4 and 6; for games with modulos higher than threshold (Etheroll), a simple
43     // limit is used, allowing betting on any outcome in [0, N) range.
44     //
45     // The specific value is dictated by the fact that 256-bit intermediate
46     // multiplication result allows implementing population count efficiently
47     // for numbers that are up to 42 bits, and 40 is the highest multiple of
48     // eight below 42.
49     uint constant MAX_MASK_MODULO = 40;
50 
51     // This is a check on bet mask overflow.
52     uint constant MAX_BET_MASK = 2 ** MAX_MASK_MODULO;
53 
54     // EVM BLOCKHASH opcode can query no further than 256 blocks into the
55     // past. Given that settleBet uses block hash of placeBet as one of
56     // complementary entropy sources, we cannot process bets older than this
57     // threshold. On rare occasions croupier may fail to invoke
58     // settleBet in this timespan due to technical issues or extreme Ethereum
59     // congestion; such bets can be refunded via invoking refundBet.
60     uint constant BET_EXPIRATION_BLOCKS = 250;
61 
62     // Some deliberately invalid address to initialize the secret signer with.
63     // Forces maintainers to invoke setSecretSigner before processing any bets.
64     address constant DUMMY_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
65 
66     // Standard contract ownership transfer.
67     address public owner;
68     address private nextOwner;
69 
70     // Adjustable max bet profit. Used to cap bets against dynamic odds.
71     uint public maxProfit;
72 
73     // The address corresponding to a private key used to sign placeBet commits.
74     address public secretSigner;
75 
76     // Accumulated jackpot fund.
77     uint128 public jackpotSize;
78 
79     // Funds that are locked in potentially winning bets. Prevents contract from
80     // committing to bets it cannot pay out.
81     uint128 public lockedInBets;
82 
83     // A structure representing a single bet.
84     struct Bet {
85         // Wager amount in wei.
86         uint amount;
87         // Modulo of a game.
88         uint8 modulo;
89         // Number of winning outcomes, used to compute winning payment (* modulo/rollUnder),
90         // and used instead of mask for games with modulo > MAX_MASK_MODULO.
91         uint8 rollUnder;
92         // Block number of placeBet tx.
93         uint40 placeBlockNumber;
94         // Bit mask representing winning bet outcomes (see MAX_MASK_MODULO comment).
95         uint40 mask;
96         // Address of a gambler, used to pay out winning bets.
97         address gambler;
98     }
99 
100     // Mapping from commits to all currently active & processed bets.
101     mapping (uint => Bet) bets;
102 
103     // Croupier account.
104     address public croupier;
105 
106     // Events that are issued to make statistic recovery easier.
107     event FailedPayment(address indexed beneficiary, uint amount);
108     event Payment(address indexed beneficiary, uint amount);
109     event JackpotPayment(address indexed beneficiary, uint amount);
110 
111     // This event is emitted in placeBet to record commit in the logs.
112     event Commit(uint commit);
113 
114     // Constructor. Deliberately does not take any parameters.
115     constructor () public {
116         owner = msg.sender;
117         secretSigner = DUMMY_ADDRESS;
118         croupier = DUMMY_ADDRESS;
119     }
120 
121     // Standard modifier on methods invokable only by contract owner.
122     modifier onlyOwner {
123         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
124         _;
125     }
126 
127     // Standard modifier on methods invokable only by contract owner.
128     modifier onlyCroupier {
129         require (msg.sender == croupier, "OnlyCroupier methods called by non-croupier.");
130         _;
131     }
132 
133     // Standard contract ownership transfer implementation,
134     function approveNextOwner(address _nextOwner) external onlyOwner {
135         require (_nextOwner != owner, "Cannot approve current owner.");
136         nextOwner = _nextOwner;
137     }
138 
139     function acceptNextOwner() external {
140         require (msg.sender == nextOwner, "Can only accept preapproved new owner.");
141         owner = nextOwner;
142     }
143 
144     // Fallback function deliberately left empty. It's primary use case
145     // is to top up the bank roll.
146     function () public payable {
147     }
148 
149     // See comment for "secretSigner" variable.
150     function setSecretSigner(address newSecretSigner) external onlyOwner {
151         secretSigner = newSecretSigner;
152     }
153 
154     // Change the croupier address.
155     function setCroupier(address newCroupier) external onlyOwner {
156         croupier = newCroupier;
157     }
158 
159     // Change max bet reward. Setting this to zero effectively disables betting.
160     function setMaxProfit(uint _maxProfit) public onlyOwner {
161         require (_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
162         maxProfit = _maxProfit;
163     }
164 
165     // This function is used to bump up the jackpot fund. Cannot be used to lower it.
166     function increaseJackpot(uint increaseAmount) external onlyOwner {
167         require (increaseAmount <= address(this).balance, "Increase amount larger than balance.");
168         require (jackpotSize + lockedInBets + increaseAmount <= address(this).balance, "Not enough funds.");
169         jackpotSize += uint128(increaseAmount);
170     }
171 
172     // Funds withdrawal to cover costs of fairwin operation.
173     function withdrawFunds(address beneficiary, uint withdrawAmount) external onlyOwner {
174         require (withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
175         require (jackpotSize + lockedInBets + withdrawAmount <= address(this).balance, "Not enough funds.");
176         sendFunds(beneficiary, withdrawAmount, withdrawAmount);
177     }
178 
179     // Contract may be destroyed only when there are no ongoing bets,
180     // either settled or refunded. All funds are transferred to contract owner.
181     function kill() external onlyOwner {
182         require (lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
183         selfdestruct(owner);
184     }
185 
186     /// *** Betting logic
187 
188     // Bet states:
189     //  amount == 0 && gambler == 0 - 'clean' (can place a bet)
190     //  amount != 0 && gambler != 0 - 'active' (can be settled or refunded)
191     //  amount == 0 && gambler != 0 - 'processed' (can clean storage)
192     //
193     //  NOTE: Storage cleaning is not implemented in this contract version; it will be added
194     //        with the next upgrade to prevent polluting Ethereum state with expired bets.
195 
196     // Bet placing transaction - issued by the player.
197     //  betMask         - bet outcomes bit mask for modulo <= MAX_MASK_MODULO,
198     //                    [0, betMask) for larger modulos.
199     //  modulo          - game modulo.
200     //  commitLastBlock - number of the maximum block where "commit" is still considered valid.
201     //  commit          - Keccak256 hash of some secret "reveal" random number, to be supplied
202     //                    by the fairwin croupier bot in the settleBet transaction. Supplying
203     //                    "commit" ensures that "reveal" cannot be changed behind the scenes
204     //                    after placeBet have been mined.
205     //  r, s            - components of ECDSA signature of (commitLastBlock, commit). v is
206     //                    guaranteed to always equal 27.
207     //
208     // Commit, being essentially random 256-bit number, is used as a unique bet identifier in
209     // the 'bets' mapping.
210     //
211     // Commits are signed with a block limit to ensure that they are used at most once - otherwise
212     // it would be possible for a miner to place a bet with a known commit/reveal pair and tamper
213     // with the blockhash. Croupier guarantees that commitLastBlock will always be not greater than
214     // placeBet block number plus BET_EXPIRATION_BLOCKS. See whitepaper for details.
215     function placeBet(uint betMask, uint modulo, uint commitLastBlock, uint commit, bytes32 r, bytes32 s) external payable {
216         // Check that the bet is in 'clean' state.
217         Bet storage bet = bets[commit];
218         require (bet.gambler == address(0), "Bet should be in a 'clean' state.");
219 
220         // Validate input data ranges.
221         uint amount = msg.value;
222         require (modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
223         require (amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
224         require (betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
225 
226         // Check that commit is valid - it has not expired and its signature is valid.
227         require (block.number <= commitLastBlock, "Commit has expired.");
228         bytes32 signatureHash = keccak256(abi.encodePacked(uint40(commitLastBlock), commit));
229         require (secretSigner == ecrecover(signatureHash, 27, r, s), "ECDSA signature is not valid.");
230 
231         uint rollUnder;
232         uint mask;
233 
234         if (modulo <= MAX_MASK_MODULO) {
235 
236             rollUnder = ((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
237             mask = betMask;
238         } else {
239             // Larger modulos specify the right edge of half-open interval of
240             // winning bet outcomes.
241             require (betMask > 0 && betMask <= modulo, "High modulo range, betMask larger than modulo.");
242             rollUnder = betMask;
243         }
244 
245         // Winning amount and jackpot increase.
246         uint possibleWinAmount;
247         uint jackpotFee;
248 
249         (possibleWinAmount, jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
250 
251         // Enforce max profit limit.
252         require (possibleWinAmount <= amount + maxProfit, "maxProfit limit violation.");
253 
254         // Lock funds.
255         lockedInBets += uint128(possibleWinAmount);
256         jackpotSize += uint128(jackpotFee);
257 
258         // Check whether contract has enough funds to process this bet.
259         require (jackpotSize + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
260 
261         // Record commit in logs.
262         emit Commit(commit);
263 
264         // Store bet parameters on blockchain.
265         bet.amount = amount;
266         bet.modulo = uint8(modulo);
267         bet.rollUnder = uint8(rollUnder);
268         bet.placeBlockNumber = uint40(block.number);
269         bet.mask = uint40(mask);
270         bet.gambler = msg.sender;
271     }
272 
273     // This is the method used to settle 99% of bets. To process a bet with a specific
274     // "commit", settleBet should supply a "reveal" number that would Keccak256-hash to
275     // "commit". "blockHash" is the block hash of placeBet block as seen by croupier; it
276     // is additionally asserted to prevent changing the bet outcomes on Ethereum reorgs.
277     function settleBet(uint reveal, bytes32 blockHash) external onlyCroupier {
278         uint commit = uint(keccak256(abi.encodePacked(reveal)));
279 
280         Bet storage bet = bets[commit];
281         uint placeBlockNumber = bet.placeBlockNumber;
282 
283         // Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
284         require (block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
285         require (block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
286         require (blockhash(placeBlockNumber) == blockHash);
287 
288         // Settle bet using reveal and blockHash as entropy sources.
289         settleBetCommon(bet, reveal, blockHash);
290     }
291 
292     // This method is used to settle a bet that was mined into an uncle block. At this
293     // point the player was shown some bet outcome, but the blockhash at placeBet height
294     // is different because of Ethereum chain reorg. We supply a full merkle proof of the
295     // placeBet transaction receipt to provide untamperable evidence that uncle block hash
296     // indeed was present on-chain at some point.
297     function settleBetUncleMerkleProof(uint reveal, uint40 canonicalBlockNumber) external onlyCroupier {
298         // "commit" for bet settlement can only be obtained by hashing a "reveal".
299         uint commit = uint(keccak256(abi.encodePacked(reveal)));
300 
301         Bet storage bet = bets[commit];
302 
303         // Check that canonical block hash can still be verified.
304         require (block.number <= canonicalBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
305 
306         // Verify placeBet receipt.
307         requireCorrectReceipt(4 + 32 + 32 + 4);
308 
309         // Reconstruct canonical & uncle block hashes from a receipt merkle proof, verify them.
310         bytes32 canonicalHash;
311         bytes32 uncleHash;
312         (canonicalHash, uncleHash) = verifyMerkleProof(commit, 4 + 32 + 32);
313         require (blockhash(canonicalBlockNumber) == canonicalHash);
314 
315         // Settle bet using reveal and uncleHash as entropy sources.
316         settleBetCommon(bet, reveal, uncleHash);
317     }
318 
319     // Common settlement code for settleBet & settleBetUncleMerkleProof.
320     function settleBetCommon(Bet storage bet, uint reveal, bytes32 entropyBlockHash) private {
321         // Fetch bet parameters into local variables (to save gas).
322         uint amount = bet.amount;
323         uint modulo = bet.modulo;
324         uint rollUnder = bet.rollUnder;
325         address gambler = bet.gambler;
326 
327         // Check that bet is in 'active' state.
328         require (amount != 0, "Bet should be in an 'active' state");
329 
330         // Move bet into 'processed' state already.
331         bet.amount = 0;
332 
333         // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
334         // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
335         // preimage is intractable), and house is unable to alter the "reveal" after
336         // placeBet have been mined (as Keccak256 collision finding is also intractable).
337         bytes32 entropy = keccak256(abi.encodePacked(reveal, entropyBlockHash));
338 
339         // Do a roll by taking a modulo of entropy. Compute winning amount.
340         uint dice = uint(entropy) % modulo;
341 
342         uint diceWinAmount;
343         uint _jackpotFee;
344         (diceWinAmount, _jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
345 
346         uint diceWin = 0;
347         uint jackpotWin = 0;
348 
349         // Determine dice outcome.
350         if (modulo <= MAX_MASK_MODULO) {
351             // For small modulo games, check the outcome against a bit mask.
352             if ((2 ** dice) & bet.mask != 0) {
353                 diceWin = diceWinAmount;
354             }
355 
356         } else {
357             // For larger modulos, check inclusion into half-open interval.
358             if (dice < rollUnder) {
359                 diceWin = diceWinAmount;
360             }
361 
362         }
363 
364         // Unlock the bet amount, regardless of the outcome.
365         lockedInBets -= uint128(diceWinAmount);
366 
367         // Roll for a jackpot (if eligible).
368         if (amount >= MIN_JACKPOT_BET) {
369             // The second modulo, statistically independent from the "main" dice roll.
370             // Effectively you are playing two games at once!
371             uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;
372 
373             // Bingo!
374             if (jackpotRng == 0) {
375                 jackpotWin = jackpotSize;
376                 jackpotSize = 0;
377             }
378         }
379 
380         // Log jackpot win.
381         if (jackpotWin > 0) {
382             emit JackpotPayment(gambler, jackpotWin);
383         }
384 
385         // Send the funds to gambler.
386         sendFunds(gambler, diceWin + jackpotWin == 0 ? 1 wei : diceWin + jackpotWin, diceWin);
387     }
388 
389     // Refund transaction - return the bet amount of a roll that was not processed in a
390     // due timeframe. Processing such blocks is not possible due to EVM limitations (see
391     // BET_EXPIRATION_BLOCKS comment above for details). In case you ever find yourself
392     // in a situation like this, just contact the fairwin support, however nothing
393     // precludes you from invoking this method yourself.
394     function refundBet(uint commit) external {
395         // Check that bet is in 'active' state.
396         Bet storage bet = bets[commit];
397         uint amount = bet.amount;
398 
399         require (amount != 0, "Bet should be in an 'active' state");
400 
401         // Check that bet has already expired.
402         require (block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
403 
404         // Move bet into 'processed' state, release funds.
405         bet.amount = 0;
406 
407         uint diceWinAmount;
408         uint jackpotFee;
409         (diceWinAmount, jackpotFee) = getDiceWinAmount(amount, bet.modulo, bet.rollUnder);
410 
411         lockedInBets -= uint128(diceWinAmount);
412         jackpotSize -= uint128(jackpotFee);
413 
414         // Send the refund.
415         sendFunds(bet.gambler, amount, amount);
416     }
417 
418     // Get the expected win amount after house edge is subtracted.
419     function getDiceWinAmount(uint amount, uint modulo, uint rollUnder) private pure returns (uint winAmount, uint jackpotFee) {
420         require (0 < rollUnder && rollUnder <= modulo, "Win probability out of range.");
421 
422         jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
423 
424         uint houseEdge = amount * HOUSE_EDGE_PERCENT / 100;
425 
426         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
427             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
428         }
429 
430         require (houseEdge + jackpotFee <= amount, "Bet doesn't even cover house edge.");
431         winAmount = (amount - houseEdge - jackpotFee) * modulo / rollUnder;
432     }
433 
434     // Helper routine to process the payment.
435     function sendFunds(address beneficiary, uint amount, uint successLogAmount) private {
436         if (beneficiary.send(amount)) {
437             emit Payment(beneficiary, successLogAmount);
438         } else {
439             emit FailedPayment(beneficiary, amount);
440         }
441     }
442 
443     // This are some constants making O(1) population count in placeBet possible.
444     // See whitepaper for intuition and proofs behind it.
445     uint constant POPCNT_MULT = 0x0000000000002000000000100000000008000000000400000000020000000001;
446     uint constant POPCNT_MASK = 0x0001041041041041041041041041041041041041041041041041041041041041;
447     uint constant POPCNT_MODULO = 0x3F;
448 
449     // *** Merkle proofs.
450 
451     // This helpers are used to verify cryptographic proofs of placeBet inclusion into
452     // uncle blocks. They are used to prevent bet outcome changing on Ethereum reorgs without
453     // compromising the security of the smart contract. Proof data is appended to the input data
454     // in a simple prefix length format and does not adhere to the ABI.
455     // Invariants checked:
456     //  - receipt trie entry contains a (1) successful transaction (2) directed at this smart
457     //    contract (3) containing commit as a payload.
458     //  - receipt trie entry is a part of a valid merkle proof of a block header
459     //  - the block header is a part of uncle list of some block on canonical chain
460     // The implementation is optimized for gas cost and relies on the specifics of Ethereum internal data structures.
461     // Read the whitepaper for details.
462 
463     // Helper to verify a full merkle proof starting from some seedHash (usually commit). "offset" is the location of the proof
464     // beginning in the calldata.
465     function verifyMerkleProof(uint seedHash, uint offset) pure private returns (bytes32 blockHash, bytes32 uncleHash) {
466         // (Safe) assumption - nobody will write into RAM during this method invocation.
467         uint scratchBuf1;  assembly { scratchBuf1 := mload(0x40) }
468 
469         uint uncleHeaderLength; uint blobLength; uint shift; uint hashSlot;
470 
471         // Verify merkle proofs up to uncle block header. Calldata layout is:
472         //  - 2 byte big-endian slice length
473         //  - 2 byte big-endian offset to the beginning of previous slice hash within the current slice (should be zeroed)
474         //  - followed by the current slice verbatim
475         for (;; offset += blobLength) {
476             assembly { blobLength := and(calldataload(sub(offset, 30)), 0xffff) }
477             if (blobLength == 0) {
478                 // Zero slice length marks the end of uncle proof.
479                 break;
480             }
481 
482             assembly { shift := and(calldataload(sub(offset, 28)), 0xffff) }
483             require (shift + 32 <= blobLength, "Shift bounds check.");
484 
485             offset += 4;
486             assembly { hashSlot := calldataload(add(offset, shift)) }
487             require (hashSlot == 0, "Non-empty hash slot.");
488 
489             assembly {
490                 calldatacopy(scratchBuf1, offset, blobLength)
491                 mstore(add(scratchBuf1, shift), seedHash)
492                 seedHash := sha3(scratchBuf1, blobLength)
493                 uncleHeaderLength := blobLength
494             }
495         }
496 
497         // At this moment the uncle hash is known.
498         uncleHash = bytes32(seedHash);
499 
500         // Construct the uncle list of a canonical block.
501         uint scratchBuf2 = scratchBuf1 + uncleHeaderLength;
502         uint unclesLength; assembly { unclesLength := and(calldataload(sub(offset, 28)), 0xffff) }
503         uint unclesShift;  assembly { unclesShift := and(calldataload(sub(offset, 26)), 0xffff) }
504         require (unclesShift + uncleHeaderLength <= unclesLength, "Shift bounds check.");
505 
506         offset += 6;
507         assembly { calldatacopy(scratchBuf2, offset, unclesLength) }
508         memcpy(scratchBuf2 + unclesShift, scratchBuf1, uncleHeaderLength);
509 
510         assembly { seedHash := sha3(scratchBuf2, unclesLength) }
511 
512         offset += unclesLength;
513 
514         // Verify the canonical block header using the computed sha3Uncles.
515         assembly {
516             blobLength := and(calldataload(sub(offset, 30)), 0xffff)
517             shift := and(calldataload(sub(offset, 28)), 0xffff)
518         }
519         require (shift + 32 <= blobLength, "Shift bounds check.");
520 
521         offset += 4;
522         assembly { hashSlot := calldataload(add(offset, shift)) }
523         require (hashSlot == 0, "Non-empty hash slot.");
524 
525         assembly {
526             calldatacopy(scratchBuf1, offset, blobLength)
527             mstore(add(scratchBuf1, shift), seedHash)
528 
529             // At this moment the canonical block hash is known.
530             blockHash := sha3(scratchBuf1, blobLength)
531         }
532     }
533 
534     // Helper to check the placeBet receipt. "offset" is the location of the proof beginning in the calldata.
535     // RLP layout: [triePath, str([status, cumGasUsed, bloomFilter, [[address, [topics], data]])]
536     function requireCorrectReceipt(uint offset) view private {
537         uint leafHeaderByte; assembly { leafHeaderByte := byte(0, calldataload(offset)) }
538 
539         require (leafHeaderByte >= 0xf7, "Receipt leaf longer than 55 bytes.");
540         offset += leafHeaderByte - 0xf6;
541 
542         uint pathHeaderByte; assembly { pathHeaderByte := byte(0, calldataload(offset)) }
543 
544         if (pathHeaderByte <= 0x7f) {
545             offset += 1;
546 
547         } else {
548             require (pathHeaderByte >= 0x80 && pathHeaderByte <= 0xb7, "Path is an RLP string.");
549             offset += pathHeaderByte - 0x7f;
550         }
551 
552         uint receiptStringHeaderByte; assembly { receiptStringHeaderByte := byte(0, calldataload(offset)) }
553         require (receiptStringHeaderByte == 0xb9, "Receipt string is always at least 256 bytes long, but less than 64k.");
554         offset += 3;
555 
556         uint receiptHeaderByte; assembly { receiptHeaderByte := byte(0, calldataload(offset)) }
557         require (receiptHeaderByte == 0xf9, "Receipt is always at least 256 bytes long, but less than 64k.");
558         offset += 3;
559 
560         uint statusByte; assembly { statusByte := byte(0, calldataload(offset)) }
561         require (statusByte == 0x1, "Status should be success.");
562         offset += 1;
563 
564         uint cumGasHeaderByte; assembly { cumGasHeaderByte := byte(0, calldataload(offset)) }
565         if (cumGasHeaderByte <= 0x7f) {
566             offset += 1;
567 
568         } else {
569             require (cumGasHeaderByte >= 0x80 && cumGasHeaderByte <= 0xb7, "Cumulative gas is an RLP string.");
570             offset += cumGasHeaderByte - 0x7f;
571         }
572 
573         uint bloomHeaderByte; assembly { bloomHeaderByte := byte(0, calldataload(offset)) }
574         require (bloomHeaderByte == 0xb9, "Bloom filter is always 256 bytes long.");
575         offset += 256 + 3;
576 
577         uint logsListHeaderByte; assembly { logsListHeaderByte := byte(0, calldataload(offset)) }
578         require (logsListHeaderByte == 0xf8, "Logs list is less than 256 bytes long.");
579         offset += 2;
580 
581         uint logEntryHeaderByte; assembly { logEntryHeaderByte := byte(0, calldataload(offset)) }
582         require (logEntryHeaderByte == 0xf8, "Log entry is less than 256 bytes long.");
583         offset += 2;
584 
585         uint addressHeaderByte; assembly { addressHeaderByte := byte(0, calldataload(offset)) }
586         require (addressHeaderByte == 0x94, "Address is 20 bytes long.");
587 
588         uint logAddress; assembly { logAddress := and(calldataload(sub(offset, 11)), 0xffffffffffffffffffffffffffffffffffffffff) }
589         require (logAddress == uint(address(this)));
590     }
591 
592     // Memory copy.
593     function memcpy(uint dest, uint src, uint len) pure private {
594         // Full 32 byte words
595         for(; len >= 32; len -= 32) {
596             assembly { mstore(dest, mload(src)) }
597             dest += 32; src += 32;
598         }
599 
600         // Remaining bytes
601         uint mask = 256 ** (32 - len) - 1;
602         assembly {
603             let srcpart := and(mload(src), not(mask))
604             let destpart := and(mload(dest), mask)
605             mstore(dest, or(destpart, srcpart))
606         }
607     }
608 }