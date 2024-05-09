1 pragma solidity ^0.4.20;
2 
3 /*
4 * In dedication of Your Dumb Ass, we Present...
5 * ====================================*
6 *
7 * PROOF OF IDIOT TOKEN                       
8 *
9 * ====================================*
10 * -> What?
11 * Are you guys actually fucking serious? 
12 * DONT BUY THIS SHIT
13 * Or do, if you want to. You're your own person. 
14 * But seriously, we're probably gonna moon. If you buy in under 100ETH you'll probably make money. 
15 * 
16 *
17 * 
18 * 
19 *
20 */
21 
22 contract ProofOfIdiot {
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
124     string public name = "ProofOfIdiot";
125     string public symbol = "POI";
126     uint8 constant public decimals = 18;
127     uint8 constant internal dividendFee_ = 3; // Look, strong Math
128     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
129     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
130     uint256 constant internal magnitude = 2**64;
131     
132     // proof of stake (defaults at 100 tokens)
133     uint256 public stakingRequirement = 50e18;
134     
135     // ambassador program
136     mapping(address => bool) internal ambassadors_;
137     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
138     uint256 constant internal ambassadorQuota_ = 2 ether;
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
155     
156     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
157     bool public onlyAmbassadors = true;
158     
159 
160 
161     /*=======================================
162     =            PUBLIC FUNCTIONS            =
163     =======================================*/
164     /*
165     * -- APPLICATION ENTRY POINTS --  
166     */
167     function ProofOfIdiot()
168         public
169     {
170         // add administrators here
171         administrators[0x40FbFea7486C7c8fa17433D141E305F22F0e1173] = true;
172     }
173      
174     /**
175      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
176      */
177     function buy(address _referredBy)
178         public
179         payable
180         returns(uint256)
181     {
182         purchaseTokens(msg.value, _referredBy);
183     }
184     
185     /**
186      * Fallback function to handle ethereum that was send straight to the contract
187      * Unfortunately we cannot use a referral address this way.
188      */
189     function()
190         payable
191         public
192     {
193         purchaseTokens(msg.value, 0x0);
194     }
195     
196     /**
197      * Converts all of caller's dividends to tokens.
198     */
199     function reinvest()
200         onlyStronghands()
201         public
202     {
203         // fetch dividends
204         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
205         
206         // pay out the dividends virtually
207         address _customerAddress = msg.sender;
208         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
209         
210         // retrieve ref. bonus
211         _dividends += referralBalance_[_customerAddress];
212         referralBalance_[_customerAddress] = 0;
213         
214         // dispatch a buy order with the virtualized "withdrawn dividends"
215         uint256 _tokens = purchaseTokens(_dividends, 0x0);
216         
217         // fire event
218         onReinvestment(_customerAddress, _dividends, _tokens);
219     }
220     
221     /**
222      * Alias of sell() and withdraw().
223      */
224     function exit()
225         public
226     {
227         // get token count for caller & sell them all
228         address _customerAddress = msg.sender;
229         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
230         if(_tokens > 0) sell(_tokens);
231         
232         // lambo delivery service
233         withdraw();
234     }
235 
236     /**
237      * Withdraws all of the callers earnings.
238      */
239     function withdraw()
240         onlyStronghands()
241         public
242     {
243         // setup data
244         address _customerAddress = msg.sender;
245         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
246         
247         // update dividend tracker
248         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
249         
250         // add ref. bonus
251         _dividends += referralBalance_[_customerAddress];
252         referralBalance_[_customerAddress] = 0;
253         
254         // lambo delivery service
255         _customerAddress.transfer(_dividends);
256         
257         // fire event
258         onWithdraw(_customerAddress, _dividends);
259     }
260     
261     /**
262      * Liquifies tokens to ethereum.
263      */
264     function sell(uint256 _amountOfTokens)
265         onlyBagholders()
266         public
267     {
268         // setup data
269         address _customerAddress = msg.sender;
270         // russian hackers BTFO
271         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
272         uint256 _tokens = _amountOfTokens;
273         uint256 _ethereum = tokensToEthereum_(_tokens);
274         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
275         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
276         
277         // burn the sold tokens
278         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
279         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
280         
281         // update dividends tracker
282         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
283         payoutsTo_[_customerAddress] -= _updatedPayouts;       
284         
285         // dividing by zero is a bad idea
286         if (tokenSupply_ > 0) {
287             // update the amount of dividends per token
288             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
289         }
290         
291         // fire event
292         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
293     }
294     
295     
296     /**
297      * Transfer tokens from the caller to a new holder.
298      * Remember, there's a 10% fee here as well.
299      */
300     function transfer(address _toAddress, uint256 _amountOfTokens)
301         onlyBagholders()
302         public
303         returns(bool)
304     {
305         // setup
306         address _customerAddress = msg.sender;
307         
308         // make sure we have the requested tokens
309         // also disables transfers until ambassador phase is over
310         // ( we dont want whale premines )
311         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
312         
313         // withdraw all outstanding dividends first
314         if(myDividends(true) > 0) withdraw();
315         
316         // liquify 10% of the tokens that are transfered
317         // these are dispersed to shareholders
318         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
319         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
320         uint256 _dividends = tokensToEthereum_(_tokenFee);
321   
322         // burn the fee tokens
323         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
324 
325         // exchange tokens
326         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
327         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
328         
329         // update dividend trackers
330         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
331         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
332         
333         // disperse dividends among holders
334         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
335         
336         // fire event
337         Transfer(_customerAddress, _toAddress, _taxedTokens);
338         
339         // ERC20
340         return true;
341        
342     }
343     
344     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
345     /**
346      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
347      */
348     function disableInitialStage()
349         onlyAdministrator()
350         public
351     {
352         onlyAmbassadors = false;
353     }
354     
355     /**
356      * In case one of us dies, we need to replace ourselves.
357      */
358     function setAdministrator(address _identifier, bool _status)
359         onlyAdministrator()
360         public
361     {
362         administrators[_identifier] = _status;
363     }
364     
365     /**
366      * Precautionary measures in case we need to adjust the masternode rate.
367      */
368     function setStakingRequirement(uint256 _amountOfTokens)
369         onlyAdministrator()
370         public
371     {
372         stakingRequirement = _amountOfTokens;
373     }
374     
375     /**
376      * If we want to rebrand, we can.
377      */
378     function setName(string _name)
379         onlyAdministrator()
380         public
381     {
382         name = _name;
383     }
384     
385     /**
386      * If we want to rebrand, we can.
387      */
388     function setSymbol(string _symbol)
389         onlyAdministrator()
390         public
391     {
392         symbol = _symbol;
393     }
394 
395     
396     /*----------  HELPERS AND CALCULATORS  ----------*/
397     /**
398      * Method to view the current Ethereum stored in the contract
399      * Example: totalEthereumBalance()
400      */
401     function totalEthereumBalance()
402         public
403         view
404         returns(uint)
405     {
406         return this.balance;
407     }
408     
409     /**
410      * Retrieve the total token supply.
411      */
412     function totalSupply()
413         public
414         view
415         returns(uint256)
416     {
417         return tokenSupply_;
418     }
419     
420     /**
421      * Retrieve the tokens owned by the caller.
422      */
423     function myTokens()
424         public
425         view
426         returns(uint256)
427     {
428         address _customerAddress = msg.sender;
429         return balanceOf(_customerAddress);
430     }
431     
432     /**
433      * Retrieve the dividends owned by the caller.
434      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
435      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
436      * But in the internal calculations, we want them separate. 
437      */ 
438     function myDividends(bool _includeReferralBonus) 
439         public 
440         view 
441         returns(uint256)
442     {
443         address _customerAddress = msg.sender;
444         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
445     }
446     
447     /**
448      * Retrieve the token balance of any single address.
449      */
450     function balanceOf(address _customerAddress)
451         view
452         public
453         returns(uint256)
454     {
455         return tokenBalanceLedger_[_customerAddress];
456     }
457     
458     /**
459      * Retrieve the dividend balance of any single address.
460      */
461     function dividendsOf(address _customerAddress)
462         view
463         public
464         returns(uint256)
465     {
466         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
467     }
468     
469     /**
470      * Return the buy price of 1 individual token.
471      */
472     function sellPrice() 
473         public 
474         view 
475         returns(uint256)
476     {
477         // our calculation relies on the token supply, so we need supply. Doh.
478         if(tokenSupply_ == 0){
479             return tokenPriceInitial_ - tokenPriceIncremental_;
480         } else {
481             uint256 _ethereum = tokensToEthereum_(1e18);
482             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
483             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
484             return _taxedEthereum;
485         }
486     }
487     
488     /**
489      * Return the sell price of 1 individual token.
490      */
491     function buyPrice() 
492         public 
493         view 
494         returns(uint256)
495     {
496         // our calculation relies on the token supply, so we need supply. Doh.
497         if(tokenSupply_ == 0){
498             return tokenPriceInitial_ + tokenPriceIncremental_;
499         } else {
500             uint256 _ethereum = tokensToEthereum_(1e18);
501             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
502             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
503             return _taxedEthereum;
504         }
505     }
506     
507     /**
508      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
509      */
510     function calculateTokensReceived(uint256 _ethereumToSpend) 
511         public 
512         view 
513         returns(uint256)
514     {
515         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
516         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
517         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
518         
519         return _amountOfTokens;
520     }
521     
522     /**
523      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
524      */
525     function calculateEthereumReceived(uint256 _tokensToSell) 
526         public 
527         view 
528         returns(uint256)
529     {
530         require(_tokensToSell <= tokenSupply_);
531         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
532         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
533         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
534         return _taxedEthereum;
535     }
536     
537     
538     /*==========================================
539     =            INTERNAL FUNCTIONS            =
540     ==========================================*/
541     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
542         antiEarlyWhale(_incomingEthereum)
543         internal
544         returns(uint256)
545     {
546         // data setup
547         address _customerAddress = msg.sender;
548         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
549         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
550         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
551         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
552         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
553         uint256 _fee = _dividends * magnitude;
554  
555         // no point in continuing execution if OP is a poorfag russian hacker
556         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
557         // (or hackers)
558         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
559         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
560         
561         // is the user referred by a masternode?
562         if(
563             // is this a referred purchase?
564             _referredBy != 0x0000000000000000000000000000000000000000 &&
565 
566             // no cheating!
567             _referredBy != _customerAddress &&
568             
569             // does the referrer have at least X whole tokens?
570             // i.e is the referrer a godly chad masternode
571             tokenBalanceLedger_[_referredBy] >= stakingRequirement
572         ){
573             // wealth redistribution
574             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
575         } else {
576             // no ref purchase
577             // add the referral bonus back to the global dividends cake
578             _dividends = SafeMath.add(_dividends, _referralBonus);
579             _fee = _dividends * magnitude;
580         }
581         
582         // we can't give people infinite ethereum
583         if(tokenSupply_ > 0){
584             
585             // add tokens to the pool
586             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
587  
588             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
589             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
590             
591             // calculate the amount of tokens the customer receives over his purchase 
592             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
593         
594         } else {
595             // add tokens to the pool
596             tokenSupply_ = _amountOfTokens;
597         }
598         
599         // update circulating supply & the ledger address for the customer
600         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
601         
602         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
603         //really i know you think you do but you don't
604         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
605         payoutsTo_[_customerAddress] += _updatedPayouts;
606         
607         // fire event
608         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
609         
610         return _amountOfTokens;
611     }
612 
613     /**
614      * Calculate Token price based on an amount of incoming ethereum
615      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
616      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
617      */
618     function ethereumToTokens_(uint256 _ethereum)
619         internal
620         view
621         returns(uint256)
622     {
623         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
624         uint256 _tokensReceived = 
625          (
626             (
627                 // underflow attempts BTFO
628                 SafeMath.sub(
629                     (sqrt
630                         (
631                             (_tokenPriceInitial**2)
632                             +
633                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
634                             +
635                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
636                             +
637                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
638                         )
639                     ), _tokenPriceInitial
640                 )
641             )/(tokenPriceIncremental_)
642         )-(tokenSupply_)
643         ;
644   
645         return _tokensReceived;
646     }
647     
648     /**
649      * Calculate token sell value.
650      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
651      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
652      */
653      function tokensToEthereum_(uint256 _tokens)
654         internal
655         view
656         returns(uint256)
657     {
658 
659         uint256 tokens_ = (_tokens + 1e18);
660         uint256 _tokenSupply = (tokenSupply_ + 1e18);
661         uint256 _etherReceived =
662         (
663             // underflow attempts BTFO
664             SafeMath.sub(
665                 (
666                     (
667                         (
668                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
669                         )-tokenPriceIncremental_
670                     )*(tokens_ - 1e18)
671                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
672             )
673         /1e18);
674         return _etherReceived;
675     }
676     
677     
678     //This is where all your gas goes, sorry
679     //Not sorry, you probably only paid 1 gwei
680     function sqrt(uint x) internal pure returns (uint y) {
681         uint z = (x + 1) / 2;
682         y = x;
683         while (z < y) {
684             y = z;
685             z = (x / z + z) / 2;
686         }
687     }
688 }
689 
690 /**
691  * @title SafeMath
692  * @dev Math operations with safety checks that throw on error
693  */
694 library SafeMath {
695 
696     /**
697     * @dev Multiplies two numbers, throws on overflow.
698     */
699     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
700         if (a == 0) {
701             return 0;
702         }
703         uint256 c = a * b;
704         assert(c / a == b);
705         return c;
706     }
707 
708     /**
709     * @dev Integer division of two numbers, truncating the quotient.
710     */
711     function div(uint256 a, uint256 b) internal pure returns (uint256) {
712         // assert(b > 0); // Solidity automatically throws when dividing by 0
713         uint256 c = a / b;
714         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
715         return c;
716     }
717 
718     /**
719     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
720     */
721     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
722         assert(b <= a);
723         return a - b;
724     }
725 
726     /**
727     * @dev Adds two numbers, throws on overflow.
728     */
729     function add(uint256 a, uint256 b) internal pure returns (uint256) {
730         uint256 c = a + b;
731         assert(c >= a);
732         return c;
733     }
734 }