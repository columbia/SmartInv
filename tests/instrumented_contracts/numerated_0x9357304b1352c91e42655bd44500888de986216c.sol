1 pragma solidity ^0.4.21;
2 
3 // Project: imigize.io (original)
4 // v13, 2018-06-19
5 // This code is the property of CryptoB2B.io
6 // Copying in whole or in part is prohibited.
7 // Authors: Ivan Fedorov and Dmitry Borodin
8 // Do you want the same TokenSale platform? www.cryptob2b.io
9 
10 contract IRightAndRoles {
11     address[][] public wallets;
12     mapping(address => uint16) public roles;
13 
14     event WalletChanged(address indexed newWallet, address indexed oldWallet, uint8 indexed role);
15     event CloneChanged(address indexed wallet, uint8 indexed role, bool indexed mod);
16 
17     function changeWallet(address _wallet, uint8 _role) external;
18     function setManagerPowerful(bool _mode) external;
19     function onlyRoles(address _sender, uint16 _roleMask) view external returns(bool);
20 }
21 
22 contract ICreator{
23     IRightAndRoles public rightAndRoles;
24     function createAllocation(IToken _token, uint256 _unlockPart1, uint256 _unlockPart2) external returns (IAllocation);
25     function createFinancialStrategy() external returns(IFinancialStrategy);
26     function getRightAndRoles() external returns(IRightAndRoles);
27 }
28 
29 contract IFinancialStrategy{
30 
31     enum State { Active, Refunding, Closed }
32     State public state = State.Active;
33 
34     event Deposited(address indexed beneficiary, uint256 weiAmount);
35     event Receive(address indexed beneficiary, uint256 weiAmount);
36     event Refunded(address indexed beneficiary, uint256 weiAmount);
37     event Started();
38     event Closed();
39     event RefundsEnabled();
40     function freeCash() view public returns(uint256);
41     function deposit(address _beneficiary) external payable;
42     function refund(address _investor) external;
43     function setup(uint8 _state, bytes32[] _params) external;
44     function getBeneficiaryCash() external;
45     function getPartnerCash(uint8 _user, address _msgsender) external;
46 }
47 
48 contract IToken{
49     function setUnpausedWallet(address _wallet, bool mode) public;
50     function mint(address _to, uint256 _amount) public returns (bool);
51     function totalSupply() public view returns (uint256);
52     function setPause(bool mode) public;
53     function setMigrationAgent(address _migrationAgent) public;
54     function migrateAll(address[] _holders) public;
55     function burn(address _beneficiary, uint256 _value) public;
56     function freezedTokenOf(address _beneficiary) public view returns (uint256 amount);
57     function defrostDate(address _beneficiary) public view returns (uint256 Date);
58     function freezeTokens(address _beneficiary, uint256 _amount, uint256 _when) public;
59 }
60 
61 contract IAllocation {
62     function addShare(address _beneficiary, uint256 _proportion, uint256 _percenForFirstPart) external;
63 }
64 
65 contract GuidedByRoles {
66     IRightAndRoles public rightAndRoles;
67     function GuidedByRoles(IRightAndRoles _rightAndRoles) public {
68         rightAndRoles = _rightAndRoles;
69     }
70 }
71 
72 library SafeMath {
73     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74         if (a == 0) {
75             return 0;
76         }
77         uint256 c = a * b;
78         assert(c / a == b);
79         return c;
80     }
81     function div(uint256 a, uint256 b) internal pure returns (uint256) {
82         uint256 c = a / b;
83         return c;
84     }
85     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
86         assert(b <= a);
87         return a - b;
88     }
89     function add(uint256 a, uint256 b) internal pure returns (uint256) {
90         uint256 c = a + b;
91         assert(c >= a);
92         return c;
93     }
94     function minus(uint256 a, uint256 b) internal pure returns (uint256) {
95         if (b>=a) return 0;
96         return a - b;
97     }
98 }
99 
100 contract Crowdsale is GuidedByRoles{
101 // (A1)
102 // The main contract for the sale and management of rounds.
103 // 0000000000000000000000000000000000000000000000000000000000000000
104 
105     uint256 constant USER_UNPAUSE_TOKEN_TIMEOUT =  60 days;
106     uint256 constant FORCED_REFUND_TIMEOUT1     = 400 days;
107     uint256 constant FORCED_REFUND_TIMEOUT2     = 600 days;
108     uint256 constant ROUND_PROLONGATE           =  90 days;
109     //uint256 constant BURN_TOKENS_TIME           =  90 days;
110 
111     using SafeMath for uint256;
112 
113     enum TokenSaleType {round1, round2}
114 
115     TokenSaleType public TokenSale = TokenSaleType.round1;
116 
117     ICreator public creator;
118     bool isBegin=false;
119 
120     IToken public token;
121     IAllocation public allocation;
122     IFinancialStrategy public financialStrategy;
123     bool public isFinalized;
124     bool public isInitialized;
125     bool public isPausedCrowdsale;
126     bool public chargeBonuses;
127     bool public canFirstMint=true;
128 
129     struct Bonus {
130         uint256 value;
131         uint256 procent;
132         uint256 freezeTime;
133     }
134 
135     struct Profit {
136         uint256 percent;
137         uint256 duration;
138     }
139 
140     struct Freezed {
141         uint256 value;
142         uint256 dateTo;
143     }
144 
145     Bonus[] public bonuses;
146     Profit[] public profits;
147 
148 
149     uint256 public startTime= 1537401600; //20.09.2018 0:00:00
150     uint256 public endTime  = 1540079999; //20.10.2018 23:59:59
151     uint256 public renewal;
152 
153     // How many tokens (excluding the bonus) are transferred to the investor in exchange for 1 ETH
154     // **THOUSANDS** 10^18 for human, *10**18 for Solidity, 1e18 for MyEtherWallet (MEW).
155     // Example: if 1ETH = 40.5 Token ==> use 40500 finney
156     uint256 public rate = 9855 ether; // $0.07 (ETH/USD=$680)
157 
158     // ETH/USD rate in US$
159     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: ETH/USD=$1000 ==> use 1000*10**18 (Solidity) or 1000 ether or 1000e18 (MEW)
160     uint256 public exchange  = 680 ether;
161 
162     // If the round does not attain this value before the closing date, the round is recognized as a
163     // failure and investors take the money back (the founders will not interfere in any way).
164     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: softcap=15ETH ==> use 15*10**18 (Solidity) or 15e18 (MEW)
165     uint256 public softCap = 1400 ether;
166 
167     // The maximum possible amount of income
168     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: hardcap=123.45ETH ==> use 123450*10**15 (Solidity) or 12345e15 (MEW)
169     uint256 public hardCap = 88300 ether; // $60M (ETH/USD=$680)
170 
171     // If the last payment is slightly higher than the hardcap, then the usual contracts do
172     // not accept it, because it goes beyond the hardcap. However it is more reasonable to accept the
173     // last payment, very slightly raising the hardcap. The value indicates by how many ETH the
174     // last payment can exceed the hardcap to allow it to be paid. Immediately after this payment, the
175     // round closes. The funders should write here a small number, not more than 1% of the CAP.
176     // Can be equal to zero, to cancel.
177     // **QUINTILLIONS** 10^18 / *10**18 / 1e18
178     uint256 public overLimit = 20 ether;
179 
180     // The minimum possible payment from an investor in ETH. Payments below this value will be rejected.
181     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: minPay=0.1ETH ==> use 100*10**15 (Solidity) or 100e15 (MEW)
182     uint256 public minPay = 15 finney;
183 
184     uint256 public maxAllProfit = 35; // max time bonus=15%, max value bonus=20%, maxAll=15%+20%
185 
186     uint256 public ethWeiRaised;
187     uint256 public nonEthWeiRaised;
188     uint256 public weiRound1;
189     uint256 public tokenReserved;
190 
191     uint256 public totalSaledToken;
192 
193     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
194 
195     event Finalized();
196     event Initialized();
197 
198     event PaymentedInOtherCurrency(uint256 token, uint256 value);
199     event ExchangeChanged(uint256 indexed oldExchange, uint256 indexed newExchange);
200 
201     function Crowdsale(ICreator _creator,IToken _token) GuidedByRoles(_creator.getRightAndRoles()) public
202     {
203         creator=_creator;
204         token = _token;
205     }
206 
207     // Setting the current rate ETH/USD         
208 //    function changeExchange(uint256 _ETHUSD) public {
209 //        require(rightAndRoles.onlyRoles(msg.sender,18));
210 //        require(_ETHUSD >= 1 ether);
211 //        emit ExchangeChanged(exchange,_ETHUSD);
212 //        softCap=softCap.mul(exchange).div(_ETHUSD);             // QUINTILLIONS
213 //        hardCap=hardCap.mul(exchange).div(_ETHUSD);             // QUINTILLIONS
214 //        minPay=minPay.mul(exchange).div(_ETHUSD);               // QUINTILLIONS
215 //
216 //        rate=rate.mul(_ETHUSD).div(exchange);                   // QUINTILLIONS
217 //
218 //        for (uint16 i = 0; i < bonuses.length; i++) {
219 //            bonuses[i].value=bonuses[i].value.mul(exchange).div(_ETHUSD);   // QUINTILLIONS
220 //        }
221 //        bytes32[] memory params = new bytes32[](2);
222 //        params[0] = bytes32(exchange);
223 //        params[1] = bytes32(_ETHUSD);
224 //        financialStrategy.setup(5, params);
225 //
226 //        exchange=_ETHUSD;
227 //
228 //    }
229 
230     // Setting of basic parameters, analog of class constructor
231     // @ Do I have to use the function      see your scenario
232     // @ When it is possible to call        before Round 1/2
233     // @ When it is launched automatically  -
234     // @ Who can call the function          admins
235     function begin() public
236     {
237         require(rightAndRoles.onlyRoles(msg.sender,22));
238         if (isBegin) return;
239         isBegin=true;
240 
241         financialStrategy = creator.createFinancialStrategy();
242 
243         token.setUnpausedWallet(rightAndRoles.wallets(1,0), true);
244         token.setUnpausedWallet(rightAndRoles.wallets(3,0), true);
245         token.setUnpausedWallet(rightAndRoles.wallets(4,0), true);
246         token.setUnpausedWallet(rightAndRoles.wallets(5,0), true);
247         token.setUnpausedWallet(rightAndRoles.wallets(6,0), true);
248 
249         bonuses.push(Bonus(73529 finney, 10,0));
250         bonuses.push(Bonus(147059 finney, 15,0));
251         bonuses.push(Bonus(367647 finney, 20,0));
252 
253         profits.push(Profit(15,7 days));
254         profits.push(Profit(10,7 days));
255         profits.push(Profit(5,7 days));
256     }
257 
258 
259 
260     // Issue of tokens for the zero round, it is usually called: private pre-sale (Round 0)
261     // @ Do I have to use the function      may be
262     // @ When it is possible to call        before Round 1/2
263     // @ When it is launched automatically  -
264     // @ Who can call the function          admins
265     function firstMintRound0(uint256 _amount /* QUINTILLIONS! */) public {
266         require(rightAndRoles.onlyRoles(msg.sender,6));
267         require(canFirstMint);
268         begin();
269         token.mint(rightAndRoles.wallets(3,0),_amount);
270     }
271 
272     function firstMintRound0For(address[] _to, uint256[] _amount, bool[] _setAsUnpaused) public {
273         require(rightAndRoles.onlyRoles(msg.sender,6));
274         require(canFirstMint);
275         begin();
276         require(_to.length == _amount.length && _to.length == _setAsUnpaused.length);
277         for(uint256 i = 0; i < _to.length; i++){
278             token.mint(_to[i],_amount[i]);
279             if(_setAsUnpaused[i]){
280                 token.setUnpausedWallet(_to[i], true);
281             }
282         }
283     }
284 
285     // info
286     function totalSupply() external view returns (uint256){
287         return token.totalSupply();
288     }
289 
290     // Returns the name of the current round in plain text. Constant.
291     function getTokenSaleType() external view returns(string){
292         return (TokenSale == TokenSaleType.round1)?'round1':'round2';
293     }
294 
295     // Transfers the funds of the investor to the contract of return of funds. Internal.
296     function forwardFunds(address _beneficiary) internal {
297         financialStrategy.deposit.value(msg.value)(_beneficiary);
298     }
299 
300     // Check for the possibility of buying tokens. Inside. Constant.
301     function validPurchase() internal view returns (bool) {
302 
303         // The round started and did not end
304         bool withinPeriod = (now > startTime && now < endTime.add(renewal));
305 
306         // Rate is greater than or equal to the minimum
307         bool nonZeroPurchase = msg.value >= minPay;
308 
309         // hardCap is not reached, and in the event of a transaction, it will not be exceeded by more than OverLimit
310         bool withinCap = msg.value <= hardCap.sub(weiRaised()).add(overLimit);
311 
312         // round is initialized and no "Pause of trading" is set
313         return withinPeriod && nonZeroPurchase && withinCap && isInitialized && !isFinalized && !isPausedCrowdsale;
314     }
315 
316     // Check for the ability to finalize the round. Constant.
317     function hasEnded() public view returns (bool) {
318         bool isAdmin = rightAndRoles.onlyRoles(msg.sender,6);
319 
320         bool timeReached = now > endTime.add(renewal);
321 
322         bool capReached = weiRaised() >= hardCap;
323 
324         return (timeReached || capReached || (isAdmin && goalReached())) && isInitialized && !isFinalized;
325     }
326 
327     // Finalize. Only available to the Manager and the Beneficiary. If the round failed, then
328     // anyone can call the finalization to unlock the return of funds to investors
329     // You must call a function to finalize each round (after the Round1 & after the Round2)
330     // @ Do I have to use the function      yes
331     // @ When it is possible to call        after end of Round1 & Round2
332     // @ When it is launched automatically  no
333     // @ Who can call the function          admins or anybody (if round is failed)
334     function finalize() public {
335         require(hasEnded());
336 
337         isFinalized = true;
338         finalization();
339         emit Finalized();
340     }
341 
342     // The logic of finalization. Internal
343     // @ Do I have to use the function      no
344     // @ When it is possible to call        -
345     // @ When it is launched automatically  after end of round
346     // @ Who can call the function          -
347     function finalization() internal {
348         bytes32[] memory params = new bytes32[](0);
349         // If the goal of the achievement
350         if (goalReached()) {
351 
352             financialStrategy.setup(1,params);//Для контракта Buz деньги не возвращает.
353 
354             // if there is anything to give
355             if (tokenReserved > 0) {
356 
357                 token.mint(rightAndRoles.wallets(3,0),tokenReserved);
358 
359                 // Reset the counter
360                 tokenReserved = 0;
361             }
362 
363             // If the finalization is Round 1
364             if (TokenSale == TokenSaleType.round1) {
365 
366                 // Reset settings
367                 isInitialized = false;
368                 isFinalized = false;
369                 if(financialStrategy.freeCash() == 0){
370                     rightAndRoles.setManagerPowerful(true);
371                 }
372 
373                 // Switch to the second round (to Round2)
374                 TokenSale = TokenSaleType.round2;
375 
376                 // Reset the collection counter
377                 weiRound1 = weiRaised();
378                 ethWeiRaised = 0;
379                 nonEthWeiRaised = 0;
380 
381 
382 
383             }
384             else // If the second round is finalized
385             {
386 
387                 // Permission to collect tokens to those who can pick them up
388                 chargeBonuses = true;
389 
390                 totalSaledToken = token.totalSupply();
391                 //partners = true;
392 
393             }
394 
395         }
396         else // If they failed round
397         {
398             financialStrategy.setup(3,params);
399         }
400     }
401 
402     // The Manager freezes the tokens for the Team.
403     // You must call a function to finalize Round 2 (only after the Round2)
404     // @ Do I have to use the function      yes
405     // @ When it is possible to call        Round2
406     // @ When it is launched automatically  -
407     // @ Who can call the function          admins
408     function finalize2() public {
409         require(rightAndRoles.onlyRoles(msg.sender,6));
410         require(chargeBonuses);
411         chargeBonuses = false;
412 
413         allocation = creator.createAllocation(token, now + 1 years /* stage N1 */,0/* not need*/);
414         token.setUnpausedWallet(allocation, true);
415         // Team = %, Founders = %, Fund = %    TOTAL = %
416         allocation.addShare(rightAndRoles.wallets(7,0),100,100); // all 100% - first year
417 
418         // 2% - bounty wallet
419         token.mint(rightAndRoles.wallets(5,0), totalSaledToken.mul(2).div(58));
420 
421         // 10% + 15% - company
422         token.mint(rightAndRoles.wallets(6,0), totalSaledToken.mul(25).div(58));
423 
424         // 15% - team
425         token.mint(allocation, totalSaledToken.mul(15).div(58));
426     }
427 
428 
429 
430     // Initializing the round. Available to the manager. After calling the function,
431     // the Manager loses all rights: Manager can not change the settings (setup), change
432     // wallets, prevent the beginning of the round, etc. You must call a function after setup
433     // for the initial round (before the Round1 and before the Round2)
434     // @ Do I have to use the function      yes
435     // @ When it is possible to call        before each round
436     // @ When it is launched automatically  -
437     // @ Who can call the function          admins
438     function initialize() public {
439         require(rightAndRoles.onlyRoles(msg.sender,6));
440         // If not yet initialized
441         require(!isInitialized);
442         begin();
443 
444 
445         // And the specified start time has not yet come
446         // If initialization return an error, check the start date!
447         require(now <= startTime);
448 
449         initialization();
450 
451         emit Initialized();
452 
453         renewal = 0;
454 
455         isInitialized = true;
456 
457         canFirstMint = false;
458     }
459 
460     function initialization() internal {
461         bytes32[] memory params = new bytes32[](0);
462         rightAndRoles.setManagerPowerful(false);
463         if (financialStrategy.state() != IFinancialStrategy.State.Active){
464             financialStrategy.setup(2,params);
465         }
466     }
467 
468     // 
469     // @ Do I have to use the function      
470     // @ When it is possible to call        
471     // @ When it is launched automatically  
472     // @ Who can call the function          
473     function getPartnerCash(uint8 _user, bool _calc) external {
474         if(_calc)
475             calcFin();
476         financialStrategy.getPartnerCash(_user, msg.sender);
477     }
478 
479     function getBeneficiaryCash(bool _calc) public {
480         require(rightAndRoles.onlyRoles(msg.sender,22));
481         if(_calc)
482             calcFin();
483         financialStrategy.getBeneficiaryCash();
484         if(!isInitialized && financialStrategy.freeCash() == 0)
485             rightAndRoles.setManagerPowerful(true);
486     }
487 
488     function claimRefund() external{
489         financialStrategy.refund(msg.sender);
490     }
491 
492     function calcFin() public {
493         bytes32[] memory params = new bytes32[](2);
494         params[0] = bytes32(weiTotalRaised());
495         params[1] = bytes32(msg.sender);
496         financialStrategy.setup(4,params);
497     }
498 
499     function calcAndGet() public {
500         require(rightAndRoles.onlyRoles(msg.sender,22));
501         getBeneficiaryCash(true);
502         for (uint8 i=0; i<0; i++) { // <-- TODO check financialStrategy.wallets.length
503             financialStrategy.getPartnerCash(i, msg.sender);
504         }
505     }
506 
507     // We check whether we collected the necessary minimum funds. Constant.
508     function goalReached() public view returns (bool) {
509         return weiRaised() >= softCap;
510     }
511 
512 
513     // Customize. The arguments are described in the constructor above.
514     // @ Do I have to use the function      yes
515     // @ When it is possible to call        before each rond
516     // @ When it is launched automatically  -
517     // @ Who can call the function          admins
518     function setup(uint256 _startTime, uint256 _endTime, uint256 _softCap, uint256 _hardCap,
519         uint256 _rate, uint256 _exchange,
520         uint256 _maxAllProfit, uint256 _overLimit, uint256 _minPay,
521         uint256[] _durationTB , uint256[] _percentTB, uint256[] _valueVB, uint256[] _percentVB, uint256[] _freezeTimeVB) public
522     {
523 
524         require(rightAndRoles.onlyRoles(msg.sender,6));
525         require(!isInitialized);
526 
527         begin();
528 
529         // Date and time are correct
530         require(now <= _startTime);
531         require(_startTime < _endTime);
532 
533         startTime = _startTime;
534         endTime = _endTime;
535 
536         // The parameters are correct
537         require(_softCap <= _hardCap);
538 
539         softCap = _softCap;
540         hardCap = _hardCap;
541 
542         require(_rate > 0);
543 
544         rate = _rate;
545 
546         overLimit = _overLimit;
547         minPay = _minPay;
548         exchange = _exchange;
549 
550         maxAllProfit = _maxAllProfit;
551 
552         require(_valueVB.length == _percentVB.length && _valueVB.length == _freezeTimeVB.length);
553         bonuses.length = _valueVB.length;
554         for(uint256 i = 0; i < _valueVB.length; i++){
555             bonuses[i] = Bonus(_valueVB[i],_percentVB[i],_freezeTimeVB[i]);
556         }
557 
558         require(_percentTB.length == _durationTB.length);
559         profits.length = _percentTB.length;
560         for( i = 0; i < _percentTB.length; i++){
561             profits[i] = Profit(_percentTB[i],_durationTB[i]);
562         }
563 
564     }
565 
566     // Collected funds for the current round. Constant.
567     function weiRaised() public constant returns(uint256){
568         return ethWeiRaised.add(nonEthWeiRaised);
569     }
570 
571     // Returns the amount of fees for both phases. Constant.
572     function weiTotalRaised() public constant returns(uint256){
573         return weiRound1.add(weiRaised());
574     }
575 
576     // Returns the percentage of the bonus on the current date. Constant.
577     function getProfitPercent() public constant returns (uint256){
578         return getProfitPercentForData(now);
579     }
580 
581     // Returns the percentage of the bonus on the given date. Constant.
582     function getProfitPercentForData(uint256 _timeNow) public constant returns (uint256){
583         uint256 allDuration;
584         for(uint8 i = 0; i < profits.length; i++){
585             allDuration = allDuration.add(profits[i].duration);
586             if(_timeNow < startTime.add(allDuration)){
587                 return profits[i].percent;
588             }
589         }
590         return 0;
591     }
592 
593     function getBonuses(uint256 _value) public constant returns (uint256,uint256,uint256){
594         if(bonuses.length == 0 || bonuses[0].value > _value){
595             return (0,0,0);
596         }
597         uint16 i = 1;
598         for(i; i < bonuses.length; i++){
599             if(bonuses[i].value > _value){
600                 break;
601             }
602         }
603         return (bonuses[i-1].value,bonuses[i-1].procent,bonuses[i-1].freezeTime);
604     }
605 
606 
607     // Remove the "Pause of exchange". Available to the manager at any time. If the
608     // manager refuses to remove the pause, then 30-120 days after the successful
609     // completion of the TokenSale, anyone can remove a pause and allow the exchange to continue.
610     // The manager does not interfere and will not be able to delay the term.
611     // He can only cancel the pause before the appointed time.
612     // @ Do I have to use the function      YES YES YES
613     // @ When it is possible to call        after end of ICO
614     // @ When it is launched automatically  -
615     // @ Who can call the function          admins or anybody
616     function tokenUnpause() external {
617 
618         require(rightAndRoles.onlyRoles(msg.sender,2)
619         || (now > endTime.add(renewal).add(USER_UNPAUSE_TOKEN_TIMEOUT) && TokenSale == TokenSaleType.round2 && isFinalized && goalReached()));
620         token.setPause(false);
621     }
622 
623     // Enable the "Pause of exchange". Available to the manager until the TokenSale is completed.
624     // The manager cannot turn on the pause, for example, 3 years after the end of the TokenSale.
625     // @ Do I have to use the function      no
626     // @ When it is possible to call        while Round2 not ended
627     // @ When it is launched automatically  before any rounds
628     // @ Who can call the function          admins
629     function tokenPause() public {
630         require(rightAndRoles.onlyRoles(msg.sender,6));
631         require(!isFinalized);
632         token.setPause(true);
633     }
634 
635     // Pause of sale. Available to the manager.
636     // @ Do I have to use the function      no
637     // @ When it is possible to call        during active rounds
638     // @ When it is launched automatically  -
639     // @ Who can call the function          admins
640     function setCrowdsalePause(bool mode) public {
641         require(rightAndRoles.onlyRoles(msg.sender,6));
642         isPausedCrowdsale = mode;
643     }
644 
645     // For example - After 5 years of the project's existence, all of us suddenly decided collectively
646     // (company + investors) that it would be more profitable for everyone to switch to another smart
647     // contract responsible for tokens. The company then prepares a new token, investors
648     // disassemble, study, discuss, etc. After a general agreement, the manager allows any investor:
649     //      - to burn the tokens of the previous contract
650     //      - generate new tokens for a new contract
651     // It is understood that after a general solution through this function all investors
652     // will collectively (and voluntarily) move to a new token.
653     // @ Do I have to use the function      no
654     // @ When it is possible to call        only after ICO!
655     // @ When it is launched automatically  -
656     // @ Who can call the function          admins
657     function moveTokens(address _migrationAgent) public {
658         require(rightAndRoles.onlyRoles(msg.sender,6));
659         token.setMigrationAgent(_migrationAgent);
660     }
661 
662     // @ Do I have to use the function      no
663     // @ When it is possible to call        only after ICO!
664     // @ When it is launched automatically  -
665     // @ Who can call the function          admins
666     function migrateAll(address[] _holders) public {
667         require(rightAndRoles.onlyRoles(msg.sender,6));
668         token.migrateAll(_holders);
669     }
670 
671 
672     // Burn the investor tokens, if provided by the ICO scenario. Limited time available - BURN_TOKENS_TIME
673     // For people who ignore the KYC/AML procedure during 30 days after payment: money back and burning tokens.
674     // ***CHECK***SCENARIO***
675     // @ Do I have to use the function      no
676     // @ When it is possible to call        any time
677     // @ When it is launched automatically  -
678     // @ Who can call the function          admin
679 //    function massBurnTokens(address[] _beneficiary, uint256[] _value) external {
680 //        require(rightAndRoles.onlyRoles(msg.sender,6));
681 //        require(endTime.add(renewal).add(BURN_TOKENS_TIME) > now);
682 //        require(_beneficiary.length == _value.length);
683 //        for(uint16 i; i<_beneficiary.length; i++) {
684 //            token.burn(_beneficiary[i],_value[i]);
685 //        }
686 //    }
687 
688     // Extend the round time, if provided by the script. Extend the round only for
689     // a limited number of days - ROUND_PROLONGATE
690     // ***CHECK***SCENARIO***
691     // @ Do I have to use the function      no
692     // @ When it is possible to call        during active round
693     // @ When it is launched automatically  -
694     // @ Who can call the function          admins
695     function prolong(uint256 _duration) external {
696         require(rightAndRoles.onlyRoles(msg.sender,6));
697         require(now > startTime && now < endTime.add(renewal) && isInitialized && !isFinalized);
698         renewal = renewal.add(_duration);
699         require(renewal <= ROUND_PROLONGATE);
700 
701     }
702     // If a little more than a year has elapsed (Round2 start date + 400 days), a smart contract
703     // will allow you to send all the money to the Beneficiary, if any money is present. This is
704     // possible if you mistakenly launch the Round2 for 30 years (not 30 days), investors will transfer
705     // money there and you will not be able to pick them up within a reasonable time. It is also
706     // possible that in our checked script someone will make unforeseen mistakes, spoiling the
707     // finalization. Without finalization, money cannot be returned. This is a rescue option to
708     // get around this problem, but available only after a year (400 days).
709 
710     // Another reason - the TokenSale was a failure, but not all ETH investors took their money during the year after.
711     // Some investors may have lost a wallet key, for example.
712 
713     // The method works equally with the Round1 and Round2. When the Round1 starts, the time for unlocking
714     // the distructVault begins. If the TokenSale is then started, then the term starts anew from the first day of the TokenSale.
715 
716     // Next, act independently, in accordance with obligations to investors.
717 
718     // Within 400 days (FORCED_REFUND_TIMEOUT1) of the start of the Round, if it fails only investors can take money. After
719     // the deadline this can also include the company as well as investors, depending on who is the first to use the method.
720     // @ Do I have to use the function      no
721     // @ When it is possible to call        -
722     // @ When it is launched automatically  -
723     // @ Who can call the function          beneficiary & manager
724     function distructVault() public {
725         bytes32[] memory params = new bytes32[](1);
726         params[0] = bytes32(msg.sender);
727         if (rightAndRoles.onlyRoles(msg.sender,4) && (now > startTime.add(FORCED_REFUND_TIMEOUT1))) {
728 
729             financialStrategy.setup(0,params);
730         }
731         if (rightAndRoles.onlyRoles(msg.sender,2) && (now > startTime.add(FORCED_REFUND_TIMEOUT2))) {
732             financialStrategy.setup(0,params);
733         }
734     }
735 
736 
737     // We accept payments other than Ethereum (ETH) and other currencies, for example, Bitcoin (BTC).
738     // Perhaps other types of cryptocurrency - see the original terms in the white paper and on the TokenSale website.
739 
740     // We release tokens on Ethereum. During the Round1 and Round2 with a smart contract, you directly transfer
741     // the tokens there and immediately, with the same transaction, receive tokens in your wallet.
742 
743     // When paying in any other currency, for example in BTC, we accept your money via one common wallet.
744     // Our manager fixes the amount received for the bitcoin wallet and calls the method of the smart
745     // contract paymentsInOtherCurrency to inform him how much foreign currency has been received - on a daily basis.
746     // The smart contract pins the number of accepted ETH directly and the number of BTC. Smart contract
747     // monitors softcap and hardcap, so as not to go beyond this framework.
748 
749     // In theory, it is possible that when approaching hardcap, we will receive a transfer (one or several
750     // transfers) to the wallet of BTC, that together with previously received money will exceed the hardcap in total.
751     // In this case, we will refund all the amounts above, in order not to exceed the hardcap.
752 
753     // Collection of money in BTC will be carried out via one common wallet. The wallet's address will be published
754     // everywhere (in a white paper, on the TokenSale website, on Telegram, on Bitcointalk, in this code, etc.)
755     // Anyone interested can check that the administrator of the smart contract writes down exactly the amount
756     // in ETH (in equivalent for BTC) there. In theory, the ability to bypass a smart contract to accept money in
757     // BTC and not register them in ETH creates a possibility for manipulation by the company. Thanks to
758     // paymentsInOtherCurrency however, this threat is leveled.
759 
760     // Any user can check the amounts in BTC and the variable of the smart contract that accounts for this
761     // (paymentsInOtherCurrency method). Any user can easily check the incoming transactions in a smart contract
762     // on a daily basis. Any hypothetical tricks on the part of the company can be exposed and panic during the TokenSale,
763     // simply pointing out the incompatibility of paymentsInOtherCurrency (ie, the amount of ETH + BTC collection)
764     // and the actual transactions in BTC. The company strictly adheres to the described principles of openness.
765 
766     // The company administrator is required to synchronize paymentsInOtherCurrency every working day (but you
767     // cannot synchronize if there are no new BTC payments). In the case of unforeseen problems, such as
768     // brakes on the Ethereum network, this operation may be difficult. You should only worry if the
769     // administrator does not synchronize the amount for more than 96 hours in a row, and the BTC wallet
770     // receives significant amounts.
771 
772     // This scenario ensures that for the sum of all fees in all currencies this value does not exceed hardcap.
773 
774     // ** QUINTILLIONS ** 10^18 / 1**18 / 1e18
775 
776     // @ Do I have to use the function      no
777     // @ When it is possible to call        during active rounds
778     // @ When it is launched automatically  every day from cryptob2b token software
779     // @ Who can call the function          admins + observer
780     function paymentsInOtherCurrency(uint256 _token, uint256 _value) public {
781 
782         // **For audit**
783         // BTC Wallet:             1HQahivPX2cU5Nq921wSuULpuZyi9AcXCY
784         require(rightAndRoles.onlyRoles(msg.sender,18));
785         bool withinPeriod = (now >= startTime && now <= endTime.add(renewal));
786         bool withinCap = _value.add(ethWeiRaised) <= hardCap.add(overLimit);
787         require(withinPeriod && withinCap && isInitialized && !isFinalized);
788         emit PaymentedInOtherCurrency(_token,_value);
789         nonEthWeiRaised = _value;
790         tokenReserved = _token;
791 
792     }
793 
794     function lokedMint(address _beneficiary, uint256 _value, uint256 _freezeTime) internal {
795         if(_freezeTime > 0){
796 
797             uint256 totalBloked = token.freezedTokenOf(_beneficiary).add(_value);
798             uint256 pastDateUnfreeze = token.defrostDate(_beneficiary);
799             uint256 newDateUnfreeze = _freezeTime.add(now);
800             newDateUnfreeze = (pastDateUnfreeze > newDateUnfreeze ) ? pastDateUnfreeze : newDateUnfreeze;
801 
802             token.freezeTokens(_beneficiary,totalBloked,newDateUnfreeze);
803         }
804         token.mint(_beneficiary,_value);
805     }
806 
807 
808     // The function for obtaining smart contract funds in ETH. If all the checks are true, the token is
809     // transferred to the buyer, taking into account the current bonus.
810     function buyTokens(address _beneficiary) public payable {
811         require(_beneficiary != 0x0);
812         require(validPurchase());
813 
814         uint256 weiAmount = msg.value;
815 
816         uint256 ProfitProcent = getProfitPercent();
817 
818         uint256 value;
819         uint256 percent;
820         uint256 freezeTime;
821 
822         (value,
823         percent,
824         freezeTime) = getBonuses(weiAmount);
825 
826         Bonus memory curBonus = Bonus(value,percent,freezeTime);
827 
828         uint256 bonus = curBonus.procent;
829 
830         // --------------------------------------------------------------------------------------------
831         // *** Scenario 1 - select max from all bonuses + check maxAllProfit
832         //uint256 totalProfit = (ProfitProcent < bonus) ? bonus : ProfitProcent;
833         // *** Scenario 2 - sum both bonuses + check maxAllProfit
834         uint256 totalProfit = bonus.add(ProfitProcent);
835         // --------------------------------------------------------------------------------------------
836         totalProfit = (totalProfit > maxAllProfit) ? maxAllProfit : totalProfit;
837 
838         // calculate token amount to be created
839         uint256 tokens = weiAmount.mul(rate).mul(totalProfit.add(100)).div(100 ether);
840 
841         // update state
842         ethWeiRaised = ethWeiRaised.add(weiAmount);
843 
844         lokedMint(_beneficiary, tokens, curBonus.freezeTime);
845 
846         emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
847 
848         forwardFunds(_beneficiary);//forwardFunds(msg.sender);
849     }
850 
851     // buyTokens alias
852     function () public payable {
853         buyTokens(msg.sender);
854     }
855 }