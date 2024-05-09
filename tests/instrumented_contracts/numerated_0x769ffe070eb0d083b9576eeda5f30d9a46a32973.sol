1 pragma solidity ^0.4.25;
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
68 TY Guys
69 
70 **/
71 
72 contract WheelOfEther
73 {
74     using SafeMath for uint;
75 
76     // Randomizer contract
77     Randomizer private rand;
78 
79     /**
80      * MODIFIERS
81      */
82     modifier onlyHuman() {
83         require(tx.origin == msg.sender);
84         _;
85     }
86 
87     modifier gameActive() {
88         require(gamePaused == false);
89         _;
90     }
91 
92     modifier onlyAdmin(){
93         require(msg.sender == admin);
94         _;
95     }
96 
97     /**
98      * EVENTS
99      */
100     event onDeposit(
101         address indexed customer,
102         uint256 amount,
103         uint256 balance,
104         uint256 devFee,
105         uint timestamp
106     );
107 
108     event onWithdraw(
109         address indexed customer,
110         uint256 amount,
111         uint256 balance,
112         uint timestamp
113     );
114 
115     event spinResult(
116         address indexed customer,
117         uint256 wheelNumber,
118         uint256 outcome,
119         uint256 betAmount,
120         uint256 returnAmount,
121         uint256 customerBalance,
122         uint timestamp
123     );
124 
125     // Contract admin
126     address public admin;
127     uint256 public devBalance = 0;
128 
129     // Game status
130     bool public gamePaused = false;
131 
132     // Random values
133     uint8 private randMin  = 1;
134     uint8 private randMax  = 80;
135 
136     // Bets limit
137     uint256 public minBet = 0.01 ether;
138     uint256 public maxBet = 10 ether;
139 
140     // Win brackets
141     uint8[10] public brackets = [1,3,6,12,24,40,56,68,76,80];
142 
143     // Factors
144     uint256 private          globalFactor   = 10e21;
145     uint256 constant private constantFactor = 10e21 * 10e21;
146 
147     // Customer balance
148     mapping(address => uint256) private personalFactor;
149     mapping(address => uint256) private personalLedger;
150 
151 
152     /**
153      * Constructor
154      */
155     constructor() public {
156         admin = msg.sender;
157     }
158 
159     /**
160      * Admin methods
161      */
162     function setRandomizer(address _rand) external onlyAdmin {
163         rand = Randomizer(_rand);
164     }
165 
166     function gamePause() external onlyAdmin {
167         gamePaused = true;
168     }
169 
170     function gameUnpause() external onlyAdmin {
171         gamePaused = false;
172     }
173 
174     function refund(address customer) external onlyAdmin {
175         uint256 amount = getBalanceOf(customer);
176         customer.transfer(amount);
177         personalLedger[customer] = 0;
178         personalFactor[customer] = constantFactor / globalFactor;
179         emit onWithdraw(customer, amount, getBalance(), now);
180     }
181 
182     function withdrawDevFees() external onlyAdmin {
183         admin.transfer(devBalance);
184         devBalance = 0;
185     }
186 
187 
188     /**
189      * Get contract balance
190      */
191     function getBalance() public view returns(uint256 balance) {
192         return address(this).balance;
193     }
194 
195     function getBalanceOf(address customer) public view returns(uint256 balance) {
196         return personalLedger[customer].mul(personalFactor[customer]).mul(globalFactor) / constantFactor;
197     }
198 
199     function getBalanceMy() public view returns(uint256 balance) {
200         return getBalanceOf(msg.sender);
201     }
202 
203     function betPool(address customer) public view returns(uint256 value) {
204         return address(this).balance.sub(getBalanceOf(customer)).sub(devBalance);
205     }
206 
207 
208     /**
209      * Deposit/withdrawal
210      */
211     function deposit() public payable onlyHuman gameActive {
212         address customer = msg.sender;
213         require(msg.value >= (minBet * 2));
214 
215         // Add 2% fee of the buy to devBalance
216         uint256 devFee = msg.value / 50;
217         devBalance = devBalance.add(devFee);
218 
219         personalLedger[customer] = getBalanceOf(customer).add(msg.value).sub(devFee);
220         personalFactor[customer] = constantFactor / globalFactor;
221 
222         emit onDeposit(customer, msg.value, getBalance(), devFee, now);
223     }
224 
225     function withdraw(uint256 amount) public onlyHuman {
226         address customer = msg.sender;
227         require(amount > 0);
228         require(amount <= getBalanceOf(customer));
229 
230         customer.transfer(amount);
231         personalLedger[customer] = getBalanceOf(customer).sub(amount);
232         personalFactor[customer] = constantFactor / globalFactor;
233 
234         emit onWithdraw(customer, amount, getBalance(), now);
235     }
236 
237     function withdrawAll() public onlyHuman {
238         withdraw(getBalanceOf(msg.sender));
239     }
240 
241 
242     /**
243      * Spin the wheel methods
244      */
245     function spin(uint256 betAmount) public onlyHuman gameActive returns(uint256 resultNum) {
246         address customer = msg.sender;
247         require(betAmount              >= minBet);
248         require(getBalanceOf(customer) >= betAmount);
249 
250         if (betAmount > maxBet) {
251             betAmount = maxBet;
252         }
253         if (betAmount > betPool(customer) / 10) {
254             betAmount = betPool(customer) / 10;
255         }
256         resultNum = bet(betAmount, customer);
257     }
258 
259     function spinAll() public onlyHuman gameActive returns(uint256 resultNum) {
260         resultNum = spin(getBalanceOf(msg.sender));
261     }
262 
263     function spinDeposit() public payable onlyHuman gameActive returns(uint256 resultNum) {
264         address customer  = msg.sender;
265         uint256 betAmount = msg.value;
266 
267         require(betAmount >= (minBet * 2));
268 
269         // Add 2% fee of the buy to devFeeBalance
270         uint256 devFee = betAmount / 50;
271         devBalance     = devBalance.add(devFee);
272         betAmount      = betAmount.sub(devFee);
273 
274         personalLedger[customer] = getBalanceOf(customer).add(msg.value).sub(devFee);
275         personalFactor[customer] = constantFactor / globalFactor;
276 
277         if (betAmount >= maxBet) {
278             betAmount = maxBet;
279         }
280         if (betAmount > betPool(customer) / 10) {
281             betAmount = betPool(customer) / 10;
282         }
283 
284         resultNum = bet(betAmount, customer);
285     }
286 
287 
288     /**
289      * PRIVATE
290      */
291     function bet(uint256 betAmount, address customer) private returns(uint256 resultNum) {
292         resultNum      = uint256(rand.getRandomNumber(randMin, randMax + randMin));
293         uint256 result = determinePrize(resultNum);
294 
295         uint256 returnAmount;
296 
297         if (result < 5) {                                               // < 5 = WIN
298             uint256 winAmount;
299             if (result == 0) {                                          // Grand Jackpot
300                 winAmount = betAmount.mul(9) / 10;                      // +90% of original bet
301             } else if (result == 1) {                                   // Jackpot
302                 winAmount = betAmount.mul(8) / 10;                      // +80% of original bet
303             } else if (result == 2) {                                   // Grand Prize
304                 winAmount = betAmount.mul(7) / 10;                      // +70% of original bet
305             } else if (result == 3) {                                   // Major Prize
306                 winAmount = betAmount.mul(6) / 10;                      // +60% of original bet
307             } else if (result == 4) {                                   // Minor Prize
308                 winAmount = betAmount.mul(3) / 10;                      // +30% of original bet
309             }
310             weGotAWinner(customer, winAmount);
311             returnAmount = betAmount.add(winAmount);
312         } else if (result == 5) {                                       // 5 = Refund
313             returnAmount = betAmount;
314         } else {                                                        // > 5 = LOSE
315             uint256 lostAmount;
316             if (result == 6) {                                          // Minor Loss
317                 lostAmount = betAmount / 10;                            // -10% of original bet
318             } else if (result == 7) {                                   // Major Loss
319                 lostAmount = betAmount / 4;                             // -25% of original bet
320             } else if (result == 8) {                                   // Grand Loss
321                 lostAmount = betAmount / 2;                             // -50% of original bet
322             } else if (result == 9) {                                   // Total Loss
323                 lostAmount = betAmount;                                 // -100% of original bet
324             }
325             goodLuck(customer, lostAmount);
326             returnAmount = betAmount.sub(lostAmount);
327         }
328 
329         uint256 newBalance = getBalanceOf(customer);
330         emit spinResult(customer, resultNum, result, betAmount, returnAmount, newBalance, now);
331         return resultNum;
332     }
333 
334 
335     function determinePrize(uint256 result) private view returns(uint256 resultNum) {
336         for (uint8 i = 0; i < 10; i++) {
337             if (result <= brackets[i]) {
338                 return i;
339             }
340         }
341     }
342 
343 
344     function goodLuck(address customer, uint256 lostAmount) private {
345         uint256 customerBalance  = getBalanceOf(customer);
346         uint256 globalIncrease   = globalFactor.mul(lostAmount) / betPool(customer);
347         globalFactor             = globalFactor.add(globalIncrease);
348         personalFactor[customer] = constantFactor / globalFactor;
349 
350         if (lostAmount > customerBalance) {
351             lostAmount = customerBalance;
352         }
353         personalLedger[customer] = customerBalance.sub(lostAmount);
354     }
355 
356     function weGotAWinner(address customer, uint256 winAmount) private {
357         uint256 customerBalance  = getBalanceOf(customer);
358         uint256 globalDecrease   = globalFactor.mul(winAmount) / betPool(customer);
359         globalFactor             = globalFactor.sub(globalDecrease);
360         personalFactor[customer] = constantFactor / globalFactor;
361         personalLedger[customer] = customerBalance.add(winAmount);
362     }
363 }
364 
365 
366 /**
367  * @dev Randomizer contract interface
368  */
369 contract Randomizer {
370     function getRandomNumber(int256 min, int256 max) public returns(int256);
371 }
372 
373 
374 /**
375  * @title SafeMath
376  * @dev Math operations with safety checks that throw on error
377  */
378 library SafeMath {
379 
380     /**
381     * @dev Multiplies two numbers, throws on overflow.
382     */
383     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
384         if (a == 0) {
385             return 0;
386         }
387         c = a * b;
388         assert(c / a == b);
389         return c;
390     }
391 
392     /**
393     * @dev Integer division of two numbers, truncating the quotient.
394     */
395     function div(uint256 a, uint256 b) internal pure returns (uint256) {
396         // assert(b > 0); // Solidity automatically throws when dividing by 0
397         // uint256 c = a / b;
398         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
399         return a / b;
400     }
401 
402     /**
403     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
404     */
405     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
406         assert(b <= a);
407         return a - b;
408     }
409 
410     /**
411     * @dev Adds two numbers, throws on overflow.
412     */
413     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
414         c = a + b;
415         assert(c >= a);
416         return c;
417     }
418 }