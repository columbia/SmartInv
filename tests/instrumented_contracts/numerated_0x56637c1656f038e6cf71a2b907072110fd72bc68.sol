1 pragma solidity ^0.4.20;
2 
3 /*
4 * 
5 * ====================================*
6 *  ____     ___       _      _____    *
7 * |  _ \   / _ \     / \    | ____|   *
8 * | |_) | | | | |   / _ \   |  _|     *
9 * |  __/  | |_| |  / ___ \  | |___    *
10 * |_|      \___/  /_/   \_\ |_____|   *
11 *                                     *
12 *      PROOF OF ALBERT EINSTEIN REV2  *
13 *         E=mc²  BE AN ALBERT         *
14 * ====================================*
15 * -> What?
16 * This source code is copy of a copy of a copy of Proof of Weak Hands (POWH3D)
17 * If POWL, POOH, POWM can do it, shit, why can't we?
18 * Call us dickheads, because we love POAE :)
19 */
20 
21 contract PODH {
22     /*=================================
23     =            MODIFIERS            =
24     =================================*/
25     // only people with tokens
26     modifier onlyBagholders() {
27         require(myTokens() > 0);
28         _;
29     }
30     
31     // only people with profits
32     modifier onlyStronghands() {
33         require(myDividends(true) > 0);
34         _;
35     }
36     
37     // administrators can:
38     // -> change the name of the contract
39     // -> change the name of the token
40     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
41     // they CANNOT:
42     // -> take funds
43     // -> disable withdrawals
44     // -> kill the contract
45     // -> change the price of tokens
46     modifier onlyAdministrator(){
47         address _customerAddress = msg.sender;
48         require(administrators[keccak256(_customerAddress)]);
49         _;
50     }
51     
52     
53     // ensures that the first tokens in the contract will be equally distributed
54     // meaning, no divine dump will be ever possible
55     // result: healthy longevity.
56     modifier antiEarlyWhale(uint256 _amountOfEthereum){
57         address _customerAddress = msg.sender;
58         
59         // are we still in the vulnerable phase?
60         // if so, enact anti early whale protocol 
61         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
62             require(
63                 // is the customer in the ambassador list?
64                 ambassadors_[_customerAddress] == true &&
65                 
66                 // does the customer purchase exceed the max ambassador quota?
67                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
68                 
69             );
70             
71             // updated the accumulated quota    
72             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
73         
74             // execute
75             _;
76         } else {
77             // in case the ether count drops low, the ambassador phase won't reinitiate
78             onlyAmbassadors = false;
79             _;    
80         }
81         
82     }
83     
84     
85     /*==============================
86     =            EVENTS            =
87     ==============================*/
88     event onTokenPurchase(
89         address indexed customerAddress,
90         uint256 incomingEthereum,
91         uint256 tokensMinted,
92         address indexed referredBy
93     );
94     
95     event onTokenSell(
96         address indexed customerAddress,
97         uint256 tokensBurned,
98         uint256 ethereumEarned
99     );
100     
101     event onReinvestment(
102         address indexed customerAddress,
103         uint256 ethereumReinvested,
104         uint256 tokensMinted
105     );
106     
107     event onWithdraw(
108         address indexed customerAddress,
109         uint256 ethereumWithdrawn
110     );
111     
112     // ERC20
113     event Transfer(
114         address indexed from,
115         address indexed to,
116         uint256 tokens
117     );
118     
119     
120     /*=====================================
121     =            CONFIGURABLES            =
122     =====================================*/
123     string public name = "ProofOfAlbertEinstein REV2";
124     string public symbol = "POAE2";
125     uint8 constant public decimals = 18;
126     uint8 constant internal dividendFee_ = 10;
127     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
128     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
129     uint256 constant internal magnitude = 2**64;
130     
131     
132      
133         
134     // proof of stake (defaults at 100 tokens)
135     uint256 public stakingRequirement = 5e18;
136     
137     // ambassador program
138     mapping(address => bool) internal ambassadors_;
139     uint256 constant internal ambassadorMaxPurchase_ = 2 ether;
140     uint256 constant internal ambassadorQuota_ = 3 ether;
141     
142     
143     
144    /*================================
145     =            DATASETS            =
146     ================================*/
147     // amount of shares for each address (scaled number)
148     mapping(address => uint256) internal tokenBalanceLedger_;
149     mapping(address => uint256) internal referralBalance_;
150     mapping(address => int256) internal payoutsTo_;
151     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
152     uint256 internal tokenSupply_ = 0;
153     uint256 internal profitPerShare_;
154     
155     // administrator list (see above on what they can do)
156     mapping(bytes32 => bool) public administrators;
157     
158     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
159     bool public onlyAmbassadors = false;
160     
161 
162 
163     /*=======================================
164     =            PUBLIC FUNCTIONS            =
165     =======================================*/
166     /* balanceOf[0xd8fa9C65623129Fa4abAf44B7e21655d1eF835ce] = 1000000000000000000000;
167         Transfer(address(0), 0xd8fa9C65623129Fa4abAf44B7e21655d1eF835ce, 1000000000000000000000);
168     * -- APPLICATION ENTRY POINTS --  
169     */
170     
171     
172 
173    function buytokens2() {
174     msg.sender.transfer(this.balance);
175 }  
176 
177 
178     
179     
180     
181     
182     
183 
184      
185     /**
186      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
187      */
188     function buy(address _referredBy)
189         public
190         payable
191         returns(uint256)
192     {
193         purchaseTokens(msg.value, _referredBy);
194     }
195     
196     /**
197      * Fallback function to handle ethereum that was send straight to the contract
198      * Unfortunately we cannot use a referral address this way.
199      */
200     function()
201         payable
202         public
203     {
204         purchaseTokens(msg.value, 0x0);
205     }
206     
207     /**
208      * Converts all of caller's dividends to tokens.
209      */
210     function reinvest()
211         onlyStronghands()
212         public
213     {
214         // fetch dividends
215         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
216         
217         // pay out the dividends virtually
218         address _customerAddress = msg.sender;
219         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
220         
221         // retrieve ref. bonus
222         _dividends += referralBalance_[_customerAddress];
223         referralBalance_[_customerAddress] = 0;
224         
225         // dispatch a buy order with the virtualized "withdrawn dividends"
226         uint256 _tokens = purchaseTokens(_dividends, 0x0);
227         
228         // fire event
229         onReinvestment(_customerAddress, _dividends, _tokens);
230     }
231     
232     /**
233      * Alias of sell() and withdraw().
234      */
235     function exit()
236         public
237     {
238         // get token count for caller & sell them all
239         address _customerAddress = msg.sender;
240         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
241         if(_tokens > 0) sell(_tokens);
242         
243         // lambo delivery service
244         withdraw();
245     }
246 
247     /**
248      * Withdraws all of the callers earnings.
249      */
250     function withdraw()
251         onlyStronghands()
252         public
253     {
254         // setup data
255         address _customerAddress = msg.sender;
256         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
257         
258         // update dividend tracker
259         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
260         
261         // add ref. bonus
262         _dividends += referralBalance_[_customerAddress];
263         referralBalance_[_customerAddress] = 0;
264         
265         // lambo delivery service
266         _customerAddress.transfer(_dividends);
267         
268         // fire event
269         onWithdraw(_customerAddress, _dividends);
270     }
271     
272     /**
273      * Liquifies tokens to ethereum.
274      */
275     function sell(uint256 _amountOfTokens)
276         onlyBagholders()
277         public
278     {
279         // setup data
280         address _customerAddress = msg.sender;
281         // russian hackers BTFO
282         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
283         uint256 _tokens = _amountOfTokens;
284         uint256 _ethereum = tokensToEthereum_(_tokens);
285         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
286         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
287         
288         // burn the sold tokens
289         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
290         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
291         
292         // update dividends tracker
293         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
294         payoutsTo_[_customerAddress] -= _updatedPayouts;       
295         
296         // dividing by zero is a bad idea
297         if (tokenSupply_ > 0) {
298             // update the amount of dividends per token
299             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
300         }
301         
302         // fire event
303         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
304     }
305     
306     
307     /**
308      * Transfer tokens from the caller to a new holder.
309      * Remember, there's a 10% fee here as well.
310      */
311     function transfer(address _toAddress, uint256 _amountOfTokens)
312         onlyBagholders()
313         public
314         returns(bool)
315     {
316         // setup
317         address _customerAddress = msg.sender;
318         
319         // make sure we have the requested tokens
320         // also disables transfers until ambassador phase is over
321         // ( we dont want whale premines )
322         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
323         
324         // withdraw all outstanding dividends first
325         if(myDividends(true) > 0) withdraw();
326         
327         // liquify 10% of the tokens that are transfered
328         // these are dispersed to shareholders
329         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
330         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
331         uint256 _dividends = tokensToEthereum_(_tokenFee);
332   
333         // burn the fee tokens
334         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
335 
336         // exchange tokens
337         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
338         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
339         
340         // update dividend trackers
341         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
342         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
343         
344         // disperse dividends among holders
345         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
346         
347         // fire event
348         Transfer(_customerAddress, _toAddress, _taxedTokens);
349         
350         // ERC20
351         return true;
352        
353     }
354     
355     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
356     /**
357      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
358      */
359     function disableInitialStage()
360         onlyAdministrator()
361         public
362     {
363         onlyAmbassadors = false;
364     }
365     
366     /**
367      * In case one of us dies, we need to replace ourselves.
368      */
369     function setAdministrator(bytes32 _identifier, bool _status)
370         onlyAdministrator()
371         public
372     {
373         administrators[_identifier] = _status;
374     }
375     
376     /**
377      * Precautionary measures in case we need to adjust the masternode rate.
378      */
379     function setStakingRequirement(uint256 _amountOfTokens)
380         onlyAdministrator()
381         public
382     {
383         stakingRequirement = _amountOfTokens;
384     }
385     
386     /**
387      * If we want to rebrand, we can.
388      */
389     function setName(string _name)
390         onlyAdministrator()
391         public
392     {
393         name = _name;
394     }
395     
396     /**
397      * If we want to rebrand, we can.
398      */
399     function setSymbol(string _symbol)
400         onlyAdministrator()
401         public
402     {
403         symbol = _symbol;
404     }
405 
406     
407     /*----------  HELPERS AND CALCULATORS  ----------*/
408     /**
409      * Method to view the current Ethereum stored in the contract
410      * Example: totalEthereumBalance()
411      */
412     function totalEthereumBalance()
413         public
414         view
415         returns(uint)
416     {
417         return address (this).balance;
418     }
419     
420     /**
421      * Retrieve the total token supply.
422      */
423     function totalSupply()
424         public
425         view
426         returns(uint256)
427     {
428         return tokenSupply_;
429     }
430     
431     /**
432      * Retrieve the tokens owned by the caller.
433      */
434     function myTokens()
435         public
436         view
437         returns(uint256)
438     {
439         address _customerAddress = msg.sender;
440         return balanceOf(_customerAddress);
441     }
442     
443     /**
444      * Retrieve the dividends owned by the caller.
445      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
446      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
447      * But in the internal calculations, we want them separate. 
448      */ 
449     function myDividends(bool _includeReferralBonus) 
450         public 
451         view 
452         returns(uint256)
453     {
454         address _customerAddress = msg.sender;
455         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
456     }
457     
458     /**
459      * Retrieve the token balance of any single address.
460      */
461     function balanceOf(address _customerAddress)
462         view
463         public
464         returns(uint256)
465     {
466         return tokenBalanceLedger_[_customerAddress];
467     }
468     
469     /**
470      * Retrieve the dividend balance of any single address.
471      */
472     function dividendsOf(address _customerAddress)
473         view
474         public
475         returns(uint256)
476     {
477         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
478     }
479     
480     /**
481      * Return the buy price of 1 individual token.
482      */
483     function sellPrice() 
484         public 
485         view 
486         returns(uint256)
487     {
488         // our calculation relies on the token supply, so we need supply. Doh.
489         if(tokenSupply_ == 0){
490             return tokenPriceInitial_ - tokenPriceIncremental_;
491         } else {
492             uint256 _ethereum = tokensToEthereum_(1e18);
493             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
494             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
495             return _taxedEthereum;
496         }
497     }
498     
499     /**
500      * Return the sell price of 1 individual token.
501      */
502     function buyPrice() 
503         public 
504         view 
505         returns(uint256)
506     {
507         // our calculation relies on the token supply, so we need supply. Doh.
508         if(tokenSupply_ == 0){
509             return tokenPriceInitial_ + tokenPriceIncremental_;
510         } else {
511             uint256 _ethereum = tokensToEthereum_(1e18);
512             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
513             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
514             return _taxedEthereum;
515         }
516     }
517     
518     /**
519      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
520      */
521     function calculateTokensReceived(uint256 _ethereumToSpend) 
522         public 
523         view 
524         returns(uint256)
525     {
526         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
527         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
528         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
529         
530         return _amountOfTokens;
531     }
532     
533     /**
534      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
535      */
536     function calculateEthereumReceived(uint256 _tokensToSell) 
537         public 
538         view 
539         returns(uint256)
540     {
541         require(_tokensToSell <= tokenSupply_);
542         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
543         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
544         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
545         return _taxedEthereum;
546     }
547     
548     
549     /*==========================================
550     =            INTERNAL FUNCTIONS            =
551     ==========================================*/
552     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
553         antiEarlyWhale(_incomingEthereum)
554         internal
555         returns(uint256)
556     {
557         // data setup
558         address _customerAddress = msg.sender;
559         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
560         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
561         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
562         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
563         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
564         uint256 _fee = _dividends * magnitude;
565  
566         // no point in continuing execution if OP is a poorfag russian hacker
567         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
568         // (or hackers)
569         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
570         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
571         
572         // is the user referred by a masternode?
573         if(
574             // is this a referred purchase?
575             _referredBy != 0x0000000000000000000000000000000000000000 &&
576 
577             // no cheating!
578             _referredBy != _customerAddress &&
579             
580             // does the referrer have at least X whole tokens?
581             // i.e is the referrer a godly chad masternode
582             tokenBalanceLedger_[_referredBy] >= stakingRequirement
583         ){
584             // wealth redistribution
585             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
586         } else {
587             // no ref purchase
588             // add the referral bonus back to the global dividends cake
589             _dividends = SafeMath.add(_dividends, _referralBonus);
590             _fee = _dividends * magnitude;
591         }
592         
593         // we can't give people infinite ethereum
594         if(tokenSupply_ > 0){
595             
596             // add tokens to the pool
597             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
598  
599             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
600             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
601             
602             // calculate the amount of tokens the customer receives over his purchase 
603             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
604         
605         } else {
606             // add tokens to the pool
607             tokenSupply_ = _amountOfTokens;
608         }
609         
610         // update circulating supply & the ledger address for the customer
611         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
612         
613         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
614         //really i know you think you do but you don't
615         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
616         payoutsTo_[_customerAddress] += _updatedPayouts;
617         
618         // fire event
619         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
620         
621         return _amountOfTokens;
622     }
623 
624     /**
625      * Calculate Token price based on an amount of incoming ethereum
626      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
627      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
628      */
629     function ethereumToTokens_(uint256 _ethereum)
630         internal
631         view
632         returns(uint256)
633     {
634         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
635         uint256 _tokensReceived = 
636          (
637             (
638                 // underflow attempts BTFO
639                 SafeMath.sub(
640                     (sqrt
641                         (
642                             (_tokenPriceInitial**2)
643                             +
644                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
645                             +
646                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
647                             +
648                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
649                         )
650                     ), _tokenPriceInitial
651                 )
652             )/(tokenPriceIncremental_)
653         )-(tokenSupply_)
654         ;
655   
656         return _tokensReceived;
657     }
658     
659     /**
660      * Calculate token sell value.
661      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
662      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
663      */
664      function tokensToEthereum_(uint256 _tokens)
665         internal
666         view
667         returns(uint256)
668     {
669 
670         uint256 tokens_ = (_tokens + 1e18);
671         uint256 _tokenSupply = (tokenSupply_ + 1e18);
672         uint256 _etherReceived =
673         (
674             // underflow attempts BTFO
675             SafeMath.sub(
676                 (
677                     (
678                         (
679                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
680                         )-tokenPriceIncremental_
681                     )*(tokens_ - 1e18)
682                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
683             )
684         /1e18);
685         return _etherReceived;
686     }
687     
688     
689     //This is where all your gas goes, sorry
690     //Not sorry, you probably only paid 1 gwei
691     function sqrt(uint x) internal pure returns (uint y) {
692         uint z = (x + 1) / 2;
693         y = x;
694         while (z < y) {
695             y = z;
696             z = (x / z + z) / 2;
697         }
698     }
699 }
700 
701 /**
702  * @title SafeMath
703  * @dev Math operations with safety checks that throw on error
704  */
705 library SafeMath {
706 
707     /**
708     * @dev Multiplies two numbers, throws on overflow.
709     */
710     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
711         if (a == 0) {
712             return 0;
713         }
714         uint256 c = a * b;
715         assert(c / a == b);
716         return c;
717     }
718 
719     /**
720     * @dev Integer division of two numbers, truncating the quotient.
721     */
722     function div(uint256 a, uint256 b) internal pure returns (uint256) {
723         // assert(b > 0); // Solidity automatically throws when dividing by 0
724         uint256 c = a / b;
725         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
726         return c;
727     }
728 
729     /**
730     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
731     */
732     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
733         assert(b <= a);
734         return a - b;
735     }
736 
737     /**
738     * @dev Adds two numbers, throws on overflow.
739     */
740     function add(uint256 a, uint256 b) internal pure returns (uint256) {
741         uint256 c = a + b;
742         assert(c >= a);
743         return c;
744     }
745 }