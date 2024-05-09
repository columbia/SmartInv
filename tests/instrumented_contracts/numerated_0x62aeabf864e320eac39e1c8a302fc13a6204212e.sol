1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * See https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender)
21     public view returns (uint256);
22 
23   function transferFrom(address from, address to, uint256 value)
24     public returns (bool);
25 
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(
28     address indexed owner,
29     address indexed spender,
30     uint256 value
31   );
32 }
33 library SafeMath {
34 
35   /**
36   * @dev Multiplies two numbers, throws on overflow.
37   */
38   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
39     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
40     // benefit is lost if 'b' is also tested.
41     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
42     if (a == 0) {
43       return 0;
44     }
45 
46     c = a * b;
47     assert(c / a == b);
48     return c;
49   }
50 
51   /**
52   * @dev Integer division of two numbers, truncating the quotient.
53   */
54   function div(uint256 a, uint256 b) internal pure returns (uint256) {
55     // assert(b > 0); // Solidity automatically throws when dividing by 0
56     // uint256 c = a / b;
57     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58     return a / b;
59   }
60 
61   /**
62   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
63   */
64   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65     assert(b <= a);
66     return a - b;
67   }
68 
69   /**
70   * @dev Adds two numbers, throws on overflow.
71   */
72   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
73     c = a + b;
74     assert(c >= a);
75     return c;
76   }
77 }
78 /**
79  * @title SafeERC20
80  * @dev Wrappers around ERC20 operations that throw on failure.
81  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
82  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
83  */
84 library SafeERC20 {
85   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
86     require(token.transfer(to, value));
87   }
88 
89   function safeTransferFrom(
90     ERC20 token,
91     address from,
92     address to,
93     uint256 value
94   )
95     internal
96   {
97     require(token.transferFrom(from, to, value));
98   }
99 
100   function safeApprove(ERC20 token, address spender, uint256 value) internal {
101     require(token.approve(spender, value));
102   }
103 }
104 /**
105  * @title Crowdsale
106  * @dev Crowdsale is a base contract for managing a token crowdsale,
107  * allowing investors to purchase tokens with ether. This contract implements
108  * such functionality in its most fundamental form and can be extended to provide additional
109  * functionality and/or custom behavior.
110  * The external interface represents the basic interface for purchasing tokens, and conform
111  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
112  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
113  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
114  * behavior.
115  */
116 contract Crowdsale {
117   using SafeMath for uint256;
118   using SafeERC20 for ERC20;
119 
120   // The token being sold
121   ERC20 public token;
122 
123   // Address where funds are collected
124   address public wallet;
125 
126   // How many token units a buyer gets per wei.
127   // The rate is the conversion between wei and the smallest and indivisible token unit.
128   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
129   // 1 wei will give you 1 unit, or 0.001 TOK.
130   uint256 public rate;
131 
132   // Amount of wei raised
133   uint256 public weiRaised;
134 
135   /**
136    * Event for token purchase logging
137    * @param purchaser who paid for the tokens
138    * @param beneficiary who got the tokens
139    * @param value weis paid for purchase
140    * @param amount amount of tokens purchased
141    */
142   event TokenPurchase(
143     address indexed purchaser,
144     address indexed beneficiary,
145     uint256 value,
146     uint256 amount
147   );
148 
149   /**
150    * @param _rate Number of token units a buyer gets per wei
151    * @param _wallet Address where collected funds will be forwarded to
152    * @param _token Address of the token being sold
153    */
154   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
155     require(_rate > 0);
156     require(_wallet != address(0));
157     require(_token != address(0));
158 
159     rate = _rate;
160     wallet = _wallet;
161     token = _token;
162   }
163 
164   // -----------------------------------------
165   // Crowdsale external interface
166   // -----------------------------------------
167 
168   /**
169    * @dev fallback function ***DO NOT OVERRIDE***
170    */
171   function () external payable {
172     buyTokens(msg.sender);
173   }
174 
175   /**
176    * @dev low level token purchase ***DO NOT OVERRIDE***
177    * @param _beneficiary Address performing the token purchase
178    */
179   function buyTokens(address _beneficiary) public payable {
180 
181     uint256 weiAmount = msg.value;
182     _preValidatePurchase(_beneficiary, weiAmount);
183 
184     // calculate token amount to be created
185     uint256 tokens = _getTokenAmount(weiAmount);
186 
187     // update state
188     weiRaised = weiRaised.add(weiAmount);
189 
190     _processPurchase(_beneficiary, tokens);
191     emit TokenPurchase(
192       msg.sender,
193       _beneficiary,
194       weiAmount,
195       tokens
196     );
197 
198     _updatePurchasingState(_beneficiary, weiAmount);
199 
200     _forwardFunds();
201     _postValidatePurchase(_beneficiary, weiAmount);
202   }
203 
204   // -----------------------------------------
205   // Internal interface (extensible)
206   // -----------------------------------------
207 
208   /**
209    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
210    * @param _beneficiary Address performing the token purchase
211    * @param _weiAmount Value in wei involved in the purchase
212    */
213   function _preValidatePurchase(
214     address _beneficiary,
215     uint256 _weiAmount
216   )
217     internal
218   {
219     require(_beneficiary != address(0));
220     require(_weiAmount != 0);
221   }
222 
223   /**
224    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
225    * @param _beneficiary Address performing the token purchase
226    * @param _weiAmount Value in wei involved in the purchase
227    */
228   function _postValidatePurchase(
229     address _beneficiary,
230     uint256 _weiAmount
231   )
232     internal
233   {
234     // optional override
235   }
236 
237   /**
238    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
239    * @param _beneficiary Address performing the token purchase
240    * @param _tokenAmount Number of tokens to be emitted
241    */
242   function _deliverTokens(
243     address _beneficiary,
244     uint256 _tokenAmount
245   )
246     internal
247   {
248     token.safeTransfer(_beneficiary, _tokenAmount);
249   }
250 
251   /**
252    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
253    * @param _beneficiary Address receiving the tokens
254    * @param _tokenAmount Number of tokens to be purchased
255    */
256   function _processPurchase(
257     address _beneficiary,
258     uint256 _tokenAmount
259   )
260     internal
261   {
262     _deliverTokens(_beneficiary, _tokenAmount);
263   }
264 
265   /**
266    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
267    * @param _beneficiary Address receiving the tokens
268    * @param _weiAmount Value in wei involved in the purchase
269    */
270   function _updatePurchasingState(
271     address _beneficiary,
272     uint256 _weiAmount
273   )
274     internal
275   {
276     // optional override
277   }
278 
279   /**
280    * @dev Override to extend the way in which ether is converted to tokens.
281    * @param _weiAmount Value in wei to be converted into tokens
282    * @return Number of tokens that can be purchased with the specified _weiAmount
283    */
284   function _getTokenAmount(uint256 _weiAmount)
285     internal view returns (uint256)
286   {
287     return _weiAmount.mul(rate);
288   }
289 
290   /**
291    * @dev Determines how ETH is stored/forwarded on purchases.
292    */
293   function _forwardFunds() internal {
294     wallet.transfer(msg.value);
295   }
296 }
297 /**
298  * @title CappedCrowdsale
299  * @dev Crowdsale with a limit for total contributions.
300  */
301 contract CappedCrowdsale is Crowdsale {
302   using SafeMath for uint256;
303 
304   uint256 public cap;
305 
306   /**
307    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
308    * @param _cap Max amount of wei to be contributed
309    */
310   constructor(uint256 _cap) public {
311     require(_cap > 0);
312     cap = _cap;
313   }
314 
315   /**
316    * @dev Checks whether the cap has been reached.
317    * @return Whether the cap was reached
318    */
319   function capReached() public view returns (bool) {
320     return weiRaised >= cap;
321   }
322 
323   /**
324    * @dev Extend parent behavior requiring purchase to respect the funding cap.
325    * @param _beneficiary Token purchaser
326    * @param _weiAmount Amount of wei contributed
327    */
328   function _preValidatePurchase(
329     address _beneficiary,
330     uint256 _weiAmount
331   )
332     internal
333   {
334     super._preValidatePurchase(_beneficiary, _weiAmount);
335     require(weiRaised.add(_weiAmount) <= cap);
336   }
337 }
338 /**
339  * @title TimedCrowdsale
340  * @dev Crowdsale accepting contributions only within a time frame.
341  */
342 contract TimedCrowdsale is Crowdsale {
343   using SafeMath for uint256;
344 
345   uint256 public openingTime;
346   uint256 public closingTime;
347 
348   /**
349    * @dev Reverts if not in crowdsale time range.
350    */
351   modifier onlyWhileOpen {
352     // solium-disable-next-line security/no-block-members
353     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
354     _;
355   }
356 
357   /**
358    * @dev Constructor, takes crowdsale opening and closing times.
359    * @param _openingTime Crowdsale opening time
360    * @param _closingTime Crowdsale closing time
361    */
362   constructor(uint256 _openingTime, uint256 _closingTime) public {
363     // solium-disable-next-line security/no-block-members
364     require(_openingTime >= block.timestamp);
365     require(_closingTime >= _openingTime);
366 
367     openingTime = _openingTime;
368     closingTime = _closingTime;
369   }
370 
371   /**
372    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
373    * @return Whether crowdsale period has elapsed
374    */
375   function hasClosed() public view returns (bool) {
376     // solium-disable-next-line security/no-block-members
377     return block.timestamp > closingTime;
378   }
379 
380   /**
381    * @dev Extend parent behavior requiring to be within contributing period
382    * @param _beneficiary Token purchaser
383    * @param _weiAmount Amount of wei contributed
384    */
385   function _preValidatePurchase(
386     address _beneficiary,
387     uint256 _weiAmount
388   )
389     internal
390     onlyWhileOpen
391   {
392     super._preValidatePurchase(_beneficiary, _weiAmount);
393   }
394 }
395 /**
396  * @title Ownable
397  * @dev The Ownable contract has an owner address, and provides basic authorization control
398  * functions, this simplifies the implementation of "user permissions".
399  */
400 contract Ownable {
401   address public owner;
402 
403 
404   event OwnershipRenounced(address indexed previousOwner);
405   event OwnershipTransferred(
406     address indexed previousOwner,
407     address indexed newOwner
408   );
409 
410 
411   /**
412    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
413    * account.
414    */
415   constructor() public {
416     owner = msg.sender;
417   }
418 
419   /**
420    * @dev Throws if called by any account other than the owner.
421    */
422   modifier onlyOwner() {
423     require(msg.sender == owner);
424     _;
425   }
426 
427   /**
428    * @dev Allows the current owner to relinquish control of the contract.
429    * @notice Renouncing to ownership will leave the contract without an owner.
430    * It will not be possible to call the functions with the `onlyOwner`
431    * modifier anymore.
432    */
433   function renounceOwnership() public onlyOwner {
434     emit OwnershipRenounced(owner);
435     owner = address(0);
436   }
437 
438   /**
439    * @dev Allows the current owner to transfer control of the contract to a newOwner.
440    * @param _newOwner The address to transfer ownership to.
441    */
442   function transferOwnership(address _newOwner) public onlyOwner {
443     _transferOwnership(_newOwner);
444   }
445 
446   /**
447    * @dev Transfers control of the contract to a newOwner.
448    * @param _newOwner The address to transfer ownership to.
449    */
450   function _transferOwnership(address _newOwner) internal {
451     require(_newOwner != address(0));
452     emit OwnershipTransferred(owner, _newOwner);
453     owner = _newOwner;
454   }
455 }
456 /**
457  * @title FinalizableCrowdsale
458  * @dev Extension of Crowdsale where an owner can do extra work
459  * after finishing.
460  */
461 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
462   using SafeMath for uint256;
463 
464   bool public isFinalized = false;
465 
466   event Finalized();
467 
468   /**
469    * @dev Must be called after crowdsale ends, to do some extra finalization
470    * work. Calls the contract's finalization function.
471    */
472   function finalize() onlyOwner public {
473     require(!isFinalized);
474     require(hasClosed());
475 
476     finalization();
477     emit Finalized();
478 
479     isFinalized = true;
480   }
481 
482   /**
483    * @dev Can be overridden to add finalization logic. The overriding function
484    * should call super.finalization() to ensure the chain of finalization is
485    * executed entirely.
486    */
487   function finalization() internal {}
488 
489 }
490 /**
491  * @title Escrow
492  * @dev Base escrow contract, holds funds destinated to a payee until they
493  * withdraw them. The contract that uses the escrow as its payment method
494  * should be its owner, and provide public methods redirecting to the escrow's
495  * deposit and withdraw.
496  */
497 contract Escrow is Ownable {
498   using SafeMath for uint256;
499 
500   event Deposited(address indexed payee, uint256 weiAmount);
501   event Withdrawn(address indexed payee, uint256 weiAmount);
502 
503   mapping(address => uint256) private deposits;
504 
505   function depositsOf(address _payee) public view returns (uint256) {
506     return deposits[_payee];
507   }
508 
509   /**
510   * @dev Stores the sent amount as credit to be withdrawn.
511   * @param _payee The destination address of the funds.
512   */
513   function deposit(address _payee) public onlyOwner payable {
514     uint256 amount = msg.value;
515     deposits[_payee] = deposits[_payee].add(amount);
516 
517     emit Deposited(_payee, amount);
518   }
519 
520   /**
521   * @dev Withdraw accumulated balance for a payee.
522   * @param _payee The address whose funds will be withdrawn and transferred to.
523   */
524   function withdraw(address _payee) public onlyOwner {
525     uint256 payment = deposits[_payee];
526     assert(address(this).balance >= payment);
527 
528     deposits[_payee] = 0;
529 
530     _payee.transfer(payment);
531 
532     emit Withdrawn(_payee, payment);
533   }
534 }
535 /**
536  * @title ConditionalEscrow
537  * @dev Base abstract escrow to only allow withdrawal if a condition is met.
538  */
539 contract ConditionalEscrow is Escrow {
540   /**
541   * @dev Returns whether an address is allowed to withdraw their funds. To be
542   * implemented by derived contracts.
543   * @param _payee The destination address of the funds.
544   */
545   function withdrawalAllowed(address _payee) public view returns (bool);
546 
547   function withdraw(address _payee) public {
548     require(withdrawalAllowed(_payee));
549     super.withdraw(_payee);
550   }
551 }
552 
553 /**
554  * @title RefundEscrow
555  * @dev Escrow that holds funds for a beneficiary, deposited from multiple parties.
556  * The contract owner may close the deposit period, and allow for either withdrawal
557  * by the beneficiary, or refunds to the depositors.
558  */
559 contract RefundEscrow is Ownable, ConditionalEscrow {
560   enum State { Active, Refunding, Closed }
561 
562   event Closed();
563   event RefundsEnabled();
564 
565   State public state;
566   address public beneficiary;
567 
568   /**
569    * @dev Constructor.
570    * @param _beneficiary The beneficiary of the deposits.
571    */
572   constructor(address _beneficiary) public {
573     require(_beneficiary != address(0));
574     beneficiary = _beneficiary;
575     state = State.Active;
576   }
577 
578   /**
579    * @dev Stores funds that may later be refunded.
580    * @param _refundee The address funds will be sent to if a refund occurs.
581    */
582   function deposit(address _refundee) public payable {
583     require(state == State.Active);
584     super.deposit(_refundee);
585   }
586 
587   /**
588    * @dev Allows for the beneficiary to withdraw their funds, rejecting
589    * further deposits.
590    */
591   function close() public onlyOwner {
592     require(state == State.Active);
593     state = State.Closed;
594     emit Closed();
595   }
596 
597   /**
598    * @dev Allows for refunds to take place, rejecting further deposits.
599    */
600   function enableRefunds() public onlyOwner {
601     require(state == State.Active);
602     state = State.Refunding;
603     emit RefundsEnabled();
604   }
605 
606   /**
607    * @dev Withdraws the beneficiary's funds.
608    */
609   function beneficiaryWithdraw() public {
610     require(state == State.Closed);
611     beneficiary.transfer(address(this).balance);
612   }
613 
614   /**
615    * @dev Returns whether refundees can withdraw their deposits (be refunded).
616    */
617   function withdrawalAllowed(address _payee) public view returns (bool) {
618     return state == State.Refunding;
619   }
620 }
621 /**
622  * @title RefundableCrowdsale
623  * @dev Extension of Crowdsale contract that adds a funding goal, and
624  * the possibility of users getting a refund if goal is not met.
625  */
626 contract RefundableCrowdsale is FinalizableCrowdsale {
627   using SafeMath for uint256;
628 
629   // minimum amount of funds to be raised in weis
630   uint256 public goal;
631 
632   // refund escrow used to hold funds while crowdsale is running
633   RefundEscrow private escrow;
634 
635   /**
636    * @dev Constructor, creates RefundEscrow.
637    * @param _goal Funding goal
638    */
639   constructor(uint256 _goal) public {
640     require(_goal > 0);
641     escrow = new RefundEscrow(wallet);
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
652     escrow.withdraw(msg.sender);
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
664    * @dev escrow finalization task, called when owner calls finalize()
665    */
666   function finalization() internal {
667     if (goalReached()) {
668       escrow.close();
669       escrow.beneficiaryWithdraw();
670     } else {
671       escrow.enableRefunds();
672     }
673 
674     super.finalization();
675   }
676 
677   /**
678    * @dev Overrides Crowdsale fund forwarding, sending funds to escrow.
679    */
680   function _forwardFunds() internal {
681     escrow.deposit.value(msg.value)(msg.sender);
682   }
683 }
684 /**
685  * @title AllowanceCrowdsale
686  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
687  */
688 contract AllowanceCrowdsale is Crowdsale {
689   using SafeMath for uint256;
690   using SafeERC20 for ERC20;
691 
692   address public tokenWallet;
693 
694   /**
695    * @dev Constructor, takes token wallet address.
696    * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
697    */
698   constructor(address _tokenWallet) public {
699     require(_tokenWallet != address(0));
700     tokenWallet = _tokenWallet;
701   }
702 
703   /**
704    * @dev Checks the amount of tokens left in the allowance.
705    * @return Amount of tokens left in the allowance
706    */
707   function remainingTokens() public view returns (uint256) {
708     return token.allowance(tokenWallet, this);
709   }
710 
711   /**
712    * @dev Overrides parent behavior by transferring tokens from wallet.
713    * @param _beneficiary Token purchaser
714    * @param _tokenAmount Amount of tokens purchased
715    */
716   function _deliverTokens(
717     address _beneficiary,
718     uint256 _tokenAmount
719   )
720     internal
721   {
722     token.safeTransferFrom(tokenWallet, _beneficiary, _tokenAmount);
723   }
724 }/**
725  * @title Basic token
726  * @dev Basic version of StandardToken, with no allowances.
727  */
728 contract BasicToken is ERC20Basic {
729   using SafeMath for uint256;
730 
731   mapping(address => uint256) balances;
732 
733   uint256 totalSupply_;
734 
735   /**
736   * @dev Total number of tokens in existence
737   */
738   function totalSupply() public view returns (uint256) {
739     return totalSupply_;
740   }
741 
742   /**
743   * @dev Transfer token for a specified address
744   * @param _to The address to transfer to.
745   * @param _value The amount to be transferred.
746   */
747   function transfer(address _to, uint256 _value) public returns (bool) {
748     require(_to != address(0));
749     require(_value <= balances[msg.sender]);
750 
751     balances[msg.sender] = balances[msg.sender].sub(_value);
752     balances[_to] = balances[_to].add(_value);
753     emit Transfer(msg.sender, _to, _value);
754     return true;
755   }
756 
757   /**
758   * @dev Gets the balance of the specified address.
759   * @param _owner The address to query the the balance of.
760   * @return An uint256 representing the amount owned by the passed address.
761   */
762   function balanceOf(address _owner) public view returns (uint256) {
763     return balances[_owner];
764   }
765 }
766 /**
767  * @title Burnable Token
768  * @dev Token that can be irreversibly burned (destroyed).
769  */
770 contract BurnableToken is BasicToken {
771 
772   event Burn(address indexed burner, uint256 value);
773 
774   /**
775    * @dev Burns a specific amount of tokens.
776    * @param _value The amount of token to be burned.
777    */
778   function burn(uint256 _value) public {
779     _burn(msg.sender, _value);
780   }
781 
782   function _burn(address _who, uint256 _value) internal {
783     require(_value <= balances[_who]);
784     // no need to require value <= totalSupply, since that would imply the
785     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
786 
787     balances[_who] = balances[_who].sub(_value);
788     totalSupply_ = totalSupply_.sub(_value);
789     emit Burn(_who, _value);
790     emit Transfer(_who, address(0), _value);
791   }
792 }
793 /**
794  * @title Standard ERC20 token
795  *
796  * @dev Implementation of the basic standard token.
797  * https://github.com/ethereum/EIPs/issues/20
798  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
799  */
800 contract StandardToken is ERC20, BasicToken {
801 
802   mapping (address => mapping (address => uint256)) internal allowed;
803 
804 
805   /**
806    * @dev Transfer tokens from one address to another
807    * @param _from address The address which you want to send tokens from
808    * @param _to address The address which you want to transfer to
809    * @param _value uint256 the amount of tokens to be transferred
810    */
811   function transferFrom(
812     address _from,
813     address _to,
814     uint256 _value
815   )
816     public
817     returns (bool)
818   {
819     require(_to != address(0));
820     require(_value <= balances[_from]);
821     require(_value <= allowed[_from][msg.sender]);
822 
823     balances[_from] = balances[_from].sub(_value);
824     balances[_to] = balances[_to].add(_value);
825     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
826     emit Transfer(_from, _to, _value);
827     return true;
828   }
829 
830   /**
831    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
832    * Beware that changing an allowance with this method brings the risk that someone may use both the old
833    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
834    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
835    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
836    * @param _spender The address which will spend the funds.
837    * @param _value The amount of tokens to be spent.
838    */
839   function approve(address _spender, uint256 _value) public returns (bool) {
840     allowed[msg.sender][_spender] = _value;
841     emit Approval(msg.sender, _spender, _value);
842     return true;
843   }
844 
845   /**
846    * @dev Function to check the amount of tokens that an owner allowed to a spender.
847    * @param _owner address The address which owns the funds.
848    * @param _spender address The address which will spend the funds.
849    * @return A uint256 specifying the amount of tokens still available for the spender.
850    */
851   function allowance(
852     address _owner,
853     address _spender
854    )
855     public
856     view
857     returns (uint256)
858   {
859     return allowed[_owner][_spender];
860   }
861 
862   /**
863    * @dev Increase the amount of tokens that an owner allowed to a spender.
864    * approve should be called when allowed[_spender] == 0. To increment
865    * allowed value is better to use this function to avoid 2 calls (and wait until
866    * the first transaction is mined)
867    * From MonolithDAO Token.sol
868    * @param _spender The address which will spend the funds.
869    * @param _addedValue The amount of tokens to increase the allowance by.
870    */
871   function increaseApproval(
872     address _spender,
873     uint256 _addedValue
874   )
875     public
876     returns (bool)
877   {
878     allowed[msg.sender][_spender] = (
879       allowed[msg.sender][_spender].add(_addedValue));
880     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
881     return true;
882   }
883 
884   /**
885    * @dev Decrease the amount of tokens that an owner allowed to a spender.
886    * approve should be called when allowed[_spender] == 0. To decrement
887    * allowed value is better to use this function to avoid 2 calls (and wait until
888    * the first transaction is mined)
889    * From MonolithDAO Token.sol
890    * @param _spender The address which will spend the funds.
891    * @param _subtractedValue The amount of tokens to decrease the allowance by.
892    */
893   function decreaseApproval(
894     address _spender,
895     uint256 _subtractedValue
896   )
897     public
898     returns (bool)
899   {
900     uint256 oldValue = allowed[msg.sender][_spender];
901     if (_subtractedValue > oldValue) {
902       allowed[msg.sender][_spender] = 0;
903     } else {
904       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
905     }
906     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
907     return true;
908   }
909 
910 }
911 /**
912  * @title Standard Burnable Token
913  * @dev Adds burnFrom method to ERC20 implementations
914  */
915 contract StandardBurnableToken is BurnableToken, StandardToken {
916 
917   /**
918    * @dev Burns a specific amount of tokens from the target address and decrements allowance
919    * @param _from address The address which you want to send tokens from
920    * @param _value uint256 The amount of token to be burned
921    */
922   function burnFrom(address _from, uint256 _value) public {
923     require(_value <= allowed[_from][msg.sender]);
924     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
925     // this function needs to emit an event with the updated approval.
926     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
927     _burn(_from, _value);
928   }
929 }
930 /**
931  * @title TezaCrowdsale
932  * @dev This is an example of a fully fledged crowdsale.
933  * The way to add new features to a base crowdsale is by multiple inheritance.
934  * In this example we are providing following extensions:
935  * CappedCrowdsale - sets a max boundary for raised funds
936  * RefundableCrowdsale - set a min goal to be reached and returns funds if it's not met
937  *
938  * After adding multiple features it's good practice to run integration tests
939  * to ensure that subcontracts works together as intended.
940  */
941 // XXX There doesn't seem to be a way to split this line that keeps solium
942 // happy. See:
943 // https://github.com/duaraghav8/Solium/issues/205
944 // --elopio - 2018-05-10
945 // solium-disable-next-line max-len
946 contract TezaCrowdsale is CappedCrowdsale, RefundableCrowdsale, AllowanceCrowdsale {
947 
948     //mapping (address => uint256) internal referrers
949     mapping (address => uint256) public referrers;
950     
951     uint internal constant REFERRER_PERCENT = 10;
952     
953     modifier whenNotPaused() {
954         require((block.timestamp >= openingTime && block.timestamp <= openingTime + (40 days)) || (block.timestamp >= openingTime + (80 days) && block.timestamp < closingTime));
955         _;
956     }
957 
958     constructor(
959         uint256 _openingTime,
960         uint256 _closingTime,
961         uint256 _rate,
962         address _wallet,
963         uint256 _cap,
964         StandardBurnableToken _token,
965         uint256 _goal
966     )
967     public
968     Crowdsale(_rate, _wallet, _token)
969     CappedCrowdsale(_cap)
970     TimedCrowdsale(_openingTime, _closingTime)
971     RefundableCrowdsale(_goal)
972     AllowanceCrowdsale(_wallet)
973     {
974         //As goal needs to be met for a successful crowdsale
975         //the value needs to less or equal than a cap which is limit for accepted funds
976         require(_goal <= _cap);
977         require(_rate > 0);
978     }
979     
980     function bytesToAddres(bytes source) internal pure returns(address) {
981         uint result;
982         uint mul = 1;
983         for(uint i = 20; i > 0; i--) {
984             result += uint8(source[i-1])*mul;
985             mul = mul*256;
986         }
987         return address(result);
988     }
989     
990     /**
991      * @dev Extend parent behavior requiring beneficiary to be in whitelist.
992      * @param _beneficiary Token beneficiary
993      * @param _weiAmount Amount of wei contributed
994      */
995     function _preValidatePurchase(
996         address _beneficiary,
997         uint256 _weiAmount
998     )
999     internal
1000     whenNotPaused
1001     {
1002         super._preValidatePurchase(_beneficiary, _weiAmount);
1003         
1004         if(block.timestamp <= openingTime + (18 days)) {
1005             rate = 2000;
1006         }else if(block.timestamp > openingTime + (18 days) && block.timestamp <= openingTime + (37 days)) {
1007             rate = weiRaised <= 4000000000000000000000000 ? 1428 : 1250;
1008         }else if(block.timestamp >= openingTime + (77 days) && block.timestamp <= openingTime + (108 days)) {
1009             rate = weiRaised >= 50000000000000000000000000 ? 1000 : 1111;
1010         }else{
1011             rate = 2000;
1012         }
1013     }
1014 
1015     function referrerBonus(address _referrer) public view returns (uint256) {
1016         require(goalReached());
1017         return referrers[_referrer];
1018     }
1019 
1020     function _forwardFunds() internal
1021     {
1022         // referer bonus
1023         if(msg.data.length == 20) {
1024             address referrerAddress = bytesToAddres(bytes(msg.data));
1025             require(referrerAddress != address(token) && referrerAddress != msg.sender);
1026             uint256 referrerAmount = msg.value.mul(REFERRER_PERCENT).div(100);
1027             referrers[referrerAddress] = referrers[referrerAddress].add(referrerAmount);
1028         }
1029     }
1030 }