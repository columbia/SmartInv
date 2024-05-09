1 pragma solidity ^0.4.20;
2 
3 contract SuperCardToken {
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
67     string public name = "SuperCard Token";
68     string public symbol = "    GOD";
69     uint8 constant public decimals = 18;
70 
71     /// @dev 10% dividends for token purchase
72     uint8 constant internal entryFee_ = 10;
73 
74     /// @dev 1% dividends for token transfer
75     uint8 constant internal transferFee_ = 1;
76 
77     /// @dev 10% dividends for token selling
78     uint8 constant internal exitFee_ = 10;
79 
80     /// @dev 15% masternode
81     uint8 constant internal refferalFee_ = 15;
82 
83     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
84     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
85     uint256 constant internal magnitude = 2 ** 64;
86 
87     /// @dev 250 Medaillions needed for masternode activation
88     uint256 public stakingRequirement = 250e18;
89 
90 
91    /*=================================
92     =            DATASETS            =
93     ================================*/
94 
95     // amount of shares for each address (scaled number)
96     mapping(address => uint256) internal tokenBalanceLedger_;
97     mapping(address => uint256) internal referralBalance_;
98     mapping(address => int256) internal payoutsTo_;
99     uint256 internal tokenSupply_;
100     uint256 internal profitPerShare_;
101 
102 
103     /*=======================================
104     =            PUBLIC FUNCTIONS           =
105     =======================================*/
106 
107     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
108     function buy(address _referredBy) public payable returns (uint256) {
109         purchaseTokens(msg.value, _referredBy);
110     }
111 
112     /**
113      * @dev Fallback function to handle ethereum that was send straight to the contract
114      *  Unfortunately we cannot use a referral address this way.
115      */
116     function() payable public {
117         purchaseTokens(msg.value, 0x0);
118     }
119 
120     /// @dev Converts all of caller's dividends to tokens.
121     function reinvest() onlyStronghands public {
122         // fetch dividends
123         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
124 
125         // pay out the dividends virtually
126         address _customerAddress = msg.sender;
127         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
128 
129         // retrieve ref. bonus
130         _dividends += referralBalance_[_customerAddress];
131         referralBalance_[_customerAddress] = 0;
132 
133         // dispatch a buy order with the virtualized "withdrawn dividends"
134         uint256 _tokens = purchaseTokens(_dividends, 0x0);
135 
136         // fire event
137         onReinvestment(_customerAddress, _dividends, _tokens);
138     }
139 
140     /// @dev Alias of sell() and withdraw().
141     function exit() public {
142         // get token count for caller & sell them all
143         address _customerAddress = msg.sender;
144         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
145         if (_tokens > 0) sell(_tokens);
146 
147         // lambo delivery service
148         withdraw();
149     }
150 
151     /// @dev Withdraws all of the callers earnings.
152     function withdraw() onlyStronghands public {
153         // setup data
154         address _customerAddress = msg.sender;
155         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
156 
157         // update dividend tracker
158         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
159 
160         // add ref. bonus
161         _dividends += referralBalance_[_customerAddress];
162         referralBalance_[_customerAddress] = 0;
163 
164         // lambo delivery service
165         _customerAddress.transfer(_dividends);
166 
167         // fire event
168         onWithdraw(_customerAddress, _dividends);
169     }
170 
171     /// @dev Liquifies tokens to ethereum.
172     function sell(uint256 _amountOfTokens) onlyBagholders public {
173         // setup data
174         address _customerAddress = msg.sender;
175         // russian hackers BTFO
176         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
177         uint256 _tokens = _amountOfTokens;
178         uint256 _ethereum = tokensToEthereum_(_tokens);
179         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
180         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
181 
182         // burn the sold tokens
183         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
184         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
185 
186         // update dividends tracker
187         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
188         payoutsTo_[_customerAddress] -= _updatedPayouts;
189 
190         // dividing by zero is a bad idea
191         if (tokenSupply_ > 0) {
192             // update the amount of dividends per token
193             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
194         }
195 
196         // fire event
197         onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
198     }
199 
200 
201     /**
202      * @dev Transfer tokens from the caller to a new holder.
203      *  Remember, there's a 1% fee here as well.
204      */
205     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
206         // setup
207         address _customerAddress = msg.sender;
208 
209         // make sure we have the requested tokens
210         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
211 
212         // withdraw all outstanding dividends first
213         if (myDividends(true) > 0) {
214             withdraw();
215         }
216 
217         // liquify 1% of the tokens that are transfered
218         // these are dispersed to shareholders
219         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
220         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
221         uint256 _dividends = tokensToEthereum_(_tokenFee);
222 
223         // burn the fee tokens
224         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
225 
226         // exchange tokens
227         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
228         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
229 
230         // update dividend trackers
231         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
232         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
233 
234         // disperse dividends among holders
235         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
236 
237         // fire event
238         Transfer(_customerAddress, _toAddress, _taxedTokens);
239 
240         // ERC20
241         return true;
242     }
243 
244 
245     /*=====================================
246     =      HELPERS AND CALCULATORS        =
247     =====================================*/
248 
249     /**
250      * @dev Method to view the current Ethereum stored in the contract
251      *  Example: totalEthereumBalance()
252      */
253     function totalEthereumBalance() public view returns (uint256) {
254         return this.balance;
255     }
256 
257     /// @dev Retrieve the total token supply.
258     function totalSupply() public view returns (uint256) {
259         return tokenSupply_;
260     }
261 
262     /// @dev Retrieve the tokens owned by the caller.
263     function myTokens() public view returns (uint256) {
264         address _customerAddress = msg.sender;
265         return balanceOf(_customerAddress);
266     }
267 
268     /**
269      * @dev Retrieve the dividends owned by the caller.
270      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
271      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
272      *  But in the internal calculations, we want them separate.
273      */
274     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
275         address _customerAddress = msg.sender;
276         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
277     }
278 
279     /// @dev Retrieve the token balance of any single address.
280     function balanceOf(address _customerAddress) public view returns (uint256) {
281         return tokenBalanceLedger_[_customerAddress];
282     }
283 
284     /// @dev Retrieve the dividend balance of any single address.
285     function dividendsOf(address _customerAddress) public view returns (uint256) {
286         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
287     }
288 
289     /// @dev Return the sell price of 1 individual token.
290     function sellPrice() public view returns (uint256) {
291         // our calculation relies on the token supply, so we need supply. Doh.
292         if (tokenSupply_ == 0) {
293             return tokenPriceInitial_ - tokenPriceIncremental_;
294         } else {
295             uint256 _ethereum = tokensToEthereum_(1e18);
296             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
297             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
298 
299             return _taxedEthereum;
300         }
301     }
302 
303     /// @dev Return the buy price of 1 individual token.
304     function buyPrice() public view returns (uint256) {
305         // our calculation relies on the token supply, so we need supply. Doh.
306         if (tokenSupply_ == 0) {
307             return tokenPriceInitial_ + tokenPriceIncremental_;
308         } else {
309             uint256 _ethereum = tokensToEthereum_(1e18);
310             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
311             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
312 
313             return _taxedEthereum;
314         }
315     }
316 
317     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
318     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
319         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
320         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
321         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
322 
323         return _amountOfTokens;
324     }
325 
326     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
327     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
328         require(_tokensToSell <= tokenSupply_);
329         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
330         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
331         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
332         return _taxedEthereum;
333     }
334 
335 
336     /*==========================================
337     =            INTERNAL FUNCTIONS            =
338     ==========================================*/
339 
340     /// @dev Internal function to actually purchase the tokens.
341     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
342         // data setup
343         address _customerAddress = msg.sender;
344         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
345         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
346         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
347         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
348         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
349         uint256 _fee = _dividends * magnitude;
350 
351         // no point in continuing execution if OP is a poorfag russian hacker
352         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
353         // (or hackers)
354         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
355         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
356 
357         // is the user referred by a masternode?
358         if (
359             // is this a referred purchase?
360             _referredBy != 0x0000000000000000000000000000000000000000 &&
361 
362             // no cheating!
363             _referredBy != _customerAddress &&
364 
365             // does the referrer have at least X whole tokens?
366             // i.e is the referrer a godly chad masternode
367             tokenBalanceLedger_[_referredBy] >= stakingRequirement
368         ) {
369             // wealth redistribution
370             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
371         } else {
372             // no ref purchase
373             // add the referral bonus back to the global dividends cake
374             _dividends = SafeMath.add(_dividends, _referralBonus);
375             _fee = _dividends * magnitude;
376         }
377 
378         // we can't give people infinite ethereum
379         if (tokenSupply_ > 0) {
380             // add tokens to the pool
381             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
382 
383             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
384             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
385 
386             // calculate the amount of tokens the customer receives over his purchase
387             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
388         } else {
389             // add tokens to the pool
390             tokenSupply_ = _amountOfTokens;
391         }
392 
393         // update circulating supply & the ledger address for the customer
394         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
395 
396         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
397         // really i know you think you do but you don't
398         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
399         payoutsTo_[_customerAddress] += _updatedPayouts;
400 
401         // fire event
402         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
403 
404         return _amountOfTokens;
405     }
406 
407     /**
408      * @dev Calculate Token price based on an amount of incoming ethereum
409      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
410      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
411      */
412     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
413         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
414         uint256 _tokensReceived =
415          (
416             (
417                 // underflow attempts BTFO
418                 SafeMath.sub(
419                     (sqrt
420                         (
421                             (_tokenPriceInitial ** 2)
422                             +
423                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
424                             +
425                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
426                             +
427                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
428                         )
429                     ), _tokenPriceInitial
430                 )
431             ) / (tokenPriceIncremental_)
432         ) - (tokenSupply_);
433 
434         return _tokensReceived;
435     }
436 
437     /**
438      * @dev Calculate token sell value.
439      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
440      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
441      */
442     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
443         uint256 tokens_ = (_tokens + 1e18);
444         uint256 _tokenSupply = (tokenSupply_ + 1e18);
445         uint256 _etherReceived =
446         (
447             // underflow attempts BTFO
448             SafeMath.sub(
449                 (
450                     (
451                         (
452                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
453                         ) - tokenPriceIncremental_
454                     ) * (tokens_ - 1e18)
455                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
456             )
457         / 1e18);
458 
459         return _etherReceived;
460     }
461 
462     /// @dev This is where all your gas goes.
463     function sqrt(uint256 x) internal pure returns (uint256 y) {
464         uint256 z = (x + 1) / 2;
465         y = x;
466 
467         while (z < y) {
468             y = z;
469             z = (x / z + z) / 2;
470         }
471     }
472 
473 
474 }
475 
476 /**
477  * @title SafeMath
478  * @dev Math operations with safety checks that throw on error
479  */
480 library SafeMath {
481 
482     /**
483     * @dev Multiplies two numbers, throws on overflow.
484     */
485     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
486         if (a == 0) {
487             return 0;
488         }
489         uint256 c = a * b;
490         assert(c / a == b);
491         return c;
492     }
493 
494     /**
495     * @dev Integer division of two numbers, truncating the quotient.
496     */
497     function div(uint256 a, uint256 b) internal pure returns (uint256) {
498         // assert(b > 0); // Solidity automatically throws when dividing by 0
499         uint256 c = a / b;
500         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
501         return c;
502     }
503 
504     /**
505     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
506     */
507     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
508         assert(b <= a);
509         return a - b;
510     }
511 
512     /**
513     * @dev Adds two numbers, throws on overflow.
514     */
515     function add(uint256 a, uint256 b) internal pure returns (uint256) {
516         uint256 c = a + b;
517         assert(c >= a);
518         return c;
519     }
520 
521 }