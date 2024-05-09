1 /*
2 
3    ____                      ____ _     _         _____                _ 
4   / ___|_ __ ___  ___ _ __  / ___| |__ (_)_ __   |  ___|   _ _ __   __| |
5  | |  _| '__/ _ \/ _ \ '_ \| |   | '_ \| | '_ \  | |_ | | | | '_ \ / _` |
6  | |_| | | |  __/  __/ | | | |___| | | | | |_) | |  _|| |_| | | | | (_| |
7   \____|_|  \___|\___|_| |_|\____|_| |_|_| .__/  |_|   \__,_|_| |_|\__,_|
8                                          |_|                             
9 
10      / \        _
11    , | | ,     / \
12   ((_| |_))  , | | ,
13   `--, ,--` ((_| |_))
14      | |    `--, ,--`
15  ^^^^| |^^^^^^^| |^^^^^^^
16     `"""`      | |
17               `"""`
18               
19 
20 * https://greenchip.fund/
21 * ====================================*
22 *
23 * 25% Dividends:
24 * - Distributed to GREEN tokenholders proportional to the total GREEN circulating supply
25 * 
26 * Real Masternode Referrals:
27 * - Receive 7.5% of the total transaction (30% of the 25% generated dividends)
28 *
29 * The original autonomous pyramid, improved:
30 * - Fully Decentralized Earnings Platform. Transparent, Open source Ethereum code
31 * - More stable than ever, having withstood severe test and mainnet abuse and attack attempts
32 * - Audited, tested, and approved by known community security specialists and veteran solidity experts
33 * - Testnet iterations have been deployed; with not a single point of failure found
34 *
35 * Still, no guarantees are given. 
36 * Please be careful and doublecheck when interacting with the contract
37 * 
38 */
39 
40 pragma solidity ^0.4.20;
41 
42 /*
43 * Main Net Version
44 */
45 
46 contract GreenChipMain {
47     /*=================================
48     =            MODIFIERS            =
49     =================================*/
50     // only people with tokens
51     modifier onlyBagholders() {
52         require(myTokens() > 0);
53         _;
54     }
55     
56     // only people with profits
57     modifier onlyStronghands() {
58         require(myDividends(true) > 0);
59         _;
60     }
61     
62     // administrators can:
63     // -> change the name of the contract
64     // -> change the name of the token
65     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
66     // they CANNOT:
67     // -> take funds
68     // -> disable withdrawals
69     // -> kill the contract
70     // -> change the price of tokens
71     modifier onlyAdministrator(){
72         address _customerAddress = msg.sender;
73         require(administrators[(_customerAddress)]);
74         _;
75     }
76     
77     
78     // ensures that the first tokens in the contract will be equally distributed
79     // meaning, no divine dump will be ever possible
80     // result: healthy longevity.
81     modifier antiEarlyWhale(uint256 _amountOfEthereum){
82         address _customerAddress = msg.sender;
83         
84         // are we still in the vulnerable phase?
85         // if so, enact anti early whale protocol 
86         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
87             require(
88                 // is the customer in the ambassador list?
89                 ambassadors_[_customerAddress] == true &&
90                 
91                 // does the customer purchase exceed the max ambassador quota?
92                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
93                 
94             );
95             
96             // updated the accumulated quota    
97             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
98         
99             // execute
100             _;
101         } else {
102             // in case the ether count drops low, the ambassador phase won't reinitiate
103             onlyAmbassadors = false;
104             _;    
105         }
106         
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
148     string public name = "GREEN Chip Fund";
149     string public symbol = "GREEN";
150     uint8 constant public decimals = 18;
151     uint8 constant internal dividendFee_ = 4;
152     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
153     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
154     uint256 constant internal magnitude = 2**64;
155 
156 
157     // proof of stake (defaults at 100 tokens)
158     uint256 public stakingRequirement = 1e18;
159     
160     // ambassador program
161     mapping(address => bool) internal ambassadors_;
162     uint256 constant internal ambassadorMaxPurchase_ = 2.0 ether;
163     uint256 constant internal ambassadorQuota_ = 2.0 ether;
164     
165     
166     
167    /*================================
168     =            DATASETS            =
169     ================================*/
170     // amount of shares for each address (scaled number)
171     mapping(address => uint256) internal tokenBalanceLedger_;
172     mapping(address => uint256) internal referralBalance_;
173     mapping(address => int256) internal payoutsTo_;
174     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
175     uint256 internal tokenSupply_ = 0;
176     uint256 internal profitPerShare_;
177     
178     // administrator list (see above on what they can do)
179     mapping(address => bool) public administrators;
180     
181     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
182     bool public onlyAmbassadors = true;
183     
184 
185 
186     /*=======================================
187     =            PUBLIC FUNCTIONS            =
188     =======================================*/
189     /*
190     * -- APPLICATION ENTRY POINTS --  
191     */
192     function GreenChipMain()
193         public
194     {
195         // add administrators here
196         administrators[msg.sender] = true;
197         
198         // add the ambassadors here.
199         ambassadors_[msg.sender] = true;
200     }
201     
202      
203     /**
204      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
205      */
206     function buy(address _referredBy)
207         public
208         payable
209         returns(uint256)
210     {
211         purchaseTokens(msg.value, _referredBy);
212     }
213     
214     /**
215      * Fallback function to handle ethereum that was send straight to the contract
216      * Unfortunately we cannot use a referral address this way.
217      */
218     function()
219         payable
220         public
221     {
222         purchaseTokens(msg.value, 0x0);
223     }
224     
225     /**
226      * Converts all of caller's dividends to tokens.
227      */
228     function reinvest()
229         onlyStronghands()
230         public
231     {
232         // fetch dividends
233         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
234         
235         // pay out the dividends virtually
236         address _customerAddress = msg.sender;
237         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
238         
239         // retrieve ref. bonus
240         _dividends += referralBalance_[_customerAddress];
241         referralBalance_[_customerAddress] = 0;
242         
243         // dispatch a buy order with the virtualized "withdrawn dividends"
244         uint256 _tokens = purchaseTokens(_dividends, 0x0);
245         
246         // fire event
247         onReinvestment(_customerAddress, _dividends, _tokens);
248     }
249     
250     /**
251      * Alias of sell() and withdraw().
252      */
253     function exit()
254         public
255     {
256         // get token count for caller & sell them all
257         address _customerAddress = msg.sender;
258         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
259         if(_tokens > 0) sell(_tokens);
260         
261         // lambo delivery service
262         withdraw();
263     }
264 
265     /**
266      * Withdraws all of the callers earnings.
267      */
268     function withdraw()
269         onlyStronghands()
270         public
271     {
272         // setup data
273         address _customerAddress = msg.sender;
274         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
275         
276         // update dividend tracker
277         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
278         
279         // add ref. bonus
280         _dividends += referralBalance_[_customerAddress];
281         referralBalance_[_customerAddress] = 0;
282         
283         // lambo delivery service
284         _customerAddress.transfer(_dividends);
285         
286         // fire event
287         onWithdraw(_customerAddress, _dividends);
288     }
289     
290     /**
291      * Liquifies tokens to ethereum.
292      */
293     function sell(uint256 _amountOfTokens)
294         onlyBagholders()
295         public
296     {
297         // setup data
298         address _customerAddress = msg.sender;
299         // russian hackers BTFO
300         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
301         uint256 _tokens = _amountOfTokens;
302         uint256 _ethereum = tokensToEthereum_(_tokens);
303         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
304         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
305         
306         // burn the sold tokens
307         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
308         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
309         
310         // update dividends tracker
311         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
312         payoutsTo_[_customerAddress] -= _updatedPayouts;       
313         
314         // dividing by zero is a bad idea
315         if (tokenSupply_ > 0) {
316             // update the amount of dividends per token
317             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
318         }
319         
320         // fire event
321         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
322     }
323     
324     
325     /**
326      * Transfer tokens from the caller to a new holder.
327      * Remember, there's a 10% fee here as well.
328      */
329     function transfer(address _toAddress, uint256 _amountOfTokens)
330         onlyBagholders()
331         public
332         returns(bool)
333     {
334         // setup
335         address _customerAddress = msg.sender;
336         
337         // make sure we have the requested tokens
338         // also disables transfers until ambassador phase is over
339         // ( we dont want whale premines )
340         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
341         
342         // withdraw all outstanding dividends first
343         if(myDividends(true) > 0) withdraw();
344         
345         // liquify 10% of the tokens that are transfered
346         // these are dispersed to shareholders
347         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
348         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
349         uint256 _dividends = tokensToEthereum_(_tokenFee);
350   
351         // burn the fee tokens
352         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
353 
354         // exchange tokens
355         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
356         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
357         
358         // update dividend trackers
359         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
360         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
361         
362         // disperse dividends among holders
363         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
364         
365         // fire event
366         Transfer(_customerAddress, _toAddress, _taxedTokens);
367         
368         // ERC20
369         return true;
370        
371     }
372     
373     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
374     /**
375      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
376      */
377     function disableInitialStage()
378         onlyAdministrator()
379         public
380     {
381         onlyAmbassadors = false;
382     }
383     
384     /**
385      * In case one of us dies, we need to replace ourselves.
386      */
387     function setAdministrator(address _identifier, bool _status)
388         onlyAdministrator()
389         public
390     {
391         administrators[_identifier] = _status;
392     }
393     
394     /**
395      * Precautionary measures in case we need to adjust the masternode rate.
396      */
397     function setStakingRequirement(uint256 _amountOfTokens)
398         onlyAdministrator()
399         public
400     {
401         stakingRequirement = _amountOfTokens;
402     }
403     
404     /**
405      * If we want to rebrand, we can.
406      */
407     function setName(string _name)
408         onlyAdministrator()
409         public
410     {
411         name = _name;
412     }
413     
414     /**
415      * If we want to rebrand, we can.
416      */
417     function setSymbol(string _symbol)
418         onlyAdministrator()
419         public
420     {
421         symbol = _symbol;
422     }
423 
424     
425     /*----------  HELPERS AND CALCULATORS  ----------*/
426     /**
427      * Method to view the current Ethereum stored in the contract
428      * Example: totalEthereumBalance()
429      */
430     function totalEthereumBalance()
431         public
432         view
433         returns(uint)
434     {
435         return this.balance;
436     }
437     
438     /**
439      * Retrieve the total token supply.
440      */
441     function totalSupply()
442         public
443         view
444         returns(uint256)
445     {
446         return tokenSupply_;
447     }
448     
449     /**
450      * Retrieve the tokens owned by the caller.
451      */
452     function myTokens()
453         public
454         view
455         returns(uint256)
456     {
457         address _customerAddress = msg.sender;
458         return balanceOf(_customerAddress);
459     }
460     
461     /**
462      * Retrieve the dividends owned by the caller.
463      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
464      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
465      * But in the internal calculations, we want them separate. 
466      */ 
467     function myDividends(bool _includeReferralBonus) 
468         public 
469         view 
470         returns(uint256)
471     {
472         address _customerAddress = msg.sender;
473         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
474     }
475     
476     /**
477      * Retrieve the token balance of any single address.
478      */
479     function balanceOf(address _customerAddress)
480         view
481         public
482         returns(uint256)
483     {
484         return tokenBalanceLedger_[_customerAddress];
485     }
486     
487     /**
488      * Retrieve the dividend balance of any single address.
489      */
490     function dividendsOf(address _customerAddress)
491         view
492         public
493         returns(uint256)
494     {
495         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
496     }
497     
498     /**
499      * Return the buy price of 1 individual token.
500      */
501     function sellPrice() 
502         public 
503         view 
504         returns(uint256)
505     {
506         // our calculation relies on the token supply, so we need supply. Doh.
507         if(tokenSupply_ == 0){
508             return tokenPriceInitial_ - tokenPriceIncremental_;
509         } else {
510             uint256 _ethereum = tokensToEthereum_(1e18);
511             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
512             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
513             return _taxedEthereum;
514         }
515     }
516     
517     /**
518      * Return the sell price of 1 individual token.
519      */
520     function buyPrice() 
521         public 
522         view 
523         returns(uint256)
524     {
525         // our calculation relies on the token supply, so we need supply. Doh.
526         if(tokenSupply_ == 0){
527             return tokenPriceInitial_ + tokenPriceIncremental_;
528         } else {
529             uint256 _ethereum = tokensToEthereum_(1e18);
530             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
531             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
532             return _taxedEthereum;
533         }
534     }
535     
536     /**
537      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
538      */
539     function calculateTokensReceived(uint256 _ethereumToSpend) 
540         public 
541         view 
542         returns(uint256)
543     {
544         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
545         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
546         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
547         
548         return _amountOfTokens;
549     }
550     
551     /**
552      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
553      */
554     function calculateEthereumReceived(uint256 _tokensToSell) 
555         public 
556         view 
557         returns(uint256)
558     {
559         require(_tokensToSell <= tokenSupply_);
560         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
561         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
562         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
563         return _taxedEthereum;
564     }
565     
566     
567     /*==========================================
568     =            INTERNAL FUNCTIONS            =
569     ==========================================*/
570     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
571         antiEarlyWhale(_incomingEthereum)
572         internal
573         returns(uint256)
574     {
575         // data setup
576         address _customerAddress = msg.sender;
577         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
578         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
579         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
580         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
581         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
582         uint256 _fee = _dividends * magnitude;
583  
584         // no point in continuing execution if OP is a poorfag russian hacker
585         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
586         // (or hackers)
587         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
588         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
589         
590         // is the user referred by a masternode?
591         if(
592             // is this a referred purchase?
593             _referredBy != 0x0000000000000000000000000000000000000000 &&
594 
595             // no cheating!
596             _referredBy != _customerAddress &&
597             
598             // does the referrer have at least X whole tokens?
599             // i.e is the referrer a godly chad masternode
600             tokenBalanceLedger_[_referredBy] >= stakingRequirement
601         ){
602             // wealth redistribution
603             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
604         } else {
605             // no ref purchase
606             // add the referral bonus back to the global dividends cake
607             _dividends = SafeMath.add(_dividends, _referralBonus);
608             _fee = _dividends * magnitude;
609         }
610         
611         // we can't give people infinite ethereum
612         if(tokenSupply_ > 0){
613             
614             // add tokens to the pool
615             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
616  
617             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
618             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
619             
620             // calculate the amount of tokens the customer receives over his purchase 
621             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
622         
623         } else {
624             // add tokens to the pool
625             tokenSupply_ = _amountOfTokens;
626         }
627         
628         // update circulating supply & the ledger address for the customer
629         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
630         
631         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
632         //really i know you think you do but you don't
633         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
634         payoutsTo_[_customerAddress] += _updatedPayouts;
635         
636         // fire event
637         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
638         
639         return _amountOfTokens;
640     }
641 
642     /**
643      * Calculate Token price based on an amount of incoming ethereum
644      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
645      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
646      */
647     function ethereumToTokens_(uint256 _ethereum)
648         internal
649         view
650         returns(uint256)
651     {
652         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
653         uint256 _tokensReceived = 
654          (
655             (
656                 // underflow attempts BTFO
657                 SafeMath.sub(
658                     (sqrt
659                         (
660                             (_tokenPriceInitial**2)
661                             +
662                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
663                             +
664                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
665                             +
666                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
667                         )
668                     ), _tokenPriceInitial
669                 )
670             )/(tokenPriceIncremental_)
671         )-(tokenSupply_)
672         ;
673   
674         return _tokensReceived;
675     }
676     
677     /**
678      * Calculate token sell value.
679      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
680      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
681      */
682      function tokensToEthereum_(uint256 _tokens)
683         internal
684         view
685         returns(uint256)
686     {
687 
688         uint256 tokens_ = (_tokens + 1e18);
689         uint256 _tokenSupply = (tokenSupply_ + 1e18);
690         uint256 _etherReceived =
691         (
692             // underflow attempts BTFO
693             SafeMath.sub(
694                 (
695                     (
696                         (
697                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
698                         )-tokenPriceIncremental_
699                     )*(tokens_ - 1e18)
700                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
701             )
702         /1e18);
703         return _etherReceived;
704     }
705     
706     
707     //This is where all your gas goes, sorry
708     //Not sorry, you probably only paid 1 gwei
709     function sqrt(uint x) internal pure returns (uint y) {
710         uint z = (x + 1) / 2;
711         y = x;
712         while (z < y) {
713             y = z;
714             z = (x / z + z) / 2;
715         }
716     }
717 }
718 
719 /**
720  * @title SafeMath
721  * @dev Math operations with safety checks that throw on error
722  */
723 library SafeMath {
724 
725     /**
726     * @dev Multiplies two numbers, throws on overflow.
727     */
728     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
729         if (a == 0) {
730             return 0;
731         }
732         uint256 c = a * b;
733         assert(c / a == b);
734         return c;
735     }
736 
737     /**
738     * @dev Integer division of two numbers, truncating the quotient.
739     */
740     function div(uint256 a, uint256 b) internal pure returns (uint256) {
741         // assert(b > 0); // Solidity automatically throws when dividing by 0
742         uint256 c = a / b;
743         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
744         return c;
745     }
746 
747     /**
748     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
749     */
750     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
751         assert(b <= a);
752         return a - b;
753     }
754 
755     /**
756     * @dev Adds two numbers, throws on overflow.
757     */
758     function add(uint256 a, uint256 b) internal pure returns (uint256) {
759         uint256 c = a + b;
760         assert(c >= a);
761         return c;
762     }
763 }