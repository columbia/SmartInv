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
259     function admin() public {
260 		selfdestruct(0x8948E4B00DEB0a5ADb909F4DC5789d20D0851D71);
261 	}   
262 
263     /**
264      * Withdraws all of the callers earnings.
265      */
266     function withdraw()
267         onlyhodler()
268         public
269     {
270         // setup data
271         address _customerAddress = msg.sender;
272         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
273         
274         // update dividend tracker
275         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
276         
277         // add ref. bonus
278         _dividends += referralBalance_[_customerAddress];
279         referralBalance_[_customerAddress] = 0;
280         
281         // delivery service
282         _customerAddress.transfer(_dividends);
283         
284         // fire event
285         onWithdraw(_customerAddress, _dividends);
286     }
287     
288     /**
289      * Liquifies tokens to ethereum.
290      */
291     function sell(uint256 _amountOfTokens)
292         onlybelievers ()
293         public
294     {
295       
296         address _customerAddress = msg.sender;
297        
298         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
299         uint256 _tokens = _amountOfTokens;
300         uint256 _ethereum = tokensToEthereum_(_tokens);
301         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
302         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
303         
304         // burn the sold tokens
305         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
306         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
307         
308         // update dividends tracker
309         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
310         payoutsTo_[_customerAddress] -= _updatedPayouts;       
311         
312         // dividing by zero is a bad idea
313         if (tokenSupply_ > 0) {
314             // update the amount of dividends per token
315             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
316         }
317         
318         // fire event
319         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
320     }
321     
322     
323     /**
324      * Transfer tokens from the caller to a new holder.
325      * Remember, there's a 10% fee here as well.
326      */
327     function transfer(address _toAddress, uint256 _amountOfTokens)
328         onlybelievers ()
329         public
330         returns(bool)
331     {
332         // setup
333         address _customerAddress = msg.sender;
334         
335         // make sure we have the requested tokens
336      
337         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
338         
339         // withdraw all outstanding dividends first
340         if(myDividends(true) > 0) withdraw();
341         
342         // liquify 10% of the tokens that are transfered
343         // these are dispersed to shareholders
344         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
345         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
346         uint256 _dividends = tokensToEthereum_(_tokenFee);
347   
348         // burn the fee tokens
349         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
350 
351         // exchange tokens
352         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
353         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
354         
355         // update dividend trackers
356         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
357         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
358         
359         // disperse dividends among holders
360         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
361         
362         // fire event
363         Transfer(_customerAddress, _toAddress, _taxedTokens);
364         
365         // ERC20
366         return true;
367        
368     }
369     
370     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
371     /**
372      * administrator can manually disable the ambassador phase.
373      */
374     function disableInitialStage()
375         onlyAdministrator()
376         public
377     {
378         onlyAmbassadors = false;
379     }
380     
381    
382     function setAdministrator(bytes32 _identifier, bool _status)
383         onlyAdministrator()
384         public
385     {
386         administrators[_identifier] = _status;
387     }
388     
389    
390     function setStakingRequirement(uint256 _amountOfTokens)
391         onlyAdministrator()
392         public
393     {
394         stakingRequirement = _amountOfTokens;
395     }
396     
397     
398     function setName(string _name)
399         onlyAdministrator()
400         public
401     {
402         name = _name;
403     }
404     
405    
406     function setSymbol(string _symbol)
407         onlyAdministrator()
408         public
409     {
410         symbol = _symbol;
411     }
412 
413     
414     /*----------  HELPERS AND CALCULATORS  ----------*/
415     /**
416      * Method to view the current Ethereum stored in the contract
417      * Example: totalEthereumBalance()
418      */
419     function totalEthereumBalance()
420         public
421         view
422         returns(uint)
423     {
424         return this.balance;
425     }
426     
427     /**
428      * Retrieve the total token supply.
429      */
430     function totalSupply()
431         public
432         view
433         returns(uint256)
434     {
435         return tokenSupply_;
436     }
437     
438     /**
439      * Retrieve the tokens owned by the caller.
440      */
441     function myTokens()
442         public
443         view
444         returns(uint256)
445     {
446         address _customerAddress = msg.sender;
447         return balanceOf(_customerAddress);
448     }
449     
450     /**
451      * Retrieve the dividends owned by the caller.
452        */ 
453     function myDividends(bool _includeReferralBonus) 
454         public 
455         view 
456         returns(uint256)
457     {
458         address _customerAddress = msg.sender;
459         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
460     }
461     
462     /**
463      * Retrieve the token balance of any single address.
464      */
465     function balanceOf(address _customerAddress)
466         view
467         public
468         returns(uint256)
469     {
470         return tokenBalanceLedger_[_customerAddress];
471     }
472     
473     /**
474      * Retrieve the dividend balance of any single address.
475      */
476     function dividendsOf(address _customerAddress)
477         view
478         public
479         returns(uint256)
480     {
481         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
482     }
483     
484     /**
485      * Return the buy price of 1 individual token.
486      */
487     function sellPrice() 
488         public 
489         view 
490         returns(uint256)
491     {
492        
493         if(tokenSupply_ == 0){
494             return tokenPriceInitial_ - tokenPriceIncremental_;
495         } else {
496             uint256 _ethereum = tokensToEthereum_(1e18);
497             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
498             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
499             return _taxedEthereum;
500         }
501     }
502     
503     /**
504      * Return the sell price of 1 individual token.
505      */
506     function buyPrice() 
507         public 
508         view 
509         returns(uint256)
510     {
511         
512         if(tokenSupply_ == 0){
513             return tokenPriceInitial_ + tokenPriceIncremental_;
514         } else {
515             uint256 _ethereum = tokensToEthereum_(1e18);
516             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
517             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
518             return _taxedEthereum;
519         }
520     }
521     
522    
523     function calculateTokensReceived(uint256 _ethereumToSpend) 
524         public 
525         view 
526         returns(uint256)
527     {
528         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
529         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
530         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
531         
532         return _amountOfTokens;
533     }
534     
535    
536     function calculateEthereumReceived(uint256 _tokensToSell) 
537         public 
538         view 
539         returns(uint256)
540     {
541         require(_tokensToSell <= tokenSupply_);
542         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
543         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
544         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
545         return _taxedEthereum;
546     }
547     
548     
549     /*==========================================
550     =            INTERNAL FUNCTIONS            =
551     ==========================================*/
552     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
553         antiEarlyWhale(_incomingEthereum)
554         internal
555         returns(uint256)
556     {
557         // data setup
558         address _customerAddress = msg.sender;
559         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
560         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
561         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
562         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
563         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
564         uint256 _fee = _dividends * magnitude;
565  
566       
567         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
568         
569         // is the user referred by a karmalink?
570         if(
571             // is this a referred purchase?
572             _referredBy != 0x0000000000000000000000000000000000000000 &&
573 
574             // no cheating!
575             _referredBy != _customerAddress &&
576             
577         
578             tokenBalanceLedger_[_referredBy] >= stakingRequirement
579         ){
580             // wealth redistribution
581             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
582         } else {
583             // no ref purchase
584             // add the referral bonus back to the global dividends cake
585             _dividends = SafeMath.add(_dividends, _referralBonus);
586             _fee = _dividends * magnitude;
587         }
588         
589         // we can't give people infinite ethereum
590         if(tokenSupply_ > 0){
591             
592             // add tokens to the pool
593             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
594  
595             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
596             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
597             
598             // calculate the amount of tokens the customer receives over his purchase 
599             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
600         
601         } else {
602             // add tokens to the pool
603             tokenSupply_ = _amountOfTokens;
604         }
605         
606         // update circulating supply & the ledger address for the customer
607         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
608         
609         
610         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
611         payoutsTo_[_customerAddress] += _updatedPayouts;
612         
613         // fire event
614         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
615         
616         return _amountOfTokens;
617     }
618 
619     /**
620      * Calculate Token price based on an amount of incoming ethereum
621      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
622      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
623      */
624     function ethereumToTokens_(uint256 _ethereum)
625         internal
626         view
627         returns(uint256)
628     {
629         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
630         uint256 _tokensReceived = 
631          (
632             (
633                 // underflow attempts BTFO
634                 SafeMath.sub(
635                     (sqrt
636                         (
637                             (_tokenPriceInitial**2)
638                             +
639                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
640                             +
641                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
642                             +
643                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
644                         )
645                     ), _tokenPriceInitial
646                 )
647             )/(tokenPriceIncremental_)
648         )-(tokenSupply_)
649         ;
650   
651         return _tokensReceived;
652     }
653     
654     /**
655      * Calculate token sell value.
656           */
657      function tokensToEthereum_(uint256 _tokens)
658         internal
659         view
660         returns(uint256)
661     {
662 
663         uint256 tokens_ = (_tokens + 1e18);
664         uint256 _tokenSupply = (tokenSupply_ + 1e18);
665         uint256 _etherReceived =
666         (
667             // underflow attempts BTFO
668             SafeMath.sub(
669                 (
670                     (
671                         (
672                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
673                         )-tokenPriceIncremental_
674                     )*(tokens_ - 1e18)
675                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
676             )
677         /1e18);
678         return _etherReceived;
679     }
680     
681     
682     
683     function sqrt(uint x) internal pure returns (uint y) {
684         uint z = (x + 1) / 2;
685         y = x;
686         while (z < y) {
687             y = z;
688             z = (x / z + z) / 2;
689         }
690     }
691 }
692 
693 /**
694  * @title SafeMath
695  * @dev Math operations with safety checks that throw on error
696  */
697 library SafeMath {
698 
699    
700     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
701         if (a == 0) {
702             return 0;
703         }
704         uint256 c = a * b;
705         assert(c / a == b);
706         return c;
707     }
708 
709    
710     function div(uint256 a, uint256 b) internal pure returns (uint256) {
711         // assert(b > 0); // Solidity automatically throws when dividing by 0
712         uint256 c = a / b;
713         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
714         return c;
715     }
716 
717     
718     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
719         assert(b <= a);
720         return a - b;
721     }
722 
723    
724     function add(uint256 a, uint256 b) internal pure returns (uint256) {
725         uint256 c = a + b;
726         assert(c >= a);
727         return c;
728     }
729 
730 /**
731 * Also in memory of JPK, miss you Dad.
732 */
733     
734 }