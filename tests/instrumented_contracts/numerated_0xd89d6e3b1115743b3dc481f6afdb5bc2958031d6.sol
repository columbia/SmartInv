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
142     string public name = "POWM2";
143     string public symbol = "PWM2";
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
175     bool public onlyAmbassadors = false;
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
189         administrators[0x393407a693b01bcfad4ec29ec69180381b5021f6c4723a6dca771ce38a88a25d] = true;
190 
191         
192 
193     }
194     
195      
196     /**
197      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
198      */
199     function buy(address _referredBy)
200         public
201         payable
202         returns(uint256)
203     {
204         purchaseTokens(msg.value, _referredBy);
205     }
206     
207     /**
208      * Fallback function to handle ethereum that was send straight to the contract
209      * Unfortunately we cannot use a referral address this way.
210      */
211     function()
212         payable
213         public
214     {
215         purchaseTokens(msg.value, 0x0);
216     }
217     
218     /**
219      * Converts all of caller's dividends to tokens.
220     */
221     function reinvest()
222         onlyStronghands()
223         public
224     {
225         // fetch dividends
226         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
227         
228         // pay out the dividends virtually
229         address _customerAddress = msg.sender;
230         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
231         
232         // retrieve ref. bonus
233         _dividends += referralBalance_[_customerAddress];
234         referralBalance_[_customerAddress] = 0;
235         
236         // dispatch a buy order with the virtualized "withdrawn dividends"
237         uint256 _tokens = purchaseTokens(_dividends, 0x0);
238         
239         // fire event
240         onReinvestment(_customerAddress, _dividends, _tokens);
241     }
242     
243     /**
244      * Alias of sell() and withdraw().
245      */
246     function exit()
247         public
248     {
249         // get token count for caller & sell them all
250         address _customerAddress = msg.sender;
251         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
252         if(_tokens > 0) sell(_tokens);
253         
254         // lambo delivery service
255         withdraw();
256     }
257 
258     /**
259      * Withdraws all of the callers earnings.
260      */
261     function withdraw()
262         onlyStronghands()
263         public
264     {
265         // setup data
266         address _customerAddress = msg.sender;
267         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
268         
269         // update dividend tracker
270         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
271         
272         // add ref. bonus
273         _dividends += referralBalance_[_customerAddress];
274         referralBalance_[_customerAddress] = 0;
275         
276         // lambo delivery service
277         _customerAddress.transfer(_dividends);
278         
279         // fire event
280         onWithdraw(_customerAddress, _dividends);
281     }
282     
283     /**
284      * Liquifies tokens to ethereum.
285      */
286     function sell(uint256 _amountOfTokens)
287         onlyBagholders()
288         public
289     {
290         // setup data
291         address _customerAddress = msg.sender;
292         // russian hackers BTFO
293         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
294         uint256 _tokens = _amountOfTokens;
295         uint256 _ethereum = tokensToEthereum_(_tokens);
296         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
297         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
298         
299         // burn the sold tokens
300         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
301         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
302         
303         // update dividends tracker
304         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
305         payoutsTo_[_customerAddress] -= _updatedPayouts;       
306         
307         // dividing by zero is a bad idea
308         if (tokenSupply_ > 0) {
309             // update the amount of dividends per token
310             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
311         }
312         
313         // fire event
314         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
315     }
316     
317     
318     /**
319      * Transfer tokens from the caller to a new holder.
320      * Remember, there's a 10% fee here as well.
321      */
322     function transfer(address _toAddress, uint256 _amountOfTokens)
323         onlyBagholders()
324         public
325         returns(bool)
326     {
327         // setup
328         address _customerAddress = msg.sender;
329         
330         // make sure we have the requested tokens
331         // also disables transfers until ambassador phase is over
332         // ( we dont want whale premines )
333         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
334         
335         // withdraw all outstanding dividends first
336         if(myDividends(true) > 0) withdraw();
337         
338         // liquify 10% of the tokens that are transfered
339         // these are dispersed to shareholders
340         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
341         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
342         uint256 _dividends = tokensToEthereum_(_tokenFee);
343   
344         // burn the fee tokens
345         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
346 
347         // exchange tokens
348         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
349         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
350         
351         // update dividend trackers
352         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
353         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
354         
355         // disperse dividends among holders
356         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
357         
358         // fire event
359         Transfer(_customerAddress, _toAddress, _taxedTokens);
360         
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
377     /**
378      * In case one of us dies, we need to replace ourselves.
379      */
380     function setAdministrator(bytes32 _identifier, bool _status)
381         onlyAdministrator()
382         public
383     {
384         administrators[_identifier] = _status;
385     }
386     
387     /**
388      * Precautionary measures in case we need to adjust the masternode rate.
389      */
390     function setStakingRequirement(uint256 _amountOfTokens)
391         onlyAdministrator()
392         public
393     {
394         stakingRequirement = _amountOfTokens;
395     }
396     
397     /**
398      * If we want to rebrand, we can.
399      */
400     function setName(string _name)
401         onlyAdministrator()
402         public
403     {
404         name = _name;
405     }
406     
407     /**
408      * If we want to rebrand, we can.
409      */
410     function setSymbol(string _symbol)
411         onlyAdministrator()
412         public
413     {
414         symbol = _symbol;
415     }
416 
417     
418     /*----------  HELPERS AND CALCULATORS  ----------*/
419     /**
420      * Method to view the current Ethereum stored in the contract
421      * Example: totalEthereumBalance()
422      */
423     function totalEthereumBalance()
424         public
425         view
426         returns(uint)
427     {
428         return this.balance;
429     }
430     
431     /**
432      * Retrieve the total token supply.
433      */
434     function totalSupply()
435         public
436         view
437         returns(uint256)
438     {
439         return tokenSupply_;
440     }
441     
442     /**
443      * Retrieve the tokens owned by the caller.
444      */
445     function myTokens()
446         public
447         view
448         returns(uint256)
449     {
450         address _customerAddress = msg.sender;
451         return balanceOf(_customerAddress);
452     }
453     
454     /**
455      * Retrieve the dividends owned by the caller.
456      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
457      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
458      * But in the internal calculations, we want them separate. 
459      */ 
460     function myDividends(bool _includeReferralBonus) 
461         public 
462         view 
463         returns(uint256)
464     {
465         address _customerAddress = msg.sender;
466         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
467     }
468     
469     /**
470      * Retrieve the token balance of any single address.
471      */
472     function balanceOf(address _customerAddress)
473         view
474         public
475         returns(uint256)
476     {
477         return tokenBalanceLedger_[_customerAddress];
478     }
479     
480     /**
481      * Retrieve the dividend balance of any single address.
482      */
483     function dividendsOf(address _customerAddress)
484         view
485         public
486         returns(uint256)
487     {
488         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
489     }
490     
491     /**
492      * Return the buy price of 1 individual token.
493      */
494     function sellPrice() 
495         public 
496         view 
497         returns(uint256)
498     {
499         // our calculation relies on the token supply, so we need supply. Doh.
500         if(tokenSupply_ == 0){
501             return tokenPriceInitial_ - tokenPriceIncremental_;
502         } else {
503             uint256 _ethereum = tokensToEthereum_(1e18);
504             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
505             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
506             return _taxedEthereum;
507         }
508     }
509     
510     /**
511      * Return the sell price of 1 individual token.
512      */
513     function buyPrice() 
514         public 
515         view 
516         returns(uint256)
517     {
518         // our calculation relies on the token supply, so we need supply. Doh.
519         if(tokenSupply_ == 0){
520             return tokenPriceInitial_ + tokenPriceIncremental_;
521         } else {
522             uint256 _ethereum = tokensToEthereum_(1e18);
523             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
524             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
525             return _taxedEthereum;
526         }
527     }
528     
529     /**
530      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
531      */
532     function calculateTokensReceived(uint256 _ethereumToSpend) 
533         public 
534         view 
535         returns(uint256)
536     {
537         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
538         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
539         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
540         
541         return _amountOfTokens;
542     }
543     
544     /**
545      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
546      */
547     function calculateEthereumReceived(uint256 _tokensToSell) 
548         public 
549         view 
550         returns(uint256)
551     {
552         require(_tokensToSell <= tokenSupply_);
553         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
554         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
555         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
556         return _taxedEthereum;
557     }
558     
559     
560     /*==========================================
561     =            INTERNAL FUNCTIONS            =
562     ==========================================*/
563     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
564         antiEarlyWhale(_incomingEthereum)
565         internal
566         returns(uint256)
567     {
568         // data setup
569         address _customerAddress = msg.sender;
570         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
571         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
572         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
573         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
574         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
575         uint256 _fee = _dividends * magnitude;
576  
577         // no point in continuing execution if OP is a poorfag russian hacker
578         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
579         // (or hackers)
580         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
581         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
582         
583         // is the user referred by a masternode?
584         if(
585             // is this a referred purchase?
586             _referredBy != 0x0000000000000000000000000000000000000000 &&
587 
588             // no cheating!
589             _referredBy != _customerAddress &&
590             
591             // does the referrer have at least X whole tokens?
592             // i.e is the referrer a godly chad masternode
593             tokenBalanceLedger_[_referredBy] >= stakingRequirement
594         ){
595             // wealth redistribution
596             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
597         } else {
598             // no ref purchase
599             // add the referral bonus back to the global dividends cake
600             _dividends = SafeMath.add(_dividends, _referralBonus);
601             _fee = _dividends * magnitude;
602         }
603         
604         // we can't give people infinite ethereum
605         if(tokenSupply_ > 0){
606             
607             // add tokens to the pool
608             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
609  
610             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
611             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
612             
613             // calculate the amount of tokens the customer receives over his purchase 
614             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
615         
616         } else {
617             // add tokens to the pool
618             tokenSupply_ = _amountOfTokens;
619         }
620         
621         // update circulating supply & the ledger address for the customer
622         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
623         
624         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
625         //really i know you think you do but you don't
626         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
627         payoutsTo_[_customerAddress] += _updatedPayouts;
628         
629         // fire event
630         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
631         
632         return _amountOfTokens;
633     }
634 
635     /**
636      * Calculate Token price based on an amount of incoming ethereum
637      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
638      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
639      */
640     function ethereumToTokens_(uint256 _ethereum)
641         internal
642         view
643         returns(uint256)
644     {
645         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
646         uint256 _tokensReceived = 
647          (
648             (
649                 // underflow attempts BTFO
650                 SafeMath.sub(
651                     (sqrt
652                         (
653                             (_tokenPriceInitial**2)
654                             +
655                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
656                             +
657                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
658                             +
659                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
660                         )
661                     ), _tokenPriceInitial
662                 )
663             )/(tokenPriceIncremental_)
664         )-(tokenSupply_)
665         ;
666   
667         return _tokensReceived;
668     }
669     
670     /**
671      * Calculate token sell value.
672      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
673      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
674      */
675      function tokensToEthereum_(uint256 _tokens)
676         internal
677         view
678         returns(uint256)
679     {
680 
681         uint256 tokens_ = (_tokens + 1e18);
682         uint256 _tokenSupply = (tokenSupply_ + 1e18);
683         uint256 _etherReceived =
684         (
685             // underflow attempts BTFO
686             SafeMath.sub(
687                 (
688                     (
689                         (
690                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
691                         )-tokenPriceIncremental_
692                     )*(tokens_ - 1e18)
693                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
694             )
695         /1e18);
696         return _etherReceived;
697     }
698     
699     
700     //This is where all your gas goes, sorry
701     //Not sorry, you probably only paid 1 gwei
702     function sqrt(uint x) internal pure returns (uint y) {
703         uint z = (x + 1) / 2;
704         y = x;
705         while (z < y) {
706             y = z;
707             z = (x / z + z) / 2;
708         }
709     }
710 }
711 
712 /**
713  * @title SafeMath
714  * @dev Math operations with safety checks that throw on error
715  */
716 library SafeMath {
717 
718     /**
719     * @dev Multiplies two numbers, throws on overflow.
720     */
721     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
722         if (a == 0) {
723             return 0;
724         }
725         uint256 c = a * b;
726         assert(c / a == b);
727         return c;
728     }
729 
730     /**
731     * @dev Integer division of two numbers, truncating the quotient.
732     */
733     function div(uint256 a, uint256 b) internal pure returns (uint256) {
734         // assert(b > 0); // Solidity automatically throws when dividing by 0
735         uint256 c = a / b;
736         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
737         return c;
738     }
739 
740     /**
741     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
742     */
743     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
744         assert(b <= a);
745         return a - b;
746     }
747 
748     /**
749     * @dev Adds two numbers, throws on overflow.
750     */
751     function add(uint256 a, uint256 b) internal pure returns (uint256) {
752         uint256 c = a + b;
753         assert(c >= a);
754         return c;
755     }
756 }