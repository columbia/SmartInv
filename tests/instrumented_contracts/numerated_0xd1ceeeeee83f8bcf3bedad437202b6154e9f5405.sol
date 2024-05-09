1 pragma solidity ^0.4.24;
2 
3 // * dice2.win - fair games that pay Ether. Version 5.
4 //
5 // * Ethereum smart contract, deployed at 0xD1CEeeeee83F8bCF3BEDad437202b6154E9F5405.
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
109     // Croupier account.
110     address public croupier;
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
178     // Funds withdrawal to cover costs of dice2.win operation.
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
195     //  amount == 0 && gambler == 0 - 'clean' (can place a bet)
196     //  amount != 0 && gambler != 0 - 'active' (can be settled or refunded)
197     //  amount == 0 && gambler != 0 - 'processed' (can clean storage)
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
208     //                    by the dice2.win croupier bot in the settleBet transaction. Supplying
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
224         require (bet.gambler == address(0), "Bet should be in a 'clean' state.");
225 
226         // Validate input data ranges.
227         uint amount = msg.value;
228         require (modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
229         require (amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
230         require (betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
231 
232         // Check that commit is valid - it has not expired and its signature is valid.
233         require (block.number <= commitLastBlock, "Commit has expired.");
234         bytes32 signatureHash = keccak256(abi.encodePacked(uint40(commitLastBlock), commit));
235         require (secretSigner == ecrecover(signatureHash, 27, r, s), "ECDSA signature is not valid.");
236 
237         uint rollUnder;
238         uint mask;
239 
240         if (modulo <= MAX_MASK_MODULO) {
241             // Small modulo games specify bet outcomes via bit mask.
242             // rollUnder is a number of 1 bits in this mask (population count).
243             // This magic looking formula is an efficient way to compute population
244             // count on EVM for numbers below 2**40. For detailed proof consult
245             // the dice2.win whitepaper.
246             rollUnder = ((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
247             mask = betMask;
248         } else {
249             // Larger modulos specify the right edge of half-open interval of
250             // winning bet outcomes.
251             require (betMask > 0 && betMask <= modulo, "High modulo range, betMask larger than modulo.");
252             rollUnder = betMask;
253         }
254 
255         // Winning amount and jackpot increase.
256         uint possibleWinAmount;
257         uint jackpotFee;
258 
259         (possibleWinAmount, jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
260 
261         // Enforce max profit limit.
262         require (possibleWinAmount <= amount + maxProfit, "maxProfit limit violation.");
263 
264         // Lock funds.
265         lockedInBets += uint128(possibleWinAmount);
266         jackpotSize += uint128(jackpotFee);
267 
268         // Check whether contract has enough funds to process this bet.
269         require (jackpotSize + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
270 
271         // Record commit in logs.
272         emit Commit(commit);
273 
274         // Store bet parameters on blockchain.
275         bet.amount = amount;
276         bet.modulo = uint8(modulo);
277         bet.rollUnder = uint8(rollUnder);
278         bet.placeBlockNumber = uint40(block.number);
279         bet.mask = uint40(mask);
280         bet.gambler = msg.sender;
281     }
282 
283     // This is the method used to settle 99% of bets. To process a bet with a specific
284     // "commit", settleBet should supply a "reveal" number that would Keccak256-hash to
285     // "commit". "blockHash" is the block hash of placeBet block as seen by croupier; it
286     // is additionally asserted to prevent changing the bet outcomes on Ethereum reorgs.
287     function settleBet(uint reveal, bytes32 blockHash) external onlyCroupier {
288         uint commit = uint(keccak256(abi.encodePacked(reveal)));
289 
290         Bet storage bet = bets[commit];
291         uint placeBlockNumber = bet.placeBlockNumber;
292 
293         // Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
294         require (block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
295         require (block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
296         require (blockhash(placeBlockNumber) == blockHash);
297 
298         // Settle bet using reveal and blockHash as entropy sources.
299         settleBetCommon(bet, reveal, blockHash);
300     }
301 
302     // This method is used to settle a bet that was mined into an uncle block. At this
303     // point the player was shown some bet outcome, but the blockhash at placeBet height
304     // is different because of Ethereum chain reorg. We supply a full merkle proof of the
305     // placeBet transaction receipt to provide untamperable evidence that uncle block hash
306     // indeed was present on-chain at some point.
307     function settleBetUncleMerkleProof(uint reveal, uint40 canonicalBlockNumber) external onlyCroupier {
308         // "commit" for bet settlement can only be obtained by hashing a "reveal".
309         uint commit = uint(keccak256(abi.encodePacked(reveal)));
310 
311         Bet storage bet = bets[commit];
312 
313         // Check that canonical block hash can still be verified.
314         require (block.number <= canonicalBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
315 
316         // Verify placeBet receipt.
317         requireCorrectReceipt(4 + 32 + 32 + 4);
318 
319         // Reconstruct canonical & uncle block hashes from a receipt merkle proof, verify them.
320         bytes32 canonicalHash;
321         bytes32 uncleHash;
322         (canonicalHash, uncleHash) = verifyMerkleProof(commit, 4 + 32 + 32);
323         require (blockhash(canonicalBlockNumber) == canonicalHash);
324 
325         // Settle bet using reveal and uncleHash as entropy sources.
326         settleBetCommon(bet, reveal, uncleHash);
327     }
328 
329     // Common settlement code for settleBet & settleBetUncleMerkleProof.
330     function settleBetCommon(Bet storage bet, uint reveal, bytes32 entropyBlockHash) private {
331         // Fetch bet parameters into local variables (to save gas).
332         uint amount = bet.amount;
333         uint modulo = bet.modulo;
334         uint rollUnder = bet.rollUnder;
335         address gambler = bet.gambler;
336 
337         // Check that bet is in 'active' state.
338         require (amount != 0, "Bet should be in an 'active' state");
339 
340         // Move bet into 'processed' state already.
341         bet.amount = 0;
342 
343         // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
344         // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
345         // preimage is intractable), and house is unable to alter the "reveal" after
346         // placeBet have been mined (as Keccak256 collision finding is also intractable).
347         bytes32 entropy = keccak256(abi.encodePacked(reveal, entropyBlockHash));
348 
349         // Do a roll by taking a modulo of entropy. Compute winning amount.
350         uint dice = uint(entropy) % modulo;
351 
352         uint diceWinAmount;
353         uint _jackpotFee;
354         (diceWinAmount, _jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
355 
356         uint diceWin = 0;
357         uint jackpotWin = 0;
358 
359         // Determine dice outcome.
360         if (modulo <= MAX_MASK_MODULO) {
361             // For small modulo games, check the outcome against a bit mask.
362             if ((2 ** dice) & bet.mask != 0) {
363                 diceWin = diceWinAmount;
364             }
365 
366         } else {
367             // For larger modulos, check inclusion into half-open interval.
368             if (dice < rollUnder) {
369                 diceWin = diceWinAmount;
370             }
371 
372         }
373 
374         // Unlock the bet amount, regardless of the outcome.
375         lockedInBets -= uint128(diceWinAmount);
376 
377         // Roll for a jackpot (if eligible).
378         if (amount >= MIN_JACKPOT_BET) {
379             // The second modulo, statistically independent from the "main" dice roll.
380             // Effectively you are playing two games at once!
381             uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;
382 
383             // Bingo!
384             if (jackpotRng == 0) {
385                 jackpotWin = jackpotSize;
386                 jackpotSize = 0;
387             }
388         }
389 
390         // Log jackpot win.
391         if (jackpotWin > 0) {
392             emit JackpotPayment(gambler, jackpotWin);
393         }
394 
395         // Send the funds to gambler.
396         sendFunds(gambler, diceWin + jackpotWin == 0 ? 1 wei : diceWin + jackpotWin, diceWin);
397     }
398 
399     // Refund transaction - return the bet amount of a roll that was not processed in a
400     // due timeframe. Processing such blocks is not possible due to EVM limitations (see
401     // BET_EXPIRATION_BLOCKS comment above for details). In case you ever find yourself
402     // in a situation like this, just contact the dice2.win support, however nothing
403     // precludes you from invoking this method yourself.
404     function refundBet(uint commit) external {
405         // Check that bet is in 'active' state.
406         Bet storage bet = bets[commit];
407         uint amount = bet.amount;
408 
409         require (amount != 0, "Bet should be in an 'active' state");
410 
411         // Check that bet has already expired.
412         require (block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
413 
414         // Move bet into 'processed' state, release funds.
415         bet.amount = 0;
416 
417         uint diceWinAmount;
418         uint jackpotFee;
419         (diceWinAmount, jackpotFee) = getDiceWinAmount(amount, bet.modulo, bet.rollUnder);
420 
421         lockedInBets -= uint128(diceWinAmount);
422         jackpotSize -= uint128(jackpotFee);
423 
424         // Send the refund.
425         sendFunds(bet.gambler, amount, amount);
426     }
427 
428     // Get the expected win amount after house edge is subtracted.
429     function getDiceWinAmount(uint amount, uint modulo, uint rollUnder) private pure returns (uint winAmount, uint jackpotFee) {
430         require (0 < rollUnder && rollUnder <= modulo, "Win probability out of range.");
431 
432         jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
433 
434         uint houseEdge = amount * HOUSE_EDGE_PERCENT / 100;
435 
436         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
437             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
438         }
439 
440         require (houseEdge + jackpotFee <= amount, "Bet doesn't even cover house edge.");
441         winAmount = (amount - houseEdge - jackpotFee) * modulo / rollUnder;
442     }
443 
444     // Helper routine to process the payment.
445     function sendFunds(address beneficiary, uint amount, uint successLogAmount) private {
446         if (beneficiary.send(amount)) {
447             emit Payment(beneficiary, successLogAmount);
448         } else {
449             emit FailedPayment(beneficiary, amount);
450         }
451     }
452 
453     // This are some constants making O(1) population count in placeBet possible.
454     // See whitepaper for intuition and proofs behind it.
455     uint constant POPCNT_MULT = 0x0000000000002000000000100000000008000000000400000000020000000001;
456     uint constant POPCNT_MASK = 0x0001041041041041041041041041041041041041041041041041041041041041;
457     uint constant POPCNT_MODULO = 0x3F;
458 
459     // *** Merkle proofs.
460 
461     // This helpers are used to verify cryptographic proofs of placeBet inclusion into
462     // uncle blocks. They are used to prevent bet outcome changing on Ethereum reorgs without
463     // compromising the security of the smart contract. Proof data is appended to the input data
464     // in a simple prefix length format and does not adhere to the ABI.
465     // Invariants checked:
466     //  - receipt trie entry contains a (1) successful transaction (2) directed at this smart
467     //    contract (3) containing commit as a payload.
468     //  - receipt trie entry is a part of a valid merkle proof of a block header
469     //  - the block header is a part of uncle list of some block on canonical chain
470     // The implementation is optimized for gas cost and relies on the specifics of Ethereum internal data structures.
471     // Read the whitepaper for details.
472 
473     // Helper to verify a full merkle proof starting from some seedHash (usually commit). "offset" is the location of the proof
474     // beginning in the calldata.
475     function verifyMerkleProof(uint seedHash, uint offset) pure private returns (bytes32 blockHash, bytes32 uncleHash) {
476         // (Safe) assumption - nobody will write into RAM during this method invocation.
477         uint scratchBuf1;  assembly { scratchBuf1 := mload(0x40) }
478 
479         uint uncleHeaderLength; uint blobLength; uint shift; uint hashSlot;
480 
481         // Verify merkle proofs up to uncle block header. Calldata layout is:
482         //  - 2 byte big-endian slice length
483         //  - 2 byte big-endian offset to the beginning of previous slice hash within the current slice (should be zeroed)
484         //  - followed by the current slice verbatim
485         for (;; offset += blobLength) {
486             assembly { blobLength := and(calldataload(sub(offset, 30)), 0xffff) }
487             if (blobLength == 0) {
488                 // Zero slice length marks the end of uncle proof.
489                 break;
490             }
491 
492             assembly { shift := and(calldataload(sub(offset, 28)), 0xffff) }
493             require (shift + 32 <= blobLength, "Shift bounds check.");
494 
495             offset += 4;
496             assembly { hashSlot := calldataload(add(offset, shift)) }
497             require (hashSlot == 0, "Non-empty hash slot.");
498 
499             assembly {
500                 calldatacopy(scratchBuf1, offset, blobLength)
501                 mstore(add(scratchBuf1, shift), seedHash)
502                 seedHash := sha3(scratchBuf1, blobLength)
503                 uncleHeaderLength := blobLength
504             }
505         }
506 
507         // At this moment the uncle hash is known.
508         uncleHash = bytes32(seedHash);
509 
510         // Construct the uncle list of a canonical block.
511         uint scratchBuf2 = scratchBuf1 + uncleHeaderLength;
512         uint unclesLength; assembly { unclesLength := and(calldataload(sub(offset, 28)), 0xffff) }
513         uint unclesShift;  assembly { unclesShift := and(calldataload(sub(offset, 26)), 0xffff) }
514         require (unclesShift + uncleHeaderLength <= unclesLength, "Shift bounds check.");
515 
516         offset += 6;
517         assembly { calldatacopy(scratchBuf2, offset, unclesLength) }
518         memcpy(scratchBuf2 + unclesShift, scratchBuf1, uncleHeaderLength);
519 
520         assembly { seedHash := sha3(scratchBuf2, unclesLength) }
521 
522         offset += unclesLength;
523 
524         // Verify the canonical block header using the computed sha3Uncles.
525         assembly {
526             blobLength := and(calldataload(sub(offset, 30)), 0xffff)
527             shift := and(calldataload(sub(offset, 28)), 0xffff)
528         }
529         require (shift + 32 <= blobLength, "Shift bounds check.");
530 
531         offset += 4;
532         assembly { hashSlot := calldataload(add(offset, shift)) }
533         require (hashSlot == 0, "Non-empty hash slot.");
534 
535         assembly {
536             calldatacopy(scratchBuf1, offset, blobLength)
537             mstore(add(scratchBuf1, shift), seedHash)
538 
539             // At this moment the canonical block hash is known.
540             blockHash := sha3(scratchBuf1, blobLength)
541         }
542     }
543 
544     // Helper to check the placeBet receipt. "offset" is the location of the proof beginning in the calldata.
545     // RLP layout: [triePath, str([status, cumGasUsed, bloomFilter, [[address, [topics], data]])]
546     function requireCorrectReceipt(uint offset) view private {
547         uint leafHeaderByte; assembly { leafHeaderByte := byte(0, calldataload(offset)) }
548 
549         require (leafHeaderByte >= 0xf7, "Receipt leaf longer than 55 bytes.");
550         offset += leafHeaderByte - 0xf6;
551 
552         uint pathHeaderByte; assembly { pathHeaderByte := byte(0, calldataload(offset)) }
553 
554         if (pathHeaderByte <= 0x7f) {
555             offset += 1;
556 
557         } else {
558             require (pathHeaderByte >= 0x80 && pathHeaderByte <= 0xb7, "Path is an RLP string.");
559             offset += pathHeaderByte - 0x7f;
560         }
561 
562         uint receiptStringHeaderByte; assembly { receiptStringHeaderByte := byte(0, calldataload(offset)) }
563         require (receiptStringHeaderByte == 0xb9, "Receipt string is always at least 256 bytes long, but less than 64k.");
564         offset += 3;
565 
566         uint receiptHeaderByte; assembly { receiptHeaderByte := byte(0, calldataload(offset)) }
567         require (receiptHeaderByte == 0xf9, "Receipt is always at least 256 bytes long, but less than 64k.");
568         offset += 3;
569 
570         uint statusByte; assembly { statusByte := byte(0, calldataload(offset)) }
571         require (statusByte == 0x1, "Status should be success.");
572         offset += 1;
573 
574         uint cumGasHeaderByte; assembly { cumGasHeaderByte := byte(0, calldataload(offset)) }
575         if (cumGasHeaderByte <= 0x7f) {
576             offset += 1;
577 
578         } else {
579             require (cumGasHeaderByte >= 0x80 && cumGasHeaderByte <= 0xb7, "Cumulative gas is an RLP string.");
580             offset += cumGasHeaderByte - 0x7f;
581         }
582 
583         uint bloomHeaderByte; assembly { bloomHeaderByte := byte(0, calldataload(offset)) }
584         require (bloomHeaderByte == 0xb9, "Bloom filter is always 256 bytes long.");
585         offset += 256 + 3;
586 
587         uint logsListHeaderByte; assembly { logsListHeaderByte := byte(0, calldataload(offset)) }
588         require (logsListHeaderByte == 0xf8, "Logs list is less than 256 bytes long.");
589         offset += 2;
590 
591         uint logEntryHeaderByte; assembly { logEntryHeaderByte := byte(0, calldataload(offset)) }
592         require (logEntryHeaderByte == 0xf8, "Log entry is less than 256 bytes long.");
593         offset += 2;
594 
595         uint addressHeaderByte; assembly { addressHeaderByte := byte(0, calldataload(offset)) }
596         require (addressHeaderByte == 0x94, "Address is 20 bytes long.");
597 
598         uint logAddress; assembly { logAddress := and(calldataload(sub(offset, 11)), 0xffffffffffffffffffffffffffffffffffffffff) }
599         require (logAddress == uint(address(this)));
600     }
601 
602     // Memory copy.
603     function memcpy(uint dest, uint src, uint len) pure private {
604         // Full 32 byte words
605         for(; len >= 32; len -= 32) {
606             assembly { mstore(dest, mload(src)) }
607             dest += 32; src += 32;
608         }
609 
610         // Remaining bytes
611         uint mask = 256 ** (32 - len) - 1;
612         assembly {
613             let srcpart := and(mload(src), not(mask))
614             let destpart := and(mload(dest), mask)
615             mstore(dest, or(destpart, srcpart))
616         }
617     }
618 }