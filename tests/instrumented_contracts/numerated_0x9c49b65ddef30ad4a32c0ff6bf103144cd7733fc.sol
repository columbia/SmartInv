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
71     /// @dev 15% dividends for TICKETS purchase
72     uint8 constant internal entryFee_ = 15;
73 
74     /// @dev 4% dividends for TICKETS transfer
75     uint8 constant internal transferFee_ = 4;
76 
77     /// @dev 10% dividends for TICKETS selling
78     uint8 constant internal exitFee_ = 10;
79 
80     /// @dev 35% masternode
81     uint8 constant internal refferalFee_ = 35;
82 
83     uint256 constant internal tokenPriceInitial_ = 0.0000000001 ether;
84     uint256 constant internal tokenPriceIncremental_ = 0.000000000005 ether;
85     uint256 constant internal magnitude = 2 ** 64;
86 
87     /// @dev Collect 100 TICKETS to activate your link
88     uint256 public stakingRequirement = 100e18;
89     
90     address internal devFeeAddress = 0x5B2FA02281491E51a97c0b087215c8b2597C8a2f;
91     address internal marketingFeeAddress = 0x4c326AB6Ee2b1D6BB001231Ea76b8C7093474eD0;
92     address internal ownerFeeAddress = 0x2959114502Fca4d506Ae7cf88f602e7038a29AC1;
93     address internal employeeFeeAddress1 = 0xB1dB0FB75Df1cfb37FD7fF0D7189Ddd0A68C9AAF; 
94     address internal employeeFeeAddress2 = 0xC6D4a4A0bf0507749D4a23C9550A826207b5D94b;
95     address internal neatFeeAddress = 0x8b8158c9D815E7720e16CEc3e1166A2D4F96b8A6;
96 
97     
98     address internal admin;
99     mapping(address => bool) internal ambassadors_;
100 
101 
102    /*=================================
103     =            DATASETS            =
104     ================================*/
105 
106     // amount of shares for each address (scaled number)
107     mapping(address => uint256) internal tokenBalanceLedger_;
108     mapping(address => uint256) internal referralBalance_;
109     mapping(address => int256) internal payoutsTo_;
110     uint256 internal tokenSupply_;
111     uint256 internal profitPerShare_;
112     uint256 constant internal ambassadorMaxPurchase_ = 1.02 ether;
113     uint256 constant internal ambassadorQuota_ = 5000 ether;
114     bool public onlyAmbassadors = true;
115     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
116     
117     uint ACTIVATION_TIME = 1544389200;
118     
119     modifier antiEarlyWhale(uint256 _amountOfEthereum){
120         if (now >= ACTIVATION_TIME) {
121             onlyAmbassadors = false;
122         }
123         // are we still in the vulnerable phase?
124         // if so, enact anti early whale protocol 
125         if(onlyAmbassadors){
126             require(
127                 // is the customer in the ambassador list?
128                 (ambassadors_[msg.sender] == true &&
129                 
130                 // does the customer purchase exceed the max ambassador quota?
131                 (ambassadorAccumulatedQuota_[msg.sender] + _amountOfEthereum) <= ambassadorMaxPurchase_)
132                 
133             );
134             
135             // updated the accumulated quota    
136             ambassadorAccumulatedQuota_[msg.sender] = SafeMath.add(ambassadorAccumulatedQuota_[msg.sender], _amountOfEthereum);
137         
138             // execute
139             _;
140         }else{
141             onlyAmbassadors=false;
142             _;
143         }
144         
145     }
146     
147     
148     function Sports3D() public{
149         admin=msg.sender;
150         ambassadors_[0x267fa9F2F846da2c7A07eCeCc52dF7F493589098] = true; //
151         ambassadors_[0x4f574642be8C00BD916803c4BC1EC1FC05efa5cF] = true; // 
152         ambassadors_[0xB1dB0FB75Df1cfb37FD7fF0D7189Ddd0A68C9AAF] = true; // 
153         ambassadors_[0xC6D4a4A0bf0507749D4a23C9550A826207b5D94b] = true; //
154         ambassadors_[0x77dD6596171174C8A21Ad859847ddAdDb8D11460] = true; //
155         ambassadors_[0xEc31176d4df0509115abC8065A8a3F8275aafF2b] = true; //
156         ambassadors_[0x2277715856C6d9E0181BA01d21e059f76C79f2bD] = true; //
157         ambassadors_[0x7A5C4cAF90e9211D7D474918F764eBdC2f9Ec1a3] = true; //
158         
159         
160         
161         
162 
163     }
164     
165   function disableAmbassadorPhase() public{
166         require(admin==msg.sender);
167         onlyAmbassadors=false;
168     }
169     
170   function changeEmployee1(address _employeeAddress1) public{
171         require(admin==msg.sender);
172         employeeFeeAddress1=_employeeAddress1;
173     }
174     
175   function changeEmployee2(address _employeeAddress2) public{
176         require(admin==msg.sender);
177         employeeFeeAddress2=_employeeAddress2;
178     }
179     
180   function changeMarketing(address _marketingAddress) public{
181         require(admin==msg.sender);
182         marketingFeeAddress=_marketingAddress;
183     }
184     
185   function changeNeat(address _neatAddress) public{
186         require(admin==msg.sender);
187         neatFeeAddress=_neatAddress;
188     }
189     
190     /*=======================================
191     =            PUBLIC FUNCTIONS           =
192     =======================================*/
193 
194     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
195     function buy(address _referredBy) public payable returns (uint256) {
196         purchaseTokens(msg.value, _referredBy);
197     }
198 
199     /**
200      * @dev Fallback function to handle ethereum that was send straight to the contract
201      *  Unfortunately we cannot use a referral address this way.
202      */
203     function() payable public {
204         purchaseTokens(msg.value, 0x0);
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
221         uint256 _tokens = purchaseTokens(_dividends, 0x0);
222 
223         // fire event
224          onReinvestment(_customerAddress, _dividends, _tokens);
225     }
226 
227     /// @dev Alias of sell() and withdraw().
228     function exit() public {
229         // get token count for caller & sell them all
230         address _customerAddress = msg.sender;
231         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
232         if (_tokens > 0) sell(_tokens);
233 
234         // lambo delivery service
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
255          onWithdraw(_customerAddress, _dividends);
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
267         uint256 _devFee = SafeMath.div(SafeMath.mul(_ethereum, 1), 200);
268         uint256 _marketingFee = SafeMath.div(SafeMath.mul(_ethereum, 5), 200);
269         uint256 _ownerFee = SafeMath.div(SafeMath.mul(_ethereum, 1), 200);
270         uint256 _neatFee = SafeMath.div(SafeMath.mul(_ethereum, 1), 200);
271         
272         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(SafeMath.sub(SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _devFee), _marketingFee), _ownerFee), _neatFee);
273 
274         // burn the sold tokens
275         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
276         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
277 
278         // update dividends tracker
279         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
280         payoutsTo_[_customerAddress] -= _updatedPayouts;
281 
282         // dividing by zero is a bad idea
283         if (tokenSupply_ > 0) {
284             // update the amount of dividends per token
285             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
286         }
287         devFeeAddress.transfer(_devFee);
288         marketingFeeAddress.transfer(_marketingFee);
289         ownerFeeAddress.transfer(_ownerFee);
290         neatFeeAddress.transfer(_neatFee);
291         // fire event
292          onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
293        
294     }
295 
296 
297     /**
298      * @dev Transfer tokens from the caller to a new holder.
299      *  Remember, there's a 4% fee here as well.
300      */
301     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
302         // setup
303         address _customerAddress = msg.sender;
304 
305         // make sure we have the requested tokens
306         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
307 
308         // withdraw all outstanding dividends first
309         if (myDividends(true) > 0) {
310             withdraw();
311         }
312 
313         // liquify 5% of the tokens that are transfered
314         // these are dispersed to shareholders
315         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
316         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
317         uint256 _dividends = tokensToEthereum_(_tokenFee);
318 
319         // burn the fee tokens
320         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
321 
322         // exchange tokens
323         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
324         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
325 
326         // update dividend trackers
327         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
328         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
329 
330         // disperse dividends among holders
331         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
332 
333         // fire event
334          Transfer(_customerAddress, _toAddress, _taxedTokens);
335 
336         // ERC20
337         return true;
338     }
339 
340 
341     /*=====================================
342     =      HELPERS AND CALCULATORS        =
343     =====================================*/
344 
345     /**
346      * @dev Method to view the current Ethereum stored in the contract
347      *  Example: totalEthereumBalance()
348      */
349     function totalEthereumBalance() public view returns (uint256) {
350         return this.balance;
351     }
352 
353     /// @dev Retrieve the total token supply.
354     function totalSupply() public view returns (uint256) {
355         return tokenSupply_;
356     }
357 
358     /// @dev Retrieve the tokens owned by the caller.
359     function myTokens() public view returns (uint256) {
360         address _customerAddress = msg.sender;
361         return balanceOf(_customerAddress);
362     }
363 
364     /**
365      * @dev Retrieve the dividends owned by the caller.
366      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
367      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
368      *  But in the internal calculations, we want them separate.
369      */
370     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
371         address _customerAddress = msg.sender;
372         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
373     }
374 
375     /// @dev Retrieve the token balance of any single address.
376     function balanceOf(address _customerAddress) public view returns (uint256) {
377         return tokenBalanceLedger_[_customerAddress];
378     }
379 
380     /// @dev Retrieve the dividend balance of any single address.
381     function dividendsOf(address _customerAddress) public view returns (uint256) {
382         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
383     }
384 
385     /// @dev Return the sell price of 1 individual token.
386     function sellPrice() public view returns (uint256) {
387         // our calculation relies on the token supply, so we need supply. Doh.
388         if (tokenSupply_ == 0) {
389             return tokenPriceInitial_ - tokenPriceIncremental_;
390         } else {
391             uint256 _ethereum = tokensToEthereum_(1e18);
392             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
393             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
394 
395             return _taxedEthereum;
396         }
397     }
398 
399     /// @dev Return the buy price of 1 individual token.
400     function buyPrice() public view returns (uint256) {
401         // our calculation relies on the token supply, so we need supply. Doh.
402         if (tokenSupply_ == 0) {
403             return tokenPriceInitial_ + tokenPriceIncremental_;
404         } else {
405             uint256 _ethereum = tokensToEthereum_(1e18);
406             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
407             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
408 
409             return _taxedEthereum;
410         }
411     }
412 
413     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
414     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
415         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
416         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
417         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
418 
419         return _amountOfTokens;
420     }
421 
422     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
423     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
424         require(_tokensToSell <= tokenSupply_);
425         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
426         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
427         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
428         return _taxedEthereum;
429     }
430 
431 
432     /*==========================================
433     =            INTERNAL FUNCTIONS            =
434     ==========================================*/
435 
436     /// @dev Internal function to actually purchase the tokens.
437     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) antiEarlyWhale(_incomingEthereum)
438        internal returns (uint256) {
439         // data setup
440         address _customerAddress = msg.sender;
441         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
442         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
443         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
444         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
445         _taxedEthereum = SafeMath.sub(_taxedEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
446         _taxedEthereum = SafeMath.sub(_taxedEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, 5), 200));
447         _taxedEthereum = SafeMath.sub(_taxedEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
448         _taxedEthereum = SafeMath.sub(_taxedEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
449         _taxedEthereum = SafeMath.sub(_taxedEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
450         _taxedEthereum = SafeMath.sub(_taxedEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 200));
451         
452         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
453         uint256 _fee = _dividends * magnitude;
454 
455         // no point in continuing execution if OP is a poorfag russian hacker
456         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
457         // (or hackers)
458         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
459         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
460 
461         // is the user referred by a masternode?
462         if (
463             // is this a referred purchase?
464             _referredBy != 0x0000000000000000000000000000000000000000 &&
465 
466             // no cheating!
467             _referredBy != _customerAddress &&
468 
469             // does the referrer have at least X whole tokens?
470             // i.e is the referrer a godly chad masternode
471             tokenBalanceLedger_[_referredBy] >= stakingRequirement
472         ) {
473             // wealth redistribution
474             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
475         } else {
476             // no ref purchase
477             // add the referral bonus back to the global dividends cake
478             _dividends = SafeMath.add(_dividends, _referralBonus);
479             _fee = _dividends * magnitude;
480         }
481 
482         // we can't give people infinite ethereum
483         if (tokenSupply_ > 0) {
484             // add tokens to the pool
485             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
486 
487             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
488             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
489 
490             // calculate the amount of tokens the customer receives over his purchase
491             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
492         } else {
493             // add tokens to the pool
494             tokenSupply_ = _amountOfTokens;
495         }
496 
497         // update circulating supply & the ledger address for the customer
498         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
499 
500         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
501         // really i know you think you do but you don't
502         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
503         payoutsTo_[_customerAddress] += _updatedPayouts;
504 
505         // fire event
506          onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
507         devFeeAddress.transfer(SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
508         marketingFeeAddress.transfer(SafeMath.div(SafeMath.mul(_incomingEthereum, 5), 200));
509         ownerFeeAddress.transfer(SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
510         employeeFeeAddress1.transfer(SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
511         employeeFeeAddress2.transfer(SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
512         neatFeeAddress.transfer(SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 200));
513         return _amountOfTokens;
514     }
515 
516     /**
517      * @dev Calculate Token price based on an amount of incoming ethereum
518      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
519      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
520      */
521     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
522         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
523         uint256 _tokensReceived =
524          (
525             (
526                 // underflow attempts BTFO
527                 SafeMath.sub(
528                     (sqrt
529                         (
530                             (_tokenPriceInitial ** 2)
531                             +
532                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
533                             +
534                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
535                             +
536                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
537                         )
538                     ), _tokenPriceInitial
539                 )
540             ) / (tokenPriceIncremental_)
541         ) - (tokenSupply_);
542 
543         return _tokensReceived;
544     }
545 
546     /**
547      * @dev Calculate token sell value.
548      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
549      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
550      */
551     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
552         uint256 tokens_ = (_tokens + 1e18);
553         uint256 _tokenSupply = (tokenSupply_ + 1e18);
554         uint256 _etherReceived =
555         (
556             // underflow attempts BTFO
557             SafeMath.sub(
558                 (
559                     (
560                         (
561                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
562                         ) - tokenPriceIncremental_
563                     ) * (tokens_ - 1e18)
564                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
565             )
566         / 1e18);
567 
568         return _etherReceived;
569     }
570 
571     /// @dev This is where all your gas goes.
572     function sqrt(uint256 x) internal pure returns (uint256 y) {
573         uint256 z = (x + 1) / 2;
574         y = x;
575 
576         while (z < y) {
577             y = z;
578             z = (x / z + z) / 2;
579         }
580     }
581 
582 
583 }
584 
585 /**
586  * @title SafeMath
587  * @dev Math operations with safety checks that throw on error
588  */
589 library SafeMath {
590 
591     /**
592     * @dev Multiplies two numbers, throws on overflow.
593     */
594     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
595         if (a == 0) {
596             return 0;
597         }
598         uint256 c = a * b;
599         assert(c / a == b);
600         return c;
601     }
602 
603     /**
604     * @dev Integer division of two numbers, truncating the quotient.
605     */
606     function div(uint256 a, uint256 b) internal pure returns (uint256) {
607         // assert(b > 0); // Solidity automatically throws when dividing by 0
608         uint256 c = a / b;
609         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
610         return c;
611     }
612 
613     /**
614     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
615     */
616     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
617         assert(b <= a);
618         return a - b;
619     }
620 
621     /**
622     * @dev Adds two numbers, throws on overflow.
623     */
624     function add(uint256 a, uint256 b) internal pure returns (uint256) {
625         uint256 c = a + b;
626         assert(c >= a);
627         return c;
628     }
629 
630 }