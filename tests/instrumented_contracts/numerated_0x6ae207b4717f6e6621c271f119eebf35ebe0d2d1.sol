1 pragma solidity ^0.4.25;
2 
3 /*
4 
5 
6 ███████╗████████╗██╗  ██╗    ███████╗ ██████╗ ██████╗ ████████╗███╗   ██╗██╗████████╗███████╗
7 ██╔════╝╚══██╔══╝██║  ██║    ██╔════╝██╔═══██╗██╔══██╗╚══██╔══╝████╗  ██║██║╚══██╔══╝██╔════╝
8 █████╗     ██║   ███████║    █████╗  ██║   ██║██████╔╝   ██║   ██╔██╗ ██║██║   ██║   █████╗  
9 ██╔══╝     ██║   ██╔══██║    ██╔══╝  ██║   ██║██╔══██╗   ██║   ██║╚██╗██║██║   ██║   ██╔══╝  
10 ███████╗   ██║   ██║  ██║    ██║     ╚██████╔╝██║  ██║   ██║   ██║ ╚████║██║   ██║   ███████╗
11 ╚══════╝   ╚═╝   ╚═╝  ╚═╝    ╚═╝      ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═══╝╚═╝   ╚═╝   ╚══════╝
12                                                                                              
13 
14 
15 
16 website:       https://ethfortnite.com
17 
18 discord:       https://discord.gg/hbbf2cZ
19 
20 20% Dividends Fees/Payouts for Exchange
21 
22 Win the Golden Chest Jackpot..........
23 
24 Players are rewarded with the ETH Threshold Jackpot when their Buy causes the total ETH 
25 Balance to cross the next ETH Threshold.
26 
27 ETH Thresholds are every 5 ETH:   5,10,15,20,...
28 
29 Whether you spend 5 ETH or 0.005 ETH to cross you win the jackpot.
30 
31 ETH Threshold jackpot is funded with 10% of the BUY/SELL transactions
32 
33 More Games and Challenges coming to ETHFORTNITE.COM SOON!!!!
34 
35 */
36 
37 contract AcceptsExchange {
38     ethfortnite public tokenContract;
39 
40     function AcceptsExchange(address _tokenContract) public {
41         tokenContract = ethfortnite(_tokenContract);
42     }
43 
44     modifier onlyTokenContract {
45         require(msg.sender == address(tokenContract));
46         _;
47     }
48 
49     /**
50     * @dev Standard ERC677 function that will handle incoming token transfers.
51     *
52     * @param _from  Token sender address.
53     * @param _value Amount of tokens.
54     * @param _data  Transaction metadata.
55     */
56     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
57     function tokenFallbackExpanded(address _from, uint256 _value, bytes _data, address _sender, address _referrer) external returns (bool);
58 }
59 
60 contract ethfortnite {
61     /*=================================
62     =            MODIFIERS            =
63     =================================*/
64     // only people with tokens
65     modifier onlyBagholders() {
66         require(myTokens() > 0);
67         _;
68     }
69     
70     // only people with profits
71     modifier onlyStronghands() {
72         require(myDividends(true) > 0 || ownerAccounts[msg.sender] > 0);
73         //require(myDividends(true) > 0);
74         _;
75     }
76     
77       modifier notContract() {
78       require (msg.sender == tx.origin);
79       _;
80     }
81 
82     modifier allowPlayer(){
83         
84         require(boolAllowPlayer);
85         _;
86     }
87 
88     // administrators can:
89     // -> change the name of the contract
90     // -> change the name of the token
91     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
92     // they CANNOT:
93     // -> take funds
94     // -> disable withdrawals
95     // -> kill the contract
96     // -> change the price of tokens
97     modifier onlyAdministrator(){
98         address _customerAddress = msg.sender;
99         require(administrators[_customerAddress]);
100         _;
101     }
102     
103     modifier onlyActive(){
104         require(boolContractActive);
105         _;
106     }
107 
108     // ensures that the first tokens in the contract will be equally distributed
109     // meaning, no divine dump will be ever possible
110     // result: healthy longevity.
111     modifier antiEarlyWhale(uint256 _amountOfEthereum){
112         address _customerAddress = msg.sender;
113         
114         // are we still in the vulnerable phase?
115         // if so, enact anti early whale protocol 
116         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
117             require(
118                 // is the customer in the ambassador list?
119                 (ambassadors_[_customerAddress] == true &&
120                 
121                 // does the customer purchase exceed the max ambassador quota?
122                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_) ||
123 
124                 (_customerAddress == dev)
125                 
126             );
127             
128             // updated the accumulated quota    
129             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
130         
131             // execute
132             _;
133         } else {
134             // in case the ether count drops low, the ambassador phase won't reinitiate
135             onlyAmbassadors = false;
136             _;    
137         }
138         
139     }
140     
141     /*==============================
142     =            EVENTS            =
143     ==============================*/
144 
145     event onTokenPurchase(
146         address indexed customerAddress,
147         uint256 incomingEthereum,
148         uint256 tokensMinted,
149         address indexed referredBy
150     );
151     
152     event onTokenSell(
153         address indexed customerAddress,
154         uint256 tokensBurned,
155         uint256 ethereumEarned
156     );
157     
158     event onReinvestment(
159         address indexed customerAddress,
160         uint256 ethereumReinvested,
161         uint256 tokensMinted
162     );
163     
164     event onWithdraw(
165         address indexed customerAddress,
166         uint256 ethereumWithdrawn
167     );
168     
169     // ERC20
170     event Transfer(
171         address indexed from,
172         address indexed to,
173         uint256 tokens
174     );
175 
176      // JackPot
177     event onJackpot(
178         address indexed customerAddress,
179         uint indexed value,
180         uint indexed nextThreshold
181     );
182     
183 
184     
185     /*=====================================
186     =            CONFIGURABLES            =
187     =====================================*/
188     string public name = "ETH FORTNITE";
189     string public symbol = "LOOT";
190     uint8 constant public decimals = 18;
191     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
192     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
193     uint256 constant internal magnitude = 2**64;
194     
195     // proof of stake (defaults at 100 tokens)
196     uint256 public stakingRequirement = 100e18;
197     
198     // ambassador program
199     mapping(address => bool) internal ambassadors_;
200     uint256 constant internal ambassadorMaxPurchase_ = 2 ether;
201     uint256 constant internal ambassadorQuota_ = 20 ether;
202     
203     address dev;
204 
205     bool public boolAllowPlayer = false;
206 
207    /*================================
208     =            DATASETS            =
209     ================================*/
210     // amount of shares for each address (scaled number)
211     mapping(address => uint256) internal tokenBalanceLedger_;
212     mapping(address => uint256) internal referralBalance_;
213     mapping(address => int256) internal payoutsTo_;
214     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
215     uint256 internal tokenSupply_ = 0;
216     uint256 internal profitPerShare_;
217 
218     mapping(address => uint) internal ownerAccounts;
219 
220     bool public allowReferral = false;  //for cards
221 
222     uint8 public buyDividendFee_ = 200;  
223     uint8 public sellDividendFee_ = 200;           
224 
225     bool public boolContractActive = false;
226 
227     // administrator list (see above on what they can do)
228     mapping(address => bool) public administrators;
229     
230     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
231     bool public onlyAmbassadors = true;
232 
233       // Special Wall Street Market Platform control from scam game contracts on Wall Street Market platform
234     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept Wall Street tokens
235 
236     //ETH Jackpot
237     uint public jackpotThreshold = 5 ether;
238     uint public jackpotAccount = 0;
239     uint public jackpotFeeRate = 100;   //10%
240     uint public jackpotPayRate = 900;  //100%
241     uint public jackpotThreshIncrease = 5 ether;
242 
243     address mkt1 = 0x0;
244     address mkt2 = 0x0;
245     address mkt3 = 0x0;   
246 
247     uint mkt1Rate = 0;   
248     uint mkt2Rate = 0;
249     uint mkt3Rate = 0;
250 
251 
252 
253     /*=======================================
254     =            PUBLIC FUNCTIONS            =
255     =======================================*/
256     /*
257     * -- APPLICATION ENTRY POINTS --  
258     */
259     function ethfortnite()
260     public
261     {
262      
263         // add administrators here
264         administrators[msg.sender] = true;
265         dev = msg.sender;
266 
267         ambassadors_[dev] = true;
268         
269     }
270     
271      
272     /**
273      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
274      */
275     function buy(address _referredBy)
276         public
277         payable
278         returns(uint256)
279     {
280         purchaseTokens(msg.value, _referredBy);
281     }
282     
283     /**
284      * Fallback function to handle ethereum that was send straight to the contract
285      * Unfortunately we cannot use a referral address this way.
286      */
287     function()
288         payable
289         public
290     {
291         purchaseTokens(msg.value, 0x0);
292     }
293     
294     /**
295      * Converts all of caller's dividends to tokens.
296      */
297     function reinvest()
298         onlyStronghands()
299         public
300     {
301         // fetch dividends
302         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
303         
304         // pay out the dividends virtually
305         address _customerAddress = msg.sender;
306         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
307         
308         // retrieve ref. bonus
309         _dividends += referralBalance_[_customerAddress] + ownerAccounts[_customerAddress];
310         referralBalance_[_customerAddress] = 0;
311         ownerAccounts[_customerAddress] = 0;
312         
313         // dispatch a buy order with the virtualized "withdrawn dividends"
314         uint256 _tokens = purchaseTokens(_dividends, 0x0);
315         
316         // fire event
317         onReinvestment(_customerAddress, _dividends, _tokens);
318       
319     }
320     
321     /**
322      * Alias of sell() and withdraw().
323      */
324     function exit()
325         public
326     {
327         // get token count for caller & sell them all
328         address _customerAddress = msg.sender;
329         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
330         if(_tokens > 0) sell(_tokens);
331         
332         // lambo delivery service
333         withdraw();
334    
335     }
336 
337     /**
338      * Withdraws all of the callers earnings.
339      */
340     function withdraw()
341         onlyStronghands()
342         public
343     {
344         // setup data
345         address _customerAddress = msg.sender;
346         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
347         
348         // update dividend tracker
349         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
350         
351         // add ref. bonus
352         _dividends += referralBalance_[_customerAddress] + ownerAccounts[_customerAddress];
353         referralBalance_[_customerAddress] = 0;
354         ownerAccounts[_customerAddress] = 0;
355         
356         // lambo delivery service
357         _customerAddress.transfer(_dividends);
358         
359         // fire event
360         onWithdraw(_customerAddress, _dividends);
361     
362     }
363     
364     /**
365      * Liquifies tokens to ethereum.
366      */
367     function sell(uint256 _amountOfTokens)
368     
369         onlyBagholders()
370         public
371     {
372         // setup data
373         uint8 localDivFee = 200;
374    
375 
376         address _customerAddress = msg.sender;
377         // russian hackers BTFO
378         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
379 
380       
381 
382         uint256 _tokens = _amountOfTokens;
383         uint256 _ethereum = tokensToEthereum_(_tokens);
384 
385         if (mkt1 != 0x0 && mkt1Rate != 0){
386             ownerAccounts[mkt1] = SafeMath.add(ownerAccounts[mkt1] , SafeMath.div(SafeMath.mul(_ethereum, mkt1Rate), 1000));
387             _ethereum = SafeMath.sub(_ethereum, SafeMath.div(SafeMath.mul(_ethereum, mkt1Rate), 1000));
388         }
389 
390         if (mkt2 != 0x0 && mkt2Rate != 0){
391             ownerAccounts[mkt2] = SafeMath.add(ownerAccounts[mkt2] , SafeMath.div(SafeMath.mul(_ethereum, mkt2Rate), 1000));
392             _ethereum = SafeMath.sub(_ethereum, SafeMath.div(SafeMath.mul(_ethereum, mkt2Rate), 1000));
393         }
394         
395         if (mkt3 != 0x0 && mkt3Rate != 0){
396             ownerAccounts[mkt3] = SafeMath.add(ownerAccounts[mkt3] , SafeMath.div(SafeMath.mul(_ethereum, mkt3Rate), 1000));
397             _ethereum = SafeMath.sub(_ethereum, SafeMath.div(SafeMath.mul(_ethereum, mkt3Rate), 1000));
398         }
399 
400         jackpotAccount = SafeMath.add(SafeMath.div(SafeMath.mul(_ethereum,jackpotFeeRate),1000),jackpotAccount);
401 
402         _ethereum = SafeMath.sub(_ethereum, SafeMath.div(SafeMath.mul(_ethereum,jackpotFeeRate),1000));
403 
404         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, sellDividendFee_),1000);
405         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
406         
407         // burn the sold tokens
408         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
409         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
410         
411         // update dividends tracker
412         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
413         payoutsTo_[_customerAddress] -= _updatedPayouts;       
414         
415         // dividing by zero is a bad idea
416         if (tokenSupply_ > 0) {
417             // update the amount of dividends per token
418             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
419         }
420 
421     
422         // fire event
423         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
424     }
425     
426     
427     /**
428      * Transfer tokens from the caller to a new holder.
429      * Remember, there's a 10% fee here as well.
430      */
431     function transfer(address _toAddress, uint256 _amountOfTokens)
432         onlyBagholders()
433         public
434         returns(bool)
435     {
436         // setup
437         address _customerAddress = msg.sender;
438 
439         uint8 localDivFee = 200;
440 
441         
442         // make sure we have the requested tokens
443         // also disables transfers until ambassador phase is over
444         // ( we dont want whale premines )
445         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
446         
447         // withdraw all outstanding dividends first
448         if(myDividends(true) > 0) withdraw();
449         
450         // liquify 20% of the tokens that are transfered
451         // these are dispersed to shareholders
452         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, localDivFee),1000);
453         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
454         uint256 _dividends = tokensToEthereum_(_tokenFee);
455   
456         // burn the fee tokens
457         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
458 
459         // exchange tokens
460         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
461         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
462         
463         // update dividend trackers
464         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
465         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
466         
467         // disperse dividends among holders
468         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
469         
470         // fire event
471         Transfer(_customerAddress, _toAddress, _taxedTokens);
472         
473         // ERC20
474         return true;
475        
476     }
477     
478     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
479     /**
480      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
481      */
482     function disableInitialStage()
483         onlyAdministrator()
484         public
485     {
486         onlyAmbassadors = false;
487     }
488     
489     /**
490      * In case one of us dies, we need to replace ourselves.
491      */
492     function setAdministrator(address _identifier, bool _status)
493         onlyAdministrator()
494         public
495     {
496         administrators[_identifier] = _status;
497     }
498 
499  
500 
501     /**
502     * Set Exchange Rates
503     */
504     function setExchangeRates(uint8 _newBuyFee, uint8 _newSellFee)
505         onlyAdministrator()
506         public
507     {
508         require(_newBuyFee <= 400);   //40%
509         require(_newSellFee <= 400);   //40%
510 
511         buyDividendFee_ = _newBuyFee;
512         sellDividendFee_ = _newSellFee;
513     
514     }
515 
516 /**
517     * Set Marketing Rates
518     */
519     function setMarketingRates(uint8 _newMkt1Rate, uint8 _newMkt2Rate, uint8 _newMkt3Rate)
520         onlyAdministrator()
521         public
522     {
523         require(_newMkt1Rate +_newMkt2Rate +_newMkt3Rate <= 180); 
524        
525         mkt1Rate =  _newMkt1Rate;
526         mkt2Rate =  _newMkt2Rate;
527         mkt3Rate =  _newMkt3Rate;
528 
529     }
530 
531     /**
532     * Set Mkt1 Address
533     */
534     function setMarket1(address _newMkt1)
535         onlyAdministrator()
536         public
537     {
538       
539         mkt1 =  _newMkt1;
540      
541     }
542 
543     /**
544     * Set Mkt2 Address
545     */
546     function setMarket2(address _newMkt2)
547         onlyAdministrator()
548         public
549     {
550       
551         mkt2 =  _newMkt2;
552      
553     }
554 
555     /**
556     * Set Mkt3 Address
557     */
558     function setMarket3(address _newMkt3)
559         onlyAdministrator()
560         public
561     {
562       
563         mkt3 =  _newMkt3;
564      
565     }
566 
567     /**
568      * In case one of us dies, we need to replace ourselves.
569      */
570     function setContractActive(bool _status)
571         onlyAdministrator()
572         public
573     {
574         boolContractActive = _status;
575     }
576 
577     /**
578      * Precautionary measures in case we need to adjust the masternode rate.
579      */
580     function setStakingRequirement(uint256 _amountOfTokens)
581         onlyAdministrator()
582         public
583     {
584         stakingRequirement = _amountOfTokens;
585     }
586     
587     /**
588      * If we want to rebrand, we can.
589      */
590     function setName(string _name)
591         onlyAdministrator()
592         public
593     {
594         name = _name;
595     }
596     
597     /**
598      * If we want to rebrand, we can.
599      */
600     function setSymbol(string _symbol)
601         onlyAdministrator()
602         public
603     {
604         symbol = _symbol;
605     }
606 
607     function addAmbassador(address _newAmbassador) 
608         onlyAdministrator()
609         public
610     {
611         ambassadors_[_newAmbassador] = true;
612     }
613 
614 
615     /**
616     * Set Jackpot PayRate
617     */
618     function setJackpotFeeRate(uint256 _newFeeRate)
619         onlyAdministrator()
620         public
621     {
622         require(_newFeeRate <= 400);
623         jackpotFeeRate = _newFeeRate;
624     }
625 
626     
627     /**
628     * Set Jackpot PayRate
629     */
630     function setJackpotPayRate(uint256 _newPayRate)
631         onlyAdministrator()
632         public
633     {
634         jackpotPayRate = _newPayRate;
635     }
636 
637     /**
638     * Set Jackpot Increment
639     */
640     function setJackpotIncrement(uint256 _newIncrement)
641         onlyAdministrator()
642         public
643     {
644         jackpotThreshIncrease = _newIncrement;
645     }
646 
647     /**
648     * Set Jackpot Threshold Level
649     */
650     function setJackpotThreshold(uint256 _newTarget)
651         onlyAdministrator()
652         public
653     {
654         jackpotThreshold = _newTarget;
655     }
656 
657 
658     
659     /*----------  HELPERS AND CALCULATORS  ----------*/
660     /**
661      * Method to view the current Ethereum stored in the contract
662      * Example: totalEthereumBalance()
663      */
664     function totalEthereumBalance()
665         public
666         view
667         returns(uint)
668     {
669         return address(this).balance;
670     }
671     
672     /**
673      * Retrieve the total token supply.
674      */
675     function totalSupply()
676         public
677         view
678         returns(uint256)
679     {
680         return tokenSupply_;
681     }
682     
683     /**
684      * Retrieve the tokens owned by the caller.
685      */
686     function myTokens()
687         public
688         view
689         returns(uint256)
690     {
691         address _customerAddress = msg.sender;
692         return balanceOf(_customerAddress);
693     }
694     
695     /**
696      * Retrieve the dividends owned by the caller.
697      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
698      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
699      * But in the internal calculations, we want them separate. 
700      */ 
701     function myDividends(bool _includeReferralBonus) 
702         public 
703         view 
704         returns(uint256)
705     {
706         address _customerAddress = msg.sender;
707         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
708     }
709 
710     function myCardDividends()
711         public
712         view
713         returns(uint256)
714     {
715         address _customerAddress = msg.sender;
716         return ownerAccounts[_customerAddress];
717     }
718     
719     /**
720      * Retrieve the token balance of any single address.
721      */
722     function balanceOf(address _customerAddress)
723         view
724         public
725         returns(uint256)
726     {
727         return tokenBalanceLedger_[_customerAddress];
728     }
729     
730     /**
731      * Retrieve the dividend balance of any single address.
732      */
733     function dividendsOf(address _customerAddress)
734         view
735         public
736         returns(uint256)
737     {
738         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
739     }
740 
741 
742     function getData() 
743         //Ethereum Balance, MyTokens, TotalTokens, myDividends, myRefDividends, jackpot, jackpotThreshold
744         public 
745         view 
746         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256)
747     {
748         return(address(this).balance, balanceOf(msg.sender), tokenSupply_, dividendsOf(msg.sender) + ownerAccounts[msg.sender], referralBalance_[msg.sender], jackpotAccount, jackpotThreshold);
749     }
750 
751 
752     
753     /**
754      * Return the buy price of 1 individual token.
755      */
756     function sellPrice() 
757         public 
758         view 
759         returns(uint256)
760     {
761         // our calculation relies on the token supply, so we need supply. Doh.
762         if(tokenSupply_ == 0){
763             return tokenPriceInitial_ - tokenPriceIncremental_;
764         } else {
765             uint256 _ethereum = tokensToEthereum_(1e18);
766             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, sellDividendFee_),1000);
767             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
768             return _taxedEthereum;
769         }
770     }
771     
772     /**
773      * Return the sell price of 1 individual token.
774      */
775     function buyPrice() 
776         public 
777         view 
778         returns(uint256)
779     {
780         // our calculation relies on the token supply, so we need supply. Doh.
781         if(tokenSupply_ == 0){
782             return tokenPriceInitial_ + tokenPriceIncremental_;
783         } else {
784             uint256 _ethereum = tokensToEthereum_(1e18);
785             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, buyDividendFee_),1000);
786             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
787             return _taxedEthereum;
788         }
789     }
790     
791     /**
792      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
793      */
794     function calculateTokensReceived(uint256 _ethereumToSpend) 
795         public 
796         view 
797         returns(uint256)
798     {
799         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, buyDividendFee_),1000);
800         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
801         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
802         
803         return _amountOfTokens;
804     }
805     
806     /**
807      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
808      */
809     function calculateEthereumReceived(uint256 _tokensToSell) 
810         public 
811         view 
812         returns(uint256)
813     {
814         require(_tokensToSell <= tokenSupply_);
815         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
816         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, sellDividendFee_),1000);
817         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
818         return _taxedEthereum;
819     }
820     
821     
822     /*==========================================
823     =            INTERNAL FUNCTIONS            =
824     ==========================================*/
825 
826 
827     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
828         antiEarlyWhale(_incomingEthereum)
829         onlyActive()
830         internal
831         returns(uint256)
832     {
833         // data setup
834 
835         // setup data
836 
837 
838         if (mkt1 != 0x0 && mkt1Rate != 0){
839             ownerAccounts[mkt1] = SafeMath.add(ownerAccounts[mkt1] , SafeMath.div(SafeMath.mul(msg.value, mkt1Rate), 1000));
840             _incomingEthereum = SafeMath.sub(_incomingEthereum, SafeMath.div(SafeMath.mul(msg.value, mkt1Rate), 1000));
841         }
842 
843         if (mkt2 != 0x0 && mkt2Rate != 0){
844             ownerAccounts[mkt2] = SafeMath.add(ownerAccounts[mkt2] , SafeMath.div(SafeMath.mul(msg.value, mkt2Rate), 1000));
845             _incomingEthereum = SafeMath.sub(_incomingEthereum, SafeMath.div(SafeMath.mul(msg.value, mkt2Rate), 1000));
846         }
847         
848         if (mkt3 != 0x0 && mkt3Rate != 0){
849             ownerAccounts[mkt3] = SafeMath.add(ownerAccounts[mkt3] , SafeMath.div(SafeMath.mul(msg.value, mkt3Rate), 1000));
850             _incomingEthereum = SafeMath.sub(_incomingEthereum, SafeMath.div(SafeMath.mul(msg.value, mkt3Rate), 1000));
851         }
852 
853           //check for jackpot win
854         if (address(this).balance >= jackpotThreshold){
855             jackpotThreshold = address(this).balance + jackpotThreshIncrease;
856             onJackpot(msg.sender, SafeMath.div(SafeMath.mul(jackpotAccount,jackpotPayRate),1000), jackpotThreshold);
857             ownerAccounts[msg.sender] = SafeMath.add(ownerAccounts[msg.sender], SafeMath.div(SafeMath.mul(jackpotAccount,jackpotPayRate),1000));
858             
859             jackpotAccount = SafeMath.sub(jackpotAccount,SafeMath.div(SafeMath.mul(jackpotAccount,jackpotPayRate),1000));
860             
861         } else {
862             jackpotAccount = SafeMath.add(SafeMath.div(SafeMath.mul(_incomingEthereum,jackpotFeeRate),1000),jackpotAccount);
863             _incomingEthereum = SafeMath.sub(_incomingEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum,jackpotFeeRate),1000));
864             //SafeMath.div(SafeMath.mul(_incomingEthereum,jackpotFeeRate),1000);
865         }
866 
867         uint256 _referralBonus = SafeMath.div(SafeMath.div(SafeMath.mul(_incomingEthereum, buyDividendFee_  ),1000), 3);
868         uint256 _dividends = SafeMath.sub(SafeMath.div(SafeMath.mul(_incomingEthereum, buyDividendFee_  ),1000), _referralBonus);
869         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, buyDividendFee_),1000));
870         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
871         uint256 _fee = _dividends * magnitude;
872 
873       
874 
875  
876         // no point in continuing execution if OP is a poorfag russian hacker
877         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
878         // (or hackers)
879         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
880         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
881         
882         // is the user referred by a masternode?
883         if(
884             // is this a referred purchase?
885             _referredBy != 0x0000000000000000000000000000000000000000 &&
886 
887             // no cheating!
888             _referredBy != msg.sender &&
889             
890             // does the referrer have at least X whole tokens?
891             // i.e is the referrer a godly chad masternode
892             tokenBalanceLedger_[_referredBy] >= stakingRequirement
893         ){
894             // wealth redistribution
895             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
896         } else {
897             // no ref purchase
898             // add the referral bonus back to the global dividends cake
899             _dividends = SafeMath.add(_dividends, _referralBonus);
900             _fee = _dividends * magnitude;
901         }
902         
903         // we can't give people infinite ethereum
904         if(tokenSupply_ > 0){
905             
906             // add tokens to the pool
907             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
908  
909             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
910             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
911             
912             // calculate the amount of tokens the customer receives over his purchase 
913             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
914         
915         } else {
916             // add tokens to the pool
917             tokenSupply_ = _amountOfTokens;
918         }
919         
920         // update circulating supply & the ledger address for the customer
921         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
922         
923         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
924         //really i know you think you do but you don't
925         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
926         payoutsTo_[msg.sender] += _updatedPayouts;
927 
928      
929         // fire event
930         onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
931         
932         return _amountOfTokens;
933     }
934 
935 
936     /**
937      * Calculate Token price based on an amount of incoming ethereum
938      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
939      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
940      */
941     function ethereumToTokens_(uint256 _ethereum)
942         internal
943         view
944         returns(uint256)
945     {
946         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
947         uint256 _tokensReceived = 
948          (
949             (
950                 // underflow attempts BTFO
951                 SafeMath.sub(
952                     (sqrt
953                         (
954                             (_tokenPriceInitial**2)
955                             +
956                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
957                             +
958                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
959                             +
960                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
961                         )
962                     ), _tokenPriceInitial
963                 )
964             )/(tokenPriceIncremental_)
965         )-(tokenSupply_)
966         ;
967   
968         return _tokensReceived;
969     }
970     
971     /**
972      * Calculate token sell value.
973      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
974      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
975      */
976      function tokensToEthereum_(uint256 _tokens)
977         internal
978         view
979         returns(uint256)
980     {
981 
982         uint256 tokens_ = (_tokens + 1e18);
983         uint256 _tokenSupply = (tokenSupply_ + 1e18);
984         uint256 _etherReceived =
985         (
986             // underflow attempts BTFO
987             SafeMath.sub(
988                 (
989                     (
990                         (
991                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
992                         )-tokenPriceIncremental_
993                     )*(tokens_ - 1e18)
994                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
995             )
996         /1e18);
997         return _etherReceived;
998     }
999 
1000   
1001     //This is where all your gas goes, sorry
1002     //Not sorry, you probably only paid 1 gwei
1003     function sqrt(uint x) internal pure returns (uint y) {
1004         uint z = (x + 1) / 2;
1005         y = x;
1006         while (z < y) {
1007             y = z;
1008             z = (x / z + z) / 2;
1009         }
1010     }
1011 }
1012 
1013 /**
1014  * @title SafeMath
1015  * @dev Math operations with safety checks that throw on error
1016  */
1017 library SafeMath {
1018 
1019     /**
1020     * @dev Multiplies two numbers, throws on overflow.
1021     */
1022     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1023         if (a == 0) {
1024             return 0;
1025         }
1026         uint256 c = a * b;
1027         assert(c / a == b);
1028         return c;
1029     }
1030 
1031     /**
1032     * @dev Integer division of two numbers, truncating the quotient.
1033     */
1034     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1035         // assert(b > 0); // Solidity automatically throws when dividing by 0
1036         uint256 c = a / b;
1037         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1038         return c;
1039     }
1040 
1041     /**
1042     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1043     */
1044     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1045         assert(b <= a);
1046         return a - b;
1047     }
1048 
1049     /**
1050     * @dev Adds two numbers, throws on overflow.
1051     */
1052     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1053         uint256 c = a + b;
1054         assert(c >= a);
1055         return c;
1056     }
1057 }