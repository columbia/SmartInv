1 pragma solidity ^0.4.23;
2 
3 
4 
5 contract Rocket {
6     /*=================================
7     =            MODIFIERS            =
8     =================================*/
9     // only people with tokens
10     modifier onlyBagholders() {
11         require(myTokens() > 0);
12         _;
13     }
14     
15     // only people with profits
16     modifier onlyStronghands() {
17         require(myDividends(true) > 0);
18         _;
19     }
20     
21     // administrators can:
22     // -> change the name of the contract
23     // -> change the name of the token
24     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
25     // they CANNOT:
26     // -> take funds
27     // -> disable withdrawals
28     // -> kill the contract
29     // -> change the price of tokens
30     modifier onlyAdministrator(){
31         address _customerAddress = msg.sender;
32         require(administrators[_customerAddress]);
33         _;
34     }
35 
36 
37     // ensures that the first tokens in the contract will be equally distributed
38     // meaning, no divine dump will be ever possible
39     // result: healthy longevity.
40     modifier antiEarlyWhale(uint256 _amountOfEthereum){
41         address _customerAddress = msg.sender;
42         
43         // are we still in the vulnerable phase?
44         // if so, enact anti early whale protocol 
45         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
46             require(
47                 // is the customer in the ambassador list?
48                 ambassadors_[_customerAddress] == true &&
49                 
50                 // does the customer purchase exceed the max ambassador quota?
51                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
52                 
53             );
54             
55             // updated the accumulated quota    
56             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
57         
58             // execute
59             _;
60         } else {
61             // in case the ether count drops low, the ambassador phase won't reinitiate
62             onlyAmbassadors = false;
63             _;    
64         }
65         
66     }
67     
68     bool onlyAmbassadors = true;
69     mapping(address => bool) internal ambassadors_;
70     uint256 constant internal ambassadorMaxPurchase_ = 0.5 ether;
71     uint256 constant internal ambassadorQuota_ = 20 ether;
72         
73     
74     
75     /*==============================
76     =            EVENTS            =
77     ==============================*/
78     event onTokenPurchase(
79         address indexed customerAddress,
80         uint256 incomingEthereum,
81         uint256 tokensMinted,
82         address indexed referredBy
83     );
84     
85     event onTokenSell(
86         address indexed customerAddress,
87         uint256 tokensBurned,
88         uint256 ethereumEarned
89     );
90     
91     event onReinvestment(
92         address indexed customerAddress,
93         uint256 ethereumReinvested,
94         uint256 tokensMinted
95     );
96     
97     event onWithdraw(
98         address indexed customerAddress,
99         uint256 ethereumWithdrawn
100     );
101     
102     // ERC20
103     event Transfer(
104         address indexed from,
105         address indexed to,
106         uint256 tokens
107     );
108     
109     
110     /*=====================================
111     =            CONFIGURABLES            =
112     =====================================*/
113     string public name = "Rocket";
114     string public symbol = "RCKT";
115     uint8 constant public decimals = 18;
116     uint8 constant internal dividendFee_ = 5; // Look, strong Math
117     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
118     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
119     uint256 constant internal magnitude = 2**64;
120     
121     // proof of stake (defaults at 100 tokens)
122     uint256 public stakingRequirement = 100e18;
123      
124 
125     
126     uint256 public Timer;
127     uint16 constant public JackpotTimer = 30 minutes;
128     address public Jackpot;
129     uint256 public JackpotAmount;
130     
131     uint8 constant JackpotCut = 4; // Cut to jackpot (division) 
132     uint8 constant JackpotPay = 80; // 80 / 100 = 80%
133     uint16 constant JackpotMinBuyin = 1000; // division; 1/100 of all ether currently in contract 
134     uint256 constant JackpotMinBuyingConst = 10 finney; 
135     uint256 constant MaxBuyInMin = 1 ether;
136     uint8 constant MaxBuyInCut = 10;  
137     
138 
139     
140 
141 
142 
143     
144    /*================================
145     =            DATASETS            =
146     ================================*/
147     // amount of shares for each address (scaled number)
148     mapping(address => uint256) internal tokenBalanceLedger_;
149     mapping(address => uint256) internal referralBalance_;
150     mapping(address => int256) internal payoutsTo_;
151     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
152     uint256 internal tokenSupply_ = 0;
153     uint256 internal profitPerShare_;
154     
155     // administrator list (see above on what they can do)
156     mapping(address => bool) public administrators;
157     
158  
159     
160 
161 
162     /*=======================================
163     =            PUBLIC FUNCTIONS            =
164     =======================================*/
165     /*
166     * -- APPLICATION ENTRY POINTS --  
167     */
168     constructor()
169         public
170         payable
171     {
172         // add administrators here
173 
174         administrators[msg.sender] = true;
175         ambassadors_[msg.sender]=true;
176         ambassadors_[0x8CA47715Be8AC08aF165a628Ab8111bB3FeF38f1]=true;
177         ambassadors_[0xbAB0308B1CBf9d66f0171581556807b08B3f5860]=true;
178         ambassadors_[0x69FE700236B3F5A32A878c1c1243169C6851d25B]=true;
179         ambassadors_[0x703b16787180a94c2f9f2510F08eDB59Aa899568]=true;
180         ambassadors_[0x05f2c11996d73288AbE8a31d8b593a693FF2E5D8]=true;
181         ambassadors_[0xe2C28fe6279F882B432d79436fc85131bbD8e369]=true;
182         
183         buy(0x0);
184     }
185     
186     function donateJackpot() public payable{
187         JackpotAmount = JackpotAmount + msg.value;
188     }
189     
190      
191     /**
192      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
193      */
194     function buy(address _referredBy)
195         public
196         payable
197         returns(uint256)
198     {
199         require(msg.value <= GetMaxBuyIn());
200 
201         purchaseTokens(msg.value, _referredBy);
202     }
203     
204     /**
205      * Fallback function to handle ethereum that was send straight to the contract
206      * Unfortunately we cannot use a referral address this way.
207      */
208     function()
209         payable
210         public
211     {
212         require(msg.value <= GetMaxBuyIn());
213 
214         purchaseTokens(msg.value, 0x0);
215     }
216     
217     /**
218      * Converts all of caller's dividends to tokens.
219     */
220     function reinvest()
221         onlyStronghands()
222         public
223     {
224         // fetch dividends
225         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
226         
227         // pay out the dividends virtually
228         address _customerAddress = msg.sender;
229         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
230         
231         // retrieve ref. bonus
232         _dividends += referralBalance_[_customerAddress];
233         referralBalance_[_customerAddress] = 0;
234         
235         // dispatch a buy order with the virtualized "withdrawn dividends"
236         uint256 _tokens = purchaseTokens(_dividends, 0x0);
237         
238         // fire event
239         onReinvestment(_customerAddress, _dividends, _tokens);
240     }
241     
242     /**
243      * Alias of sell() and withdraw().
244      */
245     function exit()
246         public
247     {
248         // get token count for caller & sell them all
249         address _customerAddress = msg.sender;
250         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
251         if(_tokens > 0) sell(_tokens);
252         
253         // lambo delivery service
254         withdraw();
255     }
256 
257     /**
258      * Withdraws all of the callers earnings.
259      */
260     function withdraw()
261         onlyStronghands()
262         public
263     {
264         // setup data
265         address _customerAddress = msg.sender;
266         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
267         
268         // update dividend tracker
269         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
270         
271         // add ref. bonus
272         _dividends += referralBalance_[_customerAddress];
273         referralBalance_[_customerAddress] = 0;
274         
275         // lambo delivery service
276         _customerAddress.transfer(_dividends);
277         
278         // fire event
279         onWithdraw(_customerAddress, _dividends);
280     }
281     
282     /**
283      * Liquifies tokens to ethereum.
284      */
285     function sell(uint256 _amountOfTokens)
286         onlyBagholders()
287         public
288     {
289         // setup data
290         address _customerAddress = msg.sender;
291         // russian hackers BTFO
292         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
293         uint256 _tokens = _amountOfTokens;
294         uint256 _ethereum = tokensToEthereum_(_tokens);
295         uint256 _undividedDividends = SafeMath.div(_ethereum, dividendFee_);
296 
297         uint256 _jackpotAmount = SafeMath.div(_undividedDividends, JackpotCut);
298         JackpotAmount = SafeMath.add(JackpotAmount,  _jackpotAmount);
299         uint256 _dividends = SafeMath.sub(_undividedDividends,_jackpotAmount);
300         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _undividedDividends);
301         
302         // burn the sold tokens
303         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
304         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
305         
306         // update dividends tracker
307         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
308         payoutsTo_[_customerAddress] -= _updatedPayouts;       
309         
310         // dividing by zero is a bad idea
311         if (tokenSupply_ > 0) {
312             // update the amount of dividends per token
313             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
314         }
315         
316         // fire event
317         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
318     }
319     
320     
321     /**
322      * Transfer tokens from the caller to a new holder.
323      * Remember, there's a 10% fee here as well.
324      */
325     function transfer(address _toAddress, uint256 _amountOfTokens)
326         onlyBagholders()
327         public
328         returns(bool)
329     {
330         // setup
331         address _customerAddress = msg.sender;
332         
333         // make sure we have the requested tokens
334         // also disables transfers until ambassador phase is over
335         // ( we dont want whale premines )
336         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
337         
338         // withdraw all outstanding dividends first
339         if(myDividends(true) > 0) withdraw();
340 
341         // exchange tokens
342         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
343         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
344         
345         // update dividend trackers
346         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
347         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
348         
349         // fire event
350         Transfer(_customerAddress, _toAddress, _amountOfTokens);
351         
352         // ERC20
353         return true;
354        
355     }
356     
357     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
358     /**
359      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
360      */
361     function disableInitialStage()
362         onlyAdministrator()
363         public
364     {
365         onlyAmbassadors = false;
366     }
367     
368     
369     
370     /**
371      * In case one of us dies, we need to replace ourselves.
372      */
373     function setAdministrator(address _identifier, bool _status)
374         onlyAdministrator()
375         public
376     {
377         administrators[_identifier] = _status;
378     }
379     
380     /**
381      * Precautionary measures in case we need to adjust the masternode rate.
382      */
383     function setStakingRequirement(uint256 _amountOfTokens)
384         onlyAdministrator()
385         public
386     {
387         stakingRequirement = _amountOfTokens;
388     }
389     
390     /**
391      * If we want to rebrand, we can.
392      */
393     function setName(string _name)
394         onlyAdministrator()
395         public
396     {
397         name = _name;
398     }
399     
400     /**
401      * If we want to rebrand, we can.
402      */
403     function setSymbol(string _symbol)
404         onlyAdministrator()
405         public
406     {
407         symbol = _symbol;
408     }
409     
410     function GetJackpotMin() public view returns (uint){
411         uint Ret = SafeMath.div(totalEthereumBalance(),(JackpotMinBuyin));
412         if (Ret < JackpotMinBuyingConst){
413             return JackpotMinBuyingConst;
414         }
415         return Ret;
416     }
417     
418     function GetMaxBuyIn() public view returns (uint){
419         uint Ret = SafeMath.div(totalEthereumBalance(),(MaxBuyInCut));
420         if (Ret < MaxBuyInMin){
421             return MaxBuyInMin;
422         }
423         return Ret;
424     }
425 
426     
427     /*----------  HELPERS AND CALCULATORS  ----------*/
428     /**
429      * Method to view the current Ethereum stored in the contract
430      * Example: totalEthereumBalance()
431      */
432     function totalEthereumBalance()
433         public
434         view
435         returns(uint)
436     {
437         return address(this).balance;
438     }
439     
440     /**
441      * Retrieve the total token supply.
442      */
443     function totalSupply()
444         public
445         view
446         returns(uint256)
447     {
448         return tokenSupply_;
449     }
450     
451     /**
452      * Retrieve the tokens owned by the caller.
453      */
454     function myTokens()
455         public
456         view
457         returns(uint256)
458     {
459         address _customerAddress = msg.sender;
460         return balanceOf(_customerAddress);
461     }
462     
463     /**
464      * Retrieve the dividends owned by the caller.
465      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
466      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
467      * But in the internal calculations, we want them separate. 
468      */ 
469     function myDividends(bool _includeReferralBonus) 
470         public 
471         view 
472         returns(uint256)
473     {
474         address _customerAddress = msg.sender;
475         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
476     }
477     
478     /**
479      * Retrieve the token balance of any single address.
480      */
481     function balanceOf(address _customerAddress)
482         view
483         public
484         returns(uint256)
485     {
486         return tokenBalanceLedger_[_customerAddress];
487     }
488     
489     /**
490      * Retrieve the dividend balance of any single address.
491      */
492     function dividendsOf(address _customerAddress)
493         view
494         public
495         returns(uint256)
496     {
497         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
498     }
499     
500     /**
501      * Return the buy price of 1 individual token.
502      */
503     function sellPrice() 
504         public 
505         view 
506         returns(uint256)
507     {
508         // our calculation relies on the token supply, so we need supply. Doh.
509         if(tokenSupply_ == 0){
510             return tokenPriceInitial_ - tokenPriceIncremental_;
511         } else {
512             uint256 _ethereum = tokensToEthereum_(1e18);
513             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
514             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
515             return _taxedEthereum;
516         }
517     }
518     
519     /**
520      * Return the sell price of 1 individual token.
521      */
522     function buyPrice() 
523         public 
524         view 
525         returns(uint256)
526     {
527         // our calculation relies on the token supply, so we need supply. Doh.
528         if(tokenSupply_ == 0){
529             return tokenPriceInitial_ + tokenPriceIncremental_;
530         } else {
531             uint256 _ethereum = tokensToEthereum_(1e18);
532             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
533             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
534             return _taxedEthereum;
535         }
536     }
537     
538     /**
539      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
540      */
541     function calculateTokensReceived(uint256 _ethereumToSpend) 
542         public 
543         view 
544         returns(uint256)
545     {
546         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
547         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
548         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
549         
550         return _amountOfTokens;
551     }
552     
553     /**
554      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
555      */
556     function calculateEthereumReceived(uint256 _tokensToSell) 
557         public 
558         view 
559         returns(uint256)
560     {
561         require(_tokensToSell <= tokenSupply_);
562         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
563         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
564         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
565         return _taxedEthereum;
566     }
567     
568     function PayJackpot() public{
569         if (block.timestamp > Timer && Jackpot != address(0x0)){
570             uint256 pay = (SafeMath.div(SafeMath.mul(JackpotAmount, JackpotPay), 100));
571             referralBalance_[Jackpot] += pay; 
572             Jackpot = address(0x0);
573             JackpotAmount = SafeMath.sub(JackpotAmount, (uint256) (pay));
574         }
575     }
576     
577     /*==========================================
578     =            INTERNAL FUNCTIONS            =
579     ==========================================*/
580     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
581         internal
582         antiEarlyWhale(_incomingEthereum)
583         returns(uint256)
584     {
585       
586         if (block.timestamp > Timer){
587             // pay jp 
588             PayJackpot();
589         }
590         // yes, reinvests count too 
591         if (_incomingEthereum >= GetJackpotMin()){
592             Jackpot = msg.sender;
593             Timer = block.timestamp + JackpotTimer;
594         }
595         // data setup
596 
597         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
598 
599         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
600         if ((_referredBy != 0x0000000000000000000000000000000000000000 && _referredBy != msg.sender && tokenBalanceLedger_[_referredBy] >= stakingRequirement)){
601             
602         }
603         else{
604             _referralBonus = 0;
605         }
606         uint256 _jackpotAmount = SafeMath.div(SafeMath.sub(_undividedDividends, _referralBonus), JackpotCut);
607         JackpotAmount = SafeMath.add(JackpotAmount,  _jackpotAmount);
608         uint256 _dividends = SafeMath.sub(SafeMath.sub(_undividedDividends, _referralBonus),_jackpotAmount);
609         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
610         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
611         uint256 _fee = _dividends * magnitude;
612  
613         // no point in continuing execution if OP is a poorfag russian hacker
614         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
615         // (or hackers)
616         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
617         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
618         
619         // is the user referred by a masternode?
620         if(
621              (_referredBy != 0x0000000000000000000000000000000000000000 && _referredBy != msg.sender && tokenBalanceLedger_[_referredBy] >= stakingRequirement)
622         ){
623             // wealth redistribution
624             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
625         }
626 
627         
628         // we can't give people infinite ethereum
629         if(tokenSupply_ > 0){
630             
631             // add tokens to the pool
632             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
633  
634             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
635             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
636             
637             // calculate the amount of tokens the customer receives over his purchase 
638             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
639         
640         } else {
641             // add tokens to the pool
642             tokenSupply_ = _amountOfTokens;
643         }
644         
645         // update circulating supply & the ledger address for the customer
646         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
647         
648         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
649         //really i know you think you do but you don't
650         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
651         payoutsTo_[msg.sender] += _updatedPayouts;
652         
653         // fire event
654         onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
655         
656         return _amountOfTokens;
657     }
658 
659     /**
660      * Calculate Token price based on an amount of incoming ethereum
661      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
662      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
663      */
664     function ethereumToTokens_(uint256 _ethereum)
665         internal
666         view
667         returns(uint256)
668     {
669         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
670         uint256 _tokensReceived = 
671          (
672             (
673                 // underflow attempts BTFO
674                 SafeMath.sub(
675                     (sqrt
676                         (
677                             (_tokenPriceInitial**2)
678                             +
679                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
680                             +
681                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
682                             +
683                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
684                         )
685                     ), _tokenPriceInitial
686                 )
687             )/(tokenPriceIncremental_)
688         )-(tokenSupply_)
689         ;
690   
691         return _tokensReceived;
692     }
693     
694     /**
695      * Calculate token sell value.
696      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
697      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
698      */
699      function tokensToEthereum_(uint256 _tokens)
700         internal
701         view
702         returns(uint256)
703     {
704 
705         uint256 tokens_ = (_tokens + 1e18);
706         uint256 _tokenSupply = (tokenSupply_ + 1e18);
707         uint256 _etherReceived =
708         (
709             // underflow attempts BTFO
710             SafeMath.sub(
711                 (
712                     (
713                         (
714                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
715                         )-tokenPriceIncremental_
716                     )*(tokens_ - 1e18)
717                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
718             )
719         /1e18);
720         return _etherReceived;
721     }
722     
723     
724     //This is where all your gas goes, sorry
725     //Not sorry, you probably only paid 1 gwei
726     function sqrt(uint x) internal pure returns (uint y) {
727         uint z = (x + 1) / 2;
728         y = x;
729         while (z < y) {
730             y = z;
731             z = (x / z + z) / 2;
732         }
733     }
734 }
735 
736 /**
737  * @title SafeMath
738  * @dev Math operations with safety checks that throw on error
739  */
740 library SafeMath {
741 
742     /**
743     * @dev Multiplies two numbers, throws on overflow.
744     */
745     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
746         if (a == 0) {
747             return 0;
748         }
749         uint256 c = a * b;
750         assert(c / a == b);
751         return c;
752     }
753 
754     /**
755     * @dev Integer division of two numbers, truncating the quotient.
756     */
757     function div(uint256 a, uint256 b) internal pure returns (uint256) {
758         // assert(b > 0); // Solidity automatically throws when dividing by 0
759         uint256 c = a / b;
760         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
761         return c;
762     }
763 
764     /**
765     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
766     */
767     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
768         assert(b <= a);
769         return a - b;
770     }
771 
772     /**
773     * @dev Adds two numbers, throws on overflow.
774     */
775     function add(uint256 a, uint256 b) internal pure returns (uint256) {
776         uint256 c = a + b;
777         assert(c >= a);
778         return c;
779     }
780 }