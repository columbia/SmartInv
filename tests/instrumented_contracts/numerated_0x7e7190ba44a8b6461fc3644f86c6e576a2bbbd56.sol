1 pragma solidity ^0.4.24;
2 
3 /***
4  * https://hypereth.net
5  * 
6  * No administrators or developers, this contract is fully autonomous
7  *
8  * 10 % entry fee 
9  * 3 % of entry fee to masternode referrals
10  * 0 % transfer fee
11  * Exit fee starts at 50% from contract start
12  * Exit fee decreases over 30 days until 15%
13  * Stays at 15% forever.
14  */
15 contract Hyperexchange {
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
45           require(ambassadors_[msg.sender] && msg.value == 0.01 ether);
46         }else
47         if (depositCount_ < 1){
48           require(ambassadors_[msg.sender] && msg.value == 0.05 ether);
49         }else
50         if (depositCount_ == 1 || depositCount_==2){
51           require(ambassadors_[msg.sender] && msg.value == 0.1 ether);
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
106     string public name = "HYPER Token";
107     string public symbol = "HYPER";
108     uint8 constant public decimals = 18;
109 
110     /// @dev 10% dividends for token purchase
111     uint8 constant internal entryFee_ = 10;
112 
113     /// @dev 50% dividends for token selling
114     uint8 constant internal startExitFee_ = 50;
115 
116     /// @dev 15% dividends for token selling after step
117     uint8 constant internal finalExitFee_ = 15;
118 
119     /// @dev Exit fee falls over period of 30 days
120     uint256 constant internal exitFeeFallDuration_ = 30 days;
121 
122     /// @dev 3% masternode
123     uint8 constant internal refferalFee_ = 3;
124 
125     /// @dev P3D pricing
126     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
127     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
128 
129     uint256 constant internal magnitude = 2 ** 64;
130 
131     /// @dev 300 needed for masternode activation
132     uint256 public stakingRequirement = 300e18;
133 
134     /// @dev anti-early-whale
135     uint256 public maxEarlyStake = 3 ether;
136     uint256 public whaleBalanceLimit = 125 ether;
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
165      //HyperETH Funding Allocations
166      ambassadors_[msg.sender]=true;
167      //1
168      ambassadors_[0x250F9cD6D75C8CDc34183a51b68ed727B86C1b41]=true;
169          
170      apex = msg.sender;
171    }
172 
173     /*=======================================
174     =            PUBLIC FUNCTIONS           =
175     =======================================*/
176 
177     // @dev Function setting the start time of the system
178     function setStartTime(uint256 _startTime) public {
179       require(msg.sender==apex && !isStarted() && now < _startTime);
180       startTime = _startTime;
181     }
182 
183     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
184     function buy(address _referredBy) antiEarlyWhale notGasbag isControlled public payable  returns (uint256) {
185         purchaseTokens(msg.value, _referredBy , msg.sender);
186     }
187 
188     /// @dev Converts to tokens on behalf of the customer - this allows gifting and integration with other systems
189     function buyFor(address _referredBy, address _customerAddress) antiEarlyWhale notGasbag isControlled public payable returns (uint256) {
190         purchaseTokens(msg.value, _referredBy , _customerAddress);
191     }
192 
193     /**
194      * @dev Fallback function to handle ethereum that was send straight to the contract
195      *  Unfortunately we cannot use a referral address this way.
196      */
197     function() antiEarlyWhale notGasbag isControlled payable public {
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
260         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
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
297         // exchange tokens
298         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
299         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
300 
301         // update dividend trackers
302         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
303         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
304 
305         // fire event
306         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
307 
308         // ERC20
309         return true;
310     }
311 
312 
313     /*=====================================
314     =      HELPERS AND CALCULATORS        =
315     =====================================*/
316 
317     /**
318      * @dev Method to view the current Ethereum stored in the contract
319      *  Example: totalEthereumBalance()
320      */
321     function totalEthereumBalance() public view returns (uint256) {
322         return address(this).balance;
323     }
324 
325     /// @dev Retrieve the total token supply.
326     function totalSupply() public view returns (uint256) {
327         return tokenSupply_;
328     }
329 
330     /// @dev Retrieve the tokens owned by the caller.
331     function myTokens() public view returns (uint256) {
332         address _customerAddress = msg.sender;
333         return balanceOf(_customerAddress);
334     }
335 
336     /**
337      * @dev Retrieve the dividends owned by the caller.
338      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
339      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
340      *  But in the internal calculations, we want them separate.
341      */
342     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
343         address _customerAddress = msg.sender;
344         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
345     }
346 
347     /// @dev Retrieve the token balance of any single address.
348     function balanceOf(address _customerAddress) public view returns (uint256) {
349         return tokenBalanceLedger_[_customerAddress];
350     }
351 
352     /// @dev Retrieve the dividend balance of any single address.
353     function dividendsOf(address _customerAddress) public view returns (uint256) {
354         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
355     }
356 
357     /// @dev Return the sell price of 1 individual token.
358     function sellPrice() public view returns (uint256) {
359         // our calculation relies on the token supply, so we need supply. Doh.
360         if (tokenSupply_ == 0) {
361             return tokenPriceInitial_ - tokenPriceIncremental_;
362         } else {
363             uint256 _ethereum = tokensToEthereum_(1e18);
364             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
365             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
366 
367             return _taxedEthereum;
368         }
369     }
370 
371     /// @dev Return the buy price of 1 individual token.
372     function buyPrice() public view returns (uint256) {
373         // our calculation relies on the token supply, so we need supply. Doh.
374         if (tokenSupply_ == 0) {
375             return tokenPriceInitial_ + tokenPriceIncremental_;
376         } else {
377             uint256 _ethereum = tokensToEthereum_(1e18);
378             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
379             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
380 
381             return _taxedEthereum;
382         }
383     }
384 
385     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
386     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
387         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
388         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
389         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
390         return _amountOfTokens;
391     }
392 
393     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
394     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
395         require(_tokensToSell <= tokenSupply_);
396         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
397         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
398         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
399         return _taxedEthereum;
400     }
401 
402     /// @dev Function for the frontend to get untaxed receivable ethereum.
403     function calculateUntaxedEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
404         require(_tokensToSell <= tokenSupply_);
405         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
406         //uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
407         //uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
408         return _ethereum;
409     }
410 
411 
412     /// @dev Function for getting the current exitFee
413     function exitFee() public view returns (uint8) {
414         if (startTime==0){
415            return startExitFee_;
416         }
417         if ( now < startTime) {
418           return 0;
419         }
420         uint256 secondsPassed = now - startTime;
421         if (secondsPassed >= exitFeeFallDuration_) {
422             return finalExitFee_;
423         }
424         uint8 totalChange = startExitFee_ - finalExitFee_;
425         uint8 currentChange = uint8(totalChange * secondsPassed / exitFeeFallDuration_);
426         uint8 currentFee = startExitFee_- currentChange;
427         return currentFee;
428     }
429 
430     // @dev Function for find if premine
431     function isPremine() public view returns (bool) {
432       return depositCount_<=7;
433     }
434 
435     // @dev Function for find if premine
436     function isStarted() public view returns (bool) {
437       return startTime!=0 && now > startTime;
438     }
439 
440     /*==========================================
441     =            INTERNAL FUNCTIONS            =
442     ==========================================*/
443 
444     /// @dev Internal function to actually purchase the tokens.
445     function purchaseTokens(uint256 _incomingEthereum, address _referredBy , address _customerAddress) internal returns (uint256) {
446         // data setup
447         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
448         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
449         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
450         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
451         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
452         uint256 _fee = _dividends * magnitude;
453 
454         // no point in continuing execution if OP is a poorfag russian hacker
455         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
456         // (or hackers)
457         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
458         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
459 
460         // is the user referred by a masternode?
461         if (
462             // is this a referred purchase?
463             _referredBy != 0x0000000000000000000000000000000000000000 &&
464 
465             // no cheating!
466             _referredBy != _customerAddress &&
467 
468             // does the referrer have at least X whole tokens?
469             // i.e is the referrer a godly chad masternode
470             tokenBalanceLedger_[_referredBy] >= stakingRequirement
471         ) {
472             // wealth redistribution
473             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
474         } else {
475             // no ref purchase
476             // add the referral bonus back to the global dividends cake
477             _dividends = SafeMath.add(_dividends, _referralBonus);
478             _fee = _dividends * magnitude;
479         }
480 
481         // we can't give people infinite ethereum
482         if (tokenSupply_ > 0) {
483             // add tokens to the pool
484             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
485 
486             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
487             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
488 
489             // calculate the amount of tokens the customer receives over his purchase
490             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
491         } else {
492             // add tokens to the pool
493             tokenSupply_ = _amountOfTokens;
494         }
495 
496         // update circulating supply & the ledger address for the customer
497         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
498 
499         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
500         // really i know you think you do but you don't
501         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
502         payoutsTo_[_customerAddress] += _updatedPayouts;
503 
504         // fire event
505         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
506 
507         // Keep track
508         depositCount_++;
509         return _amountOfTokens;
510     }
511 
512     /**
513      * @dev Calculate Token price based on an amount of incoming ethereum
514      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
515      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
516      */
517     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
518         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
519         uint256 _tokensReceived =
520          (
521             (
522                 // underflow attempts BTFO
523                 SafeMath.sub(
524                     (sqrt
525                         (
526                             (_tokenPriceInitial ** 2)
527                             +
528                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
529                             +
530                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
531                             +
532                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
533                         )
534                     ), _tokenPriceInitial
535                 )
536             ) / (tokenPriceIncremental_)
537         ) - (tokenSupply_);
538 
539         return _tokensReceived;
540     }
541 
542     /**
543      * @dev Calculate token sell value.
544      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
545      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
546      */
547     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
548         uint256 tokens_ = (_tokens + 1e18);
549         uint256 _tokenSupply = (tokenSupply_ + 1e18);
550         uint256 _etherReceived =
551         (
552             // underflow attempts BTFO
553             SafeMath.sub(
554                 (
555                     (
556                         (
557                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
558                         ) - tokenPriceIncremental_
559                     ) * (tokens_ - 1e18)
560                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
561             )
562         / 1e18);
563 
564         return _etherReceived;
565     }
566 
567     /// @dev This is where all your gas goes.
568     function sqrt(uint256 x) internal pure returns (uint256 y) {
569         uint256 z = (x + 1) / 2;
570         y = x;
571 
572         while (z < y) {
573             y = z;
574             z = (x / z + z) / 2;
575         }
576     }
577 
578 
579 }
580 
581 /**
582  * @title SafeMath
583  * @dev Math operations with safety checks that throw on error
584  */
585 library SafeMath {
586 
587     /**
588     * @dev Multiplies two numbers, throws on overflow.
589     */
590     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
591         if (a == 0) {
592             return 0;
593         }
594         uint256 c = a * b;
595         assert(c / a == b);
596         return c;
597     }
598 
599     /**
600     * @dev Integer division of two numbers, truncating the quotient.
601     */
602     function div(uint256 a, uint256 b) internal pure returns (uint256) {
603         // assert(b > 0); // Solidity automatically throws when dividing by 0
604         uint256 c = a / b;
605         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
606         return c;
607     }
608 
609     /**
610     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
611     */
612     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
613         assert(b <= a);
614         return a - b;
615     }
616 
617     /**
618     * @dev Adds two numbers, throws on overflow.
619     */
620     function add(uint256 a, uint256 b) internal pure returns (uint256) {
621         uint256 c = a + b;
622         assert(c >= a);
623         return c;
624     }
625 
626 }