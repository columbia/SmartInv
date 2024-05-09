1 pragma solidity ^0.4.20;
2 
3 /*
4 * In dedication of the ShillMaster himself, we Present...
5 * ====================================*
6 *
7 * PROOF OF CRAIG GRANT COIN                        
8 *
9 * ====================================*
10 * -> What?
11 * The original autonomous pyramid, improved:
12 * [x] More stable than ever, having withstood severe testnet abuse and attack attempts from our community!.
13 * [x] Audited, tested, and approved by known community security specialists.
14 * [X] New functionality; you can now perform partial sell orders. If you succumb to weak hands, you don't have to dump all of your bags!
15 * [x] New functionality; you can now transfer tokens between wallets. Trading is now possible from within the contract!
16 * [x] New Feature: PoS Masternodes! The first implementation of Ethereum Staking in the world! Vitalik is mad.
17 * [x] Masternodes: Holding 50 POCG Coins allow you to generate a Masternode link, Masternode links are used as unique entry points to the contract!
18 * [x] Masternodes: All players who enter the contract through your Masternode have 30% of their 10% dividends fee rerouted from the master-node, to the node-master!
19 *
20 * 
21 * -> Who worked on this project?
22 * Trusted community members
23 *
24 */
25 
26 contract ProofOfCraigGrant {
27     /*=================================
28     =            MODIFIERS            =
29     =================================*/
30     // only people with tokens
31     modifier onlyBagholders() {
32         require(myTokens() > 0);
33         _;
34     }
35     
36     // only people with profits
37     modifier onlyStronghands() {
38         require(myDividends(true) > 0);
39         _;
40     }
41     
42     // administrators can:
43     // -> change the name of the contract
44     // -> change the name of the token
45     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
46     // they CANNOT:
47     // -> take funds
48     // -> disable withdrawals
49     // -> kill the contract
50     // -> change the price of tokens
51     modifier onlyAdministrator(){
52         address _customerAddress = msg.sender;
53         require(administrators[_customerAddress]);
54         _;
55     }
56     
57     
58     // ensures that the first tokens in the contract will be equally distributed
59     // meaning, no divine dump will be ever possible
60     // result: healthy longevity.
61     modifier antiEarlyWhale(uint256 _amountOfEthereum){
62         address _customerAddress = msg.sender;
63         
64         // are we still in the vulnerable phase?
65         // if so, enact anti early whale protocol 
66         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
67             require(
68                 // is the customer in the ambassador list?
69                 ambassadors_[_customerAddress] == true &&
70                 
71                 // does the customer purchase exceed the max ambassador quota?
72                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
73                 
74             );
75             
76             // updated the accumulated quota    
77             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
78         
79             // execute
80             _;
81         } else {
82             // in case the ether count drops low, the ambassador phase won't reinitiate
83             onlyAmbassadors = false;
84             _;    
85         }
86         
87     }
88     
89     
90     /*==============================
91     =            EVENTS            =
92     ==============================*/
93     event onTokenPurchase(
94         address indexed customerAddress,
95         uint256 incomingEthereum,
96         uint256 tokensMinted,
97         address indexed referredBy
98     );
99     
100     event onTokenSell(
101         address indexed customerAddress,
102         uint256 tokensBurned,
103         uint256 ethereumEarned
104     );
105     
106     event onReinvestment(
107         address indexed customerAddress,
108         uint256 ethereumReinvested,
109         uint256 tokensMinted
110     );
111     
112     event onWithdraw(
113         address indexed customerAddress,
114         uint256 ethereumWithdrawn
115     );
116     
117     // ERC20
118     event Transfer(
119         address indexed from,
120         address indexed to,
121         uint256 tokens
122     );
123     
124     
125     /*=====================================
126     =            CONFIGURABLES            =
127     =====================================*/
128     string public name = "ProofOfCraigGrant";
129     string public symbol = "POCG";
130     uint8 constant public decimals = 18;
131     uint8 constant internal dividendFee_ = 4; // Look, strong Math
132     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
133     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
134     uint256 constant internal magnitude = 2**64;
135     
136     // proof of stake (defaults at 100 tokens)
137     uint256 public stakingRequirement = 100e18;
138     
139     // ambassador program
140     mapping(address => bool) internal ambassadors_;
141     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
142     uint256 constant internal ambassadorQuota_ = 3 ether;
143     
144     
145     
146    /*================================
147     =            DATASETS            =
148     ================================*/
149     // amount of shares for each address (scaled number)
150     mapping(address => uint256) internal tokenBalanceLedger_;
151     mapping(address => uint256) internal referralBalance_;
152     mapping(address => int256) internal payoutsTo_;
153     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
154     uint256 internal tokenSupply_ = 0;
155     uint256 internal profitPerShare_;
156     
157     // administrator list (see above on what they can do)
158     mapping(address => bool) public administrators;
159     
160     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
161     bool public onlyAmbassadors = true;
162     
163 
164 
165     /*=======================================
166     =            PUBLIC FUNCTIONS            =
167     =======================================*/
168     /*
169     * -- APPLICATION ENTRY POINTS --  
170     */
171     function ProofOfCraigGrant()
172         public
173     {
174         // add administrators here
175         administrators[0x976b7B7E25e70C569915738d58450092bFAD5AF7] = true;
176     }
177      
178     /**
179      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
180      */
181     function buy(address _referredBy)
182         public
183         payable
184         returns(uint256)
185     {
186         purchaseTokens(msg.value, _referredBy);
187     }
188     
189     /**
190      * Fallback function to handle ethereum that was send straight to the contract
191      * Unfortunately we cannot use a referral address this way.
192      */
193     function()
194         payable
195         public
196     {
197         purchaseTokens(msg.value, 0x0);
198     }
199     
200     /**
201      * Converts all of caller's dividends to tokens.
202     */
203     function reinvest()
204         onlyStronghands()
205         public
206     {
207         // fetch dividends
208         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
209         
210         // pay out the dividends virtually
211         address _customerAddress = msg.sender;
212         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
213         
214         // retrieve ref. bonus
215         _dividends += referralBalance_[_customerAddress];
216         referralBalance_[_customerAddress] = 0;
217         
218         // dispatch a buy order with the virtualized "withdrawn dividends"
219         uint256 _tokens = purchaseTokens(_dividends, 0x0);
220         
221         // fire event
222         onReinvestment(_customerAddress, _dividends, _tokens);
223     }
224     
225     /**
226      * Alias of sell() and withdraw().
227      */
228     function exit()
229         public
230     {
231         // get token count for caller & sell them all
232         address _customerAddress = msg.sender;
233         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
234         if(_tokens > 0) sell(_tokens);
235         
236         // lambo delivery service
237         withdraw();
238     }
239 
240     /**
241      * Withdraws all of the callers earnings.
242      */
243     function withdraw()
244         onlyStronghands()
245         public
246     {
247         // setup data
248         address _customerAddress = msg.sender;
249         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
250         
251         // update dividend tracker
252         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
253         
254         // add ref. bonus
255         _dividends += referralBalance_[_customerAddress];
256         referralBalance_[_customerAddress] = 0;
257         
258         // lambo delivery service
259         _customerAddress.transfer(_dividends);
260         
261         // fire event
262         onWithdraw(_customerAddress, _dividends);
263     }
264     
265     /**
266      * Liquifies tokens to ethereum.
267      */
268     function sell(uint256 _amountOfTokens)
269         onlyBagholders()
270         public
271     {
272         // setup data
273         address _customerAddress = msg.sender;
274         // russian hackers BTFO
275         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
276         uint256 _tokens = _amountOfTokens;
277         uint256 _ethereum = tokensToEthereum_(_tokens);
278         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
279         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
280         
281         // burn the sold tokens
282         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
283         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
284         
285         // update dividends tracker
286         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
287         payoutsTo_[_customerAddress] -= _updatedPayouts;       
288         
289         // dividing by zero is a bad idea
290         if (tokenSupply_ > 0) {
291             // update the amount of dividends per token
292             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
293         }
294         
295         // fire event
296         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
297     }
298     
299     
300     /**
301      * Transfer tokens from the caller to a new holder.
302      * Remember, there's a 10% fee here as well.
303      */
304     function transfer(address _toAddress, uint256 _amountOfTokens)
305         onlyBagholders()
306         public
307         returns(bool)
308     {
309         // setup
310         address _customerAddress = msg.sender;
311         
312         // make sure we have the requested tokens
313         // also disables transfers until ambassador phase is over
314         // ( we dont want whale premines )
315         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
316         
317         // withdraw all outstanding dividends first
318         if(myDividends(true) > 0) withdraw();
319         
320         // liquify 10% of the tokens that are transfered
321         // these are dispersed to shareholders
322         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
323         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
324         uint256 _dividends = tokensToEthereum_(_tokenFee);
325   
326         // burn the fee tokens
327         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
328 
329         // exchange tokens
330         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
331         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
332         
333         // update dividend trackers
334         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
335         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
336         
337         // disperse dividends among holders
338         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
339         
340         // fire event
341         Transfer(_customerAddress, _toAddress, _taxedTokens);
342         
343         // ERC20
344         return true;
345        
346     }
347     
348     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
349     /**
350      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
351      */
352     function disableInitialStage()
353         onlyAdministrator()
354         public
355     {
356         onlyAmbassadors = false;
357     }
358     
359     /**
360      * In case one of us dies, we need to replace ourselves.
361      */
362     function setAdministrator(address _identifier, bool _status)
363         onlyAdministrator()
364         public
365     {
366         administrators[_identifier] = _status;
367     }
368     
369     /**
370      * Precautionary measures in case we need to adjust the masternode rate.
371      */
372     function setStakingRequirement(uint256 _amountOfTokens)
373         onlyAdministrator()
374         public
375     {
376         stakingRequirement = _amountOfTokens;
377     }
378     
379     /**
380      * If we want to rebrand, we can.
381      */
382     function setName(string _name)
383         onlyAdministrator()
384         public
385     {
386         name = _name;
387     }
388     
389     /**
390      * If we want to rebrand, we can.
391      */
392     function setSymbol(string _symbol)
393         onlyAdministrator()
394         public
395     {
396         symbol = _symbol;
397     }
398 
399     
400     /*----------  HELPERS AND CALCULATORS  ----------*/
401     /**
402      * Method to view the current Ethereum stored in the contract
403      * Example: totalEthereumBalance()
404      */
405     function totalEthereumBalance()
406         public
407         view
408         returns(uint)
409     {
410         return this.balance;
411     }
412     
413     /**
414      * Retrieve the total token supply.
415      */
416     function totalSupply()
417         public
418         view
419         returns(uint256)
420     {
421         return tokenSupply_;
422     }
423     
424     /**
425      * Retrieve the tokens owned by the caller.
426      */
427     function myTokens()
428         public
429         view
430         returns(uint256)
431     {
432         address _customerAddress = msg.sender;
433         return balanceOf(_customerAddress);
434     }
435     
436     /**
437      * Retrieve the dividends owned by the caller.
438      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
439      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
440      * But in the internal calculations, we want them separate. 
441      */ 
442     function myDividends(bool _includeReferralBonus) 
443         public 
444         view 
445         returns(uint256)
446     {
447         address _customerAddress = msg.sender;
448         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
449     }
450     
451     /**
452      * Retrieve the token balance of any single address.
453      */
454     function balanceOf(address _customerAddress)
455         view
456         public
457         returns(uint256)
458     {
459         return tokenBalanceLedger_[_customerAddress];
460     }
461     
462     /**
463      * Retrieve the dividend balance of any single address.
464      */
465     function dividendsOf(address _customerAddress)
466         view
467         public
468         returns(uint256)
469     {
470         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
471     }
472     
473     /**
474      * Return the buy price of 1 individual token.
475      */
476     function sellPrice() 
477         public 
478         view 
479         returns(uint256)
480     {
481         // our calculation relies on the token supply, so we need supply. Doh.
482         if(tokenSupply_ == 0){
483             return tokenPriceInitial_ - tokenPriceIncremental_;
484         } else {
485             uint256 _ethereum = tokensToEthereum_(1e18);
486             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
487             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
488             return _taxedEthereum;
489         }
490     }
491     
492     /**
493      * Return the sell price of 1 individual token.
494      */
495     function buyPrice() 
496         public 
497         view 
498         returns(uint256)
499     {
500         // our calculation relies on the token supply, so we need supply. Doh.
501         if(tokenSupply_ == 0){
502             return tokenPriceInitial_ + tokenPriceIncremental_;
503         } else {
504             uint256 _ethereum = tokensToEthereum_(1e18);
505             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
506             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
507             return _taxedEthereum;
508         }
509     }
510     
511     /**
512      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
513      */
514     function calculateTokensReceived(uint256 _ethereumToSpend) 
515         public 
516         view 
517         returns(uint256)
518     {
519         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
520         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
521         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
522         
523         return _amountOfTokens;
524     }
525     
526     /**
527      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
528      */
529     function calculateEthereumReceived(uint256 _tokensToSell) 
530         public 
531         view 
532         returns(uint256)
533     {
534         require(_tokensToSell <= tokenSupply_);
535         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
536         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
537         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
538         return _taxedEthereum;
539     }
540     
541     
542     /*==========================================
543     =            INTERNAL FUNCTIONS            =
544     ==========================================*/
545     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
546         antiEarlyWhale(_incomingEthereum)
547         internal
548         returns(uint256)
549     {
550         // data setup
551         address _customerAddress = msg.sender;
552         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
553         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
554         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
555         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
556         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
557         uint256 _fee = _dividends * magnitude;
558  
559         // no point in continuing execution if OP is a poorfag russian hacker
560         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
561         // (or hackers)
562         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
563         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
564         
565         // is the user referred by a masternode?
566         if(
567             // is this a referred purchase?
568             _referredBy != 0x0000000000000000000000000000000000000000 &&
569 
570             // no cheating!
571             _referredBy != _customerAddress &&
572             
573             // does the referrer have at least X whole tokens?
574             // i.e is the referrer a godly chad masternode
575             tokenBalanceLedger_[_referredBy] >= stakingRequirement
576         ){
577             // wealth redistribution
578             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
579         } else {
580             // no ref purchase
581             // add the referral bonus back to the global dividends cake
582             _dividends = SafeMath.add(_dividends, _referralBonus);
583             _fee = _dividends * magnitude;
584         }
585         
586         // we can't give people infinite ethereum
587         if(tokenSupply_ > 0){
588             
589             // add tokens to the pool
590             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
591  
592             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
593             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
594             
595             // calculate the amount of tokens the customer receives over his purchase 
596             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
597         
598         } else {
599             // add tokens to the pool
600             tokenSupply_ = _amountOfTokens;
601         }
602         
603         // update circulating supply & the ledger address for the customer
604         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
605         
606         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
607         //really i know you think you do but you don't
608         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
609         payoutsTo_[_customerAddress] += _updatedPayouts;
610         
611         // fire event
612         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
613         
614         return _amountOfTokens;
615     }
616 
617     /**
618      * Calculate Token price based on an amount of incoming ethereum
619      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
620      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
621      */
622     function ethereumToTokens_(uint256 _ethereum)
623         internal
624         view
625         returns(uint256)
626     {
627         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
628         uint256 _tokensReceived = 
629          (
630             (
631                 // underflow attempts BTFO
632                 SafeMath.sub(
633                     (sqrt
634                         (
635                             (_tokenPriceInitial**2)
636                             +
637                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
638                             +
639                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
640                             +
641                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
642                         )
643                     ), _tokenPriceInitial
644                 )
645             )/(tokenPriceIncremental_)
646         )-(tokenSupply_)
647         ;
648   
649         return _tokensReceived;
650     }
651     
652     /**
653      * Calculate token sell value.
654      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
655      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
656      */
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
682     //This is where all your gas goes, sorry
683     //Not sorry, you probably only paid 1 gwei
684     function sqrt(uint x) internal pure returns (uint y) {
685         uint z = (x + 1) / 2;
686         y = x;
687         while (z < y) {
688             y = z;
689             z = (x / z + z) / 2;
690         }
691     }
692 }
693 
694 /**
695  * @title SafeMath
696  * @dev Math operations with safety checks that throw on error
697  */
698 library SafeMath {
699 
700     /**
701     * @dev Multiplies two numbers, throws on overflow.
702     */
703     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
704         if (a == 0) {
705             return 0;
706         }
707         uint256 c = a * b;
708         assert(c / a == b);
709         return c;
710     }
711 
712     /**
713     * @dev Integer division of two numbers, truncating the quotient.
714     */
715     function div(uint256 a, uint256 b) internal pure returns (uint256) {
716         // assert(b > 0); // Solidity automatically throws when dividing by 0
717         uint256 c = a / b;
718         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
719         return c;
720     }
721 
722     /**
723     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
724     */
725     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
726         assert(b <= a);
727         return a - b;
728     }
729 
730     /**
731     * @dev Adds two numbers, throws on overflow.
732     */
733     function add(uint256 a, uint256 b) internal pure returns (uint256) {
734         uint256 c = a + b;
735         assert(c >= a);
736         return c;
737     }
738 }