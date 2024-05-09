1 pragma solidity ^0.4.20;
2 
3 /*
4 * Team JUST presents..
5 * ===================================*
6 *  _____   ____    _    _    ____    *
7 * |  ___/ / __ \  / \  / \  / __ \   *
8 * | |___ | |  | |/   \/   \| |  | |  *
9 * |  __/ | |  | || |\  /| || |  | |  *
10 * | |    | |__| || | \/ | || |__| |  *
11 * |_|     \____/ /_|    |_\ \____/   *
12 * ===================================*
13 *          _______  _____ 
14 *          \____  / |___ \ 
15 *              / /  ||  \ |
16 *              \ \  ||  | |
17 *         _____/  / ||__/ |
18 *         \______/  |____/
19 * 
20 * The Final Solution To The Pyramids Ecosystem
21 *
22 *>20% dividend fee
23 *>No administrators
24 *>No ambassadors
25 *
26 * -> What?
27 * The original autonomous pyramid, improved:
28 * [x] More stable than ever, having withstood severe testnet abuse and attack attempts from our community!.
29 * [x] Audited, tested, and approved by known community security specialists such as tocsick and Arc.
30 * [X] New functionality; you can now perform partial sell orders. If you succumb to weak hands, you don't have to dump all of your bags!
31 * [x] New functionality; you can now transfer tokens between wallets. Trading is now possible from within the contract!
32 * [x] New Feature: PoS Masternodes! The first implementation of Ethereum Staking in the world! Vitalik is mad.
33 * [x] Masternodes: Holding 100 PoWH3D Tokens allow you to generate a Masternode link, Masternode links are used as unique entry points to the contract!
34 * [x] Masternodes: All players who enter the contract through your Masternode have 30% of their 10% dividends fee rerouted from the master-node, to the node-master!
35 *
36 * -> What about the last projects?
37 * Every programming member of the old dev team has been fired and/or killed by 232.
38 * The new dev team consists of seasoned, professional developers and has been audited by veteran solidity experts.
39 * Additionally, two independent testnet iterations have been used by hundreds of people; not a single point of failure was found.
40 * P3D has like 6k ethereum inside. Why would you get in that late...
41 * 
42 * -> Who worked on this project?
43 * - PonziBot (math/memes/main site/master)
44 * - Mantso (lead solidity dev/lead web3 dev)
45 * - swagg (concept design/feedback/management)
46 * - Anonymous#1 (main site/web3/test cases)
47 * - Anonymous#2 (math formulae/whitepaper)
48 *
49 * -> Who has audited & approved the projected:
50 * - Arc
51 * - tocisck
52 * - sumpunk
53 */
54 
55 contract Fomo3D {
56     /*=================================
57     =            MODIFIERS            =
58     =================================*/
59     // only people with tokens
60     modifier onlyBagholders() {
61         require(myTokens() > 0);
62         _;
63     }
64     
65     // only people with profits
66     modifier onlyStronghands() {
67         require(myDividends(true) > 0);
68         _;
69     }
70     
71     // administrators can:
72     // -> change the name of the contract
73     // -> change the name of the token
74     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
75     // they CANNOT:
76     // -> take funds
77     // -> disable withdrawals
78     // -> kill the contract
79     // -> change the price of tokens
80     modifier onlyAdministrator(){
81         address _customerAddress = msg.sender;
82         require(administrators[keccak256(_customerAddress)]);
83         _;
84     }
85     
86     
87     // ensures that the first tokens in the contract will be equally distributed
88     // meaning, no divine dump will be ever possible
89     // result: healthy longevity.
90     modifier antiEarlyWhale(uint256 _amountOfEthereum){
91         address _customerAddress = msg.sender;
92         
93         // are we still in the vulnerable phase?
94         // if so, enact anti early whale protocol 
95         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
96             require(
97                 // is the customer in the ambassador list?
98                 ambassadors_[_customerAddress] == true &&
99                 
100                 // does the customer purchase exceed the max ambassador quota?
101                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
102                 
103             );
104             
105             // updated the accumulated quota    
106             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
107         
108             // execute
109             _;
110         } else {
111             // in case the ether count drops low, the ambassador phase won't reinitiate
112             onlyAmbassadors = false;
113             _;    
114         }
115         
116     }
117     
118     
119     /*==============================
120     =            EVENTS            =
121     ==============================*/
122     event onTokenPurchase(
123         address indexed customerAddress,
124         uint256 incomingEthereum,
125         uint256 tokensMinted,
126         address indexed referredBy
127     );
128     
129     event onTokenSell(
130         address indexed customerAddress,
131         uint256 tokensBurned,
132         uint256 ethereumEarned
133     );
134     
135     event onReinvestment(
136         address indexed customerAddress,
137         uint256 ethereumReinvested,
138         uint256 tokensMinted
139     );
140     
141     event onWithdraw(
142         address indexed customerAddress,
143         uint256 ethereumWithdrawn
144     );
145     
146     // ERC20
147     event Transfer(
148         address indexed from,
149         address indexed to,
150         uint256 tokens
151     );
152     
153     
154     /*=====================================
155     =            CONFIGURABLES            =
156     =====================================*/
157     string public name = "FOMO3D";
158     string public symbol = "F3D";
159     uint8 constant public decimals = 18;
160     uint8 constant internal dividendFee_ = 5;
161     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
162     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
163     uint256 constant internal magnitude = 2**64;
164     
165     // proof of stake (defaults at 100 tokens)
166     uint256 public stakingRequirement = 100e18;
167     
168     // ambassador program
169     mapping(address => bool) internal ambassadors_;
170     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
171     uint256 constant internal ambassadorQuota_ = 20 ether;
172     
173     
174     
175    /*================================
176     =            DATASETS            =
177     ================================*/
178     // amount of shares for each address (scaled number)
179     mapping(address => uint256) internal tokenBalanceLedger_;
180     mapping(address => uint256) internal referralBalance_;
181     mapping(address => int256) internal payoutsTo_;
182     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
183     uint256 internal tokenSupply_ = 0;
184     uint256 internal profitPerShare_;
185     
186     // administrator list (see above on what they can do)
187     mapping(bytes32 => bool) public administrators;
188     
189     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
190     bool public onlyAmbassadors = false; //set to false, no ambassadors
191     
192 
193 
194     /*=======================================
195     =            PUBLIC FUNCTIONS            =
196     =======================================*/
197     /*
198     * -- APPLICATION ENTRY POINTS --  
199     */
200     function Hourglass()
201         public
202     {
203         // add administrators here
204        
205         // add the ambassadors here.
206         
207     }
208     
209      
210     /**
211      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
212      */
213     function buy(address _referredBy)
214         public
215         payable
216         returns(uint256)
217     {
218         purchaseTokens(msg.value, _referredBy);
219     }
220     
221     /**
222      * Fallback function to handle ethereum that was send straight to the contract
223      * Unfortunately we cannot use a referral address this way.
224      */
225     function()
226         payable
227         public
228     {
229         purchaseTokens(msg.value, 0x0);
230     }
231     
232     /**
233      * Converts all of caller's dividends to tokens.
234      */
235     function reinvest()
236         onlyStronghands()
237         public
238     {
239         // fetch dividends
240         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
241         
242         // pay out the dividends virtually
243         address _customerAddress = msg.sender;
244         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
245         
246         // retrieve ref. bonus
247         _dividends += referralBalance_[_customerAddress];
248         referralBalance_[_customerAddress] = 0;
249         
250         // dispatch a buy order with the virtualized "withdrawn dividends"
251         uint256 _tokens = purchaseTokens(_dividends, 0x0);
252         
253         // fire event
254         onReinvestment(_customerAddress, _dividends, _tokens);
255     }
256     
257     /**
258      * Alias of sell() and withdraw().
259      */
260     function exit()
261         public
262     {
263         // get token count for caller & sell them all
264         address _customerAddress = msg.sender;
265         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
266         if(_tokens > 0) sell(_tokens);
267         
268         // lambo delivery service
269         withdraw();
270     }
271 
272     /**
273      * Withdraws all of the callers earnings.
274      */
275     function withdraw()
276         onlyStronghands()
277         public
278     {
279         // setup data
280         address _customerAddress = msg.sender;
281         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
282         
283         // update dividend tracker
284         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
285         
286         // add ref. bonus
287         _dividends += referralBalance_[_customerAddress];
288         referralBalance_[_customerAddress] = 0;
289         
290         // lambo delivery service
291         _customerAddress.transfer(_dividends);
292         
293         // fire event
294         onWithdraw(_customerAddress, _dividends);
295     }
296     
297     /**
298      * Liquifies tokens to ethereum.
299      */
300     function sell(uint256 _amountOfTokens)
301         onlyBagholders()
302         public
303     {
304         // setup data
305         address _customerAddress = msg.sender;
306         // russian hackers BTFO
307         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
308         uint256 _tokens = _amountOfTokens;
309         uint256 _ethereum = tokensToEthereum_(_tokens);
310         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
311         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
312         
313         // burn the sold tokens
314         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
315         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
316         
317         // update dividends tracker
318         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
319         payoutsTo_[_customerAddress] -= _updatedPayouts;       
320         
321         // dividing by zero is a bad idea
322         if (tokenSupply_ > 0) {
323             // update the amount of dividends per token
324             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
325         }
326         
327         // fire event
328         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
329     }
330     
331     
332     /**
333      * Transfer tokens from the caller to a new holder.
334      * Remember, there's a 10% fee here as well.
335      */
336     function transfer(address _toAddress, uint256 _amountOfTokens)
337         onlyBagholders()
338         public
339         returns(bool)
340     {
341         // setup
342         address _customerAddress = msg.sender;
343         
344         // make sure we have the requested tokens
345         // also disables transfers until ambassador phase is over
346         // ( we dont want whale premines )
347         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
348         
349         // withdraw all outstanding dividends first
350         if(myDividends(true) > 0) withdraw();
351         
352         // liquify 10% of the tokens that are transfered
353         // these are dispersed to shareholders
354         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
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
518             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
519             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
520             return _taxedEthereum;
521         }
522     }
523     
524     /**
525      * Return the sell price of 1 individual token.
526      */
527     function buyPrice() 
528         public 
529         view 
530         returns(uint256)
531     {
532         // our calculation relies on the token supply, so we need supply. Doh.
533         if(tokenSupply_ == 0){
534             return tokenPriceInitial_ + tokenPriceIncremental_;
535         } else {
536             uint256 _ethereum = tokensToEthereum_(1e18);
537             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
538             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
539             return _taxedEthereum;
540         }
541     }
542     
543     /**
544      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
545      */
546     function calculateTokensReceived(uint256 _ethereumToSpend) 
547         public 
548         view 
549         returns(uint256)
550     {
551         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
552         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
553         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
554         
555         return _amountOfTokens;
556     }
557     
558     /**
559      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
560      */
561     function calculateEthereumReceived(uint256 _tokensToSell) 
562         public 
563         view 
564         returns(uint256)
565     {
566         require(_tokensToSell <= tokenSupply_);
567         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
568         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
569         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
570         return _taxedEthereum;
571     }
572     
573     
574     /*==========================================
575     =            INTERNAL FUNCTIONS            =
576     ==========================================*/
577     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
578         antiEarlyWhale(_incomingEthereum)
579         internal
580         returns(uint256)
581     {
582         // data setup
583         address _customerAddress = msg.sender;
584         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
585         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
586         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
587         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
588         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
589         uint256 _fee = _dividends * magnitude;
590  
591         // no point in continuing execution if OP is a poorfag russian hacker
592         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
593         // (or hackers)
594         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
595         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
596         
597         // is the user referred by a masternode?
598         if(
599             // is this a referred purchase?
600             _referredBy != 0x0000000000000000000000000000000000000000 &&
601 
602             // no cheating!
603             _referredBy != _customerAddress &&
604             
605             // does the referrer have at least X whole tokens?
606             // i.e is the referrer a godly chad masternode
607             tokenBalanceLedger_[_referredBy] >= stakingRequirement
608         ){
609             // wealth redistribution
610             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
611         } else {
612             // no ref purchase
613             // add the referral bonus back to the global dividends cake
614             _dividends = SafeMath.add(_dividends, _referralBonus);
615             _fee = _dividends * magnitude;
616         }
617         
618         // we can't give people infinite ethereum
619         if(tokenSupply_ > 0){
620             
621             // add tokens to the pool
622             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
623  
624             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
625             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
626             
627             // calculate the amount of tokens the customer receives over his purchase 
628             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
629         
630         } else {
631             // add tokens to the pool
632             tokenSupply_ = _amountOfTokens;
633         }
634         
635         // update circulating supply & the ledger address for the customer
636         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
637         
638         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
639         //really i know you think you do but you don't
640         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
641         payoutsTo_[_customerAddress] += _updatedPayouts;
642         
643         // fire event
644         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
645         
646         return _amountOfTokens;
647     }
648 
649     /**
650      * Calculate Token price based on an amount of incoming ethereum
651      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
652      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
653      */
654     function ethereumToTokens_(uint256 _ethereum)
655         internal
656         view
657         returns(uint256)
658     {
659         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
660         uint256 _tokensReceived = 
661          (
662             (
663                 // underflow attempts BTFO
664                 SafeMath.sub(
665                     (sqrt
666                         (
667                             (_tokenPriceInitial**2)
668                             +
669                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
670                             +
671                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
672                             +
673                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
674                         )
675                     ), _tokenPriceInitial
676                 )
677             )/(tokenPriceIncremental_)
678         )-(tokenSupply_)
679         ;
680   
681         return _tokensReceived;
682     }
683     
684     /**
685      * Calculate token sell value.
686      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
687      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
688      */
689      function tokensToEthereum_(uint256 _tokens)
690         internal
691         view
692         returns(uint256)
693     {
694 
695         uint256 tokens_ = (_tokens + 1e18);
696         uint256 _tokenSupply = (tokenSupply_ + 1e18);
697         uint256 _etherReceived =
698         (
699             // underflow attempts BTFO
700             SafeMath.sub(
701                 (
702                     (
703                         (
704                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
705                         )-tokenPriceIncremental_
706                     )*(tokens_ - 1e18)
707                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
708             )
709         /1e18);
710         return _etherReceived;
711     }
712     
713     
714     //This is where all your gas goes, sorry
715     //Not sorry, you probably only paid 1 gwei
716     function sqrt(uint x) internal pure returns (uint y) {
717         uint z = (x + 1) / 2;
718         y = x;
719         while (z < y) {
720             y = z;
721             z = (x / z + z) / 2;
722         }
723     }
724 }
725 
726 /**
727  * @title SafeMath
728  * @dev Math operations with safety checks that throw on error
729  */
730 library SafeMath {
731 
732     /**
733     * @dev Multiplies two numbers, throws on overflow.
734     */
735     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
736         if (a == 0) {
737             return 0;
738         }
739         uint256 c = a * b;
740         assert(c / a == b);
741         return c;
742     }
743 
744     /**
745     * @dev Integer division of two numbers, truncating the quotient.
746     */
747     function div(uint256 a, uint256 b) internal pure returns (uint256) {
748         // assert(b > 0); // Solidity automatically throws when dividing by 0
749         uint256 c = a / b;
750         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
751         return c;
752     }
753 
754     /**
755     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
756     */
757     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
758         assert(b <= a);
759         return a - b;
760     }
761 
762     /**
763     * @dev Adds two numbers, throws on overflow.
764     */
765     function add(uint256 a, uint256 b) internal pure returns (uint256) {
766         uint256 c = a + b;
767         assert(c >= a);
768         return c;
769     }
770 }