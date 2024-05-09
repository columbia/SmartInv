1 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * See https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address _who) public view returns (uint256);
14   function transfer(address _to, uint256 _value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
19 
20 pragma solidity ^0.4.24;
21 
22 
23 
24 /**
25  * @title ERC20 interface
26  * @dev see https://github.com/ethereum/EIPs/issues/20
27  */
28 contract ERC20 is ERC20Basic {
29   function allowance(address _owner, address _spender)
30     public view returns (uint256);
31 
32   function transferFrom(address _from, address _to, uint256 _value)
33     public returns (bool);
34 
35   function approve(address _spender, uint256 _value) public returns (bool);
36   event Approval(
37     address indexed owner,
38     address indexed spender,
39     uint256 value
40   );
41 }
42 
43 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
44 
45 pragma solidity ^0.4.24;
46 
47 
48 /**
49  * @title SafeMath
50  * @dev Math operations with safety checks that throw on error
51  */
52 library SafeMath {
53 
54   /**
55   * @dev Multiplies two numbers, throws on overflow.
56   */
57   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
58     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
59     // benefit is lost if 'b' is also tested.
60     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
61     if (_a == 0) {
62       return 0;
63     }
64 
65     c = _a * _b;
66     assert(c / _a == _b);
67     return c;
68   }
69 
70   /**
71   * @dev Integer division of two numbers, truncating the quotient.
72   */
73   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
74     // assert(_b > 0); // Solidity automatically throws when dividing by 0
75     // uint256 c = _a / _b;
76     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
77     return _a / _b;
78   }
79 
80   /**
81   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
82   */
83   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
84     assert(_b <= _a);
85     return _a - _b;
86   }
87 
88   /**
89   * @dev Adds two numbers, throws on overflow.
90   */
91   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
92     c = _a + _b;
93     assert(c >= _a);
94     return c;
95   }
96 }
97 
98 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
99 
100 pragma solidity ^0.4.24;
101 
102 
103 
104 
105 /**
106  * @title SafeERC20
107  * @dev Wrappers around ERC20 operations that throw on failure.
108  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
109  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
110  */
111 library SafeERC20 {
112   function safeTransfer(
113     ERC20Basic _token,
114     address _to,
115     uint256 _value
116   )
117     internal
118   {
119     require(_token.transfer(_to, _value));
120   }
121 
122   function safeTransferFrom(
123     ERC20 _token,
124     address _from,
125     address _to,
126     uint256 _value
127   )
128     internal
129   {
130     require(_token.transferFrom(_from, _to, _value));
131   }
132 
133   function safeApprove(
134     ERC20 _token,
135     address _spender,
136     uint256 _value
137   )
138     internal
139   {
140     require(_token.approve(_spender, _value));
141   }
142 }
143 
144 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
145 
146 pragma solidity ^0.4.24;
147 
148 
149 
150 
151 
152 /**
153  * @title Crowdsale
154  * @dev Crowdsale is a base contract for managing a token crowdsale,
155  * allowing investors to purchase tokens with ether. This contract implements
156  * such functionality in its most fundamental form and can be extended to provide additional
157  * functionality and/or custom behavior.
158  * The external interface represents the basic interface for purchasing tokens, and conform
159  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
160  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
161  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
162  * behavior.
163  */
164 contract Crowdsale {
165   using SafeMath for uint256;
166   using SafeERC20 for ERC20;
167 
168   // The token being sold
169   ERC20 public token;
170 
171   // Address where funds are collected
172   address public wallet;
173 
174   // How many token units a buyer gets per wei.
175   // The rate is the conversion between wei and the smallest and indivisible token unit.
176   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
177   // 1 wei will give you 1 unit, or 0.001 TOK.
178   uint256 public rate;
179 
180   // Amount of wei raised
181   uint256 public weiRaised;
182 
183   /**
184    * Event for token purchase logging
185    * @param purchaser who paid for the tokens
186    * @param beneficiary who got the tokens
187    * @param value weis paid for purchase
188    * @param amount amount of tokens purchased
189    */
190   event TokenPurchase(
191     address indexed purchaser,
192     address indexed beneficiary,
193     uint256 value,
194     uint256 amount
195   );
196 
197   /**
198    * @param _rate Number of token units a buyer gets per wei
199    * @param _wallet Address where collected funds will be forwarded to
200    * @param _token Address of the token being sold
201    */
202   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
203     require(_rate > 0);
204     require(_wallet != address(0));
205     require(_token != address(0));
206 
207     rate = _rate;
208     wallet = _wallet;
209     token = _token;
210   }
211 
212   // -----------------------------------------
213   // Crowdsale external interface
214   // -----------------------------------------
215 
216   /**
217    * @dev fallback function ***DO NOT OVERRIDE***
218    */
219   function () external payable {
220     buyTokens(msg.sender);
221   }
222 
223   /**
224    * @dev low level token purchase ***DO NOT OVERRIDE***
225    * @param _beneficiary Address performing the token purchase
226    */
227   function buyTokens(address _beneficiary) public payable {
228 
229     uint256 weiAmount = msg.value;
230     _preValidatePurchase(_beneficiary, weiAmount);
231 
232     // calculate token amount to be created
233     uint256 tokens = _getTokenAmount(weiAmount);
234 
235     // update state
236     weiRaised = weiRaised.add(weiAmount);
237 
238     _processPurchase(_beneficiary, tokens);
239     emit TokenPurchase(
240       msg.sender,
241       _beneficiary,
242       weiAmount,
243       tokens
244     );
245 
246     _updatePurchasingState(_beneficiary, weiAmount);
247 
248     _forwardFunds();
249     _postValidatePurchase(_beneficiary, weiAmount);
250   }
251 
252   // -----------------------------------------
253   // Internal interface (extensible)
254   // -----------------------------------------
255 
256   /**
257    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
258    * Example from CappedCrowdsale.sol's _preValidatePurchase method: 
259    *   super._preValidatePurchase(_beneficiary, _weiAmount);
260    *   require(weiRaised.add(_weiAmount) <= cap);
261    * @param _beneficiary Address performing the token purchase
262    * @param _weiAmount Value in wei involved in the purchase
263    */
264   function _preValidatePurchase(
265     address _beneficiary,
266     uint256 _weiAmount
267   )
268     internal
269   {
270     require(_beneficiary != address(0));
271     require(_weiAmount != 0);
272   }
273 
274   /**
275    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
276    * @param _beneficiary Address performing the token purchase
277    * @param _weiAmount Value in wei involved in the purchase
278    */
279   function _postValidatePurchase(
280     address _beneficiary,
281     uint256 _weiAmount
282   )
283     internal
284   {
285     // optional override
286   }
287 
288   /**
289    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
290    * @param _beneficiary Address performing the token purchase
291    * @param _tokenAmount Number of tokens to be emitted
292    */
293   function _deliverTokens(
294     address _beneficiary,
295     uint256 _tokenAmount
296   )
297     internal
298   {
299     token.safeTransfer(_beneficiary, _tokenAmount);
300   }
301 
302   /**
303    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
304    * @param _beneficiary Address receiving the tokens
305    * @param _tokenAmount Number of tokens to be purchased
306    */
307   function _processPurchase(
308     address _beneficiary,
309     uint256 _tokenAmount
310   )
311     internal
312   {
313     _deliverTokens(_beneficiary, _tokenAmount);
314   }
315 
316   /**
317    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
318    * @param _beneficiary Address receiving the tokens
319    * @param _weiAmount Value in wei involved in the purchase
320    */
321   function _updatePurchasingState(
322     address _beneficiary,
323     uint256 _weiAmount
324   )
325     internal
326   {
327     // optional override
328   }
329 
330   /**
331    * @dev Override to extend the way in which ether is converted to tokens.
332    * @param _weiAmount Value in wei to be converted into tokens
333    * @return Number of tokens that can be purchased with the specified _weiAmount
334    */
335   function _getTokenAmount(uint256 _weiAmount)
336     internal view returns (uint256)
337   {
338     return _weiAmount.mul(rate);
339   }
340 
341   /**
342    * @dev Determines how ETH is stored/forwarded on purchases.
343    */
344   function _forwardFunds() internal {
345     wallet.transfer(msg.value);
346   }
347 }
348 
349 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
350 
351 pragma solidity ^0.4.24;
352 
353 
354 
355 
356 /**
357  * @title Basic token
358  * @dev Basic version of StandardToken, with no allowances.
359  */
360 contract BasicToken is ERC20Basic {
361   using SafeMath for uint256;
362 
363   mapping(address => uint256) internal balances;
364 
365   uint256 internal totalSupply_;
366 
367   /**
368   * @dev Total number of tokens in existence
369   */
370   function totalSupply() public view returns (uint256) {
371     return totalSupply_;
372   }
373 
374   /**
375   * @dev Transfer token for a specified address
376   * @param _to The address to transfer to.
377   * @param _value The amount to be transferred.
378   */
379   function transfer(address _to, uint256 _value) public returns (bool) {
380     require(_value <= balances[msg.sender]);
381     require(_to != address(0));
382 
383     balances[msg.sender] = balances[msg.sender].sub(_value);
384     balances[_to] = balances[_to].add(_value);
385     emit Transfer(msg.sender, _to, _value);
386     return true;
387   }
388 
389   /**
390   * @dev Gets the balance of the specified address.
391   * @param _owner The address to query the the balance of.
392   * @return An uint256 representing the amount owned by the passed address.
393   */
394   function balanceOf(address _owner) public view returns (uint256) {
395     return balances[_owner];
396   }
397 
398 }
399 
400 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
401 
402 pragma solidity ^0.4.24;
403 
404 
405 
406 
407 /**
408  * @title Standard ERC20 token
409  *
410  * @dev Implementation of the basic standard token.
411  * https://github.com/ethereum/EIPs/issues/20
412  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
413  */
414 contract StandardToken is ERC20, BasicToken {
415 
416   mapping (address => mapping (address => uint256)) internal allowed;
417 
418 
419   /**
420    * @dev Transfer tokens from one address to another
421    * @param _from address The address which you want to send tokens from
422    * @param _to address The address which you want to transfer to
423    * @param _value uint256 the amount of tokens to be transferred
424    */
425   function transferFrom(
426     address _from,
427     address _to,
428     uint256 _value
429   )
430     public
431     returns (bool)
432   {
433     require(_value <= balances[_from]);
434     require(_value <= allowed[_from][msg.sender]);
435     require(_to != address(0));
436 
437     balances[_from] = balances[_from].sub(_value);
438     balances[_to] = balances[_to].add(_value);
439     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
440     emit Transfer(_from, _to, _value);
441     return true;
442   }
443 
444   /**
445    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
446    * Beware that changing an allowance with this method brings the risk that someone may use both the old
447    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
448    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
449    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
450    * @param _spender The address which will spend the funds.
451    * @param _value The amount of tokens to be spent.
452    */
453   function approve(address _spender, uint256 _value) public returns (bool) {
454     allowed[msg.sender][_spender] = _value;
455     emit Approval(msg.sender, _spender, _value);
456     return true;
457   }
458 
459   /**
460    * @dev Function to check the amount of tokens that an owner allowed to a spender.
461    * @param _owner address The address which owns the funds.
462    * @param _spender address The address which will spend the funds.
463    * @return A uint256 specifying the amount of tokens still available for the spender.
464    */
465   function allowance(
466     address _owner,
467     address _spender
468    )
469     public
470     view
471     returns (uint256)
472   {
473     return allowed[_owner][_spender];
474   }
475 
476   /**
477    * @dev Increase the amount of tokens that an owner allowed to a spender.
478    * approve should be called when allowed[_spender] == 0. To increment
479    * allowed value is better to use this function to avoid 2 calls (and wait until
480    * the first transaction is mined)
481    * From MonolithDAO Token.sol
482    * @param _spender The address which will spend the funds.
483    * @param _addedValue The amount of tokens to increase the allowance by.
484    */
485   function increaseApproval(
486     address _spender,
487     uint256 _addedValue
488   )
489     public
490     returns (bool)
491   {
492     allowed[msg.sender][_spender] = (
493       allowed[msg.sender][_spender].add(_addedValue));
494     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
495     return true;
496   }
497 
498   /**
499    * @dev Decrease the amount of tokens that an owner allowed to a spender.
500    * approve should be called when allowed[_spender] == 0. To decrement
501    * allowed value is better to use this function to avoid 2 calls (and wait until
502    * the first transaction is mined)
503    * From MonolithDAO Token.sol
504    * @param _spender The address which will spend the funds.
505    * @param _subtractedValue The amount of tokens to decrease the allowance by.
506    */
507   function decreaseApproval(
508     address _spender,
509     uint256 _subtractedValue
510   )
511     public
512     returns (bool)
513   {
514     uint256 oldValue = allowed[msg.sender][_spender];
515     if (_subtractedValue >= oldValue) {
516       allowed[msg.sender][_spender] = 0;
517     } else {
518       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
519     }
520     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
521     return true;
522   }
523 
524 }
525 
526 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
527 
528 pragma solidity ^0.4.24;
529 
530 
531 /**
532  * @title Ownable
533  * @dev The Ownable contract has an owner address, and provides basic authorization control
534  * functions, this simplifies the implementation of "user permissions".
535  */
536 contract Ownable {
537   address public owner;
538 
539 
540   event OwnershipRenounced(address indexed previousOwner);
541   event OwnershipTransferred(
542     address indexed previousOwner,
543     address indexed newOwner
544   );
545 
546 
547   /**
548    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
549    * account.
550    */
551   constructor() public {
552     owner = msg.sender;
553   }
554 
555   /**
556    * @dev Throws if called by any account other than the owner.
557    */
558   modifier onlyOwner() {
559     require(msg.sender == owner);
560     _;
561   }
562 
563   /**
564    * @dev Allows the current owner to relinquish control of the contract.
565    * @notice Renouncing to ownership will leave the contract without an owner.
566    * It will not be possible to call the functions with the `onlyOwner`
567    * modifier anymore.
568    */
569   function renounceOwnership() public onlyOwner {
570     emit OwnershipRenounced(owner);
571     owner = address(0);
572   }
573 
574   /**
575    * @dev Allows the current owner to transfer control of the contract to a newOwner.
576    * @param _newOwner The address to transfer ownership to.
577    */
578   function transferOwnership(address _newOwner) public onlyOwner {
579     _transferOwnership(_newOwner);
580   }
581 
582   /**
583    * @dev Transfers control of the contract to a newOwner.
584    * @param _newOwner The address to transfer ownership to.
585    */
586   function _transferOwnership(address _newOwner) internal {
587     require(_newOwner != address(0));
588     emit OwnershipTransferred(owner, _newOwner);
589     owner = _newOwner;
590   }
591 }
592 
593 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
594 
595 pragma solidity ^0.4.24;
596 
597 
598 
599 
600 /**
601  * @title Mintable token
602  * @dev Simple ERC20 Token example, with mintable token creation
603  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
604  */
605 contract MintableToken is StandardToken, Ownable {
606   event Mint(address indexed to, uint256 amount);
607   event MintFinished();
608 
609   bool public mintingFinished = false;
610 
611 
612   modifier canMint() {
613     require(!mintingFinished);
614     _;
615   }
616 
617   modifier hasMintPermission() {
618     require(msg.sender == owner);
619     _;
620   }
621 
622   /**
623    * @dev Function to mint tokens
624    * @param _to The address that will receive the minted tokens.
625    * @param _amount The amount of tokens to mint.
626    * @return A boolean that indicates if the operation was successful.
627    */
628   function mint(
629     address _to,
630     uint256 _amount
631   )
632     public
633     hasMintPermission
634     canMint
635     returns (bool)
636   {
637     totalSupply_ = totalSupply_.add(_amount);
638     balances[_to] = balances[_to].add(_amount);
639     emit Mint(_to, _amount);
640     emit Transfer(address(0), _to, _amount);
641     return true;
642   }
643 
644   /**
645    * @dev Function to stop minting new tokens.
646    * @return True if the operation was successful.
647    */
648   function finishMinting() public onlyOwner canMint returns (bool) {
649     mintingFinished = true;
650     emit MintFinished();
651     return true;
652   }
653 }
654 
655 // File: openzeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol
656 
657 pragma solidity ^0.4.24;
658 
659 
660 
661 
662 /**
663  * @title MintedCrowdsale
664  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
665  * Token ownership should be transferred to MintedCrowdsale for minting.
666  */
667 contract MintedCrowdsale is Crowdsale {
668 
669   /**
670    * @dev Overrides delivery by minting tokens upon purchase.
671    * @param _beneficiary Token purchaser
672    * @param _tokenAmount Number of tokens to be minted
673    */
674   function _deliverTokens(
675     address _beneficiary,
676     uint256 _tokenAmount
677   )
678     internal
679   {
680     // Potentially dangerous assumption about the type of the token.
681     require(MintableToken(address(token)).mint(_beneficiary, _tokenAmount));
682   }
683 }
684 
685 // File: openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
686 
687 pragma solidity ^0.4.24;
688 
689 
690 
691 
692 /**
693  * @title CappedCrowdsale
694  * @dev Crowdsale with a limit for total contributions.
695  */
696 contract CappedCrowdsale is Crowdsale {
697   using SafeMath for uint256;
698 
699   uint256 public cap;
700 
701   /**
702    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
703    * @param _cap Max amount of wei to be contributed
704    */
705   constructor(uint256 _cap) public {
706     require(_cap > 0);
707     cap = _cap;
708   }
709 
710   /**
711    * @dev Checks whether the cap has been reached.
712    * @return Whether the cap was reached
713    */
714   function capReached() public view returns (bool) {
715     return weiRaised >= cap;
716   }
717 
718   /**
719    * @dev Extend parent behavior requiring purchase to respect the funding cap.
720    * @param _beneficiary Token purchaser
721    * @param _weiAmount Amount of wei contributed
722    */
723   function _preValidatePurchase(
724     address _beneficiary,
725     uint256 _weiAmount
726   )
727     internal
728   {
729     super._preValidatePurchase(_beneficiary, _weiAmount);
730     require(weiRaised.add(_weiAmount) <= cap);
731   }
732 
733 }
734 
735 // File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
736 
737 pragma solidity ^0.4.24;
738 
739 
740 
741 
742 /**
743  * @title TimedCrowdsale
744  * @dev Crowdsale accepting contributions only within a time frame.
745  */
746 contract TimedCrowdsale is Crowdsale {
747   using SafeMath for uint256;
748 
749   uint256 public openingTime;
750   uint256 public closingTime;
751 
752   /**
753    * @dev Reverts if not in crowdsale time range.
754    */
755   modifier onlyWhileOpen {
756     // solium-disable-next-line security/no-block-members
757     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
758     _;
759   }
760 
761   /**
762    * @dev Constructor, takes crowdsale opening and closing times.
763    * @param _openingTime Crowdsale opening time
764    * @param _closingTime Crowdsale closing time
765    */
766   constructor(uint256 _openingTime, uint256 _closingTime) public {
767     // solium-disable-next-line security/no-block-members
768     require(_openingTime >= block.timestamp);
769     require(_closingTime >= _openingTime);
770 
771     openingTime = _openingTime;
772     closingTime = _closingTime;
773   }
774 
775   /**
776    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
777    * @return Whether crowdsale period has elapsed
778    */
779   function hasClosed() public view returns (bool) {
780     // solium-disable-next-line security/no-block-members
781     return block.timestamp > closingTime;
782   }
783 
784   /**
785    * @dev Extend parent behavior requiring to be within contributing period
786    * @param _beneficiary Token purchaser
787    * @param _weiAmount Amount of wei contributed
788    */
789   function _preValidatePurchase(
790     address _beneficiary,
791     uint256 _weiAmount
792   )
793     internal
794     onlyWhileOpen
795   {
796     super._preValidatePurchase(_beneficiary, _weiAmount);
797   }
798 
799 }
800 
801 // File: openzeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol
802 
803 pragma solidity ^0.4.24;
804 
805 
806 
807 
808 
809 /**
810  * @title FinalizableCrowdsale
811  * @dev Extension of Crowdsale where an owner can do extra work
812  * after finishing.
813  */
814 contract FinalizableCrowdsale is Ownable, TimedCrowdsale {
815   using SafeMath for uint256;
816 
817   bool public isFinalized = false;
818 
819   event Finalized();
820 
821   /**
822    * @dev Must be called after crowdsale ends, to do some extra finalization
823    * work. Calls the contract's finalization function.
824    */
825   function finalize() public onlyOwner {
826     require(!isFinalized);
827     require(hasClosed());
828 
829     finalization();
830     emit Finalized();
831 
832     isFinalized = true;
833   }
834 
835   /**
836    * @dev Can be overridden to add finalization logic. The overriding function
837    * should call super.finalization() to ensure the chain of finalization is
838    * executed entirely.
839    */
840   function finalization() internal {
841   }
842 
843 }
844 
845 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
846 
847 pragma solidity ^0.4.24;
848 
849 
850 
851 /**
852  * @title Pausable
853  * @dev Base contract which allows children to implement an emergency stop mechanism.
854  */
855 contract Pausable is Ownable {
856   event Pause();
857   event Unpause();
858 
859   bool public paused = false;
860 
861 
862   /**
863    * @dev Modifier to make a function callable only when the contract is not paused.
864    */
865   modifier whenNotPaused() {
866     require(!paused);
867     _;
868   }
869 
870   /**
871    * @dev Modifier to make a function callable only when the contract is paused.
872    */
873   modifier whenPaused() {
874     require(paused);
875     _;
876   }
877 
878   /**
879    * @dev called by the owner to pause, triggers stopped state
880    */
881   function pause() public onlyOwner whenNotPaused {
882     paused = true;
883     emit Pause();
884   }
885 
886   /**
887    * @dev called by the owner to unpause, returns to normal state
888    */
889   function unpause() public onlyOwner whenPaused {
890     paused = false;
891     emit Unpause();
892   }
893 }
894 
895 // File: contracts/ATFCrowdSale.sol
896 
897 pragma solidity ^0.4.24;
898 
899 
900 
901 
902 
903 
904 contract ATFCrowdsale is MintedCrowdsale, CappedCrowdsale, Ownable {
905 
906     struct CustomContract {
907         bool isReferral;
908         bool isSpecial;
909         address referralAddress;
910     }
911 
912     // ICO Stage
913     // ============
914     enum CrowdsaleStage { PrivateICO, PreICO, ICO }
915     CrowdsaleStage public stage = CrowdsaleStage.PrivateICO;
916     // =============
917 
918     // Token Distribution
919     // =============================
920     uint256 public maxTokens = 300000000 * 10**18; // There will be total 300,000,000 Tokens
921     uint256 public tokensForEcosystem = 120000000 * 10**18;//40%
922     uint256 public tokensForTeam = 15000000 * 10**18; //5%
923     uint256 public tokensForBounty = 15000000 * 10**18;//5%
924     uint256 public tokensForMarketing = 30000000 * 10**18; //10%
925     uint256 public tokensForOperations = 30000000 * 10**18;//10%
926     uint256 public totalTokensForSale = 90000000 * 10**18; // 30%
927     // ==============================
928 
929     //minimum investor Contribution - 100000000000000000
930     //minimum investor Contribution - 5000000000000000000000
931     uint256 public investorMinCap = 1000000000000000000;
932     uint256 public investorHardCap = 5000000000000000000000;
933 
934     mapping(address => uint256) public contributions;
935 
936     // customBonuses
937     mapping (address => CustomContract) public customBonuses;
938 
939     // Manual kill switch
940     bool crowdsaleConcluded = false;
941 
942     constructor(uint256 _rate,
943         address _wallet,
944         ERC20 _token,
945         uint256 _cap)
946     Crowdsale(_rate, _wallet, _token)
947     CappedCrowdsale(_cap)
948     Ownable()
949     public{
950     }
951 
952 
953     function _preValidatePurchase(
954         address _beneficiary,
955         uint256 _weiAmount
956     )
957     internal
958     {
959         require(!hasEnded());
960         super._preValidatePurchase(_beneficiary, _weiAmount);
961         uint256 _existingContribution = contributions[_beneficiary];
962         uint256 _newContribution = _existingContribution.add(_weiAmount);
963         require(_weiAmount >= investorMinCap && _weiAmount <= investorHardCap);
964         contributions[_beneficiary] = _newContribution;
965     }
966 
967     // Override this method to have a way to add business logic to your crowdsale when buying
968     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
969         uint256 tokens = getBaseAmount(_weiAmount);
970         uint256 percentage = 0;
971 
972          // Special bonuses
973         if (customBonuses[msg.sender].isSpecial == true) {
974             percentage = 40;
975 
976         // Regular bonuses
977         } else {
978 
979           if ( stage == CrowdsaleStage.PrivateICO ) {
980             percentage = 40;
981           } else if ( stage == CrowdsaleStage.PreICO ) {
982             percentage = 20;
983           } else if ( stage == CrowdsaleStage.ICO) {
984             // Large contributors
985             if (msg.value >= 100 ether) {
986               percentage = 20;
987             } else if (msg.value >= 50 ether) {
988               percentage = 10;
989             } else if (msg.value >= 10 ether) {
990               percentage = 5;
991             }
992           }
993 
994         }
995 
996         tokens += tokens.mul(percentage).div(100);
997 
998         assert(tokens > 0);
999 
1000         return (tokens);
1001     }
1002 
1003     // Change Crowdsale Stage. Available Options: PrivateICO, PreICO, ICO
1004     function setCrowdsaleStage(uint value) onlyOwner public  {
1005 
1006         CrowdsaleStage _stage;
1007 
1008         if (uint(CrowdsaleStage.PrivateICO) == value) {
1009           _stage = CrowdsaleStage.PrivateICO;
1010         } else if (uint(CrowdsaleStage.PreICO) == value) {
1011           _stage = CrowdsaleStage.PreICO;
1012         } else if (uint(CrowdsaleStage.ICO) == value) {
1013           _stage = CrowdsaleStage.ICO;
1014         }
1015 
1016         stage = _stage;
1017     }
1018 
1019     function setCustomBonus(address _contract, bool _isReferral, bool _isSpecial, address _referralAddress) onlyOwner public {
1020       require(_contract != address(0));
1021 
1022       customBonuses[_contract] = CustomContract({
1023           isReferral: _isReferral,
1024           isSpecial: _isSpecial,
1025           referralAddress: _referralAddress
1026       });
1027     }
1028 
1029     function getBaseAmount(uint256 _weiAmount) public view returns (uint256) {
1030         return _weiAmount.mul(rate);
1031     }
1032 
1033     // ===========================
1034 
1035     // Finish: Mint Extra Tokens as needed before finalizing the Crowdsale.
1036     // ====================================================================
1037 
1038     function finish(address _teamFund, address _ecosystemFund, address _bountyFund, address _operationsFund) public onlyOwner {
1039 
1040         require(!hasEnded());
1041         uint256 alreadyMinted = token.totalSupply();
1042         require(alreadyMinted < maxTokens);
1043 
1044         uint256 unsoldTokens = totalTokensForSale.add(tokensForMarketing).sub(alreadyMinted);
1045         if (unsoldTokens > 0) {
1046           tokensForEcosystem = tokensForEcosystem.add(unsoldTokens);
1047         }
1048 
1049         MintableToken(address(token)).mint(_teamFund,tokensForTeam);
1050         MintableToken(address(token)).mint(_ecosystemFund,tokensForEcosystem);
1051         MintableToken(address(token)).mint(_bountyFund,tokensForBounty);
1052         MintableToken(address(token)).mint(_operationsFund,tokensForOperations);
1053 
1054         endSale();
1055     }
1056 
1057     // @return true if crowdsale event has ended
1058     function hasEnded() public view returns (bool) {
1059         return crowdsaleConcluded;
1060     }
1061 
1062     /**
1063      * End crowdsale manually
1064      */
1065 
1066     function endSale() onlyOwner internal {
1067       // close crowdsale
1068       crowdsaleConcluded = true;
1069       MintableToken(address(token)).transferOwnership(msg.sender);
1070 
1071     }
1072 
1073 
1074 
1075 
1076 }