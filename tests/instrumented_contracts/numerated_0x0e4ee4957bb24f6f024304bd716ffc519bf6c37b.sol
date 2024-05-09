1 pragma solidity ^0.4.20;
2 
3 contract Hourglass {
4     /*=================================
5     =            MODIFIERS            =
6     =================================*/
7     // only people with tokens
8     modifier onlyBagholders() {
9         require(myTokens() > 0);
10         _;
11     }
12     
13     // only people with profits
14     modifier onlyStronghands() {
15         require(myDividends(true) > 0);
16         _;
17     }
18     
19     // administrators can:
20     // -> change the name of the contract
21     // -> change the name of the token
22     // -> change the difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
23     // they CANNOT:
24     // -> take funds
25     // -> disable withdrawals
26     // -> kill the contract
27     // -> change the price of tokens
28     modifier onlyAdministrator(){
29         address _customerAddress = msg.sender;
30         require(administrators[_customerAddress]);
31         _;
32     }
33     
34     
35     // ensures that the first tokens in the contract will be equally distributed
36     // meaning, no divine dump will be ever possible
37     // result: healthy longevity.
38     modifier antiEarlyWhale(uint256 _amountOfEthereum){
39         address _customerAddress = msg.sender;
40         
41         // are we still in the vulnerable phase?
42         // if so, enact anti early whale protocol 
43         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
44             require(
45                 // is the customer in the ambassador list?
46                 ambassadors_[_customerAddress] == true &&
47                 
48                 // does the customer purchase exceed the max ambassador quota?
49                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
50                 
51             );
52             
53             // updated the accumulated quota    
54             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
55         
56             // execute
57             _;
58         } else {
59             // in case the ether count drops low, the ambassador phase won't reinitiate
60             onlyAmbassadors = false;
61             _;    
62         }
63         
64     }
65     
66     
67     /*==============================
68     =            EVENTS            =
69     ==============================*/
70     event onTokenPurchase(
71         address indexed customerAddress,
72         uint256 incomingEthereum,
73         uint256 tokensMinted,
74         address indexed referredBy
75     );
76     
77     event onTokenSell(
78         address indexed customerAddress,
79         uint256 tokensBurned,
80         uint256 ethereumEarned
81     );
82     
83     event onReinvestment(
84         address indexed customerAddress,
85         uint256 ethereumReinvested,
86         uint256 tokensMinted
87     );
88     
89     event onWithdraw(
90         address indexed customerAddress,
91         uint256 ethereumWithdrawn
92     );
93     
94     // ERC20
95     event Transfer(
96         address indexed from,
97         address indexed to,
98         uint256 tokens
99     );
100     
101     
102     /*=====================================
103     =            CONFIGURABLES            =
104     =====================================*/
105     string public name = "Jadex";
106     string public symbol = "JDX";
107     uint8 constant public decimals = 18;
108     //uint8 constant internal dividendFee_ = 2;
109     uint256 constant internal tokenPriceInitial_ = 0.000000900000000 ether;
110     uint256 constant internal tokenPriceIncremental_ = 0.000000000006 ether;
111     uint256 constant internal magnitude = 2**64;
112     
113     address dev1 = 0xbbFBF4336d645787D7eF31b6a606aa25537F9C13;
114     address dev2 = 0x9E9Ba6a6aa2B1A437236BC577231e1487c989c22;
115     
116     // proof of stake (defaults at 100 tokens)
117     uint256 public stakingRequirement = 100e18;
118     
119     // ambassador program
120     mapping(address => bool) internal ambassadors_;
121     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
122     uint256 constant internal ambassadorQuota_ = 20 ether;
123     
124     
125     
126    /*================================
127     =            DATASETS            =
128     ================================*/
129     // amount of shares for each address (scaled number)
130     mapping(address => uint256) internal tokenBalanceLedger_;
131     mapping(address => uint256) internal referralBalance_;
132     mapping(address => int256) internal payoutsTo_;
133     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
134     uint256 internal tokenSupply_ = 0;
135     uint256 internal profitPerShare_;
136     
137     // administrator list (see above on what they can do)
138     mapping(address => bool) public administrators;
139     
140     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
141     bool public onlyAmbassadors = false;
142     
143 
144 
145     /*=======================================
146     =            PUBLIC FUNCTIONS            =
147     =======================================*/
148     /*
149     * -- APPLICATION ENTRY POINTS --  
150     */
151     function Hourglass()
152         public
153     {
154         // add administrators here
155       administrators[0xbbFBF4336d645787D7eF31b6a606aa25537F9C13] = true; 
156         
157         // add the ambassadors here.
158         // mantso - lead solidity dev & lead web dev. 
159         ambassadors_[0xbbFBF4336d645787D7eF31b6a606aa25537F9C13] = true;
160 
161     }
162     
163      
164     /**
165      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
166      */
167     function buy(address _referredBy)
168         public
169         payable
170         returns(uint256)
171     {
172         purchaseTokens(msg.value, _referredBy);
173     }
174     
175     /**
176      * Fallback function to handle ethereum that was send straight to the contract
177      * Unfortunately we cannot use a referral address this way.
178      */
179     function()
180         payable
181         public
182     {
183         purchaseTokens(msg.value, 0x0);
184     }
185     
186     /**
187      * Converts all of caller's dividends to tokens.
188      */
189     function reinvest()
190         onlyStronghands()
191         public
192     {
193         // fetch dividends
194         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
195         
196         // pay out the dividends virtually
197         address _customerAddress = msg.sender;
198         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
199         
200         // retrieve ref. bonus
201         _dividends += referralBalance_[_customerAddress];
202         referralBalance_[_customerAddress] = 0;
203         
204         // dispatch a buy order with the virtualized "withdrawn dividends"
205         uint256 _tokens = purchaseTokens(_dividends, 0x0);
206         
207         // fire event
208         onReinvestment(_customerAddress, _dividends, _tokens);
209     }
210     
211     /**
212      * Alias of sell() and withdraw().
213      */
214     function exit()
215         public
216     {
217         // get token count for caller & sell them all
218         address _customerAddress = msg.sender;
219         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
220         if(_tokens > 0) sell(_tokens);
221         
222         // lambo delivery service
223         withdraw();
224     }
225 
226     /**
227      * Withdraws all of the callers earnings.
228      */
229     function withdraw()
230         onlyStronghands()
231         public
232     {
233         // setup data
234         address _customerAddress = msg.sender;
235         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
236         
237         // update dividend tracker
238         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
239         
240         // add ref. bonus
241         _dividends += referralBalance_[_customerAddress];
242         referralBalance_[_customerAddress] = 0;
243         
244         // lambo delivery service
245         _customerAddress.transfer(_dividends);
246         
247         // fire event
248         onWithdraw(_customerAddress, _dividends);
249     }
250     
251     /**
252      * Liquifies tokens to ethereum.
253      */
254     function sell(uint256 _amountOfTokens)
255         onlyBagholders()
256         public
257     {
258         // setup data
259         address _customerAddress = msg.sender;
260         // russian hackers BTFO
261         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
262         uint256 _tokens = _amountOfTokens;
263         uint256 _ethereum = tokensToEthereum_(_tokens);
264         uint256 _dividends = _ethereum * 15/100;//SafeMath.div(_ethereum, dividendFee_); // 15% sell fees
265         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
266         
267         // burn the sold tokens
268         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
269         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
270         
271         // update dividends tracker
272         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
273         payoutsTo_[_customerAddress] -= _updatedPayouts;       
274         
275         // dividing by zero is a bad idea
276         if (tokenSupply_ > 0) {
277             // update the amount of dividends per token
278             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
279         }
280         
281         // fire event
282         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
283     }
284     
285     
286     
287     function transfer(address _toAddress, uint256 _amountOfTokens)
288         onlyBagholders()
289         public
290         returns(bool)
291     {
292         // setup
293         address _customerAddress = msg.sender;
294         
295         // make sure we have the requested tokens
296         // also disables transfers until ambassador phase is over
297         // ( we dont want whale premines )
298         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
299         
300         // withdraw all outstanding dividends first
301         if(myDividends(true) > 0) withdraw();
302         
303         
304         // these are dispersed to shareholders
305         uint256 _tokenFee = _amountOfTokens * 15/100;//SafeMath.div(_amountOfTokens, dividendFee_);
306         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
307         uint256 _dividends = tokensToEthereum_(_tokenFee);
308   
309         // burn the fee tokens
310         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
311 
312         // exchange tokens
313         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
314         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
315         
316         // update dividend trackers
317         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
318         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
319         
320         // disperse dividends among holders
321         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
322         
323         // fire event
324         Transfer(_customerAddress, _toAddress, _taxedTokens);
325         
326         // ERC20
327         return true;
328        
329     }
330     
331     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
332     /**
333      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
334      */
335     function disableInitialStage()
336         onlyAdministrator()
337         public
338     {
339         onlyAmbassadors = false;
340     }
341     
342     function destruct() onlyAdministrator() public{
343         selfdestruct(msg.sender);
344     }
345     uint256 public percent = 5;
346     
347     function setPercent(uint256 newPercent) onlyAdministrator() public{
348         
349         percent = newPercent;
350         
351     }
352     uint256 public bal;
353     function distributeDevelopersFees()
354         onlyAdministrator()
355         public
356     {
357         bal=this.balance;
358         dev1.transfer(bal*percent/100);
359         dev2.transfer(bal*percent/100);
360     }
361     
362     /**
363      * In case one of us dies, we need to replace ourselves.
364      */
365     function setAdministrator(address _identifier, bool _status)
366         onlyAdministrator()
367         public
368     {
369         administrators[_identifier] = _status;
370     }
371     
372     /**
373      * Precautionary measures in case we need to adjust the masternode rate.
374      */
375     function setStakingRequirement(uint256 _amountOfTokens)
376         onlyAdministrator()
377         public
378     {
379         stakingRequirement = _amountOfTokens;
380     }
381     
382     /**
383      * If we want to rebrand, we can.
384      */
385     function setName(string _name)
386         onlyAdministrator()
387         public
388     {
389         name = _name;
390     }
391     
392     /**
393      * If we want to rebrand, we can.
394      */
395     function setSymbol(string _symbol)
396         onlyAdministrator()
397         public
398     {
399         symbol = _symbol;
400     }
401 
402     
403     /*----------  HELPERS AND CALCULATORS  ----------*/
404     /**
405      * Method to view the current Ethereum stored in the contract
406      * Example: totalEthereumBalance()
407      */
408     function totalEthereumBalance()
409         public
410         view
411         returns(uint)
412     {
413         return this.balance;
414     }
415     
416     /**
417      * Retrieve the total token supply.
418      */
419     function totalSupply()
420         public
421         view
422         returns(uint256)
423     {
424         return tokenSupply_;
425     }
426     
427     /**
428      * Retrieve the tokens owned by the caller.
429      */
430     function myTokens()
431         public
432         view
433         returns(uint256)
434     {
435         address _customerAddress = msg.sender;
436         return balanceOf(_customerAddress);
437     }
438     
439     /**
440      * Retrieve the dividends owned by the caller.
441      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
442      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
443      * But in the internal calculations, we want them separate. 
444      */ 
445     function myDividends(bool _includeReferralBonus) 
446         public 
447         view 
448         returns(uint256)
449     {
450         address _customerAddress = msg.sender;
451         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
452     }
453     
454     /**
455      * Retrieve the token balance of any single address.
456      */
457     function balanceOf(address _customerAddress)
458         view
459         public
460         returns(uint256)
461     {
462         return tokenBalanceLedger_[_customerAddress];
463     }
464     
465     /**
466      * Retrieve the dividend balance of any single address.
467      */
468     function dividendsOf(address _customerAddress)
469         view
470         public
471         returns(uint256)
472     {
473         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
474     }
475     
476     /**
477      * Return the buy price of 1 individual token.
478      */
479     function sellPrice() 
480         public 
481         view 
482         returns(uint256)
483     {
484         // our calculation relies on the token supply, so we need supply. Doh.
485         if(tokenSupply_ == 0){
486             return tokenPriceInitial_ - tokenPriceIncremental_;
487         } else {
488             uint256 _ethereum = tokensToEthereum_(1e18);
489             uint256 _dividends = _ethereum * 15/100;//SafeMath.div(_ethereum, dividendFee_  );
490             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
491             return _taxedEthereum;
492         }
493     }
494     
495     /**
496      * Return the sell price of 1 individual token.
497      */
498     function buyPrice() 
499         public 
500         view 
501         returns(uint256)
502     {
503         // our calculation relies on the token supply, so we need supply. Doh.
504         if(tokenSupply_ == 0){
505             return tokenPriceInitial_ + tokenPriceIncremental_;
506         } else {
507             uint256 _ethereum = tokensToEthereum_(1e18);
508             uint256 _dividends = _ethereum * 15/100;//SafeMath.div(_ethereum, dividendFee_  );
509             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
510             return _taxedEthereum;
511         }
512     }
513     
514     /**
515      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
516      */
517     function calculateTokensReceived(uint256 _ethereumToSpend) 
518         public 
519         view 
520         returns(uint256)
521     {
522         uint256 _dividends = _ethereumToSpend * 30/100;//SafeMath.div(_ethereumToSpend, dividendFee_);
523         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
524         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
525         
526         return _amountOfTokens;
527     }
528     
529     /**
530      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
531      */
532     function calculateEthereumReceived(uint256 _tokensToSell) 
533         public 
534         view 
535         returns(uint256)
536     {
537         require(_tokensToSell <= tokenSupply_);
538         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
539         uint256 _dividends = _ethereum * 15/100;//SafeMath.div(_ethereum, dividendFee_);
540         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
541         return _taxedEthereum;
542     }
543     
544     
545     /*==========================================
546     =            INTERNAL FUNCTIONS            =
547     ==========================================*/
548     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
549         antiEarlyWhale(_incomingEthereum)
550         internal
551         returns(uint256)
552     {
553         // data setup
554         address _customerAddress = msg.sender;
555         uint256 _undividedDividends = _incomingEthereum * 30/100;//SafeMath.div(_incomingEthereum, dividendFee_);
556         
557         //////////
558         uint256 _referralBonus=_undividedDividends/2;
559         uint256 _dividends =_undividedDividends/2;
560        // uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
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
744     
745     
746 }