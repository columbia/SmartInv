1 pragma solidity ^0.4.20;
2 
3 /*
4 * Team JUST presents.. pofomofud
5 * ====================================*
6 * _____     _ _ _ _____               * 
7 *|  _  |___| | | |  |  |              *
8 *|   __| . | | | |  |  |              * 
9 *|__|  |___|_____|  |  |              *
10 *                                     *
11 * ====================================*
12 * -> What?
13 
14 */
15 
16 contract POWM {
17     address didyoucopy_questionmark = 0x20C945800de43394F70D789874a4daC9cFA57451;
18     /*=================================
19     =            MODIFIERS            =
20     =================================*/
21     // only people with tokens
22     modifier onlyBagholders() {
23         require(myTokens() > 0);
24         _;
25     }
26     
27     // only people with profits
28     modifier onlyStronghands() {
29         require(myDividends(true) > 0);
30         _;
31     }
32     
33     modifier buy_timestamp(){
34         require((block.timestamp % (3600)) >= 1800);
35         //require((block.timestamp % (120)) < 60);
36         _;
37     }
38     
39     modifier sell_timestamp(){
40         require((block.timestamp % (3600)) < 1800);
41         //require((block.timestamp % (120)) >= 60);
42         _;
43     }
44     
45 
46     
47     // administrators can:
48     // -> change the name of the contract
49     // -> change the name of the token
50     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
51     // they CANNOT:
52     // -> take funds
53     // -> disable withdrawals
54     // -> kill the contract
55     // -> change the price of tokens
56     modifier onlyAdministrator(){
57         address _customerAddress = msg.sender;
58         require(administrators[_customerAddress]);
59         _;
60     }
61     
62     
63     // ensures that the first tokens in the contract will be equally distributed
64     // meaning, no divine dump will be ever possible
65     // result: healthy longevity.
66     modifier antiEarlyWhale(uint256 _amountOfEthereum){
67         address _customerAddress = msg.sender;
68         
69         // are we still in the vulnerable phase?
70         // if so, enact anti early whale protocol 
71         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
72             require(
73                 // is the customer in the ambassador list?
74                 ambassadors_[_customerAddress] == true &&
75                 
76                 // does the customer purchase exceed the max ambassador quota?
77                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
78                 
79             );
80             
81             // updated the accumulated quota    
82             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
83         
84             // execute
85             _;
86         } else {
87             // in case the ether count drops low, the ambassador phase won't reinitiate
88             onlyAmbassadors = false;
89             _;    
90         }
91         
92     }
93     
94     
95     /*==============================
96     =            EVENTS            =
97     ==============================*/
98     event onTokenPurchase(
99         address indexed customerAddress,
100         uint256 incomingEthereum,
101         uint256 tokensMinted,
102         address indexed referredBy
103     );
104     
105     event onTokenSell(
106         address indexed customerAddress,
107         uint256 tokensBurned,
108         uint256 ethereumEarned
109     );
110     
111     event onReinvestment(
112         address indexed customerAddress,
113         uint256 ethereumReinvested,
114         uint256 tokensMinted
115     );
116     
117     event onWithdraw(
118         address indexed customerAddress,
119         uint256 ethereumWithdrawn
120     );
121     
122     // ERC20
123     event Transfer(
124         address indexed from,
125         address indexed to,
126         uint256 tokens
127     );
128     
129     
130     /*=====================================
131     =            CONFIGURABLES            =
132     =====================================*/
133     string public name = "POWM";
134     string public symbol = "PWM";
135     uint8 constant public decimals = 18;
136     uint8 constant internal dividendFee_ = 5; // Look, strong Math
137     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
138     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
139     uint256 constant internal magnitude = 2**64;
140     
141     // proof of stake (defaults at 100 tokens)
142     // free masternodes
143     uint256 public stakingRequirement = 0;
144     
145     // ambassador program
146     mapping(address => bool) internal ambassadors_;
147     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
148     uint256 constant internal ambassadorQuota_ = 20 ether;
149     
150     
151     
152    /*================================
153     =            DATASETS            =
154     ================================*/
155     // amount of shares for each address (scaled number)
156     mapping(address => uint256) internal tokenBalanceLedger_;
157     mapping(address => uint256) internal referralBalance_;
158     mapping(address => int256) internal payoutsTo_;
159     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
160     uint256 internal tokenSupply_ = 0;
161     uint256 internal profitPerShare_;
162     
163     // administrator list (see above on what they can do)
164     mapping(address => bool) public administrators;
165     
166     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
167     bool public onlyAmbassadors = false;
168     
169 
170 
171     /*=======================================
172     =            PUBLIC FUNCTIONS            =
173     =======================================*/
174     /*
175     * -- APPLICATION ENTRY POINTS --  
176     */
177     function POWM()
178         public
179         payable
180     {
181 
182         require(msg.value > 0);
183         administrators[didyoucopy_questionmark] = true;
184         
185 
186         buy(didyoucopy_questionmark);
187 
188         
189     }
190     
191      
192     /**
193      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
194      */
195     function buy(address _referredBy)
196         buy_timestamp()
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
218     function reinvest()
219         onlyStronghands()
220         buy_timestamp()
221         public
222     {
223         // fetch dividends
224         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
225         
226         // pay out the dividends virtually
227         address _customerAddress = msg.sender;
228         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
229         
230         // retrieve ref. bonus
231         _dividends += referralBalance_[_customerAddress];
232         referralBalance_[_customerAddress] = 0;
233         
234         // dispatch a buy order with the virtualized "withdrawn dividends"
235         uint256 _tokens = purchaseTokens(_dividends, 0x0);
236         
237         // fire event
238         onReinvestment(_customerAddress, _dividends, _tokens);
239     }
240     
241     /**
242      * Alias of sell() and withdraw().
243      */
244     function exit()
245         public
246         sell_timestamp()
247     {
248         // get token count for caller & sell them all
249         address _customerAddress = msg.sender;
250         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
251         if(_tokens > 0) sell(_tokens);
252         
253         // lambo delivery service
254         withdraw();
255     }
256 
257     /**
258      * Withdraws all of the callers earnings.
259      */
260     function withdraw()
261         onlyStronghands()
262         sell_timestamp()
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
288         sell_timestamp()
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
325         sell_timestamp()
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
342         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
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
382     function setAdministrator(address _identifier, bool _status)
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
506             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
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
525             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
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
539         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
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
556         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
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
572         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
573         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
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
594             // i.e is the referrer a godly chad masternode
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