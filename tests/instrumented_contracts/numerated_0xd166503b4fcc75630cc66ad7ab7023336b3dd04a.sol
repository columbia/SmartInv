1 pragma solidity ^0.4.21;
2 
3 // ----------------- 
4 //begin SafeMath.sol
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
17     // benefit is lost if 'b' is also tested.
18     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19     if (a == 0) {
20       return 0;
21     }
22 
23     c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers, truncating the quotient.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     // uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return a / b;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45 
46   /**
47   * @dev Adds two numbers, throws on overflow.
48   */
49   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
50     c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 }
55 
56 //end SafeMath.sol
57 // ----------------- 
58 //begin Ownable.sol
59 
60 /**
61  * @title Ownable
62  * @dev The Ownable contract has an owner address, and provides basic authorization control
63  * functions, this simplifies the implementation of "user permissions".
64  */
65 contract Ownable {
66   address public owner;
67 
68 
69   event OwnershipRenounced(address indexed previousOwner);
70   event OwnershipTransferred(
71     address indexed previousOwner,
72     address indexed newOwner
73   );
74 
75 
76   /**
77    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
78    * account.
79    */
80   constructor() public {
81     owner = msg.sender;
82   }
83 
84   /**
85    * @dev Throws if called by any account other than the owner.
86    */
87   modifier onlyOwner() {
88     require(msg.sender == owner);
89     _;
90   }
91 
92   /**
93    * @dev Allows the current owner to relinquish control of the contract.
94    * @notice Renouncing to ownership will leave the contract without an owner.
95    * It will not be possible to call the functions with the `onlyOwner`
96    * modifier anymore.
97    */
98   function renounceOwnership() public onlyOwner {
99     emit OwnershipRenounced(owner);
100     owner = address(0);
101   }
102 
103   /**
104    * @dev Allows the current owner to transfer control of the contract to a newOwner.
105    * @param _newOwner The address to transfer ownership to.
106    */
107   function transferOwnership(address _newOwner) public onlyOwner {
108     _transferOwnership(_newOwner);
109   }
110 
111   /**
112    * @dev Transfers control of the contract to a newOwner.
113    * @param _newOwner The address to transfer ownership to.
114    */
115   function _transferOwnership(address _newOwner) internal {
116     require(_newOwner != address(0));
117     emit OwnershipTransferred(owner, _newOwner);
118     owner = _newOwner;
119   }
120 }
121 
122 //end Ownable.sol
123 // ----------------- 
124 //begin ERC20Basic.sol
125 
126 /**
127  * @title ERC20Basic
128  * @dev Simpler version of ERC20 interface
129  * See https://github.com/ethereum/EIPs/issues/179
130  */
131 contract ERC20Basic {
132   function totalSupply() public view returns (uint256);
133   function balanceOf(address who) public view returns (uint256);
134   function transfer(address to, uint256 value) public returns (bool);
135   event Transfer(address indexed from, address indexed to, uint256 value);
136 }
137 
138 //end ERC20Basic.sol
139 // ----------------- 
140 //begin Pausable.sol
141 
142 
143 
144 /**
145  * @title Pausable
146  * @dev Base contract which allows children to implement an emergency stop mechanism.
147  */
148 contract Pausable is Ownable {
149   event Pause();
150   event Unpause();
151 
152   bool public paused = false;
153 
154 
155   /**
156    * @dev Modifier to make a function callable only when the contract is not paused.
157    */
158   modifier whenNotPaused() {
159     require(!paused);
160     _;
161   }
162 
163   /**
164    * @dev Modifier to make a function callable only when the contract is paused.
165    */
166   modifier whenPaused() {
167     require(paused);
168     _;
169   }
170 
171   /**
172    * @dev called by the owner to pause, triggers stopped state
173    */
174   function pause() onlyOwner whenNotPaused public {
175     paused = true;
176     emit Pause();
177   }
178 
179   /**
180    * @dev called by the owner to unpause, returns to normal state
181    */
182   function unpause() onlyOwner whenPaused public {
183     paused = false;
184     emit Unpause();
185   }
186 }
187 
188 //end Pausable.sol
189 // ----------------- 
190 //begin ERC20.sol
191 
192 
193 /**
194  * @title ERC20 interface
195  * @dev see https://github.com/ethereum/EIPs/issues/20
196  */
197 contract ERC20 is ERC20Basic {
198   function allowance(address owner, address spender)
199     public view returns (uint256);
200 
201   function transferFrom(address from, address to, uint256 value)
202     public returns (bool);
203 
204   function approve(address spender, uint256 value) public returns (bool);
205   event Approval(
206     address indexed owner,
207     address indexed spender,
208     uint256 value
209   );
210 }
211 
212 //end ERC20.sol
213 // ----------------- 
214 //begin BasicToken.sol
215 
216 
217 
218 /**
219  * @title Basic token
220  * @dev Basic version of StandardToken, with no allowances.
221  */
222 contract BasicToken is ERC20Basic {
223   using SafeMath for uint256;
224 
225   mapping(address => uint256) balances;
226 
227   uint256 totalSupply_;
228 
229   /**
230   * @dev Total number of tokens in existence
231   */
232   function totalSupply() public view returns (uint256) {
233     return totalSupply_;
234   }
235 
236   /**
237   * @dev Transfer token for a specified address
238   * @param _to The address to transfer to.
239   * @param _value The amount to be transferred.
240   */
241   function transfer(address _to, uint256 _value) public returns (bool) {
242     require(_to != address(0));
243     require(_value <= balances[msg.sender]);
244 
245     balances[msg.sender] = balances[msg.sender].sub(_value);
246     balances[_to] = balances[_to].add(_value);
247     emit Transfer(msg.sender, _to, _value);
248     return true;
249   }
250 
251   /**
252   * @dev Gets the balance of the specified address.
253   * @param _owner The address to query the the balance of.
254   * @return An uint256 representing the amount owned by the passed address.
255   */
256   function balanceOf(address _owner) public view returns (uint256) {
257     return balances[_owner];
258   }
259 
260 }
261 
262 //end BasicToken.sol
263 // ----------------- 
264 //begin StandardToken.sol
265 
266 
267 /**
268  * @title Standard ERC20 token
269  *
270  * @dev Implementation of the basic standard token.
271  * https://github.com/ethereum/EIPs/issues/20
272  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
273  */
274 contract StandardToken is ERC20, BasicToken {
275 
276   mapping (address => mapping (address => uint256)) internal allowed;
277 
278 
279   /**
280    * @dev Transfer tokens from one address to another
281    * @param _from address The address which you want to send tokens from
282    * @param _to address The address which you want to transfer to
283    * @param _value uint256 the amount of tokens to be transferred
284    */
285   function transferFrom(
286     address _from,
287     address _to,
288     uint256 _value
289   )
290     public
291     returns (bool)
292   {
293     require(_to != address(0));
294     require(_value <= balances[_from]);
295     require(_value <= allowed[_from][msg.sender]);
296 
297     balances[_from] = balances[_from].sub(_value);
298     balances[_to] = balances[_to].add(_value);
299     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
300     emit Transfer(_from, _to, _value);
301     return true;
302   }
303 
304   /**
305    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
306    * Beware that changing an allowance with this method brings the risk that someone may use both the old
307    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
308    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
309    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
310    * @param _spender The address which will spend the funds.
311    * @param _value The amount of tokens to be spent.
312    */
313   function approve(address _spender, uint256 _value) public returns (bool) {
314     allowed[msg.sender][_spender] = _value;
315     emit Approval(msg.sender, _spender, _value);
316     return true;
317   }
318 
319   /**
320    * @dev Function to check the amount of tokens that an owner allowed to a spender.
321    * @param _owner address The address which owns the funds.
322    * @param _spender address The address which will spend the funds.
323    * @return A uint256 specifying the amount of tokens still available for the spender.
324    */
325   function allowance(
326     address _owner,
327     address _spender
328    )
329     public
330     view
331     returns (uint256)
332   {
333     return allowed[_owner][_spender];
334   }
335 
336   /**
337    * @dev Increase the amount of tokens that an owner allowed to a spender.
338    * approve should be called when allowed[_spender] == 0. To increment
339    * allowed value is better to use this function to avoid 2 calls (and wait until
340    * the first transaction is mined)
341    * From MonolithDAO Token.sol
342    * @param _spender The address which will spend the funds.
343    * @param _addedValue The amount of tokens to increase the allowance by.
344    */
345   function increaseApproval(
346     address _spender,
347     uint256 _addedValue
348   )
349     public
350     returns (bool)
351   {
352     allowed[msg.sender][_spender] = (
353       allowed[msg.sender][_spender].add(_addedValue));
354     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
355     return true;
356   }
357 
358   /**
359    * @dev Decrease the amount of tokens that an owner allowed to a spender.
360    * approve should be called when allowed[_spender] == 0. To decrement
361    * allowed value is better to use this function to avoid 2 calls (and wait until
362    * the first transaction is mined)
363    * From MonolithDAO Token.sol
364    * @param _spender The address which will spend the funds.
365    * @param _subtractedValue The amount of tokens to decrease the allowance by.
366    */
367   function decreaseApproval(
368     address _spender,
369     uint256 _subtractedValue
370   )
371     public
372     returns (bool)
373   {
374     uint256 oldValue = allowed[msg.sender][_spender];
375     if (_subtractedValue > oldValue) {
376       allowed[msg.sender][_spender] = 0;
377     } else {
378       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
379     }
380     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
381     return true;
382   }
383 
384 }
385 
386 //end StandardToken.sol
387 // ----------------- 
388 //begin SafeERC20.sol
389 
390 
391 /**
392  * @title SafeERC20
393  * @dev Wrappers around ERC20 operations that throw on failure.
394  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
395  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
396  */
397 library SafeERC20 {
398   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
399     require(token.transfer(to, value));
400   }
401 
402   function safeTransferFrom(
403     ERC20 token,
404     address from,
405     address to,
406     uint256 value
407   )
408     internal
409   {
410     require(token.transferFrom(from, to, value));
411   }
412 
413   function safeApprove(ERC20 token, address spender, uint256 value) internal {
414     require(token.approve(spender, value));
415   }
416 }
417 
418 //end SafeERC20.sol
419 // ----------------- 
420 //begin PausableToken.sol
421 
422 
423 /**
424  * @title Pausable token
425  * @dev StandardToken modified with pausable transfers.
426  **/
427 contract PausableToken is StandardToken, Pausable {
428 
429   function transfer(
430     address _to,
431     uint256 _value
432   )
433     public
434     whenNotPaused
435     returns (bool)
436   {
437     return super.transfer(_to, _value);
438   }
439 
440   function transferFrom(
441     address _from,
442     address _to,
443     uint256 _value
444   )
445     public
446     whenNotPaused
447     returns (bool)
448   {
449     return super.transferFrom(_from, _to, _value);
450   }
451 
452   function approve(
453     address _spender,
454     uint256 _value
455   )
456     public
457     whenNotPaused
458     returns (bool)
459   {
460     return super.approve(_spender, _value);
461   }
462 
463   function increaseApproval(
464     address _spender,
465     uint _addedValue
466   )
467     public
468     whenNotPaused
469     returns (bool success)
470   {
471     return super.increaseApproval(_spender, _addedValue);
472   }
473 
474   function decreaseApproval(
475     address _spender,
476     uint _subtractedValue
477   )
478     public
479     whenNotPaused
480     returns (bool success)
481   {
482     return super.decreaseApproval(_spender, _subtractedValue);
483   }
484 }
485 
486 //end PausableToken.sol
487 // ----------------- 
488 //begin Crowdsale.sol
489 
490 
491 /**
492  * @title Crowdsale
493  * @dev Crowdsale is a base contract for managing a token crowdsale,
494  * allowing investors to purchase tokens with ether. This contract implements
495  * such functionality in its most fundamental form and can be extended to provide additional
496  * functionality and/or custom behavior.
497  * The external interface represents the basic interface for purchasing tokens, and conform
498  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
499  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
500  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
501  * behavior.
502  */
503 contract Crowdsale {
504   using SafeMath for uint256;
505   using SafeERC20 for ERC20;
506 
507   // The token being sold
508   ERC20 public token;
509 
510   // Address where funds are collected
511   address public wallet;
512 
513   // How many token units a buyer gets per wei.
514   // The rate is the conversion between wei and the smallest and indivisible token unit.
515   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
516   // 1 wei will give you 1 unit, or 0.001 TOK.
517   uint256 public rate;
518 
519   // Amount of wei raised
520   uint256 public weiRaised;
521 
522   /**
523    * Event for token purchase logging
524    * @param purchaser who paid for the tokens
525    * @param beneficiary who got the tokens
526    * @param value weis paid for purchase
527    * @param amount amount of tokens purchased
528    */
529   event TokenPurchase(
530     address indexed purchaser,
531     address indexed beneficiary,
532     uint256 value,
533     uint256 amount
534   );
535 
536   /**
537    * @param _rate Number of token units a buyer gets per wei
538    * @param _wallet Address where collected funds will be forwarded to
539    * @param _token Address of the token being sold
540    */
541   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
542     require(_rate > 0);
543     require(_wallet != address(0));
544     require(_token != address(0));
545 
546     rate = _rate;
547     wallet = _wallet;
548     token = _token;
549   }
550 
551   // -----------------------------------------
552   // Crowdsale external interface
553   // -----------------------------------------
554 
555   /**
556    * @dev fallback function ***DO NOT OVERRIDE***
557    */
558   function () external payable {
559     buyTokens(msg.sender);
560   }
561 
562   /**
563    * @dev low level token purchase ***DO NOT OVERRIDE***
564    * @param _beneficiary Address performing the token purchase
565    */
566   function buyTokens(address _beneficiary) public payable {
567 
568     uint256 weiAmount = msg.value;
569     _preValidatePurchase(_beneficiary, weiAmount);
570 
571     // calculate token amount to be created
572     uint256 tokens = _getTokenAmount(weiAmount);
573 
574     // update state
575     weiRaised = weiRaised.add(weiAmount);
576 
577     _processPurchase(_beneficiary, tokens);
578     emit TokenPurchase(
579       msg.sender,
580       _beneficiary,
581       weiAmount,
582       tokens
583     );
584 
585     _updatePurchasingState(_beneficiary, weiAmount);
586 
587     _forwardFunds();
588     _postValidatePurchase(_beneficiary, weiAmount);
589   }
590 
591   // -----------------------------------------
592   // Internal interface (extensible)
593   // -----------------------------------------
594 
595   /**
596    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
597    * @param _beneficiary Address performing the token purchase
598    * @param _weiAmount Value in wei involved in the purchase
599    */
600   function _preValidatePurchase(
601     address _beneficiary,
602     uint256 _weiAmount
603   )
604     internal
605   {
606     require(_beneficiary != address(0));
607     require(_weiAmount != 0);
608   }
609 
610   /**
611    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
612    * @param _beneficiary Address performing the token purchase
613    * @param _weiAmount Value in wei involved in the purchase
614    */
615   function _postValidatePurchase(
616     address _beneficiary,
617     uint256 _weiAmount
618   )
619     internal
620   {
621     // optional override
622   }
623 
624   /**
625    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
626    * @param _beneficiary Address performing the token purchase
627    * @param _tokenAmount Number of tokens to be emitted
628    */
629   function _deliverTokens(
630     address _beneficiary,
631     uint256 _tokenAmount
632   )
633     internal
634   {
635     token.safeTransfer(_beneficiary, _tokenAmount);
636   }
637 
638   /**
639    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
640    * @param _beneficiary Address receiving the tokens
641    * @param _tokenAmount Number of tokens to be purchased
642    */
643   function _processPurchase(
644     address _beneficiary,
645     uint256 _tokenAmount
646   )
647     internal
648   {
649     _deliverTokens(_beneficiary, _tokenAmount);
650   }
651 
652   /**
653    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
654    * @param _beneficiary Address receiving the tokens
655    * @param _weiAmount Value in wei involved in the purchase
656    */
657   function _updatePurchasingState(
658     address _beneficiary,
659     uint256 _weiAmount
660   )
661     internal
662   {
663     // optional override
664   }
665 
666   /**
667    * @dev Override to extend the way in which ether is converted to tokens.
668    * @param _weiAmount Value in wei to be converted into tokens
669    * @return Number of tokens that can be purchased with the specified _weiAmount
670    */
671   function _getTokenAmount(uint256 _weiAmount)
672     internal view returns (uint256)
673   {
674     return _weiAmount.mul(rate);
675   }
676 
677   /**
678    * @dev Determines how ETH is stored/forwarded on purchases.
679    */
680   function _forwardFunds() internal {
681     wallet.transfer(msg.value);
682   }
683 }
684 //end Crowdsale.sol
685 // ----------------- 
686 //begin MintableToken.sol
687 
688 
689 /**
690  * @title Mintable token
691  * @dev Simple ERC20 Token example, with mintable token creation
692  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
693  */
694 contract MintableToken is StandardToken, Ownable {
695   event Mint(address indexed to, uint256 amount);
696   event MintFinished();
697 
698   bool public mintingFinished = false;
699 
700 
701   modifier canMint() {
702     require(!mintingFinished);
703     _;
704   }
705 
706   modifier hasMintPermission() {
707     require(msg.sender == owner);
708     _;
709   }
710 
711   /**
712    * @dev Function to mint tokens
713    * @param _to The address that will receive the minted tokens.
714    * @param _amount The amount of tokens to mint.
715    * @return A boolean that indicates if the operation was successful.
716    */
717   function mint(
718     address _to,
719     uint256 _amount
720   )
721     hasMintPermission
722     canMint
723     public
724     returns (bool)
725   {
726     totalSupply_ = totalSupply_.add(_amount);
727     balances[_to] = balances[_to].add(_amount);
728     emit Mint(_to, _amount);
729     emit Transfer(address(0), _to, _amount);
730     return true;
731   }
732 
733   /**
734    * @dev Function to stop minting new tokens.
735    * @return True if the operation was successful.
736    */
737   function finishMinting() onlyOwner canMint public returns (bool) {
738     mintingFinished = true;
739     emit MintFinished();
740     return true;
741   }
742 }
743 
744 //end MintableToken.sol
745 // ----------------- 
746 //begin MintedCrowdsale.sol
747 
748 
749 /**
750  * @title MintedCrowdsale
751  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
752  * Token ownership should be transferred to MintedCrowdsale for minting.
753  */
754 contract MintedCrowdsale is Crowdsale {
755 
756   /**
757    * @dev Overrides delivery by minting tokens upon purchase.
758    * @param _beneficiary Token purchaser
759    * @param _tokenAmount Number of tokens to be minted
760    */
761   function _deliverTokens(
762     address _beneficiary,
763     uint256 _tokenAmount
764   )
765     internal
766   {
767     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
768   }
769 }
770 
771 //end MintedCrowdsale.sol
772 // ----------------- 
773 //begin TimedCrowdsale.sol
774 
775 
776 /**
777  * @title TimedCrowdsale
778  * @dev Crowdsale accepting contributions only within a time frame.
779  */
780 contract TimedCrowdsale is Crowdsale {
781   using SafeMath for uint256;
782 
783   uint256 public openingTime;
784   uint256 public closingTime;
785 
786   /**
787    * @dev Reverts if not in crowdsale time range.
788    */
789   modifier onlyWhileOpen {
790     // solium-disable-next-line security/no-block-members
791     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
792     _;
793   }
794 
795   /**
796    * @dev Constructor, takes crowdsale opening and closing times.
797    * @param _openingTime Crowdsale opening time
798    * @param _closingTime Crowdsale closing time
799    */
800   constructor(uint256 _openingTime, uint256 _closingTime) public {
801     // solium-disable-next-line security/no-block-members
802     require(_openingTime >= block.timestamp);
803     require(_closingTime >= _openingTime);
804 
805     openingTime = _openingTime;
806     closingTime = _closingTime;
807   }
808 
809   /**
810    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
811    * @return Whether crowdsale period has elapsed
812    */
813   function hasClosed() public view returns (bool) {
814     // solium-disable-next-line security/no-block-members
815     return block.timestamp > closingTime;
816   }
817 
818   /**
819    * @dev Extend parent behavior requiring to be within contributing period
820    * @param _beneficiary Token purchaser
821    * @param _weiAmount Amount of wei contributed
822    */
823   function _preValidatePurchase(
824     address _beneficiary,
825     uint256 _weiAmount
826   )
827     internal
828     onlyWhileOpen
829   {
830     super._preValidatePurchase(_beneficiary, _weiAmount);
831   }
832 
833 }
834 
835 //end TimedCrowdsale.sol
836 // ----------------- 
837 //begin FinalizableCrowdsale.sol
838 
839 
840 /**
841  * @title FinalizableCrowdsale
842  * @dev Extension of Crowdsale where an owner can do extra work
843  * after finishing.
844  */
845 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
846   using SafeMath for uint256;
847 
848   bool public isFinalized = false;
849 
850   event Finalized();
851 
852   /**
853    * @dev Must be called after crowdsale ends, to do some extra finalization
854    * work. Calls the contract's finalization function.
855    */
856   function finalize() onlyOwner public {
857     require(!isFinalized);
858     require(hasClosed());
859 
860     finalization();
861     emit Finalized();
862 
863     isFinalized = true;
864   }
865 
866   /**
867    * @dev Can be overridden to add finalization logic. The overriding function
868    * should call super.finalization() to ensure the chain of finalization is
869    * executed entirely.
870    */
871   function finalization() internal {
872   }
873 
874 }
875 
876 //end FinalizableCrowdsale.sol
877 // ----------------- 
878 //begin TimedPresaleCrowdsale.sol
879 
880 contract TimedPresaleCrowdsale is FinalizableCrowdsale {
881     using SafeMath for uint256;
882 
883     uint256 public presaleOpeningTime;
884     uint256 public presaleClosingTime;
885 
886     uint256 public bonusUnlockTime;
887 
888     event CrowdsaleTimesChanged(uint256 presaleOpeningTime, uint256 presaleClosingTime, uint256 openingTime, uint256 closingTime);
889 
890     /**
891      * @dev Reverts if not in crowdsale time range.
892      */
893     modifier onlyWhileOpen {
894         require(isPresale() || isSale());
895         _;
896     }
897 
898 
899     constructor(uint256 _presaleOpeningTime, uint256 _presaleClosingTime, uint256 _openingTime, uint256 _closingTime) public
900     TimedCrowdsale(_openingTime, _closingTime) {
901 
902         changeTimes(_presaleOpeningTime, _presaleClosingTime, _openingTime, _closingTime);
903     }
904 
905     function changeTimes(uint256 _presaleOpeningTime, uint256 _presaleClosingTime, uint256 _openingTime, uint256 _closingTime) public onlyOwner {
906         require(!isFinalized);
907         require(_presaleClosingTime >= _presaleOpeningTime);
908         require(_openingTime >= _presaleClosingTime);
909         require(_closingTime >= _openingTime);
910 
911         presaleOpeningTime = _presaleOpeningTime;
912         presaleClosingTime = _presaleClosingTime;
913         openingTime = _openingTime;
914         closingTime = _closingTime;
915 
916         emit CrowdsaleTimesChanged(_presaleOpeningTime, _presaleClosingTime, _openingTime, _closingTime);
917     }
918 
919     function isPresale() public view returns (bool) {
920         return now >= presaleOpeningTime && now <= presaleClosingTime;
921     }
922 
923     function isSale() public view returns (bool) {
924         return now >= openingTime && now <= closingTime;
925     }
926 }
927 
928 //end TimedPresaleCrowdsale.sol
929 // ----------------- 
930 //begin TokenCappedCrowdsale.sol
931 
932 
933 
934 contract TokenCappedCrowdsale is FinalizableCrowdsale {
935     using SafeMath for uint256;
936 
937     uint256 public cap;
938     uint256 public totalTokens;
939     uint256 public soldTokens = 0;
940     bool public capIncreased = false;
941 
942     event CapIncreased();
943 
944     constructor() public {
945 
946         cap = 400 * 1000 * 1000 * 1 ether;
947         totalTokens = 750 * 1000 * 1000 * 1 ether;
948     }
949 
950     function notExceedingSaleCap(uint256 amount) internal view returns (bool) {
951         return cap >= amount.add(soldTokens);
952     }
953 
954     /**
955     * Finalization logic. We take the expected sale cap
956     * ether and find the difference from the actual minted tokens.
957     * The remaining balance and the reserved amount for the team are minted
958     * to the team wallet.
959     */
960     function finalization() internal {
961         super.finalization();
962     }
963 }
964 
965 //end TokenCappedCrowdsale.sol
966 // ----------------- 
967 //begin OpiriaCrowdsale.sol
968 
969 contract OpiriaCrowdsale is TimedPresaleCrowdsale, MintedCrowdsale, TokenCappedCrowdsale {
970     using SafeMath for uint256;
971 
972     uint256 public presaleWeiLimit;
973 
974     address public tokensWallet;
975 
976     uint256 public totalBonus = 0;
977 
978     bool public hiddenCapTriggered;
979 
980     uint16 public additionalBonusPercent = 0;
981 
982     mapping(address => uint256) public bonusOf;
983 
984     // Crowdsale(uint256 _rate, address _wallet, ERC20 _token)
985     constructor(ERC20 _token, uint16 _initialEtherUsdRate, address _wallet, address _tokensWallet,
986         uint256 _presaleOpeningTime, uint256 _presaleClosingTime, uint256 _openingTime, uint256 _closingTime
987     ) public
988     TimedPresaleCrowdsale(_presaleOpeningTime, _presaleClosingTime, _openingTime, _closingTime)
989     Crowdsale(_initialEtherUsdRate, _wallet, _token) {
990         setEtherUsdRate(_initialEtherUsdRate);
991         tokensWallet = _tokensWallet;
992 
993         require(PausableToken(token).paused());
994     }
995 
996     //overridden
997     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
998         // 1 ether * etherUsdRate * 10
999 
1000         return _weiAmount.mul(rate).mul(10);
1001     }
1002 
1003     function _getBonusAmount(uint256 tokens) internal view returns (uint256) {
1004         uint16 bonusPercent = _getBonusPercent();
1005         uint256 bonusAmount = tokens.mul(bonusPercent).div(100);
1006         return bonusAmount;
1007     }
1008 
1009     function _getBonusPercent() internal view returns (uint16) {
1010         if (isPresale()) {
1011             return 20;
1012         }
1013         uint256 daysPassed = (now - openingTime) / 1 days;
1014         uint16 calcPercent = 0;
1015         if (daysPassed < 15) {
1016             // daysPassed will be less than 15 so no worries about overflow here
1017             calcPercent = (15 - uint8(daysPassed));
1018         }
1019 
1020         calcPercent = additionalBonusPercent + calcPercent;
1021 
1022         return calcPercent;
1023     }
1024 
1025     //overridden
1026     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
1027         _saveBonus(_beneficiary, _tokenAmount);
1028         _deliverTokens(_beneficiary, _tokenAmount);
1029 
1030         soldTokens = soldTokens.add(_tokenAmount);
1031     }
1032 
1033     function _saveBonus(address _beneficiary, uint256 tokens) internal {
1034         uint256 bonusAmount = _getBonusAmount(tokens);
1035         if (bonusAmount > 0) {
1036             totalBonus = totalBonus.add(bonusAmount);
1037             soldTokens = soldTokens.add(bonusAmount);
1038             bonusOf[_beneficiary] = bonusOf[_beneficiary].add(bonusAmount);
1039         }
1040     }
1041 
1042     //overridden
1043     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
1044         super._preValidatePurchase(_beneficiary, _weiAmount);
1045         if (isPresale()) {
1046             require(_weiAmount >= presaleWeiLimit);
1047         }
1048 
1049         uint256 tokens = _getTokenAmount(_weiAmount);
1050         uint256 bonusTokens = _getBonusAmount(tokens);
1051         require(notExceedingSaleCap(tokens.add(bonusTokens)));
1052     }
1053 
1054     function setEtherUsdRate(uint16 _etherUsdRate) public onlyOwner {
1055         rate = _etherUsdRate;
1056 
1057         // the presaleWeiLimit must be $5000 in eth at the defined 'etherUsdRate'
1058         // presaleWeiLimit = 1 ether / etherUsdRate * 5000
1059         presaleWeiLimit = uint256(1 ether).mul(2500).div(rate);
1060     }
1061 
1062     function setAdditionalBonusPercent(uint8 _additionalBonusPercent) public onlyOwner {
1063         additionalBonusPercent = _additionalBonusPercent;
1064     }
1065     /**
1066     * Send tokens by the owner directly to an address.
1067     */
1068     function sendTokensTo(uint256 amount, address to) public onlyOwner {
1069         require(!isFinalized);
1070         require(notExceedingSaleCap(amount));
1071 
1072         require(MintableToken(token).mint(to, amount));
1073         soldTokens = soldTokens.add(amount);
1074 
1075         emit TokenPurchase(msg.sender, to, 0, amount);
1076     }
1077 
1078     function sendTokensToBatch(uint256[] amounts, address[] recipients) public onlyOwner {
1079         require(amounts.length == recipients.length);
1080         for (uint i = 0; i < recipients.length; i++) {
1081             sendTokensTo(amounts[i], recipients[i]);
1082         }
1083     }
1084 
1085     function addBonusBatch(uint256[] amounts, address[] recipients) public onlyOwner {
1086 
1087         for (uint i = 0; i < recipients.length; i++) {
1088             require(PausableToken(token).balanceOf(recipients[i]) > 0);
1089             require(notExceedingSaleCap(amounts[i]));
1090 
1091             totalBonus = totalBonus.add(amounts[i]);
1092             soldTokens = soldTokens.add(amounts[i]);
1093             bonusOf[recipients[i]] = bonusOf[recipients[i]].add(amounts[i]);
1094         }
1095     }
1096 
1097     function unlockTokenTransfers() public onlyOwner {
1098         require(isFinalized);
1099         require(now > closingTime + 30 days);
1100         require(PausableToken(token).paused());
1101         bonusUnlockTime = now + 30 days;
1102         PausableToken(token).unpause();
1103     }
1104 
1105 
1106     function distributeBonus(address[] addresses) public onlyOwner {
1107         require(now > bonusUnlockTime);
1108         for (uint i = 0; i < addresses.length; i++) {
1109             if (bonusOf[addresses[i]] > 0) {
1110                 uint256 bonusAmount = bonusOf[addresses[i]];
1111                 _deliverTokens(addresses[i], bonusAmount);
1112                 totalBonus = totalBonus.sub(bonusAmount);
1113                 bonusOf[addresses[i]] = 0;
1114             }
1115         }
1116         if (totalBonus == 0 && reservedTokensClaimStage == 3) {
1117             MintableToken(token).finishMinting();
1118         }
1119     }
1120 
1121     function withdrawBonus() public {
1122         require(now > bonusUnlockTime);
1123         require(bonusOf[msg.sender] > 0);
1124 
1125         _deliverTokens(msg.sender, bonusOf[msg.sender]);
1126         totalBonus = totalBonus.sub(bonusOf[msg.sender]);
1127         bonusOf[msg.sender] = 0;
1128 
1129         if (totalBonus == 0 && reservedTokensClaimStage == 3) {
1130             MintableToken(token).finishMinting();
1131         }
1132     }
1133 
1134 
1135     function finalization() internal {
1136         super.finalization();
1137 
1138         // mint 25% of total Tokens (13% for development, 5% for company/team, 6% for advisors, 2% bounty) into team wallet
1139         uint256 toMintNow = totalTokens.mul(25).div(100);
1140 
1141         if (!capIncreased) {
1142             // if the cap didn't increase (according to whitepaper) mint the 50MM tokens to the team wallet too
1143             toMintNow = toMintNow.add(50 * 1000 * 1000);
1144         }
1145         _deliverTokens(tokensWallet, toMintNow);
1146     }
1147 
1148     uint8 public reservedTokensClaimStage = 0;
1149 
1150     function claimReservedTokens() public onlyOwner {
1151 
1152         uint256 toMintNow = totalTokens.mul(5).div(100);
1153         if (reservedTokensClaimStage == 0) {
1154             require(now > closingTime + 6 * 30 days);
1155             reservedTokensClaimStage = 1;
1156             _deliverTokens(tokensWallet, toMintNow);
1157         }
1158         else if (reservedTokensClaimStage == 1) {
1159             require(now > closingTime + 12 * 30 days);
1160             reservedTokensClaimStage = 2;
1161             _deliverTokens(tokensWallet, toMintNow);
1162         }
1163         else if (reservedTokensClaimStage == 2) {
1164             require(now > closingTime + 24 * 30 days);
1165             reservedTokensClaimStage = 3;
1166             _deliverTokens(tokensWallet, toMintNow);
1167             if (totalBonus == 0) {
1168                 MintableToken(token).finishMinting();
1169                 MintableToken(token).transferOwnership(owner);
1170             }
1171         }
1172         else {
1173             revert();
1174         }
1175     }
1176 
1177     function increaseCap() public onlyOwner {
1178         require(!capIncreased);
1179         require(!isFinalized);
1180         require(now < openingTime + 5 days);
1181 
1182         capIncreased = true;
1183         cap = cap.add(50 * 1000 * 1000);
1184         emit CapIncreased();
1185     }
1186 
1187     function triggerHiddenCap() public onlyOwner {
1188         require(!hiddenCapTriggered);
1189         require(now > presaleOpeningTime);
1190         require(now < presaleClosingTime);
1191 
1192         presaleClosingTime = now;
1193         openingTime = now + 24 hours;
1194 
1195         hiddenCapTriggered = true;
1196     }
1197 }
1198 
1199 //end OpiriaCrowdsale.sol