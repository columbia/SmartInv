1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * See https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address _who) public view returns (uint256);
12   function transfer(address _to, uint256 _value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipRenounced(address indexed previousOwner);
28   event OwnershipTransferred(
29     address indexed previousOwner,
30     address indexed newOwner
31   );
32 
33 
34   /**
35    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36    * account.
37    */
38   constructor() public {
39     owner = msg.sender;
40   }
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50   /**
51    * @dev Allows the current owner to relinquish control of the contract.
52    * @notice Renouncing to ownership will leave the contract without an owner.
53    * It will not be possible to call the functions with the `onlyOwner`
54    * modifier anymore.
55    */
56   function renounceOwnership() public onlyOwner {
57     emit OwnershipRenounced(owner);
58     owner = address(0);
59   }
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param _newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address _newOwner) public onlyOwner {
66     _transferOwnership(_newOwner);
67   }
68 
69   /**
70    * @dev Transfers control of the contract to a newOwner.
71    * @param _newOwner The address to transfer ownership to.
72    */
73   function _transferOwnership(address _newOwner) internal {
74     require(_newOwner != address(0));
75     emit OwnershipTransferred(owner, _newOwner);
76     owner = _newOwner;
77   }
78 }
79 
80 
81 
82 
83 
84 /**
85  * @title ERC20 interface
86  * @dev see https://github.com/ethereum/EIPs/issues/20
87  */
88 contract ERC20 is ERC20Basic {
89   function allowance(address _owner, address _spender)
90     public view returns (uint256);
91 
92   function transferFrom(address _from, address _to, uint256 _value)
93     public returns (bool);
94 
95   function approve(address _spender, uint256 _value) public returns (bool);
96   event Approval(
97     address indexed owner,
98     address indexed spender,
99     uint256 value
100   );
101 }
102 
103 
104 
105 /**
106  * @title SafeMath
107  * @dev Math operations with safety checks that throw on error
108  */
109 library SafeMath {
110 
111   /**
112   * @dev Multiplies two numbers, throws on overflow.
113   */
114   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
115     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
116     // benefit is lost if 'b' is also tested.
117     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
118     if (_a == 0) {
119       return 0;
120     }
121 
122     c = _a * _b;
123     assert(c / _a == _b);
124     return c;
125   }
126 
127   /**
128   * @dev Integer division of two numbers, truncating the quotient.
129   */
130   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
131     // assert(_b > 0); // Solidity automatically throws when dividing by 0
132     // uint256 c = _a / _b;
133     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
134     return _a / _b;
135   }
136 
137   /**
138   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
139   */
140   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
141     assert(_b <= _a);
142     return _a - _b;
143   }
144 
145   /**
146   * @dev Adds two numbers, throws on overflow.
147   */
148   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
149     c = _a + _b;
150     assert(c >= _a);
151     return c;
152   }
153 }
154 
155 
156 
157 
158 
159 
160 /**
161  * @title SafeERC20
162  * @dev Wrappers around ERC20 operations that throw on failure.
163  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
164  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
165  */
166 library SafeERC20 {
167   function safeTransfer(
168     ERC20Basic _token,
169     address _to,
170     uint256 _value
171   )
172     internal
173   {
174     require(_token.transfer(_to, _value));
175   }
176 
177   function safeTransferFrom(
178     ERC20 _token,
179     address _from,
180     address _to,
181     uint256 _value
182   )
183     internal
184   {
185     require(_token.transferFrom(_from, _to, _value));
186   }
187 
188   function safeApprove(
189     ERC20 _token,
190     address _spender,
191     uint256 _value
192   )
193     internal
194   {
195     require(_token.approve(_spender, _value));
196   }
197 }
198 
199 
200 
201 
202 
203 
204 
205 
206 
207 /**
208  * @title Crowdsale
209  * @dev Crowdsale is a base contract for managing a token crowdsale,
210  * allowing investors to purchase tokens with ether. This contract implements
211  * such functionality in its most fundamental form and can be extended to provide additional
212  * functionality and/or custom behavior.
213  * The external interface represents the basic interface for purchasing tokens, and conform
214  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
215  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
216  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
217  * behavior.
218  */
219 contract Crowdsale {
220   using SafeMath for uint256;
221   using SafeERC20 for ERC20;
222 
223   // The token being sold
224   ERC20 public token;
225 
226   // Address where funds are collected
227   address public wallet;
228 
229   // How many token units a buyer gets per wei.
230   // The rate is the conversion between wei and the smallest and indivisible token unit.
231   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
232   // 1 wei will give you 1 unit, or 0.001 TOK.
233   uint256 public rate;
234 
235   // Amount of wei raised
236   uint256 public weiRaised;
237 
238   /**
239    * Event for token purchase logging
240    * @param purchaser who paid for the tokens
241    * @param beneficiary who got the tokens
242    * @param value weis paid for purchase
243    * @param amount amount of tokens purchased
244    */
245   event TokenPurchase(
246     address indexed purchaser,
247     address indexed beneficiary,
248     uint256 value,
249     uint256 amount
250   );
251 
252   /**
253    * @param _rate Number of token units a buyer gets per wei
254    * @param _wallet Address where collected funds will be forwarded to
255    * @param _token Address of the token being sold
256    */
257   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
258     require(_rate > 0);
259     require(_wallet != address(0));
260     require(_token != address(0));
261 
262     rate = _rate;
263     wallet = _wallet;
264     token = _token;
265   }
266 
267   // -----------------------------------------
268   // Crowdsale external interface
269   // -----------------------------------------
270 
271   /**
272    * @dev fallback function ***DO NOT OVERRIDE***
273    */
274   function () external payable {
275     buyTokens(msg.sender);
276   }
277 
278   /**
279    * @dev low level token purchase ***DO NOT OVERRIDE***
280    * @param _beneficiary Address performing the token purchase
281    */
282   function buyTokens(address _beneficiary) public payable {
283 
284     uint256 weiAmount = msg.value;
285     _preValidatePurchase(_beneficiary, weiAmount);
286 
287     // calculate token amount to be created
288     uint256 tokens = _getTokenAmount(weiAmount);
289 
290     // update state
291     weiRaised = weiRaised.add(weiAmount);
292 
293     _processPurchase(_beneficiary, tokens);
294     emit TokenPurchase(
295       msg.sender,
296       _beneficiary,
297       weiAmount,
298       tokens
299     );
300 
301     _updatePurchasingState(_beneficiary, weiAmount);
302 
303     _forwardFunds();
304     _postValidatePurchase(_beneficiary, weiAmount);
305   }
306 
307   // -----------------------------------------
308   // Internal interface (extensible)
309   // -----------------------------------------
310 
311   /**
312    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
313    * Example from CappedCrowdsale.sol's _preValidatePurchase method: 
314    *   super._preValidatePurchase(_beneficiary, _weiAmount);
315    *   require(weiRaised.add(_weiAmount) <= cap);
316    * @param _beneficiary Address performing the token purchase
317    * @param _weiAmount Value in wei involved in the purchase
318    */
319   function _preValidatePurchase(
320     address _beneficiary,
321     uint256 _weiAmount
322   )
323     internal
324   {
325     require(_beneficiary != address(0));
326     require(_weiAmount != 0);
327   }
328 
329   /**
330    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
331    * @param _beneficiary Address performing the token purchase
332    * @param _weiAmount Value in wei involved in the purchase
333    */
334   function _postValidatePurchase(
335     address _beneficiary,
336     uint256 _weiAmount
337   )
338     internal
339   {
340     // optional override
341   }
342 
343   /**
344    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
345    * @param _beneficiary Address performing the token purchase
346    * @param _tokenAmount Number of tokens to be emitted
347    */
348   function _deliverTokens(
349     address _beneficiary,
350     uint256 _tokenAmount
351   )
352     internal
353   {
354     token.safeTransfer(_beneficiary, _tokenAmount);
355   }
356 
357   /**
358    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
359    * @param _beneficiary Address receiving the tokens
360    * @param _tokenAmount Number of tokens to be purchased
361    */
362   function _processPurchase(
363     address _beneficiary,
364     uint256 _tokenAmount
365   )
366     internal
367   {
368     _deliverTokens(_beneficiary, _tokenAmount);
369   }
370 
371   /**
372    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
373    * @param _beneficiary Address receiving the tokens
374    * @param _weiAmount Value in wei involved in the purchase
375    */
376   function _updatePurchasingState(
377     address _beneficiary,
378     uint256 _weiAmount
379   )
380     internal
381   {
382     // optional override
383   }
384 
385   /**
386    * @dev Override to extend the way in which ether is converted to tokens.
387    * @param _weiAmount Value in wei to be converted into tokens
388    * @return Number of tokens that can be purchased with the specified _weiAmount
389    */
390   function _getTokenAmount(uint256 _weiAmount)
391     internal view returns (uint256)
392   {
393     return _weiAmount.mul(rate);
394   }
395 
396   /**
397    * @dev Determines how ETH is stored/forwarded on purchases.
398    */
399   function _forwardFunds() internal {
400     wallet.transfer(msg.value);
401   }
402 }
403 
404 
405 
406 
407 
408 
409 
410 
411 
412 
413 
414 
415 
416 
417 
418 /**
419  * @title Basic token
420  * @dev Basic version of StandardToken, with no allowances.
421  */
422 contract BasicToken is ERC20Basic {
423   using SafeMath for uint256;
424 
425   mapping(address => uint256) internal balances;
426 
427   uint256 internal totalSupply_;
428 
429   /**
430   * @dev Total number of tokens in existence
431   */
432   function totalSupply() public view returns (uint256) {
433     return totalSupply_;
434   }
435 
436   /**
437   * @dev Transfer token for a specified address
438   * @param _to The address to transfer to.
439   * @param _value The amount to be transferred.
440   */
441   function transfer(address _to, uint256 _value) public returns (bool) {
442     require(_value <= balances[msg.sender]);
443     require(_to != address(0));
444 
445     balances[msg.sender] = balances[msg.sender].sub(_value);
446     balances[_to] = balances[_to].add(_value);
447     emit Transfer(msg.sender, _to, _value);
448     return true;
449   }
450 
451   /**
452   * @dev Gets the balance of the specified address.
453   * @param _owner The address to query the the balance of.
454   * @return An uint256 representing the amount owned by the passed address.
455   */
456   function balanceOf(address _owner) public view returns (uint256) {
457     return balances[_owner];
458   }
459 
460 }
461 
462 
463 
464 
465 /**
466  * @title Standard ERC20 token
467  *
468  * @dev Implementation of the basic standard token.
469  * https://github.com/ethereum/EIPs/issues/20
470  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
471  */
472 contract StandardToken is ERC20, BasicToken {
473 
474   mapping (address => mapping (address => uint256)) internal allowed;
475 
476 
477   /**
478    * @dev Transfer tokens from one address to another
479    * @param _from address The address which you want to send tokens from
480    * @param _to address The address which you want to transfer to
481    * @param _value uint256 the amount of tokens to be transferred
482    */
483   function transferFrom(
484     address _from,
485     address _to,
486     uint256 _value
487   )
488     public
489     returns (bool)
490   {
491     require(_value <= balances[_from]);
492     require(_value <= allowed[_from][msg.sender]);
493     require(_to != address(0));
494 
495     balances[_from] = balances[_from].sub(_value);
496     balances[_to] = balances[_to].add(_value);
497     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
498     emit Transfer(_from, _to, _value);
499     return true;
500   }
501 
502   /**
503    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
504    * Beware that changing an allowance with this method brings the risk that someone may use both the old
505    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
506    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
507    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
508    * @param _spender The address which will spend the funds.
509    * @param _value The amount of tokens to be spent.
510    */
511   function approve(address _spender, uint256 _value) public returns (bool) {
512     allowed[msg.sender][_spender] = _value;
513     emit Approval(msg.sender, _spender, _value);
514     return true;
515   }
516 
517   /**
518    * @dev Function to check the amount of tokens that an owner allowed to a spender.
519    * @param _owner address The address which owns the funds.
520    * @param _spender address The address which will spend the funds.
521    * @return A uint256 specifying the amount of tokens still available for the spender.
522    */
523   function allowance(
524     address _owner,
525     address _spender
526    )
527     public
528     view
529     returns (uint256)
530   {
531     return allowed[_owner][_spender];
532   }
533 
534   /**
535    * @dev Increase the amount of tokens that an owner allowed to a spender.
536    * approve should be called when allowed[_spender] == 0. To increment
537    * allowed value is better to use this function to avoid 2 calls (and wait until
538    * the first transaction is mined)
539    * From MonolithDAO Token.sol
540    * @param _spender The address which will spend the funds.
541    * @param _addedValue The amount of tokens to increase the allowance by.
542    */
543   function increaseApproval(
544     address _spender,
545     uint256 _addedValue
546   )
547     public
548     returns (bool)
549   {
550     allowed[msg.sender][_spender] = (
551       allowed[msg.sender][_spender].add(_addedValue));
552     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
553     return true;
554   }
555 
556   /**
557    * @dev Decrease the amount of tokens that an owner allowed to a spender.
558    * approve should be called when allowed[_spender] == 0. To decrement
559    * allowed value is better to use this function to avoid 2 calls (and wait until
560    * the first transaction is mined)
561    * From MonolithDAO Token.sol
562    * @param _spender The address which will spend the funds.
563    * @param _subtractedValue The amount of tokens to decrease the allowance by.
564    */
565   function decreaseApproval(
566     address _spender,
567     uint256 _subtractedValue
568   )
569     public
570     returns (bool)
571   {
572     uint256 oldValue = allowed[msg.sender][_spender];
573     if (_subtractedValue >= oldValue) {
574       allowed[msg.sender][_spender] = 0;
575     } else {
576       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
577     }
578     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
579     return true;
580   }
581 
582 }
583 
584 
585 
586 
587 /**
588  * @title Mintable token
589  * @dev Simple ERC20 Token example, with mintable token creation
590  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
591  */
592 contract MintableToken is StandardToken, Ownable {
593   event Mint(address indexed to, uint256 amount);
594   event MintFinished();
595 
596   bool public mintingFinished = false;
597 
598 
599   modifier canMint() {
600     require(!mintingFinished);
601     _;
602   }
603 
604   modifier hasMintPermission() {
605     require(msg.sender == owner);
606     _;
607   }
608 
609   /**
610    * @dev Function to mint tokens
611    * @param _to The address that will receive the minted tokens.
612    * @param _amount The amount of tokens to mint.
613    * @return A boolean that indicates if the operation was successful.
614    */
615   function mint(
616     address _to,
617     uint256 _amount
618   )
619     public
620     hasMintPermission
621     canMint
622     returns (bool)
623   {
624     totalSupply_ = totalSupply_.add(_amount);
625     balances[_to] = balances[_to].add(_amount);
626     emit Mint(_to, _amount);
627     emit Transfer(address(0), _to, _amount);
628     return true;
629   }
630 
631   /**
632    * @dev Function to stop minting new tokens.
633    * @return True if the operation was successful.
634    */
635   function finishMinting() public onlyOwner canMint returns (bool) {
636     mintingFinished = true;
637     emit MintFinished();
638     return true;
639   }
640 }
641 
642 
643 
644 /**
645  * @title MintedCrowdsale
646  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
647  * Token ownership should be transferred to MintedCrowdsale for minting.
648  */
649 contract MintedCrowdsale is Crowdsale {
650 
651   /**
652    * @dev Overrides delivery by minting tokens upon purchase.
653    * @param _beneficiary Token purchaser
654    * @param _tokenAmount Number of tokens to be minted
655    */
656   function _deliverTokens(
657     address _beneficiary,
658     uint256 _tokenAmount
659   )
660     internal
661   {
662     // Potentially dangerous assumption about the type of the token.
663     require(MintableToken(address(token)).mint(_beneficiary, _tokenAmount));
664   }
665 }
666 
667 
668 
669 
670 
671 
672 
673 
674 /**
675  * @title CappedCrowdsale
676  * @dev Crowdsale with a limit for total contributions.
677  */
678 contract CappedCrowdsale is Crowdsale {
679   using SafeMath for uint256;
680 
681   uint256 public cap;
682 
683   /**
684    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
685    * @param _cap Max amount of wei to be contributed
686    */
687   constructor(uint256 _cap) public {
688     require(_cap > 0);
689     cap = _cap;
690   }
691 
692   /**
693    * @dev Checks whether the cap has been reached.
694    * @return Whether the cap was reached
695    */
696   function capReached() public view returns (bool) {
697     return weiRaised >= cap;
698   }
699 
700   /**
701    * @dev Extend parent behavior requiring purchase to respect the funding cap.
702    * @param _beneficiary Token purchaser
703    * @param _weiAmount Amount of wei contributed
704    */
705   function _preValidatePurchase(
706     address _beneficiary,
707     uint256 _weiAmount
708   )
709     internal
710   {
711     super._preValidatePurchase(_beneficiary, _weiAmount);
712     require(weiRaised.add(_weiAmount) <= cap);
713   }
714 
715 }
716 
717 
718 
719 
720 
721 
722 
723 
724 
725 
726 
727 /**
728  * @title Pausable
729  * @dev Base contract which allows children to implement an emergency stop mechanism.
730  */
731 contract Pausable is Ownable {
732   event Pause();
733   event Unpause();
734 
735   bool public paused = false;
736 
737 
738   /**
739    * @dev Modifier to make a function callable only when the contract is not paused.
740    */
741   modifier whenNotPaused() {
742     require(!paused);
743     _;
744   }
745 
746   /**
747    * @dev Modifier to make a function callable only when the contract is paused.
748    */
749   modifier whenPaused() {
750     require(paused);
751     _;
752   }
753 
754   /**
755    * @dev called by the owner to pause, triggers stopped state
756    */
757   function pause() public onlyOwner whenNotPaused {
758     paused = true;
759     emit Pause();
760   }
761 
762   /**
763    * @dev called by the owner to unpause, returns to normal state
764    */
765   function unpause() public onlyOwner whenPaused {
766     paused = false;
767     emit Unpause();
768   }
769 }
770 
771 
772 
773 /**
774  * @title Pausable token
775  * @dev StandardToken modified with pausable transfers.
776  **/
777 contract PausableToken is StandardToken, Pausable {
778 
779   function transfer(
780     address _to,
781     uint256 _value
782   )
783     public
784     whenNotPaused
785     returns (bool)
786   {
787     return super.transfer(_to, _value);
788   }
789 
790   function transferFrom(
791     address _from,
792     address _to,
793     uint256 _value
794   )
795     public
796     whenNotPaused
797     returns (bool)
798   {
799     return super.transferFrom(_from, _to, _value);
800   }
801 
802   function approve(
803     address _spender,
804     uint256 _value
805   )
806     public
807     whenNotPaused
808     returns (bool)
809   {
810     return super.approve(_spender, _value);
811   }
812 
813   function increaseApproval(
814     address _spender,
815     uint _addedValue
816   )
817     public
818     whenNotPaused
819     returns (bool success)
820   {
821     return super.increaseApproval(_spender, _addedValue);
822   }
823 
824   function decreaseApproval(
825     address _spender,
826     uint _subtractedValue
827   )
828     public
829     whenNotPaused
830     returns (bool success)
831   {
832     return super.decreaseApproval(_spender, _subtractedValue);
833   }
834 }
835 
836 
837 contract COTCrowdsale is Crowdsale, MintedCrowdsale, CappedCrowdsale, Ownable{
838 
839  using SafeMath for uint256;
840 
841  uint256 private limit;
842  uint256 private maxLimit;
843  uint256 private minLimit;
844  uint256 private limitAmount;
845  uint256 private percent;
846  uint256 private ICOrate;
847  uint256 private limitTime;
848  bool    private isSetTime = false;
849  bool    private isCallPauseTokens = false;
850  bool    private isSetLimitAmount = false;
851  uint256 private timeForISL;
852  bool    private isSetISLTime = false;
853 
854  constructor(
855     uint256 _rate,
856     address _wallet,
857     ERC20 _token,
858     uint256 _limit,
859     uint256 _cap,
860     uint256 _percent,
861     uint256 _ICOrate,
862     uint256 _limitTime,
863     uint256 _timeForISL
864   )
865   Crowdsale(_rate, _wallet, _token)
866   CappedCrowdsale(_cap)
867   public
868   {
869     maxLimit = _limit;
870     limit = _limit.div(5);
871     minLimit = _limit.div(5);
872     limitAmount = _limit.div(10).div(5);
873     percent = _percent;
874     ICOrate = _ICOrate;
875     limitTime = _limitTime;
876     timeForISL = _timeForISL;
877   }
878 
879   /*
880     @dev Owner can reduce bonus percent 25% by default
881     each call reduces of 1%
882   */
883 
884   function ReduceRate()
885     public
886     onlyOwner()
887   {
888     require(rate > ICOrate);
889     uint256 totalPercent = ICOrate.div(100).mul(percent);
890     rate = ICOrate.add(totalPercent);
891     if (percent != 0) {
892     percent = percent.sub(1);
893     }
894   }
895 
896   /*
897    @dev Owner can reduce limit
898    After call this function owner can not set new limit more than
899    value of parametr previous call
900  */
901 
902  function ReduceMaxLimit(uint256 newlLimit)
903    public
904    onlyOwner()
905  {
906    uint256 totalLimit = maxLimit;
907    require(newlLimit >= minLimit);
908    require(newlLimit <= totalLimit);
909    maxLimit = newlLimit;
910  }
911 
912   /*
913     @dev Owner can change time limit for call ISL()
914     @param Unix Date
915   */
916 
917   function SetMintTimeLimit(uint256 newTime)
918     public
919     onlyOwner()
920   {
921     require(!isSetTime);
922     limitTime = newTime;
923   }
924 
925   /*
926     @dev Owner can block SetMintTimeLimit() FOREVER
927   */
928 
929   function blockSetMintTimeLimit()
930     public
931     onlyOwner()
932   {
933     isSetTime = true;
934   }
935 
936   /*
937     @dev View status about the possibility of calling of SetMintTimeLimit function
938   */
939 
940   function isblockSetMintTimeLimit()
941     public
942     view
943     returns (bool)
944   {
945     return isSetTime;
946   }
947 
948 
949   /*
950     @dev Owner can add 2B (by Default) to limit per 3 month,
951     100B maximum tokens limit (can be reduce via ReduceMaxLimit)
952   */
953 
954   function ISL()
955     public
956     onlyOwner()
957   {
958     require(now >= limitTime);
959     require(limit < maxLimit);
960     limit = limit.add(limitAmount);
961     limitTime = now + timeForISL;
962   }
963 
964   /*
965     @dev Owner can change time ISL for next call
966     @param time in seconds
967   */
968 
969   function SetISLTime(uint256 newTime)
970     public
971     onlyOwner()
972   {
973     require(!isSetISLTime);
974     timeForISL = newTime;
975   }
976 
977   /*
978     @dev Owner can block SetISLTime
979   */
980 
981   function blockSetISLTime()
982     public
983     onlyOwner()
984   {
985     isSetISLTime = true;
986     limitAmount = minLimit.div(10);
987   }
988 
989   /*
990     @dev View status about the possibility of calling of SetISLTime function
991   */
992 
993   function isblockSetISLTime()
994     public
995     view
996     returns (bool)
997   {
998     return isSetISLTime;
999   }
1000 
1001   /*
1002     @dev View value of timeForISL return time in secods
1003   */
1004 
1005   function ReturnISLDays()
1006     public
1007     view
1008     returns (uint256)
1009   {
1010     return timeForISL;
1011   }
1012 
1013   /*
1014     @dev Owner can change Limit amount for ISL
1015     can NOT set more that 100B anyway
1016   */
1017 
1018   function SetLimitAmount(uint256 amount)
1019     public
1020     onlyOwner()
1021   {
1022    require(!isSetLimitAmount);
1023    uint256 max = maxLimit;
1024    uint256 total = limit;
1025    require(max > amount);
1026 
1027    if(total.add(amount) > max){
1028     amount = 0;
1029    }
1030    require(amount > 0);
1031    limitAmount = amount;
1032   }
1033 
1034   /*
1035     @dev Owner can block SetLimitAmount
1036     set 2B by default after block
1037   */
1038 
1039   function blockSetLimitAmount()
1040     public
1041     onlyOwner()
1042   {
1043     isSetLimitAmount = true;
1044     limitAmount = minLimit.div(10);
1045   }
1046 
1047   /*
1048     @dev View status about the possibility of calling of SetLimitAmount function
1049   */
1050 
1051   function isblockSetLimitAmount()
1052     public
1053     view
1054     returns (bool)
1055   {
1056     return isSetLimitAmount;
1057   }
1058 
1059   /*
1060     @dev Owner can mint new Tokens up to a certain limit
1061     @param _beneficiary - receiver
1062     @param _tokenAmount - amount
1063   */
1064 
1065   function MintLimit(
1066     address _beneficiary,
1067     uint256 _tokenAmount
1068   )
1069     public
1070     onlyOwner()
1071   {
1072 
1073   uint256 _limit = ReturnLimit();
1074 
1075   uint256 total = token.totalSupply();
1076   require(total < _limit);
1077 
1078   if(_tokenAmount.add(total) > _limit ){
1079     _tokenAmount = 0;
1080   }
1081   require(_tokenAmount > 0);
1082   require(MintableToken(address(token)).mint(_beneficiary, _tokenAmount));
1083   }
1084 
1085   /*
1086     @dev Get amount of total limit for MintLimit function
1087   */
1088 
1089   function ReturnLimit()
1090     public
1091     view
1092     returns (uint256)
1093   {
1094     return limit;
1095   }
1096 
1097   /*
1098     @dev View amount of minLimit
1099   */
1100 
1101   function ReturnMinLimit()
1102     public
1103     view
1104     returns (uint256)
1105   {
1106     return minLimit;
1107   }
1108 
1109   /*
1110     @dev View amount of maxLimit
1111   */
1112 
1113   function ReturnMaxLimit()
1114     public
1115     view
1116     returns (uint256)
1117   {
1118     return maxLimit;
1119   }
1120 
1121   /*
1122     @dev return unix Date time when ISL can be call
1123   */
1124 
1125   function iSLDate()
1126     public
1127     view
1128     returns (uint256)
1129   {
1130     return limitTime;
1131   }
1132 
1133   /*
1134     @dev owner sale can pause Token
1135     only through contract sale
1136   */
1137 
1138   function pauseTokens()
1139     public
1140     onlyOwner()
1141   {
1142     require(!isCallPauseTokens);
1143     PausableToken(address(token)).pause();
1144   }
1145 
1146   /*
1147     @dev owner sale can unpause Token
1148     only through contract sale
1149   */
1150 
1151   function unpauseTokens()
1152     public
1153     onlyOwner()
1154   {
1155     PausableToken(address(token)).unpause();
1156   }
1157 
1158   /*
1159     @dev Owner can block call pauseTokens FOREVER
1160   */
1161 
1162   function blockCallPauseTokens()
1163     public
1164     onlyOwner()
1165   {
1166     isCallPauseTokens = true;
1167   }
1168 
1169   /*
1170     @dev view status about the possibility of calling pauseTokens()
1171   */
1172 
1173   function isblockCallPauseTokens()
1174     public
1175     view
1176     returns (bool)
1177   {
1178     return isCallPauseTokens;
1179   }
1180 
1181   /*
1182     @dev owner sale can finish mint FOREVER
1183   */
1184 
1185   function finishMint()
1186     public
1187     onlyOwner()
1188   {
1189     MintableToken(address(token)).finishMinting();
1190   }
1191 
1192 }