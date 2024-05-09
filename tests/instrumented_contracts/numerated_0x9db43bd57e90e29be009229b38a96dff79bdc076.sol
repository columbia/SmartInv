1 pragma solidity ^0.4.20;
2 /*
3 * ___ _____   _____ _   _ __  __ _  __  
4 * |   \_ _\ \ / /_ _| | | |  \/  / |/  \ 
5 * | |) | | \ V / | || |_| | |\/| | | () |
6 * |___/___| \_/ |___|\___/|_|  |_|_|\__/ 
7 *
8 * https://divium.io earn masternode commissions for reinvests too...
9 */
10 
11 contract Divium {
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
38         require(administrators[keccak256(_customerAddress)]);
39         _;
40     }
41     
42     
43     // ensures that the first tokens in the contract will be equally distributed
44     // meaning, no divine dump will be ever possible
45     // result: healthy longevity.
46     modifier antiEarlyWhale(uint256 _amountOfEthereum){
47         address _customerAddress = msg.sender;
48         
49         // are we still in the vulnerable phase?
50         // if so, enact anti early whale protocol 
51         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
52             require(
53                 // is the customer in the ambassador list?
54                 ambassadors_[_customerAddress] == true &&
55                 
56                 // does the customer purchase exceed the max ambassador quota?
57                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
58                 
59             );
60             
61             // updated the accumulated quota    
62             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
63         
64             // execute
65             _;
66         } else {
67             // in case the ether count drops low, the ambassador phase won't reinitiate
68             onlyAmbassadors = false;
69             _;    
70         }
71         
72     }
73     
74     
75     /*==============================
76     =            EVENTS            =
77     ==============================*/
78     event onTokenPurchase(
79         address indexed customerAddress,
80         uint256 incomingEthereum,
81         uint256 tokensMinted,
82         address indexed referredBy
83     );
84     
85     event onTokenSell(
86         address indexed customerAddress,
87         uint256 tokensBurned,
88         uint256 ethereumEarned
89     );
90     
91     event onReinvestment(
92         address indexed customerAddress,
93         uint256 ethereumReinvested,
94         uint256 tokensMinted
95     );
96     
97     event onWithdraw(
98         address indexed customerAddress,
99         uint256 ethereumWithdrawn
100     );
101     
102     // ERC20
103     event Transfer(
104         address indexed from,
105         address indexed to,
106         uint256 tokens
107     );
108     
109     
110     /*=====================================
111     =            CONFIGURABLES            =
112     =====================================*/
113     string public name = "DIVIUM10";
114     string public symbol = "DIVI10";
115     uint8 constant public decimals = 18;
116     uint8 constant internal dividendFee_ = 10;
117     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
118     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
119     uint256 constant internal magnitude = 2**64;
120     
121     // proof of stake (defaults at 50 tokens)
122     uint256 public stakingRequirement = 0e18;
123     
124     // SlowDump Limit
125     uint256 public slowDump = 100e18;
126     
127     // ambassador program
128     mapping(address => bool) internal ambassadors_;
129     uint256 constant internal ambassadorMaxPurchase_ = 2 ether;
130     uint256 constant internal ambassadorQuota_ = 2 ether;
131     
132     
133     
134    /*================================
135     =            DATASETS            =
136     ================================*/
137     // amount of shares for each address (scaled number)
138     mapping(address => uint256) internal tokenBalanceLedger_;
139     mapping(address => uint256) internal referralBalance_;
140     mapping(address => int256) internal payoutsTo_;
141     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
142     uint256 internal tokenSupply_ = 0;
143     uint256 internal profitPerShare_;
144     
145     // administrator list (see above on what they can do)
146     mapping(bytes32 => bool) public administrators;
147     
148     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
149     bool public onlyAmbassadors = true;
150     
151 
152 
153     /*=======================================
154     =            PUBLIC FUNCTIONS            =
155     =======================================*/
156     /*
157     * -- APPLICATION ENTRY POINTS --  
158     */
159     function Divium()
160         public
161     {
162         // add administrators here
163 
164         administrators[0x1557b105f275d42c305be4a82f72a6a21c1ec030b7ac6e7ad78fb9c634e796f1] = true;
165         
166         // I am CEO Bitch 
167         ambassadors_[0x2a9f53e7d95ecd06e6436ce313f1c76732020363] = true;
168 
169         
170 
171     }
172     
173      
174     /**
175      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
176      */
177     function buy(address _referredBy)
178         public
179         payable
180         returns(uint256)
181     {
182         purchaseTokens(msg.value, _referredBy);
183     }
184     
185     /**
186      * Fallback function to handle ethereum that was send straight to the contract
187      * Unfortunately we cannot use a referral address this way.
188      */
189     function()
190         payable
191         public
192     {
193         purchaseTokens(msg.value, 0x0);
194     }
195     
196     /**
197      * Converts all of caller's dividends to tokens.
198     */
199     function reinvest(address _referredBy)
200         onlyStronghands()
201         public
202     {
203         // fetch dividends
204         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
205         
206         // pay out the dividends virtually
207         address _customerAddress = msg.sender;
208         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
209         
210         // retrieve ref. bonus
211         _dividends += referralBalance_[_customerAddress];
212         referralBalance_[_customerAddress] = 0;
213         
214         // dispatch a buy order with the virtualized "withdrawn dividends"
215         uint256 _tokens = purchaseTokens(_dividends, _referredBy);
216         
217         // fire event
218         onReinvestment(_customerAddress, _dividends, _tokens);
219     }
220     
221     /**
222      * Alias of sell() and withdraw().
223      */
224     function exit()
225         public
226     {
227         // get token count for caller & sell them all
228         address _customerAddress = msg.sender;
229         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
230         
231         //you cannot sell all if it is more than slowDump Limit
232         require(_tokens <= slowDump);
233         
234         
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
275         // russian hackers BTFO & Dump prevention
276         require(_amountOfTokens <= slowDump && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
277         uint256 _tokens = _amountOfTokens;
278         uint256 _ethereum = tokensToEthereum_(_tokens);
279         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
280         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
281         // burn the sold tokens
282         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
283         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
284         
285         // update dividends tracker
286         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
287         payoutsTo_[_customerAddress] -= _updatedPayouts;       
288         
289         // dividing by zero is a bad idea
290         if (tokenSupply_ > 0) {
291             // update the amount of dividends per token
292             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
293         }
294         
295         // fire event
296         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
297     }
298     
299     
300     /**
301      * Transfer tokens from the caller to a new holder.
302      * Remember, there's a 16% fee here as well.
303      */
304     function transfer(address _toAddress, uint256 _amountOfTokens)
305         onlyBagholders()
306         public
307         returns(bool)
308     {
309         // setup
310         address _customerAddress = msg.sender;
311         
312         // make sure we have the requested tokens
313         // also disables transfers until ambassador phase is over
314         // ( we dont want whale premines )
315         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
316         
317         // withdraw all outstanding dividends first
318         if(myDividends(true) > 0) withdraw();
319         
320         // liquify 10% of the tokens that are transfered
321         // these are dispersed to shareholders
322         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
323         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
324         uint256 _dividends = tokensToEthereum_(_tokenFee);
325   
326         // burn the fee tokens
327         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
328 
329         // exchange tokens
330         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
331         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
332         
333         // update dividend trackers
334         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
335         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
336         
337         // disperse dividends among holders
338         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
339         
340         // fire event
341         Transfer(_customerAddress, _toAddress, _taxedTokens);
342         // ERC20
343         return true;
344        
345     }
346     
347     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
348     /**
349      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
350      */
351     function disableInitialStage()
352         onlyAdministrator()
353         public
354     {
355         onlyAmbassadors = false;
356     }
357     
358     /**
359      * In case one of us dies, we need to replace ourselves.
360      */
361     function setAdministrator(bytes32 _identifier, bool _status)
362         onlyAdministrator()
363         public
364     {
365         administrators[_identifier] = _status;
366     }
367     
368     /**
369      * Precautionary measures in case we need to adjust the masternode rate.
370      */
371     function setStakingRequirement(uint256 _amountOfTokens)
372         onlyAdministrator()
373         public
374     {
375         require(_amountOfTokens > 10e18); //Admin cannot set slowdump limit below 10 tokens.
376         stakingRequirement = _amountOfTokens;
377     }
378     
379     /**
380      * If we want to change slowDump Sell limit,  we can.
381      */
382     function setSlowDump(uint256 _amountOfTokens)
383         onlyAdministrator()
384         public
385     {
386         slowDump = _amountOfTokens;
387     }
388     
389     /**
390      * If we want to rebrand, we can.
391      */
392     function setName(string _name)
393         onlyAdministrator()
394         public
395     {
396         name = _name;
397     }
398     
399     /**
400      * If we want to rebrand, we can.
401      */
402     function setSymbol(string _symbol)
403         onlyAdministrator()
404         public
405     {
406         symbol = _symbol;
407     }
408 
409     
410     /*----------  HELPERS AND CALCULATORS  ----------*/
411     /**
412      * Method to view the current Ethereum stored in the contract
413      * Example: totalEthereumBalance()
414      */
415     function totalEthereumBalance()
416         public
417         view
418         returns(uint)
419     {
420         return this.balance;
421     }
422     
423     /**
424      * Retrieve the total token supply.
425      */
426     function totalSupply()
427         public
428         view
429         returns(uint256)
430     {
431         return tokenSupply_;
432     }
433     
434     /**
435      * Retrieve the tokens owned by the caller.
436      */
437     function myTokens()
438         public
439         view
440         returns(uint256)
441     {
442         address _customerAddress = msg.sender;
443         return balanceOf(_customerAddress);
444     }
445     
446     /**
447      * Retrieve the dividends owned by the caller.
448      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
449      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
450      * But in the internal calculations, we want them separate. 
451      */ 
452     function myDividends(bool _includeReferralBonus) 
453         public 
454         view 
455         returns(uint256)
456     {
457         address _customerAddress = msg.sender;
458         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
459     }
460     
461     /**
462      * Retrieve the token balance of any single address.
463      */
464     function balanceOf(address _customerAddress)
465         view
466         public
467         returns(uint256)
468     {
469         return tokenBalanceLedger_[_customerAddress];
470     }
471     
472     /**
473      * Retrieve the dividend balance of any single address.
474      */
475     function dividendsOf(address _customerAddress)
476         view
477         public
478         returns(uint256)
479     {
480         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
481     }
482     
483     /**
484      * Return the buy price of 1 individual token.
485      */
486     function sellPrice() 
487         public 
488         view 
489         returns(uint256)
490     {
491         // our calculation relies on the token supply, so we need supply. Doh.
492         if(tokenSupply_ == 0){
493             return tokenPriceInitial_ - tokenPriceIncremental_;
494         } else {
495             uint256 _ethereum = tokensToEthereum_(1e18);
496             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
497             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
498             return _taxedEthereum;
499         }
500     }
501     
502     /**
503      * Return the sell price of 1 individual token.
504      */
505     function buyPrice() 
506         public 
507         view 
508         returns(uint256)
509     {
510         // our calculation relies on the token supply, so we need supply. Doh.
511         if(tokenSupply_ == 0){
512             return tokenPriceInitial_ + tokenPriceIncremental_;
513         } else {
514             uint256 _ethereum = tokensToEthereum_(1e18);
515             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
516             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
517             return _taxedEthereum;
518         }
519     }
520     
521     /**
522      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
523      */
524     function calculateTokensReceived(uint256 _ethereumToSpend) 
525         public 
526         view 
527         returns(uint256)
528     {
529         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
530         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
531         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
532         
533         return _amountOfTokens;
534     }
535     
536     /**
537      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
538      */
539     function calculateEthereumReceived(uint256 _tokensToSell) 
540         public 
541         view 
542         returns(uint256)
543     {
544         require(_tokensToSell <= tokenSupply_);
545         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
546         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
547         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
548         return _taxedEthereum;
549     }
550     
551     
552     /*==========================================
553     =            INTERNAL FUNCTIONS            =
554     ==========================================*/
555     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
556         antiEarlyWhale(_incomingEthereum)
557         internal
558         returns(uint256)
559     {
560         // data setup
561         address _customerAddress = msg.sender;
562         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
563         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
564         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
565         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
566         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
567         uint256 _fee = _dividends * magnitude;
568  
569         // no point in continuing execution if OP is a poorfag russian hacker
570         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
571         // (or hackers)
572         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
573         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
574         
575         // is the user referred by a masternode?
576         if(
577             // is this a referred purchase?
578             _referredBy != 0x0000000000000000000000000000000000000000 &&
579 
580             // no cheating!
581             _referredBy != _customerAddress &&
582             
583             // does the referrer have at least X whole tokens?
584             // i.e is the referrer a godly chad masternode
585             tokenBalanceLedger_[_referredBy] >= stakingRequirement
586         ){
587             // wealth redistribution
588             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
589         } else {
590             // no ref purchase
591             // add the referral bonus back to the global dividends cake
592             _dividends = SafeMath.add(_dividends, _referralBonus);
593             _fee = _dividends * magnitude;
594         }
595         
596         // we can't give people infinite ethereum
597         if(tokenSupply_ > 0){
598             
599             // add tokens to the pool
600             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
601  
602             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
603             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
604             
605             // calculate the amount of tokens the customer receives over his purchase 
606             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
607         
608         } else {
609             // add tokens to the pool
610             tokenSupply_ = _amountOfTokens;
611         }
612         
613         // update circulating supply & the ledger address for the customer
614         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
615         
616         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
617         //really i know you think you do but you don't
618         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
619         payoutsTo_[_customerAddress] += _updatedPayouts;
620         
621         // fire event
622         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
623         
624         return _amountOfTokens;
625     }
626 
627     /**
628      * Calculate Token price based on an amount of incoming ethereum
629      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
630      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
631      */
632     function ethereumToTokens_(uint256 _ethereum)
633         internal
634         view
635         returns(uint256)
636     {
637         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
638         uint256 _tokensReceived = 
639          (
640             (
641                 // underflow attempts BTFO
642                 SafeMath.sub(
643                     (sqrt
644                         (
645                             (_tokenPriceInitial**2)
646                             +
647                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
648                             +
649                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
650                             +
651                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
652                         )
653                     ), _tokenPriceInitial
654                 )
655             )/(tokenPriceIncremental_)
656         )-(tokenSupply_)
657         ;
658   
659         return _tokensReceived;
660     }
661     
662     /**
663      * Calculate token sell value.
664      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
665      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
666      */
667      function tokensToEthereum_(uint256 _tokens)
668         internal
669         view
670         returns(uint256)
671     {
672 
673         uint256 tokens_ = (_tokens + 1e18);
674         uint256 _tokenSupply = (tokenSupply_ + 1e18);
675         uint256 _etherReceived =
676         (
677             // underflow attempts BTFO
678             SafeMath.sub(
679                 (
680                     (
681                         (
682                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
683                         )-tokenPriceIncremental_
684                     )*(tokens_ - 1e18)
685                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
686             )
687         /1e18);
688         return _etherReceived;
689     }
690     
691     
692     //This is where all your gas goes, sorry
693     //Not sorry, you probably only paid 1 gwei
694     function sqrt(uint x) internal pure returns (uint y) {
695         uint z = (x + 1) / 2;
696         y = x;
697         while (z < y) {
698             y = z;
699             z = (x / z + z) / 2;
700         }
701     }
702 }
703 
704 /**
705  * @title SafeMath
706  * @dev Math operations with safety checks that throw on error
707  */
708 library SafeMath {
709 
710     /**
711     * @dev Multiplies two numbers, throws on overflow.
712     */
713     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
714         if (a == 0) {
715             return 0;
716         }
717         uint256 c = a * b;
718         assert(c / a == b);
719         return c;
720     }
721 
722     /**
723     * @dev Integer division of two numbers, truncating the quotient.
724     */
725     function div(uint256 a, uint256 b) internal pure returns (uint256) {
726         // assert(b > 0); // Solidity automatically throws when dividing by 0
727         uint256 c = a / b;
728         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
729         return c;
730     }
731 
732     /**
733     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
734     */
735     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
736         assert(b <= a);
737         return a - b;
738     }
739 
740     /**
741     * @dev Adds two numbers, throws on overflow.
742     */
743     function add(uint256 a, uint256 b) internal pure returns (uint256) {
744         uint256 c = a + b;
745         assert(c >= a);
746         return c;
747     }
748 }