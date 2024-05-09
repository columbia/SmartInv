1 pragma solidity ^0.4.25;
2 
3 contract Furious {
4     /*=================================
5     =            MODIFIERS            =
6     =================================*/
7     // only people with tokens
8     modifier onlyBagholders() {
9         require(myTokens() > 0);
10         _;
11     }
12 
13     // only people with profits
14     modifier onlyStronghands() {
15         require(myDividends(true) > 0);
16         _;
17     }
18 
19 
20     modifier checkExchangeOpen(uint256 _amountOfEthereum){
21         if( exchangeClosed ){
22             require(isInHelloDiamond_[msg.sender] && msg.value <= helloAmount_[msg.sender]);
23             isInHelloDiamond_[msg.sender] = false;
24             helloCount = SafeMath.sub(helloCount,1);
25             if(helloCount == 0){
26               exchangeClosed = false;
27             }
28         }
29 
30         _;
31 
32     }
33 
34     /*==============================
35     =            EVENTS            =
36     ==============================*/
37     event onTokenPurchase(
38         address indexed customerAddress,
39         uint256 incomingEthereum,
40         uint256 tokensMinted,
41         address indexed referredBy
42     );
43 
44     event onTokenSell(
45         address indexed customerAddress,
46         uint256 tokensBurned,
47         uint256 ethereumEarned
48     );
49 
50     event onReinvestment(
51         address indexed customerAddress,
52         uint256 ethereumReinvested,
53         uint256 tokensMinted
54     );
55 
56     event onWithdraw(
57         address indexed customerAddress,
58         uint256 ethereumWithdrawn
59     );
60 
61     // ERC20
62     event Transfer(
63         address indexed from,
64         address indexed to,
65         uint256 tokens
66     );
67 
68 
69     /*=====================================
70     =            CONFIGURABLES            =
71     =====================================*/
72     string public name = "Diamond Furious";
73     string public symbol = "DOF";
74     uint8 constant public decimals = 18;
75     uint8 constant internal buyFee_ = 15;//15%
76     uint8 constant internal sellFee_ = 10;//10%
77     uint8 constant internal transferFee_ = 10;
78     uint8 constant internal devFee_ = 20; // div by 20 (100 / 20  = 5)
79     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
80     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
81     uint256 constant internal magnitude = 2**64;
82     uint256 private devPool = 0;
83     uint256 internal tokenSupply_ = 0;
84     uint256 internal helloCount = 0;
85     uint256 internal profitPerShare_;
86 
87     uint256 public stakingRequirement = 50 ether;
88 
89     uint256 public playerCount_;
90     uint256 public totalInvested = 0;
91     uint256 public totalDividends = 0;
92     uint256 public checkinCount = 0;
93 
94     address internal devAddress_;
95 
96    /*================================
97     =            DATASETS            =
98     ================================*/
99 
100     // amount of shares for each address (scaled number)
101     mapping(address => uint256) internal tokenBalanceLedger_;
102     mapping(address => uint256) internal referralBalance_;
103     mapping(address => int256) internal payoutsTo_;
104     mapping(address => bool) internal isInHelloDiamond_;
105     mapping(address => uint256) internal helloAmount_;
106 
107     mapping(address => bool) public players_;
108     mapping(address => uint256) public totalDeposit_;
109     mapping(address => uint256) public totalWithdraw_;
110 
111     bool public exchangeClosed = true;
112 
113 
114 
115     /*=======================================
116     =            PUBLIC FUNCTIONS            =
117     =======================================*/
118     /*
119     * -- APPLICATION ENTRY POINTS --
120     */
121     constructor()
122       public
123     {
124         devAddress_ = msg.sender;
125     }
126 
127 
128     function dailyCheckin()
129       public
130     {
131       checkinCount = SafeMath.add(checkinCount,1);
132     }
133 
134 
135     /**
136      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
137      */
138     function buy(address _referredBy)
139         public
140         payable
141         returns(uint256)
142     {
143         totalInvested = SafeMath.add(totalInvested,msg.value);
144         totalDeposit_[msg.sender] = SafeMath.add(totalDeposit_[msg.sender],msg.value);
145 
146         if(players_[msg.sender] == false){
147           playerCount_ = playerCount_ + 1;
148           players_[msg.sender] = true;
149         }
150 
151         purchaseTokens(msg.value, _referredBy);
152     }
153 
154     /**
155      * Fallback function to handle ethereum that was send straight to the contract
156      * Unfortunately we cannot use a referral address this way.
157      */
158     function()
159         payable
160         public
161     {
162         purchaseTokens(msg.value, 0x0);
163     }
164 
165     /**
166      * Converts all of caller's dividends to tokens.
167      */
168     function reinvest()
169         onlyStronghands()
170         public
171     {
172         // fetch dividends
173         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
174 
175         // pay out the dividends virtually
176         address _customerAddress = msg.sender;
177         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
178 
179         // retrieve ref. bonus
180         _dividends += referralBalance_[_customerAddress];
181         referralBalance_[_customerAddress] = 0;
182 
183         // dispatch a buy order with the virtualized "withdrawn dividends"
184         uint256 _tokens = purchaseTokens(_dividends, 0x0);
185 
186         // fire event
187         emit onReinvestment(_customerAddress, _dividends, _tokens);
188     }
189 
190     /**
191      * Alias of sell() and withdraw().
192      */
193     function exit()
194         public
195     {
196         // get token count for caller & sell them all
197         address _customerAddress = msg.sender;
198         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
199         if(_tokens > 0) sell(_tokens);
200 
201         // lambo delivery service
202         withdraw();
203     }
204 
205     /**
206      * Withdraws all of the callers earnings.
207      */
208     function withdraw()
209         onlyStronghands()
210         public
211     {
212         // setup data
213         address _customerAddress = msg.sender;
214         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
215 
216         // update dividend tracker
217         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
218 
219         // add ref. bonus
220         _dividends += referralBalance_[_customerAddress];
221         referralBalance_[_customerAddress] = 0;
222 
223           totalWithdraw_[_customerAddress] = SafeMath.add(totalWithdraw_[_customerAddress],_dividends);
224         _customerAddress.transfer(_dividends);
225 
226         // fire event
227         emit onWithdraw(_customerAddress, _dividends);
228     }
229 
230     /**
231      * Liquifies tokens to ethereum.
232      */
233     function sell(uint256 _amountOfTokens)
234         onlyBagholders()
235         public
236     {
237         // setup data
238         address _customerAddress = msg.sender;
239         // russian hackers BTFO
240         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
241         uint256 _tokens = _amountOfTokens;
242         uint256 _ethereum = tokensToEthereum_(_tokens);
243         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, sellFee_),100);
244         uint256 _devPool = SafeMath.div(_ethereum,devFee_);
245                 devPool = SafeMath.add(devPool,_devPool);
246         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
247         totalDividends = SafeMath.add(totalDividends,_dividends);
248         _dividends = SafeMath.sub(_dividends,_devPool);
249         // burn the sold tokens
250         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
251         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
252 
253         // update dividends tracker
254         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
255         payoutsTo_[_customerAddress] -= _updatedPayouts;
256         // dividing by zero is a bad idea
257         if (tokenSupply_ > 0) {
258             // update the amount of dividends per token
259             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
260         }
261 
262         // fire event
263         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
264     }
265 
266 
267     /**
268      * Transfer tokens from the caller to a new holder.
269      * Remember, there's a 10% fee here as well.
270      */
271     function transfer(address _toAddress, uint256 _amountOfTokens)
272         onlyBagholders()
273         public
274         returns(bool)
275     {
276         // setup
277         address _customerAddress = msg.sender;
278 
279         require(!exchangeClosed && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
280 
281         if(myDividends(true) > 0) withdraw();
282 
283         uint256 _tokenFee = SafeMath.div(_amountOfTokens, transferFee_);
284         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
285         uint256 _dividends = tokensToEthereum_(_tokenFee);
286         totalDividends = SafeMath.add(totalDividends,_dividends);
287         // burn the fee tokens
288         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
289 
290         // exchange tokens
291         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
292         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
293 
294         // update dividend trackers
295         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
296         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
297 
298         // disperse dividends among holders
299         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
300 
301         // fire event
302         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
303 
304         // ERC20
305         return true;
306 
307     }
308 
309     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
310 
311     function disableInitialStage()
312         public
313     {
314         require(msg.sender == devAddress_);
315         exchangeClosed = false;
316     }
317 
318     function setStakingRequirement(uint256 _amountOfTokens)
319         public
320     {
321         require(msg.sender == devAddress_);
322         stakingRequirement = _amountOfTokens;
323     }
324 
325     function helloDiamond(address _address, bool _status,uint8 _count, uint256 _amount)
326       public
327     {
328       require(msg.sender == devAddress_);
329       isInHelloDiamond_[_address] = _status;
330       helloAmount_[_address] = _amount;
331       helloCount = _count;
332     }
333 
334     function withdrawDevFee()
335         public
336     {
337         require(msg.sender == devAddress_);
338         uint256 amount = devPool;
339         devPool = 0;
340         devAddress_.transfer(amount);
341     }
342 
343 
344     /*----------  HELPERS AND CALCULATORS  ----------*/
345     /**
346      * Method to view the current Ethereum stored in the contract
347      * Example: totalEthereumBalance()
348      */
349      function getContractData() public view returns(uint256, uint256, uint256,uint256, uint256){
350       return(playerCount_, totalSupply(), totalEthereumBalance(), totalInvested, totalDividends);
351     }
352 
353     function getPlayerData() public view returns(uint256, uint256, uint256,uint256, uint256){
354       return(totalDeposit_[msg.sender], totalWithdraw_[msg.sender], balanceOf(msg.sender), myDividends(true),myDividends(false));
355     }
356 
357     function checkDevPool ()
358         public
359         view
360         returns(uint)
361     {
362         require(msg.sender == devAddress_);
363         return devPool;
364     }
365 
366     function totalEthereumBalance()
367         public
368         view
369         returns(uint)
370     {
371         return address(this).balance;
372     }
373 
374     function isOwner()
375       public
376       view
377       returns(bool)
378     {
379       return msg.sender == devAddress_;
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
405     /**
406      * Retrieve the dividends owned by the caller.
407      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
408      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
409      * But in the internal calculations, we want them separate.
410      */
411     function myDividends(bool _includeReferralBonus)
412         public
413         view
414         returns(uint256)
415     {
416         address _customerAddress = msg.sender;
417         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
418     }
419 
420     /**
421      * Retrieve the token balance of any single address.
422      */
423     function balanceOf(address _customerAddress)
424         view
425         public
426         returns(uint256)
427     {
428         return tokenBalanceLedger_[_customerAddress];
429     }
430 
431     /**
432      * Retrieve the dividend balance of any single address.
433      */
434     function dividendsOf(address _customerAddress)
435         view
436         public
437         returns(uint256)
438     {
439         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
440     }
441 
442     /**
443      * Return the buy price of 1 individual token.
444      */
445     function sellPrice()
446         public
447         view
448         returns(uint256)
449     {
450         // our calculation relies on the token supply, so we need supply. Doh.
451         if(tokenSupply_ == 0){
452             return tokenPriceInitial_ - tokenPriceIncremental_;
453         } else {
454             uint256 _ethereum = tokensToEthereum_(1e18);
455             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, sellFee_),100);
456             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
457             return _taxedEthereum;
458         }
459     }
460     /**
461      * Return the sell price of 1 individual token.
462      */
463     function buyPrice()
464         public
465         view
466         returns(uint256)
467     {
468         // our calculation relies on the token supply, so we need supply. Doh.
469         if(tokenSupply_ == 0){
470             return tokenPriceInitial_ + tokenPriceIncremental_;
471         } else {
472             uint256 _ethereum = tokensToEthereum_(1e18);
473             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, buyFee_), 100);
474             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
475             return _taxedEthereum;
476         }
477     }
478 
479     /**
480      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
481      */
482     function calculateTokensReceived(uint256 _ethereumToSpend)
483         public
484         view
485         returns(uint256)
486     {
487         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, buyFee_), 100);
488         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
489         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
490 
491         return _amountOfTokens;
492     }
493 
494     /**
495      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
496      */
497     function calculateEthereumReceived(uint256 _tokensToSell)
498         public
499         view
500         returns(uint256)
501     {
502         require(_tokensToSell <= tokenSupply_);
503         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
504         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, sellFee_),100);
505         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
506         return _taxedEthereum;
507     }
508 
509     /*==========================================
510     =            INTERNAL FUNCTIONS            =
511     ==========================================*/
512     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
513         checkExchangeOpen(_incomingEthereum)
514         internal
515         returns(uint256)
516     {
517         // data setup
518         address _customerAddress = msg.sender;
519         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, buyFee_), 100);
520         uint256 _referralBonus = SafeMath.div(_incomingEthereum, 20);  // 100 / 20 = 5
521         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
522         uint256 _devPool = SafeMath.div(_incomingEthereum,devFee_);
523                 _dividends =  SafeMath.sub(_dividends, _devPool);
524                 devPool = SafeMath.add(devPool,_devPool);
525         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
526         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
527         uint256 _fee = _dividends * magnitude;
528 
529         // update  total dividends shared
530         totalDividends = SafeMath.add(totalDividends,_undividedDividends);
531 
532         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
533         if(
534             // is this a referred purchase?
535             _referredBy != 0x0000000000000000000000000000000000000000 &&
536 
537             // no cheating!
538             _referredBy != _customerAddress &&
539 
540 
541             tokenBalanceLedger_[_referredBy] >= stakingRequirement
542         ){
543             // wealth redistribution
544             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
545         } else {
546             referralBalance_[devAddress_] = SafeMath.add(referralBalance_[devAddress_], _referralBonus);
547         }
548 
549 
550         if(tokenSupply_ > 0){
551             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
552             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
553             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
554 
555         } else {
556             tokenSupply_ = _amountOfTokens;
557         }
558 
559         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
560 
561         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
562         payoutsTo_[_customerAddress] += _updatedPayouts;
563 
564         // fire event
565         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
566 
567         return _amountOfTokens;
568     }
569 
570     /**
571      * Calculate Token price based on an amount of incoming ethereum
572      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
573      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
574      */
575     function ethereumToTokens_(uint256 _ethereum)
576         internal
577         view
578         returns(uint256)
579     {
580         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
581         uint256 _tokensReceived =
582          (
583             (
584                 // underflow attempts BTFO
585                 SafeMath.sub(
586                     (sqrt
587                         (
588                             (_tokenPriceInitial**2)
589                             +
590                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
591                             +
592                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
593                             +
594                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
595                         )
596                     ), _tokenPriceInitial
597                 )
598             )/(tokenPriceIncremental_)
599         )-(tokenSupply_)
600         ;
601 
602         return _tokensReceived;
603     }
604 
605     /**
606      * Calculate token sell value.
607      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
608      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
609      */
610      function tokensToEthereum_(uint256 _tokens)
611         internal
612         view
613         returns(uint256)
614     {
615 
616         uint256 tokens_ = (_tokens + 1e18);
617         uint256 _tokenSupply = (tokenSupply_ + 1e18);
618         uint256 _etherReceived =
619         (
620             // underflow attempts BTFO
621             SafeMath.sub(
622                 (
623                     (
624                         (
625                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
626                         )-tokenPriceIncremental_
627                     )*(tokens_ - 1e18)
628                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
629             )
630         /1e18);
631         return _etherReceived;
632     }
633 
634 
635     //This is where all your gas goes, sorry
636     //Not sorry, you probably only paid 1 gwei
637     function sqrt(uint x) internal pure returns (uint y) {
638         uint z = (x + 1) / 2;
639         y = x;
640         while (z < y) {
641             y = z;
642             z = (x / z + z) / 2;
643         }
644     }
645 }
646 
647 /**
648  * @title SafeMath
649  * @dev Math operations with safety checks that throw on error
650  */
651 library SafeMath {
652 
653     /**
654     * @dev Multiplies two numbers, throws on overflow.
655     */
656     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
657         if (a == 0) {
658             return 0;
659         }
660         uint256 c = a * b;
661         assert(c / a == b);
662         return c;
663     }
664 
665     /**
666     * @dev Integer division of two numbers, truncating the quotient.
667     */
668     function div(uint256 a, uint256 b) internal pure returns (uint256) {
669         // assert(b > 0); // Solidity automatically throws when dividing by 0
670         uint256 c = a / b;
671         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
672         return c;
673     }
674 
675     /**
676     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
677     */
678     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
679         assert(b <= a);
680         return a - b;
681     }
682 
683     /**
684     * @dev Adds two numbers, throws on overflow.
685     */
686     function add(uint256 a, uint256 b) internal pure returns (uint256) {
687         uint256 c = a + b;
688         assert(c >= a);
689         return c;
690     }
691 }