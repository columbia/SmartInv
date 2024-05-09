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
17 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
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
69 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
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
115 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
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
593 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
594 
595 /**
596  * @title Burnable Token
597  * @dev Token that can be irreversibly burned (destroyed).
598  */
599 contract BurnableToken is BasicToken {
600 
601   event Burn(address indexed burner, uint256 value);
602 
603   /**
604    * @dev Burns a specific amount of tokens.
605    * @param _value The amount of token to be burned.
606    */
607   function burn(uint256 _value) public {
608     _burn(msg.sender, _value);
609   }
610 
611   function _burn(address _who, uint256 _value) internal {
612     require(_value <= balances[_who]);
613     // no need to require value <= totalSupply, since that would imply the
614     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
615 
616     balances[_who] = balances[_who].sub(_value);
617     totalSupply_ = totalSupply_.sub(_value);
618     emit Burn(_who, _value);
619     emit Transfer(_who, address(0), _value);
620   }
621 }
622 
623 // File: openzeppelin-solidity/contracts/token/ERC20/StandardBurnableToken.sol
624 
625 /**
626  * @title Standard Burnable Token
627  * @dev Adds burnFrom method to ERC20 implementations
628  */
629 contract StandardBurnableToken is BurnableToken, StandardToken {
630 
631   /**
632    * @dev Burns a specific amount of tokens from the target address and decrements allowance
633    * @param _from address The address which you want to send tokens from
634    * @param _value uint256 The amount of token to be burned
635    */
636   function burnFrom(address _from, uint256 _value) public {
637     require(_value <= allowed[_from][msg.sender]);
638     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
639     // this function needs to emit an event with the updated approval.
640     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
641     _burn(_from, _value);
642   }
643 }
644 
645 // File: openzeppelin-solidity/contracts/ownership/HasNoEther.sol
646 
647 /**
648  * @title Contracts that should not own Ether
649  * @author Remco Bloemen <remco@2π.com>
650  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
651  * in the contract, it will allow the owner to reclaim this Ether.
652  * @notice Ether can still be sent to this contract by:
653  * calling functions labeled `payable`
654  * `selfdestruct(contract_address)`
655  * mining directly to the contract address
656  */
657 contract HasNoEther is Ownable {
658 
659   /**
660   * @dev Constructor that rejects incoming Ether
661   * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
662   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
663   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
664   * we could use assembly to access msg.value.
665   */
666   constructor() public payable {
667     require(msg.value == 0);
668   }
669 
670   /**
671    * @dev Disallows direct send by setting a default function without the `payable` flag.
672    */
673   function() external {
674   }
675 
676   /**
677    * @dev Transfer all Ether held by the contract to the owner.
678    */
679   function reclaimEther() external onlyOwner {
680     owner.transfer(address(this).balance);
681   }
682 }
683 
684 // File: contracts/inx/INXToken.sol
685 
686 /**
687  * @title INXToken ERC20 token for use with the Investx Platform
688  * See investx.io for more details
689  */
690 contract INXToken is WhitelistedMintableToken, StandardBurnableToken, HasNoEther {
691 
692   string public constant name = "INX Token";
693   string public constant symbol = "INX";
694   uint8 public constant decimals = 18;
695 
696   // flag to control "general" transfers (outside of whitelisted and founders)
697   bool public transfersEnabled = false;
698 
699   // all the founders must be added to this mapping (with a true flag)
700   mapping(address => bool) public founders;
701 
702   // founders have a token lock-up that stops transfers (to non-investx addresses) upto this timestamp
703   // locked until after the Sunday, February 28, 2021 11:59:59 PM
704   uint256 constant public founderTokensLockedUntil = 1614556799;
705 
706   // address that the investx platform will use to receive INX tokens for investment (when developed)
707   address public investxPlatform;
708 
709   constructor() public payable {
710     // contract creator is automatically whitelisted
711     addAddressToWhitelist(msg.sender);
712   }
713 
714   /**
715    * @dev Adds single address to founders (who are locked for a period of time).
716    * @param _founder Address to be added to the founder list
717    */
718   function addAddressToFounders(address _founder) external onlyOwner {
719     require(_founder != address(0), "Can not be zero address");
720 
721     founders[_founder] = true;
722   }
723 
724   /**
725    * @dev Owner turn on "general" account-to-account transfers (once and only once)
726    */
727   function enableTransfers() external onlyOwner {
728     require(!transfersEnabled, "Transfers already enabled");
729 
730     transfersEnabled = true;
731   }
732 
733   /**
734    * @dev Owner can set the investx platform address once built
735    * @param _investxPlatform address of the investx platform (where you send your tokens for investments)
736    */
737   function setInvestxPlatform(address _investxPlatform) external onlyOwner {
738     require(_investxPlatform != address(0), "Can not be zero address");
739 
740     investxPlatform = _investxPlatform;
741   }
742 
743  /**
744   * @dev transfer token for a specified address
745   * @param _to The address to transfer to.
746   * @param _value The amount to be transferred.
747   */
748   function transfer(address _to, uint256 _value) public returns (bool) {
749     // transfers will be disabled during the crowdfunding phase - unless on the whitelist
750     require(transfersEnabled || whitelist(msg.sender), "INXToken transfers disabled");
751 
752     require(
753       !founders[msg.sender] || founderTokensLockedUntil < block.timestamp || _to == investxPlatform,
754       "INXToken locked for founders for arbitrary time unless sending to investx platform"
755     );
756 
757     return super.transfer(_to, _value);
758   }
759 
760   /**
761    * @dev Transfer tokens from one address to another
762    * @param _from address The address which you want to send tokens from
763    * @param _to address The address which you want to transfer to
764    * @param _value uint256 the amount of tokens to be transferred
765    */
766   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
767     // transfers will be disabled during the crowdfunding phase - unless on the whitelist
768     require(transfersEnabled || whitelist(_from), "INXToken transfers disabled");
769 
770     require(
771       !founders[_from] || founderTokensLockedUntil < block.timestamp || _to == investxPlatform,
772         "INXToken locked for founders for arbitrary time unless sending to investx platform"
773     );
774 
775     return super.transferFrom(_from, _to, _value);
776   }
777 }