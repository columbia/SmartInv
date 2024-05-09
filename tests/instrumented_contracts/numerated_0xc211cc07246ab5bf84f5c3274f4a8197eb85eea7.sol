1 pragma solidity ^0.4.20;
2 
3 contract Sports3D {
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
67     string public name = "Sports3D";
68     string public symbol = "TICKETS";
69     uint8 constant public decimals = 18;
70 
71     /// @dev 25% dividends for TICKETS purchase
72     uint8 constant internal entryFee_ = 25;
73 
74     /// @dev 10% dividends for TICKETS transfer
75     uint8 constant internal transferFee_ = 10;
76 
77     /// @dev 15% dividends for TICKETS selling
78     uint8 constant internal exitFee_ = 15;
79 
80     /// @dev 35% masternode
81     uint8 constant internal refferalFee_ = 35;
82 
83     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
84     uint256 constant internal tokenPriceIncremental_ = 0.000000006 ether;
85     uint256 constant internal magnitude = 2 ** 64;
86 
87     /// @dev Collect 100 TICKETS to activate your link
88     uint256 public stakingRequirement = 100e18;
89     
90     address internal devFeeAddress = 0x4c326AB6Ee2b1D6BB001231Ea76b8C7093474eD0;
91 
92     
93     address internal admin;
94     mapping(address => bool) internal ambassadors_;
95 
96 
97    /*=================================
98     =            DATASETS            =
99     ================================*/
100 
101     // amount of shares for each address (scaled number)
102     mapping(address => uint256) internal tokenBalanceLedger_;
103     mapping(address => uint256) internal referralBalance_;
104     mapping(address => int256) internal payoutsTo_;
105     uint256 internal tokenSupply_;
106     uint256 internal profitPerShare_;
107     uint256 constant internal ambassadorMaxPurchase_ = 1.1 ether;
108     uint256 constant internal ambassadorQuota_ = 5000 ether;
109     bool public onlyAmbassadors = true;
110     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
111     
112     uint ACTIVATION_TIME = 1548010801;
113     
114     modifier antiEarlyWhale(uint256 _amountOfEthereum){
115         if (now >= ACTIVATION_TIME) {
116             onlyAmbassadors = false;
117         }
118         // are we still in the vulnerable phase?
119         // if so, enact anti early whale protocol 
120         if(onlyAmbassadors){
121             require(
122                 // is the customer in the ambassador list?
123                 (ambassadors_[msg.sender] == true &&
124                 
125                 // does the customer purchase exceed the max ambassador quota?
126                 (ambassadorAccumulatedQuota_[msg.sender] + _amountOfEthereum) <= ambassadorMaxPurchase_)
127                 
128             );
129             
130             // updated the accumulated quota    
131             ambassadorAccumulatedQuota_[msg.sender] = SafeMath.add(ambassadorAccumulatedQuota_[msg.sender], _amountOfEthereum);
132         
133             // execute
134             _;
135         }else{
136             onlyAmbassadors=false;
137             _;
138         }
139         
140     }
141     
142     
143     function Sports3D() public{
144         admin=msg.sender;
145         ambassadors_[0xd558E92330bF2473371D5cd8D04555FEfd6eDa31] = true; //
146         ambassadors_[0x267fa9F2F846da2c7A07eCeCc52dF7F493589098] = true; // 
147         ambassadors_[0x4f574642be8C00BD916803c4BC1EC1FC05efa5cF] = true; // 
148         ambassadors_[0xB1dB0FB75Df1cfb37FD7fF0D7189Ddd0A68C9AAF] = true; //
149         ambassadors_[0x7A5C4cAF90e9211D7D474918F764eBdC2f9Ec1a3] = true; //
150         ambassadors_[0x77dD6596171174C8A21Ad859847ddAdDb8D11460] = true; //
151         ambassadors_[0xa19D77de5eC68f9c3D8Ece09448130D9e92332ad] = true; //
152         ambassadors_[0x17c1cF2eeFda3f339996c67cd18d4389D132D033] = true; //
153         ambassadors_[0xEc31176d4df0509115abC8065A8a3F8275aafF2b] = true; //
154         ambassadors_[0x2C605D4430Cc955BEdD4CB9d5B2F5fB9Cf143d2E] = true; //
155         
156         
157         
158         
159 
160     }
161     
162   function disableAmbassadorPhase() public{
163         require(admin==msg.sender);
164         onlyAmbassadors=false;
165     }
166     
167     
168     /*=======================================
169     =            PUBLIC FUNCTIONS           =
170     =======================================*/
171 
172     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
173     function buy(address _referredBy) public payable returns (uint256) {
174         purchaseTokens(msg.value, _referredBy);
175     }
176 
177     /**
178      * @dev Fallback function to handle ethereum that was send straight to the contract
179      *  Unfortunately we cannot use a referral address this way.
180      */
181     function() payable public {
182         purchaseTokens(msg.value, 0x0);
183     }
184 
185     /// @dev Converts all of caller's dividends to tokens.
186     function reinvest() onlyStronghands public {
187         // fetch dividends
188         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
189 
190         // pay out the dividends virtually
191         address _customerAddress = msg.sender;
192         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
193 
194         // retrieve ref. bonus
195         _dividends += referralBalance_[_customerAddress];
196         referralBalance_[_customerAddress] = 0;
197 
198         // dispatch a buy order with the virtualized "withdrawn dividends"
199         uint256 _tokens = purchaseTokens(_dividends, 0x0);
200 
201         // fire event
202          onReinvestment(_customerAddress, _dividends, _tokens);
203     }
204 
205     /// @dev Alias of sell() and withdraw().
206     function exit() public {
207         // get token count for caller & sell them all
208         address _customerAddress = msg.sender;
209         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
210         if (_tokens > 0) sell(_tokens);
211 
212         // lambo delivery service
213         withdraw();
214     }
215 
216     /// @dev Withdraws all of the callers earnings.
217     function withdraw() onlyStronghands public {
218         // setup data
219         address _customerAddress = msg.sender;
220         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
221 
222         // update dividend tracker
223         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
224 
225         // add ref. bonus
226         _dividends += referralBalance_[_customerAddress];
227         referralBalance_[_customerAddress] = 0;
228 
229         // lambo delivery service
230         _customerAddress.transfer(_dividends);
231 
232         // fire event
233          onWithdraw(_customerAddress, _dividends);
234     }
235 
236     /// @dev Liquifies tokens to ethereum.
237     function sell(uint256 _amountOfTokens) onlyBagholders public {
238         // setup data
239         address _customerAddress = msg.sender;
240         // russian hackers BTFO
241         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
242         uint256 _tokens = _amountOfTokens;
243         uint256 _ethereum = tokensToEthereum_(_tokens);
244         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
245         
246         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
247 
248         // burn the sold tokens
249         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
250         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
251 
252         // update dividends tracker
253         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
254         payoutsTo_[_customerAddress] -= _updatedPayouts;
255 
256         // dividing by zero is a bad idea
257         if (tokenSupply_ > 0) {
258             // update the amount of dividends per token
259             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
260         }
261         // fire event
262          onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
263        
264     }
265 
266 
267     /**
268      * @dev Transfer tokens from the caller to a new holder.
269      *  Remember, there's a 4% fee here as well.
270      */
271     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
272         // setup
273         address _customerAddress = msg.sender;
274 
275         // make sure we have the requested tokens
276         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
277 
278         // withdraw all outstanding dividends first
279         if (myDividends(true) > 0) {
280             withdraw();
281         }
282 
283         // liquify 5% of the tokens that are transfered
284         // these are dispersed to shareholders
285         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
286         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
287         uint256 _dividends = tokensToEthereum_(_tokenFee);
288 
289         // burn the fee tokens
290         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
291 
292         // exchange tokens
293         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
294         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
295 
296         // update dividend trackers
297         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
298         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
299 
300         // disperse dividends among holders
301         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
302 
303         // fire event
304          Transfer(_customerAddress, _toAddress, _taxedTokens);
305 
306         // ERC20
307         return true;
308     }
309 
310 
311     /*=====================================
312     =      HELPERS AND CALCULATORS        =
313     =====================================*/
314 
315     /**
316      * @dev Method to view the current Ethereum stored in the contract
317      *  Example: totalEthereumBalance()
318      */
319     function totalEthereumBalance() public view returns (uint256) {
320         return this.balance;
321     }
322 
323     /// @dev Retrieve the total token supply.
324     function totalSupply() public view returns (uint256) {
325         return tokenSupply_;
326     }
327 
328     /// @dev Retrieve the tokens owned by the caller.
329     function myTokens() public view returns (uint256) {
330         address _customerAddress = msg.sender;
331         return balanceOf(_customerAddress);
332     }
333 
334     /**
335      * @dev Retrieve the dividends owned by the caller.
336      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
337      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
338      *  But in the internal calculations, we want them separate.
339      */
340     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
341         address _customerAddress = msg.sender;
342         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
343     }
344 
345     /// @dev Retrieve the token balance of any single address.
346     function balanceOf(address _customerAddress) public view returns (uint256) {
347         return tokenBalanceLedger_[_customerAddress];
348     }
349 
350     /// @dev Retrieve the dividend balance of any single address.
351     function dividendsOf(address _customerAddress) public view returns (uint256) {
352         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
353     }
354 
355     /// @dev Return the sell price of 1 individual token.
356     function sellPrice() public view returns (uint256) {
357         // our calculation relies on the token supply, so we need supply. Doh.
358         if (tokenSupply_ == 0) {
359             return tokenPriceInitial_ - tokenPriceIncremental_;
360         } else {
361             uint256 _ethereum = tokensToEthereum_(1e18);
362             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
363             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
364 
365             return _taxedEthereum;
366         }
367     }
368 
369     /// @dev Return the buy price of 1 individual token.
370     function buyPrice() public view returns (uint256) {
371         // our calculation relies on the token supply, so we need supply. Doh.
372         if (tokenSupply_ == 0) {
373             return tokenPriceInitial_ + tokenPriceIncremental_;
374         } else {
375             uint256 _ethereum = tokensToEthereum_(1e18);
376             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
377             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
378 
379             return _taxedEthereum;
380         }
381     }
382 
383     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
384     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
385         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
386         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
387         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
388 
389         return _amountOfTokens;
390     }
391 
392     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
393     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
394         require(_tokensToSell <= tokenSupply_);
395         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
396         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
397         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
398         return _taxedEthereum;
399     }
400 
401 
402     /*==========================================
403     =            INTERNAL FUNCTIONS            =
404     ==========================================*/
405 
406     /// @dev Internal function to actually purchase the tokens.
407     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) antiEarlyWhale(_incomingEthereum)
408        internal returns (uint256) {
409         // data setup
410         address _customerAddress = msg.sender;
411         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
412         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
413         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
414         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
415         _taxedEthereum = SafeMath.sub(_taxedEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, 10), 100));
416         
417         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
418         uint256 _fee = _dividends * magnitude;
419 
420         // no point in continuing execution if OP is a poorfag russian hacker
421         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
422         // (or hackers)
423         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
424         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
425 
426         // is the user referred by a masternode?
427         if (
428             // is this a referred purchase?
429             _referredBy != 0x0000000000000000000000000000000000000000 &&
430 
431             // no cheating!
432             _referredBy != _customerAddress &&
433 
434             // does the referrer have at least X whole tokens?
435             // i.e is the referrer a godly chad masternode
436             tokenBalanceLedger_[_referredBy] >= stakingRequirement
437         ) {
438             // wealth redistribution
439             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
440         } else {
441             // no ref purchase
442             // add the referral bonus back to the global dividends cake
443             _dividends = SafeMath.add(_dividends, _referralBonus);
444             _fee = _dividends * magnitude;
445         }
446 
447         // we can't give people infinite ethereum
448         if (tokenSupply_ > 0) {
449             // add tokens to the pool
450             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
451 
452             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
453             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
454 
455             // calculate the amount of tokens the customer receives over his purchase
456             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
457         } else {
458             // add tokens to the pool
459             tokenSupply_ = _amountOfTokens;
460         }
461 
462         // update circulating supply & the ledger address for the customer
463         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
464 
465         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
466         // really i know you think you do but you don't
467         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
468         payoutsTo_[_customerAddress] += _updatedPayouts;
469 
470         // fire event
471          onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
472         devFeeAddress.transfer(SafeMath.div(SafeMath.mul(_incomingEthereum, 10), 100));
473         return _amountOfTokens;
474     }
475 
476     /**
477      * @dev Calculate Token price based on an amount of incoming ethereum
478      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
479      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
480      */
481     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
482         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
483         uint256 _tokensReceived =
484          (
485             (
486                 // underflow attempts BTFO
487                 SafeMath.sub(
488                     (sqrt
489                         (
490                             (_tokenPriceInitial ** 2)
491                             +
492                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
493                             +
494                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
495                             +
496                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
497                         )
498                     ), _tokenPriceInitial
499                 )
500             ) / (tokenPriceIncremental_)
501         ) - (tokenSupply_);
502 
503         return _tokensReceived;
504     }
505 
506     /**
507      * @dev Calculate token sell value.
508      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
509      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
510      */
511     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
512         uint256 tokens_ = (_tokens + 1e18);
513         uint256 _tokenSupply = (tokenSupply_ + 1e18);
514         uint256 _etherReceived =
515         (
516             // underflow attempts BTFO
517             SafeMath.sub(
518                 (
519                     (
520                         (
521                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
522                         ) - tokenPriceIncremental_
523                     ) * (tokens_ - 1e18)
524                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
525             )
526         / 1e18);
527 
528         return _etherReceived;
529     }
530 
531     /// @dev This is where all your gas goes.
532     function sqrt(uint256 x) internal pure returns (uint256 y) {
533         uint256 z = (x + 1) / 2;
534         y = x;
535 
536         while (z < y) {
537             y = z;
538             z = (x / z + z) / 2;
539         }
540     }
541 
542 
543 }
544 
545 /**
546  * @title SafeMath
547  * @dev Math operations with safety checks that throw on error
548  */
549 library SafeMath {
550 
551     /**
552     * @dev Multiplies two numbers, throws on overflow.
553     */
554     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
555         if (a == 0) {
556             return 0;
557         }
558         uint256 c = a * b;
559         assert(c / a == b);
560         return c;
561     }
562 
563     /**
564     * @dev Integer division of two numbers, truncating the quotient.
565     */
566     function div(uint256 a, uint256 b) internal pure returns (uint256) {
567         // assert(b > 0); // Solidity automatically throws when dividing by 0
568         uint256 c = a / b;
569         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
570         return c;
571     }
572 
573     /**
574     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
575     */
576     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
577         assert(b <= a);
578         return a - b;
579     }
580 
581     /**
582     * @dev Adds two numbers, throws on overflow.
583     */
584     function add(uint256 a, uint256 b) internal pure returns (uint256) {
585         uint256 c = a + b;
586         assert(c >= a);
587         return c;
588     }
589 
590 }