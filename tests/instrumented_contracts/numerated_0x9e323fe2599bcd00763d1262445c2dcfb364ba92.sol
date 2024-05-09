1 // Project: AleHub
2 // v1, 2018-05-24
3 // This code is the property of CryptoB2B.io
4 // Copying in whole or in part is prohibited.
5 // Authors: Ivan Fedorov and Dmitry Borodin
6 // Do you want the same TokenSale platform? www.cryptob2b.io
7 
8 // *.sol in 1 file - https://cryptob2b.io/solidity/alehub/
9 pragma solidity ^0.4.21;
10 
11 contract GuidedByRoles {
12     IRightAndRoles public rightAndRoles;
13     function GuidedByRoles(IRightAndRoles _rightAndRoles) public {
14         rightAndRoles = _rightAndRoles;
15     }
16 }
17 
18 library SafeMath {
19     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20         if (a == 0) {
21             return 0;
22         }
23         uint256 c = a * b;
24         assert(c / a == b);
25         return c;
26     }
27     function div(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a / b;
29         return c;
30     }
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         assert(b <= a);
33         return a - b;
34     }
35     function add(uint256 a, uint256 b) internal pure returns (uint256) {
36         uint256 c = a + b;
37         assert(c >= a);
38         return c;
39     }
40     function minus(uint256 a, uint256 b) internal pure returns (uint256) {
41         if (b>=a) return 0;
42         return a - b;
43     }
44 }
45 
46 contract Crowdsale is GuidedByRoles{
47 // (A1)
48 // The main contract for the sale and management of rounds.
49 // 0000000000000000000000000000000000000000000000000000000000000000
50 
51     uint256 constant USER_UNPAUSE_TOKEN_TIMEOUT =  60 days;
52     uint256 constant FORCED_REFUND_TIMEOUT1     = 400 days;
53     uint256 constant FORCED_REFUND_TIMEOUT2     = 600 days;
54     uint256 constant ROUND_PROLONGATE           =  60 days;
55     uint256 constant BURN_TOKENS_TIME           =  90 days;
56 
57     using SafeMath for uint256;
58 
59     enum TokenSaleType {round1, round2}
60 
61     TokenSaleType public TokenSale = TokenSaleType.round1;
62 
63     ICreator public creator;
64     bool isBegin=false;
65 
66     IToken public token;
67     IAllocation public allocation;
68     IFinancialStrategy public financialStrategy;
69     bool public isFinalized;
70     bool public isInitialized;
71     bool public isPausedCrowdsale;
72     bool public chargeBonuses;
73     bool public canFirstMint=true;
74 
75     struct Bonus {
76         uint256 value;
77         uint256 procent;
78         uint256 freezeTime;
79     }
80 
81     struct Profit {
82         uint256 percent;
83         uint256 duration;
84     }
85 
86     struct Freezed {
87         uint256 value;
88         uint256 dateTo;
89     }
90 
91     Bonus[] public bonuses;
92     Profit[] public profits;
93 
94 
95     uint256 public startTime= 1527206400;
96     uint256 public endTime  = 1529971199;
97     uint256 public renewal;
98 
99     // How many tokens (excluding the bonus) are transferred to the investor in exchange for 1 ETH
100     // **THOUSANDS** 10^18 for human, *10**18 for Solidity, 1e18 for MyEtherWallet (MEW).
101     // Example: if 1ETH = 40.5 Token ==> use 40500 finney
102     uint256 public rate = 2333 ether; // $0.1 (ETH/USD=$500)
103 
104     // ETH/USD rate in US$
105     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: ETH/USD=$1000 ==> use 1000*10**18 (Solidity) or 1000 ether or 1000e18 (MEW)
106     uint256 public exchange  = 700 ether;
107 
108     // If the round does not attain this value before the closing date, the round is recognized as a
109     // failure and investors take the money back (the founders will not interfere in any way).
110     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: softcap=15ETH ==> use 15*10**18 (Solidity) or 15e18 (MEW)
111     uint256 public softCap = 0;
112 
113     // The maximum possible amount of income
114     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: hardcap=123.45ETH ==> use 123450*10**15 (Solidity) or 12345e15 (MEW)
115     uint256 public hardCap = 4285 ether; // $31M (ETH/USD=$500)
116 
117     // If the last payment is slightly higher than the hardcap, then the usual contracts do
118     // not accept it, because it goes beyond the hardcap. However it is more reasonable to accept the
119     // last payment, very slightly raising the hardcap. The value indicates by how many ETH the
120     // last payment can exceed the hardcap to allow it to be paid. Immediately after this payment, the
121     // round closes. The funders should write here a small number, not more than 1% of the CAP.
122     // Can be equal to zero, to cancel.
123     // **QUINTILLIONS** 10^18 / *10**18 / 1e18
124     uint256 public overLimit = 20 ether;
125 
126     // The minimum possible payment from an investor in ETH. Payments below this value will be rejected.
127     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: minPay=0.1ETH ==> use 100*10**15 (Solidity) or 100e15 (MEW)
128     uint256 public minPay = 43 finney;
129 
130     uint256 public maxAllProfit = 40; // max time bonus=20%, max value bonus=10%, maxAll=10%+20%
131 
132     uint256 public ethWeiRaised;
133     uint256 public nonEthWeiRaised;
134     uint256 public weiRound1;
135     uint256 public tokenReserved;
136 
137     uint256 public totalSaledToken;
138 
139     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
140 
141     event Finalized();
142     event Initialized();
143 
144     event PaymentedInOtherCurrency(uint256 token, uint256 value);
145     event ExchangeChanged(uint256 indexed oldExchange, uint256 indexed newExchange);
146 
147     function Crowdsale(ICreator _creator,IToken _token) GuidedByRoles(_creator.getRightAndRoles()) public
148     {
149         creator=_creator;
150         token = _token;
151     }
152 
153     // Setting the current rate ETH/USD         
154 //    function changeExchange(uint256 _ETHUSD) public {
155 //        require(rightAndRoles.onlyRoles(msg.sender,18));
156 //        require(_ETHUSD >= 1 ether);
157 //        emit ExchangeChanged(exchange,_ETHUSD);
158 //        softCap=softCap.mul(exchange).div(_ETHUSD);             // QUINTILLIONS
159 //        hardCap=hardCap.mul(exchange).div(_ETHUSD);             // QUINTILLIONS
160 //        minPay=minPay.mul(exchange).div(_ETHUSD);               // QUINTILLIONS
161 //
162 //        rate=rate.mul(_ETHUSD).div(exchange);                   // QUINTILLIONS
163 //
164 //        for (uint16 i = 0; i < bonuses.length; i++) {
165 //            bonuses[i].value=bonuses[i].value.mul(exchange).div(_ETHUSD);   // QUINTILLIONS
166 //        }
167 //        bytes32[] memory params = new bytes32[](2);
168 //        params[0] = bytes32(exchange);
169 //        params[1] = bytes32(_ETHUSD);
170 //        financialStrategy.setup(5, params);
171 //
172 //        exchange=_ETHUSD;
173 //
174 //    }
175 
176     // Setting of basic parameters, analog of class constructor
177     // @ Do I have to use the function      see your scenario
178     // @ When it is possible to call        before Round 1/2
179     // @ When it is launched automatically  -
180     // @ Who can call the function          admins
181     function begin() public
182     {
183         require(rightAndRoles.onlyRoles(msg.sender,22));
184         if (isBegin) return;
185         isBegin=true;
186 
187         financialStrategy = creator.createFinancialStrategy();
188 
189         token.setUnpausedWallet(rightAndRoles.wallets(1,0), true);
190         token.setUnpausedWallet(rightAndRoles.wallets(3,0), true);
191         token.setUnpausedWallet(rightAndRoles.wallets(4,0), true);
192         token.setUnpausedWallet(rightAndRoles.wallets(5,0), true);
193         token.setUnpausedWallet(rightAndRoles.wallets(6,0), true);
194 
195         bonuses.push(Bonus(1429 finney, 2,0));
196         bonuses.push(Bonus(14286 finney, 5,0));
197         bonuses.push(Bonus(142857 finney, 10,0));
198 
199         profits.push(Profit(25,100 days));
200     }
201 
202 
203 
204     // Issue of tokens for the zero round, it is usually called: private pre-sale (Round 0)
205     // @ Do I have to use the function      may be
206     // @ When it is possible to call        before Round 1/2
207     // @ When it is launched automatically  -
208     // @ Who can call the function          admins
209     function firstMintRound0(uint256 _amount /* QUINTILLIONS! */) public {
210         require(rightAndRoles.onlyRoles(msg.sender,6));
211         require(canFirstMint);
212         begin();
213         token.mint(rightAndRoles.wallets(3,0),_amount);
214     }
215 
216     // info
217     function totalSupply() external view returns (uint256){
218         return token.totalSupply();
219     }
220 
221     // Returns the name of the current round in plain text. Constant.
222     function getTokenSaleType() external view returns(string){
223         return (TokenSale == TokenSaleType.round1)?'round1':'round2';
224     }
225 
226     // Transfers the funds of the investor to the contract of return of funds. Internal.
227     function forwardFunds(address _beneficiary) internal {
228         financialStrategy.deposit.value(msg.value)(_beneficiary);
229     }
230 
231     // Check for the possibility of buying tokens. Inside. Constant.
232     function validPurchase() internal view returns (bool) {
233 
234         // The round started and did not end
235         bool withinPeriod = (now > startTime && now < endTime.add(renewal));
236 
237         // Rate is greater than or equal to the minimum
238         bool nonZeroPurchase = msg.value >= minPay;
239 
240         // hardCap is not reached, and in the event of a transaction, it will not be exceeded by more than OverLimit
241         bool withinCap = msg.value <= hardCap.sub(weiRaised()).add(overLimit);
242 
243         // round is initialized and no "Pause of trading" is set
244         return withinPeriod && nonZeroPurchase && withinCap && isInitialized && !isFinalized && !isPausedCrowdsale;
245     }
246 
247     // Check for the ability to finalize the round. Constant.
248     function hasEnded() public view returns (bool) {
249         bool isAdmin = rightAndRoles.onlyRoles(msg.sender,6);
250 
251         bool timeReached = now > endTime.add(renewal);
252 
253         bool capReached = weiRaised() >= hardCap;
254 
255         return (timeReached || capReached || (isAdmin && goalReached())) && isInitialized && !isFinalized;
256     }
257 
258     // Finalize. Only available to the Manager and the Beneficiary. If the round failed, then
259     // anyone can call the finalization to unlock the return of funds to investors
260     // You must call a function to finalize each round (after the Round1 & after the Round2)
261     // @ Do I have to use the function      yes
262     // @ When it is possible to call        after end of Round1 & Round2
263     // @ When it is launched automatically  no
264     // @ Who can call the function          admins or anybody (if round is failed)
265     function finalize() public {
266 //        bool isAdmin = rightAndRoles.onlyRoles(msg.sender,6);
267 //        require(isAdmin|| !goalReached());
268 //        require(!isFinalized && isInitialized);
269 //        require(hasEnded() || (isAdmin && goalReached()));
270         require(hasEnded());
271 
272         isFinalized = true;
273         finalization();
274         emit Finalized();
275     }
276 
277     // The logic of finalization. Internal
278     // @ Do I have to use the function      no
279     // @ When it is possible to call        -
280     // @ When it is launched automatically  after end of round
281     // @ Who can call the function          -
282     function finalization() internal {
283         bytes32[] memory params = new bytes32[](0);
284         // If the goal of the achievement
285         if (goalReached()) {
286 
287             financialStrategy.setup(1,params);//Для контракта Buz деньги не возвращает.
288 
289             // if there is anything to give
290             if (tokenReserved > 0) {
291 
292                 token.mint(rightAndRoles.wallets(3,0),tokenReserved);
293 
294                 // Reset the counter
295                 tokenReserved = 0;
296             }
297 
298             // If the finalization is Round 1
299             if (TokenSale == TokenSaleType.round1) {
300 
301                 // Reset settings
302                 isInitialized = false;
303                 isFinalized = false;
304                 if(financialStrategy.freeCash() == 0){
305                     rightAndRoles.setManagerPowerful(true);
306                 }
307 
308                 // Switch to the second round (to Round2)
309                 TokenSale = TokenSaleType.round2;
310 
311                 // Reset the collection counter
312                 weiRound1 = weiRaised();
313                 ethWeiRaised = 0;
314                 nonEthWeiRaised = 0;
315 
316 
317 
318             }
319             else // If the second round is finalized
320             {
321 
322                 // Permission to collect tokens to those who can pick them up
323                 chargeBonuses = true;
324 
325                 totalSaledToken = token.totalSupply();
326                 //partners = true;
327 
328             }
329 
330         }
331         else // If they failed round
332         {
333             financialStrategy.setup(3,params);
334         }
335     }
336 
337     // The Manager freezes the tokens for the Team.
338     // You must call a function to finalize Round 2 (only after the Round2)
339     // @ Do I have to use the function      yes
340     // @ When it is possible to call        Round2
341     // @ When it is launched automatically  -
342     // @ Who can call the function          admins
343     function finalize2() public {
344         require(rightAndRoles.onlyRoles(msg.sender,6));
345         require(chargeBonuses);
346         chargeBonuses = false;
347 
348         allocation = creator.createAllocation(token, now + 1 years /* stage N1 */,0/* not need*/);
349         token.setUnpausedWallet(allocation, true);
350         // Team = %, Founders = %, Fund = %    TOTAL = %
351         allocation.addShare(rightAndRoles.wallets(7,0),100,100); // all 100% - first year
352         //allocation.addShare(wallets[uint8(Roles.founders)],  10,  50); // only 50% - first year, stage N1  (and +50 for stage N2)
353 
354         // 2% - bounty wallet
355         token.mint(rightAndRoles.wallets(5,0), totalSaledToken.mul(2).div(77));
356 
357         // 10% - company
358         token.mint(rightAndRoles.wallets(6,0), totalSaledToken.mul(10).div(77));
359 
360         // 13% - team
361         token.mint(allocation, totalSaledToken.mul(11).div(77));
362     }
363 
364 
365 
366     // Initializing the round. Available to the manager. After calling the function,
367     // the Manager loses all rights: Manager can not change the settings (setup), change
368     // wallets, prevent the beginning of the round, etc. You must call a function after setup
369     // for the initial round (before the Round1 and before the Round2)
370     // @ Do I have to use the function      yes
371     // @ When it is possible to call        before each round
372     // @ When it is launched automatically  -
373     // @ Who can call the function          admins
374     function initialize() public {
375         require(rightAndRoles.onlyRoles(msg.sender,6));
376         // If not yet initialized
377         require(!isInitialized);
378         begin();
379 
380 
381         // And the specified start time has not yet come
382         // If initialization return an error, check the start date!
383         require(now <= startTime);
384 
385         initialization();
386 
387         emit Initialized();
388 
389         renewal = 0;
390 
391         isInitialized = true;
392 
393         canFirstMint = false;
394     }
395 
396     function initialization() internal {
397         bytes32[] memory params = new bytes32[](0);
398         rightAndRoles.setManagerPowerful(false);
399         if (financialStrategy.state() != IFinancialStrategy.State.Active){
400             financialStrategy.setup(2,params);
401         }
402     }
403 
404     // 
405     // @ Do I have to use the function      
406     // @ When it is possible to call        
407     // @ When it is launched automatically  
408     // @ Who can call the function          
409     function getPartnerCash(uint8 _user, bool _calc) external {
410         if(_calc)
411             calcFin();
412         financialStrategy.getPartnerCash(_user, msg.sender);
413     }
414 
415     function getBeneficiaryCash(bool _calc) public {
416         require(rightAndRoles.onlyRoles(msg.sender,22));
417         if(_calc)
418             calcFin();
419         financialStrategy.getBeneficiaryCash();
420         if(!isInitialized && financialStrategy.freeCash() == 0)
421             rightAndRoles.setManagerPowerful(true);
422     }
423 
424     function claimRefund() external{
425         financialStrategy.refund(msg.sender);
426     }
427 
428     function calcFin() public {
429         bytes32[] memory params = new bytes32[](2);
430         params[0] = bytes32(weiTotalRaised());
431         params[1] = bytes32(msg.sender);
432         financialStrategy.setup(4,params);
433     }
434 
435     function calcAndGet() public {
436         require(rightAndRoles.onlyRoles(msg.sender,22));
437         getBeneficiaryCash(true);
438         for (uint8 i=0; i<0; i++) { // <-- TODO check financialStrategy.wallets.length
439             financialStrategy.getPartnerCash(i, msg.sender);
440         }
441     }
442 
443     // We check whether we collected the necessary minimum funds. Constant.
444     function goalReached() public view returns (bool) {
445         return weiRaised() >= softCap;
446     }
447 
448 
449     // Customize. The arguments are described in the constructor above.
450     // @ Do I have to use the function      yes
451     // @ When it is possible to call        before each rond
452     // @ When it is launched automatically  -
453     // @ Who can call the function          admins
454     function setup(uint256 _startTime, uint256 _endTime, uint256 _softCap, uint256 _hardCap,
455         uint256 _rate, uint256 _exchange,
456         uint256 _maxAllProfit, uint256 _overLimit, uint256 _minPay,
457         uint256[] _durationTB , uint256[] _percentTB, uint256[] _valueVB, uint256[] _percentVB, uint256[] _freezeTimeVB) public
458     {
459 
460         require(rightAndRoles.onlyRoles(msg.sender,6));
461         require(!isInitialized);
462 
463         begin();
464 
465         // Date and time are correct
466         require(now <= _startTime);
467         require(_startTime < _endTime);
468 
469         startTime = _startTime;
470         endTime = _endTime;
471 
472         // The parameters are correct
473         require(_softCap <= _hardCap);
474 
475         softCap = _softCap;
476         hardCap = _hardCap;
477 
478         require(_rate > 0);
479 
480         rate = _rate;
481 
482         overLimit = _overLimit;
483         minPay = _minPay;
484         exchange = _exchange;
485 
486         maxAllProfit = _maxAllProfit;
487 
488         require(_valueVB.length == _percentVB.length && _valueVB.length == _freezeTimeVB.length);
489         bonuses.length = _valueVB.length;
490         for(uint256 i = 0; i < _valueVB.length; i++){
491             bonuses[i] = Bonus(_valueVB[i],_percentVB[i],_freezeTimeVB[i]);
492         }
493 
494         require(_percentTB.length == _durationTB.length);
495         profits.length = _percentTB.length;
496         for( i = 0; i < _percentTB.length; i++){
497             profits[i] = Profit(_percentTB[i],_durationTB[i]);
498         }
499 
500     }
501 
502     // Collected funds for the current round. Constant.
503     function weiRaised() public constant returns(uint256){
504         return ethWeiRaised.add(nonEthWeiRaised);
505     }
506 
507     // Returns the amount of fees for both phases. Constant.
508     function weiTotalRaised() public constant returns(uint256){
509         return weiRound1.add(weiRaised());
510     }
511 
512     // Returns the percentage of the bonus on the current date. Constant.
513     function getProfitPercent() public constant returns (uint256){
514         return getProfitPercentForData(now);
515     }
516 
517     // Returns the percentage of the bonus on the given date. Constant.
518     function getProfitPercentForData(uint256 _timeNow) public constant returns (uint256){
519         uint256 allDuration;
520         for(uint8 i = 0; i < profits.length; i++){
521             allDuration = allDuration.add(profits[i].duration);
522             if(_timeNow < startTime.add(allDuration)){
523                 return profits[i].percent;
524             }
525         }
526         return 0;
527     }
528 
529     function getBonuses(uint256 _value) public constant returns (uint256,uint256,uint256){
530         if(bonuses.length == 0 || bonuses[0].value > _value){
531             return (0,0,0);
532         }
533         uint16 i = 1;
534         for(i; i < bonuses.length; i++){
535             if(bonuses[i].value > _value){
536                 break;
537             }
538         }
539         return (bonuses[i-1].value,bonuses[i-1].procent,bonuses[i-1].freezeTime);
540     }
541 
542     // The ability to quickly check Round1 (only for Round1, only 1 time). Completes the Round1 by
543     // transferring the specified number of tokens to the Accountant's wallet. Available to the Manager.
544     // Use only if this is provided by the script and white paper. In the normal scenario, it
545     // does not call and the funds are raised normally. We recommend that you delete this
546     // function entirely, so as not to confuse the auditors. Initialize & Finalize not needed.
547     // ** QUINTILIONS **  10^18 / 1**18 / 1e18
548     // @ Do I have to use the function      no, see your scenario
549     // @ When it is possible to call        after Round0 and before Round2
550     // @ When it is launched automatically  -
551     // @ Who can call the function          admins
552     //    function fastTokenSale(uint256 _totalSupply) external {
553     //      onlyAdmin(false);
554     //        require(TokenSale == TokenSaleType.round1 && !isInitialized);
555     //        token.mint(wallets[uint8(Roles.accountant)], _totalSupply);
556     //        TokenSale = TokenSaleType.round2;
557     //    }
558 
559 
560     // Remove the "Pause of exchange". Available to the manager at any time. If the
561     // manager refuses to remove the pause, then 30-120 days after the successful
562     // completion of the TokenSale, anyone can remove a pause and allow the exchange to continue.
563     // The manager does not interfere and will not be able to delay the term.
564     // He can only cancel the pause before the appointed time.
565     // @ Do I have to use the function      YES YES YES
566     // @ When it is possible to call        after end of ICO
567     // @ When it is launched automatically  -
568     // @ Who can call the function          admins or anybody
569     function tokenUnpause() external {
570 
571         require(rightAndRoles.onlyRoles(msg.sender,2)
572         || (now > endTime.add(renewal).add(USER_UNPAUSE_TOKEN_TIMEOUT) && TokenSale == TokenSaleType.round2 && isFinalized && goalReached()));
573         token.setPause(false);
574     }
575 
576     // Enable the "Pause of exchange". Available to the manager until the TokenSale is completed.
577     // The manager cannot turn on the pause, for example, 3 years after the end of the TokenSale.
578     // @ Do I have to use the function      no
579     // @ When it is possible to call        while Round2 not ended
580     // @ When it is launched automatically  before any rounds
581     // @ Who can call the function          admins
582     function tokenPause() public {
583         require(rightAndRoles.onlyRoles(msg.sender,6));
584         require(!isFinalized);
585         token.setPause(true);
586     }
587 
588     // Pause of sale. Available to the manager.
589     // @ Do I have to use the function      no
590     // @ When it is possible to call        during active rounds
591     // @ When it is launched automatically  -
592     // @ Who can call the function          admins
593     function setCrowdsalePause(bool mode) public {
594         require(rightAndRoles.onlyRoles(msg.sender,6));
595         isPausedCrowdsale = mode;
596     }
597 
598     // For example - After 5 years of the project's existence, all of us suddenly decided collectively
599     // (company + investors) that it would be more profitable for everyone to switch to another smart
600     // contract responsible for tokens. The company then prepares a new token, investors
601     // disassemble, study, discuss, etc. After a general agreement, the manager allows any investor:
602     //      - to burn the tokens of the previous contract
603     //      - generate new tokens for a new contract
604     // It is understood that after a general solution through this function all investors
605     // will collectively (and voluntarily) move to a new token.
606     // @ Do I have to use the function      no
607     // @ When it is possible to call        only after ICO!
608     // @ When it is launched automatically  -
609     // @ Who can call the function          admins
610     function moveTokens(address _migrationAgent) public {
611         require(rightAndRoles.onlyRoles(msg.sender,6));
612         token.setMigrationAgent(_migrationAgent);
613     }
614 
615     // @ Do I have to use the function      no
616     // @ When it is possible to call        only after ICO!
617     // @ When it is launched automatically  -
618     // @ Who can call the function          admins
619     function migrateAll(address[] _holders) public {
620         require(rightAndRoles.onlyRoles(msg.sender,6));
621         token.migrateAll(_holders);
622     }
623 
624 
625     // The beneficiary at any time can take rights in all roles and prescribe his wallet in all the
626     // rollers. Thus, he will become the recipient of tokens for the role of Accountant,
627     // Team, etc. Works at any time.
628     // @ Do I have to use the function      no
629     // @ When it is possible to call        any time
630     // @ When it is launched automatically  -
631     // @ Who can call the function          only Beneficiary
632 //    function resetAllWallets() external{
633 //        address _beneficiary = wallets[uint8(Roles.beneficiary)];
634 //        require(msg.sender == _beneficiary);
635 //        for(uint8 i = 0; i < wallets.length; i++){
636 //            wallets[i] = _beneficiary;
637 //        }
638 //        token.setUnpausedWallet(_beneficiary, true);
639 //    }
640 
641 
642     // Burn the investor tokens, if provided by the ICO scenario. Limited time available - BURN_TOKENS_TIME
643     // For people who ignore the KYC/AML procedure during 30 days after payment: money back and burning tokens.
644     // ***CHECK***SCENARIO***
645     // @ Do I have to use the function      no
646     // @ When it is possible to call        any time
647     // @ When it is launched automatically  -
648     // @ Who can call the function          admin
649     function massBurnTokens(address[] _beneficiary, uint256[] _value) external {
650         require(rightAndRoles.onlyRoles(msg.sender,6));
651         require(endTime.add(renewal).add(BURN_TOKENS_TIME) > now);
652         require(_beneficiary.length == _value.length);
653         for(uint16 i; i<_beneficiary.length; i++) {
654             token.burn(_beneficiary[i],_value[i]);
655         }
656     }
657 
658     // Extend the round time, if provided by the script. Extend the round only for
659     // a limited number of days - ROUND_PROLONGATE
660     // ***CHECK***SCENARIO***
661     // @ Do I have to use the function      no
662     // @ When it is possible to call        during active round
663     // @ When it is launched automatically  -
664     // @ Who can call the function          admins
665     function prolong(uint256 _duration) external {
666         require(rightAndRoles.onlyRoles(msg.sender,6));
667         require(now > startTime && now < endTime.add(renewal) && isInitialized && !isFinalized);
668         renewal = renewal.add(_duration);
669         require(renewal <= ROUND_PROLONGATE);
670 
671     }
672     // If a little more than a year has elapsed (Round2 start date + 400 days), a smart contract
673     // will allow you to send all the money to the Beneficiary, if any money is present. This is
674     // possible if you mistakenly launch the Round2 for 30 years (not 30 days), investors will transfer
675     // money there and you will not be able to pick them up within a reasonable time. It is also
676     // possible that in our checked script someone will make unforeseen mistakes, spoiling the
677     // finalization. Without finalization, money cannot be returned. This is a rescue option to
678     // get around this problem, but available only after a year (400 days).
679 
680     // Another reason - the TokenSale was a failure, but not all ETH investors took their money during the year after.
681     // Some investors may have lost a wallet key, for example.
682 
683     // The method works equally with the Round1 and Round2. When the Round1 starts, the time for unlocking
684     // the distructVault begins. If the TokenSale is then started, then the term starts anew from the first day of the TokenSale.
685 
686     // Next, act independently, in accordance with obligations to investors.
687 
688     // Within 400 days (FORCED_REFUND_TIMEOUT1) of the start of the Round, if it fails only investors can take money. After
689     // the deadline this can also include the company as well as investors, depending on who is the first to use the method.
690     // @ Do I have to use the function      no
691     // @ When it is possible to call        -
692     // @ When it is launched automatically  -
693     // @ Who can call the function          beneficiary & manager
694     function distructVault() public {
695         bytes32[] memory params = new bytes32[](1);
696         params[0] = bytes32(msg.sender);
697         if (rightAndRoles.onlyRoles(msg.sender,4) && (now > startTime.add(FORCED_REFUND_TIMEOUT1))) {
698 
699             financialStrategy.setup(0,params);
700         }
701         if (rightAndRoles.onlyRoles(msg.sender,2) && (now > startTime.add(FORCED_REFUND_TIMEOUT2))) {
702             financialStrategy.setup(0,params);
703         }
704     }
705 
706 
707     // We accept payments other than Ethereum (ETH) and other currencies, for example, Bitcoin (BTC).
708     // Perhaps other types of cryptocurrency - see the original terms in the white paper and on the TokenSale website.
709 
710     // We release tokens on Ethereum. During the Round1 and Round2 with a smart contract, you directly transfer
711     // the tokens there and immediately, with the same transaction, receive tokens in your wallet.
712 
713     // When paying in any other currency, for example in BTC, we accept your money via one common wallet.
714     // Our manager fixes the amount received for the bitcoin wallet and calls the method of the smart
715     // contract paymentsInOtherCurrency to inform him how much foreign currency has been received - on a daily basis.
716     // The smart contract pins the number of accepted ETH directly and the number of BTC. Smart contract
717     // monitors softcap and hardcap, so as not to go beyond this framework.
718 
719     // In theory, it is possible that when approaching hardcap, we will receive a transfer (one or several
720     // transfers) to the wallet of BTC, that together with previously received money will exceed the hardcap in total.
721     // In this case, we will refund all the amounts above, in order not to exceed the hardcap.
722 
723     // Collection of money in BTC will be carried out via one common wallet. The wallet's address will be published
724     // everywhere (in a white paper, on the TokenSale website, on Telegram, on Bitcointalk, in this code, etc.)
725     // Anyone interested can check that the administrator of the smart contract writes down exactly the amount
726     // in ETH (in equivalent for BTC) there. In theory, the ability to bypass a smart contract to accept money in
727     // BTC and not register them in ETH creates a possibility for manipulation by the company. Thanks to
728     // paymentsInOtherCurrency however, this threat is leveled.
729 
730     // Any user can check the amounts in BTC and the variable of the smart contract that accounts for this
731     // (paymentsInOtherCurrency method). Any user can easily check the incoming transactions in a smart contract
732     // on a daily basis. Any hypothetical tricks on the part of the company can be exposed and panic during the TokenSale,
733     // simply pointing out the incompatibility of paymentsInOtherCurrency (ie, the amount of ETH + BTC collection)
734     // and the actual transactions in BTC. The company strictly adheres to the described principles of openness.
735 
736     // The company administrator is required to synchronize paymentsInOtherCurrency every working day (but you
737     // cannot synchronize if there are no new BTC payments). In the case of unforeseen problems, such as
738     // brakes on the Ethereum network, this operation may be difficult. You should only worry if the
739     // administrator does not synchronize the amount for more than 96 hours in a row, and the BTC wallet
740     // receives significant amounts.
741 
742     // This scenario ensures that for the sum of all fees in all currencies this value does not exceed hardcap.
743 
744     // ** QUINTILLIONS ** 10^18 / 1**18 / 1e18
745 
746     // @ Do I have to use the function      no
747     // @ When it is possible to call        during active rounds
748     // @ When it is launched automatically  every day from cryptob2b token software
749     // @ Who can call the function          admins + observer
750     function paymentsInOtherCurrency(uint256 _token, uint256 _value) public {
751 
752         // **For audit**
753         // BTC Wallet:             1D7qaRN6keGJKb5LracZYQEgCBaryZxVaE
754         // BCH Wallet:             1CDRdTwvEyZD7qjiGUYxZQSf8n91q95xHU
755         // DASH Wallet:            XnjajDvQq1C7z2o4EFevRhejc6kRmX1NUp
756         // LTC Wallet:             LhHkiwVfoYEviYiLXP5pRK2S1QX5eGrotA
757         require(rightAndRoles.onlyRoles(msg.sender,18));
758         //onlyAdmin(true);
759         bool withinPeriod = (now >= startTime && now <= endTime.add(renewal));
760         bool withinCap = _value.add(ethWeiRaised) <= hardCap.add(overLimit);
761         require(withinPeriod && withinCap && isInitialized && !isFinalized);
762         emit PaymentedInOtherCurrency(_token,_value);
763         nonEthWeiRaised = _value;
764         tokenReserved = _token;
765 
766     }
767 
768     function lokedMint(address _beneficiary, uint256 _value, uint256 _freezeTime) internal {
769         if(_freezeTime > 0){
770 
771             uint256 totalBloked = token.freezedTokenOf(_beneficiary).add(_value);
772             uint256 pastDateUnfreeze = token.defrostDate(_beneficiary);
773             uint256 newDateUnfreeze = _freezeTime.add(now);
774             newDateUnfreeze = (pastDateUnfreeze > newDateUnfreeze ) ? pastDateUnfreeze : newDateUnfreeze;
775 
776             token.freezeTokens(_beneficiary,totalBloked,newDateUnfreeze);
777         }
778         token.mint(_beneficiary,_value);
779     }
780 
781 
782     // The function for obtaining smart contract funds in ETH. If all the checks are true, the token is
783     // transferred to the buyer, taking into account the current bonus.
784     function buyTokens(address _beneficiary) public payable {
785         require(_beneficiary != 0x0);
786         require(validPurchase());
787 
788         uint256 weiAmount = msg.value;
789 
790         uint256 ProfitProcent = getProfitPercent();
791 
792         uint256 value;
793         uint256 percent;
794         uint256 freezeTime;
795 
796         (value,
797         percent,
798         freezeTime) = getBonuses(weiAmount);
799 
800         Bonus memory curBonus = Bonus(value,percent,freezeTime);
801 
802         uint256 bonus = curBonus.procent;
803 
804         // --------------------------------------------------------------------------------------------
805         // *** Scenario 1 - select max from all bonuses + check maxAllProfit
806         //uint256 totalProfit = (ProfitProcent < bonus) ? bonus : ProfitProcent;
807         // *** Scenario 2 - sum both bonuses + check maxAllProfit
808         uint256 totalProfit = bonus.add(ProfitProcent);
809         // --------------------------------------------------------------------------------------------
810         totalProfit = (totalProfit > maxAllProfit) ? maxAllProfit : totalProfit;
811 
812         // calculate token amount to be created
813         uint256 tokens = weiAmount.mul(rate).mul(totalProfit.add(100)).div(100 ether);
814 
815         // update state
816         ethWeiRaised = ethWeiRaised.add(weiAmount);
817 
818         lokedMint(_beneficiary, tokens, curBonus.freezeTime);
819 
820         emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
821 
822         forwardFunds(_beneficiary);//forwardFunds(msg.sender);
823     }
824 
825     // buyTokens alias
826     function () public payable {
827         buyTokens(msg.sender);
828     }
829 }
830 
831 contract ICreator{
832     function createAllocation(IToken _token, uint256 _unlockPart1, uint256 _unlockPart2) external returns (IAllocation);
833     function createFinancialStrategy() external returns(IFinancialStrategy);
834     function getRightAndRoles() external returns(IRightAndRoles);
835 }
836 
837 contract IToken{
838     function setUnpausedWallet(address _wallet, bool mode) public;
839     function mint(address _to, uint256 _amount) public returns (bool);
840     function totalSupply() public view returns (uint256);
841     function setPause(bool mode) public;
842     function setMigrationAgent(address _migrationAgent) public;
843     function migrateAll(address[] _holders) public;
844     function burn(address _beneficiary, uint256 _value) public;
845     function freezedTokenOf(address _beneficiary) public view returns (uint256 amount);
846     function defrostDate(address _beneficiary) public view returns (uint256 Date);
847     function freezeTokens(address _beneficiary, uint256 _amount, uint256 _when) public;
848 }
849 
850 contract IFinancialStrategy{
851 
852     enum State { Active, Refunding, Closed }
853     State public state = State.Active;
854 
855     event Deposited(address indexed beneficiary, uint256 weiAmount);
856     event Receive(address indexed beneficiary, uint256 weiAmount);
857     event Refunded(address indexed beneficiary, uint256 weiAmount);
858     event Started();
859     event Closed();
860     event RefundsEnabled();
861     function freeCash() view public returns(uint256);
862     function deposit(address _beneficiary) external payable;
863     function refund(address _investor) external;
864     function setup(uint8 _state, bytes32[] _params) external;
865     function getBeneficiaryCash() external;
866     function getPartnerCash(uint8 _user, address _msgsender) external;
867 }
868 
869 contract IAllocation {
870     function addShare(address _beneficiary, uint256 _proportion, uint256 _percenForFirstPart) external;
871 }
872 
873 contract IRightAndRoles {
874     address[][] public wallets;
875     mapping(address => uint16) public roles;
876 
877     event WalletChanged(address indexed newWallet, address indexed oldWallet, uint8 indexed role);
878     event CloneChanged(address indexed wallet, uint8 indexed role, bool indexed mod);
879 
880     function changeWallet(address _wallet, uint8 _role) external;
881     function setManagerPowerful(bool _mode) external;
882     function onlyRoles(address _sender, uint16 _roleMask) view external returns(bool);
883 }