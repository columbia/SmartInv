1 pragma solidity ^0.4.20;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) onlyOwner public {
39     require(newOwner != address(0));
40     OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44 }
45 
46 /**
47  * @title SafeMath
48  * @dev Math operations with safety checks that throw on error
49  */
50 library SafeMath {
51   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
52     uint256 c = a * b;
53     assert(a == 0 || c / a == b);
54     return c;
55   }
56 
57   function div(uint256 a, uint256 b) internal constant returns (uint256) {
58     // assert(b > 0); // Solidity automatically throws when dividing by 0
59     uint256 c = a / b;
60     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61     return c;
62   }
63 
64   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
65     assert(b <= a);
66     return a - b;
67   }
68 
69   function add(uint256 a, uint256 b) internal constant returns (uint256) {
70     uint256 c = a + b;
71     assert(c >= a);
72     return c;
73   }
74 }
75 
76 /**
77  * @title Pausable
78  * @dev Base contract which allows children to implement an emergency stop mechanism.
79  */
80 contract Pausable is Ownable {
81   event Pause();
82   event Unpause();
83 
84   bool public paused = false;
85 
86 
87   /**
88    * @dev Modifier to make a function callable only when the contract is not paused.
89    */
90   modifier whenNotPaused() {
91     require(!paused);
92     _;
93   }
94 
95   /**
96    * @dev Modifier to make a function callable only when the contract is paused.
97    */
98   modifier whenPaused() {
99     require(paused);
100     _;
101   }
102 
103   /**
104    * @dev called by the owner to pause, triggers stopped state
105    */
106   function pause() onlyOwner whenNotPaused public {
107     paused = true;
108     Pause();
109   }
110 
111   /**
112    * @dev called by the owner to unpause, returns to normal state
113    */
114   function unpause() onlyOwner whenPaused public {
115     paused = false;
116     Unpause();
117   }
118 }
119 
120 
121 /*
122 * ====================================*
123 *  _____             ____      _
124 * |  ___|   _ _ __  / ___|___ (_)_ __
125 * | |_ | | | | '_ \| |   / _ \| | '_ \
126 * |  _|| |_| | | | | |__| (_) | | | | |
127 * |_|   \__,_|_| |_|\____\___/|_|_| |_|
128 *
129 * ====================================*
130 * That's a fun coin built by opensource developers,
131 * cleaned out of all previous premined bullshit and
132 * made it clean and fair for the community. :)
133 * Added nice elements like Ownable and Pausable.
134 */
135 
136 contract FunCoin is Ownable, Pausable {
137     using SafeMath for uint256;
138 
139     /*=================================
140     =            MODIFIERS            =
141     =================================*/
142     // only people with tokens
143     modifier onlyBagholders() {
144         require(myTokens() > 0);
145         _;
146     }
147 
148     // only people with profits
149     modifier onlyStronghands() {
150         require(myDividends(true) > 0);
151         _;
152     }
153 
154     /*==============================
155     =            EVENTS            =
156     ==============================*/
157     event onTokenPurchase(
158         address indexed customerAddress,
159         uint256 incomingEthereum,
160         uint256 tokensMinted,
161         address indexed referredBy
162     );
163 
164     event onTokenSell(
165         address indexed customerAddress,
166         uint256 tokensBurned,
167         uint256 ethereumEarned
168     );
169 
170     event onReinvestment(
171         address indexed customerAddress,
172         uint256 ethereumReinvested,
173         uint256 tokensMinted
174     );
175 
176     event onWithdraw(
177         address indexed customerAddress,
178         uint256 ethereumWithdrawn
179     );
180 
181     // ERC20
182     event Transfer(
183         address indexed from,
184         address indexed to,
185         uint256 tokens
186     );
187 
188 
189     /*=====================================
190     =            CONFIGURABLES            =
191     =====================================*/
192     string public name = "FunCoin";
193     string public symbol = "FUN";
194     uint8 constant public decimals = 18;
195     uint8 constant internal dividendFee_ = 15;
196     uint8 constant internal devFee_ = 5;
197     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
198     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
199     uint256 constant internal magnitude = 2**64;
200 
201     // proof of stake (defaults at 100 tokens)
202     uint256 public stakingRequirement = 100e18;
203 
204 
205 
206    /*================================
207     =            DATASETS            =
208     ================================*/
209     // amount of shares for each address (scaled number)
210     mapping(address => uint256) internal tokenBalanceLedger_;
211     mapping(address => uint256) internal referralBalance_;
212     mapping(address => int256) internal payoutsTo_;
213     uint256 internal tokenSupply_ = 0;
214     uint256 internal profitPerShare_;
215 
216 
217     /*=======================================
218     =            PUBLIC FUNCTIONS            =
219     =======================================*/
220 
221     function buy(address _referredBy) whenNotPaused() public payable returns(uint256)
222     {
223         purchaseTokens(msg.value, _referredBy);
224     }
225 
226     /**
227      * Fallback function to handle ethereum that was send straight to the contract
228      * Unfortunately we cannot use a referral address this way.
229      */
230     function() whenNotPaused() payable public
231     {
232         purchaseTokens(msg.value, 0x0);
233     }
234 
235     /**
236      * Converts all of caller's dividends to tokens.
237      */
238     function reinvest() whenNotPaused() onlyStronghands() public
239     {
240         // fetch dividends
241         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
242 
243         // pay out the dividends virtually
244         address _customerAddress = msg.sender;
245         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
246 
247         // retrieve ref. bonus
248         _dividends += referralBalance_[_customerAddress];
249         referralBalance_[_customerAddress] = 0;
250 
251         // dispatch a buy order with the virtualized "withdrawn dividends"
252         uint256 _tokens = purchaseTokens(_dividends, 0x0);
253 
254         // fire event
255         onReinvestment(_customerAddress, _dividends, _tokens);
256     }
257 
258     /**
259      * Alias of sell() and withdraw().
260      */
261     function exit() public
262     {
263         // get token count for caller & sell them all
264         address _customerAddress = msg.sender;
265         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
266         if(_tokens > 0) sell(_tokens);
267 
268         // lambo delivery service
269         withdraw();
270     }
271 
272     /**
273      * Withdraws all of the callers earnings.
274      */
275     function withdraw() onlyStronghands() public
276     {
277         // setup data
278         address _customerAddress = msg.sender;
279         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
280 
281         // update dividend tracker
282         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
283 
284         // add ref. bonus
285         _dividends += referralBalance_[_customerAddress];
286         referralBalance_[_customerAddress] = 0;
287 
288         // lambo delivery service
289         _customerAddress.transfer(_dividends);
290 
291         // fire event
292         onWithdraw(_customerAddress, _dividends);
293     }
294 
295     /**
296      * Liquifies tokens to ethereum.
297      */
298     function sell(uint256 _amountOfTokens) onlyBagholders() public
299     {
300         // setup data
301         address _customerAddress = msg.sender;
302         // russian hackers BTFO
303         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
304         uint256 _tokens = _amountOfTokens;
305         uint256 _ethereum = tokensToEthereum_(_tokens);
306         uint256 _dividends = calculateDividends_(_ethereum);
307         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
308 
309         // burn the sold tokens
310         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
311         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
312 
313         // update dividends tracker
314         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
315         payoutsTo_[_customerAddress] -= _updatedPayouts;
316 
317         // dividing by zero is a bad idea
318         if (tokenSupply_ > 0) {
319             // update the amount of dividends per token
320             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
321         }
322 
323         // fire event
324         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
325     }
326 
327 
328     /**
329      * Transfer tokens from the caller to a new holder.
330      * Remember, there's a 10% fee here as well.
331      */
332     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders() public returns(bool)
333     {
334         // setup
335         address _customerAddress = msg.sender;
336 
337         // make sure we have the requested tokens
338         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
339 
340         // withdraw all outstanding dividends first
341         if(myDividends(true) > 0) withdraw();
342 
343         // liquify 15% of the tokens that are transfered
344         // these are dispersed to shareholders (Be happy shareholder!!! :) )
345         uint256 _tokenFee = calculateDividends_(_amountOfTokens);
346         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
347         uint256 _dividends = tokensToEthereum_(_tokenFee);
348 
349         // burn the fee tokens
350         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
351 
352         // exchange tokens
353         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
354         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
355 
356         // update dividend trackers
357         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
358         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
359 
360         // disperse dividends among holders
361         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
362 
363         // fire event
364         Transfer(_customerAddress, _toAddress, _taxedTokens);
365 
366         // ERC20
367         return true;
368     }
369 
370     /**
371      * Precautionary measures in case we need to adjust the masternode rate.
372      */
373     function setStakingRequirement(uint256 _amountOfTokens) onlyOwner() public
374     {
375         stakingRequirement = _amountOfTokens;
376     }
377 
378     /**
379      * If we want to rebrand, we can.
380      */
381     function setName(string _name) onlyOwner() public
382     {
383         name = _name;
384     }
385 
386     /**
387      * If we want to rebrand, we can.
388      */
389     function setSymbol(string _symbol) onlyOwner() public
390     {
391         symbol = _symbol;
392     }
393 
394 
395     /*----------  HELPERS AND CALCULATORS  ----------*/
396     /**
397      * Method to view the current Ethereum stored in the contract
398      * Example: totalEthereumBalance()
399      */
400     function totalEthereumBalance() public view returns(uint)
401     {
402         return this.balance;
403     }
404 
405     /**
406      * Retrieve the total token supply.
407      */
408     function totalSupply() public view returns(uint256)
409     {
410         return tokenSupply_;
411     }
412 
413     /**
414      * Retrieve the tokens owned by the caller.
415      */
416     function myTokens() public view returns(uint256)
417     {
418         address _customerAddress = msg.sender;
419         return balanceOf(_customerAddress);
420     }
421 
422     /**
423      * Retrieve the dividends owned by the caller.
424      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
425      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
426      * But in the internal calculations, we want them separate.
427      */
428     function myDividends(bool _includeReferralBonus) public view returns(uint256)
429     {
430         address _customerAddress = msg.sender;
431         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
432     }
433 
434     /**
435      * Retrieve the token balance of any single address.
436      */
437     function balanceOf(address _customerAddress) view public returns(uint256)
438     {
439         return tokenBalanceLedger_[_customerAddress];
440     }
441 
442     /**
443      * Retrieve the dividend balance of any single address.
444      */
445     function dividendsOf(address _customerAddress) view public returns(uint256)
446     {
447         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
448     }
449 
450     /**
451      * Return the buy price of 1 individual token.
452      */
453     function sellPrice() public view returns(uint256)
454     {
455         // our calculation relies on the token supply, so we need supply. Doh.
456         if(tokenSupply_ == 0){
457             return tokenPriceInitial_ - tokenPriceIncremental_;
458         } else {
459             uint256 _ethereum = tokensToEthereum_(1e18);
460             uint256 _dividends = calculateDividends_(_ethereum);
461             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
462             return _taxedEthereum;
463         }
464     }
465 
466     /**
467      * Return the sell price of 1 individual token.
468      */
469     function buyPrice() public view returns(uint256)
470     {
471         // our calculation relies on the token supply, so we need supply. Doh.
472         if(tokenSupply_ == 0){
473             return tokenPriceInitial_ + tokenPriceIncremental_;
474         } else {
475             uint256 _ethereum = tokensToEthereum_(1e18);
476             uint256 _dividends = calculateDividends_(_ethereum);
477             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
478             return _taxedEthereum;
479         }
480     }
481 
482     /**
483      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
484      */
485     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns(uint256)
486     {
487         uint256 _dividends = calculateDividends_(_ethereumToSpend);
488         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
489         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
490 
491         return _amountOfTokens;
492     }
493 
494     /**
495      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
496      */
497     function calculateEthereumReceived(uint256 _tokensToSell) public view returns(uint256)
498     {
499         require(_tokensToSell <= tokenSupply_);
500         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
501         uint256 _dividends = calculateDividends_(_ethereum);
502         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
503         return _taxedEthereum;
504     }
505 
506 
507     /*==========================================
508     =            INTERNAL FUNCTIONS            =
509     ==========================================*/
510     // It has refferedBuy, but its not used, so more money to all players :)
511     // And we love to give more money to all players.
512     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns(uint256)
513     {
514         // data setup
515         address _customerAddress = msg.sender;
516         uint256 _undividedDividends = calculateDividends_(_incomingEthereum);
517         uint256 _devCut = calculateDevCut_(_incomingEthereum);
518 
519         uint256 _dividends = SafeMath.sub(_undividedDividends, _devCut);
520         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
521         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
522         uint256 _fee = _dividends * magnitude;
523 
524         // no point in continuing execution if OP is a poorfag russian hacker
525         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
526         // (or hackers)
527         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
528         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
529 
530         // Pay a tiny devCut
531         referralBalance_[owner] = SafeMath.add(referralBalance_[owner], _devCut);
532 
533         // we can't give people infinite ethereum
534         if(tokenSupply_ > 0){
535 
536             // add tokens to the pool
537             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
538 
539             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
540             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
541 
542             // calculate the amount of tokens the customer receives over his purchase
543             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
544 
545         } else {
546             // add tokens to the pool
547             tokenSupply_ = _amountOfTokens;
548         }
549 
550         // update circulating supply & the ledger address for the customer
551         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
552 
553         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
554         //really i know you think you do but you don't
555         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
556         payoutsTo_[_customerAddress] += _updatedPayouts;
557 
558         // fire event
559         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
560 
561         return _amountOfTokens;
562     }
563 
564     /**
565      * Calculate Token price based on an amount of incoming ethereum
566      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
567      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
568      */
569     function ethereumToTokens_(uint256 _ethereum) internal view returns(uint256)
570     {
571         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
572         uint256 _tokensReceived =
573          (
574             (
575                 // underflow attempts BTFO
576                 SafeMath.sub(
577                     (sqrt
578                         (
579                             (_tokenPriceInitial**2)
580                             +
581                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
582                             +
583                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
584                             +
585                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
586                         )
587                     ), _tokenPriceInitial
588                 )
589             )/(tokenPriceIncremental_)
590         )-(tokenSupply_)
591         ;
592 
593         return _tokensReceived;
594     }
595 
596     /**
597      * Calculate token sell value.
598      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
599      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
600      */
601      function tokensToEthereum_(uint256 _tokens) internal view returns(uint256)
602     {
603 
604         uint256 tokens_ = (_tokens + 1e18);
605         uint256 _tokenSupply = (tokenSupply_ + 1e18);
606         uint256 _etherReceived =
607         (
608             // underflow attempts BTFO
609             SafeMath.sub(
610                 (
611                     (
612                         (
613                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
614                         )-tokenPriceIncremental_
615                     )*(tokens_ - 1e18)
616                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
617             )
618         /1e18);
619         return _etherReceived;
620     }
621 
622     /**
623      * Calculate amount of dividends
624      * base on the incoming value from the users.
625      */
626     function calculateDividends_(uint256 _incomingEthereum) internal view returns(uint256) {
627       uint256 _dividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
628       return _dividends;
629     }
630 
631     function calculateDevCut_(uint256 _incomingEthereum) internal view returns(uint256) {
632       uint256 _devCut = SafeMath.div(SafeMath.mul(_incomingEthereum, devFee_), 100);
633       return _devCut;
634     }
635 
636 
637     //This is where all your gas goes, sorry
638     //Not sorry, you probably only paid 1 gwei
639     function sqrt(uint x) internal pure returns (uint y) {
640         uint z = (x + 1) / 2;
641         y = x;
642         while (z < y) {
643             y = z;
644             z = (x / z + z) / 2;
645         }
646     }
647 }