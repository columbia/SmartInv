1 pragma solidity ^0.4.24;
2 
3 contract Lottery {
4     using SafeMath for uint;
5     using SafeMath for uint8;
6 
7     uint private lotteryBalance;
8     uint private ticketsCount;
9 
10     address[] internal ticketsAddresses;
11     mapping(address => uint) internal tickets;
12 
13     uint constant private DEPOSIT_MULTIPLY = 100 finney; // 0.1 eth
14     uint8 constant internal ITERATION_LIMIT = 150;
15     uint8 private generatorOffset = 0;
16     uint private randomNumber = 0;
17 
18     Utils.winner private lastWinner;
19 
20     function addLotteryParticipant(address addr, uint depositAmount) internal {
21         if (depositAmount >= DEPOSIT_MULTIPLY) {
22             uint investorTicketCount = depositAmount.div(DEPOSIT_MULTIPLY);
23             ticketsCount = ticketsCount.add(investorTicketCount);
24             ticketsAddresses.push(addr);
25             tickets[addr] = tickets[addr].add(investorTicketCount);
26         }
27     }
28 
29     function getLotteryBalance() public view returns(uint) {
30 
31         return lotteryBalance;
32     }
33 
34     function increaseLotteryBalance(uint value) internal {
35 
36         lotteryBalance = lotteryBalance.add(value);
37     }
38 
39     function resetLotteryBalance() internal {
40 
41         ticketsCount = 0;
42         lotteryBalance = 0;
43     }
44 
45     function setLastWinner(address addr, uint balance, uint prize, uint date) internal {
46         lastWinner.addr = addr;
47         lastWinner.balance = balance;
48         lastWinner.prize = prize;
49         lastWinner.date = date;
50     }
51 
52     function getLastWinner() public view returns(address, uint, uint, uint) {
53         return (lastWinner.addr, lastWinner.balance, lastWinner.prize, lastWinner.date);
54     }
55 
56     function getRandomLotteryTicket() internal returns(address) {
57         address addr;
58         if (randomNumber != 0)
59             randomNumber = random(ticketsCount);
60         uint edge = 0;
61         for (uint8 key = generatorOffset; key < ticketsAddresses.length && key < ITERATION_LIMIT; key++) {
62             addr = ticketsAddresses[key];
63             edge = edge.add(tickets[addr]);
64             if (randomNumber <= edge) {
65                 randomNumber = 0;
66                 generatorOffset = 0;
67                 return addr;
68             }
69         }
70         generatorOffset = key;
71         return 0;
72     }
73 
74     function random(uint max) private view returns (uint) {
75         return uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % max + 1;
76     }
77 }
78 
79 contract Stellar {
80     using SafeMath for uint;
81 
82     uint private stellarInvestorBalance;
83 
84     struct stellar {
85         address addr;
86         uint balance;
87     }
88 
89     stellar private stellarInvestor;
90 
91     Utils.winner private lastStellar;
92 
93     event NewStellar(address addr, uint balance);
94 
95     function checkForNewStellar(address addr, uint balance) internal {
96         if (balance > stellarInvestor.balance) {
97             stellarInvestor = stellar(addr, balance);
98             emit NewStellar(addr, balance);
99         }
100     }
101 
102     function getStellarInvestor() public view returns(address, uint) {
103 
104         return (stellarInvestor.addr, stellarInvestor.balance);
105     }
106 
107     function getStellarBalance() public view returns(uint) {
108 
109         return stellarInvestorBalance;
110     }
111 
112     function increaseStellarBalance(uint value) internal {
113 
114         stellarInvestorBalance = stellarInvestorBalance.add(value);
115     }
116 
117     function resetStellarBalance() internal {
118         stellarInvestorBalance = 0;
119     }
120 
121     function resetStellarInvestor() internal {
122         stellarInvestor.addr = 0;
123         stellarInvestor.balance = 0;
124     }
125 
126     function setLastStellar(address addr, uint balance, uint prize, uint date) internal {
127         lastStellar.addr = addr;
128         lastStellar.balance = balance;
129         lastStellar.prize = prize;
130         lastStellar.date = date;
131     }
132 
133     function getLastStellar() public view returns(address, uint, uint, uint) {
134         return (lastStellar.addr, lastStellar.balance, lastStellar.prize, lastStellar.date);
135     }
136 }
137 
138 contract Star is Lottery, Stellar {
139 
140     using Math for Math.percent;
141     using SafeMath for uint;
142 
143     uint constant private MIN_DEPOSIT = 10 finney; // 0.01 eth
144     uint constant private PAYOUT_INTERVAL = 23 hours;
145     uint constant private WITHDRAW_INTERVAL = 12 hours;
146     uint constant private PAYOUT_TRANSACTION_LIMIT = 100;
147 
148     Math.percent private DAILY_PERCENT =  Math.percent(35, 10); // Math.percent(35, 10) = 35 / 10 = 3.5%
149     Math.percent private FEE_PERCENT = Math.percent(18, 1);
150     Math.percent private LOTTERY_PERCENT = Math.percent(1, 1);
151     Math.percent private STELLAR_INVESTOR_PERCENT = Math.percent(1, 1);
152 
153     address internal owner;
154 
155     uint8 cycle;
156 
157     address[] internal addresses;
158 
159     uint internal investorCount;
160     uint internal lastPayoutDate;
161     uint internal lastDepositDate;
162 
163     bool public isCycleFinish = false;
164 
165     struct investor {
166         uint id;
167         uint balance;
168         uint depositCount;
169         uint lastDepositDate;
170     }
171 
172     mapping(address => investor) internal investors;
173 
174     event Invest(address addr, uint amount);
175     event InvestorPayout(address addr, uint amount, uint date);
176     event Payout(uint amount, uint transactionCount, uint date);
177     event Withdraw(address addr, uint amount);
178     event NextCycle(uint8 cycle, uint now, uint);
179 
180     modifier onlyOwner() {
181         require(msg.sender == owner);
182         _;
183     }
184 
185     constructor() public {
186         owner = msg.sender;
187         addresses.length = 1;
188     }
189 
190     function() payable public {
191         require(isCycleFinish == false, "Cycle completed. The new cycle will start within 24 hours.");
192 
193         if (msg.value == 0) {
194             withdraw(msg.sender);
195             return;
196         }
197 
198         deposit(msg.sender, msg.value);
199     }
200 
201     function restartCycle() public onlyOwner returns(bool) {
202         if (isCycleFinish == true) {
203             newCycle();
204             return false;
205         }
206         return true;
207     }
208 
209     function payout(uint startPosition) public onlyOwner {
210 
211         require(isCycleFinish == false, "Cycle completed. The new cycle will start within 24 hours.");
212 
213         uint transactionCount;
214         uint investorsPayout;
215         uint dividendsAmount;
216 
217         if (startPosition == 0)
218             startPosition = 1;
219 
220         for (uint key = startPosition; key <= investorCount && transactionCount < PAYOUT_TRANSACTION_LIMIT; key++) {
221             address addr = addresses[key];
222             if (investors[addr].lastDepositDate + PAYOUT_INTERVAL > now) {
223                 continue;
224             }
225 
226             dividendsAmount = getInvestorDividends(addr);
227 
228             if (address(this).balance < dividendsAmount) {
229                 isCycleFinish = true;
230                 return;
231             }
232 
233             addr.transfer(dividendsAmount);
234             emit InvestorPayout(addr, dividendsAmount, now);
235             investors[addr].lastDepositDate = now;
236 
237             investorsPayout = investorsPayout.add(dividendsAmount);
238 
239             transactionCount++;
240         }
241 
242         lastPayoutDate = now;
243         emit Payout(investorsPayout, transactionCount, lastPayoutDate);
244     }
245 
246     function deposit(address addr, uint amount) internal {
247         require(amount >= MIN_DEPOSIT, "Too small amount, minimum 0.01 eth");
248 
249         investor storage user = investors[addr];
250 
251         if (user.id == 0) {
252             user.id = addresses.length;
253             addresses.push(addr);
254             investorCount ++;
255         }
256 
257         uint depositFee = FEE_PERCENT.getPercentFrom(amount);
258 
259         increaseLotteryBalance(LOTTERY_PERCENT.getPercentFrom(amount));
260         increaseStellarBalance(STELLAR_INVESTOR_PERCENT.getPercentFrom(amount));
261 
262         addLotteryParticipant(addr, amount);
263 
264         user.balance = user.balance.add(amount);
265         user.depositCount ++;
266         user.lastDepositDate = now;
267         lastDepositDate = now;
268 
269         checkForNewStellar(addr, user.balance);
270 
271         emit Invest(msg.sender, msg.value);
272 
273         owner.transfer(depositFee);
274     }
275 
276     function withdraw(address addr) internal {
277         require(isCycleFinish == false, "Cycle completed. The new cycle will start within 24 hours.");
278 
279         investor storage user = investors[addr];
280         require(user.id > 0, "Account not found");
281 
282         require(now.sub(user.lastDepositDate).div(WITHDRAW_INTERVAL) > 0, "The latest payment was earlier than 12 hours");
283 
284         uint dividendsAmount = getInvestorDividends(addr);
285 
286         if (address(this).balance < dividendsAmount) {
287             isCycleFinish = true;
288             return;
289         }
290 
291         addr.transfer(dividendsAmount);
292         user.lastDepositDate = now;
293 
294         emit Withdraw(addr, dividendsAmount);
295     }
296 
297     function runLottery() public onlyOwner returns(bool) {
298         return processLotteryReward();
299     }
300 
301     function processLotteryReward() private returns(bool) {
302         if (getLotteryBalance() > 0) {
303             address winnerAddress = getRandomLotteryTicket();
304             if (winnerAddress == 0)
305                 return false;
306             winnerAddress.transfer(getLotteryBalance());
307             setLastWinner(winnerAddress, investors[winnerAddress].balance, getLotteryBalance(), now);
308             resetLotteryBalance();
309             return true;
310         }
311 
312         return false;
313     }
314 
315     function giveStellarReward() public onlyOwner {
316         processStellarReward();
317     }
318 
319     function processStellarReward() private {
320         uint balance = getStellarBalance();
321         if (balance > 0) {
322             (address addr, uint investorBalance) = getStellarInvestor();
323             addr.transfer(balance);
324             setLastStellar(addr, investors[addr].balance, getStellarBalance(), now);
325             resetStellarBalance();
326         }
327     }
328 
329     function getInvestorCount() public view returns (uint) {
330 
331         return investorCount;
332     }
333 
334     function getBalance() public view returns (uint) {
335 
336         return address(this).balance;
337     }
338 
339     function getLastPayoutDate() public view returns (uint) {
340 
341         return lastPayoutDate;
342     }
343 
344     function getLastDepositDate() public view returns (uint) {
345 
346         return lastDepositDate;
347     }
348 
349     function getInvestorDividends(address addr) public view returns(uint) {
350         uint amountPerDay = DAILY_PERCENT.getPercentFrom(investors[addr].balance);
351         uint timeLapse = now.sub(investors[addr].lastDepositDate);
352 
353         return amountPerDay.mul(timeLapse).div(1 days);
354     }
355 
356     function getInvestorBalance(address addr) public view returns(uint) {
357 
358         return investors[addr].balance;
359     }
360 
361     function getInvestorInfo(address addr) public onlyOwner view returns(uint, uint, uint, uint) {
362 
363         return (
364             investors[addr].id,
365             investors[addr].balance,
366             investors[addr].depositCount,
367             investors[addr].lastDepositDate
368         );
369     }
370 
371     function newCycle() private {
372         address addr;
373         uint8 iteration;
374         uint i;
375 
376         for (i = addresses.length - 1; i > 0; i--) {
377             addr = addresses[i];
378             addresses.length -= 1;
379             delete investors[addr];
380             iteration++;
381             if (iteration >= ITERATION_LIMIT) {
382                 return;
383             }
384         }
385 
386         for (i = ticketsAddresses.length - 1; i > 0; i--) {
387             addr = ticketsAddresses[i];
388             ticketsAddresses.length -= 1;
389             delete tickets[addr];
390             iteration++;
391             if (iteration >= ITERATION_LIMIT) {
392                 return;
393             }
394         }
395 
396         emit NextCycle(cycle, now, getBalance());
397 
398         cycle++;
399         investorCount = 0;
400         lastPayoutDate = now;
401         lastDepositDate = now;
402         isCycleFinish = false;
403 
404         resetLotteryBalance();
405         resetStellarBalance();
406         resetStellarInvestor();
407     }
408 
409 }
410 
411 /**
412  * @title SafeMath
413  * @dev Math operations with safety checks that revert on error
414  */
415 library SafeMath {
416 
417     /**
418     * @dev Multiplies two numbers, reverts on overflow.
419     */
420     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
421         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
422         // benefit is lost if 'b' is also tested.
423         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
424         if (a == 0) {
425             return 0;
426         }
427 
428         uint256 c = a * b;
429         require(c / a == b);
430 
431         return c;
432     }
433 
434     /**
435     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
436     */
437     function div(uint256 a, uint256 b) internal pure returns (uint256) {
438         require(b > 0); // Solidity only automatically asserts when dividing by 0
439         uint256 c = a / b;
440         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
441 
442         return c;
443     }
444 
445     /**
446     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
447     */
448     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
449         require(b <= a);
450         uint256 c = a - b;
451 
452         return c;
453     }
454 
455     /**
456     * @dev Adds two numbers, reverts on overflow.
457     */
458     function add(uint256 a, uint256 b) internal pure returns (uint256) {
459         uint256 c = a + b;
460         require(c >= a);
461 
462         return c;
463     }
464 
465     /**
466     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
467     * reverts when dividing by zero.
468     */
469     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
470         require(b != 0);
471         return a % b;
472     }
473 }
474 
475 library Math {
476 
477     struct percent {
478         uint percent;
479         uint base;
480     }
481 
482     function getPercentFrom(percent storage p, uint value) internal view returns (uint) {
483         return value * p.percent / p.base / 100;
484     }
485 
486 }
487 
488 library Utils {
489 
490     struct winner {
491         address addr;
492         uint balance;
493         uint prize;
494         uint date;
495     }
496 
497 }