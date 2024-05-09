1 pragma solidity ^0.4.20;
2 
3 /*
4 * BlvckMoneySteeze presents..
5 * ====================================*
6 * ⓅⓄⓈⓂ
7 * “PROOF OF SHEEP MENTALITIES”
8 * Some people are sheep, some are herders, and others are WOLVES
9 * Which are you?
10 * ====================================*
11 * -> What?
12 * The original autonomous PROOF contract, improved:
13 * [x] More stable than ever, having withstood severe testnet abuse and attack attempts from THEIR community!.
14 * [x] Audited, tested, and approved by DE FACTO.
15 * [X] SAME functionality; you can perform partial sell orders. If you succumb to WOLVES, you don't have to kill all the SHEEP!
16 * [x] SAME functionality; you can transfer tokens between wallets. Trading is possible from within the contract!
17 * [x] SAME Features but BETTER: PoS MasterWOLF! The NEXT implementation of Ethereum Staking in the world! Mantso is mad.
18 * [x] MasterWOLF: Holding ANY POSM Tokens allows you to generate a MasterWOLF link, MasterWOLF links are used as unique entry points to the contract!
19 * [x] MasterWOLF: All players who enter the contract through your MasterWOLF link will have 80% of their 10% dividends fee rerouted from the masterWOLF, to the WOLF-master!
20 * [x] INSANE protection from whales - Other contracts have promised this but whales still took over. Well NOW you wanna read the contract don’t you?
21 *
22 * -> What about the last projects?
23 * All other PROOF contracts are DED .
24 * The dev team is the dev team from before, Thanks P3D!
25 * The difference here is the mistakes have been addressed from not only the perspective of the small player but also core marketing elements have been improved. 
26 * 
27 * -> Who worked on this project?
28 * - BlvckMoneySteeze (POSM Visionary, N00B Solidity Dev)
29 * - Mantso (Solidity dev) by DE FACTO & Inspiration only
30 * - Anonymous Helpers (Solidity Devs)
31 
32 *
33 * -> Who has audited & approved the projected:
34 * - Anonymous Helpers
35 */
36 
37 contract ProofOfSheepM {
38     /*=================================
39     =            MODIFIERS            =
40     =================================*/
41     // only people with tokens
42     modifier onlyBagholders() {
43         require(myTokens() > 0);
44         _;
45     }
46 
47     // only people with profits
48     modifier onlyStronghands() {
49         require(myDividends(true) > 0);
50         _;
51     }
52 
53     // administrators can:
54     // -> change the name of the contract
55     // -> change the name of the token
56     // -> authorize a new administrator
57     // -> change how many tokens it costs to hold a masternode (fat chance!)
58     // they CANNOT:
59     // -> take funds
60     // -> disable withdrawals
61     // -> kill the contract
62     // -> change the price of tokens
63     modifier onlyAdministrator(){
64         address _customerAddress = msg.sender;
65         require(administrators[keccak256(_customerAddress)]);
66         _;
67     }
68 
69 
70     // ensures that the first tokens in the contract will be equally distributed
71     // meaning, no divine dump will be ever possible
72     // result: healthy longevity.
73     modifier limitQuota(uint256 _amountOfEthereum){
74         address _customerAddress = msg.sender;
75 
76         // are we still in the vulnerable phase?
77         // if so, enact anti whale protocol
78         if((totalEthereumBalance() - _amountOfEthereum) <= quota_ ){
79             require(
80                 // does the customer purchase exceed the max quota?
81                 (accumulatedQuota_[_customerAddress] + _amountOfEthereum) <= maxPurchase_
82 
83             );
84 
85             // updated the accumulated quota
86             accumulatedQuota_[_customerAddress] = SafeMath.add(accumulatedQuota_[_customerAddress], _amountOfEthereum);
87 
88             // execute
89             _;
90         }else{
91             _;
92         }
93 
94     }
95 
96 
97     /*==============================
98     =            EVENTS            =
99     ==============================*/
100     event onTokenPurchase(
101         address indexed customerAddress,
102         uint256 incomingEthereum,
103         uint256 tokensMinted,
104         address indexed referredBy
105     );
106 
107     event onTokenSell(
108         address indexed customerAddress,
109         uint256 tokensBurned,
110         uint256 ethereumEarned
111     );
112 
113     event onReinvestment(
114         address indexed customerAddress,
115         uint256 ethereumReinvested,
116         uint256 tokensMinted
117     );
118 
119     event onWithdraw(
120         address indexed customerAddress,
121         uint256 ethereumWithdrawn
122     );
123 
124     // ERC20
125     event Transfer(
126         address indexed from,
127         address indexed to,
128         uint256 tokens
129     );
130 
131 
132     /*=====================================
133     =            CONFIGURABLES            =
134     =====================================*/
135     string public name = "ProofOfSheepM";
136     string public symbol = "POSM";
137     uint8 constant public decimals = 18;
138     uint8 constant internal dividendFee_ = 10;
139     uint8 constant internal bonusRate_ = 8;
140     uint256 constant internal tokenPriceInitial_ = 0.0000004 ether;
141     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
142     uint256 constant internal magnitude = 2**64;
143 
144     // proof of stake (defaults at 100 tokens SIKE)
145     uint256 public stakingRequirement = 0;
146 
147     // fair distribution program
148     mapping(address => bool) internal ambassadors_;
149     uint256 constant internal maxPurchase_ = 1 ether;
150     uint256 constant internal quota_ = 500 ether;
151 
152 
153 
154    /*================================
155     =            DATASETS            =
156     ================================*/
157     // amount of shares for each address (scaled number)
158     mapping(address => uint256) internal tokenBalanceLedger_;
159     mapping(address => uint256) internal referralBalance_;
160     mapping(address => int256) internal payoutsTo_;
161     mapping(address => uint256) internal accumulatedQuota_;
162     uint256 internal tokenSupply_ = 0;
163     uint256 internal profitPerShare_;
164 
165     // administrator list (see above on what they can do)
166     mapping(bytes32 => bool) public administrators;
167 
168 
169 
170     /*=======================================
171     =            PUBLIC FUNCTIONS            =
172     =======================================*/
173     /*
174     * -- APPLICATION ENTRY POINTS --
175     */
176     function ProofOfSheepM()
177         public
178     {
179         // add administrators here
180         administrators[keccak256(0x06abDaf5423Dc6828e33bcDe88a34A782C720667)] = true;
181 
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
207     /**
208      * Converts all of caller's dividends to tokens.
209      */
210     function reinvest()
211         onlyStronghands()
212         public
213     {
214         // fetch dividends
215         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
216 
217         // pay out the dividends virtually
218         address _customerAddress = msg.sender;
219         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
220 
221         // retrieve ref. bonus
222         _dividends += referralBalance_[_customerAddress];
223         referralBalance_[_customerAddress] = 0;
224 
225         // dispatch a buy order with the virtualized "withdrawn dividends"
226         uint256 _tokens = purchaseTokens(_dividends, 0x0);
227 
228         // fire event
229           onReinvestment(_customerAddress, _dividends, _tokens);
230     }
231 
232     /**
233      * Alias of sell() and withdraw().
234      */
235     function exit()
236         public
237     {
238         // get token count for caller & sell them all
239         address _customerAddress = msg.sender;
240         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
241         if(_tokens > 0) sell(_tokens);
242 
243         // lambo delivery service
244         withdraw();
245     }
246 
247     /**
248      * Withdraws all of the callers earnings.
249      */
250     function withdraw()
251         onlyStronghands()
252         public
253     {
254         // setup data
255         address _customerAddress = msg.sender;
256         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
257 
258         // update dividend tracker
259         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
260 
261         // add ref. bonus
262         _dividends += referralBalance_[_customerAddress];
263         referralBalance_[_customerAddress] = 0;
264 
265         // lambo delivery service
266         _customerAddress.transfer(_dividends);
267 
268         // fire event
269          onWithdraw(_customerAddress, _dividends);
270     }
271 
272     /**
273      * Liquifies tokens to ethereum.
274      */
275     function sell(uint256 _amountOfTokens)
276         onlyBagholders()
277         public
278     {
279         // setup data
280         address _customerAddress = msg.sender;
281         // russian hackers BTFO
282         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
283         uint256 _tokens = _amountOfTokens;
284         uint256 _ethereum = tokensToEthereum_(_tokens);
285         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
286         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
287 
288         // burn the sold tokens
289         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
290         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
291 
292         // update dividends tracker
293         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
294         payoutsTo_[_customerAddress] -= _updatedPayouts;
295 
296         // dividing by zero is a bad idea
297         if (tokenSupply_ > 0) {
298             // update the amount of dividends per token
299             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
300         }
301 
302         // fire event
303          onTokenSell(_customerAddress, _tokens, _taxedEthereum);
304     }
305 
306 
307     /**
308      * Transfer tokens from the caller to a new holder.
309      * Remember, there's a 10% fee here as well.
310      */
311     function transfer(address _toAddress, uint256 _amountOfTokens)
312         onlyBagholders()
313         public
314         returns(bool)
315     {
316         // setup
317         address _customerAddress = msg.sender;
318 
319         // withdraw all outstanding dividends first
320         if(myDividends(true) > 0) withdraw();
321 
322         // liquify 10% of the tokens that are transferred
323         // these are dispersed to shareholders
324         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
325         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
326         uint256 _dividends = tokensToEthereum_(_tokenFee);
327 
328         // burn the fee tokens
329         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
330 
331         // exchange tokens
332         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
333         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
334 
335         // update dividend trackers
336         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
337         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
338 
339         // disperse dividends among holders
340         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
341 
342         // fire event
343          Transfer(_customerAddress, _toAddress, _taxedTokens);
344 
345         // ERC20
346         return true;
347 
348     }
349 
350     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
351     /**
352      * In case the ambassador quota is not met, the administrator can manually disable the ambassador phase. (NOW OBSOLETE)
353      */
354     /*function disableInitialStage()
355         onlyAdministrator()
356         public
357     {
358         onlyAmbassadors = false;
359     }*/
360 
361     /**
362      * In case one of us dies, we need to replace ourselves.
363      */
364     function setAdministrator(bytes32 _identifier, bool _status)
365         onlyAdministrator()
366         public
367     {
368         administrators[_identifier] = _status;
369     }
370 
371     /**
372      * Precautionary measures in case we need to adjust the masternode rate. (FAT CHANCE)
373      */
374     function setStakingRequirement(uint256 _amountOfTokens)
375         onlyAdministrator()
376         public
377     {
378         stakingRequirement = _amountOfTokens;
379     }
380 
381     /**
382      * If we want to rebrand, we can.
383      */
384     function setName(string _name)
385         onlyAdministrator()
386         public
387     {
388         name = _name;
389     }
390 
391     /**
392      * If we want to rebrand, we can.
393      */
394     function setSymbol(string _symbol)
395         onlyAdministrator()
396         public
397     {
398         symbol = _symbol;
399     }
400 
401 
402     /*----------  HELPERS AND CALCULATORS  ----------*/
403     /**
404      * Method to view the current Ethereum stored in the contract
405      * Example: totalEthereumBalance()
406      */
407     function totalEthereumBalance()
408         public
409         view
410         returns(uint)
411     {
412         return address(this).balance;
413     }
414 
415     /**
416      * Retrieve the total token supply.
417      */
418     function totalSupply()
419         public
420         view
421         returns(uint256)
422     {
423         return tokenSupply_;
424     }
425 
426     /**
427      * Retrieve the tokens owned by the caller.
428      */
429     function myTokens()
430         public
431         view
432         returns(uint256)
433     {
434         address _customerAddress = msg.sender;
435         return balanceOf(_customerAddress);
436     }
437 
438     /**
439      * Retrieve the dividends owned by the caller.
440      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
441      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
442      * But in the internal calculations, we want them separate.
443      */
444     function myDividends(bool _includeReferralBonus)
445         public
446         view
447         returns(uint256)
448     {
449         address _customerAddress = msg.sender;
450         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
451     }
452 
453     /**
454      * Retrieve the token balance of any single address.
455      */
456     function balanceOf(address _customerAddress)
457         view
458         public
459         returns(uint256)
460     {
461         return tokenBalanceLedger_[_customerAddress];
462     }
463 
464     /**
465      * Retrieve the dividend balance of any single address.
466      */
467     function dividendsOf(address _customerAddress)
468         view
469         public
470         returns(uint256)
471     {
472         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
473     }
474 
475     /**
476      * Return the buy price of 1 individual token.
477      */
478     function sellPrice()
479         public
480         view
481         returns(uint256)
482     {
483         // our calculation relies on the token supply, so we need supply. Doh.
484         if(tokenSupply_ == 0){
485             return tokenPriceInitial_ - tokenPriceIncremental_;
486         } else {
487             uint256 _ethereum = tokensToEthereum_(1e18);
488             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
489             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
490             return _taxedEthereum;
491         }
492     }
493 
494     /**
495      * Return the sell price of 1 individual token.
496      */
497     function buyPrice()
498         public
499         view
500         returns(uint256)
501     {
502         // our calculation relies on the token supply, so we need supply. Doh.
503         if(tokenSupply_ == 0){
504             return tokenPriceInitial_ + tokenPriceIncremental_;
505         } else {
506             uint256 _ethereum = tokensToEthereum_(1e18);
507             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
508             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
509             return _taxedEthereum;
510         }
511     }
512 
513     /**
514      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
515      */
516     function calculateTokensReceived(uint256 _ethereumToSpend)
517         public
518         view
519         returns(uint256)
520     {
521         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
522         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
523         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
524 
525         return _amountOfTokens;
526     }
527 
528     /**
529      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
530      */
531     function calculateEthereumReceived(uint256 _tokensToSell)
532         public
533         view
534         returns(uint256)
535     {
536         require(_tokensToSell <= tokenSupply_);
537         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
538         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
539         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
540         return _taxedEthereum;
541     }
542 
543 
544     /*==========================================
545     =            INTERNAL FUNCTIONS            =
546     ==========================================*/
547     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
548         limitQuota(_incomingEthereum)
549         internal
550         returns(uint256)
551     {
552         // data setup
553         address _customerAddress = msg.sender;
554         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
555         uint256 _referralBonus = SafeMath.div(_undividedDividends, bonusRate_);
556         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
557         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
558         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
559         uint256 _fee = _dividends * magnitude;
560 
561         // prevents overflow in the case POSM somehow magically starts being used by everyone in the world
562         // (or hackers)
563         // and yes we know that the safemath function automatically rules out the "greater then" equation.
564         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
565 
566         // is the user referred by a masternode?
567         if(
568             // is this a referred purchase?
569             _referredBy != 0x0000000000000000000000000000000000000000 &&
570 
571             // no cheating!
572             _referredBy != _customerAddress &&
573 
574             // does the referrer have at least X whole tokens?
575             // i.e is the referrer a godly chad masternode
576             tokenBalanceLedger_[_referredBy] >= stakingRequirement
577         ){
578             // wealth redistribution
579             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
580         } else {
581             // no ref purchase
582             // add the referral bonus back to the global dividends cake
583             _dividends = SafeMath.add(_dividends, _referralBonus);
584             _fee = _dividends * magnitude;
585         }
586 
587         // we can't give people infinite ethereum
588         if(tokenSupply_ > 0){
589 
590             // add tokens to the pool
591             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
592 
593             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
594             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
595 
596             // calculate the amount of tokens the customer receives over his purchase
597             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
598 
599         } else {
600             // add tokens to the pool
601             tokenSupply_ = _amountOfTokens;
602         }
603 
604         // update circulating supply & the ledger address for the customer
605         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
606 
607         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
608         //really i know you think you do but you don't
609         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
610         payoutsTo_[_customerAddress] += _updatedPayouts;
611 
612         // fire event
613          onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
614 
615         return _amountOfTokens;
616     }
617 
618     /**
619      * Calculate Token price based on an amount of incoming ethereum
620      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
621      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
622      */
623     function ethereumToTokens_(uint256 _ethereum)
624         internal
625         view
626         returns(uint256)
627     {
628         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
629         uint256 _tokensReceived =
630          (
631             (
632                 // underflow attempts BTFO
633                 SafeMath.sub(
634                     (sqrt
635                         (
636                             (_tokenPriceInitial**2)
637                             +
638                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
639                             +
640                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
641                             +
642                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
643                         )
644                     ), _tokenPriceInitial
645                 )
646             )/(tokenPriceIncremental_)
647         )-(tokenSupply_)
648         ;
649 
650         return _tokensReceived;
651     }
652 
653     /**
654      * Calculate token sell value.
655      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
656      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
657      */
658      function tokensToEthereum_(uint256 _tokens)
659         internal
660         view
661         returns(uint256)
662     {
663 
664         uint256 tokens_ = (_tokens + 1e18);
665         uint256 _tokenSupply = (tokenSupply_ + 1e18);
666         uint256 _etherReceived =
667         (
668             // underflow attempts BTFO
669             SafeMath.sub(
670                 (
671                     (
672                         (
673                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
674                         )-tokenPriceIncremental_
675                     )*(tokens_ - 1e18)
676                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
677             )
678         /1e18);
679         return _etherReceived;
680     }
681 
682 
683     //This is where all your gas goes, sorry
684     //Not sorry, you probably only paid 1 gwei
685     function sqrt(uint x) internal pure returns (uint y) {
686         uint z = (x + 1) / 2;
687         y = x;
688         while (z < y) {
689             y = z;
690             z = (x / z + z) / 2;
691         }
692     }
693 }
694 
695 /**
696  * @title SafeMath
697  * @dev Math operations with safety checks that throw on error
698  */
699 library SafeMath {
700 
701     /**
702     * @dev Multiplies two numbers, throws on overflow.
703     */
704     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
705         if (a == 0) {
706             return 0;
707         }
708         uint256 c = a * b;
709         assert(c / a == b);
710         return c;
711     }
712 
713     /**
714     * @dev Integer division of two numbers, truncating the quotient.
715     */
716     function div(uint256 a, uint256 b) internal pure returns (uint256) {
717         // assert(b > 0); // Solidity automatically throws when dividing by 0
718         uint256 c = a / b;
719         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
720         return c;
721     }
722 
723     /**
724     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
725     */
726     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
727         assert(b <= a);
728         return a - b;
729     }
730 
731     /**
732     * @dev Adds two numbers, throws on overflow.
733     */
734     function add(uint256 a, uint256 b) internal pure returns (uint256) {
735         uint256 c = a + b;
736         assert(c >= a);
737         return c;
738     }
739 }