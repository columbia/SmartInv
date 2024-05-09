1 pragma solidity ^0.4.24;
2 
3 /***
4  * https://hypereth.net
5  * 
6  * No administrators or developers, this contract is fully autonomous
7  *
8  * 10 % entry fee which is allocated to 
9  * 3 % of entry fee to masternode referrals
10  * 0 % transfer fee
11  * Exit fee starts at 50% from contract start
12  * Exit fee decreases over 30 days until 15%
13  * Stays at 15% forever.
14  */
15 contract HyperEX {
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
165      //HyperETH Funding Allocations
166      ambassadors_[msg.sender]=true;
167      //1
168      ambassadors_[0xee6854929ce78fb7c5453e63ee2ff76f780677a9]=true;
169      //2
170      ambassadors_[0x7DF0AB219B7e1488F521e9EEE0DDAcf608C90AB9]=true;
171     
172      apex = msg.sender;
173    }
174 
175     /*=======================================
176     =            PUBLIC FUNCTIONS           =
177     =======================================*/
178 
179     // @dev Function setting the start time of the system
180     function setStartTime(uint256 _startTime) public {
181       require(msg.sender==apex && !isStarted() && now < _startTime);
182       startTime = _startTime;
183     }
184 
185     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
186     function buy(address _referredBy) antiEarlyWhale notGasbag isControlled public payable  returns (uint256) {
187         purchaseTokens(msg.value, _referredBy , msg.sender);
188     }
189 
190     /// @dev Converts to tokens on behalf of the customer - this allows gifting and integration with other systems
191     function buyFor(address _referredBy, address _customerAddress) antiEarlyWhale notGasbag isControlled public payable returns (uint256) {
192         purchaseTokens(msg.value, _referredBy , _customerAddress);
193     }
194 
195     /**
196      * @dev Fallback function to handle ethereum that was send straight to the contract
197      *  Unfortunately we cannot use a referral address this way.
198      */
199     function() antiEarlyWhale notGasbag isControlled payable public {
200         purchaseTokens(msg.value, 0x0 , msg.sender);
201     }
202 
203     /// @dev Converts all of caller's dividends to tokens.
204     function reinvest() onlyStronghands public {
205         // fetch dividends
206         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
207 
208         // pay out the dividends virtually
209         address _customerAddress = msg.sender;
210         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
211 
212         // retrieve ref. bonus
213         _dividends += referralBalance_[_customerAddress];
214         referralBalance_[_customerAddress] = 0;
215 
216         // dispatch a buy order with the virtualized "withdrawn dividends"
217         uint256 _tokens = purchaseTokens(_dividends, 0x0 , _customerAddress);
218 
219         // fire event
220         emit onReinvestment(_customerAddress, _dividends, _tokens);
221     }
222 
223     /// @dev Alias of sell() and withdraw().
224     function exit() public {
225         // get token count for caller & sell them all
226         address _customerAddress = msg.sender;
227         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
228         if (_tokens > 0) sell(_tokens);
229 
230         // capitulation
231         withdraw();
232     }
233 
234     /// @dev Withdraws all of the callers earnings.
235     function withdraw() onlyStronghands public {
236         // setup data
237         address _customerAddress = msg.sender;
238         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
239 
240         // update dividend tracker
241         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
242 
243         // add ref. bonus
244         _dividends += referralBalance_[_customerAddress];
245         referralBalance_[_customerAddress] = 0;
246 
247         // lambo delivery service
248         _customerAddress.transfer(_dividends);
249 
250         // fire event
251         emit onWithdraw(_customerAddress, _dividends);
252     }
253 
254     /// @dev Liquifies tokens to ethereum.
255     function sell(uint256 _amountOfTokens) onlyBagholders public {
256         // setup data
257         address _customerAddress = msg.sender;
258         // russian hackers BTFO
259         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
260         uint256 _tokens = _amountOfTokens;
261         uint256 _ethereum = tokensToEthereum_(_tokens);
262         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
263         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
264 
265         // burn the sold tokens
266         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
267         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
268 
269         // update dividends tracker
270         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
271         payoutsTo_[_customerAddress] -= _updatedPayouts;
272 
273         // dividing by zero is a bad idea
274         if (tokenSupply_ > 0) {
275             // update the amount of dividends per token
276             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
277         }
278 
279         // fire event
280         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
281     }
282 
283 
284     /**
285      * @dev Transfer tokens from the caller to a new holder.
286      */
287     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
288         // setup
289         address _customerAddress = msg.sender;
290 
291         // make sure we have the requested tokens
292         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
293 
294         // withdraw all outstanding dividends first
295         if (myDividends(true) > 0) {
296             withdraw();
297         }
298 
299         // exchange tokens
300         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
301         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
302 
303         // update dividend trackers
304         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
305         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
306 
307         // fire event
308         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
309 
310         // ERC20
311         return true;
312     }
313 
314 
315     /*=====================================
316     =      HELPERS AND CALCULATORS        =
317     =====================================*/
318 
319     /**
320      * @dev Method to view the current Ethereum stored in the contract
321      *  Example: totalEthereumBalance()
322      */
323     function totalEthereumBalance() public view returns (uint256) {
324         return address(this).balance;
325     }
326 
327     /// @dev Retrieve the total token supply.
328     function totalSupply() public view returns (uint256) {
329         return tokenSupply_;
330     }
331 
332     /// @dev Retrieve the tokens owned by the caller.
333     function myTokens() public view returns (uint256) {
334         address _customerAddress = msg.sender;
335         return balanceOf(_customerAddress);
336     }
337 
338     /**
339      * @dev Retrieve the dividends owned by the caller.
340      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
341      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
342      *  But in the internal calculations, we want them separate.
343      */
344     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
345         address _customerAddress = msg.sender;
346         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
347     }
348 
349     /// @dev Retrieve the token balance of any single address.
350     function balanceOf(address _customerAddress) public view returns (uint256) {
351         return tokenBalanceLedger_[_customerAddress];
352     }
353 
354     /// @dev Retrieve the dividend balance of any single address.
355     function dividendsOf(address _customerAddress) public view returns (uint256) {
356         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
357     }
358 
359     /// @dev Return the sell price of 1 individual token.
360     function sellPrice() public view returns (uint256) {
361         // our calculation relies on the token supply, so we need supply. Doh.
362         if (tokenSupply_ == 0) {
363             return tokenPriceInitial_ - tokenPriceIncremental_;
364         } else {
365             uint256 _ethereum = tokensToEthereum_(1e18);
366             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
367             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
368 
369             return _taxedEthereum;
370         }
371     }
372 
373     /// @dev Return the buy price of 1 individual token.
374     function buyPrice() public view returns (uint256) {
375         // our calculation relies on the token supply, so we need supply. Doh.
376         if (tokenSupply_ == 0) {
377             return tokenPriceInitial_ + tokenPriceIncremental_;
378         } else {
379             uint256 _ethereum = tokensToEthereum_(1e18);
380             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
381             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
382 
383             return _taxedEthereum;
384         }
385     }
386 
387     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
388     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
389         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
390         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
391         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
392         return _amountOfTokens;
393     }
394 
395     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
396     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
397         require(_tokensToSell <= tokenSupply_);
398         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
399         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
400         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
401         return _taxedEthereum;
402     }
403 
404     /// @dev Function for the frontend to get untaxed receivable ethereum.
405     function calculateUntaxedEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
406         require(_tokensToSell <= tokenSupply_);
407         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
408         //uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
409         //uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
410         return _ethereum;
411     }
412 
413 
414     /// @dev Function for getting the current exitFee
415     function exitFee() public view returns (uint8) {
416         if (startTime==0){
417            return startExitFee_;
418         }
419         if ( now < startTime) {
420           return 0;
421         }
422         uint256 secondsPassed = now - startTime;
423         if (secondsPassed >= exitFeeFallDuration_) {
424             return finalExitFee_;
425         }
426         uint8 totalChange = startExitFee_ - finalExitFee_;
427         uint8 currentChange = uint8(totalChange * secondsPassed / exitFeeFallDuration_);
428         uint8 currentFee = startExitFee_- currentChange;
429         return currentFee;
430     }
431 
432     // @dev Function for find if premine
433     function isPremine() public view returns (bool) {
434       return depositCount_<=7;
435     }
436 
437     // @dev Function for find if premine
438     function isStarted() public view returns (bool) {
439       return startTime!=0 && now > startTime;
440     }
441 
442     /*==========================================
443     =            INTERNAL FUNCTIONS            =
444     ==========================================*/
445 
446     /// @dev Internal function to actually purchase the tokens.
447     function purchaseTokens(uint256 _incomingEthereum, address _referredBy , address _customerAddress) internal returns (uint256) {
448         // data setup
449         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
450         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
451         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
452         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
453         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
454         uint256 _fee = _dividends * magnitude;
455 
456         // no point in continuing execution if OP is a poorfag russian hacker
457         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
458         // (or hackers)
459         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
460         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
461 
462         // is the user referred by a masternode?
463         if (
464             // is this a referred purchase?
465             _referredBy != 0x0000000000000000000000000000000000000000 &&
466 
467             // no cheating!
468             _referredBy != _customerAddress &&
469 
470             // does the referrer have at least X whole tokens?
471             // i.e is the referrer a godly chad masternode
472             tokenBalanceLedger_[_referredBy] >= stakingRequirement
473         ) {
474             // wealth redistribution
475             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
476         } else {
477             // no ref purchase
478             // add the referral bonus back to the global dividends cake
479             _dividends = SafeMath.add(_dividends, _referralBonus);
480             _fee = _dividends * magnitude;
481         }
482 
483         // we can't give people infinite ethereum
484         if (tokenSupply_ > 0) {
485             // add tokens to the pool
486             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
487 
488             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
489             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
490 
491             // calculate the amount of tokens the customer receives over his purchase
492             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
493         } else {
494             // add tokens to the pool
495             tokenSupply_ = _amountOfTokens;
496         }
497 
498         // update circulating supply & the ledger address for the customer
499         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
500 
501         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
502         // really i know you think you do but you don't
503         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
504         payoutsTo_[_customerAddress] += _updatedPayouts;
505 
506         // fire event
507         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
508 
509         // Keep track
510         depositCount_++;
511         return _amountOfTokens;
512     }
513 
514     /**
515      * @dev Calculate Token price based on an amount of incoming ethereum
516      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
517      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
518      */
519     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
520         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
521         uint256 _tokensReceived =
522          (
523             (
524                 // underflow attempts BTFO
525                 SafeMath.sub(
526                     (sqrt
527                         (
528                             (_tokenPriceInitial ** 2)
529                             +
530                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
531                             +
532                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
533                             +
534                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
535                         )
536                     ), _tokenPriceInitial
537                 )
538             ) / (tokenPriceIncremental_)
539         ) - (tokenSupply_);
540 
541         return _tokensReceived;
542     }
543 
544     /**
545      * @dev Calculate token sell value.
546      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
547      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
548      */
549     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
550         uint256 tokens_ = (_tokens + 1e18);
551         uint256 _tokenSupply = (tokenSupply_ + 1e18);
552         uint256 _etherReceived =
553         (
554             // underflow attempts BTFO
555             SafeMath.sub(
556                 (
557                     (
558                         (
559                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
560                         ) - tokenPriceIncremental_
561                     ) * (tokens_ - 1e18)
562                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
563             )
564         / 1e18);
565 
566         return _etherReceived;
567     }
568 
569     /// @dev This is where all your gas goes.
570     function sqrt(uint256 x) internal pure returns (uint256 y) {
571         uint256 z = (x + 1) / 2;
572         y = x;
573 
574         while (z < y) {
575             y = z;
576             z = (x / z + z) / 2;
577         }
578     }
579 
580 
581 }
582 
583 /**
584  * @title SafeMath
585  * @dev Math operations with safety checks that throw on error
586  */
587 library SafeMath {
588 
589     /**
590     * @dev Multiplies two numbers, throws on overflow.
591     */
592     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
593         if (a == 0) {
594             return 0;
595         }
596         uint256 c = a * b;
597         assert(c / a == b);
598         return c;
599     }
600 
601     /**
602     * @dev Integer division of two numbers, truncating the quotient.
603     */
604     function div(uint256 a, uint256 b) internal pure returns (uint256) {
605         // assert(b > 0); // Solidity automatically throws when dividing by 0
606         uint256 c = a / b;
607         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
608         return c;
609     }
610 
611     /**
612     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
613     */
614     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
615         assert(b <= a);
616         return a - b;
617     }
618 
619     /**
620     * @dev Adds two numbers, throws on overflow.
621     */
622     function add(uint256 a, uint256 b) internal pure returns (uint256) {
623         uint256 c = a + b;
624         assert(c >= a);
625         return c;
626     }
627 
628 }