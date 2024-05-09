1 pragma solidity ^0.4.20;
2 
3 contract FUDContract {
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
22     /*==============================
23     =            EVENTS            =
24     ==============================*/
25 
26     event onTokenPurchase(
27         address indexed customerAddress,
28         uint256 incomingEthereum,
29         uint256 tokensMinted,
30         address indexed referredBy,
31         bool isReinvest,
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
52         uint256 ethereumWithdrawn,
53         uint256 estimateTokens,
54         bool isTransfer
55     );
56 
57     // ERC20
58     event Transfer(
59         address indexed from,
60         address indexed to,
61         uint256 tokens
62     );
63 
64 
65     /*=====================================
66     =            CONFIGURABLES            =
67     =====================================*/
68 
69     string public name = "FUD3D";
70     string public symbol = "FUD";
71     uint8 constant public decimals = 18;
72 
73     /// @dev 10% dividends for token purchase
74     uint8 constant internal entryFee_ = 10;
75 
76     /// @dev 1% dividends for token transfer
77     uint8 constant internal transferFee_ = 1;
78 
79     /// @dev 10% dividends for token selling
80     uint8 constant internal exitFee_ = 10;
81 
82     /// @dev 15% masternode
83     uint8 constant internal refferalFee_ = 15;
84 
85     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
86     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
87     uint256 constant internal magnitude = 2 ** 64;
88 
89     /// @dev 250 FUD needed for masternode activation
90     uint256 public stakingRequirement = 250e18;
91 
92 
93    /*=================================
94     =            DATASETS            =
95     ================================*/
96 
97     // amount of shares for each address (scaled number)
98     mapping(address => uint256) internal tokenBalanceLedger_;
99     mapping(address => uint256) internal referralBalance_;
100     mapping(address => int256) internal payoutsTo_;
101     uint256 internal tokenSupply_;
102     uint256 internal profitPerShare_;
103 
104     // administrator list
105     address internal owner;
106     mapping(address => bool) public administrators;
107 
108     /*=======================================
109     =            PUBLIC FUNCTIONS           =
110     =======================================*/
111 
112     constructor()
113     public
114     {
115         // add administrators here
116         owner = msg.sender;
117         administrators[owner] = true;
118     }
119 
120     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral (if any)
121     function buy(address _referredBy) public payable returns (uint256) {
122         purchaseTokens(msg.value, _referredBy, false);
123     }
124 
125     /**
126      * @dev Fallback function to handle ethereum that was send straight to the contract
127      *  Unfortunately we cannot use a referral address this way.
128      */
129     function() payable public {
130         purchaseTokens(msg.value, 0x0, false);
131     }
132 
133     /// @dev Converts all of caller's dividends to tokens.
134     function reinvest() onlyStronghands public {
135         // fetch dividends
136         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
137 
138         // pay out the dividends virtually
139         address _customerAddress = msg.sender;
140         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
141 
142         // retrieve ref. bonus
143         _dividends += referralBalance_[_customerAddress];
144         referralBalance_[_customerAddress] = 0;
145 
146         // dispatch a buy order with the virtualized "withdrawn dividends"
147         uint256 _tokens = purchaseTokens(_dividends, 0x0, true);
148 
149         // fire event
150         emit onReinvestment(_customerAddress, _dividends, _tokens);
151     }
152 
153     /// @dev Alias of sell() and withdraw().
154     function exit() public {
155         // get token count for caller & sell them all
156         address _customerAddress = msg.sender;
157         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
158         if (_tokens > 0) sell(_tokens);
159 
160         // lambo delivery service
161         withdraw(false);
162     }
163 
164     /// @dev Withdraws all of the callers earnings.
165     function withdraw(bool _isTransfer) onlyStronghands public {
166         // setup data
167         address _customerAddress = msg.sender;
168         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
169         uint256 _estimateTokens = calculateTokensReceived(_dividends);
170 
171         // update dividend tracker
172         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
173 
174         // add ref. bonus
175         _dividends += referralBalance_[_customerAddress];
176         referralBalance_[_customerAddress] = 0;
177 
178         // lambo delivery service
179         _customerAddress.transfer(_dividends);
180 
181         // fire event
182         emit onWithdraw(_customerAddress, _dividends, _estimateTokens, _isTransfer);
183     }
184 
185     /// @dev Liquifies tokens to ethereum.
186     function sell(uint256 _amountOfTokens) onlyBagholders public {
187         // setup data
188         address _customerAddress = msg.sender;
189         // russian hackers BTFO
190         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
191         uint256 _tokens = _amountOfTokens;
192         uint256 _ethereum = tokensToEthereum_(_tokens);
193         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
194         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
195 
196         // burn the sold tokens
197         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
198         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
199 
200         // update dividends tracker
201         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
202         payoutsTo_[_customerAddress] -= _updatedPayouts;
203 
204         // dividing by zero is a bad idea
205         if (tokenSupply_ > 0) {
206             // update the amount of dividends per token
207             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
208         }
209 
210         // fire event
211         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
212     }
213 
214 
215     /**
216      * @dev Transfer tokens from the caller to a new holder.
217      *  Remember, there's a 1% fee here as well.
218      */
219     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
220         // setup
221         address _customerAddress = msg.sender;
222 
223         // make sure we have the requested tokens
224         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
225 
226         // withdraw all outstanding dividends first
227         if (myDividends(true) > 0) {
228             withdraw(true);
229         }
230 
231         // liquify 1% of the tokens that are transfered
232         // these are dispersed to shareholders
233         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
234         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
235         uint256 _dividends = tokensToEthereum_(_tokenFee);
236 
237         // burn the fee tokens
238         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
239 
240         // exchange tokens
241         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
242         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
243 
244         // update dividend trackers
245         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
246         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
247 
248         // disperse dividends among holders
249         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
250 
251         // fire event
252         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
253 
254         // ERC20
255         return true;
256     }
257 
258     /*=====================================
259     =      HELPERS AND CALCULATORS        =
260     =====================================*/
261 
262     /**
263      * @dev Method to view the current Ethereum stored in the contract
264      *  Example: totalEthereumBalance()
265      */
266     function totalEthereumBalance() public view returns (uint256) {
267         return address(this).balance;
268     }
269 
270     /// @dev Retrieve the total token supply.
271     function totalSupply() public view returns (uint256) {
272         return tokenSupply_;
273     }
274 
275     /// @dev Retrieve the tokens owned by the caller.
276     function myTokens() public view returns (uint256) {
277         address _customerAddress = msg.sender;
278         return balanceOf(_customerAddress);
279     }
280 
281     /**
282      * @dev Retrieve the dividends owned by the caller.
283      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
284      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
285      *  But in the internal calculations, we want them separate.
286      */
287     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
288         address _customerAddress = msg.sender;
289         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
290     }
291 
292     /// @dev Retrieve the token balance of any single address.
293     function balanceOf(address _customerAddress) public view returns (uint256) {
294         return tokenBalanceLedger_[_customerAddress];
295     }
296 
297     /// @dev Retrieve the dividend balance of any single address.
298     function dividendsOf(address _customerAddress) public view returns (uint256) {
299         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
300     }
301 
302     /// @dev Return the sell price of 1 individual token.
303     function sellPrice() public view returns (uint256) {
304         // our calculation relies on the token supply, so we need supply. Doh.
305         if (tokenSupply_ == 0) {
306             return tokenPriceInitial_ - tokenPriceIncremental_;
307         } else {
308             uint256 _ethereum = tokensToEthereum_(1e18);
309             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
310             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
311 
312             return _taxedEthereum;
313         }
314     }
315 
316     /// @dev Return the buy price of 1 individual token.
317     function buyPrice() public view returns (uint256) {
318         // our calculation relies on the token supply, so we need supply. Doh.
319         if (tokenSupply_ == 0) {
320             return tokenPriceInitial_ + tokenPriceIncremental_;
321         } else {
322             uint256 _ethereum = tokensToEthereum_(1e18);
323             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
324             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
325 
326             return _taxedEthereum;
327         }
328     }
329 
330     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
331     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
332         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
333         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
334         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
335 
336         return _amountOfTokens;
337     }
338 
339     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
340     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
341         require(_tokensToSell <= tokenSupply_);
342         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
343         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
344         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
345         return _taxedEthereum;
346     }
347 
348 
349     /*==========================================
350     =            INTERNAL FUNCTIONS            =
351     ==========================================*/
352 
353     /// @dev Internal function to actually purchase the tokens.
354     function purchaseTokens(uint256 _incomingEthereum, address _referredBy, bool _isReinvest) internal returns (uint256) {
355         // data setup
356         address _customerAddress = msg.sender;
357         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
358         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
359         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
360         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
361         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
362         uint256 _fee = _dividends * magnitude;
363 
364         // no point in continuing execution if OP is a poorfag russian hacker
365         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
366         // (or hackers)
367         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
368         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
369 
370         // is the user referred by a masternode?
371         if (
372             // is this a referred purchase?
373             _referredBy != 0x0000000000000000000000000000000000000000 &&
374 
375             // no cheating!
376             _referredBy != _customerAddress &&
377 
378             // does the referrer have at least X whole tokens?
379             // i.e is the referrer a godly chad masternode
380             tokenBalanceLedger_[_referredBy] >= stakingRequirement
381         ) {
382             // wealth redistribution
383             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
384         } else {
385             // no ref purchase
386             // add the referral bonus back to the global dividends cake
387             _dividends = SafeMath.add(_dividends, _referralBonus);
388             _fee = _dividends * magnitude;
389         }
390 
391         // we can't give people infinite ethereum
392         if (tokenSupply_ > 0) {
393             // add tokens to the pool
394             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
395 
396             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
397             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
398 
399             // calculate the amount of tokens the customer receives over his purchase
400             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
401         } else {
402             // add tokens to the pool
403             tokenSupply_ = _amountOfTokens;
404         }
405 
406         // update circulating supply & the ledger address for the customer
407         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
408 
409         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
410         // really i know you think you do but you don't
411         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
412         payoutsTo_[_customerAddress] += _updatedPayouts;
413 
414         // fire event
415         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, _isReinvest, now, buyPrice());
416 
417         return _amountOfTokens;
418     }
419 
420     /**
421      * @dev Calculate Token price based on an amount of incoming ethereum
422      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
423      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
424      */
425     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
426         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
427         uint256 _tokensReceived =
428          (
429             (
430                 // underflow attempts BTFO
431                 SafeMath.sub(
432                     (sqrt
433                         (
434                             (_tokenPriceInitial ** 2)
435                             +
436                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
437                             +
438                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
439                             +
440                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
441                         )
442                     ), _tokenPriceInitial
443                 )
444             ) / (tokenPriceIncremental_)
445         ) - (tokenSupply_);
446 
447         return _tokensReceived;
448     }
449 
450     /**
451      * @dev Calculate token sell value.
452      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
453      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
454      */
455     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
456         uint256 tokens_ = (_tokens + 1e18);
457         uint256 _tokenSupply = (tokenSupply_ + 1e18);
458         uint256 _etherReceived =
459         (
460             // underflow attempts BTFO
461             SafeMath.sub(
462                 (
463                     (
464                         (
465                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
466                         ) - tokenPriceIncremental_
467                     ) * (tokens_ - 1e18)
468                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
469             )
470         / 1e18);
471 
472         return _etherReceived;
473     }
474 
475     /// @dev This is where all your gas goes.
476     function sqrt(uint256 x) internal pure returns (uint256 y) {
477         uint256 z = (x + 1) / 2;
478         y = x;
479 
480         while (z < y) {
481             y = z;
482             z = (x / z + z) / 2;
483         }
484     }
485 
486 
487 }
488 
489 /**
490  * @title SafeMath
491  * @dev Math operations with safety checks that throw on error
492  */
493 library SafeMath {
494 
495     /**
496     * @dev Multiplies two numbers, throws on overflow.
497     */
498     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
499         if (a == 0) {
500             return 0;
501         }
502         uint256 c = a * b;
503         assert(c / a == b);
504         return c;
505     }
506 
507     /**
508     * @dev Integer division of two numbers, truncating the quotient.
509     */
510     function div(uint256 a, uint256 b) internal pure returns (uint256) {
511         // assert(b > 0); // Solidity automatically throws when dividing by 0
512         uint256 c = a / b;
513         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
514         return c;
515     }
516 
517     /**
518     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
519     */
520     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
521         assert(b <= a);
522         return a - b;
523     }
524 
525     /**
526     * @dev Adds two numbers, throws on overflow.
527     */
528     function add(uint256 a, uint256 b) internal pure returns (uint256) {
529         uint256 c = a + b;
530         assert(c >= a);
531         return c;
532     }
533 
534 }