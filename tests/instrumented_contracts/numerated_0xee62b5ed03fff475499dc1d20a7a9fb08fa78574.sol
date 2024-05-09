1 pragma solidity 0.4.24;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (_a == 0) {
13       return 0;
14     }
15 
16     c = _a * _b;
17     assert(c / _a == _b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
25     // assert(_b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = _a / _b;
27     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
28     return _a / _b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
35     assert(_b <= _a);
36     return _a - _b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
43     c = _a + _b;
44     assert(c >= _a);
45     return c;
46   }
47 }
48 
49 contract Config {
50     uint256 public constant jvySupply = 333333333333333;
51     uint256 public constant bonusSupply = 83333333333333;
52     uint256 public constant saleSupply =  250000000000000;
53     uint256 public constant hardCapUSD = 8000000;
54 
55     uint256 public constant preIcoBonus = 25;
56     uint256 public constant minimalContributionAmount = 0.4 ether;
57 
58     function getStartPreIco() public view returns (uint256) {
59         // solium-disable-next-line security/no-block-members
60         uint256 nowTime = block.timestamp;
61         uint256 _preIcoStartTime = nowTime + 1 minutes;
62         return _preIcoStartTime;
63     }
64 
65     function getStartIco() public view returns (uint256) {
66         uint256 _icoStartTime = 1543554000;
67         return _icoStartTime;
68     }
69 
70     function getEndIco() public view returns (uint256) {
71         uint256 _icoEndTime = 1551416400;
72         return _icoEndTime;
73     }
74 }
75 
76 contract Ownable {
77   address public owner;
78 
79 
80   event OwnershipRenounced(address indexed previousOwner);
81   event OwnershipTransferred(
82     address indexed previousOwner,
83     address indexed newOwner
84   );
85 
86 
87   /**
88    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
89    * account.
90    */
91   constructor() public {
92     owner = msg.sender;
93   }
94 
95   /**
96    * @dev Throws if called by any account other than the owner.
97    */
98   modifier onlyOwner() {
99     require(msg.sender == owner);
100     _;
101   }
102 
103   /**
104    * @dev Allows the current owner to relinquish control of the contract.
105    * @notice Renouncing to ownership will leave the contract without an owner.
106    * It will not be possible to call the functions with the `onlyOwner`
107    * modifier anymore.
108    */
109   function renounceOwnership() public onlyOwner {
110     emit OwnershipRenounced(owner);
111     owner = address(0);
112   }
113 
114   /**
115    * @dev Allows the current owner to transfer control of the contract to a newOwner.
116    * @param _newOwner The address to transfer ownership to.
117    */
118   function transferOwnership(address _newOwner) public onlyOwner {
119     _transferOwnership(_newOwner);
120   }
121 
122   /**
123    * @dev Transfers control of the contract to a newOwner.
124    * @param _newOwner The address to transfer ownership to.
125    */
126   function _transferOwnership(address _newOwner) internal {
127     require(_newOwner != address(0));
128     emit OwnershipTransferred(owner, _newOwner);
129     owner = _newOwner;
130   }
131 }
132 
133 contract ERC20Basic {
134   function totalSupply() public view returns (uint256);
135   function balanceOf(address _who) public view returns (uint256);
136   function transfer(address _to, uint256 _value) public returns (bool);
137   event Transfer(address indexed from, address indexed to, uint256 value);
138 }
139 
140 
141 contract ERC20 is ERC20Basic {
142   function allowance(address _owner, address _spender)
143     public view returns (uint256);
144 
145   function transferFrom(address _from, address _to, uint256 _value)
146     public returns (bool);
147 
148   function approve(address _spender, uint256 _value) public returns (bool);
149   event Approval(
150     address indexed owner,
151     address indexed spender,
152     uint256 value
153   );
154 }
155 
156 
157 contract DetailedERC20 is ERC20 {
158   string public name;
159   string public symbol;
160   uint8 public decimals;
161 
162   constructor(string _name, string _symbol, uint8 _decimals) public {
163     name = _name;
164     symbol = _symbol;
165     decimals = _decimals;
166   }
167 }
168 
169 contract BasicToken is ERC20Basic {
170   using SafeMath for uint256;
171 
172   mapping(address => uint256) internal balances;
173 
174   uint256 internal totalSupply_;
175 
176   /**
177   * @dev Total number of tokens in existence
178   */
179   function totalSupply() public view returns (uint256) {
180     return totalSupply_;
181   }
182 
183   /**
184   * @dev Transfer token for a specified address
185   * @param _to The address to transfer to.
186   * @param _value The amount to be transferred.
187   */
188   function transfer(address _to, uint256 _value) public returns (bool) {
189     require(_value <= balances[msg.sender]);
190     require(_to != address(0));
191 
192     balances[msg.sender] = balances[msg.sender].sub(_value);
193     balances[_to] = balances[_to].add(_value);
194     emit Transfer(msg.sender, _to, _value);
195     return true;
196   }
197 
198   /**
199   * @dev Gets the balance of the specified address.
200   * @param _owner The address to query the the balance of.
201   * @return An uint256 representing the amount owned by the passed address.
202   */
203   function balanceOf(address _owner) public view returns (uint256) {
204     return balances[_owner];
205   }
206 
207 }
208 
209 
210 contract StandardToken is ERC20, BasicToken {
211 
212   mapping (address => mapping (address => uint256)) internal allowed;
213 
214 
215   /**
216    * @dev Transfer tokens from one address to another
217    * @param _from address The address which you want to send tokens from
218    * @param _to address The address which you want to transfer to
219    * @param _value uint256 the amount of tokens to be transferred
220    */
221   function transferFrom(
222     address _from,
223     address _to,
224     uint256 _value
225   )
226     public
227     returns (bool)
228   {
229     require(_value <= balances[_from]);
230     require(_value <= allowed[_from][msg.sender]);
231     require(_to != address(0));
232 
233     balances[_from] = balances[_from].sub(_value);
234     balances[_to] = balances[_to].add(_value);
235     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
236     emit Transfer(_from, _to, _value);
237     return true;
238   }
239 
240   /**
241    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
242    * Beware that changing an allowance with this method brings the risk that someone may use both the old
243    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
244    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
245    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
246    * @param _spender The address which will spend the funds.
247    * @param _value The amount of tokens to be spent.
248    */
249   function approve(address _spender, uint256 _value) public returns (bool) {
250     allowed[msg.sender][_spender] = _value;
251     emit Approval(msg.sender, _spender, _value);
252     return true;
253   }
254 
255   /**
256    * @dev Function to check the amount of tokens that an owner allowed to a spender.
257    * @param _owner address The address which owns the funds.
258    * @param _spender address The address which will spend the funds.
259    * @return A uint256 specifying the amount of tokens still available for the spender.
260    */
261   function allowance(
262     address _owner,
263     address _spender
264    )
265     public
266     view
267     returns (uint256)
268   {
269     return allowed[_owner][_spender];
270   }
271 
272   /**
273    * @dev Increase the amount of tokens that an owner allowed to a spender.
274    * approve should be called when allowed[_spender] == 0. To increment
275    * allowed value is better to use this function to avoid 2 calls (and wait until
276    * the first transaction is mined)
277    * From MonolithDAO Token.sol
278    * @param _spender The address which will spend the funds.
279    * @param _addedValue The amount of tokens to increase the allowance by.
280    */
281   function increaseApproval(
282     address _spender,
283     uint256 _addedValue
284   )
285     public
286     returns (bool)
287   {
288     allowed[msg.sender][_spender] = (
289       allowed[msg.sender][_spender].add(_addedValue));
290     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
291     return true;
292   }
293 
294   /**
295    * @dev Decrease the amount of tokens that an owner allowed to a spender.
296    * approve should be called when allowed[_spender] == 0. To decrement
297    * allowed value is better to use this function to avoid 2 calls (and wait until
298    * the first transaction is mined)
299    * From MonolithDAO Token.sol
300    * @param _spender The address which will spend the funds.
301    * @param _subtractedValue The amount of tokens to decrease the allowance by.
302    */
303   function decreaseApproval(
304     address _spender,
305     uint256 _subtractedValue
306   )
307     public
308     returns (bool)
309   {
310     uint256 oldValue = allowed[msg.sender][_spender];
311     if (_subtractedValue >= oldValue) {
312       allowed[msg.sender][_spender] = 0;
313     } else {
314       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
315     }
316     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
317     return true;
318   }
319 
320 }
321 
322 contract Escrow is Ownable {
323   using SafeMath for uint256;
324 
325   event Deposited(address indexed payee, uint256 weiAmount);
326   event Withdrawn(address indexed payee, uint256 weiAmount);
327 
328   mapping(address => uint256) private deposits;
329 
330   function depositsOf(address _payee) public view returns (uint256) {
331     return deposits[_payee];
332   }
333 
334   /**
335   * @dev Stores the sent amount as credit to be withdrawn.
336   * @param _payee The destination address of the funds.
337   */
338   function deposit(address _payee) public onlyOwner payable {
339     uint256 amount = msg.value;
340     deposits[_payee] = deposits[_payee].add(amount);
341 
342     emit Deposited(_payee, amount);
343   }
344 
345   /**
346   * @dev Withdraw accumulated balance for a payee.
347   * @param _payee The address whose funds will be withdrawn and transferred to.
348   */
349   function withdraw(address _payee) public onlyOwner {
350     uint256 payment = deposits[_payee];
351     assert(address(this).balance >= payment);
352 
353     deposits[_payee] = 0;
354 
355     _payee.transfer(payment);
356 
357     emit Withdrawn(_payee, payment);
358   }
359 }
360 
361 
362 contract Crowdsale {
363   using SafeMath for uint256;
364   using SafeERC20 for ERC20;
365 
366   // The token being sold
367   ERC20 public token;
368 
369   // Address where funds are collected
370   address public wallet;
371 
372   // How many token units a buyer gets per wei.
373   // The rate is the conversion between wei and the smallest and indivisible token unit.
374   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
375   // 1 wei will give you 1 unit, or 0.001 TOK.
376   uint256 public rate;
377 
378   // Amount of wei raised
379   uint256 public weiRaised;
380 
381   /**
382    * Event for token purchase logging
383    * @param purchaser who paid for the tokens
384    * @param beneficiary who got the tokens
385    * @param value weis paid for purchase
386    * @param amount amount of tokens purchased
387    */
388   event TokenPurchase(
389     address indexed purchaser,
390     address indexed beneficiary,
391     uint256 value,
392     uint256 amount
393   );
394 
395   /**
396    * @param _rate Number of token units a buyer gets per wei
397    * @param _wallet Address where collected funds will be forwarded to
398    * @param _token Address of the token being sold
399    */
400   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
401     require(_rate > 0);
402     require(_wallet != address(0));
403     require(_token != address(0));
404 
405     rate = _rate;
406     wallet = _wallet;
407     token = _token;
408   }
409 
410   // -----------------------------------------
411   // Crowdsale external interface
412   // -----------------------------------------
413 
414   /**
415    * @dev fallback function ***DO NOT OVERRIDE***
416    */
417   function () external payable {
418     buyTokens(msg.sender);
419   }
420 
421   /**
422    * @dev low level token purchase ***DO NOT OVERRIDE***
423    * @param _beneficiary Address performing the token purchase
424    */
425   function buyTokens(address _beneficiary) public payable {
426 
427     uint256 weiAmount = msg.value;
428     _preValidatePurchase(_beneficiary, weiAmount);
429 
430     // calculate token amount to be created
431     uint256 tokens = _getTokenAmount(weiAmount);
432 
433     // update state
434     weiRaised = weiRaised.add(weiAmount);
435 
436     _processPurchase(_beneficiary, tokens);
437     emit TokenPurchase(
438       msg.sender,
439       _beneficiary,
440       weiAmount,
441       tokens
442     );
443 
444     _updatePurchasingState(_beneficiary, weiAmount);
445 
446     _forwardFunds();
447     _postValidatePurchase(_beneficiary, weiAmount);
448   }
449 
450   // -----------------------------------------
451   // Internal interface (extensible)
452   // -----------------------------------------
453 
454   /**
455    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
456    * Example from CappedCrowdsale.sol's _preValidatePurchase method: 
457    *   super._preValidatePurchase(_beneficiary, _weiAmount);
458    *   require(weiRaised.add(_weiAmount) <= cap);
459    * @param _beneficiary Address performing the token purchase
460    * @param _weiAmount Value in wei involved in the purchase
461    */
462   function _preValidatePurchase(
463     address _beneficiary,
464     uint256 _weiAmount
465   )
466     internal
467   {
468     require(_beneficiary != address(0));
469     require(_weiAmount != 0);
470   }
471 
472   /**
473    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
474    * @param _beneficiary Address performing the token purchase
475    * @param _weiAmount Value in wei involved in the purchase
476    */
477   function _postValidatePurchase(
478     address _beneficiary,
479     uint256 _weiAmount
480   )
481     internal
482   {
483     // optional override
484   }
485 
486   /**
487    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
488    * @param _beneficiary Address performing the token purchase
489    * @param _tokenAmount Number of tokens to be emitted
490    */
491   function _deliverTokens(
492     address _beneficiary,
493     uint256 _tokenAmount
494   )
495     internal
496   {
497     token.safeTransfer(_beneficiary, _tokenAmount);
498   }
499 
500   /**
501    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
502    * @param _beneficiary Address receiving the tokens
503    * @param _tokenAmount Number of tokens to be purchased
504    */
505   function _processPurchase(
506     address _beneficiary,
507     uint256 _tokenAmount
508   )
509     internal
510   {
511     _deliverTokens(_beneficiary, _tokenAmount);
512   }
513 
514   /**
515    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
516    * @param _beneficiary Address receiving the tokens
517    * @param _weiAmount Value in wei involved in the purchase
518    */
519   function _updatePurchasingState(
520     address _beneficiary,
521     uint256 _weiAmount
522   )
523     internal
524   {
525     // optional override
526   }
527 
528   /**
529    * @dev Override to extend the way in which ether is converted to tokens.
530    * @param _weiAmount Value in wei to be converted into tokens
531    * @return Number of tokens that can be purchased with the specified _weiAmount
532    */
533   function _getTokenAmount(uint256 _weiAmount)
534     internal view returns (uint256)
535   {
536     return _weiAmount.mul(rate);
537   }
538 
539   /**
540    * @dev Determines how ETH is stored/forwarded on purchases.
541    */
542   function _forwardFunds() internal {
543     wallet.transfer(msg.value);
544   }
545 }
546 
547 contract ConditionalEscrow is Escrow {
548   /**
549   * @dev Returns whether an address is allowed to withdraw their funds. To be
550   * implemented by derived contracts.
551   * @param _payee The destination address of the funds.
552   */
553   function withdrawalAllowed(address _payee) public view returns (bool);
554 
555   function withdraw(address _payee) public {
556     require(withdrawalAllowed(_payee));
557     super.withdraw(_payee);
558   }
559 }
560 
561 
562 contract RefundEscrow is Ownable, ConditionalEscrow {
563   enum State { Active, Refunding, Closed }
564 
565   event Closed();
566   event RefundsEnabled();
567 
568   State public state;
569   address public beneficiary;
570 
571   /**
572    * @dev Constructor.
573    * @param _beneficiary The beneficiary of the deposits.
574    */
575   constructor(address _beneficiary) public {
576     require(_beneficiary != address(0));
577     beneficiary = _beneficiary;
578     state = State.Active;
579   }
580 
581   /**
582    * @dev Stores funds that may later be refunded.
583    * @param _refundee The address funds will be sent to if a refund occurs.
584    */
585   function deposit(address _refundee) public payable {
586     require(state == State.Active);
587     super.deposit(_refundee);
588   }
589 
590   /**
591    * @dev Allows for the beneficiary to withdraw their funds, rejecting
592    * further deposits.
593    */
594   function close() public onlyOwner {
595     require(state == State.Active);
596     state = State.Closed;
597     emit Closed();
598   }
599 
600   /**
601    * @dev Allows for refunds to take place, rejecting further deposits.
602    */
603   function enableRefunds() public onlyOwner {
604     require(state == State.Active);
605     state = State.Refunding;
606     emit RefundsEnabled();
607   }
608 
609   /**
610    * @dev Withdraws the beneficiary's funds.
611    */
612   function beneficiaryWithdraw() public {
613     require(state == State.Closed);
614     beneficiary.transfer(address(this).balance);
615   }
616 
617   /**
618    * @dev Returns whether refundees can withdraw their deposits (be refunded).
619    */
620   function withdrawalAllowed(address _payee) public view returns (bool) {
621     return state == State.Refunding;
622   }
623 }
624 
625 library SafeERC20 {
626   function safeTransfer(
627     ERC20Basic _token,
628     address _to,
629     uint256 _value
630   )
631     internal
632   {
633     require(_token.transfer(_to, _value));
634   }
635 
636   function safeTransferFrom(
637     ERC20 _token,
638     address _from,
639     address _to,
640     uint256 _value
641   )
642     internal
643   {
644     require(_token.transferFrom(_from, _to, _value));
645   }
646 
647   function safeApprove(
648     ERC20 _token,
649     address _spender,
650     uint256 _value
651   )
652     internal
653   {
654     require(_token.approve(_spender, _value));
655   }
656 }
657 
658 contract CappedCrowdsale is Crowdsale {
659   using SafeMath for uint256;
660 
661   uint256 public cap;
662 
663   /**
664    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
665    * @param _cap Max amount of wei to be contributed
666    */
667   constructor(uint256 _cap) public {
668     require(_cap > 0);
669     cap = _cap;
670   }
671 
672   /**
673    * @dev Checks whether the cap has been reached.
674    * @return Whether the cap was reached
675    */
676   function capReached() public view returns (bool) {
677     return weiRaised >= cap;
678   }
679 
680   /**
681    * @dev Extend parent behavior requiring purchase to respect the funding cap.
682    * @param _beneficiary Token purchaser
683    * @param _weiAmount Amount of wei contributed
684    */
685   function _preValidatePurchase(
686     address _beneficiary,
687     uint256 _weiAmount
688   )
689     internal
690   {
691     super._preValidatePurchase(_beneficiary, _weiAmount);
692     require(weiRaised.add(_weiAmount) <= cap);
693   }
694 
695 }
696 
697 
698 
699 contract TimedCrowdsale is Crowdsale {
700   using SafeMath for uint256;
701 
702   uint256 public openingTime;
703   uint256 public closingTime;
704 
705   /**
706    * @dev Reverts if not in crowdsale time range.
707    */
708   modifier onlyWhileOpen {
709     // solium-disable-next-line security/no-block-members
710     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
711     _;
712   }
713 
714   /**
715    * @dev Constructor, takes crowdsale opening and closing times.
716    * @param _openingTime Crowdsale opening time
717    * @param _closingTime Crowdsale closing time
718    */
719   constructor(uint256 _openingTime, uint256 _closingTime) public {
720     // solium-disable-next-line security/no-block-members
721     require(_openingTime >= block.timestamp);
722     require(_closingTime >= _openingTime);
723 
724     openingTime = _openingTime;
725     closingTime = _closingTime;
726   }
727 
728   /**
729    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
730    * @return Whether crowdsale period has elapsed
731    */
732   function hasClosed() public view returns (bool) {
733     // solium-disable-next-line security/no-block-members
734     return block.timestamp > closingTime;
735   }
736 
737   /**
738    * @dev Extend parent behavior requiring to be within contributing period
739    * @param _beneficiary Token purchaser
740    * @param _weiAmount Amount of wei contributed
741    */
742   function _preValidatePurchase(
743     address _beneficiary,
744     uint256 _weiAmount
745   )
746     internal
747     onlyWhileOpen
748   {
749     super._preValidatePurchase(_beneficiary, _weiAmount);
750   }
751 
752 }
753 
754 contract FinalizableCrowdsale is Ownable, TimedCrowdsale {
755   using SafeMath for uint256;
756 
757   bool public isFinalized = false;
758 
759   event Finalized();
760 
761   /**
762    * @dev Must be called after crowdsale ends, to do some extra finalization
763    * work. Calls the contract's finalization function.
764    */
765   function finalize() public onlyOwner {
766     require(!isFinalized);
767     require(hasClosed());
768 
769     finalization();
770     emit Finalized();
771 
772     isFinalized = true;
773   }
774 
775   /**
776    * @dev Can be overridden to add finalization logic. The overriding function
777    * should call super.finalization() to ensure the chain of finalization is
778    * executed entirely.
779    */
780   function finalization() internal {
781   }
782 
783 }
784 
785 contract RefundableCrowdsale is FinalizableCrowdsale {
786   using SafeMath for uint256;
787 
788   // minimum amount of funds to be raised in weis
789   uint256 public goal;
790 
791   // refund escrow used to hold funds while crowdsale is running
792   RefundEscrow private escrow;
793 
794   /**
795    * @dev Constructor, creates RefundEscrow.
796    * @param _goal Funding goal
797    */
798   constructor(uint256 _goal) public {
799     require(_goal > 0);
800     escrow = new RefundEscrow(wallet);
801     goal = _goal;
802   }
803 
804   /**
805    * @dev Investors can claim refunds here if crowdsale is unsuccessful
806    */
807   function claimRefund() public {
808     require(isFinalized);
809     require(!goalReached());
810 
811     escrow.withdraw(msg.sender);
812   }
813 
814   /**
815    * @dev Checks whether funding goal was reached.
816    * @return Whether funding goal was reached
817    */
818   function goalReached() public view returns (bool) {
819     return weiRaised >= goal;
820   }
821 
822   /**
823    * @dev escrow finalization task, called when owner calls finalize()
824    */
825   function finalization() internal {
826     if (goalReached()) {
827       escrow.close();
828       escrow.beneficiaryWithdraw();
829     } else {
830       escrow.enableRefunds();
831     }
832 
833     super.finalization();
834   }
835 
836   /**
837    * @dev Overrides Crowdsale fund forwarding, sending funds to escrow.
838    */
839   function _forwardFunds() internal {
840     escrow.deposit.value(msg.value)(msg.sender);
841   }
842 
843 }
844 
845 contract Pausable is Ownable {
846   event Pause();
847   event Unpause();
848 
849   bool public paused = false;
850 
851 
852   /**
853    * @dev Modifier to make a function callable only when the contract is not paused.
854    */
855   modifier whenNotPaused() {
856     require(!paused);
857     _;
858   }
859 
860   /**
861    * @dev Modifier to make a function callable only when the contract is paused.
862    */
863   modifier whenPaused() {
864     require(paused);
865     _;
866   }
867 
868   /**
869    * @dev called by the owner to pause, triggers stopped state
870    */
871   function pause() public onlyOwner whenNotPaused {
872     paused = true;
873     emit Pause();
874   }
875 
876   /**
877    * @dev called by the owner to unpause, returns to normal state
878    */
879   function unpause() public onlyOwner whenPaused {
880     paused = false;
881     emit Unpause();
882   }
883 }
884 
885 contract MultiSigWallet {
886     uint constant public MAX_OWNER_COUNT = 50;
887 
888     event Confirmation(address indexed sender, uint indexed transactionId);
889     event Revocation(address indexed sender, uint indexed transactionId);
890     event Submission(uint indexed transactionId);
891     event Execution(uint indexed transactionId);
892     event ExecutionFailure(uint indexed transactionId);
893     event Deposit(address indexed sender, uint value);
894     event OwnerAddition(address indexed owner);
895     event OwnerRemoval(address indexed owner);
896     event RequirementChange(uint required);
897 
898     mapping (uint => Transaction) public transactions;
899     mapping (uint => mapping (address => bool)) public confirmations;
900     mapping (address => bool) public isOwner;
901 
902     address[] public owners;
903     uint public required;
904     uint public transactionCount;
905 
906     struct Transaction {
907         address destination;
908         uint value;
909         bytes data;
910         bool executed;
911     }
912 
913     modifier onlyWallet() {
914         require(msg.sender == address(this));
915         _;
916     }
917 
918     modifier ownerDoesNotExist(address owner) {
919         require(!isOwner[owner]);
920         _;
921     }
922 
923     modifier ownerExists(address owner) {
924         require(isOwner[owner]);
925         _;
926     }
927 
928     modifier transactionExists(uint transactionId) {
929         require(transactions[transactionId].destination != 0);
930         _;
931     }
932 
933     modifier confirmed(uint transactionId, address owner) {
934         require(confirmations[transactionId][owner]);
935         _;
936     }
937 
938     modifier notConfirmed(uint transactionId, address owner) {
939         require(!confirmations[transactionId][owner]);
940         _;
941     }
942 
943     modifier notExecuted(uint transactionId) {
944         require(!transactions[transactionId].executed);
945         _;
946     }
947 
948     modifier notNull(address _address) {
949         require(_address != address(0));
950         _;
951     }
952 
953     modifier validRequirement(uint ownerCount, uint _required) {
954         bool ownerValid = ownerCount <= MAX_OWNER_COUNT;
955         bool ownerNotZero = ownerCount != 0;
956         bool requiredValid = _required <= ownerCount;
957         bool requiredNotZero = _required != 0;
958         require(ownerValid && ownerNotZero && requiredValid && requiredNotZero);
959         _;
960     }
961 
962     /// @dev Fallback function allows to deposit ether.
963     function() payable public {
964         fallback();
965     }
966 
967     function fallback() payable public {
968         if (msg.value > 0) {
969             emit Deposit(msg.sender, msg.value);
970         }
971     }
972 
973     /*
974      * Public functions
975      */
976     /// @dev Contract constructor sets initial owners and required number of confirmations.
977     /// @param _owners List of initial owners.
978     /// @param _required Number of required confirmations.
979     constructor(
980         address[] _owners, 
981         uint _required
982     ) public validRequirement(_owners.length, _required) 
983     {
984         for (uint i = 0; i<_owners.length; i++) {
985             require(!isOwner[_owners[i]] && _owners[i] != 0);
986             isOwner[_owners[i]] = true;
987         }
988         owners = _owners;
989         required = _required;
990     }
991 
992     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
993     /// @param owner Address of new owner.
994     function addOwner(address owner)
995         public
996         onlyWallet
997         ownerDoesNotExist(owner)
998         notNull(owner)
999         validRequirement(owners.length + 1, required)
1000     {
1001         isOwner[owner] = true;
1002         owners.push(owner);
1003         emit OwnerAddition(owner);
1004     }
1005 
1006     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
1007     /// @param owner Address of owner.
1008     function removeOwner(address owner)
1009         public
1010         onlyWallet
1011         ownerExists(owner)
1012     {
1013         isOwner[owner] = false;
1014         for (uint i = 0; i < owners.length - 1; i++)
1015             if (owners[i] == owner) {
1016                 owners[i] = owners[owners.length - 1];
1017                 break;
1018             }
1019         owners.length -= 1;
1020         if (required > owners.length)
1021             changeRequirement(owners.length);
1022         emit OwnerRemoval(owner);
1023     }
1024 
1025     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
1026     /// @param owner Address of owner to be replaced.
1027     /// @param newOwner Address of new owner.
1028     function replaceOwner(address owner, address newOwner)
1029         public
1030         onlyWallet
1031         ownerExists(owner)
1032         ownerDoesNotExist(newOwner)
1033     {
1034         for (uint i = 0; i < owners.length; i++)
1035             if (owners[i] == owner) {
1036                 owners[i] = newOwner;
1037                 break;
1038             }
1039         isOwner[owner] = false;
1040         isOwner[newOwner] = true;
1041         emit OwnerRemoval(owner);
1042         emit OwnerAddition(newOwner);
1043     }
1044 
1045     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
1046     /// @param _required Number of required confirmations.
1047     function changeRequirement(uint _required)
1048         public
1049         onlyWallet
1050         validRequirement(owners.length, _required)
1051     {
1052         required = _required;
1053         emit RequirementChange(_required);
1054     }
1055 
1056     /// @dev Allows an owner to submit and confirm a transaction.
1057     /// @param destination Transaction target address.
1058     /// @param value Transaction ether value.
1059     /// @param data Transaction data payload.
1060     /// @return Returns transaction ID.
1061     function submitTransaction(address destination, uint value, bytes data)
1062         public
1063         returns (uint transactionId)
1064     {
1065         transactionId = addTransaction(destination, value, data);
1066         confirmTransaction(transactionId);
1067     }
1068 
1069     /// @dev Allows an owner to confirm a transaction.
1070     /// @param transactionId Transaction ID.
1071     function confirmTransaction(uint transactionId)
1072         public
1073         ownerExists(msg.sender)
1074         transactionExists(transactionId)
1075         notConfirmed(transactionId, msg.sender)
1076     {
1077         confirmations[transactionId][msg.sender] = true;
1078         emit Confirmation(msg.sender, transactionId);
1079         executeTransaction(transactionId);
1080     }
1081 
1082     /// @dev Allows an owner to revoke a confirmation for a transaction.
1083     /// @param transactionId Transaction ID.
1084     function revokeConfirmation(uint transactionId)
1085         public
1086         ownerExists(msg.sender)
1087         confirmed(transactionId, msg.sender)
1088         notExecuted(transactionId)
1089     {
1090         confirmations[transactionId][msg.sender] = false;
1091         emit Revocation(msg.sender, transactionId);
1092     }
1093 
1094     /// @dev Allows anyone to execute a confirmed transaction.
1095     /// @param transactionId Transaction ID.
1096     function executeTransaction(uint transactionId)
1097         public
1098         ownerExists(msg.sender)
1099         confirmed(transactionId, msg.sender)
1100         notExecuted(transactionId)
1101     {
1102         if (isConfirmed(transactionId)) {
1103             Transaction storage txn = transactions[transactionId];
1104             txn.executed = true;
1105             if (txn.destination.call.value(txn.value)(txn.data))
1106                 emit Execution(transactionId);
1107             else {
1108                 emit ExecutionFailure(transactionId);
1109                 txn.executed = false;
1110             }
1111         }
1112     }
1113 
1114     /// @dev Returns the confirmation status of a transaction.
1115     /// @param transactionId Transaction ID.
1116     /// @return Confirmation status.
1117     function isConfirmed(uint transactionId) public view returns (bool) {
1118         uint count = 0;
1119         for (uint i = 0; i < owners.length; i++) {
1120             if (confirmations[transactionId][owners[i]])
1121                 count += 1;
1122             if (count == required)
1123                 return true;
1124         }
1125     }
1126 
1127     /*
1128      * Internal functions
1129      */
1130     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
1131     /// @param destination Transaction target address.
1132     /// @param value Transaction ether value.
1133     /// @param data Transaction data payload.
1134     /// @return Returns transaction ID.
1135     function addTransaction(address destination, uint value, bytes data)
1136         internal
1137         notNull(destination)
1138         returns (uint transactionId)
1139     {
1140         transactionId = transactionCount;
1141         transactions[transactionId] = Transaction({
1142             destination: destination,
1143             value: value,
1144             data: data,
1145             executed: false
1146         });
1147         transactionCount += 1;
1148         emit Submission(transactionId);
1149     }
1150 
1151     /*
1152      * Web3 call functions
1153      */
1154     /// @dev Returns number of confirmations of a transaction.
1155     /// @param transactionId Transaction ID.
1156     /// @return Number of confirmations.
1157     function getConfirmationCount(uint transactionId) public view returns (uint count) {
1158         for (uint i = 0; i < owners.length; i++) {
1159             if (confirmations[transactionId][owners[i]]) {
1160                 count += 1;
1161             }
1162         }
1163     }
1164 
1165     /// @dev Returns total number of transactions after filers are applied.
1166     /// @param pending Include pending transactions.
1167     /// @param executed Include executed transactions.
1168     /// @return Total number of transactions after filters are applied.
1169     function getTransactionCount(
1170         bool pending, 
1171         bool executed
1172     ) public view returns (uint count) {
1173         for (uint i = 0; i < transactionCount; i++) {
1174             if (pending && 
1175                 !transactions[i].executed || 
1176                 executed && 
1177                 transactions[i].executed
1178             ) {
1179                 count += 1;
1180             }
1181         }
1182     }
1183 
1184     /// @dev Returns list of owners.
1185     /// @return List of owner addresses.
1186     function getOwners() public view returns (address[]) {
1187         return owners;
1188     }
1189 
1190     /// @dev Returns array with owner addresses, which confirmed transaction.
1191     /// @param transactionId Transaction ID.
1192     /// @return Returns array of owner addresses.
1193     function getConfirmations(
1194         uint transactionId
1195     ) public view returns (address[] _confirmations) {
1196         address[] memory confirmationsTemp = new address[](owners.length);
1197         uint count = 0;
1198         uint i;
1199         for (i = 0; i < owners.length; i++)
1200             if (confirmations[transactionId][owners[i]]) {
1201                 confirmationsTemp[count] = owners[i];
1202                 count += 1;
1203             }
1204         _confirmations = new address[](count);
1205         for (i = 0; i < count; i++)
1206             _confirmations[i] = confirmationsTemp[i];
1207     }
1208 
1209     /// @dev Returns list of transaction IDs in defined range.
1210     /// @param from Index start position of transaction array.
1211     /// @param to Index end position of transaction array.
1212     /// @param pending Include pending transactions.
1213     /// @param executed Include executed transactions.
1214     /// @return Returns array of transaction IDs.
1215     function getTransactionIds(
1216         uint from, 
1217         uint to, 
1218         bool pending, 
1219         bool executed
1220     ) public view returns (uint[] _transactionIds) {
1221         uint[] memory transactionIdsTemp = new uint[](transactionCount);
1222         uint count = 0;
1223         uint i;
1224         for (i = 0; i < transactionCount; i++)
1225             if (pending && 
1226                 !transactions[i].executed || 
1227                 executed && 
1228                 transactions[i].executed
1229             ) {
1230                 transactionIdsTemp[count] = i;
1231                 count += 1;
1232             }
1233         _transactionIds = new uint[](to - from);
1234         for (i = from; i < to; i++)
1235             _transactionIds[i - from] = transactionIdsTemp[i];
1236     }
1237 }
1238 
1239 contract JavvyMultiSig is MultiSigWallet {
1240     constructor(
1241         address[] _owners, 
1242         uint _required
1243     )
1244     MultiSigWallet(_owners, _required)
1245     public {}
1246 }
1247 
1248 contract JavvyToken is DetailedERC20, StandardToken, Ownable, Config {
1249     address public crowdsaleAddress;
1250     address public bonusAddress;
1251     address public multiSigAddress;
1252 
1253     constructor(
1254         string _name, 
1255         string _symbol, 
1256         uint8 _decimals
1257     ) public
1258     DetailedERC20(_name, _symbol, _decimals) {
1259         require(
1260             jvySupply == saleSupply + bonusSupply,
1261             "Sum of provided supplies is not equal to declared total Javvy supply. Check config!"
1262         );
1263         totalSupply_ = tokenToDecimals(jvySupply);
1264     }
1265 
1266     function initializeBalances(
1267         address _crowdsaleAddress,
1268         address _bonusAddress,
1269         address _multiSigAddress
1270     ) public 
1271     onlyOwner() {
1272         crowdsaleAddress = _crowdsaleAddress;
1273         bonusAddress = _bonusAddress;
1274         multiSigAddress = _multiSigAddress;
1275 
1276         _initializeBalance(_crowdsaleAddress, saleSupply);
1277         _initializeBalance(_bonusAddress, bonusSupply);
1278     }
1279 
1280     function _initializeBalance(address _address, uint256 _supply) private {
1281         require(_address != address(0), "Address cannot be equal to 0x0!");
1282         require(_supply != 0, "Supply cannot be equal to 0!");
1283         balances[_address] = tokenToDecimals(_supply);
1284         emit Transfer(address(0), _address, _supply);
1285     }
1286 
1287     function tokenToDecimals(uint256 _amount) private view returns (uint256){
1288         // NOTE for additional accuracy, we're using 6 decimal places in supply
1289         return _amount * (10 ** 12);
1290     }
1291 
1292     function getRemainingSaleTokens() external view returns (uint256) {
1293         return balanceOf(crowdsaleAddress);
1294     }
1295 
1296 }
1297 
1298 contract JavvyCrowdsale is RefundableCrowdsale, CappedCrowdsale, Pausable, Config {
1299     uint256 public icoStartTime;
1300     address public transminingAddress;
1301     address public bonusAddress;
1302     uint256 private USDETHRate;
1303 
1304     mapping (address => bool) public blacklisted;
1305 
1306     JavvyToken token;
1307     
1308     enum Stage {
1309         NotStarted,
1310         PreICO,
1311         ICO,
1312         AfterICO
1313     }
1314 
1315     function getStage() public view returns (Stage) {
1316         // solium-disable-next-line security/no-block-members
1317         uint256 blockTime = block.timestamp;
1318         if (blockTime < openingTime) return Stage.NotStarted;
1319         if (blockTime < icoStartTime) return Stage.PreICO;
1320         if (blockTime < closingTime) return Stage.ICO;
1321         else return Stage.AfterICO;
1322     }
1323 
1324     constructor(
1325         uint256 _rate,  
1326         JavvyMultiSig _wallet,
1327         JavvyToken _token,
1328         uint256 _cap,  // Should be in USD!
1329         uint256 _goal,
1330         address _bonusAddress,
1331         address[] _blacklistAddresses,
1332         uint256 _USDETHRate
1333     ) 
1334     Crowdsale(_rate, _wallet, _token)
1335     CappedCrowdsale(_cap)
1336     TimedCrowdsale(getStartPreIco(), getEndIco())
1337     RefundableCrowdsale(_goal)
1338     public {
1339         require(getStartIco() > block.timestamp, "ICO has to begin in the future");
1340         require(getEndIco() > block.timestamp, "ICO has to end in the future");
1341         require(_goal <= _cap, "Soft cap should be equal or smaller than hard cap");
1342         icoStartTime = getStartIco();
1343         bonusAddress = _bonusAddress;
1344         token = _token;
1345         for (uint256 i = 0; i < _blacklistAddresses.length; i++) {
1346             blacklisted[_blacklistAddresses[i]] = true;
1347         }
1348         setUSDETHRate(_USDETHRate);
1349     }
1350 
1351     function buyTokens(address _beneficiary) public payable {
1352         require(!blacklisted[msg.sender], "Sender is blacklisted");
1353         bool preallocated = false;
1354         uint256 preallocatedTokens = 0;
1355 
1356         _buyTokens(
1357             _beneficiary, 
1358             msg.sender, 
1359             msg.value,
1360             preallocated,
1361             preallocatedTokens
1362         );
1363     }
1364 
1365     function bulkPreallocate(address[] _owners, uint256[] _tokens, uint256[] _paid)
1366     public
1367     onlyOwner() {
1368         require(
1369             _owners.length == _tokens.length,
1370             "Lengths of parameter lists have to be equal"
1371         );
1372         require(
1373             _owners.length == _paid.length,
1374             "Lengths of parameter lists have to be equal"
1375         );
1376         for (uint256 i=0; i< _owners.length; i++) {
1377             preallocate(_owners[i], _tokens[i], _paid[i]);
1378         }
1379     }
1380 
1381     function preallocate(address _owner, uint256 _tokens, uint256 _paid)
1382     public
1383     onlyOwner() {
1384         require(!blacklisted[_owner], "Address where tokens will be sent is blacklisted");
1385         bool preallocated = true;
1386         uint256 preallocatedTokens = _tokens;
1387 
1388         _buyTokens(
1389             _owner, 
1390             _owner, 
1391             _paid,
1392             preallocated,
1393             preallocatedTokens
1394         );
1395     }
1396 
1397     function setTransminingAddress(address _transminingAddress) public
1398     onlyOwner() {
1399         transminingAddress = _transminingAddress;
1400     }
1401 
1402     // Created for moving funds later to transmining address
1403     function moveTokensToTransmining(uint256 _amount) public
1404     onlyOwner() {
1405         uint256 remainingTokens = token.getRemainingSaleTokens();
1406         require(
1407             transminingAddress != address(0),
1408             "Transmining address must be set!"
1409         );
1410         require(
1411             remainingTokens >= _amount,
1412             "Balance of remaining tokens for sale is smaller than requested amount for trans-mining"
1413         );
1414         uint256 weiNeeded = cap - weiRaised;
1415         uint256 tokensNeeded = weiNeeded * rate;
1416         
1417         if (getStage() != Stage.AfterICO){
1418             require(remainingTokens - _amount > tokensNeeded, "You need to leave enough tokens to reach hard cap");
1419         }
1420         _deliverTokens(transminingAddress, _amount, this);
1421     }
1422 
1423     function _buyTokens(
1424         address _beneficiary, 
1425         address _sender, 
1426         uint256 _value,
1427         bool _preallocated,
1428         uint256 _tokens
1429     ) internal
1430     whenNotPaused() {
1431         uint256 tokens;
1432         
1433         if (!_preallocated) {
1434             // pre validate params
1435             require(
1436                 _value >= minimalContributionAmount, 
1437                 "Amount contributed should be greater than required minimal contribution"
1438             );
1439             require(_tokens == 0, "Not preallocated tokens should be zero");
1440             _preValidatePurchase(_beneficiary, _value);
1441         } else {
1442             require(_tokens != 0, "Preallocated tokens should be greater than zero");
1443             require(weiRaised.add(_value) <= cap, "Raised tokens should not exceed hard cap");
1444         }
1445 
1446         // calculate tokens
1447         if (!_preallocated) {
1448             tokens = _getTokenAmount(_value);
1449         } else {
1450             tokens = _tokens;
1451         }
1452 
1453         // increase wei
1454         weiRaised = weiRaised.add(_value);
1455 
1456         _processPurchase(_beneficiary, tokens, this);
1457         
1458         emit TokenPurchase(
1459             _sender,
1460             _beneficiary,
1461             _value,
1462             tokens
1463         );
1464 
1465         // transfer payment
1466         _updatePurchasingState(_beneficiary, _value);
1467         _forwardFunds();
1468 
1469         // post validate
1470         if (!_preallocated) {
1471             _postValidatePurchase(_beneficiary, _value);
1472         }
1473     }
1474 
1475     function _getBaseTokens(uint256 _value) internal view returns (uint256) {
1476         return _value.mul(rate);
1477     }
1478 
1479     function _getTokenAmount(uint256 _weiAmount)
1480     internal view returns (uint256) {
1481         uint256 baseTokens = _getBaseTokens(_weiAmount);
1482         if (getStage() == Stage.PreICO) {
1483             return baseTokens.mul(100 + preIcoBonus).div(100);
1484         } else {
1485             return baseTokens;
1486         }
1487     }
1488 
1489     function _processPurchase(
1490         address _beneficiary,
1491         uint256 _tokenAmount,
1492         address _sourceAddress
1493     ) internal {
1494         _deliverTokens(_beneficiary, _tokenAmount, _sourceAddress);
1495     }
1496 
1497     function _deliverTokens(
1498         address _beneficiary,
1499         uint256 _tokenAmount,
1500         address _sourceAddress
1501     ) internal {
1502         if (_sourceAddress == address(this)) {
1503             token.transfer(_beneficiary, _tokenAmount);
1504         } else {
1505             token.transferFrom(_sourceAddress, _beneficiary, _tokenAmount);
1506         }
1507     }
1508 
1509     function finalization() internal {
1510         require(
1511             transminingAddress != address(0),
1512             "Transmining address must be set!"
1513         );
1514         super.finalization();
1515         
1516         _deliverTokens(transminingAddress, token.getRemainingSaleTokens(), this);
1517     }
1518 
1519     function setUSDETHRate(uint256 _USDETHRate) public 
1520     onlyOwner(){
1521         require(_USDETHRate > 0, "USDETH rate should not be zero");
1522         USDETHRate = _USDETHRate;
1523         cap = hardCapUSD * USDETHRate;
1524     }
1525 }