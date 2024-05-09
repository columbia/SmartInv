1 pragma solidity ^0.4.24;
2 
3 // File: node_modules\zeppelin-solidity\contracts\math\SafeMath.sol
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
55 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
56 
57 /**
58  * @title ERC20Basic
59  * @dev Simpler version of ERC20 interface
60  * See https://github.com/ethereum/EIPs/issues/179
61  */
62 contract ERC20Basic {
63   function totalSupply() public view returns (uint256);
64   function balanceOf(address who) public view returns (uint256);
65   function transfer(address to, uint256 value) public returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\ERC20.sol
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
90 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\SafeERC20.sol
91 
92 /**
93  * @title SafeERC20
94  * @dev Wrappers around ERC20 operations that throw on failure.
95  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
96  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
97  */
98 library SafeERC20 {
99   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
100     require(token.transfer(to, value));
101   }
102 
103   function safeTransferFrom(
104     ERC20 token,
105     address from,
106     address to,
107     uint256 value
108   )
109     internal
110   {
111     require(token.transferFrom(from, to, value));
112   }
113 
114   function safeApprove(ERC20 token, address spender, uint256 value) internal {
115     require(token.approve(spender, value));
116   }
117 }
118 
119 // File: node_modules\zeppelin-solidity\contracts\crowdsale\Crowdsale.sol
120 
121 /**
122  * @title Crowdsale
123  * @dev Crowdsale is a base contract for managing a token crowdsale,
124  * allowing investors to purchase tokens with ether. This contract implements
125  * such functionality in its most fundamental form and can be extended to provide additional
126  * functionality and/or custom behavior.
127  * The external interface represents the basic interface for purchasing tokens, and conform
128  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
129  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
130  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
131  * behavior.
132  */
133 contract Crowdsale {
134   using SafeMath for uint256;
135   using SafeERC20 for ERC20;
136 
137   // The token being sold
138   ERC20 public token;
139 
140   // Address where funds are collected
141   address public wallet;
142 
143   // How many token units a buyer gets per wei.
144   // The rate is the conversion between wei and the smallest and indivisible token unit.
145   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
146   // 1 wei will give you 1 unit, or 0.001 TOK.
147   uint256 public rate;
148 
149   // Amount of wei raised
150   uint256 public weiRaised;
151 
152   /**
153    * Event for token purchase logging
154    * @param purchaser who paid for the tokens
155    * @param beneficiary who got the tokens
156    * @param value weis paid for purchase
157    * @param amount amount of tokens purchased
158    */
159   event TokenPurchase(
160     address indexed purchaser,
161     address indexed beneficiary,
162     uint256 value,
163     uint256 amount
164   );
165 
166   /**
167    * @param _rate Number of token units a buyer gets per wei
168    * @param _wallet Address where collected funds will be forwarded to
169    * @param _token Address of the token being sold
170    */
171   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
172     require(_rate > 0);
173     require(_wallet != address(0));
174     require(_token != address(0));
175 
176     rate = _rate;
177     wallet = _wallet;
178     token = _token;
179   }
180 
181   // -----------------------------------------
182   // Crowdsale external interface
183   // -----------------------------------------
184 
185   /**
186    * @dev fallback function ***DO NOT OVERRIDE***
187    */
188   function () external payable {
189     buyTokens(msg.sender);
190   }
191 
192   /**
193    * @dev low level token purchase ***DO NOT OVERRIDE***
194    * @param _beneficiary Address performing the token purchase
195    */
196   function buyTokens(address _beneficiary) public payable {
197 
198     uint256 weiAmount = msg.value;
199     _preValidatePurchase(_beneficiary, weiAmount);
200 
201     // calculate token amount to be created
202     uint256 tokens = _getTokenAmount(weiAmount);
203 
204     // update state
205     weiRaised = weiRaised.add(weiAmount);
206 
207     _processPurchase(_beneficiary, tokens);
208     emit TokenPurchase(
209       msg.sender,
210       _beneficiary,
211       weiAmount,
212       tokens
213     );
214 
215     _updatePurchasingState(_beneficiary, weiAmount);
216 
217     _forwardFunds();
218     _postValidatePurchase(_beneficiary, weiAmount);
219   }
220 
221   // -----------------------------------------
222   // Internal interface (extensible)
223   // -----------------------------------------
224 
225   /**
226    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
227    * @param _beneficiary Address performing the token purchase
228    * @param _weiAmount Value in wei involved in the purchase
229    */
230   function _preValidatePurchase(
231     address _beneficiary,
232     uint256 _weiAmount
233   )
234     internal
235   {
236     require(_beneficiary != address(0));
237     require(_weiAmount != 0);
238   }
239 
240   /**
241    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
242    * @param _beneficiary Address performing the token purchase
243    * @param _weiAmount Value in wei involved in the purchase
244    */
245   function _postValidatePurchase(
246     address _beneficiary,
247     uint256 _weiAmount
248   )
249     internal
250   {
251     // optional override
252   }
253 
254   /**
255    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
256    * @param _beneficiary Address performing the token purchase
257    * @param _tokenAmount Number of tokens to be emitted
258    */
259   function _deliverTokens(
260     address _beneficiary,
261     uint256 _tokenAmount
262   )
263     internal
264   {
265     token.safeTransfer(_beneficiary, _tokenAmount);
266   }
267 
268   /**
269    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
270    * @param _beneficiary Address receiving the tokens
271    * @param _tokenAmount Number of tokens to be purchased
272    */
273   function _processPurchase(
274     address _beneficiary,
275     uint256 _tokenAmount
276   )
277     internal
278   {
279     _deliverTokens(_beneficiary, _tokenAmount);
280   }
281 
282   /**
283    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
284    * @param _beneficiary Address receiving the tokens
285    * @param _weiAmount Value in wei involved in the purchase
286    */
287   function _updatePurchasingState(
288     address _beneficiary,
289     uint256 _weiAmount
290   )
291     internal
292   {
293     // optional override
294   }
295 
296   /**
297    * @dev Override to extend the way in which ether is converted to tokens.
298    * @param _weiAmount Value in wei to be converted into tokens
299    * @return Number of tokens that can be purchased with the specified _weiAmount
300    */
301   function _getTokenAmount(uint256 _weiAmount)
302     internal view returns (uint256)
303   {
304     return _weiAmount.mul(rate);
305   }
306 
307   /**
308    * @dev Determines how ETH is stored/forwarded on purchases.
309    */
310   function _forwardFunds() internal {
311     wallet.transfer(msg.value);
312   }
313 }
314 
315 // File: node_modules\zeppelin-solidity\contracts\ownership\Ownable.sol
316 
317 /**
318  * @title Ownable
319  * @dev The Ownable contract has an owner address, and provides basic authorization control
320  * functions, this simplifies the implementation of "user permissions".
321  */
322 contract Ownable {
323   address public owner;
324 
325 
326   event OwnershipRenounced(address indexed previousOwner);
327   event OwnershipTransferred(
328     address indexed previousOwner,
329     address indexed newOwner
330   );
331 
332 
333   /**
334    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
335    * account.
336    */
337   constructor() public {
338     owner = msg.sender;
339   }
340 
341   /**
342    * @dev Throws if called by any account other than the owner.
343    */
344   modifier onlyOwner() {
345     require(msg.sender == owner);
346     _;
347   }
348 
349   /**
350    * @dev Allows the current owner to relinquish control of the contract.
351    * @notice Renouncing to ownership will leave the contract without an owner.
352    * It will not be possible to call the functions with the `onlyOwner`
353    * modifier anymore.
354    */
355   function renounceOwnership() public onlyOwner {
356     emit OwnershipRenounced(owner);
357     owner = address(0);
358   }
359 
360   /**
361    * @dev Allows the current owner to transfer control of the contract to a newOwner.
362    * @param _newOwner The address to transfer ownership to.
363    */
364   function transferOwnership(address _newOwner) public onlyOwner {
365     _transferOwnership(_newOwner);
366   }
367 
368   /**
369    * @dev Transfers control of the contract to a newOwner.
370    * @param _newOwner The address to transfer ownership to.
371    */
372   function _transferOwnership(address _newOwner) internal {
373     require(_newOwner != address(0));
374     emit OwnershipTransferred(owner, _newOwner);
375     owner = _newOwner;
376   }
377 }
378 
379 // File: node_modules\zeppelin-solidity\contracts\crowdsale\validation\TimedCrowdsale.sol
380 
381 /**
382  * @title TimedCrowdsale
383  * @dev Crowdsale accepting contributions only within a time frame.
384  */
385 contract TimedCrowdsale is Crowdsale {
386   using SafeMath for uint256;
387 
388   uint256 public openingTime;
389   uint256 public closingTime;
390 
391   /**
392    * @dev Reverts if not in crowdsale time range.
393    */
394   modifier onlyWhileOpen {
395     // solium-disable-next-line security/no-block-members
396     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
397     _;
398   }
399 
400   /**
401    * @dev Constructor, takes crowdsale opening and closing times.
402    * @param _openingTime Crowdsale opening time
403    * @param _closingTime Crowdsale closing time
404    */
405   constructor(uint256 _openingTime, uint256 _closingTime) public {
406     // solium-disable-next-line security/no-block-members
407     require(_openingTime >= block.timestamp);
408     require(_closingTime >= _openingTime);
409 
410     openingTime = _openingTime;
411     closingTime = _closingTime;
412   }
413 
414   /**
415    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
416    * @return Whether crowdsale period has elapsed
417    */
418   function hasClosed() public view returns (bool) {
419     // solium-disable-next-line security/no-block-members
420     return block.timestamp > closingTime;
421   }
422 
423   /**
424    * @dev Extend parent behavior requiring to be within contributing period
425    * @param _beneficiary Token purchaser
426    * @param _weiAmount Amount of wei contributed
427    */
428   function _preValidatePurchase(
429     address _beneficiary,
430     uint256 _weiAmount
431   )
432     internal
433     onlyWhileOpen
434   {
435     super._preValidatePurchase(_beneficiary, _weiAmount);
436   }
437 
438 }
439 
440 // File: node_modules\zeppelin-solidity\contracts\crowdsale\distribution\FinalizableCrowdsale.sol
441 
442 /**
443  * @title FinalizableCrowdsale
444  * @dev Extension of Crowdsale where an owner can do extra work
445  * after finishing.
446  */
447 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
448   using SafeMath for uint256;
449 
450   bool public isFinalized = false;
451 
452   event Finalized();
453 
454   /**
455    * @dev Must be called after crowdsale ends, to do some extra finalization
456    * work. Calls the contract's finalization function.
457    */
458   function finalize() onlyOwner public {
459     require(!isFinalized);
460     require(hasClosed());
461 
462     finalization();
463     emit Finalized();
464 
465     isFinalized = true;
466   }
467 
468   /**
469    * @dev Can be overridden to add finalization logic. The overriding function
470    * should call super.finalization() to ensure the chain of finalization is
471    * executed entirely.
472    */
473   function finalization() internal {
474   }
475 
476 }
477 
478 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\BasicToken.sol
479 
480 /**
481  * @title Basic token
482  * @dev Basic version of StandardToken, with no allowances.
483  */
484 contract BasicToken is ERC20Basic {
485   using SafeMath for uint256;
486 
487   mapping(address => uint256) balances;
488 
489   uint256 totalSupply_;
490 
491   /**
492   * @dev Total number of tokens in existence
493   */
494   function totalSupply() public view returns (uint256) {
495     return totalSupply_;
496   }
497 
498   /**
499   * @dev Transfer token for a specified address
500   * @param _to The address to transfer to.
501   * @param _value The amount to be transferred.
502   */
503   function transfer(address _to, uint256 _value) public returns (bool) {
504     require(_to != address(0));
505     require(_value <= balances[msg.sender]);
506 
507     balances[msg.sender] = balances[msg.sender].sub(_value);
508     balances[_to] = balances[_to].add(_value);
509     emit Transfer(msg.sender, _to, _value);
510     return true;
511   }
512 
513   /**
514   * @dev Gets the balance of the specified address.
515   * @param _owner The address to query the the balance of.
516   * @return An uint256 representing the amount owned by the passed address.
517   */
518   function balanceOf(address _owner) public view returns (uint256) {
519     return balances[_owner];
520   }
521 
522 }
523 
524 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\StandardToken.sol
525 
526 /**
527  * @title Standard ERC20 token
528  *
529  * @dev Implementation of the basic standard token.
530  * https://github.com/ethereum/EIPs/issues/20
531  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
532  */
533 contract StandardToken is ERC20, BasicToken {
534 
535   mapping (address => mapping (address => uint256)) internal allowed;
536 
537 
538   /**
539    * @dev Transfer tokens from one address to another
540    * @param _from address The address which you want to send tokens from
541    * @param _to address The address which you want to transfer to
542    * @param _value uint256 the amount of tokens to be transferred
543    */
544   function transferFrom(
545     address _from,
546     address _to,
547     uint256 _value
548   )
549     public
550     returns (bool)
551   {
552     require(_to != address(0));
553     require(_value <= balances[_from]);
554     require(_value <= allowed[_from][msg.sender]);
555 
556     balances[_from] = balances[_from].sub(_value);
557     balances[_to] = balances[_to].add(_value);
558     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
559     emit Transfer(_from, _to, _value);
560     return true;
561   }
562 
563   /**
564    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
565    * Beware that changing an allowance with this method brings the risk that someone may use both the old
566    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
567    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
568    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
569    * @param _spender The address which will spend the funds.
570    * @param _value The amount of tokens to be spent.
571    */
572   function approve(address _spender, uint256 _value) public returns (bool) {
573     allowed[msg.sender][_spender] = _value;
574     emit Approval(msg.sender, _spender, _value);
575     return true;
576   }
577 
578   /**
579    * @dev Function to check the amount of tokens that an owner allowed to a spender.
580    * @param _owner address The address which owns the funds.
581    * @param _spender address The address which will spend the funds.
582    * @return A uint256 specifying the amount of tokens still available for the spender.
583    */
584   function allowance(
585     address _owner,
586     address _spender
587    )
588     public
589     view
590     returns (uint256)
591   {
592     return allowed[_owner][_spender];
593   }
594 
595   /**
596    * @dev Increase the amount of tokens that an owner allowed to a spender.
597    * approve should be called when allowed[_spender] == 0. To increment
598    * allowed value is better to use this function to avoid 2 calls (and wait until
599    * the first transaction is mined)
600    * From MonolithDAO Token.sol
601    * @param _spender The address which will spend the funds.
602    * @param _addedValue The amount of tokens to increase the allowance by.
603    */
604   function increaseApproval(
605     address _spender,
606     uint256 _addedValue
607   )
608     public
609     returns (bool)
610   {
611     allowed[msg.sender][_spender] = (
612       allowed[msg.sender][_spender].add(_addedValue));
613     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
614     return true;
615   }
616 
617   /**
618    * @dev Decrease the amount of tokens that an owner allowed to a spender.
619    * approve should be called when allowed[_spender] == 0. To decrement
620    * allowed value is better to use this function to avoid 2 calls (and wait until
621    * the first transaction is mined)
622    * From MonolithDAO Token.sol
623    * @param _spender The address which will spend the funds.
624    * @param _subtractedValue The amount of tokens to decrease the allowance by.
625    */
626   function decreaseApproval(
627     address _spender,
628     uint256 _subtractedValue
629   )
630     public
631     returns (bool)
632   {
633     uint256 oldValue = allowed[msg.sender][_spender];
634     if (_subtractedValue > oldValue) {
635       allowed[msg.sender][_spender] = 0;
636     } else {
637       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
638     }
639     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
640     return true;
641   }
642 
643 }
644 
645 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\MintableToken.sol
646 
647 /**
648  * @title Mintable token
649  * @dev Simple ERC20 Token example, with mintable token creation
650  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
651  */
652 contract MintableToken is StandardToken, Ownable {
653   event Mint(address indexed to, uint256 amount);
654   event MintFinished();
655 
656   bool public mintingFinished = false;
657 
658 
659   modifier canMint() {
660     require(!mintingFinished);
661     _;
662   }
663 
664   modifier hasMintPermission() {
665     require(msg.sender == owner);
666     _;
667   }
668 
669   /**
670    * @dev Function to mint tokens
671    * @param _to The address that will receive the minted tokens.
672    * @param _amount The amount of tokens to mint.
673    * @return A boolean that indicates if the operation was successful.
674    */
675   function mint(
676     address _to,
677     uint256 _amount
678   )
679     hasMintPermission
680     canMint
681     public
682     returns (bool)
683   {
684     totalSupply_ = totalSupply_.add(_amount);
685     balances[_to] = balances[_to].add(_amount);
686     emit Mint(_to, _amount);
687     emit Transfer(address(0), _to, _amount);
688     return true;
689   }
690 
691   /**
692    * @dev Function to stop minting new tokens.
693    * @return True if the operation was successful.
694    */
695   function finishMinting() onlyOwner canMint public returns (bool) {
696     mintingFinished = true;
697     emit MintFinished();
698     return true;
699   }
700 }
701 
702 // File: node_modules\zeppelin-solidity\contracts\crowdsale\emission\MintedCrowdsale.sol
703 
704 /**
705  * @title MintedCrowdsale
706  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
707  * Token ownership should be transferred to MintedCrowdsale for minting.
708  */
709 contract MintedCrowdsale is Crowdsale {
710 
711   /**
712    * @dev Overrides delivery by minting tokens upon purchase.
713    * @param _beneficiary Token purchaser
714    * @param _tokenAmount Number of tokens to be minted
715    */
716   function _deliverTokens(
717     address _beneficiary,
718     uint256 _tokenAmount
719   )
720     internal
721   {
722     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
723   }
724 }
725 
726 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\CappedToken.sol
727 
728 /**
729  * @title Capped token
730  * @dev Mintable token with a token cap.
731  */
732 contract CappedToken is MintableToken {
733 
734   uint256 public cap;
735 
736   constructor(uint256 _cap) public {
737     require(_cap > 0);
738     cap = _cap;
739   }
740 
741   /**
742    * @dev Function to mint tokens
743    * @param _to The address that will receive the minted tokens.
744    * @param _amount The amount of tokens to mint.
745    * @return A boolean that indicates if the operation was successful.
746    */
747   function mint(
748     address _to,
749     uint256 _amount
750   )
751     public
752     returns (bool)
753   {
754     require(totalSupply_.add(_amount) <= cap);
755 
756     return super.mint(_to, _amount);
757   }
758 
759 }
760 
761 // File: node_modules\zeppelin-solidity\contracts\math\Math.sol
762 
763 /**
764  * @title Math
765  * @dev Assorted math operations
766  */
767 library Math {
768   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
769     return a >= b ? a : b;
770   }
771 
772   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
773     return a < b ? a : b;
774   }
775 
776   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
777     return a >= b ? a : b;
778   }
779 
780   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
781     return a < b ? a : b;
782   }
783 }
784 
785 // File: node_modules\zeppelin-solidity\contracts\payment\Escrow.sol
786 
787 /**
788  * @title Escrow
789  * @dev Base escrow contract, holds funds destinated to a payee until they
790  * withdraw them. The contract that uses the escrow as its payment method
791  * should be its owner, and provide public methods redirecting to the escrow's
792  * deposit and withdraw.
793  */
794 contract Escrow is Ownable {
795   using SafeMath for uint256;
796 
797   event Deposited(address indexed payee, uint256 weiAmount);
798   event Withdrawn(address indexed payee, uint256 weiAmount);
799 
800   mapping(address => uint256) private deposits;
801 
802   function depositsOf(address _payee) public view returns (uint256) {
803     return deposits[_payee];
804   }
805 
806   /**
807   * @dev Stores the sent amount as credit to be withdrawn.
808   * @param _payee The destination address of the funds.
809   */
810   function deposit(address _payee) public onlyOwner payable {
811     uint256 amount = msg.value;
812     deposits[_payee] = deposits[_payee].add(amount);
813 
814     emit Deposited(_payee, amount);
815   }
816 
817   /**
818   * @dev Withdraw accumulated balance for a payee.
819   * @param _payee The address whose funds will be withdrawn and transferred to.
820   */
821   function withdraw(address _payee) public onlyOwner {
822     uint256 payment = deposits[_payee];
823     assert(address(this).balance >= payment);
824 
825     deposits[_payee] = 0;
826 
827     _payee.transfer(payment);
828 
829     emit Withdrawn(_payee, payment);
830   }
831 }
832 
833 // File: node_modules\zeppelin-solidity\contracts\payment\ConditionalEscrow.sol
834 
835 /**
836  * @title ConditionalEscrow
837  * @dev Base abstract escrow to only allow withdrawal if a condition is met.
838  */
839 contract ConditionalEscrow is Escrow {
840   /**
841   * @dev Returns whether an address is allowed to withdraw their funds. To be
842   * implemented by derived contracts.
843   * @param _payee The destination address of the funds.
844   */
845   function withdrawalAllowed(address _payee) public view returns (bool);
846 
847   function withdraw(address _payee) public {
848     require(withdrawalAllowed(_payee));
849     super.withdraw(_payee);
850   }
851 }
852 
853 // File: node_modules\zeppelin-solidity\contracts\payment\RefundEscrow.sol
854 
855 /**
856  * @title RefundEscrow
857  * @dev Escrow that holds funds for a beneficiary, deposited from multiple parties.
858  * The contract owner may close the deposit period, and allow for either withdrawal
859  * by the beneficiary, or refunds to the depositors.
860  */
861 contract RefundEscrow is Ownable, ConditionalEscrow {
862   enum State { Active, Refunding, Closed }
863 
864   event Closed();
865   event RefundsEnabled();
866 
867   State public state;
868   address public beneficiary;
869 
870   /**
871    * @dev Constructor.
872    * @param _beneficiary The beneficiary of the deposits.
873    */
874   constructor(address _beneficiary) public {
875     require(_beneficiary != address(0));
876     beneficiary = _beneficiary;
877     state = State.Active;
878   }
879 
880   /**
881    * @dev Stores funds that may later be refunded.
882    * @param _refundee The address funds will be sent to if a refund occurs.
883    */
884   function deposit(address _refundee) public payable {
885     require(state == State.Active);
886     super.deposit(_refundee);
887   }
888 
889   /**
890    * @dev Allows for the beneficiary to withdraw their funds, rejecting
891    * further deposits.
892    */
893   function close() public onlyOwner {
894     require(state == State.Active);
895     state = State.Closed;
896     emit Closed();
897   }
898 
899   /**
900    * @dev Allows for refunds to take place, rejecting further deposits.
901    */
902   function enableRefunds() public onlyOwner {
903     require(state == State.Active);
904     state = State.Refunding;
905     emit RefundsEnabled();
906   }
907 
908   /**
909    * @dev Withdraws the beneficiary's funds.
910    */
911   function beneficiaryWithdraw() public {
912     require(state == State.Closed);
913     beneficiary.transfer(address(this).balance);
914   }
915 
916   /**
917    * @dev Returns whether refundees can withdraw their deposits (be refunded).
918    */
919   function withdrawalAllowed(address _payee) public view returns (bool) {
920     return state == State.Refunding;
921   }
922 }
923 
924 // File: contracts\ClinicAllRefundEscrow.sol
925 
926 /**
927  * @title ClinicAllRefundEscrow
928  * @dev Escrow that holds funds for a beneficiary, deposited from multiple parties.
929  * The contract owner may close the deposit period, and allow for either withdrawal
930  * by the beneficiary, or refunds to the depositors.
931  */
932 contract ClinicAllRefundEscrow is RefundEscrow {
933   using Math for uint256;
934 
935   struct RefundeeRecord {
936     bool isRefunded;
937     uint256 index;
938   }
939 
940   mapping(address => RefundeeRecord) public refundees;
941   address[] internal refundeesList;
942 
943   event Deposited(address indexed payee, uint256 weiAmount);
944   event Withdrawn(address indexed payee, uint256 weiAmount);
945 
946   mapping(address => uint256) private deposits;
947   mapping(address => uint256) private beneficiaryDeposits;
948 
949   // Amount of wei deposited by beneficiary
950   uint256 public beneficiaryDepositedAmount;
951 
952   // Amount of wei deposited by investors to CrowdSale
953   uint256 public investorsDepositedToCrowdSaleAmount;
954 
955   /**
956    * @dev Constructor.
957    * @param _beneficiary The beneficiary of the deposits.
958    */
959   constructor(address _beneficiary)
960   RefundEscrow(_beneficiary)
961   public {
962   }
963 
964   function depositsOf(address _payee) public view returns (uint256) {
965     return deposits[_payee];
966   }
967 
968   function beneficiaryDepositsOf(address _payee) public view returns (uint256) {
969     return beneficiaryDeposits[_payee];
970   }
971 
972 
973 
974   /**
975    * @dev Stores funds that may later be refunded.
976    * @param _refundee The address funds will be sent to if a refund occurs.
977    */
978   function deposit(address _refundee) public payable {
979     uint256 amount = msg.value;
980     beneficiaryDeposits[_refundee] = beneficiaryDeposits[_refundee].add(amount);
981     beneficiaryDepositedAmount = beneficiaryDepositedAmount.add(amount);
982   }
983 
984   /**
985  * @dev Stores funds that may later be refunded.
986  * @param _refundee The address funds will be sent to if a refund occurs.
987  * @param _value The amount of funds will be sent to if a refund occurs.
988  */
989   function depositFunds(address _refundee, uint256 _value) public onlyOwner {
990     require(state == State.Active, "Funds deposition is possible only in the Active state.");
991 
992     uint256 amount = _value;
993     deposits[_refundee] = deposits[_refundee].add(amount);
994     investorsDepositedToCrowdSaleAmount = investorsDepositedToCrowdSaleAmount.add(amount);
995 
996     emit Deposited(_refundee, amount);
997 
998     RefundeeRecord storage _data = refundees[_refundee];
999     _data.isRefunded = false;
1000 
1001     if (_data.index == uint256(0)) {
1002       refundeesList.push(_refundee);
1003       _data.index = refundeesList.length.sub(1);
1004     }
1005   }
1006 
1007   /**
1008   * @dev Allows for the beneficiary to withdraw their funds, rejecting
1009   * further deposits.
1010   */
1011   function close() public onlyOwner {
1012     super.close();
1013   }
1014 
1015   function withdraw(address _payee) public onlyOwner {
1016     require(state == State.Refunding, "Funds withdrawal is possible only in the Refunding state.");
1017     require(depositsOf(_payee) > 0, "An investor should have non-negative deposit for withdrawal.");
1018 
1019     RefundeeRecord storage _data = refundees[_payee];
1020     require(_data.isRefunded == false, "An investor should not be refunded.");
1021 
1022     uint256 payment = deposits[_payee];
1023     assert(address(this).balance >= payment);
1024 
1025     deposits[_payee] = 0;
1026 
1027     investorsDepositedToCrowdSaleAmount = investorsDepositedToCrowdSaleAmount.sub(payment);
1028 
1029     _payee.transfer(payment);
1030 
1031     emit Withdrawn(_payee, payment);
1032 
1033     _data.isRefunded = true;
1034 
1035     removeRefundeeByIndex(_data.index);
1036   }
1037 
1038   /**
1039   @dev Owner can do manual refund here if investore has "BAD" money
1040   @param _payee address of investor that needs to refund with next manual ETH sending
1041   */
1042   function manualRefund(address _payee) public onlyOwner {
1043     RefundeeRecord storage _data = refundees[_payee];
1044 
1045     deposits[_payee] = 0;
1046     _data.isRefunded = true;
1047 
1048     removeRefundeeByIndex(_data.index);
1049   }
1050 
1051   /**
1052   * @dev Remove refundee referenced index from the internal list
1053   * @param _indexToDelete An index in an array for deletion
1054   */
1055   function removeRefundeeByIndex(uint256 _indexToDelete) private {
1056     if ((refundeesList.length > 0) && (_indexToDelete < refundeesList.length)) {
1057       uint256 _lastIndex = refundeesList.length.sub(1);
1058       refundeesList[_indexToDelete] = refundeesList[_lastIndex];
1059       refundeesList.length--;
1060     }
1061   }
1062   /**
1063   * @dev Get refundee list length
1064   */
1065   function refundeesListLength() public onlyOwner view returns (uint256) {
1066     return refundeesList.length;
1067   }
1068 
1069   /**
1070   * @dev Auto refund
1071   * @param _txFee The cost of executing refund code
1072   */
1073   function withdrawChunk(uint256 _txFee, uint256 _chunkLength) public onlyOwner returns (uint256, address[]) {
1074     require(state == State.Refunding, "Funds withdrawal is possible only in the Refunding state.");
1075 
1076     uint256 _refundeesCount = refundeesList.length;
1077     require(_chunkLength >= _refundeesCount);
1078     require(_txFee > 0, "Transaction fee should be above zero.");
1079     require(_refundeesCount > 0, "List of investors should not be empty.");
1080     uint256 _weiRefunded = 0;
1081     require(address(this).balance > (_chunkLength.mul(_txFee)), "Account's ballance should allow to pay all tx fees.");
1082     address[] memory _refundeesListCopy = new address[](_chunkLength);
1083 
1084     uint256 i;
1085     for (i = 0; i < _chunkLength; i++) {
1086       address _refundee = refundeesList[i];
1087       RefundeeRecord storage _data = refundees[_refundee];
1088       if (_data.isRefunded == false) {
1089         if (depositsOf(_refundee) > _txFee) {
1090           uint256 _deposit = depositsOf(_refundee);
1091           if (_deposit > _txFee) {
1092             _weiRefunded = _weiRefunded.add(_deposit);
1093             uint256 _paymentWithoutTxFee = _deposit.sub(_txFee);
1094             _refundee.transfer(_paymentWithoutTxFee);
1095             emit Withdrawn(_refundee, _paymentWithoutTxFee);
1096             _data.isRefunded = true;
1097             _refundeesListCopy[i] = _refundee;
1098           }
1099         }
1100       }
1101     }
1102 
1103     for (i = 0; i < _chunkLength; i++) {
1104       if (address(0) != _refundeesListCopy[i]) {
1105         RefundeeRecord storage _dataCleanup = refundees[_refundeesListCopy[i]];
1106         require(_dataCleanup.isRefunded == true, "Investors in this list should be refunded.");
1107         removeRefundeeByIndex(_dataCleanup.index);
1108       }
1109     }
1110 
1111     return (_weiRefunded, _refundeesListCopy);
1112   }
1113 
1114   /**
1115   * @dev Auto refund
1116   * @param _txFee The cost of executing refund code
1117   */
1118   function withdrawEverything(uint256 _txFee) public onlyOwner returns (uint256, address[]) {
1119     require(state == State.Refunding, "Funds withdrawal is possible only in the Refunding state.");
1120     return withdrawChunk(_txFee, refundeesList.length);
1121   }
1122 
1123   /**
1124   * @dev Withdraws the part of beneficiary's funds.
1125   */
1126   function beneficiaryWithdrawChunk(uint256 _value) public onlyOwner {
1127     require(_value <= address(this).balance, "Withdraw part can not be more than current balance");
1128     beneficiaryDepositedAmount = beneficiaryDepositedAmount.sub(_value);
1129     beneficiary.transfer(_value);
1130   }
1131 
1132   /**
1133   * @dev Withdraws all beneficiary's funds.
1134   */
1135   function beneficiaryWithdrawAll() public onlyOwner {
1136     uint256 _value = address(this).balance;
1137     beneficiaryDepositedAmount = beneficiaryDepositedAmount.sub(_value);
1138     beneficiary.transfer(_value);
1139   }
1140 
1141 }
1142 
1143 // File: node_modules\zeppelin-solidity\contracts\lifecycle\TokenDestructible.sol
1144 
1145 /**
1146  * @title TokenDestructible:
1147  * @author Remco Bloemen <remco@2π.com>
1148  * @dev Base contract that can be destroyed by owner. All funds in contract including
1149  * listed tokens will be sent to the owner.
1150  */
1151 contract TokenDestructible is Ownable {
1152 
1153   constructor() public payable { }
1154 
1155   /**
1156    * @notice Terminate contract and refund to owner
1157    * @param tokens List of addresses of ERC20 or ERC20Basic token contracts to
1158    refund.
1159    * @notice The called token contracts could try to re-enter this contract. Only
1160    supply token contracts you trust.
1161    */
1162   function destroy(address[] tokens) onlyOwner public {
1163 
1164     // Transfer tokens to owner
1165     for (uint256 i = 0; i < tokens.length; i++) {
1166       ERC20Basic token = ERC20Basic(tokens[i]);
1167       uint256 balance = token.balanceOf(this);
1168       token.transfer(owner, balance);
1169     }
1170 
1171     // Transfer Eth to owner and terminate contract
1172     selfdestruct(owner);
1173   }
1174 }
1175 
1176 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\BurnableToken.sol
1177 
1178 /**
1179  * @title Burnable Token
1180  * @dev Token that can be irreversibly burned (destroyed).
1181  */
1182 contract BurnableToken is BasicToken {
1183 
1184   event Burn(address indexed burner, uint256 value);
1185 
1186   /**
1187    * @dev Burns a specific amount of tokens.
1188    * @param _value The amount of token to be burned.
1189    */
1190   function burn(uint256 _value) public {
1191     _burn(msg.sender, _value);
1192   }
1193 
1194   function _burn(address _who, uint256 _value) internal {
1195     require(_value <= balances[_who]);
1196     // no need to require value <= totalSupply, since that would imply the
1197     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
1198 
1199     balances[_who] = balances[_who].sub(_value);
1200     totalSupply_ = totalSupply_.sub(_value);
1201     emit Burn(_who, _value);
1202     emit Transfer(_who, address(0), _value);
1203   }
1204 }
1205 
1206 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\DetailedERC20.sol
1207 
1208 /**
1209  * @title DetailedERC20 token
1210  * @dev The decimals are only for visualization purposes.
1211  * All the operations are done using the smallest and indivisible token unit,
1212  * just as on Ethereum all the operations are done in wei.
1213  */
1214 contract DetailedERC20 is ERC20 {
1215   string public name;
1216   string public symbol;
1217   uint8 public decimals;
1218 
1219   constructor(string _name, string _symbol, uint8 _decimals) public {
1220     name = _name;
1221     symbol = _symbol;
1222     decimals = _decimals;
1223   }
1224 }
1225 
1226 // File: node_modules\zeppelin-solidity\contracts\lifecycle\Pausable.sol
1227 
1228 /**
1229  * @title Pausable
1230  * @dev Base contract which allows children to implement an emergency stop mechanism.
1231  */
1232 contract Pausable is Ownable {
1233   event Pause();
1234   event Unpause();
1235 
1236   bool public paused = false;
1237 
1238 
1239   /**
1240    * @dev Modifier to make a function callable only when the contract is not paused.
1241    */
1242   modifier whenNotPaused() {
1243     require(!paused);
1244     _;
1245   }
1246 
1247   /**
1248    * @dev Modifier to make a function callable only when the contract is paused.
1249    */
1250   modifier whenPaused() {
1251     require(paused);
1252     _;
1253   }
1254 
1255   /**
1256    * @dev called by the owner to pause, triggers stopped state
1257    */
1258   function pause() onlyOwner whenNotPaused public {
1259     paused = true;
1260     emit Pause();
1261   }
1262 
1263   /**
1264    * @dev called by the owner to unpause, returns to normal state
1265    */
1266   function unpause() onlyOwner whenPaused public {
1267     paused = false;
1268     emit Unpause();
1269   }
1270 }
1271 
1272 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\PausableToken.sol
1273 
1274 /**
1275  * @title Pausable token
1276  * @dev StandardToken modified with pausable transfers.
1277  **/
1278 contract PausableToken is StandardToken, Pausable {
1279 
1280   function transfer(
1281     address _to,
1282     uint256 _value
1283   )
1284     public
1285     whenNotPaused
1286     returns (bool)
1287   {
1288     return super.transfer(_to, _value);
1289   }
1290 
1291   function transferFrom(
1292     address _from,
1293     address _to,
1294     uint256 _value
1295   )
1296     public
1297     whenNotPaused
1298     returns (bool)
1299   {
1300     return super.transferFrom(_from, _to, _value);
1301   }
1302 
1303   function approve(
1304     address _spender,
1305     uint256 _value
1306   )
1307     public
1308     whenNotPaused
1309     returns (bool)
1310   {
1311     return super.approve(_spender, _value);
1312   }
1313 
1314   function increaseApproval(
1315     address _spender,
1316     uint _addedValue
1317   )
1318     public
1319     whenNotPaused
1320     returns (bool success)
1321   {
1322     return super.increaseApproval(_spender, _addedValue);
1323   }
1324 
1325   function decreaseApproval(
1326     address _spender,
1327     uint _subtractedValue
1328   )
1329     public
1330     whenNotPaused
1331     returns (bool success)
1332   {
1333     return super.decreaseApproval(_spender, _subtractedValue);
1334   }
1335 }
1336 
1337 // File: contracts\TransferableToken.sol
1338 
1339 /**
1340  * @title TransferableToken
1341  * @dev Base contract which allows to implement transfer for token.
1342  */
1343 contract TransferableToken is Ownable {
1344   event TransferOn();
1345   event TransferOff();
1346 
1347   bool public transferable = false;
1348 
1349   /**
1350    * @dev Modifier to make a function callable only when the contract is not transferable.
1351    */
1352   modifier whenNotTransferable() {
1353     require(!transferable);
1354     _;
1355   }
1356 
1357   /**
1358    * @dev Modifier to make a function callable only when the contract is transferable.
1359    */
1360   modifier whenTransferable() {
1361     require(transferable);
1362     _;
1363   }
1364 
1365   /**
1366    * @dev called by the owner to enable transfers
1367    */
1368   function transferOn() onlyOwner whenNotTransferable public {
1369     transferable = true;
1370     emit TransferOn();
1371   }
1372 
1373   /**
1374    * @dev called by the owner to disable transfers
1375    */
1376   function transferOff() onlyOwner whenTransferable public {
1377     transferable = false;
1378     emit TransferOff();
1379   }
1380 
1381 }
1382 
1383 // File: contracts\ClinicAllToken.sol
1384 
1385 contract ClinicAllToken is MintableToken, DetailedERC20, CappedToken, PausableToken, BurnableToken, TokenDestructible, TransferableToken {
1386   constructor
1387   (
1388     string _name,
1389     string _symbol,
1390     uint8 _decimals,
1391     uint256 _cap
1392   )
1393   DetailedERC20(_name, _symbol, _decimals)
1394   CappedToken(_cap)
1395   public
1396   {
1397 
1398   }
1399 
1400   /*/
1401   *  Refund event when ICO didn't pass soft cap and we refund ETH to investors + burn ERC-20 tokens from investors balances
1402   /*/
1403   function burnAfterRefund(address _who) public onlyOwner {
1404     uint256 _value = balances[_who];
1405     _burn(_who, _value);
1406   }
1407 
1408   /*/
1409   *  Allow transfers only if token is transferable
1410   /*/
1411   function transfer(
1412     address _to,
1413     uint256 _value
1414   )
1415   public
1416   whenTransferable
1417   returns (bool)
1418   {
1419     return super.transfer(_to, _value);
1420   }
1421 
1422   /*/
1423   *  Allow transfers only if token is transferable
1424   /*/
1425   function transferFrom(
1426     address _from,
1427     address _to,
1428     uint256 _value
1429   )
1430   public
1431   whenTransferable
1432   returns (bool)
1433   {
1434     return super.transferFrom(_from, _to, _value);
1435   }
1436 
1437   function transferToPrivateInvestor(
1438     address _from,
1439     address _to,
1440     uint256 _value
1441   )
1442   public
1443   onlyOwner
1444   returns (bool)
1445   {
1446     require(_to != address(0));
1447     require(_value <= balances[_from]);
1448 
1449     balances[_from] = balances[_from].sub(_value);
1450     balances[_to] = balances[_to].add(_value);
1451     emit Transfer(_from, _to, _value);
1452     return true;
1453   }
1454 
1455   function burnPrivateSale(address privateSaleWallet, uint256 _value) public onlyOwner {
1456     _burn(privateSaleWallet, _value);
1457   }
1458 
1459 }
1460 
1461 // File: node_modules\zeppelin-solidity\contracts\ownership\rbac\Roles.sol
1462 
1463 /**
1464  * @title Roles
1465  * @author Francisco Giordano (@frangio)
1466  * @dev Library for managing addresses assigned to a Role.
1467  * See RBAC.sol for example usage.
1468  */
1469 library Roles {
1470   struct Role {
1471     mapping (address => bool) bearer;
1472   }
1473 
1474   /**
1475    * @dev give an address access to this role
1476    */
1477   function add(Role storage role, address addr)
1478     internal
1479   {
1480     role.bearer[addr] = true;
1481   }
1482 
1483   /**
1484    * @dev remove an address' access to this role
1485    */
1486   function remove(Role storage role, address addr)
1487     internal
1488   {
1489     role.bearer[addr] = false;
1490   }
1491 
1492   /**
1493    * @dev check if an address has this role
1494    * // reverts
1495    */
1496   function check(Role storage role, address addr)
1497     view
1498     internal
1499   {
1500     require(has(role, addr));
1501   }
1502 
1503   /**
1504    * @dev check if an address has this role
1505    * @return bool
1506    */
1507   function has(Role storage role, address addr)
1508     view
1509     internal
1510     returns (bool)
1511   {
1512     return role.bearer[addr];
1513   }
1514 }
1515 
1516 // File: node_modules\zeppelin-solidity\contracts\ownership\rbac\RBAC.sol
1517 
1518 /**
1519  * @title RBAC (Role-Based Access Control)
1520  * @author Matt Condon (@Shrugs)
1521  * @dev Stores and provides setters and getters for roles and addresses.
1522  * Supports unlimited numbers of roles and addresses.
1523  * See //contracts/mocks/RBACMock.sol for an example of usage.
1524  * This RBAC method uses strings to key roles. It may be beneficial
1525  * for you to write your own implementation of this interface using Enums or similar.
1526  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
1527  * to avoid typos.
1528  */
1529 contract RBAC {
1530   using Roles for Roles.Role;
1531 
1532   mapping (string => Roles.Role) private roles;
1533 
1534   event RoleAdded(address indexed operator, string role);
1535   event RoleRemoved(address indexed operator, string role);
1536 
1537   /**
1538    * @dev reverts if addr does not have role
1539    * @param _operator address
1540    * @param _role the name of the role
1541    * // reverts
1542    */
1543   function checkRole(address _operator, string _role)
1544     view
1545     public
1546   {
1547     roles[_role].check(_operator);
1548   }
1549 
1550   /**
1551    * @dev determine if addr has role
1552    * @param _operator address
1553    * @param _role the name of the role
1554    * @return bool
1555    */
1556   function hasRole(address _operator, string _role)
1557     view
1558     public
1559     returns (bool)
1560   {
1561     return roles[_role].has(_operator);
1562   }
1563 
1564   /**
1565    * @dev add a role to an address
1566    * @param _operator address
1567    * @param _role the name of the role
1568    */
1569   function addRole(address _operator, string _role)
1570     internal
1571   {
1572     roles[_role].add(_operator);
1573     emit RoleAdded(_operator, _role);
1574   }
1575 
1576   /**
1577    * @dev remove a role from an address
1578    * @param _operator address
1579    * @param _role the name of the role
1580    */
1581   function removeRole(address _operator, string _role)
1582     internal
1583   {
1584     roles[_role].remove(_operator);
1585     emit RoleRemoved(_operator, _role);
1586   }
1587 
1588   /**
1589    * @dev modifier to scope access to a single role (uses msg.sender as addr)
1590    * @param _role the name of the role
1591    * // reverts
1592    */
1593   modifier onlyRole(string _role)
1594   {
1595     checkRole(msg.sender, _role);
1596     _;
1597   }
1598 
1599   /**
1600    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
1601    * @param _roles the names of the roles to scope access to
1602    * // reverts
1603    *
1604    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
1605    *  see: https://github.com/ethereum/solidity/issues/2467
1606    */
1607   // modifier onlyRoles(string[] _roles) {
1608   //     bool hasAnyRole = false;
1609   //     for (uint8 i = 0; i < _roles.length; i++) {
1610   //         if (hasRole(msg.sender, _roles[i])) {
1611   //             hasAnyRole = true;
1612   //             break;
1613   //         }
1614   //     }
1615 
1616   //     require(hasAnyRole);
1617 
1618   //     _;
1619   // }
1620 }
1621 
1622 // File: contracts\Managed.sol
1623 
1624 /**
1625  * @title Managed
1626  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
1627  * This simplifies the implementation of "user permissions".
1628  */
1629 contract Managed is Ownable, RBAC {
1630   string public constant ROLE_MANAGER = "manager";
1631 
1632   /**
1633   * @dev Throws if operator is not whitelisted.
1634   */
1635   modifier onlyManager() {
1636     checkRole(msg.sender, ROLE_MANAGER);
1637     _;
1638   }
1639 
1640   /**
1641   * @dev set an address as a manager
1642   * @param _operator address
1643   * @return true if the address was added to the whitelist, false if the address was already in the whitelist
1644   */
1645   function setManager(address _operator) public onlyOwner {
1646     addRole(_operator, ROLE_MANAGER);
1647   }
1648 
1649   /**
1650   * @dev delete an address as a manager
1651   * @param _operator address
1652   * @return true if the address was deleted from the whitelist, false if the address wasn't already in the whitelist
1653   */
1654   function removeManager(address _operator) public onlyOwner {
1655     removeRole(_operator, ROLE_MANAGER);
1656   }
1657 }
1658 
1659 // File: contracts\Limited.sol
1660 
1661 /**
1662  * @title LimitedCrowdsale
1663  * @dev Crowdsale in which only limited number of tokens can be bought.
1664  */
1665 contract Limited is Managed {
1666   using SafeMath for uint256;
1667   mapping(address => uint256) public limitsList;
1668 
1669   /**
1670   * @dev Reverts if beneficiary has no limit. Can be used when extending this contract.
1671   */
1672   modifier isLimited(address _payee) {
1673     require(limitsList[_payee] > 0, "An investor is limited if it has a limit.");
1674     _;
1675   }
1676 
1677 
1678   /**
1679   * @dev Reverts if beneficiary want to buy more tickets than limit allows. Can be used when extending this contract.
1680   */
1681   modifier doesNotExceedLimit(address _payee, uint256 _tokenAmount, uint256 _tokenBalance, uint256 kycLimitEliminator) {
1682     if(_tokenBalance.add(_tokenAmount) >= kycLimitEliminator) {
1683       require(_tokenBalance.add(_tokenAmount) <= getLimit(_payee), "An investor should not exceed its limit on buying.");
1684     }
1685     _;
1686   }
1687 
1688   /**
1689   * @dev Returns limits for _payee.
1690   * @param _payee Address to get token limits
1691   */
1692   function getLimit(address _payee)
1693   public view returns (uint256)
1694   {
1695     return limitsList[_payee];
1696   }
1697 
1698   /**
1699   * @dev Adds limits to addresses.
1700   * @param _payees Addresses to set limit
1701   * @param _limits Limit values to set to addresses
1702   */
1703   function addAddressesLimits(address[] _payees, uint256[] _limits) public
1704   onlyManager
1705   {
1706     require(_payees.length == _limits.length, "Array sizes should be equal.");
1707     for (uint256 i = 0; i < _payees.length; i++) {
1708       addLimit(_payees[i], _limits[i]);
1709     }
1710   }
1711 
1712 
1713   /**
1714   * @dev Adds limit to address.
1715   * @param _payee Address to set limit
1716   * @param _limit Limit value to set to address
1717   */
1718   function addLimit(address _payee, uint256 _limit) public
1719   onlyManager
1720   {
1721     limitsList[_payee] = _limit;
1722   }
1723 
1724 
1725   /**
1726   * @dev Removes single address-limit record.
1727   * @param _payee Address to be removed
1728   */
1729   function removeLimit(address _payee) external
1730   onlyManager
1731   {
1732     limitsList[_payee] = 0;
1733   }
1734 
1735 }
1736 
1737 // File: node_modules\zeppelin-solidity\contracts\access\Whitelist.sol
1738 
1739 /**
1740  * @title Whitelist
1741  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
1742  * This simplifies the implementation of "user permissions".
1743  */
1744 contract Whitelist is Ownable, RBAC {
1745   string public constant ROLE_WHITELISTED = "whitelist";
1746 
1747   /**
1748    * @dev Throws if operator is not whitelisted.
1749    * @param _operator address
1750    */
1751   modifier onlyIfWhitelisted(address _operator) {
1752     checkRole(_operator, ROLE_WHITELISTED);
1753     _;
1754   }
1755 
1756   /**
1757    * @dev add an address to the whitelist
1758    * @param _operator address
1759    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
1760    */
1761   function addAddressToWhitelist(address _operator)
1762     onlyOwner
1763     public
1764   {
1765     addRole(_operator, ROLE_WHITELISTED);
1766   }
1767 
1768   /**
1769    * @dev getter to determine if address is in whitelist
1770    */
1771   function whitelist(address _operator)
1772     public
1773     view
1774     returns (bool)
1775   {
1776     return hasRole(_operator, ROLE_WHITELISTED);
1777   }
1778 
1779   /**
1780    * @dev add addresses to the whitelist
1781    * @param _operators addresses
1782    * @return true if at least one address was added to the whitelist,
1783    * false if all addresses were already in the whitelist
1784    */
1785   function addAddressesToWhitelist(address[] _operators)
1786     onlyOwner
1787     public
1788   {
1789     for (uint256 i = 0; i < _operators.length; i++) {
1790       addAddressToWhitelist(_operators[i]);
1791     }
1792   }
1793 
1794   /**
1795    * @dev remove an address from the whitelist
1796    * @param _operator address
1797    * @return true if the address was removed from the whitelist,
1798    * false if the address wasn't in the whitelist in the first place
1799    */
1800   function removeAddressFromWhitelist(address _operator)
1801     onlyOwner
1802     public
1803   {
1804     removeRole(_operator, ROLE_WHITELISTED);
1805   }
1806 
1807   /**
1808    * @dev remove addresses from the whitelist
1809    * @param _operators addresses
1810    * @return true if at least one address was removed from the whitelist,
1811    * false if all addresses weren't in the whitelist in the first place
1812    */
1813   function removeAddressesFromWhitelist(address[] _operators)
1814     onlyOwner
1815     public
1816   {
1817     for (uint256 i = 0; i < _operators.length; i++) {
1818       removeAddressFromWhitelist(_operators[i]);
1819     }
1820   }
1821 
1822 }
1823 
1824 // File: contracts\ManagedWhitelist.sol
1825 
1826 /**
1827  * @title ManagedWhitelist
1828  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
1829  * This simplifies the implementation of "user permissions".
1830  */
1831 contract ManagedWhitelist is Managed, Whitelist {
1832   /**
1833   * @dev add an address to the whitelist
1834   * @param _operator address
1835   * @return true if the address was added to the whitelist, false if the address was already in the whitelist
1836   */
1837   function addAddressToWhitelist(address _operator) public onlyManager {
1838     addRole(_operator, ROLE_WHITELISTED);
1839   }
1840 
1841   /**
1842   * @dev add addresses to the whitelist
1843   * @param _operators addresses
1844   * @return true if at least one address was added to the whitelist,
1845   * false if all addresses were already in the whitelist
1846   */
1847   function addAddressesToWhitelist(address[] _operators) public onlyManager {
1848     for (uint256 i = 0; i < _operators.length; i++) {
1849       addAddressToWhitelist(_operators[i]);
1850     }
1851   }
1852 
1853   /**
1854   * @dev remove an address from the whitelist
1855   * @param _operator address
1856   * @return true if the address was removed from the whitelist,
1857   * false if the address wasn't in the whitelist in the first place
1858   */
1859   function removeAddressFromWhitelist(address _operator) public onlyManager {
1860     removeRole(_operator, ROLE_WHITELISTED);
1861   }
1862 
1863   /**
1864   * @dev remove addresses from the whitelist
1865   * @param _operators addresses
1866   * @return true if at least one address was removed from the whitelist,
1867   * false if all addresses weren't in the whitelist in the first place
1868   */
1869   function removeAddressesFromWhitelist(address[] _operators) public onlyManager {
1870     for (uint256 i = 0; i < _operators.length; i++) {
1871       removeAddressFromWhitelist(_operators[i]);
1872     }
1873   }
1874 }
1875 
1876 // File: contracts\ClinicAllCrowdsale.sol
1877 
1878 /// @title ClinicAll crowdsale contract
1879 /// @dev  ClinicAll crowdsale contract
1880 contract ClinicAllCrowdsale is Crowdsale, FinalizableCrowdsale, MintedCrowdsale, ManagedWhitelist, Limited {
1881   constructor
1882   (
1883     uint256 _tokenLimitSupply,
1884     uint256 _rate,
1885     address _wallet,
1886     address _privateSaleWallet,
1887     ERC20 _token,
1888     uint256 _openingTime,
1889     uint256 _closingTime,
1890     uint256 _discountTokenAmount,
1891     uint256 _discountTokenPercent,
1892     uint256 _preSaleClosingTime,
1893     uint256 _softCapLimit,
1894     ClinicAllRefundEscrow _vault,
1895     uint256 _buyLimitSupplyMin,
1896     uint256 _buyLimitSupplyMax,
1897     uint256 _kycLimitEliminator
1898   )
1899   Crowdsale(_rate, _wallet, _token)
1900   TimedCrowdsale(_openingTime, _closingTime)
1901   public
1902   {
1903     privateSaleWallet = _privateSaleWallet;
1904     tokenSupplyLimit = _tokenLimitSupply;
1905     discountTokenAmount = _discountTokenAmount;
1906     discountTokenPercent = _discountTokenPercent;
1907     preSaleClosingTime = _preSaleClosingTime;
1908     softCapLimit = _softCapLimit;
1909     vault = _vault;
1910     buyLimitSupplyMin = _buyLimitSupplyMin;
1911     buyLimitSupplyMax = _buyLimitSupplyMax;
1912     kycLimitEliminator = _kycLimitEliminator;
1913   }
1914 
1915   using SafeMath for uint256;
1916 
1917   // refund vault used to hold funds while crowdsale is running
1918   ClinicAllRefundEscrow public vault;
1919 
1920   /*/
1921   *  Properties, constants
1922   /*/
1923   //address public walletPrivateSaler;
1924   // Limit of tokens for supply during ICO public sale
1925   uint256 public tokenSupplyLimit;
1926   // Limit of tokens with discount on current contract
1927   uint256 public discountTokenAmount;
1928   // Percent value for discount tokens
1929   uint256 public discountTokenPercent;
1930   // Time when we finish pre sale
1931   uint256 public preSaleClosingTime;
1932   // Minimum amount of funds to be raised in weis
1933   uint256 public softCapLimit;
1934   // Min buy limit for each investor
1935   uint256 public buyLimitSupplyMin;
1936   // Max buy limit for each investor
1937   uint256 public buyLimitSupplyMax;
1938   // KYC Limit Eliminator for small and big investors
1939   uint256 public kycLimitEliminator;
1940   // Address where private sale funds are collected
1941   address public privateSaleWallet;
1942   // Private sale tokens supply limit
1943   uint256 public privateSaleSupplyLimit;
1944 
1945   // Public functions
1946 
1947   /*/
1948   *  @dev CrowdSale manager is able to change rate value during ICO
1949   *  @param _rate wei to CHT tokens exchange rate
1950   */
1951   function updateRate(uint256 _rate) public
1952   onlyManager
1953   {
1954     require(_rate != 0, "Exchange rate should not be 0.");
1955     rate = _rate;
1956   }
1957 
1958   /*/
1959   *  @dev CrowdSale manager is able to change min and max buy limit for investors during ICO
1960   *  @param _min Minimal amount of tokens that could be bought
1961   *  @param _max Maximum amount of tokens that could be bought
1962   */
1963   function updateBuyLimitRange(uint256 _min, uint256 _max) public
1964   onlyOwner
1965   {
1966     require(_min != 0, "Minimal buy limit should not be 0.");
1967     require(_max != 0, "Maximal buy limit should not be 0.");
1968     require(_max > _min, "Maximal buy limit should be greater than minimal buy limit.");
1969     buyLimitSupplyMin = _min;
1970     buyLimitSupplyMax = _max;
1971   }
1972 
1973   /*/
1974   *  @dev CrowdSale manager is able to change Kyc Limit Eliminator for investors during ICO
1975   *  @param _value amount of tokens that should be as eliminator
1976   */
1977   function updateKycLimitEliminator(uint256 _value) public
1978   onlyOwner
1979   {
1980     require(_value != 0, "Kyc Eliminator should not be 0.");
1981     kycLimitEliminator = _value;
1982   }
1983 
1984   /**
1985   * @dev Investors can claim refunds here if crowdsale is unsuccessful
1986   */
1987   function claimRefund() public {
1988     require(isFinalized, "Claim refunds is only possible if the ICO is finalized.");
1989     require(!goalReached(), "Claim refunds is only possible if the soft cap goal has not been reached.");
1990     uint256 deposit = vault.depositsOf(msg.sender);
1991     vault.withdraw(msg.sender);
1992     weiRaised = weiRaised.sub(deposit);
1993     ClinicAllToken(token).burnAfterRefund(msg.sender);
1994   }
1995 
1996   /**
1997   @dev Owner can claim full refund if a crowdsale is unsuccessful
1998   @param _txFee Transaction fee that will be deducted from an invested sum
1999   */
2000   function claimRefundChunk(uint256 _txFee, uint256 _chunkLength) public onlyOwner {
2001     require(isFinalized, "Claim refunds is only possible if the ICO is finalized.");
2002     require(!goalReached(), "Claim refunds is only possible if the soft cap goal has not been reached.");
2003     uint256 _weiRefunded;
2004     address[] memory _refundeesList;
2005     (_weiRefunded, _refundeesList) = vault.withdrawChunk(_txFee, _chunkLength);
2006     weiRaised = weiRaised.sub(_weiRefunded);
2007     for (uint256 i = 0; i < _refundeesList.length; i++) {
2008       ClinicAllToken(token).burnAfterRefund(_refundeesList[i]);
2009     }
2010   }
2011 
2012 
2013   /**
2014   * @dev Get refundee list length
2015   */
2016   function refundeesListLength() public onlyOwner view returns (uint256) {
2017     return vault.refundeesListLength();
2018   }
2019 
2020   /**
2021   * @dev Checks whether the period in which the crowdsale is open has already elapsed.
2022   * @return Whether crowdsale period has elapsed
2023   */
2024   function hasClosed() public view returns (bool) {
2025     return ((block.timestamp > closingTime) || tokenSupplyLimit <= token.totalSupply());
2026   }
2027 
2028   /**
2029   * @dev Checks whether funding goal was reached.
2030   * @return Whether funding goal was reached
2031   */
2032   function goalReached() public view returns (bool) {
2033     return token.totalSupply() >= softCapLimit;
2034   }
2035 
2036   /**
2037   * @dev Checks rest of tokens supply.
2038   */
2039   function supplyRest() public view returns (uint256) {
2040     return (tokenSupplyLimit.sub(token.totalSupply()));
2041   }
2042 
2043   //Private functions
2044 
2045   function _processPurchase(
2046     address _beneficiary,
2047     uint256 _tokenAmount
2048   )
2049   internal
2050   doesNotExceedLimit(_beneficiary, _tokenAmount, token.balanceOf(_beneficiary), kycLimitEliminator)
2051   {
2052     super._processPurchase(_beneficiary, _tokenAmount);
2053   }
2054 
2055   function _preValidatePurchase(
2056     address _beneficiary,
2057     uint256 _weiAmount
2058   )
2059   internal
2060   onlyIfWhitelisted(_beneficiary)
2061   isLimited(_beneficiary)
2062   {
2063     super._preValidatePurchase(_beneficiary, _weiAmount);
2064     uint256 tokens = _getTokenAmount(_weiAmount);
2065     require(tokens.add(token.totalSupply()) <= tokenSupplyLimit, "Total amount fo sold tokens should not exceed the total supply limit.");
2066     require(tokens >= buyLimitSupplyMin, "An investor can buy an amount of tokens only above the minimal limit.");
2067     require(tokens.add(token.balanceOf(_beneficiary)) <= buyLimitSupplyMax, "An investor cannot buy tokens above the maximal limit.");
2068   }
2069 
2070   /**
2071    * @dev Te way in which ether is converted to tokens.
2072    * @param _weiAmount Value in wei to be converted into tokens
2073    * @return Number of tokens that can be purchased with the specified _weiAmount with discount or not
2074    */
2075   function _getTokenAmount(uint256 _weiAmount)
2076   internal view returns (uint256)
2077   {
2078     if (isDiscount()) {
2079       return _getTokensWithDiscount(_weiAmount);
2080     }
2081     return _weiAmount.mul(rate);
2082   }
2083   /**
2084    * @dev Public method where ether is converted to tokens.
2085    * @param _weiAmount Value in wei to be converted into tokens
2086    */
2087   function getTokenAmount(uint256 _weiAmount)
2088   public view returns (uint256)
2089   {
2090     return _getTokenAmount(_weiAmount);
2091   }
2092 
2093   /**
2094    * @dev iternal method returns total tokens amount including discount
2095    */
2096   function _getTokensWithDiscount(uint256 _weiAmount)
2097   internal view returns (uint256)
2098   {
2099     uint256 tokens = 0;
2100     uint256 restOfDiscountTokens = discountTokenAmount.sub(token.totalSupply());
2101     uint256 discountTokensMax = _getDiscountTokenAmount(_weiAmount);
2102     if (restOfDiscountTokens < discountTokensMax) {
2103       uint256 discountTokens = restOfDiscountTokens;
2104       //get rest of WEI
2105       uint256 _rate = _getDiscountRate();
2106       uint256 _discointWeiAmount = discountTokens.div(_rate);
2107       uint256 _restOfWeiAmount = _weiAmount.sub(_discointWeiAmount);
2108       uint256 normalTokens = _restOfWeiAmount.mul(rate);
2109       tokens = discountTokens.add(normalTokens);
2110     } else {
2111       tokens = discountTokensMax;
2112     }
2113 
2114     return tokens;
2115   }
2116 
2117   /**
2118    * @dev iternal method returns discount tokens amount
2119    * @param _weiAmount An amount of ETH that should be converted to an amount of CHT tokens
2120    */
2121   function _getDiscountTokenAmount(uint256 _weiAmount)
2122   internal view returns (uint256)
2123   {
2124     require(_weiAmount != 0, "It should be possible to buy tokens only by providing non zero ETH.");
2125     uint256 _rate = _getDiscountRate();
2126     return _weiAmount.mul(_rate);
2127   }
2128 
2129   /**
2130    * @dev Returns the discount rate value
2131    */
2132   function _getDiscountRate()
2133   internal view returns (uint256)
2134   {
2135     require(isDiscount(), "Getting discount rate should be possible only below the discount tokens limit.");
2136     return rate.add(rate.mul(discountTokenPercent).div(100));
2137   }
2138 
2139   /**
2140    * @dev Returns the exchange rate value
2141    */
2142   function getRate()
2143   public view returns (uint256)
2144   {
2145     if (isDiscount()) {
2146       return _getDiscountRate();
2147     }
2148 
2149     return rate;
2150   }
2151 
2152   /**
2153    * @dev Returns the status if the ICO's private sale has closed or not
2154    */
2155   function isDiscount()
2156   public view returns (bool)
2157   {
2158     return (preSaleClosingTime >= block.timestamp);
2159   }
2160 
2161   /**
2162    * @dev Internal method where owner transfers part of tokens to reserve
2163    */
2164 
2165   function transferTokensToReserve(address _beneficiary) private
2166   {
2167     require(tokenSupplyLimit < CappedToken(token).cap(), "Token's supply limit should be less that token' cap limit.");
2168     // calculate token amount to be created
2169     uint256 _tokenCap = CappedToken(token).cap();
2170     uint256 tokens = _tokenCap.sub(tokenSupplyLimit);
2171 
2172     _deliverTokens(_beneficiary, tokens);
2173   }
2174 
2175   /**
2176   * @dev Enable transfers of tokens between wallets
2177   */
2178   function transferOn() public onlyOwner
2179   {
2180     ClinicAllToken(token).transferOn();
2181   }
2182 
2183   /**
2184   * @dev Disable transfers of tokens between wallets
2185   */
2186   function transferOff() public onlyOwner
2187   {
2188     ClinicAllToken(token).transferOff();
2189   }
2190 
2191   /**
2192    * @dev Internal method where owner transfers part of tokens to reserve and finish minting
2193    */
2194   function finalization() internal {
2195     if (goalReached()) {
2196       transferTokensToReserve(wallet);
2197       vault.close();
2198     } else {
2199       vault.enableRefunds();
2200     }
2201     MintableToken(token).finishMinting();
2202     super.finalization();
2203   }
2204 
2205   /**
2206   * @dev Overrides Crowdsale fund forwarding, sending funds to vault.
2207   */
2208   function _forwardFunds() internal {
2209     super._forwardFunds();
2210     vault.depositFunds(msg.sender, msg.value);
2211   }
2212 
2213   /**
2214   * @dev Throws if operator is not whitelisted.
2215   */
2216   modifier onlyPrivateSaleWallet() {
2217     require(privateSaleWallet == msg.sender, "Wallet should be the same as private sale wallet.");
2218     _;
2219   }
2220 
2221   /**
2222   * @dev Public method where private sale manager can transfer tokens to private investors
2223   */
2224   function transferToPrivateInvestor(
2225     address _beneficiary,
2226     uint256 _value
2227   )
2228   public
2229   onlyPrivateSaleWallet
2230   onlyIfWhitelisted(_beneficiary)
2231   returns (bool)
2232   {
2233     ClinicAllToken(token).transferToPrivateInvestor(msg.sender, _beneficiary, _value);
2234   }
2235 
2236   /**
2237   * @dev Public method where private sale manager can transfer the rest of tokens form private sale wallet available to crowdsale
2238   */
2239   function redeemPrivateSaleFunds()
2240   public
2241   onlyPrivateSaleWallet
2242   {
2243     uint256 _balance = ClinicAllToken(token).balanceOf(msg.sender);
2244     privateSaleSupplyLimit = privateSaleSupplyLimit.sub(_balance);
2245     ClinicAllToken(token).burnPrivateSale(msg.sender, _balance);
2246   }
2247 
2248   /**
2249   * @dev Internal method where private sale manager getting private sale limit amount of tokens
2250   * @param privateSaleSupplyAmount value of CHT tokens to add for private sale
2251   */
2252   function allocatePrivateSaleFunds(uint256 privateSaleSupplyAmount) public onlyOwner
2253   {
2254     require(privateSaleSupplyLimit.add(privateSaleSupplyAmount) < tokenSupplyLimit, "Token's private sale supply limit should be less that token supply limit.");
2255     privateSaleSupplyLimit = privateSaleSupplyLimit.add(privateSaleSupplyAmount);
2256     _deliverTokens(privateSaleWallet, privateSaleSupplyAmount);
2257   }
2258 
2259   /**
2260   @dev Owner can withdraw part of funds during of ICO
2261   @param _value Transaction amoun that will be deducted from an vault sum
2262   */
2263   function beneficiaryWithdrawChunk(uint256 _value) public onlyOwner {
2264     vault.beneficiaryWithdrawChunk(_value);
2265   }
2266 
2267   /**
2268   @dev Owner can withdraw all funds during or after of ICO
2269   */
2270   function beneficiaryWithdrawAll() public onlyOwner {
2271     vault.beneficiaryWithdrawAll();
2272   }
2273 
2274   /**
2275   @dev Owner can do manual refund here if investore has "BAD" money
2276   @param _payee address of investor that needs to refund with next manual ETH sending
2277   */
2278   function manualRefund(address _payee) public onlyOwner {
2279 
2280     uint256 deposit = vault.depositsOf(_payee);
2281     vault.manualRefund(_payee);
2282     weiRaised = weiRaised.sub(deposit);
2283     ClinicAllToken(token).burnAfterRefund(_payee);
2284   }
2285 
2286 }