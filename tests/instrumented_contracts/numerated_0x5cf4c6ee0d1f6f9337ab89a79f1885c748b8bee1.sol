1 pragma solidity ^0.4.20;
2 
3 /*
4 *
5 *https://freeblock.luxe
6 *
7 *
8 * BLOCK OF LIBERTY
9 *
10 * -> What?
11 * The original autonomous pyramid, improved:
12 * [x] More stable than ever, having withstood severe testnet abuse and attack attempts from our community!.
13 * [x] Audited, tested, and approved by known community security specialists such as tocsick and Arc.
14 * [X] New functionality; you can now perform partial sell orders. If you succumb to weak hands, you don't have to dump all of your bags!
15 * [x] New functionality; you can now transfer tokens between wallets. Trading is now possible from within the contract!
16 * [x] New Feature: PoS Masternodes! The first implementation of Ethereum Staking in the world! Vitalik is mad.
17 * [x] Masternodes: Holding 100 seashells Tokens allow you to generate a Masternode link, Masternode links are used as unique entry points to the contract!
18 * [x] Masternodes: All players who enter the contract through your Masternode have 30% of their 10% dividends fee rerouted from the master-node, to the node-master!
19 *
20 * -> What about the last projects?
21 * Every programming member of the old dev team has been fired and/or killed by 232.
22 * The new dev team consists of seasoned, professional developers and has been audited by veteran solidity experts.
23 * Additionally, two independent testnet iterations have been used by hundreds of people; not a single point of failure was found.
24 * 
25 *
26 */
27 
28 contract seashells {
29     /*=================================
30     =            MODIFIERS            =
31     =================================*/
32     // only people with tokens
33     modifier onlyBagholders() {
34         require(myTokens() > 0);
35         _;
36     }
37     
38     // only people with profits
39     modifier onlyStronghands() {
40         require(myDividends(true) > 0);
41         _;
42     }
43     
44     // administrators can:
45     // -> change the name of the contract
46     // -> change the name of the token
47     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
48     // they CANNOT:
49     // -> take funds
50     // -> disable withdrawals
51     // -> kill the contract
52     // -> change the price of tokens
53     modifier onlyAdministrator(){
54         address _customerAddress = msg.sender;
55         require(administrators[keccak256(_customerAddress)]);
56         _;
57     }
58     
59     
60     // ensures that the first tokens in the contract will be equally distributed
61     // meaning, no divine dump will be ever possible
62     // result: healthy longevity.
63     modifier antiEarlyWhale(uint256 _amountOfEthereum){
64         address _customerAddress = msg.sender;
65         
66         // are we still in the vulnerable phase?
67         // if so, enact anti early whale protocol 
68         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
69             require(
70                 // is the customer in the ambassador list?
71                 ambassadors_[_customerAddress] == true &&
72                 
73                 // does the customer purchase exceed the max ambassador quota?
74                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
75                 
76             );
77             
78             // updated the accumulated quota    
79             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
80         
81             // execute
82             _;
83         } else {
84             // in case the ether count drops low, the ambassador phase won't reinitiate
85             onlyAmbassadors = false;
86             _;    
87         }
88         
89     }
90     
91     
92     /*==============================
93     =            EVENTS            =
94     ==============================*/
95     event onTokenPurchase(
96         address indexed customerAddress,
97         uint256 incomingEthereum,
98         uint256 tokensMinted,
99         address indexed referredBy
100     );
101     
102     event onTokenSell(
103         address indexed customerAddress,
104         uint256 tokensBurned,
105         uint256 ethereumEarned
106     );
107     
108     event onReinvestment(
109         address indexed customerAddress,
110         uint256 ethereumReinvested,
111         uint256 tokensMinted
112     );
113     
114     event onWithdraw(
115         address indexed customerAddress,
116         uint256 ethereumWithdrawn
117     );
118     
119     // ERC20
120     event Transfer(
121         address indexed from,
122         address indexed to,
123         uint256 tokens
124     );
125     
126     
127     /*=====================================
128     =            CONFIGURABLES            =
129     =====================================*/
130     string public name = "seashells";
131     string public symbol = "SS";
132     uint8 constant public decimals = 18;
133     uint8 constant internal dividendFee_ = 10;
134     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
135     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
136     uint256 constant internal magnitude = 2**64;
137     
138     // proof of stake (defaults at 100 tokens)
139     uint256 public stakingRequirement = 100e18;
140     
141     // ambassador program
142     mapping(address => bool) internal ambassadors_;
143     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
144     uint256 constant internal ambassadorQuota_ = 20 ether;
145     
146     
147     
148    /*================================
149     =            DATASETS            =
150     ================================*/
151     // amount of shares for each address (scaled number)
152     mapping(address => uint256) internal tokenBalanceLedger_;
153     mapping(address => uint256) internal referralBalance_;
154     mapping(address => int256) internal payoutsTo_;
155     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
156     uint256 internal tokenSupply_ = 0;
157     uint256 internal profitPerShare_;
158     
159     // administrator list (see above on what they can do)
160     mapping(bytes32 => bool) public administrators;
161     
162     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
163     bool public onlyAmbassadors = true;
164     
165 
166 
167     /*=======================================
168     =            PUBLIC FUNCTIONS            =
169     =======================================*/
170     /*
171     * -- APPLICATION ENTRY POINTS --  
172     */
173     function seashells()
174         public
175     {
176         // add administrators here
177         administrators[0x0e02a154a8b4a23993e4a42c7c58faf0ee0253ffdccbed46e8c32e69fe318b20] = true;
178 
179         // Reward funds for developers
180         ambassadors_[0xBe1bB799f587249ad8bEf492Cc48E0D5bBB2c991] = true;
181 
182         // add the ambassadors and contributors.
183         // lead solidity dev & lead web dev. 
184         ambassadors_[0x379F025b37E04d9d5ec4e3198b36717FA54C513c] = true;
185         
186         // mathematics & website, and undisputed meme god.
187         ambassadors_[0x2E29304769e5fdD0bF4F6Eb3174afA6a08B5aC75] = true;
188         
189         // concept design, feedback, management.
190         ambassadors_[0x5cB8629504F3F79b0E2c935e68e6976B5239a9c1] = true;
191         
192         // shilling machine, meme maestro, bizman.
193         ambassadors_[0xe190c28bb3965C7013A523848181175228055e8f] = true;
194         
195         // all those pretty .GIFs & memes you see? you can thank this man for that.
196         ambassadors_[0x76637b31163b438b15BBf61Bcf878495F7A0Ea4f] = true;
197         
198         // community moderator.
199         ambassadors_[0x2d6283FF3777Ae609B01b4BB9dA1e95088204400] = true;
200         
201         // pentests & twitter trendsetter.
202         ambassadors_[0x36cA5db7bd28ad839a9BD2Ab79dF6F67bF7DfB2F] = true;
203         
204         // the source behind the non-intrusive referral model.
205         ambassadors_[0xCf52875fda3ad1994886651Dd4D8ADc2938bB245] = true;
206         
207         // pentesting, contract auditing.
208         ambassadors_[0xBF9A45f956F459D470235f4B25f6C44d9f501ad3] = true;
209         
210         // pentesting, contract auditing.
211         ambassadors_[0x026283a2a9e0cd723425645F1cE18168d02DDD01] = true;
212         
213         // contract auditing.
214         ambassadors_[0xdcC5D774a54733981E94C245172F7E2Cd8749771] = true;
215         
216         // charts & sheets, data dissector, advisor.
217         ambassadors_[0x5025fDB82e3813B2077a944FEaA166553eCe9302] = true;
218         
219         // ss chart visualization.
220         ambassadors_[0x88438a476AdE52368E518A741EC13ED27E8C14f6] = true;
221         
222         // contributors that need to remain private out of security concerns.
223         ambassadors_[0xfaCF4cF9Be08fFfBA03ab698A1c28f4818d5Bf5c] = true;
224         ambassadors_[0x569afbB4AA0ED54C1E1b4a1958f0FBc0eBf60bb1] = true;
225         ambassadors_[0xF74493fa653AC573da925E50388eb6368aC41A9E] = true;
226         ambassadors_[0xFF6fa8D19b9534104c0F4F81C82dFb0f30c1Cb3c] = true;
227         ambassadors_[0x1f187B81fB7b0168a0261380c93C4C370F5ABb06] = true;
228         ambassadors_[0x2B2f84E55b21a743Ed1d37f0F574eF817663d362] = true;
229         ambassadors_[0x706e17Ab71f84C704945Bd272f3B34FC8b32cE09] = true;
230         ambassadors_[0x9b55B24Ae2f16CD509D1e57a89EB8985CA249Cb0] = true;
231         ambassadors_[0x1151A85fA688cf21949a277242A610f4d8d1fAD0] = true;
232         ambassadors_[0xe65d09a935aC95377ECa215a3Fc7827bCD69b5cb] = true;
233 
234     }
235     
236      
237     /**
238      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
239      */
240     function buy(address _referredBy)
241         public
242         payable
243         returns(uint256)
244     {
245         purchaseTokens(msg.value, _referredBy);
246     }
247     
248     /**
249      * Fallback function to handle ethereum that was send straight to the contract
250      * Unfortunately we cannot use a referral address this way.
251      */
252     function()
253         payable
254         public
255     {
256         purchaseTokens(msg.value, 0x0);
257     }
258     
259     /**
260      * Converts all of caller's dividends to tokens.
261      */
262     function reinvest()
263         onlyStronghands()
264         public
265     {
266         // fetch dividends
267         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
268         
269         // pay out the dividends virtually
270         address _customerAddress = msg.sender;
271         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
272         
273         // retrieve ref. bonus
274         _dividends += referralBalance_[_customerAddress];
275         referralBalance_[_customerAddress] = 0;
276         
277         // dispatch a buy order with the virtualized "withdrawn dividends"
278         uint256 _tokens = purchaseTokens(_dividends, 0x0);
279         
280         // fire event
281         onReinvestment(_customerAddress, _dividends, _tokens);
282     }
283     
284     /**
285      * Alias of sell() and withdraw().
286      */
287     function exit()
288         public
289     {
290         // get token count for caller & sell them all
291         address _customerAddress = msg.sender;
292         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
293         if(_tokens > 0) sell(_tokens);
294         
295         // lambo delivery service
296         withdraw();
297     }
298 
299     /**
300      * Withdraws all of the callers earnings.
301      */
302     function withdraw()
303         onlyStronghands()
304         public
305     {
306         // setup data
307         address _customerAddress = msg.sender;
308         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
309         
310         // update dividend tracker
311         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
312         
313         // add ref. bonus
314         _dividends += referralBalance_[_customerAddress];
315         referralBalance_[_customerAddress] = 0;
316         
317         // lambo delivery service
318         _customerAddress.transfer(_dividends);
319         
320         // fire event
321         onWithdraw(_customerAddress, _dividends);
322     }
323     
324     /**
325      * Liquifies tokens to ethereum.
326      */
327     function sell(uint256 _amountOfTokens)
328         onlyBagholders()
329         public
330     {
331         // setup data
332         address _customerAddress = msg.sender;
333         // russian hackers BTFO
334         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
335         uint256 _tokens = _amountOfTokens;
336         uint256 _ethereum = tokensToEthereum_(_tokens);
337         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
338         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
339         
340         // burn the sold tokens
341         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
342         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
343         
344         // update dividends tracker
345         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
346         payoutsTo_[_customerAddress] -= _updatedPayouts;       
347         
348         // dividing by zero is a bad idea
349         if (tokenSupply_ > 0) {
350             // update the amount of dividends per token
351             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
352         }
353         
354         // fire event
355         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
356     }
357     
358     
359     /**
360      * Transfer tokens from the caller to a new holder.
361      * Remember, there's a 10% fee here as well.
362      */
363     function transfer(address _toAddress, uint256 _amountOfTokens)
364         onlyBagholders()
365         public
366         returns(bool)
367     {
368         // setup
369         address _customerAddress = msg.sender;
370         
371         // make sure we have the requested tokens
372         // also disables transfers until ambassador phase is over
373         // ( we dont want whale premines )
374         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
375         
376         // withdraw all outstanding dividends first
377         if(myDividends(true) > 0) withdraw();
378         
379         // liquify 10% of the tokens that are transfered
380         // these are dispersed to shareholders
381         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
382         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
383         uint256 _dividends = tokensToEthereum_(_tokenFee);
384   
385         // burn the fee tokens
386         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
387 
388         // exchange tokens
389         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
390         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
391         
392         // update dividend trackers
393         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
394         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
395         
396         // disperse dividends among holders
397         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
398         
399         // fire event
400         Transfer(_customerAddress, _toAddress, _taxedTokens);
401         
402         // ERC20
403         return true;
404        
405     }
406     
407     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
408     /**
409      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
410      */
411     function disableInitialStage()
412         onlyAdministrator()
413         public
414     {
415         onlyAmbassadors = false;
416     }
417     
418     /**
419      * In case one of us dies, we need to replace ourselves.
420      */
421     function setAdministrator(bytes32 _identifier, bool _status)
422         onlyAdministrator()
423         public
424     {
425         administrators[_identifier] = _status;
426     }
427     
428     /**
429      * Precautionary measures in case we need to adjust the masternode rate.
430      */
431     function setStakingRequirement(uint256 _amountOfTokens)
432         onlyAdministrator()
433         public
434     {
435         stakingRequirement = _amountOfTokens;
436     }
437     
438     /**
439      * If we want to rebrand, we can.
440      */
441     function setName(string _name)
442         onlyAdministrator()
443         public
444     {
445         name = _name;
446     }
447     
448     /**
449      * If we want to rebrand, we can.
450      */
451     function setSymbol(string _symbol)
452         onlyAdministrator()
453         public
454     {
455         symbol = _symbol;
456     }
457 
458     
459     /*----------  HELPERS AND CALCULATORS  ----------*/
460     /**
461      * Method to view the current Ethereum stored in the contract
462      * Example: totalEthereumBalance()
463      */
464     function totalEthereumBalance()
465         public
466         view
467         returns(uint)
468     {
469         return this.balance;
470     }
471     
472     /**
473      * Retrieve the total token supply.
474      */
475     function totalSupply()
476         public
477         view
478         returns(uint256)
479     {
480         return tokenSupply_;
481     }
482     
483     /**
484      * Retrieve the tokens owned by the caller.
485      */
486     function myTokens()
487         public
488         view
489         returns(uint256)
490     {
491         address _customerAddress = msg.sender;
492         return balanceOf(_customerAddress);
493     }
494     
495     /**
496      * Retrieve the dividends owned by the caller.
497      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
498      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
499      * But in the internal calculations, we want them separate. 
500      */ 
501     function myDividends(bool _includeReferralBonus) 
502         public 
503         view 
504         returns(uint256)
505     {
506         address _customerAddress = msg.sender;
507         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
508     }
509     
510     /**
511      * Retrieve the token balance of any single address.
512      */
513     function balanceOf(address _customerAddress)
514         view
515         public
516         returns(uint256)
517     {
518         return tokenBalanceLedger_[_customerAddress];
519     }
520     
521     /**
522      * Retrieve the dividend balance of any single address.
523      */
524     function dividendsOf(address _customerAddress)
525         view
526         public
527         returns(uint256)
528     {
529         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
530     }
531     
532     /**
533      * Return the buy price of 1 individual token.
534      */
535     function sellPrice() 
536         public 
537         view 
538         returns(uint256)
539     {
540         // our calculation relies on the token supply, so we need supply. Doh.
541         if(tokenSupply_ == 0){
542             return tokenPriceInitial_ - tokenPriceIncremental_;
543         } else {
544             uint256 _ethereum = tokensToEthereum_(1e18);
545             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
546             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
547             return _taxedEthereum;
548         }
549     }
550     
551     /**
552      * Return the sell price of 1 individual token.
553      */
554     function buyPrice() 
555         public 
556         view 
557         returns(uint256)
558     {
559         // our calculation relies on the token supply, so we need supply. Doh.
560         if(tokenSupply_ == 0){
561             return tokenPriceInitial_ + tokenPriceIncremental_;
562         } else {
563             uint256 _ethereum = tokensToEthereum_(1e18);
564             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
565             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
566             return _taxedEthereum;
567         }
568     }
569     
570     /**
571      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
572      */
573     function calculateTokensReceived(uint256 _ethereumToSpend) 
574         public 
575         view 
576         returns(uint256)
577     {
578         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
579         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
580         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
581         
582         return _amountOfTokens;
583     }
584     
585     /**
586      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
587      */
588     function calculateEthereumReceived(uint256 _tokensToSell) 
589         public 
590         view 
591         returns(uint256)
592     {
593         require(_tokensToSell <= tokenSupply_);
594         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
595         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
596         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
597         return _taxedEthereum;
598     }
599     
600     
601     /*==========================================
602     =            INTERNAL FUNCTIONS            =
603     ==========================================*/
604     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
605         antiEarlyWhale(_incomingEthereum)
606         internal
607         returns(uint256)
608     {
609         // data setup
610         address _customerAddress = msg.sender;
611         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
612         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
613         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
614         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
615         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
616         uint256 _fee = _dividends * magnitude;
617  
618         // no point in continuing execution if OP is a poorfag russian hacker
619         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
620         // (or hackers)
621         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
622         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
623         
624         // is the user referred by a masternode?
625         if(
626             // is this a referred purchase?
627             _referredBy != 0x0000000000000000000000000000000000000000 &&
628 
629             // no cheating!
630             _referredBy != _customerAddress &&
631             
632             // does the referrer have at least X whole tokens?
633             // i.e is the referrer a godly chad masternode
634             tokenBalanceLedger_[_referredBy] >= stakingRequirement
635         ){
636             // wealth redistribution
637             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
638         } else {
639             // no ref purchase
640             // add the referral bonus back to the global dividends cake
641             _dividends = SafeMath.add(_dividends, _referralBonus);
642             _fee = _dividends * magnitude;
643         }
644         
645         // we can't give people infinite ethereum
646         if(tokenSupply_ > 0){
647             
648             // add tokens to the pool
649             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
650  
651             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
652             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
653             
654             // calculate the amount of tokens the customer receives over his purchase 
655             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
656         
657         } else {
658             // add tokens to the pool
659             tokenSupply_ = _amountOfTokens;
660         }
661         
662         // update circulating supply & the ledger address for the customer
663         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
664         
665         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
666         //really i know you think you do but you don't
667         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
668         payoutsTo_[_customerAddress] += _updatedPayouts;
669         
670         // fire event
671         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
672         
673         return _amountOfTokens;
674         
675     }
676 
677     /**
678      * Calculate Token price based on an amount of incoming ethereum
679      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
680      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
681      */
682     function ethereumToTokens_(uint256 _ethereum)
683         internal
684         view
685         returns(uint256)
686     {
687         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
688         uint256 _tokensReceived = 
689          (
690             (
691                 // underflow attempts BTFO
692                 SafeMath.sub(
693                     (sqrt
694                         (
695                             (_tokenPriceInitial**2)
696                             +
697                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
698                             +
699                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
700                             +
701                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
702                         )
703                     ), _tokenPriceInitial
704                 )
705             )/(tokenPriceIncremental_)
706         )-(tokenSupply_)
707         ;
708   
709         return _tokensReceived;
710     }
711     
712     /**
713      * Calculate token sell value.
714      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
715      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
716      */
717      function tokensToEthereum_(uint256 _tokens)
718         internal
719         view
720         returns(uint256)
721     {
722 
723         uint256 tokens_ = (_tokens + 1e18);
724         uint256 _tokenSupply = (tokenSupply_ + 1e18);
725         uint256 _etherReceived =
726         (
727             // underflow attempts BTFO
728             SafeMath.sub(
729                 (
730                     (
731                         (
732                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
733                         )-tokenPriceIncremental_
734                     )*(tokens_ - 1e18)
735                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
736             )
737         /1e18);
738         return _etherReceived;
739     }
740     
741     
742     //This is where all your gas goes, sorry
743     //Not sorry, you probably only paid 1 gwei
744     function sqrt(uint x) internal pure returns (uint y) {
745         uint z = (x + 1) / 2;
746         y = x;
747         while (z < y) {
748             y = z;
749             z = (x / z + z) / 2;
750         }
751     }
752 }
753 
754 /**
755  * @title SafeMath
756  * @dev Math operations with safety checks that throw on error
757  */
758 library SafeMath {
759 
760     /**
761     * @dev Multiplies two numbers, throws on overflow.
762     */
763     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
764         if (a == 0) {
765             return 0;
766         }
767         uint256 c = a * b;
768         assert(c / a == b);
769         return c;
770     }
771 
772     /**
773     * @dev Integer division of two numbers, truncating the quotient.
774     */
775     function div(uint256 a, uint256 b) internal pure returns (uint256) {
776         // assert(b > 0); // Solidity automatically throws when dividing by 0
777         uint256 c = a / b;
778         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
779         return c;
780     }
781 
782     /**
783     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
784     */
785     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
786         assert(b <= a);
787         return a - b;
788     }
789 
790     /**
791     * @dev Adds two numbers, throws on overflow.
792     */
793     function add(uint256 a, uint256 b) internal pure returns (uint256) {
794         uint256 c = a + b;
795         assert(c >= a);
796         return c;
797     }
798     
799 }