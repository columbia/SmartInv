1 pragma solidity ^0.4.20;
2 /*
3 
4 ETC Version:
5 https://etherhub.io/addr/0xc2dc5e825faeb9bd274b61a2993f4f8949af4a21
6 
7 */
8 
9 contract BlackPearlETH {
10     /*=================================
11     =            MODIFIERS            =
12     =================================*/
13     // only people with tokens
14     modifier onlyBagholders() {
15         require(myTokens() > 0);
16         _;
17     }
18 
19     // only people with profits
20     modifier onlyStronghands() {
21         require(myDividends(true) > 0);
22         _;
23     }
24 
25     // administrators can:
26     // -> change the name of the contract
27     // -> change the name of the token
28     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
29     // they CANNOT:
30     // -> take funds
31     // -> disable withdrawals
32     // -> kill the contract
33     // -> change the price of tokens
34     modifier onlyAdministrator(){
35         address _customerAddress = msg.sender;
36         require(administrators[_customerAddress]);
37         _;
38     }
39 
40 
41     // ensures that the first tokens in the contract will be equally distributed
42     // meaning, no divine dump will be ever possible
43     // result: healthy longevity.
44     modifier antiEarlyWhale(uint256 _amountOfEthereum){
45         address _customerAddress = msg.sender;
46 
47         // are we still in the vulnerable phase?
48         // if so, enact anti early whale protocol
49         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
50             require(
51                 // is the customer in the ambassador list?
52                 ambassadors_[_customerAddress] == true &&
53 
54                 // does the customer purchase exceed the max ambassador quota?
55                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
56 
57             );
58 
59             // updated the accumulated quota
60             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
61 
62             // execute
63             _;
64         } else {
65             // in case the ether count drops low, the ambassador phase won't reinitiate
66             onlyAmbassadors = false;
67             _;
68         }
69     }
70 
71     /*==============================
72     =            EVENTS            =
73     ==============================*/
74     event onTokenPurchase(
75         address indexed customerAddress,
76         uint256 incomingEthereum,
77         uint256 tokensMinted,
78         address indexed referredBy
79     );
80 
81     event onTokenSell(
82         address indexed customerAddress,
83         uint256 tokensBurned,
84         uint256 ethereumEarned
85     );
86 
87     event onReinvestment(
88         address indexed customerAddress,
89         uint256 ethereumReinvested,
90         uint256 tokensMinted
91     );
92 
93     event onWithdraw(
94         address indexed customerAddress,
95         uint256 ethereumWithdrawn
96     );
97 
98     // ERC20
99     event Transfer(
100         address indexed from,
101         address indexed to,
102         uint256 tokens
103     );
104 
105     /*=====================================
106     =            CONFIGURABLES            =
107     =====================================*/
108     string public name = "Black Pearl ETH";
109     string public symbol = "MEDA";
110     uint8 constant public decimals = 18;
111     uint8 constant internal entryFee_ = 20; // 20% Entry fee
112     uint8 constant internal refferalFee_ = 15; // 15% Referral
113     uint8 constant internal exitFee_ = 10; // 10% exit fee
114     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
115     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
116     uint256 constant internal magnitude = 2**64;
117 
118     // 250 Medaillions required for activation masternode
119     uint256 public stakingRequirement = 250e18;
120 
121     // ambassador program
122     mapping(address => bool) internal ambassadors_;
123     uint256 constant internal ambassadorMaxPurchase_ = 50 ether;
124     uint256 constant internal ambassadorQuota_ = 300 ether;
125 
126     // referral program
127     mapping(address => uint256) internal referrals;
128     mapping(address => bool) internal isUser;
129     address[] public usersAddresses;
130 
131    /*================================
132     =            DATASETS            =
133     ================================*/
134     // amount of shares for each address (scaled number)
135     mapping(address => uint256) internal tokenBalanceLedger_;
136     mapping(address => uint256) internal referralBalance_;
137     mapping(address => int256) internal payoutsTo_;
138     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
139     uint256 internal tokenSupply_ = 0;
140     uint256 internal profitPerShare_;
141 
142     // administrator list (see above on what they can do)
143     mapping(address => bool) public administrators;
144 
145     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
146     bool public onlyAmbassadors = true;
147 
148     /*=======================================
149     =            PUBLIC FUNCTIONS            =
150     =======================================*/
151     /*
152     * -- APPLICATION ENTRY POINTS --
153     */
154     function BlackPearlETH()
155         public
156     {
157 
158   		// N.O.T
159 		ambassadors_[0x9d71d8743f41987597e2ae3663cca36ca71024f4] = true;
160 		// T.T.U
161 		ambassadors_[0xC6D4a4A0bf0507749D4a23C9550A826207b5D94b] = true;
162 		// C.A
163 		ambassadors_[0x008ca4f1ba79d1a265617c6206d7884ee8108a78] = true;
164 	    // R.A
165 		ambassadors_[0x41a21b264F9ebF6cF571D4543a5b3AB1c6bEd98C] = true;
166 	    // J.K
167 		ambassadors_[0xc7F15d0238d207e19cce6bd6C0B85f343896F046] = true;
168 	    // C.G
169 		ambassadors_[0xee54d208f62368b4effe176cb548a317dcae963f] = true;
170 	    // P.X
171 		ambassadors_[0x074f21a36217d7615d0202faa926aefebb5a9999] = true;
172 	    // S.Z
173 		ambassadors_[0x8c8F39b851ABF4455CFE5832a09B5E5ccEBD320f] = true;
174 
175 
176 
177 		// Deployer
178 		administrators[msg.sender] = true;
179 		ambassadors_[msg.sender] = true;
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
205     /* Converts all of caller's dividends to tokens. */
206     function reinvest() onlyStronghands() public {
207         // fetch dividends
208         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
209 
210         // pay out the dividends virtually
211         address _customerAddress = msg.sender;
212         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
213 
214         // retrieve ref. bonus
215         _dividends += referralBalance_[_customerAddress];
216         referralBalance_[_customerAddress] = 0;
217 
218         // dispatch a buy order with the virtualized "withdrawn dividends"
219         uint256 _tokens = purchaseTokens(_dividends, 0x0);
220 
221         // fire event
222         onReinvestment(_customerAddress, _dividends, _tokens);
223     }
224 
225     /* Alias of sell() and withdraw(). */
226     function exit() public {
227         // get token count for caller & sell them all
228         address _customerAddress = msg.sender;
229         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
230         if(_tokens > 0) sell(_tokens);
231 
232         // lambo delivery service
233         withdraw();
234     }
235 
236     /* Withdraws all of the callers earnings. */
237     function withdraw() onlyStronghands() public {
238         // setup data
239         address _customerAddress = msg.sender;
240         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
241 
242         // update dividend tracker
243         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
244 
245         // add ref. bonus
246         _dividends += referralBalance_[_customerAddress];
247         referralBalance_[_customerAddress] = 0;
248 
249         // lambo delivery service
250         _customerAddress.transfer(_dividends);
251 
252         // fire event
253         onWithdraw(_customerAddress, _dividends);
254     }
255 
256     /* Liquifies tokens to ethereum. */
257     function sell(uint256 _amountOfTokens) onlyBagholders() public {
258         // setup data
259         address _customerAddress = msg.sender;
260         // russian hackers BTFO
261         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
262         uint256 _tokens = _amountOfTokens;
263         uint256 _ethereum = tokensToEthereum_(_tokens);
264         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
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
286     /* Transfer tokens from the caller to a new holder. * No fee! */
287     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders() public returns(bool) {
288         // setup
289         address _customerAddress = msg.sender;
290 
291         // make sure we have the requested tokens
292         // also disables transfers until ambassador phase is over
293         // ( we dont want whale premines )
294         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
295 
296         // withdraw all outstanding dividends first
297         if(myDividends(true) > 0) withdraw();
298 
299         // exchange tokens
300         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
301         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
302 
303         // update dividend trackers
304         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
305         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
306 
307         // fire event
308         Transfer(_customerAddress, _toAddress, _amountOfTokens);
309 
310         // ERC20
311         return true;
312 
313     }
314 
315     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
316     /**
317      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
318      */
319     function disableInitialStage()
320         onlyAdministrator()
321         public
322     {
323         onlyAmbassadors = false;
324     }
325 
326     /**
327      * In case one of us dies, we need to replace ourselves.
328      */
329     function setAdministrator(address _identifier, bool _status)
330         onlyAdministrator()
331         public
332     {
333         administrators[_identifier] = _status;
334     }
335 
336     /**
337      * Precautionary measures in case we need to adjust the masternode rate.
338      */
339     function setStakingRequirement(uint256 _amountOfTokens)
340         onlyAdministrator()
341         public
342     {
343         stakingRequirement = _amountOfTokens;
344     }
345 
346     /**
347      * If we want to rebrand, we can.
348      */
349     function setName(string _name)
350         onlyAdministrator()
351         public
352     {
353         name = _name;
354     }
355 
356     /**
357      * If we want to rebrand, we can.
358      */
359     function setSymbol(string _symbol)
360         onlyAdministrator()
361         public
362     {
363         symbol = _symbol;
364     }
365 
366 
367     /*----------  HELPERS AND CALCULATORS  ----------*/
368     /**
369      * Method to view the current Ethereum stored in the contract
370      * Example: totalEthereumBalance()
371      */
372     function totalEthereumBalance()
373         public
374         view
375         returns(uint)
376     {
377         return this.balance;
378     }
379 
380     /**
381      * Retrieve the total token supply.
382      */
383     function totalSupply()
384         public
385         view
386         returns(uint256)
387     {
388         return tokenSupply_;
389     }
390 
391     /**
392      * Retrieve the tokens owned by the caller.
393      */
394     function myTokens()
395         public
396         view
397         returns(uint256)
398     {
399         address _customerAddress = msg.sender;
400         return balanceOf(_customerAddress);
401     }
402 
403     function referralsOf(address _customerAddress)
404         public
405         view
406         returns(uint256)
407     {
408         return referrals[_customerAddress];
409     }
410 
411     function totalUsers()
412         public
413         view
414         returns(uint256)
415     {
416         return usersAddresses.length;
417     }
418 
419     /**
420      * Retrieve the dividends owned by the caller.
421      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
422      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
423      * But in the internal calculations, we want them separate.
424      */
425     function myDividends(bool _includeReferralBonus)
426         public
427         view
428         returns(uint256)
429     {
430         address _customerAddress = msg.sender;
431         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
432     }
433 
434     /**
435      * Retrieve the token balance of any single address.
436      */
437     function balanceOf(address _customerAddress)
438         view
439         public
440         returns(uint256)
441     {
442         return tokenBalanceLedger_[_customerAddress];
443     }
444 
445     /**
446      * Retrieve the dividend balance of any single address.
447      */
448     function dividendsOf(address _customerAddress)
449         view
450         public
451         returns(uint256)
452     {
453         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
454     }
455 
456     /**
457      * Return the buy price of 1 individual token.
458      */
459     function sellPrice()
460         public
461         view
462         returns(uint256)
463     {
464         // our calculation relies on the token supply, so we need supply. Doh.
465         if(tokenSupply_ == 0){
466             return tokenPriceInitial_ - tokenPriceIncremental_;
467         } else {
468             uint256 _ethereum = tokensToEthereum_(1e18);
469             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
470             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
471             return _taxedEthereum;
472         }
473     }
474 
475     /**
476      * Return the sell price of 1 individual token.
477      */
478     function buyPrice()
479         public
480         view
481         returns(uint256)
482     {
483         // our calculation relies on the token supply, so we need supply. Doh.
484         if(tokenSupply_ == 0){
485             return tokenPriceInitial_ + tokenPriceIncremental_;
486         } else {
487             uint256 _ethereum = tokensToEthereum_(1e18);
488             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
489             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
490             return _taxedEthereum;
491         }
492     }
493 
494     /**
495      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
496      */
497     function calculateTokensReceived(uint256 _ethereumToSpend)
498         public
499         view
500         returns(uint256)
501     {
502         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
503         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
504         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
505 
506         return _amountOfTokens;
507     }
508 
509     /**
510      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
511      */
512     function calculateEthereumReceived(uint256 _tokensToSell)
513         public
514         view
515         returns(uint256)
516     {
517         require(_tokensToSell <= tokenSupply_);
518         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
519         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
520         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
521         return _taxedEthereum;
522     }
523 
524 
525     /*==========================================
526     =            INTERNAL FUNCTIONS            =
527     ==========================================*/
528     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
529         antiEarlyWhale(_incomingEthereum)
530         internal
531         returns(uint256)
532     {
533         // data setup
534         address _customerAddress = msg.sender;
535         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
536         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
537         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
538         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
539         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
540         uint256 _fee = _dividends * magnitude;
541 
542         // no point in continuing execution if OP is a poorfag russian hacker
543         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
544         // (or hackers)
545         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
546         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
547 
548         // is the user referred by a masternode?
549         if(
550             // is this a referred purchase?
551             _referredBy != 0x0000000000000000000000000000000000000000 &&
552 
553             // no cheating!
554             _referredBy != _customerAddress &&
555 
556             // does the referrer have at least X whole tokens?
557             // i.e is the referrer a Kekly chad masternode
558             tokenBalanceLedger_[_referredBy] >= stakingRequirement
559         ){
560             // wealth redistribution
561             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
562 
563             if (isUser[_customerAddress] == false) {
564             	referrals[_referredBy]++;
565             }     
566 
567         } else {
568             // no ref purchase
569             // add the referral bonus back to the global dividends cake
570             _dividends = SafeMath.add(_dividends, _referralBonus);
571             _fee = _dividends * magnitude;
572         }
573 
574         if (isUser[_customerAddress] == false ) {
575         	isUser[_customerAddress] = true;
576         	usersAddresses.push(_customerAddress);
577         }
578 
579         // we can't give people infinite ethereum
580         if(tokenSupply_ > 0){
581 
582             // add tokens to the pool
583             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
584 
585             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
586             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
587 
588             // calculate the amount of tokens the customer receives over his purchase
589             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
590 
591         } else {
592             // add tokens to the pool
593             tokenSupply_ = _amountOfTokens;
594         }
595 
596         // update circulating supply & the ledger address for the customer
597         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
598 
599         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
600         //really i know you think you do but you don't
601         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
602         payoutsTo_[_customerAddress] += _updatedPayouts;
603 
604         // fire event
605         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
606 
607         return _amountOfTokens;
608     }
609 
610     /**
611      * Calculate Token price based on an amount of incoming ethereum
612      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
613      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
614      */
615     function ethereumToTokens_(uint256 _ethereum)
616         internal
617         view
618         returns(uint256)
619     {
620         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
621         uint256 _tokensReceived =
622          (
623             (
624                 // underflow attempts BTFO
625                 SafeMath.sub(
626                     (sqrt
627                         (
628                             (_tokenPriceInitial**2)
629                             +
630                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
631                             +
632                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
633                             +
634                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
635                         )
636                     ), _tokenPriceInitial
637                 )
638             )/(tokenPriceIncremental_)
639         )-(tokenSupply_)
640         ;
641 
642         return _tokensReceived;
643     }
644 
645     /**
646      * Calculate token sell value.
647      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
648      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
649      */
650      function tokensToEthereum_(uint256 _tokens)
651         internal
652         view
653         returns(uint256)
654     {
655 
656         uint256 tokens_ = (_tokens + 1e18);
657         uint256 _tokenSupply = (tokenSupply_ + 1e18);
658         uint256 _etherReceived =
659         (
660             // underflow attempts BTFO
661             SafeMath.sub(
662                 (
663                     (
664                         (
665                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
666                         )-tokenPriceIncremental_
667                     )*(tokens_ - 1e18)
668                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
669             )
670         /1e18);
671         return _etherReceived;
672     }
673 
674 
675     //This is where all your gas goes, sorry
676     //Not sorry, you probably only paid 1 gwei
677     function sqrt(uint x) internal pure returns (uint y) {
678         uint z = (x + 1) / 2;
679         y = x;
680         while (z < y) {
681             y = z;
682             z = (x / z + z) / 2;
683         }
684     }
685 }
686 
687 /**
688  * @title SafeMath
689  * @dev Math operations with safety checks that throw on error
690  */
691 library SafeMath {
692 
693     /**
694     * @dev Multiplies two numbers, throws on overflow.
695     */
696     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
697         if (a == 0) {
698             return 0;
699         }
700         uint256 c = a * b;
701         assert(c / a == b);
702         return c;
703     }
704 
705     /**
706     * @dev Integer division of two numbers, truncating the quotient.
707     */
708     function div(uint256 a, uint256 b) internal pure returns (uint256) {
709         // assert(b > 0); // Solidity automatically throws when dividing by 0
710         uint256 c = a / b;
711         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
712         return c;
713     }
714 
715     /**
716     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
717     */
718     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
719         assert(b <= a);
720         return a - b;
721     }
722 
723     /**
724     * @dev Adds two numbers, throws on overflow.
725     */
726     function add(uint256 a, uint256 b) internal pure returns (uint256) {
727         uint256 c = a + b;
728         assert(c >= a);
729         return c;
730     }
731 }