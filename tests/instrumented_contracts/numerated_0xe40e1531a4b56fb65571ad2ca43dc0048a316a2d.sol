1 pragma solidity ^0.5.8;
2 
3 
4 /**
5  * EthPrime - ethprime.io
6  * 
7  * A defi dapp ecosystem which simplifies and automates the process of playing eth dapps/games by bundling them into a "portfolio/fund"
8  * 
9  */
10 
11 
12 contract EthPrime {
13     
14     LoyaltyScheme loyalty = LoyaltyScheme(0x0);
15     UniswapPriceGuard uniswapPriceGuard = UniswapPriceGuard(0x0);
16 
17     Subscription[] public activeSubscriptions;
18     mapping(address => bool) public subscriptionLoanable;
19     
20     mapping(address => address payable[]) public userSubscriptionsList;
21     mapping(address => mapping(address => bool)) public userSubscriptions;
22     mapping(address => Streak) public reinvestStreaks;
23     mapping(address => Approval) public pendingDapps;
24     mapping(address => uint256) public ethLoaned;
25     
26     FundPaymentHandler paymentHandler = FundPaymentHandler(0x4f50cAAEA490A5B939ad291d0567093E89649872);
27     
28     uint256 totalWeighting = 0; // Updates every time subscription is added/removed
29     address payable owner = msg.sender;
30     
31     uint256 fundFee = 10; // 1% on launch, reducing over time
32     uint256 loansFee = 50; // 5% (of earnt divs)
33     uint256 public newDappDelay;
34     
35     uint256 platformFees;
36     uint256 loanDivs;
37     
38     struct Subscription {
39         address payable dapp;
40         uint128 weighting;
41         bool requiresFunds;
42     }
43     
44     struct Approval {
45         address payable dapp;
46         uint128 weighting;
47         uint128 delayTimestamp;
48         bool requiresFunds;
49         bool loanable;
50     }
51     
52     struct Streak {
53         uint128 currentStreak;
54         uint128 lastReinvestWeek;
55     }
56     
57     event Deposit(address player, address ref, uint256 tron);
58     event Cashout(address player, address ref, uint256 tron);
59     event Reinvest(address player, address ref, uint256 tron);
60     event Withdraw(address player, uint256 tron);
61     event Borrow(address player, uint256 tron);
62     event Payback(address player, uint256 tron);
63     
64     function() external payable { }
65     
66     function reduceFundFee(uint256 newFundFee) external {
67         require(msg.sender == owner);
68         require(newFundFee < fundFee);
69         fundFee = newFundFee;
70     }
71     
72     function withdrawPlatformFees(uint256 amount) external {
73         require(msg.sender == owner);
74         require(amount <= platformFees);
75         platformFees -= amount;
76         owner.transfer(amount);
77     }
78     
79     function withdrawLoanDivs(uint256 amount) external {
80         require(msg.sender == owner);
81         require(amount <= loanDivs);
82         loanDivs -= amount;
83         owner.transfer(amount);
84     }
85     
86     function updateDappDelay(uint256 newDelay) external {
87         require(msg.sender == owner);
88         require(newDelay >= 3 days);
89         newDappDelay = newDelay;
90     }
91     
92     function updateLoansFee(uint256 newLoansFee) external {
93         require(msg.sender == owner);
94         require(newLoansFee <= 200); // 20%
95         loansFee = newLoansFee;
96     }
97     
98     function updateLoyaltyContract(address loyaltyAddress) external {
99         require(msg.sender == owner);
100         loyalty = LoyaltyScheme(loyaltyAddress);
101     }
102     
103     function updateUniswapPriceGuard(address guardAddress) external {
104         require(msg.sender == owner);
105         uniswapPriceGuard = UniswapPriceGuard(guardAddress);
106     }
107     
108     function updateLoanable(address dapp, bool loanable) external {
109         require(msg.sender == owner);
110         subscriptionLoanable[dapp] = loanable;
111     }
112     
113     function addSubscription(address dappAddress, uint128 dappWeighting, bool requiresFunds, bool loanable) external {
114         require(msg.sender == owner); 
115         require(dappWeighting > 0);
116         require(dappWeighting < 1000);
117         
118         // If existing then update subscription weighting
119         for (uint256 i = 0; i < activeSubscriptions.length; i++) {
120             Subscription storage existing = activeSubscriptions[i];
121             if (existing.dapp == dappAddress) {
122                 if (dappWeighting > existing.weighting) {
123                     totalWeighting += (dappWeighting - existing.weighting);
124                 } else if (dappWeighting < existing.weighting) {
125                     totalWeighting -= (existing.weighting - dappWeighting);
126                 }
127                 existing.weighting = dappWeighting;
128                 return;
129             }
130         }
131 
132         // Otherwise add new subscription after newDappDelay
133         pendingDapps[dappAddress] = Approval(address(uint160(dappAddress)), dappWeighting, uint128(now + newDappDelay), requiresFunds, loanable);
134     }
135     
136     function addPendingSubscription(address dappAddress) external {
137         require(msg.sender == owner);
138         Approval memory approval = pendingDapps[dappAddress];
139         require(now > approval.delayTimestamp);
140         activeSubscriptions.push(Subscription(approval.dapp, approval.weighting, approval.requiresFunds));
141         subscriptionLoanable[approval.dapp] = approval.loanable;
142         totalWeighting += approval.weighting;
143         delete pendingDapps[dappAddress];
144     }
145     
146     function removeSubscription(address dappAddress) external {
147         require(msg.sender == owner);
148         
149         for (uint256 i = 0; i < activeSubscriptions.length; i++) {
150             Subscription memory existing = activeSubscriptions[i];
151             if (existing.dapp == dappAddress) {
152                 totalWeighting -= existing.weighting;
153                 
154                 // Remove subscription (and shift all subscriptions left one position) 
155                 uint256 length = activeSubscriptions.length - 1;
156                 for (uint j = i; j < length; j++){
157                     activeSubscriptions[j] = activeSubscriptions[j+1]; 
158                 }
159                 activeSubscriptions.length--;
160                 return;
161             }
162         }
163     }
164     
165     function deposit(address referrer, address[] calldata pathPairs, uint256[] calldata minOuts) external payable {
166         require(msg.value > 0.199 ether);
167         require(uniswapPriceGuard.overPriceFloorValue(pathPairs, minOuts));
168         depositInternal(msg.value, msg.sender, referrer, false);
169         emit Deposit(msg.sender, referrer, msg.value);
170     }
171     
172     function depositFor(address player, address referrer, address[] calldata pathPairs, uint256[] calldata minOuts) external payable {
173         require(msg.value > 0.199 ether);
174         require(uniswapPriceGuard.overPriceFloorValue(pathPairs, minOuts));
175         depositInternal(msg.value, player, referrer, false);
176         emit Deposit(player, referrer, msg.value);
177     }
178     
179     function depositInternal(uint256 ethDeposit, address player, address referrer, bool alreadyClaimedDivs) internal {
180         if (now < 1592866800) {
181             player = owner; // Before launch time no-one can deposit
182         } else if (now < 1592867100) {
183             require(ethDeposit <= 50 ether && tx.gasprice <= 0.1 szabo); // For first 5 mins max buy is 50 eth & 100 gwei
184         }
185         
186         if (fundFee > 0) {
187             uint256 fee = (ethDeposit * fundFee) / 1000;
188             ethDeposit -= fee;
189             platformFees += fee;
190         }
191         
192         uint256 subscriptions = activeSubscriptions.length;
193         uint256 remainingWeighting = totalWeighting;
194         for (uint256 i = 0; i < subscriptions; i++) {
195             if (remainingWeighting == 0) {
196                 break;
197             }
198             
199             Subscription memory subscription = activeSubscriptions[i];
200             SubscriptionDapp dapp = SubscriptionDapp(subscription.dapp);
201             uint256 maxDeposit = (ethDeposit * subscription.weighting) / remainingWeighting;
202             
203             uint256 deposited;
204             if (subscription.requiresFunds) {
205                 deposited = maxDeposit;
206             }
207             (bool success, bytes memory returnData) = address(dapp).call.value(deposited)(abi.encodePacked(dapp.deposit.selector, abi.encode(player, maxDeposit, referrer, alreadyClaimedDivs)));
208             
209             if (success) {
210                 deposited = abi.decode(returnData, (uint256));
211             }
212             
213             require(deposited <= maxDeposit);
214             if (deposited > 0) {
215                 ethDeposit -= deposited;
216                 if (!userSubscriptions[player][subscription.dapp]) {
217                     userSubscriptions[player][subscription.dapp] = true;
218                     userSubscriptionsList[player].push(subscription.dapp);
219                 }
220             }
221             remainingWeighting -= subscription.weighting;
222         }
223     }
224     
225     function cashout(address referrer, uint256 percent, address[] calldata pathPairs, uint256[] calldata minOuts) external {
226         require(percent > 0 && percent < 101);
227         require(uniswapPriceGuard.overPriceFloorValue(pathPairs, minOuts));
228         require(ethLoaned[msg.sender] == 0);
229         
230         uint256 ethGained;
231         uint256 length = userSubscriptionsList[msg.sender].length;
232         for (uint256 i = 0; i < length; i++) {
233             SubscriptionDapp dapp = SubscriptionDapp(userSubscriptionsList[msg.sender][i]);
234             (bool success, bytes memory returnData) = address(dapp).call(abi.encodePacked(dapp.cashout.selector, abi.encode(msg.sender, referrer, percent)));
235             if (success) {
236                 ethGained += abi.decode(returnData, (uint256));
237             }
238             
239         }
240         paymentHandler.cashout.value(ethGained)(msg.sender);
241         reinvestStreaks[msg.sender] = Streak(0, weeksSinceEpoch());
242         
243         emit Cashout(msg.sender, referrer, ethGained);
244     }
245     
246     function claimDivs() public {
247         uint256 ethGained = claimDivsInternal(msg.sender);
248         paymentHandler.cashout.value(ethGained)(msg.sender);
249         reinvestStreaks[msg.sender] = Streak(0, weeksSinceEpoch());
250         emit Withdraw(msg.sender, ethGained);
251     }
252     
253     function claimDivsInternal(address player) internal returns (uint256) {
254         uint256 ethGained;
255         uint256 length = userSubscriptionsList[player].length;
256         for (uint256 i = 0; i < length; i++) {
257             SubscriptionDapp dapp = SubscriptionDapp(userSubscriptionsList[player][i]);
258             (bool success, bytes memory returnData) = address(dapp).call(abi.encodePacked(dapp.claimDivs.selector, abi.encode(player)));
259             if (success) {
260                 ethGained += abi.decode(returnData, (uint256));
261             }
262         }
263         
264         if (ethLoaned[player] > 0) {
265             uint256 fee = ethGained * loansFee / 1000;
266             ethGained -= fee;
267             loanDivs += fee;
268         }
269         
270         return ethGained;
271     }
272     
273     function reinvest(address referrer, address[] calldata pathPairs, uint256[] calldata minOuts) external {
274         require(uniswapPriceGuard.overPriceFloorValue(pathPairs, minOuts));
275         reinvestInternal(msg.sender, referrer, 100);
276     }
277     
278     function reinvestInternal(address player, address referrer, uint256 percent) internal {
279         uint256 ethGained = claimDivsInternal(player);
280         uint256 reinvestPortion = (ethGained * percent) / 100;
281         if (percent < 100) {
282             paymentHandler.cashout.value(ethGained - reinvestPortion)(player);
283             emit Withdraw(player, ethGained - reinvestPortion);
284         }
285         paymentHandler.reinvest.value(reinvestPortion)(address(this));
286         depositInternal(reinvestPortion, player, referrer, true);
287         
288         // Streak stuff
289         Streak memory streak = reinvestStreaks[player];
290         uint128 epochWeek = weeksSinceEpoch();
291         if (streak.lastReinvestWeek + 1 == epochWeek) {
292             streak.currentStreak++;
293         } else if (streak.lastReinvestWeek < epochWeek || streak.currentStreak == 0) {
294             streak.currentStreak = 1;
295         }
296 
297         streak.lastReinvestWeek = epochWeek;
298         reinvestStreaks[player] = streak;
299         
300         emit Reinvest(player, referrer, reinvestPortion);
301     }
302     
303     function drawEth(uint256 amount) external {
304         uint256 ethValue = loanableValueInternal(msg.sender);
305         uint256 maxLoanPercent = loyalty.getLoanPercentMax(msg.sender);
306         require(maxLoanPercent < 80);
307         uint256 maxLoan = (ethValue * maxLoanPercent) / 100;
308         require(amount <= maxLoan);
309         require(ethLoaned[msg.sender] + amount <= maxLoan);
310         ethLoaned[msg.sender] += amount;
311         msg.sender.transfer(amount);
312         emit Borrow(msg.sender, amount);
313     }
314     
315     function cashoutPayLoan(address referrer, uint256 percent, address[] calldata pathPairs, uint256[] calldata minOuts) external {
316         uint256 existing = ethLoaned[msg.sender];
317         require(existing > 0);
318         require(percent > 0 && percent < 101);
319         require(uniswapPriceGuard.overPriceFloorValue(pathPairs, minOuts));
320         
321         uint256 ethGained;
322         uint256 length = userSubscriptionsList[msg.sender].length;
323         for (uint256 i = 0; i < length; i++) {
324             SubscriptionDapp dapp = SubscriptionDapp(userSubscriptionsList[msg.sender][i]);
325             (bool success, bytes memory returnData) = address(dapp).call(abi.encodePacked(dapp.cashout.selector, abi.encode(msg.sender, referrer, percent)));
326             if (success) {
327                 ethGained += abi.decode(returnData, (uint256));
328             }
329             
330         }
331         
332         emit Cashout(msg.sender, referrer, ethGained);
333         
334         if (ethGained > existing) {
335             msg.sender.transfer(ethGained - existing);
336             ethGained = existing;
337         }
338         ethLoaned[msg.sender] -= ethGained;
339         reinvestStreaks[msg.sender] = Streak(0, weeksSinceEpoch());
340     }
341     
342     function paybackEthWithDivs() public {
343         uint256 existing = ethLoaned[msg.sender];
344         require(existing > 0);
345         
346         uint256 ethGained = claimDivsInternal(msg.sender);
347         emit Payback(msg.sender, ethGained);
348         
349         if (ethGained > existing) {
350             msg.sender.transfer(ethGained - existing);
351             ethGained = existing;
352         }
353         ethLoaned[msg.sender] -= ethGained;
354     }
355     
356     function paybackEth() external payable {
357         claimDivs();
358         uint256 amount = msg.value;
359         uint256 existing = ethLoaned[msg.sender];
360         if (amount > existing) {
361             msg.sender.transfer(amount - existing);
362             amount = existing;
363         }
364         ethLoaned[msg.sender] -= amount;
365         emit Payback(msg.sender, amount);
366     }
367     
368     function weeksSinceEpoch() public view returns(uint128) {
369         return uint128((now - 259200) / 604800);
370     }
371     
372     function totalDivsInternal(address player) internal returns (uint256) {
373         uint256 length = userSubscriptionsList[player].length;
374         
375         uint256 ethDivs;
376         for (uint256 i = 0; i < length; i++) {
377             SubscriptionDapp dapp = SubscriptionDapp(userSubscriptionsList[player][i]);
378             (bool success, bytes memory returnData) = address(dapp).call(abi.encodePacked(dapp.currentDivs.selector, abi.encode(player)));
379             if (success) {
380                 ethDivs += abi.decode(returnData, (uint256));
381             }
382         }
383         
384         return ethDivs;
385     }
386     
387     function totalDivs(address player) external view returns (uint256) {
388         uint256 length = userSubscriptionsList[player].length;
389         
390         uint256 ethDivs;
391         for (uint256 i = 0; i < length; i++) {
392             ethDivs += SubscriptionDapp(userSubscriptionsList[player][i]).currentDivs(player);
393         }
394         
395         return ethDivs;
396     }
397     
398     function accountValue(address player, bool includeFees) external view returns(uint256) {
399         uint256 length = userSubscriptionsList[player].length;
400         
401         uint256 ethValue;
402         for (uint256 i = 0; i < length; i++) {
403             ethValue += SubscriptionDapp(userSubscriptionsList[player][i]).currentValue(player, includeFees);
404         }
405         
406         return ethValue;
407     }
408     
409     function loanableValueInternal(address player) internal returns(uint256) {
410         uint256 length = userSubscriptionsList[player].length;
411         
412         uint256 ethValue;
413         for (uint256 i = 0; i < length; i++) {
414             if (subscriptionLoanable[userSubscriptionsList[player][i]]) { // If whitelisted
415                 SubscriptionDapp dapp = SubscriptionDapp(userSubscriptionsList[player][i]);
416                 (bool success, bytes memory returnData) = address(dapp).call(abi.encodePacked(dapp.currentValue.selector, abi.encode(player, false)));
417                 if (success) {
418                     ethValue += abi.decode(returnData, (uint256));
419                 }
420             }
421         }
422         return ethValue;
423     }
424     
425     function loanableValue(address player) external view returns(uint256) {
426         uint256 length = userSubscriptionsList[player].length;
427         
428         uint256 ethValue;
429         for (uint256 i = 0; i < length; i++) {
430             if (subscriptionLoanable[userSubscriptionsList[player][i]]) { // If whitelisted
431                 ethValue += SubscriptionDapp(userSubscriptionsList[player][i]).currentValue(player, false);
432             }
433         }
434         return ethValue;
435     }
436     
437     function accountSubscriptions(address player) external view returns (uint256) {
438         return userSubscriptionsList[player].length;
439     }
440 }
441 
442 
443 
444 
445 
446 
447 
448 
449 interface SubscriptionDapp {
450     function deposit(address player, uint256 amount, address referrer, bool alreadyClaimedDivs) external payable returns (uint256);
451     function cashout(address player, address referrer, uint256 percent) external returns (uint256);
452     function claimDivs(address player) external returns (uint256);
453     function currentValue(address player, bool removeFees) external view returns(uint256);
454     function currentDivs(address player) external view returns(uint256);
455     function() external payable;
456 }
457 
458 
459 interface FundPaymentHandler {
460     function cashout(address player) external payable;
461     function reinvest(address player) external payable;
462 }
463 
464 
465 interface UniswapPriceGuard {
466     function overPriceFloorValue(address[] calldata pathPairs, uint256[] calldata minOuts) external returns(bool);
467 }
468 
469 
470 interface LoyaltyScheme {
471     function getLoanPercentMax(address player) external view returns (uint256);
472 }
473 
474 
475 
476 library SafeMath {
477 
478   /**
479   * @dev Multiplies two numbers, throws on overflow.
480   */
481   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
482     if (a == 0) {
483       return 0;
484     }
485     uint256 c = a * b;
486     assert(c / a == b);
487     return c;
488   }
489 
490   /**
491   * @dev Integer division of two numbers, truncating the quotient.
492   */
493   function div(uint256 a, uint256 b) internal pure returns (uint256) {
494     // assert(b > 0); // Solidity automatically throws when dividing by 0
495     uint256 c = a / b;
496     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
497     return c;
498   }
499 
500   /**
501   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
502   */
503   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
504     assert(b <= a);
505     return a - b;
506   }
507 
508   /**
509   * @dev Adds two numbers, throws on overflow.
510   */
511   function add(uint256 a, uint256 b) internal pure returns (uint256) {
512     uint256 c = a + b;
513     assert(c >= a);
514     return c;
515   }
516 }