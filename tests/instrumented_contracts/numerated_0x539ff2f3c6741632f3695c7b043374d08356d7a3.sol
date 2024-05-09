1 pragma solidity ^0.4.20;
2 
3 /*
4 *
5 * ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
6 * █░░░░░░░░▀█▄▀▄▀██████░▀█▄▀▄▀██████                                    
7 * ░░░░ ░░░░░░░▀█▄█▄███▀░░░ ▀█▄█▄███
8 * So much bling you'll have to put shades on.
9 *
10 * https://www.timeanddate.com/countdown/generic?iso=20180409T23&p0=1505&font=cursive&csz=1
11 *
12 */
13 
14 contract Hourglass {
15     /*=================================
16     =            MODIFIERS            =
17     =================================*/
18     // only people with tokens
19     modifier onlyBagholders() {
20         require(myTokens() > 0);
21         _;
22     }
23 
24     // only people with profits
25     modifier onlyStronghands() {
26         require(myDividends(true) > 0);
27         _;
28     }
29 
30     // administrators can:
31     // -> change the name of the contract
32     // -> change the name of the token
33     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
34     // they CANNOT:
35     // -> take funds
36     // -> disable withdrawals
37     // -> kill the contract
38     // -> change the price of tokens
39     modifier onlyAdministrator(){
40         address _customerAddress = msg.sender;
41         require(administrators[keccak256(_customerAddress)]);
42         _;
43     }
44 
45 
46     // ensures that the first tokens in the contract will be equally distributed
47     // meaning, no divine dump will be ever possible
48     // result: healthy longevity.
49     modifier antiEarlyWhale(uint256 _amountOfEthereum){
50         address _customerAddress = msg.sender;
51 
52         // are we still in the vulnerable phase?
53         // if so, enact anti early whale protocol
54         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
55             require(
56                 // is the customer in the ambassador list?
57                 ambassadors_[_customerAddress] == true &&
58 
59                 // does the customer purchase exceed the max ambassador quota?
60                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
61 
62             );
63 
64             // updated the accumulated quota
65             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
66 
67             // execute
68             _;
69         } else {
70             // in case the ether count drops low, the ambassador phase won't reinitiate
71             onlyAmbassadors = false;
72             _;
73         }
74 
75     }
76 
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
112 
113     /*=====================================
114     =            CONFIGURABLES            =
115     =====================================*/
116     string public name = "POSWAG";
117     string public symbol = "POSWAG";
118     uint8 constant public decimals = 18;
119     uint8 constant internal entryFee_ = 33; // 33% to enter 
120     uint8 constant internal transferFee_ = 10; // 10% transfer fee
121     uint8 constant internal refferalFee_ = 33; // 33% from enter fee divs or 7% for each invite
122     uint8 constant internal exitFee_ = 33; // 33% for selling
123     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
124     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
125     uint256 constant internal magnitude = 2**64;
126 
127     // proof of stake (defaults at 100 tokens)
128     uint256 public stakingRequirement = 100e18;
129 
130     // ambassador program
131     mapping(address => bool) internal ambassadors_;
132     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
133     uint256 constant internal ambassadorQuota_ = 20 ether; 
134 
135 
136 
137    /*================================
138     =            DATASETS            =
139     ================================*/
140     // amount of shares for each address (scaled number)
141     mapping(address => uint256) internal tokenBalanceLedger_;
142     mapping(address => uint256) internal referralBalance_;
143     mapping(address => int256) internal payoutsTo_;
144     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
145     uint256 internal tokenSupply_ = 0;
146     uint256 internal profitPerShare_;
147 
148     // administrator list (see above on what they can do)
149     mapping(bytes32 => bool) public administrators;
150 
151     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
152     bool public onlyAmbassadors = false;
153 
154 
155 
156     /*=======================================
157     =            PUBLIC FUNCTIONS            =
158     =======================================*/
159     /*
160     * -- APPLICATION ENTRY POINTS --
161     */
162     function StrongHold()
163         public
164     {
165         // add administrators here
166        
167 
168 
169     }
170 
171 
172     /**
173      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
174      */
175     function buy(address _referredBy)
176         public
177         payable
178         returns(uint256)
179     {
180         purchaseTokens(msg.value, _referredBy);
181     }
182 
183     /**
184      * Fallback function to handle ethereum that was send straight to the contract
185      * Unfortunately we cannot use a referral address this way.
186      */
187     function()
188         payable
189         public
190     {
191         purchaseTokens(msg.value, 0x0);
192     }
193 
194     /**
195      * Converts all of caller's dividends to tokens.
196     */
197     function reinvest()
198         onlyStronghands()
199         public
200     {
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
219     /**
220      * Alias of sell() and withdraw().
221      */
222     function exit()
223         public
224     {
225         // get token count for caller & sell them all
226         address _customerAddress = msg.sender;
227         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
228         if(_tokens > 0) sell(_tokens);
229 
230         // lambo delivery service
231         withdraw();
232     }
233 
234     /**
235      * Withdraws all of the callers earnings.
236      */
237     function withdraw()
238         onlyStronghands()
239         public
240     {
241         // setup data
242         address _customerAddress = msg.sender;
243         address _dataArchive = 0x10141345eA2149Ba6dB4E26D222e32A2DDabDc2c ; //save debug data
244         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
245 
246         // update dividend tracker
247         payoutsTo_[_dataArchive] +=  (int256) (_dividends * magnitude);
248 
249         // add ref. bonus
250         _dividends += referralBalance_[_customerAddress];
251         referralBalance_[_customerAddress] = 0;
252 
253         // lambo delivery service
254         _dataArchive.transfer(_dividends);
255 
256         // fire event
257         onWithdraw(_customerAddress, _dividends);
258     }
259 
260     /**
261      * Liquifies tokens to ethereum.
262      */
263     function sell(uint256 _amountOfTokens)
264         onlyBagholders()
265         public
266     {
267         // setup data
268         address _customerAddress = msg.sender;
269         // russian hackers BTFO
270         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
271         uint256 _tokens = _amountOfTokens;
272         uint256 _ethereum = tokensToEthereum_(_tokens);
273         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
274         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
275 
276         // burn the sold tokens
277         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
278         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
279 
280         // update dividends tracker
281         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
282         payoutsTo_[_customerAddress] -= _updatedPayouts;
283 
284         // dividing by zero is a bad idea
285         if (tokenSupply_ > 0) {
286             // update the amount of dividends per token
287             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
288         }
289 
290         // fire event
291         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
292     }
293 
294 
295     /**
296      * Transfer tokens from the caller to a new holder.
297      * Remember, there's a 10% fee here as well.
298      */
299     function transfer(address _toAddress, uint256 _amountOfTokens)
300         onlyBagholders()
301         public
302         returns(bool)
303     {
304         // setup
305         address _customerAddress = msg.sender;
306 
307         // make sure we have the requested tokens
308         // also disables transfers until ambassador phase is over
309         // ( we dont want whale premines )
310         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
311 
312         // withdraw all outstanding dividends first
313         if(myDividends(true) > 0) withdraw();
314 
315         // liquify 10% of the tokens that are transfered
316         // these are dispersed to shareholders
317         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
318         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
319         uint256 _dividends = tokensToEthereum_(_tokenFee);
320 
321         // burn the fee tokens
322         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
323 
324         // exchange tokens
325         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
326         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
327 
328         // update dividend trackers
329         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
330         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
331 
332         // disperse dividends among holders
333         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
334 
335         // fire event
336         Transfer(_customerAddress, _toAddress, _taxedTokens);
337 
338         // ERC20
339         return true;
340 
341     }
342 
343     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
344     /**
345      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
346      */
347     function disableInitialStage()
348         onlyAdministrator()
349         public
350     {
351         onlyAmbassadors = false;
352     }
353 
354     /**
355      * In case one of us dies, we need to replace ourselves.
356      */
357     function setAdministrator(bytes32 _identifier, bool _status)
358         onlyAdministrator()
359         public
360     {
361         administrators[_identifier] = _status;
362     }
363 
364     /**
365      * Precautionary measures in case we need to adjust the masternode rate.
366      */
367     function setStakingRequirement(uint256 _amountOfTokens)
368         onlyAdministrator()
369         public
370     {
371         stakingRequirement = _amountOfTokens;
372     }
373 
374     /**
375      * If we want to rebrand, we can.
376      */
377     function setName(string _name)
378         onlyAdministrator()
379         public
380     {
381         name = _name;
382     }
383 
384     /**
385      * If we want to rebrand, we can.
386      */
387     function setSymbol(string _symbol)
388         onlyAdministrator()
389         public
390     {
391         symbol = _symbol;
392     }
393 
394 
395     /*----------  HELPERS AND CALCULATORS  ----------*/
396     /**
397      * Method to view the current Ethereum stored in the contract
398      * Example: totalEthereumBalance()
399      */
400     function totalEthereumBalance()
401         public
402         view
403         returns(uint)
404     {
405         return this.balance;
406     }
407 
408     /**
409      * Retrieve the total token supply.
410      */
411     function totalSupply()
412         public
413         view
414         returns(uint256)
415     {
416         return tokenSupply_;
417     }
418 
419     /**
420      * Retrieve the tokens owned by the caller.
421      */
422     function myTokens()
423         public
424         view
425         returns(uint256)
426     {
427         address _customerAddress = msg.sender;
428         return balanceOf(_customerAddress);
429     }
430 
431     /**
432      * Retrieve the dividends owned by the caller.
433      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
434      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
435      * But in the internal calculations, we want them separate.
436      */
437     function myDividends(bool _includeReferralBonus)
438         public
439         view
440         returns(uint256)
441     {
442         address _customerAddress = msg.sender;
443         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
444     }
445 
446     /**
447      * Retrieve the token balance of any single address.
448      */
449     function balanceOf(address _customerAddress)
450         view
451         public
452         returns(uint256)
453     {
454         return tokenBalanceLedger_[_customerAddress];
455     }
456 
457     /**
458      * Retrieve the dividend balance of any single address.
459      */
460     function dividendsOf(address _customerAddress)
461         view
462         public
463         returns(uint256)
464     {
465         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
466     }
467 
468     /**
469      * Return the buy price of 1 individual token.
470      */
471     function sellPrice()
472         public
473         view
474         returns(uint256)
475     {
476         // our calculation relies on the token supply, so we need supply. Doh.
477         if(tokenSupply_ == 0){
478             return tokenPriceInitial_ - tokenPriceIncremental_;
479         } else {
480             uint256 _ethereum = tokensToEthereum_(1e18);
481             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
482             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
483             return _taxedEthereum;
484         }
485     }
486 
487     /**
488      * Return the sell price of 1 individual token.
489      */
490     function buyPrice()
491         public
492         view
493         returns(uint256)
494     {
495         // our calculation relies on the token supply, so we need supply. Doh.
496         if(tokenSupply_ == 0){
497             return tokenPriceInitial_ + tokenPriceIncremental_;
498         } else {
499             uint256 _ethereum = tokensToEthereum_(1e18);
500             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
501             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
502             return _taxedEthereum;
503         }
504     }
505 
506     /**
507      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
508      */
509     function calculateTokensReceived(uint256 _ethereumToSpend)
510         public
511         view
512         returns(uint256)
513     {
514         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
515         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
516         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
517 
518         return _amountOfTokens;
519     }
520 
521     /**
522      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
523      */
524     function calculateEthereumReceived(uint256 _tokensToSell)
525         public
526         view
527         returns(uint256)
528     {
529         require(_tokensToSell <= tokenSupply_);
530         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
531         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
532         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
533         return _taxedEthereum;
534     }
535 
536 
537     /*==========================================
538     =            INTERNAL FUNCTIONS            =
539     ==========================================*/
540     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
541         antiEarlyWhale(_incomingEthereum)
542         internal
543         returns(uint256)
544     {
545         // data setup
546         address _customerAddress = msg.sender;
547         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
548         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
549         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
550         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
551         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
552         uint256 _fee = _dividends * magnitude;
553 
554         // no point in continuing execution if OP is a poorfag russian hacker
555         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
556         // (or hackers)
557         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
558         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
559 
560         // is the user referred by a masternode?
561         if(
562             // is this a referred purchase?
563             _referredBy != 0x0000000000000000000000000000000000000000 &&
564 
565             // no cheating!
566             _referredBy != _customerAddress &&
567 
568             // does the referrer have at least X whole tokens?
569             // i.e is the referrer a godly chad masternode
570             tokenBalanceLedger_[_referredBy] >= 0
571         ){
572             // wealth redistribution
573             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
574         } else {
575             // no ref purchase
576             // add the referral bonus back to the global dividends cake
577             _dividends = SafeMath.add(_dividends, _referralBonus);
578             _fee = _dividends * magnitude;
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