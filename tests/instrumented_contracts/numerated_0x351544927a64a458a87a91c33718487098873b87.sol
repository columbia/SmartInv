1 pragma solidity ^0.4.20;
2 
3 /*
4 * We Present To You....
5 * https://pomn.co/
6 * https://discord.gg/pGVTD5h
7 * 
8 * 
9 *
10 * Proof of Masternode
11 * Earn 15% of the total purchase each time someone uses your Masternode!
12 *
13 * -> What?
14 * Incorporated the strong points of different POW{x}, best config:
15 * [✓] 20% rewards for token purchase, shared among all token holders.
16 * [✓] 10% rewards for token transfer, shared among all token holders.
17 * [✓] 25% rewards for token selling.
18 * [✓] 15% of the total purchase each time someone uses your Masternode.
19 * [✓] 50 tokens to activate Masternodes.
20 *
21 */
22 
23 contract PoMN {
24 
25 
26     /*=================================
27     =            MODIFIERS            =
28     =================================*/
29 
30     /// @dev Only people with tokens
31     modifier onlyBagholders {
32         require(myTokens() > 0);
33         _;
34     }
35 
36     /// @dev Only people with profits
37     modifier onlyStronghands {
38         require(myDividends(true) > 0);
39         _;
40     }
41 
42 
43     /*==============================
44     =            EVENTS            =
45     ==============================*/
46 
47     event onTokenPurchase(
48         address indexed customerAddress,
49         uint256 incomingEthereum,
50         uint256 tokensMinted,
51         address indexed referredBy,
52         uint timestamp,
53         uint256 price
54     );
55 
56     event onTokenSell(
57         address indexed customerAddress,
58         uint256 tokensBurned,
59         uint256 ethereumEarned,
60         uint timestamp,
61         uint256 price
62     );
63 
64     event onReinvestment(
65         address indexed customerAddress,
66         uint256 ethereumReinvested,
67         uint256 tokensMinted
68     );
69 
70     event onWithdraw(
71         address indexed customerAddress,
72         uint256 ethereumWithdrawn
73     );
74 
75     // ERC20
76     event Transfer(
77         address indexed from,
78         address indexed to,
79         uint256 tokens
80     );
81 
82 
83     /*=====================================
84     =            CONFIGURABLES            =
85     =====================================*/
86 
87     string public name = "Proof of Masternode";
88     string public symbol = "PoMN";
89     uint8 constant public decimals = 18;
90 
91     /// @dev 20% dividends for token purchase
92     uint8 constant internal entryFee_ = 20;
93 
94     /// @dev 10% dividends for token transfer
95     uint8 constant internal transferFee_ = 10;
96 
97     /// @dev 25% dividends for token selling
98     uint8 constant internal exitFee_ = 25;
99 
100     /// @dev 75% of entryFee_ (i.e. 15% dividends) is given to referrer
101     uint8 constant internal refferalFee_ = 75;
102 
103     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
104     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
105     uint256 constant internal magnitude = 2 ** 64;
106 
107     /// @dev proof of stake (defaults at 50 tokens)
108     uint256 public stakingRequirement = 50e18;
109 
110 
111    /*=================================
112     =            DATASETS            =
113     ================================*/
114 
115     // amount of shares for each address (scaled number)
116     mapping(address => uint256) internal tokenBalanceLedger_;
117     mapping(address => uint256) internal referralBalance_;
118     mapping(address => int256) internal payoutsTo_;
119     uint256 internal tokenSupply_;
120     uint256 internal profitPerShare_;
121 
122 
123     /*=======================================
124     =            PUBLIC FUNCTIONS           =
125     =======================================*/
126 
127     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
128     function buy(address _referredBy) public payable returns (uint256) {
129         purchaseTokens(msg.value, _referredBy);
130     }
131 
132     /**
133      * @dev Fallback function to handle ethereum that was send straight to the contract
134      *  Unfortunately we cannot use a referral address this way.
135      */
136     function() payable public {
137         purchaseTokens(msg.value, 0x0);
138     }
139 
140     /// @dev Converts all of caller's dividends to tokens.
141     function reinvest() onlyStronghands public {
142         // fetch dividends
143         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
144 
145         // pay out the dividends virtually
146         address _customerAddress = msg.sender;
147         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
148 
149         // retrieve ref. bonus
150         _dividends += referralBalance_[_customerAddress];
151         referralBalance_[_customerAddress] = 0;
152 
153         // dispatch a buy order with the virtualized "withdrawn dividends"
154         uint256 _tokens = purchaseTokens(_dividends, 0x0);
155 
156         // fire event
157         onReinvestment(_customerAddress, _dividends, _tokens);
158     }
159 
160     /// @dev Alias of sell() and withdraw().
161     function exit() public {
162         // get token count for caller & sell them all
163         address _customerAddress = msg.sender;
164         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
165         if (_tokens > 0) sell(_tokens);
166 
167         // lambo delivery service
168         withdraw();
169     }
170 
171     /// @dev Withdraws all of the callers earnings.
172     function withdraw() onlyStronghands public {
173         // setup data
174         address _customerAddress = msg.sender;
175         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
176 
177         // update dividend tracker
178         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
179 
180         // add ref. bonus
181         _dividends += referralBalance_[_customerAddress];
182         referralBalance_[_customerAddress] = 0;
183 
184         // lambo delivery service
185         _customerAddress.transfer(_dividends);
186 
187         // fire event
188         onWithdraw(_customerAddress, _dividends);
189     }
190 
191     /// @dev Liquifies tokens to ethereum.
192     function sell(uint256 _amountOfTokens) onlyBagholders public {
193         // setup data
194         address _customerAddress = msg.sender;
195         // russian hackers BTFO
196         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
197         uint256 _tokens = _amountOfTokens;
198         uint256 _ethereum = tokensToEthereum_(_tokens);
199         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
200         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
201 
202         // burn the sold tokens
203         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
204         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
205 
206         // update dividends tracker
207         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
208         payoutsTo_[_customerAddress] -= _updatedPayouts;
209 
210         // dividing by zero is a bad idea
211         if (tokenSupply_ > 0) {
212             // update the amount of dividends per token
213             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
214         }
215 
216         // fire event
217         onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
218     }
219 
220 
221     /**
222      * @dev Transfer tokens from the caller to a new holder.
223      *  Remember, there's a 15% fee here as well.
224      */
225     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
226         // setup
227         address _customerAddress = msg.sender;
228 
229         // make sure we have the requested tokens
230         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
231 
232         // withdraw all outstanding dividends first
233         if (myDividends(true) > 0) {
234             withdraw();
235         }
236 
237         // liquify 10% of the tokens that are transfered
238         // these are dispersed to shareholders
239         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
240         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
241         uint256 _dividends = tokensToEthereum_(_tokenFee);
242 
243         // burn the fee tokens
244         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
245 
246         // exchange tokens
247         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
248         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
249 
250         // update dividend trackers
251         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
252         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
253 
254         // disperse dividends among holders
255         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
256 
257         // fire event
258         Transfer(_customerAddress, _toAddress, _taxedTokens);
259 
260         // ERC20
261         return true;
262     }
263 
264 
265     /*=====================================
266     =      HELPERS AND CALCULATORS        =
267     =====================================*/
268 
269     /**
270      * @dev Method to view the current Ethereum stored in the contract
271      *  Example: totalEthereumBalance()
272      */
273     function totalEthereumBalance() public view returns (uint256) {
274         return this.balance;
275     }
276 
277     /// @dev Retrieve the total token supply.
278     function totalSupply() public view returns (uint256) {
279         return tokenSupply_;
280     }
281 
282     /// @dev Retrieve the tokens owned by the caller.
283     function myTokens() public view returns (uint256) {
284         address _customerAddress = msg.sender;
285         return balanceOf(_customerAddress);
286     }
287 
288     /**
289      * @dev Retrieve the dividends owned by the caller.
290      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
291      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
292      *  But in the internal calculations, we want them separate.
293      */
294     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
295         address _customerAddress = msg.sender;
296         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
297     }
298 
299     /// @dev Retrieve the token balance of any single address.
300     function balanceOf(address _customerAddress) public view returns (uint256) {
301         return tokenBalanceLedger_[_customerAddress];
302     }
303 
304     /// @dev Retrieve the dividend balance of any single address.
305     function dividendsOf(address _customerAddress) public view returns (uint256) {
306         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
307     }
308 
309     /// @dev Return the sell price of 1 individual token.
310     function sellPrice() public view returns (uint256) {
311         // our calculation relies on the token supply, so we need supply. Doh.
312         if (tokenSupply_ == 0) {
313             return tokenPriceInitial_ - tokenPriceIncremental_;
314         } else {
315             uint256 _ethereum = tokensToEthereum_(1e18);
316             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
317             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
318 
319             return _taxedEthereum;
320         }
321     }
322 
323     /// @dev Return the buy price of 1 individual token.
324     function buyPrice() public view returns (uint256) {
325         // our calculation relies on the token supply, so we need supply. Doh.
326         if (tokenSupply_ == 0) {
327             return tokenPriceInitial_ + tokenPriceIncremental_;
328         } else {
329             uint256 _ethereum = tokensToEthereum_(1e18);
330             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
331             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
332 
333             return _taxedEthereum;
334         }
335     }
336 
337     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
338     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
339         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
340         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
341         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
342 
343         return _amountOfTokens;
344     }
345 
346     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
347     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
348         require(_tokensToSell <= tokenSupply_);
349         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
350         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
351         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
352         return _taxedEthereum;
353     }
354 
355 
356     /*==========================================
357     =            INTERNAL FUNCTIONS            =
358     ==========================================*/
359 
360     /// @dev Internal function to actually purchase the tokens.
361     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
362         // data setup
363         address _customerAddress = msg.sender;
364         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
365         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
366         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
367         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
368         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
369         uint256 _fee = _dividends * magnitude;
370 
371         // no point in continuing execution if OP is a poorfag russian hacker
372         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
373         // (or hackers)
374         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
375         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
376 
377         // is the user referred by a masternode?
378         if (
379             // is this a referred purchase?
380             _referredBy != 0x0000000000000000000000000000000000000000 &&
381 
382             // no cheating!
383             _referredBy != _customerAddress &&
384 
385             // does the referrer have at least X whole tokens?
386             // i.e is the referrer a godly chad masternode
387             tokenBalanceLedger_[_referredBy] >= stakingRequirement
388         ) {
389             // wealth redistribution
390             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
391         } else {
392             // no ref purchase
393             // add the referral bonus back to the global dividends cake
394             _dividends = SafeMath.add(_dividends, _referralBonus);
395             _fee = _dividends * magnitude;
396         }
397 
398         // we can't give people infinite ethereum
399         if (tokenSupply_ > 0) {
400             // add tokens to the pool
401             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
402 
403             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
404             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
405 
406             // calculate the amount of tokens the customer receives over his purchase
407             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
408         } else {
409             // add tokens to the pool
410             tokenSupply_ = _amountOfTokens;
411         }
412 
413         // update circulating supply & the ledger address for the customer
414         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
415 
416         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
417         // really i know you think you do but you don't
418         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
419         payoutsTo_[_customerAddress] += _updatedPayouts;
420 
421         // fire event
422         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
423 
424         return _amountOfTokens;
425     }
426 
427     /**
428      * @dev Calculate Token price based on an amount of incoming ethereum
429      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
430      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
431      */
432     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
433         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
434         uint256 _tokensReceived =
435          (
436             (
437                 // underflow attempts BTFO
438                 SafeMath.sub(
439                     (sqrt
440                         (
441                             (_tokenPriceInitial ** 2)
442                             +
443                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
444                             +
445                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
446                             +
447                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
448                         )
449                     ), _tokenPriceInitial
450                 )
451             ) / (tokenPriceIncremental_)
452         ) - (tokenSupply_);
453 
454         return _tokensReceived;
455     }
456 
457     /**
458      * @dev Calculate token sell value.
459      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
460      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
461      */
462     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
463         uint256 tokens_ = (_tokens + 1e18);
464         uint256 _tokenSupply = (tokenSupply_ + 1e18);
465         uint256 _etherReceived =
466         (
467             // underflow attempts BTFO
468             SafeMath.sub(
469                 (
470                     (
471                         (
472                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
473                         ) - tokenPriceIncremental_
474                     ) * (tokens_ - 1e18)
475                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
476             )
477         / 1e18);
478 
479         return _etherReceived;
480     }
481 
482     /// @dev This is where all your gas goes.
483     function sqrt(uint256 x) internal pure returns (uint256 y) {
484         uint256 z = (x + 1) / 2;
485         y = x;
486 
487         while (z < y) {
488             y = z;
489             z = (x / z + z) / 2;
490         }
491     }
492 
493 
494 }
495 
496 /**
497  * @title SafeMath
498  * @dev Math operations with safety checks that throw on error
499  */
500 library SafeMath {
501 
502     /**
503     * @dev Multiplies two numbers, throws on overflow.
504     */
505     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
506         if (a == 0) {
507             return 0;
508         }
509         uint256 c = a * b;
510         assert(c / a == b);
511         return c;
512     }
513 
514     /**
515     * @dev Integer division of two numbers, truncating the quotient.
516     */
517     function div(uint256 a, uint256 b) internal pure returns (uint256) {
518         // assert(b > 0); // Solidity automatically throws when dividing by 0
519         uint256 c = a / b;
520         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
521         return c;
522     }
523 
524     /**
525     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
526     */
527     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
528         assert(b <= a);
529         return a - b;
530     }
531 
532     /**
533     * @dev Adds two numbers, throws on overflow.
534     */
535     function add(uint256 a, uint256 b) internal pure returns (uint256) {
536         uint256 c = a + b;
537         assert(c >= a);
538         return c;
539     }
540 
541 }