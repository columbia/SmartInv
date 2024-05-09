1 pragma solidity ^0.4.20;
2 
3 /*
4 * Team JUST presents..
5 * =====================================================*
6 * _____  __          ___    _ __  __          __   __  *
7 *|  __ \ \ \        / / |  | |  \/  |   /\    \ \ / /  *
8 *| |__) |_\ \  /\  / /| |__| | \  / |  /  \    \ V /   *
9 *|  ___/ _ \ \/  \/ / |  __  | |\/| | / /\ \    > <    *
10 *| |  | (_) \  /\  /  | |  | | |  | |/ ____ \  / . \   *
11 *|_|   \___/ \/  \/   |_|  |_|_|  |_/_/    \_\/_/ \_\  *
12 *                                                      *
13 *                                                      *
14 * =====================================================*
15 * -> What?
16 * The original autonomous pyramid, improved:
17 * [x] More stable than ever, having withstood severe testnet abuse and attack attempts from our community!.
18 * [x] Audited, tested, and approved by known community security specialists such as tocsick and Arc.
19 * [X] New functionality; you can now perform partial sell orders. If you succumb to weak hands, you don't have to dump all of your bags!
20 * [x] New functionality; you can now transfer tokens between wallets. Trading is now possible from within the contract!
21 * [x] New Feature: PoS Masternodes! The first implementation of Ethereum Staking in the world! Vitalik is mad.
22 * [x] Masternodes: Holding 100 PoWH3D Tokens allow you to generate a Masternode link, Masternode links are used as unique entry points to the contract!
23 * [x] Masternodes: All players who enter the contract through your Masternode have 30% of their 10% dividends fee rerouted from the master-node, to the node-master!
24 *
25 * -> What about the last projects?
26 * Every programming member of the old dev team has been fired and/or killed by 232.
27 * The new dev team consists of seasoned, professional developers and has been audited by veteran solidity experts.
28 * Additionally, two independent testnet iterations have been used by hundreds of people; not a single point of failure was found.
29 * 
30 * -> Who worked on this project?
31 * - PonziBot (math/memes/main site/master)
32 * - Mantso (lead solidity dev/lead web3 dev)
33 * - swagg (concept design/feedback/management)
34 * - Anonymous#1 (main site/web3/test cases)
35 * - Anonymous#2 (math formulae/whitepaper)
36 *
37 * -> Who has audited & approved the projected:
38 * - Arc
39 * - tocisck
40 * - sumpunk
41 */
42 
43 contract Hourglass {
44     /*=================================
45     =            MODIFIERS            =
46     =================================*/
47     // only people with tokens
48     modifier onlyBagholders() {
49         require(myTokens() > 0);
50         _;
51     }
52     
53     // only people with profits
54     modifier onlyStronghands() {
55         require(myDividends(true) > 0);
56         _;
57     }
58     
59     // administrators can:
60     // -> change the name of the contract
61     // -> change the name of the token
62     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
63     // they CANNOT:
64     // -> take funds
65     // -> disable withdrawals
66     // -> kill the contract
67     // -> change the price of tokens
68     modifier onlyAdministrator(){
69         address _customerAddress = msg.sender;
70         require(administrators[keccak256(_customerAddress)]);
71         _;
72     }
73     
74     
75     // ensures that the first tokens in the contract will be equally distributed
76     // meaning, no divine dump will be ever possible
77     // result: healthy longevity.
78     modifier antiEarlyWhale(uint256 _amountOfEthereum){
79         address _customerAddress = msg.sender;
80         
81         // are we still in the vulnerable phase?
82         // if so, enact anti early whale protocol 
83         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
84             require(
85                 // is the customer in the ambassador list?
86                 ambassadors_[_customerAddress] == true &&
87                 
88                 // does the customer purchase exceed the max ambassador quota?
89                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
90                 
91             );
92             
93             // updated the accumulated quota    
94             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
95         
96             // execute
97             _;
98         } else {
99             // in case the ether count drops low, the ambassador phase won't reinitiate
100             onlyAmbassadors = false;
101             _;    
102         }
103         
104     }
105     
106     
107     /*==============================
108     =            EVENTS            =
109     ==============================*/
110     event onTokenPurchase(
111         address indexed customerAddress,
112         uint256 incomingEthereum,
113         uint256 tokensMinted,
114         address indexed referredBy
115     );
116     
117     event onTokenSell(
118         address indexed customerAddress,
119         uint256 tokensBurned,
120         uint256 ethereumEarned
121     );
122     
123     event onReinvestment(
124         address indexed customerAddress,
125         uint256 ethereumReinvested,
126         uint256 tokensMinted
127     );
128     
129     event onWithdraw(
130         address indexed customerAddress,
131         uint256 ethereumWithdrawn
132     );
133     
134     // ERC20
135     event Transfer(
136         address indexed from,
137         address indexed to,
138         uint256 tokens
139     );
140     
141     
142     /*=====================================
143     =            CONFIGURABLES            =
144     =====================================*/
145     string public name = "PoWHMAX";
146     string public symbol = "M4X";
147     uint8 constant public decimals = 18;
148     uint8 constant internal dividendFee_ = 100;
149     uint8 constant internal feeMul_ = 99;
150     uint256 constant internal tokenPriceInitial_ = 0.001 ether;
151     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
152     uint256 constant internal magnitude = 2**64;
153     
154     // proof of stake (defaults at 100 tokens)
155     uint256 public stakingRequirement = 10e18;
156     
157     // ambassador program
158     mapping(address => bool) internal ambassadors_;
159     uint256 constant internal ambassadorMaxPurchase_ = 0.5 ether;
160     uint256 constant internal ambassadorQuota_ = 1.5 ether;
161     
162     
163     
164    /*================================
165     =            DATASETS            =
166     ================================*/
167     // amount of shares for each address (scaled number)
168     mapping(address => uint256) internal tokenBalanceLedger_;
169     mapping(address => uint256) internal referralBalance_;
170     mapping(address => int256) internal payoutsTo_;
171     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
172     uint256 internal tokenSupply_ = 0;
173     uint256 internal profitPerShare_;
174     
175     // administrator list (see above on what they can do)
176     mapping(bytes32 => bool) public administrators;
177     
178     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
179     bool public onlyAmbassadors = true;
180     
181 
182 
183     /*=======================================
184     =            PUBLIC FUNCTIONS            =
185     =======================================*/
186     /*
187     * -- APPLICATION ENTRY POINTS --  
188     */
189     function Hourglass()
190         public
191     {
192         // add administrators here
193         administrators[0x707e2ca02f428c904ca200b5de531432ef1db837abd8bf5d4996389bc35b62c0] = true;
194         
195         // add the ambassadors here.
196         
197         ambassadors_[0x8aB5FF360B4545f478b68cb13657710F32D4857f] = true;
198         ambassadors_[0x536A8963e91d70730D81D729AEAa25A5A039A0a3] = true;
199         ambassadors_[0x0ECBeF908Df21Baa8f176E3d6712e2702349A851] = true;
200         ambassadors_[0x5c9E4D1feA4E9283FdAF89C338a29f593E413860] = true;
201 
202 
203         //ambassadors_[0x65Df9CfFd256f306Aa8b85b9219b2D5Fa1F0440C] = true; //tj99 - DELETE COMMENT ON MAIN
204 
205     }
206     
207      
208     /**
209      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
210      */
211     function buy(address _referredBy)
212         public
213         payable
214         returns(uint256)
215     {
216         purchaseTokens(msg.value, _referredBy);
217     }
218     
219     /**
220      * Fallback function to handle ethereum that was send straight to the contract
221      * Unfortunately we cannot use a referral address this way.
222      */
223     function()
224         payable
225         public
226     {
227         purchaseTokens(msg.value, 0x0);
228     }
229     
230     /**
231      * Converts all of caller's dividends to tokens.
232      */
233     function reinvest()
234         onlyStronghands()
235         public
236     {
237         // fetch dividends
238         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
239         
240         // pay out the dividends virtually
241         address _customerAddress = msg.sender;
242         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
243         
244         // retrieve ref. bonus
245         _dividends += referralBalance_[_customerAddress];
246         referralBalance_[_customerAddress] = 0;
247         
248         // dispatch a buy order with the virtualized "withdrawn dividends"
249         uint256 _tokens = purchaseTokens(_dividends, 0x0);
250         
251         // fire event
252         onReinvestment(_customerAddress, _dividends, _tokens);
253     }
254     
255     /**
256      * Alias of sell() and withdraw().
257      */
258     function exit()
259         public
260     {
261         // get token count for caller & sell them all
262         address _customerAddress = msg.sender;
263         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
264         if(_tokens > 0) sell(_tokens);
265         
266         // lambo delivery service
267         withdraw();
268     }
269 
270     /**
271      * Withdraws all of the callers earnings.
272      */
273     function withdraw()
274         onlyStronghands()
275         public
276     {
277         // setup data
278         address _customerAddress = msg.sender;
279         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
280         
281         // update dividend tracker
282         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
283         
284         // add ref. bonus
285         _dividends += referralBalance_[_customerAddress];
286         referralBalance_[_customerAddress] = 0;
287         
288         // lambo delivery service
289         _customerAddress.transfer(_dividends);
290         
291         // fire event
292         onWithdraw(_customerAddress, _dividends);
293     }
294     
295     /**
296      * Liquifies tokens to ethereum.
297      */
298     function sell(uint256 _amountOfTokens)
299         onlyBagholders()
300         public
301     {
302         // setup data
303         address _customerAddress = msg.sender;
304         // russian hackers BTFO
305         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
306         uint256 _tokens = _amountOfTokens;
307         uint256 _ethereum = tokensToEthereum_(_tokens);
308         uint256 _preDividends = SafeMath.div(_ethereum, dividendFee_);
309         uint256 _dividends = SafeMath.mul(_preDividends, feeMul_);
310         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
311         
312         // burn the sold tokens
313         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
314         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
315         
316         // update dividends tracker
317         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
318         payoutsTo_[_customerAddress] -= _updatedPayouts;       
319         
320         // dividing by zero is a bad idea
321         if (tokenSupply_ > 0) {
322             // update the amount of dividends per token
323             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
324         }
325         
326         // fire event
327         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
328     }
329     
330     
331     /**
332      * Transfer tokens from the caller to a new holder.
333      * Remember, there's a 10% fee here as well.
334      */
335     function transfer(address _toAddress, uint256 _amountOfTokens)
336         onlyBagholders()
337         public
338         returns(bool)
339     {
340         // setup
341         address _customerAddress = msg.sender;
342         
343         // make sure we have the requested tokens
344         // also disables transfers until ambassador phase is over
345         // ( we dont want whale premines )
346         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
347         
348         // withdraw all outstanding dividends first
349         if(myDividends(true) > 0) withdraw();
350         
351         // liquify 99% of the tokens that are transfered
352         // these are dispersed to shareholders
353         uint256 _preTokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
354         uint256 _tokenFee = SafeMath.mul(_preTokenFee, feeMul_);
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
380     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
381     /**
382      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
383      */
384     function disableInitialStage()
385         onlyAdministrator()
386         public
387     {
388         onlyAmbassadors = false;
389     }
390     
391     /**
392      * In case one of us dies, we need to replace ourselves.
393      */
394     function setAdministrator(bytes32 _identifier, bool _status)
395         onlyAdministrator()
396         public
397     {
398         administrators[_identifier] = _status;
399     }
400     
401     /**
402      * Precautionary measures in case we need to adjust the masternode rate.
403      */
404     function setStakingRequirement(uint256 _amountOfTokens)
405         onlyAdministrator()
406         public
407     {
408         stakingRequirement = _amountOfTokens;
409     }
410     
411     /**
412      * If we want to rebrand, we can.
413      */
414     function setName(string _name)
415         onlyAdministrator()
416         public
417     {
418         name = _name;
419     }
420     
421     /**
422      * If we want to rebrand, we can.
423      */
424     function setSymbol(string _symbol)
425         onlyAdministrator()
426         public
427     {
428         symbol = _symbol;
429     }
430 
431     
432     /*----------  HELPERS AND CALCULATORS  ----------*/
433     /**
434      * Method to view the current Ethereum stored in the contract
435      * Example: totalEthereumBalance()
436      */
437     function totalEthereumBalance()
438         public
439         view
440         returns(uint)
441     {
442         return this.balance;
443     }
444     
445     /**
446      * Retrieve the total token supply.
447      */
448     function totalSupply()
449         public
450         view
451         returns(uint256)
452     {
453         return tokenSupply_;
454     }
455     
456     /**
457      * Retrieve the tokens owned by the caller.
458      */
459     function myTokens()
460         public
461         view
462         returns(uint256)
463     {
464         address _customerAddress = msg.sender;
465         return balanceOf(_customerAddress);
466     }
467     
468     /**
469      * Retrieve the dividends owned by the caller.
470      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
471      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
472      * But in the internal calculations, we want them separate. 
473      */ 
474     function myDividends(bool _includeReferralBonus) 
475         public 
476         view 
477         returns(uint256)
478     {
479         address _customerAddress = msg.sender;
480         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
481     }
482     
483     /**
484      * Retrieve the token balance of any single address.
485      */
486     function balanceOf(address _customerAddress)
487         view
488         public
489         returns(uint256)
490     {
491         return tokenBalanceLedger_[_customerAddress];
492     }
493     
494     /**
495      * Retrieve the dividend balance of any single address.
496      */
497     function dividendsOf(address _customerAddress)
498         view
499         public
500         returns(uint256)
501     {
502         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
503     }
504     
505     /**
506      * Return the buy price of 1 individual token.
507      */
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
518             uint256 _preDividends = SafeMath.div(_ethereum, dividendFee_  );
519             uint256 _dividends = SafeMath.mul(_preDividends, feeMul_  );
520             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
521             return _taxedEthereum;
522         }
523     }
524     
525     /**
526      * Return the sell price of 1 individual token.
527      */
528     function buyPrice() 
529         public 
530         view 
531         returns(uint256)
532     {
533         // our calculation relies on the token supply, so we need supply. Doh.
534         if(tokenSupply_ == 0){
535             return tokenPriceInitial_ + tokenPriceIncremental_;
536         } else {
537             uint256 _ethereum = tokensToEthereum_(1e18);
538             uint256 _preDividends = SafeMath.div(_ethereum, dividendFee_  );
539             uint256 _dividends = SafeMath.mul(_preDividends, feeMul_  );
540             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
541             return _taxedEthereum;
542         }
543     }
544     
545     /**
546      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
547      */
548     function calculateTokensReceived(uint256 _ethereumToSpend) 
549         public 
550         view 
551         returns(uint256)
552     {
553         uint256 _preDividends = SafeMath.div(_ethereumToSpend, dividendFee_);
554         uint256 _dividends = SafeMath.mul(_preDividends, feeMul_);
555         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
556         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
557         
558         return _amountOfTokens;
559     }
560     
561     /**
562      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
563      */
564     function calculateEthereumReceived(uint256 _tokensToSell) 
565         public 
566         view 
567         returns(uint256)
568     {
569         require(_tokensToSell <= tokenSupply_);
570         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
571         uint256 _preDividends = SafeMath.div(_ethereum, dividendFee_);
572         uint256 _dividends = SafeMath.mul(_preDividends, feeMul_);
573         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
574         return _taxedEthereum;
575     }
576     
577     
578     /*==========================================
579     =            INTERNAL FUNCTIONS            =
580     ==========================================*/
581     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
582         antiEarlyWhale(_incomingEthereum)
583         internal
584         returns(uint256)
585     {
586         // data setup
587         address _customerAddress = msg.sender;
588         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_) * 99;
589         uint256 _referralBonus = SafeMath.div(_undividedDividends, 2);
590         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
591         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
592         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
593         uint256 _fee = _dividends * magnitude;
594  
595         // no point in continuing execution if OP is a poorfag russian hacker
596         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
597         // (or hackers)
598         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
599         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
600         
601         // is the user referred by a masternode?
602         if(
603             // is this a referred purchase?
604             _referredBy != 0x0000000000000000000000000000000000000000 &&
605 
606             // no cheating!
607             _referredBy != _customerAddress &&
608             
609             // does the referrer have at least X whole tokens?
610             // i.e is the referrer a godly chad masternode
611             tokenBalanceLedger_[_referredBy] >= stakingRequirement
612         ){
613             // wealth redistribution
614             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
615         } else {
616             // no ref purchase
617             // add the referral bonus back to the global dividends cake
618             _dividends = SafeMath.add(_dividends, _referralBonus);
619             _fee = _dividends * magnitude;
620         }
621         
622         // we can't give people infinite ethereum
623         if(tokenSupply_ > 0){
624             
625             // add tokens to the pool
626             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
627  
628             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
629             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
630             
631             // calculate the amount of tokens the customer receives over his purchase 
632             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
633         
634         } else {
635             // add tokens to the pool
636             tokenSupply_ = _amountOfTokens;
637         }
638         
639         // update circulating supply & the ledger address for the customer
640         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
641         
642         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
643         //really i know you think you do but you don't
644         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
645         payoutsTo_[_customerAddress] += _updatedPayouts;
646         
647         // fire event
648         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
649         
650         return _amountOfTokens;
651     }
652 
653     /**
654      * Calculate Token price based on an amount of incoming ethereum
655      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
656      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
657      */
658     function ethereumToTokens_(uint256 _ethereum)
659         internal
660         view
661         returns(uint256)
662     {
663         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
664         uint256 _tokensReceived = 
665          (
666             (
667                 // underflow attempts BTFO
668                 SafeMath.sub(
669                     (sqrt
670                         (
671                             (_tokenPriceInitial**2)
672                             +
673                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
674                             +
675                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
676                             +
677                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
678                         )
679                     ), _tokenPriceInitial
680                 )
681             )/(tokenPriceIncremental_)
682         )-(tokenSupply_)
683         ;
684   
685         return _tokensReceived;
686     }
687     
688     /**
689      * Calculate token sell value.
690      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
691      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
692      */
693      function tokensToEthereum_(uint256 _tokens)
694         internal
695         view
696         returns(uint256)
697     {
698 
699         uint256 tokens_ = (_tokens + 1e18);
700         uint256 _tokenSupply = (tokenSupply_ + 1e18);
701         uint256 _etherReceived =
702         (
703             // underflow attempts BTFO
704             SafeMath.sub(
705                 (
706                     (
707                         (
708                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
709                         )-tokenPriceIncremental_
710                     )*(tokens_ - 1e18)
711                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
712             )
713         /1e18);
714         return _etherReceived;
715     }
716     
717     
718     //This is where all your gas goes, sorry
719     //Not sorry, you probably only paid 1 gwei
720     function sqrt(uint x) internal pure returns (uint y) {
721         uint z = (x + 1) / 2;
722         y = x;
723         while (z < y) {
724             y = z;
725             z = (x / z + z) / 2;
726         }
727     }
728 }
729 
730 /**
731  * @title SafeMath
732  * @dev Math operations with safety checks that throw on error
733  */
734 library SafeMath {
735 
736     /**
737     * @dev Multiplies two numbers, throws on overflow.
738     */
739     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
740         if (a == 0) {
741             return 0;
742         }
743         uint256 c = a * b;
744         assert(c / a == b);
745         return c;
746     }
747 
748     /**
749     * @dev Integer division of two numbers, truncating the quotient.
750     */
751     function div(uint256 a, uint256 b) internal pure returns (uint256) {
752         // assert(b > 0); // Solidity automatically throws when dividing by 0
753         uint256 c = a / b;
754         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
755         return c;
756     }
757 
758     /**
759     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
760     */
761     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
762         assert(b <= a);
763         return a - b;
764     }
765 
766     /**
767     * @dev Adds two numbers, throws on overflow.
768     */
769     function add(uint256 a, uint256 b) internal pure returns (uint256) {
770         uint256 c = a + b;
771         assert(c >= a);
772         return c;
773     }
774 }