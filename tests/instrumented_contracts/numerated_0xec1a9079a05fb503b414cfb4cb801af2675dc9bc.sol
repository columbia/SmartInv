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
20             __  _                      _ __      
21  ___ ____  / /_(_) ___ ________ __  __(_) /___ __
22 / _ `/ _ \/ __/ / / _ `/ __/ _ `/ |/ / / __/ // /
23 \_,_/_//_/\__/_/  \_, /_/  \_,_/|___/_/\__/\_, / 
24                  /___/                    /___/  
25                                                                                                          
26 
27 
28 
29 website:    https://crypto-botics.com
30 
31 game:       https://crypto-botics.com/antigravity.html
32 
33 discord:    https://discord.gg/3xKTVhw
34 
35 25% Dividends Fees for Token Exchange
36 
37 Players are rewarded with the ETH Threshold Jackpot when their Buy causes the total ETH 
38 Balance to cross the next ETH Jackpot Threshold.
39 
40 ETH Thresholds increase by 10 ETH after every WIN.
41 
42 This is our anti-gravity engine.
43 
44 Whether you spend 5 ETH or 0.005 ETH to cross you win the jackpot.
45 
46 Jackpot winnings are automatically added to your dividends.
47 
48 ETH Threshold jackpot is funded with 10% of the BUY/SELL transactions
49 
50 Game Launches November 6, 22:00 UTC.
51 
52 */
53 
54 contract AcceptsExchange {
55     antigravity public tokenContract;
56 
57     function AcceptsExchange(address _tokenContract) public {
58         tokenContract = antigravity(_tokenContract);
59     }
60 
61     modifier onlyTokenContract {
62         require(msg.sender == address(tokenContract));
63         _;
64     }
65 
66     /**
67     * @dev Standard ERC677 function that will handle incoming token transfers.
68     *
69     * @param _from  Token sender address.
70     * @param _value Amount of tokens.
71     * @param _data  Transaction metadata.
72     */
73     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
74     function tokenFallbackExpanded(address _from, uint256 _value, bytes _data, address _sender, address _referrer) external returns (bool);
75 }
76 
77 contract antigravity {
78     /*=================================
79     =            MODIFIERS            =
80     =================================*/
81     // only people with tokens
82     modifier onlyBagholders() {
83         require(myTokens() > 0);
84         _;
85     }
86     
87     // only people with profits
88     modifier onlyStronghands() {
89         require(myDividends(true) > 0 || ownerAccounts[msg.sender] > 0);
90         //require(myDividends(true) > 0);
91         _;
92     }
93     
94       modifier notContract() {
95       require (msg.sender == tx.origin);
96       _;
97     }
98 
99     modifier allowPlayer(){
100         
101         require(boolAllowPlayer);
102         _;
103     }
104 
105     // administrators can:
106     // -> change the name of the contract
107     // -> change the name of the token
108     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
109     // they CANNOT:
110     // -> take funds
111     // -> disable withdrawals
112     // -> kill the contract
113     // -> change the price of tokens
114     modifier onlyAdministrator(){
115         address _customerAddress = msg.sender;
116         require(administrators[_customerAddress]);
117         _;
118     }
119     
120     modifier onlyActive(){
121         require(boolContractActive);
122         _;
123     }
124 
125     // ensures that the first tokens in the contract will be equally distributed
126     // meaning, no divine dump will be ever possible
127     // result: healthy longevity.
128     modifier antiEarlyWhale(uint256 _amountOfEthereum){
129         address _customerAddress = msg.sender;
130         
131         // are we still in the vulnerable phase?
132         // if so, enact anti early whale protocol 
133         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
134             require(
135                 // is the customer in the ambassador list?
136                 (ambassadors_[_customerAddress] == true &&
137                 
138                 // does the customer purchase exceed the max ambassador quota?
139                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_) ||
140 
141                 (_customerAddress == dev)
142                 
143             );
144             
145             // updated the accumulated quota    
146             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
147         
148             // execute
149             _;
150         } else {
151             // in case the ether count drops low, the ambassador phase won't reinitiate
152             onlyAmbassadors = false;
153             _;    
154         }
155         
156     }
157     
158     /*==============================
159     =            EVENTS            =
160     ==============================*/
161 
162 
163     event onTokenPurchase(
164         address indexed customerAddress,
165         uint256 incomingEthereum,
166         uint256 tokensMinted,
167         address indexed referredBy
168     );
169     
170     event onTokenSell(
171         address indexed customerAddress,
172         uint256 tokensBurned,
173         uint256 ethereumEarned
174     );
175     
176     event onReinvestment(
177         address indexed customerAddress,
178         uint256 ethereumReinvested,
179         uint256 tokensMinted
180     );
181     
182     event onWithdraw(
183         address indexed customerAddress,
184         uint256 ethereumWithdrawn
185     );
186     
187     // ERC20
188     event Transfer(
189         address indexed from,
190         address indexed to,
191         uint256 tokens
192     );
193 
194      // JackPot
195     event onJackpot(
196         address indexed customerAddress,
197         uint indexed value,
198         uint indexed nextThreshold
199     );
200     
201 
202     
203     /*=====================================
204     =            CONFIGURABLES            =
205     =====================================*/
206     string public name = "AntiGravity";
207     string public symbol = "LIFT";
208     uint8 constant public decimals = 18;
209     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
210     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
211     uint256 constant internal magnitude = 2**64;
212     
213     // proof of stake (defaults at 100 tokens)
214     uint256 public stakingRequirement = 100e18;
215     
216     // ambassador program
217     mapping(address => bool) internal ambassadors_;
218     uint256 constant internal ambassadorMaxPurchase_ = 2 ether;
219     uint256 constant internal ambassadorQuota_ = 20 ether;
220     
221     address dev;
222 
223     bool public boolAllowPlayer = false;
224 
225    /*================================
226     =            DATASETS            =
227     ================================*/
228     // amount of shares for each address (scaled number)
229     mapping(address => uint256) internal tokenBalanceLedger_;
230     mapping(address => uint256) internal referralBalance_;
231     mapping(address => int256) internal payoutsTo_;
232     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
233     uint256 internal tokenSupply_ = 0;
234     uint256 internal profitPerShare_;
235 
236     mapping(address => uint) internal ownerAccounts;
237 
238     bool public allowReferral = false;  //for cards
239 
240     uint8 public buyDividendFee_ = 150;  
241     uint8 public sellDividendFee_ = 150;           
242 
243     bool public boolContractActive = false;
244 
245     // administrator list (see above on what they can do)
246     mapping(address => bool) public administrators;
247     
248     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
249     bool public onlyAmbassadors = true;
250 
251       // Special Wall Street Market Platform control from scam game contracts on Wall Street Market platform
252     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept Wall Street tokens
253 
254     //ETH Jackpot
255     uint public jackpotThreshold = 10 ether;
256     uint public jackpotAccount = 0;
257     uint public jackpotFeeRate = 100;   //10%
258     uint public jackpotPayRate = 1000;  //100%
259     uint public jackpotThreshIncrease = 10 ether;
260 
261     address mkt1 = 0x0;
262     address mkt2 = 0x0;
263     address mkt3 = 0x0;   
264 
265     uint mkt1Rate = 0;
266     uint mkt2Rate = 0;
267     uint mkt3Rate = 0;
268 
269     /*=======================================
270     =            PUBLIC FUNCTIONS            =
271     =======================================*/
272     /*
273     * -- APPLICATION ENTRY POINTS --  
274     */
275     function antigravity()
276     public
277     {
278      
279         // add administrators here
280         administrators[msg.sender] = true;
281         dev = msg.sender;
282         
283     }
284     
285      
286     /**
287      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
288      */
289     function buy(address _referredBy)
290         public
291         payable
292         returns(uint256)
293     {
294         purchaseTokens(msg.value, _referredBy);
295     }
296     
297     /**
298      * Fallback function to handle ethereum that was send straight to the contract
299      * Unfortunately we cannot use a referral address this way.
300      */
301     function()
302         payable
303         public
304     {
305         purchaseTokens(msg.value, 0x0);
306     }
307     
308     /**
309      * Converts all of caller's dividends to tokens.
310      */
311     function reinvest()
312         onlyStronghands()
313         public
314     {
315         // fetch dividends
316         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
317         
318         // pay out the dividends virtually
319         address _customerAddress = msg.sender;
320         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
321         
322         // retrieve ref. bonus
323         _dividends += referralBalance_[_customerAddress] + ownerAccounts[_customerAddress];
324         referralBalance_[_customerAddress] = 0;
325         ownerAccounts[_customerAddress] = 0;
326         
327         // dispatch a buy order with the virtualized "withdrawn dividends"
328         uint256 _tokens = purchaseTokens(_dividends, 0x0);
329         
330         // fire event
331         onReinvestment(_customerAddress, _dividends, _tokens);
332       
333     }
334     
335     /**
336      * Alias of sell() and withdraw().
337      */
338     function exit()
339         public
340     {
341         // get token count for caller & sell them all
342         address _customerAddress = msg.sender;
343         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
344         if(_tokens > 0) sell(_tokens);
345         
346         withdraw();
347    
348     }
349 
350     /**
351      * Withdraws all of the callers earnings.
352      */
353     function withdraw()
354         onlyStronghands()
355         public
356     {
357         // setup data
358         address _customerAddress = msg.sender;
359         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
360         
361         // update dividend tracker
362         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
363         
364         // add ref. bonus
365         _dividends += referralBalance_[_customerAddress] + ownerAccounts[_customerAddress];
366         referralBalance_[_customerAddress] = 0;
367         ownerAccounts[_customerAddress] = 0;
368         
369         _customerAddress.transfer(_dividends);
370         
371         // fire event
372         onWithdraw(_customerAddress, _dividends);
373     
374     }
375     
376     /**
377      * Liquifies tokens to ethereum.
378      */
379     function sell(uint256 _amountOfTokens)
380     
381         onlyBagholders()
382         public
383     {
384         // setup data
385         uint8 localDivFee = 200;
386    
387 
388         address _customerAddress = msg.sender;
389         // russian hackers BTFO
390         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
391         uint256 _tokens = _amountOfTokens;
392         uint256 _ethereum = tokensToEthereum_(_tokens);
393         jackpotAccount = SafeMath.add(SafeMath.div(SafeMath.mul(_ethereum,jackpotFeeRate),1000),jackpotAccount);
394 
395         _ethereum = SafeMath.sub(_ethereum, SafeMath.div(SafeMath.mul(_ethereum,jackpotFeeRate),1000));
396 
397         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, sellDividendFee_),1000);
398         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
399         
400         // burn the sold tokens
401         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
402         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
403         
404         // update dividends tracker
405         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
406         payoutsTo_[_customerAddress] -= _updatedPayouts;       
407         
408         // dividing by zero is a bad idea
409         if (tokenSupply_ > 0) {
410             // update the amount of dividends per token
411             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
412         }
413 
414     
415         // fire event
416         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
417     }
418     
419     
420     /**
421      * Transfer tokens from the caller to a new holder.
422      * Remember, there's a 10% fee here as well.
423      */
424     function transfer(address _toAddress, uint256 _amountOfTokens)
425         onlyBagholders()
426         public
427         returns(bool)
428     {
429         // setup
430         address _customerAddress = msg.sender;
431 
432         uint8 localDivFee = 200;
433 
434         if (msg.sender == dev){   //exempt the dev from transfer fees so we can do some promo, you'll thank me in the morning
435             localDivFee = 0;
436         }
437 
438         
439         // make sure we have the requested tokens
440         // also disables transfers until ambassador phase is over
441         // ( we dont want whale premines )
442         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
443         
444         // withdraw all outstanding dividends first
445         if(myDividends(true) > 0) withdraw();
446         
447         // liquify 20% of the tokens that are transfered
448         // these are dispersed to shareholders
449         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, localDivFee),1000);
450         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
451         uint256 _dividends = tokensToEthereum_(_tokenFee);
452   
453         // burn the fee tokens
454         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
455 
456         // exchange tokens
457         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
458         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
459         
460         // update dividend trackers
461         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
462         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
463         
464         // disperse dividends among holders
465         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
466         
467         // fire event
468         Transfer(_customerAddress, _toAddress, _taxedTokens);
469         
470         // ERC20
471         return true;
472        
473     }
474     
475     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
476     /**
477      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
478      */
479     function disableInitialStage()
480         onlyAdministrator()
481         public
482     {
483         onlyAmbassadors = false;
484     }
485     
486     /**
487      * In case one of us dies, we need to replace ourselves.
488      */
489     function setAdministrator(address _identifier, bool _status)
490         onlyAdministrator()
491         public
492     {
493         administrators[_identifier] = _status;
494     }
495 
496  
497 
498     /**
499     * Set Exchange Rates
500     */
501     function setExchangeRates(uint8 _newBuyFee, uint8 _newSellFee)
502         onlyAdministrator()
503         public
504     {
505         require(_newBuyFee <= 400);   //40%
506         require(_newSellFee <= 400);   //40%
507 
508         buyDividendFee_ = _newBuyFee;
509         sellDividendFee_ = _newSellFee;
510     
511     }
512 
513 
514     /**
515     * Set Marketing Rates
516     */
517     function setMarketingRates(uint8 _newMkt1Rate, uint8 _newMkt2Rate, uint8 _newMkt3Rate)
518         onlyAdministrator()
519         public
520     {
521         require(_newMkt1Rate +_newMkt2Rate +_newMkt3Rate <= 60);   // 6%
522        
523         mkt1Rate =  _newMkt1Rate;
524         mkt2Rate =  _newMkt2Rate;
525         mkt3Rate =  _newMkt3Rate;
526 
527     }
528 
529     /**
530     * Set Mkt1 Address
531     */
532     function setMarket1(address _newMkt1)
533         onlyAdministrator()
534         public
535     {
536       
537         mkt1 =  _newMkt1;
538      
539     }
540 
541     /**
542     * Set Mkt2 Address
543     */
544     function setMarket2(address _newMkt2)
545         onlyAdministrator()
546         public
547     {
548       
549         mkt2 =  _newMkt2;
550      
551     }
552 
553     /**
554     * Set Mkt3 Address
555     */
556     function setMarket3(address _newMkt3)
557         onlyAdministrator()
558         public
559     {
560       
561         mkt3 =  _newMkt3;
562      
563     }
564 
565 
566     /**
567      * In case one of us dies, we need to replace ourselves.
568      */
569     function setContractActive(bool _status)
570         onlyAdministrator()
571         public
572     {
573         boolContractActive = _status;
574     }
575 
576     /**
577      * Precautionary measures in case we need to adjust the masternode rate.
578      */
579     function setStakingRequirement(uint256 _amountOfTokens)
580         onlyAdministrator()
581         public
582     {
583         stakingRequirement = _amountOfTokens;
584     }
585     
586     /**
587      * If we want to rebrand, we can.
588      */
589     function setName(string _name)
590         onlyAdministrator()
591         public
592     {
593         name = _name;
594     }
595     
596     /**
597      * If we want to rebrand, we can.
598      */
599     function setSymbol(string _symbol)
600         onlyAdministrator()
601         public
602     {
603         symbol = _symbol;
604     }
605 
606     function addAmbassador(address _newAmbassador) 
607         onlyAdministrator()
608         public
609     {
610         ambassadors_[_newAmbassador] = true;
611     }
612 
613 
614     /**
615     * Set Jackpot PayRate
616     */
617     function setJackpotFeeRate(uint256 _newFeeRate)
618         onlyAdministrator()
619         public
620     {
621         require(_newFeeRate <= 400);
622         jackpotFeeRate = _newFeeRate;
623     }
624 
625     
626     /**
627     * Set Jackpot PayRate
628     */
629     function setJackpotPayRate(uint256 _newPayRate)
630         onlyAdministrator()
631         public
632     {
633         require(_newPayRate >= 500);
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
644         require(_newIncrement >= 10 ether);
645         jackpotThreshIncrease = _newIncrement;
646     }
647 
648     /**
649     * Set Jackpot Threshold Level
650     */
651     function setJackpotThreshold(uint256 _newTarget)
652         onlyAdministrator()
653         public
654     {
655 
656         require(_newTarget >= (address(this).balance + jackpotAccount + jackpotThreshIncrease));
657         jackpotThreshold = _newTarget;
658     }
659 
660 
661     
662     /*----------  HELPERS AND CALCULATORS  ----------*/
663     /**
664      * Method to view the current Ethereum stored in the contract
665      * Example: totalEthereumBalance()
666      */
667     function totalEthereumBalance()
668         public
669         view
670         returns(uint)
671     {
672         return address(this).balance;
673     }
674     
675     /**
676      * Retrieve the total token supply.
677      */
678     function totalSupply()
679         public
680         view
681         returns(uint256)
682     {
683         return tokenSupply_;
684     }
685     
686     /**
687      * Retrieve the tokens owned by the caller.
688      */
689     function myTokens()
690         public
691         view
692         returns(uint256)
693     {
694         address _customerAddress = msg.sender;
695         return balanceOf(_customerAddress);
696     }
697     
698     /**
699      * Retrieve the dividends owned by the caller.
700      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
701      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
702      * But in the internal calculations, we want them separate. 
703      */ 
704     function myDividends(bool _includeReferralBonus) 
705         public 
706         view 
707         returns(uint256)
708     {
709         address _customerAddress = msg.sender;
710         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
711     }
712 
713     function myCardDividends()
714         public
715         view
716         returns(uint256)
717     {
718         address _customerAddress = msg.sender;
719         return ownerAccounts[_customerAddress];
720     }
721     
722     /**
723      * Retrieve the token balance of any single address.
724      */
725     function balanceOf(address _customerAddress)
726         view
727         public
728         returns(uint256)
729     {
730         return tokenBalanceLedger_[_customerAddress];
731     }
732     
733     /**
734      * Retrieve the dividend balance of any single address.
735      */
736     function dividendsOf(address _customerAddress)
737         view
738         public
739         returns(uint256)
740     {
741         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
742     }
743     
744     /**
745      * Return the buy price of 1 individual token.
746      */
747     function sellPrice() 
748         public 
749         view 
750         returns(uint256)
751     {
752         // our calculation relies on the token supply, so we need supply. Doh.
753         if(tokenSupply_ == 0){
754             return tokenPriceInitial_ - tokenPriceIncremental_;
755         } else {
756             uint256 _ethereum = tokensToEthereum_(1e18);
757             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, sellDividendFee_),1000);
758             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
759             return _taxedEthereum;
760         }
761     }
762     
763     /**
764      * Return the sell price of 1 individual token.
765      */
766     function buyPrice() 
767         public 
768         view 
769         returns(uint256)
770     {
771         // our calculation relies on the token supply, so we need supply. Doh.
772         if(tokenSupply_ == 0){
773             return tokenPriceInitial_ + tokenPriceIncremental_;
774         } else {
775             uint256 _ethereum = tokensToEthereum_(1e18);
776             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, buyDividendFee_),1000);
777             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
778             return _taxedEthereum;
779         }
780     }
781     
782     /**
783      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
784      */
785     function calculateTokensReceived(uint256 _ethereumToSpend) 
786         public 
787         view 
788         returns(uint256)
789     {
790         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, buyDividendFee_),1000);
791         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
792         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
793         
794         return _amountOfTokens;
795     }
796     
797     /**
798      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
799      */
800     function calculateEthereumReceived(uint256 _tokensToSell) 
801         public 
802         view 
803         returns(uint256)
804     {
805         require(_tokensToSell <= tokenSupply_);
806         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
807         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, sellDividendFee_),1000);
808         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
809         return _taxedEthereum;
810     }
811     
812     
813     /*==========================================
814     =            INTERNAL FUNCTIONS            =
815     ==========================================*/
816 
817 
818     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
819         antiEarlyWhale(_incomingEthereum)
820         onlyActive()
821         internal
822         returns(uint256)
823     {
824         // data setup
825 
826         // setup data
827 
828         if (mkt1 != 0x0 && mkt1Rate != 0){
829             ownerAccounts[mkt1] = SafeMath.add(ownerAccounts[mkt1] , SafeMath.div(SafeMath.mul(msg.value, mkt1Rate), 1000));
830             _incomingEthereum = SafeMath.sub(_incomingEthereum, SafeMath.div(SafeMath.mul(msg.value, mkt1Rate), 1000));
831         }
832 
833         if (mkt2 != 0x0 && mkt2Rate != 0){
834             ownerAccounts[mkt2] = SafeMath.add(ownerAccounts[mkt2] , SafeMath.div(SafeMath.mul(msg.value, mkt2Rate), 1000));
835             _incomingEthereum = SafeMath.sub(_incomingEthereum, SafeMath.div(SafeMath.mul(msg.value, mkt2Rate), 1000));
836         }
837         
838         if (mkt3 != 0x0 && mkt3Rate != 0){
839             ownerAccounts[mkt3] = SafeMath.add(ownerAccounts[mkt3] , SafeMath.div(SafeMath.mul(msg.value, mkt3Rate), 1000));
840             _incomingEthereum = SafeMath.sub(_incomingEthereum, SafeMath.div(SafeMath.mul(msg.value, mkt3Rate), 1000));
841         }
842         
843         //check for jackpot win
844         if (address(this).balance >= jackpotThreshold){
845             jackpotThreshold = address(this).balance + jackpotThreshIncrease;
846             onJackpot(msg.sender, SafeMath.div(SafeMath.mul(jackpotAccount,jackpotPayRate),1000), jackpotThreshold);
847             ownerAccounts[msg.sender] = SafeMath.add(ownerAccounts[msg.sender], SafeMath.div(SafeMath.mul(jackpotAccount,jackpotPayRate),1000));
848             
849             jackpotAccount = SafeMath.sub(jackpotAccount,SafeMath.div(SafeMath.mul(jackpotAccount,jackpotPayRate),1000));
850             
851         } else {
852             jackpotAccount = SafeMath.add(SafeMath.div(SafeMath.mul(_incomingEthereum,jackpotFeeRate),1000),jackpotAccount);
853             _incomingEthereum = SafeMath.sub(_incomingEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum,jackpotFeeRate),1000));
854             //SafeMath.div(SafeMath.mul(_incomingEthereum,jackpotFeeRate),1000);
855         }
856 
857         uint256 _referralBonus = SafeMath.div(SafeMath.div(SafeMath.mul(_incomingEthereum, buyDividendFee_  ),1000), 3);
858         uint256 _dividends = SafeMath.sub(SafeMath.div(SafeMath.mul(_incomingEthereum, buyDividendFee_  ),1000), _referralBonus);
859         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, buyDividendFee_),1000));
860         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
861         uint256 _fee = _dividends * magnitude;
862 
863       
864 
865  
866         // no point in continuing execution if OP is a poorfag russian hacker
867         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
868         // (or hackers)
869         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
870         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
871         
872         // is the user referred by a masternode?
873         if(
874             // is this a referred purchase?
875             _referredBy != 0x0000000000000000000000000000000000000000 &&
876 
877             // no cheating!
878             _referredBy != msg.sender &&
879             
880             // does the referrer have at least X whole tokens?
881             // i.e is the referrer a godly chad masternode
882             tokenBalanceLedger_[_referredBy] >= stakingRequirement
883         ){
884             // wealth redistribution
885             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
886         } else {
887             // no ref purchase
888             // add the referral bonus back to the global dividends cake
889             _dividends = SafeMath.add(_dividends, _referralBonus);
890             _fee = _dividends * magnitude;
891         }
892         
893         // we can't give people infinite ethereum
894         if(tokenSupply_ > 0){
895             
896             // add tokens to the pool
897             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
898  
899             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
900             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
901             
902             // calculate the amount of tokens the customer receives over his purchase 
903             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
904         
905         } else {
906             // add tokens to the pool
907             tokenSupply_ = _amountOfTokens;
908         }
909         
910         // update circulating supply & the ledger address for the customer
911         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
912         
913         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
914         //really i know you think you do but you don't
915         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
916         payoutsTo_[msg.sender] += _updatedPayouts;
917 
918      
919         // fire event
920         onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
921         
922         return _amountOfTokens;
923     }
924 
925 
926     /**
927      * Calculate Token price based on an amount of incoming ethereum
928      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
929      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
930      */
931     function ethereumToTokens_(uint256 _ethereum)
932         internal
933         view
934         returns(uint256)
935     {
936         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
937         uint256 _tokensReceived = 
938          (
939             (
940                 // underflow attempts BTFO
941                 SafeMath.sub(
942                     (sqrt
943                         (
944                             (_tokenPriceInitial**2)
945                             +
946                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
947                             +
948                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
949                             +
950                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
951                         )
952                     ), _tokenPriceInitial
953                 )
954             )/(tokenPriceIncremental_)
955         )-(tokenSupply_)
956         ;
957   
958         return _tokensReceived;
959     }
960     
961     /**
962      * Calculate token sell value.
963      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
964      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
965      */
966      function tokensToEthereum_(uint256 _tokens)
967         internal
968         view
969         returns(uint256)
970     {
971 
972         uint256 tokens_ = (_tokens + 1e18);
973         uint256 _tokenSupply = (tokenSupply_ + 1e18);
974         uint256 _etherReceived =
975         (
976             // underflow attempts BTFO
977             SafeMath.sub(
978                 (
979                     (
980                         (
981                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
982                         )-tokenPriceIncremental_
983                     )*(tokens_ - 1e18)
984                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
985             )
986         /1e18);
987         return _etherReceived;
988     }
989 
990   
991     //This is where all your gas goes, sorry
992     //Not sorry, you probably only paid 1 gwei
993     function sqrt(uint x) internal pure returns (uint y) {
994         uint z = (x + 1) / 2;
995         y = x;
996         while (z < y) {
997             y = z;
998             z = (x / z + z) / 2;
999         }
1000     }
1001 }
1002 
1003 /**
1004  * @title SafeMath
1005  * @dev Math operations with safety checks that throw on error
1006  */
1007 library SafeMath {
1008 
1009     /**
1010     * @dev Multiplies two numbers, throws on overflow.
1011     */
1012     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1013         if (a == 0) {
1014             return 0;
1015         }
1016         uint256 c = a * b;
1017         assert(c / a == b);
1018         return c;
1019     }
1020 
1021     /**
1022     * @dev Integer division of two numbers, truncating the quotient.
1023     */
1024     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1025         // assert(b > 0); // Solidity automatically throws when dividing by 0
1026         uint256 c = a / b;
1027         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1028         return c;
1029     }
1030 
1031     /**
1032     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1033     */
1034     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1035         assert(b <= a);
1036         return a - b;
1037     }
1038 
1039     /**
1040     * @dev Adds two numbers, throws on overflow.
1041     */
1042     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1043         uint256 c = a + b;
1044         assert(c >= a);
1045         return c;
1046     }
1047 }