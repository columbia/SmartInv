1 pragma solidity ^0.4.20;
2 /*
3 * Created by LOCKEDiN
4 * ====================================*
5 * ->About LCK
6 * An autonomousfully automated passive income:
7 * [x] Created by a team of professional Developers from India who run a software company and specialize in Internet and Cryptographic Security
8 * [x] Pen-tested multiple times with zero vulnerabilities!
9 * [X] Able to operate even if our website www.lockedin.io is down via Metamask and Etherscan
10 * [x] 30 LCK required for a Masternode Link generation
11 * [x] As people join your make money as people leave you make money 24/7 – Not a lending platform but a human-less passive income machine on the Ethereum Blockchain
12 * [x] Once deployed neither we nor any other human can alter, change or stop the contract it will run for as long as Ethereum is running!
13 * [x] Unlike similar projects the developers are only allowing 3 ETH to be purchased by Developers at deployment as opposed to 22 ETH – Fair for the Public!
14 * - 33% Reward of dividends if someone signs up using your Masternode link
15 * -  You earn by others depositing or withdrawing ETH and this passive ETH earnings can either be reinvested or you can withdraw it at any time without penalty.
16 * Upon entry into the contract it will automatically deduct your 10% entry and exit fees so the longer you remain and the higher the volume the more you earn and the more that people join or leave you also earn more.  
17 * You are able to withdraw your entire balance at any time you so choose. 
18 */
19 
20 
21 contract LOCKEDiN {
22     /*=================================
23     =            MODIFIERS            =
24     =================================*/
25     // only people with tokens
26     modifier onlyBagholders() {
27         require(myTokens() > 0);
28         _;
29     }
30 
31     // only people with profits
32     modifier onlyStronghands() {
33         require(myDividends(true) > 0);
34         _;
35     }
36 
37     // ensures that the first tokens in the contract will be equally distributed
38     // meaning, no divine dump will be ever possible
39     // result: healthy longevity.
40     modifier antiEarlyWhale(uint256 _amountOfEthereum){
41         address _customerAddress = msg.sender;
42 
43         // are we still in the vulnerable phase?
44         // if so, enact anti early whale protocol 
45         if( onlyDevs && ((totalEthereumBalance() - _amountOfEthereum) <= devsQuota_ )){
46             require(
47                 // is the customer in the ambassador list?
48                 developers_[_customerAddress] == true &&
49 
50                 // does the customer purchase exceed the max ambassador quota?
51                 (devsAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= devsMaxPurchase_
52             );
53 
54             // updated the accumulated quota    
55             devsAccumulatedQuota_[_customerAddress] = SafeMath.add(devsAccumulatedQuota_[_customerAddress], _amountOfEthereum);
56 
57             // execute
58             _;
59         } else {
60             // in case the ether count drops low, the ambassador phase won't reinitiate
61             onlyDevs = false;
62             _;    
63         }
64 
65     }
66 
67 
68     /*==============================
69     =            EVENTS            =
70     ==============================*/
71     event onTokenPurchase(
72         address indexed customerAddress,
73         uint256 incomingEthereum,
74         uint256 tokensMinted,
75         address indexed referredBy
76     );
77 
78     event onTokenSell(
79         address indexed customerAddress,
80         uint256 tokensBurned,
81         uint256 ethereumEarned
82     );
83 
84     event onReinvestment(
85         address indexed customerAddress,
86         uint256 ethereumReinvested,
87         uint256 tokensMinted
88     );
89 
90     event onWithdraw(
91         address indexed customerAddress,
92         uint256 ethereumWithdrawn
93     );
94 
95     // ERC20
96     event Transfer(
97         address indexed from,
98         address indexed to,
99         uint256 tokens
100     );
101 
102 
103     /*=====================================
104     =            CONFIGURABLES            =
105     =====================================*/
106     string public name = "LOCKEDiN";
107     string public symbol = "LCK";
108     uint8 constant public decimals = 18;
109     uint8 constant internal dividendFee_ = 10;
110     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
111     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
112     uint256 constant internal magnitude = 2**64;
113 
114     // proof of stake (defaults at 30 tokens)
115     uint256 public stakingRequirement = 30e18;
116 
117     // Developer program
118     mapping(address => bool) internal developers_;
119     uint256 constant internal devsMaxPurchase_ = 1 ether;
120     uint256 constant internal devsQuota_ = 3 ether;
121 
122 
123 
124    /*================================
125     =            DATASETS            =
126     ================================*/
127     // amount of shares for each address (scaled number)
128     mapping(address => uint256) internal tokenBalanceLedger_;
129     mapping(address => uint256) internal referralBalance_;
130     mapping(address => int256) internal payoutsTo_;
131     mapping(address => uint256) internal devsAccumulatedQuota_;
132     uint256 internal tokenSupply_ = 0;
133     uint256 internal profitPerShare_;
134 
135 
136     // when this is set to true, only developers can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
137     bool public onlyDevs = true;
138 
139     /*=======================================
140     =            PUBLIC FUNCTIONS            =
141     =======================================*/
142     /*
143     * -- APPLICATION ENTRY POINTS --  
144     */
145     function LOCKEDiN()
146         public
147     {
148         // add developers here
149         developers_[0x2AAC4821B03Ed3c14Cab6d62782a368e0c44e7de] = true;
150 
151         developers_[0x7b459F23119206cfddE5d92572127a5B99075ac4] = true;
152 
153         developers_[0xd9eA90E6491475EB498d55Be2165775080eD4F83] = true;
154 
155         developers_[0xEb1874f8b702AB8911ae64D36f6B34975afcc431] = true;
156 
157     }
158 
159 
160     /**
161      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
162      */
163     function buy(address _referredBy)
164         public
165         payable
166         returns(uint256)
167     {
168         purchaseTokens(msg.value, _referredBy);
169     }
170 
171     /**
172      * Fallback function to handle ethereum that was send straight to the contract
173      * Unfortunately we cannot use a referral address this way.
174      */
175     function()
176         payable
177         public
178     {
179         purchaseTokens(msg.value, 0x0);
180     }
181 
182     /**
183      * Converts all of caller's dividends to tokens.
184      */
185     function reinvest()
186     onlyStronghands()
187         public
188     {
189         // fetch dividends
190         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
191 
192         // pay out the dividends virtually
193         address _customerAddress = msg.sender;
194         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
195 
196         // retrieve ref. bonus
197         _dividends += referralBalance_[_customerAddress];
198         referralBalance_[_customerAddress] = 0;
199 
200         // dispatch a buy order with the virtualized "withdrawn dividends"
201         uint256 _tokens = purchaseTokens(_dividends, 0x0);
202 
203         // fire event
204         emit onReinvestment(_customerAddress, _dividends, _tokens);
205     }
206 
207     /**
208      * Alias of sell() and withdraw().
209      */
210     function exit()
211         public
212     {
213         // get token count for caller & sell them all
214         address _customerAddress = msg.sender;
215         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
216         if(_tokens > 0) sell(_tokens);
217 
218         // lambo delivery service
219         withdraw();
220     }
221 
222     /**
223      * Withdraws all of the callers earnings.
224      */
225     function withdraw()
226     onlyStronghands()
227         public
228     {
229         // setup data
230         address _customerAddress = msg.sender;
231         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
232 
233         // update dividend tracker
234         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
235 
236         // add ref. bonus
237         _dividends += referralBalance_[_customerAddress];
238         referralBalance_[_customerAddress] = 0;
239 
240         // lambo delivery service
241         _customerAddress.transfer(_dividends);
242 
243         // fire event
244         emit onWithdraw(_customerAddress, _dividends);
245     }
246 
247     /**
248      * Liquifies tokens to ethereum.
249      */
250     function sell(uint256 _amountOfTokens)
251         onlyBagholders()
252         public
253     {
254         // setup data
255         address _customerAddress = msg.sender;
256         // russian hackers BTFO
257         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
258         uint256 _tokens = _amountOfTokens;
259         uint256 _ethereum = tokensToEthereum_(_tokens);
260         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
261         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
262 
263         // burn the sold tokens
264         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
265         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
266 
267         // update dividends tracker
268         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
269         payoutsTo_[_customerAddress] -= _updatedPayouts;       
270 
271         // dividing by zero is a bad idea
272         if (tokenSupply_ > 0) {
273             // update the amount of dividends per token
274             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
275         }
276 
277         // fire event
278         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
279     }
280 
281 
282     /**
283      * Transfer tokens from the caller to a new holder.
284      * Remember, there's a 10% fee here as well.
285      */
286     function transfer(address _toAddress, uint256 _amountOfTokens)
287         onlyBagholders()
288         public
289         returns(bool)
290     {
291         // setup
292         address _customerAddress = msg.sender;
293 
294         // make sure we have the requested tokens
295         // also disables transfers until ambassador phase is over
296         // ( wedont want whale premines )
297         require(!onlyDevs && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
298 
299         // withdraw all outstanding dividends first
300         if(myDividends(true) > 0) withdraw();
301 
302         // liquify 10% of the tokens that are transfered
303         // these are dispersed to shareholders
304         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
305         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
306         uint256 _dividends = tokensToEthereum_(_tokenFee);
307 
308         // burn the fee tokens
309         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
310 
311         // exchange tokens
312         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
313         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
314 
315         // update dividend trackers
316         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
317         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
318 
319         // disperse dividends among holders
320         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
321 
322         // fire event
323         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
324 
325         // ERC20
326         return true;
327 
328     }
329 
330     /*----------  HELPERS AND CALCULATORS  ----------*/
331     /**
332      * Method to view the current Ethereum stored in the contract
333      * Example: totalEthereumBalance()
334      */
335     function totalEthereumBalance()
336         public
337         view
338         returns(uint)
339     {
340         return this.balance;
341     }
342 
343     /**
344      * Retrieve the total token supply.
345      */
346     function totalSupply()
347         public
348         view
349         returns(uint256)
350     {
351         return tokenSupply_;
352     }
353 
354     /**
355      * Retrieve the tokens owned by the caller.
356      */
357     function myTokens()
358         public
359         view
360         returns(uint256)
361     {
362         address _customerAddress = msg.sender;
363         return balanceOf(_customerAddress);
364     }
365 
366     /**
367      * Retrieve the dividends owned by the caller.
368      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
369      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
370      * But in the internal calculations, we want them separate. 
371      */ 
372     function myDividends(bool _includeReferralBonus) 
373         public 
374         view 
375         returns(uint256)
376     {
377         address _customerAddress = msg.sender;
378         return _includeReferralBonus ?dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
379     }
380 
381     /**
382      * Retrieve the token balance of any single address.
383      */
384     function balanceOf(address _customerAddress)
385         view
386         public
387         returns(uint256)
388     {
389         return tokenBalanceLedger_[_customerAddress];
390     }
391 
392     /**
393      * Retrieve the dividend balance of any single address.
394      */
395     function dividendsOf(address _customerAddress)
396         view
397         public
398         returns(uint256)
399     {
400         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
401     }
402 
403     /**
404      * Return the buy price of 1 individual token.
405      */
406     function sellPrice() 
407         public 
408         view 
409         returns(uint256)
410         {
411         // our calculation relies on the token supply, so we need supply. Doh.
412         if(tokenSupply_ == 0)
413         {
414             return tokenPriceInitial_ - tokenPriceIncremental_;
415         }
416         else
417         {
418             uint256 _ethereum = tokensToEthereum_(1e18);
419             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
420             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
421             return _taxedEthereum;
422         }
423         }
424 
425     /**
426      * Return the sell price of 1 individual token.
427      */
428     function buyPrice() 
429         public 
430         view 
431         returns(uint256)
432     {
433         // our calculation relies on the token supply, so we need supply. Doh.
434         if(tokenSupply_ == 0){
435             return tokenPriceInitial_ + tokenPriceIncremental_;
436         } else {
437             uint256 _ethereum = tokensToEthereum_(1e18);
438             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
439             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
440             return _taxedEthereum;
441         }
442     }
443 
444     /**
445      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
446      */
447     function calculateTokensReceived(uint256 _ethereumToSpend) 
448         public 
449         view 
450         returns(uint256)
451     {
452         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
453         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
454         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
455 
456         return _amountOfTokens;
457     }
458 
459     /**
460      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
461      */
462     function calculateEthereumReceived(uint256 _tokensToSell) 
463         public 
464         view 
465         returns(uint256)
466     {
467         require(_tokensToSell <= tokenSupply_);
468         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
469         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
470         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
471         return _taxedEthereum;
472     }
473 
474 
475     /*==========================================
476     =            INTERNAL FUNCTIONS            =
477     ==========================================*/
478     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
479         antiEarlyWhale(_incomingEthereum)
480         internal
481         returns(uint256)
482     {
483         // data setup
484         address _customerAddress = msg.sender;
485         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
486         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
487         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
488         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
489         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
490         uint256 _fee = _dividends * magnitude;
491 
492         // no point in continuing execution if OP is a poorfagrussian hacker
493         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
494         // (or hackers)
495         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
496         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
497 
498         // is the user referred by a masternode?
499         if(
500             // is this a referred purchase?
501             _referredBy != 0x0000000000000000000000000000000000000000 &&
502 
503             // no cheating!
504             _referredBy != _customerAddress&&
505 
506             // does the referrer have at least X whole tokens?
507             // i.e is the referrer a godly chad masternode
508             tokenBalanceLedger_[_referredBy] >= stakingRequirement
509         ){
510             // wealth redistribution
511             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
512         } else {
513             // no ref purchase
514             // add the referral bonus back to the global dividends cake
515             _dividends = SafeMath.add(_dividends, _referralBonus);
516             _fee = _dividends * magnitude;
517         }
518 
519         // we can't give people infinite ethereum
520         if(tokenSupply_ > 0){
521 
522             // add tokens to the pool
523             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
524 
525             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
526             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
527 
528             // calculate the amount of tokens the customer receives over his purchase 
529             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
530 
531         } else {
532             // add tokens to the pool
533             tokenSupply_ = _amountOfTokens;
534         }
535 
536         // update circulating supply & the ledger address for the customer
537         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
538 
539         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
540         //really i know you think you do but you don't
541         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
542         payoutsTo_[_customerAddress] += _updatedPayouts;
543 
544         // fire event
545         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
546 
547         return _amountOfTokens;
548     }
549 
550     /**
551      * Calculate Token price based on an amount of incoming ethereum
552      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
553      */
554     function ethereumToTokens_(uint256 _ethereum)
555         internal
556         view
557         returns(uint256)
558     {
559         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
560         uint256 _tokensReceived = 
561         (
562             (
563                 // underflow attempts BTFO
564                 SafeMath.sub(
565                     (sqrt
566                         (
567                             (_tokenPriceInitial**2)
568                             +
569                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
570                             +
571                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
572                             +
573                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
574                         )
575                     ), _tokenPriceInitial
576                 )
577             )/(tokenPriceIncremental_)
578         )-(tokenSupply_)
579         ;
580 
581         return _tokensReceived;
582     }
583 
584     /**
585      * Calculate token sell value.
586      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
587      */
588     function tokensToEthereum_(uint256 _tokens)
589         internal
590         view
591         returns(uint256)
592     {
593 
594         uint256 tokens_ = (_tokens + 1e18);
595         uint256 _tokenSupply = (tokenSupply_ + 1e18);
596         uint256 _etherReceived = 
597         (
598             // underflow attempts BTFO
599             SafeMath.sub(
600                 (
601                     (
602                         (
603                         tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply/1e18))
604                                                 )-tokenPriceIncremental_
605                     )*(tokens_ - 1e18)
606                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
607             )
608         /1e18);
609         return _etherReceived;
610     }
611 
612     function sqrt(uint x) internal pure returns (uint y) {
613         uint z = (x + 1) / 2;
614         y = x;
615         while (z < y) {
616             y = z;
617             z = (x / z + z) / 2;
618         }
619     }
620 }
621 
622 /**
623  * @title SafeMath
624  * @dev Math operations with safety checks that throw on error
625  */
626 library SafeMath {
627 
628     /**
629     * @dev Multiplies two numbers, throws on overflow.
630     */
631     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
632         if (a == 0) {
633             return 0;
634         }
635         uint256 c = a * b;
636         assert(c / a == b);
637         return c;
638     }
639 
640     /**
641     * @dev Integer division of two numbers, truncating the quotient.
642     */
643     function div(uint256 a, uint256 b) internal pure returns (uint256) {
644         // assert(b > 0); // Solidity automatically throws when dividing by 0
645         uint256 c = a / b;
646         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
647         return c;
648     }
649 
650     /**
651     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
652     */
653     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
654         assert(b <= a);
655         return a - b;
656     }
657 
658     /**
659     * @dev Adds two numbers, throws on overflow.
660     */
661     function add(uint256 a, uint256 b) internal pure returns (uint256) {
662         uint256 c = a + b;
663         assert(c >= a);
664         return c;
665     }
666 }