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
943   /**
944    * @dev Constructor.
945    * @param _beneficiary The beneficiary of the deposits.
946    */
947   constructor(address _beneficiary)
948   RefundEscrow(_beneficiary)
949   public {
950   }
951 
952   /**
953    * @dev Stores funds that may later be refunded.
954    * @param _refundee The address funds will be sent to if a refund occurs.
955    */
956   function deposit(address _refundee) public payable {
957     require(state == State.Active, "Funds deposition is possible only in the Active state.");
958     super.deposit(_refundee);
959 
960     RefundeeRecord storage _data = refundees[_refundee];
961     _data.isRefunded = false;
962 
963     if (_data.index == uint256(0)) {
964       refundeesList.push(_refundee);
965       _data.index = refundeesList.length.sub(1);
966     }
967   }
968 
969   /**
970   * @dev Allows for the beneficiary to withdraw their funds, rejecting
971   * further deposits.
972   */
973   function close() public onlyOwner {
974     super.close();
975     super.beneficiaryWithdraw();
976   }
977 
978   function withdraw(address _payee) public onlyOwner {
979     require(state == State.Refunding, "Funds withdrawal is possible only in the Refunding state.");
980     require(depositsOf(_payee) > 0, "An investor should have non-negative deposit for withdrawal.");
981 
982     RefundeeRecord storage _data = refundees[_payee];
983     require(_data.isRefunded == false, "An investor should not be refunded.");
984     super.withdraw(_payee);
985     _data.isRefunded = true;
986 
987     removeRefundeeByIndex(_data.index);
988   }
989 
990   /**
991   * @dev Remove refundee referenced index from the internal list
992   * @param _indexToDelete An index in an array for deletion
993   */
994   function removeRefundeeByIndex(uint256 _indexToDelete) private {
995     if ((refundeesList.length > 0) && (_indexToDelete < refundeesList.length)) {
996       uint256 _lastIndex = refundeesList.length.sub(1);
997       refundeesList[_indexToDelete] = refundeesList[_lastIndex];
998       refundeesList.length--;
999     }
1000   }
1001   /**
1002   * @dev Get refundee list length
1003   */
1004   function refundeesListLength() public onlyOwner view returns (uint256) {
1005     return refundeesList.length;
1006   }
1007 
1008   /**
1009   * @dev Auto refund
1010   * @param _txFee The cost of executing refund code
1011   */
1012   function withdrawChunk(uint256 _txFee, uint256 _chunkLength) public onlyOwner returns (uint256, address[]) {
1013     require(state == State.Refunding, "Funds withdrawal is possible only in the Refunding state.");
1014 
1015     uint256 _refundeesCount = refundeesList.length;
1016     require(_chunkLength >= _refundeesCount);
1017     require(_txFee > 0, "Transaction fee should be above zero.");
1018     require(_refundeesCount > 0, "List of investors should not be empty.");
1019     uint256 _weiRefunded = 0;
1020     require(address(this).balance > (_chunkLength.mul(_txFee)), "Account's ballance should allow to pay all tx fees.");
1021     address[] memory _refundeesListCopy = new address[](_chunkLength);
1022 
1023     uint256 i;
1024     for (i = 0; i < _chunkLength; i++) {
1025       address _refundee = refundeesList[i];
1026       RefundeeRecord storage _data = refundees[_refundee];
1027       if (_data.isRefunded == false) {
1028         if (depositsOf(_refundee) > _txFee) {
1029           uint256 _deposit = depositsOf(_refundee);
1030           if (_deposit > _txFee) {
1031             _weiRefunded = _weiRefunded.add(_deposit);
1032             uint256 _paymentWithoutTxFee = _deposit.sub(_txFee);
1033             _refundee.transfer(_paymentWithoutTxFee);
1034             emit Withdrawn(_refundee, _paymentWithoutTxFee);
1035             _data.isRefunded = true;
1036             _refundeesListCopy[i] = _refundee;
1037           }
1038         }
1039       }
1040     }
1041 
1042     for (i = 0; i < _chunkLength; i++) {
1043       if (address(0) != _refundeesListCopy[i]) {
1044         RefundeeRecord storage _dataCleanup = refundees[_refundeesListCopy[i]];
1045         require(_dataCleanup.isRefunded == true, "Investors in this list should be refunded.");
1046         removeRefundeeByIndex(_dataCleanup.index);
1047       }
1048     }
1049 
1050     return (_weiRefunded, _refundeesListCopy);
1051   }
1052 
1053   /**
1054   * @dev Auto refund
1055   * @param _txFee The cost of executing refund code
1056   */
1057   function withdrawEverything(uint256 _txFee) public onlyOwner returns (uint256, address[]) {
1058     require(state == State.Refunding, "Funds withdrawal is possible only in the Refunding state.");
1059     return withdrawChunk(_txFee, refundeesList.length);
1060   }
1061 }
1062 
1063 // File: node_modules\zeppelin-solidity\contracts\lifecycle\TokenDestructible.sol
1064 
1065 /**
1066  * @title TokenDestructible:
1067  * @author Remco Bloemen <remco@2π.com>
1068  * @dev Base contract that can be destroyed by owner. All funds in contract including
1069  * listed tokens will be sent to the owner.
1070  */
1071 contract TokenDestructible is Ownable {
1072 
1073   constructor() public payable { }
1074 
1075   /**
1076    * @notice Terminate contract and refund to owner
1077    * @param tokens List of addresses of ERC20 or ERC20Basic token contracts to
1078    refund.
1079    * @notice The called token contracts could try to re-enter this contract. Only
1080    supply token contracts you trust.
1081    */
1082   function destroy(address[] tokens) onlyOwner public {
1083 
1084     // Transfer tokens to owner
1085     for (uint256 i = 0; i < tokens.length; i++) {
1086       ERC20Basic token = ERC20Basic(tokens[i]);
1087       uint256 balance = token.balanceOf(this);
1088       token.transfer(owner, balance);
1089     }
1090 
1091     // Transfer Eth to owner and terminate contract
1092     selfdestruct(owner);
1093   }
1094 }
1095 
1096 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\BurnableToken.sol
1097 
1098 /**
1099  * @title Burnable Token
1100  * @dev Token that can be irreversibly burned (destroyed).
1101  */
1102 contract BurnableToken is BasicToken {
1103 
1104   event Burn(address indexed burner, uint256 value);
1105 
1106   /**
1107    * @dev Burns a specific amount of tokens.
1108    * @param _value The amount of token to be burned.
1109    */
1110   function burn(uint256 _value) public {
1111     _burn(msg.sender, _value);
1112   }
1113 
1114   function _burn(address _who, uint256 _value) internal {
1115     require(_value <= balances[_who]);
1116     // no need to require value <= totalSupply, since that would imply the
1117     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
1118 
1119     balances[_who] = balances[_who].sub(_value);
1120     totalSupply_ = totalSupply_.sub(_value);
1121     emit Burn(_who, _value);
1122     emit Transfer(_who, address(0), _value);
1123   }
1124 }
1125 
1126 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\DetailedERC20.sol
1127 
1128 /**
1129  * @title DetailedERC20 token
1130  * @dev The decimals are only for visualization purposes.
1131  * All the operations are done using the smallest and indivisible token unit,
1132  * just as on Ethereum all the operations are done in wei.
1133  */
1134 contract DetailedERC20 is ERC20 {
1135   string public name;
1136   string public symbol;
1137   uint8 public decimals;
1138 
1139   constructor(string _name, string _symbol, uint8 _decimals) public {
1140     name = _name;
1141     symbol = _symbol;
1142     decimals = _decimals;
1143   }
1144 }
1145 
1146 // File: node_modules\zeppelin-solidity\contracts\lifecycle\Pausable.sol
1147 
1148 /**
1149  * @title Pausable
1150  * @dev Base contract which allows children to implement an emergency stop mechanism.
1151  */
1152 contract Pausable is Ownable {
1153   event Pause();
1154   event Unpause();
1155 
1156   bool public paused = false;
1157 
1158 
1159   /**
1160    * @dev Modifier to make a function callable only when the contract is not paused.
1161    */
1162   modifier whenNotPaused() {
1163     require(!paused);
1164     _;
1165   }
1166 
1167   /**
1168    * @dev Modifier to make a function callable only when the contract is paused.
1169    */
1170   modifier whenPaused() {
1171     require(paused);
1172     _;
1173   }
1174 
1175   /**
1176    * @dev called by the owner to pause, triggers stopped state
1177    */
1178   function pause() onlyOwner whenNotPaused public {
1179     paused = true;
1180     emit Pause();
1181   }
1182 
1183   /**
1184    * @dev called by the owner to unpause, returns to normal state
1185    */
1186   function unpause() onlyOwner whenPaused public {
1187     paused = false;
1188     emit Unpause();
1189   }
1190 }
1191 
1192 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\PausableToken.sol
1193 
1194 /**
1195  * @title Pausable token
1196  * @dev StandardToken modified with pausable transfers.
1197  **/
1198 contract PausableToken is StandardToken, Pausable {
1199 
1200   function transfer(
1201     address _to,
1202     uint256 _value
1203   )
1204     public
1205     whenNotPaused
1206     returns (bool)
1207   {
1208     return super.transfer(_to, _value);
1209   }
1210 
1211   function transferFrom(
1212     address _from,
1213     address _to,
1214     uint256 _value
1215   )
1216     public
1217     whenNotPaused
1218     returns (bool)
1219   {
1220     return super.transferFrom(_from, _to, _value);
1221   }
1222 
1223   function approve(
1224     address _spender,
1225     uint256 _value
1226   )
1227     public
1228     whenNotPaused
1229     returns (bool)
1230   {
1231     return super.approve(_spender, _value);
1232   }
1233 
1234   function increaseApproval(
1235     address _spender,
1236     uint _addedValue
1237   )
1238     public
1239     whenNotPaused
1240     returns (bool success)
1241   {
1242     return super.increaseApproval(_spender, _addedValue);
1243   }
1244 
1245   function decreaseApproval(
1246     address _spender,
1247     uint _subtractedValue
1248   )
1249     public
1250     whenNotPaused
1251     returns (bool success)
1252   {
1253     return super.decreaseApproval(_spender, _subtractedValue);
1254   }
1255 }
1256 
1257 // File: contracts\ClinicAllToken.sol
1258 
1259 contract ClinicAllToken is MintableToken, DetailedERC20, CappedToken, PausableToken, BurnableToken, TokenDestructible {
1260   constructor
1261   (
1262     string _name,
1263     string _symbol,
1264     uint8 _decimals,
1265     uint256 _cap
1266   )
1267   DetailedERC20(_name, _symbol, _decimals)
1268   CappedToken(_cap)
1269   public
1270   {
1271 
1272   }
1273 
1274   /*/
1275   *  Refund event when ICO didn't pass soft cap and we refund ETH to investors + burn ERC-20 tokens from investors balances
1276   /*/
1277   function burnAfterRefund(address _who) public onlyOwner {
1278     uint256 _value = balances[_who];
1279     _burn(_who, _value);
1280   }
1281 
1282 }
1283 
1284 // File: node_modules\zeppelin-solidity\contracts\ownership\rbac\Roles.sol
1285 
1286 /**
1287  * @title Roles
1288  * @author Francisco Giordano (@frangio)
1289  * @dev Library for managing addresses assigned to a Role.
1290  * See RBAC.sol for example usage.
1291  */
1292 library Roles {
1293   struct Role {
1294     mapping (address => bool) bearer;
1295   }
1296 
1297   /**
1298    * @dev give an address access to this role
1299    */
1300   function add(Role storage role, address addr)
1301     internal
1302   {
1303     role.bearer[addr] = true;
1304   }
1305 
1306   /**
1307    * @dev remove an address' access to this role
1308    */
1309   function remove(Role storage role, address addr)
1310     internal
1311   {
1312     role.bearer[addr] = false;
1313   }
1314 
1315   /**
1316    * @dev check if an address has this role
1317    * // reverts
1318    */
1319   function check(Role storage role, address addr)
1320     view
1321     internal
1322   {
1323     require(has(role, addr));
1324   }
1325 
1326   /**
1327    * @dev check if an address has this role
1328    * @return bool
1329    */
1330   function has(Role storage role, address addr)
1331     view
1332     internal
1333     returns (bool)
1334   {
1335     return role.bearer[addr];
1336   }
1337 }
1338 
1339 // File: node_modules\zeppelin-solidity\contracts\ownership\rbac\RBAC.sol
1340 
1341 /**
1342  * @title RBAC (Role-Based Access Control)
1343  * @author Matt Condon (@Shrugs)
1344  * @dev Stores and provides setters and getters for roles and addresses.
1345  * Supports unlimited numbers of roles and addresses.
1346  * See //contracts/mocks/RBACMock.sol for an example of usage.
1347  * This RBAC method uses strings to key roles. It may be beneficial
1348  * for you to write your own implementation of this interface using Enums or similar.
1349  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
1350  * to avoid typos.
1351  */
1352 contract RBAC {
1353   using Roles for Roles.Role;
1354 
1355   mapping (string => Roles.Role) private roles;
1356 
1357   event RoleAdded(address indexed operator, string role);
1358   event RoleRemoved(address indexed operator, string role);
1359 
1360   /**
1361    * @dev reverts if addr does not have role
1362    * @param _operator address
1363    * @param _role the name of the role
1364    * // reverts
1365    */
1366   function checkRole(address _operator, string _role)
1367     view
1368     public
1369   {
1370     roles[_role].check(_operator);
1371   }
1372 
1373   /**
1374    * @dev determine if addr has role
1375    * @param _operator address
1376    * @param _role the name of the role
1377    * @return bool
1378    */
1379   function hasRole(address _operator, string _role)
1380     view
1381     public
1382     returns (bool)
1383   {
1384     return roles[_role].has(_operator);
1385   }
1386 
1387   /**
1388    * @dev add a role to an address
1389    * @param _operator address
1390    * @param _role the name of the role
1391    */
1392   function addRole(address _operator, string _role)
1393     internal
1394   {
1395     roles[_role].add(_operator);
1396     emit RoleAdded(_operator, _role);
1397   }
1398 
1399   /**
1400    * @dev remove a role from an address
1401    * @param _operator address
1402    * @param _role the name of the role
1403    */
1404   function removeRole(address _operator, string _role)
1405     internal
1406   {
1407     roles[_role].remove(_operator);
1408     emit RoleRemoved(_operator, _role);
1409   }
1410 
1411   /**
1412    * @dev modifier to scope access to a single role (uses msg.sender as addr)
1413    * @param _role the name of the role
1414    * // reverts
1415    */
1416   modifier onlyRole(string _role)
1417   {
1418     checkRole(msg.sender, _role);
1419     _;
1420   }
1421 
1422   /**
1423    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
1424    * @param _roles the names of the roles to scope access to
1425    * // reverts
1426    *
1427    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
1428    *  see: https://github.com/ethereum/solidity/issues/2467
1429    */
1430   // modifier onlyRoles(string[] _roles) {
1431   //     bool hasAnyRole = false;
1432   //     for (uint8 i = 0; i < _roles.length; i++) {
1433   //         if (hasRole(msg.sender, _roles[i])) {
1434   //             hasAnyRole = true;
1435   //             break;
1436   //         }
1437   //     }
1438 
1439   //     require(hasAnyRole);
1440 
1441   //     _;
1442   // }
1443 }
1444 
1445 // File: contracts\Managed.sol
1446 
1447 /**
1448  * @title Managed
1449  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
1450  * This simplifies the implementation of "user permissions".
1451  */
1452 contract Managed is Ownable, RBAC {
1453   string public constant ROLE_MANAGER = "manager";
1454 
1455   /**
1456   * @dev Throws if operator is not whitelisted.
1457   */
1458   modifier onlyManager() {
1459     checkRole(msg.sender, ROLE_MANAGER);
1460     _;
1461   }
1462 
1463   /**
1464   * @dev set an address as a manager
1465   * @param _operator address
1466   * @return true if the address was added to the whitelist, false if the address was already in the whitelist
1467   */
1468   function setManager(address _operator) public onlyOwner {
1469     addRole(_operator, ROLE_MANAGER);
1470   }
1471 }
1472 
1473 // File: contracts\Limited.sol
1474 
1475 /**
1476  * @title LimitedCrowdsale
1477  * @dev Crowdsale in which only limited number of tokens can be bought.
1478  */
1479 contract Limited is Managed {
1480   using SafeMath for uint256;
1481   mapping(address => uint256) public limitsList;
1482 
1483   /**
1484   * @dev Reverts if beneficiary has no limit. Can be used when extending this contract.
1485   */
1486   modifier isLimited(address _payee) {
1487     require(limitsList[_payee] > 0, "An investor is limited if it has a limit.");
1488     _;
1489   }
1490 
1491 
1492   /**
1493   * @dev Reverts if beneficiary want to buy more tickets than limit allows. Can be used when extending this contract.
1494   */
1495   modifier doesNotExceedLimit(address _payee, uint256 _tokenAmount, uint256 _tokenBalance) {
1496     require(_tokenBalance.add(_tokenAmount) <= getLimit(_payee), "An investor should not exceed its limit on buying.");
1497     _;
1498   }
1499 
1500   /**
1501   * @dev Returns limits for _payee.
1502   * @param _payee Address to get token limits
1503   */
1504   function getLimit(address _payee)
1505   public view returns (uint256)
1506   {
1507     return limitsList[_payee];
1508   }
1509 
1510   /**
1511   * @dev Adds limits to addresses.
1512   * @param _payees Addresses to set limit
1513   * @param _limits Limit values to set to addresses
1514   */
1515   function addAddressesLimits(address[] _payees, uint256[] _limits) public
1516   onlyManager
1517   {
1518     require(_payees.length == _limits.length, "Array sizes should be equal.");
1519     for (uint256 i = 0; i < _payees.length; i++) {
1520       addLimit(_payees[i], _limits[i]);
1521     }
1522   }
1523 
1524 
1525   /**
1526   * @dev Adds limit to address.
1527   * @param _payee Address to set limit
1528   * @param _limit Limit value to set to address
1529   */
1530   function addLimit(address _payee, uint256 _limit) public
1531   onlyManager
1532   {
1533     limitsList[_payee] = _limit;
1534   }
1535 
1536 
1537   /**
1538   * @dev Removes single address-limit record.
1539   * @param _payee Address to be removed
1540   */
1541   function removeLimit(address _payee) external
1542   onlyManager
1543   {
1544     limitsList[_payee] = 0;
1545   }
1546 
1547 }
1548 
1549 // File: node_modules\zeppelin-solidity\contracts\access\Whitelist.sol
1550 
1551 /**
1552  * @title Whitelist
1553  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
1554  * This simplifies the implementation of "user permissions".
1555  */
1556 contract Whitelist is Ownable, RBAC {
1557   string public constant ROLE_WHITELISTED = "whitelist";
1558 
1559   /**
1560    * @dev Throws if operator is not whitelisted.
1561    * @param _operator address
1562    */
1563   modifier onlyIfWhitelisted(address _operator) {
1564     checkRole(_operator, ROLE_WHITELISTED);
1565     _;
1566   }
1567 
1568   /**
1569    * @dev add an address to the whitelist
1570    * @param _operator address
1571    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
1572    */
1573   function addAddressToWhitelist(address _operator)
1574     onlyOwner
1575     public
1576   {
1577     addRole(_operator, ROLE_WHITELISTED);
1578   }
1579 
1580   /**
1581    * @dev getter to determine if address is in whitelist
1582    */
1583   function whitelist(address _operator)
1584     public
1585     view
1586     returns (bool)
1587   {
1588     return hasRole(_operator, ROLE_WHITELISTED);
1589   }
1590 
1591   /**
1592    * @dev add addresses to the whitelist
1593    * @param _operators addresses
1594    * @return true if at least one address was added to the whitelist,
1595    * false if all addresses were already in the whitelist
1596    */
1597   function addAddressesToWhitelist(address[] _operators)
1598     onlyOwner
1599     public
1600   {
1601     for (uint256 i = 0; i < _operators.length; i++) {
1602       addAddressToWhitelist(_operators[i]);
1603     }
1604   }
1605 
1606   /**
1607    * @dev remove an address from the whitelist
1608    * @param _operator address
1609    * @return true if the address was removed from the whitelist,
1610    * false if the address wasn't in the whitelist in the first place
1611    */
1612   function removeAddressFromWhitelist(address _operator)
1613     onlyOwner
1614     public
1615   {
1616     removeRole(_operator, ROLE_WHITELISTED);
1617   }
1618 
1619   /**
1620    * @dev remove addresses from the whitelist
1621    * @param _operators addresses
1622    * @return true if at least one address was removed from the whitelist,
1623    * false if all addresses weren't in the whitelist in the first place
1624    */
1625   function removeAddressesFromWhitelist(address[] _operators)
1626     onlyOwner
1627     public
1628   {
1629     for (uint256 i = 0; i < _operators.length; i++) {
1630       removeAddressFromWhitelist(_operators[i]);
1631     }
1632   }
1633 
1634 }
1635 
1636 // File: contracts\ManagedWhitelist.sol
1637 
1638 /**
1639  * @title ManagedWhitelist
1640  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
1641  * This simplifies the implementation of "user permissions".
1642  */
1643 contract ManagedWhitelist is Managed, Whitelist {
1644   /**
1645   * @dev add an address to the whitelist
1646   * @param _operator address
1647   * @return true if the address was added to the whitelist, false if the address was already in the whitelist
1648   */
1649   function addAddressToWhitelist(address _operator) public onlyManager {
1650     addRole(_operator, ROLE_WHITELISTED);
1651   }
1652 
1653   /**
1654   * @dev add addresses to the whitelist
1655   * @param _operators addresses
1656   * @return true if at least one address was added to the whitelist,
1657   * false if all addresses were already in the whitelist
1658   */
1659   function addAddressesToWhitelist(address[] _operators) public onlyManager {
1660     for (uint256 i = 0; i < _operators.length; i++) {
1661       addAddressToWhitelist(_operators[i]);
1662     }
1663   }
1664 
1665   /**
1666   * @dev remove an address from the whitelist
1667   * @param _operator address
1668   * @return true if the address was removed from the whitelist,
1669   * false if the address wasn't in the whitelist in the first place
1670   */
1671   function removeAddressFromWhitelist(address _operator) public onlyManager {
1672     removeRole(_operator, ROLE_WHITELISTED);
1673   }
1674 
1675   /**
1676   * @dev remove addresses from the whitelist
1677   * @param _operators addresses
1678   * @return true if at least one address was removed from the whitelist,
1679   * false if all addresses weren't in the whitelist in the first place
1680   */
1681   function removeAddressesFromWhitelist(address[] _operators) public onlyManager {
1682     for (uint256 i = 0; i < _operators.length; i++) {
1683       removeAddressFromWhitelist(_operators[i]);
1684     }
1685   }
1686 }
1687 
1688 // File: contracts\ClinicAllCrowdsale.sol
1689 
1690 /// @title ClinicAll crowdsale contract
1691 /// @dev  ClinicAll crowdsale contract
1692 contract ClinicAllCrowdsale is Crowdsale, FinalizableCrowdsale, MintedCrowdsale, ManagedWhitelist, Limited {
1693   constructor
1694   (
1695     uint256 _tokenLimitSupply,
1696     uint256 _rate,
1697     address _wallet,
1698     ERC20 _token,
1699     uint256 _openingTime,
1700     uint256 _closingTime,
1701     uint256 _discountTokenAmount,
1702     uint256 _discountTokenPercent,
1703     uint256 _privateSaleClosingTime,
1704     uint256 _softCapLimit,
1705     ClinicAllRefundEscrow _vault,
1706     uint256 _buyLimitSupplyMin,
1707     uint256 _buyLimitSupplyMax
1708   )
1709   Crowdsale(_rate, _wallet, _token)
1710   TimedCrowdsale(_openingTime, _closingTime)
1711   public
1712   {
1713     tokenSupplyLimit = _tokenLimitSupply;
1714     discountTokenAmount = _discountTokenAmount;
1715     discountTokenPercent = _discountTokenPercent;
1716     privateSaleClosingTime = _privateSaleClosingTime;
1717     softCapLimit = _softCapLimit;
1718     vault = _vault;
1719     buyLimitSupplyMin = _buyLimitSupplyMin;
1720     buyLimitSupplyMax = _buyLimitSupplyMax;
1721   }
1722 
1723   using SafeMath for uint256;
1724 
1725   // refund vault used to hold funds while crowdsale is running
1726   ClinicAllRefundEscrow public vault;
1727 
1728   /*/
1729   *  Properties, constants
1730   /*/
1731   // Limit of tokens for supply during ICO public sale
1732   uint256 public tokenSupplyLimit;
1733   // Limit of tokens with discount on current contract
1734   uint256 public discountTokenAmount;
1735   // Percent value for discount tokens
1736   uint256 public discountTokenPercent;
1737   // Time when we finish private sale
1738   uint256 public privateSaleClosingTime;
1739   // Minimum amount of funds to be raised in weis
1740   uint256 public softCapLimit;
1741   // Min buy limit for each investor
1742   uint256 public buyLimitSupplyMin;
1743   // Max buy limit for each investor
1744   uint256 public buyLimitSupplyMax;
1745 
1746   // Public functions
1747 
1748   /*/
1749   *  @dev CrowdSale manager is able to change rate value during ICO
1750   *  @param _rate wei to CHT tokens exchange rate
1751   */
1752   function updateRate(uint256 _rate) public
1753   onlyManager
1754   {
1755     require(_rate != 0, "Exchange rate should not be 0.");
1756     rate = _rate;
1757   }
1758 
1759   /*/
1760   *  @dev CrowdSale manager is able to change min and max buy limit for investors during ICO
1761   *  @param _min Minimal amount of tokens that could be bought
1762   *  @param _max Maximum amount of tokens that could be bought
1763   */
1764   function updateBuyLimitRange(uint256 _min, uint256 _max) public
1765   onlyOwner
1766   {
1767     require(_min != 0, "Minimal buy limit should not be 0.");
1768     require(_max != 0, "Maximal buy limit should not be 0.");
1769     require(_max > _min, "Maximal buy limit should be greater than minimal buy limit.");
1770     buyLimitSupplyMin = _min;
1771     buyLimitSupplyMax = _max;
1772   }
1773 
1774   /**
1775   * @dev Investors can claim refunds here if crowdsale is unsuccessful
1776   */
1777   function claimRefund() public {
1778     require(isFinalized, "Claim refunds is only possible if the ICO is finalized.");
1779     require(!goalReached(), "Claim refunds is only possible if the soft cap goal has not been reached.");
1780     uint256 deposit = vault.depositsOf(msg.sender);
1781     vault.withdraw(msg.sender);
1782     weiRaised = weiRaised.sub(deposit);
1783     ClinicAllToken(token).burnAfterRefund(msg.sender);
1784   }
1785 
1786   /**
1787   @dev Owner can claim full refund if a crowdsale is unsuccessful
1788   @param _txFee Transaction fee that will be deducted from an invested sum
1789   */
1790   function claimRefundChunk(uint256 _txFee, uint256 _chunkLength) public onlyOwner {
1791     require(isFinalized, "Claim refunds is only possible if the ICO is finalized.");
1792     require(!goalReached(), "Claim refunds is only possible if the soft cap goal has not been reached.");
1793     uint256 _weiRefunded;
1794     address[] memory _refundeesList;
1795     (_weiRefunded, _refundeesList) = vault.withdrawChunk(_txFee, _chunkLength);
1796     weiRaised = weiRaised.sub(_weiRefunded);
1797     for (uint256 i = 0; i < _refundeesList.length; i++) {
1798       ClinicAllToken(token).burnAfterRefund(_refundeesList[i]);
1799     }
1800   }
1801 
1802 
1803   /**
1804   * @dev Get refundee list length
1805   */
1806   function refundeesListLength() public onlyOwner view returns (uint256) {
1807     return vault.refundeesListLength();
1808   }
1809 
1810   /**
1811   * @dev Checks whether the period in which the crowdsale is open has already elapsed.
1812   * @return Whether crowdsale period has elapsed
1813   */
1814   function hasClosed() public view returns (bool) {
1815     return ((block.timestamp > closingTime) || tokenSupplyLimit <= token.totalSupply());
1816   }
1817 
1818   /**
1819   * @dev Checks whether funding goal was reached.
1820   * @return Whether funding goal was reached
1821   */
1822   function goalReached() public view returns (bool) {
1823     return token.totalSupply() >= softCapLimit;
1824   }
1825 
1826   /**
1827   * @dev Checks rest of tokens supply.
1828   */
1829   function supplyRest() public view returns (uint256) {
1830     return (tokenSupplyLimit.sub(token.totalSupply()));
1831   }
1832 
1833   //Private functions
1834 
1835   function _processPurchase(
1836     address _beneficiary,
1837     uint256 _tokenAmount
1838   )
1839   internal
1840   doesNotExceedLimit(_beneficiary, _tokenAmount, token.balanceOf(_beneficiary))
1841   {
1842     super._processPurchase(_beneficiary, _tokenAmount);
1843   }
1844 
1845   function _preValidatePurchase(
1846     address _beneficiary,
1847     uint256 _weiAmount
1848   )
1849   internal
1850   onlyIfWhitelisted(_beneficiary)
1851   isLimited(_beneficiary)
1852   {
1853     super._preValidatePurchase(_beneficiary, _weiAmount);
1854     uint256 tokens = _getTokenAmount(_weiAmount);
1855     require(tokens.add(token.totalSupply()) <= tokenSupplyLimit, "Total amount fo sold tokens should not exceed the total supply limit.");
1856     require(tokens >= buyLimitSupplyMin, "An investor can buy an amount of tokens only above the minimal limit.");
1857     require(tokens.add(token.balanceOf(_beneficiary)) <= buyLimitSupplyMax, "An investor cannot buy tokens above the maximal limit.");
1858   }
1859 
1860   /**
1861    * @dev Te way in which ether is converted to tokens.
1862    * @param _weiAmount Value in wei to be converted into tokens
1863    * @return Number of tokens that can be purchased with the specified _weiAmount with discount or not
1864    */
1865   function _getTokenAmount(uint256 _weiAmount)
1866   internal view returns (uint256)
1867   {
1868     if (isDiscount()) {
1869       return _getTokensWithDiscount(_weiAmount);
1870     }
1871     return _weiAmount.mul(rate);
1872   }
1873   /**
1874    * @dev Public method where ether is converted to tokens.
1875    * @param _weiAmount Value in wei to be converted into tokens
1876    */
1877   function getTokenAmount(uint256 _weiAmount)
1878   public view returns (uint256)
1879   {
1880     return _getTokenAmount(_weiAmount);
1881   }
1882 
1883   /**
1884    * @dev iternal method returns total tokens amount including discount
1885    */
1886   function _getTokensWithDiscount(uint256 _weiAmount)
1887   internal view returns (uint256)
1888   {
1889     uint256 tokens = 0;
1890     uint256 restOfDiscountTokens = discountTokenAmount.sub(token.totalSupply());
1891     uint256 discountTokensMax = _getDiscountTokenAmount(_weiAmount);
1892     if (restOfDiscountTokens < discountTokensMax) {
1893       uint256 discountTokens = restOfDiscountTokens;
1894       //get rest of WEI
1895       uint256 _rate = _getDiscountRate();
1896       uint256 _discointWeiAmount = discountTokens.div(_rate);
1897       uint256 _restOfWeiAmount = _weiAmount.sub(_discointWeiAmount);
1898       uint256 normalTokens = _restOfWeiAmount.mul(rate);
1899       tokens = discountTokens.add(normalTokens);
1900     } else {
1901       tokens = discountTokensMax;
1902     }
1903 
1904     return tokens;
1905   }
1906 
1907   /**
1908    * @dev iternal method returns discount tokens amount
1909    * @param _weiAmount An amount of ETH that should be converted to an amount of CHT tokens
1910    */
1911   function _getDiscountTokenAmount(uint256 _weiAmount)
1912   internal view returns (uint256)
1913   {
1914     require(_weiAmount != 0, "It should be possible to buy tokens only by providing non zero ETH.");
1915     uint256 _rate = _getDiscountRate();
1916     return _weiAmount.mul(_rate);
1917   }
1918 
1919   /**
1920    * @dev Returns the discount rate value
1921    */
1922   function _getDiscountRate()
1923   internal view returns (uint256)
1924   {
1925     require(isDiscount(), "Getting discount rate should be possible only below the discount tokens limit.");
1926     return rate.add(rate.mul(discountTokenPercent).div(100));
1927   }
1928 
1929   /**
1930    * @dev Returns the exchange rate value
1931    */
1932   function getRate()
1933   public view returns (uint256)
1934   {
1935     if (isDiscount()) {
1936       return _getDiscountRate();
1937     }
1938 
1939     return rate;
1940   }
1941 
1942   /**
1943    * @dev Returns the status if the ICO's private sale has closed or not
1944    */
1945   function isDiscount()
1946   public view returns (bool)
1947   {
1948     return (privateSaleClosingTime >= block.timestamp && token.totalSupply() < discountTokenAmount);
1949   }
1950 
1951   /**
1952    * @dev Internal method where owner transfers part of tokens to reserve
1953    */
1954 
1955   function transferTokensToReserve(address _beneficiary) private
1956   {
1957     require(tokenSupplyLimit < CappedToken(token).cap(), "Token's supply limit should be less that token' cap limit.");
1958     // calculate token amount to be created
1959     uint256 _tokenCap = CappedToken(token).cap();
1960     uint256 tokens = _tokenCap.sub(tokenSupplyLimit);
1961 
1962     _deliverTokens(_beneficiary, tokens);
1963   }
1964 
1965   /**
1966    * @dev Internal method where owner transfers part of tokens to reserve and finish minting
1967    */
1968   function finalization() internal {
1969     if (goalReached()) {
1970       transferTokensToReserve(wallet);
1971       vault.close();
1972     } else {
1973       vault.enableRefunds();
1974     }
1975     MintableToken(token).finishMinting();
1976     super.finalization();
1977   }
1978 
1979   /**
1980   * @dev Overrides Crowdsale fund forwarding, sending funds to vault.
1981   */
1982   function _forwardFunds() internal {
1983     vault.deposit.value(msg.value)(msg.sender);
1984   }
1985 }