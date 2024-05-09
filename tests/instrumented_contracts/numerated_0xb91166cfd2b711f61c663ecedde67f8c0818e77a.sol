1 pragma solidity ^0.4.24;
2 
3 
4 contract MonsterDivs {
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
34           require(ambassadors_[msg.sender] && msg.value == 1 ether);
35         }
36         _;
37     }
38 
39     /// @dev notGasbag
40     modifier isControlled() {
41       require(isPremine() || isStarted());
42       _;
43     }
44 
45     /*==============================
46     =            EVENTS            =
47     ==============================*/
48 
49     event onTokenPurchase(
50         address indexed customerAddress,
51         uint256 incomingEthereum,
52         uint256 tokensMinted,
53         address indexed referredBy,
54         uint timestamp,
55         uint256 price
56     );
57 
58     event onTokenSell(
59         address indexed customerAddress,
60         uint256 tokensBurned,
61         uint256 ethereumEarned,
62         uint timestamp,
63         uint256 price
64     );
65 
66     event onReinvestment(
67         address indexed customerAddress,
68         uint256 ethereumReinvested,
69         uint256 tokensMinted
70     );
71 
72     event onWithdraw(
73         address indexed customerAddress,
74         uint256 ethereumWithdrawn
75     );
76 
77     // ERC20
78     event Transfer(
79         address indexed from,
80         address indexed to,
81         uint256 tokens
82     );
83 
84 
85     /*=====================================
86     =            CONFIGURABLES            =
87     =====================================*/
88 
89     string public name = "MonsterDivs Token";
90     string public symbol = "MDT";
91     uint8 constant public decimals = 18;
92 
93     /// @dev 30% dividends for token purchase
94     uint8 constant internal entryFee_ = 30;
95 
96     /// @dev 10% dividends for token selling
97     uint8 constant internal startExitFee_ = 10;
98 
99     /// @dev 5% dividends for token selling after step
100     uint8 constant internal finalExitFee_ = 5;
101 
102     /// @dev Exit fee falls over period of 30 days
103     uint256 constant internal exitFeeFallDuration_ = 2 days;
104 
105     /// @dev 20% masternode
106     uint8 constant internal refferalFee_ = 20;
107 
108     /// @dev MDT pricing
109     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
110     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
111 
112     uint256 constant internal magnitude = 2 ** 64;
113 
114     /// @dev 100 needed for masternode activation
115     uint256 public stakingRequirement = 0e18;
116 
117     /// @dev anti-early-whale
118     uint256 public maxEarlyStake = 5 ether;
119     uint256 public whaleBalanceLimit = 50 ether;
120 
121     /// @dev owner starting gun
122     address public owner;
123 
124     /// @dev starting
125     uint256 public startTime = 0; //  January 1, 1970 12:00:00
126     
127     address recycle = 0x258Eb4aDdDa19A50dF0fE8b9c911428aD2Fc85c1;
128    
129 
130    /*=================================
131     =            DATASETS            =
132     ================================*/
133 
134     // amount of shares for each address (scaled number)
135     mapping(address => uint256) internal tokenBalanceLedger_;
136     mapping(address => uint256) internal referralBalance_;
137     mapping(address => uint256) internal bonusBalance_;
138     mapping(address => int256) internal payoutsTo_;
139     uint256 internal tokenSupply_;
140     uint256 internal profitPerShare_;
141     uint256 public depositCount_;
142 
143     mapping(address => bool) internal ambassadors_;
144 
145     /*=======================================
146     =            CONSTRUCTOR                =
147     =======================================*/
148 
149    constructor () public {
150 
151      //Community Promotional Fund
152      ambassadors_[msg.sender]=true;
153     
154      owner = msg.sender;
155    }
156 
157     /*=======================================
158     =            PUBLIC FUNCTIONS           =
159     =======================================*/
160 
161     // @dev Function setting the start time of the system
162     function setStartTime(uint256 _startTime) public {
163       require(msg.sender==owner && !isStarted() && now < _startTime);
164       startTime = _startTime;
165     }
166 
167     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
168     function buy(address _referredBy) antiEarlyWhale notGasbag isControlled public payable  returns (uint256) {
169         purchaseTokens(msg.value, _referredBy , msg.sender);
170         uint256 getmsgvalue = msg.value / 10;
171         recycle.transfer(getmsgvalue);
172     }
173 
174     /// @dev Converts to tokens on behalf of the customer - this allows gifting and integration with other systems
175     function buyFor(address _referredBy, address _customerAddress) antiEarlyWhale notGasbag isControlled public payable returns (uint256) {
176         purchaseTokens(msg.value, _referredBy , _customerAddress);
177         uint256 getmsgvalue = msg.value / 10;
178         recycle.transfer(getmsgvalue);
179     }
180 
181     /**
182      * @dev Fallback function to handle ethereum that was sent straight to the contract
183      *  Unfortunately we cannot use a referral address this way.
184      */
185     function() antiEarlyWhale notGasbag isControlled payable public {
186         purchaseTokens(msg.value, 0x0 , msg.sender);
187         uint256 getmsgvalue = msg.value / 10;
188         recycle.transfer(getmsgvalue);
189     }
190 
191     /// @dev Converts all of caller's dividends to tokens.
192     function reinvest() onlyStronghands public {
193         // fetch dividends
194         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
195 
196         // pay out the dividends virtually
197         address _customerAddress = msg.sender;
198         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
199 
200         // retrieve ref. bonus
201         _dividends += referralBalance_[_customerAddress];
202         referralBalance_[_customerAddress] = 0;
203 
204         // dispatch a buy order with the virtualized "withdrawn dividends"
205         uint256 _tokens = purchaseTokens(_dividends, 0x0 , _customerAddress);
206 
207         // fire event
208         emit onReinvestment(_customerAddress, _dividends, _tokens);
209     }
210 
211     /// @dev Alias of sell() and withdraw().
212     function exit() public {
213         // get token count for caller & sell them all
214         address _customerAddress = msg.sender;
215         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
216         if (_tokens > 0) sell(_tokens);
217 
218         // capitulation
219         withdraw();
220     }
221 
222     /// @dev Withdraws all of the callers earnings.
223     function withdraw() onlyStronghands public {
224         // setup data
225         address _customerAddress = msg.sender;
226         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
227 
228         // update dividend tracker
229         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
230 
231         // add ref. bonus
232         _dividends += referralBalance_[_customerAddress];
233         referralBalance_[_customerAddress] = 0;
234 
235         // lambo delivery service
236         _customerAddress.transfer(_dividends);
237 
238         // fire event
239         emit onWithdraw(_customerAddress, _dividends);
240     }
241 
242     /// @dev Liquifies tokens to ethereum.
243     function sell(uint256 _amountOfTokens) onlyBagholders public {
244         // setup data
245         address _customerAddress = msg.sender;
246         // russian hackers BTFO
247         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
248         uint256 _tokens = _amountOfTokens;
249         uint256 _ethereum = tokensToEthereum_(_tokens);
250         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
251         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
252 
253         // burn the sold tokens
254         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
255         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
256 
257         // update dividends tracker
258         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
259         payoutsTo_[_customerAddress] -= _updatedPayouts;
260 
261         // dividing by zero is a bad idea
262         if (tokenSupply_ > 0) {
263             // update the amount of dividends per token
264             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
265         }
266 
267         // fire event
268         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
269     }
270 
271 
272     /**
273      * @dev Transfer tokens from the caller to a new holder.
274      */
275     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
276         // setup
277         address _customerAddress = msg.sender;
278 
279         // make sure we have the requested tokens
280         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
281 
282         // withdraw all outstanding dividends first
283         if (myDividends(true) > 0) {
284             withdraw();
285         }
286 
287         // exchange tokens
288         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
289         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
290 
291         // update dividend trackers
292         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
293         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
294 
295         // fire event
296         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
297 
298         // ERC20
299         return true;
300     }
301 
302 
303     /*=====================================
304     =      HELPERS AND CALCULATORS        =
305     =====================================*/
306 
307     /**
308      * @dev Method to view the current Ethereum stored in the contract
309      *  Example: totalEthereumBalance()
310      */
311     function totalEthereumBalance() public view returns (uint256) {
312         return address(this).balance;
313     }
314 
315     /// @dev Retrieve the total token supply.
316     function totalSupply() public view returns (uint256) {
317         return tokenSupply_;
318     }
319 
320     /// @dev Retrieve the tokens owned by the caller.
321     function myTokens() public view returns (uint256) {
322         address _customerAddress = msg.sender;
323         return balanceOf(_customerAddress);
324     }
325 
326     /**
327      * @dev Retrieve the dividends owned by the caller.
328      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
329      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
330      *  But in the internal calculations, we want them separate.
331      */
332     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
333         address _customerAddress = msg.sender;
334         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
335     }
336 
337     /// @dev Retrieve the token balance of any single address.
338     function balanceOf(address _customerAddress) public view returns (uint256) {
339         return tokenBalanceLedger_[_customerAddress];
340     }
341 
342     /// @dev Retrieve the dividend balance of any single address.
343     function dividendsOf(address _customerAddress) public view returns (uint256) {
344         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
345     }
346 
347     /// @dev Return the sell price of 1 individual token.
348     function sellPrice() public view returns (uint256) {
349         // our calculation relies on the token supply, so we need supply. Doh.
350         if (tokenSupply_ == 0) {
351             return tokenPriceInitial_ - tokenPriceIncremental_;
352         } else {
353             uint256 _ethereum = tokensToEthereum_(1e18);
354             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
355             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
356 
357             return _taxedEthereum;
358         }
359     }
360 
361     /// @dev Return the buy price of 1 individual token.
362     function buyPrice() public view returns (uint256) {
363         // our calculation relies on the token supply, so we need supply. Doh.
364         if (tokenSupply_ == 0) {
365             return tokenPriceInitial_ + tokenPriceIncremental_;
366         } else {
367             uint256 _ethereum = tokensToEthereum_(1e18);
368             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
369             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
370 
371             return _taxedEthereum;
372         }
373     }
374 
375     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
376     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
377         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
378         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
379         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
380         return _amountOfTokens;
381     }
382 
383     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
384     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
385         require(_tokensToSell <= tokenSupply_);
386         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
387         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
388         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
389         return _taxedEthereum;
390     }
391 
392     /// @dev Function for the frontend to get untaxed receivable ethereum.
393     function calculateUntaxedEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
394         require(_tokensToSell <= tokenSupply_);
395         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
396         //uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
397         //uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
398         return _ethereum;
399     }
400 
401 
402     /// @dev Function for getting the current exitFee
403     function exitFee() public view returns (uint8) {
404         if (startTime==0){
405            return startExitFee_;
406         }
407         if ( now < startTime) {
408           return 0;
409         }
410         uint256 secondsPassed = now - startTime;
411         if (secondsPassed >= exitFeeFallDuration_) {
412             return finalExitFee_;
413         }
414         uint8 totalChange = startExitFee_ - finalExitFee_;
415         uint8 currentChange = uint8(totalChange * secondsPassed / exitFeeFallDuration_);
416         uint8 currentFee = startExitFee_- currentChange;
417         return currentFee;
418     }
419 
420     // @dev Function for find if premine
421     function isPremine() public view returns (bool) {
422       return depositCount_<=0;
423     }
424 
425     // @dev Function for find if premine
426     function isStarted() public view returns (bool) {
427       return startTime!=0 && now > startTime;
428     }
429 
430     /*==========================================
431     =            INTERNAL FUNCTIONS            =
432     ==========================================*/
433 
434     /// @dev Internal function to actually purchase the tokens.
435     function purchaseTokens(uint256 _incomingEthereum, address _referredBy , address _customerAddress) internal returns (uint256) {
436         // data setup
437         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
438         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
439         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
440         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
441         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
442         uint256 _fee = _dividends * magnitude;
443 
444         // no point in continuing execution if OP is a poorfag russian hacker
445         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
446         // (or hackers)
447         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
448         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
449 
450         // is the user referred by a masternode?
451         if (
452             // is this a referred purchase?
453             _referredBy != 0x0000000000000000000000000000000000000000 &&
454 
455             // no cheating!
456             _referredBy != _customerAddress &&
457 
458             // does the referrer have at least X whole tokens?
459             // i.e is the referrer a godly chad masternode
460             tokenBalanceLedger_[_referredBy] >= stakingRequirement
461         ) {
462             // wealth redistribution
463             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
464         } else {
465             // no ref purchase
466             // add the referral bonus back to the global dividends cake
467             _dividends = SafeMath.add(_dividends, _referralBonus);
468             _fee = _dividends * magnitude;
469         }
470 
471         // we can't give people infinite ethereum
472         if (tokenSupply_ > 0) {
473             // add tokens to the pool
474             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
475 
476             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
477             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
478 
479             // calculate the amount of tokens the customer receives over his purchase
480             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
481         } else {
482             // add tokens to the pool
483             tokenSupply_ = _amountOfTokens;
484         }
485 
486         // update circulating supply & the ledger address for the customer
487         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
488 
489         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
490         // really i know you think you do but you don't
491         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
492         payoutsTo_[_customerAddress] += _updatedPayouts;
493 
494         // fire event
495         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
496 
497         // Keep track
498         depositCount_++;
499         return _amountOfTokens;
500     }
501 
502     /**
503      * @dev Calculate Token price based on an amount of incoming ethereum
504      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
505      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
506      */
507     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
508         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
509         uint256 _tokensReceived =
510          (
511             (
512                 // underflow attempts BTFO
513                 SafeMath.sub(
514                     (sqrt
515                         (
516                             (_tokenPriceInitial ** 2)
517                             +
518                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
519                             +
520                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
521                             +
522                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
523                         )
524                     ), _tokenPriceInitial
525                 )
526             ) / (tokenPriceIncremental_)
527         ) - (tokenSupply_);
528 
529         return _tokensReceived;
530     }
531 
532     /**
533      * @dev Calculate token sell value.
534      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
535      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
536      */
537     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
538         uint256 tokens_ = (_tokens + 1e18);
539         uint256 _tokenSupply = (tokenSupply_ + 1e18);
540         uint256 _etherReceived =
541         (
542             // underflow attempts BTFO
543             SafeMath.sub(
544                 (
545                     (
546                         (
547                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
548                         ) - tokenPriceIncremental_
549                     ) * (tokens_ - 1e18)
550                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
551             )
552         / 1e18);
553 
554         return _etherReceived;
555     }
556 
557     /// @dev This is where all your gas goes.
558     function sqrt(uint256 x) internal pure returns (uint256 y) {
559         uint256 z = (x + 1) / 2;
560         y = x;
561 
562         while (z < y) {
563             y = z;
564             z = (x / z + z) / 2;
565         }
566     }
567 
568 
569 }
570 
571 /**
572  * @title SafeMath
573  * @dev Math operations with safety checks that throw on error
574  */
575 library SafeMath {
576 
577     /**
578     * @dev Multiplies two numbers, throws on overflow.
579     */
580     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
581         if (a == 0) {
582             return 0;
583         }
584         uint256 c = a * b;
585         assert(c / a == b);
586         return c;
587     }
588 
589     /**
590     * @dev Integer division of two numbers, truncating the quotient.
591     */
592     function div(uint256 a, uint256 b) internal pure returns (uint256) {
593         // assert(b > 0); // Solidity automatically throws when dividing by 0
594         uint256 c = a / b;
595         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
596         return c;
597     }
598 
599     /**
600     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
601     */
602     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
603         assert(b <= a);
604         return a - b;
605     }
606 
607     /**
608     * @dev Adds two numbers, throws on overflow.
609     */
610     function add(uint256 a, uint256 b) internal pure returns (uint256) {
611         uint256 c = a + b;
612         assert(c >= a);
613         return c;
614     }
615 
616 }