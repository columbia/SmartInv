1 pragma solidity ^0.4.24;
2 
3 /***
4  * https://apexONE.io
5  * 
6  * No administrators or developers, this contract is fully autonomous
7  *
8  * 12 % entry fee
9  * 12 % of entry fee to masternode referrals
10  * 0 % transfer fee
11  * Exit fee starts at 48% from contract start
12  * Exit fee decreases over 30 days  until 12%
13  * Stays at 12% forever.
14  */
15 contract apexONE {
16 
17     /*=================================
18     =            MODIFIERS            =
19     =================================*/
20 
21     /// @dev Only people with tokens
22     modifier onlyBagholders {
23         require(myTokens() > 0);
24         _;
25     }
26 
27     /// @dev Only people with profits
28     modifier onlyStronghands {
29         require(myDividends(true) > 0);
30         _;
31     }
32 
33     /// @dev notGasbag
34     modifier notGasbag() {
35       require(tx.gasprice < 200999999999);
36       _;
37     }
38 
39     /// @dev Preventing unstable dumping and limit ambassador mine
40     modifier antiEarlyWhale {
41         if (address(this).balance  -msg.value < whaleBalanceLimit){
42           require(msg.value <= maxEarlyStake);
43         }
44         if (depositCount_ == 0){
45           require(ambassadors_[msg.sender] && msg.value == 0.25 ether);
46         }else
47         if (depositCount_ < 6){
48           require(ambassadors_[msg.sender] && msg.value == 0.75 ether);
49         }else
50         if (depositCount_ == 6 || depositCount_==7){
51           require(ambassadors_[msg.sender] && msg.value == 1 ether);
52         }
53         _;
54     }
55 
56     /// @dev notGasbag
57     modifier isControlled() {
58       require(isPremine() || isStarted());
59       _;
60     }
61 
62     /*==============================
63     =            EVENTS            =
64     ==============================*/
65 
66     event onTokenPurchase(
67         address indexed customerAddress,
68         uint256 incomingEthereum,
69         uint256 tokensMinted,
70         address indexed referredBy,
71         uint timestamp,
72         uint256 price
73     );
74 
75     event onTokenSell(
76         address indexed customerAddress,
77         uint256 tokensBurned,
78         uint256 ethereumEarned,
79         uint timestamp,
80         uint256 price
81     );
82 
83     event onReinvestment(
84         address indexed customerAddress,
85         uint256 ethereumReinvested,
86         uint256 tokensMinted
87     );
88 
89     event onWithdraw(
90         address indexed customerAddress,
91         uint256 ethereumWithdrawn
92     );
93 
94     // ERC20
95     event Transfer(
96         address indexed from,
97         address indexed to,
98         uint256 tokens
99     );
100 
101 
102     /*=====================================
103     =            CONFIGURABLES            =
104     =====================================*/
105 
106     string public name = "apexONE Token";
107     string public symbol = "APX1";
108     uint8 constant public decimals = 18;
109 
110     /// @dev 12% dividends for token purchase
111     uint8 constant internal entryFee_ = 12;
112 
113     /// @dev 48% dividends for token selling
114     uint8 constant internal startExitFee_ = 48;
115 
116     /// @dev 12% dividends for token selling after step
117     uint8 constant internal finalExitFee_ = 12;
118 
119     /// @dev Exit fee falls over period of 30 days
120     uint256 constant internal exitFeeFallDuration_ = 30 days;
121 
122     /// @dev 12% masternode
123     uint8 constant internal refferalFee_ = 12;
124 
125     /// @dev P3D pricing
126     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
127     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
128 
129     uint256 constant internal magnitude = 2 ** 64;
130 
131     /// @dev 100 needed for masternode activation
132     uint256 public stakingRequirement = 100e18;
133 
134     /// @dev anti-early-whale
135     uint256 public maxEarlyStake = 2.5 ether;
136     uint256 public whaleBalanceLimit = 75 ether;
137 
138     /// @dev apex starting gun
139     address public apex;
140 
141     /// @dev starting
142     uint256 public startTime = 0; //  January 1, 1970 12:00:00
143 
144    /*=================================
145     =            DATASETS            =
146     ================================*/
147 
148     // amount of shares for each address (scaled number)
149     mapping(address => uint256) internal tokenBalanceLedger_;
150     mapping(address => uint256) internal referralBalance_;
151     mapping(address => uint256) internal bonusBalance_;
152     mapping(address => int256) internal payoutsTo_;
153     uint256 internal tokenSupply_;
154     uint256 internal profitPerShare_;
155     uint256 public depositCount_;
156 
157     mapping(address => bool) internal ambassadors_;
158 
159     /*=======================================
160     =            CONSTRUCTOR                =
161     =======================================*/
162 
163    constructor () public {
164 
165      //Community Promotional Fund
166      ambassadors_[msg.sender]=true;
167      //1
168      ambassadors_[0x1D72C933BC38344e4ecD33F0B6fC2F8F7A6B336F]=true;
169      //2
170      ambassadors_[0xBAce3371fd1E65DD0255DDef233bD16bFa374DB2]=true;
171      //3
172      ambassadors_[0x87A7e71D145187eE9aAdc86954d39cf0e9446751]=true;
173      //4
174      ambassadors_[0x0C0dF6e58e5F7865b8137a7Fb663E7DCD5672995]=true;
175      //5
176      ambassadors_[0x6BCCC4AECc19d73ff967dA124f0Ae537aBb17440]=true;
177      //6
178      ambassadors_[0xa1038E5098E90E43a19B4A024fEF413028139d50]=true;
179      //7
180      ambassadors_[0x408C2a514aff2fE88D274C82B61256Ef74DA5811]=true;
181 
182      apex = msg.sender;
183    }
184 
185     /*=======================================
186     =            PUBLIC FUNCTIONS           =
187     =======================================*/
188 
189     // @dev Function setting the start time of the system
190     function setStartTime(uint256 _startTime) public {
191       require(msg.sender==apex && !isStarted() && now < _startTime);
192       startTime = _startTime;
193     }
194 
195     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
196     function buy(address _referredBy) antiEarlyWhale notGasbag isControlled public payable  returns (uint256) {
197         purchaseTokens(msg.value, _referredBy , msg.sender);
198     }
199 
200     /// @dev Converts to tokens on behalf of the customer - this allows gifting and integration with other systems
201     function buyFor(address _referredBy, address _customerAddress) antiEarlyWhale notGasbag isControlled public payable returns (uint256) {
202         purchaseTokens(msg.value, _referredBy , _customerAddress);
203     }
204 
205     /**
206      * @dev Fallback function to handle ethereum that was send straight to the contract
207      *  Unfortunately we cannot use a referral address this way.
208      */
209     function() antiEarlyWhale notGasbag isControlled payable public {
210         purchaseTokens(msg.value, 0x0 , msg.sender);
211     }
212 
213     /// @dev Converts all of caller's dividends to tokens.
214     function reinvest() onlyStronghands public {
215         // fetch dividends
216         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
217 
218         // pay out the dividends virtually
219         address _customerAddress = msg.sender;
220         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
221 
222         // retrieve ref. bonus
223         _dividends += referralBalance_[_customerAddress];
224         referralBalance_[_customerAddress] = 0;
225 
226         // dispatch a buy order with the virtualized "withdrawn dividends"
227         uint256 _tokens = purchaseTokens(_dividends, 0x0 , _customerAddress);
228 
229         // fire event
230         emit onReinvestment(_customerAddress, _dividends, _tokens);
231     }
232 
233     /// @dev Alias of sell() and withdraw().
234     function exit() public {
235         // get token count for caller & sell them all
236         address _customerAddress = msg.sender;
237         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
238         if (_tokens > 0) sell(_tokens);
239 
240         // capitulation
241         withdraw();
242     }
243 
244     /// @dev Withdraws all of the callers earnings.
245     function withdraw() onlyStronghands public {
246         // setup data
247         address _customerAddress = msg.sender;
248         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
249 
250         // update dividend tracker
251         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
252 
253         // add ref. bonus
254         _dividends += referralBalance_[_customerAddress];
255         referralBalance_[_customerAddress] = 0;
256 
257         // lambo delivery service
258         _customerAddress.transfer(_dividends);
259 
260         // fire event
261         emit onWithdraw(_customerAddress, _dividends);
262     }
263 
264     /// @dev Liquifies tokens to ethereum.
265     function sell(uint256 _amountOfTokens) onlyBagholders public {
266         // setup data
267         address _customerAddress = msg.sender;
268         // russian hackers BTFO
269         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
270         uint256 _tokens = _amountOfTokens;
271         uint256 _ethereum = tokensToEthereum_(_tokens);
272         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
273         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
274 
275         // burn the sold tokens
276         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
277         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
278 
279         // update dividends tracker
280         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
281         payoutsTo_[_customerAddress] -= _updatedPayouts;
282 
283         // dividing by zero is a bad idea
284         if (tokenSupply_ > 0) {
285             // update the amount of dividends per token
286             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
287         }
288 
289         // fire event
290         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
291     }
292 
293 
294     /**
295      * @dev Transfer tokens from the caller to a new holder.
296      */
297     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
298         // setup
299         address _customerAddress = msg.sender;
300 
301         // make sure we have the requested tokens
302         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
303 
304         // withdraw all outstanding dividends first
305         if (myDividends(true) > 0) {
306             withdraw();
307         }
308 
309         // exchange tokens
310         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
311         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
312 
313         // update dividend trackers
314         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
315         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
316 
317         // fire event
318         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
319 
320         // ERC20
321         return true;
322     }
323 
324 
325     /*=====================================
326     =      HELPERS AND CALCULATORS        =
327     =====================================*/
328 
329     /**
330      * @dev Method to view the current Ethereum stored in the contract
331      *  Example: totalEthereumBalance()
332      */
333     function totalEthereumBalance() public view returns (uint256) {
334         return address(this).balance;
335     }
336 
337     /// @dev Retrieve the total token supply.
338     function totalSupply() public view returns (uint256) {
339         return tokenSupply_;
340     }
341 
342     /// @dev Retrieve the tokens owned by the caller.
343     function myTokens() public view returns (uint256) {
344         address _customerAddress = msg.sender;
345         return balanceOf(_customerAddress);
346     }
347 
348     /**
349      * @dev Retrieve the dividends owned by the caller.
350      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
351      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
352      *  But in the internal calculations, we want them separate.
353      */
354     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
355         address _customerAddress = msg.sender;
356         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
357     }
358 
359     /// @dev Retrieve the token balance of any single address.
360     function balanceOf(address _customerAddress) public view returns (uint256) {
361         return tokenBalanceLedger_[_customerAddress];
362     }
363 
364     /// @dev Retrieve the dividend balance of any single address.
365     function dividendsOf(address _customerAddress) public view returns (uint256) {
366         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
367     }
368 
369     /// @dev Return the sell price of 1 individual token.
370     function sellPrice() public view returns (uint256) {
371         // our calculation relies on the token supply, so we need supply. Doh.
372         if (tokenSupply_ == 0) {
373             return tokenPriceInitial_ - tokenPriceIncremental_;
374         } else {
375             uint256 _ethereum = tokensToEthereum_(1e18);
376             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
377             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
378 
379             return _taxedEthereum;
380         }
381     }
382 
383     /// @dev Return the buy price of 1 individual token.
384     function buyPrice() public view returns (uint256) {
385         // our calculation relies on the token supply, so we need supply. Doh.
386         if (tokenSupply_ == 0) {
387             return tokenPriceInitial_ + tokenPriceIncremental_;
388         } else {
389             uint256 _ethereum = tokensToEthereum_(1e18);
390             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
391             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
392 
393             return _taxedEthereum;
394         }
395     }
396 
397     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
398     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
399         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
400         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
401         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
402         return _amountOfTokens;
403     }
404 
405     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
406     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
407         require(_tokensToSell <= tokenSupply_);
408         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
409         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
410         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
411         return _taxedEthereum;
412     }
413 
414     /// @dev Function for the frontend to get untaxed receivable ethereum.
415     function calculateUntaxedEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
416         require(_tokensToSell <= tokenSupply_);
417         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
418         //uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
419         //uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
420         return _ethereum;
421     }
422 
423 
424     /// @dev Function for getting the current exitFee
425     function exitFee() public view returns (uint8) {
426         if (startTime==0){
427            return startExitFee_;
428         }
429         if ( now < startTime) {
430           return 0;
431         }
432         uint256 secondsPassed = now - startTime;
433         if (secondsPassed >= exitFeeFallDuration_) {
434             return finalExitFee_;
435         }
436         uint8 totalChange = startExitFee_ - finalExitFee_;
437         uint8 currentChange = uint8(totalChange * secondsPassed / exitFeeFallDuration_);
438         uint8 currentFee = startExitFee_- currentChange;
439         return currentFee;
440     }
441 
442     // @dev Function for find if premine
443     function isPremine() public view returns (bool) {
444       return depositCount_<=7;
445     }
446 
447     // @dev Function for find if premine
448     function isStarted() public view returns (bool) {
449       return startTime!=0 && now > startTime;
450     }
451 
452     /*==========================================
453     =            INTERNAL FUNCTIONS            =
454     ==========================================*/
455 
456     /// @dev Internal function to actually purchase the tokens.
457     function purchaseTokens(uint256 _incomingEthereum, address _referredBy , address _customerAddress) internal returns (uint256) {
458         // data setup
459         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
460         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
461         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
462         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
463         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
464         uint256 _fee = _dividends * magnitude;
465 
466         // no point in continuing execution if OP is a poorfag russian hacker
467         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
468         // (or hackers)
469         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
470         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
471 
472         // is the user referred by a masternode?
473         if (
474             // is this a referred purchase?
475             _referredBy != 0x0000000000000000000000000000000000000000 &&
476 
477             // no cheating!
478             _referredBy != _customerAddress &&
479 
480             // does the referrer have at least X whole tokens?
481             // i.e is the referrer a godly chad masternode
482             tokenBalanceLedger_[_referredBy] >= stakingRequirement
483         ) {
484             // wealth redistribution
485             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
486         } else {
487             // no ref purchase
488             // add the referral bonus back to the global dividends cake
489             _dividends = SafeMath.add(_dividends, _referralBonus);
490             _fee = _dividends * magnitude;
491         }
492 
493         // we can't give people infinite ethereum
494         if (tokenSupply_ > 0) {
495             // add tokens to the pool
496             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
497 
498             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
499             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
500 
501             // calculate the amount of tokens the customer receives over his purchase
502             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
503         } else {
504             // add tokens to the pool
505             tokenSupply_ = _amountOfTokens;
506         }
507 
508         // update circulating supply & the ledger address for the customer
509         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
510 
511         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
512         // really i know you think you do but you don't
513         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
514         payoutsTo_[_customerAddress] += _updatedPayouts;
515 
516         // fire event
517         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
518 
519         // Keep track
520         depositCount_++;
521         return _amountOfTokens;
522     }
523 
524     /**
525      * @dev Calculate Token price based on an amount of incoming ethereum
526      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
527      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
528      */
529     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
530         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
531         uint256 _tokensReceived =
532          (
533             (
534                 // underflow attempts BTFO
535                 SafeMath.sub(
536                     (sqrt
537                         (
538                             (_tokenPriceInitial ** 2)
539                             +
540                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
541                             +
542                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
543                             +
544                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
545                         )
546                     ), _tokenPriceInitial
547                 )
548             ) / (tokenPriceIncremental_)
549         ) - (tokenSupply_);
550 
551         return _tokensReceived;
552     }
553 
554     /**
555      * @dev Calculate token sell value.
556      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
557      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
558      */
559     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
560         uint256 tokens_ = (_tokens + 1e18);
561         uint256 _tokenSupply = (tokenSupply_ + 1e18);
562         uint256 _etherReceived =
563         (
564             // underflow attempts BTFO
565             SafeMath.sub(
566                 (
567                     (
568                         (
569                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
570                         ) - tokenPriceIncremental_
571                     ) * (tokens_ - 1e18)
572                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
573             )
574         / 1e18);
575 
576         return _etherReceived;
577     }
578 
579     /// @dev This is where all your gas goes.
580     function sqrt(uint256 x) internal pure returns (uint256 y) {
581         uint256 z = (x + 1) / 2;
582         y = x;
583 
584         while (z < y) {
585             y = z;
586             z = (x / z + z) / 2;
587         }
588     }
589 
590 
591 }
592 
593 /**
594  * @title SafeMath
595  * @dev Math operations with safety checks that throw on error
596  */
597 library SafeMath {
598 
599     /**
600     * @dev Multiplies two numbers, throws on overflow.
601     */
602     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
603         if (a == 0) {
604             return 0;
605         }
606         uint256 c = a * b;
607         assert(c / a == b);
608         return c;
609     }
610 
611     /**
612     * @dev Integer division of two numbers, truncating the quotient.
613     */
614     function div(uint256 a, uint256 b) internal pure returns (uint256) {
615         // assert(b > 0); // Solidity automatically throws when dividing by 0
616         uint256 c = a / b;
617         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
618         return c;
619     }
620 
621     /**
622     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
623     */
624     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
625         assert(b <= a);
626         return a - b;
627     }
628 
629     /**
630     * @dev Adds two numbers, throws on overflow.
631     */
632     function add(uint256 a, uint256 b) internal pure returns (uint256) {
633         uint256 c = a + b;
634         assert(c >= a);
635         return c;
636     }
637 
638 }