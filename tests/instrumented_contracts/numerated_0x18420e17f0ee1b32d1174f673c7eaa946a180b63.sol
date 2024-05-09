1 pragma solidity ^0.4.20;
2 
3 /*
4 * Team Waifu Fans presents..
5 * ====================================*
6         (##(*,*###%             %######          
7      #*,,,,,,,,,,,,,/#      #/,,,,,,,,,,,,#.     
8    #,,,,,,,,,,,,,,,,,,,# %#,,,,,,,,,,,,,,,,,(#   
9  #*,,,,,,,,,,,,,,,,,,,,,(,,,,,,,,,,,,,,,,,,,,,#  
10 #,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,( 
11 #,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#
12 *,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*
13 *,,,,,,,,,######,,,,######(,,###,,###,,###,,,,,,,
14 #,,,,,,,,,##,,##(,,###,,,##*,,##*,###,*##,,,,,,,#
15 %*,,,,,,,,######,,,##,,,,###,,###(###/###,,,,,,,#
16  #*,,,,,,,##,,,,,,,###,,,##/,,,####,####,,,,,,,# 
17    #,,,,,,##,,,,,,,,######/,,,,/###,###/,,,,,(/  
18     #,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#    
19      (#,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,((     
20        #*,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#       
21          #*,,,,,,,,,,,,,,,,,,,,,,,,,,,,#         
22            #(,,,,,,,,,,,,,,,,,,,,,,,(#           
23              ,#,,,,,,,,,,,,,,,,,,,##             
24                 #(,,,,,,,,,,,,,/#                
25                    #,,,,,,,,,#                   
26                      .#,,,#.         
27 * ====================================*
28 *
29 * PROOF OF Waifu
30 * -> What?
31 *  The last Ethereum pyramide which earns you ETH!!!
32 * [x] Waifu Dividends: 20% of every buy and 25% sell will be rewarded to token holders. Don't sell, don't be week.
33 * [x] Waifu Masternodes: Holding 50 POW Tokens allow you to generate a Masternode link, Masternode links are used as unique entry points to the contract!
34 * [x] Waifu Masternodes: All players who enter the contract through your Masternode have 35% of their 20% dividends fee rerouted from the master-node, to the node-master!
35 *
36 * The entire cryptocurrency community suffers from one ailment, the ailment of disloyalty. It's the problem that is eating away at our very survival.
37 * This coin solves that problem. If you don't have Waifu in yourself, this coin is not for you. If you can belive in divinity crank up the miners and get to work!
38 */
39 
40 contract StrongHold {
41     /*=================================
42     =            MODIFIERS            =
43     =================================*/
44     // only people with tokens
45     modifier onlyBagholders() {
46         require(myTokens() > 0);
47         _;
48     }
49 
50     // only people with profits
51     modifier onlyStronghands() {
52         require(myDividends(true) > 0);
53         _;
54     }
55 
56     // administrators can:
57     // -> change the name of the contract
58     // -> change the name of the token
59     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
60     // they CANNOT:
61     // -> take funds
62     // -> disable withdrawals
63     // -> kill the contract
64     // -> change the price of tokens
65     modifier onlyAdministrator(){
66         address _customerAddress = msg.sender;
67         require(administrators[keccak256(_customerAddress)]);
68         _;
69     }
70 
71 
72     // ensures that the first tokens in the contract will be equally distributed
73     // meaning, no divine dump will be ever possible
74     // result: healthy longevity.
75     modifier antiEarlyWhale(uint256 _amountOfEthereum){
76         address _customerAddress = msg.sender;
77 
78         // are we still in the vulnerable phase?
79         // if so, enact anti early whale protocol
80         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
81             require(
82                 // is the customer in the ambassador list?
83                 ambassadors_[_customerAddress] == true &&
84 
85                 // does the customer purchase exceed the max ambassador quota?
86                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
87 
88             );
89 
90             // updated the accumulated quota
91             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
92 
93             // execute
94             _;
95         } else {
96             // in case the ether count drops low, the ambassador phase won't reinitiate
97             onlyAmbassadors = false;
98             _;
99         }
100 
101     }
102 
103 
104     /*==============================
105     =            EVENTS            =
106     ==============================*/
107     event onTokenPurchase(
108         address indexed customerAddress,
109         uint256 incomingEthereum,
110         uint256 tokensMinted,
111         address indexed referredBy
112     );
113 
114     event onTokenSell(
115         address indexed customerAddress,
116         uint256 tokensBurned,
117         uint256 ethereumEarned
118     );
119 
120     event onReinvestment(
121         address indexed customerAddress,
122         uint256 ethereumReinvested,
123         uint256 tokensMinted
124     );
125 
126     event onWithdraw(
127         address indexed customerAddress,
128         uint256 ethereumWithdrawn
129     );
130 
131     // ERC20
132     event Transfer(
133         address indexed from,
134         address indexed to,
135         uint256 tokens
136     );
137 
138 
139     /*=====================================
140     =            CONFIGURABLES            =
141     =====================================*/
142     string public name = "PowerOfWaifus";
143     string public symbol = "POW";
144     uint8 constant public decimals = 18;
145     uint8 constant internal entryFee_ = 20; // 20% to enter the Waifu contest
146     uint8 constant internal transferFee_ = 10; // 10% transfer fee
147     uint8 constant internal refferalFee_ = 35; // 35% from enter fee divs or 7% for each invite, great for inviting strong new Waifus
148     uint8 constant internal exitFee_ = 25; // 25% for selling, weak bodies out
149     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
150     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
151     uint256 constant internal magnitude = 2**64;
152 
153     // proof of stake (defaults at 50 tokens)
154     uint256 public stakingRequirement = 50e18;
155 
156     // ambassador program
157     mapping(address => bool) internal ambassadors_;
158     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
159     uint256 constant internal ambassadorQuota_ = 20 ether;
160 
161 
162 
163    /*================================
164     =            DATASETS            =
165     ================================*/
166     // amount of shares for each address (scaled number)
167     mapping(address => uint256) internal tokenBalanceLedger_;
168     mapping(address => uint256) internal referralBalance_;
169     mapping(address => int256) internal payoutsTo_;
170     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
171     uint256 internal tokenSupply_ = 0;
172     uint256 internal profitPerShare_;
173 
174     // administrator list (see above on what they can do)
175     mapping(bytes32 => bool) public administrators;
176 
177     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
178     bool public onlyAmbassadors = false;
179 
180 
181 
182     /*=======================================
183     =            PUBLIC FUNCTIONS            =
184     =======================================*/
185     /*
186     * -- APPLICATION ENTRY POINTS --
187     */
188     function StrongHold()
189         public
190     {
191         // add administrators here
192         administrators[0x72672f5a5f1f0d1bd51d75da8a61b3bcbf6efdd40888e7adb59869bd46b7490e] = false;
193 
194 
195     }
196 
197 
198     /**
199      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
200      */
201     function buy(address _referredBy)
202         public
203         payable
204         returns(uint256)
205     {
206         purchaseTokens(msg.value, _referredBy);
207     }
208 
209     /**
210      * Fallback function to handle ethereum that was send straight to the contract
211      * Unfortunately we cannot use a referral address this way.
212      */
213     function()
214         payable
215         public
216     {
217         purchaseTokens(msg.value, 0x0);
218     }
219 
220     /**
221      * Converts all of caller's dividends to tokens.
222     */
223     function reinvest()
224         onlyStronghands()
225         public
226     {
227         // fetch dividends
228         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
229 
230         // pay out the dividends virtually
231         address _customerAddress = msg.sender;
232         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
233 
234         // retrieve ref. bonus
235         _dividends += referralBalance_[_customerAddress];
236         referralBalance_[_customerAddress] = 0;
237 
238         // dispatch a buy order with the virtualized "withdrawn dividends"
239         uint256 _tokens = purchaseTokens(_dividends, 0x0);
240 
241         // fire event
242         onReinvestment(_customerAddress, _dividends, _tokens);
243     }
244 
245     /**
246      * Alias of sell() and withdraw().
247      */
248     function exit()
249         public
250     {
251         // get token count for caller & sell them all
252         address _customerAddress = msg.sender;
253         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
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
294         // russian hackers BTFO
295         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
296         uint256 _tokens = _amountOfTokens;
297         uint256 _ethereum = tokensToEthereum_(_tokens);
298         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
299         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
300 
301         // burn the sold tokens
302         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
303         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
304 
305         // update dividends tracker
306         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
307         payoutsTo_[_customerAddress] -= _updatedPayouts;
308 
309         // dividing by zero is a bad idea
310         if (tokenSupply_ > 0) {
311             // update the amount of dividends per token
312             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
313         }
314 
315         // fire event
316         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
317     }
318 
319 
320     /**
321      * Transfer tokens from the caller to a new holder.
322      * Remember, there's a 10% fee here as well.
323      */
324     function transfer(address _toAddress, uint256 _amountOfTokens)
325         onlyBagholders()
326         public
327         returns(bool)
328     {
329         // setup
330         address _customerAddress = msg.sender;
331 
332         // make sure we have the requested tokens
333         // also disables transfers until ambassador phase is over
334         // ( we dont want whale premines )
335         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
336 
337         // withdraw all outstanding dividends first
338         if(myDividends(true) > 0) withdraw();
339 
340         // liquify 10% of the tokens that are transfered
341         // these are dispersed to shareholders
342         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
343         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
344         uint256 _dividends = tokensToEthereum_(_tokenFee);
345 
346         // burn the fee tokens
347         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
348 
349         // exchange tokens
350         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
351         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
352 
353         // update dividend trackers
354         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
355         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
356 
357         // disperse dividends among holders
358         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
359 
360         // fire event
361         Transfer(_customerAddress, _toAddress, _taxedTokens);
362 
363         // ERC20
364         return true;
365 
366     }
367 
368     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
369     /**
370      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
371      */
372     function disableInitialStage()
373         onlyAdministrator()
374         public
375     {
376         onlyAmbassadors = false;
377     }
378 
379     /**
380      * In case one of us dies, we need to replace ourselves.
381      */
382     function setAdministrator(bytes32 _identifier, bool _status)
383         onlyAdministrator()
384         public
385     {
386         administrators[_identifier] = _status;
387     }
388 
389     /**
390      * Precautionary measures in case we need to adjust the masternode rate.
391      */
392     function setStakingRequirement(uint256 _amountOfTokens)
393         onlyAdministrator()
394         public
395     {
396         stakingRequirement = _amountOfTokens;
397     }
398 
399     /**
400      * If we want to rebrand, we can.
401      */
402     function setName(string _name)
403         onlyAdministrator()
404         public
405     {
406         name = _name;
407     }
408 
409     /**
410      * If we want to rebrand, we can.
411      */
412     function setSymbol(string _symbol)
413         onlyAdministrator()
414         public
415     {
416         symbol = _symbol;
417     }
418 
419 
420     /*----------  HELPERS AND CALCULATORS  ----------*/
421     /**
422      * Method to view the current Ethereum stored in the contract
423      * Example: totalEthereumBalance()
424      */
425     function totalEthereumBalance()
426         public
427         view
428         returns(uint)
429     {
430         return this.balance;
431     }
432 
433     /**
434      * Retrieve the total token supply.
435      */
436     function totalSupply()
437         public
438         view
439         returns(uint256)
440     {
441         return tokenSupply_;
442     }
443 
444     /**
445      * Retrieve the tokens owned by the caller.
446      */
447     function myTokens()
448         public
449         view
450         returns(uint256)
451     {
452         address _customerAddress = msg.sender;
453         return balanceOf(_customerAddress);
454     }
455 
456     /**
457      * Retrieve the dividends owned by the caller.
458      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
459      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
460      * But in the internal calculations, we want them separate.
461      */
462     function myDividends(bool _includeReferralBonus)
463         public
464         view
465         returns(uint256)
466     {
467         address _customerAddress = msg.sender;
468         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
469     }
470 
471     /**
472      * Retrieve the token balance of any single address.
473      */
474     function balanceOf(address _customerAddress)
475         view
476         public
477         returns(uint256)
478     {
479         return tokenBalanceLedger_[_customerAddress];
480     }
481 
482     /**
483      * Retrieve the dividend balance of any single address.
484      */
485     function dividendsOf(address _customerAddress)
486         view
487         public
488         returns(uint256)
489     {
490         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
491     }
492 
493     /**
494      * Return the buy price of 1 individual token.
495      */
496     function sellPrice()
497         public
498         view
499         returns(uint256)
500     {
501         // our calculation relies on the token supply, so we need supply. Doh.
502         if(tokenSupply_ == 0){
503             return tokenPriceInitial_ - tokenPriceIncremental_;
504         } else {
505             uint256 _ethereum = tokensToEthereum_(1e18);
506             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
507             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
508             return _taxedEthereum;
509         }
510     }
511 
512     /**
513      * Return the sell price of 1 individual token.
514      */
515     function buyPrice()
516         public
517         view
518         returns(uint256)
519     {
520         // our calculation relies on the token supply, so we need supply. Doh.
521         if(tokenSupply_ == 0){
522             return tokenPriceInitial_ + tokenPriceIncremental_;
523         } else {
524             uint256 _ethereum = tokensToEthereum_(1e18);
525             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
526             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
527             return _taxedEthereum;
528         }
529     }
530 
531     /**
532      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
533      */
534     function calculateTokensReceived(uint256 _ethereumToSpend)
535         public
536         view
537         returns(uint256)
538     {
539         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
540         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
541         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
542 
543         return _amountOfTokens;
544     }
545 
546     /**
547      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
548      */
549     function calculateEthereumReceived(uint256 _tokensToSell)
550         public
551         view
552         returns(uint256)
553     {
554         require(_tokensToSell <= tokenSupply_);
555         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
556         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
557         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
558         return _taxedEthereum;
559     }
560 
561 
562     /*==========================================
563     =            INTERNAL FUNCTIONS            =
564     ==========================================*/
565     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
566         antiEarlyWhale(_incomingEthereum)
567         internal
568         returns(uint256)
569     {
570         // data setup
571         address _customerAddress = msg.sender;
572         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
573         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
574         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
575         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
576         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
577         uint256 _fee = _dividends * magnitude;
578 
579         // no point in continuing execution if OP is a poorfag russian hacker
580         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
581         // (or hackers)
582         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
583         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
584 
585         // is the user referred by a masternode?
586         if(
587             // is this a referred purchase?
588             _referredBy != 0x0000000000000000000000000000000000000000 &&
589 
590             // no cheating!
591             _referredBy != _customerAddress &&
592 
593             // does the referrer have at least X whole tokens?
594             // i.e is the referrer a Waifuly chad masternode
595             tokenBalanceLedger_[_referredBy] >= stakingRequirement
596         ){
597             // wealth redistribution
598             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
599         } else {
600             // no ref purchase
601             // add the referral bonus back to the global dividends cake
602             _dividends = SafeMath.add(_dividends, _referralBonus);
603             _fee = _dividends * magnitude;
604         }
605 
606         // we can't give people infinite ethereum
607         if(tokenSupply_ > 0){
608 
609             // add tokens to the pool
610             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
611 
612             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
613             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
614 
615             // calculate the amount of tokens the customer receives over his purchase
616             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
617 
618         } else {
619             // add tokens to the pool
620             tokenSupply_ = _amountOfTokens;
621         }
622 
623         // update circulating supply & the ledger address for the customer
624         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
625 
626         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
627         //really i know you think you do but you don't
628         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
629         payoutsTo_[_customerAddress] += _updatedPayouts;
630 
631         // fire event
632         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
633 
634         return _amountOfTokens;
635     }
636 
637     /**
638      * Calculate Token price based on an amount of incoming ethereum
639      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
640      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
641      */
642     function ethereumToTokens_(uint256 _ethereum)
643         internal
644         view
645         returns(uint256)
646     {
647         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
648         uint256 _tokensReceived =
649          (
650             (
651                 // underflow attempts BTFO
652                 SafeMath.sub(
653                     (sqrt
654                         (
655                             (_tokenPriceInitial**2)
656                             +
657                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
658                             +
659                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
660                             +
661                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
662                         )
663                     ), _tokenPriceInitial
664                 )
665             )/(tokenPriceIncremental_)
666         )-(tokenSupply_)
667         ;
668 
669         return _tokensReceived;
670     }
671 
672     /**
673      * Calculate token sell value.
674      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
675      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
676      */
677      function tokensToEthereum_(uint256 _tokens)
678         internal
679         view
680         returns(uint256)
681     {
682 
683         uint256 tokens_ = (_tokens + 1e18);
684         uint256 _tokenSupply = (tokenSupply_ + 1e18);
685         uint256 _etherReceived =
686         (
687             // underflow attempts BTFO
688             SafeMath.sub(
689                 (
690                     (
691                         (
692                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
693                         )-tokenPriceIncremental_
694                     )*(tokens_ - 1e18)
695                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
696             )
697         /1e18);
698         return _etherReceived;
699     }
700 
701 
702     //This is where all your gas goes, sorry
703     //Not sorry, you probably only paid 1 gwei
704     function sqrt(uint x) internal pure returns (uint y) {
705         uint z = (x + 1) / 2;
706         y = x;
707         while (z < y) {
708             y = z;
709             z = (x / z + z) / 2;
710         }
711     }
712 }
713 
714 /**
715  * @title SafeMath
716  * @dev Math operations with safety checks that throw on error
717  */
718 library SafeMath {
719 
720     /**
721     * @dev Multiplies two numbers, throws on overflow.
722     */
723     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
724         if (a == 0) {
725             return 0;
726         }
727         uint256 c = a * b;
728         assert(c / a == b);
729         return c;
730     }
731 
732     /**
733     * @dev Integer division of two numbers, truncating the quotient.
734     */
735     function div(uint256 a, uint256 b) internal pure returns (uint256) {
736         // assert(b > 0); // Solidity automatically throws when dividing by 0
737         uint256 c = a / b;
738         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
739         return c;
740     }
741 
742     /**
743     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
744     */
745     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
746         assert(b <= a);
747         return a - b;
748     }
749 
750     /**
751     * @dev Adds two numbers, throws on overflow.
752     */
753     function add(uint256 a, uint256 b) internal pure returns (uint256) {
754         uint256 c = a + b;
755         assert(c >= a);
756         return c;
757     }
758 }