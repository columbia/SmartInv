1 pragma solidity 0.4.20;
2 
3 /*=====================================
4 =       https://powh.surge.sh/        =
5 =====================================*/
6 
7 /*
8 *
9 * -> Team POWHF presents!
10 *           _____                   _______                   _____                    _____
11 *          /\    \                 /::\    \                 /\    \                  /\    \
12 *         /::\    \               /::::\    \               /::\____\                /::\____\
13 *        /::::\    \             /::::::\    \             /:::/    /               /:::/    /
14 *       /::::::\    \           /::::::::\    \           /:::/   _/___            /:::/    /
15 *      /:::/\:::\    \         /:::/~~\:::\    \         /:::/   /\    \          /:::/    /
16 *     /:::/__\:::\    \       /:::/    \:::\    \       /:::/   /::\____\        /:::/____/
17 *    /::::\   \:::\    \     /:::/    / \:::\    \     /:::/   /:::/    /       /::::\    \
18 *   /::::::\   \:::\    \   /:::/____/   \:::\____\   /:::/   /:::/   _/___    /::::::\    \   _____
19 *  /:::/\:::\   \:::\____\ |:::|    |     |:::|    | /:::/___/:::/   /\    \  /:::/\:::\    \ /\    \
20 * /:::/  \:::\   \:::|    ||:::|____|     |:::|    ||:::|   /:::/   /::\____\/:::/  \:::\    /::\____\
21 * \::/    \:::\  /:::|____| \:::\    \   /:::/    / |:::|__/:::/   /:::/    /\::/    \:::\  /:::/    /
22 *  \/_____/\:::\/:::/    /   \:::\    \ /:::/    /   \:::\/:::/   /:::/    /  \/____/ \:::\/:::/    /
23 *           \::::::/    /     \:::\    /:::/    /     \::::::/   /:::/    /            \::::::/    /
24 *            \::::/    /       \:::\__/:::/    /       \::::/___/:::/    /              \::::/    /
25 *             \__/____/         \::::::::/    /         \:::\__/:::/    /               /:::/    /
26 *                                \::::::/    /           \::::::::/    /               /:::/    /
27 *                                 \::::/    /             \::::::/    /               /:::/    /
28 *                                  \__/____/               \::::/    /               /:::/    /
29 *                                                           \__/____/                \::/    /
30 *                                                                                     \/____/
31 * -> Features!
32 * All the features from the original PoWH3D pyramid, with dividend fee optimized (10% > 15%):
33 * [x] Highly Secure: Hundreds of thousands of investers of the original PoWH3D, holding tens of thousands of ethers.
34 * [X] Purchase/Sell: You can perform partial sell orders. If you succumb to weak hands, you don't have to dump all of your bags.
35 * [x] Purchase/Sell: You can transfer tokens between wallets. Trading is possible from within the contract.
36 * [x] Masternodes: The implementation of Ethereum Staking in the world.
37 * [x] Masternodes: Holding 100 POWHF Tokens allow you to generate a Masternode link, Masternode links are used as unique entry points to the contract.
38 * [x] Masternodes: All players who enter the contract through your Masternode have 30% of their 15% dividends fee rerouted from the master-node, to the node-master.
39 *
40 * -> Who worked on this project?
41 * - ManFromFuture (math/memes/main site/master)
42 * - WomanFromMoon (lead solidity dev/lead web3 dev)
43 * - Anonymous#1 (concept design/feedback/management)
44 * - Anonymous#2 (main site/web3/test cases)
45 * - Anonymous#3 (math formulae/whitepaper)
46 *
47 * -> Owner of contract can:
48 * - Nothing, nothing at all.
49 *
50 * -> Owner of contract CANNOT:
51 * - exit scam
52 * - kill the contract
53 * - take funds
54 * - pause the contract
55 * - disable withdrawals
56 * - change the price of tokens
57 *
58 * -> Moon Now! ** https://powh.surge.sh/ **
59 */
60 
61 contract POWHF {
62 
63 
64     /*=====================================
65     =            CONFIGURABLES            =
66     =====================================*/
67     
68     string public name = "POWH Future";
69     string public symbol = "POWHF";
70     uint8 constant public decimals = 18;
71     uint8 constant internal dividendFee_ = 15; // Dividend Fee Optimized!
72     uint constant internal tokenPriceInitial_ = 0.0000001 ether;
73     uint constant internal tokenPriceIncremental_ = 0.00000001 ether;
74     uint constant internal magnitude = 2**64;
75 
76     // proof of stake (defaults at 100 tokens)
77     uint public stakingRequirement = 100e18;
78 
79 
80    /*===============================
81     =            STORAGE           =
82     ==============================*/
83     
84     // amount of shares for each address (scaled number)
85     mapping(address => uint) internal tokenBalanceLedger_;
86     mapping(address => uint) internal referralBalance_;
87     mapping(address => int) internal payoutsTo_;
88     uint internal tokenSupply_ = 0;
89     uint internal profitPerShare_;
90 
91 
92     /*==============================
93     =            EVENTS            =
94     ==============================*/
95     
96     event onTokenPurchase(
97         address indexed customerAddress,
98         uint incomingEthereum,
99         uint tokensMinted,
100         address indexed referredBy
101     );
102 
103     event onTokenSell(
104         address indexed customerAddress,
105         uint tokensBurned,
106         uint ethereumEarned
107     );
108 
109     event onReinvestment(
110         address indexed customerAddress,
111         uint ethereumReinvested,
112         uint tokensMinted
113     );
114 
115     event onWithdraw(
116         address indexed customerAddress,
117         uint ethereumWithdrawn
118     );
119 
120     // ERC20
121     event Transfer(
122         address indexed from,
123         address indexed to,
124         uint tokens
125     );
126 
127 
128     /*=======================================
129     =            PUBLIC FUNCTIONS            =
130     =======================================*/
131 
132     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
133     function buy(address _referredBy) public payable returns (uint) {
134         purchaseTokens(msg.value, _referredBy);
135     }
136 
137     /**
138      * @dev Fallback function to handle ethereum that was send straight to the contract
139      *  Unfortunately we cannot use a referral address this way.
140      */
141     function() payable public {
142         purchaseTokens(msg.value, 0x0);
143     }
144 
145     /// @dev Converts all of caller's dividends to tokens.
146     function reinvest() onlyStronghands public {
147         // fetch dividends
148         uint _dividends = myDividends(false); // retrieve ref. bonus later in the code
149 
150         // pay out the dividends virtually
151         address _customerAddress = msg.sender;
152         payoutsTo_[_customerAddress] +=  (int) (_dividends * magnitude);
153 
154         // retrieve ref. bonus
155         _dividends += referralBalance_[_customerAddress];
156         referralBalance_[_customerAddress] = 0;
157 
158         // dispatch a buy order with the virtualized "withdrawn dividends"
159         uint _tokens = purchaseTokens(_dividends, 0x0);
160 
161         // fire event
162         onReinvestment(_customerAddress, _dividends, _tokens);
163     }
164 
165     /// @dev Alias of sell() and withdraw().
166     function exit() public {
167         // get token count for caller & sell them all
168         address _customerAddress = msg.sender;
169         uint _tokens = tokenBalanceLedger_[_customerAddress];
170         if (_tokens > 0) sell(_tokens);
171 
172         // lambo delivery service
173         withdraw();
174     }
175 
176     /// @dev Withdraws all of the callers earnings.
177     function withdraw() onlyStronghands public {
178         // setup data
179         address _customerAddress = msg.sender;
180         uint _dividends = myDividends(false); // get ref. bonus later in the code
181 
182         // update dividend tracker
183         payoutsTo_[_customerAddress] +=  (int) (_dividends * magnitude);
184 
185         // add ref. bonus
186         _dividends += referralBalance_[_customerAddress];
187         referralBalance_[_customerAddress] = 0;
188 
189         // lambo delivery service
190         _customerAddress.transfer(_dividends);
191 
192         // fire event
193         onWithdraw(_customerAddress, _dividends);
194     }
195 
196     /// @dev Liquifies tokens to ethereum.
197     function sell(uint _amountOfTokens) onlyBagholders public {
198         // setup data
199         address _customerAddress = msg.sender;
200         // russian hackers BTFO
201         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
202         uint _tokens = _amountOfTokens;
203         uint _ethereum = tokensToEthereum_(_tokens);
204         uint _dividends = SafeMath.div(_ethereum, dividendFee_);
205         uint _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
206 
207         // burn the sold tokens
208         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
209         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
210 
211         // update dividends tracker
212         int _updatedPayouts = (int) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
213         payoutsTo_[_customerAddress] -= _updatedPayouts;
214 
215         // dividing by zero is a bad idea
216         if (tokenSupply_ > 0) {
217             // update the amount of dividends per token
218             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
219         }
220 
221         // fire event
222         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
223     }
224 
225 
226     /**
227      * @dev Transfer tokens from the caller to a new holder.
228      *  Remember, there's a 15% fee here as well.
229      */
230     function transfer(address _toAddress, uint _amountOfTokens) onlyBagholders public returns (bool) {
231         // setup
232         address _customerAddress = msg.sender;
233 
234         // make sure we have the requested tokens
235         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
236 
237         // withdraw all outstanding dividends first
238         if (myDividends(true) > 0) {
239             withdraw();
240         }
241 
242         // liquify 15% of the tokens that are transfered
243         // these are dispersed to shareholders
244         uint _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
245         uint _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
246         uint _dividends = tokensToEthereum_(_tokenFee);
247 
248         // burn the fee tokens
249         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
250 
251         // exchange tokens
252         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
253         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
254 
255         // update dividend trackers
256         payoutsTo_[_customerAddress] -= (int) (profitPerShare_ * _amountOfTokens);
257         payoutsTo_[_toAddress] += (int) (profitPerShare_ * _taxedTokens);
258 
259         // disperse dividends among holders
260         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
261 
262         // fire event
263         Transfer(_customerAddress, _toAddress, _taxedTokens);
264 
265         // ERC20
266         return true;
267     }
268 
269 
270     /*=====================================
271     =      HELPERS AND CALCULATORS        =
272     =====================================*/
273     /**
274      * @dev Method to view the current Ethereum stored in the contract
275      *  Example: totalEthereumBalance()
276      */
277     function totalEthereumBalance() public view returns (uint) {
278         return this.balance;
279     }
280 
281     /// @dev Retrieve the total token supply.
282     function totalSupply() public view returns (uint) {
283         return tokenSupply_;
284     }
285 
286     /// @dev Retrieve the tokens owned by the caller.
287     function myTokens() public view returns (uint) {
288         address _customerAddress = msg.sender;
289         return balanceOf(_customerAddress);
290     }
291 
292     /**
293      * @dev Retrieve the dividends owned by the caller.
294      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
295      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
296      *  But in the internal calculations, we want them separate.
297      */
298     function myDividends(bool _includeReferralBonus) public view returns (uint) {
299         address _customerAddress = msg.sender;
300         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
301     }
302 
303     /// @dev Retrieve the token balance of any single address.
304     function balanceOf(address _customerAddress) public view returns (uint) {
305         return tokenBalanceLedger_[_customerAddress];
306     }
307 
308     /**
309      * Retrieve the dividend balance of any single address.
310      */
311     function dividendsOf(address _customerAddress) public view returns (uint) {
312         return (uint) ((int)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
313     }
314 
315     /// @dev Return the buy price of 1 individual token.
316     function sellPrice() public view returns (uint) {
317         // our calculation relies on the token supply, so we need supply. Doh.
318         if (tokenSupply_ == 0) {
319             return tokenPriceInitial_ - tokenPriceIncremental_;
320         } else {
321             uint _ethereum = tokensToEthereum_(1e18);
322             uint _dividends = SafeMath.div(_ethereum, dividendFee_  );
323             uint _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
324             return _taxedEthereum;
325         }
326     }
327 
328     /// @dev Return the sell price of 1 individual token.
329     function buyPrice() public view returns (uint) {
330         // our calculation relies on the token supply, so we need supply. Doh.
331         if (tokenSupply_ == 0) {
332             return tokenPriceInitial_ + tokenPriceIncremental_;
333         } else {
334             uint _ethereum = tokensToEthereum_(1e18);
335             uint _dividends = SafeMath.div(_ethereum, dividendFee_  );
336             uint _taxedEthereum = SafeMath.add(_ethereum, _dividends);
337             return _taxedEthereum;
338         }
339     }
340 
341     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
342     function calculateTokensReceived(uint _ethereumToSpend) public view returns (uint) {
343         uint _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
344         uint _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
345         uint _amountOfTokens = ethereumToTokens_(_taxedEthereum);
346 
347         return _amountOfTokens;
348     }
349 
350     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
351     function calculateEthereumReceived(uint _tokensToSell) public view returns (uint) {
352         require(_tokensToSell <= tokenSupply_);
353         uint _ethereum = tokensToEthereum_(_tokensToSell);
354         uint _dividends = SafeMath.div(_ethereum, dividendFee_);
355         uint _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
356         return _taxedEthereum;
357     }
358 
359 
360     /*==========================================
361     =            INTERNAL FUNCTIONS            =
362     ==========================================*/
363     function purchaseTokens(uint _incomingEthereum, address _referredBy) internal returns (uint) {
364         // data setup
365         address _customerAddress = msg.sender;
366         uint _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
367         uint _referralBonus = SafeMath.div(_undividedDividends, 3);
368         uint _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
369         uint _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
370         uint _amountOfTokens = ethereumToTokens_(_taxedEthereum);
371         uint _fee = _dividends * magnitude;
372 
373         // no point in continuing execution if OP is a poorfag russian hacker
374         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
375         // (or hackers)
376         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
377         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
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
402 
403             // add tokens to the pool
404             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
405 
406             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
407             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
408 
409             // calculate the amount of tokens the customer receives over his purchase
410             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
411 
412         } else {
413             // add tokens to the pool
414             tokenSupply_ = _amountOfTokens;
415         }
416 
417         // update circulating supply & the ledger address for the customer
418         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
419 
420         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
421         //really i know you think you do but you don't
422         int _updatedPayouts = (int) ((profitPerShare_ * _amountOfTokens) - _fee);
423         payoutsTo_[_customerAddress] += _updatedPayouts;
424 
425         // fire event
426         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
427 
428         return _amountOfTokens;
429     }
430 
431     /**
432      * Calculate Token price based on an amount of incoming ethereum
433      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
434      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
435      */
436     function ethereumToTokens_(uint _ethereum) internal view returns (uint) {
437         uint _tokenPriceInitial = tokenPriceInitial_ * 1e18;
438         uint _tokensReceived =
439          (
440             (
441                 // underflow attempts BTFO
442                 SafeMath.sub(
443                     (sqrt
444                         (
445                             (_tokenPriceInitial**2)
446                             +
447                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
448                             +
449                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
450                             +
451                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
452                         )
453                     ), _tokenPriceInitial
454                 )
455             )/(tokenPriceIncremental_)
456         )-(tokenSupply_)
457         ;
458 
459         return _tokensReceived;
460     }
461 
462     /**
463      * @dev Calculate token sell value.
464      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
465      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
466      */
467     function tokensToEthereum_(uint _tokens) internal view returns (uint) {
468         uint tokens_ = (_tokens + 1e18);
469         uint _tokenSupply = (tokenSupply_ + 1e18);
470         uint _etherReceived =
471         (
472             // underflow attempts BTFO
473             SafeMath.sub(
474                 (
475                     (
476                         (
477                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
478                         )-tokenPriceIncremental_
479                     )*(tokens_ - 1e18)
480                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
481             )
482         /1e18);
483         return _etherReceived;
484     }
485 
486     /// @dev This is where all your gas goes.
487     function sqrt(uint x) internal pure returns (uint y) {
488         uint z = (x + 1) / 2;
489         y = x;
490         while (z < y) {
491             y = z;
492             z = (x / z + z) / 2;
493         }
494     }
495 
496 
497     /*=================================
498     =            MODIFIERS            =
499     =================================*/
500 
501     /// @dev Only people with tokens
502     modifier onlyBagholders {
503         require(myTokens() > 0);
504         _;
505     }
506 
507     /// @dev Only people with profits
508     modifier onlyStronghands {
509         require(myDividends(true) > 0);
510         _;
511     }
512 
513 
514 }
515 
516 /**
517  * @title SafeMath
518  * @dev Math operations with safety checks that throw on error
519  */
520 library SafeMath {
521 
522     /**
523     * @dev Multiplies two numbers, throws on overflow.
524     */
525     function mul(uint a, uint b) internal pure returns (uint) {
526         if (a == 0) {
527             return 0;
528         }
529         uint c = a * b;
530         assert(c / a == b);
531         return c;
532     }
533 
534     /**
535     * @dev Integer division of two numbers, truncating the quotient.
536     */
537     function div(uint a, uint b) internal pure returns (uint) {
538         // assert(b > 0); // Solidity automatically throws when dividing by 0
539         uint c = a / b;
540         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
541         return c;
542     }
543 
544     /**
545     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
546     */
547     function sub(uint a, uint b) internal pure returns (uint) {
548         assert(b <= a);
549         return a - b;
550     }
551 
552     /**
553     * @dev Adds two numbers, throws on overflow.
554     */
555     function add(uint a, uint b) internal pure returns (uint) {
556         uint c = a + b;
557         assert(c >= a);
558         return c;
559     }
560 }