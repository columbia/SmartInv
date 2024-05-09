1 // File: contracts\Play2Win.sol
2 
3 pragma solidity ^0.5.0;
4 
5 // * Ethereum smart contract
6 //
7 // * Uses hybrid commit-reveal + block hash random number generation that is immune
8 //   to tampering by players, house and miners. Apart from being fully transparent,
9 //   this also allows arbitrarily high bets.
10 
11 contract Play2Win {
12     /// *** Constants section
13 
14     // Each bet is deducted 1% in favour of the house, but no less than some minimum.
15     // The lower bound is dictated by gas costs of the settleBet transaction, providing
16     // headroom for up to 10 Gwei prices.
17     uint constant HOUSE_EDGE_PERCENT = 1;
18     uint constant HOUSE_EDGE_MINIMUM_AMOUNT = 0.0003 ether;
19 
20     // Bets lower than this amount do not participate in jackpot rolls (and are
21     // not deducted JACKPOT_FEE).
22     uint constant MIN_JACKPOT_BET = 0.1 ether;
23 
24     // Chance to win jackpot (currently 0.1%) and fee deducted into jackpot fund.
25     uint constant JACKPOT_MODULO = 1000;
26     uint constant JACKPOT_FEE = 0.001 ether;
27 
28     // There is minimum and maximum bets.
29     uint constant MIN_BET = 0.01 ether;
30     uint constant MAX_AMOUNT = 300000 ether;
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
61     // threshold. On rare occasions play2.win croupier may fail to invoke
62     // settleBet in this timespan due to technical issues or extreme Ethereum
63     // congestion; such bets can be refunded via invoking refundBet.
64     uint constant BET_EXPIRATION_BLOCKS = 250;
65 
66     // Some deliberately invalid address to initialize the secret signer with.
67     // Forces maintainers to invoke setSecretSigner before processing any bets.
68     address constant DUMMY_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
69 
70     // Standard contract ownership transfer.
71     address public owner;
72     address private nextOwner;
73 
74     // Adjustable max bet profit. Used to cap bets against dynamic odds.
75     uint public maxProfit;
76 
77     // The address corresponding to a private key used to sign placeBet commits.
78     address public secretSigner;
79 
80     // Accumulated jackpot fund.
81     uint128 public jackpotSize;
82 
83     // Funds that are locked in potentially winning bets. Prevents contract from
84     // committing to bets it cannot pay out.
85     uint128 public lockedInBets;
86 
87     // A structure representing a single bet.
88     struct Bet {
89         // Wager amount in wei.
90         uint amount;
91         // Modulo of a game.
92         uint8 modulo;
93         // Number of winning outcomes, used to compute winning payment (* modulo/rollUnder),
94         // and used instead of mask for games with modulo > MAX_MASK_MODULO.
95         uint8 rollUnder;
96         // Block number of placeBet tx.
97         uint40 placeBlockNumber;
98         // Bit mask representing winning bet outcomes (see MAX_MASK_MODULO comment).
99         uint40 mask;
100         // Address of a gambler, used to pay out winning bets.
101         address gambler;
102     }
103 
104     // Mapping from commits to all currently active & processed bets.
105     mapping (uint => Bet) public bets;
106 
107     // Croupier account.
108     address public croupier;
109 
110     // Events that are issued to make statistic recovery easier.
111     event FailedPayment(address indexed beneficiary, uint amount);
112     event Payment(address indexed beneficiary, uint amount);
113     event JackpotPayment(address indexed beneficiary, uint amount);
114 
115     // This event is emitted in placeBet to record commit in the logs.
116     event Commit(uint commit);
117 
118     // Constructor. Deliberately does not take any parameters.
119     constructor () public {
120         owner = msg.sender;
121         secretSigner = DUMMY_ADDRESS;
122         croupier = DUMMY_ADDRESS;
123     }
124 
125     // Standard modifier on methods invokable only by contract owner.
126     modifier onlyOwner {
127         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
128         _;
129     }
130 
131     // Standard modifier on methods invokable only by contract owner.
132     modifier onlyCroupier {
133         require (msg.sender == croupier, "OnlyCroupier methods called by non-croupier.");
134         _;
135     }
136 
137     // Standard contract ownership transfer implementation,
138     function approveNextOwner(address _nextOwner) external onlyOwner {
139         require (_nextOwner != owner, "Cannot approve current owner.");
140         nextOwner = _nextOwner;
141     }
142 
143     function acceptNextOwner() external {
144         require (msg.sender == nextOwner, "Can only accept preapproved new owner.");
145         owner = nextOwner;
146     }
147 
148     // Fallback function deliberately left empty. It's primary use case
149     // is to top up the bank roll.
150     function () external payable {
151     }
152 
153     // See comment for "secretSigner" variable.
154     function setSecretSigner(address newSecretSigner) external onlyOwner {
155         secretSigner = newSecretSigner;
156     }
157 
158     // Change the croupier address.
159     function setCroupier(address newCroupier) external onlyOwner {
160         croupier = newCroupier;
161     }
162 
163     // Change max bet reward. Setting this to zero effectively disables betting.
164     function setMaxProfit(uint _maxProfit) public onlyOwner {
165         require (_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
166         maxProfit = _maxProfit;
167     }
168 
169     // This function is used to bump up the jackpot fund. Cannot be used to lower it.
170     function increaseJackpot(uint increaseAmount) external onlyOwner {
171         require (increaseAmount <= address(this).balance, "Increase amount larger than balance.");
172         require (jackpotSize + lockedInBets + increaseAmount <= address(this).balance, "Not enough funds.");
173         jackpotSize += uint128(increaseAmount);
174     }
175 
176     // Funds withdrawal to cover costs of play2.win operation.
177     function withdrawFunds(address beneficiary, uint withdrawAmount) external onlyOwner {
178         require (withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
179         require (jackpotSize + lockedInBets + withdrawAmount <= address(this).balance, "Not enough funds.");
180         sendFunds(beneficiary, withdrawAmount, withdrawAmount);
181     }
182 
183     function changeLockedInBets(uint128 amount) external onlyOwner {
184         lockedInBets = amount;
185     }
186 
187     // Contract may be destroyed only when there are no ongoing bets,
188     // either settled or refunded. All funds are transferred to contract owner.
189     function kill() external onlyOwner {
190         require (lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
191         address payable tmp;
192         tmp = address(uint160(owner));
193         selfdestruct(tmp);
194     }
195 
196     /// *** Betting logic
197 
198     // Bet states:
199     //  amount == 0 && gambler == 0 - 'clean' (can place a bet)
200     //  amount != 0 && gambler != 0 - 'active' (can be settled or refunded)
201     //  amount == 0 && gambler != 0 - 'processed' (can clean storage)
202     //
203     //  NOTE: Storage cleaning is not implemented in this contract version; it will be added
204     //        with the next upgrade to prevent polluting Ethereum state with expired bets.
205 
206     // Bet placing transaction - issued by the player.
207     //  betMask         - bet outcomes bit mask for modulo <= MAX_MASK_MODULO,
208     //                    [0, betMask) for larger modulos.
209     //  modulo          - game modulo.
210     //  commitLastBlock - number of the maximum block where "commit" is still considered valid.
211     //  commit          - Keccak256 hash of some secret "reveal" random number, to be supplied
212     //                    by the play2.win croupier bot in the settleBet transaction. Supplying
213     //                    "commit" ensures that "reveal" cannot be changed behind the scenes
214     //                    after placeBet have been mined.
215     //  r, s, v         - components of ECDSA signature of (commitLastBlock, commit)
216     //
217     // Commit, being essentially random 256-bit number, is used as a unique bet identifier in
218     // the 'bets' mapping.
219     //
220     // Commits are signed with a block limit to ensure that they are used at most once - otherwise
221     // it would be possible for a miner to place a bet with a known commit/reveal pair and tamper
222     // with the blockhash. Croupier guarantees that commitLastBlock will always be not greater than
223     // placeBet block number plus BET_EXPIRATION_BLOCKS. See whitepaper for details.
224     function placeBet(uint betMask, uint modulo, uint commitLastBlock, uint commit, uint8 v, bytes32 r, bytes32 s) external payable {
225         // Check that the bet is in 'clean' state.
226         Bet storage bet = bets[commit];
227         require (bet.gambler == address(0), "Bet should be in a 'clean' state.");
228 
229         // Validate input data ranges.
230         require (modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
231         require (msg.value >= MIN_BET && msg.value <= MAX_AMOUNT, "Amount should be within range.");
232         require (betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
233 
234         // Check that commit is valid - it has not expired and its signature is valid.
235         require (block.number <= commitLastBlock, "Commit has expired.");
236         bytes32 signatureHash = keccak256(abi.encodePacked(commitLastBlock, commit));
237         require (secretSigner == ecrecover(envelopMessage(signatureHash), v, r, s), "ECDSA signature is not valid.");
238 
239         uint rollUnder;
240         uint mask;
241 
242         if (modulo <= MAX_MASK_MODULO) {
243             // Small modulo games specify bet outcomes via bit mask.
244             // rollUnder is a number of 1 bits in this mask (population count).
245             // This magic looking formula is an efficient way to compute population
246             // count on EVM for numbers below 2**40
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
260         (possibleWinAmount, jackpotFee) = getDiceWinAmount(msg.value, modulo, rollUnder);
261 
262         // Enforce max profit limit.
263         require (possibleWinAmount <= msg.value + maxProfit, "maxProfit limit violation.");
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
276         bet.amount = msg.value;
277         bet.modulo = uint8(modulo);
278         bet.rollUnder = uint8(rollUnder);
279         bet.placeBlockNumber = uint40(block.number);
280         bet.mask = uint40(mask);
281         bet.gambler = msg.sender;
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
297         require (blockhash(placeBlockNumber) == blockHash, "Blockhash invalid");
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
330     function envelopMessage(bytes32 signatureHash) private pure returns (bytes32) {
331         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
332         return (keccak256(abi.encodePacked(prefix, signatureHash)));
333     }
334 
335     // Common settlement code for settleBet & settleBetUncleMerkleProof.
336     function settleBetCommon(Bet storage bet, uint reveal, bytes32 entropyBlockHash) private {
337         // Fetch bet parameters into local variables (to save gas).
338         uint amount = bet.amount;
339         uint modulo = bet.modulo;
340         uint rollUnder = bet.rollUnder;
341         address gambler = bet.gambler;
342 
343         // Check that bet is in 'active' state.
344         require (amount != 0, "Bet should be in an 'active' state");
345 
346         // Move bet into 'processed' state already.
347         bet.amount = 0;
348 
349         // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
350         // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
351         // preimage is intractable), and house is unable to alter the "reveal" after
352         // placeBet have been mined (as Keccak256 collision finding is also intractable).
353         bytes32 entropy = keccak256(abi.encodePacked(reveal, entropyBlockHash));
354 
355         // Do a roll by taking a modulo of entropy. Compute winning amount.
356         uint dice = uint(entropy) % modulo;
357 
358         uint diceWinAmount;
359         uint _jackpotFee;
360         (diceWinAmount, _jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
361 
362         uint diceWin = 0;
363         uint jackpotWin = 0;
364 
365         // Determine dice outcome.
366         if (modulo <= MAX_MASK_MODULO) {
367             // For small modulo games, check the outcome against a bit mask.
368             if ((2 ** dice) & bet.mask != 0) {
369                 diceWin = diceWinAmount;
370             }
371 
372         } else {
373             // For larger modulos, check inclusion into half-open interval.
374             if (dice < rollUnder) {
375                 diceWin = diceWinAmount;
376             }
377 
378         }
379 
380         // Unlock the bet amount, regardless of the outcome.
381         lockedInBets -= uint128(diceWinAmount);
382 
383         // Roll for a jackpot (if eligible).
384         if (amount >= MIN_JACKPOT_BET) {
385             // The second modulo, statistically independent from the "main" dice roll.
386             // Effectively you are playing two games at once!
387             uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;
388 
389             // Bingo!
390             if (jackpotRng == 0) {
391                 jackpotWin = jackpotSize;
392                 jackpotSize = 0;
393             }
394         }
395 
396         // Log jackpot win.
397         if (jackpotWin > 0) {
398             emit JackpotPayment(gambler, jackpotWin);
399         }
400         // Send the funds to gambler.
401         sendFunds(gambler, diceWin + jackpotWin == 0 ? 1 wei : diceWin + jackpotWin, diceWin);
402     }
403 
404     // Refund transaction - return the bet amount of a roll that was not processed in a
405     // due timeframe. Processing such blocks is not possible due to EVM limitations (see
406     // BET_EXPIRATION_BLOCKS comment above for details). In case you ever find yourself
407     // in a situation like this, just contact the play2.win support, however nothing
408     // precludes you from invoking this method yourself.
409     function refundBet(uint commit) external {
410         // Check that bet is in 'active' state.
411         Bet storage bet = bets[commit];
412         uint amount = bet.amount;
413 
414         require (amount != 0, "Bet should be in an 'active' state");
415 
416         // Check that bet has already expired.
417         require (block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
418 
419         // Move bet into 'processed' state, release funds.
420         bet.amount = 0;
421 
422         uint diceWinAmount;
423         uint jackpotFee;
424         (diceWinAmount, jackpotFee) = getDiceWinAmount(amount, bet.modulo, bet.rollUnder);
425 
426         lockedInBets -= uint128(diceWinAmount);
427         jackpotSize -= uint128(jackpotFee);
428 
429         // Send the refund.
430         sendFunds(bet.gambler, amount, amount);
431     }
432 
433     // Get the expected win amount after house edge is subtracted.
434     function getDiceWinAmount(uint amount, uint modulo, uint rollUnder) private pure returns (uint winAmount, uint jackpotFee) {
435         require (0 < rollUnder && rollUnder <= modulo, "Win probability out of range.");
436 
437         jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
438 
439         uint houseEdge = amount * HOUSE_EDGE_PERCENT / 100;
440 
441         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
442             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
443         }
444 
445         require (houseEdge + jackpotFee <= amount, "Bet doesn't even cover house edge.");
446         winAmount = (amount - houseEdge - jackpotFee) * modulo / rollUnder;
447     }
448 
449     function getPossibleWinAmount(uint amount, uint betMask, uint modulo) public pure returns (uint winAmount, uint jackpotFee) {
450 
451         uint rollUnder;
452 
453         if (modulo <= MAX_MASK_MODULO) {
454             rollUnder = ((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
455         } else {
456             rollUnder = betMask;
457         }
458 
459         jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
460 
461         uint houseEdge = amount * HOUSE_EDGE_PERCENT / 100;
462 
463         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
464             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
465         }
466 
467         winAmount = (amount - houseEdge - jackpotFee) * modulo / rollUnder;
468     }
469 
470     // Helper routine to process the payment.
471     function sendFunds(address beneficiary, uint amount, uint successLogAmount) private {
472         address payable tmp = address(uint160(beneficiary));
473         if (tmp.send(amount)) {
474             emit Payment(beneficiary, successLogAmount);
475         } else {
476             emit FailedPayment(beneficiary, amount);
477         }
478     }
479 
480     // This are some constants making O(1) population count in placeBet possible.
481     // See whitepaper for intuition and proofs behind it.
482     uint constant POPCNT_MULT = 0x0000000000002000000000100000000008000000000400000000020000000001;
483     uint constant POPCNT_MASK = 0x0001041041041041041041041041041041041041041041041041041041041041;
484     uint constant POPCNT_MODULO = 0x3F;
485 
486     // *** Merkle proofs.
487 
488     // This helpers are used to verify cryptographic proofs of placeBet inclusion into
489     // uncle blocks. They are used to prevent bet outcome changing on Ethereum reorgs without
490     // compromising the security of the smart contract. Proof data is appended to the input data
491     // in a simple prefix length format and does not adhere to the ABI.
492     // Invariants checked:
493     //  - receipt trie entry contains a (1) successful transaction (2) directed at this smart
494     //    contract (3) containing commit as a payload.
495     //  - receipt trie entry is a part of a valid merkle proof of a block header
496     //  - the block header is a part of uncle list of some block on canonical chain
497     // The implementation is optimized for gas cost and relies on the specifics of Ethereum internal data structures.
498     // Read the whitepaper for details.
499 
500     // Helper to verify a full merkle proof starting from some seedHash (usually commit). "offset" is the location of the proof
501     // beginning in the calldata.
502     function verifyMerkleProof(uint seedHash, uint offset) pure private returns (bytes32 blockHash, bytes32 uncleHash) {
503         // (Safe) assumption - nobody will write into RAM during this method invocation.
504         uint scratchBuf1;  assembly { scratchBuf1 := mload(0x40) }
505 
506         uint uncleHeaderLength; uint blobLength; uint shift; uint hashSlot;
507 
508         // Verify merkle proofs up to uncle block header. Calldata layout is:
509         //  - 2 byte big-endian slice length
510         //  - 2 byte big-endian offset to the beginning of previous slice hash within the current slice (should be zeroed)
511         //  - followed by the current slice verbatim
512         for (;; offset += blobLength) {
513             assembly { blobLength := and(calldataload(sub(offset, 30)), 0xffff) }
514             if (blobLength == 0) {
515                 // Zero slice length marks the end of uncle proof.
516                 break;
517             }
518 
519             assembly { shift := and(calldataload(sub(offset, 28)), 0xffff) }
520             require (shift + 32 <= blobLength, "Shift bounds check.");
521 
522             offset += 4;
523             assembly { hashSlot := calldataload(add(offset, shift)) }
524             require (hashSlot == 0, "Non-empty hash slot.");
525 
526             assembly {
527                 calldatacopy(scratchBuf1, offset, blobLength)
528                 mstore(add(scratchBuf1, shift), seedHash)
529                 seedHash := keccak256(scratchBuf1, blobLength)
530                 uncleHeaderLength := blobLength
531             }
532         }
533 
534         // At this moment the uncle hash is known.
535         uncleHash = bytes32(seedHash);
536 
537         // Construct the uncle list of a canonical block.
538         uint scratchBuf2 = scratchBuf1 + uncleHeaderLength;
539         uint unclesLength; assembly { unclesLength := and(calldataload(sub(offset, 28)), 0xffff) }
540         uint unclesShift;  assembly { unclesShift := and(calldataload(sub(offset, 26)), 0xffff) }
541         require (unclesShift + uncleHeaderLength <= unclesLength, "Shift bounds check.");
542 
543         offset += 6;
544         assembly { calldatacopy(scratchBuf2, offset, unclesLength) }
545         memcpy(scratchBuf2 + unclesShift, scratchBuf1, uncleHeaderLength);
546 
547         assembly { seedHash := keccak256(scratchBuf2, unclesLength) }
548 
549         offset += unclesLength;
550 
551         // Verify the canonical block header using the computed sha3Uncles.
552         assembly {
553             blobLength := and(calldataload(sub(offset, 30)), 0xffff)
554             shift := and(calldataload(sub(offset, 28)), 0xffff)
555         }
556         require (shift + 32 <= blobLength, "Shift bounds check.");
557 
558         offset += 4;
559         assembly { hashSlot := calldataload(add(offset, shift)) }
560         require (hashSlot == 0, "Non-empty hash slot.");
561 
562         assembly {
563             calldatacopy(scratchBuf1, offset, blobLength)
564             mstore(add(scratchBuf1, shift), seedHash)
565 
566             // At this moment the canonical block hash is known.
567             blockHash := keccak256(scratchBuf1, blobLength)
568         }
569     }
570 
571     // Helper to check the placeBet receipt. "offset" is the location of the proof beginning in the calldata.
572     // RLP layout: [triePath, str([status, cumGasUsed, bloomFilter, [[address, [topics], data]])]
573     function requireCorrectReceipt(uint offset) view private {
574         uint leafHeaderByte; assembly { leafHeaderByte := byte(0, calldataload(offset)) }
575 
576         require (leafHeaderByte >= 0xf7, "Receipt leaf longer than 55 bytes.");
577         offset += leafHeaderByte - 0xf6;
578 
579         uint pathHeaderByte; assembly { pathHeaderByte := byte(0, calldataload(offset)) }
580 
581         if (pathHeaderByte <= 0x7f) {
582             offset += 1;
583 
584         } else {
585             require (pathHeaderByte >= 0x80 && pathHeaderByte <= 0xb7, "Path is an RLP string.");
586             offset += pathHeaderByte - 0x7f;
587         }
588 
589         uint receiptStringHeaderByte; assembly { receiptStringHeaderByte := byte(0, calldataload(offset)) }
590         require (receiptStringHeaderByte == 0xb9, "Receipt string is always at least 256 bytes long, but less than 64k.");
591         offset += 3;
592 
593         uint receiptHeaderByte; assembly { receiptHeaderByte := byte(0, calldataload(offset)) }
594         require (receiptHeaderByte == 0xf9, "Receipt is always at least 256 bytes long, but less than 64k.");
595         offset += 3;
596 
597         uint statusByte; assembly { statusByte := byte(0, calldataload(offset)) }
598         require (statusByte == 0x1, "Status should be success.");
599         offset += 1;
600 
601         uint cumGasHeaderByte; assembly { cumGasHeaderByte := byte(0, calldataload(offset)) }
602         if (cumGasHeaderByte <= 0x7f) {
603             offset += 1;
604 
605         } else {
606             require (cumGasHeaderByte >= 0x80 && cumGasHeaderByte <= 0xb7, "Cumulative gas is an RLP string.");
607             offset += cumGasHeaderByte - 0x7f;
608         }
609 
610         uint bloomHeaderByte; assembly { bloomHeaderByte := byte(0, calldataload(offset)) }
611         require (bloomHeaderByte == 0xb9, "Bloom filter is always 256 bytes long.");
612         offset += 256 + 3;
613 
614         uint logsListHeaderByte; assembly { logsListHeaderByte := byte(0, calldataload(offset)) }
615         require (logsListHeaderByte == 0xf8, "Logs list is less than 256 bytes long.");
616         offset += 2;
617 
618         uint logEntryHeaderByte; assembly { logEntryHeaderByte := byte(0, calldataload(offset)) }
619         require (logEntryHeaderByte == 0xf8, "Log entry is less than 256 bytes long.");
620         offset += 2;
621 
622         uint addressHeaderByte; assembly { addressHeaderByte := byte(0, calldataload(offset)) }
623         require (addressHeaderByte == 0x94, "Address is 20 bytes long.");
624 
625         uint logAddress; assembly { logAddress := and(calldataload(sub(offset, 11)), 0xffffffffffffffffffffffffffffffffffffffff) }
626         require (logAddress == uint(address(this)));
627     }
628 
629     // Memory copy.
630     function memcpy(uint dest, uint src, uint len) pure private {
631         // Full 32 byte words
632         for(; len >= 32; len -= 32) {
633             assembly { mstore(dest, mload(src)) }
634             dest += 32; src += 32;
635         }
636 
637         // Remaining bytes
638         uint mask = 256 ** (32 - len) - 1;
639         assembly {
640             let srcpart := and(mload(src), not(mask))
641             let destpart := and(mload(dest), mask)
642             mstore(dest, or(destpart, srcpart))
643         }
644     }
645 }