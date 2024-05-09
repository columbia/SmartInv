1 pragma solidity ^0.4.23;
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
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
56 
57 /**
58  * @title ERC20Basic
59  * @dev Simpler version of ERC20 interface
60  * @dev see https://github.com/ethereum/EIPs/issues/179
61  */
62 contract ERC20Basic {
63   function totalSupply() public view returns (uint256);
64   function balanceOf(address who) public view returns (uint256);
65   function transfer(address to, uint256 value) public returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
70 
71 /**
72  * @title ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/20
74  */
75 contract ERC20 is ERC20Basic {
76   function allowance(address owner, address spender)
77     public view returns (uint256);
78 
79   function transferFrom(address from, address to, uint256 value)
80     public returns (bool);
81 
82   function approve(address spender, uint256 value) public returns (bool);
83   event Approval(
84     address indexed owner,
85     address indexed spender,
86     uint256 value
87   );
88 }
89 
90 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
91 
92 /**
93  * @title Crowdsale
94  * @dev Crowdsale is a base contract for managing a token crowdsale,
95  * allowing investors to purchase tokens with ether. This contract implements
96  * such functionality in its most fundamental form and can be extended to provide additional
97  * functionality and/or custom behavior.
98  * The external interface represents the basic interface for purchasing tokens, and conform
99  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
100  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
101  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
102  * behavior.
103  */
104 contract Crowdsale {
105   using SafeMath for uint256;
106 
107   // The token being sold
108   ERC20 public token;
109 
110   // Address where funds are collected
111   address public wallet;
112 
113   // How many token units a buyer gets per wei.
114   // The rate is the conversion between wei and the smallest and indivisible token unit.
115   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
116   // 1 wei will give you 1 unit, or 0.001 TOK.
117   uint256 public rate;
118 
119   // Amount of wei raised
120   uint256 public weiRaised;
121 
122   /**
123    * Event for token purchase logging
124    * @param purchaser who paid for the tokens
125    * @param beneficiary who got the tokens
126    * @param value weis paid for purchase
127    * @param amount amount of tokens purchased
128    */
129   event TokenPurchase(
130     address indexed purchaser,
131     address indexed beneficiary,
132     uint256 value,
133     uint256 amount
134   );
135 
136   /**
137    * @param _rate Number of token units a buyer gets per wei
138    * @param _wallet Address where collected funds will be forwarded to
139    * @param _token Address of the token being sold
140    */
141   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
142     require(_rate > 0);
143     require(_wallet != address(0));
144     require(_token != address(0));
145 
146     rate = _rate;
147     wallet = _wallet;
148     token = _token;
149   }
150 
151   // -----------------------------------------
152   // Crowdsale external interface
153   // -----------------------------------------
154 
155   /**
156    * @dev fallback function ***DO NOT OVERRIDE***
157    */
158   function () external payable {
159     buyTokens(msg.sender);
160   }
161 
162   /**
163    * @dev low level token purchase ***DO NOT OVERRIDE***
164    * @param _beneficiary Address performing the token purchase
165    */
166   function buyTokens(address _beneficiary) public payable {
167 
168     uint256 weiAmount = msg.value;
169     _preValidatePurchase(_beneficiary, weiAmount);
170 
171     // calculate token amount to be created
172     uint256 tokens = _getTokenAmount(weiAmount);
173 
174     // update state
175     weiRaised = weiRaised.add(weiAmount);
176 
177     _processPurchase(_beneficiary, tokens);
178     emit TokenPurchase(
179       msg.sender,
180       _beneficiary,
181       weiAmount,
182       tokens
183     );
184 
185     _updatePurchasingState(_beneficiary, weiAmount);
186 
187     _forwardFunds();
188     _postValidatePurchase(_beneficiary, weiAmount);
189   }
190 
191   // -----------------------------------------
192   // Internal interface (extensible)
193   // -----------------------------------------
194 
195   /**
196    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
197    * @param _beneficiary Address performing the token purchase
198    * @param _weiAmount Value in wei involved in the purchase
199    */
200   function _preValidatePurchase(
201     address _beneficiary,
202     uint256 _weiAmount
203   )
204     internal
205   {
206     require(_beneficiary != address(0));
207     require(_weiAmount != 0);
208   }
209 
210   /**
211    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
212    * @param _beneficiary Address performing the token purchase
213    * @param _weiAmount Value in wei involved in the purchase
214    */
215   function _postValidatePurchase(
216     address _beneficiary,
217     uint256 _weiAmount
218   )
219     internal
220   {
221     // optional override
222   }
223 
224   /**
225    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
226    * @param _beneficiary Address performing the token purchase
227    * @param _tokenAmount Number of tokens to be emitted
228    */
229   function _deliverTokens(
230     address _beneficiary,
231     uint256 _tokenAmount
232   )
233     internal
234   {
235     token.transfer(_beneficiary, _tokenAmount);
236   }
237 
238   /**
239    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
240    * @param _beneficiary Address receiving the tokens
241    * @param _tokenAmount Number of tokens to be purchased
242    */
243   function _processPurchase(
244     address _beneficiary,
245     uint256 _tokenAmount
246   )
247     internal
248   {
249     _deliverTokens(_beneficiary, _tokenAmount);
250   }
251 
252   /**
253    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
254    * @param _beneficiary Address receiving the tokens
255    * @param _weiAmount Value in wei involved in the purchase
256    */
257   function _updatePurchasingState(
258     address _beneficiary,
259     uint256 _weiAmount
260   )
261     internal
262   {
263     // optional override
264   }
265 
266   /**
267    * @dev Override to extend the way in which ether is converted to tokens.
268    * @param _weiAmount Value in wei to be converted into tokens
269    * @return Number of tokens that can be purchased with the specified _weiAmount
270    */
271   function _getTokenAmount(uint256 _weiAmount)
272     internal view returns (uint256)
273   {
274     return _weiAmount.mul(rate);
275   }
276 
277   /**
278    * @dev Determines how ETH is stored/forwarded on purchases.
279    */
280   function _forwardFunds() internal {
281     wallet.transfer(msg.value);
282   }
283 }
284 
285 // File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
286 
287 /**
288  * @title TimedCrowdsale
289  * @dev Crowdsale accepting contributions only within a time frame.
290  */
291 contract TimedCrowdsale is Crowdsale {
292   using SafeMath for uint256;
293 
294   uint256 public openingTime;
295   uint256 public closingTime;
296 
297   /**
298    * @dev Reverts if not in crowdsale time range.
299    */
300   modifier onlyWhileOpen {
301     // solium-disable-next-line security/no-block-members
302     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
303     _;
304   }
305 
306   /**
307    * @dev Constructor, takes crowdsale opening and closing times.
308    * @param _openingTime Crowdsale opening time
309    * @param _closingTime Crowdsale closing time
310    */
311   constructor(uint256 _openingTime, uint256 _closingTime) public {
312     // solium-disable-next-line security/no-block-members
313     require(_openingTime >= block.timestamp);
314     require(_closingTime >= _openingTime);
315 
316     openingTime = _openingTime;
317     closingTime = _closingTime;
318   }
319 
320   /**
321    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
322    * @return Whether crowdsale period has elapsed
323    */
324   function hasClosed() public view returns (bool) {
325     // solium-disable-next-line security/no-block-members
326     return block.timestamp > closingTime;
327   }
328 
329   /**
330    * @dev Extend parent behavior requiring to be within contributing period
331    * @param _beneficiary Token purchaser
332    * @param _weiAmount Amount of wei contributed
333    */
334   function _preValidatePurchase(
335     address _beneficiary,
336     uint256 _weiAmount
337   )
338     internal
339     onlyWhileOpen
340   {
341     super._preValidatePurchase(_beneficiary, _weiAmount);
342   }
343 
344 }
345 
346 // File: openzeppelin-solidity/contracts/crowdsale/distribution/PostDeliveryCrowdsale.sol
347 
348 /**
349  * @title PostDeliveryCrowdsale
350  * @dev Crowdsale that locks tokens from withdrawal until it ends.
351  */
352 contract PostDeliveryCrowdsale is TimedCrowdsale {
353   using SafeMath for uint256;
354 
355   mapping(address => uint256) public balances;
356 
357   /**
358    * @dev Withdraw tokens only after crowdsale ends.
359    */
360   function withdrawTokens() public {
361     require(hasClosed());
362     uint256 amount = balances[msg.sender];
363     require(amount > 0);
364     balances[msg.sender] = 0;
365     _deliverTokens(msg.sender, amount);
366   }
367 
368   /**
369    * @dev Overrides parent by storing balances instead of issuing tokens right away.
370    * @param _beneficiary Token purchaser
371    * @param _tokenAmount Amount of tokens purchased
372    */
373   function _processPurchase(
374     address _beneficiary,
375     uint256 _tokenAmount
376   )
377     internal
378   {
379     balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);
380   }
381 
382 }
383 
384 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
385 
386 /**
387  * @title Ownable
388  * @dev The Ownable contract has an owner address, and provides basic authorization control
389  * functions, this simplifies the implementation of "user permissions".
390  */
391 contract Ownable {
392   address public owner;
393 
394 
395   event OwnershipRenounced(address indexed previousOwner);
396   event OwnershipTransferred(
397     address indexed previousOwner,
398     address indexed newOwner
399   );
400 
401 
402   /**
403    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
404    * account.
405    */
406   constructor() public {
407     owner = msg.sender;
408   }
409 
410   /**
411    * @dev Throws if called by any account other than the owner.
412    */
413   modifier onlyOwner() {
414     require(msg.sender == owner);
415     _;
416   }
417 
418   /**
419    * @dev Allows the current owner to relinquish control of the contract.
420    */
421   function renounceOwnership() public onlyOwner {
422     emit OwnershipRenounced(owner);
423     owner = address(0);
424   }
425 
426   /**
427    * @dev Allows the current owner to transfer control of the contract to a newOwner.
428    * @param _newOwner The address to transfer ownership to.
429    */
430   function transferOwnership(address _newOwner) public onlyOwner {
431     _transferOwnership(_newOwner);
432   }
433 
434   /**
435    * @dev Transfers control of the contract to a newOwner.
436    * @param _newOwner The address to transfer ownership to.
437    */
438   function _transferOwnership(address _newOwner) internal {
439     require(_newOwner != address(0));
440     emit OwnershipTransferred(owner, _newOwner);
441     owner = _newOwner;
442   }
443 }
444 
445 // File: openzeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol
446 
447 /**
448  * @title FinalizableCrowdsale
449  * @dev Extension of Crowdsale where an owner can do extra work
450  * after finishing.
451  */
452 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
453   using SafeMath for uint256;
454 
455   bool public isFinalized = false;
456 
457   event Finalized();
458 
459   /**
460    * @dev Must be called after crowdsale ends, to do some extra finalization
461    * work. Calls the contract's finalization function.
462    */
463   function finalize() onlyOwner public {
464     require(!isFinalized);
465     require(hasClosed());
466 
467     finalization();
468     emit Finalized();
469 
470     isFinalized = true;
471   }
472 
473   /**
474    * @dev Can be overridden to add finalization logic. The overriding function
475    * should call super.finalization() to ensure the chain of finalization is
476    * executed entirely.
477    */
478   function finalization() internal {
479   }
480 
481 }
482 
483 // File: openzeppelin-solidity/contracts/crowdsale/distribution/utils/RefundVault.sol
484 
485 /**
486  * @title RefundVault
487  * @dev This contract is used for storing funds while a crowdsale
488  * is in progress. Supports refunding the money if crowdsale fails,
489  * and forwarding it if crowdsale is successful.
490  */
491 contract RefundVault is Ownable {
492   using SafeMath for uint256;
493 
494   enum State { Active, Refunding, Closed }
495 
496   mapping (address => uint256) public deposited;
497   address public wallet;
498   State public state;
499 
500   event Closed();
501   event RefundsEnabled();
502   event Refunded(address indexed beneficiary, uint256 weiAmount);
503 
504   /**
505    * @param _wallet Vault address
506    */
507   constructor(address _wallet) public {
508     require(_wallet != address(0));
509     wallet = _wallet;
510     state = State.Active;
511   }
512 
513   /**
514    * @param investor Investor address
515    */
516   function deposit(address investor) onlyOwner public payable {
517     require(state == State.Active);
518     deposited[investor] = deposited[investor].add(msg.value);
519   }
520 
521   function close() onlyOwner public {
522     require(state == State.Active);
523     state = State.Closed;
524     emit Closed();
525     wallet.transfer(address(this).balance);
526   }
527 
528   function enableRefunds() onlyOwner public {
529     require(state == State.Active);
530     state = State.Refunding;
531     emit RefundsEnabled();
532   }
533 
534   /**
535    * @param investor Investor address
536    */
537   function refund(address investor) public {
538     require(state == State.Refunding);
539     uint256 depositedValue = deposited[investor];
540     deposited[investor] = 0;
541     investor.transfer(depositedValue);
542     emit Refunded(investor, depositedValue);
543   }
544 }
545 
546 // File: openzeppelin-solidity/contracts/crowdsale/distribution/RefundableCrowdsale.sol
547 
548 /**
549  * @title RefundableCrowdsale
550  * @dev Extension of Crowdsale contract that adds a funding goal, and
551  * the possibility of users getting a refund if goal is not met.
552  * Uses a RefundVault as the crowdsale's vault.
553  */
554 contract RefundableCrowdsale is FinalizableCrowdsale {
555   using SafeMath for uint256;
556 
557   // minimum amount of funds to be raised in weis
558   uint256 public goal;
559 
560   // refund vault used to hold funds while crowdsale is running
561   RefundVault public vault;
562 
563   /**
564    * @dev Constructor, creates RefundVault.
565    * @param _goal Funding goal
566    */
567   constructor(uint256 _goal) public {
568     require(_goal > 0);
569     vault = new RefundVault(wallet);
570     goal = _goal;
571   }
572 
573   /**
574    * @dev Investors can claim refunds here if crowdsale is unsuccessful
575    */
576   function claimRefund() public {
577     require(isFinalized);
578     require(!goalReached());
579 
580     vault.refund(msg.sender);
581   }
582 
583   /**
584    * @dev Checks whether funding goal was reached.
585    * @return Whether funding goal was reached
586    */
587   function goalReached() public view returns (bool) {
588     return weiRaised >= goal;
589   }
590 
591   /**
592    * @dev vault finalization task, called when owner calls finalize()
593    */
594   function finalization() internal {
595     if (goalReached()) {
596       vault.close();
597     } else {
598       vault.enableRefunds();
599     }
600 
601     super.finalization();
602   }
603 
604   /**
605    * @dev Overrides Crowdsale fund forwarding, sending funds to vault.
606    */
607   function _forwardFunds() internal {
608     vault.deposit.value(msg.value)(msg.sender);
609   }
610 
611 }
612 
613 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
614 
615 /**
616  * @title Basic token
617  * @dev Basic version of StandardToken, with no allowances.
618  */
619 contract BasicToken is ERC20Basic {
620   using SafeMath for uint256;
621 
622   mapping(address => uint256) balances;
623 
624   uint256 totalSupply_;
625 
626   /**
627   * @dev total number of tokens in existence
628   */
629   function totalSupply() public view returns (uint256) {
630     return totalSupply_;
631   }
632 
633   /**
634   * @dev transfer token for a specified address
635   * @param _to The address to transfer to.
636   * @param _value The amount to be transferred.
637   */
638   function transfer(address _to, uint256 _value) public returns (bool) {
639     require(_to != address(0));
640     require(_value <= balances[msg.sender]);
641 
642     balances[msg.sender] = balances[msg.sender].sub(_value);
643     balances[_to] = balances[_to].add(_value);
644     emit Transfer(msg.sender, _to, _value);
645     return true;
646   }
647 
648   /**
649   * @dev Gets the balance of the specified address.
650   * @param _owner The address to query the the balance of.
651   * @return An uint256 representing the amount owned by the passed address.
652   */
653   function balanceOf(address _owner) public view returns (uint256) {
654     return balances[_owner];
655   }
656 
657 }
658 
659 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
660 
661 /**
662  * @title Standard ERC20 token
663  *
664  * @dev Implementation of the basic standard token.
665  * @dev https://github.com/ethereum/EIPs/issues/20
666  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
667  */
668 contract StandardToken is ERC20, BasicToken {
669 
670   mapping (address => mapping (address => uint256)) internal allowed;
671 
672 
673   /**
674    * @dev Transfer tokens from one address to another
675    * @param _from address The address which you want to send tokens from
676    * @param _to address The address which you want to transfer to
677    * @param _value uint256 the amount of tokens to be transferred
678    */
679   function transferFrom(
680     address _from,
681     address _to,
682     uint256 _value
683   )
684     public
685     returns (bool)
686   {
687     require(_to != address(0));
688     require(_value <= balances[_from]);
689     require(_value <= allowed[_from][msg.sender]);
690 
691     balances[_from] = balances[_from].sub(_value);
692     balances[_to] = balances[_to].add(_value);
693     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
694     emit Transfer(_from, _to, _value);
695     return true;
696   }
697 
698   /**
699    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
700    *
701    * Beware that changing an allowance with this method brings the risk that someone may use both the old
702    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
703    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
704    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
705    * @param _spender The address which will spend the funds.
706    * @param _value The amount of tokens to be spent.
707    */
708   function approve(address _spender, uint256 _value) public returns (bool) {
709     allowed[msg.sender][_spender] = _value;
710     emit Approval(msg.sender, _spender, _value);
711     return true;
712   }
713 
714   /**
715    * @dev Function to check the amount of tokens that an owner allowed to a spender.
716    * @param _owner address The address which owns the funds.
717    * @param _spender address The address which will spend the funds.
718    * @return A uint256 specifying the amount of tokens still available for the spender.
719    */
720   function allowance(
721     address _owner,
722     address _spender
723    )
724     public
725     view
726     returns (uint256)
727   {
728     return allowed[_owner][_spender];
729   }
730 
731   /**
732    * @dev Increase the amount of tokens that an owner allowed to a spender.
733    *
734    * approve should be called when allowed[_spender] == 0. To increment
735    * allowed value is better to use this function to avoid 2 calls (and wait until
736    * the first transaction is mined)
737    * From MonolithDAO Token.sol
738    * @param _spender The address which will spend the funds.
739    * @param _addedValue The amount of tokens to increase the allowance by.
740    */
741   function increaseApproval(
742     address _spender,
743     uint _addedValue
744   )
745     public
746     returns (bool)
747   {
748     allowed[msg.sender][_spender] = (
749       allowed[msg.sender][_spender].add(_addedValue));
750     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
751     return true;
752   }
753 
754   /**
755    * @dev Decrease the amount of tokens that an owner allowed to a spender.
756    *
757    * approve should be called when allowed[_spender] == 0. To decrement
758    * allowed value is better to use this function to avoid 2 calls (and wait until
759    * the first transaction is mined)
760    * From MonolithDAO Token.sol
761    * @param _spender The address which will spend the funds.
762    * @param _subtractedValue The amount of tokens to decrease the allowance by.
763    */
764   function decreaseApproval(
765     address _spender,
766     uint _subtractedValue
767   )
768     public
769     returns (bool)
770   {
771     uint oldValue = allowed[msg.sender][_spender];
772     if (_subtractedValue > oldValue) {
773       allowed[msg.sender][_spender] = 0;
774     } else {
775       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
776     }
777     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
778     return true;
779   }
780 
781 }
782 
783 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
784 
785 /**
786  * @title Mintable token
787  * @dev Simple ERC20 Token example, with mintable token creation
788  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
789  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
790  */
791 contract MintableToken is StandardToken, Ownable {
792   event Mint(address indexed to, uint256 amount);
793   event MintFinished();
794 
795   bool public mintingFinished = false;
796 
797 
798   modifier canMint() {
799     require(!mintingFinished);
800     _;
801   }
802 
803   modifier hasMintPermission() {
804     require(msg.sender == owner);
805     _;
806   }
807 
808   /**
809    * @dev Function to mint tokens
810    * @param _to The address that will receive the minted tokens.
811    * @param _amount The amount of tokens to mint.
812    * @return A boolean that indicates if the operation was successful.
813    */
814   function mint(
815     address _to,
816     uint256 _amount
817   )
818     hasMintPermission
819     canMint
820     public
821     returns (bool)
822   {
823     totalSupply_ = totalSupply_.add(_amount);
824     balances[_to] = balances[_to].add(_amount);
825     emit Mint(_to, _amount);
826     emit Transfer(address(0), _to, _amount);
827     return true;
828   }
829 
830   /**
831    * @dev Function to stop minting new tokens.
832    * @return True if the operation was successful.
833    */
834   function finishMinting() onlyOwner canMint public returns (bool) {
835     mintingFinished = true;
836     emit MintFinished();
837     return true;
838   }
839 }
840 
841 // File: openzeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol
842 
843 /**
844  * @title MintedCrowdsale
845  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
846  * Token ownership should be transferred to MintedCrowdsale for minting.
847  */
848 contract MintedCrowdsale is Crowdsale {
849 
850   /**
851    * @dev Overrides delivery by minting tokens upon purchase.
852    * @param _beneficiary Token purchaser
853    * @param _tokenAmount Number of tokens to be minted
854    */
855   function _deliverTokens(
856     address _beneficiary,
857     uint256 _tokenAmount
858   )
859     internal
860   {
861     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
862   }
863 }
864 
865 // File: openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
866 
867 /**
868  * @title CappedCrowdsale
869  * @dev Crowdsale with a limit for total contributions.
870  */
871 contract CappedCrowdsale is Crowdsale {
872   using SafeMath for uint256;
873 
874   uint256 public cap;
875 
876   /**
877    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
878    * @param _cap Max amount of wei to be contributed
879    */
880   constructor(uint256 _cap) public {
881     require(_cap > 0);
882     cap = _cap;
883   }
884 
885   /**
886    * @dev Checks whether the cap has been reached.
887    * @return Whether the cap was reached
888    */
889   function capReached() public view returns (bool) {
890     return weiRaised >= cap;
891   }
892 
893   /**
894    * @dev Extend parent behavior requiring purchase to respect the funding cap.
895    * @param _beneficiary Token purchaser
896    * @param _weiAmount Amount of wei contributed
897    */
898   function _preValidatePurchase(
899     address _beneficiary,
900     uint256 _weiAmount
901   )
902     internal
903   {
904     super._preValidatePurchase(_beneficiary, _weiAmount);
905     require(weiRaised.add(_weiAmount) <= cap);
906   }
907 
908 }
909 
910 // File: openzeppelin-solidity/contracts/crowdsale/validation/IndividuallyCappedCrowdsale.sol
911 
912 /**
913  * @title IndividuallyCappedCrowdsale
914  * @dev Crowdsale with per-user caps.
915  */
916 contract IndividuallyCappedCrowdsale is Crowdsale, Ownable {
917   using SafeMath for uint256;
918 
919   mapping(address => uint256) public contributions;
920   mapping(address => uint256) public caps;
921 
922   /**
923    * @dev Sets a specific user's maximum contribution.
924    * @param _beneficiary Address to be capped
925    * @param _cap Wei limit for individual contribution
926    */
927   function setUserCap(address _beneficiary, uint256 _cap) external onlyOwner {
928     caps[_beneficiary] = _cap;
929   }
930 
931   /**
932    * @dev Sets a group of users' maximum contribution.
933    * @param _beneficiaries List of addresses to be capped
934    * @param _cap Wei limit for individual contribution
935    */
936   function setGroupCap(
937     address[] _beneficiaries,
938     uint256 _cap
939   )
940     external
941     onlyOwner
942   {
943     for (uint256 i = 0; i < _beneficiaries.length; i++) {
944       caps[_beneficiaries[i]] = _cap;
945     }
946   }
947 
948   /**
949    * @dev Returns the cap of a specific user.
950    * @param _beneficiary Address whose cap is to be checked
951    * @return Current cap for individual user
952    */
953   function getUserCap(address _beneficiary) public view returns (uint256) {
954     return caps[_beneficiary];
955   }
956 
957   /**
958    * @dev Returns the amount contributed so far by a sepecific user.
959    * @param _beneficiary Address of contributor
960    * @return User contribution so far
961    */
962   function getUserContribution(address _beneficiary)
963     public view returns (uint256)
964   {
965     return contributions[_beneficiary];
966   }
967 
968   /**
969    * @dev Extend parent behavior requiring purchase to respect the user's funding cap.
970    * @param _beneficiary Token purchaser
971    * @param _weiAmount Amount of wei contributed
972    */
973   function _preValidatePurchase(
974     address _beneficiary,
975     uint256 _weiAmount
976   )
977     internal
978   {
979     super._preValidatePurchase(_beneficiary, _weiAmount);
980     require(contributions[_beneficiary].add(_weiAmount) <= caps[_beneficiary]);
981   }
982 
983   /**
984    * @dev Extend parent behavior to update user contributions
985    * @param _beneficiary Token purchaser
986    * @param _weiAmount Amount of wei contributed
987    */
988   function _updatePurchasingState(
989     address _beneficiary,
990     uint256 _weiAmount
991   )
992     internal
993   {
994     super._updatePurchasingState(_beneficiary, _weiAmount);
995     contributions[_beneficiary] = contributions[_beneficiary].add(_weiAmount);
996   }
997 
998 }
999 
1000 // File: openzeppelin-solidity/contracts/crowdsale/validation/WhitelistedCrowdsale.sol
1001 
1002 /**
1003  * @title WhitelistedCrowdsale
1004  * @dev Crowdsale in which only whitelisted users can contribute.
1005  */
1006 contract WhitelistedCrowdsale is Crowdsale, Ownable {
1007 
1008   mapping(address => bool) public whitelist;
1009 
1010   /**
1011    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
1012    */
1013   modifier isWhitelisted(address _beneficiary) {
1014     require(whitelist[_beneficiary]);
1015     _;
1016   }
1017 
1018   /**
1019    * @dev Adds single address to whitelist.
1020    * @param _beneficiary Address to be added to the whitelist
1021    */
1022   function addToWhitelist(address _beneficiary) external onlyOwner {
1023     whitelist[_beneficiary] = true;
1024   }
1025 
1026   /**
1027    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
1028    * @param _beneficiaries Addresses to be added to the whitelist
1029    */
1030   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
1031     for (uint256 i = 0; i < _beneficiaries.length; i++) {
1032       whitelist[_beneficiaries[i]] = true;
1033     }
1034   }
1035 
1036   /**
1037    * @dev Removes single address from whitelist.
1038    * @param _beneficiary Address to be removed to the whitelist
1039    */
1040   function removeFromWhitelist(address _beneficiary) external onlyOwner {
1041     whitelist[_beneficiary] = false;
1042   }
1043 
1044   /**
1045    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
1046    * @param _beneficiary Token beneficiary
1047    * @param _weiAmount Amount of wei contributed
1048    */
1049   function _preValidatePurchase(
1050     address _beneficiary,
1051     uint256 _weiAmount
1052   )
1053     internal
1054     isWhitelisted(_beneficiary)
1055   {
1056     super._preValidatePurchase(_beneficiary, _weiAmount);
1057   }
1058 
1059 }
1060 
1061 // File: contracts/GBECrowdsale.sol
1062 
1063 /*
1064  * @title GBECrowdsale
1065  * @dev The crowdsale that will gain ownership and distrubute
1066  * the token
1067  * @param _rate Rate in the public sale
1068  * @param _wallet The address to which the funds will be forwarded to after the crowdsale ends
1069  * @param _cap The hard cap
1070  * @param _goal The soft cap
1071  * @param _minimumInvestment Minimum investment allowed in public sale
1072  * @param _openingTime The opening time as a unix timestamp
1073  * @param _closingTime The closing time as a unix timestamp
1074  * @param _token The address of the mintable token to be deployed
1075  */
1076 contract GBECrowdsale is CappedCrowdsale, RefundableCrowdsale, MintedCrowdsale, WhitelistedCrowdsale { // solium-disable-line max-len
1077 
1078   uint256 public minimumInvestment;
1079   uint256 public initialRate;
1080 
1081   constructor(
1082     uint256 _rate,
1083     address _wallet,
1084     uint256 _cap,
1085     uint256 _goal,
1086     uint256 _minimumInvestment,
1087     uint256 _openingTime,
1088     uint256 _closingTime,
1089     MintableToken _token
1090   )
1091     public
1092     Crowdsale(_rate, _wallet, _token)
1093     CappedCrowdsale(_cap)
1094     TimedCrowdsale(_openingTime, _closingTime)
1095     RefundableCrowdsale(_goal)
1096   {
1097     minimumInvestment = _minimumInvestment;
1098     initialRate = _rate;
1099   }
1100 
1101 /*
1102  * @title pushPrivateInvestment
1103  * @dev The function tracks a private investment made in currencies other than ETH.
1104  * For a _weiAmount calculated based on the ETH value of some other currency, a _tokenAmount
1105  * amount of tokens will be minted post crowdsale for the _beneficiary
1106  * @param _weiAmount The value in wei calculated based on the value of the external currency
1107  * @param _tokenAmount The amount to be minted
1108  * @param _beneficiary The beneficiary of the tokens
1109  */
1110 
1111   function pushPrivateInvestment(uint256 _weiAmount, uint256 _tokenAmount, address _beneficiary) external onlyOwner {
1112     // solium-disable-next-line security/no-block-members
1113     require(block.timestamp <= closingTime);
1114     require(_weiAmount >= minimumInvestment, "Wei amount lower than minimum investment");
1115 
1116     require(_beneficiary != address(0));
1117     require(weiRaised.add(_weiAmount) <= cap);
1118 
1119     _deliverTokens(_beneficiary, _tokenAmount);
1120 
1121     // Wei added based on external value 
1122     weiRaised = weiRaised.add(_weiAmount);
1123 
1124     // Every user that participated in private investments is whitelisted
1125     _addToWhitelist(_beneficiary);
1126 
1127     emit TokenPurchase(
1128       msg.sender,
1129       _beneficiary,
1130       _weiAmount,
1131       _tokenAmount
1132     );
1133   }
1134 
1135 /*
1136  * @title changeRate
1137  * @dev The function sets the rate for exchanging ETH for tokens
1138  * Rate can be changed only if new rate value is greater than the old rate value
1139  * @param _newRate new rate value
1140  */
1141   function changeRate(uint256 _newRate) external onlyOwner {
1142     // solium-disable-next-line security/no-block-members
1143     require(block.timestamp <= closingTime);
1144     require(_newRate >= initialRate, "New rate must be greater than initial rate");
1145 
1146     rate = _newRate;
1147   }
1148 
1149   // -----------------------------------------
1150   // Internal interface (extensible)
1151   // -----------------------------------------
1152 
1153   /*
1154    * @dev Validation of an incoming purchase. Use require statements 
1155    * to revert state when conditions are not met. Use super to concatenate validations.
1156    * @param _beneficiary Address performing the token purchase
1157    * @param _weiAmount Value in wei involved in the purchase
1158    */
1159   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
1160     require(_weiAmount != 0);
1161     require(_weiAmount >= minimumInvestment, "Wei amount lower than minimum investment");
1162     super._preValidatePurchase(_beneficiary, _weiAmount);
1163   }
1164 
1165   /*
1166    * @dev Add the beneficiary to the whitelist. Used internally for private
1167    * investors since every private investor is automatically whitelisted.
1168    * minted and can be claimed post crowdsale
1169    * @param _beneficiary The address that will be whitelisted
1170    */
1171   function _addToWhitelist(address _beneficiary) private {
1172     whitelist[_beneficiary] = true;
1173   }
1174 }
1175 
1176 // File: openzeppelin-solidity/contracts/token/ERC20/CappedToken.sol
1177 
1178 /**
1179  * @title Capped token
1180  * @dev Mintable token with a token cap.
1181  */
1182 contract CappedToken is MintableToken {
1183 
1184   uint256 public cap;
1185 
1186   constructor(uint256 _cap) public {
1187     require(_cap > 0);
1188     cap = _cap;
1189   }
1190 
1191   /**
1192    * @dev Function to mint tokens
1193    * @param _to The address that will receive the minted tokens.
1194    * @param _amount The amount of tokens to mint.
1195    * @return A boolean that indicates if the operation was successful.
1196    */
1197   function mint(
1198     address _to,
1199     uint256 _amount
1200   )
1201     onlyOwner
1202     canMint
1203     public
1204     returns (bool)
1205   {
1206     require(totalSupply_.add(_amount) <= cap);
1207 
1208     return super.mint(_to, _amount);
1209   }
1210 
1211 }
1212 
1213 // File: contracts/GBEToken.sol
1214 
1215 /*
1216  * @title GBEToken
1217  * @dev Mintable ERC20 compliant token.
1218  */
1219 contract GBEToken is CappedToken {
1220 
1221   string public constant name = "GBE Token"; // solium-disable-line uppercase
1222   string public constant symbol = "GBE"; // solium-disable-line uppercase
1223   uint8 public constant decimals = 18; // solium-disable-line uppercase
1224 
1225   // 4 * (10 ** 6) * (10 ** 18) 4M tokens
1226   uint256 public constant advisorsAmount = 4000000000000000000000000; // solium-disable-line uppercase
1227   // 21 * (10 ** 6) * (10 ** 18) 21M tokens
1228   uint256 public constant companyAmount = 21000000000000000000000000; // solium-disable-line uppercase
1229   // 2 * (10 ** 6) * (10 ** 18) 2M tokens
1230   uint256 public constant teamAmount = 2000000000000000000000000; // solium-disable-line uppercase
1231 
1232   address public constant advisorsWallet = 0xD9fFAAd95B151D6B50df0a3770B4481cA320F530; // solium-disable-line uppercase
1233   address public constant companyWallet = 0xFCcD1bD20aE0635D6AB5181cdA2c3de660f074C4; // solium-disable-line uppercase
1234   address public constant teamWallet = 0x27950EcE748A9a1A1F0AA6167Cd39893e7f39819; // solium-disable-line uppercase
1235 
1236   constructor(uint256 _cap) public CappedToken(_cap){
1237     super.mint(advisorsWallet, advisorsAmount);
1238     super.mint(companyWallet, companyAmount);
1239     super.mint(teamWallet, teamAmount);
1240   }
1241 }