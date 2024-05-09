1 pragma solidity ^0.4.25;
2 
3 // * myethergames.fun
4 //   
5 // * Uses hybrid commit-reveal + block hash random number generation that is immune
6 //   to tampering by players, house and miners. Apart from being fully transparent,
7 //   this also allows arbitrarily high bets.
8 
9 contract FairCasino {
10     
11     /// *** Constants section
12 
13     // Each bet is deducted 1% in favour of the house, but no less than some minimum.
14     // The lower bound is dictated by gas costs of the settleBet transaction, providing
15     // headroom for up to 10 Gwei prices.
16     uint constant HOUSE_EDGE_PERCENT = 1;
17     uint constant HOUSE_EDGE_MINIMUM_AMOUNT = 0.0003 ether;
18 
19     // Bets lower than this amount do not participate in jackpot rolls (and are
20     // not deducted JACKPOT_FEE).
21     uint constant MIN_JACKPOT_BET = 0.1 ether;
22 
23     // Chance to win jackpot (currently 0.1%) and fee deducted into jackpot fund.
24     uint constant JACKPOT_MODULO = 1000;
25     uint constant JACKPOT_FEE = 0.001 ether;
26 
27     // There is minimum and maximum bets.
28     uint constant MIN_BET = 0.01 ether;
29     uint constant MAX_AMOUNT = 300000 ether;
30 
31     // Modulo is a number of equiprobable outcomes in a game:
32     //  - 2 for coin flip
33     //  - 6 for dice
34     //  - 6*6 = 36 for double dice
35     //  - 100 for etheroll
36     //  - 37 for roulette
37     //  etc.
38     // It's called so because 256-bit entropy is treated like a huge integer and
39     // the remainder of its division by modulo is considered bet outcome.
40     uint constant MAX_MODULO = 100;
41 
42     // For modulos below this threshold rolls are checked against a bit mask,
43     // thus allowing betting on any combination of outcomes. For example, given
44     // modulo 6 for dice, 101000 mask (base-2, big endian) means betting on
45     // 4 and 6; for games with modulos higher than threshold (Etheroll), a simple
46     // limit is used, allowing betting on any outcome in [0, N) range.
47     //
48     // The specific value is dictated by the fact that 256-bit intermediate
49     // multiplication result allows implementing population count efficiently
50     // for numbers that are up to 42 bits, and 40 is the highest multiple of
51     // eight below 42.
52     uint constant MAX_MASK_MODULO = 40;
53 
54     // This is a check on bet mask overflow.
55     uint constant MAX_BET_MASK = 2 ** MAX_MASK_MODULO;
56 
57     // EVM BLOCKHASH opcode can query no further than 256 blocks into the
58     // past. Given that settleBet uses block hash of placeBet as one of
59     // complementary entropy sources, we cannot process bets older than this
60     // threshold. On rare occasions myethergames.fun croupier may fail to invoke
61     // settleBet in this timespan due to technical issues or extreme Ethereum
62     // congestion; such bets can be refunded via invoking refundBet.
63     uint constant BET_EXPIRATION_BLOCKS = 250;
64 
65     // Some deliberately invalid address to initialize the secret signer with.
66     // Forces maintainers to invoke setSecretSigner before processing any bets.
67     
68     // Standard contract ownership transfer.
69     address public owner;
70     address private nextOwner;
71 
72     // Adjustable max bet profit. Used to cap bets against dynamic odds.
73     uint public maxProfit;
74 
75     // The address corresponding to a private key used to sign placeBet commits.
76     address public secretSigner;
77 
78     // Accumulated jackpot fund.
79     uint128 public jackpotSize;
80 
81     // Funds that are locked in potentially winning bets. Prevents contract from
82     // committing to bets it cannot pay out.
83     uint128 public lockedInBets;
84 
85     // A structure representing a single bet.
86     struct Bet {
87         // Wager amount in wei.
88         uint amount;
89         // Modulo of a game.
90         uint8 modulo;
91         // Number of winning outcomes, used to compute winning payment (* modulo/rollUnder),
92         // and used instead of mask for games with modulo > MAX_MASK_MODULO.
93         uint8 rollUnder;
94         // Block number of placeBet tx.
95         uint40 placeBlockNumber;
96         // Bit mask representing winning bet outcomes (see MAX_MASK_MODULO comment).
97         uint40 mask;
98         // Address of a gambler, used to pay out winning bets.
99         address gambler;
100     }
101 
102     // Mapping from commits to all currently active & processed bets.
103     mapping (uint => Bet) bets;
104 
105     // Croupier account.
106     address public croupier;
107 
108     // Events that are issued to make statistic recovery easier.
109     event FailedPayment(address indexed beneficiary, uint amount);
110     event Payment(address indexed beneficiary, uint amount);
111     event JackpotPayment(address indexed beneficiary, uint amount);
112 
113     // This event is emitted in placeBet to record commit in the logs.
114     event Commit(uint commit);
115 
116     // Constructor. Deliberately does not take any parameters.
117     constructor () public {
118         owner = msg.sender;
119         secretSigner = 0x77777A7AD41f5f0578D96c0DEe0afD2816376229;
120         croupier = 0xfC5998aE24dD8ECCaD7Acbf1427002b94f3830fc;
121     }
122 
123     // Standard modifier on methods invokable only by contract owner.
124     modifier onlyOwner {
125         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
126         _;
127     }
128 
129     // Standard modifier on methods invokable only by contract owner.
130     modifier onlyCroupier {
131         require (msg.sender == croupier, "OnlyCroupier methods called by non-croupier.");
132         _;
133     }
134 
135     // Standard contract ownership transfer implementation,
136     function approveNextOwner(address _nextOwner) external onlyOwner {
137         require (_nextOwner != owner, "Cannot approve current owner.");
138         nextOwner = _nextOwner;
139     }
140 
141     function acceptNextOwner() external {
142         require (msg.sender == nextOwner, "Can only accept preapproved new owner.");
143         owner = nextOwner;
144     }
145 
146     // Fallback function deliberately left empty. It's primary use case
147     // is to top up the bank roll.
148     function () public payable {
149     }
150 
151     // See comment for "secretSigner" variable.
152     function setSecretSigner(address newSecretSigner) external onlyOwner {
153         secretSigner = newSecretSigner;
154     }
155 
156     // Change the croupier address.
157     function setCroupier(address newCroupier) external onlyOwner {
158         croupier = newCroupier;
159     }
160 
161     // Change max bet reward. Setting this to zero effectively disables betting.
162     function setMaxProfit(uint _maxProfit) public onlyOwner {
163         require (_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
164         maxProfit = _maxProfit;
165     }
166 
167     // This function is used to bump up the jackpot fund. Cannot be used to lower it.
168     function increaseJackpot(uint increaseAmount) external onlyOwner {
169         require (increaseAmount <= address(this).balance, "Increase amount larger than balance.");
170         require (jackpotSize + lockedInBets + increaseAmount <= address(this).balance, "Not enough funds.");
171         jackpotSize += uint128(increaseAmount);
172     }
173 
174     // Funds withdrawal to cover costs of myethergames.fun operation.
175     function withdrawFunds(address beneficiary, uint withdrawAmount) external onlyOwner {
176         require (withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
177         require (jackpotSize + lockedInBets + withdrawAmount <= address(this).balance, "Not enough funds.");
178         sendFunds(beneficiary, withdrawAmount, withdrawAmount);
179     }
180 
181     // Contract may be destroyed only when there are no ongoing bets,
182     // either settled or refunded. All funds are transferred to contract owner.
183     function kill() external onlyOwner {
184         require (lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
185         selfdestruct(owner);
186     }
187 
188     /// *** Betting logic
189 
190     // Bet states:
191     //  amount == 0 && gambler == 0 - 'clean' (can place a bet)
192     //  amount != 0 && gambler != 0 - 'active' (can be settled or refunded)
193     //  amount == 0 && gambler != 0 - 'processed' (can clean storage)
194     //
195     //  NOTE: Storage cleaning is not implemented in this contract version; it will be added
196     //        with the next upgrade to prevent polluting Ethereum state with expired bets.
197 
198     // Bet placing transaction - issued by the player.
199     //  betMask         - bet outcomes bit mask for modulo <= MAX_MASK_MODULO,
200     //                    [0, betMask) for larger modulos.
201     //  modulo          - game modulo.
202     //  commitLastBlock - number of the maximum block where "commit" is still considered valid.
203     //  commit          - Keccak256 hash of some secret "reveal" random number, to be supplied
204     //                    by the myethergames.fun croupier bot in the settleBet transaction. Supplying
205     //                    "commit" ensures that "reveal" cannot be changed behind the scenes
206     //                    after placeBet have been mined.
207     // r, s             - components of ECDSA signature of (commitLastBlock, commit). v is
208     //                    equal 27 or 28.
209     //
210     // Commit, being essentially random 256-bit number, is used as a unique bet identifier in
211     // the 'bets' mapping.
212     //
213     // Commits are signed with a block limit to ensure that they are used at most once - otherwise
214     // it would be possible for a miner to place a bet with a known commit/reveal pair and tamper
215     // with the blockhash. Croupier guarantees that commitLastBlock will always be not greater than
216     // placeBet block number plus BET_EXPIRATION_BLOCKS. See whitepaper for details.
217     function placeBet(uint betMask, uint modulo, uint commitLastBlock, uint commit, bytes32 r, bytes32 s, uint8 v) external payable {
218         // Check that the bet is in 'clean' state.
219         Bet storage bet = bets[commit];
220         require (bet.gambler == address(0), "Bet should be in a 'clean' state.");
221 
222         // Validate input data ranges.
223         uint amount = msg.value;
224         require (modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
225         require (amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
226         require (betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
227         
228         // Check that commit is valid - it has not expired and its signature is valid.
229         require(v >= 27 && v <=28);
230         require (block.number <= commitLastBlock, "Commit has expired.");
231         require (secretSigner == 
232             ecrecover(keccak256(abi.encodePacked(uint40(commitLastBlock), commit)), v, r, s), "ECDSA signature is not valid.");
233 
234         uint rollUnder;
235         uint mask;
236 
237         if (modulo <= MAX_MASK_MODULO) {
238             // Small modulo games specify bet outcomes via bit mask.
239             // rollUnder is a number of 1 bits in this mask (population count).
240             // This magic looking formula is an efficient way to compute population
241             // count on EVM for numbers below 2**40. For detailed proof consult
242             // the myethergames.fun whitepaper.
243             rollUnder = ((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
244             mask = betMask;
245         } else {
246             // Larger modulos specify the right edge of half-open interval of
247             // winning bet outcomes.
248             require (betMask > 0 && betMask <= modulo, "High modulo range, betMask larger than modulo.");
249             rollUnder = betMask;
250         }
251 
252         // Winning amount and jackpot increase.
253         uint possibleWinAmount;
254         uint jackpotFee;
255 
256         (possibleWinAmount, jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
257 
258         // Enforce max profit limit.
259         require (possibleWinAmount <= amount + maxProfit, "maxProfit limit violation.");
260 
261         // Lock funds.
262         lockedInBets += uint128(possibleWinAmount);
263         jackpotSize += uint128(jackpotFee);
264 
265         // Check whether contract has enough funds to process this bet.
266         require (jackpotSize + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
267 
268         // Record commit in logs.
269         emit Commit(commit);
270 
271         // Store bet parameters on blockchain.
272         bet.amount = amount;
273         bet.modulo = uint8(modulo);
274         bet.rollUnder = uint8(rollUnder);
275         bet.placeBlockNumber = uint40(block.number);
276         bet.mask = uint40(mask);
277         bet.gambler = msg.sender;
278     }
279 
280     // This is the method used to settle 99% of bets. To process a bet with a specific
281     // "commit", settleBet should supply a "reveal" number that would Keccak256-hash to
282     // "commit". "blockHash" is the block hash of placeBet block as seen by croupier; it
283     // is additionally asserted to prevent changing the bet outcomes on Ethereum reorgs.
284     function settleBet(uint reveal, bytes32 blockHash) external onlyCroupier {
285         uint commit = uint(keccak256(abi.encodePacked(reveal)));
286 
287         Bet storage bet = bets[commit];
288         uint placeBlockNumber = bet.placeBlockNumber;
289 
290         // Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
291         require (block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
292         require (block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
293         require (blockhash(placeBlockNumber) == blockHash);
294 
295         // Settle bet using reveal and blockHash as entropy sources.
296         settleBetCommon(bet, reveal, blockHash);
297     }
298 
299     // Common settlement code for settleBet & settleBetUncleMerkleProof.
300     function settleBetCommon(Bet storage bet, uint reveal, bytes32 entropyBlockHash) private {
301         // Fetch bet parameters into local variables (to save gas).
302         uint amount = bet.amount;
303         uint modulo = bet.modulo;
304         uint rollUnder = bet.rollUnder;
305         address gambler = bet.gambler;
306 
307         // Check that bet is in 'active' state.
308         require (amount != 0, "Bet should be in an 'active' state");
309 
310         // Move bet into 'processed' state already.
311         bet.amount = 0;
312 
313         // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
314         // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
315         // preimage is intractable), and house is unable to alter the "reveal" after
316         // placeBet have been mined (as Keccak256 collision finding is also intractable).
317         bytes32 entropy = keccak256(abi.encodePacked(reveal, entropyBlockHash));
318 
319         // Do a roll by taking a modulo of entropy. Compute winning amount.
320         uint dice = uint(entropy) % modulo;
321 
322         uint diceWinAmount;
323         uint _jackpotFee;
324         (diceWinAmount, _jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
325 
326         uint diceWin = 0;
327         uint jackpotWin = 0;
328 
329         // Determine dice outcome.
330         if (modulo <= MAX_MASK_MODULO) {
331             // For small modulo games, check the outcome against a bit mask.
332             if ((2 ** dice) & bet.mask != 0) {
333                 diceWin = diceWinAmount;
334             }
335 
336         } else {
337             // For larger modulos, check inclusion into half-open interval.
338             if (dice < rollUnder) {
339                 diceWin = diceWinAmount;
340             }
341 
342         }
343 
344         // Unlock the bet amount, regardless of the outcome.
345         lockedInBets -= uint128(diceWinAmount);
346 
347         // Roll for a jackpot (if eligible).
348         if (amount >= MIN_JACKPOT_BET) {
349             // The second modulo, statistically independent from the "main" dice roll.
350             // Effectively you are playing two games at once!
351             uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;
352 
353             // Bingo!
354             if (jackpotRng == 0) {
355                 jackpotWin = jackpotSize;
356                 jackpotSize = 0;
357             }
358         }
359 
360         // Log jackpot win.
361         if (jackpotWin > 0) {
362             emit JackpotPayment(gambler, jackpotWin);
363         }
364 
365         // Send the funds to gambler.
366         sendFunds(gambler, diceWin + jackpotWin == 0 ? 1 wei : diceWin + jackpotWin, diceWin);
367     }
368 
369     // Refund transaction - return the bet amount of a roll that was not processed in a
370     // due timeframe. Processing such blocks is not possible due to EVM limitations (see
371     // BET_EXPIRATION_BLOCKS comment above for details). In case you ever find yourself
372     // in a situation like this, just contact the myethergames.fun support, however nothing
373     // precludes you from invoking this method yourself.
374     function refundBet(uint commit) external {
375         // Check that bet is in 'active' state.
376         Bet storage bet = bets[commit];
377         uint amount = bet.amount;
378 
379         require (amount != 0, "Bet should be in an 'active' state");
380 
381         // Check that bet has already expired.
382         require (block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
383 
384         // Move bet into 'processed' state, release funds.
385         bet.amount = 0;
386 
387         uint diceWinAmount;
388         uint jackpotFee;
389         (diceWinAmount, jackpotFee) = getDiceWinAmount(amount, bet.modulo, bet.rollUnder);
390 
391         lockedInBets -= uint128(diceWinAmount);
392         jackpotSize -= uint128(jackpotFee);
393 
394         // Send the refund.
395         sendFunds(bet.gambler, amount, amount);
396     }
397 
398     // Get the expected win amount after house edge is subtracted.
399     function getDiceWinAmount(uint amount, uint modulo, uint rollUnder) private pure returns (uint winAmount, uint jackpotFee) {
400         require (0 < rollUnder && rollUnder <= modulo, "Win probability out of range.");
401 
402         jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
403 
404         uint houseEdge = amount * HOUSE_EDGE_PERCENT / 100;
405 
406         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
407             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
408         }
409 
410         require (houseEdge + jackpotFee <= amount, "Bet doesn't even cover house edge.");
411         winAmount = (amount - houseEdge - jackpotFee) * modulo / rollUnder;
412     }
413 
414     // Helper routine to process the payment.
415     function sendFunds(address beneficiary, uint amount, uint successLogAmount) private {
416         if (beneficiary.send(amount)) {
417             emit Payment(beneficiary, successLogAmount);
418         } else {
419             emit FailedPayment(beneficiary, amount);
420         }
421     }
422 
423     // This are some constants making O(1) population count in placeBet possible.
424     // See whitepaper for intuition and proofs behind it.
425     uint constant POPCNT_MULT = 0x0000000000002000000000100000000008000000000400000000020000000001;
426     uint constant POPCNT_MASK = 0x0001041041041041041041041041041041041041041041041041041041041041;
427     uint constant POPCNT_MODULO = 0x3F;
428 }