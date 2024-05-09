1 pragma solidity 0.4.23;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     if (a == 0) {
16       return 0;
17     }
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   function totalSupply() public view returns (uint256);
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
66 
67 /**
68  * @title ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/20
70  */
71 contract ERC20 is ERC20Basic {
72   function allowance(address owner, address spender) public view returns (uint256);
73   function transferFrom(address from, address to, uint256 value) public returns (bool);
74   function approve(address spender, uint256 value) public returns (bool);
75   event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
79 
80 /**
81  * @title Crowdsale
82  * @dev Crowdsale is a base contract for managing a token crowdsale,
83  * allowing investors to purchase tokens with ether. This contract implements
84  * such functionality in its most fundamental form and can be extended to provide additional
85  * functionality and/or custom behavior.
86  * The external interface represents the basic interface for purchasing tokens, and conform
87  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
88  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
89  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
90  * behavior.
91  */
92 contract Crowdsale {
93   using SafeMath for uint256;
94 
95   // The token being sold
96   ERC20 public token;
97 
98   // Address where funds are collected
99   address public wallet;
100 
101   // How many token units a buyer gets per wei
102   uint256 public rate;
103 
104   // Amount of wei raised
105   uint256 public weiRaised;
106 
107   /**
108    * Event for token purchase logging
109    * @param purchaser who paid for the tokens
110    * @param beneficiary who got the tokens
111    * @param value weis paid for purchase
112    * @param amount amount of tokens purchased
113    */
114   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
115 
116   /**
117    * @param _rate Number of token units a buyer gets per wei
118    * @param _wallet Address where collected funds will be forwarded to
119    * @param _token Address of the token being sold
120    */
121   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
122     require(_rate > 0);
123     require(_wallet != address(0));
124     require(_token != address(0));
125 
126     rate = _rate;
127     wallet = _wallet;
128     token = _token;
129   }
130 
131   // -----------------------------------------
132   // Crowdsale external interface
133   // -----------------------------------------
134 
135   /**
136    * @dev fallback function ***DO NOT OVERRIDE***
137    */
138   function () external payable {
139     buyTokens(msg.sender);
140   }
141 
142   /**
143    * @dev low level token purchase ***DO NOT OVERRIDE***
144    * @param _beneficiary Address performing the token purchase
145    */
146   function buyTokens(address _beneficiary) public payable {
147 
148     uint256 weiAmount = msg.value;
149     _preValidatePurchase(_beneficiary, weiAmount);
150 
151     // calculate token amount to be created
152     uint256 tokens = _getTokenAmount(weiAmount);
153 
154     // update state
155     weiRaised = weiRaised.add(weiAmount);
156 
157     _processPurchase(_beneficiary, tokens);
158     emit TokenPurchase(
159       msg.sender,
160       _beneficiary,
161       weiAmount,
162       tokens
163     );
164 
165     _updatePurchasingState(_beneficiary, weiAmount);
166 
167     _forwardFunds();
168     _postValidatePurchase(_beneficiary, weiAmount);
169   }
170 
171   // -----------------------------------------
172   // Internal interface (extensible)
173   // -----------------------------------------
174 
175   /**
176    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
177    * @param _beneficiary Address performing the token purchase
178    * @param _weiAmount Value in wei involved in the purchase
179    */
180   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
181     require(_beneficiary != address(0));
182     require(_weiAmount != 0);
183   }
184 
185   /**
186    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
187    * @param _beneficiary Address performing the token purchase
188    * @param _weiAmount Value in wei involved in the purchase
189    */
190   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
191     // optional override
192   }
193 
194   /**
195    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
196    * @param _beneficiary Address performing the token purchase
197    * @param _tokenAmount Number of tokens to be emitted
198    */
199   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
200     token.transfer(_beneficiary, _tokenAmount);
201   }
202 
203   /**
204    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
205    * @param _beneficiary Address receiving the tokens
206    * @param _tokenAmount Number of tokens to be purchased
207    */
208   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
209     _deliverTokens(_beneficiary, _tokenAmount);
210   }
211 
212   /**
213    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
214    * @param _beneficiary Address receiving the tokens
215    * @param _weiAmount Value in wei involved in the purchase
216    */
217   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
218     // optional override
219   }
220 
221   /**
222    * @dev Override to extend the way in which ether is converted to tokens.
223    * @param _weiAmount Value in wei to be converted into tokens
224    * @return Number of tokens that can be purchased with the specified _weiAmount
225    */
226   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
227     return _weiAmount.mul(rate);
228   }
229 
230   /**
231    * @dev Determines how ETH is stored/forwarded on purchases.
232    */
233   function _forwardFunds() internal {
234     wallet.transfer(msg.value);
235   }
236 }
237 
238 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
239 
240 /**
241  * @title Ownable
242  * @dev The Ownable contract has an owner address, and provides basic authorization control
243  * functions, this simplifies the implementation of "user permissions".
244  */
245 contract Ownable {
246   address public owner;
247 
248 
249   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
250 
251 
252   /**
253    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
254    * account.
255    */
256   function Ownable() public {
257     owner = msg.sender;
258   }
259 
260   /**
261    * @dev Throws if called by any account other than the owner.
262    */
263   modifier onlyOwner() {
264     require(msg.sender == owner);
265     _;
266   }
267 
268   /**
269    * @dev Allows the current owner to transfer control of the contract to a newOwner.
270    * @param newOwner The address to transfer ownership to.
271    */
272   function transferOwnership(address newOwner) public onlyOwner {
273     require(newOwner != address(0));
274     emit OwnershipTransferred(owner, newOwner);
275     owner = newOwner;
276   }
277 
278 }
279 
280 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
281 
282 /**
283  * @title Pausable
284  * @dev Base contract which allows children to implement an emergency stop mechanism.
285  */
286 contract Pausable is Ownable {
287   event Pause();
288   event Unpause();
289 
290   bool public paused = false;
291 
292 
293   /**
294    * @dev Modifier to make a function callable only when the contract is not paused.
295    */
296   modifier whenNotPaused() {
297     require(!paused);
298     _;
299   }
300 
301   /**
302    * @dev Modifier to make a function callable only when the contract is paused.
303    */
304   modifier whenPaused() {
305     require(paused);
306     _;
307   }
308 
309   /**
310    * @dev called by the owner to pause, triggers stopped state
311    */
312   function pause() onlyOwner whenNotPaused public {
313     paused = true;
314     emit Pause();
315   }
316 
317   /**
318    * @dev called by the owner to unpause, returns to normal state
319    */
320   function unpause() onlyOwner whenPaused public {
321     paused = false;
322     emit Unpause();
323   }
324 }
325 
326 // File: contracts/PausableCrowdsale.sol
327 
328 /**
329  * @title PausableCrowdsale
330  * @dev Extension of Crowdsale contract that can be paused and unpaused by owner
331  */
332 contract PausableCrowdsale is Crowdsale, Pausable {
333 
334   /**
335    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
336    * @param _beneficiary Address performing the token purchase
337    * @param _weiAmount Value in wei involved in the purchase
338    */
339   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal whenNotPaused {
340     return super._preValidatePurchase(_beneficiary, _weiAmount);
341   }
342 }
343 
344 // File: contracts/interfaces/IDAVToken.sol
345 
346 contract IDAVToken is ERC20 {
347 
348   function name() public view returns (string) {}
349   function symbol() public view returns (string) {}
350   function decimals() public view returns (uint8) {}
351   function increaseApproval(address _spender, uint _addedValue) public returns (bool success);
352   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success);
353 
354   function owner() public view returns (address) {}
355   function transferOwnership(address newOwner) public;
356 
357   function burn(uint256 _value) public;
358 
359   function pauseCutoffTime() public view returns (uint256) {}
360   function paused() public view returns (bool) {}
361   function pause() public;
362   function unpause() public;
363   function setPauseCutoffTime(uint256 _pauseCutoffTime) public;
364 
365 }
366 
367 // File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
368 
369 /**
370  * @title TimedCrowdsale
371  * @dev Crowdsale accepting contributions only within a time frame.
372  */
373 contract TimedCrowdsale is Crowdsale {
374   using SafeMath for uint256;
375 
376   uint256 public openingTime;
377   uint256 public closingTime;
378 
379   /**
380    * @dev Reverts if not in crowdsale time range.
381    */
382   modifier onlyWhileOpen {
383     // solium-disable-next-line security/no-block-members
384     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
385     _;
386   }
387 
388   /**
389    * @dev Constructor, takes crowdsale opening and closing times.
390    * @param _openingTime Crowdsale opening time
391    * @param _closingTime Crowdsale closing time
392    */
393   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
394     // solium-disable-next-line security/no-block-members
395     require(_openingTime >= block.timestamp);
396     require(_closingTime >= _openingTime);
397 
398     openingTime = _openingTime;
399     closingTime = _closingTime;
400   }
401 
402   /**
403    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
404    * @return Whether crowdsale period has elapsed
405    */
406   function hasClosed() public view returns (bool) {
407     // solium-disable-next-line security/no-block-members
408     return block.timestamp > closingTime;
409   }
410 
411   /**
412    * @dev Extend parent behavior requiring to be within contributing period
413    * @param _beneficiary Token purchaser
414    * @param _weiAmount Amount of wei contributed
415    */
416   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
417     super._preValidatePurchase(_beneficiary, _weiAmount);
418   }
419 
420 }
421 
422 // File: openzeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol
423 
424 /**
425  * @title FinalizableCrowdsale
426  * @dev Extension of Crowdsale where an owner can do extra work
427  * after finishing.
428  */
429 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
430   using SafeMath for uint256;
431 
432   bool public isFinalized = false;
433 
434   event Finalized();
435 
436   /**
437    * @dev Must be called after crowdsale ends, to do some extra finalization
438    * work. Calls the contract's finalization function.
439    */
440   function finalize() onlyOwner public {
441     require(!isFinalized);
442     require(hasClosed());
443 
444     finalization();
445     emit Finalized();
446 
447     isFinalized = true;
448   }
449 
450   /**
451    * @dev Can be overridden to add finalization logic. The overriding function
452    * should call super.finalization() to ensure the chain of finalization is
453    * executed entirely.
454    */
455   function finalization() internal {
456   }
457 
458 }
459 
460 // File: contracts/DAVCrowdsale.sol
461 
462 /**
463  * @title DAVCrowdsale
464  * @dev DAV Crowdsale contract
465  */
466 contract DAVCrowdsale is PausableCrowdsale, FinalizableCrowdsale {
467 
468   // Opening time for Whitelist B
469   uint256 public openingTimeB;
470   // Sum of contributions in Wei, per beneficiary
471   mapping(address => uint256) public contributions;
472   // List of beneficiaries whitelisted in group A
473   mapping(address => bool) public whitelistA;
474   // List of beneficiaries whitelisted in group B
475   mapping(address => bool) public whitelistB;
476   // Maximum number of Wei that can be raised
477   uint256 public weiCap;
478   // Maximum number of Vincis that can be sold in Crowdsale
479   uint256 public vinciCap;
480   // Minimal contribution amount in Wei per transaction
481   uint256 public minimalContribution;
482   // Maximal total contribution amount in Wei per beneficiary
483   uint256 public maximalIndividualContribution;
484   // Maximal acceptable gas price
485   uint256 public gasPriceLimit = 50000000000 wei;
486   // Wallet to transfer foundation tokens to
487   address public tokenWallet;
488   // Wallet to transfer locked tokens to (e.g., presale buyers)
489   address public lockedTokensWallet;
490   // DAV Token
491   IDAVToken public davToken;
492   // Amount of Vincis sold
493   uint256 public vinciSold;
494   // Address of account that can manage the whitelist
495   address public whitelistManager;
496 
497   constructor(uint256 _rate, address _wallet, address _tokenWallet, address _lockedTokensWallet, IDAVToken _token, uint256 _weiCap, uint256 _vinciCap, uint256 _minimalContribution, uint256 _maximalIndividualContribution, uint256 _openingTime, uint256 _openingTimeB, uint256 _closingTime) public
498     Crowdsale(_rate, _wallet, _token)
499     TimedCrowdsale(_openingTime, _closingTime)
500   {
501     require(_openingTimeB >= _openingTime);
502     require(_openingTimeB <= _closingTime);
503     require(_weiCap > 0);
504     require(_vinciCap > 0);
505     require(_minimalContribution > 0);
506     require(_maximalIndividualContribution > 0);
507     require(_minimalContribution <= _maximalIndividualContribution);
508     require(_tokenWallet != address(0));
509     require(_lockedTokensWallet != address(0));
510     weiCap = _weiCap;
511     vinciCap = _vinciCap;
512     minimalContribution = _minimalContribution;
513     maximalIndividualContribution = _maximalIndividualContribution;
514     openingTimeB = _openingTimeB;
515     tokenWallet = _tokenWallet;
516     lockedTokensWallet= _lockedTokensWallet;
517     davToken = _token;
518     whitelistManager = msg.sender;
519   }
520 
521   /**
522    * @dev Modifier to make a function callable only if user is in whitelist A, or in whitelist B and openingTimeB has passed
523    */
524   modifier onlyWhitelisted(address _beneficiary) {
525     require(whitelistA[_beneficiary] || (whitelistB[_beneficiary] && block.timestamp >= openingTimeB));
526     _;
527   }
528 
529   /**
530    * @dev Throws if called by any account other than the whitelist manager
531    */
532   modifier onlyWhitelistManager() {
533     require(msg.sender == whitelistManager);
534     _;
535   }
536 
537   /**
538    * @dev Change the whitelist manager
539    *
540    * @param _whitelistManager Address of new whitelist manager
541    */
542   function setWhitelistManager(address _whitelistManager) external onlyOwner {
543     require(_whitelistManager != address(0));
544     whitelistManager= _whitelistManager;
545   }
546 
547   /**
548    * @dev Change the gas price limit
549    *
550    * @param _gasPriceLimit New gas price limit
551    */
552   function setGasPriceLimit(uint256 _gasPriceLimit) external onlyOwner {
553     gasPriceLimit = _gasPriceLimit;
554   }
555 
556   /**
557    * Add a group of users to whitelist A
558    *
559    * @param _beneficiaries List of addresses to be whitelisted
560    */
561   function addUsersWhitelistA(address[] _beneficiaries) external onlyWhitelistManager {
562     for (uint256 i = 0; i < _beneficiaries.length; i++) {
563       whitelistA[_beneficiaries[i]] = true;
564     }
565   }
566 
567   /**
568    * Add a group of users to whitelist B
569    *
570    * @param _beneficiaries List of addresses to be whitelisted
571    */
572   function addUsersWhitelistB(address[] _beneficiaries) external onlyWhitelistManager {
573     for (uint256 i = 0; i < _beneficiaries.length; i++) {
574       whitelistB[_beneficiaries[i]] = true;
575     }
576   }
577 
578   /**
579    * Remove a group of users from whitelist A
580    *
581    * @param _beneficiaries List of addresses to be removed from whitelist
582    */
583   function removeUsersWhitelistA(address[] _beneficiaries) external onlyWhitelistManager {
584     for (uint256 i = 0; i < _beneficiaries.length; i++) {
585       whitelistA[_beneficiaries[i]] = false;
586     }
587   }
588 
589   /**
590    * Remove a group of users from whitelist B
591    *
592    * @param _beneficiaries List of addresses to be removed from whitelist
593    */
594   function removeUsersWhitelistB(address[] _beneficiaries) external onlyWhitelistManager {
595     for (uint256 i = 0; i < _beneficiaries.length; i++) {
596       whitelistB[_beneficiaries[i]] = false;
597     }
598   }
599 
600   /**
601    * Allow adjustment of the closing time
602    *
603    * @param _closingTime Time to close the sale. If in the past will set to the present
604    */
605   function closeEarly(uint256 _closingTime) external onlyOwner onlyWhileOpen {
606     // Make sure the new closing time isn't after the old closing time
607     require(_closingTime <= closingTime);
608     // solium-disable-next-line security/no-block-members
609     if (_closingTime < block.timestamp) {
610       // If closing time is in the past, set closing time to right now
611       closingTime = block.timestamp;
612     } else {
613       // Update the closing time
614       closingTime = _closingTime;
615     }
616   }
617 
618   /**
619    * Record a transaction that happened during the presale and transfer tokens to locked tokens wallet
620    *
621    * @param _weiAmount Value in wei involved in the purchase
622    * @param _vinciAmount Amount of Vincis sold
623    */
624   function recordSale(uint256 _weiAmount, uint256 _vinciAmount) external onlyOwner {
625     // Verify that the amount won't put us over the wei cap
626     require(weiRaised.add(_weiAmount) <= weiCap);
627     // Verify that the amount won't put us over the vinci cap
628     require(vinciSold.add(_vinciAmount) <= vinciCap);
629     // Verify Crowdsale hasn't been finalized yet
630     require(!isFinalized);
631     // Update crowdsale totals
632     weiRaised = weiRaised.add(_weiAmount);
633     vinciSold = vinciSold.add(_vinciAmount);
634     // Transfer tokens
635     token.transfer(lockedTokensWallet, _vinciAmount);
636   }
637 
638   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhitelisted(_beneficiary) {
639     super._preValidatePurchase(_beneficiary, _weiAmount);
640     // Verify that the amount won't put us over the wei cap
641     require(weiRaised.add(_weiAmount) <= weiCap);
642     // Verify that the amount won't put us over the vinci cap
643     require(vinciSold.add(_weiAmount.mul(rate)) <= vinciCap);
644     // Verify amount is larger than or equal to minimal contribution
645     require(_weiAmount >= minimalContribution);
646     // Verify that the gas price is lower than 50 gwei
647     require(tx.gasprice <= gasPriceLimit);
648     // Verify that user hasn't contributed more than the individual hard cap
649     require(contributions[_beneficiary].add(_weiAmount) <= maximalIndividualContribution);
650   }
651 
652   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
653     super._updatePurchasingState(_beneficiary, _weiAmount);
654     // Update user contribution total
655     contributions[_beneficiary] = contributions[_beneficiary].add(_weiAmount);
656     // Update total Vincis sold
657     vinciSold = vinciSold.add(_weiAmount.mul(rate));
658   }
659 
660   function finalization() internal {
661     super.finalization();
662     // transfer tokens to foundation
663     uint256 foundationTokens = weiRaised.div(2).add(weiRaised);
664     foundationTokens = foundationTokens.mul(rate);
665     uint256 crowdsaleBalance = davToken.balanceOf(this);
666     if (crowdsaleBalance < foundationTokens) {
667       foundationTokens = crowdsaleBalance;
668     }
669     davToken.transfer(tokenWallet, foundationTokens);
670     // Burn off remaining tokens
671     crowdsaleBalance = davToken.balanceOf(this);
672     davToken.burn(crowdsaleBalance);
673     // Set token's pause cutoff time to 3 weeks from closing time
674     davToken.setPauseCutoffTime(closingTime.add(1814400));
675     // transfer token Ownership back to original owner
676     davToken.transferOwnership(owner);
677   }
678 
679 }