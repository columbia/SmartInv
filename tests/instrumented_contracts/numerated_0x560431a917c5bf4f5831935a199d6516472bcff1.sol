1 pragma solidity ^0.4.20;
2 
3 /*
4 
5   _____  _____   ____   ____  ______ 
6  |  __ \|  __ \ / __ \ / __ \|  ____|
7  | |__) | |__) | |  | | |  | | |__   
8  |  ___/|  _  /| |  | | |  | |  __|  
9  | |    | | \ \| |__| | |__| | |     
10  |_|___ |_|__\_\\____/ \____/|_|     
11   / __ \|  ____|                     
12  | |  | | |__                        
13  | |  | |  __|                       
14  | |__| | |                          
15   \____/|_|__  __  __  ____          
16  |  ____/ __ \|  \/  |/ __ \         
17  | |__ | |  | | \  / | |  | |        
18  |  __|| |  | | |\/| | |  | |        
19  | |   | |__| | |  | | |__| |        
20  |_|    \____/|_|  |_|\____/         
21                               
22     
23     Autonomous pyramid with 20% dividends and a SLOWER TOKEN PRICE INCREASE to give fairer FOMO for all.
24     Longer pyramid lifespan = more divs for everyone :)
25 */
26 
27 
28 contract POFOMO {
29     /*=================================
30     =            MODIFIERS            =
31     =================================*/
32     // only people with tokens
33     modifier onlyBagholders() {
34         require(myTokens() > 0);
35         _;
36     }
37     
38     // only people with profits
39     modifier onlyStronghands() {
40         require(myDividends(true) > 0);
41         _;
42     }
43     
44     // administrators can:
45     // -> change the name of the contract
46     // -> change the name of the token
47     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
48     // they CANNOT:
49     // -> take funds
50     // -> disable withdrawals
51     // -> kill the contract
52     // -> change the price of tokens
53     modifier onlyAdministrator(){
54         address _customerAddress = msg.sender;
55         require(administrators[_customerAddress]);
56         _;
57     }
58     
59     
60     // ensures that the first tokens in the contract will be equally distributed
61     // meaning, no divine dump will be ever possible
62     // result: healthy longevity.
63     modifier antiEarlyWhale(uint256 _amountOfEthereum){
64         address _customerAddress = msg.sender;
65         
66         // are we still in the vulnerable phase?
67         // if so, enact anti early whale protocol 
68         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
69             require(
70                 // is the customer in the ambassador list?
71                 ambassadors_[_customerAddress] == true &&
72                 
73                 // does the customer purchase exceed the max ambassador quota?
74                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
75                 
76             );
77             
78             // updated the accumulated quota    
79             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
80         
81             // execute
82             _;
83         } else {
84             // in case the ether count drops low, the ambassador phase won't reinitiate
85             onlyAmbassadors = false;
86             _;    
87         }
88         
89     }
90     
91     
92     /*==============================
93     =            EVENTS            =
94     ==============================*/
95     event onTokenPurchase(
96         address indexed customerAddress,
97         uint256 incomingEthereum,
98         uint256 tokensMinted,
99         address indexed referredBy
100     );
101     
102     event onTokenSell(
103         address indexed customerAddress,
104         uint256 tokensBurned,
105         uint256 ethereumEarned
106     );
107     
108     event onReinvestment(
109         address indexed customerAddress,
110         uint256 ethereumReinvested,
111         uint256 tokensMinted
112     );
113     
114     event onWithdraw(
115         address indexed customerAddress,
116         uint256 ethereumWithdrawn
117     );
118     
119     // ERC20
120     event Transfer(
121         address indexed from,
122         address indexed to,
123         uint256 tokens
124     );
125     
126     
127     /*=====================================
128     =            CONFIGURABLES            =
129     =====================================*/
130     string public name = "POFOMO";
131     string public symbol = "POFOMO";
132     uint8 constant public decimals = 18;
133     uint8 constant internal dividendFee_ = 5; 
134     uint256 constant internal tokenPriceInitial_ = 0.0000000001 ether;
135     uint256 constant internal tokenPriceIncremental_ = 0.000000007 ether; //slower price increase, longer FOMO!
136     uint256 constant internal magnitude = 2**64;
137     
138     // proof of stake (defaults at 100 tokens)
139     uint256 public stakingRequirement = 5e18;
140     
141     // ambassador program
142     mapping(address => bool) internal ambassadors_;
143     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
144     uint256 constant internal ambassadorQuota_ = 20 ether;
145     
146     
147     
148    /*================================
149     =            DATASETS            =
150     ================================*/
151     // amount of shares for each address (scaled number)
152     mapping(address => uint256) internal tokenBalanceLedger_;
153     mapping(address => uint256) internal referralBalance_;
154     mapping(address => int256) internal payoutsTo_;
155     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
156     uint256 internal tokenSupply_ = 0;
157     uint256 internal profitPerShare_;
158     
159     // administrator list (see above on what they can do)
160     mapping(address => bool) public administrators;
161     bool public onlyAmbassadors = false;
162     
163 
164 
165     /*=======================================
166     =            PUBLIC FUNCTIONS            =
167     =======================================*/
168     /*
169     * -- APPLICATION ENTRY POINTS --  
170     */
171     function POFOMO()
172         public
173     {
174         // add administrators here
175 
176         administrators[0x52FCeE7816b59F99De5e53e7fcA640a7B4a96894] = true;
177 
178     }
179     
180      
181     /**
182      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
183      */
184     function buy(address _referredBy)
185         public
186         payable
187         returns(uint256)
188     {
189         purchaseTokens(msg.value, _referredBy);
190     }
191     
192     /**
193      * Fallback function to handle ethereum that was send straight to the contract
194      * Unfortunately we cannot use a referral address this way.
195      */
196     function()
197         payable
198         public
199     {
200         purchaseTokens(msg.value, 0x0);
201     }
202     
203     /**
204      * Converts all of caller's dividends to tokens.
205     */
206     function reinvest()
207         onlyStronghands()
208         public
209     {
210         // fetch dividends
211         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
212         
213         // pay out the dividends virtually
214         address _customerAddress = msg.sender;
215         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
216         
217         // retrieve ref. bonus
218         _dividends += referralBalance_[_customerAddress];
219         referralBalance_[_customerAddress] = 0;
220         
221         // dispatch a buy order with the virtualized "withdrawn dividends"
222         uint256 _tokens = purchaseTokens(_dividends, 0x0);
223         
224         // fire event
225         onReinvestment(_customerAddress, _dividends, _tokens);
226     }
227     
228     /**
229      * Alias of sell() and withdraw().
230      */
231     function exit()
232         public
233     {
234         // get token count for caller & sell them all
235         address _customerAddress = msg.sender;
236         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
237         if(_tokens > 0) sell(_tokens);
238         
239         // lambo delivery service
240         withdraw();
241     }
242 
243     /**
244      * Withdraws all of the callers earnings.
245      */
246     function withdraw()
247         onlyStronghands()
248         public
249     {
250         // setup data
251         address _customerAddress = msg.sender;
252         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
253         
254         // update dividend tracker
255         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
256         
257         // add ref. bonus
258         _dividends += referralBalance_[_customerAddress];
259         referralBalance_[_customerAddress] = 0;
260         
261         // lambo delivery service
262         _customerAddress.transfer(_dividends);
263         
264         // fire event
265         onWithdraw(_customerAddress, _dividends);
266     }
267     
268     /**
269      * Liquifies tokens to ethereum.
270      */
271     function sell(uint256 _amountOfTokens)
272         onlyBagholders()
273         public
274     {
275         // setup data
276         address _customerAddress = msg.sender;
277         // russian hackers BTFO
278         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
279         uint256 _tokens = _amountOfTokens;
280         uint256 _ethereum = tokensToEthereum_(_tokens);
281         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
282         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
283         
284         // burn the sold tokens
285         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
286         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
287         
288         // update dividends tracker
289         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
290         payoutsTo_[_customerAddress] -= _updatedPayouts;       
291         
292         // dividing by zero is a bad idea
293         if (tokenSupply_ > 0) {
294             // update the amount of dividends per token
295             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
296         }
297         
298         // fire event
299         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
300     }
301     
302     
303     /**
304      * Transfer tokens from the caller to a new holder.
305      * Remember, there's a 10% fee here as well.
306      */
307     function transfer(address _toAddress, uint256 _amountOfTokens)
308         onlyBagholders()
309         public
310         returns(bool)
311     {
312         // setup
313         address _customerAddress = msg.sender;
314         
315         // make sure we have the requested tokens
316         // also disables transfers until ambassador phase is over
317         // ( we dont want whale premines )
318         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
319         
320         // withdraw all outstanding dividends first
321         if(myDividends(true) > 0) withdraw();
322         
323         // liquify 10% of the tokens that are transfered
324         // these are dispersed to shareholders
325         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
326         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
327         uint256 _dividends = tokensToEthereum_(_tokenFee);
328   
329         // burn the fee tokens
330         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
331 
332         // exchange tokens
333         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
334         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
335         
336         // update dividend trackers
337         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
338         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
339         
340         // disperse dividends among holders
341         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
342         
343         // fire event
344         Transfer(_customerAddress, _toAddress, _taxedTokens);
345         
346         // ERC20
347         return true;
348        
349     }
350     
351     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
352     /**
353      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
354      */
355     function disableInitialStage()
356         onlyAdministrator()
357         public
358     {
359         onlyAmbassadors = false;
360     }
361     
362     /**
363      * In case one of us dies, we need to replace ourselves.
364      */
365 
366     
367     /**
368      * Precautionary measures in case we need to adjust the masternode rate.
369      */
370     function setStakingRequirement(uint256 _amountOfTokens)
371         onlyAdministrator()
372         public
373     {
374         stakingRequirement = _amountOfTokens;
375     }
376     
377     /**
378      * If we want to rebrand, we can.
379      */
380     function setName(string _name)
381         onlyAdministrator()
382         public
383     {
384         name = _name;
385     }
386     
387     /**
388      * If we want to rebrand, we can.
389      */
390     function setSymbol(string _symbol)
391         onlyAdministrator()
392         public
393     {
394         symbol = _symbol;
395     }
396 
397     
398     /*----------  HELPERS AND CALCULATORS  ----------*/
399     /**
400      * Method to view the current Ethereum stored in the contract
401      * Example: totalEthereumBalance()
402      */
403     function totalEthereumBalance()
404         public
405         view
406         returns(uint)
407     {
408         return this.balance;
409     }
410     
411     /**
412      * Retrieve the total token supply.
413      */
414     function totalSupply()
415         public
416         view
417         returns(uint256)
418     {
419         return tokenSupply_;
420     }
421     
422     /**
423      * Retrieve the tokens owned by the caller.
424      */
425     function myTokens()
426         public
427         view
428         returns(uint256)
429     {
430         address _customerAddress = msg.sender;
431         return balanceOf(_customerAddress);
432     }
433     
434     /**
435      * Retrieve the dividends owned by the caller.
436      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
437      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
438      * But in the internal calculations, we want them separate. 
439      */ 
440     function myDividends(bool _includeReferralBonus) 
441         public 
442         view 
443         returns(uint256)
444     {
445         address _customerAddress = msg.sender;
446         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
447     }
448     
449     /**
450      * Retrieve the token balance of any single address.
451      */
452     function balanceOf(address _customerAddress)
453         view
454         public
455         returns(uint256)
456     {
457         return tokenBalanceLedger_[_customerAddress];
458     }
459     
460     /**
461      * Retrieve the dividend balance of any single address.
462      */
463     function dividendsOf(address _customerAddress)
464         view
465         public
466         returns(uint256)
467     {
468         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
469     }
470     
471     /**
472      * Return the buy price of 1 individual token.
473      */
474     function sellPrice() 
475         public 
476         view 
477         returns(uint256)
478     {
479         // our calculation relies on the token supply, so we need supply. Doh.
480         if(tokenSupply_ == 0){
481             return tokenPriceInitial_ - tokenPriceIncremental_;
482         } else {
483             uint256 _ethereum = tokensToEthereum_(1e18);
484             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
485             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
486             return _taxedEthereum;
487         }
488     }
489     
490     /**
491      * Return the sell price of 1 individual token.
492      */
493     function buyPrice() 
494         public 
495         view 
496         returns(uint256)
497     {
498         // our calculation relies on the token supply, so we need supply. Doh.
499         if(tokenSupply_ == 0){
500             return tokenPriceInitial_ + tokenPriceIncremental_;
501         } else {
502             uint256 _ethereum = tokensToEthereum_(1e18);
503             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
504             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
505             return _taxedEthereum;
506         }
507     }
508     
509     /**
510      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
511      */
512     function calculateTokensReceived(uint256 _ethereumToSpend) 
513         public 
514         view 
515         returns(uint256)
516     {
517         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
518         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
519         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
520         
521         return _amountOfTokens;
522     }
523     
524     /**
525      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
526      */
527     function calculateEthereumReceived(uint256 _tokensToSell) 
528         public 
529         view 
530         returns(uint256)
531     {
532         require(_tokensToSell <= tokenSupply_);
533         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
534         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
535         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
536         return _taxedEthereum;
537     }
538     
539     
540     /*==========================================
541     =            INTERNAL FUNCTIONS            =
542     ==========================================*/
543     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
544         antiEarlyWhale(_incomingEthereum)
545         internal
546         returns(uint256)
547     {
548         // data setup
549         address _customerAddress = msg.sender;
550         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
551         uint256 _referralBonus = SafeMath.div(_undividedDividends, 2);
552         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
553         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
554         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
555         uint256 _fee = _dividends * magnitude;
556  
557         // no point in continuing execution if OP is a poorfag russian hacker
558         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
559         // (or hackers)
560         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
561         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
562         
563         // is the user referred by a masternode?
564         if(
565             // is this a referred purchase?
566             _referredBy != 0x0000000000000000000000000000000000000000 &&
567 
568             // no cheating!
569             _referredBy != _customerAddress &&
570             
571             // does the referrer have at least X whole tokens?
572             // i.e is the referrer a godly chad masternode
573             tokenBalanceLedger_[_referredBy] >= stakingRequirement
574         ){
575             // wealth redistribution
576             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
577         } else {
578             // no ref purchase
579             // add the referral bonus back to the global dividends cake
580             _dividends = SafeMath.add(_dividends, _referralBonus);
581             _fee = _dividends * magnitude;
582         }
583         
584         // we can't give people infinite ethereum
585         if(tokenSupply_ > 0){
586             
587             // add tokens to the pool
588             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
589  
590             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
591             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
592             
593             // calculate the amount of tokens the customer receives over his purchase 
594             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
595         
596         } else {
597             // add tokens to the pool
598             tokenSupply_ = _amountOfTokens;
599         }
600         
601         // update circulating supply & the ledger address for the customer
602         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
603         
604         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
605         //really i know you think you do but you don't
606         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
607         payoutsTo_[_customerAddress] += _updatedPayouts;
608         
609         // fire event
610         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
611         
612         return _amountOfTokens;
613     }
614 
615     /**
616      * Calculate Token price based on an amount of incoming ethereum
617      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
618      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
619      */
620     function ethereumToTokens_(uint256 _ethereum)
621         internal
622         view
623         returns(uint256)
624     {
625         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
626         uint256 _tokensReceived = 
627          (
628             (
629                 // underflow attempts BTFO
630                 SafeMath.sub(
631                     (sqrt
632                         (
633                             (_tokenPriceInitial**2)
634                             +
635                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
636                             +
637                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
638                             +
639                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
640                         )
641                     ), _tokenPriceInitial
642                 )
643             )/(tokenPriceIncremental_)
644         )-(tokenSupply_)
645         ;
646   
647         return _tokensReceived;
648     }
649     
650     /**
651      * Calculate token sell value.
652      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
653      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
654      */
655      function tokensToEthereum_(uint256 _tokens)
656         internal
657         view
658         returns(uint256)
659     {
660 
661         uint256 tokens_ = (_tokens + 1e18);
662         uint256 _tokenSupply = (tokenSupply_ + 1e18);
663         uint256 _etherReceived =
664         (
665             // underflow attempts BTFO
666             SafeMath.sub(
667                 (
668                     (
669                         (
670                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
671                         )-tokenPriceIncremental_
672                     )*(tokens_ - 1e18)
673                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
674             )
675         /1e18);
676         return _etherReceived;
677     }
678     
679     
680     //This is where all your gas goes, sorry
681     //Not sorry, you probably only paid 1 gwei
682     function sqrt(uint x) internal pure returns (uint y) {
683         uint z = (x + 1) / 2;
684         y = x;
685         while (z < y) {
686             y = z;
687             z = (x / z + z) / 2;
688         }
689     }
690 }
691 
692 /**
693  * @title SafeMath
694  * @dev Math operations with safety checks that throw on error
695  */
696 library SafeMath {
697 
698     /**
699     * @dev Multiplies two numbers, throws on overflow.
700     */
701     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
702         if (a == 0) {
703             return 0;
704         }
705         uint256 c = a * b;
706         assert(c / a == b);
707         return c;
708     }
709 
710     /**
711     * @dev Integer division of two numbers, truncating the quotient.
712     */
713     function div(uint256 a, uint256 b) internal pure returns (uint256) {
714         // assert(b > 0); // Solidity automatically throws when dividing by 0
715         uint256 c = a / b;
716         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
717         return c;
718     }
719 
720     /**
721     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
722     */
723     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
724         assert(b <= a);
725         return a - b;
726     }
727 
728     /**
729     * @dev Adds two numbers, throws on overflow.
730     */
731     function add(uint256 a, uint256 b) internal pure returns (uint256) {
732         uint256 c = a + b;
733         assert(c >= a);
734         return c;
735     }
736 }