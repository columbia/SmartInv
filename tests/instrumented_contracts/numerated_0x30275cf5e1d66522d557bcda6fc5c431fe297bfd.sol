1 pragma solidity ^0.4.20;
2 
3 /*
4 * ZAYNIX FIRST AND SAFE DECENTRALIZED CRYPTOCURRENCY FOR INVESTMENTS 
5 * ====================================*
6 * Telegram Annoucements: https://t.me/zaynixcom
7 * Telegram Group: https://t.me/joinchat/ItCwUkuUfhZMTrO4aCP6OQ
8 * Website: https://zaynix.com
9 * https://twitter.com/Zaynixcom  
10 * ====================================*
11 */
12 
13 contract Hourglass {
14     /*=================================
15     =            MODIFIERS            =
16     =================================*/
17     // only people with tokens
18     modifier onlyBagholders() {
19         require(myTokens() > 0);
20         _;
21     }
22     
23     // only people with profits
24     modifier onlyStronghands() {
25         require(myDividends(true) > 0);
26         _;
27     }
28     
29     // administrators can:
30     // -> change the name of the contract
31     // -> change the name of the token
32     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
33     // they CANNOT:
34     // -> take funds
35     // -> disable withdrawals
36     // -> kill the contract
37     // -> change the price of tokens
38     modifier onlyAdministrator(){
39         address _customerAddress = msg.sender;
40         require(administrators[address(_customerAddress)]);
41         _;
42     }
43     
44     
45     // ensures that the first tokens in the contract will be equally distributed
46     // meaning, no divine dump will be ever possible
47     // result: healthy longevity.
48     modifier antiEarlyWhale(uint256 _amountOfEthereum){
49         address _customerAddress = msg.sender;
50         
51         // are we still in the vulnerable phase?
52         // if so, enact anti early whale protocol 
53         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
54             require(
55                 // is the customer in the ambassador list?
56                 ambassadors_[_customerAddress] == true &&
57                 
58                 // does the customer purchase exceed the max ambassador quota?
59                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
60                 
61             );
62             
63             // updated the accumulated quota    
64             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
65         
66             // execute
67             _;
68         } else {
69             // in case the ether count drops low, the ambassador phase won't reinitiate
70             onlyAmbassadors = false;
71             _;    
72         }
73         
74     }
75     
76     
77     /*==============================
78     =            EVENTS            =
79     ==============================*/
80     event onTokenPurchase(
81         address indexed customerAddress,
82         uint256 incomingEthereum,
83         uint256 tokensMinted,
84         address indexed referredBy
85     );
86     
87     event onTokenSell(
88         address indexed customerAddress,
89         uint256 tokensBurned,
90         uint256 ethereumEarned
91     );
92     
93     event onReinvestment(
94         address indexed customerAddress,
95         uint256 ethereumReinvested,
96         uint256 tokensMinted
97     );
98     
99     event onWithdraw(
100         address indexed customerAddress,
101         uint256 ethereumWithdrawn
102     );
103     
104     // ERC20
105     event Transfer(
106         address indexed from,
107         address indexed to,
108         uint256 tokens
109     );
110     
111     
112     /*=====================================
113     =            CONFIGURABLES            =
114     =====================================*/
115     string public name = "Zaynix";
116     string public symbol = "ZYX";
117     uint8 constant public decimals = 18;
118     uint8 constant internal dividendFee_ = 10;
119     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
120     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
121     uint256 constant internal magnitude = 2**64;
122     
123     // proof of stake (defaults at 100 tokens)
124     uint256 public stakingRequirement = 100e18;
125     
126     // ambassador program
127     mapping(address => bool) internal ambassadors_;
128     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
129     uint256 constant internal ambassadorQuota_ = 20 ether;
130     
131     
132     
133    /*================================
134     =            DATASETS            =
135     ================================*/
136     // amount of shares for each address (scaled number)
137     mapping(address => uint256) internal tokenBalanceLedger_;
138     mapping(address => uint256) internal referralBalance_;
139     mapping(address => int256) internal payoutsTo_;
140     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
141     uint256 internal tokenSupply_ = 0;
142     uint256 internal profitPerShare_;
143     
144     // administrator list (see above on what they can do)
145     mapping(address => bool) public administrators;
146     
147     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
148     bool public onlyAmbassadors = true;
149     
150 
151 
152     /*=======================================
153     =            PUBLIC FUNCTIONS            =
154     =======================================*/
155     /*
156     * -- APPLICATION ENTRY POINTS --  
157     */
158     function Hourglass()
159         public
160     {
161         // add administrators here
162         administrators[0xb4013f85ea12dCa6E4AB7996527368d3D886CEE8] = true;
163         
164         // contributors that need to remain private out of security concerns.
165         ambassadors_[0xb4013f85ea12dCa6E4AB7996527368d3D886CEE8] = true; //dp
166         
167 
168     }
169     
170      
171     /**
172      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
173      */
174     function buy(address _referredBy)
175         public
176         payable
177         returns(uint256)
178     {
179         purchaseTokens(msg.value, _referredBy);
180     }
181     
182     /**
183      * Fallback function to handle ethereum that was send straight to the contract
184      * Unfortunately we cannot use a referral address this way.
185      */
186     function()
187         payable
188         public
189     {
190         purchaseTokens(msg.value, 0x0);
191     }
192     
193     /**
194      * Converts all of caller's dividends to tokens.
195      */
196     function reinvest()
197         onlyStronghands()
198         public
199     {
200         // fetch dividends
201         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
202         
203         // pay out the dividends virtually
204         address _customerAddress = msg.sender;
205         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
206         
207         // retrieve ref. bonus
208         _dividends += referralBalance_[_customerAddress];
209         referralBalance_[_customerAddress] = 0;
210         
211         // dispatch a buy order with the virtualized "withdrawn dividends"
212         uint256 _tokens = purchaseTokens(_dividends, 0x0);
213         
214         // fire event
215         onReinvestment(_customerAddress, _dividends, _tokens);
216     }
217     
218     /**
219      * Alias of sell() and withdraw().
220      */
221     function exit()
222         public
223     {
224         // get token count for caller & sell them all
225         address _customerAddress = msg.sender;
226         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
227         if(_tokens > 0) sell(_tokens);
228         
229         // lambo delivery service
230         withdraw();
231     }
232 
233     /**
234      * Withdraws all of the callers earnings.
235      */
236     function withdraw()
237         onlyStronghands()
238         public
239     {
240         // setup data
241         address _customerAddress = msg.sender;
242         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
243         
244         // update dividend tracker
245         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
246         
247         // add ref. bonus
248         _dividends += referralBalance_[_customerAddress];
249         referralBalance_[_customerAddress] = 0;
250         
251         // lambo delivery service
252         _customerAddress.transfer(_dividends);
253         
254         // fire event
255         onWithdraw(_customerAddress, _dividends);
256     }
257     
258     /**
259      * Liquifies tokens to ethereum.
260      */
261     function sell(uint256 _amountOfTokens)
262         onlyBagholders()
263         public
264     {
265         // setup data
266         address _customerAddress = msg.sender;
267         // russian hackers BTFO
268         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
269         uint256 _tokens = _amountOfTokens;
270         uint256 _ethereum = tokensToEthereum_(_tokens);
271         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
272         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
273         
274         // burn the sold tokens
275         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
276         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
277         
278         // update dividends tracker
279         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
280         payoutsTo_[_customerAddress] -= _updatedPayouts;       
281         
282         // dividing by zero is a bad idea
283         if (tokenSupply_ > 0) {
284             // update the amount of dividends per token
285             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
286         }
287         
288         // fire event
289         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
290     }
291     
292     
293     /**
294      * Transfer tokens from the caller to a new holder.
295      * Remember, there's a 10% fee here as well.
296      */
297     function transfer(address _toAddress, uint256 _amountOfTokens)
298         onlyBagholders()
299         public
300         returns(bool)
301     {
302         // setup
303         address _customerAddress = msg.sender;
304         
305         // make sure we have the requested tokens
306         // also disables transfers until ambassador phase is over
307         // ( we dont want whale premines )
308         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
309         
310         // withdraw all outstanding dividends first
311         if(myDividends(true) > 0) withdraw();
312         
313         // liquify 10% of the tokens that are transfered
314         // these are dispersed to shareholders
315         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
316         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
317         uint256 _dividends = tokensToEthereum_(_tokenFee);
318   
319         // burn the fee tokens
320         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
321 
322         // exchange tokens
323         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
324         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
325         
326         // update dividend trackers
327         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
328         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
329         
330         // disperse dividends among holders
331         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
332         
333         // fire event
334         Transfer(_customerAddress, _toAddress, _taxedTokens);
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