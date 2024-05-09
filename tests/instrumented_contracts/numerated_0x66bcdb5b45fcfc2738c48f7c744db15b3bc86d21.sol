1 pragma solidity 0.4.24;
2 
3 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
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
17 // File: zeppelin-solidity/contracts/math/SafeMath.sol
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
69 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
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
115 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
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
136 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
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
257 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
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
321 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
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
378 // File: zeppelin-solidity/contracts/token/ERC20/CappedToken.sol
379 
380 /**
381  * @title Capped token
382  * @dev Mintable token with a token cap.
383  */
384 contract CappedToken is MintableToken {
385 
386   uint256 public cap;
387 
388   constructor(uint256 _cap) public {
389     require(_cap > 0);
390     cap = _cap;
391   }
392 
393   /**
394    * @dev Function to mint tokens
395    * @param _to The address that will receive the minted tokens.
396    * @param _amount The amount of tokens to mint.
397    * @return A boolean that indicates if the operation was successful.
398    */
399   function mint(
400     address _to,
401     uint256 _amount
402   )
403     public
404     returns (bool)
405   {
406     require(totalSupply_.add(_amount) <= cap);
407 
408     return super.mint(_to, _amount);
409   }
410 
411 }
412 
413 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
414 
415 /**
416  * @title Burnable Token
417  * @dev Token that can be irreversibly burned (destroyed).
418  */
419 contract BurnableToken is BasicToken {
420 
421   event Burn(address indexed burner, uint256 value);
422 
423   /**
424    * @dev Burns a specific amount of tokens.
425    * @param _value The amount of token to be burned.
426    */
427   function burn(uint256 _value) public {
428     _burn(msg.sender, _value);
429   }
430 
431   function _burn(address _who, uint256 _value) internal {
432     require(_value <= balances[_who]);
433     // no need to require value <= totalSupply, since that would imply the
434     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
435 
436     balances[_who] = balances[_who].sub(_value);
437     totalSupply_ = totalSupply_.sub(_value);
438     emit Burn(_who, _value);
439     emit Transfer(_who, address(0), _value);
440   }
441 }
442 
443 // File: zeppelin-solidity/contracts/access/rbac/Roles.sol
444 
445 /**
446  * @title Roles
447  * @author Francisco Giordano (@frangio)
448  * @dev Library for managing addresses assigned to a Role.
449  * See RBAC.sol for example usage.
450  */
451 library Roles {
452   struct Role {
453     mapping (address => bool) bearer;
454   }
455 
456   /**
457    * @dev give an address access to this role
458    */
459   function add(Role storage _role, address _addr)
460     internal
461   {
462     _role.bearer[_addr] = true;
463   }
464 
465   /**
466    * @dev remove an address' access to this role
467    */
468   function remove(Role storage _role, address _addr)
469     internal
470   {
471     _role.bearer[_addr] = false;
472   }
473 
474   /**
475    * @dev check if an address has this role
476    * // reverts
477    */
478   function check(Role storage _role, address _addr)
479     internal
480     view
481   {
482     require(has(_role, _addr));
483   }
484 
485   /**
486    * @dev check if an address has this role
487    * @return bool
488    */
489   function has(Role storage _role, address _addr)
490     internal
491     view
492     returns (bool)
493   {
494     return _role.bearer[_addr];
495   }
496 }
497 
498 // File: zeppelin-solidity/contracts/access/rbac/RBAC.sol
499 
500 /**
501  * @title RBAC (Role-Based Access Control)
502  * @author Matt Condon (@Shrugs)
503  * @dev Stores and provides setters and getters for roles and addresses.
504  * Supports unlimited numbers of roles and addresses.
505  * See //contracts/mocks/RBACMock.sol for an example of usage.
506  * This RBAC method uses strings to key roles. It may be beneficial
507  * for you to write your own implementation of this interface using Enums or similar.
508  */
509 contract RBAC {
510   using Roles for Roles.Role;
511 
512   mapping (string => Roles.Role) private roles;
513 
514   event RoleAdded(address indexed operator, string role);
515   event RoleRemoved(address indexed operator, string role);
516 
517   /**
518    * @dev reverts if addr does not have role
519    * @param _operator address
520    * @param _role the name of the role
521    * // reverts
522    */
523   function checkRole(address _operator, string _role)
524     public
525     view
526   {
527     roles[_role].check(_operator);
528   }
529 
530   /**
531    * @dev determine if addr has role
532    * @param _operator address
533    * @param _role the name of the role
534    * @return bool
535    */
536   function hasRole(address _operator, string _role)
537     public
538     view
539     returns (bool)
540   {
541     return roles[_role].has(_operator);
542   }
543 
544   /**
545    * @dev add a role to an address
546    * @param _operator address
547    * @param _role the name of the role
548    */
549   function addRole(address _operator, string _role)
550     internal
551   {
552     roles[_role].add(_operator);
553     emit RoleAdded(_operator, _role);
554   }
555 
556   /**
557    * @dev remove a role from an address
558    * @param _operator address
559    * @param _role the name of the role
560    */
561   function removeRole(address _operator, string _role)
562     internal
563   {
564     roles[_role].remove(_operator);
565     emit RoleRemoved(_operator, _role);
566   }
567 
568   /**
569    * @dev modifier to scope access to a single role (uses msg.sender as addr)
570    * @param _role the name of the role
571    * // reverts
572    */
573   modifier onlyRole(string _role)
574   {
575     checkRole(msg.sender, _role);
576     _;
577   }
578 
579   /**
580    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
581    * @param _roles the names of the roles to scope access to
582    * // reverts
583    *
584    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
585    *  see: https://github.com/ethereum/solidity/issues/2467
586    */
587   // modifier onlyRoles(string[] _roles) {
588   //     bool hasAnyRole = false;
589   //     for (uint8 i = 0; i < _roles.length; i++) {
590   //         if (hasRole(msg.sender, _roles[i])) {
591   //             hasAnyRole = true;
592   //             break;
593   //         }
594   //     }
595 
596   //     require(hasAnyRole);
597 
598   //     _;
599   // }
600 }
601 
602 // File: contracts/RBACBurnableToken.sol
603 
604 /**
605  * @title RBACBurnableToken
606  * @dev Burnable Token, with RBAC burner permissions
607  */
608 contract RBACBurnableToken is BurnableToken, Ownable, RBAC {
609   /**
610    * A constant role name for indicating burners.
611    */
612   string public constant ROLE_BURNER = "burner";
613 
614   /**
615    * @dev override the Burnable token _burn function
616    */
617   function _burn(address _who, uint256 _value) internal {
618     checkRole(msg.sender, ROLE_BURNER);
619     super._burn(_who, _value);    
620   }
621 
622   /**
623    * @dev add a burner role to an address
624    * @param _burner address
625    */
626   function addBurner(address _burner) public onlyOwner {
627     addRole(_burner, ROLE_BURNER);
628   }
629 
630   /**
631    * @dev remove a burner role from an address
632    * @param _burner address
633    */
634   function removeBurner(address _burner) public onlyOwner {
635     removeRole(_burner, ROLE_BURNER);
636   }
637 }
638 
639 // File: contracts/ABCToken.sol
640 
641 contract ABCToken is MintableToken, CappedToken, RBACBurnableToken {
642     string public name = "ABC Token";
643     string public symbol = "ABC";
644     uint8 public decimals = 18;
645     function ABCToken
646         (
647             uint256 _cap
648         )
649         public 
650         CappedToken(_cap) {
651 
652         }
653 }
654 
655 // File: zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
656 
657 /**
658  * @title SafeERC20
659  * @dev Wrappers around ERC20 operations that throw on failure.
660  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
661  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
662  */
663 library SafeERC20 {
664   function safeTransfer(
665     ERC20Basic _token,
666     address _to,
667     uint256 _value
668   )
669     internal
670   {
671     require(_token.transfer(_to, _value));
672   }
673 
674   function safeTransferFrom(
675     ERC20 _token,
676     address _from,
677     address _to,
678     uint256 _value
679   )
680     internal
681   {
682     require(_token.transferFrom(_from, _to, _value));
683   }
684 
685   function safeApprove(
686     ERC20 _token,
687     address _spender,
688     uint256 _value
689   )
690     internal
691   {
692     require(_token.approve(_spender, _value));
693   }
694 }
695 
696 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
697 
698 /**
699  * @title Crowdsale
700  * @dev Crowdsale is a base contract for managing a token crowdsale,
701  * allowing investors to purchase tokens with ether. This contract implements
702  * such functionality in its most fundamental form and can be extended to provide additional
703  * functionality and/or custom behavior.
704  * The external interface represents the basic interface for purchasing tokens, and conform
705  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
706  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
707  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
708  * behavior.
709  */
710 contract Crowdsale {
711   using SafeMath for uint256;
712   using SafeERC20 for ERC20;
713 
714   // The token being sold
715   ERC20 public token;
716 
717   // Address where funds are collected
718   address public wallet;
719 
720   // How many token units a buyer gets per wei.
721   // The rate is the conversion between wei and the smallest and indivisible token unit.
722   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
723   // 1 wei will give you 1 unit, or 0.001 TOK.
724   uint256 public rate;
725 
726   // Amount of wei raised
727   uint256 public weiRaised;
728 
729   /**
730    * Event for token purchase logging
731    * @param purchaser who paid for the tokens
732    * @param beneficiary who got the tokens
733    * @param value weis paid for purchase
734    * @param amount amount of tokens purchased
735    */
736   event TokenPurchase(
737     address indexed purchaser,
738     address indexed beneficiary,
739     uint256 value,
740     uint256 amount
741   );
742 
743   /**
744    * @param _rate Number of token units a buyer gets per wei
745    * @param _wallet Address where collected funds will be forwarded to
746    * @param _token Address of the token being sold
747    */
748   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
749     require(_rate > 0);
750     require(_wallet != address(0));
751     require(_token != address(0));
752 
753     rate = _rate;
754     wallet = _wallet;
755     token = _token;
756   }
757 
758   // -----------------------------------------
759   // Crowdsale external interface
760   // -----------------------------------------
761 
762   /**
763    * @dev fallback function ***DO NOT OVERRIDE***
764    */
765   function () external payable {
766     buyTokens(msg.sender);
767   }
768 
769   /**
770    * @dev low level token purchase ***DO NOT OVERRIDE***
771    * @param _beneficiary Address performing the token purchase
772    */
773   function buyTokens(address _beneficiary) public payable {
774 
775     uint256 weiAmount = msg.value;
776     _preValidatePurchase(_beneficiary, weiAmount);
777 
778     // calculate token amount to be created
779     uint256 tokens = _getTokenAmount(weiAmount);
780 
781     // update state
782     weiRaised = weiRaised.add(weiAmount);
783 
784     _processPurchase(_beneficiary, tokens);
785     emit TokenPurchase(
786       msg.sender,
787       _beneficiary,
788       weiAmount,
789       tokens
790     );
791 
792     _updatePurchasingState(_beneficiary, weiAmount);
793 
794     _forwardFunds();
795     _postValidatePurchase(_beneficiary, weiAmount);
796   }
797 
798   // -----------------------------------------
799   // Internal interface (extensible)
800   // -----------------------------------------
801 
802   /**
803    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
804    * Example from CappedCrowdsale.sol's _preValidatePurchase method: 
805    *   super._preValidatePurchase(_beneficiary, _weiAmount);
806    *   require(weiRaised.add(_weiAmount) <= cap);
807    * @param _beneficiary Address performing the token purchase
808    * @param _weiAmount Value in wei involved in the purchase
809    */
810   function _preValidatePurchase(
811     address _beneficiary,
812     uint256 _weiAmount
813   )
814     internal
815   {
816     require(_beneficiary != address(0));
817     require(_weiAmount != 0);
818   }
819 
820   /**
821    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
822    * @param _beneficiary Address performing the token purchase
823    * @param _weiAmount Value in wei involved in the purchase
824    */
825   function _postValidatePurchase(
826     address _beneficiary,
827     uint256 _weiAmount
828   )
829     internal
830   {
831     // optional override
832   }
833 
834   /**
835    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
836    * @param _beneficiary Address performing the token purchase
837    * @param _tokenAmount Number of tokens to be emitted
838    */
839   function _deliverTokens(
840     address _beneficiary,
841     uint256 _tokenAmount
842   )
843     internal
844   {
845     token.safeTransfer(_beneficiary, _tokenAmount);
846   }
847 
848   /**
849    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
850    * @param _beneficiary Address receiving the tokens
851    * @param _tokenAmount Number of tokens to be purchased
852    */
853   function _processPurchase(
854     address _beneficiary,
855     uint256 _tokenAmount
856   )
857     internal
858   {
859     _deliverTokens(_beneficiary, _tokenAmount);
860   }
861 
862   /**
863    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
864    * @param _beneficiary Address receiving the tokens
865    * @param _weiAmount Value in wei involved in the purchase
866    */
867   function _updatePurchasingState(
868     address _beneficiary,
869     uint256 _weiAmount
870   )
871     internal
872   {
873     // optional override
874   }
875 
876   /**
877    * @dev Override to extend the way in which ether is converted to tokens.
878    * @param _weiAmount Value in wei to be converted into tokens
879    * @return Number of tokens that can be purchased with the specified _weiAmount
880    */
881   function _getTokenAmount(uint256 _weiAmount)
882     internal view returns (uint256)
883   {
884     return _weiAmount.mul(rate);
885   }
886 
887   /**
888    * @dev Determines how ETH is stored/forwarded on purchases.
889    */
890   function _forwardFunds() internal {
891     wallet.transfer(msg.value);
892   }
893 }
894 
895 // File: zeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol
896 
897 /**
898  * @title MintedCrowdsale
899  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
900  * Token ownership should be transferred to MintedCrowdsale for minting.
901  */
902 contract MintedCrowdsale is Crowdsale {
903 
904   /**
905    * @dev Overrides delivery by minting tokens upon purchase.
906    * @param _beneficiary Token purchaser
907    * @param _tokenAmount Number of tokens to be minted
908    */
909   function _deliverTokens(
910     address _beneficiary,
911     uint256 _tokenAmount
912   )
913     internal
914   {
915     // Potentially dangerous assumption about the type of the token.
916     require(MintableToken(address(token)).mint(_beneficiary, _tokenAmount));
917   }
918 }
919 
920 // File: zeppelin-solidity/contracts/access/Whitelist.sol
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
1007 // File: zeppelin-solidity/contracts/crowdsale/validation/WhitelistedCrowdsale.sol
1008 
1009 /**
1010  * @title WhitelistedCrowdsale
1011  * @dev Crowdsale in which only whitelisted users can contribute.
1012  */
1013 contract WhitelistedCrowdsale is Whitelist, Crowdsale {
1014   /**
1015    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
1016    * @param _beneficiary Token beneficiary
1017    * @param _weiAmount Amount of wei contributed
1018    */
1019   function _preValidatePurchase(
1020     address _beneficiary,
1021     uint256 _weiAmount
1022   )
1023     internal
1024     onlyIfWhitelisted(_beneficiary)
1025   {
1026     super._preValidatePurchase(_beneficiary, _weiAmount);
1027   }
1028 
1029 }
1030 
1031 // File: zeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
1032 
1033 /**
1034  * @title TimedCrowdsale
1035  * @dev Crowdsale accepting contributions only within a time frame.
1036  */
1037 contract TimedCrowdsale is Crowdsale {
1038   using SafeMath for uint256;
1039 
1040   uint256 public openingTime;
1041   uint256 public closingTime;
1042 
1043   /**
1044    * @dev Reverts if not in crowdsale time range.
1045    */
1046   modifier onlyWhileOpen {
1047     // solium-disable-next-line security/no-block-members
1048     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
1049     _;
1050   }
1051 
1052   /**
1053    * @dev Constructor, takes crowdsale opening and closing times.
1054    * @param _openingTime Crowdsale opening time
1055    * @param _closingTime Crowdsale closing time
1056    */
1057   constructor(uint256 _openingTime, uint256 _closingTime) public {
1058     // solium-disable-next-line security/no-block-members
1059     require(_openingTime >= block.timestamp);
1060     require(_closingTime >= _openingTime);
1061 
1062     openingTime = _openingTime;
1063     closingTime = _closingTime;
1064   }
1065 
1066   /**
1067    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
1068    * @return Whether crowdsale period has elapsed
1069    */
1070   function hasClosed() public view returns (bool) {
1071     // solium-disable-next-line security/no-block-members
1072     return block.timestamp > closingTime;
1073   }
1074 
1075   /**
1076    * @dev Extend parent behavior requiring to be within contributing period
1077    * @param _beneficiary Token purchaser
1078    * @param _weiAmount Amount of wei contributed
1079    */
1080   function _preValidatePurchase(
1081     address _beneficiary,
1082     uint256 _weiAmount
1083   )
1084     internal
1085     onlyWhileOpen
1086   {
1087     super._preValidatePurchase(_beneficiary, _weiAmount);
1088   }
1089 
1090 }
1091 
1092 // File: zeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol
1093 
1094 /**
1095  * @title FinalizableCrowdsale
1096  * @dev Extension of Crowdsale where an owner can do extra work
1097  * after finishing.
1098  */
1099 contract FinalizableCrowdsale is Ownable, TimedCrowdsale {
1100   using SafeMath for uint256;
1101 
1102   bool public isFinalized = false;
1103 
1104   event Finalized();
1105 
1106   /**
1107    * @dev Must be called after crowdsale ends, to do some extra finalization
1108    * work. Calls the contract's finalization function.
1109    */
1110   function finalize() public onlyOwner {
1111     require(!isFinalized);
1112     require(hasClosed());
1113 
1114     finalization();
1115     emit Finalized();
1116 
1117     isFinalized = true;
1118   }
1119 
1120   /**
1121    * @dev Can be overridden to add finalization logic. The overriding function
1122    * should call super.finalization() to ensure the chain of finalization is
1123    * executed entirely.
1124    */
1125   function finalization() internal {
1126   }
1127 
1128 }
1129 
1130 // File: zeppelin-solidity/contracts/payment/Escrow.sol
1131 
1132 /**
1133  * @title Escrow
1134  * @dev Base escrow contract, holds funds destinated to a payee until they
1135  * withdraw them. The contract that uses the escrow as its payment method
1136  * should be its owner, and provide public methods redirecting to the escrow's
1137  * deposit and withdraw.
1138  */
1139 contract Escrow is Ownable {
1140   using SafeMath for uint256;
1141 
1142   event Deposited(address indexed payee, uint256 weiAmount);
1143   event Withdrawn(address indexed payee, uint256 weiAmount);
1144 
1145   mapping(address => uint256) private deposits;
1146 
1147   function depositsOf(address _payee) public view returns (uint256) {
1148     return deposits[_payee];
1149   }
1150 
1151   /**
1152   * @dev Stores the sent amount as credit to be withdrawn.
1153   * @param _payee The destination address of the funds.
1154   */
1155   function deposit(address _payee) public onlyOwner payable {
1156     uint256 amount = msg.value;
1157     deposits[_payee] = deposits[_payee].add(amount);
1158 
1159     emit Deposited(_payee, amount);
1160   }
1161 
1162   /**
1163   * @dev Withdraw accumulated balance for a payee.
1164   * @param _payee The address whose funds will be withdrawn and transferred to.
1165   */
1166   function withdraw(address _payee) public onlyOwner {
1167     uint256 payment = deposits[_payee];
1168     assert(address(this).balance >= payment);
1169 
1170     deposits[_payee] = 0;
1171 
1172     _payee.transfer(payment);
1173 
1174     emit Withdrawn(_payee, payment);
1175   }
1176 }
1177 
1178 // File: zeppelin-solidity/contracts/payment/ConditionalEscrow.sol
1179 
1180 /**
1181  * @title ConditionalEscrow
1182  * @dev Base abstract escrow to only allow withdrawal if a condition is met.
1183  */
1184 contract ConditionalEscrow is Escrow {
1185   /**
1186   * @dev Returns whether an address is allowed to withdraw their funds. To be
1187   * implemented by derived contracts.
1188   * @param _payee The destination address of the funds.
1189   */
1190   function withdrawalAllowed(address _payee) public view returns (bool);
1191 
1192   function withdraw(address _payee) public {
1193     require(withdrawalAllowed(_payee));
1194     super.withdraw(_payee);
1195   }
1196 }
1197 
1198 // File: zeppelin-solidity/contracts/payment/RefundEscrow.sol
1199 
1200 /**
1201  * @title RefundEscrow
1202  * @dev Escrow that holds funds for a beneficiary, deposited from multiple parties.
1203  * The contract owner may close the deposit period, and allow for either withdrawal
1204  * by the beneficiary, or refunds to the depositors.
1205  */
1206 contract RefundEscrow is Ownable, ConditionalEscrow {
1207   enum State { Active, Refunding, Closed }
1208 
1209   event Closed();
1210   event RefundsEnabled();
1211 
1212   State public state;
1213   address public beneficiary;
1214 
1215   /**
1216    * @dev Constructor.
1217    * @param _beneficiary The beneficiary of the deposits.
1218    */
1219   constructor(address _beneficiary) public {
1220     require(_beneficiary != address(0));
1221     beneficiary = _beneficiary;
1222     state = State.Active;
1223   }
1224 
1225   /**
1226    * @dev Stores funds that may later be refunded.
1227    * @param _refundee The address funds will be sent to if a refund occurs.
1228    */
1229   function deposit(address _refundee) public payable {
1230     require(state == State.Active);
1231     super.deposit(_refundee);
1232   }
1233 
1234   /**
1235    * @dev Allows for the beneficiary to withdraw their funds, rejecting
1236    * further deposits.
1237    */
1238   function close() public onlyOwner {
1239     require(state == State.Active);
1240     state = State.Closed;
1241     emit Closed();
1242   }
1243 
1244   /**
1245    * @dev Allows for refunds to take place, rejecting further deposits.
1246    */
1247   function enableRefunds() public onlyOwner {
1248     require(state == State.Active);
1249     state = State.Refunding;
1250     emit RefundsEnabled();
1251   }
1252 
1253   /**
1254    * @dev Withdraws the beneficiary's funds.
1255    */
1256   function beneficiaryWithdraw() public {
1257     require(state == State.Closed);
1258     beneficiary.transfer(address(this).balance);
1259   }
1260 
1261   /**
1262    * @dev Returns whether refundees can withdraw their deposits (be refunded).
1263    */
1264   function withdrawalAllowed(address _payee) public view returns (bool) {
1265     return state == State.Refunding;
1266   }
1267 }
1268 
1269 // File: zeppelin-solidity/contracts/crowdsale/distribution/RefundableCrowdsale.sol
1270 
1271 /**
1272  * @title RefundableCrowdsale
1273  * @dev Extension of Crowdsale contract that adds a funding goal, and
1274  * the possibility of users getting a refund if goal is not met.
1275  */
1276 contract RefundableCrowdsale is FinalizableCrowdsale {
1277   using SafeMath for uint256;
1278 
1279   // minimum amount of funds to be raised in weis
1280   uint256 public goal;
1281 
1282   // refund escrow used to hold funds while crowdsale is running
1283   RefundEscrow private escrow;
1284 
1285   /**
1286    * @dev Constructor, creates RefundEscrow.
1287    * @param _goal Funding goal
1288    */
1289   constructor(uint256 _goal) public {
1290     require(_goal > 0);
1291     escrow = new RefundEscrow(wallet);
1292     goal = _goal;
1293   }
1294 
1295   /**
1296    * @dev Investors can claim refunds here if crowdsale is unsuccessful
1297    */
1298   function claimRefund() public {
1299     require(isFinalized);
1300     require(!goalReached());
1301 
1302     escrow.withdraw(msg.sender);
1303   }
1304 
1305   /**
1306    * @dev Checks whether funding goal was reached.
1307    * @return Whether funding goal was reached
1308    */
1309   function goalReached() public view returns (bool) {
1310     return weiRaised >= goal;
1311   }
1312 
1313   /**
1314    * @dev escrow finalization task, called when owner calls finalize()
1315    */
1316   function finalization() internal {
1317     if (goalReached()) {
1318       escrow.close();
1319       escrow.beneficiaryWithdraw();
1320     } else {
1321       escrow.enableRefunds();
1322     }
1323 
1324     super.finalization();
1325   }
1326 
1327   /**
1328    * @dev Overrides Crowdsale fund forwarding, sending funds to escrow.
1329    */
1330   function _forwardFunds() internal {
1331     escrow.deposit.value(msg.value)(msg.sender);
1332   }
1333 
1334 }
1335 
1336 // File: zeppelin-solidity/contracts/token/ERC20/TokenTimelock.sol
1337 
1338 /**
1339  * @title TokenTimelock
1340  * @dev TokenTimelock is a token holder contract that will allow a
1341  * beneficiary to extract the tokens after a given release time
1342  */
1343 contract TokenTimelock {
1344   using SafeERC20 for ERC20Basic;
1345 
1346   // ERC20 basic token contract being held
1347   ERC20Basic public token;
1348 
1349   // beneficiary of tokens after they are released
1350   address public beneficiary;
1351 
1352   // timestamp when token release is enabled
1353   uint256 public releaseTime;
1354 
1355   constructor(
1356     ERC20Basic _token,
1357     address _beneficiary,
1358     uint256 _releaseTime
1359   )
1360     public
1361   {
1362     // solium-disable-next-line security/no-block-members
1363     require(_releaseTime > block.timestamp);
1364     token = _token;
1365     beneficiary = _beneficiary;
1366     releaseTime = _releaseTime;
1367   }
1368 
1369   /**
1370    * @notice Transfers tokens held by timelock to beneficiary.
1371    */
1372   function release() public {
1373     // solium-disable-next-line security/no-block-members
1374     require(block.timestamp >= releaseTime);
1375 
1376     uint256 amount = token.balanceOf(address(this));
1377     require(amount > 0);
1378 
1379     token.safeTransfer(beneficiary, amount);
1380   }
1381 }
1382 
1383 // File: contracts/ABCTokenCrowdsale.sol
1384 
1385 contract ABCTokenCrowdsale is WhitelistedCrowdsale, RefundableCrowdsale, MintedCrowdsale {
1386     
1387     // ICO Stages
1388     enum CrowdsaleStage { PrivateSale, PreSale, ICO }
1389     CrowdsaleStage public stage = CrowdsaleStage.PrivateSale; 
1390 
1391     uint256 public privateSaleRate;
1392     uint256 public preSaleRate;
1393     uint256 public publicRate;
1394     uint256 public totalTokensForSaleDuringPrivateSale;
1395     uint256 public totalTokensForSaleDuringPreSale;
1396     uint256 public totalTokensForSale;
1397     uint256 public privateSaleMinimumTokens;
1398     uint256 public preSaleMinimumTokens;
1399     uint256 public tokensForTeam;
1400     uint256 public tokensForAdvisors;
1401 
1402     uint256 public privateSaleTokensSold = 0;
1403     uint256 public preSaleTokensSold = 0;
1404     uint256 public tokensSold = 0;
1405 
1406 
1407     // Team, Advisor, Strategic partner Timelocks
1408     address public teamWallet;
1409     address public advisorsWallet;
1410 
1411 	address public teamTimelock1;
1412 	address public teamTimelock2;
1413 	address public teamTimelock3;
1414 	address public teamTimelock4;
1415 	address public teamTimelock5;
1416 	address public teamTimelock6;
1417 	address public teamTimelock7;
1418 	address public advisorTimelock;
1419     
1420 	function ABCTokenCrowdsale
1421         (
1422         	uint256 _goal,
1423             uint256 _openingTime,
1424             uint256 _closingTime,
1425             uint256 _privateSaleRate,
1426             uint256 _preSaleRate,
1427             uint256 _rate,
1428             uint256 _totalTokensForSaleDuringPrivateSale,
1429             uint256 _totalTokensForSaleDuringPreSale,
1430             uint256 _totalTokensForSale,
1431             uint256 _privateSaleMinimumTokens,
1432             uint256 _preSaleMinimumTokens,
1433             uint256 _tokensForTeam,
1434             uint256 _tokensForAdvisors,
1435             address _wallet,
1436             MintableToken _token
1437         )
1438         public
1439         Crowdsale(_rate, _wallet, _token)
1440         TimedCrowdsale(_openingTime, _closingTime)
1441         RefundableCrowdsale(_goal) {
1442         
1443         	uint256 tokenCap = CappedToken(address(_token)).cap();
1444 			require(_totalTokensForSale.add(_tokensForTeam).add(_tokensForAdvisors) <= tokenCap);			
1445 			
1446             publicRate = _rate;
1447             preSaleRate = _preSaleRate;
1448             privateSaleRate = _privateSaleRate;           
1449 
1450 			totalTokensForSaleDuringPrivateSale = _totalTokensForSaleDuringPrivateSale;
1451             totalTokensForSaleDuringPreSale = _totalTokensForSaleDuringPreSale;
1452             totalTokensForSale = _totalTokensForSale;
1453 
1454 			preSaleMinimumTokens = _preSaleMinimumTokens;
1455     		privateSaleMinimumTokens = _privateSaleMinimumTokens;
1456 
1457 			tokensForTeam = _tokensForTeam;
1458     		tokensForAdvisors = _tokensForAdvisors;
1459 
1460             setCrowdsaleStage(uint(CrowdsaleStage.PrivateSale));
1461     }
1462     
1463     function setCrowdsaleStage(uint value) public onlyOwner {
1464     
1465         CrowdsaleStage _stage;
1466         
1467         if (uint(CrowdsaleStage.PrivateSale) == value) {
1468             _stage = CrowdsaleStage.PrivateSale;
1469         } else if (uint(CrowdsaleStage.PreSale) == value) {
1470             _stage = CrowdsaleStage.PreSale;
1471         } else if (uint(CrowdsaleStage.ICO) == value) {
1472             _stage = CrowdsaleStage.ICO;
1473         }
1474         
1475         stage = _stage;
1476         
1477         
1478         if (stage == CrowdsaleStage.PrivateSale) {
1479             setCurrentRate(privateSaleRate);
1480         } else if (stage == CrowdsaleStage.PreSale) {
1481             setCurrentRate(preSaleRate);
1482         } else if (stage == CrowdsaleStage.ICO) {
1483             setCurrentRate(publicRate);
1484         }
1485     }
1486     
1487     function setTeamWallet(address _wallet) public onlyOwner {
1488 		teamWallet = _wallet;
1489 	}    
1490     function setAdvisorWallet(address _wallet) public onlyOwner {
1491 		advisorsWallet = _wallet;
1492 	}    
1493 
1494     function setCurrentRate(uint256 _rate) private {
1495         rate = _rate;
1496     }
1497     
1498     function _preValidatePurchase(
1499         address _beneficiary,
1500         uint256 _weiAmount
1501     )
1502     internal
1503     {
1504         super._preValidatePurchase(_beneficiary, _weiAmount);
1505 
1506         uint256 tokens = _getTokenAmount(_weiAmount);
1507         if (stage == CrowdsaleStage.PrivateSale) {
1508             require(tokens >= privateSaleMinimumTokens);
1509             require(privateSaleTokensSold.add(tokens) <= totalTokensForSaleDuringPrivateSale);
1510         } else if (stage == CrowdsaleStage.PreSale) {
1511             require(tokens >= preSaleMinimumTokens);
1512             require(preSaleTokensSold.add(tokens) <= totalTokensForSaleDuringPreSale);
1513         }
1514         require(tokensSold.add(tokens) <= totalTokensForSale);
1515     }    
1516 
1517     function _postValidatePurchase(
1518         address _beneficiary,
1519         uint256 _weiAmount
1520     )
1521     internal
1522     {
1523         super._postValidatePurchase(_beneficiary, _weiAmount);
1524 
1525         uint256 tokens = _getTokenAmount(_weiAmount);
1526         if (stage == CrowdsaleStage.PrivateSale) {
1527             privateSaleTokensSold = privateSaleTokensSold.add(tokens);
1528         } else if (stage == CrowdsaleStage.PreSale) {
1529             preSaleTokensSold = preSaleTokensSold.add(tokens);
1530         }
1531         tokensSold = tokensSold.add(tokens);
1532     }    
1533 
1534 	function finalization() 
1535 	internal 
1536 	{
1537     	if(goalReached()) {        
1538 			require(teamWallet != address(0));
1539 			require(advisorsWallet != address(0));
1540 
1541 	        // mint team tokens
1542     	    uint256 teamReleaseTime1 = now + (182.5 * 24 * 60 * 60); // 182.5 days from now
1543         	teamTimelock1 = mintTimeLockedTokens(teamWallet, (tokensForTeam * 25 / 100 ), teamReleaseTime1);
1544         
1545 	        uint256 teamReleaseTime2 = teamReleaseTime1 + (91.25 * 24 * 60 * 60); // 91.25 days from last release
1546     	    teamTimelock2 = mintTimeLockedTokens(teamWallet, (tokensForTeam * 125 / 1000), teamReleaseTime2);
1547         
1548         	uint256 teamReleaseTime3 = teamReleaseTime2 + (91.25 * 24 * 60 * 60); // 91.25 days from last release
1549 	        teamTimelock3 = mintTimeLockedTokens(teamWallet, (tokensForTeam * 125 / 1000), teamReleaseTime3);
1550         
1551         	uint256 teamReleaseTime4 = teamReleaseTime3 + (91.25 * 24 * 60 * 60); // 91.25 days from last release
1552         	teamTimelock4 = mintTimeLockedTokens(teamWallet, (tokensForTeam * 125 / 1000), teamReleaseTime4);
1553         
1554 	        uint256 teamReleaseTime5 = teamReleaseTime4 + (91.25 * 24 * 60 * 60); // 91.25 days from last release
1555     	    teamTimelock5 = mintTimeLockedTokens(teamWallet, (tokensForTeam * 125 / 1000), teamReleaseTime5);
1556         
1557 	        uint256 teamReleaseTime6 = teamReleaseTime5 + (91.25 * 24 * 60 * 60); // 91.25 days from last release
1558     	    teamTimelock6 = mintTimeLockedTokens(teamWallet, (tokensForTeam * 125 / 1000), teamReleaseTime6);
1559         
1560 	        uint256 teamReleaseTime7 = teamReleaseTime6 + (91.25 * 24 * 60 * 60); // 91.25 days from last release
1561     	    teamTimelock7 = mintTimeLockedTokens(teamWallet, (tokensForTeam * 125 / 1000), teamReleaseTime7);
1562 
1563 	        // mint advisor tokens in 3 months
1564 	        uint256 advisorReleaseTime = now + (91.25 * 24 * 60 * 60); // 91.25 days from now
1565     	    advisorTimelock = mintTimeLockedTokens(advisorsWallet, tokensForAdvisors, advisorReleaseTime);
1566         
1567 			MintableToken _mintableToken = MintableToken(token);
1568 			_mintableToken.finishMinting();
1569 		
1570 	      	_mintableToken.transferOwnership(wallet);
1571     	}
1572 	    super.finalization();    	          
1573     }    
1574 
1575     function mintTimeLockedTokens(address _to, uint256 _amount, uint256 _releaseTime) private returns (TokenTimelock) {
1576         TokenTimelock timelock = new TokenTimelock(token, _to, _releaseTime);
1577         MintableToken(address(token)).mint(timelock, _amount);
1578         return timelock;
1579     }        
1580 }