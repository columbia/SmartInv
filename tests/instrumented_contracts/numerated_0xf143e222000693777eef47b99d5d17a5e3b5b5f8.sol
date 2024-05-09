1 pragma solidity ^0.4.20;
2 
3 contract NeverEndingApp {
4 
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
22 
23     /*==============================
24     =            EVENTS            =
25     ==============================*/
26 
27     event onTokenPurchase(
28         address indexed customerAddress,
29         uint256 incomingEthereum,
30         uint256 tokensMinted,
31         address indexed referredBy,
32         uint timestamp,
33         uint256 price
34     );
35 
36     event onTokenSell(
37         address indexed customerAddress,
38         uint256 tokensBurned,
39         uint256 ethereumEarned,
40         uint timestamp,
41         uint256 price
42     );
43 
44     event onReinvestment(
45         address indexed customerAddress,
46         uint256 ethereumReinvested,
47         uint256 tokensMinted
48     );
49 
50     event onWithdraw(
51         address indexed customerAddress,
52         uint256 ethereumWithdrawn
53     );
54 
55     // ERC20
56     event Transfer(
57         address indexed from,
58         address indexed to,
59         uint256 tokens
60     );
61 
62 
63     /*=====================================
64     =            CONFIGURABLES            =
65     =====================================*/
66 
67     string public name = "Never Ending App";
68     string public symbol = "Neathereum";
69     uint8 constant public decimals = 18;
70 
71     /// @dev 
72     uint8 constant internal entryFee_ = 30;
73 
74     /// @dev 
75     uint8 constant internal transferFee_ = 7;
76 
77     /// @dev 
78     uint8 constant internal exitFee_ = 3;
79 
80     /// @dev 38% masternode
81     uint8 constant internal refferalFee_ = 38;
82 
83     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
84     uint256 constant internal tokenPriceIncremental_ = 0.000000005 ether;
85     uint256 constant internal magnitude = 2 ** 64;
86 
87     /// @dev 
88     uint256 public stakingRequirement = 50e18;
89     
90     address internal devFeeAddress = 0x5B2FA02281491E51a97c0b087215c8b2597C8a2f;
91     address internal employeeFeeAddress = 0x17103d0Be87aD32f7fA17930f5A0c5c7beF2F4a8; // OMO
92     address internal employeeFeeAddress1 = 0x56deBe7ed7C66d867304ed5aD5FE1Da76C8404bE; // UB
93     address internal employeeFeeAddress2 = 0x4f574642be8C00BD916803c4BC1EC1FC05efa5cF; // OPEN
94     address internal neatFeeAddress = 0x1fE96BD388451E7640bf72f834ADC7FC9B69Ba11;
95 
96     
97     address internal admin;
98     mapping(address => bool) internal ambassadors_;
99 
100 
101    /*=================================
102     =            DATASETS            =
103     ================================*/
104 
105     // amount of shares for each address (scaled number)
106     mapping(address => uint256) internal tokenBalanceLedger_;
107     mapping(address => uint256) internal referralBalance_;
108     mapping(address => int256) internal payoutsTo_;
109     uint256 internal tokenSupply_;
110     uint256 internal profitPerShare_;
111     uint256 constant internal ambassadorMaxPurchase_ = 0.55 ether;
112     uint256 constant internal ambassadorQuota_ = 5000 ether;
113     bool public onlyAmbassadors = true;
114     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
115     
116     uint ACTIVATION_TIME = 1547319601;
117     
118     modifier antiEarlyWhale(uint256 _amountOfEthereum){
119         if (now >= ACTIVATION_TIME) {
120             onlyAmbassadors = false;
121         }
122         // are we still in the vulnerable phase?
123         // if so, enact anti early whale protocol 
124         if(onlyAmbassadors){
125             require(
126                 // is the customer in the ambassador list?
127                 (ambassadors_[msg.sender] == true &&
128                 
129                 // does the customer purchase exceed the max ambassador quota?
130                 (ambassadorAccumulatedQuota_[msg.sender] + _amountOfEthereum) <= ambassadorMaxPurchase_)
131                 
132             );
133             
134             // updated the accumulated quota    
135             ambassadorAccumulatedQuota_[msg.sender] = SafeMath.add(ambassadorAccumulatedQuota_[msg.sender], _amountOfEthereum);
136         
137             // execute
138             _;
139         }else{
140             onlyAmbassadors=false;
141             _;
142         }
143         
144     }
145     
146     
147     function NeverEndingApp() public{
148         admin=msg.sender;
149         ambassadors_[0x4f574642be8C00BD916803c4BC1EC1FC05efa5cF] = true; //
150         ambassadors_[0x56deBe7ed7C66d867304ed5aD5FE1Da76C8404bE] = true; // 
151         ambassadors_[0x267fa9F2F846da2c7A07eCeCc52dF7F493589098] = true; // 
152         
153         
154         
155         
156 
157     }
158     
159   function disableAmbassadorPhase() public{
160         require(admin==msg.sender);
161         onlyAmbassadors=false;
162     }
163 
164   function changeEmployee(address _employeeAddress) public{
165         require(admin==msg.sender);
166         employeeFeeAddress=_employeeAddress;
167     }
168     
169   function changeEmployee1(address _employeeAddress1) public{
170         require(admin==msg.sender);
171         employeeFeeAddress1=_employeeAddress1;
172     }
173     
174   function changeEmployee2(address _employeeAddress2) public{
175         require(admin==msg.sender);
176         employeeFeeAddress2=_employeeAddress2;
177     }
178     
179   function changeNeat(address _neatAddress) public{
180         require(admin==msg.sender);
181         neatFeeAddress=_neatAddress;
182     }
183     
184     /*=======================================
185     =            PUBLIC FUNCTIONS           =
186     =======================================*/
187 
188     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
189     function buy(address _referredBy) public payable returns (uint256) {
190         purchaseTokens(msg.value, _referredBy);
191     }
192 
193     /**
194      * @dev Fallback function to handle ethereum that was send straight to the contract
195      *  Unfortunately we cannot use a referral address this way.
196      */
197     function() payable public {
198         purchaseTokens(msg.value, 0x0);
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
215         uint256 _tokens = purchaseTokens(_dividends, 0x0);
216 
217         // fire event
218          onReinvestment(_customerAddress, _dividends, _tokens);
219     }
220 
221     /// @dev Alias of sell() and withdraw().
222     function exit() public {
223         // get token count for caller & sell them all
224         address _customerAddress = msg.sender;
225         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
226         if (_tokens > 0) sell(_tokens);
227 
228         // lambo delivery service
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
249          onWithdraw(_customerAddress, _dividends);
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
261         uint256 _neatFee = SafeMath.div(SafeMath.mul(_ethereum, 1), 100);
262         
263         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _neatFee);
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
278         neatFeeAddress.transfer(_neatFee);
279         // fire event
280          onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
281        
282     }
283 
284 
285     /**
286      * @dev Transfer tokens from the caller to a new holder.
287      *  Remember, there's a 7% fee here as well.
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
301         // liquify 5% of the tokens that are transfered
302         // these are dispersed to shareholders
303         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
304         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
305         uint256 _dividends = tokensToEthereum_(_tokenFee);
306 
307         // burn the fee tokens
308         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
309 
310         // exchange tokens
311         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
312         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
313 
314         // update dividend trackers
315         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
316         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
317 
318         // disperse dividends among holders
319         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
320 
321         // fire event
322          Transfer(_customerAddress, _toAddress, _taxedTokens);
323 
324         // ERC20
325         return true;
326     }
327 
328 
329     /*=====================================
330     =      HELPERS AND CALCULATORS        =
331     =====================================*/
332 
333     /**
334      * @dev Method to view the current Ethereum stored in the contract
335      *  Example: totalEthereumBalance()
336      */
337     function totalEthereumBalance() public view returns (uint256) {
338         return this.balance;
339     }
340 
341     /// @dev Retrieve the total token supply.
342     function totalSupply() public view returns (uint256) {
343         return tokenSupply_;
344     }
345 
346     /// @dev Retrieve the tokens owned by the caller.
347     function myTokens() public view returns (uint256) {
348         address _customerAddress = msg.sender;
349         return balanceOf(_customerAddress);
350     }
351 
352     /**
353      * @dev Retrieve the dividends owned by the caller.
354      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
355      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
356      *  But in the internal calculations, we want them separate.
357      */
358     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
359         address _customerAddress = msg.sender;
360         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
361     }
362 
363     /// @dev Retrieve the token balance of any single address.
364     function balanceOf(address _customerAddress) public view returns (uint256) {
365         return tokenBalanceLedger_[_customerAddress];
366     }
367 
368     /// @dev Retrieve the dividend balance of any single address.
369     function dividendsOf(address _customerAddress) public view returns (uint256) {
370         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
371     }
372 
373     /// @dev Return the sell price of 1 individual token.
374     function sellPrice() public view returns (uint256) {
375         // our calculation relies on the token supply, so we need supply. Doh.
376         if (tokenSupply_ == 0) {
377             return tokenPriceInitial_ - tokenPriceIncremental_;
378         } else {
379             uint256 _ethereum = tokensToEthereum_(1e18);
380             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
381             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
382 
383             return _taxedEthereum;
384         }
385     }
386 
387     /// @dev Return the buy price of 1 individual token.
388     function buyPrice() public view returns (uint256) {
389         // our calculation relies on the token supply, so we need supply. Doh.
390         if (tokenSupply_ == 0) {
391             return tokenPriceInitial_ + tokenPriceIncremental_;
392         } else {
393             uint256 _ethereum = tokensToEthereum_(1e18);
394             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
395             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
396 
397             return _taxedEthereum;
398         }
399     }
400 
401     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
402     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
403         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
404         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
405         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
406 
407         return _amountOfTokens;
408     }
409 
410     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
411     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
412         require(_tokensToSell <= tokenSupply_);
413         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
414         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
415         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
416         return _taxedEthereum;
417     }
418 
419 
420     /*==========================================
421     =            INTERNAL FUNCTIONS            =
422     ==========================================*/
423 
424     /// @dev Internal function to actually purchase the tokens.
425     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) antiEarlyWhale(_incomingEthereum)
426        internal returns (uint256) {
427         // data setup
428         address _customerAddress = msg.sender;
429         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
430         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
431         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
432         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
433         _taxedEthereum = SafeMath.sub(_taxedEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, 5), 200));
434         _taxedEthereum = SafeMath.sub(_taxedEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
435         _taxedEthereum = SafeMath.sub(_taxedEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
436         _taxedEthereum = SafeMath.sub(_taxedEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
437         _taxedEthereum = SafeMath.sub(_taxedEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, 3), 200));
438         
439         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
440         uint256 _fee = _dividends * magnitude;
441 
442         // no point in continuing execution if OP is a poorfag russian hacker
443         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
444         // (or hackers)
445         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
446         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
447 
448         // is the user referred by a masternode?
449         if (
450             // is this a referred purchase?
451             _referredBy != 0x0000000000000000000000000000000000000000 &&
452 
453             // no cheating!
454             _referredBy != _customerAddress &&
455 
456             // does the referrer have at least X whole tokens?
457             // i.e is the referrer a godly chad masternode
458             tokenBalanceLedger_[_referredBy] >= stakingRequirement
459         ) {
460             // wealth redistribution
461             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
462         } else {
463             // no ref purchase
464             // add the referral bonus back to the global dividends cake
465             _dividends = SafeMath.add(_dividends, _referralBonus);
466             _fee = _dividends * magnitude;
467         }
468 
469         // we can't give people infinite ethereum
470         if (tokenSupply_ > 0) {
471             // add tokens to the pool
472             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
473 
474             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
475             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
476 
477             // calculate the amount of tokens the customer receives over his purchase
478             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
479         } else {
480             // add tokens to the pool
481             tokenSupply_ = _amountOfTokens;
482         }
483 
484         // update circulating supply & the ledger address for the customer
485         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
486 
487         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
488         // really i know you think you do but you don't
489         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
490         payoutsTo_[_customerAddress] += _updatedPayouts;
491 
492         // fire event
493          onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
494         devFeeAddress.transfer(SafeMath.div(SafeMath.mul(_incomingEthereum, 5), 200));
495         employeeFeeAddress.transfer(SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
496         employeeFeeAddress1.transfer(SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
497         employeeFeeAddress2.transfer(SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
498         neatFeeAddress.transfer(SafeMath.div(SafeMath.mul(_incomingEthereum, 3), 200));
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