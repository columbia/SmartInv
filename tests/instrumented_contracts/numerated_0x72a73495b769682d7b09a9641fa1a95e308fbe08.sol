1 pragma solidity ^0.4.21;
2 
3 // File: contracts/P4RTYRelay.sol
4 
5 /*
6  * Visit: https://p4rty.io
7  * Discord: https://discord.gg/7y3DHYF
8  * Copyright Mako Labs LLC 2018 All Rights Reseerved
9 */
10 
11 interface P4RTYRelay {
12     /**
13     * @dev Will relay to internal implementation
14     * @param beneficiary Token purchaser
15     * @param tokenAmount Number of tokens to be minted
16     */
17     function relay(address beneficiary, uint256 tokenAmount) external;
18 }
19 
20 // File: contracts/ReinvestProxy.sol
21 
22 /*
23  * Visit: https://p4rty.io
24  * Discord: https://discord.gg/7y3DHYF
25  * Copyright Mako Labs LLC 2018 All Rights Reseerved
26 */
27 interface ReinvestProxy {
28 
29     /// @dev Converts all incoming ethereum to tokens for the caller,
30     function reinvestFor(address customer) external payable;
31 
32 }
33 
34 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
35 
36 /**
37  * @title SafeMath
38  * @dev Math operations with safety checks that throw on error
39  */
40 library SafeMath {
41 
42   /**
43   * @dev Multiplies two numbers, throws on overflow.
44   */
45   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
46     if (a == 0) {
47       return 0;
48     }
49     c = a * b;
50     assert(c / a == b);
51     return c;
52   }
53 
54   /**
55   * @dev Integer division of two numbers, truncating the quotient.
56   */
57   function div(uint256 a, uint256 b) internal pure returns (uint256) {
58     // assert(b > 0); // Solidity automatically throws when dividing by 0
59     // uint256 c = a / b;
60     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61     return a / b;
62   }
63 
64   /**
65   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
66   */
67   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68     assert(b <= a);
69     return a - b;
70   }
71 
72   /**
73   * @dev Adds two numbers, throws on overflow.
74   */
75   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
76     c = a + b;
77     assert(c >= a);
78     return c;
79   }
80 }
81 
82 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
83 
84 /**
85  * @title Ownable
86  * @dev The Ownable contract has an owner address, and provides basic authorization control
87  * functions, this simplifies the implementation of "user permissions".
88  */
89 contract Ownable {
90   address public owner;
91 
92 
93   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
94 
95 
96   /**
97    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
98    * account.
99    */
100   constructor() public {
101     owner = msg.sender;
102   }
103 
104   /**
105    * @dev Throws if called by any account other than the owner.
106    */
107   modifier onlyOwner() {
108     require(msg.sender == owner);
109     _;
110   }
111 
112   /**
113    * @dev Allows the current owner to transfer control of the contract to a newOwner.
114    * @param newOwner The address to transfer ownership to.
115    */
116   function transferOwnership(address newOwner) public onlyOwner {
117     require(newOwner != address(0));
118     emit OwnershipTransferred(owner, newOwner);
119     owner = newOwner;
120   }
121 
122 }
123 
124 // File: openzeppelin-solidity/contracts/ownership/Whitelist.sol
125 
126 /**
127  * @title Whitelist
128  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
129  * @dev This simplifies the implementation of "user permissions".
130  */
131 contract Whitelist is Ownable {
132   mapping(address => bool) public whitelist;
133 
134   event WhitelistedAddressAdded(address addr);
135   event WhitelistedAddressRemoved(address addr);
136 
137   /**
138    * @dev Throws if called by any account that's not whitelisted.
139    */
140   modifier onlyWhitelisted() {
141     require(whitelist[msg.sender]);
142     _;
143   }
144 
145   /**
146    * @dev add an address to the whitelist
147    * @param addr address
148    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
149    */
150   function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {
151     if (!whitelist[addr]) {
152       whitelist[addr] = true;
153       emit WhitelistedAddressAdded(addr);
154       success = true;
155     }
156   }
157 
158   /**
159    * @dev add addresses to the whitelist
160    * @param addrs addresses
161    * @return true if at least one address was added to the whitelist,
162    * false if all addresses were already in the whitelist
163    */
164   function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
165     for (uint256 i = 0; i < addrs.length; i++) {
166       if (addAddressToWhitelist(addrs[i])) {
167         success = true;
168       }
169     }
170   }
171 
172   /**
173    * @dev remove an address from the whitelist
174    * @param addr address
175    * @return true if the address was removed from the whitelist,
176    * false if the address wasn't in the whitelist in the first place
177    */
178   function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
179     if (whitelist[addr]) {
180       whitelist[addr] = false;
181       emit WhitelistedAddressRemoved(addr);
182       success = true;
183     }
184   }
185 
186   /**
187    * @dev remove addresses from the whitelist
188    * @param addrs addresses
189    * @return true if at least one address was removed from the whitelist,
190    * false if all addresses weren't in the whitelist in the first place
191    */
192   function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
193     for (uint256 i = 0; i < addrs.length; i++) {
194       if (removeAddressFromWhitelist(addrs[i])) {
195         success = true;
196       }
197     }
198   }
199 
200 }
201 
202 // File: contracts/P4.sol
203 
204 /*
205  * Visit: https://p4rty.io
206  * Discord: https://discord.gg/7y3DHYF
207  * Stable + DIVIS: Whale and Minow Friendly
208  * Fees balanced for capital preservation for long term HODLERS
209  * Active depositors rewarded with P4RTY tokens; sellers forgiveness, just 5%
210  * 50% of ETH value in earned P4RTY token rewards
211  * P4RTYRelay is notified on all dividend producing transactions
212  *
213  *
214  * P4
215  * The worry free way to earn ETH & P4RTY reward tokens
216  *
217  * -> What?
218  * The first true Virtual Deposit Contract:
219  * [✓] Pegged to ETH, P4 protects your ETH balance; .001 ETH per P4 token
220  * [✓] The only VDC that is part of the P4RTY Entertainment Network
221  * [✓] Earn ERC20 P4RTY tokens on all ETH deposit activities; send them to family and friends
222  * [✓] Referrals permanently saved in contract; reliable income for supporters, at any scale
223  * [✓] 15% dividends for token purchase, shared among all token holders.
224  * [✓] 5% dividends for token selling, shared among all token holders.
225  * [✓] 1% dividends for token transfer, shared among all token holders.
226  * [✓] 4.5% of deposit on referrals.
227  * [✓] 3% of deposit for maintenance fee on deposits for development, operations, and promotion
228  * [✓] 100 tokens to activate referral links; .1 ETH
229 */
230 
231 contract P4 is Whitelist {
232 
233 
234     /*=================================
235     =            MODIFIERS            =
236     =================================*/
237 
238     /// @dev Only people with tokens
239     modifier onlyTokenHolders {
240         require(myTokens() > 0);
241         _;
242     }
243 
244     /// @dev Only people with profits
245     modifier onlyDivis {
246         require(myDividends(true) > 0);
247         _;
248     }
249 
250 
251     /*==============================
252     =            EVENTS            =
253     ==============================*/
254 
255     event onTokenPurchase(
256         address indexed customerAddress,
257         uint256 incomingEthereum,
258         uint256 tokensMinted,
259         address indexed referredBy,
260         uint timestamp,
261         uint256 price
262     );
263 
264     event onTokenSell(
265         address indexed customerAddress,
266         uint256 tokensBurned,
267         uint256 ethereumEarned,
268         uint timestamp,
269         uint256 price
270     );
271 
272     event onReinvestment(
273         address indexed customerAddress,
274         uint256 ethereumReinvested,
275         uint256 tokensMinted
276     );
277 
278     event onReinvestmentProxy(
279         address indexed customerAddress,
280         address indexed destinationAddress,
281         uint256 ethereumReinvested
282     );
283 
284     event onWithdraw(
285         address indexed customerAddress,
286         uint256 ethereumWithdrawn
287     );
288 
289     // ERC20
290     event Transfer(
291         address indexed from,
292         address indexed to,
293         uint256 tokens
294     );
295 
296 
297     /*=====================================
298     =            CONFIGURABLES            =
299     =====================================*/
300 
301     /// @dev 15% dividends for token purchase
302     uint256  internal entryFee_ = 15;
303 
304     /// @dev 1% dividends for token transfer
305     uint256  internal transferFee_ = 1;
306 
307     /// @dev 5% dividends for token selling
308     uint256  internal exitFee_ = 5;
309 
310     /// @dev 30% of entryFee_  is given to referrer
311     uint256  internal referralFee_ = 30;
312 
313     /// @dev 20% of entryFee/exit fee is given to maintainer
314     uint256  internal maintenanceFee = 20;
315     address  internal maintenanceAddress;
316 
317     uint256 constant internal tokenRatio_ = 1000;
318     uint256 constant internal magnitude = 2 ** 64;
319 
320     /// @dev proof of stake (defaults at 100 tokens)
321     uint256 public stakingRequirement = 100e18;
322 
323 
324     /*=================================
325      =            DATASETS            =
326      ================================*/
327 
328     // amount of shares for each address (scaled number)
329     mapping(address => uint256) internal tokenBalanceLedger_;
330     mapping(address => uint256) internal referralBalance_;
331     mapping(address => int256) internal payoutsTo_;
332     //on chain referral tracking
333     mapping(address => address) public referrals;
334     uint256 internal tokenSupply_;
335     uint256 internal profitPerShare_;
336 
337     P4RTYRelay public relay;
338 
339 
340     /*=======================================
341     =            PUBLIC FUNCTIONS           =
342     =======================================*/
343 
344     constructor(address relayAddress)  public {
345 
346         relay = P4RTYRelay(relayAddress);
347 
348         //assume caller as default
349         updateMaintenanceAddress(msg.sender);
350     }
351 
352     function updateMaintenanceAddress(address maintenance) onlyOwner public {
353         maintenanceAddress = maintenance;
354     }
355 
356     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
357     function buyFor(address _customerAddress, address _referredBy) onlyWhitelisted public payable returns (uint256) {
358         setReferral(_referredBy);
359         return purchaseTokens(_customerAddress, msg.value);
360     }
361 
362     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
363     function buy(address _referredBy) public payable returns (uint256) {
364         setReferral(_referredBy);
365         return purchaseTokens(msg.sender, msg.value);
366     }
367 
368     function setReferral(address _referredBy) internal {
369         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
370             referrals[msg.sender]=_referredBy;
371         }
372     }
373 
374     /**
375      * @dev Fallback function to handle ethereum that was send straight to the contract
376      *  Unfortunately we cannot use a referral address this way.
377      */
378     function() payable public {
379         purchaseTokens(msg.sender, msg.value);
380     }
381 
382     /// @dev Converts all of caller's dividends to tokens.
383     function reinvest() onlyDivis public {
384         address _customerAddress = msg.sender;
385 
386         // fetch dividends
387         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
388 
389         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
390 
391         // retrieve ref. bonus
392         _dividends += referralBalance_[_customerAddress];
393         referralBalance_[_customerAddress] = 0;
394 
395         // dispatch a buy order with the virtualized "withdrawn dividends"
396         uint256 _tokens = purchaseTokens(_customerAddress, _dividends);
397 
398         // fire event
399         emit onReinvestment(_customerAddress, _dividends, _tokens);
400     }
401 
402     function reinvestByProxy(address _customerAddress) onlyWhitelisted public {
403         // fetch dividends
404         uint256 _dividends = dividendsOf(_customerAddress); // retrieve ref. bonus later in the code
405 
406 
407         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
408 
409         // retrieve ref. bonus
410         _dividends += referralBalance_[_customerAddress];
411         referralBalance_[_customerAddress] = 0;
412 
413         // dispatch a buy order with the virtualized "withdrawn dividends"
414         ReinvestProxy reinvestProxy =  ReinvestProxy(msg.sender);
415         reinvestProxy.reinvestFor.value(_dividends)(_customerAddress);
416 
417         emit  onReinvestmentProxy(_customerAddress, msg.sender, _dividends);
418 
419 
420     }
421 
422     /// @dev Alias of sell() and withdraw().
423     function exit() external {
424         // get token count for caller & sell them all
425         address _customerAddress = msg.sender;
426         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
427         if (_tokens > 0) sell(_tokens);
428 
429         // lambo delivery service
430         withdraw();
431     }
432 
433     /// @dev Withdraws all of the callers earnings.
434     function withdraw() onlyDivis public {
435 
436         address _customerAddress = msg.sender;
437         // setup data
438         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
439 
440         // update dividend tracker
441         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
442 
443         // add ref. bonus
444         _dividends += referralBalance_[_customerAddress];
445         referralBalance_[_customerAddress] = 0;
446 
447         // lambo delivery service
448         _customerAddress.transfer(_dividends);
449 
450         // fire event
451         emit onWithdraw(_customerAddress, _dividends);
452     }
453 
454 
455     /// @dev Liquifies tokens to ethereum.
456     function sell(uint256 _amountOfTokens) onlyTokenHolders public {
457         address _customerAddress = msg.sender;
458 
459 
460         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
461         uint256 _tokens = _amountOfTokens;
462         uint256 _ethereum = tokensToEthereum_(_tokens);
463 
464 
465         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
466         uint256 _maintenance = SafeMath.div(SafeMath.mul(_undividedDividends,maintenanceFee),100);
467         //maintenance and referral come out of the exitfee
468         uint256 _dividends = SafeMath.sub(_undividedDividends, _maintenance);
469         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _undividedDividends);
470 
471         // burn the sold tokens
472         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
473         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
474 
475         // update dividends tracker
476         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
477         payoutsTo_[_customerAddress] -= _updatedPayouts;
478 
479 
480         //Apply maintenance fee as a referral
481         referralBalance_[maintenanceAddress] = SafeMath.add(referralBalance_[maintenanceAddress], _maintenance);
482 
483         // dividing by zero is a bad idea
484         if (tokenSupply_ > 0) {
485             // update the amount of dividends per token
486             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
487         }
488 
489         // fire event
490         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
491     }
492 
493 
494     /**
495      * @dev Transfer tokens from the caller to a new holder.
496      *  Remember, there's a 15% fee here as well.
497      */
498     function transfer(address _toAddress, uint256 _amountOfTokens) onlyTokenHolders external returns (bool){
499 
500         address _customerAddress = msg.sender;
501 
502         // make sure we have the requested tokens
503         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
504 
505         // withdraw all outstanding dividends first
506         if (myDividends(true) > 0) {
507             withdraw();
508         }
509 
510         // liquify a percentage of the tokens that are transfered
511         // these are dispersed to shareholders
512         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
513         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
514         uint256 _dividends = tokensToEthereum_(_tokenFee);
515 
516         // burn the fee tokens
517         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
518 
519         // exchange tokens
520         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
521         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
522 
523         // update dividend trackers
524         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
525         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
526 
527         // disperse dividends among holders
528         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
529 
530         // fire event
531         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
532 
533         // ERC20
534         return true;
535     }
536 
537 
538     /*=====================================
539     =      HELPERS AND CALCULATORS        =
540     =====================================*/
541 
542     /**
543      * @dev Method to view the current Ethereum stored in the contract
544      *  Example: totalEthereumBalance()
545      */
546     function totalEthereumBalance() public view returns (uint256) {
547         return address(this).balance;
548     }
549 
550     /// @dev Retrieve the total token supply.
551     function totalSupply() public view returns (uint256) {
552         return tokenSupply_;
553     }
554 
555     /// @dev Retrieve the tokens owned by the caller.
556     function myTokens() public view returns (uint256) {
557         address _customerAddress = msg.sender;
558         return balanceOf(_customerAddress);
559     }
560 
561     /**
562      * @dev Retrieve the dividends owned by the caller.
563      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
564      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
565      *  But in the internal calculations, we want them separate.
566      */
567     /**
568      * @dev Retrieve the dividends owned by the caller.
569      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
570      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
571      *  But in the internal calculations, we want them separate.
572      */
573     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
574         address _customerAddress = msg.sender;
575         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
576     }
577 
578     /// @dev Retrieve the token balance of any single address.
579     function balanceOf(address _customerAddress) public view returns (uint256) {
580         return tokenBalanceLedger_[_customerAddress];
581     }
582 
583     /// @dev Retrieve the dividend balance of any single address.
584     function dividendsOf(address _customerAddress) public view returns (uint256) {
585         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
586     }
587 
588     /// @dev Return the sell price of 1 individual token.
589     function sellPrice() public view returns (uint256) {
590         uint256 _ethereum = tokensToEthereum_(1e18);
591         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
592         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
593 
594         return _taxedEthereum;
595 
596     }
597 
598     /// @dev Return the buy price of 1 individual token.
599     function buyPrice() public view returns (uint256) {
600         uint256 _ethereum = tokensToEthereum_(1e18);
601         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
602         uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
603 
604         return _taxedEthereum;
605 
606     }
607 
608     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
609     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
610         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
611         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
612         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
613 
614         return _amountOfTokens;
615     }
616 
617     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
618     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
619         require(_tokensToSell <= tokenSupply_);
620         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
621         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
622         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
623         return _taxedEthereum;
624     }
625 
626 
627     /*==========================================
628     =            INTERNAL FUNCTIONS            =
629     ==========================================*/
630 
631     /// @dev Internal function to actually purchase the tokens.
632     function purchaseTokens(address _customerAddress, uint256 _incomingEthereum) internal returns (uint256) {
633         // data setup
634         address _referredBy = referrals[_customerAddress];
635         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
636         uint256 _maintenance = SafeMath.div(SafeMath.mul(_undividedDividends,maintenanceFee),100);
637         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, referralFee_), 100);
638         //maintenance and referral come out of the buyin
639         uint256 _dividends = SafeMath.sub(_undividedDividends, SafeMath.add(_referralBonus,_maintenance));
640         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
641         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
642         uint256 _fee = _dividends * magnitude;
643         uint256 _tokenAllocation = SafeMath.div(_incomingEthereum,2);
644 
645 
646         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
647         // (or hackers)
648         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
649         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
650 
651         //Apply maintenance fee as a referral
652         referralBalance_[maintenanceAddress] = SafeMath.add(referralBalance_[maintenanceAddress], _maintenance);
653 
654         // is the user referred by a masternode?
655         if (
656         // is this a referred purchase?
657             _referredBy != 0x0000000000000000000000000000000000000000 &&
658 
659             // no cheating!
660             _referredBy != _customerAddress &&
661 
662             // does the referrer have at least X whole tokens?
663             // i.e is the referrer a godly chad masternode
664             tokenBalanceLedger_[_referredBy] >= stakingRequirement
665         ) {
666             // wealth redistribution
667             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
668         } else {
669             // no ref purchase
670             // add the referral bonus back to the global dividends cake
671             _dividends = SafeMath.add(_dividends, _referralBonus);
672             _fee = _dividends * magnitude;
673         }
674 
675         // we can't give people infinite ethereum
676         if (tokenSupply_ > 0) {
677             // add tokens to the pool
678             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
679 
680             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
681             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
682 
683             // calculate the amount of tokens the customer receives over his purchase
684             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
685         } else {
686             // add tokens to the pool
687             tokenSupply_ = _amountOfTokens;
688         }
689 
690         // update circulating supply & the ledger address for the customer
691         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
692 
693         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
694         // really i know you think you do but you don't
695         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
696         payoutsTo_[_customerAddress] += _updatedPayouts;
697 
698         //Notifying the relay is simple and should represent the total economic activity which is the _incomingEthereum
699         //Every player is a customer and mints their own tokens when the buy or reinvest, relay P4RTY 50/50
700         relay.relay(maintenanceAddress,_tokenAllocation);
701         relay.relay(_customerAddress,_tokenAllocation);
702 
703         // fire event
704         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
705 
706         return _amountOfTokens;
707     }
708 
709     /**
710      * @dev Calculate Token price based on an amount of incoming ethereum
711      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
712      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
713      */
714     function ethereumToTokens_(uint256 _ethereum) internal pure returns (uint256) {
715         return SafeMath.mul(_ethereum, tokenRatio_);
716     }
717 
718     /**
719      * @dev Calculate token sell value.
720      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
721      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
722      */
723     function tokensToEthereum_(uint256 _tokens) internal pure returns (uint256) {
724         return SafeMath.div(_tokens, tokenRatio_);
725     }
726 
727 }