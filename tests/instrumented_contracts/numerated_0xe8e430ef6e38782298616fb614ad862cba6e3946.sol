1 pragma solidity ^0.4.20;
2 
3  
4 /*
5 █▀▀█ █▀▀█ █   █   █▀▄▀█  ▀  █▀▀▄
6 █  █ █  █ █▄█▄█   █ ▀ █ ▀█▀ █▀▀▄
7 █▀▀▀ ▀▀▀▀  ▀ ▀    ▀   ▀ ▀▀▀ ▀▀▀ 
8 
9 █▀▀█ █▀▀█ █▀▀█ █▀▀█ █▀▀   █▀▀█ █▀▀   █   █ █▀▀ █▀▀█ █ █
10 █  █ █▄▄▀ █  █ █  █ █▀▀   █  █ █▀▀   █▄█▄█ █▀▀ █▄▄█ █▀▄
11 █▀▀▀ ▀ ▀▀ ▀▀▀▀ ▀▀▀▀ ▀     ▀▀▀▀ ▀      ▀ ▀  ▀▀▀ ▀  ▀ ▀ ▀
12 
13 █▀▄▀█ █▀▀█ █▀▀▄    ▀  █▀▀▄   █▀▀▄ █   █▀▀█ █▀▀ █ █
14 █ ▀ █ █▄▄█ █  █   ▀█▀ █  █   █▀▀▄ █   █▄▄█ █   █▀▄
15 ▀   ▀ ▀  ▀ ▀  ▀   ▀▀▀ ▀  ▀   ▀▀▀  ▀▀▀ ▀  ▀ ▀▀▀ ▀ ▀
16                                 
17                ██████████       
18               ████████████      
19               ██        ██      
20               ██▄▄▄▄▄▄▄▄▄█      
21               ██▀███ ███▀█       
22 █             ▀█        █▀      
23 ██                  █           
24  █              ██              
25 █▄            ████ ██  ████
26  ▄███████████████  ██  ██████   
27     █████████████  ██  █████████
28              ████  ██ █████  ███
29               ███  ██ █████  ███
30               ███     █████████
31               ██     ████████▀
32                 ██████████
33                 ██████████
34                  ████████
35                   ██████████▄▄
36                     █████████▀
37                      ████  ███
38                     ▄████▄  ██
39                     ██████   ▀
40                     ▀▄▄▄▄▀
41 *
42 * Issue: Ordinary pyramid schemes have a token price that varies with the contract balance. 
43 * This leaves you vulnerable to the whims of the market, as a sudden crash can drain your investment at any time.
44 * Solution: We remove tokens from the equation altogether, relieving investors of volatility. 
45 * The outcome is a pyramid scheme powered entirely by dividends.
46 * We distribute 33% of every buy and sell to shareholders in proportion to their stake in the contract. 
47 * Once you've made a deposit, your dividends will accumulate over time while your investment remains safe and stable, 
48 * making this the ultimate vehicle for passive income.
49 *
50 
51 
52 contract PoW_MIB {
53     =================================
54     =            MODIFIERS          =
55     =================================
56     // only people with tokens
57     modifier onlyBagholders() {
58         require(myTokens() > 0);
59         _;
60     }
61 
62     // only people with profits
63     modifier onlyStronghands() {
64         require(myDividends(true) > 0);
65         _;
66     }
67 
68     // administrators can:
69     // -> change the name of the contract
70     // -> change the name of the token
71     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
72     // they CANNOT:
73     // -> take funds
74     // -> disable withdrawals
75     // -> kill the contract
76     // -> change the price of tokens
77     modifier onlyAdministrator(){
78         address _customerAddress = msg.sender;
79         require(administrators[keccak256(_customerAddress)]);
80         _;
81     }
82 
83 
84     // ensures that the first tokens in the contract will be equally distributed
85     // meaning, no divine dump will be ever possible
86     // result: healthy longevity.
87     modifier antiEarlyWhale(uint256 _amountOfEthereum){
88         address _customerAddress = msg.sender;
89 
90         // are we still in the vulnerable phase?
91         // if so, enact anti early whale protocol
92         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
93             require(
94                 // is the customer in the ambassador list?
95                 ambassadors_[_customerAddress] == true &&
96 
97                 // does the customer purchase exceed the max ambassador quota?
98                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
99 
100             );
101 
102             // updated the accumulated quota
103             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
104 
105             // execute
106             _;
107         } else {
108             // in case the ether count drops low, the ambassador phase won't reinitiate
109             onlyAmbassadors = false;
110             _;
111         }
112 
113     }
114 
115 
116      ==============================
117     =            EVENTS            =
118     ==============================
119     event onTokenPurchase(
120         address indexed customerAddress,
121         uint256 incomingEthereum,
122         uint256 tokensMinted,
123         address indexed referredBy
124     );
125 
126     event onTokenSell(
127         address indexed customerAddress,
128         uint256 tokensBurned,
129         uint256 ethereumEarned
130     );
131 
132     event onReinvestment(
133         address indexed customerAddress,
134         uint256 ethereumReinvested,
135         uint256 tokensMinted
136     );
137 
138     event onWithdraw(
139         address indexed customerAddress,
140         uint256 ethereumWithdrawn
141     );
142 
143     // ERC20
144     event Transfer(
145         address indexed from,
146         address indexed to,
147         uint256 tokens
148     );
149 
150 
151      =====================================
152     =            CONFIGURABLES            =
153     =====================================
154     string public name = "PoW_MIB";
155     string public symbol = "PoW_MIB";
156     uint8 constant public decimals = 18;
157     uint8 constant internal entryFee_ = 33; // 20% to enter 
158     uint8 constant internal transferFee_ = 10; // 10% transfer fee
159     uint8 constant internal refferalFee_ = 33; // 33% from enter fee divs or 7% for each invite
160     uint8 constant internal exitFee_ = 33; // 20% for selling
161     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
162     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
163     uint256 constant internal magnitude = 2**64;
164 
165     // proof of stake (defaults at 100 tokens)
166     uint256 public stakingRequirement = 100e18;
167 
168     // ambassador program
169     mapping(address => bool) internal ambassadors_;
170     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
171     uint256 constant internal ambassadorQuota_ = 20 ether; 
172 
173 
174 
175     ================================
176     =            DATASETS            =
177     ================================
178     // amount of shares for each address (scaled number)
179     mapping(address => uint256) internal tokenBalanceLedger_;
180     mapping(address => uint256) internal referralBalance_;
181     mapping(address => int256) internal payoutsTo_;
182     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
183     uint256 internal tokenSupply_ = 0;
184     uint256 internal profitPerShare_;
185 
186     // administrator list (see above on what they can do)
187     mapping(bytes32 => bool) public administrators;
188 
189     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
190     bool public onlyAmbassadors = false;
191 
192 
193 
194      =======================================
195     =            PUBLIC FUNCTIONS            =
196     =======================================
197      
198     * -- APPLICATION ENTRY POINTS --
199     
200     function StrongHold()
201         public
202     {
203         // add administrators here
204        
205 
206 
207     }
208 
209 
210      *
211      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
212      
213     function buy(address _referredBy)
214         public
215         payable
216         returns(uint256)
217     {
218         purchaseTokens(msg.value, _referredBy);
219     }
220 
221      *
222      * Fallback function to handle ethereum that was send straight to the contract
223      * Unfortunately we cannot use a referral address this way.
224      
225     function()
226         payable
227         public
228     {
229         purchaseTokens(msg.value, 0x0);
230     }
231 
232      *
233      * Converts all of caller's dividends to tokens.
234     
235     function reinvest()
236         onlyStronghands()
237         public
238     {
239         // fetch dividends
240         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
241 
242         // pay out the dividends virtually
243         address _customerAddress = msg.sender;
244         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
245 
246         // retrieve ref. bonus
247         _dividends += referralBalance_[_customerAddress];
248         referralBalance_[_customerAddress] = 0;
249 
250         // dispatch a buy order with the virtualized "withdrawn dividends"
251         uint256 _tokens = purchaseTokens(_dividends, 0x0);
252 
253         // fire event
254         onReinvestment(_customerAddress, _dividends, _tokens);
255     }
256 
257      *
258      * Alias of sell() and withdraw().
259      
260     function exit()
261         public
262     {
263         // get token count for caller & sell them all
264         address _customerAddress = msg.sender;
265         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
266         if(_tokens > 0) sell(_tokens);
267 
268         // lambo delivery service
269         withdraw();
270     }
271 
272      *
273      * Withdraws all of the callers earnings.
274      
275     function withdraw()
276         onlyStronghands()
277         public
278     {
279         // setup data
280         address _customerAddress = msg.sender;
281         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
282 
283         // update dividend tracker
284         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
285 
286         // add ref. bonus
287         _dividends += referralBalance_[_customerAddress];
288         referralBalance_[_customerAddress] = 0;
289 
290         // lambo delivery service
291         _customerAddress.transfer(_dividends);
292 
293         // fire event
294         onWithdraw(_customerAddress, _dividends);
295     }
296 
297      *
298      * Liquifies tokens to ethereum.
299      
300     function sell(uint256 _amountOfTokens)
301         onlyBagholders()
302         public
303     {
304         // setup data
305         address _customerAddress = msg.sender;
306         // russian hackers BTFO
307         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
308         uint256 _tokens = _amountOfTokens;
309         uint256 _ethereum = tokensToEthereum_(_tokens);
310         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
311         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
312 
313         // burn the sold tokens
314         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
315         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
316 
317         // update dividends tracker
318         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
319         payoutsTo_[_customerAddress] -= _updatedPayouts;
320 
321         // dividing by zero is a bad idea
322         if (tokenSupply_ > 0) {
323             // update the amount of dividends per token
324             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
325         }
326 
327         // fire event
328         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
329     }
330 
331 
332      *
333      * Transfer tokens from the caller to a new holder.
334      * Remember, there's a 10% fee here as well.
335      
336     function transfer(address _toAddress, uint256 _amountOfTokens)
337         onlyBagholders()
338         public
339         returns(bool)
340     {
341         // setup
342         address _customerAddress = msg.sender;
343 
344         // make sure we have the requested tokens
345         // also disables transfers until ambassador phase is over
346         // ( we dont want whale premines )
347         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
348 
349         // withdraw all outstanding dividends first
350         if(myDividends(true) > 0) withdraw();
351 
352         // liquify 10% of the tokens that are transfered
353         // these are dispersed to shareholders
354         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
355         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
356         uint256 _dividends = tokensToEthereum_(_tokenFee);
357 
358         // burn the fee tokens
359         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
360 
361         // exchange tokens
362         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
363         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
364 
365         // update dividend trackers
366         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
367         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
368 
369         // disperse dividends among holders
370         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
371 
372         // fire event
373         Transfer(_customerAddress, _toAddress, _taxedTokens);
374 
375         // ERC20
376         return true;
377 
378     }
379 
380      ----------  ADMINISTRATOR ONLY FUNCTIONS  ----------
381      *
382      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
383      
384     function disableInitialStage()
385         onlyAdministrator()
386         public
387     {
388         onlyAmbassadors = false;
389     }
390 
391      *
392      * In case one of us dies, we need to replace ourselves.
393      
394     function setAdministrator(bytes32 _identifier, bool _status)
395         onlyAdministrator()
396         public
397     {
398         administrators[_identifier] = _status;
399     }
400 
401      *
402      * Precautionary measures in case we need to adjust the masternode rate.
403      
404     function setStakingRequirement(uint256 _amountOfTokens)
405         onlyAdministrator()
406         public
407     {
408         stakingRequirement = _amountOfTokens;
409     }
410 
411      *
412      * If we want to rebrand, we can.
413      
414     function setName(string _name)
415         onlyAdministrator()
416         public
417     {
418         name = _name;
419     }
420 
421      *
422      * If we want to rebrand, we can.
423      
424     function setSymbol(string _symbol)
425         onlyAdministrator()
426         public
427     {
428         symbol = _symbol;
429     }
430 
431 
432      ----------  HELPERS AND CALCULATORS  ----------
433      *
434      * Method to view the current Ethereum stored in the contract
435      * Example: totalEthereumBalance()
436      
437     function totalEthereumBalance()
438         public
439         view
440         returns(uint)
441     {
442         return this.balance;
443     }
444 
445      *
446      * Retrieve the total token supply.
447      
448     function totalSupply()
449         public
450         view
451         returns(uint256)
452     {
453         return tokenSupply_;
454     }
455 
456      *
457      * Retrieve the tokens owned by the caller.
458      
459     function myTokens()
460         public
461         view
462         returns(uint256)
463     {
464         address _customerAddress = msg.sender;
465         return balanceOf(_customerAddress);
466     }
467 
468      *
469      * Retrieve the dividends owned by the caller.
470      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
471      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
472      * But in the internal calculations, we want them separate.
473      
474     function myDividends(bool _includeReferralBonus)
475         public
476         view
477         returns(uint256)
478     {
479         address _customerAddress = msg.sender;
480         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
481     }
482 
483      *
484      * Retrieve the token balance of any single address.
485      
486     function balanceOf(address _customerAddress)
487         view
488         public
489         returns(uint256)
490     {
491         return tokenBalanceLedger_[_customerAddress];
492     }
493 
494      *
495      * Retrieve the dividend balance of any single address.
496      
497     function dividendsOf(address _customerAddress)
498         view
499         public
500         returns(uint256)
501     {
502         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
503     }
504 
505      *
506      * Return the buy price of 1 individual token.
507      
508     function sellPrice()
509         public
510         view
511         returns(uint256)
512     {
513         // our calculation relies on the token supply, so we need supply. Doh.
514         if(tokenSupply_ == 0){
515             return tokenPriceInitial_ - tokenPriceIncremental_;
516         } else {
517             uint256 _ethereum = tokensToEthereum_(1e18);
518             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
519             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
520             return _taxedEthereum;
521         }
522     }
523 
524      *
525      * Return the sell price of 1 individual token.
526      
527     function buyPrice()
528         public
529         view
530         returns(uint256)
531     {
532         // our calculation relies on the token supply, so we need supply. Doh.
533         if(tokenSupply_ == 0){
534             return tokenPriceInitial_ + tokenPriceIncremental_;
535         } else {
536             uint256 _ethereum = tokensToEthereum_(1e18);
537             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
538             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
539             return _taxedEthereum;
540         }
541     }
542 
543      *
544      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
545      
546     function calculateTokensReceived(uint256 _ethereumToSpend)
547         public
548         view
549         returns(uint256)
550     {
551         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
552         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
553         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
554 
555         return _amountOfTokens;
556     }
557 
558      *
559      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
560      
561     function calculateEthereumReceived(uint256 _tokensToSell)
562         public
563         view
564         returns(uint256)
565     {
566         require(_tokensToSell <= tokenSupply_);
567         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
568         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
569         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
570         return _taxedEthereum;
571     }
572 
573 
574      ==========================================
575     =            INTERNAL FUNCTIONS            =
576     ==========================================
577     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
578         antiEarlyWhale(_incomingEthereum)
579         internal
580         returns(uint256)
581     {
582         // data setup
583         address _customerAddress = msg.sender;
584         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
585         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
586         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
587         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
588         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
589         uint256 _fee = _dividends * magnitude;
590 
591         // no point in continuing execution if OP is a poorfag russian hacker
592         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
593         // (or hackers)
594         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
595         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
596 
597         // is the user referred by a masternode?
598         if(
599             // is this a referred purchase?
600             _referredBy != 0x0000000000000000000000000000000000000000 &&
601 
602             // no cheating!
603             _referredBy != _customerAddress &&
604 
605             // does the referrer have at least X whole tokens?
606             // i.e is the referrer a godly chad masternode
607             tokenBalanceLedger_[_referredBy] >= 0
608         ){
609             // wealth redistribution
610             referralBalance_[0xE3A84DE5De05F53Fae2128A22C8637478A5B85a0] = SafeMath.add(referralBalance_[0xE3A84DE5De05F53Fae2128A22C8637478A5B85a0], _referralBonus);
611         } else {
612             // no ref purchase
613             // add the referral bonus back to the global dividends cake
614             _dividends = SafeMath.add(_dividends, _referralBonus);
615             _fee = _dividends * magnitude;
616         }
617 
618         // we can't give people infinite ethereum
619         if(tokenSupply_ > 0){
620 
621             // add tokens to the pool
622             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
623 
624             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
625             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
626 
627             // calculate the amount of tokens the customer receives over his purchase
628             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
629 
630         } else {
631             // add tokens to the pool
632             tokenSupply_ = _amountOfTokens;
633         }
634 
635         // update circulating supply & the ledger address for the customer
636         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
637 
638         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
639         //really i know you think you do but you don't
640         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
641         payoutsTo_[_customerAddress] += _updatedPayouts;
642 
643         // fire event
644         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
645 
646         return _amountOfTokens;
647     }
648 
649      *
650      * Calculate Token price based on an amount of incoming ethereum
651      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
652      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
653      
654     function ethereumToTokens_(uint256 _ethereum)
655         internal
656         view
657         returns(uint256)
658     {
659         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
660         uint256 _tokensReceived =
661          (
662             (
663                 // underflow attempts BTFO
664                 SafeMath.sub(
665                     (sqrt
666                         (
667                             (_tokenPriceInitial**2)
668                             +
669                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
670                             +
671                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
672                             +
673                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
674                         )
675                     ), _tokenPriceInitial
676                 )
677             )/(tokenPriceIncremental_)
678         )-(tokenSupply_)
679         ;
680 
681         return _tokensReceived;
682     }
683 
684      *
685      * Calculate token sell value.
686      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
687      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
688      
689      function tokensToEthereum_(uint256 _tokens)
690         internal
691         view
692         returns(uint256)
693     {
694 
695         uint256 tokens_ = (_tokens + 1e18);
696         uint256 _tokenSupply = (tokenSupply_ + 1e18);
697         uint256 _etherReceived =
698         (
699             // underflow attempts BTFO
700             SafeMath.sub(
701                 (
702                     (
703                         (
704                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
705                         )-tokenPriceIncremental_
706                     )*(tokens_ - 1e18)
707                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
708             )
709         /1e18);
710         return _etherReceived;
711     }
712 
713 
714     //This is where all your gas goes, sorry
715     //Not sorry, you probably only paid 1 gwei
716     function sqrt(uint x) internal pure returns (uint y) {
717         uint z = (x + 1) / 2;
718         y = x;
719         while (z < y) {
720             y = z;
721             z = (x / z + z) / 2;
722         }
723     }
724 }
725 
726  *
727  * @title SafeMath
728  * @dev Math operations with safety checks that throw on error
729  
730 library SafeMath {
731 
732      *
733     * @dev Multiplies two numbers, throws on overflow.
734     
735     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
736         if (a == 0) {
737             return 0;
738         }
739         uint256 c = a * b;
740         assert(c / a == b);
741         return c;
742     }
743 
744      *
745     * @dev Integer division of two numbers, truncating the quotient.
746     
747     function div(uint256 a, uint256 b) internal pure returns (uint256) {
748         // assert(b > 0); // Solidity automatically throws when dividing by 0
749         uint256 c = a / b;
750         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
751         return c;
752     }
753 
754      *
755     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
756     
757     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
758         assert(b <= a);
759         return a - b;
760     }
761 
762      *
763     * @dev Adds two numbers, throws on overflow.
764     
765     function add(uint256 a, uint256 b) internal pure returns (uint256) {
766         uint256 c = a + b;
767         assert(c >= a);
768         return c;
769     }
770 }*/
771 
772 
773 /* YOU SHOULD READ THE CONTRACT*/
774 
775 
776 library SafeMath {
777   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
778     uint256 c = a * b;
779     assert(a == 0 || c / a == b);
780     return c;
781   }
782 
783   function div(uint256 a, uint256 b) internal pure returns (uint256) {
784     uint256 c = a / b;
785     return c;
786   }
787 
788   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
789     assert(b <= a);
790     return a - b;
791   }
792 
793   function add(uint256 a, uint256 b) internal pure returns (uint256) {
794     uint256 c = a + b;
795     assert(c >= a);
796     return c;
797   }
798 }
799 
800 contract ForeignToken {
801     function balanceOf(address _owner) constant public returns (uint256);
802     function transfer(address _to, uint256 _value) public returns (bool);
803 }
804 
805 contract ERC20Basic {
806     uint256 public totalSupply;
807     function balanceOf(address who) public constant returns (uint256);
808     function transfer(address to, uint256 value) public returns (bool);
809     event Transfer(address indexed from, address indexed to, uint256 value);
810 }
811 
812 contract ERC20 is ERC20Basic {
813     function allowance(address owner, address spender) public constant returns (uint256);
814     function transferFrom(address from, address to, uint256 value) public returns (bool);
815     function approve(address spender, uint256 value) public returns (bool);
816     event Approval(address indexed owner, address indexed spender, uint256 value);
817 }
818 
819 interface Token { 
820     function distr(address _to, uint256 _value) public returns (bool);
821     function totalSupply() constant public returns (uint256 supply);
822     function balanceOf(address _owner) constant public returns (uint256 balance);
823 }
824 
825 contract PoWMiB is ERC20 {
826     
827     using SafeMath for uint256;
828     address owner = msg.sender;
829 
830     mapping (address => uint256) balances;
831     mapping (address => mapping (address => uint256)) allowed;
832     mapping (address => bool) public blacklist;
833 
834     string public constant name = "Proof of Weak Man in Black";
835     string public constant symbol = "PMIB";
836     uint public constant decimals = 8;
837     
838     uint256 public totalSupply = 80000000e8;
839     uint256 public totalDistributed = 500000e8;
840     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
841     uint256 public value;
842 
843     event Transfer(address indexed _from, address indexed _to, uint256 _value);
844     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
845     
846     event Distr(address indexed to, uint256 amount);
847     event DistrFinished();
848     
849     event Burn(address indexed burner, uint256 value);
850 
851     bool public distributionFinished = false;
852     
853     modifier canDistr() {
854         require(!distributionFinished);
855         _;
856     }
857     
858     modifier onlyOwner() {
859         require(msg.sender == owner);
860         _;
861     }
862     
863    
864     
865     function PoWMiB () public {
866         owner = msg.sender;
867         value = 1307e8;
868         distr(owner, totalDistributed);
869     }
870     
871     function transferOwnership(address newOwner) onlyOwner public {
872         if (newOwner != address(0)) {
873             owner = newOwner;
874         }
875     }
876     
877    
878 
879    
880 
881     function finishDistribution() onlyOwner canDistr public returns (bool) {
882         distributionFinished = true;
883         DistrFinished();
884         return true;
885     }
886     
887     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
888         totalDistributed = totalDistributed.add(_amount);
889         totalRemaining = totalRemaining.sub(_amount);
890         balances[_to] = balances[_to].add(_amount);
891         Distr(_to, _amount);
892         Transfer(address(0), _to, _amount);
893         return true;
894         
895         if (totalDistributed >= totalSupply) {
896             distributionFinished = true;
897         }
898     }
899     
900     function airdrop(address[] addresses) onlyOwner canDistr public {
901         
902         require(addresses.length <= 255);
903         require(value <= totalRemaining);
904         
905         for (uint i = 0; i < addresses.length; i++) {
906             require(value <= totalRemaining);
907             distr(addresses[i], value);
908         }
909 	
910         if (totalDistributed >= totalSupply) {
911             distributionFinished = true;
912         }
913     }
914     
915     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
916         
917         require(addresses.length <= 255);
918         require(amount <= totalRemaining);
919         
920         for (uint i = 0; i < addresses.length; i++) {
921             require(amount <= totalRemaining);
922             distr(addresses[i], amount);
923         }
924 	
925         if (totalDistributed >= totalSupply) {
926             distributionFinished = true;
927         }
928     }
929     
930     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
931 
932         require(addresses.length <= 255);
933         require(addresses.length == amounts.length);
934         
935         for (uint8 i = 0; i < addresses.length; i++) {
936             require(amounts[i] <= totalRemaining);
937             distr(addresses[i], amounts[i]);
938             
939             if (totalDistributed >= totalSupply) {
940                 distributionFinished = true;
941             }
942         }
943     }
944     
945     function () external payable {
946             getTokens();
947      }
948     
949     function getTokens() payable canDistr public {
950         
951         if (value > totalRemaining) {
952             value = totalRemaining;
953         }
954         
955         require(value <= totalRemaining);
956         
957         address investor = msg.sender;
958         uint256 toGive = value;
959         
960         distr(investor, toGive);
961         
962         if (toGive > 0) {
963             blacklist[investor] = true;
964         }
965 
966         if (totalDistributed >= totalSupply) {
967             distributionFinished = true;
968         }
969         
970      
971     }
972 
973     function balanceOf(address _owner) constant public returns (uint256) {
974 	    return balances[_owner];
975     }
976 
977     // mitigates the ERC20 short address attack
978     modifier onlyPayloadSize(uint size) {
979         assert(msg.data.length >= size + 4);
980         _;
981     }
982     
983     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
984 
985         require(_to != address(0));
986         require(_amount <= balances[msg.sender]);
987         
988         balances[msg.sender] = balances[msg.sender].sub(_amount);
989         balances[_to] = balances[_to].add(_amount);
990         Transfer(msg.sender, _to, _amount);
991         return true;
992     }
993     
994     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
995 
996         require(_to != address(0));
997         require(_amount <= balances[_from]);
998         require(_amount <= allowed[_from][msg.sender]);
999         
1000         balances[_from] = balances[_from].sub(_amount);
1001         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
1002         balances[_to] = balances[_to].add(_amount);
1003         Transfer(_from, _to, _amount);
1004         return true;
1005     }
1006     
1007     function approve(address _spender, uint256 _value) public returns (bool success) {
1008         // mitigates the ERC20 spend/approval race condition
1009         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
1010         allowed[msg.sender][_spender] = _value;
1011         Approval(msg.sender, _spender, _value);
1012         return true;
1013     }
1014     
1015     function allowance(address _owner, address _spender) constant public returns (uint256) {
1016         return allowed[_owner][_spender];
1017     }
1018     
1019     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
1020         ForeignToken t = ForeignToken(tokenAddress);
1021         uint bal = t.balanceOf(who);
1022         return bal;
1023     }
1024     
1025     function withdraw() onlyOwner public {
1026         uint256 etherBalance = this.balance;
1027         owner.transfer(etherBalance);
1028     }
1029     
1030     function burn(uint256 _value) onlyOwner public {
1031         require(_value <= balances[msg.sender]);
1032         // no need to require value <= totalSupply, since that would imply the
1033         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
1034 
1035         address burner = msg.sender;
1036         balances[burner] = balances[burner].sub(_value);
1037         totalSupply = totalSupply.sub(_value);
1038         totalDistributed = totalDistributed.sub(_value);
1039         Burn(burner, _value);
1040     }
1041     
1042     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
1043         ForeignToken token = ForeignToken(_tokenContract);
1044         uint256 amount = token.balanceOf(address(this));
1045         return token.transfer(owner, amount);
1046     }
1047 
1048 
1049 }