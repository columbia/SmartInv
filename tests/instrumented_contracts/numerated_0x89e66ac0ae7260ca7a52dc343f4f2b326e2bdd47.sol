1 pragma solidity ^0.4.25;
2 
3 /*
4 
5 
6    _____                  _        _           _   _          
7   / ____|                | |      | |         | | (_)         
8  | |     _ __ _   _ _ __ | |_ ___ | |__   ___ | |_ _  ___ ___ 
9  | |    | '__| | | | '_ \| __/ _ \| '_ \ / _ \| __| |/ __/ __|
10  | |____| |  | |_| | |_) | || (_) | |_) | (_) | |_| | (__\__ \
11   \_____|_|   \__, | .__/ \__\___/|_.__/ \___/ \__|_|\___|___/
12                __/ | |                                        
13               |___/|_|                                        
14 
15 
16  Presents........
17 
18 
19 
20  ____   _______  _______  ___   __    _  ___   _______  ___  
21 |    | |  _    ||       ||   | |  |  | ||   | |       ||   | 
22  |   | | | |   ||    ___||   | |   |_| ||   | |_     _||   | 
23  |   | | | |   ||   |___ |   | |       ||   |   |   |  |   | 
24  |   | | |_|   ||    ___||   | |  _    ||   |   |   |  |   | 
25  |   | |       ||   |    |   | | | |   ||   |   |   |  |   | 
26  |___| |_______||___|    |___| |_|  |__||___|   |___|  |___| 
27                         
28 
29 
30 
31 website:    https://10finiti.com
32 
33 discord:    https://discord.gg/3xKTVhw
34 
35 Daily payout contract that pays 10% of the payout pool to token holders every day.
36 
37 The contract is guaranteed to never go to zero.
38 
39 Players can choose to sell their tokens at ny time but they will forego any further payouts.
40 
41 Fee Structure:
42 
43     84% Daily Payout Pool
44     10% Retained Player Token Value
45     6%  Management Fee
46 
47 */
48 
49 
50 contract AcceptsExchange {
51     tenfiniti public tokenContract;
52 
53     function AcceptsExchange(address _tokenContract) public {
54         tokenContract = tenfiniti(_tokenContract);
55     }
56 
57     modifier onlyTokenContract {
58         require(msg.sender == address(tokenContract));
59         _;
60     }
61 
62     /**
63     * @dev Standard ERC677 function that will handle incoming token transfers.
64     *
65     * @param _from  Token sender address.
66     * @param _value Amount of tokens.
67     * @param _data  Transaction metadata.
68     */
69     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
70     function tokenFallbackExpanded(address _from, uint256 _value, bytes _data, address _sender, address _referrer) external returns (bool);
71 }
72 
73 contract tenfiniti {
74     /*=================================
75     =            MODIFIERS            =
76     =================================*/
77     // only people with tokens
78     modifier onlyBagholders() {
79         require(myTokens() > 0);
80         _;
81     }
82     
83     // only people with profits
84     modifier onlyStronghands() {
85         require(myDividends(true) > 0 || ownerAccounts[msg.sender] > 0);
86         //require(myDividends(true) > 0);
87         _;
88     }
89     
90       modifier notContract() {
91       require (msg.sender == tx.origin);
92       _;
93     }
94 
95     modifier allowPlayer(){
96         
97         require(boolAllowPlayer);
98         _;
99     }
100 
101     // administrators can:
102     // -> change the name of the contract
103     // -> change the name of the token
104     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
105     // they CANNOT:
106     // -> take funds
107     // -> disable withdrawals
108     // -> kill the contract
109     // -> change the price of tokens
110     modifier onlyAdministrator(){
111         address _customerAddress = msg.sender;
112         require(administrators[_customerAddress]);
113         _;
114     }
115     
116     modifier onlyActive(){
117         require(boolContractActive);
118         _;
119     }
120 
121     // ensures that the first tokens in the contract will be equally distributed
122     // meaning, no divine dump will be ever possible
123     // result: healthy longevity.
124     modifier antiEarlyWhale(uint256 _amountOfEthereum){
125         address _customerAddress = msg.sender;
126         
127         // are we still in the vulnerable phase?
128         // if so, enact anti early whale protocol 
129         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
130             require(
131                 // is the customer in the ambassador list?
132                 (ambassadors_[_customerAddress] == true &&
133                 
134                 // does the customer purchase exceed the max ambassador quota?
135                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_) ||
136 
137                 (_customerAddress == manager)
138                 
139             );
140             
141             // updated the accumulated quota    
142             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
143         
144             // execute
145             _;
146         } else {
147             // in case the ether count drops low, the ambassador phase won't reinitiate
148             onlyAmbassadors = false;
149             _;    
150         }
151         
152     }
153     
154     /*==============================
155     =            EVENTS            =
156     ==============================*/
157 
158 
159     event onTokenPurchase(
160         address indexed customerAddress,
161         uint256 incomingEthereum,
162         uint256 tokensMinted,
163         address indexed referredBy
164     );
165     
166     event onTokenSell(
167         address indexed customerAddress,
168         uint256 tokensBurned,
169         uint256 ethereumEarned
170     );
171     
172     event onReinvestment(
173         address indexed customerAddress,
174         uint256 ethereumReinvested,
175         uint256 tokensMinted
176     );
177     
178     event onWithdraw(
179         address indexed customerAddress,
180         uint256 ethereumWithdrawn
181     );
182     
183     // ERC20
184     event Transfer(
185         address indexed from,
186         address indexed to,
187         uint256 tokens
188     );
189 
190      // JackPot
191     event onJackpot(
192         address indexed customerAddress,
193         uint indexed value,
194         uint indexed nextThreshold
195     );
196 
197 
198      // Daily Payout
199     event dailyPay(
200         uint percent,
201         uint256 amount
202     );
203 
204 
205     /*=====================================
206     =            CONFIGURABLES            =
207     =====================================*/
208     string public name = "10Finiti";
209     string public symbol = "∞";
210     uint8 constant public decimals = 18;
211     uint256 constant internal tokenPriceInitial_ = 0.000000001 ether;
212     uint256 constant internal tokenPriceIncremental_ = 0.0000000001 ether;
213 
214     // uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
215     // uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
216 
217     uint256 constant internal magnitude = 2**64;
218     
219     // proof of stake (defaults at 100 tokens)
220     uint256 public stakingRequirement = 100e18;
221     
222     // ambassador program
223     mapping(address => bool) internal ambassadors_;
224     uint256 internal ambassadorMaxPurchase_ = 2 ether;
225     uint256 internal ambassadorQuota_ = 100 ether;
226     
227     address manager;
228 
229     bool public boolAllowPlayer = false;
230 
231 
232    /*================================
233     =            DATASETS            =
234     ================================*/
235     // amount of shares for each address (scaled number)
236     mapping(address => uint256) internal tokenBalanceLedger_;
237     mapping(address => uint256) internal referralBalance_;
238     mapping(address => int256) internal payoutsTo_;
239     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
240     uint256 internal tokenSupply_ = 0;
241     uint256 internal profitPerShare_;
242 
243     mapping(address => uint) internal ownerAccounts;
244 
245     //Daily Payout
246     uint public payoutFee = 840;      // 84%
247     uint public dailyPayoutPool = 0;
248     uint public payPeriod = 5900;     // 1 day
249     bool boolAllowPayout = true;
250     uint public lastPayoutBlock;
251     uint public lastPayoutAmount = 0;
252     uint payoutPercent = 100;  //10%  This will vary based on amount coming into the contract
253     bool boolVariablePercent = false;
254 
255 
256     uint public buyDividendFee_ = 333;   //33.3%
257     uint public sellDividendFee_ = 333;  //33.3%         
258 
259     bool public boolContractActive = false;
260 
261     // administrator list (see above on what they can do)
262     mapping(address => bool) public administrators;
263     
264     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
265     bool public onlyAmbassadors = true;
266 
267       // Special Wall Street Market Platform control from scam game contracts on Wall Street Market platform
268     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept Wall Street tokens
269 
270     //ETH Jackpot
271     uint public jackpotThreshold = 10 ether;
272     uint public jackpotAccount = 0;
273     uint public jackpotFeeRate = 0;     //    0%
274     uint public jackpotPayRate = 1000;  //  100%
275     uint public jackpotThreshIncrease = 10 ether;
276 
277     uint managerFee = 60;  // 6%
278   
279 
280     /*=======================================
281     =            PUBLIC FUNCTIONS            =
282     =======================================*/
283     /*
284     * -- APPLICATION ENTRY POINTS --  
285     */
286     function tenfiniti()
287     public
288     {
289      
290         // add administrators here
291         administrators[msg.sender] = true;
292         manager = msg.sender;
293         lastPayoutBlock = block.number;
294         
295     }
296     
297     /**
298      * Daily Payout.
299      */
300     function dailyPayout() 
301         internal 
302     {
303 
304         if ((block.number > lastPayoutBlock + payPeriod) && boolAllowPayout){
305 
306             uint dividendsPaid = SafeMath.div(SafeMath.mul(dailyPayoutPool, payoutPercent),1000);
307             dailyPayoutPool = SafeMath.sub(dailyPayoutPool,dividendsPaid);
308             profitPerShare_ += (dividendsPaid * magnitude / (tokenSupply_));
309             emit dailyPay(payoutPercent, dividendsPaid);
310             lastPayoutAmount = dividendsPaid;
311             lastPayoutBlock = block.number;
312 
313         }
314 
315        
316 
317     }
318 
319 
320     // Allow anyone to activate the Daily Payout
321     function checkDailyPayout()
322         public
323     {
324         dailyPayout();
325     }
326 
327 
328     /**
329      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
330      */
331     function buy(address _referredBy)
332         public
333         payable
334         returns(uint256)
335     {
336         purchaseTokens(msg.value, _referredBy);
337     }
338     
339     /**
340      * Fallback function to handle ethereum that was send straight to the contract
341      * Unfortunately we cannot use a referral address this way.
342      */
343     function()
344         payable
345         public
346     {
347         purchaseTokens(msg.value, 0x0);
348     }
349     /**
350      * Converts all of caller's dividends to tokens.
351      */
352     function reinvest()
353         onlyStronghands()
354         public
355     {
356         // fetch dividends
357         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
358         
359         // pay out the dividends virtually
360         address _customerAddress = msg.sender;
361         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
362         
363         // retrieve ref. bonus
364         _dividends += referralBalance_[_customerAddress] + ownerAccounts[_customerAddress];
365         referralBalance_[_customerAddress] = 0;
366         ownerAccounts[_customerAddress] = 0;
367         
368         // dispatch a buy order with the virtualized "withdrawn dividends"
369         uint256 _tokens = purchaseTokens(_dividends, 0x0);
370         
371         // fire event
372         onReinvestment(_customerAddress, _dividends, _tokens);
373       
374     }
375     
376     /**
377      * Alias of sell() and withdraw().
378      */
379     function exit()
380         public
381     {
382         // get token count for caller & sell them all
383         address _customerAddress = msg.sender;
384         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
385         if(_tokens > 0) sell(_tokens);
386         
387         withdraw();
388    
389     }
390 
391     /**
392      * Withdraws all of the callers earnings.
393      */
394     function withdraw()
395         onlyStronghands()
396         public
397     {
398         // setup data
399         address _customerAddress = msg.sender;
400         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
401         
402         // update dividend tracker
403         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
404         
405         // add ref. bonus
406         _dividends += referralBalance_[_customerAddress] + ownerAccounts[_customerAddress];
407         referralBalance_[_customerAddress] = 0;
408         ownerAccounts[_customerAddress] = 0;
409         
410         _customerAddress.transfer(_dividends);
411         
412         // fire event
413         onWithdraw(_customerAddress, _dividends);
414     
415     }
416     
417     /**
418      * Liquifies tokens to ethereum.
419      */
420     function sell(uint256 _amountOfTokens)
421     
422         onlyBagholders()
423         public
424     {
425         // setup data
426 
427         address _customerAddress = msg.sender;
428         // russian hackers BTFO
429         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
430         uint256 _tokens = _amountOfTokens;
431         uint256 _ethereum = tokensToEthereum_(_tokens);
432 
433         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, sellDividendFee_),1000);
434         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
435         
436         // burn the sold tokens
437         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
438         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
439         
440         // update dividends tracker
441         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
442         payoutsTo_[_customerAddress] -= _updatedPayouts;       
443         
444         // dividing by zero is a bad idea
445         if (tokenSupply_ > 0) {
446             // update the amount of dividends per token
447             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
448         }
449 
450         dailyPayout();
451         // fire event
452         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
453     }
454     
455     
456     /**
457      * Transfer tokens from the caller to a new holder.
458      * Remember, there's a 10% fee here as well.
459      */
460     function transfer(address _toAddress, uint256 _amountOfTokens)
461         onlyBagholders()
462         public
463         returns(bool)
464     {
465         // setup
466         address _customerAddress = msg.sender;
467 
468         uint8 localDivFee = 200;
469 
470         // make sure we have the requested tokens
471         // also disables transfers until ambassador phase is over
472         // ( we dont want whale premines )
473         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
474         
475         // withdraw all outstanding dividends first
476         if(myDividends(true) > 0) withdraw();
477         
478         // liquify 20% of the tokens that are transfered
479         // these are dispersed to shareholders
480         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, localDivFee),1000);
481         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
482         uint256 _dividends = tokensToEthereum_(_tokenFee);
483   
484         // burn the fee tokens
485         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
486 
487         // exchange tokens
488         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
489         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
490         
491         // update dividend trackers
492         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
493         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
494         
495         // disperse dividends among holders
496         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
497         
498         // fire event
499         Transfer(_customerAddress, _toAddress, _taxedTokens);
500 
501         dailyPayout();
502         
503         // ERC20
504         return true;
505     }
506     
507     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
508     /**
509      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
510      */
511     function disableInitialStage()
512         onlyAdministrator()
513         public
514     {
515         onlyAmbassadors = false;
516     }
517 
518     /**
519      * In case one of us dies, we need to replace ourselves.
520      */
521     function setAdministrator(address _identifier, bool _status)
522         onlyAdministrator()
523         public
524     {
525         administrators[_identifier] = _status;
526     }
527 
528 
529     /**
530     * Set Exchange Rates
531     */
532     function setExchangeRates(uint _newBuyFee, uint _newSellFee)
533         onlyAdministrator()
534         public
535     {
536         require(_newBuyFee <= 400);   //40%
537         require(_newSellFee <= 400);   //40%
538         buyDividendFee_ = _newBuyFee;
539         sellDividendFee_ = _newSellFee;
540     }
541 
542     /**
543     * Set Rates
544     */
545     function setFeeRates(uint _newManagerFee,  uint _newPayoutFee)
546         onlyAdministrator()
547         public
548     {
549         require(_newManagerFee <= 60);   //6%
550         require(_newManagerFee + _newPayoutFee <= 1000);
551         managerFee = _newManagerFee;
552         payoutFee = _newPayoutFee;
553     }
554 
555     /**
556     * Set PayoutRate
557     */
558     function setPayoutRate(uint _newPayoutRate)
559         onlyAdministrator()
560         public
561     {
562         require(_newPayoutRate <= 100);   //10%
563         require(_newPayoutRate >= 10);   //1%
564         payoutPercent = _newPayoutRate;
565     }
566 
567      /**
568     * Set PayPeriod
569     */
570     function setPayPeriod(uint _newPayPeriod)
571         onlyAdministrator()
572         public
573     {
574         payPeriod = _newPayPeriod;
575     }
576 
577     /**
578     * Set PayoutRate
579     */
580     function setVariablePayout(bool _boolVariablePayout)  //Allow Automatic Payout adjustment
581         onlyAdministrator()
582         public
583     {
584         boolVariablePercent = _boolVariablePayout;
585     }
586 
587     
588     /**
589     * Set Allow Payouts
590     */
591     function setAllowPayout(bool _newAllowPayout)  //Allow Automatic Payout adjustment
592         onlyAdministrator()
593         public
594     {
595         boolAllowPayout = _newAllowPayout;
596     }
597 
598     /**
599      * In case one of us dies, we need to replace ourselves.
600      */
601     function setContractActive(bool _status)
602         onlyAdministrator()
603         public
604     {
605         boolContractActive = _status;
606     }
607 
608     /**
609      * Precautionary measures in case we need to adjust the masternode rate.
610      */
611     function setStakingRequirement(uint256 _amountOfTokens)
612         onlyAdministrator()
613         public
614     {
615         stakingRequirement = _amountOfTokens;
616     }
617     
618     /**
619      * If we want to rebrand, we can.
620      */
621     function setName(string _name)
622         onlyAdministrator()
623         public
624     {
625         name = _name;
626     }
627     
628     /**
629      * If we want to rebrand, we can.
630      */
631     function setSymbol(string _symbol)
632         onlyAdministrator()
633         public
634     {
635         symbol = _symbol;
636     }
637 
638     function addAmbassador(address _newAmbassador) 
639         onlyAdministrator()
640         public
641     {
642         ambassadors_[_newAmbassador] = true;
643     }
644 
645 
646     /**
647     * Set Jackpot PayRate
648     */
649     function setJackpotFeeRate(uint256 _newFeeRate)
650         onlyAdministrator()
651         public
652     {
653         require(_newFeeRate <= 400);
654         jackpotFeeRate = _newFeeRate;
655     }
656 
657     
658     /**
659     * Set Jackpot PayRate
660     */
661     function setJackpotPayRate(uint256 _newPayRate)
662         onlyAdministrator()
663         public
664     {
665         require(_newPayRate >= 500);
666         jackpotPayRate = _newPayRate;
667     }
668 
669     /**
670     * Set Jackpot Increment
671     */
672     function setJackpotIncrement(uint256 _newIncrement)
673         onlyAdministrator()
674         public
675     {
676         require(_newIncrement >= 10 ether);
677         jackpotThreshIncrease = _newIncrement;
678     }
679 
680     /**
681     * Set Jackpot Threshold Level
682     */
683     function setJackpotThreshold(uint256 _newTarget)
684         onlyAdministrator()
685         public
686     {
687         require(_newTarget >= (address(this).balance + jackpotAccount + jackpotThreshIncrease));
688         jackpotThreshold = _newTarget;
689     }
690 
691     /**
692     * Set Quotas
693     */
694     function setQuotas(uint _newMaxPurchase,  uint _newQuota)
695         onlyAdministrator()
696         public
697     {
698     
699         ambassadorMaxPurchase_ = _newMaxPurchase;
700         ambassadorQuota_ = _newQuota;
701     }
702 
703 
704     
705     /*----------  HELPERS AND CALCULATORS  ----------*/
706     /**
707      * Method to view the current Ethereum stored in the contract
708      * Example: totalEthereumBalance()
709      */
710     function totalEthereumBalance()
711         public
712         view
713         returns(uint)
714     {
715         return address(this).balance;
716     }
717     
718     /**
719      * Retrieve the total token supply.
720      */
721     function totalSupply()
722         public
723         view
724         returns(uint256)
725     {
726         return tokenSupply_;
727     }
728     
729     /**
730      * Retrieve the tokens owned by the caller.
731      */
732     function myTokens()
733         public
734         view
735         returns(uint256)
736     {
737         address _customerAddress = msg.sender;
738         return balanceOf(_customerAddress);
739     }
740     
741     /**
742      * Retrieve the dividends owned by the caller.
743      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
744      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
745      * But in the internal calculations, we want them separate. 
746      */ 
747     function myDividends(bool _includeReferralBonus) 
748         public 
749         view 
750         returns(uint256)
751     {
752         address _customerAddress = msg.sender;
753         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
754     }
755 
756     /**
757      * Retrieve the token balance of any single address.
758      */
759     function balanceOf(address _customerAddress)
760         view
761         public
762         returns(uint256)
763     {
764         return tokenBalanceLedger_[_customerAddress];
765     }
766     
767     /**
768      * Retrieve the dividend balance of any single address.
769      */
770     function dividendsOf(address _customerAddress)
771         view
772         public
773         returns(uint256)
774     {
775         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
776     }
777     
778     /**
779      * Return the buy price of 1 individual token.
780      */
781     function sellPrice() 
782         public 
783         view 
784         returns(uint256)
785     {
786         // our calculation relies on the token supply, so we need supply. Doh.
787         if(tokenSupply_ == 0){
788             return tokenPriceInitial_ - tokenPriceIncremental_;
789         } else {
790             uint256 _ethereum = tokensToEthereum_(1e18);
791             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, sellDividendFee_),1000);
792             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
793             return _taxedEthereum;
794         }
795     }
796     
797     /**
798      * Return the sell price of 1 individual token.
799      */
800     function buyPrice() 
801         public 
802         view 
803         returns(uint256)
804     {
805         // our calculation relies on the token supply, so we need supply. Doh.
806         if(tokenSupply_ == 0){
807             return tokenPriceInitial_ + tokenPriceIncremental_;
808         } else {
809             uint256 _ethereum = tokensToEthereum_(1e18);
810             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, buyDividendFee_),1000);
811             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
812             return _taxedEthereum;
813         }
814     }
815 
816     /**
817      * Return the sell price of 1 individual token.
818      */
819     function getData() 
820         //Ethereum Balance, MyTokens, TotalTokens, myDividends, myRefDividends
821         public 
822         view 
823         returns(uint256, uint256, uint256, uint256, uint256)
824     {
825         return(address(this).balance, balanceOf(msg.sender), tokenSupply_, dividendsOf(msg.sender) + ownerAccounts[msg.sender], referralBalance_[msg.sender]);
826     }
827 
828       /**
829      * Return the sell price of 1 individual token.
830      */
831     function getPayoutData() 
832         //Next Payout Block, Last Payout Amount,  PayoutPool
833         public 
834         view 
835         returns(uint256, uint256, uint256, uint256, uint256)
836     {
837 
838         uint nextPayout = SafeMath.div(SafeMath.mul(dailyPayoutPool, payoutPercent),1000);
839 
840         return(lastPayoutBlock + payPeriod, lastPayoutAmount, dailyPayoutPool, lastPayoutBlock - block.number  + payPeriod, nextPayout);
841     }
842     
843     /**
844      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
845      */
846     function calculateTokensReceived(uint256 _ethereumToSpend) 
847         public 
848         view 
849         returns(uint256)
850     {
851         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, buyDividendFee_),1000);
852         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
853         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
854         
855         return _amountOfTokens;
856     }
857     
858     /**
859      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
860      */
861     function calculateEthereumReceived(uint256 _tokensToSell) 
862         public 
863         view 
864         returns(uint256)
865     {
866         require(_tokensToSell <= tokenSupply_);
867         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
868         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, sellDividendFee_),1000);
869         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
870         return _taxedEthereum;
871     }
872     
873     
874     /*==========================================
875     =            INTERNAL FUNCTIONS            =
876     ==========================================*/
877 
878 
879     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
880         antiEarlyWhale(_incomingEthereum)
881         onlyActive()
882         internal
883         returns(uint256)
884     {
885         uint intitialValue = _incomingEthereum;
886 
887         ownerAccounts[manager] = SafeMath.add(ownerAccounts[manager], SafeMath.div(SafeMath.mul(intitialValue, managerFee), 1000));
888         _incomingEthereum = SafeMath.sub(_incomingEthereum, SafeMath.div(SafeMath.mul(intitialValue, managerFee), 1000));
889 
890         dailyPayoutPool = SafeMath.add(dailyPayoutPool, SafeMath.div(SafeMath.mul(intitialValue, payoutFee), 1000)); 
891         _incomingEthereum = SafeMath.sub(_incomingEthereum, SafeMath.div(SafeMath.mul(intitialValue, payoutFee), 1000));
892 
893         uint256 _referralBonus = SafeMath.div(SafeMath.div(SafeMath.mul(_incomingEthereum, buyDividendFee_  ),1000), 3);
894         uint256 _dividends = SafeMath.sub(SafeMath.div(SafeMath.mul(_incomingEthereum, buyDividendFee_  ),1000), _referralBonus);
895         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, buyDividendFee_),1000));
896         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
897         uint256 _fee = _dividends * magnitude;
898 
899 
900         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
901         
902         // is the user referred by a masternode?
903         if(
904             // is this a referred purchase?
905             _referredBy != 0x0000000000000000000000000000000000000000 &&
906 
907             // no cheating!
908             _referredBy != msg.sender &&
909             
910             // does the referrer have at least X whole tokens?
911             // i.e is the referrer a godly chad masternode
912             tokenBalanceLedger_[_referredBy] >= stakingRequirement
913         ){
914             // wealth redistribution
915             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
916         } else {
917             // no ref purchase
918             // add the referral bonus back to the global dividends cake
919             _dividends = SafeMath.add(_dividends, _referralBonus);
920             _fee = _dividends * magnitude;
921         }
922         
923         // we can't give people infinite ethereum
924         if(tokenSupply_ > 0){
925             
926             // add tokens to the pool
927             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
928  
929             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
930             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
931             
932             // calculate the amount of tokens the customer receives over his purchase 
933             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
934         
935         } else {
936             // add tokens to the pool
937             tokenSupply_ = _amountOfTokens;
938         }
939         
940         // update circulating supply & the ledger address for the customer
941         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
942         
943         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
944         //really i know you think you do but you don't
945         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
946         payoutsTo_[msg.sender] += _updatedPayouts;
947 
948      
949         // fire event
950         onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
951         
952         dailyPayout();
953 
954         return _amountOfTokens;
955     }
956 
957 
958     /**
959      * Calculate Token price based on an amount of incoming ethereum
960      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
961      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
962      */
963     function ethereumToTokens_(uint256 _ethereum)
964         internal
965         view
966         returns(uint256)
967     {
968         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
969         uint256 _tokensReceived = 
970          (
971             (
972                 // underflow attempts BTFO
973                 SafeMath.sub(
974                     (sqrt
975                         (
976                             (_tokenPriceInitial**2)
977                             +
978                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
979                             +
980                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
981                             +
982                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
983                         )
984                     ), _tokenPriceInitial
985                 )
986             )/(tokenPriceIncremental_)
987         )-(tokenSupply_)
988         ;
989   
990         return _tokensReceived;
991     }
992     
993     /**
994      * Calculate token sell value.
995      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
996      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
997      */
998      function tokensToEthereum_(uint256 _tokens)
999         internal
1000         view
1001         returns(uint256)
1002     {
1003 
1004         uint256 tokens_ = (_tokens + 1e18);
1005         uint256 _tokenSupply = (tokenSupply_ + 1e18);
1006         uint256 _etherReceived =
1007         (
1008             // underflow attempts BTFO
1009             SafeMath.sub(
1010                 (
1011                     (
1012                         (
1013                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
1014                         )-tokenPriceIncremental_
1015                     )*(tokens_ - 1e18)
1016                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
1017             )
1018         /1e18);
1019         return _etherReceived;
1020     }
1021 
1022   
1023     //This is where all your gas goes, sorry
1024     //Not sorry, you probably only paid 1 gwei
1025     function sqrt(uint x) internal pure returns (uint y) {
1026         uint z = (x + 1) / 2;
1027         y = x;
1028         while (z < y) {
1029             y = z;
1030             z = (x / z + z) / 2;
1031         }
1032     }
1033 }
1034 
1035 /**
1036  * @title SafeMath
1037  * @dev Math operations with safety checks that throw on error
1038  */
1039 library SafeMath {
1040 
1041     /**
1042     * @dev Multiplies two numbers, throws on overflow.
1043     */
1044     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1045         if (a == 0) {
1046             return 0;
1047         }
1048         uint256 c = a * b;
1049         assert(c / a == b);
1050         return c;
1051     }
1052 
1053     /**
1054     * @dev Integer division of two numbers, truncating the quotient.
1055     */
1056     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1057         // assert(b > 0); // Solidity automatically throws when dividing by 0
1058         uint256 c = a / b;
1059         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1060         return c;
1061     }
1062 
1063     /**
1064     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1065     */
1066     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1067         assert(b <= a);
1068         return a - b;
1069     }
1070 
1071     /**
1072     * @dev Adds two numbers, throws on overflow.
1073     */
1074     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1075         uint256 c = a + b;
1076         assert(c >= a);
1077         return c;
1078     }
1079 }