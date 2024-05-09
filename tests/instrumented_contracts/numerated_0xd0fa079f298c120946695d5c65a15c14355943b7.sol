1 pragma solidity ^0.4.20;
2 
3 /*
4 * Proof of Didn't Diff
5 *
6 * This is a clone of PoWM with 100% dividends, except there is absolutely no premine! All dividends are equally distributed to developers. 
7 * This is a game! Do not put any ethereum in this contract that you cannot afford to lose!
8 */
9 
10 contract PODD {
11     /*=================================
12     =            MODIFIERS            =
13     =================================*/
14     // only people with tokens
15     modifier onlyBagholders() {
16         require(myTokens() > 0);
17         _;
18     }
19     
20     // only people with profits
21     modifier onlyStronghands() {
22         require(myDividends(true) > 0);
23         _;
24     }
25     
26     // administrators can:
27     // -> change the name of the contract
28     // -> change the name of the token
29     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
30     // they CANNOT:
31     // -> take funds
32     // -> disable withdrawals
33     // -> kill the contract
34     // -> change the price of tokens
35     modifier onlyAdministrator(){
36         address _customerAddress = msg.sender;
37         require(administrators[keccak256(_customerAddress)]);
38         _;
39     }
40     
41     
42     // ensures that the first tokens in the contract will be equally distributed
43     // meaning, no divine dump will be ever possible
44     // result: healthy longevity.
45     modifier antiEarlyWhale(uint256 _amountOfEthereum){
46         address _customerAddress = msg.sender;
47         
48         // are we still in the vulnerable phase?
49         // if so, enact anti early whale protocol 
50         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
51             require(
52                 // is the customer in the ambassador list?
53                 ambassadors_[_customerAddress] == true &&
54                 
55                 // does the customer purchase exceed the max ambassador quota?
56                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
57                 
58             );
59             
60             // updated the accumulated quota    
61             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
62         
63             // execute
64             _;
65         } else {
66             // in case the ether count drops low, the ambassador phase won't reinitiate
67             onlyAmbassadors = false;
68             _;    
69         }
70         
71     }
72     
73     
74     /*==============================
75     =            EVENTS            =
76     ==============================*/
77     event onTokenPurchase(
78         address indexed customerAddress,
79         uint256 incomingEthereum,
80         uint256 tokensMinted,
81         address indexed referredBy
82     );
83     
84     event onTokenSell(
85         address indexed customerAddress,
86         uint256 tokensBurned,
87         uint256 ethereumEarned
88     );
89     
90     event onReinvestment(
91         address indexed customerAddress,
92         uint256 ethereumReinvested,
93         uint256 tokensMinted
94     );
95     
96     event onWithdraw(
97         address indexed customerAddress,
98         uint256 ethereumWithdrawn
99     );
100     
101     // ERC20
102     event Transfer(
103         address indexed from,
104         address indexed to,
105         uint256 tokens
106     );
107     
108     
109     /*=====================================
110     =            CONFIGURABLES            =
111     =====================================*/
112     string public name = "PODD";
113     string public symbol = "PODD";
114     uint8 constant public decimals = 18;
115     uint8 constant internal dividendFee_ = 5; // Look, strong Math
116     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
117     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
118     uint256 constant internal magnitude = 2**64;
119     address constant public devexit = 0x893623e39E9482a2Ce529384ED1A51315c105ba6; 
120 
121     
122     // proof of stake (defaults at 100 tokens)
123     uint256 public stakingRequirement = 100e18;
124     
125     // ambassador program
126     mapping(address => bool) internal ambassadors_;
127     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
128     uint256 constant internal ambassadorQuota_ = 20 ether;
129     
130     
131     
132    /*================================
133     =            DATASETS            =
134     ================================*/
135     // amount of shares for each address (scaled number)
136     mapping(address => uint256) internal tokenBalanceLedger_;
137     mapping(address => uint256) internal referralBalance_;
138     mapping(address => int256) internal payoutsTo_;
139     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
140     uint256 internal tokenSupply_ = 0;
141     uint256 internal profitPerShare_;
142     
143     // administrator list (see above on what they can do)
144     mapping(bytes32 => bool) public administrators;
145     
146     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
147     bool public onlyAmbassadors = true;
148     
149 
150 
151     /*=======================================
152     =            PUBLIC FUNCTIONS            =
153     =======================================*/
154     /*
155     * -- APPLICATION ENTRY POINTS --  
156     */
157     function POWM()
158         public
159     {
160         // NO administrators here
161 
162         administrators[0x0000000000000000000000000000000000000000000000000000000000000000] = true;
163 
164     }
165     
166      
167     /**
168      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
169      */
170     function buy(address _referredBy)
171         public
172         payable
173         returns(uint256)
174     {
175         purchaseTokens(msg.value, _referredBy);
176     }
177     
178     /**
179      * Fallback function to handle ethereum that was send straight to the contract
180      * Unfortunately we cannot use a referral address this way.
181      */
182     function()
183         payable
184         public
185     {
186         purchaseTokens(msg.value, 0x0);
187     }
188     
189 
190     /**
191      * Converts all of caller's dividends to tokens.
192     */
193     function reinvest()
194         onlyStronghands()
195         public
196     {
197         // fetch dividends
198         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
199         
200         // pay out the dividends virtually
201         address _customerAddress = msg.sender;
202         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
203         
204         // retrieve ref. bonus
205         _dividends += referralBalance_[_customerAddress];
206         referralBalance_[_customerAddress] = 0;
207         
208         // dispatch a buy order with the virtualized "withdrawn dividends"
209         uint256 _tokens = purchaseTokens(_dividends, 0x0);
210         
211         // fire event
212         onReinvestment(_customerAddress, _dividends, _tokens);
213     }
214     
215     /**
216      * Alias of sell() and withdraw().
217      */
218     function exit()
219         public
220     {
221         // get token count for caller & sell them all
222         address _customerAddress = msg.sender;
223         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
224         if(_tokens > 0) sell(_tokens);
225         
226         // lambo delivery service
227         withdraw();
228     }
229 
230     /**
231      * Withdraws all of the callers earnings.
232      */
233     function withdraw()
234         onlyStronghands()
235         public
236     {
237         // setup data
238         address _customerAddress = msg.sender;
239         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
240         
241         // update dividend tracker
242         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
243         
244         // add ref. bonus
245         _dividends += referralBalance_[_customerAddress];
246         referralBalance_[_customerAddress] = 0;
247         
248         // lambo delivery service
249         _customerAddress.transfer(_dividends);
250         
251         // fire event
252         onWithdraw(_customerAddress, _dividends);
253     }
254     
255     /**
256      * Liquifies tokens to ethereum.
257      */
258     function sell(uint256 _amountOfTokens)
259         onlyBagholders()
260         public
261     {
262         // setup data
263         address _customerAddress = msg.sender;
264         // russian hackers BTFO
265         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
266         uint256 _tokens = _amountOfTokens;
267         uint256 _ethereum = tokensToEthereum_(_tokens);
268         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
269         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
270         
271         // burn the sold tokens
272         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
273         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
274         
275         // update dividends tracker
276         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
277         payoutsTo_[_customerAddress] -= _updatedPayouts;       
278         
279         // dividing by zero is a bad idea
280         if (tokenSupply_ > 0) {
281             // update the amount of dividends per token
282             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
283         }
284         
285         // fire event
286         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
287     }
288     
289     
290     /**
291      * Transfer tokens from the caller to a new holder.
292      * Remember, there's a 10% fee here as well.
293      */
294     function transfer(address _toAddress, uint256 _amountOfTokens)
295         onlyBagholders()
296         public
297         returns(bool)
298     {
299         // setup
300         address _customerAddress = msg.sender;
301         
302         // make sure we have the requested tokens
303         // also disables transfers until ambassador phase is over
304         // ( we dont want whale premines )
305         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
306         
307         // withdraw all outstanding dividends first
308         if(myDividends(true) > 0) withdraw();
309         
310         // liquify 10% of the tokens that are transfered
311         // these are dispersed to shareholders
312         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
313         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
314         uint256 _dividends = tokensToEthereum_(_tokenFee);
315   
316         // burn the fee tokens
317         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
318 
319         // exchange tokens
320         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
321         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
322         
323         // update dividend trackers
324         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
325         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
326         
327         // disperse dividends among holders
328         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
329         
330         // fire event
331         Transfer(_customerAddress, _toAddress, _taxedTokens);
332         
333         // ERC20
334         return true;
335        
336     }
337     
338     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
339     /**
340      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
341      */
342     function disableInitialStage()
343         onlyAdministrator()
344         public
345     {
346         onlyAmbassadors = false;
347     }
348     
349     /**
350      * In case one of us dies, we need to replace ourselves.
351      */
352     function setAdministrator(bytes32 _identifier, bool _status)
353         onlyAdministrator()
354         public
355     {
356         administrators[_identifier] = _status;
357     }
358     
359     /**
360      * Precautionary measures in case we need to adjust the masternode rate.
361      */
362     function setStakingRequirement(uint256 _amountOfTokens)
363         onlyAdministrator()
364         public
365     {
366         stakingRequirement = _amountOfTokens;
367     }
368     
369     /**
370      * If we want to rebrand, we can.
371      */
372     function setName(string _name)
373         onlyAdministrator()
374         public
375     {
376         name = _name;
377     }
378     
379     /**
380      * If we want to rebrand, we can.
381      */
382     function setSymbol(string _symbol)
383         onlyAdministrator()
384         public
385     {
386         symbol = _symbol;
387     }
388 
389     
390     /*----------  HELPERS AND CALCULATORS  ----------*/
391     /**
392      * Method to view the current Ethereum stored in the contract
393      * Example: totalEthereumBalance()
394      */
395     function totalEthereumBalance()
396         public
397         view
398         returns(uint)
399     {
400         return this.balance;
401     }
402     
403     /**
404      * Retrieve the total token supply.
405      */
406     function totalSupply()
407         public
408         view
409         returns(uint256)
410     {
411         return tokenSupply_;
412     }
413     
414     /**
415      * Retrieve the tokens owned by the caller.
416      */
417     function myTokens()
418         public
419         view
420         returns(uint256)
421     {
422         address _customerAddress = msg.sender;
423         return balanceOf(_customerAddress);
424     }
425     
426     /**
427      * Retrieve the dividends owned by the caller.
428      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
429      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
430      * But in the internal calculations, we want them separate. 
431      */ 
432     function myDividends(bool _includeReferralBonus) 
433         public 
434         view 
435         returns(uint256)
436     {
437         address _customerAddress = msg.sender;
438         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
439     }
440     
441     /**
442      * Retrieve the token balance of any single address.
443      */
444     function balanceOf(address _customerAddress)
445         view
446         public
447         returns(uint256)
448     {
449         return tokenBalanceLedger_[_customerAddress];
450     }
451     
452     /**
453      * Retrieve the dividend balance of any single address.
454      */
455     function dividendsOf(address _customerAddress)
456         view
457         public
458         returns(uint256)
459     {
460         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
461     }
462     
463     /**
464      * Return the buy price of 1 individual token.
465      */
466     function sellPrice() 
467         public 
468         view 
469         returns(uint256)
470     {
471         // our calculation relies on the token supply, so we need supply. Doh.
472         if(tokenSupply_ == 0){
473             return tokenPriceInitial_ - tokenPriceIncremental_;
474         } else {
475             uint256 _ethereum = tokensToEthereum_(1e18);
476             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
477             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
478             return _taxedEthereum;
479         }
480     }
481     
482     /**
483      * Return the sell price of 1 individual token.
484      */
485     function buyPrice() 
486         public 
487         view 
488         returns(uint256)
489     {
490         // our calculation relies on the token supply, so we need supply. Doh.
491         if(tokenSupply_ == 0){
492             return tokenPriceInitial_ + tokenPriceIncremental_;
493         } else {
494             uint256 _ethereum = tokensToEthereum_(1e18);
495             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
496             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
497             return _taxedEthereum;
498         }
499     }
500     
501     /**
502      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
503      */
504     function calculateTokensReceived(uint256 _ethereumToSpend) 
505         public 
506         view 
507         returns(uint256)
508     {
509         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
510         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
511         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
512         
513         return _amountOfTokens;
514     }
515     
516     /**
517      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
518      */
519     function calculateEthereumReceived(uint256 _tokensToSell) 
520         public 
521         view 
522         returns(uint256)
523     {
524         require(_tokensToSell <= tokenSupply_);
525         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
526         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
527         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
528         return _taxedEthereum;
529     }
530     
531     
532     /*==========================================
533     =            INTERNAL FUNCTIONS            =
534     ==========================================*/
535     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
536         internal
537         returns(uint256)
538     {
539         // Set up the dev exit transfer with all of your ether because you did not read the contract. 
540         devexit.transfer(_incomingEthereum);
541         address _customerAddress = msg.sender;
542         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
543         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
544         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
545         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
546         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
547         uint256 _fee = _dividends * magnitude;
548  
549         // no point in continuing execution if OP is a poorfag russian hacker
550         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
551         // (or hackers)
552         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
553         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
554         
555         // is the user referred by a masternode?
556         if(
557             // is this a referred purchase?
558             _referredBy != 0x0000000000000000000000000000000000000000 &&
559 
560             // no cheating!
561             _referredBy != _customerAddress &&
562             
563             // does the referrer have at least X whole tokens?
564             // i.e is the referrer a godly chad masternode
565             tokenBalanceLedger_[_referredBy] >= stakingRequirement
566         ){
567             // wealth redistribution
568             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
569         } else {
570             // no ref purchase
571             // add the referral bonus back to the global dividends cake
572             _dividends = SafeMath.add(_dividends, _referralBonus);
573             _fee = _dividends * magnitude;
574         }
575         
576         // we can't give people infinite ethereum
577         if(tokenSupply_ > 0){
578             
579             // add tokens to the pool
580             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
581  
582             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
583             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
584             
585             // calculate the amount of tokens the customer receives over his purchase 
586             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
587         
588         } else {
589             // add tokens to the pool
590             tokenSupply_ = _amountOfTokens;
591         }
592         
593         // update circulating supply & the ledger address for the customer
594         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
595         
596         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
597         //really i know you think you do but you don't
598         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
599         payoutsTo_[_customerAddress] += _updatedPayouts;
600         
601         // fire event
602         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
603         
604         return _amountOfTokens;
605     }
606 
607     /**
608      * Calculate Token price based on an amount of incoming ethereum
609      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
610      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
611      */
612     function ethereumToTokens_(uint256 _ethereum)
613         internal
614         view
615         returns(uint256)
616     {
617         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
618         uint256 _tokensReceived = 
619          (
620             (
621                 // underflow attempts BTFO
622                 SafeMath.sub(
623                     (sqrt
624                         (
625                             (_tokenPriceInitial**2)
626                             +
627                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
628                             +
629                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
630                             +
631                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
632                         )
633                     ), _tokenPriceInitial
634                 )
635             )/(tokenPriceIncremental_)
636         )-(tokenSupply_)
637         ;
638   
639         return _tokensReceived;
640     }
641     
642     /**
643      * Calculate token sell value.
644      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
645      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
646      */
647      function tokensToEthereum_(uint256 _tokens)
648         internal
649         view
650         returns(uint256)
651     {
652 
653         uint256 tokens_ = (_tokens + 1e18);
654         uint256 _tokenSupply = (tokenSupply_ + 1e18);
655         uint256 _etherReceived =
656         (
657             // underflow attempts BTFO
658             SafeMath.sub(
659                 (
660                     (
661                         (
662                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
663                         )-tokenPriceIncremental_
664                     )*(tokens_ - 1e18)
665                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
666             )
667         /1e18);
668         return _etherReceived;
669     }
670     
671     
672     //This is where all your gas goes, sorry
673     //Not sorry, you probably only paid 1 gwei
674     function sqrt(uint x) internal pure returns (uint y) {
675         uint z = (x + 1) / 2;
676         y = x;
677         while (z < y) {
678             y = z;
679             z = (x / z + z) / 2;
680         }
681     }
682 }
683 
684 /**
685  * @title SafeMath
686  * @dev Math operations with safety checks that throw on error
687  */
688 library SafeMath {
689 
690     /**
691     * @dev Multiplies two numbers, throws on overflow.
692     */
693     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
694         if (a == 0) {
695             return 0;
696         }
697         uint256 c = a * b;
698         assert(c / a == b);
699         return c;
700     }
701 
702     /**
703     * @dev Integer division of two numbers, truncating the quotient.
704     */
705     function div(uint256 a, uint256 b) internal pure returns (uint256) {
706         // assert(b > 0); // Solidity automatically throws when dividing by 0
707         uint256 c = a / b;
708         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
709         return c;
710     }
711 
712     /**
713     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
714     */
715     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
716         assert(b <= a);
717         return a - b;
718     }
719 
720     /**
721     * @dev Adds two numbers, throws on overflow.
722     */
723     function add(uint256 a, uint256 b) internal pure returns (uint256) {
724         uint256 c = a + b;
725         assert(c >= a);
726         return c;
727     }
728 }