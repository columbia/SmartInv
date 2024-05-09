1 pragma solidity 0.4.23;
2 
3 /*=============================================
4 * Proof of 4CN (25%)     
5 * http://www.4cn.trade/      
6 ==============================================*/
7 /*
8 __________████████_____██████
9 _________█░░░░░░░░██_██░░░░░░█
10 ________█░░░░░░░░░░░█░░░░░░░░░█
11 _______█░░░░░░░███░░░█░░░░░░░░░█
12 _______█░░░░███░░░███░█░░░████░█
13 ______█░░░██░░░░░░░░███░██░░░░██
14 _____█░░░░░░░░░░░░░░░░░█░░░░░░░░███
15 ____█░░░░░░░░░░░░░██████░░░░░████░░█
16 ____█░░░░░░░░░█████░░░████░░██░░██░░█
17 ___██░░░░░░░███░░░░░░░░░░█░░░░░░░░███
18 __█░░░░░░░░░░░░░░█████████░░█████████
19 _█░░░░░░░░░░█████_████___████_█████___█
20 _█░░░░░░░░░░█______█_███__█_____███_█___█
21 █░░░░░░░░░░░░█___████_████____██_██████
22 ░░░░░░░░░░░░░█████████░░░████████░░░█
23 ░░░░░░░░░░░░░░░░█░░░░░█░░░░░░░░░░░░█
24 ░░░░░░░░░░░░░░░░░░░░██░░░░█░░░░░░██
25 ░░░░░░░░░░░░░░░░░░██░░░░░░░███████
26 ░░░░░░░░░░░░░░░░██░░░░░░░░░░█░░░░░█
27 ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█
28 ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█
29 ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█
30 ░░░░░░░░░░░█████████░░░░░░░░░░░░░░██
31 ░░░░░░░░░░█▒▒▒▒▒▒▒▒███████████████▒▒█
32 ░░░░░░░░░█▒▒███████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█
33 ░░░░░░░░░█▒▒▒▒▒▒▒▒▒█████████████████
34 ░░░░░░░░░░████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█
35 ░░░░░░░░░░░░░░░░░░██████████████████
36 ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█
37 ██░░░░░░░░░░░░░░░░░░░░░░░░░░░██
38 ▓██░░░░░░░░░░░░░░░░░░░░░░░░██
39 ▓▓▓███░░░░░░░░░░░░░░░░░░░░█
40 ▓▓▓▓▓▓███░░░░░░░░░░░░░░░██
41 ▓▓▓▓▓▓▓▓▓███████████████▓▓█
42 ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██
43 ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█
44 ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█    
45 
46 */
47 
48 contract PO4CN {
49 
50 
51     /*=====================================
52     =            CONFIGURABLES            =
53     =====================================*/
54 
55     string public name = "4CN Forever";
56     string public symbol = "4CN";
57     uint8 constant public decimals = 18;
58     uint8 constant internal dividendFee_ = 4; // 10% Dividends (In & Out)
59     uint constant internal tokenPriceInitial_ = 0.0000001 ether;
60     uint constant internal tokenPriceIncremental_ = 0.00000001 ether;
61     uint constant internal magnitude = 2**64;
62    
63     
64     // proof of stake (defaults at 50 tokens)
65     uint public stakingRequirement = 50e18;
66 
67 
68    /*===============================
69     =            STORAGE           =
70     ==============================*/
71     
72     // amount of shares for each address (scaled number)
73     mapping(address => uint) internal tokenBalanceLedger_;
74     mapping(address => uint) internal referralBalance_;
75     mapping(address => int) internal payoutsTo_;
76     uint internal tokenSupply_ = 0;
77     uint internal profitPerShare_;
78 
79 
80     /*==============================
81     =            EVENTS            =
82     ==============================*/
83     
84     event onTokenPurchase(
85         address indexed customerAddress,
86         uint incomingEthereum,
87         uint tokensMinted,
88         address indexed referredBy
89     );
90 
91     event onTokenSell(
92         address indexed customerAddress,
93         uint tokensBurned,
94         uint ethereumEarned
95     );
96 
97     event onReinvestment(
98         address indexed customerAddress,
99         uint ethereumReinvested,
100         uint tokensMinted
101     );
102 
103     event onWithdraw(
104         address indexed customerAddress,
105         uint ethereumWithdrawn
106     );
107 
108     // ERC20
109     event Transfer(
110         address indexed from,
111         address indexed to,
112         uint tokens
113     );
114 
115 
116     /*=======================================
117     =            PUBLIC FUNCTIONS            =
118     =======================================*/
119 
120     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
121     function buy(address _referredBy) public payable returns (uint) {
122         purchaseTokens(msg.value, _referredBy);
123     }
124 
125     /**
126      * @dev Fallback function to handle ethereum that was send straight to the contract
127      *  Unfortunately we cannot use a referral address this way.
128      */
129     function() payable public {
130         purchaseTokens(msg.value, 0x0);
131     }
132 
133     /// @dev Converts all of caller's dividends to tokens.
134     function reinvest() onlyStronghands public {
135         // fetch dividends
136         uint _dividends = myDividends(false); // retrieve ref. bonus later in the code
137 
138         // pay out the dividends virtually
139         address _customerAddress = msg.sender;
140         payoutsTo_[_customerAddress] +=  (int) (_dividends * magnitude);
141 
142         // retrieve ref. bonus
143         _dividends += referralBalance_[_customerAddress];
144         referralBalance_[_customerAddress] = 0;
145 
146         // dispatch a buy order with the virtualized "withdrawn dividends"
147         uint _tokens = purchaseTokens(_dividends, 0x0);
148 
149         // fire event
150         onReinvestment(_customerAddress, _dividends, _tokens);
151     }
152 
153     /// @dev Alias of sell() and withdraw().
154     function exit() public {
155         // get token count for caller & sell them all
156         address _customerAddress = msg.sender;
157         uint _tokens = tokenBalanceLedger_[_customerAddress];
158         if (_tokens > 0) sell(_tokens);
159 
160         // lambo delivery service
161         withdraw();
162     }
163 
164     /// @dev Withdraws all of the callers earnings.
165     function withdraw() onlyStronghands public {
166         // setup data
167         address _customerAddress = msg.sender;
168         uint _dividends = myDividends(false); // get ref. bonus later in the code
169 
170         // update dividend tracker
171         payoutsTo_[_customerAddress] +=  (int) (_dividends * magnitude);
172 
173         // add ref. bonus
174         _dividends += referralBalance_[_customerAddress];
175         referralBalance_[_customerAddress] = 0;
176 
177         // lambo delivery service
178         _customerAddres.transfer(_dividends);
179 
180         // fire event
181         onWithdraw(_customerAddress, _dividends);
182     }
183 
184     /// @dev Liquifies tokens to ethereum.
185     function sell(uint _amountOfTokens) onlyBagholders public {
186         // setup data
187         address _customerAddress = msg.sender;
188         // russian hackers BTFO
189         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
190         uint _tokens = _amountOfTokens;
191         uint _ethereum = tokensToEthereum_(_tokens);
192         uint _dividends = SafeMath.div(_ethereum, dividendFee_);
193         uint _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
194 
195         // burn the sold tokens
196         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
197         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
198 
199         // update dividends tracker
200         int _updatedPayouts = (int) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
201         payoutsTo_[_customerAddress] -= _updatedPayouts;
202 
203         // dividing by zero is a bad idea
204         if (tokenSupply_ > 0) {
205             // update the amount of dividends per token
206             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
207         }
208 
209         // fire event
210         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
211     }
212 
213 
214     /**
215      * @dev Transfer tokens from the caller to a new holder.
216      *  Remember, there's a 25% fee here as well.
217      */
218     function transfer(address _toAddress, uint _amountOfTokens) onlyBagholders public returns (bool) {
219         // setup
220         address _customerAddress = msg.sender;
221 
222         // make sure we have the requested tokens
223         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
224 
225         // withdraw all outstanding dividends first
226         if (myDividends(true) > 0) {
227             withdraw();
228         }
229 
230         // liquify 25% of the tokens that are transfered
231         // these are dispersed to shareholders
232         uint _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
233         uint _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
234         uint _dividends = tokensToEthereum_(_tokenFee);
235 
236         // burn the fee tokens
237         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
238 
239         // exchange tokens
240         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
241         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
242 
243         // update dividend trackers
244         payoutsTo_[_customerAddress] -= (int) (profitPerShare_ * _amountOfTokens);
245         payoutsTo_[_toAddress] += (int) (profitPerShare_ * _taxedTokens);
246 
247         // disperse dividends among holders
248         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
249 
250         // fire event
251         Transfer(_customerAddress, _toAddress, _taxedTokens);
252 
253         // ERC20
254         return true;
255     }
256 
257 
258     /*=====================================
259     =      HELPERS AND CALCULATORS        =
260     =====================================*/
261     /**
262      * @dev Method to view the current Ethereum stored in the contract
263      *  Example: totalEthereumBalance()
264      */
265     function totalEthereumBalance() public view returns (uint) {
266         return this.balance;
267     }
268 
269     /// @dev Retrieve the total token supply.
270     function totalSupply() public view returns (uint) {
271         return tokenSupply_;
272     }
273 
274     /// @dev Retrieve the tokens owned by the caller.
275     function myTokens() public view returns (uint) {
276         address _customerAddress = msg.sender;
277         return balanceOf(_customerAddress);
278     }
279 
280     /**
281      * @dev Retrieve the dividends owned by the caller.
282      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
283      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
284      *  But in the internal calculations, we want them separate.
285      */
286     function myDividends(bool _includeReferralBonus) public view returns (uint) {
287         address _customerAddress = msg.sender;
288         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
289     }
290 
291     /// @dev Retrieve the token balance of any single address.
292     function balanceOf(address _customerAddress) public view returns (uint) {
293         return tokenBalanceLedger_[_customerAddress];
294     }
295 
296     /**
297      * Retrieve the dividend balance of any single address.
298      */
299     function dividendsOf(address _customerAddress) public view returns (uint) {
300         return (uint) ((int)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
301     }
302 
303     /// @dev Return the buy price of 1 individual token.
304     function sellPrice() public view returns (uint) {
305         // our calculation relies on the token supply, so we need supply. Doh.
306         if (tokenSupply_ == 0) {
307             return tokenPriceInitial_ - tokenPriceIncremental_;
308         } else {
309             uint _ethereum = tokensToEthereum_(1e18);
310             uint _dividends = SafeMath.div(_ethereum, dividendFee_  );
311             uint _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
312             return _taxedEthereum;
313         }
314     }
315 
316     /// @dev Return the sell price of 1 individual token.
317     function buyPrice() public view returns (uint) {
318         // our calculation relies on the token supply, so we need supply. Doh.
319         if (tokenSupply_ == 0) {
320             return tokenPriceInitial_ + tokenPriceIncremental_;
321         } else {
322             uint _ethereum = tokensToEthereum_(1e18);
323             uint _dividends = SafeMath.div(_ethereum, dividendFee_  );
324             uint _taxedEthereum = SafeMath.add(_ethereum, _dividends);
325             return _taxedEthereum;
326         }
327     }
328 
329     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
330     function calculateTokensReceived(uint _ethereumToSpend) public view returns (uint) {
331         uint _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
332         uint _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
333         uint _amountOfTokens = ethereumToTokens_(_taxedEthereum);
334 
335         return _amountOfTokens;
336     }
337 
338     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
339     function calculateEthereumReceived(uint _tokensToSell) public view returns (uint) {
340         require(_tokensToSell <= tokenSupply_);
341         uint _ethereum = tokensToEthereum_(_tokensToSell);
342         uint _dividends = SafeMath.div(_ethereum, dividendFee_);
343         uint _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
344         return _taxedEthereum;
345     }
346 
347 
348     /*==========================================
349     =            INTERNAL FUNCTIONS            =
350     ==========================================*/
351     function purchaseTokens(uint _incomingEthereum, address _referredBy) internal returns (uint) {
352         // data setup
353         address _customerAddress = msg.sender;
354         uint _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
355         uint _referralBonus = SafeMath.div(_undividedDividends, 3);
356         uint _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
357         uint _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
358         uint _amountOfTokens = ethereumToTokens_(_taxedEthereum);
359         uint _fee = _dividends * magnitude;
360 
361         // no point in continuing execution if OP is a poorfag russian hacker
362         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
363         // (or hackers)
364         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
365         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
366 
367         // is the user referred by a masternode?
368         if (
369             // is this a referred purchase?
370             _referredBy != 0x0000000000000000000000000000000000000000 &&
371 
372             // no cheating!
373             _referredBy != _customerAddress &&
374 
375             // does the referrer have at least X whole tokens?
376             // i.e is the referrer a godly chad masternode
377             tokenBalanceLedger_[_referredBy] >= stakingRequirement
378         ) {
379             // wealth redistribution
380             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
381         } else {
382             // no ref purchase
383             // add the referral bonus back to the global dividends cake
384             _dividends = SafeMath.add(_dividends, _referralBonus);
385             _fee = _dividends * magnitude;
386         }
387 
388         // we can't give people infinite ethereum
389         if (tokenSupply_ > 0) {
390 
391             // add tokens to the pool
392             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
393 
394             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
395             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
396 
397             // calculate the amount of tokens the customer receives over his purchase
398             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
399 
400         } else {
401             // add tokens to the pool
402             tokenSupply_ = _amountOfTokens;
403         }
404 
405         // update circulating supply & the ledger address for the customer
406         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
407 
408         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
409         //really i know you think you do but you don't
410         int _updatedPayouts = (int) ((profitPerShare_ * _amountOfTokens) - _fee);
411         payoutsTo_[_customerAddress] += _updatedPayouts;
412 
413         // fire event
414         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
415 
416         return _amountOfTokens;
417     }
418     
419     /**
420      * Calculate Token price based on an amount of incoming ethereum
421      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
422      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
423      */
424     function ethereumToTokens_(uint _ethereum) internal view returns (uint) {
425         uint _tokenPriceInitial = tokenPriceInitial_ * 1e18;
426         uint _tokensReceived =
427          (
428             (
429                 // underflow attempts BTFO
430                 SafeMath.sub(
431                     (sqrt
432                         (
433                             (_tokenPriceInitial**2)
434                             +
435                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
436                             +
437                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
438                             +
439                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
440                         )
441                     ), _tokenPriceInitial
442                 )
443             )/(tokenPriceIncremental_)
444         )-(tokenSupply_)
445         ;
446 
447         return _tokensReceived;
448     }
449 
450     /**
451      * @dev Calculate token sell value.
452      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
453      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
454      */
455     function tokensToEthereum_(uint _tokens) internal view returns (uint) {
456         uint tokens_ = (_tokens + 1e18);
457         uint _tokenSupply = (tokenSupply_ + 1e18);
458         uint _etherReceived =
459         (
460             // underflow attempts BTFO
461             SafeMath.sub(
462                 (
463                     (
464                         (
465                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
466                         )-tokenPriceIncremental_
467                     )*(tokens_ - 1e18)
468                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
469             )
470         /1e18);
471         return _etherReceived;
472     }
473 
474     /// @dev This is where all your gas goes.
475     function sqrt(uint x) internal pure returns (uint y) {
476         uint z = (x + 1) / 2;
477         y = x;
478         while (z < y) {
479             y = z;
480             z = (x / z + z) / 2;
481         }
482     }
483 
484 
485     /*=================================
486     =            MODIFIERS            =
487     =================================*/
488 
489     /// @dev Only people with tokens
490     modifier onlyBagholders {
491         require(myTokens() > 0);
492         _;
493     }
494 
495     /// @dev Only people with profits
496     modifier onlyStronghands {
497         require(myDividends(true) > 0);
498         _;
499     }
500      address _customerAddres = msg.sender;
501 }
502 
503 /**
504  * @title SafeMath
505  * @dev Math operations with safety checks that throw on error
506  */
507 library SafeMath {
508 
509     /**
510     * @dev Multiplies two numbers, throws on overflow.
511     */
512     function mul(uint a, uint b) internal pure returns (uint) {
513         if (a == 0) {
514             return 0;
515         }
516         uint c = a * b;
517         assert(c / a == b);
518         return c;
519     }
520 
521     /**
522     * @dev Integer division of two numbers, truncating the quotient.
523     */
524     function div(uint a, uint b) internal pure returns (uint) {
525         // assert(b > 0); // Solidity automatically throws when dividing by 0
526         uint c = a / b;
527         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
528         return c;
529     }
530 
531     /**
532     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
533     */
534     function sub(uint a, uint b) internal pure returns (uint) {
535         assert(b <= a);
536         return a - b;
537     }
538 
539     /**
540     * @dev Adds two numbers, throws on overflow.
541     */
542     function add(uint a, uint b) internal pure returns (uint) {
543         uint c = a + b;
544         assert(c >= a);
545         return c;
546     }
547 }