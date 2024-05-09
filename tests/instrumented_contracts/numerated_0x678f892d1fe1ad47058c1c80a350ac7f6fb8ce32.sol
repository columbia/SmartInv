1 pragma solidity ^0.4.24;
2 
3 
4 contract apexPlatinum {
5 
6     /*=================================
7     =            MODIFIERS            =
8     =================================*/
9 
10     /// @dev Only people with tokens
11     modifier onlyBagholders {
12         require(myTokens() > 0);
13         _;
14     }
15 
16     /// @dev Only people with profits
17     modifier onlyStronghands {
18         require(myDividends(true) > 0);
19         _;
20     }
21 
22     /// @dev notGasbag
23     modifier notGasbag() {
24       require(tx.gasprice < 200999999999);
25       _;
26     }
27 
28     /// @dev Preventing unstable dumping and limit ambassador mine
29     modifier antiEarlyWhale {
30         if (address(this).balance  -msg.value < whaleBalanceLimit){
31           require(msg.value <= maxEarlyStake);
32         }
33         if (depositCount_ == 0){
34           require(ambassadors_[msg.sender] && msg.value == 0.5 ether);
35         }else
36         if (depositCount_ < 6){
37           require(ambassadors_[msg.sender] && msg.value == 0.3 ether);
38         }else
39         if (depositCount_ == 6 || depositCount_==7){
40           require(ambassadors_[msg.sender] && msg.value == 0.51 ether);
41         }
42         _;
43     }
44 
45     /// @dev notGasbag
46     modifier isControlled() {
47       require(isPremine() || isStarted());
48       _;
49     }
50 
51     /*==============================
52     =            EVENTS            =
53     ==============================*/
54 
55     event onTokenPurchase(
56         address indexed customerAddress,
57         uint256 incomingEthereum,
58         uint256 tokensMinted,
59         address indexed referredBy,
60         uint timestamp,
61         uint256 price
62     );
63 
64     event onTokenSell(
65         address indexed customerAddress,
66         uint256 tokensBurned,
67         uint256 ethereumEarned,
68         uint timestamp,
69         uint256 price
70     );
71 
72     event onReinvestment(
73         address indexed customerAddress,
74         uint256 ethereumReinvested,
75         uint256 tokensMinted
76     );
77 
78     event onWithdraw(
79         address indexed customerAddress,
80         uint256 ethereumWithdrawn
81     );
82 
83     // ERC20
84     event Transfer(
85         address indexed from,
86         address indexed to,
87         uint256 tokens
88     );
89 
90 
91     /*=====================================
92     =            CONFIGURABLES            =
93     =====================================*/
94 
95     string public name = "apex Platinium";
96     string public symbol = "AXP";
97     uint8 constant public decimals = 18;
98 
99     /// @dev 12% dividends for token purchase
100     uint8 constant internal entryFee_ = 12;
101 
102     /// @dev 48% dividends for token selling
103     uint8 constant internal startExitFee_ = 48;
104 
105     /// @dev 12% dividends for token selling after step
106     uint8 constant internal finalExitFee_ = 12;
107 
108     /// @dev Exit fee falls over period of 30 days
109     uint256 constant internal exitFeeFallDuration_ = 30 days;
110 
111     /// @dev 12% masternode
112     uint8 constant internal refferalFee_ = 12;
113 
114     /// @dev P3D pricing
115     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
116     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
117 
118     uint256 constant internal magnitude = 2 ** 64;
119 
120     /// @dev 100 needed for masternode activation
121     uint256 public stakingRequirement = 100e18;
122 
123     /// @dev anti-early-whale
124     uint256 public maxEarlyStake = 2.5 ether;
125     uint256 public whaleBalanceLimit = 75 ether;
126 
127     /// @dev apex starting gun
128     address public apex;
129 
130     /// @dev starting
131     uint256 public startTime = 0; //  January 1, 1970 12:00:00
132 
133    /*=================================
134     =            DATASETS            =
135     ================================*/
136 
137     // amount of shares for each address (scaled number)
138     mapping(address => uint256) internal tokenBalanceLedger_;
139     mapping(address => uint256) internal referralBalance_;
140     mapping(address => uint256) internal bonusBalance_;
141     mapping(address => int256) internal payoutsTo_;
142     uint256 internal tokenSupply_;
143     uint256 internal profitPerShare_;
144     uint256 public depositCount_;
145 
146     mapping(address => bool) internal ambassadors_;
147 
148     /*=======================================
149     =            CONSTRUCTOR                =
150     =======================================*/
151 
152    constructor () public {
153 
154      //Community Promotional Fund
155      ambassadors_[msg.sender]=true;
156      //1
157      ambassadors_[0xAD171996c9B9d7a188133057b7Bd2563edd02b14]=true;
158      //2
159      ambassadors_[0x28B98FAEAe05Cb2cAcEc36d09Bdf3d19dD1F799e]=true;
160      //3
161      ambassadors_[0xD3FF623172d6B143C607d8771936E2c05DEEf9D0]=true;
162      //4
163      ambassadors_[0xB32435C63151527AFDdF82BE9Edd88f37f7413D3]=true;
164      //5
165      ambassadors_[0xE5c1C106F920e1594327c27690B64A5dc5eB033e]=true;
166      //6
167      ambassadors_[0x5fcb488584e3b63FAb9A29142ee2Fb149979eEfd]=true;
168      //7
169      ambassadors_[0x966518F716896513d6a89fF52a4dEE5eF2BF1870]=true;
170 
171      apex = msg.sender;
172    }
173 
174     /*=======================================
175     =            PUBLIC FUNCTIONS           =
176     =======================================*/
177 
178     // @dev Function setting the start time of the system
179     function setStartTime(uint256 _startTime) public {
180       require(msg.sender==apex && !isStarted() && now < _startTime);
181       startTime = _startTime;
182     }
183 
184     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
185     function buy(address _referredBy) antiEarlyWhale notGasbag isControlled public payable  returns (uint256) {
186         purchaseTokens(msg.value, _referredBy , msg.sender);
187     }
188 
189     /// @dev Converts to tokens on behalf of the customer - this allows gifting and integration with other systems
190     function buyFor(address _referredBy, address _customerAddress) antiEarlyWhale notGasbag isControlled public payable returns (uint256) {
191         purchaseTokens(msg.value, _referredBy , _customerAddress);
192     }
193 
194     /**
195      * @dev Fallback function to handle ethereum that was send straight to the contract
196      *  Unfortunately we cannot use a referral address this way.
197      */
198     function() antiEarlyWhale notGasbag isControlled payable public {
199         purchaseTokens(msg.value, 0x0 , msg.sender);
200     }
201 
202     /// @dev Converts all of caller's dividends to tokens.
203     function reinvest() onlyStronghands public {
204         // fetch dividends
205         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
206 
207         // pay out the dividends virtually
208         address _customerAddress = msg.sender;
209         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
210 
211         // retrieve ref. bonus
212         _dividends += referralBalance_[_customerAddress];
213         referralBalance_[_customerAddress] = 0;
214 
215         // dispatch a buy order with the virtualized "withdrawn dividends"
216         uint256 _tokens = purchaseTokens(_dividends, 0x0 , _customerAddress);
217 
218         // fire event
219         emit onReinvestment(_customerAddress, _dividends, _tokens);
220     }
221 
222     /// @dev Alias of sell() and withdraw().
223     function exit() public {
224         // get token count for caller & sell them all
225         address _customerAddress = msg.sender;
226         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
227         if (_tokens > 0) sell(_tokens);
228 
229         // capitulation
230         withdraw();
231     }
232 
233     /// @dev Withdraws all of the callers earnings.
234     function withdraw() onlyStronghands public {
235         // setup data
236         address _customerAddress = msg.sender;
237         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
238 
239         // update dividend tracker
240         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
241 
242         // add ref. bonus
243         _dividends += referralBalance_[_customerAddress];
244         referralBalance_[_customerAddress] = 0;
245 
246         // lambo delivery service
247         _customerAddress.transfer(_dividends);
248 
249         // fire event
250         emit onWithdraw(_customerAddress, _dividends);
251     }
252 
253     /// @dev Liquifies tokens to ethereum.
254     function sell(uint256 _amountOfTokens) onlyBagholders public {
255         // setup data
256         address _customerAddress = msg.sender;
257         // russian hackers BTFO
258         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
259         uint256 _tokens = _amountOfTokens;
260         uint256 _ethereum = tokensToEthereum_(_tokens);
261         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
262         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
263 
264         // burn the sold tokens
265         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
266         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
267 
268         // update dividends tracker
269         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
270         payoutsTo_[_customerAddress] -= _updatedPayouts;
271 
272         // dividing by zero is a bad idea
273         if (tokenSupply_ > 0) {
274             // update the amount of dividends per token
275             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
276         }
277 
278         // fire event
279         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
280     }
281 
282 
283     /**
284      * @dev Transfer tokens from the caller to a new holder.
285      */
286     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
287         // setup
288         address _customerAddress = msg.sender;
289 
290         // make sure we have the requested tokens
291         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
292 
293         // withdraw all outstanding dividends first
294         if (myDividends(true) > 0) {
295             withdraw();
296         }
297 
298         // exchange tokens
299         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
300         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
301 
302         // update dividend trackers
303         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
304         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
305 
306         // fire event
307         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
308 
309         // ERC20
310         return true;
311     }
312 
313 
314     /*=====================================
315     =      HELPERS AND CALCULATORS        =
316     =====================================*/
317 
318     /**
319      * @dev Method to view the current Ethereum stored in the contract
320      *  Example: totalEthereumBalance()
321      */
322     function totalEthereumBalance() public view returns (uint256) {
323         return address(this).balance;
324     }
325 
326     /// @dev Retrieve the total token supply.
327     function totalSupply() public view returns (uint256) {
328         return tokenSupply_;
329     }
330 
331     /// @dev Retrieve the tokens owned by the caller.
332     function myTokens() public view returns (uint256) {
333         address _customerAddress = msg.sender;
334         return balanceOf(_customerAddress);
335     }
336 
337     /**
338      * @dev Retrieve the dividends owned by the caller.
339      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
340      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
341      *  But in the internal calculations, we want them separate.
342      */
343     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
344         address _customerAddress = msg.sender;
345         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
346     }
347 
348     /// @dev Retrieve the token balance of any single address.
349     function balanceOf(address _customerAddress) public view returns (uint256) {
350         return tokenBalanceLedger_[_customerAddress];
351     }
352 
353     /// @dev Retrieve the dividend balance of any single address.
354     function dividendsOf(address _customerAddress) public view returns (uint256) {
355         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
356     }
357 
358     /// @dev Return the sell price of 1 individual token.
359     function sellPrice() public view returns (uint256) {
360         // our calculation relies on the token supply, so we need supply. Doh.
361         if (tokenSupply_ == 0) {
362             return tokenPriceInitial_ - tokenPriceIncremental_;
363         } else {
364             uint256 _ethereum = tokensToEthereum_(1e18);
365             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
366             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
367 
368             return _taxedEthereum;
369         }
370     }
371 
372     /// @dev Return the buy price of 1 individual token.
373     function buyPrice() public view returns (uint256) {
374         // our calculation relies on the token supply, so we need supply. Doh.
375         if (tokenSupply_ == 0) {
376             return tokenPriceInitial_ + tokenPriceIncremental_;
377         } else {
378             uint256 _ethereum = tokensToEthereum_(1e18);
379             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
380             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
381 
382             return _taxedEthereum;
383         }
384     }
385 
386     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
387     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
388         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
389         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
390         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
391         return _amountOfTokens;
392     }
393 
394     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
395     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
396         require(_tokensToSell <= tokenSupply_);
397         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
398         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
399         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
400         return _taxedEthereum;
401     }
402 
403     /// @dev Function for the frontend to get untaxed receivable ethereum.
404     function calculateUntaxedEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
405         require(_tokensToSell <= tokenSupply_);
406         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
407         //uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
408         //uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
409         return _ethereum;
410     }
411 
412 
413     /// @dev Function for getting the current exitFee
414     function exitFee() public view returns (uint8) {
415         if (startTime==0){
416            return startExitFee_;
417         }
418         if ( now < startTime) {
419           return 0;
420         }
421         uint256 secondsPassed = now - startTime;
422         if (secondsPassed >= exitFeeFallDuration_) {
423             return finalExitFee_;
424         }
425         uint8 totalChange = startExitFee_ - finalExitFee_;
426         uint8 currentChange = uint8(totalChange * secondsPassed / exitFeeFallDuration_);
427         uint8 currentFee = startExitFee_- currentChange;
428         return currentFee;
429     }
430 
431     // @dev Function for find if premine
432     function isPremine() public view returns (bool) {
433       return depositCount_<=7;
434     }
435 
436     // @dev Function for find if premine
437     function isStarted() public view returns (bool) {
438       return startTime!=0 && now > startTime;
439     }
440 
441     /*==========================================
442     =            INTERNAL FUNCTIONS            =
443     ==========================================*/
444 
445     /// @dev Internal function to actually purchase the tokens.
446     function purchaseTokens(uint256 _incomingEthereum, address _referredBy , address _customerAddress) internal returns (uint256) {
447         // data setup
448         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
449         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
450         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
451         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
452         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
453         uint256 _fee = _dividends * magnitude;
454 
455         // no point in continuing execution if OP is a poorfag russian hacker
456         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
457         // (or hackers)
458         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
459         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
460 
461         // is the user referred by a masternode?
462         if (
463             // is this a referred purchase?
464             _referredBy != 0x0000000000000000000000000000000000000000 &&
465 
466             // no cheating!
467             _referredBy != _customerAddress &&
468 
469             // does the referrer have at least X whole tokens?
470             // i.e is the referrer a godly chad masternode
471             tokenBalanceLedger_[_referredBy] >= stakingRequirement
472         ) {
473             // wealth redistribution
474             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
475         } else {
476             // no ref purchase
477             // add the referral bonus back to the global dividends cake
478             _dividends = SafeMath.add(_dividends, _referralBonus);
479             _fee = _dividends * magnitude;
480         }
481 
482         // we can't give people infinite ethereum
483         if (tokenSupply_ > 0) {
484             // add tokens to the pool
485             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
486 
487             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
488             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
489 
490             // calculate the amount of tokens the customer receives over his purchase
491             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
492         } else {
493             // add tokens to the pool
494             tokenSupply_ = _amountOfTokens;
495         }
496 
497         // update circulating supply & the ledger address for the customer
498         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
499 
500         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
501         // really i know you think you do but you don't
502         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
503         payoutsTo_[_customerAddress] += _updatedPayouts;
504 
505         // fire event
506         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
507 
508         // Keep track
509         depositCount_++;
510         return _amountOfTokens;
511     }
512 
513     /**
514      * @dev Calculate Token price based on an amount of incoming ethereum
515      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
516      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
517      */
518     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
519         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
520         uint256 _tokensReceived =
521          (
522             (
523                 // underflow attempts BTFO
524                 SafeMath.sub(
525                     (sqrt
526                         (
527                             (_tokenPriceInitial ** 2)
528                             +
529                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
530                             +
531                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
532                             +
533                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
534                         )
535                     ), _tokenPriceInitial
536                 )
537             ) / (tokenPriceIncremental_)
538         ) - (tokenSupply_);
539 
540         return _tokensReceived;
541     }
542 
543     /**
544      * @dev Calculate token sell value.
545      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
546      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
547      */
548     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
549         uint256 tokens_ = (_tokens + 1e18);
550         uint256 _tokenSupply = (tokenSupply_ + 1e18);
551         uint256 _etherReceived =
552         (
553             // underflow attempts BTFO
554             SafeMath.sub(
555                 (
556                     (
557                         (
558                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
559                         ) - tokenPriceIncremental_
560                     ) * (tokens_ - 1e18)
561                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
562             )
563         / 1e18);
564 
565         return _etherReceived;
566     }
567 
568     /// @dev This is where all your gas goes.
569     function sqrt(uint256 x) internal pure returns (uint256 y) {
570         uint256 z = (x + 1) / 2;
571         y = x;
572 
573         while (z < y) {
574             y = z;
575             z = (x / z + z) / 2;
576         }
577     }
578 
579 
580 }
581 
582 /**
583  * @title SafeMath
584  * @dev Math operations with safety checks that throw on error
585  */
586 library SafeMath {
587 
588     /**
589     * @dev Multiplies two numbers, throws on overflow.
590     */
591     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
592         if (a == 0) {
593             return 0;
594         }
595         uint256 c = a * b;
596         assert(c / a == b);
597         return c;
598     }
599 
600     /**
601     * @dev Integer division of two numbers, truncating the quotient.
602     */
603     function div(uint256 a, uint256 b) internal pure returns (uint256) {
604         // assert(b > 0); // Solidity automatically throws when dividing by 0
605         uint256 c = a / b;
606         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
607         return c;
608     }
609 
610     /**
611     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
612     */
613     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
614         assert(b <= a);
615         return a - b;
616     }
617 
618     /**
619     * @dev Adds two numbers, throws on overflow.
620     */
621     function add(uint256 a, uint256 b) internal pure returns (uint256) {
622         uint256 c = a + b;
623         assert(c >= a);
624         return c;
625     }
626 
627 }