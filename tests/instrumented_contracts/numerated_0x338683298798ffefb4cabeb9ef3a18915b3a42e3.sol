1 pragma solidity ^0.4.20;
2  
3 /*
4 * 
5 * ====================================*
6 *
7 * PROOF OF CLONE WARS!!!!!!!
8 * https://pocw.io
9 * 
10 * ====================================*
11 * -> What?
12 * The original autonomous pyramid, improved:
13 * [x] More stable than ever, having withstood severe testnet abuse and attack attempts from our community!.
14 * [x] Audited, tested, and approved by known community security specialists.
15 * [X] New functionality; you can now perform partial sell orders. If you succumb to weak hands, you don't have to dump all of your bags!
16 * [x] New functionality; you can now transfer tokens between wallets. Trading is now possible from within the contract!
17 * [x] New Feature: PoS Masternodes! The first implementation of Ethereum Staking in the world! Vitalik is mad.
18 * [x] Masternodes: Holding 100 POCW Tokens allow you to generate a Masternode link, Masternode links are used as unique entry points to the contract!
19 * [x] Masternodes: All players who enter the contract through your Masternode have 30% of their 12.5% dividends fee rerouted from the master-node, to the node-master!
20 *
21 * [x] REVOLUTIONARY 0% TRANSFER FEES, NOW YOU CAN SEND POCW tokens to all your family, no charge :)
22 *
23 * -> Who worked on this project?
24 * Trusted community
25 *
26 */
27  
28 contract ProofOfCloneWars {
29     /*=================================
30     =            MODIFIERS            =
31     =================================*/
32     // only people with tokens
33     modifier onlyBagholders() {
34         require(myTokens() > 0);
35         _;
36     }
37  
38     // only people with profits
39     modifier onlyStronghands() {
40         require(myDividends(true) > 0);
41         _;
42     }
43  
44     // administrators can:
45     // -> change the name of the contract
46     // -> change the name of the token
47     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
48     // they CANNOT:
49     // -> take funds
50     // -> disable withdrawals
51     // -> kill the contract
52     // -> change the price of tokens
53     modifier onlyAdministrator(){
54         address _customerAddress = msg.sender;
55         require(administrators[_customerAddress]);
56         _;
57     }
58  
59  
60     // ensures that the first tokens in the contract will be equally distributed
61     // meaning, no divine dump will be ever possible
62     // result: healthy longevity.
63     modifier antiEarlyWhale(uint256 _amountOfEthereum){
64         address _customerAddress = msg.sender;
65  
66         // are we still in the vulnerable phase?
67         // if so, enact anti early whale protocol
68         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
69             require(
70                 // is the customer in the ambassador list?
71                 ambassadors_[_customerAddress] == true &&
72  
73                 // does the customer purchase exceed the max ambassador quota?
74                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
75  
76             );
77  
78             // updated the accumulated quota
79             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
80  
81             // execute
82             _;
83         } else {
84             // in case the ether count drops low, the ambassador phase won't reinitiate
85             onlyAmbassadors = false;
86             _;
87         }
88  
89     }
90  
91  
92     /*==============================
93     =            EVENTS            =
94     ==============================*/
95     event onTokenPurchase(
96         address indexed customerAddress,
97         uint256 incomingEthereum,
98         uint256 tokensMinted,
99         address indexed referredBy
100     );
101  
102     event onTokenSell(
103         address indexed customerAddress,
104         uint256 tokensBurned,
105         uint256 ethereumEarned
106     );
107  
108     event onReinvestment(
109         address indexed customerAddress,
110         uint256 ethereumReinvested,
111         uint256 tokensMinted
112     );
113  
114     event onWithdraw(
115         address indexed customerAddress,
116         uint256 ethereumWithdrawn
117     );
118  
119     // ERC20
120     event Transfer(
121         address indexed from,
122         address indexed to,
123         uint256 tokens
124     );
125  
126  
127     /*=====================================
128     =            CONFIGURABLES            =
129     =====================================*/
130     string public name = "ProofOfCloneWars";
131     string public symbol = "POCW";
132     uint8 constant public decimals = 18;
133     uint8 constant internal dividendFee_ = 8; // Look, strong Math 12.5% SUPER SAFE
134     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
135     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
136     uint256 constant internal magnitude = 2**64;
137  
138     // proof of stake (defaults at 100 tokens)
139     uint256 public stakingRequirement = 100e18;
140  
141     // ambassador program
142     mapping(address => bool) internal ambassadors_;
143     uint256 constant internal ambassadorMaxPurchase_ = 0.5 ether;
144     uint256 constant internal ambassadorQuota_ = 3 ether;
145  
146  
147  
148    /*================================
149     =            DATASETS            =
150     ================================*/
151     // amount of shares for each address (scaled number)
152     mapping(address => uint256) internal tokenBalanceLedger_;
153     mapping(address => uint256) internal referralBalance_;
154     mapping(address => int256) internal payoutsTo_;
155     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
156     uint256 internal tokenSupply_ = 0;
157     uint256 internal profitPerShare_;
158  
159     // administrator list (see above on what they can do)
160     mapping(address => bool) public administrators;
161  
162     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
163     bool public onlyAmbassadors = true;
164  
165  
166  
167     /*=======================================
168     =            PUBLIC FUNCTIONS            =
169     =======================================*/
170     /*
171     * -- APPLICATION ENTRY POINTS --
172     */
173     function ProofOfCloneWars()
174         public
175     {
176         // add administrators here
177         administrators[0x5d4E9E60C6B3Dd2779CA1F374694e031e2Ca2557] = true;
178     }
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
322         // exchange tokens
323         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
324         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
325  
326         // update dividend trackers
327         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
328         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
329  
330         // fire event
331         Transfer(_customerAddress, _toAddress, _amountOfTokens);
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
352     function setAdministrator(address _identifier, bool _status)
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
536         antiEarlyWhale(_incomingEthereum)
537         internal
538         returns(uint256)
539     {
540         // data setup
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