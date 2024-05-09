1 pragma solidity ^0.4.20;
2 
3 /*
4 * ====================================*
5 * Team Power2X presents..
6 * ====================================*
7 *
8 * Built by trusted community members
9 * Power2X, an approved PoWH3D Pyrmid                         
10 *
11 * ====================================*
12 * ====================================*
13 */
14 
15 contract Power2X {
16     /*=================================
17     =            MODIFIERS            =
18     =================================*/
19     // only people with tokens
20     modifier onlyBagholders() {
21         require(myTokens() > 0);
22         _;
23     }
24     
25     // only people with profits
26     modifier onlyStronghands() {
27         require(myDividends(true) > 0);
28         _;
29     }
30     
31     // administrators can:
32     // -> change the name of the contract
33     // -> change the name of the token
34     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
35     // they CANNOT:
36     // -> take funds
37     // -> disable withdrawals
38     // -> kill the contract
39     // -> change the price of tokens
40     modifier onlyAdministrator(){
41         address _customerAddress = msg.sender;
42         require(administrators[_customerAddress]);
43         _;
44     }
45     
46     
47     // ensures that the first tokens in the contract will be equally distributed
48     // meaning, no divine dump will be ever possible
49     // result: healthy longevity.
50     modifier antiEarlyWhale(uint256 _amountOfEthereum){
51         address _customerAddress = msg.sender;
52         
53         // are we still in the vulnerable phase?
54         // if so, enact anti early whale protocol 
55         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
56             require(
57                 // is the customer in the ambassador list?
58                 ambassadors_[_customerAddress] == true &&
59                 
60                 // does the customer purchase exceed the max ambassador quota?
61                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
62                 
63             );
64             
65             // updated the accumulated quota    
66             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
67         
68             // execute
69             _;
70         } else {
71             // in case the ether count drops low, the ambassador phase won't reinitiate
72             onlyAmbassadors = false;
73             _;    
74         }
75         
76     }
77     
78     
79     /*==============================
80     =            EVENTS            =
81     ==============================*/
82     event onTokenPurchase(
83         address indexed customerAddress,
84         uint256 incomingEthereum,
85         uint256 tokensMinted,
86         address indexed referredBy
87     );
88     
89     event onTokenSell(
90         address indexed customerAddress,
91         uint256 tokensBurned,
92         uint256 ethereumEarned
93     );
94     
95     event onReinvestment(
96         address indexed customerAddress,
97         uint256 ethereumReinvested,
98         uint256 tokensMinted
99     );
100     
101     event onWithdraw(
102         address indexed customerAddress,
103         uint256 ethereumWithdrawn
104     );
105     
106     // ERC20
107     event Transfer(
108         address indexed from,
109         address indexed to,
110         uint256 tokens
111     );
112     
113     
114     /*=====================================
115     =            CONFIGURABLES            =
116     =====================================*/
117     string public name = "Power2X";
118     string public symbol = "P2X";
119     uint8 constant public decimals = 18;
120     uint8 constant internal dividendFee_ = 10;
121     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
122     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
123     uint256 constant internal magnitude = 2**64;
124     
125     // proof of stake (defaults at 100 tokens)
126     uint256 public stakingRequirement = 100e18;
127     
128     // ambassador program
129     mapping(address => bool) internal ambassadors_;
130     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
131     uint256 constant internal ambassadorQuota_ = 20 ether;
132     
133     
134     
135    /*================================
136     =            DATASETS            =
137     ================================*/
138     // amount of shares for each address (scaled number)
139     mapping(address => uint256) internal tokenBalanceLedger_;
140     mapping(address => uint256) internal referralBalance_;
141     mapping(address => int256) internal payoutsTo_;
142     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
143     uint256 internal tokenSupply_ = 0;
144     uint256 internal profitPerShare_;
145     
146     // administrator list (see above on what they can do)
147     mapping(address => bool) public administrators;
148     
149     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
150     bool public onlyAmbassadors = true;
151     
152 
153 
154     /*=======================================
155     =            PUBLIC FUNCTIONS            =
156     =======================================*/
157     /*
158     * -- APPLICATION ENTRY POINTS --  
159     */
160     function Power2X()
161         public
162     {
163         // add administrators here
164         administrators[0x52F798Ec5fCceB79a4FecF3d5CD1759a7313Af8D] = true;
165         
166         // add the ambassadors here.
167         // web dev 
168         ambassadors_[0x5728C8549a224bb0ea937D64a216DD21fB081993] = true;
169         
170         // Management (adverts, feedbacks, social media)
171         ambassadors_[0x1799F4C7c074F141f664f2d315CAD5919c1305da] = true;
172         
173         // Further R&D 
174         ambassadors_[0xc9C7843353E40Ae31c38e82462b9D0587Cf83ebE] = true;
175         
176         // Investment Funds
177         ambassadors_[0xD90f5277bb12162E571F656c24772Fc76bDF1898] = true;
178         
179 
180     }
181     
182      
183     /**
184      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
185      */
186     function buy(address _referredBy)
187         public
188         payable
189         returns(uint256)
190     {
191         purchaseTokens(msg.value, _referredBy);
192     }
193     
194     /**
195      * Fallback function to handle ethereum that was send straight to the contract
196      * Unfortunately we cannot use a referral address this way.
197      */
198     function()
199         payable
200         public
201     {
202         purchaseTokens(msg.value, 0x0);
203     }
204     
205     /**
206      * Converts all of caller's dividends to tokens.
207      */
208     function reinvest()
209         onlyStronghands()
210         public
211     {
212         // fetch dividends
213         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
214         
215         // pay out the dividends virtually
216         address _customerAddress = msg.sender;
217         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
218         
219         // retrieve ref. bonus
220         _dividends += referralBalance_[_customerAddress];
221         referralBalance_[_customerAddress] = 0;
222         
223         // dispatch a buy order with the virtualized "withdrawn dividends"
224         uint256 _tokens = purchaseTokens(_dividends, 0x0);
225         
226         // fire event
227         onReinvestment(_customerAddress, _dividends, _tokens);
228     }
229     
230     /**
231      * Alias of sell() and withdraw().
232      */
233     function exit()
234         public
235     {
236         // get token count for caller & sell them all
237         address _customerAddress = msg.sender;
238         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
239         if(_tokens > 0) sell(_tokens);
240         
241         // lambo delivery service
242         withdraw();
243     }
244 
245     /**
246      * Withdraws all of the callers earnings.
247      */
248     function withdraw()
249         onlyStronghands()
250         public
251     {
252         // setup data
253         address _customerAddress = msg.sender;
254         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
255         
256         // update dividend tracker
257         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
258         
259         // add ref. bonus
260         _dividends += referralBalance_[_customerAddress];
261         referralBalance_[_customerAddress] = 0;
262         
263         // lambo delivery service
264         _customerAddress.transfer(_dividends);
265         
266         // fire event
267         onWithdraw(_customerAddress, _dividends);
268     }
269     
270     /**
271      * Liquifies tokens to ethereum.
272      */
273     function sell(uint256 _amountOfTokens)
274         onlyBagholders()
275         public
276     {
277         // setup data
278         address _customerAddress = msg.sender;
279         // russian hackers BTFO
280         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
281         uint256 _tokens = _amountOfTokens;
282         uint256 _ethereum = tokensToEthereum_(_tokens);
283         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
284         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
285         
286         // burn the sold tokens
287         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
288         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
289         
290         // update dividends tracker
291         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
292         payoutsTo_[_customerAddress] -= _updatedPayouts;       
293         
294         // dividing by zero is a bad idea
295         if (tokenSupply_ > 0) {
296             // update the amount of dividends per token
297             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
298         }
299         
300         // fire event
301         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
302     }
303     
304     
305     /**
306      * Transfer tokens from the caller to a new holder.
307      * Remember, there's a 10% fee here as well.
308      */
309     function transfer(address _toAddress, uint256 _amountOfTokens)
310         onlyBagholders()
311         public
312         returns(bool)
313     {
314         // setup
315         address _customerAddress = msg.sender;
316         
317         // make sure we have the requested tokens
318         // also disables transfers until ambassador phase is over
319         // ( we dont want whale premines )
320         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
321         
322         // withdraw all outstanding dividends first
323         if(myDividends(true) > 0) withdraw();
324         
325         // liquify 10% of the tokens that are transfered
326         // these are dispersed to shareholders
327         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
328         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
329         uint256 _dividends = tokensToEthereum_(_tokenFee);
330   
331         // burn the fee tokens
332         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
333 
334         // exchange tokens
335         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
336         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
337         
338         // update dividend trackers
339         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
340         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
341         
342         // disperse dividends among holders
343         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
344         
345         // fire event
346         Transfer(_customerAddress, _toAddress, _taxedTokens);
347         
348         // ERC20
349         return true;
350        
351     }
352     
353     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
354     /**
355      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
356      */
357     function disableInitialStage()
358         onlyAdministrator()
359         public
360     {
361         onlyAmbassadors = false;
362     }
363     
364     /**
365      * In case one of us dies, we need to replace ourselves.
366      */
367     function setAdministrator(address _identifier, bool _status)
368         onlyAdministrator()
369         public
370     {
371         administrators[_identifier] = _status;
372     }
373     
374     /**
375      * Precautionary measures in case we need to adjust the masternode rate.
376      */
377     function setStakingRequirement(uint256 _amountOfTokens)
378         onlyAdministrator()
379         public
380     {
381         stakingRequirement = _amountOfTokens;
382     }
383     
384     /**
385      * If we want to rebrand, we can.
386      */
387     function setName(string _name)
388         onlyAdministrator()
389         public
390     {
391         name = _name;
392     }
393     
394     /**
395      * If we want to rebrand, we can.
396      */
397     function setSymbol(string _symbol)
398         onlyAdministrator()
399         public
400     {
401         symbol = _symbol;
402     }
403 
404     
405     /*----------  HELPERS AND CALCULATORS  ----------*/
406     /**
407      * Method to view the current Ethereum stored in the contract
408      * Example: totalEthereumBalance()
409      */
410     function totalEthereumBalance()
411         public
412         view
413         returns(uint)
414     {
415         return this.balance;
416     }
417     
418     /**
419      * Retrieve the total token supply.
420      */
421     function totalSupply()
422         public
423         view
424         returns(uint256)
425     {
426         return tokenSupply_;
427     }
428     
429     /**
430      * Retrieve the tokens owned by the caller.
431      */
432     function myTokens()
433         public
434         view
435         returns(uint256)
436     {
437         address _customerAddress = msg.sender;
438         return balanceOf(_customerAddress);
439     }
440     
441     /**
442      * Retrieve the dividends owned by the caller.
443      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
444      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
445      * But in the internal calculations, we want them separate. 
446      */ 
447     function myDividends(bool _includeReferralBonus) 
448         public 
449         view 
450         returns(uint256)
451     {
452         address _customerAddress = msg.sender;
453         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
454     }
455     
456     /**
457      * Retrieve the token balance of any single address.
458      */
459     function balanceOf(address _customerAddress)
460         view
461         public
462         returns(uint256)
463     {
464         return tokenBalanceLedger_[_customerAddress];
465     }
466     
467     /**
468      * Retrieve the dividend balance of any single address.
469      */
470     function dividendsOf(address _customerAddress)
471         view
472         public
473         returns(uint256)
474     {
475         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
476     }
477     
478     /**
479      * Return the buy price of 1 individual token.
480      */
481     function sellPrice() 
482         public 
483         view 
484         returns(uint256)
485     {
486         // our calculation relies on the token supply, so we need supply. Doh.
487         if(tokenSupply_ == 0){
488             return tokenPriceInitial_ - tokenPriceIncremental_;
489         } else {
490             uint256 _ethereum = tokensToEthereum_(1e18);
491             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
492             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
493             return _taxedEthereum;
494         }
495     }
496     
497     /**
498      * Return the sell price of 1 individual token.
499      */
500     function buyPrice() 
501         public 
502         view 
503         returns(uint256)
504     {
505         // our calculation relies on the token supply, so we need supply. Doh.
506         if(tokenSupply_ == 0){
507             return tokenPriceInitial_ + tokenPriceIncremental_;
508         } else {
509             uint256 _ethereum = tokensToEthereum_(1e18);
510             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
511             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
512             return _taxedEthereum;
513         }
514     }
515     
516     /**
517      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
518      */
519     function calculateTokensReceived(uint256 _ethereumToSpend) 
520         public 
521         view 
522         returns(uint256)
523     {
524         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
525         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
526         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
527         
528         return _amountOfTokens;
529     }
530     
531     /**
532      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
533      */
534     function calculateEthereumReceived(uint256 _tokensToSell) 
535         public 
536         view 
537         returns(uint256)
538     {
539         require(_tokensToSell <= tokenSupply_);
540         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
541         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
542         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
543         return _taxedEthereum;
544     }
545     
546     
547     /*==========================================
548     =            INTERNAL FUNCTIONS            =
549     ==========================================*/
550     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
551         antiEarlyWhale(_incomingEthereum)
552         internal
553         returns(uint256)
554     {
555         // data setup
556         address _customerAddress = msg.sender;
557         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
558         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
559         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
560         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
561         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
562         uint256 _fee = _dividends * magnitude;
563  
564         // no point in continuing execution if OP is a poorfag russian hacker
565         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
566         // (or hackers)
567         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
568         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
569         
570         // is the user referred by a masternode?
571         if(
572             // is this a referred purchase?
573             _referredBy != 0x0000000000000000000000000000000000000000 &&
574 
575             // no cheating!
576             _referredBy != _customerAddress &&
577             
578             // does the referrer have at least X whole tokens?
579             // i.e is the referrer a godly chad masternode
580             tokenBalanceLedger_[_referredBy] >= stakingRequirement
581         ){
582             // wealth redistribution
583             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
584         } else {
585             // no ref purchase
586             // add the referral bonus back to the global dividends cake
587             _dividends = SafeMath.add(_dividends, _referralBonus);
588             _fee = _dividends * magnitude;
589         }
590         
591         // we can't give people infinite ethereum
592         if(tokenSupply_ > 0){
593             
594             // add tokens to the pool
595             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
596  
597             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
598             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
599             
600             // calculate the amount of tokens the customer receives over his purchase 
601             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
602         
603         } else {
604             // add tokens to the pool
605             tokenSupply_ = _amountOfTokens;
606         }
607         
608         // update circulating supply & the ledger address for the customer
609         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
610         
611         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
612         //really i know you think you do but you don't
613         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
614         payoutsTo_[_customerAddress] += _updatedPayouts;
615         
616         // fire event
617         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
618         
619         return _amountOfTokens;
620     }
621 
622     /**
623      * Calculate Token price based on an amount of incoming ethereum
624      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
625      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
626      */
627     function ethereumToTokens_(uint256 _ethereum)
628         internal
629         view
630         returns(uint256)
631     {
632         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
633         uint256 _tokensReceived = 
634          (
635             (
636                 // underflow attempts BTFO
637                 SafeMath.sub(
638                     (sqrt
639                         (
640                             (_tokenPriceInitial**2)
641                             +
642                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
643                             +
644                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
645                             +
646                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
647                         )
648                     ), _tokenPriceInitial
649                 )
650             )/(tokenPriceIncremental_)
651         )-(tokenSupply_)
652         ;
653   
654         return _tokensReceived;
655     }
656     
657     /**
658      * Calculate token sell value.
659      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
660      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
661      */
662      function tokensToEthereum_(uint256 _tokens)
663         internal
664         view
665         returns(uint256)
666     {
667 
668         uint256 tokens_ = (_tokens + 1e18);
669         uint256 _tokenSupply = (tokenSupply_ + 1e18);
670         uint256 _etherReceived =
671         (
672             // underflow attempts BTFO
673             SafeMath.sub(
674                 (
675                     (
676                         (
677                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
678                         )-tokenPriceIncremental_
679                     )*(tokens_ - 1e18)
680                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
681             )
682         /1e18);
683         return _etherReceived;
684     }
685     
686     
687     //This is where all your gas goes, sorry
688     //Not sorry, you probably only paid 1 gwei
689     function sqrt(uint x) internal pure returns (uint y) {
690         uint z = (x + 1) / 2;
691         y = x;
692         while (z < y) {
693             y = z;
694             z = (x / z + z) / 2;
695         }
696     }
697 }
698 
699 /**
700  * @title SafeMath
701  * @dev Math operations with safety checks that throw on error
702  */
703 library SafeMath {
704 
705     /**
706     * @dev Multiplies two numbers, throws on overflow.
707     */
708     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
709         if (a == 0) {
710             return 0;
711         }
712         uint256 c = a * b;
713         assert(c / a == b);
714         return c;
715     }
716 
717     /**
718     * @dev Integer division of two numbers, truncating the quotient.
719     */
720     function div(uint256 a, uint256 b) internal pure returns (uint256) {
721         // assert(b > 0); // Solidity automatically throws when dividing by 0
722         uint256 c = a / b;
723         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
724         return c;
725     }
726 
727     /**
728     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
729     */
730     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
731         assert(b <= a);
732         return a - b;
733     }
734 
735     /**
736     * @dev Adds two numbers, throws on overflow.
737     */
738     function add(uint256 a, uint256 b) internal pure returns (uint256) {
739         uint256 c = a + b;
740         assert(c >= a);
741         return c;
742     }
743 }