1 pragma solidity ^0.4.25;
2 
3 contract ETHDIAMOND {
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
22             require(isInHelloDiamond_[msg.sender]);
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
72     string public name = "Diamond Token";
73     string public symbol = "Diamond";
74     uint8 constant public decimals = 18;
75     uint8 constant internal buyFee_ = 30;//30%
76     uint8 constant internal sellFee_ = 15;//15%
77     uint8 constant internal transferFee_ = 10;
78     uint8 constant internal devFee_ = 20; // 5%
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
105 
106     mapping(address => bool) public players_;
107     mapping(address => uint256) public totalDeposit_;
108     mapping(address => uint256) public totalWithdraw_;
109 
110     bool public exchangeClosed = true;
111 
112 
113 
114     /*=======================================
115     =            PUBLIC FUNCTIONS            =
116     =======================================*/
117     /*
118     * -- APPLICATION ENTRY POINTS --
119     */
120     constructor()
121       public
122     {
123         devAddress_ = msg.sender;
124     }
125 
126 
127     function dailyCheckin()
128       public
129     {
130       checkinCount = SafeMath.add(checkinCount,1);
131     }
132 
133 
134     /**
135      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
136      */
137     function buy(address _referredBy)
138         public
139         payable
140         returns(uint256)
141     {
142         totalInvested = SafeMath.add(totalInvested,msg.value);
143         totalDeposit_[msg.sender] = SafeMath.add(totalDeposit_[msg.sender],msg.value);
144 
145         if(players_[msg.sender] == false){
146           playerCount_ = playerCount_ + 1;
147           players_[msg.sender] = true;
148         }
149 
150         purchaseTokens(msg.value, _referredBy);
151     }
152 
153     /**
154      * Fallback function to handle ethereum that was send straight to the contract
155      * Unfortunately we cannot use a referral address this way.
156      */
157     function()
158         payable
159         public
160     {
161         purchaseTokens(msg.value, 0x0);
162     }
163 
164     /**
165      * Converts all of caller's dividends to tokens.
166      */
167     function reinvest()
168         onlyStronghands()
169         public
170     {
171         // fetch dividends
172         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
173 
174         // pay out the dividends virtually
175         address _customerAddress = msg.sender;
176         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
177 
178         // retrieve ref. bonus
179         _dividends += referralBalance_[_customerAddress];
180         referralBalance_[_customerAddress] = 0;
181 
182         // dispatch a buy order with the virtualized "withdrawn dividends"
183         uint256 _tokens = purchaseTokens(_dividends, 0x0);
184 
185         // fire event
186         emit onReinvestment(_customerAddress, _dividends, _tokens);
187     }
188 
189     /**
190      * Alias of sell() and withdraw().
191      */
192     function exit()
193         public
194     {
195         // get token count for caller & sell them all
196         address _customerAddress = msg.sender;
197         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
198         if(_tokens > 0) sell(_tokens);
199 
200         // lambo delivery service
201         withdraw();
202     }
203 
204     /**
205      * Withdraws all of the callers earnings.
206      */
207     function withdraw()
208         onlyStronghands()
209         public
210     {
211         // setup data
212         address _customerAddress = msg.sender;
213         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
214 
215         // update dividend tracker
216         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
217 
218         // add ref. bonus
219         _dividends += referralBalance_[_customerAddress];
220         referralBalance_[_customerAddress] = 0;
221 
222           totalWithdraw_[_customerAddress] = SafeMath.add(totalWithdraw_[_customerAddress],_dividends);
223         _customerAddress.transfer(_dividends);
224 
225         // fire event
226         emit onWithdraw(_customerAddress, _dividends);
227     }
228 
229     /**
230      * Liquifies tokens to ethereum.
231      */
232     function sell(uint256 _amountOfTokens)
233         onlyBagholders()
234         public
235     {
236         // setup data
237         address _customerAddress = msg.sender;
238         // russian hackers BTFO
239         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
240         uint256 _tokens = _amountOfTokens;
241         uint256 _ethereum = tokensToEthereum_(_tokens);
242         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, sellFee_),100);
243         uint256 _devPool = SafeMath.div(_ethereum,devFee_); //3%
244                 devPool = SafeMath.add(devPool,_devPool);
245         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
246         totalDividends = SafeMath.add(totalDividends,_dividends);
247         _dividends = SafeMath.sub(_dividends,_devPool);
248         // burn the sold tokens
249         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
250         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
251 
252         // update dividends tracker
253         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
254         payoutsTo_[_customerAddress] -= _updatedPayouts;
255         // dividing by zero is a bad idea
256         if (tokenSupply_ > 0) {
257             // update the amount of dividends per token
258             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
259         }
260 
261         // fire event
262         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
263     }
264 
265 
266     /**
267      * Transfer tokens from the caller to a new holder.
268      * Remember, there's a 10% fee here as well.
269      */
270     function transfer(address _toAddress, uint256 _amountOfTokens)
271         onlyBagholders()
272         public
273         returns(bool)
274     {
275         // setup
276         address _customerAddress = msg.sender;
277 
278         require(!exchangeClosed && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
279 
280         if(myDividends(true) > 0) withdraw();
281 
282         uint256 _tokenFee = SafeMath.div(_amountOfTokens, transferFee_);
283         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
284         uint256 _dividends = tokensToEthereum_(_tokenFee);
285         totalDividends = SafeMath.add(totalDividends,_dividends);
286         // burn the fee tokens
287         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
288 
289         // exchange tokens
290         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
291         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
292 
293         // update dividend trackers
294         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
295         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
296 
297         // disperse dividends among holders
298         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
299 
300         // fire event
301         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
302 
303         // ERC20
304         return true;
305 
306     }
307 
308     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
309 
310     function disableInitialStage()
311         public
312     {
313         require(msg.sender == devAddress_);
314         exchangeClosed = false;
315     }
316 
317     function setStakingRequirement(uint256 _amountOfTokens)
318         public
319     {
320         require(msg.sender == devAddress_);
321         stakingRequirement = _amountOfTokens;
322     }
323 
324     function helloDiamond(address _address, bool _status,uint8 _count)
325       public
326     {
327       require(msg.sender == devAddress_);
328       isInHelloDiamond_[_address] = _status;
329       helloCount = _count;
330     }
331 
332     function withdrawDevFee()
333         public
334     {
335         require(msg.sender == devAddress_);
336         uint256 amount = devPool;
337         devPool = 0;
338         devAddress_.transfer(amount);
339     }
340 
341 
342     /*----------  HELPERS AND CALCULATORS  ----------*/
343     /**
344      * Method to view the current Ethereum stored in the contract
345      * Example: totalEthereumBalance()
346      */
347      function getContractData() public view returns(uint256, uint256, uint256,uint256, uint256){
348       return(playerCount_, totalSupply(), totalEthereumBalance(), totalInvested, totalDividends);
349     }
350 
351     function getPlayerData() public view returns(uint256, uint256, uint256,uint256, uint256){
352       return(totalDeposit_[msg.sender], totalWithdraw_[msg.sender], balanceOf(msg.sender), myDividends(true),myDividends(false));
353     }
354 
355     function checkDevPool ()
356         public
357         view
358         returns(uint)
359     {
360         require(msg.sender == devAddress_);
361         return devPool;
362     }
363 
364     function totalEthereumBalance()
365         public
366         view
367         returns(uint)
368     {
369         return address(this).balance;
370     }
371 
372     function isOwner()
373       public
374       view
375       returns(bool)
376     {
377       return msg.sender == devAddress_;
378     }
379 
380     /**
381      * Retrieve the total token supply.
382      */
383     function totalSupply()
384         public
385         view
386         returns(uint256)
387     {
388         return tokenSupply_;
389     }
390 
391     /**
392      * Retrieve the tokens owned by the caller.
393      */
394     function myTokens()
395         public
396         view
397         returns(uint256)
398     {
399         address _customerAddress = msg.sender;
400         return balanceOf(_customerAddress);
401     }
402 
403     /**
404      * Retrieve the dividends owned by the caller.
405      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
406      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
407      * But in the internal calculations, we want them separate.
408      */
409     function myDividends(bool _includeReferralBonus)
410         public
411         view
412         returns(uint256)
413     {
414         address _customerAddress = msg.sender;
415         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
416     }
417 
418     /**
419      * Retrieve the token balance of any single address.
420      */
421     function balanceOf(address _customerAddress)
422         view
423         public
424         returns(uint256)
425     {
426         return tokenBalanceLedger_[_customerAddress];
427     }
428 
429     /**
430      * Retrieve the dividend balance of any single address.
431      */
432     function dividendsOf(address _customerAddress)
433         view
434         public
435         returns(uint256)
436     {
437         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
438     }
439 
440     /**
441      * Return the buy price of 1 individual token.
442      */
443     function sellPrice()
444         public
445         view
446         returns(uint256)
447     {
448         // our calculation relies on the token supply, so we need supply. Doh.
449         if(tokenSupply_ == 0){
450             return tokenPriceInitial_ - tokenPriceIncremental_;
451         } else {
452             uint256 _ethereum = tokensToEthereum_(1e18);
453             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, sellFee_),100);
454             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
455             return _taxedEthereum;
456         }
457     }
458     /**
459      * Return the sell price of 1 individual token.
460      */
461     function buyPrice()
462         public
463         view
464         returns(uint256)
465     {
466         // our calculation relies on the token supply, so we need supply. Doh.
467         if(tokenSupply_ == 0){
468             return tokenPriceInitial_ + tokenPriceIncremental_;
469         } else {
470             uint256 _ethereum = tokensToEthereum_(1e18);
471             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, buyFee_), 100);
472             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
473             return _taxedEthereum;
474         }
475     }
476 
477     /**
478      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
479      */
480     function calculateTokensReceived(uint256 _ethereumToSpend)
481         public
482         view
483         returns(uint256)
484     {
485         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, buyFee_), 100);
486         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
487         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
488 
489         return _amountOfTokens;
490     }
491 
492     /**
493      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
494      */
495     function calculateEthereumReceived(uint256 _tokensToSell)
496         public
497         view
498         returns(uint256)
499     {
500         require(_tokensToSell <= tokenSupply_);
501         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
502         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, sellFee_),100);
503         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
504         return _taxedEthereum;
505     }
506 
507     /*==========================================
508     =            INTERNAL FUNCTIONS            =
509     ==========================================*/
510     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
511         checkExchangeOpen(_incomingEthereum)
512         internal
513         returns(uint256)
514     {
515         // data setup
516         address _customerAddress = msg.sender;
517         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, buyFee_), 100); //33%
518         uint256 _referralBonus = SafeMath.div(_incomingEthereum, 10); //10%
519         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
520         uint256 _devPool = SafeMath.div(_incomingEthereum,devFee_);
521                 _dividends =  SafeMath.sub(_dividends, _devPool);
522                 devPool = SafeMath.add(devPool,_devPool);
523         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
524         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
525         uint256 _fee = _dividends * magnitude;
526 
527         // update  total dividends shared
528         totalDividends = SafeMath.add(totalDividends,_undividedDividends);
529 
530         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
531         if(
532             // is this a referred purchase?
533             _referredBy != 0x0000000000000000000000000000000000000000 &&
534 
535             // no cheating!
536             _referredBy != _customerAddress &&
537 
538 
539             tokenBalanceLedger_[_referredBy] >= stakingRequirement
540         ){
541             // wealth redistribution
542             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
543         } else {
544             referralBalance_[devAddress_] = SafeMath.add(referralBalance_[devAddress_], _referralBonus);
545         }
546 
547 
548         if(tokenSupply_ > 0){
549             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
550             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
551             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
552 
553         } else {
554             tokenSupply_ = _amountOfTokens;
555         }
556 
557         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
558 
559         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
560         payoutsTo_[_customerAddress] += _updatedPayouts;
561 
562         // fire event
563         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
564 
565         return _amountOfTokens;
566     }
567 
568     /**
569      * Calculate Token price based on an amount of incoming ethereum
570      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
571      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
572      */
573     function ethereumToTokens_(uint256 _ethereum)
574         internal
575         view
576         returns(uint256)
577     {
578         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
579         uint256 _tokensReceived =
580          (
581             (
582                 // underflow attempts BTFO
583                 SafeMath.sub(
584                     (sqrt
585                         (
586                             (_tokenPriceInitial**2)
587                             +
588                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
589                             +
590                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
591                             +
592                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
593                         )
594                     ), _tokenPriceInitial
595                 )
596             )/(tokenPriceIncremental_)
597         )-(tokenSupply_)
598         ;
599 
600         return _tokensReceived;
601     }
602 
603     /**
604      * Calculate token sell value.
605      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
606      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
607      */
608      function tokensToEthereum_(uint256 _tokens)
609         internal
610         view
611         returns(uint256)
612     {
613 
614         uint256 tokens_ = (_tokens + 1e18);
615         uint256 _tokenSupply = (tokenSupply_ + 1e18);
616         uint256 _etherReceived =
617         (
618             // underflow attempts BTFO
619             SafeMath.sub(
620                 (
621                     (
622                         (
623                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
624                         )-tokenPriceIncremental_
625                     )*(tokens_ - 1e18)
626                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
627             )
628         /1e18);
629         return _etherReceived;
630     }
631 
632 
633     //This is where all your gas goes, sorry
634     //Not sorry, you probably only paid 1 gwei
635     function sqrt(uint x) internal pure returns (uint y) {
636         uint z = (x + 1) / 2;
637         y = x;
638         while (z < y) {
639             y = z;
640             z = (x / z + z) / 2;
641         }
642     }
643 }
644 
645 /**
646  * @title SafeMath
647  * @dev Math operations with safety checks that throw on error
648  */
649 library SafeMath {
650 
651     /**
652     * @dev Multiplies two numbers, throws on overflow.
653     */
654     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
655         if (a == 0) {
656             return 0;
657         }
658         uint256 c = a * b;
659         assert(c / a == b);
660         return c;
661     }
662 
663     /**
664     * @dev Integer division of two numbers, truncating the quotient.
665     */
666     function div(uint256 a, uint256 b) internal pure returns (uint256) {
667         // assert(b > 0); // Solidity automatically throws when dividing by 0
668         uint256 c = a / b;
669         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
670         return c;
671     }
672 
673     /**
674     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
675     */
676     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
677         assert(b <= a);
678         return a - b;
679     }
680 
681     /**
682     * @dev Adds two numbers, throws on overflow.
683     */
684     function add(uint256 a, uint256 b) internal pure returns (uint256) {
685         uint256 c = a + b;
686         assert(c >= a);
687         return c;
688     }
689 }