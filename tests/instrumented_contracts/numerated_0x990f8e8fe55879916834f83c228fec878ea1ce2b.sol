1 pragma solidity ^0.4.21;
2 
3 /*
4 #     #    #     #####  ######     #     #####  
5 ##    #   # #   #     # #     #   # #   #     # 
6 # #   #  #   #  #       #     #  #   #  #     # 
7 #  #  # #     #  #####  #     # #     # #     # 
8 #   # # #######       # #     # ####### #   # # 
9 #    ## #     # #     # #     # #     # #    #  
10 #     # #     #  #####  ######  #     #  #### # 
11 *
12 *
13 * [x] 0% TRANSFER FEES
14 * [x] 20% DIVIDENDS AND MASTERNODES
15 * [x] Multi-tier Masternode system 50% 1st ref 30% 2nd ref 20% 3rd ref
16 * [x] 5% FEE ON EACH BUY AND SELL GO TO NASDAQ BOND GAME
17 * [x] AUDITTED BY JOHHNY BOY
18 */
19 
20 
21 /**
22  * Definition of contract accepting NASDAQ tokens
23  * Games, casinos, anything can reuse this contract to support NASDAQ tokens
24  */
25 contract AcceptsNASDAQ {
26     NASDAQ public tokenContract;
27 
28     function AcceptsNASDAQ(address _tokenContract) public {
29         tokenContract = NASDAQ(_tokenContract);
30     }
31 
32     modifier onlyTokenContract {
33         require(msg.sender == address(tokenContract));
34         _;
35     }
36 
37     /**
38     * @dev Standard ERC677 function that will handle incoming token transfers.
39     *
40     * @param _from  Token sender address.
41     * @param _value Amount of tokens.
42     * @param _data  Transaction metadata.
43     */
44     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
45 }
46 
47 
48 contract NASDAQ {
49     /*=================================
50     =            MODIFIERS            =
51     =================================*/
52     // only people with tokens
53     modifier onlyBagholders() {
54         require(myTokens() > 0);
55         _;
56     }
57 
58     // only people with profits
59     modifier onlyStronghands() {
60         require(myDividends(true) > 0);
61         _;
62     }
63 
64     modifier notContract() {
65       require (msg.sender == tx.origin);
66       _;
67     }
68 
69     // administrators can:
70     // -> change the name of the contract
71     // -> change the name of the token
72     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
73     // they CANNOT:
74     // -> take funds
75     // -> disable withdrawals
76     // -> kill the contract
77     // -> change the price of tokens
78     modifier onlyAdministrator(){
79         address _customerAddress = msg.sender;
80         require(administrators[_customerAddress]);
81         _;
82     }
83     
84     uint ACTIVATION_TIME = 1535835600;
85 
86 
87     // ensures that the first tokens in the contract will be equally distributed
88     // meaning, no divine dump will be ever possible
89     // result: healthy longevity.
90     modifier antiEarlyWhale(uint256 _amountOfEthereum){
91         address _customerAddress = msg.sender;
92         
93         if (now >= ACTIVATION_TIME) {
94             onlyAmbassadors = false;
95         }
96 
97         // are we still in the vulnerable phase?
98         // if so, enact anti early whale protocol
99         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
100             require(
101                 // is the customer in the ambassador list?
102                 ambassadors_[_customerAddress] == true &&
103 
104                 // does the customer purchase exceed the max ambassador quota?
105                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
106 
107             );
108 
109             // updated the accumulated quota
110             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
111 
112             // execute
113             _;
114         } else {
115             // in case the ether count drops low, the ambassador phase won't reinitiate
116             onlyAmbassadors = false;
117             _;
118         }
119 
120     }
121 
122     /*==============================
123     =            EVENTS            =
124     ==============================*/
125     event onTokenPurchase(
126         address indexed customerAddress,
127         uint256 incomingEthereum,
128         uint256 tokensMinted,
129         address indexed referredBy
130     );
131 
132     event onTokenSell(
133         address indexed customerAddress,
134         uint256 tokensBurned,
135         uint256 ethereumEarned
136     );
137 
138     event onReinvestment(
139         address indexed customerAddress,
140         uint256 ethereumReinvested,
141         uint256 tokensMinted
142     );
143 
144     event onWithdraw(
145         address indexed customerAddress,
146         uint256 ethereumWithdrawn
147     );
148 
149     // ERC20
150     event Transfer(
151         address indexed from,
152         address indexed to,
153         uint256 tokens
154     );
155 
156 
157     /*=====================================
158     =            CONFIGURABLES            =
159     =====================================*/
160     string public name = "NASDAQ";
161     string public symbol = "NASDAQ";
162     uint8 constant public decimals = 18;
163     uint8 constant internal dividendFee_ = 20; // 20% dividend fee on each buy and sell
164     uint8 constant internal fundFee_ = 5; // 5% investment fund fee on each buy and sell
165     uint256 constant internal tokenPriceInitial_ = 0.000000001 ether;
166     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
167     uint256 constant internal magnitude = 2**64;
168 
169     // Address to send the 5% Fee
170     address constant public giveEthFundAddress = 0x1044d95817689bf0E87B71a13263107D9cBBB930;
171     uint256 public totalEthFundRecieved; // total ETH charity recieved from this contract
172     uint256 public totalEthFundCollected; // total ETH charity collected in this contract
173 
174     // proof of stake (defaults at 100 tokens)
175     uint256 public stakingRequirement = 25e18;
176 
177     // ambassador program
178     mapping(address => bool) internal ambassadors_;
179     uint256 constant internal ambassadorMaxPurchase_ = 2.5 ether;
180     uint256 constant internal ambassadorQuota_ = 2.5 ether;
181 
182 
183 
184    /*================================
185     =            DATASETS            =
186     ================================*/
187     // amount of shares for each address (scaled number)
188     mapping(address => uint256) internal tokenBalanceLedger_;
189     mapping(address => uint256) internal referralBalance_;
190     mapping(address => int256) internal payoutsTo_;
191     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
192     uint256 internal tokenSupply_ = 0;
193     uint256 internal profitPerShare_;
194 
195     // administrator list (see above on what they can do)
196     mapping(address => bool) public administrators;
197 
198     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
199     bool public onlyAmbassadors = true;
200 
201     // Special NASDAQ Platform control from scam game contracts on NASDAQ platform
202     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept NASDAQ tokens
203 
204     mapping(address => address) public stickyRef;
205 
206     /*=======================================
207     =            PUBLIC FUNCTIONS            =
208     =======================================*/
209     /*
210     * -- APPLICATION ENTRY POINTS --
211     */
212     function NASDAQ()
213         public
214     {
215         // add administrators here
216         administrators[0x1044d95817689bf0E87B71a13263107D9cBBB930] = true;
217 
218         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
219         ambassadors_[0x41FE3738B503cBaFD01C1Fd8DD66b7fE6Ec11b01] = true;
220         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
221         ambassadors_[0x1044d95817689bf0E87B71a13263107D9cBBB930] = true;
222        // add the ambassadors here - Tokens will be distributed to these addresses from main premine
223         ambassadors_[0x41fe3dD64cc434a4e3bf6aAd566e25c0b9c20964] = true;
224 
225         
226     }
227 
228 
229     /**
230      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
231      */
232     function buy(address _referredBy)
233         public
234         payable
235         returns(uint256)
236     {
237         
238         require(tx.gasprice <= 0.95 szabo);
239         purchaseTokens(msg.value, _referredBy);
240     }
241 
242     /**
243      * Fallback function to handle ethereum that was send straight to the contract
244      * Unfortunately we cannot use a referral address this way.
245      */
246     function()
247         payable
248         public
249     {
250         
251         require(tx.gasprice <= 0.95 szabo);
252         purchaseTokens(msg.value, 0x0);
253     }
254 
255 
256     function payFund() payable public {
257       uint256 ethToPay = SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
258       require(ethToPay > 1);
259       totalEthFundRecieved = SafeMath.add(totalEthFundRecieved, ethToPay);
260       if(!giveEthFundAddress.call.value(ethToPay).gas(400000)()) {
261          totalEthFundRecieved = SafeMath.sub(totalEthFundRecieved, ethToPay);
262       }
263     }
264 
265     /**
266      * Converts all of caller's dividends to tokens.
267      */
268     function reinvest()
269         onlyStronghands()
270         public
271     {
272         // fetch dividends
273         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
274 
275         // pay out the dividends virtually
276         address _customerAddress = msg.sender;
277         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
278 
279         // retrieve ref. bonus
280         _dividends += referralBalance_[_customerAddress];
281         referralBalance_[_customerAddress] = 0;
282 
283         // dispatch a buy order with the virtualized "withdrawn dividends"
284         uint256 _tokens = purchaseTokens(_dividends, 0x0);
285 
286         // fire event
287         onReinvestment(_customerAddress, _dividends, _tokens);
288     }
289 
290     /**
291      * Alias of sell() and withdraw().
292      */
293     function exit()
294         public
295     {
296         // get token count for caller & sell them all
297         address _customerAddress = msg.sender;
298         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
299         if(_tokens > 0) sell(_tokens);
300 
301         // lambo delivery service
302         withdraw();
303     }
304 
305     /**
306      * Withdraws all of the callers earnings.
307      */
308     function withdraw()
309         onlyStronghands()
310         public
311     {
312         // setup data
313         address _customerAddress = msg.sender;
314         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
315 
316         // update dividend tracker
317         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
318 
319         // add ref. bonus
320         _dividends += referralBalance_[_customerAddress];
321         referralBalance_[_customerAddress] = 0;
322 
323         // lambo delivery service
324         _customerAddress.transfer(_dividends);
325 
326         // fire event
327         onWithdraw(_customerAddress, _dividends);
328     }
329 
330     /**
331      * Liquifies tokens to ethereum.
332      */
333     function sell(uint256 _amountOfTokens)
334         onlyBagholders()
335         public
336     {
337         // setup data
338         address _customerAddress = msg.sender;
339         // russian hackers BTFO
340         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
341         uint256 _tokens = _amountOfTokens;
342         uint256 _ethereum = tokensToEthereum_(_tokens);
343 
344         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
345         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
346         uint256 _refPayout = _dividends / 3;
347         _dividends = SafeMath.sub(_dividends, _refPayout);
348         (_dividends,) = handleRef(stickyRef[msg.sender], _refPayout, _dividends, 0);
349 
350         // Take out dividends and then _fundPayout
351         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
352 
353         // Add ethereum to send to fund
354         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
355 
356         // burn the sold tokens
357         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
358         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
359 
360         // update dividends tracker
361         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
362         payoutsTo_[_customerAddress] -= _updatedPayouts;
363 
364         // dividing by zero is a bad idea
365         if (tokenSupply_ > 0) {
366             // update the amount of dividends per token
367             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
368         }
369 
370         // fire event
371         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
372     }
373 
374 
375     /**
376      * Transfer tokens from the caller to a new holder.
377      * REMEMBER THIS IS 0% TRANSFER FEE
378      */
379     function transfer(address _toAddress, uint256 _amountOfTokens)
380         onlyBagholders()
381         public
382         returns(bool)
383     {
384         // setup
385         address _customerAddress = msg.sender;
386 
387         // make sure we have the requested tokens
388         // also disables transfers until ambassador phase is over
389         // ( we dont want whale premines )
390         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
391 
392         // withdraw all outstanding dividends first
393         if(myDividends(true) > 0) withdraw();
394 
395         // exchange tokens
396         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
397         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
398 
399         // update dividend trackers
400         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
401         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
402 
403 
404         // fire event
405         Transfer(_customerAddress, _toAddress, _amountOfTokens);
406 
407         // ERC20
408         return true;
409     }
410 
411     /**
412     * Transfer token to a specified address and forward the data to recipient
413     * ERC-677 standard
414     * https://github.com/ethereum/EIPs/issues/677
415     * @param _to    Receiver address.
416     * @param _value Amount of tokens that will be transferred.
417     * @param _data  Transaction metadata.
418     */
419     function transferAndCall(address _to, uint256 _value, bytes _data) external returns (bool) {
420       require(_to != address(0));
421       require(canAcceptTokens_[_to] == true); // security check that contract approved by NASDAQ platform
422       require(transfer(_to, _value)); // do a normal token transfer to the contract
423 
424       if (isContract(_to)) {
425         AcceptsNASDAQ receiver = AcceptsNASDAQ(_to);
426         require(receiver.tokenFallback(msg.sender, _value, _data));
427       }
428 
429       return true;
430     }
431 
432     /**
433      * Additional check that the game address we are sending tokens to is a contract
434      * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
435      */
436      function isContract(address _addr) private constant returns (bool is_contract) {
437        // retrieve the size of the code on target address, this needs assembly
438        uint length;
439        assembly { length := extcodesize(_addr) }
440        return length > 0;
441      }
442 
443     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
444     /**
445      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
446      */
447     //function disableInitialStage()
448     //    onlyAdministrator()
449     //    public
450     //{
451     //    onlyAmbassadors = false;
452     //}
453 
454     /**
455      * In case one of us dies, we need to replace ourselves.
456      */
457     function setAdministrator(address _identifier, bool _status)
458         onlyAdministrator()
459         public
460     {
461         administrators[_identifier] = _status;
462     }
463 
464     /**
465      * Precautionary measures in case we need to adjust the masternode rate.
466      */
467     function setStakingRequirement(uint256 _amountOfTokens)
468         onlyAdministrator()
469         public
470     {
471         stakingRequirement = _amountOfTokens;
472     }
473 
474     /**
475      * Add or remove game contract, which can accept NASDAQ tokens
476      */
477     function setCanAcceptTokens(address _address, bool _value)
478       onlyAdministrator()
479       public
480     {
481       canAcceptTokens_[_address] = _value;
482     }
483 
484     /**
485      * If we want to rebrand, we can.
486      */
487     function setName(string _name)
488         onlyAdministrator()
489         public
490     {
491         name = _name;
492     }
493 
494     /**
495      * If we want to rebrand, we can.
496      */
497     function setSymbol(string _symbol)
498         onlyAdministrator()
499         public
500     {
501         symbol = _symbol;
502     }
503 
504 
505     /*----------  HELPERS AND CALCULATORS  ----------*/
506     /**
507      * Method to view the current Ethereum stored in the contract
508      * Example: totalEthereumBalance()
509      */
510     function totalEthereumBalance()
511         public
512         view
513         returns(uint)
514     {
515         return this.balance;
516     }
517 
518     /**
519      * Retrieve the total token supply.
520      */
521     function totalSupply()
522         public
523         view
524         returns(uint256)
525     {
526         return tokenSupply_;
527     }
528 
529     /**
530      * Retrieve the tokens owned by the caller.
531      */
532     function myTokens()
533         public
534         view
535         returns(uint256)
536     {
537         address _customerAddress = msg.sender;
538         return balanceOf(_customerAddress);
539     }
540 
541     /**
542      * Retrieve the dividends owned by the caller.
543      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
544      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
545      * But in the internal calculations, we want them separate.
546      */
547     function myDividends(bool _includeReferralBonus)
548         public
549         view
550         returns(uint256)
551     {
552         address _customerAddress = msg.sender;
553         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
554     }
555 
556     /**
557      * Retrieve the token balance of any single address.
558      */
559     function balanceOf(address _customerAddress)
560         view
561         public
562         returns(uint256)
563     {
564         return tokenBalanceLedger_[_customerAddress];
565     }
566 
567     /**
568      * Retrieve the dividend balance of any single address.
569      */
570     function dividendsOf(address _customerAddress)
571         view
572         public
573         returns(uint256)
574     {
575         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
576     }
577 
578     /**
579      * Return the buy price of 1 individual token.
580      */
581     function sellPrice()
582         public
583         view
584         returns(uint256)
585     {
586         // our calculation relies on the token supply, so we need supply. Doh.
587         if(tokenSupply_ == 0){
588             return tokenPriceInitial_ - tokenPriceIncremental_;
589         } else {
590             uint256 _ethereum = tokensToEthereum_(1e18);
591             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
592             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
593             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
594             return _taxedEthereum;
595         }
596     }
597 
598     /**
599      * Return the sell price of 1 individual token.
600      */
601     function buyPrice()
602         public
603         view
604         returns(uint256)
605     {
606         // our calculation relies on the token supply, so we need supply. Doh.
607         if(tokenSupply_ == 0){
608             return tokenPriceInitial_ + tokenPriceIncremental_;
609         } else {
610             uint256 _ethereum = tokensToEthereum_(1e18);
611             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
612             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
613             uint256 _taxedEthereum =  SafeMath.add(SafeMath.add(_ethereum, _dividends), _fundPayout);
614             return _taxedEthereum;
615         }
616     }
617 
618     /**
619      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
620      */
621     function calculateTokensReceived(uint256 _ethereumToSpend)
622         public
623         view
624         returns(uint256)
625     {
626         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_), 100);
627         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereumToSpend, fundFee_), 100);
628         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _fundPayout);
629         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
630         return _amountOfTokens;
631     }
632 
633     /**
634      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
635      */
636     function calculateEthereumReceived(uint256 _tokensToSell)
637         public
638         view
639         returns(uint256)
640     {
641         require(_tokensToSell <= tokenSupply_);
642         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
643         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
644         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
645         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
646         return _taxedEthereum;
647     }
648 
649     /**
650      * Function for the frontend to show ether waiting to be send to fund in contract
651      */
652     function etherToSendFund()
653         public
654         view
655         returns(uint256) {
656         return SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
657     }
658 
659 
660     /*==========================================
661     =            INTERNAL FUNCTIONS            =
662     ==========================================*/
663 
664     // Make sure we will send back excess if user sends more then 5 ether before 100 ETH in contract
665     function purchaseInternal(uint256 _incomingEthereum, address _referredBy)
666       notContract()// no contracts allowed
667       internal
668       returns(uint256) {
669 
670       uint256 purchaseEthereum = _incomingEthereum;
671       uint256 excess;
672       if(purchaseEthereum > 2.5 ether) { // check if the transaction is over 2.5 ether
673           if (SafeMath.sub(address(this).balance, purchaseEthereum) <= 25 ether) { // if so check the contract is less then 100 ether
674               purchaseEthereum = 2.5 ether;
675               excess = SafeMath.sub(_incomingEthereum, purchaseEthereum);
676           }
677       }
678 
679       purchaseTokens(purchaseEthereum, _referredBy);
680 
681       if (excess > 0) {
682         msg.sender.transfer(excess);
683       }
684     }
685 
686     function handleRef(address _ref, uint _referralBonus, uint _currentDividends, uint _currentFee) internal returns (uint, uint){
687         uint _dividends = _currentDividends;
688         uint _fee = _currentFee;
689         address _referredBy = stickyRef[msg.sender];
690         if (_referredBy == address(0x0)){
691             _referredBy = _ref;
692         }
693         // is the user referred by a masternode?
694         if(
695             // is this a referred purchase?
696             _referredBy != 0x0000000000000000000000000000000000000000 &&
697 
698             // no cheating!
699             _referredBy != msg.sender &&
700 
701             // does the referrer have at least X whole tokens?
702             // i.e is the referrer a godly chad masternode
703             tokenBalanceLedger_[_referredBy] >= stakingRequirement
704         ){
705             // wealth redistribution
706             if (stickyRef[msg.sender] == address(0x0)){
707                 stickyRef[msg.sender] = _referredBy;
708             }
709             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus/2);
710             address currentRef = stickyRef[_referredBy];
711             if (currentRef != address(0x0) && tokenBalanceLedger_[currentRef] >= stakingRequirement){
712                 referralBalance_[currentRef] = SafeMath.add(referralBalance_[currentRef], (_referralBonus/10)*3);
713                 currentRef = stickyRef[currentRef];
714                 if (currentRef != address(0x0) && tokenBalanceLedger_[currentRef] >= stakingRequirement){
715                     referralBalance_[currentRef] = SafeMath.add(referralBalance_[currentRef], (_referralBonus/10)*2);
716                 }
717                 else{
718                     _dividends = SafeMath.add(_dividends, _referralBonus - _referralBonus/2 - (_referralBonus/10)*3);
719                     _fee = _dividends * magnitude;
720                 }
721             }
722             else{
723                 _dividends = SafeMath.add(_dividends, _referralBonus - _referralBonus/2);
724                 _fee = _dividends * magnitude;
725             }
726             
727             
728         } else {
729             // no ref purchase
730             // add the referral bonus back to the global dividends cake
731             _dividends = SafeMath.add(_dividends, _referralBonus);
732             _fee = _dividends * magnitude;
733         }
734         return (_dividends, _fee);
735     }
736 
737 
738     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
739         antiEarlyWhale(_incomingEthereum)
740         internal
741         returns(uint256)
742     {
743         // data setup
744         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
745         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
746         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, fundFee_), 100);
747         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
748         uint256 _fee;
749         (_dividends, _fee) = handleRef(_referredBy, _referralBonus, _dividends, _fee);
750         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _dividends), _fundPayout);
751         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
752 
753         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
754 
755 
756         // no point in continuing execution if OP is a poorfag russian hacker
757         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
758         // (or hackers)
759         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
760         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
761 
762 
763 
764         // we can't give people infinite ethereum
765         if(tokenSupply_ > 0){
766  
767             // add tokens to the pool
768             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
769 
770             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
771             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
772 
773             // calculate the amount of tokens the customer receives over his purchase
774             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
775 
776         } else {
777             // add tokens to the pool
778             tokenSupply_ = _amountOfTokens;
779         }
780 
781         // update circulating supply & the ledger address for the customer
782         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
783 
784         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
785         //really i know you think you do but you don't
786         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
787         payoutsTo_[msg.sender] += _updatedPayouts;
788 
789         // fire event
790         onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
791 
792         return _amountOfTokens;
793     }
794 
795     /**
796      * Calculate Token price based on an amount of incoming ethereum
797      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
798      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
799      */
800     function ethereumToTokens_(uint256 _ethereum)
801         internal
802         view
803         returns(uint256)
804     {
805         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
806         uint256 _tokensReceived =
807          (
808             (
809                 // underflow attempts BTFO
810                 SafeMath.sub(
811                     (sqrt
812                         (
813                             (_tokenPriceInitial**2)
814                             +
815                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
816                             +
817                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
818                             +
819                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
820                         )
821                     ), _tokenPriceInitial
822                 )
823             )/(tokenPriceIncremental_)
824         )-(tokenSupply_)
825         ;
826 
827         return _tokensReceived;
828     }
829 
830     /**
831      * Calculate token sell value.
832      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
833      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
834      */
835      function tokensToEthereum_(uint256 _tokens)
836         internal
837         view
838         returns(uint256)
839     {
840 
841         uint256 tokens_ = (_tokens + 1e18);
842         uint256 _tokenSupply = (tokenSupply_ + 1e18);
843         uint256 _etherReceived =
844         (
845             // underflow attempts BTFO
846             SafeMath.sub(
847                 (
848                     (
849                         (
850                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
851                         )-tokenPriceIncremental_
852                     )*(tokens_ - 1e18)
853                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
854             )
855         /1e18);
856         return _etherReceived;
857     }
858 
859 
860     //This is where all your gas goes, sorry
861     //Not sorry, you probably only paid 1 gwei
862     function sqrt(uint x) internal pure returns (uint y) {
863         uint z = (x + 1) / 2;
864         y = x;
865         while (z < y) {
866             y = z;
867             z = (x / z + z) / 2;
868         }
869     }
870 }
871 
872 /**
873  * @title SafeMath
874  * @dev Math operations with safety checks that throw on error
875  */
876 library SafeMath {
877 
878     /**
879     * @dev Multiplies two numbers, throws on overflow.
880     */
881     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
882         if (a == 0) {
883             return 0;
884         }
885         uint256 c = a * b;
886         assert(c / a == b);
887         return c;
888     }
889 
890     /**
891     * @dev Integer division of two numbers, truncating the quotient.
892     */
893     function div(uint256 a, uint256 b) internal pure returns (uint256) {
894         // assert(b > 0); // Solidity automatically throws when dividing by 0
895         uint256 c = a / b;
896         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
897         return c;
898     }
899 
900     /**
901     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
902     */
903     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
904         assert(b <= a);
905         return a - b;
906     }
907 
908     /**
909     * @dev Adds two numbers, throws on overflow.
910     */
911     function add(uint256 a, uint256 b) internal pure returns (uint256) {
912         uint256 c = a + b;
913         assert(c >= a);
914         return c;
915     }
916 }