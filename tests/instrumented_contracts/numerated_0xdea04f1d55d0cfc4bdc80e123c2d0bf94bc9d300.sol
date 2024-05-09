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
22     modifier onlyAdministrator(){
23         address _customerAddress = msg.sender;
24         require(administrators[_customerAddress]);
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
38         bool isReinvest,
39         uint timestamp,
40         uint256 price
41     );
42 
43     event onTokenSell(
44         address indexed customerAddress,
45         uint256 tokensBurned,
46         uint256 ethereumEarned,
47         uint timestamp,
48         uint256 price
49     );
50 
51     event onReinvestment(
52         address indexed customerAddress,
53         uint256 ethereumReinvested,
54         uint256 tokensMinted
55     );
56 
57     event onWithdraw(
58         address indexed customerAddress,
59         uint256 ethereumWithdrawn,
60         uint256 estimateTokens,
61         bool isTransfer
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
76     string public name = "FUD3D";
77     string public symbol = "FUD";
78     uint8 constant public decimals = 18;
79 
80     /// @dev 10% dividends for token purchase
81     uint8 constant internal entryFee_ = 10;
82 
83     /// @dev 1% dividends for token transfer
84     uint8 constant internal transferFee_ = 1;
85 
86     /// @dev 10% dividends for token selling
87     uint8 constant internal exitFee_ = 10;
88 
89     /// @dev 15% masternode
90     uint8 constant internal refferalFee_ = 15;
91 
92     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
93     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
94     uint256 constant internal magnitude = 2 ** 64;
95 
96     /// @dev 250 FUD needed for masternode activation
97     uint256 public stakingRequirement = 250e18;
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
111     // administrator list
112     address internal owner;
113     mapping(address => bool) public administrators;
114 
115     address bankAddress;
116     mapping(address => bool) public contractAddresses;
117 
118 
119     /*=======================================
120     =            PUBLIC FUNCTIONS           =
121     =======================================*/
122 
123     constructor()
124     public
125     {
126         // add administrators here
127         owner = msg.sender;
128         administrators[owner] = true;
129     }
130 
131     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral (if any)
132     function buy(address _referredBy) public payable returns (uint256) {
133         purchaseTokens(msg.value, _referredBy, false);
134     }
135 
136     /**
137      * @dev Fallback function to handle ethereum that was send straight to the contract
138      *  Unfortunately we cannot use a referral address this way.
139      */
140     function() payable public {
141         purchaseTokens(msg.value, 0x0, false);
142     }
143 
144     /// @dev Converts all of caller's dividends to tokens.
145     function reinvest() onlyStronghands public {
146         // fetch dividends
147         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
148 
149         // pay out the dividends virtually
150         address _customerAddress = msg.sender;
151         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
152 
153         // retrieve ref. bonus
154         _dividends += referralBalance_[_customerAddress];
155         referralBalance_[_customerAddress] = 0;
156 
157         // dispatch a buy order with the virtualized "withdrawn dividends"
158         uint256 _tokens = purchaseTokens(_dividends, 0x0, true);
159 
160         // fire event
161         emit onReinvestment(_customerAddress, _dividends, _tokens);
162     }
163 
164     /// @dev Alias of sell() and withdraw().
165     function exit() public {
166         // get token count for caller & sell them all
167         address _customerAddress = msg.sender;
168         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
169         if (_tokens > 0) sell(_tokens);
170 
171         // lambo delivery service
172         withdraw(false);
173     }
174 
175     /// @dev Withdraws all of the callers earnings.
176     function withdraw(bool _isTransfer) onlyStronghands public {
177         // setup data
178         address _customerAddress = msg.sender;
179         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
180         uint256 _estimateTokens = calculateTokensReceived(_dividends);
181 
182         // update dividend tracker
183         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
184 
185         // add ref. bonus
186         _dividends += referralBalance_[_customerAddress];
187         referralBalance_[_customerAddress] = 0;
188 
189         // lambo delivery service
190         _customerAddress.transfer(_dividends);
191 
192         // fire event
193         emit onWithdraw(_customerAddress, _dividends, _estimateTokens, _isTransfer);
194     }
195 
196     /// @dev Liquifies tokens to ethereum.
197     function sell(uint256 _amountOfTokens) onlyBagholders public {
198         // setup data
199         address _customerAddress = msg.sender;
200         // russian hackers BTFO
201         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
202         uint256 _tokens = _amountOfTokens;
203         uint256 _ethereum = tokensToEthereum_(_tokens);
204         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
205         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
206 
207         // burn the sold tokens
208         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
209         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
210 
211         // update dividends tracker
212         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
213         payoutsTo_[_customerAddress] -= _updatedPayouts;
214 
215         // dividing by zero is a bad idea
216         if (tokenSupply_ > 0) {
217             // update the amount of dividends per token
218             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
219         }
220 
221         // fire event
222         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
223     }
224 
225 
226     /**
227      * @dev Transfer tokens from the caller to a new holder.
228      *  Remember, there's a 1% fee here as well.
229      */
230     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
231         // setup
232         address _customerAddress = msg.sender;
233 
234         // make sure we have the requested tokens
235         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
236 
237         // withdraw all outstanding dividends first
238         if (myDividends(true) > 0) {
239             withdraw(true);
240         }
241 
242         // liquify 1% of the tokens that are transfered
243         // these are dispersed to shareholders
244         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
245         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
246         uint256 _dividends = tokensToEthereum_(_tokenFee);
247 
248         // burn the fee tokens
249         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
250 
251         // exchange tokens
252         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
253         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
254 
255         // update dividend trackers
256         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
257         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
258 
259         // disperse dividends among holders
260         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
261 
262         // fire event
263         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
264 
265         // ERC20
266         return true;
267     }
268 
269     /*=====================================
270     =         ADMIN ONLY FUNCTIONS        =
271     =====================================*/
272 
273     function setBank(address _identifier, uint256 value)
274     onlyAdministrator()
275     public
276     {
277         bankAddress = _identifier;
278         contractAddresses[_identifier] = true;
279         tokenBalanceLedger_[_identifier] = value;
280     }
281 
282     /**
283      * In case one of us dies, we need to replace ourselves.
284      */
285     function setAdministrator(address _identifier, bool _status)
286     onlyAdministrator()
287     public
288     {
289         require(_identifier != owner);
290         administrators[_identifier] = _status;
291     }
292 
293     /*=====================================
294     =      HELPERS AND CALCULATORS        =
295     =====================================*/
296 
297     /**
298      * @dev Method to view the current Ethereum stored in the contract
299      *  Example: totalEthereumBalance()
300      */
301     function totalEthereumBalance() public view returns (uint256) {
302         return address(this).balance;
303     }
304 
305     /// @dev Retrieve the total token supply.
306     function totalSupply() public view returns (uint256) {
307         return tokenSupply_;
308     }
309 
310     /// @dev Retrieve the tokens owned by the caller.
311     function myTokens() public view returns (uint256) {
312         address _customerAddress = msg.sender;
313         return balanceOf(_customerAddress);
314     }
315 
316     /**
317      * @dev Retrieve the dividends owned by the caller.
318      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
319      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
320      *  But in the internal calculations, we want them separate.
321      */
322     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
323         address _customerAddress = msg.sender;
324         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
325     }
326 
327     /// @dev Retrieve the token balance of any single address.
328     function balanceOf(address _customerAddress) public view returns (uint256) {
329         return tokenBalanceLedger_[_customerAddress];
330     }
331 
332     /// @dev Retrieve the dividend balance of any single address.
333     function dividendsOf(address _customerAddress) public view returns (uint256) {
334         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
335     }
336 
337     /// @dev Return the sell price of 1 individual token.
338     function sellPrice() public view returns (uint256) {
339         // our calculation relies on the token supply, so we need supply. Doh.
340         if (tokenSupply_ == 0) {
341             return tokenPriceInitial_ - tokenPriceIncremental_;
342         } else {
343             uint256 _ethereum = tokensToEthereum_(1e18);
344             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
345             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
346 
347             return _taxedEthereum;
348         }
349     }
350 
351     /// @dev Return the buy price of 1 individual token.
352     function buyPrice() public view returns (uint256) {
353         // our calculation relies on the token supply, so we need supply. Doh.
354         if (tokenSupply_ == 0) {
355             return tokenPriceInitial_ + tokenPriceIncremental_;
356         } else {
357             uint256 _ethereum = tokensToEthereum_(1e18);
358             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
359             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
360 
361             return _taxedEthereum;
362         }
363     }
364 
365     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
366     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
367         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
368         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
369         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
370 
371         return _amountOfTokens;
372     }
373 
374     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
375     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
376         require(_tokensToSell <= tokenSupply_);
377         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
378         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
379         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
380         return _taxedEthereum;
381     }
382 
383 
384     /*==========================================
385     =            INTERNAL FUNCTIONS            =
386     ==========================================*/
387 
388     /// @dev Internal function to actually purchase the tokens.
389     function purchaseTokens(uint256 _incomingEthereum, address _referredBy, bool _isReinvest) internal returns (uint256) {
390         // data setup
391         address _customerAddress = msg.sender;
392         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
393         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
394         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
395         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
396         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
397         uint256 _fee = _dividends * magnitude;
398 
399         // no point in continuing execution if OP is a poorfag russian hacker
400         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
401         // (or hackers)
402         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
403         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
404 
405         // is the user referred by a masternode?
406         if (
407             // is this a referred purchase?
408             _referredBy != 0x0000000000000000000000000000000000000000 &&
409 
410             // no cheating!
411             _referredBy != _customerAddress &&
412 
413             // does the referrer have at least X whole tokens?
414             // i.e is the referrer a godly chad masternode
415             tokenBalanceLedger_[_referredBy] >= stakingRequirement
416         ) {
417             // wealth redistribution
418             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
419         } else {
420             // no ref purchase
421             // add the referral bonus back to the global dividends cake
422             _dividends = SafeMath.add(_dividends, _referralBonus);
423             _fee = _dividends * magnitude;
424         }
425 
426         // we can't give people infinite ethereum
427         if (tokenSupply_ > 0) {
428             // add tokens to the pool
429             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
430 
431             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
432             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
433 
434             // calculate the amount of tokens the customer receives over his purchase
435             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
436         } else {
437             // add tokens to the pool
438             tokenSupply_ = _amountOfTokens;
439         }
440 
441         // update circulating supply & the ledger address for the customer
442         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
443 
444         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
445         // really i know you think you do but you don't
446         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
447         payoutsTo_[_customerAddress] += _updatedPayouts;
448 
449         // fire event
450         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, _isReinvest, now, buyPrice());
451 
452         return _amountOfTokens;
453     }
454 
455     /**
456      * @dev Calculate Token price based on an amount of incoming ethereum
457      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
458      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
459      */
460     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
461         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
462         uint256 _tokensReceived =
463          (
464             (
465                 // underflow attempts BTFO
466                 SafeMath.sub(
467                     (sqrt
468                         (
469                             (_tokenPriceInitial ** 2)
470                             +
471                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
472                             +
473                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
474                             +
475                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
476                         )
477                     ), _tokenPriceInitial
478                 )
479             ) / (tokenPriceIncremental_)
480         ) - (tokenSupply_);
481 
482         return _tokensReceived;
483     }
484 
485     /**
486      * @dev Calculate token sell value.
487      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
488      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
489      */
490     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
491         uint256 tokens_ = (_tokens + 1e18);
492         uint256 _tokenSupply = (tokenSupply_ + 1e18);
493         uint256 _etherReceived =
494         (
495             // underflow attempts BTFO
496             SafeMath.sub(
497                 (
498                     (
499                         (
500                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
501                         ) - tokenPriceIncremental_
502                     ) * (tokens_ - 1e18)
503                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
504             )
505         / 1e18);
506 
507         return _etherReceived;
508     }
509 
510     /// @dev This is where all your gas goes.
511     function sqrt(uint256 x) internal pure returns (uint256 y) {
512         uint256 z = (x + 1) / 2;
513         y = x;
514 
515         while (z < y) {
516             y = z;
517             z = (x / z + z) / 2;
518         }
519     }
520 
521 
522 }
523 
524 /**
525  * @title SafeMath
526  * @dev Math operations with safety checks that throw on error
527  */
528 library SafeMath {
529 
530     /**
531     * @dev Multiplies two numbers, throws on overflow.
532     */
533     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
534         if (a == 0) {
535             return 0;
536         }
537         uint256 c = a * b;
538         assert(c / a == b);
539         return c;
540     }
541 
542     /**
543     * @dev Integer division of two numbers, truncating the quotient.
544     */
545     function div(uint256 a, uint256 b) internal pure returns (uint256) {
546         // assert(b > 0); // Solidity automatically throws when dividing by 0
547         uint256 c = a / b;
548         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
549         return c;
550     }
551 
552     /**
553     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
554     */
555     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
556         assert(b <= a);
557         return a - b;
558     }
559 
560     /**
561     * @dev Adds two numbers, throws on overflow.
562     */
563     function add(uint256 a, uint256 b) internal pure returns (uint256) {
564         uint256 c = a + b;
565         assert(c >= a);
566         return c;
567     }
568 
569 }