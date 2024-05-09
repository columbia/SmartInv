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
26 * [x] 1 ETH max buy in per TX until 100 ETH
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
75     // unit VGhpcyBjb250cmFjdCB3YXMgbWFkZSBmb3IgaHR0cHM6Ly9oNGQuaW8gYnkgZGlzY29yZCB1c2VyIEBCYW5rc3kjODUxNw==
76     
77     // ensures that the first tokens in the contract will be equally distributed
78     // meaning, no divine dump will be ever possible
79     // result: healthy longevity.
80     modifier antiEarlyWhale(uint256 _amountOfEthereum){
81         address _customerAddress = msg.sender;
82     
83         if (now >= ACTIVATION_TIME) {
84             onlyAmbassadors = false;
85         }
86         
87         // are we still in the vulnerable phase?
88         // if so, enact anti early whale protocol 
89         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
90             require(
91                 // is the customer in the ambassador list?
92                 ambassadors_[_customerAddress] == true &&
93                 
94                 // does the customer purchase exceed the max ambassador quota?
95                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
96                 
97             );
98             
99             // updated the accumulated quota    
100             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
101         
102             // execute
103             _;
104         } else {
105             // in case the ether count drops low, the ambassador phase won't reinitiate
106             onlyAmbassadors = false;
107             _;    
108         }
109         
110     }
111     
112     
113     /*==============================
114     =            EVENTS            =
115     ==============================*/
116     event onTokenPurchase(
117         address indexed customerAddress,
118         uint256 incomingEthereum,
119         uint256 tokensMinted,
120         address indexed referredBy
121     );
122     
123     event onTokenSell(
124         address indexed customerAddress,
125         uint256 tokensBurned,
126         uint256 ethereumEarned
127     );
128     
129     event onReinvestment(
130         address indexed customerAddress,
131         uint256 ethereumReinvested,
132         uint256 tokensMinted
133     );
134     
135     event onWithdraw(
136         address indexed customerAddress,
137         uint256 ethereumWithdrawn
138     );
139     
140     // ERC20
141     event Transfer(
142         address indexed from,
143         address indexed to,
144         uint256 tokens
145     );
146     
147     
148     /*=====================================
149     =            CONFIGURABLES            =
150     =====================================*/
151     string public name = "HoDL4D";
152     string public symbol = "H4D";
153     uint8 constant public decimals = 18;
154     uint8 constant internal dividendFee_ = 5;
155     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
156     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
157     uint256 constant internal magnitude = 2**64;
158     
159     // proof of stake (defaults at 100 tokens)
160     uint256 public stakingRequirement = 1;
161     
162     // ambassador program
163     mapping(address => bool) internal ambassadors_;
164     uint256 constant internal ambassadorMaxPurchase_ = .5 ether;
165     uint256 constant internal ambassadorQuota_ = 3.5 ether;
166     
167     
168     
169    /*================================
170     =            DATASETS            =
171     ================================*/
172     // amount of shares for each address (scaled number)
173     mapping(address => uint256) internal tokenBalanceLedger_;
174     mapping(address => uint256) internal referralBalance_;
175     mapping(address => int256) internal payoutsTo_;
176     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
177     uint256 internal tokenSupply_ = 0;
178     uint256 internal profitPerShare_;
179     
180     // administrator list (see above on what they can do)
181     mapping(address => bool) public administrators;
182     
183     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
184     bool public onlyAmbassadors = true;
185     
186 
187 
188     /*=======================================
189     =            PUBLIC FUNCTIONS            =
190     =======================================*/
191     /*
192     * -- APPLICATION ENTRY POINTS --  
193     */
194     function H4D()
195         public
196     {
197         // add administrators here
198         administrators[msg.sender] = true;
199         
200         // add the ambassadors here.
201         // Dev Account 
202         ambassadors_[0xfc256291687150b9dB4502e721a9e6e98fd1FE93] = true;
203         
204         // Ambassador #2
205         ambassadors_[0x12b353d1a2842d2272ab5a18c6814d69f4296873] = true;
206         
207         // Ambassador #3
208         ambassadors_[0xD38A82102951b82ab7884e64552538FbFe701bad] = true;
209         
210         // Ambassador #4
211         ambassadors_[0x05f2c11996d73288AbE8a31d8b593a693FF2E5D8] = true;
212         
213         // Ambassador #5
214         ambassadors_[0x5632ca98e5788eddb2397757aa82d1ed6171e5ad] = true;
215         
216         // Ambassador #6
217         ambassadors_[0xab73e01ba3a8009d682726b752c11b1e9722f059] = true;
218         
219         // Ambassador #7
220         ambassadors_[0x87A7e71D145187eE9aAdc86954d39cf0e9446751] = true;
221         
222         // Ambassador #8
223         ambassadors_[0xBac5E4ccB84fe2869b598996031d1a158ae4779b] = true;
224         
225         // Ambassador #9
226         ambassadors_[0x126dEa51094ebd6cE43290aBb18e5cB405b2d3DE] = true;
227     }
228     
229      
230     /**
231      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
232      */
233     function buy(address _referredBy)
234         public
235         payable
236         returns(uint256)
237     {
238         if (address(this).balance <= 100 ether) {
239             require(msg.value <= 1 ether);
240         }
241         require(tx.gasprice <= 0.05 szabo);
242         purchaseTokens(msg.value, _referredBy);
243     }
244     
245     /**
246      * Fallback function to handle ethereum that was send straight to the contract
247      * Unfortunately we cannot use a referral address this way.
248      */
249     function()
250         payable
251         public
252     {
253         if (address(this).balance <= 100 ether) {
254             require(msg.value <= 1 ether);
255         }
256         require(tx.gasprice <= 0.06 szabo);
257         purchaseTokens(msg.value, 0x0);
258     }
259     // unit VGhpcyBjb250cmFjdCB3YXMgbWFkZSBmb3IgaHR0cHM6Ly9oNGQuaW8gYnkgZGlzY29yZCB1c2VyIEBCYW5rc3kjODUxNw==
260     /**
261      * Converts all of caller's dividends to tokens.
262      */
263     function reinvest()
264         onlyStronghands()
265         public
266     {
267         // fetch dividends
268         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
269         
270         // pay out the dividends virtually
271         address _customerAddress = msg.sender;
272         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
273         
274         // retrieve ref. bonus
275         _dividends += referralBalance_[_customerAddress];
276         referralBalance_[_customerAddress] = 0;
277         
278         // dispatch a buy order with the virtualized "withdrawn dividends"
279         uint256 _tokens = purchaseTokens(_dividends, 0x0);
280         
281         // fire event
282         onReinvestment(_customerAddress, _dividends, _tokens);
283     }
284     
285     /**
286      * Alias of sell() and withdraw().
287      */
288     function exit()
289         public
290     {
291         // get token count for caller & sell them all
292         address _customerAddress = msg.sender;
293         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
294         if(_tokens > 0) sell(_tokens);
295         
296         // lambo delivery service
297         withdraw();
298     }
299 
300     /**
301      * Withdraws all of the callers earnings.
302      */
303     function withdraw()
304         onlyStronghands()
305         public
306     {
307         // setup data
308         address _customerAddress = msg.sender;
309         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
310         
311         // update dividend tracker
312         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
313         
314         // add ref. bonus
315         _dividends += referralBalance_[_customerAddress];
316         referralBalance_[_customerAddress] = 0;
317         
318         // lambo delivery service
319         _customerAddress.transfer(_dividends);
320         
321         // fire event
322         onWithdraw(_customerAddress, _dividends);
323     }
324     
325     /**
326      * Liquifies tokens to ethereum.
327      */
328     function sell(uint256 _amountOfTokens)
329         onlyBagholders()
330         public
331     {
332         // setup data
333         address _customerAddress = msg.sender;
334         // russian hackers BTFO
335         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
336         uint256 _tokens = _amountOfTokens;
337         uint256 _ethereum = tokensToEthereum_(_tokens);
338         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
339         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
340         
341         // burn the sold tokens
342         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
343         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
344         
345         // update dividends tracker
346         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
347         payoutsTo_[_customerAddress] -= _updatedPayouts;       
348         
349         // dividing by zero is a bad idea
350         if (tokenSupply_ > 0) {
351             // update the amount of dividends per token
352             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
353         }
354         
355         // fire event
356         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
357     }
358     
359     
360     /**
361      * Transfer tokens from the caller to a new holder.
362      * Remember, there's a 20% fee here as well.
363      */
364     function transfer(address _toAddress, uint256 _amountOfTokens)
365         onlyBagholders()
366         public
367         returns(bool)
368     {
369         // setup
370         address _customerAddress = msg.sender;
371         
372         // make sure we have the requested tokens
373         // also disables transfers until ambassador phase is over
374         // ( we dont want whale premines )
375         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
376         
377         // withdraw all outstanding dividends first
378         if(myDividends(true) > 0) withdraw();
379         
380         // liquify 10% of the tokens that are transfered
381         // these are dispersed to shareholders
382         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
383         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
384         uint256 _dividends = tokensToEthereum_(_tokenFee);
385   
386         // burn the fee tokens
387         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
388 
389         // exchange tokens
390         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
391         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
392         
393         // update dividend trackers
394         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
395         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
396         
397         // disperse dividends among holders
398         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
399         
400         // fire event
401         Transfer(_customerAddress, _toAddress, _taxedTokens);
402         
403         // ERC20
404         return true;
405        
406     }
407     
408     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
409     /**
410      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
411      */
412     //function disableInitialStage()
413     //    onlyAdministrator()
414     //    public
415     //{
416     //    onlyAmbassadors = false;
417     //}
418     
419     /**
420      * In case one of us dies, we need to replace ourselves.
421      */
422     function setAdministrator(address _identifier, bool _status)
423         onlyAdministrator()
424         public
425     {
426         administrators[_identifier] = _status;
427     }
428     
429     /**
430      * Precautionary measures in case we need to adjust the masternode rate.
431      */
432     function setStakingRequirement(uint256 _amountOfTokens)
433         onlyAdministrator()
434         public
435     {
436         stakingRequirement = _amountOfTokens;
437     }
438     
439     /**
440      * If we want to rebrand, we can.
441      */
442     function setName(string _name)
443         onlyAdministrator()
444         public
445     {
446         name = _name;
447     }
448     
449     /**
450      * If we want to rebrand, we can.
451      */
452     function setSymbol(string _symbol)
453         onlyAdministrator()
454         public
455     {
456         symbol = _symbol;
457     }
458 
459     
460     /*----------  HELPERS AND CALCULATORS  ----------*/
461     /**
462      * Method to view the current Ethereum stored in the contract
463      * Example: totalEthereumBalance()
464      */
465     function totalEthereumBalance()
466         public
467         view
468         returns(uint)
469     {
470         return this.balance;
471     }
472     
473     /**
474      * Retrieve the total token supply.
475      */
476     function totalSupply()
477         public
478         view
479         returns(uint256)
480     {
481         return tokenSupply_;
482     }
483     
484     /**
485      * Retrieve the tokens owned by the caller.
486      */
487     function myTokens()
488         public
489         view
490         returns(uint256)
491     {
492         address _customerAddress = msg.sender;
493         return balanceOf(_customerAddress);
494     }
495     
496     /**
497      * Retrieve the dividends owned by the caller.
498      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
499      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
500      * But in the internal calculations, we want them separate. 
501      */ 
502     function myDividends(bool _includeReferralBonus) 
503         public 
504         view 
505         returns(uint256)
506     {
507         address _customerAddress = msg.sender;
508         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
509     }
510     
511     /**
512      * Retrieve the token balance of any single address.
513      */
514     function balanceOf(address _customerAddress)
515         view
516         public
517         returns(uint256)
518     {
519         return tokenBalanceLedger_[_customerAddress];
520     }
521     
522     /**
523      * Retrieve the dividend balance of any single address.
524      */
525     function dividendsOf(address _customerAddress)
526         view
527         public
528         returns(uint256)
529     {
530         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
531     }
532     
533     /**
534      * Return the buy price of 1 individual token.
535      */
536     function sellPrice() 
537         public 
538         view 
539         returns(uint256)
540     {
541         // our calculation relies on the token supply, so we need supply. Doh.
542         if(tokenSupply_ == 0){
543             return tokenPriceInitial_ - tokenPriceIncremental_;
544         } else {
545             uint256 _ethereum = tokensToEthereum_(1e18);
546             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
547             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
548             return _taxedEthereum;
549         }
550     }
551     
552     /**
553      * Return the sell price of 1 individual token.
554      */
555     function buyPrice() 
556         public 
557         view 
558         returns(uint256)
559     {
560         // our calculation relies on the token supply, so we need supply. Doh.
561         if(tokenSupply_ == 0){
562             return tokenPriceInitial_ + tokenPriceIncremental_;
563         } else {
564             uint256 _ethereum = tokensToEthereum_(1e18);
565             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
566             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
567             return _taxedEthereum;
568         }
569     }
570     
571     /**
572      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
573      */
574     function calculateTokensReceived(uint256 _ethereumToSpend) 
575         public 
576         view 
577         returns(uint256)
578     {
579         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
580         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
581         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
582         
583         return _amountOfTokens;
584     }
585     
586     /**
587      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
588      */
589     function calculateEthereumReceived(uint256 _tokensToSell) 
590         public 
591         view 
592         returns(uint256)
593     {
594         require(_tokensToSell <= tokenSupply_);
595         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
596         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
597         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
598         return _taxedEthereum;
599     }
600     
601     
602     /*==========================================
603     =            INTERNAL FUNCTIONS            =
604     ==========================================*/
605     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
606         antiEarlyWhale(_incomingEthereum)
607         internal
608         returns(uint256)
609     {
610         // data setup
611         address _customerAddress = msg.sender;
612         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
613         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
614         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
615         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
616         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
617         uint256 _fee = _dividends * magnitude;
618  
619         // no point in continuing execution if OP is a poorfag russian hacker
620         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
621         // (or hackers)
622         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
623         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
624         
625         // is the user referred by a masternode?
626         if(
627             // is this a referred purchase?
628             _referredBy != 0x0000000000000000000000000000000000000000 &&
629 
630             // no cheating!
631             _referredBy != _customerAddress &&
632             
633             // does the referrer have at least X whole tokens?
634             // i.e is the referrer a godly chad masternode
635             tokenBalanceLedger_[_referredBy] >= stakingRequirement
636         ){
637             // wealth redistribution
638             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
639         } else {
640             // no ref purchase
641             // add the referral bonus back to the global dividends cake
642             _dividends = SafeMath.add(_dividends, _referralBonus);
643             _fee = _dividends * magnitude;
644         }
645         
646         // we can't give people infinite ethereum
647         if(tokenSupply_ > 0){
648             
649             // add tokens to the pool
650             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
651  
652             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
653             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
654             
655             // calculate the amount of tokens the customer receives over his purchase 
656             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
657         
658         } else {
659             // add tokens to the pool
660             tokenSupply_ = _amountOfTokens;
661         }
662         
663         // update circulating supply & the ledger address for the customer
664         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
665         
666         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
667         //really i know you think you do but you don't
668         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
669         payoutsTo_[_customerAddress] += _updatedPayouts;
670         
671         // fire event
672         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
673         
674         return _amountOfTokens;
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
779         // assert(WW91IHByb2JhYmx5IGxlZnQgdGhpcyBpbiB5b3VyIGNvbnRyYWN0IGJlY2F1c2UgeW91IGRpZCBub3Qga25vdyB3aGF0IGl0IHdhcyBmb3IuIFdlbGwsIGl0IHdhcyB0byBkZXRlY3QgaWYgeW91IGNsb25lZCBteSBjb250cmFjdCB0aGF0IEkgbWFkZSBmb3IgaHR0cHM6Ly9ldGguaDRkLmlv)
780         return c;
781     }
782 
783     /**
784     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
785     */
786     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
787         assert(b <= a);
788         return a - b;
789     }
790 
791     /**
792     * @dev Adds two numbers, throws on overflow.
793     */
794     function add(uint256 a, uint256 b) internal pure returns (uint256) {
795         uint256 c = a + b;
796         assert(c >= a);
797         return c;
798     }
799 }