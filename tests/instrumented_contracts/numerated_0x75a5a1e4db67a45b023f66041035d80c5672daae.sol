1 // Project: AleHub
2 // v1, 2018-05-24
3 // This code is the property of CryptoB2B.io
4 // Copying in whole or in part is prohibited.
5 // Authors: Ivan Fedorov and Dmitry Borodin
6 // Do you want the same TokenSale platform? www.cryptob2b.io
7 
8 // *.sol in 1 file - https://cryptob2b.io/solidity/alehub/
9 
10 pragma solidity ^0.4.21;
11 
12 contract IRightAndRoles {
13     address[][] public wallets;
14     mapping(address => uint16) public roles;
15 
16     event WalletChanged(address indexed newWallet, address indexed oldWallet, uint8 indexed role);
17     event CloneChanged(address indexed wallet, uint8 indexed role, bool indexed mod);
18 
19     function changeWallet(address _wallet, uint8 _role) external;
20     function setManagerPowerful(bool _mode) external;
21     function onlyRoles(address _sender, uint16 _roleMask) view external returns(bool);
22 }
23 
24 library SafeMath {
25     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26         if (a == 0) {
27             return 0;
28         }
29         uint256 c = a * b;
30         assert(c / a == b);
31         return c;
32     }
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a / b;
35         return c;
36     }
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         assert(b <= a);
39         return a - b;
40     }
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         assert(c >= a);
44         return c;
45     }
46     function minus(uint256 a, uint256 b) internal pure returns (uint256) {
47         if (b>=a) return 0;
48         return a - b;
49     }
50 }
51 
52 contract ICreator{
53     function createAllocation(IToken _token, uint256 _unlockPart1, uint256 _unlockPart2) external returns (IAllocation);
54     function createFinancialStrategy() external returns(IFinancialStrategy);
55     function getRightAndRoles() external returns(IRightAndRoles);
56 }
57 
58 contract IToken{
59     function setUnpausedWallet(address _wallet, bool mode) public;
60     function mint(address _to, uint256 _amount) public returns (bool);
61     function totalSupply() public view returns (uint256);
62     function setPause(bool mode) public;
63     function setMigrationAgent(address _migrationAgent) public;
64     function migrateAll(address[] _holders) public;
65     function burn(address _beneficiary, uint256 _value) public;
66     function freezedTokenOf(address _beneficiary) public view returns (uint256 amount);
67     function defrostDate(address _beneficiary) public view returns (uint256 Date);
68     function freezeTokens(address _beneficiary, uint256 _amount, uint256 _when) public;
69 }
70 
71 contract IFinancialStrategy{
72 
73     enum State { Active, Refunding, Closed }
74     State public state = State.Active;
75 
76     event Deposited(address indexed beneficiary, uint256 weiAmount);
77     event Receive(address indexed beneficiary, uint256 weiAmount);
78     event Refunded(address indexed beneficiary, uint256 weiAmount);
79     event Started();
80     event Closed();
81     event RefundsEnabled();
82     function freeCash() view public returns(uint256);
83     function deposit(address _beneficiary) external payable;
84     function refund(address _investor) external;
85     function setup(uint8 _state, bytes32[] _params) external;
86     function getBeneficiaryCash() external;
87     function getPartnerCash(uint8 _user, address _msgsender) external;
88 }
89 
90 contract IAllocation {
91     function addShare(address _beneficiary, uint256 _proportion, uint256 _percenForFirstPart) external;
92 }
93 
94 contract GuidedByRoles {
95     IRightAndRoles public rightAndRoles;
96     function GuidedByRoles(IRightAndRoles _rightAndRoles) public {
97         rightAndRoles = _rightAndRoles;
98     }
99 }
100 
101 contract Crowdsale is GuidedByRoles{
102 // (A1)
103 // The main contract for the sale and management of rounds.
104 // 0000000000000000000000000000000000000000000000000000000000000000
105 
106     uint256 constant USER_UNPAUSE_TOKEN_TIMEOUT =  60 days;
107     uint256 constant FORCED_REFUND_TIMEOUT1     = 400 days;
108     uint256 constant FORCED_REFUND_TIMEOUT2     = 600 days;
109     uint256 constant ROUND_PROLONGATE           =  60 days;
110     uint256 constant BURN_TOKENS_TIME           =  90 days;
111 
112     using SafeMath for uint256;
113 
114     enum TokenSaleType {round1, round2}
115 
116     TokenSaleType public TokenSale = TokenSaleType.round2;
117 
118     ICreator public creator;
119     bool isBegin=false;
120 
121     IToken public token;
122     IAllocation public allocation;
123     IFinancialStrategy public financialStrategy;
124     bool public isFinalized;
125     bool public isInitialized;
126     bool public isPausedCrowdsale;
127     bool public chargeBonuses;
128     bool public canFirstMint=true;
129 
130     struct Bonus {
131         uint256 value;
132         uint256 procent;
133         uint256 freezeTime;
134     }
135 
136     struct Profit {
137         uint256 percent;
138         uint256 duration;
139     }
140 
141     struct Freezed {
142         uint256 value;
143         uint256 dateTo;
144     }
145 
146     Bonus[] public bonuses;
147     Profit[] public profits;
148 
149 
150     uint256 public startTime= 1527170400;
151     uint256 public endTime  = 1532390399;
152     uint256 public renewal;
153 
154     // How many tokens (excluding the bonus) are transferred to the investor in exchange for 1 ETH
155     // **THOUSANDS** 10^18 for human, *10**18 for Solidity, 1e18 for MyEtherWallet (MEW).
156     // Example: if 1ETH = 40.5 Token ==> use 40500 finney
157     uint256 public rate = 2333 ether; // $0.1 (ETH/USD=$500)
158 
159     // ETH/USD rate in US$
160     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: ETH/USD=$1000 ==> use 1000*10**18 (Solidity) or 1000 ether or 1000e18 (MEW)
161     uint256 public exchange  = 700 ether;
162 
163     // If the round does not attain this value before the closing date, the round is recognized as a
164     // failure and investors take the money back (the founders will not interfere in any way).
165     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: softcap=15ETH ==> use 15*10**18 (Solidity) or 15e18 (MEW)
166     uint256 public softCap = 0;
167 
168     // The maximum possible amount of income
169     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: hardcap=123.45ETH ==> use 123450*10**15 (Solidity) or 12345e15 (MEW)
170     uint256 public hardCap = 44498 ether; // $31M (ETH/USD=$500)
171 
172     // If the last payment is slightly higher than the hardcap, then the usual contracts do
173     // not accept it, because it goes beyond the hardcap. However it is more reasonable to accept the
174     // last payment, very slightly raising the hardcap. The value indicates by how many ETH the
175     // last payment can exceed the hardcap to allow it to be paid. Immediately after this payment, the
176     // round closes. The funders should write here a small number, not more than 1% of the CAP.
177     // Can be equal to zero, to cancel.
178     // **QUINTILLIONS** 10^18 / *10**18 / 1e18
179     uint256 public overLimit = 20 ether;
180 
181     // The minimum possible payment from an investor in ETH. Payments below this value will be rejected.
182     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: minPay=0.1ETH ==> use 100*10**15 (Solidity) or 100e15 (MEW)
183     uint256 public minPay = 43 finney;
184 
185     uint256 public maxAllProfit = 30; // max time bonus=20%, max value bonus=10%, maxAll=10%+20%
186 
187     uint256 public ethWeiRaised;
188     uint256 public nonEthWeiRaised;
189     uint256 public weiRound1;
190     uint256 public tokenReserved;
191 
192     uint256 public totalSaledToken;
193 
194     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
195 
196     event Finalized();
197     event Initialized();
198 
199     event PaymentedInOtherCurrency(uint256 token, uint256 value);
200     event ExchangeChanged(uint256 indexed oldExchange, uint256 indexed newExchange);
201 
202     function Crowdsale(ICreator _creator,IToken _token) GuidedByRoles(_creator.getRightAndRoles()) public
203     {
204         creator=_creator;
205         token = _token;
206     }
207 
208     // Setting the current rate ETH/USD         
209 //    function changeExchange(uint256 _ETHUSD) public {
210 //        require(rightAndRoles.onlyRoles(msg.sender,18));
211 //        require(_ETHUSD >= 1 ether);
212 //        emit ExchangeChanged(exchange,_ETHUSD);
213 //        softCap=softCap.mul(exchange).div(_ETHUSD);             // QUINTILLIONS
214 //        hardCap=hardCap.mul(exchange).div(_ETHUSD);             // QUINTILLIONS
215 //        minPay=minPay.mul(exchange).div(_ETHUSD);               // QUINTILLIONS
216 //
217 //        rate=rate.mul(_ETHUSD).div(exchange);                   // QUINTILLIONS
218 //
219 //        for (uint16 i = 0; i < bonuses.length; i++) {
220 //            bonuses[i].value=bonuses[i].value.mul(exchange).div(_ETHUSD);   // QUINTILLIONS
221 //        }
222 //        bytes32[] memory params = new bytes32[](2);
223 //        params[0] = bytes32(exchange);
224 //        params[1] = bytes32(_ETHUSD);
225 //        financialStrategy.setup(5, params);
226 //
227 //        exchange=_ETHUSD;
228 //
229 //    }
230 
231     // Setting of basic parameters, analog of class constructor
232     // @ Do I have to use the function      see your scenario
233     // @ When it is possible to call        before Round 1/2
234     // @ When it is launched automatically  -
235     // @ Who can call the function          admins
236     function begin() public
237     {
238         require(rightAndRoles.onlyRoles(msg.sender,22));
239         if (isBegin) return;
240         isBegin=true;
241 
242         financialStrategy = creator.createFinancialStrategy();
243 
244         token.setUnpausedWallet(rightAndRoles.wallets(1,0), true);
245         token.setUnpausedWallet(rightAndRoles.wallets(3,0), true);
246         token.setUnpausedWallet(rightAndRoles.wallets(4,0), true);
247         token.setUnpausedWallet(rightAndRoles.wallets(5,0), true);
248         token.setUnpausedWallet(rightAndRoles.wallets(6,0), true);
249 
250         bonuses.push(Bonus(1429 finney, 2,0));
251         bonuses.push(Bonus(14286 finney, 5,0));
252         bonuses.push(Bonus(142857 finney, 10,0));
253 
254         profits.push(Profit(20,5 days + 36000));
255         profits.push(Profit(15,5 days));
256         profits.push(Profit(10,5 days));
257         profits.push(Profit(5,5 days));
258     }
259 
260 
261 
262     // Issue of tokens for the zero round, it is usually called: private pre-sale (Round 0)
263     // @ Do I have to use the function      may be
264     // @ When it is possible to call        before Round 1/2
265     // @ When it is launched automatically  -
266     // @ Who can call the function          admins
267     function firstMintRound0(uint256 _amount /* QUINTILLIONS! */) public {
268         require(rightAndRoles.onlyRoles(msg.sender,6));
269         require(canFirstMint);
270         begin();
271         token.mint(rightAndRoles.wallets(3,0),_amount);
272     }
273 
274     // info
275     function totalSupply() external view returns (uint256){
276         return token.totalSupply();
277     }
278 
279     // Returns the name of the current round in plain text. Constant.
280     function getTokenSaleType() external view returns(string){
281         return (TokenSale == TokenSaleType.round1)?'round1':'round2';
282     }
283 
284     // Transfers the funds of the investor to the contract of return of funds. Internal.
285     function forwardFunds(address _beneficiary) internal {
286         financialStrategy.deposit.value(msg.value)(_beneficiary);
287     }
288 
289     // Check for the possibility of buying tokens. Inside. Constant.
290     function validPurchase() internal view returns (bool) {
291 
292         // The round started and did not end
293         bool withinPeriod = (now > startTime && now < endTime.add(renewal));
294 
295         // Rate is greater than or equal to the minimum
296         bool nonZeroPurchase = msg.value >= minPay;
297 
298         // hardCap is not reached, and in the event of a transaction, it will not be exceeded by more than OverLimit
299         bool withinCap = msg.value <= hardCap.sub(weiRaised()).add(overLimit);
300 
301         // round is initialized and no "Pause of trading" is set
302         return withinPeriod && nonZeroPurchase && withinCap && isInitialized && !isFinalized && !isPausedCrowdsale;
303     }
304 
305     // Check for the ability to finalize the round. Constant.
306     function hasEnded() public view returns (bool) {
307         bool isAdmin = rightAndRoles.onlyRoles(msg.sender,6);
308 
309         bool timeReached = now > endTime.add(renewal);
310 
311         bool capReached = weiRaised() >= hardCap;
312 
313         return (timeReached || capReached || (isAdmin && goalReached())) && isInitialized && !isFinalized;
314     }
315 
316     // Finalize. Only available to the Manager and the Beneficiary. If the round failed, then
317     // anyone can call the finalization to unlock the return of funds to investors
318     // You must call a function to finalize each round (after the Round1 & after the Round2)
319     // @ Do I have to use the function      yes
320     // @ When it is possible to call        after end of Round1 & Round2
321     // @ When it is launched automatically  no
322     // @ Who can call the function          admins or anybody (if round is failed)
323     function finalize() public {
324 //        bool isAdmin = rightAndRoles.onlyRoles(msg.sender,6);
325 //        require(isAdmin|| !goalReached());
326 //        require(!isFinalized && isInitialized);
327 //        require(hasEnded() || (isAdmin && goalReached()));
328         require(hasEnded());
329 
330         isFinalized = true;
331         finalization();
332         emit Finalized();
333     }
334 
335     // The logic of finalization. Internal
336     // @ Do I have to use the function      no
337     // @ When it is possible to call        -
338     // @ When it is launched automatically  after end of round
339     // @ Who can call the function          -
340     function finalization() internal {
341         bytes32[] memory params = new bytes32[](0);
342         // If the goal of the achievement
343         if (goalReached()) {
344 
345             financialStrategy.setup(1,params);//Для контракта Buz деньги не возвращает.
346 
347             // if there is anything to give
348             if (tokenReserved > 0) {
349 
350                 token.mint(rightAndRoles.wallets(3,0),tokenReserved);
351 
352                 // Reset the counter
353                 tokenReserved = 0;
354             }
355 
356             // If the finalization is Round 1
357             if (TokenSale == TokenSaleType.round1) {
358 
359                 // Reset settings
360                 isInitialized = false;
361                 isFinalized = false;
362                 if(financialStrategy.freeCash() == 0){
363                     rightAndRoles.setManagerPowerful(true);
364                 }
365 
366                 // Switch to the second round (to Round2)
367                 TokenSale = TokenSaleType.round2;
368 
369                 // Reset the collection counter
370                 weiRound1 = weiRaised();
371                 ethWeiRaised = 0;
372                 nonEthWeiRaised = 0;
373 
374 
375 
376             }
377             else // If the second round is finalized
378             {
379 
380                 // Permission to collect tokens to those who can pick them up
381                 chargeBonuses = true;
382 
383                 totalSaledToken = token.totalSupply();
384                 //partners = true;
385 
386             }
387 
388         }
389         else // If they failed round
390         {
391             financialStrategy.setup(3,params);
392         }
393     }
394 
395     // The Manager freezes the tokens for the Team.
396     // You must call a function to finalize Round 2 (only after the Round2)
397     // @ Do I have to use the function      yes
398     // @ When it is possible to call        Round2
399     // @ When it is launched automatically  -
400     // @ Who can call the function          admins
401     function finalize2() public {
402         require(rightAndRoles.onlyRoles(msg.sender,6));
403         require(chargeBonuses);
404         chargeBonuses = false;
405 
406         allocation = creator.createAllocation(token, now + 1 years /* stage N1 */,0/* not need*/);
407         token.setUnpausedWallet(allocation, true);
408         // Team = %, Founders = %, Fund = %    TOTAL = %
409         allocation.addShare(rightAndRoles.wallets(7,0),100,100); // all 100% - first year
410         //allocation.addShare(wallets[uint8(Roles.founders)],  10,  50); // only 50% - first year, stage N1  (and +50 for stage N2)
411 
412         // 2% - bounty wallet
413         token.mint(rightAndRoles.wallets(5,0), totalSaledToken.mul(2).div(77));
414 
415         // 10% - company
416         token.mint(rightAndRoles.wallets(6,0), totalSaledToken.mul(10).div(77));
417 
418         // 13% - team
419         token.mint(allocation, totalSaledToken.mul(11).div(77));
420     }
421 
422 
423 
424     // Initializing the round. Available to the manager. After calling the function,
425     // the Manager loses all rights: Manager can not change the settings (setup), change
426     // wallets, prevent the beginning of the round, etc. You must call a function after setup
427     // for the initial round (before the Round1 and before the Round2)
428     // @ Do I have to use the function      yes
429     // @ When it is possible to call        before each round
430     // @ When it is launched automatically  -
431     // @ Who can call the function          admins
432     function initialize() public {
433         require(rightAndRoles.onlyRoles(msg.sender,6));
434         // If not yet initialized
435         require(!isInitialized);
436         begin();
437 
438 
439         // And the specified start time has not yet come
440         // If initialization return an error, check the start date!
441         require(now <= startTime);
442 
443         initialization();
444 
445         emit Initialized();
446 
447         renewal = 0;
448 
449         isInitialized = true;
450 
451         canFirstMint = false;
452     }
453 
454     function initialization() internal {
455         bytes32[] memory params = new bytes32[](0);
456         rightAndRoles.setManagerPowerful(false);
457         if (financialStrategy.state() != IFinancialStrategy.State.Active){
458             financialStrategy.setup(2,params);
459         }
460     }
461 
462     // 
463     // @ Do I have to use the function      
464     // @ When it is possible to call        
465     // @ When it is launched automatically  
466     // @ Who can call the function          
467     function getPartnerCash(uint8 _user, bool _calc) external {
468         if(_calc)
469             calcFin();
470         financialStrategy.getPartnerCash(_user, msg.sender);
471     }
472 
473     function getBeneficiaryCash(bool _calc) public {
474         require(rightAndRoles.onlyRoles(msg.sender,22));
475         if(_calc)
476             calcFin();
477         financialStrategy.getBeneficiaryCash();
478         if(!isInitialized && financialStrategy.freeCash() == 0)
479             rightAndRoles.setManagerPowerful(true);
480     }
481 
482     function claimRefund() external{
483         financialStrategy.refund(msg.sender);
484     }
485 
486     function calcFin() public {
487         bytes32[] memory params = new bytes32[](2);
488         params[0] = bytes32(weiTotalRaised());
489         params[1] = bytes32(msg.sender);
490         financialStrategy.setup(4,params);
491     }
492 
493     function calcAndGet() public {
494         require(rightAndRoles.onlyRoles(msg.sender,22));
495         getBeneficiaryCash(true);
496         for (uint8 i=0; i<0; i++) { // <-- TODO check financialStrategy.wallets.length
497             financialStrategy.getPartnerCash(i, msg.sender);
498         }
499     }
500 
501     // We check whether we collected the necessary minimum funds. Constant.
502     function goalReached() public view returns (bool) {
503         return weiRaised() >= softCap;
504     }
505 
506 
507     // Customize. The arguments are described in the constructor above.
508     // @ Do I have to use the function      yes
509     // @ When it is possible to call        before each rond
510     // @ When it is launched automatically  -
511     // @ Who can call the function          admins
512     function setup(uint256 _startTime, uint256 _endTime, uint256 _softCap, uint256 _hardCap,
513         uint256 _rate, uint256 _exchange,
514         uint256 _maxAllProfit, uint256 _overLimit, uint256 _minPay,
515         uint256[] _durationTB , uint256[] _percentTB, uint256[] _valueVB, uint256[] _percentVB, uint256[] _freezeTimeVB) public
516     {
517 
518         require(rightAndRoles.onlyRoles(msg.sender,6));
519         require(!isInitialized);
520 
521         begin();
522 
523         // Date and time are correct
524         require(now <= _startTime);
525         require(_startTime < _endTime);
526 
527         startTime = _startTime;
528         endTime = _endTime;
529 
530         // The parameters are correct
531         require(_softCap <= _hardCap);
532 
533         softCap = _softCap;
534         hardCap = _hardCap;
535 
536         require(_rate > 0);
537 
538         rate = _rate;
539 
540         overLimit = _overLimit;
541         minPay = _minPay;
542         exchange = _exchange;
543 
544         maxAllProfit = _maxAllProfit;
545 
546         require(_valueVB.length == _percentVB.length && _valueVB.length == _freezeTimeVB.length);
547         bonuses.length = _valueVB.length;
548         for(uint256 i = 0; i < _valueVB.length; i++){
549             bonuses[i] = Bonus(_valueVB[i],_percentVB[i],_freezeTimeVB[i]);
550         }
551 
552         require(_percentTB.length == _durationTB.length);
553         profits.length = _percentTB.length;
554         for( i = 0; i < _percentTB.length; i++){
555             profits[i] = Profit(_percentTB[i],_durationTB[i]);
556         }
557 
558     }
559 
560     // Collected funds for the current round. Constant.
561     function weiRaised() public constant returns(uint256){
562         return ethWeiRaised.add(nonEthWeiRaised);
563     }
564 
565     // Returns the amount of fees for both phases. Constant.
566     function weiTotalRaised() public constant returns(uint256){
567         return weiRound1.add(weiRaised());
568     }
569 
570     // Returns the percentage of the bonus on the current date. Constant.
571     function getProfitPercent() public constant returns (uint256){
572         return getProfitPercentForData(now);
573     }
574 
575     // Returns the percentage of the bonus on the given date. Constant.
576     function getProfitPercentForData(uint256 _timeNow) public constant returns (uint256){
577         uint256 allDuration;
578         for(uint8 i = 0; i < profits.length; i++){
579             allDuration = allDuration.add(profits[i].duration);
580             if(_timeNow < startTime.add(allDuration)){
581                 return profits[i].percent;
582             }
583         }
584         return 0;
585     }
586 
587     function getBonuses(uint256 _value) public constant returns (uint256,uint256,uint256){
588         if(bonuses.length == 0 || bonuses[0].value > _value){
589             return (0,0,0);
590         }
591         uint16 i = 1;
592         for(i; i < bonuses.length; i++){
593             if(bonuses[i].value > _value){
594                 break;
595             }
596         }
597         return (bonuses[i-1].value,bonuses[i-1].procent,bonuses[i-1].freezeTime);
598     }
599 
600     // The ability to quickly check Round1 (only for Round1, only 1 time). Completes the Round1 by
601     // transferring the specified number of tokens to the Accountant's wallet. Available to the Manager.
602     // Use only if this is provided by the script and white paper. In the normal scenario, it
603     // does not call and the funds are raised normally. We recommend that you delete this
604     // function entirely, so as not to confuse the auditors. Initialize & Finalize not needed.
605     // ** QUINTILIONS **  10^18 / 1**18 / 1e18
606     // @ Do I have to use the function      no, see your scenario
607     // @ When it is possible to call        after Round0 and before Round2
608     // @ When it is launched automatically  -
609     // @ Who can call the function          admins
610     //    function fastTokenSale(uint256 _totalSupply) external {
611     //      onlyAdmin(false);
612     //        require(TokenSale == TokenSaleType.round1 && !isInitialized);
613     //        token.mint(wallets[uint8(Roles.accountant)], _totalSupply);
614     //        TokenSale = TokenSaleType.round2;
615     //    }
616 
617 
618     // Remove the "Pause of exchange". Available to the manager at any time. If the
619     // manager refuses to remove the pause, then 30-120 days after the successful
620     // completion of the TokenSale, anyone can remove a pause and allow the exchange to continue.
621     // The manager does not interfere and will not be able to delay the term.
622     // He can only cancel the pause before the appointed time.
623     // @ Do I have to use the function      YES YES YES
624     // @ When it is possible to call        after end of ICO
625     // @ When it is launched automatically  -
626     // @ Who can call the function          admins or anybody
627     function tokenUnpause() external {
628 
629         require(rightAndRoles.onlyRoles(msg.sender,2)
630         || (now > endTime.add(renewal).add(USER_UNPAUSE_TOKEN_TIMEOUT) && TokenSale == TokenSaleType.round2 && isFinalized && goalReached()));
631         token.setPause(false);
632     }
633 
634     // Enable the "Pause of exchange". Available to the manager until the TokenSale is completed.
635     // The manager cannot turn on the pause, for example, 3 years after the end of the TokenSale.
636     // @ Do I have to use the function      no
637     // @ When it is possible to call        while Round2 not ended
638     // @ When it is launched automatically  before any rounds
639     // @ Who can call the function          admins
640     function tokenPause() public {
641         require(rightAndRoles.onlyRoles(msg.sender,6));
642         require(!isFinalized);
643         token.setPause(true);
644     }
645 
646     // Pause of sale. Available to the manager.
647     // @ Do I have to use the function      no
648     // @ When it is possible to call        during active rounds
649     // @ When it is launched automatically  -
650     // @ Who can call the function          admins
651     function setCrowdsalePause(bool mode) public {
652         require(rightAndRoles.onlyRoles(msg.sender,6));
653         isPausedCrowdsale = mode;
654     }
655 
656     // For example - After 5 years of the project's existence, all of us suddenly decided collectively
657     // (company + investors) that it would be more profitable for everyone to switch to another smart
658     // contract responsible for tokens. The company then prepares a new token, investors
659     // disassemble, study, discuss, etc. After a general agreement, the manager allows any investor:
660     //      - to burn the tokens of the previous contract
661     //      - generate new tokens for a new contract
662     // It is understood that after a general solution through this function all investors
663     // will collectively (and voluntarily) move to a new token.
664     // @ Do I have to use the function      no
665     // @ When it is possible to call        only after ICO!
666     // @ When it is launched automatically  -
667     // @ Who can call the function          admins
668     function moveTokens(address _migrationAgent) public {
669         require(rightAndRoles.onlyRoles(msg.sender,6));
670         token.setMigrationAgent(_migrationAgent);
671     }
672 
673     // @ Do I have to use the function      no
674     // @ When it is possible to call        only after ICO!
675     // @ When it is launched automatically  -
676     // @ Who can call the function          admins
677     function migrateAll(address[] _holders) public {
678         require(rightAndRoles.onlyRoles(msg.sender,6));
679         token.migrateAll(_holders);
680     }
681 
682 
683     // The beneficiary at any time can take rights in all roles and prescribe his wallet in all the
684     // rollers. Thus, he will become the recipient of tokens for the role of Accountant,
685     // Team, etc. Works at any time.
686     // @ Do I have to use the function      no
687     // @ When it is possible to call        any time
688     // @ When it is launched automatically  -
689     // @ Who can call the function          only Beneficiary
690 //    function resetAllWallets() external{
691 //        address _beneficiary = wallets[uint8(Roles.beneficiary)];
692 //        require(msg.sender == _beneficiary);
693 //        for(uint8 i = 0; i < wallets.length; i++){
694 //            wallets[i] = _beneficiary;
695 //        }
696 //        token.setUnpausedWallet(_beneficiary, true);
697 //    }
698 
699 
700     // Burn the investor tokens, if provided by the ICO scenario. Limited time available - BURN_TOKENS_TIME
701     // For people who ignore the KYC/AML procedure during 30 days after payment: money back and burning tokens.
702     // ***CHECK***SCENARIO***
703     // @ Do I have to use the function      no
704     // @ When it is possible to call        any time
705     // @ When it is launched automatically  -
706     // @ Who can call the function          admin
707     function massBurnTokens(address[] _beneficiary, uint256[] _value) external {
708         require(rightAndRoles.onlyRoles(msg.sender,6));
709         require(endTime.add(renewal).add(BURN_TOKENS_TIME) > now);
710         require(_beneficiary.length == _value.length);
711         for(uint16 i; i<_beneficiary.length; i++) {
712             token.burn(_beneficiary[i],_value[i]);
713         }
714     }
715 
716     // Extend the round time, if provided by the script. Extend the round only for
717     // a limited number of days - ROUND_PROLONGATE
718     // ***CHECK***SCENARIO***
719     // @ Do I have to use the function      no
720     // @ When it is possible to call        during active round
721     // @ When it is launched automatically  -
722     // @ Who can call the function          admins
723     function prolong(uint256 _duration) external {
724         require(rightAndRoles.onlyRoles(msg.sender,6));
725         require(now > startTime && now < endTime.add(renewal) && isInitialized && !isFinalized);
726         renewal = renewal.add(_duration);
727         require(renewal <= ROUND_PROLONGATE);
728 
729     }
730     // If a little more than a year has elapsed (Round2 start date + 400 days), a smart contract
731     // will allow you to send all the money to the Beneficiary, if any money is present. This is
732     // possible if you mistakenly launch the Round2 for 30 years (not 30 days), investors will transfer
733     // money there and you will not be able to pick them up within a reasonable time. It is also
734     // possible that in our checked script someone will make unforeseen mistakes, spoiling the
735     // finalization. Without finalization, money cannot be returned. This is a rescue option to
736     // get around this problem, but available only after a year (400 days).
737 
738     // Another reason - the TokenSale was a failure, but not all ETH investors took their money during the year after.
739     // Some investors may have lost a wallet key, for example.
740 
741     // The method works equally with the Round1 and Round2. When the Round1 starts, the time for unlocking
742     // the distructVault begins. If the TokenSale is then started, then the term starts anew from the first day of the TokenSale.
743 
744     // Next, act independently, in accordance with obligations to investors.
745 
746     // Within 400 days (FORCED_REFUND_TIMEOUT1) of the start of the Round, if it fails only investors can take money. After
747     // the deadline this can also include the company as well as investors, depending on who is the first to use the method.
748     // @ Do I have to use the function      no
749     // @ When it is possible to call        -
750     // @ When it is launched automatically  -
751     // @ Who can call the function          beneficiary & manager
752     function distructVault() public {
753         bytes32[] memory params = new bytes32[](1);
754         params[0] = bytes32(msg.sender);
755         if (rightAndRoles.onlyRoles(msg.sender,4) && (now > startTime.add(FORCED_REFUND_TIMEOUT1))) {
756 
757             financialStrategy.setup(0,params);
758         }
759         if (rightAndRoles.onlyRoles(msg.sender,2) && (now > startTime.add(FORCED_REFUND_TIMEOUT2))) {
760             financialStrategy.setup(0,params);
761         }
762     }
763 
764 
765     // We accept payments other than Ethereum (ETH) and other currencies, for example, Bitcoin (BTC).
766     // Perhaps other types of cryptocurrency - see the original terms in the white paper and on the TokenSale website.
767 
768     // We release tokens on Ethereum. During the Round1 and Round2 with a smart contract, you directly transfer
769     // the tokens there and immediately, with the same transaction, receive tokens in your wallet.
770 
771     // When paying in any other currency, for example in BTC, we accept your money via one common wallet.
772     // Our manager fixes the amount received for the bitcoin wallet and calls the method of the smart
773     // contract paymentsInOtherCurrency to inform him how much foreign currency has been received - on a daily basis.
774     // The smart contract pins the number of accepted ETH directly and the number of BTC. Smart contract
775     // monitors softcap and hardcap, so as not to go beyond this framework.
776 
777     // In theory, it is possible that when approaching hardcap, we will receive a transfer (one or several
778     // transfers) to the wallet of BTC, that together with previously received money will exceed the hardcap in total.
779     // In this case, we will refund all the amounts above, in order not to exceed the hardcap.
780 
781     // Collection of money in BTC will be carried out via one common wallet. The wallet's address will be published
782     // everywhere (in a white paper, on the TokenSale website, on Telegram, on Bitcointalk, in this code, etc.)
783     // Anyone interested can check that the administrator of the smart contract writes down exactly the amount
784     // in ETH (in equivalent for BTC) there. In theory, the ability to bypass a smart contract to accept money in
785     // BTC and not register them in ETH creates a possibility for manipulation by the company. Thanks to
786     // paymentsInOtherCurrency however, this threat is leveled.
787 
788     // Any user can check the amounts in BTC and the variable of the smart contract that accounts for this
789     // (paymentsInOtherCurrency method). Any user can easily check the incoming transactions in a smart contract
790     // on a daily basis. Any hypothetical tricks on the part of the company can be exposed and panic during the TokenSale,
791     // simply pointing out the incompatibility of paymentsInOtherCurrency (ie, the amount of ETH + BTC collection)
792     // and the actual transactions in BTC. The company strictly adheres to the described principles of openness.
793 
794     // The company administrator is required to synchronize paymentsInOtherCurrency every working day (but you
795     // cannot synchronize if there are no new BTC payments). In the case of unforeseen problems, such as
796     // brakes on the Ethereum network, this operation may be difficult. You should only worry if the
797     // administrator does not synchronize the amount for more than 96 hours in a row, and the BTC wallet
798     // receives significant amounts.
799 
800     // This scenario ensures that for the sum of all fees in all currencies this value does not exceed hardcap.
801 
802     // ** QUINTILLIONS ** 10^18 / 1**18 / 1e18
803 
804     // @ Do I have to use the function      no
805     // @ When it is possible to call        during active rounds
806     // @ When it is launched automatically  every day from cryptob2b token software
807     // @ Who can call the function          admins + observer
808     function paymentsInOtherCurrency(uint256 _token, uint256 _value) public {
809 
810         // **For audit**
811         // BTC Wallet:             1D7qaRN6keGJKb5LracZYQEgCBaryZxVaE
812         // BCH Wallet:             1CDRdTwvEyZD7qjiGUYxZQSf8n91q95xHU
813         // DASH Wallet:            XnjajDvQq1C7z2o4EFevRhejc6kRmX1NUp
814         // LTC Wallet:             LhHkiwVfoYEviYiLXP5pRK2S1QX5eGrotA
815         require(rightAndRoles.onlyRoles(msg.sender,18));
816         //onlyAdmin(true);
817         bool withinPeriod = (now >= startTime && now <= endTime.add(renewal));
818         bool withinCap = _value.add(ethWeiRaised) <= hardCap.add(overLimit);
819         require(withinPeriod && withinCap && isInitialized && !isFinalized);
820         emit PaymentedInOtherCurrency(_token,_value);
821         nonEthWeiRaised = _value;
822         tokenReserved = _token;
823 
824     }
825 
826     function lokedMint(address _beneficiary, uint256 _value, uint256 _freezeTime) internal {
827         if(_freezeTime > 0){
828 
829             uint256 totalBloked = token.freezedTokenOf(_beneficiary).add(_value);
830             uint256 pastDateUnfreeze = token.defrostDate(_beneficiary);
831             uint256 newDateUnfreeze = _freezeTime.add(now);
832             newDateUnfreeze = (pastDateUnfreeze > newDateUnfreeze ) ? pastDateUnfreeze : newDateUnfreeze;
833 
834             token.freezeTokens(_beneficiary,totalBloked,newDateUnfreeze);
835         }
836         token.mint(_beneficiary,_value);
837     }
838 
839 
840     // The function for obtaining smart contract funds in ETH. If all the checks are true, the token is
841     // transferred to the buyer, taking into account the current bonus.
842     function buyTokens(address _beneficiary) public payable {
843         require(_beneficiary != 0x0);
844         require(validPurchase());
845 
846         uint256 weiAmount = msg.value;
847 
848         uint256 ProfitProcent = getProfitPercent();
849 
850         uint256 value;
851         uint256 percent;
852         uint256 freezeTime;
853 
854         (value,
855         percent,
856         freezeTime) = getBonuses(weiAmount);
857 
858         Bonus memory curBonus = Bonus(value,percent,freezeTime);
859 
860         uint256 bonus = curBonus.procent;
861 
862         // --------------------------------------------------------------------------------------------
863         // *** Scenario 1 - select max from all bonuses + check maxAllProfit
864         //uint256 totalProfit = (ProfitProcent < bonus) ? bonus : ProfitProcent;
865         // *** Scenario 2 - sum both bonuses + check maxAllProfit
866         uint256 totalProfit = bonus.add(ProfitProcent);
867         // --------------------------------------------------------------------------------------------
868         totalProfit = (totalProfit > maxAllProfit) ? maxAllProfit : totalProfit;
869 
870         // calculate token amount to be created
871         uint256 tokens = weiAmount.mul(rate).mul(totalProfit.add(100)).div(100 ether);
872 
873         // update state
874         ethWeiRaised = ethWeiRaised.add(weiAmount);
875 
876         lokedMint(_beneficiary, tokens, curBonus.freezeTime);
877 
878         emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
879 
880         forwardFunds(_beneficiary);//forwardFunds(msg.sender);
881     }
882 
883     // buyTokens alias
884     function () public payable {
885         buyTokens(msg.sender);
886     }
887 }