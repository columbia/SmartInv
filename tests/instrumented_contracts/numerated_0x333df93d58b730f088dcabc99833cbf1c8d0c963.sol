1 pragma solidity ^0.4.18;
2 
3 // Project: Imigize
4 // v2, 2018-01-14
5 // This code is the property of CryptoB2B.io
6 // Copying in whole or in part is prohibited.
7 // Authors: Ivan Fedorov and Dmitry Borodin
8 // Do you want the same TokenSale platform? www.cryptob2b.io
9 
10 // (A1)
11 // The main contract for the sale and management of rounds.
12 contract CrowdsaleL{
13 
14 	// For Round0, firstMint is:
15 	// 0000000000000000000000000000000000000000000069e10de76676d0800000
16 	// (extra 500K tokens for marketing)
17     
18     using SafeMath for uint256;
19 
20     enum TokenSaleType {round1, round2}
21     enum Roles {beneficiary, accountant, manager, observer, bounty, team, company}
22     
23     // Extra fee
24     address constant TaxCollector = 0x0;
25 	// fee for round 1 & 2
26     uint256[2] TaxValues = [0 finney, 0 finney];
27     uint8 vaultNum;
28 
29     TokenL public token;
30 
31     bool public isFinalized;
32     bool public isInitialized;
33     bool public isPausedCrowdsale;
34 
35     mapping (uint8 => address) public wallets;
36 
37     struct Profit{
38 	    uint256 min;    // percent from 0 to 50
39 	    uint256 max;    // percent from 0 to 50
40 	    uint256 step;   // percent step, from 1 to 50 (please, read doc!)
41 	    uint256 maxAllProfit; 
42     }
43     struct Bonus {
44 	    uint256 value;
45 	    uint256 procent;
46 	    uint256 freezeTime;
47     }
48 
49     Bonus[] public bonuses;
50 
51     Profit public profit = Profit(0, 20, 5, 100);
52     
53     uint256 public startTime= 1515974400;
54     uint256 public endDiscountTime = 1520294400;
55     uint256 public endTime = 1520294400;
56 
57     // How many tokens (excluding the bonus) are transferred to the investor in exchange for 1 ETH
58     // **THOUSANDS** 10^3 for human, *10**3 for Solidity, 1e3 for MyEtherWallet (MEW).
59     // Example: if 1ETH = 40.5 Token ==> use 40500
60     uint256 public rate = 5668000;
61 
62     // If the round does not attain this value before the closing date, the round is recognized as a
63     // failure and investors take the money back (the founders will not interfere in any way).
64     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: softcap=15ETH ==> use 15*10**18 (Solidity) or 15e18 (MEW)
65     uint256 public softCap = 0 ether;
66 
67     // The maximum possible amount of income
68     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: hardcap=123.45ETH ==> use 123450*10**15 (Solidity) or 12345e15 (MEW)
69     uint256 public hardCap = 802 ether;
70 
71     // If the last payment is slightly higher than the hardcap, then the usual contracts do
72     // not accept it, because it goes beyond the hardcap. However it is more reasonable to accept the
73     // last payment, very slightly raising the hardcap. The value indicates by how many ETH the
74     // last payment can exceed the hardcap to allow it to be paid. Immediately after this payment, the
75     // round closes. The funders should write here a small number, not more than 1% of the CAP.
76     // Can be equal to zero, to cancel.
77     // **QUINTILLIONS** 10^18 / *10**18 / 1e18
78     uint256 public overLimit = 20 ether;
79 
80     // The minimum possible payment from an investor in ETH. Payments below this value will be rejected.
81     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: minPay=0.1ETH ==> use 100*10**15 (Solidity) or 100e15 (MEW)
82     uint256 public minPay = 70 finney;
83 
84     uint256 ethWeiRaised;
85     uint256 nonEthWeiRaised;
86     uint256 weiRound1;
87     uint256 public tokenReserved;
88 
89     RefundVault public vault;
90     SVTAllocation public lockedAllocation;
91 
92     TokenSaleType TokenSale = TokenSaleType.round1;
93 
94     uint256 allToken;
95 
96     bool public bounty;
97     bool public team;
98     bool public company;
99     //bool public partners;
100 
101     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
102 
103     event Finalized();
104     event Initialized();
105 
106     function CrowdsaleL(TokenL _token, uint256 firstMint) public
107     {
108         // Initially, all next 7 roles/wallets are given to the Manager. The Manager is an employee of the company
109         // with knowledge of IT, who publishes the contract and sets it up. However, money and tokens require
110         // a Beneficiary and other roles (Accountant, Team, etc.). The Manager will not have the right
111         // to receive them. To enable this, the Manager must either enter specific wallets here, or perform
112         // this via method changeWallet. In the finalization methods it is written which wallet and
113         // what percentage of tokens are received.
114 
115         // Receives all the money (when finalizing Round1 & Round2)
116         wallets[uint8(Roles.beneficiary)] = 0x07544edde0542857277188598606B32F2C28062F; //msg.sender;
117 
118         // Receives all the tokens for non-ETH investors (when finalizing Round1 & Round2)
119         wallets[uint8(Roles.accountant)] = 0x31e78568a5E53C568711dd139Ec99d775E9fB80b; //msg.sender;
120 
121         // All rights except the rights to receive tokens or money. Has the right to change any other
122         // wallets (Beneficiary, Accountant, ...), but only if the round has not started. Once the
123         // round is initialized, the Manager has lost all rights to change the wallets.
124         // If the TokenSale is conducted by one person, then nothing needs to be changed. Permit all 7 roles
125         // point to a single wallet.
126         wallets[uint8(Roles.manager)] = msg.sender;
127 
128         // Has only the right to call paymentsInOtherCurrency (please read the document)
129         wallets[uint8(Roles.observer)] = 0x7FF83C688CaC62f5944C694CF04bF3f30ec19608; //msg.sender;
130 
131         wallets[uint8(Roles.bounty)] = 0x17194d2cA481d2533A147776BeB471DC40dc4580; //msg.sender;
132 
133         // When the round is finalized, all team tokens are transferred to a special freezing
134         // contract. As soon as defrosting is over, only the Team wallet will be able to
135         // collect all the tokens. It does not store the address of the freezing contract,
136         // but the final wallet of the project team.
137         wallets[uint8(Roles.team)] = 0x443f4Be0f50f973e3970343c6A50bcf1Ac66c6C3; //msg.sender;
138 
139         wallets[uint8(Roles.company)] = 0xb4D429B3240616FA67D1509c0C0E48D11900dd18; //msg.sender;
140 
141         token = _token;
142         token.setOwner();
143 
144         token.pause(); // block exchange tokens
145 
146         token.addUnpausedWallet(wallets[uint8(Roles.accountant)]);
147         token.addUnpausedWallet(msg.sender);
148         token.addUnpausedWallet(wallets[uint8(Roles.bounty)]);
149         token.addUnpausedWallet(wallets[uint8(Roles.company)]);
150 
151         if (firstMint > 0) {
152             token.mint(msg.sender, firstMint);
153         }
154 
155     }
156 
157     // Returns the name of the current round in plain text. Constant.
158     function getTokenSaleType()  public constant returns(string){
159         return (TokenSale == TokenSaleType.round1)?'round1':'round2';
160     }
161 
162     // Transfers the funds of the investor to the contract of return of funds. Internal.
163     function forwardFunds() internal {
164         vault.deposit.value(msg.value)(msg.sender);
165     }
166 
167     // Check for the possibility of buying tokens. Inside. Constant.
168     function validPurchase() internal constant returns (bool) {
169 
170         // The round started and did not end
171         bool withinPeriod = (now > startTime && now < endTime);
172 
173         // Rate is greater than or equal to the minimum
174         bool nonZeroPurchase = msg.value >= minPay;
175 
176         // hardCap is not reached, and in the event of a transaction, it will not be exceeded by more than OverLimit
177         bool withinCap = msg.value <= hardCap.sub(weiRaised()).add(overLimit);
178 
179         // round is initialized and no "Pause of trading" is set
180         return withinPeriod && nonZeroPurchase && withinCap && isInitialized && !isPausedCrowdsale;
181     }
182 
183     // Check for the ability to finalize the round. Constant.
184     function hasEnded() public constant returns (bool) {
185 
186         bool timeReached = now > endTime;
187 
188         bool capReached = weiRaised() >= hardCap;
189 
190         return (timeReached || capReached) && isInitialized;
191     }
192     
193     function finalizeAll() external {
194         finalize();
195         finalize1();
196         finalize2();
197         finalize3();
198     }
199 
200     // Finalize. Only available to the Manager and the Beneficiary. If the round failed, then
201     // anyone can call the finalization to unlock the return of funds to investors
202     // You must call a function to finalize each round (after the Round1 & after the Round2)
203     function finalize() public {
204 
205         require(wallets[uint8(Roles.manager)] == msg.sender || wallets[uint8(Roles.beneficiary)] == msg.sender || !goalReached());
206         require(!isFinalized);
207         require(hasEnded());
208 
209         isFinalized = true;
210         finalization();
211         Finalized();
212     }
213 
214     // The logic of finalization. Internal
215     function finalization() internal {
216 
217         // If the goal of the achievement
218         if (goalReached()) {
219 
220             // Send ether to Beneficiary
221             vault.close(wallets[uint8(Roles.beneficiary)]);
222 
223             // if there is anything to give
224             if (tokenReserved > 0) {
225 
226                 // Issue tokens of non-eth investors to Accountant account
227                 token.mint(wallets[uint8(Roles.accountant)],tokenReserved);
228 
229                 // Reset the counter
230                 tokenReserved = 0;
231             }
232 
233             // If the finalization is Round 1
234             if (TokenSale == TokenSaleType.round1) {
235 
236                 // Reset settings
237                 isInitialized = false;
238                 isFinalized = false;
239 
240                 // Switch to the second round (to Round2)
241                 TokenSale = TokenSaleType.round2;
242 
243                 // Reset the collection counter
244                 weiRound1 = weiRaised();
245                 ethWeiRaised = 0;
246                 nonEthWeiRaised = 0;
247 
248 
249             }
250             else // If the second round is finalized
251             {
252 
253                 // Record how many tokens we have issued
254                 allToken = token.totalSupply();
255 
256                 // Permission to collect tokens to those who can pick them up
257                 bounty = true;
258                 team = true;
259                 company = true;
260                 //partners = true;
261 
262             }
263 
264         }
265         else // If they failed round
266         {
267             // Allow investors to withdraw their funds
268             vault.enableRefunds();
269         }
270     }
271 
272     // The Manager freezes the tokens for the Team.
273     // You must call a function to finalize Round 2 (only after the Round2)
274     function finalize1() public {
275         require(wallets[uint8(Roles.manager)] == msg.sender || wallets[uint8(Roles.beneficiary)] == msg.sender);
276         require(team);
277         team = false;
278         lockedAllocation = new SVTAllocation(token, wallets[uint8(Roles.team)]);
279         token.addUnpausedWallet(lockedAllocation);
280         // 12% - tokens to Team wallet after freeze (77% for investors)
281         // *** CHECK THESE NUMBERS ***
282         token.mint(lockedAllocation,allToken.mul(12).div(77));
283     }
284 
285     function finalize2() public {
286         require(wallets[uint8(Roles.manager)] == msg.sender || wallets[uint8(Roles.beneficiary)] == msg.sender);
287         require(bounty);
288         bounty = false;
289         // 2% - tokens to bounty wallet after freeze (77% for investors)
290         // *** CHECK THESE NUMBERS ***
291         token.mint(wallets[uint8(Roles.bounty)],allToken.mul(2).div(77));
292     }
293 
294     // For marketing, referral, reserve 
295     // You must call a function to finalize Round 2 (only after the Round2)
296     function finalize3() public {
297         require(wallets[uint8(Roles.manager)] == msg.sender || wallets[uint8(Roles.beneficiary)] == msg.sender);
298         require(company);
299         company = false;
300         // 9% - tokens to company wallet after freeze (77% for investors)
301         // *** CHECK THESE NUMBERS ***
302         token.mint(wallets[uint8(Roles.company)],allToken.mul(9).div(77));
303     }
304 
305 
306     // Initializing the round. Available to the manager. After calling the function,
307     // the Manager loses all rights: Manager can not change the settings (setup), change
308     // wallets, prevent the beginning of the round, etc. You must call a function after setup
309     // for the initial round (before the Round1 and before the Round2)
310     function initialize() public {
311 
312         // Only the Manager
313         require(wallets[uint8(Roles.manager)] == msg.sender);
314 
315         // If not yet initialized
316         require(!isInitialized);
317 
318         // And the specified start time has not yet come
319         // If initialization return an error, check the start date!
320         require(now <= startTime);
321 
322         initialization();
323 
324         Initialized();
325 
326         isInitialized = true;
327     }
328 
329     function initialization() internal {
330         uint256 taxValue = TaxValues[vaultNum];
331         vaultNum++;
332         uint256 arrear;
333         if (address(vault) != 0x0){
334             arrear = DistributorRefundVault(vault).taxValue();
335             vault.del(wallets[uint8(Roles.beneficiary)]);
336         }
337         vault = new DistributorRefundVault(TaxCollector, taxValue.add(arrear));
338     }
339 
340     // At the request of the investor, we raise the funds (if the round has failed because of the hardcap)
341     function claimRefund() public{
342         vault.refund(msg.sender);
343     }
344 
345     // We check whether we collected the necessary minimum funds. Constant.
346     function goalReached() public constant returns (bool) {
347         return weiRaised() >= softCap;
348     }
349 
350     // Customize. The arguments are described in the constructor above.
351     function setup(uint256 _startTime, uint256 _endDiscountTime, uint256 _endTime, uint256 _softCap, uint256 _hardCap, uint256 _rate, uint256 _overLimit, uint256 _minPay, uint256 _minProfit, uint256 _maxProfit, uint256 _stepProfit, uint256 _maxAllProfit, uint256[] _value, uint256[] _procent, uint256[] _freezeTime) public{
352         changePeriod(_startTime, _endDiscountTime, _endTime);
353         changeTargets(_softCap, _hardCap);
354         changeRate(_rate, _overLimit, _minPay);
355         changeDiscount(_minProfit, _maxProfit, _stepProfit, _maxAllProfit);
356         setBonuses(_value, _procent, _freezeTime);
357     }
358 
359     // Change the date and time: the beginning of the round, the end of the bonus, the end of the round. Available to Manager
360     // Description in the Crowdsale constructor
361     function changePeriod(uint256 _startTime, uint256 _endDiscountTime, uint256 _endTime) public{
362 
363         require(wallets[uint8(Roles.manager)] == msg.sender);
364 
365         require(!isInitialized);
366 
367         // Date and time are correct
368         require(now <= _startTime);
369         require(_endDiscountTime > _startTime && _endDiscountTime <= _endTime);
370 
371         startTime = _startTime;
372         endTime = _endTime;
373         endDiscountTime = _endDiscountTime;
374 
375     }
376 
377     // We change the purpose of raising funds. Available to the manager.
378     // Description in the Crowdsale constructor.
379     function changeTargets(uint256 _softCap, uint256 _hardCap) public {
380 
381         require(wallets[uint8(Roles.manager)] == msg.sender);
382 
383         require(!isInitialized);
384 
385         // The parameters are correct
386         require(_softCap <= _hardCap);
387 
388         softCap = _softCap;
389         hardCap = _hardCap;
390     }
391 
392     // Change the price (the number of tokens per 1 eth), the maximum hardCap for the last bet,
393     // the minimum bet. Available to the Manager.
394     // Description in the Crowdsale constructor
395     function changeRate(uint256 _rate, uint256 _overLimit, uint256 _minPay) public {
396 
397         require(wallets[uint8(Roles.manager)] == msg.sender);
398 
399         require(!isInitialized);
400 
401         require(_rate > 0);
402 
403         rate = _rate;
404         overLimit = _overLimit;
405         minPay = _minPay;
406     }
407 
408     // We change the parameters of the discount:% min bonus,% max bonus, number of steps.
409     // Available to the manager. Description in the Crowdsale constructor
410     function changeDiscount(uint256 _minProfit, uint256 _maxProfit, uint256 _stepProfit, uint256 _maxAllProfit) public {
411 
412         require(wallets[uint8(Roles.manager)] == msg.sender);
413 
414         require(!isInitialized);
415         
416         require(_maxProfit <= _maxAllProfit);
417 
418         // The parameters are correct
419         require(_stepProfit <= _maxProfit.sub(_minProfit));
420 
421         // If not zero steps
422         if(_stepProfit > 0){
423             // We will specify the maximum percentage at which it is possible to provide
424             // the specified number of steps without fractional parts
425             profit.max = _maxProfit.sub(_minProfit).div(_stepProfit).mul(_stepProfit).add(_minProfit);
426         }else{
427             // to avoid a divide to zero error, set the bonus as static
428             profit.max = _minProfit;
429         }
430 
431         profit.min = _minProfit;
432         profit.step = _stepProfit;
433         profit.maxAllProfit = _maxAllProfit;
434     }
435 
436     function setBonuses(uint256[] _value, uint256[] _procent, uint256[] _dateUnfreeze) public {
437 
438         require(wallets[uint8(Roles.manager)] == msg.sender);
439         require(!isInitialized);
440 
441         require(_value.length == _procent.length && _value.length == _dateUnfreeze.length);
442         bonuses.length = _value.length;
443         for(uint256 i = 0; i < _value.length; i++){
444             bonuses[i] = Bonus(_value[i],_procent[i],_dateUnfreeze[i]);
445         }
446     }
447 
448     // Collected funds for the current round. Constant.
449     function weiRaised() public constant returns(uint256){
450         return ethWeiRaised.add(nonEthWeiRaised);
451     }
452 
453     // Returns the amount of fees for both phases. Constant.
454     function weiTotalRaised() public constant returns(uint256){
455         return weiRound1.add(weiRaised());
456     }
457 
458     // Returns the percentage of the bonus on the current date. Constant.
459     function getProfitPercent() public constant returns (uint256){
460         return getProfitPercentForData(now);
461     }
462 
463     // Returns the percentage of the bonus on the given date. Constant.
464     function getProfitPercentForData(uint256 timeNow) public constant returns (uint256){
465         // if the discount is 0 or zero steps, or the round does not start, we return the minimum discount
466         if (profit.max == 0 || profit.step == 0 || timeNow > endDiscountTime){
467             return profit.min;
468         }
469 
470         // if the round is over - the maximum
471         if (timeNow<=startTime){
472             return profit.max;
473         }
474 
475         // bonus period
476         uint256 range = endDiscountTime.sub(startTime);
477 
478         // delta bonus percentage
479         uint256 profitRange = profit.max.sub(profit.min);
480 
481         // Time left
482         uint256 timeRest = endDiscountTime.sub(timeNow);
483 
484         // Divide the delta of time into
485         uint256 profitProcent = profitRange.div(profit.step).mul(timeRest.mul(profit.step.add(1)).div(range));
486         return profitProcent.add(profit.min);
487     }
488 
489     function getBonuses(uint256 _value) public constant returns(uint256 procent, uint256 _dateUnfreeze){
490         if(bonuses.length == 0 || bonuses[0].value > _value){
491             return (0,0);
492         }
493         uint16 i = 1;
494         for(i; i < bonuses.length; i++){
495             if(bonuses[i].value > _value){
496                 break;
497             }
498         }
499         return (bonuses[i-1].procent,bonuses[i-1].freezeTime);
500     }
501 
502     // The ability to quickly check Round1 (only for Round1, only 1 time). Completes the Round1 by
503     // transferring the specified number of tokens to the Accountant's wallet. Available to the Manager.
504     // Use only if this is provided by the script and white paper. In the normal scenario, it
505     // does not call and the funds are raised normally. We recommend that you delete this
506     // function entirely, so as not to confuse the auditors. Initialize & Finalize not needed.
507     // ** QUINTILIONS **  10^18 / 1**18 / 1e18
508     function fastTokenSale(uint256 _totalSupply) public {
509         require(wallets[uint8(Roles.manager)] == msg.sender);
510         require(TokenSale == TokenSaleType.round1 && !isInitialized);
511         token.mint(wallets[uint8(Roles.accountant)], _totalSupply);
512         TokenSale = TokenSaleType.round2;
513     }
514 
515     // Remove the "Pause of exchange". Available to the manager at any time. If the
516     // manager refuses to remove the pause, then 30-120 days after the successful
517     // completion of the TokenSale, anyone can remove a pause and allow the exchange to continue.
518     // The manager does not interfere and will not be able to delay the term.
519     // He can only cancel the pause before the appointed time.
520     function tokenUnpause() public {
521         require(wallets[uint8(Roles.manager)] == msg.sender
522             || (now > endTime + 60 days && TokenSale == TokenSaleType.round2 && isFinalized && goalReached()));
523         token.unpause();
524     }
525 
526     // Enable the "Pause of exchange". Available to the manager until the TokenSale is completed.
527     // The manager cannot turn on the pause, for example, 3 years after the end of the TokenSale.
528     function tokenPause() public {
529         require(wallets[uint8(Roles.manager)] == msg.sender && !isFinalized);
530         token.pause();
531     }
532 
533     // Pause of sale. Available to the manager.
534     function crowdsalePause() public {
535         require(wallets[uint8(Roles.manager)] == msg.sender);
536         require(isPausedCrowdsale == false);
537         isPausedCrowdsale = true;
538     }
539 
540     // Withdrawal from the pause of sale. Available to the manager.
541     function crowdsaleUnpause() public {
542         require(wallets[uint8(Roles.manager)] == msg.sender);
543         require(isPausedCrowdsale == true);
544         isPausedCrowdsale = false;
545     }
546 
547     // Checking whether the rights to address ignore the "Pause of exchange". If the
548     // wallet is included in this list, it can translate tokens, ignoring the pause. By default,
549     // only the following wallets are included:
550     //    - Accountant wallet (he should immediately transfer tokens, but not to non-ETH investors)
551     //    - Contract for freezing the tokens for the Team (but Team wallet not included)
552     // Inside. Constant.
553     function unpausedWallet(address _wallet) internal constant returns(bool) {
554         bool _accountant = wallets[uint8(Roles.accountant)] == _wallet;
555         bool _manager = wallets[uint8(Roles.manager)] == _wallet;
556         bool _bounty = wallets[uint8(Roles.bounty)] == _wallet;
557         bool _company = wallets[uint8(Roles.company)] == _wallet;
558         return _accountant || _manager || _bounty || _company;
559     }
560 
561     // For example - After 5 years of the project's existence, all of us suddenly decided collectively
562     // (company + investors) that it would be more profitable for everyone to switch to another smart
563     // contract responsible for tokens. The company then prepares a new token, investors
564     // disassemble, study, discuss, etc. After a general agreement, the manager allows any investor:
565     //      - to burn the tokens of the previous contract
566     //      - generate new tokens for a new contract
567     // It is understood that after a general solution through this function all investors
568     // will collectively (and voluntarily) move to a new token.
569     function moveTokens(address _migrationAgent) public {
570         require(wallets[uint8(Roles.manager)] == msg.sender);
571         token.setMigrationAgent(_migrationAgent);
572     }
573 
574     function migrateAll(address[] _holders) public {
575         require(wallets[uint8(Roles.manager)] == msg.sender);
576         token.migrateAll(_holders);
577     }
578 
579     // Change the address for the specified role.
580     // Available to any wallet owner except the observer.
581     // Available to the manager until the round is initialized.
582     // The Observer's wallet or his own manager can change at any time.
583     function changeWallet(Roles _role, address _wallet) public
584     {
585         require(
586         (msg.sender == wallets[uint8(_role)] && _role != Roles.observer)
587         ||
588         (msg.sender == wallets[uint8(Roles.manager)] && (!isInitialized || _role == Roles.observer))
589         );
590         address oldWallet = wallets[uint8(_role)];
591         wallets[uint8(_role)] = _wallet;
592         if(!unpausedWallet(oldWallet))
593         token.delUnpausedWallet(oldWallet);
594         if(unpausedWallet(_wallet))
595         token.addUnpausedWallet(_wallet);
596     }
597 
598     // If a little more than a year has elapsed (Round2 start date + 400 days), a smart contract
599     // will allow you to send all the money to the Beneficiary, if any money is present. This is
600     // possible if you mistakenly launch the Round2 for 30 years (not 30 days), investors will transfer
601     // money there and you will not be able to pick them up within a reasonable time. It is also
602     // possible that in our checked script someone will make unforeseen mistakes, spoiling the
603     // finalization. Without finalization, money cannot be returned. This is a rescue option to
604     // get around this problem, but available only after a year (400 days).
605 
606     // Another reason - the TokenSale was a failure, but not all ETH investors took their money during the year after.
607     // Some investors may have lost a wallet key, for example.
608 
609     // The method works equally with the Round1 and Round2. When the Round1 starts, the time for unlocking
610     // the distructVault begins. If the TokenSale is then started, then the term starts anew from the first day of the TokenSale.
611 
612     // Next, act independently, in accordance with obligations to investors.
613 
614     // Within 400 days of the start of the Round, if it fails only investors can take money. After
615     // the deadline this can also include the company as well as investors, depending on who is the first to use the method.
616     function distructVault() public {
617         require(wallets[uint8(Roles.beneficiary)] == msg.sender);
618         require(now > startTime + 400 days);
619         vault.del(wallets[uint8(Roles.beneficiary)]);
620     }
621 
622 
623     // We accept payments other than Ethereum (ETH) and other currencies, for example, Bitcoin (BTC).
624     // Perhaps other types of cryptocurrency - see the original terms in the white paper and on the TokenSale website.
625 
626     // We release tokens on Ethereum. During the Round1 and Round2 with a smart contract, you directly transfer
627     // the tokens there and immediately, with the same transaction, receive tokens in your wallet.
628 
629     // When paying in any other currency, for example in BTC, we accept your money via one common wallet.
630     // Our manager fixes the amount received for the bitcoin wallet and calls the method of the smart
631     // contract paymentsInOtherCurrency to inform him how much foreign currency has been received - on a daily basis.
632     // The smart contract pins the number of accepted ETH directly and the number of BTC. Smart contract
633     // monitors softcap and hardcap, so as not to go beyond this framework.
634 
635     // In theory, it is possible that when approaching hardcap, we will receive a transfer (one or several
636     // transfers) to the wallet of BTC, that together with previously received money will exceed the hardcap in total.
637     // In this case, we will refund all the amounts above, in order not to exceed the hardcap.
638 
639     // Collection of money in BTC will be carried out via one common wallet. The wallet's address will be published
640     // everywhere (in a white paper, on the TokenSale website, on Telegram, on Bitcointalk, in this code, etc.)
641     // Anyone interested can check that the administrator of the smart contract writes down exactly the amount
642     // in ETH (in equivalent for BTC) there. In theory, the ability to bypass a smart contract to accept money in
643     // BTC and not register them in ETH creates a possibility for manipulation by the company. Thanks to
644     // paymentsInOtherCurrency however, this threat is leveled.
645 
646     // Any user can check the amounts in BTC and the variable of the smart contract that accounts for this
647     // (paymentsInOtherCurrency method). Any user can easily check the incoming transactions in a smart contract
648     // on a daily basis. Any hypothetical tricks on the part of the company can be exposed and panic during the TokenSale,
649     // simply pointing out the incompatibility of paymentsInOtherCurrency (ie, the amount of ETH + BTC collection)
650     // and the actual transactions in BTC. The company strictly adheres to the described principles of openness.
651 
652     // The company administrator is required to synchronize paymentsInOtherCurrency every working day (but you
653     // cannot synchronize if there are no new BTC payments). In the case of unforeseen problems, such as
654     // brakes on the Ethereum network, this operation may be difficult. You should only worry if the
655     // administrator does not synchronize the amount for more than 96 hours in a row, and the BTC wallet
656     // receives significant amounts.
657 
658     // This scenario ensures that for the sum of all fees in all currencies this value does not exceed hardcap.
659 
660     // BTC - 1HQahivPX2cU5Nq921wSuULpuZyi9AcXCY
661 
662     // ** QUINTILLIONS ** 10^18 / 1**18 / 1e18
663     function paymentsInOtherCurrency(uint256 _token, uint256 _value) public {
664         require(wallets[uint8(Roles.observer)] == msg.sender);
665         bool withinPeriod = (now >= startTime && now <= endTime);
666 
667         bool withinCap = _value.add(ethWeiRaised) <= hardCap.add(overLimit);
668         require(withinPeriod && withinCap && isInitialized);
669 
670         nonEthWeiRaised = _value;
671         tokenReserved = _token;
672 
673     }
674     
675     function changeLock(address _owner, uint256 _value, uint256 _date) external {
676         require(wallets[uint8(Roles.manager)] == msg.sender);
677         token.changeLock(_owner, _value, _date);
678     }
679 
680     function lokedMint(address _beneficiary, uint256 _value, uint256 _freezeTime) internal {
681         if(_freezeTime > 0){
682             
683             uint256 totalBloked = token.valueBlocked(_beneficiary).add(_value);
684             uint256 pastDateUnfreeze = token.blikedUntil(_beneficiary);
685             uint256 newDateUnfreeze = _freezeTime + now; 
686             newDateUnfreeze = (pastDateUnfreeze > newDateUnfreeze ) ? pastDateUnfreeze : newDateUnfreeze;
687 
688             token.changeLock(_beneficiary,totalBloked,newDateUnfreeze);
689         }
690         token.mint(_beneficiary,_value);
691     }
692 
693 
694     // The function for obtaining smart contract funds in ETH. If all the checks are true, the token is
695     // transferred to the buyer, taking into account the current bonus.
696     function buyTokens(address beneficiary) public payable {
697         require(beneficiary != 0x0);
698         require(validPurchase());
699 
700         uint256 weiAmount = msg.value;
701 
702         uint256 ProfitProcent = getProfitPercent();
703 
704         var (bonus, dateUnfreeze) = getBonuses(weiAmount);
705         
706         // Scenario 1 - select max from all bonuses + check profit.maxAllProfit
707         //uint256 totalProfit = ProfitProcent;
708         //totalProfit = (totalProfit < bonus) ? bonus : totalProfit;
709         //totalProfit = (totalProfit > profit.maxAllProfit) ? profit.maxAllProfit : totalProfit;
710         
711         // Scenario 2 - sum both bonuses + check profit.maxAllProfit
712         uint256 totalProfit = bonus.add(ProfitProcent);
713         totalProfit = (totalProfit > profit.maxAllProfit)? profit.maxAllProfit: totalProfit;
714         
715         // calculate token amount to be created
716         uint256 tokens = weiAmount.mul(rate).mul(totalProfit + 100).div(100000);
717 
718         // update state
719         ethWeiRaised = ethWeiRaised.add(weiAmount);
720 
721         lokedMint(beneficiary, tokens, dateUnfreeze);
722 
723         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
724 
725         forwardFunds();
726     }
727 
728     // buyTokens alias
729     function () public payable {
730         buyTokens(msg.sender);
731     }
732 
733 }
734 
735 
736 /**
737  * @title SafeMath
738  * @dev Math operations with safety checks that throw on error
739  */
740 library SafeMath {
741     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
742         uint256 c = a * b;
743         assert(a == 0 || c / a == b);
744         return c;
745     }
746 
747     function div(uint256 a, uint256 b) internal pure returns (uint256) {
748         // assert(b > 0); // Solidity automatically throws when dividing by 0
749         uint256 c = a / b;
750         // assert(a == b * c + a % b); // There is no case in which this does not hold
751         return c;
752     }
753 
754     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
755         assert(b <= a);
756         return a - b;
757     }
758 
759     function add(uint256 a, uint256 b) internal pure returns (uint256) {
760         uint256 c = a + b;
761         assert(c >= a);
762         return c;
763     }
764 }
765 
766 /**
767  * @title Ownable
768  * @dev The Ownable contract has an owner address, and provides basic authorization control
769  * functions, this simplifies the implementation of "user permissions".
770  */
771 contract Ownable {
772     address public owner;
773 
774 
775     /**
776      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
777      * account.
778      */
779     function Ownable() public {
780         owner = msg.sender;
781     }
782 
783 
784     /**
785      * @dev Throws if called by any account other than the owner.
786      */
787     modifier onlyOwner() {
788         require(msg.sender == owner);
789         _;
790     }
791 
792 
793     /**
794      * @dev Allows the current owner to transfer control of the contract to a newOwner.
795      * @param newOwner The address to transfer ownership to.
796      */
797     function transferOwnership(address newOwner) onlyOwner public{
798         require(newOwner != address(0));
799         owner = newOwner;
800     }
801 
802 }
803 
804 /**
805  * @title Pausable
806  * @dev Base contract which allows children to implement an emergency stop mechanism.
807  */
808 contract Pausable is Ownable {
809     event Pause();
810     event Unpause();
811 
812     bool _paused = false;
813 
814     function paused() public constant returns(bool)
815     {
816         return _paused;
817     }
818 
819 
820     /**
821      * @dev modifier to allow actions only when the contract IS paused
822      */
823     modifier whenNotPaused() {
824         require(!paused());
825         _;
826     }
827 
828     /**
829      * @dev called by the owner to pause, triggers stopped state
830      */
831     function pause() onlyOwner public {
832         require(!_paused);
833         _paused = true;
834         Pause();
835     }
836 
837     /**
838      * @dev called by the owner to unpause, returns to normal state
839      */
840     function unpause() onlyOwner public {
841         require(_paused);
842         _paused = false;
843         Unpause();
844     }
845 }
846 
847 
848 // Contract interface for transferring current tokens to another
849 contract MigrationAgent
850 {
851     function migrateFrom(address _from, uint256 _value) public;
852 }
853 
854 contract BlockedToken is Ownable {
855     using SafeMath for uint256;
856 
857     struct locked {uint256 value; uint256 date;}
858 
859     mapping (address => locked) locks;
860 
861     function blikedUntil(address _owner) external constant returns (uint256) {
862         if(now < locks[_owner].date)
863         {
864             return locks[_owner].date;
865         }else{
866             return 0;
867         }
868     }
869 
870     function valueBlocked(address _owner) public constant returns (uint256) {
871         if(now < locks[_owner].date)
872         {
873             return locks[_owner].value;
874         }else{
875             return 0;
876         }
877     }
878 
879     function changeLock(address _owner, uint256 _value, uint256 _date) external onlyOwner {
880         locks[_owner] = locked(_value,_date);
881     }
882 }
883 
884 
885 // (A2)
886 // Contract token
887 contract TokenL is Pausable, BlockedToken {
888     using SafeMath for uint256;
889 
890     string public constant name = "Imigize";
891     string public constant symbol = "IMGZ";
892     uint8 public constant decimals = 18;
893 
894     uint256 public totalSupply;
895 
896     mapping(address => uint256) balances;
897     mapping (address => mapping (address => uint256)) allowed;
898 
899     mapping (address => bool) public unpausedWallet;
900 
901     bool public mintingFinished = false;
902 
903     uint256 public totalMigrated;
904     address public migrationAgent;
905 
906     event Transfer(address indexed from, address indexed to, uint256 value);
907     event Approval(address indexed owner, address indexed spender, uint256 value);
908 
909     event Mint(address indexed to, uint256 amount);
910     event MintFinished();
911 
912     event Migrate(address indexed _from, address indexed _to, uint256 _value);
913 
914     modifier canMint() {
915         require(!mintingFinished);
916         _;
917     }
918 
919     function TokenL() public{
920         owner = 0x0;
921     }
922 
923     function setOwner() public{
924         require(owner == 0x0);
925         owner = msg.sender;
926     }
927 
928     // Balance of the specified address
929     function balanceOf(address _owner) public constant returns (uint256 balance) {
930         return balances[_owner];
931     }
932 
933 
934     // Transfer of tokens from one account to another
935     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
936         uint256 available = balances[msg.sender].sub(valueBlocked(msg.sender));
937         require(_value <= available);
938         require (_value > 0);
939         balances[msg.sender] = balances[msg.sender].sub(_value);
940         balances[_to] = balances[_to].add(_value);
941         Transfer(msg.sender, _to, _value);
942         return true;
943     }
944 
945     // Returns the number of tokens that _owner trusted to spend from his account _spender
946     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
947         return allowed[_owner][_spender];
948     }
949 
950     // Trust _sender and spend _value tokens from your account
951     function approve(address _spender, uint256 _value) public returns (bool) {
952 
953         // To change the approve amount you first have to reduce the addresses
954         //  allowance to zero by calling `approve(_spender, 0)` if it is not
955         //  already 0 to mitigate the race condition described here:
956         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
957         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
958 
959         allowed[msg.sender][_spender] = _value;
960         Approval(msg.sender, _spender, _value);
961         return true;
962     }
963 
964     // Transfer of tokens from the trusted address _from to the address _to in the number _value
965     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
966 
967         uint256 available = balances[_from].sub(valueBlocked(_from));
968         require(_value <= available);
969 
970         var _allowance = allowed[_from][msg.sender];
971 
972         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
973         // require (_value <= _allowance);
974 
975         require (_value > 0);
976 
977         balances[_from] = balances[_from].sub(_value);
978         balances[_to] = balances[_to].add(_value);
979         allowed[_from][msg.sender] = _allowance.sub(_value);
980         Transfer(_from, _to, _value);
981         return true;
982     }
983 
984     // Issue new tokens to the address _to in the amount _amount. Available to the owner of the contract (contract Crowdsale)
985     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
986         totalSupply = totalSupply.add(_amount);
987         balances[_to] = balances[_to].add(_amount);
988         Mint(_to, _amount);
989         Transfer(0x0, _to, _amount);
990         return true;
991     }
992 
993     // Stop the release of tokens. This is not possible to cancel. Available to the owner of the contract.
994     function finishMinting() public onlyOwner returns (bool) {
995     	mintingFinished = true;
996         MintFinished();
997         return true;
998     }
999 
1000     // Redefinition of the method of the returning status of the "Exchange pause".
1001     // Never for the owner of an unpaused wallet.
1002     function paused() public constant returns(bool) {
1003         return super.paused() && !unpausedWallet[msg.sender];
1004     }
1005 
1006     // Add a wallet ignoring the "Exchange pause". Available to the owner of the contract.
1007     function addUnpausedWallet(address _wallet) public onlyOwner {
1008         unpausedWallet[_wallet] = true;
1009     }
1010 
1011     // Remove the wallet ignoring the "Exchange pause". Available to the owner of the contract.
1012     function delUnpausedWallet(address _wallet) public onlyOwner {
1013         unpausedWallet[_wallet] = false;
1014     }
1015 
1016     // Enable the transfer of current tokens to others. Only 1 time. Disabling this is not possible.
1017     // Available to the owner of the contract.
1018     function setMigrationAgent(address _migrationAgent) public onlyOwner {
1019         require(migrationAgent == 0x0);
1020         migrationAgent = _migrationAgent;
1021     }
1022 
1023     function migrateAll(address[] _holders) public onlyOwner {
1024         require(migrationAgent != 0x0);
1025         uint256 total = 0;
1026         uint256 value;
1027         for(uint i = 0; i < _holders.length; i++){
1028             value = balances[_holders[i]];
1029             if(value > 0){
1030                 balances[_holders[i]] = 0;
1031                 total = total.add(value);
1032                 MigrationAgent(migrationAgent).migrateFrom(_holders[i], value);
1033                 Migrate(_holders[i],migrationAgent,value);
1034             }
1035             totalSupply = totalSupply.sub(total);
1036             totalMigrated = totalMigrated.add(total);
1037         }
1038     }
1039 
1040     function migration(address _holder) internal {
1041         require(migrationAgent != 0x0);
1042         uint256 value = balances[_holder];
1043         require(value > 0);
1044         balances[_holder] = 0;
1045         totalSupply = totalSupply.sub(value);
1046         totalMigrated = totalMigrated.add(value);
1047         MigrationAgent(migrationAgent).migrateFrom(_holder, value);
1048         Migrate(_holder,migrationAgent,value);
1049 
1050     }
1051 
1052     // Reissue your tokens.
1053     function migrate() public
1054     {
1055         migration(msg.sender);
1056     }
1057 }
1058 
1059 
1060 // (A3)
1061 // Contract for freezing of investors' funds. Hence, investors will be able to withdraw money if the
1062 // round does not attain the softcap. From here the wallet of the beneficiary will receive all the
1063 // money (namely, the beneficiary, not the manager's wallet).
1064 contract RefundVault is Ownable {
1065     using SafeMath for uint256;
1066 
1067     enum State { Active, Refunding, Closed }
1068 
1069     mapping (address => uint256) public deposited;
1070     State public state;
1071 
1072     event Closed();
1073     event RefundsEnabled();
1074     event Refunded(address indexed beneficiary, uint256 weiAmount);
1075     event Deposited(address indexed beneficiary, uint256 weiAmount);
1076 
1077     function RefundVault() public {
1078         state = State.Active;
1079     }
1080 
1081     // Depositing funds on behalf of an TokenSale investor. Available to the owner of the contract (Crowdsale Contract).
1082     function deposit(address investor) onlyOwner public payable {
1083         require(state == State.Active);
1084         deposited[investor] = deposited[investor].add(msg.value);
1085         Deposited(investor,msg.value);
1086     }
1087 
1088     // Move the collected funds to a specified address. Available to the owner of the contract.
1089     function close(address _wallet) onlyOwner public {
1090         require(state == State.Active);
1091         require(_wallet != 0x0);
1092         state = State.Closed;
1093         Closed();
1094         _wallet.transfer(this.balance);
1095     }
1096 
1097     // Allow refund to investors. Available to the owner of the contract.
1098     function enableRefunds() onlyOwner public {
1099         require(state == State.Active);
1100         state = State.Refunding;
1101         RefundsEnabled();
1102     }
1103 
1104     // Return the funds to a specified investor. In case of failure of the round, the investor
1105     // should call this method of this contract (RefundVault) or call the method claimRefund of Crowdsale
1106     // contract. This function should be called either by the investor himself, or the company
1107     // (or anyone) can call this function in the loop to return funds to all investors en masse.
1108     function refund(address investor) public {
1109         require(state == State.Refunding);
1110         require(deposited[investor] > 0);
1111         uint256 depositedValue = deposited[investor];
1112         deposited[investor] = 0;
1113         investor.transfer(depositedValue);
1114         Refunded(investor, depositedValue);
1115     }
1116 
1117     // Destruction of the contract with return of funds to the specified address. Available to
1118     // the owner of the contract.
1119     function del(address _wallet) external onlyOwner {
1120         selfdestruct(_wallet);
1121     }
1122 }
1123 
1124 contract DistributorRefundVault is RefundVault{
1125  
1126     address public taxCollector;
1127     uint256 public taxValue;
1128     
1129     function DistributorRefundVault(address _taxCollector, uint256 _taxValue) RefundVault() public{
1130         taxCollector = _taxCollector;
1131         taxValue = _taxValue;
1132     }
1133    
1134     function close(address _wallet) onlyOwner public {
1135     
1136         require(state == State.Active);
1137         require(_wallet != 0x0);
1138         
1139         state = State.Closed;
1140         Closed();
1141         uint256 allPay = this.balance;
1142         uint256 forTarget1;
1143         uint256 forTarget2;
1144         if(taxValue <= allPay){
1145            forTarget1 = taxValue;
1146            forTarget2 = allPay.sub(taxValue);
1147            taxValue = 0;
1148         }else {
1149             taxValue = taxValue.sub(allPay);
1150             forTarget1 = allPay;
1151             forTarget2 = 0;
1152         }
1153         if(forTarget1 != 0){
1154             taxCollector.transfer(forTarget1);
1155         }
1156        
1157         if(forTarget2 != 0){
1158             _wallet.transfer(forTarget2);
1159         }
1160 
1161     }
1162 
1163 }
1164 
1165 
1166 // (B)
1167 // The contract for freezing tokens for the team..
1168 contract SVTAllocation {
1169     using SafeMath for uint256;
1170 
1171     TokenL public token;
1172 
1173     address public owner;
1174 
1175     uint256 public unlockedAt;
1176 
1177     // The contract takes the ERC20 coin address from which this contract will work and from the
1178     // owner (Team wallet) who owns the funds.
1179     function SVTAllocation(TokenL _token, address _owner) public{
1180 
1181         // How many days to freeze from the moment of finalizing Round2
1182         unlockedAt = now + 1 years;
1183 
1184         token = _token;
1185         owner = _owner;
1186     }
1187 
1188     function changeToken(TokenL _token) external{
1189         require(msg.sender == owner);
1190         token = _token;
1191     }
1192 
1193 
1194     // If the time of freezing expired will return the funds to the owner.
1195     function unlock() external{
1196         require(now >= unlockedAt);
1197         require(token.transfer(owner,token.balanceOf(this)));
1198     }
1199 }