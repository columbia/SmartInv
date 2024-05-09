1 pragma solidity ^0.4.20;
2 
3 /*
4 Website: https://www.tiptopuniverse.com
5 Discord: https://discord.gg/pXh5qEq
6 */
7 
8 contract Tiptop {
9     /*=================================
10     =            MODIFIERS            =
11     =================================*/
12     // only people with tokens
13     modifier onlyBagholders() {
14         require(myTokens() > 0);
15         _;
16     }
17 
18     // only people with profits
19     modifier onlyStronghands() {
20         require(myDividends(true) > 0);
21         _;
22     }
23 
24     
25 
26     /*==============================
27     =            EVENTS            =
28     ==============================*/
29     event onTokenPurchase(
30         address indexed customerAddress,
31         uint256 incomingEthereum,
32         uint256 tokensMinted,
33         address indexed referredBy
34     );
35 
36     event onTokenSell(
37         address indexed customerAddress,
38         uint256 tokensBurned,
39         uint256 ethereumEarned
40     );
41 
42     event onReinvestment(
43         address indexed customerAddress,
44         uint256 ethereumReinvested,
45         uint256 tokensMinted
46     );
47 
48     event onWithdraw(
49         address indexed customerAddress,
50         uint256 ethereumWithdrawn
51     );
52 
53     // ERC20
54     event Transfer(
55         address indexed from,
56         address indexed to,
57         uint256 tokens
58     );
59 
60     /*=====================================
61     =            CONFIGURABLES            =
62     =====================================*/
63     string public name = "Tip Top Universe";
64     string public symbol = "FUEL";
65     uint8 constant public decimals = 18;
66     uint8 constant internal entryFee_ = 27; 
67     uint8 constant internal refferalFee_ = 20; 
68     uint8 constant internal exitFee_ = 27; 
69     uint256 constant internal tokenPriceInitial_ = 0.000000001 ether;
70     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
71     uint256 constant internal magnitude = 2**64;
72 
73     // proof of stake (defaults at 100 tokens)
74     uint256 public stakingRequirement = 50e18;
75 
76     // referral program
77     mapping(address => uint256) internal referrals;
78     mapping(address => bool) internal isUser;
79     address[] public usersAddresses;
80 
81    /*================================
82     =            DATASETS            =
83     ================================*/
84     // amount of shares for each address (scaled number)
85     mapping(address => uint256) internal tokenBalanceLedger_;
86     mapping(address => uint256) internal referralBalance_;
87     mapping(address => int256) internal payoutsTo_;
88     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
89     uint256 internal tokenSupply_ = 0;
90     uint256 internal profitPerShare_;
91 
92     /*=======================================
93     =            PUBLIC FUNCTIONS            =
94     =======================================*/
95 
96     /**
97      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
98      */
99     function buy(address _referredBy)
100         public
101         payable
102         returns(uint256)
103     {
104         purchaseTokens(msg.value, _referredBy);
105     }
106 
107     /**
108      * Fallback function to handle ethereum that was send straight to the contract
109      * Unfortunately we cannot use a referral address this way.
110      */
111     function()
112         payable
113         public
114     {
115         purchaseTokens(msg.value, 0x0);
116     }
117 
118     /* Converts all of caller's dividends to tokens. */
119     function reinvest() onlyStronghands() public {
120         // fetch dividends
121         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
122 
123         // pay out the dividends virtually
124         address _customerAddress = msg.sender;
125         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
126 
127         // retrieve ref. bonus
128         _dividends += referralBalance_[_customerAddress];
129         referralBalance_[_customerAddress] = 0;
130 
131         // dispatch a buy order with the virtualized "withdrawn dividends"
132         uint256 _tokens = purchaseTokens(_dividends, 0x0);
133 
134         // fire event
135         onReinvestment(_customerAddress, _dividends, _tokens);
136     }
137 
138     /* Alias of sell() and withdraw(). */
139     function exit() public {
140         // get token count for caller & sell them all
141         address _customerAddress = msg.sender;
142         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
143         if(_tokens > 0) sell(_tokens);
144 
145         // lambo delivery service
146         withdraw();
147     }
148 
149     /* Withdraws all of the callers earnings. */
150     function withdraw() onlyStronghands() public {
151         // setup data
152         address _customerAddress = msg.sender;
153         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
154 
155         // update dividend tracker
156         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
157 
158         // add ref. bonus
159         _dividends += referralBalance_[_customerAddress];
160         referralBalance_[_customerAddress] = 0;
161 
162         // lambo delivery service
163         _customerAddress.transfer(_dividends);
164 
165         // fire event
166         onWithdraw(_customerAddress, _dividends);
167     }
168 
169     /* Liquifies tokens to ethereum. */
170     function sell(uint256 _amountOfTokens) onlyBagholders() public {
171         // setup data
172         address _customerAddress = msg.sender;
173         // russian hackers BTFO
174         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
175         uint256 _tokens = _amountOfTokens;
176         uint256 _ethereum = tokensToEthereum_(_tokens);
177         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
178         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
179 
180         // burn the sold tokens
181         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
182         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
183 
184         // update dividends tracker
185         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
186         payoutsTo_[_customerAddress] -= _updatedPayouts;
187 
188         // dividing by zero is a bad idea
189         if (tokenSupply_ > 0) {
190             // update the amount of dividends per token
191             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
192         }
193 
194         // fire event
195         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
196     }
197 
198 
199     /* Transfer tokens from the caller to a new holder. * No fee! */
200     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders() public returns(bool) {
201         // setup
202         address _customerAddress = msg.sender;
203 
204 
205         // withdraw all outstanding dividends first
206         if(myDividends(true) > 0) withdraw();
207 
208         // exchange tokens
209         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
210         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
211 
212         // update dividend trackers
213         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
214         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
215 
216         // fire event
217         Transfer(_customerAddress, _toAddress, _amountOfTokens);
218 
219         // ERC20
220         return true;
221 
222     }
223 
224     
225     /*----------  HELPERS AND CALCULATORS  ----------*/
226     /**
227      * Method to view the current Ethereum stored in the contract
228      * Example: totalEthereumBalance()
229      */
230     function totalEthereumBalance()
231         public
232         view
233         returns(uint)
234     {
235         return this.balance;
236     }
237 
238     /**
239      * Retrieve the total token supply.
240      */
241     function totalSupply()
242         public
243         view
244         returns(uint256)
245     {
246         return tokenSupply_;
247     }
248 
249     /**
250      * Retrieve the tokens owned by the caller.
251      */
252     function myTokens()
253         public
254         view
255         returns(uint256)
256     {
257         address _customerAddress = msg.sender;
258         return balanceOf(_customerAddress);
259     }
260 
261     function referralsOf(address _customerAddress)
262         public
263         view
264         returns(uint256)
265     {
266         return referrals[_customerAddress];
267     }
268 
269     function totalUsers()
270         public
271         view
272         returns(uint256)
273     {
274         return usersAddresses.length;
275     }
276 
277     /**
278      * Retrieve the dividends owned by the caller.
279      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
280      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
281      * But in the internal calculations, we want them separate.
282      */
283     function myDividends(bool _includeReferralBonus)
284         public
285         view
286         returns(uint256)
287     {
288         address _customerAddress = msg.sender;
289         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
290     }
291 
292     /**
293      * Retrieve the token balance of any single address.
294      */
295     function balanceOf(address _customerAddress)
296         view
297         public
298         returns(uint256)
299     {
300         return tokenBalanceLedger_[_customerAddress];
301     }
302 
303     /**
304      * Retrieve the dividend balance of any single address.
305      */
306     function dividendsOf(address _customerAddress)
307         view
308         public
309         returns(uint256)
310     {
311         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
312     }
313 
314     /**
315      * Return the buy price of 1 individual token.
316      */
317     function sellPrice()
318         public
319         view
320         returns(uint256)
321     {
322         // our calculation relies on the token supply, so we need supply. Doh.
323         if(tokenSupply_ == 0){
324             return tokenPriceInitial_ - tokenPriceIncremental_;
325         } else {
326             uint256 _ethereum = tokensToEthereum_(1e18);
327             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
328             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
329             return _taxedEthereum;
330         }
331     }
332 
333     /**
334      * Return the sell price of 1 individual token.
335      */
336     function buyPrice()
337         public
338         view
339         returns(uint256)
340     {
341         // our calculation relies on the token supply, so we need supply. Doh.
342         if(tokenSupply_ == 0){
343             return tokenPriceInitial_ + tokenPriceIncremental_;
344         } else {
345             uint256 _ethereum = tokensToEthereum_(1e18);
346             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
347             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
348             return _taxedEthereum;
349         }
350     }
351 
352     /**
353      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
354      */
355     function calculateTokensReceived(uint256 _ethereumToSpend)
356         public
357         view
358         returns(uint256)
359     {
360         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
361         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
362         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
363 
364         return _amountOfTokens;
365     }
366 
367     /**
368      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
369      */
370     function calculateEthereumReceived(uint256 _tokensToSell)
371         public
372         view
373         returns(uint256)
374     {
375         require(_tokensToSell <= tokenSupply_);
376         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
377         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
378         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
379         return _taxedEthereum;
380     }
381 
382 
383     /*==========================================
384     =            INTERNAL FUNCTIONS            =
385     ==========================================*/
386     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
387         internal
388         returns(uint256)
389     {
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
403         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
404 
405         // is the user referred by a masternode?
406         if(
407             // is this a referred purchase?
408             _referredBy != 0x0000000000000000000000000000000000000000 &&
409 
410             // no cheating!
411             _referredBy != _customerAddress &&
412 
413             // does the referrer have at least X whole tokens?
414             // i.e is the referrer a Kekly chad masternode
415             tokenBalanceLedger_[_referredBy] >= stakingRequirement
416         ){
417             // wealth redistribution
418             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
419 
420             if (isUser[_customerAddress] == false) {
421             	referrals[_referredBy]++;
422             }     
423 
424         } else {
425             // no ref purchase
426             // add the referral bonus back to the global dividends cake
427             _dividends = SafeMath.add(_dividends, _referralBonus);
428             _fee = _dividends * magnitude;
429         }
430 
431         if (isUser[_customerAddress] == false ) {
432         	isUser[_customerAddress] = true;
433         	usersAddresses.push(_customerAddress);
434         }
435 
436         // we can't give people infinite ethereum
437         if(tokenSupply_ > 0){
438 
439             // add tokens to the pool
440             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
441 
442             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
443             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
444 
445             // calculate the amount of tokens the customer receives over his purchase
446             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
447 
448         } else {
449             // add tokens to the pool
450             tokenSupply_ = _amountOfTokens;
451         }
452 
453         // update circulating supply & the ledger address for the customer
454         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
455 
456         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
457         //really i know you think you do but you don't
458         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
459         payoutsTo_[_customerAddress] += _updatedPayouts;
460 
461         // fire event
462         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
463 
464         return _amountOfTokens;
465     }
466 
467     /**
468      * Calculate Token price based on an amount of incoming ethereum
469      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
470      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
471      */
472     function ethereumToTokens_(uint256 _ethereum)
473         internal
474         view
475         returns(uint256)
476     {
477         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
478         uint256 _tokensReceived =
479          (
480             (
481                 // underflow attempts BTFO
482                 SafeMath.sub(
483                     (sqrt
484                         (
485                             (_tokenPriceInitial**2)
486                             +
487                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
488                             +
489                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
490                             +
491                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
492                         )
493                     ), _tokenPriceInitial
494                 )
495             )/(tokenPriceIncremental_)
496         )-(tokenSupply_)
497         ;
498 
499         return _tokensReceived;
500     }
501 
502     /**
503      * Calculate token sell value.
504      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
505      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
506      */
507      function tokensToEthereum_(uint256 _tokens)
508         internal
509         view
510         returns(uint256)
511     {
512 
513         uint256 tokens_ = (_tokens + 1e18);
514         uint256 _tokenSupply = (tokenSupply_ + 1e18);
515         uint256 _etherReceived =
516         (
517             // underflow attempts BTFO
518             SafeMath.sub(
519                 (
520                     (
521                         (
522                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
523                         )-tokenPriceIncremental_
524                     )*(tokens_ - 1e18)
525                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
526             )
527         /1e18);
528         return _etherReceived;
529     }
530 
531 
532     //This is where all your gas goes, sorry
533     //Not sorry, you probably only paid 1 gwei
534     function sqrt(uint x) internal pure returns (uint y) {
535         uint z = (x + 1) / 2;
536         y = x;
537         while (z < y) {
538             y = z;
539             z = (x / z + z) / 2;
540         }
541     }
542 }
543 
544 /**
545  * @title SafeMath
546  * @dev Math operations with safety checks that throw on error
547  */
548 library SafeMath {
549 
550     /**
551     * @dev Multiplies two numbers, throws on overflow.
552     */
553     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
554         if (a == 0) {
555             return 0;
556         }
557         uint256 c = a * b;
558         assert(c / a == b);
559         return c;
560     }
561 
562     /**
563     * @dev Integer division of two numbers, truncating the quotient.
564     */
565     function div(uint256 a, uint256 b) internal pure returns (uint256) {
566         // assert(b > 0); // Solidity automatically throws when dividing by 0
567         uint256 c = a / b;
568         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
569         return c;
570     }
571 
572     /**
573     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
574     */
575     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
576         assert(b <= a);
577         return a - b;
578     }
579 
580     /**
581     * @dev Adds two numbers, throws on overflow.
582     */
583     function add(uint256 a, uint256 b) internal pure returns (uint256) {
584         uint256 c = a + b;
585         assert(c >= a);
586         return c;
587     }
588 }