1 pragma solidity ^0.4.25;
2 
3 /*
4 
5 
6  __       __            __  __         ______     __                                     __             ______  
7 |  \  _  |  \          |  \|  \       /      \   |  \                                   |  \           /      \ 
8 | $$ / \ | $$  ______  | $$| $$      |  $$$$$$\ _| $$_     ______    ______    ______  _| $$_         |  $$$$$$\
9 | $$/  $\| $$ |      \ | $$| $$      | $$___\$$|   $$ \   /      \  /      \  /      \|   $$ \         \$$__| $$
10 | $$  $$$\ $$  \$$$$$$\| $$| $$       \$$    \  \$$$$$$  |  $$$$$$\|  $$$$$$\|  $$$$$$\\$$$$$$         /      $$
11 | $$ $$\$$\$$ /      $$| $$| $$       _\$$$$$$\  | $$ __ | $$   \$$| $$    $$| $$    $$ | $$ __       |  $$$$$$ 
12 | $$$$  \$$$$|  $$$$$$$| $$| $$      |  \__| $$  | $$|  \| $$      | $$$$$$$$| $$$$$$$$ | $$|  \      | $$_____ 
13 | $$$    \$$$ \$$    $$| $$| $$       \$$    $$   \$$  $$| $$       \$$     \ \$$     \  \$$  $$      | $$     \
14  \$$      \$$  \$$$$$$$ \$$ \$$        \$$$$$$     \$$$$  \$$        \$$$$$$$  \$$$$$$$   \$$$$        \$$$$$$$$
15                                                                                                                 
16                                                                                                                                                                                                         
17 
18 website:    https://wallstreetmarket.tk
19 
20 discord:    hhttps://discord.gg/FyWtwRT
21 
22 20% Dividends Fees/Payouts for Exchange
23 
24 Win the Stock Split Jackpot..........
25 
26 Players are rewarded with the ETH Threshold Jackpot when their Buy causes the total ETH 
27 Balance to cross the next ETH Threshold.
28 
29 ETH Thresholds are every 5 ETH:   5,10,15,20,...
30 
31 Whether you spend 5 ETH or 0.005 ETH to cross you win the jackpot.
32 
33 ETH Threshold jackpot is funded with 10% of the BUY/SELL transactions
34 
35 Additional Games will include Bonds, Options, and MORE!
36 
37 */
38 
39 contract AcceptsExchange {
40     wallstreet2 public tokenContract;
41 
42     function AcceptsExchange(address _tokenContract) public {
43         tokenContract = wallstreet2(_tokenContract);
44     }
45 
46     modifier onlyTokenContract {
47         require(msg.sender == address(tokenContract));
48         _;
49     }
50 
51     /**
52     * @dev Standard ERC677 function that will handle incoming token transfers.
53     *
54     * @param _from  Token sender address.
55     * @param _value Amount of tokens.
56     * @param _data  Transaction metadata.
57     */
58     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
59     function tokenFallbackExpanded(address _from, uint256 _value, bytes _data, address _sender, address _referrer) external returns (bool);
60 }
61 
62 contract wallstreet2 {
63     /*=================================
64     =            MODIFIERS            =
65     =================================*/
66     // only people with tokens
67     modifier onlyBagholders() {
68         require(myTokens() > 0);
69         _;
70     }
71     
72     // only people with profits
73     modifier onlyStronghands() {
74         require(myDividends(true) > 0 || ownerAccounts[msg.sender] > 0);
75         //require(myDividends(true) > 0);
76         _;
77     }
78     
79       modifier notContract() {
80       require (msg.sender == tx.origin);
81       _;
82     }
83 
84     modifier allowPlayer(){
85         
86         require(boolAllowPlayer);
87         _;
88     }
89 
90     // administrators can:
91     // -> change the name of the contract
92     // -> change the name of the token
93     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
94     // they CANNOT:
95     // -> take funds
96     // -> disable withdrawals
97     // -> kill the contract
98     // -> change the price of tokens
99     modifier onlyAdministrator(){
100         address _customerAddress = msg.sender;
101         require(administrators[_customerAddress]);
102         _;
103     }
104     
105     modifier onlyActive(){
106         require(boolContractActive);
107         _;
108     }
109 
110     // ensures that the first tokens in the contract will be equally distributed
111     // meaning, no divine dump will be ever possible
112     // result: healthy longevity.
113     modifier antiEarlyWhale(uint256 _amountOfEthereum){
114         address _customerAddress = msg.sender;
115         
116         // are we still in the vulnerable phase?
117         // if so, enact anti early whale protocol 
118         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
119             require(
120                 // is the customer in the ambassador list?
121                 (ambassadors_[_customerAddress] == true &&
122                 
123                 // does the customer purchase exceed the max ambassador quota?
124                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_) ||
125 
126                 (_customerAddress == dev)
127                 
128             );
129             
130             // updated the accumulated quota    
131             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
132         
133             // execute
134             _;
135         } else {
136             // in case the ether count drops low, the ambassador phase won't reinitiate
137             onlyAmbassadors = false;
138             _;    
139         }
140         
141     }
142     
143     /*==============================
144     =            EVENTS            =
145     ==============================*/
146 
147     event onTokenPurchase(
148         address indexed customerAddress,
149         uint256 incomingEthereum,
150         uint256 tokensMinted,
151         address indexed referredBy
152     );
153     
154     event onTokenSell(
155         address indexed customerAddress,
156         uint256 tokensBurned,
157         uint256 ethereumEarned
158     );
159     
160     event onReinvestment(
161         address indexed customerAddress,
162         uint256 ethereumReinvested,
163         uint256 tokensMinted
164     );
165     
166     event onWithdraw(
167         address indexed customerAddress,
168         uint256 ethereumWithdrawn
169     );
170     
171     // ERC20
172     event Transfer(
173         address indexed from,
174         address indexed to,
175         uint256 tokens
176     );
177 
178      // JackPot
179     event onJackpot(
180         address indexed customerAddress,
181         uint indexed value,
182         uint indexed nextThreshold
183     );
184     
185 
186     
187     /*=====================================
188     =            CONFIGURABLES            =
189     =====================================*/
190     string public name = "Wall Street 2";
191     string public symbol = "SHARE";
192     uint8 constant public decimals = 18;
193     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
194     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
195     uint256 constant internal magnitude = 2**64;
196     
197     // proof of stake (defaults at 100 tokens)
198     uint256 public stakingRequirement = 100e18;
199     
200     // ambassador program
201     mapping(address => bool) internal ambassadors_;
202     uint256 constant internal ambassadorMaxPurchase_ = 2 ether;
203     uint256 constant internal ambassadorQuota_ = 20 ether;
204     
205     address dev;
206 
207     bool public boolAllowPlayer = false;
208 
209    /*================================
210     =            DATASETS            =
211     ================================*/
212     // amount of shares for each address (scaled number)
213     mapping(address => uint256) internal tokenBalanceLedger_;
214     mapping(address => uint256) internal referralBalance_;
215     mapping(address => int256) internal payoutsTo_;
216     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
217     uint256 internal tokenSupply_ = 0;
218     uint256 internal profitPerShare_;
219 
220     mapping(address => uint) internal ownerAccounts;
221 
222     bool public allowReferral = false;  //for cards
223 
224     uint8 public buyDividendFee_ = 150;  
225     uint8 public sellDividendFee_ = 150;           
226 
227     bool public boolContractActive = false;
228 
229     // administrator list (see above on what they can do)
230     mapping(address => bool) public administrators;
231     
232     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
233     bool public onlyAmbassadors = true;
234 
235       // Special Wall Street Market Platform control from scam game contracts on Wall Street Market platform
236     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept Wall Street tokens
237 
238     //ETH Jackpot
239     uint public jackpotThreshold = 5 ether;
240     uint public jackpotAccount = 0;
241     uint public jackpotFeeRate = 100;   //10%
242     uint public jackpotPayRate = 1000;  //100%
243     uint public jackpotThreshIncrease = 5 ether;
244 
245     address mkt1 = 0x0;
246     address mkt2 = 0x0;
247     address mkt3 = 0x0;   
248 
249     uint mkt1Rate = 0;   
250     uint mkt2Rate = 0;
251     uint mkt3Rate = 0;
252 
253 
254 
255     /*=======================================
256     =            PUBLIC FUNCTIONS            =
257     =======================================*/
258     /*
259     * -- APPLICATION ENTRY POINTS --  
260     */
261     function wallstreet2()
262     public
263     {
264      
265         // add administrators here
266         administrators[msg.sender] = true;
267         dev = msg.sender;
268 
269         ambassadors_[dev] = true;
270         
271     }
272     
273      
274     /**
275      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
276      */
277     function buy(address _referredBy)
278         public
279         payable
280         returns(uint256)
281     {
282         purchaseTokens(msg.value, _referredBy);
283     }
284     
285     /**
286      * Fallback function to handle ethereum that was send straight to the contract
287      * Unfortunately we cannot use a referral address this way.
288      */
289     function()
290         payable
291         public
292     {
293         purchaseTokens(msg.value, 0x0);
294     }
295     
296     /**
297      * Converts all of caller's dividends to tokens.
298      */
299     function reinvest()
300         onlyStronghands()
301         public
302     {
303         // fetch dividends
304         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
305         
306         // pay out the dividends virtually
307         address _customerAddress = msg.sender;
308         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
309         
310         // retrieve ref. bonus
311         _dividends += referralBalance_[_customerAddress] + ownerAccounts[_customerAddress];
312         referralBalance_[_customerAddress] = 0;
313         ownerAccounts[_customerAddress] = 0;
314         
315         // dispatch a buy order with the virtualized "withdrawn dividends"
316         uint256 _tokens = purchaseTokens(_dividends, 0x0);
317         
318         // fire event
319         onReinvestment(_customerAddress, _dividends, _tokens);
320       
321     }
322     
323     /**
324      * Alias of sell() and withdraw().
325      */
326     function exit()
327         public
328     {
329         // get token count for caller & sell them all
330         address _customerAddress = msg.sender;
331         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
332         if(_tokens > 0) sell(_tokens);
333         
334         // lambo delivery service
335         withdraw();
336    
337     }
338 
339     /**
340      * Withdraws all of the callers earnings.
341      */
342     function withdraw()
343         onlyStronghands()
344         public
345     {
346         // setup data
347         address _customerAddress = msg.sender;
348         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
349         
350         // update dividend tracker
351         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
352         
353         // add ref. bonus
354         _dividends += referralBalance_[_customerAddress] + ownerAccounts[_customerAddress];
355         referralBalance_[_customerAddress] = 0;
356         ownerAccounts[_customerAddress] = 0;
357         
358         // lambo delivery service
359         _customerAddress.transfer(_dividends);
360         
361         // fire event
362         onWithdraw(_customerAddress, _dividends);
363     
364     }
365     
366     /**
367      * Liquifies tokens to ethereum.
368      */
369     function sell(uint256 _amountOfTokens)
370     
371         onlyBagholders()
372         public
373     {
374         // setup data
375         uint8 localDivFee = 200;
376    
377 
378         address _customerAddress = msg.sender;
379         // russian hackers BTFO
380         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
381         uint256 _tokens = _amountOfTokens;
382         uint256 _ethereum = tokensToEthereum_(_tokens);
383         jackpotAccount = SafeMath.add(SafeMath.div(SafeMath.mul(_ethereum,jackpotFeeRate),1000),jackpotAccount);
384 
385         _ethereum = SafeMath.sub(_ethereum, SafeMath.div(SafeMath.mul(_ethereum,jackpotFeeRate),1000));
386 
387         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, sellDividendFee_),1000);
388         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
389         
390         // burn the sold tokens
391         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
392         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
393         
394         // update dividends tracker
395         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
396         payoutsTo_[_customerAddress] -= _updatedPayouts;       
397         
398         // dividing by zero is a bad idea
399         if (tokenSupply_ > 0) {
400             // update the amount of dividends per token
401             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
402         }
403 
404     
405         // fire event
406         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
407     }
408     
409     
410     /**
411      * Transfer tokens from the caller to a new holder.
412      * Remember, there's a 10% fee here as well.
413      */
414     function transfer(address _toAddress, uint256 _amountOfTokens)
415         onlyBagholders()
416         public
417         returns(bool)
418     {
419         // setup
420         address _customerAddress = msg.sender;
421 
422         uint8 localDivFee = 200;
423 
424         
425         // make sure we have the requested tokens
426         // also disables transfers until ambassador phase is over
427         // ( we dont want whale premines )
428         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
429         
430         // withdraw all outstanding dividends first
431         if(myDividends(true) > 0) withdraw();
432         
433         // liquify 20% of the tokens that are transfered
434         // these are dispersed to shareholders
435         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, localDivFee),1000);
436         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
437         uint256 _dividends = tokensToEthereum_(_tokenFee);
438   
439         // burn the fee tokens
440         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
441 
442         // exchange tokens
443         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
444         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
445         
446         // update dividend trackers
447         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
448         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
449         
450         // disperse dividends among holders
451         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
452         
453         // fire event
454         Transfer(_customerAddress, _toAddress, _taxedTokens);
455         
456         // ERC20
457         return true;
458        
459     }
460     
461     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
462     /**
463      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
464      */
465     function disableInitialStage()
466         onlyAdministrator()
467         public
468     {
469         onlyAmbassadors = false;
470     }
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
482  
483 
484     /**
485     * Set Exchange Rates
486     */
487     function setExchangeRates(uint8 _newBuyFee, uint8 _newSellFee)
488         onlyAdministrator()
489         public
490     {
491         require(_newBuyFee <= 400);   //40%
492         require(_newSellFee <= 400);   //40%
493 
494         buyDividendFee_ = _newBuyFee;
495         sellDividendFee_ = _newSellFee;
496     
497     }
498 
499 /**
500     * Set Marketing Rates
501     */
502     function setMarketingRates(uint256 _newMkt1Rate, uint256 _newMkt2Rate, uint256 _newMkt3Rate)
503         onlyAdministrator()
504         public
505     {
506         require(_newMkt1Rate +_newMkt2Rate +_newMkt3Rate <= 180); 
507        
508         mkt1Rate =  _newMkt1Rate;
509         mkt2Rate =  _newMkt2Rate;
510         mkt3Rate =  _newMkt3Rate;
511 
512     }
513 
514     /**
515     * Set Mkt1 Address
516     */
517     function setMarket1(address _newMkt1)
518         onlyAdministrator()
519         public
520     {
521       
522         mkt1 =  _newMkt1;
523      
524     }
525 
526     /**
527     * Set Mkt2 Address
528     */
529     function setMarket2(address _newMkt2)
530         onlyAdministrator()
531         public
532     {
533       
534         mkt2 =  _newMkt2;
535      
536     }
537 
538     /**
539     * Set Mkt3 Address
540     */
541     function setMarket3(address _newMkt3)
542         onlyAdministrator()
543         public
544     {
545       
546         mkt3 =  _newMkt3;
547      
548     }
549 
550     /**
551      * In case one of us dies, we need to replace ourselves.
552      */
553     function setContractActive(bool _status)
554         onlyAdministrator()
555         public
556     {
557         boolContractActive = _status;
558     }
559 
560     /**
561      * Precautionary measures in case we need to adjust the masternode rate.
562      */
563     function setStakingRequirement(uint256 _amountOfTokens)
564         onlyAdministrator()
565         public
566     {
567         stakingRequirement = _amountOfTokens;
568     }
569     
570     /**
571      * If we want to rebrand, we can.
572      */
573     function setName(string _name)
574         onlyAdministrator()
575         public
576     {
577         name = _name;
578     }
579     
580     /**
581      * If we want to rebrand, we can.
582      */
583     function setSymbol(string _symbol)
584         onlyAdministrator()
585         public
586     {
587         symbol = _symbol;
588     }
589 
590     function addAmbassador(address _newAmbassador) 
591         onlyAdministrator()
592         public
593     {
594         ambassadors_[_newAmbassador] = true;
595     }
596 
597 
598     /**
599     * Set Jackpot PayRate
600     */
601     function setJackpotFeeRate(uint256 _newFeeRate)
602         onlyAdministrator()
603         public
604     {
605         require(_newFeeRate <= 400);
606         jackpotFeeRate = _newFeeRate;
607     }
608 
609     
610     /**
611     * Set Jackpot PayRate
612     */
613     function setJackpotPayRate(uint256 _newPayRate)
614         onlyAdministrator()
615         public
616     {
617         jackpotPayRate = _newPayRate;
618     }
619 
620     /**
621     * Set Jackpot Increment
622     */
623     function setJackpotIncrement(uint256 _newIncrement)
624         onlyAdministrator()
625         public
626     {
627         jackpotThreshIncrease = _newIncrement;
628     }
629 
630     /**
631     * Set Jackpot Threshold Level
632     */
633     function setJackpotThreshold(uint256 _newTarget)
634         onlyAdministrator()
635         public
636     {
637         jackpotThreshold = _newTarget;
638     }
639 
640 
641     
642     /*----------  HELPERS AND CALCULATORS  ----------*/
643     /**
644      * Method to view the current Ethereum stored in the contract
645      * Example: totalEthereumBalance()
646      */
647     function totalEthereumBalance()
648         public
649         view
650         returns(uint)
651     {
652         return address(this).balance;
653     }
654     
655     /**
656      * Retrieve the total token supply.
657      */
658     function totalSupply()
659         public
660         view
661         returns(uint256)
662     {
663         return tokenSupply_;
664     }
665     
666     /**
667      * Retrieve the tokens owned by the caller.
668      */
669     function myTokens()
670         public
671         view
672         returns(uint256)
673     {
674         address _customerAddress = msg.sender;
675         return balanceOf(_customerAddress);
676     }
677     
678     /**
679      * Retrieve the dividends owned by the caller.
680      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
681      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
682      * But in the internal calculations, we want them separate. 
683      */ 
684     function myDividends(bool _includeReferralBonus) 
685         public 
686         view 
687         returns(uint256)
688     {
689         address _customerAddress = msg.sender;
690         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
691     }
692 
693     function myCardDividends()
694         public
695         view
696         returns(uint256)
697     {
698         address _customerAddress = msg.sender;
699         return ownerAccounts[_customerAddress];
700     }
701     
702     /**
703      * Retrieve the token balance of any single address.
704      */
705     function balanceOf(address _customerAddress)
706         view
707         public
708         returns(uint256)
709     {
710         return tokenBalanceLedger_[_customerAddress];
711     }
712     
713     /**
714      * Retrieve the dividend balance of any single address.
715      */
716     function dividendsOf(address _customerAddress)
717         view
718         public
719         returns(uint256)
720     {
721         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
722     }
723 
724 
725     function getData() 
726         //Ethereum Balance, MyTokens, TotalTokens, myDividends, myRefDividends, jackpot, jackpotThreshold
727         public 
728         view 
729         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256)
730     {
731         return(address(this).balance, balanceOf(msg.sender), tokenSupply_, dividendsOf(msg.sender) + ownerAccounts[msg.sender], referralBalance_[msg.sender], jackpotAccount, jackpotThreshold);
732     }
733 
734 
735     
736     /**
737      * Return the buy price of 1 individual token.
738      */
739     function sellPrice() 
740         public 
741         view 
742         returns(uint256)
743     {
744         // our calculation relies on the token supply, so we need supply. Doh.
745         if(tokenSupply_ == 0){
746             return tokenPriceInitial_ - tokenPriceIncremental_;
747         } else {
748             uint256 _ethereum = tokensToEthereum_(1e18);
749             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, sellDividendFee_),1000);
750             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
751             return _taxedEthereum;
752         }
753     }
754     
755     /**
756      * Return the sell price of 1 individual token.
757      */
758     function buyPrice() 
759         public 
760         view 
761         returns(uint256)
762     {
763         // our calculation relies on the token supply, so we need supply. Doh.
764         if(tokenSupply_ == 0){
765             return tokenPriceInitial_ + tokenPriceIncremental_;
766         } else {
767             uint256 _ethereum = tokensToEthereum_(1e18);
768             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, buyDividendFee_),1000);
769             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
770             return _taxedEthereum;
771         }
772     }
773     
774     /**
775      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
776      */
777     function calculateTokensReceived(uint256 _ethereumToSpend) 
778         public 
779         view 
780         returns(uint256)
781     {
782         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, buyDividendFee_),1000);
783         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
784         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
785         
786         return _amountOfTokens;
787     }
788     
789     /**
790      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
791      */
792     function calculateEthereumReceived(uint256 _tokensToSell) 
793         public 
794         view 
795         returns(uint256)
796     {
797         require(_tokensToSell <= tokenSupply_);
798         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
799         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, sellDividendFee_),1000);
800         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
801         return _taxedEthereum;
802     }
803     
804     
805     /*==========================================
806     =            INTERNAL FUNCTIONS            =
807     ==========================================*/
808 
809 
810     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
811         antiEarlyWhale(_incomingEthereum)
812         onlyActive()
813         internal
814         returns(uint256)
815     {
816         // data setup
817 
818         // setup data
819 
820 
821         if (mkt1 != 0x0 && mkt1Rate != 0){
822             ownerAccounts[mkt1] = SafeMath.add(ownerAccounts[mkt1] , SafeMath.div(SafeMath.mul(msg.value, mkt1Rate), 1000));
823             _incomingEthereum = SafeMath.sub(_incomingEthereum, SafeMath.div(SafeMath.mul(msg.value, mkt1Rate), 1000));
824         }
825 
826         if (mkt2 != 0x0 && mkt2Rate != 0){
827             ownerAccounts[mkt2] = SafeMath.add(ownerAccounts[mkt2] , SafeMath.div(SafeMath.mul(msg.value, mkt2Rate), 1000));
828             _incomingEthereum = SafeMath.sub(_incomingEthereum, SafeMath.div(SafeMath.mul(msg.value, mkt2Rate), 1000));
829         }
830         
831         if (mkt3 != 0x0 && mkt3Rate != 0){
832             ownerAccounts[mkt3] = SafeMath.add(ownerAccounts[mkt3] , SafeMath.div(SafeMath.mul(msg.value, mkt3Rate), 1000));
833             _incomingEthereum = SafeMath.sub(_incomingEthereum, SafeMath.div(SafeMath.mul(msg.value, mkt3Rate), 1000));
834         }
835 
836           //check for jackpot win
837         if (address(this).balance >= jackpotThreshold){
838             jackpotThreshold = address(this).balance + jackpotThreshIncrease;
839             onJackpot(msg.sender, SafeMath.div(SafeMath.mul(jackpotAccount,jackpotPayRate),1000), jackpotThreshold);
840             ownerAccounts[msg.sender] = SafeMath.add(ownerAccounts[msg.sender], SafeMath.div(SafeMath.mul(jackpotAccount,jackpotPayRate),1000));
841             
842             jackpotAccount = SafeMath.sub(jackpotAccount,SafeMath.div(SafeMath.mul(jackpotAccount,jackpotPayRate),1000));
843             
844         } else {
845             jackpotAccount = SafeMath.add(SafeMath.div(SafeMath.mul(_incomingEthereum,jackpotFeeRate),1000),jackpotAccount);
846             _incomingEthereum = SafeMath.sub(_incomingEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum,jackpotFeeRate),1000));
847             //SafeMath.div(SafeMath.mul(_incomingEthereum,jackpotFeeRate),1000);
848         }
849 
850         uint256 _referralBonus = SafeMath.div(SafeMath.div(SafeMath.mul(_incomingEthereum, buyDividendFee_  ),1000), 3);
851         uint256 _dividends = SafeMath.sub(SafeMath.div(SafeMath.mul(_incomingEthereum, buyDividendFee_  ),1000), _referralBonus);
852         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, buyDividendFee_),1000));
853         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
854         uint256 _fee = _dividends * magnitude;
855 
856       
857 
858  
859         // no point in continuing execution if OP is a poorfag russian hacker
860         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
861         // (or hackers)
862         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
863         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
864         
865         // is the user referred by a masternode?
866         if(
867             // is this a referred purchase?
868             _referredBy != 0x0000000000000000000000000000000000000000 &&
869 
870             // no cheating!
871             _referredBy != msg.sender &&
872             
873             // does the referrer have at least X whole tokens?
874             // i.e is the referrer a godly chad masternode
875             tokenBalanceLedger_[_referredBy] >= stakingRequirement
876         ){
877             // wealth redistribution
878             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
879         } else {
880             // no ref purchase
881             // add the referral bonus back to the global dividends cake
882             _dividends = SafeMath.add(_dividends, _referralBonus);
883             _fee = _dividends * magnitude;
884         }
885         
886         // we can't give people infinite ethereum
887         if(tokenSupply_ > 0){
888             
889             // add tokens to the pool
890             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
891  
892             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
893             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
894             
895             // calculate the amount of tokens the customer receives over his purchase 
896             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
897         
898         } else {
899             // add tokens to the pool
900             tokenSupply_ = _amountOfTokens;
901         }
902         
903         // update circulating supply & the ledger address for the customer
904         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
905         
906         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
907         //really i know you think you do but you don't
908         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
909         payoutsTo_[msg.sender] += _updatedPayouts;
910 
911      
912         // fire event
913         onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
914         
915         return _amountOfTokens;
916     }
917 
918 
919     /**
920      * Calculate Token price based on an amount of incoming ethereum
921      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
922      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
923      */
924     function ethereumToTokens_(uint256 _ethereum)
925         internal
926         view
927         returns(uint256)
928     {
929         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
930         uint256 _tokensReceived = 
931          (
932             (
933                 // underflow attempts BTFO
934                 SafeMath.sub(
935                     (sqrt
936                         (
937                             (_tokenPriceInitial**2)
938                             +
939                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
940                             +
941                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
942                             +
943                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
944                         )
945                     ), _tokenPriceInitial
946                 )
947             )/(tokenPriceIncremental_)
948         )-(tokenSupply_)
949         ;
950   
951         return _tokensReceived;
952     }
953     
954     /**
955      * Calculate token sell value.
956      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
957      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
958      */
959      function tokensToEthereum_(uint256 _tokens)
960         internal
961         view
962         returns(uint256)
963     {
964 
965         uint256 tokens_ = (_tokens + 1e18);
966         uint256 _tokenSupply = (tokenSupply_ + 1e18);
967         uint256 _etherReceived =
968         (
969             // underflow attempts BTFO
970             SafeMath.sub(
971                 (
972                     (
973                         (
974                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
975                         )-tokenPriceIncremental_
976                     )*(tokens_ - 1e18)
977                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
978             )
979         /1e18);
980         return _etherReceived;
981     }
982 
983   
984     //This is where all your gas goes, sorry
985     //Not sorry, you probably only paid 1 gwei
986     function sqrt(uint x) internal pure returns (uint y) {
987         uint z = (x + 1) / 2;
988         y = x;
989         while (z < y) {
990             y = z;
991             z = (x / z + z) / 2;
992         }
993     }
994 }
995 
996 /**
997  * @title SafeMath
998  * @dev Math operations with safety checks that throw on error
999  */
1000 library SafeMath {
1001 
1002     /**
1003     * @dev Multiplies two numbers, throws on overflow.
1004     */
1005     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1006         if (a == 0) {
1007             return 0;
1008         }
1009         uint256 c = a * b;
1010         assert(c / a == b);
1011         return c;
1012     }
1013 
1014     /**
1015     * @dev Integer division of two numbers, truncating the quotient.
1016     */
1017     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1018         // assert(b > 0); // Solidity automatically throws when dividing by 0
1019         uint256 c = a / b;
1020         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1021         return c;
1022     }
1023 
1024     /**
1025     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1026     */
1027     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1028         assert(b <= a);
1029         return a - b;
1030     }
1031 
1032     /**
1033     * @dev Adds two numbers, throws on overflow.
1034     */
1035     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1036         uint256 c = a + b;
1037         assert(c >= a);
1038         return c;
1039     }
1040 }