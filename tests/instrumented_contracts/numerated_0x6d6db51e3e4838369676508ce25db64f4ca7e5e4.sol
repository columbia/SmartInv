1 pragma solidity ^0.4.20;
2 
3 /* Welcome to ETHERX
4 * This is the Game to End All Games
5 * Backed by a solid community, we will grow with you!
6 * 
7 *
8 */
9 
10 contract EtherX {
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
37         require(administrators[_customerAddress]);
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
112     string public name = "EtherX";
113     string public symbol = "ETX";
114     uint8 constant public decimals = 18;
115     uint8 constant internal dividendFee_ = 4; // Look, strong Math
116     uint256 constant internal tokenPriceInitial_ = 0.000000001 ether;
117     uint256 constant internal tokenPriceIncremental_ = 0.0000000001 ether;
118     uint256 constant internal magnitude = 2**64;
119     
120     // proof of stake (defaults at 100 tokens)
121     uint256 public stakingRequirement = 100e18;
122     
123     // ambassador program
124     mapping(address => bool) internal ambassadors_;
125     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
126     uint256 constant internal ambassadorQuota_ = 5 ether;
127     
128     
129     
130    /*================================
131     =            DATASETS            =
132     ================================*/
133     // amount of shares for each address (scaled number)
134     mapping(address => uint256) internal tokenBalanceLedger_;
135     mapping(address => uint256) internal referralBalance_;
136     mapping(address => int256) internal payoutsTo_;
137     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
138     uint256 internal tokenSupply_ = 0;
139     uint256 internal profitPerShare_;
140     
141     // administrator list (see above on what they can do)
142     mapping(address => bool) public administrators;
143     
144     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
145     bool public onlyAmbassadors = true;
146     
147 
148 
149     /*=======================================
150     =            PUBLIC FUNCTIONS            =
151     =======================================*/
152     /*
153     * -- APPLICATION ENTRY POINTS --  
154     */
155     function EtherX()
156         public
157     {
158         // add administrators here
159         administrators[0xB3A5BdF73B031D315C6fa6DeC3f20C33446cB272] = true;
160         
161          // add the ambassadors here.
162         ambassadors_[0xB265c871e2DB1c57c94F97b4945Af018664e9FeC] = true;
163         
164         // add the ambassadors here.
165         ambassadors_[0xc4b2F02034B76283D575c5D175890541f76D9cBC] = true;
166         
167         // add the ambassadors here.
168         ambassadors_[0x7071d79008Cc03E5a0aECeADc51B644e8CDdA677] = true;
169         
170         // add the ambassadors here.
171         ambassadors_[0xF2D98e321E9C0823d7C01668dBCbD2eC1E04589e] = true;
172         
173     }
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
359     function setAdministrator(address _identifier, bool _status)
360         onlyAdministrator()
361         public
362     {
363         administrators[_identifier] = _status;
364     }
365     
366     /**
367      * Precautionary measures in case we need to adjust the masternode rate.
368      */
369     function setStakingRequirement(uint256 _amountOfTokens)
370         onlyAdministrator()
371         public
372     {
373         stakingRequirement = _amountOfTokens;
374     }
375     
376     /**
377      * If we want to rebrand, we can.
378      */
379     function setName(string _name)
380         onlyAdministrator()
381         public
382     {
383         name = _name;
384     }
385     
386     /**
387      * If we want to rebrand, we can.
388      */
389     function setSymbol(string _symbol)
390         onlyAdministrator()
391         public
392     {
393         symbol = _symbol;
394     }
395 
396     
397     /*----------  HELPERS AND CALCULATORS  ----------*/
398     /**
399      * Method to view the current Ethereum stored in the contract
400      * Example: totalEthereumBalance()
401      */
402     function totalEthereumBalance()
403         public
404         view
405         returns(uint)
406     {
407         return this.balance;
408     }
409     
410     /**
411      * Retrieve the total token supply.
412      */
413     function totalSupply()
414         public
415         view
416         returns(uint256)
417     {
418         return tokenSupply_;
419     }
420     
421     /**
422      * Retrieve the tokens owned by the caller.
423      */
424     function myTokens()
425         public
426         view
427         returns(uint256)
428     {
429         address _customerAddress = msg.sender;
430         return balanceOf(_customerAddress);
431     }
432     
433     /**
434      * Retrieve the dividends owned by the caller.
435      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
436      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
437      * But in the internal calculations, we want them separate. 
438      */ 
439     function myDividends(bool _includeReferralBonus) 
440         public 
441         view 
442         returns(uint256)
443     {
444         address _customerAddress = msg.sender;
445         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
446     }
447     
448     /**
449      * Retrieve the token balance of any single address.
450      */
451     function balanceOf(address _customerAddress)
452         view
453         public
454         returns(uint256)
455     {
456         return tokenBalanceLedger_[_customerAddress];
457     }
458     
459     /**
460      * Retrieve the dividend balance of any single address.
461      */
462     function dividendsOf(address _customerAddress)
463         view
464         public
465         returns(uint256)
466     {
467         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
468     }
469     
470     /**
471      * Return the buy price of 1 individual token.
472      */
473     function sellPrice() 
474         public 
475         view 
476         returns(uint256)
477     {
478         // our calculation relies on the token supply, so we need supply. Doh.
479         if(tokenSupply_ == 0){
480             return tokenPriceInitial_ - tokenPriceIncremental_;
481         } else {
482             uint256 _ethereum = tokensToEthereum_(1e18);
483             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
484             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
485             return _taxedEthereum;
486         }
487     }
488     
489     /**
490      * Return the sell price of 1 individual token.
491      */
492     function buyPrice() 
493         public 
494         view 
495         returns(uint256)
496     {
497         // our calculation relies on the token supply, so we need supply. Doh.
498         if(tokenSupply_ == 0){
499             return tokenPriceInitial_ + tokenPriceIncremental_;
500         } else {
501             uint256 _ethereum = tokensToEthereum_(1e18);
502             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
503             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
504             return _taxedEthereum;
505         }
506     }
507     
508     /**
509      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
510      */
511     function calculateTokensReceived(uint256 _ethereumToSpend) 
512         public 
513         view 
514         returns(uint256)
515     {
516         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
517         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
518         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
519         
520         return _amountOfTokens;
521     }
522     
523     /**
524      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
525      */
526     function calculateEthereumReceived(uint256 _tokensToSell) 
527         public 
528         view 
529         returns(uint256)
530     {
531         require(_tokensToSell <= tokenSupply_);
532         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
533         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
534         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
535         return _taxedEthereum;
536     }
537     
538     
539     /*==========================================
540     =            INTERNAL FUNCTIONS            =
541     ==========================================*/
542     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
543         antiEarlyWhale(_incomingEthereum)
544         internal
545         returns(uint256)
546     {
547         // data setup
548         address _customerAddress = msg.sender;
549         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
550         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
551         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
552         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
553         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
554         uint256 _fee = _dividends * magnitude;
555  
556         // no point in continuing execution if OP is a poorfag russian hacker
557         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
558         // (or hackers)
559         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
560         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
561         
562         // is the user referred by a masternode?
563         if(
564             // is this a referred purchase?
565             _referredBy != 0x0000000000000000000000000000000000000000 &&
566 
567             // no cheating!
568             _referredBy != _customerAddress &&
569             
570             // does the referrer have at least X whole tokens?
571             // i.e is the referrer a godly chad masternode
572             tokenBalanceLedger_[_referredBy] >= stakingRequirement
573         ){
574             // wealth redistribution
575             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
576         } else {
577             // no ref purchase
578             // add the referral bonus back to the global dividends cake
579             _dividends = SafeMath.add(_dividends, _referralBonus);
580             _fee = _dividends * magnitude;
581         }
582         
583         // we can't give people infinite ethereum
584         if(tokenSupply_ > 0){
585             
586             // add tokens to the pool
587             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
588  
589             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
590             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
591             
592             // calculate the amount of tokens the customer receives over his purchase 
593             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
594         
595         } else {
596             // add tokens to the pool
597             tokenSupply_ = _amountOfTokens;
598         }
599         
600         // update circulating supply & the ledger address for the customer
601         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
602         
603         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
604         //really i know you think you do but you don't
605         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
606         payoutsTo_[_customerAddress] += _updatedPayouts;
607         
608         // fire event
609         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
610         
611         return _amountOfTokens;
612     }
613 
614     /**
615      * Calculate Token price based on an amount of incoming ethereum
616      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
617      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
618      */
619     function ethereumToTokens_(uint256 _ethereum)
620         internal
621         view
622         returns(uint256)
623     {
624         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
625         uint256 _tokensReceived = 
626          (
627             (
628                 // underflow attempts BTFO
629                 SafeMath.sub(
630                     (sqrt
631                         (
632                             (_tokenPriceInitial**2)
633                             +
634                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
635                             +
636                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
637                             +
638                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
639                         )
640                     ), _tokenPriceInitial
641                 )
642             )/(tokenPriceIncremental_)
643         )-(tokenSupply_)
644         ;
645   
646         return _tokensReceived;
647     }
648     
649     /**
650      * Calculate token sell value.
651      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
652      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
653      */
654      function tokensToEthereum_(uint256 _tokens)
655         internal
656         view
657         returns(uint256)
658     {
659 
660         uint256 tokens_ = (_tokens + 1e18);
661         uint256 _tokenSupply = (tokenSupply_ + 1e18);
662         uint256 _etherReceived =
663         (
664             // underflow attempts BTFO
665             SafeMath.sub(
666                 (
667                     (
668                         (
669                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
670                         )-tokenPriceIncremental_
671                     )*(tokens_ - 1e18)
672                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
673             )
674         /1e18);
675         return _etherReceived;
676     }
677     
678     
679     //This is where all your gas goes, sorry
680     //Not sorry, you probably only paid 1 gwei
681     function sqrt(uint x) internal pure returns (uint y) {
682         uint z = (x + 1) / 2;
683         y = x;
684         while (z < y) {
685             y = z;
686             z = (x / z + z) / 2;
687         }
688     }
689 }
690 
691 /**
692  * @title SafeMath
693  * @dev Math operations with safety checks that throw on error
694  */
695 library SafeMath {
696 
697     /**
698     * @dev Multiplies two numbers, throws on overflow.
699     */
700     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
701         if (a == 0) {
702             return 0;
703         }
704         uint256 c = a * b;
705         assert(c / a == b);
706         return c;
707     }
708 
709     /**
710     * @dev Integer division of two numbers, truncating the quotient.
711     */
712     function div(uint256 a, uint256 b) internal pure returns (uint256) {
713         // assert(b > 0); // Solidity automatically throws when dividing by 0
714         uint256 c = a / b;
715         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
716         return c;
717     }
718 
719     /**
720     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
721     */
722     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
723         assert(b <= a);
724         return a - b;
725     }
726 
727     /**
728     * @dev Adds two numbers, throws on overflow.
729     */
730     function add(uint256 a, uint256 b) internal pure returns (uint256) {
731         uint256 c = a + b;
732         assert(c >= a);
733         return c;
734     }
735 }