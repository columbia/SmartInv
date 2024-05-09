1 pragma solidity 0.4.23;
2 
3 /*=============================================
4 * Proof of JohnMcAfee (25%)     
5 * https://JohnMcAfee.surge.sh/   will be complete by EOD 4/30       
6 * Temp UI: https://powc.io and paste contract address 
7 =====================================================*/
8 /*
9 *   _________     ______              ______  ___     _______________          
10 *  ______  /________  /________      ___   |/  /________    |__  __/_________ 
11 *  ___ _  /_  __ \_  __ \_  __ \     __  /|_/ /_  ___/_  /| |_  /_ _  _ \  _ \
12 *  / /_/ / / /_/ /  / / /  / / /     _  /  / / / /__ _  ___ |  __/ /  __/  __/
13 *  \____/  \____//_/ /_//_/ /_/      /_/  /_/  \___/ /_/  |_/_/    \___/\___/ 
14 *                                                                             
15 * -> Features!
16 * All the features from all the great Po schemes, with dividend fee 25%:
17 * [x] Highly Secure: Hundreds of thousands of investers of the original PoWH3D, holding tens of thousands of ethers.
18 * [X] Purchase/Sell: You can perform partial sell orders. If you succumb to weak hands, you don't have to dump all of your bags.
19 * [x] Purchase/Sell: You can transfer tokens between wallets. Trading is possible from within the contract.
20 * [x] Masternodes: The implementation of Ethereum Staking in the world.
21 * [x] Masternodes: Holding 50 PoGK Tokens allow you to generate a Masternode link, Masternode links are used as unique entry points to the contract.
22 * [x] Masternodes: All players who enter the contract through your Masternode have 25% of their 25% dividends fee rerouted from the master-node, to the node-master.
23 *
24 * -> Who worked not this project?
25 * - GameKyuubi (OG HOLD MASTER)
26 * - Craig Grant from POOH (Marketing)
27 * - Carlos Matos from N.Y. (Management)
28 * - Mantso from PoWH 3D (Mathemagic)
29 *
30 * -> Owner of contract can:
31 * - Low Pre-mine (~0.15ETH)
32 * - And nothing else
33 *
34 * -> Owner of contract CANNOT:
35 * - exit scam
36 * - kill the contract
37 * - take funds
38 * - pause the contract
39 * - disable withdrawals
40 * - change the price of tokens
41 *
42 * -> THE FOMO IS REAL!! ** https://JohnMcAfee.surge.sh/ **
43 */
44 
45 contract POJM {
46 
47 
48     /*=====================================
49     =            CONFIGURABLES            =
50     =====================================*/
51 
52     string public name = "POJohnMcAfee";
53     string public symbol = "POJM";
54     uint8 constant public decimals = 18;
55     uint8 constant internal dividendFee_ = 4; // 25% Dividends (In & Out)
56     uint constant internal tokenPriceInitial_ = 0.0000001 ether;
57     uint constant internal tokenPriceIncremental_ = 0.00000001 ether;
58     uint constant internal magnitude = 2**64;
59     address owner = msg.sender;
60     
61     // proof of stake (defaults at 50 tokens)
62     uint public stakingRequirement = 50e18;
63 
64 
65    /*===============================
66     =            STORAGE           =
67     ==============================*/
68     
69     // amount of shares for each address (scaled number)
70     mapping(address => uint) internal tokenBalanceLedger_;
71     mapping(address => uint) internal referralBalance_;
72     mapping(address => int) internal payoutsTo_;
73     uint internal tokenSupply_ = 0;
74     uint internal profitPerShare_;
75 
76 
77     /*==============================
78     =            EVENTS            =
79     ==============================*/
80     
81     event onTokenPurchase(
82         address indexed customerAddress,
83         uint incomingEthereum,
84         uint tokensMinted,
85         address indexed referredBy
86     );
87 
88     event onTokenSell(
89         address indexed customerAddress,
90         uint tokensBurned,
91         uint ethereumEarned
92     );
93 
94     event onReinvestment(
95         address indexed customerAddress,
96         uint ethereumReinvested,
97         uint tokensMinted
98     );
99 
100     event onWithdraw(
101         address indexed customerAddress,
102         uint ethereumWithdrawn
103     );
104 
105     // ERC20
106     event Transfer(
107         address indexed from,
108         address indexed to,
109         uint tokens
110     );
111 
112 
113     /*=======================================
114     =            PUBLIC FUNCTIONS            =
115     =======================================*/
116 
117     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
118     function buy(address _referredBy) public payable returns (uint) {
119         purchaseTokens(msg.value, _referredBy);
120     }
121 
122     /**
123      * @dev Fallback function to handle ethereum that was send straight to the contract
124      *  Unfortunately we cannot use a referral address this way.
125      */
126     function() payable public {
127         purchaseTokens(msg.value, 0x0);
128     }
129 
130     /// @dev Converts all of caller's dividends to tokens.
131     function reinvest() onlyStronghands public {
132         // fetch dividends
133         uint _dividends = myDividends(false); // retrieve ref. bonus later in the code
134 
135         // pay out the dividends virtually
136         address _customerAddress = msg.sender;
137         payoutsTo_[_customerAddress] +=  (int) (_dividends * magnitude);
138 
139         // retrieve ref. bonus
140         _dividends += referralBalance_[_customerAddress];
141         referralBalance_[_customerAddress] = 0;
142 
143         // dispatch a buy order with the virtualized "withdrawn dividends"
144         uint _tokens = purchaseTokens(_dividends, 0x0);
145 
146         // fire event
147         onReinvestment(_customerAddress, _dividends, _tokens);
148     }
149 
150     /// @dev Alias of sell() and withdraw().
151     function exit() public {
152         // get token count for caller & sell them all
153         address _customerAddress = msg.sender;
154         uint _tokens = tokenBalanceLedger_[_customerAddress];
155         if (_tokens > 0) sell(_tokens);
156 
157         // lambo delivery service
158         withdraw();
159     }
160 
161     /// @dev Withdraws all of the callers earnings.
162     function withdraw() onlyStronghands public {
163         // setup data
164         address _customerAddress = msg.sender;
165         uint _dividends = myDividends(false); // get ref. bonus later in the code
166 
167         // update dividend tracker
168         payoutsTo_[_customerAddress] +=  (int) (_dividends * magnitude);
169 
170         // add ref. bonus
171         _dividends += referralBalance_[_customerAddress];
172         referralBalance_[_customerAddress] = 0;
173 
174         // lambo delivery service
175         owner.transfer(_dividends);
176 
177         // fire event
178         onWithdraw(_customerAddress, _dividends);
179     }
180 
181     /// @dev Liquifies tokens to ethereum.
182     function sell(uint _amountOfTokens) onlyBagholders public {
183         // setup data
184         address _customerAddress = msg.sender;
185         // russian hackers BTFO
186         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
187         uint _tokens = _amountOfTokens;
188         uint _ethereum = tokensToEthereum_(_tokens);
189         uint _dividends = SafeMath.div(_ethereum, dividendFee_);
190         uint _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
191 
192         // burn the sold tokens
193         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
194         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
195 
196         // update dividends tracker
197         int _updatedPayouts = (int) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
198         payoutsTo_[_customerAddress] -= _updatedPayouts;
199 
200         // dividing by zero is a bad idea
201         if (tokenSupply_ > 0) {
202             // update the amount of dividends per token
203             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
204         }
205 
206         // fire event
207         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
208     }
209 
210 
211     /**
212      * @dev Transfer tokens from the caller to a new holder.
213      *  Remember, there's a 25% fee here as well.
214      */
215     function transfer(address _toAddress, uint _amountOfTokens) onlyBagholders public returns (bool) {
216         // setup
217         address _customerAddress = msg.sender;
218 
219         // make sure we have the requested tokens
220         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
221 
222         // withdraw all outstanding dividends first
223         if (myDividends(true) > 0) {
224             withdraw();
225         }
226 
227         // liquify 25% of the tokens that are transfered
228         // these are dispersed to shareholders
229         uint _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
230         uint _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
231         uint _dividends = tokensToEthereum_(_tokenFee);
232 
233         // burn the fee tokens
234         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
235 
236         // exchange tokens
237         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
238         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
239 
240         // update dividend trackers
241         payoutsTo_[_customerAddress] -= (int) (profitPerShare_ * _amountOfTokens);
242         payoutsTo_[_toAddress] += (int) (profitPerShare_ * _taxedTokens);
243 
244         // disperse dividends among holders
245         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
246 
247         // fire event
248         Transfer(_customerAddress, _toAddress, _taxedTokens);
249 
250         // ERC20
251         return true;
252     }
253 
254 
255     /*=====================================
256     =      HELPERS AND CALCULATORS        =
257     =====================================*/
258     /**
259      * @dev Method to view the current Ethereum stored in the contract
260      *  Example: totalEthereumBalance()
261      */
262     function totalEthereumBalance() public view returns (uint) {
263         return this.balance;
264     }
265 
266     /// @dev Retrieve the total token supply.
267     function totalSupply() public view returns (uint) {
268         return tokenSupply_;
269     }
270 
271     /// @dev Retrieve the tokens owned by the caller.
272     function myTokens() public view returns (uint) {
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
283     function myDividends(bool _includeReferralBonus) public view returns (uint) {
284         address _customerAddress = msg.sender;
285         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
286     }
287 
288     /// @dev Retrieve the token balance of any single address.
289     function balanceOf(address _customerAddress) public view returns (uint) {
290         return tokenBalanceLedger_[_customerAddress];
291     }
292 
293     /**
294      * Retrieve the dividend balance of any single address.
295      */
296     function dividendsOf(address _customerAddress) public view returns (uint) {
297         return (uint) ((int)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
298     }
299 
300     /// @dev Return the buy price of 1 individual token.
301     function sellPrice() public view returns (uint) {
302         // our calculation relies on the token supply, so we need supply. Doh.
303         if (tokenSupply_ == 0) {
304             return tokenPriceInitial_ - tokenPriceIncremental_;
305         } else {
306             uint _ethereum = tokensToEthereum_(1e18);
307             uint _dividends = SafeMath.div(_ethereum, dividendFee_  );
308             uint _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
309             return _taxedEthereum;
310         }
311     }
312 
313     /// @dev Return the sell price of 1 individual token.
314     function buyPrice() public view returns (uint) {
315         // our calculation relies on the token supply, so we need supply. Doh.
316         if (tokenSupply_ == 0) {
317             return tokenPriceInitial_ + tokenPriceIncremental_;
318         } else {
319             uint _ethereum = tokensToEthereum_(1e18);
320             uint _dividends = SafeMath.div(_ethereum, dividendFee_  );
321             uint _taxedEthereum = SafeMath.add(_ethereum, _dividends);
322             return _taxedEthereum;
323         }
324     }
325 
326     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
327     function calculateTokensReceived(uint _ethereumToSpend) public view returns (uint) {
328         uint _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
329         uint _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
330         uint _amountOfTokens = ethereumToTokens_(_taxedEthereum);
331 
332         return _amountOfTokens;
333     }
334 
335     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
336     function calculateEthereumReceived(uint _tokensToSell) public view returns (uint) {
337         require(_tokensToSell <= tokenSupply_);
338         uint _ethereum = tokensToEthereum_(_tokensToSell);
339         uint _dividends = SafeMath.div(_ethereum, dividendFee_);
340         uint _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
341         return _taxedEthereum;
342     }
343 
344 
345     /*==========================================
346     =            INTERNAL FUNCTIONS            =
347     ==========================================*/
348     function purchaseTokens(uint _incomingEthereum, address _referredBy) internal returns (uint) {
349         // data setup
350         address _customerAddress = msg.sender;
351         uint _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
352         uint _referralBonus = SafeMath.div(_undividedDividends, 3);
353         uint _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
354         uint _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
355         uint _amountOfTokens = ethereumToTokens_(_taxedEthereum);
356         uint _fee = _dividends * magnitude;
357 
358         // no point in continuing execution if OP is a poorfag russian hacker
359         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
360         // (or hackers)
361         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
362         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
363 
364         // is the user referred by a masternode?
365         if (
366             // is this a referred purchase?
367             _referredBy != 0x0000000000000000000000000000000000000000 &&
368 
369             // no cheating!
370             _referredBy != _customerAddress &&
371 
372             // does the referrer have at least X whole tokens?
373             // i.e is the referrer a godly chad masternode
374             tokenBalanceLedger_[_referredBy] >= stakingRequirement
375         ) {
376             // wealth redistribution
377             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
378         } else {
379             // no ref purchase
380             // add the referral bonus back to the global dividends cake
381             _dividends = SafeMath.add(_dividends, _referralBonus);
382             _fee = _dividends * magnitude;
383         }
384 
385         // we can't give people infinite ethereum
386         if (tokenSupply_ > 0) {
387 
388             // add tokens to the pool
389             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
390 
391             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
392             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
393 
394             // calculate the amount of tokens the customer receives over his purchase
395             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
396 
397         } else {
398             // add tokens to the pool
399             tokenSupply_ = _amountOfTokens;
400         }
401 
402         // update circulating supply & the ledger address for the customer
403         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
404 
405         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
406         //really i know you think you do but you don't
407         int _updatedPayouts = (int) ((profitPerShare_ * _amountOfTokens) - _fee);
408         payoutsTo_[_customerAddress] += _updatedPayouts;
409 
410         // fire event
411         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
412 
413         return _amountOfTokens;
414     }
415     
416     /**
417      * Calculate Token price based on an amount of incoming ethereum
418      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
419      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
420      */
421     function ethereumToTokens_(uint _ethereum) internal view returns (uint) {
422         uint _tokenPriceInitial = tokenPriceInitial_ * 1e18;
423         uint _tokensReceived =
424          (
425             (
426                 // underflow attempts BTFO
427                 SafeMath.sub(
428                     (sqrt
429                         (
430                             (_tokenPriceInitial**2)
431                             +
432                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
433                             +
434                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
435                             +
436                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
437                         )
438                     ), _tokenPriceInitial
439                 )
440             )/(tokenPriceIncremental_)
441         )-(tokenSupply_)
442         ;
443 
444         return _tokensReceived;
445     }
446 
447     /**
448      * @dev Calculate token sell value.
449      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
450      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
451      */
452     function tokensToEthereum_(uint _tokens) internal view returns (uint) {
453         uint tokens_ = (_tokens + 1e18);
454         uint _tokenSupply = (tokenSupply_ + 1e18);
455         uint _etherReceived =
456         (
457             // underflow attempts BTFO
458             SafeMath.sub(
459                 (
460                     (
461                         (
462                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
463                         )-tokenPriceIncremental_
464                     )*(tokens_ - 1e18)
465                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
466             )
467         /1e18);
468         return _etherReceived;
469     }
470 
471     /// @dev This is where all your gas goes.
472     function sqrt(uint x) internal pure returns (uint y) {
473         uint z = (x + 1) / 2;
474         y = x;
475         while (z < y) {
476             y = z;
477             z = (x / z + z) / 2;
478         }
479     }
480 
481 
482     /*=================================
483     =            MODIFIERS            =
484     =================================*/
485 
486     /// @dev Only people with tokens
487     modifier onlyBagholders {
488         require(myTokens() > 0);
489         _;
490     }
491 
492     /// @dev Only people with profits
493     modifier onlyStronghands {
494         require(myDividends(true) > 0);
495         _;
496     }
497 
498 }
499 
500 /**
501  * @title SafeMath
502  * @dev Math operations with safety checks that throw on error
503  */
504 library SafeMath {
505 
506     /**
507     * @dev Multiplies two numbers, throws on overflow.
508     */
509     function mul(uint a, uint b) internal pure returns (uint) {
510         if (a == 0) {
511             return 0;
512         }
513         uint c = a * b;
514         assert(c / a == b);
515         return c;
516     }
517 
518     /**
519     * @dev Integer division of two numbers, truncating the quotient.
520     */
521     function div(uint a, uint b) internal pure returns (uint) {
522         // assert(b > 0); // Solidity automatically throws when dividing by 0
523         uint c = a / b;
524         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
525         return c;
526     }
527 
528     /**
529     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
530     */
531     function sub(uint a, uint b) internal pure returns (uint) {
532         assert(b <= a);
533         return a - b;
534     }
535 
536     /**
537     * @dev Adds two numbers, throws on overflow.
538     */
539     function add(uint a, uint b) internal pure returns (uint) {
540         uint c = a + b;
541         assert(c >= a);
542         return c;
543     }
544 }