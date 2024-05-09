1 pragma solidity ^0.4.21;
2 
3 // Project: MOBU.io
4 // v12, 2018-08-24
5 // This code is the property of CryptoB2B.io
6 // Copying in whole or in part is prohibited.
7 // Authors: Ivan Fedorov and Dmitry Borodin
8 // Do you want the same TokenSale platform? www.cryptob2b.io
9 
10 contract GuidedByRoles {
11     IRightAndRoles public rightAndRoles;
12     function GuidedByRoles(IRightAndRoles _rightAndRoles) public {
13         rightAndRoles = _rightAndRoles;
14     }
15 }
16 
17 contract IToken{
18     function setUnpausedWallet(address _wallet, bool mode) public;
19     function mint(address _to, uint256 _amount) public returns (bool);
20     function totalSupply() public view returns (uint256);
21     function setPause(bool mode) public;
22     function setMigrationAgent(address _migrationAgent) public;
23     function migrateAll(address[] _holders) public;
24     function markTokens(address _beneficiary, uint256 _value) public;
25     function freezedTokenOf(address _beneficiary) public view returns (uint256 amount);
26     function defrostDate(address _beneficiary) public view returns (uint256 Date);
27     function freezeTokens(address _beneficiary, uint256 _amount, uint256 _when) public;
28 }
29 
30 contract IRightAndRoles {
31     address[][] public wallets;
32     mapping(address => uint16) public roles;
33 
34     event WalletChanged(address indexed newWallet, address indexed oldWallet, uint8 indexed role);
35     event CloneChanged(address indexed wallet, uint8 indexed role, bool indexed mod);
36 
37     function changeWallet(address _wallet, uint8 _role) external;
38     function setManagerPowerful(bool _mode) external;
39     function onlyRoles(address _sender, uint16 _roleMask) view external returns(bool);
40 }
41 
42 contract ERC20Provider is GuidedByRoles {
43     function transferTokens(ERC20Basic _token, address _to, uint256 _value) public returns (bool){
44         require(rightAndRoles.onlyRoles(msg.sender,2));
45         return _token.transfer(_to,_value);
46     }
47 }
48 
49 contract Crowdsale is GuidedByRoles, ERC20Provider{
50 // (A1)
51 // The main contract for the sale and management of rounds.
52 // 0000000000000000000000000000000000000000000000000000000000000000
53 
54     uint256 constant USER_UNPAUSE_TOKEN_TIMEOUT =  30 days;
55     uint256 constant FORCED_REFUND_TIMEOUT1     = 400 days;
56     uint256 constant FORCED_REFUND_TIMEOUT2     = 600 days;
57     uint256 constant ROUND_PROLONGATE           =  60 days;
58     //uint256 constant KYC_PERIOD                 =  90 days;
59 
60     using SafeMath for uint256;
61 
62     enum TokenSaleType {round1, round2}
63     TokenSaleType public TokenSale = TokenSaleType.round1;
64 
65 
66     ICreator public creator;
67     bool isBegin=false;
68 
69     IToken public token;
70     IAllocation public allocation;
71     IFinancialStrategy public financialStrategy;
72 
73     bool public isFinalized;
74     bool public isInitialized;
75     bool public isPausedCrowdsale;
76     bool public chargeBonuses;
77     bool public canFirstMint=true;
78 
79     struct Bonus {
80         uint256 value;
81         uint256 procent;
82         uint256 freezeTime;
83     }
84 
85     struct Profit {
86         uint256 percent;
87         uint256 duration;
88     }
89 
90     struct Freezed {
91         uint256 value;
92         uint256 dateTo;
93     }
94 
95     mapping (address => bool) public promo;
96 
97     Bonus[] public bonuses;
98     Profit[] public profits;
99 
100 
101     uint256 public startTime;  
102     uint256 public endTime; 
103     uint256 public renewal;
104 
105     // How many tokens (excluding the bonus) are transferred to the investor in exchange for 1 ETH
106     // **THOUSANDS** 10^18 for human, *10**18 for Solidity, 1e18 for MyEtherWallet (MEW).
107     // Example: if 1ETH = 40.5 Token ==> use 40500 finney
108     uint256 public rate; 
109 
110     // ETH/USD rate in US$
111     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: ETH/USD=$1000 ==> use 1000*10**18 (Solidity) or 1000 ether or 1000e18 (MEW)
112     uint256 public exchange;
113 
114     // If the round does not attain this value before the closing date, the round is recognized as a
115     // failure and investors take the money back (the founders will not interfere in any way).
116     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: softcap=15ETH ==> use 15*10**18 (Solidity) or 15e18 (MEW)
117     uint256 public softCap;
118 
119     // The maximum possible amount of income
120     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: hardcap=123.45ETH ==> use 123450*10**15 (Solidity) or 12345e15 (MEW)
121     uint256 public hardCap;
122 
123     // If the last payment is slightly higher than the hardcap, then the usual contracts do
124     // not accept it, because it goes beyond the hardcap. However it is more reasonable to accept the
125     // last payment, very slightly raising the hardcap. The value indicates by how many ETH the
126     // last payment can exceed the hardcap to allow it to be paid. Immediately after this payment, the
127     // round closes. The funders should write here a small number, not more than 1% of the CAP.
128     // Can be equal to zero, to cancel.
129     // **QUINTILLIONS** 10^18 / *10**18 / 1e18
130     uint256 public overLimit;
131 
132     // The minimum possible payment from an investor in ETH. Payments below this value will be rejected.
133     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: minPay=0.1ETH ==> use 100*10**15 (Solidity) or 100e15 (MEW)
134     uint256 public minPay;
135 
136     uint256 public maxAllProfit; // max time bonus=20%, max value bonus=10%, maxAll=10%+20%
137 
138     uint256 public ethWeiRaised;
139     uint256 public nonEthWeiRaised;
140     uint256 public weiRound1;
141     uint256 public tokenReserved;
142 
143     uint256 public totalSaledToken;
144 
145     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
146 
147     event Finalized();
148     event Initialized();
149 
150     event PaymentedInOtherCurrency(uint256 token, uint256 value);
151     event ExchangeChanged(uint256 indexed oldExchange, uint256 indexed newExchange);
152 
153     function Crowdsale(ICreator _creator,IToken _token) GuidedByRoles(_creator.getRightAndRoles()) public
154     {
155         creator=_creator;
156         token = _token;
157     }
158 
159     function updateInfo(uint256 _ETHUSD,uint256 _token, uint256 _value) public {
160 //        if(_ETHUSD > 0){
161 //            changeExchange(_ETHUSD);
162 //        }
163         if(_token > 0 && _value > 0){
164             paymentsInOtherCurrency(_token,_value);
165         }
166     }
167 
168     // Setting the current rate ETH/USD         
169     //    function changeExchange(uint256 _ETHUSD) internal {
170     //        - skip -
171     //    }
172 
173     function setPromo(address[] _investors, uint8[] _mod) public {
174         require(rightAndRoles.onlyRoles(msg.sender,18));
175         for(uint256 i = 0; i < _investors.length; i++){
176             promo[_investors[i]] = _mod[i] > 0;
177         }
178     }
179 
180     // Setting of basic parameters, analog of class constructor
181     // @ Do I have to use the function      see your scenario
182     // @ When it is possible to call        before Round 1/2
183     // @ When it is launched automatically  -
184     // @ Who can call the function          admins
185     function begin() public
186     {
187 
188         require(rightAndRoles.onlyRoles(msg.sender,22));
189         if (isBegin) return;
190         isBegin=true;
191 
192         // This setting only for Round #1 (pre-ICO), not for both rounds.
193         startTime   = 1535799600;   // 1.09.18
194         endTime     = 1538391599;   // 1.10.18
195         rate        = 2000 ether;   // 1 ETH -> 2000 tokens (ETH/USD $300)
196         exchange    = 300 ether;    // ETH/USD
197         softCap     = 0 ether;     
198         hardCap     = 58333 ether;  // $20 000 000 (ETH/USD $300)
199         overLimit   = 20 ether;  
200         minPay      = 1000 finney;  // 1 ETH =~ $300 (ETH/USD $300)
201         maxAllProfit= 55;           // 55%
202 
203         financialStrategy = creator.createFinancialStrategy();
204 
205         token.setUnpausedWallet(rightAndRoles.wallets(1,0), true);
206         token.setUnpausedWallet(rightAndRoles.wallets(3,0), true);
207         token.setUnpausedWallet(rightAndRoles.wallets(4,0), true);
208         token.setUnpausedWallet(rightAndRoles.wallets(5,0), true);
209         token.setUnpausedWallet(rightAndRoles.wallets(6,0), true);
210 
211         bonuses.push(Bonus(33 ether, 10,0));   // value >$10000 is +10% bonus   (ETH/USD $300)
212         bonuses.push(Bonus(333 ether, 20,0));  // value >$100000 is +20% bonus
213 
214         profits.push(Profit(25,100 days));
215     }
216 
217 
218 
219     // Issue of tokens for the zero round, it is usually called: private pre-sale (Round 0)
220     // @ Do I have to use the function      may be
221     // @ When it is possible to call        before Round 1/2
222     // @ When it is launched automatically  -
223     // @ Who can call the function          admins
224     function firstMintRound0(uint256 _amount /* QUINTILLIONS! */) public {
225         require(rightAndRoles.onlyRoles(msg.sender,6));
226         require(canFirstMint);
227         begin();
228         token.mint(rightAndRoles.wallets(3,0),_amount);
229         totalSaledToken = totalSaledToken.add(_amount);
230     }
231 
232     function firstMintRound0For(address[] _to, uint256[] _amount, uint8[] _setAsUnpaused) public {
233         require(rightAndRoles.onlyRoles(msg.sender,6));
234         require(canFirstMint);
235         begin();
236         require(_to.length == _amount.length && _to.length == _setAsUnpaused.length);
237         for(uint256 i = 0; i < _to.length; i++){
238             token.mint(_to[i],_amount[i]);
239             totalSaledToken = totalSaledToken.add(_amount[i]);
240             if(_setAsUnpaused[i]>0){
241                 token.setUnpausedWallet(_to[i], true);
242             }
243         }
244     }
245 
246     // info
247     function totalSupply() external view returns (uint256){
248         return token.totalSupply();
249     }
250 
251     function isPromo(address _address) public view returns (bool){
252        return promo[_address];
253     }
254 
255     // Transfers the funds of the investor to the contract of return of funds. Internal.
256     function forwardFunds(address _beneficiary) internal {
257         financialStrategy.deposit.value(msg.value)(_beneficiary);
258     }
259 
260     // Check for the possibility of buying tokens. Inside. Constant.
261     function validPurchase() internal view returns (bool) {
262 
263         // The round started and did not end
264         bool withinPeriod = (now > startTime && now < endTime.add(renewal));
265 
266         // Rate is greater than or equal to the minimum
267         bool nonZeroPurchase = msg.value >= minPay;
268 
269         // hardCap is not reached, and in the event of a transaction, it will not be exceeded by more than OverLimit
270         bool withinCap = msg.value <= hardCap.sub(weiRaised()).add(overLimit);
271 
272         // round is initialized and no "Pause of trading" is set
273         return withinPeriod && nonZeroPurchase && withinCap && isInitialized && !isFinalized && !isPausedCrowdsale;
274     }
275 
276     // Check for the ability to finalize the round. Constant.
277     function hasEnded() public view returns (bool) {
278         bool isAdmin = rightAndRoles.onlyRoles(msg.sender,6);
279 
280         bool timeReached = now > endTime.add(renewal);
281 
282         bool capReached = weiRaised() >= hardCap;
283 
284         return (timeReached || capReached || (isAdmin && goalReached())) && isInitialized && !isFinalized;
285     }
286 
287     // Finalize. Only available to the Manager and the Beneficiary. If the round failed, then
288     // anyone can call the finalization to unlock the return of funds to investors
289     // You must call a function to finalize each round (after the Round1 & after the Round2)
290     // @ Do I have to use the function      yes
291     // @ When it is possible to call        after end of Round1 & Round2
292     // @ When it is launched automatically  no
293     // @ Who can call the function          admins or anybody (if round is failed)
294     function finalize() public {
295         require(hasEnded());
296 
297         isFinalized = true;
298         finalization();
299         emit Finalized();
300     }
301 
302     // The logic of finalization. Internal
303     // @ Do I have to use the function      no
304     // @ When it is possible to call        -
305     // @ When it is launched automatically  after end of round
306     // @ Who can call the function          -
307     function finalization() internal {
308         bytes32[] memory params = new bytes32[](0);
309         // If the goal of the achievement
310         if (goalReached()) {
311 
312             financialStrategy.setup(1,params);
313 
314             // if there is anything to give
315             if (tokenReserved > 0) {
316 
317                 token.mint(rightAndRoles.wallets(3,0),tokenReserved);
318                 totalSaledToken = totalSaledToken.add(tokenReserved);
319 
320                 // Reset the counter
321                 tokenReserved = 0;
322             }
323 
324             // If the finalization is Round 1
325             if (TokenSale == TokenSaleType.round1) {
326 
327                 // Reset settings
328                 isInitialized = false;
329                 isFinalized = false;
330                 if(financialStrategy.freeCash() == 0){
331                     rightAndRoles.setManagerPowerful(true);
332                 }
333 
334                 // Switch to the second round (to Round2)
335                 TokenSale = TokenSaleType.round2;
336 
337                 // Reset the collection counter
338                 weiRound1 = weiRaised();
339                 ethWeiRaised = 0;
340                 nonEthWeiRaised = 0;
341 
342 
343 
344             }
345             else // If the second round is finalized
346             {
347 
348                 // Permission to collect tokens to those who can pick them up
349                 chargeBonuses = true;
350 
351                 //totalSaledToken = token.totalSupply();
352                 //partners = true;
353 
354             }
355 
356         }
357         else // If they failed round
358         {
359             financialStrategy.setup(3,params);
360         }
361     }
362 
363     // The Manager freezes the tokens for the Team.
364     // You must call a function to finalize Round 2 (only after the Round2)
365     // @ Do I have to use the function      yes
366     // @ When it is possible to call        Round2
367     // @ When it is launched automatically  -
368     // @ Who can call the function          admins
369     function finalize2() public {
370         require(rightAndRoles.onlyRoles(msg.sender,6));
371         require(chargeBonuses);
372         chargeBonuses = false;
373 
374         allocation = creator.createAllocation(token, now + 1 years /* stage N1 */,0/* not need*/);
375         token.setUnpausedWallet(allocation, true);
376         // Team = %, Founders = %, Fund = %    TOTAL = %
377         allocation.addShare(rightAndRoles.wallets(7,0),100,100); // all 100% - first year
378 
379         // 2% - bounty wallet
380         token.mint(rightAndRoles.wallets(5,0), totalSaledToken.mul(8).div(80));
381 
382         // 10% - company
383         //token.mint(rightAndRoles.wallets(6,0), totalSaledToken.mul(10).div(77));
384 
385         // 13% - team
386         token.mint(allocation, totalSaledToken.mul(12).div(80));
387     }
388 
389 
390 
391     // Initializing the round. Available to the manager. After calling the function,
392     // the Manager loses all rights: Manager can not change the settings (setup), change
393     // wallets, prevent the beginning of the round, etc. You must call a function after setup
394     // for the initial round (before the Round1 and before the Round2)
395     // @ Do I have to use the function      yes
396     // @ When it is possible to call        before each round
397     // @ When it is launched automatically  -
398     // @ Who can call the function          admins
399     function initialize() public {
400         require(rightAndRoles.onlyRoles(msg.sender,6));
401         // If not yet initialized
402         require(!isInitialized);
403         begin();
404 
405 
406         // And the specified start time has not yet come
407         // If initialization return an error, check the start date!
408         require(now <= startTime);
409 
410         initialization();
411 
412         emit Initialized();
413 
414         renewal = 0;
415 
416         isInitialized = true;
417 
418         if(TokenSale == TokenSaleType.round2) canFirstMint = false;
419     }
420 
421     function initialization() internal {
422         bytes32[] memory params = new bytes32[](0);
423         rightAndRoles.setManagerPowerful(false);
424         if (financialStrategy.state() != IFinancialStrategy.State.Active){
425             financialStrategy.setup(2,params);
426         }
427     }
428 
429     // 
430     // @ Do I have to use the function      
431     // @ When it is possible to call        
432     // @ When it is launched automatically  
433     // @ Who can call the function          
434     function getPartnerCash(uint8 _user, bool _calc) external {
435         if(_calc)
436             calcFin();
437         financialStrategy.getPartnerCash(_user, msg.sender);
438     }
439 
440     function getBeneficiaryCash(bool _calc) public {
441         require(rightAndRoles.onlyRoles(msg.sender,22));
442         if(_calc)
443             calcFin();
444         financialStrategy.getBeneficiaryCash();
445         if(!isInitialized && financialStrategy.freeCash() == 0)
446             rightAndRoles.setManagerPowerful(true);
447     }
448 
449     function claimRefund() external{
450         financialStrategy.refund(msg.sender);
451     }
452 
453     function calcFin() public {
454         bytes32[] memory params = new bytes32[](2);
455         params[0] = bytes32(weiTotalRaised());
456         params[1] = bytes32(msg.sender);
457         financialStrategy.setup(4,params);
458     }
459 
460     function calcAndGet() public {
461         require(rightAndRoles.onlyRoles(msg.sender,22));
462         getBeneficiaryCash(true);
463         for (uint8 i=0; i<0; i++) { // <-- TODO check financialStrategy.wallets.length
464             financialStrategy.getPartnerCash(i, msg.sender);
465         }
466     }
467 
468     // We check whether we collected the necessary minimum funds. Constant.
469     function goalReached() public view returns (bool) {
470         return weiRaised() >= softCap;
471     }
472 
473 
474     // Customize. The arguments are described in the constructor above.
475     // @ Do I have to use the function      yes
476     // @ When it is possible to call        before each rond
477     // @ When it is launched automatically  -
478     // @ Who can call the function          admins
479     function setup(uint256 _startTime, uint256 _endTime, uint256 _softCap, uint256 _hardCap,
480         uint256 _rate, uint256 _exchange,
481         uint256 _maxAllProfit, uint256 _overLimit, uint256 _minPay,
482         uint256[] _durationTB , uint256[] _percentTB, uint256[] _valueVB, uint256[] _percentVB, uint256[] _freezeTimeVB) public
483     {
484 
485         require(rightAndRoles.onlyRoles(msg.sender,6));
486         require(!isInitialized);
487 
488         begin();
489 
490         // Date and time are correct
491         require(now <= _startTime);
492         require(_startTime < _endTime);
493 
494         startTime = _startTime;
495         endTime = _endTime;
496 
497         // The parameters are correct
498         require(_softCap <= _hardCap);
499 
500         softCap = _softCap;
501         hardCap = _hardCap;
502 
503         require(_rate > 0);
504 
505         rate = _rate;
506 
507         overLimit = _overLimit;
508         minPay = _minPay;
509         exchange = _exchange;
510 
511         maxAllProfit = _maxAllProfit;
512 
513         require(_valueVB.length == _percentVB.length && _valueVB.length == _freezeTimeVB.length);
514         bonuses.length = _valueVB.length;
515         for(uint256 i = 0; i < _valueVB.length; i++){
516             bonuses[i] = Bonus(_valueVB[i],_percentVB[i],_freezeTimeVB[i]);
517         }
518 
519         require(_percentTB.length == _durationTB.length);
520         profits.length = _percentTB.length;
521         for( i = 0; i < _percentTB.length; i++){
522             profits[i] = Profit(_percentTB[i],_durationTB[i]);
523         }
524 
525     }
526 
527     // Collected funds for the current round. Constant.
528     function weiRaised() public constant returns(uint256){
529         return ethWeiRaised.add(nonEthWeiRaised);
530     }
531 
532     // Returns the amount of fees for both phases. Constant.
533     function weiTotalRaised() public constant returns(uint256){
534         return weiRound1.add(weiRaised());
535     }
536 
537     // Returns the percentage of the bonus on the current date. Constant.
538     function getProfitPercent() public constant returns (uint256){
539         return getProfitPercentForData(now);
540     }
541 
542     // Returns the percentage of the bonus on the given date. Constant.
543     function getProfitPercentForData(uint256 _timeNow) public constant returns (uint256){
544         uint256 allDuration;
545         for(uint8 i = 0; i < profits.length; i++){
546             allDuration = allDuration.add(profits[i].duration);
547             if(_timeNow < startTime.add(allDuration)){
548                 return profits[i].percent;
549             }
550         }
551         return 0;
552     }
553 
554     function getBonuses(uint256 _value) public constant returns (uint256,uint256,uint256){
555         if(bonuses.length == 0 || bonuses[0].value > _value){
556             return (0,0,0);
557         }
558         uint16 i = 1;
559         for(i; i < bonuses.length; i++){
560             if(bonuses[i].value > _value){
561                 break;
562             }
563         }
564         return (bonuses[i-1].value,bonuses[i-1].procent,bonuses[i-1].freezeTime);
565     }
566 
567 
568     // Remove the "Pause of exchange". Available to the manager at any time. If the
569     // manager refuses to remove the pause, then 30-120 days after the successful
570     // completion of the TokenSale, anyone can remove a pause and allow the exchange to continue.
571     // The manager does not interfere and will not be able to delay the term.
572     // He can only cancel the pause before the appointed time.
573     // @ Do I have to use the function      YES YES YES
574     // @ When it is possible to call        after end of ICO
575     // @ When it is launched automatically  -
576     // @ Who can call the function          admins or anybody
577     function tokenUnpause() external {
578 
579         require(rightAndRoles.onlyRoles(msg.sender,2)
580         || (now > endTime.add(renewal).add(USER_UNPAUSE_TOKEN_TIMEOUT) && TokenSale == TokenSaleType.round2 && isFinalized && goalReached()));
581         token.setPause(false);
582     }
583 
584     // Enable the "Pause of exchange". Available to the manager until the TokenSale is completed.
585     // The manager cannot turn on the pause, for example, 3 years after the end of the TokenSale.
586     // @ Do I have to use the function      no
587     // @ When it is possible to call        while Round2 not ended
588     // @ When it is launched automatically  before any rounds
589     // @ Who can call the function          admins
590     function tokenPause() public {
591         require(rightAndRoles.onlyRoles(msg.sender,6));
592         require(!isFinalized);
593         token.setPause(true);
594     }
595 
596     // Pause of sale. Available to the manager.
597     // @ Do I have to use the function      no
598     // @ When it is possible to call        during active rounds
599     // @ When it is launched automatically  -
600     // @ Who can call the function          admins
601     function setCrowdsalePause(bool mode) public {
602         require(rightAndRoles.onlyRoles(msg.sender,6));
603         isPausedCrowdsale = mode;
604     }
605 
606     // For example - After 5 years of the project's existence, all of us suddenly decided collectively
607     // (company + investors) that it would be more profitable for everyone to switch to another smart
608     // contract responsible for tokens. The company then prepares a new token, investors
609     // disassemble, study, discuss, etc. 
610     // @ Do I have to use the function      no
611     // @ When it is possible to call        only after ICO!
612     // @ When it is launched automatically  -
613     // @ Who can call the function          admins
614 //    function moveTokens(address _migrationAgent) public {
615 //        require(rightAndRoles.onlyRoles(msg.sender,6));
616 //        token.setMigrationAgent(_migrationAgent);
617 //    }
618 
619     // @ Do I have to use the function      no
620     // @ When it is possible to call        only after ICO!
621     // @ When it is launched automatically  -
622     // @ Who can call the function          admins
623 //    function migrateAll(address[] _holders) public {
624 //        require(rightAndRoles.onlyRoles(msg.sender,6));
625 //        token.migrateAll(_holders);
626 //    }
627 
628 
629     // For people who ignore the KYC/AML procedure during 30 days after payment (KYC_PERIOD): money back and zeroing tokens.
630     // ***CHECK***SCENARIO***
631     // @ Do I have to use the function      no
632     // @ When it is possible to call        any time
633     // @ When it is launched automatically  -
634     // @ Who can call the function          admin
635 //    function invalidPayments(address[] _beneficiary, uint256[] _value) external {
636 //        require(rightAndRoles.onlyRoles(msg.sender,6));
637 //        require(endTime.add(renewal).add(KYC_PERIOD) > now);
638 //        require(_beneficiary.length == _value.length);
639 //        for(uint16 i; i<_beneficiary.length; i++) {
640 //            token.markTokens(_beneficiary[i],_value[i]);
641 //        }
642 //    }
643 
644     // Extend the round time, if provided by the script. Extend the round only for
645     // a limited number of days - ROUND_PROLONGATE
646     // ***CHECK***SCENARIO***
647     // @ Do I have to use the function      no
648     // @ When it is possible to call        during active round
649     // @ When it is launched automatically  -
650     // @ Who can call the function          admins
651     function prolong(uint256 _duration) external {
652         require(rightAndRoles.onlyRoles(msg.sender,6));
653         require(now > startTime && now < endTime.add(renewal) && isInitialized && !isFinalized);
654         renewal = renewal.add(_duration);
655         require(renewal <= ROUND_PROLONGATE);
656 
657     }
658     // If a little more than a year has elapsed (Round2 start date + 400 days), a smart contract
659     // will allow you to send all the money to the Beneficiary, if any money is present. This is
660     // possible if you mistakenly launch the Round2 for 30 years (not 30 days), investors will transfer
661     // money there and you will not be able to pick them up within a reasonable time. It is also
662     // possible that in our checked script someone will make unforeseen mistakes, spoiling the
663     // finalization. Without finalization, money cannot be returned. This is a rescue option to
664     // get around this problem, but available only after a year (400 days).
665 
666     // Another reason - the TokenSale was a failure, but not all ETH investors took their money during the year after.
667     // Some investors may have lost a wallet key, for example.
668 
669     // The method works equally with the Round1 and Round2. When the Round1 starts, the time for unlocking
670     // the distructVault begins. If the TokenSale is then started, then the term starts anew from the first day of the TokenSale.
671 
672     // Next, act independently, in accordance with obligations to investors.
673 
674     // Within 400 days (FORCED_REFUND_TIMEOUT1) of the start of the Round, if it fails only investors can take money. After
675     // the deadline this can also include the company as well as investors, depending on who is the first to use the method.
676     // @ Do I have to use the function      no
677     // @ When it is possible to call        -
678     // @ When it is launched automatically  -
679     // @ Who can call the function          beneficiary & manager
680     function distructVault() public {
681         bytes32[] memory params = new bytes32[](1);
682         params[0] = bytes32(msg.sender);
683         if (rightAndRoles.onlyRoles(msg.sender,4) && (now > startTime.add(FORCED_REFUND_TIMEOUT1))) {
684             financialStrategy.setup(0,params);
685         }
686         if (rightAndRoles.onlyRoles(msg.sender,2) && (now > startTime.add(FORCED_REFUND_TIMEOUT2))) {
687             financialStrategy.setup(0,params);
688         }
689     }
690 
691 
692     // We accept payments other than Ethereum (ETH) and other currencies, for example, Bitcoin (BTC).
693     // Perhaps other types of cryptocurrency - see the original terms in the white paper and on the TokenSale website.
694 
695     // We release tokens on Ethereum. During the Round1 and Round2 with a smart contract, you directly transfer
696     // the tokens there and immediately, with the same transaction, receive tokens in your wallet.
697 
698     // When paying in any other currency, for example in BTC, we accept your money via one common wallet.
699     // Our manager fixes the amount received for the bitcoin wallet and calls the method of the smart
700     // contract paymentsInOtherCurrency to inform him how much foreign currency has been received - on a daily basis.
701     // The smart contract pins the number of accepted ETH directly and the number of BTC. Smart contract
702     // monitors softcap and hardcap, so as not to go beyond this framework.
703 
704     // In theory, it is possible that when approaching hardcap, we will receive a transfer (one or several
705     // transfers) to the wallet of BTC, that together with previously received money will exceed the hardcap in total.
706     // In this case, we will refund all the amounts above, in order not to exceed the hardcap.
707 
708     // Collection of money in BTC will be carried out via one common wallet. The wallet's address will be published
709     // everywhere (in a white paper, on the TokenSale website, on Telegram, on Bitcointalk, in this code, etc.)
710     // Anyone interested can check that the administrator of the smart contract writes down exactly the amount
711     // in ETH (in equivalent for BTC) there. In theory, the ability to bypass a smart contract to accept money in
712     // BTC and not register them in ETH creates a possibility for manipulation by the company. Thanks to
713     // paymentsInOtherCurrency however, this threat is leveled.
714 
715     // Any user can check the amounts in BTC and the variable of the smart contract that accounts for this
716     // (paymentsInOtherCurrency method). Any user can easily check the incoming transactions in a smart contract
717     // on a daily basis. Any hypothetical tricks on the part of the company can be exposed and panic during the TokenSale,
718     // simply pointing out the incompatibility of paymentsInOtherCurrency (ie, the amount of ETH + BTC collection)
719     // and the actual transactions in BTC. The company strictly adheres to the described principles of openness.
720 
721     // The company administrator is required to synchronize paymentsInOtherCurrency every working day (but you
722     // cannot synchronize if there are no new BTC payments). In the case of unforeseen problems, such as
723     // brakes on the Ethereum network, this operation may be difficult. You should only worry if the
724     // administrator does not synchronize the amount for more than 96 hours in a row, and the BTC wallet
725     // receives significant amounts.
726 
727     // This scenario ensures that for the sum of all fees in all currencies this value does not exceed hardcap.
728 
729     // ** QUINTILLIONS ** 10^18 / 1**18 / 1e18
730 
731     // @ Do I have to use the function      no
732     // @ When it is possible to call        during active rounds
733     // @ When it is launched automatically  every day from cryptob2b token software
734     // @ Who can call the function          admins + observer
735     function paymentsInOtherCurrency(uint256 _token, uint256 _value) internal {
736 
737         // **For audit**
738         // BTC Wallet:             38kYRf1Ent74d77H8F4ZJCyngtRTJFPdhj
739         // BCH Wallet:             qpyjy2urvjhwz4emw0hfrlm39gmu3shvngy7aa673l
740         // DASH Wallet:            XrouPiHyXwfB2uajja1RALuAvHaDEUNPw7
741         // LTC Wallet:             MJxPYAeMbvYBoFsoNnF9WwiUqnLSUR8yVc
742         require(rightAndRoles.onlyRoles(msg.sender,18));
743         bool withinPeriod = (now >= startTime && now <= endTime.add(renewal));
744         bool withinCap = _value.add(ethWeiRaised) <= hardCap.add(overLimit);
745         require(withinPeriod && withinCap && isInitialized && !isFinalized);
746         emit PaymentedInOtherCurrency(_token,_value);
747         nonEthWeiRaised = _value;
748         tokenReserved = _token;
749 
750     }
751 
752     function lokedMint(address _beneficiary, uint256 _value, uint256 _freezeTime) internal {
753         if(_freezeTime > 0){
754 
755             uint256 totalBloked = token.freezedTokenOf(_beneficiary).add(_value);
756             uint256 pastDateUnfreeze = token.defrostDate(_beneficiary);
757             uint256 newDateUnfreeze = _freezeTime.add(now);
758             newDateUnfreeze = (pastDateUnfreeze > newDateUnfreeze ) ? pastDateUnfreeze : newDateUnfreeze;
759 
760             token.freezeTokens(_beneficiary,totalBloked,newDateUnfreeze);
761         }
762         token.mint(_beneficiary,_value);
763         totalSaledToken = totalSaledToken.add(_value);
764     }
765 
766 
767     // The function for obtaining smart contract funds in ETH. If all the checks are true, the token is
768     // transferred to the buyer, taking into account the current bonus.
769     function buyTokens(address _beneficiary) public payable {
770         require(_beneficiary != 0x0);
771         require(validPurchase());
772 
773         uint256 weiAmount = msg.value;
774 
775         uint256 ProfitProcent = getProfitPercent();
776 
777         uint256 value;
778         uint256 percent;
779         uint256 freezeTime;
780 
781         (value,
782         percent,
783         freezeTime) = getBonuses(weiAmount);
784 
785         Bonus memory curBonus = Bonus(value,percent,freezeTime);
786 
787         uint256 bonus = curBonus.procent;
788 
789 
790         // --------------------------------------------------------------------------------------------
791         // *** Scenario 1 - select max from all bonuses + check maxAllProfit
792         //uint256 totalProfit = (ProfitProcent < bonus) ? bonus : ProfitProcent;
793         // *** Scenario 2 - sum both bonuses + check maxAllProfit
794         uint256 totalProfit = bonus.add(ProfitProcent);
795         if(isPromo(_beneficiary)){
796             totalProfit = totalProfit.add(10);
797         }
798         // --------------------------------------------------------------------------------------------
799         totalProfit = (totalProfit > maxAllProfit) ? maxAllProfit : totalProfit;
800 
801         // calculate token amount to be created
802         uint256 tokens = weiAmount.mul(rate).mul(totalProfit.add(100)).div(100 ether);
803 
804         // update state
805         ethWeiRaised = ethWeiRaised.add(weiAmount);
806 
807         lokedMint(_beneficiary, tokens, curBonus.freezeTime);
808 
809         emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
810 
811         forwardFunds(_beneficiary);//forwardFunds(msg.sender);
812     }
813 
814     // buyTokens alias
815     function () public payable {
816         buyTokens(msg.sender);
817     }
818 }
819 
820 contract ERC20Basic {
821     function totalSupply() public view returns (uint256);
822     function balanceOf(address who) public view returns (uint256);
823     function transfer(address to, uint256 value) public returns (bool);
824     event Transfer(address indexed from, address indexed to, uint256 value);
825 }
826 
827 library SafeMath {
828     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
829         if (a == 0) {
830             return 0;
831         }
832         uint256 c = a * b;
833         assert(c / a == b);
834         return c;
835     }
836     function div(uint256 a, uint256 b) internal pure returns (uint256) {
837         uint256 c = a / b;
838         return c;
839     }
840     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
841         assert(b <= a);
842         return a - b;
843     }
844     function add(uint256 a, uint256 b) internal pure returns (uint256) {
845         uint256 c = a + b;
846         assert(c >= a);
847         return c;
848     }
849     function minus(uint256 a, uint256 b) internal pure returns (uint256) {
850         if (b>=a) return 0;
851         return a - b;
852     }
853 }
854 
855 contract IFinancialStrategy{
856 
857     enum State { Active, Refunding, Closed }
858     State public state = State.Active;
859 
860     event Deposited(address indexed beneficiary, uint256 weiAmount);
861     event Receive(address indexed beneficiary, uint256 weiAmount);
862     event Refunded(address indexed beneficiary, uint256 weiAmount);
863     event Started();
864     event Closed();
865     event RefundsEnabled();
866     function freeCash() view public returns(uint256);
867     function deposit(address _beneficiary) external payable;
868     function refund(address _investor) external;
869     function setup(uint8 _state, bytes32[] _params) external;
870     function getBeneficiaryCash() external;
871     function getPartnerCash(uint8 _user, address _msgsender) external;
872 }
873 
874 contract IAllocation {
875     function addShare(address _beneficiary, uint256 _proportion, uint256 _percenForFirstPart) external;
876 }
877 
878 contract ICreator{
879     IRightAndRoles public rightAndRoles;
880     function createAllocation(IToken _token, uint256 _unlockPart1, uint256 _unlockPart2) external returns (IAllocation);
881     function createFinancialStrategy() external returns(IFinancialStrategy);
882     function getRightAndRoles() external returns(IRightAndRoles);
883 }