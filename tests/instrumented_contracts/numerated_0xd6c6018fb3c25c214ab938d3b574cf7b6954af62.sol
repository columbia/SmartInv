1 pragma solidity ^0.4.24;
2 
3 /***
4  * http://apexTWO.online
5  * 
6  * No administrators or developers, this contract is fully autonomous
7  *
8  * 12 % entry fee
9  * 12 % of entry fee to masternode referrals
10  * 0 % transfer fee
11  * Exit fee starts at 60% from contract start
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
106     string public name = "apexTWO Token";
107     string public symbol = "APX2";
108     uint8 constant public decimals = 18;
109 
110     /// @dev 12% dividends for token purchase
111     uint8 constant internal entryFee_ = 12;
112 
113     /// @dev 60% dividends for token selling
114     uint8 constant internal startExitFee_ = 60;
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
135     uint256 public maxEarlyStake = 5 ether;
136     uint256 public whaleBalanceLimit = 20 ether;
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
168      ambassadors_[0xaf9c025ce6322a23ac00301c714f4f42895c9818]=true;
169      //2
170      ambassadors_[0x44503314c43422764582502e59a6b2905f999d04]=true;
171      //3
172      ambassadors_[0x7b705c83c8c270745955cc3ca5f80fb3acf75d83]=true;
173      //4
174      ambassadors_[0xe25903c5078d01bbea64c01dc1107f40f44141a3]=true;
175 
176      apex = msg.sender;
177    }
178 
179     /*=======================================
180     =            PUBLIC FUNCTIONS           =
181     =======================================*/
182 
183     // @dev Function setting the start time of the system
184     function setStartTime(uint256 _startTime) public {
185       require(msg.sender==apex && !isStarted() && now < _startTime);
186       startTime = _startTime;
187     }
188 
189     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
190     function buy(address _referredBy) antiEarlyWhale notGasbag isControlled public payable  returns (uint256) {
191         purchaseTokens(msg.value, _referredBy , msg.sender);
192     }
193 
194     /// @dev Converts to tokens on behalf of the customer - this allows gifting and integration with other systems
195     function buyFor(address _referredBy, address _customerAddress) antiEarlyWhale notGasbag isControlled public payable returns (uint256) {
196         purchaseTokens(msg.value, _referredBy , _customerAddress);
197     }
198 
199     /**
200      * @dev Fallback function to handle ethereum that was send straight to the contract
201      *  Unfortunately we cannot use a referral address this way.
202      */
203     function() antiEarlyWhale notGasbag isControlled payable public {
204         purchaseTokens(msg.value, 0x0 , msg.sender);
205     }
206 
207     /// @dev Converts all of caller's dividends to tokens.
208     function reinvest() onlyStronghands public {
209         // fetch dividends
210         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
211 
212         // pay out the dividends virtually
213         address _customerAddress = msg.sender;
214         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
215 
216         // retrieve ref. bonus
217         _dividends += referralBalance_[_customerAddress];
218         referralBalance_[_customerAddress] = 0;
219 
220         // dispatch a buy order with the virtualized "withdrawn dividends"
221         uint256 _tokens = purchaseTokens(_dividends, 0x0 , _customerAddress);
222 
223         // fire event
224         emit onReinvestment(_customerAddress, _dividends, _tokens);
225     }
226 
227     /// @dev Alias of sell() and withdraw().
228     function exit() public {
229         // get token count for caller & sell them all
230         address _customerAddress = msg.sender;
231         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
232         if (_tokens > 0) sell(_tokens);
233 
234         // capitulation
235         withdraw();
236     }
237 
238     /// @dev Withdraws all of the callers earnings.
239     function withdraw() onlyStronghands public {
240         // setup data
241         address _customerAddress = msg.sender;
242         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
243 
244         // update dividend tracker
245         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
246 
247         // add ref. bonus
248         _dividends += referralBalance_[_customerAddress];
249         referralBalance_[_customerAddress] = 0;
250 
251         // lambo delivery service
252         _customerAddress.transfer(_dividends);
253 
254         // fire event
255         emit onWithdraw(_customerAddress, _dividends);
256     }
257 
258     /// @dev Liquifies tokens to ethereum.
259     function sell(uint256 _amountOfTokens) onlyBagholders public {
260         // setup data
261         address _customerAddress = msg.sender;
262         // russian hackers BTFO
263         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
264         uint256 _tokens = _amountOfTokens;
265         uint256 _ethereum = tokensToEthereum_(_tokens);
266         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
267         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
268 
269         // burn the sold tokens
270         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
271         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
272 
273         // update dividends tracker
274         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
275         payoutsTo_[_customerAddress] -= _updatedPayouts;
276 
277         // dividing by zero is a bad idea
278         if (tokenSupply_ > 0) {
279             // update the amount of dividends per token
280             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
281         }
282 
283         // fire event
284         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
285     }
286 
287 
288     /**
289      * @dev Transfer tokens from the caller to a new holder.
290      */
291     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
292         // setup
293         address _customerAddress = msg.sender;
294 
295         // make sure we have the requested tokens
296         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
297 
298         // withdraw all outstanding dividends first
299         if (myDividends(true) > 0) {
300             withdraw();
301         }
302 
303         // exchange tokens
304         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
305         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
306 
307         // update dividend trackers
308         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
309         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
310 
311         // fire event
312         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
313 
314         // ERC20
315         return true;
316     }
317 
318 
319     /*=====================================
320     =      HELPERS AND CALCULATORS        =
321     =====================================*/
322 
323     /**
324      * @dev Method to view the current Ethereum stored in the contract
325      *  Example: totalEthereumBalance()
326      */
327     function totalEthereumBalance() public view returns (uint256) {
328         return address(this).balance;
329     }
330 
331     /// @dev Retrieve the total token supply.
332     function totalSupply() public view returns (uint256) {
333         return tokenSupply_;
334     }
335 
336     /// @dev Retrieve the tokens owned by the caller.
337     function myTokens() public view returns (uint256) {
338         address _customerAddress = msg.sender;
339         return balanceOf(_customerAddress);
340     }
341 
342     /**
343      * @dev Retrieve the dividends owned by the caller.
344      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
345      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
346      *  But in the internal calculations, we want them separate.
347      */
348     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
349         address _customerAddress = msg.sender;
350         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
351     }
352 
353     /// @dev Retrieve the token balance of any single address.
354     function balanceOf(address _customerAddress) public view returns (uint256) {
355         return tokenBalanceLedger_[_customerAddress];
356     }
357 
358     /// @dev Retrieve the dividend balance of any single address.
359     function dividendsOf(address _customerAddress) public view returns (uint256) {
360         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
361     }
362 
363     /// @dev Return the sell price of 1 individual token.
364     function sellPrice() public view returns (uint256) {
365         // our calculation relies on the token supply, so we need supply. Doh.
366         if (tokenSupply_ == 0) {
367             return tokenPriceInitial_ - tokenPriceIncremental_;
368         } else {
369             uint256 _ethereum = tokensToEthereum_(1e18);
370             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
371             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
372 
373             return _taxedEthereum;
374         }
375     }
376 
377     /// @dev Return the buy price of 1 individual token.
378     function buyPrice() public view returns (uint256) {
379         // our calculation relies on the token supply, so we need supply. Doh.
380         if (tokenSupply_ == 0) {
381             return tokenPriceInitial_ + tokenPriceIncremental_;
382         } else {
383             uint256 _ethereum = tokensToEthereum_(1e18);
384             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
385             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
386 
387             return _taxedEthereum;
388         }
389     }
390 
391     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
392     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
393         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
394         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
395         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
396         return _amountOfTokens;
397     }
398 
399     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
400     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
401         require(_tokensToSell <= tokenSupply_);
402         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
403         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
404         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
405         return _taxedEthereum;
406     }
407 
408     /// @dev Function for the frontend to get untaxed receivable ethereum.
409     function calculateUntaxedEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
410         require(_tokensToSell <= tokenSupply_);
411         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
412         //uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
413         //uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
414         return _ethereum;
415     }
416 
417 
418     /// @dev Function for getting the current exitFee
419     function exitFee() public view returns (uint8) {
420         if (startTime==0){
421            return startExitFee_;
422         }
423         if ( now < startTime) {
424           return 0;
425         }
426         uint256 secondsPassed = now - startTime;
427         if (secondsPassed >= exitFeeFallDuration_) {
428             return finalExitFee_;
429         }
430         uint8 totalChange = startExitFee_ - finalExitFee_;
431         uint8 currentChange = uint8(totalChange * secondsPassed / exitFeeFallDuration_);
432         uint8 currentFee = startExitFee_- currentChange;
433         return currentFee;
434     }
435 
436     // @dev Function for find if premine
437     function isPremine() public view returns (bool) {
438       return depositCount_<=7;
439     }
440 
441     // @dev Function for find if premine
442     function isStarted() public view returns (bool) {
443       return startTime!=0 && now > startTime;
444     }
445 
446     /*==========================================
447     =            INTERNAL FUNCTIONS            =
448     ==========================================*/
449 
450     /// @dev Internal function to actually purchase the tokens.
451     function purchaseTokens(uint256 _incomingEthereum, address _referredBy , address _customerAddress) internal returns (uint256) {
452         // data setup
453         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
454         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
455         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
456         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
457         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
458         uint256 _fee = _dividends * magnitude;
459 
460         // no point in continuing execution if OP is a poorfag russian hacker
461         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
462         // (or hackers)
463         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
464         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
465 
466         // is the user referred by a masternode?
467         if (
468             // is this a referred purchase?
469             _referredBy != 0x0000000000000000000000000000000000000000 &&
470 
471             // no cheating!
472             _referredBy != _customerAddress &&
473 
474             // does the referrer have at least X whole tokens?
475             // i.e is the referrer a godly chad masternode
476             tokenBalanceLedger_[_referredBy] >= stakingRequirement
477         ) {
478             // wealth redistribution
479             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
480         } else {
481             // no ref purchase
482             // add the referral bonus back to the global dividends cake
483             _dividends = SafeMath.add(_dividends, _referralBonus);
484             _fee = _dividends * magnitude;
485         }
486 
487         // we can't give people infinite ethereum
488         if (tokenSupply_ > 0) {
489             // add tokens to the pool
490             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
491 
492             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
493             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
494 
495             // calculate the amount of tokens the customer receives over his purchase
496             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
497         } else {
498             // add tokens to the pool
499             tokenSupply_ = _amountOfTokens;
500         }
501 
502         // update circulating supply & the ledger address for the customer
503         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
504 
505         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
506         // really i know you think you do but you don't
507         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
508         payoutsTo_[_customerAddress] += _updatedPayouts;
509 
510         // fire event
511         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
512 
513         // Keep track
514         depositCount_++;
515         return _amountOfTokens;
516     }
517 
518     /**
519      * @dev Calculate Token price based on an amount of incoming ethereum
520      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
521      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
522      */
523     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
524         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
525         uint256 _tokensReceived =
526          (
527             (
528                 // underflow attempts BTFO
529                 SafeMath.sub(
530                     (sqrt
531                         (
532                             (_tokenPriceInitial ** 2)
533                             +
534                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
535                             +
536                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
537                             +
538                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
539                         )
540                     ), _tokenPriceInitial
541                 )
542             ) / (tokenPriceIncremental_)
543         ) - (tokenSupply_);
544 
545         return _tokensReceived;
546     }
547 
548     /**
549      * @dev Calculate token sell value.
550      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
551      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
552      */
553     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
554         uint256 tokens_ = (_tokens + 1e18);
555         uint256 _tokenSupply = (tokenSupply_ + 1e18);
556         uint256 _etherReceived =
557         (
558             // underflow attempts BTFO
559             SafeMath.sub(
560                 (
561                     (
562                         (
563                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
564                         ) - tokenPriceIncremental_
565                     ) * (tokens_ - 1e18)
566                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
567             )
568         / 1e18);
569 
570         return _etherReceived;
571     }
572 
573     /// @dev This is where all your gas goes.
574     function sqrt(uint256 x) internal pure returns (uint256 y) {
575         uint256 z = (x + 1) / 2;
576         y = x;
577 
578         while (z < y) {
579             y = z;
580             z = (x / z + z) / 2;
581         }
582     }
583 
584 
585 }
586 
587 /**
588  * @title SafeMath
589  * @dev Math operations with safety checks that throw on error
590  */
591 library SafeMath {
592 
593     /**
594     * @dev Multiplies two numbers, throws on overflow.
595     */
596     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
597         if (a == 0) {
598             return 0;
599         }
600         uint256 c = a * b;
601         assert(c / a == b);
602         return c;
603     }
604 
605     /**
606     * @dev Integer division of two numbers, truncating the quotient.
607     */
608     function div(uint256 a, uint256 b) internal pure returns (uint256) {
609         // assert(b > 0); // Solidity automatically throws when dividing by 0
610         uint256 c = a / b;
611         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
612         return c;
613     }
614 
615     /**
616     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
617     */
618     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
619         assert(b <= a);
620         return a - b;
621     }
622 
623     /**
624     * @dev Adds two numbers, throws on overflow.
625     */
626     function add(uint256 a, uint256 b) internal pure returns (uint256) {
627         uint256 c = a + b;
628         assert(c >= a);
629         return c;
630     }
631 
632 }