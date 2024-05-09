1 pragma solidity 0.4.20;
2 
3 /*===========================================
4 =    [ Proof of Satoshi Nakamoto (20%) ]    =
5 =          https://posatoshi.com/           =
6 =        https://discord.gg/ENXNGHc         =
7 =============================================
8 
9   _________       __               .__    .__              
10  /   _____/____ _/  |_  ____  _____|  |__ |__|             
11  \_____  \\__  \\   __\/  _ \/  ___/  |  \|  |             
12  /        \/ __ \|  | (  <_> )___ \|   Y  \  |             
13 /_______  (____  /__|  \____/____  >___|  /__|             
14         \/     \/                \/     \/                 
15  _______          __                           __          
16  \      \ _____  |  | _______    _____   _____/  |_  ____  
17  /   |   \\__  \ |  |/ /\__  \  /     \ /  _ \   __\/  _ \ 
18 /    |    \/ __ \|    <  / __ \|  Y Y  (  <_> )  | (  <_> )
19 \____|__  (____  /__|_ \(____  /__|_|  /\____/|__|  \____/ 
20         \/     \/     \/     \/      \/                    
21 
22 > Where It All Begins... - @2018-05-01T02:00:00Z
23 
24 * -> Features!
25 * All the features from the original Po contract, with dividend fee 20%:
26 * [x] Highly Secure: Hundreds of thousands of investers have invested in the original contract.
27 * [X] Purchase/Sell: You can perform partial sell orders. If you succumb to weak hands, you don't have to dump all of your bags.
28 * [x] Purchase/Sell: You can transfer tokens between wallets. Trading is possible from within the contract.
29 * [x] Masternodes: The implementation of Ethereum Staking in the world.
30 * [x] Masternodes: Holding 50 PoSatoshi Tokens allow you to generate a Masternode link, Masternode links are used as unique entry points to the contract.
31 * [x] Masternodes: All players who enter the contract through your Masternode have 30% of their 20% dividends fee rerouted from the master-node, to the node-master.
32 *
33 * -> Who worked not this project?
34 * - Satashi Nakamoto (GOD)
35 * - Mantso (Original Program)
36 *
37 * -> Owner of contract can:
38 * - Low pre-mine (0.999ETH)
39 * - And nothing else
40 *
41 * -> Owner of contract CANNOT:
42 * - exit scam
43 * - kill the contract
44 * - take funds
45 * - pause the contract
46 * - disable withdrawals
47 * - change the price of tokens
48 *
49 * -> THE FOMO IS REAL!! ** https://posatoshi.com/ **
50 */
51 
52 contract PoSatoshi {
53 
54 
55     /*=====================================
56     =            CONFIGURABLES            =
57     =====================================*/
58 
59     uint beginTime = 1525140000; // GMT: Tuesday, May 1, 2018 2:00:00 AM
60 
61     string public name = "Proof of Satoshi Nakamoto";
62     string public symbol = "PoSatoshi";
63     uint8 constant public decimals = 18;
64     uint8 constant internal dividendFee_ = 5; // 20% Dividends (In & Out)
65     uint constant internal tokenPriceInitial_ = 0.0000001 ether;
66     uint constant internal tokenPriceIncremental_ = 0.00000001 ether;
67     uint constant internal magnitude = 2**64;
68 
69     // proof of stake (defaults at 50 tokens)
70     uint public stakingRequirement = 50e18;
71 
72 
73    /*===============================
74     =            STORAGE           =
75     ==============================*/
76     
77     // amount of shares for each address (scaled number)
78     mapping(address => uint) internal tokenBalanceLedger_;
79     mapping(address => uint) internal referralBalance_;
80     mapping(address => int) internal payoutsTo_;
81     uint internal tokenSupply_ = 0;
82     uint internal profitPerShare_;
83 
84 
85     /*==============================
86     =            EVENTS            =
87     ==============================*/
88     
89     event onTokenPurchase(
90         address indexed customerAddress,
91         uint incomingEthereum,
92         uint tokensMinted,
93         address indexed referredBy
94     );
95 
96     event onTokenSell(
97         address indexed customerAddress,
98         uint tokensBurned,
99         uint ethereumEarned
100     );
101 
102     event onReinvestment(
103         address indexed customerAddress,
104         uint ethereumReinvested,
105         uint tokensMinted
106     );
107 
108     event onWithdraw(
109         address indexed customerAddress,
110         uint ethereumWithdrawn
111     );
112 
113     // ERC20
114     event Transfer(
115         address indexed from,
116         address indexed to,
117         uint tokens
118     );
119 
120 
121     /*=======================================
122     =            CONSTRUCTOR                =
123     =======================================*/
124     
125     function PoSatoshi() public payable {
126         // Owner can only pre-mine once (0.999ETH)
127         purchaseTokens(msg.value, 0x0);
128     }
129 
130 
131     /*=======================================
132     =           PUBLIC FUNCTIONS            =
133     =======================================*/
134 
135     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
136     function buy(address _referredBy) public payable returns (uint) {
137         require(now >= beginTime);
138 
139         purchaseTokens(msg.value, _referredBy);
140     }
141 
142     /**
143      * @dev Fallback function to handle ethereum that was send straight to the contract
144      *  Unfortunately we cannot use a referral address this way.
145      */
146     function() payable public {
147         require(now >= beginTime);
148 
149         purchaseTokens(msg.value, 0x0);
150     }
151 
152     /// @dev Converts all of caller's dividends to tokens.
153     function reinvest() onlyStronghands public {
154         // fetch dividends
155         uint _dividends = myDividends(false); // retrieve ref. bonus later in the code
156 
157         // pay out the dividends virtually
158         address _customerAddress = msg.sender;
159         payoutsTo_[_customerAddress] +=  (int) (_dividends * magnitude);
160 
161         // retrieve ref. bonus
162         _dividends += referralBalance_[_customerAddress];
163         referralBalance_[_customerAddress] = 0;
164 
165         // dispatch a buy order with the virtualized "withdrawn dividends"
166         uint _tokens = purchaseTokens(_dividends, 0x0);
167 
168         // fire event
169         onReinvestment(_customerAddress, _dividends, _tokens);
170     }
171 
172     /// @dev Alias of sell() and withdraw().
173     function exit() public {
174         // get token count for caller & sell them all
175         address _customerAddress = msg.sender;
176         uint _tokens = tokenBalanceLedger_[_customerAddress];
177         if (_tokens > 0) sell(_tokens);
178 
179         // lambo delivery service
180         withdraw();
181     }
182 
183     /// @dev Withdraws all of the callers earnings.
184     function withdraw() onlyStronghands public {
185         // setup data
186         address _customerAddress = msg.sender;
187         uint _dividends = myDividends(false); // get ref. bonus later in the code
188 
189         // update dividend tracker
190         payoutsTo_[_customerAddress] +=  (int) (_dividends * magnitude);
191 
192         // add ref. bonus
193         _dividends += referralBalance_[_customerAddress];
194         referralBalance_[_customerAddress] = 0;
195 
196         // lambo delivery service
197         _customerAddress.transfer(_dividends);
198 
199         // fire event
200         onWithdraw(_customerAddress, _dividends);
201     }
202 
203     /// @dev Liquifies tokens to ethereum.
204     function sell(uint _amountOfTokens) onlyBagholders public {
205         // setup data
206         address _customerAddress = msg.sender;
207         // russian hackers BTFO
208         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
209         uint _tokens = _amountOfTokens;
210         uint _ethereum = tokensToEthereum_(_tokens);
211         uint _dividends = SafeMath.div(_ethereum, dividendFee_);
212         uint _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
213 
214         // burn the sold tokens
215         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
216         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
217 
218         // update dividends tracker
219         int _updatedPayouts = (int) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
220         payoutsTo_[_customerAddress] -= _updatedPayouts;
221 
222         // dividing by zero is a bad idea
223         if (tokenSupply_ > 0) {
224             // update the amount of dividends per token
225             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
226         }
227 
228         // fire event
229         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
230     }
231 
232 
233     /**
234      * @dev Transfer tokens from the caller to a new holder.
235      *  Remember, there's a 20% fee here as well.
236      */
237     function transfer(address _toAddress, uint _amountOfTokens) onlyBagholders public returns (bool) {
238         // setup
239         address _customerAddress = msg.sender;
240 
241         // make sure we have the requested tokens
242         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
243 
244         // withdraw all outstanding dividends first
245         if (myDividends(true) > 0) {
246             withdraw();
247         }
248 
249         // liquify 20% of the tokens that are transfered
250         // these are dispersed to shareholders
251         uint _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
252         uint _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
253         uint _dividends = tokensToEthereum_(_tokenFee);
254 
255         // burn the fee tokens
256         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
257 
258         // exchange tokens
259         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
260         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
261 
262         // update dividend trackers
263         payoutsTo_[_customerAddress] -= (int) (profitPerShare_ * _amountOfTokens);
264         payoutsTo_[_toAddress] += (int) (profitPerShare_ * _taxedTokens);
265 
266         // disperse dividends among holders
267         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
268 
269         // fire event
270         Transfer(_customerAddress, _toAddress, _taxedTokens);
271 
272         // ERC20
273         return true;
274     }
275 
276 
277     /*=====================================
278     =      HELPERS AND CALCULATORS        =
279     =====================================*/
280     /**
281      * @dev Method to view the current Ethereum stored in the contract
282      *  Example: totalEthereumBalance()
283      */
284     function totalEthereumBalance() public view returns (uint) {
285         return this.balance;
286     }
287 
288     /// @dev Retrieve the total token supply.
289     function totalSupply() public view returns (uint) {
290         return tokenSupply_;
291     }
292 
293     /// @dev Retrieve the tokens owned by the caller.
294     function myTokens() public view returns (uint) {
295         address _customerAddress = msg.sender;
296         return balanceOf(_customerAddress);
297     }
298 
299     /**
300      * @dev Retrieve the dividends owned by the caller.
301      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
302      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
303      *  But in the internal calculations, we want them separate.
304      */
305     function myDividends(bool _includeReferralBonus) public view returns (uint) {
306         address _customerAddress = msg.sender;
307         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
308     }
309 
310     /// @dev Retrieve the token balance of any single address.
311     function balanceOf(address _customerAddress) public view returns (uint) {
312         return tokenBalanceLedger_[_customerAddress];
313     }
314 
315     /**
316      * Retrieve the dividend balance of any single address.
317      */
318     function dividendsOf(address _customerAddress) public view returns (uint) {
319         return (uint) ((int)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
320     }
321 
322     /// @dev Return the buy price of 1 individual token.
323     function sellPrice() public view returns (uint) {
324         // our calculation relies on the token supply, so we need supply. Doh.
325         if (tokenSupply_ == 0) {
326             return tokenPriceInitial_ - tokenPriceIncremental_;
327         } else {
328             uint _ethereum = tokensToEthereum_(1e18);
329             uint _dividends = SafeMath.div(_ethereum, dividendFee_  );
330             uint _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
331             return _taxedEthereum;
332         }
333     }
334 
335     /// @dev Return the sell price of 1 individual token.
336     function buyPrice() public view returns (uint) {
337         // our calculation relies on the token supply, so we need supply. Doh.
338         if (tokenSupply_ == 0) {
339             return tokenPriceInitial_ + tokenPriceIncremental_;
340         } else {
341             uint _ethereum = tokensToEthereum_(1e18);
342             uint _dividends = SafeMath.div(_ethereum, dividendFee_  );
343             uint _taxedEthereum = SafeMath.add(_ethereum, _dividends);
344             return _taxedEthereum;
345         }
346     }
347 
348     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
349     function calculateTokensReceived(uint _ethereumToSpend) public view returns (uint) {
350         uint _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
351         uint _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
352         uint _amountOfTokens = ethereumToTokens_(_taxedEthereum);
353 
354         return _amountOfTokens;
355     }
356 
357     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
358     function calculateEthereumReceived(uint _tokensToSell) public view returns (uint) {
359         require(_tokensToSell <= tokenSupply_);
360         uint _ethereum = tokensToEthereum_(_tokensToSell);
361         uint _dividends = SafeMath.div(_ethereum, dividendFee_);
362         uint _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
363         return _taxedEthereum;
364     }
365 
366 
367     /*==========================================
368     =            INTERNAL FUNCTIONS            =
369     ==========================================*/
370     function purchaseTokens(uint _incomingEthereum, address _referredBy) internal returns (uint) {
371         // data setup
372         address _customerAddress = msg.sender;
373         uint _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
374         uint _referralBonus = SafeMath.div(_undividedDividends, 3);
375         uint _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
376         uint _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
377         uint _amountOfTokens = ethereumToTokens_(_taxedEthereum);
378         uint _fee = _dividends * magnitude;
379 
380         // no point in continuing execution if OP is a poorfag russian hacker
381         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
382         // (or hackers)
383         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
384         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
385 
386         // is the user referred by a masternode?
387         if (
388             // is this a referred purchase?
389             _referredBy != 0x0000000000000000000000000000000000000000 &&
390 
391             // no cheating!
392             _referredBy != _customerAddress &&
393 
394             // does the referrer have at least X whole tokens?
395             // i.e is the referrer a godly chad masternode
396             tokenBalanceLedger_[_referredBy] >= stakingRequirement
397         ) {
398             // wealth redistribution
399             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
400         } else {
401             // no ref purchase
402             // add the referral bonus back to the global dividends cake
403             _dividends = SafeMath.add(_dividends, _referralBonus);
404             _fee = _dividends * magnitude;
405         }
406 
407         // we can't give people infinite ethereum
408         if (tokenSupply_ > 0) {
409 
410             // add tokens to the pool
411             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
412 
413             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
414             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
415 
416             // calculate the amount of tokens the customer receives over his purchase
417             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
418 
419         } else {
420             // add tokens to the pool
421             tokenSupply_ = _amountOfTokens;
422         }
423 
424         // update circulating supply & the ledger address for the customer
425         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
426 
427         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
428         //really i know you think you do but you don't
429         int _updatedPayouts = (int) ((profitPerShare_ * _amountOfTokens) - _fee);
430         payoutsTo_[_customerAddress] += _updatedPayouts;
431 
432         // fire event
433         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
434 
435         return _amountOfTokens;
436     }
437 
438     /**
439      * Calculate Token price based on an amount of incoming ethereum
440      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
441      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
442      */
443     function ethereumToTokens_(uint _ethereum) internal view returns (uint) {
444         uint _tokenPriceInitial = tokenPriceInitial_ * 1e18;
445         uint _tokensReceived =
446          (
447             (
448                 // underflow attempts BTFO
449                 SafeMath.sub(
450                     (sqrt
451                         (
452                             (_tokenPriceInitial**2)
453                             +
454                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
455                             +
456                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
457                             +
458                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
459                         )
460                     ), _tokenPriceInitial
461                 )
462             )/(tokenPriceIncremental_)
463         )-(tokenSupply_)
464         ;
465 
466         return _tokensReceived;
467     }
468 
469     /**
470      * @dev Calculate token sell value.
471      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
472      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
473      */
474     function tokensToEthereum_(uint _tokens) internal view returns (uint) {
475         uint tokens_ = (_tokens + 1e18);
476         uint _tokenSupply = (tokenSupply_ + 1e18);
477         uint _etherReceived =
478         (
479             // underflow attempts BTFO
480             SafeMath.sub(
481                 (
482                     (
483                         (
484                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
485                         )-tokenPriceIncremental_
486                     )*(tokens_ - 1e18)
487                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
488             )
489         /1e18);
490         return _etherReceived;
491     }
492 
493     /// @dev This is where all your gas goes.
494     function sqrt(uint x) internal pure returns (uint y) {
495         uint z = (x + 1) / 2;
496         y = x;
497         while (z < y) {
498             y = z;
499             z = (x / z + z) / 2;
500         }
501     }
502 
503 
504     /*=================================
505     =            MODIFIERS            =
506     =================================*/
507 
508     /// @dev Only people with tokens
509     modifier onlyBagholders {
510         require(myTokens() > 0);
511         _;
512     }
513 
514     /// @dev Only people with profits
515     modifier onlyStronghands {
516         require(myDividends(true) > 0);
517         _;
518     }
519 
520 
521 }
522 
523 /**
524  * @title SafeMath
525  * @dev Math operations with safety checks that throw on error
526  */
527 library SafeMath {
528 
529     /**
530     * @dev Multiplies two numbers, throws on overflow.
531     */
532     function mul(uint a, uint b) internal pure returns (uint) {
533         if (a == 0) {
534             return 0;
535         }
536         uint c = a * b;
537         assert(c / a == b);
538         return c;
539     }
540 
541     /**
542     * @dev Integer division of two numbers, truncating the quotient.
543     */
544     function div(uint a, uint b) internal pure returns (uint) {
545         // assert(b > 0); // Solidity automatically throws when dividing by 0
546         uint c = a / b;
547         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
548         return c;
549     }
550 
551     /**
552     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
553     */
554     function sub(uint a, uint b) internal pure returns (uint) {
555         assert(b <= a);
556         return a - b;
557     }
558 
559     /**
560     * @dev Adds two numbers, throws on overflow.
561     */
562     function add(uint a, uint b) internal pure returns (uint) {
563         uint c = a + b;
564         assert(c >= a);
565         return c;
566     }
567 }