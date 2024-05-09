1 pragma solidity ^0.4.23;
2 
3 /**
4  _ _ _  _____  _____  _____  __            ___    _____  _____  _____  _____  _____
5 | | | ||  |  ||   __||   __||  |      ___ |  _|  |   __||_   _||  |  ||   __|| __  |
6 | | | ||     ||   __||   __||  |__   | . ||  _|  |   __|  | |  |     ||   __||    -|
7 |_____||__|__||_____||_____||_____|  |___||_|    |_____|  |_|  |__|__||_____||__|__|
8 
9 
10 
11                                   `.-::::::::::::-.`
12                            .:::+:-.`            `.-:+:::.
13                       `::::.   `-                  -`   .:::-`
14                    .:::`        :                  :        `:::.
15                 `:/-            `-                -`            -/:`
16               ./:`               :               `:               `:/.
17             .+:                   :              :                  `:+.
18           `/-`..`                 -`            `-                 `..`-/`
19          :/`    ..`                :            :                `..    `/:
20        `+.        ..`              -`          `-              `..        .+`
21       .+`           ..`             :          :             `..           `+.
22      -+               ..`           -.        ..           `..               +-
23     .+                 `..`          :        :          `..                  +.
24    `o                    `..`        ..      ..        `..`                    o`
25    o`                      `..`     `./------/.`     `..`                      `o
26   -+``                       `..``-::.````````.::-``..`                       ``+-
27   s```....````                 `+:.  ..------..  .:+`                 ````....```o
28  .+       ````...````         .+. `--``      ``--` .+.         ````...````       +.
29  +.              ````....`````+` .:`            `:. `o`````....````              ./
30  o                       ````s` `/                /` `s````                       o
31  s                           s  /`                .:  s                           s
32  s                           s  /`                `/  s                           s
33  s                        ```s` `/                /` `s```                        o
34  +.               ````....```.+  .:`            `:.  +.```....````               .+
35  ./        ```....````        -/` `--`        `--` `/.        ````....```        +.
36   s````....```                 .+:` `.--------.` `:+.                 ```....````s
37   :/```                       ..`.::-.``    ``.-::.`..                       ```/:
38    o`                       ..`     `-/-::::-/-`     `..                       `o
39    `o                     ..`        ..      ..        `..                     o`
40     -/                  ..`          :        :          `..                  /-
41      -/               ..`           ..        ..           `..               /-
42       -+`           ..`             :          :             `-.           `+-
43        .+.        .-`              -`          ..              `-.        .+.
44          /:     .-`                :            :                `-.    `:/
45           ./- .-`                 -`            `-                 `-. -/.
46             -+-                   :              :                   :+-
47               -/-`               -`              `-               `-/-
48                 .:/.             :                :             ./:.
49                    -:/-         :                  :         -/:-
50                       .:::-`   `-                  -`   `-:::.
51                           `-:::+-.`              `.:+:::-`
52                                 `.-::::::::::::::-.`
53 
54 ---Design---
55 Jörmungandr
56 
57 ---Contract and Frontend---
58 Mr Fahrenheit
59 Jörmungandr
60 
61 ---Contract Auditor---
62 8 ฿ł₮ ₮Ɽł₱
63 
64 ---Contract Advisors---
65 Etherguy
66 Norsefire
67 
68 **/
69 
70 contract WheelOfEther {
71     using SafeMath for uint;
72 
73     //  Modifiers
74 
75     modifier nonContract() {                // contracts pls go
76         require(tx.origin == msg.sender);
77         _;
78     }
79 
80     modifier gameActive() {
81         require(gamePaused == false);
82         _;
83     }
84 
85     modifier onlyAdmin(){
86         require(msg.sender == admin);
87         _;
88     }
89 
90     // Events
91 
92     event onTokenPurchase(
93         address indexed customerAddress,
94         uint256 ethereumIn,
95         uint256 contractBal,
96         uint timestamp
97     );
98 
99     event onTokenSell(
100         address indexed customerAddress,
101         uint256 ethereumOut,
102         uint256 contractBal,
103         uint timestamp
104     );
105 
106     event spinResult(
107         address indexed customerAddress,
108         uint256 wheelNumber,
109         uint256 outcome,
110         uint256 ethSpent,
111         uint256 ethReturned,
112         uint256 devFee,
113         uint timestamp
114     );
115 
116     uint256 _seed;
117     address admin;
118     bool public gamePaused = false;
119     uint256 minBet = 0.01 ether;
120     uint256 devFeeBalance = 0;
121 
122     uint8[10] brackets = [1,3,6,12,24,40,56,68,76,80];
123 
124     uint256 internal globalFactor = 1000000000000000000000;
125     uint256 constant internal constantFactor = globalFactor * globalFactor;
126     mapping(address => uint256) internal personalFactorLedger_;
127     mapping(address => uint256) internal balanceLedger_;
128 
129 
130     constructor()
131         public
132     {
133         admin = msg.sender;
134     }
135 
136 
137     function getBalance()
138         public
139         view
140         returns (uint256)
141     {
142         return this.balance;
143     }
144 
145 
146     function buyTokens()
147         public
148         payable
149         nonContract
150         gameActive
151     {
152         address _customerAddress = msg.sender;
153         // User must buy at least 0.01 eth
154         require(msg.value >= minBet);
155         // Adjust ledgers
156         balanceLedger_[_customerAddress] = ethBalanceOf(_customerAddress).add(msg.value);
157         personalFactorLedger_[_customerAddress] = constantFactor / globalFactor;
158 
159         onTokenPurchase(_customerAddress, msg.value, this.balance, now);
160     }
161 
162 
163     function sell(uint256 sellEth)
164         public
165         nonContract
166     {
167         address _customerAddress = msg.sender;
168         // User must have enough eth and cannot sell 0
169         require(sellEth <= ethBalanceOf(_customerAddress));
170         require(sellEth > 0);
171         // Transfer balance and update user ledgers
172         _customerAddress.transfer(sellEth);
173         balanceLedger_[_customerAddress] = ethBalanceOf(_customerAddress).sub(sellEth);
174 		personalFactorLedger_[_customerAddress] = constantFactor / globalFactor;
175 
176         onTokenSell(_customerAddress, sellEth, this.balance, now);
177     }
178 
179 
180     function ethBalanceOf(address _customerAddress)
181         public
182         view
183         returns (uint256)
184     {
185         // Balance ledger * personal factor * globalFactor / constantFactor
186         return balanceLedger_[_customerAddress].mul(personalFactorLedger_[_customerAddress]).mul(globalFactor) / constantFactor;
187     }
188 
189 
190     function tokenSpin(uint256 betEth)
191         public
192         nonContract
193         gameActive
194         returns (uint256 resultNum)
195     {
196         address _customerAddress = msg.sender;
197         // User must have enough eth
198         require(ethBalanceOf(_customerAddress) >= betEth);
199         // If user bets more than available bet pool, bet only as much as the pool
200         if (betEth > betPool(_customerAddress)) {
201             betEth = betPool(_customerAddress);
202         }
203         // User must bet more than the minimum
204         require(betEth >= minBet);
205         // Execute the bet and return the outcome
206         resultNum = bet(betEth, _customerAddress);
207     }
208 
209 
210     function etherSpin()
211         public
212         payable
213         nonContract
214         gameActive
215         returns (uint256 resultNum)
216     {
217         address _customerAddress = msg.sender;
218         uint256 betEth = msg.value;
219         // All eth is converted into tokens before the bet
220         // If user bets more than available bet pool, bet only as much as the pool
221         if (betEth > betPool(_customerAddress)) {
222             betEth = betPool(_customerAddress);
223         }
224         // User must bet more than the minimum
225         require(betEth >= minBet);
226         // Adjust ledgers
227         balanceLedger_[_customerAddress] = ethBalanceOf(_customerAddress).add(msg.value);
228 		personalFactorLedger_[_customerAddress] = constantFactor / globalFactor;
229         // Execute the bet and return the outcome
230         resultNum = bet(betEth, _customerAddress);
231     }
232 
233 
234     function betPool(address _customerAddress)
235         public
236         view
237         returns (uint256)
238     {
239         // Balance of contract, minus eth balance of user and accrued dev fees
240         return this.balance.sub(ethBalanceOf(_customerAddress)).sub(devFeeBalance);
241     }
242 
243     /*
244         panicButton and refundUser are here incase of an emergency, or launch of a new contract
245         The game will be frozen, and all token holders will be refunded
246     */
247 
248     function panicButton(bool newStatus)
249         public
250         onlyAdmin
251     {
252         gamePaused = newStatus;
253     }
254 
255 
256     function refundUser(address _customerAddress)
257         public
258         onlyAdmin
259     {
260         uint256 sellEth = ethBalanceOf(_customerAddress);
261         _customerAddress.transfer(sellEth);
262         balanceLedger_[_customerAddress] = 0;
263 		personalFactorLedger_[_customerAddress] = constantFactor / globalFactor;
264         onTokenSell(_customerAddress, sellEth, this.balance, now);
265     }
266 
267     function getDevBalance()
268         public
269         view
270         returns (uint256)
271     {
272         return devFeeBalance;
273     }
274 
275 
276     function withdrawDevFees()
277         public
278         onlyAdmin
279     {
280         admin.transfer(devFeeBalance);
281         devFeeBalance = 0;
282     }
283 
284 
285     // Internal Functions
286 
287 
288     function bet(uint256 initEth, address _customerAddress)
289         internal
290         returns (uint256 resultNum)
291     {
292         // Spin the wheel
293         resultNum = random(80);
294         // Determine the outcome
295         uint result = determinePrize(resultNum);
296 
297         // Add 2% fee to devFeeBalance and remove from user's balance
298         uint256 devFee = initEth / 50;
299         devFeeBalance = devFeeBalance.add(devFee);
300         balanceLedger_[_customerAddress] = ethBalanceOf(_customerAddress).sub(devFee);
301         personalFactorLedger_[_customerAddress] = constantFactor / globalFactor;
302 
303         // Remove the dev fee from the bet amount
304         uint256 betEth = initEth - devFee;
305 
306         uint256 returnedEth;
307         uint256 prizePool = betPool(_customerAddress);
308 
309 		if (result < 5)                                             // < 5 = WIN
310 		{
311 			uint256 wonEth;
312 			if (result == 0){                                       // Grand Jackpot
313 				wonEth = grandJackpot(betEth, prizePool);
314 			} else if (result == 1){                                // Jackpot
315 				wonEth = jackpot(betEth, prizePool);
316 			} else if (result == 2){                                // Grand Prize
317 				wonEth = betEth / 2;                                // +50% of original bet
318 			} else if (result == 3){                                // Major Prize
319 				wonEth = betEth / 4;                                // +25% of original bet
320 			} else if (result == 4){                                // Minor Prize
321 				wonEth = betEth / 10;                               // +10% of original bet
322 			}
323 			winEth(_customerAddress, wonEth);                       // Award the user their prize
324             returnedEth = betEth.add(wonEth);
325         } else if (result == 5){                                    // 5 = Refund
326             returnedEth = betEth;
327 		}
328 		else {                                                      // > 5 = LOSE
329 			uint256 lostEth;
330 			if (result == 6){                                		// Minor Loss
331 				lostEth = betEth / 4;                    		    // -25% of original bet
332 			} else if (result == 7){                                // Major Loss
333 				lostEth = betEth / 2;                     			// -50% of original bet
334 			} else if (result == 8){                                // Grand Loss
335 				lostEth = betEth.mul(3) / 4;                     	// -75% of original bet
336 			} else if (result == 9){                                // Total Loss
337 				lostEth = betEth;                                   // -100% of original bet
338 			}
339 			loseEth(_customerAddress, lostEth);                     // "Award" the user their loss
340             returnedEth = betEth.sub(lostEth);
341 		}
342         spinResult(_customerAddress, resultNum, result, betEth, returnedEth, devFee, now);
343         return resultNum;
344     }
345 
346     function grandJackpot(uint256 betEth, uint256 prizePool)
347         internal
348         returns (uint256 wonEth)
349     {
350         wonEth = betEth / 2;                                        // +50% of original bet
351         uint256 max = minBet * 100 * betEth / prizePool;            // Fire the loop a maximum of 100 times
352 		for (uint256 i=0;i<max; i+= minBet) {			  	        // Add a % of the remaining Token Pool
353             wonEth = wonEth.add((prizePool.sub(wonEth)) / 50);      // +2% of remaining pool
354 		}
355     }
356 
357     function jackpot(uint256 betEth, uint256 prizePool)
358         internal
359         returns (uint256 wonEth)
360     {
361         wonEth = betEth / 2;                                        // +50% of original bet
362         uint256 max = minBet * 100 * betEth / prizePool;            // Fire the loop a maximum of 100 times
363 		for (uint256 i=0;i<max; i+= minBet) {                       // Add a % of the remaining Token Pool
364             wonEth = wonEth.add((prizePool.sub(wonEth)) / 100);     // +1% of remaining pool
365 		}
366     }
367 
368     function maxRandom()
369         internal
370         returns (uint256 randomNumber)
371     {
372         _seed = uint256(keccak256(
373             abi.encodePacked(_seed,
374                 blockhash(block.number - 1),
375                 block.coinbase,
376                 block.difficulty)
377         ));
378         return _seed;
379     }
380 
381 
382     function random(uint256 upper)
383         internal
384         returns (uint256 randomNumber)
385     {
386         return maxRandom() % upper + 1;
387     }
388 
389 
390     function determinePrize(uint256 result)
391         internal
392         returns (uint256 resultNum)
393     {
394         // Loop until the result bracket is determined
395         for (uint8 i=0;i<=9;i++){
396             if (result <= brackets[i]){
397                 return i;
398             }
399         }
400     }
401 
402 
403     function loseEth(address _customerAddress, uint256 lostEth)
404         internal
405     {
406         uint256 customerEth = ethBalanceOf(_customerAddress);
407         // Increase amount of eth everyone else owns
408         uint256 globalIncrease = globalFactor.mul(lostEth) / betPool(_customerAddress);
409         globalFactor = globalFactor.add(globalIncrease);
410         // Update user ledgers
411         personalFactorLedger_[_customerAddress] = constantFactor / globalFactor;
412         balanceLedger_[_customerAddress] = customerEth.sub(lostEth);
413     }
414 
415 
416     function winEth(address _customerAddress, uint256 wonEth)
417         internal
418     {
419         uint256 customerEth = ethBalanceOf(_customerAddress);
420         // Decrease amount of eth everyone else owns
421         uint256 globalDecrease = globalFactor.mul(wonEth) / betPool(_customerAddress);
422         globalFactor = globalFactor.sub(globalDecrease);
423         // Update user ledgers
424         personalFactorLedger_[_customerAddress] = constantFactor / globalFactor;
425         balanceLedger_[_customerAddress] = customerEth.add(wonEth);
426     }
427 }
428 
429 /**
430  * @title SafeMath
431  * @dev Math operations with safety checks that throw on error
432  */
433 library SafeMath {
434 
435     /**
436     * @dev Multiplies two numbers, throws on overflow.
437     */
438     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
439         if (a == 0) {
440           return 0;
441         }
442         c = a * b;
443         assert(c / a == b);
444         return c;
445     }
446 
447     /**
448     * @dev Integer division of two numbers, truncating the quotient.
449     */
450     function div(uint256 a, uint256 b) internal pure returns (uint256) {
451         // assert(b > 0); // Solidity automatically throws when dividing by 0
452         // uint256 c = a / b;
453         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
454         return a / b;
455     }
456 
457     /**
458     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
459     */
460     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
461         assert(b <= a);
462         return a - b;
463     }
464 
465     /**
466     * @dev Adds two numbers, throws on overflow.
467     */
468     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
469         c = a + b;
470         assert(c >= a);
471         return c;
472     }
473 }