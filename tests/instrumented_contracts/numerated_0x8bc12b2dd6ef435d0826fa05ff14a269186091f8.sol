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
25     50% masternode bonus for maximum incentive!
26 */
27 
28 
29 contract POFOMO {
30     /*=================================
31     =            MODIFIERS            =
32     =================================*/
33     // only people with tokens
34     modifier onlyBagholders() {
35         require(myTokens() > 0);
36         _;
37     }
38     
39     // only people with profits
40     modifier onlyStronghands() {
41         require(myDividends(true) > 0);
42         _;
43     }
44     
45     // administrators can:
46     // -> change the name of the contract
47     // -> change the name of the token
48     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
49     // they CANNOT:
50     // -> take funds
51     // -> disable withdrawals
52     // -> kill the contract
53     // -> change the price of tokens
54     modifier onlyAdministrator(){
55         address _customerAddress = msg.sender;
56         require(administrators[_customerAddress]);
57         _;
58     }
59     
60     
61     // ensures that the first tokens in the contract will be equally distributed
62     // meaning, no divine dump will be ever possible
63     // result: healthy longevity.
64     modifier antiEarlyWhale(uint256 _amountOfEthereum){
65         address _customerAddress = msg.sender;
66         
67         // are we still in the vulnerable phase?
68         // if so, enact anti early whale protocol 
69         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
70             require(
71                 // is the customer in the ambassador list?
72                 ambassadors_[_customerAddress] == true &&
73                 
74                 // does the customer purchase exceed the max ambassador quota?
75                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
76                 
77             );
78             
79             // updated the accumulated quota    
80             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
81         
82             // execute
83             _;
84         } else {
85             // in case the ether count drops low, the ambassador phase won't reinitiate
86             onlyAmbassadors = false;
87             _;    
88         }
89         
90     }
91     
92     
93     /*==============================
94     =            EVENTS            =
95     ==============================*/
96     event onTokenPurchase(
97         address indexed customerAddress,
98         uint256 incomingEthereum,
99         uint256 tokensMinted,
100         address indexed referredBy
101     );
102     
103     event onTokenSell(
104         address indexed customerAddress,
105         uint256 tokensBurned,
106         uint256 ethereumEarned
107     );
108     
109     event onReinvestment(
110         address indexed customerAddress,
111         uint256 ethereumReinvested,
112         uint256 tokensMinted
113     );
114     
115     event onWithdraw(
116         address indexed customerAddress,
117         uint256 ethereumWithdrawn
118     );
119     
120     // ERC20
121     event Transfer(
122         address indexed from,
123         address indexed to,
124         uint256 tokens
125     );
126     
127     
128     /*=====================================
129     =            CONFIGURABLES            =
130     =====================================*/
131     string public name = "POFOMO";
132     string public symbol = "POFOMO";
133     uint8 constant public decimals = 18;
134     uint8 constant internal dividendFee_ = 5; 
135     uint256 constant internal tokenPriceInitial_ = 0.000000001 ether;
136     uint256 constant internal tokenPriceIncremental_ = 0.000000007 ether; //slower price increase, longer FOMO!
137     uint256 constant internal magnitude = 2**64;
138     
139     // proof of stake (defaults at 100 tokens)
140     uint256 public stakingRequirement = 5e18;
141     
142     // ambassador program
143     mapping(address => bool) internal ambassadors_;
144     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
145     uint256 constant internal ambassadorQuota_ = 20 ether;
146     
147     
148     
149    /*================================
150     =            DATASETS            =
151     ================================*/
152     // amount of shares for each address (scaled number)
153     mapping(address => uint256) internal tokenBalanceLedger_;
154     mapping(address => uint256) internal referralBalance_;
155     mapping(address => int256) internal payoutsTo_;
156     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
157     uint256 internal tokenSupply_ = 0;
158     uint256 internal profitPerShare_;
159     
160     // administrator list (see above on what they can do)
161     mapping(address => bool) public administrators;
162     bool public onlyAmbassadors = false;
163     
164 
165 
166     /*=======================================
167     =            PUBLIC FUNCTIONS            =
168     =======================================*/
169     /*
170     * -- APPLICATION ENTRY POINTS --  
171     */
172     function POFOMO()
173         public
174     {
175         // add administrators here
176 
177         administrators[0x52FCeE7816b59F99De5e53e7fcA640a7B4a96894] = true;
178 
179     }
180     
181      
182     /**
183      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
184      */
185     function buy(address _referredBy)
186         public
187         payable
188         returns(uint256)
189     {
190         purchaseTokens(msg.value, _referredBy);
191     }
192     
193     /**
194      * Fallback function to handle ethereum that was send straight to the contract
195      * Unfortunately we cannot use a referral address this way.
196      */
197     function()
198         payable
199         public
200     {
201         purchaseTokens(msg.value, 0x0);
202     }
203     
204     /**
205      * Converts all of caller's dividends to tokens.
206     */
207     function reinvest()
208         onlyStronghands()
209         public
210     {
211         // fetch dividends
212         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
213         
214         // pay out the dividends virtually
215         address _customerAddress = msg.sender;
216         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
217         
218         // retrieve ref. bonus
219         _dividends += referralBalance_[_customerAddress];
220         referralBalance_[_customerAddress] = 0;
221         
222         // dispatch a buy order with the virtualized "withdrawn dividends"
223         uint256 _tokens = purchaseTokens(_dividends, 0x0);
224         
225         // fire event
226         onReinvestment(_customerAddress, _dividends, _tokens);
227     }
228     
229     /**
230      * Alias of sell() and withdraw().
231      */
232     function exit()
233         public
234     {
235         // get token count for caller & sell them all
236         address _customerAddress = msg.sender;
237         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
238         if(_tokens > 0) sell(_tokens);
239         
240         // lambo delivery service
241         withdraw();
242     }
243 
244     /**
245      * Withdraws all of the callers earnings.
246      */
247     function withdraw()
248         onlyStronghands()
249         public
250     {
251         // setup data
252         address _customerAddress = msg.sender;
253         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
254         
255         // update dividend tracker
256         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
257         
258         // add ref. bonus
259         _dividends += referralBalance_[_customerAddress];
260         referralBalance_[_customerAddress] = 0;
261         
262         // lambo delivery service
263         _customerAddress.transfer(_dividends);
264         
265         // fire event
266         onWithdraw(_customerAddress, _dividends);
267     }
268     
269     /**
270      * Liquifies tokens to ethereum.
271      */
272     function sell(uint256 _amountOfTokens)
273         onlyBagholders()
274         public
275     {
276         // setup data
277         address _customerAddress = msg.sender;
278         // russian hackers BTFO
279         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
280         uint256 _tokens = _amountOfTokens;
281         uint256 _ethereum = tokensToEthereum_(_tokens);
282         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
283         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
284         
285         // burn the sold tokens
286         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
287         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
288         
289         // update dividends tracker
290         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
291         payoutsTo_[_customerAddress] -= _updatedPayouts;       
292         
293         // dividing by zero is a bad idea
294         if (tokenSupply_ > 0) {
295             // update the amount of dividends per token
296             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
297         }
298         
299         // fire event
300         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
301     }
302     
303     
304     /**
305      * Transfer tokens from the caller to a new holder.
306      * Remember, there's a 10% fee here as well.
307      */
308     function transfer(address _toAddress, uint256 _amountOfTokens)
309         onlyBagholders()
310         public
311         returns(bool)
312     {
313         // setup
314         address _customerAddress = msg.sender;
315         
316         // make sure we have the requested tokens
317         // also disables transfers until ambassador phase is over
318         // ( we dont want whale premines )
319         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
320         
321         // withdraw all outstanding dividends first
322         if(myDividends(true) > 0) withdraw();
323         
324         // liquify 10% of the tokens that are transfered
325         // these are dispersed to shareholders
326         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
327         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
328         uint256 _dividends = tokensToEthereum_(_tokenFee);
329   
330         // burn the fee tokens
331         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
332 
333         // exchange tokens
334         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
335         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
336         
337         // update dividend trackers
338         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
339         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
340         
341         // disperse dividends among holders
342         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
343         
344         // fire event
345         Transfer(_customerAddress, _toAddress, _taxedTokens);
346         
347         // ERC20
348         return true;
349        
350     }
351     
352     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
353     /**
354      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
355      */
356     function disableInitialStage()
357         onlyAdministrator()
358         public
359     {
360         onlyAmbassadors = false;
361     }
362     
363     /**
364      * In case one of us dies, we need to replace ourselves.
365      */
366 
367     
368     /**
369      * Precautionary measures in case we need to adjust the masternode rate.
370      */
371     function setStakingRequirement(uint256 _amountOfTokens)
372         onlyAdministrator()
373         public
374     {
375         stakingRequirement = _amountOfTokens;
376     }
377     
378     /**
379      * If we want to rebrand, we can.
380      */
381     function setName(string _name)
382         onlyAdministrator()
383         public
384     {
385         name = _name;
386     }
387     
388     /**
389      * If we want to rebrand, we can.
390      */
391     function setSymbol(string _symbol)
392         onlyAdministrator()
393         public
394     {
395         symbol = _symbol;
396     }
397 
398     
399     /*----------  HELPERS AND CALCULATORS  ----------*/
400     /**
401      * Method to view the current Ethereum stored in the contract
402      * Example: totalEthereumBalance()
403      */
404     function totalEthereumBalance()
405         public
406         view
407         returns(uint)
408     {
409         return this.balance;
410     }
411     
412     /**
413      * Retrieve the total token supply.
414      */
415     function totalSupply()
416         public
417         view
418         returns(uint256)
419     {
420         return tokenSupply_;
421     }
422     
423     /**
424      * Retrieve the tokens owned by the caller.
425      */
426     function myTokens()
427         public
428         view
429         returns(uint256)
430     {
431         address _customerAddress = msg.sender;
432         return balanceOf(_customerAddress);
433     }
434     
435     /**
436      * Retrieve the dividends owned by the caller.
437      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
438      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
439      * But in the internal calculations, we want them separate. 
440      */ 
441     function myDividends(bool _includeReferralBonus) 
442         public 
443         view 
444         returns(uint256)
445     {
446         address _customerAddress = msg.sender;
447         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
448     }
449     
450     /**
451      * Retrieve the token balance of any single address.
452      */
453     function balanceOf(address _customerAddress)
454         view
455         public
456         returns(uint256)
457     {
458         return tokenBalanceLedger_[_customerAddress];
459     }
460     
461     /**
462      * Retrieve the dividend balance of any single address.
463      */
464     function dividendsOf(address _customerAddress)
465         view
466         public
467         returns(uint256)
468     {
469         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
470     }
471     
472     /**
473      * Return the buy price of 1 individual token.
474      */
475     function sellPrice() 
476         public 
477         view 
478         returns(uint256)
479     {
480         // our calculation relies on the token supply, so we need supply. Doh.
481         if(tokenSupply_ == 0){
482             return tokenPriceInitial_ - tokenPriceIncremental_;
483         } else {
484             uint256 _ethereum = tokensToEthereum_(1e18);
485             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
486             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
487             return _taxedEthereum;
488         }
489     }
490     
491     /**
492      * Return the sell price of 1 individual token.
493      */
494     function buyPrice() 
495         public 
496         view 
497         returns(uint256)
498     {
499         // our calculation relies on the token supply, so we need supply. Doh.
500         if(tokenSupply_ == 0){
501             return tokenPriceInitial_ + tokenPriceIncremental_;
502         } else {
503             uint256 _ethereum = tokensToEthereum_(1e18);
504             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
505             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
506             return _taxedEthereum;
507         }
508     }
509     
510     /**
511      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
512      */
513     function calculateTokensReceived(uint256 _ethereumToSpend) 
514         public 
515         view 
516         returns(uint256)
517     {
518         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
519         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
520         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
521         
522         return _amountOfTokens;
523     }
524     
525     /**
526      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
527      */
528     function calculateEthereumReceived(uint256 _tokensToSell) 
529         public 
530         view 
531         returns(uint256)
532     {
533         require(_tokensToSell <= tokenSupply_);
534         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
535         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
536         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
537         return _taxedEthereum;
538     }
539     
540     
541     /*==========================================
542     =            INTERNAL FUNCTIONS            =
543     ==========================================*/
544     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
545         antiEarlyWhale(_incomingEthereum)
546         internal
547         returns(uint256)
548     {
549         // data setup
550         address _customerAddress = msg.sender;
551         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
552         uint256 _referralBonus = SafeMath.div(_undividedDividends, 2);
553         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
554         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
555         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
556         uint256 _fee = _dividends * magnitude;
557  
558         // no point in continuing execution if OP is a poorfag russian hacker
559         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
560         // (or hackers)
561         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
562         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
563         
564         // is the user referred by a masternode?
565         if(
566             // is this a referred purchase?
567             _referredBy != 0x0000000000000000000000000000000000000000 &&
568 
569             // no cheating!
570             _referredBy != _customerAddress &&
571             
572             // does the referrer have at least X whole tokens?
573             // i.e is the referrer a godly chad masternode
574             tokenBalanceLedger_[_referredBy] >= stakingRequirement
575         ){
576             // wealth redistribution
577             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
578         } else {
579             // no ref purchase
580             // add the referral bonus back to the global dividends cake
581             _dividends = SafeMath.add(_dividends, _referralBonus);
582             _fee = _dividends * magnitude;
583         }
584         
585         // we can't give people infinite ethereum
586         if(tokenSupply_ > 0){
587             
588             // add tokens to the pool
589             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
590  
591             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
592             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
593             
594             // calculate the amount of tokens the customer receives over his purchase 
595             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
596         
597         } else {
598             // add tokens to the pool
599             tokenSupply_ = _amountOfTokens;
600         }
601         
602         // update circulating supply & the ledger address for the customer
603         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
604         
605         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
606         //really i know you think you do but you don't
607         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
608         payoutsTo_[_customerAddress] += _updatedPayouts;
609         
610         // fire event
611         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
612         
613         return _amountOfTokens;
614     }
615 
616     /**
617      * Calculate Token price based on an amount of incoming ethereum
618      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
619      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
620      */
621     function ethereumToTokens_(uint256 _ethereum)
622         internal
623         view
624         returns(uint256)
625     {
626         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
627         uint256 _tokensReceived = 
628          (
629             (
630                 // underflow attempts BTFO
631                 SafeMath.sub(
632                     (sqrt
633                         (
634                             (_tokenPriceInitial**2)
635                             +
636                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
637                             +
638                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
639                             +
640                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
641                         )
642                     ), _tokenPriceInitial
643                 )
644             )/(tokenPriceIncremental_)
645         )-(tokenSupply_)
646         ;
647   
648         return _tokensReceived;
649     }
650     
651     /**
652      * Calculate token sell value.
653      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
654      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
655      */
656      function tokensToEthereum_(uint256 _tokens)
657         internal
658         view
659         returns(uint256)
660     {
661 
662         uint256 tokens_ = (_tokens + 1e18);
663         uint256 _tokenSupply = (tokenSupply_ + 1e18);
664         uint256 _etherReceived =
665         (
666             // underflow attempts BTFO
667             SafeMath.sub(
668                 (
669                     (
670                         (
671                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
672                         )-tokenPriceIncremental_
673                     )*(tokens_ - 1e18)
674                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
675             )
676         /1e18);
677         return _etherReceived;
678     }
679     
680     
681     //This is where all your gas goes, sorry
682     //Not sorry, you probably only paid 1 gwei
683     function sqrt(uint x) internal pure returns (uint y) {
684         uint z = (x + 1) / 2;
685         y = x;
686         while (z < y) {
687             y = z;
688             z = (x / z + z) / 2;
689         }
690     }
691 }
692 
693 /**
694  * @title SafeMath
695  * @dev Math operations with safety checks that throw on error
696  */
697 library SafeMath {
698 
699     /**
700     * @dev Multiplies two numbers, throws on overflow.
701     */
702     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
703         if (a == 0) {
704             return 0;
705         }
706         uint256 c = a * b;
707         assert(c / a == b);
708         return c;
709     }
710 
711     /**
712     * @dev Integer division of two numbers, truncating the quotient.
713     */
714     function div(uint256 a, uint256 b) internal pure returns (uint256) {
715         // assert(b > 0); // Solidity automatically throws when dividing by 0
716         uint256 c = a / b;
717         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
718         return c;
719     }
720 
721     /**
722     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
723     */
724     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
725         assert(b <= a);
726         return a - b;
727     }
728 
729     /**
730     * @dev Adds two numbers, throws on overflow.
731     */
732     function add(uint256 a, uint256 b) internal pure returns (uint256) {
733         uint256 c = a + b;
734         assert(c >= a);
735         return c;
736     }
737 }