1 pragma solidity ^0.4.20;
2 
3 /*
4 * Team noFUCKS presents..
5 * ====================================*
6 *                                     *
7 *                                     *  
8 *                                     *
9 *                                     *
10 *            ---,_,----               *
11 *           /    .     \              *
12 *          /     |      \             *
13 *         (      @@      )            *
14 *         /   _/----\_   \            *
15 *        /   '/      \`   \	          *
16 *       /    /   .    \    \          *
17 *      /    /|        |\    \         *
18 *      /   / |        | \   \         *
19 *     /   /`_/_      _\_'\   \        *
20 *    /  '/  (  . )( .  )  \  `\       *
21 *    <_ ' `--`___'`___'--' ` _>       *
22 *   /  '     @ @/ =\@ @     `  \      *
23 *  /  /      @@(  , )@@      \  \     *
24 * /  /       @@| o o|@@       \  \    *
25 *' /          @@@@@@@@          \ `   *
26 *                                     *
27 * ====================================*
28 *
29 * PROOF OF DELICIOUS FOOD
30 * -> What?
31 *  The last Ethereum pyramid (for real this time!) which earns you ETH!!!
32 * [x] Hot Dividends: 10% of every buy and 25% sell will be rewarded to token holders. Don't sell, don't be week.
33 * [x] Hot Masternodes: Holding 50 POHB Tokens allow you to generate a Masternode link, Masternode links are used as unique entry points to the contract!
34 * [x] HOT BODS: All players who enter the contract through your Masternode have 35% of their 20% dividends fee rerouted from the master-node, to the node-master!
35 *
36 * The entire cryptocurrency community suffers from one ailment, the ailment of disloyalty. It's the problem that is eating away at our very survival.
37 * This coin solves that problem. If you have weak body, this coin is not for you. If you can go the distance crank up the miners and get to work!
38 */
39 
40 contract StrongHold {
41     /*=================================
42     =            MODIFIERS            =
43     =================================*/
44     // only people with tokens
45     modifier onlyBagholders() {
46         require(myTokens() > 0);
47         _;
48     }
49 
50     // only people with profits
51     modifier onlyStronghands() {
52         require(myDividends(true) > 0);
53         _;
54     }
55 
56     // administrators can:
57     // -> change the name of the contract
58     // -> change the name of the token
59     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
60     // they CANNOT:
61     // -> take funds
62     // -> disable withdrawals
63     // -> kill the contract
64     // -> change the price of tokens
65     modifier onlyAdministrator(){
66         address _customerAddress = msg.sender;
67         require(administrators[_customerAddress]);
68         _;
69     }
70 
71 
72     // ensures that the first tokens in the contract will be equally distributed
73     // meaning, no divine dump will be ever possible
74     // result: healthy longevity.
75     modifier antiEarlyWhale(uint256 _amountOfEthereum){
76         address _customerAddress = msg.sender;
77 
78         // are we still in the vulnerable phase?
79         // if so, enact anti early whale protocol
80         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
81             require(
82                 // is the customer in the ambassador list?
83                 ambassadors_[_customerAddress] == true &&
84 
85                 // does the customer purchase exceed the max ambassador quota?
86                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
87 
88             );
89 
90             // updated the accumulated quota
91             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
92 
93             // execute
94             _;
95         } else {
96             // in case the ether count drops low, the ambassador phase won't reinitiate
97             onlyAmbassadors = false;
98             _;
99         }
100 
101     }
102 
103 
104     /*==============================
105     =            EVENTS            =
106     ==============================*/
107     event onTokenPurchase(
108         address indexed customerAddress,
109         uint256 incomingEthereum,
110         uint256 tokensMinted,
111         address indexed referredBy
112     );
113 
114     event onTokenSell(
115         address indexed customerAddress,
116         uint256 tokensBurned,
117         uint256 ethereumEarned
118     );
119 
120     event onReinvestment(
121         address indexed customerAddress,
122         uint256 ethereumReinvested,
123         uint256 tokensMinted
124     );
125 
126     event onWithdraw(
127         address indexed customerAddress,
128         uint256 ethereumWithdrawn
129     );
130 
131     // ERC20
132     event Transfer(
133         address indexed from,
134         address indexed to,
135         uint256 tokens
136     );
137 
138 
139     /*=====================================
140     =            CONFIGURABLES            =
141     =====================================*/
142     string public name = "PODeliciousFOOD";
143     string public symbol = "PODF";
144     uint8 constant public decimals = 18;
145     uint8 constant internal entryFee_ = 10; // 10% to enter the strong body coins
146     uint8 constant internal transferFee_ = 0; // transfer fee
147     uint8 constant internal refferalFee_ = 30; // 35% from enter fee divs or 7% for each invite, great for inviting strong bodies
148     uint8 constant internal exitFee_ = 25; // 25% for selling, weak bodies out
149     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
150     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
151     uint256 constant internal magnitude = 2**64;
152 
153     // proof of stake (defaults at 50 tokens)
154     uint256 public stakingRequirement = 50e18;
155 
156     // ambassador program
157     mapping(address => bool) internal ambassadors_;
158     uint256 constant internal ambassadorMaxPurchase_ = 1.5 ether;
159     uint256 constant internal ambassadorQuota_ = 7 ether; // Ocean's -Thirteen- TwentyFive (Big Strong Bodies)
160 
161 
162 
163    /*================================
164     =            DATASETS            =
165     ================================*/
166     // amount of shares for each address (scaled number)
167     mapping(address => uint256) internal tokenBalanceLedger_;
168     mapping(address => uint256) internal referralBalance_;
169     mapping(address => int256) internal payoutsTo_;
170     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
171     uint256 internal tokenSupply_ = 0;
172     uint256 internal profitPerShare_;
173 
174     // administrator list (see above on what they can do)
175     mapping(address => bool) public administrators;
176 
177     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
178     bool public onlyAmbassadors = true;
179 
180 
181 
182     /*=======================================
183     =            PUBLIC FUNCTIONS            =
184     =======================================*/
185     /*
186     * -- APPLICATION ENTRY POINTS --
187     */
188     function StrongHold()
189         public
190     {
191         // add administrators here
192         administrators[0xD5F784ccEAE9E70d9A55994466a24A8D336A9Dd5] = true;
193         administrators[0x20c945800de43394f70d789874a4dac9cfa57451]=true;
194         
195         ambassadors_[0x05f2c11996d73288AbE8a31d8b593a693FF2E5D8] = true; // kh 
196         ambassadors_[0x7c377B7bCe53a5CEF88458b2cBBe11C3babe16DA]=true; // ka
197         ambassadors_[0xb593Dec358362401ce1c6D47291dd96749318fEF]=true; //ri
198         ambassadors_[0x0b46FaEcfE315c44F1DdF463aC68D1d5C3BB1912]=true; // fl
199         ambassadors_[0x83c0Efc6d8B16D87BFe1335AB6BcAb3Ed3960285]=true; //he
200         ambassadors_[0xD5F784ccEAE9E70d9A55994466a24A8D336A9Dd5]=true; //pg
201         //ambassadors_[0xca35b7d915458ef540ade6068dfe2f44e8fa733c]=true; //js
202         ambassadors_[0x02De5c29be1150E3aFEbd1424F885e809b0882A6]=true; //rg
203         ambassadors_[0x20c945800de43394f70d789874a4dac9cfa57451]=true; //eg
204         ambassadors_[0x4945cc80a888a85bf017710895e943faef9dd0fc]=true; //br
205         ambassadors_[0xe8c8d784cff7dd7143026ada247133e92ee2b2b8]=true; //ul
206         ambassadors_[0x11e52c75998fe2E7928B191bfc5B25937Ca16741]=true; //kl
207         ambassadors_[0x165AA385e9Adf7222B82CEc4c5b0eE6b93d71ac5]=true; // ln
208     }
209 
210 
211     /**
212      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
213      */
214     function buy(address _referredBy)
215         public
216         payable
217         returns(uint256)
218     {
219         purchaseTokens(msg.value, _referredBy);
220     }
221 
222     /**
223      * Fallback function to handle ethereum that was send straight to the contract
224      * Unfortunately we cannot use a referral address this way.
225      */
226     function()
227         payable
228         public
229     {
230         purchaseTokens(msg.value, 0x0);
231     }
232 
233     /**
234      * Converts all of caller's dividends to tokens.
235     */
236     function reinvest()
237         onlyStronghands()
238         public
239     {
240         // fetch dividends
241         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
242 
243         // pay out the dividends virtually
244         address _customerAddress = msg.sender;
245         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
246 
247         // retrieve ref. bonus
248         _dividends += referralBalance_[_customerAddress];
249         referralBalance_[_customerAddress] = 0;
250 
251         // dispatch a buy order with the virtualized "withdrawn dividends"
252         uint256 _tokens = purchaseTokens(_dividends, 0x0);
253 
254         // fire event
255         onReinvestment(_customerAddress, _dividends, _tokens);
256     }
257 
258     /**
259      * Alias of sell() and withdraw().
260      */
261     function exit()
262         public
263     {
264         // get token count for caller & sell them all
265         address _customerAddress = msg.sender;
266         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
267         if(_tokens > 0) sell(_tokens);
268 
269         // lambo delivery service
270         withdraw();
271     }
272 
273     /**
274      * Withdraws all of the callers earnings.
275      */
276     function withdraw()
277         onlyStronghands()
278         public
279     {
280         // setup data
281         address _customerAddress = msg.sender;
282         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
283 
284         // update dividend tracker
285         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
286 
287         // add ref. bonus
288         _dividends += referralBalance_[_customerAddress];
289         referralBalance_[_customerAddress] = 0;
290 
291         // lambo delivery service
292         _customerAddress.transfer(_dividends);
293 
294         // fire event
295         onWithdraw(_customerAddress, _dividends);
296     }
297 
298     /**
299      * Liquifies tokens to ethereum.
300      */
301     function sell(uint256 _amountOfTokens)
302         onlyBagholders()
303         public
304     {
305         // setup data
306         address _customerAddress = msg.sender;
307         // russian hackers BTFO
308         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
309         uint256 _tokens = _amountOfTokens;
310         uint256 _ethereum = tokensToEthereum_(_tokens);
311         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
312         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
313 
314         // burn the sold tokens
315         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
316         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
317 
318         // update dividends tracker
319         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
320         payoutsTo_[_customerAddress] -= _updatedPayouts;
321 
322         // dividing by zero is a bad idea
323         if (tokenSupply_ > 0) {
324             // update the amount of dividends per token
325             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
326         }
327 
328         // fire event
329         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
330     }
331 
332 
333     /**
334      * Transfer tokens from the caller to a new holder.
335      * Remember, there's a 10% fee here as well.
336      */
337     function transfer(address _toAddress, uint256 _amountOfTokens)
338         onlyBagholders()
339         public
340         returns(bool)
341     {
342         // setup
343         address _customerAddress = msg.sender;
344 
345         // make sure we have the requested tokens
346         // also disables transfers until ambassador phase is over
347         // ( we dont want whale premines )
348         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
349 
350         // withdraw all outstanding dividends first
351         if(myDividends(true) > 0) withdraw();
352 
353         // liquify 10% of the tokens that are transfered
354         // these are dispersed to shareholders
355         uint256 _tokenFee = 0;//SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
356         uint256 _taxedTokens = _amountOfTokens;//SafeMath.sub(_amountOfTokens, _tokenFee);
357         uint256 _dividends = 0;//tokensToEthereum_(_tokenFee);
358 
359         // burn the fee tokens
360         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
361 
362         // exchange tokens
363         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
364         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
365 
366         // update dividend trackers
367         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
368         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
369 
370         // disperse dividends among holders
371         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
372 
373         // fire event
374         Transfer(_customerAddress, _toAddress, _taxedTokens);
375 
376         // ERC20
377         return true;
378 
379     }
380 
381     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
382     /**
383      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
384      */
385     function disableInitialStage()
386         onlyAdministrator()
387         public
388     {
389         onlyAmbassadors = false;
390     }
391 
392     /**
393      * In case one of us dies, we need to replace ourselves.
394      */
395     function setAdministrator(address _identifier, bool _status)
396         onlyAdministrator()
397         public
398     {
399         administrators[_identifier] = _status;
400     }
401 
402     /**
403      * Precautionary measures in case we need to adjust the masternode rate.
404      */
405     function setStakingRequirement(uint256 _amountOfTokens)
406         onlyAdministrator()
407         public
408     {
409         stakingRequirement = _amountOfTokens;
410     }
411 
412     /**
413      * If we want to rebrand, we can.
414      */
415     function setName(string _name)
416         onlyAdministrator()
417         public
418     {
419         name = _name;
420     }
421 
422     /**
423      * If we want to rebrand, we can.
424      */
425     function setSymbol(string _symbol)
426         onlyAdministrator()
427         public
428     {
429         symbol = _symbol;
430     }
431 
432 
433     /*----------  HELPERS AND CALCULATORS  ----------*/
434     /**
435      * Method to view the current Ethereum stored in the contract
436      * Example: totalEthereumBalance()
437      */
438     function totalEthereumBalance()
439         public
440         view
441         returns(uint)
442     {
443         return this.balance;
444     }
445 
446     /**
447      * Retrieve the total token supply.
448      */
449     function totalSupply()
450         public
451         view
452         returns(uint256)
453     {
454         return tokenSupply_;
455     }
456 
457     /**
458      * Retrieve the tokens owned by the caller.
459      */
460     function myTokens()
461         public
462         view
463         returns(uint256)
464     {
465         address _customerAddress = msg.sender;
466         return balanceOf(_customerAddress);
467     }
468 
469     /**
470      * Retrieve the dividends owned by the caller.
471      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
472      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
473      * But in the internal calculations, we want them separate.
474      */
475     function myDividends(bool _includeReferralBonus)
476         public
477         view
478         returns(uint256)
479     {
480         address _customerAddress = msg.sender;
481         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
482     }
483 
484     /**
485      * Retrieve the token balance of any single address.
486      */
487     function balanceOf(address _customerAddress)
488         view
489         public
490         returns(uint256)
491     {
492         return tokenBalanceLedger_[_customerAddress];
493     }
494 
495     /**
496      * Retrieve the dividend balance of any single address.
497      */
498     function dividendsOf(address _customerAddress)
499         view
500         public
501         returns(uint256)
502     {
503         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
504     }
505 
506     /**
507      * Return the buy price of 1 individual token.
508      */
509     function sellPrice()
510         public
511         view
512         returns(uint256)
513     {
514         // our calculation relies on the token supply, so we need supply. Doh.
515         if(tokenSupply_ == 0){
516             return tokenPriceInitial_ - tokenPriceIncremental_;
517         } else {
518             uint256 _ethereum = tokensToEthereum_(1e18);
519             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
520             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
521             return _taxedEthereum;
522         }
523     }
524 
525     /**
526      * Return the sell price of 1 individual token.
527      */
528     function buyPrice()
529         public
530         view
531         returns(uint256)
532     {
533         // our calculation relies on the token supply, so we need supply. Doh.
534         if(tokenSupply_ == 0){
535             return tokenPriceInitial_ + tokenPriceIncremental_;
536         } else {
537             uint256 _ethereum = tokensToEthereum_(1e18);
538             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
539             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
540             return _taxedEthereum;
541         }
542     }
543 
544     /**
545      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
546      */
547     function calculateTokensReceived(uint256 _ethereumToSpend)
548         public
549         view
550         returns(uint256)
551     {
552         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
553         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
554         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
555 
556         return _amountOfTokens;
557     }
558 
559     /**
560      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
561      */
562     function calculateEthereumReceived(uint256 _tokensToSell)
563         public
564         view
565         returns(uint256)
566     {
567         require(_tokensToSell <= tokenSupply_);
568         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
569         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
570         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
571         return _taxedEthereum;
572     }
573 
574 
575     /*==========================================
576     =            INTERNAL FUNCTIONS            =
577     ==========================================*/
578     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
579         antiEarlyWhale(_incomingEthereum)
580         internal
581         returns(uint256)
582     {
583         // data setup
584         address _customerAddress = msg.sender;
585         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
586         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
587         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
588         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
589         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
590         uint256 _fee = _dividends * magnitude;
591 
592         // no point in continuing execution if OP is a poorfag russian hacker
593         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
594         // (or hackers)
595         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
596         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
597 
598         // is the user referred by a masternode?
599         if(
600             // is this a referred purchase?
601             _referredBy != 0x0000000000000000000000000000000000000000 &&
602 
603             // no cheating!
604             _referredBy != _customerAddress &&
605 
606             // does the referrer have at least X whole tokens?
607             // i.e is the referrer a godly chad masternode
608             tokenBalanceLedger_[_referredBy] >= stakingRequirement
609         ){
610             // wealth redistribution
611             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
612         } else {
613             // no ref purchase
614             // add the referral bonus back to the global dividends cake
615             _dividends = SafeMath.add(_dividends, _referralBonus);
616             _fee = _dividends * magnitude;
617         }
618 
619         // we can't give people infinite ethereum
620         if(tokenSupply_ > 0){
621 
622             // add tokens to the pool
623             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
624 
625             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
626             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
627 
628             // calculate the amount of tokens the customer receives over his purchase
629             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
630 
631         } else {
632             // add tokens to the pool
633             tokenSupply_ = _amountOfTokens;
634         }
635 
636         // update circulating supply & the ledger address for the customer
637         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
638 
639         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
640         //really i know you think you do but you don't
641         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
642         payoutsTo_[_customerAddress] += _updatedPayouts;
643 
644         // fire event
645         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
646 
647         return _amountOfTokens;
648     }
649 
650     /**
651      * Calculate Token price based on an amount of incoming ethereum
652      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
653      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
654      */
655     function ethereumToTokens_(uint256 _ethereum)
656         internal
657         view
658         returns(uint256)
659     {
660         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
661         uint256 _tokensReceived =
662          (
663             (
664                 // underflow attempts BTFO
665                 SafeMath.sub(
666                     (sqrt
667                         (
668                             (_tokenPriceInitial**2)
669                             +
670                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
671                             +
672                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
673                             +
674                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
675                         )
676                     ), _tokenPriceInitial
677                 )
678             )/(tokenPriceIncremental_)
679         )-(tokenSupply_)
680         ;
681 
682         return _tokensReceived;
683     }
684 
685     /**
686      * Calculate token sell value.
687      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
688      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
689      */
690      function tokensToEthereum_(uint256 _tokens)
691         internal
692         view
693         returns(uint256)
694     {
695 
696         uint256 tokens_ = (_tokens + 1e18);
697         uint256 _tokenSupply = (tokenSupply_ + 1e18);
698         uint256 _etherReceived =
699         (
700             // underflow attempts BTFO
701             SafeMath.sub(
702                 (
703                     (
704                         (
705                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
706                         )-tokenPriceIncremental_
707                     )*(tokens_ - 1e18)
708                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
709             )
710         /1e18);
711         return _etherReceived;
712     }
713 
714 
715     //This is where all your gas goes, sorry
716     //Not sorry, you probably only paid 1 gwei
717     function sqrt(uint x) internal pure returns (uint y) {
718         uint z = (x + 1) / 2;
719         y = x;
720         while (z < y) {
721             y = z;
722             z = (x / z + z) / 2;
723         }
724     }
725 }
726 
727 /**
728  * @title SafeMath
729  * @dev Math operations with safety checks that throw on error
730  */
731 library SafeMath {
732 
733     /**
734     * @dev Multiplies two numbers, throws on overflow.
735     */
736     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
737         if (a == 0) {
738             return 0;
739         }
740         uint256 c = a * b;
741         assert(c / a == b);
742         return c;
743     }
744 
745     /**
746     * @dev Integer division of two numbers, truncating the quotient.
747     */
748     function div(uint256 a, uint256 b) internal pure returns (uint256) {
749         // assert(b > 0); // Solidity automatically throws when dividing by 0
750         uint256 c = a / b;
751         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
752         return c;
753     }
754 
755     /**
756     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
757     */
758     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
759         assert(b <= a);
760         return a - b;
761     }
762 
763     /**
764     * @dev Adds two numbers, throws on overflow.
765     */
766     function add(uint256 a, uint256 b) internal pure returns (uint256) {
767         uint256 c = a + b;
768         assert(c >= a);
769         return c;
770     }
771 }