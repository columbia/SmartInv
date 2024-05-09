1 /*
2 * ....................../´¯/) 
3 ....................,/¯../ 
4 .................../..../ 
5 ............./´¯/'...'/´¯¯`·¸ 
6 ........../'/.../..../......./¨¯\ 
7 ........('(...´...´.... ¯~/'...') 
8 .........\.................'...../ 
9 ..........''...\.......... _.·´ 
10 ............\..............( 
11 ..............\.............\...
12 * 187
13 * Burn Kenny Burn !
14 
15 Fuck kenny
16   should of read the code
17  _                      
18 | |                     
19 | |__  _   _ _ __ _ __  
20 | '_ \| | | | '__| '_ \ 
21 | |_) | |_| | |  | | | |      
22 |_.__/ \__,_|_|  |_| |_|
23 
24  _                          
25 | |                         
26 | | _____ _ __  _ __  _   _ 
27 | |/ / _ \ '_ \| '_ \| | | |
28 |   <  __/ | | | | | | |_| |
29 |_|\_\___|_| |_|_| |_|\__, |
30                        __/ |
31                       |___/ 
32 
33  */   
34  
35 contract POKCC {
36     /*=================================
37     =            MODIFIERS            =
38     =================================*/
39     // only people with tokens
40     modifier onlyBagholders() {
41         require(myTokens() > 0);
42         _;
43     }
44     
45     // only people with profits
46     modifier onlyStronghands() {
47         require(myDividends(true) > 0);
48         _;
49     }
50     
51     // administrators can:
52     // -> change the name of the contract
53     // -> change the name of the token
54     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
55     // they CANNOT:
56     // -> take funds
57     // -> disable withdrawals
58     // -> kill the contract
59     // -> change the price of tokens
60     modifier onlyAdministrator(){
61         address _customerAddress = msg.sender;
62         require(administrators[keccak256(_customerAddress)]);
63         _;
64     }
65     
66     
67     // ensures that the first tokens in the contract will be equally distributed
68     // meaning, no divine dump will be ever possible
69     // result: healthy longevity.
70     modifier antiEarlyWhale(uint256 _amountOfEthereum){
71         address _customerAddress = msg.sender;
72         
73         // are we still in the vulnerable phase?
74         // if so, enact anti early whale protocol 
75         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
76             require(
77                 // is the customer in the ambassador list?
78                 ambassadors_[_customerAddress] == true &&
79                 
80                 // does the customer purchase exceed the max ambassador quota?
81                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
82                 
83             );
84             
85             // updated the accumulated quota    
86             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
87         
88             // execute
89             _;
90         } else {
91             // in case the ether count drops low, the ambassador phase won't reinitiate
92             onlyAmbassadors = false;
93             _;    
94         }
95         
96     }
97     
98     
99     /*==============================
100     =            EVENTS            =
101     ==============================*/
102     event onTokenPurchase(
103         address indexed customerAddress,
104         uint256 incomingEthereum,
105         uint256 tokensMinted,
106         address indexed referredBy
107     );
108     
109     event onTokenSell(
110         address indexed customerAddress,
111         uint256 tokensBurned,
112         uint256 ethereumEarned
113     );
114     
115     event onReinvestment(
116         address indexed customerAddress,
117         uint256 ethereumReinvested,
118         uint256 tokensMinted
119     );
120     
121     event onWithdraw(
122         address indexed customerAddress,
123         uint256 ethereumWithdrawn
124     );
125     
126     // ERC20
127     event Transfer(
128         address indexed from,
129         address indexed to,
130         uint256 tokens
131     );
132     
133     
134     /*=====================================
135     =            CONFIGURABLES            =
136     =====================================*/
137     string public name = "POKCC";
138     string public symbol = "POKCC";
139     uint8 constant public decimals = 18;
140     uint8 constant internal dividendFee_ = 10;
141     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
142     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
143     uint256 constant internal magnitude = 2**64;
144     
145     // proof of stake (defaults at 100 tokens)
146     uint256 public stakingRequirement = 5e18;
147     
148     // ambassador program
149     mapping(address => bool) internal ambassadors_;
150     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
151     uint256 constant internal ambassadorQuota_ = 3 ether;
152     
153     
154     
155    /*================================
156     =            DATASETS            =
157     ================================*/
158     // amount of shares for each address (scaled number)
159     mapping(address => uint256) internal tokenBalanceLedger_;
160     mapping(address => uint256) internal referralBalance_;
161     mapping(address => int256) internal payoutsTo_;
162     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
163     uint256 internal tokenSupply_ = 0;
164     uint256 internal profitPerShare_;
165     
166     // administrator list (see above on what they can do)
167     mapping(bytes32 => bool) public administrators;
168     
169     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
170     bool public onlyAmbassadors = true;
171     
172 
173 
174     /*=======================================
175     =            PUBLIC FUNCTIONS            =
176     =======================================*/
177     /*
178     * -- APPLICATION ENTRY POINTS --  
179     */
180     function POKCC()
181         public
182     {
183         // add administrators here
184         //KIll Kenny! Drive it like you going to kill kenny!
185         administrators[0xb717f6069e33926531a6beb307cdef92eb72c54c3cc2d0bbabd6f90303988d14] = true; //c
186 
187         // add the ambassadors here. 
188         ambassadors_[0x7E754d57db0DEF3Cd9f1CeDeC61f638CEFFeaF0E] = true; //CC
189         ambassadors_[0x5536b2f8056Fd993537bF56168d2A0667224587C] = true; //LC
190         ambassadors_[0x267fa9F2F846da2c7A07eCeCc52dF7F493589098] = true; //Crypto Grandad
191         ambassadors_[0xef764BAC8a438E7E498c2E5fcCf0f174c3E3F8dB] = true; //Blur
192         ambassadors_[0x3460cad0381b6d4c6c37f5f82633bdad109f020a] = true; //DG
193         ambassadors_[0x11e52c75998fe2E7928B191bfc5B25937Ca16741] = true; //Klob
194 		ambassadors_[0x36EA59b8657bab4de6147a1B065033DC46008650] = true; //alex
195 	    ambassadors_[0x273569713c870E6C2faB2380c48975d4aB04e3D1] = true; //Hitman Fund
196 		ambassadors_[0x273569713c870E6C2faB2380c48975d4aB04e3D1] = true; //clean Up Crew
197  
198     }
199     
200      
201     /**
202      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
203      */
204     function buy(address _referredBy)
205         public
206         payable
207         returns(uint256)
208     {
209         purchaseTokens(msg.value, _referredBy);
210     }
211     
212     /**
213      * Fallback function to handle ethereum that was send straight to the contract
214      * Unfortunately we cannot use a referral address this way.
215      */
216     function()
217         payable
218         public
219     {
220         purchaseTokens(msg.value, 0x0);
221     }
222     
223     /**
224      * Converts all of caller's dividends to tokens.
225      */
226     function reinvest()
227         onlyStronghands()
228         public
229     {
230         // fetch dividends
231         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
232         
233         // pay out the dividends virtually
234         address _customerAddress = msg.sender;
235         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
236         
237         // retrieve ref. bonus
238         _dividends += referralBalance_[_customerAddress];
239         referralBalance_[_customerAddress] = 0;
240         
241         // dispatch a buy order with the virtualized "withdrawn dividends"
242         uint256 _tokens = purchaseTokens(_dividends, 0x0);
243         
244         // fire event
245         onReinvestment(_customerAddress, _dividends, _tokens);
246     }
247     
248     /**
249      * Alias of sell() and withdraw().
250      */
251     function exit()
252         public
253     {
254         // get token count for caller & sell them all
255         address _customerAddress = msg.sender;
256         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
257         if(_tokens > 0) sell(_tokens);
258         
259         // lambo delivery service
260         withdraw();
261     }
262 
263     /**
264      * Withdraws all of the callers earnings.
265      */
266     function withdraw()
267         onlyStronghands()
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
281         // lambo delivery service
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
292         onlyBagholders()
293         public
294     {
295         // setup data
296         address _customerAddress = msg.sender;
297         // russian hackers BTFO
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
328         onlyBagholders()
329         public
330         returns(bool)
331     {
332         // setup
333         address _customerAddress = msg.sender;
334         
335         // make sure we have the requested tokens
336         // also disables transfers until ambassador phase is over
337         // ( we dont want whale premines )
338         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
339         
340         // withdraw all outstanding dividends first
341         if(myDividends(true) > 0) withdraw();
342         
343         // liquify 10% of the tokens that are transfered
344         // these are dispersed to shareholders
345         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
346         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
347         uint256 _dividends = tokensToEthereum_(_tokenFee);
348   
349         // burn the fee tokens
350         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
351 
352         // exchange tokens
353         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
354         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
355         
356         // update dividend trackers
357         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
358         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
359         
360         // disperse dividends among holders
361         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
362         
363         // fire event
364         Transfer(_customerAddress, _toAddress, _taxedTokens);
365         
366         // ERC20
367         return true;
368        
369     }
370     
371     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
372     /**
373      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
374      */
375     function disableInitialStage()
376         onlyAdministrator()
377         public
378     {
379         onlyAmbassadors = false;
380     }
381     
382     /**
383      * In case one of us dies, we need to replace ourselves.
384      */
385     function setAdministrator(bytes32 _identifier, bool _status)
386         onlyAdministrator()
387         public
388     {
389         administrators[_identifier] = _status;
390     }
391     
392     /**
393      * Precautionary measures in case we need to adjust the masternode rate.
394      */
395     function setStakingRequirement(uint256 _amountOfTokens)
396         onlyAdministrator()
397         public
398     {
399         stakingRequirement = _amountOfTokens;
400     }
401     
402     /**
403      * If we want to rebrand, we can.
404      */
405     function setName(string _name)
406         onlyAdministrator()
407         public
408     {
409         name = _name;
410     }
411     
412     /**
413      * If we want to rebrand, we can.
414      */
415     function setSymbol(string _symbol)
416         onlyAdministrator()
417         public
418     {
419         symbol = _symbol;
420     }
421 
422     
423     /*----------  HELPERS AND CALCULATORS  ----------*/
424     /**
425      * Method to view the current Ethereum stored in the contract
426      * Example: totalEthereumBalance()
427      */
428     function totalEthereumBalance()
429         public
430         view
431         returns(uint)
432     {
433         return address (this).balance;
434     }
435     
436     /**
437      * Retrieve the total token supply.
438      */
439     function totalSupply()
440         public
441         view
442         returns(uint256)
443     {
444         return tokenSupply_;
445     }
446     
447     /**
448      * Retrieve the tokens owned by the caller.
449      */
450     function myTokens()
451         public
452         view
453         returns(uint256)
454     {
455         address _customerAddress = msg.sender;
456         return balanceOf(_customerAddress);
457     }
458     
459     /**
460      * Retrieve the dividends owned by the caller.
461      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
462      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
463      * But in the internal calculations, we want them separate. 
464      */ 
465     function myDividends(bool _includeReferralBonus) 
466         public 
467         view 
468         returns(uint256)
469     {
470         address _customerAddress = msg.sender;
471         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
472     }
473     
474     /**
475      * Retrieve the token balance of any single address.
476      */
477     function balanceOf(address _customerAddress)
478         view
479         public
480         returns(uint256)
481     {
482         return tokenBalanceLedger_[_customerAddress];
483     }
484     
485     /**
486      * Retrieve the dividend balance of any single address.
487      */
488     function dividendsOf(address _customerAddress)
489         view
490         public
491         returns(uint256)
492     {
493         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
494     }
495     
496     /**
497      * Return the buy price of 1 individual token.
498      */
499     function sellPrice() 
500         public 
501         view 
502         returns(uint256)
503     {
504         // our calculation relies on the token supply, so we need supply. Doh.
505         if(tokenSupply_ == 0){
506             return tokenPriceInitial_ - tokenPriceIncremental_;
507         } else {
508             uint256 _ethereum = tokensToEthereum_(1e18);
509             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
510             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
511             return _taxedEthereum;
512         }
513     }
514     
515     /**
516      * Return the sell price of 1 individual token.
517      */
518     function buyPrice() 
519         public 
520         view 
521         returns(uint256)
522     {
523         // our calculation relies on the token supply, so we need supply. Doh.
524         if(tokenSupply_ == 0){
525             return tokenPriceInitial_ + tokenPriceIncremental_;
526         } else {
527             uint256 _ethereum = tokensToEthereum_(1e18);
528             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
529             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
530             return _taxedEthereum;
531         }
532     }
533     
534     /**
535      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
536      */
537     function calculateTokensReceived(uint256 _ethereumToSpend) 
538         public 
539         view 
540         returns(uint256)
541     {
542         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
543         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
544         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
545         
546         return _amountOfTokens;
547     }
548     
549     /**
550      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
551      */
552     function calculateEthereumReceived(uint256 _tokensToSell) 
553         public 
554         view 
555         returns(uint256)
556     {
557         require(_tokensToSell <= tokenSupply_);
558         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
559         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
560         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
561         return _taxedEthereum;
562     }
563     
564     
565     /*==========================================
566     =            INTERNAL FUNCTIONS            =
567     ==========================================*/
568     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
569         antiEarlyWhale(_incomingEthereum)
570         internal
571         returns(uint256)
572     {
573         // data setup
574         address _customerAddress = msg.sender;
575         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
576         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
577         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
578         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
579         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
580         uint256 _fee = _dividends * magnitude;
581  
582         // no point in continuing execution if OP is a poorfag russian hacker
583         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
584         // (or hackers)
585         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
586         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
587         
588         // is the user referred by a masternode?
589         if(
590             // is this a referred purchase?
591             _referredBy != 0x0000000000000000000000000000000000000000 &&
592 
593             // no cheating!
594             _referredBy != _customerAddress &&
595             
596             // does the referrer have at least X whole tokens?
597             // i.e is the referrer a godly chad masternode
598             tokenBalanceLedger_[_referredBy] >= stakingRequirement
599         ){
600             // wealth redistribution
601             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
602         } else {
603             // no ref purchase
604             // add the referral bonus back to the global dividends cake
605             _dividends = SafeMath.add(_dividends, _referralBonus);
606             _fee = _dividends * magnitude;
607         }
608         
609         // we can't give people infinite ethereum
610         if(tokenSupply_ > 0){
611             
612             // add tokens to the pool
613             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
614  
615             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
616             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
617             
618             // calculate the amount of tokens the customer receives over his purchase 
619             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
620         
621         } else {
622             // add tokens to the pool
623             tokenSupply_ = _amountOfTokens;
624         }
625         
626         // update circulating supply & the ledger address for the customer
627         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
628         
629         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
630         //really i know you think you do but you don't
631         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
632         payoutsTo_[_customerAddress] += _updatedPayouts;
633         
634         // fire event
635         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
636         
637         return _amountOfTokens;
638     }
639 
640     /**
641      * Calculate Token price based on an amount of incoming ethereum
642      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
643      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
644      */
645     function ethereumToTokens_(uint256 _ethereum)
646         internal
647         view
648         returns(uint256)
649     {
650         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
651         uint256 _tokensReceived = 
652          (
653             (
654                 // underflow attempts BTFO
655                 SafeMath.sub(
656                     (sqrt
657                         (
658                             (_tokenPriceInitial**2)
659                             +
660                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
661                             +
662                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
663                             +
664                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
665                         )
666                     ), _tokenPriceInitial
667                 )
668             )/(tokenPriceIncremental_)
669         )-(tokenSupply_)
670         ;
671   
672         return _tokensReceived;
673     }
674     
675     /**
676      * Calculate token sell value.
677      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
678      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
679      */
680      function tokensToEthereum_(uint256 _tokens)
681         internal
682         view
683         returns(uint256)
684     {
685 
686         uint256 tokens_ = (_tokens + 1e18);
687         uint256 _tokenSupply = (tokenSupply_ + 1e18);
688         uint256 _etherReceived =
689         (
690             // underflow attempts BTFO
691             SafeMath.sub(
692                 (
693                     (
694                         (
695                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
696                         )-tokenPriceIncremental_
697                     )*(tokens_ - 1e18)
698                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
699             )
700         /1e18);
701         return _etherReceived;
702     }
703     
704     
705     //This is where all your gas goes, sorry
706     //Not sorry, you probably only paid 1 gwei
707     function sqrt(uint x) internal pure returns (uint y) {
708         uint z = (x + 1) / 2;
709         y = x;
710         while (z < y) {
711             y = z;
712             z = (x / z + z) / 2;
713         }
714     }
715 }
716 
717 /**
718  * @title SafeMath
719  * @dev Math operations with safety checks that throw on error
720  */
721 library SafeMath {
722 
723     /**
724     * @dev Multiplies two numbers, throws on overflow.
725     */
726     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
727         if (a == 0) {
728             return 0;
729         }
730         uint256 c = a * b;
731         assert(c / a == b);
732         return c;
733     }
734 
735     /**
736     * @dev Integer division of two numbers, truncating the quotient.
737     */
738     function div(uint256 a, uint256 b) internal pure returns (uint256) {
739         // assert(b > 0); // Solidity automatically throws when dividing by 0
740         uint256 c = a / b;
741         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
742         return c;
743     }
744 
745     /**
746     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
747     */
748     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
749         assert(b <= a);
750         return a - b;
751     }
752 
753     /**
754     * @dev Adds two numbers, throws on overflow.
755     */
756     function add(uint256 a, uint256 b) internal pure returns (uint256) {
757         uint256 c = a + b;
758         assert(c >= a);
759         return c;
760     }
761 }