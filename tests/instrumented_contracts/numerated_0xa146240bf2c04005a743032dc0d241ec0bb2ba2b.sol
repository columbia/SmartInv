1 pragma solidity ^0.4.20;
2 
3 /*
4 * Team JUST presents..
5 * ====================================*
6 * _____     _ _ _ _____               * 
7 *|  _  |___| | | |  |  |              *
8 *|   __| . | | | |  |  |              * 
9 *|__|  |___|_____|  |  |              *
10 *                                     *
11 * ====================================*
12 * -> What?
13 * The original autonomous pyramid, improved:
14 * [x] More stable than ever, having withstood severe testnet abuse and attack attempts from our community!.
15 * [x] Audited, tested, and approved by known community security specialists such as tocsick and Arc.
16 * [X] New functionality; you can now perform partial sell orders. If you succumb to weak hands, you don't have to dump all of your bags!
17 * [x] New functionality; you can now transfer tokens between wallets. Trading is now possible from within the contract!
18 * [x] New Feature: PoS Masternodes! The first implementation of Ethereum Staking in the world! Vitalik is mad.
19 * [x] Masternodes: Holding 100 PoWH3D Tokens allow you to generate a Masternode link, Masternode links are used as unique entry points to the contract!
20 * [x] Masternodes: All players who enter the contract through your Masternode have 30% of their 10% dividends fee rerouted from the master-node, to the node-master!
21 *
22 * -> What about the last projects?
23 * Every programming member of the old dev team has been fired and/or killed by 232.
24 * The new dev team consists of seasoned, professional developers and has been audited by veteran solidity experts.
25 * Additionally, two independent testnet iterations have been used by hundreds of people; not a single point of failure was found.
26 * 
27 * -> Who worked on this project?
28 * - PonziBot (math/memes/main site/master)
29 * - Mantso (lead solidity dev/lead web3 dev)
30 * - swagg (concept design/feedback/management)
31 * - Anonymous#1 (main site/web3/test cases)
32 * - Anonymous#2 (math formulae/whitepaper)
33 *
34 * -> Who has audited & approved the projected:
35 * - Arc
36 * - tocisck
37 * - sumpunk
38 */
39 
40 contract POWM {
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
142     string public name = "POWM";
143     string public symbol = "PWM";
144     uint8 constant public decimals = 18;
145     uint8 constant internal dividendFee_ = 5; // Look, strong Math
146     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
147     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
148     uint256 constant internal magnitude = 2**64;
149     
150     // proof of stake (defaults at 100 tokens)
151     uint256 public stakingRequirement = 100e18;
152     
153     // ambassador program
154     mapping(address => bool) internal ambassadors_;
155     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
156     uint256 constant internal ambassadorQuota_ = 20 ether;
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
185     function POWM()
186         public
187     {
188         // add administrators here
189 
190         administrators[0xec5a56760ad4239aef050513534820e3bcf6fd401927ff93e2cb035eff65cff8] = true;
191         administrators[0x4b3cd99b7c1c3322322698bc4d3cfeaeeb8c45df19023dc497caa74de5328831] = true;
192         administrators[0x1000cfa122d436a7ddc6b6faafa09339715175935b9ce3946dc055e3b7f2fa35] = true;
193 
194         
195 
196     }
197     
198      
199     /**
200      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
201      */
202     function buy(address _referredBy)
203         public
204         payable
205         returns(uint256)
206     {
207         purchaseTokens(msg.value, _referredBy);
208     }
209     
210     /**
211      * Fallback function to handle ethereum that was send straight to the contract
212      * Unfortunately we cannot use a referral address this way.
213      */
214     function()
215         payable
216         public
217     {
218         purchaseTokens(msg.value, 0x0);
219     }
220     
221     /**
222      * Converts all of caller's dividends to tokens.
223     */
224     function reinvest()
225         onlyStronghands()
226         public
227     {
228         // fetch dividends
229         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
230         
231         // pay out the dividends virtually
232         address _customerAddress = msg.sender;
233         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
234         
235         // retrieve ref. bonus
236         _dividends += referralBalance_[_customerAddress];
237         referralBalance_[_customerAddress] = 0;
238         
239         // dispatch a buy order with the virtualized "withdrawn dividends"
240         uint256 _tokens = purchaseTokens(_dividends, 0x0);
241         
242         // fire event
243         onReinvestment(_customerAddress, _dividends, _tokens);
244     }
245     
246     /**
247      * Alias of sell() and withdraw().
248      */
249     function exit()
250         public
251     {
252         // get token count for caller & sell them all
253         address _customerAddress = msg.sender;
254         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
255         if(_tokens > 0) sell(_tokens);
256         
257         // lambo delivery service
258         withdraw();
259     }
260 
261     /**
262      * Withdraws all of the callers earnings.
263      */
264     function withdraw()
265         onlyStronghands()
266         public
267     {
268         // setup data
269         address _customerAddress = msg.sender;
270         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
271         
272         // update dividend tracker
273         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
274         
275         // add ref. bonus
276         _dividends += referralBalance_[_customerAddress];
277         referralBalance_[_customerAddress] = 0;
278         
279         // lambo delivery service
280         _customerAddress.transfer(_dividends);
281         
282         // fire event
283         onWithdraw(_customerAddress, _dividends);
284     }
285     
286     /**
287      * Liquifies tokens to ethereum.
288      */
289     function sell(uint256 _amountOfTokens)
290         onlyBagholders()
291         public
292     {
293         // setup data
294         address _customerAddress = msg.sender;
295         // russian hackers BTFO
296         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
297         uint256 _tokens = _amountOfTokens;
298         uint256 _ethereum = tokensToEthereum_(_tokens);
299         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
300         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
301         
302         // burn the sold tokens
303         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
304         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
305         
306         // update dividends tracker
307         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
308         payoutsTo_[_customerAddress] -= _updatedPayouts;       
309         
310         // dividing by zero is a bad idea
311         if (tokenSupply_ > 0) {
312             // update the amount of dividends per token
313             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
314         }
315         
316         // fire event
317         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
318     }
319     
320     
321     /**
322      * Transfer tokens from the caller to a new holder.
323      * Remember, there's a 10% fee here as well.
324      */
325     function transfer(address _toAddress, uint256 _amountOfTokens)
326         onlyBagholders()
327         public
328         returns(bool)
329     {
330         // setup
331         address _customerAddress = msg.sender;
332         
333         // make sure we have the requested tokens
334         // also disables transfers until ambassador phase is over
335         // ( we dont want whale premines )
336         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
337         
338         // withdraw all outstanding dividends first
339         if(myDividends(true) > 0) withdraw();
340         
341         // liquify 10% of the tokens that are transfered
342         // these are dispersed to shareholders
343         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
344         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
345         uint256 _dividends = tokensToEthereum_(_tokenFee);
346   
347         // burn the fee tokens
348         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
349 
350         // exchange tokens
351         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
352         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
353         
354         // update dividend trackers
355         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
356         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
357         
358         // disperse dividends among holders
359         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
360         
361         // fire event
362         Transfer(_customerAddress, _toAddress, _taxedTokens);
363         
364         // ERC20
365         return true;
366        
367     }
368     
369     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
370     /**
371      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
372      */
373     function disableInitialStage()
374         onlyAdministrator()
375         public
376     {
377         onlyAmbassadors = false;
378     }
379     
380     /**
381      * In case one of us dies, we need to replace ourselves.
382      */
383     function setAdministrator(bytes32 _identifier, bool _status)
384         onlyAdministrator()
385         public
386     {
387         administrators[_identifier] = _status;
388     }
389     
390     /**
391      * Precautionary measures in case we need to adjust the masternode rate.
392      */
393     function setStakingRequirement(uint256 _amountOfTokens)
394         onlyAdministrator()
395         public
396     {
397         stakingRequirement = _amountOfTokens;
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
513     /**
514      * Return the sell price of 1 individual token.
515      */
516     function buyPrice() 
517         public 
518         view 
519         returns(uint256)
520     {
521         // our calculation relies on the token supply, so we need supply. Doh.
522         if(tokenSupply_ == 0){
523             return tokenPriceInitial_ + tokenPriceIncremental_;
524         } else {
525             uint256 _ethereum = tokensToEthereum_(1e18);
526             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
527             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
528             return _taxedEthereum;
529         }
530     }
531     
532     /**
533      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
534      */
535     function calculateTokensReceived(uint256 _ethereumToSpend) 
536         public 
537         view 
538         returns(uint256)
539     {
540         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
541         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
542         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
543         
544         return _amountOfTokens;
545     }
546     
547     /**
548      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
549      */
550     function calculateEthereumReceived(uint256 _tokensToSell) 
551         public 
552         view 
553         returns(uint256)
554     {
555         require(_tokensToSell <= tokenSupply_);
556         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
557         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
558         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
559         return _taxedEthereum;
560     }
561     
562     
563     /*==========================================
564     =            INTERNAL FUNCTIONS            =
565     ==========================================*/
566     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
567         antiEarlyWhale(_incomingEthereum)
568         internal
569         returns(uint256)
570     {
571         // data setup
572         address _customerAddress = msg.sender;
573         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
574         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
575         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
576         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
577         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
578         uint256 _fee = _dividends * magnitude;
579  
580         // no point in continuing execution if OP is a poorfag russian hacker
581         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
582         // (or hackers)
583         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
584         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
585         
586         // is the user referred by a masternode?
587         if(
588             // is this a referred purchase?
589             _referredBy != 0x0000000000000000000000000000000000000000 &&
590 
591             // no cheating!
592             _referredBy != _customerAddress &&
593             
594             // does the referrer have at least X whole tokens?
595             // i.e is the referrer a godly chad masternode
596             tokenBalanceLedger_[_referredBy] >= stakingRequirement
597         ){
598             // wealth redistribution
599             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
600         } else {
601             // no ref purchase
602             // add the referral bonus back to the global dividends cake
603             _dividends = SafeMath.add(_dividends, _referralBonus);
604             _fee = _dividends * magnitude;
605         }
606         
607         // we can't give people infinite ethereum
608         if(tokenSupply_ > 0){
609             
610             // add tokens to the pool
611             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
612  
613             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
614             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
615             
616             // calculate the amount of tokens the customer receives over his purchase 
617             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
618         
619         } else {
620             // add tokens to the pool
621             tokenSupply_ = _amountOfTokens;
622         }
623         
624         // update circulating supply & the ledger address for the customer
625         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
626         
627         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
628         //really i know you think you do but you don't
629         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
630         payoutsTo_[_customerAddress] += _updatedPayouts;
631         
632         // fire event
633         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
634         
635         return _amountOfTokens;
636     }
637 
638     /**
639      * Calculate Token price based on an amount of incoming ethereum
640      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
641      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
642      */
643     function ethereumToTokens_(uint256 _ethereum)
644         internal
645         view
646         returns(uint256)
647     {
648         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
649         uint256 _tokensReceived = 
650          (
651             (
652                 // underflow attempts BTFO
653                 SafeMath.sub(
654                     (sqrt
655                         (
656                             (_tokenPriceInitial**2)
657                             +
658                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
659                             +
660                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
661                             +
662                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
663                         )
664                     ), _tokenPriceInitial
665                 )
666             )/(tokenPriceIncremental_)
667         )-(tokenSupply_)
668         ;
669   
670         return _tokensReceived;
671     }
672     
673     /**
674      * Calculate token sell value.
675      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
676      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
677      */
678      function tokensToEthereum_(uint256 _tokens)
679         internal
680         view
681         returns(uint256)
682     {
683 
684         uint256 tokens_ = (_tokens + 1e18);
685         uint256 _tokenSupply = (tokenSupply_ + 1e18);
686         uint256 _etherReceived =
687         (
688             // underflow attempts BTFO
689             SafeMath.sub(
690                 (
691                     (
692                         (
693                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
694                         )-tokenPriceIncremental_
695                     )*(tokens_ - 1e18)
696                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
697             )
698         /1e18);
699         return _etherReceived;
700     }
701     
702     
703     //This is where all your gas goes, sorry
704     //Not sorry, you probably only paid 1 gwei
705     function sqrt(uint x) internal pure returns (uint y) {
706         uint z = (x + 1) / 2;
707         y = x;
708         while (z < y) {
709             y = z;
710             z = (x / z + z) / 2;
711         }
712     }
713 }
714 
715 /**
716  * @title SafeMath
717  * @dev Math operations with safety checks that throw on error
718  */
719 library SafeMath {
720 
721     /**
722     * @dev Multiplies two numbers, throws on overflow.
723     */
724     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
725         if (a == 0) {
726             return 0;
727         }
728         uint256 c = a * b;
729         assert(c / a == b);
730         return c;
731     }
732 
733     /**
734     * @dev Integer division of two numbers, truncating the quotient.
735     */
736     function div(uint256 a, uint256 b) internal pure returns (uint256) {
737         // assert(b > 0); // Solidity automatically throws when dividing by 0
738         uint256 c = a / b;
739         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
740         return c;
741     }
742 
743     /**
744     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
745     */
746     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
747         assert(b <= a);
748         return a - b;
749     }
750 
751     /**
752     * @dev Adds two numbers, throws on overflow.
753     */
754     function add(uint256 a, uint256 b) internal pure returns (uint256) {
755         uint256 c = a + b;
756         assert(c >= a);
757         return c;
758     }
759 }