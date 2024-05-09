1 // Project: Proof of Toss - https://toss.pro
2 // v12, 2018-04-23
3 // Authors: Ivan Fedorov and Dmitry Borodin
4 // Copying in whole or in part is prohibited.
5 
6 pragma solidity ^0.4.21;
7 
8 // (A1)
9 // The main contract for the sale and management of rounds.
10 // 0000000000000000000000000000000000000000000000000000000000000000
11 contract Crowdsale{
12 
13     uint256 constant USER_UNPAUSE_TOKEN_TIMEOUT =  60 days;
14     uint256 constant FORCED_REFUND_TIMEOUT1     = 400 days;
15     uint256 constant FORCED_REFUND_TIMEOUT2     = 600 days;
16     uint256 constant ROUND_PROLONGATE           =   0 days;
17     uint256 constant BURN_TOKENS_TIME           =  90 days;
18 
19     using SafeMath for uint256;
20 
21     enum TokenSaleType {round1, round2}
22     TokenSaleType public TokenSale = TokenSaleType.round2;
23 
24     //              0             1         2        3        4        5      6       7        8     9
25     enum Roles {beneficiary, accountant, manager, observer, bounty, company, team, founders, fund, fees}
26 
27     Creator public creator;
28     bool creator2;
29     bool isBegin=false;
30     Token public token;
31     RefundVault public vault;
32     AllocationTOSS public allocation;
33 
34     bool public isFinalized;
35     bool public isInitialized;
36     bool public isPausedCrowdsale;
37     bool public chargeBonuses;
38     bool public canFirstMint=true;
39 
40     // Initially, all next 7+ roles/wallets are given to the Manager. The Manager is an employee of the company
41     // with knowledge of IT, who publishes the contract and sets it up. However, money and tokens require
42     // a Beneficiary and other roles (Accountant, Team, etc.). The Manager will not have the right
43     // to receive them. To enable this, the Manager must either enter specific wallets here, or perform
44     // this via method changeWallet. In the finalization methods it is written which wallet and
45     // what percentage of tokens are received.
46     address[10] public wallets = [
47 
48         // Beneficiary
49         // Receives all the money (when finalizing Round1 & Round2)
50         0xAa951F7c52055B89d3F281c73d557275070cBBfb,
51 
52         // Accountant
53         // Receives all the tokens for non-ETH investors (when finalizing Round1 & Round2)
54         0xD29f0aE1621F4Be48C4DF438038E38af546DA498,
55 
56         // Manager
57         // All rights except the rights to receive tokens or money. Has the right to change any other
58         // wallets (Beneficiary, Accountant, ...), but only if the round has not started. Once the
59         // round is initialized, the Manager has lost all rights to change the wallets.
60         // If the TokenSale is conducted by one person, then nothing needs to be changed. Permit all 7 roles
61         // point to a single wallet.
62         msg.sender,
63 
64         // Observer
65         // Has only the right to call paymentsInOtherCurrency (please read the document)
66         0x8a91aC199440Da0B45B2E278f3fE616b1bCcC494,
67 
68         // Bounty - 7% tokens
69         0xd7AC0393e2B29D8aC6221CF69c27171aba6278c4,
70 
71         // Company, White list 1%
72         0x765f60E314766Bc25eb2a9F66991Fe867D42A449,
73 
74         // Team, 6%, freeze 1+1 year
75         0xF9f0c53c07803a2670a354F3de88482393ABdBac,
76 
77         // Founders, 10% freeze 1+1 year
78         0x61628D884b5F137c3D3e0b04b90DaE4402f32510,
79 
80         // Fund, 6%
81         0xd833899Ea1b84E980daA13553CE13D1512bF0774,
82 
83         // Fees, 7% money
84         0xEB29e654AFF7658394C9d413dDC66711ADD44F59
85 
86     ];
87 
88 
89 
90     struct Bonus {
91         uint256 value;
92         uint256 procent;
93         uint256 freezeTime;
94     }
95 
96     struct Profit {
97         uint256 percent;
98         uint256 duration;
99     }
100 
101     struct Freezed {
102         uint256 value;
103         uint256 dateTo;
104     }
105 
106     Bonus[] public bonuses;
107     Profit[] public profits;
108 
109 
110     uint256 public startTime= 1524560400;
111     uint256 public endTime  = 1529830799;
112     uint256 public renewal;
113 
114     // How many tokens (excluding the bonus) are transferred to the investor in exchange for 1 ETH
115     // **QUINTILLIONS** 10^18 for human, *10**18 for Solidity, 1e18 for MyEtherWallet (MEW).
116     // Example: if 1ETH = 40.5 Token ==> use 40500 finney
117     uint256 public rate = 10000 ether;
118 
119     // ETH/USD rate in US$
120     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: ETH/USD=$1000 ==> use 1000*10**18 (Solidity) or 1000 ether or 1000e18 (MEW)
121     uint256 public exchange  = 700 ether; // not in use
122 
123     // If the round does not attain this value before the closing date, the round is recognized as a
124     // failure and investors take the money back (the founders will not interfere in any way).
125     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: softcap=15ETH ==> use 15*10**18 (Solidity) or 15e18 (MEW)
126     uint256 public softCap = 8500 ether;
127 
128     // The maximum possible amount of income
129     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: hardcap=123.45ETH ==> use 123450*10**15 (Solidity) or 12345e15 (MEW)
130     uint256 public hardCap = 71500 ether;
131 
132     // If the last payment is slightly higher than the hardcap, then the usual contracts do
133     // not accept it, because it goes beyond the hardcap. However it is more reasonable to accept the
134     // last payment, very slightly raising the hardcap. The value indicates by how many ETH the
135     // last payment can exceed the hardcap to allow it to be paid. Immediately after this payment, the
136     // round closes. The funders should write here a small number, not more than 1% of the CAP.
137     // Can be equal to zero, to cancel.
138     // **QUINTILLIONS** 10^18 / *10**18 / 1e18
139     uint256 public overLimit = 20 ether;
140 
141     // The minimum possible payment from an investor in ETH. Payments below this value will be rejected.
142     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: minPay=0.1ETH ==> use 100*10**15 (Solidity) or 100e15 (MEW)
143     uint256 public minPay = 71 finney;
144 
145     uint256 public maxAllProfit = 30;
146 
147     uint256 public ethWeiRaised;
148     uint256 public nonEthWeiRaised;
149     uint256 public weiRound1;
150     uint256 public tokenReserved;
151 
152     uint256 public totalSaledToken;
153 
154     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
155 
156     event Finalized();
157     event Initialized();
158 
159     function Crowdsale(Creator _creator) public
160     {
161         creator2=true;
162         creator=_creator;
163     }
164 
165     function onlyAdmin(bool forObserver) internal view {
166         require(wallets[uint8(Roles.manager)] == msg.sender || wallets[uint8(Roles.beneficiary)] == msg.sender ||
167             forObserver==true && wallets[uint8(Roles.observer)] == msg.sender);
168     }
169 
170     // Setting of basic parameters, analog of class constructor
171     // @ Do I have to use the function      see your scenario
172     // @ When it is possible to call        before Round 1/2
173     // @ When it is launched automatically  -
174     // @ Who can call the function          admins
175     function begin() internal
176     {
177         if (isBegin) return;
178         isBegin=true;
179 
180         token = creator.createToken();
181         if (creator2) {
182             vault = creator.createRefund();
183         }
184 
185         token.setUnpausedWallet(wallets[uint8(Roles.accountant)], true);
186         token.setUnpausedWallet(wallets[uint8(Roles.manager)], true);
187         token.setUnpausedWallet(wallets[uint8(Roles.bounty)], true);
188         token.setUnpausedWallet(wallets[uint8(Roles.company)], true);
189         token.setUnpausedWallet(wallets[uint8(Roles.observer)], true);
190 
191         bonuses.push(Bonus(71 ether, 30, 30*5 days));
192 
193         profits.push(Profit(15,1 days));
194         profits.push(Profit(10,2 days));
195         profits.push(Profit(5, 4 days));
196 
197     }
198 
199 
200 
201     // Issue of tokens for the zero round, it is usually called: private pre-sale (Round 0)
202     // @ Do I have to use the function      may be
203     // @ When it is possible to call        before Round 1/2
204     // @ When it is launched automatically  -
205     // @ Who can call the function          admins
206     function firstMintRound0(uint256 _amount) public {
207         onlyAdmin(false);
208         require(canFirstMint);
209         begin();
210         token.mint(wallets[uint8(Roles.accountant)],_amount);
211     }
212 
213     // info
214     function totalSupply() external view returns (uint256){
215         return token.totalSupply();
216     }
217 
218     // Returns the name of the current round in plain text. Constant.
219     function getTokenSaleType() external view returns(string){
220         return (TokenSale == TokenSaleType.round1)?'round1':'round2';
221     }
222 
223     // Transfers the funds of the investor to the contract of return of funds. Internal.
224     function forwardFunds() internal {
225         if(address(vault) != 0x0){
226             vault.deposit.value(msg.value)(msg.sender);
227         }else {
228             if(address(this).balance > 0){
229                 wallets[uint8(Roles.beneficiary)].transfer(address(this).balance);
230             }
231         }
232 
233     }
234 
235     // Check for the possibility of buying tokens. Inside. Constant.
236     function validPurchase() internal view returns (bool) {
237 
238         // The round started and did not end
239         bool withinPeriod = (now > startTime && now < endTime.add(renewal));
240 
241         // Rate is greater than or equal to the minimum
242         bool nonZeroPurchase = msg.value >= minPay;
243 
244         // hardCap is not reached, and in the event of a transaction, it will not be exceeded by more than OverLimit
245         bool withinCap = msg.value <= hardCap.sub(weiRaised()).add(overLimit);
246 
247         // round is initialized and no "Pause of trading" is set
248         return withinPeriod && nonZeroPurchase && withinCap && isInitialized && !isPausedCrowdsale;
249     }
250 
251     // Check for the ability to finalize the round. Constant.
252     function hasEnded() public view returns (bool) {
253 
254         bool timeReached = now > endTime.add(renewal);
255 
256         bool capReached = weiRaised() >= hardCap;
257 
258         return (timeReached || capReached) && isInitialized;
259     }
260 
261     // Finalize. Only available to the Manager and the Beneficiary. If the round failed, then
262     // anyone can call the finalization to unlock the return of funds to investors
263     // You must call a function to finalize each round (after the Round1 & after the Round2)
264     // @ Do I have to use the function      yes
265     // @ When it is possible to call        after end of Round1 & Round2
266     // @ When it is launched automatically  no
267     // @ Who can call the function          admins or anybody (if round is failed)
268     function finalize() public {
269 
270         require(wallets[uint8(Roles.manager)] == msg.sender || wallets[uint8(Roles.beneficiary)] == msg.sender || !goalReached());
271         require(!isFinalized);
272         require(hasEnded() || ((wallets[uint8(Roles.manager)] == msg.sender || wallets[uint8(Roles.beneficiary)] == msg.sender) && goalReached()));
273 
274         isFinalized = true;
275         finalization();
276         emit Finalized();
277     }
278 
279     // The logic of finalization. Internal
280     // @ Do I have to use the function      no
281     // @ When it is possible to call        -
282     // @ When it is launched automatically  after end of round
283     // @ Who can call the function          -
284     function finalization() internal {
285 
286         //uint256 feesValue;
287         // If the goal of the achievement
288         if (goalReached()) {
289 
290             if(address(vault) != 0x0){
291                 // Send ether to Beneficiary
292                 vault.close(wallets[uint8(Roles.beneficiary)], wallets[uint8(Roles.fees)], ethWeiRaised.mul(7).div(100)); //7% for fees
293             }
294 
295             // if there is anything to give
296             if (tokenReserved > 0) {
297 
298                 token.mint(wallets[uint8(Roles.accountant)],tokenReserved);
299 
300                 // Reset the counter
301                 tokenReserved = 0;
302             }
303 
304             // If the finalization is Round 1
305             if (TokenSale == TokenSaleType.round1) {
306 
307                 // Reset settings
308                 isInitialized = false;
309                 isFinalized = false;
310 
311                 // Switch to the second round (to Round2)
312                 TokenSale = TokenSaleType.round2;
313 
314                 // Reset the collection counter
315                 weiRound1 = weiRaised();
316                 ethWeiRaised = 0;
317                 nonEthWeiRaised = 0;
318 
319 
320 
321             }
322             else // If the second round is finalized
323             {
324 
325                 // Permission to collect tokens to those who can pick them up
326                 chargeBonuses = true;
327 
328                 totalSaledToken = token.totalSupply();
329 
330             }
331 
332         }
333         else if (address(vault) != 0x0) // If they failed round
334         {
335             // Allow investors to withdraw their funds
336 
337             vault.enableRefunds();
338         }
339     }
340 
341     // The Manager freezes the tokens for the Team.
342     // You must call a function to finalize Round 2 (only after the Round2)
343     // @ Do I have to use the function      yes
344     // @ When it is possible to call        Round2
345     // @ When it is launched automatically  -
346     // @ Who can call the function          admins
347     function finalize2() public {
348 
349         onlyAdmin(false);
350         require(chargeBonuses);
351         chargeBonuses = false;
352 
353         allocation = creator.createAllocation(token, now + 1 years /* stage N1 */, now + 2 years /* stage N2 */);
354         token.setUnpausedWallet(allocation, true);
355 
356         // Team = 6%, Founders = 10%, Fund = 6%    TOTAL = 22%
357         allocation.addShare(wallets[uint8(Roles.team)],       6,  50); // only 50% - first year, stage N1  (and +50 for stage N2)
358         allocation.addShare(wallets[uint8(Roles.founders)],  10,  50); // only 50% - first year, stage N1  (and +50 for stage N2)
359         allocation.addShare(wallets[uint8(Roles.fund)],       6, 100); // 100% - first year
360 
361         // 22% - tokens to freeze contract (Team+Founders+Fund)
362         token.mint(allocation, totalSaledToken.mul(22).div(70));
363 
364         // 7% - tokens to Bounty wallet
365         token.mint(wallets[uint8(Roles.bounty)], totalSaledToken.mul(7).div(70));
366 
367         // 1% - tokens to Company (White List) wallet
368         token.mint(wallets[uint8(Roles.company)], totalSaledToken.mul(1).div(70));
369 
370     }
371 
372 
373 
374     // Initializing the round. Available to the manager. After calling the function,
375     // the Manager loses all rights: Manager can not change the settings (setup), change
376     // wallets, prevent the beginning of the round, etc. You must call a function after setup
377     // for the initial round (before the Round1 and before the Round2)
378     // @ Do I have to use the function      yes
379     // @ When it is possible to call        before each round
380     // @ When it is launched automatically  -
381     // @ Who can call the function          admins
382     function initialize() public {
383 
384         onlyAdmin(false);
385         // If not yet initialized
386         require(!isInitialized);
387         begin();
388 
389 
390         // And the specified start time has not yet come
391         // If initialization return an error, check the start date!
392         require(now <= startTime);
393 
394         initialization();
395 
396         emit Initialized();
397 
398         isInitialized = true;
399         renewal = 0;
400         canFirstMint = false;
401     }
402 
403     function initialization() internal {
404         if (address(vault) != 0x0 && vault.state() != RefundVault.State.Active){
405             vault.restart();
406         }
407     }
408 
409     // At the request of the investor, we raise the funds (if the round has failed because of the hardcap)
410     // @ Do I have to use the function      no
411     // @ When it is possible to call        if round is failed (softcap not reached)
412     // @ When it is launched automatically  -
413     // @ Who can call the function          all investors
414     function claimRefund() external {
415         require(address(vault) != 0x0);
416         vault.refund(msg.sender);
417     }
418 
419     // We check whether we collected the necessary minimum funds. Constant.
420     function goalReached() public view returns (bool) {
421         return weiRaised() >= softCap;
422     }
423 
424 
425     // Customize. The arguments are described in the constructor above.
426     // @ Do I have to use the function      yes
427     // @ When it is possible to call        before each rond
428     // @ When it is launched automatically  -
429     // @ Who can call the function          admins
430     function setup(uint256 _startTime, uint256 _endTime, uint256 _softCap, uint256 _hardCap,
431         uint256 _rate, uint256 _exchange,
432         uint256 _maxAllProfit, uint256 _overLimit, uint256 _minPay,
433         uint256[] _durationTB , uint256[] _percentTB, uint256[] _valueVB, uint256[] _percentVB, uint256[] _freezeTimeVB) public
434     {
435 
436         onlyAdmin(false);
437         require(!isInitialized);
438 
439         begin();
440 
441         // Date and time are correct
442         require(now <= _startTime);
443         require(_startTime < _endTime);
444         startTime = _startTime;
445         endTime = _endTime;
446 
447         // The parameters are correct
448         require(_softCap <= _hardCap);
449         softCap = _softCap;
450         hardCap = _hardCap;
451 
452         require(_rate > 0);
453         rate = _rate;
454 
455         overLimit = _overLimit;
456         minPay = _minPay;
457         exchange = _exchange;
458         maxAllProfit = _maxAllProfit;
459 
460         require(_valueVB.length == _percentVB.length && _valueVB.length == _freezeTimeVB.length);
461         bonuses.length = _valueVB.length;
462         for(uint256 i = 0; i < _valueVB.length; i++){
463             bonuses[i] = Bonus(_valueVB[i],_percentVB[i],_freezeTimeVB[i]);
464         }
465 
466         require(_percentTB.length == _durationTB.length);
467         profits.length = _percentTB.length;
468         for( i = 0; i < _percentTB.length; i++){
469             profits[i] = Profit(_percentTB[i],_durationTB[i]);
470         }
471 
472     }
473 
474     // Collected funds for the current round. Constant.
475     function weiRaised() public constant returns(uint256){
476         return ethWeiRaised.add(nonEthWeiRaised);
477     }
478 
479     // Returns the amount of fees for both phases. Constant.
480     function weiTotalRaised() external constant returns(uint256){
481         return weiRound1.add(weiRaised());
482     }
483 
484     // Returns the percentage of the bonus on the current date. Constant.
485     function getProfitPercent() public constant returns (uint256){
486         return getProfitPercentForData(now);
487     }
488 
489     // Returns the percentage of the bonus on the given date. Constant.
490     function getProfitPercentForData(uint256 _timeNow) public constant returns (uint256){
491         uint256 allDuration;
492         for(uint8 i = 0; i < profits.length; i++){
493             allDuration = allDuration.add(profits[i].duration);
494             if(_timeNow < startTime.add(allDuration)){
495                 return profits[i].percent;
496             }
497         }
498         return 0;
499     }
500 
501     function getBonuses(uint256 _value) public constant returns (uint256,uint256,uint256){
502         if(bonuses.length == 0 || bonuses[0].value > _value){
503             return (0,0,0);
504         }
505         uint16 i = 1;
506         for(i; i < bonuses.length; i++){
507             if(bonuses[i].value > _value){
508                 break;
509             }
510         }
511         return (bonuses[i-1].value,bonuses[i-1].procent,bonuses[i-1].freezeTime);
512     }
513 
514     // Remove the "Pause of exchange". Available to the manager at any time. If the
515     // manager refuses to remove the pause, then 30-120 days after the successful
516     // completion of the TokenSale, anyone can remove a pause and allow the exchange to continue.
517     // The manager does not interfere and will not be able to delay the term.
518     // He can only cancel the pause before the appointed time.
519     // ***CHECK***SCENARIO***
520     // @ Do I have to use the function      YES YES YES
521     // @ When it is possible to call        after end of ICO (or any time - not necessary)
522     // @ When it is launched automatically  -
523     // @ Who can call the function          admins or anybody
524     function tokenUnpause() external {
525         require(wallets[uint8(Roles.manager)] == msg.sender
526             || (now > endTime.add(renewal).add(USER_UNPAUSE_TOKEN_TIMEOUT) && TokenSale == TokenSaleType.round2 && isFinalized && goalReached()));
527         token.setPause(false);
528     }
529 
530     // Enable the "Pause of exchange". Available to the manager until the TokenSale is completed.
531     // The manager cannot turn on the pause, for example, 3 years after the end of the TokenSale.
532     // @ Do I have to use the function      no
533     // @ When it is possible to call        while Round2 not ended
534     // @ When it is launched automatically  before Round0
535     // @ Who can call the function          admins
536     function tokenPause() public {
537         onlyAdmin(false);
538         require(!isFinalized);
539         token.setPause(true);
540     }
541 
542     // Pause of sale. Available to the manager.
543     // @ Do I have to use the function      no
544     // @ When it is possible to call        during active rounds
545     // @ When it is launched automatically  -
546     // @ Who can call the function          admins
547     function setCrowdsalePause(bool mode) public {
548         onlyAdmin(false);
549         isPausedCrowdsale = mode;
550     }
551 
552     // For example - After 5 years of the project's existence, all of us suddenly decided collectively
553     // (company + investors) that it would be more profitable for everyone to switch to another smart
554     // contract responsible for tokens. The company then prepares a new token, investors
555     // disassemble, study, discuss, etc. After a general agreement, the manager allows any investor:
556     //      - to burn the tokens of the previous contract
557     //      - generate new tokens for a new contract
558     // It is understood that after a general solution through this function all investors
559     // will collectively (and voluntarily) move to a new token.
560     // @ Do I have to use the function      no
561     // @ When it is possible to call        only after ICO!
562     // @ When it is launched automatically  -
563     // @ Who can call the function          admins
564     function moveTokens(address _migrationAgent) public {
565         onlyAdmin(false);
566         token.setMigrationAgent(_migrationAgent);
567     }
568 
569     // @ Do I have to use the function      no
570     // @ When it is possible to call        only after ICO!
571     // @ When it is launched automatically  -
572     // @ Who can call the function          admins
573     function migrateAll(address[] _holders) public {
574         onlyAdmin(false);
575         token.migrateAll(_holders);
576     }
577 
578     // Change the address for the specified role.
579     // Available to any wallet owner except the observer.
580     // Available to the manager until the round is initialized.
581     // The Observer's wallet or his own manager can change at any time.
582     // @ Do I have to use the function      no
583     // @ When it is possible to call        depend...
584     // @ When it is launched automatically  -
585     // @ Who can call the function          staff (all 7+ roles)
586     function changeWallet(Roles _role, address _wallet) external
587     {
588         require(
589             (msg.sender == wallets[uint8(_role)] && _role != Roles.observer)
590             ||
591             (msg.sender == wallets[uint8(Roles.manager)] && (!isInitialized || _role == Roles.observer) && _role != Roles.fees )
592         );
593 
594         wallets[uint8(_role)] = _wallet;
595     }
596 
597 
598     // The beneficiary at any time can take rights in all roles and prescribe his wallet in all the
599     // rollers. Thus, he will become the recipient of tokens for the role of Accountant,
600     // Team, etc. Works at any time.
601     // @ Do I have to use the function      no
602     // @ When it is possible to call        any time
603     // @ When it is launched automatically  -
604     // @ Who can call the function          only Beneficiary
605     function resetAllWallets() external{
606         address _beneficiary = wallets[uint8(Roles.beneficiary)];
607         require(msg.sender == _beneficiary);
608         for(uint8 i = 0; i < wallets.length; i++){
609             if(uint8(Roles.fees) == i || uint8(Roles.team) == i)
610                 continue;
611 
612             wallets[i] = _beneficiary;
613         }
614         token.setUnpausedWallet(_beneficiary, true);
615     }
616 
617 
618     // Burn the investor tokens, if provided by the ICO scenario. Limited time available - BURN_TOKENS_TIME
619     // ***CHECK***SCENARIO***
620     // @ Do I have to use the function      no
621     // @ When it is possible to call        any time
622     // @ When it is launched automatically  -
623     // @ Who can call the function          admin
624     function massBurnTokens(address[] _beneficiary, uint256[] _value) external {
625         onlyAdmin(false);
626         require(endTime.add(renewal).add(BURN_TOKENS_TIME) > now);
627         require(_beneficiary.length == _value.length);
628         for(uint16 i; i<_beneficiary.length; i++) {
629             token.burn(_beneficiary[i],_value[i]);
630         }
631     }
632 
633     // Extend the round time, if provided by the script. Extend the round only for
634     // a limited number of days - ROUND_PROLONGATE
635     // ***CHECK***SCENARIO***
636     // @ Do I have to use the function      no
637     // @ When it is possible to call        during active round
638     // @ When it is launched automatically  -
639     // @ Who can call the function          admins
640     function prolong(uint256 _duration) external {
641         onlyAdmin(false);
642         require(now > startTime && now < endTime.add(renewal) && isInitialized);
643         renewal = renewal.add(_duration);
644         require(renewal <= ROUND_PROLONGATE);
645 
646     }
647     // If a little more than a year has elapsed (Round2 start date + 400 days), a smart contract
648     // will allow you to send all the money to the Beneficiary, if any money is present. This is
649     // possible if you mistakenly launch the Round2 for 30 years (not 30 days), investors will transfer
650     // money there and you will not be able to pick them up within a reasonable time. It is also
651     // possible that in our checked script someone will make unforeseen mistakes, spoiling the
652     // finalization. Without finalization, money cannot be returned. This is a rescue option to
653     // get around this problem, but available only after a year (400 days).
654 
655     // Another reason - the TokenSale was a failure, but not all ETH investors took their money during the year after.
656     // Some investors may have lost a wallet key, for example.
657 
658     // The method works equally with the Round1 and Round2. When the Round1 starts, the time for unlocking
659     // the distructVault begins. If the TokenSale is then started, then the term starts anew from the first day of the TokenSale.
660 
661     // Next, act independently, in accordance with obligations to investors.
662 
663     // Within 400 days (FORCED_REFUND_TIMEOUT1) of the start of the Round, if it fails only investors can take money. After
664     // the deadline this can also include the company as well as investors, depending on who is the first to use the method.
665     // @ Do I have to use the function      no
666     // @ When it is possible to call        -
667     // @ When it is launched automatically  -
668     // @ Who can call the function          beneficiary & manager
669     function distructVault() public {
670         require(address(vault) != 0x0);
671         if (wallets[uint8(Roles.beneficiary)] == msg.sender && (now > startTime.add(FORCED_REFUND_TIMEOUT1))) {
672             vault.del(wallets[uint8(Roles.beneficiary)]);
673         }
674         if (wallets[uint8(Roles.manager)] == msg.sender && (now > startTime.add(FORCED_REFUND_TIMEOUT2))) {
675             vault.del(wallets[uint8(Roles.manager)]);
676         }
677     }
678 
679 
680     // We accept payments other than Ethereum (ETH) and other currencies, for example, Bitcoin (BTC).
681     // Perhaps other types of cryptocurrency - see the original terms in the white paper and on the TokenSale website.
682 
683     // We release tokens on Ethereum. During the Round1 and Round2 with a smart contract, you directly transfer
684     // the tokens there and immediately, with the same transaction, receive tokens in your wallet.
685 
686     // When paying in any other currency, for example in BTC, we accept your money via one common wallet.
687     // Our manager fixes the amount received for the bitcoin wallet and calls the method of the smart
688     // contract paymentsInOtherCurrency to inform him how much foreign currency has been received - on a daily basis.
689     // The smart contract pins the number of accepted ETH directly and the number of BTC. Smart contract
690     // monitors softcap and hardcap, so as not to go beyond this framework.
691 
692     // In theory, it is possible that when approaching hardcap, we will receive a transfer (one or several
693     // transfers) to the wallet of BTC, that together with previously received money will exceed the hardcap in total.
694     // In this case, we will refund all the amounts above, in order not to exceed the hardcap.
695 
696     // Collection of money in BTC will be carried out via one common wallet. The wallet's address will be published
697     // everywhere (in a white paper, on the TokenSale website, on Telegram, on Bitcointalk, in this code, etc.)
698     // Anyone interested can check that the administrator of the smart contract writes down exactly the amount
699     // in ETH (in equivalent for BTC) there. In theory, the ability to bypass a smart contract to accept money in
700     // BTC and not register them in ETH creates a possibility for manipulation by the company. Thanks to
701     // paymentsInOtherCurrency however, this threat is leveled.
702 
703     // Any user can check the amounts in BTC and the variable of the smart contract that accounts for this
704     // (paymentsInOtherCurrency method). Any user can easily check the incoming transactions in a smart contract
705     // on a daily basis. Any hypothetical tricks on the part of the company can be exposed and panic during the TokenSale,
706     // simply pointing out the incompatibility of paymentsInOtherCurrency (ie, the amount of ETH + BTC collection)
707     // and the actual transactions in BTC. The company strictly adheres to the described principles of openness.
708 
709     // The company administrator is required to synchronize paymentsInOtherCurrency every working day (but you
710     // cannot synchronize if there are no new BTC payments). In the case of unforeseen problems, such as
711     // brakes on the Ethereum network, this operation may be difficult. You should only worry if the
712     // administrator does not synchronize the amount for more than 96 hours in a row, and the BTC wallet
713     // receives significant amounts.
714 
715     // This scenario ensures that for the sum of all fees in all currencies this value does not exceed hardcap.
716 
717     // Addresses for other currencies:
718     // BTC Address: 3HiqVz6wFhSHZ3QUbX9C8GUPSjdDuksPJA
719 
720     // ** QUINTILLIONS ** 10^18 / 1**18 / 1e18
721 
722     // @ Do I have to use the function      no
723     // @ When it is possible to call        during active rounds
724     // @ When it is launched automatically  every day
725     // @ Who can call the function          admins + observer
726     function paymentsInOtherCurrency(uint256 _token, uint256 _value) public {
727         //require(wallets[uint8(Roles.observer)] == msg.sender || wallets[uint8(Roles.manager)] == msg.sender);
728         onlyAdmin(true);
729         bool withinPeriod = (now >= startTime && now <= endTime.add(renewal));
730 
731         bool withinCap = _value.add(ethWeiRaised) <= hardCap.add(overLimit);
732         require(withinPeriod && withinCap && isInitialized);
733 
734         nonEthWeiRaised = _value;
735         tokenReserved = _token;
736 
737     }
738 
739     function lokedMint(address _beneficiary, uint256 _value, uint256 _freezeTime) internal {
740         if(_freezeTime > 0){
741 
742             uint256 totalBloked = token.freezedTokenOf(_beneficiary).add(_value);
743             uint256 pastDateUnfreeze = token.defrostDate(_beneficiary);
744             uint256 newDateUnfreeze = _freezeTime.add(now);
745             newDateUnfreeze = (pastDateUnfreeze > newDateUnfreeze ) ? pastDateUnfreeze : newDateUnfreeze;
746 
747             token.freezeTokens(_beneficiary,totalBloked,newDateUnfreeze);
748         }
749         token.mint(_beneficiary,_value);
750     }
751 
752 
753     // The function for obtaining smart contract funds in ETH. If all the checks are true, the token is
754     // transferred to the buyer, taking into account the current bonus.
755     function buyTokens(address beneficiary) public payable {
756         require(beneficiary != 0x0);
757         require(validPurchase());
758 
759         uint256 weiAmount = msg.value;
760 
761         uint256 ProfitProcent = getProfitPercent();
762 
763         uint256 value;
764         uint256 percent;
765         uint256 freezeTime;
766 
767         (value,
768         percent,
769         freezeTime) = getBonuses(weiAmount);
770 
771         Bonus memory curBonus = Bonus(value,percent,freezeTime);
772 
773         uint256 bonus = curBonus.procent;
774 
775         // --------------------------------------------------------------------------------------------
776         // *** Scenario 1 - select max from all bonuses + check maxAllProfit
777         uint256 totalProfit = (ProfitProcent < bonus) ? bonus : ProfitProcent;
778 
779         // --------------------------------------------------------------------------------------------
780         totalProfit = (totalProfit > maxAllProfit) ? maxAllProfit : totalProfit;
781 
782         // calculate token amount to be created
783         uint256 tokens = weiAmount.mul(rate).mul(totalProfit.add(100)).div(100 ether);
784 
785         // update state
786         ethWeiRaised = ethWeiRaised.add(weiAmount);
787 
788         lokedMint(beneficiary, tokens, curBonus.freezeTime);
789 
790         emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
791 
792         forwardFunds();
793     }
794 
795     // buyTokens alias
796     function () public payable {
797         buyTokens(msg.sender);
798     }
799 
800 
801 
802 }
803 
804 /**
805  * @title SafeMath
806  * @dev Math operations with safety checks that throw on error
807  */
808 library SafeMath {
809   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
810     if (a == 0) {
811       return 0;
812     }
813     uint256 c = a * b;
814     assert(c / a == b);
815     return c;
816   }
817   function div(uint256 a, uint256 b) internal pure returns (uint256) {
818     uint256 c = a / b;
819     return c;
820   }
821   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
822     assert(b <= a);
823     return a - b;
824   }
825   function add(uint256 a, uint256 b) internal pure returns (uint256) {
826     uint256 c = a + b;
827     assert(c >= a);
828     return c;
829   }
830 }
831 
832 /**
833  * @title Ownable
834  * @dev The Ownable contract has an owner address, and provides basic authorization control
835  * functions, this simplifies the implementation of "user permissions".
836  * This code is taken from openZeppelin without any changes.
837  */
838 contract Ownable {
839   address public owner;
840 
841 
842   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
843 
844 
845   /**
846    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
847    * account.
848    */
849   function Ownable() public {
850     owner = msg.sender;
851   }
852 
853   /**
854    * @dev Throws if called by any account other than the owner.
855    */
856   modifier onlyOwner() {
857     require(msg.sender == owner);
858     _;
859   }
860 
861   /**
862    * @dev Allows the current owner to transfer control of the contract to a newOwner.
863    * @param newOwner The address to transfer ownership to.
864    */
865   function transferOwnership(address newOwner) public onlyOwner {
866     require(newOwner != address(0));
867     emit OwnershipTransferred(owner, newOwner);
868     owner = newOwner;
869   }
870 
871 }
872 
873 
874 // (A3)
875 // Contract for freezing of investors' funds. Hence, investors will be able to withdraw money if the
876 // round does not attain the softcap. From here the wallet of the beneficiary will receive all the
877 // money (namely, the beneficiary, not the manager's wallet).
878 contract RefundVault is Ownable {
879     using SafeMath for uint256;
880 
881     enum State { Active, Refunding, Closed }
882 
883     uint8 round;
884 
885     mapping (uint8 => mapping (address => uint256)) public deposited;
886 
887     State public state;
888 
889     event Closed();
890     event RefundsEnabled();
891     event Refunded(address indexed beneficiary, uint256 weiAmount);
892     event Deposited(address indexed beneficiary, uint256 weiAmount);
893 
894     function RefundVault() public {
895         state = State.Active;
896     }
897 
898     // Depositing funds on behalf of an TokenSale investor. Available to the owner of the contract (Crowdsale Contract).
899     function deposit(address investor) onlyOwner public payable {
900         require(state == State.Active);
901         deposited[round][investor] = deposited[round][investor].add(msg.value);
902         emit Deposited(investor,msg.value);
903     }
904 
905     // Move the collected funds to a specified address. Available to the owner of the contract.
906     function close(address _wallet1, address _wallet2, uint256 _feesValue) onlyOwner public {
907         require(state == State.Active);
908         require(_wallet1 != 0x0);
909         state = State.Closed;
910         emit Closed();
911         if(_wallet2 != 0x0)
912             _wallet2.transfer(_feesValue);
913         _wallet1.transfer(address(this).balance);
914     }
915 
916     // Allow refund to investors. Available to the owner of the contract.
917     function enableRefunds() onlyOwner public {
918         require(state == State.Active);
919         state = State.Refunding;
920         emit RefundsEnabled();
921     }
922 
923     // Return the funds to a specified investor. In case of failure of the round, the investor
924     // should call this method of this contract (RefundVault) or call the method claimRefund of Crowdsale
925     // contract. This function should be called either by the investor himself, or the company
926     // (or anyone) can call this function in the loop to return funds to all investors en masse.
927     function refund(address investor) public {
928         require(state == State.Refunding);
929         uint256 depositedValue = deposited[round][investor];
930         require(depositedValue > 0);
931         deposited[round][investor] = 0;
932         investor.transfer(depositedValue);
933         emit Refunded(investor, depositedValue);
934     }
935 
936     function restart() external onlyOwner {
937         require(state == State.Closed);
938         round++;
939         state = State.Active;
940 
941     }
942 
943     // Destruction of the contract with return of funds to the specified address. Available to
944     // the owner of the contract.
945     function del(address _wallet) external onlyOwner {
946         selfdestruct(_wallet);
947     }
948 }
949 
950 
951 /**
952  * @title ERC20Basic
953  * @dev Simpler version of ERC20 interface
954  * @dev see https://github.com/ethereum/EIPs/issues/179
955  * This code is taken from openZeppelin without any changes.
956  */
957 contract ERC20Basic {
958   function totalSupply() public view returns (uint256);
959   function balanceOf(address who) public view returns (uint256);
960   function transfer(address to, uint256 value) public returns (bool);
961   event Transfer(address indexed from, address indexed to, uint256 value);
962 }
963 
964 /**
965  * @title ERC20 interface
966  * @dev see https://github.com/ethereum/EIPs/issues/20
967  * This code is taken from openZeppelin without any changes.
968  */
969 contract ERC20 is ERC20Basic {
970   function allowance(address owner, address spender) public view returns (uint256);
971   function transferFrom(address from, address to, uint256 value) public returns (bool);
972   function approve(address spender, uint256 value) public returns (bool);
973   event Approval(address indexed owner, address indexed spender, uint256 value);
974 }
975 
976 /**
977  * @title Basic token
978  * @dev Basic version of StandardToken, with no allowances.
979  * This code is taken from openZeppelin without any changes.
980  */
981 contract BasicToken is ERC20Basic {
982   using SafeMath for uint256;
983 
984   mapping(address => uint256) balances;
985 
986   uint256 totalSupply_;
987 
988   /**
989   * @dev total number of tokens in existence
990   */
991   function totalSupply() public view returns (uint256) {
992     return totalSupply_;
993   }
994 
995   /**
996   * @dev transfer token for a specified address
997   * @param _to The address to transfer to.
998   * @param _value The amount to be transferred.
999   */
1000   function transfer(address _to, uint256 _value) public returns (bool) {
1001     require(_to != address(0));
1002     require(_value <= balances[msg.sender]);
1003 
1004     // SafeMath.sub will throw if there is not enough balance.
1005     balances[msg.sender] = balances[msg.sender].sub(_value);
1006     balances[_to] = balances[_to].add(_value);
1007     emit Transfer(msg.sender, _to, _value);
1008     return true;
1009   }
1010 
1011   /**
1012   * @dev Gets the balance of the specified address.
1013   * @param _owner The address to query the the balance of.
1014   * @return An uint256 representing the amount owned by the passed address.
1015   */
1016   function balanceOf(address _owner) public view returns (uint256 balance) {
1017     return balances[_owner];
1018   }
1019 
1020 }
1021 
1022 
1023 
1024   /**
1025  * @title Standard ERC20 token
1026  *
1027  * @dev Implementation of the basic standard token.
1028  * @dev https://github.com/ethereum/EIPs/issues/20
1029  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
1030  * This code is taken from openZeppelin without any changes.
1031  */
1032 contract StandardToken is ERC20, BasicToken {
1033 
1034   mapping (address => mapping (address => uint256)) internal allowed;
1035 
1036 
1037   /**
1038    * @dev Transfer tokens from one address to another
1039    * @param _from address The address which you want to send tokens from
1040    * @param _to address The address which you want to transfer to
1041    * @param _value uint256 the amount of tokens to be transferred
1042    */
1043   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
1044     require(_to != address(0));
1045     require(_value <= balances[_from]);
1046     require(_value <= allowed[_from][msg.sender]);
1047 
1048     balances[_from] = balances[_from].sub(_value);
1049     balances[_to] = balances[_to].add(_value);
1050     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
1051     emit Transfer(_from, _to, _value);
1052     return true;
1053   }
1054 
1055   /**
1056    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1057    *
1058    * Beware that changing an allowance with this method brings the risk that someone may use both the old
1059    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1060    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1061    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1062    * @param _spender The address which will spend the funds.
1063    * @param _value The amount of tokens to be spent.
1064    */
1065   function approve(address _spender, uint256 _value) public returns (bool) {
1066     allowed[msg.sender][_spender] = _value;
1067     emit Approval(msg.sender, _spender, _value);
1068     return true;
1069   }
1070 
1071   /**
1072    * @dev Function to check the amount of tokens that an owner allowed to a spender.
1073    * @param _owner address The address which owns the funds.
1074    * @param _spender address The address which will spend the funds.
1075    * @return A uint256 specifying the amount of tokens still available for the spender.
1076    */
1077   function allowance(address _owner, address _spender) public view returns (uint256) {
1078     return allowed[_owner][_spender];
1079   }
1080 
1081   /**
1082    * @dev Increase the amount of tokens that an owner allowed to a spender.
1083    *
1084    * approve should be called when allowed[_spender] == 0. To increment
1085    * allowed value is better to use this function to avoid 2 calls (and wait until
1086    * the first transaction is mined)
1087    * From MonolithDAO Token.sol
1088    * @param _spender The address which will spend the funds.
1089    * @param _addedValue The amount of tokens to increase the allowance by.
1090    */
1091   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
1092     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
1093     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1094     return true;
1095   }
1096 
1097   /**
1098    * @dev Decrease the amount of tokens that an owner allowed to a spender.
1099    *
1100    * approve should be called when allowed[_spender] == 0. To decrement
1101    * allowed value is better to use this function to avoid 2 calls (and wait until
1102    * the first transaction is mined)
1103    * From MonolithDAO Token.sol
1104    * @param _spender The address which will spend the funds.
1105    * @param _subtractedValue The amount of tokens to decrease the allowance by.
1106    */
1107   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
1108     uint oldValue = allowed[msg.sender][_spender];
1109     if (_subtractedValue > oldValue) {
1110       allowed[msg.sender][_spender] = 0;
1111     } else {
1112       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
1113     }
1114     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1115     return true;
1116   }
1117 
1118 }
1119 
1120 
1121 
1122 
1123 /**
1124  * @title Mintable token
1125  * @dev Simple ERC20 Token example, with mintable token creation
1126  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
1127  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
1128  * This code is taken from openZeppelin without any changes.
1129  */
1130 contract MintableToken is StandardToken, Ownable {
1131   event Mint(address indexed to, uint256 amount);
1132   event MintFinished();
1133 
1134   /**
1135    * @dev Function to mint tokens
1136    * @param _to The address that will receive the minted tokens.
1137    * @param _amount The amount of tokens to mint.
1138    * @return A boolean that indicates if the operation was successful.
1139    */
1140   function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
1141     totalSupply_ = totalSupply_.add(_amount);
1142     balances[_to] = balances[_to].add(_amount);
1143     emit Mint(_to, _amount);
1144     emit Transfer(address(0), _to, _amount);
1145     return true;
1146   }
1147 }
1148 
1149 
1150 
1151 /**
1152  * @title Pausable
1153  * @dev Base contract which allows children to implement an emergency stop mechanism.
1154  */
1155 contract Pausable is Ownable {
1156 
1157   mapping (address => bool) public unpausedWallet;
1158 
1159   event Pause();
1160   event Unpause();
1161 
1162   bool public paused = true;
1163 
1164 
1165   /**
1166    * @dev Modifier to make a function callable only when the contract is not paused.
1167    */
1168   modifier whenNotPaused(address _to) {
1169     require(!paused||unpausedWallet[msg.sender]||unpausedWallet[_to]);
1170     _;
1171   }
1172 
1173    // Add a wallet ignoring the "Exchange pause". Available to the owner of the contract.
1174   function setUnpausedWallet(address _wallet, bool mode) public {
1175        require(owner == msg.sender || msg.sender == Crowdsale(owner).wallets(uint8(Crowdsale.Roles.manager)));
1176        unpausedWallet[_wallet] = mode;
1177   }
1178 
1179   /**
1180    * @dev called by the owner to pause, triggers stopped state
1181    */
1182   function setPause(bool mode) public onlyOwner {
1183     if (!paused && mode) {
1184         paused = true;
1185         emit Pause();
1186     }
1187     if (paused && !mode) {
1188         paused = false;
1189         emit Unpause();
1190     }
1191   }
1192 
1193 }
1194 
1195 
1196 
1197 /**
1198  * @title Pausable token
1199  * @dev StandardToken modified with pausable transfers.
1200  **/
1201 contract PausableToken is StandardToken, Pausable {
1202 
1203     mapping (address => bool) public grantedToSetUnpausedWallet;
1204 
1205     function transfer(address _to, uint256 _value) public whenNotPaused(_to) returns (bool) {
1206       return super.transfer(_to, _value);
1207     }
1208 
1209     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused(_to) returns (bool) {
1210       return super.transferFrom(_from, _to, _value);
1211     }
1212 
1213     function grantToSetUnpausedWallet(address _to, bool permission) public {
1214         require(owner == msg.sender || msg.sender == Crowdsale(owner).wallets(uint8(Crowdsale.Roles.manager)));
1215         grantedToSetUnpausedWallet[_to] = permission;
1216     }
1217 
1218     // Add a wallet ignoring the "Exchange pause". Available to the owner of the contract.
1219     function setUnpausedWallet(address _wallet, bool mode) public {
1220         require(owner == msg.sender || grantedToSetUnpausedWallet[msg.sender] || msg.sender == Crowdsale(owner).wallets(uint8(Crowdsale.Roles.manager)));
1221         unpausedWallet[_wallet] = mode;
1222     }
1223 }
1224 
1225 
1226 contract MigratableToken is BasicToken,Ownable {
1227 
1228     uint256 public totalMigrated;
1229     address public migrationAgent;
1230 
1231     event Migrate(address indexed _from, address indexed _to, uint256 _value);
1232 
1233     function setMigrationAgent(address _migrationAgent) public onlyOwner {
1234         require(migrationAgent == 0x0);
1235         migrationAgent = _migrationAgent;
1236     }
1237 
1238     function migrateInternal(address _holder) internal {
1239         require(migrationAgent != 0x0);
1240 
1241         uint256 value = balances[_holder];
1242         balances[_holder] = 0;
1243 
1244         totalSupply_ = totalSupply_.sub(value);
1245         totalMigrated = totalMigrated.add(value);
1246 
1247         MigrationAgent(migrationAgent).migrateFrom(_holder, value);
1248         emit Migrate(_holder,migrationAgent,value);
1249     }
1250 
1251     function migrateAll(address[] _holders) public onlyOwner {
1252         for(uint i = 0; i < _holders.length; i++){
1253             migrateInternal(_holders[i]);
1254         }
1255     }
1256 
1257     // Reissue your tokens.
1258     function migrate() public
1259     {
1260         require(balances[msg.sender] > 0);
1261         migrateInternal(msg.sender);
1262     }
1263 
1264 }
1265 
1266 contract MigrationAgent
1267 {
1268     function migrateFrom(address _from, uint256 _value) public;
1269 }
1270 
1271 contract FreezingToken is PausableToken {
1272     struct freeze {
1273         uint256 amount;
1274         uint256 when;
1275     }
1276 
1277 
1278     mapping (address => freeze) freezedTokens;
1279 
1280 
1281     // @ Do I have to use the function      no
1282     // @ When it is possible to call        any time
1283     // @ When it is launched automatically  -
1284     // @ Who can call the function          any
1285     function freezedTokenOf(address _beneficiary) public view returns (uint256 amount){
1286         freeze storage _freeze = freezedTokens[_beneficiary];
1287         if(_freeze.when < now) return 0;
1288         return _freeze.amount;
1289     }
1290 
1291     // @ Do I have to use the function      no
1292     // @ When it is possible to call        any time
1293     // @ When it is launched automatically  -
1294     // @ Who can call the function          any
1295     function defrostDate(address _beneficiary) public view returns (uint256 Date) {
1296         freeze storage _freeze = freezedTokens[_beneficiary];
1297         if(_freeze.when < now) return 0;
1298         return _freeze.when;
1299     }
1300 
1301 
1302     // ***CHECK***SCENARIO***
1303     function freezeTokens(address _beneficiary, uint256 _amount, uint256 _when) public onlyOwner {
1304         freeze storage _freeze = freezedTokens[_beneficiary];
1305         _freeze.amount = _amount;
1306         _freeze.when = _when;
1307     }
1308 
1309     function transferAndFreeze(address _to, uint256 _value, uint256 _when) external {
1310         require(unpausedWallet[msg.sender]);
1311         if(_when > 0){
1312             freeze storage _freeze = freezedTokens[_to];
1313             _freeze.amount = _freeze.amount.add(_value);
1314             _freeze.when = (_freeze.when > _when)? _freeze.when: _when;
1315         }
1316         transfer(_to,_value);
1317     }
1318 
1319     function transfer(address _to, uint256 _value) public returns (bool) {
1320         require(balanceOf(msg.sender) >= freezedTokenOf(msg.sender).add(_value));
1321         return super.transfer(_to,_value);
1322     }
1323 
1324     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
1325         require(balanceOf(_from) >= freezedTokenOf(_from).add(_value));
1326         return super.transferFrom( _from,_to,_value);
1327     }
1328 
1329 
1330 
1331 }
1332 
1333 contract BurnableToken is BasicToken, Ownable {
1334 
1335   event Burn(address indexed burner, uint256 value);
1336 
1337   /**
1338    * @dev Burns a specific amount of tokens.
1339    * @param _value The amount of token to be burned.
1340    */
1341   function burn(address _beneficiary, uint256 _value) public onlyOwner {
1342     require(_value <= balances[_beneficiary]);
1343     // no need to require value <= totalSupply, since that would imply the
1344     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
1345 
1346     balances[_beneficiary] = balances[_beneficiary].sub(_value);
1347     totalSupply_ = totalSupply_.sub(_value);
1348     emit Burn(_beneficiary, _value);
1349     emit Transfer(_beneficiary, address(0), _value);
1350   }
1351 }
1352 
1353 /*
1354 * Contract that is working with ERC223 tokens
1355 */
1356 contract ERC223ReceivingContract {
1357     function tokenFallback(address _from, uint _value, bytes _data) public;
1358 }
1359 
1360 // (A2)
1361 // Contract token
1362 contract Token is FreezingToken, MintableToken, MigratableToken, BurnableToken {
1363     string public constant name = "TOSS";
1364 
1365     string public constant symbol = "PROOF OF TOSS";
1366 
1367     uint8 public constant decimals = 18;
1368 
1369     mapping (address => mapping (address => bool)) public grantedToAllowBlocking; // Address of smart contract that can allow other contracts to block tokens
1370     mapping (address => mapping (address => bool)) public allowedToBlocking; // Address of smart contract that can block tokens
1371     mapping (address => mapping (address => uint256)) public blocked; // Blocked tokens per blocker
1372 
1373     event TokenOperationEvent(string operation, address indexed from, address indexed to, uint256 value, address indexed _contract);
1374 
1375 
1376     modifier contractOnly(address _to) {
1377         uint256 codeLength;
1378 
1379         assembly {
1380         // Retrieve the size of the code on target address, this needs assembly .
1381         codeLength := extcodesize(_to)
1382         }
1383 
1384         require(codeLength > 0);
1385 
1386         _;
1387     }
1388 
1389     /**
1390     * @dev Transfer the specified amount of tokens to the specified address.
1391     * Invokes the `tokenFallback` function if the recipient is a contract.
1392     * The token transfer fails if the recipient is a contract
1393     * but does not implement the `tokenFallback` function
1394     * or the fallback function to receive funds.
1395     *
1396     * @param _to Receiver address.
1397     * @param _value Amount of tokens that will be transferred.
1398     * @param _data Transaction metadata.
1399     */
1400 
1401     function transferToContract(address _to, uint256 _value, bytes _data) public contractOnly(_to) returns (bool) {
1402         // Standard function transfer similar to ERC20 transfer with no _data .
1403         // Added due to backwards compatibility reasons .
1404 
1405 
1406         super.transfer(_to, _value);
1407 
1408         ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
1409         receiver.tokenFallback(msg.sender, _value, _data);
1410 
1411         return true;
1412     }
1413 
1414     // @brief Allow another contract to allow another contract to block tokens. Can be revoked
1415     // @param _spender another contract address
1416     // @param _value amount of approved tokens
1417     function grantToAllowBlocking(address _contract, bool permission) contractOnly(_contract) public {
1418 
1419 
1420         grantedToAllowBlocking[msg.sender][_contract] = permission;
1421 
1422         emit TokenOperationEvent('grant_allow_blocking', msg.sender, _contract, 0, 0);
1423     }
1424 
1425     // @brief Allow another contract to block tokens. Can't be revoked
1426     // @param _owner tokens owner
1427     // @param _contract another contract address
1428     function allowBlocking(address _owner, address _contract) contractOnly(_contract) public {
1429 
1430 
1431         require(_contract != msg.sender && _contract != owner);
1432 
1433         require(grantedToAllowBlocking[_owner][msg.sender]);
1434 
1435         allowedToBlocking[_owner][_contract] = true;
1436 
1437         emit TokenOperationEvent('allow_blocking', _owner, _contract, 0, msg.sender);
1438     }
1439 
1440     // @brief Blocks tokens
1441     // @param _blocking The address of tokens which are being blocked
1442     // @param _value The blocked token count
1443     function blockTokens(address _blocking, uint256 _value) whenNotPaused(_blocking) public {
1444         require(allowedToBlocking[_blocking][msg.sender]);
1445 
1446         require(balanceOf(_blocking) >= freezedTokenOf(_blocking).add(_value) && _value > 0);
1447 
1448         balances[_blocking] = balances[_blocking].sub(_value);
1449         blocked[_blocking][msg.sender] = blocked[_blocking][msg.sender].add(_value);
1450 
1451         emit Transfer(_blocking, address(0), _value);
1452         emit TokenOperationEvent('block', _blocking, 0, _value, msg.sender);
1453     }
1454 
1455     // @brief Unblocks tokens and sends them to the given address (to _unblockTo)
1456     // @param _blocking The address of tokens which are blocked
1457     // @param _unblockTo The address to send to the blocked tokens after unblocking
1458     // @param _value The blocked token count to unblock
1459     function unblockTokens(address _blocking, address _unblockTo, uint256 _value) whenNotPaused(_unblockTo) public {
1460         require(allowedToBlocking[_blocking][msg.sender]);
1461         require(blocked[_blocking][msg.sender] >= _value && _value > 0);
1462 
1463         blocked[_blocking][msg.sender] = blocked[_blocking][msg.sender].sub(_value);
1464         balances[_unblockTo] = balances[_unblockTo].add(_value);
1465 
1466         emit Transfer(address(0), _blocking, _value);
1467 
1468         if (_blocking != _unblockTo) {
1469             emit Transfer(_blocking, _unblockTo, _value);
1470         }
1471 
1472         emit TokenOperationEvent('unblock', _blocking, _unblockTo, _value, msg.sender);
1473     }
1474 }
1475 
1476 // (B)
1477 // The contract for freezing tokens for the team..
1478 contract AllocationTOSS is Ownable {
1479     using SafeMath for uint256;
1480 
1481     struct Share {
1482         uint256 proportion;
1483         uint256 forPart;
1484     }
1485 
1486     // How many days to freeze from the moment of finalizing ICO
1487     uint256 public unlockPart1;
1488     uint256 public unlockPart2;
1489     uint256 public totalShare;
1490 
1491     mapping(address => Share) public shares;
1492 
1493     ERC20Basic public token;
1494 
1495     address public owner;
1496 
1497     // The contract takes the ERC20 coin address from which this contract will work and from the
1498     // owner (Team wallet) who owns the funds.
1499     function AllocationTOSS(ERC20Basic _token, uint256 _unlockPart1, uint256 _unlockPart2) public{
1500         unlockPart1 = _unlockPart1;
1501         unlockPart2 = _unlockPart2;
1502         token = _token;
1503     }
1504 
1505     function addShare(address _beneficiary, uint256 _proportion, uint256 _percenForFirstPart) onlyOwner external {
1506         shares[_beneficiary] = Share(shares[_beneficiary].proportion.add(_proportion),_percenForFirstPart);
1507         totalShare = totalShare.add(_proportion);
1508     }
1509 
1510     // If the time of freezing expired will return the funds to the owner.
1511     function unlockFor(address _owner) public {
1512         require(now >= unlockPart1);
1513         uint256 share = shares[_owner].proportion;
1514         if (now < unlockPart2) {
1515             share = share.mul(shares[_owner].forPart)/100;
1516             shares[_owner].forPart = 0;
1517         }
1518         if (share > 0) {
1519             uint256 unlockedToken = token.balanceOf(this).mul(share).div(totalShare);
1520             shares[_owner].proportion = shares[_owner].proportion.sub(share);
1521             totalShare = totalShare.sub(share);
1522             token.transfer(_owner,unlockedToken);
1523         }
1524     }
1525 }
1526 
1527 contract Creator{
1528     Token public token = new Token();
1529     RefundVault public refund = new RefundVault();
1530 
1531     function createToken() external returns (Token) {
1532         token.transferOwnership(msg.sender);
1533         return token;
1534     }
1535 
1536     function createAllocation(Token _token, uint256 _unlockPart1, uint256 _unlockPart2) external returns (AllocationTOSS) {
1537         AllocationTOSS allocation = new AllocationTOSS(_token,_unlockPart1,_unlockPart2);
1538         allocation.transferOwnership(msg.sender);
1539         return allocation;
1540     }
1541 
1542     function createRefund() external returns (RefundVault) {
1543         refund.transferOwnership(msg.sender);
1544         return refund;
1545     }
1546 
1547 }