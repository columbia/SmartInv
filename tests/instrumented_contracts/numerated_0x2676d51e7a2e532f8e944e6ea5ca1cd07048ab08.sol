1 pragma solidity ^0.4.20;
2 
3 /*
4 * THE ADAM HOLE SYSTEM, A SIMPLE WEBDESIGN WITH A RIPPED SOURCE
5 * YES, Another POWH3D clone, who gives a shit? :)
6 * Only thing you need to worry about is to get in early
7 */
8 
9 contract AHS {
10 
11 
12     /*=================================
13     =            MODIFIERS            =
14     =================================*/
15 
16     /// @dev Only people with tokens
17     modifier onlyBagholders {
18         require(myTokens() > 0);
19         _;
20     }
21 
22     /// @dev Only people with profits
23     modifier onlyStronghands {
24         require(myDividends(true) > 0);
25         _;
26     }
27 
28 
29     /*==============================
30     =            EVENTS            =
31     ==============================*/
32 
33     event onTokenPurchase(
34         address indexed customerAddress,
35         uint256 incomingEthereum,
36         uint256 tokensMinted,
37         address indexed referredBy,
38         uint timestamp,
39         uint256 price
40     );
41 
42     event onTokenSell(
43         address indexed customerAddress,
44         uint256 tokensBurned,
45         uint256 ethereumEarned,
46         uint timestamp,
47         uint256 price
48     );
49 
50     event onReinvestment(
51         address indexed customerAddress,
52         uint256 ethereumReinvested,
53         uint256 tokensMinted
54     );
55 
56     event onWithdraw(
57         address indexed customerAddress,
58         uint256 ethereumWithdrawn
59     );
60 
61     // ERC20
62     event Transfer(
63         address indexed from,
64         address indexed to,
65         uint256 tokens
66     );
67 
68 
69     /*=====================================
70     =            CONFIGURABLES            =
71     =====================================*/
72 
73     string public name = "Adam Hole System";
74     string public symbol = "AHS";
75     uint8 constant public decimals = 18;
76 
77     /// @dev 20% dividends for token purchase
78     uint8 constant internal entryFee_ = 20;
79 
80     /// @dev 10% dividends for token transfer
81     uint8 constant internal transferFee_ = 10;
82 
83     /// @dev 25% dividends for token selling
84     uint8 constant internal exitFee_ = 25;
85 
86     /// @dev 50% of entryFee is given to referrer
87     uint8 constant internal refferalFee_ = 50;
88 
89     uint256 constant internal tokenPriceInitial_ = 0.000000001 ether;
90     uint256 constant internal tokenPriceIncremental_ = 0.000000002 ether;
91     uint256 constant internal magnitude = 2 ** 64;
92 
93     /// @dev proof of stake (defaults at 50 tokens)
94     uint256 public stakingRequirement = 50e18;
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
107 
108 
109     /*=======================================
110     =            PUBLIC FUNCTIONS           =
111     =======================================*/
112 
113     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
114     function buy(address _referredBy) public payable returns (uint256) {
115         purchaseTokens(msg.value, _referredBy);
116     }
117 
118     /**
119      * @dev Fallback function to handle ethereum that was send straight to the contract
120      *  Unfortunately we cannot use a referral address this way.
121      */
122     function() payable public {
123         purchaseTokens(msg.value, 0x0);
124     }
125 
126     /// @dev Converts all of caller's dividends to tokens.
127     function reinvest() onlyStronghands public {
128         // fetch dividends
129         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
130 
131         // pay out the dividends virtually
132         address _customerAddress = msg.sender;
133         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
134 
135         // retrieve ref. bonus
136         _dividends += referralBalance_[_customerAddress];
137         referralBalance_[_customerAddress] = 0;
138 
139         // dispatch a buy order with the virtualized "withdrawn dividends"
140         uint256 _tokens = purchaseTokens(_dividends, 0x0);
141 
142         // fire event
143         onReinvestment(_customerAddress, _dividends, _tokens);
144     }
145 
146     /// @dev Alias of sell() and withdraw().
147     function exit() public {
148         // get token count for caller & sell them all
149         address _customerAddress = msg.sender;
150         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
151         if (_tokens > 0) sell(_tokens);
152 
153         // lambo delivery service
154         withdraw();
155     }
156 
157     /// @dev Withdraws all of the callers earnings.
158     function withdraw() onlyStronghands public {
159         // setup data
160         address _customerAddress = msg.sender;
161         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
162 
163         // update dividend tracker
164         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
165 
166         // add ref. bonus
167         _dividends += referralBalance_[_customerAddress];
168         referralBalance_[_customerAddress] = 0;
169 
170         // lambo delivery service
171         _customerAddress.transfer(_dividends);
172 
173         // fire event
174         onWithdraw(_customerAddress, _dividends);
175     }
176 
177     /// @dev Liquifies tokens to ethereum.
178     function sell(uint256 _amountOfTokens) onlyBagholders public {
179         // setup data
180         address _customerAddress = msg.sender;
181         // russian hackers BTFO
182         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
183         uint256 _tokens = _amountOfTokens;
184         uint256 _ethereum = tokensToEthereum_(_tokens);
185         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
186         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
187 
188         // burn the sold tokens
189         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
190         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
191 
192         // update dividends tracker
193         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
194         payoutsTo_[_customerAddress] -= _updatedPayouts;
195 
196         // dividing by zero is a bad idea
197         if (tokenSupply_ > 0) {
198             // update the amount of dividends per token
199             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
200         }
201 
202         // fire event
203         onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
204     }
205 
206 
207     /**
208      * @dev Transfer tokens from the caller to a new holder.
209      *  Remember, there's a 15% fee here as well.
210      */
211     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
212         // setup
213         address _customerAddress = msg.sender;
214 
215         // make sure we have the requested tokens
216         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
217 
218         // withdraw all outstanding dividends first
219         if (myDividends(true) > 0) {
220             withdraw();
221         }
222 
223         // liquify 10% of the tokens that are transfered
224         // these are dispersed to shareholders
225         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
226         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
227         uint256 _dividends = tokensToEthereum_(_tokenFee);
228 
229         // burn the fee tokens
230         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
231 
232         // exchange tokens
233         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
234         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
235 
236         // update dividend trackers
237         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
238         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
239 
240         // disperse dividends among holders
241         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
242 
243         // fire event
244         Transfer(_customerAddress, _toAddress, _taxedTokens);
245 
246         // ERC20
247         return true;
248     }
249 
250 
251     /*=====================================
252     =      HELPERS AND CALCULATORS        =
253     =====================================*/
254 
255     /**
256      * @dev Method to view the current Ethereum stored in the contract
257      *  Example: totalEthereumBalance()
258      */
259     function totalEthereumBalance() public view returns (uint256) {
260         return this.balance;
261     }
262 
263     /// @dev Retrieve the total token supply.
264     function totalSupply() public view returns (uint256) {
265         return tokenSupply_;
266     }
267 
268     /// @dev Retrieve the tokens owned by the caller.
269     function myTokens() public view returns (uint256) {
270         address _customerAddress = msg.sender;
271         return balanceOf(_customerAddress);
272     }
273 
274     /**
275      * @dev Retrieve the dividends owned by the caller.
276      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
277      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
278      *  But in the internal calculations, we want them separate.
279      */
280     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
281         address _customerAddress = msg.sender;
282         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
283     }
284 
285     /// @dev Retrieve the token balance of any single address.
286     function balanceOf(address _customerAddress) public view returns (uint256) {
287         return tokenBalanceLedger_[_customerAddress];
288     }
289 
290     /// @dev Retrieve the dividend balance of any single address.
291     function dividendsOf(address _customerAddress) public view returns (uint256) {
292         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
293     }
294 
295     /// @dev Return the sell price of 1 individual token.
296     function sellPrice() public view returns (uint256) {
297         // our calculation relies on the token supply, so we need supply. Doh.
298         if (tokenSupply_ == 0) {
299             return tokenPriceInitial_ - tokenPriceIncremental_;
300         } else {
301             uint256 _ethereum = tokensToEthereum_(1e18);
302             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
303             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
304 
305             return _taxedEthereum;
306         }
307     }
308 
309     /// @dev Return the buy price of 1 individual token.
310     function buyPrice() public view returns (uint256) {
311         // our calculation relies on the token supply, so we need supply. Doh.
312         if (tokenSupply_ == 0) {
313             return tokenPriceInitial_ + tokenPriceIncremental_;
314         } else {
315             uint256 _ethereum = tokensToEthereum_(1e18);
316             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
317             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
318 
319             return _taxedEthereum;
320         }
321     }
322 
323     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
324     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
325         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
326         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
327         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
328 
329         return _amountOfTokens;
330     }
331 
332     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
333     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
334         require(_tokensToSell <= tokenSupply_);
335         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
336         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
337         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
338         return _taxedEthereum;
339     }
340 
341 
342     /*==========================================
343     =            INTERNAL FUNCTIONS            =
344     ==========================================*/
345 
346     /// @dev Internal function to actually purchase the tokens.
347     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
348         // data setup
349         address _customerAddress = msg.sender;
350         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
351         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
352         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
353         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
354         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
355         uint256 _fee = _dividends * magnitude;
356 
357         // no point in continuing execution if OP is a poorfag russian hacker
358         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
359         // (or hackers)
360         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
361         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
362 
363         // is the user referred by a masternode?
364         if (
365             // is this a referred purchase?
366             _referredBy != 0x0000000000000000000000000000000000000000 &&
367 
368             // no cheating!
369             _referredBy != _customerAddress &&
370 
371             // does the referrer have at least X whole tokens?
372             // i.e is the referrer a godly chad masternode
373             tokenBalanceLedger_[_referredBy] >= stakingRequirement
374         ) {
375             // wealth redistribution
376             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
377         } else {
378             // no ref purchase
379             // add the referral bonus back to the global dividends cake
380             _dividends = SafeMath.add(_dividends, _referralBonus);
381             _fee = _dividends * magnitude;
382         }
383 
384         // we can't give people infinite ethereum
385         if (tokenSupply_ > 0) {
386             // add tokens to the pool
387             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
388 
389             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
390             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
391 
392             // calculate the amount of tokens the customer receives over his purchase
393             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
394         } else {
395             // add tokens to the pool
396             tokenSupply_ = _amountOfTokens;
397         }
398 
399         // update circulating supply & the ledger address for the customer
400         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
401 
402         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
403         // really i know you think you do but you don't
404         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
405         payoutsTo_[_customerAddress] += _updatedPayouts;
406 
407         // fire event
408         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
409 
410         return _amountOfTokens;
411     }
412 
413     /**
414      * @dev Calculate Token price based on an amount of incoming ethereum
415      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
416      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
417      */
418     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
419         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
420         uint256 _tokensReceived =
421          (
422             (
423                 // underflow attempts BTFO
424                 SafeMath.sub(
425                     (sqrt
426                         (
427                             (_tokenPriceInitial ** 2)
428                             +
429                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
430                             +
431                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
432                             +
433                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
434                         )
435                     ), _tokenPriceInitial
436                 )
437             ) / (tokenPriceIncremental_)
438         ) - (tokenSupply_);
439 
440         return _tokensReceived;
441     }
442 
443     /**
444      * @dev Calculate token sell value.
445      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
446      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
447      */
448     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
449         uint256 tokens_ = (_tokens + 1e18);
450         uint256 _tokenSupply = (tokenSupply_ + 1e18);
451         uint256 _etherReceived =
452         (
453             // underflow attempts BTFO
454             SafeMath.sub(
455                 (
456                     (
457                         (
458                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
459                         ) - tokenPriceIncremental_
460                     ) * (tokens_ - 1e18)
461                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
462             )
463         / 1e18);
464 
465         return _etherReceived;
466     }
467 
468     /// @dev This is where all your gas goes.
469     function sqrt(uint256 x) internal pure returns (uint256 y) {
470         uint256 z = (x + 1) / 2;
471         y = x;
472 
473         while (z < y) {
474             y = z;
475             z = (x / z + z) / 2;
476         }
477     }
478 
479 
480 }
481 
482 /**
483  * @title SafeMath
484  * @dev Math operations with safety checks that throw on error
485  */
486 library SafeMath {
487 
488     /**
489     * @dev Multiplies two numbers, throws on overflow.
490     */
491     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
492         if (a == 0) {
493             return 0;
494         }
495         uint256 c = a * b;
496         assert(c / a == b);
497         return c;
498     }
499 
500     /**
501     * @dev Integer division of two numbers, truncating the quotient.
502     */
503     function div(uint256 a, uint256 b) internal pure returns (uint256) {
504         // assert(b > 0); // Solidity automatically throws when dividing by 0
505         uint256 c = a / b;
506         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
507         return c;
508     }
509 
510     /**
511     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
512     */
513     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
514         assert(b <= a);
515         return a - b;
516     }
517 
518     /**
519     * @dev Adds two numbers, throws on overflow.
520     */
521     function add(uint256 a, uint256 b) internal pure returns (uint256) {
522         uint256 c = a + b;
523         assert(c >= a);
524         return c;
525     }
526 
527 }