1 pragma solidity ^0.4.24;
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
391 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
392 
393 /**
394  * @title Basic token
395  * @dev Basic version of StandardToken, with no allowances.
396  */
397 contract BasicToken is ERC20Basic {
398   using SafeMath for uint256;
399 
400   mapping(address => uint256) internal balances;
401 
402   uint256 internal totalSupply_;
403 
404   /**
405   * @dev Total number of tokens in existence
406   */
407   function totalSupply() public view returns (uint256) {
408     return totalSupply_;
409   }
410 
411   /**
412   * @dev Transfer token for a specified address
413   * @param _to The address to transfer to.
414   * @param _value The amount to be transferred.
415   */
416   function transfer(address _to, uint256 _value) public returns (bool) {
417     require(_value <= balances[msg.sender]);
418     require(_to != address(0));
419 
420     balances[msg.sender] = balances[msg.sender].sub(_value);
421     balances[_to] = balances[_to].add(_value);
422     emit Transfer(msg.sender, _to, _value);
423     return true;
424   }
425 
426   /**
427   * @dev Gets the balance of the specified address.
428   * @param _owner The address to query the the balance of.
429   * @return An uint256 representing the amount owned by the passed address.
430   */
431   function balanceOf(address _owner) public view returns (uint256) {
432     return balances[_owner];
433   }
434 
435 }
436 
437 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
438 
439 /**
440  * @title Standard ERC20 token
441  *
442  * @dev Implementation of the basic standard token.
443  * https://github.com/ethereum/EIPs/issues/20
444  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
445  */
446 contract StandardToken is ERC20, BasicToken {
447 
448   mapping (address => mapping (address => uint256)) internal allowed;
449 
450 
451   /**
452    * @dev Transfer tokens from one address to another
453    * @param _from address The address which you want to send tokens from
454    * @param _to address The address which you want to transfer to
455    * @param _value uint256 the amount of tokens to be transferred
456    */
457   function transferFrom(
458     address _from,
459     address _to,
460     uint256 _value
461   )
462     public
463     returns (bool)
464   {
465     require(_value <= balances[_from]);
466     require(_value <= allowed[_from][msg.sender]);
467     require(_to != address(0));
468 
469     balances[_from] = balances[_from].sub(_value);
470     balances[_to] = balances[_to].add(_value);
471     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
472     emit Transfer(_from, _to, _value);
473     return true;
474   }
475 
476   /**
477    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
478    * Beware that changing an allowance with this method brings the risk that someone may use both the old
479    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
480    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
481    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
482    * @param _spender The address which will spend the funds.
483    * @param _value The amount of tokens to be spent.
484    */
485   function approve(address _spender, uint256 _value) public returns (bool) {
486     allowed[msg.sender][_spender] = _value;
487     emit Approval(msg.sender, _spender, _value);
488     return true;
489   }
490 
491   /**
492    * @dev Function to check the amount of tokens that an owner allowed to a spender.
493    * @param _owner address The address which owns the funds.
494    * @param _spender address The address which will spend the funds.
495    * @return A uint256 specifying the amount of tokens still available for the spender.
496    */
497   function allowance(
498     address _owner,
499     address _spender
500    )
501     public
502     view
503     returns (uint256)
504   {
505     return allowed[_owner][_spender];
506   }
507 
508   /**
509    * @dev Increase the amount of tokens that an owner allowed to a spender.
510    * approve should be called when allowed[_spender] == 0. To increment
511    * allowed value is better to use this function to avoid 2 calls (and wait until
512    * the first transaction is mined)
513    * From MonolithDAO Token.sol
514    * @param _spender The address which will spend the funds.
515    * @param _addedValue The amount of tokens to increase the allowance by.
516    */
517   function increaseApproval(
518     address _spender,
519     uint256 _addedValue
520   )
521     public
522     returns (bool)
523   {
524     allowed[msg.sender][_spender] = (
525       allowed[msg.sender][_spender].add(_addedValue));
526     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
527     return true;
528   }
529 
530   /**
531    * @dev Decrease the amount of tokens that an owner allowed to a spender.
532    * approve should be called when allowed[_spender] == 0. To decrement
533    * allowed value is better to use this function to avoid 2 calls (and wait until
534    * the first transaction is mined)
535    * From MonolithDAO Token.sol
536    * @param _spender The address which will spend the funds.
537    * @param _subtractedValue The amount of tokens to decrease the allowance by.
538    */
539   function decreaseApproval(
540     address _spender,
541     uint256 _subtractedValue
542   )
543     public
544     returns (bool)
545   {
546     uint256 oldValue = allowed[msg.sender][_spender];
547     if (_subtractedValue >= oldValue) {
548       allowed[msg.sender][_spender] = 0;
549     } else {
550       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
551     }
552     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
553     return true;
554   }
555 
556 }
557 
558 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
559 
560 /**
561  * @title Ownable
562  * @dev The Ownable contract has an owner address, and provides basic authorization control
563  * functions, this simplifies the implementation of "user permissions".
564  */
565 contract Ownable {
566   address public owner;
567 
568 
569   event OwnershipRenounced(address indexed previousOwner);
570   event OwnershipTransferred(
571     address indexed previousOwner,
572     address indexed newOwner
573   );
574 
575 
576   /**
577    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
578    * account.
579    */
580   constructor() public {
581     owner = msg.sender;
582   }
583 
584   /**
585    * @dev Throws if called by any account other than the owner.
586    */
587   modifier onlyOwner() {
588     require(msg.sender == owner);
589     _;
590   }
591 
592   /**
593    * @dev Allows the current owner to relinquish control of the contract.
594    * @notice Renouncing to ownership will leave the contract without an owner.
595    * It will not be possible to call the functions with the `onlyOwner`
596    * modifier anymore.
597    */
598   function renounceOwnership() public onlyOwner {
599     emit OwnershipRenounced(owner);
600     owner = address(0);
601   }
602 
603   /**
604    * @dev Allows the current owner to transfer control of the contract to a newOwner.
605    * @param _newOwner The address to transfer ownership to.
606    */
607   function transferOwnership(address _newOwner) public onlyOwner {
608     _transferOwnership(_newOwner);
609   }
610 
611   /**
612    * @dev Transfers control of the contract to a newOwner.
613    * @param _newOwner The address to transfer ownership to.
614    */
615   function _transferOwnership(address _newOwner) internal {
616     require(_newOwner != address(0));
617     emit OwnershipTransferred(owner, _newOwner);
618     owner = _newOwner;
619   }
620 }
621 
622 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
623 
624 /**
625  * @title Mintable token
626  * @dev Simple ERC20 Token example, with mintable token creation
627  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
628  */
629 contract MintableToken is StandardToken, Ownable {
630   event Mint(address indexed to, uint256 amount);
631   event MintFinished();
632 
633   bool public mintingFinished = false;
634 
635 
636   modifier canMint() {
637     require(!mintingFinished);
638     _;
639   }
640 
641   modifier hasMintPermission() {
642     require(msg.sender == owner);
643     _;
644   }
645 
646   /**
647    * @dev Function to mint tokens
648    * @param _to The address that will receive the minted tokens.
649    * @param _amount The amount of tokens to mint.
650    * @return A boolean that indicates if the operation was successful.
651    */
652   function mint(
653     address _to,
654     uint256 _amount
655   )
656     public
657     hasMintPermission
658     canMint
659     returns (bool)
660   {
661     totalSupply_ = totalSupply_.add(_amount);
662     balances[_to] = balances[_to].add(_amount);
663     emit Mint(_to, _amount);
664     emit Transfer(address(0), _to, _amount);
665     return true;
666   }
667 
668   /**
669    * @dev Function to stop minting new tokens.
670    * @return True if the operation was successful.
671    */
672   function finishMinting() public onlyOwner canMint returns (bool) {
673     mintingFinished = true;
674     emit MintFinished();
675     return true;
676   }
677 }
678 
679 // File: openzeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol
680 
681 /**
682  * @title MintedCrowdsale
683  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
684  * Token ownership should be transferred to MintedCrowdsale for minting.
685  */
686 contract MintedCrowdsale is Crowdsale {
687 
688   /**
689    * @dev Overrides delivery by minting tokens upon purchase.
690    * @param _beneficiary Token purchaser
691    * @param _tokenAmount Number of tokens to be minted
692    */
693   function _deliverTokens(
694     address _beneficiary,
695     uint256 _tokenAmount
696   )
697     internal
698   {
699     // Potentially dangerous assumption about the type of the token.
700     require(MintableToken(address(token)).mint(_beneficiary, _tokenAmount));
701   }
702 }
703 
704 // File: contracts/crowdsale/base/TokenCappedCrowdsale.sol
705 
706 /**
707  * @title TokenCappedCrowdsale
708  * @dev Crowdsale with a limit of total tokens to be sold
709  */
710 contract TokenCappedCrowdsale is Crowdsale {
711   using SafeMath for uint256;
712 
713   uint256 public tokenCap;
714 
715   // Amount of token sold
716   uint256 public soldTokens;
717 
718   /**
719    * @dev Constructor, takes maximum amount of tokens to be sold in the crowdsale.
720    * @param _tokenCap Max amount of tokens to be sold
721    */
722   constructor(uint256 _tokenCap) public {
723     require(_tokenCap > 0);
724     tokenCap = _tokenCap;
725   }
726 
727   /**
728    * @dev Checks whether the tokenCap has been reached.
729    * @return Whether the tokenCap was reached
730    */
731   function tokenCapReached() public view returns (bool) {
732     return soldTokens >= tokenCap;
733   }
734 
735   /**
736    * @dev Extend parent behavior requiring purchase to respect the tokenCap.
737    * @param _beneficiary Token purchaser
738    * @param _weiAmount Amount of wei contributed
739    */
740   function _preValidatePurchase(
741     address _beneficiary,
742     uint256 _weiAmount
743   )
744   internal
745   {
746     super._preValidatePurchase(_beneficiary, _weiAmount);
747     require(soldTokens.add(_getTokenAmount(_weiAmount)) <= tokenCap);
748   }
749 
750   /**
751    * @dev Update the contributions contract states
752    * @param _beneficiary Address receiving the tokens
753    * @param _weiAmount Value in wei involved in the purchase
754    */
755   function _updatePurchasingState(
756     address _beneficiary,
757     uint256 _weiAmount
758   )
759   internal
760   {
761     super._updatePurchasingState(_beneficiary, _weiAmount);
762     soldTokens = soldTokens.add(_getTokenAmount(_weiAmount));
763   }
764 
765 }
766 
767 // File: contracts/safe/TokenRecover.sol
768 
769 contract TokenRecover is Ownable {
770 
771   /**
772    * @dev It's a safe function allowing to recover any ERC20 sent into the contract for error
773    * @param _tokenAddress address The token contract address
774    * @param _tokens Number of tokens to be sent
775    * @return bool
776    */
777   function transferAnyERC20Token(
778     address _tokenAddress,
779     uint256 _tokens
780   )
781   public
782   onlyOwner
783   returns (bool success)
784   {
785     return ERC20Basic(_tokenAddress).transfer(owner, _tokens);
786   }
787 }
788 
789 // File: openzeppelin-solidity/contracts/access/rbac/Roles.sol
790 
791 /**
792  * @title Roles
793  * @author Francisco Giordano (@frangio)
794  * @dev Library for managing addresses assigned to a Role.
795  * See RBAC.sol for example usage.
796  */
797 library Roles {
798   struct Role {
799     mapping (address => bool) bearer;
800   }
801 
802   /**
803    * @dev give an address access to this role
804    */
805   function add(Role storage _role, address _addr)
806     internal
807   {
808     _role.bearer[_addr] = true;
809   }
810 
811   /**
812    * @dev remove an address' access to this role
813    */
814   function remove(Role storage _role, address _addr)
815     internal
816   {
817     _role.bearer[_addr] = false;
818   }
819 
820   /**
821    * @dev check if an address has this role
822    * // reverts
823    */
824   function check(Role storage _role, address _addr)
825     internal
826     view
827   {
828     require(has(_role, _addr));
829   }
830 
831   /**
832    * @dev check if an address has this role
833    * @return bool
834    */
835   function has(Role storage _role, address _addr)
836     internal
837     view
838     returns (bool)
839   {
840     return _role.bearer[_addr];
841   }
842 }
843 
844 // File: openzeppelin-solidity/contracts/access/rbac/RBAC.sol
845 
846 /**
847  * @title RBAC (Role-Based Access Control)
848  * @author Matt Condon (@Shrugs)
849  * @dev Stores and provides setters and getters for roles and addresses.
850  * Supports unlimited numbers of roles and addresses.
851  * See //contracts/mocks/RBACMock.sol for an example of usage.
852  * This RBAC method uses strings to key roles. It may be beneficial
853  * for you to write your own implementation of this interface using Enums or similar.
854  */
855 contract RBAC {
856   using Roles for Roles.Role;
857 
858   mapping (string => Roles.Role) private roles;
859 
860   event RoleAdded(address indexed operator, string role);
861   event RoleRemoved(address indexed operator, string role);
862 
863   /**
864    * @dev reverts if addr does not have role
865    * @param _operator address
866    * @param _role the name of the role
867    * // reverts
868    */
869   function checkRole(address _operator, string _role)
870     public
871     view
872   {
873     roles[_role].check(_operator);
874   }
875 
876   /**
877    * @dev determine if addr has role
878    * @param _operator address
879    * @param _role the name of the role
880    * @return bool
881    */
882   function hasRole(address _operator, string _role)
883     public
884     view
885     returns (bool)
886   {
887     return roles[_role].has(_operator);
888   }
889 
890   /**
891    * @dev add a role to an address
892    * @param _operator address
893    * @param _role the name of the role
894    */
895   function addRole(address _operator, string _role)
896     internal
897   {
898     roles[_role].add(_operator);
899     emit RoleAdded(_operator, _role);
900   }
901 
902   /**
903    * @dev remove a role from an address
904    * @param _operator address
905    * @param _role the name of the role
906    */
907   function removeRole(address _operator, string _role)
908     internal
909   {
910     roles[_role].remove(_operator);
911     emit RoleRemoved(_operator, _role);
912   }
913 
914   /**
915    * @dev modifier to scope access to a single role (uses msg.sender as addr)
916    * @param _role the name of the role
917    * // reverts
918    */
919   modifier onlyRole(string _role)
920   {
921     checkRole(msg.sender, _role);
922     _;
923   }
924 
925   /**
926    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
927    * @param _roles the names of the roles to scope access to
928    * // reverts
929    *
930    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
931    *  see: https://github.com/ethereum/solidity/issues/2467
932    */
933   // modifier onlyRoles(string[] _roles) {
934   //     bool hasAnyRole = false;
935   //     for (uint8 i = 0; i < _roles.length; i++) {
936   //         if (hasRole(msg.sender, _roles[i])) {
937   //             hasAnyRole = true;
938   //             break;
939   //         }
940   //     }
941 
942   //     require(hasAnyRole);
943 
944   //     _;
945   // }
946 }
947 
948 // File: contracts/crowdsale/utils/Contributions.sol
949 
950 contract Contributions is RBAC, Ownable {
951   using SafeMath for uint256;
952 
953   string public constant ROLE_MINTER = "minter";
954 
955   modifier onlyMinter () {
956     checkRole(msg.sender, ROLE_MINTER);
957     _;
958   }
959 
960   mapping(address => uint256) public tokenBalances;
961   mapping(address => uint256) public ethContributions;
962   address[] public addresses;
963 
964   constructor() public {}
965 
966   function addBalance(
967     address _address,
968     uint256 _weiAmount,
969     uint256 _tokenAmount
970   )
971   public
972   onlyMinter
973   {
974     if (ethContributions[_address] == 0) {
975       addresses.push(_address);
976     }
977     ethContributions[_address] = ethContributions[_address].add(_weiAmount);
978     tokenBalances[_address] = tokenBalances[_address].add(_tokenAmount);
979   }
980 
981   /**
982    * @dev add a minter role to an address
983    * @param _minter address
984    */
985   function addMinter(address _minter) public onlyOwner {
986     addRole(_minter, ROLE_MINTER);
987   }
988 
989   /**
990    * @dev add a minter role to an array of addresses
991    * @param _minters address[]
992    */
993   function addMinters(address[] _minters) public onlyOwner {
994     require(_minters.length > 0);
995     for (uint i = 0; i < _minters.length; i++) {
996       addRole(_minters[i], ROLE_MINTER);
997     }
998   }
999 
1000   /**
1001    * @dev remove a minter role from an address
1002    * @param _minter address
1003    */
1004   function removeMinter(address _minter) public onlyOwner {
1005     removeRole(_minter, ROLE_MINTER);
1006   }
1007 
1008   function getContributorsLength() public view returns (uint) {
1009     return addresses.length;
1010   }
1011 }
1012 
1013 // File: contracts/crowdsale/base/DefaultCrowdsale.sol
1014 
1015 contract DefaultCrowdsale is TimedCrowdsale, MintedCrowdsale, TokenCappedCrowdsale, TokenRecover { // solium-disable-line max-len
1016 
1017   Contributions public contributions;
1018 
1019   uint256 public minimumContribution;
1020   uint256 public transactionCount;
1021 
1022   constructor(
1023     uint256 _startTime,
1024     uint256 _endTime,
1025     uint256 _rate,
1026     address _wallet,
1027     uint256 _tokenCap,
1028     uint256 _minimumContribution,
1029     address _token,
1030     address _contributions
1031   )
1032   Crowdsale(_rate, _wallet, ERC20(_token))
1033   TimedCrowdsale(_startTime, _endTime)
1034   TokenCappedCrowdsale(_tokenCap)
1035   public
1036   {
1037     require(_contributions != address(0));
1038     contributions = Contributions(_contributions);
1039     minimumContribution = _minimumContribution;
1040   }
1041 
1042   // false if the ico is not started, true if the ico is started and running, true if the ico is completed
1043   function started() public view returns(bool) {
1044     // solium-disable-next-line security/no-block-members
1045     return block.timestamp >= openingTime;
1046   }
1047 
1048   // false if the ico is not started, false if the ico is started and running, true if the ico is completed
1049   function ended() public view returns(bool) {
1050     return hasClosed() || tokenCapReached();
1051   }
1052 
1053 
1054   /**
1055    * @dev Extend parent behavior requiring purchase to respect the tokenCap.
1056    * @param _beneficiary Token purchaser
1057    * @param _weiAmount Amount of wei contributed
1058    */
1059   function _preValidatePurchase(
1060     address _beneficiary,
1061     uint256 _weiAmount
1062   )
1063   internal
1064   {
1065     require(_weiAmount >= minimumContribution);
1066     super._preValidatePurchase(_beneficiary, _weiAmount);
1067   }
1068 
1069   /**
1070    * @dev Update the contributions contract states
1071    * @param _beneficiary Address receiving the tokens
1072    * @param _weiAmount Value in wei involved in the purchase
1073    */
1074   function _updatePurchasingState(
1075     address _beneficiary,
1076     uint256 _weiAmount
1077   )
1078   internal
1079   {
1080     super._updatePurchasingState(_beneficiary, _weiAmount);
1081     contributions.addBalance(
1082       _beneficiary,
1083       _weiAmount,
1084       _getTokenAmount(_weiAmount)
1085     );
1086 
1087     transactionCount = transactionCount + 1;
1088   }
1089 }
1090 
1091 // File: contracts/crowdsale/base/IncreasingBonusCrowdsale.sol
1092 
1093 contract IncreasingBonusCrowdsale is DefaultCrowdsale {
1094 
1095   uint256[] public bonusRanges;
1096   uint256[] public bonusValues;
1097 
1098   constructor(
1099     uint256 _startTime,
1100     uint256 _endTime,
1101     uint256 _rate,
1102     address _wallet,
1103     uint256 _tokenCap,
1104     uint256 _minimumContribution,
1105     address _token,
1106     address _contributions
1107   )
1108   DefaultCrowdsale(
1109     _startTime,
1110     _endTime,
1111     _rate,
1112     _wallet,
1113     _tokenCap,
1114     _minimumContribution,
1115     _token,
1116     _contributions
1117   )
1118   public
1119   {}
1120 
1121   function setBonusRates(
1122     uint256[] _bonusRanges,
1123     uint256[] _bonusValues
1124   )
1125   public
1126   onlyOwner
1127   {
1128     require(bonusRanges.length == 0 && bonusValues.length == 0);
1129     require(_bonusRanges.length == _bonusValues.length);
1130 
1131     for (uint256 i = 0; i < (_bonusValues.length - 1); i++) {
1132       require(_bonusValues[i] > _bonusValues[i + 1]);
1133       require(_bonusRanges[i] > _bonusRanges[i + 1]);
1134     }
1135 
1136     bonusRanges = _bonusRanges;
1137     bonusValues = _bonusValues;
1138   }
1139 
1140   /**
1141    * @dev Override to extend the way in which ether is converted to tokens.
1142    * @param _weiAmount Value in wei to be converted into tokens
1143    * @return Number of tokens that can be purchased with the specified _weiAmount
1144    */
1145   function _getTokenAmount(uint256 _weiAmount)
1146   internal view returns (uint256)
1147   {
1148     uint256 tokens = _weiAmount.mul(rate);
1149 
1150     uint256 bonusPercent = 0;
1151 
1152     for (uint256 i = 0; i < bonusValues.length; i++) {
1153       if (_weiAmount >= bonusRanges[i]) {
1154         bonusPercent = bonusValues[i];
1155         break;
1156       }
1157     }
1158 
1159     uint256 bonusAmount = tokens.mul(bonusPercent).div(100);
1160 
1161     return tokens.add(bonusAmount);
1162   }
1163 }
1164 
1165 // File: contracts/crowdsale/ForkRC.sol
1166 
1167 contract ForkRC is IncreasingBonusCrowdsale {
1168 
1169   constructor(
1170     uint256 _startTime,
1171     uint256 _endTime,
1172     uint256 _rate,
1173     address _wallet,
1174     uint256 _tokenCap,
1175     uint256 _minimumContribution,
1176     address _token,
1177     address _contributions
1178   )
1179   IncreasingBonusCrowdsale(
1180     _startTime,
1181     _endTime,
1182     _rate,
1183     _wallet,
1184     _tokenCap,
1185     _minimumContribution,
1186     _token,
1187     _contributions
1188   )
1189   public
1190   {}
1191 }
1192 
1193 // File: contracts/distribution/CrowdGenerator.sol
1194 
1195 contract CrowdGenerator is TokenRecover {
1196 
1197   uint256[] public bonusRanges;
1198   uint256[] public bonusValues;
1199 
1200   uint256 public endTime;
1201   uint256 public rate;
1202   address public wallet;
1203   uint256 public tokenCap;
1204   address public token;
1205   address public contributions;
1206   uint256 public minimumContribution;
1207 
1208   address[] public crowdsaleList;
1209 
1210   event CrowdsaleStarted(
1211     address indexed crowdsale
1212   );
1213 
1214   constructor(
1215     uint256 _endTime,
1216     uint256 _rate,
1217     address _wallet,
1218     uint256 _tokenCap,
1219     uint256 _minimumContribution,
1220     address _token,
1221     address _contributions,
1222     uint256[] _bonusRanges,
1223     uint256[] _bonusValues
1224   ) public {
1225     // solium-disable-next-line security/no-block-members
1226     require(_endTime >= block.timestamp);
1227     require(_rate > 0);
1228     require(_wallet != address(0));
1229     require(_tokenCap > 0);
1230     require(_token != address(0));
1231     require(_contributions != address(0));
1232     require(_bonusRanges.length == _bonusValues.length);
1233 
1234     for (uint256 i = 0; i < (_bonusValues.length - 1); i++) {
1235       require(_bonusValues[i] > _bonusValues[i + 1]);
1236       require(_bonusRanges[i] > _bonusRanges[i + 1]);
1237     }
1238 
1239     endTime = _endTime;
1240     rate = _rate;
1241     wallet = _wallet;
1242     tokenCap = _tokenCap;
1243     token = _token;
1244     minimumContribution = _minimumContribution;
1245     contributions = _contributions;
1246     bonusRanges = _bonusRanges;
1247     bonusValues = _bonusValues;
1248   }
1249 
1250   function startCrowdsales(uint256 _number) public onlyOwner {
1251     for (uint256 i = 0; i < _number; i++) {
1252       ForkRC crowd = new ForkRC(
1253         block.timestamp, // solium-disable-line security/no-block-members
1254         endTime,
1255         rate,
1256         wallet,
1257         tokenCap,
1258         minimumContribution,
1259         token,
1260         contributions
1261       );
1262 
1263       crowd.setBonusRates(bonusRanges, bonusValues);
1264       crowd.transferOwnership(msg.sender);
1265       crowdsaleList.push(address(crowd));
1266       emit CrowdsaleStarted(address(crowd));
1267     }
1268   }
1269 
1270   function getCrowdsalesLength() public view returns (uint) {
1271     return crowdsaleList.length;
1272   }
1273 }