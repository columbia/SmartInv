1 pragma solidity ^0.4.20;
2 
3 
4 /*
5 * ====================================*
6 *  _____   ____    ____   _______     *
7 * |  ___| / __ \  |    \ |__   __|    * 
8 * | |___ | |__| | |    /    | |       *
9 * |  ___||  __  | | |\ \    | |       *
10 * | |    | |  | | | | \ \   | |       *
11 * |_|    |_|  |_| |_|  \_\  |_|       *
12 * ====================================*
13 * 
14 * Freedom Around Revolutionary Technology
15 *
16 * Changing the humanitarian world while having fun!
17 *
18 */
19 
20 contract FART {
21     /*=================================
22     =            MODIFIERS            =
23     =================================*/
24     // only people with tokens
25     modifier onlyBagholders() {
26         require(myTokens() > 0);
27         _;
28     }
29     
30     // only people with profits
31     modifier onlyStronghands() {
32         require(myDividends(true) > 0);
33         _;
34     }
35     
36     // administrators can:
37     // -> change the name of the contract
38     // -> change the name of the token
39     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
40     // they CANNOT:
41     // -> take funds
42     // -> disable withdrawals
43     // -> kill the contract
44     // -> change the price of tokens
45     modifier onlyAdministrator(){
46         address _customerAddress = msg.sender;
47         require(administrators[keccak256(_customerAddress)]);
48         _;
49     }
50     
51     
52     // ensures that the first tokens in the contract will be equally distributed
53     // meaning, no divine dump will be ever possible
54     // result: healthy longevity.
55     modifier antiEarlyWhale(uint256 _amountOfEthereum){
56         address _customerAddress = msg.sender;
57         
58         // are we still in the vulnerable phase?
59         // if so, enact anti early whale protocol 
60         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
61             require(
62                 // is the customer in the ambassador list?
63                 ambassadors_[_customerAddress] == true &&
64                 
65                 // does the customer purchase exceed the max ambassador quota?
66                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
67                 
68             );
69             
70             // updated the accumulated quota    
71             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
72         
73             // execute
74             _;
75         } else {
76             // in case the ether count drops low, the ambassador phase won't reinitiate
77             onlyAmbassadors = false;
78             _;    
79         }
80         
81     }
82     
83     
84     /*==============================
85     =            EVENTS            =
86     ==============================*/
87     event onTokenPurchase(
88         address indexed customerAddress,
89         uint256 incomingEthereum,
90         uint256 tokensMinted,
91         address indexed referredBy
92     );
93     
94     event onTokenSell(
95         address indexed customerAddress,
96         uint256 tokensBurned,
97         uint256 ethereumEarned
98     );
99     
100     event onReinvestment(
101         address indexed customerAddress,
102         uint256 ethereumReinvested,
103         uint256 tokensMinted
104     );
105     
106     event onWithdraw(
107         address indexed customerAddress,
108         uint256 ethereumWithdrawn
109     );
110     
111     // ERC20
112     event Transfer(
113         address indexed from,
114         address indexed to,
115         uint256 tokens
116     );
117     
118     
119     /*=====================================
120     =            CONFIGURABLES            =
121     =====================================*/
122     string public name = "FART";
123     string public symbol = "FART";
124     uint8 constant public decimals = 18;
125     uint8 constant internal dividendFee_ = 10;
126     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
127     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
128     uint256 constant internal magnitude = 2**64;
129     
130     // proof of stake (defaults at 100 tokens)
131     uint256 public stakingRequirement = 5e18;
132     
133     // ambassador program
134     mapping(address => bool) internal ambassadors_;
135     uint256 constant internal ambassadorMaxPurchase_ = 2 ether;
136     uint256 constant internal ambassadorQuota_ = 1 ether;
137     
138     
139     
140    /*================================
141     =            DATASETS            =
142     ================================*/
143     // amount of shares for each address (scaled number)
144     mapping(address => uint256) internal tokenBalanceLedger_;
145     mapping(address => uint256) internal referralBalance_;
146     mapping(address => int256) internal payoutsTo_;
147     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
148     uint256 internal tokenSupply_ = 0;
149     uint256 internal profitPerShare_;
150     
151     // administrator list (see above on what they can do)
152     mapping(bytes32 => bool) public administrators;
153     
154     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
155     bool public onlyAmbassadors = true;
156     
157 
158 
159     /*=======================================
160     =            PUBLIC FUNCTIONS            =
161     =======================================*/
162     /*
163     * -- APPLICATION ENTRY POINTS --  
164     */
165     function FART()
166         public
167     {
168         // add administrators here
169         //fuck admin! Drive it like you stole it!
170         
171 
172         // add the ambassadors here. 
173         ambassadors_[0x7e474fe5Cfb720804860215f407111183cbc2f85] = true; //K
174 
175 
176     }
177     
178      
179     /**
180      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
181      */
182     function buy(address _referredBy)
183         public
184         payable
185         returns(uint256)
186     {
187         purchaseTokens(msg.value, _referredBy);
188     }
189     
190     /**
191      * Fallback function to handle ethereum that was send straight to the contract
192      * Unfortunately we cannot use a referral address this way.
193      */
194     function()
195         payable
196         public
197     {
198         purchaseTokens(msg.value, 0x0);
199     }
200     
201     /**
202      * Converts all of caller's dividends to tokens.
203      */
204     function reinvest()
205         onlyStronghands()
206         public
207     {
208         // fetch dividends
209         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
210         
211         // pay out the dividends virtually
212         address _customerAddress = msg.sender;
213         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
214         
215         // retrieve ref. bonus
216         _dividends += referralBalance_[_customerAddress];
217         referralBalance_[_customerAddress] = 0;
218         
219         // dispatch a buy order with the virtualized "withdrawn dividends"
220         uint256 _tokens = purchaseTokens(_dividends, 0x0);
221         
222         // fire event
223         onReinvestment(_customerAddress, _dividends, _tokens);
224     }
225     
226     /**
227      * Alias of sell() and withdraw().
228      */
229     function exit()
230         public
231     {
232         // get token count for caller & sell them all
233         address _customerAddress = msg.sender;
234         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
235         if(_tokens > 0) sell(_tokens);
236         
237         // lambo delivery service
238         withdraw();
239     }
240 
241     /**
242      * Withdraws all of the callers earnings.
243      */
244     function withdraw()
245         onlyStronghands()
246         public
247     {
248         // setup data
249         address _customerAddress = msg.sender;
250         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
251         
252         // update dividend tracker
253         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
254         
255         // add ref. bonus
256         _dividends += referralBalance_[_customerAddress];
257         referralBalance_[_customerAddress] = 0;
258         
259         // lambo delivery service
260         _customerAddress.transfer(_dividends);
261         
262         // fire event
263         onWithdraw(_customerAddress, _dividends);
264     }
265     
266     /**
267      * Liquifies tokens to ethereum.
268      */
269     function sell(uint256 _amountOfTokens)
270         onlyBagholders()
271         public
272     {
273         // setup data
274         address _customerAddress = msg.sender;
275         // russian hackers BTFO
276         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
277         uint256 _tokens = _amountOfTokens;
278         uint256 _ethereum = tokensToEthereum_(_tokens);
279         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
280         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
281         
282         // burn the sold tokens
283         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
284         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
285         
286         // update dividends tracker
287         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
288         payoutsTo_[_customerAddress] -= _updatedPayouts;       
289         
290         // dividing by zero is a bad idea
291         if (tokenSupply_ > 0) {
292             // update the amount of dividends per token
293             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
294         }
295         
296         // fire event
297         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
298     }
299     
300     
301     /**
302      * Transfer tokens from the caller to a new holder.
303      * Remember, there's a 10% fee here as well.
304      */
305     function transfer(address _toAddress, uint256 _amountOfTokens)
306         onlyBagholders()
307         public
308         returns(bool)
309     {
310         // setup
311         address _customerAddress = msg.sender;
312         
313         // make sure we have the requested tokens
314         // also disables transfers until ambassador phase is over
315         // ( we dont want whale premines )
316         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
317         
318         // withdraw all outstanding dividends first
319         if(myDividends(true) > 0) withdraw();
320         
321         // liquify 10% of the tokens that are transfered
322         // these are dispersed to shareholders
323         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
324         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
325         uint256 _dividends = tokensToEthereum_(_tokenFee);
326   
327         // burn the fee tokens
328         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
329 
330         // exchange tokens
331         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
332         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
333         
334         // update dividend trackers
335         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
336         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
337         
338         // disperse dividends among holders
339         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
340         
341         // fire event
342         Transfer(_customerAddress, _toAddress, _taxedTokens);
343         
344         // ERC20
345         return true;
346        
347     }
348     
349     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
350     /**
351      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
352      */
353     function disableInitialStage()
354         onlyAdministrator()
355         public
356     {
357         onlyAmbassadors = false;
358     }
359     
360     /**
361      * In case one of us dies, we need to replace ourselves.
362      */
363     function setAdministrator(bytes32 _identifier, bool _status)
364         onlyAdministrator()
365         public
366     {
367         administrators[_identifier] = _status;
368     }
369     
370     /**
371      * Precautionary measures in case we need to adjust the masternode rate.
372      */
373     function setStakingRequirement(uint256 _amountOfTokens)
374         onlyAdministrator()
375         public
376     {
377         stakingRequirement = _amountOfTokens;
378     }
379     
380     /**
381      * If we want to rebrand, we can.
382      */
383     function setName(string _name)
384         onlyAdministrator()
385         public
386     {
387         name = _name;
388     }
389     
390     /**
391      * If we want to rebrand, we can.
392      */
393     function setSymbol(string _symbol)
394         onlyAdministrator()
395         public
396     {
397         symbol = _symbol;
398     }
399 
400     
401     /*----------  HELPERS AND CALCULATORS  ----------*/
402     /**
403      * Method to view the current Ethereum stored in the contract
404      * Example: totalEthereumBalance()
405      */
406     function totalEthereumBalance()
407         public
408         view
409         returns(uint)
410     {
411         return address (this).balance;
412     }
413     
414     /**
415      * Retrieve the total token supply.
416      */
417     function totalSupply()
418         public
419         view
420         returns(uint256)
421     {
422         return tokenSupply_;
423     }
424     
425     /**
426      * Retrieve the tokens owned by the caller.
427      */
428     function myTokens()
429         public
430         view
431         returns(uint256)
432     {
433         address _customerAddress = msg.sender;
434         return balanceOf(_customerAddress);
435     }
436     
437     /**
438      * Retrieve the dividends owned by the caller.
439      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
440      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
441      * But in the internal calculations, we want them separate. 
442      */ 
443     function myDividends(bool _includeReferralBonus) 
444         public 
445         view 
446         returns(uint256)
447     {
448         address _customerAddress = msg.sender;
449         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
450     }
451     
452     /**
453      * Retrieve the token balance of any single address.
454      */
455     function balanceOf(address _customerAddress)
456         view
457         public
458         returns(uint256)
459     {
460         return tokenBalanceLedger_[_customerAddress];
461     }
462     
463     /**
464      * Retrieve the dividend balance of any single address.
465      */
466     function dividendsOf(address _customerAddress)
467         view
468         public
469         returns(uint256)
470     {
471         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
472     }
473     
474     /**
475      * Return the buy price of 1 individual token.
476      */
477     function sellPrice() 
478         public 
479         view 
480         returns(uint256)
481     {
482         // our calculation relies on the token supply, so we need supply. Doh.
483         if(tokenSupply_ == 0){
484             return tokenPriceInitial_ - tokenPriceIncremental_;
485         } else {
486             uint256 _ethereum = tokensToEthereum_(1e18);
487             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
488             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
489             return _taxedEthereum;
490         }
491     }
492     
493     /**
494      * Return the sell price of 1 individual token.
495      */
496     function buyPrice() 
497         public 
498         view 
499         returns(uint256)
500     {
501         // our calculation relies on the token supply, so we need supply. Doh.
502         if(tokenSupply_ == 0){
503             return tokenPriceInitial_ + tokenPriceIncremental_;
504         } else {
505             uint256 _ethereum = tokensToEthereum_(1e18);
506             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
507             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
508             return _taxedEthereum;
509         }
510     }
511     
512     /**
513      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
514      */
515     function calculateTokensReceived(uint256 _ethereumToSpend) 
516         public 
517         view 
518         returns(uint256)
519     {
520         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
521         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
522         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
523         
524         return _amountOfTokens;
525     }
526     
527     /**
528      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
529      */
530     function calculateEthereumReceived(uint256 _tokensToSell) 
531         public 
532         view 
533         returns(uint256)
534     {
535         require(_tokensToSell <= tokenSupply_);
536         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
537         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
538         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
539         return _taxedEthereum;
540     }
541     
542     
543     /*==========================================
544     =            INTERNAL FUNCTIONS            =
545     ==========================================*/
546     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
547         antiEarlyWhale(_incomingEthereum)
548         internal
549         returns(uint256)
550     {
551         // data setup
552         address _customerAddress = msg.sender;
553         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
554         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
555         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
556         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
557         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
558         uint256 _fee = _dividends * magnitude;
559  
560         // no point in continuing execution if OP is a poorfag russian hacker
561         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
562         // (or hackers)
563         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
564         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
565         
566         // is the user referred by a masternode?
567         if(
568             // is this a referred purchase?
569             _referredBy != 0x0000000000000000000000000000000000000000 &&
570 
571             // no cheating!
572             _referredBy != _customerAddress &&
573             
574             // does the referrer have at least X whole tokens?
575             // i.e is the referrer a godly chad masternode
576             tokenBalanceLedger_[_referredBy] >= stakingRequirement
577         ){
578             // wealth redistribution
579             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
580         } else {
581             // no ref purchase
582             // add the referral bonus back to the global dividends cake
583             _dividends = SafeMath.add(_dividends, _referralBonus);
584             _fee = _dividends * magnitude;
585         }
586         
587         // we can't give people infinite ethereum
588         if(tokenSupply_ > 0){
589             
590             // add tokens to the pool
591             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
592  
593             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
594             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
595             
596             // calculate the amount of tokens the customer receives over his purchase 
597             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
598         
599         } else {
600             // add tokens to the pool
601             tokenSupply_ = _amountOfTokens;
602         }
603         
604         // update circulating supply & the ledger address for the customer
605         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
606         
607         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
608         //really i know you think you do but you don't
609         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
610         payoutsTo_[_customerAddress] += _updatedPayouts;
611         
612         // fire event
613         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
614         
615         return _amountOfTokens;
616     }
617 
618     /**
619      * Calculate Token price based on an amount of incoming ethereum
620      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
621      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
622      */
623     function ethereumToTokens_(uint256 _ethereum)
624         internal
625         view
626         returns(uint256)
627     {
628         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
629         uint256 _tokensReceived = 
630          (
631             (
632                 // underflow attempts BTFO
633                 SafeMath.sub(
634                     (sqrt
635                         (
636                             (_tokenPriceInitial**2)
637                             +
638                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
639                             +
640                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
641                             +
642                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
643                         )
644                     ), _tokenPriceInitial
645                 )
646             )/(tokenPriceIncremental_)
647         )-(tokenSupply_)
648         ;
649   
650         return _tokensReceived;
651     }
652     
653     /**
654      * Calculate token sell value.
655      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
656      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
657      */
658      function tokensToEthereum_(uint256 _tokens)
659         internal
660         view
661         returns(uint256)
662     {
663 
664         uint256 tokens_ = (_tokens + 1e18);
665         uint256 _tokenSupply = (tokenSupply_ + 1e18);
666         uint256 _etherReceived =
667         (
668             // underflow attempts BTFO
669             SafeMath.sub(
670                 (
671                     (
672                         (
673                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
674                         )-tokenPriceIncremental_
675                     )*(tokens_ - 1e18)
676                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
677             )
678         /1e18);
679         return _etherReceived;
680     }
681     
682     
683     //This is where all your gas goes, sorry
684     //Not sorry, you probably only paid 1 gwei
685     function sqrt(uint x) internal pure returns (uint y) {
686         uint z = (x + 1) / 2;
687         y = x;
688         while (z < y) {
689             y = z;
690             z = (x / z + z) / 2;
691         }
692     }
693 }
694 
695 /**
696  * @title SafeMath
697  * @dev Math operations with safety checks that throw on error
698  */
699 library SafeMath {
700 
701     /**
702     * @dev Multiplies two numbers, throws on overflow.
703     */
704     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
705         if (a == 0) {
706             return 0;
707         }
708         uint256 c = a * b;
709         assert(c / a == b);
710         return c;
711     }
712 
713     /**
714     * @dev Integer division of two numbers, truncating the quotient.
715     */
716     function div(uint256 a, uint256 b) internal pure returns (uint256) {
717         // assert(b > 0); // Solidity automatically throws when dividing by 0
718         uint256 c = a / b;
719         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
720         return c;
721     }
722 
723     /**
724     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
725     */
726     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
727         assert(b <= a);
728         return a - b;
729     }
730 
731     /**
732     * @dev Adds two numbers, throws on overflow.
733     */
734     function add(uint256 a, uint256 b) internal pure returns (uint256) {
735         uint256 c = a + b;
736         assert(c >= a);
737         return c;
738     }
739 }