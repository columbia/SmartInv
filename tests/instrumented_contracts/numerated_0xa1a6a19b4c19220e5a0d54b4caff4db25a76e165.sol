1 pragma solidity ^0.4.19;
2 
3 /*
4  _____   ___   _   _ _   _ _   _ ___________ _
5 /  __ \ / _ \ | \ | | | | | | | |  _  |  _  \ |
6 | /  \// /_\ \|  \| | | | | |_| | | | | | | | |
7 | |    |  _  || . ` | | | |  _  | | | | | | | |
8 | \__/\| | | || |\  | |_| | | | \ \_/ / |/ /| |____
9  \____/\_| |_/\_| \_/\___/\_| |_/\___/|___/ \_____/
10 ==================================================
11 * [x] An autonomous A.I controlled speculation game developed on the Ethereum blockchain
12 * [x] Fully autonomous entity with ZERO human control - no exit scams, no shutting the system down
13 
14 * [x] Secure tried and tested smart contract
15 * [x] Anti-whaling protocol implemented by devs
16 * [x] Full transparency from the get go:
17 * [x] CANUHODL takes 11% from any transaction (BUY | SELL | TRANSFER) and redistributes it across all CANU shareholders,
18 based on how much stake you hold.
19 * [x] These dividends can be cashed out immediately into ETH or reinvested into the system for more gains
20 * [x] As each token is purchased the price of the coin goes up incrementally from its' starting price.
21 Additionally, as each token is sold, the price of the token goes down incrementally.
22 * [x] Masternodes: Holding 25 CANUHODL Tokens allow you to generate a Masternode link, Masternode links are used as unique entry points to the contract!
23 All players who enter the contract through your Masternode have 30% of their 11% dividends fee rerouted from the master-node, to the node-master!
24 * [x] Backup site to buy and sell tokens incase we get overrun by traffic
25 Do you have what it takes to HODL all the way to the top, earning instant ETH dividends for every token you hold?
26 CANUHODL?
27 ---------
28 
29 RECOGNITIONS
30 ============
31 - Ponzibot for introducing the world to A.I smart contract experiments
32 - POWH3D for taking the idea to the next level and some very funny shilling
33 - YOU the players and together we will have fun and build a great community!!
34 
35 DEVS
36 ====
37 - <AI>Pete
38 - <AI>John
39 - ChalkBwoy8
40 */
41 
42 contract CANUHODL {
43     /*=================================
44     =            MODIFIERS            =
45     =================================*/
46     // only people with tokens
47     modifier onlyBagholders() {
48         require(myTokens() > 0);
49         _;
50     }
51 
52     // only people with profits
53     modifier onlyStronghands() {
54         require(myDividends(true) > 0);
55         _;
56     }
57 
58     // administrators can:
59     // -> change the name of the contract
60     // -> change the name of the token
61     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
62     // they CANNOT:
63     // -> take funds
64     // -> disable withdrawals
65     // -> kill the contract
66     // -> change the price of tokens
67     modifier onlyAdministrator(){
68         address _customerAddress = msg.sender;
69         require(administrators[keccak256(_customerAddress)]);
70         _;
71     }
72 
73 
74     // ensures that the first tokens in the contract will be equally distributed
75     // meaning, no divine dump will be ever possible
76     // result: healthy longevity.
77     modifier antiEarlyWhale(uint256 _amountOfEthereum){
78         address _customerAddress = msg.sender;
79 
80         // are we still in the vulnerable phase?
81         // if so, enact anti early whale protocol
82         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
83             require(
84                 // is the customer in the ambassador list?
85                 ambassadors_[_customerAddress] == true &&
86 
87                 // does the customer purchase exceed the max ambassador quota?
88                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
89 
90             );
91 
92             // updated the accumulated quota
93             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
94 
95             // execute
96             _;
97         } else {
98             // in case the ether count drops low, the ambassador phase won't reinitiate
99             onlyAmbassadors = false;
100             _;
101         }
102 
103     }
104 
105 
106     /*==============================
107     =            EVENTS            =
108     ==============================*/
109     event onTokenPurchase(
110         address indexed customerAddress,
111         uint256 incomingEthereum,
112         uint256 tokensMinted,
113         address indexed referredBy
114     );
115 
116     event onTokenSell(
117         address indexed customerAddress,
118         uint256 tokensBurned,
119         uint256 ethereumEarned
120     );
121 
122     event onReinvestment(
123         address indexed customerAddress,
124         uint256 ethereumReinvested,
125         uint256 tokensMinted
126     );
127 
128     event onWithdraw(
129         address indexed customerAddress,
130         uint256 ethereumWithdrawn
131     );
132 
133     // ERC20
134     event Transfer(
135         address indexed from,
136         address indexed to,
137         uint256 tokens
138     );
139 
140 
141     /*=====================================
142     =            CONFIGURABLES            =
143     =====================================*/
144     string public name = "CANUHODL";
145     string public symbol = "CANU";
146     uint8 constant public decimals = 18;
147     uint8 constant internal percentageFee = 11;
148     uint8 constant internal transferFee = 1; //1%
149     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
150     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
151     uint256 constant internal magnitude = 2**64;
152 
153     // proof of stake (defaults at 25 tokens)
154     uint256 public stakingRequirement = 25e18;
155 
156     // ambassador program
157     mapping(address => bool) internal ambassadors_;
158     uint256 constant internal ambassadorMaxPurchase_ = 2 ether;
159     uint256 constant internal ambassadorQuota_ = 20 ether;
160 
161    /*================================
162     =            DATASETS            =
163     ================================*/
164     // amount of shares for each address (scaled number)
165     mapping(address => uint256) internal tokenBalanceLedger_;
166     mapping(address => uint256) internal referralBalance_;
167     mapping(address => int256) internal payoutsTo_;
168     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
169     uint256 private tokenSupply_ = 0;
170     uint256 private profitPerShare_;
171 
172     // administrator list (see above on what they can do)
173     mapping(bytes32 => bool) public administrators;
174 
175     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
176     bool public onlyAmbassadors = true;
177 
178     /*=======================================
179     =            PUBLIC FUNCTIONS            =
180     =======================================*/
181     /*
182     * -- APPLICATION ENTRY POINTS --
183     */
184     constructor ()
185         public
186     {
187          administrators[keccak256(0xf43BE860B464598E8BB6e758dd2fE0D050ADb9BB)] = true;
188          administrators[keccak256(0x5D96ba0A9c70ee4503aAe88B4250643Ae52A9BAc)] = true;
189 
190          // add administrators here
191          administrators[keccak256(0x31F67FE4737CFDd04C422c42a5C3561474ee2FcA)] = true;
192          // add the ambassadors here.
193          ambassadors_[0xB5869587CA6E239345f75C28d3b8Ee23da812759] = true; // ETG2
194          ambassadors_[0x371785006AaE1CBf32Fa17339D063Bc25742D43F] = true; // ETG3
195          ambassadors_[0x9253DbCAa3b1e158e2aB71316DeCE57fde3c06Fe] = true; // ETG4
196          // ZLOADR  - AMBASSADOR   10ETH
197          ambassadors_[0x6a3fa00bbdc4669c193a5445e7255e905e386ac3] = true; // ETG5
198     }
199 
200 
201     /**
202      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
203      */
204     function buy(address _referredBy)
205         public
206         payable
207         returns(uint256)
208     {
209         purchaseTokens(msg.value, _referredBy);
210     }
211 
212     /**
213      * Fallback function to handle ethereum that was send straight to the contract
214      * Unfortunately we cannot use a referral address this way.
215      */
216     function()
217         payable
218         public
219     {
220         purchaseTokens(msg.value, 0x0);
221     }
222 
223     /**
224      * Converts all of caller's dividends to tokens.
225      */
226     function reinvest()
227         onlyStronghands()
228         public
229     {
230         // fetch dividends
231         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
232 
233         // pay out the dividends virtually
234         address _customerAddress = msg.sender;
235         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
236 
237         // retrieve ref. bonus
238         _dividends += referralBalance_[_customerAddress];
239         referralBalance_[_customerAddress] = 0;
240 
241         // dispatch a buy order with the virtualized "withdrawn dividends"
242         uint256 _tokens = purchaseTokens(_dividends, 0x0);
243 
244         // fire event
245         emit onReinvestment(_customerAddress, _dividends, _tokens);
246     }
247 
248     /**
249      * Alias of sell() and withdraw().
250      */
251     function exit()
252         public
253     {
254         // get token count for caller & sell them all
255         address _customerAddress = msg.sender;
256         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
257         if(_tokens > 0) sell(_tokens);
258 
259         // lambo delivery service
260         withdraw();
261     }
262 
263     /**
264      * Withdraws all of the callers earnings.
265      */
266      function withdraw()
267          onlyStronghands()
268          public
269      {
270          // setup data
271          address _customerAddress = msg.sender;
272          uint256 _dividends = myDividends(false); // get ref. bonus later in the code
273 
274          // update dividend tracker
275          payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
276 
277          // add ref. bonus
278          _dividends += referralBalance_[_customerAddress];
279          referralBalance_[_customerAddress] = 0;
280 
281          // lambo delivery service
282          _customerAddress.transfer(_dividends);
283 
284          // fire event
285          emit onWithdraw(_customerAddress, _dividends);
286      }
287 
288      /**
289       * Liquifies tokens to ethereum.
290       */
291      function sell(uint256 _amountOfTokens)
292          onlyBagholders()
293          public
294      {
295          // setup data
296          address _customerAddress = msg.sender;
297          // russian hackers BTFO
298          require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
299          uint256 _tokens = _amountOfTokens;
300          uint256 _ethereum = tokensToEthereum_(_tokens);
301          uint256 _dividends = getDividends(percentageFee, _ethereum);
302          uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
303 
304          // burn the sold tokens
305          tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
306          tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
307 
308          // update dividends tracker
309          int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
310          payoutsTo_[_customerAddress] -= _updatedPayouts;
311 
312          // dividing by zero is a bad idea
313          if (tokenSupply_ > 0) {
314              // update the amount of dividends per token
315              profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
316          }
317 
318          // fire event
319          emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
320      }
321 
322 
323     /**
324      * Transfer tokens from the caller to a new holder.
325      * Remember, there's a 1% fee here as well.
326      */
327     function transfer(address _toAddress, uint256 _amountOfTokens)
328         onlyBagholders()
329         public
330         returns(bool)
331     {
332         // setup
333         address _customerAddress = msg.sender;
334 
335         // make sure we have the requested tokens
336         // also disables transfers until ambassador phase is over
337         // ( we dont want whale premines )
338         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
339 
340         // withdraw all outstanding dividends first
341         if(myDividends(true) > 0) withdraw();
342 
343         // liquify 1% of the tokens that are transfered
344         // these are dispersed to shareholders
345         uint256 _tokenFee = getDividends(transferFee, _amountOfTokens);
346         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
347         uint256 _dividends = tokensToEthereum_(_tokenFee);
348 
349         // burn the fee tokens
350         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
351 
352         // exchange tokens
353         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
354         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
355 
356         // update dividend trackers
357         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
358         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
359 
360         // disperse dividends among holders
361         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
362 
363         // fire event
364         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
365 
366         // ERC20
367         return true;
368 
369     }
370 
371     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
372     /**
373      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
374      */
375     function disableInitialStage()
376         onlyAdministrator()
377         public
378     {
379         onlyAmbassadors = false;
380     }
381 
382     /**
383      * In case one of us dies, we need to replace ourselves.
384      */
385     function setAdministrator(bytes32 _identifier, bool _status)
386         onlyAdministrator()
387         public
388     {
389         administrators[_identifier] = _status;
390     }
391 
392     /**
393      * Precautionary measures in case we need to adjust the masternode rate.
394      */
395     function setStakingRequirement(uint256 _amountOfTokens)
396         onlyAdministrator()
397         public
398     {
399         stakingRequirement = _amountOfTokens;
400     }
401 
402     /**
403      * If we want to rebrand, we can.
404      */
405     function setName(string _name)
406         onlyAdministrator()
407         public
408     {
409         name = _name;
410     }
411 
412     /**
413      * If we want to rebrand, we can.
414      */
415     function setSymbol(string _symbol)
416         onlyAdministrator()
417         public
418     {
419         symbol = _symbol;
420     }
421 
422 
423     /*----------  HELPERS AND CALCULATORS  ----------*/
424     /**
425      * Method to view the current Ethereum stored in the contract
426      * Example: totalEthereumBalance()
427      */
428     function totalEthereumBalance()
429         public
430         view
431         returns(uint)
432     {
433         return address(this).balance;
434     }
435 
436     /**
437      * Retrieve the total token supply.
438      */
439     function totalSupply()
440         public
441         view
442         returns(uint256)
443     {
444         return tokenSupply_;
445     }
446 
447     /**
448      * Retrieve the tokens owned by the caller.
449      */
450     function myTokens()
451         public
452         view
453         returns(uint256)
454     {
455         address _customerAddress = msg.sender;
456         return balanceOf(_customerAddress);
457     }
458 
459     /**
460      * Retrieve the dividends owned by the caller.
461      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
462      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
463      * But in the internal calculations, we want them separate.
464      */
465     function myDividends(bool _includeReferralBonus)
466         public
467         view
468         returns(uint256)
469     {
470         address _customerAddress = msg.sender;
471         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
472     }
473 
474     /**
475      * Retrieve the token balance of any single address.
476      */
477     function balanceOf(address _customerAddress)
478         view
479         public
480         returns(uint256)
481     {
482         return tokenBalanceLedger_[_customerAddress];
483     }
484 
485     /**
486      * Retrieve the dividend balance of any single address.
487      */
488     function dividendsOf(address _customerAddress)
489         view
490         public
491         returns(uint256)
492     {
493         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
494     }
495 
496     /**
497      * Return the buy price of 1 individual token.
498      */
499     function sellPrice()
500         public
501         view
502         returns(uint256)
503     {
504         // our calculation relies on the token supply, so we need supply. Doh.
505         if(tokenSupply_ == 0){
506             return tokenPriceInitial_ - tokenPriceIncremental_;
507         } else {
508             uint256 _ethereum = tokensToEthereum_(1e18);
509             uint256 _dividends = getDividends(percentageFee, _ethereum);
510             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
511             return _taxedEthereum;
512         }
513     }
514 
515     /**
516      * Return the sell price of 1 individual token.
517      */
518     function buyPrice()
519         public
520         view
521         returns(uint256)
522     {
523         // our calculation relies on the token supply, so we need supply. Doh.
524         if(tokenSupply_ == 0){
525             return tokenPriceInitial_ + tokenPriceIncremental_;
526         } else {
527             uint256 _ethereum = tokensToEthereum_(1e18);
528             uint256 _dividends = getDividends(percentageFee, _ethereum);
529             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
530             return _taxedEthereum;
531         }
532     }
533 
534     /**
535      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
536      */
537     function calculateTokensReceived(uint256 _ethereumToSpend)
538         public
539         view
540         returns(uint256)
541     {
542         uint256 _dividends = getDividends(percentageFee, _ethereumToSpend);
543         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
544         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
545 
546         return _amountOfTokens;
547     }
548 
549     /**
550      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
551      */
552     function calculateEthereumReceived(uint256 _tokensToSell)
553         public
554         view
555         returns(uint256)
556     {
557         require(_tokensToSell <= tokenSupply_);
558         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
559         uint256 _dividends = getDividends(percentageFee, _ethereum);
560         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
561         return _taxedEthereum;
562     }
563 
564 
565     /*==========================================
566     =            INTERNAL FUNCTIONS            =
567     ==========================================*/
568     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
569         antiEarlyWhale(_incomingEthereum)
570         internal
571         returns(uint256)
572     {
573         // data setup
574         address _customerAddress = msg.sender;
575         uint256 _undividedDividends = getDividends(percentageFee, _incomingEthereum);
576         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
577         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
578         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
579         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
580         uint256 _fee = _dividends * magnitude;
581 
582         // no point in continuing execution if OP is a poorfag russian hacker
583         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
584         // (or hackers)
585         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
586         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
587 
588         // is the user referred by a masternode?
589         if(
590             // is this a referred purchase?
591             _referredBy != 0x0000000000000000000000000000000000000000 &&
592 
593             // no cheating!
594             _referredBy != _customerAddress &&
595 
596             // does the referrer have at least X whole tokens?
597             // i.e is the referrer a godly chad masternode
598             tokenBalanceLedger_[_referredBy] >= stakingRequirement
599         ){
600             // wealth redistribution
601             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
602         } else {
603             // no ref purchase
604             // add the referral bonus back to the global dividends cake
605             _dividends = SafeMath.add(_dividends, _referralBonus);
606             _fee = _dividends * magnitude;
607         }
608 
609         // we can't give people infinite ethereum
610         if(tokenSupply_ > 0){
611 
612             // add tokens to the pool
613             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
614 
615             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
616             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
617 
618             // calculate the amount of tokens the customer receives over his purchase
619             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
620 
621         } else {
622             // add tokens to the pool
623             tokenSupply_ = _amountOfTokens;
624         }
625 
626         // update circulating supply & the ledger address for the customer
627         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
628 
629         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
630         //really i know you think you do but you don't
631         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
632         payoutsTo_[_customerAddress] += _updatedPayouts;
633 
634         // fire event
635         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
636 
637         return _amountOfTokens;
638     }
639 
640     /**
641      * Calculate Token price based on an amount of incoming ethereum
642      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
643      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
644      */
645     function ethereumToTokens_(uint256 _ethereum)
646         internal
647         view
648         returns(uint256)
649     {
650         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
651         uint256 _tokensReceived =
652          (
653             (
654                 // underflow attempts BTFO
655                 SafeMath.sub(
656                     (sqrt
657                         (
658                             (_tokenPriceInitial**2)
659                             +
660                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
661                             +
662                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
663                             +
664                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
665                         )
666                     ), _tokenPriceInitial
667                 )
668             )/(tokenPriceIncremental_)
669         )-(tokenSupply_)
670         ;
671 
672         return _tokensReceived;
673     }
674 
675     /**
676      * Calculate token sell value.
677      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
678      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
679      */
680      function tokensToEthereum_(uint256 _tokens)
681         public
682         view
683         returns(uint256)
684     {
685 
686         uint256 tokens_ = _tokens;
687         uint256 _tokenSupply = (tokenSupply_ + 1e18);
688         uint256 _etherReceived =
689         (
690             // underflow attempts BTFO
691             SafeMath.sub(
692                 (
693                     (
694                         (
695                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
696                         )-tokenPriceIncremental_
697                     )*(tokens_)
698                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
699             )
700         /1e18);
701         return _etherReceived;
702     }
703 
704 
705     //This is where all your gas goes, sorry
706     //Not sorry, you probably only paid 1 gwei
707     function sqrt(uint x) internal pure returns (uint y) {
708         uint z = (x + 1) / 2;
709         y = x;
710         while (z < y) {
711             y = z;
712             z = (x / z + z) / 2;
713         }
714     }
715 
716     function getDividends(uint256 _percentage, uint256 _ethereum) internal pure returns (uint256) {
717         uint256 _amount = SafeMath.div(_ethereum, 100);
718         uint256 _dividends = SafeMath.mul(_amount, _percentage);
719         return _dividends;
720     }
721 }
722 
723 /**
724  * @title SafeMath
725  * @dev Math operations with safety checks that throw on error
726  */
727 library SafeMath {
728 
729     /**
730     * @dev Multiplies two numbers, throws on overflow.
731     */
732     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
733         if (a == 0) {
734             return 0;
735         }
736         uint256 c = a * b;
737         assert(c / a == b);
738         return c;
739     }
740 
741     /**
742     * @dev Integer division of two numbers, truncating the quotient.
743     */
744     function div(uint256 a, uint256 b) internal pure returns (uint256) {
745         // assert(b > 0); // Solidity automatically throws when dividing by 0
746         uint256 c = a / b;
747         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
748         return c;
749     }
750 
751     /**
752     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
753     */
754     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
755         assert(b <= a);
756         return a - b;
757     }
758 
759     /**
760     * @dev Adds two numbers, throws on overflow.
761     */
762     function add(uint256 a, uint256 b) internal pure returns (uint256) {
763         uint256 c = a + b;
764         assert(c >= a);
765         return c;
766     }
767 }