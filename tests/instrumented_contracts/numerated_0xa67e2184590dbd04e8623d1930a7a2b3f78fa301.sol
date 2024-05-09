1 pragma solidity ^0.4.20;
2 
3 /*
4 
5      @###########&@     @########@#                                          
6    @##################%@%#############@                                        
7  @#####################@################@                                      
8 @#############%%%%%%%%%################@                                     
9 ########&%###############@#####@@@@@@@####@                                    
10 ######&%###################@############@&                                   
11 #############################@###############@,                                
12 #############################################@.                              
13 ##########@%%%%%%%%%%%@###%@%@#############&&&                             
14 #########@@########%@%###@###&#######&#####%@&%                          
15 #####@##@################@#&#@####@##&#####@##@#                         
16 ####%#@%%@@@@@@@@@@@@@####&@#####@@@@@@@@##@&                          
17 ##########%@( @@@*@@@&(@&     *##&#@ @ &@@@@@   ,@/                          
18 ##############@@@ @@& @@@      @####@ @@@@@@  @    ,%                          
19 ###########&#####&@@@@        @%#&% @@@@@@@@#  ,@#&                          
20 ##############@%%################@################&*                           
21 ############################%%@#######@&@@@######&&/                           
22 ####&@######################@############@##########@                          
23 #########################&@################@#########@                         
24 ##@##################@@###############################&                        
25 ###%#####&@#########################################%#@                        
26 ####@###&#####%&&@############################%@%,                         
27 #######@###%&@%%##########%@@@@&#############&@##@.                          
28 ##########@&%######%&&&&@@@%#####################@##@                          
29 ##############&##################################&,                          
30 ##################&@#############################%@                            
31 ##########################&@@@&&&&&&&&&&&&&&&&@%##@                            
32 ###########################################%%####%.                            
33 ########################################&@####@@@                              
34 #####################################@%#########%@                             
35 ##############################&&#@@###############@,                         
36 #################################%###%####& @#@%#####*                       
37 #############################@####%@@@@%##@  @@#########@                      
38 ###############################@#####@#&@ (%##############@                    
39 ################################@####@  #########@#########@                   
40 #######################################@@######@######%#####%.                 
41 ########################################@%##@#####%###@##/         
42 
43 This is the rarest ethereum ascii pepe.
44 It appears once every 5578000 blocks.
45 
46 Buy in or you will never make it.
47 
48 Welcome to Proof Of Rare Pepe
49 
50 
51 */
52 
53 contract ProofOfRarePepe {
54     /*=================================
55     =            MODIFIERS            =
56     =================================*/
57     // only people with tokens
58     modifier onlyBagholders() {
59         require(myTokens() > 0);
60         _;
61     }
62     
63     // only people with profits
64     modifier onlyStronghands() {
65         require(myDividends(true) > 0);
66         _;
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
80         require(administrators[keccak256(_customerAddress)]);
81         _;
82     }
83     
84     
85     // ensures that the first tokens in the contract will be equally distributed
86     // meaning, no divine dump will be ever possible
87     // result: healthy longevity.
88     modifier antiEarlyWhale(uint256 _amountOfEthereum){
89         address _customerAddress = msg.sender;
90         
91         // are we still in the vulnerable phase?
92         // if so, enact anti early whale protocol 
93         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
94             require(
95                 // is the customer in the ambassador list?
96                 ambassadors_[_customerAddress] == true &&
97                 
98                 // does the customer purchase exceed the max ambassador quota?
99                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
100                 
101             );
102             
103             // updated the accumulated quota    
104             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
105         
106             // execute
107             _;
108         } else {
109             // in case the ether count drops low, the ambassador phase won't reinitiate
110             onlyAmbassadors = false;
111             _;    
112         }
113         
114     }
115     
116     
117     /*==============================
118     =            EVENTS            =
119     ==============================*/
120     event onTokenPurchase(
121         address indexed customerAddress,
122         uint256 incomingEthereum,
123         uint256 tokensMinted,
124         address indexed referredBy
125     );
126     
127     event onTokenSell(
128         address indexed customerAddress,
129         uint256 tokensBurned,
130         uint256 ethereumEarned
131     );
132     
133     event onReinvestment(
134         address indexed customerAddress,
135         uint256 ethereumReinvested,
136         uint256 tokensMinted
137     );
138     
139     event onWithdraw(
140         address indexed customerAddress,
141         uint256 ethereumWithdrawn
142     );
143     
144     // ERC20
145     event Transfer(
146         address indexed from,
147         address indexed to,
148         uint256 tokens
149     );
150     
151     
152     /*=====================================
153     =            CONFIGURABLES            =
154     =====================================*/
155     string public name = "Proof of Rare Pepe";
156     string public symbol = "PORP";
157     uint8 constant public decimals = 18;
158     uint8 constant internal dividendFee_ = 4;
159     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
160     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
161     uint256 constant internal magnitude = 2**64;
162     
163     // proof of stake (defaults at 100 tokens)
164     uint256 public stakingRequirement = 5e18;
165     
166     // ambassador program
167     mapping(address => bool) internal ambassadors_;
168     uint256 constant internal ambassadorMaxPurchase_ = 10 ether;
169     uint256 constant internal ambassadorQuota_ = 10 ether;
170     
171     
172     
173    /*================================
174     =            DATASETS            =
175     ================================*/
176     // amount of shares for each address (scaled number)
177     mapping(address => uint256) internal tokenBalanceLedger_;
178     mapping(address => uint256) internal referralBalance_;
179     mapping(address => int256) internal payoutsTo_;
180     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
181     uint256 internal tokenSupply_ = 0;
182     uint256 internal profitPerShare_;
183     
184     // administrator list (see above on what they can do)
185     mapping(bytes32 => bool) public administrators;
186     
187     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
188     bool public onlyAmbassadors = false;
189     
190 
191 
192     /*=======================================
193     =            PUBLIC FUNCTIONS            =
194     =======================================*/
195     /*
196     * -- APPLICATION ENTRY POINTS --  
197     */
198     function ProofOfRarePepe()
199         public
200     {
201         // add administrators here
202         
203         
204         // add the ambassadors here.
205 
206     }
207     
208      
209     /**
210      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
211      */
212     function buy(address _referredBy)
213         public
214         payable
215         returns(uint256)
216     {
217         purchaseTokens(msg.value, _referredBy);
218     }
219     
220     /**
221      * Fallback function to handle ethereum that was send straight to the contract
222      * Unfortunately we cannot use a referral address this way.
223      */
224     function()
225         payable
226         public
227     {
228         purchaseTokens(msg.value, 0x0);
229     }
230     
231     /**
232      * Converts all of caller's dividends to tokens.
233      */
234     function reinvest()
235         onlyStronghands()
236         public
237     {
238         // fetch dividends
239         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
240         
241         // pay out the dividends virtually
242         address _customerAddress = msg.sender;
243         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
244         
245         // retrieve ref. bonus
246         _dividends += referralBalance_[_customerAddress];
247         referralBalance_[_customerAddress] = 0;
248         
249         // dispatch a buy order with the virtualized "withdrawn dividends"
250         uint256 _tokens = purchaseTokens(_dividends, 0x0);
251         
252         // fire event
253         onReinvestment(_customerAddress, _dividends, _tokens);
254     }
255     
256     /**
257      * Alias of sell() and withdraw().
258      */
259     function exit()
260         public
261     {
262         // get token count for caller & sell them all
263         address _customerAddress = msg.sender;
264         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
265         if(_tokens > 0) sell(_tokens);
266         
267         // lambo delivery service
268         withdraw();
269     }
270 
271     /**
272      * Withdraws all of the callers earnings.
273      */
274     function withdraw()
275         onlyStronghands()
276         public
277     {
278         // setup data
279         address _customerAddress = msg.sender;
280         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
281         
282         // update dividend tracker
283         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
284         
285         // add ref. bonus
286         _dividends += referralBalance_[_customerAddress];
287         referralBalance_[_customerAddress] = 0;
288         
289         // lambo delivery service
290         _customerAddress.transfer(_dividends);
291         
292         // fire event
293         onWithdraw(_customerAddress, _dividends);
294     }
295     
296     /**
297      * Liquifies tokens to ethereum.
298      */
299     function sell(uint256 _amountOfTokens)
300         onlyBagholders()
301         public
302     {
303         // setup data
304         address _customerAddress = msg.sender;
305         // russian hackers BTFO
306         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
307         uint256 _tokens = _amountOfTokens;
308         uint256 _ethereum = tokensToEthereum_(_tokens);
309         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
310         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
311         
312         // burn the sold tokens
313         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
314         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
315         
316         // update dividends tracker
317         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
318         payoutsTo_[_customerAddress] -= _updatedPayouts;       
319         
320         // dividing by zero is a bad idea
321         if (tokenSupply_ > 0) {
322             // update the amount of dividends per token
323             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
324         }
325         
326         // fire event
327         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
328     }
329     
330     
331     /**
332      * Transfer tokens from the caller to a new holder.
333      * Remember, there's a 10% fee here as well.
334      */
335     function transfer(address _toAddress, uint256 _amountOfTokens)
336         onlyBagholders()
337         public
338         returns(bool)
339     {
340         // setup
341         address _customerAddress = msg.sender;
342         
343         // make sure we have the requested tokens
344         // also disables transfers until ambassador phase is over
345         // ( we dont want whale premines )
346         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
347         
348         // withdraw all outstanding dividends first
349         if(myDividends(true) > 0) withdraw();
350         
351         // liquify 10% of the tokens that are transfered
352         // these are dispersed to shareholders
353         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
354         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
355         uint256 _dividends = tokensToEthereum_(_tokenFee);
356   
357         // burn the fee tokens
358         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
359 
360         // exchange tokens
361         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
362         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
363         
364         // update dividend trackers
365         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
366         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
367         
368         // disperse dividends among holders
369         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
370         
371         // fire event
372         Transfer(_customerAddress, _toAddress, _taxedTokens);
373         
374         // ERC20
375         return true;
376        
377     }
378     
379     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
380     /**
381      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
382      */
383     function disableInitialStage()
384         onlyAdministrator()
385         public
386     {
387         onlyAmbassadors = false;
388     }
389     
390     /**
391      * In case one of us dies, we need to replace ourselves.
392      */
393     function setAdministrator(bytes32 _identifier, bool _status)
394         onlyAdministrator()
395         public
396     {
397         administrators[_identifier] = _status;
398     }
399     
400     /**
401      * Precautionary measures in case we need to adjust the masternode rate.
402      */
403     function setStakingRequirement(uint256 _amountOfTokens)
404         onlyAdministrator()
405         public
406     {
407         stakingRequirement = _amountOfTokens;
408     }
409     
410     /**
411      * If we want to rebrand, we can.
412      */
413     function setName(string _name)
414         onlyAdministrator()
415         public
416     {
417         name = _name;
418     }
419     
420     /**
421      * If we want to rebrand, we can.
422      */
423     function setSymbol(string _symbol)
424         onlyAdministrator()
425         public
426     {
427         symbol = _symbol;
428     }
429 
430     
431     /*----------  HELPERS AND CALCULATORS  ----------*/
432     /**
433      * Method to view the current Ethereum stored in the contract
434      * Example: totalEthereumBalance()
435      */
436     function totalEthereumBalance()
437         public
438         view
439         returns(uint)
440     {
441         return this.balance;
442     }
443     
444     /**
445      * Retrieve the total token supply.
446      */
447     function totalSupply()
448         public
449         view
450         returns(uint256)
451     {
452         return tokenSupply_;
453     }
454     
455     /**
456      * Retrieve the tokens owned by the caller.
457      */
458     function myTokens()
459         public
460         view
461         returns(uint256)
462     {
463         address _customerAddress = msg.sender;
464         return balanceOf(_customerAddress);
465     }
466     
467     /**
468      * Retrieve the dividends owned by the caller.
469      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
470      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
471      * But in the internal calculations, we want them separate. 
472      */ 
473     function myDividends(bool _includeReferralBonus) 
474         public 
475         view 
476         returns(uint256)
477     {
478         address _customerAddress = msg.sender;
479         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
480     }
481     
482     /**
483      * Retrieve the token balance of any single address.
484      */
485     function balanceOf(address _customerAddress)
486         view
487         public
488         returns(uint256)
489     {
490         return tokenBalanceLedger_[_customerAddress];
491     }
492     
493     /**
494      * Retrieve the dividend balance of any single address.
495      */
496     function dividendsOf(address _customerAddress)
497         view
498         public
499         returns(uint256)
500     {
501         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
502     }
503     
504     /**
505      * Return the buy price of 1 individual token.
506      */
507     function sellPrice() 
508         public 
509         view 
510         returns(uint256)
511     {
512         // our calculation relies on the token supply, so we need supply. Doh.
513         if(tokenSupply_ == 0){
514             return tokenPriceInitial_ - tokenPriceIncremental_;
515         } else {
516             uint256 _ethereum = tokensToEthereum_(1e18);
517             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
518             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
519             return _taxedEthereum;
520         }
521     }
522     
523     /**
524      * Return the sell price of 1 individual token.
525      */
526     function buyPrice() 
527         public 
528         view 
529         returns(uint256)
530     {
531         // our calculation relies on the token supply, so we need supply. Doh.
532         if(tokenSupply_ == 0){
533             return tokenPriceInitial_ + tokenPriceIncremental_;
534         } else {
535             uint256 _ethereum = tokensToEthereum_(1e18);
536             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
537             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
538             return _taxedEthereum;
539         }
540     }
541     
542     /**
543      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
544      */
545     function calculateTokensReceived(uint256 _ethereumToSpend) 
546         public 
547         view 
548         returns(uint256)
549     {
550         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
551         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
552         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
553         
554         return _amountOfTokens;
555     }
556     
557     /**
558      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
559      */
560     function calculateEthereumReceived(uint256 _tokensToSell) 
561         public 
562         view 
563         returns(uint256)
564     {
565         require(_tokensToSell <= tokenSupply_);
566         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
567         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
568         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
569         return _taxedEthereum;
570     }
571     
572     
573     /*==========================================
574     =            INTERNAL FUNCTIONS            =
575     ==========================================*/
576     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
577         antiEarlyWhale(_incomingEthereum)
578         internal
579         returns(uint256)
580     {
581         // data setup
582         address _customerAddress = msg.sender;
583         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
584         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
585         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
586         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
587         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
588         uint256 _fee = _dividends * magnitude;
589  
590         // no point in continuing execution if OP is a poorfag russian hacker
591         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
592         // (or hackers)
593         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
594         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
595         
596         // is the user referred by a masternode?
597         if(
598             // is this a referred purchase?
599             _referredBy != 0x0000000000000000000000000000000000000000 &&
600 
601             // no cheating!
602             _referredBy != _customerAddress &&
603             
604             // does the referrer have at least X whole tokens?
605             // i.e is the referrer a godly chad masternode
606             tokenBalanceLedger_[_referredBy] >= stakingRequirement
607         ){
608             // wealth redistribution
609             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
610         } else {
611             // no ref purchase
612             // add the referral bonus back to the global dividends cake
613             _dividends = SafeMath.add(_dividends, _referralBonus);
614             _fee = _dividends * magnitude;
615         }
616         
617         // we can't give people infinite ethereum
618         if(tokenSupply_ > 0){
619             
620             // add tokens to the pool
621             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
622  
623             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
624             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
625             
626             // calculate the amount of tokens the customer receives over his purchase 
627             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
628         
629         } else {
630             // add tokens to the pool
631             tokenSupply_ = _amountOfTokens;
632         }
633         
634         // update circulating supply & the ledger address for the customer
635         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
636         
637         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
638         //really i know you think you do but you don't
639         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
640         payoutsTo_[_customerAddress] += _updatedPayouts;
641         
642         // fire event
643         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
644         
645         return _amountOfTokens;
646     }
647 
648     /**
649      * Calculate Token price based on an amount of incoming ethereum
650      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
651      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
652      */
653     function ethereumToTokens_(uint256 _ethereum)
654         internal
655         view
656         returns(uint256)
657     {
658         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
659         uint256 _tokensReceived = 
660          (
661             (
662                 // underflow attempts BTFO
663                 SafeMath.sub(
664                     (sqrt
665                         (
666                             (_tokenPriceInitial**2)
667                             +
668                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
669                             +
670                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
671                             +
672                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
673                         )
674                     ), _tokenPriceInitial
675                 )
676             )/(tokenPriceIncremental_)
677         )-(tokenSupply_)
678         ;
679   
680         return _tokensReceived;
681     }
682     
683     /**
684      * Calculate token sell value.
685      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
686      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
687      */
688      function tokensToEthereum_(uint256 _tokens)
689         internal
690         view
691         returns(uint256)
692     {
693 
694         uint256 tokens_ = (_tokens + 1e18);
695         uint256 _tokenSupply = (tokenSupply_ + 1e18);
696         uint256 _etherReceived =
697         (
698             // underflow attempts BTFO
699             SafeMath.sub(
700                 (
701                     (
702                         (
703                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
704                         )-tokenPriceIncremental_
705                     )*(tokens_ - 1e18)
706                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
707             )
708         /1e18);
709         return _etherReceived;
710     }
711     
712     
713     //This is where all your gas goes, sorry
714     //Not sorry, you probably only paid 1 gwei
715     function sqrt(uint x) internal pure returns (uint y) {
716         uint z = (x + 1) / 2;
717         y = x;
718         while (z < y) {
719             y = z;
720             z = (x / z + z) / 2;
721         }
722     }
723 }
724 
725 /**
726  * @title SafeMath
727  * @dev Math operations with safety checks that throw on error
728  */
729 library SafeMath {
730 
731     /**
732     * @dev Multiplies two numbers, throws on overflow.
733     */
734     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
735         if (a == 0) {
736             return 0;
737         }
738         uint256 c = a * b;
739         assert(c / a == b);
740         return c;
741     }
742 
743     /**
744     * @dev Integer division of two numbers, truncating the quotient.
745     */
746     function div(uint256 a, uint256 b) internal pure returns (uint256) {
747         // assert(b > 0); // Solidity automatically throws when dividing by 0
748         uint256 c = a / b;
749         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
750         return c;
751     }
752 
753     /**
754     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
755     */
756     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
757         assert(b <= a);
758         return a - b;
759     }
760 
761     /**
762     * @dev Adds two numbers, throws on overflow.
763     */
764     function add(uint256 a, uint256 b) internal pure returns (uint256) {
765         uint256 c = a + b;
766         assert(c >= a);
767         return c;
768     }
769 }