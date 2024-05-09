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
57           require(ambassadors_[msg.sender] && msg.value == 1 ether);
58         }else
59         if (depositCount_ < 6){
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
142     uint256 public startTime = 0; //  January 1, 1970 12:00:00
143 
144     /// @dev one shot
145     bool public startCalled = false; //  January 1, 1970 12:00:00
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
172      ambassadors_[0xE4042aE1C40913bA00619392DE669BdB3becEd50]=true;
173      //theodor
174      ambassadors_[0xBAce3371fd1E65DD0255DDef233bD16bFa374DB2]=true;
175      //khan
176      ambassadors_[0x05f2c11996d73288AbE8a31d8b593a693FF2E5D8]=true;
177      //karu
178      ambassadors_[0x54d6fCa0CA37382b01304E6716420538604b447b]=true;
179      //mart
180      ambassadors_[0xaa49BF121D1C4498E3A4a1ADdA6860B9eB40fdDF]=true;
181 
182    }
183 
184     /*=======================================
185     =            PUBLIC FUNCTIONS           =
186     =======================================*/
187 
188     // @dev Function setting the start time of the system
189     function setStartTime(uint256 _startTime) public {
190       require(msg.sender==fuse && !isStarted() && now < _startTime && !startCalled);
191       require(_startTime > now);
192       startTime = _startTime;
193       startCalled = true;
194     }
195 
196     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
197     function buy(address _referredBy) antiEarlyWhale easyOnTheGas isControlled public payable  returns (uint256) {
198         purchaseTokens(msg.value, _referredBy , msg.sender);
199     }
200 
201     /// @dev Converts to tokens on behalf of the customer - this allows gifting and integration with other systems
202     function purchaseFor(address _referredBy, address _customerAddress) antiEarlyWhale easyOnTheGas isControlled public payable returns (uint256) {
203         purchaseTokens(msg.value, _referredBy , _customerAddress);
204     }
205 
206     /**
207      * @dev Fallback function to handle ethereum that was send straight to the contract
208      *  Unfortunately we cannot use a referral address this way.
209      */
210     function() antiEarlyWhale easyOnTheGas isControlled payable public {
211         purchaseTokens(msg.value, 0x0 , msg.sender);
212     }
213 
214     /// @dev Converts all of caller's dividends to tokens.
215     function reinvest() onlyStronghands public {
216         // fetch dividends
217         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
218 
219         // pay out the dividends virtually
220         address _customerAddress = msg.sender;
221         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
222 
223         // retrieve ref. bonus
224         _dividends += referralBalance_[_customerAddress];
225         referralBalance_[_customerAddress] = 0;
226 
227         // dispatch a buy order with the virtualized "withdrawn dividends"
228         uint256 _tokens = purchaseTokens(_dividends, 0x0 , _customerAddress);
229 
230         // fire event
231         emit onReinvestment(_customerAddress, _dividends, _tokens);
232     }
233 
234     /// @dev Alias of sell() and withdraw().
235     function exit() public {
236         // get token count for caller & sell them all
237         address _customerAddress = msg.sender;
238         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
239         if (_tokens > 0) sell(_tokens);
240 
241         // capitulation
242         withdraw();
243     }
244 
245     /// @dev Withdraws all of the callers earnings.
246     function withdraw() onlyStronghands public {
247         // setup data
248         address _customerAddress = msg.sender;
249         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
250 
251         // update dividend tracker
252         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
253 
254         // add ref. bonus
255         _dividends += referralBalance_[_customerAddress];
256         referralBalance_[_customerAddress] = 0;
257 
258         // lambo delivery service
259         _customerAddress.transfer(_dividends);
260 
261         // fire event
262         emit onWithdraw(_customerAddress, _dividends);
263     }
264 
265     /// @dev Liquifies tokens to ethereum.
266     function sell(uint256 _amountOfTokens) onlyBagholders public {
267         // setup data
268         address _customerAddress = msg.sender;
269         // russian hackers BTFO
270         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
271         uint256 _tokens = _amountOfTokens;
272         uint256 _ethereum = tokensToEthereum_(_tokens);
273         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
274         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
275 
276         // burn the sold tokens
277         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
278         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
279 
280         // update dividends tracker
281         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
282         payoutsTo_[_customerAddress] -= _updatedPayouts;
283 
284         // dividing by zero is a bad idea
285         if (tokenSupply_ > 0) {
286             // update the amount of dividends per token
287             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
288         }
289 
290         // fire event
291         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
292     }
293 
294 
295     /**
296      * @dev Transfer tokens from the caller to a new holder.
297      */
298     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
299         // setup
300         address _customerAddress = msg.sender;
301 
302         // make sure we have the requested tokens
303         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
304 
305         // withdraw all outstanding dividends first
306         if (myDividends(true) > 0) {
307             withdraw();
308         }
309 
310         return transferInternal(_toAddress,_amountOfTokens,_customerAddress);
311     }
312 
313     function transferInternal(address _toAddress, uint256 _amountOfTokens , address _fromAddress) internal returns (bool) {
314         // setup
315         address _customerAddress = _fromAddress;
316 
317         // exchange tokens
318         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
319         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
320 
321         // update dividend trackers
322         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
323         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
324 
325         // fire event
326         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
327 
328         // ERC20
329         return true;
330     }
331 
332 
333     /*=====================================
334     =      HELPERS AND CALCULATORS        =
335     =====================================*/
336 
337     /**
338      * @dev Method to view the current Ethereum stored in the contract
339      *  Example: totalEthereumBalance()
340      */
341     function totalEthereumBalance() public view returns (uint256) {
342         return address(this).balance;
343     }
344 
345     /// @dev Retrieve the total token supply.
346     function totalSupply() public view returns (uint256) {
347         return tokenSupply_;
348     }
349 
350     /// @dev Retrieve the tokens owned by the caller.
351     function myTokens() public view returns (uint256) {
352         address _customerAddress = msg.sender;
353         return balanceOf(_customerAddress);
354     }
355 
356     /**
357      * @dev Retrieve the dividends owned by the caller.
358      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
359      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
360      *  But in the internal calculations, we want them separate.
361      */
362     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
363         address _customerAddress = msg.sender;
364         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
365     }
366 
367     /// @dev Retrieve the token balance of any single address.
368     function balanceOf(address _customerAddress) public view returns (uint256) {
369         return tokenBalanceLedger_[_customerAddress];
370     }
371 
372     /// @dev Retrieve the dividend balance of any single address.
373     function dividendsOf(address _customerAddress) public view returns (uint256) {
374         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
375     }
376 
377     /// @dev Return the sell price of 1 individual token.
378     function sellPrice() public view returns (uint256) {
379         // our calculation relies on the token supply, so we need supply. Doh.
380         if (tokenSupply_ == 0) {
381             return tokenPriceInitial_ - tokenPriceIncremental_;
382         } else {
383             uint256 _ethereum = tokensToEthereum_(1e18);
384             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
385             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
386 
387             return _taxedEthereum;
388         }
389     }
390 
391     /// @dev Return the buy price of 1 individual token.
392     function buyPrice() public view returns (uint256) {
393         // our calculation relies on the token supply, so we need supply. Doh.
394         if (tokenSupply_ == 0) {
395             return tokenPriceInitial_ + tokenPriceIncremental_;
396         } else {
397             uint256 _ethereum = tokensToEthereum_(1e18);
398             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee()), 100);
399             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
400 
401             return _taxedEthereum;
402         }
403     }
404 
405     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
406     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
407         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee()), 100);
408         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
409         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
410         return _amountOfTokens;
411     }
412 
413     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
414     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
415         require(_tokensToSell <= tokenSupply_);
416         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
417         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
418         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
419         return _taxedEthereum;
420     }
421 
422     /// @dev Function for the frontend to get untaxed receivable ethereum.
423     function calculateUntaxedEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
424         require(_tokensToSell <= tokenSupply_);
425         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
426         //uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
427         //uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
428         return _ethereum;
429     }
430 
431     function entryFee() public view returns (uint8){
432       uint256 volume = address(this).balance  - msg.value;
433 
434       if (volume<=10 ether){
435         return 40;
436       }
437       if (volume<=20 ether){
438         return 35;
439       }
440       if (volume<=50 ether){
441         return 30;
442       }
443       if (volume<=100 ether){
444         return 25;
445       }
446       if (volume<=250 ether){
447         return 20;
448       }
449       return 15;
450     }
451 
452     // @dev Function for find if premine
453     function isPremine() public view returns (bool) {
454       return depositCount_<=5;
455     }
456 
457     // @dev Function for find if premine
458     function isStarted() public view returns (bool) {
459       return startTime!=0 && now > startTime;
460     }
461 
462     /*==========================================
463     =            INTERNAL FUNCTIONS            =
464     ==========================================*/
465 
466     /// @dev Internal function to actually purchase the tokens.
467     function purchaseTokens(uint256 _incomingEthereum, address _referredBy , address _customerAddress) internal returns (uint256) {
468         // data setup
469         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee()), 100);
470         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
471         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
472         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
473         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
474         uint256 _fee = _dividends * magnitude;
475 
476         // no point in continuing execution if OP is a poorfag russian hacker
477         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
478         // (or hackers)
479         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
480         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
481 
482         // is the user referred by a masternode?
483         if (
484             // is this a referred purchase?
485             _referredBy != 0x0000000000000000000000000000000000000000 &&
486 
487             // no cheating!
488             _referredBy != _customerAddress &&
489 
490             // does the referrer have at least X whole tokens?
491             // i.e is the referrer a godly chad masternode
492             tokenBalanceLedger_[_referredBy] >= stakingRequirement
493         ) {
494             // wealth redistribution
495             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
496         } else {
497             // no ref purchase
498             // add the referral bonus back to the global dividends cake
499             _dividends = SafeMath.add(_dividends, _referralBonus);
500             _fee = _dividends * magnitude;
501         }
502 
503         // we can't give people infinite ethereum
504         if (tokenSupply_ > 0) {
505             // add tokens to the pool
506             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
507 
508             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
509             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
510 
511             // calculate the amount of tokens the customer receives over his purchase
512             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
513         } else {
514             // add tokens to the pool
515             tokenSupply_ = _amountOfTokens;
516         }
517 
518         // update circulating supply & the ledger address for the customer
519         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
520 
521         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
522         // really i know you think you do but you don't
523         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
524         payoutsTo_[_customerAddress] += _updatedPayouts;
525 
526         // fire event
527         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
528 
529         // Keep track
530         depositCount_++;
531         return _amountOfTokens;
532     }
533 
534     /**
535      * @dev Calculate Token price based on an amount of incoming ethereum
536      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
537      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
538      */
539     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
540         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
541         uint256 _tokensReceived =
542          (
543             (
544                 // underflow attempts BTFO
545                 SafeMath.sub(
546                     (sqrt
547                         (
548                             (_tokenPriceInitial ** 2)
549                             +
550                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
551                             +
552                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
553                             +
554                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
555                         )
556                     ), _tokenPriceInitial
557                 )
558             ) / (tokenPriceIncremental_)
559         ) - (tokenSupply_);
560 
561         return _tokensReceived;
562     }
563 
564     /**
565      * @dev Calculate token sell value.
566      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
567      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
568      */
569     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
570         uint256 tokens_ = (_tokens + 1e18);
571         uint256 _tokenSupply = (tokenSupply_ + 1e18);
572         uint256 _etherReceived =
573         (
574             // underflow attempts BTFO
575             SafeMath.sub(
576                 (
577                     (
578                         (
579                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
580                         ) - tokenPriceIncremental_
581                     ) * (tokens_ - 1e18)
582                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
583             )
584         / 1e18);
585 
586         return _etherReceived;
587     }
588 
589     /// @dev This is where all your gas goes.
590     function sqrt(uint256 x) internal pure returns (uint256 y) {
591         uint256 z = (x + 1) / 2;
592         y = x;
593 
594         while (z < y) {
595             y = z;
596             z = (x / z + z) / 2;
597         }
598     }
599 
600 
601 }
602 
603 /**
604  * @title SafeMath
605  * @dev Math operations with safety checks that throw on error
606  */
607 library SafeMath {
608 
609     /**
610     * @dev Multiplies two numbers, throws on overflow.
611     */
612     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
613         if (a == 0) {
614             return 0;
615         }
616         uint256 c = a * b;
617         assert(c / a == b);
618         return c;
619     }
620 
621     /**
622     * @dev Integer division of two numbers, truncating the quotient.
623     */
624     function div(uint256 a, uint256 b) internal pure returns (uint256) {
625         // assert(b > 0); // Solidity automatically throws when dividing by 0
626         uint256 c = a / b;
627         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
628         return c;
629     }
630 
631     /**
632     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
633     */
634     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
635         assert(b <= a);
636         return a - b;
637     }
638 
639     /**
640     * @dev Adds two numbers, throws on overflow.
641     */
642     function add(uint256 a, uint256 b) internal pure returns (uint256) {
643         uint256 c = a + b;
644         assert(c >= a);
645         return c;
646     }
647 
648 }