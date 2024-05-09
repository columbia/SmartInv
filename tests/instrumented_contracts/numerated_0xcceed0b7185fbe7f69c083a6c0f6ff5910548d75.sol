1 pragma solidity <= 0.6;
2 
3 contract Game365Meta {
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
68         // Modulo of a game.
69         uint8 modulo;
70         // Number of winning outcomes, used to compute winning payment (* modulo/rollUnder),
71         // and used instead of mask for games with modulo > MAX_MASK_MODULO.
72         uint8 rollUnder;
73         // Block number of placeBet tx.
74         uint40 placeBlockNumber;
75         // Bit mask representing winning bet outcomes (see MAX_MASK_MODULO comment).
76         uint40 mask;
77         // Address of a gambler, used to pay out winning bets.
78         address payable gambler;
79     }
80     mapping(uint256 => Bet) bets;
81 
82     // Events that are issued to make statistic recovery easier.
83     event FailedPayment(uint256 indexed commit, address indexed beneficiary, uint amount, uint jackpotAmount);
84     event Payment(uint256 indexed commit, address indexed beneficiary, uint amount, uint jackpotAmount);
85     event JackpotPayment(address indexed beneficiary, uint amount);
86     event Commit(uint256 indexed commit, uint256 possibleWinAmount);
87     
88     /**
89         Constructor
90      */
91     constructor () 
92         public
93     {
94         owner = msg.sender;
95     }
96 
97     /**
98         Modifier
99     */
100     // Standard modifier on methods invokable only by contract owner.
101     modifier onlyOwner {
102         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
103         _;
104     }
105     
106     // Standard modifier on methods invokable only by contract owner.
107     modifier onlyCroupier {
108         require (msg.sender == croupier, "OnlyCroupier methods called by non-croupier.");
109         _;
110     }
111 
112     // See comment for "secretSigner" variable.
113     function setSecretSigner(address newSecretSigner) external onlyOwner {
114         secretSigner = newSecretSigner;
115     }
116 
117     // Change the croupier address.
118     function setCroupier(address newCroupier) external onlyOwner {
119         croupier = newCroupier;
120     }
121 
122     function setMaxProfit(uint _maxProfit) public onlyOwner {
123         require (_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
124         maxProfit = _maxProfit;
125     }
126 
127     function setMinJackPotWinAmount(uint _minJackpotAmount) public onlyOwner {
128         minJackpotWinAmount = _minJackpotAmount;
129     }
130 
131     // This function is used to bump up the jackpot fund. Cannot be used to lower it.
132     function increaseJackpot(uint increaseAmount) external onlyOwner {
133         require (increaseAmount <= address(this).balance, "Increase amount larger than balance.");
134         require (lockedInJackpot_ + lockedInBets_ + increaseAmount <= address(this).balance, "Not enough funds.");
135         lockedInJackpot_ += uint128(increaseAmount);
136     }
137 
138     // Funds withdrawal to cover costs of our operation.
139     function withdrawFunds(address payable beneficiary, uint withdrawAmount) external onlyOwner {
140         require (withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
141         require (lockedInJackpot_ + lockedInBets_ + withdrawAmount <= address(this).balance, "Not enough funds.");
142         sendFunds(1, beneficiary, withdrawAmount, 0);
143     }
144     
145     // Contract may be destroyed only when there are no ongoing bets,
146     // either settled or refunded. All funds are transferred to contract owner.
147     function kill() external onlyOwner {
148         require (lockedInBets_ == 0, "All bets should be processed (settled or refunded) before self-destruct.");
149         selfdestruct(owner);
150     }
151 
152     // Fallback function deliberately left empty. It's primary use case
153     // is to top up the bank roll.
154     function () external payable {
155     }
156     
157     function placeBet(uint256 betMask, uint256 modulo, uint256 commitLastBlock, uint256 commit, bytes32 r, bytes32 s) 
158         external
159         payable 
160     {
161         Bet storage bet = bets[commit];
162         require(bet.gambler == address(0), "already betting same commit number");
163 
164         uint256 amount = msg.value;
165         require (modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
166         require (amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
167         require (betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
168 
169         require (block.number <= commitLastBlock, "Commit has expired.");
170 
171         //@DEV It will be changed later.
172         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
173         bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, commit));
174         require (secretSigner == ecrecover(prefixedHash, 28, r, s), "ECDSA signature is not valid.");
175 
176         // Winning amount and jackpot increase.
177         uint rollUnder;
178         
179         // Small modulo games specify bet outcomes via bit mask.
180         // rollUnder is a number of 1 bits in this mask (population count).
181         // This magical looking formula is an efficient way to compute population
182         // count on EVM for numbers below 2**40. For detailed proof consult
183         // the our whitepaper.
184         if(modulo <= MAX_MASK_MODULO){
185             rollUnder = ((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
186             // mask = betMask;  //Stack too deep, try removing local variables.
187         }else{
188             require (betMask > 0 && betMask <= modulo, "High modulo range, betMask larger than modulo.");
189             rollUnder = betMask;
190         }
191 
192         uint possibleWinAmount;
193         uint jackpotFee;
194 
195         (possibleWinAmount, jackpotFee) = getGameWinAmount(amount, modulo, rollUnder);
196 
197         // Enforce max profit limit.
198         require (possibleWinAmount <= amount + maxProfit, "maxProfit limit violation.");
199 
200         // Lock funds.
201         lockedInBets_ += uint128(possibleWinAmount);
202         lockedInJackpot_ += uint128(jackpotFee);
203 
204         // Check whether contract has enough funds to process this bet.
205         require (lockedInJackpot_ + lockedInBets_ <= address(this).balance, "Cannot afford to lose this bet.");
206         
207         // Record commit in logs.
208         emit Commit(commit, possibleWinAmount);
209 
210         bet.amount = uint128(amount);
211         bet.modulo = uint8(modulo);
212         bet.rollUnder = uint8(rollUnder);
213         bet.placeBlockNumber = uint40(block.number);
214         bet.mask = uint40(betMask);
215         bet.gambler = msg.sender;
216     }
217     
218     // This is the method used to settle 99% of bets. To process a bet with a specific
219     // "commit", settleBet should supply a "reveal" number that would Keccak256-hash to
220     // "commit". "blockHash" is the block hash of placeBet block as seen by croupier; it
221     // is additionally asserted to prevent changing the bet outcomes on Ethereum reorgs.
222     function settleBet(uint reveal, bytes32 blockHash) external onlyCroupier {
223         uint commit = uint(keccak256(abi.encodePacked(reveal)));
224 
225         Bet storage bet = bets[commit];
226         uint placeBlockNumber = bet.placeBlockNumber;
227 
228         // Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
229         require (block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
230         require (block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
231         require (blockhash(placeBlockNumber) == blockHash, "Does not matched blockHash.");
232 
233         // Settle bet using reveal and blockhash as entropy sources.
234         settleBetCommon(bet, reveal, blockHash);
235     }
236 
237     // Common settlement code for settleBet.
238     function settleBetCommon(Bet storage bet, uint reveal, bytes32 entropyBlockHash) private {
239         // Fetch bet parameters into local variables (to save gas).
240         uint commit = uint(keccak256(abi.encodePacked(reveal)));
241         uint amount = bet.amount;
242         uint modulo = bet.modulo;
243         uint rollUnder = bet.rollUnder;
244         address payable gambler = bet.gambler;
245 
246         // Check that bet is in 'active' state.
247         require (amount != 0, "Bet should be in an 'active' state");
248 
249         // Move bet into 'processed' state already.
250         bet.amount = 0;
251         
252         // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
253         // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
254         // preimage is intractable), and house is unable to alter the "reveal" after
255         // placeBet have been mined (as Keccak256 collision finding is also intractable).
256         bytes32 entropy = keccak256(abi.encodePacked(reveal, entropyBlockHash));
257 
258         // Do a roll by taking a modulo of entropy. Compute winning amount.
259         uint game = uint(entropy) % modulo;
260 
261         uint gameWinAmount;
262         uint _jackpotFee;
263         (gameWinAmount, _jackpotFee) = getGameWinAmount(amount, modulo, rollUnder);
264 
265         uint gameWin = 0;
266         uint jackpotWin = 0;
267 
268         // Determine game outcome.
269         if (modulo <= MAX_MASK_MODULO) {
270             // For small modulo games, check the outcome against a bit mask.
271             if ((2 ** game) & bet.mask != 0) {
272                 gameWin = gameWinAmount;
273             }
274         } else {
275             // For larger modulos, check inclusion into half-open interval.
276             if (game < rollUnder) {
277                 gameWin = gameWinAmount;
278             }
279         }
280 
281         // Unlock the bet amount, regardless of the outcome.
282         lockedInBets_ -= uint128(gameWinAmount);
283 
284         // Roll for a jackpot (if eligible).
285         if (amount >= MIN_JACKPOT_BET && lockedInJackpot_ >= minJackpotWinAmount) {
286             // The second modulo, statistically independent from the "main" dice roll.
287             // Effectively you are playing two games at once!
288             uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;
289 
290             // Bingo!
291             if (jackpotRng == 0) {
292                 jackpotWin = lockedInJackpot_;
293                 lockedInJackpot_ = 0;
294             }
295         }
296 
297         // Log jackpot win.
298         if (jackpotWin > 0) {
299             emit JackpotPayment(gambler, jackpotWin);
300         }
301 
302         // Send the funds to gambler.
303         sendFunds(commit, gambler, gameWin, jackpotWin);
304     }
305 
306     function getGameWinAmount(uint amount, uint modulo, uint rollUnder) private pure returns (uint winAmount, uint jackpotFee) {
307         require (0 < rollUnder && rollUnder <= modulo, "Win probability out of range.");
308 
309         jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
310 
311         uint houseEdge = amount * HOUSE_EDGE_PERCENT / 100;
312 
313         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
314             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
315         }
316 
317         require (houseEdge + jackpotFee <= amount, "Bet doesn't even cover house edge.");
318         winAmount = (amount - houseEdge - jackpotFee) * modulo / rollUnder;
319     }
320     
321     // Refund transaction - return the bet amount of a roll that was not processed in a
322     // due timeframe. Processing such blocks is not possible due to EVM limitations (see
323     // BET_EXPIRATION_BLOCKS comment above for details). In case you ever find yourself
324     // in a situation like this, just contact the our support, however nothing
325     // precludes you from invoking this method yourself.
326     function refundBet(uint commit) external {
327         // Check that bet is in 'active' state.
328         Bet storage bet = bets[commit];
329         uint amount = bet.amount;
330 
331         require (amount != 0, "Bet should be in an 'active' state");
332 
333         // Check that bet has already expired.
334         require (block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
335 
336         // Move bet into 'processed' state, release funds.
337         bet.amount = 0;
338         
339         uint gameWinAmount;
340         uint jackpotFee;
341         (gameWinAmount, jackpotFee) = getGameWinAmount(amount, bet.modulo, bet.rollUnder);
342 
343         lockedInBets_ -= uint128(gameWinAmount);
344         lockedInJackpot_ -= uint128(jackpotFee);
345 
346         // Send the refund.
347         sendFunds(commit, bet.gambler, amount, 0);
348     }
349 
350     // Helper routine to process the payment.
351     function sendFunds(uint commit, address payable beneficiary, uint gameWin, uint jackpotWin) private {
352         uint amount = gameWin + jackpotWin == 0 ? 1 wei : gameWin + jackpotWin;
353         uint successLogAmount = gameWin;
354 
355         if (beneficiary.send(amount)) {
356             emit Payment(commit, beneficiary, successLogAmount, jackpotWin);
357         } else {
358             emit FailedPayment(commit, beneficiary, amount, 0);
359         }
360     }
361     
362 }