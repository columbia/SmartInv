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
96         uint256 devFee,
97         uint timestamp
98     );
99 
100     event onTokenSell(
101         address indexed customerAddress,
102         uint256 ethereumOut,
103         uint256 contractBal,
104         uint timestamp
105     );
106 
107     event spinResult(
108         address indexed customerAddress,
109         uint256 wheelNumber,
110         uint256 outcome,
111         uint256 ethSpent,
112         uint256 ethReturned,
113         uint256 userBalance,
114         uint timestamp
115     );
116 
117     uint256 _seed;
118     address admin;
119     bool public gamePaused = false;
120     uint256 minBet = 0.01 ether;
121     uint256 maxBet = 5 ether;
122     uint256 devFeeBalance = 0;
123 
124     uint8[10] brackets = [1,3,6,12,24,40,56,68,76,80];
125 
126     uint256 internal globalFactor = 10e21;
127     uint256 constant internal constantFactor = 10e21 * 10e21;
128     mapping(address => uint256) internal personalFactorLedger_;
129     mapping(address => uint256) internal balanceLedger_;
130 
131 
132     constructor()
133         public
134     {
135         admin = msg.sender;
136     }
137 
138 
139     function getBalance()
140         public
141         view
142         returns (uint256)
143     {
144         return this.balance;
145     }
146 
147 
148     function buyTokens()
149         public
150         payable
151         nonContract
152         gameActive
153     {
154         address _customerAddress = msg.sender;
155         // User must buy at least 0.02 eth
156         require(msg.value >= (minBet * 2));
157 
158         // Add 2% fee of the buy to devFeeBalance
159         uint256 devFee = msg.value / 50;
160         devFeeBalance = devFeeBalance.add(devFee);
161 
162         // Adjust ledgers while taking the dev fee into account
163         balanceLedger_[_customerAddress] = ethBalanceOf(_customerAddress).add(msg.value).sub(devFee);
164         personalFactorLedger_[_customerAddress] = constantFactor / globalFactor;
165 
166         onTokenPurchase(_customerAddress, msg.value, this.balance, devFee, now);
167     }
168 
169 
170     function sell(uint256 sellEth)
171         public
172         nonContract
173     {
174         address _customerAddress = msg.sender;
175         // User must have enough eth and cannot sell 0
176         require(sellEth <= ethBalanceOf(_customerAddress));
177         require(sellEth > 0);
178         // Transfer balance and update user ledgers
179         _customerAddress.transfer(sellEth);
180         balanceLedger_[_customerAddress] = ethBalanceOf(_customerAddress).sub(sellEth);
181 		personalFactorLedger_[_customerAddress] = constantFactor / globalFactor;
182 
183         onTokenSell(_customerAddress, sellEth, this.balance, now);
184     }
185 
186 
187     function sellAll()
188         public
189         nonContract
190     {
191         address _customerAddress = msg.sender;
192         // Set the sell amount to the user's full balance, don't sell if empty
193         uint256 sellEth = ethBalanceOf(_customerAddress);
194         require(sellEth > 0);
195         // Transfer balance and update user ledgers
196         _customerAddress.transfer(sellEth);
197         balanceLedger_[_customerAddress] = 0;
198 		personalFactorLedger_[_customerAddress] = constantFactor / globalFactor;
199 
200         onTokenSell(_customerAddress, sellEth, this.balance, now);
201     }
202 
203 
204     function ethBalanceOf(address _customerAddress)
205         public
206         view
207         returns (uint256)
208     {
209         // Balance ledger * personal factor * globalFactor / constantFactor
210         return balanceLedger_[_customerAddress].mul(personalFactorLedger_[_customerAddress]).mul(globalFactor) / constantFactor;
211     }
212 
213 
214     function tokenSpin(uint256 betEth)
215         public
216         nonContract
217         gameActive
218         returns (uint256 resultNum)
219     {
220         address _customerAddress = msg.sender;
221         // User must have enough eth
222         require(ethBalanceOf(_customerAddress) >= betEth);
223         // User must bet at least the minimum
224         require(betEth >= minBet);
225         // If the user bets more than maximum...they just bet the maximum
226         if (betEth > maxBet){
227             betEth = maxBet;
228         }
229         // User cannot bet more than 10% of available pool
230         if (betEth > betPool(_customerAddress)/10) {
231             betEth = betPool(_customerAddress)/10;
232         }
233         // Execute the bet and return the outcome
234         resultNum = bet(betEth, _customerAddress);
235     }
236 
237 
238     function spinAllTokens()
239         public
240         nonContract
241         gameActive
242         returns (uint256 resultNum)
243     {
244         address _customerAddress = msg.sender;
245         // set the bet amount to the user's full balance
246         uint256 betEth = ethBalanceOf(_customerAddress);
247         // User cannot bet more than 10% of available pool
248         if (betEth > betPool(_customerAddress)/10) {
249             betEth = betPool(_customerAddress)/10;
250         }
251         // User must bet more than the minimum
252         require(betEth >= minBet);
253         // If the user bets more than maximum...they just bet the maximum
254         if (betEth >= maxBet){
255             betEth = maxBet;
256         }
257         // Execute the bet and return the outcome
258         resultNum = bet(betEth, _customerAddress);
259     }
260 
261 
262     function etherSpin()
263         public
264         payable
265         nonContract
266         gameActive
267         returns (uint256 resultNum)
268     {
269         address _customerAddress = msg.sender;
270         uint256 betEth = msg.value;
271 
272         // All eth is converted into tokens before the bet
273         // User must buy at least 0.02 eth
274         require(betEth >= (minBet * 2));
275 
276         // Add 2% fee of the buy to devFeeBalance
277         uint256 devFee = betEth / 50;
278         devFeeBalance = devFeeBalance.add(devFee);
279         betEth = betEth.sub(devFee);
280 
281         // If the user bets more than maximum...they just bet the maximum
282         if (betEth >= maxBet){
283             betEth = maxBet;
284         }
285 
286         // Adjust ledgers while taking the dev fee into account
287         balanceLedger_[_customerAddress] = ethBalanceOf(_customerAddress).add(msg.value).sub(devFee);
288 		personalFactorLedger_[_customerAddress] = constantFactor / globalFactor;
289 
290         // User cannot bet more than 10% of available pool
291         if (betEth > betPool(_customerAddress)/10) {
292             betEth = betPool(_customerAddress)/10;
293         }
294 
295         // Execute the bet while taking the dev fee into account, and return the outcome
296         resultNum = bet(betEth, _customerAddress);
297     }
298 
299 
300     function betPool(address _customerAddress)
301         public
302         view
303         returns (uint256)
304     {
305         // Balance of contract, minus eth balance of user and accrued dev fees
306         return this.balance.sub(ethBalanceOf(_customerAddress)).sub(devFeeBalance);
307     }
308 
309     /*
310         panicButton and refundUser are here incase of an emergency, or launch of a new contract
311         The game will be frozen, and all token holders will be refunded
312     */
313 
314     function panicButton(bool newStatus)
315         public
316         onlyAdmin
317     {
318         gamePaused = newStatus;
319     }
320 
321 
322     function refundUser(address _customerAddress)
323         public
324         onlyAdmin
325     {
326         uint256 sellEth = ethBalanceOf(_customerAddress);
327         _customerAddress.transfer(sellEth);
328         balanceLedger_[_customerAddress] = 0;
329 		personalFactorLedger_[_customerAddress] = constantFactor / globalFactor;
330         onTokenSell(_customerAddress, sellEth, this.balance, now);
331     }
332 
333     function getDevBalance()
334         public
335         view
336         returns (uint256)
337     {
338         return devFeeBalance;
339     }
340 
341 
342     function withdrawDevFees()
343         public
344         onlyAdmin
345     {
346         admin.transfer(devFeeBalance);
347         devFeeBalance = 0;
348     }
349 
350 
351     // Internal Functions
352 
353 
354     function bet(uint256 betEth, address _customerAddress)
355         internal
356         returns (uint256 resultNum)
357     {
358         // Spin the wheel
359         resultNum = random(80);
360         // Determine the outcome
361         uint result = determinePrize(resultNum);
362 
363         uint256 returnedEth;
364 
365 		if (result < 5)                                             // < 5 = WIN
366 		{
367 			uint256 wonEth;
368 			if (result == 0){                                       // Grand Jackpot
369 				wonEth = betEth.mul(9) / 10;                        // +90% of original bet
370 			} else if (result == 1){                                // Jackpot
371 				wonEth = betEth.mul(8) / 10;                        // +80% of original bet
372 			} else if (result == 2){                                // Grand Prize
373 				wonEth = betEth.mul(7) / 10;                        // +70% of original bet
374 			} else if (result == 3){                                // Major Prize
375 				wonEth = betEth.mul(6) / 10;                        // +60% of original bet
376 			} else if (result == 4){                                // Minor Prize
377 				wonEth = betEth.mul(3) / 10;                        // +30% of original bet
378 			}
379 			winEth(_customerAddress, wonEth);                       // Award the user their prize
380             returnedEth = betEth.add(wonEth);
381         } else if (result == 5){                                    // 5 = Refund
382             returnedEth = betEth;
383 		}
384 		else {                                                      // > 5 = LOSE
385 			uint256 lostEth;
386 			if (result == 6){                                		// Minor Loss
387 				lostEth = betEth / 10;                    		    // -10% of original bet
388 			} else if (result == 7){                                // Major Loss
389 				lostEth = betEth / 4;                     			// -25% of original bet
390 			} else if (result == 8){                                // Grand Loss
391 				lostEth = betEth / 2;                     	        // -50% of original bet
392 			} else if (result == 9){                                // Total Loss
393 				lostEth = betEth;                                   // -100% of original bet
394 			}
395 			loseEth(_customerAddress, lostEth);                     // "Award" the user their loss
396             returnedEth = betEth.sub(lostEth);
397 		}
398         uint256 newBal = ethBalanceOf(_customerAddress);
399         spinResult(_customerAddress, resultNum, result, betEth, returnedEth, newBal, now);
400         return resultNum;
401     }
402 
403     function maxRandom()
404         internal
405         returns (uint256 randomNumber)
406     {
407         _seed = uint256(keccak256(
408             abi.encodePacked(_seed,
409                 blockhash(block.number - 1),
410                 block.coinbase,
411                 block.difficulty,
412                 now)
413         ));
414         return _seed;
415     }
416 
417 
418     function random(uint256 upper)
419         internal
420         returns (uint256 randomNumber)
421     {
422         return maxRandom() % upper + 1;
423     }
424 
425 
426     function determinePrize(uint256 result)
427         internal
428         returns (uint256 resultNum)
429     {
430         // Loop until the result bracket is determined
431         for (uint8 i=0;i<=9;i++){
432             if (result <= brackets[i]){
433                 return i;
434             }
435         }
436     }
437 
438 
439     function loseEth(address _customerAddress, uint256 lostEth)
440         internal
441     {
442         uint256 customerEth = ethBalanceOf(_customerAddress);
443         // Increase amount of eth everyone else owns
444         uint256 globalIncrease = globalFactor.mul(lostEth) / betPool(_customerAddress);
445         globalFactor = globalFactor.add(globalIncrease);
446         // Update user ledgers
447         personalFactorLedger_[_customerAddress] = constantFactor / globalFactor;
448         balanceLedger_[_customerAddress] = customerEth.sub(lostEth);
449     }
450 
451 
452     function winEth(address _customerAddress, uint256 wonEth)
453         internal
454     {
455         uint256 customerEth = ethBalanceOf(_customerAddress);
456         // Decrease amount of eth everyone else owns
457         uint256 globalDecrease = globalFactor.mul(wonEth) / betPool(_customerAddress);
458         globalFactor = globalFactor.sub(globalDecrease);
459         // Update user ledgers
460         personalFactorLedger_[_customerAddress] = constantFactor / globalFactor;
461         balanceLedger_[_customerAddress] = customerEth.add(wonEth);
462     }
463 }
464 
465 /**
466  * @title SafeMath
467  * @dev Math operations with safety checks that throw on error
468  */
469 library SafeMath {
470 
471     /**
472     * @dev Multiplies two numbers, throws on overflow.
473     */
474     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
475         if (a == 0) {
476           return 0;
477         }
478         c = a * b;
479         assert(c / a == b);
480         return c;
481     }
482 
483     /**
484     * @dev Integer division of two numbers, truncating the quotient.
485     */
486     function div(uint256 a, uint256 b) internal pure returns (uint256) {
487         // assert(b > 0); // Solidity automatically throws when dividing by 0
488         // uint256 c = a / b;
489         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
490         return a / b;
491     }
492 
493     /**
494     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
495     */
496     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
497         assert(b <= a);
498         return a - b;
499     }
500 
501     /**
502     * @dev Adds two numbers, throws on overflow.
503     */
504     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
505         c = a + b;
506         assert(c >= a);
507         return c;
508     }
509 }