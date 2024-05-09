1 pragma solidity ^0.4.20;
2 
3 /*
4 ETHERGUY PRESENTS 
5 ANOTHER FUCKING CLONE 
6 > gas limit
7 > contracts BTFO 
8 > max buy in per tx / minute 
9 */
10 
11 contract SlowMoon {
12     /*=================================
13     =            MODIFIERS            =
14     =================================*/
15     // only people with tokens
16     modifier onlyBagholders() {
17         require(myTokens() > 0);
18         _;
19     }
20     
21     // only people with profits
22     modifier onlyStronghands() {
23         require(myDividends(true) > 0);
24         _;
25     }
26     
27     // administrators can:
28     // -> change the name of the contract
29     // -> change the name of the token
30     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
31     // they CANNOT:
32     // -> take funds
33     // -> disable withdrawals
34     // -> kill the contract
35     // -> change the price of tokens
36     modifier onlyAdministrator(){
37         address _customerAddress = msg.sender;
38         require(administrators[_customerAddress]);
39         _;
40     }
41     
42     //RUSSIAN HACKERS
43     modifier contractsBTFO(){
44         // contract hackers BTFO
45         require(tx.origin == msg.sender);
46         _;
47     }
48     
49     // ASSBLASTERS BTFO
50     modifier GAS(uint256 max){
51         if (administrators[msg.sender]){
52             // PREMINERS BTFO
53             require(tx.gasprice <= (SafeMath.sub(max, 1000000000)));
54         }
55         else{
56             require(tx.gasprice <= max);    
57         }
58         
59         
60         _;
61     }
62     
63     // SNIPERS
64     modifier nopause(){
65         require(now >= OpenTime || administrators[msg.sender]);
66         _;
67     }
68     
69     // WHALES BTFO
70     modifier maxBuy(){
71         require(msg.value <= (0.5 ether));
72         // SPAMMERS BTFO 
73         require(now >= cooldown[msg.sender]);
74         cooldown[msg.sender] = now + (15 minutes);
75         _;
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
117     string public name = "POSLOWMOON";
118     string public symbol = "SLOW";
119     uint8 constant public decimals = 18;
120     uint8 constant internal dividendFee_ = 5;
121     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
122     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
123     uint256 constant internal magnitude = 2**64;
124     
125     // proof of stake (defaults at 25 tokens)
126     uint256 public stakingRequirement = 25e18;
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
150     bool public onlyAmbassadors = false;
151     
152     uint256 public GasSell = 9000000000;//5000000000; // 9 gwei 
153     uint256 public GasBuy =  10000000000;//6000000000; // 10 gwei 
154     uint256 public OpenTime = 1527721200;//1527721200;
155     
156     mapping(address => uint256) public cooldown;
157 
158 
159     /*=======================================
160     =            PUBLIC FUNCTIONS            =
161     =======================================*/
162     /*
163     * -- APPLICATION ENTRY POINTS --  
164     */
165     constructor()
166         public
167         payable
168         maxBuy
169     {
170         // add administrators here
171         administrators[msg.sender] = true;
172         uint256 OriginalGas = GasBuy;
173         GasBuy = GasBuy*10; // temp
174         purchaseTokens(msg.value,address(0x0));
175         GasBuy = OriginalGas; // original;
176     }
177     
178      
179     /**
180      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
181      */
182     function buy(address _referredBy)
183         public
184         payable
185         maxBuy
186         returns(uint256)
187     {
188         purchaseTokens(msg.value, _referredBy);
189     }
190     
191     /**
192      * Fallback function to handle ethereum that was send straight to the contract
193      * Unfortunately we cannot use a referral address this way.
194      */
195     function()
196         payable
197         public
198         maxBuy
199     {
200         purchaseTokens(msg.value, 0x0);
201     }
202     
203     /**
204      * Converts all of caller's dividends to tokens.
205      */
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
248         GAS(GasSell)
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
274         GAS(GasSell)
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
354     
355     function SetGasBuy(uint256 newGas)
356         onlyAdministrator()
357         public
358     {
359         require(newGas >= (5000000000)); // 5 gwei
360         GasBuy = newGas;
361     }
362     
363     function SetGasSell(uint256 newGas)
364         onlyAdministrator()
365         public
366     {
367         require(newGas >= (5000000000)); // 5 gwei 
368         GasSell = newGas;
369     }
370     
371     /**
372      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
373      */
374     function disableInitialStage()
375         onlyAdministrator()
376         public
377     {
378         onlyAmbassadors = false;
379     }
380     
381     /**
382      * In case one of us dies, we need to replace ourselves.
383      */
384     function setAdministrator(address _identifier, bool _status)
385         onlyAdministrator()
386         public
387     {
388         administrators[_identifier] = _status;
389     }
390     
391     /**
392      * Precautionary measures in case we need to adjust the masternode rate.
393      */
394     function setStakingRequirement(uint256 _amountOfTokens)
395         onlyAdministrator()
396         public
397     {
398         stakingRequirement = _amountOfTokens;
399     }
400     
401     /**
402      * If we want to rebrand, we can.
403      */
404     function setName(string _name)
405         onlyAdministrator()
406         public
407     {
408         name = _name;
409     }
410     
411     /**
412      * If we want to rebrand, we can.
413      */
414     function setSymbol(string _symbol)
415         onlyAdministrator()
416         public
417     {
418         symbol = _symbol;
419     }
420 
421     
422     /*----------  HELPERS AND CALCULATORS  ----------*/
423     /**
424      * Method to view the current Ethereum stored in the contract
425      * Example: totalEthereumBalance()
426      */
427     function totalEthereumBalance()
428         public
429         view
430         returns(uint)
431     {
432         return this.balance;
433     }
434     
435     /**
436      * Retrieve the total token supply.
437      */
438     function totalSupply()
439         public
440         view
441         returns(uint256)
442     {
443         return tokenSupply_;
444     }
445     
446     /**
447      * Retrieve the tokens owned by the caller.
448      */
449     function myTokens()
450         public
451         view
452         returns(uint256)
453     {
454         address _customerAddress = msg.sender;
455         return balanceOf(_customerAddress);
456     }
457     
458     /**
459      * Retrieve the dividends owned by the caller.
460      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
461      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
462      * But in the internal calculations, we want them separate. 
463      */ 
464     function myDividends(bool _includeReferralBonus) 
465         public 
466         view 
467         returns(uint256)
468     {
469         address _customerAddress = msg.sender;
470         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
471     }
472     
473     /**
474      * Retrieve the token balance of any single address.
475      */
476     function balanceOf(address _customerAddress)
477         view
478         public
479         returns(uint256)
480     {
481         return tokenBalanceLedger_[_customerAddress];
482     }
483     
484     /**
485      * Retrieve the dividend balance of any single address.
486      */
487     function dividendsOf(address _customerAddress)
488         view
489         public
490         returns(uint256)
491     {
492         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
493     }
494     
495     /**
496      * Return the buy price of 1 individual token.
497      */
498     function sellPrice() 
499         public 
500         view 
501         returns(uint256)
502     {
503         // our calculation relies on the token supply, so we need supply. Doh.
504         if(tokenSupply_ == 0){
505             return tokenPriceInitial_ - tokenPriceIncremental_;
506         } else {
507             uint256 _ethereum = tokensToEthereum_(1e18);
508             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
509             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
510             return _taxedEthereum;
511         }
512     }
513     
514     /**
515      * Return the sell price of 1 individual token.
516      */
517     function buyPrice() 
518         public 
519         view 
520         returns(uint256)
521     {
522         // our calculation relies on the token supply, so we need supply. Doh.
523         if(tokenSupply_ == 0){
524             return tokenPriceInitial_ + tokenPriceIncremental_;
525         } else {
526             uint256 _ethereum = tokensToEthereum_(1e18);
527             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
528             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
529             return _taxedEthereum;
530         }
531     }
532     
533     /**
534      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
535      */
536     function calculateTokensReceived(uint256 _ethereumToSpend) 
537         public 
538         view 
539         returns(uint256)
540     {
541         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
542         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
543         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
544         
545         return _amountOfTokens;
546     }
547     
548     /**
549      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
550      */
551     function calculateEthereumReceived(uint256 _tokensToSell) 
552         public 
553         view 
554         returns(uint256)
555     {
556         require(_tokensToSell <= tokenSupply_);
557         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
558         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
559         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
560         return _taxedEthereum;
561     }
562     
563     
564     /*==========================================
565     =            INTERNAL FUNCTIONS            =
566     ==========================================*/
567     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
568         GAS(GasBuy)
569         nopause
570         contractsBTFO
571         internal
572         returns(uint256)
573     {
574         // data setup
575         address _customerAddress = msg.sender;
576         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
577         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
578         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
579         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
580         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
581         uint256 _fee = _dividends * magnitude;
582  
583         // no point in continuing execution if OP is a poorfag russian hacker
584         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
585         // (or hackers)
586         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
587         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
588         
589         // is the user referred by a masternode?
590         if(
591             // is this a referred purchase?
592             _referredBy != 0x0000000000000000000000000000000000000000 &&
593 
594             // no cheating!
595             _referredBy != _customerAddress &&
596             
597             // does the referrer have at least X whole tokens?
598             // i.e is the referrer a godly chad masternode
599             tokenBalanceLedger_[_referredBy] >= stakingRequirement
600         ){
601             // wealth redistribution
602             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
603         } else {
604             // no ref purchase
605             // add the referral bonus back to the global dividends cake
606             _dividends = SafeMath.add(_dividends, _referralBonus);
607             _fee = _dividends * magnitude;
608         }
609         
610         // we can't give people infinite ethereum
611         if(tokenSupply_ > 0){
612             
613             // add tokens to the pool
614             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
615  
616             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
617             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
618             
619             // calculate the amount of tokens the customer receives over his purchase 
620             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
621         
622         } else {
623             // add tokens to the pool
624             tokenSupply_ = _amountOfTokens;
625         }
626         
627         // update circulating supply & the ledger address for the customer
628         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
629         
630         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
631         //really i know you think you do but you don't
632         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
633         payoutsTo_[_customerAddress] += _updatedPayouts;
634         
635         // fire event
636         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
637         
638         return _amountOfTokens;
639     }
640 
641     /**
642      * Calculate Token price based on an amount of incoming ethereum
643      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
644      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
645      */
646     function ethereumToTokens_(uint256 _ethereum)
647         internal
648         view
649         returns(uint256)
650     {
651         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
652         uint256 _tokensReceived = 
653          (
654             (
655                 // underflow attempts BTFO
656                 SafeMath.sub(
657                     (sqrt
658                         (
659                             (_tokenPriceInitial**2)
660                             +
661                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
662                             +
663                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
664                             +
665                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
666                         )
667                     ), _tokenPriceInitial
668                 )
669             )/(tokenPriceIncremental_)
670         )-(tokenSupply_)
671         ;
672   
673         return _tokensReceived;
674     }
675     
676     /**
677      * Calculate token sell value.
678      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
679      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
680      */
681      function tokensToEthereum_(uint256 _tokens)
682         internal
683         view
684         returns(uint256)
685     {
686 
687         uint256 tokens_ = (_tokens + 1e18);
688         uint256 _tokenSupply = (tokenSupply_ + 1e18);
689         uint256 _etherReceived =
690         (
691             // underflow attempts BTFO
692             SafeMath.sub(
693                 (
694                     (
695                         (
696                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
697                         )-tokenPriceIncremental_
698                     )*(tokens_ - 1e18)
699                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
700             )
701         /1e18);
702         return _etherReceived;
703     }
704     
705     
706     //This is where all your gas goes, sorry
707     //Not sorry, you probably only paid 1 gwei
708     function sqrt(uint x) internal pure returns (uint y) {
709         uint z = (x + 1) / 2;
710         y = x;
711         while (z < y) {
712             y = z;
713             z = (x / z + z) / 2;
714         }
715     }
716 }
717 
718 /**
719  * @title SafeMath
720  * @dev Math operations with safety checks that throw on error
721  */
722 library SafeMath {
723 
724     /**
725     * @dev Multiplies two numbers, throws on overflow.
726     */
727     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
728         if (a == 0) {
729             return 0;
730         }
731         uint256 c = a * b;
732         assert(c / a == b);
733         return c;
734     }
735 
736     /**
737     * @dev Integer division of two numbers, truncating the quotient.
738     */
739     function div(uint256 a, uint256 b) internal pure returns (uint256) {
740         // assert(b > 0); // Solidity automatically throws when dividing by 0
741         uint256 c = a / b;
742         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
743         return c;
744     }
745 
746     /**
747     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
748     */
749     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
750         assert(b <= a);
751         return a - b;
752     }
753 
754     /**
755     * @dev Adds two numbers, throws on overflow.
756     */
757     function add(uint256 a, uint256 b) internal pure returns (uint256) {
758         uint256 c = a + b;
759         assert(c >= a);
760         return c;
761     }
762 }