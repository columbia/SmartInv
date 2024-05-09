1 pragma solidity ^0.4.20;
2 
3 /*
4 
5 * -> What?
6 * Incorporated the strong points of different POW{x}, best config:
7 * [✓] 20% dividends for token purchase, shared among all token holders.
8 * [✓] 10% dividends for token transfer, shared among all token holders.
9 * [✓] 25% dividends for token selling.
10 * [✓] 7% dividends is given to referrer.
11 * [✓] 50 tokens to activate Masternodes.
12 *
13 */
14 
15 contract EtherDiamond {
16 
17 
18     /*=================================
19     =            MODIFIERS            =
20     =================================*/
21 
22     /// @dev Only people with tokens
23     modifier onlyBagholders {
24         require(myTokens() > 0);
25         _;
26     }
27 
28     /// @dev Only people with profits
29     modifier onlyStronghands {
30         require(myDividends(true) > 0);
31         _;
32     }
33 
34 
35     /*==============================
36     =            EVENTS            =
37     ==============================*/
38 
39     event onTokenPurchase(
40         address indexed customerAddress,
41         uint256 incomingEthereum,
42         uint256 tokensMinted,
43         address indexed referredBy,
44         uint timestamp,
45         uint256 price
46     );
47 
48     event onTokenSell(
49         address indexed customerAddress,
50         uint256 tokensBurned,
51         uint256 ethereumEarned,
52         uint timestamp,
53         uint256 price
54     );
55 
56     event onReinvestment(
57         address indexed customerAddress,
58         uint256 ethereumReinvested,
59         uint256 tokensMinted
60     );
61 
62     event onWithdraw(
63         address indexed customerAddress,
64         uint256 ethereumWithdrawn
65     );
66 
67     // ERC20
68     event Transfer(
69         address indexed from,
70         address indexed to,
71         uint256 tokens
72     );
73 
74 
75     /*=====================================
76     =            CONFIGURABLES            =
77     =====================================*/
78 
79     string public name = "Ether Diamond";
80     string public symbol = "ETHD";
81     uint8 constant public decimals = 18;
82 
83     /// @dev 20% dividends for token purchase
84     uint8 constant internal entryFee_ = 20;
85 
86     /// @dev 10% dividends for token transfer
87     uint8 constant internal transferFee_ = 10;
88 
89     /// @dev 25% dividends for token selling
90     uint8 constant internal exitFee_ = 25;
91 
92     /// @dev 35% of entryFee_ (i.e. 7% dividends) is given to referrer
93     uint8 constant internal refferalFee_ = 35;
94 
95     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
96     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
97     uint256 constant internal magnitude = 2 ** 64;
98 
99     /// @dev proof of stake (defaults at 50 tokens)
100     uint256 public stakingRequirement = 50e18;
101 
102 
103    /*=================================
104     =            DATASETS            =
105     ================================*/
106 
107     // amount of shares for each address (scaled number)
108     mapping(address => uint256) internal tokenBalanceLedger_;
109     mapping(address => uint256) internal referralBalance_;
110     mapping(address => int256) internal payoutsTo_;
111     uint256 internal tokenSupply_;
112     uint256 internal profitPerShare_;
113 
114 
115     /*=======================================
116     =            PUBLIC FUNCTIONS           =
117     =======================================*/
118 
119     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
120     function buy(address _referredBy) public payable returns (uint256) {
121         purchaseTokens(msg.value, _referredBy);
122     }
123 
124     /**
125      * @dev Fallback function to handle ethereum that was send straight to the contract
126      *  Unfortunately we cannot use a referral address this way.
127      */
128     function() payable public {
129         purchaseTokens(msg.value, 0x0);
130     }
131 
132     /// @dev Converts all of caller's dividends to tokens.
133     function reinvest() onlyStronghands public {
134         // fetch dividends
135         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
136 
137         // pay out the dividends virtually
138         address _customerAddress = msg.sender;
139         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
140 
141         // retrieve ref. bonus
142         _dividends += referralBalance_[_customerAddress];
143         referralBalance_[_customerAddress] = 0;
144 
145         // dispatch a buy order with the virtualized "withdrawn dividends"
146         uint256 _tokens = purchaseTokens(_dividends, 0x0);
147 
148         // fire event
149         onReinvestment(_customerAddress, _dividends, _tokens);
150     }
151 
152     /// @dev Alias of sell() and withdraw().
153     function exit() public {
154         // get token count for caller & sell them all
155         address _customerAddress = msg.sender;
156         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
157         if (_tokens > 0) sell(_tokens);
158 
159         // lambo delivery service
160         withdraw();
161     }
162 
163     /// @dev Withdraws all of the callers earnings.
164     function withdraw() onlyStronghands public {
165         // setup data
166         address _customerAddress = msg.sender;
167         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
168 
169         // update dividend tracker
170         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
171 
172         // add ref. bonus
173         _dividends += referralBalance_[_customerAddress];
174         referralBalance_[_customerAddress] = 0;
175 
176         // lambo delivery service
177         _customerAddress.transfer(_dividends);
178 
179         // fire event
180         onWithdraw(_customerAddress, _dividends);
181     }
182 
183     /// @dev Liquifies tokens to ethereum.
184     function sell(uint256 _amountOfTokens) onlyBagholders public {
185         // setup data
186         address _customerAddress = msg.sender;
187         // russian hackers BTFO
188         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
189         uint256 _tokens = _amountOfTokens;
190         uint256 _ethereum = tokensToEthereum_(_tokens);
191         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
192         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
193 
194         // burn the sold tokens
195         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
196         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
197 
198         // update dividends tracker
199         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
200         payoutsTo_[_customerAddress] -= _updatedPayouts;
201 
202         // dividing by zero is a bad idea
203         if (tokenSupply_ > 0) {
204             // update the amount of dividends per token
205             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
206         }
207 
208         // fire event
209         onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
210     }
211 
212 
213     /**
214      * @dev Transfer tokens from the caller to a new holder.
215      *  Remember, there's a 15% fee here as well.
216      */
217     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
218         // setup
219         address _customerAddress = msg.sender;
220 
221         // make sure we have the requested tokens
222         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
223 
224         // withdraw all outstanding dividends first
225         if (myDividends(true) > 0) {
226             withdraw();
227         }
228 
229         // liquify 10% of the tokens that are transfered
230         // these are dispersed to shareholders
231         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
232         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
233         uint256 _dividends = tokensToEthereum_(_tokenFee);
234 
235         // burn the fee tokens
236         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
237 
238         // exchange tokens
239         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
240         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
241 
242         // update dividend trackers
243         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
244         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
245 
246         // disperse dividends among holders
247         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
248 
249         // fire event
250         Transfer(_customerAddress, _toAddress, _taxedTokens);
251 
252         // ERC20
253         return true;
254     }
255 
256 
257     /*=====================================
258     =      HELPERS AND CALCULATORS        =
259     =====================================*/
260 
261     /**
262      * @dev Method to view the current Ethereum stored in the contract
263      *  Example: totalEthereumBalance()
264      */
265     function totalEthereumBalance() public view returns (uint256) {
266         return this.balance;
267     }
268 
269     /// @dev Retrieve the total token supply.
270     function totalSupply() public view returns (uint256) {
271         return tokenSupply_;
272     }
273 
274     /// @dev Retrieve the tokens owned by the caller.
275     function myTokens() public view returns (uint256) {
276         address _customerAddress = msg.sender;
277         return balanceOf(_customerAddress);
278     }
279 
280     /**
281      * @dev Retrieve the dividends owned by the caller.
282      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
283      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
284      *  But in the internal calculations, we want them separate.
285      */
286     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
287         address _customerAddress = msg.sender;
288         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
289     }
290 
291     /// @dev Retrieve the token balance of any single address.
292     function balanceOf(address _customerAddress) public view returns (uint256) {
293         return tokenBalanceLedger_[_customerAddress];
294     }
295 
296     /// @dev Retrieve the dividend balance of any single address.
297     function dividendsOf(address _customerAddress) public view returns (uint256) {
298         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
299     }
300 
301     /// @dev Return the sell price of 1 individual token.
302     function sellPrice() public view returns (uint256) {
303         // our calculation relies on the token supply, so we need supply. Doh.
304         if (tokenSupply_ == 0) {
305             return tokenPriceInitial_ - tokenPriceIncremental_;
306         } else {
307             uint256 _ethereum = tokensToEthereum_(1e18);
308             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
309             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
310 
311             return _taxedEthereum;
312         }
313     }
314 
315     /// @dev Return the buy price of 1 individual token.
316     function buyPrice() public view returns (uint256) {
317         // our calculation relies on the token supply, so we need supply. Doh.
318         if (tokenSupply_ == 0) {
319             return tokenPriceInitial_ + tokenPriceIncremental_;
320         } else {
321             uint256 _ethereum = tokensToEthereum_(1e18);
322             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
323             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
324 
325             return _taxedEthereum;
326         }
327     }
328 
329     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
330     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
331         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
332         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
333         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
334 
335         return _amountOfTokens;
336     }
337 
338     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
339     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
340         require(_tokensToSell <= tokenSupply_);
341         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
342         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
343         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
344         return _taxedEthereum;
345     }
346 
347 
348     /*==========================================
349     =            INTERNAL FUNCTIONS            =
350     ==========================================*/
351 
352     /// @dev Internal function to actually purchase the tokens.
353     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
354         // data setup
355         address _customerAddress = msg.sender;
356         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
357         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
358         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
359         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
360         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
361         uint256 _fee = _dividends * magnitude;
362 
363         // no point in continuing execution if OP is a poorfag russian hacker
364         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
365         // (or hackers)
366         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
367         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
368 
369         // is the user referred by a masternode?
370         if (
371             // is this a referred purchase?
372             _referredBy != 0x0000000000000000000000000000000000000000 &&
373 
374             // no cheating!
375             _referredBy != _customerAddress &&
376 
377             // does the referrer have at least X whole tokens?
378             // i.e is the referrer a godly chad masternode
379             tokenBalanceLedger_[_referredBy] >= stakingRequirement
380         ) {
381             // wealth redistribution
382             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
383         } else {
384             // no ref purchase
385             // add the referral bonus back to the global dividends cake
386             _dividends = SafeMath.add(_dividends, _referralBonus);
387             _fee = _dividends * magnitude;
388         }
389 
390         // we can't give people infinite ethereum
391         if (tokenSupply_ > 0) {
392             // add tokens to the pool
393             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
394 
395             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
396             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
397 
398             // calculate the amount of tokens the customer receives over his purchase
399             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
400         } else {
401             // add tokens to the pool
402             tokenSupply_ = _amountOfTokens;
403         }
404 
405         // update circulating supply & the ledger address for the customer
406         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
407 
408         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
409         // really i know you think you do but you don't
410         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
411         payoutsTo_[_customerAddress] += _updatedPayouts;
412 
413         // fire event
414         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
415 
416         return _amountOfTokens;
417     }
418 
419     /**
420      * @dev Calculate Token price based on an amount of incoming ethereum
421      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
422      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
423      */
424     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
425         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
426         uint256 _tokensReceived =
427          (
428             (
429                 // underflow attempts BTFO
430                 SafeMath.sub(
431                     (sqrt
432                         (
433                             (_tokenPriceInitial ** 2)
434                             +
435                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
436                             +
437                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
438                             +
439                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
440                         )
441                     ), _tokenPriceInitial
442                 )
443             ) / (tokenPriceIncremental_)
444         ) - (tokenSupply_);
445 
446         return _tokensReceived;
447     }
448 
449     /**
450      * @dev Calculate token sell value.
451      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
452      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
453      */
454     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
455         uint256 tokens_ = (_tokens + 1e18);
456         uint256 _tokenSupply = (tokenSupply_ + 1e18);
457         uint256 _etherReceived =
458         (
459             // underflow attempts BTFO
460             SafeMath.sub(
461                 (
462                     (
463                         (
464                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
465                         ) - tokenPriceIncremental_
466                     ) * (tokens_ - 1e18)
467                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
468             )
469         / 1e18);
470 
471         return _etherReceived;
472     }
473 
474     /// @dev This is where all your gas goes.
475     function sqrt(uint256 x) internal pure returns (uint256 y) {
476         uint256 z = (x + 1) / 2;
477         y = x;
478 
479         while (z < y) {
480             y = z;
481             z = (x / z + z) / 2;
482         }
483     }
484 
485 
486 }
487 
488 /**
489  * @title SafeMath
490  * @dev Math operations with safety checks that throw on error
491  */
492 library SafeMath {
493 
494     /**
495     * @dev Multiplies two numbers, throws on overflow.
496     */
497     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
498         if (a == 0) {
499             return 0;
500         }
501         uint256 c = a * b;
502         assert(c / a == b);
503         return c;
504     }
505 
506     /**
507     * @dev Integer division of two numbers, truncating the quotient.
508     */
509     function div(uint256 a, uint256 b) internal pure returns (uint256) {
510         // assert(b > 0); // Solidity automatically throws when dividing by 0
511         uint256 c = a / b;
512         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
513         return c;
514     }
515 
516     /**
517     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
518     */
519     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
520         assert(b <= a);
521         return a - b;
522     }
523 
524     /**
525     * @dev Adds two numbers, throws on overflow.
526     */
527     function add(uint256 a, uint256 b) internal pure returns (uint256) {
528         uint256 c = a + b;
529         assert(c >= a);
530         return c;
531     }
532 
533 }