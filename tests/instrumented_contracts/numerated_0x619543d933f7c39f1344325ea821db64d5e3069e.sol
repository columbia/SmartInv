1 pragma solidity 0.4.24;
2 
3 // File: node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
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
14   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (_a == 0) {
19       return 0;
20     }
21 
22     c = _a * _b;
23     assert(c / _a == _b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     // assert(_b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34     return _a / _b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     assert(_b <= _a);
42     return _a - _b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
49     c = _a + _b;
50     assert(c >= _a);
51     return c;
52   }
53 }
54 
55 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
56 
57 /**
58  * @title ERC20Basic
59  * @dev Simpler version of ERC20 interface
60  * See https://github.com/ethereum/EIPs/issues/179
61  */
62 contract ERC20Basic {
63   function totalSupply() public view returns (uint256);
64   function balanceOf(address _who) public view returns (uint256);
65   function transfer(address _to, uint256 _value) public returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
70 
71 /**
72  * @title ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/20
74  */
75 contract ERC20 is ERC20Basic {
76   function allowance(address _owner, address _spender)
77     public view returns (uint256);
78 
79   function transferFrom(address _from, address _to, uint256 _value)
80     public returns (bool);
81 
82   function approve(address _spender, uint256 _value) public returns (bool);
83   event Approval(
84     address indexed owner,
85     address indexed spender,
86     uint256 value
87   );
88 }
89 
90 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
91 
92 /**
93  * @title SafeERC20
94  * @dev Wrappers around ERC20 operations that throw on failure.
95  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
96  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
97  */
98 library SafeERC20 {
99   function safeTransfer(
100     ERC20Basic _token,
101     address _to,
102     uint256 _value
103   )
104     internal
105   {
106     require(_token.transfer(_to, _value));
107   }
108 
109   function safeTransferFrom(
110     ERC20 _token,
111     address _from,
112     address _to,
113     uint256 _value
114   )
115     internal
116   {
117     require(_token.transferFrom(_from, _to, _value));
118   }
119 
120   function safeApprove(
121     ERC20 _token,
122     address _spender,
123     uint256 _value
124   )
125     internal
126   {
127     require(_token.approve(_spender, _value));
128   }
129 }
130 
131 // File: node_modules/openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
132 
133 /**
134  * @title Crowdsale
135  * @dev Crowdsale is a base contract for managing a token crowdsale,
136  * allowing investors to purchase tokens with ether. This contract implements
137  * such functionality in its most fundamental form and can be extended to provide additional
138  * functionality and/or custom behavior.
139  * The external interface represents the basic interface for purchasing tokens, and conform
140  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
141  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
142  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
143  * behavior.
144  */
145 contract Crowdsale {
146   using SafeMath for uint256;
147   using SafeERC20 for ERC20;
148 
149   // The token being sold
150   ERC20 public token;
151 
152   // Address where funds are collected
153   address public wallet;
154 
155   // How many token units a buyer gets per wei.
156   // The rate is the conversion between wei and the smallest and indivisible token unit.
157   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
158   // 1 wei will give you 1 unit, or 0.001 TOK.
159   uint256 public rate;
160 
161   // Amount of wei raised
162   uint256 public weiRaised;
163 
164   /**
165    * Event for token purchase logging
166    * @param purchaser who paid for the tokens
167    * @param beneficiary who got the tokens
168    * @param value weis paid for purchase
169    * @param amount amount of tokens purchased
170    */
171   event TokenPurchase(
172     address indexed purchaser,
173     address indexed beneficiary,
174     uint256 value,
175     uint256 amount
176   );
177 
178   /**
179    * @param _rate Number of token units a buyer gets per wei
180    * @param _wallet Address where collected funds will be forwarded to
181    * @param _token Address of the token being sold
182    */
183   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
184     require(_rate > 0);
185     require(_wallet != address(0));
186     require(_token != address(0));
187 
188     rate = _rate;
189     wallet = _wallet;
190     token = _token;
191   }
192 
193   // -----------------------------------------
194   // Crowdsale external interface
195   // -----------------------------------------
196 
197   /**
198    * @dev fallback function ***DO NOT OVERRIDE***
199    */
200   function () external payable {
201     buyTokens(msg.sender);
202   }
203 
204   /**
205    * @dev low level token purchase ***DO NOT OVERRIDE***
206    * @param _beneficiary Address performing the token purchase
207    */
208   function buyTokens(address _beneficiary) public payable {
209 
210     uint256 weiAmount = msg.value;
211     _preValidatePurchase(_beneficiary, weiAmount);
212 
213     // calculate token amount to be created
214     uint256 tokens = _getTokenAmount(weiAmount);
215 
216     // update state
217     weiRaised = weiRaised.add(weiAmount);
218 
219     _processPurchase(_beneficiary, tokens);
220     emit TokenPurchase(
221       msg.sender,
222       _beneficiary,
223       weiAmount,
224       tokens
225     );
226 
227     _updatePurchasingState(_beneficiary, weiAmount);
228 
229     _forwardFunds();
230     _postValidatePurchase(_beneficiary, weiAmount);
231   }
232 
233   // -----------------------------------------
234   // Internal interface (extensible)
235   // -----------------------------------------
236 
237   /**
238    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
239    * Example from CappedCrowdsale.sol's _preValidatePurchase method: 
240    *   super._preValidatePurchase(_beneficiary, _weiAmount);
241    *   require(weiRaised.add(_weiAmount) <= cap);
242    * @param _beneficiary Address performing the token purchase
243    * @param _weiAmount Value in wei involved in the purchase
244    */
245   function _preValidatePurchase(
246     address _beneficiary,
247     uint256 _weiAmount
248   )
249     internal
250   {
251     require(_beneficiary != address(0));
252     require(_weiAmount != 0);
253   }
254 
255   /**
256    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
257    * @param _beneficiary Address performing the token purchase
258    * @param _weiAmount Value in wei involved in the purchase
259    */
260   function _postValidatePurchase(
261     address _beneficiary,
262     uint256 _weiAmount
263   )
264     internal
265   {
266     // optional override
267   }
268 
269   /**
270    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
271    * @param _beneficiary Address performing the token purchase
272    * @param _tokenAmount Number of tokens to be emitted
273    */
274   function _deliverTokens(
275     address _beneficiary,
276     uint256 _tokenAmount
277   )
278     internal
279   {
280     token.safeTransfer(_beneficiary, _tokenAmount);
281   }
282 
283   /**
284    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
285    * @param _beneficiary Address receiving the tokens
286    * @param _tokenAmount Number of tokens to be purchased
287    */
288   function _processPurchase(
289     address _beneficiary,
290     uint256 _tokenAmount
291   )
292     internal
293   {
294     _deliverTokens(_beneficiary, _tokenAmount);
295   }
296 
297   /**
298    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
299    * @param _beneficiary Address receiving the tokens
300    * @param _weiAmount Value in wei involved in the purchase
301    */
302   function _updatePurchasingState(
303     address _beneficiary,
304     uint256 _weiAmount
305   )
306     internal
307   {
308     // optional override
309   }
310 
311   /**
312    * @dev Override to extend the way in which ether is converted to tokens.
313    * @param _weiAmount Value in wei to be converted into tokens
314    * @return Number of tokens that can be purchased with the specified _weiAmount
315    */
316   function _getTokenAmount(uint256 _weiAmount)
317     internal view returns (uint256)
318   {
319     return _weiAmount.mul(rate);
320   }
321 
322   /**
323    * @dev Determines how ETH is stored/forwarded on purchases.
324    */
325   function _forwardFunds() internal {
326     wallet.transfer(msg.value);
327   }
328 }
329 
330 // File: node_modules/openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
331 
332 /**
333  * @title CappedCrowdsale
334  * @dev Crowdsale with a limit for total contributions.
335  */
336 contract CappedCrowdsale is Crowdsale {
337   using SafeMath for uint256;
338 
339   uint256 public cap;
340 
341   /**
342    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
343    * @param _cap Max amount of wei to be contributed
344    */
345   constructor(uint256 _cap) public {
346     require(_cap > 0);
347     cap = _cap;
348   }
349 
350   /**
351    * @dev Checks whether the cap has been reached.
352    * @return Whether the cap was reached
353    */
354   function capReached() public view returns (bool) {
355     return weiRaised >= cap;
356   }
357 
358   /**
359    * @dev Extend parent behavior requiring purchase to respect the funding cap.
360    * @param _beneficiary Token purchaser
361    * @param _weiAmount Amount of wei contributed
362    */
363   function _preValidatePurchase(
364     address _beneficiary,
365     uint256 _weiAmount
366   )
367     internal
368   {
369     super._preValidatePurchase(_beneficiary, _weiAmount);
370     require(weiRaised.add(_weiAmount) <= cap);
371   }
372 
373 }
374 
375 // File: node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol
376 
377 /**
378  * @title Ownable
379  * @dev The Ownable contract has an owner address, and provides basic authorization control
380  * functions, this simplifies the implementation of "user permissions".
381  */
382 contract Ownable {
383   address public owner;
384 
385 
386   event OwnershipRenounced(address indexed previousOwner);
387   event OwnershipTransferred(
388     address indexed previousOwner,
389     address indexed newOwner
390   );
391 
392 
393   /**
394    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
395    * account.
396    */
397   constructor() public {
398     owner = msg.sender;
399   }
400 
401   /**
402    * @dev Throws if called by any account other than the owner.
403    */
404   modifier onlyOwner() {
405     require(msg.sender == owner);
406     _;
407   }
408 
409   /**
410    * @dev Allows the current owner to relinquish control of the contract.
411    * @notice Renouncing to ownership will leave the contract without an owner.
412    * It will not be possible to call the functions with the `onlyOwner`
413    * modifier anymore.
414    */
415   function renounceOwnership() public onlyOwner {
416     emit OwnershipRenounced(owner);
417     owner = address(0);
418   }
419 
420   /**
421    * @dev Allows the current owner to transfer control of the contract to a newOwner.
422    * @param _newOwner The address to transfer ownership to.
423    */
424   function transferOwnership(address _newOwner) public onlyOwner {
425     _transferOwnership(_newOwner);
426   }
427 
428   /**
429    * @dev Transfers control of the contract to a newOwner.
430    * @param _newOwner The address to transfer ownership to.
431    */
432   function _transferOwnership(address _newOwner) internal {
433     require(_newOwner != address(0));
434     emit OwnershipTransferred(owner, _newOwner);
435     owner = _newOwner;
436   }
437 }
438 
439 // File: node_modules/openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
440 
441 /**
442  * @title TimedCrowdsale
443  * @dev Crowdsale accepting contributions only within a time frame.
444  */
445 contract TimedCrowdsale is Crowdsale {
446   using SafeMath for uint256;
447 
448   uint256 public openingTime;
449   uint256 public closingTime;
450 
451   /**
452    * @dev Reverts if not in crowdsale time range.
453    */
454   modifier onlyWhileOpen {
455     // solium-disable-next-line security/no-block-members
456     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
457     _;
458   }
459 
460   /**
461    * @dev Constructor, takes crowdsale opening and closing times.
462    * @param _openingTime Crowdsale opening time
463    * @param _closingTime Crowdsale closing time
464    */
465   constructor(uint256 _openingTime, uint256 _closingTime) public {
466     // solium-disable-next-line security/no-block-members
467     require(_openingTime >= block.timestamp);
468     require(_closingTime >= _openingTime);
469 
470     openingTime = _openingTime;
471     closingTime = _closingTime;
472   }
473 
474   /**
475    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
476    * @return Whether crowdsale period has elapsed
477    */
478   function hasClosed() public view returns (bool) {
479     // solium-disable-next-line security/no-block-members
480     return block.timestamp > closingTime;
481   }
482 
483   /**
484    * @dev Extend parent behavior requiring to be within contributing period
485    * @param _beneficiary Token purchaser
486    * @param _weiAmount Amount of wei contributed
487    */
488   function _preValidatePurchase(
489     address _beneficiary,
490     uint256 _weiAmount
491   )
492     internal
493     onlyWhileOpen
494   {
495     super._preValidatePurchase(_beneficiary, _weiAmount);
496   }
497 
498 }
499 
500 // File: node_modules/openzeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol
501 
502 /**
503  * @title FinalizableCrowdsale
504  * @dev Extension of Crowdsale where an owner can do extra work
505  * after finishing.
506  */
507 contract FinalizableCrowdsale is Ownable, TimedCrowdsale {
508   using SafeMath for uint256;
509 
510   bool public isFinalized = false;
511 
512   event Finalized();
513 
514   /**
515    * @dev Must be called after crowdsale ends, to do some extra finalization
516    * work. Calls the contract's finalization function.
517    */
518   function finalize() public onlyOwner {
519     require(!isFinalized);
520     require(hasClosed());
521 
522     finalization();
523     emit Finalized();
524 
525     isFinalized = true;
526   }
527 
528   /**
529    * @dev Can be overridden to add finalization logic. The overriding function
530    * should call super.finalization() to ensure the chain of finalization is
531    * executed entirely.
532    */
533   function finalization() internal {
534   }
535 
536 }
537 
538 // File: node_modules/openzeppelin-solidity/contracts/payment/Escrow.sol
539 
540 /**
541  * @title Escrow
542  * @dev Base escrow contract, holds funds destinated to a payee until they
543  * withdraw them. The contract that uses the escrow as its payment method
544  * should be its owner, and provide public methods redirecting to the escrow's
545  * deposit and withdraw.
546  */
547 contract Escrow is Ownable {
548   using SafeMath for uint256;
549 
550   event Deposited(address indexed payee, uint256 weiAmount);
551   event Withdrawn(address indexed payee, uint256 weiAmount);
552 
553   mapping(address => uint256) private deposits;
554 
555   function depositsOf(address _payee) public view returns (uint256) {
556     return deposits[_payee];
557   }
558 
559   /**
560   * @dev Stores the sent amount as credit to be withdrawn.
561   * @param _payee The destination address of the funds.
562   */
563   function deposit(address _payee) public onlyOwner payable {
564     uint256 amount = msg.value;
565     deposits[_payee] = deposits[_payee].add(amount);
566 
567     emit Deposited(_payee, amount);
568   }
569 
570   /**
571   * @dev Withdraw accumulated balance for a payee.
572   * @param _payee The address whose funds will be withdrawn and transferred to.
573   */
574   function withdraw(address _payee) public onlyOwner {
575     uint256 payment = deposits[_payee];
576     assert(address(this).balance >= payment);
577 
578     deposits[_payee] = 0;
579 
580     _payee.transfer(payment);
581 
582     emit Withdrawn(_payee, payment);
583   }
584 }
585 
586 // File: node_modules/openzeppelin-solidity/contracts/payment/ConditionalEscrow.sol
587 
588 /**
589  * @title ConditionalEscrow
590  * @dev Base abstract escrow to only allow withdrawal if a condition is met.
591  */
592 contract ConditionalEscrow is Escrow {
593   /**
594   * @dev Returns whether an address is allowed to withdraw their funds. To be
595   * implemented by derived contracts.
596   * @param _payee The destination address of the funds.
597   */
598   function withdrawalAllowed(address _payee) public view returns (bool);
599 
600   function withdraw(address _payee) public {
601     require(withdrawalAllowed(_payee));
602     super.withdraw(_payee);
603   }
604 }
605 
606 // File: node_modules/openzeppelin-solidity/contracts/payment/RefundEscrow.sol
607 
608 /**
609  * @title RefundEscrow
610  * @dev Escrow that holds funds for a beneficiary, deposited from multiple parties.
611  * The contract owner may close the deposit period, and allow for either withdrawal
612  * by the beneficiary, or refunds to the depositors.
613  */
614 contract RefundEscrow is Ownable, ConditionalEscrow {
615   enum State { Active, Refunding, Closed }
616 
617   event Closed();
618   event RefundsEnabled();
619 
620   State public state;
621   address public beneficiary;
622 
623   /**
624    * @dev Constructor.
625    * @param _beneficiary The beneficiary of the deposits.
626    */
627   constructor(address _beneficiary) public {
628     require(_beneficiary != address(0));
629     beneficiary = _beneficiary;
630     state = State.Active;
631   }
632 
633   /**
634    * @dev Stores funds that may later be refunded.
635    * @param _refundee The address funds will be sent to if a refund occurs.
636    */
637   function deposit(address _refundee) public payable {
638     require(state == State.Active);
639     super.deposit(_refundee);
640   }
641 
642   /**
643    * @dev Allows for the beneficiary to withdraw their funds, rejecting
644    * further deposits.
645    */
646   function close() public onlyOwner {
647     require(state == State.Active);
648     state = State.Closed;
649     emit Closed();
650   }
651 
652   /**
653    * @dev Allows for refunds to take place, rejecting further deposits.
654    */
655   function enableRefunds() public onlyOwner {
656     require(state == State.Active);
657     state = State.Refunding;
658     emit RefundsEnabled();
659   }
660 
661   /**
662    * @dev Withdraws the beneficiary's funds.
663    */
664   function beneficiaryWithdraw() public {
665     require(state == State.Closed);
666     beneficiary.transfer(address(this).balance);
667   }
668 
669   /**
670    * @dev Returns whether refundees can withdraw their deposits (be refunded).
671    */
672   function withdrawalAllowed(address _payee) public view returns (bool) {
673     return state == State.Refunding;
674   }
675 }
676 
677 // File: node_modules/openzeppelin-solidity/contracts/crowdsale/distribution/RefundableCrowdsale.sol
678 
679 /**
680  * @title RefundableCrowdsale
681  * @dev Extension of Crowdsale contract that adds a funding goal, and
682  * the possibility of users getting a refund if goal is not met.
683  */
684 contract RefundableCrowdsale is FinalizableCrowdsale {
685   using SafeMath for uint256;
686 
687   // minimum amount of funds to be raised in weis
688   uint256 public goal;
689 
690   // refund escrow used to hold funds while crowdsale is running
691   RefundEscrow private escrow;
692 
693   /**
694    * @dev Constructor, creates RefundEscrow.
695    * @param _goal Funding goal
696    */
697   constructor(uint256 _goal) public {
698     require(_goal > 0);
699     escrow = new RefundEscrow(wallet);
700     goal = _goal;
701   }
702 
703   /**
704    * @dev Investors can claim refunds here if crowdsale is unsuccessful
705    */
706   function claimRefund() public {
707     require(isFinalized);
708     require(!goalReached());
709 
710     escrow.withdraw(msg.sender);
711   }
712 
713   /**
714    * @dev Checks whether funding goal was reached.
715    * @return Whether funding goal was reached
716    */
717   function goalReached() public view returns (bool) {
718     return weiRaised >= goal;
719   }
720 
721   /**
722    * @dev escrow finalization task, called when owner calls finalize()
723    */
724   function finalization() internal {
725     if (goalReached()) {
726       escrow.close();
727       escrow.beneficiaryWithdraw();
728     } else {
729       escrow.enableRefunds();
730     }
731 
732     super.finalization();
733   }
734 
735   /**
736    * @dev Overrides Crowdsale fund forwarding, sending funds to escrow.
737    */
738   function _forwardFunds() internal {
739     escrow.deposit.value(msg.value)(msg.sender);
740   }
741 
742 }
743 
744 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
745 
746 /**
747  * @title Basic token
748  * @dev Basic version of StandardToken, with no allowances.
749  */
750 contract BasicToken is ERC20Basic {
751   using SafeMath for uint256;
752 
753   mapping(address => uint256) internal balances;
754 
755   uint256 internal totalSupply_;
756 
757   /**
758   * @dev Total number of tokens in existence
759   */
760   function totalSupply() public view returns (uint256) {
761     return totalSupply_;
762   }
763 
764   /**
765   * @dev Transfer token for a specified address
766   * @param _to The address to transfer to.
767   * @param _value The amount to be transferred.
768   */
769   function transfer(address _to, uint256 _value) public returns (bool) {
770     require(_value <= balances[msg.sender]);
771     require(_to != address(0));
772 
773     balances[msg.sender] = balances[msg.sender].sub(_value);
774     balances[_to] = balances[_to].add(_value);
775     emit Transfer(msg.sender, _to, _value);
776     return true;
777   }
778 
779   /**
780   * @dev Gets the balance of the specified address.
781   * @param _owner The address to query the the balance of.
782   * @return An uint256 representing the amount owned by the passed address.
783   */
784   function balanceOf(address _owner) public view returns (uint256) {
785     return balances[_owner];
786   }
787 
788 }
789 
790 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
791 
792 /**
793  * @title Standard ERC20 token
794  *
795  * @dev Implementation of the basic standard token.
796  * https://github.com/ethereum/EIPs/issues/20
797  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
798  */
799 contract StandardToken is ERC20, BasicToken {
800 
801   mapping (address => mapping (address => uint256)) internal allowed;
802 
803 
804   /**
805    * @dev Transfer tokens from one address to another
806    * @param _from address The address which you want to send tokens from
807    * @param _to address The address which you want to transfer to
808    * @param _value uint256 the amount of tokens to be transferred
809    */
810   function transferFrom(
811     address _from,
812     address _to,
813     uint256 _value
814   )
815     public
816     returns (bool)
817   {
818     require(_value <= balances[_from]);
819     require(_value <= allowed[_from][msg.sender]);
820     require(_to != address(0));
821 
822     balances[_from] = balances[_from].sub(_value);
823     balances[_to] = balances[_to].add(_value);
824     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
825     emit Transfer(_from, _to, _value);
826     return true;
827   }
828 
829   /**
830    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
831    * Beware that changing an allowance with this method brings the risk that someone may use both the old
832    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
833    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
834    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
835    * @param _spender The address which will spend the funds.
836    * @param _value The amount of tokens to be spent.
837    */
838   function approve(address _spender, uint256 _value) public returns (bool) {
839     allowed[msg.sender][_spender] = _value;
840     emit Approval(msg.sender, _spender, _value);
841     return true;
842   }
843 
844   /**
845    * @dev Function to check the amount of tokens that an owner allowed to a spender.
846    * @param _owner address The address which owns the funds.
847    * @param _spender address The address which will spend the funds.
848    * @return A uint256 specifying the amount of tokens still available for the spender.
849    */
850   function allowance(
851     address _owner,
852     address _spender
853    )
854     public
855     view
856     returns (uint256)
857   {
858     return allowed[_owner][_spender];
859   }
860 
861   /**
862    * @dev Increase the amount of tokens that an owner allowed to a spender.
863    * approve should be called when allowed[_spender] == 0. To increment
864    * allowed value is better to use this function to avoid 2 calls (and wait until
865    * the first transaction is mined)
866    * From MonolithDAO Token.sol
867    * @param _spender The address which will spend the funds.
868    * @param _addedValue The amount of tokens to increase the allowance by.
869    */
870   function increaseApproval(
871     address _spender,
872     uint256 _addedValue
873   )
874     public
875     returns (bool)
876   {
877     allowed[msg.sender][_spender] = (
878       allowed[msg.sender][_spender].add(_addedValue));
879     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
880     return true;
881   }
882 
883   /**
884    * @dev Decrease the amount of tokens that an owner allowed to a spender.
885    * approve should be called when allowed[_spender] == 0. To decrement
886    * allowed value is better to use this function to avoid 2 calls (and wait until
887    * the first transaction is mined)
888    * From MonolithDAO Token.sol
889    * @param _spender The address which will spend the funds.
890    * @param _subtractedValue The amount of tokens to decrease the allowance by.
891    */
892   function decreaseApproval(
893     address _spender,
894     uint256 _subtractedValue
895   )
896     public
897     returns (bool)
898   {
899     uint256 oldValue = allowed[msg.sender][_spender];
900     if (_subtractedValue >= oldValue) {
901       allowed[msg.sender][_spender] = 0;
902     } else {
903       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
904     }
905     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
906     return true;
907   }
908 
909 }
910 
911 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
912 
913 /**
914  * @title Mintable token
915  * @dev Simple ERC20 Token example, with mintable token creation
916  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
917  */
918 contract MintableToken is StandardToken, Ownable {
919   event Mint(address indexed to, uint256 amount);
920   event MintFinished();
921 
922   bool public mintingFinished = false;
923 
924 
925   modifier canMint() {
926     require(!mintingFinished);
927     _;
928   }
929 
930   modifier hasMintPermission() {
931     require(msg.sender == owner);
932     _;
933   }
934 
935   /**
936    * @dev Function to mint tokens
937    * @param _to The address that will receive the minted tokens.
938    * @param _amount The amount of tokens to mint.
939    * @return A boolean that indicates if the operation was successful.
940    */
941   function mint(
942     address _to,
943     uint256 _amount
944   )
945     public
946     hasMintPermission
947     canMint
948     returns (bool)
949   {
950     totalSupply_ = totalSupply_.add(_amount);
951     balances[_to] = balances[_to].add(_amount);
952     emit Mint(_to, _amount);
953     emit Transfer(address(0), _to, _amount);
954     return true;
955   }
956 
957   /**
958    * @dev Function to stop minting new tokens.
959    * @return True if the operation was successful.
960    */
961   function finishMinting() public onlyOwner canMint returns (bool) {
962     mintingFinished = true;
963     emit MintFinished();
964     return true;
965   }
966 }
967 
968 // File: node_modules/openzeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol
969 
970 /**
971  * @title MintedCrowdsale
972  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
973  * Token ownership should be transferred to MintedCrowdsale for minting.
974  */
975 contract MintedCrowdsale is Crowdsale {
976 
977   /**
978    * @dev Overrides delivery by minting tokens upon purchase.
979    * @param _beneficiary Token purchaser
980    * @param _tokenAmount Number of tokens to be minted
981    */
982   function _deliverTokens(
983     address _beneficiary,
984     uint256 _tokenAmount
985   )
986     internal
987   {
988     // Potentially dangerous assumption about the type of the token.
989     require(MintableToken(address(token)).mint(_beneficiary, _tokenAmount));
990   }
991 }
992 
993 // File: contracts/EventaToken.sol
994 
995 // ----------------------------------------------------------------------------
996 // 'Eventa' CROWDSALE token contract
997 //
998 // Deployed to : XXXXXXXXXXXXXXXXXXX
999 // Symbol      : EVENTA
1000 // Name        : Eventa Token
1001 // Total supply: 3000000000000000000000000000
1002 // Decimals    : 18
1003 //
1004 // (c) by Andrea Zanda, Eventa SRL, April 2018. The MIT Licence.
1005 // ----------------------------------------------------------------------------
1006 
1007 contract EventaToken is MintableToken {
1008 
1009   string public constant name = "Eventa Token";
1010   string public constant symbol = "EVTA";
1011   uint8 public constant decimals = 18;
1012 
1013 
1014 }
1015 
1016 // File: contracts/EventaCrowdsale.sol
1017 
1018 // ----------------------------------------------------------------------------
1019 // 'Eventa' CROWDSALE token contract
1020 //
1021 // Deployed to : XXXXXXXXXXXXXXXXXXX
1022 // Symbol      : EVENTA
1023 // Name        : Eventa Token
1024 // Total supply: 3000000000000000000000000000
1025 // Decimals    : 18
1026 //
1027 // (c) by Andrea Zanda, Eventa SRL, April 2018. The MIT Licence.
1028 // ----------------------------------------------------------------------------
1029 
1030 
1031 
1032 
1033 // ----------------------------------------------------------------------------
1034 // ERC20 Token, with the addition of symbol, name and decimals and assisted
1035 // token transfers
1036 // ----------------------------------------------------------------------------
1037 
1038 
1039 contract EventaCrowdsale is CappedCrowdsale ,TimedCrowdsale, MintedCrowdsale {
1040 
1041 
1042 
1043   constructor(
1044     uint256 _openingTime,
1045     uint256 _closingTime,
1046     uint256 _rate,
1047     address _wallet,
1048     uint256 _cap,
1049     MintableToken _token
1050   )
1051     
1052     public
1053     Crowdsale(_rate, _wallet, _token)
1054     CappedCrowdsale(_cap)
1055     TimedCrowdsale(_openingTime, _closingTime) {}
1056 
1057 
1058 
1059 
1060 
1061 
1062 }