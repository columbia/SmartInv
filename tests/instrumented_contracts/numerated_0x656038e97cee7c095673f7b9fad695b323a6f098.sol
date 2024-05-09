1 pragma solidity ^0.4.24;
2 
3 /**
4 __          ___               _          __    ___       ____  _ _            _
5 \ \        / / |             | |        / _|  / _ \     |  _ \(_) |          (_)
6  \ \  /\  / /| |__   ___  ___| |   ___ | |_  | | | |_  _| |_) |_| |_ ___ ___  _ _ __
7   \ \/  \/ / | '_ \ / _ \/ _ \ |  / _ \|  _| | | | \ \/ /  _ <| | __/ __/ _ \| | '_ \
8    \  /\  /  | | | |  __/  __/ | | (_) | |   | |_| |>  <| |_) | | || (_| (_) | | | | |
9     \/  \/   |_| |_|\___|\___|_|  \___/|_|    \___//_/\_\____/|_|\__\___\___/|_|_| |_|
10 
11                                   `.-::::::::::::-.`
12                            .:::+:-.`            `.-:+:::.
13                       `::::.   `-                  -`   .:::-`
14                    .:::`        :         J        :        `:::.
15                 `:/-            `-        A       -`            -/:`
16               ./:`               :        C      `:               `:/.
17             .+:                   :       K      :                  `:+.
18           `/-`..`                 -`      P     `-                 `..`-/`
19          :/`    ..`                :      O     :                `..    `/:
20        `+.        ..`              -`     T    `-              `..        .+`
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
32  s                           s  /`       0xB      `/  s                           s
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
61 ---0xBitcoin Specialist---
62 Mr Fahrenheit
63 
64 ---Contract Auditor---
65 8 ฿ł₮ ₮Ɽł₱
66 
67 ---Contract Advisors---
68 Etherguy
69 Norsefire
70 
71 **/
72 
73 contract ERC20Interface
74 {
75     function totalSupply() public constant returns (uint);
76     function balanceOf(address tokenOwner) public constant returns (uint balance);
77     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
78     function transfer(address to, uint tokens) public returns (bool success);
79     function approve(address spender, uint tokens) public returns (bool success);
80     function transferFrom(address from, address to, uint tokens) public returns (bool success);
81 
82     event Transfer(address indexed from, address indexed to, uint tokens);
83     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
84 }
85 
86 contract WheelOf0xBitcoin {
87     using SafeMath for uint;
88 
89     //  Modifiers
90 
91     modifier nonContract() {                // contracts pls go
92         require(tx.origin == msg.sender);
93         _;
94     }
95 
96     modifier gameActive() {
97         require(gamePaused == false);
98         _;
99     }
100 
101     modifier onlyAdmin(){
102         require(msg.sender == admin);
103         _;
104     }
105 
106     // Events
107 
108     event onDeposit(
109         address indexed customerAddress,
110         uint256 tokensIn,
111         uint256 contractBal,
112         uint256 devFee,
113         uint timestamp
114     );
115 
116     event onWithdraw(
117         address indexed customerAddress,
118         uint256 tokensOut,
119         uint256 contractBal,
120         uint timestamp
121     );
122 
123     event spinResult(
124         address indexed customerAddress,
125         uint256 wheelNumber,
126         uint256 outcome,
127         uint256 tokensSpent,
128         uint256 tokensReturned,
129         uint256 userBalance,
130         uint timestamp
131     );
132 
133     uint256 _seed;
134     address admin;
135     bool public gamePaused = false;
136     uint256 minBet = 100000000;
137     uint256 maxBet = 500000000000;
138     uint256 devFeeBalance = 0;
139 
140     uint8[10] brackets = [1,3,6,12,24,40,56,68,76,80];
141 
142     struct playerSpin {
143         uint256 betAmount;
144         uint48 blockNum;
145     }
146 
147     mapping(address => playerSpin) public playerSpins;
148     mapping(address => uint256) internal personalFactorLedger_;
149     mapping(address => uint256) internal balanceLedger_;
150 
151     uint256 internal globalFactor = 10e21;
152     uint256 constant internal constantFactor = 10e21 * 10e21;
153     address public tokenAddress = 0xB6eD7644C69416d67B522e20bC294A9a9B405B31;
154 
155     constructor()
156         public
157     {
158         admin = msg.sender;
159     }
160 
161 
162     function getBalance()
163         public
164         view
165         returns (uint256)
166     {
167         return ERC20Interface(tokenAddress).balanceOf(this);
168     }
169 
170 
171     //deposit needs approval from token contract
172     function deposit(address _customerAddress, uint256 amount)
173         public
174         gameActive
175     {
176         require(tx.origin == _customerAddress);
177         require(amount >= (minBet * 2));
178         require(ERC20Interface(tokenAddress).transferFrom(_customerAddress, this, amount), "token transfer failed");
179         // Add 4% fee of the buy to devFeeBalance
180         uint256 devFee = amount / 33;
181         devFeeBalance = devFeeBalance.add(devFee);
182         // Adjust ledgers while taking the dev fee into account
183         balanceLedger_[_customerAddress] = tokenBalanceOf(_customerAddress).add(amount).sub(devFee);
184         personalFactorLedger_[_customerAddress] = constantFactor / globalFactor;
185 
186         emit onDeposit(_customerAddress, amount, getBalance(), devFee, now);
187     }
188 
189 
190     function receiveApproval(address receiveFrom, uint256 amount, address tknaddr, bytes data)
191       public
192     {
193         if (uint(data[0]) == 0) {
194           deposit(receiveFrom, amount);
195         } else {
196           depositAndSpin(receiveFrom, amount);
197         }
198     }
199 
200 
201     //withdraw from contract
202     function withdraw(uint256 amount)
203       public
204     {
205         address _customerAddress = msg.sender;
206         require(amount <= tokenBalanceOf(_customerAddress));
207         require(amount > 0);
208         if(!ERC20Interface(tokenAddress).transfer(_customerAddress, amount))
209             revert();
210         balanceLedger_[_customerAddress] = tokenBalanceOf(_customerAddress).sub(amount);
211         personalFactorLedger_[_customerAddress] = constantFactor / globalFactor;
212         emit onWithdraw(_customerAddress, amount, getBalance(), now);
213     }
214 
215 
216     function withdrawAll()
217         public
218     {
219         address _customerAddress = msg.sender;
220         // Set the sell amount to the user's full balance, don't sell if empty
221         uint256 amount = tokenBalanceOf(_customerAddress);
222         require(amount > 0);
223         // Transfer balance and update user ledgers
224         if(!ERC20Interface(tokenAddress).transfer(_customerAddress, amount))
225             revert();
226         balanceLedger_[_customerAddress] = 0;
227         personalFactorLedger_[_customerAddress] = constantFactor / globalFactor;
228         emit onWithdraw(_customerAddress, amount, getBalance(), now);
229     }
230 
231 
232     function tokenBalanceOf(address _customerAddress)
233         public
234         view
235         returns (uint256)
236     {
237         // Balance ledger * personal factor * globalFactor / constantFactor
238         return balanceLedger_[_customerAddress].mul(personalFactorLedger_[_customerAddress]).mul(globalFactor) / constantFactor;
239     }
240 
241 
242     function spinTokens(uint256 betAmount)
243         public
244         nonContract
245         gameActive
246     {
247         address _customerAddress = msg.sender;
248         // User must have enough eth
249         require(tokenBalanceOf(_customerAddress) >= betAmount);
250         // User must bet at least the minimum
251         require(betAmount >= minBet);
252         // If the user bets more than maximum...they just bet the maximum
253         if (betAmount > maxBet){
254             betAmount = maxBet;
255         }
256         // User cannot bet more than 10% of available pool
257         if (betAmount > betPool(_customerAddress)/10) {
258             betAmount = betPool(_customerAddress)/10;
259         }
260         // Execute the bet and return the outcome
261         startSpin(betAmount, _customerAddress);
262     }
263 
264 
265     function spinAll()
266         public
267         nonContract
268         gameActive
269     {
270         address _customerAddress = msg.sender;
271         // set the bet amount to the user's full balance
272         uint256 betAmount = tokenBalanceOf(_customerAddress);
273         // User cannot bet more than 10% of available pool
274         if (betAmount > betPool(_customerAddress)/10) {
275             betAmount = betPool(_customerAddress)/10;
276         }
277         // User must bet more than the minimum
278         require(betAmount >= minBet);
279         // If the user bets more than maximum...they just bet the maximum
280         if (betAmount >= maxBet){
281             betAmount = maxBet;
282         }
283         // Execute the bet and return the outcome
284         startSpin(betAmount, _customerAddress);
285     }
286 
287 
288     //deposit needs approval from token contract
289     function depositAndSpin(address _customerAddress, uint256 betAmount)
290         public
291         gameActive
292     {
293         require(tx.origin == _customerAddress);
294         require(betAmount >= (minBet * 2));
295         require(ERC20Interface(tokenAddress).transferFrom(_customerAddress, this, betAmount), "token transfer failed");
296         // Add 4% fee of the buy to devFeeBalance
297         uint256 devFee = betAmount / 33;
298         devFeeBalance = devFeeBalance.add(devFee);
299         // Adjust ledgers while taking the dev fee into account
300         balanceLedger_[_customerAddress] = tokenBalanceOf(_customerAddress).add(betAmount).sub(devFee);
301         personalFactorLedger_[_customerAddress] = constantFactor / globalFactor;
302 
303         emit onDeposit(_customerAddress, betAmount, getBalance(), devFee, now);
304 
305         betAmount = betAmount.sub(devFee);
306         // If the user bets more than maximum...they just bet the maximum
307         if (betAmount >= maxBet){
308             betAmount = maxBet;
309         }
310         // User cannot bet more than 10% of available pool
311         if (betAmount > betPool(_customerAddress)/10) {
312             betAmount = betPool(_customerAddress)/10;
313         }
314         // Execute the bet while taking the dev fee into account, and return the outcome
315         startSpin(betAmount, _customerAddress);
316     }
317 
318 
319     function betPool(address _customerAddress)
320         public
321         view
322         returns (uint256)
323     {
324         // Balance of contract, minus eth balance of user and accrued dev fees
325         return getBalance().sub(tokenBalanceOf(_customerAddress)).sub(devFeeBalance);
326     }
327 
328     /*
329         panicButton and refundUser are here incase of an emergency, or launch of a new contract
330         The game will be frozen, and all token holders will be refunded
331     */
332 
333     function panicButton(bool newStatus)
334         public
335         onlyAdmin
336     {
337         gamePaused = newStatus;
338     }
339 
340 
341     function refundUser(address _customerAddress)
342         public
343         onlyAdmin
344     {
345         uint256 withdrawAmount = tokenBalanceOf(_customerAddress);
346         if(!ERC20Interface(tokenAddress).transfer(_customerAddress, withdrawAmount))
347             revert();
348         balanceLedger_[_customerAddress] = 0;
349 	      personalFactorLedger_[_customerAddress] = constantFactor / globalFactor;
350         emit onWithdraw(_customerAddress, withdrawAmount, getBalance(), now);
351     }
352 
353 
354     function updateMinBet(uint256 newMin)
355         public
356         onlyAdmin
357     {
358         require(newMin > 0);
359         minBet = newMin;
360     }
361 
362 
363     function updateMaxBet(uint256 newMax)
364         public
365         onlyAdmin
366     {
367         require(newMax > 0);
368         maxBet = newMax;
369     }
370 
371 
372     function getDevBalance()
373         public
374         view
375         returns (uint256)
376     {
377         return devFeeBalance;
378     }
379 
380 
381     function withdrawDevFees()
382         public
383     {
384         address fahrenheit = 0x7e7e2bf7EdC52322ee1D251432c248693eCd9E0f;
385         address jormun = 0xf14BE3662FE4c9215c27698166759Db6967De94f;
386         uint256 initDevBal = devFeeBalance;
387         if(!ERC20Interface(tokenAddress).transfer(fahrenheit, devFeeBalance/2))
388           revert();
389         if(!ERC20Interface(tokenAddress).transfer(jormun, devFeeBalance/2))
390           revert();
391         devFeeBalance = devFeeBalance.sub(initDevBal/2);
392         devFeeBalance = devFeeBalance.sub(initDevBal/2);
393     }
394 
395 
396     function finishSpin(address _customerAddress)
397         public
398         returns (uint256)
399     {
400         return _finishSpin(_customerAddress);
401     }
402 
403 
404     // Internal Functions
405 
406 
407     function startSpin(uint256 betAmount, address _customerAddress)
408         internal
409     {
410         playerSpin memory spin = playerSpins[_customerAddress];
411         require(block.number != spin.blockNum);
412 
413         if (spin.blockNum != 0) {
414             _finishSpin(_customerAddress);
415         }
416         lose(_customerAddress, betAmount);
417         playerSpins[_customerAddress] = playerSpin(uint256(betAmount), uint48(block.number));
418     }
419 
420 
421     function _finishSpin(address _customerAddress)
422         internal
423         returns (uint256 resultNum)
424     {
425         playerSpin memory spin = playerSpins[_customerAddress];
426         require(block.number != spin.blockNum);
427 
428         uint result;
429         if (block.number - spin.blockNum > 255) {
430             resultNum = 80;
431             result = 9; // timed out :(
432             return resultNum;
433         } else {
434             resultNum = random(80, spin.blockNum, _customerAddress);
435             result = determinePrize(resultNum);
436         }
437 
438         uint256 betAmount = spin.betAmount;
439         uint256 returnedAmount;
440 
441         if (result < 5)                                             // < 5 = WIN
442         {
443             uint256 wonAmount;
444             if (result == 0){                                       // Grand Jackpot
445                 wonAmount = betAmount.mul(9) / 10;                  // +90% of original bet
446             } else if (result == 1){                                // Jackpot
447                 wonAmount = betAmount.mul(8) / 10;                  // +80% of original bet
448             } else if (result == 2){                                // Grand Prize
449                 wonAmount = betAmount.mul(7) / 10;                  // +70% of original bet
450             } else if (result == 3){                                // Major Prize
451                 wonAmount = betAmount.mul(6) / 10;                  // +60% of original bet
452             } else if (result == 4){                                // Minor Prize
453                 wonAmount = betAmount.mul(3) / 10;                  // +30% of original bet
454             }
455             returnedAmount = betAmount.add(wonAmount);
456         } else if (result == 5){                                    // 5 = Refund
457             returnedAmount = betAmount;
458         } else {                                                    // > 5 = LOSE
459             uint256 lostAmount;
460             if (result == 6){                                	    // Minor Loss
461                 lostAmount = betAmount / 10;                        // -10% of original bet
462             } else if (result == 7){                                // Major Loss
463                 lostAmount = betAmount / 4;                         // -25% of original bet
464             } else if (result == 8){                                // Grand Loss
465                 lostAmount = betAmount / 2;                     	// -50% of original bet
466             } else if (result == 9){                                // Total Loss
467                 lostAmount = betAmount;                             // -100% of original bet
468             }
469             returnedAmount = betAmount.sub(lostAmount);
470         }
471         if (returnedAmount > 0) {
472             win(_customerAddress, returnedAmount);                  // Give user their tokens
473         }
474         uint256 newBal = tokenBalanceOf(_customerAddress);
475         emit spinResult(_customerAddress, resultNum, result, betAmount, returnedAmount, newBal, now);
476 
477         playerSpins[_customerAddress] = playerSpin(uint256(0), uint48(0));
478 
479         return resultNum;
480     }
481 
482 
483     function maxRandom(uint blockn, address entropy)
484         internal
485         returns (uint256 randomNumber)
486     {
487         return uint256(keccak256(
488             abi.encodePacked(
489               blockhash(blockn),
490               entropy)
491         ));
492     }
493 
494 
495     function random(uint256 upper, uint256 blockn, address entropy)
496         internal
497         returns (uint256 randomNumber)
498     {
499         return maxRandom(blockn, entropy) % upper + 1;
500     }
501 
502 
503     function determinePrize(uint256 result)
504         internal
505         returns (uint256 resultNum)
506     {
507         // Loop until the result bracket is determined
508         for (uint8 i=0;i<=9;i++){
509             if (result <= brackets[i]){
510                 return i;
511             }
512         }
513     }
514 
515 
516     function lose(address _customerAddress, uint256 lostAmount)
517         internal
518     {
519         uint256 customerBal = tokenBalanceOf(_customerAddress);
520         // Increase amount of eth everyone else owns
521         uint256 globalIncrease = globalFactor.mul(lostAmount) / betPool(_customerAddress);
522         globalFactor = globalFactor.add(globalIncrease);
523         // Update user ledgers
524         personalFactorLedger_[_customerAddress] = constantFactor / globalFactor;
525         // User can't lose more than they have
526         if (lostAmount > customerBal){
527             lostAmount = customerBal;
528         }
529         balanceLedger_[_customerAddress] = customerBal.sub(lostAmount);
530     }
531 
532 
533     function win(address _customerAddress, uint256 wonAmount)
534         internal
535     {
536         uint256 customerBal = tokenBalanceOf(_customerAddress);
537         // Decrease amount of eth everyone else owns
538         uint256 globalDecrease = globalFactor.mul(wonAmount) / betPool(_customerAddress);
539         globalFactor = globalFactor.sub(globalDecrease);
540         // Update user ledgers
541         personalFactorLedger_[_customerAddress] = constantFactor / globalFactor;
542         balanceLedger_[_customerAddress] = customerBal.add(wonAmount);
543     }
544 }
545 
546 /**
547  * @title SafeMath
548  * @dev Math operations with safety checks that throw on error
549  */
550 library SafeMath {
551 
552     /**
553     * @dev Multiplies two numbers, throws on overflow.
554     */
555     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
556         if (a == 0) {
557           return 0;
558         }
559         c = a * b;
560         assert(c / a == b);
561         return c;
562     }
563 
564     /**
565     * @dev Integer division of two numbers, truncating the quotient.
566     */
567     function div(uint256 a, uint256 b) internal pure returns (uint256) {
568         // assert(b > 0); // Solidity automatically throws when dividing by 0
569         // uint256 c = a / b;
570         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
571         return a / b;
572     }
573 
574     /**
575     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
576     */
577     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
578         assert(b <= a);
579         return a - b;
580     }
581 
582     /**
583     * @dev Adds two numbers, throws on overflow.
584     */
585     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
586         c = a + b;
587         assert(c >= a);
588         return c;
589     }
590 }