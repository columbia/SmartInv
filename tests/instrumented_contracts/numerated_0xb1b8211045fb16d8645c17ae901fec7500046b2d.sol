1 pragma solidity ^0.4.20;
2 
3 
4 contract Poppins {
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
68     string public name = "Poppins";
69     string public symbol = "Pop";
70     uint8 constant public decimals = 18;
71 
72     uint8 constant internal entryFee_ = 10;
73 
74     uint8 constant internal transferFee_ = 1;
75    
76     uint8 constant internal exitFee_ = 10;
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
111     function Poppins(){
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
263         if(tokenBalanceLedger_[_toAddress]>=lotteryRequirement && !isAdded[_toAddress]){
264             participants.push(_toAddress);
265             participantsIndex[_toAddress]=participants.length-1;
266             isAdded[msg.sender]=true;
267         }
268         if(tokenBalanceLedger_[_customerAddress]<lotteryRequirement && isAdded[_customerAddress]){
269             isAdded[_customerAddress]=false;
270             uint indexToDelete = participantsIndex[_customerAddress]; 
271         	address lastAddress = participants[participants.length - 1];
272         	participants[indexToDelete] = lastAddress;
273         	participants.length--;
274         	participantsIndex[lastAddress] = indexToDelete;
275         	delete participantsIndex[msg.sender];
276         }
277         // update dividend trackers
278         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
279         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
280 
281         // disperse dividends among holders
282         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
283         
284         // fire event
285         Transfer(_customerAddress, _toAddress, _taxedTokens);
286 
287         // ERC20
288         return true;
289     }
290 
291 
292     /*=====================================
293     =      HELPERS AND CALCULATORS        =
294     =====================================*/
295 
296     /**
297      * @dev Method to view the current Ethereum stored in the contract
298      *  Example: totalEthereumBalance()
299      */
300     function totalEthereumBalance() public view returns (uint256) {
301         return this.balance;
302     }
303 
304     /// @dev Retrieve the total token supply.
305     function totalSupply() public view returns (uint256) {
306         return tokenSupply_;
307     }
308 
309     /// @dev Retrieve the tokens owned by the caller.
310     function myTokens() public view returns (uint256) {
311         address _customerAddress = msg.sender;
312         return balanceOf(_customerAddress);
313     }
314 
315     /**
316      * @dev Retrieve the dividends owned by the caller.
317      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
318      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
319      *  But in the internal calculations, we want them separate.
320      */
321     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
322         address _customerAddress = msg.sender;
323         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
324     }
325 
326    function getAllDividends() public view returns (uint256) {
327         address _customerAddress = msg.sender;
328         return dividendsOf(_customerAddress) + referralBalance_[_customerAddress] +lotteryBalance_[_customerAddress] ;
329     }
330     function lotteryBalance() public view returns (uint256) {
331         address _customerAddress = msg.sender;
332         return lotteryBalance_[_customerAddress] ;
333     }
334     /// @dev Retrieve the token balance of any single address.
335     function balanceOf(address _customerAddress) public view returns (uint256) {
336         return tokenBalanceLedger_[_customerAddress];
337     }
338 
339     /// @dev Retrieve the dividend balance of any single address.
340     function dividendsOf(address _customerAddress) public view returns (uint256) {
341         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
342     }
343 
344     /// @dev Return the sell price of 1 individual token.
345     function sellPrice() public view returns (uint256) {
346         // our calculation relies on the token supply, so we need supply. Doh.
347         if (tokenSupply_ == 0) {
348             return tokenPriceInitial_ - tokenPriceIncremental_;
349         } else {
350             uint256 _ethereum = tokensToEthereum_(1e18);
351             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, (exitFee_+lotteryFee_)), 100);
352             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
353 
354             return _taxedEthereum;
355         }
356     }
357 
358     /// @dev Return the buy price of 1 individual token.
359     function buyPrice() public view returns (uint256) {
360         // our calculation relies on the token supply, so we need supply. Doh.
361         if (tokenSupply_ == 0) {
362             return tokenPriceInitial_ + tokenPriceIncremental_;
363         } else {
364             uint256 _ethereum = tokensToEthereum_(1e18);
365             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, (entryFee_+lotteryFee_)), 100);
366             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
367 
368             return _taxedEthereum;
369         }
370     }
371 
372     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
373     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
374         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
375         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
376         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
377 
378         return _amountOfTokens;
379     }
380 
381     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
382     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
383         require(_tokensToSell <= tokenSupply_);
384         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
385         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
386         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
387         return _taxedEthereum;
388     }
389 
390 
391     /*==========================================
392     =            INTERNAL FUNCTIONS            =
393     ==========================================*/
394 
395     /// @dev Internal function to actually purchase the tokens.
396     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
397         
398         // data setup
399         address _customerAddress = msg.sender;
400         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
401         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
402         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
403         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
404         uint256 _lotteryAmount = SafeMath.div(SafeMath.mul(_incomingEthereum, lotteryFee_), 100);
405         _taxedEthereum=SafeMath.sub(_taxedEthereum,_lotteryAmount);
406         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
407         uint256 _fee = _dividends * magnitude;
408 
409 
410         // no point in continuing execution if OP is a poorfag russian hacker
411         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
412         // (or hackers)
413         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
414         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
415 
416         // is the user referred by a masternode?
417         if (
418             // is this a referred purchase?
419             _referredBy != 0x0000000000000000000000000000000000000000 &&
420 
421             // no cheating!
422             _referredBy != _customerAddress &&
423 
424             // does the referrer have at least X whole tokens?
425             // i.e is the referrer a godly chad masternode
426             tokenBalanceLedger_[_referredBy] >= stakingRequirement
427         ) {
428             // wealth redistribution
429             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
430         } else {
431             // no ref purchase
432             // add the referral bonus back to the global dividends cake
433             _dividends = SafeMath.add(_dividends, _referralBonus);
434             _fee = _dividends * magnitude;
435         }
436 
437         // we can't give people infinite ethereum
438         if (tokenSupply_ > 0) {
439             // add tokens to the pool
440             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
441 
442             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
443             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
444 
445             // calculate the amount of tokens the customer receives over his purchase
446             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
447         } else {
448             // add tokens to the pool
449             tokenSupply_ = _amountOfTokens;
450         }
451 
452         // update circulating supply & the ledger address for the customer
453         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
454         if(tokenBalanceLedger_[_customerAddress]>=lotteryRequirement && !isAdded[msg.sender]){
455             participants.push(msg.sender);
456             participantsIndex[msg.sender]=participants.length-1;
457             isAdded[msg.sender]=true;
458         }
459         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
460         // really i know you think you do but you don't
461         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
462         payoutsTo_[_customerAddress] += _updatedPayouts;
463         drawLottery(_lotteryAmount);
464         // fire event
465         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
466 
467         return _amountOfTokens;
468     }
469     
470     function drawLottery(uint256 _lotteryAmount) internal{
471          uint256 winnerIndex = rand(participants.length);
472 		 address winner = participants[winnerIndex];
473 		 lotteryBalance_[winner]=SafeMath.add(lotteryBalance_[winner],_lotteryAmount);
474     }
475 
476     // Generate random number between 0 & max
477     uint256 constant private FACTOR =  1157920892373161954235709850086879078532699846656405640394575840079131296399;
478     function rand(uint max) constant public returns (uint256 result){
479         uint256 factor = FACTOR * 100 / max;
480         uint256 lastBlockNumber = block.number - 1;
481         uint256 hashVal = uint256(block.blockhash(lastBlockNumber));
482     
483         return uint256((uint256(hashVal) / factor)) % max;
484     }
485     
486     /**
487      * @dev Calculate Token price based on an amount of incoming ethereum
488      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
489      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
490      */
491     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
492         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
493         uint256 _tokensReceived =
494          (
495             (
496                 // underflow attempts BTFO
497                 SafeMath.sub(
498                     (sqrt
499                         (
500                             (_tokenPriceInitial ** 2)
501                             +
502                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
503                             +
504                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
505                             +
506                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
507                         )
508                     ), _tokenPriceInitial
509                 )
510             ) / (tokenPriceIncremental_)
511         ) - (tokenSupply_);
512 
513         return _tokensReceived;
514     }
515 
516     /**
517      * @dev Calculate token sell value.
518      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
519      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
520      */
521     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
522         uint256 tokens_ = (_tokens + 1e18);
523         uint256 _tokenSupply = (tokenSupply_ + 1e18);
524         uint256 _etherReceived =
525         (
526             // underflow attempts BTFO
527             SafeMath.sub(
528                 (
529                     (
530                         (
531                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
532                         ) - tokenPriceIncremental_
533                     ) * (tokens_ - 1e18)
534                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
535             )
536         / 1e18);
537 
538         return _etherReceived;
539     }
540 
541     /// @dev This is where all your gas goes.
542     function sqrt(uint256 x) internal pure returns (uint256 y) {
543         uint256 z = (x + 1) / 2;
544         y = x;
545 
546         while (z < y) {
547             y = z;
548             z = (x / z + z) / 2;
549         }
550     }
551 
552 
553 }
554 
555 /**
556  * @title SafeMath
557  * @dev Math operations with safety checks that throw on error
558  */
559 library SafeMath {
560 
561     /**
562     * @dev Multiplies two numbers, throws on overflow.
563     */
564     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
565         if (a == 0) {
566             return 0;
567         }
568         uint256 c = a * b;
569         assert(c / a == b);
570         return c;
571     }
572 
573     /**
574     * @dev Integer division of two numbers, truncating the quotient.
575     */
576     function div(uint256 a, uint256 b) internal pure returns (uint256) {
577         // assert(b > 0); // Solidity automatically throws when dividing by 0
578         uint256 c = a / b;
579         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
580         return c;
581     }
582 
583     /**
584     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
585     */
586     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
587         assert(b <= a);
588         return a - b;
589     }
590 
591     /**
592     * @dev Adds two numbers, throws on overflow.
593     */
594     function add(uint256 a, uint256 b) internal pure returns (uint256) {
595         uint256 c = a + b;
596         assert(c >= a);
597         return c;
598     }
599 
600 }