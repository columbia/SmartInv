1 pragma solidity ^0.4.20;
2 
3 /*
4     -------------------------------------------------------------------------------------------------------
5     Website: https://lootether.com/
6     Exchange (We recomand to use MetaMask or TrustWallet): https://lootether.com/exchange
7     Second Exchange (We recomand to use MetaMask or TrustWallet): https://lootether.com/second
8     Daily Dividends 10% (We recomand to use MetaMask or TrustWallet): https://lootether.com/daily
9     Twitter: https://twitter.com/lootether
10     Discord: https://discordapp.com/invite/bTK4KbB
11     -------------------------------------------------------------------------------------------------------
12 	LootEther 
13      LootEther Earn Passive Ethereum. 
14 	- Buys - 35% fee goes to all current token holders. 
15 	- Sells - 25% fee to all current tokens holders. And it’s lower because you shouldn’t have to pay the sane fee exiting. You deserve more. 
16 	- Transfers - 0% fee! We have plans for games and we don't want that to be an obstacle!
17 	- Masternode - you get 7% from deposit of all players who enter using your Masternode . 
18 */
19 
20 contract LootEther {
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
47         require(administrators[_customerAddress]);
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
119     string public name = "LootEther";
120     string public symbol = "LOOT";
121     uint8 constant public decimals = 18;
122     uint8 constant internal entryFee_ = 35; // 35% to enter our community
123     uint8 constant internal refferalFee_ = 20; // 20% from enter fee divs or 7% for each invite, great for inviting new members on LootEther
124     uint8 constant internal exitFee_ = 25; // 15% for selling
125     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
126     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
127     uint256 constant internal magnitude = 2**64;
128 
129     // proof of stake (defaults at 100 tokens)
130     uint256 public stakingRequirement = 100e18;
131 
132     // ambassador program
133     mapping(address => bool) internal ambassadors_;
134     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
135     uint256 constant internal ambassadorQuota_ = 20 ether;
136 
137     // referral program
138     mapping(address => uint256) internal referrals;
139     mapping(address => bool) internal isUser;
140     address[] public usersAddresses;
141 
142    /*================================
143     =            DATASETS            =
144     ================================*/
145     // amount of shares for each address (scaled number)
146     mapping(address => uint256) internal tokenBalanceLedger_;
147     mapping(address => uint256) internal referralBalance_;
148     mapping(address => int256) internal payoutsTo_;
149     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
150     uint256 internal tokenSupply_ = 0;
151     uint256 internal profitPerShare_;
152 
153     // administrator list (see above on what they can do)
154     mapping(address => bool) public administrators;
155 
156     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
157     bool public onlyAmbassadors = true;
158 
159     /*=======================================
160     =            PUBLIC FUNCTIONS            =
161     =======================================*/
162     /*
163     * -- APPLICATION ENTRY POINTS --
164     */
165     function LootEtherCom()
166         public
167     {
168         // add administrators here with their wallets
169 
170   		// bungalogic
171 		// Website developer, concept and design. Community
172 		administrators[0x4eB3e1dBFf9e61dc8d7B5a084DE4290c4CD8Fc52] = true;
173 		ambassadors_[0x4eB3e1dBFf9e61dc8d7B5a084DE4290c4CD8Fc52] = true;
174 
175 		// clumsier 
176 		// Solidity Developer, website,  LOOT 
177 		administrators[msg.sender] = true;
178 		ambassadors_[msg.sender] = true;
179     }
180 
181 
182     /**
183      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
184      */
185     function buy(address _referredBy)
186         public
187         payable
188         returns(uint256)
189     {
190         purchaseTokens(msg.value, _referredBy);
191     }
192 
193     /**
194      * Fallback function to handle ethereum that was send straight to the contract
195      * Unfortunately we cannot use a referral address this way.
196      */
197     function()
198         payable
199         public
200     {
201         purchaseTokens(msg.value, 0x0);
202     }
203 
204     /* Converts all of caller's dividends to tokens. */
205     function reinvest() onlyStronghands() public {
206         // fetch dividends
207         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
208 
209         // pay out the dividends virtually
210         address _customerAddress = msg.sender;
211         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
212 
213         // retrieve ref. bonus
214         _dividends += referralBalance_[_customerAddress];
215         referralBalance_[_customerAddress] = 0;
216 
217         // dispatch a buy order with the virtualized "withdrawn dividends"
218         uint256 _tokens = purchaseTokens(_dividends, 0x0);
219 
220         // fire event
221         onReinvestment(_customerAddress, _dividends, _tokens);
222     }
223 
224     /* Alias of sell() and withdraw(). */
225     function exit() public {
226         // get token count for caller & sell them all
227         address _customerAddress = msg.sender;
228         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
229         if(_tokens > 0) sell(_tokens);
230 
231         // lambo delivery service
232         withdraw();
233     }
234 
235     /* Withdraws all of the callers earnings. */
236     function withdraw() onlyStronghands() public {
237         // setup data
238         address _customerAddress = msg.sender;
239         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
240 
241         // update dividend tracker
242         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
243 
244         // add ref. bonus
245         _dividends += referralBalance_[_customerAddress];
246         referralBalance_[_customerAddress] = 0;
247 
248         // lambo delivery service
249         _customerAddress.transfer(_dividends);
250 
251         // fire event
252         onWithdraw(_customerAddress, _dividends);
253     }
254 
255     /* Liquifies tokens to ethereum. */
256     function sell(uint256 _amountOfTokens) onlyBagholders() public {
257         // setup data
258         address _customerAddress = msg.sender;
259         // russian hackers BTFO
260         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
261         uint256 _tokens = _amountOfTokens;
262         uint256 _ethereum = tokensToEthereum_(_tokens);
263         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
264         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
265 
266         // burn the sold tokens
267         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
268         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
269 
270         // update dividends tracker
271         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
272         payoutsTo_[_customerAddress] -= _updatedPayouts;
273 
274         // dividing by zero is a bad idea
275         if (tokenSupply_ > 0) {
276             // update the amount of dividends per token
277             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
278         }
279 
280         // fire event
281         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
282     }
283 
284 
285     /* Transfer tokens from the caller to a new holder. * No fee! */
286     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders() public returns(bool) {
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
298         // exchange tokens
299         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
300         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
301 
302         // update dividend trackers
303         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
304         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
305 
306         // fire event
307         Transfer(_customerAddress, _toAddress, _amountOfTokens);
308 
309         // ERC20
310         return true;
311 
312     }
313 
314     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
315     /**
316      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
317      */
318     function disableInitialStage()
319         onlyAdministrator()
320         public
321     {
322         onlyAmbassadors = false;
323     }
324 
325     /**
326      * In case one of us dies, we need to replace ourselves.
327      */
328     function setAdministrator(address _identifier, bool _status)
329         onlyAdministrator()
330         public
331     {
332         administrators[_identifier] = _status;
333     }
334 
335     /**
336      * Precautionary measures in case we need to adjust the masternode rate.
337      */
338     function setStakingRequirement(uint256 _amountOfTokens)
339         onlyAdministrator()
340         public
341     {
342         stakingRequirement = _amountOfTokens;
343     }
344 
345     /**
346      * If we want to rebrand, we can.
347      */
348     function setName(string _name)
349         onlyAdministrator()
350         public
351     {
352         name = _name;
353     }
354 
355     /**
356      * If we want to rebrand, we can.
357      */
358     function setSymbol(string _symbol)
359         onlyAdministrator()
360         public
361     {
362         symbol = _symbol;
363     }
364 
365 
366     /*----------  HELPERS AND CALCULATORS  ----------*/
367     /**
368      * Method to view the current Ethereum stored in the contract
369      * Example: totalEthereumBalance()
370      */
371     function totalEthereumBalance()
372         public
373         view
374         returns(uint)
375     {
376         return this.balance;
377     }
378 
379     /**
380      * Retrieve the total token supply.
381      */
382     function totalSupply()
383         public
384         view
385         returns(uint256)
386     {
387         return tokenSupply_;
388     }
389 
390     /**
391      * Retrieve the tokens owned by the caller.
392      */
393     function myTokens()
394         public
395         view
396         returns(uint256)
397     {
398         address _customerAddress = msg.sender;
399         return balanceOf(_customerAddress);
400     }
401 
402     function referralsOf(address _customerAddress)
403         public
404         view
405         returns(uint256)
406     {
407         return referrals[_customerAddress];
408     }
409 
410     function totalUsers()
411         public
412         view
413         returns(uint256)
414     {
415         return usersAddresses.length;
416     }
417 
418     /**
419      * Retrieve the dividends owned by the caller.
420      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
421      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
422      * But in the internal calculations, we want them separate.
423      */
424     function myDividends(bool _includeReferralBonus)
425         public
426         view
427         returns(uint256)
428     {
429         address _customerAddress = msg.sender;
430         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
431     }
432 
433     /**
434      * Retrieve the token balance of any single address.
435      */
436     function balanceOf(address _customerAddress)
437         view
438         public
439         returns(uint256)
440     {
441         return tokenBalanceLedger_[_customerAddress];
442     }
443 
444     /**
445      * Retrieve the dividend balance of any single address.
446      */
447     function dividendsOf(address _customerAddress)
448         view
449         public
450         returns(uint256)
451     {
452         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
453     }
454 
455     /**
456      * Return the buy price of 1 individual token.
457      */
458     function sellPrice()
459         public
460         view
461         returns(uint256)
462     {
463         // our calculation relies on the token supply, so we need supply. Doh.
464         if(tokenSupply_ == 0){
465             return tokenPriceInitial_ - tokenPriceIncremental_;
466         } else {
467             uint256 _ethereum = tokensToEthereum_(1e18);
468             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
469             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
470             return _taxedEthereum;
471         }
472     }
473 
474     /**
475      * Return the sell price of 1 individual token.
476      */
477     function buyPrice()
478         public
479         view
480         returns(uint256)
481     {
482         // our calculation relies on the token supply, so we need supply. Doh.
483         if(tokenSupply_ == 0){
484             return tokenPriceInitial_ + tokenPriceIncremental_;
485         } else {
486             uint256 _ethereum = tokensToEthereum_(1e18);
487             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
488             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
489             return _taxedEthereum;
490         }
491     }
492 
493     /**
494      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
495      */
496     function calculateTokensReceived(uint256 _ethereumToSpend)
497         public
498         view
499         returns(uint256)
500     {
501         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
502         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
503         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
504 
505         return _amountOfTokens;
506     }
507 
508     /**
509      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
510      */
511     function calculateEthereumReceived(uint256 _tokensToSell)
512         public
513         view
514         returns(uint256)
515     {
516         require(_tokensToSell <= tokenSupply_);
517         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
518         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
519         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
520         return _taxedEthereum;
521     }
522 
523 
524     /*==========================================
525     =            INTERNAL FUNCTIONS            =
526     ==========================================*/
527     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
528         antiEarlyWhale(_incomingEthereum)
529         internal
530         returns(uint256)
531     {
532         // data setup
533         address _customerAddress = msg.sender;
534         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
535         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
536         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
537         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
538         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
539         uint256 _fee = _dividends * magnitude;
540 
541         // no point in continuing execution if OP is a poorfag russian hacker
542         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
543         // (or hackers)
544         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
545         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
546 
547         // is the user referred by a masternode?
548         if(
549             // is this a referred purchase?
550             _referredBy != 0x0000000000000000000000000000000000000000 &&
551 
552             // no cheating!
553             _referredBy != _customerAddress &&
554 
555             // does the referrer have at least X whole tokens?
556             // i.e is the referrer a Kekly chad masternode
557             tokenBalanceLedger_[_referredBy] >= stakingRequirement
558         ){
559             // wealth redistribution
560             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
561 
562             if (isUser[_customerAddress] == false) {
563             	referrals[_referredBy]++;
564             }     
565 
566         } else {
567             // no ref purchase
568             // add the referral bonus back to the global dividends cake
569             _dividends = SafeMath.add(_dividends, _referralBonus);
570             _fee = _dividends * magnitude;
571         }
572 
573         if (isUser[_customerAddress] == false ) {
574         	isUser[_customerAddress] = true;
575         	usersAddresses.push(_customerAddress);
576         }
577 
578         // we can't give people infinite ethereum
579         if(tokenSupply_ > 0){
580 
581             // add tokens to the pool
582             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
583 
584             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
585             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
586 
587             // calculate the amount of tokens the customer receives over his purchase
588             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
589 
590         } else {
591             // add tokens to the pool
592             tokenSupply_ = _amountOfTokens;
593         }
594 
595         // update circulating supply & the ledger address for the customer
596         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
597 
598         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
599         //really i know you think you do but you don't
600         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
601         payoutsTo_[_customerAddress] += _updatedPayouts;
602 
603         // fire event
604         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
605 
606         return _amountOfTokens;
607     }
608 
609     /**
610      * Calculate Token price based on an amount of incoming ethereum
611      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
612      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
613      */
614     function ethereumToTokens_(uint256 _ethereum)
615         internal
616         view
617         returns(uint256)
618     {
619         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
620         uint256 _tokensReceived =
621          (
622             (
623                 // underflow attempts BTFO
624                 SafeMath.sub(
625                     (sqrt
626                         (
627                             (_tokenPriceInitial**2)
628                             +
629                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
630                             +
631                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
632                             +
633                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
634                         )
635                     ), _tokenPriceInitial
636                 )
637             )/(tokenPriceIncremental_)
638         )-(tokenSupply_)
639         ;
640 
641         return _tokensReceived;
642     }
643 
644     /**
645      * Calculate token sell value.
646      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
647      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
648      */
649      function tokensToEthereum_(uint256 _tokens)
650         internal
651         view
652         returns(uint256)
653     {
654 
655         uint256 tokens_ = (_tokens + 1e18);
656         uint256 _tokenSupply = (tokenSupply_ + 1e18);
657         uint256 _etherReceived =
658         (
659             // underflow attempts BTFO
660             SafeMath.sub(
661                 (
662                     (
663                         (
664                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
665                         )-tokenPriceIncremental_
666                     )*(tokens_ - 1e18)
667                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
668             )
669         /1e18);
670         return _etherReceived;
671     }
672 
673 
674     //This is where all your gas goes, sorry
675     //Not sorry, you probably only paid 1 gwei
676     function sqrt(uint x) internal pure returns (uint y) {
677         uint z = (x + 1) / 2;
678         y = x;
679         while (z < y) {
680             y = z;
681             z = (x / z + z) / 2;
682         }
683     }
684 }
685 
686 /**
687  * @title SafeMath
688  * @dev Math operations with safety checks that throw on error
689  */
690 library SafeMath {
691 
692     /**
693     * @dev Multiplies two numbers, throws on overflow.
694     */
695     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
696         if (a == 0) {
697             return 0;
698         }
699         uint256 c = a * b;
700         assert(c / a == b);
701         return c;
702     }
703 
704     /**
705     * @dev Integer division of two numbers, truncating the quotient.
706     */
707     function div(uint256 a, uint256 b) internal pure returns (uint256) {
708         // assert(b > 0); // Solidity automatically throws when dividing by 0
709         uint256 c = a / b;
710         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
711         return c;
712     }
713 
714     /**
715     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
716     */
717     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
718         assert(b <= a);
719         return a - b;
720     }
721 
722     /**
723     * @dev Adds two numbers, throws on overflow.
724     */
725     function add(uint256 a, uint256 b) internal pure returns (uint256) {
726         uint256 c = a + b;
727         assert(c >= a);
728         return c;
729     }
730 }