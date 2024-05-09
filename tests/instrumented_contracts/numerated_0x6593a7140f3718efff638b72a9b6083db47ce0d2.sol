1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a / b;
18         return c;
19     }
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         assert(c >= a);
27         return c;
28     }
29     function minus(uint256 a, uint256 b) internal pure returns (uint256) {
30         if (b>=a) return 0;
31         return a - b;
32     }
33 }
34 
35 contract IFinancialStrategy{
36 
37     enum State { Active, Refunding, Closed }
38     State public state = State.Active;
39 
40     event Deposited(address indexed beneficiary, uint256 weiAmount);
41     event Receive(address indexed beneficiary, uint256 weiAmount);
42     event Refunded(address indexed beneficiary, uint256 weiAmount);
43     event Started();
44     event Closed();
45     event RefundsEnabled();
46     function freeCash() view public returns(uint256);
47     function deposit(address _beneficiary) external payable;
48     function refund(address _investor) external;
49     function setup(uint8 _state, bytes32[] _params) external;
50     function getBeneficiaryCash() external;
51     function getPartnerCash(uint8 _user, address _msgsender) external;
52 }
53 
54 contract IToken{
55     function setUnpausedWallet(address _wallet, bool mode) public;
56     function mint(address _to, uint256 _amount) public returns (bool);
57     function totalSupply() public view returns (uint256);
58     function setPause(bool mode) public;
59     function setMigrationAgent(address _migrationAgent) public;
60     function migrateAll(address[] _holders) public;
61     function markTokens(address _beneficiary, uint256 _value) public;
62     function freezedTokenOf(address _beneficiary) public view returns (uint256 amount);
63     function defrostDate(address _beneficiary) public view returns (uint256 Date);
64     function freezeTokens(address _beneficiary, uint256 _amount, uint256 _when) public;
65 }
66 
67 contract IRightAndRoles {
68     address[][] public wallets;
69     mapping(address => uint16) public roles;
70 
71     event WalletChanged(address indexed newWallet, address indexed oldWallet, uint8 indexed role);
72     event CloneChanged(address indexed wallet, uint8 indexed role, bool indexed mod);
73 
74     function changeWallet(address _wallet, uint8 _role) external;
75     function setManagerPowerful(bool _mode) external;
76     function onlyRoles(address _sender, uint16 _roleMask) view external returns(bool);
77 }
78 
79 contract IAllocation {
80     function addShare(address _beneficiary, uint256 _proportion, uint256 _percenForFirstPart) external;
81 }
82 
83 contract ICreator{
84     IRightAndRoles public rightAndRoles;
85     function createAllocation(IToken _token, uint256 _unlockPart1, uint256 _unlockPart2) external returns (IAllocation);
86     function createFinancialStrategy() external returns(IFinancialStrategy);
87     function getRightAndRoles() external returns(IRightAndRoles);
88 }
89 
90 contract GuidedByRoles {
91     IRightAndRoles public rightAndRoles;
92     function GuidedByRoles(IRightAndRoles _rightAndRoles) public {
93         rightAndRoles = _rightAndRoles;
94     }
95 }
96 
97 /**
98  * @title ERC20Basic
99  * @dev Simpler version of ERC20 interface
100  * @dev see https://github.com/ethereum/EIPs/issues/179
101  * This code is taken from openZeppelin without any changes.
102  */
103 contract ERC20Basic {
104     function totalSupply() public view returns (uint256);
105     function balanceOf(address who) public view returns (uint256);
106     function transfer(address to, uint256 value) public returns (bool);
107     event Transfer(address indexed from, address indexed to, uint256 value);
108 }
109 
110 contract ERC20Provider is GuidedByRoles {
111     function transferTokens(ERC20Basic _token, address _to, uint256 _value) public returns (bool){
112         require(rightAndRoles.onlyRoles(msg.sender,2));
113         return _token.transfer(_to,_value);
114     }
115 }
116 
117 contract Crowdsale is GuidedByRoles, ERC20Provider{
118 // (A1)
119 // The main contract for the sale and management of rounds.
120 // 0000000000000000000000000000000000000000000000000000000000000000
121 
122     uint256 constant USER_UNPAUSE_TOKEN_TIMEOUT =  90 days;
123     uint256 constant FORCED_REFUND_TIMEOUT1     = 400 days;
124     uint256 constant FORCED_REFUND_TIMEOUT2     = 600 days;
125     uint256 constant ROUND_PROLONGATE           =  90 days;
126     //uint256 constant KYC_PERIOD                 =  90 days;
127 
128     using SafeMath for uint256;
129 
130     enum TokenSaleType {round1, round2}
131     TokenSaleType public TokenSale = TokenSaleType.round1;
132 
133 
134     ICreator public creator;
135     bool isBegin=false;
136 
137     IToken public token;
138     IAllocation public allocation;
139     IFinancialStrategy public financialStrategy;
140 
141     bool public isFinalized;
142     bool public isInitialized;
143     bool public isPausedCrowdsale;
144     bool public chargeBonuses;
145     bool public canFirstMint=true;
146 
147     struct Bonus {
148         uint256 value;
149         uint256 procent;
150         uint256 freezeTime;
151     }
152 
153     struct Profit {
154         uint256 percent;
155         uint256 duration;
156     }
157 
158     struct Freezed {
159         uint256 value;
160         uint256 dateTo;
161     }
162 
163     Bonus[] public bonuses;
164     Profit[] public profits;
165 
166 
167     uint256 public startTime;
168     uint256 public endTime;
169     uint256 public renewal;
170 
171     // How many tokens (excluding the bonus) are transferred to the investor in exchange for 1 ETH
172     // **THOUSANDS** 10^18 for human, *10**18 for Solidity, 1e18 for MyEtherWallet (MEW).
173     // Example: if 1ETH = 40.5 Token ==> use 40500 finney
174     uint256 public rate;
175 
176     // ETH/USD rate in US$
177     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: ETH/USD=$1000 ==> use 1000*10**18 (Solidity) or 1000 ether or 1000e18 (MEW)
178     uint256 public exchange;
179 
180     // If the round does not attain this value before the closing date, the round is recognized as a
181     // failure and investors take the money back (the founders will not interfere in any way).
182     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: softcap=15ETH ==> use 15*10**18 (Solidity) or 15e18 (MEW)
183     uint256 public softCap;
184 
185     // The maximum possible amount of income
186     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: hardcap=123.45ETH ==> use 123450*10**15 (Solidity) or 12345e15 (MEW)
187     uint256 public hardCap;
188 
189     // If the last payment is slightly higher than the hardcap, then the usual contracts do
190     // not accept it, because it goes beyond the hardcap. However it is more reasonable to accept the
191     // last payment, very slightly raising the hardcap. The value indicates by how many ETH the
192     // last payment can exceed the hardcap to allow it to be paid. Immediately after this payment, the
193     // round closes. The funders should write here a small number, not more than 1% of the CAP.
194     // Can be equal to zero, to cancel.
195     // **QUINTILLIONS** 10^18 / *10**18 / 1e18
196     uint256 public overLimit;
197 
198     // The minimum possible payment from an investor in ETH. Payments below this value will be rejected.
199     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: minPay=0.1ETH ==> use 100*10**15 (Solidity) or 100e15 (MEW)
200     uint256 public minPay;
201 
202     uint256 public maxAllProfit;
203 
204     uint256 public ethWeiRaised;
205     uint256 public nonEthWeiRaised;
206     uint256 public weiRound1;
207     uint256 public tokenReserved;
208 
209     uint256 public totalSaledToken;
210 
211     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
212 
213     event Finalized();
214     event Initialized();
215 
216     event PaymentedInOtherCurrency(uint256 token, uint256 value);
217     event ExchangeChanged(uint256 indexed oldExchange, uint256 indexed newExchange);
218 
219     function Crowdsale(ICreator _creator,IToken _token) GuidedByRoles(_creator.getRightAndRoles()) public
220     {
221         creator=_creator;
222         token = _token;
223     }
224 
225     function updateInfo(uint256 _ETHUSD,uint256 _token, uint256 _value) public {
226         require(rightAndRoles.onlyRoles(msg.sender,18));
227 //        if(_ETHUSD > 0){
228 //            changeExchange(_ETHUSD);
229 //        }
230         if(_token > 0 && _value > 0){
231             paymentsInOtherCurrency(_token,_value);
232         }
233     }
234 
235     // Setting the current rate ETH/USD
236 //    function changeExchange(uint256 _ETHUSD) internal {
237 //        require(rightAndRoles.onlyRoles(msg.sender,18));
238 //        if(_ETHUSD >= 1 ether){
239 //            require(_ETHUSD >= exchange/2 && _ETHUSD <= exchange*2);
240 //        }else{
241 //            _ETHUSD = _ETHUSD * 1000000;
242 //        }
243 //        emit ExchangeChanged(exchange,_ETHUSD);
244 //        softCap=softCap.mul(exchange).div(_ETHUSD);             // QUINTILLIONS
245 //        hardCap=hardCap.mul(exchange).div(_ETHUSD);             // QUINTILLIONS
246 //        minPay=minPay.mul(exchange).div(_ETHUSD);               // QUINTILLIONS
247 //
248 //        rate=rate.mul(_ETHUSD).div(exchange);                   // QUINTILLIONS
249 //
250 //        for (uint16 i = 0; i < bonuses.length; i++) {
251 //            bonuses[i].value=bonuses[i].value.mul(exchange).div(_ETHUSD);   // QUINTILLIONS
252 //        }
253 //        bytes32[] memory params = new bytes32[](2);
254 //        params[0] = bytes32(exchange);
255 //        params[1] = bytes32(_ETHUSD);
256 //        financialStrategy.setup(5, params);
257 //
258 //        exchange=_ETHUSD;
259 //
260 //    }
261 
262     // Setting of basic parameters, analog of class constructor
263     // @ Do I have to use the function      see your scenario
264     // @ When it is possible to call        before Round 1/2
265     // @ When it is launched automatically  -
266     // @ Who can call the function          admins
267     function begin() public
268     {
269 
270         require(rightAndRoles.onlyRoles(msg.sender,22));
271         if (isBegin) return;
272         isBegin=true;
273 
274         startTime= 1541073600;
275         endTime  = 1549022399;
276         rate = 2500 ether;
277         exchange  = 250 ether;
278         softCap = 0 ether;
279         hardCap = 1800 ether;
280         overLimit = 20 ether;
281         minPay = 40000 finney;
282         maxAllProfit = 45;
283 
284         financialStrategy = creator.createFinancialStrategy();
285 
286         token.setUnpausedWallet(rightAndRoles.wallets(1,0), true);
287         token.setUnpausedWallet(rightAndRoles.wallets(3,0), true);
288         token.setUnpausedWallet(rightAndRoles.wallets(4,0), true);
289         token.setUnpausedWallet(rightAndRoles.wallets(5,0), true);
290         token.setUnpausedWallet(rightAndRoles.wallets(6,0), true);
291 
292         bonuses.push(Bonus(4000 finney, 2,0));
293         bonuses.push(Bonus(40000 finney, 5,0));
294         bonuses.push(Bonus(400000 finney, 10,0));
295 
296         profits.push(Profit(30,180 days));
297     }
298 
299 
300 
301     // Issue of tokens for the zero round, it is usually called: private pre-sale (Round 0)
302     // @ Do I have to use the function      may be
303     // @ When it is possible to call        before Round 1/2
304     // @ When it is launched automatically  -
305     // @ Who can call the function          admins
306     function firstMintRound0(uint256 _amount /* QUINTILLIONS! */) public {
307         require(rightAndRoles.onlyRoles(msg.sender,6));
308         require(canFirstMint);
309         begin();
310         token.mint(rightAndRoles.wallets(3,0),_amount);
311         totalSaledToken = totalSaledToken.add(_amount);
312     }
313 
314     function firstMintRound0For(address[] _to, uint256[] _amount, uint8[] _setAsUnpaused) public {
315         require(rightAndRoles.onlyRoles(msg.sender,6));
316         require(canFirstMint);
317         begin();
318         require(_to.length == _amount.length && _to.length == _setAsUnpaused.length);
319         for(uint256 i = 0; i < _to.length; i++){
320             token.mint(_to[i],_amount[i]);
321             totalSaledToken = totalSaledToken.add(_amount[i]);
322             if(_setAsUnpaused[i]>0){
323                 token.setUnpausedWallet(_to[i], true);
324             }
325         }
326     }
327 
328     // info
329     function totalSupply() external view returns (uint256){
330         return token.totalSupply();
331     }
332 
333     // Transfers the funds of the investor to the contract of return of funds. Internal.
334     function forwardFunds(address _beneficiary) internal {
335         financialStrategy.deposit.value(msg.value)(_beneficiary);
336     }
337 
338     // Check for the possibility of buying tokens. Inside. Constant.
339     function validPurchase() internal view returns (bool) {
340 
341         // The round started and did not end
342         bool withinPeriod = (now > startTime && now < endTime.add(renewal));
343 
344         // Rate is greater than or equal to the minimum
345         bool nonZeroPurchase = msg.value >= minPay;
346 
347         // hardCap is not reached, and in the event of a transaction, it will not be exceeded by more than OverLimit
348         bool withinCap = msg.value <= hardCap.sub(weiRaised()).add(overLimit);
349 
350         // round is initialized and no "Pause of trading" is set
351         return withinPeriod && nonZeroPurchase && withinCap && isInitialized && !isFinalized && !isPausedCrowdsale;
352     }
353 
354     // Check for the ability to finalize the round. Constant.
355     function hasEnded() public view returns (bool) {
356         bool isAdmin = rightAndRoles.onlyRoles(msg.sender,6);
357 
358         bool timeReached = now > endTime.add(renewal);
359 
360         bool capReached = weiRaised() >= hardCap;
361 
362         return (timeReached || capReached || (isAdmin && goalReached())) && isInitialized && !isFinalized;
363     }
364 
365     // Finalize. Only available to the Manager and the Beneficiary. If the round failed, then
366     // anyone can call the finalization to unlock the return of funds to investors
367     // You must call a function to finalize each round (after the Round1 & after the Round2)
368     // @ Do I have to use the function      yes
369     // @ When it is possible to call        after end of Round1 & Round2
370     // @ When it is launched automatically  no
371     // @ Who can call the function          admins or anybody (if round is failed)
372     function finalize() public {
373         require(hasEnded());
374 
375         isFinalized = true;
376         finalization();
377         emit Finalized();
378     }
379 
380     // The logic of finalization. Internal
381     // @ Do I have to use the function      no
382     // @ When it is possible to call        -
383     // @ When it is launched automatically  after end of round
384     // @ Who can call the function          -
385     function finalization() internal {
386         bytes32[] memory params = new bytes32[](0);
387         // If the goal of the achievement
388         if (goalReached()) {
389 
390             financialStrategy.setup(1,params);
391 
392             // if there is anything to give
393             if (tokenReserved > 0) {
394 
395                 token.mint(rightAndRoles.wallets(3,0),tokenReserved);
396                 totalSaledToken = totalSaledToken.add(tokenReserved);
397 
398                 // Reset the counter
399                 tokenReserved = 0;
400             }
401 
402             // If the finalization is Round 1
403             if (TokenSale == TokenSaleType.round1) {
404 
405                 // Reset settings
406                 isInitialized = false;
407                 isFinalized = false;
408                 if(financialStrategy.freeCash() == 0){
409                     rightAndRoles.setManagerPowerful(true);
410                 }
411 
412                 // Switch to the second round (to Round2)
413                 TokenSale = TokenSaleType.round2;
414 
415                 // Reset the collection counter
416                 weiRound1 = weiRaised();
417                 ethWeiRaised = 0;
418                 nonEthWeiRaised = 0;
419 
420 
421 
422             }
423             else // If the second round is finalized
424             {
425 
426                 // Permission to collect tokens to those who can pick them up
427                 chargeBonuses = true;
428 
429                 //totalSaledToken = token.totalSupply();
430                 //partners = true;
431 
432             }
433 
434         }
435         else // If they failed round
436         {
437             financialStrategy.setup(3,params);
438         }
439     }
440 
441     // The Manager freezes the tokens for the Team.
442     // You must call a function to finalize Round 2 (only after the Round2)
443     // @ Do I have to use the function      yes
444     // @ When it is possible to call        Round2
445     // @ When it is launched automatically  -
446     // @ Who can call the function          admins
447     function finalize2() public {
448         require(rightAndRoles.onlyRoles(msg.sender,6));
449         require(chargeBonuses);
450         chargeBonuses = false;
451 
452         allocation = creator.createAllocation(token, now + 1 years /* stage N1 */,0/* not need*/);
453         token.setUnpausedWallet(allocation, true);
454         // Team = %, Founders = %, Fund = %    TOTAL = %
455         allocation.addShare(rightAndRoles.wallets(7,0),100,100); // all 100% - first year
456 
457         // 2% - bounty wallet
458         token.mint(rightAndRoles.wallets(5,0), totalSaledToken.mul(5).div(75));
459 
460         // 8% - company (referral, reserve, advisers)
461         token.mint(rightAndRoles.wallets(6,0), totalSaledToken.mul(10).div(75));
462 
463         // 10% - team
464         token.mint(allocation, totalSaledToken.mul(10).div(75));
465     }
466 
467 
468 
469     // Initializing the round. Available to the manager. After calling the function,
470     // the Manager loses all rights: Manager can not change the settings (setup), change
471     // wallets, prevent the beginning of the round, etc. You must call a function after setup
472     // for the initial round (before the Round1 and before the Round2)
473     // @ Do I have to use the function      yes
474     // @ When it is possible to call        before each round
475     // @ When it is launched automatically  -
476     // @ Who can call the function          admins
477     function initialize() public {
478         require(rightAndRoles.onlyRoles(msg.sender,6));
479         // If not yet initialized
480         require(!isInitialized);
481         begin();
482 
483 
484         // And the specified start time has not yet come
485         // If initialization return an error, check the start date!
486         require(now <= startTime);
487 
488         initialization();
489 
490         emit Initialized();
491 
492         renewal = 0;
493 
494         isInitialized = true;
495 
496         canFirstMint = false;
497     }
498 
499     function initialization() internal {
500         bytes32[] memory params = new bytes32[](0);
501         rightAndRoles.setManagerPowerful(false);
502         if (financialStrategy.state() != IFinancialStrategy.State.Active){
503             financialStrategy.setup(2,params);
504         }
505     }
506 
507     // 
508     // @ Do I have to use the function      
509     // @ When it is possible to call        
510     // @ When it is launched automatically  
511     // @ Who can call the function          
512     function getPartnerCash(uint8 _user, bool _calc) external {
513         if(_calc)
514             calcFin();
515         financialStrategy.getPartnerCash(_user, msg.sender);
516     }
517 
518     function getBeneficiaryCash(bool _calc) public {
519         require(rightAndRoles.onlyRoles(msg.sender,22));
520         if(_calc)
521             calcFin();
522         financialStrategy.getBeneficiaryCash();
523         if(!isInitialized && financialStrategy.freeCash() == 0)
524             rightAndRoles.setManagerPowerful(true);
525     }
526 
527     function claimRefund() external{
528         financialStrategy.refund(msg.sender);
529     }
530 
531     function calcFin() public {
532         bytes32[] memory params = new bytes32[](2);
533         params[0] = bytes32(weiTotalRaised());
534         params[1] = bytes32(msg.sender);
535         financialStrategy.setup(4,params);
536     }
537 
538     function calcAndGet() public {
539         require(rightAndRoles.onlyRoles(msg.sender,22));
540         getBeneficiaryCash(true);
541         for (uint8 i=0; i<0; i++) {
542             financialStrategy.getPartnerCash(i, msg.sender);
543         }
544     }
545 
546     // We check whether we collected the necessary minimum funds. Constant.
547     function goalReached() public view returns (bool) {
548         return weiRaised() >= softCap;
549     }
550 
551 
552     // Customize. The arguments are described in the constructor above.
553     // @ Do I have to use the function      yes
554     // @ When it is possible to call        before each rond
555     // @ When it is launched automatically  -
556     // @ Who can call the function          admins
557     function setup(uint256 _startTime, uint256 _endTime, uint256 _softCap, uint256 _hardCap,
558         uint256 _rate, uint256 _exchange,
559         uint256 _maxAllProfit, uint256 _overLimit, uint256 _minPay,
560         uint256[] _durationTB , uint256[] _percentTB, uint256[] _valueVB, uint256[] _percentVB, uint256[] _freezeTimeVB) public
561     {
562 
563         require(rightAndRoles.onlyRoles(msg.sender,6));
564         require(!isInitialized);
565 
566         begin();
567 
568         // Date and time are correct
569         require(now <= _startTime);
570         require(_startTime < _endTime);
571 
572         startTime = _startTime;
573         endTime = _endTime;
574 
575         // The parameters are correct
576         require(_softCap <= _hardCap);
577 
578         softCap = _softCap;
579         hardCap = _hardCap;
580 
581         require(_rate > 0);
582 
583         rate = _rate;
584 
585         overLimit = _overLimit;
586         minPay = _minPay;
587         exchange = _exchange;
588 
589         maxAllProfit = _maxAllProfit;
590 
591         require(_valueVB.length == _percentVB.length && _valueVB.length == _freezeTimeVB.length);
592         bonuses.length = _valueVB.length;
593         for(uint256 i = 0; i < _valueVB.length; i++){
594             bonuses[i] = Bonus(_valueVB[i],_percentVB[i],_freezeTimeVB[i]);
595         }
596 
597         require(_percentTB.length == _durationTB.length);
598         profits.length = _percentTB.length;
599         for( i = 0; i < _percentTB.length; i++){
600             profits[i] = Profit(_percentTB[i],_durationTB[i]);
601         }
602 
603     }
604 
605     // Collected funds for the current round. Constant.
606     function weiRaised() public constant returns(uint256){
607         return ethWeiRaised.add(nonEthWeiRaised);
608     }
609 
610     // Returns the amount of fees for both phases. Constant.
611     function weiTotalRaised() public constant returns(uint256){
612         return weiRound1.add(weiRaised());
613     }
614 
615     // Returns the percentage of the bonus on the current date. Constant.
616     function getProfitPercent() public constant returns (uint256){
617         return getProfitPercentForData(now);
618     }
619 
620     // Returns the percentage of the bonus on the given date. Constant.
621     function getProfitPercentForData(uint256 _timeNow) public constant returns (uint256){
622         uint256 allDuration;
623         for(uint8 i = 0; i < profits.length; i++){
624             allDuration = allDuration.add(profits[i].duration);
625             if(_timeNow < startTime.add(allDuration)){
626                 return profits[i].percent;
627             }
628         }
629         return 0;
630     }
631 
632     function getBonuses(uint256 _value) public constant returns (uint256,uint256,uint256){
633         if(bonuses.length == 0 || bonuses[0].value > _value){
634             return (0,0,0);
635         }
636         uint16 i = 1;
637         for(i; i < bonuses.length; i++){
638             if(bonuses[i].value > _value){
639                 break;
640             }
641         }
642         return (bonuses[i-1].value,bonuses[i-1].procent,bonuses[i-1].freezeTime);
643     }
644 
645 
646     // Remove the "Pause of exchange". Available to the manager at any time. If the
647     // manager refuses to remove the pause, then 30-120 days after the successful
648     // completion of the TokenSale, anyone can remove a pause and allow the exchange to continue.
649     // The manager does not interfere and will not be able to delay the term.
650     // He can only cancel the pause before the appointed time.
651     // @ Do I have to use the function      YES YES YES
652     // @ When it is possible to call        after end of ICO
653     // @ When it is launched automatically  -
654     // @ Who can call the function          admins or anybody
655     function tokenUnpause() external {
656 
657         require(rightAndRoles.onlyRoles(msg.sender,6)
658         || (now > endTime.add(renewal).add(USER_UNPAUSE_TOKEN_TIMEOUT) && TokenSale == TokenSaleType.round2 && isFinalized && goalReached()));
659         token.setPause(false);
660     }
661 
662     // Enable the "Pause of exchange". Available to the manager until the TokenSale is completed.
663     // The manager cannot turn on the pause, for example, 3 years after the end of the TokenSale.
664     // @ Do I have to use the function      no
665     // @ When it is possible to call        while Round2 not ended
666     // @ When it is launched automatically  before any rounds
667     // @ Who can call the function          admins
668     function tokenPause() external {
669         require(rightAndRoles.onlyRoles(msg.sender,6));
670         require(!isFinalized);
671         token.setPause(true);
672     }
673 
674     // Pause of sale. Available to the manager.
675     // @ Do I have to use the function      no
676     // @ When it is possible to call        during active rounds
677     // @ When it is launched automatically  -
678     // @ Who can call the function          admins
679     function setCrowdsalePause(bool mode) public {
680         require(rightAndRoles.onlyRoles(msg.sender,6));
681         isPausedCrowdsale = mode;
682     }
683 
684     // For people who ignore the KYC/AML procedure during 30 days after payment (KYC_PERIOD): money back and zeroing tokens.
685     // ***CHECK***SCENARIO***
686     // @ Do I have to use the function      no
687     // @ When it is possible to call        any time
688     // @ When it is launched automatically  -
689     // @ Who can call the function          admin
690 //    function invalidPayments(address[] _beneficiary, uint256[] _value) external {
691 //        require(rightAndRoles.onlyRoles(msg.sender,6));
692 //        require(endTime.add(renewal).add(KYC_PERIOD) > now);
693 //        require(_beneficiary.length == _value.length);
694 //        for(uint16 i; i<_beneficiary.length; i++) {
695 //            token.markTokens(_beneficiary[i],_value[i]);
696 //        }
697 //    }
698 
699     // Extend the round time, if provided by the script. Extend the round only for
700     // a limited number of days - ROUND_PROLONGATE
701     // ***CHECK***SCENARIO***
702     // @ Do I have to use the function      no
703     // @ When it is possible to call        during active round
704     // @ When it is launched automatically  -
705     // @ Who can call the function          admins
706     function prolong(uint256 _duration) external {
707         require(rightAndRoles.onlyRoles(msg.sender,6));
708         require(now > startTime && now < endTime.add(renewal) && isInitialized && !isFinalized);
709         renewal = renewal.add(_duration);
710         require(renewal <= ROUND_PROLONGATE);
711 
712     }
713     // If a little more than a year has elapsed (Round2 start date + 400 days), a smart contract
714     // will allow you to send all the money to the Beneficiary, if any money is present. This is
715     // possible if you mistakenly launch the Round2 for 30 years (not 30 days), investors will transfer
716     // money there and you will not be able to pick them up within a reasonable time. It is also
717     // possible that in our checked script someone will make unforeseen mistakes, spoiling the
718     // finalization. Without finalization, money cannot be returned. This is a rescue option to
719     // get around this problem, but available only after a year (400 days).
720 
721     // Another reason - the TokenSale was a failure, but not all ETH investors took their money during the year after.
722     // Some investors may have lost a wallet key, for example.
723 
724     // The method works equally with the Round1 and Round2. When the Round1 starts, the time for unlocking
725     // the distructVault begins. If the TokenSale is then started, then the term starts anew from the first day of the TokenSale.
726 
727     // Next, act independently, in accordance with obligations to investors.
728 
729     // Within 400 days (FORCED_REFUND_TIMEOUT1) of the start of the Round, if it fails only investors can take money. After
730     // the deadline this can also include the company as well as investors, depending on who is the first to use the method.
731     // @ Do I have to use the function      no
732     // @ When it is possible to call        -
733     // @ When it is launched automatically  -
734     // @ Who can call the function          beneficiary & manager
735     function distructVault() public {
736         bytes32[] memory params = new bytes32[](1);
737         params[0] = bytes32(msg.sender);
738         if (rightAndRoles.onlyRoles(msg.sender,4) && (now > startTime.add(FORCED_REFUND_TIMEOUT1))) {
739 
740             financialStrategy.setup(0,params);
741         }
742         if (rightAndRoles.onlyRoles(msg.sender,2) && (now > startTime.add(FORCED_REFUND_TIMEOUT2))) {
743             financialStrategy.setup(0,params);
744         }
745     }
746 
747 
748     // We accept payments other than Ethereum (ETH) and other currencies, for example, Bitcoin (BTC).
749     // Perhaps other types of cryptocurrency - see the original terms in the white paper and on the TokenSale website.
750 
751     // We release tokens on Ethereum. During the Round1 and Round2 with a smart contract, you directly transfer
752     // the tokens there and immediately, with the same transaction, receive tokens in your wallet.
753 
754     // When paying in any other currency, for example in BTC, we accept your money via one common wallet.
755     // Our manager fixes the amount received for the bitcoin wallet and calls the method of the smart
756     // contract paymentsInOtherCurrency to inform him how much foreign currency has been received - on a daily basis.
757     // The smart contract pins the number of accepted ETH directly and the number of BTC. Smart contract
758     // monitors softcap and hardcap, so as not to go beyond this framework.
759 
760     // In theory, it is possible that when approaching hardcap, we will receive a transfer (one or several
761     // transfers) to the wallet of BTC, that together with previously received money will exceed the hardcap in total.
762     // In this case, we will refund all the amounts above, in order not to exceed the hardcap.
763 
764     // Collection of money in BTC will be carried out via one common wallet. The wallet's address will be published
765     // everywhere (in a white paper, on the TokenSale website, on Telegram, on Bitcointalk, in this code, etc.)
766     // Anyone interested can check that the administrator of the smart contract writes down exactly the amount
767     // in ETH (in equivalent for BTC) there. In theory, the ability to bypass a smart contract to accept money in
768     // BTC and not register them in ETH creates a possibility for manipulation by the company. Thanks to
769     // paymentsInOtherCurrency however, this threat is leveled.
770 
771     // Any user can check the amounts in BTC and the variable of the smart contract that accounts for this
772     // (paymentsInOtherCurrency method). Any user can easily check the incoming transactions in a smart contract
773     // on a daily basis. Any hypothetical tricks on the part of the company can be exposed and panic during the TokenSale,
774     // simply pointing out the incompatibility of paymentsInOtherCurrency (ie, the amount of ETH + BTC collection)
775     // and the actual transactions in BTC. The company strictly adheres to the described principles of openness.
776 
777     // The company administrator is required to synchronize paymentsInOtherCurrency every working day (but you
778     // cannot synchronize if there are no new BTC payments). In the case of unforeseen problems, such as
779     // brakes on the Ethereum network, this operation may be difficult. You should only worry if the
780     // administrator does not synchronize the amount for more than 96 hours in a row, and the BTC wallet
781     // receives significant amounts.
782 
783     // This scenario ensures that for the sum of all fees in all currencies this value does not exceed hardcap.
784 
785     // ** QUINTILLIONS ** 10^18 / 1**18 / 1e18
786 
787     // @ Do I have to use the function      no
788     // @ When it is possible to call        during active rounds
789     // @ When it is launched automatically  every day from cryptob2b token software
790     // @ Who can call the function          admins + observer
791     function paymentsInOtherCurrency(uint256 _token, uint256 _value) internal {
792 
793         // **For audit**
794         // BTC Wallet:      3PA3mFnHsn8JAd8tyy1R7yzhSP7pDaP3qH
795         // DASH Wallet:     XsDYYXM8fM9EZvLmaTD4wZxjoFQ3QwQb35
796         // LTC Wallet:      MN7zdA7wKocizJGagqZaZ2akRfB2ZqTot9
797         // BCH Wallet:      qq063mly500cn7z87v4dtzdty0uhltqzvsjqa2g6s9
798 
799         bool withinPeriod = (now >= startTime && now <= endTime.add(renewal));
800         bool withinCap = _value.add(ethWeiRaised) <= hardCap.add(overLimit);
801         require(withinPeriod && withinCap && isInitialized && !isFinalized);
802         emit PaymentedInOtherCurrency(_token,_value);
803         nonEthWeiRaised = _value;
804         tokenReserved = _token;
805 
806     }
807 
808     function lokedMint(address _beneficiary, uint256 _value, uint256 _freezeTime) internal {
809         if(_freezeTime > 0){
810 
811             uint256 totalBloked = token.freezedTokenOf(_beneficiary).add(_value);
812             uint256 pastDateUnfreeze = token.defrostDate(_beneficiary);
813             uint256 newDateUnfreeze = _freezeTime.add(now);
814             newDateUnfreeze = (pastDateUnfreeze > newDateUnfreeze ) ? pastDateUnfreeze : newDateUnfreeze;
815 
816             token.freezeTokens(_beneficiary,totalBloked,newDateUnfreeze);
817         }
818         token.mint(_beneficiary,_value);
819         totalSaledToken = totalSaledToken.add(_value);
820     }
821 
822 
823     // The function for obtaining smart contract funds in ETH. If all the checks are true, the token is
824     // transferred to the buyer, taking into account the current bonus.
825     function buyTokens(address _beneficiary) public payable {
826         require(_beneficiary != 0x0);
827         require(validPurchase());
828 
829         uint256 weiAmount = msg.value;
830 
831         uint256 ProfitProcent = getProfitPercent();
832 
833         uint256 value;
834         uint256 percent;
835         uint256 freezeTime;
836 
837         (value,
838         percent,
839         freezeTime) = getBonuses(weiAmount);
840 
841         Bonus memory curBonus = Bonus(value,percent,freezeTime);
842 
843         uint256 bonus = curBonus.procent;
844 
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