1 /**
2 *    ___  __           _______   _        ____             __
3 *   / _ )/ /_ _____   / ___/ /  (_)__    / __/_ _____  ___/ /
4 *  / _  / / // / -_) / /__/ _ \/ / _ \  / _// // / _ \/ _  / 
5 * /____/_/\_,_/\__/  \___/_//_/_/ .__/ /_/  \_,_/_//_/\_,_/  
6 *                              /_/                           
7 * 
8 * https://bluechip.fund/
9 * https://bluechip.fund/exchange
10 * 
11 * https://discord.gg/aee8BjR
12 * https://t.me/bluechipfund
13 *  
14 * ====================================*
15 *
16 * 20% Dividends:
17 * - Distributed to BLUE tokenholders proportional to the total BLUE circulating supply
18 * 
19 * Real Masternode Referrals:
20 * - Receive 6% of the total transaction (30% of the 20% generated dividends)
21 *
22 * The original autonomous pyramid, improved:
23 * - Fully Decentralized Earnings Platform. Transparent, Open source Ethereum code
24 * - More stable than ever, having withstood severe test and mainnet abuse and attack attempts
25 * - Audited, tested, and approved by known community security specialists and veteran solidity experts
26 * - Testnet iterations have been deployed; with not a single point of failure found
27 *
28 * Still, no guarantees are given. 
29 * Please be careful and doublecheck when interacting with the contract
30 * 
31 */
32 
33 pragma solidity ^0.4.20;
34 
35 /*
36 * Main Net Version
37 */
38 
39 contract BlueChipMain {
40     /*=================================
41     =            MODIFIERS            =
42     =================================*/
43     // only people with tokens
44     modifier onlyBagholders() {
45         require(myTokens() > 0);
46         _;
47     }
48     
49     // only people with profits
50     modifier onlyStronghands() {
51         require(myDividends(true) > 0);
52         _;
53     }
54     
55     // administrators can:
56     // -> change the name of the contract
57     // -> change the name of the token
58     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
59     // they CANNOT:
60     // -> take funds
61     // -> disable withdrawals
62     // -> kill the contract
63     // -> change the price of tokens
64     modifier onlyAdministrator(){
65         address _customerAddress = msg.sender;
66         require(administrators[keccak256(_customerAddress)]);
67         _;
68     }
69     
70     
71     // ensures that the first tokens in the contract will be equally distributed
72     // meaning, no divine dump will be ever possible
73     // result: healthy longevity.
74     modifier antiEarlyWhale(uint256 _amountOfEthereum){
75         address _customerAddress = msg.sender;
76         
77         // are we still in the vulnerable phase?
78         // if so, enact anti early whale protocol 
79         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
80             require(
81                 // is the customer in the ambassador list?
82                 ambassadors_[_customerAddress] == true &&
83                 
84                 // does the customer purchase exceed the max ambassador quota?
85                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
86                 
87             );
88             
89             // updated the accumulated quota    
90             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
91         
92             // execute
93             _;
94         } else {
95             // in case the ether count drops low, the ambassador phase won't reinitiate
96             onlyAmbassadors = false;
97             _;    
98         }
99         
100     }
101     
102     
103     /*==============================
104     =            EVENTS            =
105     ==============================*/
106     event onTokenPurchase(
107         address indexed customerAddress,
108         uint256 incomingEthereum,
109         uint256 tokensMinted,
110         address indexed referredBy
111     );
112     
113     event onTokenSell(
114         address indexed customerAddress,
115         uint256 tokensBurned,
116         uint256 ethereumEarned
117     );
118     
119     event onReinvestment(
120         address indexed customerAddress,
121         uint256 ethereumReinvested,
122         uint256 tokensMinted
123     );
124     
125     event onWithdraw(
126         address indexed customerAddress,
127         uint256 ethereumWithdrawn
128     );
129     
130     // ERC20
131     event Transfer(
132         address indexed from,
133         address indexed to,
134         uint256 tokens
135     );
136     
137     
138     /*=====================================
139     =            CONFIGURABLES            =
140     =====================================*/
141     string public name = "Blue Chip Fund";
142     string public symbol = "BLUE";
143     uint8 constant public decimals = 18;
144     uint8 constant internal dividendFee_ = 5;
145     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
146     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
147     uint256 constant internal magnitude = 2**64;
148 
149 
150     // proof of stake (defaults at 100 tokens)
151     uint256 public stakingRequirement = 1e18;
152     
153     // ambassador program
154     mapping(address => bool) internal ambassadors_;
155     uint256 constant internal ambassadorMaxPurchase_ = 1.0 ether;
156     uint256 constant internal ambassadorQuota_ = 2.0 ether;
157     
158     
159     
160    /*================================
161     =            DATASETS            =
162     ================================*/
163     // amount of shares for each address (scaled number)
164     mapping(address => uint256) internal tokenBalanceLedger_;
165     mapping(address => uint256) internal referralBalance_;
166     mapping(address => int256) internal payoutsTo_;
167     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
168     uint256 internal tokenSupply_ = 0;
169     uint256 internal profitPerShare_;
170     
171     // administrator list (see above on what they can do)
172     mapping(bytes32 => bool) public administrators;
173     
174     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
175     bool public onlyAmbassadors = true;
176     
177 
178 
179     /*=======================================
180     =            PUBLIC FUNCTIONS            =
181     =======================================*/
182     /*
183     * -- APPLICATION ENTRY POINTS --  
184     */
185     function BlueChip()
186         public
187     {
188         // add administrators here
189         administrators[keccak256(0xFeFa15424Fd45bAFe123163B2ad8D509c1256256)] = true;
190         
191         // add the ambassadors here.
192         ambassadors_[0x895a6E21AcC9F4e81B77Cf28A6599FF3805dC81e] = true;
193         ambassadors_[0xFeFa15424Fd45bAFe123163B2ad8D509c1256256] = true;
194     }
195     
196      
197     /**
198      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
199      */
200     function buy(address _referredBy)
201         public
202         payable
203         returns(uint256)
204     {
205         purchaseTokens(msg.value, _referredBy);
206     }
207     
208     /**
209      * Fallback function to handle ethereum that was send straight to the contract
210      * Unfortunately we cannot use a referral address this way.
211      */
212     function()
213         payable
214         public
215     {
216         purchaseTokens(msg.value, 0x0);
217     }
218     
219     /**
220      * Converts all of caller's dividends to tokens.
221      */
222     function reinvest()
223         onlyStronghands()
224         public
225     {
226         // fetch dividends
227         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
228         
229         // pay out the dividends virtually
230         address _customerAddress = msg.sender;
231         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
232         
233         // retrieve ref. bonus
234         _dividends += referralBalance_[_customerAddress];
235         referralBalance_[_customerAddress] = 0;
236         
237         // dispatch a buy order with the virtualized "withdrawn dividends"
238         uint256 _tokens = purchaseTokens(_dividends, 0x0);
239         
240         // fire event
241         onReinvestment(_customerAddress, _dividends, _tokens);
242     }
243     
244     /**
245      * Alias of sell() and withdraw().
246      */
247     function exit()
248         public
249     {
250         // get token count for caller & sell them all
251         address _customerAddress = msg.sender;
252         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
253         if(_tokens > 0) sell(_tokens);
254         
255         // lambo delivery service
256         withdraw();
257     }
258 
259     /**
260      * Withdraws all of the callers earnings.
261      */
262     function withdraw()
263         onlyStronghands()
264         public
265     {
266         // setup data
267         address _customerAddress = msg.sender;
268         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
269         
270         // update dividend tracker
271         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
272         
273         // add ref. bonus
274         _dividends += referralBalance_[_customerAddress];
275         referralBalance_[_customerAddress] = 0;
276         
277         // lambo delivery service
278         _customerAddress.transfer(_dividends);
279         
280         // fire event
281         onWithdraw(_customerAddress, _dividends);
282     }
283     
284     /**
285      * Liquifies tokens to ethereum.
286      */
287     function sell(uint256 _amountOfTokens)
288         onlyBagholders()
289         public
290     {
291         // setup data
292         address _customerAddress = msg.sender;
293         // russian hackers BTFO
294         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
295         uint256 _tokens = _amountOfTokens;
296         uint256 _ethereum = tokensToEthereum_(_tokens);
297         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
298         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
299         
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
321      * Remember, there's a 10% fee here as well.
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
361         
362         // ERC20
363         return true;
364        
365     }
366     
367     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
368     /**
369      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
370      */
371     function disableInitialStage()
372         onlyAdministrator()
373         public
374     {
375         onlyAmbassadors = false;
376     }
377     
378     /**
379      * In case one of us dies, we need to replace ourselves.
380      */
381     function setAdministrator(bytes32 _identifier, bool _status)
382         onlyAdministrator()
383         public
384     {
385         administrators[_identifier] = _status;
386     }
387     
388     /**
389      * Precautionary measures in case we need to adjust the masternode rate.
390      */
391     function setStakingRequirement(uint256 _amountOfTokens)
392         onlyAdministrator()
393         public
394     {
395         stakingRequirement = _amountOfTokens;
396     }
397     
398     /**
399      * If we want to rebrand, we can.
400      */
401     function setName(string _name)
402         onlyAdministrator()
403         public
404     {
405         name = _name;
406     }
407     
408     /**
409      * If we want to rebrand, we can.
410      */
411     function setSymbol(string _symbol)
412         onlyAdministrator()
413         public
414     {
415         symbol = _symbol;
416     }
417 
418     
419     /*----------  HELPERS AND CALCULATORS  ----------*/
420     /**
421      * Method to view the current Ethereum stored in the contract
422      * Example: totalEthereumBalance()
423      */
424     function totalEthereumBalance()
425         public
426         view
427         returns(uint)
428     {
429         return this.balance;
430     }
431     
432     /**
433      * Retrieve the total token supply.
434      */
435     function totalSupply()
436         public
437         view
438         returns(uint256)
439     {
440         return tokenSupply_;
441     }
442     
443     /**
444      * Retrieve the tokens owned by the caller.
445      */
446     function myTokens()
447         public
448         view
449         returns(uint256)
450     {
451         address _customerAddress = msg.sender;
452         return balanceOf(_customerAddress);
453     }
454     
455     /**
456      * Retrieve the dividends owned by the caller.
457      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
458      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
459      * But in the internal calculations, we want them separate. 
460      */ 
461     function myDividends(bool _includeReferralBonus) 
462         public 
463         view 
464         returns(uint256)
465     {
466         address _customerAddress = msg.sender;
467         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
468     }
469     
470     /**
471      * Retrieve the token balance of any single address.
472      */
473     function balanceOf(address _customerAddress)
474         view
475         public
476         returns(uint256)
477     {
478         return tokenBalanceLedger_[_customerAddress];
479     }
480     
481     /**
482      * Retrieve the dividend balance of any single address.
483      */
484     function dividendsOf(address _customerAddress)
485         view
486         public
487         returns(uint256)
488     {
489         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
490     }
491     
492     /**
493      * Return the buy price of 1 individual token.
494      */
495     function sellPrice() 
496         public 
497         view 
498         returns(uint256)
499     {
500         // our calculation relies on the token supply, so we need supply. Doh.
501         if(tokenSupply_ == 0){
502             return tokenPriceInitial_ - tokenPriceIncremental_;
503         } else {
504             uint256 _ethereum = tokensToEthereum_(1e18);
505             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
506             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
507             return _taxedEthereum;
508         }
509     }
510     
511     /**
512      * Return the sell price of 1 individual token.
513      */
514     function buyPrice() 
515         public 
516         view 
517         returns(uint256)
518     {
519         // our calculation relies on the token supply, so we need supply. Doh.
520         if(tokenSupply_ == 0){
521             return tokenPriceInitial_ + tokenPriceIncremental_;
522         } else {
523             uint256 _ethereum = tokensToEthereum_(1e18);
524             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
525             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
526             return _taxedEthereum;
527         }
528     }
529     
530     /**
531      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
532      */
533     function calculateTokensReceived(uint256 _ethereumToSpend) 
534         public 
535         view 
536         returns(uint256)
537     {
538         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
539         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
540         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
541         
542         return _amountOfTokens;
543     }
544     
545     /**
546      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
547      */
548     function calculateEthereumReceived(uint256 _tokensToSell) 
549         public 
550         view 
551         returns(uint256)
552     {
553         require(_tokensToSell <= tokenSupply_);
554         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
555         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
556         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
557         return _taxedEthereum;
558     }
559     
560     
561     /*==========================================
562     =            INTERNAL FUNCTIONS            =
563     ==========================================*/
564     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
565         antiEarlyWhale(_incomingEthereum)
566         internal
567         returns(uint256)
568     {
569         // data setup
570         address _customerAddress = msg.sender;
571         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
572         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
573         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
574         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
575         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
576         uint256 _fee = _dividends * magnitude;
577  
578         // no point in continuing execution if OP is a poorfag russian hacker
579         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
580         // (or hackers)
581         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
582         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
583         
584         // is the user referred by a masternode?
585         if(
586             // is this a referred purchase?
587             _referredBy != 0x0000000000000000000000000000000000000000 &&
588 
589             // no cheating!
590             _referredBy != _customerAddress &&
591             
592             // does the referrer have at least X whole tokens?
593             // i.e is the referrer a godly chad masternode
594             tokenBalanceLedger_[_referredBy] >= stakingRequirement
595         ){
596             // wealth redistribution
597             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
598         } else {
599             // no ref purchase
600             // add the referral bonus back to the global dividends cake
601             _dividends = SafeMath.add(_dividends, _referralBonus);
602             _fee = _dividends * magnitude;
603         }
604         
605         // we can't give people infinite ethereum
606         if(tokenSupply_ > 0){
607             
608             // add tokens to the pool
609             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
610  
611             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
612             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
613             
614             // calculate the amount of tokens the customer receives over his purchase 
615             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
616         
617         } else {
618             // add tokens to the pool
619             tokenSupply_ = _amountOfTokens;
620         }
621         
622         // update circulating supply & the ledger address for the customer
623         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
624         
625         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
626         //really i know you think you do but you don't
627         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
628         payoutsTo_[_customerAddress] += _updatedPayouts;
629         
630         // fire event
631         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
632         
633         return _amountOfTokens;
634     }
635 
636     /**
637      * Calculate Token price based on an amount of incoming ethereum
638      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
639      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
640      */
641     function ethereumToTokens_(uint256 _ethereum)
642         internal
643         view
644         returns(uint256)
645     {
646         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
647         uint256 _tokensReceived = 
648          (
649             (
650                 // underflow attempts BTFO
651                 SafeMath.sub(
652                     (sqrt
653                         (
654                             (_tokenPriceInitial**2)
655                             +
656                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
657                             +
658                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
659                             +
660                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
661                         )
662                     ), _tokenPriceInitial
663                 )
664             )/(tokenPriceIncremental_)
665         )-(tokenSupply_)
666         ;
667   
668         return _tokensReceived;
669     }
670     
671     /**
672      * Calculate token sell value.
673      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
674      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
675      */
676      function tokensToEthereum_(uint256 _tokens)
677         internal
678         view
679         returns(uint256)
680     {
681 
682         uint256 tokens_ = (_tokens + 1e18);
683         uint256 _tokenSupply = (tokenSupply_ + 1e18);
684         uint256 _etherReceived =
685         (
686             // underflow attempts BTFO
687             SafeMath.sub(
688                 (
689                     (
690                         (
691                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
692                         )-tokenPriceIncremental_
693                     )*(tokens_ - 1e18)
694                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
695             )
696         /1e18);
697         return _etherReceived;
698     }
699     
700     
701     //This is where all your gas goes, sorry
702     //Not sorry, you probably only paid 1 gwei
703     function sqrt(uint x) internal pure returns (uint y) {
704         uint z = (x + 1) / 2;
705         y = x;
706         while (z < y) {
707             y = z;
708             z = (x / z + z) / 2;
709         }
710     }
711 }
712 
713 /**
714  * @title SafeMath
715  * @dev Math operations with safety checks that throw on error
716  */
717 library SafeMath {
718 
719     /**
720     * @dev Multiplies two numbers, throws on overflow.
721     */
722     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
723         if (a == 0) {
724             return 0;
725         }
726         uint256 c = a * b;
727         assert(c / a == b);
728         return c;
729     }
730 
731     /**
732     * @dev Integer division of two numbers, truncating the quotient.
733     */
734     function div(uint256 a, uint256 b) internal pure returns (uint256) {
735         // assert(b > 0); // Solidity automatically throws when dividing by 0
736         uint256 c = a / b;
737         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
738         return c;
739     }
740 
741     /**
742     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
743     */
744     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
745         assert(b <= a);
746         return a - b;
747     }
748 
749     /**
750     * @dev Adds two numbers, throws on overflow.
751     */
752     function add(uint256 a, uint256 b) internal pure returns (uint256) {
753         uint256 c = a + b;
754         assert(c >= a);
755         return c;
756     }
757 }