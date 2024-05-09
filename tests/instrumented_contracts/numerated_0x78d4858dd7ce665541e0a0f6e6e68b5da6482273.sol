1 pragma solidity ^0.4.20;
2 
3 /*
4 *
5 * Incorporated the strong points of different POW{x}, best config:
6 * [✓] 10% dividends for token purchase, shared among all token holders.
7 * [✓] 10% dividends for token transfer, shared among all token holders.
8 * [✓] 10% dividends for token selling.
9 * [✓] 7% dividends is given to referrer.
10 * [✓] 100 tokens to activate Masternodes.
11 *
12 */
13 
14 contract NPCM {
15 
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
33 
34     /*==============================
35     =            EVENTS            =
36     ==============================*/
37 
38     event onTokenPurchase(
39         address indexed customerAddress,
40         uint256 incomingEthereum,
41         uint256 tokensMinted,
42         address indexed referredBy,
43         uint timestamp,
44         uint256 price
45     );
46 
47     event onTokenSell(
48         address indexed customerAddress,
49         uint256 tokensBurned,
50         uint256 ethereumEarned,
51         uint timestamp,
52         uint256 price
53     );
54 
55     event onReinvestment(
56         address indexed customerAddress,
57         uint256 ethereumReinvested,
58         uint256 tokensMinted
59     );
60 
61     event onWithdraw(
62         address indexed customerAddress,
63         uint256 ethereumWithdrawn
64     );
65 
66     // ERC20
67     event Transfer(
68         address indexed from,
69         address indexed to,
70         uint256 tokens
71     );
72 
73 
74     /*=====================================
75     =            CONFIGURABLES            =
76     =====================================*/
77 
78     string public name = "Noponzi Carlos Matos";
79     string public symbol = "NPCM";
80     uint8 constant public decimals = 18;
81 
82     /// @dev 10% dividends for token purchase
83     uint8 constant internal entryFee_ = 10;
84 
85     /// @dev 10% dividends for token transfer
86     uint8 constant internal transferFee_ = 10;
87 
88     /// @dev 10% dividends for token selling
89     uint8 constant internal exitFee_ = 10;
90 
91     /// @dev 35% of entryFee_ (i.e. 7% dividends) is given to referrer
92     uint8 constant internal refferalFee_ = 35;
93 
94     uint256 constant internal tokenPriceInitial_ = 0.00180000 ether;
95     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
96     uint256 constant internal magnitude = 2 ** 64;
97 
98     /// @dev proof of stake (defaults at 100 tokens)
99     uint256 public stakingRequirement = 100e18;
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
112 
113 
114     /*=======================================
115     =            PUBLIC FUNCTIONS           =
116     =======================================*/
117 
118     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
119     function buy(address _referredBy) public payable returns (uint256) {
120         purchaseTokens(msg.value, _referredBy);
121     }
122 
123     /**
124      * @dev Fallback function to handle ethereum that was send straight to the contract
125      *  Unfortunately we cannot use a referral address this way.
126      */
127     function() payable public {
128         purchaseTokens(msg.value, 0x0);
129     }
130 
131     /// @dev Converts all of caller's dividends to tokens.
132     function reinvest() onlyStronghands public {
133         // fetch dividends
134         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
135 
136         // pay out the dividends virtually
137         address _customerAddress = msg.sender;
138         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
139 
140         // retrieve ref. bonus
141         _dividends += referralBalance_[_customerAddress];
142         referralBalance_[_customerAddress] = 0;
143 
144         // dispatch a buy order with the virtualized "withdrawn dividends"
145         uint256 _tokens = purchaseTokens(_dividends, 0x0);
146 
147         // fire event
148         onReinvestment(_customerAddress, _dividends, _tokens);
149     }
150 
151     /// @dev Alias of sell() and withdraw().
152     function exit() public {
153         // get token count for caller & sell them all
154         address _customerAddress = msg.sender;
155         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
156         if (_tokens > 0) sell(_tokens);
157 
158         // lambo delivery service
159         withdraw();
160     }
161 
162     /// @dev Withdraws all of the callers earnings.
163     function withdraw() onlyStronghands public {
164         // setup data
165         address _customerAddress = msg.sender;
166         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
167 
168         // update dividend tracker
169         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
170 
171         // add ref. bonus
172         _dividends += referralBalance_[_customerAddress];
173         referralBalance_[_customerAddress] = 0;
174 
175         // lambo delivery service
176         _customerAddress.transfer(_dividends);
177 
178         // fire event
179         onWithdraw(_customerAddress, _dividends);
180     }
181 
182     /// @dev Liquifies tokens to ethereum.
183     function sell(uint256 _amountOfTokens) onlyBagholders public {
184         // setup data
185         address _customerAddress = msg.sender;
186         // russian hackers BTFO
187         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
188         uint256 _tokens = _amountOfTokens;
189         uint256 _ethereum = tokensToEthereum_(_tokens);
190         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
191         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
192 
193         // burn the sold tokens
194         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
195         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
196 
197         // update dividends tracker
198         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
199         payoutsTo_[_customerAddress] -= _updatedPayouts;
200 
201         // dividing by zero is a bad idea
202         if (tokenSupply_ > 0) {
203             // update the amount of dividends per token
204             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
205         }
206 
207         // fire event
208         onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
209     }
210 
211 
212     /**
213      * @dev Transfer tokens from the caller to a new holder.
214      *  Remember, there's a 15% fee here as well.
215      */
216     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
217         // setup
218         address _customerAddress = msg.sender;
219 
220         // make sure we have the requested tokens
221         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
222 
223         // withdraw all outstanding dividends first
224         if (myDividends(true) > 0) {
225             withdraw();
226         }
227 
228         // liquify 10% of the tokens that are transfered
229         // these are dispersed to shareholders
230         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
231         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
232         uint256 _dividends = tokensToEthereum_(_tokenFee);
233 
234         // burn the fee tokens
235         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
236 
237         // exchange tokens
238         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
239         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
240 
241         // update dividend trackers
242         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
243         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
244 
245         // disperse dividends among holders
246         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
247 
248         // fire event
249         Transfer(_customerAddress, _toAddress, _taxedTokens);
250 
251         // ERC20
252         return true;
253     }
254 
255 
256     /*=====================================
257     =      HELPERS AND CALCULATORS        =
258     =====================================*/
259 
260     /**
261      * @dev Method to view the current Ethereum stored in the contract
262      *  Example: totalEthereumBalance()
263      */
264     function totalEthereumBalance() public view returns (uint256) {
265         return this.balance;
266     }
267 
268     /// @dev Retrieve the total token supply.
269     function totalSupply() public view returns (uint256) {
270         return tokenSupply_;
271     }
272 
273     /// @dev Retrieve the tokens owned by the caller.
274     function myTokens() public view returns (uint256) {
275         address _customerAddress = msg.sender;
276         return balanceOf(_customerAddress);
277     }
278 
279     /**
280      * @dev Retrieve the dividends owned by the caller.
281      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
282      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
283      *  But in the internal calculations, we want them separate.
284      */
285     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
286         address _customerAddress = msg.sender;
287         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
288     }
289 
290     /// @dev Retrieve the token balance of any single address.
291     function balanceOf(address _customerAddress) public view returns (uint256) {
292         return tokenBalanceLedger_[_customerAddress];
293     }
294 
295     /// @dev Retrieve the dividend balance of any single address.
296     function dividendsOf(address _customerAddress) public view returns (uint256) {
297         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
298     }
299 
300     /// @dev Return the sell price of 1 individual token.
301     function sellPrice() public view returns (uint256) {
302         // our calculation relies on the token supply, so we need supply. Doh.
303         if (tokenSupply_ == 0) {
304             return tokenPriceInitial_ - tokenPriceIncremental_;
305         } else {
306             uint256 _ethereum = tokensToEthereum_(1e18);
307             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
308             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
309 
310             return _taxedEthereum;
311         }
312     }
313 
314     /// @dev Return the buy price of 1 individual token.
315     function buyPrice() public view returns (uint256) {
316         // our calculation relies on the token supply, so we need supply. Doh.
317         if (tokenSupply_ == 0) {
318             return tokenPriceInitial_ + tokenPriceIncremental_;
319         } else {
320             uint256 _ethereum = tokensToEthereum_(1e18);
321             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
322             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
323 
324             return _taxedEthereum;
325         }
326     }
327 
328     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
329     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
330         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
331         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
332         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
333 
334         return _amountOfTokens;
335     }
336 
337     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
338     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
339         require(_tokensToSell <= tokenSupply_);
340         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
341         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
342         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
343         return _taxedEthereum;
344     }
345 
346 
347     /*==========================================
348     =            INTERNAL FUNCTIONS            =
349     ==========================================*/
350 
351     /// @dev Internal function to actually purchase the tokens.
352     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
353         // data setup
354         address _customerAddress = msg.sender;
355         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
356         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
357         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
358         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
359         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
360         uint256 _fee = _dividends * magnitude;
361 
362         // no point in continuing execution if OP is a poorfag russian hacker
363         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
364         // (or hackers)
365         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
366         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
367 
368         // is the user referred by a masternode?
369         if (
370             // is this a referred purchase?
371             _referredBy != 0x0000000000000000000000000000000000000000 &&
372 
373             // no cheating!
374             _referredBy != _customerAddress &&
375 
376             // does the referrer have at least X whole tokens?
377             // i.e is the referrer a godly chad masternode
378             tokenBalanceLedger_[_referredBy] >= stakingRequirement
379         ) {
380             // wealth redistribution
381             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
382         } else {
383             // no ref purchase
384             // add the referral bonus back to the global dividends cake
385             _dividends = SafeMath.add(_dividends, _referralBonus);
386             _fee = _dividends * magnitude;
387         }
388 
389         // we can't give people infinite ethereum
390         if (tokenSupply_ > 0) {
391             // add tokens to the pool
392             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
393 
394             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
395             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
396 
397             // calculate the amount of tokens the customer receives over his purchase
398             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
399         } else {
400             // add tokens to the pool
401             tokenSupply_ = _amountOfTokens;
402         }
403 
404         // update circulating supply & the ledger address for the customer
405         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
406 
407         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
408         // really i know you think you do but you don't
409         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
410         payoutsTo_[_customerAddress] += _updatedPayouts;
411 
412         // fire event
413         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
414 
415         return _amountOfTokens;
416     }
417 
418     /**
419      * @dev Calculate Token price based on an amount of incoming ethereum
420      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
421      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
422      */
423     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
424         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
425         uint256 _tokensReceived =
426          (
427             (
428                 // underflow attempts BTFO
429                 SafeMath.sub(
430                     (sqrt
431                         (
432                             (_tokenPriceInitial ** 2)
433                             +
434                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
435                             +
436                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
437                             +
438                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
439                         )
440                     ), _tokenPriceInitial
441                 )
442             ) / (tokenPriceIncremental_)
443         ) - (tokenSupply_);
444 
445         return _tokensReceived;
446     }
447 
448     /**
449      * @dev Calculate token sell value.
450      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
451      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
452      */
453     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
454         uint256 tokens_ = (_tokens + 1e18);
455         uint256 _tokenSupply = (tokenSupply_ + 1e18);
456         uint256 _etherReceived =
457         (
458             // underflow attempts BTFO
459             SafeMath.sub(
460                 (
461                     (
462                         (
463                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
464                         ) - tokenPriceIncremental_
465                     ) * (tokens_ - 1e18)
466                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
467             )
468         / 1e18);
469 
470         return _etherReceived;
471     }
472 
473     /// @dev This is where all your gas goes.
474     function sqrt(uint256 x) internal pure returns (uint256 y) {
475         uint256 z = (x + 1) / 2;
476         y = x;
477 
478         while (z < y) {
479             y = z;
480             z = (x / z + z) / 2;
481         }
482     }
483 
484 
485 }
486 
487 /**
488  * @title SafeMath
489  * @dev Math operations with safety checks that throw on error
490  */
491 library SafeMath {
492 
493     /**
494     * @dev Multiplies two numbers, throws on overflow.
495     */
496     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
497         if (a == 0) {
498             return 0;
499         }
500         uint256 c = a * b;
501         assert(c / a == b);
502         return c;
503     }
504 
505     /**
506     * @dev Integer division of two numbers, truncating the quotient.
507     */
508     function div(uint256 a, uint256 b) internal pure returns (uint256) {
509         // assert(b > 0); // Solidity automatically throws when dividing by 0
510         uint256 c = a / b;
511         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
512         return c;
513     }
514 
515     /**
516     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
517     */
518     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
519         assert(b <= a);
520         return a - b;
521     }
522 
523     /**
524     * @dev Adds two numbers, throws on overflow.
525     */
526     function add(uint256 a, uint256 b) internal pure returns (uint256) {
527         uint256 c = a + b;
528         assert(c >= a);
529         return c;
530     }
531 
532 }