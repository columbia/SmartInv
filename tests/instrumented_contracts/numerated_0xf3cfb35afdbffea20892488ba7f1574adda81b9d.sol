1 pragma solidity ^0.4.21;
2 
3 /*
4 * One Proof (Proof)
5 * https://oneproof.net
6 * 
7 * Instead of having many small "proof of" smart contracts here you can
8 * re-brand a unique website and use this same smart contract address.
9 * This would benefit all those holding because of the increased volume.
10 * 
11 * 
12 *
13 *
14 * Features:
15 * [✓] 5% rewards for token purchase, shared among all token holders.
16 * [✓] 5% rewards for token selling, shared among all token holders.
17 * [✓] 0% rewards for token transfer.
18 * [✓] 3% rewards is given to referrer which is 60% of the 5% purchase reward.
19 * [✓] Price increment by 0.000000001 instead of 0.00000001 for lower buy/sell price.
20 * [✓] 1 token to activate Masternode referrals.
21 * [✓] Ability to create games and other contracts that transact in One Proof Tokens.
22 * [✓] No Administrators or Ambassadors that can change anything with the contract.
23 * 
24 */
25 
26 /**
27  * Definition of contract accepting One Proof Tokens
28  * Other contracts can reuse the AcceptsProof contract below to support One Proof Tokens
29  */
30 contract AcceptsProof {
31     Proof public tokenContract;
32 
33     function AcceptsProof(address _tokenContract) public {
34         tokenContract = Proof(_tokenContract);
35     }
36 
37     modifier onlyTokenContract {
38         require(msg.sender == address(tokenContract));
39         _;
40     }
41 
42     /**
43     * @dev Standard ERC677 function that will handle incoming token transfers.
44     *
45     * @param _from  Token sender address.
46     * @param _value Amount of tokens.
47     * @param _data  Transaction metadata.
48     */
49     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
50 }
51 
52 contract Proof {
53 
54     /*=================================
55     =            MODIFIERS            =
56     =================================*/
57 
58     /// @dev Only people with tokens
59     modifier onlyBagholders {
60         require(myTokens() > 0);
61         _;
62     }
63 
64     /// @dev Only people with profits
65     modifier onlyStronghands {
66         require(myDividends(true) > 0);
67         _;
68     }
69 
70 	modifier notContract() {
71       require (msg.sender == tx.origin);
72       _;
73     }
74 
75     /*==============================
76     =            EVENTS            =
77     ==============================*/
78 
79     event onTokenPurchase(
80         address indexed customerAddress,
81         uint256 incomingEthereum,
82         uint256 tokensMinted,
83         address indexed referredBy,
84         uint timestamp,
85         uint256 price
86     );
87 
88     event onTokenSell(
89         address indexed customerAddress,
90         uint256 tokensBurned,
91         uint256 ethereumEarned,
92         uint timestamp,
93         uint256 price
94     );
95 
96     event onReinvestment(
97         address indexed customerAddress,
98         uint256 ethereumReinvested,
99         uint256 tokensMinted
100     );
101 
102     event onWithdraw(
103         address indexed customerAddress,
104         uint256 ethereumWithdrawn
105     );
106 
107     // ERC20
108     event Transfer(
109         address indexed from,
110         address indexed to,
111         uint256 tokens
112     );
113 
114 
115     /*=====================================
116     =            CONFIGURABLES            =
117     =====================================*/
118 
119     string public name = "One Proof";
120     string public symbol = "Proof";
121     uint8 constant public decimals = 18;
122 
123     /// @dev 5% rewards for token purchase
124     uint8 constant internal entryFee_ = 5;
125 
126     /// @dev 5% rewards for token selling
127     uint8 constant internal exitFee_ = 5;
128 
129     /// @dev 60% of entryFee_ (i.e. 3% rewards) is given to referrer
130     uint8 constant internal refferalFee_ = 60;
131 
132     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
133     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
134     uint256 constant internal magnitude = 2 ** 64;
135 
136     /// @dev proof of stake just 1 token)
137     uint256 public stakingRequirement = 1e18;
138 
139 
140    /*=================================
141     =            DATASETS            =
142     ================================*/
143 
144     // amount of shares for each address (scaled number)
145     mapping(address => uint256) internal tokenBalanceLedger_;
146     mapping(address => uint256) internal referralBalance_;
147     mapping(address => int256) internal payoutsTo_;
148     uint256 internal tokenSupply_;
149     uint256 internal profitPerShare_;
150 
151 
152     /*=======================================
153     =            PUBLIC FUNCTIONS           =
154     =======================================*/
155 
156     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
157     function buy(address _referredBy) public payable returns (uint256) {
158         purchaseInternal(msg.value, _referredBy);
159     }
160 
161     /**
162      * @dev Fallback function to handle ethereum that was send straight to the contract
163      *  Unfortunately we cannot use a referral address this way.
164      */
165     function() payable public {
166         purchaseInternal(msg.value, 0x0);
167     }
168 
169     /// @dev Converts all of caller's dividends to tokens.
170     function reinvest() onlyStronghands public {
171         // fetch dividends
172         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
173 
174         // pay out the dividends virtually
175         address _customerAddress = msg.sender;
176         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
177 
178         // retrieve ref. bonus
179         _dividends += referralBalance_[_customerAddress];
180         referralBalance_[_customerAddress] = 0;
181 
182         // dispatch a buy order with the virtualized "withdrawn dividends"
183         uint256 _tokens = purchaseTokens(_dividends, 0x0);
184 
185         // fire event
186         emit onReinvestment(_customerAddress, _dividends, _tokens);
187     }
188 
189     /// @dev Alias of sell() and withdraw().
190     function exit() public {
191         // get token count for caller & sell them all
192         address _customerAddress = msg.sender;
193         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
194         if (_tokens > 0) sell(_tokens);
195 
196         // lambo delivery service
197         withdraw();
198     }
199 
200     /// @dev Withdraws all of the callers earnings.
201     function withdraw() onlyStronghands public {
202         // setup data
203         address _customerAddress = msg.sender;
204         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
205 
206         // update dividend tracker
207         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
208 
209         // add ref. bonus
210         _dividends += referralBalance_[_customerAddress];
211         referralBalance_[_customerAddress] = 0;
212 
213         // lambo delivery service
214         _customerAddress.transfer(_dividends);
215 
216         // fire event
217         emit onWithdraw(_customerAddress, _dividends);
218     }
219 
220     /// @dev Liquifies tokens to ethereum.
221     function sell(uint256 _amountOfTokens) onlyBagholders public {
222         // setup data
223         address _customerAddress = msg.sender;
224         // 
225         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
226         uint256 _tokens = _amountOfTokens;
227         uint256 _ethereum = tokensToEthereum_(_tokens);
228         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
229         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
230 
231         // burn the sold tokens
232         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
233         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
234 
235         // update rewards tracker
236         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
237         payoutsTo_[_customerAddress] -= _updatedPayouts;
238 
239         // dividing by zero is a bad idea
240         if (tokenSupply_ > 0) {
241             // update the amount of dividends per token
242             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
243         }
244 
245         // fire event
246         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
247     }
248 
249 	/**
250      * Transfer tokens from the caller to a new holder.
251      * No fee with this transfer
252      */
253     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders() public returns(bool) {
254         // setup
255         address _customerAddress = msg.sender;
256 
257         // make sure we have the requested tokens
258         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
259 
260         // withdraw all outstanding dividends first
261         if(myDividends(true) > 0) withdraw();
262 
263         // exchange tokens
264         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
265         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
266 
267         // update dividend trackers
268         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
269         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
270 
271 
272         // fire event
273         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
274 
275         // ERC20
276         return true;
277     }
278 
279 	/**
280     * Transfer token to a specified address and forward the data to recipient
281     * ERC-677 standard
282     * https://github.com/ethereum/EIPs/issues/677
283     * @param _to    Receiver address.
284     * @param _value Amount of tokens that will be transferred.
285     * @param _data  Transaction metadata.
286     */
287     function transferAndCall(address _to, uint256 _value, bytes _data) external returns (bool) {
288       require(_to != address(0));
289       require(transfer(_to, _value)); // do a normal token transfer to the contract
290 
291       if (isContract(_to)) {
292         AcceptsProof receiver = AcceptsProof(_to);
293         require(receiver.tokenFallback(msg.sender, _value, _data));
294       }
295 
296       return true;
297     }
298 
299 	/**
300 	* Additional check that the game address we are sending tokens to is a contract
301 	* assemble the given address bytecode. If bytecode exists then the _addr is a contract.
302 	*/
303 	function isContract(address _addr) private constant returns (bool is_contract) {
304        // retrieve the size of the code on target address, this needs assembly
305        uint length;
306        assembly { length := extcodesize(_addr) }
307        return length > 0;
308 	}
309 
310     /*=====================================
311     =      HELPERS AND CALCULATORS        =
312     =====================================*/
313 
314     /**
315      * @dev Method to view the current Ethereum stored in the contract
316      *  Example: totalEthereumBalance()
317      */
318     function totalEthereumBalance() public view returns (uint256) {
319         return address(this).balance;
320     }
321 
322     /// @dev Retrieve the total token supply.
323     function totalSupply() public view returns (uint256) {
324         return tokenSupply_;
325     }
326 
327     /// @dev Retrieve the tokens owned by the caller.
328     function myTokens() public view returns (uint256) {
329         address _customerAddress = msg.sender;
330         return balanceOf(_customerAddress);
331     }
332 
333     /**
334      * @dev Retrieve the dividends owned by the caller.
335      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
336      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
337      *  But in the internal calculations, we want them separate.
338      */
339     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
340         address _customerAddress = msg.sender;
341         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
342     }
343 
344     /// @dev Retrieve the token balance of any single address.
345     function balanceOf(address _customerAddress) public view returns (uint256) {
346         return tokenBalanceLedger_[_customerAddress];
347     }
348 
349     /// @dev Retrieve the dividend balance of any single address.
350     function dividendsOf(address _customerAddress) public view returns (uint256) {
351         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
352     }
353 
354     /// @dev Return the sell price of 1 individual token.
355     function sellPrice() public view returns (uint256) {
356         // our calculation relies on the token supply, so we need supply. Doh.
357         if (tokenSupply_ == 0) {
358             return tokenPriceInitial_ - tokenPriceIncremental_;
359         } else {
360             uint256 _ethereum = tokensToEthereum_(1e18);
361             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
362             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
363 
364             return _taxedEthereum;
365         }
366     }
367 
368     /// @dev Return the buy price of 1 individual token.
369     function buyPrice() public view returns (uint256) {
370         // our calculation relies on the token supply, so we need supply. Doh.
371         if (tokenSupply_ == 0) {
372             return tokenPriceInitial_ + tokenPriceIncremental_;
373         } else {
374             uint256 _ethereum = tokensToEthereum_(1e18);
375             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
376             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
377 
378             return _taxedEthereum;
379         }
380     }
381 
382     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
383     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
384         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
385         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
386         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
387 
388         return _amountOfTokens;
389     }
390 
391     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
392     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
393         require(_tokensToSell <= tokenSupply_);
394         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
395         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
396         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
397         return _taxedEthereum;
398     }
399 
400 
401     /*==========================================
402     =            INTERNAL FUNCTIONS            =
403     ==========================================*/
404 	
405     function purchaseInternal(uint256 _incomingEthereum, address _referredBy)
406       notContract()// no contracts allowed
407       internal
408       returns(uint256) {
409 
410       purchaseTokens(_incomingEthereum, _referredBy);
411 
412     }
413 
414 
415     /// @dev Internal function to actually purchase the tokens.
416     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
417         // data setup
418         address _customerAddress = msg.sender;
419         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
420         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
421         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
422         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
423         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
424         uint256 _fee = _dividends * magnitude;
425 
426         // no point in continuing execution if OP is a poorfag russian hacker
427         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
428         // (or hackers)
429         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
430         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
431 
432         // is the user referred by a masternode?
433         if (
434             // is this a referred purchase?
435             _referredBy != 0x0000000000000000000000000000000000000000 &&
436 
437             // no cheating!
438             _referredBy != _customerAddress &&
439 
440             // does the referrer have at least X whole tokens?
441             // i.e is the referrer a godly chad masternode
442             tokenBalanceLedger_[_referredBy] >= stakingRequirement
443         ) {
444             // wealth redistribution
445             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
446         } else {
447             // no ref purchase
448             // add the referral bonus back to the global dividends cake
449             _dividends = SafeMath.add(_dividends, _referralBonus);
450             _fee = _dividends * magnitude;
451         }
452 
453         // we can't give people infinite ethereum
454         if (tokenSupply_ > 0) {
455             // add tokens to the pool
456             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
457 
458             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
459             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
460 
461             // calculate the amount of tokens the customer receives over his purchase
462             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
463         } else {
464             // add tokens to the pool
465             tokenSupply_ = _amountOfTokens;
466         }
467 
468         // update circulating supply & the ledger address for the customer
469         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
470 
471         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
472         // really i know you think you do but you don't
473         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
474         payoutsTo_[_customerAddress] += _updatedPayouts;
475 
476         // fire event
477         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
478 
479         return _amountOfTokens;
480     }
481 
482     /**
483      * @dev Calculate Token price based on an amount of incoming ethereum
484      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
485      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
486      */
487     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
488         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
489         uint256 _tokensReceived =
490          (
491             (
492                 // underflow attempts BTFO
493                 SafeMath.sub(
494                     (sqrt
495                         (
496                             (_tokenPriceInitial ** 2)
497                             +
498                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
499                             +
500                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
501                             +
502                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
503                         )
504                     ), _tokenPriceInitial
505                 )
506             ) / (tokenPriceIncremental_)
507         ) - (tokenSupply_);
508 
509         return _tokensReceived;
510     }
511 
512     /**
513      * @dev Calculate token sell value.
514      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
515      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
516      */
517     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
518         uint256 tokens_ = (_tokens + 1e18);
519         uint256 _tokenSupply = (tokenSupply_ + 1e18);
520         uint256 _etherReceived =
521         (
522             // underflow attempts BTFO
523             SafeMath.sub(
524                 (
525                     (
526                         (
527                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
528                         ) - tokenPriceIncremental_
529                     ) * (tokens_ - 1e18)
530                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
531             )
532         / 1e18);
533 
534         return _etherReceived;
535     }
536 
537     /// @dev This is where all your gas goes.
538     function sqrt(uint256 x) internal pure returns (uint256 y) {
539         uint256 z = (x + 1) / 2;
540         y = x;
541 
542         while (z < y) {
543             y = z;
544             z = (x / z + z) / 2;
545         }
546     }
547 
548 
549 }
550 
551 /**
552  * @title SafeMath
553  * @dev Math operations with safety checks that throw on error
554  */
555 library SafeMath {
556 
557     /**
558     * @dev Multiplies two numbers, throws on overflow.
559     */
560     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
561         if (a == 0) {
562             return 0;
563         }
564         uint256 c = a * b;
565         assert(c / a == b);
566         return c;
567     }
568 
569     /**
570     * @dev Integer division of two numbers, truncating the quotient.
571     */
572     function div(uint256 a, uint256 b) internal pure returns (uint256) {
573         // assert(b > 0); // Solidity automatically throws when dividing by 0
574         uint256 c = a / b;
575         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
576         return c;
577     }
578 
579     /**
580     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
581     */
582     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
583         assert(b <= a);
584         return a - b;
585     }
586 
587     /**
588     * @dev Adds two numbers, throws on overflow.
589     */
590     function add(uint256 a, uint256 b) internal pure returns (uint256) {
591         uint256 c = a + b;
592         assert(c >= a);
593         return c;
594     }
595 
596 }