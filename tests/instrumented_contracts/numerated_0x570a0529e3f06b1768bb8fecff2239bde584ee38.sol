1 pragma solidity ^0.4.23;
2 
3 // File: contracts/grapevine/crowdsale/BurnableTokenInterface.sol
4 
5 /**
6  * @title Burnable Token Interface, defining one single function to burn tokens.
7  * @dev Grapevine Crowdsale
8  **/
9 contract BurnableTokenInterface {
10 
11   /**
12   * @dev Burns a specific amount of tokens.
13   * @param _value The amount of token to be burned.
14   */
15   function burn(uint256 _value) public;
16 }
17 
18 // File: contracts/grapevine/crowdsale/GrapevineWhitelistInterface.sol
19 
20 /**
21  * @title Grapevine Whitelist extends the zeppelin Whitelist and adding off-chain signing capabilities.
22  * @dev Grapevine Crowdsale
23  **/
24 contract GrapevineWhitelistInterface {
25 
26   /**
27    * @dev Function to check if an address is whitelisted or not
28    * @param _address address The address to be checked.
29    */
30   function whitelist(address _address) view external returns (bool);
31 
32  
33   /**
34    * @dev Handles the off-chain whitelisting.
35    * @param _addr Address of the sender.
36    * @param _sig signed message provided by the sender.
37    */
38   function handleOffchainWhitelisted(address _addr, bytes _sig) external returns (bool);
39 }
40 
41 // File: contracts/grapevine/crowdsale/TokenTimelockControllerInterface.sol
42 
43 /**
44  * @title TokenTimelock Controller Interface
45  * @dev This contract allows the crowdsale to create locked bonuses and activate the controller.
46  **/
47 contract TokenTimelockControllerInterface {
48 
49   /**
50    * @dev Function to activate the controller.
51    * It can be called only by the crowdsale address.
52    */
53   function activate() external;
54 
55   /**
56    * @dev Creates a lock for the provided _beneficiary with the provided amount
57    * The creation can be peformed only if:
58    * - the sender is the address of the crowdsale;
59    * - the _beneficiary and _tokenHolder are valid addresses;
60    * - the _amount is greater than 0 and was appoved by the _tokenHolder prior to the transaction.
61    * The investors will have a lock with a lock period of 6 months.
62    * @param _beneficiary Address that will own the lock.
63    * @param _amount the amount of the locked tokens.
64    * @param _start when the lock should start.
65    * @param _tokenHolder the account that approved the amount for this contract.
66    */
67   function createInvestorTokenTimeLock(
68     address _beneficiary,
69     uint256 _amount, 
70     uint256 _start,
71     address _tokenHolder
72     ) external returns (bool);
73 }
74 
75 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
76 
77 /**
78  * @title SafeMath
79  * @dev Math operations with safety checks that throw on error
80  */
81 library SafeMath {
82 
83   /**
84   * @dev Multiplies two numbers, throws on overflow.
85   */
86   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
87     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
88     // benefit is lost if 'b' is also tested.
89     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
90     if (a == 0) {
91       return 0;
92     }
93 
94     c = a * b;
95     assert(c / a == b);
96     return c;
97   }
98 
99   /**
100   * @dev Integer division of two numbers, truncating the quotient.
101   */
102   function div(uint256 a, uint256 b) internal pure returns (uint256) {
103     // assert(b > 0); // Solidity automatically throws when dividing by 0
104     // uint256 c = a / b;
105     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
106     return a / b;
107   }
108 
109   /**
110   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
111   */
112   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
113     assert(b <= a);
114     return a - b;
115   }
116 
117   /**
118   * @dev Adds two numbers, throws on overflow.
119   */
120   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
121     c = a + b;
122     assert(c >= a);
123     return c;
124   }
125 }
126 
127 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
128 
129 /**
130  * @title ERC20Basic
131  * @dev Simpler version of ERC20 interface
132  * @dev see https://github.com/ethereum/EIPs/issues/179
133  */
134 contract ERC20Basic {
135   function totalSupply() public view returns (uint256);
136   function balanceOf(address who) public view returns (uint256);
137   function transfer(address to, uint256 value) public returns (bool);
138   event Transfer(address indexed from, address indexed to, uint256 value);
139 }
140 
141 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
142 
143 /**
144  * @title ERC20 interface
145  * @dev see https://github.com/ethereum/EIPs/issues/20
146  */
147 contract ERC20 is ERC20Basic {
148   function allowance(address owner, address spender)
149     public view returns (uint256);
150 
151   function transferFrom(address from, address to, uint256 value)
152     public returns (bool);
153 
154   function approve(address spender, uint256 value) public returns (bool);
155   event Approval(
156     address indexed owner,
157     address indexed spender,
158     uint256 value
159   );
160 }
161 
162 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
163 
164 /**
165  * @title Crowdsale
166  * @dev Crowdsale is a base contract for managing a token crowdsale,
167  * allowing investors to purchase tokens with ether. This contract implements
168  * such functionality in its most fundamental form and can be extended to provide additional
169  * functionality and/or custom behavior.
170  * The external interface represents the basic interface for purchasing tokens, and conform
171  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
172  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
173  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
174  * behavior.
175  */
176 contract Crowdsale {
177   using SafeMath for uint256;
178 
179   // The token being sold
180   ERC20 public token;
181 
182   // Address where funds are collected
183   address public wallet;
184 
185   // How many token units a buyer gets per wei.
186   // The rate is the conversion between wei and the smallest and indivisible token unit.
187   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
188   // 1 wei will give you 1 unit, or 0.001 TOK.
189   uint256 public rate;
190 
191   // Amount of wei raised
192   uint256 public weiRaised;
193 
194   /**
195    * Event for token purchase logging
196    * @param purchaser who paid for the tokens
197    * @param beneficiary who got the tokens
198    * @param value weis paid for purchase
199    * @param amount amount of tokens purchased
200    */
201   event TokenPurchase(
202     address indexed purchaser,
203     address indexed beneficiary,
204     uint256 value,
205     uint256 amount
206   );
207 
208   /**
209    * @param _rate Number of token units a buyer gets per wei
210    * @param _wallet Address where collected funds will be forwarded to
211    * @param _token Address of the token being sold
212    */
213   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
214     require(_rate > 0);
215     require(_wallet != address(0));
216     require(_token != address(0));
217 
218     rate = _rate;
219     wallet = _wallet;
220     token = _token;
221   }
222 
223   // -----------------------------------------
224   // Crowdsale external interface
225   // -----------------------------------------
226 
227   /**
228    * @dev fallback function ***DO NOT OVERRIDE***
229    */
230   function () external payable {
231     buyTokens(msg.sender);
232   }
233 
234   /**
235    * @dev low level token purchase ***DO NOT OVERRIDE***
236    * @param _beneficiary Address performing the token purchase
237    */
238   function buyTokens(address _beneficiary) public payable {
239 
240     uint256 weiAmount = msg.value;
241     _preValidatePurchase(_beneficiary, weiAmount);
242 
243     // calculate token amount to be created
244     uint256 tokens = _getTokenAmount(weiAmount);
245 
246     // update state
247     weiRaised = weiRaised.add(weiAmount);
248 
249     _processPurchase(_beneficiary, tokens);
250     emit TokenPurchase(
251       msg.sender,
252       _beneficiary,
253       weiAmount,
254       tokens
255     );
256 
257     _updatePurchasingState(_beneficiary, weiAmount);
258 
259     _forwardFunds();
260     _postValidatePurchase(_beneficiary, weiAmount);
261   }
262 
263   // -----------------------------------------
264   // Internal interface (extensible)
265   // -----------------------------------------
266 
267   /**
268    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
269    * @param _beneficiary Address performing the token purchase
270    * @param _weiAmount Value in wei involved in the purchase
271    */
272   function _preValidatePurchase(
273     address _beneficiary,
274     uint256 _weiAmount
275   )
276     internal
277   {
278     require(_beneficiary != address(0));
279     require(_weiAmount != 0);
280   }
281 
282   /**
283    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
284    * @param _beneficiary Address performing the token purchase
285    * @param _weiAmount Value in wei involved in the purchase
286    */
287   function _postValidatePurchase(
288     address _beneficiary,
289     uint256 _weiAmount
290   )
291     internal
292   {
293     // optional override
294   }
295 
296   /**
297    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
298    * @param _beneficiary Address performing the token purchase
299    * @param _tokenAmount Number of tokens to be emitted
300    */
301   function _deliverTokens(
302     address _beneficiary,
303     uint256 _tokenAmount
304   )
305     internal
306   {
307     token.transfer(_beneficiary, _tokenAmount);
308   }
309 
310   /**
311    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
312    * @param _beneficiary Address receiving the tokens
313    * @param _tokenAmount Number of tokens to be purchased
314    */
315   function _processPurchase(
316     address _beneficiary,
317     uint256 _tokenAmount
318   )
319     internal
320   {
321     _deliverTokens(_beneficiary, _tokenAmount);
322   }
323 
324   /**
325    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
326    * @param _beneficiary Address receiving the tokens
327    * @param _weiAmount Value in wei involved in the purchase
328    */
329   function _updatePurchasingState(
330     address _beneficiary,
331     uint256 _weiAmount
332   )
333     internal
334   {
335     // optional override
336   }
337 
338   /**
339    * @dev Override to extend the way in which ether is converted to tokens.
340    * @param _weiAmount Value in wei to be converted into tokens
341    * @return Number of tokens that can be purchased with the specified _weiAmount
342    */
343   function _getTokenAmount(uint256 _weiAmount)
344     internal view returns (uint256)
345   {
346     return _weiAmount.mul(rate);
347   }
348 
349   /**
350    * @dev Determines how ETH is stored/forwarded on purchases.
351    */
352   function _forwardFunds() internal {
353     wallet.transfer(msg.value);
354   }
355 }
356 
357 // File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
358 
359 /**
360  * @title TimedCrowdsale
361  * @dev Crowdsale accepting contributions only within a time frame.
362  */
363 contract TimedCrowdsale is Crowdsale {
364   using SafeMath for uint256;
365 
366   uint256 public openingTime;
367   uint256 public closingTime;
368 
369   /**
370    * @dev Reverts if not in crowdsale time range.
371    */
372   modifier onlyWhileOpen {
373     // solium-disable-next-line security/no-block-members
374     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
375     _;
376   }
377 
378   /**
379    * @dev Constructor, takes crowdsale opening and closing times.
380    * @param _openingTime Crowdsale opening time
381    * @param _closingTime Crowdsale closing time
382    */
383   constructor(uint256 _openingTime, uint256 _closingTime) public {
384     // solium-disable-next-line security/no-block-members
385     require(_openingTime >= block.timestamp);
386     require(_closingTime >= _openingTime);
387 
388     openingTime = _openingTime;
389     closingTime = _closingTime;
390   }
391 
392   /**
393    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
394    * @return Whether crowdsale period has elapsed
395    */
396   function hasClosed() public view returns (bool) {
397     // solium-disable-next-line security/no-block-members
398     return block.timestamp > closingTime;
399   }
400 
401   /**
402    * @dev Extend parent behavior requiring to be within contributing period
403    * @param _beneficiary Token purchaser
404    * @param _weiAmount Amount of wei contributed
405    */
406   function _preValidatePurchase(
407     address _beneficiary,
408     uint256 _weiAmount
409   )
410     internal
411     onlyWhileOpen
412   {
413     super._preValidatePurchase(_beneficiary, _weiAmount);
414   }
415 
416 }
417 
418 // File: openzeppelin-solidity/contracts/crowdsale/distribution/PostDeliveryCrowdsale.sol
419 
420 /**
421  * @title PostDeliveryCrowdsale
422  * @dev Crowdsale that locks tokens from withdrawal until it ends.
423  */
424 contract PostDeliveryCrowdsale is TimedCrowdsale {
425   using SafeMath for uint256;
426 
427   mapping(address => uint256) public balances;
428 
429   /**
430    * @dev Withdraw tokens only after crowdsale ends.
431    */
432   function withdrawTokens() public {
433     require(hasClosed());
434     uint256 amount = balances[msg.sender];
435     require(amount > 0);
436     balances[msg.sender] = 0;
437     _deliverTokens(msg.sender, amount);
438   }
439 
440   /**
441    * @dev Overrides parent by storing balances instead of issuing tokens right away.
442    * @param _beneficiary Token purchaser
443    * @param _tokenAmount Amount of tokens purchased
444    */
445   function _processPurchase(
446     address _beneficiary,
447     uint256 _tokenAmount
448   )
449     internal
450   {
451     balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);
452   }
453 
454 }
455 
456 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
457 
458 /**
459  * @title Ownable
460  * @dev The Ownable contract has an owner address, and provides basic authorization control
461  * functions, this simplifies the implementation of "user permissions".
462  */
463 contract Ownable {
464   address public owner;
465 
466 
467   event OwnershipRenounced(address indexed previousOwner);
468   event OwnershipTransferred(
469     address indexed previousOwner,
470     address indexed newOwner
471   );
472 
473 
474   /**
475    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
476    * account.
477    */
478   constructor() public {
479     owner = msg.sender;
480   }
481 
482   /**
483    * @dev Throws if called by any account other than the owner.
484    */
485   modifier onlyOwner() {
486     require(msg.sender == owner);
487     _;
488   }
489 
490   /**
491    * @dev Allows the current owner to relinquish control of the contract.
492    */
493   function renounceOwnership() public onlyOwner {
494     emit OwnershipRenounced(owner);
495     owner = address(0);
496   }
497 
498   /**
499    * @dev Allows the current owner to transfer control of the contract to a newOwner.
500    * @param _newOwner The address to transfer ownership to.
501    */
502   function transferOwnership(address _newOwner) public onlyOwner {
503     _transferOwnership(_newOwner);
504   }
505 
506   /**
507    * @dev Transfers control of the contract to a newOwner.
508    * @param _newOwner The address to transfer ownership to.
509    */
510   function _transferOwnership(address _newOwner) internal {
511     require(_newOwner != address(0));
512     emit OwnershipTransferred(owner, _newOwner);
513     owner = _newOwner;
514   }
515 }
516 
517 // File: openzeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol
518 
519 /**
520  * @title FinalizableCrowdsale
521  * @dev Extension of Crowdsale where an owner can do extra work
522  * after finishing.
523  */
524 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
525   using SafeMath for uint256;
526 
527   bool public isFinalized = false;
528 
529   event Finalized();
530 
531   /**
532    * @dev Must be called after crowdsale ends, to do some extra finalization
533    * work. Calls the contract's finalization function.
534    */
535   function finalize() onlyOwner public {
536     require(!isFinalized);
537     require(hasClosed());
538 
539     finalization();
540     emit Finalized();
541 
542     isFinalized = true;
543   }
544 
545   /**
546    * @dev Can be overridden to add finalization logic. The overriding function
547    * should call super.finalization() to ensure the chain of finalization is
548    * executed entirely.
549    */
550   function finalization() internal {
551   }
552 
553 }
554 
555 // File: openzeppelin-solidity/contracts/crowdsale/distribution/utils/RefundVault.sol
556 
557 /**
558  * @title RefundVault
559  * @dev This contract is used for storing funds while a crowdsale
560  * is in progress. Supports refunding the money if crowdsale fails,
561  * and forwarding it if crowdsale is successful.
562  */
563 contract RefundVault is Ownable {
564   using SafeMath for uint256;
565 
566   enum State { Active, Refunding, Closed }
567 
568   mapping (address => uint256) public deposited;
569   address public wallet;
570   State public state;
571 
572   event Closed();
573   event RefundsEnabled();
574   event Refunded(address indexed beneficiary, uint256 weiAmount);
575 
576   /**
577    * @param _wallet Vault address
578    */
579   constructor(address _wallet) public {
580     require(_wallet != address(0));
581     wallet = _wallet;
582     state = State.Active;
583   }
584 
585   /**
586    * @param investor Investor address
587    */
588   function deposit(address investor) onlyOwner public payable {
589     require(state == State.Active);
590     deposited[investor] = deposited[investor].add(msg.value);
591   }
592 
593   function close() onlyOwner public {
594     require(state == State.Active);
595     state = State.Closed;
596     emit Closed();
597     wallet.transfer(address(this).balance);
598   }
599 
600   function enableRefunds() onlyOwner public {
601     require(state == State.Active);
602     state = State.Refunding;
603     emit RefundsEnabled();
604   }
605 
606   /**
607    * @param investor Investor address
608    */
609   function refund(address investor) public {
610     require(state == State.Refunding);
611     uint256 depositedValue = deposited[investor];
612     deposited[investor] = 0;
613     investor.transfer(depositedValue);
614     emit Refunded(investor, depositedValue);
615   }
616 }
617 
618 // File: openzeppelin-solidity/contracts/crowdsale/distribution/RefundableCrowdsale.sol
619 
620 /**
621  * @title RefundableCrowdsale
622  * @dev Extension of Crowdsale contract that adds a funding goal, and
623  * the possibility of users getting a refund if goal is not met.
624  * Uses a RefundVault as the crowdsale's vault.
625  */
626 contract RefundableCrowdsale is FinalizableCrowdsale {
627   using SafeMath for uint256;
628 
629   // minimum amount of funds to be raised in weis
630   uint256 public goal;
631 
632   // refund vault used to hold funds while crowdsale is running
633   RefundVault public vault;
634 
635   /**
636    * @dev Constructor, creates RefundVault.
637    * @param _goal Funding goal
638    */
639   constructor(uint256 _goal) public {
640     require(_goal > 0);
641     vault = new RefundVault(wallet);
642     goal = _goal;
643   }
644 
645   /**
646    * @dev Investors can claim refunds here if crowdsale is unsuccessful
647    */
648   function claimRefund() public {
649     require(isFinalized);
650     require(!goalReached());
651 
652     vault.refund(msg.sender);
653   }
654 
655   /**
656    * @dev Checks whether funding goal was reached.
657    * @return Whether funding goal was reached
658    */
659   function goalReached() public view returns (bool) {
660     return weiRaised >= goal;
661   }
662 
663   /**
664    * @dev vault finalization task, called when owner calls finalize()
665    */
666   function finalization() internal {
667     if (goalReached()) {
668       vault.close();
669     } else {
670       vault.enableRefunds();
671     }
672 
673     super.finalization();
674   }
675 
676   /**
677    * @dev Overrides Crowdsale fund forwarding, sending funds to vault.
678    */
679   function _forwardFunds() internal {
680     vault.deposit.value(msg.value)(msg.sender);
681   }
682 
683 }
684 
685 // File: openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
686 
687 /**
688  * @title CappedCrowdsale
689  * @dev Crowdsale with a limit for total contributions.
690  */
691 contract CappedCrowdsale is Crowdsale {
692   using SafeMath for uint256;
693 
694   uint256 public cap;
695 
696   /**
697    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
698    * @param _cap Max amount of wei to be contributed
699    */
700   constructor(uint256 _cap) public {
701     require(_cap > 0);
702     cap = _cap;
703   }
704 
705   /**
706    * @dev Checks whether the cap has been reached.
707    * @return Whether the cap was reached
708    */
709   function capReached() public view returns (bool) {
710     return weiRaised >= cap;
711   }
712 
713   /**
714    * @dev Extend parent behavior requiring purchase to respect the funding cap.
715    * @param _beneficiary Token purchaser
716    * @param _weiAmount Amount of wei contributed
717    */
718   function _preValidatePurchase(
719     address _beneficiary,
720     uint256 _weiAmount
721   )
722     internal
723   {
724     super._preValidatePurchase(_beneficiary, _weiAmount);
725     require(weiRaised.add(_weiAmount) <= cap);
726   }
727 
728 }
729 
730 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
731 
732 /**
733  * @title Pausable
734  * @dev Base contract which allows children to implement an emergency stop mechanism.
735  */
736 contract Pausable is Ownable {
737   event Pause();
738   event Unpause();
739 
740   bool public paused = false;
741 
742 
743   /**
744    * @dev Modifier to make a function callable only when the contract is not paused.
745    */
746   modifier whenNotPaused() {
747     require(!paused);
748     _;
749   }
750 
751   /**
752    * @dev Modifier to make a function callable only when the contract is paused.
753    */
754   modifier whenPaused() {
755     require(paused);
756     _;
757   }
758 
759   /**
760    * @dev called by the owner to pause, triggers stopped state
761    */
762   function pause() onlyOwner whenNotPaused public {
763     paused = true;
764     emit Pause();
765   }
766 
767   /**
768    * @dev called by the owner to unpause, returns to normal state
769    */
770   function unpause() onlyOwner whenPaused public {
771     paused = false;
772     emit Unpause();
773   }
774 }
775 
776 // File: contracts/grapevine/crowdsale/GrapevineCrowdsale.sol
777 
778 /**
779  * @title Grapevine Crowdsale, combining capped, timed, PostDelivery and refundable crowdsales
780  * while being pausable.
781  * @dev Grapevine Crowdsale
782  **/
783 contract GrapevineCrowdsale is CappedCrowdsale, TimedCrowdsale, Pausable, RefundableCrowdsale, PostDeliveryCrowdsale {
784   using SafeMath for uint256;
785 
786   TokenTimelockControllerInterface public timelockController;
787   GrapevineWhitelistInterface  public authorisedInvestors;
788   GrapevineWhitelistInterface public earlyInvestors;
789 
790   mapping(address => uint256) public bonuses;
791 
792   uint256 deliveryTime;
793   uint256 tokensToBeDelivered;
794 
795   /**
796     * @param _timelockController address of the controller managing the bonus token lock
797     * @param _rate Number of token units a buyer gets per wei
798     * @param _wallet Address where collected funds will be forwarded to
799     * @param _token Address of the token being sold
800     * @param _openingTime Crowdsale opening time
801     * @param _closingTime Crowdsale closing time
802     * @param _softCap Funding goal
803     * @param _hardCap Max amount of wei to be contributed
804     */
805   constructor(
806     TokenTimelockControllerInterface _timelockController,
807     GrapevineWhitelistInterface _authorisedInvestors,
808     GrapevineWhitelistInterface _earlyInvestors,
809     uint256 _rate, 
810     address _wallet,
811     ERC20 _token, 
812     uint256 _openingTime, 
813     uint256 _closingTime, 
814     uint256 _softCap, 
815     uint256 _hardCap)
816     Crowdsale(_rate, _wallet, _token)
817     CappedCrowdsale(_hardCap)
818     TimedCrowdsale(_openingTime, _closingTime) 
819     RefundableCrowdsale(_softCap)
820     public 
821     {
822     timelockController = _timelockController;
823     authorisedInvestors = _authorisedInvestors;
824     earlyInvestors = _earlyInvestors;
825     // token delivery starts 5 days after the crowdsale ends.
826     //deliveryTime = _closingTime.add(60*60*24*5);
827     deliveryTime = _closingTime.add(60*5);
828   }
829 
830   /**
831    * @dev low level token purchase
832    * @param _beneficiary Address performing the token purchase
833    */
834   function buyTokens(address _beneficiary, bytes _whitelistSign) public payable {
835     // since the earlyInvestors are by definition autorised, we check first the earlyInvestors.
836     if (!earlyInvestors.handleOffchainWhitelisted(_beneficiary, _whitelistSign)) {
837       authorisedInvestors.handleOffchainWhitelisted(_beneficiary, _whitelistSign);
838     }
839     super.buyTokens(_beneficiary);
840   }
841 
842   /**
843    * @dev Withdraw tokens only after the deliveryTime.
844    */
845   function withdrawTokens() public {
846     require(goalReached());
847     // solium-disable-next-line security/no-block-members
848     require(block.timestamp > deliveryTime);
849     super.withdrawTokens();
850     uint256 _bonusTokens = bonuses[msg.sender];
851     if (_bonusTokens > 0) {
852       bonuses[msg.sender] = 0;
853       require(token.approve(address(timelockController), _bonusTokens));
854       require(
855         timelockController.createInvestorTokenTimeLock(
856           msg.sender,
857           _bonusTokens,
858           deliveryTime,
859           this
860         )
861       );
862     }
863   }
864 
865   /**
866    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
867    * It computes the bonus and store it using the timelockController.
868    * @param _beneficiary Address receiving the tokens
869    * @param _tokenAmount Number of tokens to be purchased
870    */
871   function _processPurchase( address _beneficiary, uint256 _tokenAmount ) internal {
872     uint256 _totalTokens = _tokenAmount;
873     // solium-disable-next-line security/no-block-members
874     uint256 _bonus = getBonus(block.timestamp, _beneficiary, msg.value);
875     if (_bonus>0) {
876       uint256 _bonusTokens = _tokenAmount.mul(_bonus).div(100);
877       // make sure the crowdsale contract has enough tokens to transfer the purchased tokens and to create the timelock bonus.
878       uint256 _currentBalance = token.balanceOf(this);
879       require(_currentBalance >= _totalTokens.add(_bonusTokens));
880       bonuses[_beneficiary] = bonuses[_beneficiary].add(_bonusTokens);
881       _totalTokens = _totalTokens.add(_bonusTokens);
882     }
883     tokensToBeDelivered = tokensToBeDelivered.add(_totalTokens);
884     super._processPurchase(_beneficiary, _tokenAmount);
885   }
886 
887   /**
888    * @dev Validation of an incoming purchase. Allowas purchases only when crowdsale is not paused and the _beneficiary is authorized to buy.
889    * The early investors went through the KYC process, so they are authorised by default.
890    * @param _beneficiary Address performing the token purchase
891    * @param _weiAmount Value in wei involved in the purchase
892    */
893   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal whenNotPaused {
894     require(authorisedInvestors.whitelist(_beneficiary) || earlyInvestors.whitelist(_beneficiary));
895     super._preValidatePurchase(_beneficiary, _weiAmount);
896   }
897 
898   /**
899    * @dev Computes the bonus. The bonus is
900    * - 0 by default
901    * - 30% before reaching the softCap for those whitelisted.
902    * - 15% the first week
903    * - 10% the second week
904    * - 8% the third week
905    * - 6% the remaining time.
906    * @param _time when the purchased happened.
907    * @param _beneficiary Address performing the token purchase.
908    * @param _value Value in wei involved in the purchase.
909    */
910   function getBonus(uint256 _time, address _beneficiary, uint256 _value) view internal returns (uint256 _bonus) {
911     //default bonus is 0.
912     _bonus = 0;
913     
914     // at this level the amount was added to weiRaised
915     if ( (weiRaised.sub(_value) < goal) && earlyInvestors.whitelist(_beneficiary) ) {
916       _bonus = 30;
917     } else {
918       if (_time < openingTime.add(7 days)) {
919         _bonus = 15;
920       } else if (_time < openingTime.add(14 days)) {
921         _bonus = 10;
922       } else if (_time < openingTime.add(21 days)) {
923         _bonus = 8;
924       } else {
925         _bonus = 6;
926       }
927     }
928     return _bonus;
929   }
930 
931   /**
932    * @dev Performs the finalization tasks:
933    * - if goal reached, activate the controller and burn the remaining tokens
934    * - transfer the ownership of the token contract back to the owner.
935    */
936   function finalization() internal {
937     // only when the goal is reached we burn the tokens and activate the controller.
938     if (goalReached()) {
939       // activate the controller to enable the investors and team members 
940       // to claim their tokens when the time comes.
941       timelockController.activate();
942 
943       // calculate the quantity of tokens to be burnt. The bonuses are already transfered to the Controller.
944       uint256 balance = token.balanceOf(this);
945       uint256 remainingTokens = balance.sub(tokensToBeDelivered);
946       if (remainingTokens>0) {
947         BurnableTokenInterface(address(token)).burn(remainingTokens);
948       }
949     }
950     Ownable(address(token)).transferOwnership(owner);
951     super.finalization();
952   }
953 }