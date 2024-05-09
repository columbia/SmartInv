1 pragma solidity ^0.4.20;
2 /*
3 /*
4 * ===========================
5 * Welcome To Ramen Coin! The FIRST and ONLY Proof of Ramen Cryptocurrency!
6 * Our cryptocurrency not only provides an opportunity to earn from playing our dApp but we will use funds in the long run 
7 * to help those who suffer from hunger and starvation in the world. By taking part in our dApp you are doing your part to help!
8 * |
9 *         |  /           
10 *         | /
11 *   .~^(,&|/o.   
12 *  |`-------^|
13 *  \         /
14 *   `======='  
15 * 
16 * https://ramencoin.me
17 *
18 * ===========================
19 * -> Who doesn't love Ramen?
20 * Incorporated the best aspects of different contracts to make a NEW and IMPROVED version which now includes:
21 * [✓] 20% dividends for token purchase, shared among all token holders.
22 * [✓] 10% dividends for token transfer, shared among all token holders.
23 * [✓] 25% dividends for token selling.
24 * [✓] 7% dividends is given to referrer.
25 * [✓] 50 tokens to activate Masternodes.
26 *
27 */
28 
29 contract RAMEN {
30 
31 
32     /*=================================
33     =            MODIFIERS            =
34     =================================*/
35 
36     /// @dev Only people with tokens
37     modifier onlyBagholders {
38         require(myTokens() > 0);
39         _;
40     }
41 
42     /// @dev Only people with profits
43     modifier onlyStronghands {
44         require(myDividends(true) > 0);
45         _;
46     }
47 
48 
49     /*==============================
50     =            EVENTS            =
51     ==============================*/
52 
53     event onTokenPurchase(
54         address indexed customerAddress,
55         uint256 incomingEthereum,
56         uint256 tokensMinted,
57         address indexed referredBy,
58         uint timestamp,
59         uint256 price
60     );
61 
62     event onTokenSell(
63         address indexed customerAddress,
64         uint256 tokensBurned,
65         uint256 ethereumEarned,
66         uint timestamp,
67         uint256 price
68     );
69 
70     event onReinvestment(
71         address indexed customerAddress,
72         uint256 ethereumReinvested,
73         uint256 tokensMinted
74     );
75 
76     event onWithdraw(
77         address indexed customerAddress,
78         uint256 ethereumWithdrawn
79     );
80 
81     // ERC20
82     event Transfer(
83         address indexed from,
84         address indexed to,
85         uint256 tokens
86     );
87 
88 
89     /*=====================================
90     =            CONFIGURABLES            =
91     =====================================*/
92 
93     string public name = "Ramen Coin";
94     string public symbol = "RAMEN";
95     uint8 constant public decimals = 18;
96 
97     /// @dev 15% dividends for token purchase
98     uint8 constant internal entryFee_ = 20;
99 
100     /// @dev 10% dividends for token transfer
101     uint8 constant internal transferFee_ = 10;
102 
103     /// @dev 25% dividends for token selling
104     uint8 constant internal exitFee_ = 25;
105 
106     /// @dev 35% of entryFee_ (i.e. 7% dividends) is given to referrer
107     uint8 constant internal refferalFee_ = 35;
108 
109     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
110     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
111     uint256 constant internal magnitude = 2 ** 64;
112 
113     /// @dev proof of stake (defaults at 50 tokens)
114     uint256 public stakingRequirement = 50e18;
115 
116 
117    /*=================================
118     =            DATASETS            =
119     ================================*/
120 
121     // amount of shares for each address (scaled number)
122     mapping(address => uint256) internal tokenBalanceLedger_;
123     mapping(address => uint256) internal referralBalance_;
124     mapping(address => int256) internal payoutsTo_;
125     uint256 internal tokenSupply_;
126     uint256 internal profitPerShare_;
127 
128 
129     /*=======================================
130     =            PUBLIC FUNCTIONS           =
131     =======================================*/
132 
133     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
134     function buy(address _referredBy) public payable returns (uint256) {
135         purchaseTokens(msg.value, _referredBy);
136     }
137 
138     /**
139      * @dev Fallback function to handle ethereum that was send straight to the contract
140      *  Unfortunately we cannot use a referral address this way.
141      */
142     function() payable public {
143         purchaseTokens(msg.value, 0x0);
144     }
145 
146     /// @dev Converts all of caller's dividends to tokens.
147     function reinvest() onlyStronghands public {
148         // fetch dividends
149         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
150 
151         // pay out the dividends virtually
152         address _customerAddress = msg.sender;
153         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
154 
155         // retrieve ref. bonus
156         _dividends += referralBalance_[_customerAddress];
157         referralBalance_[_customerAddress] = 0;
158 
159         // dispatch a buy order with the virtualized "withdrawn dividends"
160         uint256 _tokens = purchaseTokens(_dividends, 0x0);
161 
162         // fire event
163         onReinvestment(_customerAddress, _dividends, _tokens);
164     }
165 
166     /// @dev Alias of sell() and withdraw().
167     function exit() public {
168         // get token count for caller & sell them all
169         address _customerAddress = msg.sender;
170         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
171         if (_tokens > 0) sell(_tokens);
172 
173         // lambo delivery service
174         withdraw();
175     }
176 
177     /// @dev Withdraws all of the callers earnings.
178     function withdraw() onlyStronghands public {
179         // setup data
180         address _customerAddress = msg.sender;
181         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
182 
183         // update dividend tracker
184         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
185 
186         // add ref. bonus
187         _dividends += referralBalance_[_customerAddress];
188         referralBalance_[_customerAddress] = 0;
189 
190         // lambo delivery service
191         _customerAddress.transfer(_dividends);
192 
193         // fire event
194         onWithdraw(_customerAddress, _dividends);
195     }
196 
197     /// @dev Liquifies tokens to ethereum.
198     function sell(uint256 _amountOfTokens) onlyBagholders public {
199         // setup data
200         address _customerAddress = msg.sender;
201         // russian hackers BTFO
202         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
203         uint256 _tokens = _amountOfTokens;
204         uint256 _ethereum = tokensToEthereum_(_tokens);
205         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
206         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
207 
208         // burn the sold tokens
209         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
210         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
211 
212         // update dividends tracker
213         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
214         payoutsTo_[_customerAddress] -= _updatedPayouts;
215 
216         // dividing by zero is a bad idea
217         if (tokenSupply_ > 0) {
218             // update the amount of dividends per token
219             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
220         }
221 
222         // fire event
223         onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
224     }
225 
226 
227     /**
228      * @dev Transfer tokens from the caller to a new holder.
229      *  Remember, there's a 15% fee here as well.
230      */
231     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
232         // setup
233         address _customerAddress = msg.sender;
234 
235         // make sure we have the requested tokens
236         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
237 
238         // withdraw all outstanding dividends first
239         if (myDividends(true) > 0) {
240             withdraw();
241         }
242 
243         // liquify 10% of the tokens that are transfered
244         // these are dispersed to shareholders
245         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
246         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
247         uint256 _dividends = tokensToEthereum_(_tokenFee);
248 
249         // burn the fee tokens
250         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
251 
252         // exchange tokens
253         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
254         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
255 
256         // update dividend trackers
257         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
258         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
259 
260         // disperse dividends among holders
261         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
262 
263         // fire event
264         Transfer(_customerAddress, _toAddress, _taxedTokens);
265 
266         // ERC20
267         return true;
268     }
269 
270 
271     /*=====================================
272     =      HELPERS AND CALCULATORS        =
273     =====================================*/
274 
275     /**
276      * @dev Method to view the current Ethereum stored in the contract
277      *  Example: totalEthereumBalance()
278      */
279     function totalEthereumBalance() public view returns (uint256) {
280         return this.balance;
281     }
282 
283     /// @dev Retrieve the total token supply.
284     function totalSupply() public view returns (uint256) {
285         return tokenSupply_;
286     }
287 
288     /// @dev Retrieve the tokens owned by the caller.
289     function myTokens() public view returns (uint256) {
290         address _customerAddress = msg.sender;
291         return balanceOf(_customerAddress);
292     }
293 
294     /**
295      * @dev Retrieve the dividends owned by the caller.
296      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
297      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
298      *  But in the internal calculations, we want them separate.
299      */
300     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
301         address _customerAddress = msg.sender;
302         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
303     }
304 
305     /// @dev Retrieve the token balance of any single address.
306     function balanceOf(address _customerAddress) public view returns (uint256) {
307         return tokenBalanceLedger_[_customerAddress];
308     }
309 
310     /// @dev Retrieve the dividend balance of any single address.
311     function dividendsOf(address _customerAddress) public view returns (uint256) {
312         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
313     }
314 
315     /// @dev Return the sell price of 1 individual token.
316     function sellPrice() public view returns (uint256) {
317         // our calculation relies on the token supply, so we need supply. Doh.
318         if (tokenSupply_ == 0) {
319             return tokenPriceInitial_ - tokenPriceIncremental_;
320         } else {
321             uint256 _ethereum = tokensToEthereum_(1e18);
322             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
323             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
324 
325             return _taxedEthereum;
326         }
327     }
328 
329     /// @dev Return the buy price of 1 individual token.
330     function buyPrice() public view returns (uint256) {
331         // our calculation relies on the token supply, so we need supply. Doh.
332         if (tokenSupply_ == 0) {
333             return tokenPriceInitial_ + tokenPriceIncremental_;
334         } else {
335             uint256 _ethereum = tokensToEthereum_(1e18);
336             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
337             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
338 
339             return _taxedEthereum;
340         }
341     }
342 
343     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
344     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
345         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
346         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
347         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
348 
349         return _amountOfTokens;
350     }
351 
352     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
353     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
354         require(_tokensToSell <= tokenSupply_);
355         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
356         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
357         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
358         return _taxedEthereum;
359     }
360 
361 
362     /*==========================================
363     =            INTERNAL FUNCTIONS            =
364     ==========================================*/
365 
366     /// @dev Internal function to actually purchase the tokens.
367     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
368         // data setup
369         address _customerAddress = msg.sender;
370         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
371         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
372         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
373         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
374         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
375         uint256 _fee = _dividends * magnitude;
376 
377         // no point in continuing execution if OP is a poorfag russian hacker
378         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
379         // (or hackers)
380         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
381         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
382 
383         // is the user referred by a masternode?
384         if (
385             // is this a referred purchase?
386             _referredBy != 0x0000000000000000000000000000000000000000 &&
387 
388             // no cheating!
389             _referredBy != _customerAddress &&
390 
391             // does the referrer have at least X whole tokens?
392             // i.e is the referrer a godly chad masternode
393             tokenBalanceLedger_[_referredBy] >= stakingRequirement
394         ) {
395             // wealth redistribution
396             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
397         } else {
398             // no ref purchase
399             // add the referral bonus back to the global dividends cake
400             _dividends = SafeMath.add(_dividends, _referralBonus);
401             _fee = _dividends * magnitude;
402         }
403 
404         // we can't give people infinite ethereum
405         if (tokenSupply_ > 0) {
406             // add tokens to the pool
407             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
408 
409             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
410             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
411 
412             // calculate the amount of tokens the customer receives over his purchase
413             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
414         } else {
415             // add tokens to the pool
416             tokenSupply_ = _amountOfTokens;
417         }
418 
419         // update circulating supply & the ledger address for the customer
420         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
421 
422         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
423         // really i know you think you do but you don't
424         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
425         payoutsTo_[_customerAddress] += _updatedPayouts;
426 
427         // fire event
428         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
429 
430         return _amountOfTokens;
431     }
432 
433     /**
434      * @dev Calculate Token price based on an amount of incoming ethereum
435      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
436      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
437      */
438     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
439         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
440         uint256 _tokensReceived =
441          (
442             (
443                 // underflow attempts BTFO
444                 SafeMath.sub(
445                     (sqrt
446                         (
447                             (_tokenPriceInitial ** 2)
448                             +
449                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
450                             +
451                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
452                             +
453                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
454                         )
455                     ), _tokenPriceInitial
456                 )
457             ) / (tokenPriceIncremental_)
458         ) - (tokenSupply_);
459 
460         return _tokensReceived;
461     }
462 
463     /**
464      * @dev Calculate token sell value.
465      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
466      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
467      */
468     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
469         uint256 tokens_ = (_tokens + 1e18);
470         uint256 _tokenSupply = (tokenSupply_ + 1e18);
471         uint256 _etherReceived =
472         (
473             // underflow attempts BTFO
474             SafeMath.sub(
475                 (
476                     (
477                         (
478                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
479                         ) - tokenPriceIncremental_
480                     ) * (tokens_ - 1e18)
481                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
482             )
483         / 1e18);
484 
485         return _etherReceived;
486     }
487 
488     /// @dev This is where all your gas goes.
489     function sqrt(uint256 x) internal pure returns (uint256 y) {
490         uint256 z = (x + 1) / 2;
491         y = x;
492 
493         while (z < y) {
494             y = z;
495             z = (x / z + z) / 2;
496         }
497     }
498 
499 
500 }
501 
502 /**
503  * @title SafeMath
504  * @dev Math operations with safety checks that throw on error
505  */
506 library SafeMath {
507 
508     /**
509     * @dev Multiplies two numbers, throws on overflow.
510     */
511     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
512         if (a == 0) {
513             return 0;
514         }
515         uint256 c = a * b;
516         assert(c / a == b);
517         return c;
518     }
519 
520     /**
521     * @dev Integer division of two numbers, truncating the quotient.
522     */
523     function div(uint256 a, uint256 b) internal pure returns (uint256) {
524         // assert(b > 0); // Solidity automatically throws when dividing by 0
525         uint256 c = a / b;
526         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
527         return c;
528     }
529 
530     /**
531     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
532     */
533     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
534         assert(b <= a);
535         return a - b;
536     }
537 
538     /**
539     * @dev Adds two numbers, throws on overflow.
540     */
541     function add(uint256 a, uint256 b) internal pure returns (uint256) {
542         uint256 c = a + b;
543         assert(c >= a);
544         return c;
545     }
546 
547 }