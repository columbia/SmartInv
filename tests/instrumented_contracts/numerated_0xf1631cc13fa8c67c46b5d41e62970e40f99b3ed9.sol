1 pragma solidity ^0.4.20;
2 
3 pragma solidity ^0.4.20;
4 
5 /*
6 * Team noFUCKS presents..
7 * ====================================*
8 *                                     *
9 *                                     *  
10 *                                     *
11 *                                     *
12 *            ---,_,----               *
13 *           /    .     \              *
14 *          /     |      \             *
15 *         (      @@      )            *
16 *         /   _/----\_   \            *
17 *        /   '/      \`   \	          *
18 *       /    /   .    \    \          *
19 *      /    /|        |\    \         *
20 *      /   / |        | \   \         *
21 *     /   /`_/_      _\_'\   \        *
22 *    /  '/  (  . )( .  )  \  `\       *
23 *    <_ ' `--`___'`___'--' ` _>       *
24 *   /  '     @ @/ =\@ @     `  \      *
25 *  /  /      @@(  , )@@      \  \     *
26 * /  /       @@| o o|@@       \  \    *
27 *' /          @@@@@@@@          \ `   *
28 *                                     *
29 * ====================================*
30 *
31 * PROOF OF HOT BODY
32 * -> What?
33 *  The last Ethereum pyramid (for real this time!) which earns you ETH!!!
34 * [x] Hot Dividends: 20% of every buy and 25% sell will be rewarded to token holders. Don't sell, don't be week.
35 * [x] Hot Masternodes: Holding 50 POHB Tokens allow you to generate a Masternode link, Masternode links are used as unique entry points to the contract!
36 * [x] HOT BODS: All players who enter the contract through your Masternode have 35% of their 20% dividends fee rerouted from the master-node, to the node-master!
37 *
38 * The entire cryptocurrency community suffers from one ailment, the ailment of disloyalty. It's the problem that is eating away at our very survival.
39 * This coin solves that problem. If you have weak body, this coin is not for you. If you can go the distance crank up the miners and get to work!
40 */
41 
42 contract StrongHold {
43     /*=================================
44     =            MODIFIERS            =
45     =================================*/
46     // only people with tokens
47     modifier onlyBagholders() {
48         require(myTokens() > 0);
49         _;
50     }
51 
52     // only people with profits
53     modifier onlyStronghands() {
54         require(myDividends(true) > 0);
55         _;
56     }
57 
58     // administrators can:
59     // -> change the name of the contract
60     // -> change the name of the token
61     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
62     // they CANNOT:
63     // -> take funds
64     // -> disable withdrawals
65     // -> kill the contract
66     // -> change the price of tokens
67     modifier onlyAdministrator(){
68         address _customerAddress = msg.sender;
69         require(administrators[keccak256(_customerAddress)]);
70         _;
71     }
72 
73 
74     // ensures that the first tokens in the contract will be equally distributed
75     // meaning, no divine dump will be ever possible
76     // result: healthy longevity.
77     modifier antiEarlyWhale(uint256 _amountOfEthereum){
78         address _customerAddress = msg.sender;
79 
80         // are we still in the vulnerable phase?
81         // if so, enact anti early whale protocol
82         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
83             require(
84                 // is the customer in the ambassador list?
85                 ambassadors_[_customerAddress] == true &&
86 
87                 // does the customer purchase exceed the max ambassador quota?
88                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
89 
90             );
91 
92             // updated the accumulated quota
93             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
94 
95             // execute
96             _;
97         } else {
98             // in case the ether count drops low, the ambassador phase won't reinitiate
99             onlyAmbassadors = false;
100             _;
101         }
102 
103     }
104 
105 
106     /*==============================
107     =            EVENTS            =
108     ==============================*/
109     event onTokenPurchase(
110         address indexed customerAddress,
111         uint256 incomingEthereum,
112         uint256 tokensMinted,
113         address indexed referredBy
114     );
115 
116     event onTokenSell(
117         address indexed customerAddress,
118         uint256 tokensBurned,
119         uint256 ethereumEarned
120     );
121 
122     event onReinvestment(
123         address indexed customerAddress,
124         uint256 ethereumReinvested,
125         uint256 tokensMinted
126     );
127 
128     event onWithdraw(
129         address indexed customerAddress,
130         uint256 ethereumWithdrawn
131     );
132 
133     // ERC20
134     event Transfer(
135         address indexed from,
136         address indexed to,
137         uint256 tokens
138     );
139 
140 
141     /*=====================================
142     =            CONFIGURABLES            =
143     =====================================*/
144     string public name = "POStrongBody";
145     string public symbol = "PSB";
146     uint8 constant public decimals = 18;
147     uint8 constant internal entryFee_ = 20; // 20% to enter the strong body coins
148     uint8 constant internal transferFee_ = 10; // 10% transfer fee
149     uint8 constant internal refferalFee_ = 35; // 35% from enter fee divs or 7% for each invite, great for inviting strong bodies
150     uint8 constant internal exitFee_ = 25; // 25% for selling, weak bodies out
151     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
152     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
153     uint256 constant internal magnitude = 2**64;
154 
155     // proof of stake (defaults at 50 tokens)
156     uint256 public stakingRequirement = 50e18;
157 
158     // ambassador program
159     mapping(address => bool) internal ambassadors_;
160     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
161     uint256 constant internal ambassadorQuota_ = 20 ether; // Ocean's -Thirteen- TwentyFive (Big Strong Bodies)
162 
163 
164 
165    /*================================
166     =            DATASETS            =
167     ================================*/
168     // amount of shares for each address (scaled number)
169     mapping(address => uint256) internal tokenBalanceLedger_;
170     mapping(address => uint256) internal referralBalance_;
171     mapping(address => int256) internal payoutsTo_;
172     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
173     uint256 internal tokenSupply_ = 0;
174     uint256 internal profitPerShare_;
175 
176     // administrator list (see above on what they can do)
177     mapping(bytes32 => bool) public administrators;
178 
179     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
180     bool public onlyAmbassadors = false;
181 
182 
183 
184     /*=======================================
185     =            PUBLIC FUNCTIONS            =
186     =======================================*/
187     /*
188     * -- APPLICATION ENTRY POINTS --
189     */
190     function StrongHold()
191         public
192     {
193         // add administrators here
194         administrators[0xfab95f62dea147f9ba8eec368611c7bfc37e6c92680a158d1c8c390253ba8ee] = false;
195 
196 
197     }
198 
199 
200     /**
201      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
202      */
203     function buy(address _referredBy)
204         public
205         payable
206         returns(uint256)
207     {
208         purchaseTokens(msg.value, _referredBy);
209     }
210 
211     /**
212      * Fallback function to handle ethereum that was send straight to the contract
213      * Unfortunately we cannot use a referral address this way.
214      */
215     function()
216         payable
217         public
218     {
219         purchaseTokens(msg.value, 0x0);
220     }
221 
222     /**
223      * Converts all of caller's dividends to tokens.
224     */
225     function reinvest()
226         onlyStronghands()
227         public
228     {
229         // fetch dividends
230         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
231 
232         // pay out the dividends virtually
233         address _customerAddress = msg.sender;
234         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
235 
236         // retrieve ref. bonus
237         _dividends += referralBalance_[_customerAddress];
238         referralBalance_[_customerAddress] = 0;
239 
240         // dispatch a buy order with the virtualized "withdrawn dividends"
241         uint256 _tokens = purchaseTokens(_dividends, 0x0);
242 
243         // fire event
244         onReinvestment(_customerAddress, _dividends, _tokens);
245     }
246 
247     /**
248      * Alias of sell() and withdraw().
249      */
250     function exit()
251         public
252     {
253         // get token count for caller & sell them all
254         address _customerAddress = msg.sender;
255         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
256         if(_tokens > 0) sell(_tokens);
257 
258         // lambo delivery service
259         withdraw();
260     }
261 
262     /**
263      * Withdraws all of the callers earnings.
264      */
265     function withdraw()
266         onlyStronghands()
267         public
268     {
269         // setup data
270         address _customerAddress = msg.sender;
271         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
272 
273         // update dividend tracker
274         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
275 
276         // add ref. bonus
277         _dividends += referralBalance_[_customerAddress];
278         referralBalance_[_customerAddress] = 0;
279 
280         // lambo delivery service
281         _customerAddress.transfer(_dividends);
282 
283         // fire event
284         onWithdraw(_customerAddress, _dividends);
285     }
286 
287     /**
288      * Liquifies tokens to ethereum.
289      */
290     function sell(uint256 _amountOfTokens)
291         onlyBagholders()
292         public
293     {
294         // setup data
295         address _customerAddress = msg.sender;
296         // russian hackers BTFO
297         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
298         uint256 _tokens = _amountOfTokens;
299         uint256 _ethereum = tokensToEthereum_(_tokens);
300         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
301         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
302 
303         // burn the sold tokens
304         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
305         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
306 
307         // update dividends tracker
308         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
309         payoutsTo_[_customerAddress] -= _updatedPayouts;
310 
311         // dividing by zero is a bad idea
312         if (tokenSupply_ > 0) {
313             // update the amount of dividends per token
314             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
315         }
316 
317         // fire event
318         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
319     }
320 
321 
322     /**
323      * Transfer tokens from the caller to a new holder.
324      * Remember, there's a 10% fee here as well.
325      */
326     function transfer(address _toAddress, uint256 _amountOfTokens)
327         onlyBagholders()
328         public
329         returns(bool)
330     {
331         // setup
332         address _customerAddress = msg.sender;
333 
334         // make sure we have the requested tokens
335         // also disables transfers until ambassador phase is over
336         // ( we dont want whale premines )
337         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
338 
339         // withdraw all outstanding dividends first
340         if(myDividends(true) > 0) withdraw();
341 
342         // liquify 10% of the tokens that are transfered
343         // these are dispersed to shareholders
344         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
345         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
346         uint256 _dividends = tokensToEthereum_(_tokenFee);
347 
348         // burn the fee tokens
349         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
350 
351         // exchange tokens
352         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
353         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
354 
355         // update dividend trackers
356         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
357         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
358 
359         // disperse dividends among holders
360         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
361 
362         // fire event
363         Transfer(_customerAddress, _toAddress, _taxedTokens);
364 
365         // ERC20
366         return true;
367 
368     }
369 
370     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
371     /**
372      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
373      */
374     function disableInitialStage()
375         onlyAdministrator()
376         public
377     {
378         onlyAmbassadors = false;
379     }
380 
381     /**
382      * In case one of us dies, we need to replace ourselves.
383      */
384     function setAdministrator(bytes32 _identifier, bool _status)
385         onlyAdministrator()
386         public
387     {
388         administrators[_identifier] = _status;
389     }
390 
391     /**
392      * Precautionary measures in case we need to adjust the masternode rate.
393      */
394     function setStakingRequirement(uint256 _amountOfTokens)
395         onlyAdministrator()
396         public
397     {
398         stakingRequirement = _amountOfTokens;
399     }
400 
401     /**
402      * If we want to rebrand, we can.
403      */
404     function setName(string _name)
405         onlyAdministrator()
406         public
407     {
408         name = _name;
409     }
410 
411     /**
412      * If we want to rebrand, we can.
413      */
414     function setSymbol(string _symbol)
415         onlyAdministrator()
416         public
417     {
418         symbol = _symbol;
419     }
420 
421 
422     /*----------  HELPERS AND CALCULATORS  ----------*/
423     /**
424      * Method to view the current Ethereum stored in the contract
425      * Example: totalEthereumBalance()
426      */
427     function totalEthereumBalance()
428         public
429         view
430         returns(uint)
431     {
432         return this.balance;
433     }
434 
435     /**
436      * Retrieve the total token supply.
437      */
438     function totalSupply()
439         public
440         view
441         returns(uint256)
442     {
443         return tokenSupply_;
444     }
445 
446     /**
447      * Retrieve the tokens owned by the caller.
448      */
449     function myTokens()
450         public
451         view
452         returns(uint256)
453     {
454         address _customerAddress = msg.sender;
455         return balanceOf(_customerAddress);
456     }
457 
458     /**
459      * Retrieve the dividends owned by the caller.
460      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
461      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
462      * But in the internal calculations, we want them separate.
463      */
464     function myDividends(bool _includeReferralBonus)
465         public
466         view
467         returns(uint256)
468     {
469         address _customerAddress = msg.sender;
470         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
471     }
472 
473     /**
474      * Retrieve the token balance of any single address.
475      */
476     function balanceOf(address _customerAddress)
477         view
478         public
479         returns(uint256)
480     {
481         return tokenBalanceLedger_[_customerAddress];
482     }
483 
484     /**
485      * Retrieve the dividend balance of any single address.
486      */
487     function dividendsOf(address _customerAddress)
488         view
489         public
490         returns(uint256)
491     {
492         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
493     }
494 
495     /**
496      * Return the buy price of 1 individual token.
497      */
498     function sellPrice()
499         public
500         view
501         returns(uint256)
502     {
503         // our calculation relies on the token supply, so we need supply. Doh.
504         if(tokenSupply_ == 0){
505             return tokenPriceInitial_ - tokenPriceIncremental_;
506         } else {
507             uint256 _ethereum = tokensToEthereum_(1e18);
508             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
509             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
510             return _taxedEthereum;
511         }
512     }
513 
514     /**
515      * Return the sell price of 1 individual token.
516      */
517     function buyPrice()
518         public
519         view
520         returns(uint256)
521     {
522         // our calculation relies on the token supply, so we need supply. Doh.
523         if(tokenSupply_ == 0){
524             return tokenPriceInitial_ + tokenPriceIncremental_;
525         } else {
526             uint256 _ethereum = tokensToEthereum_(1e18);
527             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
528             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
529             return _taxedEthereum;
530         }
531     }
532 
533     /**
534      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
535      */
536     function calculateTokensReceived(uint256 _ethereumToSpend)
537         public
538         view
539         returns(uint256)
540     {
541         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
542         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
543         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
544 
545         return _amountOfTokens;
546     }
547 
548     /**
549      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
550      */
551     function calculateEthereumReceived(uint256 _tokensToSell)
552         public
553         view
554         returns(uint256)
555     {
556         require(_tokensToSell <= tokenSupply_);
557         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
558         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
559         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
560         return _taxedEthereum;
561     }
562 
563 
564     /*==========================================
565     =            INTERNAL FUNCTIONS            =
566     ==========================================*/
567     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
568         antiEarlyWhale(_incomingEthereum)
569         internal
570         returns(uint256)
571     {
572         // data setup
573         address _customerAddress = msg.sender;
574         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
575         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
576         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
577         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
578         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
579         uint256 _fee = _dividends * magnitude;
580 
581         // no point in continuing execution if OP is a poorfag russian hacker
582         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
583         // (or hackers)
584         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
585         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
586 
587         // is the user referred by a masternode?
588         if(
589             // is this a referred purchase?
590             _referredBy != 0x0000000000000000000000000000000000000000 &&
591 
592             // no cheating!
593             _referredBy != _customerAddress &&
594 
595             // does the referrer have at least X whole tokens?
596             // i.e is the referrer a godly chad masternode
597             tokenBalanceLedger_[_referredBy] >= stakingRequirement
598         ){
599             // wealth redistribution
600             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
601         } else {
602             // no ref purchase
603             // add the referral bonus back to the global dividends cake
604             _dividends = SafeMath.add(_dividends, _referralBonus);
605             _fee = _dividends * magnitude;
606         }
607 
608         // we can't give people infinite ethereum
609         if(tokenSupply_ > 0){
610 
611             // add tokens to the pool
612             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
613 
614             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
615             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
616 
617             // calculate the amount of tokens the customer receives over his purchase
618             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
619 
620         } else {
621             // add tokens to the pool
622             tokenSupply_ = _amountOfTokens;
623         }
624 
625         // update circulating supply & the ledger address for the customer
626         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
627 
628         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
629         //really i know you think you do but you don't
630         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
631         payoutsTo_[_customerAddress] += _updatedPayouts;
632 
633         // fire event
634         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
635 
636         return _amountOfTokens;
637     }
638 
639     /**
640      * Calculate Token price based on an amount of incoming ethereum
641      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
642      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
643      */
644     function ethereumToTokens_(uint256 _ethereum)
645         internal
646         view
647         returns(uint256)
648     {
649         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
650         uint256 _tokensReceived =
651          (
652             (
653                 // underflow attempts BTFO
654                 SafeMath.sub(
655                     (sqrt
656                         (
657                             (_tokenPriceInitial**2)
658                             +
659                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
660                             +
661                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
662                             +
663                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
664                         )
665                     ), _tokenPriceInitial
666                 )
667             )/(tokenPriceIncremental_)
668         )-(tokenSupply_)
669         ;
670 
671         return _tokensReceived;
672     }
673 
674     /**
675      * Calculate token sell value.
676      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
677      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
678      */
679      function tokensToEthereum_(uint256 _tokens)
680         internal
681         view
682         returns(uint256)
683     {
684 
685         uint256 tokens_ = (_tokens + 1e18);
686         uint256 _tokenSupply = (tokenSupply_ + 1e18);
687         uint256 _etherReceived =
688         (
689             // underflow attempts BTFO
690             SafeMath.sub(
691                 (
692                     (
693                         (
694                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
695                         )-tokenPriceIncremental_
696                     )*(tokens_ - 1e18)
697                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
698             )
699         /1e18);
700         return _etherReceived;
701     }
702 
703 
704     //This is where all your gas goes, sorry
705     //Not sorry, you probably only paid 1 gwei
706     function sqrt(uint x) internal pure returns (uint y) {
707         uint z = (x + 1) / 2;
708         y = x;
709         while (z < y) {
710             y = z;
711             z = (x / z + z) / 2;
712         }
713     }
714 }
715 
716 /**
717  * @title SafeMath
718  * @dev Math operations with safety checks that throw on error
719  */
720 library SafeMath {
721 
722     /**
723     * @dev Multiplies two numbers, throws on overflow.
724     */
725     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
726         if (a == 0) {
727             return 0;
728         }
729         uint256 c = a * b;
730         assert(c / a == b);
731         return c;
732     }
733 
734     /**
735     * @dev Integer division of two numbers, truncating the quotient.
736     */
737     function div(uint256 a, uint256 b) internal pure returns (uint256) {
738         // assert(b > 0); // Solidity automatically throws when dividing by 0
739         uint256 c = a / b;
740         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
741         return c;
742     }
743 
744     /**
745     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
746     */
747     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
748         assert(b <= a);
749         return a - b;
750     }
751 
752     /**
753     * @dev Adds two numbers, throws on overflow.
754     */
755     function add(uint256 a, uint256 b) internal pure returns (uint256) {
756         uint256 c = a + b;
757         assert(c >= a);
758         return c;
759     }
760 }