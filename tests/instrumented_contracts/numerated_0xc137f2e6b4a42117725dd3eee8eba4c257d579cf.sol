1 pragma solidity ^0.4.20;
2 
3 /*
4 / https://www.tiptopuniverse.com
5 / https://discord.gg/pXh5qEq
6 */
7 
8 contract MDDV2 {
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
72     string public name = "Moon Dust Dividends";
73     string public symbol = "Moon Dust";
74     uint8 constant public decimals = 18;
75     uint8 constant internal entryFee_ = 25;
76     uint8 constant internal transferFee_ = 11;
77     uint8 constant internal exitFee_ = 9;
78     uint8 constant internal refferalFee_ = 20;
79     uint256 constant internal tokenPriceInitial_ = 0.0075 ether;
80     uint256 constant internal tokenPriceIncremental_ = 0.000000000000000001 ether;
81     uint256 constant internal magnitude = 2 ** 64;
82 
83     /// @dev proof of stake
84     uint256 public stakingRequirement = 10e18;
85 
86 
87    /*=================================
88     =            DATASETS            =
89     ================================*/
90 
91     // amount of shares for each address (scaled number)
92     mapping(address => uint256) internal tokenBalanceLedger_;
93     mapping(address => uint256) internal referralBalance_;
94     mapping(address => int256) internal payoutsTo_;
95     uint256 internal tokenSupply_;
96     uint256 internal profitPerShare_;
97 
98 
99     /*=======================================
100     =            PUBLIC FUNCTIONS           =
101     =======================================*/
102 
103     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
104     function buy(address _referredBy) public payable returns (uint256) {
105         purchaseTokens(msg.value, _referredBy);
106     }
107 
108     /**
109      * @dev Fallback function to handle ethereum that was send straight to the contract
110      *  Unfortunately we cannot use a referral address this way.
111      */
112     function() payable public {
113         purchaseTokens(msg.value, 0x0);
114     }
115 
116     /// @dev Converts all of caller's dividends to tokens.
117     function reinvest() onlyStronghands public {
118         // fetch dividends
119         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
120 
121         // pay out the dividends virtually
122         address _customerAddress = msg.sender;
123         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
124 
125         // retrieve ref. bonus
126         _dividends += referralBalance_[_customerAddress];
127         referralBalance_[_customerAddress] = 0;
128 
129         // dispatch a buy order with the virtualized "withdrawn dividends"
130         uint256 _tokens = purchaseTokens(_dividends, 0x0);
131 
132         // fire event
133         onReinvestment(_customerAddress, _dividends, _tokens);
134     }
135 
136     /// @dev Alias of sell() and withdraw().
137     function exit() public {
138         // get token count for caller & sell them all
139         address _customerAddress = msg.sender;
140         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
141         if (_tokens > 0) sell(_tokens);
142 
143         // lambo delivery service
144         withdraw();
145     }
146 
147     /// @dev Withdraws all of the callers earnings.
148     function withdraw() onlyStronghands public {
149         // setup data
150         address _customerAddress = msg.sender;
151         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
152 
153         // update dividend tracker
154         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
155 
156         // add ref. bonus
157         _dividends += referralBalance_[_customerAddress];
158         referralBalance_[_customerAddress] = 0;
159 
160         // lambo delivery service
161         _customerAddress.transfer(_dividends);
162 
163         // fire event
164         onWithdraw(_customerAddress, _dividends);
165     }
166 
167     /// @dev Liquifies tokens to ethereum.
168     function sell(uint256 _amountOfTokens) onlyBagholders public {
169         // setup data
170         address _customerAddress = msg.sender;
171         // russian hackers BTFO
172         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
173         uint256 _tokens = _amountOfTokens;
174         uint256 _ethereum = tokensToEthereum_(_tokens);
175         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
176         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
177 
178         // burn the sold tokens
179         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
180         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
181 
182         // update dividends tracker
183         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
184         payoutsTo_[_customerAddress] -= _updatedPayouts;
185 
186         // dividing by zero is a bad idea
187         if (tokenSupply_ > 0) {
188             // update the amount of dividends per token
189             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
190         }
191 
192         // fire event
193         onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
194     }
195 
196 
197     /**
198      * @dev Transfer tokens from the caller to a new holder.
199      *  Remember, there's a 15% fee here as well.
200      */
201     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
202         // setup
203         address _customerAddress = msg.sender;
204 
205         // make sure we have the requested tokens
206         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
207 
208         // withdraw all outstanding dividends first
209         if (myDividends(true) > 0) {
210             withdraw();
211         }
212 
213         // liquify 10% of the tokens that are transfered
214         // these are dispersed to shareholders
215         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
216         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
217         uint256 _dividends = tokensToEthereum_(_tokenFee);
218 
219         // burn the fee tokens
220         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
221 
222         // exchange tokens
223         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
224         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
225 
226         // update dividend trackers
227         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
228         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
229 
230         // disperse dividends among holders
231         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
232 
233         // fire event
234         Transfer(_customerAddress, _toAddress, _taxedTokens);
235 
236         // ERC20
237         return true;
238     }
239 
240 
241     /*=====================================
242     =      HELPERS AND CALCULATORS        =
243     =====================================*/
244 
245     /**
246      * @dev Method to view the current Ethereum stored in the contract
247      *  Example: totalEthereumBalance()
248      */
249     function totalEthereumBalance() public view returns (uint256) {
250         return this.balance;
251     }
252 
253     /// @dev Retrieve the total token supply.
254     function totalSupply() public view returns (uint256) {
255         return tokenSupply_;
256     }
257 
258     /// @dev Retrieve the tokens owned by the caller.
259     function myTokens() public view returns (uint256) {
260         address _customerAddress = msg.sender;
261         return balanceOf(_customerAddress);
262     }
263 
264     /**
265      * @dev Retrieve the dividends owned by the caller.
266      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
267      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
268      *  But in the internal calculations, we want them separate.
269      */
270     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
271         address _customerAddress = msg.sender;
272         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
273     }
274 
275     /// @dev Retrieve the token balance of any single address.
276     function balanceOf(address _customerAddress) public view returns (uint256) {
277         return tokenBalanceLedger_[_customerAddress];
278     }
279 
280     /// @dev Retrieve the dividend balance of any single address.
281     function dividendsOf(address _customerAddress) public view returns (uint256) {
282         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
283     }
284 
285     /// @dev Return the sell price of 1 individual token.
286     function sellPrice() public view returns (uint256) {
287         // our calculation relies on the token supply, so we need supply. Doh.
288         if (tokenSupply_ == 0) {
289             return tokenPriceInitial_ - tokenPriceIncremental_;
290         } else {
291             uint256 _ethereum = tokensToEthereum_(1e18);
292             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
293             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
294 
295             return _taxedEthereum;
296         }
297     }
298 
299     /// @dev Return the buy price of 1 individual token.
300     function buyPrice() public view returns (uint256) {
301         // our calculation relies on the token supply, so we need supply. Doh.
302         if (tokenSupply_ == 0) {
303             return tokenPriceInitial_ + tokenPriceIncremental_;
304         } else {
305             uint256 _ethereum = tokensToEthereum_(1e18);
306             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
307             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
308 
309             return _taxedEthereum;
310         }
311     }
312 
313     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
314     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
315         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
316         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
317         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
318 
319         return _amountOfTokens;
320     }
321 
322     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
323     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
324         require(_tokensToSell <= tokenSupply_);
325         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
326         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
327         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
328         return _taxedEthereum;
329     }
330 
331 
332     /*==========================================
333     =            INTERNAL FUNCTIONS            =
334     ==========================================*/
335 
336     /// @dev Internal function to actually purchase the tokens.
337     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
338         // data setup
339         address _customerAddress = msg.sender;
340         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
341         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
342         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
343         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
344         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
345         uint256 _fee = _dividends * magnitude;
346 
347         // no point in continuing execution if OP is a poorfag russian hacker
348         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
349         // (or hackers)
350         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
351         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
352 
353         // is the user referred by a masternode?
354         if (
355             // is this a referred purchase?
356             _referredBy != 0x0000000000000000000000000000000000000000 &&
357 
358             // no cheating!
359             _referredBy != _customerAddress &&
360 
361             // does the referrer have at least X whole tokens?
362             // i.e is the referrer a godly chad masternode
363             tokenBalanceLedger_[_referredBy] >= stakingRequirement
364         ) {
365             // wealth redistribution
366             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
367         } else {
368             // no ref purchase
369             // add the referral bonus back to the global dividends cake
370             _dividends = SafeMath.add(_dividends, _referralBonus);
371             _fee = _dividends * magnitude;
372         }
373 
374         // we can't give people infinite ethereum
375         if (tokenSupply_ > 0) {
376             // add tokens to the pool
377             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
378 
379             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
380             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
381 
382             // calculate the amount of tokens the customer receives over his purchase
383             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
384         } else {
385             // add tokens to the pool
386             tokenSupply_ = _amountOfTokens;
387         }
388 
389         // update circulating supply & the ledger address for the customer
390         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
391 
392         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
393         // really i know you think you do but you don't
394         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
395         payoutsTo_[_customerAddress] += _updatedPayouts;
396 
397         // fire event
398         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
399 
400         return _amountOfTokens;
401     }
402 
403     /**
404      * @dev Calculate Token price based on an amount of incoming ethereum
405      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
406      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
407      */
408     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
409         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
410         uint256 _tokensReceived =
411          (
412             (
413                 // underflow attempts BTFO
414                 SafeMath.sub(
415                     (sqrt
416                         (
417                             (_tokenPriceInitial ** 2)
418                             +
419                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
420                             +
421                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
422                             +
423                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
424                         )
425                     ), _tokenPriceInitial
426                 )
427             ) / (tokenPriceIncremental_)
428         ) - (tokenSupply_);
429 
430         return _tokensReceived;
431     }
432 
433     /**
434      * @dev Calculate token sell value.
435      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
436      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
437      */
438     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
439         uint256 tokens_ = (_tokens + 1e18);
440         uint256 _tokenSupply = (tokenSupply_ + 1e18);
441         uint256 _etherReceived =
442         (
443             // underflow attempts BTFO
444             SafeMath.sub(
445                 (
446                     (
447                         (
448                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
449                         ) - tokenPriceIncremental_
450                     ) * (tokens_ - 1e18)
451                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
452             )
453         / 1e18);
454 
455         return _etherReceived;
456     }
457 
458     /// @dev This is where all your gas goes.
459     function sqrt(uint256 x) internal pure returns (uint256 y) {
460         uint256 z = (x + 1) / 2;
461         y = x;
462 
463         while (z < y) {
464             y = z;
465             z = (x / z + z) / 2;
466         }
467     }
468 
469 
470 }
471 
472 /**
473  * @title SafeMath
474  * @dev Math operations with safety checks that throw on error
475  */
476 library SafeMath {
477 
478     /**
479     * @dev Multiplies two numbers, throws on overflow.
480     */
481     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
482         if (a == 0) {
483             return 0;
484         }
485         uint256 c = a * b;
486         assert(c / a == b);
487         return c;
488     }
489 
490     /**
491     * @dev Integer division of two numbers, truncating the quotient.
492     */
493     function div(uint256 a, uint256 b) internal pure returns (uint256) {
494         // assert(b > 0); // Solidity automatically throws when dividing by 0
495         uint256 c = a / b;
496         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
497         return c;
498     }
499 
500     /**
501     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
502     */
503     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
504         assert(b <= a);
505         return a - b;
506     }
507 
508     /**
509     * @dev Adds two numbers, throws on overflow.
510     */
511     function add(uint256 a, uint256 b) internal pure returns (uint256) {
512         uint256 c = a + b;
513         assert(c >= a);
514         return c;
515     }
516 
517 }