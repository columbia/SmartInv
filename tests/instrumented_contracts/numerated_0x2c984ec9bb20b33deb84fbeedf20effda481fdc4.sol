1 pragma solidity ^0.4.20;
2 
3 /*
4 * -> What?
5 * The original autonomous pyramid, improved:
6 * [x] More stable than ever, having withstood severe testnet abuse and attack attempts from our community!.
7 * [x] Audited, tested, and approved by known community security specialists such as tocsick and Arc.
8 * [X] New functionality; you can now perform partial sell orders. If you succumb to weak hands, you don't have to dump all of your bags!
9 * [x] New functionality; you can now transfer tokens between wallets. Trading is now possible from within the contract!
10 * [x] New Feature: PoS Masternodes! The first implementation of Ethereum Staking in the world! Vitalik is mad.
11 * [x] Masternodes: Holding 100 ETC Tokens allow you to generate a Masternode link, Masternode links are used as unique entry points to the contract!
12 * [x] Masternodes: All players who enter the contract through your Masternode have 30% of their 10% dividends fee rerouted from the master-node, to the node-master!
13 *
14 * -> What about the last projects?
15 * Every programming member of the old dev team has been fired and/or killed by 232.
16 * The new dev team consists of seasoned, professional developers and has been audited by veteran solidity experts.
17 * Additionally, two independent testnet iterations have been used by hundreds of people; not a single point of failure was found.
18 *
19 * -> Who worked on this project?
20 * - PonziBot (math/memes/main site/master)
21 * - Mantso (lead solidity dev/lead web3 dev)
22 * - swagg (concept design/feedback/management)
23 * - Anonymous#1 (main site/web3/test cases)
24 * - Anonymous#2 (math formulae/whitepaper)
25 *
26 * -> Who has audited & approved the projected:
27 * - Arc
28 * - tocisck
29 * - sumpunk
30 */
31 
32 contract Ethershares {
33     /*=================================
34     =            MODIFIERS            =
35     =================================*/
36     // only people with tokens
37     modifier onlyBagholders() {
38         require(myTokens() > 0);
39         _;
40     }
41 
42     // only people with profits
43     modifier onlyStronghands() {
44         require(myDividends(true) > 0);
45         _;
46     }
47 
48     // administrators can:
49     // -> change the name of the contract
50     // -> change the name of the token
51     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
52     // they CANNOT:
53     // -> take funds
54     // -> disable withdrawals
55     // -> kill the contract
56     // -> change the price of tokens
57     modifier onlyAdministrator(){
58         address _customerAddress = msg.sender;
59         require(administrators[_customerAddress]);
60         _;
61     }
62 
63 
64     // ensures that the first tokens in the contract will be equally distributed
65     // meaning, no divine dump will be ever possible
66     // result: healthy longevity.
67     modifier antiEarlyWhale(uint256 _amountOfEthereum){
68         address _customerAddress = msg.sender;
69 
70         // are we still in the vulnerable phase?
71         // if so, enact anti early whale protocol
72         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
73             require(
74                 // is the customer in the ambassador list?
75                 ambassadors_[_customerAddress] == true &&
76 
77                 // does the customer purchase exceed the max ambassador quota?
78                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
79 
80             );
81 
82             // updated the accumulated quota
83             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
84 
85             // execute
86             _;
87         } else {
88             // in case the ether count drops low, the ambassador phase won't reinitiate
89             onlyAmbassadors = false;
90             _;
91         }
92 
93     }
94 
95 
96     /*==============================
97     =            EVENTS            =
98     ==============================*/
99     event onTokenPurchase(
100         address indexed customerAddress,
101         uint256 incomingEthereum,
102         uint256 tokensMinted,
103         address indexed referredBy
104     );
105 
106     event onTokenSell(
107         address indexed customerAddress,
108         uint256 tokensBurned,
109         uint256 ethereumEarned
110     );
111 
112     event onReinvestment(
113         address indexed customerAddress,
114         uint256 ethereumReinvested,
115         uint256 tokensMinted
116     );
117 
118     event onWithdraw(
119         address indexed customerAddress,
120         uint256 ethereumWithdrawn
121     );
122 
123     // ERC20
124     event Transfer(
125         address indexed from,
126         address indexed to,
127         uint256 tokens
128     );
129 
130 
131     /*=====================================
132     =            CONFIGURABLES            =
133     =====================================*/
134     string public name = "Ethershares";
135     uint8 constant public decimals = 18;
136     string public symbol = "ETS";
137     uint8 constant internal dividendFee_ = 5; // Look, strong Math
138     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
139     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
140     uint256 constant internal magnitude = 2**64;
141 
142     // proof of stake (defaults at 100 tokens)
143     uint256 public stakingRequirement = 100e18;
144 
145     // ambassador program
146     mapping(address => bool) internal ambassadors_;
147     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
148     uint256 constant internal ambassadorQuota_ = 20 ether;
149 
150 
151 
152    /*================================
153     =            DATASETS            =
154     ================================*/
155     // amount of shares for each address (scaled number)
156     mapping(address => uint256) internal tokenBalanceLedger_;
157     mapping(address => uint256) internal referralBalance_;
158     mapping(address => int256) internal payoutsTo_;
159     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
160     uint256 internal tokenSupply_ = 0;
161     uint256 internal profitPerShare_;
162 
163     // administrator list (see above on what they can do)
164     mapping(address => bool) public administrators;
165     address public owner;
166 
167     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
168     bool public onlyAmbassadors = true;
169 
170 
171 
172     /*=======================================
173     =            PUBLIC FUNCTIONS            =
174     =======================================*/
175     /*
176     * -- APPLICATION ENTRY POINTS --
177     */
178     function Ethershares()
179         public
180     {
181 
182         owner = 0x3A6C7d94565C9c95966bE4740AdcbbFC5526D556;
183 
184         administrators[0x3A6C7d94565C9c95966bE4740AdcbbFC5526D556] = true;
185 
186         ambassadors_[0x86c7003a6b20130C03b77A6dc833d993feB71e7d] = true;
187         ambassadors_[0x24692EB3567065BC9b74C75261fb50F5b6d4eaeE] = true;
188         ambassadors_[0xB1D2FefA6073C9ED692047855B7b9ccEcd332Be2] = true;
189         ambassadors_[0x68F019c43047877a713834c84f0043072A1e508e] = true;
190         ambassadors_[0x5327633f19BacdaDdd9675d9A805C7F8496d6298] = true;
191 
192     }
193 
194 
195     /**
196      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
197      */
198     function buy(address _referredBy)
199         public
200         payable
201         returns(uint256)
202     {
203         purchaseTokens(msg.value, _referredBy);
204     }
205 
206     /**
207      * Fallback function to handle ethereum that was send straight to the contract
208      * Unfortunately we cannot use a referral address this way.
209      */
210     function()
211         payable
212         public
213     {
214         purchaseTokens(msg.value, 0x0);
215     }
216 
217     /**
218      * Converts all of caller's dividends to tokens.
219     */
220     function reinvest()
221         onlyStronghands()
222         public
223     {
224         // fetch dividends
225         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
226 
227         // pay out the dividends virtually
228         address _customerAddress = msg.sender;
229         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
230 
231         // retrieve ref. bonus
232         _dividends += referralBalance_[_customerAddress];
233         referralBalance_[_customerAddress] = 0;
234 
235         // dispatch a buy order with the virtualized "withdrawn dividends"
236         uint256 _tokens = purchaseTokens(_dividends, 0x0);
237 
238         // fire event
239         onReinvestment(_customerAddress, _dividends, _tokens);
240     }
241 
242     /**
243      * Alias of sell() and withdraw().
244      */
245     function exit()
246         public
247     {
248         // get token count for caller & sell them all
249         address _customerAddress = msg.sender;
250         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
251         if(_tokens > 0) sell(_tokens);
252 
253         // lambo delivery service
254         withdraw();
255     }
256 
257     /**
258      * Withdraws all of the callers earnings.
259      */
260     function withdraw()
261         onlyStronghands()
262         public
263     {
264         // setup data
265         address _customerAddress = msg.sender;
266         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
267 
268         // update dividend tracker
269         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
270 
271         // add ref. bonus
272         _dividends += referralBalance_[_customerAddress];
273         referralBalance_[_customerAddress] = 0;
274 
275         // lambo delivery service
276         _customerAddress.transfer(_dividends);
277 
278         // fire event
279         onWithdraw(_customerAddress, _dividends);
280     }
281 
282     /**
283      * Liquifies tokens to ethereum.
284      */
285     function sell(uint256 _amountOfTokens)
286         onlyBagholders()
287         public
288     {
289         // setup data
290         address _customerAddress = msg.sender;
291         // russian hackers BTFO
292         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
293         uint256 _tokens = _amountOfTokens;
294         uint256 _ethereum = tokensToEthereum_(_tokens);
295         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
296         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
297 
298         // burn the sold tokens
299         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
300         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
301 
302         // update dividends tracker
303         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
304         payoutsTo_[_customerAddress] -= _updatedPayouts;
305 
306         // dividing by zero is a bad idea
307         if (tokenSupply_ > 0) {
308             // update the amount of dividends per token
309             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
310         }
311 
312         // fire event
313         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
314     }
315 
316 
317     /**
318      * Transfer tokens from the caller to a new holder.
319      * Remember, there's a 10% fee here as well.
320      */
321     function transfer(address _toAddress, uint256 _amountOfTokens)
322         onlyBagholders()
323         public
324         returns(bool)
325     {
326         // setup
327         address _customerAddress = msg.sender;
328 
329         // make sure we have the requested tokens
330         // also disables transfers until ambassador phase is over
331         // ( we dont want whale premines )
332         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
333 
334         // withdraw all outstanding dividends first
335         if(myDividends(true) > 0) withdraw();
336 
337         // liquify 10% of the tokens that are transfered
338         // these are dispersed to shareholders
339         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
340         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
341         uint256 _dividends = tokensToEthereum_(_tokenFee);
342 
343         // burn the fee tokens
344         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
345 
346         // exchange tokens
347         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
348         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
349 
350         // update dividend trackers
351         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
352         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
353 
354         // disperse dividends among holders
355         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
356 
357         // fire event
358         Transfer(_customerAddress, _toAddress, _taxedTokens);
359 
360         // ERC20
361         return true;
362 
363     }
364 
365     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
366     /**
367      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
368      */
369     function disableInitialStage()
370         onlyAdministrator()
371         public
372     {
373         onlyAmbassadors = false;
374     }
375 
376     /**
377      * In case one of us dies, we need to replace ourselves.
378      */
379     function setAdministrator(address _identifier, bool _status)
380         onlyAdministrator()
381         public
382     {
383         administrators[_identifier] = _status;
384     }
385 
386     /**
387      * Precautionary measures in case we need to adjust the masternode rate.
388      */
389     function setStakingRequirement(uint256 _amountOfTokens)
390         onlyAdministrator()
391         public
392     {
393         stakingRequirement = _amountOfTokens;
394     }
395 
396     /**
397      * If we want to rebrand, we can.
398      */
399     function setName(string _name)
400         onlyAdministrator()
401         public
402     {
403         name = _name;
404     }
405 
406     /**
407      * If we want to rebrand, we can.
408      */
409     function setSymbol(string _symbol)
410         onlyAdministrator()
411         public
412     {
413         symbol = _symbol;
414     }
415 
416 
417     /*----------  HELPERS AND CALCULATORS  ----------*/
418     /**
419      * Method to view the current Ethereum stored in the contract
420      * Example: totalEthereumBalance()
421      */
422     function totalEthereumBalance()
423         public
424         view
425         returns(uint)
426     {
427         return this.balance;
428     }
429 
430     /**
431      * Retrieve the total token supply.
432      */
433     function totalSupply()
434         public
435         view
436         returns(uint256)
437     {
438         return tokenSupply_;
439     }
440 
441     /**
442      * Retrieve the tokens owned by the caller.
443      */
444     function myTokens()
445         public
446         view
447         returns(uint256)
448     {
449         address _customerAddress = msg.sender;
450         return balanceOf(_customerAddress);
451     }
452 
453     /**
454      * Retrieve the dividends owned by the caller.
455      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
456      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
457      * But in the internal calculations, we want them separate.
458      */
459     function myDividends(bool _includeReferralBonus)
460         public
461         view
462         returns(uint256)
463     {
464         address _customerAddress = msg.sender;
465         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
466     }
467 
468     /**
469      * Retrieve the token balance of any single address.
470      */
471     function balanceOf(address _customerAddress)
472         view
473         public
474         returns(uint256)
475     {
476         return tokenBalanceLedger_[_customerAddress];
477     }
478 
479     /**
480      * Retrieve the dividend balance of any single address.
481      */
482     function dividendsOf(address _customerAddress)
483         view
484         public
485         returns(uint256)
486     {
487         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
488     }
489 
490     /**
491      * Return the buy price of 1 individual token.
492      */
493     function sellPrice()
494         public
495         view
496         returns(uint256)
497     {
498         // our calculation relies on the token supply, so we need supply. Doh.
499         if(tokenSupply_ == 0){
500             return tokenPriceInitial_ - tokenPriceIncremental_;
501         } else {
502             uint256 _ethereum = tokensToEthereum_(1e18);
503             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
504             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
505             return _taxedEthereum;
506         }
507     }
508 
509     /**
510      * Return the sell price of 1 individual token.
511      */
512     function buyPrice()
513         public
514         view
515         returns(uint256)
516     {
517         // our calculation relies on the token supply, so we need supply. Doh.
518         if(tokenSupply_ == 0){
519             return tokenPriceInitial_ + tokenPriceIncremental_;
520         } else {
521             uint256 _ethereum = tokensToEthereum_(1e18);
522             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
523             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
524             return _taxedEthereum;
525         }
526     }
527 
528     /**
529      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
530      */
531     function calculateTokensReceived(uint256 _ethereumToSpend)
532         public
533         view
534         returns(uint256)
535     {
536         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
537         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
538         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
539 
540         return _amountOfTokens;
541     }
542 
543     /**
544      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
545      */
546     function calculateEthereumReceived(uint256 _tokensToSell)
547         public
548         view
549         returns(uint256)
550     {
551         require(_tokensToSell <= tokenSupply_);
552         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
553         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
554         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
555         return _taxedEthereum;
556     }
557 
558 
559     /*==========================================
560     =            INTERNAL FUNCTIONS            =
561     ==========================================*/
562     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
563         antiEarlyWhale(_incomingEthereum)
564         internal
565         returns(uint256)
566     {
567         // data setup
568         address _customerAddress = msg.sender;
569         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
570         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
571         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
572         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
573         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
574         uint256 _fee = _dividends * magnitude;
575 
576         // no point in continuing execution if OP is a poorfag russian hacker
577         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
578         // (or hackers)
579         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
580         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
581 
582         // is the user referred by a masternode?
583         if(
584             // is this a referred purchase?
585             _referredBy != 0x0000000000000000000000000000000000000000 &&
586 
587             // no cheating!
588             _referredBy != _customerAddress &&
589 
590             // does the referrer have at least X whole tokens?
591             // i.e is the referrer a godly chad masternode
592             tokenBalanceLedger_[_referredBy] >= stakingRequirement
593         ){
594             // wealth redistribution
595             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
596         } else {
597             // no ref purchase
598             // add the referral bonus back to the global dividends cake
599             _dividends = SafeMath.add(_dividends, _referralBonus);
600             _fee = _dividends * magnitude;
601         }
602 
603         // we can't give people infinite ethereum
604         if(tokenSupply_ > 0){
605 
606             // add tokens to the pool
607             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
608 
609             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
610             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
611 
612             // calculate the amount of tokens the customer receives over his purchase
613             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
614 
615         } else {
616             // add tokens to the pool
617             tokenSupply_ = _amountOfTokens;
618         }
619 
620         // update circulating supply & the ledger address for the customer
621         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
622 
623         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
624         //really i know you think you do but you don't
625         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
626         payoutsTo_[_customerAddress] += _updatedPayouts;
627 
628         // fire event
629         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
630 
631         return _amountOfTokens;
632     }
633 
634     /**
635      * Calculate Token price based on an amount of incoming ethereum
636      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
637      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
638      */
639     function ethereumToTokens_(uint256 _ethereum)
640         internal
641         view
642         returns(uint256)
643     {
644         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
645         uint256 _tokensReceived =
646          (
647             (
648                 // underflow attempts BTFO
649                 SafeMath.sub(
650                     (sqrt
651                         (
652                             (_tokenPriceInitial**2)
653                             +
654                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
655                             +
656                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
657                             +
658                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
659                         )
660                     ), _tokenPriceInitial
661                 )
662             )/(tokenPriceIncremental_)
663         )-(tokenSupply_)
664         ;
665 
666         return _tokensReceived;
667     }
668 
669     /**
670      * Calculate token sell value.
671      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
672      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
673      */
674      function tokensToEthereum_(uint256 _tokens)
675         internal
676         view
677         returns(uint256)
678     {
679 
680         uint256 tokens_ = (_tokens + 1e18);
681         uint256 _tokenSupply = (tokenSupply_ + 1e18);
682         uint256 _etherReceived =
683         (
684             // underflow attempts BTFO
685             SafeMath.sub(
686                 (
687                     (
688                         (
689                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
690                         )-tokenPriceIncremental_
691                     )*(tokens_ - 1e18)
692                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
693             )
694         /1e18);
695         return _etherReceived;
696     }
697 
698 
699     //This is where all your gas goes, sorry
700     //Not sorry, you probably only paid 1 gwei
701     function sqrt(uint x) internal pure returns (uint y) {
702         uint z = (x + 1) / 2;
703         y = x;
704         while (z < y) {
705             y = z;
706             z = (x / z + z) / 2;
707         }
708     }
709 }
710 
711 /**
712  * @title SafeMath
713  * @dev Math operations with safety checks that throw on error
714  */
715 library SafeMath {
716 
717     /**
718     * @dev Multiplies two numbers, throws on overflow.
719     */
720     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
721         if (a == 0) {
722             return 0;
723         }
724         uint256 c = a * b;
725         assert(c / a == b);
726         return c;
727     }
728 
729     /**
730     * @dev Integer division of two numbers, truncating the quotient.
731     */
732     function div(uint256 a, uint256 b) internal pure returns (uint256) {
733         // assert(b > 0); // Solidity automatically throws when dividing by 0
734         uint256 c = a / b;
735         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
736         return c;
737     }
738 
739     /**
740     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
741     */
742     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
743         assert(b <= a);
744         return a - b;
745     }
746 
747     /**
748     * @dev Adds two numbers, throws on overflow.
749     */
750     function add(uint256 a, uint256 b) internal pure returns (uint256) {
751         uint256 c = a + b;
752         assert(c >= a);
753         return c;
754     }
755 }