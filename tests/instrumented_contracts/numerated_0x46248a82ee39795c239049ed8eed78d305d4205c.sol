1 pragma solidity ^0.4.24;
2 
3 contract AcceptsExchange {
4     Exchange public tokenContract;
5 
6     constructor(address _tokenContract) public {
7         tokenContract = Exchange(_tokenContract);
8     }
9 
10     modifier onlyTokenContract {
11         require(msg.sender == address(tokenContract));
12         _;
13     }
14 
15     /**
16     * @dev Standard ERC677 function that will handle incoming token transfers.
17     *
18     * @param _from  Token sender address.
19     * @param _value Amount of tokens.
20     * @param _data  Transaction metadata.
21     */
22     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
23 }
24 
25 
26 contract Exchange {
27     /*=================================
28     =            MODIFIERS            =
29     =================================*/
30     // only people with tokens
31     modifier onlyBagholders() {
32         require(myTokens() > 0);
33         _;
34     }
35 
36     // only people with profits
37     modifier onlyStronghands() {
38         require(myDividends(true) > 0);
39         _;
40     }
41 
42     // only human
43     modifier notContract() {
44         require (msg.sender == tx.origin);
45         _;
46     }
47 
48     // maximum of 100 vips allowed for private fund raising event in china
49     modifier maxAmbassadors() {
50         require(totalAmbassadors < 100);
51         _;
52     }
53 
54     // remove ambassadors who didn't make a minimum of 0.1 eth deposit after 6 hours
55     modifier removeAmbassadorCriteria(address _existingAmbassador) {
56         require(ambassadorAccumulatedQuota_[_existingAmbassador] < 0.1 ether && ambassadorDepositTime_[_existingAmbassador] + 6 hours < now);
57         _;
58     }
59 
60     uint TRANSFER_SELL_TIME = 1541952000;
61 
62     // only can transfer 24 hours after launch time
63     // admin can only transfer and withdraw dividends. admin cannot sell tokens before launch time
64     // well, I have to transfer tokens to promoters
65     modifier isActivated(){
66         require(now >= TRANSFER_SELL_TIME || administrators[msg.sender]);
67         _;
68     }
69 
70     // only can sell 24 hours after launch time
71     modifier isSellActivated(){
72         require(now >= TRANSFER_SELL_TIME);
73         _;
74     }
75 
76     // administrators can:
77     // -> change the name of the contract
78     // -> change the name of the token
79     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
80     // they CANNOT:
81     // -> take funds
82     // -> disable withdrawals
83     // -> kill the contract
84     // -> change the price of tokens
85     modifier onlyAdministrator(){
86         address _customerAddress = msg.sender;
87         require(administrators[_customerAddress]);
88         _;
89     }
90 
91     uint ACTIVATION_TIME = 1541865600;
92 
93     // ensures that the first tokens in the contract will be equally distributed
94     // meaning, no divine dump will be ever possible
95     // result: healthy longevity.
96     modifier antiEarlyWhale(uint256 _amountOfEthereum, bool _isReinvest){
97 
98         if (now >= ACTIVATION_TIME) {
99             onlyAmbassadors = false;
100         }
101 
102         // are we still in the vulnerable phase?
103         // if so, enact anti early whale protocol
104         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
105             require(
106                 // is the customer in the ambassador list?
107                 ambassadors_[msg.sender] == true &&
108 
109                 // does the customer purchase exceed the max ambassador quota?
110                 (ambassadorAccumulatedQuota_[msg.sender] + _amountOfEthereum) <= ambassadorMaxPurchase_ &&
111 
112                 // did the customer deposit a minimum of 0.1 eth for the first time?
113                 // existing customer can buy again and reinvest
114                 (ambassadorAccumulatedQuota_[msg.sender] >= 0.1 ether || _amountOfEthereum >= 0.1 ether || _isReinvest)
115             );
116 
117             // updated the accumulated quota and deposit time
118             ambassadorAccumulatedQuota_[msg.sender] = SafeMath.add(ambassadorAccumulatedQuota_[msg.sender], _amountOfEthereum);
119             ambassadorDepositTime_[msg.sender] = now;
120 
121             // execute
122             _;
123         } else {
124             // in case the ether count drops low, the ambassador phase won't reinitiate
125             onlyAmbassadors = false;
126             _;
127         }
128 
129     }
130 
131     /*==============================
132     =            EVENTS            =
133     ==============================*/
134     event onTokenPurchase(
135         address indexed customerAddress,
136         uint256 incomingEthereum,
137         uint256 tokensMinted,
138         address indexed referredBy,
139         bool isReinvest,
140         uint timestamp,
141         uint256 price
142     );
143 
144     event onTokenSell(
145         address indexed customerAddress,
146         uint256 tokensBurned,
147         uint256 ethereumEarned,
148         uint timestamp,
149         uint256 price
150     );
151 
152     event onReinvestment(
153         address indexed customerAddress,
154         uint256 ethereumReinvested,
155         uint256 tokensMinted
156     );
157 
158     event onWithdraw(
159         address indexed customerAddress,
160         uint256 ethereumWithdrawn,
161         uint256 estimateTokens,
162         bool isTransfer
163     );
164 
165     // ERC20
166     event Transfer(
167         address indexed from,
168         address indexed to,
169         uint256 tokens
170     );
171 
172 
173     /*=====================================
174     =            CONFIGURABLES            =
175     =====================================*/
176     string public name = "EXCHANGE";
177     string public symbol = "SHARES";
178     uint8 constant public decimals = 18;
179 
180     uint8 constant internal entryFee_ = 10; // 10% dividend fee on each buy
181     uint8 constant internal startExitFee_ = 40; // 40 % dividends for token selling
182     uint8 constant internal finalExitFee_ = 10; // 10% dividends for token selling after step
183     uint8 constant internal fundFee_ = 5; // 5% to fund third party games
184     uint256 constant internal exitFeeFallDuration_ = 30 days; //Exit fee falls over period of 30 days
185 
186     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
187     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
188     uint256 constant internal magnitude = 2**64;
189 
190     // Address to send the 5% Fee
191     address public giveEthFundAddress = 0x0;
192     bool public finalizedEthFundAddress = false;
193     uint256 public totalEthFundReceived; // total ETH charity received from this contract
194     uint256 public totalEthFundCollected; // total ETH charity collected in this contract
195 
196     // proof of stake (defaults at 100 tokens)
197     uint256 public stakingRequirement = 25e18;
198 
199     // vip program for private fund raising event in China
200     uint public totalAmbassadors = 0;
201     mapping(address => bool) internal ambassadors_;
202     uint256 constant internal ambassadorMaxPurchase_ = 2.5 ether;
203     uint256 constant internal ambassadorQuota_ = 250 ether;
204 
205    /*================================
206     =            DATASETS            =
207     ================================*/
208     // amount of shares for each address (scaled number)
209     mapping(address => uint256) internal tokenBalanceLedger_;
210     mapping(address => uint256) internal referralBalance_;
211     mapping(address => int256) internal payoutsTo_;
212     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
213     mapping(address => uint256) internal ambassadorDepositTime_;
214     uint256 internal tokenSupply_ = 0;
215     uint256 internal profitPerShare_;
216 
217     // administrator list (see above on what they can do)
218     mapping(address => bool) public administrators;
219 
220     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
221     bool public onlyAmbassadors = true;
222 
223     // To whitelist game contracts on the platform
224     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept the exchanges tokens
225 
226     /*=======================================
227     =            PUBLIC FUNCTIONS            =
228     =======================================*/
229     /*
230     * -- APPLICATION ENTRY POINTS --
231     */
232     constructor()
233         public
234     {
235         // add administrators here
236         administrators[0x3db1e274bf36824cf655beddb92a90c04906e04b] = true;
237     }
238 
239     /**
240      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
241      */
242     function buy(address _referredBy)
243         public
244         payable
245         returns(uint256)
246     {
247         require(tx.gasprice <= 0.05 szabo);
248         purchaseTokens(msg.value, _referredBy, false);
249     }
250 
251     /**
252      * Fallback function to handle ethereum that was send straight to the contract
253      * Unfortunately we cannot use a referral address this way.
254      */
255     function()
256         payable
257         public
258     {
259         require(tx.gasprice <= 0.05 szabo);
260         purchaseTokens(msg.value, 0x0, false);
261     }
262 
263     function updateFundAddress(address _newAddress)
264         onlyAdministrator()
265         public
266     {
267         require(finalizedEthFundAddress == false);
268         giveEthFundAddress = _newAddress;
269     }
270 
271     function finalizeFundAddress(address _finalAddress)
272         onlyAdministrator()
273         public
274     {
275         require(finalizedEthFundAddress == false);
276         giveEthFundAddress = _finalAddress;
277         finalizedEthFundAddress = true;
278     }
279 
280     function payFund() payable onlyAdministrator() public {
281         uint256 ethToPay = SafeMath.sub(totalEthFundCollected, totalEthFundReceived);
282         require(ethToPay > 0);
283         totalEthFundReceived = SafeMath.add(totalEthFundReceived, ethToPay);
284         if(!giveEthFundAddress.call.value(ethToPay).gas(400000)()) {
285           totalEthFundReceived = SafeMath.sub(totalEthFundReceived, ethToPay);
286         }
287     }
288 
289     /**
290      * Converts all of caller's dividends to tokens.
291      */
292     function reinvest()
293         onlyStronghands()
294         public
295     {
296         // fetch dividends
297         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
298 
299         // pay out the dividends virtually
300         address _customerAddress = msg.sender;
301         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
302 
303         // retrieve ref. bonus
304         _dividends += referralBalance_[_customerAddress];
305         referralBalance_[_customerAddress] = 0;
306 
307         // dispatch a buy order with the virtualized "withdrawn dividends"
308         uint256 _tokens = purchaseTokens(_dividends, 0x0, true);
309 
310         // fire event
311         emit onReinvestment(_customerAddress, _dividends, _tokens);
312     }
313 
314     /**
315      * Alias of sell() and withdraw().
316      */
317     function exit()
318         public
319     {
320         // get token count for caller & sell them all
321         address _customerAddress = msg.sender;
322         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
323         if(_tokens > 0) sell(_tokens);
324 
325         // lambo delivery service
326         withdraw(false);
327     }
328 
329     /**
330      * Withdraws all of the callers earnings.
331      */
332     function withdraw(bool _isTransfer)
333         isActivated()
334         onlyStronghands()
335         public
336     {
337         // setup data
338         address _customerAddress = msg.sender;
339         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
340 
341         uint256 _estimateTokens = calculateTokensReceived(_dividends); // amount of tokens at current token price
342 
343         // update dividend tracker
344         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
345 
346         // add ref. bonus
347         _dividends += referralBalance_[_customerAddress];
348         referralBalance_[_customerAddress] = 0;
349 
350         // lambo delivery service
351         _customerAddress.transfer(_dividends);
352 
353         // fire event
354         emit onWithdraw(_customerAddress, _dividends, _estimateTokens, _isTransfer);
355     }
356 
357     /**
358      * Liquifies tokens to ethereum.
359      */
360     function sell(uint256 _amountOfTokens)
361         isSellActivated()
362         onlyBagholders()
363         public
364     {
365         // setup data
366         address _customerAddress = msg.sender;
367         // russian hackers BTFO
368         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
369         uint256 _tokens = _amountOfTokens;
370         uint256 _ethereum = tokensToEthereum_(_tokens);
371 
372         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
373         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
374 
375         // Take out dividends and then _fundPayout
376         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
377 
378         // Add ethereum to send to fund
379         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
380 
381         // burn the sold tokens
382         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
383         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
384 
385         // update dividends tracker
386         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
387         payoutsTo_[_customerAddress] -= _updatedPayouts;
388 
389         // dividing by zero is a bad idea
390         if (tokenSupply_ > 0) {
391             // update the amount of dividends per token
392             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
393         }
394 
395         // fire event
396         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
397     }
398 
399 
400     /**
401      * Transfer tokens from the caller to a new holder.
402      * REMEMBER THIS IS 0% TRANSFER FEE
403      */
404     function transfer(address _toAddress, uint256 _amountOfTokens)
405         isActivated()
406         onlyBagholders()
407         public
408         returns(bool)
409     {
410         // setup
411         address _customerAddress = msg.sender;
412 
413         // make sure we have the requested tokens
414         // also disables transfers until ambassador phase is over
415         // ( we dont want whale premines )
416         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
417 
418         // withdraw all outstanding dividends first
419         if(myDividends(true) > 0) withdraw(true);
420 
421         // exchange tokens
422         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
423         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
424 
425         // update dividend trackers
426         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
427         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
428 
429 
430         // fire event
431         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
432 
433         // ERC20
434         return true;
435     }
436 
437     /**
438     * Transfer token to a specified address and forward the data to recipient
439     * ERC-677 standard
440     * https://github.com/ethereum/EIPs/issues/677
441     * @param _to    Receiver address.
442     * @param _value Amount of tokens that will be transferred.
443     * @param _data  Transaction metadata.
444     */
445     function transferAndCall(address _to, uint256 _value, bytes _data) external returns (bool) {
446       require(_to != address(0));
447       require(canAcceptTokens_[_to] == true); // security check that contract approved by the exchange
448       require(transfer(_to, _value)); // do a normal token transfer to the contract
449 
450       if (isContract(_to)) {
451         AcceptsExchange receiver = AcceptsExchange(_to);
452         require(receiver.tokenFallback(msg.sender, _value, _data));
453       }
454 
455       return true;
456     }
457 
458     /**
459      * Additional check that the game address we are sending tokens to is a contract
460      * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
461      */
462      function isContract(address _addr) private constant returns (bool is_contract) {
463        // retrieve the size of the code on target address, this needs assembly
464        uint length;
465        assembly { length := extcodesize(_addr) }
466        return length > 0;
467      }
468 
469     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
470     /**
471 
472     /**
473      * In case one of us dies, we need to replace ourselves.
474      */
475     function setAdministrator(address _identifier, bool _status)
476         onlyAdministrator()
477         public
478     {
479         administrators[_identifier] = _status;
480     }
481 
482     /**
483      * Precautionary measures in case we need to adjust the masternode rate.
484      */
485     function setStakingRequirement(uint256 _amountOfTokens)
486         onlyAdministrator()
487         public
488     {
489         stakingRequirement = _amountOfTokens;
490     }
491 
492     /**
493      * Add or remove game contract, which can accept tokens
494      */
495     function setCanAcceptTokens(address _address, bool _value)
496       onlyAdministrator()
497       public
498     {
499       canAcceptTokens_[_address] = _value;
500     }
501 
502     /**
503      * If we want to rebrand, we can.
504      */
505     function setName(string _name)
506         onlyAdministrator()
507         public
508     {
509         name = _name;
510     }
511 
512     /**
513      * If we want to rebrand, we can.
514      */
515     function setSymbol(string _symbol)
516         onlyAdministrator()
517         public
518     {
519         symbol = _symbol;
520     }
521 
522     /**
523      * To add VIPs for prelaunch event
524      */
525     function addAmbassador(address _newAmbassador)
526         maxAmbassadors()
527         onlyAdministrator()
528         public
529     {
530         totalAmbassadors = SafeMath.add(totalAmbassadors,1);
531         ambassadors_[_newAmbassador] = true;
532     }
533 
534     /**
535      * To remove VIPs for prelaunch event whom didn't deposit after 12 hours
536      */
537     function removeAmbassador(address _existingAmbassador)
538         removeAmbassadorCriteria(_existingAmbassador)
539         onlyAdministrator()
540         public
541     {
542         totalAmbassadors = SafeMath.sub(totalAmbassadors,1);
543         ambassadors_[_existingAmbassador] = false;
544     }
545 
546     /*----------  HELPERS AND CALCULATORS  ----------*/
547     /**
548      * Method to view the current Ethereum stored in the contract
549      * Example: totalEthereumBalance()
550      */
551     function totalEthereumBalance()
552         public
553         view
554         returns(uint)
555     {
556         return address(this).balance;
557     }
558 
559     /**
560      * Retrieve the total token supply.
561      */
562     function totalSupply()
563         public
564         view
565         returns(uint256)
566     {
567         return tokenSupply_;
568     }
569 
570     /**
571      * Retrieve the tokens owned by the caller.
572      */
573     function myTokens()
574         public
575         view
576         returns(uint256)
577     {
578         address _customerAddress = msg.sender;
579         return balanceOf(_customerAddress);
580     }
581 
582     /**
583      * Retrieve the dividends owned by the caller.
584      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
585      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
586      * But in the internal calculations, we want them separate.
587      */
588     function myDividends(bool _includeReferralBonus)
589         public
590         view
591         returns(uint256)
592     {
593         address _customerAddress = msg.sender;
594         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
595     }
596 
597     /**
598      * Retrieve the token balance of any single address.
599      */
600     function balanceOf(address _customerAddress)
601         view
602         public
603         returns(uint256)
604     {
605         return tokenBalanceLedger_[_customerAddress];
606     }
607 
608     /**
609      * Retrieve the dividend balance of any single address.
610      */
611     function dividendsOf(address _customerAddress)
612         view
613         public
614         returns(uint256)
615     {
616         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
617     }
618 
619     /**
620      * Return the buy price of 1 individual token.
621      */
622     function sellPrice()
623         public
624         view
625         returns(uint256)
626     {
627         // our calculation relies on the token supply, so we need supply. Doh.
628         if(tokenSupply_ == 0){
629             return tokenPriceInitial_ - tokenPriceIncremental_;
630         } else {
631             uint256 _ethereum = tokensToEthereum_(1e18);
632             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
633             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
634             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
635             return _taxedEthereum;
636         }
637     }
638 
639     /**
640      * Return the sell price of 1 individual token.
641      */
642     function buyPrice()
643         public
644         view
645         returns(uint256)
646     {
647         // our calculation relies on the token supply, so we need supply. Doh.
648         if(tokenSupply_ == 0){
649             return tokenPriceInitial_ + tokenPriceIncremental_;
650         } else {
651             uint256 _ethereum = tokensToEthereum_(1e18);
652             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
653             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
654             uint256 _taxedEthereum =  SafeMath.add(SafeMath.add(_ethereum, _dividends), _fundPayout);
655             return _taxedEthereum;
656         }
657     }
658 
659     /**
660      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
661      */
662     function calculateTokensReceived(uint256 _ethereumToSpend)
663         public
664         view
665         returns(uint256)
666     {
667         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
668         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereumToSpend, fundFee_), 100);
669         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _fundPayout);
670         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
671         return _amountOfTokens;
672     }
673 
674     /**
675      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
676      */
677     function calculateEthereumReceived(uint256 _tokensToSell)
678         public
679         view
680         returns(uint256)
681     {
682         require(_tokensToSell <= tokenSupply_);
683         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
684         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
685         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
686         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
687         return _taxedEthereum;
688     }
689 
690     /**
691      * Function for the frontend to show ether waiting to be send to fund in contract
692      */
693     function etherToSendFund()
694         public
695         view
696         returns(uint256) {
697         return SafeMath.sub(totalEthFundCollected, totalEthFundReceived);
698     }
699 
700     /**
701      * Function for getting the current exitFee
702      */
703     function exitFee() public view returns (uint8) {
704         if ( now < ACTIVATION_TIME) {
705           return startExitFee_;
706         }
707         uint256 secondsPassed = now - ACTIVATION_TIME;
708         if (secondsPassed >= exitFeeFallDuration_) {
709             return finalExitFee_;
710         }
711         uint8 totalChange = startExitFee_ - finalExitFee_;
712         uint8 currentChange = uint8(totalChange * secondsPassed / exitFeeFallDuration_);
713         uint8 currentFee = startExitFee_- currentChange;
714         return currentFee;
715     }
716 
717     /*==========================================
718     =            INTERNAL FUNCTIONS            =
719     ==========================================*/
720 
721     function purchaseTokens(uint256 _incomingEthereum, address _referredBy, bool _isReinvest)
722         antiEarlyWhale(_incomingEthereum, _isReinvest)
723         internal
724         returns(uint256)
725     {
726         // data setup
727         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
728         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, fundFee_), 100);
729         uint256 _dividends = SafeMath.sub(_undividedDividends, SafeMath.div(_undividedDividends, 3));
730         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _undividedDividends), _fundPayout);
731         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
732 
733         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
734         uint256 _fee = _dividends * magnitude;
735 
736         // no point in continuing execution if OP is a poor russian hacker
737         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
738         // (or hackers)
739         // and yes we know that the safemath function automatically rules out the "greater then" equation.
740         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
741 
742         // is the user referred by a masternode?
743         if(
744             // is this a referred purchase?
745             _referredBy != 0x0000000000000000000000000000000000000000 &&
746 
747             // no cheating!
748             _referredBy != msg.sender &&
749 
750             // does the referrer have at least X whole tokens?
751             // i.e is the referrer a godly chad masternode
752             tokenBalanceLedger_[_referredBy] >= stakingRequirement
753         ){
754             // wealth redistribution
755             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], SafeMath.div(_undividedDividends, 3));
756         } else {
757             // no ref purchase
758             // add the referral bonus back to the global dividends cake
759             _dividends = SafeMath.add(_dividends, SafeMath.div(_undividedDividends, 3));
760             _fee = _dividends * magnitude;
761         }
762 
763         // we can't give people infinite ethereum
764         if(tokenSupply_ > 0){
765 
766             // add tokens to the pool
767             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
768 
769             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
770             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
771 
772             // calculate the amount of tokens the customer receives over his purchase
773             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
774 
775         } else {
776             // add tokens to the pool
777             tokenSupply_ = _amountOfTokens;
778         }
779 
780         // update circulating supply & the ledger address for the customer
781         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
782 
783         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
784         //really i know you think you do but you don't
785         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
786         payoutsTo_[msg.sender] += _updatedPayouts;
787 
788         // fire event
789         emit onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy, _isReinvest, now, buyPrice());
790 
791         return _amountOfTokens;
792     }
793 
794     /**
795      * Calculate Token price based on an amount of incoming ethereum
796      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
797      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
798      */
799     function ethereumToTokens_(uint256 _ethereum)
800         internal
801         view
802         returns(uint256)
803     {
804         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
805         uint256 _tokensReceived =
806          (
807             (
808                 // underflow attempts BTFO
809                 SafeMath.sub(
810                     (sqrt
811                         (
812                             (_tokenPriceInitial**2)
813                             +
814                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
815                             +
816                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
817                             +
818                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
819                         )
820                     ), _tokenPriceInitial
821                 )
822             )/(tokenPriceIncremental_)
823         )-(tokenSupply_)
824         ;
825 
826         return _tokensReceived;
827     }
828 
829     /**
830      * Calculate token sell value.
831      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
832      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
833      */
834      function tokensToEthereum_(uint256 _tokens)
835         internal
836         view
837         returns(uint256)
838     {
839 
840         uint256 tokens_ = (_tokens + 1e18);
841         uint256 _tokenSupply = (tokenSupply_ + 1e18);
842         uint256 _etherReceived =
843         (
844             // underflow attempts BTFO
845             SafeMath.sub(
846                 (
847                     (
848                         (
849                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
850                         )-tokenPriceIncremental_
851                     )*(tokens_ - 1e18)
852                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
853             )
854         /1e18);
855         return _etherReceived;
856     }
857 
858 
859     //This is where all your gas goes, sorry
860     //Not sorry, you probably only paid 1 gwei
861     function sqrt(uint x) internal pure returns (uint y) {
862         uint z = (x + 1) / 2;
863         y = x;
864         while (z < y) {
865             y = z;
866             z = (x / z + z) / 2;
867         }
868     }
869 }
870 
871 /**
872  * @title SafeMath
873  * @dev Math operations with safety checks that throw on error
874  */
875 library SafeMath {
876 
877     /**
878     * @dev Multiplies two numbers, throws on overflow.
879     */
880     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
881         if (a == 0) {
882             return 0;
883         }
884         uint256 c = a * b;
885         assert(c / a == b);
886         return c;
887     }
888 
889     /**
890     * @dev Integer division of two numbers, truncating the quotient.
891     */
892     function div(uint256 a, uint256 b) internal pure returns (uint256) {
893         // assert(b > 0); // Solidity automatically throws when dividing by 0
894         uint256 c = a / b;
895         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
896         return c;
897     }
898 
899     /**
900     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
901     */
902     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
903         assert(b <= a);
904         return a - b;
905     }
906 
907     /**
908     * @dev Adds two numbers, throws on overflow.
909     */
910     function add(uint256 a, uint256 b) internal pure returns (uint256) {
911         uint256 c = a + b;
912         assert(c >= a);
913         return c;
914     }
915 }