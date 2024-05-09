1 pragma solidity ^0.4.25;
2 
3 contract NeverEndingToken {
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
67     string public name = "Never Ending Token";
68     string public symbol = "NET"; // (Never Ending Token)
69     uint8 constant public decimals = 18;
70 
71     /// @dev 15% dividends for token purchase
72     uint8 constant internal entryFee_ = 15;
73 
74     /// @dev 4% dividends for token transfer
75     uint8 constant internal transferFee_ = 4;
76 
77     /// @dev 5% dividends for token selling
78     uint8 constant internal exitFee_ = 5;
79 
80     /// @dev 35% masternode
81     uint8 constant internal refferalFee_ = 35;
82 
83     uint256 constant internal tokenPriceInitial_ = 0.000000000001 ether;
84     uint256 constant internal tokenPriceIncremental_ = 0.0000000000009 ether;
85     uint256 constant internal magnitude = 2 ** 64;
86 
87     /// @dev 100 Never Ending App Tokens needed for masternode activation
88     uint256 public stakingRequirement = 100e18;
89     
90     // 8% Total extra fee to keep the FOMO going
91     
92     // Dev (3%)
93     address internal devFeeAddress = 0xBf7da5d6236ad9A375E5121466bc6b0925E6CbB7;
94     // Yes we need to pay for marketing (1% buy)
95     address internal marketingFeeAddress = 0xBf7da5d6236ad9A375E5121466bc6b0925E6CbB7;
96     // To make it rain dividends once in a while (1% sell)
97     address internal feedingFeeAddress = 0x5aFa2A530B83E239261Aa46C6c29c9dF371FAA62;
98     // Website and community runners (1% buy)
99     address internal employeeFeeAddress1 = 0xa4940d54f21cb7d28ddfcd6c058a428704c08360; 
100     // Admin/Moderator
101     address internal employeeFeeAddress2 = 0xBf7da5d6236ad9A375E5121466bc6b0925E6CbB7;
102     // Admin/Moderator
103     address internal employeeFeeAddress3 = 0x5aFa2A530B83E239261Aa46C6c29c9dF371FAA62;
104     
105     address internal admin;
106     mapping(address => bool) internal ambassadors_;
107 
108 
109    /*=================================
110     =            DATASETS            =
111     ================================*/
112 
113     // amount of shares for each address (scaled number)
114     mapping(address => uint256) internal tokenBalanceLedger_;
115     mapping(address => uint256) internal referralBalance_;
116     mapping(address => int256) internal payoutsTo_;
117     uint256 internal tokenSupply_;
118     uint256 internal profitPerShare_;
119     uint256 constant internal ambassadorMaxPurchase_ = 0.55 ether;
120     uint256 constant internal ambassadorQuota_ = 500 ether;
121     bool public onlyAmbassadors = true;
122     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
123     
124     uint ACTIVATION_TIME = 1542378600;
125     
126     modifier antiEarlyWhale(uint256 _amountOfEthereum){
127         if (now >= ACTIVATION_TIME) {
128             onlyAmbassadors = false;
129         }
130         // are we still in the vulnerable phase?
131         // if so, enact anti early whale protocol 
132         if(onlyAmbassadors){
133             require(
134                 // is the customer in the ambassador list?
135                 (ambassadors_[msg.sender] == true &&
136                 
137                 // does the customer purchase exceed the max ambassador quota?
138                 (ambassadorAccumulatedQuota_[msg.sender] + _amountOfEthereum) <= ambassadorMaxPurchase_)
139                 
140             );
141             
142             // updated the accumulated quota    
143             ambassadorAccumulatedQuota_[msg.sender] = SafeMath.add(ambassadorAccumulatedQuota_[msg.sender], _amountOfEthereum);
144         
145             // execute
146             _;
147         }else{
148             onlyAmbassadors=false;
149             _;
150         }
151         
152     }
153     
154     
155     function NeverEndingApp() public{
156         admin=msg.sender;
157                 
158         ambassadors_[0x77c192342F25a364FB17C25cdDddb194a8d34991] = true; // 
159         ambassadors_[0xE206201116978a48080C4b65cFA4ae9f03DA3F0D] = true; // 
160         ambassadors_[0x21adD73393635b26710C7689519a98b09ecdc474] = true; // 
161         ambassadors_[0xEc31176d4df0509115abC8065A8a3F8275aafF2b] = true; // 
162         ambassadors_[0xc7F15d0238d207e19cce6bd6C0B85f343896F046] = true; //
163         ambassadors_[0xBa21d01125D6932ce8ABf3625977899Fd2C7fa30] = true; //
164         ambassadors_[0x2277715856C6d9E0181BA01d21e059f76C79f2bD] = true; //
165         ambassadors_[0xB1dB0FB75Df1cfb37FD7fF0D7189Ddd0A68C9AAF] = true; //
166         ambassadors_[0xEafE863757a2b2a2c5C3f71988b7D59329d09A78] = true; //
167         ambassadors_[0xBf7da5d6236ad9A375E5121466bc6b0925E6CbB7] = true; // 
168         ambassadors_[0xB19772e5E8229aC499C67E820Db53BF52dbaf0dE] = true; //        
169         ambassadors_[0x42830382f378d083A8Ae55Eb729A9d789fA4dEA6] = true; //
170         ambassadors_[0x87f7a5708e384407B4ED494bE1ff22aE68aB11F9] = true; //
171         ambassadors_[0x53e1eB6a53d9354d43155f76861C5a2AC80ef361] = true; //  
172         ambassadors_[0x267fa9F2F846da2c7A07eCeCc52dF7F493589098] = true; // 
173         
174         
175 
176     }
177     
178   function disableAmbassadorPhase() public{
179         require(admin==msg.sender);
180         onlyAmbassadors=false;
181     }
182     
183   function changeEmployee1(address _employeeAddress1) public{
184         require(admin==msg.sender);
185         employeeFeeAddress1=_employeeAddress1;
186     }
187     
188   function changeEmployee2(address _employeeAddress2) public{
189         require(admin==msg.sender);
190         employeeFeeAddress2=_employeeAddress2;
191     }
192     
193   function changeEmployee3(address _employeeAddress3) public{
194         require(admin==msg.sender);
195         employeeFeeAddress3=_employeeAddress3;
196     }
197     
198   function changeMarketing(address _marketingAddress) public{
199         require(admin==msg.sender);
200         marketingFeeAddress=_marketingAddress;
201     }
202     
203     /*=======================================
204     =            PUBLIC FUNCTIONS           =
205     =======================================*/
206 
207     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
208     function buy(address _referredBy) public payable returns (uint256) {
209         purchaseTokens(msg.value, _referredBy);
210     }
211 
212     /**
213      * @dev Fallback function to handle ethereum that was send straight to the contract
214      *  Unfortunately we cannot use a referral address this way.
215      */
216     function() payable public {
217         purchaseTokens(msg.value, 0x0);
218     }
219 
220     /// @dev Converts all of caller's dividends to tokens.
221     function reinvest() onlyStronghands public {
222         // fetch dividends
223         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
224 
225         // pay out the dividends virtually
226         address _customerAddress = msg.sender;
227         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
228 
229         // retrieve ref. bonus
230         _dividends += referralBalance_[_customerAddress];
231         referralBalance_[_customerAddress] = 0;
232 
233         // dispatch a buy order with the virtualized "withdrawn dividends"
234         uint256 _tokens = purchaseTokens(_dividends, 0x0);
235 
236         // fire event
237          onReinvestment(_customerAddress, _dividends, _tokens);
238     }
239 
240     /// @dev Alias of sell() and withdraw().
241     function exit() public {
242         // get token count for caller & sell them all
243         address _customerAddress = msg.sender;
244         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
245         if (_tokens > 0) sell(_tokens);
246 
247         // lambo delivery service
248         withdraw();
249     }
250 
251     /// @dev Withdraws all of the callers earnings.
252     function withdraw() onlyStronghands public {
253         // setup data
254         address _customerAddress = msg.sender;
255         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
256 
257         // update dividend tracker
258         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
259 
260         // add ref. bonus
261         _dividends += referralBalance_[_customerAddress];
262         referralBalance_[_customerAddress] = 0;
263 
264         // lambo delivery service
265         _customerAddress.transfer(_dividends);
266 
267         // fire event
268          onWithdraw(_customerAddress, _dividends);
269     }
270 
271     /// @dev Liquifies tokens to ethereum.
272     function sell(uint256 _amountOfTokens) onlyBagholders public {
273         // setup data
274         address _customerAddress = msg.sender;
275         // russian hackers BTFO
276         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
277         uint256 _tokens = _amountOfTokens;
278         uint256 _ethereum = tokensToEthereum_(_tokens);
279         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
280         uint256 _devFee = SafeMath.div(SafeMath.mul(_ethereum, 1), 100);
281         uint256 _marketingFee = SafeMath.div(SafeMath.mul(_ethereum, 1), 100);
282         uint256 _feedingFee = SafeMath.div(SafeMath.mul(_ethereum, 1), 100);
283         
284         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _devFee), _marketingFee), _feedingFee);
285 
286         // burn the sold tokens
287         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
288         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
289 
290         // update dividends tracker
291         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
292         payoutsTo_[_customerAddress] -= _updatedPayouts;
293 
294         // dividing by zero is a bad idea
295         if (tokenSupply_ > 0) {
296             // update the amount of dividends per token
297             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
298         }
299         devFeeAddress.transfer(_devFee);
300         marketingFeeAddress.transfer(_marketingFee);
301         feedingFeeAddress.transfer(_feedingFee);
302         // fire event
303          onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
304        
305     }
306 
307 
308     /**
309      * @dev Transfer tokens from the caller to a new holder.
310      *  Remember, there's a 5% fee here as well.
311      */
312     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
313         // setup
314         address _customerAddress = msg.sender;
315 
316         // make sure we have the requested tokens
317         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
318 
319         // withdraw all outstanding dividends first
320         if (myDividends(true) > 0) {
321             withdraw();
322         }
323 
324         // liquify 5% of the tokens that are transfered
325         // these are dispersed to shareholders
326         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
327         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
328         uint256 _dividends = tokensToEthereum_(_tokenFee);
329 
330         // burn the fee tokens
331         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
332 
333         // exchange tokens
334         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
335         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
336 
337         // update dividend trackers
338         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
339         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
340 
341         // disperse dividends among holders
342         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
343 
344         // fire event
345          Transfer(_customerAddress, _toAddress, _taxedTokens);
346 
347         // ERC20
348         return true;
349     }
350 
351 
352     /*=====================================
353     =      HELPERS AND CALCULATORS        =
354     =====================================*/
355 
356     /**
357      * @dev Method to view the current Ethereum stored in the contract
358      *  Example: totalEthereumBalance()
359      */
360     function totalEthereumBalance() public view returns (uint256) {
361         return this.balance;
362     }
363 
364     /// @dev Retrieve the total token supply.
365     function totalSupply() public view returns (uint256) {
366         return tokenSupply_;
367     }
368 
369     /// @dev Retrieve the tokens owned by the caller.
370     function myTokens() public view returns (uint256) {
371         address _customerAddress = msg.sender;
372         return balanceOf(_customerAddress);
373     }
374 
375     /**
376      * @dev Retrieve the dividends owned by the caller.
377      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
378      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
379      *  But in the internal calculations, we want them separate.
380      */
381     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
382         address _customerAddress = msg.sender;
383         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
384     }
385 
386     /// @dev Retrieve the token balance of any single address.
387     function balanceOf(address _customerAddress) public view returns (uint256) {
388         return tokenBalanceLedger_[_customerAddress];
389     }
390 
391     /// @dev Retrieve the dividend balance of any single address.
392     function dividendsOf(address _customerAddress) public view returns (uint256) {
393         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
394     }
395 
396     /// @dev Return the sell price of 1 individual token.
397     function sellPrice() public view returns (uint256) {
398         // our calculation relies on the token supply, so we need supply. Doh.
399         if (tokenSupply_ == 0) {
400             return tokenPriceInitial_ - tokenPriceIncremental_;
401         } else {
402             uint256 _ethereum = tokensToEthereum_(1e18);
403             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
404             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
405 
406             return _taxedEthereum;
407         }
408     }
409 
410     /// @dev Return the buy price of 1 individual token.
411     function buyPrice() public view returns (uint256) {
412         // our calculation relies on the token supply, so we need supply. Doh.
413         if (tokenSupply_ == 0) {
414             return tokenPriceInitial_ + tokenPriceIncremental_;
415         } else {
416             uint256 _ethereum = tokensToEthereum_(1e18);
417             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
418             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
419 
420             return _taxedEthereum;
421         }
422     }
423 
424     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
425     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
426         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
427         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
428         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
429 
430         return _amountOfTokens;
431     }
432 
433     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
434     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
435         require(_tokensToSell <= tokenSupply_);
436         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
437         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
438         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
439         return _taxedEthereum;
440     }
441 
442 
443     /*==========================================
444     =            INTERNAL FUNCTIONS            =
445     ==========================================*/
446 
447     /// @dev Internal function to actually purchase the tokens.
448     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) antiEarlyWhale(_incomingEthereum)
449        internal returns (uint256) {
450         // data setup
451         address _customerAddress = msg.sender;
452         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
453         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
454         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
455         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
456         _taxedEthereum = SafeMath.sub(_taxedEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, 3), 100));
457         _taxedEthereum = SafeMath.sub(_taxedEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
458         _taxedEthereum = SafeMath.sub(_taxedEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
459         _taxedEthereum = SafeMath.sub(_taxedEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
460         _taxedEthereum = SafeMath.sub(_taxedEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
461         _taxedEthereum = SafeMath.sub(_taxedEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
462         
463         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
464         uint256 _fee = _dividends * magnitude;
465 
466         // no point in continuing execution if OP is a poorfag russian hacker
467         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
468         // (or hackers)
469         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
470         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
471 
472         // is the user referred by a masternode?
473         if (
474             // is this a referred purchase?
475             _referredBy != 0x0000000000000000000000000000000000000000 &&
476 
477             // no cheating!
478             _referredBy != _customerAddress &&
479 
480             // does the referrer have at least X whole tokens?
481             // i.e is the referrer a godly chad masternode
482             tokenBalanceLedger_[_referredBy] >= stakingRequirement
483         ) {
484             // wealth redistribution
485             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
486         } else {
487             // no ref purchase
488             // add the referral bonus back to the global dividends cake
489             _dividends = SafeMath.add(_dividends, _referralBonus);
490             _fee = _dividends * magnitude;
491         }
492 
493         // we can't give people infinite ethereum
494         if (tokenSupply_ > 0) {
495             // add tokens to the pool
496             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
497 
498             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
499             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
500 
501             // calculate the amount of tokens the customer receives over his purchase
502             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
503         } else {
504             // add tokens to the pool
505             tokenSupply_ = _amountOfTokens;
506         }
507 
508         // update circulating supply & the ledger address for the customer
509         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
510 
511         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
512         // really i know you think you do but you don't
513         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
514         payoutsTo_[_customerAddress] += _updatedPayouts;
515 
516         // fire event
517          onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
518         devFeeAddress.transfer(SafeMath.div(SafeMath.mul(_incomingEthereum, 3), 100));
519         marketingFeeAddress.transfer(SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
520         feedingFeeAddress.transfer(SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
521         employeeFeeAddress1.transfer(SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
522         employeeFeeAddress2.transfer(SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
523         employeeFeeAddress3.transfer(SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
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