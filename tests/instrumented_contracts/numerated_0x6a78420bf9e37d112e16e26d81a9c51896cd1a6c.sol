1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
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
55 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipRenounced(address indexed previousOwner);
67   event OwnershipTransferred(
68     address indexed previousOwner,
69     address indexed newOwner
70   );
71 
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   constructor() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to relinquish control of the contract.
91    * @notice Renouncing to ownership will leave the contract without an owner.
92    * It will not be possible to call the functions with the `onlyOwner`
93    * modifier anymore.
94    */
95   function renounceOwnership() public onlyOwner {
96     emit OwnershipRenounced(owner);
97     owner = address(0);
98   }
99 
100   /**
101    * @dev Allows the current owner to transfer control of the contract to a newOwner.
102    * @param _newOwner The address to transfer ownership to.
103    */
104   function transferOwnership(address _newOwner) public onlyOwner {
105     _transferOwnership(_newOwner);
106   }
107 
108   /**
109    * @dev Transfers control of the contract to a newOwner.
110    * @param _newOwner The address to transfer ownership to.
111    */
112   function _transferOwnership(address _newOwner) internal {
113     require(_newOwner != address(0));
114     emit OwnershipTransferred(owner, _newOwner);
115     owner = _newOwner;
116   }
117 }
118 
119 // File: openzeppelin-solidity/contracts/ownership/HasNoEther.sol
120 
121 /**
122  * @title Contracts that should not own Ether
123  * @author Remco Bloemen <remco@2π.com>
124  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
125  * in the contract, it will allow the owner to reclaim this Ether.
126  * @notice Ether can still be sent to this contract by:
127  * calling functions labeled `payable`
128  * `selfdestruct(contract_address)`
129  * mining directly to the contract address
130  */
131 contract HasNoEther is Ownable {
132 
133   /**
134   * @dev Constructor that rejects incoming Ether
135   * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
136   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
137   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
138   * we could use assembly to access msg.value.
139   */
140   constructor() public payable {
141     require(msg.value == 0);
142   }
143 
144   /**
145    * @dev Disallows direct send by setting a default function without the `payable` flag.
146    */
147   function() external {
148   }
149 
150   /**
151    * @dev Transfer all Ether held by the contract to the owner.
152    */
153   function reclaimEther() external onlyOwner {
154     owner.transfer(address(this).balance);
155   }
156 }
157 
158 // File: contracts/lifecycle/Finalizable.sol
159 
160 /**
161  * @title Finalizable contract
162  * @dev Lifecycle extension where an owner can do extra work after finishing.
163  */
164 contract Finalizable is Ownable {
165   using SafeMath for uint256;
166 
167   /// @dev Throws if called before the contract is finalized.
168   modifier onlyFinalized() {
169     require(isFinalized, "Contract not finalized.");
170     _;
171   }
172 
173   /// @dev Throws if called after the contract is finalized.
174   modifier onlyNotFinalized() {
175     require(!isFinalized, "Contract already finalized.");
176     _;
177   }
178 
179   bool public isFinalized = false;
180 
181   event Finalized();
182 
183   /**
184    * @dev Called by owner to do some extra finalization
185    * work. Calls the contract's finalization function.
186    */
187   function finalize() public onlyOwner onlyNotFinalized {
188     finalization();
189     emit Finalized();
190 
191     isFinalized = true;
192   }
193 
194   /**
195    * @dev Can be overridden to add finalization logic. The overriding function
196    * should call super.finalization() to ensure the chain of finalization is
197    * executed entirely.
198    */
199   function finalization() internal {
200     // override
201   }
202 
203 }
204 
205 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
206 
207 /**
208  * @title ERC20Basic
209  * @dev Simpler version of ERC20 interface
210  * See https://github.com/ethereum/EIPs/issues/179
211  */
212 contract ERC20Basic {
213   function totalSupply() public view returns (uint256);
214   function balanceOf(address _who) public view returns (uint256);
215   function transfer(address _to, uint256 _value) public returns (bool);
216   event Transfer(address indexed from, address indexed to, uint256 value);
217 }
218 
219 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
220 
221 /**
222  * @title ERC20 interface
223  * @dev see https://github.com/ethereum/EIPs/issues/20
224  */
225 contract ERC20 is ERC20Basic {
226   function allowance(address _owner, address _spender)
227     public view returns (uint256);
228 
229   function transferFrom(address _from, address _to, uint256 _value)
230     public returns (bool);
231 
232   function approve(address _spender, uint256 _value) public returns (bool);
233   event Approval(
234     address indexed owner,
235     address indexed spender,
236     uint256 value
237   );
238 }
239 
240 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
241 
242 /**
243  * @title SafeERC20
244  * @dev Wrappers around ERC20 operations that throw on failure.
245  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
246  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
247  */
248 library SafeERC20 {
249   function safeTransfer(
250     ERC20Basic _token,
251     address _to,
252     uint256 _value
253   )
254     internal
255   {
256     require(_token.transfer(_to, _value));
257   }
258 
259   function safeTransferFrom(
260     ERC20 _token,
261     address _from,
262     address _to,
263     uint256 _value
264   )
265     internal
266   {
267     require(_token.transferFrom(_from, _to, _value));
268   }
269 
270   function safeApprove(
271     ERC20 _token,
272     address _spender,
273     uint256 _value
274   )
275     internal
276   {
277     require(_token.approve(_spender, _value));
278   }
279 }
280 
281 // File: contracts/payment/TokenEscrow.sol
282 
283 /**
284  * @title TokenEscrow
285  * @dev Base token escrow contract, holds funds destinated to a payee until they
286  * withdraw them. The contract that uses the escrow as its payment method
287  * should be its owner, and provide public methods redirecting to the escrow's
288  * deposit and withdraw.
289  */
290 contract TokenEscrow is Ownable {
291   using SafeMath for uint256;
292   using SafeERC20 for ERC20;
293 
294   event Deposited(address indexed payee, uint256 amount);
295   event Withdrawn(address indexed payee, uint256 amount);
296 
297   // deposits of the beneficiaries of tokens
298   mapping(address => uint256) private deposits;
299 
300   // ERC20 token contract being held
301   ERC20 public token;
302 
303   constructor(ERC20 _token) public {
304     require(_token != address(0), "Token address should not be 0x0.");
305     token = _token;
306   }
307 
308   /**
309    * @dev Returns the token accumulated balance for a payee.
310    * @param _payee The destination address of the tokens.
311    */
312   function depositsOf(address _payee) public view returns (uint256) {
313     return deposits[_payee];
314   }
315 
316   /**
317    * @dev Stores the token amount as credit to be withdrawn.
318    * @param _payee The destination address of the tokens.
319    * @param _amount The amount of tokens that can be pulled.
320    */
321   function deposit(address _payee, uint256 _amount) public onlyOwner {
322     require(_payee != address(0), "Destination address should not be 0x0.");
323     require(_payee != address(this), "Deposits should not be made to this contract.");
324 
325     deposits[_payee] = deposits[_payee].add(_amount);
326     token.safeTransferFrom(owner, this, _amount);
327 
328     emit Deposited(_payee, _amount);
329   }
330 
331   /**
332    * @dev Withdraw accumulated balance for a payee.
333    * @param _payee The address whose tokens will be withdrawn and transferred to.
334    */
335   function withdraw(address _payee) public onlyOwner {
336     uint256 payment = deposits[_payee];
337     assert(token.balanceOf(address(this)) >= payment);
338 
339     deposits[_payee] = 0;
340     token.safeTransfer(_payee, payment);
341 
342     emit Withdrawn(_payee, payment);
343   }
344 }
345 
346 // File: contracts/payment/TokenConditionalEscrow.sol
347 
348 /**
349  * @title ConditionalEscrow
350  * @dev Base abstract escrow to only allow withdrawal if a condition is met.
351  */
352 contract TokenConditionalEscrow is TokenEscrow {
353 
354   /**
355    * @dev Returns whether an address is allowed to withdraw their tokens. To be
356    * implemented by derived contracts.
357    * @param _payee The destination address of the tokens.
358    */
359   function withdrawalAllowed(address _payee) public view returns (bool);
360 
361   /**
362    * @dev Withdraw accumulated balance for a payee if allowed.
363    * @param _payee The address whose tokens will be withdrawn and transferred to.
364    */
365   function withdraw(address _payee) public {
366     require(withdrawalAllowed(_payee), "Withdrawal is not allowed.");
367     super.withdraw(_payee);
368   }
369 }
370 
371 // File: contracts/payment/TokenTimelockEscrow.sol
372 
373 /**
374  * @title TokenTimelockEscrow
375  * @dev Token escrow to only allow withdrawal only if the lock period
376  * has expired. As only the owner can make deposits and withdrawals
377  * this contract should be owned by the crowdsale, which can then
378  * perform deposits and withdrawals for individual users.
379  */
380 contract TokenTimelockEscrow is TokenConditionalEscrow {
381 
382   // timestamp when token release is enabled
383   uint256 public releaseTime;
384 
385   constructor(uint256 _releaseTime) public {
386     // solium-disable-next-line security/no-block-members
387     require(_releaseTime > block.timestamp, "Release time should be in the future.");
388     releaseTime = _releaseTime;
389   }
390 
391   /**
392    * @dev Returns whether an address is allowed to withdraw their tokens.
393    * @param _payee The destination address of the tokens.
394    */
395   function withdrawalAllowed(address _payee) public view returns (bool) {
396     // solium-disable-next-line security/no-block-members
397     return block.timestamp >= releaseTime;
398   }
399 }
400 
401 // File: contracts/payment/TokenTimelockFactory.sol
402 
403 /**
404  * @title TokenTimelockFactory
405  * @dev Allows creation of timelock wallet.
406  */
407 contract TokenTimelockFactory {
408 
409   /**
410    * @dev Allows verified creation of token timelock wallet.
411    * @param _token Address of the token being locked.
412    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred.
413    * @param _releaseTime The release times after which the tokens can be withdrawn.
414    * @return Returns wallet address.
415    */
416   function create(
417     ERC20 _token,
418     address _beneficiary,
419     uint256 _releaseTime
420   )
421     public
422     returns (address wallet);
423 }
424 
425 // File: contracts/payment/TokenVestingFactory.sol
426 
427 /**
428  * @title TokenVestingFactory
429  * @dev Allows creation of token vesting wallet.
430  */
431 contract TokenVestingFactory {
432 
433   /**
434    * @dev Allows verified creation of token vesting wallet.
435    * Creates a vesting contract that vests its balance of any ERC20 token to the
436    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
437    * of the balance will have vested.
438    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
439    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
440    * @param _start the time (as Unix time) at which point vesting starts
441    * @param _duration duration in seconds of the period in which the tokens will vest
442    * @param _revocable whether the vesting is revocable or not
443    * @return Returns wallet address.
444    */
445   function create(
446     address _beneficiary,
447     uint256 _start,
448     uint256 _cliff,
449     uint256 _duration,
450     bool _revocable
451   )
452     public
453     returns (address wallet);
454 }
455 
456 // File: openzeppelin-solidity/contracts/ownership/HasNoContracts.sol
457 
458 /**
459  * @title Contracts that should not own Contracts
460  * @author Remco Bloemen <remco@2π.com>
461  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
462  * of this contract to reclaim ownership of the contracts.
463  */
464 contract HasNoContracts is Ownable {
465 
466   /**
467    * @dev Reclaim ownership of Ownable contracts
468    * @param _contractAddr The address of the Ownable to be reclaimed.
469    */
470   function reclaimContract(address _contractAddr) external onlyOwner {
471     Ownable contractInst = Ownable(_contractAddr);
472     contractInst.transferOwnership(owner);
473   }
474 }
475 
476 // File: contracts/TokenTimelockEscrowImpl.sol
477 
478 /// @title TokenTimelockEscrowImpl
479 contract TokenTimelockEscrowImpl is HasNoEther, HasNoContracts, TokenTimelockEscrow {
480 
481   constructor(ERC20 _token, uint256 _releaseTime)
482     public
483     TokenEscrow(_token)
484     TokenTimelockEscrow(_releaseTime)
485   {
486     // constructor
487   }
488 }
489 
490 // File: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol
491 
492 /**
493  * @title Contracts that should be able to recover tokens
494  * @author SylTi
495  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
496  * This will prevent any accidental loss of tokens.
497  */
498 contract CanReclaimToken is Ownable {
499   using SafeERC20 for ERC20Basic;
500 
501   /**
502    * @dev Reclaim all ERC20Basic compatible tokens
503    * @param _token ERC20Basic The address of the token contract
504    */
505   function reclaimToken(ERC20Basic _token) external onlyOwner {
506     uint256 balance = _token.balanceOf(this);
507     _token.safeTransfer(owner, balance);
508   }
509 
510 }
511 
512 // File: openzeppelin-solidity/contracts/ownership/HasNoTokens.sol
513 
514 /**
515  * @title Contracts that should not own Tokens
516  * @author Remco Bloemen <remco@2π.com>
517  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
518  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
519  * owner to reclaim the tokens.
520  */
521 contract HasNoTokens is CanReclaimToken {
522 
523  /**
524   * @dev Reject all ERC223 compatible tokens
525   * @param _from address The address that is transferring the tokens
526   * @param _value uint256 the amount of the specified token
527   * @param _data Bytes The data passed from the caller.
528   */
529   function tokenFallback(
530     address _from,
531     uint256 _value,
532     bytes _data
533   )
534     external
535     pure
536   {
537     _from;
538     _value;
539     _data;
540     revert();
541   }
542 
543 }
544 
545 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
546 
547 /**
548  * @title Crowdsale
549  * @dev Crowdsale is a base contract for managing a token crowdsale,
550  * allowing investors to purchase tokens with ether. This contract implements
551  * such functionality in its most fundamental form and can be extended to provide additional
552  * functionality and/or custom behavior.
553  * The external interface represents the basic interface for purchasing tokens, and conform
554  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
555  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
556  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
557  * behavior.
558  */
559 contract Crowdsale {
560   using SafeMath for uint256;
561   using SafeERC20 for ERC20;
562 
563   // The token being sold
564   ERC20 public token;
565 
566   // Address where funds are collected
567   address public wallet;
568 
569   // How many token units a buyer gets per wei.
570   // The rate is the conversion between wei and the smallest and indivisible token unit.
571   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
572   // 1 wei will give you 1 unit, or 0.001 TOK.
573   uint256 public rate;
574 
575   // Amount of wei raised
576   uint256 public weiRaised;
577 
578   /**
579    * Event for token purchase logging
580    * @param purchaser who paid for the tokens
581    * @param beneficiary who got the tokens
582    * @param value weis paid for purchase
583    * @param amount amount of tokens purchased
584    */
585   event TokenPurchase(
586     address indexed purchaser,
587     address indexed beneficiary,
588     uint256 value,
589     uint256 amount
590   );
591 
592   /**
593    * @param _rate Number of token units a buyer gets per wei
594    * @param _wallet Address where collected funds will be forwarded to
595    * @param _token Address of the token being sold
596    */
597   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
598     require(_rate > 0);
599     require(_wallet != address(0));
600     require(_token != address(0));
601 
602     rate = _rate;
603     wallet = _wallet;
604     token = _token;
605   }
606 
607   // -----------------------------------------
608   // Crowdsale external interface
609   // -----------------------------------------
610 
611   /**
612    * @dev fallback function ***DO NOT OVERRIDE***
613    */
614   function () external payable {
615     buyTokens(msg.sender);
616   }
617 
618   /**
619    * @dev low level token purchase ***DO NOT OVERRIDE***
620    * @param _beneficiary Address performing the token purchase
621    */
622   function buyTokens(address _beneficiary) public payable {
623 
624     uint256 weiAmount = msg.value;
625     _preValidatePurchase(_beneficiary, weiAmount);
626 
627     // calculate token amount to be created
628     uint256 tokens = _getTokenAmount(weiAmount);
629 
630     // update state
631     weiRaised = weiRaised.add(weiAmount);
632 
633     _processPurchase(_beneficiary, tokens);
634     emit TokenPurchase(
635       msg.sender,
636       _beneficiary,
637       weiAmount,
638       tokens
639     );
640 
641     _updatePurchasingState(_beneficiary, weiAmount);
642 
643     _forwardFunds();
644     _postValidatePurchase(_beneficiary, weiAmount);
645   }
646 
647   // -----------------------------------------
648   // Internal interface (extensible)
649   // -----------------------------------------
650 
651   /**
652    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
653    * Example from CappedCrowdsale.sol's _preValidatePurchase method: 
654    *   super._preValidatePurchase(_beneficiary, _weiAmount);
655    *   require(weiRaised.add(_weiAmount) <= cap);
656    * @param _beneficiary Address performing the token purchase
657    * @param _weiAmount Value in wei involved in the purchase
658    */
659   function _preValidatePurchase(
660     address _beneficiary,
661     uint256 _weiAmount
662   )
663     internal
664   {
665     require(_beneficiary != address(0));
666     require(_weiAmount != 0);
667   }
668 
669   /**
670    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
671    * @param _beneficiary Address performing the token purchase
672    * @param _weiAmount Value in wei involved in the purchase
673    */
674   function _postValidatePurchase(
675     address _beneficiary,
676     uint256 _weiAmount
677   )
678     internal
679   {
680     // optional override
681   }
682 
683   /**
684    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
685    * @param _beneficiary Address performing the token purchase
686    * @param _tokenAmount Number of tokens to be emitted
687    */
688   function _deliverTokens(
689     address _beneficiary,
690     uint256 _tokenAmount
691   )
692     internal
693   {
694     token.safeTransfer(_beneficiary, _tokenAmount);
695   }
696 
697   /**
698    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
699    * @param _beneficiary Address receiving the tokens
700    * @param _tokenAmount Number of tokens to be purchased
701    */
702   function _processPurchase(
703     address _beneficiary,
704     uint256 _tokenAmount
705   )
706     internal
707   {
708     _deliverTokens(_beneficiary, _tokenAmount);
709   }
710 
711   /**
712    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
713    * @param _beneficiary Address receiving the tokens
714    * @param _weiAmount Value in wei involved in the purchase
715    */
716   function _updatePurchasingState(
717     address _beneficiary,
718     uint256 _weiAmount
719   )
720     internal
721   {
722     // optional override
723   }
724 
725   /**
726    * @dev Override to extend the way in which ether is converted to tokens.
727    * @param _weiAmount Value in wei to be converted into tokens
728    * @return Number of tokens that can be purchased with the specified _weiAmount
729    */
730   function _getTokenAmount(uint256 _weiAmount)
731     internal view returns (uint256)
732   {
733     return _weiAmount.mul(rate);
734   }
735 
736   /**
737    * @dev Determines how ETH is stored/forwarded on purchases.
738    */
739   function _forwardFunds() internal {
740     wallet.transfer(msg.value);
741   }
742 }
743 
744 // File: openzeppelin-solidity/contracts/crowdsale/validation/IndividuallyCappedCrowdsale.sol
745 
746 /**
747  * @title IndividuallyCappedCrowdsale
748  * @dev Crowdsale with per-user caps.
749  */
750 contract IndividuallyCappedCrowdsale is Ownable, Crowdsale {
751   using SafeMath for uint256;
752 
753   mapping(address => uint256) public contributions;
754   mapping(address => uint256) public caps;
755 
756   /**
757    * @dev Sets a specific user's maximum contribution.
758    * @param _beneficiary Address to be capped
759    * @param _cap Wei limit for individual contribution
760    */
761   function setUserCap(address _beneficiary, uint256 _cap) external onlyOwner {
762     caps[_beneficiary] = _cap;
763   }
764 
765   /**
766    * @dev Sets a group of users' maximum contribution.
767    * @param _beneficiaries List of addresses to be capped
768    * @param _cap Wei limit for individual contribution
769    */
770   function setGroupCap(
771     address[] _beneficiaries,
772     uint256 _cap
773   )
774     external
775     onlyOwner
776   {
777     for (uint256 i = 0; i < _beneficiaries.length; i++) {
778       caps[_beneficiaries[i]] = _cap;
779     }
780   }
781 
782   /**
783    * @dev Returns the cap of a specific user.
784    * @param _beneficiary Address whose cap is to be checked
785    * @return Current cap for individual user
786    */
787   function getUserCap(address _beneficiary) public view returns (uint256) {
788     return caps[_beneficiary];
789   }
790 
791   /**
792    * @dev Returns the amount contributed so far by a sepecific user.
793    * @param _beneficiary Address of contributor
794    * @return User contribution so far
795    */
796   function getUserContribution(address _beneficiary)
797     public view returns (uint256)
798   {
799     return contributions[_beneficiary];
800   }
801 
802   /**
803    * @dev Extend parent behavior requiring purchase to respect the user's funding cap.
804    * @param _beneficiary Token purchaser
805    * @param _weiAmount Amount of wei contributed
806    */
807   function _preValidatePurchase(
808     address _beneficiary,
809     uint256 _weiAmount
810   )
811     internal
812   {
813     super._preValidatePurchase(_beneficiary, _weiAmount);
814     require(contributions[_beneficiary].add(_weiAmount) <= caps[_beneficiary]);
815   }
816 
817   /**
818    * @dev Extend parent behavior to update user contributions
819    * @param _beneficiary Token purchaser
820    * @param _weiAmount Amount of wei contributed
821    */
822   function _updatePurchasingState(
823     address _beneficiary,
824     uint256 _weiAmount
825   )
826     internal
827   {
828     super._updatePurchasingState(_beneficiary, _weiAmount);
829     contributions[_beneficiary] = contributions[_beneficiary].add(_weiAmount);
830   }
831 
832 }
833 
834 // File: openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
835 
836 /**
837  * @title CappedCrowdsale
838  * @dev Crowdsale with a limit for total contributions.
839  */
840 contract CappedCrowdsale is Crowdsale {
841   using SafeMath for uint256;
842 
843   uint256 public cap;
844 
845   /**
846    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
847    * @param _cap Max amount of wei to be contributed
848    */
849   constructor(uint256 _cap) public {
850     require(_cap > 0);
851     cap = _cap;
852   }
853 
854   /**
855    * @dev Checks whether the cap has been reached.
856    * @return Whether the cap was reached
857    */
858   function capReached() public view returns (bool) {
859     return weiRaised >= cap;
860   }
861 
862   /**
863    * @dev Extend parent behavior requiring purchase to respect the funding cap.
864    * @param _beneficiary Token purchaser
865    * @param _weiAmount Amount of wei contributed
866    */
867   function _preValidatePurchase(
868     address _beneficiary,
869     uint256 _weiAmount
870   )
871     internal
872   {
873     super._preValidatePurchase(_beneficiary, _weiAmount);
874     require(weiRaised.add(_weiAmount) <= cap);
875   }
876 
877 }
878 
879 // File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
880 
881 /**
882  * @title TimedCrowdsale
883  * @dev Crowdsale accepting contributions only within a time frame.
884  */
885 contract TimedCrowdsale is Crowdsale {
886   using SafeMath for uint256;
887 
888   uint256 public openingTime;
889   uint256 public closingTime;
890 
891   /**
892    * @dev Reverts if not in crowdsale time range.
893    */
894   modifier onlyWhileOpen {
895     // solium-disable-next-line security/no-block-members
896     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
897     _;
898   }
899 
900   /**
901    * @dev Constructor, takes crowdsale opening and closing times.
902    * @param _openingTime Crowdsale opening time
903    * @param _closingTime Crowdsale closing time
904    */
905   constructor(uint256 _openingTime, uint256 _closingTime) public {
906     // solium-disable-next-line security/no-block-members
907     require(_openingTime >= block.timestamp);
908     require(_closingTime >= _openingTime);
909 
910     openingTime = _openingTime;
911     closingTime = _closingTime;
912   }
913 
914   /**
915    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
916    * @return Whether crowdsale period has elapsed
917    */
918   function hasClosed() public view returns (bool) {
919     // solium-disable-next-line security/no-block-members
920     return block.timestamp > closingTime;
921   }
922 
923   /**
924    * @dev Extend parent behavior requiring to be within contributing period
925    * @param _beneficiary Token purchaser
926    * @param _weiAmount Amount of wei contributed
927    */
928   function _preValidatePurchase(
929     address _beneficiary,
930     uint256 _weiAmount
931   )
932     internal
933     onlyWhileOpen
934   {
935     super._preValidatePurchase(_beneficiary, _weiAmount);
936   }
937 
938 }
939 
940 // File: openzeppelin-solidity/contracts/crowdsale/emission/AllowanceCrowdsale.sol
941 
942 /**
943  * @title AllowanceCrowdsale
944  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
945  */
946 contract AllowanceCrowdsale is Crowdsale {
947   using SafeMath for uint256;
948   using SafeERC20 for ERC20;
949 
950   address public tokenWallet;
951 
952   /**
953    * @dev Constructor, takes token wallet address.
954    * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
955    */
956   constructor(address _tokenWallet) public {
957     require(_tokenWallet != address(0));
958     tokenWallet = _tokenWallet;
959   }
960 
961   /**
962    * @dev Checks the amount of tokens left in the allowance.
963    * @return Amount of tokens left in the allowance
964    */
965   function remainingTokens() public view returns (uint256) {
966     return token.allowance(tokenWallet, this);
967   }
968 
969   /**
970    * @dev Overrides parent behavior by transferring tokens from wallet.
971    * @param _beneficiary Token purchaser
972    * @param _tokenAmount Amount of tokens purchased
973    */
974   function _deliverTokens(
975     address _beneficiary,
976     uint256 _tokenAmount
977   )
978     internal
979   {
980     token.safeTransferFrom(tokenWallet, _beneficiary, _tokenAmount);
981   }
982 }
983 
984 // File: contracts/crowdsale/distribution/PostDeliveryCrowdsale.sol
985 
986 /**
987  * @title PostDeliveryCrowdsale
988  * @dev Crowdsale that locks tokens from withdrawal until it ends.
989  */
990 contract PostDeliveryCrowdsale is TimedCrowdsale {
991   using SafeMath for uint256;
992 
993   mapping(address => uint256) public balances;
994 
995   /// @dev Withdraw tokens only after crowdsale ends.
996   function withdrawTokens() public {
997     _withdrawTokens(msg.sender);
998   }
999 
1000   /**
1001    * @dev Withdraw tokens only after crowdsale ends.
1002    * @param _beneficiary Token purchaser
1003    */
1004   function _withdrawTokens(address _beneficiary) internal {
1005     require(hasClosed(), "Crowdsale not closed.");
1006     uint256 amount = balances[_beneficiary];
1007     require(amount > 0, "Beneficiary has zero balance.");
1008     balances[_beneficiary] = 0;
1009     _deliverTokens(_beneficiary, amount);
1010   }
1011 
1012   /**
1013    * @dev Overrides parent by storing balances instead of issuing tokens right away.
1014    * @param _beneficiary Token purchaser
1015    * @param _tokenAmount Amount of tokens purchased
1016    */
1017   function _processPurchase(
1018     address _beneficiary,
1019     uint256 _tokenAmount
1020   )
1021     internal
1022   {
1023     balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);
1024   }
1025 
1026 }
1027 
1028 // File: contracts/TokenCrowdsale.sol
1029 
1030 /**
1031  * @title TokenCrowdsale
1032  * @dev This is a ERC20 token crowdsale that will sell tokens util
1033  * the cap is reached, time expired or the allowance is spent.
1034  */
1035 // solium-disable-next-line
1036 contract TokenCrowdsale
1037   is
1038     HasNoTokens,
1039     HasNoContracts,
1040     TimedCrowdsale,
1041     CappedCrowdsale,
1042     IndividuallyCappedCrowdsale,
1043     PostDeliveryCrowdsale,
1044     AllowanceCrowdsale
1045 {
1046 
1047   // When withdrawals open
1048   uint256 public withdrawTime;
1049 
1050   // Amount of tokens sold
1051   uint256 public tokensSold;
1052 
1053   // Amount of tokens delivered
1054   uint256 public tokensDelivered;
1055 
1056   constructor(
1057     uint256 _rate,
1058     address _wallet,
1059     ERC20 _token,
1060     address _tokenWallet,
1061     uint256 _cap,
1062     uint256 _openingTime,
1063     uint256 _closingTime,
1064     uint256 _withdrawTime
1065   )
1066     public
1067     Crowdsale(_rate, _wallet, _token)
1068     TimedCrowdsale(_openingTime, _closingTime)
1069     CappedCrowdsale(_cap)
1070     AllowanceCrowdsale(_tokenWallet)
1071   {
1072     require(_withdrawTime >= _closingTime, "Withdrawals should open after crowdsale closes.");
1073     withdrawTime = _withdrawTime;
1074   }
1075 
1076   /**
1077    * @dev Checks whether the period in which the crowdsale is open
1078    * has already elapsed or cap was reached.
1079    * @return Whether crowdsale has ended
1080    */
1081   function hasEnded() public view returns (bool) {
1082     return hasClosed() || capReached();
1083   }
1084 
1085   /**
1086    * @dev Withdraw tokens only after crowdsale ends.
1087    * @param _beneficiary Token purchaser
1088    */
1089   function withdrawTokens(address _beneficiary) public {
1090     _withdrawTokens(_beneficiary);
1091   }
1092 
1093   /**
1094    * @dev Withdraw tokens only after crowdsale ends.
1095    * @param _beneficiaries List of token purchasers
1096    */
1097   function withdrawTokens(address[] _beneficiaries) public {
1098     for (uint32 i = 0; i < _beneficiaries.length; i ++) {
1099       _withdrawTokens(_beneficiaries[i]);
1100     }
1101   }
1102 
1103   /**
1104    * @dev We use this function to store the total amount of tokens sold
1105    * @param _beneficiary Token purchaser
1106    * @param _tokenAmount Amount of tokens purchased
1107    */
1108   function _processPurchase(
1109     address _beneficiary,
1110     uint256 _tokenAmount
1111   )
1112     internal
1113   {
1114     super._processPurchase(_beneficiary, _tokenAmount);
1115     tokensSold = tokensSold.add(_tokenAmount);
1116   }
1117 
1118   /**
1119    * @dev We use this function to store the total amount of tokens delivered
1120    * @param _beneficiary Address performing the token purchase
1121    * @param _tokenAmount Number of tokens to be emitted
1122    */
1123   function _deliverTokens(
1124     address _beneficiary,
1125     uint256 _tokenAmount
1126   )
1127     internal
1128   {
1129     super._deliverTokens(_beneficiary, _tokenAmount);
1130     tokensDelivered = tokensDelivered.add(_tokenAmount);
1131   }
1132 
1133   /**
1134    * @dev Withdraw tokens only after crowdsale ends.
1135    * @param _beneficiary Token purchaser
1136    */
1137   function _withdrawTokens(address _beneficiary) internal {
1138     // solium-disable-next-line security/no-block-members
1139     require(block.timestamp > withdrawTime, "Withdrawals not open.");
1140     super._withdrawTokens(_beneficiary);
1141   }
1142 
1143 }
1144 
1145 // File: contracts/TokenDistributor.sol
1146 
1147 /**
1148  * @title TokenDistributor
1149  * @dev This is a token distribution contract used to distribute tokens and create a public Crowdsale.
1150  */
1151 contract TokenDistributor is HasNoEther, Finalizable {
1152   using SafeMath for uint256;
1153   using SafeERC20 for ERC20;
1154 
1155   // We also declare Factory.ContractInstantiation here to read it in truffle logs
1156   // https://github.com/trufflesuite/truffle/issues/555
1157   event ContractInstantiation(address sender, address instantiation);
1158   event CrowdsaleInstantiated(address sender, address instantiation, uint256 allowance);
1159 
1160   /// Party (team multisig) who is in the control of the token pool.
1161   /// @notice this will be different from the owner address (scripted) that calls this contract.
1162   address public benefactor;
1163 
1164   // How many token units a buyer gets per wei.
1165   // The rate is the conversion between wei and the smallest and indivisible token unit.
1166   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
1167   // 1 wei will give you 1 unit, or 0.001 TOK.
1168   uint256 public rate;
1169 
1170    // Address where funds are collected
1171   address public wallet;
1172 
1173   // The token being sold
1174   ERC20 public token;
1175 
1176   // Max cap for presale + crowdsale
1177   uint256 public cap;
1178 
1179   // Crowdsale is open in this period
1180   uint256 public openingTime;
1181   uint256 public closingTime;
1182 
1183   // When withdrawals open
1184   uint256 public withdrawTime;
1185 
1186   // Amount of wei raised
1187   uint256 public weiRaised;
1188 
1189   // Crowdsale that is created after the presale distribution is finalized
1190   TokenCrowdsale public crowdsale;
1191 
1192   // Escrow contract used to lock team tokens until crowdsale ends
1193   TokenTimelockEscrow public presaleEscrow;
1194 
1195   // Escrow contract used to lock bonus tokens
1196   TokenTimelockEscrow public bonusEscrow;
1197 
1198   // Factory used to create individual time locked token contracts
1199   TokenTimelockFactory public timelockFactory;
1200 
1201   // Factory used to create individual vesting token contracts
1202   TokenVestingFactory public vestingFactory;
1203 
1204   /// @dev Throws if called before the crowdsale is created.
1205   modifier onlyIfCrowdsale() {
1206     require(crowdsale != address(0), "Crowdsale not started.");
1207     _;
1208   }
1209 
1210   constructor(
1211     address _benefactor,
1212     uint256 _rate,
1213     address _wallet,
1214     ERC20 _token,
1215     uint256 _cap,
1216     uint256 _openingTime,
1217     uint256 _closingTime,
1218     uint256 _withdrawTime,
1219     uint256 _bonusTime
1220   )
1221     public
1222   {
1223     require(address(_benefactor) != address(0), "Benefactor address should not be 0x0.");
1224     require(_rate > 0, "Rate should not be > 0.");
1225     require(_wallet != address(0), "Wallet address should not be 0x0.");
1226     require(address(_token) != address(0), "Token address should not be 0x0.");
1227     require(_cap > 0, "Cap should be > 0.");
1228     // solium-disable-next-line security/no-block-members
1229     require(_openingTime > block.timestamp, "Opening time should be in the future.");
1230     require(_closingTime > _openingTime, "Closing time should be after opening.");
1231     require(_withdrawTime >= _closingTime, "Withdrawals should open after crowdsale closes.");
1232     require(_bonusTime > _withdrawTime, "Bonus time should be set after withdrawals open.");
1233 
1234     benefactor = _benefactor;
1235     rate = _rate;
1236     wallet = _wallet;
1237     token = _token;
1238     cap = _cap;
1239     openingTime = _openingTime;
1240     closingTime = _closingTime;
1241     withdrawTime = _withdrawTime;
1242 
1243     presaleEscrow = new TokenTimelockEscrowImpl(_token, _withdrawTime);
1244     bonusEscrow = new TokenTimelockEscrowImpl(_token, _bonusTime);
1245   }
1246 
1247   /**
1248    * @dev Sets a specific user's maximum contribution.
1249    * @param _beneficiary Address to be capped
1250    * @param _cap Wei limit for individual contribution
1251    */
1252   function setUserCap(address _beneficiary, uint256 _cap) external onlyOwner onlyIfCrowdsale {
1253     crowdsale.setUserCap(_beneficiary, _cap);
1254   }
1255 
1256   /**
1257    * @dev Sets a group of users' maximum contribution.
1258    * @param _beneficiaries List of addresses to be capped
1259    * @param _cap Wei limit for individual contribution
1260    */
1261   function setGroupCap(address[] _beneficiaries, uint256 _cap) external onlyOwner onlyIfCrowdsale {
1262     crowdsale.setGroupCap(_beneficiaries, _cap);
1263   }
1264 
1265   /**
1266    * @dev Returns the cap of a specific user.
1267    * @param _beneficiary Address whose cap is to be checked
1268    * @return Current cap for individual user
1269    */
1270   function getUserCap(address _beneficiary) public view onlyIfCrowdsale returns (uint256) {
1271     return crowdsale.getUserCap(_beneficiary);
1272   }
1273 
1274   /**
1275    * @dev Called by the payer to store the sent amount as credit to be pulled when withdrawals open.
1276    * @param _dest The destination address of the funds.
1277    * @param _amount The amount to transfer.
1278    */
1279   function depositPresale(address _dest, uint256 _amount) public onlyOwner onlyNotFinalized {
1280     require(_dest != address(this), "Transfering tokens to this contract address is not allowed.");
1281     require(token.allowance(benefactor, this) >= _amount, "Not enough allowance.");
1282     token.transferFrom(benefactor, this, _amount);
1283     token.approve(presaleEscrow, _amount);
1284     presaleEscrow.deposit(_dest, _amount);
1285   }
1286 
1287   /**
1288    * @dev Called by the payer to store the sent amount as credit to be pulled when withdrawals open.
1289    * @param _dest The destination address of the funds.
1290    * @param _amount The amount to transfer.
1291    * @param _weiAmount The amount of wei exchanged for the tokens.
1292    */
1293   function depositPresale(address _dest, uint256 _amount, uint256 _weiAmount) public {
1294     require(cap >= weiRaised.add(_weiAmount), "Cap reached.");
1295     depositPresale(_dest, _amount);
1296     weiRaised = weiRaised.add(_weiAmount);
1297   }
1298 
1299   /// @dev Withdraw accumulated balance, called by beneficiary.
1300   function withdrawPresale() public {
1301     presaleEscrow.withdraw(msg.sender);
1302   }
1303 
1304   /**
1305    * @dev Withdraw accumulated balance for beneficiary.
1306    * @param _beneficiary Address of beneficiary
1307    */
1308   function withdrawPresale(address _beneficiary) public {
1309     presaleEscrow.withdraw(_beneficiary);
1310   }
1311 
1312   /**
1313    * @dev Withdraw accumulated balances for beneficiaries.
1314    * @param _beneficiaries List of addresses of beneficiaries
1315    */
1316   function withdrawPresale(address[] _beneficiaries) public {
1317     for (uint32 i = 0; i < _beneficiaries.length; i ++) {
1318       presaleEscrow.withdraw(_beneficiaries[i]);
1319     }
1320   }
1321 
1322   /**
1323    * @dev Called by the payer to store the sent amount as credit to be pulled from token timelock contract.
1324    * @param _dest The destination address of the funds.
1325    * @param _amount The amount to transfer.
1326    */
1327   function depositBonus(address _dest, uint256 _amount) public onlyOwner onlyNotFinalized {
1328     require(_dest != address(this), "Transfering tokens to this contract address is not allowed.");
1329     require(token.allowance(benefactor, this) >= _amount, "Not enough allowance.");
1330     token.transferFrom(benefactor, this, _amount);
1331     token.approve(bonusEscrow, _amount);
1332     bonusEscrow.deposit(_dest, _amount);
1333   }
1334 
1335   /// @dev Withdraw accumulated balance, called by beneficiary.
1336   function withdrawBonus() public {
1337     bonusEscrow.withdraw(msg.sender);
1338   }
1339 
1340   /**
1341    * @dev Withdraw accumulated balance for beneficiary.
1342    * @param _beneficiary Address of beneficiary
1343    */
1344   function withdrawBonus(address _beneficiary) public {
1345     bonusEscrow.withdraw(_beneficiary);
1346   }
1347 
1348   /**
1349    * @dev Withdraw accumulated balances for beneficiaries.
1350    * @param _beneficiaries List of addresses of beneficiaries
1351    */
1352   function withdrawBonus(address[] _beneficiaries) public {
1353     for (uint32 i = 0; i < _beneficiaries.length; i ++) {
1354       bonusEscrow.withdraw(_beneficiaries[i]);
1355     }
1356   }
1357 
1358   /**
1359    * @dev Called by the payer to deposit tokens and bonus as credit to be pulled by benefactor.
1360    * @param _dest The destination address of the funds.
1361    * @param _amount The amount to transfer.
1362    * @param _bonusAmount The bonus amount to transfer.
1363    */
1364   function depositPresaleWithBonus(
1365     address _dest,
1366     uint256 _amount,
1367     uint256 _bonusAmount
1368   )
1369     public
1370   {
1371     depositPresale(_dest, _amount);
1372     depositBonus(_dest, _bonusAmount);
1373   }
1374 
1375   /**
1376    * @dev Called by the payer to deposit tokens and bonus as credit to be pulled by benefactor.
1377    * @param _dest The destination address of the funds.
1378    * @param _amount The amount to transfer.
1379    * @param _weiAmount The amount of wei exchanged for the tokens.
1380    * @param _bonusAmount The bonus amount to transfer.
1381    */
1382   function depositPresaleWithBonus(
1383     address _dest,
1384     uint256 _amount,
1385     uint256 _weiAmount,
1386     uint256 _bonusAmount
1387   )
1388     public
1389   {
1390     depositPresale(_dest, _amount, _weiAmount);
1391     depositBonus(_dest, _bonusAmount);
1392   }
1393 
1394   /**
1395    * @dev Setter for TokenTimelockFactory because of gas limits
1396    * @param _timelockFactory Address of the TokenTimelockFactory contract
1397    */
1398   function setTokenTimelockFactory(address _timelockFactory) public onlyOwner {
1399     require(_timelockFactory != address(0), "Factory address should not be 0x0.");
1400     require(timelockFactory == address(0), "Factory already initalizied.");
1401     timelockFactory = TokenTimelockFactory(_timelockFactory);
1402   }
1403 
1404   /**
1405    * @dev Called by the payer to store the sent amount as credit to be pulled
1406    * from token timelock contract.
1407    * @param _dest The destination address of the funds.
1408    * @param _amount The amount to transfer.
1409    * @param _releaseTime The release times after which the tokens can be withdrawn.
1410    * @return Returns wallet address.
1411    */
1412   function depositAndLock(
1413     address _dest,
1414     uint256 _amount,
1415     uint256 _releaseTime
1416   )
1417     public
1418     onlyOwner
1419     onlyNotFinalized
1420     returns (address tokenWallet)
1421   {
1422     require(token.allowance(benefactor, this) >= _amount, "Not enough allowance.");
1423     require(_dest != address(0), "Destination address should not be 0x0.");
1424     require(_dest != address(this), "Transfering tokens to this contract address is not allowed.");
1425     require(_releaseTime >= withdrawTime, "Tokens should unlock after withdrawals open.");
1426     tokenWallet = timelockFactory.create(
1427       token,
1428       _dest,
1429       _releaseTime
1430     );
1431     token.transferFrom(benefactor, tokenWallet, _amount);
1432   }
1433 
1434   /**
1435    * @dev Setter for TokenVestingFactory because of gas limits
1436    * @param _vestingFactory Address of the TokenVestingFactory contract
1437    */
1438   function setTokenVestingFactory(address _vestingFactory) public onlyOwner {
1439     require(_vestingFactory != address(0), "Factory address should not be 0x0.");
1440     require(vestingFactory == address(0), "Factory already initalizied.");
1441     vestingFactory = TokenVestingFactory(_vestingFactory);
1442   }
1443 
1444   /**
1445    * @dev Called by the payer to store the sent amount as credit to be pulled
1446    * from token vesting contract.
1447    * @param _dest The destination address of the funds.
1448    * @param _amount The amount to transfer.
1449    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
1450    * @param _start the time (as Unix time) at which point vesting starts
1451    * @param _duration duration in seconds of the period in which the tokens will vest
1452    * @return Returns wallet address.
1453    */
1454   function depositAndVest(
1455     address _dest,
1456     uint256 _amount,
1457     uint256 _start,
1458     uint256 _cliff,
1459     uint256 _duration
1460   )
1461     public
1462     onlyOwner
1463     onlyNotFinalized
1464     returns (address tokenWallet)
1465   {
1466     require(token.allowance(benefactor, this) >= _amount, "Not enough allowance.");
1467     require(_dest != address(0), "Destination address should not be 0x0.");
1468     require(_dest != address(this), "Transfering tokens to this contract address is not allowed.");
1469     require(_start.add(_cliff) >= withdrawTime, "Tokens should unlock after withdrawals open.");
1470     bool revocable = false;
1471     tokenWallet = vestingFactory.create(
1472       _dest,
1473       _start,
1474       _cliff,
1475       _duration,
1476       revocable
1477     );
1478     token.transferFrom(benefactor, tokenWallet, _amount);
1479   }
1480 
1481   /**
1482    * @dev In case there are any unsold tokens, they are claimed by the owner
1483    * @param _beneficiary Address where claimable tokens are going to be transfered
1484    */
1485   function claimUnsold(address _beneficiary) public onlyIfCrowdsale onlyOwner {
1486     // solium-disable-next-line security/no-block-members
1487     require(block.timestamp > withdrawTime, "Withdrawals not open.");
1488     uint256 sold = crowdsale.tokensSold();
1489     uint256 delivered = crowdsale.tokensDelivered();
1490     uint256 toDeliver = sold.sub(delivered);
1491 
1492     uint256 balance = token.balanceOf(this);
1493     uint256 claimable = balance.sub(toDeliver);
1494 
1495     if (claimable > 0) {
1496       token.safeTransfer(_beneficiary, claimable);
1497     }
1498   }
1499 
1500   /**
1501    * @dev Finalization logic that will create a Crowdsale with provided parameters
1502    * and calculated cap depending on the amount raised in presale.
1503    */
1504   function finalization() internal {
1505     uint256 crowdsaleCap = cap.sub(weiRaised);
1506     if (crowdsaleCap < 1 ether) {
1507       // Cap reached in presale, no crowdsale necessary
1508       return;
1509     }
1510 
1511     address tokenWallet = this;
1512     crowdsale = new TokenCrowdsale(
1513       rate,
1514       wallet,
1515       token,
1516       tokenWallet,
1517       crowdsaleCap,
1518       openingTime,
1519       closingTime,
1520       withdrawTime
1521     );
1522     uint256 allowance = token.allowance(benefactor, this);
1523     token.transferFrom(benefactor, this, allowance);
1524     token.approve(crowdsale, allowance);
1525     emit CrowdsaleInstantiated(msg.sender, crowdsale, allowance);
1526   }
1527 
1528 }