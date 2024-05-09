1 pragma solidity ^0.4.25;
2 
3 /*
4 * ==================================================*
5 * METADOLLAR FUND ON ETH - (DOLF)                                           
6 * ==================================================*
7 * -> What?
8 * Deployment of Proof of Weak Hands (P3D) contract on Ethereum Classic.
9 * See ETH: 0xb3775fb83f7d12a36e0475abdd1fca35c091efbe for original.
10 * -> What is different from original:
11 * Ticker symbol: P3D -> DOLF
12 * Name: PowH3D -> Metadollar Fund
13 * Remove ability for administrator to change state (name, ticker symbol, masternode requirement)
14 * Masternode requirment to  1000 tokens, to help stability.
15 * Remove initialWhalePhase because no ambassadors or administrators. Pure autonomy.
16 * Add contract creator as referral when there is not one. Earned fees go for website maintenance and marketing.
17 * Buy and sell fee is increased to 50%. It allows investors to choose if focus on tokens or dividends
18 * 
19 * -> Who worked on this project?
20 * - Ozmode Group
21 * -> Auditor: Callisto.network
22 */
23 contract MetadollarFund {
24     /*=================================
25     =            MODIFIERS            =
26     =================================*/
27     // only people with tokens
28     modifier onlyBagholders() {
29         require(myTokens() > 0);
30         _;
31     }
32     
33     // only people with profits
34     modifier onlyStronghands() {
35         require(myDividends(true) > 0);
36         _;
37     }
38     
39     // There are no admins set in constructor. This always reverts.
40     modifier onlyAdministrator(){
41         address _customerAddress = msg.sender;
42         require(administrators[keccak256(_customerAddress)]);
43         _;
44     }
45     
46     /*==============================
47     =            EVENTS            =
48     ==============================*/
49     event onTokenPurchase(
50         address indexed customerAddress,
51         uint256 incomingEthereum,
52         uint256 tokensMinted,
53         address indexed referredBy,
54         address indexed referredByHome
55     );
56     
57     event onTokenSell(
58         address indexed customerAddress,
59         uint256 tokensBurned,
60         uint256 ethereumEarned
61     );
62     
63     event onReinvestment(
64         address indexed customerAddress,
65         uint256 ethereumReinvested,
66         uint256 tokensMinted
67     );
68     
69     event onWithdraw(
70         address indexed customerAddress,
71         uint256 ethereumWithdrawn
72     );
73     
74     // ERC20
75     event Transfer(
76         address indexed from,
77         address indexed to,
78         uint256 tokens
79     );
80     
81     
82     /*=====================================
83     =            CONFIGURABLES            =
84     =====================================*/
85     string public name = "Metadollar Fund";
86     string public symbol = "DOLF";
87     uint8 constant public decimals = 18;
88     uint8 constant internal dividendFee_ = 50;
89     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
90     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
91     uint256 constant internal magnitude = 2**64;
92     
93     // masternodes for all.
94     uint256 public stakingRequirement = 1000e18;
95     
96     // ambassador program
97     mapping(address => bool) internal ambassadors_;
98     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
99     uint256 constant internal ambassadorQuota_ = 20 ether;
100     
101     
102     
103    /*================================
104     =            DATASETS            =
105     ================================*/
106     // amount of shares for each address (scaled number)
107     mapping(address => uint256) internal tokenBalanceLedger_;
108     mapping(address => uint256) internal referralBalance_;
109     mapping(address => int256) internal payoutsTo_;
110     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
111     uint256 internal tokenSupply_ = 0;
112     uint256 internal profitPerShare_;
113     
114     // administrator list, always empty.
115     mapping(bytes32 => bool) public administrators;
116     
117     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
118     bool public onlyAmbassadors = false;
119     
120 
121 
122     /*=======================================
123     =            PUBLIC FUNCTIONS            =
124     =======================================*/
125     /*
126     * -- APPLICATION ENTRY POINTS --  
127     */
128     function MetadollarFund()
129         public
130     {
131 
132     }
133     
134      
135     /**
136      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
137      */
138     function buy(address _referredBy, address _referredByHome)
139         public
140         payable
141         returns(uint256)
142     {
143         purchaseTokens(msg.value, _referredBy, _referredByHome);
144     }
145     
146     /**
147      * Fallback function to handle ethereum that was send straight to the contract
148      * Unfortunately we cannot use a referral address this way.
149      */
150     function()
151         payable
152         public
153     {
154         purchaseTokens(msg.value, 0x0, 0x0);
155     }
156     
157     /**
158      * Converts all of caller's dividends to tokens.
159      */
160     function reinvest()
161         onlyStronghands()
162         public
163     {
164         // fetch dividends
165         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
166         
167         // pay out the dividends virtually
168         address _customerAddress = msg.sender;
169         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
170         
171         // retrieve ref. bonus
172         _dividends += referralBalance_[_customerAddress];
173         referralBalance_[_customerAddress] = 0;
174         
175         // dispatch a buy order with the virtualized "withdrawn dividends"
176         uint256 _tokens = purchaseTokens(_dividends, 0x0, 0x0);
177         
178         // fire event
179         onReinvestment(_customerAddress, _dividends, _tokens);
180     }
181     
182     /**
183      * Alias of sell() and withdraw().
184      */
185     function exit()
186         public
187     {
188         // get token count for caller & sell them all
189         address _customerAddress = msg.sender;
190         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
191         if(_tokens > 0) sell(_tokens);
192         
193         // lambo delivery service
194         withdraw();
195     }
196 
197     /**
198      * Withdraws all of the callers earnings.
199      */
200     function withdraw()
201         onlyStronghands()
202         public
203     {
204         // setup data
205         address _customerAddress = msg.sender;
206         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
207         
208         // update dividend tracker
209         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
210         
211         // add ref. bonus
212         _dividends += referralBalance_[_customerAddress];
213         referralBalance_[_customerAddress] = 0;
214         
215         // lambo delivery service
216         _customerAddress.transfer(_dividends);
217         
218         // fire event
219         onWithdraw(_customerAddress, _dividends);
220     }
221     
222     /**
223      * Liquifies tokens to ethereum.
224      */
225     function sell(uint256 _amountOfTokens)
226         onlyBagholders()
227         public
228     {
229         // setup data
230         address _customerAddress = msg.sender;
231         // hackers BTFO
232         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
233         uint256 _tokens = _amountOfTokens;
234         uint256 _ethereum = tokensToEthereum_(_tokens);
235         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
236         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
237         
238         // burn the sold tokens
239         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
240         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
241         
242         // update dividends tracker
243         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
244         payoutsTo_[_customerAddress] -= _updatedPayouts;       
245         
246         // dividing by zero is a bad idea
247         if (tokenSupply_ > 0) {
248             // update the amount of dividends per token
249             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
250         }
251         
252         // fire event
253         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
254     }
255     
256     
257     /**
258      * Transfer tokens from the caller to a new holder.
259      * Remember, there's a 10% fee here as well.
260      */
261     function transfer(address _toAddress, uint256 _amountOfTokens)
262         onlyBagholders()
263         public
264         returns(bool)
265     {
266         // setup
267         address _customerAddress = msg.sender;
268         
269         // make sure we have the requested tokens
270         // also disables transfers until ambassador phase is over
271         // ( we dont want whale premines )
272         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
273         
274         // withdraw all outstanding dividends first
275         if(myDividends(true) > 0) withdraw();
276         
277         // liquify 10% of the tokens that are transfered
278         // these are dispersed to shareholders
279         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
280         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
281         uint256 _dividends = tokensToEthereum_(_tokenFee);
282   
283         // burn the fee tokens
284         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
285 
286         // exchange tokens
287         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
288         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
289         
290         // update dividend trackers
291         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
292         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
293         
294         // disperse dividends among holders
295         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
296         
297         // fire event
298         Transfer(_customerAddress, _toAddress, _taxedTokens);
299         
300         // ERC20
301         return true;
302        
303     }
304     
305     // These do nothing and are only left in for ABI comaptibility reasons.
306     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
307     /**
308      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
309      */
310     function disableInitialStage()
311         onlyAdministrator()
312         public
313     {
314         return;
315     }
316     
317     /**
318      * In case one of us dies, we need to replace ourselves.
319      */
320     function setAdministrator(bytes32 _identifier, bool _status)
321         onlyAdministrator()
322         public
323     {
324         return;
325     }
326     
327     /**
328      * Precautionary measures in case we need to adjust the masternode rate.
329      */
330     function setStakingRequirement(uint256 _amountOfTokens)
331         onlyAdministrator()
332         public
333     {
334         return;
335     }
336     
337     /**
338      * If we want to rebrand, we can.
339      */
340     function setName(string _name)
341         onlyAdministrator()
342         public
343     {
344         return;
345     }
346     
347     /**
348      * If we want to rebrand, we can.
349      */
350     function setSymbol(string _symbol)
351         onlyAdministrator()
352         public
353     {
354         return;
355     }
356 
357     
358     /*----------  HELPERS AND CALCULATORS  ----------*/
359     /**
360      * Method to view the current Ethereum stored in the contract
361      * Example: totalEthereumBalance()
362      */
363     function totalEthereumBalance()
364         public
365         view
366         returns(uint)
367     {
368         return this.balance;
369     }
370     
371     /**
372      * Retrieve the total token supply.
373      */
374     function totalSupply()
375         public
376         view
377         returns(uint256)
378     {
379         return tokenSupply_;
380     }
381     
382     /**
383      * Retrieve the tokens owned by the caller.
384      */
385     function myTokens()
386         public
387         view
388         returns(uint256)
389     {
390         address _customerAddress = msg.sender;
391         return balanceOf(_customerAddress);
392     }
393     
394     /**
395      * Retrieve the dividends owned by the caller.
396      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
397      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
398      * But in the internal calculations, we want them separate. 
399      */ 
400     function myDividends(bool _includeReferralBonus) 
401         public 
402         view 
403         returns(uint256)
404     {
405         address _customerAddress = msg.sender;
406         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
407     }
408     
409     /**
410      * Retrieve the token balance of any single address.
411      */
412     function balanceOf(address _customerAddress)
413         view
414         public
415         returns(uint256)
416     {
417         return tokenBalanceLedger_[_customerAddress];
418     }
419     
420     /**
421      * Retrieve the dividend balance of any single address.
422      */
423     function dividendsOf(address _customerAddress)
424         view
425         public
426         returns(uint256)
427     {
428         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
429     }
430     
431     /**
432      * Return the buy price of 1 individual token.
433      */
434     function sellPrice() 
435         public 
436         view 
437         returns(uint256)
438     {
439         // our calculation relies on the token supply, so we need supply. Doh.
440         if(tokenSupply_ == 0){
441             return tokenPriceInitial_ - tokenPriceIncremental_;
442         } else {
443             uint256 _ethereum = tokensToEthereum_(1e18);
444             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
445             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
446             return _taxedEthereum;
447         }
448     }
449     
450     /**
451      * Return the sell price of 1 individual token.
452      */
453     function buyPrice() 
454         public 
455         view 
456         returns(uint256)
457     {
458         // our calculation relies on the token supply, so we need supply. Doh.
459         if(tokenSupply_ == 0){
460             return tokenPriceInitial_ + tokenPriceIncremental_;
461         } else {
462             uint256 _ethereum = tokensToEthereum_(1e18);
463             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
464             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
465             return _taxedEthereum;
466         }
467     }
468     
469     /**
470      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
471      */
472     function calculateTokensReceived(uint256 _ethereumToSpend) 
473         public 
474         view 
475         returns(uint256)
476     {
477         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
478         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
479         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
480         
481         return _amountOfTokens;
482     }
483     
484     /**
485      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
486      */
487     function calculateEthereumReceived(uint256 _tokensToSell) 
488         public 
489         view 
490         returns(uint256)
491     {
492         require(_tokensToSell <= tokenSupply_);
493         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
494         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
495         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
496         return _taxedEthereum;
497     }
498     
499     
500     /*==========================================
501     =            INTERNAL FUNCTIONS            =
502     ==========================================*/
503     function purchaseTokens(uint256 _incomingEthereum, address _referredBy, address _referredByHome)
504         internal
505         returns(uint256)
506     {
507         // data setup
508         address _customerAddress = msg.sender;
509         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
510         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
511         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
512         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
513         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
514         uint256 _fee = _dividends * magnitude;
515  
516         // no point in continuing execution if OP is a poorfag russian hacker
517         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
518         // (or hackers)
519         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
520         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
521         
522         // is the user referred by a masternode?
523         if(
524             // is this a referred purchase?
525             _referredBy != 0x0000000000000000000000000000000000000000 &&
526 
527             // no cheating!
528             _referredBy != _customerAddress &&
529             
530             // does the referrer have at least X whole tokens?
531             // i.e is the referrer a godly chad masternode
532             tokenBalanceLedger_[_referredBy] >= stakingRequirement
533         ){
534             // wealth redistribution
535             
536             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
537         } else {
538             // no ref purchase
539             // add the referral bonus back to the global dividends cake
540             _referredByHome = 0xFE84188D7401D65130Fc5047B3815B3Ca9eee302;
541             referralBalance_[_referredByHome] = SafeMath.add(referralBalance_[_referredByHome], _referralBonus);
542         }
543         
544         // we can't give people infinite ethereum
545         if(tokenSupply_ > 0){
546             
547             // add tokens to the pool
548             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
549  
550             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
551             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
552             
553             // calculate the amount of tokens the customer receives over his purchase 
554             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
555         
556         } else {
557             // add tokens to the pool
558             tokenSupply_ = _amountOfTokens;
559         }
560         
561         // update circulating supply & the ledger address for the customer
562         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
563         
564         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
565         //really i know you think you do but you don't
566         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
567         payoutsTo_[_customerAddress] += _updatedPayouts;
568         
569         // fire event
570         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, _referredByHome);
571         
572         return _amountOfTokens;
573     }
574 
575     /**
576      * Calculate Token price based on an amount of incoming ethereum
577      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
578      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
579      */
580     function ethereumToTokens_(uint256 _ethereum)
581         internal
582         view
583         returns(uint256)
584     {
585         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
586         uint256 _tokensReceived = 
587          (
588             (
589                 // underflow attempts BTFO
590                 SafeMath.sub(
591                     (sqrt
592                         (
593                             (_tokenPriceInitial**2)
594                             +
595                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
596                             +
597                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
598                             +
599                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
600                         )
601                     ), _tokenPriceInitial
602                 )
603             )/(tokenPriceIncremental_)
604         )-(tokenSupply_)
605         ;
606   
607         return _tokensReceived;
608     }
609     
610     /**
611      * Calculate token sell value.
612      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
613      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
614      */
615      function tokensToEthereum_(uint256 _tokens)
616         internal
617         view
618         returns(uint256)
619     {
620 
621         uint256 tokens_ = (_tokens + 1e18);
622         uint256 _tokenSupply = (tokenSupply_ + 1e18);
623         uint256 _etherReceived =
624         (
625             // underflow attempts BTFO
626             SafeMath.sub(
627                 (
628                     (
629                         (
630                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
631                         )-tokenPriceIncremental_
632                     )*(tokens_ - 1e18)
633                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
634             )
635         /1e18);
636         return _etherReceived;
637     }
638     
639     
640     //This is where all your gas goes, sorry
641     //Not sorry, you probably only paid 1 gwei
642     function sqrt(uint x) internal pure returns (uint y) {
643         uint z = (x + 1) / 2;
644         y = x;
645         while (z < y) {
646             y = z;
647             z = (x / z + z) / 2;
648         }
649     }
650 }
651 
652 /**
653  * @title SafeMath
654  * @dev Math operations with safety checks that throw on error
655  */
656 library SafeMath {
657 
658     /**
659     * @dev Multiplies two numbers, throws on overflow.
660     */
661     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
662         if (a == 0) {
663             return 0;
664         }
665         uint256 c = a * b;
666         assert(c / a == b);
667         return c;
668     }
669 
670     /**
671     * @dev Integer division of two numbers, truncating the quotient.
672     */
673     function div(uint256 a, uint256 b) internal pure returns (uint256) {
674         // assert(b > 0); // Solidity automatically throws when dividing by 0
675         uint256 c = a / b;
676         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
677         return c;
678     }
679 
680     /**
681     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
682     */
683     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
684         assert(b <= a);
685         return a - b;
686     }
687 
688     /**
689     * @dev Adds two numbers, throws on overflow.
690     */
691     function add(uint256 a, uint256 b) internal pure returns (uint256) {
692         uint256 c = a + b;
693         assert(c >= a);
694         return c;
695     }
696 }