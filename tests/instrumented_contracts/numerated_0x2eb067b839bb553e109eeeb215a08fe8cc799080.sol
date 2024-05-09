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
330 // File: openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
331 
332 /**
333  * @title CappedCrowdsale
334  * @dev Crowdsale with a limit for total contributions.
335  */
336 contract CappedCrowdsale is Crowdsale {
337   using SafeMath for uint256;
338 
339   uint256 public cap;
340 
341   /**
342    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
343    * @param _cap Max amount of wei to be contributed
344    */
345   constructor(uint256 _cap) public {
346     require(_cap > 0);
347     cap = _cap;
348   }
349 
350   /**
351    * @dev Checks whether the cap has been reached.
352    * @return Whether the cap was reached
353    */
354   function capReached() public view returns (bool) {
355     return weiRaised >= cap;
356   }
357 
358   /**
359    * @dev Extend parent behavior requiring purchase to respect the funding cap.
360    * @param _beneficiary Token purchaser
361    * @param _weiAmount Amount of wei contributed
362    */
363   function _preValidatePurchase(
364     address _beneficiary,
365     uint256 _weiAmount
366   )
367     internal
368   {
369     super._preValidatePurchase(_beneficiary, _weiAmount);
370     require(weiRaised.add(_weiAmount) <= cap);
371   }
372 
373 }
374 
375 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
376 
377 /**
378  * @title DetailedERC20 token
379  * @dev The decimals are only for visualization purposes.
380  * All the operations are done using the smallest and indivisible token unit,
381  * just as on Ethereum all the operations are done in wei.
382  */
383 contract DetailedERC20 is ERC20 {
384   string public name;
385   string public symbol;
386   uint8 public decimals;
387 
388   constructor(string _name, string _symbol, uint8 _decimals) public {
389     name = _name;
390     symbol = _symbol;
391     decimals = _decimals;
392   }
393 }
394 
395 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
396 
397 /**
398  * @title Basic token
399  * @dev Basic version of StandardToken, with no allowances.
400  */
401 contract BasicToken is ERC20Basic {
402   using SafeMath for uint256;
403 
404   mapping(address => uint256) internal balances;
405 
406   uint256 internal totalSupply_;
407 
408   /**
409   * @dev Total number of tokens in existence
410   */
411   function totalSupply() public view returns (uint256) {
412     return totalSupply_;
413   }
414 
415   /**
416   * @dev Transfer token for a specified address
417   * @param _to The address to transfer to.
418   * @param _value The amount to be transferred.
419   */
420   function transfer(address _to, uint256 _value) public returns (bool) {
421     require(_value <= balances[msg.sender]);
422     require(_to != address(0));
423 
424     balances[msg.sender] = balances[msg.sender].sub(_value);
425     balances[_to] = balances[_to].add(_value);
426     emit Transfer(msg.sender, _to, _value);
427     return true;
428   }
429 
430   /**
431   * @dev Gets the balance of the specified address.
432   * @param _owner The address to query the the balance of.
433   * @return An uint256 representing the amount owned by the passed address.
434   */
435   function balanceOf(address _owner) public view returns (uint256) {
436     return balances[_owner];
437   }
438 
439 }
440 
441 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
442 
443 /**
444  * @title Standard ERC20 token
445  *
446  * @dev Implementation of the basic standard token.
447  * https://github.com/ethereum/EIPs/issues/20
448  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
449  */
450 contract StandardToken is ERC20, BasicToken {
451 
452   mapping (address => mapping (address => uint256)) internal allowed;
453 
454 
455   /**
456    * @dev Transfer tokens from one address to another
457    * @param _from address The address which you want to send tokens from
458    * @param _to address The address which you want to transfer to
459    * @param _value uint256 the amount of tokens to be transferred
460    */
461   function transferFrom(
462     address _from,
463     address _to,
464     uint256 _value
465   )
466     public
467     returns (bool)
468   {
469     require(_value <= balances[_from]);
470     require(_value <= allowed[_from][msg.sender]);
471     require(_to != address(0));
472 
473     balances[_from] = balances[_from].sub(_value);
474     balances[_to] = balances[_to].add(_value);
475     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
476     emit Transfer(_from, _to, _value);
477     return true;
478   }
479 
480   /**
481    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
482    * Beware that changing an allowance with this method brings the risk that someone may use both the old
483    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
484    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
485    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
486    * @param _spender The address which will spend the funds.
487    * @param _value The amount of tokens to be spent.
488    */
489   function approve(address _spender, uint256 _value) public returns (bool) {
490     allowed[msg.sender][_spender] = _value;
491     emit Approval(msg.sender, _spender, _value);
492     return true;
493   }
494 
495   /**
496    * @dev Function to check the amount of tokens that an owner allowed to a spender.
497    * @param _owner address The address which owns the funds.
498    * @param _spender address The address which will spend the funds.
499    * @return A uint256 specifying the amount of tokens still available for the spender.
500    */
501   function allowance(
502     address _owner,
503     address _spender
504    )
505     public
506     view
507     returns (uint256)
508   {
509     return allowed[_owner][_spender];
510   }
511 
512   /**
513    * @dev Increase the amount of tokens that an owner allowed to a spender.
514    * approve should be called when allowed[_spender] == 0. To increment
515    * allowed value is better to use this function to avoid 2 calls (and wait until
516    * the first transaction is mined)
517    * From MonolithDAO Token.sol
518    * @param _spender The address which will spend the funds.
519    * @param _addedValue The amount of tokens to increase the allowance by.
520    */
521   function increaseApproval(
522     address _spender,
523     uint256 _addedValue
524   )
525     public
526     returns (bool)
527   {
528     allowed[msg.sender][_spender] = (
529       allowed[msg.sender][_spender].add(_addedValue));
530     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
531     return true;
532   }
533 
534   /**
535    * @dev Decrease the amount of tokens that an owner allowed to a spender.
536    * approve should be called when allowed[_spender] == 0. To decrement
537    * allowed value is better to use this function to avoid 2 calls (and wait until
538    * the first transaction is mined)
539    * From MonolithDAO Token.sol
540    * @param _spender The address which will spend the funds.
541    * @param _subtractedValue The amount of tokens to decrease the allowance by.
542    */
543   function decreaseApproval(
544     address _spender,
545     uint256 _subtractedValue
546   )
547     public
548     returns (bool)
549   {
550     uint256 oldValue = allowed[msg.sender][_spender];
551     if (_subtractedValue >= oldValue) {
552       allowed[msg.sender][_spender] = 0;
553     } else {
554       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
555     }
556     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
557     return true;
558   }
559 
560 }
561 
562 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
563 
564 /**
565  * @title Ownable
566  * @dev The Ownable contract has an owner address, and provides basic authorization control
567  * functions, this simplifies the implementation of "user permissions".
568  */
569 contract Ownable {
570   address public owner;
571 
572 
573   event OwnershipRenounced(address indexed previousOwner);
574   event OwnershipTransferred(
575     address indexed previousOwner,
576     address indexed newOwner
577   );
578 
579 
580   /**
581    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
582    * account.
583    */
584   constructor() public {
585     owner = msg.sender;
586   }
587 
588   /**
589    * @dev Throws if called by any account other than the owner.
590    */
591   modifier onlyOwner() {
592     require(msg.sender == owner);
593     _;
594   }
595 
596   /**
597    * @dev Allows the current owner to relinquish control of the contract.
598    * @notice Renouncing to ownership will leave the contract without an owner.
599    * It will not be possible to call the functions with the `onlyOwner`
600    * modifier anymore.
601    */
602   function renounceOwnership() public onlyOwner {
603     emit OwnershipRenounced(owner);
604     owner = address(0);
605   }
606 
607   /**
608    * @dev Allows the current owner to transfer control of the contract to a newOwner.
609    * @param _newOwner The address to transfer ownership to.
610    */
611   function transferOwnership(address _newOwner) public onlyOwner {
612     _transferOwnership(_newOwner);
613   }
614 
615   /**
616    * @dev Transfers control of the contract to a newOwner.
617    * @param _newOwner The address to transfer ownership to.
618    */
619   function _transferOwnership(address _newOwner) internal {
620     require(_newOwner != address(0));
621     emit OwnershipTransferred(owner, _newOwner);
622     owner = _newOwner;
623   }
624 }
625 
626 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
627 
628 /**
629  * @title Mintable token
630  * @dev Simple ERC20 Token example, with mintable token creation
631  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
632  */
633 contract MintableToken is StandardToken, Ownable {
634   event Mint(address indexed to, uint256 amount);
635   event MintFinished();
636 
637   bool public mintingFinished = false;
638 
639 
640   modifier canMint() {
641     require(!mintingFinished);
642     _;
643   }
644 
645   modifier hasMintPermission() {
646     require(msg.sender == owner);
647     _;
648   }
649 
650   /**
651    * @dev Function to mint tokens
652    * @param _to The address that will receive the minted tokens.
653    * @param _amount The amount of tokens to mint.
654    * @return A boolean that indicates if the operation was successful.
655    */
656   function mint(
657     address _to,
658     uint256 _amount
659   )
660     public
661     hasMintPermission
662     canMint
663     returns (bool)
664   {
665     totalSupply_ = totalSupply_.add(_amount);
666     balances[_to] = balances[_to].add(_amount);
667     emit Mint(_to, _amount);
668     emit Transfer(address(0), _to, _amount);
669     return true;
670   }
671 
672   /**
673    * @dev Function to stop minting new tokens.
674    * @return True if the operation was successful.
675    */
676   function finishMinting() public onlyOwner canMint returns (bool) {
677     mintingFinished = true;
678     emit MintFinished();
679     return true;
680   }
681 }
682 
683 // File: openzeppelin-solidity/contracts/access/rbac/Roles.sol
684 
685 /**
686  * @title Roles
687  * @author Francisco Giordano (@frangio)
688  * @dev Library for managing addresses assigned to a Role.
689  * See RBAC.sol for example usage.
690  */
691 library Roles {
692   struct Role {
693     mapping (address => bool) bearer;
694   }
695 
696   /**
697    * @dev give an address access to this role
698    */
699   function add(Role storage _role, address _addr)
700     internal
701   {
702     _role.bearer[_addr] = true;
703   }
704 
705   /**
706    * @dev remove an address' access to this role
707    */
708   function remove(Role storage _role, address _addr)
709     internal
710   {
711     _role.bearer[_addr] = false;
712   }
713 
714   /**
715    * @dev check if an address has this role
716    * // reverts
717    */
718   function check(Role storage _role, address _addr)
719     internal
720     view
721   {
722     require(has(_role, _addr));
723   }
724 
725   /**
726    * @dev check if an address has this role
727    * @return bool
728    */
729   function has(Role storage _role, address _addr)
730     internal
731     view
732     returns (bool)
733   {
734     return _role.bearer[_addr];
735   }
736 }
737 
738 // File: openzeppelin-solidity/contracts/access/rbac/RBAC.sol
739 
740 /**
741  * @title RBAC (Role-Based Access Control)
742  * @author Matt Condon (@Shrugs)
743  * @dev Stores and provides setters and getters for roles and addresses.
744  * Supports unlimited numbers of roles and addresses.
745  * See //contracts/mocks/RBACMock.sol for an example of usage.
746  * This RBAC method uses strings to key roles. It may be beneficial
747  * for you to write your own implementation of this interface using Enums or similar.
748  */
749 contract RBAC {
750   using Roles for Roles.Role;
751 
752   mapping (string => Roles.Role) private roles;
753 
754   event RoleAdded(address indexed operator, string role);
755   event RoleRemoved(address indexed operator, string role);
756 
757   /**
758    * @dev reverts if addr does not have role
759    * @param _operator address
760    * @param _role the name of the role
761    * // reverts
762    */
763   function checkRole(address _operator, string _role)
764     public
765     view
766   {
767     roles[_role].check(_operator);
768   }
769 
770   /**
771    * @dev determine if addr has role
772    * @param _operator address
773    * @param _role the name of the role
774    * @return bool
775    */
776   function hasRole(address _operator, string _role)
777     public
778     view
779     returns (bool)
780   {
781     return roles[_role].has(_operator);
782   }
783 
784   /**
785    * @dev add a role to an address
786    * @param _operator address
787    * @param _role the name of the role
788    */
789   function addRole(address _operator, string _role)
790     internal
791   {
792     roles[_role].add(_operator);
793     emit RoleAdded(_operator, _role);
794   }
795 
796   /**
797    * @dev remove a role from an address
798    * @param _operator address
799    * @param _role the name of the role
800    */
801   function removeRole(address _operator, string _role)
802     internal
803   {
804     roles[_role].remove(_operator);
805     emit RoleRemoved(_operator, _role);
806   }
807 
808   /**
809    * @dev modifier to scope access to a single role (uses msg.sender as addr)
810    * @param _role the name of the role
811    * // reverts
812    */
813   modifier onlyRole(string _role)
814   {
815     checkRole(msg.sender, _role);
816     _;
817   }
818 
819   /**
820    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
821    * @param _roles the names of the roles to scope access to
822    * // reverts
823    *
824    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
825    *  see: https://github.com/ethereum/solidity/issues/2467
826    */
827   // modifier onlyRoles(string[] _roles) {
828   //     bool hasAnyRole = false;
829   //     for (uint8 i = 0; i < _roles.length; i++) {
830   //         if (hasRole(msg.sender, _roles[i])) {
831   //             hasAnyRole = true;
832   //             break;
833   //         }
834   //     }
835 
836   //     require(hasAnyRole);
837 
838   //     _;
839   // }
840 }
841 
842 // File: openzeppelin-solidity/contracts/token/ERC20/RBACMintableToken.sol
843 
844 /**
845  * @title RBACMintableToken
846  * @author Vittorio Minacori (@vittominacori)
847  * @dev Mintable Token, with RBAC minter permissions
848  */
849 contract RBACMintableToken is MintableToken, RBAC {
850   /**
851    * A constant role name for indicating minters.
852    */
853   string public constant ROLE_MINTER = "minter";
854 
855   /**
856    * @dev override the Mintable token modifier to add role based logic
857    */
858   modifier hasMintPermission() {
859     checkRole(msg.sender, ROLE_MINTER);
860     _;
861   }
862 
863   /**
864    * @dev add a minter role to an address
865    * @param _minter address
866    */
867   function addMinter(address _minter) public onlyOwner {
868     addRole(_minter, ROLE_MINTER);
869   }
870 
871   /**
872    * @dev remove a minter role from an address
873    * @param _minter address
874    */
875   function removeMinter(address _minter) public onlyOwner {
876     removeRole(_minter, ROLE_MINTER);
877   }
878 }
879 
880 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
881 
882 /**
883  * @title Burnable Token
884  * @dev Token that can be irreversibly burned (destroyed).
885  */
886 contract BurnableToken is BasicToken {
887 
888   event Burn(address indexed burner, uint256 value);
889 
890   /**
891    * @dev Burns a specific amount of tokens.
892    * @param _value The amount of token to be burned.
893    */
894   function burn(uint256 _value) public {
895     _burn(msg.sender, _value);
896   }
897 
898   function _burn(address _who, uint256 _value) internal {
899     require(_value <= balances[_who]);
900     // no need to require value <= totalSupply, since that would imply the
901     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
902 
903     balances[_who] = balances[_who].sub(_value);
904     totalSupply_ = totalSupply_.sub(_value);
905     emit Burn(_who, _value);
906     emit Transfer(_who, address(0), _value);
907   }
908 }
909 
910 // File: openzeppelin-solidity/contracts/AddressUtils.sol
911 
912 /**
913  * Utility library of inline functions on addresses
914  */
915 library AddressUtils {
916 
917   /**
918    * Returns whether the target address is a contract
919    * @dev This function will return false if invoked during the constructor of a contract,
920    * as the code is not actually created until after the constructor finishes.
921    * @param _addr address to check
922    * @return whether the target address is a contract
923    */
924   function isContract(address _addr) internal view returns (bool) {
925     uint256 size;
926     // XXX Currently there is no better way to check if there is a contract in an address
927     // than to check the size of the code at that address.
928     // See https://ethereum.stackexchange.com/a/14016/36603
929     // for more details about how this works.
930     // TODO Check this again before the Serenity release, because all addresses will be
931     // contracts then.
932     // solium-disable-next-line security/no-inline-assembly
933     assembly { size := extcodesize(_addr) }
934     return size > 0;
935   }
936 
937 }
938 
939 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
940 
941 /**
942  * @title ERC165
943  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
944  */
945 interface ERC165 {
946 
947   /**
948    * @notice Query if a contract implements an interface
949    * @param _interfaceId The interface identifier, as specified in ERC-165
950    * @dev Interface identification is specified in ERC-165. This function
951    * uses less than 30,000 gas.
952    */
953   function supportsInterface(bytes4 _interfaceId)
954     external
955     view
956     returns (bool);
957 }
958 
959 // File: openzeppelin-solidity/contracts/introspection/SupportsInterfaceWithLookup.sol
960 
961 /**
962  * @title SupportsInterfaceWithLookup
963  * @author Matt Condon (@shrugs)
964  * @dev Implements ERC165 using a lookup table.
965  */
966 contract SupportsInterfaceWithLookup is ERC165 {
967 
968   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
969   /**
970    * 0x01ffc9a7 ===
971    *   bytes4(keccak256('supportsInterface(bytes4)'))
972    */
973 
974   /**
975    * @dev a mapping of interface id to whether or not it's supported
976    */
977   mapping(bytes4 => bool) internal supportedInterfaces;
978 
979   /**
980    * @dev A contract implementing SupportsInterfaceWithLookup
981    * implement ERC165 itself
982    */
983   constructor()
984     public
985   {
986     _registerInterface(InterfaceId_ERC165);
987   }
988 
989   /**
990    * @dev implement supportsInterface(bytes4) using a lookup table
991    */
992   function supportsInterface(bytes4 _interfaceId)
993     external
994     view
995     returns (bool)
996   {
997     return supportedInterfaces[_interfaceId];
998   }
999 
1000   /**
1001    * @dev private method for registering an interface
1002    */
1003   function _registerInterface(bytes4 _interfaceId)
1004     internal
1005   {
1006     require(_interfaceId != 0xffffffff);
1007     supportedInterfaces[_interfaceId] = true;
1008   }
1009 }
1010 
1011 // File: erc-payable-token/contracts/token/ERC1363/ERC1363.sol
1012 
1013 /**
1014  * @title ERC1363 interface
1015  * @author Vittorio Minacori (https://github.com/vittominacori)
1016  * @dev Interface for a Payable Token contract as defined in
1017  *  https://github.com/ethereum/EIPs/issues/1363
1018  */
1019 contract ERC1363 is ERC20, ERC165 {
1020   /*
1021    * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
1022    * 0x4bbee2df ===
1023    *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
1024    *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
1025    *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
1026    *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
1027    */
1028 
1029   /*
1030    * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
1031    * 0xfb9ec8ce ===
1032    *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
1033    *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
1034    */
1035 
1036   /**
1037    * @notice Transfer tokens from `msg.sender` to another address
1038    *  and then call `onTransferReceived` on receiver
1039    * @param _to address The address which you want to transfer to
1040    * @param _value uint256 The amount of tokens to be transferred
1041    * @return true unless throwing
1042    */
1043   function transferAndCall(address _to, uint256 _value) public returns (bool);
1044 
1045   /**
1046    * @notice Transfer tokens from `msg.sender` to another address
1047    *  and then call `onTransferReceived` on receiver
1048    * @param _to address The address which you want to transfer to
1049    * @param _value uint256 The amount of tokens to be transferred
1050    * @param _data bytes Additional data with no specified format, sent in call to `_to`
1051    * @return true unless throwing
1052    */
1053   function transferAndCall(address _to, uint256 _value, bytes _data) public returns (bool); // solium-disable-line max-len
1054 
1055   /**
1056    * @notice Transfer tokens from one address to another
1057    *  and then call `onTransferReceived` on receiver
1058    * @param _from address The address which you want to send tokens from
1059    * @param _to address The address which you want to transfer to
1060    * @param _value uint256 The amount of tokens to be transferred
1061    * @return true unless throwing
1062    */
1063   function transferFromAndCall(address _from, address _to, uint256 _value) public returns (bool); // solium-disable-line max-len
1064 
1065 
1066   /**
1067    * @notice Transfer tokens from one address to another
1068    *  and then call `onTransferReceived` on receiver
1069    * @param _from address The address which you want to send tokens from
1070    * @param _to address The address which you want to transfer to
1071    * @param _value uint256 The amount of tokens to be transferred
1072    * @param _data bytes Additional data with no specified format, sent in call to `_to`
1073    * @return true unless throwing
1074    */
1075   function transferFromAndCall(address _from, address _to, uint256 _value, bytes _data) public returns (bool); // solium-disable-line max-len, arg-overflow
1076 
1077   /**
1078    * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
1079    *  and then call `onApprovalReceived` on spender
1080    *  Beware that changing an allowance with this method brings the risk that someone may use both the old
1081    *  and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1082    *  race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1083    *  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1084    * @param _spender address The address which will spend the funds
1085    * @param _value uint256 The amount of tokens to be spent
1086    */
1087   function approveAndCall(address _spender, uint256 _value) public returns (bool); // solium-disable-line max-len
1088 
1089   /**
1090    * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
1091    *  and then call `onApprovalReceived` on spender
1092    *  Beware that changing an allowance with this method brings the risk that someone may use both the old
1093    *  and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1094    *  race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1095    *  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1096    * @param _spender address The address which will spend the funds
1097    * @param _value uint256 The amount of tokens to be spent
1098    * @param _data bytes Additional data with no specified format, sent in call to `_spender`
1099    */
1100   function approveAndCall(address _spender, uint256 _value, bytes _data) public returns (bool); // solium-disable-line max-len
1101 }
1102 
1103 // File: erc-payable-token/contracts/token/ERC1363/ERC1363Receiver.sol
1104 
1105 /**
1106  * @title ERC1363Receiver interface
1107  * @author Vittorio Minacori (https://github.com/vittominacori)
1108  * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
1109  *  from ERC1363 token contracts as defined in
1110  *  https://github.com/ethereum/EIPs/issues/1363
1111  */
1112 contract ERC1363Receiver {
1113   /*
1114    * Note: the ERC-165 identifier for this interface is 0x88a7ca5c.
1115    * 0x88a7ca5c === bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))
1116    */
1117 
1118   /**
1119    * @notice Handle the receipt of ERC1363 tokens
1120    * @dev Any ERC1363 smart contract calls this function on the recipient
1121    *  after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
1122    *  transfer. Return of other than the magic value MUST result in the
1123    *  transaction being reverted.
1124    *  Note: the token contract address is always the message sender.
1125    * @param _operator address The address which called `transferAndCall` or `transferFromAndCall` function
1126    * @param _from address The address which are token transferred from
1127    * @param _value uint256 The amount of tokens transferred
1128    * @param _data bytes Additional data with no specified format
1129    * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
1130    *  unless throwing
1131    */
1132   function onTransferReceived(address _operator, address _from, uint256 _value, bytes _data) external returns (bytes4); // solium-disable-line max-len, arg-overflow
1133 }
1134 
1135 // File: erc-payable-token/contracts/token/ERC1363/ERC1363Spender.sol
1136 
1137 /**
1138  * @title ERC1363Spender interface
1139  * @author Vittorio Minacori (https://github.com/vittominacori)
1140  * @dev Interface for any contract that wants to support approveAndCall
1141  *  from ERC1363 token contracts as defined in
1142  *  https://github.com/ethereum/EIPs/issues/1363
1143  */
1144 contract ERC1363Spender {
1145   /*
1146    * Note: the ERC-165 identifier for this interface is 0x7b04a2d0.
1147    * 0x7b04a2d0 === bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))
1148    */
1149 
1150   /**
1151    * @notice Handle the approval of ERC1363 tokens
1152    * @dev Any ERC1363 smart contract calls this function on the recipient
1153    *  after an `approve`. This function MAY throw to revert and reject the
1154    *  approval. Return of other than the magic value MUST result in the
1155    *  transaction being reverted.
1156    *  Note: the token contract address is always the message sender.
1157    * @param _owner address The address which called `approveAndCall` function
1158    * @param _value uint256 The amount of tokens to be spent
1159    * @param _data bytes Additional data with no specified format
1160    * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
1161    *  unless throwing
1162    */
1163   function onApprovalReceived(address _owner, uint256 _value, bytes _data) external returns (bytes4); // solium-disable-line max-len
1164 }
1165 
1166 // File: erc-payable-token/contracts/token/ERC1363/ERC1363BasicToken.sol
1167 
1168 // solium-disable-next-line max-len
1169 
1170 
1171 
1172 
1173 
1174 
1175 
1176 /**
1177  * @title ERC1363BasicToken
1178  * @author Vittorio Minacori (https://github.com/vittominacori)
1179  * @dev Implementation of an ERC1363 interface
1180  */
1181 contract ERC1363BasicToken is SupportsInterfaceWithLookup, StandardToken, ERC1363 { // solium-disable-line max-len
1182   using AddressUtils for address;
1183 
1184   /*
1185    * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
1186    * 0x4bbee2df ===
1187    *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
1188    *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
1189    *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
1190    *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
1191    */
1192   bytes4 internal constant InterfaceId_ERC1363Transfer = 0x4bbee2df;
1193 
1194   /*
1195    * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
1196    * 0xfb9ec8ce ===
1197    *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
1198    *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
1199    */
1200   bytes4 internal constant InterfaceId_ERC1363Approve = 0xfb9ec8ce;
1201 
1202   // Equals to `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
1203   // which can be also obtained as `ERC1363Receiver(0).onTransferReceived.selector`
1204   bytes4 private constant ERC1363_RECEIVED = 0x88a7ca5c;
1205 
1206   // Equals to `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
1207   // which can be also obtained as `ERC1363Spender(0).onApprovalReceived.selector`
1208   bytes4 private constant ERC1363_APPROVED = 0x7b04a2d0;
1209 
1210   constructor() public {
1211     // register the supported interfaces to conform to ERC1363 via ERC165
1212     _registerInterface(InterfaceId_ERC1363Transfer);
1213     _registerInterface(InterfaceId_ERC1363Approve);
1214   }
1215 
1216   function transferAndCall(
1217     address _to,
1218     uint256 _value
1219   )
1220     public
1221     returns (bool)
1222   {
1223     return transferAndCall(_to, _value, "");
1224   }
1225 
1226   function transferAndCall(
1227     address _to,
1228     uint256 _value,
1229     bytes _data
1230   )
1231     public
1232     returns (bool)
1233   {
1234     require(transfer(_to, _value));
1235     require(
1236       checkAndCallTransfer(
1237         msg.sender,
1238         _to,
1239         _value,
1240         _data
1241       )
1242     );
1243     return true;
1244   }
1245 
1246   function transferFromAndCall(
1247     address _from,
1248     address _to,
1249     uint256 _value
1250   )
1251     public
1252     returns (bool)
1253   {
1254     // solium-disable-next-line arg-overflow
1255     return transferFromAndCall(_from, _to, _value, "");
1256   }
1257 
1258   function transferFromAndCall(
1259     address _from,
1260     address _to,
1261     uint256 _value,
1262     bytes _data
1263   )
1264     public
1265     returns (bool)
1266   {
1267     require(transferFrom(_from, _to, _value));
1268     require(
1269       checkAndCallTransfer(
1270         _from,
1271         _to,
1272         _value,
1273         _data
1274       )
1275     );
1276     return true;
1277   }
1278 
1279   function approveAndCall(
1280     address _spender,
1281     uint256 _value
1282   )
1283     public
1284     returns (bool)
1285   {
1286     return approveAndCall(_spender, _value, "");
1287   }
1288 
1289   function approveAndCall(
1290     address _spender,
1291     uint256 _value,
1292     bytes _data
1293   )
1294     public
1295     returns (bool)
1296   {
1297     approve(_spender, _value);
1298     require(
1299       checkAndCallApprove(
1300         _spender,
1301         _value,
1302         _data
1303       )
1304     );
1305     return true;
1306   }
1307 
1308   /**
1309    * @dev Internal function to invoke `onTransferReceived` on a target address
1310    *  The call is not executed if the target address is not a contract
1311    * @param _from address Representing the previous owner of the given token value
1312    * @param _to address Target address that will receive the tokens
1313    * @param _value uint256 The amount mount of tokens to be transferred
1314    * @param _data bytes Optional data to send along with the call
1315    * @return whether the call correctly returned the expected magic value
1316    */
1317   function checkAndCallTransfer(
1318     address _from,
1319     address _to,
1320     uint256 _value,
1321     bytes _data
1322   )
1323     internal
1324     returns (bool)
1325   {
1326     if (!_to.isContract()) {
1327       return false;
1328     }
1329     bytes4 retval = ERC1363Receiver(_to).onTransferReceived(
1330       msg.sender, _from, _value, _data
1331     );
1332     return (retval == ERC1363_RECEIVED);
1333   }
1334 
1335   /**
1336    * @dev Internal function to invoke `onApprovalReceived` on a target address
1337    *  The call is not executed if the target address is not a contract
1338    * @param _spender address The address which will spend the funds
1339    * @param _value uint256 The amount of tokens to be spent
1340    * @param _data bytes Optional data to send along with the call
1341    * @return whether the call correctly returned the expected magic value
1342    */
1343   function checkAndCallApprove(
1344     address _spender,
1345     uint256 _value,
1346     bytes _data
1347   )
1348     internal
1349     returns (bool)
1350   {
1351     if (!_spender.isContract()) {
1352       return false;
1353     }
1354     bytes4 retval = ERC1363Spender(_spender).onApprovalReceived(
1355       msg.sender, _value, _data
1356     );
1357     return (retval == ERC1363_APPROVED);
1358   }
1359 }
1360 
1361 // File: eth-token-recover/contracts/TokenRecover.sol
1362 
1363 /**
1364  * @title TokenRecover
1365  * @author Vittorio Minacori (https://github.com/vittominacori)
1366  * @dev Allow to recover any ERC20 sent into the contract for error
1367  */
1368 contract TokenRecover is Ownable {
1369 
1370   /**
1371    * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
1372    * @param _tokenAddress address The token contract address
1373    * @param _tokens Number of tokens to be sent
1374    * @return bool
1375    */
1376   function recoverERC20(
1377     address _tokenAddress,
1378     uint256 _tokens
1379   )
1380   public
1381   onlyOwner
1382   returns (bool success)
1383   {
1384     return ERC20Basic(_tokenAddress).transfer(owner, _tokens);
1385   }
1386 }
1387 
1388 // File: contracts/token/FidelityHouseToken.sol
1389 
1390 // solium-disable-next-line max-len
1391 contract FidelityHouseToken is DetailedERC20, RBACMintableToken, BurnableToken, ERC1363BasicToken, TokenRecover {
1392 
1393   uint256 public lockedUntil;
1394   mapping(address => uint256) internal lockedBalances;
1395 
1396   modifier canTransfer(address _from, uint256 _value) {
1397     require(
1398       mintingFinished,
1399       "Minting should be finished before transfer."
1400     );
1401     require(
1402       _value <= balances[_from].sub(lockedBalanceOf(_from)),
1403       "Can't transfer more than unlocked tokens"
1404     );
1405     _;
1406   }
1407 
1408   constructor(uint256 _lockedUntil)
1409     DetailedERC20("FidelityHouse Token", "FIH", 18)
1410     public
1411   {
1412     lockedUntil = _lockedUntil;
1413   }
1414 
1415   /**
1416    * @dev Gets the locked balance of the specified address.
1417    * @param _owner The address to query the balance of.
1418    * @return An uint256 representing the locked amount owned by the passed address.
1419    */
1420   function lockedBalanceOf(address _owner) public view returns (uint256) {
1421     // solium-disable-next-line security/no-block-members
1422     return block.timestamp <= lockedUntil ? lockedBalances[_owner] : 0;
1423   }
1424 
1425   /**
1426    * @dev Function to mint and lock tokens
1427    * @param _to The address that will receive the minted tokens.
1428    * @param _amount The amount of tokens to mint.
1429    * @return A boolean that indicates if the operation was successful.
1430    */
1431   function mintAndLock(
1432     address _to,
1433     uint256 _amount
1434   )
1435     public
1436     hasMintPermission
1437     canMint
1438     returns (bool)
1439   {
1440     lockedBalances[_to] = lockedBalances[_to].add(_amount);
1441     return super.mint(_to, _amount);
1442   }
1443 
1444   function transfer(
1445     address _to,
1446     uint256 _value
1447   )
1448     public
1449     canTransfer(msg.sender, _value)
1450     returns (bool)
1451   {
1452     return super.transfer(_to, _value);
1453   }
1454 
1455   function transferFrom(
1456     address _from,
1457     address _to,
1458     uint256 _value
1459   )
1460     public
1461     canTransfer(_from, _value)
1462     returns (bool)
1463   {
1464     return super.transferFrom(_from, _to, _value);
1465   }
1466 }
1467 
1468 // File: contracts/crowdsale/base/MintAndLockCrowdsale.sol
1469 
1470 /**
1471  * @title MintAndLockCrowdsale
1472  * @dev Extension of Crowdsale contract whose tokens are minted and locked in each purchase.
1473  */
1474 contract MintAndLockCrowdsale is Crowdsale {
1475 
1476   uint256 public totalRate;
1477   uint256 public bonusRate;
1478 
1479   constructor(uint256 _bonusRate) public {
1480     bonusRate = _bonusRate;
1481     totalRate = rate.add(_getBonusAmount(rate));
1482   }
1483 
1484   /**
1485    * @dev low level token purchase ***DO NOT OVERRIDE***
1486    * @param _beneficiary Address performing the token purchase
1487    */
1488   function buyTokens(address _beneficiary) public payable {
1489 
1490     uint256 weiAmount = msg.value;
1491     _preValidatePurchase(_beneficiary, weiAmount);
1492 
1493     // calculate token amount to be created
1494     uint256 tokens = _getTokenAmount(weiAmount);
1495     uint256 bonus = _getBonusAmount(tokens);
1496 
1497     // update state
1498     weiRaised = weiRaised.add(weiAmount);
1499 
1500     _processPurchase(_beneficiary, tokens);
1501     emit TokenPurchase(
1502       msg.sender,
1503       _beneficiary,
1504       weiAmount,
1505       tokens.add(bonus)
1506     );
1507 
1508     _updatePurchasingState(_beneficiary, weiAmount);
1509 
1510     _forwardFunds();
1511     _postValidatePurchase(_beneficiary, weiAmount);
1512   }
1513 
1514   /**
1515    * @dev Override to extend the way in which bonus is calculated.
1516    * @param _tokenAmount Tokens being purchased
1517    * @return Number of tokens that should be earned as bonus
1518    */
1519   function _getBonusAmount(
1520     uint256 _tokenAmount
1521   )
1522     internal
1523     view
1524     returns (uint256)
1525   {
1526     return _tokenAmount.mul(bonusRate).div(100);
1527   }
1528 
1529   /**
1530    * @dev Overrides delivery by minting and locking tokens upon purchase.
1531    * @param _beneficiary Token purchaser
1532    * @param _tokenAmount Number of tokens to be minted
1533    */
1534   function _deliverTokens(
1535     address _beneficiary,
1536     uint256 _tokenAmount
1537   )
1538     internal
1539   {
1540     FidelityHouseToken(address(token)).mintAndLock(_beneficiary, _tokenAmount);
1541     if (bonusRate > 0) {
1542       FidelityHouseToken(address(token)).mint(_beneficiary, _getBonusAmount(_tokenAmount));
1543     }
1544   }
1545 }
1546 
1547 // File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
1548 
1549 /**
1550  * @title TimedCrowdsale
1551  * @dev Crowdsale accepting contributions only within a time frame.
1552  */
1553 contract TimedCrowdsale is Crowdsale {
1554   using SafeMath for uint256;
1555 
1556   uint256 public openingTime;
1557   uint256 public closingTime;
1558 
1559   /**
1560    * @dev Reverts if not in crowdsale time range.
1561    */
1562   modifier onlyWhileOpen {
1563     // solium-disable-next-line security/no-block-members
1564     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
1565     _;
1566   }
1567 
1568   /**
1569    * @dev Constructor, takes crowdsale opening and closing times.
1570    * @param _openingTime Crowdsale opening time
1571    * @param _closingTime Crowdsale closing time
1572    */
1573   constructor(uint256 _openingTime, uint256 _closingTime) public {
1574     // solium-disable-next-line security/no-block-members
1575     require(_openingTime >= block.timestamp);
1576     require(_closingTime >= _openingTime);
1577 
1578     openingTime = _openingTime;
1579     closingTime = _closingTime;
1580   }
1581 
1582   /**
1583    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
1584    * @return Whether crowdsale period has elapsed
1585    */
1586   function hasClosed() public view returns (bool) {
1587     // solium-disable-next-line security/no-block-members
1588     return block.timestamp > closingTime;
1589   }
1590 
1591   /**
1592    * @dev Extend parent behavior requiring to be within contributing period
1593    * @param _beneficiary Token purchaser
1594    * @param _weiAmount Amount of wei contributed
1595    */
1596   function _preValidatePurchase(
1597     address _beneficiary,
1598     uint256 _weiAmount
1599   )
1600     internal
1601     onlyWhileOpen
1602   {
1603     super._preValidatePurchase(_beneficiary, _weiAmount);
1604   }
1605 
1606 }
1607 
1608 // File: contracts/crowdsale/utils/Contributions.sol
1609 
1610 contract Contributions is RBAC, Ownable {
1611   using SafeMath for uint256;
1612 
1613   uint256 private constant TIER_DELETED = 999;
1614   string public constant ROLE_MINTER = "minter";
1615   string public constant ROLE_OPERATOR = "operator";
1616 
1617   uint256 public tierLimit;
1618 
1619   modifier onlyMinter () {
1620     checkRole(msg.sender, ROLE_MINTER);
1621     _;
1622   }
1623 
1624   modifier onlyOperator () {
1625     checkRole(msg.sender, ROLE_OPERATOR);
1626     _;
1627   }
1628 
1629   uint256 public totalSoldTokens;
1630   mapping(address => uint256) public tokenBalances;
1631   mapping(address => uint256) public ethContributions;
1632   mapping(address => uint256) private _whitelistTier;
1633   address[] public tokenAddresses;
1634   address[] public ethAddresses;
1635   address[] private whitelistAddresses;
1636 
1637   constructor(uint256 _tierLimit) public {
1638     addRole(owner, ROLE_OPERATOR);
1639     tierLimit = _tierLimit;
1640   }
1641 
1642   function addMinter(address minter) external onlyOwner {
1643     addRole(minter, ROLE_MINTER);
1644   }
1645 
1646   function removeMinter(address minter) external onlyOwner {
1647     removeRole(minter, ROLE_MINTER);
1648   }
1649 
1650   function addOperator(address _operator) external onlyOwner {
1651     addRole(_operator, ROLE_OPERATOR);
1652   }
1653 
1654   function removeOperator(address _operator) external onlyOwner {
1655     removeRole(_operator, ROLE_OPERATOR);
1656   }
1657 
1658   function addTokenBalance(
1659     address _address,
1660     uint256 _tokenAmount
1661   )
1662     external
1663     onlyMinter
1664   {
1665     if (tokenBalances[_address] == 0) {
1666       tokenAddresses.push(_address);
1667     }
1668     tokenBalances[_address] = tokenBalances[_address].add(_tokenAmount);
1669     totalSoldTokens = totalSoldTokens.add(_tokenAmount);
1670   }
1671 
1672   function addEthContribution(
1673     address _address,
1674     uint256 _weiAmount
1675   )
1676     external
1677     onlyMinter
1678   {
1679     if (ethContributions[_address] == 0) {
1680       ethAddresses.push(_address);
1681     }
1682     ethContributions[_address] = ethContributions[_address].add(_weiAmount);
1683   }
1684 
1685   function setTierLimit(uint256 _newTierLimit) external onlyOperator {
1686     require(_newTierLimit > 0, "Tier must be greater than zero");
1687 
1688     tierLimit = _newTierLimit;
1689   }
1690 
1691   function addToWhitelist(
1692     address _investor,
1693     uint256 _tier
1694   )
1695     external
1696     onlyOperator
1697   {
1698     require(_tier == 1 || _tier == 2, "Only two tier level available");
1699     if (_whitelistTier[_investor] == 0) {
1700       whitelistAddresses.push(_investor);
1701     }
1702     _whitelistTier[_investor] = _tier;
1703   }
1704 
1705   function removeFromWhitelist(address _investor) external onlyOperator {
1706     _whitelistTier[_investor] = TIER_DELETED;
1707   }
1708 
1709   function whitelistTier(address _investor) external view returns (uint256) {
1710     return _whitelistTier[_investor] <= 2 ? _whitelistTier[_investor] : 0;
1711   }
1712 
1713   function getWhitelistedAddresses(
1714     uint256 _tier
1715   )
1716     external
1717     view
1718     returns (address[])
1719   {
1720     address[] memory tmp = new address[](whitelistAddresses.length);
1721 
1722     uint y = 0;
1723     if (_tier == 1 || _tier == 2) {
1724       uint len = whitelistAddresses.length;
1725       for (uint i = 0; i < len; i++) {
1726         if (_whitelistTier[whitelistAddresses[i]] == _tier) {
1727           tmp[y] = whitelistAddresses[i];
1728           y++;
1729         }
1730       }
1731     }
1732 
1733     address[] memory toReturn = new address[](y);
1734 
1735     for (uint k = 0; k < y; k++) {
1736       toReturn[k] = tmp[k];
1737     }
1738 
1739     return toReturn;
1740   }
1741 
1742   function isAllowedPurchase(
1743     address _beneficiary,
1744     uint256 _weiAmount
1745   )
1746     external
1747     view
1748     returns (bool)
1749   {
1750     if (_whitelistTier[_beneficiary] == 2) {
1751       return true;
1752     } else if (_whitelistTier[_beneficiary] == 1 && ethContributions[_beneficiary].add(_weiAmount) <= tierLimit) {
1753       return true;
1754     }
1755 
1756     return false;
1757   }
1758 
1759   function getTokenAddressesLength() external view returns (uint) {
1760     return tokenAddresses.length;
1761   }
1762 
1763   function getEthAddressesLength() external view returns (uint) {
1764     return ethAddresses.length;
1765   }
1766 }
1767 
1768 // File: contracts/crowdsale/base/DefaultCrowdsale.sol
1769 
1770 // solium-disable-next-line max-len
1771 
1772 
1773 
1774 
1775 contract DefaultCrowdsale is TimedCrowdsale, TokenRecover {
1776 
1777   Contributions public contributions;
1778 
1779   uint256 public minimumContribution;
1780 
1781   constructor(
1782     uint256 _openingTime,
1783     uint256 _closingTime,
1784     uint256 _rate,
1785     address _wallet,
1786     uint256 _minimumContribution,
1787     address _token,
1788     address _contributions
1789   )
1790     Crowdsale(_rate, _wallet, ERC20(_token))
1791     TimedCrowdsale(_openingTime, _closingTime)
1792     public
1793   {
1794     require(
1795       _contributions != address(0),
1796       "Contributions address can't be the zero address."
1797     );
1798     contributions = Contributions(_contributions);
1799     minimumContribution = _minimumContribution;
1800   }
1801 
1802   // Utility methods
1803 
1804   // false if the ico is not started, true if the ico is started and running, true if the ico is completed
1805   function started() public view returns(bool) {
1806     // solium-disable-next-line security/no-block-members
1807     return block.timestamp >= openingTime;
1808   }
1809 
1810   /**
1811    * @dev Extend parent behavior requiring purchase to respect the minimumContribution.
1812    * @param _beneficiary Token purchaser
1813    * @param _weiAmount Amount of wei contributed
1814    */
1815   function _preValidatePurchase(
1816     address _beneficiary,
1817     uint256 _weiAmount
1818   )
1819     internal
1820   {
1821     require(
1822       _weiAmount >= minimumContribution,
1823       "Can't send less than the minimum contribution"
1824     );
1825     require(
1826       contributions.isAllowedPurchase(_beneficiary, _weiAmount),
1827       "Beneficiary is not allowed to purchase this amount"
1828     );
1829     super._preValidatePurchase(_beneficiary, _weiAmount);
1830   }
1831 
1832 
1833   /**
1834    * @dev Extend parent behavior to update user contributions
1835    * @param _beneficiary Token purchaser
1836    * @param _weiAmount Amount of wei contributed
1837    */
1838   function _updatePurchasingState(
1839     address _beneficiary,
1840     uint256 _weiAmount
1841   )
1842     internal
1843   {
1844     super._updatePurchasingState(_beneficiary, _weiAmount);
1845     contributions.addEthContribution(_beneficiary, _weiAmount);
1846   }
1847 
1848   /**
1849    * @dev Extend parent behavior to add contributions log
1850    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
1851    * @param _beneficiary Address receiving the tokens
1852    * @param _tokenAmount Number of tokens to be purchased
1853    */
1854   function _processPurchase(
1855     address _beneficiary,
1856     uint256 _tokenAmount
1857   )
1858     internal
1859   {
1860     super._processPurchase(_beneficiary, _tokenAmount);
1861     contributions.addTokenBalance(_beneficiary, _tokenAmount);
1862   }
1863 }
1864 
1865 // File: contracts/crowdsale/FidelityHousePresale.sol
1866 
1867 // solium-disable-next-line max-len
1868 
1869 
1870 
1871 
1872 // solium-disable-next-line max-len
1873 contract FidelityHousePresale is DefaultCrowdsale, CappedCrowdsale, MintAndLockCrowdsale {
1874 
1875   constructor(
1876     uint256 _openingTime,
1877     uint256 _closingTime,
1878     uint256 _rate,
1879     uint256 _bonusRate,
1880     address _wallet,
1881     uint256 _cap,
1882     uint256 _minimumContribution,
1883     address _token,
1884     address _contributions
1885   )
1886     DefaultCrowdsale(
1887       _openingTime,
1888       _closingTime,
1889       _rate,
1890       _wallet,
1891       _minimumContribution,
1892       _token,
1893       _contributions
1894     )
1895     CappedCrowdsale(_cap)
1896     MintAndLockCrowdsale(_bonusRate)
1897     public
1898   {}
1899 
1900   // false if the ico is not started, false if the ico is started and running, true if the ico is completed
1901   function ended() public view returns(bool) {
1902     return hasClosed() || capReached();
1903   }
1904 
1905   /**
1906  * @dev Extend parent behavior to add contributions log
1907  * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
1908  * @param _beneficiary Address receiving the tokens
1909  * @param _tokenAmount Number of tokens to be purchased
1910  */
1911   function _processPurchase(
1912     address _beneficiary,
1913     uint256 _tokenAmount
1914   )
1915     internal
1916   {
1917     super._processPurchase(_beneficiary, _tokenAmount);
1918     if (bonusRate > 0) {
1919       contributions.addTokenBalance(_beneficiary, _getBonusAmount(_tokenAmount));
1920     }
1921   }
1922 }