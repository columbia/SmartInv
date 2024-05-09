1 pragma solidity ^0.4.20;
2 
3 /*
4 J.I.G.G.S
5 */
6 
7 contract Jiggs {
8     /*=================================
9     =            MODIFIERS            =
10     =================================*/
11     // only people with tokens
12     modifier onlyBagholders() {
13         require(myTokens() > 0);
14         _;
15     }
16 
17     // only people with profits
18     modifier onlyStronghands() {
19         require(myDividends(true) > 0);
20         _;
21     }
22 
23     
24 
25     /*==============================
26     =            EVENTS            =
27     ==============================*/
28     event onTokenPurchase(
29         address indexed customerAddress,
30         uint256 incomingEthereum,
31         uint256 tokensMinted,
32         address indexed referredBy
33     );
34 
35     event onTokenSell(
36         address indexed customerAddress,
37         uint256 tokensBurned,
38         uint256 ethereumEarned
39     );
40 
41     event onReinvestment(
42         address indexed customerAddress,
43         uint256 ethereumReinvested,
44         uint256 tokensMinted
45     );
46 
47     event onWithdraw(
48         address indexed customerAddress,
49         uint256 ethereumWithdrawn
50     );
51 
52     // ERC20
53     event Transfer(
54         address indexed from,
55         address indexed to,
56         uint256 tokens
57     );
58 
59     /*=====================================
60     =            CONFIGURABLES            =
61     =====================================*/
62     string public name = "The Jigsaw Games";
63     string public symbol = "Jiggs";
64     uint8 constant public decimals = 18;
65     uint8 constant internal entryFee_ = 25; 
66     uint8 constant internal refferalFee_ = 60; 
67     uint8 constant internal exitFee_ = 25; 
68     uint256 constant internal tokenPriceInitial_ = 0.000000001 ether;
69     uint256 constant internal tokenPriceIncremental_ = 0.000000003 ether;
70     uint256 constant internal magnitude = 2**64;
71 
72     // proof of stake (defaults at 100 tokens)
73     uint256 public stakingRequirement = 175e18;
74 
75     // referral program
76     mapping(address => uint256) internal referrals;
77     mapping(address => bool) internal isUser;
78     address[] public usersAddresses;
79 
80    /*================================
81     =            DATASETS            =
82     ================================*/
83     // amount of shares for each address (scaled number)
84     mapping(address => uint256) internal tokenBalanceLedger_;
85     mapping(address => uint256) internal referralBalance_;
86     mapping(address => int256) internal payoutsTo_;
87     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
88     uint256 internal tokenSupply_ = 0;
89     uint256 internal profitPerShare_;
90 
91     /*=======================================
92     =            PUBLIC FUNCTIONS            =
93     =======================================*/
94 
95     /**
96      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
97      */
98     function buy(address _referredBy)
99         public
100         payable
101         returns(uint256)
102     {
103         purchaseTokens(msg.value, _referredBy);
104     }
105 
106     /**
107      * Fallback function to handle ethereum that was send straight to the contract
108      * Unfortunately we cannot use a referral address this way.
109      */
110     function()
111         payable
112         public
113     {
114         purchaseTokens(msg.value, 0x0);
115     }
116 
117     /* Converts all of caller's dividends to tokens. */
118     function reinvest() onlyStronghands() public {
119         // fetch dividends
120         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
121 
122         // pay out the dividends virtually
123         address _customerAddress = msg.sender;
124         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
125 
126         // retrieve ref. bonus
127         _dividends += referralBalance_[_customerAddress];
128         referralBalance_[_customerAddress] = 0;
129 
130         // dispatch a buy order with the virtualized "withdrawn dividends"
131         uint256 _tokens = purchaseTokens(_dividends, 0x0);
132 
133         // fire event
134         onReinvestment(_customerAddress, _dividends, _tokens);
135     }
136 
137     /* Alias of sell() and withdraw(). */
138     function exit() public {
139         // get token count for caller & sell them all
140         address _customerAddress = msg.sender;
141         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
142         if(_tokens > 0) sell(_tokens);
143 
144         // lambo delivery service
145         withdraw();
146     }
147 
148     /* Withdraws all of the callers earnings. */
149     function withdraw() onlyStronghands() public {
150         // setup data
151         address _customerAddress = msg.sender;
152         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
153 
154         // update dividend tracker
155         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
156 
157         // add ref. bonus
158         _dividends += referralBalance_[_customerAddress];
159         referralBalance_[_customerAddress] = 0;
160 
161         // lambo delivery service
162         _customerAddress.transfer(_dividends);
163 
164         // fire event
165         onWithdraw(_customerAddress, _dividends);
166     }
167 
168     /* Liquifies tokens to ethereum. */
169     function sell(uint256 _amountOfTokens) onlyBagholders() public {
170         // setup data
171         address _customerAddress = msg.sender;
172         // russian hackers BTFO
173         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
174         uint256 _tokens = _amountOfTokens;
175         uint256 _ethereum = tokensToEthereum_(_tokens);
176         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
177         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
178 
179         // burn the sold tokens
180         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
181         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
182 
183         // update dividends tracker
184         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
185         payoutsTo_[_customerAddress] -= _updatedPayouts;
186 
187         // dividing by zero is a bad idea
188         if (tokenSupply_ > 0) {
189             // update the amount of dividends per token
190             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
191         }
192 
193         // fire event
194         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
195     }
196 
197 
198     /* Transfer tokens from the caller to a new holder. * No fee! */
199     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders() public returns(bool) {
200         // setup
201         address _customerAddress = msg.sender;
202 
203 
204         // withdraw all outstanding dividends first
205         if(myDividends(true) > 0) withdraw();
206 
207         // exchange tokens
208         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
209         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
210 
211         // update dividend trackers
212         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
213         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
214 
215         // fire event
216         Transfer(_customerAddress, _toAddress, _amountOfTokens);
217 
218         // ERC20
219         return true;
220 
221     }
222 
223     
224     /*----------  HELPERS AND CALCULATORS  ----------*/
225     /**
226      * Method to view the current Ethereum stored in the contract
227      * Example: totalEthereumBalance()
228      */
229     function totalEthereumBalance()
230         public
231         view
232         returns(uint)
233     {
234         return this.balance;
235     }
236 
237     /**
238      * Retrieve the total token supply.
239      */
240     function totalSupply()
241         public
242         view
243         returns(uint256)
244     {
245         return tokenSupply_;
246     }
247 
248     /**
249      * Retrieve the tokens owned by the caller.
250      */
251     function myTokens()
252         public
253         view
254         returns(uint256)
255     {
256         address _customerAddress = msg.sender;
257         return balanceOf(_customerAddress);
258     }
259 
260     function referralsOf(address _customerAddress)
261         public
262         view
263         returns(uint256)
264     {
265         return referrals[_customerAddress];
266     }
267 
268     function totalUsers()
269         public
270         view
271         returns(uint256)
272     {
273         return usersAddresses.length;
274     }
275 
276     /**
277      * Retrieve the dividends owned by the caller.
278      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
279      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
280      * But in the internal calculations, we want them separate.
281      */
282     function myDividends(bool _includeReferralBonus)
283         public
284         view
285         returns(uint256)
286     {
287         address _customerAddress = msg.sender;
288         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
289     }
290 
291     /**
292      * Retrieve the token balance of any single address.
293      */
294     function balanceOf(address _customerAddress)
295         view
296         public
297         returns(uint256)
298     {
299         return tokenBalanceLedger_[_customerAddress];
300     }
301 
302     /**
303      * Retrieve the dividend balance of any single address.
304      */
305     function dividendsOf(address _customerAddress)
306         view
307         public
308         returns(uint256)
309     {
310         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
311     }
312 
313     /**
314      * Return the buy price of 1 individual token.
315      */
316     function sellPrice()
317         public
318         view
319         returns(uint256)
320     {
321         // our calculation relies on the token supply, so we need supply. Doh.
322         if(tokenSupply_ == 0){
323             return tokenPriceInitial_ - tokenPriceIncremental_;
324         } else {
325             uint256 _ethereum = tokensToEthereum_(1e18);
326             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
327             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
328             return _taxedEthereum;
329         }
330     }
331 
332     /**
333      * Return the sell price of 1 individual token.
334      */
335     function buyPrice()
336         public
337         view
338         returns(uint256)
339     {
340         // our calculation relies on the token supply, so we need supply. Doh.
341         if(tokenSupply_ == 0){
342             return tokenPriceInitial_ + tokenPriceIncremental_;
343         } else {
344             uint256 _ethereum = tokensToEthereum_(1e18);
345             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
346             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
347             return _taxedEthereum;
348         }
349     }
350 
351     /**
352      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
353      */
354     function calculateTokensReceived(uint256 _ethereumToSpend)
355         public
356         view
357         returns(uint256)
358     {
359         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
360         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
361         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
362 
363         return _amountOfTokens;
364     }
365 
366     /**
367      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
368      */
369     function calculateEthereumReceived(uint256 _tokensToSell)
370         public
371         view
372         returns(uint256)
373     {
374         require(_tokensToSell <= tokenSupply_);
375         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
376         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
377         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
378         return _taxedEthereum;
379     }
380 
381 
382     /*==========================================
383     =            INTERNAL FUNCTIONS            =
384     ==========================================*/
385     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
386         internal
387         returns(uint256)
388     {
389         // data setup
390         address _customerAddress = msg.sender;
391         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
392         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
393         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
394         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
395         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
396         uint256 _fee = _dividends * magnitude;
397 
398         // no point in continuing execution if OP is a poorfag russian hacker
399         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
400         // (or hackers)
401         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
402         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
403 
404         // is the user referred by a masternode?
405         if(
406             // is this a referred purchase?
407             _referredBy != 0x0000000000000000000000000000000000000000 &&
408 
409             // no cheating!
410             _referredBy != _customerAddress &&
411 
412             // does the referrer have at least X whole tokens?
413             // i.e is the referrer a Kekly chad masternode
414             tokenBalanceLedger_[_referredBy] >= stakingRequirement
415         ){
416             // wealth redistribution
417             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
418 
419             if (isUser[_customerAddress] == false) {
420             	referrals[_referredBy]++;
421             }     
422 
423         } else {
424             // no ref purchase
425             // add the referral bonus back to the global dividends cake
426             _dividends = SafeMath.add(_dividends, _referralBonus);
427             _fee = _dividends * magnitude;
428         }
429 
430         if (isUser[_customerAddress] == false ) {
431         	isUser[_customerAddress] = true;
432         	usersAddresses.push(_customerAddress);
433         }
434 
435         // we can't give people infinite ethereum
436         if(tokenSupply_ > 0){
437 
438             // add tokens to the pool
439             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
440 
441             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
442             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
443 
444             // calculate the amount of tokens the customer receives over his purchase
445             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
446 
447         } else {
448             // add tokens to the pool
449             tokenSupply_ = _amountOfTokens;
450         }
451 
452         // update circulating supply & the ledger address for the customer
453         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
454 
455         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
456         //really i know you think you do but you don't
457         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
458         payoutsTo_[_customerAddress] += _updatedPayouts;
459 
460         // fire event
461         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
462 
463         return _amountOfTokens;
464     }
465 
466     /**
467      * Calculate Token price based on an amount of incoming ethereum
468      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
469      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
470      */
471     function ethereumToTokens_(uint256 _ethereum)
472         internal
473         view
474         returns(uint256)
475     {
476         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
477         uint256 _tokensReceived =
478          (
479             (
480                 // underflow attempts BTFO
481                 SafeMath.sub(
482                     (sqrt
483                         (
484                             (_tokenPriceInitial**2)
485                             +
486                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
487                             +
488                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
489                             +
490                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
491                         )
492                     ), _tokenPriceInitial
493                 )
494             )/(tokenPriceIncremental_)
495         )-(tokenSupply_)
496         ;
497 
498         return _tokensReceived;
499     }
500 
501     /**
502      * Calculate token sell value.
503      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
504      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
505      */
506      function tokensToEthereum_(uint256 _tokens)
507         internal
508         view
509         returns(uint256)
510     {
511 
512         uint256 tokens_ = (_tokens + 1e18);
513         uint256 _tokenSupply = (tokenSupply_ + 1e18);
514         uint256 _etherReceived =
515         (
516             // underflow attempts BTFO
517             SafeMath.sub(
518                 (
519                     (
520                         (
521                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
522                         )-tokenPriceIncremental_
523                     )*(tokens_ - 1e18)
524                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
525             )
526         /1e18);
527         return _etherReceived;
528     }
529 
530 
531     //This is where all your gas goes, sorry
532     //Not sorry, you probably only paid 1 gwei
533     function sqrt(uint x) internal pure returns (uint y) {
534         uint z = (x + 1) / 2;
535         y = x;
536         while (z < y) {
537             y = z;
538             z = (x / z + z) / 2;
539         }
540     }
541 }
542 
543 /**
544  * @title SafeMath
545  * @dev Math operations with safety checks that throw on error
546  */
547 library SafeMath {
548 
549     /**
550     * @dev Multiplies two numbers, throws on overflow.
551     */
552     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
553         if (a == 0) {
554             return 0;
555         }
556         uint256 c = a * b;
557         assert(c / a == b);
558         return c;
559     }
560 
561     /**
562     * @dev Integer division of two numbers, truncating the quotient.
563     */
564     function div(uint256 a, uint256 b) internal pure returns (uint256) {
565         // assert(b > 0); // Solidity automatically throws when dividing by 0
566         uint256 c = a / b;
567         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
568         return c;
569     }
570 
571     /**
572     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
573     */
574     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
575         assert(b <= a);
576         return a - b;
577     }
578 
579     /**
580     * @dev Adds two numbers, throws on overflow.
581     */
582     function add(uint256 a, uint256 b) internal pure returns (uint256) {
583         uint256 c = a + b;
584         assert(c >= a);
585         return c;
586     }
587 }