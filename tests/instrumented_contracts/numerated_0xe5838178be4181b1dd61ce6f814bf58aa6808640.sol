1 pragma solidity ^0.4.20;
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
18 
19 */
20 
21 
22 contract POW33 {
23     /*=================================
24     =            MODIFIERS            =
25     =================================*/
26     // only people with tokens
27     modifier onlyBagholders() {
28         require(myTokens() > 0);
29         _;
30     }
31     
32     // only people with profits
33     modifier onlyStronghands() {
34         require(myDividends(true) > 0);
35         _;
36     }
37     
38     // administrators can:
39     // -> change the name of the contract
40     // -> change the name of the token
41     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
42     // they CANNOT:
43     // -> take funds
44     // -> disable withdrawals
45     // -> kill the contract
46     // -> change the price of tokens
47     modifier onlyAdministrator(){
48         address _customerAddress = msg.sender;
49         require(administrators[_customerAddress]);
50         _;
51     }
52     
53     
54     // ensures that the first tokens in the contract will be equally distributed
55     // meaning, no divine dump will be ever possible
56     // result: healthy longevity.
57     modifier antiEarlyWhale(uint256 _amountOfEthereum){
58         address _customerAddress = msg.sender;
59         
60         // are we still in the vulnerable phase?
61         // if so, enact anti early whale protocol 
62         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
63             require(
64                 // is the customer in the ambassador list?
65                 ambassadors_[_customerAddress] == true &&
66                 
67                 // does the customer purchase exceed the max ambassador quota?
68                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
69                 
70             );
71             
72             // updated the accumulated quota    
73             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
74         
75             // execute
76             _;
77         } else {
78             // in case the ether count drops low, the ambassador phase won't reinitiate
79             onlyAmbassadors = false;
80             _;    
81         }
82         
83     }
84     
85     
86     /*==============================
87     =            EVENTS            =
88     ==============================*/
89     event onTokenPurchase(
90         address indexed customerAddress,
91         uint256 incomingEthereum,
92         uint256 tokensMinted,
93         address indexed referredBy
94     );
95     
96     event onTokenSell(
97         address indexed customerAddress,
98         uint256 tokensBurned,
99         uint256 ethereumEarned
100     );
101     
102     event onReinvestment(
103         address indexed customerAddress,
104         uint256 ethereumReinvested,
105         uint256 tokensMinted
106     );
107     
108     event onWithdraw(
109         address indexed customerAddress,
110         uint256 ethereumWithdrawn
111     );
112     
113     // ERC20
114     event Transfer(
115         address indexed from,
116         address indexed to,
117         uint256 tokens
118     );
119     
120     
121     /*=====================================
122     =            CONFIGURABLES            =
123     =====================================*/
124     string public name = "POW33";
125     string public symbol = "PW33";
126     uint8 constant public decimals = 18;
127     uint8 constant internal dividendFee_ = 3; 
128     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
129     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
130     uint256 constant internal magnitude = 2**64;
131     
132     // proof of stake (defaults at 100 tokens)
133     uint256 public stakingRequirement = 100e18;
134     
135     // ambassador program
136     mapping(address => bool) internal ambassadors_;
137     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
138     uint256 constant internal ambassadorQuota_ = 20 ether;
139     
140     
141     
142    /*================================
143     =            DATASETS            =
144     ================================*/
145     // amount of shares for each address (scaled number)
146     mapping(address => uint256) internal tokenBalanceLedger_;
147     mapping(address => uint256) internal referralBalance_;
148     mapping(address => int256) internal payoutsTo_;
149     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
150     uint256 internal tokenSupply_ = 0;
151     uint256 internal profitPerShare_;
152     
153     // administrator list (see above on what they can do)
154     mapping(address => bool) public administrators;
155     bool public onlyAmbassadors = false;
156     
157 
158 
159     /*=======================================
160     =            PUBLIC FUNCTIONS            =
161     =======================================*/
162     /*
163     * -- APPLICATION ENTRY POINTS --  
164     */
165     function POW33()
166         public
167     {
168         // add administrators here
169 
170         administrators[0x3446e0F8Bc2556a2f00A317D89549DBbD6e26458] = true;
171 
172     }
173     
174      
175     /**
176      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
177      */
178     function buy(address _referredBy)
179         public
180         payable
181         returns(uint256)
182     {
183         purchaseTokens(msg.value, _referredBy);
184     }
185     
186     /**
187      * Fallback function to handle ethereum that was send straight to the contract
188      * Unfortunately we cannot use a referral address this way.
189      */
190     function()
191         payable
192         public
193     {
194         purchaseTokens(msg.value, 0x0);
195     }
196     
197     /**
198      * Converts all of caller's dividends to tokens.
199     */
200     function reinvest()
201         onlyStronghands()
202         public
203     {
204         // fetch dividends
205         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
206         
207         // pay out the dividends virtually
208         address _customerAddress = msg.sender;
209         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
210         
211         // retrieve ref. bonus
212         _dividends += referralBalance_[_customerAddress];
213         referralBalance_[_customerAddress] = 0;
214         
215         // dispatch a buy order with the virtualized "withdrawn dividends"
216         uint256 _tokens = purchaseTokens(_dividends, 0x0);
217         
218         // fire event
219         onReinvestment(_customerAddress, _dividends, _tokens);
220     }
221     
222     /**
223      * Alias of sell() and withdraw().
224      */
225     function exit()
226         public
227     {
228         // get token count for caller & sell them all
229         address _customerAddress = msg.sender;
230         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
231         if(_tokens > 0) sell(_tokens);
232         
233         // lambo delivery service
234         withdraw();
235     }
236 
237     /**
238      * Withdraws all of the callers earnings.
239      */
240     function withdraw()
241         onlyStronghands()
242         public
243     {
244         // setup data
245         address _customerAddress = msg.sender;
246         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
247         
248         // update dividend tracker
249         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
250         
251         // add ref. bonus
252         _dividends += referralBalance_[_customerAddress];
253         referralBalance_[_customerAddress] = 0;
254         
255         // lambo delivery service
256         _customerAddress.transfer(_dividends);
257         
258         // fire event
259         onWithdraw(_customerAddress, _dividends);
260     }
261     
262     /**
263      * Liquifies tokens to ethereum.
264      */
265     function sell(uint256 _amountOfTokens)
266         onlyBagholders()
267         public
268     {
269         // setup data
270         address _customerAddress = msg.sender;
271         // russian hackers BTFO
272         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
273         uint256 _tokens = _amountOfTokens;
274         uint256 _ethereum = tokensToEthereum_(_tokens);
275         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
276         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
277         
278         // burn the sold tokens
279         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
280         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
281         
282         // update dividends tracker
283         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
284         payoutsTo_[_customerAddress] -= _updatedPayouts;       
285         
286         // dividing by zero is a bad idea
287         if (tokenSupply_ > 0) {
288             // update the amount of dividends per token
289             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
290         }
291         
292         // fire event
293         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
294     }
295     
296     
297     /**
298      * Transfer tokens from the caller to a new holder.
299      * Remember, there's a 10% fee here as well.
300      */
301     function transfer(address _toAddress, uint256 _amountOfTokens)
302         onlyBagholders()
303         public
304         returns(bool)
305     {
306         // setup
307         address _customerAddress = msg.sender;
308         
309         // make sure we have the requested tokens
310         // also disables transfers until ambassador phase is over
311         // ( we dont want whale premines )
312         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
313         
314         // withdraw all outstanding dividends first
315         if(myDividends(true) > 0) withdraw();
316         
317         // liquify 10% of the tokens that are transfered
318         // these are dispersed to shareholders
319         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
320         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
321         uint256 _dividends = tokensToEthereum_(_tokenFee);
322   
323         // burn the fee tokens
324         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
325 
326         // exchange tokens
327         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
328         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
329         
330         // update dividend trackers
331         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
332         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
333         
334         // disperse dividends among holders
335         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
336         
337         // fire event
338         Transfer(_customerAddress, _toAddress, _taxedTokens);
339         
340         // ERC20
341         return true;
342        
343     }
344     
345     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
346     /**
347      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
348      */
349     function disableInitialStage()
350         onlyAdministrator()
351         public
352     {
353         onlyAmbassadors = false;
354     }
355     
356     /**
357      * In case one of us dies, we need to replace ourselves.
358      */
359 
360     
361     /**
362      * Precautionary measures in case we need to adjust the masternode rate.
363      */
364     function setStakingRequirement(uint256 _amountOfTokens)
365         onlyAdministrator()
366         public
367     {
368         stakingRequirement = _amountOfTokens;
369     }
370     
371     /**
372      * If we want to rebrand, we can.
373      */
374     function setName(string _name)
375         onlyAdministrator()
376         public
377     {
378         name = _name;
379     }
380     
381     /**
382      * If we want to rebrand, we can.
383      */
384     function setSymbol(string _symbol)
385         onlyAdministrator()
386         public
387     {
388         symbol = _symbol;
389     }
390 
391     
392     /*----------  HELPERS AND CALCULATORS  ----------*/
393     /**
394      * Method to view the current Ethereum stored in the contract
395      * Example: totalEthereumBalance()
396      */
397     function totalEthereumBalance()
398         public
399         view
400         returns(uint)
401     {
402         return this.balance;
403     }
404     
405     /**
406      * Retrieve the total token supply.
407      */
408     function totalSupply()
409         public
410         view
411         returns(uint256)
412     {
413         return tokenSupply_;
414     }
415     
416     /**
417      * Retrieve the tokens owned by the caller.
418      */
419     function myTokens()
420         public
421         view
422         returns(uint256)
423     {
424         address _customerAddress = msg.sender;
425         return balanceOf(_customerAddress);
426     }
427     
428     /**
429      * Retrieve the dividends owned by the caller.
430      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
431      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
432      * But in the internal calculations, we want them separate. 
433      */ 
434     function myDividends(bool _includeReferralBonus) 
435         public 
436         view 
437         returns(uint256)
438     {
439         address _customerAddress = msg.sender;
440         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
441     }
442     
443     /**
444      * Retrieve the token balance of any single address.
445      */
446     function balanceOf(address _customerAddress)
447         view
448         public
449         returns(uint256)
450     {
451         return tokenBalanceLedger_[_customerAddress];
452     }
453     
454     /**
455      * Retrieve the dividend balance of any single address.
456      */
457     function dividendsOf(address _customerAddress)
458         view
459         public
460         returns(uint256)
461     {
462         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
463     }
464     
465     /**
466      * Return the buy price of 1 individual token.
467      */
468     function sellPrice() 
469         public 
470         view 
471         returns(uint256)
472     {
473         // our calculation relies on the token supply, so we need supply. Doh.
474         if(tokenSupply_ == 0){
475             return tokenPriceInitial_ - tokenPriceIncremental_;
476         } else {
477             uint256 _ethereum = tokensToEthereum_(1e18);
478             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
479             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
480             return _taxedEthereum;
481         }
482     }
483     
484     /**
485      * Return the sell price of 1 individual token.
486      */
487     function buyPrice() 
488         public 
489         view 
490         returns(uint256)
491     {
492         // our calculation relies on the token supply, so we need supply. Doh.
493         if(tokenSupply_ == 0){
494             return tokenPriceInitial_ + tokenPriceIncremental_;
495         } else {
496             uint256 _ethereum = tokensToEthereum_(1e18);
497             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
498             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
499             return _taxedEthereum;
500         }
501     }
502     
503     /**
504      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
505      */
506     function calculateTokensReceived(uint256 _ethereumToSpend) 
507         public 
508         view 
509         returns(uint256)
510     {
511         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
512         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
513         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
514         
515         return _amountOfTokens;
516     }
517     
518     /**
519      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
520      */
521     function calculateEthereumReceived(uint256 _tokensToSell) 
522         public 
523         view 
524         returns(uint256)
525     {
526         require(_tokensToSell <= tokenSupply_);
527         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
528         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
529         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
530         return _taxedEthereum;
531     }
532     
533     
534     /*==========================================
535     =            INTERNAL FUNCTIONS            =
536     ==========================================*/
537     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
538         antiEarlyWhale(_incomingEthereum)
539         internal
540         returns(uint256)
541     {
542         // data setup
543         address _customerAddress = msg.sender;
544         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
545         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
546         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
547         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
548         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
549         uint256 _fee = _dividends * magnitude;
550  
551         // no point in continuing execution if OP is a poorfag russian hacker
552         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
553         // (or hackers)
554         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
555         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
556         
557         // is the user referred by a masternode?
558         if(
559             // is this a referred purchase?
560             _referredBy != 0x0000000000000000000000000000000000000000 &&
561 
562             // no cheating!
563             _referredBy != _customerAddress &&
564             
565             // does the referrer have at least X whole tokens?
566             // i.e is the referrer a godly chad masternode
567             tokenBalanceLedger_[_referredBy] >= stakingRequirement
568         ){
569             // wealth redistribution
570             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
571         } else {
572             // no ref purchase
573             // add the referral bonus back to the global dividends cake
574             _dividends = SafeMath.add(_dividends, _referralBonus);
575             _fee = _dividends * magnitude;
576         }
577         
578         // we can't give people infinite ethereum
579         if(tokenSupply_ > 0){
580             
581             // add tokens to the pool
582             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
583  
584             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
585             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
586             
587             // calculate the amount of tokens the customer receives over his purchase 
588             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
589         
590         } else {
591             // add tokens to the pool
592             tokenSupply_ = _amountOfTokens;
593         }
594         
595         // update circulating supply & the ledger address for the customer
596         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
597         
598         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
599         //really i know you think you do but you don't
600         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
601         payoutsTo_[_customerAddress] += _updatedPayouts;
602         
603         // fire event
604         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
605         
606         return _amountOfTokens;
607     }
608 
609     /**
610      * Calculate Token price based on an amount of incoming ethereum
611      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
612      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
613      */
614     function ethereumToTokens_(uint256 _ethereum)
615         internal
616         view
617         returns(uint256)
618     {
619         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
620         uint256 _tokensReceived = 
621          (
622             (
623                 // underflow attempts BTFO
624                 SafeMath.sub(
625                     (sqrt
626                         (
627                             (_tokenPriceInitial**2)
628                             +
629                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
630                             +
631                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
632                             +
633                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
634                         )
635                     ), _tokenPriceInitial
636                 )
637             )/(tokenPriceIncremental_)
638         )-(tokenSupply_)
639         ;
640   
641         return _tokensReceived;
642     }
643     
644     /**
645      * Calculate token sell value.
646      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
647      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
648      */
649      function tokensToEthereum_(uint256 _tokens)
650         internal
651         view
652         returns(uint256)
653     {
654 
655         uint256 tokens_ = (_tokens + 1e18);
656         uint256 _tokenSupply = (tokenSupply_ + 1e18);
657         uint256 _etherReceived =
658         (
659             // underflow attempts BTFO
660             SafeMath.sub(
661                 (
662                     (
663                         (
664                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
665                         )-tokenPriceIncremental_
666                     )*(tokens_ - 1e18)
667                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
668             )
669         /1e18);
670         return _etherReceived;
671     }
672     
673     
674     //This is where all your gas goes, sorry
675     //Not sorry, you probably only paid 1 gwei
676     function sqrt(uint x) internal pure returns (uint y) {
677         uint z = (x + 1) / 2;
678         y = x;
679         while (z < y) {
680             y = z;
681             z = (x / z + z) / 2;
682         }
683     }
684 }
685 
686 /**
687  * @title SafeMath
688  * @dev Math operations with safety checks that throw on error
689  */
690 library SafeMath {
691 
692     /**
693     * @dev Multiplies two numbers, throws on overflow.
694     */
695     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
696         if (a == 0) {
697             return 0;
698         }
699         uint256 c = a * b;
700         assert(c / a == b);
701         return c;
702     }
703 
704     /**
705     * @dev Integer division of two numbers, truncating the quotient.
706     */
707     function div(uint256 a, uint256 b) internal pure returns (uint256) {
708         // assert(b > 0); // Solidity automatically throws when dividing by 0
709         uint256 c = a / b;
710         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
711         return c;
712     }
713 
714     /**
715     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
716     */
717     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
718         assert(b <= a);
719         return a - b;
720     }
721 
722     /**
723     * @dev Adds two numbers, throws on overflow.
724     */
725     function add(uint256 a, uint256 b) internal pure returns (uint256) {
726         uint256 c = a + b;
727         assert(c >= a);
728         return c;
729     }
730 }