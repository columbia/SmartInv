1 pragma solidity ^0.4.25;
2 
3 /*
4 
5 
6 
7  _   _       _                          _   _____                  _          _____     _              
8 | | | |     (_)                        | | /  __ \                | |        |_   _|   | |             
9 | | | |_ __  ___   _____ _ __ ___  __ _| | | /  \/_ __ _   _ _ __ | |_ ___     | | ___ | | _____ _ __  
10 | | | | '_ \| \ \ / / _ \ '__/ __|/ _` | | | |   | '__| | | | '_ \| __/ _ \    | |/ _ \| |/ / _ \ '_ \ 
11 | |_| | | | | |\ V /  __/ |  \__ \ (_| | | | \__/\ |  | |_| | |_) | || (_) |   | | (_) |   <  __/ | | |
12  \___/|_| |_|_| \_/ \___|_|  |___/\__,_|_|  \____/_|   \__, | .__/ \__\___/    \_/\___/|_|\_\___|_| |_|
13                                                         __/ | |                                        
14                                                        |___/|_|                                        
15 
16 
17   __  _____________
18  / / / / ___/_  __/
19 / /_/ / /__  / /   
20 \____/\___/ /_/    
21                    
22 
23 
24 
25 website:    https://universalcryptotoken.com
26 
27 exchange:   https://universalcryptotoken.com/exchange.html
28 
29 discord:    https://discord.gg/FyWtwRT
30 
31 ERC-20 Token based on the Ethereum Network
32 
33 (UCT) Tokens can be purchased directly with Ether on our website
34 
35 (UCT) Tokens are used for games and challenges that will be released over the coming months (see our road map)
36 
37 (UCT) Tokens feature a built-in marketplace whene you can buy and sell (UCT) tokens
38 
39 Long-term ownership is encouraged through our Exchange Fee System
40 
41 Purchase Fee:   15%
42     This is used for marketing, game support, and is distributed to all (UCT) token holders
43 
44 Liquidation Fee:   30%
45     This is distributed to all (UCT) token holders
46 
47 Referral Masternode:
48     Referrer Receives 33% of all Purchase Fees
49 
50 */
51 
52 contract AcceptsExchange {
53     UniversalCryptoToken public tokenContract;
54 
55     function AcceptsExchange(address _tokenContract) public {
56         tokenContract = UniversalCryptoToken(_tokenContract);
57     }
58 
59     modifier onlyTokenContract {
60         require(msg.sender == address(tokenContract));
61         _;
62     }
63 
64     /**
65     * @dev Standard ERC677 function that will handle incoming token transfers.
66     *
67     * @param _from  Token sender address.
68     * @param _value Amount of tokens.
69     * @param _data  Transaction metadata.
70     */
71     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
72     function tokenFallbackExpanded(address _from, uint256 _value, bytes _data, address _sender, address _referrer) external returns (bool);
73 }
74 
75 contract UniversalCryptoToken {
76     /*=================================
77     =            MODIFIERS            =
78     =================================*/
79     // only people with tokens
80     modifier onlyBagholders() {
81         require(myTokens() > 0);
82         _;
83     }
84     
85     // only people with profits
86     modifier onlyStronghands() {
87         require(myDividends(true) > 0 || ownerAccounts[msg.sender] > 0);
88         //require(myDividends(true) > 0);
89         _;
90     }
91     
92       modifier notContract() {
93       require (msg.sender == tx.origin);
94       _;
95     }
96 
97     modifier allowPlayer(){
98         
99         require(boolAllowPlayer);
100         _;
101     }
102 
103     // administrators can:
104     // -> change the name of the contract
105     // -> change the name of the token
106     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
107     // they CANNOT:
108     // -> take funds
109     // -> disable withdrawals
110     // -> kill the contract
111     // -> change the price of tokens
112     modifier onlyAdministrator(){
113         address _customerAddress = msg.sender;
114         require(administrators[_customerAddress]);
115         _;
116     }
117     
118     modifier onlyActive(){
119         require(boolContractActive);
120         _;
121     }
122 
123     // ensures that the first tokens in the contract will be equally distributed
124     // meaning, no divine dump will be ever possible
125     // result: healthy longevity.
126     modifier antiEarlyWhale(uint256 _amountOfEthereum){
127         address _customerAddress = msg.sender;
128         
129         // are we still in the vulnerable phase?
130         // if so, enact anti early whale protocol 
131         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
132             require(
133                 // is the customer in the ambassador list?
134                 (ambassadors_[_customerAddress] == true &&
135                 
136                 // does the customer purchase exceed the max ambassador quota?
137                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_) ||
138 
139                 (_customerAddress == dev)
140                 
141             );
142             
143             // updated the accumulated quota    
144             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
145         
146             // execute
147             _;
148         } else {
149             // in case the ether count drops low, the ambassador phase won't reinitiate
150             onlyAmbassadors = false;
151             _;    
152         }
153         
154     }
155     
156     /*==============================
157     =            EVENTS            =
158     ==============================*/
159 
160 
161     event onTokenPurchase(
162         address indexed customerAddress,
163         uint256 incomingEthereum,
164         uint256 tokensMinted,
165         address indexed referredBy
166     );
167     
168     event onTokenSell(
169         address indexed customerAddress,
170         uint256 tokensBurned,
171         uint256 ethereumEarned
172     );
173     
174     event onReinvestment(
175         address indexed customerAddress,
176         uint256 ethereumReinvested,
177         uint256 tokensMinted
178     );
179     
180     event onWithdraw(
181         address indexed customerAddress,
182         uint256 ethereumWithdrawn
183     );
184     
185     // ERC20
186     event Transfer(
187         address indexed from,
188         address indexed to,
189         uint256 tokens
190     );
191 
192      // JackPot
193     event onJackpot(
194         address indexed customerAddress,
195         uint indexed value,
196         uint indexed nextThreshold
197     );
198     
199 
200     
201     /*=====================================
202     =            CONFIGURABLES            =
203     =====================================*/
204     string public name = "UniversalCryptoToken";
205     string public symbol = "UCT";
206     uint8 constant public decimals = 18;
207     uint256 constant internal tokenPriceInitial_ = 0.000000001 ether;
208     uint256 constant internal tokenPriceIncremental_ = 0.0000000001 ether;
209     uint256 constant internal magnitude = 2**64;
210     
211     // proof of stake (defaults at 100 tokens)
212     uint256 public stakingRequirement = 100e18;
213     
214     // ambassador program
215     mapping(address => bool) internal ambassadors_;
216     uint256 constant internal ambassadorMaxPurchase_ = 2 ether;
217     uint256 constant internal ambassadorQuota_ = 20 ether;
218     
219     address dev;
220 
221     bool public boolAllowPlayer = false;
222 
223    /*================================
224     =            DATASETS            =
225     ================================*/
226     // amount of shares for each address (scaled number)
227     mapping(address => uint256) internal tokenBalanceLedger_;
228     mapping(address => uint256) internal referralBalance_;
229     mapping(address => int256) internal payoutsTo_;
230     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
231     uint256 internal tokenSupply_ = 0;
232     uint256 internal profitPerShare_;
233 
234     mapping(address => uint) internal ownerAccounts;
235 
236     bool public allowReferral = false;  //for cards
237 
238     uint public buyDividendFee_ = 90;  
239     uint public sellDividendFee_ = 300;           
240 
241     bool public boolContractActive = false;
242 
243     // administrator list (see above on what they can do)
244     mapping(address => bool) public administrators;
245     
246     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
247     bool public onlyAmbassadors = true;
248 
249       // Special Wall Street Market Platform control from scam game contracts on Wall Street Market platform
250     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept Wall Street tokens
251 
252     //ETH Jackpot
253     uint public jackpotThreshold = 10 ether;
254     uint public jackpotAccount = 0;
255     uint public jackpotFeeRate = 0;   //0%      We may utilize the jackpot feature later on
256     uint public jackpotPayRate = 1000;  //100%
257     uint public jackpotThreshIncrease = 5 ether;
258 
259     address mkt1 = 0xF2625aB95cF5a448F82A83cA869FD93b65eD181f;
260     address mkt2 = 0x0;
261     address mkt3 = 0x0;   
262 
263     uint mkt1Rate = 60;   //6%
264     uint mkt2Rate = 0;
265     uint mkt3Rate = 0;
266 
267     /*=======================================
268     =            PUBLIC FUNCTIONS            =
269     =======================================*/
270     /*
271     * -- APPLICATION ENTRY POINTS --  
272     */
273     function UniversalCryptoToken()
274     public
275     {
276      
277         // add administrators here
278         administrators[msg.sender] = true;
279         dev = msg.sender;
280         
281     }
282     
283      
284     /**
285      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
286      */
287     function buy(address _referredBy)
288         public
289         payable
290         returns(uint256)
291     {
292         purchaseTokens(msg.value, _referredBy);
293     }
294     
295     /**
296      * Fallback function to handle ethereum that was send straight to the contract
297      * Unfortunately we cannot use a referral address this way.
298      */
299     function()
300         payable
301         public
302     {
303         purchaseTokens(msg.value, 0x0);
304     }
305     
306     /**
307      * Converts all of caller's dividends to tokens.
308      */
309     function reinvest()
310         onlyStronghands()
311         public
312     {
313         // fetch dividends
314         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
315         
316         // pay out the dividends virtually
317         address _customerAddress = msg.sender;
318         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
319         
320         // retrieve ref. bonus
321         _dividends += referralBalance_[_customerAddress] + ownerAccounts[_customerAddress];
322         referralBalance_[_customerAddress] = 0;
323         ownerAccounts[_customerAddress] = 0;
324         
325         // dispatch a buy order with the virtualized "withdrawn dividends"
326         uint256 _tokens = purchaseTokens(_dividends, 0x0);
327         
328         // fire event
329         onReinvestment(_customerAddress, _dividends, _tokens);
330       
331     }
332     
333     /**
334      * Alias of sell() and withdraw().
335      */
336     function exit()
337         public
338     {
339         // get token count for caller & sell them all
340         address _customerAddress = msg.sender;
341         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
342         if(_tokens > 0) sell(_tokens);
343         
344         withdraw();
345    
346     }
347 
348     /**
349      * Withdraws all of the callers earnings.
350      */
351     function withdraw()
352         onlyStronghands()
353         public
354     {
355         // setup data
356         address _customerAddress = msg.sender;
357         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
358         
359         // update dividend tracker
360         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
361         
362         // add ref. bonus
363         _dividends += referralBalance_[_customerAddress] + ownerAccounts[_customerAddress];
364         referralBalance_[_customerAddress] = 0;
365         ownerAccounts[_customerAddress] = 0;
366         
367         _customerAddress.transfer(_dividends);
368         
369         // fire event
370         onWithdraw(_customerAddress, _dividends);
371     
372     }
373     
374     /**
375      * Liquifies tokens to ethereum.
376      */
377     function sell(uint256 _amountOfTokens)
378     
379         onlyBagholders()
380         public
381     {
382         // setup data
383         uint8 localDivFee = 200;
384    
385 
386         address _customerAddress = msg.sender;
387         // russian hackers BTFO
388         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
389         uint256 _tokens = _amountOfTokens;
390         uint256 _ethereum = tokensToEthereum_(_tokens);
391         jackpotAccount = SafeMath.add(SafeMath.div(SafeMath.mul(_ethereum,jackpotFeeRate),1000),jackpotAccount);
392 
393         _ethereum = SafeMath.sub(_ethereum, SafeMath.div(SafeMath.mul(_ethereum,jackpotFeeRate),1000));
394 
395         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, sellDividendFee_),1000);
396         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
397         
398         // burn the sold tokens
399         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
400         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
401         
402         // update dividends tracker
403         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
404         payoutsTo_[_customerAddress] -= _updatedPayouts;       
405         
406         // dividing by zero is a bad idea
407         if (tokenSupply_ > 0) {
408             // update the amount of dividends per token
409             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
410         }
411 
412     
413         // fire event
414         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
415     }
416     
417     
418     /**
419      * Transfer tokens from the caller to a new holder.
420      * Remember, there's a 15% fee here as well.
421      */
422     function transfer(address _toAddress, uint256 _amountOfTokens)
423         onlyBagholders()
424         public
425         returns(bool)
426     {
427         // setup
428         address _customerAddress = msg.sender;
429 
430         uint8 localDivFee = 150;  //15%
431 
432         // make sure we have the requested tokens
433         // also disables transfers until ambassador phase is over
434         // ( we dont want whale premines )
435         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
436         
437         // withdraw all outstanding dividends first
438         if(myDividends(true) > 0) withdraw();
439         
440         // liquify 20% of the tokens that are transfered
441         // these are dispersed to shareholders
442         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, localDivFee),1000);
443         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
444         uint256 _dividends = tokensToEthereum_(_tokenFee);
445   
446         // burn the fee tokens
447         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
448 
449         // exchange tokens
450         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
451         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
452         
453         // update dividend trackers
454         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
455         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
456         
457         // disperse dividends among holders
458         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
459         
460         // fire event
461         Transfer(_customerAddress, _toAddress, _taxedTokens);
462         
463         // ERC20
464         return true;
465        
466     }
467     
468     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
469     /**
470      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
471      */
472     function disableInitialStage()
473         onlyAdministrator()
474         public
475     {
476         onlyAmbassadors = false;
477     }
478     
479     /**
480      * In case one of us dies, we need to replace ourselves.
481      */
482     function setAdministrator(address _identifier, bool _status)
483         onlyAdministrator()
484         public
485     {
486         administrators[_identifier] = _status;
487     }
488 
489  
490 
491     /**
492     * Set Exchange Rates
493     */
494     function setExchangeRates(uint _newBuyFee, uint _newSellFee)
495         onlyAdministrator()
496         public
497     {
498         require(_newBuyFee <= 400);   //40%
499         require(_newSellFee <= 400);   //40%
500 
501         buyDividendFee_ = _newBuyFee;
502         sellDividendFee_ = _newSellFee;
503     
504     }
505 
506 
507     /**
508     * Set Marketing Rates
509     */
510     function setMarketingRates(uint8 _newMkt1Rate, uint8 _newMkt2Rate, uint8 _newMkt3Rate)
511         onlyAdministrator()
512         public
513     {
514         require(_newMkt1Rate +_newMkt2Rate +_newMkt3Rate <= 60);   // 6%
515        
516         mkt1Rate =  _newMkt1Rate;
517         mkt2Rate =  _newMkt2Rate;
518         mkt3Rate =  _newMkt3Rate;
519 
520     }
521 
522     /**
523     * Set Mkt1 Address
524     */
525     function setMarket1(address _newMkt1)
526         onlyAdministrator()
527         public
528     {
529       
530         mkt1 =  _newMkt1;
531      
532     }
533 
534     /**
535     * Set Mkt2 Address
536     */
537     function setMarket2(address _newMkt2)
538         onlyAdministrator()
539         public
540     {
541       
542         mkt2 =  _newMkt2;
543      
544     }
545 
546     /**
547     * Set Mkt3 Address
548     */
549     function setMarket3(address _newMkt3)
550         onlyAdministrator()
551         public
552     {
553       
554         mkt3 =  _newMkt3;
555      
556     }
557 
558 
559     /**
560      * In case one of us dies, we need to replace ourselves.
561      */
562     function setContractActive(bool _status)
563         onlyAdministrator()
564         public
565     {
566         boolContractActive = _status;
567     }
568 
569     /**
570      * Precautionary measures in case we need to adjust the masternode rate.
571      */
572     function setStakingRequirement(uint256 _amountOfTokens)
573         onlyAdministrator()
574         public
575     {
576         stakingRequirement = _amountOfTokens;
577     }
578     
579     /**
580      * If we want to rebrand, we can.
581      */
582     function setName(string _name)
583         onlyAdministrator()
584         public
585     {
586         name = _name;
587     }
588     
589     /**
590      * If we want to rebrand, we can.
591      */
592     function setSymbol(string _symbol)
593         onlyAdministrator()
594         public
595     {
596         symbol = _symbol;
597     }
598 
599     function addAmbassador(address _newAmbassador) 
600         onlyAdministrator()
601         public
602     {
603         ambassadors_[_newAmbassador] = true;
604     }
605 
606 
607     /**
608     * Set Jackpot PayRate
609     */
610     function setJackpotFeeRate(uint256 _newFeeRate)
611         onlyAdministrator()
612         public
613     {
614         require(_newFeeRate <= 400);
615         jackpotFeeRate = _newFeeRate;
616     }
617 
618     
619     /**
620     * Set Jackpot PayRate
621     */
622     function setJackpotPayRate(uint256 _newPayRate)
623         onlyAdministrator()
624         public
625     {
626         require(_newPayRate >= 500);
627         jackpotPayRate = _newPayRate;
628     }
629 
630     /**
631     * Set Jackpot Increment
632     */
633     function setJackpotIncrement(uint256 _newIncrement)
634         onlyAdministrator()
635         public
636     {
637         require(_newIncrement >= 10 ether);
638         jackpotThreshIncrease = _newIncrement;
639     }
640 
641     /**
642     * Set Jackpot Threshold Level
643     */
644     function setJackpotThreshold(uint256 _newTarget)
645         onlyAdministrator()
646         public
647     {
648 
649         require(_newTarget >= (address(this).balance + jackpotAccount + jackpotThreshIncrease));
650         jackpotThreshold = _newTarget;
651     }
652 
653 
654     
655     /*----------  HELPERS AND CALCULATORS  ----------*/
656     /**
657      * Method to view the current Ethereum stored in the contract
658      * Example: totalEthereumBalance()
659      */
660     function totalEthereumBalance()
661         public
662         view
663         returns(uint)
664     {
665         return address(this).balance;
666     }
667     
668     /**
669      * Retrieve the total token supply.
670      */
671     function totalSupply()
672         public
673         view
674         returns(uint256)
675     {
676         return tokenSupply_;
677     }
678     
679     /**
680      * Retrieve the tokens owned by the caller.
681      */
682     function myTokens()
683         public
684         view
685         returns(uint256)
686     {
687         address _customerAddress = msg.sender;
688         return balanceOf(_customerAddress);
689     }
690     
691     /**
692      * Retrieve the dividends owned by the caller.
693      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
694      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
695      * But in the internal calculations, we want them separate. 
696      */ 
697     function myDividends(bool _includeReferralBonus) 
698         public 
699         view 
700         returns(uint256)
701     {
702         address _customerAddress = msg.sender;
703         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
704     }
705 
706     function myCardDividends()
707         public
708         view
709         returns(uint256)
710     {
711         address _customerAddress = msg.sender;
712         return ownerAccounts[_customerAddress];
713     }
714     
715     /**
716      * Retrieve the token balance of any single address.
717      */
718     function balanceOf(address _customerAddress)
719         view
720         public
721         returns(uint256)
722     {
723         return tokenBalanceLedger_[_customerAddress];
724     }
725     
726     /**
727      * Retrieve the dividend balance of any single address.
728      */
729     function dividendsOf(address _customerAddress)
730         view
731         public
732         returns(uint256)
733     {
734         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
735     }
736     
737     /**
738      * Return the buy price of 1 individual token.
739      */
740     function sellPrice() 
741         public 
742         view 
743         returns(uint256)
744     {
745         // our calculation relies on the token supply, so we need supply. Doh.
746         if(tokenSupply_ == 0){
747             return tokenPriceInitial_ - tokenPriceIncremental_;
748         } else {
749             uint256 _ethereum = tokensToEthereum_(1e18);
750             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, sellDividendFee_),1000);
751             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
752             return _taxedEthereum;
753         }
754     }
755     
756     /**
757      * Return the sell price of 1 individual token.
758      */
759     function buyPrice() 
760         public 
761         view 
762         returns(uint256)
763     {
764         // our calculation relies on the token supply, so we need supply. Doh.
765         if(tokenSupply_ == 0){
766             return tokenPriceInitial_ + tokenPriceIncremental_;
767         } else {
768             uint256 _ethereum = tokensToEthereum_(1e18);
769             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, buyDividendFee_),1000);
770             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
771             return _taxedEthereum;
772         }
773     }
774     
775     /**
776      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
777      */
778     function calculateTokensReceived(uint256 _ethereumToSpend) 
779         public 
780         view 
781         returns(uint256)
782     {
783         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, buyDividendFee_),1000);
784         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
785         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
786         
787         return _amountOfTokens;
788     }
789     
790     /**
791      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
792      */
793     function calculateEthereumReceived(uint256 _tokensToSell) 
794         public 
795         view 
796         returns(uint256)
797     {
798         require(_tokensToSell <= tokenSupply_);
799         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
800         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, sellDividendFee_),1000);
801         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
802         return _taxedEthereum;
803     }
804     
805     
806     /*==========================================
807     =            INTERNAL FUNCTIONS            =
808     ==========================================*/
809 
810 
811     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
812         antiEarlyWhale(_incomingEthereum)
813         onlyActive()
814         internal
815         returns(uint256)
816     {
817         // data setup
818 
819         // setup data
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
836         //check for jackpot win
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