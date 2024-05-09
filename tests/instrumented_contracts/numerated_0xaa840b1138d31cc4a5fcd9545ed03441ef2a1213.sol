1 pragma solidity ^0.4.20;
2 
3 /*
4 
5 
6 ==================================================
7 =                                                =
8 =        Website: http://DIVIUMx2.io             =
9 = Discord: https://discordapp.com/invite/pqcjXSC =
10 =                                                =
11 ==================================================
12 
13 
14 8888888b.  8888888 888     888 8888888 888     888 888b     d888           .d8888b.      d8b          
15 888  "Y88b   888   888     888   888   888     888 8888b   d8888          d88P  Y88b     Y8P          
16 888    888   888   888     888   888   888     888 88888b.d88888                 888                  
17 888    888   888   Y88b   d88P   888   888     888 888Y88888P888 888  888      .d88P     888  .d88b.  
18 888    888   888    Y88b d88P    888   888     888 888 Y888P 888 `Y8bd8P'  .od888P"      888 d88""88b 
19 888    888   888     Y88o88P     888   888     888 888  Y8P  888   X88K   d88P"          888 888  888 
20 888  .d88P   888      Y888P      888   Y88b. .d88P 888   "   888 .d8""8b. 888"       d8b 888 Y88..88P 
21 8888888P"  8888888     Y8P     8888888  "Y88888P"  888       888 888  888 888888888  Y8P 888  "Y88P"  
22 
23 
24 Divium, but with x2 more dividends  and...
25 
26 3 COOL FEATURES:
27 
28 1. MASTERNODE FOR REINVESTS TOO
29 Earn Masternode commissions not only for DIVIUMx2 purchases under you. But also for reinvests. Imagine if your users reinvests everytime & you get commissions all day long. It works as long as your masternode saved in users browser
30 
31 2. SLOWDUMP OR SLEEPWELL FEATURE
32 This will allow you to sleepwell at night. DIVIUMx2 allows to sell only 100 tokens at a time. But, can sell any number of times. This will avoid situations like wiping out 7000ETH in 2 hours while you sleep. 100 tokens limit can be changed upon community polling (cannot be changed below 10 tokens protected by source code).
33 
34 3. ZERO TOKENS REQUIREMENT FOR MASTERNODE
35 Are you broke? Don't worry. You don't have to purchase tokens to promote your masternode. Masternode requirement is currently set to 0 tokens. It can be changed based on community polling. (don't want to change though)
36 
37 */
38 
39 contract DIVIUMx2 {
40 
41 //=================================
42 //=           MODIFIERS           =
43 //=================================
44 	  
45      // only people with tokens
46     modifier onlyBagholders() {
47         require(myTokens() > 0);
48         _;
49     }
50     
51     // only people with profits
52     modifier onlyStronghands() {
53         require(myDividends(true) > 0);
54         _;
55     }
56     
57     // administrators can:
58     // -> change the name of the contract
59     // -> change the name of the token
60     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
61     // they CANNOT:
62     // -> take funds
63     // -> disable withdrawals
64     // -> kill the contract
65     // -> change the price of tokens
66     
67     
68     modifier onlyAdministrator(){
69         address _customerAddress = msg.sender;
70         require(administrators[_customerAddress]);
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
145     string public name = "DIVIUM 10x2";
146     string public symbol = "DIVI10x2";
147     uint8 constant public decimals = 18;
148     uint8 constant internal dividendFee_ = 5;
149     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
150     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
151     uint256 constant internal magnitude = 2**64;
152     
153     // proof of stake (defaults at 50 tokens)
154     uint256 public stakingRequirement = 0e18;
155     
156     // SlowDump Limit
157     uint256 public slowDump = 100e18;
158     
159     // ambassador program
160     mapping(address => bool) internal ambassadors_;
161     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
162     uint256 constant internal ambassadorQuota_ = 2 ether;
163     
164     
165     
166    /*================================
167     =            DATASETS            =
168     ================================*/
169     // amount of shares for each address (scaled number)
170     mapping(address => uint256) internal tokenBalanceLedger_;
171     mapping(address => uint256) internal referralBalance_;
172     mapping(address => int256) internal payoutsTo_;
173     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
174     uint256 internal tokenSupply_ = 0;
175     uint256 internal profitPerShare_;
176     
177     // administrator list (see above on what they can do)
178     mapping(address => bool) public administrators;
179     
180     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
181     bool public onlyAmbassadors = true;
182     
183 
184 
185     /*=======================================
186     =            PUBLIC FUNCTIONS            =
187     =======================================*/
188     /*
189     * -- APPLICATION ENTRY POINTS --  
190     */
191 
192      
193     /**
194      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
195      */
196     function buy(address _referredBy)
197         public
198         payable
199         returns(uint256)
200     {
201         purchaseTokens(msg.value, _referredBy);
202     }
203     
204     /**
205      * Fallback function to handle ethereum that was send straight to the contract
206      * Unfortunately we cannot use a referral address this way.
207      */
208     function()
209         payable
210         public
211     {
212         purchaseTokens(msg.value, 0x0);
213     }
214     
215     /**
216      * Converts all of caller's dividends to tokens.
217     */
218     function reinvest(address _referredBy)
219         onlyStronghands()
220         public
221     {
222         // fetch dividends
223         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
224         
225         // pay out the dividends virtually
226         address _customerAddress = msg.sender;
227         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
228         
229         // retrieve ref. bonus
230         _dividends += referralBalance_[_customerAddress];
231         referralBalance_[_customerAddress] = 0;
232         
233         // dispatch a buy order with the virtualized "withdrawn dividends"
234         uint256 _tokens = purchaseTokens(_dividends, _referredBy);
235         
236         // fire event
237         onReinvestment(_customerAddress, _dividends, _tokens);
238     }
239     
240     /**
241      * Alias of sell() and withdraw().
242      */
243     function exit()
244         public
245     {
246         // get token count for caller & sell them all
247         address _customerAddress = msg.sender;
248         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
249         
250         //you cannot sell all if it is more than slowDump Limit
251         require(_tokens <= slowDump);
252         
253         
254         if(_tokens > 0) sell(_tokens);
255         
256         // lambo delivery service
257         withdraw();
258     }
259 
260     /**
261      * Withdraws all of the callers earnings.
262      */
263     function withdraw()
264         onlyStronghands()
265         public
266     {
267         // setup data
268         address _customerAddress = msg.sender;
269         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
270         
271         // update dividend tracker
272         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
273         
274         // add ref. bonus
275         _dividends += referralBalance_[_customerAddress];
276         referralBalance_[_customerAddress] = 0;
277         
278         // lambo delivery service
279         _customerAddress.transfer(_dividends);
280         
281         // fire event
282         onWithdraw(_customerAddress, _dividends);
283     }
284     
285     /**
286      * Liquifies tokens to ethereum.
287      */
288     function sell(uint256 _amountOfTokens)
289         onlyBagholders()
290         public
291     {
292         // setup data
293         address _customerAddress = msg.sender;
294         // russian hackers BTFO & Dump prevention
295         require(_amountOfTokens <= slowDump && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
296         uint256 _tokens = _amountOfTokens;
297         uint256 _ethereum = tokensToEthereum_(_tokens);
298         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
299         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
300         // burn the sold tokens
301         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
302         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
303         
304         // update dividends tracker
305         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
306         payoutsTo_[_customerAddress] -= _updatedPayouts;       
307         
308         // dividing by zero is a bad idea
309         if (tokenSupply_ > 0) {
310             // update the amount of dividends per token
311             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
312         }
313         
314         // fire event
315         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
316     }
317     
318     
319     /**
320      * Transfer tokens from the caller to a new holder.
321      * Remember, there's a 16% fee here as well.
322      */
323     function transfer(address _toAddress, uint256 _amountOfTokens)
324         onlyBagholders()
325         public
326         returns(bool)
327     {
328         // setup
329         address _customerAddress = msg.sender;
330         
331         // make sure we have the requested tokens
332         // also disables transfers until ambassador phase is over
333         // ( we dont want whale premines )
334         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
335         
336         // withdraw all outstanding dividends first
337         if(myDividends(true) > 0) withdraw();
338         
339         // liquify 10% of the tokens that are transfered
340         // these are dispersed to shareholders
341         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
342         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
343         uint256 _dividends = tokensToEthereum_(_tokenFee);
344   
345         // burn the fee tokens
346         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
347 
348         // exchange tokens
349         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
350         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
351         
352         // update dividend trackers
353         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
354         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
355         
356         // disperse dividends among holders
357         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
358         
359         // fire event
360         Transfer(_customerAddress, _toAddress, _taxedTokens);
361         // ERC20
362         return true;
363        
364     }
365     
366     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
367     /**
368      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
369      */
370     function disableInitialStage()
371         onlyAdministrator()
372         public
373     {
374         onlyAmbassadors = false;
375     }
376     
377    
378     
379     /**
380      * Precautionary measures in case we need to adjust the masternode rate.
381      */
382     function setStakingRequirement(uint256 _amountOfTokens)
383         onlyAdministrator()
384         public
385     {
386         require(_amountOfTokens > 10e18); //Admin cannot set slowdump limit below 10 tokens.
387         stakingRequirement = _amountOfTokens;
388     }
389     
390     /**
391      * If we want to change slowDump Sell limit,  we can.
392      */
393     function setSlowDump(uint256 _amountOfTokens)
394         onlyAdministrator()
395         public
396     {
397         slowDump = _amountOfTokens;
398     }
399     
400     /**
401      * If we want to rebrand, we can.
402      */
403     function setName(string _name)
404         onlyAdministrator()
405         public
406     {
407         name = _name;
408     }
409     
410     /**
411      * If we want to rebrand, we can.
412      */
413     function setSymbol(string _symbol)
414         onlyAdministrator()
415         public
416     {
417         symbol = _symbol;
418     }
419 
420     
421     /*----------  HELPERS AND CALCULATORS  ----------*/
422     /**
423      * Method to view the current Ethereum stored in the contract
424      * Example: totalEthereumBalance()
425      */
426     function totalEthereumBalance()
427         public
428         view
429         returns(uint)
430     {
431         return this.balance;
432     }
433     
434     /**
435      * Retrieve the total token supply.
436      */
437     function totalSupply()
438         public
439         view
440         returns(uint256)
441     {
442         return tokenSupply_;
443     }
444     
445     /**
446      * Retrieve the tokens owned by the caller.
447      */
448     function myTokens()
449         public
450         view
451         returns(uint256)
452     {
453         address _customerAddress = msg.sender;
454         return balanceOf(_customerAddress);
455     }
456     
457     /**
458      * Retrieve the dividends owned by the caller.
459      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
460      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
461      * But in the internal calculations, we want them separate. 
462      */ 
463     function myDividends(bool _includeReferralBonus) 
464         public 
465         view 
466         returns(uint256)
467     {
468         address _customerAddress = msg.sender;
469         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
470     }
471     
472     /**
473      * Retrieve the token balance of any single address.
474      */
475     function balanceOf(address _customerAddress)
476         view
477         public
478         returns(uint256)
479     {
480         return tokenBalanceLedger_[_customerAddress];
481     }
482     
483     /**
484      * Retrieve the dividend balance of any single address.
485      */
486     function dividendsOf(address _customerAddress)
487         view
488         public
489         returns(uint256)
490     {
491         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
492     }
493     
494     /**
495      * Return the buy price of 1 individual token.
496      */
497     function sellPrice() 
498         public 
499         view 
500         returns(uint256)
501     {
502         // our calculation relies on the token supply, so we need supply. Doh.
503         if(tokenSupply_ == 0){
504             return tokenPriceInitial_ - tokenPriceIncremental_;
505         } else {
506             uint256 _ethereum = tokensToEthereum_(1e18);
507             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
508             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
509             return _taxedEthereum;
510         }
511     }
512     
513     
514         function DIVIUMx2()
515         public
516     {
517         // add administrators here
518 
519         administrators[0x703e04F6162f0f6c63F397994EbbF372a90e3d1d] = true;
520         ambassadors_[0x480bc57cE5BDA76c60A3B74abff50ce4D1F17c1e] = true;
521         ambassadors_[0x2116a113E7FbC5ce43eFC333720dB7eB56332780] = true;
522         ambassadors_[0x0C4a9Ebd53E82cC6eb714Fa009C65e9386F76743] = true;
523 
524     }
525     
526     
527     
528     /**
529      * Return the sell price of 1 individual token.
530      */
531     function buyPrice() 
532         public 
533         view 
534         returns(uint256)
535     {
536         // our calculation relies on the token supply, so we need supply. Doh.
537         if(tokenSupply_ == 0){
538             return tokenPriceInitial_ + tokenPriceIncremental_;
539         } else {
540             uint256 _ethereum = tokensToEthereum_(1e18);
541             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
542             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
543             return _taxedEthereum;
544         }
545     }
546     
547     /**
548      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
549      */
550     function calculateTokensReceived(uint256 _ethereumToSpend) 
551         public 
552         view 
553         returns(uint256)
554     {
555         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
556         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
557         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
558         
559         return _amountOfTokens;
560     }
561     
562     /**
563      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
564      */
565     function calculateEthereumReceived(uint256 _tokensToSell) 
566         public 
567         view 
568         returns(uint256)
569     {
570         require(_tokensToSell <= tokenSupply_);
571         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
572         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
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
588         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
589         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
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