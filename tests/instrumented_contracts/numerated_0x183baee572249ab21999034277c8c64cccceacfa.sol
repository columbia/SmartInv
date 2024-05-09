1 pragma solidity ^0.4.20;
2 
3 /*
4 * Welcome to PHILcoin
5 * ==========================*
6 
7 
8    _____ ______ _____ ______     _    _ _   _______ _____ ____ _____ _   _ 
9   / ____|  ____/ ____|  ____/\  | |  | | | |__   __/ ____/ __ \_   _| \ | |
10  | (___ | |__ | |  __| |__ /  \ | |  | | |    | | | |   | |  | || | |  \| |
11   \___ \|  __|| | |_ |  __/ /\ \| |  | | |    | | | |   | |  | || | | . ` |
12   ____) | |___| |__| | | / ____ \ |__| | |____| | | |___| |__| || |_| |\  |
13  |_____/|______\_____|_|/_/    \_\____/|______|_|  \_____\____/_____|_| \_|
14                                                                            
15                                                                            
16 
17 
18 * ==========================*
19 * -> What?
20 * Tribute to Avicii
21 * Only difference is that, you will receive 99%
22 */
23 
24 contract SEGFAULTCOIN {
25     /*=================================
26     =            MODIFIERS            =
27     =================================*/
28     // only people with tokens
29     modifier onlyBagholders() {
30         require(myTokens() > 0);
31         _;
32     }
33     
34     // only people with profits
35     modifier onlyStronghands() {
36         require(myDividends(true) > 0);
37         _;
38     }
39     
40     // administrators can:
41     // -> change the name of the contract
42     // -> change the name of the token
43     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
44     // they CANNOT:
45     // -> take funds
46     // -> disable withdrawals
47     // -> kill the contract
48     // -> change the price of tokens
49     modifier onlyAdministrator(){
50         address _customerAddress = msg.sender;
51         require(administrators[keccak256(_customerAddress)]);
52         _;
53     }
54     
55     
56     // ensures that the first tokens in the contract will be equally distributed
57     // meaning, no divine dump will be ever possible
58     // result: healthy longevity.
59     modifier antiEarlyWhale(uint256 _amountOfEthereum){
60         address _customerAddress = msg.sender;
61         
62         // are we still in the vulnerable phase?
63         // if so, enact anti early whale protocol 
64         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
65             require(
66                 // is the customer in the ambassador list?
67                 ambassadors_[_customerAddress] == true &&
68                 
69                 // does the customer purchase exceed the max ambassador quota?
70                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
71                 
72             );
73             
74             // updated the accumulated quota    
75             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
76         
77             // execute
78             _;
79         } else {
80             // in case the ether count drops low, the ambassador phase won't reinitiate
81             onlyAmbassadors = false;
82             _;    
83         }
84         
85     }
86     
87     
88     /*==============================
89     =            EVENTS            =
90     ==============================*/
91     event onTokenPurchase(
92         address indexed customerAddress,
93         uint256 incomingEthereum,
94         uint256 tokensMinted,
95         address indexed referredBy
96     );
97     
98     event onTokenSell(
99         address indexed customerAddress,
100         uint256 tokensBurned,
101         uint256 ethereumEarned
102     );
103     
104     event onReinvestment(
105         address indexed customerAddress,
106         uint256 ethereumReinvested,
107         uint256 tokensMinted
108     );
109     
110     event onWithdraw(
111         address indexed customerAddress,
112         uint256 ethereumWithdrawn
113     );
114     
115     // ERC20
116     event Transfer(
117         address indexed from,
118         address indexed to,
119         uint256 tokens
120     );
121     
122     
123     /*=====================================
124     =            CONFIGURABLES            =
125     =====================================*/
126     string public name = "SEGFAULTCOIN";
127     string public symbol = "SEG";
128     uint8 constant public decimals = 18;
129     uint8 constant internal dividendFee_ = 12;
130     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
131     uint256 constant internal tokenPriceIncremental_ = 0.0001 ether;
132     uint256 constant internal magnitude = 2**64;
133     
134     // proof of stake (defaults at 100 tokens)
135     uint256 public stakingRequirement = 5e18;
136     
137     // ambassador program
138     mapping(address => bool) internal ambassadors_;
139     uint256 constant internal ambassadorMaxPurchase_ = 10 ether;
140     uint256 constant internal ambassadorQuota_ = 10 ether;
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
166     /*
167     * -- APPLICATION ENTRY POINTS --  
168     */
169     function SEGFAULTCOIN()
170         public
171     {
172  
173         
174     
175          
176          
177         
178         
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
242         // lambo delivery service
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
366      * In case one of us dies, we need to replace ourselves.
367      */
368     function setAdministrator(bytes32 _identifier, bool _status)
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
416         return this.balance;
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
468     /**
469      * Retrieve the dividend balance of any single address.
470      */
471     function dividendsOf(address _customerAddress)
472         view
473         public
474         returns(uint256)
475     {
476         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
477     }
478     
479     /**
480      * Return the buy price of 1 individual token.
481      */
482     function sellPrice() 
483         public 
484         view 
485         returns(uint256)
486     {
487         // our calculation relies on the token supply, so we need supply. Doh.
488         if(tokenSupply_ == 0){
489             return tokenPriceInitial_ - tokenPriceIncremental_;
490         } else {
491             uint256 _ethereum = tokensToEthereum_(1e18);
492             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
493             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
494             return _taxedEthereum;
495         }
496     }
497     
498     /**
499      * Return the sell price of 1 individual token.
500      */
501     function buyPrice() 
502         public 
503         view 
504         returns(uint256)
505     {
506         // our calculation relies on the token supply, so we need supply. Doh.
507         if(tokenSupply_ == 0){
508             return tokenPriceInitial_ + tokenPriceIncremental_;
509         } else {
510             uint256 _ethereum = tokensToEthereum_(1e18);
511             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
512             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
513             return _taxedEthereum;
514         }
515     }
516     
517     /**
518      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
519      */
520     function calculateTokensReceived(uint256 _ethereumToSpend) 
521         public 
522         view 
523         returns(uint256)
524     {
525         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
526         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
527         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
528         
529         return _amountOfTokens;
530     }
531     
532     /**
533      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
534      */
535     function calculateEthereumReceived(uint256 _tokensToSell) 
536         public 
537         view 
538         returns(uint256)
539     {
540         require(_tokensToSell <= tokenSupply_);
541         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
542         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
543         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
544         return _taxedEthereum;
545     }
546     
547     
548     /*==========================================
549     =            INTERNAL FUNCTIONS            =
550     ==========================================*/
551     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
552         antiEarlyWhale(_incomingEthereum)
553         internal
554         returns(uint256)
555     {
556         // data setup
557         address _customerAddress = msg.sender;
558         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
559         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
560         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
561         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
562         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
563         uint256 _fee = _dividends * magnitude;
564  
565         // no point in continuing execution if OP is a poorfag russian hacker
566         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
567         // (or hackers)
568         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
569         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
570         
571         // is the user referred by a masternode?
572         if(
573             // is this a referred purchase?
574             _referredBy != 0x0000000000000000000000000000000000000000 &&
575 
576             // no cheating!
577             _referredBy != _customerAddress &&
578             
579             // does the referrer have at least X whole tokens?
580             // i.e is the referrer a godly chad masternode
581             tokenBalanceLedger_[_referredBy] >= stakingRequirement
582         ){
583             // wealth redistribution
584             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
585         } else {
586             // no ref purchase
587             // add the referral bonus back to the global dividends cake
588             _dividends = SafeMath.add(_dividends, _referralBonus);
589             _fee = _dividends * magnitude;
590         }
591         
592         // we can't give people infinite ethereum
593         if(tokenSupply_ > 0){
594             
595             // add tokens to the pool
596             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
597  
598             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
599             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
600             
601             // calculate the amount of tokens the customer receives over his purchase 
602             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
603         
604         } else {
605             // add tokens to the pool
606             tokenSupply_ = _amountOfTokens;
607         }
608         
609         // update circulating supply & the ledger address for the customer
610         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
611         
612         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
613         //really i know you think you do but you don't
614         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
615         payoutsTo_[_customerAddress] += _updatedPayouts;
616         
617         // fire event
618         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
619         
620         return _amountOfTokens;
621     }
622 
623     /**
624      * Calculate Token price based on an amount of incoming ethereum
625      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
626      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
627      */
628     function ethereumToTokens_(uint256 _ethereum)
629         internal
630         view
631         returns(uint256)
632     {
633         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
634         uint256 _tokensReceived = 
635          (
636             (
637                 // underflow attempts BTFO
638                 SafeMath.sub(
639                     (sqrt
640                         (
641                             (_tokenPriceInitial**2)
642                             +
643                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
644                             +
645                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
646                             +
647                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
648                         )
649                     ), _tokenPriceInitial
650                 )
651             )/(tokenPriceIncremental_)
652         )-(tokenSupply_)
653         ;
654   
655         return _tokensReceived;
656     }
657     
658     /**
659      * Calculate token sell value.
660      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
661      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
662      */
663      function tokensToEthereum_(uint256 _tokens)
664         internal
665         view
666         returns(uint256)
667     {
668 
669         uint256 tokens_ = (_tokens + 1e18);
670         uint256 _tokenSupply = (tokenSupply_ + 1e18);
671         uint256 _etherReceived =
672         (
673             // underflow attempts BTFO
674             SafeMath.sub(
675                 (
676                     (
677                         (
678                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
679                         )-tokenPriceIncremental_
680                     )*(tokens_ - 1e18)
681                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
682             )
683         /1e18);
684         return _etherReceived;
685     }
686     
687     
688     //This is where all your gas goes, sorry
689     //Not sorry, you probably only paid 1 gwei
690     function sqrt(uint x) internal pure returns (uint y) {
691         uint z = (x + 1) / 2;
692         y = x;
693         while (z < y) {
694             y = z;
695             z = (x / z + z) / 2;
696         }
697     }
698 }
699 
700 /**
701  * @title SafeMath
702  * @dev Math operations with safety checks that throw on error
703  */
704 library SafeMath {
705 
706     /**
707     * @dev Multiplies two numbers, throws on overflow.
708     */
709     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
710         if (a == 0) {
711             return 0;
712         }
713         uint256 c = a * b;
714         assert(c / a == b);
715         return c;
716     }
717 
718     /**
719     * @dev Integer division of two numbers, truncating the quotient.
720     */
721     function div(uint256 a, uint256 b) internal pure returns (uint256) {
722         // assert(b > 0); // Solidity automatically throws when dividing by 0
723         uint256 c = a / b;
724         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
725         return c;
726     }
727 
728     /**
729     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
730     */
731     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
732         assert(b <= a);
733         return a - b;
734     }
735 
736     /**
737     * @dev Adds two numbers, throws on overflow.
738     */
739     function add(uint256 a, uint256 b) internal pure returns (uint256) {
740         uint256 c = a + b;
741         assert(c >= a);
742         return c;
743     }
744 }