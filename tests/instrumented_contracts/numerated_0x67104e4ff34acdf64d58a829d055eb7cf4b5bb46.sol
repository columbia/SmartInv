1 pragma solidity ^0.4.20;
2 /*
3 /*
4 * ===========================
5 * We Present to you....
6 * Coin Karma
7 * 
8 *================================*
9 *| |                             *
10 *| | ____ _ _ __ _ __ ___   __ _ *
11 *| |/ / _` | '__| '_ ` _ \ / _` |*
12 *|   < (_| | |  | | | | | | (_| |*
13 *|_|\_\__,_|_|  |_| |_| |_|\__,_|*
14 *================================*
15 *
16 * Game: https://coinkarma.me
17 * Discord: https://discord.gg/4G7Jr7N
18 * ===========================
19 * -> Karma is Universal and now.. It's DECENTRALIZED!
20 * We've managed to incorporated the best aspects of different contracts to bring KARMA to the blockchain.
21 *
22 * Why participate in our Ethereum dApp Game?
23 * [✓] 20% rewards for KARMA purchases, split among all KARMA holders.
24 * [✓] 10% rewards for KARMA transfers, split among all KARMA holders.
25 * [✓] 25% rewards for KARMA selling.
26 * [✓] 7% rewards is given to masternode referrer.
27 * [✓] 50 KARMA required to activate Masternodes (Must maintain 50 KARMA at ALL TIMES to benefit from masternode referrals.
28 *
29 */
30 
31 contract KARMA {
32 
33 
34     /*=================================
35     =            MODIFIERS            =
36     =================================*/
37 
38     /// @dev Only people with tokens
39     modifier onlyBagholders {
40         require(myTokens() > 0);
41         _;
42     }
43 
44     /// @dev Only people with profits
45     modifier onlyStronghands {
46         require(myDividends(true) > 0);
47         _;
48     }
49 
50 
51     /*==============================
52     =            EVENTS            =
53     ==============================*/
54 
55     event onTokenPurchase(
56         address indexed customerAddress,
57         uint256 incomingEthereum,
58         uint256 tokensMinted,
59         address indexed referredBy,
60         uint timestamp,
61         uint256 price
62     );
63 
64     event onTokenSell(
65         address indexed customerAddress,
66         uint256 tokensBurned,
67         uint256 ethereumEarned,
68         uint timestamp,
69         uint256 price
70     );
71 
72     event onReinvestment(
73         address indexed customerAddress,
74         uint256 ethereumReinvested,
75         uint256 tokensMinted
76     );
77 
78     event onWithdraw(
79         address indexed customerAddress,
80         uint256 ethereumWithdrawn
81     );
82 
83     // ERC20
84     event Transfer(
85         address indexed from,
86         address indexed to,
87         uint256 tokens
88     );
89 
90 
91     /*=====================================
92     =            CONFIGURABLES            =
93     =====================================*/
94 
95     string public name = "Coin Karma";
96     string public symbol = "KARMA";
97     uint8 constant public decimals = 18;
98 
99     /// @dev 15% dividends for token purchase
100     uint8 constant internal entryFee_ = 20;
101 
102     /// @dev 10% dividends for token transfer
103     uint8 constant internal transferFee_ = 10;
104 
105     /// @dev 25% dividends for token selling
106     uint8 constant internal exitFee_ = 25;
107 
108     /// @dev 35% of entryFee_ (i.e. 7% dividends) is given to referrer
109     uint8 constant internal refferalFee_ = 35;
110 
111     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
112     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
113     uint256 constant internal magnitude = 2 ** 64;
114 
115     /// @dev proof of stake (defaults at 50 tokens)
116     uint256 public stakingRequirement = 50e18;
117 
118 
119    /*=================================
120     =            DATASETS            =
121     ================================*/
122 
123     // amount of shares for each address (scaled number)
124     mapping(address => uint256) internal tokenBalanceLedger_;
125     mapping(address => uint256) internal referralBalance_;
126     mapping(address => int256) internal payoutsTo_;
127     uint256 internal tokenSupply_;
128     uint256 internal profitPerShare_;
129 
130 
131     /*=======================================
132     =            PUBLIC FUNCTIONS           =
133     =======================================*/
134 
135     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
136     function buy(address _referredBy) public payable returns (uint256) {
137         purchaseTokens(msg.value, _referredBy);
138     }
139 
140     /**
141      * @dev Fallback function to handle ethereum that was send straight to the contract
142      *  Unfortunately we cannot use a referral address this way.
143      */
144     function() payable public {
145         purchaseTokens(msg.value, 0x0);
146     }
147 
148     /// @dev Converts all of caller's dividends to tokens.
149     function reinvest() onlyStronghands public {
150         // fetch dividends
151         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
152 
153         // pay out the dividends virtually
154         address _customerAddress = msg.sender;
155         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
156 
157         // retrieve ref. bonus
158         _dividends += referralBalance_[_customerAddress];
159         referralBalance_[_customerAddress] = 0;
160 
161         // dispatch a buy order with the virtualized "withdrawn dividends"
162         uint256 _tokens = purchaseTokens(_dividends, 0x0);
163 
164         // fire event
165         onReinvestment(_customerAddress, _dividends, _tokens);
166     }
167 
168     /// @dev Alias of sell() and withdraw().
169     function exit() public {
170         // get token count for caller & sell them all
171         address _customerAddress = msg.sender;
172         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
173         if (_tokens > 0) sell(_tokens);
174 
175         // lambo delivery service
176         withdraw();
177     }
178 
179     /// @dev Withdraws all of the callers earnings.
180     function withdraw() onlyStronghands public {
181         // setup data
182         address _customerAddress = msg.sender;
183         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
184 
185         // update dividend tracker
186         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
187 
188         // add ref. bonus
189         _dividends += referralBalance_[_customerAddress];
190         referralBalance_[_customerAddress] = 0;
191 
192         // lambo delivery service
193         _customerAddress.transfer(_dividends);
194 
195         // fire event
196         onWithdraw(_customerAddress, _dividends);
197     }
198 
199     /// @dev Liquifies tokens to ethereum.
200     function sell(uint256 _amountOfTokens) onlyBagholders public {
201         // setup data
202         address _customerAddress = msg.sender;
203         // russian hackers BTFO
204         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
205         uint256 _tokens = _amountOfTokens;
206         uint256 _ethereum = tokensToEthereum_(_tokens);
207         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
208         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
209 
210         // burn the sold tokens
211         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
212         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
213 
214         // update dividends tracker
215         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
216         payoutsTo_[_customerAddress] -= _updatedPayouts;
217 
218         // dividing by zero is a bad idea
219         if (tokenSupply_ > 0) {
220             // update the amount of dividends per token
221             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
222         }
223 
224         // fire event
225         onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
226     }
227 
228 
229     /**
230      * @dev Transfer tokens from the caller to a new holder.
231      *  Remember, there's a 15% fee here as well.
232      */
233     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
234         // setup
235         address _customerAddress = msg.sender;
236 
237         // make sure we have the requested tokens
238         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
239 
240         // withdraw all outstanding dividends first
241         if (myDividends(true) > 0) {
242             withdraw();
243         }
244 
245         // liquify 10% of the tokens that are transfered
246         // these are dispersed to shareholders
247         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
248         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
249         uint256 _dividends = tokensToEthereum_(_tokenFee);
250 
251         // burn the fee tokens
252         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
253 
254         // exchange tokens
255         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
256         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
257 
258         // update dividend trackers
259         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
260         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
261 
262         // disperse dividends among holders
263         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
264 
265         // fire event
266         Transfer(_customerAddress, _toAddress, _taxedTokens);
267 
268         // ERC20
269         return true;
270     }
271 
272 
273     /*=====================================
274     =      HELPERS AND CALCULATORS        =
275     =====================================*/
276 
277     /**
278      * @dev Method to view the current Ethereum stored in the contract
279      *  Example: totalEthereumBalance()
280      */
281     function totalEthereumBalance() public view returns (uint256) {
282         return this.balance;
283     }
284 
285     /// @dev Retrieve the total token supply.
286     function totalSupply() public view returns (uint256) {
287         return tokenSupply_;
288     }
289 
290     /// @dev Retrieve the tokens owned by the caller.
291     function myTokens() public view returns (uint256) {
292         address _customerAddress = msg.sender;
293         return balanceOf(_customerAddress);
294     }
295 
296     /**
297      * @dev Retrieve the dividends owned by the caller.
298      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
299      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
300      *  But in the internal calculations, we want them separate.
301      */
302     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
303         address _customerAddress = msg.sender;
304         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
305     }
306 
307     /// @dev Retrieve the token balance of any single address.
308     function balanceOf(address _customerAddress) public view returns (uint256) {
309         return tokenBalanceLedger_[_customerAddress];
310     }
311 
312     /// @dev Retrieve the dividend balance of any single address.
313     function dividendsOf(address _customerAddress) public view returns (uint256) {
314         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
315     }
316 
317     /// @dev Return the sell price of 1 individual token.
318     function sellPrice() public view returns (uint256) {
319         // our calculation relies on the token supply, so we need supply. Doh.
320         if (tokenSupply_ == 0) {
321             return tokenPriceInitial_ - tokenPriceIncremental_;
322         } else {
323             uint256 _ethereum = tokensToEthereum_(1e18);
324             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
325             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
326 
327             return _taxedEthereum;
328         }
329     }
330 
331     /// @dev Return the buy price of 1 individual token.
332     function buyPrice() public view returns (uint256) {
333         // our calculation relies on the token supply, so we need supply. Doh.
334         if (tokenSupply_ == 0) {
335             return tokenPriceInitial_ + tokenPriceIncremental_;
336         } else {
337             uint256 _ethereum = tokensToEthereum_(1e18);
338             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
339             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
340 
341             return _taxedEthereum;
342         }
343     }
344 
345     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
346     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
347         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
348         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
349         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
350 
351         return _amountOfTokens;
352     }
353 
354     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
355     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
356         require(_tokensToSell <= tokenSupply_);
357         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
358         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
359         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
360         return _taxedEthereum;
361     }
362 
363 
364     /*==========================================
365     =            INTERNAL FUNCTIONS            =
366     ==========================================*/
367 
368     /// @dev Internal function to actually purchase the tokens.
369     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
370         // data setup
371         address _customerAddress = msg.sender;
372         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
373         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
374         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
375         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
376         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
377         uint256 _fee = _dividends * magnitude;
378 
379         // no point in continuing execution if OP is a poorfag russian hacker
380         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
381         // (or hackers)
382         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
383         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
384 
385         // is the user referred by a masternode?
386         if (
387             // is this a referred purchase?
388             _referredBy != 0x0000000000000000000000000000000000000000 &&
389 
390             // no cheating!
391             _referredBy != _customerAddress &&
392 
393             // does the referrer have at least X whole tokens?
394             // i.e is the referrer a godly chad masternode
395             tokenBalanceLedger_[_referredBy] >= stakingRequirement
396         ) {
397             // wealth redistribution
398             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
399         } else {
400             // no ref purchase
401             // add the referral bonus back to the global dividends cake
402             _dividends = SafeMath.add(_dividends, _referralBonus);
403             _fee = _dividends * magnitude;
404         }
405 
406         // we can't give people infinite ethereum
407         if (tokenSupply_ > 0) {
408             // add tokens to the pool
409             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
410 
411             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
412             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
413 
414             // calculate the amount of tokens the customer receives over his purchase
415             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
416         } else {
417             // add tokens to the pool
418             tokenSupply_ = _amountOfTokens;
419         }
420 
421         // update circulating supply & the ledger address for the customer
422         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
423 
424         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
425         // really i know you think you do but you don't
426         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
427         payoutsTo_[_customerAddress] += _updatedPayouts;
428 
429         // fire event
430         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
431 
432         return _amountOfTokens;
433     }
434 
435     /**
436      * @dev Calculate Token price based on an amount of incoming ethereum
437      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
438      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
439      */
440     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
441         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
442         uint256 _tokensReceived =
443          (
444             (
445                 // underflow attempts BTFO
446                 SafeMath.sub(
447                     (sqrt
448                         (
449                             (_tokenPriceInitial ** 2)
450                             +
451                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
452                             +
453                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
454                             +
455                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
456                         )
457                     ), _tokenPriceInitial
458                 )
459             ) / (tokenPriceIncremental_)
460         ) - (tokenSupply_);
461 
462         return _tokensReceived;
463     }
464 
465     /**
466      * @dev Calculate token sell value.
467      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
468      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
469      */
470     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
471         uint256 tokens_ = (_tokens + 1e18);
472         uint256 _tokenSupply = (tokenSupply_ + 1e18);
473         uint256 _etherReceived =
474         (
475             // underflow attempts BTFO
476             SafeMath.sub(
477                 (
478                     (
479                         (
480                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
481                         ) - tokenPriceIncremental_
482                     ) * (tokens_ - 1e18)
483                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
484             )
485         / 1e18);
486 
487         return _etherReceived;
488     }
489 
490     /// @dev This is where all your gas goes.
491     function sqrt(uint256 x) internal pure returns (uint256 y) {
492         uint256 z = (x + 1) / 2;
493         y = x;
494 
495         while (z < y) {
496             y = z;
497             z = (x / z + z) / 2;
498         }
499     }
500 
501 
502 }
503 
504 /**
505  * @title SafeMath
506  * @dev Math operations with safety checks that throw on error
507  */
508 library SafeMath {
509 
510     /**
511     * @dev Multiplies two numbers, throws on overflow.
512     */
513     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
514         if (a == 0) {
515             return 0;
516         }
517         uint256 c = a * b;
518         assert(c / a == b);
519         return c;
520     }
521 
522     /**
523     * @dev Integer division of two numbers, truncating the quotient.
524     */
525     function div(uint256 a, uint256 b) internal pure returns (uint256) {
526         // assert(b > 0); // Solidity automatically throws when dividing by 0
527         uint256 c = a / b;
528         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
529         return c;
530     }
531 
532     /**
533     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
534     */
535     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
536         assert(b <= a);
537         return a - b;
538     }
539 
540     /**
541     * @dev Adds two numbers, throws on overflow.
542     */
543     function add(uint256 a, uint256 b) internal pure returns (uint256) {
544         uint256 c = a + b;
545         assert(c >= a);
546         return c;
547     }
548 
549 }