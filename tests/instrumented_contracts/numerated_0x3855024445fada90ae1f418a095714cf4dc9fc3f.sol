1 pragma solidity ^0.4.25;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (_a == 0) {
18       return 0;
19     }
20 
21     c = _a * _b;
22     assert(c / _a == _b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     // assert(_b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = _a / _b;
32     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33     return _a / _b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
40     assert(_b <= _a);
41     return _a - _b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
48     c = _a + _b;
49     assert(c >= _a);
50     return c;
51   }
52 }
53 
54 
55 
56 /**
57  * @title ERC20Basic
58  * @dev Simpler version of ERC20 interface
59  * See https://github.com/ethereum/EIPs/issues/179
60  */
61 contract ERC20Basic {
62   function totalSupply() public view returns (uint256);
63   function balanceOf(address _who) public view returns (uint256);
64   function transfer(address _to, uint256 _value) public returns (bool);
65   event Transfer(address indexed from, address indexed to, uint256 value);
66 }
67 
68 
69 
70 
71 
72 /**
73  * @title ERC20 interface
74  * @dev see https://github.com/ethereum/EIPs/issues/20
75  */
76 contract ERC20 is ERC20Basic {
77   function allowance(address _owner, address _spender)
78     public view returns (uint256);
79 
80   function transferFrom(address _from, address _to, uint256 _value)
81     public returns (bool);
82 
83   function approve(address _spender, uint256 _value) public returns (bool);
84   event Approval(
85     address indexed owner,
86     address indexed spender,
87     uint256 value
88   );
89 }
90 
91 
92 
93 /**
94  * @title Ownable
95  * @dev The Ownable contract has an owner address, and provides basic authorization control
96  * functions, this simplifies the implementation of "user permissions".
97  */
98 contract Ownable {
99   address public owner;
100 
101 
102   event OwnershipRenounced(address indexed previousOwner);
103   event OwnershipTransferred(
104     address indexed previousOwner,
105     address indexed newOwner
106   );
107 
108 
109   /**
110    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
111    * account.
112    */
113   constructor() public {
114     owner = msg.sender;
115   }
116 
117   /**
118    * @dev Throws if called by any account other than the owner.
119    */
120   modifier onlyOwner() {
121     require(msg.sender == owner);
122     _;
123   }
124 
125   /**
126    * @dev Allows the current owner to relinquish control of the contract.
127    * @notice Renouncing to ownership will leave the contract without an owner.
128    * It will not be possible to call the functions with the `onlyOwner`
129    * modifier anymore.
130    */
131   function renounceOwnership() public onlyOwner {
132     emit OwnershipRenounced(owner);
133     owner = address(0);
134   }
135 
136   /**
137    * @dev Allows the current owner to transfer control of the contract to a newOwner.
138    * @param _newOwner The address to transfer ownership to.
139    */
140   function transferOwnership(address _newOwner) public onlyOwner {
141     _transferOwnership(_newOwner);
142   }
143 
144   /**
145    * @dev Transfers control of the contract to a newOwner.
146    * @param _newOwner The address to transfer ownership to.
147    */
148   function _transferOwnership(address _newOwner) internal {
149     require(_newOwner != address(0));
150     emit OwnershipTransferred(owner, _newOwner);
151     owner = _newOwner;
152   }
153 }
154 
155 
156 
157 
158 
159 
160 /**
161  * @title SafeERC20
162  * @dev Wrappers around ERC20 operations that throw on failure.
163  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
164  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
165  */
166 library SafeERC20 {
167   function safeTransfer(
168     ERC20Basic _token,
169     address _to,
170     uint256 _value
171   )
172     internal
173   {
174     require(_token.transfer(_to, _value));
175   }
176 
177   function safeTransferFrom(
178     ERC20 _token,
179     address _from,
180     address _to,
181     uint256 _value
182   )
183     internal
184   {
185     require(_token.transferFrom(_from, _to, _value));
186   }
187 
188   function safeApprove(
189     ERC20 _token,
190     address _spender,
191     uint256 _value
192   )
193     internal
194   {
195     require(_token.approve(_spender, _value));
196   }
197 }
198 
199 
200 
201 
202 
203 
204 
205 
206 
207 
208 
209 
210 
211 
212 
213 
214 
215 
216 
217 
218 /**
219  * @title Crowdsale
220  * @dev Crowdsale is a base contract for managing a token crowdsale,
221  * allowing investors to purchase tokens with ether. This contract implements
222  * such functionality in its most fundamental form and can be extended to provide additional
223  * functionality and/or custom behavior.
224  * The external interface represents the basic interface for purchasing tokens, and conform
225  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
226  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
227  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
228  * behavior.
229  */
230 contract Crowdsale {
231   using SafeMath for uint256;
232   using SafeERC20 for ERC20;
233 
234   // The token being sold
235   ERC20 public token;
236 
237   // Address where funds are collected
238   address public wallet;
239 
240   // How many token units a buyer gets per wei.
241   // The rate is the conversion between wei and the smallest and indivisible token unit.
242   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
243   // 1 wei will give you 1 unit, or 0.001 TOK.
244   uint256 public rate;
245 
246   // Amount of wei raised
247   uint256 public weiRaised;
248 
249   /**
250    * Event for token purchase logging
251    * @param purchaser who paid for the tokens
252    * @param beneficiary who got the tokens
253    * @param value weis paid for purchase
254    * @param amount amount of tokens purchased
255    */
256   event TokenPurchase(
257     address indexed purchaser,
258     address indexed beneficiary,
259     uint256 value,
260     uint256 amount
261   );
262 
263   /**
264    * @param _rate Number of token units a buyer gets per wei
265    * @param _wallet Address where collected funds will be forwarded to
266    * @param _token Address of the token being sold
267    */
268   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
269     require(_rate > 0);
270     require(_wallet != address(0));
271     require(_token != address(0));
272 
273     rate = _rate;
274     wallet = _wallet;
275     token = _token;
276   }
277 
278   // -----------------------------------------
279   // Crowdsale external interface
280   // -----------------------------------------
281 
282   /**
283    * @dev fallback function ***DO NOT OVERRIDE***
284    */
285   function () external payable {
286     buyTokens(msg.sender);
287   }
288 
289   /**
290    * @dev low level token purchase ***DO NOT OVERRIDE***
291    * @param _beneficiary Address performing the token purchase
292    */
293   function buyTokens(address _beneficiary) public payable {
294 
295     uint256 weiAmount = msg.value;
296     _preValidatePurchase(_beneficiary, weiAmount);
297 
298     // calculate token amount to be created
299     uint256 tokens = _getTokenAmount(weiAmount);
300 
301     // update state
302     weiRaised = weiRaised.add(weiAmount);
303 
304     _processPurchase(_beneficiary, tokens);
305     emit TokenPurchase(
306       msg.sender,
307       _beneficiary,
308       weiAmount,
309       tokens
310     );
311 
312     _updatePurchasingState(_beneficiary, weiAmount);
313 
314     _forwardFunds();
315     _postValidatePurchase(_beneficiary, weiAmount);
316   }
317 
318   // -----------------------------------------
319   // Internal interface (extensible)
320   // -----------------------------------------
321 
322   /**
323    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
324    * Example from CappedCrowdsale.sol's _preValidatePurchase method: 
325    *   super._preValidatePurchase(_beneficiary, _weiAmount);
326    *   require(weiRaised.add(_weiAmount) <= cap);
327    * @param _beneficiary Address performing the token purchase
328    * @param _weiAmount Value in wei involved in the purchase
329    */
330   function _preValidatePurchase(
331     address _beneficiary,
332     uint256 _weiAmount
333   )
334     internal
335   {
336     require(_beneficiary != address(0));
337     require(_weiAmount != 0);
338   }
339 
340   /**
341    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
342    * @param _beneficiary Address performing the token purchase
343    * @param _weiAmount Value in wei involved in the purchase
344    */
345   function _postValidatePurchase(
346     address _beneficiary,
347     uint256 _weiAmount
348   )
349     internal
350   {
351     // optional override
352   }
353 
354   /**
355    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
356    * @param _beneficiary Address performing the token purchase
357    * @param _tokenAmount Number of tokens to be emitted
358    */
359   function _deliverTokens(
360     address _beneficiary,
361     uint256 _tokenAmount
362   )
363     internal
364   {
365     token.safeTransfer(_beneficiary, _tokenAmount);
366   }
367 
368   /**
369    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
370    * @param _beneficiary Address receiving the tokens
371    * @param _tokenAmount Number of tokens to be purchased
372    */
373   function _processPurchase(
374     address _beneficiary,
375     uint256 _tokenAmount
376   )
377     internal
378   {
379     _deliverTokens(_beneficiary, _tokenAmount);
380   }
381 
382   /**
383    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
384    * @param _beneficiary Address receiving the tokens
385    * @param _weiAmount Value in wei involved in the purchase
386    */
387   function _updatePurchasingState(
388     address _beneficiary,
389     uint256 _weiAmount
390   )
391     internal
392   {
393     // optional override
394   }
395 
396   /**
397    * @dev Override to extend the way in which ether is converted to tokens.
398    * @param _weiAmount Value in wei to be converted into tokens
399    * @return Number of tokens that can be purchased with the specified _weiAmount
400    */
401   function _getTokenAmount(uint256 _weiAmount)
402     internal view returns (uint256)
403   {
404     return _weiAmount.mul(rate);
405   }
406 
407   /**
408    * @dev Determines how ETH is stored/forwarded on purchases.
409    */
410   function _forwardFunds() internal {
411     wallet.transfer(msg.value);
412   }
413 }
414 
415 
416 
417 /**
418  * @title TimedCrowdsale
419  * @dev Crowdsale accepting contributions only within a time frame.
420  */
421 contract TimedCrowdsale is Crowdsale {
422   using SafeMath for uint256;
423 
424   uint256 public openingTime;
425   uint256 public closingTime;
426 
427   /**
428    * @dev Reverts if not in crowdsale time range.
429    */
430   modifier onlyWhileOpen {
431     // solium-disable-next-line security/no-block-members
432     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
433     _;
434   }
435 
436   /**
437    * @dev Constructor, takes crowdsale opening and closing times.
438    * @param _openingTime Crowdsale opening time
439    * @param _closingTime Crowdsale closing time
440    */
441   constructor(uint256 _openingTime, uint256 _closingTime) public {
442     // solium-disable-next-line security/no-block-members
443     require(_openingTime >= block.timestamp);
444     require(_closingTime >= _openingTime);
445 
446     openingTime = _openingTime;
447     closingTime = _closingTime;
448   }
449 
450   /**
451    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
452    * @return Whether crowdsale period has elapsed
453    */
454   function hasClosed() public view returns (bool) {
455     // solium-disable-next-line security/no-block-members
456     return block.timestamp > closingTime;
457   }
458 
459   /**
460    * @dev Extend parent behavior requiring to be within contributing period
461    * @param _beneficiary Token purchaser
462    * @param _weiAmount Amount of wei contributed
463    */
464   function _preValidatePurchase(
465     address _beneficiary,
466     uint256 _weiAmount
467   )
468     internal
469     onlyWhileOpen
470   {
471     super._preValidatePurchase(_beneficiary, _weiAmount);
472   }
473 
474 }
475 
476 
477 
478 /**
479  * @title FinalizableCrowdsale
480  * @dev Extension of Crowdsale where an owner can do extra work
481  * after finishing.
482  */
483 contract FinalizableCrowdsale is Ownable, TimedCrowdsale {
484   using SafeMath for uint256;
485 
486   bool public isFinalized = false;
487 
488   event Finalized();
489 
490   /**
491    * @dev Must be called after crowdsale ends, to do some extra finalization
492    * work. Calls the contract's finalization function.
493    */
494   function finalize() public onlyOwner {
495     require(!isFinalized);
496     require(hasClosed());
497 
498     finalization();
499     emit Finalized();
500 
501     isFinalized = true;
502   }
503 
504   /**
505    * @dev Can be overridden to add finalization logic. The overriding function
506    * should call super.finalization() to ensure the chain of finalization is
507    * executed entirely.
508    */
509   function finalization() internal {
510   }
511 
512 }
513 
514 
515 
516 
517 
518 
519 
520 
521 
522 
523 
524 /**
525  * @title Escrow
526  * @dev Base escrow contract, holds funds destinated to a payee until they
527  * withdraw them. The contract that uses the escrow as its payment method
528  * should be its owner, and provide public methods redirecting to the escrow's
529  * deposit and withdraw.
530  */
531 contract Escrow is Ownable {
532   using SafeMath for uint256;
533 
534   event Deposited(address indexed payee, uint256 weiAmount);
535   event Withdrawn(address indexed payee, uint256 weiAmount);
536 
537   mapping(address => uint256) private deposits;
538 
539   function depositsOf(address _payee) public view returns (uint256) {
540     return deposits[_payee];
541   }
542 
543   /**
544   * @dev Stores the sent amount as credit to be withdrawn.
545   * @param _payee The destination address of the funds.
546   */
547   function deposit(address _payee) public onlyOwner payable {
548     uint256 amount = msg.value;
549     deposits[_payee] = deposits[_payee].add(amount);
550 
551     emit Deposited(_payee, amount);
552   }
553 
554   /**
555   * @dev Withdraw accumulated balance for a payee.
556   * @param _payee The address whose funds will be withdrawn and transferred to.
557   */
558   function withdraw(address _payee) public onlyOwner {
559     uint256 payment = deposits[_payee];
560     assert(address(this).balance >= payment);
561 
562     deposits[_payee] = 0;
563 
564     _payee.transfer(payment);
565 
566     emit Withdrawn(_payee, payment);
567   }
568 }
569 
570 
571 
572 /**
573  * @title ConditionalEscrow
574  * @dev Base abstract escrow to only allow withdrawal if a condition is met.
575  */
576 contract ConditionalEscrow is Escrow {
577   /**
578   * @dev Returns whether an address is allowed to withdraw their funds. To be
579   * implemented by derived contracts.
580   * @param _payee The destination address of the funds.
581   */
582   function withdrawalAllowed(address _payee) public view returns (bool);
583 
584   function withdraw(address _payee) public {
585     require(withdrawalAllowed(_payee));
586     super.withdraw(_payee);
587   }
588 }
589 
590 
591 
592 
593 /**
594  * @title RefundEscrow
595  * @dev Escrow that holds funds for a beneficiary, deposited from multiple parties.
596  * The contract owner may close the deposit period, and allow for either withdrawal
597  * by the beneficiary, or refunds to the depositors.
598  */
599 contract RefundEscrow is Ownable, ConditionalEscrow {
600   enum State { Active, Refunding, Closed }
601 
602   event Closed();
603   event RefundsEnabled();
604 
605   State public state;
606   address public beneficiary;
607 
608   /**
609    * @dev Constructor.
610    * @param _beneficiary The beneficiary of the deposits.
611    */
612   constructor(address _beneficiary) public {
613     require(_beneficiary != address(0));
614     beneficiary = _beneficiary;
615     state = State.Active;
616   }
617 
618   /**
619    * @dev Stores funds that may later be refunded.
620    * @param _refundee The address funds will be sent to if a refund occurs.
621    */
622   function deposit(address _refundee) public payable {
623     require(state == State.Active);
624     super.deposit(_refundee);
625   }
626 
627   /**
628    * @dev Allows for the beneficiary to withdraw their funds, rejecting
629    * further deposits.
630    */
631   function close() public onlyOwner {
632     require(state == State.Active);
633     state = State.Closed;
634     emit Closed();
635   }
636 
637   /**
638    * @dev Allows for refunds to take place, rejecting further deposits.
639    */
640   function enableRefunds() public onlyOwner {
641     require(state == State.Active);
642     state = State.Refunding;
643     emit RefundsEnabled();
644   }
645 
646   /**
647    * @dev Withdraws the beneficiary's funds.
648    */
649   function beneficiaryWithdraw() public {
650     require(state == State.Closed);
651     beneficiary.transfer(address(this).balance);
652   }
653 
654   /**
655    * @dev Returns whether refundees can withdraw their deposits (be refunded).
656    */
657   function withdrawalAllowed(address _payee) public view returns (bool) {
658     return state == State.Refunding;
659   }
660 }
661 
662 
663 
664 /**
665  * @title RefundableCrowdsale
666  * @dev Extension of Crowdsale contract that adds a funding goal, and
667  * the possibility of users getting a refund if goal is not met.
668  */
669 contract RefundableCrowdsale is FinalizableCrowdsale {
670   using SafeMath for uint256;
671 
672   // minimum amount of funds to be raised in weis
673   uint256 public goal;
674 
675   // refund escrow used to hold funds while crowdsale is running
676   RefundEscrow private escrow;
677 
678   /**
679    * @dev Constructor, creates RefundEscrow.
680    * @param _goal Funding goal
681    */
682   constructor(uint256 _goal) public {
683     require(_goal > 0);
684     escrow = new RefundEscrow(wallet);
685     goal = _goal;
686   }
687 
688   /**
689    * @dev Investors can claim refunds here if crowdsale is unsuccessful
690    */
691   function claimRefund() public {
692     require(isFinalized);
693     require(!goalReached());
694 
695     escrow.withdraw(msg.sender);
696   }
697 
698   /**
699    * @dev Checks whether funding goal was reached.
700    * @return Whether funding goal was reached
701    */
702   function goalReached() public view returns (bool) {
703     return weiRaised >= goal;
704   }
705 
706   /**
707    * @dev escrow finalization task, called when owner calls finalize()
708    */
709   function finalization() internal {
710     if (goalReached()) {
711       escrow.close();
712       escrow.beneficiaryWithdraw();
713     } else {
714       escrow.enableRefunds();
715     }
716 
717     super.finalization();
718   }
719 
720   /**
721    * @dev Overrides Crowdsale fund forwarding, sending funds to escrow.
722    */
723   function _forwardFunds() internal {
724     escrow.deposit.value(msg.value)(msg.sender);
725   }
726 
727 }
728 
729 
730 
731 
732 
733 
734 
735 
736 
737 
738 
739 
740 /**
741  * @title Basic token
742  * @dev Basic version of StandardToken, with no allowances.
743  */
744 contract BasicToken is ERC20Basic {
745   using SafeMath for uint256;
746 
747   mapping(address => uint256) internal balances;
748 
749   uint256 internal totalSupply_;
750 
751   /**
752   * @dev Total number of tokens in existence
753   */
754   function totalSupply() public view returns (uint256) {
755     return totalSupply_;
756   }
757 
758   /**
759   * @dev Transfer token for a specified address
760   * @param _to The address to transfer to.
761   * @param _value The amount to be transferred.
762   */
763   function transfer(address _to, uint256 _value) public returns (bool) {
764     require(_value <= balances[msg.sender]);
765     require(_to != address(0));
766 
767     balances[msg.sender] = balances[msg.sender].sub(_value);
768     balances[_to] = balances[_to].add(_value);
769     emit Transfer(msg.sender, _to, _value);
770     return true;
771   }
772 
773   /**
774   * @dev Gets the balance of the specified address.
775   * @param _owner The address to query the the balance of.
776   * @return An uint256 representing the amount owned by the passed address.
777   */
778   function balanceOf(address _owner) public view returns (uint256) {
779     return balances[_owner];
780   }
781 
782 }
783 
784 
785 
786 
787 /**
788  * @title Standard ERC20 token
789  *
790  * @dev Implementation of the basic standard token.
791  * https://github.com/ethereum/EIPs/issues/20
792  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
793  */
794 contract StandardToken is ERC20, BasicToken {
795 
796   mapping (address => mapping (address => uint256)) internal allowed;
797 
798 
799   /**
800    * @dev Transfer tokens from one address to another
801    * @param _from address The address which you want to send tokens from
802    * @param _to address The address which you want to transfer to
803    * @param _value uint256 the amount of tokens to be transferred
804    */
805   function transferFrom(
806     address _from,
807     address _to,
808     uint256 _value
809   )
810     public
811     returns (bool)
812   {
813     require(_value <= balances[_from]);
814     require(_value <= allowed[_from][msg.sender]);
815     require(_to != address(0));
816 
817     balances[_from] = balances[_from].sub(_value);
818     balances[_to] = balances[_to].add(_value);
819     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
820     emit Transfer(_from, _to, _value);
821     return true;
822   }
823 
824   /**
825    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
826    * Beware that changing an allowance with this method brings the risk that someone may use both the old
827    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
828    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
829    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
830    * @param _spender The address which will spend the funds.
831    * @param _value The amount of tokens to be spent.
832    */
833   function approve(address _spender, uint256 _value) public returns (bool) {
834     allowed[msg.sender][_spender] = _value;
835     emit Approval(msg.sender, _spender, _value);
836     return true;
837   }
838 
839   /**
840    * @dev Function to check the amount of tokens that an owner allowed to a spender.
841    * @param _owner address The address which owns the funds.
842    * @param _spender address The address which will spend the funds.
843    * @return A uint256 specifying the amount of tokens still available for the spender.
844    */
845   function allowance(
846     address _owner,
847     address _spender
848    )
849     public
850     view
851     returns (uint256)
852   {
853     return allowed[_owner][_spender];
854   }
855 
856   /**
857    * @dev Increase the amount of tokens that an owner allowed to a spender.
858    * approve should be called when allowed[_spender] == 0. To increment
859    * allowed value is better to use this function to avoid 2 calls (and wait until
860    * the first transaction is mined)
861    * From MonolithDAO Token.sol
862    * @param _spender The address which will spend the funds.
863    * @param _addedValue The amount of tokens to increase the allowance by.
864    */
865   function increaseApproval(
866     address _spender,
867     uint256 _addedValue
868   )
869     public
870     returns (bool)
871   {
872     allowed[msg.sender][_spender] = (
873       allowed[msg.sender][_spender].add(_addedValue));
874     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
875     return true;
876   }
877 
878   /**
879    * @dev Decrease the amount of tokens that an owner allowed to a spender.
880    * approve should be called when allowed[_spender] == 0. To decrement
881    * allowed value is better to use this function to avoid 2 calls (and wait until
882    * the first transaction is mined)
883    * From MonolithDAO Token.sol
884    * @param _spender The address which will spend the funds.
885    * @param _subtractedValue The amount of tokens to decrease the allowance by.
886    */
887   function decreaseApproval(
888     address _spender,
889     uint256 _subtractedValue
890   )
891     public
892     returns (bool)
893   {
894     uint256 oldValue = allowed[msg.sender][_spender];
895     if (_subtractedValue >= oldValue) {
896       allowed[msg.sender][_spender] = 0;
897     } else {
898       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
899     }
900     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
901     return true;
902   }
903 
904 }
905 
906 
907 
908 
909 contract NeLunaCoin is StandardToken {
910     using SafeERC20 for ERC20;
911     
912     string public name = "NeLunaCoin";
913     string public symbol = "NLC";
914     uint8 public decimals = 18;
915     uint public INITIAL_SUPPLY = 1200000000 * (10 ** uint256(decimals));
916     constructor() public {
917         totalSupply_ = INITIAL_SUPPLY;
918         balances[msg.sender] = INITIAL_SUPPLY;
919         emit Transfer(address(this), msg.sender, INITIAL_SUPPLY);
920     }
921 }
922 
923 contract NeLunaCoinCrowdsale is RefundableCrowdsale {
924 
925     uint256 period1;
926     uint256 period2;
927     uint256 period3;
928 
929     event GetTokensBack(uint256 amount);
930     event SendTokensToContributor(address contributor, uint256 tokenAmount);
931 
932     struct Contributor {
933         address addressBuyer;
934         uint256 tokensAmount;
935         bool tokensSent;
936     }
937 
938     Contributor[] contributors;
939 
940     constructor(uint256 _openingTime, uint256 _closingTime, uint _rate, address _wallet, ERC20 _token, uint256 _goal, uint256 _period1, uint256 _period2, uint256 _period3) 
941         public 
942         FinalizableCrowdsale()
943         TimedCrowdsale(_openingTime, _closingTime)
944         Crowdsale(_rate, _wallet, _token)
945         RefundableCrowdsale(_goal)
946         { 
947             period1 = _period1;
948             period2 = _period2;
949             period3 = _period3;
950     }
951 
952     // Token Purchase
953     // =========================
954     function () external payable {
955         buyTokens(msg.sender);
956     }
957 
958     function getContributors() public view returns (uint256) {
959         return contributors.length;
960     }
961 
962     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
963         //35% more
964         if(period1 >= block.timestamp) {
965             return _weiAmount.mul(rate) + (_weiAmount.mul(rate).div(100).mul(35));
966         }
967         //25% more
968         if(period2 >= block.timestamp) {
969             return _weiAmount.mul(rate) + (_weiAmount.mul(rate).div(100).mul(25));
970         }
971         //15% more
972         if(period3 >= block.timestamp) {
973             return _weiAmount.mul(rate) + (_weiAmount.mul(rate).div(100).mul(15));
974         }
975         return _weiAmount.mul(rate);
976     }
977 
978     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal
979     {
980         contributors.push(Contributor(_beneficiary, _tokenAmount, false));
981     }
982     
983     function sendTokensAfterCrowdsale(uint256 start, uint256 end) public {
984         require(isFinalized);
985         require(hasClosed());
986         require(contributors.length > 0);
987 
988         if(goalReached()) {
989             //Send Tokens to everyone
990             require(start < end && end < contributors.length);
991             for(uint256 i = start; i <= end; i++) {
992                 if(contributors[i].tokensSent == false) {
993                     contributors[i].tokensSent = true;
994                     token.safeTransfer(contributors[i].addressBuyer, contributors[i].tokensAmount); 
995                     emit SendTokensToContributor(contributors[i].addressBuyer, contributors[i].tokensAmount);
996                 }
997             }
998         }
999     }
1000 
1001     function getTokensBackAFterCorwdsale() onlyOwner public {
1002         require(isFinalized);
1003         require(hasClosed());
1004         //send the remaining tokens back
1005         uint256 tokensLeft = token.balanceOf(address(this));
1006         token.transfer(wallet, tokensLeft);
1007         emit GetTokensBack(tokensLeft);
1008     }
1009 }