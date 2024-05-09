1 pragma solidity ^0.4.24;
2 
3 /**
4  * Based on the open source code of PowerH3D, we built our UPower application ecosystem.
5  * We will inherit the open source spirit of PowerH3D and accept the community review. 
6  * In future, we will launch more creative games to enrich UPower ecosystem. 
7  * Thanks to Just Team!
8  */
9 
10 contract UPower {
11     //using SafeMath for uint256;
12     
13     /*=================================
14     =            MODIFIERS            =
15     =================================*/
16     // only people with tokens
17     modifier onlyBagholders() {
18         require(myTokens() > 0);
19         _;
20     }
21     
22     // only people with profits
23     modifier onlyStronghands() {
24         require(myDividends(true) > 0);
25         _;
26     }
27     
28     // administrators can:
29     // -> change the name of the contract
30     // -> change the name of the token
31     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
32     // they CANNOT:
33     // -> take funds
34     // -> disable withdrawals
35     // -> kill the contract
36     // -> change the price of tokens
37     modifier onlyAdministrator(){
38         address _customerAddress = msg.sender;
39         require(administrators[_customerAddress]);
40         _;
41     }
42     
43     
44     // ensures that the first tokens in the contract will be equally distributed
45     // meaning, no divine dump will be ever possible
46     // result: healthy longevity.
47     modifier antiEarlyWhale(uint256 _amountOfEthereum){
48         address _customerAddress = msg.sender;
49         
50         // are we still in the vulnerable phase?
51         // if so, enact anti early whale protocol 
52         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
53             require(
54                 // is the customer in the ambassador list?
55                 ambassadors_[_customerAddress] == true &&
56                 
57                 // does the customer purchase exceed the max ambassador quota?
58                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
59                 
60             );
61             
62             // updated the accumulated quota    
63             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
64         
65             // execute
66             _;
67         } else {
68             // in case the ether count drops low, the ambassador phase won't reinitiate
69             onlyAmbassadors = false;
70             _;    
71         }
72         
73     }
74     
75     
76     /*==============================
77     =            EVENTS            =
78     ==============================*/
79     event onTokenPurchase(
80         address indexed customerAddress,
81         uint256 incomingEthereum,
82         uint256 tokensMinted,
83         address indexed referredBy
84     );
85     
86     event onTokenSell(
87         address indexed customerAddress,
88         uint256 tokensBurned,
89         uint256 ethereumEarned
90     );
91     
92     event onReinvestment(
93         address indexed customerAddress,
94         uint256 ethereumReinvested,
95         uint256 tokensMinted
96     );
97     
98     event onWithdraw(
99         address indexed customerAddress,
100         uint256 ethereumWithdrawn
101     );
102     
103     // ERC20
104     event Transfer(
105         address indexed from,
106         address indexed to,
107         uint256 tokens
108     );
109     
110     
111     /*=====================================
112     =            CONFIGURABLES            =
113     =====================================*/
114     string public name = "UPower";
115     string public symbol = "UP";
116     uint8 constant public decimals = 18;
117     uint8 constant internal dividendFee_ = 10;
118     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
119     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
120     uint256 constant internal magnitude = 2**64;
121     
122     // proof of stake (defaults at 100 tokens)
123     uint256 public stakingRequirement = 100e18;
124     
125     // ambassador program
126     mapping(address => bool) internal ambassadors_;
127     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
128     uint256 constant internal ambassadorQuota_ = 4 ether;
129     
130     
131     
132    /*================================
133     =            DATASETS            =
134     ================================*/
135     // amount of shares for each address (scaled number)
136     mapping(address => uint256) internal tokenBalanceLedger_;
137     mapping(address => uint256) internal referralBalance_;
138     mapping(address => int256) internal payoutsTo_;
139     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
140     uint256 internal tokenSupply_ = 0;
141     uint256 internal profitPerShare_;
142     
143     // administrator list (see above on what they can do)
144     mapping(address => bool) public administrators;
145     
146     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
147     bool public onlyAmbassadors = true;
148     
149 
150 
151     /*=======================================
152     =            PUBLIC FUNCTIONS            =
153     =======================================*/
154     /*
155     * -- APPLICATION ENTRY POINTS --  
156     */
157     constructor()
158         public
159     {
160         // add administrators here
161         administrators[0x1d85A7C26952d4a7D940573eaE73f44D0D6Fa76D] = true;
162         
163         ambassadors_[0x5724fc4Abb369C6F2339F784E5b42189f3d30180] = true;
164         
165         ambassadors_[0x6Be04d4ef139eE9fd08A32FdBFb7A532Fe9eD53F] = true;
166         
167         ambassadors_[0x53E3E6444C416e2A981644706A8E5E9C13511cf7] = true;
168         
169         ambassadors_[0xEeF4f752D105fEaCB288bB7071F619A2E90a34aC] = true;
170     }
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
217         emit onReinvestment(_customerAddress, _dividends, _tokens);
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
257         emit onWithdraw(_customerAddress, _dividends);
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
291         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
292     }
293     
294     
295     /**
296      * Transfer tokens from the caller to a new holder.
297      * Remember, there's a 10% fee here as well.
298      */
299     function transfer(address _toAddress, uint256 _amountOfTokens)
300         onlyBagholders()
301         public
302         returns(bool)
303     {
304         // setup
305         address _customerAddress = msg.sender;
306         
307         // make sure we have the requested tokens
308         // also disables transfers until ambassador phase is over
309         // ( we dont want whale premines )
310         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
311         
312         // withdraw all outstanding dividends first
313         if(myDividends(true) > 0) withdraw();
314         
315         // liquify 10% of the tokens that are transfered
316         // these are dispersed to shareholders
317         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
318         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
319         uint256 _dividends = tokensToEthereum_(_tokenFee);
320   
321         // burn the fee tokens
322         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
323 
324         // exchange tokens
325         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
326         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
327         
328         // update dividend trackers
329         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
330         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
331         
332         // disperse dividends among holders
333         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
334         
335         // fire event
336         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
337         
338         // ERC20
339         return true;
340        
341     }
342     
343     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
344     /**
345      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
346      */
347     function disableInitialStage()
348         onlyAdministrator()
349         public
350     {
351         onlyAmbassadors = false;
352     }
353     
354     /**
355      * In case one of us dies, we need to replace ourselves.
356      */
357     function setAdministrator(address _identifier, bool _status)
358         onlyAdministrator()
359         public
360     {
361         administrators[_identifier] = _status;
362     }
363     
364     /**
365      * Precautionary measures in case we need to adjust the masternode rate.
366      */
367     function setStakingRequirement(uint256 _amountOfTokens)
368         onlyAdministrator()
369         public
370     {
371         stakingRequirement = _amountOfTokens;
372     }
373     
374     /**
375      * If we want to rebrand, we can.
376      */
377     function setName(string _name)
378         onlyAdministrator()
379         public
380     {
381         name = _name;
382     }
383     
384     /**
385      * If we want to rebrand, we can.
386      */
387     function setSymbol(string _symbol)
388         onlyAdministrator()
389         public
390     {
391         symbol = _symbol;
392     }
393 
394     
395     /*----------  HELPERS AND CALCULATORS  ----------*/
396     /**
397      * Method to view the current Ethereum stored in the contract
398      * Example: totalEthereumBalance()
399      */
400     function totalEthereumBalance()
401         public
402         view
403         returns(uint)
404     {
405         return address(this).balance;
406     }
407     
408     /**
409      * Retrieve the total token supply.
410      */
411     function totalSupply()
412         public
413         view
414         returns(uint256)
415     {
416         return tokenSupply_;
417     }
418     
419     /**
420      * Retrieve the tokens owned by the caller.
421      */
422     function myTokens()
423         public
424         view
425         returns(uint256)
426     {
427         address _customerAddress = msg.sender;
428         return balanceOf(_customerAddress);
429     }
430     
431     /**
432      * Retrieve the dividends owned by the caller.
433      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
434      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
435      * But in the internal calculations, we want them separate. 
436      */ 
437     function myDividends(bool _includeReferralBonus) 
438         public 
439         view 
440         returns(uint256)
441     {
442         address _customerAddress = msg.sender;
443         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
444     }
445     
446     /**
447      * Retrieve the token balance of any single address.
448      */
449     function balanceOf(address _customerAddress)
450         view
451         public
452         returns(uint256)
453     {
454         return tokenBalanceLedger_[_customerAddress];
455     }
456     
457     /**
458      * Retrieve the dividend balance of any single address.
459      */
460     function dividendsOf(address _customerAddress)
461         view
462         public
463         returns(uint256)
464     {
465         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
466     }
467     
468     /**
469      * Return the buy price of 1 individual token.
470      */
471     function sellPrice() 
472         public 
473         view 
474         returns(uint256)
475     {
476         // our calculation relies on the token supply, so we need supply. Doh.
477         if(tokenSupply_ == 0){
478             return tokenPriceInitial_ - tokenPriceIncremental_;
479         } else {
480             uint256 _ethereum = tokensToEthereum_(1e18);
481             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
482             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
483             return _taxedEthereum;
484         }
485     }
486     
487     /**
488      * Return the sell price of 1 individual token.
489      */
490     function buyPrice() 
491         public 
492         view 
493         returns(uint256)
494     {
495         // our calculation relies on the token supply, so we need supply. Doh.
496         if(tokenSupply_ == 0){
497             return tokenPriceInitial_ + tokenPriceIncremental_;
498         } else {
499             uint256 _ethereum = tokensToEthereum_(1e18);
500             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
501             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
502             return _taxedEthereum;
503         }
504     }
505     
506     /**
507      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
508      */
509     function calculateTokensReceived(uint256 _ethereumToSpend) 
510         public 
511         view 
512         returns(uint256)
513     {
514         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
515         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
516         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
517         
518         return _amountOfTokens;
519     }
520     
521     /**
522      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
523      */
524     function calculateEthereumReceived(uint256 _tokensToSell) 
525         public 
526         view 
527         returns(uint256)
528     {
529         require(_tokensToSell <= tokenSupply_);
530         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
531         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
532         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
533         return _taxedEthereum;
534     }
535     
536     
537     /*==========================================
538     =            INTERNAL FUNCTIONS            =
539     ==========================================*/
540     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
541         antiEarlyWhale(_incomingEthereum)
542         internal
543         returns(uint256)
544     {
545         // data setup
546         address _customerAddress = msg.sender;
547         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
548         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
549         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
550         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
551         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
552         uint256 _fee = _dividends * magnitude;
553  
554         // no point in continuing execution if OP is a poorfag russian hacker
555         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
556         // (or hackers)
557         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
558         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
559         
560         // is the user referred by a masternode?
561         if(
562             // is this a referred purchase?
563             _referredBy != 0x0000000000000000000000000000000000000000 &&
564 
565             // no cheating!
566             _referredBy != _customerAddress &&
567             
568             // does the referrer have at least X whole tokens?
569             // i.e is the referrer a godly chad masternode
570             tokenBalanceLedger_[_referredBy] >= stakingRequirement
571         ){
572             // wealth redistribution
573             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
574         } else {
575             // no ref purchase
576             // add the referral bonus back to the global dividends cake
577             _dividends = SafeMath.add(_dividends, _referralBonus);
578             _fee = _dividends * magnitude;
579         }
580         
581         // we can't give people infinite ethereum
582         if(tokenSupply_ > 0){
583             
584             // add tokens to the pool
585             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
586  
587             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
588             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
589             
590             // calculate the amount of tokens the customer receives over his purchase 
591             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
592         
593         } else {
594             // add tokens to the pool
595             tokenSupply_ = _amountOfTokens;
596         }
597         
598         // update circulating supply & the ledger address for the customer
599         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
600         
601         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
602         //really i know you think you do but you don't
603         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
604         payoutsTo_[_customerAddress] += _updatedPayouts;
605         
606         // fire event
607         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
608         
609         return _amountOfTokens;
610     }
611 
612     /**
613      * Calculate Token price based on an amount of incoming ethereum
614      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
615      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
616      */
617     function ethereumToTokens_(uint256 _ethereum)
618         internal
619         view
620         returns(uint256)
621     {
622         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
623         uint256 _tokensReceived = 
624          (
625             (
626                 // underflow attempts BTFO
627                 SafeMath.sub(
628                     (sqrt
629                         (
630                             (_tokenPriceInitial**2)
631                             +
632                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
633                             +
634                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
635                             +
636                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
637                         )
638                     ), _tokenPriceInitial
639                 )
640             )/(tokenPriceIncremental_)
641         )-(tokenSupply_)
642         ;
643   
644         return _tokensReceived;
645     }
646     
647     /**
648      * Calculate token sell value.
649      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
650      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
651      */
652      function tokensToEthereum_(uint256 _tokens)
653         internal
654         view
655         returns(uint256)
656     {
657 
658         uint256 tokens_ = (_tokens + 1e18);
659         uint256 _tokenSupply = (tokenSupply_ + 1e18);
660         uint256 _etherReceived =
661         (
662             // underflow attempts BTFO
663             SafeMath.sub(
664                 (
665                     (
666                         (
667                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
668                         )-tokenPriceIncremental_
669                     )*(tokens_ - 1e18)
670                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
671             )
672         /1e18);
673         return _etherReceived;
674     }
675     
676     
677     //This is where all your gas goes, sorry
678     //Not sorry, you probably only paid 1 gwei
679     function sqrt(uint x) internal pure returns (uint y) {
680         uint z = (x + 1) / 2;
681         y = x;
682         while (z < y) {
683             y = z;
684             z = (x / z + z) / 2;
685         }
686     }
687 }
688 
689 /**
690  * @title SafeMath
691  * @dev Math operations with safety checks that throw on error
692  */
693 library SafeMath {
694 
695     /**
696     * @dev Multiplies two numbers, throws on overflow.
697     */
698     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
699         if (a == 0) {
700             return 0;
701         }
702         uint256 c = a * b;
703         assert(c / a == b);
704         return c;
705     }
706 
707     /**
708     * @dev Integer division of two numbers, truncating the quotient.
709     */
710     function div(uint256 a, uint256 b) internal pure returns (uint256) {
711         // assert(b > 0); // Solidity automatically throws when dividing by 0
712         uint256 c = a / b;
713         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
714         return c;
715     }
716 
717     /**
718     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
719     */
720     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
721         assert(b <= a);
722         return a - b;
723     }
724 
725     /**
726     * @dev Adds two numbers, throws on overflow.
727     */
728     function add(uint256 a, uint256 b) internal pure returns (uint256) {
729         uint256 c = a + b;
730         assert(c >= a);
731         return c;
732     }
733 }