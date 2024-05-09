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
941   address[] public refundeesList;
942 
943   event Deposited(address indexed payee, uint256 weiAmount);
944   event Withdrawn(address indexed payee, uint256 weiAmount);
945 
946   mapping(address => uint256) public deposits;
947   mapping(address => uint256) public beneficiaryDeposits;
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
972   /**
973    * Internal. Is being user by parent classes, just for keeping the interface.
974    * @dev Stores funds that may later be refunded.
975    * @param _refundee The address funds will be sent to if a refund occurs.
976    */
977   function deposit(address _refundee) public payable {
978     uint256 amount = msg.value;
979     beneficiaryDeposits[_refundee] = beneficiaryDeposits[_refundee].add(amount);
980     beneficiaryDepositedAmount = beneficiaryDepositedAmount.add(amount);
981   }
982 
983   /**
984  * @dev Stores funds that may later be refunded.
985  * @param _refundee The address funds will be sent to if a refund occurs.
986  * @param _value The amount of funds will be sent to if a refund occurs.
987  */
988   function depositFunds(address _refundee, uint256 _value) public onlyOwner {
989     require(state == State.Active, "Funds deposition is possible only in the Active state.");
990 
991     uint256 amount = _value;
992     deposits[_refundee] = deposits[_refundee].add(amount);
993     investorsDepositedToCrowdSaleAmount = investorsDepositedToCrowdSaleAmount.add(amount);
994 
995     emit Deposited(_refundee, amount);
996 
997     RefundeeRecord storage _data = refundees[_refundee];
998     _data.isRefunded = false;
999 
1000     if (_data.index == uint256(0)) {
1001       refundeesList.push(_refundee);
1002       _data.index = refundeesList.length.sub(1);
1003     }
1004   }
1005 
1006   /**
1007   * @dev Allows for the beneficiary to withdraw their funds, rejecting
1008   * further deposits.
1009   */
1010   function close() public onlyOwner {
1011     super.close();
1012   }
1013 
1014   function withdraw(address _payee) public onlyOwner {
1015     require(state == State.Refunding, "Funds withdrawal is possible only in the Refunding state.");
1016     require(depositsOf(_payee) > 0, "An investor should have non-negative deposit for withdrawal.");
1017 
1018     RefundeeRecord storage _data = refundees[_payee];
1019     require(_data.isRefunded == false, "An investor should not be refunded.");
1020 
1021     uint256 payment = deposits[_payee];
1022     assert(address(this).balance >= payment);
1023 
1024     deposits[_payee] = 0;
1025 
1026     investorsDepositedToCrowdSaleAmount = investorsDepositedToCrowdSaleAmount.sub(payment);
1027 
1028     _payee.transfer(payment);
1029 
1030     emit Withdrawn(_payee, payment);
1031 
1032     _data.isRefunded = true;
1033 
1034     removeRefundeeByIndex(_data.index);
1035   }
1036 
1037   /**
1038   @dev Owner can do manual refund here if investore has "BAD" money
1039   @param _payee address of investor that needs to refund with next manual ETH sending
1040   */
1041   function manualRefund(address _payee) public onlyOwner {
1042     uint256 payment = deposits[_payee];
1043     RefundeeRecord storage _data = refundees[_payee];
1044 
1045     investorsDepositedToCrowdSaleAmount = investorsDepositedToCrowdSaleAmount.sub(payment);
1046     deposits[_payee] = 0;
1047     _data.isRefunded = true;
1048 
1049     removeRefundeeByIndex(_data.index);
1050   }
1051 
1052   /**
1053   * @dev Remove refundee referenced index from the internal list
1054   * @param _indexToDelete An index in an array for deletion
1055   */
1056   function removeRefundeeByIndex(uint256 _indexToDelete) private {
1057     if ((refundeesList.length > 0) && (_indexToDelete < refundeesList.length)) {
1058       uint256 _lastIndex = refundeesList.length.sub(1);
1059       refundeesList[_indexToDelete] = refundeesList[_lastIndex];
1060       refundeesList.length--;
1061     }
1062   }
1063   /**
1064   * @dev Get refundee list length
1065   */
1066   function refundeesListLength() public onlyOwner view returns (uint256) {
1067     return refundeesList.length;
1068   }
1069 
1070   /**
1071   * @dev Auto refund
1072   * @param _txFee The cost of executing refund code
1073   */
1074   function withdrawChunk(uint256 _txFee, uint256 _chunkLength) public onlyOwner returns (uint256, address[]) {
1075     require(state == State.Refunding, "Funds withdrawal is possible only in the Refunding state.");
1076 
1077     uint256 _refundeesCount = refundeesList.length;
1078     require(_chunkLength >= _refundeesCount);
1079     require(_txFee > 0, "Transaction fee should be above zero.");
1080     require(_refundeesCount > 0, "List of investors should not be empty.");
1081     uint256 _weiRefunded = 0;
1082     require(address(this).balance > (_chunkLength.mul(_txFee)), "Account's ballance should allow to pay all tx fees.");
1083     address[] memory _refundeesListCopy = new address[](_chunkLength);
1084 
1085     uint256 i;
1086     for (i = 0; i < _chunkLength; i++) {
1087       address _refundee = refundeesList[i];
1088       RefundeeRecord storage _data = refundees[_refundee];
1089       if (_data.isRefunded == false) {
1090         if (depositsOf(_refundee) > _txFee) {
1091           uint256 _deposit = depositsOf(_refundee);
1092           if (_deposit > _txFee) {
1093             _weiRefunded = _weiRefunded.add(_deposit);
1094             uint256 _paymentWithoutTxFee = _deposit.sub(_txFee);
1095             _refundee.transfer(_paymentWithoutTxFee);
1096             emit Withdrawn(_refundee, _paymentWithoutTxFee);
1097             _data.isRefunded = true;
1098             _refundeesListCopy[i] = _refundee;
1099           }
1100         }
1101       }
1102     }
1103 
1104     for (i = 0; i < _chunkLength; i++) {
1105       if (address(0) != _refundeesListCopy[i]) {
1106         RefundeeRecord storage _dataCleanup = refundees[_refundeesListCopy[i]];
1107         require(_dataCleanup.isRefunded == true, "Investors in this list should be refunded.");
1108         removeRefundeeByIndex(_dataCleanup.index);
1109       }
1110     }
1111 
1112     return (_weiRefunded, _refundeesListCopy);
1113   }
1114 
1115   /**
1116   * @dev Auto refund
1117   * @param _txFee The cost of executing refund code
1118   */
1119   function withdrawEverything(uint256 _txFee) public onlyOwner returns (uint256, address[]) {
1120     require(state == State.Refunding, "Funds withdrawal is possible only in the Refunding state.");
1121     return withdrawChunk(_txFee, refundeesList.length);
1122   }
1123 
1124   /**
1125   * @dev Withdraws all beneficiary's funds.
1126   */
1127   function beneficiaryWithdraw() public {
1128     //This methods is intentionally is overriden here to prevent uncontrollable funds transferring to a beneficiary. Only owner should be able to do this
1129     //require(state == State.Closed);
1130     //beneficiary.transfer(address(this).balance);
1131   }
1132 
1133   /**
1134   * @dev Withdraws the part of beneficiary's funds.
1135   */
1136   function beneficiaryWithdrawChunk(uint256 _value) public onlyOwner {
1137     require(_value <= address(this).balance, "Withdraw part can not be more than current balance");
1138     beneficiaryDepositedAmount = beneficiaryDepositedAmount.sub(_value);
1139     beneficiary.transfer(_value);
1140   }
1141 
1142   /**
1143   * @dev Withdraws all beneficiary's funds.
1144   */
1145   function beneficiaryWithdrawAll() public onlyOwner {
1146     uint256 _value = address(this).balance;
1147     beneficiaryDepositedAmount = beneficiaryDepositedAmount.sub(_value);
1148     beneficiary.transfer(_value);
1149   }
1150 
1151 }
1152 
1153 // File: node_modules\zeppelin-solidity\contracts\lifecycle\TokenDestructible.sol
1154 
1155 /**
1156  * @title TokenDestructible:
1157  * @author Remco Bloemen <remco@2о─.com>
1158  * @dev Base contract that can be destroyed by owner. All funds in contract including
1159  * listed tokens will be sent to the owner.
1160  */
1161 contract TokenDestructible is Ownable {
1162 
1163   constructor() public payable { }
1164 
1165   /**
1166    * @notice Terminate contract and refund to owner
1167    * @param tokens List of addresses of ERC20 or ERC20Basic token contracts to
1168    refund.
1169    * @notice The called token contracts could try to re-enter this contract. Only
1170    supply token contracts you trust.
1171    */
1172   function destroy(address[] tokens) onlyOwner public {
1173 
1174     // Transfer tokens to owner
1175     for (uint256 i = 0; i < tokens.length; i++) {
1176       ERC20Basic token = ERC20Basic(tokens[i]);
1177       uint256 balance = token.balanceOf(this);
1178       token.transfer(owner, balance);
1179     }
1180 
1181     // Transfer Eth to owner and terminate contract
1182     selfdestruct(owner);
1183   }
1184 }
1185 
1186 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\BurnableToken.sol
1187 
1188 /**
1189  * @title Burnable Token
1190  * @dev Token that can be irreversibly burned (destroyed).
1191  */
1192 contract BurnableToken is BasicToken {
1193 
1194   event Burn(address indexed burner, uint256 value);
1195 
1196   /**
1197    * @dev Burns a specific amount of tokens.
1198    * @param _value The amount of token to be burned.
1199    */
1200   function burn(uint256 _value) public {
1201     _burn(msg.sender, _value);
1202   }
1203 
1204   function _burn(address _who, uint256 _value) internal {
1205     require(_value <= balances[_who]);
1206     // no need to require value <= totalSupply, since that would imply the
1207     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
1208 
1209     balances[_who] = balances[_who].sub(_value);
1210     totalSupply_ = totalSupply_.sub(_value);
1211     emit Burn(_who, _value);
1212     emit Transfer(_who, address(0), _value);
1213   }
1214 }
1215 
1216 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\DetailedERC20.sol
1217 
1218 /**
1219  * @title DetailedERC20 token
1220  * @dev The decimals are only for visualization purposes.
1221  * All the operations are done using the smallest and indivisible token unit,
1222  * just as on Ethereum all the operations are done in wei.
1223  */
1224 contract DetailedERC20 is ERC20 {
1225   string public name;
1226   string public symbol;
1227   uint8 public decimals;
1228 
1229   constructor(string _name, string _symbol, uint8 _decimals) public {
1230     name = _name;
1231     symbol = _symbol;
1232     decimals = _decimals;
1233   }
1234 }
1235 
1236 // File: node_modules\zeppelin-solidity\contracts\lifecycle\Pausable.sol
1237 
1238 /**
1239  * @title Pausable
1240  * @dev Base contract which allows children to implement an emergency stop mechanism.
1241  */
1242 contract Pausable is Ownable {
1243   event Pause();
1244   event Unpause();
1245 
1246   bool public paused = false;
1247 
1248 
1249   /**
1250    * @dev Modifier to make a function callable only when the contract is not paused.
1251    */
1252   modifier whenNotPaused() {
1253     require(!paused);
1254     _;
1255   }
1256 
1257   /**
1258    * @dev Modifier to make a function callable only when the contract is paused.
1259    */
1260   modifier whenPaused() {
1261     require(paused);
1262     _;
1263   }
1264 
1265   /**
1266    * @dev called by the owner to pause, triggers stopped state
1267    */
1268   function pause() onlyOwner whenNotPaused public {
1269     paused = true;
1270     emit Pause();
1271   }
1272 
1273   /**
1274    * @dev called by the owner to unpause, returns to normal state
1275    */
1276   function unpause() onlyOwner whenPaused public {
1277     paused = false;
1278     emit Unpause();
1279   }
1280 }
1281 
1282 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\PausableToken.sol
1283 
1284 /**
1285  * @title Pausable token
1286  * @dev StandardToken modified with pausable transfers.
1287  **/
1288 contract PausableToken is StandardToken, Pausable {
1289 
1290   function transfer(
1291     address _to,
1292     uint256 _value
1293   )
1294     public
1295     whenNotPaused
1296     returns (bool)
1297   {
1298     return super.transfer(_to, _value);
1299   }
1300 
1301   function transferFrom(
1302     address _from,
1303     address _to,
1304     uint256 _value
1305   )
1306     public
1307     whenNotPaused
1308     returns (bool)
1309   {
1310     return super.transferFrom(_from, _to, _value);
1311   }
1312 
1313   function approve(
1314     address _spender,
1315     uint256 _value
1316   )
1317     public
1318     whenNotPaused
1319     returns (bool)
1320   {
1321     return super.approve(_spender, _value);
1322   }
1323 
1324   function increaseApproval(
1325     address _spender,
1326     uint _addedValue
1327   )
1328     public
1329     whenNotPaused
1330     returns (bool success)
1331   {
1332     return super.increaseApproval(_spender, _addedValue);
1333   }
1334 
1335   function decreaseApproval(
1336     address _spender,
1337     uint _subtractedValue
1338   )
1339     public
1340     whenNotPaused
1341     returns (bool success)
1342   {
1343     return super.decreaseApproval(_spender, _subtractedValue);
1344   }
1345 }
1346 
1347 // File: contracts\TransferableToken.sol
1348 
1349 /**
1350  * @title TransferableToken
1351  * @dev Base contract which allows to implement transfer for token.
1352  */
1353 contract TransferableToken is Ownable {
1354   event TransferOn();
1355   event TransferOff();
1356 
1357   bool public transferable = false;
1358 
1359   /**
1360    * @dev Modifier to make a function callable only when the contract is not transferable.
1361    */
1362   modifier whenNotTransferable() {
1363     require(!transferable);
1364     _;
1365   }
1366 
1367   /**
1368    * @dev Modifier to make a function callable only when the contract is transferable.
1369    */
1370   modifier whenTransferable() {
1371     require(transferable);
1372     _;
1373   }
1374 
1375   /**
1376    * @dev called by the owner to enable transfers
1377    */
1378   function transferOn() onlyOwner whenNotTransferable public {
1379     transferable = true;
1380     emit TransferOn();
1381   }
1382 
1383   /**
1384    * @dev called by the owner to disable transfers
1385    */
1386   function transferOff() onlyOwner whenTransferable public {
1387     transferable = false;
1388     emit TransferOff();
1389   }
1390 
1391 }
1392 
1393 // File: contracts\ClinicAllToken.sol
1394 
1395 //PausableToken, TokenDestructible
1396 contract ClinicAllToken is MintableToken, DetailedERC20, CappedToken, BurnableToken, TransferableToken {
1397   constructor
1398   (
1399     string _name,
1400     string _symbol,
1401     uint8 _decimals,
1402     uint256 _cap
1403   )
1404   DetailedERC20(_name, _symbol, _decimals)
1405   CappedToken(_cap)
1406   public
1407   {
1408 
1409   }
1410 
1411   /*/
1412   *  Refund event when ICO didn't pass soft cap and we refund ETH to investors + burn ERC-20 tokens from investors balances
1413   /*/
1414   function burnAfterRefund(address _who) public onlyOwner {
1415     uint256 _value = balances[_who];
1416     _burn(_who, _value);
1417   }
1418 
1419   /*/
1420   *  Allow transfers only if token is transferable
1421   /*/
1422   function transfer(
1423     address _to,
1424     uint256 _value
1425   )
1426   public
1427   whenTransferable
1428   returns (bool)
1429   {
1430     return super.transfer(_to, _value);
1431   }
1432 
1433   /*/
1434   *  Allow transfers only if token is transferable
1435   /*/
1436   function transferFrom(
1437     address _from,
1438     address _to,
1439     uint256 _value
1440   )
1441   public
1442   whenTransferable
1443   returns (bool)
1444   {
1445     return super.transferFrom(_from, _to, _value);
1446   }
1447 
1448   function transferToPrivateInvestor(
1449     address _from,
1450     address _to,
1451     uint256 _value
1452   )
1453   public
1454   onlyOwner
1455   returns (bool)
1456   {
1457     require(_to != address(0));
1458     require(_value <= balances[_from]);
1459 
1460     balances[_from] = balances[_from].sub(_value);
1461     balances[_to] = balances[_to].add(_value);
1462     emit Transfer(_from, _to, _value);
1463     return true;
1464   }
1465 
1466   function burnPrivateSale(address privateSaleWallet, uint256 _value) public onlyOwner {
1467     _burn(privateSaleWallet, _value);
1468   }
1469 
1470 }
1471 
1472 // File: node_modules\zeppelin-solidity\contracts\ownership\rbac\Roles.sol
1473 
1474 /**
1475  * @title Roles
1476  * @author Francisco Giordano (@frangio)
1477  * @dev Library for managing addresses assigned to a Role.
1478  * See RBAC.sol for example usage.
1479  */
1480 library Roles {
1481   struct Role {
1482     mapping (address => bool) bearer;
1483   }
1484 
1485   /**
1486    * @dev give an address access to this role
1487    */
1488   function add(Role storage role, address addr)
1489     internal
1490   {
1491     role.bearer[addr] = true;
1492   }
1493 
1494   /**
1495    * @dev remove an address' access to this role
1496    */
1497   function remove(Role storage role, address addr)
1498     internal
1499   {
1500     role.bearer[addr] = false;
1501   }
1502 
1503   /**
1504    * @dev check if an address has this role
1505    * // reverts
1506    */
1507   function check(Role storage role, address addr)
1508     view
1509     internal
1510   {
1511     require(has(role, addr));
1512   }
1513 
1514   /**
1515    * @dev check if an address has this role
1516    * @return bool
1517    */
1518   function has(Role storage role, address addr)
1519     view
1520     internal
1521     returns (bool)
1522   {
1523     return role.bearer[addr];
1524   }
1525 }
1526 
1527 // File: node_modules\zeppelin-solidity\contracts\ownership\rbac\RBAC.sol
1528 
1529 /**
1530  * @title RBAC (Role-Based Access Control)
1531  * @author Matt Condon (@Shrugs)
1532  * @dev Stores and provides setters and getters for roles and addresses.
1533  * Supports unlimited numbers of roles and addresses.
1534  * See //contracts/mocks/RBACMock.sol for an example of usage.
1535  * This RBAC method uses strings to key roles. It may be beneficial
1536  * for you to write your own implementation of this interface using Enums or similar.
1537  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
1538  * to avoid typos.
1539  */
1540 contract RBAC {
1541   using Roles for Roles.Role;
1542 
1543   mapping (string => Roles.Role) private roles;
1544 
1545   event RoleAdded(address indexed operator, string role);
1546   event RoleRemoved(address indexed operator, string role);
1547 
1548   /**
1549    * @dev reverts if addr does not have role
1550    * @param _operator address
1551    * @param _role the name of the role
1552    * // reverts
1553    */
1554   function checkRole(address _operator, string _role)
1555     view
1556     public
1557   {
1558     roles[_role].check(_operator);
1559   }
1560 
1561   /**
1562    * @dev determine if addr has role
1563    * @param _operator address
1564    * @param _role the name of the role
1565    * @return bool
1566    */
1567   function hasRole(address _operator, string _role)
1568     view
1569     public
1570     returns (bool)
1571   {
1572     return roles[_role].has(_operator);
1573   }
1574 
1575   /**
1576    * @dev add a role to an address
1577    * @param _operator address
1578    * @param _role the name of the role
1579    */
1580   function addRole(address _operator, string _role)
1581     internal
1582   {
1583     roles[_role].add(_operator);
1584     emit RoleAdded(_operator, _role);
1585   }
1586 
1587   /**
1588    * @dev remove a role from an address
1589    * @param _operator address
1590    * @param _role the name of the role
1591    */
1592   function removeRole(address _operator, string _role)
1593     internal
1594   {
1595     roles[_role].remove(_operator);
1596     emit RoleRemoved(_operator, _role);
1597   }
1598 
1599   /**
1600    * @dev modifier to scope access to a single role (uses msg.sender as addr)
1601    * @param _role the name of the role
1602    * // reverts
1603    */
1604   modifier onlyRole(string _role)
1605   {
1606     checkRole(msg.sender, _role);
1607     _;
1608   }
1609 
1610   /**
1611    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
1612    * @param _roles the names of the roles to scope access to
1613    * // reverts
1614    *
1615    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
1616    *  see: https://github.com/ethereum/solidity/issues/2467
1617    */
1618   // modifier onlyRoles(string[] _roles) {
1619   //     bool hasAnyRole = false;
1620   //     for (uint8 i = 0; i < _roles.length; i++) {
1621   //         if (hasRole(msg.sender, _roles[i])) {
1622   //             hasAnyRole = true;
1623   //             break;
1624   //         }
1625   //     }
1626 
1627   //     require(hasAnyRole);
1628 
1629   //     _;
1630   // }
1631 }
1632 
1633 // File: contracts\Managed.sol
1634 
1635 /**
1636  * @title Managed
1637  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
1638  * This simplifies the implementation of "user permissions".
1639  */
1640 contract Managed is Ownable, RBAC {
1641   string public constant ROLE_MANAGER = "manager";
1642 
1643   /**
1644   * @dev Throws if operator is not whitelisted.
1645   */
1646   modifier onlyManager() {
1647     checkRole(msg.sender, ROLE_MANAGER);
1648     _;
1649   }
1650 
1651   /**
1652   * @dev set an address as a manager
1653   * @param _operator address
1654   * @return true if the address was added to the whitelist, false if the address was already in the whitelist
1655   */
1656   function setManager(address _operator) public onlyOwner {
1657     addRole(_operator, ROLE_MANAGER);
1658   }
1659 
1660   /**
1661   * @dev delete an address as a manager
1662   * @param _operator address
1663   * @return true if the address was deleted from the whitelist, false if the address wasn't already in the whitelist
1664   */
1665   function removeManager(address _operator) public onlyOwner {
1666     removeRole(_operator, ROLE_MANAGER);
1667   }
1668 }
1669 
1670 // File: contracts\Limited.sol
1671 
1672 /**
1673  * @title LimitedCrowdsale
1674  * @dev Crowdsale in which only limited number of tokens can be bought.
1675  */
1676 contract Limited is Managed {
1677   using SafeMath for uint256;
1678   mapping(address => uint256) public limitsList;
1679 
1680   /**
1681   * @dev Reverts if beneficiary has no limit. Can be used when extending this contract.
1682   */
1683   modifier isLimited(address _payee) {
1684     require(limitsList[_payee] > 0, "An investor is limited if it has a limit.");
1685     _;
1686   }
1687 
1688 
1689   /**
1690   * @dev Reverts if beneficiary want to buy more tokens than limit allows. Can be used when extending this contract.
1691   */
1692   modifier doesNotExceedLimit(address _payee, uint256 _tokenAmount, uint256 _tokenBalance, uint256 kycLimitThreshold) {
1693     uint256 _newBalance = _tokenBalance.add(_tokenAmount);
1694     uint256 _payeeLimit = getLimit(_payee);
1695     if (_newBalance >= kycLimitThreshold/* && _payeeLimit >= kycLimitThreshold*/) {
1696         //It does not make sense to validate limit if its lower than the threshold; otherwhise, a payee will hit the lower limit in attempt of buying more than kycThreshold
1697         require(_newBalance <= _payeeLimit, "An investor should not exceed its limit on buying.");
1698     }
1699     _;
1700   }
1701 
1702   /**
1703   * @dev Returns limits for _payee.
1704   * @param _payee Address to get token limits
1705   */
1706   function getLimit(address _payee)
1707   public view returns (uint256)
1708   {
1709     return limitsList[_payee];
1710   }
1711 
1712   /**
1713   * @dev Adds limits to addresses.
1714   * @param _payees Addresses to set limit
1715   * @param _limits Limit values to set to addresses
1716   */
1717   function addAddressesLimits(address[] _payees, uint256[] _limits) public
1718   onlyManager
1719   {
1720     require(_payees.length == _limits.length, "Array sizes should be equal.");
1721     for (uint256 i = 0; i < _payees.length; i++) {
1722       addLimit(_payees[i], _limits[i]);
1723     }
1724   }
1725 
1726 
1727   /**
1728   * @dev Adds limit to address.
1729   * @param _payee Address to set limit
1730   * @param _limit Limit value to set to address
1731   */
1732   function addLimit(address _payee, uint256 _limit) public
1733   onlyManager
1734   {
1735     limitsList[_payee] = _limit;
1736   }
1737 
1738 
1739   /**
1740   * @dev Removes single address-limit record.
1741   * @param _payee Address to be removed
1742   */
1743   function removeLimit(address _payee) external
1744   onlyManager
1745   {
1746     limitsList[_payee] = 0;
1747   }
1748 
1749 }
1750 
1751 // File: node_modules\zeppelin-solidity\contracts\access\Whitelist.sol
1752 
1753 /**
1754  * @title Whitelist
1755  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
1756  * This simplifies the implementation of "user permissions".
1757  */
1758 contract Whitelist is Ownable, RBAC {
1759   string public constant ROLE_WHITELISTED = "whitelist";
1760 
1761   /**
1762    * @dev Throws if operator is not whitelisted.
1763    * @param _operator address
1764    */
1765   modifier onlyIfWhitelisted(address _operator) {
1766     checkRole(_operator, ROLE_WHITELISTED);
1767     _;
1768   }
1769 
1770   /**
1771    * @dev add an address to the whitelist
1772    * @param _operator address
1773    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
1774    */
1775   function addAddressToWhitelist(address _operator)
1776     onlyOwner
1777     public
1778   {
1779     addRole(_operator, ROLE_WHITELISTED);
1780   }
1781 
1782   /**
1783    * @dev getter to determine if address is in whitelist
1784    */
1785   function whitelist(address _operator)
1786     public
1787     view
1788     returns (bool)
1789   {
1790     return hasRole(_operator, ROLE_WHITELISTED);
1791   }
1792 
1793   /**
1794    * @dev add addresses to the whitelist
1795    * @param _operators addresses
1796    * @return true if at least one address was added to the whitelist,
1797    * false if all addresses were already in the whitelist
1798    */
1799   function addAddressesToWhitelist(address[] _operators)
1800     onlyOwner
1801     public
1802   {
1803     for (uint256 i = 0; i < _operators.length; i++) {
1804       addAddressToWhitelist(_operators[i]);
1805     }
1806   }
1807 
1808   /**
1809    * @dev remove an address from the whitelist
1810    * @param _operator address
1811    * @return true if the address was removed from the whitelist,
1812    * false if the address wasn't in the whitelist in the first place
1813    */
1814   function removeAddressFromWhitelist(address _operator)
1815     onlyOwner
1816     public
1817   {
1818     removeRole(_operator, ROLE_WHITELISTED);
1819   }
1820 
1821   /**
1822    * @dev remove addresses from the whitelist
1823    * @param _operators addresses
1824    * @return true if at least one address was removed from the whitelist,
1825    * false if all addresses weren't in the whitelist in the first place
1826    */
1827   function removeAddressesFromWhitelist(address[] _operators)
1828     onlyOwner
1829     public
1830   {
1831     for (uint256 i = 0; i < _operators.length; i++) {
1832       removeAddressFromWhitelist(_operators[i]);
1833     }
1834   }
1835 
1836 }
1837 
1838 // File: contracts\ManagedWhitelist.sol
1839 
1840 /**
1841  * @title ManagedWhitelist
1842  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
1843  * This simplifies the implementation of "user permissions".
1844  */
1845 contract ManagedWhitelist is Managed, Whitelist {
1846   /**
1847   * @dev add an address to the whitelist
1848   * @param _operator address
1849   * @return true if the address was added to the whitelist, false if the address was already in the whitelist
1850   */
1851   function addAddressToWhitelist(address _operator) public onlyManager {
1852     addRole(_operator, ROLE_WHITELISTED);
1853   }
1854 
1855   /**
1856   * @dev add addresses to the whitelist
1857   * @param _operators addresses
1858   * @return true if at least one address was added to the whitelist,
1859   * false if all addresses were already in the whitelist
1860   */
1861   function addAddressesToWhitelist(address[] _operators) public onlyManager {
1862     for (uint256 i = 0; i < _operators.length; i++) {
1863       addAddressToWhitelist(_operators[i]);
1864     }
1865   }
1866 
1867   /**
1868   * @dev remove an address from the whitelist
1869   * @param _operator address
1870   * @return true if the address was removed from the whitelist,
1871   * false if the address wasn't in the whitelist in the first place
1872   */
1873   function removeAddressFromWhitelist(address _operator) public onlyManager {
1874     removeRole(_operator, ROLE_WHITELISTED);
1875   }
1876 
1877   /**
1878   * @dev remove addresses from the whitelist
1879   * @param _operators addresses
1880   * @return true if at least one address was removed from the whitelist,
1881   * false if all addresses weren't in the whitelist in the first place
1882   */
1883   function removeAddressesFromWhitelist(address[] _operators) public onlyManager {
1884     for (uint256 i = 0; i < _operators.length; i++) {
1885       removeAddressFromWhitelist(_operators[i]);
1886     }
1887   }
1888 }
1889 
1890 // File: contracts\MigratedTimedFinalizableCrowdsale.sol
1891 
1892 /**
1893  * @title MigratedTimedCrowdsale
1894  * @dev Crowdsale accepting contributions only within a time frame.
1895  */
1896 contract MigratedTimedFinalizableCrowdsale is Crowdsale, Ownable {
1897   using SafeMath for uint256;
1898   bool public isFinalized = false;
1899 
1900   event Finalized();
1901 
1902   /**
1903    * @dev Must be called after crowdsale ends, to do some extra finalization
1904    * work. Calls the contract's finalization function.
1905    */
1906   function finalize() onlyOwner public {
1907     require(!isFinalized);
1908     require(hasClosed());
1909 
1910     finalization();
1911     emit Finalized();
1912 
1913     isFinalized = true;
1914   }
1915 
1916   /**
1917    * @dev Can be overridden to add finalization logic. The overriding function
1918    * should call super.finalization() to ensure the chain of finalization is
1919    * executed entirely.
1920    */
1921   function finalization() internal {
1922   } 
1923   
1924   uint256 public openingTime;
1925   uint256 public closingTime;
1926 
1927   /**
1928    * @dev Reverts if not in crowdsale time range.
1929    */
1930   modifier onlyWhileOpen {
1931     // solium-disable-next-line security/no-block-members
1932     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
1933     _;
1934   }
1935 
1936   /**
1937    * @dev Constructor, takes crowdsale opening and closing times.
1938    * @param _openingTime Crowdsale opening time
1939    * @param _closingTime Crowdsale closing time
1940    */
1941   constructor(uint256 _openingTime, uint256 _closingTime) public {
1942     // solium-disable-next-line security/no-block-members
1943     //require(_closingTime >= block.timestamp);
1944     //require(_closingTime >= _openingTime);
1945 
1946     openingTime = _openingTime;
1947     closingTime = _closingTime;
1948   }
1949 
1950   /**
1951    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
1952    * @return Whether crowdsale period has elapsed
1953    */
1954   function hasClosed() public view returns (bool) {
1955     // solium-disable-next-line security/no-block-members
1956     return block.timestamp > closingTime;
1957   }
1958 
1959   /**
1960    * @dev Extend parent behavior requiring to be within contributing period
1961    * @param _beneficiary Token purchaser
1962    * @param _weiAmount Amount of wei contributed
1963    */
1964   function _preValidatePurchase(
1965     address _beneficiary,
1966     uint256 _weiAmount
1967   )
1968     internal
1969     onlyWhileOpen
1970   {
1971     super._preValidatePurchase(_beneficiary, _weiAmount);
1972   }
1973 }
1974 
1975 // File: contracts\PrivatelyManaged.sol
1976 
1977 /**
1978  * @title Managed
1979  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
1980  * This simplifies the implementation of "user permissions".
1981  */
1982 contract PrivatelyManaged is Ownable, RBAC {
1983   string public constant ROLE_PRIVATEMANAGER = "private_manager";
1984 
1985   /**
1986   * @dev Throws if operator is not whitelisted.
1987   */
1988   modifier onlyPrivateManager() {
1989     checkRole(msg.sender, ROLE_PRIVATEMANAGER);
1990     _;
1991   }
1992 
1993   /**
1994   * @dev set an address as a private sale manager
1995   * @param _operator address
1996   * @return true if the address was added to the whitelist, false if the address was already in the whitelist
1997   */
1998   function setPrivateManager(address _operator) public onlyOwner {
1999     addRole(_operator, ROLE_PRIVATEMANAGER);
2000   }
2001 
2002   /**
2003   * @dev delete an address as a private sale manager
2004   * @param _operator address
2005   * @return true if the address was deleted from the whitelist, false if the address wasn't already in the whitelist
2006   */
2007   function removePrivateManager(address _operator) public onlyOwner {
2008     removeRole(_operator, ROLE_PRIVATEMANAGER);
2009   }
2010 }
2011 
2012 // File: contracts\ClinicAllCrowdsale.sol
2013 
2014 //import "./../node_modules/zeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol";
2015 
2016 
2017 
2018 
2019 
2020 
2021 
2022 
2023 
2024 
2025 
2026 
2027 
2028 
2029 /// @title ClinicAll crowdsale contract
2030 /// @dev  ClinicAll crowdsale contract
2031 //contract ClinicAllCrowdsale is Crowdsale, TimedCrowdsale, FinalizableCrowdsale, MintedCrowdsale, ManagedWhitelist, Limited {
2032 contract ClinicAllCrowdsale is Crowdsale, MigratedTimedFinalizableCrowdsale, MintedCrowdsale, ManagedWhitelist, Limited {
2033   constructor
2034   (
2035     uint256 _tokenLimitSupply,
2036     uint256 _rate,
2037     address _wallet,
2038     address _privateSaleManagerWallet,
2039     ERC20 _token,
2040     uint256 _openingTime,
2041     uint256 _closingTime,
2042     uint256 _discountTokenAmount,
2043     uint256 _discountTokenPercent,
2044     uint256 _preSaleClosingTime,
2045     uint256 _softCapLimit,
2046     ClinicAllRefundEscrow _vault,
2047     uint256 _buyLimitSupplyMin,
2048     uint256 _buyLimitSupplyMax,
2049     uint256 _kycLimitThreshold
2050   )
2051   Crowdsale(_rate, _wallet, _token)
2052   //TimedCrowdsale(_openingTime, _closingTime)
2053   MigratedTimedFinalizableCrowdsale(_openingTime, _closingTime)
2054   public
2055   {
2056     privateSaleManagerWallet = _privateSaleManagerWallet;
2057     tokenSupplyLimit = _tokenLimitSupply;
2058     discountTokenAmount = _discountTokenAmount;
2059     discountTokenPercent = _discountTokenPercent;
2060     preSaleClosingTime = _preSaleClosingTime;
2061     softCapLimit = _softCapLimit;
2062     vault = _vault;
2063     buyLimitSupplyMin = _buyLimitSupplyMin;
2064     buyLimitSupplyMax = _buyLimitSupplyMax;
2065     kycLimitThreshold = _kycLimitThreshold;
2066   }
2067 
2068   using SafeMath for uint256;
2069 
2070   // refund vault used to hold funds while crowdsale is running
2071   ClinicAllRefundEscrow public vault;
2072 
2073   /*/
2074   *  Properties, constants
2075   /*/
2076   //address public walletPrivateSaler;
2077   // Limit of tokens for supply during ICO public sale
2078   uint256 public tokenSupplyLimit;
2079   // Limit of tokens with discount on current contract
2080   uint256 public discountTokenAmount;
2081   // Percent value for discount tokens
2082   uint256 public discountTokenPercent;
2083   // Time when we finish pre sale
2084   uint256 public preSaleClosingTime;
2085   // Minimum amount of funds to be raised in weis
2086   uint256 public softCapLimit;
2087   // Min buy limit for each investor
2088   uint256 public buyLimitSupplyMin;
2089   // Max buy limit for each investor
2090   uint256 public buyLimitSupplyMax;
2091   // KYC Limit threshold for small and big investors
2092   uint256 public kycLimitThreshold;
2093   // Address where private sale funds are collected
2094   address public privateSaleManagerWallet;
2095   // Private sale tokens supply limit
2096   uint256 public privateSaleSupplyLimit;
2097 
2098   // Modifiers
2099   /**
2100   * @dev Throws if operator is not whitelisted.
2101   */
2102   modifier onlyPrivateSaleManager() {
2103     require(privateSaleManagerWallet == msg.sender, "Operation is allowed only for the private sale manager.");
2104     _;
2105   }
2106 
2107 
2108   // Public functions
2109 
2110   /*/
2111   *  @dev Owner can transfer ownership of the token to a new owner
2112   *  @param _newTokenOwner  New token owner address
2113   */
2114   function transferTokenOwnership(address _newTokenOwner) public
2115   onlyOwner
2116   {
2117       MintableToken(token).transferOwnership(_newTokenOwner);
2118   }
2119 
2120   /*/
2121   *  @dev Owner can transfer ownership of the vault to a new owner
2122   *  @param _newTokenOwner  New token owner address
2123   */
2124   function transferVaultOwnership(address _newVaultOwner) public
2125   onlyOwner
2126   {
2127       ClinicAllRefundEscrow(vault).transferOwnership(_newVaultOwner);
2128   }
2129 
2130   /*/
2131   *  @dev Owner can extend ICO closing time
2132   *  @param _closingTime New ICO closing time
2133   */
2134   function extendICO(uint256 _closingTime) public
2135   onlyOwner
2136   {
2137       closingTime = _closingTime;
2138   }
2139 
2140   /*/
2141   *  @dev Owner can extend ICO closing time
2142   *  @param _closingTime New ICO closing time
2143   */
2144   function extendPreSale(uint256 _preSaleClosingTime) public
2145   onlyOwner
2146   {
2147       preSaleClosingTime = _preSaleClosingTime;
2148   }
2149 
2150   /*/
2151   *  @dev Should be used only once during the migration of ICO contracts
2152   *  @param _beneficiary Wallet address of migrated beneficiary
2153   *  @param _weiAmount Sum of invested ETH funds in wei
2154   *  @param _tokenAmount Sum of bought tokens for this ETH funds
2155   */
2156   function migrateBeneficiary(address _beneficiary, uint256 _weiAmount, uint256 _tokenAmount) public
2157   onlyOwner
2158   {
2159     weiRaised = weiRaised.add(_weiAmount);
2160     //That is crucial that _forwardFunds() will not be called here
2161     _processPurchase(_beneficiary, _tokenAmount);
2162     emit TokenPurchase(
2163       msg.sender,
2164       _beneficiary,
2165       _weiAmount,
2166       _tokenAmount
2167     );
2168   }
2169 
2170   /*/
2171   *  @dev CrowdSale manager is able to change rate value during ICO
2172   *  @param _rate wei to CHT tokens exchange rate
2173   */
2174   function updateRate(uint256 _rate) public
2175   onlyManager
2176   {
2177     require(_rate != 0, "Exchange rate should not be 0.");
2178     rate = _rate;
2179   }
2180 
2181   /*/
2182   *  @dev CrowdSale manager is able to change min and max buy limit for investors during ICO
2183   *  @param _min Minimal amount of tokens that could be bought
2184   *  @param _max Maximum amount of tokens that could be bought
2185   */
2186   function updateBuyLimitRange(uint256 _min, uint256 _max) public
2187   onlyOwner
2188   {
2189     require(_min != 0, "Minimal buy limit should not be 0.");
2190     require(_max != 0, "Maximal buy limit should not be 0.");
2191     require(_max > _min, "Maximal buy limit should be greater than minimal buy limit.");
2192     buyLimitSupplyMin = _min;
2193     buyLimitSupplyMax = _max;
2194   }
2195 
2196   /*/
2197   *  @dev CrowdSale manager is able to change Kyc Limit Eliminator for investors during ICO
2198   *  @param _value amount of tokens that should be as eliminator
2199   */
2200   function updateKycLimitThreshold(uint256 _value) public
2201   onlyOwner
2202   {
2203     require(_value != 0, "Kyc threshold should not be 0.");
2204     kycLimitThreshold = _value;
2205   }
2206 
2207   /**
2208   * @dev Investors can claim refunds here if crowdsale is unsuccessful
2209   */
2210   function claimRefund() public {
2211     require(isFinalized, "Claim refunds is only possible if the ICO is finalized.");
2212     require(!goalReached(), "Claim refunds is only possible if the soft cap goal has not been reached.");
2213     uint256 deposit = vault.depositsOf(msg.sender);
2214     vault.withdraw(msg.sender);
2215     weiRaised = weiRaised.sub(deposit);
2216     ClinicAllToken(token).burnAfterRefund(msg.sender);
2217   }
2218 
2219   /**
2220   @dev Owner can claim full refund if a crowdsale is unsuccessful
2221   @param _txFee Transaction fee that will be deducted from an invested sum
2222   */
2223   function claimRefundChunk(uint256 _txFee, uint256 _chunkLength) public onlyOwner {
2224     require(isFinalized, "Claim refunds is only possible if the ICO is finalized.");
2225     require(!goalReached(), "Claim refunds is only possible if the soft cap goal has not been reached.");
2226     uint256 _weiRefunded;
2227     address[] memory _refundeesList;
2228     (_weiRefunded, _refundeesList) = vault.withdrawChunk(_txFee, _chunkLength);
2229     weiRaised = weiRaised.sub(_weiRefunded);
2230     for (uint256 i = 0; i < _refundeesList.length; i++) {
2231       ClinicAllToken(token).burnAfterRefund(_refundeesList[i]);
2232     }
2233   }
2234 
2235   /**
2236   * @dev Get refundee list length
2237   */
2238   function refundeesListLength() public onlyOwner view returns (uint256) {
2239     return vault.refundeesListLength();
2240   }
2241 
2242   /**
2243   * @dev Checks whether the period in which the crowdsale is open has already elapsed.
2244   * @return Whether crowdsale period has elapsed
2245   */
2246   function hasClosed() public view returns (bool) {
2247     return ((block.timestamp > closingTime) || tokenSupplyLimit <= token.totalSupply());
2248   }
2249 
2250   /**
2251   * @dev Checks whether funding goal was reached.
2252   * @return Whether funding goal was reached
2253   */
2254   function goalReached() public view returns (bool) {
2255     return token.totalSupply() >= softCapLimit;
2256   }
2257 
2258   /**
2259   * @dev Checks rest of tokens supply.
2260   */
2261   function supplyRest() public view returns (uint256) {
2262     return (tokenSupplyLimit.sub(token.totalSupply()));
2263   }
2264 
2265   //Private functions
2266 
2267   function _processPurchase(
2268     address _beneficiary,
2269     uint256 _tokenAmount
2270   )
2271   internal
2272   doesNotExceedLimit(_beneficiary, _tokenAmount, token.balanceOf(_beneficiary), kycLimitThreshold)
2273   {
2274     super._processPurchase(_beneficiary, _tokenAmount);
2275   }
2276 
2277   function _preValidatePurchase(
2278     address _beneficiary,
2279     uint256 _weiAmount
2280   )
2281   internal
2282   onlyIfWhitelisted(_beneficiary)
2283   isLimited(_beneficiary)
2284   {
2285     super._preValidatePurchase(_beneficiary, _weiAmount);
2286     uint256 tokens = _getTokenAmount(_weiAmount);
2287     require(tokens.add(token.totalSupply()) <= tokenSupplyLimit, "Total amount fo sold tokens should not exceed the total supply limit.");
2288     require(tokens >= buyLimitSupplyMin, "An investor can buy an amount of tokens only above the minimal limit.");
2289     require(tokens.add(token.balanceOf(_beneficiary)) <= buyLimitSupplyMax, "An investor cannot buy tokens above the maximal limit.");
2290   }
2291 
2292   /**
2293    * @dev Te way in which ether is converted to tokens.
2294    * @param _weiAmount Value in wei to be converted into tokens
2295    * @return Number of tokens that can be purchased with the specified _weiAmount with discount or not
2296    */
2297   function _getTokenAmount(uint256 _weiAmount)
2298   internal view returns (uint256)
2299   {
2300     if (isDiscount()) {
2301       return _getTokensWithDiscount(_weiAmount);
2302     }
2303     return _weiAmount.mul(rate);
2304   }
2305 
2306   /**
2307    * @dev Public method where ether is converted to tokens.
2308    * @param _weiAmount Value in wei to be converted into tokens
2309    */
2310   function getTokenAmount(uint256 _weiAmount)
2311   public view returns (uint256)
2312   {
2313     return _getTokenAmount(_weiAmount);
2314   }
2315 
2316   /**
2317    * @dev iternal method returns total tokens amount including discount
2318    */
2319   function _getTokensWithDiscount(uint256 _weiAmount)
2320   internal view returns (uint256)
2321   {
2322     uint256 tokens = 0;
2323     uint256 restOfDiscountTokens = discountTokenAmount.sub(token.totalSupply());
2324     uint256 discountTokensMax = _getDiscountTokenAmount(_weiAmount);
2325     if (restOfDiscountTokens < discountTokensMax) {
2326       uint256 discountTokens = restOfDiscountTokens;
2327       //get rest of WEI
2328       uint256 _rate = _getDiscountRate();
2329       uint256 _discointWeiAmount = discountTokens.div(_rate);
2330       uint256 _restOfWeiAmount = _weiAmount.sub(_discointWeiAmount);
2331       uint256 normalTokens = _restOfWeiAmount.mul(rate);
2332       tokens = discountTokens.add(normalTokens);
2333     } else {
2334       tokens = discountTokensMax;
2335     }
2336 
2337     return tokens;
2338   }
2339 
2340   /**
2341    * @dev iternal method returns discount tokens amount
2342    * @param _weiAmount An amount of ETH that should be converted to an amount of CHT tokens
2343    */
2344   function _getDiscountTokenAmount(uint256 _weiAmount)
2345   internal view returns (uint256)
2346   {
2347     require(_weiAmount != 0, "It should be possible to buy tokens only by providing non zero ETH.");
2348     uint256 _rate = _getDiscountRate();
2349     return _weiAmount.mul(_rate);
2350   }
2351 
2352   /**
2353    * @dev Returns the discount rate value
2354    */
2355   function _getDiscountRate()
2356   internal view returns (uint256)
2357   {
2358     require(isDiscount(), "Getting discount rate should be possible only below the discount tokens limit.");
2359     return rate.add(rate.mul(discountTokenPercent).div(100));
2360   }
2361 
2362   /**
2363    * @dev Returns the exchange rate value
2364    */
2365   function getRate()
2366   public view returns (uint256)
2367   {
2368     if (isDiscount()) {
2369       return _getDiscountRate();
2370     }
2371 
2372     return rate;
2373   }
2374 
2375   /**
2376    * @dev Returns the status if the ICO's private sale has closed or not
2377    */
2378   function isDiscount()
2379   public view returns (bool)
2380   {
2381     return (preSaleClosingTime >= block.timestamp);
2382   }
2383 
2384   /**
2385    * @dev Internal method where owner transfers part of tokens to reserve
2386    */
2387   function transferTokensToReserve(address _beneficiary) private
2388   {
2389     require(tokenSupplyLimit < CappedToken(token).cap(), "Token's supply limit should be less that token' cap limit.");
2390     // calculate token amount to be created
2391     uint256 _tokenCap = CappedToken(token).cap();
2392     uint256 tokens = _tokenCap.sub(tokenSupplyLimit);
2393 
2394     _deliverTokens(_beneficiary, tokens);
2395   }
2396 
2397   /**
2398   * @dev Enable transfers of tokens between wallets
2399   */
2400   function transferOn() public onlyOwner
2401   {
2402     ClinicAllToken(token).transferOn();
2403   }
2404 
2405   /**
2406   * @dev Disable transfers of tokens between wallets
2407   */
2408   function transferOff() public onlyOwner
2409   {
2410     ClinicAllToken(token).transferOff();
2411   }
2412 
2413   /**
2414    * @dev Internal method where owner transfers part of tokens to reserve and finish minting
2415    */
2416   function finalization() internal {
2417     if (goalReached()) {
2418       transferTokensToReserve(wallet);
2419       vault.close();
2420     } else {
2421       vault.enableRefunds();
2422     }
2423     MintableToken(token).finishMinting();
2424     super.finalization();
2425   }
2426 
2427   /**
2428   * @dev Overrides Crowdsale fund forwarding, sending funds to vault.
2429   */
2430   function _forwardFunds() internal {
2431     super._forwardFunds();
2432     vault.depositFunds(msg.sender, msg.value);
2433   }
2434 
2435   /**
2436   * @dev Public method where private sale manager can transfer tokens to private investors
2437   */
2438   function transferToPrivateInvestor(
2439     address _beneficiary,
2440     uint256 _value
2441   )
2442   public
2443   onlyPrivateSaleManager
2444   onlyIfWhitelisted(_beneficiary)
2445   returns (bool)
2446   {
2447     ClinicAllToken(token).transferToPrivateInvestor(msg.sender, _beneficiary, _value);
2448   }
2449 
2450   /**
2451   * @dev Allocates funds for the private sale manager, but not beyound the tokenSupplyLimit
2452   * @param privateSaleSupplyAmount value of CHT tokens to add for private sale
2453   */
2454   function allocatePrivateSaleFunds(uint256 privateSaleSupplyAmount) public onlyOwner
2455   {
2456     require(privateSaleSupplyLimit.add(privateSaleSupplyAmount) < tokenSupplyLimit, "Token's private sale supply limit should be less that token supply limit.");
2457     privateSaleSupplyLimit = privateSaleSupplyLimit.add(privateSaleSupplyAmount);
2458     _deliverTokens(privateSaleManagerWallet, privateSaleSupplyAmount);
2459   }
2460 
2461   /**
2462   * @dev Public method where private sale manager can transfer the rest of tokens form private sale wallet available to crowdsale
2463   */
2464   function redeemPrivateSaleFunds()
2465   public
2466   onlyPrivateSaleManager
2467   {
2468     uint256 _balance = ClinicAllToken(token).balanceOf(msg.sender);
2469     privateSaleSupplyLimit = privateSaleSupplyLimit.sub(_balance);
2470     ClinicAllToken(token).burnPrivateSale(msg.sender, _balance);
2471   }
2472 
2473   /**
2474   @dev Owner can withdraw part of funds during of ICO
2475   @param _value Transaction amoun that will be deducted from an vault sum
2476   */
2477   function beneficiaryWithdrawChunk(uint256 _value)
2478   public
2479   onlyOwner
2480   {
2481     vault.beneficiaryWithdrawChunk(_value);
2482   }
2483 
2484   /**
2485   @dev Owner can withdraw all funds during or after of ICO
2486   */
2487   function beneficiaryWithdrawAll()
2488   public
2489   onlyOwner
2490   {
2491     vault.beneficiaryWithdrawAll();
2492   }
2493 
2494   /**
2495   @dev Owner can do manual refund here if investore has "BAD" money
2496   @param _payee address of investor that needs to refund with next manual ETH sending
2497   */
2498   function manualRefund(address _payee) public onlyOwner {
2499     uint256 deposit = vault.depositsOf(_payee);
2500     vault.manualRefund(_payee);
2501     weiRaised = weiRaised.sub(deposit);
2502     ClinicAllToken(token).burnAfterRefund(_payee);
2503   }
2504 
2505 }