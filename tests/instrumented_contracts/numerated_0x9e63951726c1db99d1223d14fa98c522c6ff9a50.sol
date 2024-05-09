1 pragma solidity ^0.4.24;
2 /***
3  *  _____               _            __   ___ _____ _  _
4  * |_   _|__ _ __  _ __| |___   ___ / _| | __|_   _| || |
5  *   | |/ -_) '  \| '_ \ / -_) / _ \  _| | _|  | | | __ |
6  *   |_|\___|_|_|_| .__/_\___| \___/_|   |___| |_| |_||_|
7  *                    |_|
8  * https://templeofeth.io
9  *
10  * The Temple.
11  *
12  * Volume Based Entry Fees
13  * 0-10 eth 40%
14  * 10-20 eth 35%
15  * 20-50 eth 30%
16  * 50-100 eth 25%
17  * 100- 250 eth 20%
18  * 250- infinity 15%
19  *
20  * Masternode referral bonus 33% of entry fee
21  * Exit Fee: 15% - always.
22  *
23  * Temple Warning: Do not play with more than you can afford to lose.
24  *
25  */
26 
27 contract TempleOfETH {
28 
29     /*=================================
30     =            MODIFIERS            =
31     =================================*/
32 
33     /// @dev Only people with tokens
34     modifier onlyBagholders {
35         require(myTokens() > 0);
36         _;
37     }
38 
39     /// @dev Only people with profits
40     modifier onlyStronghands {
41         require(myDividends(true) > 0);
42         _;
43     }
44 
45     /// @dev easyOnTheGas
46     modifier easyOnTheGas() {
47       require(tx.gasprice < 200999999999);
48       _;
49     }
50 
51     /// @dev Preventing unstable dumping and limit ambassador mine
52     modifier antiEarlyWhale {
53         if (address(this).balance  -msg.value < whaleBalanceLimit){
54           require(msg.value <= maxEarlyStake);
55         }
56         if (depositCount_ == 0){
57           require(ambassadors_[msg.sender] && msg.value == 0.5 ether);
58         }else
59         if (depositCount_ < 2){
60           require(ambassadors_[msg.sender] && msg.value == 0.8 ether);
61         }
62         _;
63     }
64 
65     /// @dev easyOnTheGas
66     modifier isControlled() {
67       require(isPremine() || isStarted());
68       _;
69     }
70 
71     /*==============================
72     =            EVENTS            =
73     ==============================*/
74 
75     event onTokenPurchase(
76         address indexed customerAddress,
77         uint256 incomingEthereum,
78         uint256 tokensMinted,
79         address indexed referredBy,
80         uint timestamp,
81         uint256 price
82     );
83 
84     event onTokenSell(
85         address indexed customerAddress,
86         uint256 tokensBurned,
87         uint256 ethereumEarned,
88         uint timestamp,
89         uint256 price
90     );
91 
92     event onReinvestment(
93         address indexed customerAddress,
94         uint256 ethereumReinvested,
95         uint256 tokensMinted
96     );
97 
98     event onWithdraw(
99         address indexed customerAddress,
100         uint256 ethereumWithdrawn
101     );
102 
103     // ERC20
104     event Transfer(
105         address indexed from,
106         address indexed to,
107         uint256 tokens
108     );
109 
110 
111     /*=====================================
112     =            CONFIGURABLES            =
113     =====================================*/
114 
115     string public name = "TempleOfETH Token";
116     string public symbol = "TMPL";
117     uint8 constant public decimals = 18;
118 
119     /// @dev 15% dividends for token selling
120     uint8 constant internal exitFee_ = 15;
121 
122     /// @dev 33% masternode
123     uint8 constant internal refferalFee_ = 33;
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
136     uint256 public whaleBalanceLimit = 100 ether;
137 
138     /// @dev light the fuse
139     address public fuse;
140 
141     /// @dev starting
142     uint256 public startTime = 0; 
143 
144     /// @dev one shot
145     bool public startCalled = false; 
146 
147 
148    /*=================================
149     =            DATASETS            =
150     ================================*/
151 
152     // amount of shares for each address (scaled number)
153     mapping(address => uint256) internal tokenBalanceLedger_;
154     mapping(address => uint256) internal referralBalance_;
155     mapping(address => int256) internal payoutsTo_;
156     uint256 internal tokenSupply_;
157     uint256 internal profitPerShare_;
158     uint256 public depositCount_;
159 
160     mapping(address => bool) internal ambassadors_;
161 
162     /*=======================================
163     =            CONSTRUCTOR                =
164     =======================================*/
165 
166    constructor () public {
167 
168      fuse = msg.sender;
169      // Masternode sales & promotional fund
170      ambassadors_[fuse]=true;
171      //cadmael
172      ambassadors_[0x5aFa2A530B83E239261Aa46C6c29c9dF371FAA62]=true;
173      ambassadors_[0x2fB1163A439fb5FC3a3b169E9519EAbd92E9fef2]=true;
174      
175    }
176 
177     /*=======================================
178     =            PUBLIC FUNCTIONS           =
179     =======================================*/
180 
181     // @dev Function setting the start time of the system
182     function setStartTime(uint256 _startTime) public {
183       require(msg.sender==fuse && !isStarted() && now < _startTime && !startCalled);
184       require(_startTime > now);
185       startTime = _startTime;
186       startCalled = true;
187     }
188 
189     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
190     function buy(address _referredBy) antiEarlyWhale easyOnTheGas isControlled public payable  returns (uint256) {
191         purchaseTokens(msg.value, _referredBy , msg.sender);
192     }
193 
194     /// @dev Converts to tokens on behalf of the customer - this allows gifting and integration with other systems
195     function purchaseFor(address _referredBy, address _customerAddress) antiEarlyWhale easyOnTheGas isControlled public payable returns (uint256) {
196         purchaseTokens(msg.value, _referredBy , _customerAddress);
197     }
198 
199     /**
200      * @dev Fallback function to handle ethereum that was send straight to the contract
201      *  Unfortunately we cannot use a referral address this way.
202      */
203     function() antiEarlyWhale easyOnTheGas isControlled payable public {
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
266         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
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
303         return transferInternal(_toAddress,_amountOfTokens,_customerAddress);
304     }
305 
306     function transferInternal(address _toAddress, uint256 _amountOfTokens , address _fromAddress) internal returns (bool) {
307         // setup
308         address _customerAddress = _fromAddress;
309 
310         // exchange tokens
311         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
312         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
313 
314         // update dividend trackers
315         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
316         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
317 
318         // fire event
319         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
320 
321         // ERC20
322         return true;
323     }
324 
325 
326     /*=====================================
327     =      HELPERS AND CALCULATORS        =
328     =====================================*/
329 
330     /**
331      * @dev Method to view the current Ethereum stored in the contract
332      *  Example: totalEthereumBalance()
333      */
334     function totalEthereumBalance() public view returns (uint256) {
335         return address(this).balance;
336     }
337 
338     /// @dev Retrieve the total token supply.
339     function totalSupply() public view returns (uint256) {
340         return tokenSupply_;
341     }
342 
343     /// @dev Retrieve the tokens owned by the caller.
344     function myTokens() public view returns (uint256) {
345         address _customerAddress = msg.sender;
346         return balanceOf(_customerAddress);
347     }
348 
349     /**
350      * @dev Retrieve the dividends owned by the caller.
351      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
352      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
353      *  But in the internal calculations, we want them separate.
354      */
355     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
356         address _customerAddress = msg.sender;
357         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
358     }
359 
360     /// @dev Retrieve the token balance of any single address.
361     function balanceOf(address _customerAddress) public view returns (uint256) {
362         return tokenBalanceLedger_[_customerAddress];
363     }
364 
365     /// @dev Retrieve the dividend balance of any single address.
366     function dividendsOf(address _customerAddress) public view returns (uint256) {
367         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
368     }
369 
370     /// @dev Return the sell price of 1 individual token.
371     function sellPrice() public view returns (uint256) {
372         // our calculation relies on the token supply, so we need supply. Doh.
373         if (tokenSupply_ == 0) {
374             return tokenPriceInitial_ - tokenPriceIncremental_;
375         } else {
376             uint256 _ethereum = tokensToEthereum_(1e18);
377             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
378             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
379 
380             return _taxedEthereum;
381         }
382     }
383 
384     /// @dev Return the buy price of 1 individual token.
385     function buyPrice() public view returns (uint256) {
386         // our calculation relies on the token supply, so we need supply. Doh.
387         if (tokenSupply_ == 0) {
388             return tokenPriceInitial_ + tokenPriceIncremental_;
389         } else {
390             uint256 _ethereum = tokensToEthereum_(1e18);
391             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee()), 100);
392             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
393 
394             return _taxedEthereum;
395         }
396     }
397 
398     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
399     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
400         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee()), 100);
401         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
402         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
403         return _amountOfTokens;
404     }
405 
406     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
407     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
408         require(_tokensToSell <= tokenSupply_);
409         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
410         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
411         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
412         return _taxedEthereum;
413     }
414 
415     /// @dev Function for the frontend to get untaxed receivable ethereum.
416     function calculateUntaxedEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
417         require(_tokensToSell <= tokenSupply_);
418         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
419         //uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
420         //uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
421         return _ethereum;
422     }
423 
424     function entryFee() public view returns (uint8){
425       uint256 volume = address(this).balance  - msg.value;
426 
427       if (volume<=10 ether){
428         return 40;
429       }
430       if (volume<=20 ether){
431         return 35;
432       }
433       if (volume<=50 ether){
434         return 30;
435       }
436       if (volume<=100 ether){
437         return 25;
438       }
439       if (volume<=250 ether){
440         return 20;
441       }
442       return 15;
443     }
444 
445     // @dev Function for find if premine
446     function isPremine() public view returns (bool) {
447       return depositCount_<=5;
448     }
449 
450     // @dev Function for find if premine
451     function isStarted() public view returns (bool) {
452       return startTime!=0 && now > startTime;
453     }
454 
455     /*==========================================
456     =            INTERNAL FUNCTIONS            =
457     ==========================================*/
458 
459     /// @dev Internal function to actually purchase the tokens.
460     function purchaseTokens(uint256 _incomingEthereum, address _referredBy , address _customerAddress) internal returns (uint256) {
461         // data setup
462         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee()), 100);
463         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
464         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
465         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
466         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
467         uint256 _fee = _dividends * magnitude;
468 
469         // no point in continuing execution if OP is a poorfag russian hacker
470         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
471         // (or hackers)
472         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
473         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
474 
475         // is the user referred by a masternode?
476         if (
477             // is this a referred purchase?
478             _referredBy != 0x0000000000000000000000000000000000000000 &&
479 
480             // no cheating!
481             _referredBy != _customerAddress &&
482 
483             // does the referrer have at least X whole tokens?
484             // i.e is the referrer a godly chad masternode
485             tokenBalanceLedger_[_referredBy] >= stakingRequirement
486         ) {
487             // wealth redistribution
488             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
489         } else {
490             // no ref purchase
491             // add the referral bonus back to the global dividends cake
492             _dividends = SafeMath.add(_dividends, _referralBonus);
493             _fee = _dividends * magnitude;
494         }
495 
496         // we can't give people infinite ethereum
497         if (tokenSupply_ > 0) {
498             // add tokens to the pool
499             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
500 
501             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
502             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
503 
504             // calculate the amount of tokens the customer receives over his purchase
505             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
506         } else {
507             // add tokens to the pool
508             tokenSupply_ = _amountOfTokens;
509         }
510 
511         // update circulating supply & the ledger address for the customer
512         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
513 
514         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
515         // really i know you think you do but you don't
516         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
517         payoutsTo_[_customerAddress] += _updatedPayouts;
518 
519         // fire event
520         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
521 
522         // Keep track
523         depositCount_++;
524         return _amountOfTokens;
525     }
526 
527     /**
528      * @dev Calculate Token price based on an amount of incoming ethereum
529      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
530      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
531      */
532     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
533         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
534         uint256 _tokensReceived =
535          (
536             (
537                 // underflow attempts BTFO
538                 SafeMath.sub(
539                     (sqrt
540                         (
541                             (_tokenPriceInitial ** 2)
542                             +
543                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
544                             +
545                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
546                             +
547                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
548                         )
549                     ), _tokenPriceInitial
550                 )
551             ) / (tokenPriceIncremental_)
552         ) - (tokenSupply_);
553 
554         return _tokensReceived;
555     }
556 
557     /**
558      * @dev Calculate token sell value.
559      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
560      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
561      */
562     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
563         uint256 tokens_ = (_tokens + 1e18);
564         uint256 _tokenSupply = (tokenSupply_ + 1e18);
565         uint256 _etherReceived =
566         (
567             // underflow attempts BTFO
568             SafeMath.sub(
569                 (
570                     (
571                         (
572                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
573                         ) - tokenPriceIncremental_
574                     ) * (tokens_ - 1e18)
575                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
576             )
577         / 1e18);
578 
579         return _etherReceived;
580     }
581 
582     /// @dev This is where all your gas goes.
583     function sqrt(uint256 x) internal pure returns (uint256 y) {
584         uint256 z = (x + 1) / 2;
585         y = x;
586 
587         while (z < y) {
588             y = z;
589             z = (x / z + z) / 2;
590         }
591     }
592 
593 
594 }
595 
596 /**
597  * @title SafeMath
598  * @dev Math operations with safety checks that throw on error
599  */
600 library SafeMath {
601 
602     /**
603     * @dev Multiplies two numbers, throws on overflow.
604     */
605     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
606         if (a == 0) {
607             return 0;
608         }
609         uint256 c = a * b;
610         assert(c / a == b);
611         return c;
612     }
613 
614     /**
615     * @dev Integer division of two numbers, truncating the quotient.
616     */
617     function div(uint256 a, uint256 b) internal pure returns (uint256) {
618         // assert(b > 0); // Solidity automatically throws when dividing by 0
619         uint256 c = a / b;
620         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
621         return c;
622     }
623 
624     /**
625     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
626     */
627     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
628         assert(b <= a);
629         return a - b;
630     }
631 
632     /**
633     * @dev Adds two numbers, throws on overflow.
634     */
635     function add(uint256 a, uint256 b) internal pure returns (uint256) {
636         uint256 c = a + b;
637         assert(c >= a);
638         return c;
639     }
640 
641 }