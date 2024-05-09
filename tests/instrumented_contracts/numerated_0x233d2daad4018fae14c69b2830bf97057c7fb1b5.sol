1 pragma solidity ^0.4.21;
2 
3 // zeppelin-solidity: 1.9.0
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 /**
46  * @title ERC20Basic
47  * @dev Simpler version of ERC20 interface
48  * @dev see https://github.com/ethereum/EIPs/issues/179
49  */
50 contract ERC20Basic {
51   function totalSupply() public view returns (uint256);
52   function balanceOf(address who) public view returns (uint256);
53   function transfer(address to, uint256 value) public returns (bool);
54   event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 /**
58  * @title ERC20 interface
59  * @dev see https://github.com/ethereum/EIPs/issues/20
60  */
61 contract ERC20 is ERC20Basic {
62   function allowance(address owner, address spender) public view returns (uint256);
63   function transferFrom(address from, address to, uint256 value) public returns (bool);
64   function approve(address spender, uint256 value) public returns (bool);
65   event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 /**
69  * @title SafeMath
70  * @dev Math operations with safety checks that throw on error
71  */
72 library SafeMath {
73 
74   /**
75   * @dev Multiplies two numbers, throws on overflow.
76   */
77   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
78     if (a == 0) {
79       return 0;
80     }
81     c = a * b;
82     assert(c / a == b);
83     return c;
84   }
85 
86   /**
87   * @dev Integer division of two numbers, truncating the quotient.
88   */
89   function div(uint256 a, uint256 b) internal pure returns (uint256) {
90     // assert(b > 0); // Solidity automatically throws when dividing by 0
91     // uint256 c = a / b;
92     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
93     return a / b;
94   }
95 
96   /**
97   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
98   */
99   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
100     assert(b <= a);
101     return a - b;
102   }
103 
104   /**
105   * @dev Adds two numbers, throws on overflow.
106   */
107   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
108     c = a + b;
109     assert(c >= a);
110     return c;
111   }
112 }
113 
114 /**
115  * @title Crowdsale
116  * @dev Crowdsale is a base contract for managing a token crowdsale,
117  * allowing investors to purchase tokens with ether. This contract implements
118  * such functionality in its most fundamental form and can be extended to provide additional
119  * functionality and/or custom behavior.
120  * The external interface represents the basic interface for purchasing tokens, and conform
121  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
122  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
123  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
124  * behavior.
125  */
126 contract Crowdsale {
127   using SafeMath for uint256;
128 
129   // The token being sold
130   ERC20 public token;
131 
132   // Address where funds are collected
133   address public wallet;
134 
135   // How many token units a buyer gets per wei
136   uint256 public rate;
137 
138   // Amount of wei raised
139   uint256 public weiRaised;
140 
141   /**
142    * Event for token purchase logging
143    * @param purchaser who paid for the tokens
144    * @param beneficiary who got the tokens
145    * @param value weis paid for purchase
146    * @param amount amount of tokens purchased
147    */
148   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
149 
150   /**
151    * @param _rate Number of token units a buyer gets per wei
152    * @param _wallet Address where collected funds will be forwarded to
153    * @param _token Address of the token being sold
154    */
155   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
156     require(_rate > 0);
157     require(_wallet != address(0));
158     require(_token != address(0));
159 
160     rate = _rate;
161     wallet = _wallet;
162     token = _token;
163   }
164 
165   // -----------------------------------------
166   // Crowdsale external interface
167   // -----------------------------------------
168 
169   /**
170    * @dev fallback function ***DO NOT OVERRIDE***
171    */
172   function () external payable {
173     buyTokens(msg.sender);
174   }
175 
176   /**
177    * @dev low level token purchase ***DO NOT OVERRIDE***
178    * @param _beneficiary Address performing the token purchase
179    */
180   function buyTokens(address _beneficiary) public payable {
181 
182     uint256 weiAmount = msg.value;
183     _preValidatePurchase(_beneficiary, weiAmount);
184 
185     // calculate token amount to be created
186     uint256 tokens = _getTokenAmount(weiAmount);
187 
188     // update state
189     weiRaised = weiRaised.add(weiAmount);
190 
191     _processPurchase(_beneficiary, tokens);
192     emit TokenPurchase(
193       msg.sender,
194       _beneficiary,
195       weiAmount,
196       tokens
197     );
198 
199     _updatePurchasingState(_beneficiary, weiAmount);
200 
201     _forwardFunds();
202     _postValidatePurchase(_beneficiary, weiAmount);
203   }
204 
205   // -----------------------------------------
206   // Internal interface (extensible)
207   // -----------------------------------------
208 
209   /**
210    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
211    * @param _beneficiary Address performing the token purchase
212    * @param _weiAmount Value in wei involved in the purchase
213    */
214   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
215     require(_beneficiary != address(0));
216     require(_weiAmount != 0);
217   }
218 
219   /**
220    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
221    * @param _beneficiary Address performing the token purchase
222    * @param _weiAmount Value in wei involved in the purchase
223    */
224   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
225     // optional override
226   }
227 
228   /**
229    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
230    * @param _beneficiary Address performing the token purchase
231    * @param _tokenAmount Number of tokens to be emitted
232    */
233   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
234     token.transfer(_beneficiary, _tokenAmount);
235   }
236 
237   /**
238    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
239    * @param _beneficiary Address receiving the tokens
240    * @param _tokenAmount Number of tokens to be purchased
241    */
242   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
243     _deliverTokens(_beneficiary, _tokenAmount);
244   }
245 
246   /**
247    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
248    * @param _beneficiary Address receiving the tokens
249    * @param _weiAmount Value in wei involved in the purchase
250    */
251   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
252     // optional override
253   }
254 
255   /**
256    * @dev Override to extend the way in which ether is converted to tokens.
257    * @param _weiAmount Value in wei to be converted into tokens
258    * @return Number of tokens that can be purchased with the specified _weiAmount
259    */
260   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
261     return _weiAmount.mul(rate);
262   }
263 
264   /**
265    * @dev Determines how ETH is stored/forwarded on purchases.
266    */
267   function _forwardFunds() internal {
268     wallet.transfer(msg.value);
269   }
270 }
271 
272 /**
273  * @title AllowanceCrowdsale
274  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
275  */
276 contract AllowanceCrowdsale is Crowdsale {
277   using SafeMath for uint256;
278 
279   address public tokenWallet;
280 
281   /**
282    * @dev Constructor, takes token wallet address. 
283    * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
284    */
285   function AllowanceCrowdsale(address _tokenWallet) public {
286     require(_tokenWallet != address(0));
287     tokenWallet = _tokenWallet;
288   }
289 
290   /**
291    * @dev Checks the amount of tokens left in the allowance.
292    * @return Amount of tokens left in the allowance
293    */
294   function remainingTokens() public view returns (uint256) {
295     return token.allowance(tokenWallet, this);
296   }
297 
298   /**
299    * @dev Overrides parent behavior by transferring tokens from wallet.
300    * @param _beneficiary Token purchaser
301    * @param _tokenAmount Amount of tokens purchased
302    */
303   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
304     token.transferFrom(tokenWallet, _beneficiary, _tokenAmount);
305   }
306 }
307 
308 /**
309  * @title IndividuallyCappedCrowdsale
310  * @dev Crowdsale with per-user caps.
311  */
312 contract IndividuallyCappedCrowdsale is Crowdsale, Ownable {
313   using SafeMath for uint256;
314 
315   mapping(address => uint256) public contributions;
316   mapping(address => uint256) public caps;
317 
318   /**
319    * @dev Sets a specific user's maximum contribution.
320    * @param _beneficiary Address to be capped
321    * @param _cap Wei limit for individual contribution
322    */
323   function setUserCap(address _beneficiary, uint256 _cap) external onlyOwner {
324     caps[_beneficiary] = _cap;
325   }
326 
327   /**
328    * @dev Sets a group of users' maximum contribution.
329    * @param _beneficiaries List of addresses to be capped
330    * @param _cap Wei limit for individual contribution
331    */
332   function setGroupCap(address[] _beneficiaries, uint256 _cap) external onlyOwner {
333     for (uint256 i = 0; i < _beneficiaries.length; i++) {
334       caps[_beneficiaries[i]] = _cap;
335     }
336   }
337 
338   /**
339    * @dev Returns the cap of a specific user.
340    * @param _beneficiary Address whose cap is to be checked
341    * @return Current cap for individual user
342    */
343   function getUserCap(address _beneficiary) public view returns (uint256) {
344     return caps[_beneficiary];
345   }
346 
347   /**
348    * @dev Returns the amount contributed so far by a sepecific user.
349    * @param _beneficiary Address of contributor
350    * @return User contribution so far
351    */
352   function getUserContribution(address _beneficiary) public view returns (uint256) {
353     return contributions[_beneficiary];
354   }
355 
356   /**
357    * @dev Extend parent behavior requiring purchase to respect the user's funding cap.
358    * @param _beneficiary Token purchaser
359    * @param _weiAmount Amount of wei contributed
360    */
361   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
362     super._preValidatePurchase(_beneficiary, _weiAmount);
363     require(contributions[_beneficiary].add(_weiAmount) <= caps[_beneficiary]);
364   }
365 
366   /**
367    * @dev Extend parent behavior to update user contributions
368    * @param _beneficiary Token purchaser
369    * @param _weiAmount Amount of wei contributed
370    */
371   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
372     super._updatePurchasingState(_beneficiary, _weiAmount);
373     contributions[_beneficiary] = contributions[_beneficiary].add(_weiAmount);
374   }
375 
376 }
377 
378 /**
379  * @title WhitelistedCrowdsale
380  * @dev Crowdsale in which only whitelisted users can contribute.
381  */
382 contract WhitelistedCrowdsale is Crowdsale, Ownable {
383 
384   mapping(address => bool) public whitelist;
385 
386   /**
387    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
388    */
389   modifier isWhitelisted(address _beneficiary) {
390     require(whitelist[_beneficiary]);
391     _;
392   }
393 
394   /**
395    * @dev Adds single address to whitelist.
396    * @param _beneficiary Address to be added to the whitelist
397    */
398   function addToWhitelist(address _beneficiary) external onlyOwner {
399     whitelist[_beneficiary] = true;
400   }
401 
402   /**
403    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
404    * @param _beneficiaries Addresses to be added to the whitelist
405    */
406   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
407     for (uint256 i = 0; i < _beneficiaries.length; i++) {
408       whitelist[_beneficiaries[i]] = true;
409     }
410   }
411 
412   /**
413    * @dev Removes single address from whitelist.
414    * @param _beneficiary Address to be removed to the whitelist
415    */
416   function removeFromWhitelist(address _beneficiary) external onlyOwner {
417     whitelist[_beneficiary] = false;
418   }
419 
420   /**
421    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
422    * @param _beneficiary Token beneficiary
423    * @param _weiAmount Amount of wei contributed
424    */
425   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
426     super._preValidatePurchase(_beneficiary, _weiAmount);
427   }
428 
429 }
430 
431 /**
432  * @title TimedCrowdsale
433  * @dev Crowdsale accepting contributions only within a time frame.
434  */
435 contract TimedCrowdsale is Crowdsale {
436   using SafeMath for uint256;
437 
438   uint256 public openingTime;
439   uint256 public closingTime;
440 
441   /**
442    * @dev Reverts if not in crowdsale time range.
443    */
444   modifier onlyWhileOpen {
445     // solium-disable-next-line security/no-block-members
446     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
447     _;
448   }
449 
450   /**
451    * @dev Constructor, takes crowdsale opening and closing times.
452    * @param _openingTime Crowdsale opening time
453    * @param _closingTime Crowdsale closing time
454    */
455   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
456     // solium-disable-next-line security/no-block-members
457     require(_openingTime >= block.timestamp);
458     require(_closingTime >= _openingTime);
459 
460     openingTime = _openingTime;
461     closingTime = _closingTime;
462   }
463 
464   /**
465    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
466    * @return Whether crowdsale period has elapsed
467    */
468   function hasClosed() public view returns (bool) {
469     // solium-disable-next-line security/no-block-members
470     return block.timestamp > closingTime;
471   }
472 
473   /**
474    * @dev Extend parent behavior requiring to be within contributing period
475    * @param _beneficiary Token purchaser
476    * @param _weiAmount Amount of wei contributed
477    */
478   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
479     super._preValidatePurchase(_beneficiary, _weiAmount);
480   }
481 
482 }
483 
484 contract Membership {
485   function removeMember(address _user) external;
486   function setMemberTier(address _user, uint _tier);
487 }
488 
489 contract PreSquirrelICO is Crowdsale, TimedCrowdsale, WhitelistedCrowdsale, IndividuallyCappedCrowdsale, AllowanceCrowdsale {
490   using SafeMath for uint;
491 
492   // minimum purchase == 1 ETH
493   uint constant public MIN_PURCHASE = 1 * 1 ether;
494 
495   // maximum (cumulative) purchase == 15 ETH
496   uint constant public MAX_PURCHASE = 15 * 1 ether;
497 
498   // keep track of valuable information
499   uint public totalNtsSold;
500   uint public totalNtsSoldWithBonus;
501   uint public totalEthRcvd;
502 
503   // separately deployed Membership contract since it will be used by multiple (3)
504   // ICO contracts of the different ICO stages (preSquirrel, preICO, ICO)
505   Membership public membership;
506 
507   constructor(
508     uint _startTime,
509     uint _endTime,
510     uint _rate,
511     address _ethWallet,
512     ERC20 _token,
513     address _tokenWallet,
514     Membership _membership
515   ) public
516     Crowdsale(_rate, _ethWallet, _token)
517     TimedCrowdsale(_startTime, _endTime)
518     AllowanceCrowdsale(_tokenWallet)
519   {
520     membership = Membership(_membership);
521   }
522 
523   // override to check atleast min amount eth is being paid
524   function _preValidatePurchase(address _beneficiary, uint _weiAmount)
525     internal
526   {
527     super._preValidatePurchase(_beneficiary, _weiAmount);
528 
529     // check if min contribution amount
530     require(_weiAmount >= MIN_PURCHASE);
531 
532     totalEthRcvd = totalEthRcvd.add(_weiAmount);
533   }
534 
535   // override to add 30% bonus NTS tokens on each purchase
536   function _processPurchase(address _beneficiary, uint _tokenAmount)
537     internal
538   {
539     // 30% bonus added in here, so it is not accounted for when counting in saved per user contributions
540     uint tokenAmountWithBonus_ = _tokenAmount.add(_tokenAmount.div(100).mul(30));
541 
542     totalNtsSold = totalNtsSold.add(_tokenAmount);
543     totalNtsSoldWithBonus = totalNtsSoldWithBonus.add(tokenAmountWithBonus_);
544 
545     _deliverTokens(_beneficiary, tokenAmountWithBonus_);
546   }
547 
548   // override to set max cap + tier per user
549   function addToWhitelist(address _beneficiary)
550     external
551     onlyOwner
552   {
553     whitelist[_beneficiary] = true;
554 
555     // set MAX to 15 eth per user
556     caps[_beneficiary] = MAX_PURCHASE;
557 
558     // all PreSquirrelICO users will become tier 1
559     membership.setMemberTier(_beneficiary, 1);
560   }
561 
562   // override to set max cap + tier per user
563   function addManyToWhitelist(address[] _beneficiaries)
564     external
565     onlyOwner
566   {
567     for (uint i = 0; i < _beneficiaries.length; i++) {
568       whitelist[_beneficiaries[i]] = true;
569 
570       // set MAX to 15 eth per user
571       caps[_beneficiaries[i]] = MAX_PURCHASE;
572 
573       // all PreSquirrelICO users will become tier 1
574       membership.setMemberTier(_beneficiaries[i], 1);
575     }
576   }
577 
578   // override to also remove from members
579   function removeFromWhitelist(address _beneficiary)
580     external
581     onlyOwner
582   {
583     whitelist[_beneficiary] = false;
584 
585     membership.removeMember(_beneficiary);
586   }
587 
588   // helper function so that UI can check if ICO has started
589   function hasStarted()
590     external
591     view
592     returns (bool)
593   {
594     return block.timestamp >= openingTime;
595   }
596 
597   // helper function so that UI can display amount ETH already contributed by user
598   function userAlreadyBoughtEth(address _user)
599     public
600     view
601     returns (uint)
602   {
603     return contributions[_user];
604   }
605 
606   // helper function so that UI can display amount ETH user can still contribute
607   function userCanStillBuyEth(address _user)
608     external
609     view
610     returns (uint)
611   {
612     return MAX_PURCHASE.sub(userAlreadyBoughtEth(_user));
613   }
614 
615   function userIsWhitelisted(address _user)
616     external
617     view
618     returns (bool)
619   {
620     return whitelist[_user];
621   }
622 
623   function getStats()
624     external
625     view
626     returns (uint, uint, uint)
627   {
628     return (totalNtsSold, totalNtsSoldWithBonus, totalEthRcvd);
629   }
630 }