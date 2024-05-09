1 pragma solidity >= 0.5.0;
2 
3 contract WinyDice {
4     address payable private OWNER;
5 
6     // Each bet is deducted 0.98% in favour of the house, but no less than some minimum.
7     // The lower bound is dictated by gas costs of the settleBet transaction, providing
8     // headroom for up to 20 Gwei prices.
9     uint public constant HOUSE_EDGE_OF_TEN_THOUSAND = 98;
10     uint public constant HOUSE_EDGE_MINIMUM_AMOUNT = 0.0003 ether;
11 
12     // Modulo is a number of equiprobable outcomes in a game:
13     //  - 2 for coin flip
14     //  - 6 for dice
15     //  - 6 * 6 = 36 for double dice
16     //  - 6 * 6 * 6 = 216 for triple dice
17     //  - 37 for rouletter
18     //  - 4, 13, 26, 52 for poker
19     //  - 100 for etheroll
20     //  etc.
21     // It's called so because 256-bit entropy is treated like a huge integer and
22     // the remainder of its division by modulo is considered bet outcome.
23     uint constant MAX_MODULO = 216;
24 
25     // For modulos below this threshold rolls are checked against a bit mask,
26     // thus allowing betting on any combination of outcomes. For example, given
27     // modulo 6 for dice, 101000 mask (base-2, big endian) means betting on
28     // 4 and 6; for games with modulos higher than threshold (Etheroll), a simple
29     // limit is used, allowing betting on any outcome in [0, N) range.
30     //
31     // The specific value is dictated by the fact that 256-bit intermediate
32     // multiplication result allows implementing population count efficiently
33     // for numbers that are up to 42 bits.
34     uint constant MAX_MASK_MODULO = 216;
35 
36     // This is a check on bet mask overflow.
37     uint constant MAX_BET_MASK = 2 ** MAX_MASK_MODULO;
38 
39     // Adjustable max bet profit. Used to cap bets against dynamic odds.
40     uint public MAX_PROFIT;
41     uint public MAX_PROFIT_PERCENT = 10;
42     bool public KILLED;
43 
44     // Funds that are locked in potentially winning bets. Prevents contract from
45     // committing to bets it cannot pay out.
46     uint128 public LOCKED_IN_BETS;
47 
48     uint256 public JACKPOT_BALANCE = 0;
49 
50     bool public PAYOUT_PAUSED; 
51     bool public GAME_PAUSED;
52 
53     //Minimum amount that can have a chance to win jackpot
54     uint256 public constant MIN_JACKPOT_BET = 0.1 ether;
55     uint256 public JACKPOT_CHANCE = 1000;   //0.1%
56     uint256 public constant JACKPOT_FEE = 0.001 ether;
57 
58     uint constant MIN_BET = 0.01 ether;
59     uint constant MAX_BET = 300000 ether;
60 
61      // This are some constants making O(1) population count in placeBet possible.
62     // See whitepaper for intuition and proofs behind it.
63     uint constant POPCNT_MULT = 0x0000000000002000000000100000000008000000000400000000020000000001;
64     uint constant POPCNT_MASK = 0x0001041041041041041041041041041041041041041041041041041041041041;
65     uint constant POPCNT_MODULO = 0x3F;
66     uint constant MASK40 = 0xFFFFFFFFFF;
67     uint constant MASK_MODULO_40 = 40;
68 
69     // A structure representing a single bet.
70     struct Bet {
71         // Wager amount in wei.
72         uint80 Amount;//10
73         // Modulo of a game.
74         uint8 Modulo;//1
75         // Number of winning outcomes, used to compute winning payment (* modulo/rollUnder),
76         // and used instead of mask for games with modulo > MAX_MASK_MODULO.
77         uint8 RollUnder;//1
78         // Address of a player, used to pay out winning bets.
79         address payable Player;//20
80         // Bit mask representing winning bet outcomes (see MAX_MASK_MODULO comment).
81         uint216 Mask;//27
82         uint40 PlaceBlockNumber;
83     }
84 
85     // Mapping from commits to all currently active & processed bets.
86     mapping(uint => Bet) bets;
87     // Croupier account.
88     address private CROUPIER;
89 
90     // Events that are issued to make statistic recovery easier.
91     event FailedPayment(address indexed playerAddress,uint indexed betId, uint amount,uint dice);
92     event Payment(address indexed playerAddress,uint indexed betId, uint amount,uint dice);
93     event JackpotPayment(address indexed playerAddress,uint indexed betId, uint amount);    
94     // This event is emitted in placeBet to record commit in the logs.
95     event BetPlaced(uint indexed betId, uint source);
96     event LogTransferEther(address indexed SentToAddress, uint256 AmountTransferred);
97 
98     constructor (address payable _owner,address _croupier) public payable {
99         OWNER = _owner;                
100         CROUPIER = _croupier;
101         KILLED = false;
102     }
103 
104     modifier onlyOwner() {
105         require(msg.sender == OWNER,"only owner can call this function.");
106         _;
107     }
108 
109     // Standard modifier on methods invokable only by Croupier.
110     modifier onlyCroupier {
111         require(msg.sender == CROUPIER, "OnlyCroupier methods called by non-croupier.");
112         _;
113     }
114 
115     modifier payoutsAreActive {
116         if(PAYOUT_PAUSED == true) revert("payouts are currently paused.");
117         _;
118     } 
119 
120     modifier gameIsActive {
121         if(GAME_PAUSED == true) revert("game is not active right now.");
122         _;
123     } 
124 
125 
126     function GetChoiceCountForLargeModulo(uint inputMask, uint n) private pure returns (uint choiceCount) {
127         choiceCount += (((inputMask & MASK40) * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
128         for (uint i = 1; i < n; i++) {
129             inputMask = inputMask >> MASK_MODULO_40;
130             choiceCount += (((inputMask & MASK40) * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
131         }
132         return choiceCount;
133     }
134 
135     function GetChoiceCount(uint inputMask ,uint modulo) private pure returns (uint choiceCount,uint mask) {
136 
137         if (modulo <= MASK_MODULO_40) {
138             // Small modulo games specify bet outcomes via bit mask.
139             // rollUnder is a number of 1 bits in this mask (population count).
140             // This magic looking formula is an efficient way to compute population
141             // count on EVM for numbers below 2**40.
142             choiceCount = ((inputMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
143             mask = inputMask;
144         } else if (modulo <= MASK_MODULO_40 * 2) {
145             choiceCount = GetChoiceCountForLargeModulo(inputMask, 2);
146             mask = inputMask;
147         } else if (modulo == 100) {
148             require(inputMask > 0 && inputMask <= modulo, "High modulo range, betMask larger than modulo.");
149             choiceCount = inputMask;
150         } else if (modulo <= MASK_MODULO_40 * 3) {
151             choiceCount = GetChoiceCountForLargeModulo(inputMask, 3);
152             mask = inputMask;
153         } else if (modulo <= MASK_MODULO_40 * 4) {
154             choiceCount = GetChoiceCountForLargeModulo(inputMask, 4);
155             mask = inputMask;
156         } else if (modulo <= MASK_MODULO_40 * 5) {
157             choiceCount = GetChoiceCountForLargeModulo(inputMask, 5);
158             mask = inputMask;
159         } else if (modulo <= MAX_MASK_MODULO) {
160             choiceCount = GetChoiceCountForLargeModulo(inputMask, 6);
161             mask = inputMask;
162         } else {
163             // Larger modulos specify the right edge of half-open interval of
164             // winning bet outcomes.
165             require(inputMask > 0 && inputMask <= modulo, "High modulo range, betMask larger than modulo.");
166             choiceCount = inputMask;
167         }        
168     }
169 
170     // Get the expected win amount after house edge is subtracted.
171     function GetDiceWinAmount(uint amount, uint modulo, uint choiceCount) private pure returns (uint winAmount, uint jackpotFee) {
172         require(0 < choiceCount && choiceCount <= modulo, "Win probability out of range.");
173 
174         jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
175 
176         uint houseEdge = amount * HOUSE_EDGE_OF_TEN_THOUSAND / 10000;
177 
178         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
179             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
180         }
181 
182         require(houseEdge + jackpotFee <= amount, "Bet doesn't even cover house edge.");
183 
184         winAmount = (amount - houseEdge - jackpotFee) * modulo / choiceCount;
185     }    
186 
187     /// *** Betting logic
188 
189     // Bet states:
190     //  amount == 0 && player == 0 - 'clean' (can place a bet)
191     //  amount != 0 && player != 0 - 'active' (can be settled or refunded)
192     //  amount == 0 && player != 0 - 'processed' (can clean storage)
193     
194     function PlaceBet(uint mask, uint modulo, uint betId , uint source) public payable gameIsActive {        
195         if(KILLED == true) revert ("Contract Killed");
196         // Check that the bet is in 'clean' state.
197         MAX_PROFIT = (address(this).balance + msg.value - LOCKED_IN_BETS - JACKPOT_BALANCE) * MAX_PROFIT_PERCENT / 100;
198         Bet storage bet = bets[betId];
199         if(bet.Player != address(0)) revert("Bet should be in a 'clean' state.");
200 
201         // Validate input data ranges.
202         if(modulo < 2 && modulo > MAX_MODULO) revert("Modulo should be within range.");
203         if(msg.value < MIN_BET && msg.value > MAX_BET) revert("Amount should be within range.");
204         if(mask < 0 && mask > MAX_BET_MASK) revert("Mask should be within range.");
205 
206         uint choiceCount;
207         uint finalMask;
208         (choiceCount,finalMask) = GetChoiceCount(mask,modulo);        
209 
210         // Winning amount and jackpot increase.
211         uint possibleWinAmount;
212         uint jackpotFee;
213 
214         (possibleWinAmount, jackpotFee) = GetDiceWinAmount(msg.value, modulo, choiceCount);
215 
216         // Enforce max profit limit.
217         if(possibleWinAmount > MAX_PROFIT) revert("maxProfit limit violation.");
218 
219         // Lock funds.
220         LOCKED_IN_BETS += uint128(possibleWinAmount);
221         JACKPOT_BALANCE += uint128(jackpotFee);
222 
223         // Check whether contract has enough funds to process this bet.
224         if((JACKPOT_BALANCE + LOCKED_IN_BETS) > address(this).balance) revert( "Cannot afford to lose this bet.");        
225 
226         // Record commit in logs.
227         emit BetPlaced(betId, source);
228 
229         // Store bet parameters on blockchain.
230         bet.Amount = uint80(msg.value);
231         bet.Modulo = uint8(modulo);
232         bet.RollUnder = uint8(choiceCount);
233         bet.Mask = uint216(mask);
234         bet.Player = msg.sender;
235         bet.PlaceBlockNumber = uint40(block.number);
236     }
237 
238     // Helper routine to process the payment.
239     function SendFunds(address payable beneficiary, uint amount, uint successLogAmount, uint betId,uint dice) private {
240         if (beneficiary.send(amount)) {
241             emit Payment(beneficiary,betId, successLogAmount,dice);
242             MAX_PROFIT = (address(this).balance - amount - JACKPOT_BALANCE - LOCKED_IN_BETS) * MAX_PROFIT_PERCENT / 100;
243         } else {
244             emit FailedPayment(beneficiary,betId,amount,dice);
245         }
246         
247     }
248 
249     // Refund transaction - return the bet amount of a roll that was not processed in a
250     // due timeframe. 
251     // in a situation like this, just contact us, however nothing
252     // precludes you from invoking this method yourself.
253     function RefundBet(uint betId) external onlyOwner {
254         // Check that bet is in 'active' state.
255         Bet storage bet = bets[betId];
256         uint amount = bet.Amount;
257 
258         if(amount == 0) revert("Bet should be in an 'active' state");
259 
260         // Move bet into 'processed' state, release funds.
261         bet.Amount = 0;
262 
263         uint diceWinAmount;
264         uint jackpotFee;
265         (diceWinAmount, jackpotFee) = GetDiceWinAmount(amount, bet.Modulo, bet.RollUnder);
266 
267         LOCKED_IN_BETS -= uint128(diceWinAmount);
268         if (JACKPOT_BALANCE >= jackpotFee) {
269             JACKPOT_BALANCE -= uint128(jackpotFee);
270         }       
271 
272         // Send the refund.
273         SendFunds(bet.Player, amount, amount, betId,0);
274         MAX_PROFIT = (address(this).balance - LOCKED_IN_BETS - JACKPOT_BALANCE - diceWinAmount) * MAX_PROFIT_PERCENT / 100;
275         delete bets[betId];
276     }
277 
278      // This is the method used to settle bets. 
279     function SettleBet(string memory betString,bytes32 blockHash) public onlyCroupier {
280         uint betId = uint(keccak256(abi.encodePacked(betString)));
281 
282         Bet storage bet = bets[betId];
283 
284          uint placeBlockNumber = bet.PlaceBlockNumber;
285 
286         if(block.number <= placeBlockNumber) revert("settleBet in the same block as placeBet, or before.");
287         if(blockhash(placeBlockNumber) != blockHash) revert("Invalid BlockHash");        
288         
289         SettleBetCommon(bet,betId,blockHash);
290     }
291 
292     // Common settlement code for settleBet.
293     function SettleBetCommon(Bet storage bet, uint betId,bytes32 blockHash) private {
294         uint amount = bet.Amount;
295         uint modulo = bet.Modulo;
296         uint rollUnder = bet.RollUnder;
297         address payable player = bet.Player;
298 
299         // Check that bet is in 'active' state.        
300         if(amount == 0) revert("Bet should be in an 'active' state");
301 
302         // Move bet into 'processed' state already.
303         bet.Amount = 0;
304 
305         // The RNG - combine "betId" and blockHash of placeBet using Keccak256.
306         bytes32 entropy = keccak256(abi.encodePacked(betId, blockHash));
307         
308         // Do a roll by taking a modulo of entropy. Compute winning amount.
309         uint dice = uint(entropy) % modulo;
310 
311         uint diceWinAmount;
312         uint _jackpotFee;
313         (diceWinAmount, _jackpotFee) = GetDiceWinAmount(amount, modulo, rollUnder);
314 
315         uint diceWin = 0;
316         uint jackpotWin = 0;
317 
318         // Determine dice outcome.
319         if ((modulo != 100) && (modulo <= MAX_MASK_MODULO)) {
320             // For small modulo games, check the outcome against a bit mask.
321             if ((2 ** dice) & bet.Mask != 0) {
322                 diceWin = diceWinAmount;
323             }
324         } else {
325             // For larger modulos, check inclusion into half-open interval.
326             if (dice < rollUnder) {
327                 diceWin = diceWinAmount;
328             }
329         }
330 
331         // Unlock the bet amount, regardless of the outcome.
332         LOCKED_IN_BETS -= uint128(diceWinAmount);
333 
334         // Roll for a jackpot (if eligible).
335         if (amount >= MIN_JACKPOT_BET) {
336             // The second modulo, statistically independent from the "main" dice roll.
337             // Effectively you are playing two games at once!
338             uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_CHANCE;
339 
340             // Bingo!
341             if (jackpotRng == 0) {
342                 jackpotWin = JACKPOT_BALANCE;
343                 JACKPOT_BALANCE = 0;
344             }
345         }
346 
347         // Log jackpot win.
348         if (jackpotWin > 0) {
349             emit JackpotPayment(player,betId,jackpotWin);
350         }        
351 
352         // Send the funds to player.
353         SendFunds(player, diceWin + jackpotWin == 0 ? 1 wei : diceWin + jackpotWin, diceWin, betId,dice);
354         MAX_PROFIT = (address(this).balance - LOCKED_IN_BETS - JACKPOT_BALANCE - diceWin) * MAX_PROFIT_PERCENT / 100;
355         delete bets[betId];
356     }
357 
358     function GetBetInfoByBetString(string memory betString) public view onlyOwner returns (uint _betId, uint amount, uint8 modulo, uint8 rollUnder, uint betId, uint mask, address player) {
359         _betId = uint(keccak256(abi.encodePacked(betString)));
360         (amount, modulo, rollUnder, betId, mask, player) = GetBetInfo(_betId);
361     }
362 
363     function GetBetInfo(uint _betId) public view returns (uint amount, uint8 modulo, uint8 rollUnder, uint betId, uint mask, address player) {
364         Bet storage bet = bets[_betId];
365         amount = bet.Amount;
366         modulo = bet.Modulo;
367         rollUnder = bet.RollUnder;
368         betId = _betId;
369         mask = bet.Mask;
370         player = bet.Player;
371     }
372 
373     /* only owner address can set emergency pause #1 */
374     function ownerPauseGame(bool newStatus) public onlyOwner {
375         GAME_PAUSED = newStatus;
376     }
377 
378     /* only owner address can set emergency pause #2 */
379     function ownerPausePayouts(bool newPayoutStatus) public onlyOwner {
380         PAYOUT_PAUSED = newPayoutStatus;
381     }   
382 
383     /* only owner address can set emergency pause #2 */
384     function ownerSetMaxProfit(uint _maxProfit) public onlyOwner {
385         MAX_PROFIT = _maxProfit;
386         MAX_PROFIT = (address(this).balance - LOCKED_IN_BETS - JACKPOT_BALANCE) * MAX_PROFIT_PERCENT / 100;
387     }
388 
389      /* only owner address can set emergency pause #2 */
390     function ownerSetMaxProfitPercent(uint _maxProfitPercent) public onlyOwner {
391         MAX_PROFIT_PERCENT = _maxProfitPercent;
392         MAX_PROFIT = (address(this).balance - LOCKED_IN_BETS - JACKPOT_BALANCE) * MAX_PROFIT_PERCENT / 100;
393     }    
394 
395     /* only owner address can transfer ether */
396     function TransferEther(address payable sendTo, uint amount) public onlyOwner {        
397         /* safely update contract balance when sending out funds*/              
398         if(!sendTo.send(amount)) 
399             revert("owner transfer ether failed.");
400         if(KILLED == false)
401         {
402             MAX_PROFIT = (address(this).balance - LOCKED_IN_BETS - JACKPOT_BALANCE) * MAX_PROFIT_PERCENT / 100;            
403         }
404         emit LogTransferEther(sendTo, amount); 
405     }
406 
407     //Add ether to contract by owner
408     function ChargeContract () external payable onlyOwner {
409         /* safely update contract balance */ 
410         MAX_PROFIT = (address(this).balance - LOCKED_IN_BETS - JACKPOT_BALANCE) * MAX_PROFIT_PERCENT / 100;       
411     }
412 
413     // Contract may be destroyed only when there are no ongoing bets,
414     // either settled or refunded. All funds are transferred to contract owner.
415     function kill() external onlyOwner {
416         require(LOCKED_IN_BETS == 0, "All bets should be processed (settled or refunded) before self-destruct.");
417         KILLED = true;
418         JACKPOT_BALANCE = 0;        
419     }
420 
421      function ownerSetNewOwner(address payable newOwner) external onlyOwner {
422         OWNER = newOwner;       
423     }
424 
425     function ownerSetNewCroupier(address newCroupier) external onlyOwner {
426         CROUPIER =  newCroupier  ; 
427     }
428 }