1 pragma solidity ^0.4.24;
2 
3 // https://github.com/ethereum/EIPs/issues/20
4 interface ERC20 {
5     function totalSupply() external view returns (uint supply);
6     function balanceOf(address _owner) external view returns (uint balance);
7     function transfer(address _to, uint _value) external returns (bool success);
8     function transferFrom(address _from, address _to, uint _value) external returns (bool success);
9     function approve(address _spender, uint _value) external returns (bool success);
10     function allowance(address _owner, address _spender) external view returns (uint remaining);
11     function decimals() external view returns(uint digits);
12     event Approval(address indexed _owner, address indexed _spender, uint _value);
13 }
14 
15 contract ABERoll {
16     
17     ERC20 ABEToken = ERC20(0x1Dc2189B355B5F53b5fdF64d22891900b19FB5ea);
18     
19     /// *** Constants section
20     uint256 constant BASE_UNIT = 10 ** ABEToken.decimals() * 10000;//10 ** 18; // ABEToken.decimals() * 10000
21     // Each bet is deducted 1.5% in favour of the house, but no less than some minimum.
22     // The lower bound is dictated by gas costs of the settleBet transaction, providing
23     // headroom for up to 10 Gwei prices.
24     uint constant HOUSE_EDGE_PERCENT = 15;
25     uint constant HOUSE_EDGE_MINIMUM_AMOUNT = BASE_UNIT * 45/100000; //  0.00045 ABEToken
26 
27     // Bets lower than this amount do not participate in jackpot rolls (and are
28     // not deducted JACKPOT_FEE).
29     uint constant MIN_JACKPOT_BET = BASE_UNIT * 1/10; //0.1 ABEToken
30 
31     // Chance to win jackpot (currently 0.1%) and fee deducted into jackpot fund.
32     uint constant JACKPOT_MODULO = 1000;
33     uint constant JACKPOT_FEE = BASE_UNIT * 1/1000; //0.001 ABEToken
34 
35     // There is minimum and maximum bets.
36     uint constant MIN_BET = BASE_UNIT * 1 /100; // 0.01 ABEToken
37     uint constant MAX_AMOUNT =  BASE_UNIT * 300000; // 300000 ABEToken
38 
39     // Modulo is a number of equiprobable outcomes in a game:
40     //  - 2 for coin flip
41     //  - 6 for dice
42     //  - 6*6 = 36 for double dice
43     //  - 100 for etheroll
44     //  - 37 for roulette
45     //  etc.
46     // It's called so because 256-bit entropy is treated like a huge integer and
47     // the remainder of its division by modulo is considered bet outcome.
48     uint constant MAX_MODULO = 100;
49 
50     // For modulos below this threshold rolls are checked against a bit mask,
51     // thus allowing betting on any combination of outcomes. For example, given
52     // modulo 6 for dice, 101000 mask (base-2, big endian) means betting on
53     // 4 and 6; for games with modulos higher than threshold (Etheroll), a simple
54     // limit is used, allowing betting on any outcome in [0, N) range.
55     //
56     // The specific value is dictated by the fact that 256-bit intermediate
57     // multiplication result allows implementing population count efficiently
58     // for numbers that are up to 42 bits, and 40 is the highest multiple of
59     // eight below 42.
60     uint constant MAX_MASK_MODULO = 40;
61 
62     // This is a check on bet mask overflow.
63     uint constant MAX_BET_MASK = 2 ** MAX_MASK_MODULO;
64 
65     // EVM BLOCKHASH opcode can query no further than 256 blocks into the
66     // past. Given that settleBet uses block hash of placeBet as one of
67     // complementary entropy sources, we cannot process bets older than this
68     // threshold. On rare occasions EthRoll croupier may fail to invoke
69     // settleBet in this timespan due to technical issues or extreme Ethereum
70     // congestion; such bets can be refunded via invoking refundBet.
71     uint constant BET_EXPIRATION_BLOCKS = 250;
72 
73     // Some deliberately invalid address to initialize the secret signer with.
74     // Forces maintainers to invoke setSecretSigner before processing any bets.
75     address constant DUMMY_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
76 
77     // Standard contract ownership transfer.
78     address public owner;
79     address private nextOwner;
80 
81     // Adjustable max bet profit. Used to cap bets against dynamic odds.
82     uint public maxProfit;
83 
84     // The address corresponding to a private key used to sign placeBet commits.
85     address public secretSigner;
86 
87     // Accumulated jackpot fund.
88     uint128 public jackpotSize;
89 
90     // Funds that are locked in potentially winning bets. Prevents contract from
91     // committing to bets it cannot pay out.
92     uint128 public lockedInBets;
93 
94     address public beneficiary_ = 0xAdD148Cc4F7B1b7520325a7C5934C002420Ab3d5;
95     // A structure representing a single bet.
96     struct Bet {
97         // Wager amount in wei.
98         uint amount;
99         // Modulo of a game.
100         uint8 modulo;
101         // Number of winning outcomes, used to compute winning payment (* modulo/rollUnder),
102         // and used instead of mask for games with modulo > MAX_MASK_MODULO.
103         uint8 rollUnder;
104         // Block number of placeBet tx.
105         uint40 placeBlockNumber;
106         // Bit mask representing winning bet outcomes (see MAX_MASK_MODULO comment).
107         uint40 mask;
108         // Address of a gambler, used to pay out winning bets.
109         address gambler;
110     }
111 
112     // Mapping from commits to all currently active & processed bets.
113     mapping (uint => Bet) bets;
114 
115     // Croupier account.
116     address public croupier;
117 
118     // Events that are issued to make statistic recovery easier.
119     event FailedPayment(address indexed beneficiary, uint amount);
120     event Payment(address indexed beneficiary, uint amount);
121     event JackpotPayment(address indexed beneficiary, uint amount);
122 
123     // This event is emitted in placeBet to record commit in the logs.
124     event Commit(uint commit);
125 
126     // Constructor. Deliberately does not take any parameters.
127     constructor () public {
128         owner = msg.sender;
129         secretSigner = DUMMY_ADDRESS;
130         croupier = DUMMY_ADDRESS;
131     }
132 
133     // Standard modifier on methods invokable only by contract owner.
134     modifier onlyOwner {
135         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
136         _;
137     }
138 
139     // Standard modifier on methods invokable only by contract owner.
140     modifier onlyCroupier {
141         require (msg.sender == croupier, "OnlyCroupier methods called by non-croupier.");
142         _;
143     }
144 
145     // Standard contract ownership transfer implementation,
146     function approveNextOwner(address _nextOwner) external onlyOwner {
147         require (_nextOwner != owner, "Cannot approve current owner.");
148         nextOwner = _nextOwner;
149     }
150 
151     function acceptNextOwner() external {
152         require (msg.sender == nextOwner, "Can only accept preapproved new owner.");
153         owner = nextOwner;
154     }
155 
156     // Fallback function deliberately left empty. It's primary use case
157     // is to top up the bank roll.
158     function () public payable {
159     }
160 
161     // See comment for "secretSigner" variable.
162     function setSecretSigner(address newSecretSigner) external onlyOwner {
163         secretSigner = newSecretSigner;
164     }
165 
166     // Change the croupier address.
167     function setCroupier(address newCroupier) external onlyOwner {
168         croupier = newCroupier;
169     }
170 
171     // Change max bet reward. Setting this to zero effectively disables betting.
172     function setMaxProfit(uint _maxProfit) public onlyOwner {
173         require (_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
174         maxProfit = _maxProfit;
175     }
176 
177     // This function is used to bump up the jackpot fund. Cannot be used to lower it.
178     function increaseJackpot(uint increaseAmount) external onlyOwner {
179         require (increaseAmount <= ABEToken.balanceOf(this), "Increase amount larger than balance.");
180         require (jackpotSize + lockedInBets + increaseAmount <= ABEToken.balanceOf(this), "Not enough funds.");
181         jackpotSize += uint128(increaseAmount);
182     }
183 
184     // Funds withdrawal to cover costs of EthRoll operation.
185     function withdrawFunds(uint withdrawAmount) external onlyOwner {
186         require (withdrawAmount <= ABEToken.balanceOf(this), "Increase amount larger than balance.");
187         require (jackpotSize + lockedInBets + withdrawAmount <= ABEToken.balanceOf(this), "Not enough funds.");
188         sendFunds(beneficiary_, withdrawAmount, withdrawAmount);
189     }
190 
191     // Contract may be destroyed only when there are no ongoing bets,
192     // either settled or refunded. All funds are transferred to contract owner.
193     function kill() external onlyOwner {
194         require (lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
195         require(ABEToken.transfer(beneficiary_,ABEToken.balanceOf(address(this)))," send out all token failure");
196         selfdestruct(beneficiary_);
197     }
198 
199     /// *** Betting logic
200 
201     // Bet states:
202     //  amount == 0 && gambler == 0 - 'clean' (can place a bet)
203     //  amount != 0 && gambler != 0 - 'active' (can be settled or refunded)
204     //  amount == 0 && gambler != 0 - 'processed' (can clean storage)
205     //
206     //  NOTE: Storage cleaning is not implemented in this contract version; it will be added
207     //        with the next upgrade to prevent polluting Ethereum state with expired bets.
208 
209     // Bet placing transaction - issued by the player.
210     //  betMask         - bet outcomes bit mask for modulo <= MAX_MASK_MODULO,
211     //                    [0, betMask) for larger modulos.
212     //  modulo          - game modulo.
213     //  commitLastBlock - number of the maximum block where "commit" is still considered valid.
214     //  commit          - Keccak256 hash of some secret "reveal" random number, to be supplied
215     //                    by the EthRoll croupier bot in the settleBet transaction. Supplying
216     //                    "commit" ensures that "reveal" cannot be changed behind the scenes
217     //                    after placeBet have been mined.
218     //  r, s            - components of ECDSA signature of (commitLastBlock, commit). v is
219     //                    guaranteed to always equal 27.
220     //
221     // Commit, being essentially random 256-bit number, is used as a unique bet identifier in
222     // the 'bets' mapping.
223     //
224     // Commits are signed with a block limit to ensure that they are used at most once - otherwise
225     // it would be possible for a miner to place a bet with a known commit/reveal pair and tamper
226     // with the blockhash. Croupier guarantees that commitLastBlock will always be not greater than
227     // placeBet block number plus BET_EXPIRATION_BLOCKS. See whitepaper for details.
228     function placeBet(uint betMask, uint modulo, uint commitLastBlock, uint commit, bytes32 r, bytes32 s,uint amount) external {
229         // Check that the bet is in 'clean' state.
230         Bet storage bet = bets[commit];
231         require (bet.gambler == address(0), "Bet should be in a 'clean' state.");
232         
233         require(ABEToken.transferFrom(msg.sender,this,amount));//need user approve
234         
235         // Validate input data ranges.
236         // uint amount = msg.value;
237         require (modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
238         require (amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
239         require (betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
240 
241         // Check that commit is valid - it has not expired and its signature is valid.
242         require (block.number <= commitLastBlock, "Commit has expired.");
243         bytes32 signatureHash = keccak256(abi.encodePacked(uint40(commitLastBlock), commit));
244         require (secretSigner == ecrecover(signatureHash, 27, r, s), "ECDSA signature is not valid.");
245 
246         uint rollUnder;
247         uint mask;
248 
249         if (modulo <= MAX_MASK_MODULO) {
250             // Small modulo games specify bet outcomes via bit mask.
251             // rollUnder is a number of 1 bits in this mask (population count).
252             // This magic looking formula is an efficient way to compute population
253             // count on EVM for numbers below 2**40. For detailed proof consult
254             // the EthRoll whitepaper.
255             rollUnder = ((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
256             mask = betMask;
257         } else {
258             // Larger modulos specify the right edge of half-open interval of
259             // winning bet outcomes.
260             require (betMask > 0 && betMask <= modulo, "High modulo range, betMask larger than modulo.");
261             rollUnder = betMask;
262         }
263 
264         // Winning amount and jackpot increase.
265         uint possibleWinAmount;
266         uint jackpotFee;
267 
268         (possibleWinAmount, jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
269 
270         // Enforce max profit limit.
271         require (possibleWinAmount <= amount + maxProfit, "maxProfit limit violation.");
272 
273         // Lock funds.
274         lockedInBets += uint128(possibleWinAmount);
275         jackpotSize += uint128(jackpotFee);
276 
277         // Check whether contract has enough funds to process this bet.
278         require (jackpotSize + lockedInBets <= ABEToken.balanceOf(this), "Cannot afford to lose this bet.");
279 
280         // Record commit in logs.
281         emit Commit(commit);
282 
283         // Store bet parameters on blockchain.
284         bet.amount = amount;
285         bet.modulo = uint8(modulo);
286         bet.rollUnder = uint8(rollUnder);
287         bet.placeBlockNumber = uint40(block.number);
288         bet.mask = uint40(mask);
289         bet.gambler = msg.sender;
290     }
291 
292     // This is the method used to settle 99% of bets. To process a bet with a specific
293     // "commit", settleBet should supply a "reveal" number that would Keccak256-hash to
294     // "commit". "blockHash" is the block hash of placeBet block as seen by croupier; it
295     // is additionally asserted to prevent changing the bet outcomes on Ethereum reorgs.
296     function settleBet(uint reveal, bytes32 blockHash) external onlyCroupier {
297         uint commit = uint(keccak256(abi.encodePacked(reveal)));
298 
299         Bet storage bet = bets[commit];
300         uint placeBlockNumber = bet.placeBlockNumber;
301 
302         // Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
303         require (block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
304         require (block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
305         require (blockhash(placeBlockNumber) == blockHash);
306 
307         // Settle bet using reveal and blockHash as entropy sources.
308         settleBetCommon(bet, reveal, blockHash);
309     }
310 
311     // This method is used to settle a bet that was mined into an uncle block. At this
312     // point the player was shown some bet outcome, but the blockhash at placeBet height
313     // is different because of Ethereum chain reorg. We supply a full merkle proof of the
314     // placeBet transaction receipt to provide untamperable evidence that uncle block hash
315     // indeed was present on-chain at some point.
316     function settleBetUncleMerkleProof(uint reveal, uint40 canonicalBlockNumber) external onlyCroupier {
317         // "commit" for bet settlement can only be obtained by hashing a "reveal".
318         uint commit = uint(keccak256(abi.encodePacked(reveal)));
319 
320         Bet storage bet = bets[commit];
321 
322         // Check that canonical block hash can still be verified.
323         require (block.number <= canonicalBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
324 
325         // Verify placeBet receipt.
326         requireCorrectReceipt(4 + 32 + 32 + 4);
327 
328         // Reconstruct canonical & uncle block hashes from a receipt merkle proof, verify them.
329         bytes32 canonicalHash;
330         bytes32 uncleHash;
331         (canonicalHash, uncleHash) = verifyMerkleProof(commit, 4 + 32 + 32);
332         require (blockhash(canonicalBlockNumber) == canonicalHash);
333 
334         // Settle bet using reveal and uncleHash as entropy sources.
335         settleBetCommon(bet, reveal, uncleHash);
336     }
337 
338     // Common settlement code for settleBet & settleBetUncleMerkleProof.
339     function settleBetCommon(Bet storage bet, uint reveal, bytes32 entropyBlockHash) private {
340         // Fetch bet parameters into local variables (to save gas).
341         uint amount = bet.amount;
342         uint modulo = bet.modulo;
343         uint rollUnder = bet.rollUnder;
344         address gambler = bet.gambler;
345 
346         // Check that bet is in 'active' state.
347         require (amount != 0, "Bet should be in an 'active' state");
348 
349         // Move bet into 'processed' state already.
350         bet.amount = 0;
351 
352         // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
353         // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
354         // preimage is intractable), and house is unable to alter the "reveal" after
355         // placeBet have been mined (as Keccak256 collision finding is also intractable).
356         bytes32 entropy = keccak256(abi.encodePacked(reveal, entropyBlockHash));
357 
358         // Do a roll by taking a modulo of entropy. Compute winning amount.
359         uint dice = uint(entropy) % modulo;
360 
361         uint diceWinAmount;
362         uint _jackpotFee;
363         (diceWinAmount, _jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
364 
365         uint diceWin = 0;
366         uint jackpotWin = 0;
367 
368         // Determine dice outcome.
369         if (modulo <= MAX_MASK_MODULO) {
370             // For small modulo games, check the outcome against a bit mask.
371             if ((2 ** dice) & bet.mask != 0) {
372                 diceWin = diceWinAmount;
373             }
374 
375         } else {
376             // For larger modulos, check inclusion into half-open interval.
377             if (dice < rollUnder) {
378                 diceWin = diceWinAmount;
379             }
380 
381         }
382 
383         // Unlock the bet amount, regardless of the outcome.
384         lockedInBets -= uint128(diceWinAmount);
385 
386         // Roll for a jackpot (if eligible).
387         if (amount >= MIN_JACKPOT_BET) {
388             // The second modulo, statistically independent from the "main" dice roll.
389             // Effectively you are playing two games at once!
390             uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;
391 
392             // Bingo!
393             if (jackpotRng == 0) {
394                 jackpotWin = jackpotSize;
395                 jackpotSize = 0;
396             }
397         }
398 
399         // Log jackpot win.
400         if (jackpotWin > 0) {
401             emit JackpotPayment(gambler, jackpotWin);
402         }
403 
404         // Send the funds to gambler.
405         sendFunds(gambler, diceWin + jackpotWin == 0 ? 1 : diceWin + jackpotWin, diceWin);
406     }
407 
408     // Refund transaction - return the bet amount of a roll that was not processed in a
409     // due timeframe. Processing such blocks is not possible due to EVM limitations (see
410     // BET_EXPIRATION_BLOCKS comment above for details). In case you ever find yourself
411     // in a situation like this, just contact the EthRoll support, however nothing
412     // precludes you from invoking this method yourself.
413     function refundBet(uint commit) external {
414         // Check that bet is in 'active' state.
415         Bet storage bet = bets[commit];
416         uint amount = bet.amount;
417 
418         require (amount != 0, "Bet should be in an 'active' state");
419 
420         // Check that bet has already expired.
421         require (block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
422 
423         // Move bet into 'processed' state, release funds.
424         bet.amount = 0;
425 
426         uint diceWinAmount;
427         uint jackpotFee;
428         (diceWinAmount, jackpotFee) = getDiceWinAmount(amount, bet.modulo, bet.rollUnder);
429 
430         lockedInBets -= uint128(diceWinAmount);
431         jackpotSize -= uint128(jackpotFee);
432 
433         // Send the refund.
434         sendFunds(bet.gambler, amount, amount);
435     }
436 
437     // Get the expected win amount after house edge is subtracted.
438     function getDiceWinAmount(uint amount, uint modulo, uint rollUnder) private pure returns (uint winAmount, uint jackpotFee) {
439         require (0 < rollUnder && rollUnder <= modulo, "Win probability out of range.");
440 
441         jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
442 
443         uint houseEdge = amount * HOUSE_EDGE_PERCENT / 1000;
444 
445         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
446             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
447         }
448 
449         require (houseEdge + jackpotFee <= amount, "Bet doesn't even cover house edge.");
450         winAmount = (amount - houseEdge - jackpotFee) * modulo / rollUnder;
451     }
452 
453     // Helper routine to process the payment.
454     function sendFunds(address beneficiary, uint amount, uint successLogAmount) private {
455         if (ABEToken.transfer(beneficiary,amount)) {//beneficiary.call.value(amount)()
456             emit Payment(beneficiary, successLogAmount);
457         } else {
458             emit FailedPayment(beneficiary, amount);
459         }
460     }
461 
462     // This are some constants making O(1) population count in placeBet possible.
463     // See whitepaper for intuition and proofs behind it.
464     uint constant POPCNT_MULT = 0x0000000000002000000000100000000008000000000400000000020000000001;
465     uint constant POPCNT_MASK = 0x0001041041041041041041041041041041041041041041041041041041041041;
466     uint constant POPCNT_MODULO = 0x3F;
467 
468     // *** Merkle proofs.
469 
470     // This helpers are used to verify cryptographic proofs of placeBet inclusion into
471     // uncle blocks. They are used to prevent bet outcome changing on Ethereum reorgs without
472     // compromising the security of the smart contract. Proof data is appended to the input data
473     // in a simple prefix length format and does not adhere to the ABI.
474     // Invariants checked:
475     //  - receipt trie entry contains a (1) successful transaction (2) directed at this smart
476     //    contract (3) containing commit as a payload.
477     //  - receipt trie entry is a part of a valid merkle proof of a block header
478     //  - the block header is a part of uncle list of some block on canonical chain
479     // The implementation is optimized for gas cost and relies on the specifics of Ethereum internal data structures.
480     // Read the whitepaper for details.
481 
482     // Helper to verify a full merkle proof starting from some seedHash (usually commit). "offset" is the location of the proof
483     // beginning in the calldata.
484     function verifyMerkleProof(uint seedHash, uint offset) pure private returns (bytes32 blockHash, bytes32 uncleHash) {
485         // (Safe) assumption - nobody will write into RAM during this method invocation.
486         uint scratchBuf1;  assembly { scratchBuf1 := mload(0x40) }
487 
488         uint uncleHeaderLength; uint blobLength; uint shift; uint hashSlot;
489 
490         // Verify merkle proofs up to uncle block header. Calldata layout is:
491         //  - 2 byte big-endian slice length
492         //  - 2 byte big-endian offset to the beginning of previous slice hash within the current slice (should be zeroed)
493         //  - followed by the current slice verbatim
494         for (;; offset += blobLength) {
495             assembly { blobLength := and(calldataload(sub(offset, 30)), 0xffff) }
496             if (blobLength == 0) {
497                 // Zero slice length marks the end of uncle proof.
498                 break;
499             }
500 
501             assembly { shift := and(calldataload(sub(offset, 28)), 0xffff) }
502             require (shift + 32 <= blobLength, "Shift bounds check.");
503 
504             offset += 4;
505             assembly { hashSlot := calldataload(add(offset, shift)) }
506             require (hashSlot == 0, "Non-empty hash slot.");
507 
508             assembly {
509                 calldatacopy(scratchBuf1, offset, blobLength)
510                 mstore(add(scratchBuf1, shift), seedHash)
511                 seedHash := sha3(scratchBuf1, blobLength)
512                 uncleHeaderLength := blobLength
513             }
514         }
515 
516         // At this moment the uncle hash is known.
517         uncleHash = bytes32(seedHash);
518 
519         // Construct the uncle list of a canonical block.
520         uint scratchBuf2 = scratchBuf1 + uncleHeaderLength;
521         uint unclesLength; assembly { unclesLength := and(calldataload(sub(offset, 28)), 0xffff) }
522         uint unclesShift;  assembly { unclesShift := and(calldataload(sub(offset, 26)), 0xffff) }
523         require (unclesShift + uncleHeaderLength <= unclesLength, "Shift bounds check.");
524 
525         offset += 6;
526         assembly { calldatacopy(scratchBuf2, offset, unclesLength) }
527         memcpy(scratchBuf2 + unclesShift, scratchBuf1, uncleHeaderLength);
528 
529         assembly { seedHash := sha3(scratchBuf2, unclesLength) }
530 
531         offset += unclesLength;
532 
533         // Verify the canonical block header using the computed sha3Uncles.
534         assembly {
535             blobLength := and(calldataload(sub(offset, 30)), 0xffff)
536             shift := and(calldataload(sub(offset, 28)), 0xffff)
537         }
538         require (shift + 32 <= blobLength, "Shift bounds check.");
539 
540         offset += 4;
541         assembly { hashSlot := calldataload(add(offset, shift)) }
542         require (hashSlot == 0, "Non-empty hash slot.");
543 
544         assembly {
545             calldatacopy(scratchBuf1, offset, blobLength)
546             mstore(add(scratchBuf1, shift), seedHash)
547 
548             // At this moment the canonical block hash is known.
549             blockHash := sha3(scratchBuf1, blobLength)
550         }
551     }
552 
553     // Helper to check the placeBet receipt. "offset" is the location of the proof beginning in the calldata.
554     // RLP layout: [triePath, str([status, cumGasUsed, bloomFilter, [[address, [topics], data]])]
555     function requireCorrectReceipt(uint offset) view private {
556         uint leafHeaderByte; assembly { leafHeaderByte := byte(0, calldataload(offset)) }
557 
558         require (leafHeaderByte >= 0xf7, "Receipt leaf longer than 55 bytes.");
559         offset += leafHeaderByte - 0xf6;
560 
561         uint pathHeaderByte; assembly { pathHeaderByte := byte(0, calldataload(offset)) }
562 
563         if (pathHeaderByte <= 0x7f) {
564             offset += 1;
565 
566         } else {
567             require (pathHeaderByte >= 0x80 && pathHeaderByte <= 0xb7, "Path is an RLP string.");
568             offset += pathHeaderByte - 0x7f;
569         }
570 
571         uint receiptStringHeaderByte; assembly { receiptStringHeaderByte := byte(0, calldataload(offset)) }
572         require (receiptStringHeaderByte == 0xb9, "Receipt string is always at least 256 bytes long, but less than 64k.");
573         offset += 3;
574 
575         uint receiptHeaderByte; assembly { receiptHeaderByte := byte(0, calldataload(offset)) }
576         require (receiptHeaderByte == 0xf9, "Receipt is always at least 256 bytes long, but less than 64k.");
577         offset += 3;
578 
579         uint statusByte; assembly { statusByte := byte(0, calldataload(offset)) }
580         require (statusByte == 0x1, "Status should be success.");
581         offset += 1;
582 
583         uint cumGasHeaderByte; assembly { cumGasHeaderByte := byte(0, calldataload(offset)) }
584         if (cumGasHeaderByte <= 0x7f) {
585             offset += 1;
586 
587         } else {
588             require (cumGasHeaderByte >= 0x80 && cumGasHeaderByte <= 0xb7, "Cumulative gas is an RLP string.");
589             offset += cumGasHeaderByte - 0x7f;
590         }
591 
592         uint bloomHeaderByte; assembly { bloomHeaderByte := byte(0, calldataload(offset)) }
593         require (bloomHeaderByte == 0xb9, "Bloom filter is always 256 bytes long.");
594         offset += 256 + 3;
595 
596         uint logsListHeaderByte; assembly { logsListHeaderByte := byte(0, calldataload(offset)) }
597         require (logsListHeaderByte == 0xf8, "Logs list is less than 256 bytes long.");
598         offset += 2;
599 
600         uint logEntryHeaderByte; assembly { logEntryHeaderByte := byte(0, calldataload(offset)) }
601         require (logEntryHeaderByte == 0xf8, "Log entry is less than 256 bytes long.");
602         offset += 2;
603 
604         uint addressHeaderByte; assembly { addressHeaderByte := byte(0, calldataload(offset)) }
605         require (addressHeaderByte == 0x94, "Address is 20 bytes long.");
606 
607         uint logAddress; assembly { logAddress := and(calldataload(sub(offset, 11)), 0xffffffffffffffffffffffffffffffffffffffff) }
608         require (logAddress == uint(address(this)));
609     }
610 
611     // Memory copy.
612     function memcpy(uint dest, uint src, uint len) pure private {
613         // Full 32 byte words
614         for(; len >= 32; len -= 32) {
615             assembly { mstore(dest, mload(src)) }
616             dest += 32; src += 32;
617         }
618 
619         // Remaining bytes
620         uint mask = 256 ** (32 - len) - 1;
621         assembly {
622             let srcpart := and(mload(src), not(mask))
623             let destpart := and(mload(dest), mask)
624             mstore(dest, or(destpart, srcpart))
625         }
626     }
627 }