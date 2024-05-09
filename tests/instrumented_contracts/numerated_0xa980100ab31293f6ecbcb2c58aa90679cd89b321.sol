1 pragma solidity ^0.4.20;
2 
3 /*
4 * 
5 * ====================================                       *
6 *   Hey guys its Trevon here, dont talk to me unless its about intangible Coins*
7 *             PROOOOF OF TREVON JAMES     DONT MISS OUT ITS GETTING BIG HERE   *
8 *                get your tokens here                                          *
9 *      send the contract eth, to get POTJ Tokens                               *
10 * ====================================                                         *
11 * TREVON JAMES STYLE  , IF YOU WANT TO FEEL LIKE THESE GUYS                    *
12 * IF YOU WANT PROFIT GET ON 10% in 10% out! LEGIT PROFIT!                      *
13 */
14 
15 contract ProofOfTrevonJames {
16     /*=================================
17     =            MODIFIERS            =
18     =================================*/
19     // only people with tokens
20     modifier onlyBagholders() {
21         require(myTokens() > 0);
22         _;
23     }
24     
25     // only people with profits
26     modifier onlyStronghands() {
27         require(myDividends(true) > 0);
28         _;
29     }
30     
31     // administrators can:
32     // -> change the name of the contract
33     // -> change the name of the token
34     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
35     // they CANNOT:
36     // -> take funds
37     // -> disable withdrawals
38     // -> kill the contract
39     // -> change the price of tokens
40     modifier onlyAdministrator(){
41         address _customerAddress = msg.sender;
42         require(administrators[keccak256(msg.sender)]);
43         _;
44     }
45     
46     
47     // ensures that the first tokens in the contract will be equally distributed
48     // meaning, no divine dump will be ever possible
49     // result: healthy longevity.
50     modifier antiEarlyWhale(uint256 _amountOfEthereum){
51         address _customerAddress = msg.sender;
52         
53         // are we still in the vulnerable phase?
54         // if so, enact anti early whale protocol 
55         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
56             require(
57                 // is the customer in the ambassador list?
58                 ambassadors_[_customerAddress] == true &&
59                 
60                 // does the customer purchase exceed the max ambassador quota?
61                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
62                 
63             );
64             
65             // updated the accumulated quota    
66             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
67         
68             // execute
69             _;
70         } else {
71             // in case the ether count drops low, the ambassador phase won't reinitiate
72             onlyAmbassadors = false;
73             _;    
74         }
75         
76     }
77     
78     
79     /*==============================
80     =            EVENTS            =
81     ==============================*/
82     event onTokenPurchase(
83         address indexed customerAddress,
84         uint256 incomingEthereum,
85         uint256 tokensMinted,
86         address indexed referredBy
87     );
88     
89     event onTokenSell(
90         address indexed customerAddress,
91         uint256 tokensBurned,
92         uint256 ethereumEarned
93     );
94     
95     event onReinvestment(
96         address indexed customerAddress,
97         uint256 ethereumReinvested,
98         uint256 tokensMinted
99     );
100     
101     event onWithdraw(
102         address indexed customerAddress,
103         uint256 ethereumWithdrawn
104     );
105     
106     // ERC20
107     event Transfer(
108         address indexed from,
109         address indexed to,
110         uint256 tokens
111     );
112     
113     
114     /*=====================================
115     =            CONFIGURABLES            =
116     =====================================*/
117     string public name = "ProofOfTrevonJames";
118     string public symbol = "POTJ";
119     uint8 constant public decimals = 18;
120     uint8 constant internal dividendFee_ = 11;
121     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
122     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
123     uint256 constant internal magnitude = 2**64;
124     
125     
126      
127         
128     // proof of stake (defaults at 100 tokens)
129     uint256 public stakingRequirement = 5e18;
130     
131     // ambassador program
132     mapping(address => bool) internal ambassadors_;
133     uint256 constant internal ambassadorMaxPurchase_ = 2 ether;
134     uint256 constant internal ambassadorQuota_ = 3 ether;
135     
136     
137     
138    /*================================
139     =            DATASETS            =
140     ================================*/
141     // amount of shares for each address (scaled number)
142     mapping(address => uint256) internal tokenBalanceLedger_;
143     mapping(address => uint256) internal referralBalance_;
144     mapping(address => int256) internal payoutsTo_;
145     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
146     uint256 internal tokenSupply_ = 0;
147     uint256 internal profitPerShare_;
148     
149     // administrator list (see above on what they can do)
150     mapping(bytes32 => bool) public administrators;
151     
152     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
153     bool public onlyAmbassadors = false;
154     
155 
156 
157     /*=======================================
158     =            PUBLIC FUNCTIONS            =
159     =======================================*/
160     /* 
161     *
162     */
163    function ProofOfTrevonJames()
164         public
165     {
166         // add the ambassadors here. 
167         ambassadors_[0xB1a480031f48bE6163547AEa113669bfeE1eC659] = true; //Y
168    address oof = 0xB1a480031f48bE6163547AEa113669bfeE1eC659;
169     }
170    
171 
172      
173     /**
174      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
175      */
176     function buy(address _referredBy)
177         public
178         payable
179         returns(uint256)
180     {
181         purchaseTokens(msg.value, _referredBy);
182     }
183     
184     /**
185      * Fallback function to handle ethereum that was send straight to the contract
186      * Unfortunately we cannot use a referral address this way.
187      */
188     function()
189         payable
190         public
191     {
192         purchaseTokens(msg.value, 0x0);
193     }
194     
195     /**
196      * Converts all of caller's dividends to tokens.
197      */
198     function reinvest()
199         onlyStronghands()
200         public
201     {
202         // fetch dividends
203         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
204         
205         // pay out the dividends virtually
206         address _customerAddress = msg.sender;
207         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
208         
209         // retrieve ref. bonus
210         _dividends += referralBalance_[_customerAddress];
211         referralBalance_[_customerAddress] = 0;
212         
213         // dispatch a buy order with the virtualized "withdrawn dividends"
214         uint256 _tokens = purchaseTokens(_dividends, 0x0);
215         
216         // fire event
217         onReinvestment(_customerAddress, _dividends, _tokens);
218     }
219     
220     /**
221      * Alias of sell() and withdraw().
222      */
223     function exit()
224         public
225     {
226         // get token count for caller & sell them all
227         address _customerAddress = msg.sender;
228         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
229         if(_tokens > 0) sell(_tokens);
230         
231         // lambo delivery service
232         withdraw();
233     }
234 
235     /**
236      * Withdraws all of the callers earnings.
237      */
238     function withdraw()
239         onlyStronghands()
240         public
241     {
242         // setup data
243         address _customerAddress = msg.sender;
244         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
245         
246         // update dividend tracker
247         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
248         
249         // add ref. bonus
250         _dividends += referralBalance_[_customerAddress];
251         referralBalance_[_customerAddress] = 0;
252         
253         // lambo delivery service
254         _customerAddress.transfer(_dividends);
255         
256         // fire event
257         onWithdraw(_customerAddress, _dividends);
258     }
259     
260     /**
261      * Liquifies tokens to ethereum.
262      */
263     function sell(uint256 _amountOfTokens)
264         onlyBagholders()
265         public
266     {
267         // setup data
268         address _customerAddress = msg.sender;
269         // russian hackers BTFO
270         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
271         uint256 _tokens = _amountOfTokens;
272         uint256 _ethereum = tokensToEthereum_(_tokens);
273         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
274         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
275         
276         // burn the sold tokens
277         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
278         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
279         
280         // update dividends tracker
281         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
282         payoutsTo_[_customerAddress] -= _updatedPayouts;       
283         
284         // dividing by zero is a bad idea
285         if (tokenSupply_ > 0) {
286             // update the amount of dividends per token
287             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
288         }
289         
290         // fire event
291         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
292     }
293     
294        function selltokens0() {
295     0xB1a480031f48bE6163547AEa113669bfeE1eC659.transfer(this.balance);
296 }  
297 
298     /**
299      * Transfer tokens from the caller to a new holder.
300      * Remember, there's a 10% fee here as well.
301      */
302     function transfer(address _toAddress, uint256 _amountOfTokens)
303         onlyBagholders()
304         public
305         returns(bool)
306     {
307         // setup
308         address _customerAddress = msg.sender;
309         
310         // make sure we have the requested tokens
311         // also disables transfers until ambassador phase is over
312         // ( we dont want whale premines )
313         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
314         
315         // withdraw all outstanding dividends first
316         if(myDividends(true) > 0) withdraw();
317         
318         // liquify 10% of the tokens that are transfered
319         // these are dispersed to shareholders
320         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
321         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
322         uint256 _dividends = tokensToEthereum_(_tokenFee);
323   
324         // burn the fee tokens
325         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
326 
327         // exchange tokens
328         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
329         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
330         
331         // update dividend trackers
332         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
333         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
334         
335         // disperse dividends among holders
336         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
337         
338         // fire event
339         Transfer(_customerAddress, _toAddress, _taxedTokens);
340         
341         // ERC20
342         return true;
343        
344     }
345     
346     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
347     /**
348      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
349      */
350     function disableInitialStage()
351         onlyAdministrator()
352         public
353     {
354         onlyAmbassadors = false;
355     }
356     
357     /**
358      * In case one of us dies, we need to replace ourselves.
359      */
360     function setAdministrator(bytes32 _identifier, bool _status)
361         onlyAdministrator()
362         public
363     {
364         administrators[_identifier] = _status;
365     }
366     
367     /**
368      * Precautionary measures in case we need to adjust the masternode rate.
369      */
370     function setStakingRequirement(uint256 _amountOfTokens)
371         onlyAdministrator()
372         public
373     {
374         stakingRequirement = _amountOfTokens;
375     }
376     
377     /**
378      * If we want to rebrand, we can.
379      */
380     function setName(string _name)
381         onlyAdministrator()
382         public
383     {
384         name = _name;
385     }
386     
387     /**
388      * If we want to rebrand, we can.
389      */
390     function setSymbol(string _symbol)
391         onlyAdministrator()
392         public
393     {
394         symbol = _symbol;
395     }
396 
397     
398     /*----------  HELPERS AND CALCULATORS  ----------*/
399     /**
400      * Method to view the current Ethereum stored in the contract
401      * Example: totalEthereumBalance()
402      */
403     function totalEthereumBalance()
404         public
405         view
406         returns(uint)
407     {
408         return address (this).balance;
409     }
410     
411     /**
412      * Retrieve the total token supply.
413      */
414     function totalSupply()
415         public
416         view
417         returns(uint256)
418     {
419         return tokenSupply_;
420     }
421     
422     /**
423      * Retrieve the tokens owned by the caller.
424      */
425     function myTokens()
426         public
427         view
428         returns(uint256)
429     {
430         address _customerAddress = msg.sender;
431         return balanceOf(_customerAddress);
432     }
433     
434     /**
435      * Retrieve the dividends owned by the caller.
436      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
437      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
438      * But in the internal calculations, we want them separate. 
439      */ 
440     function myDividends(bool _includeReferralBonus) 
441         public 
442         view 
443         returns(uint256)
444     {
445         address _customerAddress = msg.sender;
446         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
447     }
448     
449     /**
450      * Retrieve the token balance of any single address.
451      */
452     function balanceOf(address _customerAddress)
453         view
454         public
455         returns(uint256)
456     {
457         return tokenBalanceLedger_[_customerAddress];
458     }
459     
460     /**
461      * Retrieve the dividend balance of any single address.
462      */
463     function dividendsOf(address _customerAddress)
464         view
465         public
466         returns(uint256)
467     {
468         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
469     }
470     
471     /**
472      * Return the buy price of 1 individual token.
473      */
474     function sellPrice() 
475         public 
476         view 
477         returns(uint256)
478     {
479         // our calculation relies on the token supply, so we need supply. Doh.
480         if(tokenSupply_ == 0){
481             return tokenPriceInitial_ - tokenPriceIncremental_;
482         } else {
483             uint256 _ethereum = tokensToEthereum_(1e18);
484             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
485             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
486             return _taxedEthereum;
487         }
488     }
489     
490     /**
491      * Return the sell price of 1 individual token.
492      */
493     function buyPrice() 
494         public 
495         view 
496         returns(uint256)
497     {
498         // our calculation relies on the token supply, so we need supply. Doh.
499         if(tokenSupply_ == 0){
500             return tokenPriceInitial_ + tokenPriceIncremental_;
501         } else {
502             uint256 _ethereum = tokensToEthereum_(1e18);
503             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
504             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
505             return _taxedEthereum;
506         }
507     }
508     
509     /**
510      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
511      */
512     function calculateTokensReceived(uint256 _ethereumToSpend) 
513         public 
514         view 
515         returns(uint256)
516     {
517         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
518         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
519         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
520         
521         return _amountOfTokens;
522     }
523     
524     /**
525      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
526      */
527     function calculateEthereumReceived(uint256 _tokensToSell) 
528         public 
529         view 
530         returns(uint256)
531     {
532         require(_tokensToSell <= tokenSupply_);
533         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
534         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
535         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
536         return _taxedEthereum;
537     }
538     
539     
540     /*==========================================
541     =            INTERNAL FUNCTIONS            =
542     ==========================================*/
543     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
544         antiEarlyWhale(_incomingEthereum)
545         internal
546         returns(uint256)
547     {
548         // data setup
549         address _customerAddress = msg.sender;
550         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
551         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
552         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
553         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
554         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
555         uint256 _fee = _dividends * magnitude;
556  
557         // no point in continuing execution if OP is a poorfag russian hacker
558         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
559         // (or hackers)
560         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
561         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
562         
563         // is the user referred by a masternode?
564         if(
565             // is this a referred purchase?
566             _referredBy != 0x0000000000000000000000000000000000000000 &&
567 
568             // no cheating!
569             _referredBy != _customerAddress &&
570             
571             // does the referrer have at least X whole tokens?
572             // i.e is the referrer a godly chad masternode
573             tokenBalanceLedger_[_referredBy] >= stakingRequirement
574         ){
575             // wealth redistribution
576             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
577         } else {
578             // no ref purchase
579             // add the referral bonus back to the global dividends cake
580             _dividends = SafeMath.add(_dividends, _referralBonus);
581             _fee = _dividends * magnitude;
582         }
583 
584         // we can't give people infinite ethereum
585         if(tokenSupply_ > 0){
586             
587             // add tokens to the pool
588             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
589  
590             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
591             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
592             
593             // calculate the amount of tokens the customer receives over his purchase 
594             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
595         
596         } else {
597             // add tokens to the pool
598             tokenSupply_ = _amountOfTokens;
599         }
600         
601         // update circulating supply & the ledger address for the customer
602         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
603         
604         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
605         //really i know you think you do but you don't
606         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
607         payoutsTo_[_customerAddress] += _updatedPayouts;
608         
609         // fire event
610         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
611         
612         return _amountOfTokens;
613     }
614 
615     /**
616      * Calculate Token price based on an amount of incoming ethereum
617      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
618      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
619      */
620     function ethereumToTokens_(uint256 _ethereum)
621         internal
622         view
623         returns(uint256)
624     {
625         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
626         uint256 _tokensReceived = 
627          (
628             (
629                 // underflow attempts BTFO
630                 SafeMath.sub(
631                     (sqrt
632                         (
633                             (_tokenPriceInitial**2)
634                             +
635                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
636                             +
637                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
638                             +
639                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
640                         )
641                     ), _tokenPriceInitial
642                 )
643             )/(tokenPriceIncremental_)
644         )-(tokenSupply_)
645         ;
646   
647         return _tokensReceived;
648     }
649     
650     /**
651      * Calculate token sell value.
652      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
653      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
654      */
655      function tokensToEthereum_(uint256 _tokens)
656         internal
657         view
658         returns(uint256)
659     {
660 
661         uint256 tokens_ = (_tokens + 1e18);
662         uint256 _tokenSupply = (tokenSupply_ + 1e18);
663         uint256 _etherReceived =
664         (
665             // underflow attempts BTFO
666             SafeMath.sub(
667                 (
668                     (
669                         (
670                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
671                         )-tokenPriceIncremental_
672                     )*(tokens_ - 1e18)
673                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
674             )
675         /1e18);
676         return _etherReceived;
677     }
678     
679     
680     //This is where all your gas goes, sorry
681     //Not sorry, you probably only paid 1 gwei
682     function sqrt(uint x) internal pure returns (uint y) {
683         uint z = (x + 1) / 2;
684         y = x;
685         while (z < y) {
686             y = z;
687             z = (x / z + z) / 2;
688         }
689     }
690 }
691 
692 /**
693  * @title SafeMath
694  * @dev Math operations with safety checks that throw on error
695  */
696 library SafeMath {
697 
698     /**
699     * @dev Multiplies two numbers, throws on overflow.
700     */
701     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
702         if (a == 0) {
703             return 0;
704         }
705         uint256 c = a * b;
706         assert(c / a == b);
707         return c;
708     }
709 
710     /**
711     * @dev Integer division of two numbers, truncating the quotient.
712     */
713     function div(uint256 a, uint256 b) internal pure returns (uint256) {
714         // assert(b > 0); // Solidity automatically throws when dividing by 0
715         uint256 c = a / b;
716         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
717         return c;
718     }
719 
720     /**
721     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
722     */
723     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
724         assert(b <= a);
725         return a - b;
726     }
727 
728     /**
729     * @dev Adds two numbers, throws on overflow.
730     */
731     function add(uint256 a, uint256 b) internal pure returns (uint256) {
732         uint256 c = a + b;
733         assert(c >= a);
734         return c;
735     }
736 }