1 pragma solidity 0.4.20;
2 
3 /*==============================================================
4 =                     http://poharj.com/                       =
5 =                  https://discord.gg/Q2NQec                   =
6 = http://powc.io/?c=0x2f549f7397eed2302f7ce1ba18177abbc974dd52 =
7 ================================================================
8 
9 
10 /*
11   ___ ___    _____ __________      ____.
12  /   |   \  /  _  \\______   \    |    |
13 /    ~    \/  /_\  \|       _/    |    |
14 \    Y    /    |    \    |   \/\__|    |
15  \___|_  /\____|__  /____|_  /\________|
16        \/         \/       \/           
17 
18 
19 * -> Features!
20 * All the features from the original Po contract, with dividend fee 33%:
21 * [x] Highly Secure: Hundreds of thousands of investers have invested in the original contract.
22 * [X] Purchase/Sell: You can perform partial sell orders. If you succumb to weak hands, you don't have to dump all of your bags.
23 * [x] Purchase/Sell: You can transfer tokens between wallets. Trading is possible from within the contract.
24 * [x] Masternodes: The implementation of Ethereum Staking in the world.
25 * [x] Masternodes: Holding 50 PoHarj Tokens allow you to generate a Masternode link, Masternode links are used as unique entry points to the contract.
26 * [x] Masternodes: All players who enter the contract through your Masternode have 30% of their 33% dividends fee rerouted from the master-node, to the node-master.
27 *
28 */
29 
30 contract PoHarj {
31 
32 
33     /*=====================================
34     =            CONFIGURABLES            =
35     =====================================*/
36 
37     string public name = "The Real HarjCoin";
38     string public symbol = "PoHarj";
39     uint8 constant public decimals = 18;
40     uint8 constant internal dividendFee_ = 3; // 33% dividends
41     uint constant internal tokenPriceInitial_ = 0.0000001 ether;
42     uint constant internal tokenPriceIncremental_ = 0.00000001 ether;
43     uint constant internal magnitude = 2**64;
44 
45     // proof of stake (defaults at 50 tokens)
46     uint public stakingRequirement = 50e18;
47 
48 
49    /*===============================
50     =            STORAGE           =
51     ==============================*/
52     
53     // amount of shares for each address (scaled number)
54     mapping(address => uint) internal tokenBalanceLedger_;
55     mapping(address => uint) internal referralBalance_;
56     mapping(address => int) internal payoutsTo_;
57     uint internal tokenSupply_ = 0;
58     uint internal profitPerShare_;
59 
60 
61     /*==============================
62     =            EVENTS            =
63     ==============================*/
64     
65     event onTokenPurchase(
66         address indexed customerAddress,
67         uint incomingEthereum,
68         uint tokensMinted,
69         address indexed referredBy
70     );
71 
72     event onTokenSell(
73         address indexed customerAddress,
74         uint tokensBurned,
75         uint ethereumEarned
76     );
77 
78     event onReinvestment(
79         address indexed customerAddress,
80         uint ethereumReinvested,
81         uint tokensMinted
82     );
83 
84     event onWithdraw(
85         address indexed customerAddress,
86         uint ethereumWithdrawn
87     );
88 
89     // ERC20
90     event Transfer(
91         address indexed from,
92         address indexed to,
93         uint tokens
94     );
95 
96 
97     /*=======================================
98     =            CONSTRUCTOR                =
99     =======================================*/
100     
101     function PoHarj() public payable {
102         // Owner can only pre-mine once (0.999ETH)
103         purchaseTokens(msg.value, 0x0);
104     }
105 
106 
107     /*=======================================
108     =           PUBLIC FUNCTIONS            =
109     =======================================*/
110 
111     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
112     function buy(address _referredBy) public payable returns (uint) {
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
127         uint _dividends = myDividends(false); // retrieve ref. bonus later in the code
128 
129         // pay out the dividends virtually
130         address _customerAddress = msg.sender;
131         payoutsTo_[_customerAddress] +=  (int) (_dividends * magnitude);
132 
133         // retrieve ref. bonus
134         _dividends += referralBalance_[_customerAddress];
135         referralBalance_[_customerAddress] = 0;
136 
137         // dispatch a buy order with the virtualized "withdrawn dividends"
138         uint _tokens = purchaseTokens(_dividends, 0x0);
139 
140         // fire event
141         onReinvestment(_customerAddress, _dividends, _tokens);
142     }
143 
144     /// @dev Alias of sell() and withdraw().
145     function exit() public {
146         // get token count for caller & sell them all
147         address _customerAddress = msg.sender;
148         uint _tokens = tokenBalanceLedger_[_customerAddress];
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
159         uint _dividends = myDividends(false); // get ref. bonus later in the code
160 
161         // update dividend tracker
162         payoutsTo_[_customerAddress] +=  (int) (_dividends * magnitude);
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
176     function sell(uint _amountOfTokens) onlyBagholders public {
177         // setup data
178         address _customerAddress = msg.sender;
179         // russian hackers BTFO
180         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
181         uint _tokens = _amountOfTokens;
182         uint _ethereum = tokensToEthereum_(_tokens);
183         uint _dividends = SafeMath.div(_ethereum, dividendFee_);
184         uint _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
185 
186         // burn the sold tokens
187         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
188         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
189 
190         // update dividends tracker
191         int _updatedPayouts = (int) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
192         payoutsTo_[_customerAddress] -= _updatedPayouts;
193 
194         // dividing by zero is a bad idea
195         if (tokenSupply_ > 0) {
196             // update the amount of dividends per token
197             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
198         }
199 
200         // fire event
201         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
202     }
203 
204 
205     /**
206      * @dev Transfer tokens from the caller to a new holder.
207      *  Remember, there's a 20% fee here as well.
208      */
209     function transfer(address _toAddress, uint _amountOfTokens) onlyBagholders public returns (bool) {
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
221         // liquify 20% of the tokens that are transfered
222         // these are dispersed to shareholders
223         uint _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
224         uint _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
225         uint _dividends = tokensToEthereum_(_tokenFee);
226 
227         // burn the fee tokens
228         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
229 
230         // exchange tokens
231         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
232         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
233 
234         // update dividend trackers
235         payoutsTo_[_customerAddress] -= (int) (profitPerShare_ * _amountOfTokens);
236         payoutsTo_[_toAddress] += (int) (profitPerShare_ * _taxedTokens);
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
252     /**
253      * @dev Method to view the current Ethereum stored in the contract
254      *  Example: totalEthereumBalance()
255      */
256     function totalEthereumBalance() public view returns (uint) {
257         return this.balance;
258     }
259 
260     /// @dev Retrieve the total token supply.
261     function totalSupply() public view returns (uint) {
262         return tokenSupply_;
263     }
264 
265     /// @dev Retrieve the tokens owned by the caller.
266     function myTokens() public view returns (uint) {
267         address _customerAddress = msg.sender;
268         return balanceOf(_customerAddress);
269     }
270 
271     /**
272      * @dev Retrieve the dividends owned by the caller.
273      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
274      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
275      *  But in the internal calculations, we want them separate.
276      */
277     function myDividends(bool _includeReferralBonus) public view returns (uint) {
278         address _customerAddress = msg.sender;
279         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
280     }
281 
282     /// @dev Retrieve the token balance of any single address.
283     function balanceOf(address _customerAddress) public view returns (uint) {
284         return tokenBalanceLedger_[_customerAddress];
285     }
286 
287     /**
288      * Retrieve the dividend balance of any single address.
289      */
290     function dividendsOf(address _customerAddress) public view returns (uint) {
291         return (uint) ((int)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
292     }
293 
294     /// @dev Return the buy price of 1 individual token.
295     function sellPrice() public view returns (uint) {
296         // our calculation relies on the token supply, so we need supply. Doh.
297         if (tokenSupply_ == 0) {
298             return tokenPriceInitial_ - tokenPriceIncremental_;
299         } else {
300             uint _ethereum = tokensToEthereum_(1e18);
301             uint _dividends = SafeMath.div(_ethereum, dividendFee_  );
302             uint _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
303             return _taxedEthereum;
304         }
305     }
306 
307     /// @dev Return the sell price of 1 individual token.
308     function buyPrice() public view returns (uint) {
309         // our calculation relies on the token supply, so we need supply. Doh.
310         if (tokenSupply_ == 0) {
311             return tokenPriceInitial_ + tokenPriceIncremental_;
312         } else {
313             uint _ethereum = tokensToEthereum_(1e18);
314             uint _dividends = SafeMath.div(_ethereum, dividendFee_  );
315             uint _taxedEthereum = SafeMath.add(_ethereum, _dividends);
316             return _taxedEthereum;
317         }
318     }
319 
320     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
321     function calculateTokensReceived(uint _ethereumToSpend) public view returns (uint) {
322         uint _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
323         uint _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
324         uint _amountOfTokens = ethereumToTokens_(_taxedEthereum);
325 
326         return _amountOfTokens;
327     }
328 
329     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
330     function calculateEthereumReceived(uint _tokensToSell) public view returns (uint) {
331         require(_tokensToSell <= tokenSupply_);
332         uint _ethereum = tokensToEthereum_(_tokensToSell);
333         uint _dividends = SafeMath.div(_ethereum, dividendFee_);
334         uint _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
335         return _taxedEthereum;
336     }
337 
338 
339     /*==========================================
340     =            INTERNAL FUNCTIONS            =
341     ==========================================*/
342     function purchaseTokens(uint _incomingEthereum, address _referredBy) internal returns (uint) {
343         // data setup
344         address _customerAddress = msg.sender;
345         uint _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
346         uint _referralBonus = SafeMath.div(_undividedDividends, 3);
347         uint _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
348         uint _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
349         uint _amountOfTokens = ethereumToTokens_(_taxedEthereum);
350         uint _fee = _dividends * magnitude;
351 
352         // no point in continuing execution if OP is a poorfag russian hacker
353         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
354         // (or hackers)
355         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
356         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
357 
358         // is the user referred by a masternode?
359         if (
360             // is this a referred purchase?
361             _referredBy != 0x0000000000000000000000000000000000000000 &&
362 
363             // no cheating!
364             _referredBy != _customerAddress &&
365 
366             // does the referrer have at least X whole tokens?
367             // i.e is the referrer a godly chad masternode
368             tokenBalanceLedger_[_referredBy] >= stakingRequirement
369         ) {
370             // wealth redistribution
371             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
372         } else {
373             // no ref purchase
374             // add the referral bonus back to the global dividends cake
375             _dividends = SafeMath.add(_dividends, _referralBonus);
376             _fee = _dividends * magnitude;
377         }
378 
379         // we can't give people infinite ethereum
380         if (tokenSupply_ > 0) {
381 
382             // add tokens to the pool
383             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
384 
385             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
386             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
387 
388             // calculate the amount of tokens the customer receives over his purchase
389             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
390 
391         } else {
392             // add tokens to the pool
393             tokenSupply_ = _amountOfTokens;
394         }
395 
396         // update circulating supply & the ledger address for the customer
397         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
398 
399         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
400         //really i know you think you do but you don't
401         int _updatedPayouts = (int) ((profitPerShare_ * _amountOfTokens) - _fee);
402         payoutsTo_[_customerAddress] += _updatedPayouts;
403 
404         // fire event
405         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
406 
407         return _amountOfTokens;
408     }
409 
410     /**
411      * Calculate Token price based on an amount of incoming ethereum
412      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
413      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
414      */
415     function ethereumToTokens_(uint _ethereum) internal view returns (uint) {
416         uint _tokenPriceInitial = tokenPriceInitial_ * 1e18;
417         uint _tokensReceived =
418          (
419             (
420                 // underflow attempts BTFO
421                 SafeMath.sub(
422                     (sqrt
423                         (
424                             (_tokenPriceInitial**2)
425                             +
426                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
427                             +
428                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
429                             +
430                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
431                         )
432                     ), _tokenPriceInitial
433                 )
434             )/(tokenPriceIncremental_)
435         )-(tokenSupply_)
436         ;
437 
438         return _tokensReceived;
439     }
440 
441     /**
442      * @dev Calculate token sell value.
443      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
444      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
445      */
446     function tokensToEthereum_(uint _tokens) internal view returns (uint) {
447         uint tokens_ = (_tokens + 1e18);
448         uint _tokenSupply = (tokenSupply_ + 1e18);
449         uint _etherReceived =
450         (
451             // underflow attempts BTFO
452             SafeMath.sub(
453                 (
454                     (
455                         (
456                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
457                         )-tokenPriceIncremental_
458                     )*(tokens_ - 1e18)
459                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
460             )
461         /1e18);
462         return _etherReceived;
463     }
464 
465     /// @dev This is where all your gas goes.
466     function sqrt(uint x) internal pure returns (uint y) {
467         uint z = (x + 1) / 2;
468         y = x;
469         while (z < y) {
470             y = z;
471             z = (x / z + z) / 2;
472         }
473     }
474 
475 
476     /*=================================
477     =            MODIFIERS            =
478     =================================*/
479 
480     /// @dev Only people with tokens
481     modifier onlyBagholders {
482         require(myTokens() > 0);
483         _;
484     }
485 
486     /// @dev Only people with profits
487     modifier onlyStronghands {
488         require(myDividends(true) > 0);
489         _;
490     }
491 
492 
493 }
494 
495 /**
496  * @title SafeMath
497  * @dev Math operations with safety checks that throw on error
498  */
499 library SafeMath {
500 
501     /**
502     * @dev Multiplies two numbers, throws on overflow.
503     */
504     function mul(uint a, uint b) internal pure returns (uint) {
505         if (a == 0) {
506             return 0;
507         }
508         uint c = a * b;
509         assert(c / a == b);
510         return c;
511     }
512 
513     /**
514     * @dev Integer division of two numbers, truncating the quotient.
515     */
516     function div(uint a, uint b) internal pure returns (uint) {
517         // assert(b > 0); // Solidity automatically throws when dividing by 0
518         uint c = a / b;
519         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
520         return c;
521     }
522 
523     /**
524     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
525     */
526     function sub(uint a, uint b) internal pure returns (uint) {
527         assert(b <= a);
528         return a - b;
529     }
530 
531     /**
532     * @dev Adds two numbers, throws on overflow.
533     */
534     function add(uint a, uint b) internal pure returns (uint) {
535         uint c = a + b;
536         assert(c >= a);
537         return c;
538     }
539 }