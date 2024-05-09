1 pragma solidity ^0.4.25;
2 
3 /*
4 
5    ___  ____      _    ____ _     _____   ____  ______   ______ _   _ ___ ____   _   _  ___ _____ _     ___ _   _ _____ 
6   / _ \|  _ \    / \  / ___| |   | ____| |  _ \/ ___\ \ / / ___| | | |_ _/ ___| | | | |/ _ \_   _| |   |_ _| \ | | ____|
7  | | | | |_) |  / _ \| |   | |   |  _|   | |_) \___ \\ V / |   | |_| || | |     | |_| | | | || | | |    | ||  \| |  _|  
8  | |_| |  _ <  / ___ \ |___| |___| |___  |  __/ ___) || || |___|  _  || | |___  |  _  | |_| || | | |___ | || |\  | |___ 
9   \___/|_| \_\/_/   \_\____|_____|_____| |_|   |____/ |_| \____|_| |_|___\____| |_| |_|\___/ |_| |_____|___|_| \_|_____|
10                                                                                                                         
11                                                                   
12   
13 ERC-20 Exchange using the Psychic Powers of Donut Entrepreneur Oracle
14 
15 Oracle is Finally Sharing his Crypto Psychic Powers with YOU!!!!
16 
17 Buy and Sell Fees:   33%(Distributed to DONUTS token holders)
18 
19 Referral Masternode:
20     Referrer Receives 33% of all Purchase Fees
21 
22 
23 website:    https://oraclepsychic.ga
24 
25 exchange:   https://oraclepsychic.ga/buy.html
26 
27 discord:    https://discord.gg/mM8qehD
28 
29 
30 
31 */
32 
33 contract AcceptsExchange {
34     ORACLEPSYCHICHOTLINE public tokenContract;
35 
36     function AcceptsExchange(address _tokenContract) public {
37         tokenContract = ORACLEPSYCHICHOTLINE(_tokenContract);
38     }
39 
40     modifier onlyTokenContract {
41         require(msg.sender == address(tokenContract));
42         _;
43     }
44 
45     /**
46     * @dev Standard ERC677 function that will handle incoming token transfers.
47     *
48     * @param _from  Token sender address.
49     * @param _value Amount of tokens.
50     * @param _data  Transaction metadata.
51     */
52     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
53     function tokenFallbackExpanded(address _from, uint256 _value, bytes _data, address _sender, address _referrer) external returns (bool);
54 }
55 
56 contract ORACLEPSYCHICHOTLINE {
57     /*=================================
58     =            MODIFIERS            =
59     =================================*/
60     // only people with tokens
61     modifier onlyBagholders() {
62         require(myTokens() > 0);
63         _;
64     }
65     
66     // only people with profits
67     modifier onlyStronghands() {
68         require(myDividends(true) > 0 || ownerAccounts[msg.sender] > 0);
69         //require(myDividends(true) > 0);
70         _;
71     }
72     
73       modifier notContract() {
74       require (msg.sender == tx.origin);
75       _;
76     }
77 
78     modifier allowPlayer(){
79         
80         require(boolAllowPlayer);
81         _;
82     }
83 
84     // administrators can:
85     // -> change the name of the contract
86     // -> change the name of the token
87     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
88     // they CANNOT:
89     // -> take funds
90     // -> disable withdrawals
91     // -> kill the contract
92     // -> change the price of tokens
93     modifier onlyAdministrator(){
94         address _customerAddress = msg.sender;
95         require(administrators[_customerAddress]);
96         _;
97     }
98     
99     modifier onlyActive(){
100         require(boolContractActive);
101         _;
102     }
103 
104     // ensures that the first tokens in the contract will be equally distributed
105     // meaning, no divine dump will be ever possible
106     // result: healthy longevity.
107     modifier antiEarlyWhale(uint256 _amountOfEthereum){
108         address _customerAddress = msg.sender;
109         
110         // are we still in the vulnerable phase?
111         // if so, enact anti early whale protocol 
112         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
113             require(
114                 // is the customer in the ambassador list?
115                 (ambassadors_[_customerAddress] == true &&
116                 
117                 // does the customer purchase exceed the max ambassador quota?
118                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_) ||
119 
120                 (_customerAddress == dev)
121                 
122             );
123             
124             // updated the accumulated quota    
125             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
126         
127             // execute
128             _;
129         } else {
130             // in case the ether count drops low, the ambassador phase won't reinitiate
131             onlyAmbassadors = false;
132             _;    
133         }
134         
135     }
136     
137     /*==============================
138     =            EVENTS            =
139     ==============================*/
140 
141 
142     event onTokenPurchase(
143         address indexed customerAddress,
144         uint256 incomingEthereum,
145         uint256 tokensMinted,
146         address indexed referredBy
147     );
148     
149     event onTokenSell(
150         address indexed customerAddress,
151         uint256 tokensBurned,
152         uint256 ethereumEarned
153     );
154     
155     event onReinvestment(
156         address indexed customerAddress,
157         uint256 ethereumReinvested,
158         uint256 tokensMinted
159     );
160     
161     event onWithdraw(
162         address indexed customerAddress,
163         uint256 ethereumWithdrawn
164     );
165     
166     // ERC20
167     event Transfer(
168         address indexed from,
169         address indexed to,
170         uint256 tokens
171     );
172 
173     
174     /*=====================================
175     =            CONFIGURABLES            =
176     =====================================*/
177     string public name = "ORACLEPSYCHICHOTLINE";
178     string public symbol = "DONUTS";
179     uint8 constant public decimals = 18;
180     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
181     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
182     uint256 constant internal magnitude = 2**64;
183     
184     // proof of stake (defaults at 100 tokens)
185     uint256 public stakingRequirement = 100e18;
186     
187     // ambassador program
188     mapping(address => bool) internal ambassadors_;
189     uint256 constant internal ambassadorMaxPurchase_ = 2 ether;
190     uint256 constant internal ambassadorQuota_ = 20 ether;
191     
192     address dev;
193 
194     bool public boolAllowPlayer = false;
195 
196    /*================================
197     =            DATASETS            =
198     ================================*/
199     // amount of shares for each address (scaled number)
200     mapping(address => uint256) internal tokenBalanceLedger_;
201     mapping(address => uint256) internal referralBalance_;
202     mapping(address => int256) internal payoutsTo_;
203     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
204     uint256 internal tokenSupply_ = 0;
205     uint256 internal profitPerShare_;
206 
207     mapping(address => uint) internal ownerAccounts;
208 
209     bool public allowReferral = false;  //for cards
210 
211     uint public buyDividendFee_ = 330;  
212     uint public sellDividendFee_ = 330;           
213 
214     bool public boolContractActive = false;
215 
216     // administrator list (see above on what they can do)
217     mapping(address => bool) public administrators;
218     
219     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
220     bool public onlyAmbassadors = true;
221 
222       // Special Wall Street Market Platform control from scam game contracts on Wall Street Market platform
223     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept Wall Street tokens
224 
225     address mkt1 = 0x0;
226     address mkt2 = 0x0;
227     address mkt3 = 0x0;   
228 
229     uint mkt1Rate = 0;   
230     uint mkt2Rate = 0;
231     uint mkt3Rate = 0;
232 
233     /*=======================================
234     =            PUBLIC FUNCTIONS            =
235     =======================================*/
236     /*
237     * -- APPLICATION ENTRY POINTS --  
238     */
239     function ORACLEPSYCHICHOTLINE()
240     public
241     {
242      
243         // add administrators here
244         administrators[msg.sender] = true;
245         dev = msg.sender;
246         
247     }
248     
249      
250     /**
251      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
252      */
253     function buy(address _referredBy)
254         public
255         payable
256         returns(uint256)
257     {
258         purchaseTokens(msg.value, _referredBy);
259     }
260     
261     /**
262      * Fallback function to handle ethereum that was send straight to the contract
263      * Unfortunately we cannot use a referral address this way.
264      */
265     function()
266         payable
267         public
268     {
269         purchaseTokens(msg.value, 0x0);
270     }
271     
272     /**
273      * Converts all of caller's dividends to tokens.
274      */
275     function reinvest()
276         onlyStronghands()
277         public
278     {
279         // fetch dividends
280         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
281         
282         // pay out the dividends virtually
283         address _customerAddress = msg.sender;
284         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
285         
286         // retrieve ref. bonus
287         _dividends += referralBalance_[_customerAddress] + ownerAccounts[_customerAddress];
288         referralBalance_[_customerAddress] = 0;
289         ownerAccounts[_customerAddress] = 0;
290         
291         // dispatch a buy order with the virtualized "withdrawn dividends"
292         uint256 _tokens = purchaseTokens(_dividends, 0x0);
293         
294         // fire event
295         onReinvestment(_customerAddress, _dividends, _tokens);
296       
297     }
298     
299     /**
300      * Alias of sell() and withdraw().
301      */
302     function exit()
303         public
304     {
305         // get token count for caller & sell them all
306         address _customerAddress = msg.sender;
307         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
308         if(_tokens > 0) sell(_tokens);
309         
310         withdraw();
311    
312     }
313 
314     /**
315      * Withdraws all of the callers earnings.
316      */
317     function withdraw()
318         onlyStronghands()
319         public
320     {
321         // setup data
322         address _customerAddress = msg.sender;
323         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
324         
325         // update dividend tracker
326         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
327         
328         // add ref. bonus
329         _dividends += referralBalance_[_customerAddress] + ownerAccounts[_customerAddress];
330         referralBalance_[_customerAddress] = 0;
331         ownerAccounts[_customerAddress] = 0;
332         
333         _customerAddress.transfer(_dividends);
334         
335         // fire event
336         onWithdraw(_customerAddress, _dividends);
337     
338     }
339     
340     /**
341      * Liquifies tokens to ethereum.
342      */
343     function sell(uint256 _amountOfTokens)
344     
345         onlyBagholders()
346         public
347     {
348         // setup data
349         uint8 localDivFee = 200;
350    
351 
352         address _customerAddress = msg.sender;
353         // russian hackers BTFO
354         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
355         uint256 _tokens = _amountOfTokens;
356         uint256 _ethereum = tokensToEthereum_(_tokens);
357 
358         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, sellDividendFee_),1000);
359         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
360         
361         // burn the sold tokens
362         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
363         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
364         
365         // update dividends tracker
366         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
367         payoutsTo_[_customerAddress] -= _updatedPayouts;       
368         
369         // dividing by zero is a bad idea
370         if (tokenSupply_ > 0) {
371             // update the amount of dividends per token
372             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
373         }
374 
375     
376         // fire event
377         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
378     }
379     
380     
381     /**
382      * Transfer tokens from the caller to a new holder.
383      * Remember, there's a 15% fee here as well.
384      */
385     function transfer(address _toAddress, uint256 _amountOfTokens)
386         onlyBagholders()
387         public
388         returns(bool)
389     {
390         // setup
391         address _customerAddress = msg.sender;
392 
393         uint8 localDivFee = 150;  //15%
394 
395         // make sure we have the requested tokens
396         // also disables transfers until ambassador phase is over
397         // ( we dont want whale premines )
398         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
399         
400         // withdraw all outstanding dividends first
401         if(myDividends(true) > 0) withdraw();
402         
403         // liquify 20% of the tokens that are transfered
404         // these are dispersed to shareholders
405         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, localDivFee),1000);
406         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
407         uint256 _dividends = tokensToEthereum_(_tokenFee);
408   
409         // burn the fee tokens
410         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
411 
412         // exchange tokens
413         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
414         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
415         
416         // update dividend trackers
417         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
418         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
419         
420         // disperse dividends among holders
421         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
422         
423         // fire event
424         Transfer(_customerAddress, _toAddress, _taxedTokens);
425         
426         // ERC20
427         return true;
428        
429     }
430     
431     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
432     /**
433      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
434      */
435     function disableInitialStage()
436         onlyAdministrator()
437         public
438     {
439         onlyAmbassadors = false;
440     }
441     
442     /**
443      * In case one of us dies, we need to replace ourselves.
444      */
445     function setAdministrator(address _identifier, bool _status)
446         onlyAdministrator()
447         public
448     {
449         administrators[_identifier] = _status;
450     }
451 
452  
453 
454     /**
455     * Set Exchange Rates
456     */
457     function setExchangeRates(uint _newBuyFee, uint _newSellFee)
458         onlyAdministrator()
459         public
460     {
461         require(_newBuyFee <= 400);   //40%
462         require(_newSellFee <= 400);   //40%
463 
464         buyDividendFee_ = _newBuyFee;
465         sellDividendFee_ = _newSellFee;
466     
467     }
468 
469 
470     /**
471     * Set Marketing Rates
472     */
473     function setMarketingRates(uint8 _newMkt1Rate, uint8 _newMkt2Rate, uint8 _newMkt3Rate)
474         onlyAdministrator()
475         public
476     {
477         require(_newMkt1Rate +_newMkt2Rate +_newMkt3Rate <= 60);   // 6%
478        
479         mkt1Rate =  _newMkt1Rate;
480         mkt2Rate =  _newMkt2Rate;
481         mkt3Rate =  _newMkt3Rate;
482 
483     }
484 
485     /**
486     * Set Mkt1 Address
487     */
488     function setMarket1(address _newMkt1)
489         onlyAdministrator()
490         public
491     {
492       
493         mkt1 =  _newMkt1;
494      
495     }
496 
497     /**
498     * Set Mkt2 Address
499     */
500     function setMarket2(address _newMkt2)
501         onlyAdministrator()
502         public
503     {
504       
505         mkt2 =  _newMkt2;
506      
507     }
508 
509     /**
510     * Set Mkt3 Address
511     */
512     function setMarket3(address _newMkt3)
513         onlyAdministrator()
514         public
515     {
516       
517         mkt3 =  _newMkt3;
518      
519     }
520 
521 
522     /**
523      * In case one of us dies, we need to replace ourselves.
524      */
525     function setContractActive(bool _status)
526         onlyAdministrator()
527         public
528     {
529         boolContractActive = _status;
530     }
531 
532     /**
533      * Precautionary measures in case we need to adjust the masternode rate.
534      */
535     function setStakingRequirement(uint256 _amountOfTokens)
536         onlyAdministrator()
537         public
538     {
539         stakingRequirement = _amountOfTokens;
540     }
541     
542     /**
543      * If we want to rebrand, we can.
544      */
545     function setName(string _name)
546         onlyAdministrator()
547         public
548     {
549         name = _name;
550     }
551     
552     /**
553      * If we want to rebrand, we can.
554      */
555     function setSymbol(string _symbol)
556         onlyAdministrator()
557         public
558     {
559         symbol = _symbol;
560     }
561 
562     function addAmbassador(address _newAmbassador) 
563         onlyAdministrator()
564         public
565     {
566         ambassadors_[_newAmbassador] = true;
567     }
568 
569     
570     /*----------  HELPERS AND CALCULATORS  ----------*/
571     /**
572      * Method to view the current Ethereum stored in the contract
573      * Example: totalEthereumBalance()
574      */
575     function totalEthereumBalance()
576         public
577         view
578         returns(uint)
579     {
580         return address(this).balance;
581     }
582     
583     /**
584      * Retrieve the total token supply.
585      */
586     function totalSupply()
587         public
588         view
589         returns(uint256)
590     {
591         return tokenSupply_;
592     }
593     
594     /**
595      * Retrieve the tokens owned by the caller.
596      */
597     function myTokens()
598         public
599         view
600         returns(uint256)
601     {
602         address _customerAddress = msg.sender;
603         return balanceOf(_customerAddress);
604     }
605     
606     /**
607      * Retrieve the dividends owned by the caller.
608      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
609      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
610      * But in the internal calculations, we want them separate. 
611      */ 
612     function myDividends(bool _includeReferralBonus) 
613         public 
614         view 
615         returns(uint256)
616     {
617         address _customerAddress = msg.sender;
618         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
619     }
620 
621     function myCardDividends()
622         public
623         view
624         returns(uint256)
625     {
626         address _customerAddress = msg.sender;
627         return ownerAccounts[_customerAddress];
628     }
629     
630     /**
631      * Retrieve the token balance of any single address.
632      */
633     function balanceOf(address _customerAddress)
634         view
635         public
636         returns(uint256)
637     {
638         return tokenBalanceLedger_[_customerAddress];
639     }
640     
641     /**
642      * Retrieve the dividend balance of any single address.
643      */
644     function dividendsOf(address _customerAddress)
645         view
646         public
647         returns(uint256)
648     {
649         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
650     }
651     
652     /**
653      * Return the buy price of 1 individual token.
654      */
655     function sellPrice() 
656         public 
657         view 
658         returns(uint256)
659     {
660         // our calculation relies on the token supply, so we need supply. Doh.
661         if(tokenSupply_ == 0){
662             return tokenPriceInitial_ - tokenPriceIncremental_;
663         } else {
664             uint256 _ethereum = tokensToEthereum_(1e18);
665             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, sellDividendFee_),1000);
666             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
667             return _taxedEthereum;
668         }
669     }
670     
671     /**
672      * Return the sell price of 1 individual token.
673      */
674     function buyPrice() 
675         public 
676         view 
677         returns(uint256)
678     {
679         // our calculation relies on the token supply, so we need supply. Doh.
680         if(tokenSupply_ == 0){
681             return tokenPriceInitial_ + tokenPriceIncremental_;
682         } else {
683             uint256 _ethereum = tokensToEthereum_(1e18);
684             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, buyDividendFee_),1000);
685             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
686             return _taxedEthereum;
687         }
688     }
689     
690     /**
691      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
692      */
693     function calculateTokensReceived(uint256 _ethereumToSpend) 
694         public 
695         view 
696         returns(uint256)
697     {
698         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, buyDividendFee_),1000);
699         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
700         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
701         
702         return _amountOfTokens;
703     }
704     
705     /**
706      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
707      */
708     function calculateEthereumReceived(uint256 _tokensToSell) 
709         public 
710         view 
711         returns(uint256)
712     {
713         require(_tokensToSell <= tokenSupply_);
714         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
715         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, sellDividendFee_),1000);
716         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
717         return _taxedEthereum;
718     }
719     
720     
721     /*==========================================
722     =            INTERNAL FUNCTIONS            =
723     ==========================================*/
724 
725 
726     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
727         antiEarlyWhale(_incomingEthereum)
728         onlyActive()
729         internal
730         returns(uint256)
731     {
732         // data setup
733 
734         // setup data
735 
736         if (mkt1 != 0x0 && mkt1Rate != 0){
737             ownerAccounts[mkt1] = SafeMath.add(ownerAccounts[mkt1] , SafeMath.div(SafeMath.mul(msg.value, mkt1Rate), 1000));
738             _incomingEthereum = SafeMath.sub(_incomingEthereum, SafeMath.div(SafeMath.mul(msg.value, mkt1Rate), 1000));
739         }
740 
741         if (mkt2 != 0x0 && mkt2Rate != 0){
742             ownerAccounts[mkt2] = SafeMath.add(ownerAccounts[mkt2] , SafeMath.div(SafeMath.mul(msg.value, mkt2Rate), 1000));
743             _incomingEthereum = SafeMath.sub(_incomingEthereum, SafeMath.div(SafeMath.mul(msg.value, mkt2Rate), 1000));
744         }
745         
746         if (mkt3 != 0x0 && mkt3Rate != 0){
747             ownerAccounts[mkt3] = SafeMath.add(ownerAccounts[mkt3] , SafeMath.div(SafeMath.mul(msg.value, mkt3Rate), 1000));
748             _incomingEthereum = SafeMath.sub(_incomingEthereum, SafeMath.div(SafeMath.mul(msg.value, mkt3Rate), 1000));
749         }
750     
751 
752         uint256 _referralBonus = SafeMath.div(SafeMath.div(SafeMath.mul(_incomingEthereum, buyDividendFee_  ),1000), 3);
753         uint256 _dividends = SafeMath.sub(SafeMath.div(SafeMath.mul(_incomingEthereum, buyDividendFee_  ),1000), _referralBonus);
754         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, buyDividendFee_),1000));
755         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
756         uint256 _fee = _dividends * magnitude;
757 
758       
759 
760  
761         // no point in continuing execution if OP is a poorfag russian hacker
762         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
763         // (or hackers)
764         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
765         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
766         
767         // is the user referred by a masternode?
768         if(
769             // is this a referred purchase?
770             _referredBy != 0x0000000000000000000000000000000000000000 &&
771 
772             // no cheating!
773             _referredBy != msg.sender &&
774             
775             // does the referrer have at least X whole tokens?
776             // i.e is the referrer a godly chad masternode
777             tokenBalanceLedger_[_referredBy] >= stakingRequirement
778         ){
779             // wealth redistribution
780             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
781         } else {
782             // no ref purchase
783             // add the referral bonus back to the global dividends cake
784             _dividends = SafeMath.add(_dividends, _referralBonus);
785             _fee = _dividends * magnitude;
786         }
787         
788         // we can't give people infinite ethereum
789         if(tokenSupply_ > 0){
790             
791             // add tokens to the pool
792             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
793  
794             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
795             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
796             
797             // calculate the amount of tokens the customer receives over his purchase 
798             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
799         
800         } else {
801             // add tokens to the pool
802             tokenSupply_ = _amountOfTokens;
803         }
804         
805         // update circulating supply & the ledger address for the customer
806         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
807         
808         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
809         //really i know you think you do but you don't
810         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
811         payoutsTo_[msg.sender] += _updatedPayouts;
812 
813      
814         // fire event
815         onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
816         
817         return _amountOfTokens;
818     }
819 
820 
821     /**
822      * Calculate Token price based on an amount of incoming ethereum
823      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
824      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
825      */
826     function ethereumToTokens_(uint256 _ethereum)
827         internal
828         view
829         returns(uint256)
830     {
831         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
832         uint256 _tokensReceived = 
833          (
834             (
835                 // underflow attempts BTFO
836                 SafeMath.sub(
837                     (sqrt
838                         (
839                             (_tokenPriceInitial**2)
840                             +
841                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
842                             +
843                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
844                             +
845                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
846                         )
847                     ), _tokenPriceInitial
848                 )
849             )/(tokenPriceIncremental_)
850         )-(tokenSupply_)
851         ;
852   
853         return _tokensReceived;
854     }
855     
856     /**
857      * Calculate token sell value.
858      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
859      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
860      */
861      function tokensToEthereum_(uint256 _tokens)
862         internal
863         view
864         returns(uint256)
865     {
866 
867         uint256 tokens_ = (_tokens + 1e18);
868         uint256 _tokenSupply = (tokenSupply_ + 1e18);
869         uint256 _etherReceived =
870         (
871             // underflow attempts BTFO
872             SafeMath.sub(
873                 (
874                     (
875                         (
876                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
877                         )-tokenPriceIncremental_
878                     )*(tokens_ - 1e18)
879                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
880             )
881         /1e18);
882         return _etherReceived;
883     }
884 
885   
886     //This is where all your gas goes, sorry
887     //Not sorry, you probably only paid 1 gwei
888     function sqrt(uint x) internal pure returns (uint y) {
889         uint z = (x + 1) / 2;
890         y = x;
891         while (z < y) {
892             y = z;
893             z = (x / z + z) / 2;
894         }
895     }
896 }
897 
898 /**
899  * @title SafeMath
900  * @dev Math operations with safety checks that throw on error
901  */
902 library SafeMath {
903 
904     /**
905     * @dev Multiplies two numbers, throws on overflow.
906     */
907     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
908         if (a == 0) {
909             return 0;
910         }
911         uint256 c = a * b;
912         assert(c / a == b);
913         return c;
914     }
915 
916     /**
917     * @dev Integer division of two numbers, truncating the quotient.
918     */
919     function div(uint256 a, uint256 b) internal pure returns (uint256) {
920         // assert(b > 0); // Solidity automatically throws when dividing by 0
921         uint256 c = a / b;
922         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
923         return c;
924     }
925 
926     /**
927     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
928     */
929     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
930         assert(b <= a);
931         return a - b;
932     }
933 
934     /**
935     * @dev Adds two numbers, throws on overflow.
936     */
937     function add(uint256 a, uint256 b) internal pure returns (uint256) {
938         uint256 c = a + b;
939         assert(c >= a);
940         return c;
941     }
942 }