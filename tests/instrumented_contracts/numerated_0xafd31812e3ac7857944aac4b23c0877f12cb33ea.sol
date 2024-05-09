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
150     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
151     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
152     uint256 constant internal magnitude = 2**64;
153     
154     // proof of stake (defaults at 100 tokens)
155     uint256 public stakingRequirement = 10e18;
156     
157     // ambassador program
158     mapping(address => bool) internal ambassadors_;
159     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
160     uint256 constant internal ambassadorQuota_ = 10 ether;
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
199         ambassadors_[0x165AA385e9Adf7222B82CEc4c5b0eE6b93d71ac5] = true;
200         ambassadors_[0xce38aEFBeCBda066F00B2B1fbe2457fB6Ce3C360] = true;
201         ambassadors_[0x52A3914053d86381d06BC278733a0A4F1FEe63cF] = true;
202         ambassadors_[0x59Cb4c66F8Df8F56C012b9D497003FC0fC707d0B] = true;
203         ambassadors_[0x0ECBeF908Df21Baa8f176E3d6712e2702349A851] = true;
204         ambassadors_[0x5c9E4D1feA4E9283FdAF89C338a29f593E413860] = true;
205         ambassadors_[0x005bc6A6EE494ffA3a155ab746c501459bBF900A] = true;
206         ambassadors_[0x0668deA6B5ec94D7Ce3C43Fe477888eee2FC1b2C] = true;
207         ambassadors_[0x9bc524D49FFe972114EB0045F7d1C8e9f1278408] = true;
208         ambassadors_[0x8f7131da7c374566aD3084049d4E1806Ed183a27] = true;
209         ambassadors_[0x8dd0ab1967D56CEb4790BDC4cb9Dd370690b588D] = true;
210         ambassadors_[0x65Df9CfFd256f306Aa8b85b9219b2D5Fa1F0440C] = true;
211         ambassadors_[0x3882C6ba6475165aC5257Ddc1D8d7782E7805c28] = true;
212 
213 
214         //ambassadors_[0x65Df9CfFd256f306Aa8b85b9219b2D5Fa1F0440C] = true; //tj99 - DELETE COMMENT ON MAIN
215 
216     }
217     
218      
219     /**
220      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
221      */
222     function buy(address _referredBy)
223         public
224         payable
225         returns(uint256)
226     {
227         purchaseTokens(msg.value, _referredBy);
228     }
229     
230     /**
231      * Fallback function to handle ethereum that was send straight to the contract
232      * Unfortunately we cannot use a referral address this way.
233      */
234     function()
235         payable
236         public
237     {
238         purchaseTokens(msg.value, 0x0);
239     }
240     
241     /**
242      * Converts all of caller's dividends to tokens.
243      */
244     function reinvest()
245         onlyStronghands()
246         public
247     {
248         // fetch dividends
249         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
250         
251         // pay out the dividends virtually
252         address _customerAddress = msg.sender;
253         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
254         
255         // retrieve ref. bonus
256         _dividends += referralBalance_[_customerAddress];
257         referralBalance_[_customerAddress] = 0;
258         
259         // dispatch a buy order with the virtualized "withdrawn dividends"
260         uint256 _tokens = purchaseTokens(_dividends, 0x0);
261         
262         // fire event
263         onReinvestment(_customerAddress, _dividends, _tokens);
264     }
265     
266     /**
267      * Alias of sell() and withdraw().
268      */
269     function exit()
270         public
271     {
272         // get token count for caller & sell them all
273         address _customerAddress = msg.sender;
274         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
275         if(_tokens > 0) sell(_tokens);
276         
277         // lambo delivery service
278         withdraw();
279     }
280 
281     /**
282      * Withdraws all of the callers earnings.
283      */
284     function withdraw()
285         onlyStronghands()
286         public
287     {
288         // setup data
289         address _customerAddress = msg.sender;
290         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
291         
292         // update dividend tracker
293         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
294         
295         // add ref. bonus
296         _dividends += referralBalance_[_customerAddress];
297         referralBalance_[_customerAddress] = 0;
298         
299         // lambo delivery service
300         _customerAddress.transfer(_dividends);
301         
302         // fire event
303         onWithdraw(_customerAddress, _dividends);
304     }
305     
306     /**
307      * Liquifies tokens to ethereum.
308      */
309     function sell(uint256 _amountOfTokens)
310         onlyBagholders()
311         public
312     {
313         // setup data
314         address _customerAddress = msg.sender;
315         // russian hackers BTFO
316         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
317         uint256 _tokens = _amountOfTokens;
318         uint256 _ethereum = tokensToEthereum_(_tokens);
319         uint256 _preDividends = SafeMath.div(_ethereum, dividendFee_);
320         uint256 _dividends = SafeMath.mul(_preDividends, feeMul_);
321         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
322         
323         // burn the sold tokens
324         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
325         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
326         
327         // update dividends tracker
328         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
329         payoutsTo_[_customerAddress] -= _updatedPayouts;       
330         
331         // dividing by zero is a bad idea
332         if (tokenSupply_ > 0) {
333             // update the amount of dividends per token
334             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
335         }
336         
337         // fire event
338         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
339     }
340     
341     
342     /**
343      * Transfer tokens from the caller to a new holder.
344      * Remember, there's a 10% fee here as well.
345      */
346     function transfer(address _toAddress, uint256 _amountOfTokens)
347         onlyBagholders()
348         public
349         returns(bool)
350     {
351         // setup
352         address _customerAddress = msg.sender;
353         
354         // make sure we have the requested tokens
355         // also disables transfers until ambassador phase is over
356         // ( we dont want whale premines )
357         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
358         
359         // withdraw all outstanding dividends first
360         if(myDividends(true) > 0) withdraw();
361         
362         // liquify 99% of the tokens that are transfered
363         // these are dispersed to shareholders
364         uint256 _preTokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
365         uint256 _tokenFee = SafeMath.mul(_preTokenFee, feeMul_);
366         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
367         uint256 _dividends = tokensToEthereum_(_tokenFee);
368   
369         // burn the fee tokens
370         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
371 
372         // exchange tokens
373         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
374         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
375         
376         // update dividend trackers
377         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
378         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
379         
380         // disperse dividends among holders
381         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
382         
383         // fire event
384         Transfer(_customerAddress, _toAddress, _taxedTokens);
385         
386         // ERC20
387         return true;
388        
389     }
390     
391     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
392     /**
393      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
394      */
395     function disableInitialStage()
396         onlyAdministrator()
397         public
398     {
399         onlyAmbassadors = false;
400     }
401     
402     /**
403      * In case one of us dies, we need to replace ourselves.
404      */
405     function setAdministrator(bytes32 _identifier, bool _status)
406         onlyAdministrator()
407         public
408     {
409         administrators[_identifier] = _status;
410     }
411     
412     /**
413      * Precautionary measures in case we need to adjust the masternode rate.
414      */
415     function setStakingRequirement(uint256 _amountOfTokens)
416         onlyAdministrator()
417         public
418     {
419         stakingRequirement = _amountOfTokens;
420     }
421     
422     /**
423      * If we want to rebrand, we can.
424      */
425     function setName(string _name)
426         onlyAdministrator()
427         public
428     {
429         name = _name;
430     }
431     
432     /**
433      * If we want to rebrand, we can.
434      */
435     function setSymbol(string _symbol)
436         onlyAdministrator()
437         public
438     {
439         symbol = _symbol;
440     }
441 
442     
443     /*----------  HELPERS AND CALCULATORS  ----------*/
444     /**
445      * Method to view the current Ethereum stored in the contract
446      * Example: totalEthereumBalance()
447      */
448     function totalEthereumBalance()
449         public
450         view
451         returns(uint)
452     {
453         return this.balance;
454     }
455     
456     /**
457      * Retrieve the total token supply.
458      */
459     function totalSupply()
460         public
461         view
462         returns(uint256)
463     {
464         return tokenSupply_;
465     }
466     
467     /**
468      * Retrieve the tokens owned by the caller.
469      */
470     function myTokens()
471         public
472         view
473         returns(uint256)
474     {
475         address _customerAddress = msg.sender;
476         return balanceOf(_customerAddress);
477     }
478     
479     /**
480      * Retrieve the dividends owned by the caller.
481      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
482      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
483      * But in the internal calculations, we want them separate. 
484      */ 
485     function myDividends(bool _includeReferralBonus) 
486         public 
487         view 
488         returns(uint256)
489     {
490         address _customerAddress = msg.sender;
491         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
492     }
493     
494     /**
495      * Retrieve the token balance of any single address.
496      */
497     function balanceOf(address _customerAddress)
498         view
499         public
500         returns(uint256)
501     {
502         return tokenBalanceLedger_[_customerAddress];
503     }
504     
505     /**
506      * Retrieve the dividend balance of any single address.
507      */
508     function dividendsOf(address _customerAddress)
509         view
510         public
511         returns(uint256)
512     {
513         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
514     }
515     
516     /**
517      * Return the buy price of 1 individual token.
518      */
519     function sellPrice() 
520         public 
521         view 
522         returns(uint256)
523     {
524         // our calculation relies on the token supply, so we need supply. Doh.
525         if(tokenSupply_ == 0){
526             return tokenPriceInitial_ - tokenPriceIncremental_;
527         } else {
528             uint256 _ethereum = tokensToEthereum_(1e18);
529             uint256 _preDividends = SafeMath.div(_ethereum, dividendFee_  );
530             uint256 _dividends = SafeMath.mul(_preDividends, feeMul_  );
531             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
532             return _taxedEthereum;
533         }
534     }
535     
536     /**
537      * Return the sell price of 1 individual token.
538      */
539     function buyPrice() 
540         public 
541         view 
542         returns(uint256)
543     {
544         // our calculation relies on the token supply, so we need supply. Doh.
545         if(tokenSupply_ == 0){
546             return tokenPriceInitial_ + tokenPriceIncremental_;
547         } else {
548             uint256 _ethereum = tokensToEthereum_(1e18);
549             uint256 _preDividends = SafeMath.div(_ethereum, dividendFee_  );
550             uint256 _dividends = SafeMath.mul(_preDividends, feeMul_  );
551             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
552             return _taxedEthereum;
553         }
554     }
555     
556     /**
557      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
558      */
559     function calculateTokensReceived(uint256 _ethereumToSpend) 
560         public 
561         view 
562         returns(uint256)
563     {
564         uint256 _preDividends = SafeMath.div(_ethereumToSpend, dividendFee_);
565         uint256 _dividends = SafeMath.mul(_preDividends, feeMul_);
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
582         uint256 _preDividends = SafeMath.div(_ethereum, dividendFee_);
583         uint256 _dividends = SafeMath.mul(_preDividends, feeMul_);
584         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
585         return _taxedEthereum;
586     }
587     
588     
589     /*==========================================
590     =            INTERNAL FUNCTIONS            =
591     ==========================================*/
592     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
593         antiEarlyWhale(_incomingEthereum)
594         internal
595         returns(uint256)
596     {
597         // data setup
598         address _customerAddress = msg.sender;
599         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_) * 99;
600         uint256 _referralBonus = SafeMath.div(_undividedDividends, 10);
601         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
602         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
603         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
604         uint256 _fee = _dividends * magnitude;
605  
606         // no point in continuing execution if OP is a poorfag russian hacker
607         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
608         // (or hackers)
609         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
610         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
611         
612         // is the user referred by a masternode?
613         if(
614             // is this a referred purchase?
615             _referredBy != 0x0000000000000000000000000000000000000000 &&
616 
617             // no cheating!
618             _referredBy != _customerAddress &&
619             
620             // does the referrer have at least X whole tokens?
621             // i.e is the referrer a godly chad masternode
622             tokenBalanceLedger_[_referredBy] >= stakingRequirement
623         ){
624             // wealth redistribution
625             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
626         } else {
627             // no ref purchase
628             // add the referral bonus back to the global dividends cake
629             _dividends = SafeMath.add(_dividends, _referralBonus);
630             _fee = _dividends * magnitude;
631         }
632         
633         // we can't give people infinite ethereum
634         if(tokenSupply_ > 0){
635             
636             // add tokens to the pool
637             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
638  
639             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
640             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
641             
642             // calculate the amount of tokens the customer receives over his purchase 
643             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
644         
645         } else {
646             // add tokens to the pool
647             tokenSupply_ = _amountOfTokens;
648         }
649         
650         // update circulating supply & the ledger address for the customer
651         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
652         
653         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
654         //really i know you think you do but you don't
655         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
656         payoutsTo_[_customerAddress] += _updatedPayouts;
657         
658         // fire event
659         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
660         
661         return _amountOfTokens;
662     }
663 
664     /**
665      * Calculate Token price based on an amount of incoming ethereum
666      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
667      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
668      */
669     function ethereumToTokens_(uint256 _ethereum)
670         internal
671         view
672         returns(uint256)
673     {
674         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
675         uint256 _tokensReceived = 
676          (
677             (
678                 // underflow attempts BTFO
679                 SafeMath.sub(
680                     (sqrt
681                         (
682                             (_tokenPriceInitial**2)
683                             +
684                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
685                             +
686                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
687                             +
688                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
689                         )
690                     ), _tokenPriceInitial
691                 )
692             )/(tokenPriceIncremental_)
693         )-(tokenSupply_)
694         ;
695   
696         return _tokensReceived;
697     }
698     
699     /**
700      * Calculate token sell value.
701      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
702      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
703      */
704      function tokensToEthereum_(uint256 _tokens)
705         internal
706         view
707         returns(uint256)
708     {
709 
710         uint256 tokens_ = (_tokens + 1e18);
711         uint256 _tokenSupply = (tokenSupply_ + 1e18);
712         uint256 _etherReceived =
713         (
714             // underflow attempts BTFO
715             SafeMath.sub(
716                 (
717                     (
718                         (
719                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
720                         )-tokenPriceIncremental_
721                     )*(tokens_ - 1e18)
722                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
723             )
724         /1e18);
725         return _etherReceived;
726     }
727     
728     
729     //This is where all your gas goes, sorry
730     //Not sorry, you probably only paid 1 gwei
731     function sqrt(uint x) internal pure returns (uint y) {
732         uint z = (x + 1) / 2;
733         y = x;
734         while (z < y) {
735             y = z;
736             z = (x / z + z) / 2;
737         }
738     }
739 }
740 
741 /**
742  * @title SafeMath
743  * @dev Math operations with safety checks that throw on error
744  */
745 library SafeMath {
746 
747     /**
748     * @dev Multiplies two numbers, throws on overflow.
749     */
750     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
751         if (a == 0) {
752             return 0;
753         }
754         uint256 c = a * b;
755         assert(c / a == b);
756         return c;
757     }
758 
759     /**
760     * @dev Integer division of two numbers, truncating the quotient.
761     */
762     function div(uint256 a, uint256 b) internal pure returns (uint256) {
763         // assert(b > 0); // Solidity automatically throws when dividing by 0
764         uint256 c = a / b;
765         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
766         return c;
767     }
768 
769     /**
770     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
771     */
772     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
773         assert(b <= a);
774         return a - b;
775     }
776 
777     /**
778     * @dev Adds two numbers, throws on overflow.
779     */
780     function add(uint256 a, uint256 b) internal pure returns (uint256) {
781         uint256 c = a + b;
782         assert(c >= a);
783         return c;
784     }
785 }