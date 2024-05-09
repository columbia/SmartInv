1 pragma solidity ^0.4.20;
2  
3 /*
4 * ====================================*
5 *
6 * PROOF OF RIPPLE
7 * https://poripple.com/
8 * https://discord.gg/6AA5etr
9 *
10 * ====================================*
11 *
12 * -> How is Proof of Ripple different than other Proof Coin?
13 * Proof of Ripple is a more sustainable contract with the innovative 4X Wagering Requirement mechanics.
14 * The total amount of all sold tokens and reinvested tokens must be at least 4 times the total purchased tokens before you can withdraw.
15 *
16 * -> Here is an example illustrating how it works:
17 * Let say initially you purchased 500 PoRipple tokens, and sold all 500 tokens later, at that point, you cannot immediately withdraw because the 4X Wagering Requirement haven't met yet, you'll need to reinvest your balance in order to increase the total wagering amount.
18 * Now suppose the tokens price dropped a bit later on, and you're able to reinvest the dividends and get 750 tokens, so if you sell all 750 tokens, you'll be able to withdraw all your balance, because the 4X Wagering Requirement is fulfilled, i.e. Total Wagered Tokens (500 sell + 750 reinvest + 750 sell) = 4 x Total Purchased Tokens (500 initial purchase)
19 *
20 * -> What is the advantages of wagering:
21 * 1. Unlike all other PO clones, early buyers cannot just dump and exit in PoRipple, because they'll need to reinvest it back in order to fulfill the 4X Wagering Requirement.
22 * 2. It incentivize token holding, and gathering dividends instead of fomo dumping.
23 * 3. It induce higher volatility, more actions = more dividends for holders!
24 * 4. People will feel more comfortable buying in later stage.
25 *
26 * -> What?
27 * The original autonomous pyramid, improved:
28 * [x] More stable than ever, having withstood severe testnet abuse and attack attempts from our community!.
29 * [x] Audited, tested, and approved by known community security specialists such as tocsick and Arc.
30 * [X] New functionality; you can now perform partial sell orders. If you succumb to weak hands, you don't have to dump all of your bags!
31 * [x] New functionality; you can now transfer tokens between wallets. Trading is now possible from within the contract!
32 * [x] New Feature: PoS Masternodes! The first implementation of Ethereum Staking in the world! Vitalik is mad.
33 * [x] Masternodes: Holding 50 PoRipple Tokens allow you to generate a Masternode link, Masternode links are used as unique entry points to the contract!
34 * [x] Masternodes: All players who enter the contract through your Masternode have 30% of their 20% dividends fee rerouted from the master-node, to the node-master!
35 *
36 * -> What about the last projects?
37 * Every programming member of the old dev team has been fired and/or killed by 232.
38 * The new dev team consists of seasoned, professional developers and has been audited by veteran solidity experts.
39 * Additionally, two independent testnet iterations have been used by hundreds of people; not a single point of failure was found.
40 *
41 * -> Who worked on this project?
42 * Trusted community from CryptoGaming
43 *
44 */
45  
46 contract ProofOfRipple {
47     /*=================================
48     =            MODIFIERS            =
49     =================================*/
50     // only people with tokens
51     modifier onlyBagholders() {
52         require(myTokens() > 0);
53         _;
54     }
55  
56     // only people with profits
57     modifier onlyStronghands() {
58         require(myDividends(true) > 0);
59         _;
60     }
61  
62     modifier onlyWageredWithdraw() {
63        address _customerAddress = msg.sender;
64        require(wageringOf_[_customerAddress] >= SafeMath.mul(initialBuyinOf_[_customerAddress], wageringRequirement_));
65        _;
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
79         require(administrators[_customerAddress]);
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
116     /*==============================
117     =            EVENTS            =
118     ==============================*/
119     event onTokenPurchase(
120         address indexed customerAddress,
121         uint256 incomingEthereum,
122         uint256 tokensMinted,
123         address indexed referredBy,
124         uint256 timestamp,
125         uint256 price
126     );
127  
128     event onTokenSell(
129         address indexed customerAddress,
130         uint256 tokensBurned,
131         uint256 ethereumEarned,
132         uint256 timestamp,
133         uint256 price
134     );
135  
136     event onReinvestment(
137         address indexed customerAddress,
138         uint256 ethereumReinvested,
139         uint256 tokensMinted
140     );
141  
142     event onWithdraw(
143         address indexed customerAddress,
144         uint256 ethereumWithdrawn
145     );
146  
147     // ERC20
148     event Transfer(
149         address indexed from,
150         address indexed to,
151         uint256 tokens
152     );
153  
154  
155     /*=====================================
156     =            CONFIGURABLES            =
157     =====================================*/
158     string public name = "ProofOfRipple";
159     string public symbol = "PoRipple";
160     uint8 constant public decimals = 18;
161     uint8 constant internal dividendFee_ = 5; // 20% dividends on buy and sell and transfer
162     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
163     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
164     uint256 constant internal magnitude = 2**64;
165     uint256 constant internal wageringRequirement_ = 4; // 4x is wagering requirement for the pyramid
166  
167     // proof of stake (defaults at 100 tokens)
168     uint256 public stakingRequirement = 50e18;
169  
170     // ambassador program
171     mapping(address => bool) internal ambassadors_;
172     uint256 constant internal ambassadorMaxPurchase_ = 0.4 ether; // only 0.4 eth premine
173     uint256 constant internal ambassadorQuota_ = 2 ether;
174  
175  
176  
177    /*================================
178     =            DATASETS            =
179     ================================*/
180     mapping(address => uint256) public initialBuyinOf_; // amount of tokens bought in pyramid
181     mapping(address => uint256) public wageringOf_; // wagering amount of tokens for the user
182  
183     // amount of shares for each address (scaled number)
184     mapping(address => uint256) internal tokenBalanceLedger_;
185     mapping(address => uint256) internal referralBalance_;
186     mapping(address => int256) internal payoutsTo_;
187     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
188     uint256 internal tokenSupply_ = 0;
189     uint256 internal profitPerShare_;
190  
191     // administrator list (see above on what they can do)
192     mapping(address => bool) public administrators;
193  
194     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
195     bool public onlyAmbassadors = true;
196  
197  
198  
199     /*=======================================
200     =            PUBLIC FUNCTIONS            =
201     =======================================*/
202     /*
203     * -- APPLICATION ENTRY POINTS --
204     */
205     function ProofOfRipple()
206         public
207     {
208         // add administrators here
209         administrators[0x15Fda64fCdbcA27a60Aa8c6ca882Aa3e1DE4Ea41] = true;
210         ambassadors_[0x15Fda64fCdbcA27a60Aa8c6ca882Aa3e1DE4Ea41] = true;
211         ambassadors_[0xFEA0904ACc8Df0F3288b6583f60B86c36Ea52AcD] = true;
212         ambassadors_[0x494952f01a30547d269aaF147e6226f940f5B041] = true;
213     }
214  
215  
216     /**
217      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
218      */
219     function buy(address _referredBy)
220         public
221         payable
222         returns(uint256)
223     {
224         purchaseTokens(msg.value, _referredBy, false);
225     }
226  
227     /**
228      * Fallback function to handle ethereum that was send straight to the contract
229      * Unfortunately we cannot use a referral address this way.
230      */
231     function()
232         payable
233         public
234     {
235         purchaseTokens(msg.value, 0x0, false);
236     }
237  
238     /**
239      * Converts all of caller's dividends to tokens.
240      */
241     function reinvest()
242         onlyStronghands()
243         public
244     {
245         // fetch dividends
246         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
247  
248         // pay out the dividends virtually
249         address _customerAddress = msg.sender;
250         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
251  
252         // retrieve ref. bonus
253         _dividends += referralBalance_[_customerAddress];
254         referralBalance_[_customerAddress] = 0;
255  
256         // dispatch a buy order with the virtualized "withdrawn dividends"
257         uint256 _tokens = purchaseTokens(_dividends, 0x0, true);
258  
259         // fire event
260         onReinvestment(_customerAddress, _dividends, _tokens);
261     }
262  
263     /**
264      * Alias of sell() and withdraw().
265      */
266     function exit()
267         public
268     {
269         // get token count for caller & sell them all
270         address _customerAddress = msg.sender;
271         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
272         if(_tokens > 0) sell(_tokens);
273  
274         // lambo delivery service
275         withdraw();
276     }
277  
278     /**
279      * Withdraws all of the callers earnings.
280      */
281     function withdraw()
282         onlyStronghands()
283         onlyWageredWithdraw()
284         public
285     {
286         // setup data
287         address _customerAddress = msg.sender;
288         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
289  
290         // update dividend tracker
291         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
292  
293         // add ref. bonus
294         _dividends += referralBalance_[_customerAddress];
295         referralBalance_[_customerAddress] = 0;
296  
297         // lambo delivery service
298         _customerAddress.transfer(_dividends);
299  
300         // fire event
301         onWithdraw(_customerAddress, _dividends);
302     }
303  
304     /**
305      * Liquifies tokens to ethereum.
306      */
307     function sell(uint256 _amountOfTokens)
308         onlyBagholders()
309         public
310     {
311         // setup data
312         address _customerAddress = msg.sender;
313         // russian hackers BTFO
314         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
315         uint256 _tokens = _amountOfTokens;
316         uint256 _ethereum = tokensToEthereum_(_tokens);
317         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
318         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
319  
320         // burn the sold tokens
321         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
322         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
323         // Update wagering balance of the user, add the sold amount of tokens
324         wageringOf_[_customerAddress] = SafeMath.add(wageringOf_[_customerAddress], _tokens);
325  
326         // update dividends tracker
327         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
328         payoutsTo_[_customerAddress] -= _updatedPayouts;
329  
330         // dividing by zero is a bad idea
331         if (tokenSupply_ > 0) {
332             // update the amount of dividends per token
333             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
334         }
335  
336         // fire event
337         onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
338     }
339  
340  
341     /**
342      * Transfer tokens from the caller to a new holder.
343      * Remember, there's a 20% fee here as well.
344      */
345     function transfer(address _toAddress, uint256 _amountOfTokens)
346         onlyBagholders()
347         public
348         returns(bool)
349     {
350         // setup
351         address _customerAddress = msg.sender;
352  
353         // make sure we have the requested tokens
354         // also disables transfers until ambassador phase is over
355         // ( we dont want whale premines )
356         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
357  
358         // withdraw all outstanding dividends first
359         if(myDividends(true) > 0) withdraw();
360  
361         // liquify 20% of the tokens that are transfered
362         // these are dispersed to shareholders
363         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
364         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
365         uint256 _dividends = tokensToEthereum_(_tokenFee);
366  
367         // burn the fee tokens
368         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
369  
370         // exchange tokens
371         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
372         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
373  
374         // Update wagering balance of the user, add the transfer amount tokens
375         wageringOf_[_customerAddress] = SafeMath.add(wageringOf_[_customerAddress], _amountOfTokens);
376         // Update wagering balance and buyin fee for the user tokens transfered to
377         initialBuyinOf_[_toAddress] = SafeMath.add(initialBuyinOf_[_toAddress], _taxedTokens);
378  
379         // update dividend trackers
380         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
381         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
382  
383         // disperse dividends among holders
384         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
385  
386         // fire event
387         Transfer(_customerAddress, _toAddress, _taxedTokens);
388  
389         // ERC20
390         return true;
391  
392     }
393  
394     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
395     /**
396      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
397      */
398     function disableInitialStage()
399         onlyAdministrator()
400         public
401     {
402         onlyAmbassadors = false;
403     }
404  
405     /**
406      * In case one of us dies, we need to replace ourselves.
407      */
408     function setAdministrator(address _identifier, bool _status)
409         onlyAdministrator()
410         public
411     {
412         administrators[_identifier] = _status;
413     }
414  
415     /**
416      * Precautionary measures in case we need to adjust the masternode rate.
417      */
418     function setStakingRequirement(uint256 _amountOfTokens)
419         onlyAdministrator()
420         public
421     {
422         stakingRequirement = _amountOfTokens;
423     }
424  
425     /**
426      * If we want to rebrand, we can.
427      */
428     function setName(string _name)
429         onlyAdministrator()
430         public
431     {
432         name = _name;
433     }
434  
435     /**
436      * If we want to rebrand, we can.
437      */
438     function setSymbol(string _symbol)
439         onlyAdministrator()
440         public
441     {
442         symbol = _symbol;
443     }
444  
445  
446     /*----------  HELPERS AND CALCULATORS  ----------*/
447     /**
448      * Method to view the current Ethereum stored in the contract
449      * Example: totalEthereumBalance()
450      */
451     function totalEthereumBalance()
452         public
453         view
454         returns(uint)
455     {
456         return this.balance;
457     }
458  
459     /**
460      * Retrieve the total token supply.
461      */
462     function totalSupply()
463         public
464         view
465         returns(uint256)
466     {
467         return tokenSupply_;
468     }
469  
470     /**
471      * Retrieve the tokens owned by the caller.
472      */
473     function myTokens()
474         public
475         view
476         returns(uint256)
477     {
478         address _customerAddress = msg.sender;
479         return balanceOf(_customerAddress);
480     }
481  
482     /**
483      * Retrieve the dividends owned by the caller.
484      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
485      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
486      * But in the internal calculations, we want them separate.
487      */
488     function myDividends(bool _includeReferralBonus)
489         public
490         view
491         returns(uint256)
492     {
493         address _customerAddress = msg.sender;
494         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
495     }
496  
497     /**
498      * Retrieve the token balance of any single address.
499      */
500     function balanceOf(address _customerAddress)
501         view
502         public
503         returns(uint256)
504     {
505         return tokenBalanceLedger_[_customerAddress];
506     }
507  
508     /**
509      * Retrieve the dividend balance of any single address.
510      */
511     function dividendsOf(address _customerAddress)
512         view
513         public
514         returns(uint256)
515     {
516         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
517     }
518  
519     /**
520      * Return the buy price of 1 individual token.
521      */
522     function sellPrice()
523         public
524         view
525         returns(uint256)
526     {
527         // our calculation relies on the token supply, so we need supply. Doh.
528         if(tokenSupply_ == 0){
529             return tokenPriceInitial_ - tokenPriceIncremental_;
530         } else {
531             uint256 _ethereum = tokensToEthereum_(1e18);
532             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
533             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
534             return _taxedEthereum;
535         }
536     }
537  
538     /**
539      * Return the sell price of 1 individual token.
540      */
541     function buyPrice()
542         public
543         view
544         returns(uint256)
545     {
546         // our calculation relies on the token supply, so we need supply. Doh.
547         if(tokenSupply_ == 0){
548             return tokenPriceInitial_ + tokenPriceIncremental_;
549         } else {
550             uint256 _ethereum = tokensToEthereum_(1e18);
551             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
552             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
553             return _taxedEthereum;
554         }
555     }
556  
557     /**
558      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
559      */
560     function calculateTokensReceived(uint256 _ethereumToSpend)
561         public
562         view
563         returns(uint256)
564     {
565         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
566         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
567         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
568  
569         return _amountOfTokens;
570     }
571  
572     /**
573      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
574      */
575     function calculateEthereumReceived(uint256 _tokensToSell)
576         public
577         view
578         returns(uint256)
579     {
580         require(_tokensToSell <= tokenSupply_);
581         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
582         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
583         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
584         return _taxedEthereum;
585     }
586  
587  
588     /*==========================================
589     =            INTERNAL FUNCTIONS            =
590     ==========================================*/
591     function purchaseTokens(uint256 _incomingEthereum, address _referredBy,  bool _isReinvest)
592         antiEarlyWhale(_incomingEthereum)
593         internal
594         returns(uint256)
595     {
596         // data setup
597         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
598         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
599         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
600         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
601         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
602         uint256 _fee = _dividends * magnitude;
603  
604         // no point in continuing execution if OP is a poorfag russian hacker
605         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
606         // (or hackers)
607         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
608         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
609  
610         // is the user referred by a masternode?
611         if(
612             // is this a referred purchase?
613             _referredBy != 0x0000000000000000000000000000000000000000 &&
614  
615             // no cheating!
616             _referredBy != msg.sender &&
617  
618             // does the referrer have at least X whole tokens?
619             // i.e is the referrer a godly chad masternode
620             tokenBalanceLedger_[_referredBy] >= stakingRequirement
621         ){
622             // wealth redistribution
623             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
624         } else {
625             // no ref purchase
626             // add the referral bonus back to the global dividends cake
627             _dividends = SafeMath.add(_dividends, _referralBonus);
628             _fee = _dividends * magnitude;
629         }
630  
631         // we can't give people infinite ethereum
632         if(tokenSupply_ > 0){
633  
634             // add tokens to the pool
635             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
636  
637             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
638             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
639  
640             // calculate the amount of tokens the customer receives over his purchase
641             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
642  
643         } else {
644             // add tokens to the pool
645             tokenSupply_ = _amountOfTokens;
646         }
647  
648         // update circulating supply & the ledger address for the customer
649         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
650  
651         
652         if (_isReinvest) {
653             // Update the Wagering Balance for the customer
654             wageringOf_[msg.sender] = SafeMath.add(wageringOf_[msg.sender], _amountOfTokens);
655         } else {
656           // If it is not reinvest update initial Buy In amount
657           initialBuyinOf_[msg.sender] = SafeMath.add(initialBuyinOf_[msg.sender], _amountOfTokens);
658         }
659  
660         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
661         //really i know you think you do but you don't
662         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
663         payoutsTo_[msg.sender] += _updatedPayouts;
664  
665         // fire event
666         onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
667  
668         return _amountOfTokens;
669     }
670  
671     /**
672      * Calculate Token price based on an amount of incoming ethereum
673      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
674      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
675      */
676     function ethereumToTokens_(uint256 _ethereum)
677         internal
678         view
679         returns(uint256)
680     {
681         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
682         uint256 _tokensReceived =
683          (
684             (
685                 // underflow attempts BTFO
686                 SafeMath.sub(
687                     (sqrt
688                         (
689                             (_tokenPriceInitial**2)
690                             +
691                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
692                             +
693                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
694                             +
695                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
696                         )
697                     ), _tokenPriceInitial
698                 )
699             )/(tokenPriceIncremental_)
700         )-(tokenSupply_)
701         ;
702  
703         return _tokensReceived;
704     }
705  
706     /**
707      * Calculate token sell value.
708      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
709      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
710      */
711      function tokensToEthereum_(uint256 _tokens)
712         internal
713         view
714         returns(uint256)
715     {
716  
717         uint256 tokens_ = (_tokens + 1e18);
718         uint256 _tokenSupply = (tokenSupply_ + 1e18);
719         uint256 _etherReceived =
720         (
721             // underflow attempts BTFO
722             SafeMath.sub(
723                 (
724                     (
725                         (
726                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
727                         )-tokenPriceIncremental_
728                     )*(tokens_ - 1e18)
729                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
730             )
731         /1e18);
732         return _etherReceived;
733     }
734  
735  
736     //This is where all your gas goes, sorry
737     //Not sorry, you probably only paid 1 gwei
738     function sqrt(uint x) internal pure returns (uint y) {
739         uint z = (x + 1) / 2;
740         y = x;
741         while (z < y) {
742             y = z;
743             z = (x / z + z) / 2;
744         }
745     }
746 }
747  
748 /**
749  * @title SafeMath
750  * @dev Math operations with safety checks that throw on error
751  */
752 library SafeMath {
753  
754     /**
755     * @dev Multiplies two numbers, throws on overflow.
756     */
757     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
758         if (a == 0) {
759             return 0;
760         }
761         uint256 c = a * b;
762         assert(c / a == b);
763         return c;
764     }
765  
766     /**
767     * @dev Integer division of two numbers, truncating the quotient.
768     */
769     function div(uint256 a, uint256 b) internal pure returns (uint256) {
770         // assert(b > 0); // Solidity automatically throws when dividing by 0
771         uint256 c = a / b;
772         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
773         return c;
774     }
775  
776     /**
777     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
778     */
779     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
780         assert(b <= a);
781         return a - b;
782     }
783  
784     /**
785     * @dev Adds two numbers, throws on overflow.
786     */
787     function add(uint256 a, uint256 b) internal pure returns (uint256) {
788         uint256 c = a + b;
789         assert(c >= a);
790         return c;
791     }
792 }