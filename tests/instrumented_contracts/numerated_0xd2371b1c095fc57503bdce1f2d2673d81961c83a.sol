1 pragma solidity ^0.4.20;
2 
3 /*
4 * ===================== HODL4D =======================*
5 * ___  ___  ________  ________  ___      ___   ___  ________     
6 *|\  \|\  \|\   __  \|\   ___ \|\  \    |\  \ |\  \|\   ___ \    
7 *\ \  \\\  \ \  \|\  \ \  \_|\ \ \  \   \ \  \\_\  \ \  \_|\ \   
8 * \ \   __  \ \  \\\  \ \  \ \\ \ \  \   \ \______  \ \  \ \\ \  
9 *  \ \  \ \  \ \  \\\  \ \  \_\\ \ \  \___\|_____|\  \ \  \_\\ \ 
10 *   \ \__\ \__\ \_______\ \_______\ \_______\    \ \__\ \_______\
11 *    \|__|\|__|\|_______|\|_______|\|_______|     \|__|\|_______|
12 *                                                                
13 * ===============================================================*
14 * -> What?
15 * The original autonomous pyramid, improved:
16 * [x] More stable than ever, having withstood severe testnet abuse and attack attempts from our community!.
17 * [x] Audited, tested, and approved by known community security specialists such as tocsick and Arc.
18 * [X] New functionality; you can now perform partial sell orders. If you succumb to weak hands, you don't have to dump all of your bags!
19 * [x] New functionality; you can now transfer tokens between wallets. Trading is now possible from within the contract!
20 * [x] New Feature: PoS Masternodes! The first implementation of Ethereum Staking in the world! Vitalik is mad.
21 * [x] Masternodes: Holding 1 HoDL4D Token allow you to generate a Masternode link, Masternode links are used as unique entry points to the contract!
22 *--------------------------------
23 * BOT PREVENTION/DETERRENCE
24 
25 * [x] Gwei Limit = 50
26 * [x] 1 ETH max buy in per TX until 50 ETH
27 * [x] Contract is timer activated (No TX activation)
28 *
29 * 
30 * -> Who worked on this project (Original P3D Contract)?
31 * - PonziBot (math/memes/main site/master)
32 * - Mantso (lead solidity dev/lead web3 dev)
33 * - swagg (concept design/feedback/management)
34 * - Anonymous#1 (main site/web3/test cases)
35 * - Anonymous#2 (math formulae/whitepaper)
36 *
37 * -> Who has audited & approved the project:
38 * - Arc
39 * - tocisck
40 * - sumpunk
41 */
42 
43 contract H4D {
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
70         require(administrators[(_customerAddress)]);
71         _;
72     }
73     
74     uint ACTIVATION_TIME = 1535155200;
75     
76     // ensures that the first tokens in the contract will be equally distributed
77     // meaning, no divine dump will be ever possible
78     // result: healthy longevity.
79     modifier antiEarlyWhale(uint256 _amountOfEthereum){
80         address _customerAddress = msg.sender;
81     
82         if (now >= ACTIVATION_TIME) {
83             onlyAmbassadors = false;
84         }
85         
86         // are we still in the vulnerable phase?
87         // if so, enact anti early whale protocol 
88         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
89             require(
90                 // is the customer in the ambassador list?
91                 ambassadors_[_customerAddress] == true &&
92                 
93                 // does the customer purchase exceed the max ambassador quota?
94                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
95                 
96             );
97             
98             // updated the accumulated quota    
99             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
100         
101             // execute
102             _;
103         } else {
104             // in case the ether count drops low, the ambassador phase won't reinitiate
105             onlyAmbassadors = false;
106             _;    
107         }
108         
109     }
110     
111     
112     /*==============================
113     =            EVENTS            =
114     ==============================*/
115     event onTokenPurchase(
116         address indexed customerAddress,
117         uint256 incomingEthereum,
118         uint256 tokensMinted,
119         address indexed referredBy
120     );
121     
122     event onTokenSell(
123         address indexed customerAddress,
124         uint256 tokensBurned,
125         uint256 ethereumEarned
126     );
127     
128     event onReinvestment(
129         address indexed customerAddress,
130         uint256 ethereumReinvested,
131         uint256 tokensMinted
132     );
133     
134     event onWithdraw(
135         address indexed customerAddress,
136         uint256 ethereumWithdrawn
137     );
138     
139     // ERC20
140     event Transfer(
141         address indexed from,
142         address indexed to,
143         uint256 tokens
144     );
145     
146     
147     /*=====================================
148     =            CONFIGURABLES            =
149     =====================================*/
150     string public name = "HoDL4D";
151     string public symbol = "H4D";
152     uint8 constant public decimals = 18;
153     uint8 constant internal dividendFee_ = 5;
154     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
155     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
156     uint256 constant internal magnitude = 2**64;
157     
158     // proof of stake (defaults at 100 tokens)
159     uint256 public stakingRequirement = 1;
160     
161     // ambassador program
162     mapping(address => bool) internal ambassadors_;
163     uint256 constant internal ambassadorMaxPurchase_ = .5 ether;
164     uint256 constant internal ambassadorQuota_ = 3.8 ether; // Placeholder
165     
166     
167     
168    /*================================
169     =            DATASETS            =
170     ================================*/
171     // amount of shares for each address (scaled number)
172     mapping(address => uint256) internal tokenBalanceLedger_;
173     mapping(address => uint256) internal referralBalance_;
174     mapping(address => int256) internal payoutsTo_;
175     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
176     uint256 internal tokenSupply_ = 0;
177     uint256 internal profitPerShare_;
178     
179     // administrator list (see above on what they can do)
180     mapping(address => bool) public administrators;
181     
182     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
183     bool public onlyAmbassadors = true;
184     
185 
186 
187     /*=======================================
188     =            PUBLIC FUNCTIONS            =
189     =======================================*/
190     /*
191     * -- APPLICATION ENTRY POINTS --  
192     */
193     function H4D()
194         public
195     {
196         // add administrators here
197         administrators[msg.sender] = true;
198         
199         // add the ambassadors here.
200         // Dev Account
201         ambassadors_[0xfc256291687150b9dB4502e721a9e6e98fd1FE93] = true;
202         
203         // Ambassador #2
204         ambassadors_[0x12b353d1a2842d2272ab5a18c6814d69f4296873] = true;
205         
206         // Ambassador #3
207         ambassadors_[0xD38A82102951b82ab7884e64552538FbFe701bad] = true;
208         
209         // Ambassador #4
210         ambassadors_[0x05f2c11996d73288AbE8a31d8b593a693FF2E5D8] = true;
211         
212         // Ambassador #5
213         ambassadors_[0x5632ca98e5788eddb2397757aa82d1ed6171e5ad] = true;
214         
215         // Ambassador #6
216         ambassadors_[0xab73e01ba3a8009d682726b752c11b1e9722f059] = true;
217         
218         // Ambassador #7
219         ambassadors_[0x87A7e71D145187eE9aAdc86954d39cf0e9446751] = true;
220         
221         // Ambassador #9
222         ambassadors_[0x71f35825a3B1528859dFa1A64b24242BC0d12990] = true;
223         
224         // Ambassador #8
225         ambassadors_[0xBac5E4ccB84fe2869b598996031d1a158ae4779b] = true;
226         
227         // Ambassador #10
228         ambassadors_[0xEc31176d4df0509115abC8065A8a3F8275aafF2b] = true;
229         
230         // Ambassador #11
231         ambassadors_[0x9d901bf10420682c232695b58dd96741e0600f0f] = true;
232         
233         // Ambassador #12
234         ambassadors_[0x126dEa51094ebd6cE43290aBb18e5cB405b2d3DE] = true;
235         
236         
237     }
238     
239      
240     /**
241      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
242      */
243     function buy(address _referredBy)
244         public
245         payable
246         returns(uint256)
247     {
248         if (address(this).balance <= 50 ether) {
249             require(msg.value <= 1 ether);
250         }
251         require(tx.gasprice <= 0.05 szabo);
252         purchaseTokens(msg.value, _referredBy);
253     }
254     
255     /**
256      * Fallback function to handle ethereum that was send straight to the contract
257      * Unfortunately we cannot use a referral address this way.
258      */
259     function()
260         payable
261         public
262     {
263         if (address(this).balance <= 50 ether) {
264             require(msg.value <= 1 ether);
265         }
266         require(tx.gasprice <= 0.05 szabo);
267         purchaseTokens(msg.value, 0x0);
268     }
269     
270     /**
271      * Converts all of caller's dividends to tokens.
272      */
273     function reinvest()
274         onlyStronghands()
275         public
276     {
277         // fetch dividends
278         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
279         
280         // pay out the dividends virtually
281         address _customerAddress = msg.sender;
282         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
283         
284         // retrieve ref. bonus
285         _dividends += referralBalance_[_customerAddress];
286         referralBalance_[_customerAddress] = 0;
287         
288         // dispatch a buy order with the virtualized "withdrawn dividends"
289         uint256 _tokens = purchaseTokens(_dividends, 0x0);
290         
291         // fire event
292         onReinvestment(_customerAddress, _dividends, _tokens);
293     }
294     
295     /**
296      * Alias of sell() and withdraw().
297      */
298     function exit()
299         public
300     {
301         // get token count for caller & sell them all
302         address _customerAddress = msg.sender;
303         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
304         if(_tokens > 0) sell(_tokens);
305         
306         // lambo delivery service
307         withdraw();
308     }
309 
310     /**
311      * Withdraws all of the callers earnings.
312      */
313     function withdraw()
314         onlyStronghands()
315         public
316     {
317         // setup data
318         address _customerAddress = msg.sender;
319         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
320         
321         // update dividend tracker
322         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
323         
324         // add ref. bonus
325         _dividends += referralBalance_[_customerAddress];
326         referralBalance_[_customerAddress] = 0;
327         
328         // lambo delivery service
329         _customerAddress.transfer(_dividends);
330         
331         // fire event
332         onWithdraw(_customerAddress, _dividends);
333     }
334     
335     /**
336      * Liquifies tokens to ethereum.
337      */
338     function sell(uint256 _amountOfTokens)
339         onlyBagholders()
340         public
341     {
342         // setup data
343         address _customerAddress = msg.sender;
344         // russian hackers BTFO
345         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
346         uint256 _tokens = _amountOfTokens;
347         uint256 _ethereum = tokensToEthereum_(_tokens);
348         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
349         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
350         
351         // burn the sold tokens
352         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
353         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
354         
355         // update dividends tracker
356         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
357         payoutsTo_[_customerAddress] -= _updatedPayouts;       
358         
359         // dividing by zero is a bad idea
360         if (tokenSupply_ > 0) {
361             // update the amount of dividends per token
362             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
363         }
364         
365         // fire event
366         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
367     }
368     
369     
370     /**
371      * Transfer tokens from the caller to a new holder.
372      * Remember, there's a 20% fee here as well.
373      */
374     function transfer(address _toAddress, uint256 _amountOfTokens)
375         onlyBagholders()
376         public
377         returns(bool)
378     {
379         // setup
380         address _customerAddress = msg.sender;
381         
382         // make sure we have the requested tokens
383         // also disables transfers until ambassador phase is over
384         // ( we dont want whale premines )
385         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
386         
387         // withdraw all outstanding dividends first
388         if(myDividends(true) > 0) withdraw();
389         
390         // liquify 10% of the tokens that are transfered
391         // these are dispersed to shareholders
392         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
393         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
394         uint256 _dividends = tokensToEthereum_(_tokenFee);
395   
396         // burn the fee tokens
397         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
398 
399         // exchange tokens
400         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
401         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
402         
403         // update dividend trackers
404         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
405         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
406         
407         // disperse dividends among holders
408         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
409         
410         // fire event
411         Transfer(_customerAddress, _toAddress, _taxedTokens);
412         
413         // ERC20
414         return true;
415        
416     }
417     
418     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
419     /**
420      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
421      */
422     //function disableInitialStage()
423     //    onlyAdministrator()
424     //    public
425     //{
426     //    onlyAmbassadors = false;
427     //}
428     
429     /**
430      * In case one of us dies, we need to replace ourselves.
431      */
432     function setAdministrator(address _identifier, bool _status)
433         onlyAdministrator()
434         public
435     {
436         administrators[_identifier] = _status;
437     }
438     
439     /**
440      * Precautionary measures in case we need to adjust the masternode rate.
441      */
442     function setStakingRequirement(uint256 _amountOfTokens)
443         onlyAdministrator()
444         public
445     {
446         stakingRequirement = _amountOfTokens;
447     }
448     
449     /**
450      * If we want to rebrand, we can.
451      */
452     function setName(string _name)
453         onlyAdministrator()
454         public
455     {
456         name = _name;
457     }
458     
459     /**
460      * If we want to rebrand, we can.
461      */
462     function setSymbol(string _symbol)
463         onlyAdministrator()
464         public
465     {
466         symbol = _symbol;
467     }
468 
469     
470     /*----------  HELPERS AND CALCULATORS  ----------*/
471     /**
472      * Method to view the current Ethereum stored in the contract
473      * Example: totalEthereumBalance()
474      */
475     function totalEthereumBalance()
476         public
477         view
478         returns(uint)
479     {
480         return this.balance;
481     }
482     
483     /**
484      * Retrieve the total token supply.
485      */
486     function totalSupply()
487         public
488         view
489         returns(uint256)
490     {
491         return tokenSupply_;
492     }
493     
494     /**
495      * Retrieve the tokens owned by the caller.
496      */
497     function myTokens()
498         public
499         view
500         returns(uint256)
501     {
502         address _customerAddress = msg.sender;
503         return balanceOf(_customerAddress);
504     }
505     
506     /**
507      * Retrieve the dividends owned by the caller.
508      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
509      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
510      * But in the internal calculations, we want them separate. 
511      */ 
512     function myDividends(bool _includeReferralBonus) 
513         public 
514         view 
515         returns(uint256)
516     {
517         address _customerAddress = msg.sender;
518         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
519     }
520     
521     /**
522      * Retrieve the token balance of any single address.
523      */
524     function balanceOf(address _customerAddress)
525         view
526         public
527         returns(uint256)
528     {
529         return tokenBalanceLedger_[_customerAddress];
530     }
531     
532     /**
533      * Retrieve the dividend balance of any single address.
534      */
535     function dividendsOf(address _customerAddress)
536         view
537         public
538         returns(uint256)
539     {
540         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
541     }
542     
543     /**
544      * Return the buy price of 1 individual token.
545      */
546     function sellPrice() 
547         public 
548         view 
549         returns(uint256)
550     {
551         // our calculation relies on the token supply, so we need supply. Doh.
552         if(tokenSupply_ == 0){
553             return tokenPriceInitial_ - tokenPriceIncremental_;
554         } else {
555             uint256 _ethereum = tokensToEthereum_(1e18);
556             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
557             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
558             return _taxedEthereum;
559         }
560     }
561     
562     /**
563      * Return the sell price of 1 individual token.
564      */
565     function buyPrice() 
566         public 
567         view 
568         returns(uint256)
569     {
570         // our calculation relies on the token supply, so we need supply. Doh.
571         if(tokenSupply_ == 0){
572             return tokenPriceInitial_ + tokenPriceIncremental_;
573         } else {
574             uint256 _ethereum = tokensToEthereum_(1e18);
575             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
576             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
577             return _taxedEthereum;
578         }
579     }
580     
581     /**
582      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
583      */
584     function calculateTokensReceived(uint256 _ethereumToSpend) 
585         public 
586         view 
587         returns(uint256)
588     {
589         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
590         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
591         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
592         
593         return _amountOfTokens;
594     }
595     
596     /**
597      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
598      */
599     function calculateEthereumReceived(uint256 _tokensToSell) 
600         public 
601         view 
602         returns(uint256)
603     {
604         require(_tokensToSell <= tokenSupply_);
605         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
606         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
607         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
608         return _taxedEthereum;
609     }
610     
611     
612     /*==========================================
613     =            INTERNAL FUNCTIONS            =
614     ==========================================*/
615     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
616         antiEarlyWhale(_incomingEthereum)
617         internal
618         returns(uint256)
619     {
620         // data setup
621         address _customerAddress = msg.sender;
622         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
623         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
624         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
625         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
626         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
627         uint256 _fee = _dividends * magnitude;
628  
629         // no point in continuing execution if OP is a poorfag russian hacker
630         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
631         // (or hackers)
632         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
633         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
634         
635         // is the user referred by a masternode?
636         if(
637             // is this a referred purchase?
638             _referredBy != 0x0000000000000000000000000000000000000000 &&
639 
640             // no cheating!
641             _referredBy != _customerAddress &&
642             
643             // does the referrer have at least X whole tokens?
644             // i.e is the referrer a godly chad masternode
645             tokenBalanceLedger_[_referredBy] >= stakingRequirement
646         ){
647             // wealth redistribution
648             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
649         } else {
650             // no ref purchase
651             // add the referral bonus back to the global dividends cake
652             _dividends = SafeMath.add(_dividends, _referralBonus);
653             _fee = _dividends * magnitude;
654         }
655         
656         // we can't give people infinite ethereum
657         if(tokenSupply_ > 0){
658             
659             // add tokens to the pool
660             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
661  
662             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
663             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
664             
665             // calculate the amount of tokens the customer receives over his purchase 
666             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
667         
668         } else {
669             // add tokens to the pool
670             tokenSupply_ = _amountOfTokens;
671         }
672         
673         // update circulating supply & the ledger address for the customer
674         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
675         
676         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
677         //really i know you think you do but you don't
678         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
679         payoutsTo_[_customerAddress] += _updatedPayouts;
680         
681         // fire event
682         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
683         
684         return _amountOfTokens;
685     }
686 
687     /**
688      * Calculate Token price based on an amount of incoming ethereum
689      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
690      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
691      */
692     function ethereumToTokens_(uint256 _ethereum)
693         internal
694         view
695         returns(uint256)
696     {
697         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
698         uint256 _tokensReceived = 
699          (
700             (
701                 // underflow attempts BTFO
702                 SafeMath.sub(
703                     (sqrt
704                         (
705                             (_tokenPriceInitial**2)
706                             +
707                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
708                             +
709                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
710                             +
711                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
712                         )
713                     ), _tokenPriceInitial
714                 )
715             )/(tokenPriceIncremental_)
716         )-(tokenSupply_)
717         ;
718   
719         return _tokensReceived;
720     }
721     
722     /**
723      * Calculate token sell value.
724      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
725      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
726      */
727      function tokensToEthereum_(uint256 _tokens)
728         internal
729         view
730         returns(uint256)
731     {
732 
733         uint256 tokens_ = (_tokens + 1e18);
734         uint256 _tokenSupply = (tokenSupply_ + 1e18);
735         uint256 _etherReceived =
736         (
737             // underflow attempts BTFO
738             SafeMath.sub(
739                 (
740                     (
741                         (
742                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
743                         )-tokenPriceIncremental_
744                     )*(tokens_ - 1e18)
745                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
746             )
747         /1e18);
748         return _etherReceived;
749     }
750     
751     
752     //This is where all your gas goes, sorry
753     //Not sorry, you probably only paid 1 gwei
754     function sqrt(uint x) internal pure returns (uint y) {
755         uint z = (x + 1) / 2;
756         y = x;
757         while (z < y) {
758             y = z;
759             z = (x / z + z) / 2;
760         }
761     }
762 }
763 
764 /**
765  * @title SafeMath
766  * @dev Math operations with safety checks that throw on error
767  */
768 library SafeMath {
769 
770     /**
771     * @dev Multiplies two numbers, throws on overflow.
772     */
773     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
774         if (a == 0) {
775             return 0;
776         }
777         uint256 c = a * b;
778         assert(c / a == b);
779         return c;
780     }
781 
782     /**
783     * @dev Integer division of two numbers, truncating the quotient.
784     */
785     function div(uint256 a, uint256 b) internal pure returns (uint256) {
786         // assert(b > 0); // Solidity automatically throws when dividing by 0
787         // assert(b > 0 *VGhpcyBjb250cmFjdCB3YXMgbWFkZSBleGNsdXNpdmVseSBmb3IgaHR0cHM6Ly9oNGQuaW8=); //
788         uint256 c = a / b;
789         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
790         return c;
791     }
792 
793     /**
794     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
795     */
796     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
797         assert(b <= a);
798         return a - b;
799     }
800 
801     /**
802     * @dev Adds two numbers, throws on overflow.
803     */
804     function add(uint256 a, uint256 b) internal pure returns (uint256) {
805         uint256 c = a + b;
806         assert(c >= a);
807         return c;
808     }
809 }