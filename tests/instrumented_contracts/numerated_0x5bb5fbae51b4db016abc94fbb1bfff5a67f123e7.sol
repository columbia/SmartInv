1 pragma solidity ^0.4.25;
2 /***
3  * Gods of Olympus contract closed until 4.12.2018 23:00 UTC
4  * 
5  * 
6  * Volume Based Entry Fees
7  * 0-10 eth 40%
8  * 10-20 eth 35%
9  * 20-50 eth 30%
10  * 50-100 eth 25%
11  * 100- 250 eth 20%
12  * 250- infinity 15%
13  *
14  * Masternode referral bonus 33% of entry fee
15  * Exit Fee: 15% - always.
16  *
17  * Temple Warning: Do not play with more than you can afford to lose.
18  *
19  */
20 
21 contract GodsOfOlympus {
22 
23     /*=================================
24     =            MODIFIERS            =
25     =================================*/
26 
27     /// @dev Only people with tokens
28     modifier onlyBagholders {
29         require(myTokens() > 0);
30         _;
31     }
32 
33     /// @dev Only people with profits
34     modifier onlyStronghands {
35         require(myDividends(true) > 0);
36         _;
37     }
38 
39     /// @dev easyOnTheGas
40     modifier easyOnTheGas() {
41       require(tx.gasprice < 200999999999);
42       _;
43     }
44 
45     /// @dev Preventing unstable dumping and limit ambassador mine
46     modifier antiEarlyWhale {
47         if (address(this).balance  -msg.value < whaleBalanceLimit){
48           require(msg.value <= maxEarlyStake);
49         }
50         if (depositCount_ == 0){
51           require(ambassadors_[msg.sender] && msg.value == 0.5 ether);
52         }else
53         if (depositCount_ < 2){
54           require(ambassadors_[msg.sender] && msg.value == 0.4 ether);
55         }
56         _;
57     }
58 
59     /// @dev easyOnTheGas
60     modifier isControlled() {
61       require(isPremine() || isStarted());
62       _;
63     }
64 
65     /*==============================
66     =            EVENTS            =
67     ==============================*/
68 
69     event onTokenPurchase(
70         address indexed customerAddress,
71         uint256 incomingEthereum,
72         uint256 tokensMinted,
73         address indexed referredBy,
74         uint timestamp,
75         uint256 price
76     );
77 
78     event onTokenSell(
79         address indexed customerAddress,
80         uint256 tokensBurned,
81         uint256 ethereumEarned,
82         uint timestamp,
83         uint256 price
84     );
85 
86     event onReinvestment(
87         address indexed customerAddress,
88         uint256 ethereumReinvested,
89         uint256 tokensMinted
90     );
91 
92     event onWithdraw(
93         address indexed customerAddress,
94         uint256 ethereumWithdrawn
95     );
96 
97     // ERC20
98     event Transfer(
99         address indexed from,
100         address indexed to,
101         uint256 tokens
102     );
103 
104 
105     /*=====================================
106     =            CONFIGURABLES            =
107     =====================================*/
108 
109     string public name = "Gods of Olympus";
110     string public symbol = "GOO";
111     uint8 constant public decimals = 18;
112 
113     /// @dev 15% dividends for token selling
114     uint8 constant internal exitFee_ = 15;
115 
116     /// @dev 33% masternode
117     uint8 constant internal refferalFee_ = 33;
118 
119     /// @dev P3D pricing
120     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
121     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
122 
123     uint256 constant internal magnitude = 2 ** 64;
124 
125     /// @dev 100 needed for masternode activation
126     uint256 public stakingRequirement = 100e18;
127 
128     /// @dev anti-early-whale
129     uint256 public maxEarlyStake = 2.5 ether;
130     uint256 public whaleBalanceLimit = 100 ether;
131 
132     /// @dev light the fuse
133     address public fuse;
134 
135     /// @dev starting
136     uint256 public startTime = 0; 
137 
138     /// @dev one shot
139     bool public startCalled = false; 
140 
141 
142    /*=================================
143     =            DATASETS            =
144     ================================*/
145 
146     // amount of shares for each address (scaled number)
147     mapping(address => uint256) internal tokenBalanceLedger_;
148     mapping(address => uint256) internal referralBalance_;
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
162      fuse = msg.sender;
163      // Masternode sales & promotional fund
164      ambassadors_[fuse]=true;
165      
166      ambassadors_[0xaED453F0F301688402FEC662ebBF6bbB1cE6D90E]=true;
167      ambassadors_[0xAb219a0e8FDa547bCCDa840b4D9c9E761178C27c]=true;
168      
169    }
170 
171     /*=======================================
172     =            PUBLIC FUNCTIONS           =
173     =======================================*/
174 
175     // @dev Function setting the start time of the system
176     function setStartTime(uint256 _startTime) public {
177       require(msg.sender==fuse && !isStarted() && now < _startTime && !startCalled);
178       require(_startTime > now);
179       startTime = _startTime;
180       startCalled = true;
181     }
182 
183     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
184     function buy(address _referredBy) antiEarlyWhale easyOnTheGas isControlled public payable  returns (uint256) {
185         purchaseTokens(msg.value, _referredBy , msg.sender);
186     }
187 
188     /// @dev Converts to tokens on behalf of the customer - this allows gifting and integration with other systems
189     function purchaseFor(address _referredBy, address _customerAddress) antiEarlyWhale easyOnTheGas isControlled public payable returns (uint256) {
190         purchaseTokens(msg.value, _referredBy , _customerAddress);
191     }
192 
193     /**
194      * @dev Fallback function to handle ethereum that was send straight to the contract
195      *  Unfortunately we cannot use a referral address this way.
196      */
197     function() antiEarlyWhale easyOnTheGas isControlled payable public {
198         purchaseTokens(msg.value, 0x0 , msg.sender);
199     }
200 
201     /// @dev Converts all of caller's dividends to tokens.
202     function reinvest() onlyStronghands public {
203         // fetch dividends
204         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
205 
206         // pay out the dividends virtually
207         address _customerAddress = msg.sender;
208         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
209 
210         // retrieve ref. bonus
211         _dividends += referralBalance_[_customerAddress];
212         referralBalance_[_customerAddress] = 0;
213 
214         // dispatch a buy order with the virtualized "withdrawn dividends"
215         uint256 _tokens = purchaseTokens(_dividends, 0x0 , _customerAddress);
216 
217         // fire event
218         emit onReinvestment(_customerAddress, _dividends, _tokens);
219     }
220 
221     /// @dev Alias of sell() and withdraw().
222     function exit() public {
223         // get token count for caller & sell them all
224         address _customerAddress = msg.sender;
225         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
226         if (_tokens > 0) sell(_tokens);
227 
228         // capitulation
229         withdraw();
230     }
231 
232     /// @dev Withdraws all of the callers earnings.
233     function withdraw() onlyStronghands public {
234         // setup data
235         address _customerAddress = msg.sender;
236         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
237 
238         // update dividend tracker
239         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
240 
241         // add ref. bonus
242         _dividends += referralBalance_[_customerAddress];
243         referralBalance_[_customerAddress] = 0;
244 
245         // lambo delivery service
246         _customerAddress.transfer(_dividends);
247 
248         // fire event
249         emit onWithdraw(_customerAddress, _dividends);
250     }
251 
252     /// @dev Liquifies tokens to ethereum.
253     function sell(uint256 _amountOfTokens) onlyBagholders public {
254         // setup data
255         address _customerAddress = msg.sender;
256         // russian hackers BTFO
257         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
258         uint256 _tokens = _amountOfTokens;
259         uint256 _ethereum = tokensToEthereum_(_tokens);
260         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
261         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
262 
263         // burn the sold tokens
264         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
265         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
266 
267         // update dividends tracker
268         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
269         payoutsTo_[_customerAddress] -= _updatedPayouts;
270 
271         // dividing by zero is a bad idea
272         if (tokenSupply_ > 0) {
273             // update the amount of dividends per token
274             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
275         }
276 
277         // fire event
278         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
279     }
280 
281 
282     /**
283      * @dev Transfer tokens from the caller to a new holder.
284      */
285     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
286         // setup
287         address _customerAddress = msg.sender;
288 
289         // make sure we have the requested tokens
290         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
291 
292         // withdraw all outstanding dividends first
293         if (myDividends(true) > 0) {
294             withdraw();
295         }
296 
297         return transferInternal(_toAddress,_amountOfTokens,_customerAddress);
298     }
299 
300     function transferInternal(address _toAddress, uint256 _amountOfTokens , address _fromAddress) internal returns (bool) {
301         // setup
302         address _customerAddress = _fromAddress;
303 
304         // exchange tokens
305         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
306         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
307 
308         // update dividend trackers
309         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
310         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
311 
312         // fire event
313         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
314 
315         // ERC20
316         return true;
317     }
318 
319 
320     /*=====================================
321     =      HELPERS AND CALCULATORS        =
322     =====================================*/
323 
324     /**
325      * @dev Method to view the current Ethereum stored in the contract
326      *  Example: totalEthereumBalance()
327      */
328     function totalEthereumBalance() public view returns (uint256) {
329         return address(this).balance;
330     }
331 
332     /// @dev Retrieve the total token supply.
333     function totalSupply() public view returns (uint256) {
334         return tokenSupply_;
335     }
336 
337     /// @dev Retrieve the tokens owned by the caller.
338     function myTokens() public view returns (uint256) {
339         address _customerAddress = msg.sender;
340         return balanceOf(_customerAddress);
341     }
342 
343     /**
344      * @dev Retrieve the dividends owned by the caller.
345      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
346      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
347      *  But in the internal calculations, we want them separate.
348      */
349     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
350         address _customerAddress = msg.sender;
351         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
352     }
353 
354     /// @dev Retrieve the token balance of any single address.
355     function balanceOf(address _customerAddress) public view returns (uint256) {
356         return tokenBalanceLedger_[_customerAddress];
357     }
358 
359     /// @dev Retrieve the dividend balance of any single address.
360     function dividendsOf(address _customerAddress) public view returns (uint256) {
361         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
362     }
363 
364     /// @dev Return the sell price of 1 individual token.
365     function sellPrice() public view returns (uint256) {
366         // our calculation relies on the token supply, so we need supply. Doh.
367         if (tokenSupply_ == 0) {
368             return tokenPriceInitial_ - tokenPriceIncremental_;
369         } else {
370             uint256 _ethereum = tokensToEthereum_(1e18);
371             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
372             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
373 
374             return _taxedEthereum;
375         }
376     }
377 
378     /// @dev Return the buy price of 1 individual token.
379     function buyPrice() public view returns (uint256) {
380         // our calculation relies on the token supply, so we need supply. Doh.
381         if (tokenSupply_ == 0) {
382             return tokenPriceInitial_ + tokenPriceIncremental_;
383         } else {
384             uint256 _ethereum = tokensToEthereum_(1e18);
385             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee()), 100);
386             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
387 
388             return _taxedEthereum;
389         }
390     }
391 
392     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
393     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
394         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee()), 100);
395         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
396         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
397         return _amountOfTokens;
398     }
399 
400     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
401     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
402         require(_tokensToSell <= tokenSupply_);
403         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
404         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
405         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
406         return _taxedEthereum;
407     }
408 
409     /// @dev Function for the frontend to get untaxed receivable ethereum.
410     function calculateUntaxedEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
411         require(_tokensToSell <= tokenSupply_);
412         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
413         //uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
414         //uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
415         return _ethereum;
416     }
417 
418     function entryFee() public view returns (uint8){
419       uint256 volume = address(this).balance  - msg.value;
420 
421       if (volume<=10 ether){
422         return 40;
423       }
424       if (volume<=20 ether){
425         return 35;
426       }
427       if (volume<=50 ether){
428         return 30;
429       }
430       if (volume<=100 ether){
431         return 25;
432       }
433       if (volume<=250 ether){
434         return 20;
435       }
436       return 15;
437     }
438 
439     // @dev Function for find if premine
440     function isPremine() public view returns (bool) {
441       return depositCount_<=5;
442     }
443 
444     // @dev Function for find if premine
445     function isStarted() public view returns (bool) {
446       return startTime!=0 && now > startTime;
447     }
448 
449     /*==========================================
450     =            INTERNAL FUNCTIONS            =
451     ==========================================*/
452 
453     /// @dev Internal function to actually purchase the tokens.
454     function purchaseTokens(uint256 _incomingEthereum, address _referredBy , address _customerAddress) internal returns (uint256) {
455         // data setup
456         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee()), 100);
457         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
458         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
459         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
460         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
461         uint256 _fee = _dividends * magnitude;
462 
463         // no point in continuing execution if OP is a poorfag russian hacker
464         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
465         // (or hackers)
466         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
467         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
468 
469         // is the user referred by a masternode?
470         if (
471             // is this a referred purchase?
472             _referredBy != 0x0000000000000000000000000000000000000000 &&
473 
474             // no cheating!
475             _referredBy != _customerAddress &&
476 
477             // does the referrer have at least X whole tokens?
478             // i.e is the referrer a godly chad masternode
479             tokenBalanceLedger_[_referredBy] >= stakingRequirement
480         ) {
481             // wealth redistribution
482             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
483         } else {
484             // no ref purchase
485             // add the referral bonus back to the global dividends cake
486             _dividends = SafeMath.add(_dividends, _referralBonus);
487             _fee = _dividends * magnitude;
488         }
489 
490         // we can't give people infinite ethereum
491         if (tokenSupply_ > 0) {
492             // add tokens to the pool
493             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
494 
495             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
496             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
497 
498             // calculate the amount of tokens the customer receives over his purchase
499             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
500         } else {
501             // add tokens to the pool
502             tokenSupply_ = _amountOfTokens;
503         }
504 
505         // update circulating supply & the ledger address for the customer
506         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
507 
508         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
509         // really i know you think you do but you don't
510         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
511         payoutsTo_[_customerAddress] += _updatedPayouts;
512 
513         // fire event
514         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
515 
516         // Keep track
517         depositCount_++;
518         return _amountOfTokens;
519     }
520 
521     /**
522      * @dev Calculate Token price based on an amount of incoming ethereum
523      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
524      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
525      */
526     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
527         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
528         uint256 _tokensReceived =
529          (
530             (
531                 // underflow attempts BTFO
532                 SafeMath.sub(
533                     (sqrt
534                         (
535                             (_tokenPriceInitial ** 2)
536                             +
537                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
538                             +
539                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
540                             +
541                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
542                         )
543                     ), _tokenPriceInitial
544                 )
545             ) / (tokenPriceIncremental_)
546         ) - (tokenSupply_);
547 
548         return _tokensReceived;
549     }
550 
551     /**
552      * @dev Calculate token sell value.
553      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
554      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
555      */
556     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
557         uint256 tokens_ = (_tokens + 1e18);
558         uint256 _tokenSupply = (tokenSupply_ + 1e18);
559         uint256 _etherReceived =
560         (
561             // underflow attempts BTFO
562             SafeMath.sub(
563                 (
564                     (
565                         (
566                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
567                         ) - tokenPriceIncremental_
568                     ) * (tokens_ - 1e18)
569                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
570             )
571         / 1e18);
572 
573         return _etherReceived;
574     }
575 
576     /// @dev This is where all your gas goes.
577     function sqrt(uint256 x) internal pure returns (uint256 y) {
578         uint256 z = (x + 1) / 2;
579         y = x;
580 
581         while (z < y) {
582             y = z;
583             z = (x / z + z) / 2;
584         }
585     }
586 
587 
588 }
589 
590 /**
591  * @title SafeMath
592  * @dev Math operations with safety checks that throw on error
593  */
594 library SafeMath {
595 
596     /**
597     * @dev Multiplies two numbers, throws on overflow.
598     */
599     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
600         if (a == 0) {
601             return 0;
602         }
603         uint256 c = a * b;
604         assert(c / a == b);
605         return c;
606     }
607 
608     /**
609     * @dev Integer division of two numbers, truncating the quotient.
610     */
611     function div(uint256 a, uint256 b) internal pure returns (uint256) {
612         // assert(b > 0); // Solidity automatically throws when dividing by 0
613         uint256 c = a / b;
614         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
615         return c;
616     }
617 
618     /**
619     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
620     */
621     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
622         assert(b <= a);
623         return a - b;
624     }
625 
626     /**
627     * @dev Adds two numbers, throws on overflow.
628     */
629     function add(uint256 a, uint256 b) internal pure returns (uint256) {
630         uint256 c = a + b;
631         assert(c >= a);
632         return c;
633     }
634 
635 }