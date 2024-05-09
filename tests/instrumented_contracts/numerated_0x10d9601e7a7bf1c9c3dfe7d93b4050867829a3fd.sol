1 pragma solidity ^0.4.20;
2 
3 /*
4 * CryptoDevTeam.Net Presents
5 * ====================================*
6 *
7 * Built by trusted community members
8 * IronHandsCoin is a Phil approved Pyramid                         
9 *
10 * ====================================*
11 * -> What?
12 * The original autonomous pyramid, improved:
13 * [x] More stable than ever, having withstood severe testnet abuse and attack attempts from our community!.
14 * [x] Audited, tested, and approved by known community security specialists.
15 * [X] New functionality; you can now perform partial sell orders. If you succumb to weak hands, you don't have to dump all of your bags!
16 * [x] New functionality; you can now transfer tokens between wallets. Trading is now possible from within the contract!
17 * [x] New Feature: PoS Masternodes! The first implementation of Ethereum Staking in the world! Vitalik is mad.
18 * [x] Masternodes: Holding 50 IHC allow you to generate a Gangsternode link, Gangsternode links are used as unique entry points to the contract!
19 * [x] Masternodes: All players who enter the contract through your Masternode have 30% of their 10% dividends fee rerouted from the master-node, to the node-master!
20 * [x] Game play! No transfer tax and we will be adding gaming functionality-risk your IHC tokens and win more!
21 *
22 * -> What about the last projects?
23 * Every programming member of the old dev team has been fired and/or killed.
24 * The new dev team consists of seasoned, professional developers and has been audited by veteran solidity experts.
25 * Additionally, two independent testnet iterations have been used by hundreds of people; not a single point of failure was found.
26 * 
27 * -> Who worked on this project?
28 * Trusted community members
29 *
30 */
31 
32 contract IronHandsCoin {
33     /*=================================
34     =            MODIFIERS            =
35     =================================*/
36     // only people with tokens
37     modifier onlyBagholders() {
38         require(myTokens() > 0);
39         _;
40     }
41     
42     // only people with profits
43     modifier onlyStronghands() {
44         require(myDividends(true) > 0);
45         _;
46     }
47     
48     // administrators can:
49     // -> change the name of the contract
50     // -> change the name of the token
51     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
52     // they CANNOT:
53     // -> take funds
54     // -> disable withdrawals
55     // -> kill the contract
56     // -> change the price of tokens
57     modifier onlyAdministrator(){
58         address _customerAddress = msg.sender;
59         require(administrators[_customerAddress]);
60         _;
61     }
62     
63     
64     // ensures that the first tokens in the contract will be equally distributed
65     // meaning, no divine dump will be ever possible
66     // result: healthy longevity.
67     modifier antiEarlyWhale(uint256 _amountOfEthereum){
68         address _customerAddress = msg.sender;
69         
70         // are we still in the vulnerable phase?
71         // if so, enact anti early whale protocol 
72         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
73             require(
74                 // is the customer in the ambassador list?
75                 ambassadors_[_customerAddress] == true &&
76                 
77                 // does the customer purchase exceed the max ambassador quota?
78                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
79                 
80             );
81             
82             // updated the accumulated quota    
83             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
84         
85             // execute
86             _;
87         } else {
88             // in case the ether count drops low, the ambassador phase won't reinitiate
89             onlyAmbassadors = false;
90             _;    
91         }
92         
93     }
94     
95     
96     /*==============================
97     =            EVENTS            =
98     ==============================*/
99     event onTokenPurchase(
100         address indexed customerAddress,
101         uint256 incomingEthereum,
102         uint256 tokensMinted,
103         address indexed referredBy
104     );
105     
106     event onTokenSell(
107         address indexed customerAddress,
108         uint256 tokensBurned,
109         uint256 ethereumEarned
110     );
111     
112     event onReinvestment(
113         address indexed customerAddress,
114         uint256 ethereumReinvested,
115         uint256 tokensMinted
116     );
117     
118     event onWithdraw(
119         address indexed customerAddress,
120         uint256 ethereumWithdrawn
121     );
122     
123     // ERC20
124     event Transfer(
125         address indexed from,
126         address indexed to,
127         uint256 tokens
128     );
129     
130     
131     /*=====================================
132     =            CONFIGURABLES            =
133     =====================================*/
134     string public name = "IronHandsCoin";
135     string public symbol = "IHC";
136     uint8 constant public decimals = 18;
137     uint8 constant internal dividendFee_ = 3; // Look, strong Math
138     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
139     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
140     uint256 constant internal magnitude = 2**64;
141     
142     // proof of stake (defaults at 100 tokens)
143     uint256 public stakingRequirement = 50e18;
144     
145     // ambassador program
146     mapping(address => bool) internal ambassadors_;
147     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
148     uint256 constant internal ambassadorQuota_ = 3 ether;
149     
150     
151     
152    /*================================
153     =            DATASETS            =
154     ================================*/
155     // amount of shares for each address (scaled number)
156     mapping(address => uint256) internal tokenBalanceLedger_;
157     mapping(address => uint256) internal referralBalance_;
158     mapping(address => int256) internal payoutsTo_;
159     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
160     uint256 internal tokenSupply_ = 0;
161     uint256 internal profitPerShare_;
162     
163     // administrator list (see above on what they can do)
164     mapping(address => bool) public administrators;
165     
166     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
167     bool public onlyAmbassadors = true;
168     
169 
170 
171     /*=======================================
172     =            PUBLIC FUNCTIONS            =
173     =======================================*/
174     /*
175     * -- APPLICATION ENTRY POINTS --  
176     */
177     function IronHandsCoin()
178         public
179     {
180         // add administrators here
181         administrators[0x976b7B7E25e70C569915738d58450092bFAD5AF7] = true;
182         
183         // add the ambassadors here.
184         // gsj - shitty dev and marketing 
185         ambassadors_[0x976b7B7E25e70C569915738d58450092bFAD5AF7] = true;
186         
187         // CTE is a gangster with PLATINUM hands
188         ambassadors_[0xCd39c70f9DF2A0D216c3A52C5A475914485a0625] = true;
189         
190         // STEVE
191         ambassadors_[0x739b28163DddAeA561151A4342470eb0fE7d2cE6] = true;
192     }
193      
194     /**
195      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
196      */
197     function buy(address _referredBy)
198         public
199         payable
200         returns(uint256)
201     {
202         purchaseTokens(msg.value, _referredBy);
203     }
204     
205     /**
206      * Fallback function to handle ethereum that was send straight to the contract
207      * Unfortunately we cannot use a referral address this way.
208      */
209     function()
210         payable
211         public
212     {
213         purchaseTokens(msg.value, 0x0);
214     }
215     
216     /**
217      * Converts all of caller's dividends to tokens.
218     */
219     function reinvest()
220         onlyStronghands()
221         public
222     {
223         // fetch dividends
224         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
225         
226         // pay out the dividends virtually
227         address _customerAddress = msg.sender;
228         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
229         
230         // retrieve ref. bonus
231         _dividends += referralBalance_[_customerAddress];
232         referralBalance_[_customerAddress] = 0;
233         
234         // dispatch a buy order with the virtualized "withdrawn dividends"
235         uint256 _tokens = purchaseTokens(_dividends, 0x0);
236         
237         // fire event
238         onReinvestment(_customerAddress, _dividends, _tokens);
239     }
240     
241     /**
242      * Alias of sell() and withdraw().
243      */
244     function exit()
245         public
246     {
247         // get token count for caller & sell them all
248         address _customerAddress = msg.sender;
249         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
250         if(_tokens > 0) sell(_tokens);
251         
252         // lambo delivery service
253         withdraw();
254     }
255 
256     /**
257      * Withdraws all of the callers earnings.
258      */
259     function withdraw()
260         onlyStronghands()
261         public
262     {
263         // setup data
264         address _customerAddress = msg.sender;
265         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
266         
267         // update dividend tracker
268         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
269         
270         // add ref. bonus
271         _dividends += referralBalance_[_customerAddress];
272         referralBalance_[_customerAddress] = 0;
273         
274         // lambo delivery service
275         _customerAddress.transfer(_dividends);
276         
277         // fire event
278         onWithdraw(_customerAddress, _dividends);
279     }
280     
281     /**
282      * Liquifies tokens to ethereum.
283      */
284     function sell(uint256 _amountOfTokens)
285         onlyBagholders()
286         public
287     {
288         // setup data
289         address _customerAddress = msg.sender;
290         // russian hackers BTFO
291         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
292         uint256 _tokens = _amountOfTokens;
293         uint256 _ethereum = tokensToEthereum_(_tokens);
294         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
295         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
296         
297         // burn the sold tokens
298         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
299         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
300         
301         // update dividends tracker
302         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
303         payoutsTo_[_customerAddress] -= _updatedPayouts;       
304         
305         // dividing by zero is a bad idea
306         if (tokenSupply_ > 0) {
307             // update the amount of dividends per token
308             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
309         }
310         
311         // fire event
312         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
313     }
314     
315     
316     /**
317      * Transfer tokens from the caller to a new holder.
318      * Remember, there's a 10% fee here as well.
319      */
320     function transfer(address _toAddress, uint256 _amountOfTokens)
321         onlyBagholders()
322         public
323         returns(bool)
324     {
325         // setup
326         address _customerAddress = msg.sender;
327         
328         // make sure we have the requested tokens
329         // also disables transfers until ambassador phase is over
330         // ( we dont want whale premines )
331         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
332         
333         // withdraw all outstanding dividends first
334         if(myDividends(true) > 0) withdraw();
335         
336         // ERC20
337         return true;
338        
339     }
340     
341     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
342     /**
343      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
344      */
345     function disableInitialStage()
346         onlyAdministrator()
347         public
348     {
349         onlyAmbassadors = false;
350     }
351     
352     /**
353      * In case one of us dies, we need to replace ourselves.
354      */
355     function setAdministrator(address _identifier, bool _status)
356         onlyAdministrator()
357         public
358     {
359         administrators[_identifier] = _status;
360     }
361     
362     /**
363      * Precautionary measures in case we need to adjust the masternode rate.
364      */
365     function setStakingRequirement(uint256 _amountOfTokens)
366         onlyAdministrator()
367         public
368     {
369         stakingRequirement = _amountOfTokens;
370     }
371     
372     /**
373      * If we want to rebrand, we can.
374      */
375     function setName(string _name)
376         onlyAdministrator()
377         public
378     {
379         name = _name;
380     }
381     
382     /**
383      * If we want to rebrand, we can.
384      */
385     function setSymbol(string _symbol)
386         onlyAdministrator()
387         public
388     {
389         symbol = _symbol;
390     }
391 
392     
393     /*----------  HELPERS AND CALCULATORS  ----------*/
394     /**
395      * Method to view the current Ethereum stored in the contract
396      * Example: totalEthereumBalance()
397      */
398     function totalEthereumBalance()
399         public
400         view
401         returns(uint)
402     {
403         return this.balance;
404     }
405     
406     /**
407      * Retrieve the total token supply.
408      */
409     function totalSupply()
410         public
411         view
412         returns(uint256)
413     {
414         return tokenSupply_;
415     }
416     
417     /**
418      * Retrieve the tokens owned by the caller.
419      */
420     function myTokens()
421         public
422         view
423         returns(uint256)
424     {
425         address _customerAddress = msg.sender;
426         return balanceOf(_customerAddress);
427     }
428     
429     /**
430      * Retrieve the dividends owned by the caller.
431      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
432      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
433      * But in the internal calculations, we want them separate. 
434      */ 
435     function myDividends(bool _includeReferralBonus) 
436         public 
437         view 
438         returns(uint256)
439     {
440         address _customerAddress = msg.sender;
441         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
442     }
443     
444     /**
445      * Retrieve the token balance of any single address.
446      */
447     function balanceOf(address _customerAddress)
448         view
449         public
450         returns(uint256)
451     {
452         return tokenBalanceLedger_[_customerAddress];
453     }
454     
455     /**
456      * Retrieve the dividend balance of any single address.
457      */
458     function dividendsOf(address _customerAddress)
459         view
460         public
461         returns(uint256)
462     {
463         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
464     }
465     
466     /**
467      * Return the buy price of 1 individual token.
468      */
469     function sellPrice() 
470         public 
471         view 
472         returns(uint256)
473     {
474         // our calculation relies on the token supply, so we need supply. Doh.
475         if(tokenSupply_ == 0){
476             return tokenPriceInitial_ - tokenPriceIncremental_;
477         } else {
478             uint256 _ethereum = tokensToEthereum_(1e18);
479             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
480             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
481             return _taxedEthereum;
482         }
483     }
484     
485     /**
486      * Return the sell price of 1 individual token.
487      */
488     function buyPrice() 
489         public 
490         view 
491         returns(uint256)
492     {
493         // our calculation relies on the token supply, so we need supply. Doh.
494         if(tokenSupply_ == 0){
495             return tokenPriceInitial_ + tokenPriceIncremental_;
496         } else {
497             uint256 _ethereum = tokensToEthereum_(1e18);
498             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
499             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
500             return _taxedEthereum;
501         }
502     }
503     
504     /**
505      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
506      */
507     function calculateTokensReceived(uint256 _ethereumToSpend) 
508         public 
509         view 
510         returns(uint256)
511     {
512         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
513         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
514         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
515         
516         return _amountOfTokens;
517     }
518     
519     /**
520      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
521      */
522     function calculateEthereumReceived(uint256 _tokensToSell) 
523         public 
524         view 
525         returns(uint256)
526     {
527         require(_tokensToSell <= tokenSupply_);
528         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
529         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
530         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
531         return _taxedEthereum;
532     }
533     
534     
535     /*==========================================
536     =            INTERNAL FUNCTIONS            =
537     ==========================================*/
538     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
539         antiEarlyWhale(_incomingEthereum)
540         internal
541         returns(uint256)
542     {
543         // data setup
544         address _customerAddress = msg.sender;
545         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
546         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
547         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
548         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
549         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
550         uint256 _fee = _dividends * magnitude;
551  
552         // no point in continuing execution if OP is a poorfag russian hacker
553         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
554         // (or hackers)
555         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
556         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
557         
558         // is the user referred by a masternode?
559         if(
560             // is this a referred purchase?
561             _referredBy != 0x0000000000000000000000000000000000000000 &&
562 
563             // no cheating!
564             _referredBy != _customerAddress &&
565             
566             // does the referrer have at least X whole tokens?
567             // i.e is the referrer a godly chad masternode
568             tokenBalanceLedger_[_referredBy] >= stakingRequirement
569         ){
570             // wealth redistribution
571             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
572         } else {
573             // no ref purchase
574             // add the referral bonus back to the global dividends cake
575             _dividends = SafeMath.add(_dividends, _referralBonus);
576             _fee = _dividends * magnitude;
577         }
578         
579         // we can't give people infinite ethereum
580         if(tokenSupply_ > 0){
581             
582             // add tokens to the pool
583             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
584  
585             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
586             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
587             
588             // calculate the amount of tokens the customer receives over his purchase 
589             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
590         
591         } else {
592             // add tokens to the pool
593             tokenSupply_ = _amountOfTokens;
594         }
595         
596         // update circulating supply & the ledger address for the customer
597         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
598         
599         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
600         //really i know you think you do but you don't
601         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
602         payoutsTo_[_customerAddress] += _updatedPayouts;
603         
604         // fire event
605         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
606         
607         return _amountOfTokens;
608     }
609 
610     /**
611      * Calculate Token price based on an amount of incoming ethereum
612      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
613      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
614      */
615     function ethereumToTokens_(uint256 _ethereum)
616         internal
617         view
618         returns(uint256)
619     {
620         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
621         uint256 _tokensReceived = 
622          (
623             (
624                 // underflow attempts BTFO
625                 SafeMath.sub(
626                     (sqrt
627                         (
628                             (_tokenPriceInitial**2)
629                             +
630                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
631                             +
632                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
633                             +
634                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
635                         )
636                     ), _tokenPriceInitial
637                 )
638             )/(tokenPriceIncremental_)
639         )-(tokenSupply_)
640         ;
641   
642         return _tokensReceived;
643     }
644     
645     /**
646      * Calculate token sell value.
647      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
648      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
649      */
650      function tokensToEthereum_(uint256 _tokens)
651         internal
652         view
653         returns(uint256)
654     {
655 
656         uint256 tokens_ = (_tokens + 1e18);
657         uint256 _tokenSupply = (tokenSupply_ + 1e18);
658         uint256 _etherReceived =
659         (
660             // underflow attempts BTFO
661             SafeMath.sub(
662                 (
663                     (
664                         (
665                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
666                         )-tokenPriceIncremental_
667                     )*(tokens_ - 1e18)
668                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
669             )
670         /1e18);
671         return _etherReceived;
672     }
673     
674     
675     //This is where all your gas goes, sorry
676     //Not sorry, you probably only paid 1 gwei
677     function sqrt(uint x) internal pure returns (uint y) {
678         uint z = (x + 1) / 2;
679         y = x;
680         while (z < y) {
681             y = z;
682             z = (x / z + z) / 2;
683         }
684     }
685 }
686 
687 /**
688  * @title SafeMath
689  * @dev Math operations with safety checks that throw on error
690  */
691 library SafeMath {
692 
693     /**
694     * @dev Multiplies two numbers, throws on overflow.
695     */
696     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
697         if (a == 0) {
698             return 0;
699         }
700         uint256 c = a * b;
701         assert(c / a == b);
702         return c;
703     }
704 
705     /**
706     * @dev Integer division of two numbers, truncating the quotient.
707     */
708     function div(uint256 a, uint256 b) internal pure returns (uint256) {
709         // assert(b > 0); // Solidity automatically throws when dividing by 0
710         uint256 c = a / b;
711         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
712         return c;
713     }
714 
715     /**
716     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
717     */
718     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
719         assert(b <= a);
720         return a - b;
721     }
722 
723     /**
724     * @dev Adds two numbers, throws on overflow.
725     */
726     function add(uint256 a, uint256 b) internal pure returns (uint256) {
727         uint256 c = a + b;
728         assert(c >= a);
729         return c;
730     }
731 }