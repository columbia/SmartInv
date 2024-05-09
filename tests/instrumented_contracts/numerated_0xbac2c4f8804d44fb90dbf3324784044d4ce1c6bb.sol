1 pragma solidity <= 0.6;
2 
3 contract Game365MetaDiff {
4 
5     /*
6         set constants
7     */
8     uint constant HOUSE_EDGE_PERCENT = 1;
9     uint constant HOUSE_EDGE_MINIMUM_AMOUNT = 0.0003 ether; 
10 
11     // Chance to win jackpot (currently 0.1%) and fee deducted into jackpot fund.
12     uint public constant MIN_JACKPOT_BET = 0.1 ether;
13     uint public constant JACKPOT_MODULO = 1000; 
14     uint constant JACKPOT_FEE = 0.001 ether; 
15     // There is minimum and maximum bets.
16     uint public constant MIN_BET = 0.01 ether;
17     uint constant MAX_AMOUNT = 300000 ether; 
18     
19     // Modulo is a number of equiprobable outcomes in a game:
20     //  - 2 for coin flip
21     //  - 6 for dice
22     //  - 6*6 = 36 for double dice
23     //  - 100 for etheroll
24     //  etc.
25     // It's called so because 256-bit entropy is treated like a huge integer and
26     // the remainder of its division by modulo is considered bet outcome.
27     uint constant MAX_MODULO = 100;
28     uint constant MAX_MASK_MODULO = 40;
29 
30     // This is a check on bet mask overflow.
31     uint constant MAX_BET_MASK = 2 ** MAX_MASK_MODULO;
32 
33     // EVM BLOCKHASH opcode can query no further than 256 blocks into the
34     // past. Given that settleBet uses block hash of placeBet as one of
35     // complementary entropy sources, we cannot process bets older than this
36     // threshold. On rare occasions our croupier may fail to invoke
37     // settleBet in this timespan due to technical issues or extreme Ethereum
38     // congestion; such bets can be refunded via invoking refundBet.
39     uint constant BET_EXPIRATION_BLOCKS = 250;
40 
41     // This are some constants making O(1) population count in placeBet possible.
42     // See whitepaper for intuition and proofs behind it.
43     uint constant POPCNT_MULT = 0x0000000000002000000000100000000008000000000400000000020000000001;
44     uint constant POPCNT_MASK = 0x0001041041041041041041041041041041041041041041041041041041041041;
45     uint constant POPCNT_MODULO = 0x3F; // decimal:63, binary:111111
46     
47     // Owner setting
48     address payable public owner = address(0x0);
49 
50     // Croupier account.
51     address public croupier = address(0x0);
52 
53     // The address corresponding to a private key used to sign placeBet commits.
54     address public secretSigner = address(0x0);
55 
56     // Adjustable max bet profit and start winning the jackpot. Used to cap bets against dynamic odds.
57     uint public maxProfit = 5 ether;
58     uint public minJackpotWinAmount = 0.1 ether;
59 
60     // Funds that are locked in potentially winning bets. Prevents contract from
61     // committing to bets it cannot pay out.
62     uint256 public lockedInBets_;
63     uint256 public lockedInJackpot_;
64     
65     struct Bet {
66         // Wager amount in wei.
67         uint128 amount;
68         // Block difficulty.
69         uint128 placeBlockDifficulty;
70         // Modulo of a game.
71         uint8 modulo;
72         // Number of winning outcomes, used to compute winning payment (* modulo/rollUnder),
73         // and used instead of mask for games with modulo > MAX_MASK_MODULO.
74         uint8 rollUnder;
75         // Block number of placeBet tx.
76         uint40 placeBlockNumber;
77         // Bit mask representing winning bet outcomes (see MAX_MASK_MODULO comment).
78         uint40 mask;
79         // Address of a gambler, used to pay out winning bets.
80         address payable gambler;
81     }
82     mapping(uint256 => Bet) bets;
83 
84     // Events that are issued to make statistic recovery easier.
85     event FailedPayment(uint256 indexed commit, address indexed beneficiary, uint amount, uint jackpotAmount);
86     event Payment(uint256 indexed commit, address indexed beneficiary, uint amount, uint jackpotAmount);
87     event JackpotPayment(address indexed beneficiary, uint amount);
88     event Commit(uint256 indexed commit, uint256 possibleWinAmount);
89     
90     /**
91         Constructor
92      */
93     constructor () 
94         public
95     {
96         owner = msg.sender;
97     }
98 
99     /**
100         Modifier
101     */
102     // Standard modifier on methods invokable only by contract owner.
103     modifier onlyOwner {
104         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
105         _;
106     }
107     
108     // Standard modifier on methods invokable only by contract owner.
109     modifier onlyCroupier {
110         require (msg.sender == croupier, "OnlyCroupier methods called by non-croupier.");
111         _;
112     }
113 
114     // See comment for "secretSigner" variable.
115     function setSecretSigner(address newSecretSigner) external onlyOwner {
116         secretSigner = newSecretSigner;
117     }
118 
119     // Change the croupier address.
120     function setCroupier(address newCroupier) external onlyOwner {
121         croupier = newCroupier;
122     }
123 
124     function setMaxProfit(uint _maxProfit) public onlyOwner {
125         require (_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
126         maxProfit = _maxProfit;
127     }
128 
129     function setMinJackPotWinAmount(uint _minJackpotAmount) public onlyOwner {
130         minJackpotWinAmount = _minJackpotAmount;
131     }
132 
133     // This function is used to bump up the jackpot fund. Cannot be used to lower it.
134     function increaseJackpot(uint increaseAmount) external onlyOwner {
135         require (increaseAmount <= address(this).balance, "Increase amount larger than balance.");
136         require (lockedInJackpot_ + lockedInBets_ + increaseAmount <= address(this).balance, "Not enough funds.");
137         lockedInJackpot_ += uint128(increaseAmount);
138     }
139 
140     // Funds withdrawal to cover costs of our operation.
141     function withdrawFunds(address payable beneficiary, uint withdrawAmount) external onlyOwner {
142         require (withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
143         require (lockedInJackpot_ + lockedInBets_ + withdrawAmount <= address(this).balance, "Not enough funds.");
144         sendFunds(1, beneficiary, withdrawAmount, 0);
145     }
146     
147     // Contract may be destroyed only when there are no ongoing bets,
148     // either settled or refunded. All funds are transferred to contract owner.
149     function kill() external onlyOwner {
150         require (lockedInBets_ == 0, "All bets should be processed (settled or refunded) before self-destruct.");
151         selfdestruct(owner);
152     }
153 
154     // Fallback function deliberately left empty. It's primary use case
155     // is to top up the bank roll.
156     function () external payable {
157     }
158     
159     function placeBet(uint256 betMask, uint256 modulo, uint256 commitLastBlock, uint256 commit, bytes32 r, bytes32 s) 
160         external
161         payable 
162     {
163         Bet storage bet = bets[commit];
164         require(bet.gambler == address(0), "already betting same commit number");
165 
166         uint256 amount = msg.value;
167         require (modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
168         require (amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
169         require (betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
170 
171         require (block.number <= commitLastBlock, "Commit has expired.");
172 
173         //@DEV It will be changed later.
174         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
175         bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, commit));
176         require (secretSigner == ecrecover(prefixedHash, 28, r, s), "ECDSA signature is not valid.");
177 
178         // Winning amount and jackpot increase.
179         uint rollUnder;
180         
181         // Small modulo games specify bet outcomes via bit mask.
182         // rollUnder is a number of 1 bits in this mask (population count).
183         // This magical looking formula is an efficient way to compute population
184         // count on EVM for numbers below 2**40. For detailed proof consult
185         // the our whitepaper.
186         if(modulo <= MAX_MASK_MODULO){
187             rollUnder = ((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
188             // mask = betMask;  //Stack too deep, try removing local variables.
189         }else{
190             require (betMask > 0 && betMask <= modulo, "High modulo range, betMask larger than modulo.");
191             rollUnder = betMask;
192         }
193 
194         uint possibleWinAmount;
195         uint jackpotFee;
196 
197         (possibleWinAmount, jackpotFee) = getGameWinAmount(amount, modulo, rollUnder);
198 
199         // Enforce max profit limit.
200         require (possibleWinAmount <= amount + maxProfit, "maxProfit limit violation.");
201 
202         // Lock funds.
203         lockedInBets_ += uint128(possibleWinAmount);
204         lockedInJackpot_ += uint128(jackpotFee);
205 
206         // Check whether contract has enough funds to process this bet.
207         require (lockedInJackpot_ + lockedInBets_ <= address(this).balance, "Cannot afford to lose this bet.");
208         
209         // Record commit in logs.
210         emit Commit(commit, possibleWinAmount);
211 
212         bet.amount = uint128(amount);
213         bet.placeBlockDifficulty = uint128(block.difficulty);
214         bet.modulo = uint8(modulo);
215         bet.rollUnder = uint8(rollUnder);
216         bet.placeBlockNumber = uint40(block.number);
217         bet.mask = uint40(betMask);
218         bet.gambler = msg.sender;
219     }
220     
221     // This is the method used to settle 99% of bets. To process a bet with a specific
222     // "commit", settleBet should supply a "reveal" number that would Keccak256-hash to
223     // "commit". "difficulty" is the block difficulty of placeBet block as seen by croupier; it
224     // is additionally asserted to prevent changing the bet outcomes on Ethereum reorgs.
225     function settleBet(uint reveal, uint difficulty) external onlyCroupier {
226         uint commit = uint(keccak256(abi.encodePacked(reveal)));
227 
228         Bet storage bet = bets[commit];
229         uint placeBlockNumber = bet.placeBlockNumber;
230 
231         // Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
232         require (block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
233         require (block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
234         // require (blockhash(placeBlockNumber) == blockHash, "Does not matched blockHash.");
235         require (bet.placeBlockDifficulty == difficulty, "Does not matched difficulty.");
236 
237         // Settle bet using reveal and difficulty as entropy sources.
238         settleBetCommon(bet, reveal, difficulty);
239     }
240 
241     // Common settlement code for settleBet.
242     function settleBetCommon(Bet storage bet, uint reveal, uint entropyDifficulty) private {
243         // Fetch bet parameters into local variables (to save gas).
244         uint commit = uint(keccak256(abi.encodePacked(reveal)));
245         uint amount = bet.amount;
246         uint modulo = bet.modulo;
247         uint rollUnder = bet.rollUnder;
248         address payable gambler = bet.gambler;
249 
250         // Check that bet is in 'active' state.
251         require (amount != 0, "Bet should be in an 'active' state");
252 
253         // Move bet into 'processed' state already.
254         bet.amount = 0;
255         
256         // The RNG - combine "reveal" and difficulty of placeBet using Keccak256. Miners
257         // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
258         // preimage is intractable), and house is unable to alter the "reveal" after
259         // placeBet have been mined (as Keccak256 collision finding is also intractable).
260         bytes32 entropy = keccak256(abi.encodePacked(reveal, entropyDifficulty));
261 
262         // Do a roll by taking a modulo of entropy. Compute winning amount.
263         uint game = uint(entropy) % modulo;
264 
265         uint gameWinAmount;
266         uint _jackpotFee;
267         (gameWinAmount, _jackpotFee) = getGameWinAmount(amount, modulo, rollUnder);
268 
269         uint gameWin = 0;
270         uint jackpotWin = 0;
271 
272         // Determine game outcome.
273         if (modulo <= MAX_MASK_MODULO) {
274             // For small modulo games, check the outcome against a bit mask.
275             if ((2 ** game) & bet.mask != 0) {
276                 gameWin = gameWinAmount;
277             }
278         } else {
279             // For larger modulos, check inclusion into half-open interval.
280             if (game < rollUnder) {
281                 gameWin = gameWinAmount;
282             }
283         }
284 
285         // Unlock the bet amount, regardless of the outcome.
286         lockedInBets_ -= uint128(gameWinAmount);
287 
288         // Roll for a jackpot (if eligible).
289         if (amount >= MIN_JACKPOT_BET && lockedInJackpot_ >= minJackpotWinAmount) {
290             // The second modulo, statistically independent from the "main" dice roll.
291             // Effectively you are playing two games at once!
292             uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;
293 
294             // Bingo!
295             if (jackpotRng == 0) {
296                 jackpotWin = lockedInJackpot_;
297                 lockedInJackpot_ = 0;
298             }
299         }
300 
301         // Log jackpot win.
302         if (jackpotWin > 0) {
303             emit JackpotPayment(gambler, jackpotWin);
304         }
305 
306         // Send the funds to gambler.
307         sendFunds(commit, gambler, gameWin, jackpotWin);
308     }
309 
310     function getGameWinAmount(uint amount, uint modulo, uint rollUnder) private pure returns (uint winAmount, uint jackpotFee) {
311         require (0 < rollUnder && rollUnder <= modulo, "Win probability out of range.");
312 
313         jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
314 
315         uint houseEdge = amount * HOUSE_EDGE_PERCENT / 100;
316 
317         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
318             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
319         }
320 
321         require (houseEdge + jackpotFee <= amount, "Bet doesn't even cover house edge.");
322         winAmount = (amount - houseEdge - jackpotFee) * modulo / rollUnder;
323     }
324     
325     // Refund transaction - return the bet amount of a roll that was not processed in a
326     // due timeframe. Processing such blocks is not possible due to EVM limitations (see
327     // BET_EXPIRATION_BLOCKS comment above for details). In case you ever find yourself
328     // in a situation like this, just contact the our support, however nothing
329     // precludes you from invoking this method yourself.
330     function refundBet(uint commit) external {
331         // Check that bet is in 'active' state.
332         Bet storage bet = bets[commit];
333         uint amount = bet.amount;
334 
335         require (amount != 0, "Bet should be in an 'active' state");
336 
337         // Check that bet has already expired.
338         require (block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
339 
340         // Move bet into 'processed' state, release funds.
341         bet.amount = 0;
342         
343         uint gameWinAmount;
344         uint jackpotFee;
345         (gameWinAmount, jackpotFee) = getGameWinAmount(amount, bet.modulo, bet.rollUnder);
346 
347         lockedInBets_ -= uint128(gameWinAmount);
348         lockedInJackpot_ -= uint128(jackpotFee);
349 
350         // Send the refund.
351         sendFunds(commit, bet.gambler, amount, 0);
352     }
353 
354     // Helper routine to process the payment.
355     function sendFunds(uint commit, address payable beneficiary, uint gameWin, uint jackpotWin) private {
356         uint amount = gameWin + jackpotWin == 0 ? 1 wei : gameWin + jackpotWin;
357         uint successLogAmount = gameWin;
358 
359         if (beneficiary.send(amount)) {
360             emit Payment(commit, beneficiary, successLogAmount, jackpotWin);
361         } else {
362             emit FailedPayment(commit, beneficiary, amount, 0);
363         }
364     }
365     
366 }