1 pragma solidity ^0.4.21;
2 
3 // File: contracts/P4RTYRelay.sol
4 
5 interface P4RTYRelay {
6     /**
7     * @dev Will relay to internal implementation
8     * @param beneficiary Token purchaser
9     * @param tokenAmount Number of tokens to be minted
10     */
11     function relay(address beneficiary, uint256 tokenAmount) external;
12 }
13 
14 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
15 
16 /**
17  * @title SafeMath
18  * @dev Math operations with safety checks that throw on error
19  */
20 library SafeMath {
21 
22   /**
23   * @dev Multiplies two numbers, throws on overflow.
24   */
25   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
26     if (a == 0) {
27       return 0;
28     }
29     c = a * b;
30     assert(c / a == b);
31     return c;
32   }
33 
34   /**
35   * @dev Integer division of two numbers, truncating the quotient.
36   */
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     // uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return a / b;
42   }
43 
44   /**
45   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
46   */
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   /**
53   * @dev Adds two numbers, throws on overflow.
54   */
55   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
56     c = a + b;
57     assert(c >= a);
58     return c;
59   }
60 }
61 
62 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
63 
64 /**
65  * @title Ownable
66  * @dev The Ownable contract has an owner address, and provides basic authorization control
67  * functions, this simplifies the implementation of "user permissions".
68  */
69 contract Ownable {
70   address public owner;
71 
72 
73   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
74 
75 
76   /**
77    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
78    * account.
79    */
80   constructor() public {
81     owner = msg.sender;
82   }
83 
84   /**
85    * @dev Throws if called by any account other than the owner.
86    */
87   modifier onlyOwner() {
88     require(msg.sender == owner);
89     _;
90   }
91 
92   /**
93    * @dev Allows the current owner to transfer control of the contract to a newOwner.
94    * @param newOwner The address to transfer ownership to.
95    */
96   function transferOwnership(address newOwner) public onlyOwner {
97     require(newOwner != address(0));
98     emit OwnershipTransferred(owner, newOwner);
99     owner = newOwner;
100   }
101 
102 }
103 
104 // File: contracts/P4.sol
105 
106 /*
107  * Visit: https://p4rty.io
108  * Discord: https://discord.gg/7y3DHYF
109  * Stable + DIVIS: Whale and Minow Friendly
110  * Fees balanced for capital preservation for long term HODLERS
111  * Active depositors rewarded with P4RTY tokens; sellers forgiveness, just 5%
112  * 50% of ETH value in earned P4RTY token rewards
113  * P4RTYRelay is notified on all dividend producing transactions
114  *
115  *
116  * P4
117  * The worry free way to earn ETH & P4RTY reward tokens
118  *
119  * -> What?
120  * The first true Virtual Deposit Contract:
121  * [✓] Pegged to ETH, P4 protects your ETH balance; .001 ETH per P4 token
122  * [✓] The only VDC that is part of the P4RTY Entertainment Network
123  * [✓] Earn ERC20 P4RTY tokens on all ETH deposit activities; send them to family and friends
124  * [✓] Referrals permanently saved in contract; reliable income for supporters, at any scale
125  * [✓] 15% dividends for token purchase, shared among all token holders.
126  * [✓] 5% dividends for token selling, shared among all token holders.
127  * [✓] 1% dividends for token transfer, shared among all token holders.
128  * [✓] 4.5% of deposit on referrals.
129  * [✓] 3% of deposit for maintenance fee on deposits for development, operations, and promotion
130  * [✓] 100 tokens to activate referral links; .1 ETH
131 */
132 
133 contract P4 is Ownable {
134 
135 
136     /*=================================
137     =            MODIFIERS            =
138     =================================*/
139 
140     /// @dev Only people with tokens
141     modifier onlyBagholders {
142         require(myTokens() > 0);
143         _;
144     }
145 
146     /// @dev Only people with profits
147     modifier onlyStronghands {
148         require(myDividends(true) > 0);
149         _;
150     }
151 
152 
153     /*==============================
154     =            EVENTS            =
155     ==============================*/
156 
157     event onTokenPurchase(
158         address indexed customerAddress,
159         uint256 incomingEthereum,
160         uint256 tokensMinted,
161         address indexed referredBy,
162         uint timestamp,
163         uint256 price
164     );
165 
166     event onTokenSell(
167         address indexed customerAddress,
168         uint256 tokensBurned,
169         uint256 ethereumEarned,
170         uint timestamp,
171         uint256 price
172     );
173 
174     event onReinvestment(
175         address indexed customerAddress,
176         uint256 ethereumReinvested,
177         uint256 tokensMinted
178     );
179 
180     event onWithdraw(
181         address indexed customerAddress,
182         uint256 ethereumWithdrawn
183     );
184 
185     // ERC20
186     event Transfer(
187         address indexed from,
188         address indexed to,
189         uint256 tokens
190     );
191 
192 
193     /*=====================================
194     =            CONFIGURABLES            =
195     =====================================*/
196 
197     string public name = "P4";
198     string public symbol = "P4";
199     uint8 constant public decimals = 18;
200 
201     /// @dev 15% dividends for token purchase
202     uint8 constant internal entryFee_ = 15;
203 
204     /// @dev 1% dividends for token transfer
205     uint8 constant internal transferFee_ = 1;
206 
207     /// @dev 5% dividends for token selling
208     uint8 constant internal exitFee_ = 5;
209 
210     /// @dev 30% of entryFee_ (i.e. 4.5% dividends) is given to referrer
211     uint8 constant internal refferalFee_ = 30;
212 
213     /// @dev 20% of entryFee (i.e. 3% dividends) is given to maintainer
214     uint8 constant internal maintenanceFee = 20;
215     address internal maintenanceAddress;
216 
217     uint256 constant internal tokenRatio_ = 1000;
218     uint256 constant internal magnitude = 2 ** 64;
219 
220     /// @dev proof of stake (defaults at 100 tokens)
221     uint256 public stakingRequirement = 100e18;
222 
223 
224     /*=================================
225      =            DATASETS            =
226      ================================*/
227 
228     // amount of shares for each address (scaled number)
229     mapping(address => uint256) internal tokenBalanceLedger_;
230     mapping(address => uint256) internal referralBalance_;
231     mapping(address => int256) internal payoutsTo_;
232     //on chain referral tracking
233     mapping(address => address) public referrals;
234     uint256 internal tokenSupply_;
235     uint256 internal profitPerShare_;
236 
237     P4RTYRelay public relay;
238 
239 
240     /*=======================================
241     =            PUBLIC FUNCTIONS           =
242     =======================================*/
243 
244     constructor(address relayAddress) Ownable() public {
245         updateRelay(relayAddress);
246         //assume caller as default
247         updateMaintenanceAddress(msg.sender);
248     }
249 
250     function updateRelay (address relayAddress) onlyOwner public {
251         //Set the relay
252         relay = P4RTYRelay(relayAddress);
253     }
254 
255     function updateMaintenanceAddress(address maintenance) onlyOwner public {
256         maintenanceAddress = maintenance;
257     }
258 
259     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
260     function buy(address _referredBy) public payable returns (uint256) {
261         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
262             referrals[msg.sender]=_referredBy;
263         }
264         return purchaseTokens(msg.value);
265     }
266 
267     /**
268      * @dev Fallback function to handle ethereum that was send straight to the contract
269      *  Unfortunately we cannot use a referral address this way.
270      */
271     function() payable public {
272         purchaseTokens(msg.value);
273     }
274 
275     /// @dev Converts all of caller's dividends to tokens.
276     function reinvest() onlyStronghands public {
277         // fetch dividends
278         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
279 
280         // pay out the dividends virtually
281         address _customerAddress = msg.sender;
282         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
283 
284         // retrieve ref. bonus
285         _dividends += referralBalance_[_customerAddress];
286         referralBalance_[_customerAddress] = 0;
287 
288         // dispatch a buy order with the virtualized "withdrawn dividends"
289         uint256 _tokens = purchaseTokens(_dividends);
290 
291         // fire event
292         emit onReinvestment(_customerAddress, _dividends, _tokens);
293     }
294 
295     /// @dev Alias of sell() and withdraw().
296     function exit() external {
297         // get token count for caller & sell them all
298         address _customerAddress = msg.sender;
299         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
300         if (_tokens > 0) sell(_tokens);
301 
302         // lambo delivery service
303         withdraw();
304     }
305 
306     /// @dev Withdraws all of the callers earnings.
307     function withdraw() onlyStronghands public {
308         // setup data
309         address _customerAddress = msg.sender;
310         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
311 
312         // update dividend tracker
313         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
314 
315         // add ref. bonus
316         _dividends += referralBalance_[_customerAddress];
317         referralBalance_[_customerAddress] = 0;
318 
319         // lambo delivery service
320         _customerAddress.transfer(_dividends);
321 
322         // fire event
323         emit onWithdraw(_customerAddress, _dividends);
324     }
325 
326     /// @dev Liquifies tokens to ethereum.
327     function sell(uint256 _amountOfTokens) onlyBagholders public {
328         // setup data
329         address _customerAddress = msg.sender;
330         // russian hackers BTFO
331         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
332         uint256 _tokens = _amountOfTokens;
333         uint256 _ethereum = tokensToEthereum_(_tokens);
334         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
335         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
336 
337         // burn the sold tokens
338         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
339         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
340 
341         // update dividends tracker
342         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
343         payoutsTo_[_customerAddress] -= _updatedPayouts;
344 
345         // dividing by zero is a bad idea
346         if (tokenSupply_ > 0) {
347             // update the amount of dividends per token
348             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
349         }
350 
351         // fire event
352         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
353     }
354 
355 
356     /**
357      * @dev Transfer tokens from the caller to a new holder.
358      *  Remember, there's a 15% fee here as well.
359      */
360     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders external returns (bool) {
361         // setup
362         address _customerAddress = msg.sender;
363 
364         // make sure we have the requested tokens
365         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
366 
367         // withdraw all outstanding dividends first
368         if (myDividends(true) > 0) {
369             withdraw();
370         }
371 
372         // liquify a percentage of the tokens that are transfered
373         // these are dispersed to shareholders
374         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
375         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
376         uint256 _dividends = tokensToEthereum_(_tokenFee);
377 
378         // burn the fee tokens
379         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
380 
381         // exchange tokens
382         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
383         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
384 
385         // update dividend trackers
386         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
387         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
388 
389         // disperse dividends among holders
390         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
391 
392         // fire event
393         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
394 
395         // ERC20
396         return true;
397     }
398 
399 
400     /*=====================================
401     =      HELPERS AND CALCULATORS        =
402     =====================================*/
403 
404     /**
405      * @dev Method to view the current Ethereum stored in the contract
406      *  Example: totalEthereumBalance()
407      */
408     function totalEthereumBalance() public view returns (uint256) {
409         return address(this).balance;
410     }
411 
412     /// @dev Retrieve the total token supply.
413     function totalSupply() public view returns (uint256) {
414         return tokenSupply_;
415     }
416 
417     /// @dev Retrieve the tokens owned by the caller.
418     function myTokens() public view returns (uint256) {
419         address _customerAddress = msg.sender;
420         return balanceOf(_customerAddress);
421     }
422 
423     /**
424      * @dev Retrieve the dividends owned by the caller.
425      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
426      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
427      *  But in the internal calculations, we want them separate.
428      */
429     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
430         address _customerAddress = msg.sender;
431         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
432     }
433 
434     /// @dev Retrieve the token balance of any single address.
435     function balanceOf(address _customerAddress) public view returns (uint256) {
436         return tokenBalanceLedger_[_customerAddress];
437     }
438 
439     /// @dev Retrieve the dividend balance of any single address.
440     function dividendsOf(address _customerAddress) public view returns (uint256) {
441         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
442     }
443 
444     /// @dev Return the sell price of 1 individual token.
445     function sellPrice() public pure returns (uint256) {
446         uint256 _ethereum = tokensToEthereum_(1e18);
447         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
448         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
449 
450         return _taxedEthereum;
451 
452     }
453 
454     /// @dev Return the buy price of 1 individual token.
455     function buyPrice() public pure returns (uint256) {
456         uint256 _ethereum = tokensToEthereum_(1e18);
457         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
458         uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
459 
460         return _taxedEthereum;
461 
462     }
463 
464     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
465     function calculateTokensReceived(uint256 _ethereumToSpend) public pure returns (uint256) {
466         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
467         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
468         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
469 
470         return _amountOfTokens;
471     }
472 
473     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
474     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
475         require(_tokensToSell <= tokenSupply_);
476         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
477         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
478         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
479         return _taxedEthereum;
480     }
481 
482 
483     /*==========================================
484     =            INTERNAL FUNCTIONS            =
485     ==========================================*/
486 
487     /// @dev Internal function to actually purchase the tokens.
488     function purchaseTokens(uint256 _incomingEthereum) internal returns (uint256) {
489         // data setup
490         address _customerAddress = msg.sender;
491         address _referredBy = referrals[msg.sender];
492         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
493         uint256 _maintenance = SafeMath.div(SafeMath.mul(_undividedDividends,maintenanceFee),100);
494         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
495         //maintenance and referral come out of the buyin
496         uint256 _dividends = SafeMath.sub(_undividedDividends, SafeMath.add(_referralBonus,_maintenance));
497         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
498         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
499         uint256 _fee = _dividends * magnitude;
500         uint256 _tokenAllocation = SafeMath.div(_incomingEthereum,2);
501 
502         // no point in continuing execution if OP is a poorfag russian hacker
503         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
504         // (or hackers)
505         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
506         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
507 
508         //Apply maintenance fee as a referral
509         referralBalance_[maintenanceAddress] = SafeMath.add(referralBalance_[maintenanceAddress], _maintenance);
510 
511         // is the user referred by a masternode?
512         if (
513         // is this a referred purchase?
514             _referredBy != 0x0000000000000000000000000000000000000000 &&
515 
516             // no cheating!
517             _referredBy != _customerAddress &&
518 
519             // does the referrer have at least X whole tokens?
520             // i.e is the referrer a godly chad masternode
521             tokenBalanceLedger_[_referredBy] >= stakingRequirement
522         ) {
523             // wealth redistribution
524             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
525         } else {
526             // no ref purchase
527             // add the referral bonus back to the global dividends cake
528             _dividends = SafeMath.add(_dividends, _referralBonus);
529             _fee = _dividends * magnitude;
530         }
531 
532         // we can't give people infinite ethereum
533         if (tokenSupply_ > 0) {
534             // add tokens to the pool
535             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
536 
537             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
538             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
539 
540             // calculate the amount of tokens the customer receives over his purchase
541             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
542         } else {
543             // add tokens to the pool
544             tokenSupply_ = _amountOfTokens;
545         }
546 
547         // update circulating supply & the ledger address for the customer
548         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
549 
550         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
551         // really i know you think you do but you don't
552         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
553         payoutsTo_[_customerAddress] += _updatedPayouts;
554 
555         //Notifying the relay is simple and should represent the total economic activity which is the _incomingEthereum
556         //Every player is a customer and mints their own tokens when the buy or reinvest, relay P4RTY 50/50
557         relay.relay(maintenanceAddress,_tokenAllocation);
558         relay.relay(_customerAddress,_tokenAllocation);
559 
560         // fire event
561         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
562 
563         return _amountOfTokens;
564     }
565 
566     /**
567      * @dev Calculate Token price based on an amount of incoming ethereum
568      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
569      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
570      */
571     function ethereumToTokens_(uint256 _ethereum) internal pure returns (uint256) {
572         return SafeMath.mul(_ethereum, tokenRatio_);
573     }
574 
575     /**
576      * @dev Calculate token sell value.
577      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
578      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
579      */
580     function tokensToEthereum_(uint256 _tokens) internal pure returns (uint256) {
581         return SafeMath.div(_tokens, tokenRatio_);
582     }
583 
584 }