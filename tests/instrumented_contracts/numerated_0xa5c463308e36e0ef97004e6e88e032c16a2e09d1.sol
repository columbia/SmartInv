1 pragma solidity ^0.4.24;
2 
3 /***
4  * https://apexGOLD
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
15 contract apexGOLD {
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
106     string public name = "apexGOLD Token";
107     string public symbol = "APG";
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
168      ambassadors_[0x31A41203344C225Ef5Fc294244b5Fb7b0514f319]=true;
169      //2
170      ambassadors_[0x5Fa7ca52E3829326b4bD75FFf551313AceA135Ba]=true;
171      //3
172      ambassadors_[0x893a8b6fF42286670BCB2221d1398d2136596E4e]=true;
173      
174      apex = msg.sender;
175    }
176 
177     /*=======================================
178     =            PUBLIC FUNCTIONS           =
179     =======================================*/
180 
181     // @dev Function setting the start time of the system
182     function setStartTime(uint256 _startTime) public {
183       require(msg.sender==apex && !isStarted() && now < _startTime);
184       startTime = _startTime;
185     }
186 
187     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
188     function buy(address _referredBy) antiEarlyWhale notGasbag isControlled public payable  returns (uint256) {
189         purchaseTokens(msg.value, _referredBy , msg.sender);
190     }
191 
192     /// @dev Converts to tokens on behalf of the customer - this allows gifting and integration with other systems
193     function buyFor(address _referredBy, address _customerAddress) antiEarlyWhale notGasbag isControlled public payable returns (uint256) {
194         purchaseTokens(msg.value, _referredBy , _customerAddress);
195     }
196 
197     /**
198      * @dev Fallback function to handle ethereum that was send straight to the contract
199      *  Unfortunately we cannot use a referral address this way.
200      */
201     function() antiEarlyWhale notGasbag isControlled payable public {
202         purchaseTokens(msg.value, 0x0 , msg.sender);
203     }
204 
205     /// @dev Converts all of caller's dividends to tokens.
206     function reinvest() onlyStronghands public {
207         // fetch dividends
208         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
209 
210         // pay out the dividends virtually
211         address _customerAddress = msg.sender;
212         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
213 
214         // retrieve ref. bonus
215         _dividends += referralBalance_[_customerAddress];
216         referralBalance_[_customerAddress] = 0;
217 
218         // dispatch a buy order with the virtualized "withdrawn dividends"
219         uint256 _tokens = purchaseTokens(_dividends, 0x0 , _customerAddress);
220 
221         // fire event
222         emit onReinvestment(_customerAddress, _dividends, _tokens);
223     }
224 
225     /// @dev Alias of sell() and withdraw().
226     function exit() public {
227         // get token count for caller & sell them all
228         address _customerAddress = msg.sender;
229         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
230         if (_tokens > 0) sell(_tokens);
231 
232         // capitulation
233         withdraw();
234     }
235 
236     /// @dev Withdraws all of the callers earnings.
237     function withdraw() onlyStronghands public {
238         // setup data
239         address _customerAddress = msg.sender;
240         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
241 
242         // update dividend tracker
243         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
244 
245         // add ref. bonus
246         _dividends += referralBalance_[_customerAddress];
247         referralBalance_[_customerAddress] = 0;
248 
249         // lambo delivery service
250         _customerAddress.transfer(_dividends);
251 
252         // fire event
253         emit onWithdraw(_customerAddress, _dividends);
254     }
255 
256     /// @dev Liquifies tokens to ethereum.
257     function sell(uint256 _amountOfTokens) onlyBagholders public {
258         // setup data
259         address _customerAddress = msg.sender;
260         // russian hackers BTFO
261         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
262         uint256 _tokens = _amountOfTokens;
263         uint256 _ethereum = tokensToEthereum_(_tokens);
264         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
265         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
266 
267         // burn the sold tokens
268         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
269         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
270 
271         // update dividends tracker
272         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
273         payoutsTo_[_customerAddress] -= _updatedPayouts;
274 
275         // dividing by zero is a bad idea
276         if (tokenSupply_ > 0) {
277             // update the amount of dividends per token
278             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
279         }
280 
281         // fire event
282         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
283     }
284 
285 
286     /**
287      * @dev Transfer tokens from the caller to a new holder.
288      */
289     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
290         // setup
291         address _customerAddress = msg.sender;
292 
293         // make sure we have the requested tokens
294         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
295 
296         // withdraw all outstanding dividends first
297         if (myDividends(true) > 0) {
298             withdraw();
299         }
300 
301         // exchange tokens
302         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
303         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
304 
305         // update dividend trackers
306         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
307         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
308 
309         // fire event
310         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
311 
312         // ERC20
313         return true;
314     }
315 
316 
317     /*=====================================
318     =      HELPERS AND CALCULATORS        =
319     =====================================*/
320 
321     /**
322      * @dev Method to view the current Ethereum stored in the contract
323      *  Example: totalEthereumBalance()
324      */
325     function totalEthereumBalance() public view returns (uint256) {
326         return address(this).balance;
327     }
328 
329     /// @dev Retrieve the total token supply.
330     function totalSupply() public view returns (uint256) {
331         return tokenSupply_;
332     }
333 
334     /// @dev Retrieve the tokens owned by the caller.
335     function myTokens() public view returns (uint256) {
336         address _customerAddress = msg.sender;
337         return balanceOf(_customerAddress);
338     }
339 
340     /**
341      * @dev Retrieve the dividends owned by the caller.
342      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
343      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
344      *  But in the internal calculations, we want them separate.
345      */
346     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
347         address _customerAddress = msg.sender;
348         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
349     }
350 
351     /// @dev Retrieve the token balance of any single address.
352     function balanceOf(address _customerAddress) public view returns (uint256) {
353         return tokenBalanceLedger_[_customerAddress];
354     }
355 
356     /// @dev Retrieve the dividend balance of any single address.
357     function dividendsOf(address _customerAddress) public view returns (uint256) {
358         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
359     }
360 
361     /// @dev Return the sell price of 1 individual token.
362     function sellPrice() public view returns (uint256) {
363         // our calculation relies on the token supply, so we need supply. Doh.
364         if (tokenSupply_ == 0) {
365             return tokenPriceInitial_ - tokenPriceIncremental_;
366         } else {
367             uint256 _ethereum = tokensToEthereum_(1e18);
368             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
369             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
370 
371             return _taxedEthereum;
372         }
373     }
374 
375     /// @dev Return the buy price of 1 individual token.
376     function buyPrice() public view returns (uint256) {
377         // our calculation relies on the token supply, so we need supply. Doh.
378         if (tokenSupply_ == 0) {
379             return tokenPriceInitial_ + tokenPriceIncremental_;
380         } else {
381             uint256 _ethereum = tokensToEthereum_(1e18);
382             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
383             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
384 
385             return _taxedEthereum;
386         }
387     }
388 
389     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
390     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
391         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
392         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
393         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
394         return _amountOfTokens;
395     }
396 
397     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
398     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
399         require(_tokensToSell <= tokenSupply_);
400         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
401         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
402         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
403         return _taxedEthereum;
404     }
405 
406     /// @dev Function for the frontend to get untaxed receivable ethereum.
407     function calculateUntaxedEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
408         require(_tokensToSell <= tokenSupply_);
409         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
410         //uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
411         //uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
412         return _ethereum;
413     }
414 
415 
416     /// @dev Function for getting the current exitFee
417     function exitFee() public view returns (uint8) {
418         if (startTime==0){
419            return startExitFee_;
420         }
421         if ( now < startTime) {
422           return 0;
423         }
424         uint256 secondsPassed = now - startTime;
425         if (secondsPassed >= exitFeeFallDuration_) {
426             return finalExitFee_;
427         }
428         uint8 totalChange = startExitFee_ - finalExitFee_;
429         uint8 currentChange = uint8(totalChange * secondsPassed / exitFeeFallDuration_);
430         uint8 currentFee = startExitFee_- currentChange;
431         return currentFee;
432     }
433 
434     // @dev Function for find if premine
435     function isPremine() public view returns (bool) {
436       return depositCount_<=7;
437     }
438 
439     // @dev Function for find if premine
440     function isStarted() public view returns (bool) {
441       return startTime!=0 && now > startTime;
442     }
443 
444     /*==========================================
445     =            INTERNAL FUNCTIONS            =
446     ==========================================*/
447 
448     /// @dev Internal function to actually purchase the tokens.
449     function purchaseTokens(uint256 _incomingEthereum, address _referredBy , address _customerAddress) internal returns (uint256) {
450         // data setup
451         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
452         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
453         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
454         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
455         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
456         uint256 _fee = _dividends * magnitude;
457 
458         // no point in continuing execution if OP is a poorfag russian hacker
459         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
460         // (or hackers)
461         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
462         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
463 
464         // is the user referred by a masternode?
465         if (
466             // is this a referred purchase?
467             _referredBy != 0x0000000000000000000000000000000000000000 &&
468 
469             // no cheating!
470             _referredBy != _customerAddress &&
471 
472             // does the referrer have at least X whole tokens?
473             // i.e is the referrer a godly chad masternode
474             tokenBalanceLedger_[_referredBy] >= stakingRequirement
475         ) {
476             // wealth redistribution
477             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
478         } else {
479             // no ref purchase
480             // add the referral bonus back to the global dividends cake
481             _dividends = SafeMath.add(_dividends, _referralBonus);
482             _fee = _dividends * magnitude;
483         }
484 
485         // we can't give people infinite ethereum
486         if (tokenSupply_ > 0) {
487             // add tokens to the pool
488             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
489 
490             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
491             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
492 
493             // calculate the amount of tokens the customer receives over his purchase
494             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
495         } else {
496             // add tokens to the pool
497             tokenSupply_ = _amountOfTokens;
498         }
499 
500         // update circulating supply & the ledger address for the customer
501         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
502 
503         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
504         // really i know you think you do but you don't
505         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
506         payoutsTo_[_customerAddress] += _updatedPayouts;
507 
508         // fire event
509         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
510 
511         // Keep track
512         depositCount_++;
513         return _amountOfTokens;
514     }
515 
516     /**
517      * @dev Calculate Token price based on an amount of incoming ethereum
518      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
519      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
520      */
521     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
522         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
523         uint256 _tokensReceived =
524          (
525             (
526                 // underflow attempts BTFO
527                 SafeMath.sub(
528                     (sqrt
529                         (
530                             (_tokenPriceInitial ** 2)
531                             +
532                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
533                             +
534                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
535                             +
536                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
537                         )
538                     ), _tokenPriceInitial
539                 )
540             ) / (tokenPriceIncremental_)
541         ) - (tokenSupply_);
542 
543         return _tokensReceived;
544     }
545 
546     /**
547      * @dev Calculate token sell value.
548      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
549      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
550      */
551     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
552         uint256 tokens_ = (_tokens + 1e18);
553         uint256 _tokenSupply = (tokenSupply_ + 1e18);
554         uint256 _etherReceived =
555         (
556             // underflow attempts BTFO
557             SafeMath.sub(
558                 (
559                     (
560                         (
561                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
562                         ) - tokenPriceIncremental_
563                     ) * (tokens_ - 1e18)
564                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
565             )
566         / 1e18);
567 
568         return _etherReceived;
569     }
570 
571     /// @dev This is where all your gas goes.
572     function sqrt(uint256 x) internal pure returns (uint256 y) {
573         uint256 z = (x + 1) / 2;
574         y = x;
575 
576         while (z < y) {
577             y = z;
578             z = (x / z + z) / 2;
579         }
580     }
581 
582 
583 }
584 
585 /**
586  * @title SafeMath
587  * @dev Math operations with safety checks that throw on error
588  */
589 library SafeMath {
590 
591     /**
592     * @dev Multiplies two numbers, throws on overflow.
593     */
594     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
595         if (a == 0) {
596             return 0;
597         }
598         uint256 c = a * b;
599         assert(c / a == b);
600         return c;
601     }
602 
603     /**
604     * @dev Integer division of two numbers, truncating the quotient.
605     */
606     function div(uint256 a, uint256 b) internal pure returns (uint256) {
607         // assert(b > 0); // Solidity automatically throws when dividing by 0
608         uint256 c = a / b;
609         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
610         return c;
611     }
612 
613     /**
614     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
615     */
616     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
617         assert(b <= a);
618         return a - b;
619     }
620 
621     /**
622     * @dev Adds two numbers, throws on overflow.
623     */
624     function add(uint256 a, uint256 b) internal pure returns (uint256) {
625         uint256 c = a + b;
626         assert(c >= a);
627         return c;
628     }
629 
630 }