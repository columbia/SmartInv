1 pragma solidity 0.4.24;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
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
55 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
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
119 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
120 
121 /**
122  * @title ERC20Basic
123  * @dev Simpler version of ERC20 interface
124  * See https://github.com/ethereum/EIPs/issues/179
125  */
126 contract ERC20Basic {
127   function totalSupply() public view returns (uint256);
128   function balanceOf(address _who) public view returns (uint256);
129   function transfer(address _to, uint256 _value) public returns (bool);
130   event Transfer(address indexed from, address indexed to, uint256 value);
131 }
132 
133 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
134 
135 /**
136  * @title ERC20 interface
137  * @dev see https://github.com/ethereum/EIPs/issues/20
138  */
139 contract ERC20 is ERC20Basic {
140   function allowance(address _owner, address _spender)
141     public view returns (uint256);
142 
143   function transferFrom(address _from, address _to, uint256 _value)
144     public returns (bool);
145 
146   function approve(address _spender, uint256 _value) public returns (bool);
147   event Approval(
148     address indexed owner,
149     address indexed spender,
150     uint256 value
151   );
152 }
153 
154 // File: zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
155 
156 /**
157  * @title SafeERC20
158  * @dev Wrappers around ERC20 operations that throw on failure.
159  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
160  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
161  */
162 library SafeERC20 {
163   function safeTransfer(
164     ERC20Basic _token,
165     address _to,
166     uint256 _value
167   )
168     internal
169   {
170     require(_token.transfer(_to, _value));
171   }
172 
173   function safeTransferFrom(
174     ERC20 _token,
175     address _from,
176     address _to,
177     uint256 _value
178   )
179     internal
180   {
181     require(_token.transferFrom(_from, _to, _value));
182   }
183 
184   function safeApprove(
185     ERC20 _token,
186     address _spender,
187     uint256 _value
188   )
189     internal
190   {
191     require(_token.approve(_spender, _value));
192   }
193 }
194 
195 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
196 
197 /**
198  * @title Crowdsale
199  * @dev Crowdsale is a base contract for managing a token crowdsale,
200  * allowing investors to purchase tokens with ether. This contract implements
201  * such functionality in its most fundamental form and can be extended to provide additional
202  * functionality and/or custom behavior.
203  * The external interface represents the basic interface for purchasing tokens, and conform
204  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
205  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
206  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
207  * behavior.
208  */
209 contract Crowdsale {
210   using SafeMath for uint256;
211   using SafeERC20 for ERC20;
212 
213   // The token being sold
214   ERC20 public token;
215 
216   // Address where funds are collected
217   address public wallet;
218 
219   // How many token units a buyer gets per wei.
220   // The rate is the conversion between wei and the smallest and indivisible token unit.
221   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
222   // 1 wei will give you 1 unit, or 0.001 TOK.
223   uint256 public rate;
224 
225   // Amount of wei raised
226   uint256 public weiRaised;
227 
228   /**
229    * Event for token purchase logging
230    * @param purchaser who paid for the tokens
231    * @param beneficiary who got the tokens
232    * @param value weis paid for purchase
233    * @param amount amount of tokens purchased
234    */
235   event TokenPurchase(
236     address indexed purchaser,
237     address indexed beneficiary,
238     uint256 value,
239     uint256 amount
240   );
241 
242   /**
243    * @param _rate Number of token units a buyer gets per wei
244    * @param _wallet Address where collected funds will be forwarded to
245    * @param _token Address of the token being sold
246    */
247   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
248     require(_rate > 0);
249     require(_wallet != address(0));
250     require(_token != address(0));
251 
252     rate = _rate;
253     wallet = _wallet;
254     token = _token;
255   }
256 
257   // -----------------------------------------
258   // Crowdsale external interface
259   // -----------------------------------------
260 
261   /**
262    * @dev fallback function ***DO NOT OVERRIDE***
263    */
264   function () external payable {
265     buyTokens(msg.sender);
266   }
267 
268   /**
269    * @dev low level token purchase ***DO NOT OVERRIDE***
270    * @param _beneficiary Address performing the token purchase
271    */
272   function buyTokens(address _beneficiary) public payable {
273 
274     uint256 weiAmount = msg.value;
275     _preValidatePurchase(_beneficiary, weiAmount);
276 
277     // calculate token amount to be created
278     uint256 tokens = _getTokenAmount(weiAmount);
279 
280     // update state
281     weiRaised = weiRaised.add(weiAmount);
282 
283     _processPurchase(_beneficiary, tokens);
284     emit TokenPurchase(
285       msg.sender,
286       _beneficiary,
287       weiAmount,
288       tokens
289     );
290 
291     _updatePurchasingState(_beneficiary, weiAmount);
292 
293     _forwardFunds();
294     _postValidatePurchase(_beneficiary, weiAmount);
295   }
296 
297   // -----------------------------------------
298   // Internal interface (extensible)
299   // -----------------------------------------
300 
301   /**
302    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
303    * Example from CappedCrowdsale.sol's _preValidatePurchase method:
304    *   super._preValidatePurchase(_beneficiary, _weiAmount);
305    *   require(weiRaised.add(_weiAmount) <= cap);
306    * @param _beneficiary Address performing the token purchase
307    * @param _weiAmount Value in wei involved in the purchase
308    */
309   function _preValidatePurchase(
310     address _beneficiary,
311     uint256 _weiAmount
312   )
313     internal
314   {
315     require(_beneficiary != address(0));
316     require(_weiAmount != 0);
317   }
318 
319   /**
320    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
321    * @param _beneficiary Address performing the token purchase
322    * @param _weiAmount Value in wei involved in the purchase
323    */
324   function _postValidatePurchase(
325     address _beneficiary,
326     uint256 _weiAmount
327   )
328     internal
329   {
330     // optional override
331   }
332 
333   /**
334    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
335    * @param _beneficiary Address performing the token purchase
336    * @param _tokenAmount Number of tokens to be emitted
337    */
338   function _deliverTokens(
339     address _beneficiary,
340     uint256 _tokenAmount
341   )
342     internal
343   {
344     token.safeTransfer(_beneficiary, _tokenAmount);
345   }
346 
347   /**
348    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
349    * @param _beneficiary Address receiving the tokens
350    * @param _tokenAmount Number of tokens to be purchased
351    */
352   function _processPurchase(
353     address _beneficiary,
354     uint256 _tokenAmount
355   )
356     internal
357   {
358     _deliverTokens(_beneficiary, _tokenAmount);
359   }
360 
361   /**
362    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
363    * @param _beneficiary Address receiving the tokens
364    * @param _weiAmount Value in wei involved in the purchase
365    */
366   function _updatePurchasingState(
367     address _beneficiary,
368     uint256 _weiAmount
369   )
370     internal
371   {
372     // optional override
373   }
374 
375   /**
376    * @dev Override to extend the way in which ether is converted to tokens.
377    * @param _weiAmount Value in wei to be converted into tokens
378    * @return Number of tokens that can be purchased with the specified _weiAmount
379    */
380   function _getTokenAmount(uint256 _weiAmount)
381     internal view returns (uint256)
382   {
383     return _weiAmount.mul(rate);
384   }
385 
386   /**
387    * @dev Determines how ETH is stored/forwarded on purchases.
388    */
389   function _forwardFunds() internal {
390     wallet.transfer(msg.value);
391   }
392 }
393 
394 // File: zeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
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
455 // File: zeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol
456 
457 /**
458  * @title FinalizableCrowdsale
459  * @dev Extension of Crowdsale where an owner can do extra work
460  * after finishing.
461  */
462 contract FinalizableCrowdsale is Ownable, TimedCrowdsale {
463   using SafeMath for uint256;
464 
465   bool public isFinalized = false;
466 
467   event Finalized();
468 
469   /**
470    * @dev Must be called after crowdsale ends, to do some extra finalization
471    * work. Calls the contract's finalization function.
472    */
473   function finalize() public onlyOwner {
474     require(!isFinalized);
475     require(hasClosed());
476 
477     finalization();
478     emit Finalized();
479 
480     isFinalized = true;
481   }
482 
483   /**
484    * @dev Can be overridden to add finalization logic. The overriding function
485    * should call super.finalization() to ensure the chain of finalization is
486    * executed entirely.
487    */
488   function finalization() internal {
489   }
490 
491 }
492 
493 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
494 
495 /**
496  * @title Basic token
497  * @dev Basic version of StandardToken, with no allowances.
498  */
499 contract BasicToken is ERC20Basic {
500   using SafeMath for uint256;
501 
502   mapping(address => uint256) internal balances;
503 
504   uint256 internal totalSupply_;
505 
506   /**
507   * @dev Total number of tokens in existence
508   */
509   function totalSupply() public view returns (uint256) {
510     return totalSupply_;
511   }
512 
513   /**
514   * @dev Transfer token for a specified address
515   * @param _to The address to transfer to.
516   * @param _value The amount to be transferred.
517   */
518   function transfer(address _to, uint256 _value) public returns (bool) {
519     require(_value <= balances[msg.sender]);
520     require(_to != address(0));
521 
522     balances[msg.sender] = balances[msg.sender].sub(_value);
523     balances[_to] = balances[_to].add(_value);
524     emit Transfer(msg.sender, _to, _value);
525     return true;
526   }
527 
528   /**
529   * @dev Gets the balance of the specified address.
530   * @param _owner The address to query the the balance of.
531   * @return An uint256 representing the amount owned by the passed address.
532   */
533   function balanceOf(address _owner) public view returns (uint256) {
534     return balances[_owner];
535   }
536 
537 }
538 
539 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
540 
541 /**
542  * @title Standard ERC20 token
543  *
544  * @dev Implementation of the basic standard token.
545  * https://github.com/ethereum/EIPs/issues/20
546  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
547  */
548 contract StandardToken is ERC20, BasicToken {
549 
550   mapping (address => mapping (address => uint256)) internal allowed;
551 
552 
553   /**
554    * @dev Transfer tokens from one address to another
555    * @param _from address The address which you want to send tokens from
556    * @param _to address The address which you want to transfer to
557    * @param _value uint256 the amount of tokens to be transferred
558    */
559   function transferFrom(
560     address _from,
561     address _to,
562     uint256 _value
563   )
564     public
565     returns (bool)
566   {
567     require(_value <= balances[_from]);
568     require(_value <= allowed[_from][msg.sender]);
569     require(_to != address(0));
570 
571     balances[_from] = balances[_from].sub(_value);
572     balances[_to] = balances[_to].add(_value);
573     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
574     emit Transfer(_from, _to, _value);
575     return true;
576   }
577 
578   /**
579    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
580    * Beware that changing an allowance with this method brings the risk that someone may use both the old
581    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
582    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
583    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
584    * @param _spender The address which will spend the funds.
585    * @param _value The amount of tokens to be spent.
586    */
587   function approve(address _spender, uint256 _value) public returns (bool) {
588     allowed[msg.sender][_spender] = _value;
589     emit Approval(msg.sender, _spender, _value);
590     return true;
591   }
592 
593   /**
594    * @dev Function to check the amount of tokens that an owner allowed to a spender.
595    * @param _owner address The address which owns the funds.
596    * @param _spender address The address which will spend the funds.
597    * @return A uint256 specifying the amount of tokens still available for the spender.
598    */
599   function allowance(
600     address _owner,
601     address _spender
602    )
603     public
604     view
605     returns (uint256)
606   {
607     return allowed[_owner][_spender];
608   }
609 
610   /**
611    * @dev Increase the amount of tokens that an owner allowed to a spender.
612    * approve should be called when allowed[_spender] == 0. To increment
613    * allowed value is better to use this function to avoid 2 calls (and wait until
614    * the first transaction is mined)
615    * From MonolithDAO Token.sol
616    * @param _spender The address which will spend the funds.
617    * @param _addedValue The amount of tokens to increase the allowance by.
618    */
619   function increaseApproval(
620     address _spender,
621     uint256 _addedValue
622   )
623     public
624     returns (bool)
625   {
626     allowed[msg.sender][_spender] = (
627       allowed[msg.sender][_spender].add(_addedValue));
628     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
629     return true;
630   }
631 
632   /**
633    * @dev Decrease the amount of tokens that an owner allowed to a spender.
634    * approve should be called when allowed[_spender] == 0. To decrement
635    * allowed value is better to use this function to avoid 2 calls (and wait until
636    * the first transaction is mined)
637    * From MonolithDAO Token.sol
638    * @param _spender The address which will spend the funds.
639    * @param _subtractedValue The amount of tokens to decrease the allowance by.
640    */
641   function decreaseApproval(
642     address _spender,
643     uint256 _subtractedValue
644   )
645     public
646     returns (bool)
647   {
648     uint256 oldValue = allowed[msg.sender][_spender];
649     if (_subtractedValue >= oldValue) {
650       allowed[msg.sender][_spender] = 0;
651     } else {
652       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
653     }
654     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
655     return true;
656   }
657 
658 }
659 
660 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
661 
662 /**
663  * @title Mintable token
664  * @dev Simple ERC20 Token example, with mintable token creation
665  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
666  */
667 contract MintableToken is StandardToken, Ownable {
668   event Mint(address indexed to, uint256 amount);
669   event MintFinished();
670 
671   bool public mintingFinished = false;
672 
673 
674   modifier canMint() {
675     require(!mintingFinished);
676     _;
677   }
678 
679   modifier hasMintPermission() {
680     require(msg.sender == owner);
681     _;
682   }
683 
684   /**
685    * @dev Function to mint tokens
686    * @param _to The address that will receive the minted tokens.
687    * @param _amount The amount of tokens to mint.
688    * @return A boolean that indicates if the operation was successful.
689    */
690   function mint(
691     address _to,
692     uint256 _amount
693   )
694     public
695     hasMintPermission
696     canMint
697     returns (bool)
698   {
699     totalSupply_ = totalSupply_.add(_amount);
700     balances[_to] = balances[_to].add(_amount);
701     emit Mint(_to, _amount);
702     emit Transfer(address(0), _to, _amount);
703     return true;
704   }
705 
706   /**
707    * @dev Function to stop minting new tokens.
708    * @return True if the operation was successful.
709    */
710   function finishMinting() public onlyOwner canMint returns (bool) {
711     mintingFinished = true;
712     emit MintFinished();
713     return true;
714   }
715 }
716 
717 // File: zeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol
718 
719 /**
720  * @title MintedCrowdsale
721  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
722  * Token ownership should be transferred to MintedCrowdsale for minting.
723  */
724 contract MintedCrowdsale is Crowdsale {
725 
726   /**
727    * @dev Overrides delivery by minting tokens upon purchase.
728    * @param _beneficiary Token purchaser
729    * @param _tokenAmount Number of tokens to be minted
730    */
731   function _deliverTokens(
732     address _beneficiary,
733     uint256 _tokenAmount
734   )
735     internal
736   {
737     // Potentially dangerous assumption about the type of the token.
738     require(MintableToken(address(token)).mint(_beneficiary, _tokenAmount));
739   }
740 }
741 
742 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
743 
744 /**
745  * @title Pausable
746  * @dev Base contract which allows children to implement an emergency stop mechanism.
747  */
748 contract Pausable is Ownable {
749   event Pause();
750   event Unpause();
751 
752   bool public paused = false;
753 
754 
755   /**
756    * @dev Modifier to make a function callable only when the contract is not paused.
757    */
758   modifier whenNotPaused() {
759     require(!paused);
760     _;
761   }
762 
763   /**
764    * @dev Modifier to make a function callable only when the contract is paused.
765    */
766   modifier whenPaused() {
767     require(paused);
768     _;
769   }
770 
771   /**
772    * @dev called by the owner to pause, triggers stopped state
773    */
774   function pause() public onlyOwner whenNotPaused {
775     paused = true;
776     emit Pause();
777   }
778 
779   /**
780    * @dev called by the owner to unpause, returns to normal state
781    */
782   function unpause() public onlyOwner whenPaused {
783     paused = false;
784     emit Unpause();
785   }
786 }
787 
788 // File: contracts/RealtyReturnsTokenInterface.sol
789 
790 contract RealtyReturnsTokenInterface {
791     function paused() public;
792     function unpause() public;
793     function finishMinting() public returns (bool);
794 }
795 
796 // File: zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
797 
798 /**
799  * @title Pausable token
800  * @dev StandardToken modified with pausable transfers.
801  **/
802 contract PausableToken is StandardToken, Pausable {
803 
804   function transfer(
805     address _to,
806     uint256 _value
807   )
808     public
809     whenNotPaused
810     returns (bool)
811   {
812     return super.transfer(_to, _value);
813   }
814 
815   function transferFrom(
816     address _from,
817     address _to,
818     uint256 _value
819   )
820     public
821     whenNotPaused
822     returns (bool)
823   {
824     return super.transferFrom(_from, _to, _value);
825   }
826 
827   function approve(
828     address _spender,
829     uint256 _value
830   )
831     public
832     whenNotPaused
833     returns (bool)
834   {
835     return super.approve(_spender, _value);
836   }
837 
838   function increaseApproval(
839     address _spender,
840     uint _addedValue
841   )
842     public
843     whenNotPaused
844     returns (bool success)
845   {
846     return super.increaseApproval(_spender, _addedValue);
847   }
848 
849   function decreaseApproval(
850     address _spender,
851     uint _subtractedValue
852   )
853     public
854     whenNotPaused
855     returns (bool success)
856   {
857     return super.decreaseApproval(_spender, _subtractedValue);
858   }
859 }
860 
861 // File: contracts/RealtyReturnsToken.sol
862 
863 /**
864  * @title Realty Coins contract - ERC20 compatible token contract.
865  * @author Gustavo Guimaraes - <gustavoguimaraes@gmail.com>
866  */
867 contract RealtyReturnsToken is PausableToken, MintableToken {
868     string public constant name = "Realty Returns Token";
869     string public constant symbol = "RRT";
870     uint8 public constant decimals = 18;
871 
872     constructor() public {
873         pause();
874     }
875 }
876 
877 // File: contracts/LockTokenAllocation.sol
878 
879 /**
880  * @title LockTokenAllocation contract
881  */
882 contract LockTokenAllocation is Ownable {
883     using SafeMath for uint;
884     uint256 public unlockedAt;
885     uint256 public canSelfDestruct;
886     uint256 public tokensCreated;
887     uint256 public allocatedTokens;
888     uint256 public totalLockTokenAllocation;
889 
890     mapping (address => uint256) public lockedAllocations;
891 
892     ERC20 public RR;
893 
894     /**
895      * @dev constructor function that sets token, totalLockTokenAllocation, unlock time, and selfdestruct timestamp
896      * for the LockTokenAllocation contract
897      */
898     constructor
899         (
900             ERC20 _token,
901             uint256 _unlockedAt,
902             uint256 _canSelfDestruct,
903             uint256 _totalLockTokenAllocation
904         )
905         public
906     {
907         require(_token != address(0));
908 
909         RR = ERC20(_token);
910         unlockedAt = _unlockedAt;
911         canSelfDestruct = _canSelfDestruct;
912         totalLockTokenAllocation = _totalLockTokenAllocation;
913     }
914 
915     /**
916      * @dev Adds founders' token allocation
917      * @param beneficiary Ethereum address of a person
918      * @param allocationValue Number of tokens allocated to person
919      * @return true if address is correctly added
920      */
921     function addLockTokenAllocation(address beneficiary, uint256 allocationValue)
922         external
923         onlyOwner
924         returns(bool)
925     {
926         require(lockedAllocations[beneficiary] == 0 && beneficiary != address(0)); // can only add once.
927 
928         allocatedTokens = allocatedTokens.add(allocationValue);
929         require(allocatedTokens <= totalLockTokenAllocation);
930 
931         lockedAllocations[beneficiary] = allocationValue;
932         return true;
933     }
934 
935 
936     /**
937      * @dev Allow unlocking of allocated tokens by transferring them to whitelisted addresses.
938      * Need to be called by each address
939      */
940     function unlock() external {
941         require(RR != address(0));
942         assert(now >= unlockedAt);
943 
944         // During first unlock attempt fetch total number of locked tokens.
945         if (tokensCreated == 0) {
946             tokensCreated = RR.balanceOf(this);
947         }
948 
949         uint256 transferAllocation = lockedAllocations[msg.sender];
950         lockedAllocations[msg.sender] = 0;
951 
952         // Will fail if allocation (and therefore toTransfer) is 0.
953         require(RR.transfer(msg.sender, transferAllocation));
954     }
955 
956     /**
957      * @dev allow for selfdestruct possibility and sending funds to owner
958      */
959     function kill() public onlyOwner {
960         require(now >= canSelfDestruct);
961         uint256 balance = RR.balanceOf(this);
962 
963         if (balance > 0) {
964             RR.transfer(msg.sender, balance);
965         }
966 
967         selfdestruct(owner);
968     }
969 }
970 
971 // File: contracts/RealtyReturnsTokenCrowdsale.sol
972 
973 /**
974  * @title Realty Returns Token Crowdsale Contract - crowdsale contract for Realty Returns (RR) tokens.
975  * @author Gustavo Guimaraes - <gustavoguimaraes@gmail.com>
976  */
977 
978 contract RealtyReturnsTokenCrowdsale is FinalizableCrowdsale, MintedCrowdsale, Pausable {
979     uint256 constant public TRESURY_SHARE =              240000000e18;   // 240 M
980     uint256 constant public TEAM_SHARE =                 120000000e18;   // 120 M
981     uint256 constant public FOUNDERS_SHARE =             120000000e18;   // 120 M
982     uint256 constant public NETWORK_SHARE =              530000000e18;   // 530 M
983 
984     uint256 constant public TOTAL_TOKENS_FOR_CROWDSALE = 190000000e18;  // 190 M
985     uint256 public crowdsaleSoftCap =  1321580e18; // approximately 1.3 M
986 
987     address public treasuryWallet;
988     address public teamShare;
989     address public foundersShare;
990     address public networkGrowth;
991 
992     // remainderPurchaser and remainderTokens info saved in the contract
993     // used for reference for contract owner to send refund if any to last purchaser after end of crowdsale
994     address public remainderPurchaser;
995     uint256 public remainderAmount;
996 
997     address public onePercentAddress;
998 
999     event MintedTokensFor(address indexed investor, uint256 tokensPurchased);
1000     event TokenRateChanged(uint256 previousRate, uint256 newRate);
1001 
1002     /**
1003      * @dev Contract constructor function
1004      * @param _openingTime The timestamp of the beginning of the crowdsale
1005      * @param _closingTime Timestamp when the crowdsale will finish
1006      * @param _token REB token address
1007      * @param _rate The token rate per ETH
1008      * @param _wallet Multisig wallet that will hold the crowdsale funds.
1009      * @param _treasuryWallet Ethereum address where bounty tokens will be minted to
1010      * @param _onePercentAddress onePercent Ethereum address
1011      */
1012     constructor
1013         (
1014             uint256 _openingTime,
1015             uint256 _closingTime,
1016             RealtyReturnsToken _token,
1017             uint256 _rate,
1018             address _wallet,
1019             address _treasuryWallet,
1020             address _onePercentAddress
1021         )
1022         public
1023         FinalizableCrowdsale()
1024         Crowdsale(_rate, _wallet, _token)
1025         TimedCrowdsale(_openingTime, _closingTime)
1026     {
1027         require(_treasuryWallet != address(0));
1028         treasuryWallet = _treasuryWallet;
1029         onePercentAddress = _onePercentAddress;
1030 
1031         // NOTE: Ensure token ownership is transferred to crowdsale so it is able to mint tokens
1032         require(RealtyReturnsToken(token).paused());
1033     }
1034 
1035     /**
1036      * @dev change crowdsale rate
1037      * @param newRate Figure that corresponds to the new rate per token
1038      */
1039     function setRate(uint256 newRate) external onlyOwner {
1040         require(newRate != 0);
1041 
1042         emit TokenRateChanged(rate, newRate);
1043         rate = newRate;
1044     }
1045 
1046     /**
1047      * @dev flexible soft cap
1048      * @param newCap Figure that corresponds to the new crowdsale soft cap
1049      */
1050     function setSoftCap(uint256 newCap) external onlyOwner {
1051         require(newCap != 0);
1052 
1053         crowdsaleSoftCap = newCap;
1054     }
1055 
1056     /**
1057      * @dev Mint tokens investors that send fiat for token purchases.
1058      * The send of fiat will be off chain and custom minting happens in this function and it performed by the owner
1059      * @param beneficiaryAddress Address of beneficiary
1060      * @param amountOfTokens Number of tokens to be created
1061      */
1062     function mintTokensFor(address beneficiaryAddress, uint256 amountOfTokens)
1063         public
1064         onlyOwner
1065     {
1066         require(beneficiaryAddress != address(0));
1067         require(token.totalSupply().add(amountOfTokens) <= TOTAL_TOKENS_FOR_CROWDSALE);
1068 
1069         _deliverTokens(beneficiaryAddress, amountOfTokens);
1070         emit MintedTokensFor(beneficiaryAddress, amountOfTokens);
1071     }
1072 
1073     /**
1074      * @dev Set the address which should receive the vested team and founders tokens plus networkGrowth shares on finalization
1075      * @param _teamShare address of team and advisor allocation contract
1076      * @param _foundersShare address of team and advisor allocation contract
1077      * @param _networkGrowth address of networkGrowth contract
1078      */
1079     function setTokenDistributionAddresses
1080         (
1081             address _teamShare,
1082             address _foundersShare,
1083             address _networkGrowth
1084         )
1085         public
1086         onlyOwner
1087     {
1088         // only able to be set once
1089         require(teamShare == address(0x0) && foundersShare == address(0x0) && networkGrowth == address(0x0));
1090         // ensure that the addresses as params to the func are not empty
1091         require(_teamShare != address(0x0) && _foundersShare != address(0x0) && _networkGrowth != address(0x0));
1092 
1093         teamShare = _teamShare;
1094         foundersShare = _foundersShare;
1095         networkGrowth = _networkGrowth;
1096     }
1097 
1098     // overriding TimeCrowdsale#hasClosed to add cap logic
1099     // @return true if crowdsale event has ended
1100     function hasClosed() public view returns (bool) {
1101         if (token.totalSupply() > crowdsaleSoftCap) {
1102             return true;
1103         }
1104 
1105         return super.hasClosed();
1106     }
1107 
1108     /**
1109      * @dev Override validation of an incoming purchase.
1110      * Use require statemens to revert state when conditions are not met. Use super to concatenate validations.
1111      * @param _beneficiary Address performing the token purchase
1112      * @param _weiAmount Value in wei involved in the purchase
1113      */
1114     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount)
1115         internal
1116         whenNotPaused
1117     {
1118         require(_beneficiary != address(0));
1119         require(token.totalSupply() < TOTAL_TOKENS_FOR_CROWDSALE);
1120     }
1121 
1122     /**
1123      * @dev Override to extend the way in which ether is converted to tokens.
1124      * @param _weiAmount Value in wei to be converted into tokens
1125      * @return Number of tokens that can be purchased with the specified _weiAmount
1126      */
1127     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
1128         uint256 tokensAmount = _weiAmount.mul(rate);
1129 
1130         // remainder logic
1131         if (token.totalSupply().add(tokensAmount) > TOTAL_TOKENS_FOR_CROWDSALE) {
1132             tokensAmount = TOTAL_TOKENS_FOR_CROWDSALE.sub(token.totalSupply());
1133             uint256 _weiAmountLocalScope = tokensAmount.div(rate);
1134 
1135             // save info so as to refund purchaser after crowdsale's end
1136             remainderPurchaser = msg.sender;
1137             remainderAmount = _weiAmount.sub(_weiAmountLocalScope);
1138 
1139             // update state here so when it is updated again in buyTokens the weiAmount reflects the remainder logic
1140             if (weiRaised > _weiAmount.add(_weiAmountLocalScope))
1141                 weiRaised = weiRaised.sub(_weiAmount.add(_weiAmountLocalScope));
1142         }
1143 
1144         return tokensAmount;
1145     }
1146 
1147     /**
1148      * @dev Determines how ETH is stored/forwarded on purchases.
1149     */
1150     function _forwardFunds() internal {
1151         // 1% of the purchase to save in different wallet
1152         uint256 onePercentValue = msg.value.div(100);
1153         uint256 valueToTransfer = msg.value.sub(onePercentValue);
1154 
1155         onePercentAddress.transfer(onePercentValue);
1156         wallet.transfer(valueToTransfer);
1157     }
1158 
1159     /**
1160      * @dev finalizes crowdsale
1161      */
1162     function finalization() internal {
1163         // This must have been set manually prior to finalize().
1164         require(teamShare != address(0) && foundersShare != address(0) && networkGrowth != address(0));
1165 
1166         if (TOTAL_TOKENS_FOR_CROWDSALE > token.totalSupply()) {
1167             uint256 remainingTokens = TOTAL_TOKENS_FOR_CROWDSALE.sub(token.totalSupply());
1168             _deliverTokens(wallet, remainingTokens);
1169         }
1170 
1171         // final minting
1172         _deliverTokens(treasuryWallet, TRESURY_SHARE);
1173         _deliverTokens(teamShare, TEAM_SHARE);
1174         _deliverTokens(foundersShare, FOUNDERS_SHARE);
1175         _deliverTokens(networkGrowth, NETWORK_SHARE);
1176 
1177         RealtyReturnsToken(token).finishMinting();
1178         RealtyReturnsToken(token).unpause();
1179         super.finalization();
1180     }
1181 }