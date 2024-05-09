1 pragma solidity 0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * See https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address _who) public view returns (uint256);
11   function transfer(address _to, uint256 _value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
25     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
26     // benefit is lost if 'b' is also tested.
27     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
28     if (_a == 0) {
29       return 0;
30     }
31 
32     c = _a * _b;
33     assert(c / _a == _b);
34     return c;
35   }
36 
37   /**
38   * @dev Integer division of two numbers, truncating the quotient.
39   */
40   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     // assert(_b > 0); // Solidity automatically throws when dividing by 0
42     // uint256 c = _a / _b;
43     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
44     return _a / _b;
45   }
46 
47   /**
48   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
51     assert(_b <= _a);
52     return _a - _b;
53   }
54 
55   /**
56   * @dev Adds two numbers, throws on overflow.
57   */
58   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
59     c = _a + _b;
60     assert(c >= _a);
61     return c;
62   }
63 }
64 
65 /**
66  * @title Basic token
67  * @dev Basic version of StandardToken, with no allowances.
68  */
69 contract BasicToken is ERC20Basic {
70   using SafeMath for uint256;
71 
72   mapping(address => uint256) internal balances;
73 
74   uint256 internal totalSupply_;
75 
76   /**
77   * @dev Total number of tokens in existence
78   */
79   function totalSupply() public view returns (uint256) {
80     return totalSupply_;
81   }
82 
83   /**
84   * @dev Transfer token for a specified address
85   * @param _to The address to transfer to.
86   * @param _value The amount to be transferred.
87   */
88   function transfer(address _to, uint256 _value) public returns (bool) {
89     require(_value <= balances[msg.sender]);
90     require(_to != address(0));
91 
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     emit Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   /**
99   * @dev Gets the balance of the specified address.
100   * @param _owner The address to query the the balance of.
101   * @return An uint256 representing the amount owned by the passed address.
102   */
103   function balanceOf(address _owner) public view returns (uint256) {
104     return balances[_owner];
105   }
106 
107 }
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address _owner, address _spender)
115     public view returns (uint256);
116 
117   function transferFrom(address _from, address _to, uint256 _value)
118     public returns (bool);
119 
120   function approve(address _spender, uint256 _value) public returns (bool);
121   event Approval(
122     address indexed owner,
123     address indexed spender,
124     uint256 value
125   );
126 }
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * https://github.com/ethereum/EIPs/issues/20
133  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is ERC20, BasicToken {
136 
137   mapping (address => mapping (address => uint256)) internal allowed;
138 
139 
140   /**
141    * @dev Transfer tokens from one address to another
142    * @param _from address The address which you want to send tokens from
143    * @param _to address The address which you want to transfer to
144    * @param _value uint256 the amount of tokens to be transferred
145    */
146   function transferFrom(
147     address _from,
148     address _to,
149     uint256 _value
150   )
151     public
152     returns (bool)
153   {
154     require(_value <= balances[_from]);
155     require(_value <= allowed[_from][msg.sender]);
156     require(_to != address(0));
157 
158     balances[_from] = balances[_from].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
161     emit Transfer(_from, _to, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167    * Beware that changing an allowance with this method brings the risk that someone may use both the old
168    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171    * @param _spender The address which will spend the funds.
172    * @param _value The amount of tokens to be spent.
173    */
174   function approve(address _spender, uint256 _value) public returns (bool) {
175     allowed[msg.sender][_spender] = _value;
176     emit Approval(msg.sender, _spender, _value);
177     return true;
178   }
179 
180   /**
181    * @dev Function to check the amount of tokens that an owner allowed to a spender.
182    * @param _owner address The address which owns the funds.
183    * @param _spender address The address which will spend the funds.
184    * @return A uint256 specifying the amount of tokens still available for the spender.
185    */
186   function allowance(
187     address _owner,
188     address _spender
189    )
190     public
191     view
192     returns (uint256)
193   {
194     return allowed[_owner][_spender];
195   }
196 
197   /**
198    * @dev Increase the amount of tokens that an owner allowed to a spender.
199    * approve should be called when allowed[_spender] == 0. To increment
200    * allowed value is better to use this function to avoid 2 calls (and wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    * @param _spender The address which will spend the funds.
204    * @param _addedValue The amount of tokens to increase the allowance by.
205    */
206   function increaseApproval(
207     address _spender,
208     uint256 _addedValue
209   )
210     public
211     returns (bool)
212   {
213     allowed[msg.sender][_spender] = (
214       allowed[msg.sender][_spender].add(_addedValue));
215     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219   /**
220    * @dev Decrease the amount of tokens that an owner allowed to a spender.
221    * approve should be called when allowed[_spender] == 0. To decrement
222    * allowed value is better to use this function to avoid 2 calls (and wait until
223    * the first transaction is mined)
224    * From MonolithDAO Token.sol
225    * @param _spender The address which will spend the funds.
226    * @param _subtractedValue The amount of tokens to decrease the allowance by.
227    */
228   function decreaseApproval(
229     address _spender,
230     uint256 _subtractedValue
231   )
232     public
233     returns (bool)
234   {
235     uint256 oldValue = allowed[msg.sender][_spender];
236     if (_subtractedValue >= oldValue) {
237       allowed[msg.sender][_spender] = 0;
238     } else {
239       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
240     }
241     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242     return true;
243   }
244 
245 }
246 
247 /**
248  * @title Ownable
249  * @dev The Ownable contract has an owner address, and provides basic authorization control
250  * functions, this simplifies the implementation of "user permissions".
251  */
252 contract Ownable {
253   address public owner;
254 
255 
256   event OwnershipRenounced(address indexed previousOwner);
257   event OwnershipTransferred(
258     address indexed previousOwner,
259     address indexed newOwner
260   );
261 
262 
263   /**
264    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
265    * account.
266    */
267   constructor() public {
268     owner = msg.sender;
269   }
270 
271   /**
272    * @dev Throws if called by any account other than the owner.
273    */
274   modifier onlyOwner() {
275     require(msg.sender == owner);
276     _;
277   }
278 
279   /**
280    * @dev Allows the current owner to relinquish control of the contract.
281    * @notice Renouncing to ownership will leave the contract without an owner.
282    * It will not be possible to call the functions with the `onlyOwner`
283    * modifier anymore.
284    */
285   function renounceOwnership() public onlyOwner {
286     emit OwnershipRenounced(owner);
287     owner = address(0);
288   }
289 
290   /**
291    * @dev Allows the current owner to transfer control of the contract to a newOwner.
292    * @param _newOwner The address to transfer ownership to.
293    */
294   function transferOwnership(address _newOwner) public onlyOwner {
295     _transferOwnership(_newOwner);
296   }
297 
298   /**
299    * @dev Transfers control of the contract to a newOwner.
300    * @param _newOwner The address to transfer ownership to.
301    */
302   function _transferOwnership(address _newOwner) internal {
303     require(_newOwner != address(0));
304     emit OwnershipTransferred(owner, _newOwner);
305     owner = _newOwner;
306   }
307 }
308 
309 /**
310  * @title Mintable token
311  * @dev Simple ERC20 Token example, with mintable token creation
312  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
313  */
314 contract MintableToken is StandardToken, Ownable {
315   event Mint(address indexed to, uint256 amount);
316   event MintFinished();
317 
318   bool public mintingFinished = false;
319 
320 
321   modifier canMint() {
322     require(!mintingFinished);
323     _;
324   }
325 
326   modifier hasMintPermission() {
327     require(msg.sender == owner);
328     _;
329   }
330 
331   /**
332    * @dev Function to mint tokens
333    * @param _to The address that will receive the minted tokens.
334    * @param _amount The amount of tokens to mint.
335    * @return A boolean that indicates if the operation was successful.
336    */
337   function mint(
338     address _to,
339     uint256 _amount
340   )
341     public
342     hasMintPermission
343     canMint
344     returns (bool)
345   {
346     totalSupply_ = totalSupply_.add(_amount);
347     balances[_to] = balances[_to].add(_amount);
348     emit Mint(_to, _amount);
349     emit Transfer(address(0), _to, _amount);
350     return true;
351   }
352 
353   /**
354    * @dev Function to stop minting new tokens.
355    * @return True if the operation was successful.
356    */
357   function finishMinting() public onlyOwner canMint returns (bool) {
358     mintingFinished = true;
359     emit MintFinished();
360     return true;
361   }
362 }
363 
364 /**
365  * @title Capped token
366  * @dev Mintable token with a token cap.
367  */
368 contract CappedToken is MintableToken {
369 
370   uint256 public cap;
371 
372   constructor(uint256 _cap) public {
373     require(_cap > 0);
374     cap = _cap;
375   }
376 
377   /**
378    * @dev Function to mint tokens
379    * @param _to The address that will receive the minted tokens.
380    * @param _amount The amount of tokens to mint.
381    * @return A boolean that indicates if the operation was successful.
382    */
383   function mint(
384     address _to,
385     uint256 _amount
386   )
387     public
388     returns (bool)
389   {
390     require(totalSupply_.add(_amount) <= cap);
391 
392     return super.mint(_to, _amount);
393   }
394 
395 }
396 
397 contract CWTPToken is CappedToken {
398   string public constant name = "Pre-sale CryptoWorkPlace Token";
399   string public constant symbol = "CWT-P";
400   uint8 public constant decimals = 18;
401   uint256 public constant MAX_SUPPLY = 15000000 * (uint256(10) ** decimals); //3% of 500 000 000
402 
403   constructor() public CappedToken(MAX_SUPPLY) {}
404 }
405 
406 /**
407  * @title SafeERC20
408  * @dev Wrappers around ERC20 operations that throw on failure.
409  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
410  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
411  */
412 library SafeERC20 {
413   function safeTransfer(
414     ERC20Basic _token,
415     address _to,
416     uint256 _value
417   )
418     internal
419   {
420     require(_token.transfer(_to, _value));
421   }
422 
423   function safeTransferFrom(
424     ERC20 _token,
425     address _from,
426     address _to,
427     uint256 _value
428   )
429     internal
430   {
431     require(_token.transferFrom(_from, _to, _value));
432   }
433 
434   function safeApprove(
435     ERC20 _token,
436     address _spender,
437     uint256 _value
438   )
439     internal
440   {
441     require(_token.approve(_spender, _value));
442   }
443 }
444 
445 /**
446  * @title Crowdsale
447  * @dev Crowdsale is a base contract for managing a token crowdsale,
448  * allowing investors to purchase tokens with ether. This contract implements
449  * such functionality in its most fundamental form and can be extended to provide additional
450  * functionality and/or custom behavior.
451  * The external interface represents the basic interface for purchasing tokens, and conform
452  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
453  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
454  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
455  * behavior.
456  */
457 contract Crowdsale {
458   using SafeMath for uint256;
459   using SafeERC20 for ERC20;
460 
461   // The token being sold
462   ERC20 public token;
463 
464   // Address where funds are collected
465   address public wallet;
466 
467   // How many token units a buyer gets per wei.
468   // The rate is the conversion between wei and the smallest and indivisible token unit.
469   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
470   // 1 wei will give you 1 unit, or 0.001 TOK.
471   uint256 public rate;
472 
473   // Amount of wei raised
474   uint256 public weiRaised;
475 
476   /**
477    * Event for token purchase logging
478    * @param purchaser who paid for the tokens
479    * @param beneficiary who got the tokens
480    * @param value weis paid for purchase
481    * @param amount amount of tokens purchased
482    */
483   event TokenPurchase(
484     address indexed purchaser,
485     address indexed beneficiary,
486     uint256 value,
487     uint256 amount
488   );
489 
490   /**
491    * @param _rate Number of token units a buyer gets per wei
492    * @param _wallet Address where collected funds will be forwarded to
493    * @param _token Address of the token being sold
494    */
495   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
496     require(_rate > 0);
497     require(_wallet != address(0));
498     require(_token != address(0));
499 
500     rate = _rate;
501     wallet = _wallet;
502     token = _token;
503   }
504 
505   // -----------------------------------------
506   // Crowdsale external interface
507   // -----------------------------------------
508 
509   /**
510    * @dev fallback function ***DO NOT OVERRIDE***
511    */
512   function () external payable {
513     buyTokens(msg.sender);
514   }
515 
516   /**
517    * @dev low level token purchase ***DO NOT OVERRIDE***
518    * @param _beneficiary Address performing the token purchase
519    */
520   function buyTokens(address _beneficiary) public payable {
521 
522     uint256 weiAmount = msg.value;
523     _preValidatePurchase(_beneficiary, weiAmount);
524 
525     // calculate token amount to be created
526     uint256 tokens = _getTokenAmount(weiAmount);
527 
528     // update state
529     weiRaised = weiRaised.add(weiAmount);
530 
531     _processPurchase(_beneficiary, tokens);
532     emit TokenPurchase(
533       msg.sender,
534       _beneficiary,
535       weiAmount,
536       tokens
537     );
538 
539     _updatePurchasingState(_beneficiary, weiAmount);
540 
541     _forwardFunds();
542     _postValidatePurchase(_beneficiary, weiAmount);
543   }
544 
545   // -----------------------------------------
546   // Internal interface (extensible)
547   // -----------------------------------------
548 
549   /**
550    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
551    * Example from CappedCrowdsale.sol's _preValidatePurchase method: 
552    *   super._preValidatePurchase(_beneficiary, _weiAmount);
553    *   require(weiRaised.add(_weiAmount) <= cap);
554    * @param _beneficiary Address performing the token purchase
555    * @param _weiAmount Value in wei involved in the purchase
556    */
557   function _preValidatePurchase(
558     address _beneficiary,
559     uint256 _weiAmount
560   )
561     internal
562   {
563     require(_beneficiary != address(0));
564     require(_weiAmount != 0);
565   }
566 
567   /**
568    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
569    * @param _beneficiary Address performing the token purchase
570    * @param _weiAmount Value in wei involved in the purchase
571    */
572   function _postValidatePurchase(
573     address _beneficiary,
574     uint256 _weiAmount
575   )
576     internal
577   {
578     // optional override
579   }
580 
581   /**
582    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
583    * @param _beneficiary Address performing the token purchase
584    * @param _tokenAmount Number of tokens to be emitted
585    */
586   function _deliverTokens(
587     address _beneficiary,
588     uint256 _tokenAmount
589   )
590     internal
591   {
592     token.safeTransfer(_beneficiary, _tokenAmount);
593   }
594 
595   /**
596    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
597    * @param _beneficiary Address receiving the tokens
598    * @param _tokenAmount Number of tokens to be purchased
599    */
600   function _processPurchase(
601     address _beneficiary,
602     uint256 _tokenAmount
603   )
604     internal
605   {
606     _deliverTokens(_beneficiary, _tokenAmount);
607   }
608 
609   /**
610    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
611    * @param _beneficiary Address receiving the tokens
612    * @param _weiAmount Value in wei involved in the purchase
613    */
614   function _updatePurchasingState(
615     address _beneficiary,
616     uint256 _weiAmount
617   )
618     internal
619   {
620     // optional override
621   }
622 
623   /**
624    * @dev Override to extend the way in which ether is converted to tokens.
625    * @param _weiAmount Value in wei to be converted into tokens
626    * @return Number of tokens that can be purchased with the specified _weiAmount
627    */
628   function _getTokenAmount(uint256 _weiAmount)
629     internal view returns (uint256)
630   {
631     return _weiAmount.mul(rate);
632   }
633 
634   /**
635    * @dev Determines how ETH is stored/forwarded on purchases.
636    */
637   function _forwardFunds() internal {
638     wallet.transfer(msg.value);
639   }
640 }
641 
642 /**
643  * @title MintedCrowdsale
644  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
645  * Token ownership should be transferred to MintedCrowdsale for minting.
646  */
647 contract MintedCrowdsale is Crowdsale {
648 
649   /**
650    * @dev Overrides delivery by minting tokens upon purchase.
651    * @param _beneficiary Token purchaser
652    * @param _tokenAmount Number of tokens to be minted
653    */
654   function _deliverTokens(
655     address _beneficiary,
656     uint256 _tokenAmount
657   )
658     internal
659   {
660     // Potentially dangerous assumption about the type of the token.
661     require(MintableToken(address(token)).mint(_beneficiary, _tokenAmount));
662   }
663 }
664 
665 /**
666  * @title CappedCrowdsale
667  * @dev Crowdsale with a limit for total contributions.
668  */
669 contract CappedCrowdsale is Crowdsale {
670   using SafeMath for uint256;
671 
672   uint256 public cap;
673 
674   /**
675    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
676    * @param _cap Max amount of wei to be contributed
677    */
678   constructor(uint256 _cap) public {
679     require(_cap > 0);
680     cap = _cap;
681   }
682 
683   /**
684    * @dev Checks whether the cap has been reached.
685    * @return Whether the cap was reached
686    */
687   function capReached() public view returns (bool) {
688     return weiRaised >= cap;
689   }
690 
691   /**
692    * @dev Extend parent behavior requiring purchase to respect the funding cap.
693    * @param _beneficiary Token purchaser
694    * @param _weiAmount Amount of wei contributed
695    */
696   function _preValidatePurchase(
697     address _beneficiary,
698     uint256 _weiAmount
699   )
700     internal
701   {
702     super._preValidatePurchase(_beneficiary, _weiAmount);
703     require(weiRaised.add(_weiAmount) <= cap);
704   }
705 
706 }
707 
708 /**
709  * @title TimedCrowdsale
710  * @dev Crowdsale accepting contributions only within a time frame.
711  */
712 contract TimedCrowdsale is Crowdsale {
713   using SafeMath for uint256;
714 
715   uint256 public openingTime;
716   uint256 public closingTime;
717 
718   /**
719    * @dev Reverts if not in crowdsale time range.
720    */
721   modifier onlyWhileOpen {
722     // solium-disable-next-line security/no-block-members
723     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
724     _;
725   }
726 
727   /**
728    * @dev Constructor, takes crowdsale opening and closing times.
729    * @param _openingTime Crowdsale opening time
730    * @param _closingTime Crowdsale closing time
731    */
732   constructor(uint256 _openingTime, uint256 _closingTime) public {
733     // solium-disable-next-line security/no-block-members
734     require(_openingTime >= block.timestamp);
735     require(_closingTime >= _openingTime);
736 
737     openingTime = _openingTime;
738     closingTime = _closingTime;
739   }
740 
741   /**
742    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
743    * @return Whether crowdsale period has elapsed
744    */
745   function hasClosed() public view returns (bool) {
746     // solium-disable-next-line security/no-block-members
747     return block.timestamp > closingTime;
748   }
749 
750   /**
751    * @dev Extend parent behavior requiring to be within contributing period
752    * @param _beneficiary Token purchaser
753    * @param _weiAmount Amount of wei contributed
754    */
755   function _preValidatePurchase(
756     address _beneficiary,
757     uint256 _weiAmount
758   )
759     internal
760     onlyWhileOpen
761   {
762     super._preValidatePurchase(_beneficiary, _weiAmount);
763   }
764 
765 }
766 
767 /**
768  * @title Roles
769  * @author Francisco Giordano (@frangio)
770  * @dev Library for managing addresses assigned to a Role.
771  * See RBAC.sol for example usage.
772  */
773 library Roles {
774   struct Role {
775     mapping (address => bool) bearer;
776   }
777 
778   /**
779    * @dev give an address access to this role
780    */
781   function add(Role storage _role, address _addr)
782     internal
783   {
784     _role.bearer[_addr] = true;
785   }
786 
787   /**
788    * @dev remove an address' access to this role
789    */
790   function remove(Role storage _role, address _addr)
791     internal
792   {
793     _role.bearer[_addr] = false;
794   }
795 
796   /**
797    * @dev check if an address has this role
798    * // reverts
799    */
800   function check(Role storage _role, address _addr)
801     internal
802     view
803   {
804     require(has(_role, _addr));
805   }
806 
807   /**
808    * @dev check if an address has this role
809    * @return bool
810    */
811   function has(Role storage _role, address _addr)
812     internal
813     view
814     returns (bool)
815   {
816     return _role.bearer[_addr];
817   }
818 }
819 
820 /**
821  * @title RBAC (Role-Based Access Control)
822  * @author Matt Condon (@Shrugs)
823  * @dev Stores and provides setters and getters for roles and addresses.
824  * Supports unlimited numbers of roles and addresses.
825  * See //contracts/mocks/RBACMock.sol for an example of usage.
826  * This RBAC method uses strings to key roles. It may be beneficial
827  * for you to write your own implementation of this interface using Enums or similar.
828  */
829 contract RBAC {
830   using Roles for Roles.Role;
831 
832   mapping (string => Roles.Role) private roles;
833 
834   event RoleAdded(address indexed operator, string role);
835   event RoleRemoved(address indexed operator, string role);
836 
837   /**
838    * @dev reverts if addr does not have role
839    * @param _operator address
840    * @param _role the name of the role
841    * // reverts
842    */
843   function checkRole(address _operator, string _role)
844     public
845     view
846   {
847     roles[_role].check(_operator);
848   }
849 
850   /**
851    * @dev determine if addr has role
852    * @param _operator address
853    * @param _role the name of the role
854    * @return bool
855    */
856   function hasRole(address _operator, string _role)
857     public
858     view
859     returns (bool)
860   {
861     return roles[_role].has(_operator);
862   }
863 
864   /**
865    * @dev add a role to an address
866    * @param _operator address
867    * @param _role the name of the role
868    */
869   function addRole(address _operator, string _role)
870     internal
871   {
872     roles[_role].add(_operator);
873     emit RoleAdded(_operator, _role);
874   }
875 
876   /**
877    * @dev remove a role from an address
878    * @param _operator address
879    * @param _role the name of the role
880    */
881   function removeRole(address _operator, string _role)
882     internal
883   {
884     roles[_role].remove(_operator);
885     emit RoleRemoved(_operator, _role);
886   }
887 
888   /**
889    * @dev modifier to scope access to a single role (uses msg.sender as addr)
890    * @param _role the name of the role
891    * // reverts
892    */
893   modifier onlyRole(string _role)
894   {
895     checkRole(msg.sender, _role);
896     _;
897   }
898 
899   /**
900    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
901    * @param _roles the names of the roles to scope access to
902    * // reverts
903    *
904    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
905    *  see: https://github.com/ethereum/solidity/issues/2467
906    */
907   // modifier onlyRoles(string[] _roles) {
908   //     bool hasAnyRole = false;
909   //     for (uint8 i = 0; i < _roles.length; i++) {
910   //         if (hasRole(msg.sender, _roles[i])) {
911   //             hasAnyRole = true;
912   //             break;
913   //         }
914   //     }
915 
916   //     require(hasAnyRole);
917 
918   //     _;
919   // }
920 }
921 
922 /**
923  * @title Whitelist
924  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
925  * This simplifies the implementation of "user permissions".
926  */
927 contract Whitelist is Ownable, RBAC {
928   string public constant ROLE_WHITELISTED = "whitelist";
929 
930   /**
931    * @dev Throws if operator is not whitelisted.
932    * @param _operator address
933    */
934   modifier onlyIfWhitelisted(address _operator) {
935     checkRole(_operator, ROLE_WHITELISTED);
936     _;
937   }
938 
939   /**
940    * @dev add an address to the whitelist
941    * @param _operator address
942    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
943    */
944   function addAddressToWhitelist(address _operator)
945     public
946     onlyOwner
947   {
948     addRole(_operator, ROLE_WHITELISTED);
949   }
950 
951   /**
952    * @dev getter to determine if address is in whitelist
953    */
954   function whitelist(address _operator)
955     public
956     view
957     returns (bool)
958   {
959     return hasRole(_operator, ROLE_WHITELISTED);
960   }
961 
962   /**
963    * @dev add addresses to the whitelist
964    * @param _operators addresses
965    * @return true if at least one address was added to the whitelist,
966    * false if all addresses were already in the whitelist
967    */
968   function addAddressesToWhitelist(address[] _operators)
969     public
970     onlyOwner
971   {
972     for (uint256 i = 0; i < _operators.length; i++) {
973       addAddressToWhitelist(_operators[i]);
974     }
975   }
976 
977   /**
978    * @dev remove an address from the whitelist
979    * @param _operator address
980    * @return true if the address was removed from the whitelist,
981    * false if the address wasn't in the whitelist in the first place
982    */
983   function removeAddressFromWhitelist(address _operator)
984     public
985     onlyOwner
986   {
987     removeRole(_operator, ROLE_WHITELISTED);
988   }
989 
990   /**
991    * @dev remove addresses from the whitelist
992    * @param _operators addresses
993    * @return true if at least one address was removed from the whitelist,
994    * false if all addresses weren't in the whitelist in the first place
995    */
996   function removeAddressesFromWhitelist(address[] _operators)
997     public
998     onlyOwner
999   {
1000     for (uint256 i = 0; i < _operators.length; i++) {
1001       removeAddressFromWhitelist(_operators[i]);
1002     }
1003   }
1004 
1005 }
1006 
1007 /**
1008  * @title WhitelistedCrowdsale
1009  * @dev Crowdsale in which only whitelisted users can contribute.
1010  */
1011 contract WhitelistedCrowdsale is Whitelist, Crowdsale {
1012   /**
1013    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
1014    * @param _beneficiary Token beneficiary
1015    * @param _weiAmount Amount of wei contributed
1016    */
1017   function _preValidatePurchase(
1018     address _beneficiary,
1019     uint256 _weiAmount
1020   )
1021     internal
1022     onlyIfWhitelisted(_beneficiary)
1023   {
1024     super._preValidatePurchase(_beneficiary, _weiAmount);
1025   }
1026 
1027 }
1028 
1029 /**
1030  * @title Escrow
1031  * @dev Base escrow contract, holds funds destinated to a payee until they
1032  * withdraw them. The contract that uses the escrow as its payment method
1033  * should be its owner, and provide public methods redirecting to the escrow's
1034  * deposit and withdraw.
1035  */
1036 contract Escrow is Ownable {
1037   using SafeMath for uint256;
1038 
1039   event Deposited(address indexed payee, uint256 weiAmount);
1040   event Withdrawn(address indexed payee, uint256 weiAmount);
1041 
1042   mapping(address => uint256) private deposits;
1043 
1044   function depositsOf(address _payee) public view returns (uint256) {
1045     return deposits[_payee];
1046   }
1047 
1048   /**
1049   * @dev Stores the sent amount as credit to be withdrawn.
1050   * @param _payee The destination address of the funds.
1051   */
1052   function deposit(address _payee) public onlyOwner payable {
1053     uint256 amount = msg.value;
1054     deposits[_payee] = deposits[_payee].add(amount);
1055 
1056     emit Deposited(_payee, amount);
1057   }
1058 
1059   /**
1060   * @dev Withdraw accumulated balance for a payee.
1061   * @param _payee The address whose funds will be withdrawn and transferred to.
1062   */
1063   function withdraw(address _payee) public onlyOwner {
1064     uint256 payment = deposits[_payee];
1065     assert(address(this).balance >= payment);
1066 
1067     deposits[_payee] = 0;
1068 
1069     _payee.transfer(payment);
1070 
1071     emit Withdrawn(_payee, payment);
1072   }
1073 }
1074 
1075 /**
1076  * @title PullPayment
1077  * @dev Base contract supporting async send for pull payments. Inherit from this
1078  * contract and use asyncTransfer instead of send or transfer.
1079  */
1080 contract PullPayment {
1081   Escrow private escrow;
1082 
1083   constructor() public {
1084     escrow = new Escrow();
1085   }
1086 
1087   /**
1088   * @dev Withdraw accumulated balance, called by payee.
1089   */
1090   function withdrawPayments() public {
1091     address payee = msg.sender;
1092     escrow.withdraw(payee);
1093   }
1094 
1095   /**
1096   * @dev Returns the credit owed to an address.
1097   * @param _dest The creditor's address.
1098   */
1099   function payments(address _dest) public view returns (uint256) {
1100     return escrow.depositsOf(_dest);
1101   }
1102 
1103   /**
1104   * @dev Called by the payer to store the sent amount as credit to be pulled.
1105   * @param _dest The destination address of the funds.
1106   * @param _amount The amount to transfer.
1107   */
1108   function asyncTransfer(address _dest, uint256 _amount) internal {
1109     escrow.deposit.value(_amount)(_dest);
1110   }
1111 }
1112 
1113 /**
1114  * @title RBACWithAdmin
1115  * @author Matt Condon (@Shrugs)
1116  * @dev It's recommended that you define constants in the contract,
1117  * @dev like ROLE_ADMIN below, to avoid typos.
1118  */
1119 contract RBACWithAdmin is RBAC {
1120   /**
1121    * A constant role name for indicating admins.
1122    */
1123   string public constant ROLE_ADMIN = "admin";
1124 
1125   constructor() public {
1126     addRole(msg.sender, ROLE_ADMIN);
1127   }
1128 
1129   /**
1130    * @dev modifier to scope access to admins
1131    * // reverts
1132    */
1133   modifier onlyAdmin()
1134   {
1135     checkRole(msg.sender, ROLE_ADMIN);
1136     _;
1137   }
1138 
1139   /**
1140    * @dev add a role to an address
1141    * @param addr address
1142    * @param roleName the name of the role
1143    */
1144   function adminAddRole(address addr, string roleName)
1145     onlyAdmin
1146     public
1147   {
1148     addRole(addr, roleName);
1149   }
1150 
1151   /**
1152    * @dev remove a role from an address
1153    * @param addr address
1154    * @param roleName the name of the role
1155    */
1156   function adminRemoveRole(address addr, string roleName)
1157     onlyAdmin
1158     public
1159   {
1160     removeRole(addr, roleName);
1161   }
1162 }
1163 
1164 contract CWTPTokenSale is WhitelistedCrowdsale, MintedCrowdsale, RBACWithAdmin, TimedCrowdsale, PullPayment {
1165 
1166   using SafeMath for uint256;
1167 
1168   struct FixedRate {
1169     uint256 rate;
1170     uint256 time;
1171     uint256 amount;
1172   }
1173 
1174   string public constant ROLE_DAPP = "dapp";
1175   string public constant ROLE_SRV = "service";
1176 
1177   mapping(address => FixedRate) public fixRate;
1178   uint256 public tokenCap;
1179   uint256 public tokenSold;
1180   FixedRate private _currentFRate;
1181 
1182   constructor(uint256 _startTime, uint256 _endTime, address _wallet, CappedToken _tokenAddress) public
1183     TimedCrowdsale(_startTime, _endTime)
1184     Crowdsale(1, _wallet, _tokenAddress)
1185   {
1186     require(Ownable(_tokenAddress) != address(0));
1187     tokenCap = _tokenAddress.cap();
1188     tokenSold = _tokenAddress.totalSupply();
1189 
1190     addRole(msg.sender, ROLE_DAPP);
1191     addRole(msg.sender, ROLE_SRV);
1192   }
1193 
1194   function registerDappAddress(address _dappAddr) public onlyRole(ROLE_ADMIN) {
1195     addRole(_dappAddr, ROLE_DAPP);
1196   }
1197 
1198 /**
1199    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
1200    * @return Whether crowdsale period has elapsed
1201    */
1202   function hasOpened() public view returns (bool) {
1203     // solium-disable-next-line security/no-block-members
1204     return block.timestamp >= openingTime && block.timestamp <= closingTime;
1205   }
1206 
1207   /**
1208    * @dev add an address to the whitelist
1209    * @param _operator address
1210    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
1211    */
1212   function addAddressToWhitelist(address _operator) public onlyRole(ROLE_DAPP)
1213   {
1214     require(block.timestamp <= closingTime);
1215     addRole(_operator, ROLE_WHITELISTED);
1216   }
1217 
1218   function setRateForTransaction(uint256 newRate, address buyer, uint256 amount) public onlyIfWhitelisted(buyer) onlyRole(ROLE_DAPP) onlyWhileOpen
1219   {
1220     fixRate[buyer] = FixedRate(newRate, block.timestamp.add(15 minutes), amount);
1221   }
1222 
1223   /**
1224    * @dev Checks whether the cap has been reached.
1225    * @return Whether the cap was reached
1226    */
1227   function capReached() public view returns (bool) {
1228     return tokenSold >= tokenCap;
1229   }
1230 
1231   /**
1232    * @dev Extend parent behavior requiring beneficiary to be in fix rate list.
1233    * @param _beneficiary Token beneficiary
1234    * @param _weiAmount Amount of wei contributed
1235    */
1236   function _preValidatePurchase(
1237     address _beneficiary,
1238     uint256 _weiAmount
1239   )
1240     internal
1241   {
1242     require(fixRate[_beneficiary].time > block.timestamp);
1243     require(_weiAmount >= fixRate[_beneficiary].amount);
1244     _currentFRate = fixRate[_beneficiary];
1245 
1246     super._preValidatePurchase(_beneficiary, _weiAmount);
1247   }
1248 
1249   /**
1250    * @dev Override to extend the way in which ether is converted to tokens.
1251    * @param _weiAmount Value in wei to be converted into tokens
1252    * @return Number of tokens that can be purchased with the specified _weiAmount
1253    */
1254   function _getTokenAmount(uint256 _weiAmount)
1255     internal view returns (uint256)
1256   {
1257     //_weiAmount
1258 
1259     uint256 tokenAmount = _currentFRate.amount.mul(_currentFRate.rate).div(1 ether).mul(1 ether);
1260     require(tokenSold.add(tokenAmount) <= tokenCap);
1261     return tokenAmount;
1262   }
1263 
1264   /**
1265    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
1266    * @param _beneficiary Address receiving the tokens
1267    * @param _tokenAmount Number of tokens to be purchased
1268    */
1269   function _processPurchase(
1270     address _beneficiary,
1271     uint256 _tokenAmount
1272   )
1273     internal
1274   {
1275     tokenSold = tokenSold.add(_tokenAmount);
1276     super._processPurchase(_beneficiary, _tokenAmount);
1277   }
1278 
1279 
1280   /**
1281    * @dev Determines how ETH is stored/forwarded on purchases.
1282    */
1283   function _forwardFunds() internal {
1284     uint256 refund = msg.value - _currentFRate.amount;
1285     weiRaised.sub(refund); 
1286     wallet.transfer(_currentFRate.amount);
1287     asyncTransfer(msg.sender, refund);
1288   }
1289 
1290   /**
1291    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
1292    * @param _beneficiary Address performing the token purchase
1293    * @param _weiAmount Value in wei involved in the purchase
1294    */
1295   function _postValidatePurchase(
1296     address _beneficiary,
1297     uint256 _weiAmount
1298   )
1299     internal
1300   {
1301     fixRate[_beneficiary].time = block.timestamp;
1302   }
1303 
1304 
1305   /**
1306    * @dev Allows the current owner to relinquish control of the contract.
1307    * @notice Disable renounce ownership
1308    */
1309   function renounceOwnership() public onlyOwner {
1310   }
1311 
1312   function transferTokenOwnership() onlyAdmin private
1313   {
1314     // solium-disable-next-line security/no-block-members
1315     require(hasClosed());
1316     Ownable(token).transferOwnership(msg.sender);
1317   }
1318 
1319   function forceTransferTokenOwnership() onlyOwner private
1320   {
1321     // solium-disable-next-line security/no-block-members
1322     Ownable(token).transferOwnership(msg.sender);
1323   }
1324 
1325   function CloseContract() onlyAdmin public {
1326     require(hasClosed());
1327     if(Ownable(token).owner() == address(this))
1328       transferTokenOwnership();
1329     selfdestruct(msg.sender);
1330   }
1331 
1332   function ForceCloseContract() onlyOwner public {
1333     if(Ownable(token).owner() == address(this))
1334       forceTransferTokenOwnership();
1335     selfdestruct(msg.sender);
1336   }
1337 }