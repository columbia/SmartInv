1 pragma solidity ^0.4.21;
2 
3 // Project: alehub.io
4 // v11, 2018-07-17
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
22 contract IFinancialStrategy{
23 
24     enum State { Active, Refunding, Closed }
25     State public state = State.Active;
26 
27     event Deposited(address indexed beneficiary, uint256 weiAmount);
28     event Receive(address indexed beneficiary, uint256 weiAmount);
29     event Refunded(address indexed beneficiary, uint256 weiAmount);
30     event Started();
31     event Closed();
32     event RefundsEnabled();
33     function freeCash() view public returns(uint256);
34     function deposit(address _beneficiary) external payable;
35     function refund(address _investor) external;
36     function setup(uint8 _state, bytes32[] _params) external;
37     function getBeneficiaryCash() external;
38     function getPartnerCash(uint8 _user, address _msgsender) external;
39 }
40 
41 contract ICreator{
42     IRightAndRoles public rightAndRoles;
43     function createAllocation(IToken _token, uint256 _unlockPart1, uint256 _unlockPart2) external returns (IAllocation);
44     function createFinancialStrategy() external returns(IFinancialStrategy);
45     function getRightAndRoles() external returns(IRightAndRoles);
46 }
47 
48 contract IToken{
49     function setUnpausedWallet(address _wallet, bool mode) public;
50     function mint(address _to, uint256 _amount) public returns (bool);
51     function totalSupply() public view returns (uint256);
52     function setPause(bool mode) public;
53     function setMigrationAgent(address _migrationAgent) public;
54     function migrateAll(address[] _holders) public;
55     function rejectTokens(address _beneficiary, uint256 _value) public;
56     function freezedTokenOf(address _beneficiary) public view returns (uint256 amount);
57     function defrostDate(address _beneficiary) public view returns (uint256 Date);
58     function freezeTokens(address _beneficiary, uint256 _amount, uint256 _when) public;
59 }
60 
61 library SafeMath {
62     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
63         if (a == 0) {
64             return 0;
65         }
66         uint256 c = a * b;
67         assert(c / a == b);
68         return c;
69     }
70     function div(uint256 a, uint256 b) internal pure returns (uint256) {
71         uint256 c = a / b;
72         return c;
73     }
74     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75         assert(b <= a);
76         return a - b;
77     }
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         assert(c >= a);
81         return c;
82     }
83     function minus(uint256 a, uint256 b) internal pure returns (uint256) {
84         if (b>=a) return 0;
85         return a - b;
86     }
87 }
88 
89 contract GuidedByRoles {
90     IRightAndRoles public rightAndRoles;
91     function GuidedByRoles(IRightAndRoles _rightAndRoles) public {
92         rightAndRoles = _rightAndRoles;
93     }
94 }
95 
96 contract ERC20Provider is GuidedByRoles {
97     function transferTokens(ERC20Basic _token, address _to, uint256 _value) public returns (bool){
98         require(rightAndRoles.onlyRoles(msg.sender,2));
99         return _token.transfer(_to,_value);
100     }
101 }
102 
103 contract Crowdsale is GuidedByRoles, ERC20Provider{
104 // (A1)
105 // The main contract for the sale and management of rounds.
106 // 0000000000000000000000000000000000000000000000000000000000000000
107 
108     uint256 constant USER_UNPAUSE_TOKEN_TIMEOUT =  60 days;
109     uint256 constant FORCED_REFUND_TIMEOUT1     = 400 days;
110     uint256 constant FORCED_REFUND_TIMEOUT2     = 600 days;
111     uint256 constant ROUND_PROLONGATE           =  60 days;
112     uint256 constant KYC_PERIOD                 =  90 days;
113     bool constant    GLOBAL_TOKEN_SYPPLY        =    false;
114 
115     using SafeMath for uint256;
116 
117     enum TokenSaleType {round1, round2}
118     TokenSaleType public TokenSale = TokenSaleType.round2;
119 
120 
121     ICreator public creator;
122     bool isBegin=false;
123 
124     IToken public token;
125     IAllocation public allocation;
126     IFinancialStrategy public financialStrategy;
127 
128     bool public isFinalized;
129     bool public isInitialized;
130     bool public isPausedCrowdsale;
131     bool public chargeBonuses;
132     bool public canFirstMint=true;
133 
134     struct Bonus {
135         uint256 value;
136         uint256 procent;
137         uint256 freezeTime;
138     }
139 
140     struct Profit {
141         uint256 percent;
142         uint256 duration;
143     }
144 
145     struct Freezed {
146         uint256 value;
147         uint256 dateTo;
148     }
149 
150     Bonus[] public bonuses;
151     Profit[] public profits;
152 
153 
154     uint256 public startTime= 1532476800;  //25.07.2018 0:00:00
155     uint256 public endTime  = 1537833599;  //24.09.2018 23:59:59
156     uint256 public renewal;
157 
158     // How many tokens (excluding the bonus) are transferred to the investor in exchange for 1 ETH
159     // **THOUSANDS** 10^18 for human, *10**18 for Solidity, 1e18 for MyEtherWallet (MEW).
160     // Example: if 1ETH = 40.5 Token ==> use 40500 finney
161     uint256 public rate = 2333 ether; // $0.1 (ETH/USD=$500)
162 
163     // ETH/USD rate in US$
164     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: ETH/USD=$1000 ==> use 1000*10**18 (Solidity) or 1000 ether or 1000e18 (MEW)
165     uint256 public exchange  = 700 ether;
166 
167     // If the round does not attain this value before the closing date, the round is recognized as a
168     // failure and investors take the money back (the founders will not interfere in any way).
169     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: softcap=15ETH ==> use 15*10**18 (Solidity) or 15e18 (MEW)
170     uint256 public softCap = 0;
171 
172     // The maximum possible amount of income
173     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: hardcap=123.45ETH ==> use 123450*10**15 (Solidity) or 12345e15 (MEW)
174     uint256 public hardCap = 45413 ether; // $31M (ETH/USD=$500)
175 
176     // If the last payment is slightly higher than the hardcap, then the usual contracts do
177     // not accept it, because it goes beyond the hardcap. However it is more reasonable to accept the
178     // last payment, very slightly raising the hardcap. The value indicates by how many ETH the
179     // last payment can exceed the hardcap to allow it to be paid. Immediately after this payment, the
180     // round closes. The funders should write here a small number, not more than 1% of the CAP.
181     // Can be equal to zero, to cancel.
182     // **QUINTILLIONS** 10^18 / *10**18 / 1e18
183     uint256 public overLimit = 20 ether;
184 
185     // The minimum possible payment from an investor in ETH. Payments below this value will be rejected.
186     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: minPay=0.1ETH ==> use 100*10**15 (Solidity) or 100e15 (MEW)
187     uint256 public minPay = 43 finney;
188 
189     uint256 public maxAllProfit = 30; // max time bonus=20%, max value bonus=10%, maxAll=10%+20%
190 
191     uint256 public ethWeiRaised;
192     uint256 public nonEthWeiRaised;
193     uint256 public weiRound1;
194     uint256 public tokenReserved;
195 
196     uint256 public totalSaledToken;
197 
198     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
199 
200     event Finalized();
201     event Initialized();
202 
203     event PaymentedInOtherCurrency(uint256 token, uint256 value);
204     event ExchangeChanged(uint256 indexed oldExchange, uint256 indexed newExchange);
205 
206     function Crowdsale(ICreator _creator,IToken _token) GuidedByRoles(_creator.getRightAndRoles()) public
207     {
208         creator=_creator;
209         token = _token;
210     }
211 
212     // Setting the current rate ETH/USD         
213 //    function changeExchange(uint256 _ETHUSD) public {
214 //        require(rightAndRoles.onlyRoles(msg.sender,18));
215 //        require(_ETHUSD >= 1 ether);
216 //        emit ExchangeChanged(exchange,_ETHUSD);
217 //        softCap=softCap.mul(exchange).div(_ETHUSD);             // QUINTILLIONS
218 //        hardCap=hardCap.mul(exchange).div(_ETHUSD);             // QUINTILLIONS
219 //        minPay=minPay.mul(exchange).div(_ETHUSD);               // QUINTILLIONS
220 //
221 //        rate=rate.mul(_ETHUSD).div(exchange);                   // QUINTILLIONS
222 //
223 //        for (uint16 i = 0; i < bonuses.length; i++) {
224 //            bonuses[i].value=bonuses[i].value.mul(exchange).div(_ETHUSD);   // QUINTILLIONS
225 //        }
226 //        bytes32[] memory params = new bytes32[](2);
227 //        params[0] = bytes32(exchange);
228 //        params[1] = bytes32(_ETHUSD);
229 //        financialStrategy.setup(5, params);
230 //
231 //        exchange=_ETHUSD;
232 //
233 //    }
234 
235     // Setting of basic parameters, analog of class constructor
236     // @ Do I have to use the function      see your scenario
237     // @ When it is possible to call        before Round 1/2
238     // @ When it is launched automatically  -
239     // @ Who can call the function          admins
240     function begin() public
241     {
242         require(rightAndRoles.onlyRoles(msg.sender,22));
243         if (isBegin) return;
244         isBegin=true;
245 
246         financialStrategy = creator.createFinancialStrategy();
247 
248         if(GLOBAL_TOKEN_SYPPLY){
249             totalSaledToken = token.totalSupply();
250         }
251 
252         token.setUnpausedWallet(rightAndRoles.wallets(1,0), true);
253         token.setUnpausedWallet(rightAndRoles.wallets(3,0), true);
254         token.setUnpausedWallet(rightAndRoles.wallets(4,0), true);
255         token.setUnpausedWallet(rightAndRoles.wallets(5,0), true);
256         token.setUnpausedWallet(rightAndRoles.wallets(6,0), true);
257 
258         bonuses.push(Bonus(1429 finney, 2,0));
259         bonuses.push(Bonus(14286 finney, 5,0));
260         bonuses.push(Bonus(142857 finney, 10,0));
261 
262         profits.push(Profit(20,5 days));
263         profits.push(Profit(15,5 days));
264         profits.push(Profit(10,5 days));
265         profits.push(Profit(5,5 days));
266     }
267 
268 
269 
270     // Issue of tokens for the zero round, it is usually called: private pre-sale (Round 0)
271     // @ Do I have to use the function      may be
272     // @ When it is possible to call        before Round 1/2
273     // @ When it is launched automatically  -
274     // @ Who can call the function          admins
275     function firstMintRound0(uint256 _amount /* QUINTILLIONS! */) public {
276         require(rightAndRoles.onlyRoles(msg.sender,6));
277         require(canFirstMint);
278         begin();
279         token.mint(rightAndRoles.wallets(3,0),_amount);
280         totalSaledToken = totalSaledToken.add(_amount);
281     }
282 
283     function firstMintRound0For(address[] _to, uint256[] _amount, bool[] _setAsUnpaused) public {
284         require(rightAndRoles.onlyRoles(msg.sender,6));
285         require(canFirstMint);
286         begin();
287         require(_to.length == _amount.length && _to.length == _setAsUnpaused.length);
288         for(uint256 i = 0; i < _to.length; i++){
289             token.mint(_to[i],_amount[i]);
290             totalSaledToken = totalSaledToken.add(_amount[i]);
291             if(_setAsUnpaused[i]){
292                 token.setUnpausedWallet(_to[i], true);
293             }
294         }
295     }
296 
297     // info
298     function totalSupply() external view returns (uint256){
299         return token.totalSupply();
300     }
301 
302     // Returns the name of the current round in plain text. Constant.
303     function getTokenSaleType() external view returns(string){
304         return (TokenSale == TokenSaleType.round1)?'round1':'round2';
305     }
306 
307     // Transfers the funds of the investor to the contract of return of funds. Internal.
308     function forwardFunds(address _beneficiary) internal {
309         financialStrategy.deposit.value(msg.value)(_beneficiary);
310     }
311 
312     // Check for the possibility of buying tokens. Inside. Constant.
313     function validPurchase() internal view returns (bool) {
314 
315         // The round started and did not end
316         bool withinPeriod = (now > startTime && now < endTime.add(renewal));
317 
318         // Rate is greater than or equal to the minimum
319         bool nonZeroPurchase = msg.value >= minPay;
320 
321         // hardCap is not reached, and in the event of a transaction, it will not be exceeded by more than OverLimit
322         bool withinCap = msg.value <= hardCap.sub(weiRaised()).add(overLimit);
323 
324         // round is initialized and no "Pause of trading" is set
325         return withinPeriod && nonZeroPurchase && withinCap && isInitialized && !isFinalized && !isPausedCrowdsale;
326     }
327 
328     // Check for the ability to finalize the round. Constant.
329     function hasEnded() public view returns (bool) {
330         bool isAdmin = rightAndRoles.onlyRoles(msg.sender,6);
331 
332         bool timeReached = now > endTime.add(renewal);
333 
334         bool capReached = weiRaised() >= hardCap;
335 
336         return (timeReached || capReached || (isAdmin && goalReached())) && isInitialized && !isFinalized;
337     }
338 
339     // Finalize. Only available to the Manager and the Beneficiary. If the round failed, then
340     // anyone can call the finalization to unlock the return of funds to investors
341     // You must call a function to finalize each round (after the Round1 & after the Round2)
342     // @ Do I have to use the function      yes
343     // @ When it is possible to call        after end of Round1 & Round2
344     // @ When it is launched automatically  no
345     // @ Who can call the function          admins or anybody (if round is failed)
346     function finalize() public {
347         require(hasEnded());
348 
349         isFinalized = true;
350         finalization();
351         emit Finalized();
352     }
353 
354     // The logic of finalization. Internal
355     // @ Do I have to use the function      no
356     // @ When it is possible to call        -
357     // @ When it is launched automatically  after end of round
358     // @ Who can call the function          -
359     function finalization() internal {
360         bytes32[] memory params = new bytes32[](0);
361         // If the goal of the achievement
362         if (goalReached()) {
363 
364             financialStrategy.setup(1,params);//Для контракта Buz деньги не возвращает.
365 
366             // if there is anything to give
367             if (tokenReserved > 0) {
368 
369                 token.mint(rightAndRoles.wallets(3,0),tokenReserved);
370                 totalSaledToken = totalSaledToken.add(tokenReserved);
371 
372                 // Reset the counter
373                 tokenReserved = 0;
374             }
375 
376             // If the finalization is Round 1
377             if (TokenSale == TokenSaleType.round1) {
378 
379                 // Reset settings
380                 isInitialized = false;
381                 isFinalized = false;
382                 if(financialStrategy.freeCash() == 0){
383                     rightAndRoles.setManagerPowerful(true);
384                 }
385 
386                 // Switch to the second round (to Round2)
387                 TokenSale = TokenSaleType.round2;
388 
389                 // Reset the collection counter
390                 weiRound1 = weiRaised();
391                 ethWeiRaised = 0;
392                 nonEthWeiRaised = 0;
393 
394 
395 
396             }
397             else // If the second round is finalized
398             {
399 
400                 // Permission to collect tokens to those who can pick them up
401                 chargeBonuses = true;
402 
403                 //totalSaledToken = token.totalSupply();
404                 //partners = true;
405 
406             }
407 
408         }
409         else // If they failed round
410         {
411             financialStrategy.setup(3,params);
412         }
413     }
414 
415     // The Manager freezes the tokens for the Team.
416     // You must call a function to finalize Round 2 (only after the Round2)
417     // @ Do I have to use the function      yes
418     // @ When it is possible to call        Round2
419     // @ When it is launched automatically  -
420     // @ Who can call the function          admins
421     function finalize2() public {
422         require(rightAndRoles.onlyRoles(msg.sender,6));
423         require(chargeBonuses);
424         chargeBonuses = false;
425 
426         allocation = creator.createAllocation(token, now + 1 years /* stage N1 */,0/* not need*/);
427         token.setUnpausedWallet(allocation, true);
428         // Team = %, Founders = %, Fund = %    TOTAL = %
429         allocation.addShare(rightAndRoles.wallets(7,0),100,100); // all 100% - first year
430 
431         // 2% - bounty wallet
432         token.mint(rightAndRoles.wallets(5,0), totalSaledToken.mul(2).div(77));
433 
434         // 10% - company
435         token.mint(rightAndRoles.wallets(6,0), totalSaledToken.mul(10).div(77));
436 
437         // 13% - team
438         token.mint(allocation, totalSaledToken.mul(11).div(77));
439     }
440 
441 
442 
443     // Initializing the round. Available to the manager. After calling the function,
444     // the Manager loses all rights: Manager can not change the settings (setup), change
445     // wallets, prevent the beginning of the round, etc. You must call a function after setup
446     // for the initial round (before the Round1 and before the Round2)
447     // @ Do I have to use the function      yes
448     // @ When it is possible to call        before each round
449     // @ When it is launched automatically  -
450     // @ Who can call the function          admins
451     function initialize() public {
452         require(rightAndRoles.onlyRoles(msg.sender,6));
453         // If not yet initialized
454         require(!isInitialized);
455         begin();
456 
457 
458         // And the specified start time has not yet come
459         // If initialization return an error, check the start date!
460         //require(now <= startTime);
461 
462         initialization();
463 
464         emit Initialized();
465 
466         renewal = 0;
467 
468         isInitialized = true;
469 
470         canFirstMint = false;
471     }
472 
473     function initialization() internal {
474         bytes32[] memory params = new bytes32[](0);
475         rightAndRoles.setManagerPowerful(false);
476         if (financialStrategy.state() != IFinancialStrategy.State.Active){
477             financialStrategy.setup(2,params);
478         }
479     }
480 
481     // 
482     // @ Do I have to use the function      
483     // @ When it is possible to call        
484     // @ When it is launched automatically  
485     // @ Who can call the function          
486     function getPartnerCash(uint8 _user, bool _calc) external {
487         if(_calc)
488             calcFin();
489         financialStrategy.getPartnerCash(_user, msg.sender);
490     }
491 
492     function getBeneficiaryCash(bool _calc) public {
493         require(rightAndRoles.onlyRoles(msg.sender,22));
494         if(_calc)
495             calcFin();
496         financialStrategy.getBeneficiaryCash();
497         if(!isInitialized && financialStrategy.freeCash() == 0)
498             rightAndRoles.setManagerPowerful(true);
499     }
500 
501     function claimRefund() external{
502         financialStrategy.refund(msg.sender);
503     }
504 
505     function calcFin() public {
506         bytes32[] memory params = new bytes32[](2);
507         params[0] = bytes32(weiTotalRaised());
508         params[1] = bytes32(msg.sender);
509         financialStrategy.setup(4,params);
510     }
511 
512     function calcAndGet() public {
513         require(rightAndRoles.onlyRoles(msg.sender,22));
514         getBeneficiaryCash(true);
515         for (uint8 i=0; i<0; i++) {
516             financialStrategy.getPartnerCash(i, msg.sender);
517         }
518     }
519 
520     // We check whether we collected the necessary minimum funds. Constant.
521     function goalReached() public view returns (bool) {
522         return weiRaised() >= softCap;
523     }
524 
525 
526     // Customize. The arguments are described in the constructor above.
527     // @ Do I have to use the function      yes
528     // @ When it is possible to call        before each rond
529     // @ When it is launched automatically  -
530     // @ Who can call the function          admins
531     function setup(uint256 _startTime, uint256 _endTime, uint256 _softCap, uint256 _hardCap,
532         uint256 _rate, uint256 _exchange,
533         uint256 _maxAllProfit, uint256 _overLimit, uint256 _minPay,
534         uint256[] _durationTB , uint256[] _percentTB, uint256[] _valueVB, uint256[] _percentVB, uint256[] _freezeTimeVB) public
535     {
536 
537         require(rightAndRoles.onlyRoles(msg.sender,6));
538         require(!isInitialized);
539 
540         begin();
541 
542         // Date and time are correct
543         //require(now <= _startTime);
544         require(_startTime < _endTime);
545 
546         startTime = _startTime;
547         endTime = _endTime;
548 
549         // The parameters are correct
550         require(_softCap <= _hardCap);
551 
552         softCap = _softCap;
553         hardCap = _hardCap;
554 
555         require(_rate > 0);
556 
557         rate = _rate;
558 
559         overLimit = _overLimit;
560         minPay = _minPay;
561         exchange = _exchange;
562 
563         maxAllProfit = _maxAllProfit;
564 
565         require(_valueVB.length == _percentVB.length && _valueVB.length == _freezeTimeVB.length);
566         bonuses.length = _valueVB.length;
567         for(uint256 i = 0; i < _valueVB.length; i++){
568             bonuses[i] = Bonus(_valueVB[i],_percentVB[i],_freezeTimeVB[i]);
569         }
570 
571         require(_percentTB.length == _durationTB.length);
572         profits.length = _percentTB.length;
573         for( i = 0; i < _percentTB.length; i++){
574             profits[i] = Profit(_percentTB[i],_durationTB[i]);
575         }
576 
577     }
578 
579     // Collected funds for the current round. Constant.
580     function weiRaised() public constant returns(uint256){
581         return ethWeiRaised.add(nonEthWeiRaised);
582     }
583 
584     // Returns the amount of fees for both phases. Constant.
585     function weiTotalRaised() public constant returns(uint256){
586         return weiRound1.add(weiRaised());
587     }
588 
589     // Returns the percentage of the bonus on the current date. Constant.
590     function getProfitPercent() public constant returns (uint256){
591         return getProfitPercentForData(now);
592     }
593 
594     // Returns the percentage of the bonus on the given date. Constant.
595     function getProfitPercentForData(uint256 _timeNow) public constant returns (uint256){
596         uint256 allDuration;
597         for(uint8 i = 0; i < profits.length; i++){
598             allDuration = allDuration.add(profits[i].duration);
599             if(_timeNow < startTime.add(allDuration)){
600                 return profits[i].percent;
601             }
602         }
603         return 0;
604     }
605 
606     function getBonuses(uint256 _value) public constant returns (uint256,uint256,uint256){
607         if(bonuses.length == 0 || bonuses[0].value > _value){
608             return (0,0,0);
609         }
610         uint16 i = 1;
611         for(i; i < bonuses.length; i++){
612             if(bonuses[i].value > _value){
613                 break;
614             }
615         }
616         return (bonuses[i-1].value,bonuses[i-1].procent,bonuses[i-1].freezeTime);
617     }
618 
619 
620     // Remove the "Pause of exchange". Available to the manager at any time. If the
621     // manager refuses to remove the pause, then 30-120 days after the successful
622     // completion of the TokenSale, anyone can remove a pause and allow the exchange to continue.
623     // The manager does not interfere and will not be able to delay the term.
624     // He can only cancel the pause before the appointed time.
625     // @ Do I have to use the function      YES YES YES
626     // @ When it is possible to call        after end of ICO
627     // @ When it is launched automatically  -
628     // @ Who can call the function          admins or anybody
629     function tokenUnpause() external {
630 
631         require(rightAndRoles.onlyRoles(msg.sender,2)
632         || (now > endTime.add(renewal).add(USER_UNPAUSE_TOKEN_TIMEOUT) && TokenSale == TokenSaleType.round2 && isFinalized && goalReached()));
633         token.setPause(false);
634     }
635 
636     // Enable the "Pause of exchange". Available to the manager until the TokenSale is completed.
637     // The manager cannot turn on the pause, for example, 3 years after the end of the TokenSale.
638     // @ Do I have to use the function      no
639     // @ When it is possible to call        while Round2 not ended
640     // @ When it is launched automatically  before any rounds
641     // @ Who can call the function          admins
642     function tokenPause() public {
643         require(rightAndRoles.onlyRoles(msg.sender,6));
644         require(!isFinalized);
645         token.setPause(true);
646     }
647 
648     // Pause of sale. Available to the manager.
649     // @ Do I have to use the function      no
650     // @ When it is possible to call        during active rounds
651     // @ When it is launched automatically  -
652     // @ Who can call the function          admins
653     function setCrowdsalePause(bool mode) public {
654         require(rightAndRoles.onlyRoles(msg.sender,6));
655         isPausedCrowdsale = mode;
656     }
657 
658     // For example - After 5 years of the project's existence, all of us suddenly decided collectively
659     // (company + investors) that it would be more profitable for everyone to switch to another smart
660     // contract responsible for tokens. The company then prepares a new token, investors
661     // disassemble, study, discuss, etc. After a general agreement, the manager allows any investor:
662     //      - to burn the tokens of the previous contract
663     //      - generate new tokens for a new contract
664     // It is understood that after a general solution through this function all investors
665     // will collectively (and voluntarily) move to a new token.
666     // @ Do I have to use the function      no
667     // @ When it is possible to call        only after ICO!
668     // @ When it is launched automatically  -
669     // @ Who can call the function          admins
670     function moveTokens(address _migrationAgent) public {
671         require(rightAndRoles.onlyRoles(msg.sender,6));
672         token.setMigrationAgent(_migrationAgent);
673     }
674 
675     // @ Do I have to use the function      no
676     // @ When it is possible to call        only after ICO!
677     // @ When it is launched automatically  -
678     // @ Who can call the function          admins
679     function migrateAll(address[] _holders) public {
680         require(rightAndRoles.onlyRoles(msg.sender,6));
681         token.migrateAll(_holders);
682     }
683 
684 
685     // For people who ignore the KYC/AML procedure during 30 days after payment (KYC_PERIOD): money back and zeroing tokens.
686     // ***CHECK***SCENARIO***
687     // @ Do I have to use the function      no
688     // @ When it is possible to call        any time
689     // @ When it is launched automatically  -
690     // @ Who can call the function          admin
691     function invalidPayments(address[] _beneficiary, uint256[] _value) external {
692         require(rightAndRoles.onlyRoles(msg.sender,6));
693         require(endTime.add(renewal).add(KYC_PERIOD) > now);
694         require(_beneficiary.length == _value.length);
695         for(uint16 i; i<_beneficiary.length; i++) {
696             token.rejectTokens(_beneficiary[i],_value[i]);
697         }
698     }
699 
700     // Extend the round time, if provided by the script. Extend the round only for
701     // a limited number of days - ROUND_PROLONGATE
702     // ***CHECK***SCENARIO***
703     // @ Do I have to use the function      no
704     // @ When it is possible to call        during active round
705     // @ When it is launched automatically  -
706     // @ Who can call the function          admins
707     function prolong(uint256 _duration) external {
708         require(rightAndRoles.onlyRoles(msg.sender,6));
709         require(now > startTime && now < endTime.add(renewal) && isInitialized && !isFinalized);
710         renewal = renewal.add(_duration);
711         require(renewal <= ROUND_PROLONGATE);
712 
713     }
714     // If a little more than a year has elapsed (Round2 start date + 400 days), a smart contract
715     // will allow you to send all the money to the Beneficiary, if any money is present. This is
716     // possible if you mistakenly launch the Round2 for 30 years (not 30 days), investors will transfer
717     // money there and you will not be able to pick them up within a reasonable time. It is also
718     // possible that in our checked script someone will make unforeseen mistakes, spoiling the
719     // finalization. Without finalization, money cannot be returned. This is a rescue option to
720     // get around this problem, but available only after a year (400 days).
721 
722     // Another reason - the TokenSale was a failure, but not all ETH investors took their money during the year after.
723     // Some investors may have lost a wallet key, for example.
724 
725     // The method works equally with the Round1 and Round2. When the Round1 starts, the time for unlocking
726     // the distructVault begins. If the TokenSale is then started, then the term starts anew from the first day of the TokenSale.
727 
728     // Next, act independently, in accordance with obligations to investors.
729 
730     // Within 400 days (FORCED_REFUND_TIMEOUT1) of the start of the Round, if it fails only investors can take money. After
731     // the deadline this can also include the company as well as investors, depending on who is the first to use the method.
732     // @ Do I have to use the function      no
733     // @ When it is possible to call        -
734     // @ When it is launched automatically  -
735     // @ Who can call the function          beneficiary & manager
736     function distructVault() public {
737         bytes32[] memory params = new bytes32[](1);
738         params[0] = bytes32(msg.sender);
739         if (rightAndRoles.onlyRoles(msg.sender,4) && (now > startTime.add(FORCED_REFUND_TIMEOUT1))) {
740 
741             financialStrategy.setup(0,params);
742         }
743         if (rightAndRoles.onlyRoles(msg.sender,2) && (now > startTime.add(FORCED_REFUND_TIMEOUT2))) {
744             financialStrategy.setup(0,params);
745         }
746     }
747 
748 
749     // We accept payments other than Ethereum (ETH) and other currencies, for example, Bitcoin (BTC).
750     // Perhaps other types of cryptocurrency - see the original terms in the white paper and on the TokenSale website.
751 
752     // We release tokens on Ethereum. During the Round1 and Round2 with a smart contract, you directly transfer
753     // the tokens there and immediately, with the same transaction, receive tokens in your wallet.
754 
755     // When paying in any other currency, for example in BTC, we accept your money via one common wallet.
756     // Our manager fixes the amount received for the bitcoin wallet and calls the method of the smart
757     // contract paymentsInOtherCurrency to inform him how much foreign currency has been received - on a daily basis.
758     // The smart contract pins the number of accepted ETH directly and the number of BTC. Smart contract
759     // monitors softcap and hardcap, so as not to go beyond this framework.
760 
761     // In theory, it is possible that when approaching hardcap, we will receive a transfer (one or several
762     // transfers) to the wallet of BTC, that together with previously received money will exceed the hardcap in total.
763     // In this case, we will refund all the amounts above, in order not to exceed the hardcap.
764 
765     // Collection of money in BTC will be carried out via one common wallet. The wallet's address will be published
766     // everywhere (in a white paper, on the TokenSale website, on Telegram, on Bitcointalk, in this code, etc.)
767     // Anyone interested can check that the administrator of the smart contract writes down exactly the amount
768     // in ETH (in equivalent for BTC) there. In theory, the ability to bypass a smart contract to accept money in
769     // BTC and not register them in ETH creates a possibility for manipulation by the company. Thanks to
770     // paymentsInOtherCurrency however, this threat is leveled.
771 
772     // Any user can check the amounts in BTC and the variable of the smart contract that accounts for this
773     // (paymentsInOtherCurrency method). Any user can easily check the incoming transactions in a smart contract
774     // on a daily basis. Any hypothetical tricks on the part of the company can be exposed and panic during the TokenSale,
775     // simply pointing out the incompatibility of paymentsInOtherCurrency (ie, the amount of ETH + BTC collection)
776     // and the actual transactions in BTC. The company strictly adheres to the described principles of openness.
777 
778     // The company administrator is required to synchronize paymentsInOtherCurrency every working day (but you
779     // cannot synchronize if there are no new BTC payments). In the case of unforeseen problems, such as
780     // brakes on the Ethereum network, this operation may be difficult. You should only worry if the
781     // administrator does not synchronize the amount for more than 96 hours in a row, and the BTC wallet
782     // receives significant amounts.
783 
784     // This scenario ensures that for the sum of all fees in all currencies this value does not exceed hardcap.
785 
786     // ** QUINTILLIONS ** 10^18 / 1**18 / 1e18
787 
788     // @ Do I have to use the function      no
789     // @ When it is possible to call        during active rounds
790     // @ When it is launched automatically  every day from cryptob2b token software
791     // @ Who can call the function          admins + observer
792     function paymentsInOtherCurrency(uint256 _token, uint256 _value) public {
793 
794         // **For audit**
795         // BTC Wallet:             1D7qaRN6keGJKb5LracZYQEgCBaryZxVaE
796         // BCH Wallet:             1CDRdTwvEyZD7qjiGUYxZQSf8n91q95xHU
797         // DASH Wallet:            XnjajDvQq1C7z2o4EFevRhejc6kRmX1NUp
798         // LTC Wallet:             LhHkiwVfoYEviYiLXP5pRK2S1QX5eGrotA
799         require(rightAndRoles.onlyRoles(msg.sender,18));
800         bool withinPeriod = (now >= startTime && now <= endTime.add(renewal));
801         bool withinCap = _value.add(ethWeiRaised) <= hardCap.add(overLimit);
802         require(withinPeriod && withinCap && isInitialized && !isFinalized);
803         emit PaymentedInOtherCurrency(_token,_value);
804         nonEthWeiRaised = _value;
805         tokenReserved = _token;
806 
807     }
808 
809     function lokedMint(address _beneficiary, uint256 _value, uint256 _freezeTime) internal {
810         if(_freezeTime > 0){
811 
812             uint256 totalBloked = token.freezedTokenOf(_beneficiary).add(_value);
813             uint256 pastDateUnfreeze = token.defrostDate(_beneficiary);
814             uint256 newDateUnfreeze = _freezeTime.add(now);
815             newDateUnfreeze = (pastDateUnfreeze > newDateUnfreeze ) ? pastDateUnfreeze : newDateUnfreeze;
816 
817             token.freezeTokens(_beneficiary,totalBloked,newDateUnfreeze);
818         }
819         token.mint(_beneficiary,_value);
820         totalSaledToken = totalSaledToken.add(_value);
821     }
822 
823 
824     // The function for obtaining smart contract funds in ETH. If all the checks are true, the token is
825     // transferred to the buyer, taking into account the current bonus.
826     function buyTokens(address _beneficiary) public payable {
827         require(_beneficiary != 0x0);
828         require(validPurchase());
829 
830         uint256 weiAmount = msg.value;
831 
832         uint256 ProfitProcent = getProfitPercent();
833 
834         uint256 value;
835         uint256 percent;
836         uint256 freezeTime;
837 
838         (value,
839         percent,
840         freezeTime) = getBonuses(weiAmount);
841 
842         Bonus memory curBonus = Bonus(value,percent,freezeTime);
843 
844         uint256 bonus = curBonus.procent;
845 
846         // --------------------------------------------------------------------------------------------
847         // *** Scenario 1 - select max from all bonuses + check maxAllProfit
848         //uint256 totalProfit = (ProfitProcent < bonus) ? bonus : ProfitProcent;
849         // *** Scenario 2 - sum both bonuses + check maxAllProfit
850         uint256 totalProfit = bonus.add(ProfitProcent);
851         // --------------------------------------------------------------------------------------------
852         totalProfit = (totalProfit > maxAllProfit) ? maxAllProfit : totalProfit;
853 
854         // calculate token amount to be created
855         uint256 tokens = weiAmount.mul(rate).mul(totalProfit.add(100)).div(100 ether);
856 
857         // update state
858         ethWeiRaised = ethWeiRaised.add(weiAmount);
859 
860         lokedMint(_beneficiary, tokens, curBonus.freezeTime);
861 
862         emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
863 
864         forwardFunds(_beneficiary);//forwardFunds(msg.sender);
865     }
866 
867     // buyTokens alias
868     function () public payable {
869         buyTokens(msg.sender);
870     }
871 }
872 
873 contract ERC20Basic {
874     function totalSupply() public view returns (uint256);
875     function balanceOf(address who) public view returns (uint256);
876     function transfer(address to, uint256 value) public returns (bool);
877     event Transfer(address indexed from, address indexed to, uint256 value);
878 }
879 
880 contract IAllocation {
881     function addShare(address _beneficiary, uint256 _proportion, uint256 _percenForFirstPart) external;
882 }