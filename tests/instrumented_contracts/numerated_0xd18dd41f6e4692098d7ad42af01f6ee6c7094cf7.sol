1 pragma solidity 0.4.24;
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
17 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address _owner, address _spender)
25     public view returns (uint256);
26 
27   function transferFrom(address _from, address _to, uint256 _value)
28     public returns (bool);
29 
30   function approve(address _spender, uint256 _value) public returns (bool);
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that throw on error
43  */
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, throws on overflow.
48   */
49   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
50     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
51     // benefit is lost if 'b' is also tested.
52     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53     if (_a == 0) {
54       return 0;
55     }
56 
57     c = _a * _b;
58     assert(c / _a == _b);
59     return c;
60   }
61 
62   /**
63   * @dev Integer division of two numbers, truncating the quotient.
64   */
65   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
66     // assert(_b > 0); // Solidity automatically throws when dividing by 0
67     // uint256 c = _a / _b;
68     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
69     return _a / _b;
70   }
71 
72   /**
73   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
74   */
75   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
76     assert(_b <= _a);
77     return _a - _b;
78   }
79 
80   /**
81   * @dev Adds two numbers, throws on overflow.
82   */
83   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
84     c = _a + _b;
85     assert(c >= _a);
86     return c;
87   }
88 }
89 
90 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
91 
92 /**
93  * @title Basic token
94  * @dev Basic version of StandardToken, with no allowances.
95  */
96 contract BasicToken is ERC20Basic {
97   using SafeMath for uint256;
98 
99   mapping(address => uint256) internal balances;
100 
101   uint256 internal totalSupply_;
102 
103   /**
104   * @dev Total number of tokens in existence
105   */
106   function totalSupply() public view returns (uint256) {
107     return totalSupply_;
108   }
109 
110   /**
111   * @dev Transfer token for a specified address
112   * @param _to The address to transfer to.
113   * @param _value The amount to be transferred.
114   */
115   function transfer(address _to, uint256 _value) public returns (bool) {
116     require(_value <= balances[msg.sender]);
117     require(_to != address(0));
118 
119     balances[msg.sender] = balances[msg.sender].sub(_value);
120     balances[_to] = balances[_to].add(_value);
121     emit Transfer(msg.sender, _to, _value);
122     return true;
123   }
124 
125   /**
126   * @dev Gets the balance of the specified address.
127   * @param _owner The address to query the the balance of.
128   * @return An uint256 representing the amount owned by the passed address.
129   */
130   function balanceOf(address _owner) public view returns (uint256) {
131     return balances[_owner];
132   }
133 
134 }
135 
136 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
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
257 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
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
321 // File: openzeppelin-solidity/contracts/access/rbac/Roles.sol
322 
323 /**
324  * @title Roles
325  * @author Francisco Giordano (@frangio)
326  * @dev Library for managing addresses assigned to a Role.
327  * See RBAC.sol for example usage.
328  */
329 library Roles {
330   struct Role {
331     mapping (address => bool) bearer;
332   }
333 
334   /**
335    * @dev give an address access to this role
336    */
337   function add(Role storage _role, address _addr)
338     internal
339   {
340     _role.bearer[_addr] = true;
341   }
342 
343   /**
344    * @dev remove an address' access to this role
345    */
346   function remove(Role storage _role, address _addr)
347     internal
348   {
349     _role.bearer[_addr] = false;
350   }
351 
352   /**
353    * @dev check if an address has this role
354    * // reverts
355    */
356   function check(Role storage _role, address _addr)
357     internal
358     view
359   {
360     require(has(_role, _addr));
361   }
362 
363   /**
364    * @dev check if an address has this role
365    * @return bool
366    */
367   function has(Role storage _role, address _addr)
368     internal
369     view
370     returns (bool)
371   {
372     return _role.bearer[_addr];
373   }
374 }
375 
376 // File: openzeppelin-solidity/contracts/access/rbac/RBAC.sol
377 
378 /**
379  * @title RBAC (Role-Based Access Control)
380  * @author Matt Condon (@Shrugs)
381  * @dev Stores and provides setters and getters for roles and addresses.
382  * Supports unlimited numbers of roles and addresses.
383  * See //contracts/mocks/RBACMock.sol for an example of usage.
384  * This RBAC method uses strings to key roles. It may be beneficial
385  * for you to write your own implementation of this interface using Enums or similar.
386  */
387 contract RBAC {
388   using Roles for Roles.Role;
389 
390   mapping (string => Roles.Role) private roles;
391 
392   event RoleAdded(address indexed operator, string role);
393   event RoleRemoved(address indexed operator, string role);
394 
395   /**
396    * @dev reverts if addr does not have role
397    * @param _operator address
398    * @param _role the name of the role
399    * // reverts
400    */
401   function checkRole(address _operator, string _role)
402     public
403     view
404   {
405     roles[_role].check(_operator);
406   }
407 
408   /**
409    * @dev determine if addr has role
410    * @param _operator address
411    * @param _role the name of the role
412    * @return bool
413    */
414   function hasRole(address _operator, string _role)
415     public
416     view
417     returns (bool)
418   {
419     return roles[_role].has(_operator);
420   }
421 
422   /**
423    * @dev add a role to an address
424    * @param _operator address
425    * @param _role the name of the role
426    */
427   function addRole(address _operator, string _role)
428     internal
429   {
430     roles[_role].add(_operator);
431     emit RoleAdded(_operator, _role);
432   }
433 
434   /**
435    * @dev remove a role from an address
436    * @param _operator address
437    * @param _role the name of the role
438    */
439   function removeRole(address _operator, string _role)
440     internal
441   {
442     roles[_role].remove(_operator);
443     emit RoleRemoved(_operator, _role);
444   }
445 
446   /**
447    * @dev modifier to scope access to a single role (uses msg.sender as addr)
448    * @param _role the name of the role
449    * // reverts
450    */
451   modifier onlyRole(string _role)
452   {
453     checkRole(msg.sender, _role);
454     _;
455   }
456 
457   /**
458    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
459    * @param _roles the names of the roles to scope access to
460    * // reverts
461    *
462    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
463    *  see: https://github.com/ethereum/solidity/issues/2467
464    */
465   // modifier onlyRoles(string[] _roles) {
466   //     bool hasAnyRole = false;
467   //     for (uint8 i = 0; i < _roles.length; i++) {
468   //         if (hasRole(msg.sender, _roles[i])) {
469   //             hasAnyRole = true;
470   //             break;
471   //         }
472   //     }
473 
474   //     require(hasAnyRole);
475 
476   //     _;
477   // }
478 }
479 
480 // File: openzeppelin-solidity/contracts/access/Whitelist.sol
481 
482 /**
483  * @title Whitelist
484  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
485  * This simplifies the implementation of "user permissions".
486  */
487 contract Whitelist is Ownable, RBAC {
488   string public constant ROLE_WHITELISTED = "whitelist";
489 
490   /**
491    * @dev Throws if operator is not whitelisted.
492    * @param _operator address
493    */
494   modifier onlyIfWhitelisted(address _operator) {
495     checkRole(_operator, ROLE_WHITELISTED);
496     _;
497   }
498 
499   /**
500    * @dev add an address to the whitelist
501    * @param _operator address
502    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
503    */
504   function addAddressToWhitelist(address _operator)
505     public
506     onlyOwner
507   {
508     addRole(_operator, ROLE_WHITELISTED);
509   }
510 
511   /**
512    * @dev getter to determine if address is in whitelist
513    */
514   function whitelist(address _operator)
515     public
516     view
517     returns (bool)
518   {
519     return hasRole(_operator, ROLE_WHITELISTED);
520   }
521 
522   /**
523    * @dev add addresses to the whitelist
524    * @param _operators addresses
525    * @return true if at least one address was added to the whitelist,
526    * false if all addresses were already in the whitelist
527    */
528   function addAddressesToWhitelist(address[] _operators)
529     public
530     onlyOwner
531   {
532     for (uint256 i = 0; i < _operators.length; i++) {
533       addAddressToWhitelist(_operators[i]);
534     }
535   }
536 
537   /**
538    * @dev remove an address from the whitelist
539    * @param _operator address
540    * @return true if the address was removed from the whitelist,
541    * false if the address wasn't in the whitelist in the first place
542    */
543   function removeAddressFromWhitelist(address _operator)
544     public
545     onlyOwner
546   {
547     removeRole(_operator, ROLE_WHITELISTED);
548   }
549 
550   /**
551    * @dev remove addresses from the whitelist
552    * @param _operators addresses
553    * @return true if at least one address was removed from the whitelist,
554    * false if all addresses weren't in the whitelist in the first place
555    */
556   function removeAddressesFromWhitelist(address[] _operators)
557     public
558     onlyOwner
559   {
560     for (uint256 i = 0; i < _operators.length; i++) {
561       removeAddressFromWhitelist(_operators[i]);
562     }
563   }
564 
565 }
566 
567 // File: contracts/inx/WhitelistedMintableToken.sol
568 
569 /**
570  * @title Whitelisted Mintable token - allow whitelisted to mint
571  * @dev Simple ERC20 Token example, with mintable token creation
572  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
573  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
574  */
575 contract WhitelistedMintableToken is StandardToken, Whitelist {
576   event Mint(address indexed to, uint256 amount);
577 
578   /**
579    * @dev Function to mint tokens
580    * @param _to The address that will receive the minted tokens.
581    * @param _amount The amount of tokens to mint.
582    * @return A boolean that indicates if the operation was successful.
583    */
584   function mint(address _to, uint256 _amount) public onlyIfWhitelisted(msg.sender) returns (bool) {
585     totalSupply_ = totalSupply_.add(_amount);
586     balances[_to] = balances[_to].add(_amount);
587     emit Mint(_to, _amount);
588     emit Transfer(address(0), _to, _amount);
589     return true;
590   }
591 }
592 
593 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
594 
595 /**
596  * @title SafeERC20
597  * @dev Wrappers around ERC20 operations that throw on failure.
598  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
599  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
600  */
601 library SafeERC20 {
602   function safeTransfer(
603     ERC20Basic _token,
604     address _to,
605     uint256 _value
606   )
607     internal
608   {
609     require(_token.transfer(_to, _value));
610   }
611 
612   function safeTransferFrom(
613     ERC20 _token,
614     address _from,
615     address _to,
616     uint256 _value
617   )
618     internal
619   {
620     require(_token.transferFrom(_from, _to, _value));
621   }
622 
623   function safeApprove(
624     ERC20 _token,
625     address _spender,
626     uint256 _value
627   )
628     internal
629   {
630     require(_token.approve(_spender, _value));
631   }
632 }
633 
634 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
635 
636 /**
637  * @title Crowdsale
638  * @dev Crowdsale is a base contract for managing a token crowdsale,
639  * allowing investors to purchase tokens with ether. This contract implements
640  * such functionality in its most fundamental form and can be extended to provide additional
641  * functionality and/or custom behavior.
642  * The external interface represents the basic interface for purchasing tokens, and conform
643  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
644  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
645  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
646  * behavior.
647  */
648 contract Crowdsale {
649   using SafeMath for uint256;
650   using SafeERC20 for ERC20;
651 
652   // The token being sold
653   ERC20 public token;
654 
655   // Address where funds are collected
656   address public wallet;
657 
658   // How many token units a buyer gets per wei.
659   // The rate is the conversion between wei and the smallest and indivisible token unit.
660   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
661   // 1 wei will give you 1 unit, or 0.001 TOK.
662   uint256 public rate;
663 
664   // Amount of wei raised
665   uint256 public weiRaised;
666 
667   /**
668    * Event for token purchase logging
669    * @param purchaser who paid for the tokens
670    * @param beneficiary who got the tokens
671    * @param value weis paid for purchase
672    * @param amount amount of tokens purchased
673    */
674   event TokenPurchase(
675     address indexed purchaser,
676     address indexed beneficiary,
677     uint256 value,
678     uint256 amount
679   );
680 
681   /**
682    * @param _rate Number of token units a buyer gets per wei
683    * @param _wallet Address where collected funds will be forwarded to
684    * @param _token Address of the token being sold
685    */
686   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
687     require(_rate > 0);
688     require(_wallet != address(0));
689     require(_token != address(0));
690 
691     rate = _rate;
692     wallet = _wallet;
693     token = _token;
694   }
695 
696   // -----------------------------------------
697   // Crowdsale external interface
698   // -----------------------------------------
699 
700   /**
701    * @dev fallback function ***DO NOT OVERRIDE***
702    */
703   function () external payable {
704     buyTokens(msg.sender);
705   }
706 
707   /**
708    * @dev low level token purchase ***DO NOT OVERRIDE***
709    * @param _beneficiary Address performing the token purchase
710    */
711   function buyTokens(address _beneficiary) public payable {
712 
713     uint256 weiAmount = msg.value;
714     _preValidatePurchase(_beneficiary, weiAmount);
715 
716     // calculate token amount to be created
717     uint256 tokens = _getTokenAmount(weiAmount);
718 
719     // update state
720     weiRaised = weiRaised.add(weiAmount);
721 
722     _processPurchase(_beneficiary, tokens);
723     emit TokenPurchase(
724       msg.sender,
725       _beneficiary,
726       weiAmount,
727       tokens
728     );
729 
730     _updatePurchasingState(_beneficiary, weiAmount);
731 
732     _forwardFunds();
733     _postValidatePurchase(_beneficiary, weiAmount);
734   }
735 
736   // -----------------------------------------
737   // Internal interface (extensible)
738   // -----------------------------------------
739 
740   /**
741    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
742    * Example from CappedCrowdsale.sol's _preValidatePurchase method: 
743    *   super._preValidatePurchase(_beneficiary, _weiAmount);
744    *   require(weiRaised.add(_weiAmount) <= cap);
745    * @param _beneficiary Address performing the token purchase
746    * @param _weiAmount Value in wei involved in the purchase
747    */
748   function _preValidatePurchase(
749     address _beneficiary,
750     uint256 _weiAmount
751   )
752     internal
753   {
754     require(_beneficiary != address(0));
755     require(_weiAmount != 0);
756   }
757 
758   /**
759    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
760    * @param _beneficiary Address performing the token purchase
761    * @param _weiAmount Value in wei involved in the purchase
762    */
763   function _postValidatePurchase(
764     address _beneficiary,
765     uint256 _weiAmount
766   )
767     internal
768   {
769     // optional override
770   }
771 
772   /**
773    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
774    * @param _beneficiary Address performing the token purchase
775    * @param _tokenAmount Number of tokens to be emitted
776    */
777   function _deliverTokens(
778     address _beneficiary,
779     uint256 _tokenAmount
780   )
781     internal
782   {
783     token.safeTransfer(_beneficiary, _tokenAmount);
784   }
785 
786   /**
787    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
788    * @param _beneficiary Address receiving the tokens
789    * @param _tokenAmount Number of tokens to be purchased
790    */
791   function _processPurchase(
792     address _beneficiary,
793     uint256 _tokenAmount
794   )
795     internal
796   {
797     _deliverTokens(_beneficiary, _tokenAmount);
798   }
799 
800   /**
801    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
802    * @param _beneficiary Address receiving the tokens
803    * @param _weiAmount Value in wei involved in the purchase
804    */
805   function _updatePurchasingState(
806     address _beneficiary,
807     uint256 _weiAmount
808   )
809     internal
810   {
811     // optional override
812   }
813 
814   /**
815    * @dev Override to extend the way in which ether is converted to tokens.
816    * @param _weiAmount Value in wei to be converted into tokens
817    * @return Number of tokens that can be purchased with the specified _weiAmount
818    */
819   function _getTokenAmount(uint256 _weiAmount)
820     internal view returns (uint256)
821   {
822     return _weiAmount.mul(rate);
823   }
824 
825   /**
826    * @dev Determines how ETH is stored/forwarded on purchases.
827    */
828   function _forwardFunds() internal {
829     wallet.transfer(msg.value);
830   }
831 }
832 
833 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
834 
835 /**
836  * @title Pausable
837  * @dev Base contract which allows children to implement an emergency stop mechanism.
838  */
839 contract Pausable is Ownable {
840   event Pause();
841   event Unpause();
842 
843   bool public paused = false;
844 
845 
846   /**
847    * @dev Modifier to make a function callable only when the contract is not paused.
848    */
849   modifier whenNotPaused() {
850     require(!paused);
851     _;
852   }
853 
854   /**
855    * @dev Modifier to make a function callable only when the contract is paused.
856    */
857   modifier whenPaused() {
858     require(paused);
859     _;
860   }
861 
862   /**
863    * @dev called by the owner to pause, triggers stopped state
864    */
865   function pause() public onlyOwner whenNotPaused {
866     paused = true;
867     emit Pause();
868   }
869 
870   /**
871    * @dev called by the owner to unpause, returns to normal state
872    */
873   function unpause() public onlyOwner whenPaused {
874     paused = false;
875     emit Unpause();
876   }
877 }
878 
879 // File: contracts/inx/MintedKYCCrowdsale.sol
880 
881 /**
882  * @title MintedKYCCrowdsale (adjusted to use WhitelistedMintableToken to deliver tokens)
883  * Based on open-zeppelin's WhitelistedCrowdsale adjusted so INX whitelisted addresses can add and remove from KYC list
884  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase with whitelisting ability (for purchase).
885  * MintedKYCCrowdsale should be on the token's whitelist to enable minting.
886  */
887 contract MintedKYCCrowdsale is Crowdsale, Pausable {
888 
889   mapping(address => bool) public kyc;
890 
891   mapping(address => bool) public inxWhitelist;
892 
893   /**
894    * @dev Throws if called by any account other than the owner or the someone in the management list.
895    */
896   modifier onlyInx() {
897     require(msg.sender == owner || inxWhitelist[msg.sender], "Must be owner or in INX whitelist");
898     _;
899   }
900 
901   /**
902    * @dev Reverts if beneficiary and msg.sender is not KYC'd. Note: msg.sender and beneficiary can be different.
903    */
904   modifier isSenderAndBeneficiaryKyc(address _beneficiary) {
905     require(kyc[_beneficiary] && kyc[msg.sender], "Both message sender and beneficiary must be KYC approved");
906     _;
907   }
908 
909   /**
910    * @dev Adds single address to kyc.
911    * @param _beneficiary Address to be added to the kyc
912    */
913   function addToKyc(address _beneficiary) external onlyInx {
914     kyc[_beneficiary] = true;
915   }
916 
917   /**
918    * @dev Adds list of addresses to kyc.
919    * @param _beneficiaries Addresses to be added to the kyc
920    */
921   function addManyToKyc(address[] _beneficiaries) external onlyInx {
922     for (uint256 i = 0; i < _beneficiaries.length; i++) {
923       kyc[_beneficiaries[i]] = true;
924     }
925   }
926 
927   /**
928    * @dev Removes single address from kyc.
929    * @param _beneficiary Address to be removed to the kyc
930    */
931   function removeFromKyc(address _beneficiary) external onlyInx {
932     kyc[_beneficiary] = false;
933   }
934 
935   /**
936  * @dev Adds single address to the INX whitelist.
937  * @param _inx Address to be added to the INX whitelist
938  */
939   function addToInxWhitelist(address _inx) external onlyOwner {
940     inxWhitelist[_inx] = true;
941   }
942 
943   /**
944    * @dev Removes single address from the INX whitelist.
945    * @param _inx Address to be removed to the INX whitelist
946    */
947   function removeFromInxWhitelist(address _inx) external onlyOwner {
948     inxWhitelist[_inx] = false;
949   }
950 
951   /**
952    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
953    * @param _beneficiary Token beneficiary
954    * @param _weiAmount Amount of wei contributed
955    */
956   function _preValidatePurchase(
957     address _beneficiary,
958     uint256 _weiAmount
959   ) internal isSenderAndBeneficiaryKyc(_beneficiary) {
960     super._preValidatePurchase(_beneficiary, _weiAmount);
961   }
962 
963   /**
964    * @dev Overrides delivery by minting tokens upon purchase.
965    * @param _beneficiary Token purchaser
966    * @param _tokenAmount Number of tokens to be minted
967    */
968   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
969     require(WhitelistedMintableToken(token).mint(_beneficiary, _tokenAmount), "Unable to deliver tokens");
970   }
971 }
972 
973 // File: contracts/inx/INXCrowdsale.sol
974 
975 /**
976  * @title INXCrowdsale to be used in the Investx crowdsale event
977  */
978 contract INXCrowdsale is MintedKYCCrowdsale {
979 
980   mapping(address => uint256) public contributions;
981 
982   // Thursday, 01-Nov-18 14:00:00 UTC
983   uint256 public openingTime = 1541080800;
984 
985   // Thursday, 28-Feb-19 14:00:00 UTC
986   uint256 public closingTime = 1551362400;
987 
988   // minimum contribution in wei - this can change
989   uint256 public minContribution = 5 ether;
990 
991   // if true, then we are in the pre-sale phase
992   bool public inPreSale = true;
993 
994   // How many token units a buyer gets per wei (during pre-sale)
995   uint256 public preSaleRate;
996 
997   constructor(
998     address _wallet,
999     ERC20 _token,
1000     uint256 _rate,
1001     uint256 _preSaleRate
1002   ) public Crowdsale(_rate, _wallet, _token) {
1003     require(_preSaleRate > 0, "Pre-sale rate must not be zero");
1004 
1005     preSaleRate = _preSaleRate;
1006   }
1007 
1008   /**
1009    * @dev Owner can set rate during the crowdsale
1010    * @param _rate rate used to calculate tokens per wei
1011    */
1012   function setRate(uint256 _rate) external onlyOwner {
1013     require(_rate > 0, "Rate must not be zero");
1014 
1015     rate = _rate;
1016   }
1017 
1018   /**
1019    * @dev Owner can set pre-sale rate during the crowdsale
1020    * @param _preSaleRate rate used to calculate tokens per wei in pre-sale
1021    */
1022   function setPreSaleRate(uint256 _preSaleRate) external onlyOwner {
1023     require(_preSaleRate > 0, "Pre-sale rate must not be zero");
1024 
1025     preSaleRate = _preSaleRate;
1026   }
1027 
1028   /**
1029    * @dev Owner can set the closing time for the crowdsale
1030    * @param _closingTime timestamp for the close
1031    */
1032   function setClosingTime(uint256 _closingTime) external onlyOwner {
1033     require(_closingTime > openingTime, "Closing time must be after opening time");
1034 
1035     closingTime = _closingTime;
1036   }
1037 
1038   /**
1039    * @dev Owner can set the minimum contribution. This will change from pre-sale to public.
1040    * @param _minContribution amount of min contribution
1041    */
1042   function setMinContribution(uint256 _minContribution) external onlyOwner {
1043     require(_minContribution > 0, "Minimum contribution must not be zero");
1044 
1045     minContribution = _minContribution;
1046   }
1047 
1048   /**
1049    * @dev Owner can trigger public sale (moves from pre-sale to public)
1050    */
1051   function publicSale() external onlyOwner {
1052     require(inPreSale, "Must be in pre-sale to start public sale");
1053 
1054     inPreSale = false;
1055   }
1056 
1057   /**
1058    * @dev returns the current rate of the crowdsale
1059    */
1060   function getCurrentRate() public view returns (uint256) {
1061     if (inPreSale) {
1062       return preSaleRate;
1063     }
1064 
1065     return rate;
1066   }
1067 
1068   /**
1069    * @dev Checks whether the period in which the crowdsale is open has elapsed.
1070    * @return Whether crowdsale period is open
1071    */
1072   function isCrowdsaleOpen() public view returns (bool) {
1073     return block.timestamp >= openingTime && block.timestamp <= closingTime;
1074   }
1075 
1076   /**
1077    * @dev Override to extend the way in which ether is converted to tokens.
1078    * @param _weiAmount Value in wei to be converted into tokens
1079    * @return Number of tokens that can be purchased with the specified _weiAmount
1080    */
1081   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
1082     if (inPreSale) {
1083       return _weiAmount.mul(preSaleRate);
1084     }
1085 
1086     return _weiAmount.mul(rate);
1087   }
1088 
1089   /**
1090    * @dev Extend parent behavior to update user contributions so far
1091    * @param _beneficiary Token purchaser
1092    * @param _weiAmount Amount of wei contributed
1093    */
1094   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
1095     super._updatePurchasingState(_beneficiary, _weiAmount);
1096     contributions[_beneficiary] = contributions[_beneficiary].add(_weiAmount);
1097   }
1098 
1099   /**
1100   * @dev Extend parent behavior requiring contract to not be paused.
1101   * @param _beneficiary Token beneficiary
1102   * @param _weiAmount Amount of wei contributed
1103   */
1104   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
1105     super._preValidatePurchase(_beneficiary, _weiAmount);
1106 
1107     require(isCrowdsaleOpen(), "INXCrowdsale not Open");
1108 
1109     require(_weiAmount >= minContribution, "INXCrowdsale contribution below minimum");
1110 
1111     require(!paused, "INXCrowdsale is paused");
1112   }
1113 }