1 pragma solidity ^0.4.20;
2 
3 /*
4 
5 P3D with new rules:
6 > 0.5 ETH buy in per 5 minutes
7 > Cannot sell/transfer/withdraw for 24 hours since last ETH buy in (reinvest doesnt up this timer)
8 > No transfer fees
9 
10 */
11 
12 contract PO24 {
13     /*=================================
14     =            MODIFIERS            =
15     =================================*/
16     // only people with tokens
17     modifier onlyBagholders() {
18         require(myTokens() > 0);
19         _;
20     }
21     
22     // only people with profits
23     modifier onlyStronghands() {
24         require(myDividends(true) > 0);
25         _;
26     }
27     
28     mapping (address => uint256) public sellTmr;
29     mapping (address => uint256) public buyTmr;
30     
31     uint256 sellTimerN = (24 hours);
32     uint256 buyTimerN = (5 minutes);
33     
34     uint256 buyMax = 0.5 ether;
35     
36     
37     modifier sellLimit(){
38         require(block.timestamp > sellTmr[msg.sender] , "You cannot sell because of the sell timer");
39         
40         _;
41     }
42     
43     modifier buyLimit(){
44         require(block.timestamp > buyTmr[msg.sender], "You cannot buy because of buy cooldown");
45         require(msg.value <= buyMax, "You cannot buy because you bought over the max");
46         buyTmr[msg.sender] = block.timestamp + buyTimerN;
47         sellTmr[msg.sender] = block.timestamp + sellTimerN;
48         _;
49     }
50     
51     // administrators can:
52     // -> change the name of the contract
53     // -> change the name of the token
54     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
55     // they CANNOT:
56     // -> take funds
57     // -> disable withdrawals
58     // -> kill the contract
59     // -> change the price of tokens
60     modifier onlyAdministrator(){
61         address _customerAddress = msg.sender;
62         require(administrators[_customerAddress]);
63         _;
64     }
65     
66     
67     // ensures that the first tokens in the contract will be equally distributed
68     // meaning, no divine dump will be ever possible
69     // result: healthy longevity.
70     modifier antiEarlyWhale(uint256 _amountOfEthereum){
71         address _customerAddress = msg.sender;
72         
73         // are we still in the vulnerable phase?
74         // if so, enact anti early whale protocol 
75         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
76             require(
77                 // is the customer in the ambassador list?
78                 ambassadors_[_customerAddress] == true &&
79                 
80                 // does the customer purchase exceed the max ambassador quota?
81                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
82                 
83             );
84             
85             // updated the accumulated quota    
86             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
87         
88             // execute
89             _;
90         } else {
91             // in case the ether count drops low, the ambassador phase won't reinitiate
92             onlyAmbassadors = false;
93             _;    
94         }
95         
96     }
97     
98     
99     /*==============================
100     =            EVENTS            =
101     ==============================*/
102     event onTokenPurchase(
103         address indexed customerAddress,
104         uint256 incomingEthereum,
105         uint256 tokensMinted,
106         address indexed referredBy
107     );
108     
109     event onTokenSell(
110         address indexed customerAddress,
111         uint256 tokensBurned,
112         uint256 ethereumEarned
113     );
114     
115     event onReinvestment(
116         address indexed customerAddress,
117         uint256 ethereumReinvested,
118         uint256 tokensMinted
119     );
120     
121     event onWithdraw(
122         address indexed customerAddress,
123         uint256 ethereumWithdrawn
124     );
125     
126     // ERC20
127     event Transfer(
128         address indexed from,
129         address indexed to,
130         uint256 tokens
131     );
132     
133     
134     /*=====================================
135     =            CONFIGURABLES            =
136     =====================================*/
137     string public name = "PO24";
138     string public symbol = "PO24";
139     uint8 constant public decimals = 18;
140     uint8 constant internal dividendFee_ = 5; // Look, strong Math
141     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
142     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
143     uint256 constant internal magnitude = 2**64;
144     
145     // proof of stake (defaults at 100 tokens)
146     uint256 public stakingRequirement = 100e18;
147     
148     // ambassador program
149     mapping(address => bool) internal ambassadors_;
150     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
151     uint256 constant internal ambassadorQuota_ = 2000 ether;
152     
153     
154     
155    /*================================
156     =            DATASETS            =
157     ================================*/
158     // amount of shares for each address (scaled number)
159     mapping(address => uint256) internal tokenBalanceLedger_;
160     mapping(address => uint256) internal referralBalance_;
161     mapping(address => int256) internal payoutsTo_;
162     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
163     uint256 internal tokenSupply_ = 0;
164     uint256 internal profitPerShare_;
165     
166     // administrator list (see above on what they can do)
167     mapping(address => bool) public administrators;
168     
169     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
170     bool public onlyAmbassadors = true;
171     
172 
173 
174     /*=======================================
175     =            PUBLIC FUNCTIONS            =
176     =======================================*/
177     /*
178     * -- APPLICATION ENTRY POINTS --  
179     */
180     function PO24()
181         public payable
182     {
183         // add administrators here
184 
185         administrators[msg.sender] = true;
186         ambassadors_[msg.sender] = true;
187         ambassadors_[0x183feBd8828a9ac6c70C0e27FbF441b93004fC05] = true;
188         ambassadors_[0xa329b25403eaf41720d58c69f61126ad1880e401] = true;
189         ambassadors_[0xa9211a3a147f412ca3f4e6f87fdd53ed864f9018] = true;
190         ambassadors_[0x7Ad9bA45a7247bFb9c52Fc8C62Dd199ceE3B4DFE] = true;
191         ambassadors_[0x273569713c870E6C2faB2380c48975d4aB04e3D1] = true;
192         ambassadors_[0xb03bEF1D9659363a9357aB29a05941491AcCb4eC] = true;
193         ambassadors_[0x5632CA98e5788edDB2397757Aa82d1Ed6171e5aD] = true;
194         ambassadors_[0x85abE8E3bed0d4891ba201Af1e212FE50bb65a26] = true;
195         ambassadors_[0x77d15e258e0d65bEe3c79ECDbda615E4Bd7dc32a] = true;
196         ambassadors_[0x89494966319943c91856326C5f6d0844dDe189A3] = true;
197         ambassadors_[0x84ECB387395a1be65E133c75Ff9e5FCC6F756DB3] = true;
198         ambassadors_[0x83c0Efc6d8B16D87BFe1335AB6BcAb3Ed3960285] = true;
199 
200 
201         purchaseTokens(msg.value, address(0x0));
202         
203 
204     }
205     
206      
207     /**
208      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
209      */
210     function buy(address _referredBy)
211         public
212         payable
213         returns(uint256)
214     {
215         purchaseTokens(msg.value, _referredBy);
216     }
217     
218     /**
219      * Fallback function to handle ethereum that was send straight to the contract
220      * Unfortunately we cannot use a referral address this way.
221      */
222     function()
223         payable
224         public
225     {
226         purchaseTokens(msg.value, 0x0);
227     }
228     
229     /**
230      * Converts all of caller's dividends to tokens.
231     */
232     function reinvest()
233         onlyStronghands()
234         public
235     {
236         // fetch dividends
237         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
238         
239         // pay out the dividends virtually
240         address _customerAddress = msg.sender;
241         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
242         
243         // retrieve ref. bonus
244         _dividends += referralBalance_[_customerAddress];
245         referralBalance_[_customerAddress] = 0;
246         
247         // dispatch a buy order with the virtualized "withdrawn dividends"
248         uint256 _tokens = _purchaseTokens(_dividends, 0x0);
249         
250         // fire event
251         onReinvestment(_customerAddress, _dividends, _tokens);
252     }
253     
254     /**
255      * Alias of sell() and withdraw().
256      */
257     function exit()
258         public
259         sellLimit()
260     {
261         // get token count for caller & sell them all
262         address _customerAddress = msg.sender;
263         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
264         if(_tokens > 0) sell(_tokens);
265         
266         // lambo delivery service
267         withdraw();
268     }
269 
270     /**
271      * Withdraws all of the callers earnings.
272      */
273     function withdraw()
274         onlyStronghands()
275         sellLimit()
276         public
277     {
278         // setup data
279         address _customerAddress = msg.sender;
280         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
281         
282         // update dividend tracker
283         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
284         
285         // add ref. bonus
286         _dividends += referralBalance_[_customerAddress];
287         referralBalance_[_customerAddress] = 0;
288         
289         // lambo delivery service
290         _customerAddress.transfer(_dividends);
291         
292         // fire event
293         onWithdraw(_customerAddress, _dividends);
294     }
295     
296     /**
297      * Liquifies tokens to ethereum.
298      */
299     function sell(uint256 _amountOfTokens)
300         onlyBagholders()
301         sellLimit()
302         public
303     {
304         // setup data
305         address _customerAddress = msg.sender;
306         // russian hackers BTFO
307         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
308         uint256 _tokens = _amountOfTokens;
309         uint256 _ethereum = tokensToEthereum_(_tokens);
310         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
311         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
312         
313         // burn the sold tokens
314         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
315         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
316         
317         // update dividends tracker
318         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
319         payoutsTo_[_customerAddress] -= _updatedPayouts;       
320         
321         // dividing by zero is a bad idea
322         if (tokenSupply_ > 0) {
323             // update the amount of dividends per token
324             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
325         }
326         
327         // fire event
328         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
329     }
330     
331     
332     /**
333      * Transfer tokens from the caller to a new holder.
334      * Remember, there's a 10% fee here as well.
335      */
336     function transfer(address _toAddress, uint256 _amountOfTokens)
337         onlyBagholders()
338         sellLimit()
339         public
340         returns(bool)
341     {
342         // setup
343         address _customerAddress = msg.sender;
344         
345         // make sure we have the requested tokens
346         // also disables transfers until ambassador phase is over
347         // ( we dont want whale premines )
348         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
349         
350         // withdraw all outstanding dividends first
351         if(myDividends(true) > 0) withdraw();
352         
353   
354 
355 
356         // exchange tokens
357         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
358         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
359         
360         // update dividend trackers
361         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
362         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
363 
364         
365         // fire event
366         Transfer(_customerAddress, _toAddress, _amountOfTokens);
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
572         buyLimit()
573         internal
574         returns(uint256)
575     {
576         return _purchaseTokens(_incomingEthereum, _referredBy);
577     }
578     
579     function _purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256){
580         
581         // data setup
582         address _customerAddress = msg.sender;
583         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
584         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
585         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
586         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
587         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
588         uint256 _fee = _dividends * magnitude;
589  
590         // no point in continuing execution if OP is a poorfag russian hacker
591         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
592         // (or hackers)
593         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
594         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
595         
596         // is the user referred by a masternode?
597         if(
598             // is this a referred purchase?
599             _referredBy != 0x0000000000000000000000000000000000000000 &&
600 
601             // no cheating!
602             _referredBy != _customerAddress &&
603             
604             // does the referrer have at least X whole tokens?
605             // i.e is the referrer a godly chad masternode
606             tokenBalanceLedger_[_referredBy] >= stakingRequirement
607         ){
608             // wealth redistribution
609             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
610         } else {
611             // no ref purchase
612             // add the referral bonus back to the global dividends cake
613             _dividends = SafeMath.add(_dividends, _referralBonus);
614             _fee = _dividends * magnitude;
615         }
616         
617         // we can't give people infinite ethereum
618         if(tokenSupply_ > 0){
619             
620             // add tokens to the pool
621             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
622  
623             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
624             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
625             
626             // calculate the amount of tokens the customer receives over his purchase 
627             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
628         
629         } else {
630             // add tokens to the pool
631             tokenSupply_ = _amountOfTokens;
632         }
633         
634         // update circulating supply & the ledger address for the customer
635         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
636         
637         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
638         //really i know you think you do but you don't
639         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
640         payoutsTo_[_customerAddress] += _updatedPayouts;
641         
642         // fire event
643         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
644         
645         return _amountOfTokens;
646     }
647 
648     /**
649      * Calculate Token price based on an amount of incoming ethereum
650      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
651      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
652      */
653     function ethereumToTokens_(uint256 _ethereum)
654         internal
655         view
656         returns(uint256)
657     {
658         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
659         uint256 _tokensReceived = 
660          (
661             (
662                 // underflow attempts BTFO
663                 SafeMath.sub(
664                     (sqrt
665                         (
666                             (_tokenPriceInitial**2)
667                             +
668                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
669                             +
670                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
671                             +
672                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
673                         )
674                     ), _tokenPriceInitial
675                 )
676             )/(tokenPriceIncremental_)
677         )-(tokenSupply_)
678         ;
679   
680         return _tokensReceived;
681     }
682     
683     /**
684      * Calculate token sell value.
685      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
686      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
687      */
688      function tokensToEthereum_(uint256 _tokens)
689         internal
690         view
691         returns(uint256)
692     {
693 
694         uint256 tokens_ = (_tokens + 1e18);
695         uint256 _tokenSupply = (tokenSupply_ + 1e18);
696         uint256 _etherReceived =
697         (
698             // underflow attempts BTFO
699             SafeMath.sub(
700                 (
701                     (
702                         (
703                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
704                         )-tokenPriceIncremental_
705                     )*(tokens_ - 1e18)
706                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
707             )
708         /1e18);
709         return _etherReceived;
710     }
711     
712     
713     //This is where all your gas goes, sorry
714     //Not sorry, you probably only paid 1 gwei
715     function sqrt(uint x) internal pure returns (uint y) {
716         uint z = (x + 1) / 2;
717         y = x;
718         while (z < y) {
719             y = z;
720             z = (x / z + z) / 2;
721         }
722     }
723 }
724 
725 /**
726  * @title SafeMath
727  * @dev Math operations with safety checks that throw on error
728  */
729 library SafeMath {
730 
731     /**
732     * @dev Multiplies two numbers, throws on overflow.
733     */
734     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
735         if (a == 0) {
736             return 0;
737         }
738         uint256 c = a * b;
739         assert(c / a == b);
740         return c;
741     }
742 
743     /**
744     * @dev Integer division of two numbers, truncating the quotient.
745     */
746     function div(uint256 a, uint256 b) internal pure returns (uint256) {
747         // assert(b > 0); // Solidity automatically throws when dividing by 0
748         uint256 c = a / b;
749         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
750         return c;
751     }
752 
753     /**
754     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
755     */
756     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
757         assert(b <= a);
758         return a - b;
759     }
760 
761     /**
762     * @dev Adds two numbers, throws on overflow.
763     */
764     function add(uint256 a, uint256 b) internal pure returns (uint256) {
765         uint256 c = a + b;
766         assert(c >= a);
767         return c;
768     }
769 }