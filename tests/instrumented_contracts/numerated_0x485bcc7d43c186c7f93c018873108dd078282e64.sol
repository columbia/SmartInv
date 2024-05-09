1 pragma solidity ^0.4.24;
2 
3 contract SimpleDivs {
4 
5     /*=================================
6     =            MODIFIERS            =
7     =================================*/
8 
9     /// @dev Only people with tokens
10     modifier onlyBagholders {
11         require(myTokens() > 0);
12         _;
13     }
14 
15     /// @dev Only people with profits
16     modifier onlyStronghands {
17         require(myDividends(true) > 0);
18         _;
19     }
20 
21     /// @dev notGasbag
22     modifier notGasbag() {
23       require(tx.gasprice < 200999999999);
24       _;
25     }
26 
27     /// @dev Preventing unstable dumping and limit ambassador mine
28     modifier antiEarlyWhale {
29         if (address(this).balance  -msg.value < whaleBalanceLimit){
30           require(msg.value <= maxEarlyStake);
31         }
32         if (depositCount_ == 0){
33           require(ambassadors_[msg.sender] && msg.value == 1 ether);
34         }
35         _;
36     }
37 
38     /// @dev notGasbag
39     modifier isControlled() {
40       require(isPremine() || isStarted());
41       _;
42     }
43 
44     /*==============================
45     =            EVENTS            =
46     ==============================*/
47 
48     event onTokenPurchase(
49         address indexed customerAddress,
50         uint256 incomingEthereum,
51         uint256 tokensMinted,
52         address indexed referredBy,
53         uint timestamp,
54         uint256 price
55     );
56 
57     event onTokenSell(
58         address indexed customerAddress,
59         uint256 tokensBurned,
60         uint256 ethereumEarned,
61         uint timestamp,
62         uint256 price
63     );
64 
65     event onReinvestment(
66         address indexed customerAddress,
67         uint256 ethereumReinvested,
68         uint256 tokensMinted
69     );
70 
71     event onWithdraw(
72         address indexed customerAddress,
73         uint256 ethereumWithdrawn
74     );
75 
76     // ERC20
77     event Transfer(
78         address indexed from,
79         address indexed to,
80         uint256 tokens
81     );
82 
83 
84     /*=====================================
85     =            CONFIGURABLES            =
86     =====================================*/
87 
88     string public name = "Simple Token";
89     string public symbol = "SMT";
90     uint8 constant public decimals = 18;
91 
92     /// @dev 20% dividends for token purchase
93     uint8 constant internal entryFee_ = 20;
94 
95     /// @dev 10% dividends for token selling
96     uint8 constant internal startExitFee_ = 10;
97 
98     /// @dev 10% dividends for token selling after step
99     uint8 constant internal finalExitFee_ = 10;
100 
101     /// @dev Exit fee falls over period of 30 days
102     uint256 constant internal exitFeeFallDuration_ = 30 days;
103 
104     /// @dev 30% masternode
105     uint8 constant internal refferalFee_ = 30;
106 
107     /// @dev SMT pricing
108     uint256 constant internal tokenPriceInitial_ = 0.000000001 ether;
109     uint256 constant internal tokenPriceIncremental_ = 0.0000001 ether;
110 
111     uint256 constant internal magnitude = 2 ** 64;
112 
113     /// @dev 100 needed for masternode activation
114     uint256 public stakingRequirement = 100e18;
115 
116     /// @dev anti-early-whale
117     uint256 public maxEarlyStake = 5 ether;
118     uint256 public whaleBalanceLimit = 50 ether;
119 
120     /// @dev owner starting gun
121     address public owner;
122 
123     /// @dev starting
124     uint256 public startTime = 0; //  January 1, 1970 12:00:00
125 
126    /*=================================
127     =            DATASETS            =
128     ================================*/
129 
130     // amount of shares for each address (scaled number)
131     mapping(address => uint256) internal tokenBalanceLedger_;
132     mapping(address => uint256) internal referralBalance_;
133     mapping(address => uint256) internal bonusBalance_;
134     mapping(address => int256) internal payoutsTo_;
135     uint256 internal tokenSupply_;
136     uint256 internal profitPerShare_;
137     uint256 public depositCount_;
138 
139     mapping(address => bool) internal ambassadors_;
140 
141     /*=======================================
142     =            CONSTRUCTOR                =
143     =======================================*/
144 
145    constructor () public {
146 
147      //Community Promotional Fund
148      ambassadors_[msg.sender]=true;
149     
150      owner = msg.sender;
151    }
152 
153     /*=======================================
154     =            PUBLIC FUNCTIONS           =
155     =======================================*/
156 
157     // @dev Function setting the start time of the system
158     function setStartTime(uint256 _startTime) public {
159       require(msg.sender==owner && !isStarted() && now < _startTime);
160       startTime = _startTime;
161     }
162 
163     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
164     function buy(address _referredBy) antiEarlyWhale notGasbag isControlled public payable  returns (uint256) {
165         purchaseTokens(msg.value, _referredBy , msg.sender);
166     }
167 
168     /// @dev Converts to tokens on behalf of the customer - this allows gifting and integration with other systems
169     function buyFor(address _referredBy, address _customerAddress) antiEarlyWhale notGasbag isControlled public payable returns (uint256) {
170         purchaseTokens(msg.value, _referredBy , _customerAddress);
171     }
172 
173     /**
174      * @dev Fallback function to handle ethereum that was sent straight to the contract
175      *  Unfortunately we cannot use a referral address this way.
176      */
177     function() antiEarlyWhale notGasbag isControlled payable public {
178         purchaseTokens(msg.value, 0x0 , msg.sender);
179     }
180 
181     /// @dev Converts all of caller's dividends to tokens.
182     function reinvest() onlyStronghands public {
183         // fetch dividends
184         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
185 
186         // pay out the dividends virtually
187         address _customerAddress = msg.sender;
188         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
189 
190         // retrieve ref. bonus
191         _dividends += referralBalance_[_customerAddress];
192         referralBalance_[_customerAddress] = 0;
193 
194         // dispatch a buy order with the virtualized "withdrawn dividends"
195         uint256 _tokens = purchaseTokens(_dividends, 0x0 , _customerAddress);
196 
197         // fire event
198         emit onReinvestment(_customerAddress, _dividends, _tokens);
199     }
200 
201     /// @dev Alias of sell() and withdraw().
202     function exit() public {
203         // get token count for caller & sell them all
204         address _customerAddress = msg.sender;
205         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
206         if (_tokens > 0) sell(_tokens);
207 
208         // capitulation
209         withdraw();
210     }
211 
212     /// @dev Withdraws all of the callers earnings.
213     function withdraw() onlyStronghands public {
214         // setup data
215         address _customerAddress = msg.sender;
216         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
217 
218         // update dividend tracker
219         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
220 
221         // add ref. bonus
222         _dividends += referralBalance_[_customerAddress];
223         referralBalance_[_customerAddress] = 0;
224 
225         // lambo delivery service
226         _customerAddress.transfer(_dividends);
227 
228         // fire event
229         emit onWithdraw(_customerAddress, _dividends);
230     }
231 
232     /// @dev Liquifies tokens to ethereum.
233     function sell(uint256 _amountOfTokens) onlyBagholders public {
234         // setup data
235         address _customerAddress = msg.sender;
236         // russian hackers BTFO
237         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
238         uint256 _tokens = _amountOfTokens;
239         uint256 _ethereum = tokensToEthereum_(_tokens);
240         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
241         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
242 
243         // burn the sold tokens
244         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
245         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
246 
247         // update dividends tracker
248         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
249         payoutsTo_[_customerAddress] -= _updatedPayouts;
250 
251         // dividing by zero is a bad idea
252         if (tokenSupply_ > 0) {
253             // update the amount of dividends per token
254             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
255         }
256 
257         // fire event
258         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
259     }
260 
261 
262     /**
263      * @dev Transfer tokens from the caller to a new holder.
264      */
265     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
266         // setup
267         address _customerAddress = msg.sender;
268 
269         // make sure we have the requested tokens
270         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
271 
272         // withdraw all outstanding dividends first
273         if (myDividends(true) > 0) {
274             withdraw();
275         }
276 
277         // exchange tokens
278         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
279         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
280 
281         // update dividend trackers
282         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
283         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
284 
285         // fire event
286         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
287 
288         // ERC20
289         return true;
290     }
291 
292 
293     /*=====================================
294     =      HELPERS AND CALCULATORS        =
295     =====================================*/
296 
297     /**
298      * @dev Method to view the current Ethereum stored in the contract
299      *  Example: totalEthereumBalance()
300      */
301     function totalEthereumBalance() public view returns (uint256) {
302         return address(this).balance;
303     }
304 
305     /// @dev Retrieve the total token supply.
306     function totalSupply() public view returns (uint256) {
307         return tokenSupply_;
308     }
309 
310     /// @dev Retrieve the tokens owned by the caller.
311     function myTokens() public view returns (uint256) {
312         address _customerAddress = msg.sender;
313         return balanceOf(_customerAddress);
314     }
315 
316     /**
317      * @dev Retrieve the dividends owned by the caller.
318      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
319      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
320      *  But in the internal calculations, we want them separate.
321      */
322     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
323         address _customerAddress = msg.sender;
324         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
325     }
326 
327     /// @dev Retrieve the token balance of any single address.
328     function balanceOf(address _customerAddress) public view returns (uint256) {
329         return tokenBalanceLedger_[_customerAddress];
330     }
331 
332     /// @dev Retrieve the dividend balance of any single address.
333     function dividendsOf(address _customerAddress) public view returns (uint256) {
334         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
335     }
336 
337     /// @dev Return the sell price of 1 individual token.
338     function sellPrice() public view returns (uint256) {
339         // our calculation relies on the token supply, so we need supply. Doh.
340         if (tokenSupply_ == 0) {
341             return tokenPriceInitial_ - tokenPriceIncremental_;
342         } else {
343             uint256 _ethereum = tokensToEthereum_(1e18);
344             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
345             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
346 
347             return _taxedEthereum;
348         }
349     }
350 
351     /// @dev Return the buy price of 1 individual token.
352     function buyPrice() public view returns (uint256) {
353         // our calculation relies on the token supply, so we need supply. Doh.
354         if (tokenSupply_ == 0) {
355             return tokenPriceInitial_ + tokenPriceIncremental_;
356         } else {
357             uint256 _ethereum = tokensToEthereum_(1e18);
358             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
359             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
360 
361             return _taxedEthereum;
362         }
363     }
364 
365     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
366     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
367         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
368         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
369         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
370         return _amountOfTokens;
371     }
372 
373     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
374     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
375         require(_tokensToSell <= tokenSupply_);
376         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
377         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
378         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
379         return _taxedEthereum;
380     }
381 
382     /// @dev Function for the frontend to get untaxed receivable ethereum.
383     function calculateUntaxedEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
384         require(_tokensToSell <= tokenSupply_);
385         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
386         //uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
387         //uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
388         return _ethereum;
389     }
390 
391 
392     /// @dev Function for getting the current exitFee
393     function exitFee() public view returns (uint8) {
394         if (startTime==0){
395            return startExitFee_;
396         }
397         if ( now < startTime) {
398           return 0;
399         }
400         uint256 secondsPassed = now - startTime;
401         if (secondsPassed >= exitFeeFallDuration_) {
402             return finalExitFee_;
403         }
404         uint8 totalChange = startExitFee_ - finalExitFee_;
405         uint8 currentChange = uint8(totalChange * secondsPassed / exitFeeFallDuration_);
406         uint8 currentFee = startExitFee_- currentChange;
407         return currentFee;
408     }
409 
410     // @dev Function for find if premine
411     function isPremine() public view returns (bool) {
412       return depositCount_<=0;
413     }
414 
415     // @dev Function for find if premine
416     function isStarted() public view returns (bool) {
417       return startTime!=0 && now > startTime;
418     }
419 
420     /*==========================================
421     =            INTERNAL FUNCTIONS            =
422     ==========================================*/
423 
424     /// @dev Internal function to actually purchase the tokens.
425     function purchaseTokens(uint256 _incomingEthereum, address _referredBy , address _customerAddress) internal returns (uint256) {
426         // data setup
427         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
428         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
429         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
430         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
431         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
432         uint256 _fee = _dividends * magnitude;
433 
434         // no point in continuing execution if OP is a poorfag russian hacker
435         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
436         // (or hackers)
437         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
438         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
439 
440         // is the user referred by a masternode?
441         if (
442             // is this a referred purchase?
443             _referredBy != 0x0000000000000000000000000000000000000000 &&
444 
445             // no cheating!
446             _referredBy != _customerAddress &&
447 
448             // does the referrer have at least X whole tokens?
449             // i.e is the referrer a godly chad masternode
450             tokenBalanceLedger_[_referredBy] >= stakingRequirement
451         ) {
452             // wealth redistribution
453             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
454         } else {
455             // no ref purchase
456             // add the referral bonus back to the global dividends cake
457             _dividends = SafeMath.add(_dividends, _referralBonus);
458             _fee = _dividends * magnitude;
459         }
460 
461         // we can't give people infinite ethereum
462         if (tokenSupply_ > 0) {
463             // add tokens to the pool
464             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
465 
466             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
467             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
468 
469             // calculate the amount of tokens the customer receives over his purchase
470             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
471         } else {
472             // add tokens to the pool
473             tokenSupply_ = _amountOfTokens;
474         }
475 
476         // update circulating supply & the ledger address for the customer
477         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
478 
479         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
480         // really i know you think you do but you don't
481         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
482         payoutsTo_[_customerAddress] += _updatedPayouts;
483 
484         // fire event
485         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
486 
487         // Keep track
488         depositCount_++;
489         return _amountOfTokens;
490     }
491 
492     /**
493      * @dev Calculate Token price based on an amount of incoming ethereum
494      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
495      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
496      */
497     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
498         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
499         uint256 _tokensReceived =
500          (
501             (
502                 // underflow attempts BTFO
503                 SafeMath.sub(
504                     (sqrt
505                         (
506                             (_tokenPriceInitial ** 2)
507                             +
508                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
509                             +
510                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
511                             +
512                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
513                         )
514                     ), _tokenPriceInitial
515                 )
516             ) / (tokenPriceIncremental_)
517         ) - (tokenSupply_);
518 
519         return _tokensReceived;
520     }
521 
522     /**
523      * @dev Calculate token sell value.
524      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
525      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
526      */
527     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
528         uint256 tokens_ = (_tokens + 1e18);
529         uint256 _tokenSupply = (tokenSupply_ + 1e18);
530         uint256 _etherReceived =
531         (
532             // underflow attempts BTFO
533             SafeMath.sub(
534                 (
535                     (
536                         (
537                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
538                         ) - tokenPriceIncremental_
539                     ) * (tokens_ - 1e18)
540                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
541             )
542         / 1e18);
543 
544         return _etherReceived;
545     }
546 
547     /// @dev This is where all your gas goes.
548     function sqrt(uint256 x) internal pure returns (uint256 y) {
549         uint256 z = (x + 1) / 2;
550         y = x;
551 
552         while (z < y) {
553             y = z;
554             z = (x / z + z) / 2;
555         }
556     }
557 
558 
559 }
560 
561 /**
562  * @title SafeMath
563  * @dev Math operations with safety checks that throw on error
564  */
565 library SafeMath {
566 
567     /**
568     * @dev Multiplies two numbers, throws on overflow.
569     */
570     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
571         if (a == 0) {
572             return 0;
573         }
574         uint256 c = a * b;
575         assert(c / a == b);
576         return c;
577     }
578 
579     /**
580     * @dev Integer division of two numbers, truncating the quotient.
581     */
582     function div(uint256 a, uint256 b) internal pure returns (uint256) {
583         // assert(b > 0); // Solidity automatically throws when dividing by 0
584         uint256 c = a / b;
585         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
586         return c;
587     }
588 
589     /**
590     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
591     */
592     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
593         assert(b <= a);
594         return a - b;
595     }
596 
597     /**
598     * @dev Adds two numbers, throws on overflow.
599     */
600     function add(uint256 a, uint256 b) internal pure returns (uint256) {
601         uint256 c = a + b;
602         assert(c >= a);
603         return c;
604     }
605 
606 }