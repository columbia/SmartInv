1 pragma solidity ^0.4.24;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender)
12     public view returns (uint256);
13 
14   function transferFrom(address from, address to, uint256 value)
15     public returns (bool);
16 
17   function approve(address spender, uint256 value) public returns (bool);
18   event Approval(
19     address indexed owner,
20     address indexed spender,
21     uint256 value
22   );
23 }
24 
25 library SafeERC20 {
26   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
27     require(token.transfer(to, value));
28   }
29 
30   function safeTransferFrom(
31     ERC20 token,
32     address from,
33     address to,
34     uint256 value
35   )
36     internal
37   {
38     require(token.transferFrom(from, to, value));
39   }
40 
41   function safeApprove(ERC20 token, address spender, uint256 value) internal {
42     require(token.approve(spender, value));
43   }
44 }
45 
46 
47 library SafeMath {
48 
49   /**
50   * @dev Multiplies two numbers, throws on overflow.
51   */
52   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
53     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
54     // benefit is lost if 'b' is also tested.
55     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
56     if (a == 0) {
57       return 0;
58     }
59 
60     c = a * b;
61     assert(c / a == b);
62     return c;
63   }
64 
65   /**
66   * @dev Integer division of two numbers, truncating the quotient.
67   */
68   function div(uint256 a, uint256 b) internal pure returns (uint256) {
69     // assert(b > 0); // Solidity automatically throws when dividing by 0
70     // uint256 c = a / b;
71     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72     return a / b;
73   }
74 
75   /**
76   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
77   */
78   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79     assert(b <= a);
80     return a - b;
81   }
82 
83   /**
84   * @dev Adds two numbers, throws on overflow.
85   */
86   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
87     c = a + b;
88     assert(c >= a);
89     return c;
90   }
91 }
92 
93 contract Crowdsale {
94   using SafeMath for uint256;
95   using SafeERC20 for ERC20;
96 
97   // The token being sold
98   ERC20 public token;
99 
100   // Address where funds are collected
101   address public wallet;
102 
103   // How many token units a buyer gets per wei.
104   // The rate is the conversion between wei and the smallest and indivisible token unit.
105   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
106   // 1 wei will give you 1 unit, or 0.001 TOK.
107   uint256 public rate;
108 
109   // Amount of wei raised
110   uint256 public weiRaised;
111 
112   /**
113    * Event for token purchase logging
114    * @param purchaser who paid for the tokens
115    * @param beneficiary who got the tokens
116    * @param value weis paid for purchase
117    * @param amount amount of tokens purchased
118    */
119   event TokenPurchase(
120     address indexed purchaser,
121     address indexed beneficiary,
122     uint256 value,
123     uint256 amount
124   );
125 
126   /**
127    * @param _rate Number of token units a buyer gets per wei
128    * @param _wallet Address where collected funds will be forwarded to
129    * @param _token Address of the token being sold
130    */
131   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
132     require(_rate > 0);
133     require(_wallet != address(0));
134     require(_token != address(0));
135 
136     rate = _rate;
137     wallet = _wallet;
138     token = _token;
139   }
140 
141   // -----------------------------------------
142   // Crowdsale external interface
143   // -----------------------------------------
144 
145   /**
146    * @dev fallback function ***DO NOT OVERRIDE***
147    */
148   function () external payable {
149     buyTokens(msg.sender);
150   }
151 
152   /**
153    * @dev low level token purchase ***DO NOT OVERRIDE***
154    * @param _beneficiary Address performing the token purchase
155    */
156   function buyTokens(address _beneficiary) public payable {
157 
158     uint256 weiAmount = msg.value;
159     _preValidatePurchase(_beneficiary, weiAmount);
160 
161     // calculate token amount to be created
162     uint256 tokens = _getTokenAmount(weiAmount);
163 
164     // update state
165     weiRaised = weiRaised.add(weiAmount);
166 
167     _processPurchase(_beneficiary, tokens);
168     emit TokenPurchase(
169       msg.sender,
170       _beneficiary,
171       weiAmount,
172       tokens
173     );
174 
175     _updatePurchasingState(_beneficiary, weiAmount);
176 
177     _forwardFunds();
178     _postValidatePurchase(_beneficiary, weiAmount);
179   }
180 
181   // -----------------------------------------
182   // Internal interface (extensible)
183   // -----------------------------------------
184 
185   /**
186    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
187    * @param _beneficiary Address performing the token purchase
188    * @param _weiAmount Value in wei involved in the purchase
189    */
190   function _preValidatePurchase(
191     address _beneficiary,
192     uint256 _weiAmount
193   )
194     internal
195   {
196     require(_beneficiary != address(0));
197     require(_weiAmount != 0);
198   }
199 
200   /**
201    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
202    * @param _beneficiary Address performing the token purchase
203    * @param _weiAmount Value in wei involved in the purchase
204    */
205   function _postValidatePurchase(
206     address _beneficiary,
207     uint256 _weiAmount
208   )
209     internal
210   {
211     // optional override
212   }
213 
214   /**
215    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
216    * @param _beneficiary Address performing the token purchase
217    * @param _tokenAmount Number of tokens to be emitted
218    */
219   function _deliverTokens(
220     address _beneficiary,
221     uint256 _tokenAmount
222   )
223     internal
224   {
225     token.safeTransfer(_beneficiary, _tokenAmount);
226   }
227 
228   /**
229    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
230    * @param _beneficiary Address receiving the tokens
231    * @param _tokenAmount Number of tokens to be purchased
232    */
233   function _processPurchase(
234     address _beneficiary,
235     uint256 _tokenAmount
236   )
237     internal
238   {
239     _deliverTokens(_beneficiary, _tokenAmount);
240   }
241 
242   /**
243    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
244    * @param _beneficiary Address receiving the tokens
245    * @param _weiAmount Value in wei involved in the purchase
246    */
247   function _updatePurchasingState(
248     address _beneficiary,
249     uint256 _weiAmount
250   )
251     internal
252   {
253     // optional override
254   }
255 
256   /**
257    * @dev Override to extend the way in which ether is converted to tokens.
258    * @param _weiAmount Value in wei to be converted into tokens
259    * @return Number of tokens that can be purchased with the specified _weiAmount
260    */
261   function _getTokenAmount(uint256 _weiAmount)
262     internal view returns (uint256)
263   {
264     return _weiAmount.mul(rate);
265   }
266 
267   /**
268    * @dev Determines how ETH is stored/forwarded on purchases.
269    */
270   function _forwardFunds() internal {
271     wallet.transfer(msg.value);
272   }
273 }
274 
275 contract TimedCrowdsale is Crowdsale {
276   using SafeMath for uint256;
277 
278   uint256 public openingTime;
279   uint256 public closingTime;
280 
281   /**
282    * @dev Reverts if not in crowdsale time range.
283    */
284   modifier onlyWhileOpen {
285     // solium-disable-next-line security/no-block-members
286     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
287     _;
288   }
289 
290   /**
291    * @dev Constructor, takes crowdsale opening and closing times.
292    * @param _openingTime Crowdsale opening time
293    * @param _closingTime Crowdsale closing time
294    */
295   constructor(uint256 _openingTime, uint256 _closingTime) public {
296     // solium-disable-next-line security/no-block-members
297     require(_openingTime >= block.timestamp);
298     require(_closingTime >= _openingTime);
299 
300     openingTime = _openingTime;
301     closingTime = _closingTime;
302   }
303 
304   /**
305    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
306    * @return Whether crowdsale period has elapsed
307    */
308   function hasClosed() public view returns (bool) {
309     // solium-disable-next-line security/no-block-members
310     return block.timestamp > closingTime;
311   }
312 
313   /**
314    * @dev Extend parent behavior requiring to be within contributing period
315    * @param _beneficiary Token purchaser
316    * @param _weiAmount Amount of wei contributed
317    */
318   function _preValidatePurchase(
319     address _beneficiary,
320     uint256 _weiAmount
321   )
322     internal
323     onlyWhileOpen
324   {
325     super._preValidatePurchase(_beneficiary, _weiAmount);
326   }
327 
328 }
329 
330 contract Ownable {
331   address public owner;
332 
333 
334   event OwnershipRenounced(address indexed previousOwner);
335   event OwnershipTransferred(
336     address indexed previousOwner,
337     address indexed newOwner
338   );
339 
340 
341   /**
342    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
343    * account.
344    */
345   constructor() public {
346     owner = msg.sender;
347   }
348 
349   /**
350    * @dev Throws if called by any account other than the owner.
351    */
352   modifier onlyOwner() {
353     require(msg.sender == owner);
354     _;
355   }
356 
357   /**
358    * @dev Allows the current owner to relinquish control of the contract.
359    * @notice Renouncing to ownership will leave the contract without an owner.
360    * It will not be possible to call the functions with the `onlyOwner`
361    * modifier anymore.
362    */
363   function renounceOwnership() public onlyOwner {
364     emit OwnershipRenounced(owner);
365     owner = address(0);
366   }
367 
368   /**
369    * @dev Allows the current owner to transfer control of the contract to a newOwner.
370    * @param _newOwner The address to transfer ownership to.
371    */
372   function transferOwnership(address _newOwner) public onlyOwner {
373     _transferOwnership(_newOwner);
374   }
375 
376   /**
377    * @dev Transfers control of the contract to a newOwner.
378    * @param _newOwner The address to transfer ownership to.
379    */
380   function _transferOwnership(address _newOwner) internal {
381     require(_newOwner != address(0));
382     emit OwnershipTransferred(owner, _newOwner);
383     owner = _newOwner;
384   }
385 }
386 
387 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
388   using SafeMath for uint256;
389 
390   bool public isFinalized = false;
391 
392   event Finalized();
393 
394   /**
395    * @dev Must be called after crowdsale ends, to do some extra finalization
396    * work. Calls the contract's finalization function.
397    */
398   function finalize() onlyOwner public {
399     require(!isFinalized);
400     require(hasClosed());
401 
402     finalization();
403     emit Finalized();
404 
405     isFinalized = true;
406   }
407 
408   /**
409    * @dev Can be overridden to add finalization logic. The overriding function
410    * should call super.finalization() to ensure the chain of finalization is
411    * executed entirely.
412    */
413   function finalization() internal {
414   }
415 
416 }
417 
418 contract PostDeliveryCrowdsale is TimedCrowdsale, FinalizableCrowdsale {
419   using SafeMath for uint256;
420 
421   mapping(address => uint256) public balances;
422   uint256 public totalTokensSold = 0;
423   uint256 private hardCap;
424 
425   /**
426    * @param _hardCap hard cap in tokens
427    */
428   constructor (uint256 _hardCap) public {
429     hardCap = _hardCap;
430   }
431 
432   function balanceOf (address _address) public view returns (uint256) {
433     return balances[_address];
434   }
435 
436   /**
437    * @dev Withdraw tokens only after crowdsale ends and crowdsale is finalized.
438    */
439   function withdrawTokens() public {
440     require(hasClosed());
441     require(isFinalized);
442     uint256 amount = balances[msg.sender];
443     require(amount > 0);
444     balances[msg.sender] = 0;
445     _deliverTokens(msg.sender, amount);
446   }
447 
448   /**
449    * @dev Overrides parent by storing balances instead of issuing tokens right away.
450    * @param _beneficiary Token purchaser
451    * @param _tokenAmount Amount of tokens purchased
452    */
453   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
454     require(totalTokensSold.add(_tokenAmount) <= hardCap);
455     totalTokensSold.add(_tokenAmount);
456     balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);
457   }
458 }
459 
460 contract RefundableBeforeSoftCapCrowdsale is Ownable, FinalizableCrowdsale {
461   using SafeMath for uint256;
462 
463   // minimum amount of funds to be raised in weis
464   uint256 public goal;
465 
466   // refund escrow used to hold funds while crowdsale is running
467   // AfterSoftCapEscrow private escrow;
468   AfterSoftCapEscrow private escrow;
469 
470   /**
471    * @dev Constructor, creates RefundEscrow.
472    * @param _goal Funding goal
473    */
474   constructor(uint256 _goal) public {
475     require(_goal > 0);
476     escrow = new AfterSoftCapEscrow(wallet, rate);
477     goal = _goal;
478   }
479 
480   /**
481    * @dev Investors can claim refunds here if crowdsale is unsuccessful
482    */
483   function claimRefund() public {
484     require(isFinalized);
485     require(!goalReached());
486 
487     escrow.withdraw(msg.sender);
488   }
489 
490   /**
491    * @dev Checks escrow wallet balance
492    */
493   function escrowBalance() public view returns (uint256) {
494     return address(escrow).balance;
495   }
496 
497   /**
498    * @dev Checks whether funding goal was reached.
499    * @return Whether funding goal was reached
500    */
501   function goalReached() public view returns (bool) {
502     return weiRaised >= goal;
503   }
504   
505   function updateEscrowGoalReached() onlyOwner public {
506     require(!isFinalized);
507     require(goalReached());
508 
509     escrow.reachGoal();
510   }
511 
512   function beneficiaryWithdraw() onlyOwner public {
513     require(goalReached());
514 
515     escrow.beneficiaryWithdraw();
516   }
517 
518   /**
519    * @dev escrow finalization task, called when owner calls finalize()
520    */
521   function finalization() internal {
522     if (goalReached()) {
523       escrow.reachGoal();
524       escrow.beneficiaryWithdraw();
525     } else {
526       escrow.enableRefunds();
527     }
528 
529     super.finalization();
530   }
531 
532   /**
533    * @dev Overrides Crowdsale fund forwarding, sending funds to escrow.
534    */
535   function _forwardFunds() internal {
536     escrow.deposit.value(msg.value)(msg.sender);
537   }
538 
539 }
540 
541 contract Escrow is Ownable {
542   using SafeMath for uint256;
543 
544   event Deposited(address indexed payee, uint256 weiAmount);
545   event Withdrawn(address indexed payee, uint256 weiAmount);
546 
547   mapping(address => uint256) private deposits;
548 
549   function depositsOf(address _payee) public view returns (uint256) {
550     return deposits[_payee];
551   }
552 
553   /**
554   * @dev Stores the sent amount as credit to be withdrawn.
555   * @param _payee The destination address of the funds.
556   */
557   function deposit(address _payee) public onlyOwner payable {
558     uint256 amount = msg.value;
559     deposits[_payee] = deposits[_payee].add(amount);
560 
561     emit Deposited(_payee, amount);
562   }
563 
564   /**
565   * @dev Withdraw accumulated balance for a payee.
566   * @param _payee The address whose funds will be withdrawn and transferred to.
567   */
568   function withdraw(address _payee) public onlyOwner {
569     uint256 payment = deposits[_payee];
570     assert(address(this).balance >= payment);
571 
572     deposits[_payee] = 0;
573 
574     _payee.transfer(payment);
575 
576     emit Withdrawn(_payee, payment);
577   }
578 }
579 
580 contract AfterSoftCapEscrow is Ownable, Escrow {
581   enum State { Active, Refunding, Reached }
582 
583   event Reached();
584   event WithdrawalsEnabled();
585   event RefundsEnabled();
586 
587   State public state;
588   address public beneficiary;
589   uint256 public minimalValue;
590 
591   /**
592    * @dev Constructor.
593    * @param _beneficiary The beneficiary of the deposits.
594    */
595   constructor(address _beneficiary, uint256 _minimalValue) public {
596     require(_beneficiary != address(0));
597     beneficiary = _beneficiary;
598     state = State.Active;
599     minimalValue = _minimalValue;
600   }
601 
602   /**
603    * @dev Stores funds that may later be refunded.
604    * @param _refundee The address funds will be sent to if a refund occurs.
605    */
606   function deposit(address _refundee) public payable {
607     require(state != State.Refunding);
608     require(msg.value >= 0.0011 ether); // minimal token price (TODO: update for ICO)
609     super.deposit(_refundee);
610   }
611 
612   /**
613    * @dev Allows for the beneficiary to withdraw their funds, rejecting
614    * further deposits.
615    */
616   function reachGoal() public onlyOwner {
617     require(state == State.Active);
618     state = State.Reached;
619     emit Reached();
620   }
621 
622   /**
623    * @dev Allows for refunds to take place, rejecting further deposits.
624    */
625   function enableRefunds() public onlyOwner {
626     require(state == State.Active);
627     state = State.Refunding;
628     emit RefundsEnabled();
629   }
630 
631   /**
632    * @dev Withdraws the beneficiary's funds.
633    */
634   function beneficiaryWithdraw() public onlyOwner {
635     require(state == State.Reached);
636     beneficiary.transfer(address(this).balance);
637   }
638 
639   function withdraw(address _payee) public {
640     require(state == State.Refunding);
641     super.withdraw(_payee);
642   }
643 }
644 
645 contract BasicToken is ERC20Basic {
646   using SafeMath for uint256;
647 
648   mapping(address => uint256) balances;
649 
650   uint256 totalSupply_;
651 
652   /**
653   * @dev Total number of tokens in existence
654   */
655   function totalSupply() public view returns (uint256) {
656     return totalSupply_;
657   }
658 
659   /**
660   * @dev Transfer token for a specified address
661   * @param _to The address to transfer to.
662   * @param _value The amount to be transferred.
663   */
664   function transfer(address _to, uint256 _value) public returns (bool) {
665     require(_to != address(0));
666     require(_value <= balances[msg.sender]);
667 
668     balances[msg.sender] = balances[msg.sender].sub(_value);
669     balances[_to] = balances[_to].add(_value);
670     emit Transfer(msg.sender, _to, _value);
671     return true;
672   }
673 
674   /**
675   * @dev Gets the balance of the specified address.
676   * @param _owner The address to query the the balance of.
677   * @return An uint256 representing the amount owned by the passed address.
678   */
679   function balanceOf(address _owner) public view returns (uint256) {
680     return balances[_owner];
681   }
682 
683 }
684 
685 contract StandardToken is ERC20, BasicToken {
686 
687   mapping (address => mapping (address => uint256)) internal allowed;
688 
689 
690   /**
691    * @dev Transfer tokens from one address to another
692    * @param _from address The address which you want to send tokens from
693    * @param _to address The address which you want to transfer to
694    * @param _value uint256 the amount of tokens to be transferred
695    */
696   function transferFrom(
697     address _from,
698     address _to,
699     uint256 _value
700   )
701     public
702     returns (bool)
703   {
704     require(_to != address(0));
705     require(_value <= balances[_from]);
706     require(_value <= allowed[_from][msg.sender]);
707 
708     balances[_from] = balances[_from].sub(_value);
709     balances[_to] = balances[_to].add(_value);
710     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
711     emit Transfer(_from, _to, _value);
712     return true;
713   }
714 
715   /**
716    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
717    * Beware that changing an allowance with this method brings the risk that someone may use both the old
718    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
719    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
720    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
721    * @param _spender The address which will spend the funds.
722    * @param _value The amount of tokens to be spent.
723    */
724   function approve(address _spender, uint256 _value) public returns (bool) {
725     allowed[msg.sender][_spender] = _value;
726     emit Approval(msg.sender, _spender, _value);
727     return true;
728   }
729 
730   /**
731    * @dev Function to check the amount of tokens that an owner allowed to a spender.
732    * @param _owner address The address which owns the funds.
733    * @param _spender address The address which will spend the funds.
734    * @return A uint256 specifying the amount of tokens still available for the spender.
735    */
736   function allowance(
737     address _owner,
738     address _spender
739    )
740     public
741     view
742     returns (uint256)
743   {
744     return allowed[_owner][_spender];
745   }
746 
747   /**
748    * @dev Increase the amount of tokens that an owner allowed to a spender.
749    * approve should be called when allowed[_spender] == 0. To increment
750    * allowed value is better to use this function to avoid 2 calls (and wait until
751    * the first transaction is mined)
752    * From MonolithDAO Token.sol
753    * @param _spender The address which will spend the funds.
754    * @param _addedValue The amount of tokens to increase the allowance by.
755    */
756   function increaseApproval(
757     address _spender,
758     uint256 _addedValue
759   )
760     public
761     returns (bool)
762   {
763     allowed[msg.sender][_spender] = (
764       allowed[msg.sender][_spender].add(_addedValue));
765     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
766     return true;
767   }
768 
769   /**
770    * @dev Decrease the amount of tokens that an owner allowed to a spender.
771    * approve should be called when allowed[_spender] == 0. To decrement
772    * allowed value is better to use this function to avoid 2 calls (and wait until
773    * the first transaction is mined)
774    * From MonolithDAO Token.sol
775    * @param _spender The address which will spend the funds.
776    * @param _subtractedValue The amount of tokens to decrease the allowance by.
777    */
778   function decreaseApproval(
779     address _spender,
780     uint256 _subtractedValue
781   )
782     public
783     returns (bool)
784   {
785     uint256 oldValue = allowed[msg.sender][_spender];
786     if (_subtractedValue > oldValue) {
787       allowed[msg.sender][_spender] = 0;
788     } else {
789       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
790     }
791     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
792     return true;
793   }
794 
795 }
796 
797 contract MintableToken is StandardToken, Ownable {
798   event Mint(address indexed to, uint256 amount);
799   event MintFinished();
800 
801   bool public mintingFinished = false;
802 
803 
804   modifier canMint() {
805     require(!mintingFinished);
806     _;
807   }
808 
809   modifier hasMintPermission() {
810     require(msg.sender == owner);
811     _;
812   }
813 
814   /**
815    * @dev Function to mint tokens
816    * @param _to The address that will receive the minted tokens.
817    * @param _amount The amount of tokens to mint.
818    * @return A boolean that indicates if the operation was successful.
819    */
820   function mint(
821     address _to,
822     uint256 _amount
823   )
824     hasMintPermission
825     canMint
826     public
827     returns (bool)
828   {
829     totalSupply_ = totalSupply_.add(_amount);
830     balances[_to] = balances[_to].add(_amount);
831     emit Mint(_to, _amount);
832     emit Transfer(address(0), _to, _amount);
833     return true;
834   }
835 
836   /**
837    * @dev Function to stop minting new tokens.
838    * @return True if the operation was successful.
839    */
840   function finishMinting() onlyOwner canMint public returns (bool) {
841     mintingFinished = true;
842     emit MintFinished();
843     return true;
844   }
845 }
846 
847 contract BitfexToken is MintableToken {
848     string public name = "BitFex Token";
849     string public symbol = "BITFEX";
850     uint8 public decimals = 2;
851 
852     uint256 public PRE_ICO_TOKENS_AMOUNT = 2000000;
853     uint256 public ICO_TOKENS_AMOUNT = 3000000;
854     uint256 public OWNERS_TOKENS_AMOUNT = 4000000;
855     uint256 public BOUNTY_TOKENS_AMOUNT = 1000000;
856     uint256 public TOTAL_SUPPLY = PRE_ICO_TOKENS_AMOUNT + ICO_TOKENS_AMOUNT + OWNERS_TOKENS_AMOUNT + BOUNTY_TOKENS_AMOUNT;
857 
858     bool public mintingFinished = false;
859 
860     function preallocate(address _preICO, address _ICO, address _ownersWallet, address _bountyWallet) onlyOwner canMint public returns (bool) {
861       assert(TOTAL_SUPPLY == 10000000); // check that total tokens amount is 100 000.00 tokens
862       mint(_preICO, PRE_ICO_TOKENS_AMOUNT);
863       mint(_ICO, ICO_TOKENS_AMOUNT);
864       mint(_ownersWallet, OWNERS_TOKENS_AMOUNT);
865       mint(_bountyWallet, BOUNTY_TOKENS_AMOUNT);
866 
867       mintingFinished = true;
868       emit MintFinished();
869 
870       return true;
871     }
872 }
873 
874 
875 contract PreICOCrowdsale is TimedCrowdsale, PostDeliveryCrowdsale, RefundableBeforeSoftCapCrowdsale {
876     constructor
877         (
878             uint256 _openingTime,
879             uint256 _closingTime,
880             uint256 _rate,
881             uint256 _goal,
882             uint256 _hardCap,
883             address _wallet,
884             BitfexToken _token
885         )
886         public
887         Crowdsale(_rate, _wallet, _token)
888         TimedCrowdsale(_openingTime, _closingTime)
889         RefundableBeforeSoftCapCrowdsale(_goal)
890         PostDeliveryCrowdsale(_hardCap)
891         {
892         }
893 
894     /**
895      * @dev Convert wei to tokens
896      * @param _weiAmount Value in wei to be converted into tokens
897      * @return Number of tokens that can be purchased with the specified _weiAmount
898      */
899     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
900       return _weiAmount.mul(10**2).div(rate);
901     }
902 }