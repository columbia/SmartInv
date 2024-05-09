1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
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
17 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address _owner, address _spender)
25     public view returns (uint256);
26 
27   function transferFrom(address _from, address _to, uint256 _value)
28     public returns (bool);
29 
30   function approve(address _spender, uint256 _value) public returns (bool);
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that throw on error
43  */
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, throws on overflow.
48   */
49   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
50     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
51     // benefit is lost if 'b' is also tested.
52     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53     if (_a == 0) {
54       return 0;
55     }
56 
57     c = _a * _b;
58     assert(c / _a == _b);
59     return c;
60   }
61 
62   /**
63   * @dev Integer division of two numbers, truncating the quotient.
64   */
65   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
66     // assert(_b > 0); // Solidity automatically throws when dividing by 0
67     // uint256 c = _a / _b;
68     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
69     return _a / _b;
70   }
71 
72   /**
73   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
74   */
75   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
76     assert(_b <= _a);
77     return _a - _b;
78   }
79 
80   /**
81   * @dev Adds two numbers, throws on overflow.
82   */
83   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
84     c = _a + _b;
85     assert(c >= _a);
86     return c;
87   }
88 }
89 
90 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
91 
92 /**
93  * @title SafeERC20
94  * @dev Wrappers around ERC20 operations that throw on failure.
95  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
96  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
97  */
98 library SafeERC20 {
99   function safeTransfer(
100     ERC20Basic _token,
101     address _to,
102     uint256 _value
103   )
104     internal
105   {
106     require(_token.transfer(_to, _value));
107   }
108 
109   function safeTransferFrom(
110     ERC20 _token,
111     address _from,
112     address _to,
113     uint256 _value
114   )
115     internal
116   {
117     require(_token.transferFrom(_from, _to, _value));
118   }
119 
120   function safeApprove(
121     ERC20 _token,
122     address _spender,
123     uint256 _value
124   )
125     internal
126   {
127     require(_token.approve(_spender, _value));
128   }
129 }
130 
131 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
132 
133 /**
134  * @title Crowdsale
135  * @dev Crowdsale is a base contract for managing a token crowdsale,
136  * allowing investors to purchase tokens with ether. This contract implements
137  * such functionality in its most fundamental form and can be extended to provide additional
138  * functionality and/or custom behavior.
139  * The external interface represents the basic interface for purchasing tokens, and conform
140  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
141  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
142  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
143  * behavior.
144  */
145 contract Crowdsale {
146   using SafeMath for uint256;
147   using SafeERC20 for ERC20;
148 
149   // The token being sold
150   ERC20 public token;
151 
152   // Address where funds are collected
153   address public wallet;
154 
155   // How many token units a buyer gets per wei.
156   // The rate is the conversion between wei and the smallest and indivisible token unit.
157   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
158   // 1 wei will give you 1 unit, or 0.001 TOK.
159   uint256 public rate;
160 
161   // Amount of wei raised
162   uint256 public weiRaised;
163 
164   /**
165    * Event for token purchase logging
166    * @param purchaser who paid for the tokens
167    * @param beneficiary who got the tokens
168    * @param value weis paid for purchase
169    * @param amount amount of tokens purchased
170    */
171   event TokenPurchase(
172     address indexed purchaser,
173     address indexed beneficiary,
174     uint256 value,
175     uint256 amount
176   );
177 
178   /**
179    * @param _rate Number of token units a buyer gets per wei
180    * @param _wallet Address where collected funds will be forwarded to
181    * @param _token Address of the token being sold
182    */
183   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
184     require(_rate > 0);
185     require(_wallet != address(0));
186     require(_token != address(0));
187 
188     rate = _rate;
189     wallet = _wallet;
190     token = _token;
191   }
192 
193   // -----------------------------------------
194   // Crowdsale external interface
195   // -----------------------------------------
196 
197   /**
198    * @dev fallback function ***DO NOT OVERRIDE***
199    */
200   function () external payable {
201     buyTokens(msg.sender);
202   }
203 
204   /**
205    * @dev low level token purchase ***DO NOT OVERRIDE***
206    * @param _beneficiary Address performing the token purchase
207    */
208   function buyTokens(address _beneficiary) public payable {
209 
210     uint256 weiAmount = msg.value;
211     _preValidatePurchase(_beneficiary, weiAmount);
212 
213     // calculate token amount to be created
214     uint256 tokens = _getTokenAmount(weiAmount);
215 
216     // update state
217     weiRaised = weiRaised.add(weiAmount);
218 
219     _processPurchase(_beneficiary, tokens);
220     emit TokenPurchase(
221       msg.sender,
222       _beneficiary,
223       weiAmount,
224       tokens
225     );
226 
227     _updatePurchasingState(_beneficiary, weiAmount);
228 
229     _forwardFunds();
230     _postValidatePurchase(_beneficiary, weiAmount);
231   }
232 
233   // -----------------------------------------
234   // Internal interface (extensible)
235   // -----------------------------------------
236 
237   /**
238    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
239    * Example from CappedCrowdsale.sol's _preValidatePurchase method: 
240    *   super._preValidatePurchase(_beneficiary, _weiAmount);
241    *   require(weiRaised.add(_weiAmount) <= cap);
242    * @param _beneficiary Address performing the token purchase
243    * @param _weiAmount Value in wei involved in the purchase
244    */
245   function _preValidatePurchase(
246     address _beneficiary,
247     uint256 _weiAmount
248   )
249     internal
250   {
251     require(_beneficiary != address(0));
252     require(_weiAmount != 0);
253   }
254 
255   /**
256    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
257    * @param _beneficiary Address performing the token purchase
258    * @param _weiAmount Value in wei involved in the purchase
259    */
260   function _postValidatePurchase(
261     address _beneficiary,
262     uint256 _weiAmount
263   )
264     internal
265   {
266     // optional override
267   }
268 
269   /**
270    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
271    * @param _beneficiary Address performing the token purchase
272    * @param _tokenAmount Number of tokens to be emitted
273    */
274   function _deliverTokens(
275     address _beneficiary,
276     uint256 _tokenAmount
277   )
278     internal
279   {
280     token.safeTransfer(_beneficiary, _tokenAmount);
281   }
282 
283   /**
284    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
285    * @param _beneficiary Address receiving the tokens
286    * @param _tokenAmount Number of tokens to be purchased
287    */
288   function _processPurchase(
289     address _beneficiary,
290     uint256 _tokenAmount
291   )
292     internal
293   {
294     _deliverTokens(_beneficiary, _tokenAmount);
295   }
296 
297   /**
298    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
299    * @param _beneficiary Address receiving the tokens
300    * @param _weiAmount Value in wei involved in the purchase
301    */
302   function _updatePurchasingState(
303     address _beneficiary,
304     uint256 _weiAmount
305   )
306     internal
307   {
308     // optional override
309   }
310 
311   /**
312    * @dev Override to extend the way in which ether is converted to tokens.
313    * @param _weiAmount Value in wei to be converted into tokens
314    * @return Number of tokens that can be purchased with the specified _weiAmount
315    */
316   function _getTokenAmount(uint256 _weiAmount)
317     internal view returns (uint256)
318   {
319     return _weiAmount.mul(rate);
320   }
321 
322   /**
323    * @dev Determines how ETH is stored/forwarded on purchases.
324    */
325   function _forwardFunds() internal {
326     wallet.transfer(msg.value);
327   }
328 }
329 
330 // File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
331 
332 /**
333  * @title TimedCrowdsale
334  * @dev Crowdsale accepting contributions only within a time frame.
335  */
336 contract TimedCrowdsale is Crowdsale {
337   using SafeMath for uint256;
338 
339   uint256 public openingTime;
340   uint256 public closingTime;
341 
342   /**
343    * @dev Reverts if not in crowdsale time range.
344    */
345   modifier onlyWhileOpen {
346     // solium-disable-next-line security/no-block-members
347     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
348     _;
349   }
350 
351   /**
352    * @dev Constructor, takes crowdsale opening and closing times.
353    * @param _openingTime Crowdsale opening time
354    * @param _closingTime Crowdsale closing time
355    */
356   constructor(uint256 _openingTime, uint256 _closingTime) public {
357     // solium-disable-next-line security/no-block-members
358     require(_openingTime >= block.timestamp);
359     require(_closingTime >= _openingTime);
360 
361     openingTime = _openingTime;
362     closingTime = _closingTime;
363   }
364 
365   /**
366    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
367    * @return Whether crowdsale period has elapsed
368    */
369   function hasClosed() public view returns (bool) {
370     // solium-disable-next-line security/no-block-members
371     return block.timestamp > closingTime;
372   }
373 
374   /**
375    * @dev Extend parent behavior requiring to be within contributing period
376    * @param _beneficiary Token purchaser
377    * @param _weiAmount Amount of wei contributed
378    */
379   function _preValidatePurchase(
380     address _beneficiary,
381     uint256 _weiAmount
382   )
383     internal
384     onlyWhileOpen
385   {
386     super._preValidatePurchase(_beneficiary, _weiAmount);
387   }
388 
389 }
390 
391 // File: openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
392 
393 /**
394  * @title CappedCrowdsale
395  * @dev Crowdsale with a limit for total contributions.
396  */
397 contract CappedCrowdsale is Crowdsale {
398   using SafeMath for uint256;
399 
400   uint256 public cap;
401 
402   /**
403    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
404    * @param _cap Max amount of wei to be contributed
405    */
406   constructor(uint256 _cap) public {
407     require(_cap > 0);
408     cap = _cap;
409   }
410 
411   /**
412    * @dev Checks whether the cap has been reached.
413    * @return Whether the cap was reached
414    */
415   function capReached() public view returns (bool) {
416     return weiRaised >= cap;
417   }
418 
419   /**
420    * @dev Extend parent behavior requiring purchase to respect the funding cap.
421    * @param _beneficiary Token purchaser
422    * @param _weiAmount Amount of wei contributed
423    */
424   function _preValidatePurchase(
425     address _beneficiary,
426     uint256 _weiAmount
427   )
428     internal
429   {
430     super._preValidatePurchase(_beneficiary, _weiAmount);
431     require(weiRaised.add(_weiAmount) <= cap);
432   }
433 
434 }
435 
436 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
437 
438 /**
439  * @title Basic token
440  * @dev Basic version of StandardToken, with no allowances.
441  */
442 contract BasicToken is ERC20Basic {
443   using SafeMath for uint256;
444 
445   mapping(address => uint256) internal balances;
446 
447   uint256 internal totalSupply_;
448 
449   /**
450   * @dev Total number of tokens in existence
451   */
452   function totalSupply() public view returns (uint256) {
453     return totalSupply_;
454   }
455 
456   /**
457   * @dev Transfer token for a specified address
458   * @param _to The address to transfer to.
459   * @param _value The amount to be transferred.
460   */
461   function transfer(address _to, uint256 _value) public returns (bool) {
462     require(_value <= balances[msg.sender]);
463     require(_to != address(0));
464 
465     balances[msg.sender] = balances[msg.sender].sub(_value);
466     balances[_to] = balances[_to].add(_value);
467     emit Transfer(msg.sender, _to, _value);
468     return true;
469   }
470 
471   /**
472   * @dev Gets the balance of the specified address.
473   * @param _owner The address to query the the balance of.
474   * @return An uint256 representing the amount owned by the passed address.
475   */
476   function balanceOf(address _owner) public view returns (uint256) {
477     return balances[_owner];
478   }
479 
480 }
481 
482 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
483 
484 /**
485  * @title Standard ERC20 token
486  *
487  * @dev Implementation of the basic standard token.
488  * https://github.com/ethereum/EIPs/issues/20
489  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
490  */
491 contract StandardToken is ERC20, BasicToken {
492 
493   mapping (address => mapping (address => uint256)) internal allowed;
494 
495 
496   /**
497    * @dev Transfer tokens from one address to another
498    * @param _from address The address which you want to send tokens from
499    * @param _to address The address which you want to transfer to
500    * @param _value uint256 the amount of tokens to be transferred
501    */
502   function transferFrom(
503     address _from,
504     address _to,
505     uint256 _value
506   )
507     public
508     returns (bool)
509   {
510     require(_value <= balances[_from]);
511     require(_value <= allowed[_from][msg.sender]);
512     require(_to != address(0));
513 
514     balances[_from] = balances[_from].sub(_value);
515     balances[_to] = balances[_to].add(_value);
516     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
517     emit Transfer(_from, _to, _value);
518     return true;
519   }
520 
521   /**
522    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
523    * Beware that changing an allowance with this method brings the risk that someone may use both the old
524    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
525    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
526    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
527    * @param _spender The address which will spend the funds.
528    * @param _value The amount of tokens to be spent.
529    */
530   function approve(address _spender, uint256 _value) public returns (bool) {
531     allowed[msg.sender][_spender] = _value;
532     emit Approval(msg.sender, _spender, _value);
533     return true;
534   }
535 
536   /**
537    * @dev Function to check the amount of tokens that an owner allowed to a spender.
538    * @param _owner address The address which owns the funds.
539    * @param _spender address The address which will spend the funds.
540    * @return A uint256 specifying the amount of tokens still available for the spender.
541    */
542   function allowance(
543     address _owner,
544     address _spender
545    )
546     public
547     view
548     returns (uint256)
549   {
550     return allowed[_owner][_spender];
551   }
552 
553   /**
554    * @dev Increase the amount of tokens that an owner allowed to a spender.
555    * approve should be called when allowed[_spender] == 0. To increment
556    * allowed value is better to use this function to avoid 2 calls (and wait until
557    * the first transaction is mined)
558    * From MonolithDAO Token.sol
559    * @param _spender The address which will spend the funds.
560    * @param _addedValue The amount of tokens to increase the allowance by.
561    */
562   function increaseApproval(
563     address _spender,
564     uint256 _addedValue
565   )
566     public
567     returns (bool)
568   {
569     allowed[msg.sender][_spender] = (
570       allowed[msg.sender][_spender].add(_addedValue));
571     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
572     return true;
573   }
574 
575   /**
576    * @dev Decrease the amount of tokens that an owner allowed to a spender.
577    * approve should be called when allowed[_spender] == 0. To decrement
578    * allowed value is better to use this function to avoid 2 calls (and wait until
579    * the first transaction is mined)
580    * From MonolithDAO Token.sol
581    * @param _spender The address which will spend the funds.
582    * @param _subtractedValue The amount of tokens to decrease the allowance by.
583    */
584   function decreaseApproval(
585     address _spender,
586     uint256 _subtractedValue
587   )
588     public
589     returns (bool)
590   {
591     uint256 oldValue = allowed[msg.sender][_spender];
592     if (_subtractedValue >= oldValue) {
593       allowed[msg.sender][_spender] = 0;
594     } else {
595       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
596     }
597     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
598     return true;
599   }
600 
601 }
602 
603 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
604 
605 /**
606  * @title Ownable
607  * @dev The Ownable contract has an owner address, and provides basic authorization control
608  * functions, this simplifies the implementation of "user permissions".
609  */
610 contract Ownable {
611   address public owner;
612 
613 
614   event OwnershipRenounced(address indexed previousOwner);
615   event OwnershipTransferred(
616     address indexed previousOwner,
617     address indexed newOwner
618   );
619 
620 
621   /**
622    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
623    * account.
624    */
625   constructor() public {
626     owner = msg.sender;
627   }
628 
629   /**
630    * @dev Throws if called by any account other than the owner.
631    */
632   modifier onlyOwner() {
633     require(msg.sender == owner);
634     _;
635   }
636 
637   /**
638    * @dev Allows the current owner to relinquish control of the contract.
639    * @notice Renouncing to ownership will leave the contract without an owner.
640    * It will not be possible to call the functions with the `onlyOwner`
641    * modifier anymore.
642    */
643   function renounceOwnership() public onlyOwner {
644     emit OwnershipRenounced(owner);
645     owner = address(0);
646   }
647 
648   /**
649    * @dev Allows the current owner to transfer control of the contract to a newOwner.
650    * @param _newOwner The address to transfer ownership to.
651    */
652   function transferOwnership(address _newOwner) public onlyOwner {
653     _transferOwnership(_newOwner);
654   }
655 
656   /**
657    * @dev Transfers control of the contract to a newOwner.
658    * @param _newOwner The address to transfer ownership to.
659    */
660   function _transferOwnership(address _newOwner) internal {
661     require(_newOwner != address(0));
662     emit OwnershipTransferred(owner, _newOwner);
663     owner = _newOwner;
664   }
665 }
666 
667 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
668 
669 /**
670  * @title Mintable token
671  * @dev Simple ERC20 Token example, with mintable token creation
672  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
673  */
674 contract MintableToken is StandardToken, Ownable {
675   event Mint(address indexed to, uint256 amount);
676   event MintFinished();
677 
678   bool public mintingFinished = false;
679 
680 
681   modifier canMint() {
682     require(!mintingFinished);
683     _;
684   }
685 
686   modifier hasMintPermission() {
687     require(msg.sender == owner);
688     _;
689   }
690 
691   /**
692    * @dev Function to mint tokens
693    * @param _to The address that will receive the minted tokens.
694    * @param _amount The amount of tokens to mint.
695    * @return A boolean that indicates if the operation was successful.
696    */
697   function mint(
698     address _to,
699     uint256 _amount
700   )
701     public
702     hasMintPermission
703     canMint
704     returns (bool)
705   {
706     totalSupply_ = totalSupply_.add(_amount);
707     balances[_to] = balances[_to].add(_amount);
708     emit Mint(_to, _amount);
709     emit Transfer(address(0), _to, _amount);
710     return true;
711   }
712 
713   /**
714    * @dev Function to stop minting new tokens.
715    * @return True if the operation was successful.
716    */
717   function finishMinting() public onlyOwner canMint returns (bool) {
718     mintingFinished = true;
719     emit MintFinished();
720     return true;
721   }
722 }
723 
724 // File: openzeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol
725 
726 /**
727  * @title MintedCrowdsale
728  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
729  * Token ownership should be transferred to MintedCrowdsale for minting.
730  */
731 contract MintedCrowdsale is Crowdsale {
732 
733   /**
734    * @dev Overrides delivery by minting tokens upon purchase.
735    * @param _beneficiary Token purchaser
736    * @param _tokenAmount Number of tokens to be minted
737    */
738   function _deliverTokens(
739     address _beneficiary,
740     uint256 _tokenAmount
741   )
742     internal
743   {
744     // Potentially dangerous assumption about the type of the token.
745     require(MintableToken(address(token)).mint(_beneficiary, _tokenAmount));
746   }
747 }
748 
749 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
750 
751 /**
752  * @title DetailedERC20 token
753  * @dev The decimals are only for visualization purposes.
754  * All the operations are done using the smallest and indivisible token unit,
755  * just as on Ethereum all the operations are done in wei.
756  */
757 contract DetailedERC20 is ERC20 {
758   string public name;
759   string public symbol;
760   uint8 public decimals;
761 
762   constructor(string _name, string _symbol, uint8 _decimals) public {
763     name = _name;
764     symbol = _symbol;
765     decimals = _decimals;
766   }
767 }
768 
769 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
770 
771 /**
772  * @title Pausable
773  * @dev Base contract which allows children to implement an emergency stop mechanism.
774  */
775 contract Pausable is Ownable {
776   event Pause();
777   event Unpause();
778 
779   bool public paused = false;
780 
781 
782   /**
783    * @dev Modifier to make a function callable only when the contract is not paused.
784    */
785   modifier whenNotPaused() {
786     require(!paused);
787     _;
788   }
789 
790   /**
791    * @dev Modifier to make a function callable only when the contract is paused.
792    */
793   modifier whenPaused() {
794     require(paused);
795     _;
796   }
797 
798   /**
799    * @dev called by the owner to pause, triggers stopped state
800    */
801   function pause() public onlyOwner whenNotPaused {
802     paused = true;
803     emit Pause();
804   }
805 
806   /**
807    * @dev called by the owner to unpause, returns to normal state
808    */
809   function unpause() public onlyOwner whenPaused {
810     paused = false;
811     emit Unpause();
812   }
813 }
814 
815 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
816 
817 /**
818  * @title Pausable token
819  * @dev StandardToken modified with pausable transfers.
820  **/
821 contract PausableToken is StandardToken, Pausable {
822 
823   function transfer(
824     address _to,
825     uint256 _value
826   )
827     public
828     whenNotPaused
829     returns (bool)
830   {
831     return super.transfer(_to, _value);
832   }
833 
834   function transferFrom(
835     address _from,
836     address _to,
837     uint256 _value
838   )
839     public
840     whenNotPaused
841     returns (bool)
842   {
843     return super.transferFrom(_from, _to, _value);
844   }
845 
846   function approve(
847     address _spender,
848     uint256 _value
849   )
850     public
851     whenNotPaused
852     returns (bool)
853   {
854     return super.approve(_spender, _value);
855   }
856 
857   function increaseApproval(
858     address _spender,
859     uint _addedValue
860   )
861     public
862     whenNotPaused
863     returns (bool success)
864   {
865     return super.increaseApproval(_spender, _addedValue);
866   }
867 
868   function decreaseApproval(
869     address _spender,
870     uint _subtractedValue
871   )
872     public
873     whenNotPaused
874     returns (bool success)
875   {
876     return super.decreaseApproval(_spender, _subtractedValue);
877   }
878 }
879 
880 // File: ../contracts/LoonieToken.sol
881 
882 /**
883  * The LoonieToken contract Creates Loonie Tokens
884  */
885 contract LoonieToken is MintableToken, PausableToken, DetailedERC20 {
886 	string public name = "Loonie Token";
887     string public symbol = "LNI";
888     uint8 public decimals = 18;
889 
890 
891 	constructor 
892 	(
893 		string _name, 
894 		string _symbol, 
895 		uint8 _decimals
896 	) 
897 	public
898 	
899 	DetailedERC20(_name, _symbol, _decimals){
900 		_name = name;
901 		_symbol = symbol;
902 		_decimals = decimals;
903 
904 	}
905 
906 	}
907 
908 // File: ../contracts/LoonieCrowdsale.sol
909 
910 contract LoonieCrowdsale is Crowdsale, TimedCrowdsale, CappedCrowdsale, MintedCrowdsale {
911     using SafeMath for uint256;
912     LoonieToken token;
913     bool public isFinalized = false;
914 
915     event Finalized();
916     constructor
917     (
918         uint256 _rate,
919         address _wallet,
920         LoonieToken _token,
921         uint256 _openingTime,
922         uint256 _closingTime,
923         uint256 _cap
924     ) 
925         Crowdsale(_rate, _wallet, _token)
926         TimedCrowdsale(_openingTime, _closingTime)
927         CappedCrowdsale(_cap)
928         public
929     {
930        token = _token; 
931     }
932     function _getTokenAmount(uint256 _weiAmount)
933       internal 
934       view
935       returns (uint256){
936         super._getTokenAmount(_weiAmount);
937         uint256 tokens = _weiAmount.mul(rate);
938         return tokens.add(tokens.mul(10).div(100));
939       }
940     function giveBackOwnership(address _wallet)
941     public {
942         token.transferOwnership(_wallet);
943     }
944 
945     function finalize() public {
946         require(!isFinalized);
947        // require(hasClosed() || capReached());
948 
949         finalization();
950         emit Finalized();
951 
952         isFinalized = true;
953     } 
954     
955     function finalization() internal {
956         token.finishMinting();  
957     }
958 
959 }