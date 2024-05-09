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
83     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
84     uint256 constant internal tokenPriceIncremental_ = 0.00000007 ether;
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
245         uint256 _devFee = SafeMath.div(SafeMath.mul(_ethereum, 1), 200);
246         
247         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _devFee);
248 
249         // burn the sold tokens
250         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
251         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
252 
253         // update dividends tracker
254         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
255         payoutsTo_[_customerAddress] -= _updatedPayouts;
256 
257         // dividing by zero is a bad idea
258         if (tokenSupply_ > 0) {
259             // update the amount of dividends per token
260             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
261         }
262         devFeeAddress.transfer(_devFee);
263         // fire event
264          onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
265        
266     }
267 
268 
269     /**
270      * @dev Transfer tokens from the caller to a new holder.
271      *  Remember, there's a 4% fee here as well.
272      */
273     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
274         // setup
275         address _customerAddress = msg.sender;
276 
277         // make sure we have the requested tokens
278         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
279 
280         // withdraw all outstanding dividends first
281         if (myDividends(true) > 0) {
282             withdraw();
283         }
284 
285         // liquify 5% of the tokens that are transfered
286         // these are dispersed to shareholders
287         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
288         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
289         uint256 _dividends = tokensToEthereum_(_tokenFee);
290 
291         // burn the fee tokens
292         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
293 
294         // exchange tokens
295         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
296         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
297 
298         // update dividend trackers
299         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
300         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
301 
302         // disperse dividends among holders
303         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
304 
305         // fire event
306          Transfer(_customerAddress, _toAddress, _taxedTokens);
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
322         return this.balance;
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
364             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
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
390 
391         return _amountOfTokens;
392     }
393 
394     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
395     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
396         require(_tokensToSell <= tokenSupply_);
397         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
398         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
399         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
400         return _taxedEthereum;
401     }
402 
403 
404     /*==========================================
405     =            INTERNAL FUNCTIONS            =
406     ==========================================*/
407 
408     /// @dev Internal function to actually purchase the tokens.
409     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) antiEarlyWhale(_incomingEthereum)
410        internal returns (uint256) {
411         // data setup
412         address _customerAddress = msg.sender;
413         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
414         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
415         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
416         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
417         _taxedEthereum = SafeMath.sub(_taxedEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
418         _taxedEthereum = SafeMath.sub(_taxedEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, 5), 200));
419         _taxedEthereum = SafeMath.sub(_taxedEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
420         _taxedEthereum = SafeMath.sub(_taxedEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
421         _taxedEthereum = SafeMath.sub(_taxedEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
422         _taxedEthereum = SafeMath.sub(_taxedEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 200));
423         
424         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
425         uint256 _fee = _dividends * magnitude;
426 
427         // no point in continuing execution if OP is a poorfag russian hacker
428         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
429         // (or hackers)
430         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
431         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
432 
433         // is the user referred by a masternode?
434         if (
435             // is this a referred purchase?
436             _referredBy != 0x0000000000000000000000000000000000000000 &&
437 
438             // no cheating!
439             _referredBy != _customerAddress &&
440 
441             // does the referrer have at least X whole tokens?
442             // i.e is the referrer a godly chad masternode
443             tokenBalanceLedger_[_referredBy] >= stakingRequirement
444         ) {
445             // wealth redistribution
446             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
447         } else {
448             // no ref purchase
449             // add the referral bonus back to the global dividends cake
450             _dividends = SafeMath.add(_dividends, _referralBonus);
451             _fee = _dividends * magnitude;
452         }
453 
454         // we can't give people infinite ethereum
455         if (tokenSupply_ > 0) {
456             // add tokens to the pool
457             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
458 
459             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
460             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
461 
462             // calculate the amount of tokens the customer receives over his purchase
463             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
464         } else {
465             // add tokens to the pool
466             tokenSupply_ = _amountOfTokens;
467         }
468 
469         // update circulating supply & the ledger address for the customer
470         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
471 
472         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
473         // really i know you think you do but you don't
474         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
475         payoutsTo_[_customerAddress] += _updatedPayouts;
476 
477         // fire event
478          onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
479         devFeeAddress.transfer(SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100));
480         return _amountOfTokens;
481     }
482 
483     /**
484      * @dev Calculate Token price based on an amount of incoming ethereum
485      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
486      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
487      */
488     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
489         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
490         uint256 _tokensReceived =
491          (
492             (
493                 // underflow attempts BTFO
494                 SafeMath.sub(
495                     (sqrt
496                         (
497                             (_tokenPriceInitial ** 2)
498                             +
499                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
500                             +
501                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
502                             +
503                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
504                         )
505                     ), _tokenPriceInitial
506                 )
507             ) / (tokenPriceIncremental_)
508         ) - (tokenSupply_);
509 
510         return _tokensReceived;
511     }
512 
513     /**
514      * @dev Calculate token sell value.
515      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
516      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
517      */
518     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
519         uint256 tokens_ = (_tokens + 1e18);
520         uint256 _tokenSupply = (tokenSupply_ + 1e18);
521         uint256 _etherReceived =
522         (
523             // underflow attempts BTFO
524             SafeMath.sub(
525                 (
526                     (
527                         (
528                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
529                         ) - tokenPriceIncremental_
530                     ) * (tokens_ - 1e18)
531                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
532             )
533         / 1e18);
534 
535         return _etherReceived;
536     }
537 
538     /// @dev This is where all your gas goes.
539     function sqrt(uint256 x) internal pure returns (uint256 y) {
540         uint256 z = (x + 1) / 2;
541         y = x;
542 
543         while (z < y) {
544             y = z;
545             z = (x / z + z) / 2;
546         }
547     }
548 
549 
550 }
551 
552 /**
553  * @title SafeMath
554  * @dev Math operations with safety checks that throw on error
555  */
556 library SafeMath {
557 
558     /**
559     * @dev Multiplies two numbers, throws on overflow.
560     */
561     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
562         if (a == 0) {
563             return 0;
564         }
565         uint256 c = a * b;
566         assert(c / a == b);
567         return c;
568     }
569 
570     /**
571     * @dev Integer division of two numbers, truncating the quotient.
572     */
573     function div(uint256 a, uint256 b) internal pure returns (uint256) {
574         // assert(b > 0); // Solidity automatically throws when dividing by 0
575         uint256 c = a / b;
576         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
577         return c;
578     }
579 
580     /**
581     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
582     */
583     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
584         assert(b <= a);
585         return a - b;
586     }
587 
588     /**
589     * @dev Adds two numbers, throws on overflow.
590     */
591     function add(uint256 a, uint256 b) internal pure returns (uint256) {
592         uint256 c = a + b;
593         assert(c >= a);
594         return c;
595     }
596 
597 }