1 pragma solidity ^0.5.0;
2 
3 contract GoDice{
4 
5     uint constant HOUSE_EDGE_PERCENT = 1;
6     uint constant HOUSE_EDGE_MINIMUM_AMOUNT = 0.0003 ether;
7 
8     uint constant MIN_JACKPOT_BET = 0.1 ether;
9 
10     uint constant JACKPOT_MODULO = 1000;
11     uint constant JACKPOT_FEE = 0.001 ether;
12 
13     uint constant MIN_BET = 0.01 ether;
14     uint constant MAX_AMOUNT = 300000 ether;
15 
16     uint constant MAX_MODULO = 100;
17 
18     uint constant MAX_MASK_MODULO = 40;
19 
20     uint constant MAX_BET_MASK = 2 ** MAX_MASK_MODULO;
21 
22     uint constant BET_EXPIRATION_BLOCKS = 250;
23 
24     address constant DUMMY_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
25 
26     address payable public owner;
27     address payable private nextOwner;
28 
29     uint public maxProfit;
30 
31     address public secretSigner;
32 
33     uint128 public jackpotSize;
34 
35     uint128 public lockedInBets;
36 
37     struct Bet {
38         uint amount;
39         uint8 modulo;
40         uint8 rollUnder;
41         uint40 placeBlockNumber;
42         uint40 mask;
43         address payable gambler;
44     }
45 
46     mapping (uint => Bet) bets;
47 
48     address public croupier;
49 
50     // Events that are issued to make statistic recovery easier.
51     event FailedPayment(address indexed beneficiary, uint amount);
52     event Payment(address indexed beneficiary, uint amount);
53     event JackpotPayment(address indexed beneficiary, uint amount);
54 
55     // This event is emitted in placeBet to record commit in the logs.
56     event Commit(uint commit);
57 
58     // Constructor. Deliberately does not take any parameters.
59     constructor () public {
60         owner = msg.sender;
61         secretSigner = DUMMY_ADDRESS;
62         croupier = DUMMY_ADDRESS;
63     }
64 
65     // Standard modifier on methods invokable only by contract owner.
66     modifier onlyOwner {
67         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
68         _;
69     }
70 
71     // Standard modifier on methods invokable only by contract owner.
72     modifier onlyCroupier {
73         require (msg.sender == croupier, "OnlyCroupier methods called by non-croupier.");
74         _;
75     }
76 
77     // Standard contract ownership transfer implementation,
78     function approveNextOwner(address payable _nextOwner) external onlyOwner {
79         require (_nextOwner != owner, "Cannot approve current owner.");
80         nextOwner = _nextOwner;
81     }
82 
83     function acceptNextOwner() external {
84         require (msg.sender == nextOwner, "Can only accept preapproved new owner.");
85         owner = nextOwner;
86     }
87 
88     // Fallback function deliberately left empty. It's primary use case
89     // is to top up the bank roll.
90     function () external payable {
91     }
92 
93     // See comment for "secretSigner" variable.
94     function setSecretSigner(address newSecretSigner) external onlyOwner {
95         secretSigner = newSecretSigner;
96     }
97 
98     // Change the croupier address.
99     function setCroupier(address newCroupier) external onlyOwner {
100         croupier = newCroupier;
101     }
102 
103     // Change max bet reward. Setting this to zero effectively disables betting.
104     function setMaxProfit(uint _maxProfit) public onlyOwner {
105         require (_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
106         maxProfit = _maxProfit;
107     }
108 
109     // This function is used to bump up the jackpot fund. Cannot be used to lower it.
110     function increaseJackpot(uint increaseAmount) external onlyOwner {
111         require (increaseAmount <= address(this).balance, "Increase amount larger than balance.");
112         require (jackpotSize + lockedInBets + increaseAmount <= address(this).balance, "Not enough funds.");
113         jackpotSize += uint128(increaseAmount);
114     }
115 
116     // Funds withdrawal to cover costs of dice2.win operation.
117     function withdrawFunds(address payable beneficiary, uint withdrawAmount) external onlyOwner {
118         require (withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
119         require (jackpotSize + lockedInBets + withdrawAmount <= address(this).balance, "Not enough funds.");
120         sendFunds(beneficiary, withdrawAmount, withdrawAmount);
121     }
122 
123     function kill() external onlyOwner {
124         require (lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
125         selfdestruct(owner);
126     }
127 
128 
129     function placeBet(uint betMask, uint modulo, uint commitLastBlock, uint commit, uint8 v, bytes32 r, bytes32 s) external payable {
130         // Check that the bet is in 'clean' state.
131         Bet storage bet = bets[commit];
132         require (bet.gambler == address(0), "Bet should be in a 'clean' state.");
133 
134         // Validate input data ranges.
135         uint amount = msg.value;
136         require (modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
137         require (amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
138         require (betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
139 
140         // Check that commit is valid - it has not expired and its signature is valid.
141         require (block.number <= commitLastBlock, "Commit has expired.");
142         bytes32 signatureHash = keccak256(abi.encodePacked(commitLastBlock, commit));
143         require (secretSigner == ecrecover(signatureHash, v, r, s), "ECDSA signature is not valid.");
144 
145         uint rollUnder;
146         uint mask;
147 
148         if (modulo <= MAX_MASK_MODULO) {
149             // Small modulo games specify bet outcomes via bit mask.
150             // rollUnder is a number of 1 bits in this mask (population count).
151             // This magic looking formula is an efficient way to compute population
152             // count on EVM for numbers below 2**40. For detailed proof consult
153             // the dice2.win whitepaper.
154             rollUnder = ((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
155             mask = betMask;
156         } else {
157             // Larger modulos specify the right edge of half-open interval of
158             // winning bet outcomes.
159             require (betMask > 0 && betMask <= modulo, "High modulo range, betMask larger than modulo.");
160             rollUnder = betMask;
161         }
162 
163         // Winning amount and jackpot increase.
164         uint possibleWinAmount;
165         uint jackpotFee;
166 
167         (possibleWinAmount, jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
168 
169         // Enforce max profit limit.
170         require (possibleWinAmount <= amount + maxProfit, "maxProfit limit violation.");
171 
172         // Lock funds.
173         lockedInBets += uint128(possibleWinAmount);
174         jackpotSize += uint128(jackpotFee);
175 
176         // Check whether contract has enough funds to process this bet.
177         require (jackpotSize + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
178 
179         // Record commit in logs.
180         emit Commit(commit);
181 
182         // Store bet parameters on blockchain.
183         bet.amount = amount;
184         bet.modulo = uint8(modulo);
185         bet.rollUnder = uint8(rollUnder);
186         bet.placeBlockNumber = uint40(block.number);
187         bet.mask = uint40(mask);
188         bet.gambler = msg.sender;
189     }
190 
191     // This is the method used to settle 99% of bets. To process a bet with a specific
192     // "commit", settleBet should supply a "reveal" number that would Keccak256-hash to
193     // "commit". "blockHash" is the block hash of placeBet block as seen by croupier; it
194     // is additionally asserted to prevent changing the bet outcomes on Ethereum reorgs.
195     function settleBet(uint reveal, bytes32 blockHash) external onlyCroupier {
196         uint commit = uint(keccak256(abi.encodePacked(reveal)));
197 
198         Bet storage bet = bets[commit];
199         uint placeBlockNumber = bet.placeBlockNumber;
200 
201         // Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
202         require (block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
203         require (block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
204         require (blockhash(placeBlockNumber) == blockHash);
205 
206         // Settle bet using reveal and blockHash as entropy sources.
207         settleBetCommon(bet, reveal, blockHash);
208     }
209 
210     function settleBetUncleMerkleProof(uint reveal, uint40 canonicalBlockNumber) external onlyCroupier {
211         // "commit" for bet settlement can only be obtained by hashing a "reveal".
212         uint commit = uint(keccak256(abi.encodePacked(reveal)));
213 
214         Bet storage bet = bets[commit];
215 
216         // Check that canonical block hash can still be verified.
217         require (block.number <= canonicalBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
218 
219         // Verify placeBet receipt.
220         requireCorrectReceipt(4 + 32 + 32 + 4);
221 
222         // Reconstruct canonical & uncle block hashes from a receipt merkle proof, verify them.
223         bytes32 canonicalHash;
224         bytes32 uncleHash;
225         (canonicalHash, uncleHash) = verifyMerkleProof(commit, 4 + 32 + 32);
226         require (blockhash(canonicalBlockNumber) == canonicalHash);
227 
228         // Settle bet using reveal and uncleHash as entropy sources.
229         settleBetCommon(bet, reveal, uncleHash);
230     }
231 
232     // Common settlement code for settleBet & settleBetUncleMerkleProof.
233     function settleBetCommon(Bet storage bet, uint reveal, bytes32 entropyBlockHash) private {
234         // Fetch bet parameters into local variables (to save gas).
235         uint amount = bet.amount;
236         uint modulo = bet.modulo;
237         uint rollUnder = bet.rollUnder;
238         address payable gambler = bet.gambler;
239 
240         // Check that bet is in 'active' state.
241         require (amount != 0, "Bet should be in an 'active' state");
242 
243         // Move bet into 'processed' state already.
244         bet.amount = 0;
245 
246 
247         bytes32 entropy = keccak256(abi.encodePacked(reveal, entropyBlockHash));
248 
249         // Do a roll by taking a modulo of entropy. Compute winning amount.
250         uint dice = uint(entropy) % modulo;
251 
252         uint diceWinAmount;
253         uint _jackpotFee;
254         (diceWinAmount, _jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
255 
256         uint diceWin = 0;
257         uint jackpotWin = 0;
258 
259         // Determine dice outcome.
260         if (modulo <= MAX_MASK_MODULO) {
261             // For small modulo games, check the outcome against a bit mask.
262             if ((2 ** dice) & bet.mask != 0) {
263                 diceWin = diceWinAmount;
264             }
265 
266         } else {
267             // For larger modulos, check inclusion into half-open interval.
268             if (dice < rollUnder) {
269                 diceWin = diceWinAmount;
270             }
271 
272         }
273 
274         // Unlock the bet amount, regardless of the outcome.
275         lockedInBets -= uint128(diceWinAmount);
276 
277         // Roll for a jackpot (if eligible).
278         if (amount >= MIN_JACKPOT_BET) {
279             // The second modulo, statistically independent from the "main" dice roll.
280             // Effectively you are playing two games at once!
281             uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;
282 
283             // Bingo!
284             if (jackpotRng == 0) {
285                 jackpotWin = jackpotSize;
286                 jackpotSize = 0;
287             }
288         }
289 
290         // Log jackpot win.
291         if (jackpotWin > 0) {
292             emit JackpotPayment(gambler, jackpotWin);
293         }
294 
295         // Send the funds to gambler.
296         sendFunds(gambler, diceWin + jackpotWin == 0 ? 1 wei : diceWin + jackpotWin, diceWin);
297     }
298 
299 
300     function refundBet(uint commit) external {
301         // Check that bet is in 'active' state.
302         Bet storage bet = bets[commit];
303         uint amount = bet.amount;
304 
305         require (amount != 0, "Bet should be in an 'active' state");
306 
307         // Check that bet has already expired.
308         require (block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
309 
310         // Move bet into 'processed' state, release funds.
311         bet.amount = 0;
312 
313         uint diceWinAmount;
314         uint jackpotFee;
315         (diceWinAmount, jackpotFee) = getDiceWinAmount(amount, bet.modulo, bet.rollUnder);
316 
317         lockedInBets -= uint128(diceWinAmount);
318         jackpotSize -= uint128(jackpotFee);
319 
320         // Send the refund.
321         sendFunds(bet.gambler, amount, amount);
322     }
323 
324     // Get the expected win amount after house edge is subtracted.
325     function getDiceWinAmount(uint amount, uint modulo, uint rollUnder) private pure returns (uint winAmount, uint jackpotFee) {
326         require (0 < rollUnder && rollUnder <= modulo, "Win probability out of range.");
327 
328         jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
329 
330         uint houseEdge = amount * HOUSE_EDGE_PERCENT / 100;
331 
332         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
333             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
334         }
335 
336         require (houseEdge + jackpotFee <= amount, "Bet doesn't even cover house edge.");
337         winAmount = (amount - houseEdge - jackpotFee) * modulo / rollUnder;
338     }
339 
340     // Helper routine to process the payment.
341     function sendFunds(address payable beneficiary, uint amount, uint successLogAmount) private {
342         if (beneficiary.send(amount)) {
343             emit Payment(beneficiary, successLogAmount);
344         } else {
345             emit FailedPayment(beneficiary, amount);
346         }
347     }
348 
349     // This are some constants making O(1) population count in placeBet possible.
350     // See whitepaper for intuition and proofs behind it.
351     uint constant POPCNT_MULT = 0x0000000000002000000000100000000008000000000400000000020000000001;
352     uint constant POPCNT_MASK = 0x0001041041041041041041041041041041041041041041041041041041041041;
353     uint constant POPCNT_MODULO = 0x3F;
354 
355 
356     function verifyMerkleProof(uint seedHash, uint offset) pure private returns (bytes32 blockHash, bytes32 uncleHash) {
357         // (Safe) assumption - nobody will write into RAM during this method invocation.
358         uint scratchBuf1;  assembly { scratchBuf1 := mload(0x40) }
359 
360         uint uncleHeaderLength; uint blobLength; uint shift; uint hashSlot;
361 
362 
363         for (;; offset += blobLength) {
364             assembly { blobLength := and(calldataload(sub(offset, 30)), 0xffff) }
365             if (blobLength == 0) {
366                 // Zero slice length marks the end of uncle proof.
367                 break;
368             }
369 
370             assembly { shift := and(calldataload(sub(offset, 28)), 0xffff) }
371             require (shift + 32 <= blobLength, "Shift bounds check.");
372 
373             offset += 4;
374             assembly { hashSlot := calldataload(add(offset, shift)) }
375             require (hashSlot == 0, "Non-empty hash slot.");
376 
377             assembly {
378                 calldatacopy(scratchBuf1, offset, blobLength)
379                 mstore(add(scratchBuf1, shift), seedHash)
380                 seedHash := keccak256(scratchBuf1, blobLength)
381                 uncleHeaderLength := blobLength
382             }
383         }
384 
385         // At this moment the uncle hash is known.
386         uncleHash = bytes32(seedHash);
387 
388         // Construct the uncle list of a canonical block.
389         uint scratchBuf2 = scratchBuf1 + uncleHeaderLength;
390         uint unclesLength; assembly { unclesLength := and(calldataload(sub(offset, 28)), 0xffff) }
391         uint unclesShift;  assembly { unclesShift := and(calldataload(sub(offset, 26)), 0xffff) }
392         require (unclesShift + uncleHeaderLength <= unclesLength, "Shift bounds check.");
393 
394         offset += 6;
395         assembly { calldatacopy(scratchBuf2, offset, unclesLength) }
396         memcpy(scratchBuf2 + unclesShift, scratchBuf1, uncleHeaderLength);
397 
398         assembly { seedHash := keccak256(scratchBuf2, unclesLength) }
399 
400         offset += unclesLength;
401 
402         // Verify the canonical block header using the computed sha3Uncles.
403         assembly {
404             blobLength := and(calldataload(sub(offset, 30)), 0xffff)
405             shift := and(calldataload(sub(offset, 28)), 0xffff)
406         }
407         require (shift + 32 <= blobLength, "Shift bounds check.");
408 
409         offset += 4;
410         assembly { hashSlot := calldataload(add(offset, shift)) }
411         require (hashSlot == 0, "Non-empty hash slot.");
412 
413         assembly {
414             calldatacopy(scratchBuf1, offset, blobLength)
415             mstore(add(scratchBuf1, shift), seedHash)
416 
417             // At this moment the canonical block hash is known.
418             blockHash := keccak256(scratchBuf1, blobLength)
419         }
420     }
421 
422     // Helper to check the placeBet receipt. "offset" is the location of the proof beginning in the calldata.
423     // RLP layout: [triePath, str([status, cumGasUsed, bloomFilter, [[address, [topics], data]])]
424     function requireCorrectReceipt(uint offset) view private {
425         uint leafHeaderByte; assembly { leafHeaderByte := byte(0, calldataload(offset)) }
426 
427         require (leafHeaderByte >= 0xf7, "Receipt leaf longer than 55 bytes.");
428         offset += leafHeaderByte - 0xf6;
429 
430         uint pathHeaderByte; assembly { pathHeaderByte := byte(0, calldataload(offset)) }
431 
432         if (pathHeaderByte <= 0x7f) {
433             offset += 1;
434 
435         } else {
436             require (pathHeaderByte >= 0x80 && pathHeaderByte <= 0xb7, "Path is an RLP string.");
437             offset += pathHeaderByte - 0x7f;
438         }
439 
440         uint receiptStringHeaderByte; assembly { receiptStringHeaderByte := byte(0, calldataload(offset)) }
441         require (receiptStringHeaderByte == 0xb9, "Receipt string is always at least 256 bytes long, but less than 64k.");
442         offset += 3;
443 
444         uint receiptHeaderByte; assembly { receiptHeaderByte := byte(0, calldataload(offset)) }
445         require (receiptHeaderByte == 0xf9, "Receipt is always at least 256 bytes long, but less than 64k.");
446         offset += 3;
447 
448         uint statusByte; assembly { statusByte := byte(0, calldataload(offset)) }
449         require (statusByte == 0x1, "Status should be success.");
450         offset += 1;
451 
452         uint cumGasHeaderByte; assembly { cumGasHeaderByte := byte(0, calldataload(offset)) }
453         if (cumGasHeaderByte <= 0x7f) {
454             offset += 1;
455 
456         } else {
457             require (cumGasHeaderByte >= 0x80 && cumGasHeaderByte <= 0xb7, "Cumulative gas is an RLP string.");
458             offset += cumGasHeaderByte - 0x7f;
459         }
460 
461         uint bloomHeaderByte; assembly { bloomHeaderByte := byte(0, calldataload(offset)) }
462         require (bloomHeaderByte == 0xb9, "Bloom filter is always 256 bytes long.");
463         offset += 256 + 3;
464 
465         uint logsListHeaderByte; assembly { logsListHeaderByte := byte(0, calldataload(offset)) }
466         require (logsListHeaderByte == 0xf8, "Logs list is less than 256 bytes long.");
467         offset += 2;
468 
469         uint logEntryHeaderByte; assembly { logEntryHeaderByte := byte(0, calldataload(offset)) }
470         require (logEntryHeaderByte == 0xf8, "Log entry is less than 256 bytes long.");
471         offset += 2;
472 
473         uint addressHeaderByte; assembly { addressHeaderByte := byte(0, calldataload(offset)) }
474         require (addressHeaderByte == 0x94, "Address is 20 bytes long.");
475 
476         uint logAddress; assembly { logAddress := and(calldataload(sub(offset, 11)), 0xffffffffffffffffffffffffffffffffffffffff) }
477         require (logAddress == uint(address(this)));
478     }
479 
480     // Memory copy.
481     function memcpy(uint dest, uint src, uint len) pure private {
482         // Full 32 byte words
483         for(; len >= 32; len -= 32) {
484             assembly { mstore(dest, mload(src)) }
485             dest += 32; src += 32;
486         }
487 
488         // Remaining bytes
489         uint mask = 256 ** (32 - len) - 1;
490         assembly {
491             let srcpart := and(mload(src), not(mask))
492             let destpart := and(mload(dest), mask)
493             mstore(dest, or(destpart, srcpart))
494         }
495     }
496 
497     function TestRecover(uint msgA,uint msgB, uint8 v, bytes32 r, bytes32 s) public pure returns (address) {
498         bytes32 msgHash = keccak256(abi.encodePacked(msgA,msgB));
499         return ecrecover(msgHash, v, r, s);
500     }
501 
502     function getSecretSigner() view public returns(address) {
503         return secretSigner;
504     }
505 
506 }