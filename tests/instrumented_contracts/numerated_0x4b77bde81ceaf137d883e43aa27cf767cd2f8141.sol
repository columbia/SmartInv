1 pragma solidity ^0.4.20;
2 
3 /*
4 * Team Top Kek presents..
5 * ====================================*
6 *  KEK, KEK, KEK, KEK, KEK, KEK, KEK ( 7 KEKS )    
7 * ====================================*
8 *
9 * PROOF OF Kek
10 * -> What?
11 *  The last Ethereum pyramide which earns you ETH!!!
12 * [x] Kek Dividends: 15% of every buy and 15% sell will be rewarded to token holders. Don't sell, don't be week.
13 * [x] Kek Masternodes: Holding 50 POW Tokens allow you to generate a Masternode link, Masternode links are used as unique entry points to the contract!
14 * [x] Kek Masternodes: All players who enter the contract through your Masternode have 35% of their 20% dividends fee rerouted from the master-node, to the node-master!
15 *
16 * The entire cryptocurrency community suffers from one ailment, the ailment of disloyalty. It's the problem that is eating away at our very survival.
17 * This coin solves that problem. If you don't have Kek in yourself, this coin is not for you. If you can belive in divinity crank up the miners and get to work!
18 */
19 
20 contract StrongKek {
21     /*=================================
22     =            MODIFIERS            =
23     =================================*/
24     // only people with tokens
25     modifier onlyBagholders() {
26         require(myTokens() > 0);
27         _;
28     }
29 
30     // only people with profits
31     modifier onlyStronghands() {
32         require(myDividends(true) > 0);
33         _;
34     }
35 
36     // administrators can:
37     // -> change the name of the contract
38     // -> change the name of the token
39     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
40     // they CANNOT:
41     // -> take funds
42     // -> disable withdrawals
43     // -> kill the contract
44     // -> change the price of tokens
45     modifier onlyAdministrator(){
46         address _customerAddress = msg.sender;
47         require(administrators[keccak256(_customerAddress)]);
48         _;
49     }
50 
51 
52     // ensures that the first tokens in the contract will be equally distributed
53     // meaning, no divine dump will be ever possible
54     // result: healthy longevity.
55     modifier antiEarlyWhale(uint256 _amountOfEthereum){
56         address _customerAddress = msg.sender;
57 
58         // are we still in the vulnerable phase?
59         // if so, enact anti early whale protocol
60         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
61             require(
62                 // is the customer in the ambassador list?
63                 ambassadors_[_customerAddress] == true &&
64 
65                 // does the customer purchase exceed the max ambassador quota?
66                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
67 
68             );
69 
70             // updated the accumulated quota
71             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
72 
73             // execute
74             _;
75         } else {
76             // in case the ether count drops low, the ambassador phase won't reinitiate
77             onlyAmbassadors = false;
78             _;
79         }
80     }
81 
82     /*==============================
83     =            EVENTS            =
84     ==============================*/
85     event onTokenPurchase(
86         address indexed customerAddress,
87         uint256 incomingEthereum,
88         uint256 tokensMinted,
89         address indexed referredBy
90     );
91 
92     event onTokenSell(
93         address indexed customerAddress,
94         uint256 tokensBurned,
95         uint256 ethereumEarned
96     );
97 
98     event onReinvestment(
99         address indexed customerAddress,
100         uint256 ethereumReinvested,
101         uint256 tokensMinted
102     );
103 
104     event onWithdraw(
105         address indexed customerAddress,
106         uint256 ethereumWithdrawn
107     );
108 
109     // ERC20
110     event Transfer(
111         address indexed from,
112         address indexed to,
113         uint256 tokens
114     );
115 
116     /*=====================================
117     =            CONFIGURABLES            =
118     =====================================*/
119     string public name = "ProphecyOfKek";
120     string public symbol = "POK";
121     uint8 constant public decimals = 18;
122     uint8 constant internal entryFee_ = 15; // 15% to enter the Kek contest
123     uint8 constant internal transferFee_ = 10; // 10% transfer fee
124     uint8 constant internal refferalFee_ = 47; // 47% from enter fee divs or 7% for each invite, great for inviting strong new Keks
125     uint8 constant internal exitFee_ = 15; // 15% for selling, weak keks out
126     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
127     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
128     uint256 constant internal magnitude = 2**64;
129 
130     // proof of stake (defaults at 50 tokens)
131     uint256 public stakingRequirement = 50e18;
132 
133     // ambassador program
134     mapping(address => bool) internal ambassadors_;
135     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
136     uint256 constant internal ambassadorQuota_ = 20 ether;
137 
138     // referral program
139     mapping(address => uint256) internal referrals;
140     mapping(address => bool) internal isUser;
141     address[] public usersAddresses;
142 
143    /*================================
144     =            DATASETS            =
145     ================================*/
146     // amount of shares for each address (scaled number)
147     mapping(address => uint256) internal tokenBalanceLedger_;
148     mapping(address => uint256) internal referralBalance_;
149     mapping(address => int256) internal payoutsTo_;
150     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
151     uint256 internal tokenSupply_ = 0;
152     uint256 internal profitPerShare_;
153 
154     // administrator list (see above on what they can do)
155     mapping(bytes32 => bool) public administrators;
156 
157     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
158     bool public onlyAmbassadors = false;
159 
160 
161     /*=======================================
162     =            PUBLIC FUNCTIONS            =
163     =======================================*/
164     /*
165     * -- APPLICATION ENTRY POINTS --
166     */
167     function StrongKek()
168         public
169     {
170         // add administrators here
171         administrators[0x72672f5a5f1f0d1bd51d75da8a61b3bcbf6efdd40888e7adb59869bd46b7490e] = false;
172     }
173 
174 
175     /**
176      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
177      */
178     function buy(address _referredBy)
179         public
180         payable
181         returns(uint256)
182     {
183         purchaseTokens(msg.value, _referredBy);
184     }
185 
186     /**
187      * Fallback function to handle ethereum that was send straight to the contract
188      * Unfortunately we cannot use a referral address this way.
189      */
190     function()
191         payable
192         public
193     {
194         purchaseTokens(msg.value, 0x0);
195     }
196 
197     /* Converts all of caller's dividends to tokens. */
198     function reinvest() onlyStronghands() public {
199         // fetch dividends
200         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
201 
202         // pay out the dividends virtually
203         address _customerAddress = msg.sender;
204         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
205 
206         // retrieve ref. bonus
207         _dividends += referralBalance_[_customerAddress];
208         referralBalance_[_customerAddress] = 0;
209 
210         // dispatch a buy order with the virtualized "withdrawn dividends"
211         uint256 _tokens = purchaseTokens(_dividends, 0x0);
212 
213         // fire event
214         onReinvestment(_customerAddress, _dividends, _tokens);
215     }
216 
217     /* Alias of sell() and withdraw(). */
218     function exit() public {
219         // get token count for caller & sell them all
220         address _customerAddress = msg.sender;
221         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
222         if(_tokens > 0) sell(_tokens);
223 
224         // lambo delivery service
225         withdraw();
226     }
227 
228     /* Withdraws all of the callers earnings. */
229     function withdraw() onlyStronghands() public {
230         // setup data
231         address _customerAddress = msg.sender;
232         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
233 
234         // update dividend tracker
235         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
236 
237         // add ref. bonus
238         _dividends += referralBalance_[_customerAddress];
239         referralBalance_[_customerAddress] = 0;
240 
241         // lambo delivery service
242         _customerAddress.transfer(_dividends);
243 
244         // fire event
245         onWithdraw(_customerAddress, _dividends);
246     }
247 
248     /* Liquifies tokens to ethereum. */
249     function sell(uint256 _amountOfTokens) onlyBagholders() public {
250         // setup data
251         address _customerAddress = msg.sender;
252         // russian hackers BTFO
253         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
254         uint256 _tokens = _amountOfTokens;
255         uint256 _ethereum = tokensToEthereum_(_tokens);
256         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
257         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
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
278     /* Transfer tokens from the caller to a new holder. * Remember, there's a 10% fee here as well. */
279     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders() public returns(bool) {
280         // setup
281         address _customerAddress = msg.sender;
282 
283         // make sure we have the requested tokens
284         // also disables transfers until ambassador phase is over
285         // ( we dont want whale premines )
286         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
287 
288         // withdraw all outstanding dividends first
289         if(myDividends(true) > 0) withdraw();
290 
291         // liquify 10% of the tokens that are transfered
292         // these are dispersed to shareholders
293         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
294         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
295         uint256 _dividends = tokensToEthereum_(_tokenFee);
296 
297         // burn the fee tokens
298         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
299 
300         // exchange tokens
301         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
302         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
303 
304         // update dividend trackers
305         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
306         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
307 
308         // disperse dividends among holders
309         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
310 
311         // fire event
312         Transfer(_customerAddress, _toAddress, _taxedTokens);
313 
314         // ERC20
315         return true;
316 
317     }
318 
319     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
320     /**
321      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
322      */
323     function disableInitialStage()
324         onlyAdministrator()
325         public
326     {
327         onlyAmbassadors = false;
328     }
329 
330     /**
331      * In case one of us dies, we need to replace ourselves.
332      */
333     function setAdministrator(bytes32 _identifier, bool _status)
334         onlyAdministrator()
335         public
336     {
337         administrators[_identifier] = _status;
338     }
339 
340     /**
341      * Precautionary measures in case we need to adjust the masternode rate.
342      */
343     function setStakingRequirement(uint256 _amountOfTokens)
344         onlyAdministrator()
345         public
346     {
347         stakingRequirement = _amountOfTokens;
348     }
349 
350     /**
351      * If we want to rebrand, we can.
352      */
353     function setName(string _name)
354         onlyAdministrator()
355         public
356     {
357         name = _name;
358     }
359 
360     /**
361      * If we want to rebrand, we can.
362      */
363     function setSymbol(string _symbol)
364         onlyAdministrator()
365         public
366     {
367         symbol = _symbol;
368     }
369 
370 
371     /*----------  HELPERS AND CALCULATORS  ----------*/
372     /**
373      * Method to view the current Ethereum stored in the contract
374      * Example: totalEthereumBalance()
375      */
376     function totalEthereumBalance()
377         public
378         view
379         returns(uint)
380     {
381         return this.balance;
382     }
383 
384     /**
385      * Retrieve the total token supply.
386      */
387     function totalSupply()
388         public
389         view
390         returns(uint256)
391     {
392         return tokenSupply_;
393     }
394 
395     /**
396      * Retrieve the tokens owned by the caller.
397      */
398     function myTokens()
399         public
400         view
401         returns(uint256)
402     {
403         address _customerAddress = msg.sender;
404         return balanceOf(_customerAddress);
405     }
406 
407     function referralsOf(address _customerAddress)
408         public
409         view
410         returns(uint256)
411     {
412         return referrals[_customerAddress];
413     }
414 
415     function totalUsers()
416         public
417         view
418         returns(uint256)
419     {
420         return usersAddresses.length;
421     }
422 
423     /**
424      * Retrieve the dividends owned by the caller.
425      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
426      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
427      * But in the internal calculations, we want them separate.
428      */
429     function myDividends(bool _includeReferralBonus)
430         public
431         view
432         returns(uint256)
433     {
434         address _customerAddress = msg.sender;
435         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
436     }
437 
438     /**
439      * Retrieve the token balance of any single address.
440      */
441     function balanceOf(address _customerAddress)
442         view
443         public
444         returns(uint256)
445     {
446         return tokenBalanceLedger_[_customerAddress];
447     }
448 
449     /**
450      * Retrieve the dividend balance of any single address.
451      */
452     function dividendsOf(address _customerAddress)
453         view
454         public
455         returns(uint256)
456     {
457         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
458     }
459 
460     /**
461      * Return the buy price of 1 individual token.
462      */
463     function sellPrice()
464         public
465         view
466         returns(uint256)
467     {
468         // our calculation relies on the token supply, so we need supply. Doh.
469         if(tokenSupply_ == 0){
470             return tokenPriceInitial_ - tokenPriceIncremental_;
471         } else {
472             uint256 _ethereum = tokensToEthereum_(1e18);
473             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
474             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
475             return _taxedEthereum;
476         }
477     }
478 
479     /**
480      * Return the sell price of 1 individual token.
481      */
482     function buyPrice()
483         public
484         view
485         returns(uint256)
486     {
487         // our calculation relies on the token supply, so we need supply. Doh.
488         if(tokenSupply_ == 0){
489             return tokenPriceInitial_ + tokenPriceIncremental_;
490         } else {
491             uint256 _ethereum = tokensToEthereum_(1e18);
492             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
493             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
494             return _taxedEthereum;
495         }
496     }
497 
498     /**
499      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
500      */
501     function calculateTokensReceived(uint256 _ethereumToSpend)
502         public
503         view
504         returns(uint256)
505     {
506         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
507         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
508         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
509 
510         return _amountOfTokens;
511     }
512 
513     /**
514      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
515      */
516     function calculateEthereumReceived(uint256 _tokensToSell)
517         public
518         view
519         returns(uint256)
520     {
521         require(_tokensToSell <= tokenSupply_);
522         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
523         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
524         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
525         return _taxedEthereum;
526     }
527 
528 
529     /*==========================================
530     =            INTERNAL FUNCTIONS            =
531     ==========================================*/
532     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
533         antiEarlyWhale(_incomingEthereum)
534         internal
535         returns(uint256)
536     {
537         // data setup
538         address _customerAddress = msg.sender;
539         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
540         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
541         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
542         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
543         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
544         uint256 _fee = _dividends * magnitude;
545 
546         // no point in continuing execution if OP is a poorfag russian hacker
547         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
548         // (or hackers)
549         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
550         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
551 
552         if (isUser[_customerAddress] == false ) {
553         	isUser[_customerAddress] = true;
554         	usersAddresses.push(_customerAddress);
555         }
556 
557         // is the user referred by a masternode?
558         if(
559             // is this a referred purchase?
560             _referredBy != 0x0000000000000000000000000000000000000000 &&
561 
562             // no cheating!
563             _referredBy != _customerAddress &&
564 
565             // does the referrer have at least X whole tokens?
566             // i.e is the referrer a Kekly chad masternode
567             tokenBalanceLedger_[_referredBy] >= stakingRequirement
568         ){
569             // wealth redistribution
570             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
571             referrals[_referredBy]++;
572         } else {
573             // no ref purchase
574             // add the referral bonus back to the global dividends cake
575             _dividends = SafeMath.add(_dividends, _referralBonus);
576             _fee = _dividends * magnitude;
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