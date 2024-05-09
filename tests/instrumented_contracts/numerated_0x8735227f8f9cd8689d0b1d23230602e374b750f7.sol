1 pragma solidity ^0.4.20;
2 
3 /*
4 * POWER                                               
5 * -> What?
6 * The original autonomous pyramid, improved:
7 * [x] More stable than ever, having withstood severe testnet abuse and attack attempts from our community!.
8 * [x] Audited, tested, and approved by known community security specialists such as tocsick and Arc.
9 * [X] New functionality; you can now perform partial sell orders. If you succumb to weak hands, you don't have to dump all of your bags!
10 * [x] New functionality; you can now transfer tokens between wallets. Trading is now possible from within the contract!
11 * [x] New Feature: PoS Masternodes! The first implementation of Ethereum Staking in the world! Vitalik is mad.
12 * [x] Masternodes: Holding 100 POWER Tokens allow you to generate a Masternode link, Masternode links are used as unique entry points to the contract!
13 * [x] Masternodes: All players who enter the contract through your Masternode have 30% of their 10% dividends fee rerouted from the master-node, to the node-master!
14 * [x] Longevity: We have something no other program has to offer.  We have big plans to moon this and provide lasting dividends so come along for the ride!
15 */
16 
17 contract Power {
18     /*=================================
19     =            MODIFIERS            =
20     =================================*/
21     // only people with tokens
22     modifier onlyBagholders() {
23         require(myTokens() > 0);
24         _;
25     }
26     
27     // only people with profits
28     modifier onlyStronghands() {
29         require(myDividends(true) > 0);
30         _;
31     }
32     
33     // administrators can:
34     // -> change the name of the contract
35     // -> change the name of the token
36     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
37     // they CANNOT:
38     // -> take funds
39     // -> disable withdrawals
40     // -> kill the contract
41     // -> change the price of tokens
42     modifier onlyAdministrator(){
43         address _customerAddress = msg.sender;
44         require(administrators[keccak256(_customerAddress)]);
45         _;
46     }
47     
48     
49     // ensures that the first tokens in the contract will be equally distributed
50     // meaning, no divine dump will be ever possible
51     // result: healthy longevity.
52     modifier antiEarlyWhale(uint256 _amountOfEthereum){
53         address _customerAddress = msg.sender;
54         
55         // are we still in the vulnerable phase?
56         // if so, enact anti early whale protocol 
57         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
58             require(
59                 // is the customer in the ambassador list?
60                 ambassadors_[_customerAddress] == true &&
61                 
62                 // does the customer purchase exceed the max ambassador quota?
63                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
64                 
65             );
66             
67             // updated the accumulated quota    
68             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
69         
70             // execute
71             _;
72         } else {
73             // in case the ether count drops low, the ambassador phase won't reinitiate
74             onlyAmbassadors = false;
75             _;    
76         }
77         
78     }
79     
80     
81     /*==============================
82     =            EVENTS            =
83     ==============================*/
84     event onTokenPurchase(
85         address indexed customerAddress,
86         uint256 incomingEthereum,
87         uint256 tokensMinted,
88         address indexed referredBy
89     );
90     
91     event onTokenSell(
92         address indexed customerAddress,
93         uint256 tokensBurned,
94         uint256 ethereumEarned
95     );
96     
97     event onReinvestment(
98         address indexed customerAddress,
99         uint256 ethereumReinvested,
100         uint256 tokensMinted
101     );
102     
103     event onWithdraw(
104         address indexed customerAddress,
105         uint256 ethereumWithdrawn
106     );
107     
108     // ERC20
109     event Transfer(
110         address indexed from,
111         address indexed to,
112         uint256 tokens
113     );
114     
115     
116     /*=====================================
117     =            CONFIGURABLES            =
118     =====================================*/
119     string public name = "POWER";
120     string public symbol = "POWER";
121     uint8 constant public decimals = 18;
122     uint8 constant internal dividendFee_ = 10;
123     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
124     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
125     uint256 constant internal magnitude = 2**64;
126     
127     // proof of stake (defaults at 100 tokens)
128     uint256 public stakingRequirement = 100e18;
129     
130     // ambassador program
131     mapping(address => bool) internal ambassadors_;
132     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
133     uint256 constant internal ambassadorQuota_ = 1 ether;
134     
135     
136     
137    /*================================
138     =            DATASETS            =
139     ================================*/
140     // amount of shares for each address (scaled number)
141     mapping(address => uint256) internal tokenBalanceLedger_;
142     mapping(address => uint256) internal referralBalance_;
143     mapping(address => int256) internal payoutsTo_;
144     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
145     uint256 internal tokenSupply_ = 0;
146     uint256 internal profitPerShare_;
147     
148     // administrator list (see above on what they can do)
149     mapping(bytes32 => bool) public administrators;
150     
151     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
152     bool public onlyAmbassadors = false;
153     
154 
155 
156     /*=======================================
157     =            PUBLIC FUNCTIONS            =
158     =======================================*/
159     /*
160     * -- APPLICATION ENTRY POINTS --  
161     */
162     function Power()
163         public
164     {
165         // add administrators here, we don't need no stinking admins
166         
167         // add the ambassadors here, or don't, power to the people
168 
169     }
170     
171      
172     /**
173      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
174      */
175     function buy(address _referredBy)
176         public
177         payable
178         returns(uint256)
179     {
180         purchaseTokens(msg.value, _referredBy);
181     }
182     
183     /**
184      * Fallback function to handle ethereum that was send straight to the contract
185      * Unfortunately we cannot use a referral address this way.
186      */
187     function()
188         payable
189         public
190     {
191         purchaseTokens(msg.value, 0x0);
192     }
193     
194     /**
195      * Converts all of caller's dividends to tokens.
196      */
197     function reinvest()
198         onlyStronghands()
199         public
200     {
201         // fetch dividends
202         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
203         
204         // pay out the dividends virtually
205         address _customerAddress = msg.sender;
206         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
207         
208         // retrieve ref. bonus
209         _dividends += referralBalance_[_customerAddress];
210         referralBalance_[_customerAddress] = 0;
211         
212         // dispatch a buy order with the virtualized "withdrawn dividends"
213         uint256 _tokens = purchaseTokens(_dividends, 0x0);
214         
215         // fire event
216         onReinvestment(_customerAddress, _dividends, _tokens);
217     }
218     
219     /**
220      * Alias of sell() and withdraw().
221      */
222     function exit()
223         public
224     {
225         // get token count for caller & sell them all
226         address _customerAddress = msg.sender;
227         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
228         if(_tokens > 0) sell(_tokens);
229         
230         // lambo delivery service
231         withdraw();
232     }
233 
234     /**
235      * Withdraws all of the callers earnings.
236      */
237     function withdraw()
238         onlyStronghands()
239         public
240     {
241         // setup data
242         address _customerAddress = msg.sender;
243         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
244         
245         // update dividend tracker
246         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
247         
248         // add ref. bonus
249         _dividends += referralBalance_[_customerAddress];
250         referralBalance_[_customerAddress] = 0;
251         
252         // lambo delivery service
253         _customerAddress.transfer(_dividends);
254         
255         // fire event
256         onWithdraw(_customerAddress, _dividends);
257     }
258     
259     /**
260      * Liquifies tokens to ethereum.
261      */
262     function sell(uint256 _amountOfTokens)
263         onlyBagholders()
264         public
265     {
266         // setup data
267         address _customerAddress = msg.sender;
268         // russian hackers BTFO
269         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
270         uint256 _tokens = _amountOfTokens;
271         uint256 _ethereum = tokensToEthereum_(_tokens);
272         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
273         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
274         
275         // burn the sold tokens
276         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
277         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
278         
279         // update dividends tracker
280         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
281         payoutsTo_[_customerAddress] -= _updatedPayouts;       
282         
283         // dividing by zero is a bad idea
284         if (tokenSupply_ > 0) {
285             // update the amount of dividends per token
286             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
287         }
288         
289         // fire event
290         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
291     }
292     
293     
294     /**
295      * Transfer tokens from the caller to a new holder.
296      * Remember, there's a 10% fee here as well.
297      */
298     function transfer(address _toAddress, uint256 _amountOfTokens)
299         onlyBagholders()
300         public
301         returns(bool)
302     {
303         // setup
304         address _customerAddress = msg.sender;
305         
306         // make sure we have the requested tokens
307         // also disables transfers until ambassador phase is over
308         // ( we dont want whale premines )
309         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
310         
311         // withdraw all outstanding dividends first
312         if(myDividends(true) > 0) withdraw();
313         
314         // liquify 10% of the tokens that are transfered
315         // these are dispersed to shareholders
316         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
317         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
318         uint256 _dividends = tokensToEthereum_(_tokenFee);
319   
320         // burn the fee tokens
321         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
322 
323         // exchange tokens
324         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
325         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
326         
327         // update dividend trackers
328         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
329         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
330         
331         // disperse dividends among holders
332         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
333         
334         // fire event
335         Transfer(_customerAddress, _toAddress, _taxedTokens);
336         
337         // ERC20
338         return true;
339        
340     }
341     
342     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
343     /**
344      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
345      */
346     function disableInitialStage()
347         onlyAdministrator()
348         public
349     {
350         onlyAmbassadors = false;
351     }
352     
353     /**
354      * In case one of us dies, we need to replace ourselves.
355      */
356     function setAdministrator(bytes32 _identifier, bool _status)
357         onlyAdministrator()
358         public
359     {
360         administrators[_identifier] = _status;
361     }
362     
363     /**
364      * Precautionary measures in case we need to adjust the masternode rate.
365      */
366     function setStakingRequirement(uint256 _amountOfTokens)
367         onlyAdministrator()
368         public
369     {
370         stakingRequirement = _amountOfTokens;
371     }
372     
373     /**
374      * If we want to rebrand, we can.
375      */
376     function setName(string _name)
377         onlyAdministrator()
378         public
379     {
380         name = _name;
381     }
382     
383     /**
384      * If we want to rebrand, we can.
385      */
386     function setSymbol(string _symbol)
387         onlyAdministrator()
388         public
389     {
390         symbol = _symbol;
391     }
392 
393     
394     /*----------  HELPERS AND CALCULATORS  ----------*/
395     /**
396      * Method to view the current Ethereum stored in the contract
397      * Example: totalEthereumBalance()
398      */
399     function totalEthereumBalance()
400         public
401         view
402         returns(uint)
403     {
404         return this.balance;
405     }
406     
407     /**
408      * Retrieve the total token supply.
409      */
410     function totalSupply()
411         public
412         view
413         returns(uint256)
414     {
415         return tokenSupply_;
416     }
417     
418     /**
419      * Retrieve the tokens owned by the caller.
420      */
421     function myTokens()
422         public
423         view
424         returns(uint256)
425     {
426         address _customerAddress = msg.sender;
427         return balanceOf(_customerAddress);
428     }
429     
430     /**
431      * Retrieve the dividends owned by the caller.
432      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
433      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
434      * But in the internal calculations, we want them separate. 
435      */ 
436     function myDividends(bool _includeReferralBonus) 
437         public 
438         view 
439         returns(uint256)
440     {
441         address _customerAddress = msg.sender;
442         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
443     }
444     
445     /**
446      * Retrieve the token balance of any single address.
447      */
448     function balanceOf(address _customerAddress)
449         view
450         public
451         returns(uint256)
452     {
453         return tokenBalanceLedger_[_customerAddress];
454     }
455     
456     /**
457      * Retrieve the dividend balance of any single address.
458      */
459     function dividendsOf(address _customerAddress)
460         view
461         public
462         returns(uint256)
463     {
464         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
465     }
466     
467     /**
468      * Return the buy price of 1 individual token.
469      */
470     function sellPrice() 
471         public 
472         view 
473         returns(uint256)
474     {
475         // our calculation relies on the token supply, so we need supply. Doh.
476         if(tokenSupply_ == 0){
477             return tokenPriceInitial_ - tokenPriceIncremental_;
478         } else {
479             uint256 _ethereum = tokensToEthereum_(1e18);
480             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
481             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
482             return _taxedEthereum;
483         }
484     }
485     
486     /**
487      * Return the sell price of 1 individual token.
488      */
489     function buyPrice() 
490         public 
491         view 
492         returns(uint256)
493     {
494         // our calculation relies on the token supply, so we need supply. Doh.
495         if(tokenSupply_ == 0){
496             return tokenPriceInitial_ + tokenPriceIncremental_;
497         } else {
498             uint256 _ethereum = tokensToEthereum_(1e18);
499             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
500             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
501             return _taxedEthereum;
502         }
503     }
504     
505     /**
506      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
507      */
508     function calculateTokensReceived(uint256 _ethereumToSpend) 
509         public 
510         view 
511         returns(uint256)
512     {
513         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
514         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
515         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
516         
517         return _amountOfTokens;
518     }
519     
520     /**
521      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
522      */
523     function calculateEthereumReceived(uint256 _tokensToSell) 
524         public 
525         view 
526         returns(uint256)
527     {
528         require(_tokensToSell <= tokenSupply_);
529         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
530         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
531         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
532         return _taxedEthereum;
533     }
534     
535     
536     /*==========================================
537     =            INTERNAL FUNCTIONS            =
538     ==========================================*/
539     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
540         antiEarlyWhale(_incomingEthereum)
541         internal
542         returns(uint256)
543     {
544         // data setup
545         address _customerAddress = msg.sender;
546         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
547         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
548         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
549         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
550         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
551         uint256 _fee = _dividends * magnitude;
552  
553         // no point in continuing execution if OP is a poorfag russian hacker
554         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
555         // (or hackers)
556         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
557         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
558         
559         // is the user referred by a masternode?
560         if(
561             // is this a referred purchase?
562             _referredBy != 0x0000000000000000000000000000000000000000 &&
563 
564             // no cheating!
565             _referredBy != _customerAddress &&
566             
567             // does the referrer have at least X whole tokens?
568             // i.e is the referrer a godly chad masternode
569             tokenBalanceLedger_[_referredBy] >= stakingRequirement
570         ){
571             // wealth redistribution
572             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
573         } else {
574             // no ref purchase
575             // add the referral bonus back to the global dividends cake
576             _dividends = SafeMath.add(_dividends, _referralBonus);
577             _fee = _dividends * magnitude;
578         }
579         
580         // we can't give people infinite ethereum
581         if(tokenSupply_ > 0){
582             
583             // add tokens to the pool
584             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
585  
586             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
587             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
588             
589             // calculate the amount of tokens the customer receives over his purchase 
590             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
591         
592         } else {
593             // add tokens to the pool
594             tokenSupply_ = _amountOfTokens;
595         }
596         
597         // update circulating supply & the ledger address for the customer
598         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
599         
600         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
601         //really i know you think you do but you don't
602         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
603         payoutsTo_[_customerAddress] += _updatedPayouts;
604         
605         // fire event
606         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
607         
608         return _amountOfTokens;
609     }
610 
611     /**
612      * Calculate Token price based on an amount of incoming ethereum
613      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
614      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
615      */
616     function ethereumToTokens_(uint256 _ethereum)
617         internal
618         view
619         returns(uint256)
620     {
621         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
622         uint256 _tokensReceived = 
623          (
624             (
625                 // underflow attempts BTFO
626                 SafeMath.sub(
627                     (sqrt
628                         (
629                             (_tokenPriceInitial**2)
630                             +
631                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
632                             +
633                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
634                             +
635                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
636                         )
637                     ), _tokenPriceInitial
638                 )
639             )/(tokenPriceIncremental_)
640         )-(tokenSupply_)
641         ;
642   
643         return _tokensReceived;
644     }
645     
646     /**
647      * Calculate token sell value.
648      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
649      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
650      */
651      function tokensToEthereum_(uint256 _tokens)
652         internal
653         view
654         returns(uint256)
655     {
656 
657         uint256 tokens_ = (_tokens + 1e18);
658         uint256 _tokenSupply = (tokenSupply_ + 1e18);
659         uint256 _etherReceived =
660         (
661             // underflow attempts BTFO
662             SafeMath.sub(
663                 (
664                     (
665                         (
666                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
667                         )-tokenPriceIncremental_
668                     )*(tokens_ - 1e18)
669                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
670             )
671         /1e18);
672         return _etherReceived;
673     }
674     
675     
676     //This is where all your gas goes, sorry
677     //Not sorry, you probably only paid 1 gwei
678     function sqrt(uint x) internal pure returns (uint y) {
679         uint z = (x + 1) / 2;
680         y = x;
681         while (z < y) {
682             y = z;
683             z = (x / z + z) / 2;
684         }
685     }
686 }
687 
688 /**
689  * @title SafeMath
690  * @dev Math operations with safety checks that throw on error
691  */
692 library SafeMath {
693 
694     /**
695     * @dev Multiplies two numbers, throws on overflow.
696     */
697     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
698         if (a == 0) {
699             return 0;
700         }
701         uint256 c = a * b;
702         assert(c / a == b);
703         return c;
704     }
705 
706     /**
707     * @dev Integer division of two numbers, truncating the quotient.
708     */
709     function div(uint256 a, uint256 b) internal pure returns (uint256) {
710         // assert(b > 0); // Solidity automatically throws when dividing by 0
711         uint256 c = a / b;
712         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
713         return c;
714     }
715 
716     /**
717     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
718     */
719     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
720         assert(b <= a);
721         return a - b;
722     }
723 
724     /**
725     * @dev Adds two numbers, throws on overflow.
726     */
727     function add(uint256 a, uint256 b) internal pure returns (uint256) {
728         uint256 c = a + b;
729         assert(c >= a);
730         return c;
731     }
732 }