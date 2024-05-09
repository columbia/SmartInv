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
12 * 
13 * Burn Kenny Burn !
14 
15  _                      
16 | |                     
17 | |__  _   _ _ __ _ __  
18 | '_ \| | | | '__| '_ \ 
19 | |_) | |_| | |  | | | |      
20 |_.__/ \__,_|_|  |_| |_|
21 
22  _                          
23 | |                         
24 | | _____ _ __  _ __  _   _ 
25 | |/ / _ \ '_ \| '_ \| | | |
26 |   <  __/ | | | | | | |_| |
27 |_|\_\___|_| |_|_| |_|\__, |
28                        __/ |
29                       |___/ 
30 
31  */   
32  
33 contract POKCC {
34     /*=================================
35     =            MODIFIERS            =
36     =================================*/
37     // only people with tokens
38     modifier onlyBagholders() {
39         require(myTokens() > 0);
40         _;
41     }
42     
43     // only people with profits
44     modifier onlyStronghands() {
45         require(myDividends(true) > 0);
46         _;
47     }
48     
49     // administrators can:
50     // -> change the name of the contract
51     // -> change the name of the token
52     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
53     // they CANNOT:
54     // -> take funds
55     // -> disable withdrawals
56     // -> kill the contract
57     // -> change the price of tokens
58     modifier onlyAdministrator(){
59         address _customerAddress = msg.sender;
60         require(administrators[keccak256(_customerAddress)]);
61         _;
62     }
63     
64     
65     // ensures that the first tokens in the contract will be equally distributed
66     // meaning, no divine dump will be ever possible
67     // result: healthy longevity.
68     modifier antiEarlyWhale(uint256 _amountOfEthereum){
69         address _customerAddress = msg.sender;
70         
71         // are we still in the vulnerable phase?
72         // if so, enact anti early whale protocol 
73         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
74             require(
75                 // is the customer in the ambassador list?
76                 ambassadors_[_customerAddress] == true &&
77                 
78                 // does the customer purchase exceed the max ambassador quota?
79                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
80                 
81             );
82             
83             // updated the accumulated quota    
84             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
85         
86             // execute
87             _;
88         } else {
89             // in case the ether count drops low, the ambassador phase won't reinitiate
90             onlyAmbassadors = false;
91             _;    
92         }
93         
94     }
95     
96     
97     /*==============================
98     =            EVENTS            =
99     ==============================*/
100     event onTokenPurchase(
101         address indexed customerAddress,
102         uint256 incomingEthereum,
103         uint256 tokensMinted,
104         address indexed referredBy
105     );
106     
107     event onTokenSell(
108         address indexed customerAddress,
109         uint256 tokensBurned,
110         uint256 ethereumEarned
111     );
112     
113     event onReinvestment(
114         address indexed customerAddress,
115         uint256 ethereumReinvested,
116         uint256 tokensMinted
117     );
118     
119     event onWithdraw(
120         address indexed customerAddress,
121         uint256 ethereumWithdrawn
122     );
123     
124     // ERC20
125     event Transfer(
126         address indexed from,
127         address indexed to,
128         uint256 tokens
129     );
130     
131     
132     /*=====================================
133     =            CONFIGURABLES            =
134     =====================================*/
135     string public name = "POKCC";
136     string public symbol = "POKCC";
137     uint8 constant public decimals = 18;
138     uint8 constant internal dividendFee_ = 10;
139     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
140     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
141     uint256 constant internal magnitude = 2**64;
142     
143     // proof of stake (defaults at 100 tokens)
144     uint256 public stakingRequirement = 5e18;
145     
146     // ambassador program
147     mapping(address => bool) internal ambassadors_;
148     uint256 constant internal ambassadorMaxPurchase_ = 2 ether;
149     uint256 constant internal ambassadorQuota_ = 3 ether;
150     
151     
152     
153    /*================================
154     =            DATASETS            =
155     ================================*/
156     // amount of shares for each address (scaled number)
157     mapping(address => uint256) internal tokenBalanceLedger_;
158     mapping(address => uint256) internal referralBalance_;
159     mapping(address => int256) internal payoutsTo_;
160     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
161     uint256 internal tokenSupply_ = 0;
162     uint256 internal profitPerShare_;
163     
164     // administrator list (see above on what they can do)
165     mapping(bytes32 => bool) public administrators;
166     
167     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
168     bool public onlyAmbassadors = true;
169     
170 
171 
172     /*=======================================
173     =            PUBLIC FUNCTIONS            =
174     =======================================*/
175     /*
176     * -- APPLICATION ENTRY POINTS --  
177     */
178     function POKCC()
179         public
180     {
181         // add administrators here
182         //fuck admin! Drive it like you stole it!
183         administrators[0x35a1770991162b35df75c3e4d087aba07ef60e477f55faf45cf69e20f364464c] = true; //c
184 
185         // add the ambassadors here. 
186         ambassadors_[0x7E754d57db0DEF3Cd9f1CeDeC61f638CEFFeaF0E] = true; //c
187         ambassadors_[0x5536b2f8056Fd993537bF56168d2A0667224587C] = true; //L
188  
189     }
190     
191      
192     /**
193      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
194      */
195     function buy(address _referredBy)
196         public
197         payable
198         returns(uint256)
199     {
200         purchaseTokens(msg.value, _referredBy);
201     }
202     
203     /**
204      * Fallback function to handle ethereum that was send straight to the contract
205      * Unfortunately we cannot use a referral address this way.
206      */
207     function()
208         payable
209         public
210     {
211         purchaseTokens(msg.value, 0x0);
212     }
213     
214     /**
215      * Converts all of caller's dividends to tokens.
216      */
217     function reinvest()
218         onlyStronghands()
219         public
220     {
221         // fetch dividends
222         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
223         
224         // pay out the dividends virtually
225         address _customerAddress = msg.sender;
226         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
227         
228         // retrieve ref. bonus
229         _dividends += referralBalance_[_customerAddress];
230         referralBalance_[_customerAddress] = 0;
231         
232         // dispatch a buy order with the virtualized "withdrawn dividends"
233         uint256 _tokens = purchaseTokens(_dividends, 0x0);
234         
235         // fire event
236         onReinvestment(_customerAddress, _dividends, _tokens);
237     }
238     
239     /**
240      * Alias of sell() and withdraw().
241      */
242     function exit()
243         public
244     {
245         // get token count for caller & sell them all
246         address _customerAddress = msg.sender;
247         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
248         if(_tokens > 0) sell(_tokens);
249         
250         // lambo delivery service
251         withdraw();
252     }
253 
254     /**
255      * Withdraws all of the callers earnings.
256      */
257     function withdraw()
258         onlyStronghands()
259         public
260     {
261         // setup data
262         address _customerAddress = msg.sender;
263         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
264         
265         // update dividend tracker
266         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
267         
268         // add ref. bonus
269         _dividends += referralBalance_[_customerAddress];
270         referralBalance_[_customerAddress] = 0;
271         
272         // lambo delivery service
273         _customerAddress.transfer(_dividends);
274         
275         // fire event
276         onWithdraw(_customerAddress, _dividends);
277     }
278     
279     /**
280      * Liquifies tokens to ethereum.
281      */
282     function sell(uint256 _amountOfTokens)
283         onlyBagholders()
284         public
285     {
286         // setup data
287         address _customerAddress = msg.sender;
288         // russian hackers BTFO
289         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
290         uint256 _tokens = _amountOfTokens;
291         uint256 _ethereum = tokensToEthereum_(_tokens);
292         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
293         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
294         
295         // burn the sold tokens
296         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
297         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
298         
299         // update dividends tracker
300         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
301         payoutsTo_[_customerAddress] -= _updatedPayouts;       
302         
303         // dividing by zero is a bad idea
304         if (tokenSupply_ > 0) {
305             // update the amount of dividends per token
306             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
307         }
308         
309         // fire event
310         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
311     }
312     
313     
314     /**
315      * Transfer tokens from the caller to a new holder.
316      * Remember, there's a 10% fee here as well.
317      */
318     function transfer(address _toAddress, uint256 _amountOfTokens)
319         onlyBagholders()
320         public
321         returns(bool)
322     {
323         // setup
324         address _customerAddress = msg.sender;
325         
326         // make sure we have the requested tokens
327         // also disables transfers until ambassador phase is over
328         // ( we dont want whale premines )
329         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
330         
331         // withdraw all outstanding dividends first
332         if(myDividends(true) > 0) withdraw();
333         
334         // liquify 10% of the tokens that are transfered
335         // these are dispersed to shareholders
336         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
337         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
338         uint256 _dividends = tokensToEthereum_(_tokenFee);
339   
340         // burn the fee tokens
341         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
342 
343         // exchange tokens
344         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
345         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
346         
347         // update dividend trackers
348         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
349         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
350         
351         // disperse dividends among holders
352         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
353         
354         // fire event
355         Transfer(_customerAddress, _toAddress, _taxedTokens);
356         
357         // ERC20
358         return true;
359        
360     }
361     
362     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
363     /**
364      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
365      */
366     function disableInitialStage()
367         onlyAdministrator()
368         public
369     {
370         onlyAmbassadors = false;
371     }
372     
373     /**
374      * In case one of us dies, we need to replace ourselves.
375      */
376     function setAdministrator(bytes32 _identifier, bool _status)
377         onlyAdministrator()
378         public
379     {
380         administrators[_identifier] = _status;
381     }
382     
383     /**
384      * Precautionary measures in case we need to adjust the masternode rate.
385      */
386     function setStakingRequirement(uint256 _amountOfTokens)
387         onlyAdministrator()
388         public
389     {
390         stakingRequirement = _amountOfTokens;
391     }
392     
393     /**
394      * If we want to rebrand, we can.
395      */
396     function setName(string _name)
397         onlyAdministrator()
398         public
399     {
400         name = _name;
401     }
402     
403     /**
404      * If we want to rebrand, we can.
405      */
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
424         return address (this).balance;
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
452      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
453      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
454      * But in the internal calculations, we want them separate. 
455      */ 
456     function myDividends(bool _includeReferralBonus) 
457         public 
458         view 
459         returns(uint256)
460     {
461         address _customerAddress = msg.sender;
462         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
463     }
464     
465     /**
466      * Retrieve the token balance of any single address.
467      */
468     function balanceOf(address _customerAddress)
469         view
470         public
471         returns(uint256)
472     {
473         return tokenBalanceLedger_[_customerAddress];
474     }
475     
476     /**
477      * Retrieve the dividend balance of any single address.
478      */
479     function dividendsOf(address _customerAddress)
480         view
481         public
482         returns(uint256)
483     {
484         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
485     }
486     
487     /**
488      * Return the buy price of 1 individual token.
489      */
490     function sellPrice() 
491         public 
492         view 
493         returns(uint256)
494     {
495         // our calculation relies on the token supply, so we need supply. Doh.
496         if(tokenSupply_ == 0){
497             return tokenPriceInitial_ - tokenPriceIncremental_;
498         } else {
499             uint256 _ethereum = tokensToEthereum_(1e18);
500             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
501             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
502             return _taxedEthereum;
503         }
504     }
505     
506     /**
507      * Return the sell price of 1 individual token.
508      */
509     function buyPrice() 
510         public 
511         view 
512         returns(uint256)
513     {
514         // our calculation relies on the token supply, so we need supply. Doh.
515         if(tokenSupply_ == 0){
516             return tokenPriceInitial_ + tokenPriceIncremental_;
517         } else {
518             uint256 _ethereum = tokensToEthereum_(1e18);
519             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
520             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
521             return _taxedEthereum;
522         }
523     }
524     
525     /**
526      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
527      */
528     function calculateTokensReceived(uint256 _ethereumToSpend) 
529         public 
530         view 
531         returns(uint256)
532     {
533         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
534         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
535         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
536         
537         return _amountOfTokens;
538     }
539     
540     /**
541      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
542      */
543     function calculateEthereumReceived(uint256 _tokensToSell) 
544         public 
545         view 
546         returns(uint256)
547     {
548         require(_tokensToSell <= tokenSupply_);
549         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
550         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
551         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
552         return _taxedEthereum;
553     }
554     
555     
556     /*==========================================
557     =            INTERNAL FUNCTIONS            =
558     ==========================================*/
559     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
560         antiEarlyWhale(_incomingEthereum)
561         internal
562         returns(uint256)
563     {
564         // data setup
565         address _customerAddress = msg.sender;
566         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
567         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
568         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
569         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
570         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
571         uint256 _fee = _dividends * magnitude;
572  
573         // no point in continuing execution if OP is a poorfag russian hacker
574         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
575         // (or hackers)
576         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
577         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
578         
579         // is the user referred by a masternode?
580         if(
581             // is this a referred purchase?
582             _referredBy != 0x0000000000000000000000000000000000000000 &&
583 
584             // no cheating!
585             _referredBy != _customerAddress &&
586             
587             // does the referrer have at least X whole tokens?
588             // i.e is the referrer a godly chad masternode
589             tokenBalanceLedger_[_referredBy] >= stakingRequirement
590         ){
591             // wealth redistribution
592             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
593         } else {
594             // no ref purchase
595             // add the referral bonus back to the global dividends cake
596             _dividends = SafeMath.add(_dividends, _referralBonus);
597             _fee = _dividends * magnitude;
598         }
599         
600         // we can't give people infinite ethereum
601         if(tokenSupply_ > 0){
602             
603             // add tokens to the pool
604             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
605  
606             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
607             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
608             
609             // calculate the amount of tokens the customer receives over his purchase 
610             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
611         
612         } else {
613             // add tokens to the pool
614             tokenSupply_ = _amountOfTokens;
615         }
616         
617         // update circulating supply & the ledger address for the customer
618         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
619         
620         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
621         //really i know you think you do but you don't
622         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
623         payoutsTo_[_customerAddress] += _updatedPayouts;
624         
625         // fire event
626         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
627         
628         return _amountOfTokens;
629     }
630 
631     /**
632      * Calculate Token price based on an amount of incoming ethereum
633      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
634      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
635      */
636     function ethereumToTokens_(uint256 _ethereum)
637         internal
638         view
639         returns(uint256)
640     {
641         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
642         uint256 _tokensReceived = 
643          (
644             (
645                 // underflow attempts BTFO
646                 SafeMath.sub(
647                     (sqrt
648                         (
649                             (_tokenPriceInitial**2)
650                             +
651                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
652                             +
653                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
654                             +
655                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
656                         )
657                     ), _tokenPriceInitial
658                 )
659             )/(tokenPriceIncremental_)
660         )-(tokenSupply_)
661         ;
662   
663         return _tokensReceived;
664     }
665     
666     /**
667      * Calculate token sell value.
668      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
669      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
670      */
671      function tokensToEthereum_(uint256 _tokens)
672         internal
673         view
674         returns(uint256)
675     {
676 
677         uint256 tokens_ = (_tokens + 1e18);
678         uint256 _tokenSupply = (tokenSupply_ + 1e18);
679         uint256 _etherReceived =
680         (
681             // underflow attempts BTFO
682             SafeMath.sub(
683                 (
684                     (
685                         (
686                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
687                         )-tokenPriceIncremental_
688                     )*(tokens_ - 1e18)
689                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
690             )
691         /1e18);
692         return _etherReceived;
693     }
694     
695     
696     //This is where all your gas goes, sorry
697     //Not sorry, you probably only paid 1 gwei
698     function sqrt(uint x) internal pure returns (uint y) {
699         uint z = (x + 1) / 2;
700         y = x;
701         while (z < y) {
702             y = z;
703             z = (x / z + z) / 2;
704         }
705     }
706 }
707 
708 /**
709  * @title SafeMath
710  * @dev Math operations with safety checks that throw on error
711  */
712 library SafeMath {
713 
714     /**
715     * @dev Multiplies two numbers, throws on overflow.
716     */
717     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
718         if (a == 0) {
719             return 0;
720         }
721         uint256 c = a * b;
722         assert(c / a == b);
723         return c;
724     }
725 
726     /**
727     * @dev Integer division of two numbers, truncating the quotient.
728     */
729     function div(uint256 a, uint256 b) internal pure returns (uint256) {
730         // assert(b > 0); // Solidity automatically throws when dividing by 0
731         uint256 c = a / b;
732         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
733         return c;
734     }
735 
736     /**
737     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
738     */
739     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
740         assert(b <= a);
741         return a - b;
742     }
743 
744     /**
745     * @dev Adds two numbers, throws on overflow.
746     */
747     function add(uint256 a, uint256 b) internal pure returns (uint256) {
748         uint256 c = a + b;
749         assert(c >= a);
750         return c;
751     }
752 }