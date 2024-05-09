1 pragma solidity ^0.4.10;
2 
3 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address _who) public view returns (uint256);
13   function transfer(address _to, uint256 _value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: zeppelin-solidity/contracts/math/SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
29     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (_a == 0) {
33       return 0;
34     }
35 
36     c = _a * _b;
37     assert(c / _a == _b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
45     // assert(_b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = _a / _b;
47     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
48     return _a / _b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
55     assert(_b <= _a);
56     return _a - _b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
63     c = _a + _b;
64     assert(c >= _a);
65     return c;
66   }
67 }
68 
69 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) internal balances;
79 
80   uint256 internal totalSupply_;
81 
82   /**
83   * @dev Total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev Transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_value <= balances[msg.sender]);
96     require(_to != address(0));
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
116 
117 /**
118  * @title ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/20
120  */
121 contract ERC20 is ERC20Basic {
122   function allowance(address _owner, address _spender)
123     public view returns (uint256);
124 
125   function transferFrom(address _from, address _to, uint256 _value)
126     public returns (bool);
127 
128   function approve(address _spender, uint256 _value) public returns (bool);
129   event Approval(
130     address indexed owner,
131     address indexed spender,
132     uint256 value
133   );
134 }
135 
136 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * https://github.com/ethereum/EIPs/issues/20
143  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) internal allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(
157     address _from,
158     address _to,
159     uint256 _value
160   )
161     public
162     returns (bool)
163   {
164     require(_value <= balances[_from]);
165     require(_value <= allowed[_from][msg.sender]);
166     require(_to != address(0));
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     emit Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _value) public returns (bool) {
185     allowed[msg.sender][_spender] = _value;
186     emit Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(
197     address _owner,
198     address _spender
199    )
200     public
201     view
202     returns (uint256)
203   {
204     return allowed[_owner][_spender];
205   }
206 
207   /**
208    * @dev Increase the amount of tokens that an owner allowed to a spender.
209    * approve should be called when allowed[_spender] == 0. To increment
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    * @param _spender The address which will spend the funds.
214    * @param _addedValue The amount of tokens to increase the allowance by.
215    */
216   function increaseApproval(
217     address _spender,
218     uint256 _addedValue
219   )
220     public
221     returns (bool)
222   {
223     allowed[msg.sender][_spender] = (
224       allowed[msg.sender][_spender].add(_addedValue));
225     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    * approve should be called when allowed[_spender] == 0. To decrement
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _subtractedValue The amount of tokens to decrease the allowance by.
237    */
238   function decreaseApproval(
239     address _spender,
240     uint256 _subtractedValue
241   )
242     public
243     returns (bool)
244   {
245     uint256 oldValue = allowed[msg.sender][_spender];
246     if (_subtractedValue >= oldValue) {
247       allowed[msg.sender][_spender] = 0;
248     } else {
249       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250     }
251     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255 }
256 
257 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
258 
259 /**
260  * @title Ownable
261  * @dev The Ownable contract has an owner address, and provides basic authorization control
262  * functions, this simplifies the implementation of "user permissions".
263  */
264 contract Ownable {
265   address public owner;
266 
267 
268   event OwnershipRenounced(address indexed previousOwner);
269   event OwnershipTransferred(
270     address indexed previousOwner,
271     address indexed newOwner
272   );
273 
274 
275   /**
276    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
277    * account.
278    */
279   constructor() public {
280     owner = msg.sender;
281   }
282 
283   /**
284    * @dev Throws if called by any account other than the owner.
285    */
286   modifier onlyOwner() {
287     require(msg.sender == owner);
288     _;
289   }
290 
291   /**
292    * @dev Allows the current owner to relinquish control of the contract.
293    * @notice Renouncing to ownership will leave the contract without an owner.
294    * It will not be possible to call the functions with the `onlyOwner`
295    * modifier anymore.
296    */
297   function renounceOwnership() public onlyOwner {
298     emit OwnershipRenounced(owner);
299     owner = address(0);
300   }
301 
302   /**
303    * @dev Allows the current owner to transfer control of the contract to a newOwner.
304    * @param _newOwner The address to transfer ownership to.
305    */
306   function transferOwnership(address _newOwner) public onlyOwner {
307     _transferOwnership(_newOwner);
308   }
309 
310   /**
311    * @dev Transfers control of the contract to a newOwner.
312    * @param _newOwner The address to transfer ownership to.
313    */
314   function _transferOwnership(address _newOwner) internal {
315     require(_newOwner != address(0));
316     emit OwnershipTransferred(owner, _newOwner);
317     owner = _newOwner;
318   }
319 }
320 
321 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
322 
323 /**
324  * @title Mintable token
325  * @dev Simple ERC20 Token example, with mintable token creation
326  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
327  */
328 contract MintableToken is StandardToken, Ownable {
329   event Mint(address indexed to, uint256 amount);
330   event MintFinished();
331 
332   bool public mintingFinished = false;
333 
334 
335   modifier canMint() {
336     require(!mintingFinished);
337     _;
338   }
339 
340   modifier hasMintPermission() {
341     require(msg.sender == owner);
342     _;
343   }
344 
345   /**
346    * @dev Function to mint tokens
347    * @param _to The address that will receive the minted tokens.
348    * @param _amount The amount of tokens to mint.
349    * @return A boolean that indicates if the operation was successful.
350    */
351   function mint(
352     address _to,
353     uint256 _amount
354   )
355     public
356     hasMintPermission
357     canMint
358     returns (bool)
359   {
360     totalSupply_ = totalSupply_.add(_amount);
361     balances[_to] = balances[_to].add(_amount);
362     emit Mint(_to, _amount);
363     emit Transfer(address(0), _to, _amount);
364     return true;
365   }
366 
367   /**
368    * @dev Function to stop minting new tokens.
369    * @return True if the operation was successful.
370    */
371   function finishMinting() public onlyOwner canMint returns (bool) {
372     mintingFinished = true;
373     emit MintFinished();
374     return true;
375   }
376 }
377 
378 // File: contracts/Atisios.sol
379 
380 contract AtisiosToken is MintableToken {
381   string public name = "Atis";
382   string public symbol = "ATIS";
383   uint8 public decimals = 18;
384 }
385 
386 // File: zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
387 
388 /**
389  * @title SafeERC20
390  * @dev Wrappers around ERC20 operations that throw on failure.
391  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
392  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
393  */
394 library SafeERC20 {
395   function safeTransfer(
396     ERC20Basic _token,
397     address _to,
398     uint256 _value
399   )
400     internal
401   {
402     require(_token.transfer(_to, _value));
403   }
404 
405   function safeTransferFrom(
406     ERC20 _token,
407     address _from,
408     address _to,
409     uint256 _value
410   )
411     internal
412   {
413     require(_token.transferFrom(_from, _to, _value));
414   }
415 
416   function safeApprove(
417     ERC20 _token,
418     address _spender,
419     uint256 _value
420   )
421     internal
422   {
423     require(_token.approve(_spender, _value));
424   }
425 }
426 
427 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
428 
429 /**
430  * @title Crowdsale
431  * @dev Crowdsale is a base contract for managing a token crowdsale,
432  * allowing investors to purchase tokens with ether. This contract implements
433  * such functionality in its most fundamental form and can be extended to provide additional
434  * functionality and/or custom behavior.
435  * The external interface represents the basic interface for purchasing tokens, and conform
436  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
437  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
438  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
439  * behavior.
440  */
441 contract Crowdsale {
442   using SafeMath for uint256;
443   using SafeERC20 for ERC20;
444 
445   // The token being sold
446   ERC20 public token;
447 
448   // Address where funds are collected
449   address public wallet;
450 
451   // How many token units a buyer gets per wei.
452   // The rate is the conversion between wei and the smallest and indivisible token unit.
453   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
454   // 1 wei will give you 1 unit, or 0.001 TOK.
455   uint256 public rate;
456 
457   // Amount of wei raised
458   uint256 public weiRaised;
459 
460   /**
461    * Event for token purchase logging
462    * @param purchaser who paid for the tokens
463    * @param beneficiary who got the tokens
464    * @param value weis paid for purchase
465    * @param amount amount of tokens purchased
466    */
467   event TokenPurchase(
468     address indexed purchaser,
469     address indexed beneficiary,
470     uint256 value,
471     uint256 amount
472   );
473 
474   /**
475    * @param _rate Number of token units a buyer gets per wei
476    * @param _wallet Address where collected funds will be forwarded to
477    * @param _token Address of the token being sold
478    */
479   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
480     require(_rate > 0);
481     require(_wallet != address(0));
482     require(_token != address(0));
483 
484     rate = _rate;
485     wallet = _wallet;
486     token = _token;
487   }
488 
489   // -----------------------------------------
490   // Crowdsale external interface
491   // -----------------------------------------
492 
493   /**
494    * @dev fallback function ***DO NOT OVERRIDE***
495    */
496   function () external payable {
497     buyTokens(msg.sender);
498   }
499 
500   /**
501    * @dev low level token purchase ***DO NOT OVERRIDE***
502    * @param _beneficiary Address performing the token purchase
503    */
504   function buyTokens(address _beneficiary) public payable {
505 
506     uint256 weiAmount = msg.value;
507     _preValidatePurchase(_beneficiary, weiAmount);
508 
509     // calculate token amount to be created
510     uint256 tokens = _getTokenAmount(weiAmount);
511 
512     // update state
513     weiRaised = weiRaised.add(weiAmount);
514 
515     _processPurchase(_beneficiary, tokens);
516     emit TokenPurchase(
517       msg.sender,
518       _beneficiary,
519       weiAmount,
520       tokens
521     );
522 
523     _updatePurchasingState(_beneficiary, weiAmount);
524 
525     _forwardFunds();
526     _postValidatePurchase(_beneficiary, weiAmount);
527   }
528 
529   // -----------------------------------------
530   // Internal interface (extensible)
531   // -----------------------------------------
532 
533   /**
534    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
535    * Example from CappedCrowdsale.sol's _preValidatePurchase method: 
536    *   super._preValidatePurchase(_beneficiary, _weiAmount);
537    *   require(weiRaised.add(_weiAmount) <= cap);
538    * @param _beneficiary Address performing the token purchase
539    * @param _weiAmount Value in wei involved in the purchase
540    */
541   function _preValidatePurchase(
542     address _beneficiary,
543     uint256 _weiAmount
544   )
545     internal
546   {
547     require(_beneficiary != address(0));
548     require(_weiAmount != 0);
549   }
550 
551   /**
552    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
553    * @param _beneficiary Address performing the token purchase
554    * @param _weiAmount Value in wei involved in the purchase
555    */
556   function _postValidatePurchase(
557     address _beneficiary,
558     uint256 _weiAmount
559   )
560     internal
561   {
562     // optional override
563   }
564 
565   /**
566    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
567    * @param _beneficiary Address performing the token purchase
568    * @param _tokenAmount Number of tokens to be emitted
569    */
570   function _deliverTokens(
571     address _beneficiary,
572     uint256 _tokenAmount
573   )
574     internal
575   {
576     token.safeTransfer(_beneficiary, _tokenAmount);
577   }
578 
579   /**
580    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
581    * @param _beneficiary Address receiving the tokens
582    * @param _tokenAmount Number of tokens to be purchased
583    */
584   function _processPurchase(
585     address _beneficiary,
586     uint256 _tokenAmount
587   )
588     internal
589   {
590     _deliverTokens(_beneficiary, _tokenAmount);
591   }
592 
593   /**
594    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
595    * @param _beneficiary Address receiving the tokens
596    * @param _weiAmount Value in wei involved in the purchase
597    */
598   function _updatePurchasingState(
599     address _beneficiary,
600     uint256 _weiAmount
601   )
602     internal
603   {
604     // optional override
605   }
606 
607   /**
608    * @dev Override to extend the way in which ether is converted to tokens.
609    * @param _weiAmount Value in wei to be converted into tokens
610    * @return Number of tokens that can be purchased with the specified _weiAmount
611    */
612   function _getTokenAmount(uint256 _weiAmount)
613     internal view returns (uint256)
614   {
615     return _weiAmount.mul(rate);
616   }
617 
618   /**
619    * @dev Determines how ETH is stored/forwarded on purchases.
620    */
621   function _forwardFunds() internal {
622     wallet.transfer(msg.value);
623   }
624 }
625 
626 // File: zeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
627 
628 /**
629  * @title TimedCrowdsale
630  * @dev Crowdsale accepting contributions only within a time frame.
631  */
632 contract TimedCrowdsale is Crowdsale {
633   using SafeMath for uint256;
634 
635   uint256 public openingTime;
636   uint256 public closingTime;
637 
638   /**
639    * @dev Reverts if not in crowdsale time range.
640    */
641   modifier onlyWhileOpen {
642     // solium-disable-next-line security/no-block-members
643     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
644     _;
645   }
646 
647   /**
648    * @dev Constructor, takes crowdsale opening and closing times.
649    * @param _openingTime Crowdsale opening time
650    * @param _closingTime Crowdsale closing time
651    */
652   constructor(uint256 _openingTime, uint256 _closingTime) public {
653     // solium-disable-next-line security/no-block-members
654     require(_openingTime >= block.timestamp);
655     require(_closingTime >= _openingTime);
656 
657     openingTime = _openingTime;
658     closingTime = _closingTime;
659   }
660 
661   /**
662    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
663    * @return Whether crowdsale period has elapsed
664    */
665   function hasClosed() public view returns (bool) {
666     // solium-disable-next-line security/no-block-members
667     return block.timestamp > closingTime;
668   }
669 
670   /**
671    * @dev Extend parent behavior requiring to be within contributing period
672    * @param _beneficiary Token purchaser
673    * @param _weiAmount Amount of wei contributed
674    */
675   function _preValidatePurchase(
676     address _beneficiary,
677     uint256 _weiAmount
678   )
679     internal
680     onlyWhileOpen
681   {
682     super._preValidatePurchase(_beneficiary, _weiAmount);
683   }
684 
685 }
686 
687 // File: zeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol
688 
689 /**
690  * @title FinalizableCrowdsale
691  * @dev Extension of Crowdsale where an owner can do extra work
692  * after finishing.
693  */
694 contract FinalizableCrowdsale is Ownable, TimedCrowdsale {
695   using SafeMath for uint256;
696 
697   bool public isFinalized = false;
698 
699   event Finalized();
700 
701   /**
702    * @dev Must be called after crowdsale ends, to do some extra finalization
703    * work. Calls the contract's finalization function.
704    */
705   function finalize() public onlyOwner {
706     require(!isFinalized);
707     require(hasClosed());
708 
709     finalization();
710     emit Finalized();
711 
712     isFinalized = true;
713   }
714 
715   /**
716    * @dev Can be overridden to add finalization logic. The overriding function
717    * should call super.finalization() to ensure the chain of finalization is
718    * executed entirely.
719    */
720   function finalization() internal {
721   }
722 
723 }
724 
725 // File: zeppelin-solidity/contracts/payment/Escrow.sol
726 
727 /**
728  * @title Escrow
729  * @dev Base escrow contract, holds funds destinated to a payee until they
730  * withdraw them. The contract that uses the escrow as its payment method
731  * should be its owner, and provide public methods redirecting to the escrow's
732  * deposit and withdraw.
733  */
734 contract Escrow is Ownable {
735   using SafeMath for uint256;
736 
737   event Deposited(address indexed payee, uint256 weiAmount);
738   event Withdrawn(address indexed payee, uint256 weiAmount);
739 
740   mapping(address => uint256) private deposits;
741 
742   function depositsOf(address _payee) public view returns (uint256) {
743     return deposits[_payee];
744   }
745 
746   /**
747   * @dev Stores the sent amount as credit to be withdrawn.
748   * @param _payee The destination address of the funds.
749   */
750   function deposit(address _payee) public onlyOwner payable {
751     uint256 amount = msg.value;
752     deposits[_payee] = deposits[_payee].add(amount);
753 
754     emit Deposited(_payee, amount);
755   }
756 
757   /**
758   * @dev Withdraw accumulated balance for a payee.
759   * @param _payee The address whose funds will be withdrawn and transferred to.
760   */
761   function withdraw(address _payee) public onlyOwner {
762     uint256 payment = deposits[_payee];
763     assert(address(this).balance >= payment);
764 
765     deposits[_payee] = 0;
766 
767     _payee.transfer(payment);
768 
769     emit Withdrawn(_payee, payment);
770   }
771 }
772 
773 // File: zeppelin-solidity/contracts/payment/ConditionalEscrow.sol
774 
775 /**
776  * @title ConditionalEscrow
777  * @dev Base abstract escrow to only allow withdrawal if a condition is met.
778  */
779 contract ConditionalEscrow is Escrow {
780   /**
781   * @dev Returns whether an address is allowed to withdraw their funds. To be
782   * implemented by derived contracts.
783   * @param _payee The destination address of the funds.
784   */
785   function withdrawalAllowed(address _payee) public view returns (bool);
786 
787   function withdraw(address _payee) public {
788     require(withdrawalAllowed(_payee));
789     super.withdraw(_payee);
790   }
791 }
792 
793 // File: zeppelin-solidity/contracts/payment/RefundEscrow.sol
794 
795 /**
796  * @title RefundEscrow
797  * @dev Escrow that holds funds for a beneficiary, deposited from multiple parties.
798  * The contract owner may close the deposit period, and allow for either withdrawal
799  * by the beneficiary, or refunds to the depositors.
800  */
801 contract RefundEscrow is Ownable, ConditionalEscrow {
802   enum State { Active, Refunding, Closed }
803 
804   event Closed();
805   event RefundsEnabled();
806 
807   State public state;
808   address public beneficiary;
809 
810   /**
811    * @dev Constructor.
812    * @param _beneficiary The beneficiary of the deposits.
813    */
814   constructor(address _beneficiary) public {
815     require(_beneficiary != address(0));
816     beneficiary = _beneficiary;
817     state = State.Active;
818   }
819 
820   /**
821    * @dev Stores funds that may later be refunded.
822    * @param _refundee The address funds will be sent to if a refund occurs.
823    */
824   function deposit(address _refundee) public payable {
825     require(state == State.Active);
826     super.deposit(_refundee);
827   }
828 
829   /**
830    * @dev Allows for the beneficiary to withdraw their funds, rejecting
831    * further deposits.
832    */
833   function close() public onlyOwner {
834     require(state == State.Active);
835     state = State.Closed;
836     emit Closed();
837   }
838 
839   /**
840    * @dev Allows for refunds to take place, rejecting further deposits.
841    */
842   function enableRefunds() public onlyOwner {
843     require(state == State.Active);
844     state = State.Refunding;
845     emit RefundsEnabled();
846   }
847 
848   /**
849    * @dev Withdraws the beneficiary's funds.
850    */
851   function beneficiaryWithdraw() public {
852     require(state == State.Closed);
853     beneficiary.transfer(address(this).balance);
854   }
855 
856   /**
857    * @dev Returns whether refundees can withdraw their deposits (be refunded).
858    */
859   function withdrawalAllowed(address _payee) public view returns (bool) {
860     return state == State.Refunding;
861   }
862 }
863 
864 // File: zeppelin-solidity/contracts/crowdsale/distribution/RefundableCrowdsale.sol
865 
866 /**
867  * @title RefundableCrowdsale
868  * @dev Extension of Crowdsale contract that adds a funding goal, and
869  * the possibility of users getting a refund if goal is not met.
870  */
871 contract RefundableCrowdsale is FinalizableCrowdsale {
872   using SafeMath for uint256;
873 
874   // minimum amount of funds to be raised in weis
875   uint256 public goal;
876 
877   // refund escrow used to hold funds while crowdsale is running
878   RefundEscrow private escrow;
879 
880   /**
881    * @dev Constructor, creates RefundEscrow.
882    * @param _goal Funding goal
883    */
884   constructor(uint256 _goal) public {
885     require(_goal > 0);
886     escrow = new RefundEscrow(wallet);
887     goal = _goal;
888   }
889 
890   /**
891    * @dev Investors can claim refunds here if crowdsale is unsuccessful
892    */
893   function claimRefund() public {
894     require(isFinalized);
895     require(!goalReached());
896 
897     escrow.withdraw(msg.sender);
898   }
899 
900   /**
901    * @dev Checks whether funding goal was reached.
902    * @return Whether funding goal was reached
903    */
904   function goalReached() public view returns (bool) {
905     return weiRaised >= goal;
906   }
907 
908   /**
909    * @dev escrow finalization task, called when owner calls finalize()
910    */
911   function finalization() internal {
912     if (goalReached()) {
913       escrow.close();
914       escrow.beneficiaryWithdraw();
915     } else {
916       escrow.enableRefunds();
917     }
918 
919     super.finalization();
920   }
921 
922   /**
923    * @dev Overrides Crowdsale fund forwarding, sending funds to escrow.
924    */
925   function _forwardFunds() internal {
926     escrow.deposit.value(msg.value)(msg.sender);
927   }
928 
929 }
930 
931 // File: zeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol
932 
933 /**
934  * @title MintedCrowdsale
935  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
936  * Token ownership should be transferred to MintedCrowdsale for minting.
937  */
938 contract MintedCrowdsale is Crowdsale {
939 
940   /**
941    * @dev Overrides delivery by minting tokens upon purchase.
942    * @param _beneficiary Token purchaser
943    * @param _tokenAmount Number of tokens to be minted
944    */
945   function _deliverTokens(
946     address _beneficiary,
947     uint256 _tokenAmount
948   )
949     internal
950   {
951     // Potentially dangerous assumption about the type of the token.
952     require(MintableToken(address(token)).mint(_beneficiary, _tokenAmount));
953   }
954 }
955 
956 // File: zeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
957 
958 /**
959  * @title CappedCrowdsale
960  * @dev Crowdsale with a limit for total contributions.
961  */
962 contract CappedCrowdsale is Crowdsale {
963   using SafeMath for uint256;
964 
965   uint256 public cap;
966 
967   /**
968    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
969    * @param _cap Max amount of wei to be contributed
970    */
971   constructor(uint256 _cap) public {
972     require(_cap > 0);
973     cap = _cap;
974   }
975 
976   /**
977    * @dev Checks whether the cap has been reached.
978    * @return Whether the cap was reached
979    */
980   function capReached() public view returns (bool) {
981     return weiRaised >= cap;
982   }
983 
984   /**
985    * @dev Extend parent behavior requiring purchase to respect the funding cap.
986    * @param _beneficiary Token purchaser
987    * @param _weiAmount Amount of wei contributed
988    */
989   function _preValidatePurchase(
990     address _beneficiary,
991     uint256 _weiAmount
992   )
993     internal
994   {
995     super._preValidatePurchase(_beneficiary, _weiAmount);
996     require(weiRaised.add(_weiAmount) <= cap);
997   }
998 
999 }
1000 
1001 // File: contracts/ICO.sol
1002 
1003 contract AtisiosICO is CappedCrowdsale, RefundableCrowdsale, MintedCrowdsale {
1004 
1005   // ICO Stage
1006   // ============
1007   enum CrowdsaleStage { PreICO, ICO }
1008   CrowdsaleStage public stage = CrowdsaleStage.PreICO; // By default it's Pre Sale
1009   // =============
1010 
1011   // Token Distribution
1012   // =============================
1013   uint256 public maxTokens = 2000000000000000000000000000; // 2 000 000 000 ATIS (18 decimals)
1014   uint256 public tokensForTeam = 400000000000000000000000000; // 400 000 000 (20% of 2 000 000 000)
1015   uint256 public tokensForBounty = 40000000000000000000000000; // 40 000 000 (2% of 2 000 000 000)
1016   uint256 public totalTokensForSale = 1580000000000000000000000000; // 1 580 000 000 ATIS (18 decimals)
1017   uint256 public totalTokensForSaleDuringPreICO = 200000000000000000000000000; // 200 000 000 / 1 380 000 000
1018   // ==============================
1019 
1020   event EthTransferred(string text);
1021   event EthRefunded(string text);
1022 
1023   constructor(
1024     uint256 _startTime,
1025     uint256 _endTime,
1026     uint256 _rate,
1027     address _wallet,
1028     uint256 _goal,
1029     uint256 _cap
1030   ) TimedCrowdsale(_startTime, _endTime) CappedCrowdsale(_cap) FinalizableCrowdsale() RefundableCrowdsale(_goal) Crowdsale(_rate, _wallet, new AtisiosToken()) public {
1031       require(_goal <= _cap);
1032   }
1033 
1034   function createTokenContract() internal returns (MintableToken) {
1035     return new AtisiosToken(); // Deploys the ERC20 token. Automatically called when crowdsale contract is deployed
1036   }
1037 
1038   // Change Crowdsale Stage. Available Options: PreICO, ICO
1039   function setCrowdsaleStage(uint value) public onlyOwner {
1040 
1041       CrowdsaleStage _stage;
1042 
1043       if (uint(CrowdsaleStage.PreICO) == value) {
1044         _stage = CrowdsaleStage.PreICO;
1045       } else if (uint(CrowdsaleStage.ICO) == value) {
1046         _stage = CrowdsaleStage.ICO;
1047       }
1048 
1049       stage = _stage;
1050 
1051       if (stage == CrowdsaleStage.PreICO) {
1052         setCurrentRate(33333); // 0.00003 ethers per unit (30000000000000 wei)
1053       } else if (stage == CrowdsaleStage.ICO) {
1054         setCurrentRate(12500); // 0.00008 ethers per unit (80000000000000 wei)
1055       }
1056   }
1057 
1058   // Change the current rate
1059   function setCurrentRate(uint256 _rate) private {
1060       rate = _rate;
1061   }
1062 
1063   function () external payable {
1064       uint256 tokensThatWillBeMintedAfterPurchase = msg.value.mul(rate);
1065       if ((stage == CrowdsaleStage.PreICO) && (token.totalSupply() + tokensThatWillBeMintedAfterPurchase > totalTokensForSaleDuringPreICO)) {
1066         msg.sender.transfer(msg.value); // Refund them
1067         emit EthRefunded("PreICO Limit Hit"); // Pre-sale hardcap reached
1068         return;
1069       }
1070 
1071       buyTokens(msg.sender);
1072   }
1073 
1074   function _forwardFunds() internal {
1075       if (stage == CrowdsaleStage.PreICO) {
1076           wallet.transfer(msg.value);
1077           emit EthTransferred("forwarding funds to wallet");
1078       } else if (stage == CrowdsaleStage.ICO) {
1079           emit EthTransferred("forwarding funds to escrow");
1080           super._forwardFunds();
1081       }
1082   }
1083 
1084   // What's unsold is burnt
1085   function finish(address _teamFund, address _bountyFund) public onlyOwner {
1086       require(!isFinalized);
1087 
1088       super._deliverTokens(_teamFund,tokensForTeam);
1089       super._deliverTokens(_bountyFund,tokensForBounty);
1090 
1091       super.finalize();
1092   }
1093 }