1 pragma solidity ^0.4.20;
2 
3 
4 contract Rappo {
5 
6 
7     /*=================================
8     =            MODIFIERS            =
9     =================================*/
10 
11     /// @dev Only people with tokens
12     modifier onlyBagholders {
13         require(myTokens() > 0);
14         _;
15     }
16 
17     /// @dev Only people with profits
18     modifier onlyStronghands {
19         require(myDividends(true) > 0);
20         _;
21     }
22 
23 
24     /*==============================
25     =            EVENTS            =
26     ==============================*/
27 
28     event onTokenPurchase(
29         address indexed customerAddress,
30         uint256 incomingEthereum,
31         uint256 tokensMinted,
32         address indexed referredBy,
33         uint timestamp,
34         uint256 price
35     );
36 
37     event onTokenSell(
38         address indexed customerAddress,
39         uint256 tokensBurned,
40         uint256 ethereumEarned,
41         uint timestamp,
42         uint256 price
43     );
44 
45     event onReinvestment(
46         address indexed customerAddress,
47         uint256 ethereumReinvested,
48         uint256 tokensMinted
49     );
50 
51     event onWithdraw(
52         address indexed customerAddress,
53         uint256 ethereumWithdrawn
54     );
55 
56     // ERC20
57     event Transfer(
58         address indexed from,
59         address indexed to,
60         uint256 tokens
61     );
62 
63 
64     /*=====================================
65     =            CONFIGURABLES            =
66     =====================================*/
67 
68     string public name = "Rappo";
69     string public symbol = "RAPPO";
70     uint8 constant public decimals = 18;
71 
72     uint8 constant internal entryFee_ = 15;
73 
74     uint8 constant internal transferFee_ = 5;
75    
76     uint8 constant internal exitFee_ = 15;
77     
78     uint8 constant internal refferalFee_ = 20;
79 
80     uint8 constant internal lotteryFee_ = 5;
81     
82     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
83     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
84     uint256 constant internal magnitude = 2 ** 64;
85 
86     
87     /// @dev proof of stake (defaults at 50 tokens)
88     uint256 public stakingRequirement = 50e18;
89     address owner;
90     mapping(address => bool) preauthorized;
91     bool gameInitiated;
92     
93     uint256 private potSize=0.1 ether;
94     uint256 private lotteryRequirement=50e18;
95     address[] participants;
96     mapping(address => bool) isAdded;
97     mapping(address => uint256) internal participantsIndex;
98     
99    /*=================================
100     =            DATASETS            =
101     ================================*/
102 
103     // amount of shares for each address (scaled number)
104     mapping(address => uint256) internal tokenBalanceLedger_;
105     mapping(address => uint256) internal referralBalance_;
106     mapping(address => int256) internal payoutsTo_;
107     uint256 internal tokenSupply_;
108     uint256 internal profitPerShare_;
109     mapping(address => uint256) internal lotteryBalance_;
110 
111     function Rappo(){
112         owner=msg.sender;
113         preauthorized[owner]=true;
114     }
115 
116     function preauthorize(address _user) public {
117         require(msg.sender == owner);
118         preauthorized[_user] = true;
119     }
120     
121     function startGame() public {
122         require(msg.sender == owner);
123         gameInitiated = true;
124     }
125     
126     /*=======================================
127     =            PUBLIC FUNCTIONS           =
128     =======================================*/
129 
130     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
131     function buy(address _referredBy) public payable returns (uint256) {
132         require(preauthorized[msg.sender] || gameInitiated);
133         purchaseTokens(msg.value, _referredBy);
134     }
135 
136     /**
137      * @dev Fallback function to handle ethereum that was send straight to the contract
138      *  Unfortunately we cannot use a referral address this way.
139      */
140     function() payable public {
141         purchaseTokens(msg.value, 0x0);
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
158         uint256 _tokens = purchaseTokens(_dividends, 0x0);
159 
160         // fire event
161         onReinvestment(_customerAddress, _dividends, _tokens);
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
172         withdraw();
173     }
174 
175     /// @dev Withdraws all of the callers earnings.
176     function withdraw() onlyStronghands public {
177         // setup data
178         address _customerAddress = msg.sender;
179         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
180 
181         // update dividend tracker
182         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
183 
184         // add ref. bonus
185         _dividends += referralBalance_[_customerAddress];
186         _dividends =SafeMath.add(_dividends,lotteryBalance_[_customerAddress]);
187         referralBalance_[_customerAddress] = 0;
188         lotteryBalance_[_customerAddress] = 0;
189         // lambo delivery service
190         _customerAddress.transfer(_dividends);
191 
192         // fire event
193         onWithdraw(_customerAddress, _dividends);
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
206         uint256 _lotteryAmount = SafeMath.div(SafeMath.mul(_ethereum, lotteryFee_), 100);
207         _taxedEthereum=SafeMath.sub(_taxedEthereum,_lotteryAmount);
208         // burn the sold tokens
209         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
210         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
211         if(tokenBalanceLedger_[_customerAddress]<lotteryRequirement && isAdded[_customerAddress]){
212             isAdded[_customerAddress]=false;
213             uint indexToDelete = participantsIndex[_customerAddress]; 
214         	address lastAddress = participants[participants.length - 1];
215         	participants[indexToDelete] = lastAddress;
216         	participants.length--;
217         	participantsIndex[lastAddress] = indexToDelete;
218         	delete participantsIndex[msg.sender];
219         }
220         // update dividends tracker
221         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
222         payoutsTo_[_customerAddress] -= _updatedPayouts;
223 
224         // dividing by zero is a bad idea
225         if (tokenSupply_ > 0) {
226             // update the amount of dividends per token
227             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
228         }
229         drawLottery(_lotteryAmount);
230         // fire event
231         onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
232     }
233 
234 
235     /**
236      * @dev Transfer tokens from the caller to a new holder.
237      *  Remember, there's a 15% fee here as well.
238      */
239     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
240         // setup
241         address _customerAddress = msg.sender;
242 
243         // make sure we have the requested tokens
244         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
245 
246         // withdraw all outstanding dividends first
247         if (myDividends(true) > 0) {
248             withdraw();
249         }
250 
251         // liquify 10% of the tokens that are transfered
252         // these are dispersed to shareholders
253         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
254         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
255         uint256 _dividends = tokensToEthereum_(_tokenFee);
256 
257         // burn the fee tokens
258         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
259 
260         // exchange tokens
261         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
262         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
263 
264         // update dividend trackers
265         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
266         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
267 
268         // disperse dividends among holders
269         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
270 
271         // fire event
272         Transfer(_customerAddress, _toAddress, _taxedTokens);
273 
274         // ERC20
275         return true;
276     }
277 
278 
279     /*=====================================
280     =      HELPERS AND CALCULATORS        =
281     =====================================*/
282 
283     /**
284      * @dev Method to view the current Ethereum stored in the contract
285      *  Example: totalEthereumBalance()
286      */
287     function totalEthereumBalance() public view returns (uint256) {
288         return this.balance;
289     }
290 
291     /// @dev Retrieve the total token supply.
292     function totalSupply() public view returns (uint256) {
293         return tokenSupply_;
294     }
295 
296     /// @dev Retrieve the tokens owned by the caller.
297     function myTokens() public view returns (uint256) {
298         address _customerAddress = msg.sender;
299         return balanceOf(_customerAddress);
300     }
301 
302     /**
303      * @dev Retrieve the dividends owned by the caller.
304      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
305      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
306      *  But in the internal calculations, we want them separate.
307      */
308     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
309         address _customerAddress = msg.sender;
310         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
311     }
312 
313    function getAllDividends() public view returns (uint256) {
314         address _customerAddress = msg.sender;
315         return dividendsOf(_customerAddress) + referralBalance_[_customerAddress] +lotteryBalance_[_customerAddress] ;
316     }
317     function lotteryBalance() public view returns (uint256) {
318         address _customerAddress = msg.sender;
319         return lotteryBalance_[_customerAddress] ;
320     }
321     /// @dev Retrieve the token balance of any single address.
322     function balanceOf(address _customerAddress) public view returns (uint256) {
323         return tokenBalanceLedger_[_customerAddress];
324     }
325 
326     /// @dev Retrieve the dividend balance of any single address.
327     function dividendsOf(address _customerAddress) public view returns (uint256) {
328         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
329     }
330 
331     /// @dev Return the sell price of 1 individual token.
332     function sellPrice() public view returns (uint256) {
333         // our calculation relies on the token supply, so we need supply. Doh.
334         if (tokenSupply_ == 0) {
335             return tokenPriceInitial_ - tokenPriceIncremental_;
336         } else {
337             uint256 _ethereum = tokensToEthereum_(1e18);
338             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, (exitFee_+lotteryFee_)), 100);
339             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
340 
341             return _taxedEthereum;
342         }
343     }
344 
345     /// @dev Return the buy price of 1 individual token.
346     function buyPrice() public view returns (uint256) {
347         // our calculation relies on the token supply, so we need supply. Doh.
348         if (tokenSupply_ == 0) {
349             return tokenPriceInitial_ + tokenPriceIncremental_;
350         } else {
351             uint256 _ethereum = tokensToEthereum_(1e18);
352             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, (entryFee_+lotteryFee_)), 100);
353             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
354 
355             return _taxedEthereum;
356         }
357     }
358 
359     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
360     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
361         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
362         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
363         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
364 
365         return _amountOfTokens;
366     }
367 
368     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
369     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
370         require(_tokensToSell <= tokenSupply_);
371         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
372         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
373         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
374         return _taxedEthereum;
375     }
376 
377 
378     /*==========================================
379     =            INTERNAL FUNCTIONS            =
380     ==========================================*/
381 
382     /// @dev Internal function to actually purchase the tokens.
383     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
384         
385         // data setup
386         address _customerAddress = msg.sender;
387         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
388         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
389         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
390         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
391         uint256 _lotteryAmount = SafeMath.div(SafeMath.mul(_incomingEthereum, lotteryFee_), 100);
392         _taxedEthereum=SafeMath.sub(_taxedEthereum,_lotteryAmount);
393         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
394         uint256 _fee = _dividends * magnitude;
395 
396 
397         // no point in continuing execution if OP is a poorfag russian hacker
398         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
399         // (or hackers)
400         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
401         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
402 
403         // is the user referred by a masternode?
404         if (
405             // is this a referred purchase?
406             _referredBy != 0x0000000000000000000000000000000000000000 &&
407 
408             // no cheating!
409             _referredBy != _customerAddress &&
410 
411             // does the referrer have at least X whole tokens?
412             // i.e is the referrer a godly chad masternode
413             tokenBalanceLedger_[_referredBy] >= stakingRequirement
414         ) {
415             // wealth redistribution
416             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
417         } else {
418             // no ref purchase
419             // add the referral bonus back to the global dividends cake
420             _dividends = SafeMath.add(_dividends, _referralBonus);
421             _fee = _dividends * magnitude;
422         }
423 
424         // we can't give people infinite ethereum
425         if (tokenSupply_ > 0) {
426             // add tokens to the pool
427             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
428 
429             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
430             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
431 
432             // calculate the amount of tokens the customer receives over his purchase
433             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
434         } else {
435             // add tokens to the pool
436             tokenSupply_ = _amountOfTokens;
437         }
438 
439         // update circulating supply & the ledger address for the customer
440         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
441         if(tokenBalanceLedger_[_customerAddress]>=lotteryRequirement && !isAdded[msg.sender]){
442             participants.push(msg.sender);
443             participantsIndex[msg.sender]=participants.length-1;
444             isAdded[msg.sender]=true;
445         }
446         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
447         // really i know you think you do but you don't
448         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
449         payoutsTo_[_customerAddress] += _updatedPayouts;
450         drawLottery(_lotteryAmount);
451         // fire event
452         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
453 
454         return _amountOfTokens;
455     }
456     
457     function drawLottery(uint256 _lotteryAmount) internal{
458          uint256 winnerIndex = rand(participants.length);
459 		 address winner = participants[winnerIndex];
460 		 lotteryBalance_[winner]=SafeMath.add(lotteryBalance_[winner],_lotteryAmount);
461     }
462 
463     // Generate random number between 0 & max
464     uint256 constant private FACTOR =  1157920892373161954235709850086879078532699846656405640394575840079131296399;
465     function rand(uint max) constant public returns (uint256 result){
466         uint256 factor = FACTOR * 100 / max;
467         uint256 lastBlockNumber = block.number - 1;
468         uint256 hashVal = uint256(block.blockhash(lastBlockNumber));
469     
470         return uint256((uint256(hashVal) / factor)) % max;
471     }
472     
473     /**
474      * @dev Calculate Token price based on an amount of incoming ethereum
475      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
476      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
477      */
478     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
479         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
480         uint256 _tokensReceived =
481          (
482             (
483                 // underflow attempts BTFO
484                 SafeMath.sub(
485                     (sqrt
486                         (
487                             (_tokenPriceInitial ** 2)
488                             +
489                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
490                             +
491                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
492                             +
493                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
494                         )
495                     ), _tokenPriceInitial
496                 )
497             ) / (tokenPriceIncremental_)
498         ) - (tokenSupply_);
499 
500         return _tokensReceived;
501     }
502 
503     /**
504      * @dev Calculate token sell value.
505      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
506      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
507      */
508     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
509         uint256 tokens_ = (_tokens + 1e18);
510         uint256 _tokenSupply = (tokenSupply_ + 1e18);
511         uint256 _etherReceived =
512         (
513             // underflow attempts BTFO
514             SafeMath.sub(
515                 (
516                     (
517                         (
518                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
519                         ) - tokenPriceIncremental_
520                     ) * (tokens_ - 1e18)
521                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
522             )
523         / 1e18);
524 
525         return _etherReceived;
526     }
527 
528     /// @dev This is where all your gas goes.
529     function sqrt(uint256 x) internal pure returns (uint256 y) {
530         uint256 z = (x + 1) / 2;
531         y = x;
532 
533         while (z < y) {
534             y = z;
535             z = (x / z + z) / 2;
536         }
537     }
538 
539 
540 }
541 
542 /**
543  * @title SafeMath
544  * @dev Math operations with safety checks that throw on error
545  */
546 library SafeMath {
547 
548     /**
549     * @dev Multiplies two numbers, throws on overflow.
550     */
551     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
552         if (a == 0) {
553             return 0;
554         }
555         uint256 c = a * b;
556         assert(c / a == b);
557         return c;
558     }
559 
560     /**
561     * @dev Integer division of two numbers, truncating the quotient.
562     */
563     function div(uint256 a, uint256 b) internal pure returns (uint256) {
564         // assert(b > 0); // Solidity automatically throws when dividing by 0
565         uint256 c = a / b;
566         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
567         return c;
568     }
569 
570     /**
571     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
572     */
573     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
574         assert(b <= a);
575         return a - b;
576     }
577 
578     /**
579     * @dev Adds two numbers, throws on overflow.
580     */
581     function add(uint256 a, uint256 b) internal pure returns (uint256) {
582         uint256 c = a + b;
583         assert(c >= a);
584         return c;
585     }
586 
587 }