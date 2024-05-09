1 pragma solidity ^0.4.23;
2 
3 
4 
5 contract Rocket {
6     /*=================================
7     =            MODIFIERS            =
8     =================================*/
9     // only people with tokens
10     modifier onlyBagholders() {
11         require(myTokens() > 0);
12         _;
13     }
14     
15     // only people with profits
16     modifier onlyStronghands() {
17         require(myDividends(true) > 0);
18         _;
19     }
20     
21     // administrators can:
22     // -> change the name of the contract
23     // -> change the name of the token
24     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
25     // they CANNOT:
26     // -> take funds
27     // -> disable withdrawals
28     // -> kill the contract
29     // -> change the price of tokens
30     modifier onlyAdministrator(){
31         address _customerAddress = msg.sender;
32         require(administrators[_customerAddress]);
33         _;
34     }
35     
36     
37 
38     
39     
40     /*==============================
41     =            EVENTS            =
42     ==============================*/
43     event onTokenPurchase(
44         address indexed customerAddress,
45         uint256 incomingEthereum,
46         uint256 tokensMinted,
47         address indexed referredBy
48     );
49     
50     event onTokenSell(
51         address indexed customerAddress,
52         uint256 tokensBurned,
53         uint256 ethereumEarned
54     );
55     
56     event onReinvestment(
57         address indexed customerAddress,
58         uint256 ethereumReinvested,
59         uint256 tokensMinted
60     );
61     
62     event onWithdraw(
63         address indexed customerAddress,
64         uint256 ethereumWithdrawn
65     );
66     
67     // ERC20
68     event Transfer(
69         address indexed from,
70         address indexed to,
71         uint256 tokens
72     );
73     
74     
75     /*=====================================
76     =            CONFIGURABLES            =
77     =====================================*/
78     string public name = "Rocket";
79     string public symbol = "RCKT";
80     uint8 constant public decimals = 18;
81     uint8 constant internal dividendFee_ = 5; // Look, strong Math
82     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
83     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
84     uint256 constant internal magnitude = 2**64;
85     
86     // proof of stake (defaults at 100 tokens)
87     uint256 public stakingRequirement = 100e18;
88      
89 
90     
91     uint256 public Timer;
92     uint16 constant public JackpotTimer = 30 minutes;
93     address public Jackpot;
94     uint256 public JackpotAmount;
95     
96     uint8 constant JackpotCut = 4; // Cut to jackpot (division) 
97     uint8 constant JackpotPay = 80; // 80 / 100 = 80%
98     uint16 constant JackpotMinBuyin = 1000; // division; 1/100 of all ether currently in contract 
99     uint256 constant JackpotMinBuyingConst = 10 finney; 
100     uint256 constant MaxBuyInMin = 1 ether;
101     uint8 constant MaxBuyInCut = 10;  
102     
103 
104     
105 
106 
107 
108     
109    /*================================
110     =            DATASETS            =
111     ================================*/
112     // amount of shares for each address (scaled number)
113     mapping(address => uint256) internal tokenBalanceLedger_;
114     mapping(address => uint256) internal referralBalance_;
115     mapping(address => int256) internal payoutsTo_;
116     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
117     uint256 internal tokenSupply_ = 0;
118     uint256 internal profitPerShare_;
119     
120     // administrator list (see above on what they can do)
121     mapping(address => bool) public administrators;
122     
123     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
124     bool public onlyAmbassadors = false;
125     
126 
127 
128     /*=======================================
129     =            PUBLIC FUNCTIONS            =
130     =======================================*/
131     /*
132     * -- APPLICATION ENTRY POINTS --  
133     */
134     constructor()
135         public
136         payable
137     {
138         // add administrators here
139 
140         administrators[msg.sender] = true;
141 
142 
143         
144         buy(0x0);
145     }
146     
147      
148     /**
149      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
150      */
151     function buy(address _referredBy)
152         public
153         payable
154         returns(uint256)
155     {
156         require(msg.value <= GetMaxBuyIn());
157 
158         purchaseTokens(msg.value, _referredBy);
159     }
160     
161     /**
162      * Fallback function to handle ethereum that was send straight to the contract
163      * Unfortunately we cannot use a referral address this way.
164      */
165     function()
166         payable
167         public
168     {
169         require(msg.value <= GetMaxBuyIn());
170 
171         purchaseTokens(msg.value, 0x0);
172     }
173     
174     /**
175      * Converts all of caller's dividends to tokens.
176     */
177     function reinvest()
178         onlyStronghands()
179         public
180     {
181         // fetch dividends
182         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
183         
184         // pay out the dividends virtually
185         address _customerAddress = msg.sender;
186         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
187         
188         // retrieve ref. bonus
189         _dividends += referralBalance_[_customerAddress];
190         referralBalance_[_customerAddress] = 0;
191         
192         // dispatch a buy order with the virtualized "withdrawn dividends"
193         uint256 _tokens = purchaseTokens(_dividends, 0x0);
194         
195         // fire event
196         onReinvestment(_customerAddress, _dividends, _tokens);
197     }
198     
199     /**
200      * Alias of sell() and withdraw().
201      */
202     function exit()
203         public
204     {
205         // get token count for caller & sell them all
206         address _customerAddress = msg.sender;
207         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
208         if(_tokens > 0) sell(_tokens);
209         
210         // lambo delivery service
211         withdraw();
212     }
213 
214     /**
215      * Withdraws all of the callers earnings.
216      */
217     function withdraw()
218         onlyStronghands()
219         public
220     {
221         // setup data
222         address _customerAddress = msg.sender;
223         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
224         
225         // update dividend tracker
226         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
227         
228         // add ref. bonus
229         _dividends += referralBalance_[_customerAddress];
230         referralBalance_[_customerAddress] = 0;
231         
232         // lambo delivery service
233         _customerAddress.transfer(_dividends);
234         
235         // fire event
236         onWithdraw(_customerAddress, _dividends);
237     }
238     
239     /**
240      * Liquifies tokens to ethereum.
241      */
242     function sell(uint256 _amountOfTokens)
243         onlyBagholders()
244         public
245     {
246         // setup data
247         address _customerAddress = msg.sender;
248         // russian hackers BTFO
249         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
250         uint256 _tokens = _amountOfTokens;
251         uint256 _ethereum = tokensToEthereum_(_tokens);
252         uint256 _undividedDividends = SafeMath.div(_ethereum, dividendFee_);
253 
254         uint256 _jackpotAmount = SafeMath.div(_undividedDividends, JackpotCut);
255         JackpotAmount = SafeMath.add(JackpotAmount,  _jackpotAmount);
256         uint256 _dividends = SafeMath.sub(_undividedDividends,_jackpotAmount);
257         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _undividedDividends);
258         
259         // burn the sold tokens
260         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
261         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
262         
263         // update dividends tracker
264         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
265         payoutsTo_[_customerAddress] -= _updatedPayouts;       
266         
267         // dividing by zero is a bad idea
268         if (tokenSupply_ > 0) {
269             // update the amount of dividends per token
270             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
271         }
272         
273         // fire event
274         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
275     }
276     
277     
278     /**
279      * Transfer tokens from the caller to a new holder.
280      * Remember, there's a 10% fee here as well.
281      */
282     function transfer(address _toAddress, uint256 _amountOfTokens)
283         onlyBagholders()
284         public
285         returns(bool)
286     {
287         // setup
288         address _customerAddress = msg.sender;
289         
290         // make sure we have the requested tokens
291         // also disables transfers until ambassador phase is over
292         // ( we dont want whale premines )
293         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
294         
295         // withdraw all outstanding dividends first
296         if(myDividends(true) > 0) withdraw();
297         
298 
299         // burn the fee tokens
300         tokenSupply_ = SafeMath.sub(tokenSupply_, _amountOfTokens);
301 
302         // exchange tokens
303         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
304         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
305         
306         // update dividend trackers
307         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
308         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
309         
310         // fire event
311         Transfer(_customerAddress, _toAddress, _amountOfTokens);
312         
313         // ERC20
314         return true;
315        
316     }
317     
318     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
319     /**
320      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
321      */
322     function disableInitialStage()
323         onlyAdministrator()
324         public
325     {
326       
327     }
328     
329     
330     
331     /**
332      * In case one of us dies, we need to replace ourselves.
333      */
334     function setAdministrator(address _identifier, bool _status)
335         onlyAdministrator()
336         public
337     {
338         administrators[_identifier] = _status;
339     }
340     
341     /**
342      * Precautionary measures in case we need to adjust the masternode rate.
343      */
344     function setStakingRequirement(uint256 _amountOfTokens)
345         onlyAdministrator()
346         public
347     {
348         stakingRequirement = _amountOfTokens;
349     }
350     
351     /**
352      * If we want to rebrand, we can.
353      */
354     function setName(string _name)
355         onlyAdministrator()
356         public
357     {
358         name = _name;
359     }
360     
361     /**
362      * If we want to rebrand, we can.
363      */
364     function setSymbol(string _symbol)
365         onlyAdministrator()
366         public
367     {
368         symbol = _symbol;
369     }
370     
371     function GetJackpotMin() public view returns (uint){
372         uint Ret = SafeMath.div(totalEthereumBalance(),(JackpotMinBuyin));
373         if (Ret < JackpotMinBuyingConst){
374             return JackpotMinBuyingConst;
375         }
376         return Ret;
377     }
378     
379     function GetMaxBuyIn() public view returns (uint){
380         uint Ret = SafeMath.div(totalEthereumBalance(),(MaxBuyInCut));
381         if (Ret < MaxBuyInMin){
382             return MaxBuyInMin;
383         }
384         return Ret;
385     }
386 
387     
388     /*----------  HELPERS AND CALCULATORS  ----------*/
389     /**
390      * Method to view the current Ethereum stored in the contract
391      * Example: totalEthereumBalance()
392      */
393     function totalEthereumBalance()
394         public
395         view
396         returns(uint)
397     {
398         return address(this).balance;
399     }
400     
401     /**
402      * Retrieve the total token supply.
403      */
404     function totalSupply()
405         public
406         view
407         returns(uint256)
408     {
409         return tokenSupply_;
410     }
411     
412     /**
413      * Retrieve the tokens owned by the caller.
414      */
415     function myTokens()
416         public
417         view
418         returns(uint256)
419     {
420         address _customerAddress = msg.sender;
421         return balanceOf(_customerAddress);
422     }
423     
424     /**
425      * Retrieve the dividends owned by the caller.
426      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
427      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
428      * But in the internal calculations, we want them separate. 
429      */ 
430     function myDividends(bool _includeReferralBonus) 
431         public 
432         view 
433         returns(uint256)
434     {
435         address _customerAddress = msg.sender;
436         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
437     }
438     
439     /**
440      * Retrieve the token balance of any single address.
441      */
442     function balanceOf(address _customerAddress)
443         view
444         public
445         returns(uint256)
446     {
447         return tokenBalanceLedger_[_customerAddress];
448     }
449     
450     /**
451      * Retrieve the dividend balance of any single address.
452      */
453     function dividendsOf(address _customerAddress)
454         view
455         public
456         returns(uint256)
457     {
458         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
459     }
460     
461     /**
462      * Return the buy price of 1 individual token.
463      */
464     function sellPrice() 
465         public 
466         view 
467         returns(uint256)
468     {
469         // our calculation relies on the token supply, so we need supply. Doh.
470         if(tokenSupply_ == 0){
471             return tokenPriceInitial_ - tokenPriceIncremental_;
472         } else {
473             uint256 _ethereum = tokensToEthereum_(1e18);
474             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
475             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
476             return _taxedEthereum;
477         }
478     }
479     
480     /**
481      * Return the sell price of 1 individual token.
482      */
483     function buyPrice() 
484         public 
485         view 
486         returns(uint256)
487     {
488         // our calculation relies on the token supply, so we need supply. Doh.
489         if(tokenSupply_ == 0){
490             return tokenPriceInitial_ + tokenPriceIncremental_;
491         } else {
492             uint256 _ethereum = tokensToEthereum_(1e18);
493             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
494             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
495             return _taxedEthereum;
496         }
497     }
498     
499     /**
500      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
501      */
502     function calculateTokensReceived(uint256 _ethereumToSpend) 
503         public 
504         view 
505         returns(uint256)
506     {
507         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
508         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
509         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
510         
511         return _amountOfTokens;
512     }
513     
514     /**
515      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
516      */
517     function calculateEthereumReceived(uint256 _tokensToSell) 
518         public 
519         view 
520         returns(uint256)
521     {
522         require(_tokensToSell <= tokenSupply_);
523         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
524         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
525         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
526         return _taxedEthereum;
527     }
528     
529     function PayJackpot() public{
530         if (block.timestamp > Timer && Jackpot != address(0x0)){
531             uint256 pay = (SafeMath.div(SafeMath.mul(JackpotAmount, JackpotPay), 100));
532             referralBalance_[Jackpot] += pay; 
533             Jackpot = address(0x0);
534             JackpotAmount = SafeMath.sub(JackpotAmount, (uint256) (pay));
535         }
536     }
537     
538     /*==========================================
539     =            INTERNAL FUNCTIONS            =
540     ==========================================*/
541     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
542         internal
543         returns(uint256)
544     {
545       
546         if (block.timestamp > Timer){
547             // pay jp 
548             PayJackpot();
549         }
550         // yes, reinvests count too 
551         if (_incomingEthereum >= GetJackpotMin()){
552             Jackpot = msg.sender;
553             Timer = block.timestamp + JackpotTimer;
554         }
555         // data setup
556         address _customerAddress = msg.sender;
557         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
558         bool ref = (_referredBy != 0x0000000000000000000000000000000000000000 && _referredBy != _customerAddress && tokenBalanceLedger_[_referredBy] >= stakingRequirement);
559         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
560         if (!ref){
561             _referralBonus = 0;
562         }
563         uint256 _jackpotAmount = SafeMath.div(SafeMath.sub(_undividedDividends, _referralBonus), JackpotCut);
564         JackpotAmount = SafeMath.add(JackpotAmount,  _jackpotAmount);
565         uint256 _dividends = SafeMath.sub(SafeMath.sub(_undividedDividends, _referralBonus),_jackpotAmount);
566         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
567         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
568         uint256 _fee = _dividends * magnitude;
569  
570         // no point in continuing execution if OP is a poorfag russian hacker
571         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
572         // (or hackers)
573         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
574         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
575         
576         // is the user referred by a masternode?
577         if(
578             ref
579         ){
580             // wealth redistribution
581             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
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