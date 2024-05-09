1 pragma solidity ^0.4.20;
2 
3 /*
4 *GRIP TOKEN
5 *No PREMINE
6 *Dedicated Dev and Marketing Team - Strongest hands; won't ever dump
7 *20% Div on Buy/25% on Sell - Additional Sell Protection
8 *-----------www.griptoken.co-----------
9 *
10 */
11 
12 contract Griptoken {
13 
14 
15     /*=================================
16     =            MODIFIERS            =
17     =================================*/
18 
19     /// @dev Only people with tokens
20     modifier onlyBagholders {
21         require(myTokens() > 0);
22         _;
23     }
24 
25     /// @dev Only people with profits
26     modifier onlyStronghands {
27         require(myDividends(true) > 0);
28         _;
29     }
30 
31 
32     /*==============================
33     =            EVENTS            =
34     ==============================*/
35 
36     event onTokenPurchase(
37         address indexed customerAddress,
38         uint256 incomingEthereum,
39         uint256 tokensMinted,
40         address indexed referredBy,
41         uint timestamp,
42         uint256 price
43     );
44 
45     event onTokenSell(
46         address indexed customerAddress,
47         uint256 tokensBurned,
48         uint256 ethereumEarned,
49         uint timestamp,
50         uint256 price
51     );
52 
53     event onReinvestment(
54         address indexed customerAddress,
55         uint256 ethereumReinvested,
56         uint256 tokensMinted
57     );
58 
59     event onWithdraw(
60         address indexed customerAddress,
61         uint256 ethereumWithdrawn
62     );
63 
64     // ERC20
65     event Transfer(
66         address indexed from,
67         address indexed to,
68         uint256 tokens
69     );
70 
71 
72     /*=====================================
73     =            CONFIGURABLES            =
74     =====================================*/
75 
76     string public name = "Griptoken";
77     string public symbol = "GRIPS";
78     uint8 constant public decimals = 18;
79 
80     /// @dev 15% dividends for token purchase
81     uint8 constant internal entryFee_ = 20;
82 
83     /// @dev 10% dividends for token transfer
84     uint8 constant internal transferFee_ = 10;
85 
86     /// @dev 25% dividends for token selling
87     uint8 constant internal exitFee_ = 25;
88 
89     /// @dev 35% of entryFee_ (i.e. 7% dividends) is given to referrer
90     uint8 constant internal refferalFee_ = 35;
91 
92     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
93     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
94     uint256 constant internal magnitude = 2 ** 64;
95 
96     /// @dev proof of stake (defaults at 50 tokens)
97     uint256 public stakingRequirement = 50e18;
98 
99 
100    /*=================================
101     =            DATASETS            =
102     ================================*/
103 
104     // amount of shares for each address (scaled number)
105     mapping(address => uint256) internal tokenBalanceLedger_;
106     mapping(address => uint256) internal referralBalance_;
107     mapping(address => int256) internal payoutsTo_;
108     uint256 internal tokenSupply_;
109     uint256 internal profitPerShare_;
110 
111 
112     /*=======================================
113     =            PUBLIC FUNCTIONS           =
114     =======================================*/
115 
116     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
117     function buy(address _referredBy) public payable returns (uint256) {
118         purchaseTokens(msg.value, _referredBy);
119     }
120 
121     /**
122      * @dev Fallback function to handle ethereum that was send straight to the contract
123      *  Unfortunately we cannot use a referral address this way.
124      */
125     function() payable public {
126         purchaseTokens(msg.value, 0x0);
127     }
128 
129     /// @dev Converts all of caller's dividends to tokens.
130     function reinvest() onlyStronghands public {
131         // fetch dividends
132         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
133 
134         // pay out the dividends virtually
135         address _customerAddress = msg.sender;
136         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
137 
138         // retrieve ref. bonus
139         _dividends += referralBalance_[_customerAddress];
140         referralBalance_[_customerAddress] = 0;
141 
142         // dispatch a buy order with the virtualized "withdrawn dividends"
143         uint256 _tokens = purchaseTokens(_dividends, 0x0);
144 
145         // fire event
146         onReinvestment(_customerAddress, _dividends, _tokens);
147     }
148 
149     /// @dev Alias of sell() and withdraw().
150     function exit() public {
151         // get token count for caller & sell them all
152         address _customerAddress = msg.sender;
153         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
154         if (_tokens > 0) sell(_tokens);
155 
156         // lambo delivery service
157         withdraw();
158     }
159 
160     /// @dev Withdraws all of the callers earnings.
161     function withdraw() onlyStronghands public {
162         // setup data
163         address _customerAddress = msg.sender;
164         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
165 
166         // update dividend tracker
167         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
168 
169         // add ref. bonus
170         _dividends += referralBalance_[_customerAddress];
171         referralBalance_[_customerAddress] = 0;
172 
173         // lambo delivery service
174         _customerAddress.transfer(_dividends);
175 
176         // fire event
177         onWithdraw(_customerAddress, _dividends);
178     }
179 
180     /// @dev Liquifies tokens to ethereum.
181     function sell(uint256 _amountOfTokens) onlyBagholders public {
182         // setup data
183         address _customerAddress = msg.sender;
184         // russian hackers BTFO
185         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
186         uint256 _tokens = _amountOfTokens;
187         uint256 _ethereum = tokensToEthereum_(_tokens);
188         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
189         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
190 
191         // burn the sold tokens
192         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
193         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
194 
195         // update dividends tracker
196         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
197         payoutsTo_[_customerAddress] -= _updatedPayouts;
198 
199         // dividing by zero is a bad idea
200         if (tokenSupply_ > 0) {
201             // update the amount of dividends per token
202             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
203         }
204 
205         // fire event
206         onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
207     }
208 
209 
210     /**
211      * @dev Transfer tokens from the caller to a new holder.
212      *  Remember, there's a 15% fee here as well.
213      */
214     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
215         // setup
216         address _customerAddress = msg.sender;
217 
218         // make sure we have the requested tokens
219         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
220 
221         // withdraw all outstanding dividends first
222         if (myDividends(true) > 0) {
223             withdraw();
224         }
225 
226         // liquify 10% of the tokens that are transfered
227         // these are dispersed to shareholders
228         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
229         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
230         uint256 _dividends = tokensToEthereum_(_tokenFee);
231 
232         // burn the fee tokens
233         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
234 
235         // exchange tokens
236         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
237         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
238 
239         // update dividend trackers
240         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
241         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
242 
243         // disperse dividends among holders
244         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
245 
246         // fire event
247         Transfer(_customerAddress, _toAddress, _taxedTokens);
248 
249         // ERC20
250         return true;
251     }
252 
253 
254     /*=====================================
255     =      HELPERS AND CALCULATORS        =
256     =====================================*/
257 
258     /**
259      * @dev Method to view the current Ethereum stored in the contract
260      *  Example: totalEthereumBalance()
261      */
262     function totalEthereumBalance() public view returns (uint256) {
263         return this.balance;
264     }
265 
266     /// @dev Retrieve the total token supply.
267     function totalSupply() public view returns (uint256) {
268         return tokenSupply_;
269     }
270 
271     /// @dev Retrieve the tokens owned by the caller.
272     function myTokens() public view returns (uint256) {
273         address _customerAddress = msg.sender;
274         return balanceOf(_customerAddress);
275     }
276 
277     /**
278      * @dev Retrieve the dividends owned by the caller.
279      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
280      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
281      *  But in the internal calculations, we want them separate.
282      */
283     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
284         address _customerAddress = msg.sender;
285         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
286     }
287 
288     /// @dev Retrieve the token balance of any single address.
289     function balanceOf(address _customerAddress) public view returns (uint256) {
290         return tokenBalanceLedger_[_customerAddress];
291     }
292 
293     /// @dev Retrieve the dividend balance of any single address.
294     function dividendsOf(address _customerAddress) public view returns (uint256) {
295         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
296     }
297 
298     /// @dev Return the sell price of 1 individual token.
299     function sellPrice() public view returns (uint256) {
300         // our calculation relies on the token supply, so we need supply. Doh.
301         if (tokenSupply_ == 0) {
302             return tokenPriceInitial_ - tokenPriceIncremental_;
303         } else {
304             uint256 _ethereum = tokensToEthereum_(1e18);
305             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
306             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
307 
308             return _taxedEthereum;
309         }
310     }
311 
312     /// @dev Return the buy price of 1 individual token.
313     function buyPrice() public view returns (uint256) {
314         // our calculation relies on the token supply, so we need supply. Doh.
315         if (tokenSupply_ == 0) {
316             return tokenPriceInitial_ + tokenPriceIncremental_;
317         } else {
318             uint256 _ethereum = tokensToEthereum_(1e18);
319             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
320             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
321 
322             return _taxedEthereum;
323         }
324     }
325 
326     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
327     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
328         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
329         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
330         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
331 
332         return _amountOfTokens;
333     }
334 
335     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
336     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
337         require(_tokensToSell <= tokenSupply_);
338         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
339         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
340         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
341         return _taxedEthereum;
342     }
343 
344 
345     /*==========================================
346     =            INTERNAL FUNCTIONS            =
347     ==========================================*/
348 
349     /// @dev Internal function to actually purchase the tokens.
350     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
351         // data setup
352         address _customerAddress = msg.sender;
353         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
354         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
355         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
356         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
357         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
358         uint256 _fee = _dividends * magnitude;
359 
360         // no point in continuing execution if OP is a poorfag russian hacker
361         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
362         // (or hackers)
363         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
364         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
365 
366         // is the user referred by a masternode?
367         if (
368             // is this a referred purchase?
369             _referredBy != 0x0000000000000000000000000000000000000000 &&
370 
371             // no cheating!
372             _referredBy != _customerAddress &&
373 
374             // does the referrer have at least X whole tokens?
375             // i.e is the referrer a godly chad masternode
376             tokenBalanceLedger_[_referredBy] >= stakingRequirement
377         ) {
378             // wealth redistribution
379             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
380         } else {
381             // no ref purchase
382             // add the referral bonus back to the global dividends cake
383             _dividends = SafeMath.add(_dividends, _referralBonus);
384             _fee = _dividends * magnitude;
385         }
386 
387         // we can't give people infinite ethereum
388         if (tokenSupply_ > 0) {
389             // add tokens to the pool
390             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
391 
392             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
393             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
394 
395             // calculate the amount of tokens the customer receives over his purchase
396             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
397         } else {
398             // add tokens to the pool
399             tokenSupply_ = _amountOfTokens;
400         }
401 
402         // update circulating supply & the ledger address for the customer
403         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
404 
405         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
406         // really i know you think you do but you don't
407         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
408         payoutsTo_[_customerAddress] += _updatedPayouts;
409 
410         // fire event
411         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
412 
413         return _amountOfTokens;
414     }
415 
416     /**
417      * @dev Calculate Token price based on an amount of incoming ethereum
418      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
419      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
420      */
421     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
422         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
423         uint256 _tokensReceived =
424          (
425             (
426                 // underflow attempts BTFO
427                 SafeMath.sub(
428                     (sqrt
429                         (
430                             (_tokenPriceInitial ** 2)
431                             +
432                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
433                             +
434                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
435                             +
436                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
437                         )
438                     ), _tokenPriceInitial
439                 )
440             ) / (tokenPriceIncremental_)
441         ) - (tokenSupply_);
442 
443         return _tokensReceived;
444     }
445 
446     /**
447      * @dev Calculate token sell value.
448      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
449      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
450      */
451     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
452         uint256 tokens_ = (_tokens + 1e18);
453         uint256 _tokenSupply = (tokenSupply_ + 1e18);
454         uint256 _etherReceived =
455         (
456             // underflow attempts BTFO
457             SafeMath.sub(
458                 (
459                     (
460                         (
461                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
462                         ) - tokenPriceIncremental_
463                     ) * (tokens_ - 1e18)
464                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
465             )
466         / 1e18);
467 
468         return _etherReceived;
469     }
470 
471     /// @dev This is where all your gas goes.
472     function sqrt(uint256 x) internal pure returns (uint256 y) {
473         uint256 z = (x + 1) / 2;
474         y = x;
475 
476         while (z < y) {
477             y = z;
478             z = (x / z + z) / 2;
479         }
480     }
481 
482 
483 }
484 
485 /**
486  * @title SafeMath
487  * @dev Math operations with safety checks that throw on error
488  */
489 library SafeMath {
490 
491     /**
492     * @dev Multiplies two numbers, throws on overflow.
493     */
494     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
495         if (a == 0) {
496             return 0;
497         }
498         uint256 c = a * b;
499         assert(c / a == b);
500         return c;
501     }
502 
503     /**
504     * @dev Integer division of two numbers, truncating the quotient.
505     */
506     function div(uint256 a, uint256 b) internal pure returns (uint256) {
507         // assert(b > 0); // Solidity automatically throws when dividing by 0
508         uint256 c = a / b;
509         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
510         return c;
511     }
512 
513     /**
514     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
515     */
516     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
517         assert(b <= a);
518         return a - b;
519     }
520 
521     /**
522     * @dev Adds two numbers, throws on overflow.
523     */
524     function add(uint256 a, uint256 b) internal pure returns (uint256) {
525         uint256 c = a + b;
526         assert(c >= a);
527         return c;
528     }
529 
530 }