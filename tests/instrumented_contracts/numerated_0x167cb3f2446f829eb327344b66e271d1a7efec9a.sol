1 pragma solidity ^0.4.20;
2 
3 /*
4 
5 *A reincarnation of Mahatma Gandhi, born again to live forever on the Ethereum Blockchain
6 
7                                                                                                                                                        
8                                                                     dddddddd                                                                           
9         GGGGGGGGGGGGG                                               d::::::dhhhhhhh               iiii   jjjj   iiii            iiii                   
10      GGG::::::::::::G                                               d::::::dh:::::h              i::::i j::::j i::::i          i::::i                  
11    GG:::::::::::::::G                                               d::::::dh:::::h               iiii   jjjj   iiii            iiii                   
12   G:::::GGGGGGGG::::G                                               d:::::d h:::::h                                                                    
13  G:::::G       GGGGGG  aaaaaaaaaaaaa  nnnn  nnnnnnnn        ddddddddd:::::d  h::::h hhhhh       iiiiiiijjjjjjjiiiiiii         iiiiiii    ooooooooooo   
14 G:::::G                a::::::::::::a n:::nn::::::::nn    dd::::::::::::::d  h::::hh:::::hhh    i:::::ij:::::ji:::::i         i:::::i  oo:::::::::::oo 
15 G:::::G                aaaaaaaaa:::::an::::::::::::::nn  d::::::::::::::::d  h::::::::::::::hh   i::::i j::::j i::::i          i::::i o:::::::::::::::o
16 G:::::G    GGGGGGGGGG           a::::ann:::::::::::::::nd:::::::ddddd:::::d  h:::::::hhh::::::h  i::::i j::::j i::::i          i::::i o:::::ooooo:::::o
17 G:::::G    G::::::::G    aaaaaaa:::::a  n:::::nnnn:::::nd::::::d    d:::::d  h::::::h   h::::::h i::::i j::::j i::::i          i::::i o::::o     o::::o
18 G:::::G    GGGGG::::G  aa::::::::::::a  n::::n    n::::nd:::::d     d:::::d  h:::::h     h:::::h i::::i j::::j i::::i          i::::i o::::o     o::::o
19 G:::::G        G::::G a::::aaaa::::::a  n::::n    n::::nd:::::d     d:::::d  h:::::h     h:::::h i::::i j::::j i::::i          i::::i o::::o     o::::o
20  G:::::G       G::::Ga::::a    a:::::a  n::::n    n::::nd:::::d     d:::::d  h:::::h     h:::::h i::::i j::::j i::::i          i::::i o::::o     o::::o
21   G:::::GGGGGGGG::::Ga::::a    a:::::a  n::::n    n::::nd::::::ddddd::::::dd h:::::h     h:::::hi::::::ij::::ji::::::i        i::::::io:::::ooooo:::::o
22    GG:::::::::::::::Ga:::::aaaa::::::a  n::::n    n::::n d:::::::::::::::::d h:::::h     h:::::hi::::::ij::::ji::::::i ...... i::::::io:::::::::::::::o
23      GGG::::::GGG:::G a::::::::::aa:::a n::::n    n::::n  d:::::::::ddd::::d h:::::h     h:::::hi::::::ij::::ji::::::i .::::. i::::::i oo:::::::::::oo 
24         GGGGGG   GGGG  aaaaaaaaaa  aaaa nnnnnn    nnnnnn   ddddddddd   ddddd hhhhhhh     hhhhhhhiiiiiiiij::::jiiiiiiii ...... iiiiiiii   ooooooooooo   
25                                                                                                         j::::j                                         
26                                                                                               jjjj      j::::j                                         
27                                                                                              j::::jj   j:::::j                                         
28                                                                                              j::::::jjj::::::j                                         
29                                                                                               jj::::::::::::j                                          
30                                                                                                 jjj::::::jjj                                           
31                                                                                                    jjjjjj                                              
32 
33 *Where there is love there is life.
34 *Happiness is when what you think, what you say, and what you do are in harmony.
35 *You must not lose faith in humanity. Humanity is an ocean; if a few drops of the ocean are dirty, the ocean does not become dirty.
36 *In a gentle way, you can shake the world.
37 *The weak can never forgive. Forgiveness is the attribute of the strong.
38 *Strength does not come from physical capacity. It comes from an indomitable will.
39 *A man is but the product of his thoughts; what he thinks, he becomes.
40 *Earth provides enough to satisfy every man's needs, but not every man's greed.
41 *Freedom is not worth having if it does not include the freedom to make mistakes.
42 *I will not let anyone walk through my mind with their dirty feet.
43 *
44 *A tribute to Mohandas Karamchand Gandhi Ji -  2 October 1869 – 30 January 1948 -  Jai Hind! 
45 */
46 
47 contract GandhiJi {
48     /*=================================
49     =            MODIFIERS            =
50     =================================*/
51     // only people with tokens
52     modifier onlybelievers () {
53         require(myTokens() > 0);
54         _;
55     }
56     
57     // only people with profits
58     modifier onlyhodler() {
59         require(myDividends(true) > 0);
60         _;
61     }
62     
63     // administrators can:
64     // -> change the name of the contract
65     // -> change the name of the token
66     // -> change the PoS difficulty 
67     // they CANNOT:
68     // -> take funds
69     // -> disable withdrawals
70     // -> kill the contract
71     // -> change the price of tokens
72     modifier onlyAdministrator(){
73         address _customerAddress = msg.sender;
74         require(administrators[keccak256(_customerAddress)]);
75         _;
76     }
77     
78     
79     modifier antiEarlyWhale(uint256 _amountOfEthereum){
80         address _customerAddress = msg.sender;
81         
82       
83         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
84             require(
85                 // is the customer in the ambassador list?
86                 ambassadors_[_customerAddress] == true &&
87                 
88                 // does the customer purchase exceed the max ambassador quota?
89                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
90                 
91             );
92             
93             // updated the accumulated quota    
94             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
95         
96             // execute
97             _;
98         } else {
99             // in case the ether count drops low, the ambassador phase won't reinitiate
100             onlyAmbassadors = false;
101             _;    
102         }
103         
104     }
105     
106     
107     /*==============================
108     =            EVENTS            =
109     ==============================*/
110     event onTokenPurchase(
111         address indexed customerAddress,
112         uint256 incomingEthereum,
113         uint256 tokensMinted,
114         address indexed referredBy
115     );
116     
117     event onTokenSell(
118         address indexed customerAddress,
119         uint256 tokensBurned,
120         uint256 ethereumEarned
121     );
122     
123     event onReinvestment(
124         address indexed customerAddress,
125         uint256 ethereumReinvested,
126         uint256 tokensMinted
127     );
128     
129     event onWithdraw(
130         address indexed customerAddress,
131         uint256 ethereumWithdrawn
132     );
133     
134     // ERC20
135     event Transfer(
136         address indexed from,
137         address indexed to,
138         uint256 tokens
139     );
140     
141     
142     /*=====================================
143     =            CONFIGURABLES            =
144     =====================================*/
145     string public name = "Gandhiji";
146     string public symbol = "IND";
147     uint8 constant public decimals = 18;
148     uint8 constant internal dividendFee_ = 10;
149     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
150     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
151     uint256 constant internal magnitude = 2**64;
152     
153     // proof of stake (defaults at 1 token)
154     uint256 public stakingRequirement = 1e18;
155     
156     // ambassador program
157     mapping(address => bool) internal ambassadors_;
158     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
159     uint256 constant internal ambassadorQuota_ = 1 ether;
160     
161     
162     
163    /*================================
164     =            DATASETS            =
165     ================================*/
166     // amount of shares for each address (scaled number)
167     mapping(address => uint256) internal tokenBalanceLedger_;
168     mapping(address => uint256) internal referralBalance_;
169     mapping(address => int256) internal payoutsTo_;
170     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
171     uint256 internal tokenSupply_ = 0;
172     uint256 internal profitPerShare_;
173     
174     // administrator list (see above on what they can do)
175     mapping(bytes32 => bool) public administrators;
176     
177     
178     bool public onlyAmbassadors = false;
179     
180 
181 
182     /*=======================================
183     =            PUBLIC FUNCTIONS            =
184     =======================================*/
185     /*
186     * -- APPLICATION ENTRY POINTS --  
187     */
188     function GandhiJi()
189         public
190     {
191         // add administrators here
192         administrators[0x9bcc16873606dc04acb98263f74c420525ddef61de0d5f18fd97d16de659131a] = true;
193 						 
194    
195         ambassadors_[0x0000000000000000000000000000000000000000] = true;
196                        
197     }
198     
199      
200     /**
201      * Converts all incoming Ethereum to tokens for the caller, and passes down the referral address (if any)
202      */
203     function buy(address _referredBy)
204         public
205         payable
206         returns(uint256)
207     {
208         purchaseTokens(msg.value, _referredBy);
209     }
210     
211     
212     function()
213         payable
214         public
215     {
216         purchaseTokens(msg.value, 0x0);
217     }
218     
219     /**
220      * Converts all of caller's dividends to tokens.
221      */
222     function reinvest()
223         onlyhodler()
224         public
225     {
226         // fetch dividends
227         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
228         
229         // pay out the dividends virtually
230         address _customerAddress = msg.sender;
231         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
232         
233         // retrieve ref. bonus
234         _dividends += referralBalance_[_customerAddress];
235         referralBalance_[_customerAddress] = 0;
236         
237         // dispatch a buy order with the virtualized "withdrawn dividends"
238         uint256 _tokens = purchaseTokens(_dividends, 0x0);
239         
240         // fire event
241         onReinvestment(_customerAddress, _dividends, _tokens);
242     }
243     
244     /**
245      * Alias of sell() and withdraw().
246      */
247     function exit()
248         public
249     {
250         // get token count for caller & sell them all
251         address _customerAddress = msg.sender;
252         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
253         if(_tokens > 0) sell(_tokens);
254         
255         
256         withdraw();
257     }
258 
259     /**
260      * Withdraws all of the callers earnings.
261      */
262     function withdraw()
263         onlyhodler()
264         public
265     {
266         // setup data
267         address _customerAddress = msg.sender;
268         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
269         
270         // update dividend tracker
271         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
272         
273         // add ref. bonus
274         _dividends += referralBalance_[_customerAddress];
275         referralBalance_[_customerAddress] = 0;
276         
277         // delivery service
278         _customerAddress.transfer(_dividends);
279         
280         // fire event
281         onWithdraw(_customerAddress, _dividends);
282     }
283     
284     /**
285      * Liquifies tokens to ethereum.
286      */
287     function sell(uint256 _amountOfTokens)
288         onlybelievers ()
289         public
290     {
291       
292         address _customerAddress = msg.sender;
293        
294         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
295         uint256 _tokens = _amountOfTokens;
296         uint256 _ethereum = tokensToEthereum_(_tokens);
297         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
298         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
299         
300         // burn the sold tokens
301         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
302         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
303         
304         // update dividends tracker
305         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
306         payoutsTo_[_customerAddress] -= _updatedPayouts;       
307         
308         // dividing by zero is a bad idea
309         if (tokenSupply_ > 0) {
310             // update the amount of dividends per token
311             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
312         }
313         
314         // fire event
315         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
316     }
317     
318     
319     /**
320      * Transfer tokens from the caller to a new holder.
321      * Remember, there's a 10% fee here as well.
322      */
323     function transfer(address _toAddress, uint256 _amountOfTokens)
324         onlybelievers ()
325         public
326         returns(bool)
327     {
328         // setup
329         address _customerAddress = msg.sender;
330         
331         // make sure we have the requested tokens
332      
333         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
334         
335         // withdraw all outstanding dividends first
336         if(myDividends(true) > 0) withdraw();
337         
338         // liquify 10% of the tokens that are transfered
339         // these are dispersed to shareholders
340         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
341         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
342         uint256 _dividends = tokensToEthereum_(_tokenFee);
343   
344         // burn the fee tokens
345         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
346 
347         // exchange tokens
348         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
349         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
350         
351         // update dividend trackers
352         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
353         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
354         
355         // disperse dividends among holders
356         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
357         
358         // fire event
359         Transfer(_customerAddress, _toAddress, _taxedTokens);
360         
361         // ERC20
362         return true;
363        
364     }
365     
366     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
367     /**
368      * administrator can manually disable the ambassador phase.
369      */
370     function disableInitialStage()
371         onlyAdministrator()
372         public
373     {
374         onlyAmbassadors = false;
375     }
376     
377    
378     function setAdministrator(bytes32 _identifier, bool _status)
379         onlyAdministrator()
380         public
381     {
382         administrators[_identifier] = _status;
383     }
384     
385    
386     function setStakingRequirement(uint256 _amountOfTokens)
387         onlyAdministrator()
388         public
389     {
390         stakingRequirement = _amountOfTokens;
391     }
392     
393     
394     function setName(string _name)
395         onlyAdministrator()
396         public
397     {
398         name = _name;
399     }
400     
401    
402     function setSymbol(string _symbol)
403         onlyAdministrator()
404         public
405     {
406         symbol = _symbol;
407     }
408 
409     
410     /*----------  HELPERS AND CALCULATORS  ----------*/
411     /**
412      * Method to view the current Ethereum stored in the contract
413      * Example: totalEthereumBalance()
414      */
415     function totalEthereumBalance()
416         public
417         view
418         returns(uint)
419     {
420         return this.balance;
421     }
422     
423     /**
424      * Retrieve the total token supply.
425      */
426     function totalSupply()
427         public
428         view
429         returns(uint256)
430     {
431         return tokenSupply_;
432     }
433     
434     /**
435      * Retrieve the tokens owned by the caller.
436      */
437     function myTokens()
438         public
439         view
440         returns(uint256)
441     {
442         address _customerAddress = msg.sender;
443         return balanceOf(_customerAddress);
444     }
445     
446     /**
447      * Retrieve the dividends owned by the caller.
448        */ 
449     function myDividends(bool _includeReferralBonus) 
450         public 
451         view 
452         returns(uint256)
453     {
454         address _customerAddress = msg.sender;
455         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
456     }
457     
458     /**
459      * Retrieve the token balance of any single address.
460      */
461     function balanceOf(address _customerAddress)
462         view
463         public
464         returns(uint256)
465     {
466         return tokenBalanceLedger_[_customerAddress];
467     }
468     
469     /**
470      * Retrieve the dividend balance of any single address.
471      */
472     function dividendsOf(address _customerAddress)
473         view
474         public
475         returns(uint256)
476     {
477         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
478     }
479     
480     /**
481      * Return the buy price of 1 individual token.
482      */
483     function sellPrice() 
484         public 
485         view 
486         returns(uint256)
487     {
488        
489         if(tokenSupply_ == 0){
490             return tokenPriceInitial_ - tokenPriceIncremental_;
491         } else {
492             uint256 _ethereum = tokensToEthereum_(1e18);
493             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
494             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
495             return _taxedEthereum;
496         }
497     }
498     
499     /**
500      * Return the sell price of 1 individual token.
501      */
502     function buyPrice() 
503         public 
504         view 
505         returns(uint256)
506     {
507         
508         if(tokenSupply_ == 0){
509             return tokenPriceInitial_ + tokenPriceIncremental_;
510         } else {
511             uint256 _ethereum = tokensToEthereum_(1e18);
512             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
513             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
514             return _taxedEthereum;
515         }
516     }
517     
518    
519     function calculateTokensReceived(uint256 _ethereumToSpend) 
520         public 
521         view 
522         returns(uint256)
523     {
524         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
525         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
526         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
527         
528         return _amountOfTokens;
529     }
530     
531    
532     function calculateEthereumReceived(uint256 _tokensToSell) 
533         public 
534         view 
535         returns(uint256)
536     {
537         require(_tokensToSell <= tokenSupply_);
538         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
539         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
540         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
541         return _taxedEthereum;
542     }
543     
544     
545     /*==========================================
546     =            INTERNAL FUNCTIONS            =
547     ==========================================*/
548     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
549         antiEarlyWhale(_incomingEthereum)
550         internal
551         returns(uint256)
552     {
553         // data setup
554         address _customerAddress = msg.sender;
555         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
556         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
557         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
558         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
559         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
560         uint256 _fee = _dividends * magnitude;
561  
562       
563         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
564         
565         // is the user referred by a karmalink?
566         if(
567             // is this a referred purchase?
568             _referredBy != 0x0000000000000000000000000000000000000000 &&
569 
570             // no cheating!
571             _referredBy != _customerAddress &&
572             
573         
574             tokenBalanceLedger_[_referredBy] >= stakingRequirement
575         ){
576             // wealth redistribution
577             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
578         } else {
579             // no ref purchase
580             // add the referral bonus back to the global dividends cake
581             _dividends = SafeMath.add(_dividends, _referralBonus);
582             _fee = _dividends * magnitude;
583         }
584         
585         // we can't give people infinite ethereum
586         if(tokenSupply_ > 0){
587             
588             // add tokens to the pool
589             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
590  
591             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
592             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
593             
594             // calculate the amount of tokens the customer receives over his purchase 
595             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
596         
597         } else {
598             // add tokens to the pool
599             tokenSupply_ = _amountOfTokens;
600         }
601         
602         // update circulating supply & the ledger address for the customer
603         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
604         
605         
606         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
607         payoutsTo_[_customerAddress] += _updatedPayouts;
608         
609         // fire event
610         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
611         
612         return _amountOfTokens;
613     }
614 
615     /**
616      * Calculate Token price based on an amount of incoming ethereum
617      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
618      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
619      */
620     function ethereumToTokens_(uint256 _ethereum)
621         internal
622         view
623         returns(uint256)
624     {
625         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
626         uint256 _tokensReceived = 
627          (
628             (
629                 // underflow attempts BTFO
630                 SafeMath.sub(
631                     (sqrt
632                         (
633                             (_tokenPriceInitial**2)
634                             +
635                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
636                             +
637                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
638                             +
639                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
640                         )
641                     ), _tokenPriceInitial
642                 )
643             )/(tokenPriceIncremental_)
644         )-(tokenSupply_)
645         ;
646   
647         return _tokensReceived;
648     }
649     
650     /**
651      * Calculate token sell value.
652           */
653      function tokensToEthereum_(uint256 _tokens)
654         internal
655         view
656         returns(uint256)
657     {
658 
659         uint256 tokens_ = (_tokens + 1e18);
660         uint256 _tokenSupply = (tokenSupply_ + 1e18);
661         uint256 _etherReceived =
662         (
663             // underflow attempts BTFO
664             SafeMath.sub(
665                 (
666                     (
667                         (
668                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
669                         )-tokenPriceIncremental_
670                     )*(tokens_ - 1e18)
671                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
672             )
673         /1e18);
674         return _etherReceived;
675     }
676     
677     
678     
679     function sqrt(uint x) internal pure returns (uint y) {
680         uint z = (x + 1) / 2;
681         y = x;
682         while (z < y) {
683             y = z;
684             z = (x / z + z) / 2;
685         }
686     }
687 }
688 
689 /**
690  * @title SafeMath
691  * @dev Math operations with safety checks that throw on error
692  */
693 library SafeMath {
694 
695    
696     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
697         if (a == 0) {
698             return 0;
699         }
700         uint256 c = a * b;
701         assert(c / a == b);
702         return c;
703     }
704 
705    
706     function div(uint256 a, uint256 b) internal pure returns (uint256) {
707         // assert(b > 0); // Solidity automatically throws when dividing by 0
708         uint256 c = a / b;
709         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
710         return c;
711     }
712 
713     
714     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
715         assert(b <= a);
716         return a - b;
717     }
718 
719    
720     function add(uint256 a, uint256 b) internal pure returns (uint256) {
721         uint256 c = a + b;
722         assert(c >= a);
723         return c;
724     }
725 
726 /**
727 * Also in memory of JPK, miss you Dad.
728 */
729     
730 }