1 pragma solidity < 0.6;
2 
3 contract Game365Meta {
4 
5     /**
6         owner setting
7      */
8     address payable public owner;
9 
10     // Croupier account.
11     address public croupier = address(0x0);
12 
13     // The address corresponding to a private key used to sign placeBet commits.
14     address public secretSigner = address(0x0);
15 
16     // Adjustable max bet profit and start winning the jackpot. Used to cap bets against dynamic odds.
17     uint public maxProfit = 5 ether;
18     uint public minJackpotWinAmount = 0.1 ether;
19 
20     /*
21         set constants
22     */
23     uint constant HOUSE_EDGE_PERCENT = 1;
24     uint constant HOUSE_EDGE_MINIMUM_AMOUNT = 0.0003 ether; 
25 
26     // Chance to win jackpot (currently 0.1%) and fee deducted into jackpot fund.
27     uint public constant MIN_JACKPOT_BET = 0.1 ether;
28     uint public constant JACKPOT_MODULO = 1000; 
29     uint constant JACKPOT_FEE = 0.001 ether; 
30 
31     // There is minimum and maximum bets.
32     uint public constant MIN_BET = 0.01 ether;
33     uint constant MAX_AMOUNT = 300000 ether; 
34     
35     // Modulo is a number of equiprobable outcomes in a game:
36     //  - 2 for coin flip
37     //  - 6 for dice
38     //  - 6*6 = 36 for double dice
39     //  - 100 for etheroll
40     //  - 37 for roulette
41     //  etc.
42     // It's called so because 256-bit entropy is treated like a huge integer and
43     // the remainder of its division by modulo is considered bet outcome.
44     uint constant MAX_MODULO = 100;
45     uint constant MAX_MASK_MODULO = 40;
46 
47     // This is a check on bet mask overflow.
48     uint constant MAX_BET_MASK = 2 ** MAX_MASK_MODULO;
49 
50     // EVM BLOCKHASH opcode can query no further than 256 blocks into the
51     // past. Given that settleBet uses block hash of placeBet as one of
52     // complementary entropy sources, we cannot process bets older than this
53     // threshold. On rare occasions our croupier may fail to invoke
54     // settleBet in this timespan due to technical issues or extreme Ethereum
55     // congestion; such bets can be refunded via invoking refundBet.
56     uint constant BET_EXPIRATION_BLOCKS = 250;
57 
58     // This are some constants making O(1) population count in placeBet possible.
59     // See whitepaper for intuition and proofs behind it.
60     uint constant POPCNT_MULT = 0x0000000000002000000000100000000008000000000400000000020000000001;
61     uint constant POPCNT_MASK = 0x0001041041041041041041041041041041041041041041041041041041041041;
62     uint constant POPCNT_MODULO = 0x3F; // decimal:63, binary:111111
63     
64     /**
65         24h Total bet amounts/counts
66      */    
67     uint256 public lockedInBets_;
68     uint256 public lockedInJackpot_;
69     
70     struct Bet {
71         // Wager amount in wei.
72         uint amount;
73         // Modulo of a game.
74         uint8 modulo;
75         // Number of winning outcomes, used to compute winning payment (* modulo/rollUnder),
76         // and used instead of mask for games with modulo > MAX_MASK_MODULO.
77         uint8 rollUnder;
78         // Block number of placeBet tx.
79         uint40 placeBlockNumber;
80         // Bit mask representing winning bet outcomes (see MAX_MASK_MODULO comment).
81         uint40 mask;
82         // Address of a gambler, used to pay out winning bets.
83         address payable gambler;
84     }
85     mapping(uint256 => Bet) bets;
86 
87     // Events that are issued to make statistic recovery easier.
88     event FailedPayment(uint commit, address indexed beneficiary, uint amount, uint jackpotAmount);
89     event Payment(uint commit, address indexed beneficiary, uint amount, uint jackpotAmount);
90     event JackpotPayment(address indexed beneficiary, uint amount);
91     event Commit(uint256 commit);
92     
93     /**
94         Constructor
95      */
96     constructor () 
97         public
98     {
99         owner = msg.sender;
100     }
101 
102     /**
103         Modifier
104     */
105     // Standard modifier on methods invokable only by contract owner.
106     modifier onlyOwner {
107         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
108         _;
109     }
110     
111     // Standard modifier on methods invokable only by contract owner.
112     modifier onlyCroupier {
113         require (msg.sender == croupier, "OnlyCroupier methods called by non-croupier.");
114         _;
115     }
116 
117     // See comment for "secretSigner" variable.
118     function setSecretSigner(address newSecretSigner) external onlyOwner {
119         secretSigner = newSecretSigner;
120     }
121 
122     // Change the croupier address.
123     function setCroupier(address newCroupier) external onlyOwner {
124         croupier = newCroupier;
125     }
126 
127     function setMaxProfit(uint _maxProfit) public onlyOwner {
128         require (_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
129         maxProfit = _maxProfit;
130     }
131 
132     function setMinJackPotWinAmount(uint _minJackpotAmount) public onlyOwner {
133         minJackpotWinAmount = _minJackpotAmount;
134     }
135 
136     // This function is used to bump up the jackpot fund. Cannot be used to lower it.
137     function increaseJackpot(uint increaseAmount) external onlyOwner {
138         require (increaseAmount <= address(this).balance, "Increase amount larger than balance.");
139         require (lockedInJackpot_ + lockedInBets_ + increaseAmount <= address(this).balance, "Not enough funds.");
140         lockedInJackpot_ += uint128(increaseAmount);
141     }
142 
143     // Funds withdrawal to cover costs of our operation.
144     function withdrawFunds(address payable beneficiary, uint withdrawAmount) external onlyOwner {
145         require (withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
146         sendFunds(1, beneficiary, withdrawAmount, 0);
147     }
148     
149     // Contract may be destroyed only when there are no ongoing bets,
150     // either settled or refunded. All funds are transferred to contract owner.
151     function kill() external onlyOwner {
152         selfdestruct(owner);
153     }
154 
155     // Fallback function deliberately left empty. It's primary use case
156     // is to top up the bank roll.
157     function () external payable {
158     }
159     
160     function placeBet(uint256 betMask, uint256 modulo, uint256 commitLastBlock, uint256 commit, bytes32 r, bytes32 s) 
161         external
162         payable 
163     {
164         Bet storage bet = bets[commit];
165         require(bet.gambler == address(0), "already betting same commit number");
166 
167         uint256 amount = msg.value;
168         require (modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
169         require (amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
170         require (betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
171 
172         require (block.number <= commitLastBlock, "Commit has expired.");
173 
174         //@DEV It will be changed later.
175         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
176         bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, commit));
177         require (secretSigner == ecrecover(prefixedHash, 28, r, s), "ECDSA signature is not valid.");
178 
179 
180         // Winning amount and jackpot increase.
181         uint rollUnder;
182         // uint mask;
183         
184         // Small modulo games specify bet outcomes via bit mask.
185         // rollUnder is a number of 1 bits in this mask (population count).
186         // This magical looking formula is an efficient way to compute population
187         // count on EVM for numbers below 2**40. For detailed proof consult
188         // the our whitepaper.
189         if(modulo <= MAX_MASK_MODULO){
190             rollUnder = ((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
191             // mask = betMask;  //Stack too deep, try removing local variables.
192         }else{
193             require (betMask > 0 && betMask <= modulo, "High modulo range, betMask larger than modulo.");
194             rollUnder = betMask;
195         }
196 
197         uint possibleWinAmount;
198         uint jackpotFee;
199 
200         (possibleWinAmount, jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
201 
202         // Enforce max profit limit.
203         require (possibleWinAmount <= amount + maxProfit, "maxProfit limit violation.");
204 
205         // Lock funds.
206         lockedInBets_ += uint128(possibleWinAmount);
207         lockedInJackpot_ += uint128(jackpotFee);
208 
209         // Check whether contract has enough funds to process this bet.
210         require (lockedInJackpot_ + lockedInBets_ <= address(this).balance, "Cannot afford to lose this bet.");
211         
212         // Record commit in logs.
213         emit Commit(commit);
214 
215         bet.amount = amount;
216         bet.modulo = uint8(modulo);
217         bet.rollUnder = uint8(rollUnder);
218         bet.placeBlockNumber = uint40(block.number);
219         bet.mask = uint40(betMask);
220         bet.gambler = msg.sender;
221     }
222     
223     // This is the method used to settle 99% of bets. To process a bet with a specific
224     // "commit", settleBet should supply a "reveal" number that would Keccak256-hash to
225     // "commit". "blockHash" is the block hash of placeBet block as seen by croupier; it
226     // is additionally asserted to prevent changing the bet outcomes on Ethereum reorgs.
227     function settleBet(uint reveal, bytes32 blockHash) external onlyCroupier {
228         uint commit = uint(keccak256(abi.encodePacked(reveal)));
229 
230         Bet storage bet = bets[commit];
231         uint placeBlockNumber = bet.placeBlockNumber;
232 
233         // Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
234         require (block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
235         require (block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
236         require (blockhash(placeBlockNumber) == blockHash, "Does not matched blockHash.");
237 
238         // Settle bet using reveal and blockHash as entropy sources.
239         settleBetCommon(bet, reveal, blockHash);
240     }
241 
242     // Common settlement code for settleBet & settleBetUncleMerkleProof.
243     function settleBetCommon(Bet storage bet, uint reveal, bytes32 entropyBlockHash) private {
244         // Fetch bet parameters into local variables (to save gas).
245         uint commit = uint(keccak256(abi.encodePacked(reveal)));
246         uint amount = bet.amount;
247         uint modulo = bet.modulo;
248         uint rollUnder = bet.rollUnder;
249         address payable gambler = bet.gambler;
250 
251         // Check that bet is in 'active' state.
252         require (amount != 0, "Bet should be in an 'active' state");
253 
254         // Move bet into 'processed' state already.
255         bet.amount = 0;
256         
257         // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
258         // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
259         // preimage is intractable), and house is unable to alter the "reveal" after
260         // placeBet have been mined (as Keccak256 collision finding is also intractable).
261         bytes32 entropy = keccak256(abi.encodePacked(reveal, entropyBlockHash));
262 
263         // Do a roll by taking a modulo of entropy. Compute winning amount.
264         uint dice = uint(entropy) % modulo;
265 
266         uint diceWinAmount;
267         uint _jackpotFee;
268         (diceWinAmount, _jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
269 
270         uint diceWin = 0;
271         uint jackpotWin = 0;
272 
273         // Determine dice outcome.
274         if (modulo <= MAX_MASK_MODULO) {
275             // For small modulo games, check the outcome against a bit mask.
276             if ((2 ** dice) & bet.mask != 0) {
277                 diceWin = diceWinAmount;
278             }
279         } else {
280             // For larger modulos, check inclusion into half-open interval.
281             if (dice < rollUnder) {
282                 diceWin = diceWinAmount;
283             }
284         }
285 
286         // Unlock the bet amount, regardless of the outcome.
287         lockedInBets_ -= uint128(diceWinAmount);
288 
289         // Roll for a jackpot (if eligible).
290         if (amount >= MIN_JACKPOT_BET && lockedInJackpot_ >= minJackpotWinAmount) {
291             // The second modulo, statistically independent from the "main" dice roll.
292             // Effectively you are playing two games at once!
293             uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;
294 
295             // Bingo!
296             if (jackpotRng == 0) {
297                 jackpotWin = lockedInJackpot_;
298                 lockedInJackpot_ = 0;
299             }
300         }
301 
302         // Log jackpot win.
303         if (jackpotWin > 0) {
304             emit JackpotPayment(gambler, jackpotWin);
305         }
306 
307         // Send the funds to gambler.
308         sendFunds(commit, gambler, diceWin, jackpotWin);
309     }
310 
311     function getDiceWinAmount(uint amount, uint modulo, uint rollUnder) private pure returns (uint winAmount, uint jackpotFee) {
312         require (0 < rollUnder && rollUnder <= modulo, "Win probability out of range.");
313 
314         jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
315 
316         uint houseEdge = amount * HOUSE_EDGE_PERCENT / 100;
317 
318         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
319             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
320         }
321 
322         require (houseEdge + jackpotFee <= amount, "Bet doesn't even cover house edge.");
323         winAmount = (amount - houseEdge - jackpotFee) * modulo / rollUnder;
324     }
325     
326     // Refund transaction - return the bet amount of a roll that was not processed in a
327     // due timeframe. Processing such blocks is not possible due to EVM limitations (see
328     // BET_EXPIRATION_BLOCKS comment above for details). In case you ever find yourself
329     // in a situation like this, just contact the our support, however nothing
330     // precludes you from invoking this method yourself.
331     function refundBet(uint commit) external {
332         // Check that bet is in 'active' state.
333         Bet storage bet = bets[commit];
334         uint amount = bet.amount;
335 
336         require (amount != 0, "Bet should be in an 'active' state");
337 
338         // Check that bet has already expired.
339         require (block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
340 
341         // Move bet into 'processed' state, release funds.
342         bet.amount = 0;
343         
344         uint diceWinAmount;
345         uint jackpotFee;
346         (diceWinAmount, jackpotFee) = getDiceWinAmount(amount, bet.modulo, bet.rollUnder);
347 
348         lockedInBets_ -= uint128(diceWinAmount);
349         lockedInJackpot_ -= uint128(jackpotFee);
350 
351         // Send the refund.
352         sendFunds(commit, bet.gambler, amount, 0);
353     }
354 
355     // Helper routine to process the payment.
356     function sendFunds(uint commit, address payable beneficiary, uint diceWin, uint jackpotWin) private {
357         uint amount = diceWin + jackpotWin == 0 ? 1 wei : diceWin + jackpotWin;
358         uint successLogAmount = diceWin;
359 
360         if (beneficiary.send(amount)) {
361             emit Payment(commit, beneficiary, successLogAmount, jackpotWin);
362         } else {
363             emit FailedPayment(commit, beneficiary, amount, 0);
364         }
365     }
366 }