1 pragma solidity ^0.4.24;
2 
3 /*
4 *
5 *  _______                                        __     
6 * |_   __ \                                      |  ]    
7 *   | |__) |  .---.  .---.   .--.   _ .--.   .--.| |     
8 *   |  __ /  / /__\\/ /'`\]/ .'`\ \[ `/'`\]/ /'`\' |     
9 *  _| |  \ \_| \__.,| \__. | \__. | | |    | \__/  |     
10 * |____|_|___|'.__.''.___.' '.__.'_[___]    '.__.;__]    
11 * |_   _ \                       [  |  _                 
12 *   | |_) | _ .--.  .---.  ,--.   | | / ] .---.  _ .--.  
13 *   |  __'.[ `/'`\]/ /__\\`'_\ :  | '' < / /__\\[ `/'`\] 
14 *  _| |__) || |    | \__.,// | |, | |`\ \| \__., | |     
15 * |_______/[___]    '.__.'\'-;__/[__|  \_]'.__.'[___]    
16 *                                                       
17 * 
18 * 
19 * One Strategy - Pure Marketing:
20 * [x] Fully autonomous and can't be shutdown.
21 * [x] Instant transactions, trade with contract, no need to wait for counterparty.
22 * [x] Audited, tested, and approved by known community security specialists.
23 * [x] Partner Masternode: Holding 100 SmartToken Tokens allow you to own a Masternode link. Individuals 
24 *     who enter the contract through your Masternode have 30% of their 10% dividends fee rerouted from the master-node, 
25 *     to the node-owner!
26 * 
27 */                                                                                                           
28 
29 contract RecordBreaker {
30     /*=================================
31     =            MODIFIERS            =
32     =================================*/
33     // only people with tokens
34     modifier onlyTokenHolders() {
35         require(myTokens() > 0);
36         _;
37     }
38     
39     // only people with profits
40     modifier onlyProfitHolders() {
41         require(myDividends(true) > 0);
42         _;
43     }
44     
45     // administrators can:
46     // -> change the name of the contract
47     // -> change the name of the token
48     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
49     // they CANNOT:
50     // -> take funds
51     // -> disable withdrawals
52     // -> kill the contract
53     // -> change the price of tokens
54     modifier onlyAdministrator(){
55         address _customerAddress = msg.sender;
56         require(administrators[_customerAddress]);
57         _;
58     }
59     
60     
61     // ensures that the first tokens in the contract will be equally distributed
62     // meaning, no divine dump will be ever possible
63     // result: healthy longevity.
64     modifier antiEarlyWhale(uint256 _amountOfEthereum){
65         address _customerAddress = msg.sender;
66         
67         // are we still in the vulnerable phase?
68         // if so, enact anti early whale protocol 
69         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) < ambassadorQuota_ )){
70             require(
71                 // is the customer in the ambassador list?
72                 ambassadors_[_customerAddress] == true &&
73                 
74                 // does the customer purchase exceed the max ambassador quota?
75                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
76                 
77             );
78             
79             // updated the accumulated quota    
80             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
81         
82             // execute
83             _;
84         } else {
85             onlyAmbassadors = false;
86 
87             if(enableAntiWhale && ((totalEthereumBalance() - _amountOfEthereum) < earlyAdopterQuota_ )){
88                 require((earlyAdopterAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= earlyAdopterMaxPurchase_);
89                 
90                 // updated the accumulated quota
91                 earlyAdopterAccumulatedQuota_[_customerAddress] = SafeMath.add(earlyAdopterAccumulatedQuota_[_customerAddress], _amountOfEthereum);
92 
93                 // execute
94                 _;
95             } else {
96                 enableAntiWhale = false;
97 
98                 // execute
99                 _;
100             }
101         }
102     }
103     
104     
105     /*==============================
106     =            EVENTS            =
107     ==============================*/
108     event onTokenPurchase(
109         address indexed customerAddress,
110         uint256 incomingEthereum,
111         uint256 tokensMinted,
112         address indexed referredBy
113     );
114     
115     event onTokenSell(
116         address indexed customerAddress,
117         uint256 tokensBurned,
118         uint256 ethereumEarned
119     );
120     
121     event onReinvestment(
122         address indexed customerAddress,
123         uint256 ethereumReinvested,
124         uint256 tokensMinted
125     );
126     
127     event onWithdraw(
128         address indexed customerAddress,
129         uint256 ethereumWithdrawn
130     );
131     
132     // ERC20
133     event Transfer(
134         address indexed from,
135         address indexed to,
136         uint256 tokens
137     );
138     
139     
140     /*=====================================
141     =            CONFIGURABLES            =
142     =====================================*/
143     string public name = "WoSNetwork";
144     string public symbol = "WOS";
145     uint8 constant public decimals = 18;
146     uint8 constant internal dividendFee_ = 20;
147     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
148     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
149     uint256 constant internal magnitude = 2**64;
150     uint256 internal treasuryMag_ = 1;
151     mapping(address => uint256) internal treasuryBalanceLedger_;
152     uint256 internal treasurySupply_ = 0;
153 
154     // proof of stake (defaults at 100 WOS)
155     uint256 public stakingRequirement = 100e18;
156     
157     // ambassador program
158     mapping(address => bool) internal ambassadors_;
159     uint256 constant internal ambassadorMaxPurchase_ = 2 ether;
160     uint256 constant internal ambassadorQuota_ = 2 ether;
161 
162     // antiwhale program
163     uint256 constant internal earlyAdopterMaxPurchase_ = 2 ether;
164     uint256 constant internal earlyAdopterQuota_ = 10 ether;
165     bool private enableAntiWhale = true;
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
177     mapping(address => uint256) internal earlyAdopterAccumulatedQuota_;
178     uint256 internal tokenSupply_ = 0;
179     uint256 internal profitPerShare_;
180     
181     // administrator list (see above on what they can do)
182     mapping(address => bool) public administrators;
183     
184     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed system)
185     bool private onlyAmbassadors = true;
186     
187     // treasury
188     TreasuryInterface private Treasury_;
189     bool needsTreasury_ = true;
190 
191 
192     /*=======================================
193     =            PUBLIC FUNCTIONS            =
194     =======================================*/
195     /*
196     * -- APPLICATION ENTRY POINTS --  
197     */
198     constructor()
199         public
200     {
201         // only one admin to start with
202         administrators[msg.sender] = true;
203         ambassadors_[msg.sender] = true;
204     }
205     
206      
207     /**
208      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
209      */
210     function buy(address _referredBy)
211         public
212         payable
213         returns(uint256)
214     {
215         purchaseTokens(msg.value, _referredBy);
216     }
217     
218     /**
219      * Fallback function to handle ethereum that was send straight to the contract
220      * Unfortunately we cannot use a referral address this way.
221      */
222     function()
223         payable
224         public
225     {
226         purchaseTokens(msg.value, 0x0);
227     }
228 
229     /**
230      * Incoming deposits to be shared among all holders
231      */
232     function deposit_dividends()
233         public
234         payable
235     {
236         uint256 _dividends = msg.value;
237         require(_dividends > 0);
238         
239         // dividing by zero is a bad idea
240         if (tokenSupply_ > 0) {
241             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
242             profitPerShare_ += dividendCalculation(_dividends);
243         }
244     }
245     
246     /**
247      * Converts all of caller's dividends to tokens.
248      */
249     function reinvest()
250         onlyProfitHolders()
251         public
252     {
253         // fetch dividends
254         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
255         
256         // pay out the dividends virtually
257         address _customerAddress = msg.sender;
258         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
259         
260         // retrieve ref. bonus
261         _dividends += referralBalance_[_customerAddress];
262         referralBalance_[_customerAddress] = 0;
263         
264         // dispatch a buy order with the virtualized "withdrawn dividends"
265         uint256 _tokens = purchaseTokens(_dividends, 0x0);
266         
267         // fire event
268         emit onReinvestment(_customerAddress, _dividends, _tokens);
269     }
270     
271     /**
272      * Alias of sell() and withdraw().
273      */
274     function exit()
275         public
276     {
277         // get token count for caller & sell them all
278         address _customerAddress = msg.sender;
279         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
280         if(_tokens > 0) sell(_tokens);
281         
282         // lambo delivery service
283         withdraw();
284     }
285 
286     /**
287      * Withdraws all of the callers earnings.
288      */
289     function withdraw()
290         onlyProfitHolders()
291         public
292     {
293         // setup data
294         address _customerAddress = msg.sender;
295         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
296         
297         // update dividend tracker
298         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
299         
300         // add ref. bonus
301         _dividends += referralBalance_[_customerAddress];
302         referralBalance_[_customerAddress] = 0;
303         
304         // lambo delivery service
305         _customerAddress.transfer(_dividends);
306 
307         // fire event
308         emit onWithdraw(_customerAddress, _dividends);
309     }
310     
311     /**
312      * Liquifies tokens to ethereum.
313      */
314     function sell(uint256 _amountOfTokens)
315         onlyTokenHolders()
316         public
317     {
318         // setup data
319         address _customerAddress = msg.sender;
320         // hackers BTFO
321         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
322         uint256 _tokens = _amountOfTokens;
323         uint256 _ethereum = tokensToEthereum_(_tokens);
324         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
325         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
326         
327         // burn the sold tokens
328         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
329         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
330 
331         // update dividends tracker
332         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
333         payoutsTo_[_customerAddress] -= _updatedPayouts;
334 
335         // dividing by zero is a bad idea
336         if (tokenSupply_ > 0) {
337             // update the amount of dividends per token
338             profitPerShare_ = SafeMath.add(profitPerShare_, dividendCalculation(_dividends));
339         }
340 
341         untrackTreasuryToken(_amountOfTokens);
342         
343         // fire event
344         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
345     }
346     
347     
348     /**
349      * Transfer tokens from the caller to a new holder.
350      * Remember, there's a 10% fee here as well.
351      */
352     function transfer(address _toAddress, uint256 _amountOfTokens)
353         onlyTokenHolders()
354         public
355         returns(bool)
356     {
357         // setup
358         address _customerAddress = msg.sender;
359         
360         // make sure we have the requested tokens
361         // also disables transfers until ambassador phase is over
362         // ( we dont want whale premines )
363         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
364         
365         // withdraw all outstanding dividends first
366         if(myDividends(true) > 0) withdraw();
367         
368         // liquify 10% of the tokens that are transfered
369         // these are dispersed to shareholders
370         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
371         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
372         uint256 _dividends = tokensToEthereum_(_tokenFee);
373 
374         // burn the fee tokens
375         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
376 
377         // exchange tokens
378         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
379         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
380         
381         // update dividend trackers
382         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
383         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
384         
385         // disperse dividends among holders
386         profitPerShare_ = SafeMath.add(profitPerShare_, dividendCalculation(_dividends));
387         
388         // fire event
389         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
390         
391         // ERC20
392         return true;
393        
394     }
395     
396     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
397     /**
398      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
399      */
400     function disableInitialAmbassadorStage()
401         onlyAdministrator()
402         public
403     {
404         onlyAmbassadors = false;
405     }
406     function disableInitialStage()
407         onlyAdministrator()
408         public
409     {
410         onlyAmbassadors = false;
411         enableAntiWhale = false;
412     }
413 
414     /**
415      * In case one of us dies, we need to replace ourselves.
416      */
417     function setAdministrator(address _identifier, bool _status)
418         onlyAdministrator()
419         public
420     {
421         administrators[_identifier] = _status;
422     }
423     
424     /**
425      * Precautionary measures in case we need to adjust the masternode rate.
426      */
427     function setStakingRequirement(uint256 _amountOfTokens)
428         onlyAdministrator()
429         public
430     {
431         stakingRequirement = _amountOfTokens;
432     }
433 
434     /**
435      * If we want to rebrand, we can.
436      */
437     function setName(string _name)
438         onlyAdministrator()
439         public
440     {
441         name = _name;
442     }
443     
444     /**
445      * If we want to rebrand, we can.
446      */
447     function setSymbol(string _symbol)
448         onlyAdministrator()
449         public
450     {
451         symbol = _symbol;
452     }
453 
454     /**
455      * Clean up what's left in the contract when 
456      * tokenSupply_ is 0
457      */
458     function cleanUpRounding()
459         onlyAdministrator()
460         public
461     {
462         require(tokenSupply_ == 0);
463         
464         address _adminAddress;
465         _adminAddress = msg.sender;
466         _adminAddress.transfer(address(this).balance);
467     }
468     
469     /*----------  HELPERS AND CALCULATORS  ----------*/
470     /**
471      * Method to view the current Ethereum stored in the contract
472      * Example: totalEthereumBalance()
473      */
474     function totalEthereumBalance()
475         public
476         view
477         returns(uint)
478     {
479         return address(this).balance;
480     }
481     
482     /**
483      * Retrieve the total token supply.
484      */
485     function totalSupply()
486         public
487         view
488         returns(uint256)
489     {
490         return tokenSupply_;
491     }
492     
493     /**
494      * Retrieve the tokens owned by the caller.
495      */
496     function myTokens()
497         public
498         view
499         returns(uint256)
500     {
501         address _customerAddress = msg.sender;
502         return balanceOf(_customerAddress);
503     }
504     
505     /**
506      * Retrieve the dividends owned by the caller.
507      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
508      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
509      * But in the internal calculations, we want them separate. 
510      */ 
511     function myDividends(bool _includeReferralBonus) 
512         public 
513         view 
514         returns(uint256)
515     {
516         address _customerAddress = msg.sender;
517         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
518     }
519     
520     /**
521      * Retrieve the token balance of any single address.
522      */
523     function balanceOf(address _customerAddress)
524         view
525         public
526         returns(uint256)
527     {
528         return tokenBalanceLedger_[_customerAddress];
529     }
530     
531     /**
532      * Retrieve the dividend balance of any single address.
533      */
534     function dividendsOf(address _customerAddress)
535         view
536         public
537         returns(uint256)
538     {
539         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
540     }
541     
542     /**
543      * Return the sell price of 1 individual token.
544      */
545     function sellPrice() 
546         public 
547         view 
548         returns(uint256)
549     {
550         // our calculation relies on the token supply, so we need supply.
551         if(tokenSupply_ == 0){
552             return tokenPriceInitial_ - tokenPriceIncremental_;
553         } else {
554             uint256 _ethereum = tokensToEthereum_(1e18);
555             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
556             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
557             return _taxedEthereum;
558         }
559     }
560     
561     /**
562      * Return the buy price of 1 individual token.
563      */
564     function buyPrice() 
565         public 
566         view 
567         returns(uint256)
568     {
569         // our calculation relies on the token supply, so we need supply.
570         if(tokenSupply_ == 0){
571             return tokenPriceInitial_ + tokenPriceIncremental_;
572         } else {
573             uint256 _ethereum = tokensToEthereum_(1e18);
574             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
575             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
576             return _taxedEthereum;
577         }
578     }
579     
580     /**
581      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
582      */
583     function calculateTokensReceived(uint256 _ethereumToSpend) 
584         public 
585         view 
586         returns(uint256)
587     {
588         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
589         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
590         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
591         
592         return _amountOfTokens;
593     }
594     
595     /**
596      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
597      */
598     function calculateEthereumReceived(uint256 _tokensToSell) 
599         public 
600         view 
601         returns(uint256)
602     {
603         require(_tokensToSell <= tokenSupply_);
604         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
605         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
606         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
607         return _taxedEthereum;
608     }
609 
610     function setup(address _treasuryAddr)
611         external
612     {
613         require(needsTreasury_ == true, "Treasury setup failed - treasury already registered");
614         Treasury_ = TreasuryInterface(_treasuryAddr);
615         needsTreasury_ = false;
616     }
617     
618     /*==========================================
619     =            INTERNAL FUNCTIONS            =
620     ==========================================*/
621     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
622         antiEarlyWhale(_incomingEthereum)
623         internal
624         returns(uint256)
625     {
626         // data setup
627         address _customerAddress = msg.sender;
628         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
629         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
630         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
631         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
632         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
633         uint256 _fee = _dividends * magnitude;
634  
635         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
636         // (or hackers)
637         // and yes we know that the safemath function automatically rules out the "greater then" equation.
638         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
639         
640         // is the user referred by a masternode?
641         if(
642             // is this a referred purchase?
643             _referredBy != 0x0000000000000000000000000000000000000000 &&
644 
645             // no cheating!
646             _referredBy != _customerAddress &&
647             
648             // does the referrer have at least X whole tokens?
649             // i.e is the referrer a godly chad masternode
650             tokenBalanceLedger_[_referredBy] >= stakingRequirement
651         ){
652             // wealth redistribution
653             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
654         } else {
655             // no ref purchase
656             // add the referral bonus back to the global dividends cake
657             _dividends = SafeMath.add(_dividends, _referralBonus);
658             _fee = _dividends * magnitude;
659         }
660 
661         trackTreasuryToken(_amountOfTokens);
662         
663         // we can't give people infinite ethereum
664         if(tokenSupply_ > 0){            
665             
666             // add tokens to the pool
667             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
668  
669             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
670             profitPerShare_ += dividendCalculation(_dividends);
671             
672             // calculate the amount of tokens the customer receives over his purchase 
673             _fee = _fee - (_fee-(_amountOfTokens *  dividendCalculation(_dividends)));
674         
675         } else {
676             // add tokens to the pool
677             tokenSupply_ = _amountOfTokens;
678         }
679         
680         // update circulating supply & the ledger address for the customer
681         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
682         
683         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
684         // really i know you think you do but you don't
685         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
686         payoutsTo_[_customerAddress] += _updatedPayouts;
687         
688         // fire event
689         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
690         
691         return _amountOfTokens;
692     }
693 
694     // calculate dividends
695     function dividendCalculation(uint256 _dividends) 
696         internal
697         view
698         returns(uint256)
699     {
700         return (_dividends * magnitude / (tokenSupply_ + treasurySupply_));
701     }
702 
703     /**
704      * Calculate Token price based on an amount of incoming ethereum
705      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
706      */
707     function ethereumToTokens_(uint256 _ethereum)
708         internal
709         view
710         returns(uint256)
711     {
712         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
713         uint256 _tokensReceived = 
714          (
715             (
716                 // underflow attempts BTFO
717                 SafeMath.sub(
718                     (sqrt
719                         (
720                             (_tokenPriceInitial**2)
721                             +
722                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
723                             +
724                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
725                             +
726                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
727                         )
728                     ), _tokenPriceInitial
729                 )
730             )/(tokenPriceIncremental_)
731         )-(tokenSupply_)
732         ;
733   
734         return _tokensReceived;
735     }
736     
737     /**
738      * Calculate token sell value.
739      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
740      */
741     function tokensToEthereum_(uint256 _tokens)
742         internal
743         view
744         returns(uint256)
745     {
746 
747         uint256 tokens_ = (_tokens + 1e18);
748         uint256 _tokenSupply = (tokenSupply_ + 1e18);
749         uint256 _etherReceived =
750         (
751             // underflow attempts BTFO
752             SafeMath.sub(
753                 (
754                     (
755                         (
756                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
757                         )-tokenPriceIncremental_
758                     )*(tokens_ - 1e18)
759                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
760             )
761         /1e18);
762         return _etherReceived;
763     }
764     
765     //track treasury/contract tokens
766     function trackTreasuryToken(uint256 _amountOfTokens)
767         internal
768     {
769         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
770 
771         address _treasuryAddress = address(Treasury_);
772         _amountOfTokens = SafeMath.div(_amountOfTokens, treasuryMag_);
773 
774 
775         // record as treasury token
776         treasurySupply_ += _amountOfTokens;
777         treasuryBalanceLedger_[_treasuryAddress] = SafeMath.add(treasuryBalanceLedger_[_treasuryAddress], _amountOfTokens);
778 
779         // tells the contract that treasury doesn't deserve dividends;
780         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens);
781         payoutsTo_[_treasuryAddress] += _updatedPayouts;
782     }
783 
784     function untrackTreasuryToken(uint256 _amountOfTokens)
785         internal
786     {
787         address _treasuryAddress = address(Treasury_);
788 
789         require(_amountOfTokens > 0 && _amountOfTokens <= treasuryBalanceLedger_[_treasuryAddress]);
790 
791         _amountOfTokens = SafeMath.div(_amountOfTokens, treasuryMag_);
792         
793         treasurySupply_ = SafeMath.sub(treasurySupply_, _amountOfTokens);
794         treasuryBalanceLedger_[_treasuryAddress] = SafeMath.sub(treasuryBalanceLedger_[_treasuryAddress], _amountOfTokens);
795 
796         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens);
797         payoutsTo_[_treasuryAddress] -= _updatedPayouts;
798     }
799     
800     //Math..
801     function sqrt(uint x) internal pure returns (uint y) {
802         uint z = (x + 1) / 2;
803         y = x;
804         while (z < y) {
805             y = z;
806             z = (x / z + z) / 2;
807         }
808     }
809 
810     function lockInTreasury()
811         public
812     {
813         // setup data
814         address _treasuryAddress = address(Treasury_);
815         uint256 _dividends = (uint256) ((int256)(profitPerShare_ * treasuryBalanceLedger_[_treasuryAddress]) - payoutsTo_[_treasuryAddress]) / magnitude;
816         payoutsTo_[_treasuryAddress] +=  (int256) (_dividends * magnitude);
817         
818         _dividends += referralBalance_[_treasuryAddress];
819         referralBalance_[_treasuryAddress] = 0;
820 
821         require(_treasuryAddress != 0x0000000000000000000000000000000000000000);
822         require(_dividends != 0);
823 
824         Treasury_.deposit.value(_dividends)();
825     }
826 }
827 
828 /**
829  * @title SafeMath
830  * @dev Math operations with safety checks that throw on error
831  */
832 library SafeMath {
833 
834     /**
835     * @dev Multiplies two numbers, throws on overflow.
836     */
837     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
838         if (a == 0) {
839             return 0;
840         }
841         uint256 c = a * b;
842         assert(c / a == b);
843         return c;
844     }
845 
846     /**
847     * @dev Integer division of two numbers, truncating the quotient.
848     */
849     function div(uint256 a, uint256 b) internal pure returns (uint256) {
850         // assert(b > 0); // Solidity automatically throws when dividing by 0
851         uint256 c = a / b;
852         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
853         return c;
854     }
855 
856     /**
857     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
858     */
859     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
860         assert(b <= a);
861         return a - b;
862     }
863 
864     /**
865     * @dev Adds two numbers, throws on overflow.
866     */
867     function add(uint256 a, uint256 b) internal pure returns (uint256) {
868         uint256 c = a + b;
869         assert(c >= a);
870         return c;
871     }
872 }
873 
874 interface TreasuryInterface {
875     function deposit() external payable returns(bool);
876     function status() external view returns(address, address, bool);
877     function startMigration(address _newBank) external returns(bool);
878     function cancelMigration() external returns(bool);
879     function finishMigration() external returns(bool);
880     function setup(address _firstBank) external;
881 }