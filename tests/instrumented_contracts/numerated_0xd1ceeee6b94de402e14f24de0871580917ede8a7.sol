1 pragma solidity ^0.4.23;
2 
3 // * dice2.win - fair games that pay Ether.
4 //
5 // * Ethereum smart contract, deployed at 0xD1CEeee6B94DE402e14F24De0871580917ede8a7.
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
114     // Constructor. Deliberately does not take any parameters.
115     constructor () public {
116         owner = msg.sender;
117         secretSigner = DUMMY_ADDRESS;
118     }
119 
120     // Standard modifier on methods invokable only by contract owner.
121     modifier onlyOwner {
122         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
123         _;
124     }
125 
126     // Standard contract ownership transfer implementation,
127     function approveNextOwner(address _nextOwner) external onlyOwner {
128         require (_nextOwner != owner, "Cannot approve current owner.");
129         nextOwner = _nextOwner;
130     }
131 
132     function acceptNextOwner() external {
133         require (msg.sender == nextOwner, "Can only accept preapproved new owner.");
134         owner = nextOwner;
135     }
136 
137     // Fallback function deliberately left empty. It's primary use case
138     // is to top up the bank roll.
139     function () public payable {
140     }
141 
142     // See comment for "secretSigner" variable.
143     function setSecretSigner(address newSecretSigner) external onlyOwner {
144         secretSigner = newSecretSigner;
145     }
146 
147     // Change max bet reward. Setting this to zero effectively disables betting.
148     function setMaxProfit(uint _maxProfit) public onlyOwner {
149         require (_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
150         maxProfit = _maxProfit;
151     }
152 
153     // This function is used to bump up the jackpot fund. Cannot be used to lower it.
154     function increaseJackpot(uint increaseAmount) external onlyOwner {
155         require (increaseAmount <= address(this).balance, "Increase amount larger than balance.");
156         require (jackpotSize + lockedInBets + increaseAmount <= address(this).balance, "Not enough funds.");
157         jackpotSize += uint128(increaseAmount);
158     }
159 
160     // Funds withdrawal to cover costs of dice2.win operation.
161     function withdrawFunds(address beneficiary, uint withdrawAmount) external onlyOwner {
162         require (withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
163         require (jackpotSize + lockedInBets + withdrawAmount <= address(this).balance, "Not enough funds.");
164         sendFunds(beneficiary, withdrawAmount, withdrawAmount);
165     }
166 
167     // Contract may be destroyed only when there are no ongoing bets,
168     // either settled or refunded. All funds are transferred to contract owner.
169     function kill() external onlyOwner {
170         require (lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
171         selfdestruct(owner);
172     }
173 
174     /// *** Betting logic
175 
176     // Bet states:
177     //  amount == 0 && gambler == 0 - 'clean' (can place a bet)
178     //  amount != 0 && gambler != 0 - 'active' (can be settled or refunded)
179     //  amount == 0 && gambler != 0 - 'processed' (can clean storage)
180 
181     // Bet placing transaction - issued by the player.
182     //  betMask         - bet outcomes bit mask for modulo <= MAX_MASK_MODULO,
183     //                    [0, betMask) for larger modulos.
184     //  modulo          - game modulo.
185     //  commitLastBlock - number of the maximum block where "commit" is still considered valid.
186     //  commit          - Keccak256 hash of some secret "reveal" random number, to be supplied
187     //                    by the dice2.win croupier bot in the settleBet transaction. Supplying
188     //                    "commit" ensures that "reveal" cannot be changed behind the scenes
189     //                    after placeBet have been mined.
190     //  r, s            - components of ECDSA signature of (commitLastBlock, commit). v is
191     //                    guaranteed to always equal 27.
192     //
193     // Commit, being essentially random 256-bit number, is used as a unique bet identifier in
194     // the 'bets' mapping.
195     //
196     // Commits are signed with a block limit to ensure that they are used at most once - otherwise
197     // it would be possible for a miner to place a bet with a known commit/reveal pair and tamper
198     // with the blockhash. Croupier guarantees that commitLastBlock will always be not greater than
199     // placeBet block number plus BET_EXPIRATION_BLOCKS. See whitepaper for details.
200     function placeBet(uint betMask, uint modulo, uint commitLastBlock, uint commit, bytes32 r, bytes32 s) external payable {
201         // Check that the bet is in 'clean' state.
202         Bet storage bet = bets[commit];
203         require (bet.gambler == address(0), "Bet should be in a 'clean' state.");
204 
205         // Validate input data ranges.
206         uint amount = msg.value;
207         require (modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
208         require (amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
209         require (betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
210 
211         // Check that commit is valid - it has not expired and its signature is valid.
212         require (block.number <= commitLastBlock, "Commit has expired.");
213         bytes32 signatureHash = keccak256(abi.encodePacked(uint40(commitLastBlock), commit));
214         require (secretSigner == ecrecover(signatureHash, 27, r, s), "ECDSA signature is not valid.");
215 
216         uint rollUnder;
217         uint mask;
218 
219         if (modulo <= MAX_MASK_MODULO) {
220             // Small modulo games specify bet outcomes via bit mask.
221             // rollUnder is a number of 1 bits in this mask (population count).
222             // This magic looking formula is an efficient way to compute population
223             // count on EVM for numbers below 2**40. For detailed proof consult
224             // the dice2.win whitepaper.
225             rollUnder = ((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
226             mask = betMask;
227         } else {
228             // Larger modulos specify the right edge of half-open interval of
229             // winning bet outcomes.
230             require (betMask > 0 && betMask <= modulo, "High modulo range, betMask larger than modulo.");
231             rollUnder = betMask;
232         }
233 
234         // Winning amount and jackpot increase.
235         uint possibleWinAmount = getDiceWinAmount(amount, modulo, rollUnder);
236         uint jackpotFee = getJackpotFee(amount);
237 
238         // Enforce max profit limit.
239         require (possibleWinAmount <= amount + maxProfit, "maxProfit limit violation.");
240 
241         // Lock funds.
242         lockedInBets += uint128(possibleWinAmount);
243         jackpotSize += uint128(jackpotFee);
244 
245         // Check whether contract has enough funds to process this bet.
246         require (jackpotSize + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
247 
248         // Store bet parameters on blockchain.
249         bet.amount = amount;
250         bet.modulo = uint8(modulo);
251         bet.rollUnder = uint8(rollUnder);
252         bet.placeBlockNumber = uint40(block.number);
253         bet.mask = uint40(mask);
254         bet.gambler = msg.sender;
255     }
256 
257     // Settlement transaction - can in theory be issued by anyone, but is designed to be
258     // handled by the dice2.win croupier bot. To settle a bet with a specific "commit",
259     // settleBet should supply a "reveal" number that would Keccak256-hash to
260     // "commit". clean_commit is some previously 'processed' bet, that will be moved into
261     // 'clean' state to prevent blockchain bloat and refund some gas.
262     function settleBet(uint reveal, uint cleanCommit) external {
263         // "commit" for bet settlement can only be obtained by hashing a "reveal".
264         uint commit = uint(keccak256(abi.encodePacked(reveal)));
265 
266         // Fetch bet parameters into local variables (to save gas).
267         Bet storage bet = bets[commit];
268         uint amount = bet.amount;
269         uint modulo = bet.modulo;
270         uint rollUnder = bet.rollUnder;
271         uint placeBlockNumber = bet.placeBlockNumber;
272         address gambler = bet.gambler;
273 
274         // Check that bet is in 'active' state.
275         require (amount != 0, "Bet should be in an 'active' state");
276 
277         // Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
278         require (block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
279         require (block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
280 
281         // Move bet into 'processed' state already.
282         bet.amount = 0;
283 
284         // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
285         // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
286         // preimage is intractable), and house is unable to alter the "reveal" after
287         // placeBet have been mined (as Keccak256 collision finding is also intractable).
288         bytes32 entropy = keccak256(abi.encodePacked(reveal, blockhash(placeBlockNumber)));
289 
290         // Do a roll by taking a modulo of entropy. Compute winning amount.
291         uint dice = uint(entropy) % modulo;
292         uint diceWinAmount = getDiceWinAmount(amount, modulo, rollUnder);
293 
294         uint diceWin = 0;
295         uint jackpotWin = 0;
296 
297         // Determine dice outcome.
298         if (modulo <= MAX_MASK_MODULO) {
299             // For small modulo games, check the outcome against a bit mask.
300             if ((2 ** dice) & bet.mask != 0) {
301                 diceWin = diceWinAmount;
302             }
303 
304         } else {
305             // For larger modulos, check inclusion into half-open interval.
306             if (dice < rollUnder) {
307                 diceWin = diceWinAmount;
308             }
309 
310         }
311 
312         // Unlock the bet amount, regardless of the outcome.
313         lockedInBets -= uint128(diceWinAmount);
314 
315         // Roll for a jackpot (if eligible).
316         if (amount >= MIN_JACKPOT_BET) {
317             // The second modulo, statistically independent from the "main" dice roll.
318             // Effectively you are playing two games at once!
319             uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;
320 
321             // Bingo!
322             if (jackpotRng == 0) {
323                 jackpotWin = jackpotSize;
324                 jackpotSize = 0;
325             }
326         }
327 
328         // Tally up the win.
329         uint totalWin = diceWin + jackpotWin;
330 
331         if (totalWin == 0) {
332             totalWin = 1 wei;
333         }
334 
335         // Log jackpot win.
336         if (jackpotWin > 0) {
337             emit JackpotPayment(gambler, jackpotWin);
338         }
339 
340         // Send the funds to gambler.
341         sendFunds(gambler, totalWin, diceWin);
342 
343         // Clear storage of some previous bet.
344         if (cleanCommit == 0) {
345             return;
346         }
347 
348         clearProcessedBet(cleanCommit);
349     }
350 
351     // Refund transaction - return the bet amount of a roll that was not processed in a
352     // due timeframe. Processing such blocks is not possible due to EVM limitations (see
353     // BET_EXPIRATION_BLOCKS comment above for details). In case you ever find yourself
354     // in a situation like this, just contact the dice2.win support, however nothing
355     // precludes you from invoking this method yourself.
356     function refundBet(uint commit) external {
357         // Check that bet is in 'active' state.
358         Bet storage bet = bets[commit];
359         uint amount = bet.amount;
360 
361         require (amount != 0, "Bet should be in an 'active' state");
362 
363         // Check that bet has already expired.
364         require (block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
365 
366         // Move bet into 'processed' state, release funds.
367         bet.amount = 0;
368         lockedInBets -= uint128(getDiceWinAmount(amount, bet.modulo, bet.rollUnder));
369 
370         // Send the refund.
371         sendFunds(bet.gambler, amount, amount);
372     }
373 
374     // A helper routine to bulk clean the storage.
375     function clearStorage(uint[] cleanCommits) external {
376         uint length = cleanCommits.length;
377 
378         for (uint i = 0; i < length; i++) {
379             clearProcessedBet(cleanCommits[i]);
380         }
381     }
382 
383     // Helper routine to move 'processed' bets into 'clean' state.
384     function clearProcessedBet(uint commit) private {
385         Bet storage bet = bets[commit];
386 
387         // Do not overwrite active bets with zeros; additionally prevent cleanup of bets
388         // for which commit signatures may have not expired yet (see whitepaper for details).
389         if (bet.amount != 0 || block.number <= bet.placeBlockNumber + BET_EXPIRATION_BLOCKS) {
390             return;
391         }
392 
393         // Zero out the remaining storage (amount was zeroed before, delete would consume 5k
394         // more gas).
395         bet.modulo = 0;
396         bet.rollUnder = 0;
397         bet.placeBlockNumber = 0;
398         bet.mask = 0;
399         bet.gambler = address(0);
400     }
401 
402     // Get the expected win amount after house edge is subtracted.
403     function getDiceWinAmount(uint amount, uint modulo, uint rollUnder) private pure returns (uint) {
404         require (0 < rollUnder && rollUnder <= modulo, "Win probability out of range.");
405 
406         uint houseEdge = amount * HOUSE_EDGE_PERCENT / 100;
407 
408         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
409             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
410         }
411 
412         require (houseEdge <= amount, "Bet doesn't even cover house edge.");
413         return (amount - houseEdge) * modulo / rollUnder;
414     }
415 
416     // Get the portion of bet amount that is to be accumulated in the jackpot.
417     function getJackpotFee(uint amount) private pure returns (uint) {
418         // Do not charge the fee from bets which don't claim jackpot.
419         return amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
420     }
421 
422     // Helper routine to process the payment.
423     function sendFunds(address beneficiary, uint amount, uint successLogAmount) private {
424         if (beneficiary.send(amount)) {
425             emit Payment(beneficiary, successLogAmount);
426         } else {
427             emit FailedPayment(beneficiary, amount);
428         }
429     }
430 
431     // This are some constants making O(1) population count in placeBet possible.
432     // See whitepaper for intuition and proofs behind it.
433     uint constant POPCNT_MULT = 0x0000000000002000000000100000000008000000000400000000020000000001;
434     uint constant POPCNT_MASK = 0x0001041041041041041041041041041041041041041041041041041041041041;
435     uint constant POPCNT_MODULO = 0x3F;
436 }