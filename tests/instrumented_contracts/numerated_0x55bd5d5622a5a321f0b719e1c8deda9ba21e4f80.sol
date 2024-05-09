1 pragma solidity ^0.4.24;
2 
3 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface0x14723a09acff6d2a60dcdf7aa4aff308fddc160c
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address _who) public view returns (uint256);
13   function transfer(address _to, uint256 _value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
29     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (_a == 0) {
33       return 0;
34     }
35 
36     c = _a * _b;
37     assert(c / _a == _b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
45     // assert(_b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = _a / _b;
47     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
48     return _a / _b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
55     assert(_b <= _a);
56     return _a - _b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
63     c = _a + _b;
64     assert(c >= _a);
65     return c;
66   }
67 }
68 
69 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\BasicToken.sol
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) internal balances;
79 
80   uint256 internal totalSupply_;
81 
82   /**
83   * @dev Total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev Transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_value <= balances[msg.sender]);
96     require(_to != address(0));
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
116 
117 /**
118  * @title ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/20
120  */
121 contract ERC20 is ERC20Basic {
122   function allowance(address _owner, address _spender)
123     public view returns (uint256);
124 
125   function transferFrom(address _from, address _to, uint256 _value)
126     public returns (bool);
127 
128   function approve(address _spender, uint256 _value) public returns (bool);
129   event Approval(
130     address indexed owner,
131     address indexed spender,
132     uint256 value
133   );
134 }
135 
136 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\StandardToken.sol
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * https://github.com/ethereum/EIPs/issues/20
143  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) internal allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(
157     address _from,
158     address _to,
159     uint256 _value
160   )
161     public
162     returns (bool)
163   {
164     require(_value <= balances[_from]);
165     require(_value <= allowed[_from][msg.sender]);
166     require(_to != address(0));
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     emit Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _value) public returns (bool) {
185     allowed[msg.sender][_spender] = _value;
186     emit Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(
197     address _owner,
198     address _spender
199    )
200     public
201     view
202     returns (uint256)
203   {
204     return allowed[_owner][_spender];
205   }
206 
207   /**
208    * @dev Increase the amount of tokens that an owner allowed to a spender.
209    * approve should be called when allowed[_spender] == 0. To increment
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    * @param _spender The address which will spend the funds.
214    * @param _addedValue The amount of tokens to increase the allowance by.
215    */
216   function increaseApproval(
217     address _spender,
218     uint256 _addedValue
219   )
220     public
221     returns (bool)
222   {
223     allowed[msg.sender][_spender] = (
224       allowed[msg.sender][_spender].add(_addedValue));
225     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    * approve should be called when allowed[_spender] == 0. To decrement
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _subtractedValue The amount of tokens to decrease the allowance by.
237    */
238   function decreaseApproval(
239     address _spender,
240     uint256 _subtractedValue
241   )
242     public
243     returns (bool)
244   {
245     uint256 oldValue = allowed[msg.sender][_spender];
246     if (_subtractedValue >= oldValue) {
247       allowed[msg.sender][_spender] = 0;
248     } else {
249       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250     }
251     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255 }
256 
257 // File: node_modules\openzeppelin-solidity\contracts\ownership\Ownable.sol
258 
259 /**
260  * @title Ownable
261  * @dev The Ownable contract has an owner address, and provides basic authorization control
262  * functions, this simplifies the implementation of "user permissions".
263  */
264 contract Ownable {
265   address public owner;
266 
267 
268   event OwnershipRenounced(address indexed previousOwner);
269   event OwnershipTransferred(
270     address indexed previousOwner,
271     address indexed newOwner
272   );
273 
274 
275   /**
276    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
277    * account.
278    */
279   constructor() public {
280     owner = msg.sender;
281   }
282 
283   /**
284    * @dev Throws if called by any account other than the owner.
285    */
286   modifier onlyOwner() {
287     require(msg.sender == owner);
288     _;
289   }
290 
291   /**
292    * @dev Allows the current owner to relinquish control of the contract.
293    * @notice Renouncing to ownership will leave the contract without an owner.
294    * It will not be possible to call the functions with the `onlyOwner`
295    * modifier anymore.
296    */
297   function renounceOwnership() public onlyOwner {
298     emit OwnershipRenounced(owner);
299     owner = address(0);
300   }
301 
302   /**
303    * @dev Allows the current owner to transfer control of the contract to a newOwner.
304    * @param _newOwner The address to transfer ownership to.
305    */
306   function transferOwnership(address _newOwner) public onlyOwner {
307     _transferOwnership(_newOwner);
308   }
309 
310   /**
311    * @dev Transfers control of the contract to a newOwner.
312    * @param _newOwner The address to transfer ownership to.
313    */
314   function _transferOwnership(address _newOwner) internal {
315     require(_newOwner != address(0));
316     emit OwnershipTransferred(owner, _newOwner);
317     owner = _newOwner;
318   }
319 }
320 
321 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\MintableToken.sol
322 
323 /**
324  * @title Mintable token
325  * @dev Simple ERC20 Token example, with mintable token creation
326  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
327  */
328 contract MintableToken is StandardToken, Ownable {
329   event Mint(address indexed to, uint256 amount);
330   event MintFinished();
331 
332   bool public mintingFinished = false;
333 
334 
335   modifier canMint() {
336     require(!mintingFinished);
337     _;
338   }
339 
340   modifier hasMintPermission() {
341     require(msg.sender == owner);
342     _;
343   }
344 
345   /**
346    * @dev Function to mint tokens
347    * @param _to The address that will receive the minted tokens.
348    * @param _amount The amount of tokens to mint.
349    * @return A boolean that indicates if the operation was successful.
350    */
351   function mint(
352     address _to,
353     uint256 _amount
354   )
355     public
356     hasMintPermission
357     canMint
358     returns (bool)
359   {
360     totalSupply_ = totalSupply_.add(_amount);
361     balances[_to] = balances[_to].add(_amount);
362     emit Mint(_to, _amount);
363     emit Transfer(address(0), _to, _amount);
364     return true;
365   }
366 
367   /**
368    * @dev Function to stop minting new tokens.
369    * @return True if the operation was successful.
370    */
371   function finishMinting() public onlyOwner canMint returns (bool) {
372     mintingFinished = true;
373     emit MintFinished();
374     return true;
375   }
376 }
377 
378 // File: contracts\PetlifeToken.sol
379 
380 contract PetlifeToken is MintableToken {
381     string public constant name = "PetlifeToken";
382     string public constant symbol = "Petl";
383     uint8 public constant decimals = 18;
384 }
385 
386 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\SafeERC20.sol
387 
388 /**
389  * @title SafeERC20
390  * @dev Wrappers around ERC20 operations that throw on failure.
391  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
392  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
393  */
394 library SafeERC20 {
395   function safeTransfer(
396     ERC20Basic _token,
397     address _to,
398     uint256 _value
399   )
400     internal
401   {
402     require(_token.transfer(_to, _value));
403   }
404 
405   function safeTransferFrom(
406     ERC20 _token,
407     address _from,
408     address _to,
409     uint256 _value
410   )
411     internal
412   {
413     require(_token.transferFrom(_from, _to, _value));
414   }
415 
416   function safeApprove(
417     ERC20 _token,
418     address _spender,
419     uint256 _value
420   )
421     internal
422   {
423     require(_token.approve(_spender, _value));
424   }
425 }
426 
427 // File: node_modules\openzeppelin-solidity\contracts\crowdsale\Crowdsale.sol
428 
429 /**
430  * @title Crowdsale
431  * @dev Crowdsale is a base contract for managing a token crowdsale,
432  * allowing investors to purchase tokens with ether. This contract implements
433  * such functionality in its most fundamental form and can be extended to provide additional
434  * functionality and/or custom behavior.
435  * The external interface represents the basic interface for purchasing tokens, and conform
436  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
437  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
438  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
439  * behavior.
440  */
441 contract Crowdsale {
442   using SafeMath for uint256;
443   using SafeERC20 for ERC20;
444 
445   // The token being sold
446   ERC20 public token;
447 
448   // Address where funds are collected
449   address public wallet;
450 
451   // How many token units a buyer gets per wei.
452   // The rate is the conversion between wei and the smallest and indivisible token unit.
453   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
454   // 1 wei will give you 1 unit, or 0.001 TOK.
455   uint256 public rate;
456 
457   // Amount of wei raised
458   uint256 public weiRaised;
459 
460   /**
461    * Event for token purchase logging
462    * @param purchaser who paid for the tokens
463    * @param beneficiary who got the tokens
464    * @param value weis paid for purchase
465    * @param amount amount of tokens purchased
466    */
467   event TokenPurchase(
468     address indexed purchaser,
469     address indexed beneficiary,
470     uint256 value,
471     uint256 amount
472   );
473 
474   /**
475    * @param _rate Number of token units a buyer gets per wei
476    * @param _wallet Address where collected funds will be forwarded to
477    * @param _token Address of the token being sold
478    */
479   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
480     require(_rate > 0);
481     require(_wallet != address(0));
482     require(_token != address(0));
483 
484     rate = _rate;
485     wallet = _wallet;
486     token = _token;
487   }
488 
489   // -----------------------------------------
490   // Crowdsale external interface
491   // -----------------------------------------
492 
493   /**
494    * @dev fallback function ***DO NOT OVERRIDE***
495    */
496   function () external payable {
497     buyTokens(msg.sender);
498   }
499 
500   /**
501    * @dev low level token purchase ***DO NOT OVERRIDE***
502    * @param _beneficiary Address performing the token purchase
503    */
504   function buyTokens(address _beneficiary) public payable {
505 
506     uint256 weiAmount = msg.value;
507     _preValidatePurchase(_beneficiary, weiAmount);
508 
509     // calculate token amount to be created
510     uint256 tokens = _getTokenAmount(weiAmount);
511 
512     // update state
513     weiRaised = weiRaised.add(weiAmount);
514 
515     _processPurchase(_beneficiary, tokens);
516     emit TokenPurchase(
517       msg.sender,
518       _beneficiary,
519       weiAmount,
520       tokens
521     );
522 
523     _updatePurchasingState(_beneficiary, weiAmount);
524 
525     _forwardFunds();
526     _postValidatePurchase(_beneficiary, weiAmount);
527   }
528 
529   // -----------------------------------------
530   // Internal interface (extensible)
531   // -----------------------------------------
532 
533   /**
534    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
535    * Example from CappedCrowdsale.sol's _preValidatePurchase method:
536    *   super._preValidatePurchase(_beneficiary, _weiAmount);
537    *   require(weiRaised.add(_weiAmount) <= cap);
538    * @param _beneficiary Address performing the token purchase
539    * @param _weiAmount Value in wei involved in the purchase
540    */
541   function _preValidatePurchase(
542     address _beneficiary,
543     uint256 _weiAmount
544   )
545     internal
546   {
547     require(_beneficiary != address(0));
548     require(_weiAmount != 0);
549   }
550 
551   /**
552    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
553    * @param _beneficiary Address performing the token purchase
554    * @param _weiAmount Value in wei involved in the purchase
555    */
556   function _postValidatePurchase(
557     address _beneficiary,
558     uint256 _weiAmount
559   )
560     internal
561   {
562     // optional override
563   }
564 
565   /**
566    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
567    * @param _beneficiary Address performing the token purchase
568    * @param _tokenAmount Number of tokens to be emitted
569    */
570   function _deliverTokens(
571     address _beneficiary,
572     uint256 _tokenAmount
573   )
574     internal
575   {
576     token.safeTransfer(_beneficiary, _tokenAmount);
577   }
578 
579   /**
580    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
581    * @param _beneficiary Address receiving the tokens
582    * @param _tokenAmount Number of tokens to be purchased
583    */
584   function _processPurchase(
585     address _beneficiary,
586     uint256 _tokenAmount
587   )
588     internal
589   {
590     _deliverTokens(_beneficiary, _tokenAmount);
591   }
592 
593   /**
594    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
595    * @param _beneficiary Address receiving the tokens
596    * @param _weiAmount Value in wei involved in the purchase
597    */
598   function _updatePurchasingState(
599     address _beneficiary,
600     uint256 _weiAmount
601   )
602     internal
603   {
604     // optional override
605   }
606 
607   /**
608    * @dev Override to extend the way in which ether is converted to tokens.
609    * @param _weiAmount Value in wei to be converted into tokens
610    * @return Number of tokens that can be purchased with the specified _weiAmount
611    */
612   function _getTokenAmount(uint256 _weiAmount)
613     internal view returns (uint256)
614   {
615     return _weiAmount.mul(rate);
616   }
617 
618   /**
619    * @dev Determines how ETH is stored/forwarded on purchases.
620    */
621   function _forwardFunds() internal {
622     wallet.transfer(msg.value);
623   }
624 }
625 
626 // File: node_modules\openzeppelin-solidity\contracts\crowdsale\emission\MintedCrowdsale.sol
627 
628 /**
629  * @title MintedCrowdsale
630  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
631  * Token ownership should be transferred to MintedCrowdsale for minting.
632  */
633 contract MintedCrowdsale is Crowdsale {
634 
635   /**
636    * @dev Overrides delivery by minting tokens upon purchase.
637    * @param _beneficiary Token purchaser
638    * @param _tokenAmount Number of tokens to be minted
639    */
640   function _deliverTokens(
641     address _beneficiary,
642     uint256 _tokenAmount
643   )
644     internal
645   {
646     // Potentially dangerous assumption about the type of the token.
647     require(MintableToken(address(token)).mint(_beneficiary, _tokenAmount));
648   }
649 }
650 
651 // File: node_modules\openzeppelin-solidity\contracts\crowdsale\validation\TimedCrowdsale.sol
652 
653 /**
654  * @title TimedCrowdsale
655  * @dev Crowdsale accepting contributions only within a time frame.
656  */
657 contract TimedCrowdsale is Crowdsale {
658   using SafeMath for uint256;
659 
660   uint256 public openingTime;
661   uint256 public closingTime;
662 
663   /**
664    * @dev Reverts if not in crowdsale time range.
665    */
666   modifier onlyWhileOpen {
667     // solium-disable-next-line security/no-block-members
668     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
669     _;
670   }
671 
672   /**
673    * @dev Constructor, takes crowdsale opening and closing times.
674    * @param _openingTime Crowdsale opening time
675    * @param _closingTime Crowdsale closing time
676    */
677   constructor(uint256 _openingTime, uint256 _closingTime) public {
678     // solium-disable-next-line security/no-block-members
679     //require(_openingTime >= block.timestamp);
680     require(_closingTime >= _openingTime);
681 
682     openingTime = _openingTime;
683     closingTime = _closingTime;
684   }
685 
686   /**
687    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
688    * @return Whether crowdsale period has elapsed
689    */
690   function hasClosed() public view returns (bool) {
691     // solium-disable-next-line security/no-block-members
692     return block.timestamp > closingTime;
693   }
694 
695   /**
696    * @dev Extend parent behavior requiring to be within contributing period
697    * @param _beneficiary Token purchaser
698    * @param _weiAmount Amount of wei contributed
699    */
700   function _preValidatePurchase(
701     address _beneficiary,
702     uint256 _weiAmount
703   )
704     internal
705     onlyWhileOpen
706   {
707     super._preValidatePurchase(_beneficiary, _weiAmount);
708   }
709 
710 }
711 
712 // File: node_modules\openzeppelin-solidity\contracts\crowdsale\distribution\FinalizableCrowdsale.sol
713 
714 /**
715  * @title FinalizableCrowdsale
716  * @dev Extension of Crowdsale where an owner can do extra work
717  * after finishing.
718  */
719 contract FinalizableCrowdsale is Ownable, TimedCrowdsale {
720   using SafeMath for uint256;
721 
722   bool public isFinalized = false;
723 
724   event Finalized();
725 
726   /**
727    * @dev Must be called after crowdsale ends, to do some extra finalization
728    * work. Calls the contract's finalization function.
729    */
730   function finalize() public onlyOwner {
731     require(!isFinalized);
732     //require(hasClosed());
733 
734     finalization();
735     emit Finalized();
736 
737     isFinalized = true;
738   }
739 
740   /**
741    * @dev Can be overridden to add finalization logic. The overriding function
742    * should call super.finalization() to ensure the chain of finalization is
743    * executed entirely.
744    */
745   function finalization() internal {
746   }
747 
748 }
749 
750 // File: contracts\PetlifeCrowdsale.sol
751 
752 contract PetlifeCrowdsale is MintedCrowdsale, FinalizableCrowdsale {
753  // ICO Stages
754   // ============
755   enum CrowdsaleStage { PrivateSale, ICOFirstStage, ICOSecondStage, ICOThirdStage }
756   CrowdsaleStage public stage = CrowdsaleStage.PrivateSale;
757   // =============
758 
759   // Token Distribution
760   // =============================
761   uint256 public privateCap = 30000000 * 10 ** 18;
762   uint256 public firstStageCap = 25000000 * 10 ** 18;
763   uint256 public secondStageCap = 20000000 * 10 ** 18;
764   uint256 public thirdStageCap = 28000000 * 10 ** 18;
765   uint256 public bonusPercent = 30;
766   uint256 public saleCap = 103000000 * 10 ** 18;
767   // ===================
768 
769   // Events
770   event EthTransferred(string text);
771   event EthRefunded(string text);
772 
773   // Constructor
774   // ============
775   MintableToken public token;
776   uint256 public mark;
777   constructor(uint256 _openingTime, uint256 _closingTime, uint256 _rate, address _wallet, MintableToken _token) FinalizableCrowdsale() TimedCrowdsale(_openingTime, _closingTime) Crowdsale(_rate, _wallet, _token) public {
778       token = _token;
779       require(_wallet != 0x0);
780   }
781   // =============
782 
783 
784   // ==================
785   // Crowdsale Stage Management
786   // =========================================================
787 
788   // Change Crowdsale Stage. Available Options: PrivateSale, ICOFirstStage, ICOSecondStage, ICOThirdStage
789   function setCrowdsaleStage(uint value) public onlyOwner {
790       CrowdsaleStage _stage;
791       if (uint(CrowdsaleStage.PrivateSale) == value) {
792         _stage = CrowdsaleStage.PrivateSale;
793       } else if (uint(CrowdsaleStage.ICOFirstStage) == value) {
794         _stage = CrowdsaleStage.ICOFirstStage;
795       } else if (uint(CrowdsaleStage.ICOSecondStage) == value) {
796         _stage = CrowdsaleStage.ICOSecondStage;
797       } else if (uint(CrowdsaleStage.ICOThirdStage) == value) {
798         _stage = CrowdsaleStage.ICOThirdStage;
799       }
800       stage = _stage;
801       if (stage == CrowdsaleStage.PrivateSale) {
802         setCurrentBonusPercent(30);
803       } else if (stage == CrowdsaleStage.ICOFirstStage) {
804         setCurrentBonusPercent(15);
805       } else if (stage == CrowdsaleStage.ICOSecondStage) {
806         setCurrentBonusPercent(5);
807       } else if (stage == CrowdsaleStage.ICOThirdStage) {
808         setCurrentBonusPercent(0);
809       }
810    }
811 
812   // Change the current rate
813   function setCurrentBonusPercent(uint256 _percent) private {
814       bonusPercent = _percent;
815   }
816 
817   // ================ Stage Management Over =====================
818 
819   // Token Purchase
820   // =========================
821   function _getTokenAmount(uint256 _weiAmount)
822     internal view returns (uint256)
823   {
824     return _weiAmount.mul(rate.mul(100+bonusPercent).div(100));
825   }
826 
827   function () external payable {
828       uint256 tokensThatWillBeMintedAfterPurchase = msg.value.mul(rate.mul(100+bonusPercent).div(100));
829       //Check if PrivateSale limit was hit
830       if ((stage == CrowdsaleStage.PrivateSale) && (token.totalSupply() + tokensThatWillBeMintedAfterPurchase > privateCap)) {
831         msg.sender.transfer(msg.value);
832         emit EthRefunded("PrivateSale Limit Hit");
833         return;
834       }
835       //Check if First Stage limit was hit
836       if ((stage == CrowdsaleStage.ICOFirstStage) && (token.totalSupply() + tokensThatWillBeMintedAfterPurchase > saleCap-thirdStageCap-secondStageCap)) {
837         msg.sender.transfer(msg.value);
838         emit EthRefunded("First Stage ICO Limit Hit");
839         return;
840       }
841       //Check if 5% bonus is avialable for Second Stage of ICO.
842       if ((stage == CrowdsaleStage.ICOSecondStage) && (token.totalSupply() > saleCap-thirdStageCap)) {
843         setCurrentBonusPercent(0);
844       }
845       //Check if all avialable tokens are sold
846       if (token.totalSupply() + tokensThatWillBeMintedAfterPurchase > saleCap) {
847         msg.sender.transfer(msg.value);
848         emit EthRefunded("ICO Limit Hit");
849         return;
850       }
851       //if passed all checks above - buy tokens
852       buyTokens(msg.sender);
853   }
854 
855   function forwardFunds() internal {
856     wallet.transfer(msg.value);
857     emit EthTransferred("forwarding funds to wallet");
858   }
859   // ===========================
860   // Final distribution and crowdsale finalization
861   // ====================================================================
862 
863   function finish(address _teamFund, address _reserveFund, address _bountyFund, address _advisoryFund) public onlyOwner {
864       require(!isFinalized);
865       uint256 alreadyMinted = token.totalSupply();
866       uint256 tokensForTeam = alreadyMinted.mul(15).div(100);
867       uint256 tokensForBounty = alreadyMinted.mul(2).div(100);
868       uint256 tokensForReserve = alreadyMinted.mul(175).div(1000);
869       uint256 tokensForAdvisors = alreadyMinted.mul(35).div(1000);
870       token.mint(_teamFund,tokensForTeam);
871       token.mint(_bountyFund,tokensForBounty);
872       token.mint(_reserveFund,tokensForReserve);
873       token.mint(_advisoryFund,tokensForAdvisors);
874       finalize();
875   }
876   
877   // ===========================
878   // Mint tokens manually (for non-ETH investing ways)
879   // ====================================================================
880   function mintManually(address _to, uint256 _amount) public onlyOwner {
881     require(!isFinalized);
882     token.mint(_to,_amount*10**18);
883   }
884   
885 }