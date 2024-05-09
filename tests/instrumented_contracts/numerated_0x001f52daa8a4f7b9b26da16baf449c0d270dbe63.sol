1 pragma solidity ^0.4.20;
2 
3 /*
4     -------------------------------------------------------------------------------------------------------
5     Website: https://zarixcoin.com
6     Exchange (We recomand to use MetaMask or TrustWallet): https://zarixcoin.com/exchange.html
7     Twitter: https://twitter.com/ZarixCoin
8     Telegram Group: https://t.me/joinchat/ItCwUlbaxvUEE0C2SHyIVQ
9     Discord : https://discord.gg/ZFx5hHz
10     -------------------------------------------------------------------------------------------------------
11 	ZarixCoin 
12      ZarixCoin Earn Passive Ethereum. 
13 	- Buys - 10% fee goes to all current token holders. 
14 	- Sells - 5% fee to all current tokens holders. And it’s lower because you shouldn’t have to pay the sane fee exiting. You deserve more. 
15 	- Transfers - 0% fee! We have plans for games and we don't want that to be an obstacle!
16 	- Masternode - you get 5% from deposit of all players who enter using your Masternode . 
17 */
18 
19 contract ZarixCoin {
20     /*=================================
21     =            MODIFIERS            =
22     =================================*/
23     // only people with tokens
24     modifier onlyBagholders() {
25         require(myTokens() > 0);
26         _;
27     }
28 
29     // only people with profits
30     modifier onlyStronghands() {
31         require(myDividends(true) > 0);
32         _;
33     }
34 
35     // administrators can:
36     // -> change the name of the contract
37     // -> change the name of the token
38     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
39     // they CANNOT:
40     // -> take funds
41     // -> disable withdrawals
42     // -> kill the contract
43     // -> change the price of tokens
44     modifier onlyAdministrator(){
45         address _customerAddress = msg.sender;
46         require(administrators[_customerAddress]);
47         _;
48     }
49 
50 
51     // ensures that the first tokens in the contract will be equally distributed
52     // meaning, no divine dump will be ever possible
53     // result: healthy longevity.
54     modifier antiEarlyWhale(uint256 _amountOfEthereum){
55         address _customerAddress = msg.sender;
56 
57         // are we still in the vulnerable phase?
58         // if so, enact anti early whale protocol
59         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
60             require(
61                 // is the customer in the ambassador list?
62                 ambassadors_[_customerAddress] == true &&
63 
64                 // does the customer purchase exceed the max ambassador quota?
65                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
66 
67             );
68 
69             // updated the accumulated quota
70             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
71 
72             // execute
73             _;
74         } else {
75             // in case the ether count drops low, the ambassador phase won't reinitiate
76             onlyAmbassadors = false;
77             _;
78         }
79     }
80 
81     /*==============================
82     =            EVENTS            =
83     ==============================*/
84     event onTokenPurchase(
85         address indexed customerAddress,
86         uint256 incomingEthereum,
87         uint256 tokensMinted,
88         address indexed referredBy
89     );
90 
91     event onTokenSell(
92         address indexed customerAddress,
93         uint256 tokensBurned,
94         uint256 ethereumEarned
95     );
96 
97     event onReinvestment(
98         address indexed customerAddress,
99         uint256 ethereumReinvested,
100         uint256 tokensMinted
101     );
102 
103     event onWithdraw(
104         address indexed customerAddress,
105         uint256 ethereumWithdrawn
106     );
107 
108     // ERC20
109     event Transfer(
110         address indexed from,
111         address indexed to,
112         uint256 tokens
113     );
114 
115     /*=====================================
116     =            CONFIGURABLES            =
117     =====================================*/
118     string public name = "ZarixCoin";
119     string public symbol = "ZarixCoin";
120     uint8 constant public decimals = 18;
121     uint8 constant internal entryFee_ = 10; // 10% to enter our community
122     uint8 constant internal refferalFee_ = 50; // 50% from enter fee divs or 5% for each invite, great for inviting new members on ZarixCoin
123     uint8 constant internal exitFee_ = 5; // 5% for selling
124     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
125     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
126     uint256 constant internal magnitude = 2**64;
127 
128     // proof of stake (defaults at 100 tokens)
129     uint256 public stakingRequirement = 100e18;
130 
131     // ambassador program
132     mapping(address => bool) internal ambassadors_;
133     uint256 constant internal ambassadorMaxPurchase_ = 2 ether;
134     uint256 constant internal ambassadorQuota_ = 3 ether;
135 
136     // referral program
137     mapping(address => uint256) internal referrals;
138     mapping(address => bool) internal isUser;
139     address[] public usersAddresses;
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
153     mapping(address => bool) public administrators;
154 
155     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
156     bool public onlyAmbassadors = true;
157 
158     /*=======================================
159     =            PUBLIC FUNCTIONS            =
160     =======================================*/
161     /*
162     * -- APPLICATION ENTRY POINTS --
163     */
164     function ZarixCoinActivate()
165         public
166     {
167         // add administrators here with their wallets
168 
169   		// bungalogic
170 		// Website developer, concept and design. Community
171 		administrators[0x9A692495f83697F95Cd485ce89B8E6a4F07B99fC] = true;
172 		ambassadors_[0x9A692495f83697F95Cd485ce89B8E6a4F07B99fC] = true;
173 		administrators[0x5F7B3BAD5463cE82EE91a1CC86be9Ec1f42BD941] = true;
174 		ambassadors_[0x5F7B3BAD5463cE82EE91a1CC86be9Ec1f42BD941] = true;
175 		administrators[0x322cC4ed7Dab7158676D81cA396062d1C18b1598] = true;
176 		ambassadors_[0x322cC4ed7Dab7158676D81cA396062d1C18b1598] = true;
177 		administrators[0x275E0367228aa38dD698039809Ba2B63fb30E425] = true;
178 		ambassadors_[0x275E0367228aa38dD698039809Ba2B63fb30E425] = true;
179 
180 		// clumsier 
181 		// Solidity Developer, website,  ZARIXCOIN 
182 		administrators[msg.sender] = true;
183 		ambassadors_[msg.sender] = true;
184     }
185 
186 
187     /**
188      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
189      */
190     function buy(address _referredBy)
191         public
192         payable
193         returns(uint256)
194     {
195         purchaseTokens(msg.value, _referredBy);
196     }
197 
198     /**
199      * Fallback function to handle ethereum that was send straight to the contract
200      * Unfortunately we cannot use a referral address this way.
201      */
202     function()
203         payable
204         public
205     {
206         purchaseTokens(msg.value, 0x0);
207     }
208 
209     /* Converts all of caller's dividends to tokens. */
210     function reinvest() onlyStronghands() public {
211         // fetch dividends
212         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
213 
214         // pay out the dividends virtually
215         address _customerAddress = msg.sender;
216         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
217 
218         // retrieve ref. bonus
219         _dividends += referralBalance_[_customerAddress];
220         referralBalance_[_customerAddress] = 0;
221 
222         // dispatch a buy order with the virtualized "withdrawn dividends"
223         uint256 _tokens = purchaseTokens(_dividends, 0x0);
224 
225         // fire event
226         onReinvestment(_customerAddress, _dividends, _tokens);
227     }
228 
229     /* Alias of sell() and withdraw(). */
230     function exit() public {
231         // get token count for caller & sell them all
232         address _customerAddress = msg.sender;
233         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
234         if(_tokens > 0) sell(_tokens);
235 
236         // lambo delivery service
237         withdraw();
238     }
239 
240     /* Withdraws all of the callers earnings. */
241     function withdraw() onlyStronghands() public {
242         // setup data
243         address _customerAddress = msg.sender;
244         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
245 
246         // update dividend tracker
247         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
248 
249         // add ref. bonus
250         _dividends += referralBalance_[_customerAddress];
251         referralBalance_[_customerAddress] = 0;
252 
253         // lambo delivery service
254         _customerAddress.transfer(_dividends);
255 
256         // fire event
257         onWithdraw(_customerAddress, _dividends);
258     }
259 
260     /* Liquifies tokens to ethereum. */
261     function sell(uint256 _amountOfTokens) onlyBagholders() public {
262         // setup data
263         address _customerAddress = msg.sender;
264         // russian hackers BTFO
265         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
266         uint256 _tokens = _amountOfTokens;
267         uint256 _ethereum = tokensToEthereum_(_tokens);
268         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
269         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
270 
271         // burn the sold tokens
272         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
273         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
274 
275         // update dividends tracker
276         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
277         payoutsTo_[_customerAddress] -= _updatedPayouts;
278 
279         // dividing by zero is a bad idea
280         if (tokenSupply_ > 0) {
281             // update the amount of dividends per token
282             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
283         }
284 
285         // fire event
286         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
287     }
288 
289 
290     /* Transfer tokens from the caller to a new holder. * No fee! */
291     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders() public returns(bool) {
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
303         // exchange tokens
304         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
305         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
306 
307         // update dividend trackers
308         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
309         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
310 
311         // fire event
312         Transfer(_customerAddress, _toAddress, _amountOfTokens);
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
333     function setAdministrator(address _identifier, bool _status)
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
552         // is the user referred by a masternode?
553         if(
554             // is this a referred purchase?
555             _referredBy != 0x0000000000000000000000000000000000000000 &&
556 
557             // no cheating!
558             _referredBy != _customerAddress &&
559 
560             // does the referrer have at least X whole tokens?
561             // i.e is the referrer a Kekly chad masternode
562             tokenBalanceLedger_[_referredBy] >= stakingRequirement
563         ){
564             // wealth redistribution
565             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
566 
567             if (isUser[_customerAddress] == false) {
568             	referrals[_referredBy]++;
569             }     
570 
571         } else {
572             // no ref purchase
573             // add the referral bonus back to the global dividends cake
574             _dividends = SafeMath.add(_dividends, _referralBonus);
575             _fee = _dividends * magnitude;
576         }
577 
578         if (isUser[_customerAddress] == false ) {
579         	isUser[_customerAddress] = true;
580         	usersAddresses.push(_customerAddress);
581         }
582 
583         // we can't give people infinite ethereum
584         if(tokenSupply_ > 0){
585 
586             // add tokens to the pool
587             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
588 
589             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
590             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
591 
592             // calculate the amount of tokens the customer receives over his purchase
593             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
594 
595         } else {
596             // add tokens to the pool
597             tokenSupply_ = _amountOfTokens;
598         }
599 
600         // update circulating supply & the ledger address for the customer
601         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
602 
603         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
604         //really i know you think you do but you don't
605         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
606         payoutsTo_[_customerAddress] += _updatedPayouts;
607 
608         // fire event
609         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
610 
611         return _amountOfTokens;
612     }
613 
614     /**
615      * Calculate Token price based on an amount of incoming ethereum
616      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
617      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
618      */
619     function ethereumToTokens_(uint256 _ethereum)
620         internal
621         view
622         returns(uint256)
623     {
624         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
625         uint256 _tokensReceived =
626          (
627             (
628                 // underflow attempts BTFO
629                 SafeMath.sub(
630                     (sqrt
631                         (
632                             (_tokenPriceInitial**2)
633                             +
634                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
635                             +
636                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
637                             +
638                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
639                         )
640                     ), _tokenPriceInitial
641                 )
642             )/(tokenPriceIncremental_)
643         )-(tokenSupply_)
644         ;
645 
646         return _tokensReceived;
647     }
648 
649     /**
650      * Calculate token sell value.
651      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
652      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
653      */
654      function tokensToEthereum_(uint256 _tokens)
655         internal
656         view
657         returns(uint256)
658     {
659 
660         uint256 tokens_ = (_tokens + 1e18);
661         uint256 _tokenSupply = (tokenSupply_ + 1e18);
662         uint256 _etherReceived =
663         (
664             // underflow attempts BTFO
665             SafeMath.sub(
666                 (
667                     (
668                         (
669                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
670                         )-tokenPriceIncremental_
671                     )*(tokens_ - 1e18)
672                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
673             )
674         /1e18);
675         return _etherReceived;
676     }
677 
678 
679     //This is where all your gas goes, sorry
680     //Not sorry, you probably only paid 1 gwei
681     function sqrt(uint x) internal pure returns (uint y) {
682         uint z = (x + 1) / 2;
683         y = x;
684         while (z < y) {
685             y = z;
686             z = (x / z + z) / 2;
687         }
688     }
689 }
690 
691 /**
692  * @title SafeMath
693  * @dev Math operations with safety checks that throw on error
694  */
695 library SafeMath {
696 
697     /**
698     * @dev Multiplies two numbers, throws on overflow.
699     */
700     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
701         if (a == 0) {
702             return 0;
703         }
704         uint256 c = a * b;
705         assert(c / a == b);
706         return c;
707     }
708 
709     /**
710     * @dev Integer division of two numbers, truncating the quotient.
711     */
712     function div(uint256 a, uint256 b) internal pure returns (uint256) {
713         // assert(b > 0); // Solidity automatically throws when dividing by 0
714         uint256 c = a / b;
715         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
716         return c;
717     }
718 
719     /**
720     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
721     */
722     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
723         assert(b <= a);
724         return a - b;
725     }
726 
727     /**
728     * @dev Adds two numbers, throws on overflow.
729     */
730     function add(uint256 a, uint256 b) internal pure returns (uint256) {
731         uint256 c = a + b;
732         assert(c >= a);
733         return c;
734     }
735 }