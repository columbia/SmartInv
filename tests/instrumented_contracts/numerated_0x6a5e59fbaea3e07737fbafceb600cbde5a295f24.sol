1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (_a == 0) {
17       return 0;
18     }
19 
20     c = _a * _b;
21     assert(c / _a == _b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
29     // assert(_b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = _a / _b;
31     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
32     return _a / _b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
39     assert(_b <= _a);
40     return _a - _b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
47     c = _a + _b;
48     assert(c >= _a);
49     return c;
50   }
51 }
52 
53 
54 
55 /**
56  * @title Ownable
57  * @dev The Ownable contract has an owner address, and provides basic authorization control
58  * functions, this simplifies the implementation of "user permissions".
59  */
60 contract Ownable {
61   address public owner;
62 
63 
64   event OwnershipRenounced(address indexed previousOwner);
65   event OwnershipTransferred(
66     address indexed previousOwner,
67     address indexed newOwner
68   );
69 
70 
71   /**
72    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
73    * account.
74    */
75   constructor() public {
76     owner = msg.sender;
77   }
78 
79   /**
80    * @dev Throws if called by any account other than the owner.
81    */
82   modifier onlyOwner() {
83     require(msg.sender == owner);
84     _;
85   }
86 
87   /**
88    * @dev Allows the current owner to relinquish control of the contract.
89    * @notice Renouncing to ownership will leave the contract without an owner.
90    * It will not be possible to call the functions with the `onlyOwner`
91    * modifier anymore.
92    */
93   function renounceOwnership() public onlyOwner {
94     emit OwnershipRenounced(owner);
95     owner = address(0);
96   }
97 
98   /**
99    * @dev Allows the current owner to transfer control of the contract to a newOwner.
100    * @param _newOwner The address to transfer ownership to.
101    */
102   function transferOwnership(address _newOwner) public onlyOwner {
103     _transferOwnership(_newOwner);
104   }
105 
106   /**
107    * @dev Transfers control of the contract to a newOwner.
108    * @param _newOwner The address to transfer ownership to.
109    */
110   function _transferOwnership(address _newOwner) internal {
111     require(_newOwner != address(0));
112     emit OwnershipTransferred(owner, _newOwner);
113     owner = _newOwner;
114   }
115 }
116 
117 
118 
119 
120 /**
121  * @title ERC20Basic
122  * @dev Simpler version of ERC20 interface
123  * See https://github.com/ethereum/EIPs/issues/179
124  */
125 contract ERC20Basic {
126   function totalSupply() public view returns (uint256);
127   function balanceOf(address _who) public view returns (uint256);
128   function transfer(address _to, uint256 _value) public returns (bool);
129   event Transfer(address indexed from, address indexed to, uint256 value);
130 }
131 
132 
133 
134 /**
135  * @title ERC20 interface
136  * @dev see https://github.com/ethereum/EIPs/issues/20
137  */
138 contract ERC20 is ERC20Basic {
139   function allowance(address _owner, address _spender)
140     public view returns (uint256);
141 
142   function transferFrom(address _from, address _to, uint256 _value)
143     public returns (bool);
144 
145   function approve(address _spender, uint256 _value) public returns (bool);
146   event Approval(
147     address indexed owner,
148     address indexed spender,
149     uint256 value
150   );
151 }
152 
153 
154 
155 /**
156  * @title SafeERC20
157  * @dev Wrappers around ERC20 operations that throw on failure.
158  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
159  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
160  */
161 library SafeERC20 {
162   function safeTransfer(
163     ERC20Basic _token,
164     address _to,
165     uint256 _value
166   )
167     internal
168   {
169     require(_token.transfer(_to, _value));
170   }
171 
172   function safeTransferFrom(
173     ERC20 _token,
174     address _from,
175     address _to,
176     uint256 _value
177   )
178     internal
179   {
180     require(_token.transferFrom(_from, _to, _value));
181   }
182 
183   function safeApprove(
184     ERC20 _token,
185     address _spender,
186     uint256 _value
187   )
188     internal
189   {
190     require(_token.approve(_spender, _value));
191   }
192 }
193 
194 
195 
196 /**
197  * @title Basic token
198  * @dev Basic version of StandardToken, with no allowances.
199  */
200 contract BasicToken is ERC20Basic {
201   using SafeMath for uint256;
202 
203   mapping(address => uint256) internal balances;
204 
205   uint256 internal totalSupply_;
206 
207   /**
208   * @dev Total number of tokens in existence
209   */
210   function totalSupply() public view returns (uint256) {
211     return totalSupply_;
212   }
213 
214   /**
215   * @dev Transfer token for a specified address
216   * @param _to The address to transfer to.
217   * @param _value The amount to be transferred.
218   */
219   function transfer(address _to, uint256 _value) public returns (bool) {
220     require(_value <= balances[msg.sender]);
221     require(_to != address(0));
222 
223     balances[msg.sender] = balances[msg.sender].sub(_value);
224     balances[_to] = balances[_to].add(_value);
225     emit Transfer(msg.sender, _to, _value);
226     return true;
227   }
228 
229   /**
230   * @dev Gets the balance of the specified address.
231   * @param _owner The address to query the the balance of.
232   * @return An uint256 representing the amount owned by the passed address.
233   */
234   function balanceOf(address _owner) public view returns (uint256) {
235     return balances[_owner];
236   }
237 
238 }
239 
240 
241 
242 /**
243  * @title Standard ERC20 token
244  *
245  * @dev Implementation of the basic standard token.
246  * https://github.com/ethereum/EIPs/issues/20
247  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
248  */
249 contract StandardToken is ERC20, BasicToken {
250 
251   mapping (address => mapping (address => uint256)) internal allowed;
252 
253 
254   /**
255    * @dev Transfer tokens from one address to another
256    * @param _from address The address which you want to send tokens from
257    * @param _to address The address which you want to transfer to
258    * @param _value uint256 the amount of tokens to be transferred
259    */
260   function transferFrom(
261     address _from,
262     address _to,
263     uint256 _value
264   )
265     public
266     returns (bool)
267   {
268     require(_value <= balances[_from]);
269     require(_value <= allowed[_from][msg.sender]);
270     require(_to != address(0));
271 
272     balances[_from] = balances[_from].sub(_value);
273     balances[_to] = balances[_to].add(_value);
274     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
275     emit Transfer(_from, _to, _value);
276     return true;
277   }
278 
279   /**
280    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
281    * Beware that changing an allowance with this method brings the risk that someone may use both the old
282    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
283    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
284    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
285    * @param _spender The address which will spend the funds.
286    * @param _value The amount of tokens to be spent.
287    */
288   function approve(address _spender, uint256 _value) public returns (bool) {
289     allowed[msg.sender][_spender] = _value;
290     emit Approval(msg.sender, _spender, _value);
291     return true;
292   }
293 
294   /**
295    * @dev Function to check the amount of tokens that an owner allowed to a spender.
296    * @param _owner address The address which owns the funds.
297    * @param _spender address The address which will spend the funds.
298    * @return A uint256 specifying the amount of tokens still available for the spender.
299    */
300   function allowance(
301     address _owner,
302     address _spender
303    )
304     public
305     view
306     returns (uint256)
307   {
308     return allowed[_owner][_spender];
309   }
310 
311   /**
312    * @dev Increase the amount of tokens that an owner allowed to a spender.
313    * approve should be called when allowed[_spender] == 0. To increment
314    * allowed value is better to use this function to avoid 2 calls (and wait until
315    * the first transaction is mined)
316    * From MonolithDAO Token.sol
317    * @param _spender The address which will spend the funds.
318    * @param _addedValue The amount of tokens to increase the allowance by.
319    */
320   function increaseApproval(
321     address _spender,
322     uint256 _addedValue
323   )
324     public
325     returns (bool)
326   {
327     allowed[msg.sender][_spender] = (
328       allowed[msg.sender][_spender].add(_addedValue));
329     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
330     return true;
331   }
332 
333   /**
334    * @dev Decrease the amount of tokens that an owner allowed to a spender.
335    * approve should be called when allowed[_spender] == 0. To decrement
336    * allowed value is better to use this function to avoid 2 calls (and wait until
337    * the first transaction is mined)
338    * From MonolithDAO Token.sol
339    * @param _spender The address which will spend the funds.
340    * @param _subtractedValue The amount of tokens to decrease the allowance by.
341    */
342   function decreaseApproval(
343     address _spender,
344     uint256 _subtractedValue
345   )
346     public
347     returns (bool)
348   {
349     uint256 oldValue = allowed[msg.sender][_spender];
350     if (_subtractedValue >= oldValue) {
351       allowed[msg.sender][_spender] = 0;
352     } else {
353       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
354     }
355     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
356     return true;
357   }
358 
359 }
360 
361 
362 
363 /**
364  * @title Mintable token
365  * @dev Simple ERC20 Token example, with mintable token creation
366  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
367  */
368 contract MintableToken is StandardToken, Ownable {
369   event Mint(address indexed to, uint256 amount);
370   event MintFinished();
371 
372   bool public mintingFinished = false;
373 
374 
375   modifier canMint() {
376     require(!mintingFinished);
377     _;
378   }
379 
380   modifier hasMintPermission() {
381     require(msg.sender == owner);
382     _;
383   }
384 
385   /**
386    * @dev Function to mint tokens
387    * @param _to The address that will receive the minted tokens.
388    * @param _amount The amount of tokens to mint.
389    * @return A boolean that indicates if the operation was successful.
390    */
391   function mint(
392     address _to,
393     uint256 _amount
394   )
395     public
396     hasMintPermission
397     canMint
398     returns (bool)
399   {
400     totalSupply_ = totalSupply_.add(_amount);
401     balances[_to] = balances[_to].add(_amount);
402     emit Mint(_to, _amount);
403     emit Transfer(address(0), _to, _amount);
404     return true;
405   }
406 
407   /**
408    * @dev Function to stop minting new tokens.
409    * @return True if the operation was successful.
410    */
411   function finishMinting() public onlyOwner canMint returns (bool) {
412     mintingFinished = true;
413     emit MintFinished();
414     return true;
415   }
416 }
417 
418 
419 
420 
421 /**
422  * @title Crowdsale
423  * @dev Crowdsale is a base contract for managing a token crowdsale,
424  * allowing investors to purchase tokens with ether. This contract implements
425  * such functionality in its most fundamental form and can be extended to provide additional
426  * functionality and/or custom behavior.
427  * The external interface represents the basic interface for purchasing tokens, and conform
428  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
429  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
430  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
431  * behavior.
432  */
433 contract Crowdsale {
434   using SafeMath for uint256;
435   using SafeERC20 for ERC20;
436 
437   // The token being sold
438   ERC20 public token;
439 
440   // Address where funds are collected
441   address public wallet;
442 
443   // How many token units a buyer gets per wei.
444   // The rate is the conversion between wei and the smallest and indivisible token unit.
445   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
446   // 1 wei will give you 1 unit, or 0.001 TOK.
447   uint256 public rate;
448 
449   // Amount of wei raised
450   uint256 public weiRaised;
451 
452   /**
453    * Event for token purchase logging
454    * @param purchaser who paid for the tokens
455    * @param beneficiary who got the tokens
456    * @param value weis paid for purchase
457    * @param amount amount of tokens purchased
458    */
459   event TokenPurchase(
460     address indexed purchaser,
461     address indexed beneficiary,
462     uint256 value,
463     uint256 amount
464   );
465 
466   /**
467    * @param _rate Number of token units a buyer gets per wei
468    * @param _wallet Address where collected funds will be forwarded to
469    * @param _token Address of the token being sold
470    */
471   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
472     require(_rate > 0);
473     require(_wallet != address(0));
474     require(_token != address(0));
475 
476     rate = _rate;
477     wallet = _wallet;
478     token = _token;
479   }
480 
481   // -----------------------------------------
482   // Crowdsale external interface
483   // -----------------------------------------
484 
485   /**
486    * @dev fallback function ***DO NOT OVERRIDE***
487    */
488   function () external payable {
489     buyTokens(msg.sender);
490   }
491 
492   /**
493    * @dev low level token purchase ***DO NOT OVERRIDE***
494    * @param _beneficiary Address performing the token purchase
495    */
496   function buyTokens(address _beneficiary) public payable {
497 
498     uint256 weiAmount = msg.value;
499     _preValidatePurchase(_beneficiary, weiAmount);
500 
501     // calculate token amount to be created
502     uint256 tokens = _getTokenAmount(weiAmount);
503 
504     // update state
505     weiRaised = weiRaised.add(weiAmount);
506 
507     _processPurchase(_beneficiary, tokens);
508     emit TokenPurchase(
509       msg.sender,
510       _beneficiary,
511       weiAmount,
512       tokens
513     );
514 
515     _updatePurchasingState(_beneficiary, weiAmount);
516 
517     _forwardFunds();
518     _postValidatePurchase(_beneficiary, weiAmount);
519   }
520 
521   // -----------------------------------------
522   // Internal interface (extensible)
523   // -----------------------------------------
524 
525   /**
526    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
527    * Example from CappedCrowdsale.sol's _preValidatePurchase method: 
528    *   super._preValidatePurchase(_beneficiary, _weiAmount);
529    *   require(weiRaised.add(_weiAmount) <= cap);
530    * @param _beneficiary Address performing the token purchase
531    * @param _weiAmount Value in wei involved in the purchase
532    */
533   function _preValidatePurchase(
534     address _beneficiary,
535     uint256 _weiAmount
536   )
537     internal
538   {
539     require(_beneficiary != address(0));
540     require(_weiAmount != 0);
541   }
542 
543   /**
544    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
545    * @param _beneficiary Address performing the token purchase
546    * @param _weiAmount Value in wei involved in the purchase
547    */
548   function _postValidatePurchase(
549     address _beneficiary,
550     uint256 _weiAmount
551   )
552     internal
553   {
554     // optional override
555   }
556 
557   /**
558    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
559    * @param _beneficiary Address performing the token purchase
560    * @param _tokenAmount Number of tokens to be emitted
561    */
562   function _deliverTokens(
563     address _beneficiary,
564     uint256 _tokenAmount
565   )
566     internal
567   {
568     token.safeTransfer(_beneficiary, _tokenAmount);
569   }
570 
571   /**
572    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
573    * @param _beneficiary Address receiving the tokens
574    * @param _tokenAmount Number of tokens to be purchased
575    */
576   function _processPurchase(
577     address _beneficiary,
578     uint256 _tokenAmount
579   )
580     internal
581   {
582     _deliverTokens(_beneficiary, _tokenAmount);
583   }
584 
585   /**
586    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
587    * @param _beneficiary Address receiving the tokens
588    * @param _weiAmount Value in wei involved in the purchase
589    */
590   function _updatePurchasingState(
591     address _beneficiary,
592     uint256 _weiAmount
593   )
594     internal
595   {
596     // optional override
597   }
598 
599   /**
600    * @dev Override to extend the way in which ether is converted to tokens.
601    * @param _weiAmount Value in wei to be converted into tokens
602    * @return Number of tokens that can be purchased with the specified _weiAmount
603    */
604   function _getTokenAmount(uint256 _weiAmount)
605     internal view returns (uint256)
606   {
607     return _weiAmount.mul(rate);
608   }
609 
610   /**
611    * @dev Determines how ETH is stored/forwarded on purchases.
612    */
613   function _forwardFunds() internal {
614     wallet.transfer(msg.value);
615   }
616 }
617 
618 
619 
620 /**
621  * @title MintedCrowdsale
622  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
623  * Token ownership should be transferred to MintedCrowdsale for minting.
624  */
625 contract MintedCrowdsale is Crowdsale {
626 
627   /**
628    * @dev Overrides delivery by minting tokens upon purchase.
629    * @param _beneficiary Token purchaser
630    * @param _tokenAmount Number of tokens to be minted
631    */
632   function _deliverTokens(
633     address _beneficiary,
634     uint256 _tokenAmount
635   )
636     internal
637   {
638     // Potentially dangerous assumption about the type of the token.
639     require(MintableToken(address(token)).mint(_beneficiary, _tokenAmount));
640   }
641 }
642 
643 
644 
645 /**
646  * @title TimedCrowdsale
647  * @dev Crowdsale accepting contributions only within a time frame.
648  */
649 contract TimedCrowdsale is Crowdsale {
650   using SafeMath for uint256;
651 
652   uint256 public openingTime;
653   uint256 public closingTime;
654 
655   /**
656    * @dev Reverts if not in crowdsale time range.
657    */
658   modifier onlyWhileOpen {
659     // solium-disable-next-line security/no-block-members
660     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
661     _;
662   }
663 
664   /**
665    * @dev Constructor, takes crowdsale opening and closing times.
666    * @param _openingTime Crowdsale opening time
667    * @param _closingTime Crowdsale closing time
668    */
669   constructor(uint256 _openingTime, uint256 _closingTime) public {
670     // solium-disable-next-line security/no-block-members
671     require(_openingTime >= block.timestamp);
672     require(_closingTime >= _openingTime);
673 
674     openingTime = _openingTime;
675     closingTime = _closingTime;
676   }
677 
678   /**
679    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
680    * @return Whether crowdsale period has elapsed
681    */
682   function hasClosed() public view returns (bool) {
683     // solium-disable-next-line security/no-block-members
684     return block.timestamp > closingTime;
685   }
686 
687   /**
688    * @dev Extend parent behavior requiring to be within contributing period
689    * @param _beneficiary Token purchaser
690    * @param _weiAmount Amount of wei contributed
691    */
692   function _preValidatePurchase(
693     address _beneficiary,
694     uint256 _weiAmount
695   )
696     internal
697     onlyWhileOpen
698   {
699     super._preValidatePurchase(_beneficiary, _weiAmount);
700   }
701 
702 }
703 
704 
705 
706 /**
707  * @title FinalizableCrowdsale
708  * @dev Extension of Crowdsale where an owner can do extra work
709  * after finishing.
710  */
711 contract FinalizableCrowdsale is Ownable, TimedCrowdsale {
712   using SafeMath for uint256;
713 
714   bool public isFinalized = false;
715 
716   event Finalized();
717 
718   /**
719    * @dev Must be called after crowdsale ends, to do some extra finalization
720    * work. Calls the contract's finalization function.
721    */
722   function finalize() public onlyOwner {
723     require(!isFinalized);
724     require(hasClosed());
725 
726     finalization();
727     emit Finalized();
728 
729     isFinalized = true;
730   }
731 
732   /**
733    * @dev Can be overridden to add finalization logic. The overriding function
734    * should call super.finalization() to ensure the chain of finalization is
735    * executed entirely.
736    */
737   function finalization() internal {
738   }
739 
740 }
741 
742 
743 
744 /**
745  * @title Escrow
746  * @dev Base escrow contract, holds funds destinated to a payee until they
747  * withdraw them. The contract that uses the escrow as its payment method
748  * should be its owner, and provide public methods redirecting to the escrow's
749  * deposit and withdraw.
750  */
751 contract Escrow is Ownable {
752   using SafeMath for uint256;
753 
754   event Deposited(address indexed payee, uint256 weiAmount);
755   event Withdrawn(address indexed payee, uint256 weiAmount);
756 
757   mapping(address => uint256) private deposits;
758 
759   function depositsOf(address _payee) public view returns (uint256) {
760     return deposits[_payee];
761   }
762 
763   /**
764   * @dev Stores the sent amount as credit to be withdrawn.
765   * @param _payee The destination address of the funds.
766   */
767   function deposit(address _payee) public onlyOwner payable {
768     uint256 amount = msg.value;
769     deposits[_payee] = deposits[_payee].add(amount);
770 
771     emit Deposited(_payee, amount);
772   }
773 
774   /**
775   * @dev Withdraw accumulated balance for a payee.
776   * @param _payee The address whose funds will be withdrawn and transferred to.
777   */
778   function withdraw(address _payee) public onlyOwner {
779     uint256 payment = deposits[_payee];
780     assert(address(this).balance >= payment);
781 
782     deposits[_payee] = 0;
783 
784     _payee.transfer(payment);
785 
786     emit Withdrawn(_payee, payment);
787   }
788 }
789 
790 
791 
792 /**
793  * @title ConditionalEscrow
794  * @dev Base abstract escrow to only allow withdrawal if a condition is met.
795  */
796 contract ConditionalEscrow is Escrow {
797   /**
798   * @dev Returns whether an address is allowed to withdraw their funds. To be
799   * implemented by derived contracts.
800   * @param _payee The destination address of the funds.
801   */
802   function withdrawalAllowed(address _payee) public view returns (bool);
803 
804   function withdraw(address _payee) public {
805     require(withdrawalAllowed(_payee));
806     super.withdraw(_payee);
807   }
808 }
809 
810 
811 
812 
813 /**
814  * @title RefundEscrow
815  * @dev Escrow that holds funds for a beneficiary, deposited from multiple parties.
816  * The contract owner may close the deposit period, and allow for either withdrawal
817  * by the beneficiary, or refunds to the depositors.
818  */
819 contract RefundEscrow is Ownable, ConditionalEscrow {
820   enum State { Active, Refunding, Closed }
821 
822   event Closed();
823   event RefundsEnabled();
824 
825   State public state;
826   address public beneficiary;
827 
828   /**
829    * @dev Constructor.
830    * @param _beneficiary The beneficiary of the deposits.
831    */
832   constructor(address _beneficiary) public {
833     require(_beneficiary != address(0));
834     beneficiary = _beneficiary;
835     state = State.Active;
836   }
837 
838   /**
839    * @dev Stores funds that may later be refunded.
840    * @param _refundee The address funds will be sent to if a refund occurs.
841    */
842   function deposit(address _refundee) public payable {
843     require(state == State.Active);
844     super.deposit(_refundee);
845   }
846 
847   /**
848    * @dev Allows for the beneficiary to withdraw their funds, rejecting
849    * further deposits.
850    */
851   function close() public onlyOwner {
852     require(state == State.Active);
853     state = State.Closed;
854     emit Closed();
855   }
856 
857   /**
858    * @dev Allows for refunds to take place, rejecting further deposits.
859    */
860   function enableRefunds() public onlyOwner {
861     require(state == State.Active);
862     state = State.Refunding;
863     emit RefundsEnabled();
864   }
865 
866   /**
867    * @dev Withdraws the beneficiary's funds.
868    */
869   function beneficiaryWithdraw() public {
870     require(state == State.Closed);
871     beneficiary.transfer(address(this).balance);
872   }
873 
874   /**
875    * @dev Returns whether refundees can withdraw their deposits (be refunded).
876    */
877   function withdrawalAllowed(address _payee) public view returns (bool) {
878     return state == State.Refunding;
879   }
880 }
881 
882 
883 
884 /**
885  * @title RefundableCrowdsale
886  * @dev Extension of Crowdsale contract that adds a funding goal, and
887  * the possibility of users getting a refund if goal is not met.
888  */
889 contract RefundableCrowdsale is FinalizableCrowdsale {
890   using SafeMath for uint256;
891 
892   // minimum amount of funds to be raised in weis
893   uint256 public goal;
894 
895   // refund escrow used to hold funds while crowdsale is running
896   RefundEscrow private escrow;
897 
898   /**
899    * @dev Constructor, creates RefundEscrow.
900    * @param _goal Funding goal
901    */
902   constructor(uint256 _goal) public {
903     require(_goal > 0);
904     escrow = new RefundEscrow(wallet);
905     goal = _goal;
906   }
907 
908   /**
909    * @dev Investors can claim refunds here if crowdsale is unsuccessful
910    */
911   function claimRefund() public {
912     require(isFinalized);
913     require(!goalReached());
914 
915     escrow.withdraw(msg.sender);
916   }
917 
918   /**
919    * @dev Checks whether funding goal was reached.
920    * @return Whether funding goal was reached
921    */
922   function goalReached() public view returns (bool) {
923     return weiRaised >= goal;
924   }
925 
926   /**
927    * @dev escrow finalization task, called when owner calls finalize()
928    */
929   function finalization() internal {
930     if (goalReached()) {
931       escrow.close();
932       escrow.beneficiaryWithdraw();
933     } else {
934       escrow.enableRefunds();
935     }
936 
937     super.finalization();
938   }
939 
940   /**
941    * @dev Overrides Crowdsale fund forwarding, sending funds to escrow.
942    */
943   function _forwardFunds() internal {
944     escrow.deposit.value(msg.value)(msg.sender);
945   }
946 
947 }
948 
949 
950 
951 /**
952  * @title KHDonCrowdsale
953  * @dev Very simple crowdsale contract for the mintable KHDon token with the following extensions:
954  * RefundableCrowdsale - set a min goal to be reached and returns funds if it's not met
955  * MintedCrowdsale - tokens are minted in each purchase. 
956  */
957 
958  
959 contract KHDonCrowdsale is Crowdsale, TimedCrowdsale, RefundableCrowdsale, MintedCrowdsale {
960         constructor(
961             uint256 _rate,
962             address _wallet,
963             ERC20 _token,
964             uint256 _openingTime,
965             uint256 _closingTime,
966             uint256 _goal
967         )
968             Crowdsale(_rate, _wallet, _token)
969             TimedCrowdsale(_openingTime, _closingTime)
970             RefundableCrowdsale(_goal)
971             public
972     {
973 
974     }
975 }