1 pragma solidity ^0.4.20;
2 
3 /*
4     -------------------------------------------------------------------------------------------------------
5     Website: https://kingdometh.com
6     Twitter: https://twitter.com/KingdomETH
7     Telegram Group: https://t.me/joinchat/IvMthlFxD8cfhpXR0wqT-g
8     Facebook: https://www.facebook.com/Kingdometh-282085195979826
9     Discord: https://discord.gg/TxhSfNB
10     -------------------------------------------------------------------------------------------------------
11 	KingdomETH 
12      KingdomETH - Ethereum Dapp Game Earn Ethereum 
13 	- Buys - 25% fee goes to all current token holders. 
14 	- Sells - 25% fee to all current tokens holders. And it’s lower because you shouldn’t have to pay the sane fee exiting. You deserve more. 
15 	- Transfers - 0% fee! We have plans for games and we don't want that to be an obstacle!
16 	- Masternode - you get 7% from deposit of all players who enter using your Masternode . 
17 */
18 
19 contract KingdomEthGoldCoin {
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
38     // -> change the Gold Coins Stakes difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
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
118     string public name = "Gold Coin";
119     string public symbol = "GoldCoin";
120     uint8 constant public decimals = 18;
121     uint8 constant internal entryFee_ = 25; // 25% to enter our community
122     uint8 constant internal refferalFee_ = 20; // 20% from enter fee divs or 7% for each invite, great for inviting new members on KingdomETH
123     uint8 constant internal exitFee_ = 25; // 25% for selling
124     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
125     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
126     uint256 constant internal magnitude = 2**64;
127 
128     // proof of stake (defaults at 100 tokens)
129     uint256 public stakingRequirement = 100e18;
130 
131     // ambassador program
132     mapping(address => bool) internal ambassadors_;
133     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
134     uint256 constant internal ambassadorQuota_ = 20 ether;
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
164     function KingdomETHCom()
165         public
166     {
167         // add administrators here with their wallets
168 
169   		// bungalogic
170 		// Website developer, concept and design. Community
171 		administrators[0x6018106414EA98FD30854b1232FebD66Bc4dF419] = true;
172 		ambassadors_[0x6018106414EA98FD30854b1232FebD66Bc4dF419] = true;
173 
174 		// clumsier 
175 		// Solidity Developer, website,  Gold Coin 
176 		administrators[msg.sender] = true;
177 		ambassadors_[msg.sender] = true;
178     }
179 
180 
181     /**
182      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
183      */
184     function buy(address _referredBy)
185         public
186         payable
187         returns(uint256)
188     {
189         purchaseTokens(msg.value, _referredBy);
190     }
191 
192     /**
193      * Fallback function to handle ethereum that was send straight to the contract
194      * Unfortunately we cannot use a referral address this way.
195      */
196     function()
197         payable
198         public
199     {
200         purchaseTokens(msg.value, 0x0);
201     }
202 
203     /* Converts all of caller's dividends to tokens. */
204     function reinvest() onlyStronghands() public {
205         // fetch dividends
206         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
207 
208         // pay out the dividends virtually
209         address _customerAddress = msg.sender;
210         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
211 
212         // retrieve ref. bonus
213         _dividends += referralBalance_[_customerAddress];
214         referralBalance_[_customerAddress] = 0;
215 
216         // dispatch a buy order with the virtualized "withdrawn dividends"
217         uint256 _tokens = purchaseTokens(_dividends, 0x0);
218 
219         // fire event
220         onReinvestment(_customerAddress, _dividends, _tokens);
221     }
222 
223     /* Alias of sell() and withdraw(). */
224     function exit() public {
225         // get token count for caller & sell them all
226         address _customerAddress = msg.sender;
227         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
228         if(_tokens > 0) sell(_tokens);
229 
230         // lambo delivery service
231         withdraw();
232     }
233 
234     /* Withdraws all of the callers earnings. */
235     function withdraw() onlyStronghands() public {
236         // setup data
237         address _customerAddress = msg.sender;
238         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
239 
240         // update dividend tracker
241         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
242 
243         // add ref. bonus
244         _dividends += referralBalance_[_customerAddress];
245         referralBalance_[_customerAddress] = 0;
246 
247         // lambo delivery service
248         _customerAddress.transfer(_dividends);
249 
250         // fire event
251         onWithdraw(_customerAddress, _dividends);
252     }
253 
254     /* Liquifies tokens to ethereum. */
255     function sell(uint256 _amountOfTokens) onlyBagholders() public {
256         // setup data
257         address _customerAddress = msg.sender;
258         // russian hackers BTFO
259         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
260         uint256 _tokens = _amountOfTokens;
261         uint256 _ethereum = tokensToEthereum_(_tokens);
262         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
263         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
264 
265         // burn the sold tokens
266         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
267         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
268 
269         // update dividends tracker
270         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
271         payoutsTo_[_customerAddress] -= _updatedPayouts;
272 
273         // dividing by zero is a bad idea
274         if (tokenSupply_ > 0) {
275             // update the amount of dividends per token
276             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
277         }
278 
279         // fire event
280         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
281     }
282 
283 
284     /* Transfer tokens from the caller to a new holder. * No fee! */
285     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders() public returns(bool) {
286         // setup
287         address _customerAddress = msg.sender;
288 
289         // make sure we have the requested tokens
290         // also disables transfers until ambassador phase is over
291         // ( we dont want whale premines )
292         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
293 
294         // withdraw all outstanding dividends first
295         if(myDividends(true) > 0) withdraw();
296 
297         // exchange tokens
298         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
299         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
300 
301         // update dividend trackers
302         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
303         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
304 
305         // fire event
306         Transfer(_customerAddress, _toAddress, _amountOfTokens);
307 
308         // ERC20
309         return true;
310 
311     }
312 
313     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
314     /**
315      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
316      */
317     function disableInitialStage()
318         onlyAdministrator()
319         public
320     {
321         onlyAmbassadors = false;
322     }
323 
324     /**
325      * In case one of us dies, we need to replace ourselves.
326      */
327     function setAdministrator(address _identifier, bool _status)
328         onlyAdministrator()
329         public
330     {
331         administrators[_identifier] = _status;
332     }
333 
334     /**
335      * Precautionary measures in case we need to adjust the masternode rate.
336      */
337     function setStakingRequirement(uint256 _amountOfTokens)
338         onlyAdministrator()
339         public
340     {
341         stakingRequirement = _amountOfTokens;
342     }
343 
344     /**
345      * If we want to rebrand, we can.
346      */
347     function setName(string _name)
348         onlyAdministrator()
349         public
350     {
351         name = _name;
352     }
353 
354     /**
355      * If we want to rebrand, we can.
356      */
357     function setSymbol(string _symbol)
358         onlyAdministrator()
359         public
360     {
361         symbol = _symbol;
362     }
363 
364 
365     /*----------  HELPERS AND CALCULATORS  ----------*/
366     /**
367      * Method to view the current Ethereum stored in the contract
368      * Example: totalEthereumBalance()
369      */
370     function totalEthereumBalance()
371         public
372         view
373         returns(uint)
374     {
375         return this.balance;
376     }
377 
378     /**
379      * Retrieve the total token supply.
380      */
381     function totalSupply()
382         public
383         view
384         returns(uint256)
385     {
386         return tokenSupply_;
387     }
388 
389     /**
390      * Retrieve the tokens owned by the caller.
391      */
392     function myTokens()
393         public
394         view
395         returns(uint256)
396     {
397         address _customerAddress = msg.sender;
398         return balanceOf(_customerAddress);
399     }
400 
401     function referralsOf(address _customerAddress)
402         public
403         view
404         returns(uint256)
405     {
406         return referrals[_customerAddress];
407     }
408 
409     function totalUsers()
410         public
411         view
412         returns(uint256)
413     {
414         return usersAddresses.length;
415     }
416 
417     /**
418      * Retrieve the dividends owned by the caller.
419      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
420      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
421      * But in the internal calculations, we want them separate.
422      */
423     function myDividends(bool _includeReferralBonus)
424         public
425         view
426         returns(uint256)
427     {
428         address _customerAddress = msg.sender;
429         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
430     }
431 
432     /**
433      * Retrieve the token balance of any single address.
434      */
435     function balanceOf(address _customerAddress)
436         view
437         public
438         returns(uint256)
439     {
440         return tokenBalanceLedger_[_customerAddress];
441     }
442 
443     /**
444      * Retrieve the dividend balance of any single address.
445      */
446     function dividendsOf(address _customerAddress)
447         view
448         public
449         returns(uint256)
450     {
451         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
452     }
453 
454     /**
455      * Return the buy price of 1 individual token.
456      */
457     function sellPrice()
458         public
459         view
460         returns(uint256)
461     {
462         // our calculation relies on the token supply, so we need supply. Doh.
463         if(tokenSupply_ == 0){
464             return tokenPriceInitial_ - tokenPriceIncremental_;
465         } else {
466             uint256 _ethereum = tokensToEthereum_(1e18);
467             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
468             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
469             return _taxedEthereum;
470         }
471     }
472 
473     /**
474      * Return the sell price of 1 individual token.
475      */
476     function buyPrice()
477         public
478         view
479         returns(uint256)
480     {
481         // our calculation relies on the token supply, so we need supply. Doh.
482         if(tokenSupply_ == 0){
483             return tokenPriceInitial_ + tokenPriceIncremental_;
484         } else {
485             uint256 _ethereum = tokensToEthereum_(1e18);
486             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
487             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
488             return _taxedEthereum;
489         }
490     }
491 
492     /**
493      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
494      */
495     function calculateTokensReceived(uint256 _ethereumToSpend)
496         public
497         view
498         returns(uint256)
499     {
500         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
501         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
502         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
503 
504         return _amountOfTokens;
505     }
506 
507     /**
508      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
509      */
510     function calculateEthereumReceived(uint256 _tokensToSell)
511         public
512         view
513         returns(uint256)
514     {
515         require(_tokensToSell <= tokenSupply_);
516         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
517         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
518         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
519         return _taxedEthereum;
520     }
521 
522 
523     /*==========================================
524     =            INTERNAL FUNCTIONS            =
525     ==========================================*/
526     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
527         antiEarlyWhale(_incomingEthereum)
528         internal
529         returns(uint256)
530     {
531         // data setup
532         address _customerAddress = msg.sender;
533         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
534         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
535         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
536         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
537         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
538         uint256 _fee = _dividends * magnitude;
539 
540         // no point in continuing execution if OP is a poorfag russian hacker
541         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
542         // (or hackers)
543         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
544         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
545 
546         // is the user referred by a masternode?
547         if(
548             // is this a referred purchase?
549             _referredBy != 0x0000000000000000000000000000000000000000 &&
550 
551             // no cheating!
552             _referredBy != _customerAddress &&
553 
554             // does the referrer have at least X whole tokens?
555             // i.e is the referrer a Kekly chad masternode
556             tokenBalanceLedger_[_referredBy] >= stakingRequirement
557         ){
558             // wealth redistribution
559             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
560 
561             if (isUser[_customerAddress] == false) {
562             	referrals[_referredBy]++;
563             }     
564 
565         } else {
566             // no ref purchase
567             // add the referral bonus back to the global dividends cake
568             _dividends = SafeMath.add(_dividends, _referralBonus);
569             _fee = _dividends * magnitude;
570         }
571 
572         if (isUser[_customerAddress] == false ) {
573         	isUser[_customerAddress] = true;
574         	usersAddresses.push(_customerAddress);
575         }
576 
577         // we can't give people infinite ethereum
578         if(tokenSupply_ > 0){
579 
580             // add tokens to the pool
581             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
582 
583             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
584             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
585 
586             // calculate the amount of tokens the customer receives over his purchase
587             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
588 
589         } else {
590             // add tokens to the pool
591             tokenSupply_ = _amountOfTokens;
592         }
593 
594         // update circulating supply & the ledger address for the customer
595         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
596 
597         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
598         //really i know you think you do but you don't
599         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
600         payoutsTo_[_customerAddress] += _updatedPayouts;
601 
602         // fire event
603         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
604 
605         return _amountOfTokens;
606     }
607 
608     /**
609      * Calculate Token price based on an amount of incoming ethereum
610      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
611      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
612      */
613     function ethereumToTokens_(uint256 _ethereum)
614         internal
615         view
616         returns(uint256)
617     {
618         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
619         uint256 _tokensReceived =
620          (
621             (
622                 // underflow attempts BTFO
623                 SafeMath.sub(
624                     (sqrt
625                         (
626                             (_tokenPriceInitial**2)
627                             +
628                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
629                             +
630                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
631                             +
632                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
633                         )
634                     ), _tokenPriceInitial
635                 )
636             )/(tokenPriceIncremental_)
637         )-(tokenSupply_)
638         ;
639 
640         return _tokensReceived;
641     }
642 
643     /**
644      * Calculate token sell value.
645      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
646      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
647      */
648      function tokensToEthereum_(uint256 _tokens)
649         internal
650         view
651         returns(uint256)
652     {
653 
654         uint256 tokens_ = (_tokens + 1e18);
655         uint256 _tokenSupply = (tokenSupply_ + 1e18);
656         uint256 _etherReceived =
657         (
658             // underflow attempts BTFO
659             SafeMath.sub(
660                 (
661                     (
662                         (
663                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
664                         )-tokenPriceIncremental_
665                     )*(tokens_ - 1e18)
666                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
667             )
668         /1e18);
669         return _etherReceived;
670     }
671 
672 
673     //This is where all your gas goes, sorry
674     //Not sorry, you probably only paid 1 gwei
675     function sqrt(uint x) internal pure returns (uint y) {
676         uint z = (x + 1) / 2;
677         y = x;
678         while (z < y) {
679             y = z;
680             z = (x / z + z) / 2;
681         }
682     }
683 }
684 
685 /**
686  * @title SafeMath
687  * @dev Math operations with safety checks that throw on error
688  */
689 library SafeMath {
690 
691     /**
692     * @dev Multiplies two numbers, throws on overflow.
693     */
694     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
695         if (a == 0) {
696             return 0;
697         }
698         uint256 c = a * b;
699         assert(c / a == b);
700         return c;
701     }
702 
703     /**
704     * @dev Integer division of two numbers, truncating the quotient.
705     */
706     function div(uint256 a, uint256 b) internal pure returns (uint256) {
707         // assert(b > 0); // Solidity automatically throws when dividing by 0
708         uint256 c = a / b;
709         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
710         return c;
711     }
712 
713     /**
714     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
715     */
716     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
717         assert(b <= a);
718         return a - b;
719     }
720 
721     /**
722     * @dev Adds two numbers, throws on overflow.
723     */
724     function add(uint256 a, uint256 b) internal pure returns (uint256) {
725         uint256 c = a + b;
726         assert(c >= a);
727         return c;
728     }
729 }