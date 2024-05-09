1 pragma solidity ^0.4.24;
2 
3 /***
4  * https://cryptox.market
5  * 
6  *
7  *
8  * 10 % entry fee
9  * 30 % to masternode referrals
10  * 0 % transfer fee
11  * Exit fee starts at 50% from contract start
12  * Exit fee decreases over 30 days  until 3%
13  * Stays at 3% forever, thereby allowing short trades.
14  */
15 contract CryptoXchange {
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
45           require(ambassadors_[msg.sender] && msg.value == 1 ether);
46         }else
47         if (depositCount_ < 2){
48           require(ambassadors_[msg.sender] && msg.value == 1 ether);
49         }else
50         if (depositCount_ == 2 || depositCount_==3){
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
106     string public name = "CryptoX Token";
107     string public symbol = "CryptoX";
108     uint8 constant public decimals = 18;
109 
110     /// @dev 10% dividends for token purchase
111     uint8 constant internal entryFee_ = 10;
112 
113     /// @dev 50% dividends for token selling
114     uint8 constant internal startExitFee_ = 50;
115 
116     /// @dev 3% dividends for token selling after step
117     uint8 constant internal finalExitFee_ = 3;
118 
119     /// @dev Exit fee falls over period of 30 days
120     uint256 constant internal exitFeeFallDuration_ = 30 days;
121 
122     /// @dev 30% masternode
123     uint8 constant internal refferalFee_ = 30;
124 
125     /// @dev CryptoX pricing
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
136     uint256 public whaleBalanceLimit = 50 ether;
137 
138     /// @dev owner starting gun
139     address public owner;
140 
141     /// @dev starting
142     uint256 public startTime = 0; //  January 1, 1970 12:00:00
143     
144     address promo1 = 0x54efb8160a4185cb5a0c86eb2abc0f1fcf4c3d07;
145     address promo2 = 0x41FE3738B503cBaFD01C1Fd8DD66b7fE6Ec11b01;
146    
147 
148    /*=================================
149     =            DATASETS            =
150     ================================*/
151 
152     // amount of shares for each address (scaled number)
153     mapping(address => uint256) internal tokenBalanceLedger_;
154     mapping(address => uint256) internal referralBalance_;
155     mapping(address => uint256) internal bonusBalance_;
156     mapping(address => int256) internal payoutsTo_;
157     uint256 internal tokenSupply_;
158     uint256 internal profitPerShare_;
159     uint256 public depositCount_;
160 
161     mapping(address => bool) internal ambassadors_;
162 
163     /*=======================================
164     =            CONSTRUCTOR                =
165     =======================================*/
166 
167    constructor () public {
168 
169      //Community Promotional Fund
170      ambassadors_[msg.sender]=true;
171      //1
172      ambassadors_[0x3f2cc2a7c15d287dd4d0614df6338e2414d5935a]=true;
173      //2
174      ambassadors_[0x41FE3738B503cBaFD01C1Fd8DD66b7fE6Ec11b01]=true;
175      //3
176      ambassadors_[0x0f238601e6b61bf4abf9d34fe846c108da38936c]=true;
177     
178      owner = msg.sender;
179    }
180 
181     /*=======================================
182     =            PUBLIC FUNCTIONS           =
183     =======================================*/
184 
185     // @dev Function setting the start time of the system
186     function setStartTime(uint256 _startTime) public {
187       require(msg.sender==owner && !isStarted() && now < _startTime);
188       startTime = _startTime;
189     }
190 
191     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
192     function buy(address _referredBy) antiEarlyWhale notGasbag isControlled public payable  returns (uint256) {
193         purchaseTokens(msg.value, _referredBy , msg.sender);
194         uint256 getmsgvalue = msg.value / 20;
195         promo1.transfer(getmsgvalue);
196         promo2.transfer(getmsgvalue);
197     }
198 
199     /// @dev Converts to tokens on behalf of the customer - this allows gifting and integration with other systems
200     function buyFor(address _referredBy, address _customerAddress) antiEarlyWhale notGasbag isControlled public payable returns (uint256) {
201         purchaseTokens(msg.value, _referredBy , _customerAddress);
202         uint256 getmsgvalue = msg.value / 20;
203         promo1.transfer(getmsgvalue);
204         promo2.transfer(getmsgvalue);
205     }
206 
207     /**
208      * @dev Fallback function to handle ethereum that was sent straight to the contract
209      *  Unfortunately we cannot use a referral address this way.
210      */
211     function() antiEarlyWhale notGasbag isControlled payable public {
212         purchaseTokens(msg.value, 0x0 , msg.sender);
213         uint256 getmsgvalue = msg.value / 20;
214         promo1.transfer(getmsgvalue);
215         promo2.transfer(getmsgvalue);
216     }
217 
218     /// @dev Converts all of caller's dividends to tokens.
219     function reinvest() onlyStronghands public {
220         // fetch dividends
221         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
222 
223         // pay out the dividends virtually
224         address _customerAddress = msg.sender;
225         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
226 
227         // retrieve ref. bonus
228         _dividends += referralBalance_[_customerAddress];
229         referralBalance_[_customerAddress] = 0;
230 
231         // dispatch a buy order with the virtualized "withdrawn dividends"
232         uint256 _tokens = purchaseTokens(_dividends, 0x0 , _customerAddress);
233 
234         // fire event
235         emit onReinvestment(_customerAddress, _dividends, _tokens);
236     }
237 
238     /// @dev Alias of sell() and withdraw().
239     function exit() public {
240         // get token count for caller & sell them all
241         address _customerAddress = msg.sender;
242         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
243         if (_tokens > 0) sell(_tokens);
244 
245         // capitulation
246         withdraw();
247     }
248 
249     /// @dev Withdraws all of the callers earnings.
250     function withdraw() onlyStronghands public {
251         // setup data
252         address _customerAddress = msg.sender;
253         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
254 
255         // update dividend tracker
256         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
257 
258         // add ref. bonus
259         _dividends += referralBalance_[_customerAddress];
260         referralBalance_[_customerAddress] = 0;
261 
262         // lambo delivery service
263         _customerAddress.transfer(_dividends);
264 
265         // fire event
266         emit onWithdraw(_customerAddress, _dividends);
267     }
268 
269     /// @dev Liquifies tokens to ethereum.
270     function sell(uint256 _amountOfTokens) onlyBagholders public {
271         // setup data
272         address _customerAddress = msg.sender;
273         // russian hackers BTFO
274         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
275         uint256 _tokens = _amountOfTokens;
276         uint256 _ethereum = tokensToEthereum_(_tokens);
277         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
278         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
279 
280         // burn the sold tokens
281         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
282         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
283 
284         // update dividends tracker
285         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
286         payoutsTo_[_customerAddress] -= _updatedPayouts;
287 
288         // dividing by zero is a bad idea
289         if (tokenSupply_ > 0) {
290             // update the amount of dividends per token
291             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
292         }
293 
294         // fire event
295         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
296     }
297 
298 
299     /**
300      * @dev Transfer tokens from the caller to a new holder.
301      */
302     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
303         // setup
304         address _customerAddress = msg.sender;
305 
306         // make sure we have the requested tokens
307         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
308 
309         // withdraw all outstanding dividends first
310         if (myDividends(true) > 0) {
311             withdraw();
312         }
313 
314         // exchange tokens
315         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
316         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
317 
318         // update dividend trackers
319         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
320         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
321 
322         // fire event
323         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
324 
325         // ERC20
326         return true;
327     }
328 
329 
330     /*=====================================
331     =      HELPERS AND CALCULATORS        =
332     =====================================*/
333 
334     /**
335      * @dev Method to view the current Ethereum stored in the contract
336      *  Example: totalEthereumBalance()
337      */
338     function totalEthereumBalance() public view returns (uint256) {
339         return address(this).balance;
340     }
341 
342     /// @dev Retrieve the total token supply.
343     function totalSupply() public view returns (uint256) {
344         return tokenSupply_;
345     }
346 
347     /// @dev Retrieve the tokens owned by the caller.
348     function myTokens() public view returns (uint256) {
349         address _customerAddress = msg.sender;
350         return balanceOf(_customerAddress);
351     }
352 
353     /**
354      * @dev Retrieve the dividends owned by the caller.
355      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
356      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
357      *  But in the internal calculations, we want them separate.
358      */
359     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
360         address _customerAddress = msg.sender;
361         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
362     }
363 
364     /// @dev Retrieve the token balance of any single address.
365     function balanceOf(address _customerAddress) public view returns (uint256) {
366         return tokenBalanceLedger_[_customerAddress];
367     }
368 
369     /// @dev Retrieve the dividend balance of any single address.
370     function dividendsOf(address _customerAddress) public view returns (uint256) {
371         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
372     }
373 
374     /// @dev Return the sell price of 1 individual token.
375     function sellPrice() public view returns (uint256) {
376         // our calculation relies on the token supply, so we need supply. Doh.
377         if (tokenSupply_ == 0) {
378             return tokenPriceInitial_ - tokenPriceIncremental_;
379         } else {
380             uint256 _ethereum = tokensToEthereum_(1e18);
381             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
382             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
383 
384             return _taxedEthereum;
385         }
386     }
387 
388     /// @dev Return the buy price of 1 individual token.
389     function buyPrice() public view returns (uint256) {
390         // our calculation relies on the token supply, so we need supply. Doh.
391         if (tokenSupply_ == 0) {
392             return tokenPriceInitial_ + tokenPriceIncremental_;
393         } else {
394             uint256 _ethereum = tokensToEthereum_(1e18);
395             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
396             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
397 
398             return _taxedEthereum;
399         }
400     }
401 
402     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
403     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
404         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
405         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
406         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
407         return _amountOfTokens;
408     }
409 
410     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
411     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
412         require(_tokensToSell <= tokenSupply_);
413         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
414         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
415         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
416         return _taxedEthereum;
417     }
418 
419     /// @dev Function for the frontend to get untaxed receivable ethereum.
420     function calculateUntaxedEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
421         require(_tokensToSell <= tokenSupply_);
422         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
423         //uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
424         //uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
425         return _ethereum;
426     }
427 
428 
429     /// @dev Function for getting the current exitFee
430     function exitFee() public view returns (uint8) {
431         if (startTime==0){
432            return startExitFee_;
433         }
434         if ( now < startTime) {
435           return 0;
436         }
437         uint256 secondsPassed = now - startTime;
438         if (secondsPassed >= exitFeeFallDuration_) {
439             return finalExitFee_;
440         }
441         uint8 totalChange = startExitFee_ - finalExitFee_;
442         uint8 currentChange = uint8(totalChange * secondsPassed / exitFeeFallDuration_);
443         uint8 currentFee = startExitFee_- currentChange;
444         return currentFee;
445     }
446 
447     // @dev Function for find if premine
448     function isPremine() public view returns (bool) {
449       return depositCount_<=3;
450     }
451 
452     // @dev Function for find if premine
453     function isStarted() public view returns (bool) {
454       return startTime!=0 && now > startTime;
455     }
456 
457     /*==========================================
458     =            INTERNAL FUNCTIONS            =
459     ==========================================*/
460 
461     /// @dev Internal function to actually purchase the tokens.
462     function purchaseTokens(uint256 _incomingEthereum, address _referredBy , address _customerAddress) internal returns (uint256) {
463         // data setup
464         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
465         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
466         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
467         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
468         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
469         uint256 _fee = _dividends * magnitude;
470 
471         // no point in continuing execution if OP is a poorfag russian hacker
472         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
473         // (or hackers)
474         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
475         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
476 
477         // is the user referred by a masternode?
478         if (
479             // is this a referred purchase?
480             _referredBy != 0x0000000000000000000000000000000000000000 &&
481 
482             // no cheating!
483             _referredBy != _customerAddress &&
484 
485             // does the referrer have at least X whole tokens?
486             // i.e is the referrer a godly chad masternode
487             tokenBalanceLedger_[_referredBy] >= stakingRequirement
488         ) {
489             // wealth redistribution
490             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
491         } else {
492             // no ref purchase
493             // add the referral bonus back to the global dividends cake
494             _dividends = SafeMath.add(_dividends, _referralBonus);
495             _fee = _dividends * magnitude;
496         }
497 
498         // we can't give people infinite ethereum
499         if (tokenSupply_ > 0) {
500             // add tokens to the pool
501             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
502 
503             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
504             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
505 
506             // calculate the amount of tokens the customer receives over his purchase
507             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
508         } else {
509             // add tokens to the pool
510             tokenSupply_ = _amountOfTokens;
511         }
512 
513         // update circulating supply & the ledger address for the customer
514         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
515 
516         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
517         // really i know you think you do but you don't
518         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
519         payoutsTo_[_customerAddress] += _updatedPayouts;
520 
521         // fire event
522         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
523 
524         // Keep track
525         depositCount_++;
526         return _amountOfTokens;
527     }
528 
529     /**
530      * @dev Calculate Token price based on an amount of incoming ethereum
531      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
532      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
533      */
534     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
535         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
536         uint256 _tokensReceived =
537          (
538             (
539                 // underflow attempts BTFO
540                 SafeMath.sub(
541                     (sqrt
542                         (
543                             (_tokenPriceInitial ** 2)
544                             +
545                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
546                             +
547                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
548                             +
549                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
550                         )
551                     ), _tokenPriceInitial
552                 )
553             ) / (tokenPriceIncremental_)
554         ) - (tokenSupply_);
555 
556         return _tokensReceived;
557     }
558 
559     /**
560      * @dev Calculate token sell value.
561      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
562      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
563      */
564     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
565         uint256 tokens_ = (_tokens + 1e18);
566         uint256 _tokenSupply = (tokenSupply_ + 1e18);
567         uint256 _etherReceived =
568         (
569             // underflow attempts BTFO
570             SafeMath.sub(
571                 (
572                     (
573                         (
574                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
575                         ) - tokenPriceIncremental_
576                     ) * (tokens_ - 1e18)
577                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
578             )
579         / 1e18);
580 
581         return _etherReceived;
582     }
583 
584     /// @dev This is where all your gas goes.
585     function sqrt(uint256 x) internal pure returns (uint256 y) {
586         uint256 z = (x + 1) / 2;
587         y = x;
588 
589         while (z < y) {
590             y = z;
591             z = (x / z + z) / 2;
592         }
593     }
594 
595 
596 }
597 
598 /**
599  * @title SafeMath
600  * @dev Math operations with safety checks that throw on error
601  */
602 library SafeMath {
603 
604     /**
605     * @dev Multiplies two numbers, throws on overflow.
606     */
607     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
608         if (a == 0) {
609             return 0;
610         }
611         uint256 c = a * b;
612         assert(c / a == b);
613         return c;
614     }
615 
616     /**
617     * @dev Integer division of two numbers, truncating the quotient.
618     */
619     function div(uint256 a, uint256 b) internal pure returns (uint256) {
620         // assert(b > 0); // Solidity automatically throws when dividing by 0
621         uint256 c = a / b;
622         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
623         return c;
624     }
625 
626     /**
627     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
628     */
629     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
630         assert(b <= a);
631         return a - b;
632     }
633 
634     /**
635     * @dev Adds two numbers, throws on overflow.
636     */
637     function add(uint256 a, uint256 b) internal pure returns (uint256) {
638         uint256 c = a + b;
639         assert(c >= a);
640         return c;
641     }
642 
643 }