1 pragma solidity ^0.4.24;
2 
3 /*
4 *
5 *  /$$      /$$            /$$$$$$ 
6 * | $$  /$ | $$           /$$__  $$
7 * | $$ /$$$| $$  /$$$$$$ | $$  \__/
8 * | $$/$$ $$ $$ /$$__  $$|  $$$$$$ 
9 * | $$$$_  $$$$| $$  \ $$ \____  $$
10 * | $$$/ \  $$$| $$  | $$ /$$  \ $$
11 * | $$/   \  $$|  $$$$$$/|  $$$$$$/
12 * |__/     \__/ \______/  \______/ 
13 * 
14 *  /$$   /$$             /$$                                       /$$      
15 * | $$$ | $$            | $$                                      | $$      
16 * | $$$$| $$  /$$$$$$  /$$$$$$   /$$  /$$  /$$  /$$$$$$   /$$$$$$ | $$   /$$
17 * | $$ $$ $$ /$$__  $$|_  $$_/  | $$ | $$ | $$ /$$__  $$ /$$__  $$| $$  /$$/
18 * | $$  $$$$| $$$$$$$$  | $$    | $$ | $$ | $$| $$  \ $$| $$  \__/| $$$$$$/ 
19 * | $$\  $$$| $$_____/  | $$ /$$| $$ | $$ | $$| $$  | $$| $$      | $$_  $$ 
20 * | $$ \  $$|  $$$$$$$  |  $$$$/|  $$$$$/$$$$/|  $$$$$$/| $$      | $$ \  $$
21 * |__/  \__/ \_______/   \___/   \_____/\___/  \______/ |__/      |__/  \__/
22 * 
23 * 
24 * The Autonomous Exchange:
25 * [x] Fully autonomous and can't be shutdown.
26 * [x] Instant transactions, trade with contract, no need to wait for counterparty.
27 * [x] This is the core of WoSNetwork, WOS holders benefit from all WoSNetwork dividends. Sky is the limit.
28 * [x] Audited, tested, and approved by known community security specialists.
29 * [x] Partner Masternode: Holding 100 SmartToken Tokens allow you to own a Masternode link. Individuals who enter the contract through your Masternode have 30% of their 10% dividends fee rerouted from the master-node, to the node-owner!
30 * 
31 * 
32 */                                                                                                           
33 
34 contract TimePassage {
35     /*=================================
36     =            MODIFIERS            =
37     =================================*/
38     // only people with tokens
39     modifier onlyTokenHolders() {
40         require(myTokens() > 0);
41         _;
42     }
43     
44     // only people with profits
45     modifier onlyProfitHolders() {
46         require(myDividends(true) > 0);
47         _;
48     }
49     
50     // administrators can:
51     // -> change the name of the contract
52     // -> change the name of the token
53     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
54     // they CANNOT:
55     // -> take funds
56     // -> disable withdrawals
57     // -> kill the contract
58     // -> change the price of tokens
59     modifier onlyAdministrator(){
60         address _customerAddress = msg.sender;
61         require(administrators[_customerAddress]);
62         _;
63     }
64     
65     
66     // ensures that the first tokens in the contract will be equally distributed
67     // meaning, no divine dump will be ever possible
68     // result: healthy longevity.
69     modifier antiEarlyWhale(uint256 _amountOfEthereum){
70         address _customerAddress = msg.sender;
71         
72         // are we still in the vulnerable phase?
73         // if so, enact anti early whale protocol 
74         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) < ambassadorQuota_ )){
75             require(
76                 // is the customer in the ambassador list?
77                 ambassadors_[_customerAddress] == true &&
78                 
79                 // does the customer purchase exceed the max ambassador quota?
80                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
81                 
82             );
83             
84             // updated the accumulated quota    
85             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
86         
87             // execute
88             _;
89         } else {
90             onlyAmbassadors = false;
91 
92             if(enableAntiWhale && ((totalEthereumBalance() - _amountOfEthereum) < earlyAdopterQuota_ )){
93                 require((earlyAdopterAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= earlyAdopterMaxPurchase_);
94                 
95                 // updated the accumulated quota
96                 earlyAdopterAccumulatedQuota_[_customerAddress] = SafeMath.add(earlyAdopterAccumulatedQuota_[_customerAddress], _amountOfEthereum);
97 
98                 // execute
99                 _;
100             } else {
101                 enableAntiWhale = false;
102 
103                 // execute
104                 _;
105             }
106         }
107     }
108     
109     
110     /*==============================
111     =            EVENTS            =
112     ==============================*/
113     event onTokenPurchase(
114         address indexed customerAddress,
115         uint256 incomingEthereum,
116         uint256 tokensMinted,
117         address indexed referredBy
118     );
119     
120     event onTokenSell(
121         address indexed customerAddress,
122         uint256 tokensBurned,
123         uint256 ethereumEarned
124     );
125     
126     event onReinvestment(
127         address indexed customerAddress,
128         uint256 ethereumReinvested,
129         uint256 tokensMinted
130     );
131     
132     event onWithdraw(
133         address indexed customerAddress,
134         uint256 ethereumWithdrawn
135     );
136     
137     // ERC20
138     event Transfer(
139         address indexed from,
140         address indexed to,
141         uint256 tokens
142     );
143     
144     
145     /*=====================================
146     =            CONFIGURABLES            =
147     =====================================*/
148     string public name = "WoSNetwork";
149     string public symbol = "WOS";
150     uint8 constant public decimals = 18;
151     uint8 constant internal dividendFee_ = 10;
152     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
153     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
154     uint256 constant internal magnitude = 2**64;
155     uint256 internal treasuryMag_ = 1;
156     mapping(address => uint256) internal treasuryBalanceLedger_;
157     uint256 internal treasurySupply_ = 0;
158 
159     // proof of stake (defaults at 100 WOS)
160     uint256 public stakingRequirement = 100e18;
161     
162     // ambassador program
163     mapping(address => bool) internal ambassadors_;
164     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
165     uint256 constant internal ambassadorQuota_ = 1 ether;
166 
167     // antiwhale program
168     uint256 constant internal earlyAdopterMaxPurchase_ = 1 ether;
169     uint256 constant internal earlyAdopterQuota_ = 25 ether;
170     bool private enableAntiWhale = true;
171 
172 
173     
174    /*================================
175     =            DATASETS            =
176     ================================*/
177     // amount of shares for each address (scaled number)
178     mapping(address => uint256) internal tokenBalanceLedger_;
179     mapping(address => uint256) internal referralBalance_;
180     mapping(address => int256) internal payoutsTo_;
181     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
182     mapping(address => uint256) internal earlyAdopterAccumulatedQuota_;
183     uint256 internal tokenSupply_ = 0;
184     uint256 internal profitPerShare_;
185     
186     // administrator list (see above on what they can do)
187     mapping(address => bool) public administrators;
188     
189     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed system)
190     bool private onlyAmbassadors = true;
191     
192     // treasury
193     TreasuryInterface private Treasury_;
194     bool needsTreasury_ = true;
195 
196 
197     /*=======================================
198     =            PUBLIC FUNCTIONS            =
199     =======================================*/
200     /*
201     * -- APPLICATION ENTRY POINTS --  
202     */
203     constructor()
204         public
205     {
206         // only one admin to start with
207         administrators[msg.sender] = true;
208         ambassadors_[msg.sender] = true;
209     }
210     
211      
212     /**
213      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
214      */
215     function buy(address _referredBy)
216         public
217         payable
218         returns(uint256)
219     {
220         purchaseTokens(msg.value, _referredBy);
221     }
222     
223     /**
224      * Fallback function to handle ethereum that was send straight to the contract
225      * Unfortunately we cannot use a referral address this way.
226      */
227     function()
228         payable
229         public
230     {
231         purchaseTokens(msg.value, 0x0);
232     }
233 
234     /**
235      * Incoming deposits to be shared among all holders
236      */
237     function deposit_dividends()
238         public
239         payable
240     {
241         uint256 _dividends = msg.value;
242         require(_dividends > 0);
243         
244         // dividing by zero is a bad idea
245         if (tokenSupply_ > 0) {
246             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
247             profitPerShare_ += dividendCalculation(_dividends);
248         }
249     }
250     
251     /**
252      * Converts all of caller's dividends to tokens.
253      */
254     function reinvest()
255         onlyProfitHolders()
256         public
257     {
258         // fetch dividends
259         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
260         
261         // pay out the dividends virtually
262         address _customerAddress = msg.sender;
263         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
264         
265         // retrieve ref. bonus
266         _dividends += referralBalance_[_customerAddress];
267         referralBalance_[_customerAddress] = 0;
268         
269         // dispatch a buy order with the virtualized "withdrawn dividends"
270         uint256 _tokens = purchaseTokens(_dividends, 0x0);
271         
272         // fire event
273         emit onReinvestment(_customerAddress, _dividends, _tokens);
274     }
275     
276     /**
277      * Alias of sell() and withdraw().
278      */
279     function exit()
280         public
281     {
282         // get token count for caller & sell them all
283         address _customerAddress = msg.sender;
284         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
285         if(_tokens > 0) sell(_tokens);
286         
287         // lambo delivery service
288         withdraw();
289     }
290 
291     /**
292      * Withdraws all of the callers earnings.
293      */
294     function withdraw()
295         onlyProfitHolders()
296         public
297     {
298         // setup data
299         address _customerAddress = msg.sender;
300         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
301         
302         // update dividend tracker
303         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
304         
305         // add ref. bonus
306         _dividends += referralBalance_[_customerAddress];
307         referralBalance_[_customerAddress] = 0;
308         
309         // lambo delivery service
310         _customerAddress.transfer(_dividends);
311 
312         // fire event
313         emit onWithdraw(_customerAddress, _dividends);
314     }
315     
316     /**
317      * Liquifies tokens to ethereum.
318      */
319     function sell(uint256 _amountOfTokens)
320         onlyTokenHolders()
321         public
322     {
323         // setup data
324         address _customerAddress = msg.sender;
325         // hackers BTFO
326         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
327         uint256 _tokens = _amountOfTokens;
328         uint256 _ethereum = tokensToEthereum_(_tokens);
329         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
330         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
331         
332         // burn the sold tokens
333         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
334         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
335 
336         // update dividends tracker
337         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
338         payoutsTo_[_customerAddress] -= _updatedPayouts;
339 
340         // dividing by zero is a bad idea
341         if (tokenSupply_ > 0) {
342             // update the amount of dividends per token
343             profitPerShare_ = SafeMath.add(profitPerShare_, dividendCalculation(_dividends));
344         }
345 
346         untrackTreasuryToken(_amountOfTokens);
347         
348         // fire event
349         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
350     }
351     
352     
353     /**
354      * Transfer tokens from the caller to a new holder.
355      * Remember, there's a 10% fee here as well.
356      */
357     function transfer(address _toAddress, uint256 _amountOfTokens)
358         onlyTokenHolders()
359         public
360         returns(bool)
361     {
362         // setup
363         address _customerAddress = msg.sender;
364         
365         // make sure we have the requested tokens
366         // also disables transfers until ambassador phase is over
367         // ( we dont want whale premines )
368         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
369         
370         // withdraw all outstanding dividends first
371         if(myDividends(true) > 0) withdraw();
372         
373         // liquify 10% of the tokens that are transfered
374         // these are dispersed to shareholders
375         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
376         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
377         uint256 _dividends = tokensToEthereum_(_tokenFee);
378 
379         // burn the fee tokens
380         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
381 
382         // exchange tokens
383         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
384         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
385         
386         // update dividend trackers
387         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
388         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
389         
390         // disperse dividends among holders
391         profitPerShare_ = SafeMath.add(profitPerShare_, dividendCalculation(_dividends));
392         
393         // fire event
394         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
395         
396         // ERC20
397         return true;
398        
399     }
400     
401     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
402     /**
403      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
404      */
405     function disableInitialAmbassadorStage()
406         onlyAdministrator()
407         public
408     {
409         onlyAmbassadors = false;
410     }
411     function disableInitialStage()
412         onlyAdministrator()
413         public
414     {
415         onlyAmbassadors = false;
416         enableAntiWhale = false;
417     }
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
459     /**
460      * Clean up what's left in the contract when 
461      * tokenSupply_ is 0
462      */
463     function cleanUpRounding()
464         onlyAdministrator()
465         public
466     {
467         require(tokenSupply_ == 0);
468         
469         address _adminAddress;
470         _adminAddress = msg.sender;
471         _adminAddress.transfer(address(this).balance);
472     }
473     
474     /*----------  HELPERS AND CALCULATORS  ----------*/
475     /**
476      * Method to view the current Ethereum stored in the contract
477      * Example: totalEthereumBalance()
478      */
479     function totalEthereumBalance()
480         public
481         view
482         returns(uint)
483     {
484         return address(this).balance;
485     }
486     
487     /**
488      * Retrieve the total token supply.
489      */
490     function totalSupply()
491         public
492         view
493         returns(uint256)
494     {
495         return tokenSupply_;
496     }
497     
498     /**
499      * Retrieve the tokens owned by the caller.
500      */
501     function myTokens()
502         public
503         view
504         returns(uint256)
505     {
506         address _customerAddress = msg.sender;
507         return balanceOf(_customerAddress);
508     }
509     
510     /**
511      * Retrieve the dividends owned by the caller.
512      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
513      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
514      * But in the internal calculations, we want them separate. 
515      */ 
516     function myDividends(bool _includeReferralBonus) 
517         public 
518         view 
519         returns(uint256)
520     {
521         address _customerAddress = msg.sender;
522         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
523     }
524     
525     /**
526      * Retrieve the token balance of any single address.
527      */
528     function balanceOf(address _customerAddress)
529         view
530         public
531         returns(uint256)
532     {
533         return tokenBalanceLedger_[_customerAddress];
534     }
535     
536     /**
537      * Retrieve the dividend balance of any single address.
538      */
539     function dividendsOf(address _customerAddress)
540         view
541         public
542         returns(uint256)
543     {
544         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
545     }
546     
547     /**
548      * Return the sell price of 1 individual token.
549      */
550     function sellPrice() 
551         public 
552         view 
553         returns(uint256)
554     {
555         // our calculation relies on the token supply, so we need supply.
556         if(tokenSupply_ == 0){
557             return tokenPriceInitial_ - tokenPriceIncremental_;
558         } else {
559             uint256 _ethereum = tokensToEthereum_(1e18);
560             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
561             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
562             return _taxedEthereum;
563         }
564     }
565     
566     /**
567      * Return the buy price of 1 individual token.
568      */
569     function buyPrice() 
570         public 
571         view 
572         returns(uint256)
573     {
574         // our calculation relies on the token supply, so we need supply.
575         if(tokenSupply_ == 0){
576             return tokenPriceInitial_ + tokenPriceIncremental_;
577         } else {
578             uint256 _ethereum = tokensToEthereum_(1e18);
579             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
580             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
581             return _taxedEthereum;
582         }
583     }
584     
585     /**
586      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
587      */
588     function calculateTokensReceived(uint256 _ethereumToSpend) 
589         public 
590         view 
591         returns(uint256)
592     {
593         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
594         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
595         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
596         
597         return _amountOfTokens;
598     }
599     
600     /**
601      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
602      */
603     function calculateEthereumReceived(uint256 _tokensToSell) 
604         public 
605         view 
606         returns(uint256)
607     {
608         require(_tokensToSell <= tokenSupply_);
609         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
610         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
611         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
612         return _taxedEthereum;
613     }
614 
615     function setup(address _treasuryAddr)
616         external
617     {
618         require(needsTreasury_ == true, "Treasury setup failed - treasury already registered");
619         Treasury_ = TreasuryInterface(_treasuryAddr);
620         needsTreasury_ = false;
621     }
622     
623     /*==========================================
624     =            INTERNAL FUNCTIONS            =
625     ==========================================*/
626     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
627         antiEarlyWhale(_incomingEthereum)
628         internal
629         returns(uint256)
630     {
631         // data setup
632         address _customerAddress = msg.sender;
633         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
634         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
635         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
636         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
637         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
638         uint256 _fee = _dividends * magnitude;
639  
640         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
641         // (or hackers)
642         // and yes we know that the safemath function automatically rules out the "greater then" equation.
643         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
644         
645         // is the user referred by a masternode?
646         if(
647             // is this a referred purchase?
648             _referredBy != 0x0000000000000000000000000000000000000000 &&
649 
650             // no cheating!
651             _referredBy != _customerAddress &&
652             
653             // does the referrer have at least X whole tokens?
654             // i.e is the referrer a godly chad masternode
655             tokenBalanceLedger_[_referredBy] >= stakingRequirement
656         ){
657             // wealth redistribution
658             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
659         } else {
660             // no ref purchase
661             // add the referral bonus back to the global dividends cake
662             _dividends = SafeMath.add(_dividends, _referralBonus);
663             _fee = _dividends * magnitude;
664         }
665 
666         trackTreasuryToken(_amountOfTokens);
667         
668         // we can't give people infinite ethereum
669         if(tokenSupply_ > 0){            
670             
671             // add tokens to the pool
672             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
673  
674             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
675             profitPerShare_ += dividendCalculation(_dividends);
676             
677             // calculate the amount of tokens the customer receives over his purchase 
678             _fee = _fee - (_fee-(_amountOfTokens *  dividendCalculation(_dividends)));
679         
680         } else {
681             // add tokens to the pool
682             tokenSupply_ = _amountOfTokens;
683         }
684         
685         // update circulating supply & the ledger address for the customer
686         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
687         
688         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
689         // really i know you think you do but you don't
690         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
691         payoutsTo_[_customerAddress] += _updatedPayouts;
692         
693         // fire event
694         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
695         
696         return _amountOfTokens;
697     }
698 
699     // calculate dividends
700     function dividendCalculation(uint256 _dividends) 
701         internal
702         view
703         returns(uint256)
704     {
705         return (_dividends * magnitude / (tokenSupply_ + treasurySupply_));
706     }
707 
708     /**
709      * Calculate Token price based on an amount of incoming ethereum
710      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
711      */
712     function ethereumToTokens_(uint256 _ethereum)
713         internal
714         view
715         returns(uint256)
716     {
717         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
718         uint256 _tokensReceived = 
719          (
720             (
721                 // underflow attempts BTFO
722                 SafeMath.sub(
723                     (sqrt
724                         (
725                             (_tokenPriceInitial**2)
726                             +
727                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
728                             +
729                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
730                             +
731                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
732                         )
733                     ), _tokenPriceInitial
734                 )
735             )/(tokenPriceIncremental_)
736         )-(tokenSupply_)
737         ;
738   
739         return _tokensReceived;
740     }
741     
742     /**
743      * Calculate token sell value.
744      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
745      */
746     function tokensToEthereum_(uint256 _tokens)
747         internal
748         view
749         returns(uint256)
750     {
751 
752         uint256 tokens_ = (_tokens + 1e18);
753         uint256 _tokenSupply = (tokenSupply_ + 1e18);
754         uint256 _etherReceived =
755         (
756             // underflow attempts BTFO
757             SafeMath.sub(
758                 (
759                     (
760                         (
761                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
762                         )-tokenPriceIncremental_
763                     )*(tokens_ - 1e18)
764                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
765             )
766         /1e18);
767         return _etherReceived;
768     }
769     
770     //track treasury/contract tokens
771     function trackTreasuryToken(uint256 _amountOfTokens)
772         internal
773     {
774         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
775 
776         address _treasuryAddress = address(Treasury_);
777         _amountOfTokens = SafeMath.div(_amountOfTokens, treasuryMag_);
778 
779 
780         // record as treasury token
781         treasurySupply_ += _amountOfTokens;
782         treasuryBalanceLedger_[_treasuryAddress] = SafeMath.add(treasuryBalanceLedger_[_treasuryAddress], _amountOfTokens);
783 
784         // tells the contract that treasury doesn't deserve dividends;
785         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens);
786         payoutsTo_[_treasuryAddress] += _updatedPayouts;
787     }
788 
789     function untrackTreasuryToken(uint256 _amountOfTokens)
790         internal
791     {
792         address _treasuryAddress = address(Treasury_);
793 
794         require(_amountOfTokens > 0 && _amountOfTokens <= treasuryBalanceLedger_[_treasuryAddress]);
795 
796         _amountOfTokens = SafeMath.div(_amountOfTokens, treasuryMag_);
797         
798         treasurySupply_ = SafeMath.sub(treasurySupply_, _amountOfTokens);
799         treasuryBalanceLedger_[_treasuryAddress] = SafeMath.sub(treasuryBalanceLedger_[_treasuryAddress], _amountOfTokens);
800 
801         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens);
802         payoutsTo_[_treasuryAddress] -= _updatedPayouts;
803     }
804     
805     //Math..
806     function sqrt(uint x) internal pure returns (uint y) {
807         uint z = (x + 1) / 2;
808         y = x;
809         while (z < y) {
810             y = z;
811             z = (x / z + z) / 2;
812         }
813     }
814 
815     function lockInTreasury()
816         public
817     {
818         // setup data
819         address _treasuryAddress = address(Treasury_);
820         uint256 _dividends = (uint256) ((int256)(profitPerShare_ * treasuryBalanceLedger_[_treasuryAddress]) - payoutsTo_[_treasuryAddress]) / magnitude;
821         payoutsTo_[_treasuryAddress] +=  (int256) (_dividends * magnitude);
822         
823         _dividends += referralBalance_[_treasuryAddress];
824         referralBalance_[_treasuryAddress] = 0;
825 
826         require(_treasuryAddress != 0x0000000000000000000000000000000000000000);
827         require(_dividends != 0);
828 
829         Treasury_.deposit.value(_dividends)();
830     }
831 }
832 
833 /**
834  * @title SafeMath
835  * @dev Math operations with safety checks that throw on error
836  */
837 library SafeMath {
838 
839     /**
840     * @dev Multiplies two numbers, throws on overflow.
841     */
842     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
843         if (a == 0) {
844             return 0;
845         }
846         uint256 c = a * b;
847         assert(c / a == b);
848         return c;
849     }
850 
851     /**
852     * @dev Integer division of two numbers, truncating the quotient.
853     */
854     function div(uint256 a, uint256 b) internal pure returns (uint256) {
855         // assert(b > 0); // Solidity automatically throws when dividing by 0
856         uint256 c = a / b;
857         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
858         return c;
859     }
860 
861     /**
862     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
863     */
864     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
865         assert(b <= a);
866         return a - b;
867     }
868 
869     /**
870     * @dev Adds two numbers, throws on overflow.
871     */
872     function add(uint256 a, uint256 b) internal pure returns (uint256) {
873         uint256 c = a + b;
874         assert(c >= a);
875         return c;
876     }
877 }
878 
879 interface TreasuryInterface {
880     function deposit() external payable returns(bool);
881     function status() external view returns(address, address, bool);
882     function startMigration(address _newBank) external returns(bool);
883     function cancelMigration() external returns(bool);
884     function finishMigration() external returns(bool);
885     function setup(address _firstBank) external;
886 }