1 pragma solidity ^0.4.23;
2 
3 contract Dice2Win {
4 
5     /// Constants
6 
7     // Chance to win jackpot - currently 0.1%
8     uint256 constant JACKPOT_MODULO = 1000;
9 
10     // Each bet is deducted 2% amount - 1% is house edge, 1% goes to jackpot fund.
11     uint256 constant HOUSE_EDGE_PERCENT = 2;
12     uint256 constant JACKPOT_FEE_PERCENT = 50;
13 
14     // Minimum supported bet is 0.02 ETH, made possible by optimizing gas costs
15     // compared to our competitors.
16     uint256 constant MIN_BET = 0.02 ether;
17 
18     // Only bets higher that 0.1 ETH have a chance to win jackpot.
19     uint256 constant MIN_JACKPOT_BET = 0.1 ether;
20 
21     // Random number generation is provided by the hashes of future blocks.
22     // Two blocks is a good compromise between responsive gameplay and safety from miner attacks.
23     uint256 constant BLOCK_DELAY = 2;
24 
25     // Bets made more than 100 blocks ago are considered failed - this has to do
26     // with EVM limitations on block hashes that are queryable. Settlement failure
27     // is most probably due to croupier bot failure, if you ever end in this situation
28     // ask dice2.win support for a refund!
29     uint256 constant BET_EXPIRATION_BLOCKS = 100;
30 
31     /// Contract storage.
32 
33     // Changing ownership of the contract safely
34     address public owner;
35     address public nextOwner;
36 
37     // Max bet limits for coin toss/single dice and double dice respectively.
38     // Setting these values to zero effectively disables the respective games.
39     uint256 public maxBetCoinDice;
40     uint256 public maxBetDoubleDice;
41 
42     // Current jackpot size.
43     uint128 public jackpotSize;
44 
45     // Amount locked in ongoing bets - this is to be sure that we do not commit to bets
46     // that we cannot fulfill in case of win.
47     uint128 public lockedInBets;
48 
49     /// Enum representing games
50 
51     enum GameId {
52         CoinFlip,
53         SingleDice,
54         DoubleDice,
55 
56         MaxGameId
57     }
58 
59     uint256 constant MAX_BLOCK_NUMBER = 2 ** 56;
60     uint256 constant MAX_BET_MASK = 2 ** 64;
61     uint256 constant MAX_AMOUNT = 2 ** 128;
62 
63     // Struct is tightly packed into a single 256-bit by Solidity compiler.
64     // This is made to reduce gas costs of placing & settlement transactions.
65     struct ActiveBet {
66         // A game that was played.
67         GameId gameId;
68         // Block number in which bet transaction was mined.
69         uint56 placeBlockNumber;
70         // A binary mask with 1 for each option.
71         // For example, if you play dice, the mask ranges from 000001 in binary (betting on one)
72         // to 111111 in binary (betting on all dice outcomes at once).
73         uint64 mask;
74         // Bet amount in wei.
75         uint128 amount;
76     }
77 
78     mapping (address => ActiveBet) activeBets;
79 
80     // Events that are issued to make statistic recovery easier.
81     event FailedPayment(address indexed _beneficiary, uint256 amount);
82     event Payment(address indexed _beneficiary, uint256 amount);
83     event JackpotPayment(address indexed _beneficiary, uint256 amount);
84 
85     /// Contract governance.
86 
87     constructor () public {
88         owner = msg.sender;
89         // all fields are automatically initialized to zero, which is just what's needed.
90     }
91 
92     modifier onlyOwner {
93         require (msg.sender == owner);
94         _;
95     }
96 
97     // This is pretty standard ownership change routine.
98 
99     function approveNextOwner(address _nextOwner) public onlyOwner {
100         require (_nextOwner != owner);
101         nextOwner = _nextOwner;
102     }
103 
104     function acceptNextOwner() public {
105         require (msg.sender == nextOwner);
106         owner = nextOwner;
107     }
108 
109     // Contract may be destroyed only when there are no ongoing bets,
110     // either settled or refunded. All funds are transferred to contract owner.
111 
112     function kill() public onlyOwner {
113         require (lockedInBets == 0);
114         selfdestruct(owner);
115     }
116 
117     // Fallback function deliberately left empty. It's primary use case
118     // is to top up the bank roll.
119     function () public payable {
120     }
121 
122     // Helper routines to alter the respective max bet limits.
123     function changeMaxBetCoinDice(uint256 newMaxBetCoinDice) public onlyOwner {
124         maxBetCoinDice = newMaxBetCoinDice;
125     }
126 
127     function changeMaxBetDoubleDice(uint256 newMaxBetDoubleDice) public onlyOwner {
128         maxBetDoubleDice = newMaxBetDoubleDice;
129     }
130 
131     // Ability to top up jackpot faster than it's natural growth by house fees.
132     function increaseJackpot(uint256 increaseAmount) public onlyOwner {
133         require (increaseAmount <= address(this).balance);
134         require (jackpotSize + lockedInBets + increaseAmount <= address(this).balance);
135         jackpotSize += uint128(increaseAmount);
136     }
137 
138     // Funds withdrawal to cover costs of dice2.win operation.
139     function withdrawFunds(address beneficiary, uint256 withdrawAmount) public onlyOwner {
140         require (withdrawAmount <= address(this).balance);
141         require (jackpotSize + lockedInBets + withdrawAmount <= address(this).balance);
142         sendFunds(beneficiary, withdrawAmount, withdrawAmount);
143     }
144 
145     /// Betting logic
146 
147     // Bet transaction - issued by player. Contains the desired game id and betting options
148     // mask. Wager is the value in ether attached to the transaction.
149     function placeBet(GameId gameId, uint256 betMask) public payable {
150         // Check that there is no ongoing bet already - we support one game at a time
151         // from single address.
152         ActiveBet storage bet = activeBets[msg.sender];
153         require (bet.amount == 0);
154 
155         // Check that the values passed fit into respective limits.
156         require (gameId < GameId.MaxGameId);
157         require (msg.value >= MIN_BET && msg.value <= getMaxBet(gameId));
158         require (betMask < MAX_BET_MASK);
159 
160         // Determine roll parameters.
161         uint256 rollModulo = getRollModulo(gameId);
162         uint256 rollUnder = getRollUnder(rollModulo, betMask);
163 
164         // Check whether contract has enough funds to process this bet.
165         uint256 reservedAmount = getDiceWinAmount(msg.value, rollModulo, rollUnder);
166         uint256 jackpotFee = getJackpotFee(msg.value);
167         require (jackpotSize + lockedInBets + reservedAmount + jackpotFee <= address(this).balance);
168 
169         // Update reserved amounts.
170         lockedInBets += uint128(reservedAmount);
171         jackpotSize += uint128(jackpotFee);
172 
173         // Store the bet parameters on blockchain.
174         bet.gameId = gameId;
175         bet.placeBlockNumber = uint56(block.number);
176         bet.mask = uint64(betMask);
177         bet.amount = uint128(msg.value);
178     }
179 
180     // Settlement transaction - can be issued by anyone, but is designed to be handled by the
181     // dice2.win croupier bot. However nothing prevents you from issuing it yourself, or anyone
182     // issuing the settlement transaction on your behalf - that does not affect the bet outcome and
183     // is in fact encouraged in the case the croupier bot malfunctions.
184     function settleBet(address gambler) public {
185         // Check that there is already a bet for this gambler.
186         ActiveBet storage bet = activeBets[gambler];
187         require (bet.amount != 0);
188 
189         // Check that the bet is neither too early nor too late.
190         require (block.number > bet.placeBlockNumber + BLOCK_DELAY);
191         require (block.number <= bet.placeBlockNumber + BET_EXPIRATION_BLOCKS);
192 
193         // The RNG - use hash of the block that is unknown at the time of placing the bet,
194         // SHA3 it with gambler address. The latter step is required to make the outcomes of
195         // different settlement transactions mined into the same block different.
196         bytes32 entropy = keccak256(gambler, blockhash(bet.placeBlockNumber + BLOCK_DELAY));
197 
198         uint256 diceWin = 0;
199         uint256 jackpotWin = 0;
200 
201         // Determine roll parameters, do a roll by taking a modulo of entropy.
202         uint256 rollModulo = getRollModulo(bet.gameId);
203         uint256 dice = uint256(entropy) % rollModulo;
204 
205         uint256 rollUnder = getRollUnder(rollModulo, bet.mask);
206         uint256 diceWinAmount = getDiceWinAmount(bet.amount, rollModulo, rollUnder);
207 
208         // Check the roll result against the bet bit mask.
209         if ((2 ** dice) & bet.mask != 0) {
210             diceWin = diceWinAmount;
211         }
212 
213         // Unlock the bet amount, regardless of the outcome.
214         lockedInBets -= uint128(diceWinAmount);
215 
216         // Roll for a jackpot (if eligible).
217         if (bet.amount >= MIN_JACKPOT_BET) {
218             // The second modulo, statistically independent from the "main" dice roll.
219             // Effectively you are playing two games at once!
220             uint256 jackpotRng = (uint256(entropy) / rollModulo) % JACKPOT_MODULO;
221 
222             // Bingo!
223             if (jackpotRng == 0) {
224                 jackpotWin = jackpotSize;
225                 jackpotSize = 0;
226             }
227         }
228 
229         // Remove the processed bet from blockchain storage.
230         delete activeBets[gambler];
231 
232         // Tally up the win.
233         uint256 totalWin = diceWin + jackpotWin;
234 
235         if (totalWin == 0) {
236             totalWin = 1 wei;
237         }
238 
239         if (jackpotWin > 0) {
240             emit JackpotPayment(gambler, jackpotWin);
241         }
242 
243         // Send the funds to gambler.
244         sendFunds(gambler, totalWin, diceWin);
245     }
246 
247     // Refund transaction - return the bet amount of a roll that was not processed
248     // in due timeframe (100 Ethereum blocks). Processing such bets is not possible,
249     // because EVM does not have access to the hashes further than 256 blocks ago.
250     //
251     // Like settlement, this transaction may be issued by anyone, but if you ever
252     // find yourself in situation like this, just contact the dice2.win support!
253     function refundBet(address gambler) public {
254         // Check that there is already a bet for this gambler.
255         ActiveBet storage bet = activeBets[gambler];
256         require (bet.amount != 0);
257 
258         // The bet should be indeed late.
259         require (block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS);
260 
261         // Determine roll parameters to calculate correct amount of funds locked.
262         uint256 rollModulo = getRollModulo(bet.gameId);
263         uint256 rollUnder = getRollUnder(rollModulo, bet.mask);
264 
265         lockedInBets -= uint128(getDiceWinAmount(bet.amount, rollModulo, rollUnder));
266 
267         // Delete the bet from the blockchain.
268         uint256 refundAmount = bet.amount;
269         delete activeBets[gambler];
270 
271         // Refund the bet.
272         sendFunds(gambler, refundAmount, refundAmount);
273     }
274 
275     /// Helper routines.
276 
277     // Number of bet options for specific game.
278     function getRollModulo(GameId gameId) pure private returns (uint256) {
279         if (gameId == GameId.CoinFlip) {
280             // Heads/tails
281             return 2;
282 
283         } else if (gameId == GameId.SingleDice) {
284             // One through six.
285             return 6;
286 
287         } else if (gameId == GameId.DoubleDice) {
288             // 6*6=36 possible outcomes.
289             return 36;
290 
291         }
292     }
293 
294     // Max bet amount for a specific game.
295     function getMaxBet(GameId gameId) view private returns (uint256) {
296         if (gameId == GameId.CoinFlip) {
297             return maxBetCoinDice;
298 
299         } else if (gameId == GameId.SingleDice) {
300             return maxBetCoinDice;
301 
302         } else if (gameId == GameId.DoubleDice) {
303             return maxBetDoubleDice;
304 
305         }
306     }
307 
308     // Count 1 bits in the bet bit mask to find the total number of bet options
309     function getRollUnder(uint256 rollModulo, uint256 betMask) pure private returns (uint256) {
310         uint256 rollUnder = 0;
311         uint256 singleBitMask = 1;
312         for (uint256 shift = 0; shift < rollModulo; shift++) {
313             if (betMask & singleBitMask != 0) {
314                 rollUnder++;
315             }
316 
317             singleBitMask *= 2;
318         }
319 
320         return rollUnder;
321     }
322 
323     // Get the expected win amount after house edge is subtracted.
324     function getDiceWinAmount(uint256 amount, uint256 rollModulo, uint256 rollUnder) pure private
325       returns (uint256) {
326         require (0 < rollUnder && rollUnder <= rollModulo);
327         return amount * rollModulo / rollUnder * (100 - HOUSE_EDGE_PERCENT) / 100;
328     }
329 
330     // Get the portion of bet amount that is to be accumulated in the jackpot.
331     function getJackpotFee(uint256 amount) pure private returns (uint256) {
332         return amount * HOUSE_EDGE_PERCENT / 100 * JACKPOT_FEE_PERCENT / 100;
333     }
334 
335     // Helper routine to process the payment.
336     function sendFunds(address beneficiary, uint256 amount, uint256 successLogAmount) private {
337         if (beneficiary.send(amount)) {
338             emit Payment(beneficiary, successLogAmount);
339         } else {
340             emit FailedPayment(beneficiary, amount);
341         }
342     }
343 
344 }