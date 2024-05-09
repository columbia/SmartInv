1 pragma solidity ^0.4.25;
2 
3 // * etherdice.io
4 //
5 // * Ethereum smart contract.
6 //
7 // * Uses hybrid commit-reveal + block hash random number generation that is immune
8 //   to tampering by players, house and miners. Apart from being fully transparent,
9 //   this also allows arbitrarily high bets.
10 //
11 contract EtherDice {
12 
13     using SafeMath for uint256;
14 
15     /// *** Constants section
16 
17     // Each bet is deducted 1% in favour of the house, but no less than some minimum.
18     // The lower bound is dictated by gas costs of the settleBet transaction, providing
19     // headroom for up to 10 Gwei prices.
20     uint constant HOUSE_EDGE_PERCENT = 1;
21 
22     // There is minimum and maximum bets.
23     uint constant MIN_BET = 0.01 ether;
24     uint constant MAX_AMOUNT = 300000 ether;
25 
26     // Modulo is a number of equiprobable outcomes in a game:
27     //  - 2 for coin flip
28     //  - 6 for dice
29     //  - 6*6 = 36 for double dice
30     //  - 100 for etheroll
31     //  - 37 for roulette
32     //  etc.
33     // It's called so because 256-bit entropy is treated like a huge integer and
34     // the remainder of its division by modulo is considered bet outcome.
35     uint constant MAX_MODULO = 100;
36 
37     // For modulos below this threshold rolls are checked against a bit mask,
38     // thus allowing betting on any combination of outcomes. For example, given
39     // modulo 6 for dice, 101000 mask (base-2, big endian) means betting on
40     // 4 and 6; for games with modulos higher than threshold (Etheroll), a simple
41     // limit is used, allowing betting on any outcome in [0, N) range.
42     //
43     // The specific value is dictated by the fact that 256-bit intermediate
44     // multiplication result allows implementing population count efficiently
45     // for numbers that are up to 42 bits, and 40 is the highest multiple of
46     // eight below 42.
47     uint constant MAX_MASK_MODULO = 40;
48 
49     // This is a check on bet mask overflow.
50     uint constant MAX_BET_MASK = 2 ** MAX_MASK_MODULO;
51 
52     // Some deliberately invalid address to initialize the secret signer with.
53     // Forces maintainers to invoke setSecretSigner before processing any bets.
54     address constant DUMMY_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
55 
56     // EVM BLOCKHASH opcode can query no further than 256 blocks into the
57     // past. Given that settleBet uses block hash of placeBet as one of
58     // complementary entropy sources, we cannot process bets older than this
59     // threshold. On rare occasions etherdice.io croupier may fail to invoke
60     // settleBet in this timespan due to technical issues or extreme Ethereum
61     // congestion; such bets can be refunded via invoking refundBet.
62     uint public betExpirationBlocks = 250;
63 
64     // Standard contract ownership transfer.
65     address public owner;
66     address private nextOwner;
67 
68     // Adjustable max bet profit. Used to cap bets against dynamic odds.
69     uint public maxProfit;
70 
71     // The address corresponding to a private key used to sign placeBet commits.
72     address public secretSigner;
73 
74     address public exchange = 0x89df456bb9ef0F7bf7718389b150d6161c9E0431;
75 
76     // Funds that are locked in potentially winning bets. Prevents contract from
77     // committing to bets it cannot pay out.
78     uint public lockedInBets;
79 
80     // A structure representing a single bet.
81     struct Bet {
82         // Wager amount in wei.
83         uint amount;
84         // Modulo of a game.
85         uint8 modulo;
86         // Number of winning outcomes, used to compute winning payment (* modulo/rollUnder),
87         // and used instead of mask for games with modulo > MAX_MASK_MODULO.
88         uint8 rollUnder;
89         // Block number of placeBet tx.
90         uint placeBlockNumber;
91         // Bit mask representing winning bet outcomes (see MAX_MASK_MODULO comment).
92         uint40 mask;
93         // Address of a gambler, used to pay out winning bets.
94         address gambler;
95     }
96 
97     // Mapping from commits to all currently active & processed bets.
98     mapping (uint => Bet) bets;
99 
100     // Croupier account.
101     address public croupier;
102 
103     // This event is emitted in settleBet for user results and stats
104     event SettleBet(uint commit, uint dice, uint amount, uint diceWin);
105 
106     // This event is emitted in refundBet
107     event Refund(uint commit, uint amount);
108 
109     // This event is emitted in placeBet to record commit in the logs.
110     event Commit(uint commit);
111 
112     // Constructor. Deliberately does not take any parameters.
113     constructor () public {
114         owner = msg.sender;
115         secretSigner = DUMMY_ADDRESS;
116         croupier = DUMMY_ADDRESS;
117     }
118 
119     // Standard modifier on methods invokable only by contract owner.
120     modifier onlyOwner {
121         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
122         _;
123     }
124 
125     // Standard modifier on methods invokable only by contract owner.
126     modifier onlyCroupier {
127         require (msg.sender == croupier, "OnlyCroupier methods called by non-croupier.");
128         _;
129     }
130 
131     // Standard contract ownership transfer implementation,
132     function approveNextOwner(address _nextOwner) external onlyOwner {
133         require (_nextOwner != owner, "Cannot approve current owner.");
134         nextOwner = _nextOwner;
135     }
136 
137     function acceptNextOwner() external {
138         require (msg.sender == nextOwner, "Can only accept preapproved new owner.");
139         owner = nextOwner;
140     }
141 
142     // Fallback function deliberately left empty. It's primary use case
143     // is to top up the bank roll.
144     function () public payable {
145     }
146 
147     // See comment for "secretSigner" variable.
148     function setSecretSigner(address newSecretSigner) external onlyOwner {
149         secretSigner = newSecretSigner;
150     }
151 
152     // Change the croupier address.
153     function setCroupier(address newCroupier) external onlyOwner {
154         croupier = newCroupier;
155     }
156 
157     // Change max bet reward. Setting this to zero effectively disables betting.
158     function setMaxProfit(uint _maxProfit) public onlyOwner {
159         require (_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
160         maxProfit = _maxProfit;
161     }
162 
163     // Change bet expiration blocks. For the future.
164     function setBetExpirationBlocks(uint _betExpirationBlocks) public onlyOwner {
165         require (_betExpirationBlocks > 0, "betExpirationBlocks should be a sane number.");
166         betExpirationBlocks = _betExpirationBlocks;
167     }
168 
169     // Funds withdrawal to reinvestment contract for token holders.
170     function withdrawFunds(uint withdrawAmount) external onlyOwner {
171         require (withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
172         require (lockedInBets.add(withdrawAmount) <= address(this).balance, "Not enough funds.");
173         exchange.transfer(withdrawAmount);
174     }
175 
176     function getBetInfoByReveal(uint reveal) external view returns (uint commit, uint amount, uint modulo, uint rollUnder, uint placeBlockNumber, uint mask, address gambler) {
177         commit = uint(keccak256(abi.encodePacked(reveal)));
178         (amount, modulo, rollUnder, placeBlockNumber, mask, gambler) = getBetInfo(commit);
179     }
180 
181     function getBetInfo(uint commit) public view returns (uint amount, uint modulo, uint rollUnder, uint placeBlockNumber, uint mask, address gambler) {
182         Bet storage bet = bets[commit];
183         amount = bet.amount;
184         modulo = bet.modulo;
185         rollUnder = bet.rollUnder;
186         placeBlockNumber = bet.placeBlockNumber;
187         mask = bet.mask;
188         gambler = bet.gambler;
189     }
190 
191     /// *** Betting logic
192 
193     // Bet states:
194     //  amount == 0 && gambler == 0 - 'clean' (can place a bet)
195     //  amount != 0 && gambler != 0 - 'active' (can be settled or refunded)
196     //  amount == 0 && gambler != 0 - 'processed' (can clean storage)
197     //
198     //  NOTE: Storage cleaning is not implemented in this contract version; it will be added
199     //        with the next upgrade to prevent polluting Ethereum state with expired bets.
200 
201     // Bet placing transaction - issued by the player.
202     //  betMask         - bet outcomes bit mask for modulo <= MAX_MASK_MODULO,
203     //                    [0, betMask) for larger modulos.
204     //  modulo          - game modulo.
205     //  commitLastBlock - number of the maximum block where "commit" is still considered valid.
206     //  commit          - Keccak256 hash of some secret "reveal" random number, to be supplied
207     //                    by the etherdice.io croupier bot in the settleBet transaction. Supplying
208     //                    "commit" ensures that "reveal" cannot be changed behind the scenes
209     //                    after placeBet have been mined.
210     //  recCode         - recommendation code. Record only the first recommendation relationship.
211     //  r, s            - components of ECDSA signature of (commitLastBlock, commit).
212     //
213     // Commit, being essentially random 256-bit number, is used as a unique bet identifier in
214     // the 'bets' mapping.
215     //
216     // Commits are signed with a block limit to ensure that they are used at most once - otherwise
217     // it would be possible for a miner to place a bet with a known commit/reveal pair and tamper
218     // with the blockhash. Croupier guarantees that commitLastBlock will always be not greater than
219     // placeBet block number plus betExpirationBlocks. See whitepaper for details.
220     function placeBet(uint betMask, uint modulo, uint commitLastBlock, uint commit, bytes32 r, bytes32 s, uint8 v) external payable {
221         // Check that the bet is in 'clean' state.
222         Bet storage bet = bets[commit];
223         require (bet.gambler == address(0), "Bet should be in a 'clean' state.");
224 
225         // Validate input data ranges.
226         require (modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
227         require (msg.value >= MIN_BET && msg.value <= MAX_AMOUNT, "Amount should be within range.");
228         require (betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
229 
230         // Check that commit is valid - it has not expired and its signature is valid.
231         require (block.number <= commitLastBlock && commitLastBlock <= block.number.add(betExpirationBlocks), "Commit has expired.");
232         require (secretSigner == ecrecover(keccak256(abi.encodePacked(uint40(commitLastBlock), commit)), v, r, s), "ECDSA signature is not valid.");
233 
234         uint rollUnder;
235         //uint mask;
236 
237         if (modulo <= MAX_MASK_MODULO) {
238             // Small modulo games specify bet outcomes via bit mask.
239             // rollUnder is a number of 1 bits in this mask (population count).
240             // This magic looking formula is an efficient way to compute population
241             // count on EVM for numbers below 2**40.
242             rollUnder = ((betMask.mul(POPCNT_MULT)) & POPCNT_MASK).mod(POPCNT_MODULO);
243             //mask = betMask;
244             bet.mask = uint40(betMask);
245         } else {
246             // Larger modulos specify the right edge of half-open interval of
247             // winning bet outcomes.
248             require (betMask > 0 && betMask <= modulo, "High modulo range, betMask larger than modulo.");
249             rollUnder = betMask;
250         }
251 
252         // Winning amount
253         uint possibleWinAmount;
254         possibleWinAmount = getDiceWinAmount(msg.value, modulo, rollUnder);
255 
256         // Enforce max profit limit.
257         require (possibleWinAmount <= msg.value.add(maxProfit), "maxProfit limit violation.");
258 
259         // Lock funds.
260         lockedInBets = lockedInBets.add(possibleWinAmount);
261 
262         // Check whether contract has enough funds to process this bet.
263         require (lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
264 
265         // Record commit in logs.
266         emit Commit(commit);
267 
268         // Store bet parameters on blockchain.
269         bet.amount = msg.value;
270         bet.modulo = uint8(modulo);
271         bet.rollUnder = uint8(rollUnder);
272         bet.placeBlockNumber = block.number;
273         //bet.mask = uint40(mask);
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
285 
286         // Check that bet has not expired yet (see comment to betExpirationBlocks).
287         require (block.number > bet.placeBlockNumber, "settleBet in the same block as placeBet, or before.");
288         require (block.number <= bet.placeBlockNumber.add(betExpirationBlocks), "Blockhash can't be queried by EVM.");
289         require (blockhash(bet.placeBlockNumber) == blockHash);
290 
291         // Settle bet using reveal and blockHash as entropy sources.
292         settleBetCommon(bet, reveal, commit, blockHash);
293     }
294 
295     // Common settlement code for settleBet & settleBetUncleMerkleProof.
296     function settleBetCommon(Bet storage bet, uint reveal, uint commit, bytes32 entropyBlockHash) private {
297         // Fetch bet parameters into local variables (to save gas).
298         uint amount = bet.amount;
299         uint modulo = bet.modulo;
300         uint rollUnder = bet.rollUnder;
301         address gambler = bet.gambler;
302 
303         // Check that bet is in 'active' state.
304         require (amount != 0, "Bet should be in an 'active' state");
305 
306         // Move bet into 'processed' state already.
307         bet.amount = 0;
308 
309         // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
310         // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
311         // preimage is intractable), and house is unable to alter the "reveal" after
312         // placeBet have been mined (as Keccak256 collision finding is also intractable).
313         bytes32 entropy = keccak256(abi.encodePacked(reveal, entropyBlockHash));
314 
315         // Do a roll by taking a modulo of entropy. Compute winning amount.
316         uint dice = uint(entropy).mod(modulo);
317 
318         uint diceWinAmount;
319         diceWinAmount = getDiceWinAmount(amount, modulo, rollUnder);
320 
321         uint diceWin = 0;
322 
323         // Determine dice outcome.
324         if (modulo <= MAX_MASK_MODULO) {
325             // For small modulo games, check the outcome against a bit mask.
326             if ((2 ** dice) & bet.mask != 0) {
327                 diceWin = diceWinAmount;
328             }
329 
330         } else {
331             // For larger modulos, check inclusion into half-open interval.
332             if (dice < rollUnder) {
333                 diceWin = diceWinAmount;
334             }
335 
336         }
337 
338         // Unlock the bet amount, regardless of the outcome.
339         lockedInBets = lockedInBets.sub(diceWinAmount);
340 
341         // Send the funds to gambler.
342         gambler.transfer(diceWin == 0 ? 1 wei : diceWin);
343 
344         // Send results to user.
345         emit SettleBet(commit, dice, amount, diceWin);
346 
347     }
348 
349     // Refund transaction - return the bet amount of a roll that was not processed in a
350     // due timeframe. Processing such blocks is not possible due to EVM limitations (see
351     // betExpirationBlocks comment above for details). In case you ever find yourself
352     // in a situation like this, just contact the etherdice.io support, however nothing
353     // precludes you from invoking this method yourself.
354     function refundBet(uint commit) external {
355         // Check that bet is in 'active' state.
356         Bet storage bet = bets[commit];
357         uint amount = bet.amount;
358 
359         require (amount != 0, "Bet should be in an 'active' state");
360 
361         // Check that bet has already expired.
362         require (block.number > bet.placeBlockNumber.add(betExpirationBlocks), "Blockhash can't be queried by EVM.");
363 
364         // Move bet into 'processed' state, release funds.
365         bet.amount = 0;
366 
367         uint diceWinAmount;
368         diceWinAmount = getDiceWinAmount(amount, bet.modulo, bet.rollUnder);
369 
370         lockedInBets = lockedInBets.sub(diceWinAmount);
371 
372         // Send the refund.
373         bet.gambler.transfer(amount);
374 
375         // Send results to user.
376         emit Refund(commit, amount);
377     }
378 
379     // Get the expected win amount after house edge is subtracted.
380     function getDiceWinAmount(uint amount, uint modulo, uint rollUnder) private pure returns (uint winAmount) {
381         require (0 < rollUnder && rollUnder <= modulo, "Win probability out of range.");
382 
383         uint houseEdge = amount.mul(HOUSE_EDGE_PERCENT).div(100);
384 
385         require (houseEdge <= amount, "Bet doesn't even cover house edge.");
386         winAmount = amount.sub(houseEdge).mul(modulo).div(rollUnder);
387     }
388 
389     // This are some constants making O(1) population count in placeBet possible.
390     // See whitepaper for intuition and proofs behind it.
391     uint constant POPCNT_MULT = 0x0000000000002000000000100000000008000000000400000000020000000001;
392     uint constant POPCNT_MASK = 0x0001041041041041041041041041041041041041041041041041041041041041;
393     uint constant POPCNT_MODULO = 0x3F;
394 
395 }
396 
397 /**
398  * @title SafeMath
399  * @dev Math operations with safety checks that revert on error
400  */
401 library SafeMath {
402 
403     /**
404     * @dev Multiplies two numbers, reverts on overflow.
405     */
406     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
407         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
408         // benefit is lost if 'b' is also tested.
409         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
410         if (a == 0) {
411             return 0;
412         }
413 
414         uint256 c = a * b;
415         require(c / a == b);
416 
417         return c;
418     }
419 
420     /**
421     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
422     */
423     function div(uint256 a, uint256 b) internal pure returns (uint256) {
424         require(b > 0); // Solidity only automatically asserts when dividing by 0
425         uint256 c = a / b;
426         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
427 
428         return c;
429     }
430 
431     /**
432     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
433     */
434     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
435         require(b <= a);
436         uint256 c = a - b;
437 
438         return c;
439     }
440 
441     /**
442     * @dev Adds two numbers, reverts on overflow.
443     */
444     function add(uint256 a, uint256 b) internal pure returns (uint256) {
445         uint256 c = a + b;
446         require(c >= a);
447 
448         return c;
449     }
450 
451     /**
452     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
453     * reverts when dividing by zero.
454     */
455     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
456         require(b != 0);
457         return a % b;
458     }
459 }