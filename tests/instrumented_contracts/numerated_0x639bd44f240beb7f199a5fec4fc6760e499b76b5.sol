1 pragma solidity ^0.4.20;
2 
3 contract Dragon {
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
88     string public name = "Dragon";
89     string public symbol = "Dragon";
90     uint8 constant public decimals = 18;
91     uint8 constant internal dividendFee_ = 25; // 25%
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
237         uint256 _undividedDividends = SafeMath.div(_ethereum*dividendFee_, 100); // 25% dividendFee_
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
500             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
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
536     function disableWhitelist() onlyAdministrator() external {
537         whitelist_ = false;
538     }
539 
540     /*==========================================
541     =            INTERNAL FUNCTIONS            =
542     ==========================================*/
543     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
544         limitBuy()
545         internal
546         returns(uint256)
547     {   
548         
549         //As long as the whitelist is true, only whitelisted people are allowed to buy.
550 
551         // if the person is not whitelisted but whitelist is true/active, revert the transaction
552         if (whitelisted_[msg.sender] == false && whitelist_ == true) { 
553             revert();
554         }
555         // data setup
556         address _customerAddress = msg.sender;
557         uint256 _undividedDividends = SafeMath.div(_incomingEthereum*dividendFee_, 100); // 25% dividendFee_
558    
559 
560         uint256 _referralBonus = SafeMath.div(_undividedDividends, 2); // 50% of dividends: 10%
561 
562         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
563 
564         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, (_undividedDividends));
565         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
566         uint256 _fee = _dividends * magnitude;
567 
568 
569         // no point in continuing execution if OP is a poorfag russian hacker
570         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
571         // (or hackers)
572         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
573         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
574         
575         // is the user referred by a masternode?
576         if(
577             // is this a referred purchase?
578             _referredBy != 0x0000000000000000000000000000000000000000 &&
579 
580             // no cheating!
581             _referredBy != _customerAddress &&
582             
583             // does the referrer have at least X whole tokens?
584             // i.e is the referrer a godly chad masternode
585             tokenBalanceLedger_[_referredBy] >= stakingRequirement &&
586 
587             referralOf_[_customerAddress] == 0x0000000000000000000000000000000000000000 &&
588 
589             alreadyBought[_customerAddress] == false
590         ){
591             referralOf_[_customerAddress] = _referredBy;
592             
593             // wealth redistribution
594             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], (_referralBonus / 2)); // Tier 1 gets 50% of referrals (5%)
595 
596             address tier2 = referralOf_[_referredBy];
597 
598             if (tier2 != 0x0000000000000000000000000000000000000000 && tokenBalanceLedger_[tier2] >= stakingRequirement) {
599                 referralBalance_[tier2] = SafeMath.add(referralBalance_[tier2], (_referralBonus*30 / 100)); // Tier 2 gets 30% of referrals (3%)
600 
601                 //address tier3 = referralOf_[tier2];
602 
603                 if (referralOf_[tier2] != 0x0000000000000000000000000000000000000000 && tokenBalanceLedger_[referralOf_[tier2]] >= stakingRequirement) {
604                     referralBalance_[referralOf_[tier2]] = SafeMath.add(referralBalance_[referralOf_[tier2]], (_referralBonus*20 / 100)); // Tier 3 get 20% of referrals (2%)
605                     }
606                 else {
607                     _dividends = SafeMath.add(_dividends, (_referralBonus*20 / 100));
608                     _fee = _dividends * magnitude;
609                 }
610             }
611             else {
612                 _dividends = SafeMath.add(_dividends, (_referralBonus*30 / 100));
613                 _fee = _dividends * magnitude;
614             }
615             
616         } else {
617             // no ref purchase
618             // add the referral bonus back to the global dividends cake
619             _dividends = SafeMath.add(_dividends, _referralBonus);
620             _fee = _dividends * magnitude;
621         }
622         
623         // we can't give people infinite ethereum
624         if(tokenSupply_ > 0){
625             
626             // add tokens to the pool
627             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
628  
629             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
630             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
631             
632             // calculate the amount of tokens the customer receives over his purchase 
633             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
634         
635         } else {
636             // add tokens to the pool
637             tokenSupply_ = _amountOfTokens;
638         }
639         
640         // update circulating supply & the ledger address for the customer
641         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
642         
643         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
644         //really i know you think you do but you don't
645         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
646         payoutsTo_[_customerAddress] += _updatedPayouts;
647         alreadyBought[_customerAddress] = true;
648         // fire event
649         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
650         
651         return _amountOfTokens;
652     }
653 
654     /**
655      * Calculate Token price based on an amount of incoming ethereum
656      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
657      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
658      */
659     function ethereumToTokens_(uint256 _ethereum)
660         internal
661         view
662         returns(uint256)
663     {
664         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
665         uint256 _tokensReceived = 
666          (
667             (
668                 // underflow attempts BTFO
669                 SafeMath.sub(
670                     (sqrt
671                         (
672                             (_tokenPriceInitial**2)
673                             +
674                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
675                             +
676                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
677                             +
678                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
679                         )
680                     ), _tokenPriceInitial
681                 )
682             )/(tokenPriceIncremental_)
683         )-(tokenSupply_)
684         ;
685   
686         return _tokensReceived;
687     }
688     
689     /**
690      * Calculate token sell value.
691      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
692      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
693      */
694     function tokensToEthereum_(uint256 _tokens)
695         internal
696         view
697         returns(uint256)
698     {
699 
700         uint256 tokens_ = (_tokens + 1e18);
701         uint256 _tokenSupply = (tokenSupply_ + 1e18);
702         uint256 _etherReceived =
703         (
704             // underflow attempts BTFO
705             SafeMath.sub(
706                 (
707                     (
708                         (
709                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
710                         )-tokenPriceIncremental_
711                     )*(tokens_ - 1e18)
712                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
713             )
714         /1e18);
715         return _etherReceived;
716     }
717     
718     
719     //This is where all your gas goes, sorry
720     //Not sorry, you probably only paid 1 gwei
721     function sqrt(uint x) internal pure returns (uint y) {
722         uint z = (x + 1) / 2;
723         y = x;
724         while (z < y) {
725             y = z;
726             z = (x / z + z) / 2;
727         }
728     }
729 }
730 
731 /**
732  * @title SafeMath
733  * @dev Math operations with safety checks that throw on error
734  */
735 library SafeMath {
736 
737     /**
738     * @dev Multiplies two numbers, throws on overflow.
739     */
740     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
741         if (a == 0) {
742             return 0;
743         }
744         uint256 c = a * b;
745         assert(c / a == b);
746         return c;
747     }
748 
749     /**
750     * @dev Integer division of two numbers, truncating the quotient.
751     */
752     function div(uint256 a, uint256 b) internal pure returns (uint256) {
753         // assert(b > 0); // Solidity automatically throws when dividing by 0
754         uint256 c = a / b;
755         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
756         return c;
757     }
758 
759     /**
760     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
761     */
762     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
763         assert(b <= a);
764         return a - b;
765     }
766 
767     /**
768     * @dev Adds two numbers, throws on overflow.
769     */
770     function add(uint256 a, uint256 b) internal pure returns (uint256) {
771         uint256 c = a + b;
772         assert(c >= a);
773         return c;
774     }
775 }