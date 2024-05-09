1 pragma solidity ^0.4.24;
2 
3 // * Uses hybrid commit-reveal + block hash random number generation that is immune
4 //   to tampering by players, house and miners. Apart from being fully transparent,
5 //   this also allows arbitrarily high bets.
6 
7 contract ChainDice {
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
57     // threshold. On rare occasions ChainDice croupier may fail to invoke
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
172     // Funds withdrawal to cover costs of ChainDice operation.
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
202     //                    by the ChainDice croupier bot in the settleBet transaction. Supplying
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
235             // Small modulo games specify bet outcomes via bit mask.
236             // rollUnder is a number of 1 bits in this mask (population count).
237             // This magic looking formula is an efficient way to compute population
238             // count on EVM for numbers below 2**40. For detailed proof consult
239             // the ChainDice whitepaper.
240             rollUnder = ((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
241             mask = betMask;
242         } else {
243             // Larger modulos specify the right edge of half-open interval of
244             // winning bet outcomes.
245             require (betMask > 0 && betMask <= modulo, "High modulo range, betMask larger than modulo.");
246             rollUnder = betMask;
247         }
248 
249         // Winning amount and jackpot increase.
250         uint possibleWinAmount;
251         uint jackpotFee;
252 
253         (possibleWinAmount, jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
254 
255         // Enforce max profit limit.
256         require (possibleWinAmount <= amount + maxProfit, "maxProfit limit violation.");
257 
258         // Lock funds.
259         lockedInBets += uint128(possibleWinAmount);
260         jackpotSize += uint128(jackpotFee);
261 
262         // Check whether contract has enough funds to process this bet.
263         require (jackpotSize + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
264 
265         // Record commit in logs.
266         emit Commit(commit);
267 
268         // Store bet parameters on blockchain.
269         bet.amount = amount;
270         bet.modulo = uint8(modulo);
271         bet.rollUnder = uint8(rollUnder);
272         bet.placeBlockNumber = uint40(block.number);
273         bet.mask = uint40(mask);
274         bet.gambler = msg.sender;
275     }
276 
277     // This is the method used to settle 99% of bets. To process a bet with a specific
278     // "commit", settleBet should supply a "reveal" number that would Keccak256-hash to
279     // "commit". "blockHash" is the block hash of placeBet block as seen by croupier; it
280     // is additionally asserted to prevent changing the bet outcomes on Ethereum reorgs.
281     function settleBet(uint reveal, bytes32 blockHash) external onlyCroupier {
282         uint commit = uint(keccak256(abi.encodePacked(reveal)));
283 
284         Bet storage bet = bets[commit];
285         uint placeBlockNumber = bet.placeBlockNumber;
286 
287         // Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
288         require (block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
289         require (block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
290         require (blockhash(placeBlockNumber) == blockHash, "BlockHash isn't placeBlockHash");
291 
292         // Settle bet using reveal and blockHash as entropy sources.
293         settleBetCommon(bet, reveal, blockHash);
294     }
295 
296     // This method is used to settle a bet that was mined into an uncle block. At this
297     // point the player was shown some bet outcome, but the blockhash at placeBet height
298     // is different because of Ethereum chain reorg. We supply a full merkle proof of the
299     // placeBet transaction receipt to provide untamperable evidence that uncle block hash
300     // indeed was present on-chain at some point.
301     function settleBetUncleMerkleProof(uint reveal, uint40 canonicalBlockNumber) external onlyCroupier {
302         // "commit" for bet settlement can only be obtained by hashing a "reveal".
303         uint commit = uint(keccak256(abi.encodePacked(reveal)));
304 
305         Bet storage bet = bets[commit];
306 
307         // Check that canonical block hash can still be verified.
308         require (block.number <= canonicalBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
309 
310         // Verify placeBet receipt.
311         requireCorrectReceipt(4 + 32 + 32 + 4);
312 
313         // Reconstruct canonical & uncle block hashes from a receipt merkle proof, verify them.
314         bytes32 canonicalHash;
315         bytes32 uncleHash;
316         (canonicalHash, uncleHash) = verifyMerkleProof(commit, 4 + 32 + 32);
317         require (blockhash(canonicalBlockNumber) == canonicalHash);
318 
319         // Settle bet using reveal and uncleHash as entropy sources.
320         settleBetCommon(bet, reveal, uncleHash);
321     }
322 
323     // Common settlement code for settleBet & settleBetUncleMerkleProof.
324     function settleBetCommon(Bet storage bet, uint reveal, bytes32 entropyBlockHash) private {
325         // Fetch bet parameters into local variables (to save gas).
326         uint amount = bet.amount;
327         uint modulo = bet.modulo;
328         uint rollUnder = bet.rollUnder;
329         address gambler = bet.gambler;
330 
331         // Check that bet is in 'active' state.
332         require (amount != 0, "Bet should be in an 'active' state");
333 
334         // Move bet into 'processed' state already.
335         bet.amount = 0;
336 
337         // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
338         // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
339         // preimage is intractable), and house is unable to alter the "reveal" after
340         // placeBet have been mined (as Keccak256 collision finding is also intractable).
341         bytes32 entropy = keccak256(abi.encodePacked(reveal, entropyBlockHash));
342 
343         // Do a roll by taking a modulo of entropy. Compute winning amount.
344         uint dice = uint(entropy) % modulo;
345 
346         uint diceWinAmount;
347         uint _jackpotFee;
348         (diceWinAmount, _jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
349 
350         uint diceWin = 0;
351         uint jackpotWin = 0;
352 
353         // Determine dice outcome.
354         if (modulo <= MAX_MASK_MODULO) {
355             // For small modulo games, check the outcome against a bit mask.
356             if ((2 ** dice) & bet.mask != 0) {
357                 diceWin = diceWinAmount;
358             }
359 
360         } else {
361             // For larger modulos, check inclusion into half-open interval.
362             if (dice < rollUnder) {
363                 diceWin = diceWinAmount;
364             }
365 
366         }
367 
368         // Unlock the bet amount, regardless of the outcome.
369         lockedInBets -= uint128(diceWinAmount);
370 
371         // Roll for a jackpot (if eligible).
372         if (amount >= MIN_JACKPOT_BET) {
373             // The second modulo, statistically independent from the "main" dice roll.
374             // Effectively you are playing two games at once!
375             uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;
376 
377             // Bingo!
378             if (jackpotRng == 0) {
379                 jackpotWin = jackpotSize;
380                 jackpotSize = 0;
381             }
382         }
383 
384         // Log jackpot win.
385         if (jackpotWin > 0) {
386             emit JackpotPayment(gambler, jackpotWin);
387         }
388 
389         // Send the funds to gambler.
390         sendFunds(gambler, diceWin + jackpotWin == 0 ? 1 wei : diceWin + jackpotWin, diceWin);
391     }
392 
393     // Refund transaction - return the bet amount of a roll that was not processed in a
394     // due timeframe. Processing such blocks is not possible due to EVM limitations (see
395     // BET_EXPIRATION_BLOCKS comment above for details). In case you ever find yourself
396     // in a situation like this, just contact the ChainDice support, however nothing
397     // precludes you from invoking this method yourself.
398     function refundBet(uint commit) external {
399         // Check that bet is in 'active' state.
400         Bet storage bet = bets[commit];
401         uint amount = bet.amount;
402 
403         require (amount != 0, "Bet should be in an 'active' state");
404 
405         // Check that bet has already expired.
406         require (block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
407 
408         // Move bet into 'processed' state, release funds.
409         bet.amount = 0;
410 
411         uint diceWinAmount;
412         uint jackpotFee;
413         (diceWinAmount, jackpotFee) = getDiceWinAmount(amount, bet.modulo, bet.rollUnder);
414 
415         lockedInBets -= uint128(diceWinAmount);
416         jackpotSize -= uint128(jackpotFee);
417 
418         // Send the refund.
419         sendFunds(bet.gambler, amount, amount);
420     }
421 
422     // Get the expected win amount after house edge is subtracted.
423     function getDiceWinAmount(uint amount, uint modulo, uint rollUnder) private pure returns (uint winAmount, uint jackpotFee) {
424         require (0 < rollUnder && rollUnder <= modulo, "Win probability out of range.");
425 
426         jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
427 
428         uint houseEdge = amount * HOUSE_EDGE_PERCENT / 100;
429 
430         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
431             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
432         }
433 
434         require (houseEdge + jackpotFee <= amount, "Bet doesn't even cover house edge.");
435         winAmount = (amount - houseEdge - jackpotFee) * modulo / rollUnder;
436     }
437 
438     // Helper routine to process the payment.
439     function sendFunds(address beneficiary, uint amount, uint successLogAmount) private {
440         if (beneficiary.send(amount)) {
441             emit Payment(beneficiary, successLogAmount);
442         } else {
443             emit FailedPayment(beneficiary, amount);
444         }
445     }
446 
447     // This are some constants making O(1) population count in placeBet possible.
448     // See whitepaper for intuition and proofs behind it.
449     uint constant POPCNT_MULT = 0x0000000000002000000000100000000008000000000400000000020000000001;
450     uint constant POPCNT_MASK = 0x0001041041041041041041041041041041041041041041041041041041041041;
451     uint constant POPCNT_MODULO = 0x3F;
452 
453     // *** Merkle proofs.
454 
455     // This helpers are used to verify cryptographic proofs of placeBet inclusion into
456     // uncle blocks. They are used to prevent bet outcome changing on Ethereum reorgs without
457     // compromising the security of the smart contract. Proof data is appended to the input data
458     // in a simple prefix length format and does not adhere to the ABI.
459     // Invariants checked:
460     //  - receipt trie entry contains a (1) successful transaction (2) directed at this smart
461     //    contract (3) containing commit as a payload.
462     //  - receipt trie entry is a part of a valid merkle proof of a block header
463     //  - the block header is a part of uncle list of some block on canonical chain
464     // The implementation is optimized for gas cost and relies on the specifics of Ethereum internal data structures.
465     // Read the whitepaper for details.
466 
467     // Helper to verify a full merkle proof starting from some seedHash (usually commit). "offset" is the location of the proof
468     // beginning in the calldata.
469     function verifyMerkleProof(uint seedHash, uint offset) pure private returns (bytes32 blockHash, bytes32 uncleHash) {
470         // (Safe) assumption - nobody will write into RAM during this method invocation.
471         uint scratchBuf1;  assembly { scratchBuf1 := mload(0x40) }
472 
473         uint uncleHeaderLength; uint blobLength; uint shift; uint hashSlot;
474 
475         // Verify merkle proofs up to uncle block header. Calldata layout is:
476         //  - 2 byte big-endian slice length
477         //  - 2 byte big-endian offset to the beginning of previous slice hash within the current slice (should be zeroed)
478         //  - followed by the current slice verbatim
479         for (;; offset += blobLength) {
480             assembly { blobLength := and(calldataload(sub(offset, 30)), 0xffff) }
481             if (blobLength == 0) {
482                 // Zero slice length marks the end of uncle proof.
483                 break;
484             }
485 
486             assembly { shift := and(calldataload(sub(offset, 28)), 0xffff) }
487             require (shift + 32 <= blobLength, "Shift bounds check.");
488 
489             offset += 4;
490             assembly { hashSlot := calldataload(add(offset, shift)) }
491             require (hashSlot == 0, "Non-empty hash slot.");
492 
493             assembly {
494                 calldatacopy(scratchBuf1, offset, blobLength)
495                 mstore(add(scratchBuf1, shift), seedHash)
496                 seedHash := sha3(scratchBuf1, blobLength)
497                 uncleHeaderLength := blobLength
498             }
499         }
500 
501         // At this moment the uncle hash is known.
502         uncleHash = bytes32(seedHash);
503 
504         // Construct the uncle list of a canonical block.
505         uint scratchBuf2 = scratchBuf1 + uncleHeaderLength;
506         uint unclesLength; assembly { unclesLength := and(calldataload(sub(offset, 28)), 0xffff) }
507         uint unclesShift;  assembly { unclesShift := and(calldataload(sub(offset, 26)), 0xffff) }
508         require (unclesShift + uncleHeaderLength <= unclesLength, "Shift bounds check.");
509 
510         offset += 6;
511         assembly { calldatacopy(scratchBuf2, offset, unclesLength) }
512         memcpy(scratchBuf2 + unclesShift, scratchBuf1, uncleHeaderLength);
513 
514         assembly { seedHash := sha3(scratchBuf2, unclesLength) }
515 
516         offset += unclesLength;
517 
518         // Verify the canonical block header using the computed sha3Uncles.
519         assembly {
520             blobLength := and(calldataload(sub(offset, 30)), 0xffff)
521             shift := and(calldataload(sub(offset, 28)), 0xffff)
522         }
523         require (shift + 32 <= blobLength, "Shift bounds check.");
524 
525         offset += 4;
526         assembly { hashSlot := calldataload(add(offset, shift)) }
527         require (hashSlot == 0, "Non-empty hash slot.");
528 
529         assembly {
530             calldatacopy(scratchBuf1, offset, blobLength)
531             mstore(add(scratchBuf1, shift), seedHash)
532 
533             // At this moment the canonical block hash is known.
534             blockHash := sha3(scratchBuf1, blobLength)
535         }
536     }
537 
538     // Helper to check the placeBet receipt. "offset" is the location of the proof beginning in the calldata.
539     // RLP layout: [triePath, str([status, cumGasUsed, bloomFilter, [[address, [topics], data]])]
540     function requireCorrectReceipt(uint offset) view private {
541         uint leafHeaderByte; assembly { leafHeaderByte := byte(0, calldataload(offset)) }
542 
543         require (leafHeaderByte >= 0xf7, "Receipt leaf longer than 55 bytes.");
544         offset += leafHeaderByte - 0xf6;
545 
546         uint pathHeaderByte; assembly { pathHeaderByte := byte(0, calldataload(offset)) }
547 
548         if (pathHeaderByte <= 0x7f) {
549             offset += 1;
550 
551         } else {
552             require (pathHeaderByte >= 0x80 && pathHeaderByte <= 0xb7, "Path is an RLP string.");
553             offset += pathHeaderByte - 0x7f;
554         }
555 
556         uint receiptStringHeaderByte; assembly { receiptStringHeaderByte := byte(0, calldataload(offset)) }
557         require (receiptStringHeaderByte == 0xb9, "Receipt string is always at least 256 bytes long, but less than 64k.");
558         offset += 3;
559 
560         uint receiptHeaderByte; assembly { receiptHeaderByte := byte(0, calldataload(offset)) }
561         require (receiptHeaderByte == 0xf9, "Receipt is always at least 256 bytes long, but less than 64k.");
562         offset += 3;
563 
564         uint statusByte; assembly { statusByte := byte(0, calldataload(offset)) }
565         require (statusByte == 0x1, "Status should be success.");
566         offset += 1;
567 
568         uint cumGasHeaderByte; assembly { cumGasHeaderByte := byte(0, calldataload(offset)) }
569         if (cumGasHeaderByte <= 0x7f) {
570             offset += 1;
571 
572         } else {
573             require (cumGasHeaderByte >= 0x80 && cumGasHeaderByte <= 0xb7, "Cumulative gas is an RLP string.");
574             offset += cumGasHeaderByte - 0x7f;
575         }
576 
577         uint bloomHeaderByte; assembly { bloomHeaderByte := byte(0, calldataload(offset)) }
578         require (bloomHeaderByte == 0xb9, "Bloom filter is always 256 bytes long.");
579         offset += 256 + 3;
580 
581         uint logsListHeaderByte; assembly { logsListHeaderByte := byte(0, calldataload(offset)) }
582         require (logsListHeaderByte == 0xf8, "Logs list is less than 256 bytes long.");
583         offset += 2;
584 
585         uint logEntryHeaderByte; assembly { logEntryHeaderByte := byte(0, calldataload(offset)) }
586         require (logEntryHeaderByte == 0xf8, "Log entry is less than 256 bytes long.");
587         offset += 2;
588 
589         uint addressHeaderByte; assembly { addressHeaderByte := byte(0, calldataload(offset)) }
590         require (addressHeaderByte == 0x94, "Address is 20 bytes long.");
591 
592         uint logAddress; assembly { logAddress := and(calldataload(sub(offset, 11)), 0xffffffffffffffffffffffffffffffffffffffff) }
593         require (logAddress == uint(address(this)));
594     }
595 
596     // Memory copy.
597     function memcpy(uint dest, uint src, uint len) pure private {
598         // Full 32 byte words
599         for(; len >= 32; len -= 32) {
600             assembly { mstore(dest, mload(src)) }
601             dest += 32; src += 32;
602         }
603 
604         // Remaining bytes
605         uint mask = 256 ** (32 - len) - 1;
606         assembly {
607             let srcpart := and(mload(src), not(mask))
608             let destpart := and(mload(dest), mask)
609             mstore(dest, or(destpart, srcpart))
610         }
611     }
612 }