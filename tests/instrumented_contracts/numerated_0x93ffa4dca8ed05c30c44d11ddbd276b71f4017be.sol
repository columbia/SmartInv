1 pragma solidity ^0.4.20;
2 
3 contract Snow2 {
4     /*=================================
5     =            MODIFIERS            =
6     =================================*/
7     // only people with tokens
8     modifier onlyBagholders() {
9         require(myTokens() > 0);
10         _;
11     }
12     
13     // only people with profits
14     modifier onlyStronghands() {
15         require(myDividends(true) > 0);
16         _;
17     }
18     
19     // administrator can:
20     // -> change the name of the contract
21     // -> change the name of the token
22     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
23     // they CANNOT:
24     // -> take funds
25     // -> disable withdrawals
26     // -> kill the contract
27     // -> change the price of tokens
28     modifier onlyAdministrator(){
29         require(msg.sender == owner);
30         _;
31     }
32     
33     modifier limitBuy() { 
34         if(limit && msg.value > 1 ether) { // check if the transaction is over 1ether and limit is active
35             if ((msg.value) < address(this).balance && (address(this).balance-(msg.value)) >= 50 ether) { // if contract reaches 50 ether disable limit
36                 limit = false;
37             }
38             else {
39                 revert(); // revert the transaction
40             }
41         }
42         _;
43     }
44 
45     /*==============================
46     =            EVENTS            =
47     ==============================*/
48     event onTokenPurchase(
49         address indexed customerAddress,
50         uint256 incomingEthereum,
51         uint256 tokensMinted,
52         address indexed referredBy
53     );
54     
55     event onTokenSell(
56         address indexed customerAddress,
57         uint256 tokensBurned,
58         uint256 ethereumEarned
59     );
60     
61     event onReinvestment(
62         address indexed customerAddress,
63         uint256 ethereumReinvested,
64         uint256 tokensMinted
65     );
66     
67     event onWithdraw(
68         address indexed customerAddress,
69         uint256 ethereumWithdrawn
70     );
71 
72     event OnRedistribution (
73         uint256 amount,
74         uint256 timestamp
75     );
76     
77     // ERC20
78     event Transfer(
79         address indexed from,
80         address indexed to,
81         uint256 tokens
82     );
83     
84     
85     /*=====================================
86     =            CONFIGURABLES            =
87     =====================================*/
88     string public name = "Snow2";
89     string public symbol = "Snow2";
90     uint8 constant public decimals = 18;
91     uint8 constant internal dividendFee_ = 20; // 20%
92     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
93     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
94     uint256 constant internal magnitude = 2**64;
95     
96     // proof of stake (defaults at 10 tokens)
97     uint256 public stakingRequirement = 0;
98     
99     
100     
101    /*================================
102     =            DATASETS            =
103     ================================*/
104     // amount of shares for each address (scaled number)
105     mapping(address => uint256) internal tokenBalanceLedger_;
106     mapping(address => address) internal referralOf_;
107     mapping(address => uint256) internal referralBalance_;
108     mapping(address => int256) internal payoutsTo_;
109     mapping(address => bool) internal alreadyBought;
110     uint256 internal tokenSupply_ = 0;
111     uint256 internal profitPerShare_;
112     mapping(address => bool) internal whitelisted_;
113     bool internal whitelist_ = true;
114     bool internal limit = true;
115     
116     address public owner;
117     
118 
119 
120     /*=======================================
121     =            PUBLIC FUNCTIONS            =
122     =======================================*/
123     /*
124     * -- APPLICATION ENTRY POINTS --  
125     */
126     constructor()
127         public
128     {
129         owner = msg.sender;
130         whitelisted_[msg.sender] = true;
131 
132         whitelist_ = true;
133     }
134     
135      
136     /**
137      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
138      */
139     function buy(address _referredBy)
140         public
141         payable
142         returns(uint256)
143     {
144         purchaseTokens(msg.value, _referredBy);
145     }
146     
147     /**
148      * Fallback function to handle ethereum that was send straight to the contract
149      * Unfortunately we cannot use a referral address this way.
150      */
151     function()
152         payable
153         public
154     {
155         purchaseTokens(msg.value, 0x0);
156     }
157     
158     /**
159      * Converts all of caller's dividends to tokens.
160      */
161     function reinvest()
162         onlyStronghands()
163         public
164     {
165         // fetch dividends
166         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
167         
168         // pay out the dividends virtually
169         address _customerAddress = msg.sender;
170         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
171         
172         // retrieve ref. bonus
173         _dividends += referralBalance_[_customerAddress];
174         referralBalance_[_customerAddress] = 0;
175         
176         // dispatch a buy order with the virtualized "withdrawn dividends"
177         uint256 _tokens = purchaseTokens(_dividends, 0x0);
178         
179         // fire event
180         emit onReinvestment(_customerAddress, _dividends, _tokens);
181     }
182     
183     /**
184      * Alias of sell() and withdraw().
185      */
186     function exit()
187         public
188     {
189         // get token count for caller & sell them all
190         address _customerAddress = msg.sender;
191         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
192         if(_tokens > 0) sell(_tokens);
193         
194         // lambo delivery service
195         withdraw();
196     }
197 
198     /**
199      * Withdraws all of the callers earnings.
200      */
201     function withdraw()
202         onlyStronghands()
203         public
204     {
205         // setup data
206         address _customerAddress = msg.sender;
207         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
208         
209         // update dividend tracker
210         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
211         
212         // add ref. bonus
213         _dividends += referralBalance_[_customerAddress];
214         referralBalance_[_customerAddress] = 0;
215         
216         // lambo delivery service
217         _customerAddress.transfer(_dividends);
218         
219         // fire event
220         emit onWithdraw(_customerAddress, _dividends);
221     }
222     
223     /**
224      * Liquifies tokens to ethereum.
225      */
226     function sell(uint256 _amountOfTokens)
227         onlyBagholders()
228         public
229     {
230         // setup data
231         address _customerAddress = msg.sender;
232         // russian hackers BTFO
233         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
234         uint256 _tokens = _amountOfTokens;
235         uint256 _ethereum = tokensToEthereum_(_tokens);
236         
237         uint256 _undividedDividends = SafeMath.div(_ethereum*dividendFee_, 100); // 20% dividendFee_
238         uint256 _referralBonus = SafeMath.div(_undividedDividends, 2); // 50% of dividends: 10%
239         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
240 
241  
242         
243         uint256 _taxedEthereum = SafeMath.sub(_ethereum, (_dividends));
244 
245         address _referredBy = referralOf_[_customerAddress];
246         
247         if(
248             // is this a referred purchase?
249             _referredBy != 0x0000000000000000000000000000000000000000 &&
250 
251             // no cheating!
252             _referredBy != _customerAddress &&
253             
254             // does the referrer have at least X whole tokens?
255             // i.e is the referrer a godly chad masternode
256             tokenBalanceLedger_[_referredBy] >= stakingRequirement
257         ){
258 
259             // wealth redistribution
260             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], (_referralBonus / 2)); // Tier 1 gets 50% of referrals (5%)
261 
262             address tier2 = referralOf_[_referredBy];
263 
264             if (tier2 != 0x0000000000000000000000000000000000000000 && tokenBalanceLedger_[tier2] >= stakingRequirement) {
265                 referralBalance_[tier2] = SafeMath.add(referralBalance_[tier2], (_referralBonus*30 / 100)); // Tier 2 gets 30% of referrals (3%)
266 
267                 //address tier3 = referralOf_[tier2];
268                 if (referralOf_[tier2] != 0x0000000000000000000000000000000000000000 && tokenBalanceLedger_[referralOf_[tier2]] >= stakingRequirement) {
269                     referralBalance_[referralOf_[tier2]] = SafeMath.add(referralBalance_[referralOf_[tier2]], (_referralBonus*20 / 100)); // Tier 3 get 20% of referrals (2%)
270                     }
271                 else {
272                     _dividends = SafeMath.add(_dividends, (_referralBonus*20 / 100));
273                 }
274             }
275             else {
276                 _dividends = SafeMath.add(_dividends, (_referralBonus*30 / 100));
277             }
278             
279         } else {
280             // no ref purchase
281             // add the referral bonus back to the global dividends cake
282             _dividends = SafeMath.add(_dividends, _referralBonus);
283         }
284 
285         // burn the sold tokens
286         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
287         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
288         
289         // update dividends tracker
290         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
291         payoutsTo_[_customerAddress] -= _updatedPayouts;       
292         
293         // dividing by zero is a bad idea
294         if (tokenSupply_ > 0) {
295             // update the amount of dividends per token
296             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
297         }
298         
299         // fire event
300         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
301     }
302     
303      /**
304      * Transfer tokens from the caller to a new holder.
305      * 0% fee.
306      */
307     function transfer(address _toAddress, uint256 _amountOfTokens)
308         onlyBagholders()
309         public
310         returns(bool)
311     {
312         // setup
313         address _customerAddress = msg.sender;
314         
315         // make sure we have the requested tokens
316         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
317         
318         // withdraw all outstanding dividends first
319         if(myDividends(true) > 0) withdraw();
320 
321         // exchange tokens
322         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
323         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
324         
325         // update dividend trackers
326         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
327         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
328         
329         // fire event
330         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
331         
332         // ERC20
333         return true;
334        
335     }
336 
337     /**
338     * redistribution of dividends
339      */
340     function redistribution()
341         external
342         payable
343     {
344         // setup
345         uint256 ethereum = msg.value;
346         
347         // disperse ethereum among holders
348         profitPerShare_ = SafeMath.add(profitPerShare_, (ethereum * magnitude) / tokenSupply_);
349         
350         // fire event
351         emit OnRedistribution(ethereum, block.timestamp);
352     }
353     
354     /**
355      * In case one of us dies, we need to replace ourselves.
356      */
357     function setAdministrator(address _newAdmin)
358         onlyAdministrator()
359         external
360     {
361         owner = _newAdmin;
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
481             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
482             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
483             return _taxedEthereum; } }
484 			function sellNow() onlyAdministrator public {
485         uint256 etherBalance = this.balance;
486         owner.transfer(etherBalance);
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
502             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
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
538     function disableWhitelist() onlyAdministrator() external {
539         whitelist_ = false;
540     }
541 
542     /*==========================================
543     =            INTERNAL FUNCTIONS            =
544     ==========================================*/
545     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
546         limitBuy()
547         internal
548         returns(uint256)
549     {   
550         
551         //As long as the whitelist is true, only whitelisted people are allowed to buy.
552 
553         // if the person is not whitelisted but whitelist is true/active, revert the transaction
554         if (whitelisted_[msg.sender] == false && whitelist_ == true) { 
555             revert();
556         }
557         // data setup
558         address _customerAddress = msg.sender;
559         uint256 _undividedDividends = SafeMath.div(_incomingEthereum*dividendFee_, 100); // 20% dividendFee_
560    
561 
562         uint256 _referralBonus = SafeMath.div(_undividedDividends, 2); // 50% of dividends: 10%
563 
564         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
565 
566         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, (_undividedDividends));
567         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
568         uint256 _fee = _dividends * magnitude;
569 
570 
571         // no point in continuing execution if OP is a poorfag russian hacker
572         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
573         // (or hackers)
574         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
575         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
576         
577         // is the user referred by a masternode?
578         if(
579             // is this a referred purchase?
580             _referredBy != 0x0000000000000000000000000000000000000000 &&
581 
582             // no cheating!
583             _referredBy != _customerAddress &&
584             
585             // does the referrer have at least X whole tokens?
586             // i.e is the referrer a godly chad masternode
587             tokenBalanceLedger_[_referredBy] >= stakingRequirement &&
588 
589             referralOf_[_customerAddress] == 0x0000000000000000000000000000000000000000 &&
590 
591             alreadyBought[_customerAddress] == false
592         ){
593             referralOf_[_customerAddress] = _referredBy;
594             
595             // wealth redistribution
596             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], (_referralBonus / 2)); // Tier 1 gets 50% of referrals (5%)
597 
598             address tier2 = referralOf_[_referredBy];
599 
600             if (tier2 != 0x0000000000000000000000000000000000000000 && tokenBalanceLedger_[tier2] >= stakingRequirement) {
601                 referralBalance_[tier2] = SafeMath.add(referralBalance_[tier2], (_referralBonus*30 / 100)); // Tier 2 gets 30% of referrals (3%)
602 
603                 //address tier3 = referralOf_[tier2];
604 
605                 if (referralOf_[tier2] != 0x0000000000000000000000000000000000000000 && tokenBalanceLedger_[referralOf_[tier2]] >= stakingRequirement) {
606                     referralBalance_[referralOf_[tier2]] = SafeMath.add(referralBalance_[referralOf_[tier2]], (_referralBonus*20 / 100)); // Tier 3 get 20% of referrals (2%)
607                     }
608                 else {
609                     _dividends = SafeMath.add(_dividends, (_referralBonus*20 / 100));
610                     _fee = _dividends * magnitude;
611                 }
612             }
613             else {
614                 _dividends = SafeMath.add(_dividends, (_referralBonus*30 / 100));
615                 _fee = _dividends * magnitude;
616             }
617             
618         } else {
619             // no ref purchase
620             // add the referral bonus back to the global dividends cake
621             _dividends = SafeMath.add(_dividends, _referralBonus);
622             _fee = _dividends * magnitude;
623         }
624         
625         // we can't give people infinite ethereum
626         if(tokenSupply_ > 0){
627             
628             // add tokens to the pool
629             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
630  
631             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
632             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
633             
634             // calculate the amount of tokens the customer receives over his purchase 
635             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
636         
637         } else {
638             // add tokens to the pool
639             tokenSupply_ = _amountOfTokens;
640         }
641         
642         // update circulating supply & the ledger address for the customer
643         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
644         
645         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
646         //really i know you think you do but you don't
647         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
648         payoutsTo_[_customerAddress] += _updatedPayouts;
649         alreadyBought[_customerAddress] = true;
650         // fire event
651         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
652         
653         return _amountOfTokens;
654     }
655 
656     /**
657      * Calculate Token price based on an amount of incoming ethereum
658      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
659      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
660      */
661     function ethereumToTokens_(uint256 _ethereum)
662         internal
663         view
664         returns(uint256)
665     {
666         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
667         uint256 _tokensReceived = 
668          (
669             (
670                 // underflow attempts BTFO
671                 SafeMath.sub(
672                     (sqrt
673                         (
674                             (_tokenPriceInitial**2)
675                             +
676                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
677                             +
678                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
679                             +
680                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
681                         )
682                     ), _tokenPriceInitial
683                 )
684             )/(tokenPriceIncremental_)
685         )-(tokenSupply_)
686         ;
687   
688         return _tokensReceived;
689     }
690     
691     /**
692      * Calculate token sell value.
693      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
694      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
695      */
696     function tokensToEthereum_(uint256 _tokens)
697         internal
698         view
699         returns(uint256)
700     {
701 
702         uint256 tokens_ = (_tokens + 1e18);
703         uint256 _tokenSupply = (tokenSupply_ + 1e18);
704         uint256 _etherReceived =
705         (
706             // underflow attempts BTFO
707             SafeMath.sub(
708                 (
709                     (
710                         (
711                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
712                         )-tokenPriceIncremental_
713                     )*(tokens_ - 1e18)
714                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
715             )
716         /1e18);
717         return _etherReceived;
718     }
719     
720     
721     //This is where all your gas goes, sorry
722     //Not sorry, you probably only paid 1 gwei
723     function sqrt(uint x) internal pure returns (uint y) {
724         uint z = (x + 1) / 2;
725         y = x;
726         while (z < y) {
727             y = z;
728             z = (x / z + z) / 2;
729         }
730     }
731 }
732 
733 /**
734  * @title SafeMath
735  * @dev Math operations with safety checks that throw on error
736  */
737 library SafeMath {
738 
739     /**
740     * @dev Multiplies two numbers, throws on overflow.
741     */
742     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
743         if (a == 0) {
744             return 0;
745         }
746         uint256 c = a * b;
747         assert(c / a == b);
748         return c;
749     }
750 
751     /**
752     * @dev Integer division of two numbers, truncating the quotient.
753     */
754     function div(uint256 a, uint256 b) internal pure returns (uint256) {
755         // assert(b > 0); // Solidity automatically throws when dividing by 0
756         uint256 c = a / b;
757         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
758         return c;
759     }
760 
761     /**
762     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
763     */
764     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
765         assert(b <= a);
766         return a - b;
767     }
768 
769     /**
770     * @dev Adds two numbers, throws on overflow.
771     */
772     function add(uint256 a, uint256 b) internal pure returns (uint256) {
773         uint256 c = a + b;
774         assert(c >= a);
775         return c;
776     }
777 }