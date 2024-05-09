1 pragma solidity ^0.4.20;
2 
3 /*
4     -------------------------------------------------------------------------------------------------------
5     Website: https://arbenis.com
6     Exchange (We recomand to use MetaMask or TrustWallet): https://arbenis.com/exchange
7     Twitter: https://twitter.com/Arbeniscom
8     Telegram Group: https://t.me/joinchat/IvMthleXYLyTaIuMt5JPzQ
9     Telegram Announcement : https://t.me/Arbeniscom
10     Discord: https://discord.gg/WvqfM4s
11     GitHub: https://github.com/Arbenis/Arbenis
12     -------------------------------------------------------------------------------------------------------
13 	Arbenis 
14     Arbenis - Earn Ethereum As dividends
15     The more Arbenis you hold the more Ethereum you gets
16     *Share your unique Refferal Link and get 10% of total purchased
17 */
18 
19 contract Arbenis {
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
118     string public name = "Arbenis";
119     string public symbol = "ABS";
120     uint8 constant public decimals = 18;
121     uint8 constant internal entryFee_ = 50; // 
122     uint8 constant internal refferalFee_ = 20; // 10% for each invite, great for inviting new members on Arbenis Project
123     uint8 constant internal exitFee_ = 0; // 0 Fee for sell
124     uint256 constant internal tokenPriceInitial_ = 0.0000000001 ether;
125     uint256 constant internal tokenPriceIncremental_ = 0.0000000001 ether;
126     uint256 constant internal magnitude = 2**64;
127 
128     // proof of stake (defaults at 100 tokens)
129     uint256 public stakingRequirement = 100e18;
130 
131     // ambassador program
132     mapping(address => bool) internal ambassadors_;
133     uint256 constant internal ambassadorMaxPurchase_ = 5 ether;
134     uint256 constant internal ambassadorQuota_ = 6 ether;
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
164     function ArbenisActive()
165         public
166     {
167         // add administrators here with their wallets
168 
169   		// bungalogic
170 		// Website developer, concept and design. Community
171 		administrators[0x9ACF67684198969687ECAdF2d9351981bf6F33B2] = true;
172 		ambassadors_[0x9ACF67684198969687ECAdF2d9351981bf6F33B2] = true;
173 		administrators[0xef89bF2aB0f4cAfD96b8B09423315B4b022CE1Be] = true;
174 		ambassadors_[0xef89bF2aB0f4cAfD96b8B09423315B4b022CE1Be] = true;
175 		administrators[0x409E494dc9D602197aF25E201f8B7C3813455A1C] = true;
176 		ambassadors_[0x409E494dc9D602197aF25E201f8B7C3813455A1C] = true;
177 
178 		// clumsier 
179 		// Solidity Developer, website,  Arbenis 
180 		administrators[msg.sender] = true;
181 		ambassadors_[msg.sender] = true;
182     }
183 
184 
185     /**
186      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
187      */
188     function buy(address _referredBy)
189         public
190         payable
191         returns(uint256)
192     {
193         purchaseTokens(msg.value, _referredBy);
194     }
195 
196     /**
197      * Fallback function to handle ethereum that was send straight to the contract
198      * Unfortunately we cannot use a referral address this way.
199      */
200     function()
201         payable
202         public
203     {
204         purchaseTokens(msg.value, 0x0);
205     }
206 
207     /* Converts all of caller's dividends to tokens. */
208     function reinvest() onlyStronghands() public {
209         // fetch dividends
210         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
211 
212         // pay out the dividends virtually
213         address _customerAddress = msg.sender;
214         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
215 
216         // retrieve ref. bonus
217         _dividends += referralBalance_[_customerAddress];
218         referralBalance_[_customerAddress] = 0;
219 
220         // dispatch a buy order with the virtualized "withdrawn dividends"
221         uint256 _tokens = purchaseTokens(_dividends, 0x0);
222 
223         // fire event
224         onReinvestment(_customerAddress, _dividends, _tokens);
225     }
226 
227     /* Alias of sell() and withdraw(). */
228     function exit() public {
229         // get token count for caller & sell them all
230         address _customerAddress = msg.sender;
231         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
232         if(_tokens > 0) sell(_tokens);
233 
234         // lambo delivery service
235         withdraw();
236     }
237 
238     /* Withdraws all of the callers earnings. */
239     function withdraw() onlyStronghands() public {
240         // setup data
241         address _customerAddress = msg.sender;
242         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
243 
244         // update dividend tracker
245         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
246 
247         // add ref. bonus
248         _dividends += referralBalance_[_customerAddress];
249         referralBalance_[_customerAddress] = 0;
250 
251         // lambo delivery service
252         _customerAddress.transfer(_dividends);
253 
254         // fire event
255         onWithdraw(_customerAddress, _dividends);
256     }
257 
258     /* Liquifies tokens to ethereum. */
259     function sell(uint256 _amountOfTokens) onlyBagholders() public {
260         // setup data
261         address _customerAddress = msg.sender;
262         // russian hackers BTFO
263         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
264         uint256 _tokens = _amountOfTokens;
265         uint256 _ethereum = tokensToEthereum_(_tokens);
266         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
267         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
268 
269         // burn the sold tokens
270         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
271         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
272 
273         // update dividends tracker
274         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
275         payoutsTo_[_customerAddress] -= _updatedPayouts;
276 
277         // dividing by zero is a bad idea
278         if (tokenSupply_ > 0) {
279             // update the amount of dividends per token
280             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
281         }
282 
283         // fire event
284         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
285     }
286 
287 
288     /* Transfer tokens from the caller to a new holder. * No fee! */
289     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders() public returns(bool) {
290         // setup
291         address _customerAddress = msg.sender;
292 
293         // make sure we have the requested tokens
294         // also disables transfers until ambassador phase is over
295         // ( we dont want whale premines )
296         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
297 
298         // withdraw all outstanding dividends first
299         if(myDividends(true) > 0) withdraw();
300 
301         // exchange tokens
302         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
303         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
304 
305         // update dividend trackers
306         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
307         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
308 
309         // fire event
310         Transfer(_customerAddress, _toAddress, _amountOfTokens);
311 
312         // ERC20
313         return true;
314 
315     }
316 
317     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
318     /**
319      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
320      */
321     function disableInitialStage()
322         onlyAdministrator()
323         public
324     {
325         onlyAmbassadors = false;
326     }
327 
328     /**
329      * In case one of us dies, we need to replace ourselves.
330      */
331     function setAdministrator(address _identifier, bool _status)
332         onlyAdministrator()
333         public
334     {
335         administrators[_identifier] = _status;
336     }
337 
338     /**
339      * Precautionary measures in case we need to adjust the masternode rate.
340      */
341     function setStakingRequirement(uint256 _amountOfTokens)
342         onlyAdministrator()
343         public
344     {
345         stakingRequirement = _amountOfTokens;
346     }
347 
348     /**
349      * If we want to rebrand, we can.
350      */
351     function setName(string _name)
352         onlyAdministrator()
353         public
354     {
355         name = _name;
356     }
357 
358     /**
359      * If we want to rebrand, we can.
360      */
361     function setSymbol(string _symbol)
362         onlyAdministrator()
363         public
364     {
365         symbol = _symbol;
366     }
367 
368 
369     /*----------  HELPERS AND CALCULATORS  ----------*/
370     /**
371      * Method to view the current Ethereum stored in the contract
372      * Example: totalEthereumBalance()
373      */
374     function totalEthereumBalance()
375         public
376         view
377         returns(uint)
378     {
379         return this.balance;
380     }
381 
382     /**
383      * Retrieve the total token supply.
384      */
385     function totalSupply()
386         public
387         view
388         returns(uint256)
389     {
390         return tokenSupply_;
391     }
392 
393     /**
394      * Retrieve the tokens owned by the caller.
395      */
396     function myTokens()
397         public
398         view
399         returns(uint256)
400     {
401         address _customerAddress = msg.sender;
402         return balanceOf(_customerAddress);
403     }
404 
405     function referralsOf(address _customerAddress)
406         public
407         view
408         returns(uint256)
409     {
410         return referrals[_customerAddress];
411     }
412 
413     function totalUsers()
414         public
415         view
416         returns(uint256)
417     {
418         return usersAddresses.length;
419     }
420 
421     /**
422      * Retrieve the dividends owned by the caller.
423      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
424      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
425      * But in the internal calculations, we want them separate.
426      */
427     function myDividends(bool _includeReferralBonus)
428         public
429         view
430         returns(uint256)
431     {
432         address _customerAddress = msg.sender;
433         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
434     }
435 
436     /**
437      * Retrieve the token balance of any single address.
438      */
439     function balanceOf(address _customerAddress)
440         view
441         public
442         returns(uint256)
443     {
444         return tokenBalanceLedger_[_customerAddress];
445     }
446 
447     /**
448      * Retrieve the dividend balance of any single address.
449      */
450     function dividendsOf(address _customerAddress)
451         view
452         public
453         returns(uint256)
454     {
455         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
456     }
457 
458     /**
459      * Return the buy price of 1 individual token.
460      */
461     function sellPrice()
462         public
463         view
464         returns(uint256)
465     {
466         // our calculation relies on the token supply, so we need supply. Doh.
467         if(tokenSupply_ == 0){
468             return tokenPriceInitial_ - tokenPriceIncremental_;
469         } else {
470             uint256 _ethereum = tokensToEthereum_(1e18);
471             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
472             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
473             return _taxedEthereum;
474         }
475     }
476 
477     /**
478      * Return the sell price of 1 individual token.
479      */
480     function buyPrice()
481         public
482         view
483         returns(uint256)
484     {
485         // our calculation relies on the token supply, so we need supply. Doh.
486         if(tokenSupply_ == 0){
487             return tokenPriceInitial_ + tokenPriceIncremental_;
488         } else {
489             uint256 _ethereum = tokensToEthereum_(1e18);
490             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
491             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
492             return _taxedEthereum;
493         }
494     }
495 
496     /**
497      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
498      */
499     function calculateTokensReceived(uint256 _ethereumToSpend)
500         public
501         view
502         returns(uint256)
503     {
504         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
505         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
506         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
507 
508         return _amountOfTokens;
509     }
510 
511     /**
512      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
513      */
514     function calculateEthereumReceived(uint256 _tokensToSell)
515         public
516         view
517         returns(uint256)
518     {
519         require(_tokensToSell <= tokenSupply_);
520         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
521         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
522         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
523         return _taxedEthereum;
524     }
525 
526 
527     /*==========================================
528     =            INTERNAL FUNCTIONS            =
529     ==========================================*/
530     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
531         antiEarlyWhale(_incomingEthereum)
532         internal
533         returns(uint256)
534     {
535         // data setup
536         address _customerAddress = msg.sender;
537         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
538         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
539         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
540         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
541         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
542         uint256 _fee = _dividends * magnitude;
543 
544         // no point in continuing execution if OP is a poorfag russian hacker
545         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
546         // (or hackers)
547         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
548         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
549 
550         // is the user referred by a masternode?
551         if(
552             // is this a referred purchase?
553             _referredBy != 0x0000000000000000000000000000000000000000 &&
554 
555             // no cheating!
556             _referredBy != _customerAddress &&
557 
558             // does the referrer have at least X whole tokens?
559             // i.e is the referrer a Kekly chad masternode
560             tokenBalanceLedger_[_referredBy] >= stakingRequirement
561         ){
562             // wealth redistribution
563             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
564 
565             if (isUser[_customerAddress] == false) {
566             	referrals[_referredBy]++;
567             }     
568 
569         } else {
570             // no ref purchase
571             // add the referral bonus back to the global dividends cake
572             _dividends = SafeMath.add(_dividends, _referralBonus);
573             _fee = _dividends * magnitude;
574         }
575 
576         if (isUser[_customerAddress] == false ) {
577         	isUser[_customerAddress] = true;
578         	usersAddresses.push(_customerAddress);
579         }
580 
581         // we can't give people infinite ethereum
582         if(tokenSupply_ > 0){
583 
584             // add tokens to the pool
585             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
586 
587             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
588             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
589 
590             // calculate the amount of tokens the customer receives over his purchase
591             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
592 
593         } else {
594             // add tokens to the pool
595             tokenSupply_ = _amountOfTokens;
596         }
597 
598         // update circulating supply & the ledger address for the customer
599         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
600 
601         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
602         //really i know you think you do but you don't
603         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
604         payoutsTo_[_customerAddress] += _updatedPayouts;
605 
606         // fire event
607         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
608 
609         return _amountOfTokens;
610     }
611 
612     /**
613      * Calculate Token price based on an amount of incoming ethereum
614      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
615      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
616      */
617     function ethereumToTokens_(uint256 _ethereum)
618         internal
619         view
620         returns(uint256)
621     {
622         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
623         uint256 _tokensReceived =
624          (
625             (
626                 // underflow attempts BTFO
627                 SafeMath.sub(
628                     (sqrt
629                         (
630                             (_tokenPriceInitial**2)
631                             +
632                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
633                             +
634                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
635                             +
636                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
637                         )
638                     ), _tokenPriceInitial
639                 )
640             )/(tokenPriceIncremental_)
641         )-(tokenSupply_)
642         ;
643 
644         return _tokensReceived;
645     }
646 
647     /**
648      * Calculate token sell value.
649      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
650      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
651      */
652      function tokensToEthereum_(uint256 _tokens)
653         internal
654         view
655         returns(uint256)
656     {
657 
658         uint256 tokens_ = (_tokens + 1e18);
659         uint256 _tokenSupply = (tokenSupply_ + 1e18);
660         uint256 _etherReceived =
661         (
662             // underflow attempts BTFO
663             SafeMath.sub(
664                 (
665                     (
666                         (
667                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
668                         )-tokenPriceIncremental_
669                     )*(tokens_ - 1e18)
670                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
671             )
672         /1e18);
673         return _etherReceived;
674     }
675 
676 
677     //This is where all your gas goes, sorry
678     //Not sorry, you probably only paid 1 gwei
679     function sqrt(uint x) internal pure returns (uint y) {
680         uint z = (x + 1) / 2;
681         y = x;
682         while (z < y) {
683             y = z;
684             z = (x / z + z) / 2;
685         }
686     }
687 }
688 
689 /**
690  * @title SafeMath
691  * @dev Math operations with safety checks that throw on error
692  */
693 library SafeMath {
694 
695     /**
696     * @dev Multiplies two numbers, throws on overflow.
697     */
698     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
699         if (a == 0) {
700             return 0;
701         }
702         uint256 c = a * b;
703         assert(c / a == b);
704         return c;
705     }
706 
707     /**
708     * @dev Integer division of two numbers, truncating the quotient.
709     */
710     function div(uint256 a, uint256 b) internal pure returns (uint256) {
711         // assert(b > 0); // Solidity automatically throws when dividing by 0
712         uint256 c = a / b;
713         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
714         return c;
715     }
716 
717     /**
718     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
719     */
720     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
721         assert(b <= a);
722         return a - b;
723     }
724 
725     /**
726     * @dev Adds two numbers, throws on overflow.
727     */
728     function add(uint256 a, uint256 b) internal pure returns (uint256) {
729         uint256 c = a + b;
730         assert(c >= a);
731         return c;
732     }
733 }