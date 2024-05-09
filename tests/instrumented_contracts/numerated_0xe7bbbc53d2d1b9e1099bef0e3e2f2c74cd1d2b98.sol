1 pragma solidity ^0.4.20;
2 
3 contract Lucky8d {
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
34         if(limit && msg.value > 2 ether && msg.sender != owner) { // check if the transaction is over 2ether and limit is active
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
88     string public name = "Lucky8D";
89     string public symbol = "Lucky";
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
131         // WorldFomo Divs Account
132         whitelisted_[0x8B4cE0C6021eb6AA43B854fB262E03F207e9ceBb] = true;
133 
134         whitelist_ = true;
135     }
136 
137 
138     /**
139      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
140      */
141     function buy(address _referredBy)
142         public
143         payable
144         returns(uint256)
145     {
146         purchaseTokens(msg.value, _referredBy);
147     }
148 
149     /**
150      * Fallback function to handle ethereum that was send straight to the contract
151      * Unfortunately we cannot use a referral address this way.
152      */
153     function()
154         payable
155         public
156     {
157         purchaseTokens(msg.value, 0x0);
158     }
159 
160     /**
161      * Converts all of caller's dividends to tokens.
162      */
163     function reinvest()
164         onlyStronghands()
165         public
166     {
167         // fetch dividends
168         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
169 
170         // pay out the dividends virtually
171         address _customerAddress = msg.sender;
172         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
173 
174         // retrieve ref. bonus
175         _dividends += referralBalance_[_customerAddress];
176         referralBalance_[_customerAddress] = 0;
177 
178         // dispatch a buy order with the virtualized "withdrawn dividends"
179         uint256 _tokens = purchaseTokens(_dividends, 0x0);
180 
181         // fire event
182         emit onReinvestment(_customerAddress, _dividends, _tokens);
183     }
184 
185     /**
186      * Alias of sell() and withdraw().
187      */
188     function exit()
189         public
190     {
191         // get token count for caller & sell them all
192         address _customerAddress = msg.sender;
193         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
194         if(_tokens > 0) sell(_tokens);
195 
196         // lambo delivery service
197         withdraw();
198     }
199 
200     /**
201      * Withdraws all of the callers earnings.
202      */
203     function withdraw()
204         onlyStronghands()
205         public
206     {
207         // setup data
208         address _customerAddress = msg.sender;
209         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
210 
211         // update dividend tracker
212         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
213 
214         // add ref. bonus
215         _dividends += referralBalance_[_customerAddress];
216         referralBalance_[_customerAddress] = 0;
217 
218         // lambo delivery service
219         _customerAddress.transfer(_dividends);
220 
221         // fire event
222         emit onWithdraw(_customerAddress, _dividends);
223     }
224 
225     /**
226      * Liquifies tokens to ethereum.
227      */
228     function sell(uint256 _amountOfTokens)
229         onlyBagholders()
230         public
231     {
232         // setup data
233         address _customerAddress = msg.sender;
234         // russian hackers BTFO
235         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
236         uint256 _tokens = _amountOfTokens;
237         uint256 _ethereum = tokensToEthereum_(_tokens);
238 
239         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100); // 20% dividendFee_
240         uint256 _referralBonus = SafeMath.div(_undividedDividends, 2); // 50% of dividends: 10%
241         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
242 
243 
244 
245         uint256 _taxedEthereum = SafeMath.sub(_ethereum, (_dividends));
246 
247         address _referredBy = referralOf_[_customerAddress];
248 
249         if(
250             // is this a referred purchase?
251             _referredBy != 0x0000000000000000000000000000000000000000 &&
252 
253             // no cheating!
254             _referredBy != _customerAddress &&
255 
256             // does the referrer have at least X whole tokens?
257             // i.e is the referrer a godly chad masternode
258             tokenBalanceLedger_[_referredBy] >= stakingRequirement
259         ){
260 
261             // wealth redistribution
262             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], (_referralBonus / 2)); // Tier 1 gets 50% of referrals (5%)
263 
264             address tier2 = referralOf_[_referredBy];
265 
266             if (tier2 != 0x0000000000000000000000000000000000000000 && tokenBalanceLedger_[tier2] >= stakingRequirement) {
267                 referralBalance_[tier2] = SafeMath.add(referralBalance_[tier2], (_referralBonus*30 / 100)); // Tier 2 gets 30% of referrals (3%)
268 
269                 //address tier3 = referralOf_[tier2];
270                 if (referralOf_[tier2] != 0x0000000000000000000000000000000000000000 && tokenBalanceLedger_[referralOf_[tier2]] >= stakingRequirement) {
271                     referralBalance_[referralOf_[tier2]] = SafeMath.add(referralBalance_[referralOf_[tier2]], (_referralBonus*20 / 100)); // Tier 3 get 20% of referrals (2%)
272                     }
273                 else {
274                     _dividends = SafeMath.add(_dividends, (_referralBonus*20 / 100));
275                 }
276             }
277             else {
278                 _dividends = SafeMath.add(_dividends, (_referralBonus*30 / 100));
279             }
280 
281         } else {
282             // no ref purchase
283             // add the referral bonus back to the global dividends cake
284             _dividends = SafeMath.add(_dividends, _referralBonus);
285         }
286 
287         // burn the sold tokens
288         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
289         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
290 
291         // update dividends tracker
292         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
293         payoutsTo_[_customerAddress] -= _updatedPayouts;
294 
295         // dividing by zero is a bad idea
296         if (tokenSupply_ > 0) {
297             // update the amount of dividends per token
298             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
299         }
300 
301         // fire event
302         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
303     }
304 
305      /**
306      * Transfer tokens from the caller to a new holder.
307      * 0% fee.
308      */
309     function transfer(address _toAddress, uint256 _amountOfTokens)
310         onlyBagholders()
311         public
312         returns(bool)
313     {
314         // setup
315         address _customerAddress = msg.sender;
316 
317         // make sure we have the requested tokens
318         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
319 
320         // withdraw all outstanding dividends first
321         if(myDividends(true) > 0) withdraw();
322 
323         // exchange tokens
324         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
325         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
326 
327         // update dividend trackers
328         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
329         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
330 
331         // fire event
332         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
333 
334         // ERC20
335         return true;
336 
337     }
338 
339     /**
340     * redistribution of dividends
341      */
342     function redistribution()
343         external
344         payable
345     {
346         // setup
347         uint256 ethereum = msg.value;
348 
349         // disperse ethereum among holders
350         profitPerShare_ = SafeMath.add(profitPerShare_, (ethereum * magnitude) / tokenSupply_);
351 
352         // fire event
353         emit OnRedistribution(ethereum, block.timestamp);
354     }
355 
356     /**
357      * In case one of us dies, we need to replace ourselves.
358      */
359     function setAdministrator(address _newAdmin)
360         onlyAdministrator()
361         external
362     {
363         owner = _newAdmin;
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
407         return address(this).balance;
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
483             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_),100);
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
502             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_),100);
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
516         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_),100);
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
533         uint256 _dividends =  SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
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
559         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100); // 20% dividendFee_
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