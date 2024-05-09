1 pragma solidity ^0.4.20;
2 
3 /*
4 / J.I.G.G.S / SAW3D
5 /
6 / https://www.jiggs.io 
7 / 
8 / This is the ONLY OFFICIAL WEBSITE of the The Jigsaw Games!
9 / If you want to play, be sure to play through this website!
10 */
11 
12 contract Jiggs {
13     /*=================================
14     =            MODIFIERS            =
15     =================================*/
16     // only people with tokens
17     modifier onlyBagholders() {
18         require(myTokens() > 0);
19         _;
20     }
21 
22     // only people with profits
23     modifier onlyStronghands() {
24         require(myDividends(true) > 0);
25         _;
26     }
27 
28     
29 
30     /*==============================
31     =            EVENTS            =
32     ==============================*/
33     event onTokenPurchase(
34         address indexed customerAddress,
35         uint256 incomingEthereum,
36         uint256 tokensMinted,
37         address indexed referredBy
38     );
39 
40     event onTokenSell(
41         address indexed customerAddress,
42         uint256 tokensBurned,
43         uint256 ethereumEarned
44     );
45 
46     event onReinvestment(
47         address indexed customerAddress,
48         uint256 ethereumReinvested,
49         uint256 tokensMinted
50     );
51 
52     event onWithdraw(
53         address indexed customerAddress,
54         uint256 ethereumWithdrawn
55     );
56 
57     // ERC20
58     event Transfer(
59         address indexed from,
60         address indexed to,
61         uint256 tokens
62     );
63 
64     /*=====================================
65     =            CONFIGURABLES            =
66     =====================================*/
67     string public name = "The Jigsaw Games";
68     string public symbol = "Jiggs3D";
69     uint8 constant public decimals = 18;
70     uint8 constant internal entryFee_ = 25; 
71     uint8 constant internal refferalFee_ = 50; 
72     uint8 constant internal exitFee_ = 25; 
73     uint256 constant internal tokenPriceInitial_ = 0.000000001 ether;
74     uint256 constant internal tokenPriceIncremental_ = 0.0000000007 ether;
75     uint256 constant internal magnitude = 2**64;
76 
77     // proof of stake (defaults at 100 tokens)
78     uint256 public stakingRequirement = 50e18;
79 
80     // referral program
81     mapping(address => uint256) internal referrals;
82     mapping(address => bool) internal isUser;
83     address[] public usersAddresses;
84 
85    /*================================
86     =            DATASETS            =
87     ================================*/
88     // amount of shares for each address (scaled number)
89     mapping(address => uint256) internal tokenBalanceLedger_;
90     mapping(address => uint256) internal referralBalance_;
91     mapping(address => int256) internal payoutsTo_;
92     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
93     uint256 internal tokenSupply_ = 0;
94     uint256 internal profitPerShare_;
95 
96     /*=======================================
97     =            PUBLIC FUNCTIONS            =
98     =======================================*/
99 
100     /**
101      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
102      */
103     function buy(address _referredBy)
104         public
105         payable
106         returns(uint256)
107     {
108         purchaseTokens(msg.value, _referredBy);
109     }
110 
111     /**
112      * Fallback function to handle ethereum that was send straight to the contract
113      * Unfortunately we cannot use a referral address this way.
114      */
115     function()
116         payable
117         public
118     {
119         purchaseTokens(msg.value, 0x0);
120     }
121 
122     /* Converts all of caller's dividends to tokens. */
123     function reinvest() onlyStronghands() public {
124         // fetch dividends
125         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
126 
127         // pay out the dividends virtually
128         address _customerAddress = msg.sender;
129         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
130 
131         // retrieve ref. bonus
132         _dividends += referralBalance_[_customerAddress];
133         referralBalance_[_customerAddress] = 0;
134 
135         // dispatch a buy order with the virtualized "withdrawn dividends"
136         uint256 _tokens = purchaseTokens(_dividends, 0x0);
137 
138         // fire event
139         onReinvestment(_customerAddress, _dividends, _tokens);
140     }
141 
142     /* Alias of sell() and withdraw(). */
143     function exit() public {
144         // get token count for caller & sell them all
145         address _customerAddress = msg.sender;
146         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
147         if(_tokens > 0) sell(_tokens);
148 
149         // lambo delivery service
150         withdraw();
151     }
152 
153     /* Withdraws all of the callers earnings. */
154     function withdraw() onlyStronghands() public {
155         // setup data
156         address _customerAddress = msg.sender;
157         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
158 
159         // update dividend tracker
160         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
161 
162         // add ref. bonus
163         _dividends += referralBalance_[_customerAddress];
164         referralBalance_[_customerAddress] = 0;
165 
166         // lambo delivery service
167         _customerAddress.transfer(_dividends);
168 
169         // fire event
170         onWithdraw(_customerAddress, _dividends);
171     }
172 
173     /* Liquifies tokens to ethereum. */
174     function sell(uint256 _amountOfTokens) onlyBagholders() public {
175         // setup data
176         address _customerAddress = msg.sender;
177         // russian hackers BTFO
178         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
179         uint256 _tokens = _amountOfTokens;
180         uint256 _ethereum = tokensToEthereum_(_tokens);
181         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
182         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
183 
184         // burn the sold tokens
185         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
186         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
187 
188         // update dividends tracker
189         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
190         payoutsTo_[_customerAddress] -= _updatedPayouts;
191 
192         // dividing by zero is a bad idea
193         if (tokenSupply_ > 0) {
194             // update the amount of dividends per token
195             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
196         }
197 
198         // fire event
199         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
200     }
201 
202 
203     /* Transfer tokens from the caller to a new holder. * No fee! */
204     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders() public returns(bool) {
205         // setup
206         address _customerAddress = msg.sender;
207 
208 
209         // withdraw all outstanding dividends first
210         if(myDividends(true) > 0) withdraw();
211 
212         // exchange tokens
213         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
214         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
215 
216         // update dividend trackers
217         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
218         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
219 
220         // fire event
221         Transfer(_customerAddress, _toAddress, _amountOfTokens);
222 
223         // ERC20
224         return true;
225 
226     }
227 
228     
229     /*----------  HELPERS AND CALCULATORS  ----------*/
230     /**
231      * Method to view the current Ethereum stored in the contract
232      * Example: totalEthereumBalance()
233      */
234     function totalEthereumBalance()
235         public
236         view
237         returns(uint)
238     {
239         return this.balance;
240     }
241 
242     /**
243      * Retrieve the total token supply.
244      */
245     function totalSupply()
246         public
247         view
248         returns(uint256)
249     {
250         return tokenSupply_;
251     }
252 
253     /**
254      * Retrieve the tokens owned by the caller.
255      */
256     function myTokens()
257         public
258         view
259         returns(uint256)
260     {
261         address _customerAddress = msg.sender;
262         return balanceOf(_customerAddress);
263     }
264 
265     function referralsOf(address _customerAddress)
266         public
267         view
268         returns(uint256)
269     {
270         return referrals[_customerAddress];
271     }
272 
273     function totalUsers()
274         public
275         view
276         returns(uint256)
277     {
278         return usersAddresses.length;
279     }
280 
281     /**
282      * Retrieve the dividends owned by the caller.
283      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
284      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
285      * But in the internal calculations, we want them separate.
286      */
287     function myDividends(bool _includeReferralBonus)
288         public
289         view
290         returns(uint256)
291     {
292         address _customerAddress = msg.sender;
293         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
294     }
295 
296     /**
297      * Retrieve the token balance of any single address.
298      */
299     function balanceOf(address _customerAddress)
300         view
301         public
302         returns(uint256)
303     {
304         return tokenBalanceLedger_[_customerAddress];
305     }
306 
307     /**
308      * Retrieve the dividend balance of any single address.
309      */
310     function dividendsOf(address _customerAddress)
311         view
312         public
313         returns(uint256)
314     {
315         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
316     }
317 
318     /**
319      * Return the buy price of 1 individual token.
320      */
321     function sellPrice()
322         public
323         view
324         returns(uint256)
325     {
326         // our calculation relies on the token supply, so we need supply. Doh.
327         if(tokenSupply_ == 0){
328             return tokenPriceInitial_ - tokenPriceIncremental_;
329         } else {
330             uint256 _ethereum = tokensToEthereum_(1e18);
331             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
332             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
333             return _taxedEthereum;
334         }
335     }
336 
337     /**
338      * Return the sell price of 1 individual token.
339      */
340     function buyPrice()
341         public
342         view
343         returns(uint256)
344     {
345         // our calculation relies on the token supply, so we need supply. Doh.
346         if(tokenSupply_ == 0){
347             return tokenPriceInitial_ + tokenPriceIncremental_;
348         } else {
349             uint256 _ethereum = tokensToEthereum_(1e18);
350             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
351             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
352             return _taxedEthereum;
353         }
354     }
355 
356     /**
357      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
358      */
359     function calculateTokensReceived(uint256 _ethereumToSpend)
360         public
361         view
362         returns(uint256)
363     {
364         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
365         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
366         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
367 
368         return _amountOfTokens;
369     }
370 
371     /**
372      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
373      */
374     function calculateEthereumReceived(uint256 _tokensToSell)
375         public
376         view
377         returns(uint256)
378     {
379         require(_tokensToSell <= tokenSupply_);
380         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
381         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
382         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
383         return _taxedEthereum;
384     }
385 
386 
387     /*==========================================
388     =            INTERNAL FUNCTIONS            =
389     ==========================================*/
390     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
391         internal
392         returns(uint256)
393     {
394         // data setup
395         address _customerAddress = msg.sender;
396         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
397         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
398         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
399         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
400         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
401         uint256 _fee = _dividends * magnitude;
402 
403         // no point in continuing execution if OP is a poorfag russian hacker
404         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
405         // (or hackers)
406         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
407         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
408 
409         // is the user referred by a masternode?
410         if(
411             // is this a referred purchase?
412             _referredBy != 0x0000000000000000000000000000000000000000 &&
413 
414             // no cheating!
415             _referredBy != _customerAddress &&
416 
417             // does the referrer have at least X whole tokens?
418             // i.e is the referrer a Kekly chad masternode
419             tokenBalanceLedger_[_referredBy] >= stakingRequirement
420         ){
421             // wealth redistribution
422             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
423 
424             if (isUser[_customerAddress] == false) {
425             	referrals[_referredBy]++;
426             }     
427 
428         } else {
429             // no ref purchase
430             // add the referral bonus back to the global dividends cake
431             _dividends = SafeMath.add(_dividends, _referralBonus);
432             _fee = _dividends * magnitude;
433         }
434 
435         if (isUser[_customerAddress] == false ) {
436         	isUser[_customerAddress] = true;
437         	usersAddresses.push(_customerAddress);
438         }
439 
440         // we can't give people infinite ethereum
441         if(tokenSupply_ > 0){
442 
443             // add tokens to the pool
444             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
445 
446             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
447             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
448 
449             // calculate the amount of tokens the customer receives over his purchase
450             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
451 
452         } else {
453             // add tokens to the pool
454             tokenSupply_ = _amountOfTokens;
455         }
456 
457         // update circulating supply & the ledger address for the customer
458         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
459 
460         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
461         //really i know you think you do but you don't
462         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
463         payoutsTo_[_customerAddress] += _updatedPayouts;
464 
465         // fire event
466         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
467 
468         return _amountOfTokens;
469     }
470 
471     /**
472      * Calculate Token price based on an amount of incoming ethereum
473      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
474      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
475      */
476     function ethereumToTokens_(uint256 _ethereum)
477         internal
478         view
479         returns(uint256)
480     {
481         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
482         uint256 _tokensReceived =
483          (
484             (
485                 // underflow attempts BTFO
486                 SafeMath.sub(
487                     (sqrt
488                         (
489                             (_tokenPriceInitial**2)
490                             +
491                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
492                             +
493                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
494                             +
495                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
496                         )
497                     ), _tokenPriceInitial
498                 )
499             )/(tokenPriceIncremental_)
500         )-(tokenSupply_)
501         ;
502 
503         return _tokensReceived;
504     }
505 
506     /**
507      * Calculate token sell value.
508      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
509      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
510      */
511      function tokensToEthereum_(uint256 _tokens)
512         internal
513         view
514         returns(uint256)
515     {
516 
517         uint256 tokens_ = (_tokens + 1e18);
518         uint256 _tokenSupply = (tokenSupply_ + 1e18);
519         uint256 _etherReceived =
520         (
521             // underflow attempts BTFO
522             SafeMath.sub(
523                 (
524                     (
525                         (
526                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
527                         )-tokenPriceIncremental_
528                     )*(tokens_ - 1e18)
529                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
530             )
531         /1e18);
532         return _etherReceived;
533     }
534 
535 
536     //This is where all your gas goes, sorry
537     //Not sorry, you probably only paid 1 gwei
538     function sqrt(uint x) internal pure returns (uint y) {
539         uint z = (x + 1) / 2;
540         y = x;
541         while (z < y) {
542             y = z;
543             z = (x / z + z) / 2;
544         }
545     }
546 }
547 
548 /**
549  * @title SafeMath
550  * @dev Math operations with safety checks that throw on error
551  */
552 library SafeMath {
553 
554     /**
555     * @dev Multiplies two numbers, throws on overflow.
556     */
557     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
558         if (a == 0) {
559             return 0;
560         }
561         uint256 c = a * b;
562         assert(c / a == b);
563         return c;
564     }
565 
566     /**
567     * @dev Integer division of two numbers, truncating the quotient.
568     */
569     function div(uint256 a, uint256 b) internal pure returns (uint256) {
570         // assert(b > 0); // Solidity automatically throws when dividing by 0
571         uint256 c = a / b;
572         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
573         return c;
574     }
575 
576     /**
577     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
578     */
579     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
580         assert(b <= a);
581         return a - b;
582     }
583 
584     /**
585     * @dev Adds two numbers, throws on overflow.
586     */
587     function add(uint256 a, uint256 b) internal pure returns (uint256) {
588         uint256 c = a + b;
589         assert(c >= a);
590         return c;
591     }
592 }