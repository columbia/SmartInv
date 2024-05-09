1 pragma solidity ^0.4.25;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
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
55 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
56 
57 /**
58  * @title ERC20Basic
59  * @dev Simpler version of ERC20 interface
60  * See https://github.com/ethereum/EIPs/issues/179
61  */
62 contract ERC20Basic {
63   function totalSupply() public view returns (uint256);
64   function balanceOf(address _who) public view returns (uint256);
65   function transfer(address _to, uint256 _value) public returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
70 
71 /**
72  * @title ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/20
74  */
75 contract ERC20 is ERC20Basic {
76   function allowance(address _owner, address _spender)
77     public view returns (uint256);
78 
79   function transferFrom(address _from, address _to, uint256 _value)
80     public returns (bool);
81 
82   function approve(address _spender, uint256 _value) public returns (bool);
83   event Approval(
84     address indexed owner,
85     address indexed spender,
86     uint256 value
87   );
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
330 // File: contracts/crowdsale/base/TokenCappedCrowdsale.sol
331 
332 /**
333  * @title TokenCappedCrowdsale
334  * @dev Crowdsale with a limited amount of tokens to be sold
335  */
336 contract TokenCappedCrowdsale is Crowdsale {
337   using SafeMath for uint256;
338 
339   uint256 public tokenCap;
340 
341   // Amount of token sold
342   uint256 public soldTokens;
343 
344   constructor(uint256 _tokenCap) public {
345     require(_tokenCap > 0, "Token Cap should be greater than zero");
346     tokenCap = _tokenCap;
347   }
348 
349   function tokenCapReached() public view returns (bool) {
350     return soldTokens >= tokenCap;
351   }
352 
353   function _preValidatePurchase(
354     address _beneficiary,
355     uint256 _weiAmount
356   )
357     internal
358   {
359     require(
360       soldTokens.add(_getTokenAmount(_weiAmount)) <= tokenCap,
361       "Can't sell more than token cap tokens"
362     );
363     super._preValidatePurchase(_beneficiary, _weiAmount);
364   }
365 
366   function _updatePurchasingState(
367     address _beneficiary,
368     uint256 _weiAmount
369   )
370     internal
371   {
372     super._updatePurchasingState(_beneficiary, _weiAmount);
373     soldTokens = soldTokens.add(_getTokenAmount(_weiAmount));
374   }
375 }
376 
377 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
378 
379 /**
380  * @title Basic token
381  * @dev Basic version of StandardToken, with no allowances.
382  */
383 contract BasicToken is ERC20Basic {
384   using SafeMath for uint256;
385 
386   mapping(address => uint256) internal balances;
387 
388   uint256 internal totalSupply_;
389 
390   /**
391   * @dev Total number of tokens in existence
392   */
393   function totalSupply() public view returns (uint256) {
394     return totalSupply_;
395   }
396 
397   /**
398   * @dev Transfer token for a specified address
399   * @param _to The address to transfer to.
400   * @param _value The amount to be transferred.
401   */
402   function transfer(address _to, uint256 _value) public returns (bool) {
403     require(_value <= balances[msg.sender]);
404     require(_to != address(0));
405 
406     balances[msg.sender] = balances[msg.sender].sub(_value);
407     balances[_to] = balances[_to].add(_value);
408     emit Transfer(msg.sender, _to, _value);
409     return true;
410   }
411 
412   /**
413   * @dev Gets the balance of the specified address.
414   * @param _owner The address to query the the balance of.
415   * @return An uint256 representing the amount owned by the passed address.
416   */
417   function balanceOf(address _owner) public view returns (uint256) {
418     return balances[_owner];
419   }
420 
421 }
422 
423 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
424 
425 /**
426  * @title Standard ERC20 token
427  *
428  * @dev Implementation of the basic standard token.
429  * https://github.com/ethereum/EIPs/issues/20
430  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
431  */
432 contract StandardToken is ERC20, BasicToken {
433 
434   mapping (address => mapping (address => uint256)) internal allowed;
435 
436 
437   /**
438    * @dev Transfer tokens from one address to another
439    * @param _from address The address which you want to send tokens from
440    * @param _to address The address which you want to transfer to
441    * @param _value uint256 the amount of tokens to be transferred
442    */
443   function transferFrom(
444     address _from,
445     address _to,
446     uint256 _value
447   )
448     public
449     returns (bool)
450   {
451     require(_value <= balances[_from]);
452     require(_value <= allowed[_from][msg.sender]);
453     require(_to != address(0));
454 
455     balances[_from] = balances[_from].sub(_value);
456     balances[_to] = balances[_to].add(_value);
457     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
458     emit Transfer(_from, _to, _value);
459     return true;
460   }
461 
462   /**
463    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
464    * Beware that changing an allowance with this method brings the risk that someone may use both the old
465    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
466    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
467    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
468    * @param _spender The address which will spend the funds.
469    * @param _value The amount of tokens to be spent.
470    */
471   function approve(address _spender, uint256 _value) public returns (bool) {
472     allowed[msg.sender][_spender] = _value;
473     emit Approval(msg.sender, _spender, _value);
474     return true;
475   }
476 
477   /**
478    * @dev Function to check the amount of tokens that an owner allowed to a spender.
479    * @param _owner address The address which owns the funds.
480    * @param _spender address The address which will spend the funds.
481    * @return A uint256 specifying the amount of tokens still available for the spender.
482    */
483   function allowance(
484     address _owner,
485     address _spender
486    )
487     public
488     view
489     returns (uint256)
490   {
491     return allowed[_owner][_spender];
492   }
493 
494   /**
495    * @dev Increase the amount of tokens that an owner allowed to a spender.
496    * approve should be called when allowed[_spender] == 0. To increment
497    * allowed value is better to use this function to avoid 2 calls (and wait until
498    * the first transaction is mined)
499    * From MonolithDAO Token.sol
500    * @param _spender The address which will spend the funds.
501    * @param _addedValue The amount of tokens to increase the allowance by.
502    */
503   function increaseApproval(
504     address _spender,
505     uint256 _addedValue
506   )
507     public
508     returns (bool)
509   {
510     allowed[msg.sender][_spender] = (
511       allowed[msg.sender][_spender].add(_addedValue));
512     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
513     return true;
514   }
515 
516   /**
517    * @dev Decrease the amount of tokens that an owner allowed to a spender.
518    * approve should be called when allowed[_spender] == 0. To decrement
519    * allowed value is better to use this function to avoid 2 calls (and wait until
520    * the first transaction is mined)
521    * From MonolithDAO Token.sol
522    * @param _spender The address which will spend the funds.
523    * @param _subtractedValue The amount of tokens to decrease the allowance by.
524    */
525   function decreaseApproval(
526     address _spender,
527     uint256 _subtractedValue
528   )
529     public
530     returns (bool)
531   {
532     uint256 oldValue = allowed[msg.sender][_spender];
533     if (_subtractedValue >= oldValue) {
534       allowed[msg.sender][_spender] = 0;
535     } else {
536       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
537     }
538     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
539     return true;
540   }
541 
542 }
543 
544 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
545 
546 /**
547  * @title Ownable
548  * @dev The Ownable contract has an owner address, and provides basic authorization control
549  * functions, this simplifies the implementation of "user permissions".
550  */
551 contract Ownable {
552   address public owner;
553 
554 
555   event OwnershipRenounced(address indexed previousOwner);
556   event OwnershipTransferred(
557     address indexed previousOwner,
558     address indexed newOwner
559   );
560 
561 
562   /**
563    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
564    * account.
565    */
566   constructor() public {
567     owner = msg.sender;
568   }
569 
570   /**
571    * @dev Throws if called by any account other than the owner.
572    */
573   modifier onlyOwner() {
574     require(msg.sender == owner);
575     _;
576   }
577 
578   /**
579    * @dev Allows the current owner to relinquish control of the contract.
580    * @notice Renouncing to ownership will leave the contract without an owner.
581    * It will not be possible to call the functions with the `onlyOwner`
582    * modifier anymore.
583    */
584   function renounceOwnership() public onlyOwner {
585     emit OwnershipRenounced(owner);
586     owner = address(0);
587   }
588 
589   /**
590    * @dev Allows the current owner to transfer control of the contract to a newOwner.
591    * @param _newOwner The address to transfer ownership to.
592    */
593   function transferOwnership(address _newOwner) public onlyOwner {
594     _transferOwnership(_newOwner);
595   }
596 
597   /**
598    * @dev Transfers control of the contract to a newOwner.
599    * @param _newOwner The address to transfer ownership to.
600    */
601   function _transferOwnership(address _newOwner) internal {
602     require(_newOwner != address(0));
603     emit OwnershipTransferred(owner, _newOwner);
604     owner = _newOwner;
605   }
606 }
607 
608 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
609 
610 /**
611  * @title Mintable token
612  * @dev Simple ERC20 Token example, with mintable token creation
613  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
614  */
615 contract MintableToken is StandardToken, Ownable {
616   event Mint(address indexed to, uint256 amount);
617   event MintFinished();
618 
619   bool public mintingFinished = false;
620 
621 
622   modifier canMint() {
623     require(!mintingFinished);
624     _;
625   }
626 
627   modifier hasMintPermission() {
628     require(msg.sender == owner);
629     _;
630   }
631 
632   /**
633    * @dev Function to mint tokens
634    * @param _to The address that will receive the minted tokens.
635    * @param _amount The amount of tokens to mint.
636    * @return A boolean that indicates if the operation was successful.
637    */
638   function mint(
639     address _to,
640     uint256 _amount
641   )
642     public
643     hasMintPermission
644     canMint
645     returns (bool)
646   {
647     totalSupply_ = totalSupply_.add(_amount);
648     balances[_to] = balances[_to].add(_amount);
649     emit Mint(_to, _amount);
650     emit Transfer(address(0), _to, _amount);
651     return true;
652   }
653 
654   /**
655    * @dev Function to stop minting new tokens.
656    * @return True if the operation was successful.
657    */
658   function finishMinting() public onlyOwner canMint returns (bool) {
659     mintingFinished = true;
660     emit MintFinished();
661     return true;
662   }
663 }
664 
665 // File: openzeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol
666 
667 /**
668  * @title MintedCrowdsale
669  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
670  * Token ownership should be transferred to MintedCrowdsale for minting.
671  */
672 contract MintedCrowdsale is Crowdsale {
673 
674   /**
675    * @dev Overrides delivery by minting tokens upon purchase.
676    * @param _beneficiary Token purchaser
677    * @param _tokenAmount Number of tokens to be minted
678    */
679   function _deliverTokens(
680     address _beneficiary,
681     uint256 _tokenAmount
682   )
683     internal
684   {
685     // Potentially dangerous assumption about the type of the token.
686     require(MintableToken(address(token)).mint(_beneficiary, _tokenAmount));
687   }
688 }
689 
690 // File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
691 
692 /**
693  * @title TimedCrowdsale
694  * @dev Crowdsale accepting contributions only within a time frame.
695  */
696 contract TimedCrowdsale is Crowdsale {
697   using SafeMath for uint256;
698 
699   uint256 public openingTime;
700   uint256 public closingTime;
701 
702   /**
703    * @dev Reverts if not in crowdsale time range.
704    */
705   modifier onlyWhileOpen {
706     // solium-disable-next-line security/no-block-members
707     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
708     _;
709   }
710 
711   /**
712    * @dev Constructor, takes crowdsale opening and closing times.
713    * @param _openingTime Crowdsale opening time
714    * @param _closingTime Crowdsale closing time
715    */
716   constructor(uint256 _openingTime, uint256 _closingTime) public {
717     // solium-disable-next-line security/no-block-members
718     require(_openingTime >= block.timestamp);
719     require(_closingTime >= _openingTime);
720 
721     openingTime = _openingTime;
722     closingTime = _closingTime;
723   }
724 
725   /**
726    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
727    * @return Whether crowdsale period has elapsed
728    */
729   function hasClosed() public view returns (bool) {
730     // solium-disable-next-line security/no-block-members
731     return block.timestamp > closingTime;
732   }
733 
734   /**
735    * @dev Extend parent behavior requiring to be within contributing period
736    * @param _beneficiary Token purchaser
737    * @param _weiAmount Amount of wei contributed
738    */
739   function _preValidatePurchase(
740     address _beneficiary,
741     uint256 _weiAmount
742   )
743     internal
744     onlyWhileOpen
745   {
746     super._preValidatePurchase(_beneficiary, _weiAmount);
747   }
748 
749 }
750 
751 // File: eth-token-recover/contracts/TokenRecover.sol
752 
753 /**
754  * @title TokenRecover
755  * @author Vittorio Minacori (https://github.com/vittominacori)
756  * @dev Allow to recover any ERC20 sent into the contract for error
757  */
758 contract TokenRecover is Ownable {
759 
760   /**
761    * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
762    * @param _tokenAddress address The token contract address
763    * @param _tokens Number of tokens to be sent
764    * @return bool
765    */
766   function recoverERC20(
767     address _tokenAddress,
768     uint256 _tokens
769   )
770   public
771   onlyOwner
772   returns (bool success)
773   {
774     return ERC20Basic(_tokenAddress).transfer(owner, _tokens);
775   }
776 }
777 
778 // File: openzeppelin-solidity/contracts/access/rbac/Roles.sol
779 
780 /**
781  * @title Roles
782  * @author Francisco Giordano (@frangio)
783  * @dev Library for managing addresses assigned to a Role.
784  * See RBAC.sol for example usage.
785  */
786 library Roles {
787   struct Role {
788     mapping (address => bool) bearer;
789   }
790 
791   /**
792    * @dev give an address access to this role
793    */
794   function add(Role storage _role, address _addr)
795     internal
796   {
797     _role.bearer[_addr] = true;
798   }
799 
800   /**
801    * @dev remove an address' access to this role
802    */
803   function remove(Role storage _role, address _addr)
804     internal
805   {
806     _role.bearer[_addr] = false;
807   }
808 
809   /**
810    * @dev check if an address has this role
811    * // reverts
812    */
813   function check(Role storage _role, address _addr)
814     internal
815     view
816   {
817     require(has(_role, _addr));
818   }
819 
820   /**
821    * @dev check if an address has this role
822    * @return bool
823    */
824   function has(Role storage _role, address _addr)
825     internal
826     view
827     returns (bool)
828   {
829     return _role.bearer[_addr];
830   }
831 }
832 
833 // File: openzeppelin-solidity/contracts/access/rbac/RBAC.sol
834 
835 /**
836  * @title RBAC (Role-Based Access Control)
837  * @author Matt Condon (@Shrugs)
838  * @dev Stores and provides setters and getters for roles and addresses.
839  * Supports unlimited numbers of roles and addresses.
840  * See //contracts/mocks/RBACMock.sol for an example of usage.
841  * This RBAC method uses strings to key roles. It may be beneficial
842  * for you to write your own implementation of this interface using Enums or similar.
843  */
844 contract RBAC {
845   using Roles for Roles.Role;
846 
847   mapping (string => Roles.Role) private roles;
848 
849   event RoleAdded(address indexed operator, string role);
850   event RoleRemoved(address indexed operator, string role);
851 
852   /**
853    * @dev reverts if addr does not have role
854    * @param _operator address
855    * @param _role the name of the role
856    * // reverts
857    */
858   function checkRole(address _operator, string _role)
859     public
860     view
861   {
862     roles[_role].check(_operator);
863   }
864 
865   /**
866    * @dev determine if addr has role
867    * @param _operator address
868    * @param _role the name of the role
869    * @return bool
870    */
871   function hasRole(address _operator, string _role)
872     public
873     view
874     returns (bool)
875   {
876     return roles[_role].has(_operator);
877   }
878 
879   /**
880    * @dev add a role to an address
881    * @param _operator address
882    * @param _role the name of the role
883    */
884   function addRole(address _operator, string _role)
885     internal
886   {
887     roles[_role].add(_operator);
888     emit RoleAdded(_operator, _role);
889   }
890 
891   /**
892    * @dev remove a role from an address
893    * @param _operator address
894    * @param _role the name of the role
895    */
896   function removeRole(address _operator, string _role)
897     internal
898   {
899     roles[_role].remove(_operator);
900     emit RoleRemoved(_operator, _role);
901   }
902 
903   /**
904    * @dev modifier to scope access to a single role (uses msg.sender as addr)
905    * @param _role the name of the role
906    * // reverts
907    */
908   modifier onlyRole(string _role)
909   {
910     checkRole(msg.sender, _role);
911     _;
912   }
913 
914   /**
915    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
916    * @param _roles the names of the roles to scope access to
917    * // reverts
918    *
919    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
920    *  see: https://github.com/ethereum/solidity/issues/2467
921    */
922   // modifier onlyRoles(string[] _roles) {
923   //     bool hasAnyRole = false;
924   //     for (uint8 i = 0; i < _roles.length; i++) {
925   //         if (hasRole(msg.sender, _roles[i])) {
926   //             hasAnyRole = true;
927   //             break;
928   //         }
929   //     }
930 
931   //     require(hasAnyRole);
932 
933   //     _;
934   // }
935 }
936 
937 // File: contracts/crowdsale/utils/Contributions.sol
938 
939 contract Contributions is RBAC, Ownable {
940   using SafeMath for uint256;
941 
942   uint256 private constant TIER_DELETED = 999;
943   string public constant ROLE_MINTER = "minter";
944   string public constant ROLE_OPERATOR = "operator";
945 
946   uint256 public tierLimit;
947 
948   modifier onlyMinter () {
949     checkRole(msg.sender, ROLE_MINTER);
950     _;
951   }
952 
953   modifier onlyOperator () {
954     checkRole(msg.sender, ROLE_OPERATOR);
955     _;
956   }
957 
958   uint256 public totalSoldTokens;
959   mapping(address => uint256) public tokenBalances;
960   mapping(address => uint256) public ethContributions;
961   mapping(address => uint256) private _whitelistTier;
962   address[] public tokenAddresses;
963   address[] public ethAddresses;
964   address[] private whitelistAddresses;
965 
966   constructor(uint256 _tierLimit) public {
967     addRole(owner, ROLE_OPERATOR);
968     tierLimit = _tierLimit;
969   }
970 
971   function addMinter(address minter) external onlyOwner {
972     addRole(minter, ROLE_MINTER);
973   }
974 
975   function removeMinter(address minter) external onlyOwner {
976     removeRole(minter, ROLE_MINTER);
977   }
978 
979   function addOperator(address _operator) external onlyOwner {
980     addRole(_operator, ROLE_OPERATOR);
981   }
982 
983   function removeOperator(address _operator) external onlyOwner {
984     removeRole(_operator, ROLE_OPERATOR);
985   }
986 
987   function addTokenBalance(
988     address _address,
989     uint256 _tokenAmount
990   )
991     external
992     onlyMinter
993   {
994     if (tokenBalances[_address] == 0) {
995       tokenAddresses.push(_address);
996     }
997     tokenBalances[_address] = tokenBalances[_address].add(_tokenAmount);
998     totalSoldTokens = totalSoldTokens.add(_tokenAmount);
999   }
1000 
1001   function addEthContribution(
1002     address _address,
1003     uint256 _weiAmount
1004   )
1005     external
1006     onlyMinter
1007   {
1008     if (ethContributions[_address] == 0) {
1009       ethAddresses.push(_address);
1010     }
1011     ethContributions[_address] = ethContributions[_address].add(_weiAmount);
1012   }
1013 
1014   function setTierLimit(uint256 _newTierLimit) external onlyOperator {
1015     require(_newTierLimit > 0, "Tier must be greater than zero");
1016 
1017     tierLimit = _newTierLimit;
1018   }
1019 
1020   function addToWhitelist(
1021     address _investor,
1022     uint256 _tier
1023   )
1024     external
1025     onlyOperator
1026   {
1027     require(_tier == 1 || _tier == 2, "Only two tier level available");
1028     if (_whitelistTier[_investor] == 0) {
1029       whitelistAddresses.push(_investor);
1030     }
1031     _whitelistTier[_investor] = _tier;
1032   }
1033 
1034   function removeFromWhitelist(address _investor) external onlyOperator {
1035     _whitelistTier[_investor] = TIER_DELETED;
1036   }
1037 
1038   function whitelistTier(address _investor) external view returns (uint256) {
1039     return _whitelistTier[_investor] <= 2 ? _whitelistTier[_investor] : 0;
1040   }
1041 
1042   function getWhitelistedAddresses(
1043     uint256 _tier
1044   )
1045     external
1046     view
1047     returns (address[])
1048   {
1049     address[] memory tmp = new address[](whitelistAddresses.length);
1050 
1051     uint y = 0;
1052     if (_tier == 1 || _tier == 2) {
1053       uint len = whitelistAddresses.length;
1054       for (uint i = 0; i < len; i++) {
1055         if (_whitelistTier[whitelistAddresses[i]] == _tier) {
1056           tmp[y] = whitelistAddresses[i];
1057           y++;
1058         }
1059       }
1060     }
1061 
1062     address[] memory toReturn = new address[](y);
1063 
1064     for (uint k = 0; k < y; k++) {
1065       toReturn[k] = tmp[k];
1066     }
1067 
1068     return toReturn;
1069   }
1070 
1071   function isAllowedPurchase(
1072     address _beneficiary,
1073     uint256 _weiAmount
1074   )
1075     external
1076     view
1077     returns (bool)
1078   {
1079     if (_whitelistTier[_beneficiary] == 2) {
1080       return true;
1081     } else if (_whitelistTier[_beneficiary] == 1 && ethContributions[_beneficiary].add(_weiAmount) <= tierLimit) {
1082       return true;
1083     }
1084 
1085     return false;
1086   }
1087 
1088   function getTokenAddressesLength() external view returns (uint) {
1089     return tokenAddresses.length;
1090   }
1091 
1092   function getEthAddressesLength() external view returns (uint) {
1093     return ethAddresses.length;
1094   }
1095 }
1096 
1097 // File: contracts/crowdsale/base/DefaultICO.sol
1098 
1099 // solium-disable-next-line max-len
1100 
1101 
1102 
1103 
1104 contract DefaultICO is TimedCrowdsale, TokenRecover {
1105 
1106   Contributions public contributions;
1107 
1108   uint256 public minimumContribution;
1109   uint256 public tierZero;
1110 
1111   constructor(
1112     uint256 _openingTime,
1113     uint256 _closingTime,
1114     uint256 _rate,
1115     address _wallet,
1116     uint256 _minimumContribution,
1117     address _token,
1118     address _contributions,
1119     uint256 _tierZero
1120   )
1121     Crowdsale(_rate, _wallet, ERC20(_token))
1122     TimedCrowdsale(_openingTime, _closingTime)
1123     public
1124   {
1125     require(
1126       _contributions != address(0),
1127       "Contributions address can't be the zero address."
1128     );
1129     contributions = Contributions(_contributions);
1130     minimumContribution = _minimumContribution;
1131     tierZero = _tierZero;
1132   }
1133 
1134   // Utility methods
1135 
1136   // false if the ico is not started, true if the ico is started and running, true if the ico is completed
1137   function started() public view returns(bool) {
1138     // solium-disable-next-line security/no-block-members
1139     return block.timestamp >= openingTime;
1140   }
1141 
1142   function setTierZero(uint256 _newTierZero) external onlyOwner {
1143     tierZero = _newTierZero;
1144   }
1145 
1146   /**
1147    * @dev Extend parent behavior requiring purchase to respect the minimumContribution.
1148    * @param _beneficiary Token purchaser
1149    * @param _weiAmount Amount of wei contributed
1150    */
1151   function _preValidatePurchase(
1152     address _beneficiary,
1153     uint256 _weiAmount
1154   )
1155     internal
1156   {
1157     require(
1158       _weiAmount >= minimumContribution,
1159       "Can't send less than the minimum contribution"
1160     );
1161 
1162     // solium-disable-next-line max-len
1163     if (contributions.ethContributions(_beneficiary).add(_weiAmount) > tierZero) {
1164       require(
1165         contributions.isAllowedPurchase(_beneficiary, _weiAmount),
1166         "Beneficiary is not allowed to purchase this amount"
1167       );
1168     }
1169 
1170     super._preValidatePurchase(_beneficiary, _weiAmount);
1171   }
1172 
1173 
1174   /**
1175    * @dev Extend parent behavior to update user contributions
1176    * @param _beneficiary Token purchaser
1177    * @param _weiAmount Amount of wei contributed
1178    */
1179   function _updatePurchasingState(
1180     address _beneficiary,
1181     uint256 _weiAmount
1182   )
1183     internal
1184   {
1185     super._updatePurchasingState(_beneficiary, _weiAmount);
1186     contributions.addEthContribution(_beneficiary, _weiAmount);
1187   }
1188 
1189   /**
1190    * @dev Extend parent behavior to add contributions log
1191    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
1192    * @param _beneficiary Address receiving the tokens
1193    * @param _tokenAmount Number of tokens to be purchased
1194    */
1195   function _processPurchase(
1196     address _beneficiary,
1197     uint256 _tokenAmount
1198   )
1199     internal
1200   {
1201     super._processPurchase(_beneficiary, _tokenAmount);
1202     contributions.addTokenBalance(_beneficiary, _tokenAmount);
1203   }
1204 }
1205 
1206 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
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
1226 // File: openzeppelin-solidity/contracts/token/ERC20/RBACMintableToken.sol
1227 
1228 /**
1229  * @title RBACMintableToken
1230  * @author Vittorio Minacori (@vittominacori)
1231  * @dev Mintable Token, with RBAC minter permissions
1232  */
1233 contract RBACMintableToken is MintableToken, RBAC {
1234   /**
1235    * A constant role name for indicating minters.
1236    */
1237   string public constant ROLE_MINTER = "minter";
1238 
1239   /**
1240    * @dev override the Mintable token modifier to add role based logic
1241    */
1242   modifier hasMintPermission() {
1243     checkRole(msg.sender, ROLE_MINTER);
1244     _;
1245   }
1246 
1247   /**
1248    * @dev add a minter role to an address
1249    * @param _minter address
1250    */
1251   function addMinter(address _minter) public onlyOwner {
1252     addRole(_minter, ROLE_MINTER);
1253   }
1254 
1255   /**
1256    * @dev remove a minter role from an address
1257    * @param _minter address
1258    */
1259   function removeMinter(address _minter) public onlyOwner {
1260     removeRole(_minter, ROLE_MINTER);
1261   }
1262 }
1263 
1264 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
1265 
1266 /**
1267  * @title Burnable Token
1268  * @dev Token that can be irreversibly burned (destroyed).
1269  */
1270 contract BurnableToken is BasicToken {
1271 
1272   event Burn(address indexed burner, uint256 value);
1273 
1274   /**
1275    * @dev Burns a specific amount of tokens.
1276    * @param _value The amount of token to be burned.
1277    */
1278   function burn(uint256 _value) public {
1279     _burn(msg.sender, _value);
1280   }
1281 
1282   function _burn(address _who, uint256 _value) internal {
1283     require(_value <= balances[_who]);
1284     // no need to require value <= totalSupply, since that would imply the
1285     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
1286 
1287     balances[_who] = balances[_who].sub(_value);
1288     totalSupply_ = totalSupply_.sub(_value);
1289     emit Burn(_who, _value);
1290     emit Transfer(_who, address(0), _value);
1291   }
1292 }
1293 
1294 // File: openzeppelin-solidity/contracts/AddressUtils.sol
1295 
1296 /**
1297  * Utility library of inline functions on addresses
1298  */
1299 library AddressUtils {
1300 
1301   /**
1302    * Returns whether the target address is a contract
1303    * @dev This function will return false if invoked during the constructor of a contract,
1304    * as the code is not actually created until after the constructor finishes.
1305    * @param _addr address to check
1306    * @return whether the target address is a contract
1307    */
1308   function isContract(address _addr) internal view returns (bool) {
1309     uint256 size;
1310     // XXX Currently there is no better way to check if there is a contract in an address
1311     // than to check the size of the code at that address.
1312     // See https://ethereum.stackexchange.com/a/14016/36603
1313     // for more details about how this works.
1314     // TODO Check this again before the Serenity release, because all addresses will be
1315     // contracts then.
1316     // solium-disable-next-line security/no-inline-assembly
1317     assembly { size := extcodesize(_addr) }
1318     return size > 0;
1319   }
1320 
1321 }
1322 
1323 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
1324 
1325 /**
1326  * @title ERC165
1327  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
1328  */
1329 interface ERC165 {
1330 
1331   /**
1332    * @notice Query if a contract implements an interface
1333    * @param _interfaceId The interface identifier, as specified in ERC-165
1334    * @dev Interface identification is specified in ERC-165. This function
1335    * uses less than 30,000 gas.
1336    */
1337   function supportsInterface(bytes4 _interfaceId)
1338     external
1339     view
1340     returns (bool);
1341 }
1342 
1343 // File: openzeppelin-solidity/contracts/introspection/SupportsInterfaceWithLookup.sol
1344 
1345 /**
1346  * @title SupportsInterfaceWithLookup
1347  * @author Matt Condon (@shrugs)
1348  * @dev Implements ERC165 using a lookup table.
1349  */
1350 contract SupportsInterfaceWithLookup is ERC165 {
1351 
1352   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
1353   /**
1354    * 0x01ffc9a7 ===
1355    *   bytes4(keccak256('supportsInterface(bytes4)'))
1356    */
1357 
1358   /**
1359    * @dev a mapping of interface id to whether or not it's supported
1360    */
1361   mapping(bytes4 => bool) internal supportedInterfaces;
1362 
1363   /**
1364    * @dev A contract implementing SupportsInterfaceWithLookup
1365    * implement ERC165 itself
1366    */
1367   constructor()
1368     public
1369   {
1370     _registerInterface(InterfaceId_ERC165);
1371   }
1372 
1373   /**
1374    * @dev implement supportsInterface(bytes4) using a lookup table
1375    */
1376   function supportsInterface(bytes4 _interfaceId)
1377     external
1378     view
1379     returns (bool)
1380   {
1381     return supportedInterfaces[_interfaceId];
1382   }
1383 
1384   /**
1385    * @dev private method for registering an interface
1386    */
1387   function _registerInterface(bytes4 _interfaceId)
1388     internal
1389   {
1390     require(_interfaceId != 0xffffffff);
1391     supportedInterfaces[_interfaceId] = true;
1392   }
1393 }
1394 
1395 // File: erc-payable-token/contracts/token/ERC1363/ERC1363.sol
1396 
1397 /**
1398  * @title ERC1363 interface
1399  * @author Vittorio Minacori (https://github.com/vittominacori)
1400  * @dev Interface for a Payable Token contract as defined in
1401  *  https://github.com/ethereum/EIPs/issues/1363
1402  */
1403 contract ERC1363 is ERC20, ERC165 {
1404   /*
1405    * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
1406    * 0x4bbee2df ===
1407    *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
1408    *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
1409    *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
1410    *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
1411    */
1412 
1413   /*
1414    * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
1415    * 0xfb9ec8ce ===
1416    *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
1417    *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
1418    */
1419 
1420   /**
1421    * @notice Transfer tokens from `msg.sender` to another address
1422    *  and then call `onTransferReceived` on receiver
1423    * @param _to address The address which you want to transfer to
1424    * @param _value uint256 The amount of tokens to be transferred
1425    * @return true unless throwing
1426    */
1427   function transferAndCall(address _to, uint256 _value) public returns (bool);
1428 
1429   /**
1430    * @notice Transfer tokens from `msg.sender` to another address
1431    *  and then call `onTransferReceived` on receiver
1432    * @param _to address The address which you want to transfer to
1433    * @param _value uint256 The amount of tokens to be transferred
1434    * @param _data bytes Additional data with no specified format, sent in call to `_to`
1435    * @return true unless throwing
1436    */
1437   function transferAndCall(address _to, uint256 _value, bytes _data) public returns (bool); // solium-disable-line max-len
1438 
1439   /**
1440    * @notice Transfer tokens from one address to another
1441    *  and then call `onTransferReceived` on receiver
1442    * @param _from address The address which you want to send tokens from
1443    * @param _to address The address which you want to transfer to
1444    * @param _value uint256 The amount of tokens to be transferred
1445    * @return true unless throwing
1446    */
1447   function transferFromAndCall(address _from, address _to, uint256 _value) public returns (bool); // solium-disable-line max-len
1448 
1449 
1450   /**
1451    * @notice Transfer tokens from one address to another
1452    *  and then call `onTransferReceived` on receiver
1453    * @param _from address The address which you want to send tokens from
1454    * @param _to address The address which you want to transfer to
1455    * @param _value uint256 The amount of tokens to be transferred
1456    * @param _data bytes Additional data with no specified format, sent in call to `_to`
1457    * @return true unless throwing
1458    */
1459   function transferFromAndCall(address _from, address _to, uint256 _value, bytes _data) public returns (bool); // solium-disable-line max-len, arg-overflow
1460 
1461   /**
1462    * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
1463    *  and then call `onApprovalReceived` on spender
1464    *  Beware that changing an allowance with this method brings the risk that someone may use both the old
1465    *  and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1466    *  race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1467    *  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1468    * @param _spender address The address which will spend the funds
1469    * @param _value uint256 The amount of tokens to be spent
1470    */
1471   function approveAndCall(address _spender, uint256 _value) public returns (bool); // solium-disable-line max-len
1472 
1473   /**
1474    * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
1475    *  and then call `onApprovalReceived` on spender
1476    *  Beware that changing an allowance with this method brings the risk that someone may use both the old
1477    *  and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1478    *  race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1479    *  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1480    * @param _spender address The address which will spend the funds
1481    * @param _value uint256 The amount of tokens to be spent
1482    * @param _data bytes Additional data with no specified format, sent in call to `_spender`
1483    */
1484   function approveAndCall(address _spender, uint256 _value, bytes _data) public returns (bool); // solium-disable-line max-len
1485 }
1486 
1487 // File: erc-payable-token/contracts/token/ERC1363/ERC1363Receiver.sol
1488 
1489 /**
1490  * @title ERC1363Receiver interface
1491  * @author Vittorio Minacori (https://github.com/vittominacori)
1492  * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
1493  *  from ERC1363 token contracts as defined in
1494  *  https://github.com/ethereum/EIPs/issues/1363
1495  */
1496 contract ERC1363Receiver {
1497   /*
1498    * Note: the ERC-165 identifier for this interface is 0x88a7ca5c.
1499    * 0x88a7ca5c === bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))
1500    */
1501 
1502   /**
1503    * @notice Handle the receipt of ERC1363 tokens
1504    * @dev Any ERC1363 smart contract calls this function on the recipient
1505    *  after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
1506    *  transfer. Return of other than the magic value MUST result in the
1507    *  transaction being reverted.
1508    *  Note: the token contract address is always the message sender.
1509    * @param _operator address The address which called `transferAndCall` or `transferFromAndCall` function
1510    * @param _from address The address which are token transferred from
1511    * @param _value uint256 The amount of tokens transferred
1512    * @param _data bytes Additional data with no specified format
1513    * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
1514    *  unless throwing
1515    */
1516   function onTransferReceived(address _operator, address _from, uint256 _value, bytes _data) external returns (bytes4); // solium-disable-line max-len, arg-overflow
1517 }
1518 
1519 // File: erc-payable-token/contracts/token/ERC1363/ERC1363Spender.sol
1520 
1521 /**
1522  * @title ERC1363Spender interface
1523  * @author Vittorio Minacori (https://github.com/vittominacori)
1524  * @dev Interface for any contract that wants to support approveAndCall
1525  *  from ERC1363 token contracts as defined in
1526  *  https://github.com/ethereum/EIPs/issues/1363
1527  */
1528 contract ERC1363Spender {
1529   /*
1530    * Note: the ERC-165 identifier for this interface is 0x7b04a2d0.
1531    * 0x7b04a2d0 === bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))
1532    */
1533 
1534   /**
1535    * @notice Handle the approval of ERC1363 tokens
1536    * @dev Any ERC1363 smart contract calls this function on the recipient
1537    *  after an `approve`. This function MAY throw to revert and reject the
1538    *  approval. Return of other than the magic value MUST result in the
1539    *  transaction being reverted.
1540    *  Note: the token contract address is always the message sender.
1541    * @param _owner address The address which called `approveAndCall` function
1542    * @param _value uint256 The amount of tokens to be spent
1543    * @param _data bytes Additional data with no specified format
1544    * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
1545    *  unless throwing
1546    */
1547   function onApprovalReceived(address _owner, uint256 _value, bytes _data) external returns (bytes4); // solium-disable-line max-len
1548 }
1549 
1550 // File: erc-payable-token/contracts/token/ERC1363/ERC1363BasicToken.sol
1551 
1552 // solium-disable-next-line max-len
1553 
1554 
1555 
1556 
1557 
1558 
1559 
1560 /**
1561  * @title ERC1363BasicToken
1562  * @author Vittorio Minacori (https://github.com/vittominacori)
1563  * @dev Implementation of an ERC1363 interface
1564  */
1565 contract ERC1363BasicToken is SupportsInterfaceWithLookup, StandardToken, ERC1363 { // solium-disable-line max-len
1566   using AddressUtils for address;
1567 
1568   /*
1569    * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
1570    * 0x4bbee2df ===
1571    *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
1572    *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
1573    *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
1574    *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
1575    */
1576   bytes4 internal constant InterfaceId_ERC1363Transfer = 0x4bbee2df;
1577 
1578   /*
1579    * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
1580    * 0xfb9ec8ce ===
1581    *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
1582    *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
1583    */
1584   bytes4 internal constant InterfaceId_ERC1363Approve = 0xfb9ec8ce;
1585 
1586   // Equals to `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
1587   // which can be also obtained as `ERC1363Receiver(0).onTransferReceived.selector`
1588   bytes4 private constant ERC1363_RECEIVED = 0x88a7ca5c;
1589 
1590   // Equals to `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
1591   // which can be also obtained as `ERC1363Spender(0).onApprovalReceived.selector`
1592   bytes4 private constant ERC1363_APPROVED = 0x7b04a2d0;
1593 
1594   constructor() public {
1595     // register the supported interfaces to conform to ERC1363 via ERC165
1596     _registerInterface(InterfaceId_ERC1363Transfer);
1597     _registerInterface(InterfaceId_ERC1363Approve);
1598   }
1599 
1600   function transferAndCall(
1601     address _to,
1602     uint256 _value
1603   )
1604     public
1605     returns (bool)
1606   {
1607     return transferAndCall(_to, _value, "");
1608   }
1609 
1610   function transferAndCall(
1611     address _to,
1612     uint256 _value,
1613     bytes _data
1614   )
1615     public
1616     returns (bool)
1617   {
1618     require(transfer(_to, _value));
1619     require(
1620       checkAndCallTransfer(
1621         msg.sender,
1622         _to,
1623         _value,
1624         _data
1625       )
1626     );
1627     return true;
1628   }
1629 
1630   function transferFromAndCall(
1631     address _from,
1632     address _to,
1633     uint256 _value
1634   )
1635     public
1636     returns (bool)
1637   {
1638     // solium-disable-next-line arg-overflow
1639     return transferFromAndCall(_from, _to, _value, "");
1640   }
1641 
1642   function transferFromAndCall(
1643     address _from,
1644     address _to,
1645     uint256 _value,
1646     bytes _data
1647   )
1648     public
1649     returns (bool)
1650   {
1651     require(transferFrom(_from, _to, _value));
1652     require(
1653       checkAndCallTransfer(
1654         _from,
1655         _to,
1656         _value,
1657         _data
1658       )
1659     );
1660     return true;
1661   }
1662 
1663   function approveAndCall(
1664     address _spender,
1665     uint256 _value
1666   )
1667     public
1668     returns (bool)
1669   {
1670     return approveAndCall(_spender, _value, "");
1671   }
1672 
1673   function approveAndCall(
1674     address _spender,
1675     uint256 _value,
1676     bytes _data
1677   )
1678     public
1679     returns (bool)
1680   {
1681     approve(_spender, _value);
1682     require(
1683       checkAndCallApprove(
1684         _spender,
1685         _value,
1686         _data
1687       )
1688     );
1689     return true;
1690   }
1691 
1692   /**
1693    * @dev Internal function to invoke `onTransferReceived` on a target address
1694    *  The call is not executed if the target address is not a contract
1695    * @param _from address Representing the previous owner of the given token value
1696    * @param _to address Target address that will receive the tokens
1697    * @param _value uint256 The amount mount of tokens to be transferred
1698    * @param _data bytes Optional data to send along with the call
1699    * @return whether the call correctly returned the expected magic value
1700    */
1701   function checkAndCallTransfer(
1702     address _from,
1703     address _to,
1704     uint256 _value,
1705     bytes _data
1706   )
1707     internal
1708     returns (bool)
1709   {
1710     if (!_to.isContract()) {
1711       return false;
1712     }
1713     bytes4 retval = ERC1363Receiver(_to).onTransferReceived(
1714       msg.sender, _from, _value, _data
1715     );
1716     return (retval == ERC1363_RECEIVED);
1717   }
1718 
1719   /**
1720    * @dev Internal function to invoke `onApprovalReceived` on a target address
1721    *  The call is not executed if the target address is not a contract
1722    * @param _spender address The address which will spend the funds
1723    * @param _value uint256 The amount of tokens to be spent
1724    * @param _data bytes Optional data to send along with the call
1725    * @return whether the call correctly returned the expected magic value
1726    */
1727   function checkAndCallApprove(
1728     address _spender,
1729     uint256 _value,
1730     bytes _data
1731   )
1732     internal
1733     returns (bool)
1734   {
1735     if (!_spender.isContract()) {
1736       return false;
1737     }
1738     bytes4 retval = ERC1363Spender(_spender).onApprovalReceived(
1739       msg.sender, _value, _data
1740     );
1741     return (retval == ERC1363_APPROVED);
1742   }
1743 }
1744 
1745 // File: contracts/token/FidelityHouseToken.sol
1746 
1747 // solium-disable-next-line max-len
1748 contract FidelityHouseToken is DetailedERC20, RBACMintableToken, BurnableToken, ERC1363BasicToken, TokenRecover {
1749 
1750   uint256 public lockedUntil;
1751   mapping(address => uint256) internal lockedBalances;
1752 
1753   modifier canTransfer(address _from, uint256 _value) {
1754     require(
1755       mintingFinished,
1756       "Minting should be finished before transfer."
1757     );
1758     require(
1759       _value <= balances[_from].sub(lockedBalanceOf(_from)),
1760       "Can't transfer more than unlocked tokens"
1761     );
1762     _;
1763   }
1764 
1765   constructor(uint256 _lockedUntil)
1766     DetailedERC20("FidelityHouse Token", "FIH", 18)
1767     public
1768   {
1769     lockedUntil = _lockedUntil;
1770   }
1771 
1772   /**
1773    * @dev Gets the locked balance of the specified address.
1774    * @param _owner The address to query the balance of.
1775    * @return An uint256 representing the locked amount owned by the passed address.
1776    */
1777   function lockedBalanceOf(address _owner) public view returns (uint256) {
1778     // solium-disable-next-line security/no-block-members
1779     return block.timestamp <= lockedUntil ? lockedBalances[_owner] : 0;
1780   }
1781 
1782   /**
1783    * @dev Function to mint and lock tokens
1784    * @param _to The address that will receive the minted tokens.
1785    * @param _amount The amount of tokens to mint.
1786    * @return A boolean that indicates if the operation was successful.
1787    */
1788   function mintAndLock(
1789     address _to,
1790     uint256 _amount
1791   )
1792     public
1793     hasMintPermission
1794     canMint
1795     returns (bool)
1796   {
1797     lockedBalances[_to] = lockedBalances[_to].add(_amount);
1798     return super.mint(_to, _amount);
1799   }
1800 
1801   function transfer(
1802     address _to,
1803     uint256 _value
1804   )
1805     public
1806     canTransfer(msg.sender, _value)
1807     returns (bool)
1808   {
1809     return super.transfer(_to, _value);
1810   }
1811 
1812   function transferFrom(
1813     address _from,
1814     address _to,
1815     uint256 _value
1816   )
1817     public
1818     canTransfer(_from, _value)
1819     returns (bool)
1820   {
1821     return super.transferFrom(_from, _to, _value);
1822   }
1823 }
1824 
1825 // File: contracts/crowdsale/base/TimedBonusCrowdsale.sol
1826 
1827 // solium-disable-next-line max-len
1828 
1829 
1830 
1831 
1832 /**
1833  * @title TimedBonusCrowdsale
1834  * @dev Extension of MintedCrowdsale and DefaultICO contract whose bonus decrease in time.
1835  */
1836 contract TimedBonusCrowdsale is MintedCrowdsale, DefaultICO {
1837 
1838   uint256[] public bonusDates;
1839   uint256[] public bonusRates;
1840 
1841   function setBonusRates(
1842     uint256[] _bonusDates,
1843     uint256[] _bonusRates
1844   )
1845     external
1846     onlyOwner
1847   {
1848     require(
1849       !started(),
1850       "Bonus rates can be set only before the campaign start"
1851     );
1852     require(
1853       _bonusDates.length == 4,
1854       "Dates array must have 4 entries."
1855     );
1856     require(
1857       _bonusRates.length == 4,
1858       "Rates array must have 4 entries."
1859     );
1860     require(
1861       _bonusDates[0] < _bonusDates[1] && _bonusDates[1] < _bonusDates[2] && _bonusDates[2] < _bonusDates[3], // solium-disable-line max-len
1862       "Dates must be consecutive"
1863     );
1864 
1865     bonusDates = _bonusDates;
1866     bonusRates = _bonusRates;
1867   }
1868 
1869   function getCurrentBonus() public view returns (uint256) {
1870     uint256 bonusPercent = 0;
1871 
1872     if (bonusDates.length > 0) {
1873       if (block.timestamp < bonusDates[0]) { // solium-disable-line security/no-block-members
1874         bonusPercent = bonusRates[0];
1875       } else if (block.timestamp < bonusDates[1]) { // solium-disable-line security/no-block-members
1876         bonusPercent = bonusRates[1];
1877       } else if (block.timestamp < bonusDates[2]) { // solium-disable-line security/no-block-members
1878         bonusPercent = bonusRates[2];
1879       } else if (block.timestamp < bonusDates[3]) { // solium-disable-line security/no-block-members
1880         bonusPercent = bonusRates[3];
1881       }
1882     }
1883 
1884     return bonusPercent;
1885   }
1886 
1887   /**
1888    * @dev Override to extend the way in which ether is converted to tokens.
1889    * @param _weiAmount Value in wei to be converted into tokens
1890    * @return Number of tokens that can be purchased with the specified _weiAmount
1891    */
1892   function _getTokenAmount(
1893     uint256 _weiAmount
1894   )
1895     internal
1896     view
1897     returns (uint256)
1898   {
1899     uint256 bonusAmount = 0;
1900     uint256 tokenAmount = super._getTokenAmount(_weiAmount);
1901 
1902     uint256 bonusPercent = getCurrentBonus();
1903 
1904     if (bonusPercent > 0) {
1905       bonusAmount = tokenAmount.mul(bonusPercent).div(100);
1906     }
1907 
1908     return tokenAmount.add(bonusAmount);
1909   }
1910 }
1911 
1912 // File: contracts/crowdsale/FidelityHouseICO.sol
1913 
1914 contract FidelityHouseICO is TokenCappedCrowdsale, TimedBonusCrowdsale {
1915 
1916   constructor(
1917     uint256 _openingTime,
1918     uint256 _closingTime,
1919     uint256 _rate,
1920     address _wallet,
1921     uint256 _tokenCap,
1922     uint256 _minimumContribution,
1923     address _token,
1924     address _contributions,
1925     uint256 _tierZero
1926   )
1927     DefaultICO(
1928       _openingTime,
1929       _closingTime,
1930       _rate,
1931       _wallet,
1932       _minimumContribution,
1933       _token,
1934       _contributions,
1935       _tierZero
1936     )
1937     TokenCappedCrowdsale(_tokenCap)
1938     public
1939   {}
1940 
1941   function adjustTokenCap(uint256 _newTokenCap) external onlyOwner {
1942     require(_newTokenCap > 0, "Token Cap should be greater than zero");
1943 
1944     tokenCap = _newTokenCap;
1945   }
1946 
1947   // false if the ico is not started, false if the ico is started and running, true if the ico is completed
1948   function ended() public view returns(bool) {
1949     return hasClosed() || tokenCapReached();
1950   }
1951 }