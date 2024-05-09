1 pragma solidity ^0.4.23;
2 
3 // * dice2.win - fair games that pay Ether.
4 // * Ethereum smart contract, deployed at 0xD1CEeee3ecFff60d9532C37c9d24f68cA0E96453
5 // * Uses hybrid commit-reveal + block hash random number generation that is immune
6 //   to tampering by players, house and miners. Apart from being fully transparent,
7 //   this also allows arbitrarily high bets.
8 // * Refer to https://dice2.win/whitepaper.pdf for detailed description and proofs.
9 
10 contract Dice2Win {
11     /// *** Constants section
12 
13     // Chance to win jackpot - currently 0.1%
14     uint constant JACKPOT_MODULO = 1000;
15 
16     // Each bet is deducted 2% amount - 1% is house edge, 1% goes to jackpot fund.
17     uint constant HOUSE_EDGE_PERCENT = 2;
18     uint constant JACKPOT_FEE_PERCENT = 50;
19 
20     // There is a minimum and maximum bets. Minimum is dictated by the gas usage
21     // of settlement transactions, and maximum is just some safe & sane number.
22     uint constant MIN_BET = 0.01 ether;
23     uint constant MAX_AMOUNT = 300000 ether;
24 
25     // Bets lower than this amount do not participate in jackpot rolls.
26     uint constant MIN_JACKPOT_BET = 0.1 ether;
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
57     // threshold. On rare occasions dice2.win croupier may fail to invoke
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
103     // Events that are issued to make statistic recovery easier.
104     event FailedPayment(address indexed _beneficiary, uint amount);
105     event Payment(address indexed _beneficiary, uint amount);
106     event JackpotPayment(address indexed _beneficiary, uint amount);
107 
108     // Constructor. Deliberately does not take any parameters.
109     constructor () public {
110         owner = msg.sender;
111         secretSigner = DUMMY_ADDRESS;
112     }
113 
114     // Standard modifier on methods invokable only by contract owner.
115     modifier onlyOwner {
116         require (msg.sender == owner);
117         _;
118     }
119 
120     // Standard contract ownership transfer implementation,
121     function approveNextOwner(address _nextOwner) external onlyOwner {
122         require (_nextOwner != owner);
123         nextOwner = _nextOwner;
124     }
125 
126     function acceptNextOwner() external {
127         require (msg.sender == nextOwner);
128         owner = nextOwner;
129     }
130 
131     // Fallback function deliberately left empty. It's primary use case
132     // is to top up the bank roll.
133     function () public payable {
134     }
135 
136     // See comment for "secretSigner" variable.
137     function setSecretSigner(address newSecretSigner) external onlyOwner {
138         secretSigner = newSecretSigner;
139     }
140 
141     // Change max bet reward. Setting this to zero effectively disables betting.
142     function setMaxProfit(uint newMaxProfit) public onlyOwner {
143         require (newMaxProfit < MAX_AMOUNT);
144         maxProfit = newMaxProfit;
145     }
146 
147     // This function is used to bump up the jackpot fund. Cannot be used to lower it.
148     function increaseJackpot(uint increaseAmount) external onlyOwner {
149         require (increaseAmount <= address(this).balance);
150         require (jackpotSize + lockedInBets + increaseAmount <= address(this).balance);
151         jackpotSize += uint128(increaseAmount);
152     }
153 
154     // Funds withdrawal to cover costs of dice2.win operation.
155     function withdrawFunds(address beneficiary, uint withdrawAmount) external onlyOwner {
156         require (withdrawAmount <= address(this).balance);
157         require (jackpotSize + lockedInBets + withdrawAmount <= address(this).balance);
158         sendFunds(beneficiary, withdrawAmount, withdrawAmount);
159     }
160 
161     // Contract may be destroyed only when there are no ongoing bets,
162     // either settled or refunded. All funds are transferred to contract owner.
163     function kill() external onlyOwner {
164         require (lockedInBets == 0);
165         selfdestruct(owner);
166     }
167 
168     /// *** Betting logic
169 
170     // Bet states:
171     //  amount == 0 && gambler == 0 - 'clean' (can place a bet)
172     //  amount != 0 && gambler != 0 - 'active' (can be settled or refunded)
173     //  amount == 0 && gambler != 0 - 'processed' (can clean storage)
174 
175     // Bet placing transaction - issued by the player.
176     //  betMask         - bet outcomes bit mask for modulo <= MAX_MASK_MODULO,
177     //                    [0, betMask) for larger modulos.
178     //  modulo          - game modulo.
179     //  commitLastBlock - number of the maximum block where "commit" is still considered valid.
180     //  commit          - Keccak256 hash of some secret "reveal" random number, to be supplied
181     //                    by the dice2.win croupier bot in the settleBet transaction. Supplying
182     //                    "commit" ensures that "reveal" cannot be changed behind the scenes
183     //                    after placeBet have been mined.
184     //  r, s            - components of ECDSA signature of (commitLastBlock, commit). v is
185     //                    guaranteed to always equal 27.
186     //
187     // Commit, being essentially random 256-bit number, is used as a unique bet identifier in
188     // the 'bets' mapping.
189     //
190     // Commits are signed with a block limit to ensure that they are used at most once - otherwise
191     // it would be possible for a miner to place a bet with a known commit/reveal pair and tamper
192     // with the blockhash. Croupier guarantees that commitLastBlock will always be not greater than
193     // placeBet block number plus BET_EXPIRATION_BLOCKS. See whitepaper for details.
194     function placeBet(uint betMask, uint modulo,
195                       uint commitLastBlock, uint commit, bytes32 r, bytes32 s) external payable {
196         // Check that the bet is in 'clean' state.
197         Bet storage bet = bets[commit];
198         require (bet.gambler == address(0));
199 
200         // Validate input data ranges.
201         uint amount = msg.value;
202         require (modulo > 1 && modulo <= MAX_MODULO);
203         require (amount >= MIN_BET && amount <= MAX_AMOUNT);
204         require (betMask > 0 && betMask < MAX_BET_MASK);
205 
206         // Check that commit is valid - it has not expired and its signature is valid.
207         require (block.number <= commitLastBlock);
208         bytes32 signatureHash = keccak256(abi.encodePacked(uint40(commitLastBlock), commit));
209         require (secretSigner == ecrecover(signatureHash, 27, r, s));
210 
211         uint rollUnder;
212         uint mask;
213 
214         if (modulo <= MAX_MASK_MODULO) {
215             // Small modulo games specify bet outcomes via bit mask.
216             // rollUnder is a number of 1 bits in this mask (population count).
217             // This magic looking formula is an efficient way to compute population
218             // count on EVM for numbers below 2**40. For detailed proof consult
219             // the dice2.win whitepaper.
220             rollUnder = ((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
221             mask = betMask;
222         } else {
223             // Larger modulos specify the right edge of half-open interval of
224             // winning bet outcomes.
225             require (betMask > 0 && betMask <= modulo);
226             rollUnder = betMask;
227         }
228 
229         // Winning amount and jackpot increase.
230         uint possibleWinAmount = getDiceWinAmount(amount, modulo, rollUnder);
231         uint jackpotFee = getJackpotFee(amount);
232 
233         // Enforce max profit limit.
234         require (possibleWinAmount <= amount + maxProfit);
235 
236         // Lock funds.
237         lockedInBets += uint128(possibleWinAmount);
238         jackpotSize += uint128(jackpotFee);
239 
240         // Check whether contract has enough funds to process this bet.
241         require (jackpotSize + lockedInBets <= address(this).balance);
242 
243         // Store bet parameters on blockchain.
244         bet.amount = amount;
245         bet.modulo = uint8(modulo);
246         bet.rollUnder = uint8(rollUnder);
247         bet.placeBlockNumber = uint40(block.number);
248         bet.mask = uint40(mask);
249         bet.gambler = msg.sender;
250     }
251 
252     // Settlement transaction - can in theory be issued by anyone, but is designed to be
253     // handled by the dice2.win croupier bot. To settle a bet with a specific "commit",
254     // settleBet should supply a "reveal" number that would Keccak256-hash to
255     // "commit". clean_commit is some previously 'processed' bet, that will be moved into
256     // 'clean' state to prevent blockchain bloat and refund some gas.
257     function settleBet(uint reveal, uint clean_commit) external {
258         // "commit" for bet settlement can only be obtained by hashing a "reveal".
259         uint commit = uint(keccak256(abi.encodePacked(reveal)));
260 
261         // Fetch bet parameters into local variables (to save gas).
262         Bet storage bet = bets[commit];
263         uint amount = bet.amount;
264         uint modulo = bet.modulo;
265         uint rollUnder = bet.rollUnder;
266         uint placeBlockNumber = bet.placeBlockNumber;
267         address gambler = bet.gambler;
268 
269         // Check that bet is in 'active' state.
270         require (amount != 0);
271 
272         // Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
273         require (block.number > placeBlockNumber);
274         require (block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS);
275 
276         // Move bet into 'processed' state already.
277         bet.amount = 0;
278 
279         // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
280         // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
281         // preimage is intractable), and house is unable to alter the "reveal" after
282         // placeBet have been mined (as Keccak256 collision finding is also intractable).
283         bytes32 entropy = keccak256(abi.encodePacked(reveal, blockhash(placeBlockNumber)));
284 
285         // Do a roll by taking a modulo of entropy. Compute winning amount.
286         uint dice = uint(entropy) % modulo;
287         uint diceWinAmount = getDiceWinAmount(amount, modulo, rollUnder);
288 
289         uint diceWin = 0;
290         uint jackpotWin = 0;
291 
292         // Determine dice outcome.
293         if (modulo <= MAX_MASK_MODULO) {
294             // For small modulo games, check the outcome against a bit mask.
295             if ((2 ** dice) & bet.mask != 0) {
296                 diceWin = diceWinAmount;
297             }
298 
299         } else {
300             // For larger modulos, check inclusion into half-open interval.
301             if (dice < rollUnder) {
302                 diceWin = diceWinAmount;
303             }
304 
305         }
306 
307         // Unlock the bet amount, regardless of the outcome.
308         lockedInBets -= uint128(diceWinAmount);
309 
310         // Roll for a jackpot (if eligible).
311         if (amount >= MIN_JACKPOT_BET) {
312             // The second modulo, statistically independent from the "main" dice roll.
313             // Effectively you are playing two games at once!
314             uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;
315 
316             // Bingo!
317             if (jackpotRng == 0) {
318                 jackpotWin = jackpotSize;
319                 jackpotSize = 0;
320             }
321         }
322 
323         // Tally up the win.
324         uint totalWin = diceWin + jackpotWin;
325 
326         if (totalWin == 0) {
327             totalWin = 1 wei;
328         }
329 
330         // Log jackpot win.
331         if (jackpotWin > 0) {
332             emit JackpotPayment(gambler, jackpotWin);
333         }
334 
335         // Send the funds to gambler.
336         sendFunds(gambler, totalWin, diceWin);
337 
338         // Clear storage of some previous bet.
339         if (clean_commit == 0) {
340             return;
341         }
342 
343         clearProcessedBet(clean_commit);
344     }
345 
346     // Refund transaction - return the bet amount of a roll that was not processed in a
347     // due timeframe. Processing such blocks is not possible due to EVM limitations (see
348     // BET_EXPIRATION_BLOCKS comment above for details). In case you ever find yourself
349     // in a situation like this, just contact the dice2.win support, however nothing
350     // precludes you from invoking this method yourself.
351     function refundBet(uint commit) external {
352         // Check that bet is in 'active' state.
353         Bet storage bet = bets[commit];
354         uint amount = bet.amount;
355 
356         require (amount != 0);
357 
358         // Check that bet has already expired.
359         require (block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS);
360 
361         // Move bet into 'processed' state, release funds.
362         bet.amount = 0;
363         lockedInBets -= uint128(getDiceWinAmount(amount, bet.modulo, bet.rollUnder));
364 
365         // Send the refund.
366         sendFunds(bet.gambler, amount, amount);
367     }
368 
369     // A helper routine to bulk clean the storage.
370     function clearStorage(uint[] clean_commits) external {
371         uint length = clean_commits.length;
372 
373         for (uint i = 0; i < length; i++) {
374             clearProcessedBet(clean_commits[i]);
375         }
376     }
377 
378     // Helper routine to move 'processed' bets into 'clean' state.
379     function clearProcessedBet(uint commit) private {
380         Bet storage bet = bets[commit];
381 
382         // Do not overwrite active bets with zeros; additionally prevent cleanup of bets
383         // for which commit signatures may have not expired yet (see whitepaper for details).
384         if (bet.amount != 0 || block.number <= bet.placeBlockNumber + BET_EXPIRATION_BLOCKS) {
385             return;
386         }
387 
388         // Zero out the remaining storage (amount was zeroed before, delete would consume 5k
389         // more gas).
390         bet.modulo = 0;
391         bet.rollUnder = 0;
392         bet.placeBlockNumber = 0;
393         bet.mask = 0;
394         bet.gambler = address(0);
395     }
396 
397     // Get the expected win amount after house edge is subtracted.
398     function getDiceWinAmount(uint amount, uint modulo, uint rollUnder) pure private returns (uint) {
399         require (0 < rollUnder && rollUnder <= modulo);
400         return amount * modulo / rollUnder * (100 - HOUSE_EDGE_PERCENT) / 100;
401     }
402 
403     // Get the portion of bet amount that is to be accumulated in the jackpot.
404     function getJackpotFee(uint amount) pure private returns (uint) {
405         return amount * HOUSE_EDGE_PERCENT / 100 * JACKPOT_FEE_PERCENT / 100;
406     }
407 
408     // Helper routine to process the payment.
409     function sendFunds(address beneficiary, uint amount, uint successLogAmount) private {
410         if (beneficiary.send(amount)) {
411             emit Payment(beneficiary, successLogAmount);
412         } else {
413             emit FailedPayment(beneficiary, amount);
414         }
415     }
416 
417     // This are some constants making O(1) population count in placeBet possible.
418     // See whitepaper for intuition and proofs behind it.
419     uint constant POPCNT_MULT = 1 + 2**41 + 2**(41*2) + 2**(41*3) + 2**(41*4) + 2**(41*5);
420     uint constant POPCNT_MASK = 1 + 2**(6*1) + 2**(6*2) + 2**(6*3) + 2**(6*4) + 2**(6*5)
421         + 2**(6*6) + 2**(6*7) + 2**(6*8) + 2**(6*9) + 2**(6*10) + 2**(6*11) + 2**(6*12)
422         + 2**(6*13) + 2**(6*14) + 2**(6*15) + 2**(6*16) + 2**(6*17) + 2**(6*18) + 2**(6*19)
423         + 2**(6*20) + 2**(6*21) + 2**(6*22) + 2**(6*23) + 2**(6*24) + 2**(6*25) + 2**(6*26)
424         + 2**(6*27) + 2**(6*28) + 2**(6*29) + 2**(6*30) + 2**(6*31) + 2**(6*32) + 2**(6*33)
425         + 2**(6*34) + 2**(6*35) + 2**(6*36) + 2**(6*37) + 2**(6*38) + 2**(6*39) + 2**(6*40);
426 
427     uint constant POPCNT_MODULO = 2**6 - 1;
428 
429 }