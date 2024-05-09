1 /**
2  * Copyright (c) 2018 blockimmo AG license@blockimmo.ch
3  * Non-Profit Open Software License 3.0 (NPOSL-3.0)
4  * https://opensource.org/licenses/NPOSL-3.0
5  */
6  
7 
8 pragma solidity 0.4.25;
9 
10 
11 /**
12  * @title SafeMath
13  * @dev Math operations with safety checks that throw on error
14  */
15 library SafeMath {
16 
17   /**
18   * @dev Multiplies two numbers, throws on overflow.
19   */
20   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
21     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
22     // benefit is lost if 'b' is also tested.
23     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
24     if (_a == 0) {
25       return 0;
26     }
27 
28     c = _a * _b;
29     assert(c / _a == _b);
30     return c;
31   }
32 
33   /**
34   * @dev Integer division of two numbers, truncating the quotient.
35   */
36   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
37     // assert(_b > 0); // Solidity automatically throws when dividing by 0
38     // uint256 c = _a / _b;
39     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
40     return _a / _b;
41   }
42 
43   /**
44   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45   */
46   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
47     assert(_b <= _a);
48     return _a - _b;
49   }
50 
51   /**
52   * @dev Adds two numbers, throws on overflow.
53   */
54   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
55     c = _a + _b;
56     assert(c >= _a);
57     return c;
58   }
59 }
60 
61 
62 /**
63  * @title ERC20Basic
64  * @dev Simpler version of ERC20 interface
65  * See https://github.com/ethereum/EIPs/issues/179
66  */
67 contract ERC20Basic {
68   function totalSupply() public view returns (uint256);
69   function balanceOf(address _who) public view returns (uint256);
70   function transfer(address _to, uint256 _value) public returns (bool);
71   event Transfer(address indexed from, address indexed to, uint256 value);
72 }
73 
74 
75 /**
76  * @title ERC20 interface
77  * @dev see https://github.com/ethereum/EIPs/issues/20
78  */
79 contract ERC20 is ERC20Basic {
80   function allowance(address _owner, address _spender)
81     public view returns (uint256);
82 
83   function transferFrom(address _from, address _to, uint256 _value)
84     public returns (bool);
85 
86   function approve(address _spender, uint256 _value) public returns (bool);
87   event Approval(
88     address indexed owner,
89     address indexed spender,
90     uint256 value
91   );
92 }
93 
94 
95 /**
96  * @title SafeERC20
97  * @dev Wrappers around ERC20 operations that throw on failure.
98  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
99  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
100  */
101 library SafeERC20 {
102   function safeTransfer(
103     ERC20Basic _token,
104     address _to,
105     uint256 _value
106   )
107     internal
108   {
109     require(_token.transfer(_to, _value));
110   }
111 
112   function safeTransferFrom(
113     ERC20 _token,
114     address _from,
115     address _to,
116     uint256 _value
117   )
118     internal
119   {
120     require(_token.transferFrom(_from, _to, _value));
121   }
122 
123   function safeApprove(
124     ERC20 _token,
125     address _spender,
126     uint256 _value
127   )
128     internal
129   {
130     require(_token.approve(_spender, _value));
131   }
132 }
133 
134 
135 /**
136  * @title Ownable
137  * @dev The Ownable contract has an owner address, and provides basic authorization control
138  * functions, this simplifies the implementation of "user permissions".
139  */
140 contract Ownable {
141   address public owner;
142 
143 
144   event OwnershipRenounced(address indexed previousOwner);
145   event OwnershipTransferred(
146     address indexed previousOwner,
147     address indexed newOwner
148   );
149 
150 
151   /**
152    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
153    * account.
154    */
155   constructor() public {
156     owner = msg.sender;
157   }
158 
159   /**
160    * @dev Throws if called by any account other than the owner.
161    */
162   modifier onlyOwner() {
163     require(msg.sender == owner);
164     _;
165   }
166 
167   /**
168    * @dev Allows the current owner to relinquish control of the contract.
169    * @notice Renouncing to ownership will leave the contract without an owner.
170    * It will not be possible to call the functions with the `onlyOwner`
171    * modifier anymore.
172    */
173   function renounceOwnership() public onlyOwner {
174     emit OwnershipRenounced(owner);
175     owner = address(0);
176   }
177 
178   /**
179    * @dev Allows the current owner to transfer control of the contract to a newOwner.
180    * @param _newOwner The address to transfer ownership to.
181    */
182   function transferOwnership(address _newOwner) public onlyOwner {
183     _transferOwnership(_newOwner);
184   }
185 
186   /**
187    * @dev Transfers control of the contract to a newOwner.
188    * @param _newOwner The address to transfer ownership to.
189    */
190   function _transferOwnership(address _newOwner) internal {
191     require(_newOwner != address(0));
192     emit OwnershipTransferred(owner, _newOwner);
193     owner = _newOwner;
194   }
195 }
196 
197 
198 /**
199  * @title Crowdsale
200  * @dev Crowdsale is a base contract for managing a token crowdsale,
201  * allowing investors to purchase tokens with ether. This contract implements
202  * such functionality in its most fundamental form and can be extended to provide additional
203  * functionality and/or custom behavior.
204  * The external interface represents the basic interface for purchasing tokens, and conform
205  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
206  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
207  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
208  * behavior.
209  */
210 contract Crowdsale {
211   using SafeMath for uint256;
212   using SafeERC20 for ERC20;
213 
214   // The token being sold
215   ERC20 public token;
216 
217   // Address where funds are collected
218   address public wallet;
219 
220   // How many token units a buyer gets per wei.
221   // The rate is the conversion between wei and the smallest and indivisible token unit.
222   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
223   // 1 wei will give you 1 unit, or 0.001 TOK.
224   uint256 public rate;
225 
226   // Amount of wei raised
227   uint256 public weiRaised;
228 
229   /**
230    * Event for token purchase logging
231    * @param purchaser who paid for the tokens
232    * @param beneficiary who got the tokens
233    * @param value weis paid for purchase
234    * @param amount amount of tokens purchased
235    */
236   event TokenPurchase(
237     address indexed purchaser,
238     address indexed beneficiary,
239     uint256 value,
240     uint256 amount
241   );
242 
243   /**
244    * @param _rate Number of token units a buyer gets per wei
245    * @param _wallet Address where collected funds will be forwarded to
246    * @param _token Address of the token being sold
247    */
248   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
249     require(_rate > 0);
250     require(_wallet != address(0));
251     require(_token != address(0));
252 
253     rate = _rate;
254     wallet = _wallet;
255     token = _token;
256   }
257 
258   // -----------------------------------------
259   // Crowdsale external interface
260   // -----------------------------------------
261 
262   /**
263    * @dev fallback function ***DO NOT OVERRIDE***
264    */
265   function () external payable {
266     buyTokens(msg.sender);
267   }
268 
269   /**
270    * @dev low level token purchase ***DO NOT OVERRIDE***
271    * @param _beneficiary Address performing the token purchase
272    */
273   function buyTokens(address _beneficiary) public payable {
274 
275     uint256 weiAmount = msg.value;
276     _preValidatePurchase(_beneficiary, weiAmount);
277 
278     // calculate token amount to be created
279     uint256 tokens = _getTokenAmount(weiAmount);
280 
281     // update state
282     weiRaised = weiRaised.add(weiAmount);
283 
284     _processPurchase(_beneficiary, tokens);
285     emit TokenPurchase(
286       msg.sender,
287       _beneficiary,
288       weiAmount,
289       tokens
290     );
291 
292     _updatePurchasingState(_beneficiary, weiAmount);
293 
294     _forwardFunds();
295     _postValidatePurchase(_beneficiary, weiAmount);
296   }
297 
298   // -----------------------------------------
299   // Internal interface (extensible)
300   // -----------------------------------------
301 
302   /**
303    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
304    * Example from CappedCrowdsale.sol's _preValidatePurchase method: 
305    *   super._preValidatePurchase(_beneficiary, _weiAmount);
306    *   require(weiRaised.add(_weiAmount) <= cap);
307    * @param _beneficiary Address performing the token purchase
308    * @param _weiAmount Value in wei involved in the purchase
309    */
310   function _preValidatePurchase(
311     address _beneficiary,
312     uint256 _weiAmount
313   )
314     internal
315   {
316     require(_beneficiary != address(0));
317     require(_weiAmount != 0);
318   }
319 
320   /**
321    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
322    * @param _beneficiary Address performing the token purchase
323    * @param _weiAmount Value in wei involved in the purchase
324    */
325   function _postValidatePurchase(
326     address _beneficiary,
327     uint256 _weiAmount
328   )
329     internal
330   {
331     // optional override
332   }
333 
334   /**
335    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
336    * @param _beneficiary Address performing the token purchase
337    * @param _tokenAmount Number of tokens to be emitted
338    */
339   function _deliverTokens(
340     address _beneficiary,
341     uint256 _tokenAmount
342   )
343     internal
344   {
345     token.safeTransfer(_beneficiary, _tokenAmount);
346   }
347 
348   /**
349    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
350    * @param _beneficiary Address receiving the tokens
351    * @param _tokenAmount Number of tokens to be purchased
352    */
353   function _processPurchase(
354     address _beneficiary,
355     uint256 _tokenAmount
356   )
357     internal
358   {
359     _deliverTokens(_beneficiary, _tokenAmount);
360   }
361 
362   /**
363    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
364    * @param _beneficiary Address receiving the tokens
365    * @param _weiAmount Value in wei involved in the purchase
366    */
367   function _updatePurchasingState(
368     address _beneficiary,
369     uint256 _weiAmount
370   )
371     internal
372   {
373     // optional override
374   }
375 
376   /**
377    * @dev Override to extend the way in which ether is converted to tokens.
378    * @param _weiAmount Value in wei to be converted into tokens
379    * @return Number of tokens that can be purchased with the specified _weiAmount
380    */
381   function _getTokenAmount(uint256 _weiAmount)
382     internal view returns (uint256)
383   {
384     return _weiAmount.mul(rate);
385   }
386 
387   /**
388    * @dev Determines how ETH is stored/forwarded on purchases.
389    */
390   function _forwardFunds() internal {
391     wallet.transfer(msg.value);
392   }
393 }
394 
395 
396 /**
397  * @title TimedCrowdsale
398  * @dev Crowdsale accepting contributions only within a time frame.
399  */
400 contract TimedCrowdsale is Crowdsale {
401   using SafeMath for uint256;
402 
403   uint256 public openingTime;
404   uint256 public closingTime;
405 
406   /**
407    * @dev Reverts if not in crowdsale time range.
408    */
409   modifier onlyWhileOpen {
410     // solium-disable-next-line security/no-block-members
411     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
412     _;
413   }
414 
415   /**
416    * @dev Constructor, takes crowdsale opening and closing times.
417    * @param _openingTime Crowdsale opening time
418    * @param _closingTime Crowdsale closing time
419    */
420   constructor(uint256 _openingTime, uint256 _closingTime) public {
421     // solium-disable-next-line security/no-block-members
422     require(_openingTime >= block.timestamp);
423     require(_closingTime >= _openingTime);
424 
425     openingTime = _openingTime;
426     closingTime = _closingTime;
427   }
428 
429   /**
430    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
431    * @return Whether crowdsale period has elapsed
432    */
433   function hasClosed() public view returns (bool) {
434     // solium-disable-next-line security/no-block-members
435     return block.timestamp > closingTime;
436   }
437 
438   /**
439    * @dev Extend parent behavior requiring to be within contributing period
440    * @param _beneficiary Token purchaser
441    * @param _weiAmount Amount of wei contributed
442    */
443   function _preValidatePurchase(
444     address _beneficiary,
445     uint256 _weiAmount
446   )
447     internal
448     onlyWhileOpen
449   {
450     super._preValidatePurchase(_beneficiary, _weiAmount);
451   }
452 
453 }
454 
455 
456 /**
457  * @title PostDeliveryCrowdsale
458  * @dev Crowdsale that locks tokens from withdrawal until it ends.
459  */
460 contract PostDeliveryCrowdsale is TimedCrowdsale {
461   using SafeMath for uint256;
462 
463   mapping(address => uint256) public balances;
464 
465   /**
466    * @dev Withdraw tokens only after crowdsale ends.
467    */
468   function withdrawTokens() public {
469     require(hasClosed());
470     uint256 amount = balances[msg.sender];
471     require(amount > 0);
472     balances[msg.sender] = 0;
473     _deliverTokens(msg.sender, amount);
474   }
475 
476   /**
477    * @dev Overrides parent by storing balances instead of issuing tokens right away.
478    * @param _beneficiary Token purchaser
479    * @param _tokenAmount Amount of tokens purchased
480    */
481   function _processPurchase(
482     address _beneficiary,
483     uint256 _tokenAmount
484   )
485     internal
486   {
487     balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);
488   }
489 
490 }
491 
492 
493 /**
494  * @title FinalizableCrowdsale
495  * @dev Extension of Crowdsale where an owner can do extra work
496  * after finishing.
497  */
498 contract FinalizableCrowdsale is Ownable, TimedCrowdsale {
499   using SafeMath for uint256;
500 
501   bool public isFinalized = false;
502 
503   event Finalized();
504 
505   /**
506    * @dev Must be called after crowdsale ends, to do some extra finalization
507    * work. Calls the contract's finalization function.
508    */
509   function finalize() public onlyOwner {
510     require(!isFinalized);
511     require(hasClosed());
512 
513     finalization();
514     emit Finalized();
515 
516     isFinalized = true;
517   }
518 
519   /**
520    * @dev Can be overridden to add finalization logic. The overriding function
521    * should call super.finalization() to ensure the chain of finalization is
522    * executed entirely.
523    */
524   function finalization() internal {
525   }
526 
527 }
528 
529 
530 /**
531  * @title Escrow
532  * @dev Base escrow contract, holds funds destinated to a payee until they
533  * withdraw them. The contract that uses the escrow as its payment method
534  * should be its owner, and provide public methods redirecting to the escrow's
535  * deposit and withdraw.
536  */
537 contract Escrow is Ownable {
538   using SafeMath for uint256;
539 
540   event Deposited(address indexed payee, uint256 weiAmount);
541   event Withdrawn(address indexed payee, uint256 weiAmount);
542 
543   mapping(address => uint256) private deposits;
544 
545   function depositsOf(address _payee) public view returns (uint256) {
546     return deposits[_payee];
547   }
548 
549   /**
550   * @dev Stores the sent amount as credit to be withdrawn.
551   * @param _payee The destination address of the funds.
552   */
553   function deposit(address _payee) public onlyOwner payable {
554     uint256 amount = msg.value;
555     deposits[_payee] = deposits[_payee].add(amount);
556 
557     emit Deposited(_payee, amount);
558   }
559 
560   /**
561   * @dev Withdraw accumulated balance for a payee.
562   * @param _payee The address whose funds will be withdrawn and transferred to.
563   */
564   function withdraw(address _payee) public onlyOwner {
565     uint256 payment = deposits[_payee];
566     assert(address(this).balance >= payment);
567 
568     deposits[_payee] = 0;
569 
570     _payee.transfer(payment);
571 
572     emit Withdrawn(_payee, payment);
573   }
574 }
575 
576 
577 /**
578  * @title ConditionalEscrow
579  * @dev Base abstract escrow to only allow withdrawal if a condition is met.
580  */
581 contract ConditionalEscrow is Escrow {
582   /**
583   * @dev Returns whether an address is allowed to withdraw their funds. To be
584   * implemented by derived contracts.
585   * @param _payee The destination address of the funds.
586   */
587   function withdrawalAllowed(address _payee) public view returns (bool);
588 
589   function withdraw(address _payee) public {
590     require(withdrawalAllowed(_payee));
591     super.withdraw(_payee);
592   }
593 }
594 
595 
596 /**
597  * @title RefundEscrow
598  * @dev Escrow that holds funds for a beneficiary, deposited from multiple parties.
599  * The contract owner may close the deposit period, and allow for either withdrawal
600  * by the beneficiary, or refunds to the depositors.
601  */
602 contract RefundEscrow is Ownable, ConditionalEscrow {
603   enum State { Active, Refunding, Closed }
604 
605   event Closed();
606   event RefundsEnabled();
607 
608   State public state;
609   address public beneficiary;
610 
611   /**
612    * @dev Constructor.
613    * @param _beneficiary The beneficiary of the deposits.
614    */
615   constructor(address _beneficiary) public {
616     require(_beneficiary != address(0));
617     beneficiary = _beneficiary;
618     state = State.Active;
619   }
620 
621   /**
622    * @dev Stores funds that may later be refunded.
623    * @param _refundee The address funds will be sent to if a refund occurs.
624    */
625   function deposit(address _refundee) public payable {
626     require(state == State.Active);
627     super.deposit(_refundee);
628   }
629 
630   /**
631    * @dev Allows for the beneficiary to withdraw their funds, rejecting
632    * further deposits.
633    */
634   function close() public onlyOwner {
635     require(state == State.Active);
636     state = State.Closed;
637     emit Closed();
638   }
639 
640   /**
641    * @dev Allows for refunds to take place, rejecting further deposits.
642    */
643   function enableRefunds() public onlyOwner {
644     require(state == State.Active);
645     state = State.Refunding;
646     emit RefundsEnabled();
647   }
648 
649   /**
650    * @dev Withdraws the beneficiary's funds.
651    */
652   function beneficiaryWithdraw() public {
653     require(state == State.Closed);
654     beneficiary.transfer(address(this).balance);
655   }
656 
657   /**
658    * @dev Returns whether refundees can withdraw their deposits (be refunded).
659    */
660   function withdrawalAllowed(address _payee) public view returns (bool) {
661     return state == State.Refunding;
662   }
663 }
664 
665 
666 /**
667  * @title RefundableCrowdsale
668  * @dev Extension of Crowdsale contract that adds a funding goal, and
669  * the possibility of users getting a refund if goal is not met.
670  */
671 contract RefundableCrowdsale is FinalizableCrowdsale {
672   using SafeMath for uint256;
673 
674   // minimum amount of funds to be raised in weis
675   uint256 public goal;
676 
677   // refund escrow used to hold funds while crowdsale is running
678   RefundEscrow private escrow;
679 
680   /**
681    * @dev Constructor, creates RefundEscrow.
682    * @param _goal Funding goal
683    */
684   constructor(uint256 _goal) public {
685     require(_goal > 0);
686     escrow = new RefundEscrow(wallet);
687     goal = _goal;
688   }
689 
690   /**
691    * @dev Investors can claim refunds here if crowdsale is unsuccessful
692    */
693   function claimRefund() public {
694     require(isFinalized);
695     require(!goalReached());
696 
697     escrow.withdraw(msg.sender);
698   }
699 
700   /**
701    * @dev Checks whether funding goal was reached.
702    * @return Whether funding goal was reached
703    */
704   function goalReached() public view returns (bool) {
705     return weiRaised >= goal;
706   }
707 
708   /**
709    * @dev escrow finalization task, called when owner calls finalize()
710    */
711   function finalization() internal {
712     if (goalReached()) {
713       escrow.close();
714       escrow.beneficiaryWithdraw();
715     } else {
716       escrow.enableRefunds();
717     }
718 
719     super.finalization();
720   }
721 
722   /**
723    * @dev Overrides Crowdsale fund forwarding, sending funds to escrow.
724    */
725   function _forwardFunds() internal {
726     escrow.deposit.value(msg.value)(msg.sender);
727   }
728 
729 }
730 
731 
732 contract MedianizerInterface {
733   function read() public view returns (bytes32);
734 }
735 
736 
737 contract WhitelistInterface {
738   function checkRole(address _operator, string _role) public view;
739   function hasRole(address _operator, string _role) public view returns (bool);
740 }
741 
742 
743 contract WhitelistProxyInterface {
744   function whitelist() public view returns (WhitelistInterface);
745 }
746 
747 
748 /**
749  * @title TokenSale
750  * @dev Distribute tokens to investors in exchange for Ether.
751  *
752  * This is the primary mechanism for outright sales of commercial investment properties (and blockimmo's STO, where shares
753  * of our company are represented as `TokenizedProperty`) (official pending FINMA approval).
754  *
755  * Selling:
756  *   1. Deploy `TokenizedProperty`. Initially all tokens and ownership of this property will be assigned to the 'deployer'
757  *   2. Deploy `ShareholderDAO` and transfer the property's (1) ownership to it
758  *   3. Configure and deploy a `TokenSale`
759  *     - After completing (1, 2, 3) blockimmo will verify the property as legitimate in `LandRegistry`
760  *     - blockimmo will then authorize `this` to the `Whitelist` before seller can proceed to (4)
761  *   4. Transfer tokens of `TokenizedProperty` (1) to be sold to `this` (3)
762  *   5. Investors are able to buy tokens while the sale is open. 'Deployer' calls `finalize` to complete the sale
763  *
764  * Note: blockimmo will be responsible for managing initial sales on our platform. This means we will be configuring
765  *       and deploying all contracts for sellers. This provides an extra layer of control/security until we've refined
766  *       these processes and proven them in the real-world.
767  *       Later sales will use SplitPayment contracts to route funds, with examples in the tests.
768  *
769  * Unsold tokens (of a successful sale) are redistributed proportionally to investors via Airdrop, as described in:
770  * https://medium.com/FundFantasy/airdropping-vs-burning-part-1-613a9c6ebf1c
771  *
772  * If a sale's soft-cap is not reached (and the seller does not `accept` a lower price), investors will be refunded Ether and the seller refunded tokens.
773  *
774  * For stable token sales (soft and hard-cap in USD instead of Wei), we rely on MakerDAO's on-chain ETH/USD conversion rate
775  * https://developer.makerdao.com/feeds/
776  * This approach to mitigating Ether volatility seems to best when analyzing trade-offs, short of selling directly in FIAT.
777  */
778 contract TokenSale is RefundableCrowdsale, PostDeliveryCrowdsale {
779   using SafeMath for uint256;
780   using SafeERC20 for ERC20;
781 
782   address public constant MEDIANIZER_ADDRESS = 0x729D19f657BD0614b4985Cf1D82531c67569197B;  // 0x0f5ea0a652e851678ebf77b69484bfcd31f9459b;
783   address public constant WHITELIST_PROXY_ADDRESS = 0x7223b032180CDb06Be7a3D634B1E10032111F367;  // 0xc4c7497fbe1a886841a195a5d622cd60053c1376;
784 
785   MedianizerInterface private medianizer = MedianizerInterface(MEDIANIZER_ADDRESS);
786   WhitelistProxyInterface private whitelistProxy = WhitelistProxyInterface(WHITELIST_PROXY_ADDRESS);
787 
788   uint256 public cap;
789   bool public goalReachedOnFinalize;
790   uint256 public totalTokens;
791   uint256 public totalTokensSold = 0;
792   bool public usd;
793 
794   mapping(address => uint256) public usdInvestment;
795 
796   constructor(
797     uint256 _openingTime,
798     uint256 _closingTime,
799     uint256 _rate,
800     address _wallet,
801     uint256 _cap,
802     ERC20 _token,
803     uint256 _goal,
804     bool _usd  // if true, both `goal` and `cap` are in units of USD. if false, in ETH
805   )
806     public
807     Crowdsale(_rate, _wallet, _token)
808     TimedCrowdsale(_openingTime, _closingTime)
809     RefundableCrowdsale(_goal)
810     PostDeliveryCrowdsale()
811   {
812     require(_cap > 0, "cap is not > 0");
813     require(_goal < _cap, "goal is not < cap");
814     cap = _cap;
815     usd = _usd;
816   }
817 
818   function capReached() public view returns (bool) {
819     return _reached(cap);
820   }
821 
822   function goalReached() public view returns (bool) {
823     if (isFinalized) {
824       return goalReachedOnFinalize;
825     } else {
826       return _reached(goal);
827     }
828   }
829 
830   function withdrawTokens() public {  // airdrop remaining tokens to investors proportionally
831     uint256 extra = totalTokens.sub(totalTokensSold).mul(balances[msg.sender]) / totalTokensSold;
832     balances[msg.sender] = balances[msg.sender].add(extra);
833     super.withdrawTokens();
834   }
835 
836   function finalization() internal {  // ether refunds enabled for investors, refund tokens to seller
837     totalTokens = token.balanceOf(address(this));
838     goalReachedOnFinalize = goalReached();
839     if (!goalReachedOnFinalize) {
840       token.safeTransfer(owner, totalTokens);
841     }
842     super.finalization();
843   }
844 
845   function _getUsdAmount(uint256 _weiAmount) internal view returns (uint256) {
846     uint256 usdPerEth = uint256(medianizer.read());
847     return _weiAmount.mul(usdPerEth).div(1e18).div(1e18);
848   }
849 
850   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
851     require(_weiAmount >= 1e18);
852     super._preValidatePurchase(_beneficiary, _weiAmount);
853 
854     WhitelistInterface whitelist = whitelistProxy.whitelist();
855 
856     usdInvestment[_beneficiary] = usdInvestment[_beneficiary].add(_getUsdAmount(_weiAmount));
857     if (!whitelist.hasRole(_beneficiary, "uncapped")) {
858       require(usdInvestment[_beneficiary] <= 100000);
859       whitelist.checkRole(_beneficiary, "authorized");
860     }
861 
862     if (usd) {
863       require(_getUsdAmount(weiRaised.add(_weiAmount)) <= cap, "usd raised must not exceed cap");
864     } else {
865       require(weiRaised.add(_weiAmount) <= cap, "wei raised must not exceed cap");
866     }
867   }
868 
869   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
870     totalTokensSold = totalTokensSold.add(_tokenAmount);
871     require(totalTokensSold <= token.balanceOf(address(this)), "totalTokensSold raised must not exceed balanceOf `this`");
872 
873     super._processPurchase(_beneficiary, _tokenAmount);
874   }
875 
876   function _reached(uint256 _target) internal view returns (bool) {
877     if (usd) {
878       return _getUsdAmount(weiRaised) >= _target;
879     } else {
880       return weiRaised >= _target;
881     }
882   }
883 }