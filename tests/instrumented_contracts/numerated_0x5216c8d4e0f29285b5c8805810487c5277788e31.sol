1 pragma solidity ^0.4.20;
2 
3 /*
4 * JIGSAW IS BACK
5 *
6 * YOU TOUGHT THE GAME WAS OVER? THINK AGAIN 
7 * ARE YOU READY TO PARTICIPATE? OR ARE YOU AFRAID? MAKE JIGSAW LAUGH!
8 * https://discord.gg/ZxEja6a
9 * Jiggs.io is the only official website!
10 * Only 1 token to activate your masterkey
11 * 20% IN / 25% OUT / 50% MASTERNODE - DONT LIKE IT? STAY AWAY! DIVIDENDS LOVERS ONLY!
12 * NO FUNNY ADMINISTRATOR/AMBASSADOR FUNCTIONS, FREEDOM TO EVERYONE!
13 * NO DEV FEES, WHO NEED DEV FEES IF THE SITE KEEPS RUNNING FOR $10 A MONTH? WHAT A BULLSHIT
14 */
15 
16 
17 contract JiggsRezurrection {
18 
19 
20     /*=================================
21     =            MODIFIERS            =
22     =================================*/
23 
24     /// @dev Only people with tokens
25     modifier onlyBagholders {
26         require(myTokens() > 0);
27         _;
28     }
29 
30     /// @dev Only people with profits
31     modifier onlyStronghands {
32         require(myDividends(true) > 0);
33         _;
34     }
35 
36 
37     /*==============================
38     =            EVENTS            =
39     ==============================*/
40 
41     event onTokenPurchase(
42         address indexed customerAddress,
43         uint256 incomingEthereum,
44         uint256 tokensMinted,
45         address indexed referredBy,
46         uint timestamp,
47         uint256 price
48     );
49 
50     event onTokenSell(
51         address indexed customerAddress,
52         uint256 tokensBurned,
53         uint256 ethereumEarned,
54         uint timestamp,
55         uint256 price
56     );
57 
58     event onReinvestment(
59         address indexed customerAddress,
60         uint256 ethereumReinvested,
61         uint256 tokensMinted
62     );
63 
64     event onWithdraw(
65         address indexed customerAddress,
66         uint256 ethereumWithdrawn
67     );
68 
69     // ERC20
70     event Transfer(
71         address indexed from,
72         address indexed to,
73         uint256 tokens
74     );
75 
76 
77     /*=====================================
78     =            CONFIGURABLES            =
79     =====================================*/
80 
81     string public name = "Jiggs Rezurrection";
82     string public symbol = "Jiggs";
83     uint8 constant public decimals = 18;
84 
85     /// NO BULLSHIT, WE ARE HERE TO EARN DIVIDENDS
86     uint8 constant internal entryFee_ = 25;
87 
88     /// THE AIR IS FOR FREE
89     uint8 constant internal transferFee_ = 10;
90 
91     /// NO MERCY WITH A EXIT EITHER
92     uint8 constant internal exitFee_ = 25;
93 
94     /// LETS GO CRAZY LIKE JIGSAW IS, EVERYTHING UNDER 50 MAKES HAVING A MASTERNODE USELESS
95     uint8 constant internal refferalFee_ = 50;
96 
97     uint256 constant internal tokenPriceInitial_ = 0.0000000001 ether;
98     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
99     uint256 constant internal magnitude = 2 ** 64;
100 
101     /// TOUCH 1 JIGGS FOR A MASTERNODE
102     uint256 public stakingRequirement = 1e18;
103 
104 
105    /*=================================
106     =            DATASETS            =
107     ================================*/
108 
109     // amount of shares for each address (scaled number)
110     mapping(address => uint256) internal tokenBalanceLedger_;
111     mapping(address => uint256) internal referralBalance_;
112     mapping(address => int256) internal payoutsTo_;
113     uint256 internal tokenSupply_;
114     uint256 internal profitPerShare_;
115 
116 
117     /*=======================================
118     =            PUBLIC FUNCTIONS           =
119     =======================================*/
120 
121     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
122     function buy(address _referredBy) public payable returns (uint256) {
123         purchaseTokens(msg.value, _referredBy);
124     }
125 
126     /**
127      * @dev Fallback function to handle ethereum that was send straight to the contract
128      *  Unfortunately we cannot use a referral address this way.
129      */
130     function() payable public {
131         purchaseTokens(msg.value, 0x0);
132     }
133 
134     /// @dev Converts all of caller's dividends to tokens.
135     function reinvest() onlyStronghands public {
136         // fetch dividends
137         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
138 
139         // pay out the dividends virtually
140         address _customerAddress = msg.sender;
141         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
142 
143         // retrieve ref. bonus
144         _dividends += referralBalance_[_customerAddress];
145         referralBalance_[_customerAddress] = 0;
146 
147         // dispatch a buy order with the virtualized "withdrawn dividends"
148         uint256 _tokens = purchaseTokens(_dividends, 0x0);
149 
150         // fire event
151         onReinvestment(_customerAddress, _dividends, _tokens);
152     }
153 
154     /// @dev Alias of sell() and withdraw().
155     function exit() public {
156         // get token count for caller & sell them all
157         address _customerAddress = msg.sender;
158         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
159         if (_tokens > 0) sell(_tokens);
160 
161         // lambo delivery service
162         withdraw();
163     }
164 
165     /// @dev Withdraws all of the callers earnings.
166     function withdraw() onlyStronghands public {
167         // setup data
168         address _customerAddress = msg.sender;
169         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
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
182         onWithdraw(_customerAddress, _dividends);
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
211         onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
212     }
213 
214 
215     /**
216      * @dev Transfer tokens from the caller to a new holder.
217      *  Remember, there's a 15% fee here as well.
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
228             withdraw();
229         }
230 
231         // liquify 10% of the tokens that are transfered
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
252         Transfer(_customerAddress, _toAddress, _taxedTokens);
253 
254         // ERC20
255         return true;
256     }
257 
258 
259     /*=====================================
260     =      HELPERS AND CALCULATORS        =
261     =====================================*/
262 
263     /**
264      * @dev Method to view the current Ethereum stored in the contract
265      *  Example: totalEthereumBalance()
266      */
267     function totalEthereumBalance() public view returns (uint256) {
268         return this.balance;
269     }
270 
271     /// @dev Retrieve the total token supply.
272     function totalSupply() public view returns (uint256) {
273         return tokenSupply_;
274     }
275 
276     /// @dev Retrieve the tokens owned by the caller.
277     function myTokens() public view returns (uint256) {
278         address _customerAddress = msg.sender;
279         return balanceOf(_customerAddress);
280     }
281 
282     /**
283      * @dev Retrieve the dividends owned by the caller.
284      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
285      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
286      *  But in the internal calculations, we want them separate.
287      */
288     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
289         address _customerAddress = msg.sender;
290         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
291     }
292 
293     /// @dev Retrieve the token balance of any single address.
294     function balanceOf(address _customerAddress) public view returns (uint256) {
295         return tokenBalanceLedger_[_customerAddress];
296     }
297 
298     /// @dev Retrieve the dividend balance of any single address.
299     function dividendsOf(address _customerAddress) public view returns (uint256) {
300         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
301     }
302 
303     /// @dev Return the sell price of 1 individual token.
304     function sellPrice() public view returns (uint256) {
305         // our calculation relies on the token supply, so we need supply. Doh.
306         if (tokenSupply_ == 0) {
307             return tokenPriceInitial_ - tokenPriceIncremental_;
308         } else {
309             uint256 _ethereum = tokensToEthereum_(1e18);
310             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
311             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
312 
313             return _taxedEthereum;
314         }
315     }
316 
317     /// @dev Return the buy price of 1 individual token.
318     function buyPrice() public view returns (uint256) {
319         // our calculation relies on the token supply, so we need supply. Doh.
320         if (tokenSupply_ == 0) {
321             return tokenPriceInitial_ + tokenPriceIncremental_;
322         } else {
323             uint256 _ethereum = tokensToEthereum_(1e18);
324             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
325             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
326 
327             return _taxedEthereum;
328         }
329     }
330 
331     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
332     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
333         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
334         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
335         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
336 
337         return _amountOfTokens;
338     }
339 
340     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
341     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
342         require(_tokensToSell <= tokenSupply_);
343         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
344         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
345         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
346         return _taxedEthereum;
347     }
348 
349 
350     /*==========================================
351     =            INTERNAL FUNCTIONS            =
352     ==========================================*/
353 
354     /// @dev Internal function to actually purchase the tokens.
355     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
356         // data setup
357         address _customerAddress = msg.sender;
358         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
359         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
360         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
361         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
362         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
363         uint256 _fee = _dividends * magnitude;
364 
365         // no point in continuing execution if OP is a poorfag russian hacker
366         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
367         // (or hackers)
368         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
369         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
370 
371         // is the user referred by a masternode?
372         if (
373             // is this a referred purchase?
374             _referredBy != 0x0000000000000000000000000000000000000000 &&
375 
376             // no cheating!
377             _referredBy != _customerAddress &&
378 
379             // does the referrer have at least X whole tokens?
380             // i.e is the referrer a godly chad masternode
381             tokenBalanceLedger_[_referredBy] >= stakingRequirement
382         ) {
383             // wealth redistribution
384             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
385         } else {
386             // no ref purchase
387             // add the referral bonus back to the global dividends cake
388             _dividends = SafeMath.add(_dividends, _referralBonus);
389             _fee = _dividends * magnitude;
390         }
391 
392         // we can't give people infinite ethereum
393         if (tokenSupply_ > 0) {
394             // add tokens to the pool
395             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
396 
397             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
398             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
399 
400             // calculate the amount of tokens the customer receives over his purchase
401             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
402         } else {
403             // add tokens to the pool
404             tokenSupply_ = _amountOfTokens;
405         }
406 
407         // update circulating supply & the ledger address for the customer
408         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
409 
410         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
411         // really i know you think you do but you don't
412         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
413         payoutsTo_[_customerAddress] += _updatedPayouts;
414 
415         // fire event
416         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
417 
418         return _amountOfTokens;
419     }
420 
421     /**
422      * @dev Calculate Token price based on an amount of incoming ethereum
423      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
424      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
425      */
426     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
427         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
428         uint256 _tokensReceived =
429          (
430             (
431                 // underflow attempts BTFO
432                 SafeMath.sub(
433                     (sqrt
434                         (
435                             (_tokenPriceInitial ** 2)
436                             +
437                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
438                             +
439                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
440                             +
441                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
442                         )
443                     ), _tokenPriceInitial
444                 )
445             ) / (tokenPriceIncremental_)
446         ) - (tokenSupply_);
447 
448         return _tokensReceived;
449     }
450 
451     /**
452      * @dev Calculate token sell value.
453      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
454      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
455      */
456     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
457         uint256 tokens_ = (_tokens + 1e18);
458         uint256 _tokenSupply = (tokenSupply_ + 1e18);
459         uint256 _etherReceived =
460         (
461             // underflow attempts BTFO
462             SafeMath.sub(
463                 (
464                     (
465                         (
466                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
467                         ) - tokenPriceIncremental_
468                     ) * (tokens_ - 1e18)
469                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
470             )
471         / 1e18);
472 
473         return _etherReceived;
474     }
475 
476     /// @dev This is where all your gas goes.
477     function sqrt(uint256 x) internal pure returns (uint256 y) {
478         uint256 z = (x + 1) / 2;
479         y = x;
480 
481         while (z < y) {
482             y = z;
483             z = (x / z + z) / 2;
484         }
485     }
486 
487 
488 }
489 
490 /**
491  * @title SafeMath
492  * @dev Math operations with safety checks that throw on error
493  */
494 library SafeMath {
495 
496     /**
497     * @dev Multiplies two numbers, throws on overflow.
498     */
499     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
500         if (a == 0) {
501             return 0;
502         }
503         uint256 c = a * b;
504         assert(c / a == b);
505         return c;
506     }
507 
508     /**
509     * @dev Integer division of two numbers, truncating the quotient.
510     */
511     function div(uint256 a, uint256 b) internal pure returns (uint256) {
512         // assert(b > 0); // Solidity automatically throws when dividing by 0
513         uint256 c = a / b;
514         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
515         return c;
516     }
517 
518     /**
519     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
520     */
521     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
522         assert(b <= a);
523         return a - b;
524     }
525 
526     /**
527     * @dev Adds two numbers, throws on overflow.
528     */
529     function add(uint256 a, uint256 b) internal pure returns (uint256) {
530         uint256 c = a + b;
531         assert(c >= a);
532         return c;
533     }
534 
535 }