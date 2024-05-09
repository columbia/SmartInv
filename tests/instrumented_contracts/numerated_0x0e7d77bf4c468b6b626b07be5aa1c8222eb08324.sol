1 pragma solidity ^0.4.21;
2 
3 /*
4 * One Proof (Proof)
5 * https://oneproof.net
6 * 
7 * Instead of having many small "proof of" smart contracts here you can
8 * re-brand a unique website and use this same smart contract address.
9 * This would benefit all those holding because of the increased volume.
10 * 
11 * 
12 *
13 *
14 * Features:
15 * [✓] 5% rewards for token purchase, shared among all token holders.
16 * [✓] 5% rewards for token selling, shared among all token holders.
17 * [✓] 5% rewards for token transfer, shared among all token holders.
18 * [✓] 3% rewards is given to referrer which is 60% of the 5% purchase reward.
19 * [✓] Price increment by 0.000000001 instead of 0.00000001 for lower buy/sell price.
20 * [✓] 1 token to activate Masternode referrals.
21 * [✓] No Administrators or Ambassadors that can change anything with the contract.
22 *
23 */
24 
25 contract Proof {
26 
27 
28     /*=================================
29     =            MODIFIERS            =
30     =================================*/
31 
32     /// @dev Only people with tokens
33     modifier onlyBagholders {
34         require(myTokens() > 0);
35         _;
36     }
37 
38     /// @dev Only people with profits
39     modifier onlyStronghands {
40         require(myDividends(true) > 0);
41         _;
42     }
43 
44 
45     /*==============================
46     =            EVENTS            =
47     ==============================*/
48 
49     event onTokenPurchase(
50         address indexed customerAddress,
51         uint256 incomingEthereum,
52         uint256 tokensMinted,
53         address indexed referredBy,
54         uint timestamp,
55         uint256 price
56     );
57 
58     event onTokenSell(
59         address indexed customerAddress,
60         uint256 tokensBurned,
61         uint256 ethereumEarned,
62         uint timestamp,
63         uint256 price
64     );
65 
66     event onReinvestment(
67         address indexed customerAddress,
68         uint256 ethereumReinvested,
69         uint256 tokensMinted
70     );
71 
72     event onWithdraw(
73         address indexed customerAddress,
74         uint256 ethereumWithdrawn
75     );
76 
77     // ERC20
78     event Transfer(
79         address indexed from,
80         address indexed to,
81         uint256 tokens
82     );
83 
84 
85     /*=====================================
86     =            CONFIGURABLES            =
87     =====================================*/
88 
89     string public name = "One Proof";
90     string public symbol = "Proof";
91     uint8 constant public decimals = 18;
92 
93     /// @dev 5% rewards for token purchase
94     uint8 constant internal entryFee_ = 5;
95 
96     /// @dev 5% rewards for token transfer
97     uint8 constant internal transferFee_ = 5;
98 
99     /// @dev 5% rewards for token selling
100     uint8 constant internal exitFee_ = 5;
101 
102     /// @dev 60% of entryFee_ (i.e. 3% rewards) is given to referrer
103     uint8 constant internal refferalFee_ = 60;
104 
105     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
106     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
107     uint256 constant internal magnitude = 2 ** 64;
108 
109     /// @dev proof of stake just 1 token)
110     uint256 public stakingRequirement = 1e18;
111 
112 
113    /*=================================
114     =            DATASETS            =
115     ================================*/
116 
117     // amount of shares for each address (scaled number)
118     mapping(address => uint256) internal tokenBalanceLedger_;
119     mapping(address => uint256) internal referralBalance_;
120     mapping(address => int256) internal payoutsTo_;
121     uint256 internal tokenSupply_;
122     uint256 internal profitPerShare_;
123 
124 
125     /*=======================================
126     =            PUBLIC FUNCTIONS           =
127     =======================================*/
128 
129     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
130     function buy(address _referredBy) public payable returns (uint256) {
131         purchaseTokens(msg.value, _referredBy);
132     }
133 
134     /**
135      * @dev Fallback function to handle ethereum that was send straight to the contract
136      *  Unfortunately we cannot use a referral address this way.
137      */
138     function() payable public {
139         purchaseTokens(msg.value, 0x0);
140     }
141 
142     /// @dev Converts all of caller's dividends to tokens.
143     function reinvest() onlyStronghands public {
144         // fetch dividends
145         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
146 
147         // pay out the dividends virtually
148         address _customerAddress = msg.sender;
149         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
150 
151         // retrieve ref. bonus
152         _dividends += referralBalance_[_customerAddress];
153         referralBalance_[_customerAddress] = 0;
154 
155         // dispatch a buy order with the virtualized "withdrawn dividends"
156         uint256 _tokens = purchaseTokens(_dividends, 0x0);
157 
158         // fire event
159         emit onReinvestment(_customerAddress, _dividends, _tokens);
160     }
161 
162     /// @dev Alias of sell() and withdraw().
163     function exit() public {
164         // get token count for caller & sell them all
165         address _customerAddress = msg.sender;
166         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
167         if (_tokens > 0) sell(_tokens);
168 
169         // lambo delivery service
170         withdraw();
171     }
172 
173     /// @dev Withdraws all of the callers earnings.
174     function withdraw() onlyStronghands public {
175         // setup data
176         address _customerAddress = msg.sender;
177         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
178 
179         // update dividend tracker
180         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
181 
182         // add ref. bonus
183         _dividends += referralBalance_[_customerAddress];
184         referralBalance_[_customerAddress] = 0;
185 
186         // lambo delivery service
187         _customerAddress.transfer(_dividends);
188 
189         // fire event
190         emit onWithdraw(_customerAddress, _dividends);
191     }
192 
193     /// @dev Liquifies tokens to ethereum.
194     function sell(uint256 _amountOfTokens) onlyBagholders public {
195         // setup data
196         address _customerAddress = msg.sender;
197         // 
198         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
199         uint256 _tokens = _amountOfTokens;
200         uint256 _ethereum = tokensToEthereum_(_tokens);
201         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
202         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
203 
204         // burn the sold tokens
205         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
206         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
207 
208         // update rewards tracker
209         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
210         payoutsTo_[_customerAddress] -= _updatedPayouts;
211 
212         // dividing by zero is a bad idea
213         if (tokenSupply_ > 0) {
214             // update the amount of dividends per token
215             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
216         }
217 
218         // fire event
219         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
220     }
221 
222 
223     /**
224      * @dev Transfer tokens from the caller to a new holder.
225      *  Remember, there's a 15% fee here as well.
226      */
227     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
228         // setup
229         address _customerAddress = msg.sender;
230 
231         // make sure we have the requested tokens
232         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
233 
234         // withdraw all outstanding dividends first
235         if (myDividends(true) > 0) {
236             withdraw();
237         }
238 
239         // liquify 10% of the tokens that are transfered
240         // these are dispersed to shareholders
241         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
242         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
243         uint256 _dividends = tokensToEthereum_(_tokenFee);
244 
245         // burn the fee tokens
246         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
247 
248         // exchange tokens
249         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
250         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
251 
252         // update dividend trackers
253         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
254         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
255 
256         // disperse dividends among holders
257         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
258 
259         // fire event
260         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
261 
262         // ERC20
263         return true;
264     }
265 
266 
267     /*=====================================
268     =      HELPERS AND CALCULATORS        =
269     =====================================*/
270 
271     /**
272      * @dev Method to view the current Ethereum stored in the contract
273      *  Example: totalEthereumBalance()
274      */
275     function totalEthereumBalance() public view returns (uint256) {
276         return address(this).balance;
277     }
278 
279     /// @dev Retrieve the total token supply.
280     function totalSupply() public view returns (uint256) {
281         return tokenSupply_;
282     }
283 
284     /// @dev Retrieve the tokens owned by the caller.
285     function myTokens() public view returns (uint256) {
286         address _customerAddress = msg.sender;
287         return balanceOf(_customerAddress);
288     }
289 
290     /**
291      * @dev Retrieve the dividends owned by the caller.
292      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
293      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
294      *  But in the internal calculations, we want them separate.
295      */
296     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
297         address _customerAddress = msg.sender;
298         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
299     }
300 
301     /// @dev Retrieve the token balance of any single address.
302     function balanceOf(address _customerAddress) public view returns (uint256) {
303         return tokenBalanceLedger_[_customerAddress];
304     }
305 
306     /// @dev Retrieve the dividend balance of any single address.
307     function dividendsOf(address _customerAddress) public view returns (uint256) {
308         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
309     }
310 
311     /// @dev Return the sell price of 1 individual token.
312     function sellPrice() public view returns (uint256) {
313         // our calculation relies on the token supply, so we need supply. Doh.
314         if (tokenSupply_ == 0) {
315             return tokenPriceInitial_ - tokenPriceIncremental_;
316         } else {
317             uint256 _ethereum = tokensToEthereum_(1e18);
318             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
319             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
320 
321             return _taxedEthereum;
322         }
323     }
324 
325     /// @dev Return the buy price of 1 individual token.
326     function buyPrice() public view returns (uint256) {
327         // our calculation relies on the token supply, so we need supply. Doh.
328         if (tokenSupply_ == 0) {
329             return tokenPriceInitial_ + tokenPriceIncremental_;
330         } else {
331             uint256 _ethereum = tokensToEthereum_(1e18);
332             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
333             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
334 
335             return _taxedEthereum;
336         }
337     }
338 
339     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
340     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
341         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
342         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
343         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
344 
345         return _amountOfTokens;
346     }
347 
348     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
349     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
350         require(_tokensToSell <= tokenSupply_);
351         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
352         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
353         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
354         return _taxedEthereum;
355     }
356 
357 
358     /*==========================================
359     =            INTERNAL FUNCTIONS            =
360     ==========================================*/
361 
362     /// @dev Internal function to actually purchase the tokens.
363     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
364         // data setup
365         address _customerAddress = msg.sender;
366         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
367         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
368         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
369         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
370         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
371         uint256 _fee = _dividends * magnitude;
372 
373         // no point in continuing execution if OP is a poorfag russian hacker
374         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
375         // (or hackers)
376         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
377         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
378 
379         // is the user referred by a masternode?
380         if (
381             // is this a referred purchase?
382             _referredBy != 0x0000000000000000000000000000000000000000 &&
383 
384             // no cheating!
385             _referredBy != _customerAddress &&
386 
387             // does the referrer have at least X whole tokens?
388             // i.e is the referrer a godly chad masternode
389             tokenBalanceLedger_[_referredBy] >= stakingRequirement
390         ) {
391             // wealth redistribution
392             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
393         } else {
394             // no ref purchase
395             // add the referral bonus back to the global dividends cake
396             _dividends = SafeMath.add(_dividends, _referralBonus);
397             _fee = _dividends * magnitude;
398         }
399 
400         // we can't give people infinite ethereum
401         if (tokenSupply_ > 0) {
402             // add tokens to the pool
403             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
404 
405             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
406             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
407 
408             // calculate the amount of tokens the customer receives over his purchase
409             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
410         } else {
411             // add tokens to the pool
412             tokenSupply_ = _amountOfTokens;
413         }
414 
415         // update circulating supply & the ledger address for the customer
416         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
417 
418         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
419         // really i know you think you do but you don't
420         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
421         payoutsTo_[_customerAddress] += _updatedPayouts;
422 
423         // fire event
424         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
425 
426         return _amountOfTokens;
427     }
428 
429     /**
430      * @dev Calculate Token price based on an amount of incoming ethereum
431      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
432      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
433      */
434     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
435         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
436         uint256 _tokensReceived =
437          (
438             (
439                 // underflow attempts BTFO
440                 SafeMath.sub(
441                     (sqrt
442                         (
443                             (_tokenPriceInitial ** 2)
444                             +
445                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
446                             +
447                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
448                             +
449                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
450                         )
451                     ), _tokenPriceInitial
452                 )
453             ) / (tokenPriceIncremental_)
454         ) - (tokenSupply_);
455 
456         return _tokensReceived;
457     }
458 
459     /**
460      * @dev Calculate token sell value.
461      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
462      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
463      */
464     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
465         uint256 tokens_ = (_tokens + 1e18);
466         uint256 _tokenSupply = (tokenSupply_ + 1e18);
467         uint256 _etherReceived =
468         (
469             // underflow attempts BTFO
470             SafeMath.sub(
471                 (
472                     (
473                         (
474                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
475                         ) - tokenPriceIncremental_
476                     ) * (tokens_ - 1e18)
477                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
478             )
479         / 1e18);
480 
481         return _etherReceived;
482     }
483 
484     /// @dev This is where all your gas goes.
485     function sqrt(uint256 x) internal pure returns (uint256 y) {
486         uint256 z = (x + 1) / 2;
487         y = x;
488 
489         while (z < y) {
490             y = z;
491             z = (x / z + z) / 2;
492         }
493     }
494 
495 
496 }
497 
498 /**
499  * @title SafeMath
500  * @dev Math operations with safety checks that throw on error
501  */
502 library SafeMath {
503 
504     /**
505     * @dev Multiplies two numbers, throws on overflow.
506     */
507     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
508         if (a == 0) {
509             return 0;
510         }
511         uint256 c = a * b;
512         assert(c / a == b);
513         return c;
514     }
515 
516     /**
517     * @dev Integer division of two numbers, truncating the quotient.
518     */
519     function div(uint256 a, uint256 b) internal pure returns (uint256) {
520         // assert(b > 0); // Solidity automatically throws when dividing by 0
521         uint256 c = a / b;
522         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
523         return c;
524     }
525 
526     /**
527     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
528     */
529     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
530         assert(b <= a);
531         return a - b;
532     }
533 
534     /**
535     * @dev Adds two numbers, throws on overflow.
536     */
537     function add(uint256 a, uint256 b) internal pure returns (uint256) {
538         uint256 c = a + b;
539         assert(c >= a);
540         return c;
541     }
542 
543 }