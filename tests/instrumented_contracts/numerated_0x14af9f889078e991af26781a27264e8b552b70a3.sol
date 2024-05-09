1 pragma solidity ^0.4.18;
2 
3 // Project: Crypt2Pos
4 // v5, 2018-02-15
5 // Copying in whole or in part is prohibited.
6 
7 // (A1)
8 // The main contract for the sale and management of rounds.
9 contract CrowdsaleL{
10 
11 	// For Round0, firstMint is:
12 	// 0000000000000000000000000000000000000000000000000000000000000000
13     
14     using SafeMath for uint256;
15 
16     enum TokenSaleType {round1, round2}
17     enum Roles {beneficiary, accountant, manager, observer, bounty, team, company}
18     
19     // Extra fee
20     address constant TaxCollector = 0x0;
21 	// fee for round 1 & 2
22     uint256[2] TaxValues = [0 finney, 0 finney];
23     uint8 vaultNum;
24 
25     TokenL public token;
26 
27     bool public isFinalized;
28     bool public isInitialized;
29     bool public isPausedCrowdsale;
30 
31 
32     // Initially, all next 7 roles/wallets are given to the Manager. The Manager is an employee of the company
33     // with knowledge of IT, who publishes the contract and sets it up. However, money and tokens require
34     // a Beneficiary and other roles (Accountant, Team, etc.). The Manager will not have the right
35     // to receive them. To enable this, the Manager must either enter specific wallets here, or perform
36     // this via method changeWallet. In the finalization methods it is written which wallet and
37     // what percentage of tokens are received.
38     address[7] public wallets = [
39         
40         // beneficiary
41         // Receives all the money (when finalizing Round1 & Round2)
42         0x9a1Fc7173086412A10dE27A9d1d543af3AB68262,
43         
44         // accountant
45         // Receives all the tokens for non-ETH investors (when finalizing Round1 & Round2)
46         0x9a1Fc7173086412A10dE27A9d1d543af3AB68262,
47         
48         // manager
49         // All rights except the rights to receive tokens or money. Has the right to change any other
50         // wallets (Beneficiary, Accountant, ...), but only if the round has not started. Once the
51         // round is initialized, the Manager has lost all rights to change the wallets.
52         // If the TokenSale is conducted by one person, then nothing needs to be changed. Permit all 7 roles
53         // point to a single wallet.
54         msg.sender,
55         
56         // observer
57         // Has only the right to call paymentsInOtherCurrency (please read the document)
58         0x8a91aC199440Da0B45B2E278f3fE616b1bCcC494,
59 
60         // bounty
61         0x9a1Fc7173086412A10dE27A9d1d543af3AB68262,
62 
63         // team
64         // When the round is finalized, all team tokens are transferred to a special freezing
65         // contract. As soon as defrosting is over, only the Team wallet will be able to
66         // collect all the tokens. It does not store the address of the freezing contract,
67         // but the final wallet of the project team.
68         0x9a1Fc7173086412A10dE27A9d1d543af3AB68262,
69         
70         // company
71         0x9a1Fc7173086412A10dE27A9d1d543af3AB68262
72         ];
73 
74     struct Profit{
75 	    uint256 min;    // percent from 0 to 50
76 	    uint256 max;    // percent from 0 to 50
77 	    uint256 step;   // percent step, from 1 to 50 (please, read doc!)
78 	    uint256 maxAllProfit; 
79     }
80     struct Bonus {
81 	    uint256 value;
82 	    uint256 procent;
83 	    uint256 freezeTime;
84     }
85 
86     Bonus[] public bonuses;
87 
88     Profit public profit = Profit(0, 20, 4, 50);
89     
90     uint256 public startTime= 1518912000; // 18 Feb
91     uint256 public endDiscountTime = 1521936000; // 25 Mar
92     uint256 public endTime = 1522800000; // 4 Apr
93 
94     // How many tokens (excluding the bonus) are transferred to the investor in exchange for 1 ETH
95     // **THOUSANDS** 10^3 for human, *10**3 for Solidity, 1e3 for MyEtherWallet (MEW).
96     // Example: if 1ETH = 40.5 Token ==> use 40500
97     uint256 public rate = 18000000;
98 
99     // If the round does not attain this value before the closing date, the round is recognized as a
100     // failure and investors take the money back (the founders will not interfere in any way).
101     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: softcap=15ETH ==> use 15*10**18 (Solidity) or 15e18 (MEW)
102     uint256 public softCap = 0 ether;
103 
104     // The maximum possible amount of income
105     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: hardcap=123.45ETH ==> use 123450*10**15 (Solidity) or 12345e15 (MEW)
106     uint256 public hardCap = 19444 ether;
107 
108     // If the last payment is slightly higher than the hardcap, then the usual contracts do
109     // not accept it, because it goes beyond the hardcap. However it is more reasonable to accept the
110     // last payment, very slightly raising the hardcap. The value indicates by how many ETH the
111     // last payment can exceed the hardcap to allow it to be paid. Immediately after this payment, the
112     // round closes. The funders should write here a small number, not more than 1% of the CAP.
113     // Can be equal to zero, to cancel.
114     // **QUINTILLIONS** 10^18 / *10**18 / 1e18
115     uint256 public overLimit = 20 ether;
116 
117     // The minimum possible payment from an investor in ETH. Payments below this value will be rejected.
118     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: minPay=0.1ETH ==> use 100*10**15 (Solidity) or 100e15 (MEW)
119     uint256 public minPay = 10 finney;
120 
121     uint256 public ethWeiRaised;
122     uint256 public nonEthWeiRaised;
123     uint256 public weiRound1;
124     uint256 public tokenReserved;
125 
126     RefundVault public vault;
127     //SVTAllocation public lockedAllocation;
128 
129     TokenSaleType TokenSale = TokenSaleType.round2;
130 
131     uint256 public allToken;
132 
133     bool public bounty;
134     bool public team;
135     bool public company;
136     //bool public partners;
137 
138     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
139 
140     event Finalized();
141     event Initialized();
142 
143     function CrowdsaleL(TokenL _token, uint256 firstMint) public
144     {
145 
146         token = _token;
147         token.setOwner();
148 
149         token.pause(); // block exchange tokens
150 
151         token.addUnpausedWallet(wallets[uint8(Roles.accountant)]);
152         token.addUnpausedWallet(msg.sender);
153         //token.addUnpausedWallet(wallets[uint8(Roles.bounty)]);
154         //token.addUnpausedWallet(wallets[uint8(Roles.company)]);
155         
156         token.setFreezingManager(wallets[uint8(Roles.accountant)]);
157         
158         bonuses.push(Bonus(11111 finney,30,60 days));
159         bonuses.push(Bonus(55556 finney,40,90 days));
160         bonuses.push(Bonus(111111 finney,50,180 days));
161 
162         if (firstMint > 0) {
163             token.mint(msg.sender, firstMint);
164         }
165 
166     }
167 
168     // Returns the name of the current round in plain text. Constant.
169     function getTokenSaleType()  public constant returns(string){
170         return (TokenSale == TokenSaleType.round1)?'round1':'round2';
171     }
172 
173     // Transfers the funds of the investor to the contract of return of funds. Internal.
174     function forwardFunds() internal {
175         vault.deposit.value(msg.value)(msg.sender);
176     }
177 
178     // Check for the possibility of buying tokens. Inside. Constant.
179     function validPurchase() internal constant returns (bool) {
180 
181         // The round started and did not end
182         bool withinPeriod = (now > startTime && now < endTime);
183 
184         // Rate is greater than or equal to the minimum
185         bool nonZeroPurchase = msg.value >= minPay;
186 
187         // hardCap is not reached, and in the event of a transaction, it will not be exceeded by more than OverLimit
188         bool withinCap = msg.value <= hardCap.sub(weiRaised()).add(overLimit);
189 
190         // round is initialized and no "Pause of trading" is set
191         return withinPeriod && nonZeroPurchase && withinCap && isInitialized && !isPausedCrowdsale;
192     }
193 
194     // Check for the ability to finalize the round. Constant.
195     function hasEnded() public constant returns (bool) {
196 
197         bool timeReached = now > endTime;
198 
199         bool capReached = weiRaised() >= hardCap;
200 
201         return (timeReached || capReached) && isInitialized;
202     }
203     
204     function finalizeAll() external {
205         finalize();
206         finalize1();
207         finalize2();
208         finalize3();
209     }
210 
211     // Finalize. Only available to the Manager and the Beneficiary. If the round failed, then
212     // anyone can call the finalization to unlock the return of funds to investors
213     // You must call a function to finalize each round (after the Round1 & after the Round2)
214     function finalize() public {
215 
216         require(wallets[uint8(Roles.manager)] == msg.sender || wallets[uint8(Roles.beneficiary)] == msg.sender || !goalReached());
217         require(!isFinalized);
218         require(hasEnded());
219 
220         isFinalized = true;
221         finalization();
222         Finalized();
223     }
224 
225     // The logic of finalization. Internal
226     function finalization() internal {
227 
228         // If the goal of the achievement
229         if (goalReached()) {
230 
231             // Send ether to Beneficiary
232             vault.close(wallets[uint8(Roles.beneficiary)]);
233 
234             // if there is anything to give
235             if (tokenReserved > 0) {
236 
237                 // Issue tokens of non-eth investors to Accountant account
238                 token.mint(wallets[uint8(Roles.accountant)],tokenReserved);
239 
240                 // Reset the counter
241                 tokenReserved = 0;
242             }
243 
244             // If the finalization is Round 1
245             if (TokenSale == TokenSaleType.round1) {
246 
247                 // Reset settings
248                 isInitialized = false;
249                 isFinalized = false;
250 
251                 // Switch to the second round (to Round2)
252                 TokenSale = TokenSaleType.round2;
253 
254                 // Reset the collection counter
255                 weiRound1 = weiRaised();
256                 ethWeiRaised = 0;
257                 nonEthWeiRaised = 0;
258 
259 
260             }
261             else // If the second round is finalized
262             {
263 
264                 // Record how many tokens we have issued
265                 allToken = token.totalSupply();
266 
267                 // Permission to collect tokens to those who can pick them up
268                 bounty = true;
269                 team = true;
270                 company = true;
271                 //partners = true;
272 
273             }
274 
275         }
276         else // If they failed round
277         {
278             // Allow investors to withdraw their funds
279             vault.enableRefunds();
280         }
281     }
282 
283     // The Manager (no-freezes) the tokens for the Team.
284     // You must call a function to finalize Round 2 (only after the Round2)
285     function finalize1() public {
286         require(wallets[uint8(Roles.manager)] == msg.sender || wallets[uint8(Roles.beneficiary)] == msg.sender);
287         require(team);
288         team = false;
289         // 14% - tokens to Team wallet after freeze (80% for investors)
290         // *** CHECK THESE NUMBERS ***
291 //        lockedAllocation = new SVTAllocation(token, wallets[uint8(Roles.team)]);
292 //        token.addUnpausedWallet(lockedAllocation);
293 //        token.mint(lockedAllocation,allToken.mul(14).div(80));
294 
295 		// no freeze
296         token.mint(wallets[uint8(Roles.team)],allToken.mul(14).div(80));
297     }
298 
299     // For bounty
300     // You must call a function to finalize Round 2 (only after the Round2)
301     function finalize2() public {
302         require(wallets[uint8(Roles.manager)] == msg.sender || wallets[uint8(Roles.beneficiary)] == msg.sender);
303         require(bounty);
304         bounty = false;
305         // 3% - tokens to bounty wallet after freeze (80% for investors)
306         // *** CHECK THESE NUMBERS ***
307         token.mint(wallets[uint8(Roles.bounty)],allToken.mul(3).div(80));
308     }
309 
310     // For marketing, referral, reserve 
311     // You must call a function to finalize Round 2 (only after the Round2)
312     function finalize3() public {
313         require(wallets[uint8(Roles.manager)] == msg.sender || wallets[uint8(Roles.beneficiary)] == msg.sender);
314         require(company);
315         company = false;
316         // 3% - tokens to company wallet after freeze (80% for investors)
317         // *** CHECK THESE NUMBERS ***
318         token.mint(wallets[uint8(Roles.company)],allToken.mul(3).div(80));
319     }
320 
321 
322     // Initializing the round. Available to the manager. After calling the function,
323     // the Manager loses all rights: Manager can not change the settings (setup), change
324     // wallets, prevent the beginning of the round, etc. You must call a function after setup
325     // for the initial round (before the Round1 and before the Round2)
326     function initialize() public {
327 
328         // Only the Manager
329         require(wallets[uint8(Roles.manager)] == msg.sender);
330 
331         // If not yet initialized
332         require(!isInitialized);
333 
334         // And the specified start time has not yet come
335         // If initialization return an error, check the start date!
336         require(now <= startTime);
337 
338         initialization();
339 
340         Initialized();
341 
342         isInitialized = true;
343     }
344 
345     function initialization() internal {
346         uint256 taxValue = TaxValues[vaultNum];
347         vaultNum++;
348         uint256 arrear;
349         if (address(vault) != 0x0){
350             arrear = DistributorRefundVault(vault).taxValue();
351             vault.del(wallets[uint8(Roles.beneficiary)]);
352         }
353         vault = new DistributorRefundVault(TaxCollector, taxValue.add(arrear));
354     }
355 
356     // At the request of the investor, we raise the funds (if the round has failed because of the hardcap)
357     function claimRefund() public{
358         vault.refund(msg.sender);
359     }
360 
361     // We check whether we collected the necessary minimum funds. Constant.
362     function goalReached() public constant returns (bool) {
363         return weiRaised() >= softCap;
364     }
365 
366     // Customize. The arguments are described in the constructor above.
367     function setup(uint256 _startTime, uint256 _endDiscountTime, uint256 _endTime, uint256 _softCap, uint256 _hardCap, uint256 _rate, uint256 _overLimit, uint256 _minPay, uint256 _minProfit, uint256 _maxProfit, uint256 _stepProfit, uint256 _maxAllProfit, uint256[] _value, uint256[] _procent, uint256[] _freezeTime) public{
368         changePeriod(_startTime, _endDiscountTime, _endTime);
369         changeTargets(_softCap, _hardCap);
370         changeRate(_rate, _overLimit, _minPay);
371         changeDiscount(_minProfit, _maxProfit, _stepProfit, _maxAllProfit);
372         setBonuses(_value, _procent, _freezeTime);
373     }
374 
375     // Change the date and time: the beginning of the round, the end of the bonus, the end of the round. Available to Manager
376     // Description in the Crowdsale constructor
377     function changePeriod(uint256 _startTime, uint256 _endDiscountTime, uint256 _endTime) public{
378 
379         require(wallets[uint8(Roles.manager)] == msg.sender);
380 
381         require(!isInitialized);
382 
383         // Date and time are correct
384         require(now <= _startTime);
385         require(_endDiscountTime > _startTime && _endDiscountTime <= _endTime);
386 
387         startTime = _startTime;
388         endTime = _endTime;
389         endDiscountTime = _endDiscountTime;
390 
391     }
392 
393     // We change the purpose of raising funds. Available to the manager.
394     // Description in the Crowdsale constructor.
395     function changeTargets(uint256 _softCap, uint256 _hardCap) public {
396 
397         require(wallets[uint8(Roles.manager)] == msg.sender);
398 
399         require(!isInitialized);
400 
401         // The parameters are correct
402         require(_softCap <= _hardCap);
403 
404         softCap = _softCap;
405         hardCap = _hardCap;
406     }
407 
408     // Change the price (the number of tokens per 1 eth), the maximum hardCap for the last bet,
409     // the minimum bet. Available to the Manager.
410     // Description in the Crowdsale constructor
411     function changeRate(uint256 _rate, uint256 _overLimit, uint256 _minPay) public {
412 
413         require(wallets[uint8(Roles.manager)] == msg.sender);
414 
415         require(!isInitialized);
416 
417         require(_rate > 0);
418 
419         rate = _rate;
420         overLimit = _overLimit;
421         minPay = _minPay;
422     }
423 
424     // We change the parameters of the discount:% min bonus,% max bonus, number of steps.
425     // Available to the manager. Description in the Crowdsale constructor
426     function changeDiscount(uint256 _minProfit, uint256 _maxProfit, uint256 _stepProfit, uint256 _maxAllProfit) public {
427 
428         require(wallets[uint8(Roles.manager)] == msg.sender);
429 
430         require(!isInitialized);
431         
432         require(_maxProfit <= _maxAllProfit);
433 
434         // The parameters are correct
435         require(_stepProfit <= _maxProfit.sub(_minProfit));
436 
437         // If not zero steps
438         if(_stepProfit > 0){
439             // We will specify the maximum percentage at which it is possible to provide
440             // the specified number of steps without fractional parts
441             profit.max = _maxProfit.sub(_minProfit).div(_stepProfit).mul(_stepProfit).add(_minProfit);
442         }else{
443             // to avoid a divide to zero error, set the bonus as static
444             profit.max = _minProfit;
445         }
446 
447         profit.min = _minProfit;
448         profit.step = _stepProfit;
449         profit.maxAllProfit = _maxAllProfit;
450     }
451 
452     function setBonuses(uint256[] _value, uint256[] _procent, uint256[] _dateUnfreeze) public {
453 
454         require(wallets[uint8(Roles.manager)] == msg.sender);
455         require(!isInitialized);
456 
457         require(_value.length == _procent.length && _value.length == _dateUnfreeze.length);
458         bonuses.length = _value.length;
459         for(uint256 i = 0; i < _value.length; i++){
460             bonuses[i] = Bonus(_value[i],_procent[i],_dateUnfreeze[i]);
461         }
462     }
463 
464     // Collected funds for the current round. Constant.
465     function weiRaised() public constant returns(uint256){
466         return ethWeiRaised.add(nonEthWeiRaised);
467     }
468 
469     // Returns the amount of fees for both phases. Constant.
470     function weiTotalRaised() public constant returns(uint256){
471         return weiRound1.add(weiRaised());
472     }
473 
474     // Returns the percentage of the bonus on the current date. Constant.
475     function getProfitPercent() public constant returns (uint256){
476         return getProfitPercentForData(now);
477     }
478 
479     // Returns the percentage of the bonus on the given date. Constant.
480     function getProfitPercentForData(uint256 timeNow) public constant returns (uint256){
481         // if the discount is 0 or zero steps, or the round does not start, we return the minimum discount
482         if (profit.max == 0 || profit.step == 0 || timeNow > endDiscountTime){
483             return profit.min;
484         }
485 
486         // if the round is over - the maximum
487         if (timeNow<=startTime){
488             return profit.max;
489         }
490 
491         // bonus period
492         uint256 range = endDiscountTime.sub(startTime);
493 
494         // delta bonus percentage
495         uint256 profitRange = profit.max.sub(profit.min);
496 
497         // Time left
498         uint256 timeRest = endDiscountTime.sub(timeNow);
499 
500         // Divide the delta of time into
501         uint256 profitProcent = profitRange.div(profit.step).mul(timeRest.mul(profit.step.add(1)).div(range));
502         return profitProcent.add(profit.min);
503     }
504 
505     function getBonuses(uint256 _value) public constant returns(uint256 procent, uint256 _dateUnfreeze){
506         if(bonuses.length == 0 || bonuses[0].value > _value){
507             return (0,0);
508         }
509         uint16 i = 1;
510         for(i; i < bonuses.length; i++){
511             if(bonuses[i].value > _value){
512                 break;
513             }
514         }
515         return (bonuses[i-1].procent,bonuses[i-1].freezeTime);
516     }
517 
518     // The ability to quickly check Round1 (only for Round1, only 1 time). Completes the Round1 by
519     // transferring the specified number of tokens to the Accountant's wallet. Available to the Manager.
520     // Use only if this is provided by the script and white paper. In the normal scenario, it
521     // does not call and the funds are raised normally. We recommend that you delete this
522     // function entirely, so as not to confuse the auditors. Initialize & Finalize not needed.
523     // ** QUINTILIONS **  10^18 / 1**18 / 1e18
524     function fastTokenSale(uint256 _totalSupply) public {
525         require(wallets[uint8(Roles.manager)] == msg.sender);
526         require(TokenSale == TokenSaleType.round1 && !isInitialized);
527         token.mint(wallets[uint8(Roles.accountant)], _totalSupply);
528         TokenSale = TokenSaleType.round2;
529     }
530 
531     // Remove the "Pause of exchange". Available to the manager at any time. If the
532     // manager refuses to remove the pause, then 30-120 days after the successful
533     // completion of the TokenSale, anyone can remove a pause and allow the exchange to continue.
534     // The manager does not interfere and will not be able to delay the term.
535     // He can only cancel the pause before the appointed time.
536     function tokenUnpause() public {
537         require(wallets[uint8(Roles.manager)] == msg.sender
538             || (now > endTime + 30 days && TokenSale == TokenSaleType.round2 && isFinalized && goalReached()));
539         token.unpause();
540     }
541 
542     // Enable the "Pause of exchange". Available to the manager until the TokenSale is completed.
543     // The manager cannot turn on the pause, for example, 3 years after the end of the TokenSale.
544     function tokenPause() public {
545         require(wallets[uint8(Roles.manager)] == msg.sender && !isFinalized);
546         token.pause();
547     }
548 
549     // Pause of sale. Available to the manager.
550     function crowdsalePause() public {
551         require(wallets[uint8(Roles.manager)] == msg.sender);
552         require(isPausedCrowdsale == false);
553         isPausedCrowdsale = true;
554     }
555 
556     // Withdrawal from the pause of sale. Available to the manager.
557     function crowdsaleUnpause() public {
558         require(wallets[uint8(Roles.manager)] == msg.sender);
559         require(isPausedCrowdsale == true);
560         isPausedCrowdsale = false;
561     }
562 
563     // Checking whether the rights to address ignore the "Pause of exchange". If the
564     // wallet is included in this list, it can translate tokens, ignoring the pause. By default,
565     // only the following wallets are included:
566     //    - Accountant wallet (he should immediately transfer tokens, but not to non-ETH investors)
567     //    - Contract for freezing the tokens for the Team (but Team wallet not included)
568     // Inside. Constant.
569     function unpausedWallet(address _wallet) internal constant returns(bool) {
570         bool _accountant = wallets[uint8(Roles.accountant)] == _wallet;
571         bool _manager = wallets[uint8(Roles.manager)] == _wallet;
572         bool _bounty = wallets[uint8(Roles.bounty)] == _wallet;
573         bool _company = wallets[uint8(Roles.company)] == _wallet;
574         return _accountant || _manager || _bounty || _company;
575     }
576 
577     // For example - After 5 years of the project's existence, all of us suddenly decided collectively
578     // (company + investors) that it would be more profitable for everyone to switch to another smart
579     // contract responsible for tokens. The company then prepares a new token, investors
580     // disassemble, study, discuss, etc. After a general agreement, the manager allows any investor:
581     //      - to burn the tokens of the previous contract
582     //      - generate new tokens for a new contract
583     // It is understood that after a general solution through this function all investors
584     // will collectively (and voluntarily) move to a new token.
585     function moveTokens(address _migrationAgent) public {
586         require(wallets[uint8(Roles.manager)] == msg.sender);
587         token.setMigrationAgent(_migrationAgent);
588     }
589 
590     function migrateAll(address[] _holders) public {
591         require(wallets[uint8(Roles.manager)] == msg.sender);
592         token.migrateAll(_holders);
593     }
594 
595     // Change the address for the specified role.
596     // Available to any wallet owner except the observer.
597     // Available to the manager until the round is initialized.
598     // The Observer's wallet or his own manager can change at any time.
599     function changeWallet(Roles _role, address _wallet) public
600     {
601         require(
602         (msg.sender == wallets[uint8(_role)] && _role != Roles.observer)
603         ||
604         (msg.sender == wallets[uint8(Roles.manager)] && (!isInitialized || _role == Roles.observer))
605         );
606         address oldWallet = wallets[uint8(_role)];
607         wallets[uint8(_role)] = _wallet;
608         if(token.unpausedWallet(oldWallet))
609             token.delUnpausedWallet(oldWallet);
610         if(unpausedWallet(_wallet))
611             token.addUnpausedWallet(_wallet);
612         
613         if(_role == Roles.accountant)
614             token.setFreezingManager(wallets[uint8(Roles.accountant)]);
615     }
616     
617     
618     // The beneficiary at any time can take rights in all roles and prescribe his wallet in all the 
619     // rollers. Thus, he will become the recipient of tokens for the role of Accountant, 
620     // Team, etc. Works at any time.
621     function resetAllWallets() public{
622         address _beneficiary = wallets[uint8(Roles.beneficiary)];
623         require(msg.sender == _beneficiary);
624         for(uint8 i = 0; i < wallets.length; i++){
625             if(token.unpausedWallet(wallets[i]))
626                 token.delUnpausedWallet(wallets[i]);
627             wallets[i] = _beneficiary;
628         }
629         token.addUnpausedWallet(_beneficiary);
630     }
631     
632 
633     // If a little more than a year has elapsed (Round2 start date + 400 days), a smart contract
634     // will allow you to send all the money to the Beneficiary, if any money is present. This is
635     // possible if you mistakenly launch the Round2 for 30 years (not 30 days), investors will transfer
636     // money there and you will not be able to pick them up within a reasonable time. It is also
637     // possible that in our checked script someone will make unforeseen mistakes, spoiling the
638     // finalization. Without finalization, money cannot be returned. This is a rescue option to
639     // get around this problem, but available only after a year (400 days).
640 
641     // Another reason - the TokenSale was a failure, but not all ETH investors took their money during the year after.
642     // Some investors may have lost a wallet key, for example.
643 
644     // The method works equally with the Round1 and Round2. When the Round1 starts, the time for unlocking
645     // the distructVault begins. If the TokenSale is then started, then the term starts anew from the first day of the TokenSale.
646 
647     // Next, act independently, in accordance with obligations to investors.
648 
649     // Within 400 days of the start of the Round, if it fails only investors can take money. After
650     // the deadline this can also include the company as well as investors, depending on who is the first to use the method.
651     function distructVault() public {
652  		if (wallets[uint8(Roles.beneficiary)] == msg.sender && (now > startTime + 400 days)) {
653  			vault.del(wallets[uint8(Roles.beneficiary)]);
654  		}
655  		if (wallets[uint8(Roles.manager)] == msg.sender && (now > startTime + 600 days)) {
656  			vault.del(wallets[uint8(Roles.manager)]);
657  		}    
658     }
659 
660 
661     // We accept payments other than Ethereum (ETH) and other currencies, for example, Bitcoin (BTC).
662     // Perhaps other types of cryptocurrency - see the original terms in the white paper and on the TokenSale website.
663 
664     // We release tokens on Ethereum. During the Round1 and Round2 with a smart contract, you directly transfer
665     // the tokens there and immediately, with the same transaction, receive tokens in your wallet.
666 
667     // When paying in any other currency, for example in BTC, we accept your money via one common wallet.
668     // Our manager fixes the amount received for the bitcoin wallet and calls the method of the smart
669     // contract paymentsInOtherCurrency to inform him how much foreign currency has been received - on a daily basis.
670     // The smart contract pins the number of accepted ETH directly and the number of BTC. Smart contract
671     // monitors softcap and hardcap, so as not to go beyond this framework.
672 
673     // In theory, it is possible that when approaching hardcap, we will receive a transfer (one or several
674     // transfers) to the wallet of BTC, that together with previously received money will exceed the hardcap in total.
675     // In this case, we will refund all the amounts above, in order not to exceed the hardcap.
676 
677     // Collection of money in BTC will be carried out via one common wallet. The wallet's address will be published
678     // everywhere (in a white paper, on the TokenSale website, on Telegram, on Bitcointalk, in this code, etc.)
679     // Anyone interested can check that the administrator of the smart contract writes down exactly the amount
680     // in ETH (in equivalent for BTC) there. In theory, the ability to bypass a smart contract to accept money in
681     // BTC and not register them in ETH creates a possibility for manipulation by the company. Thanks to
682     // paymentsInOtherCurrency however, this threat is leveled.
683 
684     // Any user can check the amounts in BTC and the variable of the smart contract that accounts for this
685     // (paymentsInOtherCurrency method). Any user can easily check the incoming transactions in a smart contract
686     // on a daily basis. Any hypothetical tricks on the part of the company can be exposed and panic during the TokenSale,
687     // simply pointing out the incompatibility of paymentsInOtherCurrency (ie, the amount of ETH + BTC collection)
688     // and the actual transactions in BTC. The company strictly adheres to the described principles of openness.
689 
690     // The company administrator is required to synchronize paymentsInOtherCurrency every working day (but you
691     // cannot synchronize if there are no new BTC payments). In the case of unforeseen problems, such as
692     // brakes on the Ethereum network, this operation may be difficult. You should only worry if the
693     // administrator does not synchronize the amount for more than 96 hours in a row, and the BTC wallet
694     // receives significant amounts.
695 
696     // This scenario ensures that for the sum of all fees in all currencies this value does not exceed hardcap.
697 
698     // BTC - 1Mzf6X9daai49B5UHvCWxUvSMpUPibATKm
699     // LTC - LKsbawSDfYuV9sfv7vFVDKMnQSP5CmNgdY
700 
701     // ** QUINTILLIONS ** 10^18 / 1**18 / 1e18
702     function paymentsInOtherCurrency(uint256 _token, uint256 _value) public {
703         require(wallets[uint8(Roles.observer)] == msg.sender || wallets[uint8(Roles.manager)] == msg.sender);
704         bool withinPeriod = (now >= startTime && now <= endTime);
705 
706         bool withinCap = _value.add(ethWeiRaised) <= hardCap.add(overLimit);
707         require(withinPeriod && withinCap && isInitialized);
708 
709         nonEthWeiRaised = _value;
710         tokenReserved = _token;
711 
712     }
713     
714     function changeLock(address _owner, uint256 _value, uint256 _date) external {
715         require(wallets[uint8(Roles.manager)] == msg.sender);
716         token.changeLock(_owner, _value, _date);
717     }
718 
719     function lokedMint(address _beneficiary, uint256 _value, uint256 _freezeTime) internal {
720         if(_freezeTime > 0){
721             
722             uint256 totalBloked = token.valueBlocked(_beneficiary).add(_value);
723             uint256 pastDateUnfreeze = token.blikedUntil(_beneficiary);
724             uint256 newDateUnfreeze = _freezeTime + now; 
725             newDateUnfreeze = (pastDateUnfreeze > newDateUnfreeze ) ? pastDateUnfreeze : newDateUnfreeze;
726 
727             token.changeLock(_beneficiary,totalBloked,newDateUnfreeze);
728         }
729         token.mint(_beneficiary,_value);
730     }
731 
732 
733     // The function for obtaining smart contract funds in ETH. If all the checks are true, the token is
734     // transferred to the buyer, taking into account the current bonus.
735     function buyTokens(address beneficiary) public payable {
736         require(beneficiary != 0x0);
737         require(validPurchase());
738 
739         uint256 weiAmount = msg.value;
740 
741         uint256 ProfitProcent = getProfitPercent();
742 
743         var (bonus, dateUnfreeze) = getBonuses(weiAmount);
744         
745         // Scenario 1 - select max from all bonuses + check profit.maxAllProfit
746         uint256 totalProfit = ProfitProcent;
747         totalProfit = (totalProfit < bonus) ? bonus : totalProfit;
748         totalProfit = (totalProfit > profit.maxAllProfit) ? profit.maxAllProfit : totalProfit;
749         
750         // Scenario 2 - sum both bonuses + check profit.maxAllProfit
751         //uint256 totalProfit = bonus.add(ProfitProcent);
752         //totalProfit = (totalProfit > profit.maxAllProfit)? profit.maxAllProfit: totalProfit;
753         
754         // calculate token amount to be created
755         uint256 tokens = weiAmount.mul(rate).mul(totalProfit + 100).div(100000);
756 
757         // update state
758         ethWeiRaised = ethWeiRaised.add(weiAmount);
759 
760         lokedMint(beneficiary, tokens, dateUnfreeze);
761 
762         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
763 
764         forwardFunds();
765     }
766 
767     // buyTokens alias
768     function () public payable {
769         buyTokens(msg.sender);
770     }
771 
772 }
773 
774 
775 /**
776  * @title SafeMath
777  * @dev Math operations with safety checks that throw on error
778  */
779 library SafeMath {
780     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
781         uint256 c = a * b;
782         assert(a == 0 || c / a == b);
783         return c;
784     }
785 
786     function div(uint256 a, uint256 b) internal pure returns (uint256) {
787         // assert(b > 0); // Solidity automatically throws when dividing by 0
788         uint256 c = a / b;
789         // assert(a == b * c + a % b); // There is no case in which this does not hold
790         return c;
791     }
792 
793     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
794         assert(b <= a);
795         return a - b;
796     }
797 
798     function add(uint256 a, uint256 b) internal pure returns (uint256) {
799         uint256 c = a + b;
800         assert(c >= a);
801         return c;
802     }
803 }
804 
805 /**
806  * @title Ownable
807  * @dev The Ownable contract has an owner address, and provides basic authorization control
808  * functions, this simplifies the implementation of "user permissions".
809  */
810 contract Ownable {
811     address public owner;
812 
813 
814     /**
815      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
816      * account.
817      */
818     function Ownable() public {
819         owner = msg.sender;
820     }
821 
822 
823     /**
824      * @dev Throws if called by any account other than the owner.
825      */
826     modifier onlyOwner() {
827         require(msg.sender == owner);
828         _;
829     }
830 
831 
832     /**
833      * @dev Allows the current owner to transfer control of the contract to a newOwner.
834      * @param newOwner The address to transfer ownership to.
835      */
836     function transferOwnership(address newOwner) onlyOwner public{
837         require(newOwner != address(0));
838         owner = newOwner;
839     }
840 
841 }
842 
843 /**
844  * @title Pausable
845  * @dev Base contract which allows children to implement an emergency stop mechanism.
846  */
847 contract Pausable is Ownable {
848     event Pause();
849     event Unpause();
850 
851     bool _paused = false;
852 
853     function paused() public constant returns(bool)
854     {
855         return _paused;
856     }
857 
858 
859     /**
860      * @dev modifier to allow actions only when the contract IS paused
861      */
862     modifier whenNotPaused() {
863         require(!paused());
864         _;
865     }
866 
867     /**
868      * @dev called by the owner to pause, triggers stopped state
869      */
870     function pause() onlyOwner public {
871         require(!_paused);
872         _paused = true;
873         Pause();
874     }
875 
876     /**
877      * @dev called by the owner to unpause, returns to normal state
878      */
879     function unpause() onlyOwner public {
880         require(_paused);
881         _paused = false;
882         Unpause();
883     }
884 }
885 
886 
887 // Contract interface for transferring current tokens to another
888 contract MigrationAgent
889 {
890     function migrateFrom(address _from, uint256 _value) public;
891 }
892 
893 contract BlockedToken is Ownable {
894     using SafeMath for uint256;
895 
896     struct locked {uint256 value; uint256 date;}
897 
898     mapping (address => locked) locks;
899 
900     function blikedUntil(address _owner) external constant returns (uint256) {
901         if(now < locks[_owner].date)
902         {
903             return locks[_owner].date;
904         }else{
905             return 0;
906         }
907     }
908 
909     function valueBlocked(address _owner) public constant returns (uint256) {
910         if(now < locks[_owner].date)
911         {
912             return locks[_owner].value;
913         }else{
914             return 0;
915         }
916     }
917 
918     function changeLock(address _owner, uint256 _value, uint256 _date) external onlyOwner {
919         locks[_owner] = locked(_value,_date);
920     }
921 }
922 
923 
924 // (A2)
925 // Contract token
926 contract TokenL is Pausable, BlockedToken {
927     using SafeMath for uint256;
928 
929     string public constant name = "Crypt2Pos";
930     string public constant symbol = "CRPOS";
931     uint8 public constant decimals = 18;
932 
933     uint256 public totalSupply;
934 
935     mapping (address => uint256) balances;
936     mapping (address => mapping (address => uint256)) allowed;
937 
938     mapping (address => bool) public unpausedWallet;
939 
940     bool public mintingFinished = false;
941 
942     uint256 public totalMigrated;
943     address public migrationAgent;
944     
945     address public freezingManager;
946     mapping (address => bool) public freezingAgent;
947 
948     event Transfer(address indexed from, address indexed to, uint256 value);
949     event Approval(address indexed owner, address indexed spender, uint256 value);
950 
951     event Mint(address indexed to, uint256 amount);
952     event MintFinished();
953 
954     event Migrate(address indexed _from, address indexed _to, uint256 _value);
955 
956     modifier canMint() {
957         require(!mintingFinished);
958         _;
959     }
960 
961     function TokenL() public{
962         owner = 0x0;
963     }
964 
965     function setOwner() public{
966         require(owner == 0x0);
967         owner = msg.sender;
968     }
969     
970     function setFreezingManager(address _newAddress) external {
971         require(msg.sender == owner || msg.sender == freezingManager);
972         freezingAgent[freezingManager] = false;
973         freezingManager = _newAddress;
974         freezingAgent[freezingManager] = true;
975     }
976     
977     function changeFreezingAgent(address _agent, bool _right) external {
978         require(msg.sender == freezingManager);
979         freezingAgent[_agent] = _right;
980     }
981     
982     function transferAndFreeze(address _to, uint256 _value, uint256 _when) external {
983         require(freezingAgent[msg.sender]);
984         if(_when > 0){
985             locked storage _locked = locks[_to];
986             _locked.value = valueBlocked(_to).add(_value);
987             _locked.date = (_locked.date > _when)? _locked.date: _when;
988         }
989         transfer(_to,_value);
990     }
991 
992     // Balance of the specified address
993     function balanceOf(address _owner) public constant returns (uint256 balance) {
994         return balances[_owner];
995     }
996 
997 
998     // Transfer of tokens from one account to another
999     function transfer(address _to, uint256 _value) public returns (bool) {
1000         require(!paused()||unpausedWallet[msg.sender]||unpausedWallet[_to]);
1001         uint256 available = balances[msg.sender].sub(valueBlocked(msg.sender));
1002         require(_value <= available);
1003         require (_value > 0);
1004         balances[msg.sender] = balances[msg.sender].sub(_value);
1005         balances[_to] = balances[_to].add(_value);
1006         Transfer(msg.sender, _to, _value);
1007         return true;
1008     }
1009 
1010     // Returns the number of tokens that _owner trusted to spend from his account _spender
1011     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
1012         return allowed[_owner][_spender];
1013     }
1014 
1015     // Trust _sender and spend _value tokens from your account
1016     function approve(address _spender, uint256 _value) public returns (bool) {
1017 
1018         // To change the approve amount you first have to reduce the addresses
1019         //  allowance to zero by calling `approve(_spender, 0)` if it is not
1020         //  already 0 to mitigate the race condition described here:
1021         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1022         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
1023 
1024         allowed[msg.sender][_spender] = _value;
1025         Approval(msg.sender, _spender, _value);
1026         return true;
1027     }
1028 
1029     // Transfer of tokens from the trusted address _from to the address _to in the number _value
1030     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
1031         require(!paused()||unpausedWallet[msg.sender]||unpausedWallet[_to]);
1032         uint256 available = balances[_from].sub(valueBlocked(_from));
1033         require(_value <= available);
1034 
1035         var _allowance = allowed[_from][msg.sender];
1036 
1037         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
1038         // require (_value <= _allowance);
1039 
1040         require (_value > 0);
1041 
1042         balances[_from] = balances[_from].sub(_value);
1043         balances[_to] = balances[_to].add(_value);
1044         allowed[_from][msg.sender] = _allowance.sub(_value);
1045         Transfer(_from, _to, _value);
1046         return true;
1047     }
1048 
1049     // Issue new tokens to the address _to in the amount _amount. Available to the owner of the contract (contract Crowdsale)
1050     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
1051         totalSupply = totalSupply.add(_amount);
1052         balances[_to] = balances[_to].add(_amount);
1053         Mint(_to, _amount);
1054         Transfer(0x0, _to, _amount);
1055         return true;
1056     }
1057 
1058     // Stop the release of tokens. This is not possible to cancel. Available to the owner of the contract.
1059     function finishMinting() public onlyOwner returns (bool) {
1060     	mintingFinished = true;
1061         MintFinished();
1062         return true;
1063     }
1064 
1065     // Redefinition of the method of the returning status of the "Exchange pause".
1066     // Never for the owner of an unpaused wallet.
1067     function paused() public constant returns(bool) {
1068         return super.paused();
1069     }
1070 
1071     // Add a wallet ignoring the "Exchange pause". Available to the owner of the contract.
1072     function addUnpausedWallet(address _wallet) public onlyOwner {
1073         unpausedWallet[_wallet] = true;
1074     }
1075 
1076     // Remove the wallet ignoring the "Exchange pause". Available to the owner of the contract.
1077     function delUnpausedWallet(address _wallet) public onlyOwner {
1078         unpausedWallet[_wallet] = false;
1079     }
1080 
1081     // Enable the transfer of current tokens to others. Only 1 time. Disabling this is not possible.
1082     // Available to the owner of the contract.
1083     function setMigrationAgent(address _migrationAgent) public onlyOwner {
1084         require(migrationAgent == 0x0);
1085         migrationAgent = _migrationAgent;
1086     }
1087 
1088     function migrateAll(address[] _holders) public onlyOwner {
1089         require(migrationAgent != 0x0);
1090         uint256 total = 0;
1091         uint256 value;
1092         for(uint i = 0; i < _holders.length; i++){
1093             value = balances[_holders[i]];
1094             if(value > 0){
1095                 balances[_holders[i]] = 0;
1096                 total = total.add(value);
1097                 MigrationAgent(migrationAgent).migrateFrom(_holders[i], value);
1098                 Migrate(_holders[i],migrationAgent,value);
1099             }
1100             totalSupply = totalSupply.sub(total);
1101             totalMigrated = totalMigrated.add(total);
1102         }
1103     }
1104 
1105     function migration(address _holder) internal {
1106         require(migrationAgent != 0x0);
1107         uint256 value = balances[_holder];
1108         require(value > 0);
1109         balances[_holder] = 0;
1110         totalSupply = totalSupply.sub(value);
1111         totalMigrated = totalMigrated.add(value);
1112         MigrationAgent(migrationAgent).migrateFrom(_holder, value);
1113         Migrate(_holder,migrationAgent,value);
1114 
1115     }
1116 
1117     // Reissue your tokens.
1118     function migrate() public
1119     {
1120         migration(msg.sender);
1121     }
1122 }
1123 
1124 
1125 // (A3)
1126 // Contract for freezing of investors' funds. Hence, investors will be able to withdraw money if the
1127 // round does not attain the softcap. From here the wallet of the beneficiary will receive all the
1128 // money (namely, the beneficiary, not the manager's wallet).
1129 contract RefundVault is Ownable {
1130     using SafeMath for uint256;
1131 
1132     enum State { Active, Refunding, Closed }
1133 
1134     mapping (address => uint256) public deposited;
1135     State public state;
1136 
1137     event Closed();
1138     event RefundsEnabled();
1139     event Refunded(address indexed beneficiary, uint256 weiAmount);
1140     event Deposited(address indexed beneficiary, uint256 weiAmount);
1141 
1142     function RefundVault() public {
1143         state = State.Active;
1144     }
1145 
1146     // Depositing funds on behalf of an TokenSale investor. Available to the owner of the contract (Crowdsale Contract).
1147     function deposit(address investor) onlyOwner public payable {
1148         require(state == State.Active);
1149         deposited[investor] = deposited[investor].add(msg.value);
1150         Deposited(investor,msg.value);
1151     }
1152 
1153     // Move the collected funds to a specified address. Available to the owner of the contract.
1154     function close(address _wallet) onlyOwner public {
1155         require(state == State.Active);
1156         require(_wallet != 0x0);
1157         state = State.Closed;
1158         Closed();
1159         _wallet.transfer(this.balance);
1160     }
1161 
1162     // Allow refund to investors. Available to the owner of the contract.
1163     function enableRefunds() onlyOwner public {
1164         require(state == State.Active);
1165         state = State.Refunding;
1166         RefundsEnabled();
1167     }
1168 
1169     // Return the funds to a specified investor. In case of failure of the round, the investor
1170     // should call this method of this contract (RefundVault) or call the method claimRefund of Crowdsale
1171     // contract. This function should be called either by the investor himself, or the company
1172     // (or anyone) can call this function in the loop to return funds to all investors en masse.
1173     function refund(address investor) public {
1174         require(state == State.Refunding);
1175         require(deposited[investor] > 0);
1176         uint256 depositedValue = deposited[investor];
1177         deposited[investor] = 0;
1178         investor.transfer(depositedValue);
1179         Refunded(investor, depositedValue);
1180     }
1181 
1182     // Destruction of the contract with return of funds to the specified address. Available to
1183     // the owner of the contract.
1184     function del(address _wallet) external onlyOwner {
1185         selfdestruct(_wallet);
1186     }
1187 }
1188 
1189 contract DistributorRefundVault is RefundVault{
1190  
1191     address public taxCollector;
1192     uint256 public taxValue;
1193     
1194     function DistributorRefundVault(address _taxCollector, uint256 _taxValue) RefundVault() public{
1195         taxCollector = _taxCollector;
1196         taxValue = _taxValue;
1197     }
1198    
1199     function close(address _wallet) onlyOwner public {
1200     
1201         require(state == State.Active);
1202         require(_wallet != 0x0);
1203         
1204         state = State.Closed;
1205         Closed();
1206         uint256 allPay = this.balance;
1207         uint256 forTarget1;
1208         uint256 forTarget2;
1209         if(taxValue <= allPay){
1210            forTarget1 = taxValue;
1211            forTarget2 = allPay.sub(taxValue);
1212            taxValue = 0;
1213         }else {
1214             taxValue = taxValue.sub(allPay);
1215             forTarget1 = allPay;
1216             forTarget2 = 0;
1217         }
1218         if(forTarget1 != 0){
1219             taxCollector.transfer(forTarget1);
1220         }
1221        
1222         if(forTarget2 != 0){
1223             _wallet.transfer(forTarget2);
1224         }
1225 
1226     }
1227 
1228 }
1229 
1230 
1231 // (B)
1232 // The contract for freezing tokens for the team..
1233 //contract SVTAllocation {
1234 //    using SafeMath for uint256;
1235 //
1236 //    TokenL public token;
1237 //
1238 //    address public owner;
1239 //
1240 //    uint256 public unlockedAt;
1241 //
1242 //    // The contract takes the ERC20 coin address from which this contract will work and from the
1243 //    // owner (Team wallet) who owns the funds.
1244 //    function SVTAllocation(TokenL _token, address _owner) public{
1245 //
1246 //        // How many days to freeze from the moment of finalizing Round2
1247 //        unlockedAt = now + 1 years;
1248 //
1249 //        token = _token;
1250 //        owner = _owner;
1251 //    }
1252 //
1253 //    function changeToken(TokenL _token) external{
1254 //        require(msg.sender == owner);
1255 //        token = _token;
1256 //    }
1257 //
1258 //
1259 //    // If the time of freezing expired will return the funds to the owner.
1260 //    function unlock() external{
1261 //        require(now >= unlockedAt);
1262 //        require(token.transfer(owner,token.balanceOf(this)));
1263 //    }
1264 //}