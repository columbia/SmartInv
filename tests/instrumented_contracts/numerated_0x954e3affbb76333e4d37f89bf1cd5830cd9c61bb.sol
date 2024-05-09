1 pragma solidity ^0.4.20;
2 
3 /*
4 *HarjCoin https://harjcoin.io
5 *
6 */
7 
8 contract Harj {
9 
10 
11     /*=================================
12     =            MODIFIERS            =
13     =================================*/
14 
15     /// @dev Only people with tokens
16     modifier onlyBagholders {
17         require(myTokens() > 0);
18         _;
19     }
20 
21     /// @dev Only people with profits
22     modifier onlyStronghands {
23         require(myDividends(true) > 0);
24         _;
25     }
26 
27 
28     /*==============================
29     =            EVENTS            =
30     ==============================*/
31 
32     event onTokenPurchase(
33         address indexed customerAddress,
34         uint256 incomingEthereum,
35         uint256 tokensMinted,
36         address indexed referredBy,
37         uint timestamp,
38         uint256 price
39     );
40 
41     event onTokenSell(
42         address indexed customerAddress,
43         uint256 tokensBurned,
44         uint256 ethereumEarned,
45         uint timestamp,
46         uint256 price
47     );
48 
49     event onReinvestment(
50         address indexed customerAddress,
51         uint256 ethereumReinvested,
52         uint256 tokensMinted
53     );
54 
55     event onWithdraw(
56         address indexed customerAddress,
57         uint256 ethereumWithdrawn
58     );
59 
60     // ERC20
61     event Transfer(
62         address indexed from,
63         address indexed to,
64         uint256 tokens
65     );
66 
67 
68     /*=====================================
69     =            CONFIGURABLES            =
70     =====================================*/
71 
72     string public name = "Harj Coin";
73     string public symbol = "Harj";
74     uint8 constant public decimals = 18;
75 
76     /// @dev 10% dividends for token purchase
77     uint8 constant internal entryFee_ = 10;
78 
79     /// @dev 0% dividends for token transfer
80     uint8 constant internal transferFee_ = 0;
81 
82     /// @dev 10% dividends for token selling
83     uint8 constant internal exitFee_ = 10;
84 
85     /// @dev 33% of entryFee_ (i.e. 3% dividends) is given to referrer
86     uint8 constant internal refferalFee_ = 33;
87 
88     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
89     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
90     uint256 constant internal magnitude = 2 ** 64;
91 
92     /// @dev proof of stake (defaults at 25 tokens)
93     uint256 public stakingRequirement = 25e18;
94 
95     /*================================
96     =            DATASETS            =
97     ================================*/
98 
99     // amount of shares for each address (scaled number)
100     mapping(address => uint256) internal tokenBalanceLedger_;
101     mapping(address => uint256) internal referralBalance_;
102     mapping(address => int256) internal payoutsTo_;
103     uint256 internal tokenSupply_;
104     uint256 internal profitPerShare_;
105 
106 
107     /*=======================================
108     =            PUBLIC FUNCTIONS           =
109     =======================================*/
110 
111     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
112     function buy(address _referredBy) public payable returns (uint256) {
113         purchaseTokens(msg.value, _referredBy);
114     }
115 
116     /**
117      * @dev Fallback function to handle ethereum that was send straight to the contract
118      *  Unfortunately we cannot use a referral address this way.
119      */
120     function() payable public {
121         purchaseTokens(msg.value, 0x0);
122     }
123 
124     /// @dev Converts all of caller's dividends to tokens.
125     function reinvest() onlyStronghands public {
126         // fetch dividends
127         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
128 
129         // pay out the dividends virtually
130         address _customerAddress = msg.sender;
131         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
132 
133         // retrieve ref. bonus
134         _dividends += referralBalance_[_customerAddress];
135         referralBalance_[_customerAddress] = 0;
136 
137         // dispatch a buy order with the virtualized "withdrawn dividends"
138         uint256 _tokens = purchaseTokens(_dividends, 0x0);
139 
140         // fire event
141         onReinvestment(_customerAddress, _dividends, _tokens);
142     }
143 
144     /// @dev Alias of sell() and withdraw().
145     function exit() public {
146         // get token count for caller & sell them all
147         address _customerAddress = msg.sender;
148         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
149         if (_tokens > 0) sell(_tokens);
150 
151         // lambo delivery service
152         withdraw();
153     }
154 
155     /// @dev Withdraws all of the callers earnings.
156     function withdraw() onlyStronghands public {
157         // setup data
158         address _customerAddress = msg.sender;
159         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
160 
161         // update dividend tracker
162         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
163 
164         // add ref. bonus
165         _dividends += referralBalance_[_customerAddress];
166         referralBalance_[_customerAddress] = 0;
167 
168         // lambo delivery service
169         _customerAddress.transfer(_dividends);
170 
171         // fire event
172         onWithdraw(_customerAddress, _dividends);
173     }
174 
175     /// @dev Liquifies tokens to ethereum.
176     function sell(uint256 _amountOfTokens) onlyBagholders public {
177         // setup data
178         address _customerAddress = msg.sender;
179         // russian hackers BTFO
180         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
181         uint256 _tokens = _amountOfTokens;
182         uint256 _ethereum = tokensToEthereum_(_tokens);
183         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
184         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
185 
186         // burn the sold tokens
187         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
188         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
189 
190         // update dividends tracker
191         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
192         payoutsTo_[_customerAddress] -= _updatedPayouts;
193 
194         // dividing by zero is a bad idea
195         if (tokenSupply_ > 0) {
196             // update the amount of dividends per token
197             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
198         }
199 
200         // fire event
201         onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
202     }
203 
204 
205     /**
206      * @dev Transfer tokens from the caller to a new holder.
207      *  
208      */
209     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
210         // setup
211         address _customerAddress = msg.sender;
212 
213         // make sure we have the requested tokens
214         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
215 
216         // withdraw all outstanding dividends first
217         if (myDividends(true) > 0) {
218             withdraw();
219         }
220 
221         
222         // these are dispersed to shareholders
223         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
224         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
225         uint256 _dividends = tokensToEthereum_(_tokenFee);
226 
227         // burn the fee tokens
228         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
229 
230         // exchange tokens
231         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
232         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
233 
234         // update dividend trackers
235         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
236         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
237 
238         // disperse dividends among holders
239         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
240 
241         // fire event
242         Transfer(_customerAddress, _toAddress, _taxedTokens);
243 
244         // ERC20
245         return true;
246     }
247 
248 
249     /*=====================================
250     =      HELPERS AND CALCULATORS        =
251     =====================================*/
252 
253     /**
254      * @dev Method to view the current Ethereum stored in the contract
255      *  Example: totalEthereumBalance()
256      */
257     function totalEthereumBalance() public view returns (uint256) {
258         return this.balance;
259     }
260 
261     /// @dev Retrieve the total token supply.
262     function totalSupply() public view returns (uint256) {
263         return tokenSupply_;
264     }
265 
266     /// @dev Retrieve the tokens owned by the caller.
267     function myTokens() public view returns (uint256) {
268         address _customerAddress = msg.sender;
269         return balanceOf(_customerAddress);
270     }
271 
272     /**
273      * @dev Retrieve the dividends owned by the caller.
274      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
275      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
276      *  But in the internal calculations, we want them separate.
277      */
278     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
279         address _customerAddress = msg.sender;
280         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
281     }
282 
283     /// @dev Retrieve the token balance of any single address.
284     function balanceOf(address _customerAddress) public view returns (uint256) {
285         return tokenBalanceLedger_[_customerAddress];
286     }
287 
288     /// @dev Retrieve the dividend balance of any single address.
289     function dividendsOf(address _customerAddress) public view returns (uint256) {
290         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
291     }
292 
293     /// @dev Return the sell price of 1 individual token.
294     function sellPrice() public view returns (uint256) {
295         // our calculation relies on the token supply, so we need supply. Doh.
296         if (tokenSupply_ == 0) {
297             return tokenPriceInitial_ - tokenPriceIncremental_;
298         } else {
299             uint256 _ethereum = tokensToEthereum_(1e18);
300             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
301             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
302 
303             return _taxedEthereum;
304         }
305     }
306 
307     /// @dev Return the buy price of 1 individual token.
308     function buyPrice() public view returns (uint256) {
309         // our calculation relies on the token supply, so we need supply. Doh.
310         if (tokenSupply_ == 0) {
311             return tokenPriceInitial_ + tokenPriceIncremental_;
312         } else {
313             uint256 _ethereum = tokensToEthereum_(1e18);
314             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
315             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
316 
317             return _taxedEthereum;
318         }
319     }
320 
321     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
322     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
323         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
324         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
325         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
326 
327         return _amountOfTokens;
328     }
329 
330     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
331     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
332         require(_tokensToSell <= tokenSupply_);
333         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
334         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
335         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
336         return _taxedEthereum;
337     }
338 
339 
340     /*==========================================
341     =            INTERNAL FUNCTIONS            =
342     ==========================================*/
343 
344     /// @dev Internal function to actually purchase the tokens.
345     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
346         // data setup
347         address _customerAddress = msg.sender;
348         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
349         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
350         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
351         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
352         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
353         uint256 _fee = _dividends * magnitude;
354 
355         // no point in continuing execution if OP is a poorfag russian hacker
356         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
357         // (or hackers)
358         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
359         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
360 
361         // is the user referred by a masternode?
362         if (
363             // is this a referred purchase?
364             _referredBy != 0x0000000000000000000000000000000000000000 &&
365 
366             // no cheating!
367             _referredBy != _customerAddress &&
368 
369             // does the referrer have at least X whole tokens?
370             // i.e is the referrer a godly chad masternode
371             tokenBalanceLedger_[_referredBy] >= stakingRequirement
372         ) {
373             // wealth redistribution
374             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
375         } else {
376             // no ref purchase
377             // add the referral bonus back to the global dividends cake
378             _dividends = SafeMath.add(_dividends, _referralBonus);
379             _fee = _dividends * magnitude;
380         }
381 
382         // we can't give people infinite ethereum
383         if (tokenSupply_ > 0) {
384             // add tokens to the pool
385             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
386 
387             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
388             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
389 
390             // calculate the amount of tokens the customer receives over his purchase
391             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
392         } else {
393             // add tokens to the pool
394             tokenSupply_ = _amountOfTokens;
395         }
396 
397         // update circulating supply & the ledger address for the customer
398         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
399 
400         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
401         // really i know you think you do but you don't
402         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
403         payoutsTo_[_customerAddress] += _updatedPayouts;
404 
405         // fire event
406         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
407 
408         return _amountOfTokens;
409     }
410 
411     /**
412      * @dev Calculate Token price based on an amount of incoming ethereum
413      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
414      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
415      */
416     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
417         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
418         uint256 _tokensReceived =
419          (
420             (
421                 // underflow attempts BTFO
422                 SafeMath.sub(
423                     (sqrt
424                         (
425                             (_tokenPriceInitial ** 2)
426                             +
427                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
428                             +
429                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
430                             +
431                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
432                         )
433                     ), _tokenPriceInitial
434                 )
435             ) / (tokenPriceIncremental_)
436         ) - (tokenSupply_);
437 
438         return _tokensReceived;
439     }
440 
441     /**
442      * @dev Calculate token sell value.
443      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
444      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
445      */
446     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
447         uint256 tokens_ = (_tokens + 1e18);
448         uint256 _tokenSupply = (tokenSupply_ + 1e18);
449         uint256 _etherReceived =
450         (
451             // underflow attempts BTFO
452             SafeMath.sub(
453                 (
454                     (
455                         (
456                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
457                         ) - tokenPriceIncremental_
458                     ) * (tokens_ - 1e18)
459                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
460             )
461         / 1e18);
462 
463         return _etherReceived;
464     }
465 
466     /// @dev This is where all your gas goes.
467     function sqrt(uint256 x) internal pure returns (uint256 y) {
468         uint256 z = (x + 1) / 2;
469         y = x;
470 
471         while (z < y) {
472             y = z;
473             z = (x / z + z) / 2;
474         }
475     }
476 
477 
478 }
479 
480 /**
481  * @title SafeMath
482  * @dev Math operations with safety checks that throw on error
483  */
484 library SafeMath {
485 
486     /**
487     * @dev Multiplies two numbers, throws on overflow.
488     */
489     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
490         if (a == 0) {
491             return 0;
492         }
493         uint256 c = a * b;
494         assert(c / a == b);
495         return c;
496     }
497 
498     /**
499     * @dev Integer division of two numbers, truncating the quotient.
500     */
501     function div(uint256 a, uint256 b) internal pure returns (uint256) {
502         // assert(b > 0); // Solidity automatically throws when dividing by 0
503         uint256 c = a / b;
504         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
505         return c;
506     }
507 
508     /**
509     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
510     */
511     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
512         assert(b <= a);
513         return a - b;
514     }
515 
516     /**
517     * @dev Adds two numbers, throws on overflow.
518     */
519     function add(uint256 a, uint256 b) internal pure returns (uint256) {
520         uint256 c = a + b;
521         assert(c >= a);
522         return c;
523     }
524 
525 }