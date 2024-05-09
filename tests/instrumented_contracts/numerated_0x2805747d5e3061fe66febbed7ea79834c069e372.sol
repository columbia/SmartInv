1 pragma solidity ^0.4.21;
2 
3 /*
4 
5 ────────────────────────────────────────────────────────────────────────────────────
6 ─██████████████─██████████████─██████──────────██████─██████████████─██████████████─
7 ─██░░░░░░░░░░██─██░░░░░░░░░░██─██░░██──────────██░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─
8 ─██░░██████░░██─██░░██████░░██─██░░██──────────██░░██─██████████░░██─██████████░░██─
9 ─██░░██──██░░██─██░░██──██░░██─██░░██──────────██░░██─────────██░░██─────────██░░██─
10 ─██░░██████░░██─██░░██──██░░██─██░░██──██████──██░░██─██████████░░██─██████████░░██─
11 ─██░░░░░░░░░░██─██░░██──██░░██─██░░██──██░░██──██░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─
12 ─██░░██████████─██░░██──██░░██─██░░██──██░░██──██░░██─██████████░░██─██████████░░██─
13 ─██░░██─────────██░░██──██░░██─██░░██████░░██████░░██─────────██░░██─────────██░░██─
14 ─██░░██─────────██░░██████░░██─██░░░░░░░░░░░░░░░░░░██─██████████░░██─██████████░░██─
15 ─██░░██─────────██░░░░░░░░░░██─██░░██████░░██████░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─
16 ─██████─────────██████████████─██████──██████──██████─██████████████─██████████████─
17 ────────────────────────────────────────────────────────────────────────────────────
18 */
19 
20 
21 contract POW33 {
22     /*=================================
23     =            MODIFIERS            =
24     =================================*/
25     // only people with tokens
26     modifier onlyBagholders() {
27         require(myTokens() > 0);
28         _;
29     }
30     
31     // only people with profits
32     modifier onlyStronghands() {
33         require(myDividends(true) > 0);
34         _;
35     }
36     
37     // administrators can:
38     // -> change the name of the contract
39     // -> change the name of the token
40     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
41     // they CANNOT:
42     // -> take funds
43     // -> disable withdrawals
44     // -> kill the contract
45     // -> change the price of tokens
46     modifier onlyAdministrator(){
47         address _customerAddress = msg.sender;
48         require(administrators[keccak256(_customerAddress)]);
49         _;
50     }
51     
52     
53     // ensures that the first tokens in the contract will be equally distributed
54     // meaning, no divine dump will be ever possible
55     // result: healthy longevity.
56     modifier antiEarlyWhale(uint256 _amountOfEthereum){
57         address _customerAddress = msg.sender;
58         
59         // are we still in the vulnerable phase?
60         // if so, enact anti early whale protocol 
61         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
62             require(
63                 // is the customer in the ambassador list?
64                 ambassadors_[_customerAddress] == true &&
65                 
66                 // does the customer purchase exceed the max ambassador quota?
67                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
68                 
69             );
70             
71             // updated the accumulated quota    
72             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
73         
74             // execute
75             _;
76         } else {
77             // in case the ether count drops low, the ambassador phase won't reinitiate
78             onlyAmbassadors = false;
79             _;    
80         }
81         
82     }
83     
84     
85     /*==============================
86     =            EVENTS            =
87     ==============================*/
88     event onTokenPurchase(
89         address indexed customerAddress,
90         uint256 incomingEthereum,
91         uint256 tokensMinted,
92         address indexed referredBy
93     );
94     
95     event onTokenSell(
96         address indexed customerAddress,
97         uint256 tokensBurned,
98         uint256 ethereumEarned
99     );
100     
101     event onReinvestment(
102         address indexed customerAddress,
103         uint256 ethereumReinvested,
104         uint256 tokensMinted
105     );
106     
107     event onWithdraw(
108         address indexed customerAddress,
109         uint256 ethereumWithdrawn
110     );
111     
112     // ERC20
113     event Transfer(
114         address indexed from,
115         address indexed to,
116         uint256 tokens
117     );
118     
119     
120     /*=====================================
121     =            CONFIGURABLES            =
122     =====================================*/
123     string public name = "POW33";
124     string public symbol = "PW33";
125     uint8 constant public decimals = 18;
126     uint8 constant internal dividendFee_ = 3; 
127     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
128     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
129     uint256 constant internal magnitude = 2**64;
130     
131     // proof of stake (defaults at 100 tokens)
132     uint256 public stakingRequirement = 100e18;
133     
134     // ambassador program
135     mapping(address => bool) internal ambassadors_;
136     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
137     uint256 constant internal ambassadorQuota_ = 20 ether;
138     
139     
140     
141    /*================================
142     =            DATASETS            =
143     ================================*/
144     // amount of shares for each address (scaled number)
145     mapping(address => uint256) internal tokenBalanceLedger_;
146     mapping(address => uint256) internal referralBalance_;
147     mapping(address => int256) internal payoutsTo_;
148     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
149     uint256 internal tokenSupply_ = 0;
150     uint256 internal profitPerShare_;
151     
152     // administrator list (see above on what they can do)
153     mapping(bytes32 => bool) public administrators;
154     
155     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
156     bool public onlyAmbassadors = true;
157     
158 
159 
160     /*=======================================
161     =            PUBLIC FUNCTIONS            =
162     =======================================*/
163     /*
164     * -- APPLICATION ENTRY POINTS --  
165     */
166     function POW33()
167         public
168     {
169         // add administrators here
170 
171         administrators[0x28d25883e7fbf1b858d6b89dd9749ab205a15d58f26f4ae9b0993c070339e71d] = true;
172 
173 
174 
175         
176 
177     }
178     
179      
180     /**
181      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
182      */
183     function buy(address _referredBy)
184         public
185         payable
186         returns(uint256)
187     {
188         purchaseTokens(msg.value, _referredBy);
189     }
190     
191     /**
192      * Fallback function to handle ethereum that was send straight to the contract
193      * Unfortunately we cannot use a referral address this way.
194      */
195     function()
196         payable
197         public
198     {
199         purchaseTokens(msg.value, 0x0);
200     }
201     
202     /**
203      * Converts all of caller's dividends to tokens.
204     */
205     function reinvest()
206         onlyStronghands()
207         public
208     {
209         // fetch dividends
210         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
211         
212         // pay out the dividends virtually
213         address _customerAddress = msg.sender;
214         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
215         
216         // retrieve ref. bonus
217         _dividends += referralBalance_[_customerAddress];
218         referralBalance_[_customerAddress] = 0;
219         
220         // dispatch a buy order with the virtualized "withdrawn dividends"
221         uint256 _tokens = purchaseTokens(_dividends, 0x0);
222         
223         // fire event
224         onReinvestment(_customerAddress, _dividends, _tokens);
225     }
226     
227     /**
228      * Alias of sell() and withdraw().
229      */
230     function exit()
231         public
232     {
233         // get token count for caller & sell them all
234         address _customerAddress = msg.sender;
235         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
236         if(_tokens > 0) sell(_tokens);
237         
238         // lambo delivery service
239         withdraw();
240     }
241 
242     /**
243      * Withdraws all of the callers earnings.
244      */
245     function withdraw()
246         onlyStronghands()
247         public
248     {
249         // setup data
250         address _customerAddress = msg.sender;
251         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
252         
253         // update dividend tracker
254         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
255         
256         // add ref. bonus
257         _dividends += referralBalance_[_customerAddress];
258         referralBalance_[_customerAddress] = 0;
259         
260         // lambo delivery service
261         _customerAddress.transfer(_dividends);
262         
263         // fire event
264         onWithdraw(_customerAddress, _dividends);
265     }
266     
267     /**
268      * Liquifies tokens to ethereum.
269      */
270     function sell(uint256 _amountOfTokens)
271         onlyBagholders()
272         public
273     {
274         // setup data
275         address _customerAddress = msg.sender;
276         // russian hackers BTFO
277         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
278         uint256 _tokens = _amountOfTokens;
279         uint256 _ethereum = tokensToEthereum_(_tokens);
280         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
281         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
282         
283         // burn the sold tokens
284         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
285         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
286         
287         // update dividends tracker
288         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
289         payoutsTo_[_customerAddress] -= _updatedPayouts;       
290         
291         // dividing by zero is a bad idea
292         if (tokenSupply_ > 0) {
293             // update the amount of dividends per token
294             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
295         }
296         
297         // fire event
298         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
299     }
300     
301     
302     /**
303      * Transfer tokens from the caller to a new holder.
304      * Remember, there's a 10% fee here as well.
305      */
306     function transfer(address _toAddress, uint256 _amountOfTokens)
307         onlyBagholders()
308         public
309         returns(bool)
310     {
311         // setup
312         address _customerAddress = msg.sender;
313         
314         // make sure we have the requested tokens
315         // also disables transfers until ambassador phase is over
316         // ( we dont want whale premines )
317         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
318         
319         // withdraw all outstanding dividends first
320         if(myDividends(true) > 0) withdraw();
321         
322         // liquify 10% of the tokens that are transfered
323         // these are dispersed to shareholders
324         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
325         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
326         uint256 _dividends = tokensToEthereum_(_tokenFee);
327   
328         // burn the fee tokens
329         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
330 
331         // exchange tokens
332         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
333         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
334         
335         // update dividend trackers
336         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
337         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
338         
339         // disperse dividends among holders
340         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
341         
342         // fire event
343         Transfer(_customerAddress, _toAddress, _taxedTokens);
344         
345         // ERC20
346         return true;
347        
348     }
349     
350     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
351     /**
352      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
353      */
354     function disableInitialStage()
355         onlyAdministrator()
356         public
357     {
358         onlyAmbassadors = false;
359     }
360     
361     /**
362      * In case one of us dies, we need to replace ourselves.
363      */
364     function setAdministrator(bytes32 _identifier, bool _status)
365         onlyAdministrator()
366         public
367     {
368         administrators[_identifier] = _status;
369     }
370     
371     /**
372      * Precautionary measures in case we need to adjust the masternode rate.
373      */
374     function setStakingRequirement(uint256 _amountOfTokens)
375         onlyAdministrator()
376         public
377     {
378         stakingRequirement = _amountOfTokens;
379     }
380     
381     /**
382      * If we want to rebrand, we can.
383      */
384     function setName(string _name)
385         onlyAdministrator()
386         public
387     {
388         name = _name;
389     }
390     
391     /**
392      * If we want to rebrand, we can.
393      */
394     function setSymbol(string _symbol)
395         onlyAdministrator()
396         public
397     {
398         symbol = _symbol;
399     }
400 
401     
402     /*----------  HELPERS AND CALCULATORS  ----------*/
403     /**
404      * Method to view the current Ethereum stored in the contract
405      * Example: totalEthereumBalance()
406      */
407     function totalEthereumBalance()
408         public
409         view
410         returns(uint)
411     {
412         return this.balance;
413     }
414     
415     /**
416      * Retrieve the total token supply.
417      */
418     function totalSupply()
419         public
420         view
421         returns(uint256)
422     {
423         return tokenSupply_;
424     }
425     
426     /**
427      * Retrieve the tokens owned by the caller.
428      */
429     function myTokens()
430         public
431         view
432         returns(uint256)
433     {
434         address _customerAddress = msg.sender;
435         return balanceOf(_customerAddress);
436     }
437     
438     /**
439      * Retrieve the dividends owned by the caller.
440      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
441      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
442      * But in the internal calculations, we want them separate. 
443      */ 
444     function myDividends(bool _includeReferralBonus) 
445         public 
446         view 
447         returns(uint256)
448     {
449         address _customerAddress = msg.sender;
450         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
451     }
452     
453     /**
454      * Retrieve the token balance of any single address.
455      */
456     function balanceOf(address _customerAddress)
457         view
458         public
459         returns(uint256)
460     {
461         return tokenBalanceLedger_[_customerAddress];
462     }
463     
464     /**
465      * Retrieve the dividend balance of any single address.
466      */
467     function dividendsOf(address _customerAddress)
468         view
469         public
470         returns(uint256)
471     {
472         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
473     }
474     
475     /**
476      * Return the buy price of 1 individual token.
477      */
478     function sellPrice() 
479         public 
480         view 
481         returns(uint256)
482     {
483         // our calculation relies on the token supply, so we need supply. Doh.
484         if(tokenSupply_ == 0){
485             return tokenPriceInitial_ - tokenPriceIncremental_;
486         } else {
487             uint256 _ethereum = tokensToEthereum_(1e18);
488             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
489             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
490             return _taxedEthereum;
491         }
492     }
493     
494     /**
495      * Return the sell price of 1 individual token.
496      */
497     function buyPrice() 
498         public 
499         view 
500         returns(uint256)
501     {
502         // our calculation relies on the token supply, so we need supply. Doh.
503         if(tokenSupply_ == 0){
504             return tokenPriceInitial_ + tokenPriceIncremental_;
505         } else {
506             uint256 _ethereum = tokensToEthereum_(1e18);
507             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
508             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
509             return _taxedEthereum;
510         }
511     }
512     
513     /**
514      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
515      */
516     function calculateTokensReceived(uint256 _ethereumToSpend) 
517         public 
518         view 
519         returns(uint256)
520     {
521         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
522         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
523         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
524         
525         return _amountOfTokens;
526     }
527     
528     /**
529      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
530      */
531     function calculateEthereumReceived(uint256 _tokensToSell) 
532         public 
533         view 
534         returns(uint256)
535     {
536         require(_tokensToSell <= tokenSupply_);
537         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
538         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
539         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
540         return _taxedEthereum;
541     }
542     
543     
544     /*==========================================
545     =            INTERNAL FUNCTIONS            =
546     ==========================================*/
547     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
548         antiEarlyWhale(_incomingEthereum)
549         internal
550         returns(uint256)
551     {
552         // data setup
553         address _customerAddress = msg.sender;
554         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
555         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
556         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
557         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
558         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
559         uint256 _fee = _dividends * magnitude;
560  
561         // no point in continuing execution if OP is a poorfag russian hacker
562         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
563         // (or hackers)
564         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
565         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
566         
567         // is the user referred by a masternode?
568         if(
569             // is this a referred purchase?
570             _referredBy != 0x0000000000000000000000000000000000000000 &&
571 
572             // no cheating!
573             _referredBy != _customerAddress &&
574             
575             // does the referrer have at least X whole tokens?
576             // i.e is the referrer a godly chad masternode
577             tokenBalanceLedger_[_referredBy] >= stakingRequirement
578         ){
579             // wealth redistribution
580             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
581         } else {
582             // no ref purchase
583             // add the referral bonus back to the global dividends cake
584             _dividends = SafeMath.add(_dividends, _referralBonus);
585             _fee = _dividends * magnitude;
586         }
587         
588         // we can't give people infinite ethereum
589         if(tokenSupply_ > 0){
590             
591             // add tokens to the pool
592             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
593  
594             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
595             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
596             
597             // calculate the amount of tokens the customer receives over his purchase 
598             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
599         
600         } else {
601             // add tokens to the pool
602             tokenSupply_ = _amountOfTokens;
603         }
604         
605         // update circulating supply & the ledger address for the customer
606         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
607         
608         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
609         //really i know you think you do but you don't
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
656      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
657      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
658      */
659      function tokensToEthereum_(uint256 _tokens)
660         internal
661         view
662         returns(uint256)
663     {
664 
665         uint256 tokens_ = (_tokens + 1e18);
666         uint256 _tokenSupply = (tokenSupply_ + 1e18);
667         uint256 _etherReceived =
668         (
669             // underflow attempts BTFO
670             SafeMath.sub(
671                 (
672                     (
673                         (
674                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
675                         )-tokenPriceIncremental_
676                     )*(tokens_ - 1e18)
677                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
678             )
679         /1e18);
680         return _etherReceived;
681     }
682     
683     
684     //This is where all your gas goes, sorry
685     //Not sorry, you probably only paid 1 gwei
686     function sqrt(uint x) internal pure returns (uint y) {
687         uint z = (x + 1) / 2;
688         y = x;
689         while (z < y) {
690             y = z;
691             z = (x / z + z) / 2;
692         }
693     }
694 }
695 
696 /**
697  * @title SafeMath
698  * @dev Math operations with safety checks that throw on error
699  */
700 library SafeMath {
701 
702     /**
703     * @dev Multiplies two numbers, throws on overflow.
704     */
705     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
706         if (a == 0) {
707             return 0;
708         }
709         uint256 c = a * b;
710         assert(c / a == b);
711         return c;
712     }
713 
714     /**
715     * @dev Integer division of two numbers, truncating the quotient.
716     */
717     function div(uint256 a, uint256 b) internal pure returns (uint256) {
718         // assert(b > 0); // Solidity automatically throws when dividing by 0
719         uint256 c = a / b;
720         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
721         return c;
722     }
723 
724     /**
725     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
726     */
727     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
728         assert(b <= a);
729         return a - b;
730     }
731 
732     /**
733     * @dev Adds two numbers, throws on overflow.
734     */
735     function add(uint256 a, uint256 b) internal pure returns (uint256) {
736         uint256 c = a + b;
737         assert(c >= a);
738         return c;
739     }
740 }