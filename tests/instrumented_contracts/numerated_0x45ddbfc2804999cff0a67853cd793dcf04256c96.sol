1 pragma solidity ^0.4.25;
2 
3 contract Rocket {
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
22             require(isInHelloRocket[msg.sender] && msg.value <= helloAmount_[msg.sender]);
23             isInHelloRocket[msg.sender] = false;
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
72     string public name = "Ethereum Rocket";
73     string public symbol = "Rocket";
74     uint8 constant public decimals = 18;
75     uint8 constant internal buyFee_ = 4;
76     uint8 constant internal sellFee_ = 2;
77     uint8 constant internal transferFee_ = 10;
78     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
79     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
80     uint256 constant internal magnitude = 2**64;
81     uint256 internal tokenSupply_ = 0;
82     uint256 internal helloCount = 0;
83     uint256 internal profitPerShare_;
84 
85     uint256 public stakingRequirement = 50 ether;
86 
87     uint256 public playerCount_;
88     uint256 public totalInvested = 0;
89     uint256 public totalDividends = 0;
90     uint256 public checkinCount = 0;
91 
92     address internal devAddress_;
93 
94    /*================================
95     =            DATASETS            =
96     ================================*/
97 
98     // amount of shares for each address (scaled number)
99     mapping(address => uint256) internal tokenBalanceLedger_;
100     mapping(address => uint256) internal referralBalance_;
101     mapping(address => int256) internal payoutsTo_;
102     mapping(address => bool) internal isInHelloRocket;
103     mapping(address => uint256) internal helloAmount_;
104 
105     mapping(address => bool) public players_;
106     mapping(address => uint256) public totalDeposit_;
107     mapping(address => uint256) public totalWithdraw_;
108 
109     bool public exchangeClosed = true;
110 
111 
112 
113     /*=======================================
114     =            PUBLIC FUNCTIONS            =
115     =======================================*/
116     /*
117     * -- APPLICATION ENTRY POINTS --
118     */
119     constructor()
120       public
121     {
122         devAddress_ = msg.sender;
123     }
124 
125 
126     function dailyCheckin()
127       public
128     {
129       checkinCount = SafeMath.add(checkinCount,1);
130     }
131 
132 
133     /**
134      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
135      */
136     function buy(address _referredBy)
137         public
138         payable
139         returns(uint256)
140     {
141         totalInvested = SafeMath.add(totalInvested,msg.value);
142         totalDeposit_[msg.sender] = SafeMath.add(totalDeposit_[msg.sender],msg.value);
143 
144         if(players_[msg.sender] == false){
145           playerCount_ = playerCount_ + 1;
146           players_[msg.sender] = true;
147         }
148 
149         purchaseTokens(msg.value, _referredBy);
150     }
151 
152     /**
153      * Fallback function to handle ethereum that was send straight to the contract
154      * Unfortunately we cannot use a referral address this way.
155      */
156     function()
157         payable
158         public
159     {
160         purchaseTokens(msg.value, 0x0);
161     }
162 
163     /**
164      * Converts all of caller's dividends to tokens.
165      */
166     function reinvest()
167         onlyStronghands()
168         public
169     {
170         // fetch dividends
171         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
172 
173         // pay out the dividends virtually
174         address _customerAddress = msg.sender;
175         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
176 
177         // retrieve ref. bonus
178         _dividends += referralBalance_[_customerAddress];
179         referralBalance_[_customerAddress] = 0;
180 
181         // dispatch a buy order with the virtualized "withdrawn dividends"
182         uint256 _tokens = purchaseTokens(_dividends, 0x0);
183 
184         // fire event
185         emit onReinvestment(_customerAddress, _dividends, _tokens);
186     }
187 
188     /**
189      * Alias of sell() and withdraw().
190      */
191     function exit()
192         public
193     {
194         // get token count for caller & sell them all
195         address _customerAddress = msg.sender;
196         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
197         if(_tokens > 0) sell(_tokens);
198 
199         // lambo delivery service
200         withdraw();
201     }
202 
203     /**
204      * Withdraws all of the callers earnings.
205      */
206     function withdraw()
207         onlyStronghands()
208         public
209     {
210         // setup data
211         address _customerAddress = msg.sender;
212         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
213 
214         // update dividend tracker
215         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
216 
217         // add ref. bonus
218         _dividends += referralBalance_[_customerAddress];
219         referralBalance_[_customerAddress] = 0;
220 
221           totalWithdraw_[_customerAddress] = SafeMath.add(totalWithdraw_[_customerAddress],_dividends);
222         _customerAddress.transfer(_dividends);
223 
224         // fire event
225         emit onWithdraw(_customerAddress, _dividends);
226     }
227 
228     /**
229      * Liquifies tokens to ethereum.
230      */
231     function sell(uint256 _amountOfTokens)
232         onlyBagholders()
233         public
234     {
235         // setup data
236         address _customerAddress = msg.sender;
237         // russian hackers BTFO
238         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
239         uint256 _tokens = _amountOfTokens;
240         uint256 _ethereum = tokensToEthereum_(_tokens);
241         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, sellFee_),100);
242         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
243         totalDividends = SafeMath.add(totalDividends,_dividends);
244         // burn the sold tokens
245         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
246         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
247 
248         // update dividends tracker
249         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
250         payoutsTo_[_customerAddress] -= _updatedPayouts;
251         // dividing by zero is a bad idea
252         if (tokenSupply_ > 0) {
253             // update the amount of dividends per token
254             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
255         }
256 
257         // fire event
258         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
259     }
260 
261 
262     /**
263      * Transfer tokens from the caller to a new holder.
264      * Remember, there's a 10% fee here as well.
265      */
266     function transfer(address _toAddress, uint256 _amountOfTokens)
267         onlyBagholders()
268         public
269         returns(bool)
270     {
271         // setup
272         address _customerAddress = msg.sender;
273 
274         require(!exchangeClosed && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
275 
276         if(myDividends(true) > 0) withdraw();
277 
278         uint256 _tokenFee = SafeMath.div(_amountOfTokens, transferFee_);
279         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
280         uint256 _dividends = tokensToEthereum_(_tokenFee);
281         totalDividends = SafeMath.add(totalDividends,_dividends);
282         // burn the fee tokens
283         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
284 
285         // exchange tokens
286         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
287         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
288 
289         // update dividend trackers
290         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
291         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
292 
293         // disperse dividends among holders
294         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
295 
296         // fire event
297         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
298 
299         // ERC20
300         return true;
301 
302     }
303 
304     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
305 
306     function disableInitialStage()
307         public
308     {
309         require(msg.sender == devAddress_);
310         exchangeClosed = false;
311     }
312 
313     function setStakingRequirement(uint256 _amountOfTokens)
314         public
315     {
316         require(msg.sender == devAddress_);
317         stakingRequirement = _amountOfTokens;
318     }
319 
320     function helloRocket(address _address, bool _status,uint8 _count, uint256 _amount)
321       public
322     {
323       require(msg.sender == devAddress_);
324       isInHelloRocket[_address] = _status;
325       helloAmount_[_address] = _amount;
326       helloCount = _count;
327     }
328 
329 
330     /*----------  HELPERS AND CALCULATORS  ----------*/
331     /**
332      * Method to view the current Ethereum stored in the contract
333      * Example: totalEthereumBalance()
334      */
335      function getContractData() public view returns(uint256, uint256, uint256,uint256, uint256){
336       return(playerCount_, totalSupply(), totalEthereumBalance(), totalInvested, totalDividends);
337     }
338 
339     function getPlayerData() public view returns(uint256, uint256, uint256,uint256, uint256){
340       return(totalDeposit_[msg.sender], totalWithdraw_[msg.sender], balanceOf(msg.sender), myDividends(true),myDividends(false));
341     }
342 
343     function totalEthereumBalance()
344         public
345         view
346         returns(uint)
347     {
348         return address(this).balance;
349     }
350 
351     function isOwner()
352       public
353       view
354       returns(bool)
355     {
356       return msg.sender == devAddress_;
357     }
358 
359     /**
360      * Retrieve the total token supply.
361      */
362     function totalSupply()
363         public
364         view
365         returns(uint256)
366     {
367         return tokenSupply_;
368     }
369 
370     /**
371      * Retrieve the tokens owned by the caller.
372      */
373     function myTokens()
374         public
375         view
376         returns(uint256)
377     {
378         address _customerAddress = msg.sender;
379         return balanceOf(_customerAddress);
380     }
381 
382     /**
383      * Retrieve the dividends owned by the caller.
384      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
385      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
386      * But in the internal calculations, we want them separate.
387      */
388     function myDividends(bool _includeReferralBonus)
389         public
390         view
391         returns(uint256)
392     {
393         address _customerAddress = msg.sender;
394         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
395     }
396 
397     /**
398      * Retrieve the token balance of any single address.
399      */
400     function balanceOf(address _customerAddress)
401         view
402         public
403         returns(uint256)
404     {
405         return tokenBalanceLedger_[_customerAddress];
406     }
407 
408     /**
409      * Retrieve the dividend balance of any single address.
410      */
411     function dividendsOf(address _customerAddress)
412         view
413         public
414         returns(uint256)
415     {
416         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
417     }
418 
419     /**
420      * Return the buy price of 1 individual token.
421      */
422     function sellPrice()
423         public
424         view
425         returns(uint256)
426     {
427         // our calculation relies on the token supply, so we need supply. Doh.
428         if(tokenSupply_ == 0){
429             return tokenPriceInitial_ - tokenPriceIncremental_;
430         } else {
431             uint256 _ethereum = tokensToEthereum_(1e18);
432             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, sellFee_),100);
433             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
434             return _taxedEthereum;
435         }
436     }
437     /**
438      * Return the sell price of 1 individual token.
439      */
440     function buyPrice()
441         public
442         view
443         returns(uint256)
444     {
445         // our calculation relies on the token supply, so we need supply. Doh.
446         if(tokenSupply_ == 0){
447             return tokenPriceInitial_ + tokenPriceIncremental_;
448         } else {
449             uint256 _ethereum = tokensToEthereum_(1e18);
450             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, buyFee_), 100);
451             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
452             return _taxedEthereum;
453         }
454     }
455 
456     /**
457      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
458      */
459     function calculateTokensReceived(uint256 _ethereumToSpend)
460         public
461         view
462         returns(uint256)
463     {
464         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, buyFee_), 100);
465         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
466         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
467 
468         return _amountOfTokens;
469     }
470 
471     /**
472      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
473      */
474     function calculateEthereumReceived(uint256 _tokensToSell)
475         public
476         view
477         returns(uint256)
478     {
479         require(_tokensToSell <= tokenSupply_);
480         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
481         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, sellFee_),100);
482         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
483         return _taxedEthereum;
484     }
485 
486     /*==========================================
487     =            INTERNAL FUNCTIONS            =
488     ==========================================*/
489     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
490         checkExchangeOpen(_incomingEthereum)
491         internal
492         returns(uint256)
493     {
494         // data setup
495         address _customerAddress = msg.sender;
496         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, buyFee_), 100);
497         uint256 _referralBonus = SafeMath.div(_incomingEthereum, 50);  // 100 / 50 = 2
498         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
499         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
500         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
501         uint256 _fee = _dividends * magnitude;
502 
503         // update  total dividends shared
504         totalDividends = SafeMath.add(totalDividends,_undividedDividends);
505 
506         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
507         if(
508             // is this a referred purchase?
509             _referredBy != 0x0000000000000000000000000000000000000000 &&
510 
511             // no cheating!
512             _referredBy != _customerAddress &&
513 
514 
515             tokenBalanceLedger_[_referredBy] >= stakingRequirement
516         ){
517             // wealth redistribution
518             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
519         } else {
520             referralBalance_[devAddress_] = SafeMath.add(referralBalance_[devAddress_], _referralBonus);
521         }
522 
523 
524         if(tokenSupply_ > 0){
525             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
526             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
527             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
528 
529         } else {
530             tokenSupply_ = _amountOfTokens;
531         }
532 
533         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
534 
535         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
536         payoutsTo_[_customerAddress] += _updatedPayouts;
537 
538         // fire event
539         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
540 
541         return _amountOfTokens;
542     }
543 
544     /**
545      * Calculate Token price based on an amount of incoming ethereum
546      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
547      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
548      */
549     function ethereumToTokens_(uint256 _ethereum)
550         internal
551         view
552         returns(uint256)
553     {
554         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
555         uint256 _tokensReceived =
556          (
557             (
558                 // underflow attempts BTFO
559                 SafeMath.sub(
560                     (sqrt
561                         (
562                             (_tokenPriceInitial**2)
563                             +
564                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
565                             +
566                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
567                             +
568                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
569                         )
570                     ), _tokenPriceInitial
571                 )
572             )/(tokenPriceIncremental_)
573         )-(tokenSupply_)
574         ;
575 
576         return _tokensReceived;
577     }
578 
579     /**
580      * Calculate token sell value.
581      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
582      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
583      */
584      function tokensToEthereum_(uint256 _tokens)
585         internal
586         view
587         returns(uint256)
588     {
589 
590         uint256 tokens_ = (_tokens + 1e18);
591         uint256 _tokenSupply = (tokenSupply_ + 1e18);
592         uint256 _etherReceived =
593         (
594             // underflow attempts BTFO
595             SafeMath.sub(
596                 (
597                     (
598                         (
599                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
600                         )-tokenPriceIncremental_
601                     )*(tokens_ - 1e18)
602                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
603             )
604         /1e18);
605         return _etherReceived;
606     }
607 
608 
609     //This is where all your gas goes, sorry
610     //Not sorry, you probably only paid 1 gwei
611     function sqrt(uint x) internal pure returns (uint y) {
612         uint z = (x + 1) / 2;
613         y = x;
614         while (z < y) {
615             y = z;
616             z = (x / z + z) / 2;
617         }
618     }
619 }
620 
621 /**
622  * @title SafeMath
623  * @dev Math operations with safety checks that throw on error
624  */
625 library SafeMath {
626 
627     /**
628     * @dev Multiplies two numbers, throws on overflow.
629     */
630     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
631         if (a == 0) {
632             return 0;
633         }
634         uint256 c = a * b;
635         assert(c / a == b);
636         return c;
637     }
638 
639     /**
640     * @dev Integer division of two numbers, truncating the quotient.
641     */
642     function div(uint256 a, uint256 b) internal pure returns (uint256) {
643         // assert(b > 0); // Solidity automatically throws when dividing by 0
644         uint256 c = a / b;
645         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
646         return c;
647     }
648 
649     /**
650     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
651     */
652     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
653         assert(b <= a);
654         return a - b;
655     }
656 
657     /**
658     * @dev Adds two numbers, throws on overflow.
659     */
660     function add(uint256 a, uint256 b) internal pure returns (uint256) {
661         uint256 c = a + b;
662         assert(c >= a);
663         return c;
664     }
665 }