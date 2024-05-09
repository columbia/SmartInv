1 pragma solidity ^0.4.24;
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
17 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
18 
19 /**
20  * @title Ownable
21  * @dev The Ownable contract has an owner address, and provides basic authorization control
22  * functions, this simplifies the implementation of "user permissions".
23  */
24 contract Ownable {
25   address public owner;
26 
27 
28   event OwnershipRenounced(address indexed previousOwner);
29   event OwnershipTransferred(
30     address indexed previousOwner,
31     address indexed newOwner
32   );
33 
34 
35   /**
36    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
37    * account.
38    */
39   constructor() public {
40     owner = msg.sender;
41   }
42 
43   /**
44    * @dev Throws if called by any account other than the owner.
45    */
46   modifier onlyOwner() {
47     require(msg.sender == owner);
48     _;
49   }
50 
51   /**
52    * @dev Allows the current owner to relinquish control of the contract.
53    * @notice Renouncing to ownership will leave the contract without an owner.
54    * It will not be possible to call the functions with the `onlyOwner`
55    * modifier anymore.
56    */
57   function renounceOwnership() public onlyOwner {
58     emit OwnershipRenounced(owner);
59     owner = address(0);
60   }
61 
62   /**
63    * @dev Allows the current owner to transfer control of the contract to a newOwner.
64    * @param _newOwner The address to transfer ownership to.
65    */
66   function transferOwnership(address _newOwner) public onlyOwner {
67     _transferOwnership(_newOwner);
68   }
69 
70   /**
71    * @dev Transfers control of the contract to a newOwner.
72    * @param _newOwner The address to transfer ownership to.
73    */
74   function _transferOwnership(address _newOwner) internal {
75     require(_newOwner != address(0));
76     emit OwnershipTransferred(owner, _newOwner);
77     owner = _newOwner;
78   }
79 }
80 
81 // File: eth-token-recover/contracts/TokenRecover.sol
82 
83 /**
84  * @title TokenRecover
85  * @author Vittorio Minacori (https://github.com/vittominacori)
86  * @dev Allow to recover any ERC20 sent into the contract for error
87  */
88 contract TokenRecover is Ownable {
89 
90   /**
91    * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
92    * @param _tokenAddress address The token contract address
93    * @param _tokens Number of tokens to be sent
94    * @return bool
95    */
96   function recoverERC20(
97     address _tokenAddress,
98     uint256 _tokens
99   )
100   public
101   onlyOwner
102   returns (bool success)
103   {
104     return ERC20Basic(_tokenAddress).transfer(owner, _tokens);
105   }
106 }
107 
108 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
109 
110 /**
111  * @title SafeMath
112  * @dev Math operations with safety checks that throw on error
113  */
114 library SafeMath {
115 
116   /**
117   * @dev Multiplies two numbers, throws on overflow.
118   */
119   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
120     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
121     // benefit is lost if 'b' is also tested.
122     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
123     if (_a == 0) {
124       return 0;
125     }
126 
127     c = _a * _b;
128     assert(c / _a == _b);
129     return c;
130   }
131 
132   /**
133   * @dev Integer division of two numbers, truncating the quotient.
134   */
135   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
136     // assert(_b > 0); // Solidity automatically throws when dividing by 0
137     // uint256 c = _a / _b;
138     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
139     return _a / _b;
140   }
141 
142   /**
143   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
144   */
145   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
146     assert(_b <= _a);
147     return _a - _b;
148   }
149 
150   /**
151   * @dev Adds two numbers, throws on overflow.
152   */
153   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
154     c = _a + _b;
155     assert(c >= _a);
156     return c;
157   }
158 }
159 
160 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
161 
162 /**
163  * @title ERC20 interface
164  * @dev see https://github.com/ethereum/EIPs/issues/20
165  */
166 contract ERC20 is ERC20Basic {
167   function allowance(address _owner, address _spender)
168     public view returns (uint256);
169 
170   function transferFrom(address _from, address _to, uint256 _value)
171     public returns (bool);
172 
173   function approve(address _spender, uint256 _value) public returns (bool);
174   event Approval(
175     address indexed owner,
176     address indexed spender,
177     uint256 value
178   );
179 }
180 
181 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
182 
183 /**
184  * @title SafeERC20
185  * @dev Wrappers around ERC20 operations that throw on failure.
186  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
187  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
188  */
189 library SafeERC20 {
190   function safeTransfer(
191     ERC20Basic _token,
192     address _to,
193     uint256 _value
194   )
195     internal
196   {
197     require(_token.transfer(_to, _value));
198   }
199 
200   function safeTransferFrom(
201     ERC20 _token,
202     address _from,
203     address _to,
204     uint256 _value
205   )
206     internal
207   {
208     require(_token.transferFrom(_from, _to, _value));
209   }
210 
211   function safeApprove(
212     ERC20 _token,
213     address _spender,
214     uint256 _value
215   )
216     internal
217   {
218     require(_token.approve(_spender, _value));
219   }
220 }
221 
222 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
223 
224 /**
225  * @title Crowdsale
226  * @dev Crowdsale is a base contract for managing a token crowdsale,
227  * allowing investors to purchase tokens with ether. This contract implements
228  * such functionality in its most fundamental form and can be extended to provide additional
229  * functionality and/or custom behavior.
230  * The external interface represents the basic interface for purchasing tokens, and conform
231  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
232  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
233  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
234  * behavior.
235  */
236 contract Crowdsale {
237   using SafeMath for uint256;
238   using SafeERC20 for ERC20;
239 
240   // The token being sold
241   ERC20 public token;
242 
243   // Address where funds are collected
244   address public wallet;
245 
246   // How many token units a buyer gets per wei.
247   // The rate is the conversion between wei and the smallest and indivisible token unit.
248   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
249   // 1 wei will give you 1 unit, or 0.001 TOK.
250   uint256 public rate;
251 
252   // Amount of wei raised
253   uint256 public weiRaised;
254 
255   /**
256    * Event for token purchase logging
257    * @param purchaser who paid for the tokens
258    * @param beneficiary who got the tokens
259    * @param value weis paid for purchase
260    * @param amount amount of tokens purchased
261    */
262   event TokenPurchase(
263     address indexed purchaser,
264     address indexed beneficiary,
265     uint256 value,
266     uint256 amount
267   );
268 
269   /**
270    * @param _rate Number of token units a buyer gets per wei
271    * @param _wallet Address where collected funds will be forwarded to
272    * @param _token Address of the token being sold
273    */
274   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
275     require(_rate > 0);
276     require(_wallet != address(0));
277     require(_token != address(0));
278 
279     rate = _rate;
280     wallet = _wallet;
281     token = _token;
282   }
283 
284   // -----------------------------------------
285   // Crowdsale external interface
286   // -----------------------------------------
287 
288   /**
289    * @dev fallback function ***DO NOT OVERRIDE***
290    */
291   function () external payable {
292     buyTokens(msg.sender);
293   }
294 
295   /**
296    * @dev low level token purchase ***DO NOT OVERRIDE***
297    * @param _beneficiary Address performing the token purchase
298    */
299   function buyTokens(address _beneficiary) public payable {
300 
301     uint256 weiAmount = msg.value;
302     _preValidatePurchase(_beneficiary, weiAmount);
303 
304     // calculate token amount to be created
305     uint256 tokens = _getTokenAmount(weiAmount);
306 
307     // update state
308     weiRaised = weiRaised.add(weiAmount);
309 
310     _processPurchase(_beneficiary, tokens);
311     emit TokenPurchase(
312       msg.sender,
313       _beneficiary,
314       weiAmount,
315       tokens
316     );
317 
318     _updatePurchasingState(_beneficiary, weiAmount);
319 
320     _forwardFunds();
321     _postValidatePurchase(_beneficiary, weiAmount);
322   }
323 
324   // -----------------------------------------
325   // Internal interface (extensible)
326   // -----------------------------------------
327 
328   /**
329    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
330    * Example from CappedCrowdsale.sol's _preValidatePurchase method: 
331    *   super._preValidatePurchase(_beneficiary, _weiAmount);
332    *   require(weiRaised.add(_weiAmount) <= cap);
333    * @param _beneficiary Address performing the token purchase
334    * @param _weiAmount Value in wei involved in the purchase
335    */
336   function _preValidatePurchase(
337     address _beneficiary,
338     uint256 _weiAmount
339   )
340     internal
341   {
342     require(_beneficiary != address(0));
343     require(_weiAmount != 0);
344   }
345 
346   /**
347    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
348    * @param _beneficiary Address performing the token purchase
349    * @param _weiAmount Value in wei involved in the purchase
350    */
351   function _postValidatePurchase(
352     address _beneficiary,
353     uint256 _weiAmount
354   )
355     internal
356   {
357     // optional override
358   }
359 
360   /**
361    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
362    * @param _beneficiary Address performing the token purchase
363    * @param _tokenAmount Number of tokens to be emitted
364    */
365   function _deliverTokens(
366     address _beneficiary,
367     uint256 _tokenAmount
368   )
369     internal
370   {
371     token.safeTransfer(_beneficiary, _tokenAmount);
372   }
373 
374   /**
375    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
376    * @param _beneficiary Address receiving the tokens
377    * @param _tokenAmount Number of tokens to be purchased
378    */
379   function _processPurchase(
380     address _beneficiary,
381     uint256 _tokenAmount
382   )
383     internal
384   {
385     _deliverTokens(_beneficiary, _tokenAmount);
386   }
387 
388   /**
389    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
390    * @param _beneficiary Address receiving the tokens
391    * @param _weiAmount Value in wei involved in the purchase
392    */
393   function _updatePurchasingState(
394     address _beneficiary,
395     uint256 _weiAmount
396   )
397     internal
398   {
399     // optional override
400   }
401 
402   /**
403    * @dev Override to extend the way in which ether is converted to tokens.
404    * @param _weiAmount Value in wei to be converted into tokens
405    * @return Number of tokens that can be purchased with the specified _weiAmount
406    */
407   function _getTokenAmount(uint256 _weiAmount)
408     internal view returns (uint256)
409   {
410     return _weiAmount.mul(rate);
411   }
412 
413   /**
414    * @dev Determines how ETH is stored/forwarded on purchases.
415    */
416   function _forwardFunds() internal {
417     wallet.transfer(msg.value);
418   }
419 }
420 
421 // File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
422 
423 /**
424  * @title TimedCrowdsale
425  * @dev Crowdsale accepting contributions only within a time frame.
426  */
427 contract TimedCrowdsale is Crowdsale {
428   using SafeMath for uint256;
429 
430   uint256 public openingTime;
431   uint256 public closingTime;
432 
433   /**
434    * @dev Reverts if not in crowdsale time range.
435    */
436   modifier onlyWhileOpen {
437     // solium-disable-next-line security/no-block-members
438     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
439     _;
440   }
441 
442   /**
443    * @dev Constructor, takes crowdsale opening and closing times.
444    * @param _openingTime Crowdsale opening time
445    * @param _closingTime Crowdsale closing time
446    */
447   constructor(uint256 _openingTime, uint256 _closingTime) public {
448     // solium-disable-next-line security/no-block-members
449     require(_openingTime >= block.timestamp);
450     require(_closingTime >= _openingTime);
451 
452     openingTime = _openingTime;
453     closingTime = _closingTime;
454   }
455 
456   /**
457    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
458    * @return Whether crowdsale period has elapsed
459    */
460   function hasClosed() public view returns (bool) {
461     // solium-disable-next-line security/no-block-members
462     return block.timestamp > closingTime;
463   }
464 
465   /**
466    * @dev Extend parent behavior requiring to be within contributing period
467    * @param _beneficiary Token purchaser
468    * @param _weiAmount Amount of wei contributed
469    */
470   function _preValidatePurchase(
471     address _beneficiary,
472     uint256 _weiAmount
473   )
474     internal
475     onlyWhileOpen
476   {
477     super._preValidatePurchase(_beneficiary, _weiAmount);
478   }
479 
480 }
481 
482 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
483 
484 /**
485  * @title Basic token
486  * @dev Basic version of StandardToken, with no allowances.
487  */
488 contract BasicToken is ERC20Basic {
489   using SafeMath for uint256;
490 
491   mapping(address => uint256) internal balances;
492 
493   uint256 internal totalSupply_;
494 
495   /**
496   * @dev Total number of tokens in existence
497   */
498   function totalSupply() public view returns (uint256) {
499     return totalSupply_;
500   }
501 
502   /**
503   * @dev Transfer token for a specified address
504   * @param _to The address to transfer to.
505   * @param _value The amount to be transferred.
506   */
507   function transfer(address _to, uint256 _value) public returns (bool) {
508     require(_value <= balances[msg.sender]);
509     require(_to != address(0));
510 
511     balances[msg.sender] = balances[msg.sender].sub(_value);
512     balances[_to] = balances[_to].add(_value);
513     emit Transfer(msg.sender, _to, _value);
514     return true;
515   }
516 
517   /**
518   * @dev Gets the balance of the specified address.
519   * @param _owner The address to query the the balance of.
520   * @return An uint256 representing the amount owned by the passed address.
521   */
522   function balanceOf(address _owner) public view returns (uint256) {
523     return balances[_owner];
524   }
525 
526 }
527 
528 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
529 
530 /**
531  * @title Standard ERC20 token
532  *
533  * @dev Implementation of the basic standard token.
534  * https://github.com/ethereum/EIPs/issues/20
535  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
536  */
537 contract StandardToken is ERC20, BasicToken {
538 
539   mapping (address => mapping (address => uint256)) internal allowed;
540 
541 
542   /**
543    * @dev Transfer tokens from one address to another
544    * @param _from address The address which you want to send tokens from
545    * @param _to address The address which you want to transfer to
546    * @param _value uint256 the amount of tokens to be transferred
547    */
548   function transferFrom(
549     address _from,
550     address _to,
551     uint256 _value
552   )
553     public
554     returns (bool)
555   {
556     require(_value <= balances[_from]);
557     require(_value <= allowed[_from][msg.sender]);
558     require(_to != address(0));
559 
560     balances[_from] = balances[_from].sub(_value);
561     balances[_to] = balances[_to].add(_value);
562     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
563     emit Transfer(_from, _to, _value);
564     return true;
565   }
566 
567   /**
568    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
569    * Beware that changing an allowance with this method brings the risk that someone may use both the old
570    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
571    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
572    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
573    * @param _spender The address which will spend the funds.
574    * @param _value The amount of tokens to be spent.
575    */
576   function approve(address _spender, uint256 _value) public returns (bool) {
577     allowed[msg.sender][_spender] = _value;
578     emit Approval(msg.sender, _spender, _value);
579     return true;
580   }
581 
582   /**
583    * @dev Function to check the amount of tokens that an owner allowed to a spender.
584    * @param _owner address The address which owns the funds.
585    * @param _spender address The address which will spend the funds.
586    * @return A uint256 specifying the amount of tokens still available for the spender.
587    */
588   function allowance(
589     address _owner,
590     address _spender
591    )
592     public
593     view
594     returns (uint256)
595   {
596     return allowed[_owner][_spender];
597   }
598 
599   /**
600    * @dev Increase the amount of tokens that an owner allowed to a spender.
601    * approve should be called when allowed[_spender] == 0. To increment
602    * allowed value is better to use this function to avoid 2 calls (and wait until
603    * the first transaction is mined)
604    * From MonolithDAO Token.sol
605    * @param _spender The address which will spend the funds.
606    * @param _addedValue The amount of tokens to increase the allowance by.
607    */
608   function increaseApproval(
609     address _spender,
610     uint256 _addedValue
611   )
612     public
613     returns (bool)
614   {
615     allowed[msg.sender][_spender] = (
616       allowed[msg.sender][_spender].add(_addedValue));
617     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
618     return true;
619   }
620 
621   /**
622    * @dev Decrease the amount of tokens that an owner allowed to a spender.
623    * approve should be called when allowed[_spender] == 0. To decrement
624    * allowed value is better to use this function to avoid 2 calls (and wait until
625    * the first transaction is mined)
626    * From MonolithDAO Token.sol
627    * @param _spender The address which will spend the funds.
628    * @param _subtractedValue The amount of tokens to decrease the allowance by.
629    */
630   function decreaseApproval(
631     address _spender,
632     uint256 _subtractedValue
633   )
634     public
635     returns (bool)
636   {
637     uint256 oldValue = allowed[msg.sender][_spender];
638     if (_subtractedValue >= oldValue) {
639       allowed[msg.sender][_spender] = 0;
640     } else {
641       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
642     }
643     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
644     return true;
645   }
646 
647 }
648 
649 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
650 
651 /**
652  * @title Mintable token
653  * @dev Simple ERC20 Token example, with mintable token creation
654  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
655  */
656 contract MintableToken is StandardToken, Ownable {
657   event Mint(address indexed to, uint256 amount);
658   event MintFinished();
659 
660   bool public mintingFinished = false;
661 
662 
663   modifier canMint() {
664     require(!mintingFinished);
665     _;
666   }
667 
668   modifier hasMintPermission() {
669     require(msg.sender == owner);
670     _;
671   }
672 
673   /**
674    * @dev Function to mint tokens
675    * @param _to The address that will receive the minted tokens.
676    * @param _amount The amount of tokens to mint.
677    * @return A boolean that indicates if the operation was successful.
678    */
679   function mint(
680     address _to,
681     uint256 _amount
682   )
683     public
684     hasMintPermission
685     canMint
686     returns (bool)
687   {
688     totalSupply_ = totalSupply_.add(_amount);
689     balances[_to] = balances[_to].add(_amount);
690     emit Mint(_to, _amount);
691     emit Transfer(address(0), _to, _amount);
692     return true;
693   }
694 
695   /**
696    * @dev Function to stop minting new tokens.
697    * @return True if the operation was successful.
698    */
699   function finishMinting() public onlyOwner canMint returns (bool) {
700     mintingFinished = true;
701     emit MintFinished();
702     return true;
703   }
704 }
705 
706 // File: openzeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol
707 
708 /**
709  * @title MintedCrowdsale
710  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
711  * Token ownership should be transferred to MintedCrowdsale for minting.
712  */
713 contract MintedCrowdsale is Crowdsale {
714 
715   /**
716    * @dev Overrides delivery by minting tokens upon purchase.
717    * @param _beneficiary Token purchaser
718    * @param _tokenAmount Number of tokens to be minted
719    */
720   function _deliverTokens(
721     address _beneficiary,
722     uint256 _tokenAmount
723   )
724     internal
725   {
726     // Potentially dangerous assumption about the type of the token.
727     require(MintableToken(address(token)).mint(_beneficiary, _tokenAmount));
728   }
729 }
730 
731 // File: contracts/crowdsale/base/TokenCappedCrowdsale.sol
732 
733 /**
734  * @title TokenCappedCrowdsale
735  * @author Vittorio Minacori (https://github.com/vittominacori)
736  * @dev Crowdsale with a limited amount of tokens to be sold
737  */
738 contract TokenCappedCrowdsale is Crowdsale {
739 
740   using SafeMath for uint256;
741 
742   uint256 public tokenCap;
743 
744   // Amount of token sold
745   uint256 public soldTokens;
746 
747   /**
748    * @dev Constructor, takes maximum amount of tokens to be sold in the crowdsale.
749    * @param _tokenCap Max amount of tokens to be sold
750    */
751   constructor(uint256 _tokenCap) public {
752     require(_tokenCap > 0);
753     tokenCap = _tokenCap;
754   }
755 
756   /**
757    * @dev Checks whether the tokenCap has been reached.
758    * @return Whether the tokenCap was reached
759    */
760   function tokenCapReached() public view returns (bool) {
761     return soldTokens >= tokenCap;
762   }
763 
764   /**
765    * @dev Extend parent behavior requiring purchase to respect the tokenCap.
766    * @param _beneficiary Token purchaser
767    * @param _weiAmount Amount of wei contributed
768    */
769   function _preValidatePurchase(
770     address _beneficiary,
771     uint256 _weiAmount
772   )
773   internal
774   {
775     super._preValidatePurchase(_beneficiary, _weiAmount);
776     require(soldTokens.add(_getTokenAmount(_weiAmount)) <= tokenCap);
777   }
778 
779   /**
780    * @dev Update the contributions contract states
781    * @param _beneficiary Address receiving the tokens
782    * @param _weiAmount Value in wei involved in the purchase
783    */
784   function _updatePurchasingState(
785     address _beneficiary,
786     uint256 _weiAmount
787   )
788   internal
789   {
790     super._updatePurchasingState(_beneficiary, _weiAmount);
791     soldTokens = soldTokens.add(_getTokenAmount(_weiAmount));
792   }
793 }
794 
795 // File: openzeppelin-solidity/contracts/access/rbac/Roles.sol
796 
797 /**
798  * @title Roles
799  * @author Francisco Giordano (@frangio)
800  * @dev Library for managing addresses assigned to a Role.
801  * See RBAC.sol for example usage.
802  */
803 library Roles {
804   struct Role {
805     mapping (address => bool) bearer;
806   }
807 
808   /**
809    * @dev give an address access to this role
810    */
811   function add(Role storage _role, address _addr)
812     internal
813   {
814     _role.bearer[_addr] = true;
815   }
816 
817   /**
818    * @dev remove an address' access to this role
819    */
820   function remove(Role storage _role, address _addr)
821     internal
822   {
823     _role.bearer[_addr] = false;
824   }
825 
826   /**
827    * @dev check if an address has this role
828    * // reverts
829    */
830   function check(Role storage _role, address _addr)
831     internal
832     view
833   {
834     require(has(_role, _addr));
835   }
836 
837   /**
838    * @dev check if an address has this role
839    * @return bool
840    */
841   function has(Role storage _role, address _addr)
842     internal
843     view
844     returns (bool)
845   {
846     return _role.bearer[_addr];
847   }
848 }
849 
850 // File: openzeppelin-solidity/contracts/access/rbac/RBAC.sol
851 
852 /**
853  * @title RBAC (Role-Based Access Control)
854  * @author Matt Condon (@Shrugs)
855  * @dev Stores and provides setters and getters for roles and addresses.
856  * Supports unlimited numbers of roles and addresses.
857  * See //contracts/mocks/RBACMock.sol for an example of usage.
858  * This RBAC method uses strings to key roles. It may be beneficial
859  * for you to write your own implementation of this interface using Enums or similar.
860  */
861 contract RBAC {
862   using Roles for Roles.Role;
863 
864   mapping (string => Roles.Role) private roles;
865 
866   event RoleAdded(address indexed operator, string role);
867   event RoleRemoved(address indexed operator, string role);
868 
869   /**
870    * @dev reverts if addr does not have role
871    * @param _operator address
872    * @param _role the name of the role
873    * // reverts
874    */
875   function checkRole(address _operator, string _role)
876     public
877     view
878   {
879     roles[_role].check(_operator);
880   }
881 
882   /**
883    * @dev determine if addr has role
884    * @param _operator address
885    * @param _role the name of the role
886    * @return bool
887    */
888   function hasRole(address _operator, string _role)
889     public
890     view
891     returns (bool)
892   {
893     return roles[_role].has(_operator);
894   }
895 
896   /**
897    * @dev add a role to an address
898    * @param _operator address
899    * @param _role the name of the role
900    */
901   function addRole(address _operator, string _role)
902     internal
903   {
904     roles[_role].add(_operator);
905     emit RoleAdded(_operator, _role);
906   }
907 
908   /**
909    * @dev remove a role from an address
910    * @param _operator address
911    * @param _role the name of the role
912    */
913   function removeRole(address _operator, string _role)
914     internal
915   {
916     roles[_role].remove(_operator);
917     emit RoleRemoved(_operator, _role);
918   }
919 
920   /**
921    * @dev modifier to scope access to a single role (uses msg.sender as addr)
922    * @param _role the name of the role
923    * // reverts
924    */
925   modifier onlyRole(string _role)
926   {
927     checkRole(msg.sender, _role);
928     _;
929   }
930 
931   /**
932    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
933    * @param _roles the names of the roles to scope access to
934    * // reverts
935    *
936    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
937    *  see: https://github.com/ethereum/solidity/issues/2467
938    */
939   // modifier onlyRoles(string[] _roles) {
940   //     bool hasAnyRole = false;
941   //     for (uint8 i = 0; i < _roles.length; i++) {
942   //         if (hasRole(msg.sender, _roles[i])) {
943   //             hasAnyRole = true;
944   //             break;
945   //         }
946   //     }
947 
948   //     require(hasAnyRole);
949 
950   //     _;
951   // }
952 }
953 
954 // File: contracts/crowdsale/utils/Contributions.sol
955 
956 /**
957  * @title Contributions
958  * @author Vittorio Minacori (https://github.com/vittominacori)
959  * @dev Utility contract where to save any information about Crowdsale contributions
960  */
961 contract Contributions is RBAC, Ownable {
962 
963   using SafeMath for uint256;
964 
965   string public constant ROLE_OPERATOR = "operator";
966 
967   modifier onlyOperator () {
968     checkRole(msg.sender, ROLE_OPERATOR);
969     _;
970   }
971 
972   uint256 public totalSoldTokens;
973   uint256 public totalWeiRaised;
974   mapping(address => uint256) public tokenBalances;
975   mapping(address => uint256) public weiContributions;
976   address[] public addresses;
977 
978   constructor() public {}
979 
980   /**
981    * @dev add contribution into the contributions array
982    * @param _address address
983    * @param _weiAmount uint256
984    * @param _tokenAmount uint256
985    */
986   function addBalance(
987     address _address,
988     uint256 _weiAmount,
989     uint256 _tokenAmount
990   )
991   public
992   onlyOperator
993   {
994     if (weiContributions[_address] == 0) {
995       addresses.push(_address);
996     }
997     weiContributions[_address] = weiContributions[_address].add(_weiAmount);
998     totalWeiRaised = totalWeiRaised.add(_weiAmount);
999 
1000     tokenBalances[_address] = tokenBalances[_address].add(_tokenAmount);
1001     totalSoldTokens = totalSoldTokens.add(_tokenAmount);
1002   }
1003 
1004   /**
1005    * @dev add a operator role to an address
1006    * @param _operator address
1007    */
1008   function addOperator(address _operator) public onlyOwner {
1009     addRole(_operator, ROLE_OPERATOR);
1010   }
1011 
1012   /**
1013    * @dev remove a operator role from an address
1014    * @param _operator address
1015    */
1016   function removeOperator(address _operator) public onlyOwner {
1017     removeRole(_operator, ROLE_OPERATOR);
1018   }
1019 
1020   /**
1021    * @dev return the contributions length
1022    * @return uint256
1023    */
1024   function getContributorsLength() public view returns (uint) {
1025     return addresses.length;
1026   }
1027 }
1028 
1029 // File: contracts/crowdsale/base/DefaultCrowdsale.sol
1030 
1031 /**
1032  * @title DefaultCrowdsale
1033  * @author Vittorio Minacori (https://github.com/vittominacori)
1034  * @dev Extends from Crowdsale with more stuffs like TimedCrowdsale, MintedCrowdsale, TokenCappedCrowdsale.
1035  *  Base for any other Crowdsale contract
1036  */
1037 contract DefaultCrowdsale is TimedCrowdsale, MintedCrowdsale, TokenCappedCrowdsale, TokenRecover { // solium-disable-line max-len
1038 
1039   Contributions public contributions;
1040 
1041   uint256 public minimumContribution;
1042   uint256 public maximumContribution;
1043   uint256 public transactionCount;
1044 
1045   constructor(
1046     uint256 _startTime,
1047     uint256 _endTime,
1048     uint256 _rate,
1049     address _wallet,
1050     uint256 _tokenCap,
1051     uint256 _minimumContribution,
1052     uint256 _maximumContribution,
1053     address _token,
1054     address _contributions
1055   )
1056   Crowdsale(_rate, _wallet, ERC20(_token))
1057   TimedCrowdsale(_startTime, _endTime)
1058   TokenCappedCrowdsale(_tokenCap)
1059   public
1060   {
1061     require(_maximumContribution >= _minimumContribution);
1062     require(_contributions != address(0));
1063 
1064     minimumContribution = _minimumContribution;
1065     maximumContribution = _maximumContribution;
1066     contributions = Contributions(_contributions);
1067   }
1068 
1069   // false if the ico is not started, true if the ico is started and running, true if the ico is completed
1070   function started() public view returns(bool) {
1071     // solium-disable-next-line security/no-block-members
1072     return block.timestamp >= openingTime;
1073   }
1074 
1075   // false if the ico is not started, false if the ico is started and running, true if the ico is completed
1076   function ended() public view returns(bool) {
1077     return hasClosed() || tokenCapReached();
1078   }
1079 
1080   /**
1081    * @dev Function to update conversion rate. To be used only in case of big ETH volatility
1082    * @param _rate The new rate
1083    */
1084   function updateRate(uint256 _rate) public onlyOwner {
1085     require(_rate > 0);
1086     rate = _rate;
1087   }
1088 
1089   /**
1090    * @dev Extend parent behavior requiring purchase to respect the minimum and maximum contribution limit
1091    * @param _beneficiary Token purchaser
1092    * @param _weiAmount Amount of wei contributed
1093    */
1094   function _preValidatePurchase(
1095     address _beneficiary,
1096     uint256 _weiAmount
1097   )
1098   internal
1099   {
1100     require(_weiAmount >= minimumContribution);
1101     require(
1102       contributions.weiContributions(_beneficiary).add(_weiAmount) <= maximumContribution
1103     );
1104     super._preValidatePurchase(_beneficiary, _weiAmount);
1105   }
1106 
1107   /**
1108    * @dev Update the contributions contract states
1109    * @param _beneficiary Address receiving the tokens
1110    * @param _weiAmount Value in wei involved in the purchase
1111    */
1112   function _updatePurchasingState(
1113     address _beneficiary,
1114     uint256 _weiAmount
1115   )
1116   internal
1117   {
1118     super._updatePurchasingState(_beneficiary, _weiAmount);
1119     contributions.addBalance(
1120       _beneficiary,
1121       _weiAmount,
1122       _getTokenAmount(_weiAmount)
1123     );
1124 
1125     transactionCount = transactionCount + 1;
1126   }
1127 }
1128 
1129 // File: contracts/crowdsale/base/TimedBonusCrowdsale.sol
1130 
1131 /**
1132  * @title TimedBonusCrowdsale
1133  * @author Vittorio Minacori (https://github.com/vittominacori)
1134  * @dev Extension of DefaultCrowdsale contract whose bonus decrease in time.
1135  */
1136 contract TimedBonusCrowdsale is DefaultCrowdsale {
1137 
1138   uint256[] public bonusDates;
1139   uint256[] public bonusRates;
1140 
1141   function setBonusRates(
1142     uint256[] _bonusDates,
1143     uint256[] _bonusRates
1144   )
1145   external
1146   onlyOwner
1147   {
1148     require(!started());
1149     require(_bonusDates.length == 2);
1150     require(_bonusRates.length == 2);
1151     require(_bonusDates[0] < _bonusDates[1]);
1152 
1153     bonusDates = _bonusDates;
1154     bonusRates = _bonusRates;
1155   }
1156 
1157   /**
1158    * @dev Override to extend the way in which ether is converted to tokens.
1159    * @param _weiAmount Value in wei to be converted into tokens
1160    * @return Number of tokens that can be purchased with the specified _weiAmount
1161    */
1162   function _getTokenAmount(
1163     uint256 _weiAmount
1164   )
1165   internal
1166   view
1167   returns (uint256)
1168   {
1169     uint256 bonusAmount = 0;
1170     uint256 tokenAmount = super._getTokenAmount(_weiAmount);
1171 
1172     if (bonusDates.length > 0) {
1173       uint256 bonusPercent = 0;
1174 
1175       // solium-disable-next-line security/no-block-members
1176       if (block.timestamp < bonusDates[0]) {
1177         bonusPercent = bonusRates[0];
1178       } else if (block.timestamp < bonusDates[1]) { // solium-disable-line security/no-block-members
1179         bonusPercent = bonusRates[1];
1180       }
1181 
1182       if (bonusPercent > 0) {
1183         bonusAmount = tokenAmount.mul(bonusPercent).div(100);
1184       }
1185     }
1186 
1187     return tokenAmount.add(bonusAmount);
1188   }
1189 }
1190 
1191 // File: contracts/crowdsale/ForkIco.sol
1192 
1193 /**
1194  * @title ForkIco
1195  * @author Vittorio Minacori (https://github.com/vittominacori)
1196  * @dev Extends from TimedBonusCrowdsale
1197  */
1198 contract ForkIco is TimedBonusCrowdsale {
1199 
1200   constructor(
1201     uint256 _startTime,
1202     uint256 _endTime,
1203     uint256 _rate,
1204     address _wallet,
1205     uint256 _tokenCap,
1206     uint256 _minimumContribution,
1207     uint256 _maximumContribution,
1208     address _token,
1209     address _contributions
1210   )
1211   DefaultCrowdsale(
1212     _startTime,
1213     _endTime,
1214     _rate,
1215     _wallet,
1216     _tokenCap,
1217     _minimumContribution,
1218     _maximumContribution,
1219     _token,
1220     _contributions
1221   )
1222   public
1223   {}
1224 
1225   function adjustTokenCap(uint256 _newTokenCap) external onlyOwner {
1226     require(_newTokenCap > 0);
1227     tokenCap = _newTokenCap;
1228   }
1229 }