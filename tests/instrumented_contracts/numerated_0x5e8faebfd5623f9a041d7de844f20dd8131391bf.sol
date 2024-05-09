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
68     string public symbol = "NEAT"; // (Never Ending App Token)
69     uint8 constant public decimals = 18;
70 
71     /// @dev 12% dividends for token purchase
72     uint8 constant internal entryFee_ = 12;
73 
74     /// @dev 4% dividends for token transfer
75     uint8 constant internal transferFee_ = 4;
76 
77     /// @dev 12% dividends for token selling
78     uint8 constant internal exitFee_ = 12;
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
90     // 7.5% Total extra fee to keep the FOMO going
91     
92     // Dev (2.5%)
93     address internal devFeeAddress = 0x5B2FA02281491E51a97c0b087215c8b2597C8a2f;
94     // Yes we need to pay for marketing (1% buy)
95     address internal marketingFeeAddress = 0xf42934E5C290AA1586d9945Ca8F20cFb72307f91;
96     // To make it rain dividends once in a while (1% sell)
97     address internal feedingFeeAddress = 0x8b8158c9D815E7720e16CEc3e1166A2D4F96b8A6;
98     // Website and community runners (1% buy)
99     address internal employeeFeeAddress1 = 0x2959114502Fca4d506Ae7cf88f602e7038a29AC1; 
100     // Admin/Moderator
101     address internal employeeFeeAddress2 = 0x5B2FA02281491E51a97c0b087215c8b2597C8a2f;
102     // Admin/Moderator
103     address internal employeeFeeAddress3 = 0x5B2FA02281491E51a97c0b087215c8b2597C8a2f;
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
120     uint256 constant internal ambassadorQuota_ = 5000 ether;
121     bool public onlyAmbassadors = true;
122     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
123     
124     uint ACTIVATION_TIME = 1543172400;
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
158         ambassadors_[0x4f574642be8C00BD916803c4BC1EC1FC05efa5cF] = true; // 
159         ambassadors_[0x77c192342F25a364FB17C25cdDddb194a8d34991] = true; // 
160         ambassadors_[0xE206201116978a48080C4b65cFA4ae9f03DA3F0D] = true; // 
161         ambassadors_[0x21adD73393635b26710C7689519a98b09ecdc474] = true; // 
162         ambassadors_[0xEc31176d4df0509115abC8065A8a3F8275aafF2b] = true; // 
163         ambassadors_[0x77a21F9E0325950f679d28ed99d8715437c74145] = true; // 
164         ambassadors_[0xc7F15d0238d207e19cce6bd6C0B85f343896F046] = true; //
165         ambassadors_[0xBa21d01125D6932ce8ABf3625977899Fd2C7fa30] = true; //
166         ambassadors_[0x2277715856C6d9E0181BA01d21e059f76C79f2bD] = true; //
167         ambassadors_[0xB1dB0FB75Df1cfb37FD7fF0D7189Ddd0A68C9AAF] = true; //
168         ambassadors_[0xEafE863757a2b2a2c5C3f71988b7D59329d09A78] = true; //
169         ambassadors_[0xB19772e5E8229aC499C67E820Db53BF52dbaf0dE] = true; //        
170         ambassadors_[0x42830382f378d083A8Ae55Eb729A9d789fA4dEA6] = true; //
171         ambassadors_[0x87f7baA7e7570DD811e50fC43F5c26d02801F3f4] = true; //
172         ambassadors_[0x53e1eB6a53d9354d43155f76861C5a2AC80ef361] = true; //    
173         ambassadors_[0x80F946BF39531E65DBEdfcA1B9e29CaC562d43a4] = true; //  
174         ambassadors_[0x41a21b264F9ebF6cF571D4543a5b3AB1c6bEd98C] = true; // 
175         ambassadors_[0x267fa9F2F846da2c7A07eCeCc52dF7F493589098] = true; // 
176         
177         
178         
179 
180     }
181     
182   function disableAmbassadorPhase() public{
183         require(admin==msg.sender);
184         onlyAmbassadors=false;
185     }
186     
187   function changeEmployee1(address _employeeAddress1) public{
188         require(admin==msg.sender);
189         employeeFeeAddress1=_employeeAddress1;
190     }
191     
192   function changeEmployee2(address _employeeAddress2) public{
193         require(admin==msg.sender);
194         employeeFeeAddress2=_employeeAddress2;
195     }
196     
197   function changeEmployee3(address _employeeAddress3) public{
198         require(admin==msg.sender);
199         employeeFeeAddress3=_employeeAddress3;
200     }
201     
202   function changeMarketing(address _marketingAddress) public{
203         require(admin==msg.sender);
204         marketingFeeAddress=_marketingAddress;
205     }
206     
207     /*=======================================
208     =            PUBLIC FUNCTIONS           =
209     =======================================*/
210 
211     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
212     function buy(address _referredBy) public payable returns (uint256) {
213         purchaseTokens(msg.value, _referredBy);
214     }
215 
216     /**
217      * @dev Fallback function to handle ethereum that was send straight to the contract
218      *  Unfortunately we cannot use a referral address this way.
219      */
220     function() payable public {
221         purchaseTokens(msg.value, 0x0);
222     }
223 
224     /// @dev Converts all of caller's dividends to tokens.
225     function reinvest() onlyStronghands public {
226         // fetch dividends
227         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
228 
229         // pay out the dividends virtually
230         address _customerAddress = msg.sender;
231         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
232 
233         // retrieve ref. bonus
234         _dividends += referralBalance_[_customerAddress];
235         referralBalance_[_customerAddress] = 0;
236 
237         // dispatch a buy order with the virtualized "withdrawn dividends"
238         uint256 _tokens = purchaseTokens(_dividends, 0x0);
239 
240         // fire event
241          onReinvestment(_customerAddress, _dividends, _tokens);
242     }
243 
244     /// @dev Alias of sell() and withdraw().
245     function exit() public {
246         // get token count for caller & sell them all
247         address _customerAddress = msg.sender;
248         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
249         if (_tokens > 0) sell(_tokens);
250 
251         // lambo delivery service
252         withdraw();
253     }
254 
255     /// @dev Withdraws all of the callers earnings.
256     function withdraw() onlyStronghands public {
257         // setup data
258         address _customerAddress = msg.sender;
259         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
260 
261         // update dividend tracker
262         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
263 
264         // add ref. bonus
265         _dividends += referralBalance_[_customerAddress];
266         referralBalance_[_customerAddress] = 0;
267 
268         // lambo delivery service
269         _customerAddress.transfer(_dividends);
270 
271         // fire event
272          onWithdraw(_customerAddress, _dividends);
273     }
274 
275     /// @dev Liquifies tokens to ethereum.
276     function sell(uint256 _amountOfTokens) onlyBagholders public {
277         // setup data
278         address _customerAddress = msg.sender;
279         // russian hackers BTFO
280         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
281         uint256 _tokens = _amountOfTokens;
282         uint256 _ethereum = tokensToEthereum_(_tokens);
283         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
284         uint256 _devFee = SafeMath.div(SafeMath.mul(_ethereum, 1), 100);
285         uint256 _marketingFee = SafeMath.div(SafeMath.mul(_ethereum, 1), 100);
286         uint256 _feedingFee = SafeMath.div(SafeMath.mul(_ethereum, 1), 100);
287         
288         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _devFee), _marketingFee), _feedingFee);
289 
290         // burn the sold tokens
291         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
292         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
293 
294         // update dividends tracker
295         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
296         payoutsTo_[_customerAddress] -= _updatedPayouts;
297 
298         // dividing by zero is a bad idea
299         if (tokenSupply_ > 0) {
300             // update the amount of dividends per token
301             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
302         }
303         devFeeAddress.transfer(_devFee);
304         marketingFeeAddress.transfer(_marketingFee);
305         feedingFeeAddress.transfer(_feedingFee);
306         // fire event
307          onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
308        
309     }
310 
311 
312     /**
313      * @dev Transfer tokens from the caller to a new holder.
314      *  Remember, there's a 5% fee here as well.
315      */
316     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
317         // setup
318         address _customerAddress = msg.sender;
319 
320         // make sure we have the requested tokens
321         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
322 
323         // withdraw all outstanding dividends first
324         if (myDividends(true) > 0) {
325             withdraw();
326         }
327 
328         // liquify 5% of the tokens that are transfered
329         // these are dispersed to shareholders
330         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
331         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
332         uint256 _dividends = tokensToEthereum_(_tokenFee);
333 
334         // burn the fee tokens
335         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
336 
337         // exchange tokens
338         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
339         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
340 
341         // update dividend trackers
342         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
343         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
344 
345         // disperse dividends among holders
346         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
347 
348         // fire event
349          Transfer(_customerAddress, _toAddress, _taxedTokens);
350 
351         // ERC20
352         return true;
353     }
354 
355 
356     /*=====================================
357     =      HELPERS AND CALCULATORS        =
358     =====================================*/
359 
360     /**
361      * @dev Method to view the current Ethereum stored in the contract
362      *  Example: totalEthereumBalance()
363      */
364     function totalEthereumBalance() public view returns (uint256) {
365         return this.balance;
366     }
367 
368     /// @dev Retrieve the total token supply.
369     function totalSupply() public view returns (uint256) {
370         return tokenSupply_;
371     }
372 
373     /// @dev Retrieve the tokens owned by the caller.
374     function myTokens() public view returns (uint256) {
375         address _customerAddress = msg.sender;
376         return balanceOf(_customerAddress);
377     }
378 
379     /**
380      * @dev Retrieve the dividends owned by the caller.
381      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
382      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
383      *  But in the internal calculations, we want them separate.
384      */
385     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
386         address _customerAddress = msg.sender;
387         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
388     }
389 
390     /// @dev Retrieve the token balance of any single address.
391     function balanceOf(address _customerAddress) public view returns (uint256) {
392         return tokenBalanceLedger_[_customerAddress];
393     }
394 
395     /// @dev Retrieve the dividend balance of any single address.
396     function dividendsOf(address _customerAddress) public view returns (uint256) {
397         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
398     }
399 
400     /// @dev Return the sell price of 1 individual token.
401     function sellPrice() public view returns (uint256) {
402         // our calculation relies on the token supply, so we need supply. Doh.
403         if (tokenSupply_ == 0) {
404             return tokenPriceInitial_ - tokenPriceIncremental_;
405         } else {
406             uint256 _ethereum = tokensToEthereum_(1e18);
407             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
408             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
409 
410             return _taxedEthereum;
411         }
412     }
413 
414     /// @dev Return the buy price of 1 individual token.
415     function buyPrice() public view returns (uint256) {
416         // our calculation relies on the token supply, so we need supply. Doh.
417         if (tokenSupply_ == 0) {
418             return tokenPriceInitial_ + tokenPriceIncremental_;
419         } else {
420             uint256 _ethereum = tokensToEthereum_(1e18);
421             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
422             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
423 
424             return _taxedEthereum;
425         }
426     }
427 
428     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
429     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
430         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
431         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
432         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
433 
434         return _amountOfTokens;
435     }
436 
437     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
438     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
439         require(_tokensToSell <= tokenSupply_);
440         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
441         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
442         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
443         return _taxedEthereum;
444     }
445 
446 
447     /*==========================================
448     =            INTERNAL FUNCTIONS            =
449     ==========================================*/
450 
451     /// @dev Internal function to actually purchase the tokens.
452     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) antiEarlyWhale(_incomingEthereum)
453        internal returns (uint256) {
454         // data setup
455         address _customerAddress = msg.sender;
456         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
457         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
458         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
459         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
460         _taxedEthereum = SafeMath.sub(_taxedEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, 3), 200));
461         _taxedEthereum = SafeMath.sub(_taxedEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
462         _taxedEthereum = SafeMath.sub(_taxedEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
463         _taxedEthereum = SafeMath.sub(_taxedEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
464         _taxedEthereum = SafeMath.sub(_taxedEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
465         _taxedEthereum = SafeMath.sub(_taxedEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
466         
467         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
468         uint256 _fee = _dividends * magnitude;
469 
470         // no point in continuing execution if OP is a poorfag russian hacker
471         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
472         // (or hackers)
473         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
474         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
475 
476         // is the user referred by a masternode?
477         if (
478             // is this a referred purchase?
479             _referredBy != 0x0000000000000000000000000000000000000000 &&
480 
481             // no cheating!
482             _referredBy != _customerAddress &&
483 
484             // does the referrer have at least X whole tokens?
485             // i.e is the referrer a godly chad masternode
486             tokenBalanceLedger_[_referredBy] >= stakingRequirement
487         ) {
488             // wealth redistribution
489             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
490         } else {
491             // no ref purchase
492             // add the referral bonus back to the global dividends cake
493             _dividends = SafeMath.add(_dividends, _referralBonus);
494             _fee = _dividends * magnitude;
495         }
496 
497         // we can't give people infinite ethereum
498         if (tokenSupply_ > 0) {
499             // add tokens to the pool
500             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
501 
502             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
503             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
504 
505             // calculate the amount of tokens the customer receives over his purchase
506             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
507         } else {
508             // add tokens to the pool
509             tokenSupply_ = _amountOfTokens;
510         }
511 
512         // update circulating supply & the ledger address for the customer
513         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
514 
515         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
516         // really i know you think you do but you don't
517         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
518         payoutsTo_[_customerAddress] += _updatedPayouts;
519 
520         // fire event
521          onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
522         devFeeAddress.transfer(SafeMath.div(SafeMath.mul(_incomingEthereum, 3), 200));
523         marketingFeeAddress.transfer(SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
524         feedingFeeAddress.transfer(SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
525         employeeFeeAddress1.transfer(SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
526         employeeFeeAddress2.transfer(SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
527         employeeFeeAddress3.transfer(SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
528         return _amountOfTokens;
529     }
530 
531     /**
532      * @dev Calculate Token price based on an amount of incoming ethereum
533      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
534      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
535      */
536     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
537         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
538         uint256 _tokensReceived =
539          (
540             (
541                 // underflow attempts BTFO
542                 SafeMath.sub(
543                     (sqrt
544                         (
545                             (_tokenPriceInitial ** 2)
546                             +
547                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
548                             +
549                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
550                             +
551                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
552                         )
553                     ), _tokenPriceInitial
554                 )
555             ) / (tokenPriceIncremental_)
556         ) - (tokenSupply_);
557 
558         return _tokensReceived;
559     }
560 
561     /**
562      * @dev Calculate token sell value.
563      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
564      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
565      */
566     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
567         uint256 tokens_ = (_tokens + 1e18);
568         uint256 _tokenSupply = (tokenSupply_ + 1e18);
569         uint256 _etherReceived =
570         (
571             // underflow attempts BTFO
572             SafeMath.sub(
573                 (
574                     (
575                         (
576                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
577                         ) - tokenPriceIncremental_
578                     ) * (tokens_ - 1e18)
579                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
580             )
581         / 1e18);
582 
583         return _etherReceived;
584     }
585 
586     /// @dev This is where all your gas goes.
587     function sqrt(uint256 x) internal pure returns (uint256 y) {
588         uint256 z = (x + 1) / 2;
589         y = x;
590 
591         while (z < y) {
592             y = z;
593             z = (x / z + z) / 2;
594         }
595     }
596 
597 
598 }
599 
600 /**
601  * @title SafeMath
602  * @dev Math operations with safety checks that throw on error
603  */
604 library SafeMath {
605 
606     /**
607     * @dev Multiplies two numbers, throws on overflow.
608     */
609     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
610         if (a == 0) {
611             return 0;
612         }
613         uint256 c = a * b;
614         assert(c / a == b);
615         return c;
616     }
617 
618     /**
619     * @dev Integer division of two numbers, truncating the quotient.
620     */
621     function div(uint256 a, uint256 b) internal pure returns (uint256) {
622         // assert(b > 0); // Solidity automatically throws when dividing by 0
623         uint256 c = a / b;
624         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
625         return c;
626     }
627 
628     /**
629     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
630     */
631     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
632         assert(b <= a);
633         return a - b;
634     }
635 
636     /**
637     * @dev Adds two numbers, throws on overflow.
638     */
639     function add(uint256 a, uint256 b) internal pure returns (uint256) {
640         uint256 c = a + b;
641         assert(c >= a);
642         return c;
643     }
644 
645 }