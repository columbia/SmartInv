1 pragma solidity ^0.4.20;
2 
3 /*
4 * Team PAPA AND FRIENDS presents...
5 * dankcoin.surge.sh
6 * https://discord.gg/Ne2PTnS
7 * 
8 * =================================================*
9 *       ___                                        *
10 *      |    \         |      |\     |  |  /        *
11 *      |     \       | |     | \    |  | /         *
12 *      |      |     |   |    |  \   |  |/          *
13 *      |      /    |_____|   |   \  |  |\          *
14 *      |     /    |       |  |    \ |  | \         *
15 *      |____/    |         | |     \|  |  \        *
16 *                                                  *
17 * =================================================*
18 *
19 * DANK COIN
20 * Join us to the MOOOOOOOOONNET!
21 *
22 * -> What?
23 * Incorporated the strong points of different POW{x}, best config:
24 * [✓] 20% dividends for token purchase, shared among all token holders.
25 * [✓] 10% dividends for token transfer, shared among all token holders.
26 * [✓] 25% dividends for token selling.
27 * [✓] 7% dividends is given to referrer.
28 * [✓] 50 tokens to activate Masternodes.
29 *
30 */
31 
32 contract DankCoin {
33 
34 
35     /*=================================
36     =            MODIFIERS            =
37     =================================*/
38 
39     /// @dev Only people with tokens
40     modifier onlyBagholders {
41         require(myTokens() > 0);
42         _;
43     }
44 
45     /// @dev Only people with profits
46     modifier onlyStronghands {
47         require(myDividends(true) > 0);
48         _;
49     }
50 
51 
52     /*==============================
53     =            EVENTS            =
54     ==============================*/
55 
56     event onTokenPurchase(
57         address indexed customerAddress,
58         uint256 incomingEthereum,
59         uint256 tokensMinted,
60         address indexed referredBy,
61         uint timestamp,
62         uint256 price
63     );
64 
65     event onTokenSell(
66         address indexed customerAddress,
67         uint256 tokensBurned,
68         uint256 ethereumEarned,
69         uint timestamp,
70         uint256 price
71     );
72 
73     event onReinvestment(
74         address indexed customerAddress,
75         uint256 ethereumReinvested,
76         uint256 tokensMinted
77     );
78 
79     event onWithdraw(
80         address indexed customerAddress,
81         uint256 ethereumWithdrawn
82     );
83 
84     // ERC20
85     event Transfer(
86         address indexed from,
87         address indexed to,
88         uint256 tokens
89     );
90 
91 
92     /*=====================================
93     =            CONFIGURABLES            =
94     =====================================*/
95 
96     string public name = "DankCoin";
97     string public symbol = "DANK";
98     uint8 constant public decimals = 18;
99 
100     /// @dev 15% dividends for token purchase
101     uint8 constant internal entryFee_ = 20;
102 
103     /// @dev 10% dividends for token transfer
104     uint8 constant internal transferFee_ = 10;
105 
106     /// @dev 25% dividends for token selling
107     uint8 constant internal exitFee_ = 25;
108 
109     /// @dev 35% of entryFee_ (i.e. 7% dividends) is given to referrer
110     uint8 constant internal refferalFee_ = 35;
111 
112     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
113     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
114     uint256 constant internal magnitude = 2 ** 64;
115 
116     /// @dev proof of stake (defaults at 50 tokens)
117     uint256 public stakingRequirement = 50e18;
118 
119 
120    /*=================================
121     =            DATASETS            =
122     ================================*/
123 
124     // amount of shares for each address (scaled number)
125     mapping(address => uint256) internal tokenBalanceLedger_;
126     mapping(address => uint256) internal referralBalance_;
127     mapping(address => int256) internal payoutsTo_;
128     uint256 internal tokenSupply_;
129     uint256 internal profitPerShare_;
130 
131 
132     /*=======================================
133     =            PUBLIC FUNCTIONS           =
134     =======================================*/
135 
136     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
137     function buy(address _referredBy) public payable returns (uint256) {
138         purchaseTokens(msg.value, _referredBy);
139     }
140 
141     /**
142      * @dev Fallback function to handle ethereum that was send straight to the contract
143      *  Unfortunately we cannot use a referral address this way.
144      */
145     function() payable public {
146         purchaseTokens(msg.value, 0x0);
147     }
148 
149     /// @dev Converts all of caller's dividends to tokens.
150     function reinvest() onlyStronghands public {
151         // fetch dividends
152         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
153 
154         // pay out the dividends virtually
155         address _customerAddress = msg.sender;
156         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
157 
158         // retrieve ref. bonus
159         _dividends += referralBalance_[_customerAddress];
160         referralBalance_[_customerAddress] = 0;
161 
162         // dispatch a buy order with the virtualized "withdrawn dividends"
163         uint256 _tokens = purchaseTokens(_dividends, 0x0);
164 
165         // fire event
166         onReinvestment(_customerAddress, _dividends, _tokens);
167     }
168 
169     /// @dev Alias of sell() and withdraw().
170     function exit() public {
171         // get token count for caller & sell them all
172         address _customerAddress = msg.sender;
173         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
174         if (_tokens > 0) sell(_tokens);
175 
176         // lambo delivery service
177         withdraw();
178     }
179 
180     /// @dev Withdraws all of the callers earnings.
181     function withdraw() onlyStronghands public {
182         // setup data
183         address _customerAddress = msg.sender;
184         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
185 
186         // update dividend tracker
187         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
188 
189         // add ref. bonus
190         _dividends += referralBalance_[_customerAddress];
191         referralBalance_[_customerAddress] = 0;
192 
193         // lambo delivery service
194         _customerAddress.transfer(_dividends);
195 
196         // fire event
197         onWithdraw(_customerAddress, _dividends);
198     }
199 
200     /// @dev Liquifies tokens to ethereum.
201     function sell(uint256 _amountOfTokens) onlyBagholders public {
202         // setup data
203         address _customerAddress = msg.sender;
204         // russian hackers BTFO
205         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
206         uint256 _tokens = _amountOfTokens;
207         uint256 _ethereum = tokensToEthereum_(_tokens);
208         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
209         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
210 
211         // burn the sold tokens
212         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
213         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
214 
215         // update dividends tracker
216         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
217         payoutsTo_[_customerAddress] -= _updatedPayouts;
218 
219         // dividing by zero is a bad idea
220         if (tokenSupply_ > 0) {
221             // update the amount of dividends per token
222             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
223         }
224 
225         // fire event
226         onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
227     }
228 
229 
230     /**
231      * @dev Transfer tokens from the caller to a new holder.
232      *  Remember, there's a 15% fee here as well.
233      */
234     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
235         // setup
236         address _customerAddress = msg.sender;
237 
238         // make sure we have the requested tokens
239         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
240 
241         // withdraw all outstanding dividends first
242         if (myDividends(true) > 0) {
243             withdraw();
244         }
245 
246         // liquify 10% of the tokens that are transfered
247         // these are dispersed to shareholders
248         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
249         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
250         uint256 _dividends = tokensToEthereum_(_tokenFee);
251 
252         // burn the fee tokens
253         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
254 
255         // exchange tokens
256         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
257         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
258 
259         // update dividend trackers
260         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
261         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
262 
263         // disperse dividends among holders
264         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
265 
266         // fire event
267         Transfer(_customerAddress, _toAddress, _taxedTokens);
268 
269         // ERC20
270         return true;
271     }
272 
273 
274     /*=====================================
275     =      HELPERS AND CALCULATORS        =
276     =====================================*/
277 
278     /**
279      * @dev Method to view the current Ethereum stored in the contract
280      *  Example: totalEthereumBalance()
281      */
282     function totalEthereumBalance() public view returns (uint256) {
283         return this.balance;
284     }
285 
286     /// @dev Retrieve the total token supply.
287     function totalSupply() public view returns (uint256) {
288         return tokenSupply_;
289     }
290 
291     /// @dev Retrieve the tokens owned by the caller.
292     function myTokens() public view returns (uint256) {
293         address _customerAddress = msg.sender;
294         return balanceOf(_customerAddress);
295     }
296 
297     /**
298      * @dev Retrieve the dividends owned by the caller.
299      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
300      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
301      *  But in the internal calculations, we want them separate.
302      */
303     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
304         address _customerAddress = msg.sender;
305         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
306     }
307 
308     /// @dev Retrieve the token balance of any single address.
309     function balanceOf(address _customerAddress) public view returns (uint256) {
310         return tokenBalanceLedger_[_customerAddress];
311     }
312 
313     /// @dev Retrieve the dividend balance of any single address.
314     function dividendsOf(address _customerAddress) public view returns (uint256) {
315         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
316     }
317 
318     /// @dev Return the sell price of 1 individual token.
319     function sellPrice() public view returns (uint256) {
320         // our calculation relies on the token supply, so we need supply. Doh.
321         if (tokenSupply_ == 0) {
322             return tokenPriceInitial_ - tokenPriceIncremental_;
323         } else {
324             uint256 _ethereum = tokensToEthereum_(1e18);
325             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
326             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
327 
328             return _taxedEthereum;
329         }
330     }
331 
332     /// @dev Return the buy price of 1 individual token.
333     function buyPrice() public view returns (uint256) {
334         // our calculation relies on the token supply, so we need supply. Doh.
335         if (tokenSupply_ == 0) {
336             return tokenPriceInitial_ + tokenPriceIncremental_;
337         } else {
338             uint256 _ethereum = tokensToEthereum_(1e18);
339             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
340             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
341 
342             return _taxedEthereum;
343         }
344     }
345 
346     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
347     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
348         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
349         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
350         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
351 
352         return _amountOfTokens;
353     }
354 
355     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
356     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
357         require(_tokensToSell <= tokenSupply_);
358         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
359         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
360         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
361         return _taxedEthereum;
362     }
363 
364 
365     /*==========================================
366     =            INTERNAL FUNCTIONS            =
367     ==========================================*/
368 
369     /// @dev Internal function to actually purchase the tokens.
370     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
371         // data setup
372         address _customerAddress = msg.sender;
373         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
374         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
375         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
376         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
377         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
378         uint256 _fee = _dividends * magnitude;
379 
380         // no point in continuing execution if OP is a poorfag russian hacker
381         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
382         // (or hackers)
383         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
384         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
385 
386         // is the user referred by a masternode?
387         if (
388             // is this a referred purchase?
389             _referredBy != 0x0000000000000000000000000000000000000000 &&
390 
391             // no cheating!
392             _referredBy != _customerAddress &&
393 
394             // does the referrer have at least X whole tokens?
395             // i.e is the referrer a godly chad masternode
396             tokenBalanceLedger_[_referredBy] >= stakingRequirement
397         ) {
398             // wealth redistribution
399             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
400         } else {
401             // no ref purchase
402             // add the referral bonus back to the global dividends cake
403             _dividends = SafeMath.add(_dividends, _referralBonus);
404             _fee = _dividends * magnitude;
405         }
406 
407         // we can't give people infinite ethereum
408         if (tokenSupply_ > 0) {
409             // add tokens to the pool
410             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
411 
412             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
413             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
414 
415             // calculate the amount of tokens the customer receives over his purchase
416             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
417         } else {
418             // add tokens to the pool
419             tokenSupply_ = _amountOfTokens;
420         }
421 
422         // update circulating supply & the ledger address for the customer
423         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
424 
425         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
426         // really i know you think you do but you don't
427         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
428         payoutsTo_[_customerAddress] += _updatedPayouts;
429 
430         // fire event
431         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
432 
433         return _amountOfTokens;
434     }
435 
436     /**
437      * @dev Calculate Token price based on an amount of incoming ethereum
438      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
439      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
440      */
441     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
442         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
443         uint256 _tokensReceived =
444          (
445             (
446                 // underflow attempts BTFO
447                 SafeMath.sub(
448                     (sqrt
449                         (
450                             (_tokenPriceInitial ** 2)
451                             +
452                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
453                             +
454                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
455                             +
456                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
457                         )
458                     ), _tokenPriceInitial
459                 )
460             ) / (tokenPriceIncremental_)
461         ) - (tokenSupply_);
462 
463         return _tokensReceived;
464     }
465 
466     /**
467      * @dev Calculate token sell value.
468      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
469      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
470      */
471     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
472         uint256 tokens_ = (_tokens + 1e18);
473         uint256 _tokenSupply = (tokenSupply_ + 1e18);
474         uint256 _etherReceived =
475         (
476             // underflow attempts BTFO
477             SafeMath.sub(
478                 (
479                     (
480                         (
481                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
482                         ) - tokenPriceIncremental_
483                     ) * (tokens_ - 1e18)
484                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
485             )
486         / 1e18);
487 
488         return _etherReceived;
489     }
490 
491     /// @dev This is where all your gas goes.
492     function sqrt(uint256 x) internal pure returns (uint256 y) {
493         uint256 z = (x + 1) / 2;
494         y = x;
495 
496         while (z < y) {
497             y = z;
498             z = (x / z + z) / 2;
499         }
500     }
501 
502 
503 }
504 
505 /**
506  * @title SafeMath
507  * @dev Math operations with safety checks that throw on error
508  */
509 library SafeMath {
510 
511     /**
512     * @dev Multiplies two numbers, throws on overflow.
513     */
514     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
515         if (a == 0) {
516             return 0;
517         }
518         uint256 c = a * b;
519         assert(c / a == b);
520         return c;
521     }
522 
523     /**
524     * @dev Integer division of two numbers, truncating the quotient.
525     */
526     function div(uint256 a, uint256 b) internal pure returns (uint256) {
527         // assert(b > 0); // Solidity automatically throws when dividing by 0
528         uint256 c = a / b;
529         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
530         return c;
531     }
532 
533     /**
534     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
535     */
536     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
537         assert(b <= a);
538         return a - b;
539     }
540 
541     /**
542     * @dev Adds two numbers, throws on overflow.
543     */
544     function add(uint256 a, uint256 b) internal pure returns (uint256) {
545         uint256 c = a + b;
546         assert(c >= a);
547         return c;
548     }
549 
550 }