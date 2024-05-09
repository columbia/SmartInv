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
15 contract apexTWO {
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
45           require(ambassadors_[msg.sender] && msg.value == 0.001 ether);
46         }else
47         if (depositCount_ == 1 || depositCount_==2){
48           require(ambassadors_[msg.sender] && msg.value == 0.002 ether);
49         }
50         _;
51     }
52 
53     /// @dev notGasbag
54     modifier isControlled() {
55       require(isPremine() || isStarted());
56       _;
57     }
58 
59     /*==============================
60     =            EVENTS            =
61     ==============================*/
62 
63     event onTokenPurchase(
64         address indexed customerAddress,
65         uint256 incomingEthereum,
66         uint256 tokensMinted,
67         address indexed referredBy,
68         uint timestamp,
69         uint256 price
70     );
71 
72     event onTokenSell(
73         address indexed customerAddress,
74         uint256 tokensBurned,
75         uint256 ethereumEarned,
76         uint timestamp,
77         uint256 price
78     );
79 
80     event onReinvestment(
81         address indexed customerAddress,
82         uint256 ethereumReinvested,
83         uint256 tokensMinted
84     );
85 
86     event onWithdraw(
87         address indexed customerAddress,
88         uint256 ethereumWithdrawn
89     );
90 
91     // ERC20
92     event Transfer(
93         address indexed from,
94         address indexed to,
95         uint256 tokens
96     );
97 
98 
99     /*=====================================
100     =            CONFIGURABLES            =
101     =====================================*/
102 
103     string public name = "apexTWO Token";
104     string public symbol = "APX2";
105     uint8 constant public decimals = 18;
106 
107     /// @dev 12% dividends for token purchase
108     uint8 constant internal entryFee_ = 12;
109 
110     /// @dev 48% dividends for token selling
111     uint8 constant internal startExitFee_ = 48;
112 
113     /// @dev 12% dividends for token selling after step
114     uint8 constant internal finalExitFee_ = 12;
115 
116     /// @dev Exit fee falls over period of 30 days
117     uint256 constant internal exitFeeFallDuration_ = 30 days;
118 
119     /// @dev 12% masternode
120     uint8 constant internal refferalFee_ = 12;
121 
122     /// @dev P3D pricing
123     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
124     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
125 
126     uint256 constant internal magnitude = 2 ** 64;
127 
128     /// @dev 100 needed for masternode activation
129     uint256 public stakingRequirement = 100e18;
130 
131     /// @dev anti-early-whale
132     uint256 public maxEarlyStake = 0.1 ether;
133     uint256 public whaleBalanceLimit = 75 ether;
134 
135     /// @dev apex starting gun
136     address public apex;
137 
138     /// @dev starting
139     uint256 public startTime = 0; //  January 1, 1970 12:00:00
140 
141    /*=================================
142     =            DATASETS            =
143     ================================*/
144 
145     // amount of shares for each address (scaled number)
146     mapping(address => uint256) internal tokenBalanceLedger_;
147     mapping(address => uint256) internal referralBalance_;
148     mapping(address => uint256) internal bonusBalance_;
149     mapping(address => int256) internal payoutsTo_;
150     uint256 internal tokenSupply_;
151     uint256 internal profitPerShare_;
152     uint256 public depositCount_;
153 
154     mapping(address => bool) internal ambassadors_;
155 
156     /*=======================================
157     =            CONSTRUCTOR                =
158     =======================================*/
159 
160    constructor () public {
161 
162      //Community Promotional Fund
163      ambassadors_[msg.sender]=true;
164      //1
165      ambassadors_[0x250F9cD6D75C8CDc34183a51b68ed727B86C1b41]=true;
166      //2
167      ambassadors_[0xb41342AE9432ee1DE63402766c6c0d9b460f7Eb4]=true;
168 
169      apex = msg.sender;
170    }
171 
172     /*=======================================
173     =            PUBLIC FUNCTIONS           =
174     =======================================*/
175 
176     // @dev Function setting the start time of the system
177     function setStartTime(uint256 _startTime) public {
178       require(msg.sender==apex && !isStarted() && now < _startTime);
179       startTime = _startTime;
180     }
181 
182     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
183     function buy(address _referredBy) antiEarlyWhale notGasbag isControlled public payable  returns (uint256) {
184         purchaseTokens(msg.value, _referredBy , msg.sender);
185     }
186 
187     /// @dev Converts to tokens on behalf of the customer - this allows gifting and integration with other systems
188     function buyFor(address _referredBy, address _customerAddress) antiEarlyWhale notGasbag isControlled public payable returns (uint256) {
189         purchaseTokens(msg.value, _referredBy , _customerAddress);
190     }
191 
192     /**
193      * @dev Fallback function to handle ethereum that was send straight to the contract
194      *  Unfortunately we cannot use a referral address this way.
195      */
196     function() antiEarlyWhale notGasbag isControlled payable public {
197         purchaseTokens(msg.value, 0x0 , msg.sender);
198     }
199 
200     /// @dev Converts all of caller's dividends to tokens.
201     function reinvest() onlyStronghands public {
202         // fetch dividends
203         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
204 
205         // pay out the dividends virtually
206         address _customerAddress = msg.sender;
207         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
208 
209         // retrieve ref. bonus
210         _dividends += referralBalance_[_customerAddress];
211         referralBalance_[_customerAddress] = 0;
212 
213         // dispatch a buy order with the virtualized "withdrawn dividends"
214         uint256 _tokens = purchaseTokens(_dividends, 0x0 , _customerAddress);
215 
216         // fire event
217         emit onReinvestment(_customerAddress, _dividends, _tokens);
218     }
219 
220     /// @dev Alias of sell() and withdraw().
221     function exit() public {
222         // get token count for caller & sell them all
223         address _customerAddress = msg.sender;
224         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
225         if (_tokens > 0) sell(_tokens);
226 
227         // capitulation
228         withdraw();
229     }
230 
231     /// @dev Withdraws all of the callers earnings.
232     function withdraw() onlyStronghands public {
233         // setup data
234         address _customerAddress = msg.sender;
235         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
236 
237         // update dividend tracker
238         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
239 
240         // add ref. bonus
241         _dividends += referralBalance_[_customerAddress];
242         referralBalance_[_customerAddress] = 0;
243 
244         // lambo delivery service
245         _customerAddress.transfer(_dividends);
246 
247         // fire event
248         emit onWithdraw(_customerAddress, _dividends);
249     }
250 
251     /// @dev Liquifies tokens to ethereum.
252     function sell(uint256 _amountOfTokens) onlyBagholders public {
253         // setup data
254         address _customerAddress = msg.sender;
255         // russian hackers BTFO
256         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
257         uint256 _tokens = _amountOfTokens;
258         uint256 _ethereum = tokensToEthereum_(_tokens);
259         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
260         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
261 
262         // burn the sold tokens
263         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
264         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
265 
266         // update dividends tracker
267         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
268         payoutsTo_[_customerAddress] -= _updatedPayouts;
269 
270         // dividing by zero is a bad idea
271         if (tokenSupply_ > 0) {
272             // update the amount of dividends per token
273             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
274         }
275 
276         // fire event
277         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
278     }
279 
280 
281     /**
282      * @dev Transfer tokens from the caller to a new holder.
283      */
284     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
285         // setup
286         address _customerAddress = msg.sender;
287 
288         // make sure we have the requested tokens
289         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
290 
291         // withdraw all outstanding dividends first
292         if (myDividends(true) > 0) {
293             withdraw();
294         }
295 
296         // exchange tokens
297         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
298         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
299 
300         // update dividend trackers
301         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
302         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
303 
304         // fire event
305         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
306 
307         // ERC20
308         return true;
309     }
310 
311 
312     /*=====================================
313     =      HELPERS AND CALCULATORS        =
314     =====================================*/
315 
316     /**
317      * @dev Method to view the current Ethereum stored in the contract
318      *  Example: totalEthereumBalance()
319      */
320     function totalEthereumBalance() public view returns (uint256) {
321         return address(this).balance;
322     }
323 
324     /// @dev Retrieve the total token supply.
325     function totalSupply() public view returns (uint256) {
326         return tokenSupply_;
327     }
328 
329     /// @dev Retrieve the tokens owned by the caller.
330     function myTokens() public view returns (uint256) {
331         address _customerAddress = msg.sender;
332         return balanceOf(_customerAddress);
333     }
334 
335     /**
336      * @dev Retrieve the dividends owned by the caller.
337      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
338      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
339      *  But in the internal calculations, we want them separate.
340      */
341     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
342         address _customerAddress = msg.sender;
343         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
344     }
345 
346     /// @dev Retrieve the token balance of any single address.
347     function balanceOf(address _customerAddress) public view returns (uint256) {
348         return tokenBalanceLedger_[_customerAddress];
349     }
350 
351     /// @dev Retrieve the dividend balance of any single address.
352     function dividendsOf(address _customerAddress) public view returns (uint256) {
353         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
354     }
355 
356     /// @dev Return the sell price of 1 individual token.
357     function sellPrice() public view returns (uint256) {
358         // our calculation relies on the token supply, so we need supply. Doh.
359         if (tokenSupply_ == 0) {
360             return tokenPriceInitial_ - tokenPriceIncremental_;
361         } else {
362             uint256 _ethereum = tokensToEthereum_(1e18);
363             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
364             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
365 
366             return _taxedEthereum;
367         }
368     }
369 
370     /// @dev Return the buy price of 1 individual token.
371     function buyPrice() public view returns (uint256) {
372         // our calculation relies on the token supply, so we need supply. Doh.
373         if (tokenSupply_ == 0) {
374             return tokenPriceInitial_ + tokenPriceIncremental_;
375         } else {
376             uint256 _ethereum = tokensToEthereum_(1e18);
377             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
378             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
379 
380             return _taxedEthereum;
381         }
382     }
383 
384     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
385     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
386         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
387         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
388         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
389         return _amountOfTokens;
390     }
391 
392     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
393     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
394         require(_tokensToSell <= tokenSupply_);
395         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
396         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
397         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
398         return _taxedEthereum;
399     }
400 
401     /// @dev Function for the frontend to get untaxed receivable ethereum.
402     function calculateUntaxedEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
403         require(_tokensToSell <= tokenSupply_);
404         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
405         //uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
406         //uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
407         return _ethereum;
408     }
409 
410 
411     /// @dev Function for getting the current exitFee
412     function exitFee() public view returns (uint8) {
413         if (startTime==0){
414            return startExitFee_;
415         }
416         if ( now < startTime) {
417           return 0;
418         }
419         uint256 secondsPassed = now - startTime;
420         if (secondsPassed >= exitFeeFallDuration_) {
421             return finalExitFee_;
422         }
423         uint8 totalChange = startExitFee_ - finalExitFee_;
424         uint8 currentChange = uint8(totalChange * secondsPassed / exitFeeFallDuration_);
425         uint8 currentFee = startExitFee_- currentChange;
426         return currentFee;
427     }
428 
429     // @dev Function for find if premine
430     function isPremine() public view returns (bool) {
431       return depositCount_<=7;
432     }
433 
434     // @dev Function for find if premine
435     function isStarted() public view returns (bool) {
436       return startTime!=0 && now > startTime;
437     }
438 
439     /*==========================================
440     =            INTERNAL FUNCTIONS            =
441     ==========================================*/
442 
443     /// @dev Internal function to actually purchase the tokens.
444     function purchaseTokens(uint256 _incomingEthereum, address _referredBy , address _customerAddress) internal returns (uint256) {
445         // data setup
446         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
447         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
448         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
449         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
450         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
451         uint256 _fee = _dividends * magnitude;
452 
453         // no point in continuing execution if OP is a poorfag russian hacker
454         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
455         // (or hackers)
456         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
457         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
458 
459         // is the user referred by a masternode?
460         if (
461             // is this a referred purchase?
462             _referredBy != 0x0000000000000000000000000000000000000000 &&
463 
464             // no cheating!
465             _referredBy != _customerAddress &&
466 
467             // does the referrer have at least X whole tokens?
468             // i.e is the referrer a godly chad masternode
469             tokenBalanceLedger_[_referredBy] >= stakingRequirement
470         ) {
471             // wealth redistribution
472             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
473         } else {
474             // no ref purchase
475             // add the referral bonus back to the global dividends cake
476             _dividends = SafeMath.add(_dividends, _referralBonus);
477             _fee = _dividends * magnitude;
478         }
479 
480         // we can't give people infinite ethereum
481         if (tokenSupply_ > 0) {
482             // add tokens to the pool
483             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
484 
485             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
486             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
487 
488             // calculate the amount of tokens the customer receives over his purchase
489             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
490         } else {
491             // add tokens to the pool
492             tokenSupply_ = _amountOfTokens;
493         }
494 
495         // update circulating supply & the ledger address for the customer
496         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
497 
498         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
499         // really i know you think you do but you don't
500         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
501         payoutsTo_[_customerAddress] += _updatedPayouts;
502 
503         // fire event
504         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
505 
506         // Keep track
507         depositCount_++;
508         return _amountOfTokens;
509     }
510 
511     /**
512      * @dev Calculate Token price based on an amount of incoming ethereum
513      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
514      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
515      */
516     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
517         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
518         uint256 _tokensReceived =
519          (
520             (
521                 // underflow attempts BTFO
522                 SafeMath.sub(
523                     (sqrt
524                         (
525                             (_tokenPriceInitial ** 2)
526                             +
527                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
528                             +
529                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
530                             +
531                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
532                         )
533                     ), _tokenPriceInitial
534                 )
535             ) / (tokenPriceIncremental_)
536         ) - (tokenSupply_);
537 
538         return _tokensReceived;
539     }
540 
541     /**
542      * @dev Calculate token sell value.
543      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
544      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
545      */
546     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
547         uint256 tokens_ = (_tokens + 1e18);
548         uint256 _tokenSupply = (tokenSupply_ + 1e18);
549         uint256 _etherReceived =
550         (
551             // underflow attempts BTFO
552             SafeMath.sub(
553                 (
554                     (
555                         (
556                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
557                         ) - tokenPriceIncremental_
558                     ) * (tokens_ - 1e18)
559                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
560             )
561         / 1e18);
562 
563         return _etherReceived;
564     }
565 
566     /// @dev This is where all your gas goes.
567     function sqrt(uint256 x) internal pure returns (uint256 y) {
568         uint256 z = (x + 1) / 2;
569         y = x;
570 
571         while (z < y) {
572             y = z;
573             z = (x / z + z) / 2;
574         }
575     }
576 
577 
578 }
579 
580 /**
581  * @title SafeMath
582  * @dev Math operations with safety checks that throw on error
583  */
584 library SafeMath {
585 
586     /**
587     * @dev Multiplies two numbers, throws on overflow.
588     */
589     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
590         if (a == 0) {
591             return 0;
592         }
593         uint256 c = a * b;
594         assert(c / a == b);
595         return c;
596     }
597 
598     /**
599     * @dev Integer division of two numbers, truncating the quotient.
600     */
601     function div(uint256 a, uint256 b) internal pure returns (uint256) {
602         // assert(b > 0); // Solidity automatically throws when dividing by 0
603         uint256 c = a / b;
604         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
605         return c;
606     }
607 
608     /**
609     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
610     */
611     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
612         assert(b <= a);
613         return a - b;
614     }
615 
616     /**
617     * @dev Adds two numbers, throws on overflow.
618     */
619     function add(uint256 a, uint256 b) internal pure returns (uint256) {
620         uint256 c = a + b;
621         assert(c >= a);
622         return c;
623     }
624 
625 }