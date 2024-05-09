1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
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
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
68 
69 /**
70  * @title ERC20Basic
71  * @dev Simpler version of ERC20 interface
72  * See https://github.com/ethereum/EIPs/issues/179
73  */
74 contract ERC20Basic {
75   function totalSupply() public view returns (uint256);
76   function balanceOf(address _who) public view returns (uint256);
77   function transfer(address _to, uint256 _value) public returns (bool);
78   event Transfer(address indexed from, address indexed to, uint256 value);
79 }
80 
81 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
82 
83 /**
84  * @title SafeMath
85  * @dev Math operations with safety checks that throw on error
86  */
87 library SafeMath {
88 
89   /**
90   * @dev Multiplies two numbers, throws on overflow.
91   */
92   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
93     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
94     // benefit is lost if 'b' is also tested.
95     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
96     if (_a == 0) {
97       return 0;
98     }
99 
100     c = _a * _b;
101     assert(c / _a == _b);
102     return c;
103   }
104 
105   /**
106   * @dev Integer division of two numbers, truncating the quotient.
107   */
108   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
109     // assert(_b > 0); // Solidity automatically throws when dividing by 0
110     // uint256 c = _a / _b;
111     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
112     return _a / _b;
113   }
114 
115   /**
116   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
117   */
118   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
119     assert(_b <= _a);
120     return _a - _b;
121   }
122 
123   /**
124   * @dev Adds two numbers, throws on overflow.
125   */
126   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
127     c = _a + _b;
128     assert(c >= _a);
129     return c;
130   }
131 }
132 
133 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
134 
135 /**
136  * @title Basic token
137  * @dev Basic version of StandardToken, with no allowances.
138  */
139 contract BasicToken is ERC20Basic {
140   using SafeMath for uint256;
141 
142   mapping(address => uint256) internal balances;
143 
144   uint256 internal totalSupply_;
145 
146   /**
147   * @dev Total number of tokens in existence
148   */
149   function totalSupply() public view returns (uint256) {
150     return totalSupply_;
151   }
152 
153   /**
154   * @dev Transfer token for a specified address
155   * @param _to The address to transfer to.
156   * @param _value The amount to be transferred.
157   */
158   function transfer(address _to, uint256 _value) public returns (bool) {
159     require(_value <= balances[msg.sender]);
160     require(_to != address(0));
161 
162     balances[msg.sender] = balances[msg.sender].sub(_value);
163     balances[_to] = balances[_to].add(_value);
164     emit Transfer(msg.sender, _to, _value);
165     return true;
166   }
167 
168   /**
169   * @dev Gets the balance of the specified address.
170   * @param _owner The address to query the the balance of.
171   * @return An uint256 representing the amount owned by the passed address.
172   */
173   function balanceOf(address _owner) public view returns (uint256) {
174     return balances[_owner];
175   }
176 
177 }
178 
179 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
180 
181 /**
182  * @title ERC20 interface
183  * @dev see https://github.com/ethereum/EIPs/issues/20
184  */
185 contract ERC20 is ERC20Basic {
186   function allowance(address _owner, address _spender)
187     public view returns (uint256);
188 
189   function transferFrom(address _from, address _to, uint256 _value)
190     public returns (bool);
191 
192   function approve(address _spender, uint256 _value) public returns (bool);
193   event Approval(
194     address indexed owner,
195     address indexed spender,
196     uint256 value
197   );
198 }
199 
200 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
201 
202 /**
203  * @title Standard ERC20 token
204  *
205  * @dev Implementation of the basic standard token.
206  * https://github.com/ethereum/EIPs/issues/20
207  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
208  */
209 contract StandardToken is ERC20, BasicToken {
210 
211   mapping (address => mapping (address => uint256)) internal allowed;
212 
213 
214   /**
215    * @dev Transfer tokens from one address to another
216    * @param _from address The address which you want to send tokens from
217    * @param _to address The address which you want to transfer to
218    * @param _value uint256 the amount of tokens to be transferred
219    */
220   function transferFrom(
221     address _from,
222     address _to,
223     uint256 _value
224   )
225     public
226     returns (bool)
227   {
228     require(_value <= balances[_from]);
229     require(_value <= allowed[_from][msg.sender]);
230     require(_to != address(0));
231 
232     balances[_from] = balances[_from].sub(_value);
233     balances[_to] = balances[_to].add(_value);
234     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
235     emit Transfer(_from, _to, _value);
236     return true;
237   }
238 
239   /**
240    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
241    * Beware that changing an allowance with this method brings the risk that someone may use both the old
242    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
243    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
244    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
245    * @param _spender The address which will spend the funds.
246    * @param _value The amount of tokens to be spent.
247    */
248   function approve(address _spender, uint256 _value) public returns (bool) {
249     allowed[msg.sender][_spender] = _value;
250     emit Approval(msg.sender, _spender, _value);
251     return true;
252   }
253 
254   /**
255    * @dev Function to check the amount of tokens that an owner allowed to a spender.
256    * @param _owner address The address which owns the funds.
257    * @param _spender address The address which will spend the funds.
258    * @return A uint256 specifying the amount of tokens still available for the spender.
259    */
260   function allowance(
261     address _owner,
262     address _spender
263    )
264     public
265     view
266     returns (uint256)
267   {
268     return allowed[_owner][_spender];
269   }
270 
271   /**
272    * @dev Increase the amount of tokens that an owner allowed to a spender.
273    * approve should be called when allowed[_spender] == 0. To increment
274    * allowed value is better to use this function to avoid 2 calls (and wait until
275    * the first transaction is mined)
276    * From MonolithDAO Token.sol
277    * @param _spender The address which will spend the funds.
278    * @param _addedValue The amount of tokens to increase the allowance by.
279    */
280   function increaseApproval(
281     address _spender,
282     uint256 _addedValue
283   )
284     public
285     returns (bool)
286   {
287     allowed[msg.sender][_spender] = (
288       allowed[msg.sender][_spender].add(_addedValue));
289     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
290     return true;
291   }
292 
293   /**
294    * @dev Decrease the amount of tokens that an owner allowed to a spender.
295    * approve should be called when allowed[_spender] == 0. To decrement
296    * allowed value is better to use this function to avoid 2 calls (and wait until
297    * the first transaction is mined)
298    * From MonolithDAO Token.sol
299    * @param _spender The address which will spend the funds.
300    * @param _subtractedValue The amount of tokens to decrease the allowance by.
301    */
302   function decreaseApproval(
303     address _spender,
304     uint256 _subtractedValue
305   )
306     public
307     returns (bool)
308   {
309     uint256 oldValue = allowed[msg.sender][_spender];
310     if (_subtractedValue >= oldValue) {
311       allowed[msg.sender][_spender] = 0;
312     } else {
313       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
314     }
315     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
316     return true;
317   }
318 
319 }
320 
321 // File: contracts/BtcexToken.sol
322 
323 contract BtcexToken is StandardToken, Ownable {
324     string public name;
325     string public symbol;
326     uint8 public decimals;
327 
328     constructor(string _name, string _symbol, uint8 _decimals, uint _totalTokens)
329     public {
330         name = _name;
331         symbol = _symbol;
332         decimals = _decimals;
333         totalSupply_ = _totalTokens;
334     }
335 
336     function transferOwnershipAndTotalBalance(address _crowdsale) onlyOwner public {
337         balances[_crowdsale] = totalSupply_;
338         transferOwnership(_crowdsale);
339 
340     }
341 }
342 
343 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
344 
345 /**
346  * @title SafeERC20
347  * @dev Wrappers around ERC20 operations that throw on failure.
348  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
349  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
350  */
351 library SafeERC20 {
352   function safeTransfer(
353     ERC20Basic _token,
354     address _to,
355     uint256 _value
356   )
357     internal
358   {
359     require(_token.transfer(_to, _value));
360   }
361 
362   function safeTransferFrom(
363     ERC20 _token,
364     address _from,
365     address _to,
366     uint256 _value
367   )
368     internal
369   {
370     require(_token.transferFrom(_from, _to, _value));
371   }
372 
373   function safeApprove(
374     ERC20 _token,
375     address _spender,
376     uint256 _value
377   )
378     internal
379   {
380     require(_token.approve(_spender, _value));
381   }
382 }
383 
384 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
385 
386 /**
387  * @title Crowdsale
388  * @dev Crowdsale is a base contract for managing a token crowdsale,
389  * allowing investors to purchase tokens with ether. This contract implements
390  * such functionality in its most fundamental form and can be extended to provide additional
391  * functionality and/or custom behavior.
392  * The external interface represents the basic interface for purchasing tokens, and conform
393  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
394  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
395  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
396  * behavior.
397  */
398 contract Crowdsale {
399   using SafeMath for uint256;
400   using SafeERC20 for ERC20;
401 
402   // The token being sold
403   ERC20 public token;
404 
405   // Address where funds are collected
406   address public wallet;
407 
408   // How many token units a buyer gets per wei.
409   // The rate is the conversion between wei and the smallest and indivisible token unit.
410   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
411   // 1 wei will give you 1 unit, or 0.001 TOK.
412   uint256 public rate;
413 
414   // Amount of wei raised
415   uint256 public weiRaised;
416 
417   /**
418    * Event for token purchase logging
419    * @param purchaser who paid for the tokens
420    * @param beneficiary who got the tokens
421    * @param value weis paid for purchase
422    * @param amount amount of tokens purchased
423    */
424   event TokenPurchase(
425     address indexed purchaser,
426     address indexed beneficiary,
427     uint256 value,
428     uint256 amount
429   );
430 
431   /**
432    * @param _rate Number of token units a buyer gets per wei
433    * @param _wallet Address where collected funds will be forwarded to
434    * @param _token Address of the token being sold
435    */
436   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
437     require(_rate > 0);
438     require(_wallet != address(0));
439     require(_token != address(0));
440 
441     rate = _rate;
442     wallet = _wallet;
443     token = _token;
444   }
445 
446   // -----------------------------------------
447   // Crowdsale external interface
448   // -----------------------------------------
449 
450   /**
451    * @dev fallback function ***DO NOT OVERRIDE***
452    */
453   function () external payable {
454     buyTokens(msg.sender);
455   }
456 
457   /**
458    * @dev low level token purchase ***DO NOT OVERRIDE***
459    * @param _beneficiary Address performing the token purchase
460    */
461   function buyTokens(address _beneficiary) public payable {
462 
463     uint256 weiAmount = msg.value;
464     _preValidatePurchase(_beneficiary, weiAmount);
465 
466     // calculate token amount to be created
467     uint256 tokens = _getTokenAmount(weiAmount);
468 
469     // update state
470     weiRaised = weiRaised.add(weiAmount);
471 
472     _processPurchase(_beneficiary, tokens);
473     emit TokenPurchase(
474       msg.sender,
475       _beneficiary,
476       weiAmount,
477       tokens
478     );
479 
480     _updatePurchasingState(_beneficiary, weiAmount);
481 
482     _forwardFunds();
483     _postValidatePurchase(_beneficiary, weiAmount);
484   }
485 
486   // -----------------------------------------
487   // Internal interface (extensible)
488   // -----------------------------------------
489 
490   /**
491    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
492    * Example from CappedCrowdsale.sol's _preValidatePurchase method: 
493    *   super._preValidatePurchase(_beneficiary, _weiAmount);
494    *   require(weiRaised.add(_weiAmount) <= cap);
495    * @param _beneficiary Address performing the token purchase
496    * @param _weiAmount Value in wei involved in the purchase
497    */
498   function _preValidatePurchase(
499     address _beneficiary,
500     uint256 _weiAmount
501   )
502     internal
503   {
504     require(_beneficiary != address(0));
505     require(_weiAmount != 0);
506   }
507 
508   /**
509    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
510    * @param _beneficiary Address performing the token purchase
511    * @param _weiAmount Value in wei involved in the purchase
512    */
513   function _postValidatePurchase(
514     address _beneficiary,
515     uint256 _weiAmount
516   )
517     internal
518   {
519     // optional override
520   }
521 
522   /**
523    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
524    * @param _beneficiary Address performing the token purchase
525    * @param _tokenAmount Number of tokens to be emitted
526    */
527   function _deliverTokens(
528     address _beneficiary,
529     uint256 _tokenAmount
530   )
531     internal
532   {
533     token.safeTransfer(_beneficiary, _tokenAmount);
534   }
535 
536   /**
537    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
538    * @param _beneficiary Address receiving the tokens
539    * @param _tokenAmount Number of tokens to be purchased
540    */
541   function _processPurchase(
542     address _beneficiary,
543     uint256 _tokenAmount
544   )
545     internal
546   {
547     _deliverTokens(_beneficiary, _tokenAmount);
548   }
549 
550   /**
551    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
552    * @param _beneficiary Address receiving the tokens
553    * @param _weiAmount Value in wei involved in the purchase
554    */
555   function _updatePurchasingState(
556     address _beneficiary,
557     uint256 _weiAmount
558   )
559     internal
560   {
561     // optional override
562   }
563 
564   /**
565    * @dev Override to extend the way in which ether is converted to tokens.
566    * @param _weiAmount Value in wei to be converted into tokens
567    * @return Number of tokens that can be purchased with the specified _weiAmount
568    */
569   function _getTokenAmount(uint256 _weiAmount)
570     internal view returns (uint256)
571   {
572     return _weiAmount.mul(rate);
573   }
574 
575   /**
576    * @dev Determines how ETH is stored/forwarded on purchases.
577    */
578   function _forwardFunds() internal {
579     wallet.transfer(msg.value);
580   }
581 }
582 
583 // File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
584 
585 /**
586  * @title TimedCrowdsale
587  * @dev Crowdsale accepting contributions only within a time frame.
588  */
589 contract TimedCrowdsale is Crowdsale {
590   using SafeMath for uint256;
591 
592   uint256 public openingTime;
593   uint256 public closingTime;
594 
595   /**
596    * @dev Reverts if not in crowdsale time range.
597    */
598   modifier onlyWhileOpen {
599     // solium-disable-next-line security/no-block-members
600     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
601     _;
602   }
603 
604   /**
605    * @dev Constructor, takes crowdsale opening and closing times.
606    * @param _openingTime Crowdsale opening time
607    * @param _closingTime Crowdsale closing time
608    */
609   constructor(uint256 _openingTime, uint256 _closingTime) public {
610     // solium-disable-next-line security/no-block-members
611     require(_openingTime >= block.timestamp);
612     require(_closingTime >= _openingTime);
613 
614     openingTime = _openingTime;
615     closingTime = _closingTime;
616   }
617 
618   /**
619    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
620    * @return Whether crowdsale period has elapsed
621    */
622   function hasClosed() public view returns (bool) {
623     // solium-disable-next-line security/no-block-members
624     return block.timestamp > closingTime;
625   }
626 
627   /**
628    * @dev Extend parent behavior requiring to be within contributing period
629    * @param _beneficiary Token purchaser
630    * @param _weiAmount Amount of wei contributed
631    */
632   function _preValidatePurchase(
633     address _beneficiary,
634     uint256 _weiAmount
635   )
636     internal
637     onlyWhileOpen
638   {
639     super._preValidatePurchase(_beneficiary, _weiAmount);
640   }
641 
642 }
643 
644 // File: openzeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol
645 
646 /**
647  * @title FinalizableCrowdsale
648  * @dev Extension of Crowdsale where an owner can do extra work
649  * after finishing.
650  */
651 contract FinalizableCrowdsale is Ownable, TimedCrowdsale {
652   using SafeMath for uint256;
653 
654   bool public isFinalized = false;
655 
656   event Finalized();
657 
658   /**
659    * @dev Must be called after crowdsale ends, to do some extra finalization
660    * work. Calls the contract's finalization function.
661    */
662   function finalize() public onlyOwner {
663     require(!isFinalized);
664     require(hasClosed());
665 
666     finalization();
667     emit Finalized();
668 
669     isFinalized = true;
670   }
671 
672   /**
673    * @dev Can be overridden to add finalization logic. The overriding function
674    * should call super.finalization() to ensure the chain of finalization is
675    * executed entirely.
676    */
677   function finalization() internal {
678   }
679 
680 }
681 
682 // File: openzeppelin-solidity/contracts/payment/Escrow.sol
683 
684 /**
685  * @title Escrow
686  * @dev Base escrow contract, holds funds destinated to a payee until they
687  * withdraw them. The contract that uses the escrow as its payment method
688  * should be its owner, and provide public methods redirecting to the escrow's
689  * deposit and withdraw.
690  */
691 contract Escrow is Ownable {
692   using SafeMath for uint256;
693 
694   event Deposited(address indexed payee, uint256 weiAmount);
695   event Withdrawn(address indexed payee, uint256 weiAmount);
696 
697   mapping(address => uint256) private deposits;
698 
699   function depositsOf(address _payee) public view returns (uint256) {
700     return deposits[_payee];
701   }
702 
703   /**
704   * @dev Stores the sent amount as credit to be withdrawn.
705   * @param _payee The destination address of the funds.
706   */
707   function deposit(address _payee) public onlyOwner payable {
708     uint256 amount = msg.value;
709     deposits[_payee] = deposits[_payee].add(amount);
710 
711     emit Deposited(_payee, amount);
712   }
713 
714   /**
715   * @dev Withdraw accumulated balance for a payee.
716   * @param _payee The address whose funds will be withdrawn and transferred to.
717   */
718   function withdraw(address _payee) public onlyOwner {
719     uint256 payment = deposits[_payee];
720     assert(address(this).balance >= payment);
721 
722     deposits[_payee] = 0;
723 
724     _payee.transfer(payment);
725 
726     emit Withdrawn(_payee, payment);
727   }
728 }
729 
730 // File: openzeppelin-solidity/contracts/payment/ConditionalEscrow.sol
731 
732 /**
733  * @title ConditionalEscrow
734  * @dev Base abstract escrow to only allow withdrawal if a condition is met.
735  */
736 contract ConditionalEscrow is Escrow {
737   /**
738   * @dev Returns whether an address is allowed to withdraw their funds. To be
739   * implemented by derived contracts.
740   * @param _payee The destination address of the funds.
741   */
742   function withdrawalAllowed(address _payee) public view returns (bool);
743 
744   function withdraw(address _payee) public {
745     require(withdrawalAllowed(_payee));
746     super.withdraw(_payee);
747   }
748 }
749 
750 // File: openzeppelin-solidity/contracts/payment/RefundEscrow.sol
751 
752 /**
753  * @title RefundEscrow
754  * @dev Escrow that holds funds for a beneficiary, deposited from multiple parties.
755  * The contract owner may close the deposit period, and allow for either withdrawal
756  * by the beneficiary, or refunds to the depositors.
757  */
758 contract RefundEscrow is Ownable, ConditionalEscrow {
759   enum State { Active, Refunding, Closed }
760 
761   event Closed();
762   event RefundsEnabled();
763 
764   State public state;
765   address public beneficiary;
766 
767   /**
768    * @dev Constructor.
769    * @param _beneficiary The beneficiary of the deposits.
770    */
771   constructor(address _beneficiary) public {
772     require(_beneficiary != address(0));
773     beneficiary = _beneficiary;
774     state = State.Active;
775   }
776 
777   /**
778    * @dev Stores funds that may later be refunded.
779    * @param _refundee The address funds will be sent to if a refund occurs.
780    */
781   function deposit(address _refundee) public payable {
782     require(state == State.Active);
783     super.deposit(_refundee);
784   }
785 
786   /**
787    * @dev Allows for the beneficiary to withdraw their funds, rejecting
788    * further deposits.
789    */
790   function close() public onlyOwner {
791     require(state == State.Active);
792     state = State.Closed;
793     emit Closed();
794   }
795 
796   /**
797    * @dev Allows for refunds to take place, rejecting further deposits.
798    */
799   function enableRefunds() public onlyOwner {
800     require(state == State.Active);
801     state = State.Refunding;
802     emit RefundsEnabled();
803   }
804 
805   /**
806    * @dev Withdraws the beneficiary's funds.
807    */
808   function beneficiaryWithdraw() public {
809     require(state == State.Closed);
810     beneficiary.transfer(address(this).balance);
811   }
812 
813   /**
814    * @dev Returns whether refundees can withdraw their deposits (be refunded).
815    */
816   function withdrawalAllowed(address _payee) public view returns (bool) {
817     return state == State.Refunding;
818   }
819 }
820 
821 // File: contracts/oraclizeAPI_0.5.sol
822 
823 // <ORACLIZE_API>
824 /*
825 Copyright (c) 2015-2016 Oraclize SRL
826 Copyright (c) 2016 Oraclize LTD
827 
828 
829 
830 Permission is hereby granted, free of charge, to any person obtaining a copy
831 of this software and associated documentation files (the "Software"), to deal
832 in the Software without restriction, including without limitation the rights
833 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
834 copies of the Software, and to permit persons to whom the Software is
835 furnished to do so, subject to the following conditions:
836 
837 
838 
839 The above copyright notice and this permission notice shall be included in
840 all copies or substantial portions of the Software.
841 
842 
843 
844 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
845 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
846 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
847 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
848 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
849 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
850 THE SOFTWARE.
851 */
852 
853 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
854 
855 pragma solidity >=0.4.18;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
856 
857 contract OraclizeI {
858     address public cbAddress;
859     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
860     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
861     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
862     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
863     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
864     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
865     function getPrice(string _datasource) public returns (uint _dsprice);
866     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
867     function setProofType(byte _proofType) external;
868     function setCustomGasPrice(uint _gasPrice) external;
869     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
870 }
871 
872 contract OraclizeAddrResolverI {
873     function getAddress() public returns (address _addr);
874 }
875 
876 /*
877 Begin solidity-cborutils
878 
879 https://github.com/smartcontractkit/solidity-cborutils
880 
881 MIT License
882 
883 Copyright (c) 2018 SmartContract ChainLink, Ltd.
884 
885 Permission is hereby granted, free of charge, to any person obtaining a copy
886 of this software and associated documentation files (the "Software"), to deal
887 in the Software without restriction, including without limitation the rights
888 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
889 copies of the Software, and to permit persons to whom the Software is
890 furnished to do so, subject to the following conditions:
891 
892 The above copyright notice and this permission notice shall be included in all
893 copies or substantial portions of the Software.
894 
895 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
896 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
897 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
898 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
899 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
900 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
901 SOFTWARE.
902  */
903 
904 library Buffer {
905     struct buffer {
906         bytes buf;
907         uint capacity;
908     }
909 
910     function init(buffer memory buf, uint _capacity) internal pure {
911         uint capacity = _capacity;
912         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
913         // Allocate space for the buffer data
914         buf.capacity = capacity;
915         assembly {
916             let ptr := mload(0x40)
917             mstore(buf, ptr)
918             mstore(ptr, 0)
919             mstore(0x40, add(ptr, capacity))
920         }
921     }
922 
923     function resize(buffer memory buf, uint capacity) private pure {
924         bytes memory oldbuf = buf.buf;
925         init(buf, capacity);
926         append(buf, oldbuf);
927     }
928 
929     function max(uint a, uint b) private pure returns(uint) {
930         if(a > b) {
931             return a;
932         }
933         return b;
934     }
935 
936     /**
937      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
938      *      would exceed the capacity of the buffer.
939      * @param buf The buffer to append to.
940      * @param data The data to append.
941      * @return The original buffer.
942      */
943     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
944         if(data.length + buf.buf.length > buf.capacity) {
945             resize(buf, max(buf.capacity, data.length) * 2);
946         }
947 
948         uint dest;
949         uint src;
950         uint len = data.length;
951         assembly {
952             // Memory address of the buffer data
953             let bufptr := mload(buf)
954             // Length of existing buffer data
955             let buflen := mload(bufptr)
956             // Start address = buffer address + buffer length + sizeof(buffer length)
957             dest := add(add(bufptr, buflen), 32)
958             // Update buffer length
959             mstore(bufptr, add(buflen, mload(data)))
960             src := add(data, 32)
961         }
962 
963         // Copy word-length chunks while possible
964         for(; len >= 32; len -= 32) {
965             assembly {
966                 mstore(dest, mload(src))
967             }
968             dest += 32;
969             src += 32;
970         }
971 
972         // Copy remaining bytes
973         uint mask = 256 ** (32 - len) - 1;
974         assembly {
975             let srcpart := and(mload(src), not(mask))
976             let destpart := and(mload(dest), mask)
977             mstore(dest, or(destpart, srcpart))
978         }
979 
980         return buf;
981     }
982 
983     /**
984      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
985      * exceed the capacity of the buffer.
986      * @param buf The buffer to append to.
987      * @param data The data to append.
988      * @return The original buffer.
989      */
990     function append(buffer memory buf, uint8 data) internal pure {
991         if(buf.buf.length + 1 > buf.capacity) {
992             resize(buf, buf.capacity * 2);
993         }
994 
995         assembly {
996             // Memory address of the buffer data
997             let bufptr := mload(buf)
998             // Length of existing buffer data
999             let buflen := mload(bufptr)
1000             // Address = buffer address + buffer length + sizeof(buffer length)
1001             let dest := add(add(bufptr, buflen), 32)
1002             mstore8(dest, data)
1003             // Update buffer length
1004             mstore(bufptr, add(buflen, 1))
1005         }
1006     }
1007 
1008     /**
1009      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
1010      * exceed the capacity of the buffer.
1011      * @param buf The buffer to append to.
1012      * @param data The data to append.
1013      * @return The original buffer.
1014      */
1015     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
1016         if(len + buf.buf.length > buf.capacity) {
1017             resize(buf, max(buf.capacity, len) * 2);
1018         }
1019 
1020         uint mask = 256 ** len - 1;
1021         assembly {
1022             // Memory address of the buffer data
1023             let bufptr := mload(buf)
1024             // Length of existing buffer data
1025             let buflen := mload(bufptr)
1026             // Address = buffer address + buffer length + sizeof(buffer length) + len
1027             let dest := add(add(bufptr, buflen), len)
1028             mstore(dest, or(and(mload(dest), not(mask)), data))
1029             // Update buffer length
1030             mstore(bufptr, add(buflen, len))
1031         }
1032         return buf;
1033     }
1034 }
1035 
1036 library CBOR {
1037     using Buffer for Buffer.buffer;
1038 
1039     uint8 private constant MAJOR_TYPE_INT = 0;
1040     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
1041     uint8 private constant MAJOR_TYPE_BYTES = 2;
1042     uint8 private constant MAJOR_TYPE_STRING = 3;
1043     uint8 private constant MAJOR_TYPE_ARRAY = 4;
1044     uint8 private constant MAJOR_TYPE_MAP = 5;
1045     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
1046 
1047     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
1048         if(value <= 23) {
1049             buf.append(uint8((major << 5) | value));
1050         } else if(value <= 0xFF) {
1051             buf.append(uint8((major << 5) | 24));
1052             buf.appendInt(value, 1);
1053         } else if(value <= 0xFFFF) {
1054             buf.append(uint8((major << 5) | 25));
1055             buf.appendInt(value, 2);
1056         } else if(value <= 0xFFFFFFFF) {
1057             buf.append(uint8((major << 5) | 26));
1058             buf.appendInt(value, 4);
1059         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
1060             buf.append(uint8((major << 5) | 27));
1061             buf.appendInt(value, 8);
1062         }
1063     }
1064 
1065     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
1066         buf.append(uint8((major << 5) | 31));
1067     }
1068 
1069     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
1070         encodeType(buf, MAJOR_TYPE_INT, value);
1071     }
1072 
1073     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
1074         if(value >= 0) {
1075             encodeType(buf, MAJOR_TYPE_INT, uint(value));
1076         } else {
1077             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
1078         }
1079     }
1080 
1081     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
1082         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
1083         buf.append(value);
1084     }
1085 
1086     function encodeString(Buffer.buffer memory buf, string value) internal pure {
1087         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
1088         buf.append(bytes(value));
1089     }
1090 
1091     function startArray(Buffer.buffer memory buf) internal pure {
1092         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
1093     }
1094 
1095     function startMap(Buffer.buffer memory buf) internal pure {
1096         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
1097     }
1098 
1099     function endSequence(Buffer.buffer memory buf) internal pure {
1100         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
1101     }
1102 }
1103 
1104 /*
1105 End solidity-cborutils
1106  */
1107 
1108 contract usingOraclize {
1109     uint constant day = 60*60*24;
1110     uint constant week = 60*60*24*7;
1111     uint constant month = 60*60*24*30;
1112     byte constant proofType_NONE = 0x00;
1113     byte constant proofType_TLSNotary = 0x10;
1114     byte constant proofType_Ledger = 0x30;
1115     byte constant proofType_Android = 0x40;
1116     byte constant proofType_Native = 0xF0;
1117     byte constant proofStorage_IPFS = 0x01;
1118     uint8 constant networkID_auto = 0;
1119     uint8 constant networkID_mainnet = 1;
1120     uint8 constant networkID_testnet = 2;
1121     uint8 constant networkID_morden = 2;
1122     uint8 constant networkID_consensys = 161;
1123 
1124     OraclizeAddrResolverI OAR;
1125 
1126     OraclizeI oraclize;
1127     modifier oraclizeAPI {
1128         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
1129             oraclize_setNetwork(networkID_auto);
1130 
1131         if(address(oraclize) != OAR.getAddress())
1132             oraclize = OraclizeI(OAR.getAddress());
1133 
1134         _;
1135     }
1136     modifier coupon(string code){
1137         oraclize = OraclizeI(OAR.getAddress());
1138         _;
1139     }
1140 
1141     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
1142       return oraclize_setNetwork();
1143       networkID; // silence the warning and remain backwards compatible
1144     }
1145     function oraclize_setNetwork() internal returns(bool){
1146         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
1147             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
1148             oraclize_setNetworkName("eth_mainnet");
1149             return true;
1150         }
1151         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
1152             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
1153             oraclize_setNetworkName("eth_ropsten3");
1154             return true;
1155         }
1156         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
1157             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
1158             oraclize_setNetworkName("eth_kovan");
1159             return true;
1160         }
1161         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
1162             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
1163             oraclize_setNetworkName("eth_rinkeby");
1164             return true;
1165         }
1166         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
1167             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
1168             return true;
1169         }
1170         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
1171             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
1172             return true;
1173         }
1174         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
1175             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
1176             return true;
1177         }
1178         return false;
1179     }
1180 
1181     function __callback(bytes32 myid, string result) public {
1182         __callback(myid, result, new bytes(0));
1183     }
1184     function __callback(bytes32 myid, string result, bytes proof) public {
1185       return;
1186       myid; result; proof; // Silence compiler warnings
1187     }
1188 
1189     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
1190         return oraclize.getPrice(datasource);
1191     }
1192 
1193     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
1194         return oraclize.getPrice(datasource, gaslimit);
1195     }
1196 
1197     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
1198         uint price = oraclize.getPrice(datasource);
1199         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1200         return oraclize.query.value(price)(0, datasource, arg);
1201     }
1202     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
1203         uint price = oraclize.getPrice(datasource);
1204         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1205         return oraclize.query.value(price)(timestamp, datasource, arg);
1206     }
1207     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1208         uint price = oraclize.getPrice(datasource, gaslimit);
1209         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1210         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
1211     }
1212     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1213         uint price = oraclize.getPrice(datasource, gaslimit);
1214         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1215         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
1216     }
1217     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
1218         uint price = oraclize.getPrice(datasource);
1219         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1220         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
1221     }
1222     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
1223         uint price = oraclize.getPrice(datasource);
1224         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1225         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
1226     }
1227     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1228         uint price = oraclize.getPrice(datasource, gaslimit);
1229         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1230         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
1231     }
1232     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1233         uint price = oraclize.getPrice(datasource, gaslimit);
1234         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1235         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
1236     }
1237     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
1238         uint price = oraclize.getPrice(datasource);
1239         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1240         bytes memory args = stra2cbor(argN);
1241         return oraclize.queryN.value(price)(0, datasource, args);
1242     }
1243     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
1244         uint price = oraclize.getPrice(datasource);
1245         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1246         bytes memory args = stra2cbor(argN);
1247         return oraclize.queryN.value(price)(timestamp, datasource, args);
1248     }
1249     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1250         uint price = oraclize.getPrice(datasource, gaslimit);
1251         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1252         bytes memory args = stra2cbor(argN);
1253         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
1254     }
1255     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1256         uint price = oraclize.getPrice(datasource, gaslimit);
1257         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1258         bytes memory args = stra2cbor(argN);
1259         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
1260     }
1261     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
1262         string[] memory dynargs = new string[](1);
1263         dynargs[0] = args[0];
1264         return oraclize_query(datasource, dynargs);
1265     }
1266     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
1267         string[] memory dynargs = new string[](1);
1268         dynargs[0] = args[0];
1269         return oraclize_query(timestamp, datasource, dynargs);
1270     }
1271     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1272         string[] memory dynargs = new string[](1);
1273         dynargs[0] = args[0];
1274         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1275     }
1276     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1277         string[] memory dynargs = new string[](1);
1278         dynargs[0] = args[0];
1279         return oraclize_query(datasource, dynargs, gaslimit);
1280     }
1281 
1282     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
1283         string[] memory dynargs = new string[](2);
1284         dynargs[0] = args[0];
1285         dynargs[1] = args[1];
1286         return oraclize_query(datasource, dynargs);
1287     }
1288     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
1289         string[] memory dynargs = new string[](2);
1290         dynargs[0] = args[0];
1291         dynargs[1] = args[1];
1292         return oraclize_query(timestamp, datasource, dynargs);
1293     }
1294     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1295         string[] memory dynargs = new string[](2);
1296         dynargs[0] = args[0];
1297         dynargs[1] = args[1];
1298         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1299     }
1300     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1301         string[] memory dynargs = new string[](2);
1302         dynargs[0] = args[0];
1303         dynargs[1] = args[1];
1304         return oraclize_query(datasource, dynargs, gaslimit);
1305     }
1306     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
1307         string[] memory dynargs = new string[](3);
1308         dynargs[0] = args[0];
1309         dynargs[1] = args[1];
1310         dynargs[2] = args[2];
1311         return oraclize_query(datasource, dynargs);
1312     }
1313     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
1314         string[] memory dynargs = new string[](3);
1315         dynargs[0] = args[0];
1316         dynargs[1] = args[1];
1317         dynargs[2] = args[2];
1318         return oraclize_query(timestamp, datasource, dynargs);
1319     }
1320     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1321         string[] memory dynargs = new string[](3);
1322         dynargs[0] = args[0];
1323         dynargs[1] = args[1];
1324         dynargs[2] = args[2];
1325         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1326     }
1327     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1328         string[] memory dynargs = new string[](3);
1329         dynargs[0] = args[0];
1330         dynargs[1] = args[1];
1331         dynargs[2] = args[2];
1332         return oraclize_query(datasource, dynargs, gaslimit);
1333     }
1334 
1335     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
1336         string[] memory dynargs = new string[](4);
1337         dynargs[0] = args[0];
1338         dynargs[1] = args[1];
1339         dynargs[2] = args[2];
1340         dynargs[3] = args[3];
1341         return oraclize_query(datasource, dynargs);
1342     }
1343     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
1344         string[] memory dynargs = new string[](4);
1345         dynargs[0] = args[0];
1346         dynargs[1] = args[1];
1347         dynargs[2] = args[2];
1348         dynargs[3] = args[3];
1349         return oraclize_query(timestamp, datasource, dynargs);
1350     }
1351     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1352         string[] memory dynargs = new string[](4);
1353         dynargs[0] = args[0];
1354         dynargs[1] = args[1];
1355         dynargs[2] = args[2];
1356         dynargs[3] = args[3];
1357         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1358     }
1359     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1360         string[] memory dynargs = new string[](4);
1361         dynargs[0] = args[0];
1362         dynargs[1] = args[1];
1363         dynargs[2] = args[2];
1364         dynargs[3] = args[3];
1365         return oraclize_query(datasource, dynargs, gaslimit);
1366     }
1367     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
1368         string[] memory dynargs = new string[](5);
1369         dynargs[0] = args[0];
1370         dynargs[1] = args[1];
1371         dynargs[2] = args[2];
1372         dynargs[3] = args[3];
1373         dynargs[4] = args[4];
1374         return oraclize_query(datasource, dynargs);
1375     }
1376     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
1377         string[] memory dynargs = new string[](5);
1378         dynargs[0] = args[0];
1379         dynargs[1] = args[1];
1380         dynargs[2] = args[2];
1381         dynargs[3] = args[3];
1382         dynargs[4] = args[4];
1383         return oraclize_query(timestamp, datasource, dynargs);
1384     }
1385     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1386         string[] memory dynargs = new string[](5);
1387         dynargs[0] = args[0];
1388         dynargs[1] = args[1];
1389         dynargs[2] = args[2];
1390         dynargs[3] = args[3];
1391         dynargs[4] = args[4];
1392         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1393     }
1394     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1395         string[] memory dynargs = new string[](5);
1396         dynargs[0] = args[0];
1397         dynargs[1] = args[1];
1398         dynargs[2] = args[2];
1399         dynargs[3] = args[3];
1400         dynargs[4] = args[4];
1401         return oraclize_query(datasource, dynargs, gaslimit);
1402     }
1403     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1404         uint price = oraclize.getPrice(datasource);
1405         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1406         bytes memory args = ba2cbor(argN);
1407         return oraclize.queryN.value(price)(0, datasource, args);
1408     }
1409     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1410         uint price = oraclize.getPrice(datasource);
1411         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1412         bytes memory args = ba2cbor(argN);
1413         return oraclize.queryN.value(price)(timestamp, datasource, args);
1414     }
1415     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1416         uint price = oraclize.getPrice(datasource, gaslimit);
1417         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1418         bytes memory args = ba2cbor(argN);
1419         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
1420     }
1421     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1422         uint price = oraclize.getPrice(datasource, gaslimit);
1423         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1424         bytes memory args = ba2cbor(argN);
1425         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
1426     }
1427     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1428         bytes[] memory dynargs = new bytes[](1);
1429         dynargs[0] = args[0];
1430         return oraclize_query(datasource, dynargs);
1431     }
1432     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1433         bytes[] memory dynargs = new bytes[](1);
1434         dynargs[0] = args[0];
1435         return oraclize_query(timestamp, datasource, dynargs);
1436     }
1437     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1438         bytes[] memory dynargs = new bytes[](1);
1439         dynargs[0] = args[0];
1440         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1441     }
1442     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1443         bytes[] memory dynargs = new bytes[](1);
1444         dynargs[0] = args[0];
1445         return oraclize_query(datasource, dynargs, gaslimit);
1446     }
1447 
1448     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1449         bytes[] memory dynargs = new bytes[](2);
1450         dynargs[0] = args[0];
1451         dynargs[1] = args[1];
1452         return oraclize_query(datasource, dynargs);
1453     }
1454     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1455         bytes[] memory dynargs = new bytes[](2);
1456         dynargs[0] = args[0];
1457         dynargs[1] = args[1];
1458         return oraclize_query(timestamp, datasource, dynargs);
1459     }
1460     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1461         bytes[] memory dynargs = new bytes[](2);
1462         dynargs[0] = args[0];
1463         dynargs[1] = args[1];
1464         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1465     }
1466     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1467         bytes[] memory dynargs = new bytes[](2);
1468         dynargs[0] = args[0];
1469         dynargs[1] = args[1];
1470         return oraclize_query(datasource, dynargs, gaslimit);
1471     }
1472     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1473         bytes[] memory dynargs = new bytes[](3);
1474         dynargs[0] = args[0];
1475         dynargs[1] = args[1];
1476         dynargs[2] = args[2];
1477         return oraclize_query(datasource, dynargs);
1478     }
1479     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1480         bytes[] memory dynargs = new bytes[](3);
1481         dynargs[0] = args[0];
1482         dynargs[1] = args[1];
1483         dynargs[2] = args[2];
1484         return oraclize_query(timestamp, datasource, dynargs);
1485     }
1486     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1487         bytes[] memory dynargs = new bytes[](3);
1488         dynargs[0] = args[0];
1489         dynargs[1] = args[1];
1490         dynargs[2] = args[2];
1491         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1492     }
1493     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1494         bytes[] memory dynargs = new bytes[](3);
1495         dynargs[0] = args[0];
1496         dynargs[1] = args[1];
1497         dynargs[2] = args[2];
1498         return oraclize_query(datasource, dynargs, gaslimit);
1499     }
1500 
1501     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1502         bytes[] memory dynargs = new bytes[](4);
1503         dynargs[0] = args[0];
1504         dynargs[1] = args[1];
1505         dynargs[2] = args[2];
1506         dynargs[3] = args[3];
1507         return oraclize_query(datasource, dynargs);
1508     }
1509     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1510         bytes[] memory dynargs = new bytes[](4);
1511         dynargs[0] = args[0];
1512         dynargs[1] = args[1];
1513         dynargs[2] = args[2];
1514         dynargs[3] = args[3];
1515         return oraclize_query(timestamp, datasource, dynargs);
1516     }
1517     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1518         bytes[] memory dynargs = new bytes[](4);
1519         dynargs[0] = args[0];
1520         dynargs[1] = args[1];
1521         dynargs[2] = args[2];
1522         dynargs[3] = args[3];
1523         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1524     }
1525     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1526         bytes[] memory dynargs = new bytes[](4);
1527         dynargs[0] = args[0];
1528         dynargs[1] = args[1];
1529         dynargs[2] = args[2];
1530         dynargs[3] = args[3];
1531         return oraclize_query(datasource, dynargs, gaslimit);
1532     }
1533     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1534         bytes[] memory dynargs = new bytes[](5);
1535         dynargs[0] = args[0];
1536         dynargs[1] = args[1];
1537         dynargs[2] = args[2];
1538         dynargs[3] = args[3];
1539         dynargs[4] = args[4];
1540         return oraclize_query(datasource, dynargs);
1541     }
1542     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1543         bytes[] memory dynargs = new bytes[](5);
1544         dynargs[0] = args[0];
1545         dynargs[1] = args[1];
1546         dynargs[2] = args[2];
1547         dynargs[3] = args[3];
1548         dynargs[4] = args[4];
1549         return oraclize_query(timestamp, datasource, dynargs);
1550     }
1551     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1552         bytes[] memory dynargs = new bytes[](5);
1553         dynargs[0] = args[0];
1554         dynargs[1] = args[1];
1555         dynargs[2] = args[2];
1556         dynargs[3] = args[3];
1557         dynargs[4] = args[4];
1558         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1559     }
1560     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1561         bytes[] memory dynargs = new bytes[](5);
1562         dynargs[0] = args[0];
1563         dynargs[1] = args[1];
1564         dynargs[2] = args[2];
1565         dynargs[3] = args[3];
1566         dynargs[4] = args[4];
1567         return oraclize_query(datasource, dynargs, gaslimit);
1568     }
1569 
1570     function oraclize_cbAddress() oraclizeAPI internal returns (address){
1571         return oraclize.cbAddress();
1572     }
1573     function oraclize_setProof(byte proofP) oraclizeAPI internal {
1574         return oraclize.setProofType(proofP);
1575     }
1576     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
1577         return oraclize.setCustomGasPrice(gasPrice);
1578     }
1579 
1580     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
1581         return oraclize.randomDS_getSessionPubKeyHash();
1582     }
1583 
1584     function getCodeSize(address _addr) constant internal returns(uint _size) {
1585         assembly {
1586             _size := extcodesize(_addr)
1587         }
1588     }
1589 
1590     function parseAddr(string _a) internal pure returns (address){
1591         bytes memory tmp = bytes(_a);
1592         uint160 iaddr = 0;
1593         uint160 b1;
1594         uint160 b2;
1595         for (uint i=2; i<2+2*20; i+=2){
1596             iaddr *= 256;
1597             b1 = uint160(tmp[i]);
1598             b2 = uint160(tmp[i+1]);
1599             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
1600             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
1601             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
1602             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
1603             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
1604             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
1605             iaddr += (b1*16+b2);
1606         }
1607         return address(iaddr);
1608     }
1609 
1610     function strCompare(string _a, string _b) internal pure returns (int) {
1611         bytes memory a = bytes(_a);
1612         bytes memory b = bytes(_b);
1613         uint minLength = a.length;
1614         if (b.length < minLength) minLength = b.length;
1615         for (uint i = 0; i < minLength; i ++)
1616             if (a[i] < b[i])
1617                 return -1;
1618             else if (a[i] > b[i])
1619                 return 1;
1620         if (a.length < b.length)
1621             return -1;
1622         else if (a.length > b.length)
1623             return 1;
1624         else
1625             return 0;
1626     }
1627 
1628     function indexOf(string _haystack, string _needle) internal pure returns (int) {
1629         bytes memory h = bytes(_haystack);
1630         bytes memory n = bytes(_needle);
1631         if(h.length < 1 || n.length < 1 || (n.length > h.length))
1632             return -1;
1633         else if(h.length > (2**128 -1))
1634             return -1;
1635         else
1636         {
1637             uint subindex = 0;
1638             for (uint i = 0; i < h.length; i ++)
1639             {
1640                 if (h[i] == n[0])
1641                 {
1642                     subindex = 1;
1643                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
1644                     {
1645                         subindex++;
1646                     }
1647                     if(subindex == n.length)
1648                         return int(i);
1649                 }
1650             }
1651             return -1;
1652         }
1653     }
1654 
1655     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
1656         bytes memory _ba = bytes(_a);
1657         bytes memory _bb = bytes(_b);
1658         bytes memory _bc = bytes(_c);
1659         bytes memory _bd = bytes(_d);
1660         bytes memory _be = bytes(_e);
1661         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1662         bytes memory babcde = bytes(abcde);
1663         uint k = 0;
1664         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1665         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1666         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1667         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1668         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1669         return string(babcde);
1670     }
1671 
1672     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
1673         return strConcat(_a, _b, _c, _d, "");
1674     }
1675 
1676     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
1677         return strConcat(_a, _b, _c, "", "");
1678     }
1679 
1680     function strConcat(string _a, string _b) internal pure returns (string) {
1681         return strConcat(_a, _b, "", "", "");
1682     }
1683 
1684     // parseInt
1685     function parseInt(string _a) internal pure returns (uint) {
1686         return parseInt(_a, 0);
1687     }
1688 
1689     // parseInt(parseFloat*10^_b)
1690     function parseInt(string _a, uint _b) internal pure returns (uint) {
1691         bytes memory bresult = bytes(_a);
1692         uint mint = 0;
1693         bool decimals = false;
1694         for (uint i=0; i<bresult.length; i++){
1695             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
1696                 if (decimals){
1697                    if (_b == 0) break;
1698                     else _b--;
1699                 }
1700                 mint *= 10;
1701                 mint += uint(bresult[i]) - 48;
1702             } else if (bresult[i] == 46) decimals = true;
1703         }
1704         if (_b > 0) mint *= 10**_b;
1705         return mint;
1706     }
1707 
1708     function uint2str(uint i) internal pure returns (string){
1709         if (i == 0) return "0";
1710         uint j = i;
1711         uint len;
1712         while (j != 0){
1713             len++;
1714             j /= 10;
1715         }
1716         bytes memory bstr = new bytes(len);
1717         uint k = len - 1;
1718         while (i != 0){
1719             bstr[k--] = byte(48 + i % 10);
1720             i /= 10;
1721         }
1722         return string(bstr);
1723     }
1724 
1725     using CBOR for Buffer.buffer;
1726     function stra2cbor(string[] arr) internal pure returns (bytes) {
1727         safeMemoryCleaner();
1728         Buffer.buffer memory buf;
1729         Buffer.init(buf, 1024);
1730         buf.startArray();
1731         for (uint i = 0; i < arr.length; i++) {
1732             buf.encodeString(arr[i]);
1733         }
1734         buf.endSequence();
1735         return buf.buf;
1736     }
1737 
1738     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
1739         safeMemoryCleaner();
1740         Buffer.buffer memory buf;
1741         Buffer.init(buf, 1024);
1742         buf.startArray();
1743         for (uint i = 0; i < arr.length; i++) {
1744             buf.encodeBytes(arr[i]);
1745         }
1746         buf.endSequence();
1747         return buf.buf;
1748     }
1749 
1750     string oraclize_network_name;
1751     function oraclize_setNetworkName(string _network_name) internal {
1752         oraclize_network_name = _network_name;
1753     }
1754 
1755     function oraclize_getNetworkName() internal view returns (string) {
1756         return oraclize_network_name;
1757     }
1758 
1759     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1760         require((_nbytes > 0) && (_nbytes <= 32));
1761         // Convert from seconds to ledger timer ticks
1762         _delay *= 10;
1763         bytes memory nbytes = new bytes(1);
1764         nbytes[0] = byte(_nbytes);
1765         bytes memory unonce = new bytes(32);
1766         bytes memory sessionKeyHash = new bytes(32);
1767         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1768         assembly {
1769             mstore(unonce, 0x20)
1770             // the following variables can be relaxed
1771             // check relaxed random contract under ethereum-examples repo
1772             // for an idea on how to override and replace comit hash vars
1773             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1774             mstore(sessionKeyHash, 0x20)
1775             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1776         }
1777         bytes memory delay = new bytes(32);
1778         assembly {
1779             mstore(add(delay, 0x20), _delay)
1780         }
1781 
1782         bytes memory delay_bytes8 = new bytes(8);
1783         copyBytes(delay, 24, 8, delay_bytes8, 0);
1784 
1785         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1786         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1787 
1788         bytes memory delay_bytes8_left = new bytes(8);
1789 
1790         assembly {
1791             let x := mload(add(delay_bytes8, 0x20))
1792             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1793             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1794             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1795             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1796             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1797             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1798             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1799             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1800 
1801         }
1802 
1803         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
1804         return queryId;
1805     }
1806 
1807     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1808         oraclize_randomDS_args[queryId] = commitment;
1809     }
1810 
1811     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1812     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1813 
1814     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1815         bool sigok;
1816         address signer;
1817 
1818         bytes32 sigr;
1819         bytes32 sigs;
1820 
1821         bytes memory sigr_ = new bytes(32);
1822         uint offset = 4+(uint(dersig[3]) - 0x20);
1823         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1824         bytes memory sigs_ = new bytes(32);
1825         offset += 32 + 2;
1826         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1827 
1828         assembly {
1829             sigr := mload(add(sigr_, 32))
1830             sigs := mload(add(sigs_, 32))
1831         }
1832 
1833 
1834         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1835         if (address(keccak256(pubkey)) == signer) return true;
1836         else {
1837             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1838             return (address(keccak256(pubkey)) == signer);
1839         }
1840     }
1841 
1842     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1843         bool sigok;
1844 
1845         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1846         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1847         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1848 
1849         bytes memory appkey1_pubkey = new bytes(64);
1850         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1851 
1852         bytes memory tosign2 = new bytes(1+65+32);
1853         tosign2[0] = byte(1); //role
1854         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1855         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1856         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1857         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1858 
1859         if (sigok == false) return false;
1860 
1861 
1862         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1863         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1864 
1865         bytes memory tosign3 = new bytes(1+65);
1866         tosign3[0] = 0xFE;
1867         copyBytes(proof, 3, 65, tosign3, 1);
1868 
1869         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1870         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1871 
1872         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1873 
1874         return sigok;
1875     }
1876 
1877     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1878         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1879         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1880 
1881         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1882         require(proofVerified);
1883 
1884         _;
1885     }
1886 
1887     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1888         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1889         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1890 
1891         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1892         if (proofVerified == false) return 2;
1893 
1894         return 0;
1895     }
1896 
1897     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1898         bool match_ = true;
1899 
1900         require(prefix.length == n_random_bytes);
1901 
1902         for (uint256 i=0; i< n_random_bytes; i++) {
1903             if (content[i] != prefix[i]) match_ = false;
1904         }
1905 
1906         return match_;
1907     }
1908 
1909     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1910 
1911         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1912         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1913         bytes memory keyhash = new bytes(32);
1914         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1915         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1916 
1917         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1918         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1919 
1920         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1921         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1922 
1923         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1924         // This is to verify that the computed args match with the ones specified in the query.
1925         bytes memory commitmentSlice1 = new bytes(8+1+32);
1926         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1927 
1928         bytes memory sessionPubkey = new bytes(64);
1929         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1930         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1931 
1932         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1933         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1934             delete oraclize_randomDS_args[queryId];
1935         } else return false;
1936 
1937 
1938         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1939         bytes memory tosign1 = new bytes(32+8+1+32);
1940         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1941         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1942 
1943         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1944         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1945             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1946         }
1947 
1948         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1949     }
1950 
1951     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1952     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1953         uint minLength = length + toOffset;
1954 
1955         // Buffer too small
1956         require(to.length >= minLength); // Should be a better way?
1957 
1958         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1959         uint i = 32 + fromOffset;
1960         uint j = 32 + toOffset;
1961 
1962         while (i < (32 + fromOffset + length)) {
1963             assembly {
1964                 let tmp := mload(add(from, i))
1965                 mstore(add(to, j), tmp)
1966             }
1967             i += 32;
1968             j += 32;
1969         }
1970 
1971         return to;
1972     }
1973 
1974     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1975     // Duplicate Solidity's ecrecover, but catching the CALL return value
1976     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1977         // We do our own memory management here. Solidity uses memory offset
1978         // 0x40 to store the current end of memory. We write past it (as
1979         // writes are memory extensions), but don't update the offset so
1980         // Solidity will reuse it. The memory used here is only needed for
1981         // this context.
1982 
1983         // FIXME: inline assembly can't access return values
1984         bool ret;
1985         address addr;
1986 
1987         assembly {
1988             let size := mload(0x40)
1989             mstore(size, hash)
1990             mstore(add(size, 32), v)
1991             mstore(add(size, 64), r)
1992             mstore(add(size, 96), s)
1993 
1994             // NOTE: we can reuse the request memory because we deal with
1995             //       the return code
1996             ret := call(3000, 1, 0, size, 128, size, 32)
1997             addr := mload(size)
1998         }
1999 
2000         return (ret, addr);
2001     }
2002 
2003     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
2004     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
2005         bytes32 r;
2006         bytes32 s;
2007         uint8 v;
2008 
2009         if (sig.length != 65)
2010           return (false, 0);
2011 
2012         // The signature format is a compact form of:
2013         //   {bytes32 r}{bytes32 s}{uint8 v}
2014         // Compact means, uint8 is not padded to 32 bytes.
2015         assembly {
2016             r := mload(add(sig, 32))
2017             s := mload(add(sig, 64))
2018 
2019             // Here we are loading the last 32 bytes. We exploit the fact that
2020             // 'mload' will pad with zeroes if we overread.
2021             // There is no 'mload8' to do this, but that would be nicer.
2022             v := byte(0, mload(add(sig, 96)))
2023 
2024             // Alternative solution:
2025             // 'byte' is not working due to the Solidity parser, so lets
2026             // use the second best option, 'and'
2027             // v := and(mload(add(sig, 65)), 255)
2028         }
2029 
2030         // albeit non-transactional signatures are not specified by the YP, one would expect it
2031         // to match the YP range of [27, 28]
2032         //
2033         // geth uses [0, 1] and some clients have followed. This might change, see:
2034         //  https://github.com/ethereum/go-ethereum/issues/2053
2035         if (v < 27)
2036           v += 27;
2037 
2038         if (v != 27 && v != 28)
2039             return (false, 0);
2040 
2041         return safer_ecrecover(hash, v, r, s);
2042     }
2043 
2044     function safeMemoryCleaner() internal pure {
2045         assembly {
2046             let fmem := mload(0x40)
2047             codecopy(fmem, codesize, sub(msize, fmem))
2048         }
2049     }
2050 
2051 }
2052 // </ORACLIZE_API>
2053 
2054 // File: contracts/TokenStrategy.sol
2055 
2056 contract TokenStrategy is usingOraclize {
2057     using SafeMath for uint256;
2058 
2059     uint public minTransactionAmount = 100000000000000000;
2060     uint public tokensAvailableForPresale = 15000000 * 10 ** 18;
2061     uint public tokensAvailableForSale = 15000000 * 10 ** 18;
2062     uint public tokensForUserIncentives = 12000000 * 10 ** 18;
2063     uint public tokensForTeam = 6000000 * 10 ** 18;
2064     uint public tokensForAdvisors = 1000000 * 10 ** 18;
2065     uint public tokensForBounty = 1000000 * 10 ** 18;
2066 
2067     uint public startPublicSale;
2068 
2069     uint public rate;
2070     uint public weiPerCent;
2071     uint256 public goal;
2072     uint256 public goalUSD;
2073 
2074 
2075     address owner;
2076     uint balance;
2077 
2078     uint internal bonusPeriod0;
2079     uint internal bonusPeriod25;
2080     uint internal bonusPeriod50;
2081     uint internal bonusPeriod100;
2082     uint internal bonusPeriod150;
2083     uint internal bonusPeriod200;
2084 
2085     event LogNewOraclizeQuery(string _message);
2086 
2087     constructor(
2088         uint _startPublicSale,
2089         uint _weiPerCent,
2090         uint _rate,
2091         uint _goal,
2092         uint _goalUSD
2093     ) public{
2094         require(_goal > 0);
2095         startPublicSale = _startPublicSale;
2096         weiPerCent = _weiPerCent;
2097         rate = _rate;
2098         goal = _goal;
2099         goalUSD = _goalUSD;
2100         owner = msg.sender;
2101         bonusPeriod0 = startPublicSale.add(15 days);
2102         bonusPeriod25 = startPublicSale.add(12 days);
2103         bonusPeriod50 = startPublicSale.add(9 days);
2104         bonusPeriod100 = startPublicSale.add(6 days);
2105         bonusPeriod150 = startPublicSale.add(3 days);
2106 //        OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
2107         oraclize_setCustomGasPrice(2000000000);
2108     }
2109 
2110     function getPublicSaleBonus() internal view returns (uint) {
2111         if (block.timestamp > bonusPeriod0) {
2112             return 0;
2113         } else if (block.timestamp > bonusPeriod25) {
2114             return 25;
2115         } else if (block.timestamp > bonusPeriod50) {
2116             return 50;
2117         } else if (block.timestamp > bonusPeriod100) {
2118             return 100;
2119         } else if (block.timestamp > bonusPeriod150) {
2120             return 150;
2121         } else {
2122             return 200;
2123         }
2124     }
2125 
2126     function getPresaleBonus(uint _weiAmount) internal view returns (uint){
2127         uint usdAmount = weiToUsd(_weiAmount);
2128         require(usdAmount >= 10000 && usdAmount <= 100000);
2129         if (usdAmount >= 10000 && usdAmount <= 25000) {
2130             return 300;
2131         } else if (usdAmount > 25000 && usdAmount <= 50000) {
2132             return 350;
2133         } else if (usdAmount > 50000) {
2134             return 400;
2135         }
2136     }
2137 
2138     function weiToUsd(uint _amount) internal view returns (uint) {
2139         return _amount / weiPerCent / 100;
2140     }
2141 
2142     function __callback(bytes32 myid, string result) public {
2143         if (msg.sender != oraclize_cbAddress()) revert();
2144         weiPerCent = 1 ether / stringToUint(result, 2);
2145         goal = weiPerCent * 100 * goalUSD;
2146         rate = weiPerCent * 25;
2147         updatePrice();
2148     }
2149 
2150     function updatePrice() public payable {
2151         require(msg.sender == owner || msg.sender == oraclize_cbAddress());
2152         if (oraclize_getPrice("URL") > address(this).balance) {
2153             emit LogNewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
2154         } else {
2155             emit LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
2156             oraclize_query(360, "URL", "json(https://api.gdax.com/products/ETH-USD/ticker).price", 100000);
2157 //            oraclize_query("URL", "json(https://api.gdax.com/products/ETH-USD/ticker).price", 100000);
2158         }
2159     }
2160 
2161     function stringToUint(string _amount, uint _maxCounterAfterDot) internal constant returns (uint result) {
2162         bytes memory b = bytes(_amount);
2163         uint i;
2164         uint counterBeforeDot;
2165         uint counterAfterDot;
2166         result = 0;
2167         uint totNum = b.length;
2168         totNum--;
2169         bool hasDot = false;
2170 
2171         for (i = 0; i < b.length; i++) {
2172             uint c = uint(b[i]);
2173             if (c >= 48 && c <= 57) {
2174                 result = result * 10 + (c - 48);
2175                 counterBeforeDot ++;
2176                 totNum--;
2177             }
2178             if (c == 46) {
2179                 hasDot = true;
2180                 break;
2181             }
2182         }
2183 
2184         if (hasDot) {
2185             for (uint j = counterBeforeDot + 1; j < counterBeforeDot + 1 + _maxCounterAfterDot; j++) {
2186                 uint m = uint(b[j]);
2187 
2188                 if (m >= 48 && m <= 57) {
2189                     result = result * 10 + (m - 48);
2190                     counterAfterDot ++;
2191                     totNum--;
2192                 }
2193 
2194                 if (totNum == 0) {
2195                     break;
2196                 }
2197             }
2198         }
2199         return result;
2200     }
2201 
2202     function getTokenAmount(uint _weiAmount, bool _isPresale) external returns (uint) {
2203         uint tokenAmount = _weiAmount.div(rate) * 1 ether;
2204         uint bonusPercent;
2205         if (_isPresale) {
2206             bonusPercent = getPresaleBonus(_weiAmount);
2207         } else {
2208             bonusPercent = getPublicSaleBonus();
2209         }
2210         if (bonusPercent == 0) {
2211             return tokenAmount;
2212         }
2213         return tokenAmount.add(tokenAmount.mul(bonusPercent).div(1000));
2214     }
2215 
2216     function goalReachedPercent(uint _weiRaised) view public returns (uint) {
2217         return _weiRaised.mul(100).div(goal);
2218     }
2219     function goalReached(uint _weiRaised) public view returns (bool) {
2220         return _weiRaised >= goal;
2221     }
2222 
2223     function() public payable {
2224         balance = balance.add(msg.value);
2225     }
2226 }
2227 
2228 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
2229 
2230 /**
2231  * @title Pausable
2232  * @dev Base contract which allows children to implement an emergency stop mechanism.
2233  */
2234 contract Pausable is Ownable {
2235   event Pause();
2236   event Unpause();
2237 
2238   bool public paused = false;
2239 
2240 
2241   /**
2242    * @dev Modifier to make a function callable only when the contract is not paused.
2243    */
2244   modifier whenNotPaused() {
2245     require(!paused);
2246     _;
2247   }
2248 
2249   /**
2250    * @dev Modifier to make a function callable only when the contract is paused.
2251    */
2252   modifier whenPaused() {
2253     require(paused);
2254     _;
2255   }
2256 
2257   /**
2258    * @dev called by the owner to pause, triggers stopped state
2259    */
2260   function pause() public onlyOwner whenNotPaused {
2261     paused = true;
2262     emit Pause();
2263   }
2264 
2265   /**
2266    * @dev called by the owner to unpause, returns to normal state
2267    */
2268   function unpause() public onlyOwner whenPaused {
2269     paused = false;
2270     emit Unpause();
2271   }
2272 }
2273 
2274 // File: contracts/TeamTokensVault.sol
2275 
2276 contract TeamTokensVault {
2277     address internal teamWallet;
2278     ERC20 internal token;
2279     uint internal tokensPerYear;
2280     uint internal timeAvailableForClaim;
2281 
2282     constructor(address _teamWallet, ERC20 _token, uint _tokensCountPerYear) public{
2283         teamWallet = _teamWallet;
2284         token = ERC20(_token);
2285         tokensPerYear = _tokensCountPerYear;
2286         updateTime();
2287     }
2288 
2289     function claimTokensForTeamWallet() public {
2290         require(token.balanceOf(address(this)) >= tokensPerYear);
2291         require(isAvailableForClaim());
2292         token.transfer(teamWallet, tokensPerYear);
2293     }
2294 
2295     function updateTime() internal {
2296         timeAvailableForClaim = block.timestamp + 365 days;
2297     }
2298 
2299     function isAvailableForClaim() public view returns (bool) {
2300         return block.timestamp >= timeAvailableForClaim;
2301     }
2302 }
2303 
2304 // File: contracts/BtcexCrowdsale.sol
2305 
2306 contract BtcexCrowdsale is FinalizableCrowdsale, Pausable {
2307 
2308     RefundEscrow private escrow;
2309     TokenStrategy tokenStrategy;
2310     address public teamTokensVault;
2311 
2312     uint tokensUsedOnPresale;
2313     uint tokensUsedOnSale;
2314 
2315     address teamWallet;
2316     address advisorWallet;
2317 
2318     constructor(
2319         TokenStrategy _tokenStrategy,
2320         BtcexToken _token,
2321         uint _tokenPrice,
2322         uint _startPreSale,
2323         uint _endSale,
2324         address _ownerWallet,
2325         address _teamWallet,
2326         address _advisorWallet
2327     )
2328     Crowdsale(_tokenPrice, _ownerWallet, _token)
2329     TimedCrowdsale(_startPreSale, _endSale)
2330     public {
2331         tokenStrategy = TokenStrategy(_tokenStrategy);
2332         escrow = new RefundEscrow(wallet);
2333         teamWallet = _teamWallet;
2334         advisorWallet = _advisorWallet;
2335     }
2336 
2337     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal whenNotPaused {
2338         super._preValidatePurchase(_beneficiary, _weiAmount);
2339         require(_weiAmount >= tokenStrategy.minTransactionAmount());
2340     }
2341 
2342     function extendCrowdsaleTime() internal {
2343         closingTime = now + 30 days;
2344     }
2345 
2346     function finalize() public onlyOwner {
2347         require(!isFinalized);
2348         require(hasClosed());
2349         if (shouldFinalize()) {
2350             finalization();
2351             emit Finalized();
2352 
2353             isFinalized = true;
2354         } else {
2355             extendCrowdsaleTime();
2356         }
2357     }
2358 
2359     function shouldFinalize() private view returns (bool) {
2360         if (goalReached() || tokenStrategy.goalReachedPercent(weiRaised) < 80) return true;
2361         return false;
2362     }
2363 
2364     function finalization() internal {
2365         if (goalReached()) {
2366             escrow.close();
2367             escrow.beneficiaryWithdraw();
2368             token.transfer(advisorWallet, tokenStrategy.tokensForAdvisors());
2369             token.transfer(owner, tokenStrategy.tokensForBounty());
2370             token.transfer(owner, tokenStrategy.tokensForUserIncentives());
2371             teamTokensVault = new TeamTokensVault(teamWallet, token, tokenStrategy.tokensForTeam() / 4);
2372             token.transfer(teamTokensVault, tokenStrategy.tokensForTeam());
2373             // unused tokens goes to owner
2374             token.transfer(owner, token.balanceOf(address(this)));
2375         } else {
2376             escrow.enableRefunds();
2377         }
2378     }
2379 
2380     function claimRefund() public {
2381         require(isFinalized);
2382         require(!goalReached());
2383 
2384         escrow.withdraw(msg.sender);
2385     }
2386 
2387     function goalReached() public view returns (bool){
2388         return tokenStrategy.goalReached(weiRaised);
2389     }
2390 
2391     function _forwardFunds() internal {
2392         escrow.deposit.value(msg.value)(msg.sender);
2393     }
2394 
2395     function isPresaleTime() internal view returns (bool) {
2396         return block.timestamp < tokenStrategy.startPublicSale();
2397     }
2398 
2399     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
2400         bool isPresale = isPresaleTime();
2401         uint tokensAmount = tokenStrategy.getTokenAmount(_weiAmount, isPresale);
2402         if (isPresale) {
2403             require(tokensUsedOnPresale.add(tokensAmount) <= tokenStrategy.tokensAvailableForPresale());
2404             tokensUsedOnPresale = tokensUsedOnPresale.add(tokensAmount);
2405         } else {
2406             require(tokensUsedOnSale.add(tokensAmount) <= tokenStrategy.tokensAvailableForSale());
2407             tokensUsedOnSale = tokensUsedOnSale.add(tokensAmount);
2408         }
2409         return tokensAmount;
2410     }
2411 
2412 }