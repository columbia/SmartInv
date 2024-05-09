1 pragma solidity ^0.4.24;
2 
3 /***
4  * http://apexTWO.online
5  * https://discord.gg/vbWkKPv
6  * this contract has administrators and developers. So did the other one. I don't know why it said it didnt.
7  * If you would like Premine tokens in exchange for helping out, PM Revenge of the Synth in the discord
8  * 
9  * 12 % entry fee
10  * 12 % of entry fee to masternode referrals
11  * 0 % transfer fee
12  * Exit fee starts at 60% from contract start
13  * Exit fee decreases over 30 days  until 12%
14  * Stays at 12% forever.
15  */
16 contract apexTWO {
17 
18     /*=================================
19     =            MODIFIERS            =
20     =================================*/
21 
22     /// @dev Only people with tokens
23     modifier onlyBagholders {
24         require(myTokens() > 0);
25         _;
26     }
27 
28     /// @dev Only people with profits
29     modifier onlyStronghands {
30         require(myDividends(true) > 0);
31         _;
32     }
33 
34     /// @dev notGasbag
35     modifier notGasbag() {
36       require(tx.gasprice < 200999999999);
37       _;
38     }
39 
40     /// @dev Preventing unstable dumping and limit ambassador mine
41     modifier antiEarlyWhale {
42         if (address(this).balance  -msg.value < whaleBalanceLimit){
43           require(msg.value <= maxEarlyStake);
44         }
45         if (depositCount_ == 0){
46           require(ambassadors_[msg.sender] && msg.value == 0.25 ether);
47         }else
48         if (depositCount_ < 6){
49           require(ambassadors_[msg.sender] && msg.value == 0.75 ether);
50         }else
51         if (depositCount_ == 6 || depositCount_==7){
52           require(ambassadors_[msg.sender] && msg.value == 1 ether);
53         }
54         _;
55     }
56 
57     /// @dev notGasbag
58     modifier isControlled() {
59       require(isPremine() || isStarted());
60       _;
61     }
62 
63     /*==============================
64     =            EVENTS            =
65     ==============================*/
66 
67     event onTokenPurchase(
68         address indexed customerAddress,
69         uint256 incomingEthereum,
70         uint256 tokensMinted,
71         address indexed referredBy,
72         uint timestamp,
73         uint256 price
74     );
75 
76     event onTokenSell(
77         address indexed customerAddress,
78         uint256 tokensBurned,
79         uint256 ethereumEarned,
80         uint timestamp,
81         uint256 price
82     );
83 
84     event onReinvestment(
85         address indexed customerAddress,
86         uint256 ethereumReinvested,
87         uint256 tokensMinted
88     );
89 
90     event onWithdraw(
91         address indexed customerAddress,
92         uint256 ethereumWithdrawn
93     );
94 
95     // ERC20
96     event Transfer(
97         address indexed from,
98         address indexed to,
99         uint256 tokens
100     );
101 
102 
103     /*=====================================
104     =            CONFIGURABLES            =
105     =====================================*/
106 
107     string public name = "apexTWO Token";
108     string public symbol = "APX2";
109     uint8 constant public decimals = 18;
110 
111     /// @dev 12% dividends for token purchase
112     uint8 constant internal entryFee_ = 12;
113 
114     /// @dev 60% dividends for token selling
115     uint8 constant internal startExitFee_ = 60;
116 
117     /// @dev 12% dividends for token selling after step
118     uint8 constant internal finalExitFee_ = 12;
119 
120     /// @dev Exit fee falls over period of 30 days
121     uint256 constant internal exitFeeFallDuration_ = 30 days;
122 
123     /// @dev 12% masternode
124     uint8 constant internal refferalFee_ = 12;
125 
126     /// @dev P3D pricing
127     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
128     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
129 
130     uint256 constant internal magnitude = 2 ** 64;
131 
132     /// @dev 100 needed for masternode activation
133     uint256 public stakingRequirement = 100e18;
134 
135     /// @dev anti-early-whale
136     uint256 public maxEarlyStake = 5 ether;
137     uint256 public whaleBalanceLimit = 20 ether;
138 
139     /// @dev apex starting gun
140     address public apex;
141 
142     /// @dev starting
143     uint256 public startTime = 0; //  January 1, 1970 12:00:00
144 
145    /*=================================
146     =            DATASETS            =
147     ================================*/
148 
149     // amount of shares for each address (scaled number)
150     mapping(address => uint256) internal tokenBalanceLedger_;
151     mapping(address => uint256) internal referralBalance_;
152     mapping(address => uint256) internal bonusBalance_;
153     mapping(address => int256) internal payoutsTo_;
154     uint256 internal tokenSupply_;
155     uint256 internal profitPerShare_;
156     uint256 public depositCount_;
157 
158     mapping(address => bool) internal ambassadors_;
159 
160     /*=======================================
161     =            CONSTRUCTOR                =
162     =======================================*/
163 
164    constructor () public {
165 
166      //Community Promotional Fund
167      ambassadors_[msg.sender]=true;
168      //1
169      ambassadors_[0xaf9c025ce6322a23ac00301c714f4f42895c9818]=true;
170      //2
171      ambassadors_[0x44503314c43422764582502e59a6b2905f999d04]=true;
172      //3
173      ambassadors_[0x7b705c83c8c270745955cc3ca5f80fb3acf75d83]=true;
174      //4
175      ambassadors_[0xe25903c5078d01bbea64c01dc1107f40f44141a3]=true;
176      //5
177      ambassadors_[0xe6f43c670cc8a366bbcf6677f43b02754bfb5855]=true;
178      //6
179      ambassadors_[0xe467e0d26344fcc2d64883958ffe27372c84beaa]=true;
180      apex = msg.sender;
181    }
182 
183     /*=======================================
184     =            PUBLIC FUNCTIONS           =
185     =======================================*/
186 
187     // @dev Function setting the start time of the system
188     function setStartTime(uint256 _startTime) public {
189       require(msg.sender==apex && !isStarted() && now < _startTime);
190       startTime = _startTime;
191     }
192 
193     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
194     function buy(address _referredBy) antiEarlyWhale notGasbag isControlled public payable  returns (uint256) {
195         purchaseTokens(msg.value, _referredBy , msg.sender);
196     }
197 
198     /// @dev Converts to tokens on behalf of the customer - this allows gifting and integration with other systems
199     function buyFor(address _referredBy, address _customerAddress) antiEarlyWhale notGasbag isControlled public payable returns (uint256) {
200         purchaseTokens(msg.value, _referredBy , _customerAddress);
201     }
202 
203     /**
204      * @dev Fallback function to handle ethereum that was send straight to the contract
205      *  Unfortunately we cannot use a referral address this way.
206      */
207     function() antiEarlyWhale notGasbag isControlled payable public {
208         purchaseTokens(msg.value, 0x0 , msg.sender);
209     }
210 
211     /// @dev Converts all of caller's dividends to tokens.
212     function reinvest() onlyStronghands public {
213         // fetch dividends
214         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
215 
216         // pay out the dividends virtually
217         address _customerAddress = msg.sender;
218         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
219 
220         // retrieve ref. bonus
221         _dividends += referralBalance_[_customerAddress];
222         referralBalance_[_customerAddress] = 0;
223 
224         // dispatch a buy order with the virtualized "withdrawn dividends"
225         uint256 _tokens = purchaseTokens(_dividends, 0x0 , _customerAddress);
226 
227         // fire event
228         emit onReinvestment(_customerAddress, _dividends, _tokens);
229     }
230 
231     /// @dev Alias of sell() and withdraw().
232     function exit() public {
233         // get token count for caller & sell them all
234         address _customerAddress = msg.sender;
235         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
236         if (_tokens > 0) sell(_tokens);
237 
238         // capitulation
239         withdraw();
240     }
241 
242     /// @dev Withdraws all of the callers earnings.
243     function withdraw() onlyStronghands public {
244         // setup data
245         address _customerAddress = msg.sender;
246         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
247 
248         // update dividend tracker
249         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
250 
251         // add ref. bonus
252         _dividends += referralBalance_[_customerAddress];
253         referralBalance_[_customerAddress] = 0;
254 
255         // lambo delivery service
256         _customerAddress.transfer(_dividends);
257 
258         // fire event
259         emit onWithdraw(_customerAddress, _dividends);
260     }
261 
262     /// @dev Liquifies tokens to ethereum.
263     function sell(uint256 _amountOfTokens) onlyBagholders public {
264         // setup data
265         address _customerAddress = msg.sender;
266         // russian hackers BTFO
267         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
268         uint256 _tokens = _amountOfTokens;
269         uint256 _ethereum = tokensToEthereum_(_tokens);
270         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
271         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
272 
273         // burn the sold tokens
274         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
275         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
276 
277         // update dividends tracker
278         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
279         payoutsTo_[_customerAddress] -= _updatedPayouts;
280 
281         // dividing by zero is a bad idea
282         if (tokenSupply_ > 0) {
283             // update the amount of dividends per token
284             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
285         }
286 
287         // fire event
288         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
289     }
290 
291 
292     /**
293      * @dev Transfer tokens from the caller to a new holder.
294      */
295     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
296         // setup
297         address _customerAddress = msg.sender;
298 
299         // make sure we have the requested tokens
300         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
301 
302         // withdraw all outstanding dividends first
303         if (myDividends(true) > 0) {
304             withdraw();
305         }
306 
307         // exchange tokens
308         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
309         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
310 
311         // update dividend trackers
312         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
313         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
314 
315         // fire event
316         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
317 
318         // ERC20
319         return true;
320     }
321 
322 
323     /*=====================================
324     =      HELPERS AND CALCULATORS        =
325     =====================================*/
326 
327     /**
328      * @dev Method to view the current Ethereum stored in the contract
329      *  Example: totalEthereumBalance()
330      */
331     function totalEthereumBalance() public view returns (uint256) {
332         return address(this).balance;
333     }
334 
335     /// @dev Retrieve the total token supply.
336     function totalSupply() public view returns (uint256) {
337         return tokenSupply_;
338     }
339 
340     /// @dev Retrieve the tokens owned by the caller.
341     function myTokens() public view returns (uint256) {
342         address _customerAddress = msg.sender;
343         return balanceOf(_customerAddress);
344     }
345 
346     /**
347      * @dev Retrieve the dividends owned by the caller.
348      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
349      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
350      *  But in the internal calculations, we want them separate.
351      */
352     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
353         address _customerAddress = msg.sender;
354         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
355     }
356 
357     /// @dev Retrieve the token balance of any single address.
358     function balanceOf(address _customerAddress) public view returns (uint256) {
359         return tokenBalanceLedger_[_customerAddress];
360     }
361 
362     /// @dev Retrieve the dividend balance of any single address.
363     function dividendsOf(address _customerAddress) public view returns (uint256) {
364         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
365     }
366 
367     /// @dev Return the sell price of 1 individual token.
368     function sellPrice() public view returns (uint256) {
369         // our calculation relies on the token supply, so we need supply. Doh.
370         if (tokenSupply_ == 0) {
371             return tokenPriceInitial_ - tokenPriceIncremental_;
372         } else {
373             uint256 _ethereum = tokensToEthereum_(1e18);
374             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
375             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
376 
377             return _taxedEthereum;
378         }
379     }
380 
381     /// @dev Return the buy price of 1 individual token.
382     function buyPrice() public view returns (uint256) {
383         // our calculation relies on the token supply, so we need supply. Doh.
384         if (tokenSupply_ == 0) {
385             return tokenPriceInitial_ + tokenPriceIncremental_;
386         } else {
387             uint256 _ethereum = tokensToEthereum_(1e18);
388             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
389             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
390 
391             return _taxedEthereum;
392         }
393     }
394 
395     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
396     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
397         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
398         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
399         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
400         return _amountOfTokens;
401     }
402 
403     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
404     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
405         require(_tokensToSell <= tokenSupply_);
406         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
407         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
408         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
409         return _taxedEthereum;
410     }
411 
412     /// @dev Function for the frontend to get untaxed receivable ethereum.
413     function calculateUntaxedEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
414         require(_tokensToSell <= tokenSupply_);
415         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
416         //uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
417         //uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
418         return _ethereum;
419     }
420 
421 
422     /// @dev Function for getting the current exitFee
423     function exitFee() public view returns (uint8) {
424         if (startTime==0){
425            return startExitFee_;
426         }
427         if ( now < startTime) {
428           return 0;
429         }
430         uint256 secondsPassed = now - startTime;
431         if (secondsPassed >= exitFeeFallDuration_) {
432             return finalExitFee_;
433         }
434         uint8 totalChange = startExitFee_ - finalExitFee_;
435         uint8 currentChange = uint8(totalChange * secondsPassed / exitFeeFallDuration_);
436         uint8 currentFee = startExitFee_- currentChange;
437         return currentFee;
438     }
439 
440     // @dev Function for find if premine
441     function isPremine() public view returns (bool) {
442       return depositCount_<=7;
443     }
444 
445     // @dev Function for find if premine
446     function isStarted() public view returns (bool) {
447       return startTime!=0 && now > startTime;
448     }
449 
450     /*==========================================
451     =            INTERNAL FUNCTIONS            =
452     ==========================================*/
453 
454     /// @dev Internal function to actually purchase the tokens.
455     function purchaseTokens(uint256 _incomingEthereum, address _referredBy , address _customerAddress) internal returns (uint256) {
456         // data setup
457         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
458         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
459         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
460         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
461         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
462         uint256 _fee = _dividends * magnitude;
463 
464         // no point in continuing execution if OP is a poorfag russian hacker
465         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
466         // (or hackers)
467         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
468         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
469 
470         // is the user referred by a masternode?
471         if (
472             // is this a referred purchase?
473             _referredBy != 0x0000000000000000000000000000000000000000 &&
474 
475             // no cheating!
476             _referredBy != _customerAddress &&
477 
478             // does the referrer have at least X whole tokens?
479             // i.e is the referrer a godly chad masternode
480             tokenBalanceLedger_[_referredBy] >= stakingRequirement
481         ) {
482             // wealth redistribution
483             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
484         } else {
485             // no ref purchase
486             // add the referral bonus back to the global dividends cake
487             _dividends = SafeMath.add(_dividends, _referralBonus);
488             _fee = _dividends * magnitude;
489         }
490 
491         // we can't give people infinite ethereum
492         if (tokenSupply_ > 0) {
493             // add tokens to the pool
494             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
495 
496             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
497             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
498 
499             // calculate the amount of tokens the customer receives over his purchase
500             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
501         } else {
502             // add tokens to the pool
503             tokenSupply_ = _amountOfTokens;
504         }
505 
506         // update circulating supply & the ledger address for the customer
507         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
508 
509         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
510         // really i know you think you do but you don't
511         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
512         payoutsTo_[_customerAddress] += _updatedPayouts;
513 
514         // fire event
515         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
516 
517         // Keep track
518         depositCount_++;
519         return _amountOfTokens;
520     }
521 
522     /**
523      * @dev Calculate Token price based on an amount of incoming ethereum
524      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
525      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
526      */
527     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
528         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
529         uint256 _tokensReceived =
530          (
531             (
532                 // underflow attempts BTFO
533                 SafeMath.sub(
534                     (sqrt
535                         (
536                             (_tokenPriceInitial ** 2)
537                             +
538                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
539                             +
540                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
541                             +
542                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
543                         )
544                     ), _tokenPriceInitial
545                 )
546             ) / (tokenPriceIncremental_)
547         ) - (tokenSupply_);
548 
549         return _tokensReceived;
550     }
551 
552     /**
553      * @dev Calculate token sell value.
554      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
555      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
556      */
557     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
558         uint256 tokens_ = (_tokens + 1e18);
559         uint256 _tokenSupply = (tokenSupply_ + 1e18);
560         uint256 _etherReceived =
561         (
562             // underflow attempts BTFO
563             SafeMath.sub(
564                 (
565                     (
566                         (
567                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
568                         ) - tokenPriceIncremental_
569                     ) * (tokens_ - 1e18)
570                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
571             )
572         / 1e18);
573 
574         return _etherReceived;
575     }
576 
577     /// @dev This is where all your gas goes.
578     function sqrt(uint256 x) internal pure returns (uint256 y) {
579         uint256 z = (x + 1) / 2;
580         y = x;
581 
582         while (z < y) {
583             y = z;
584             z = (x / z + z) / 2;
585         }
586     }
587 
588 
589 }
590 
591 /**
592  * @title SafeMath
593  * @dev Math operations with safety checks that throw on error
594  */
595 library SafeMath {
596 
597     /**
598     * @dev Multiplies two numbers, throws on overflow.
599     */
600     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
601         if (a == 0) {
602             return 0;
603         }
604         uint256 c = a * b;
605         assert(c / a == b);
606         return c;
607     }
608 
609     /**
610     * @dev Integer division of two numbers, truncating the quotient.
611     */
612     function div(uint256 a, uint256 b) internal pure returns (uint256) {
613         // assert(b > 0); // Solidity automatically throws when dividing by 0
614         uint256 c = a / b;
615         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
616         return c;
617     }
618 
619     /**
620     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
621     */
622     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
623         assert(b <= a);
624         return a - b;
625     }
626 
627     /**
628     * @dev Adds two numbers, throws on overflow.
629     */
630     function add(uint256 a, uint256 b) internal pure returns (uint256) {
631         uint256 c = a + b;
632         assert(c >= a);
633         return c;
634     }
635 
636 }