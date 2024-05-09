1 pragma solidity ^0.4.20;
2 
3 /*
4 * Golden Ratio
5 * 
6 * POWH3D Clone
7 *
8 * 25% Dividends are paid to the other token holders from the new players buy in fee
9 *
10 * 25% Dividends are paid out to other token holders whenever a player sells tokens
11 *
12 * 33% of Buy in Fees are paid to Masternodes
13 *
14 * Discord:   https://discord.gg/bcjS6Pb
15 *
16 * website:   https://goldenratio.ga
17 *
18 * email:     goldendevratio@gmail.com
19 */
20 
21 contract GOLDENRATIO {
22     /*=================================
23     =        MODIFIERS        =
24     =================================*/
25     // only players with tokens
26     modifier onlyBagholders() {
27         require(myTokens() > 0);
28         _;
29     }
30     
31      // only players with profits
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
44     // -> kill tha contract
45     // -> change the price of tokens
46     modifier onlyAdministrator(){
47         address _customerAddress = msg.sender;
48 
49         require(administrators[_customerAddress]);
50         _;
51     }
52     
53       // ensures that tha original tokens in tha contract is going to be equally distributed
54     // meaning, no divine dump is going to be possible
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
123     string public name = "GOLDENRATIO";
124     string public symbol = "GOLD";
125     uint8 constant public decimals = 18;
126     uint8 constant internal dividendFee_ = 4;    //25% Dividends 
127     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
128     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
129     uint256 constant internal magnitude = 2**64;
130     
131     // Masternode Staking Requirements
132     uint256 public stakingRequirement = 10e18;   //10 Tokens
133     
134     // ambassador program
135     mapping(address => bool) internal ambassadors_;     
136     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
137     uint256 constant internal ambassadorQuota_ = 20 ether;
138     
139     
140     
141    /*================================
142     =            DATASETS            =
143     ================================*/
144     // amount of shares for each address (scaled number)
145     mapping(address => uint256) internal tokenBalanceLedger_;
146     mapping(address => uint256) internal referralBalance_;
147     mapping(address => int256) internal payoutsTo_;
148     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
149     uint256 internal tokenSupply_ = 0;
150     uint256 internal profitPerShare_;
151     
152     // administrator list (see above on what they can do)
153     //mapping(bytes32 => bool) public administrators;
154     mapping(address => bool) public administrators;
155     
156     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
157     bool public onlyAmbassadors = true;
158 
159     address GOLDGOD;
160     
161 
162 
163     /*=======================================
164     =            PUBLIC FUNCTIONS            =
165     =======================================*/
166     /*
167     * -- APPLICATION ENTRY POINTS --  
168     */
169     function GOLDENRATIO()
170         public
171     {
172         // add administrators here
173 
174         administrators[msg.sender] = true;
175 
176         GOLDGOD = msg.sender;
177 
178         onlyAmbassadors = false;
179 
180 
181     }
182     
183      
184     /**
185      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
186      */
187     function buy(address _referredBy)
188         public
189         payable
190         returns(uint256)
191     {
192         purchaseTokens(msg.value, _referredBy);
193     }
194     
195     /**
196      * Fallback function to handle ethereum that was send straight to the contract
197      * Unfortunately we cannot use a referral address this way.
198      */
199     function()
200         payable
201         public
202     {
203         purchaseTokens(msg.value, 0x0);
204     }
205     
206     /**
207      * Converts all of caller's dividends to tokens.
208      */
209     function reinvest()
210         onlyStronghands()
211         public
212     {
213         // fetch dividends
214         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
215         
216         // pay out the dividends virtually
217         address _customerAddress = msg.sender;
218         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
219         
220         // retrieve ref. bonus
221         _dividends += referralBalance_[_customerAddress];
222         referralBalance_[_customerAddress] = 0;
223         
224         // dispatch a buy order with the virtualized "withdrawn dividends"
225         uint256 _tokens = purchaseTokens(_dividends, 0x0);
226         
227         // fire event
228         onReinvestment(_customerAddress, _dividends, _tokens);
229     }
230     
231     /**
232      * Alias of sell() and withdraw().
233      */
234     function exit()
235         public
236     {
237         // get token count for caller & sell them all
238         address _customerAddress = msg.sender;
239         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
240         if(_tokens > 0) sell(_tokens);
241         
242         
243         withdraw();
244     }
245 
246     /**
247      * Withdraws all of the callers earnings.
248      */
249     function withdraw()
250         onlyStronghands()
251         public
252     {
253         // setup data
254         address _customerAddress = msg.sender;
255         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
256         
257         // update dividend tracker
258         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
259         
260         // add ref. bonus
261         _dividends += referralBalance_[_customerAddress];
262         referralBalance_[_customerAddress] = 0;
263         
264         // lambo delivery service
265         _customerAddress.transfer(_dividends);
266         
267         // fire event
268         onWithdraw(_customerAddress, _dividends);
269     }
270     
271     /**
272      * Liquifies tokens to ethereum.
273      */
274     function sell(uint256 _amountOfTokens)
275         onlyBagholders()
276         public
277     {
278         // setup data
279         address _customerAddress = msg.sender;
280         // russian hackers BTFO
281         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
282         uint256 _tokens = _amountOfTokens;
283         uint256 _ethereum = tokensToEthereum_(_tokens);
284         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
285         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
286         
287         // burn the sold tokens
288         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
289         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
290         
291         // update dividends tracker
292         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
293         payoutsTo_[_customerAddress] -= _updatedPayouts;       
294         
295         // dividing by zero is a bad idea
296         if (tokenSupply_ > 0) {
297             // update the amount of dividends per token
298             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
299         }
300         
301         // fire event
302         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
303     }
304     
305     
306     /**
307      * Transfer tokens from the caller to a new holder.
308      * Remember, there's a 10% fee here as well.
309      */
310     function transfer(address _toAddress, uint256 _amountOfTokens)
311         onlyBagholders()
312         public
313         returns(bool)
314     {
315         // setup
316         address _customerAddress = msg.sender;
317         
318         // make sure we have the requested tokens
319         // also disables transfers until ambassador phase is over
320         // ( we dont want whale premines )
321         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
322         
323         // withdraw all outstanding dividends first
324         if(myDividends(true) > 0) withdraw();
325         
326         // liquify 10% of the tokens that are transfered
327         // these are dispersed to shareholders
328         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
329         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
330         uint256 _dividends = tokensToEthereum_(_tokenFee);
331   
332         // burn the fee tokens
333         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
334 
335         // exchange tokens
336         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
337         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
338         
339         // update dividend trackers
340         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
341         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
342         
343         // disperse dividends among holders
344         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
345         
346         // fire event
347         Transfer(_customerAddress, _toAddress, _taxedTokens);
348         
349         // ERC20
350         return true;
351        
352     }
353     
354     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
355     /**
356      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
357      */
358     function disableInitialStage()
359         onlyAdministrator()
360         public
361     {
362         onlyAmbassadors = false;
363     }
364     
365     /**
366      * In case one of us dissapears, we need to replace them.
367      */
368     function setAdministrator(address _identifier, bool _status)
369         onlyAdministrator()
370         public
371     {
372         administrators[_identifier] = _status;
373     }
374     
375     /**
376      * Precautionary measures in case we need to adjust the masternode rate.
377      */
378     function setStakingRequirement(uint256 _amountOfTokens)
379         onlyAdministrator()
380         public
381     {
382         stakingRequirement = _amountOfTokens;
383     }
384     
385     /**
386      * If we want to rebrand, we can.
387      */
388     function setName(string _name)
389         onlyAdministrator()
390         public
391     {
392         name = _name;
393     }
394     
395     /**
396      * If we want to rebrand, we can.
397      */
398     function setSymbol(string _symbol)
399         onlyAdministrator()
400         public
401     {
402         symbol = _symbol;
403     }
404 
405     
406     /*----------  HELPERS AND CALCULATORS  ----------*/
407     /**
408      * Method to view the current Ethereum stored in the contract
409      * Example: totalEthereumBalance()
410      */
411     function totalEthereumBalance()
412         public
413         view
414         returns(uint)
415     {
416         return address (this).balance;
417     }
418     
419     /**
420      * Retrieve the total token supply.
421      */
422     function totalSupply()
423         public
424         view
425         returns(uint256)
426     {
427         return tokenSupply_;
428     }
429     
430     /**
431      * Retrieve the tokens owned by the caller.
432      */
433     function myTokens()
434         public
435         view
436         returns(uint256)
437     {
438         address _customerAddress = msg.sender;
439         return balanceOf(_customerAddress);
440     }
441     
442     /**
443      * Retrieve the dividends owned by the caller.
444      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
445      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
446      * But in the internal calculations, we want them separate. 
447      */ 
448     function myDividends(bool _includeReferralBonus) 
449         public 
450         view 
451         returns(uint256)
452     {
453         address _customerAddress = msg.sender;
454         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
455     }
456     
457     /**
458      * Retrieve the token balance of any single address.
459      */
460     function balanceOf(address _customerAddress)
461         view
462         public
463         returns(uint256)
464     {
465         return tokenBalanceLedger_[_customerAddress];
466     }
467 
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
557 
558 
559         address _customerAddress = msg.sender;
560         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
561         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);           //33% Referral Bonus
562         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
563         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
564         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
565         uint256 _fee = _dividends * magnitude;
566  
567         // no point in continuing execution if OP is a poorfag russian hacker
568         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
569         // (or hackers)
570         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
571         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
572         
573         // is the user referred by a masternode?
574         if(
575             // is this a referred purchase?
576             _referredBy != 0x0000000000000000000000000000000000000000 &&
577 
578             // no cheating!
579             _referredBy != _customerAddress &&
580             
581             // does the referrer have at least X whole tokens?
582             // i.e is the referrer a godly chad masternode
583             tokenBalanceLedger_[_referredBy] >= stakingRequirement
584         ){
585             // wealth redistribution
586             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
587             
588         } else {
589             // no ref purchase
590             referralBalance_[GOLDGOD] = SafeMath.add(referralBalance_[GOLDGOD], _referralBonus);
591             //_dividends = SafeMath.add(_dividends, _referralBonus);
592            // _fee = _dividends * magnitude;
593         }
594         
595         // we can't give people infinite ethereum
596         if(tokenSupply_ > 0){
597             
598             // add tokens to the pool
599             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
600  
601             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
602             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
603             
604             // calculate the amount of tokens the customer receives over his purchase 
605             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
606         
607         } else {
608             // add tokens to the pool
609             tokenSupply_ = _amountOfTokens;
610         }
611         
612         // update circulating supply & the ledger address for the customer
613         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
614         
615         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
616         //really i know you think you do but you don't
617         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
618         payoutsTo_[_customerAddress] += _updatedPayouts;
619         
620         // fire event
621         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
622         
623         return _amountOfTokens;
624     }
625 
626     /**
627      * Calculate Token price based on an amount of incoming ethereum
628      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
629      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
630      */
631     function ethereumToTokens_(uint256 _ethereum)
632         internal
633         view
634         returns(uint256)
635     {
636         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
637         uint256 _tokensReceived = 
638          (
639             (
640                 // underflow attempts BTFO
641                 SafeMath.sub(
642                     (sqrt
643                         (
644                             (_tokenPriceInitial**2)
645                             +
646                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
647                             +
648                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
649                             +
650                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
651                         )
652                     ), _tokenPriceInitial
653                 )
654             )/(tokenPriceIncremental_)
655         )-(tokenSupply_)
656         ;
657   
658         return _tokensReceived;
659     }
660     
661     /**
662      * Calculate token sell value.
663      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
664      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
665      */
666      function tokensToEthereum_(uint256 _tokens)
667         internal
668         view
669         returns(uint256)
670     {
671 
672         uint256 tokens_ = (_tokens + 1e18);
673         uint256 _tokenSupply = (tokenSupply_ + 1e18);
674         uint256 _etherReceived =
675         (
676             // underflow attempts BTFO
677             SafeMath.sub(
678                 (
679                     (
680                         (
681                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
682                         )-tokenPriceIncremental_
683                     )*(tokens_ - 1e18)
684                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
685             )
686         /1e18);
687         return _etherReceived;
688     }
689     
690     
691     //This is where all your gas goes, sorry
692     //Not sorry, you probably only paid 1 gwei
693     function sqrt(uint x) internal pure returns (uint y) {
694         uint z = (x + 1) / 2;
695         y = x;
696         while (z < y) {
697             y = z;
698             z = (x / z + z) / 2;
699         }
700     }
701 }
702 
703 /**
704  * @title SafeMath
705  * @dev Math operations with safety checks that throw on error
706  */
707 library SafeMath {
708 
709     /**
710     * @dev Multiplies two numbers, throws on overflow.
711     */
712     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
713         if (a == 0) {
714             return 0;
715         }
716         uint256 c = a * b;
717         assert(c / a == b);
718         return c;
719     }
720 
721     /**
722     * @dev Integer division of two numbers, truncating the quotient.
723     */
724     function div(uint256 a, uint256 b) internal pure returns (uint256) {
725         // assert(b > 0); // Solidity automatically throws when dividing by 0
726         uint256 c = a / b;
727         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
728         return c;
729     }
730 
731     /**
732     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
733     */
734     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
735         assert(b <= a);
736         return a - b;
737     }
738 
739     /**
740     * @dev Adds two numbers, throws on overflow.
741     */
742     function add(uint256 a, uint256 b) internal pure returns (uint256) {
743         uint256 c = a + b;
744         assert(c >= a);
745         return c;
746     }
747 }