1 pragma solidity ^0.4.20;
2 
3 /*
4 	Welcome all to proof of weak hands classic, the contract to mark the end of all pump and dump scam contracts. 
5 	we aim to bring back the good old days of that climbing vibe you get with p3d, but without the nazis blanket banning
6 	everyone! so without further ado..... we present....
7 	
8     	__       _      __ __ __       
9       / _ \ ___ | | /| / // // /____   
10      / ___// _ \| |/ |/ // _  // __/   
11     /_/    \___/|__/|__//_//_/ \__/ 
12 	
13 	
14 */
15 
16 contract ProofOfWeakHandsClassic {
17     /*=================================
18     =            MODIFIERS            =
19     =================================*/
20     // only people with tokens
21     modifier onlyBagholders() {
22         require(myTokens() > 0);
23         _;
24     }
25 
26     // only people with profits
27     modifier onlyStronghands() {
28         require(myDividends(true) > 0);
29         _;
30     }
31 
32     // administrators can:
33     // -> change the name of the contract
34     // -> change the name of the token
35     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
36     // they CANNOT:
37     // -> take funds
38     // -> disable withdrawals
39     // -> kill the contract
40     // -> change the price of tokens
41     modifier onlyAdministrator(){
42         address _customerAddress = msg.sender;
43         require(administrators[_customerAddress]);
44         _;
45     }
46 
47 
48     // ensures that the first tokens in the contract will be equally distributed
49     // meaning, no divine dump will be ever possible
50     // result: healthy longevity.
51     modifier antiEarlyWhale(uint256 _amountOfEthereum){
52         address _customerAddress = msg.sender;
53 
54         // are we still in the vulnerable phase?
55         // if so, enact anti early whale protocol
56         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
57             require(
58                 // is the customer in the ambassador list?
59                 ambassadors_[_customerAddress] == true &&
60 
61                 // does the customer purchase exceed the max ambassador quota?
62                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
63 
64             );
65 
66             // updated the accumulated quota
67             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
68 
69             // execute
70             _;
71         } else {
72             // in case the ether count drops low, the ambassador phase won't reinitiate
73             onlyAmbassadors = false;
74             _;
75         }
76     }
77 
78     /*==============================
79     =            EVENTS            =
80     ==============================*/
81     event onTokenPurchase(
82         address indexed customerAddress,
83         uint256 incomingEthereum,
84         uint256 tokensMinted,
85         address indexed referredBy
86     );
87 
88     event onTokenSell(
89         address indexed customerAddress,
90         uint256 tokensBurned,
91         uint256 ethereumEarned
92     );
93 
94     event onReinvestment(
95         address indexed customerAddress,
96         uint256 ethereumReinvested,
97         uint256 tokensMinted
98     );
99 
100     event onWithdraw(
101         address indexed customerAddress,
102         uint256 ethereumWithdrawn
103     );
104 
105     // ERC20
106     event Transfer(
107         address indexed from,
108         address indexed to,
109         uint256 tokens
110     );
111 
112     /*=====================================
113     =            CONFIGURABLES            =
114     =====================================*/
115     string public name = "Proof of weak hands classic";
116     string public symbol = "PWHc";
117     uint8 constant public decimals = 18;
118     uint8 constant internal entryFee_ = 10; // 10% to enter our community
119     uint8 constant internal refferalFee_ = 20; // 20% from enter fee divs or 7% for each invite, great for inviting new members for our community
120     uint8 constant internal exitFee_ = 10; // 10% for selling
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
133     // referral program
134     mapping(address => uint256) internal referrals;
135     mapping(address => bool) internal isUser;
136     address[] public usersAddresses;
137 
138    /*================================
139     =            DATASETS            =
140     ================================*/
141     // amount of shares for each address (scaled number)
142     mapping(address => uint256) internal tokenBalanceLedger_;
143     mapping(address => uint256) internal referralBalance_;
144     mapping(address => int256) internal payoutsTo_;
145     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
146     uint256 internal tokenSupply_ = 0;
147     uint256 internal profitPerShare_;
148 
149     // administrator list (see above on what they can do)
150     mapping(address => bool) public administrators;
151 
152     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
153     bool public onlyAmbassadors = true;
154 
155     /*=======================================
156     =            PUBLIC FUNCTIONS            =
157     =======================================*/
158     /*
159     * -- APPLICATION ENTRY POINTS --
160     */
161     function ProofOfWeakHandsClassic()
162         public
163     {
164         // add administrators here with their wallets
165 
166   		// the top node is the community node that will hold the first chunk of tokens, will never sell, only spread
167 		// dividends across the bottom 30 percent of token holders
168 		administrators[0xF2c2e2a6f9232451483a054492Aed1D0d376F46e] = true;
169 		ambassadors_[0xF2c2e2a6f9232451483a054492Aed1D0d376F46e] = true;
170 		ambassadors_[0x84e8Ca4aCE52933eC23A4E362F0545bBc3Fb5dAB] = true; 
171 		
172 		administrators[msg.sender] = true;
173 		ambassadors_[msg.sender] = true;
174     }
175 
176 
177     /**
178      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
179      */
180     function buy(address _referredBy)
181         public
182         payable
183         returns(uint256)
184     {
185         purchaseTokens(msg.value, _referredBy);
186     }
187 
188     /**
189      * Fallback function to handle ethereum that was send straight to the contract
190      * Unfortunately we cannot use a referral address this way.
191      */
192     function()
193         payable
194         public
195     {
196         purchaseTokens(msg.value, 0x0);
197     }
198 
199     /* Converts all of caller's dividends to tokens. */
200     function reinvest() onlyStronghands() public {
201         // fetch dividends
202         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
203 
204         // pay out the dividends virtually
205         address _customerAddress = msg.sender;
206         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
207 
208         // retrieve ref. bonus
209         _dividends += referralBalance_[_customerAddress];
210         referralBalance_[_customerAddress] = 0;
211 
212         // dispatch a buy order with the virtualized "withdrawn dividends"
213         uint256 _tokens = purchaseTokens(_dividends, 0x0);
214 
215         // fire event
216         onReinvestment(_customerAddress, _dividends, _tokens);
217     }
218 
219     /* Alias of sell() and withdraw(). */
220     function exit() public {
221         // get token count for caller & sell them all
222         address _customerAddress = msg.sender;
223         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
224         if(_tokens > 0) sell(_tokens);
225 
226         // lambo delivery service
227         withdraw();
228     }
229 
230     /* Withdraws all of the callers earnings. */
231     function withdraw() onlyStronghands() public {
232         // setup data
233         address _customerAddress = msg.sender;
234         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
235 
236         // update dividend tracker
237         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
238 
239         // add ref. bonus
240         _dividends += referralBalance_[_customerAddress];
241         referralBalance_[_customerAddress] = 0;
242 
243         // AU falcon delivery service
244         _customerAddress.transfer(_dividends);
245 
246         // fire event
247         onWithdraw(_customerAddress, _dividends);
248     }
249 
250     /* Liquifies tokens to ethereum. */
251     function sell(uint256 _amountOfTokens) onlyBagholders() public {
252         // setup data
253         address _customerAddress = msg.sender;
254         // russian hackers BTFO
255         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
256         uint256 _tokens = _amountOfTokens;
257         uint256 _ethereum = tokensToEthereum_(_tokens);
258         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
259         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
260 
261         // burn the sold tokens
262         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
263         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
264 
265         // update dividends tracker
266         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
267         payoutsTo_[_customerAddress] -= _updatedPayouts;
268 
269         // dividing by zero is a bad idea
270         if (tokenSupply_ > 0) {
271             // update the amount of dividends per token
272             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
273         }
274 
275         // fire event
276         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
277     }
278 
279 
280     /* Transfer tokens from the caller to a new holder. * No fee! */
281     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders() public returns(bool) {
282         // setup
283         address _customerAddress = msg.sender;
284 
285         // make sure we have the requested tokens
286         // also disables transfers until ambassador phase is over
287         // ( we dont want whale premines )
288         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
289 
290         // withdraw all outstanding dividends first
291         if(myDividends(true) > 0) withdraw();
292 
293         // exchange tokens
294         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
295         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
296 
297         // update dividend trackers
298         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
299         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
300 
301         // fire event
302         Transfer(_customerAddress, _toAddress, _amountOfTokens);
303 
304         // ERC20
305         return true;
306 
307     }
308 
309     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
310     /**
311      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
312      */
313     function disableInitialStage()
314         onlyAdministrator()
315         public
316     {
317         onlyAmbassadors = false;
318     }
319 
320     /**
321      * In case one of us dies, we need to replace ourselves.
322      */
323     function setAdministrator(address _identifier, bool _status)
324         onlyAdministrator()
325         public
326     {
327         administrators[_identifier] = _status;
328     }
329 
330     /**
331      * Precautionary measures in case we need to adjust the masternode rate.
332      */
333     function setStakingRequirement(uint256 _amountOfTokens)
334         onlyAdministrator()
335         public
336     {
337         stakingRequirement = _amountOfTokens;
338     }
339 
340     /**
341      * If we want to rebrand, we can.
342      */
343     function setName(string _name)
344         onlyAdministrator()
345         public
346     {
347         name = _name;
348     }
349 
350     /**
351      * If we want to rebrand, we can.
352      */
353     function setSymbol(string _symbol)
354         onlyAdministrator()
355         public
356     {
357         symbol = _symbol;
358     }
359 
360 
361     /*----------  HELPERS AND CALCULATORS  ----------*/
362     /**
363      * Method to view the current Ethereum stored in the contract
364      * Example: totalEthereumBalance()
365      */
366     function totalEthereumBalance()
367         public
368         view
369         returns(uint)
370     {
371         return this.balance;
372     }
373 
374     /**
375      * Retrieve the total token supply.
376      */
377     function totalSupply()
378         public
379         view
380         returns(uint256)
381     {
382         return tokenSupply_;
383     }
384 
385     /**
386      * Retrieve the tokens owned by the caller.
387      */
388     function myTokens()
389         public
390         view
391         returns(uint256)
392     {
393         address _customerAddress = msg.sender;
394         return balanceOf(_customerAddress);
395     }
396 
397     function referralsOf(address _customerAddress)
398         public
399         view
400         returns(uint256)
401     {
402         return referrals[_customerAddress];
403     }
404 
405     function totalUsers()
406         public
407         view
408         returns(uint256)
409     {
410         return usersAddresses.length;
411     }
412 
413     /**
414      * Retrieve the dividends owned by the caller.
415      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
416      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
417      * But in the internal calculations, we want them separate.
418      */
419     function myDividends(bool _includeReferralBonus)
420         public
421         view
422         returns(uint256)
423     {
424         address _customerAddress = msg.sender;
425         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
426     }
427 
428     /**
429      * Retrieve the token balance of any single address.
430      */
431     function balanceOf(address _customerAddress)
432         view
433         public
434         returns(uint256)
435     {
436         return tokenBalanceLedger_[_customerAddress];
437     }
438 
439     /**
440      * Retrieve the dividend balance of any single address.
441      */
442     function dividendsOf(address _customerAddress)
443         view
444         public
445         returns(uint256)
446     {
447         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
448     }
449 
450     /**
451      * Return the buy price of 1 individual token.
452      */
453     function sellPrice()
454         public
455         view
456         returns(uint256)
457     {
458         // our calculation relies on the token supply, so we need supply. Doh.
459         if(tokenSupply_ == 0){
460             return tokenPriceInitial_ - tokenPriceIncremental_;
461         } else {
462             uint256 _ethereum = tokensToEthereum_(1e18);
463             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
464             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
465             return _taxedEthereum;
466         }
467     }
468 
469     /**
470      * Return the sell price of 1 individual token.
471      */
472     function buyPrice()
473         public
474         view
475         returns(uint256)
476     {
477         // our calculation relies on the token supply, so we need supply. Doh.
478         if(tokenSupply_ == 0){
479             return tokenPriceInitial_ + tokenPriceIncremental_;
480         } else {
481             uint256 _ethereum = tokensToEthereum_(1e18);
482             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
483             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
484             return _taxedEthereum;
485         }
486     }
487 
488     /**
489      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
490      */
491     function calculateTokensReceived(uint256 _ethereumToSpend)
492         public
493         view
494         returns(uint256)
495     {
496         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
497         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
498         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
499 
500         return _amountOfTokens;
501     }
502 
503     /**
504      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
505      */
506     function calculateEthereumReceived(uint256 _tokensToSell)
507         public
508         view
509         returns(uint256)
510     {
511         require(_tokensToSell <= tokenSupply_);
512         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
513         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
514         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
515         return _taxedEthereum;
516     }
517 
518 
519     /*==========================================
520     =            INTERNAL FUNCTIONS            =
521     ==========================================*/
522     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
523         antiEarlyWhale(_incomingEthereum)
524         internal
525         returns(uint256)
526     {
527         // data setup
528         address _customerAddress = msg.sender;
529         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
530         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
531         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
532         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
533         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
534         uint256 _fee = _dividends * magnitude;
535 
536         // no point in continuing execution if OP is a poorfag russian hacker
537         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
538         // (or hackers)
539         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
540         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
541 
542         // is the user referred by a masternode?
543         if(
544             // is this a referred purchase?
545             _referredBy != 0x0000000000000000000000000000000000000000 &&
546 
547             // no cheating!
548             _referredBy != _customerAddress &&
549 
550             // does the referrer have at least X whole tokens?
551             // i.e is the referrer a Kekly chad masternode
552             tokenBalanceLedger_[_referredBy] >= stakingRequirement
553         ){
554             // wealth redistribution
555             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
556 
557             if (isUser[_customerAddress] == false) {
558             	referrals[_referredBy]++;
559             }     
560 
561         } else {
562             // no ref purchase
563             // add the referral bonus back to the global dividends cake
564             _dividends = SafeMath.add(_dividends, _referralBonus);
565             _fee = _dividends * magnitude;
566         }
567 
568         if (isUser[_customerAddress] == false ) {
569         	isUser[_customerAddress] = true;
570         	usersAddresses.push(_customerAddress);
571         }
572 
573         // we can't give people infinite ethereum
574         if(tokenSupply_ > 0){
575 
576             // add tokens to the pool
577             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
578 
579             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
580             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
581 
582             // calculate the amount of tokens the customer receives over his purchase
583             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
584 
585         } else {
586             // add tokens to the pool
587             tokenSupply_ = _amountOfTokens;
588         }
589 
590         // update circulating supply & the ledger address for the customer
591         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
592 
593         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
594         //really i know you think you do but you don't
595         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
596         payoutsTo_[_customerAddress] += _updatedPayouts;
597 
598         // fire event
599         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
600 
601         return _amountOfTokens;
602     }
603 
604     /**
605      * Calculate Token price based on an amount of incoming ethereum
606      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
607      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
608      */
609     function ethereumToTokens_(uint256 _ethereum)
610         internal
611         view
612         returns(uint256)
613     {
614         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
615         uint256 _tokensReceived =
616          (
617             (
618                 // underflow attempts BTFO
619                 SafeMath.sub(
620                     (sqrt
621                         (
622                             (_tokenPriceInitial**2)
623                             +
624                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
625                             +
626                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
627                             +
628                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
629                         )
630                     ), _tokenPriceInitial
631                 )
632             )/(tokenPriceIncremental_)
633         )-(tokenSupply_)
634         ;
635 
636         return _tokensReceived;
637     }
638 
639     /**
640      * Calculate token sell value.
641      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
642      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
643      */
644      function tokensToEthereum_(uint256 _tokens)
645         internal
646         view
647         returns(uint256)
648     {
649 
650         uint256 tokens_ = (_tokens + 1e18);
651         uint256 _tokenSupply = (tokenSupply_ + 1e18);
652         uint256 _etherReceived =
653         (
654             // underflow attempts BTFO
655             SafeMath.sub(
656                 (
657                     (
658                         (
659                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
660                         )-tokenPriceIncremental_
661                     )*(tokens_ - 1e18)
662                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
663             )
664         /1e18);
665         return _etherReceived;
666     }
667 
668 
669     //This is where all your gas goes, sorry
670     //Not sorry, you probably only paid 1 gwei
671     function sqrt(uint x) internal pure returns (uint y) {
672         uint z = (x + 1) / 2;
673         y = x;
674         while (z < y) {
675             y = z;
676             z = (x / z + z) / 2;
677         }
678     }
679 }
680 
681 /**
682  * @title SafeMath
683  * @dev Math operations with safety checks that throw on error
684  */
685 library SafeMath {
686 
687     /**
688     * @dev Multiplies two numbers, throws on overflow.
689     */
690     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
691         if (a == 0) {
692             return 0;
693         }
694         uint256 c = a * b;
695         assert(c / a == b);
696         return c;
697     }
698 
699     /**
700     * @dev Integer division of two numbers, truncating the quotient.
701     */
702     function div(uint256 a, uint256 b) internal pure returns (uint256) {
703         // assert(b > 0); // Solidity automatically throws when dividing by 0
704         uint256 c = a / b;
705         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
706         return c;
707     }
708 
709     /**
710     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
711     */
712     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
713         assert(b <= a);
714         return a - b;
715     }
716 
717     /**
718     * @dev Adds two numbers, throws on overflow.
719     */
720     function add(uint256 a, uint256 b) internal pure returns (uint256) {
721         uint256 c = a + b;
722         assert(c >= a);
723         return c;
724     }
725 }