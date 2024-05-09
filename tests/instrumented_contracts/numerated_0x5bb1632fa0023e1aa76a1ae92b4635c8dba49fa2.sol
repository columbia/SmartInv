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
38 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
39 
40 /**
41  * @title DetailedERC20 token
42  * @dev The decimals are only for visualization purposes.
43  * All the operations are done using the smallest and indivisible token unit,
44  * just as on Ethereum all the operations are done in wei.
45  */
46 contract DetailedERC20 is ERC20 {
47   string public name;
48   string public symbol;
49   uint8 public decimals;
50 
51   constructor(string _name, string _symbol, uint8 _decimals) public {
52     name = _name;
53     symbol = _symbol;
54     decimals = _decimals;
55   }
56 }
57 
58 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
59 
60 /**
61  * @title SafeMath
62  * @dev Math operations with safety checks that throw on error
63  */
64 library SafeMath {
65 
66   /**
67   * @dev Multiplies two numbers, throws on overflow.
68   */
69   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
70     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
71     // benefit is lost if 'b' is also tested.
72     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
73     if (_a == 0) {
74       return 0;
75     }
76 
77     c = _a * _b;
78     assert(c / _a == _b);
79     return c;
80   }
81 
82   /**
83   * @dev Integer division of two numbers, truncating the quotient.
84   */
85   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
86     // assert(_b > 0); // Solidity automatically throws when dividing by 0
87     // uint256 c = _a / _b;
88     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
89     return _a / _b;
90   }
91 
92   /**
93   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
94   */
95   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
96     assert(_b <= _a);
97     return _a - _b;
98   }
99 
100   /**
101   * @dev Adds two numbers, throws on overflow.
102   */
103   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
104     c = _a + _b;
105     assert(c >= _a);
106     return c;
107   }
108 }
109 
110 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
111 
112 /**
113  * @title Basic token
114  * @dev Basic version of StandardToken, with no allowances.
115  */
116 contract BasicToken is ERC20Basic {
117   using SafeMath for uint256;
118 
119   mapping(address => uint256) internal balances;
120 
121   uint256 internal totalSupply_;
122 
123   /**
124   * @dev Total number of tokens in existence
125   */
126   function totalSupply() public view returns (uint256) {
127     return totalSupply_;
128   }
129 
130   /**
131   * @dev Transfer token for a specified address
132   * @param _to The address to transfer to.
133   * @param _value The amount to be transferred.
134   */
135   function transfer(address _to, uint256 _value) public returns (bool) {
136     require(_value <= balances[msg.sender]);
137     require(_to != address(0));
138 
139     balances[msg.sender] = balances[msg.sender].sub(_value);
140     balances[_to] = balances[_to].add(_value);
141     emit Transfer(msg.sender, _to, _value);
142     return true;
143   }
144 
145   /**
146   * @dev Gets the balance of the specified address.
147   * @param _owner The address to query the the balance of.
148   * @return An uint256 representing the amount owned by the passed address.
149   */
150   function balanceOf(address _owner) public view returns (uint256) {
151     return balances[_owner];
152   }
153 
154 }
155 
156 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
157 
158 /**
159  * @title Standard ERC20 token
160  *
161  * @dev Implementation of the basic standard token.
162  * https://github.com/ethereum/EIPs/issues/20
163  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
164  */
165 contract StandardToken is ERC20, BasicToken {
166 
167   mapping (address => mapping (address => uint256)) internal allowed;
168 
169 
170   /**
171    * @dev Transfer tokens from one address to another
172    * @param _from address The address which you want to send tokens from
173    * @param _to address The address which you want to transfer to
174    * @param _value uint256 the amount of tokens to be transferred
175    */
176   function transferFrom(
177     address _from,
178     address _to,
179     uint256 _value
180   )
181     public
182     returns (bool)
183   {
184     require(_value <= balances[_from]);
185     require(_value <= allowed[_from][msg.sender]);
186     require(_to != address(0));
187 
188     balances[_from] = balances[_from].sub(_value);
189     balances[_to] = balances[_to].add(_value);
190     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
191     emit Transfer(_from, _to, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
197    * Beware that changing an allowance with this method brings the risk that someone may use both the old
198    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
199    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
200    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201    * @param _spender The address which will spend the funds.
202    * @param _value The amount of tokens to be spent.
203    */
204   function approve(address _spender, uint256 _value) public returns (bool) {
205     allowed[msg.sender][_spender] = _value;
206     emit Approval(msg.sender, _spender, _value);
207     return true;
208   }
209 
210   /**
211    * @dev Function to check the amount of tokens that an owner allowed to a spender.
212    * @param _owner address The address which owns the funds.
213    * @param _spender address The address which will spend the funds.
214    * @return A uint256 specifying the amount of tokens still available for the spender.
215    */
216   function allowance(
217     address _owner,
218     address _spender
219    )
220     public
221     view
222     returns (uint256)
223   {
224     return allowed[_owner][_spender];
225   }
226 
227   /**
228    * @dev Increase the amount of tokens that an owner allowed to a spender.
229    * approve should be called when allowed[_spender] == 0. To increment
230    * allowed value is better to use this function to avoid 2 calls (and wait until
231    * the first transaction is mined)
232    * From MonolithDAO Token.sol
233    * @param _spender The address which will spend the funds.
234    * @param _addedValue The amount of tokens to increase the allowance by.
235    */
236   function increaseApproval(
237     address _spender,
238     uint256 _addedValue
239   )
240     public
241     returns (bool)
242   {
243     allowed[msg.sender][_spender] = (
244       allowed[msg.sender][_spender].add(_addedValue));
245     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
246     return true;
247   }
248 
249   /**
250    * @dev Decrease the amount of tokens that an owner allowed to a spender.
251    * approve should be called when allowed[_spender] == 0. To decrement
252    * allowed value is better to use this function to avoid 2 calls (and wait until
253    * the first transaction is mined)
254    * From MonolithDAO Token.sol
255    * @param _spender The address which will spend the funds.
256    * @param _subtractedValue The amount of tokens to decrease the allowance by.
257    */
258   function decreaseApproval(
259     address _spender,
260     uint256 _subtractedValue
261   )
262     public
263     returns (bool)
264   {
265     uint256 oldValue = allowed[msg.sender][_spender];
266     if (_subtractedValue >= oldValue) {
267       allowed[msg.sender][_spender] = 0;
268     } else {
269       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
270     }
271     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
272     return true;
273   }
274 
275 }
276 
277 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
278 
279 /**
280  * @title Ownable
281  * @dev The Ownable contract has an owner address, and provides basic authorization control
282  * functions, this simplifies the implementation of "user permissions".
283  */
284 contract Ownable {
285   address public owner;
286 
287 
288   event OwnershipRenounced(address indexed previousOwner);
289   event OwnershipTransferred(
290     address indexed previousOwner,
291     address indexed newOwner
292   );
293 
294 
295   /**
296    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
297    * account.
298    */
299   constructor() public {
300     owner = msg.sender;
301   }
302 
303   /**
304    * @dev Throws if called by any account other than the owner.
305    */
306   modifier onlyOwner() {
307     require(msg.sender == owner);
308     _;
309   }
310 
311   /**
312    * @dev Allows the current owner to relinquish control of the contract.
313    * @notice Renouncing to ownership will leave the contract without an owner.
314    * It will not be possible to call the functions with the `onlyOwner`
315    * modifier anymore.
316    */
317   function renounceOwnership() public onlyOwner {
318     emit OwnershipRenounced(owner);
319     owner = address(0);
320   }
321 
322   /**
323    * @dev Allows the current owner to transfer control of the contract to a newOwner.
324    * @param _newOwner The address to transfer ownership to.
325    */
326   function transferOwnership(address _newOwner) public onlyOwner {
327     _transferOwnership(_newOwner);
328   }
329 
330   /**
331    * @dev Transfers control of the contract to a newOwner.
332    * @param _newOwner The address to transfer ownership to.
333    */
334   function _transferOwnership(address _newOwner) internal {
335     require(_newOwner != address(0));
336     emit OwnershipTransferred(owner, _newOwner);
337     owner = _newOwner;
338   }
339 }
340 
341 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
342 
343 /**
344  * @title Mintable token
345  * @dev Simple ERC20 Token example, with mintable token creation
346  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
347  */
348 contract MintableToken is StandardToken, Ownable {
349   event Mint(address indexed to, uint256 amount);
350   event MintFinished();
351 
352   bool public mintingFinished = false;
353 
354 
355   modifier canMint() {
356     require(!mintingFinished);
357     _;
358   }
359 
360   modifier hasMintPermission() {
361     require(msg.sender == owner);
362     _;
363   }
364 
365   /**
366    * @dev Function to mint tokens
367    * @param _to The address that will receive the minted tokens.
368    * @param _amount The amount of tokens to mint.
369    * @return A boolean that indicates if the operation was successful.
370    */
371   function mint(
372     address _to,
373     uint256 _amount
374   )
375     public
376     hasMintPermission
377     canMint
378     returns (bool)
379   {
380     totalSupply_ = totalSupply_.add(_amount);
381     balances[_to] = balances[_to].add(_amount);
382     emit Mint(_to, _amount);
383     emit Transfer(address(0), _to, _amount);
384     return true;
385   }
386 
387   /**
388    * @dev Function to stop minting new tokens.
389    * @return True if the operation was successful.
390    */
391   function finishMinting() public onlyOwner canMint returns (bool) {
392     mintingFinished = true;
393     emit MintFinished();
394     return true;
395   }
396 }
397 
398 // File: openzeppelin-solidity/contracts/access/rbac/Roles.sol
399 
400 /**
401  * @title Roles
402  * @author Francisco Giordano (@frangio)
403  * @dev Library for managing addresses assigned to a Role.
404  * See RBAC.sol for example usage.
405  */
406 library Roles {
407   struct Role {
408     mapping (address => bool) bearer;
409   }
410 
411   /**
412    * @dev give an address access to this role
413    */
414   function add(Role storage _role, address _addr)
415     internal
416   {
417     _role.bearer[_addr] = true;
418   }
419 
420   /**
421    * @dev remove an address' access to this role
422    */
423   function remove(Role storage _role, address _addr)
424     internal
425   {
426     _role.bearer[_addr] = false;
427   }
428 
429   /**
430    * @dev check if an address has this role
431    * // reverts
432    */
433   function check(Role storage _role, address _addr)
434     internal
435     view
436   {
437     require(has(_role, _addr));
438   }
439 
440   /**
441    * @dev check if an address has this role
442    * @return bool
443    */
444   function has(Role storage _role, address _addr)
445     internal
446     view
447     returns (bool)
448   {
449     return _role.bearer[_addr];
450   }
451 }
452 
453 // File: openzeppelin-solidity/contracts/access/rbac/RBAC.sol
454 
455 /**
456  * @title RBAC (Role-Based Access Control)
457  * @author Matt Condon (@Shrugs)
458  * @dev Stores and provides setters and getters for roles and addresses.
459  * Supports unlimited numbers of roles and addresses.
460  * See //contracts/mocks/RBACMock.sol for an example of usage.
461  * This RBAC method uses strings to key roles. It may be beneficial
462  * for you to write your own implementation of this interface using Enums or similar.
463  */
464 contract RBAC {
465   using Roles for Roles.Role;
466 
467   mapping (string => Roles.Role) private roles;
468 
469   event RoleAdded(address indexed operator, string role);
470   event RoleRemoved(address indexed operator, string role);
471 
472   /**
473    * @dev reverts if addr does not have role
474    * @param _operator address
475    * @param _role the name of the role
476    * // reverts
477    */
478   function checkRole(address _operator, string _role)
479     public
480     view
481   {
482     roles[_role].check(_operator);
483   }
484 
485   /**
486    * @dev determine if addr has role
487    * @param _operator address
488    * @param _role the name of the role
489    * @return bool
490    */
491   function hasRole(address _operator, string _role)
492     public
493     view
494     returns (bool)
495   {
496     return roles[_role].has(_operator);
497   }
498 
499   /**
500    * @dev add a role to an address
501    * @param _operator address
502    * @param _role the name of the role
503    */
504   function addRole(address _operator, string _role)
505     internal
506   {
507     roles[_role].add(_operator);
508     emit RoleAdded(_operator, _role);
509   }
510 
511   /**
512    * @dev remove a role from an address
513    * @param _operator address
514    * @param _role the name of the role
515    */
516   function removeRole(address _operator, string _role)
517     internal
518   {
519     roles[_role].remove(_operator);
520     emit RoleRemoved(_operator, _role);
521   }
522 
523   /**
524    * @dev modifier to scope access to a single role (uses msg.sender as addr)
525    * @param _role the name of the role
526    * // reverts
527    */
528   modifier onlyRole(string _role)
529   {
530     checkRole(msg.sender, _role);
531     _;
532   }
533 
534   /**
535    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
536    * @param _roles the names of the roles to scope access to
537    * // reverts
538    *
539    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
540    *  see: https://github.com/ethereum/solidity/issues/2467
541    */
542   // modifier onlyRoles(string[] _roles) {
543   //     bool hasAnyRole = false;
544   //     for (uint8 i = 0; i < _roles.length; i++) {
545   //         if (hasRole(msg.sender, _roles[i])) {
546   //             hasAnyRole = true;
547   //             break;
548   //         }
549   //     }
550 
551   //     require(hasAnyRole);
552 
553   //     _;
554   // }
555 }
556 
557 // File: openzeppelin-solidity/contracts/token/ERC20/RBACMintableToken.sol
558 
559 /**
560  * @title RBACMintableToken
561  * @author Vittorio Minacori (@vittominacori)
562  * @dev Mintable Token, with RBAC minter permissions
563  */
564 contract RBACMintableToken is MintableToken, RBAC {
565   /**
566    * A constant role name for indicating minters.
567    */
568   string public constant ROLE_MINTER = "minter";
569 
570   /**
571    * @dev override the Mintable token modifier to add role based logic
572    */
573   modifier hasMintPermission() {
574     checkRole(msg.sender, ROLE_MINTER);
575     _;
576   }
577 
578   /**
579    * @dev add a minter role to an address
580    * @param _minter address
581    */
582   function addMinter(address _minter) public onlyOwner {
583     addRole(_minter, ROLE_MINTER);
584   }
585 
586   /**
587    * @dev remove a minter role from an address
588    * @param _minter address
589    */
590   function removeMinter(address _minter) public onlyOwner {
591     removeRole(_minter, ROLE_MINTER);
592   }
593 }
594 
595 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
596 
597 /**
598  * @title Burnable Token
599  * @dev Token that can be irreversibly burned (destroyed).
600  */
601 contract BurnableToken is BasicToken {
602 
603   event Burn(address indexed burner, uint256 value);
604 
605   /**
606    * @dev Burns a specific amount of tokens.
607    * @param _value The amount of token to be burned.
608    */
609   function burn(uint256 _value) public {
610     _burn(msg.sender, _value);
611   }
612 
613   function _burn(address _who, uint256 _value) internal {
614     require(_value <= balances[_who]);
615     // no need to require value <= totalSupply, since that would imply the
616     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
617 
618     balances[_who] = balances[_who].sub(_value);
619     totalSupply_ = totalSupply_.sub(_value);
620     emit Burn(_who, _value);
621     emit Transfer(_who, address(0), _value);
622   }
623 }
624 
625 // File: openzeppelin-solidity/contracts/token/ERC20/CappedToken.sol
626 
627 /**
628  * @title Capped token
629  * @dev Mintable token with a token cap.
630  */
631 contract CappedToken is MintableToken {
632 
633   uint256 public cap;
634 
635   constructor(uint256 _cap) public {
636     require(_cap > 0);
637     cap = _cap;
638   }
639 
640   /**
641    * @dev Function to mint tokens
642    * @param _to The address that will receive the minted tokens.
643    * @param _amount The amount of tokens to mint.
644    * @return A boolean that indicates if the operation was successful.
645    */
646   function mint(
647     address _to,
648     uint256 _amount
649   )
650     public
651     returns (bool)
652   {
653     require(totalSupply_.add(_amount) <= cap);
654 
655     return super.mint(_to, _amount);
656   }
657 
658 }
659 
660 // File: openzeppelin-solidity/contracts/AddressUtils.sol
661 
662 /**
663  * Utility library of inline functions on addresses
664  */
665 library AddressUtils {
666 
667   /**
668    * Returns whether the target address is a contract
669    * @dev This function will return false if invoked during the constructor of a contract,
670    * as the code is not actually created until after the constructor finishes.
671    * @param _addr address to check
672    * @return whether the target address is a contract
673    */
674   function isContract(address _addr) internal view returns (bool) {
675     uint256 size;
676     // XXX Currently there is no better way to check if there is a contract in an address
677     // than to check the size of the code at that address.
678     // See https://ethereum.stackexchange.com/a/14016/36603
679     // for more details about how this works.
680     // TODO Check this again before the Serenity release, because all addresses will be
681     // contracts then.
682     // solium-disable-next-line security/no-inline-assembly
683     assembly { size := extcodesize(_addr) }
684     return size > 0;
685   }
686 
687 }
688 
689 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
690 
691 /**
692  * @title ERC165
693  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
694  */
695 interface ERC165 {
696 
697   /**
698    * @notice Query if a contract implements an interface
699    * @param _interfaceId The interface identifier, as specified in ERC-165
700    * @dev Interface identification is specified in ERC-165. This function
701    * uses less than 30,000 gas.
702    */
703   function supportsInterface(bytes4 _interfaceId)
704     external
705     view
706     returns (bool);
707 }
708 
709 // File: openzeppelin-solidity/contracts/introspection/SupportsInterfaceWithLookup.sol
710 
711 /**
712  * @title SupportsInterfaceWithLookup
713  * @author Matt Condon (@shrugs)
714  * @dev Implements ERC165 using a lookup table.
715  */
716 contract SupportsInterfaceWithLookup is ERC165 {
717 
718   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
719   /**
720    * 0x01ffc9a7 ===
721    *   bytes4(keccak256('supportsInterface(bytes4)'))
722    */
723 
724   /**
725    * @dev a mapping of interface id to whether or not it's supported
726    */
727   mapping(bytes4 => bool) internal supportedInterfaces;
728 
729   /**
730    * @dev A contract implementing SupportsInterfaceWithLookup
731    * implement ERC165 itself
732    */
733   constructor()
734     public
735   {
736     _registerInterface(InterfaceId_ERC165);
737   }
738 
739   /**
740    * @dev implement supportsInterface(bytes4) using a lookup table
741    */
742   function supportsInterface(bytes4 _interfaceId)
743     external
744     view
745     returns (bool)
746   {
747     return supportedInterfaces[_interfaceId];
748   }
749 
750   /**
751    * @dev private method for registering an interface
752    */
753   function _registerInterface(bytes4 _interfaceId)
754     internal
755   {
756     require(_interfaceId != 0xffffffff);
757     supportedInterfaces[_interfaceId] = true;
758   }
759 }
760 
761 // File: erc-payable-token/contracts/token/ERC1363/ERC1363.sol
762 
763 /**
764  * @title ERC1363 interface
765  * @author Vittorio Minacori (https://github.com/vittominacori)
766  * @dev Interface for a Payable Token contract as defined in
767  *  https://github.com/ethereum/EIPs/issues/1363
768  */
769 contract ERC1363 is ERC20, ERC165 {
770   /*
771    * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
772    * 0x4bbee2df ===
773    *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
774    *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
775    *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
776    *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
777    */
778 
779   /*
780    * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
781    * 0xfb9ec8ce ===
782    *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
783    *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
784    */
785 
786   /**
787    * @notice Transfer tokens from `msg.sender` to another address
788    *  and then call `onTransferReceived` on receiver
789    * @param _to address The address which you want to transfer to
790    * @param _value uint256 The amount of tokens to be transferred
791    * @return true unless throwing
792    */
793   function transferAndCall(address _to, uint256 _value) public returns (bool);
794 
795   /**
796    * @notice Transfer tokens from `msg.sender` to another address
797    *  and then call `onTransferReceived` on receiver
798    * @param _to address The address which you want to transfer to
799    * @param _value uint256 The amount of tokens to be transferred
800    * @param _data bytes Additional data with no specified format, sent in call to `_to`
801    * @return true unless throwing
802    */
803   function transferAndCall(address _to, uint256 _value, bytes _data) public returns (bool); // solium-disable-line max-len
804 
805   /**
806    * @notice Transfer tokens from one address to another
807    *  and then call `onTransferReceived` on receiver
808    * @param _from address The address which you want to send tokens from
809    * @param _to address The address which you want to transfer to
810    * @param _value uint256 The amount of tokens to be transferred
811    * @return true unless throwing
812    */
813   function transferFromAndCall(address _from, address _to, uint256 _value) public returns (bool); // solium-disable-line max-len
814 
815 
816   /**
817    * @notice Transfer tokens from one address to another
818    *  and then call `onTransferReceived` on receiver
819    * @param _from address The address which you want to send tokens from
820    * @param _to address The address which you want to transfer to
821    * @param _value uint256 The amount of tokens to be transferred
822    * @param _data bytes Additional data with no specified format, sent in call to `_to`
823    * @return true unless throwing
824    */
825   function transferFromAndCall(address _from, address _to, uint256 _value, bytes _data) public returns (bool); // solium-disable-line max-len, arg-overflow
826 
827   /**
828    * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
829    *  and then call `onApprovalReceived` on spender
830    *  Beware that changing an allowance with this method brings the risk that someone may use both the old
831    *  and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
832    *  race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
833    *  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
834    * @param _spender address The address which will spend the funds
835    * @param _value uint256 The amount of tokens to be spent
836    */
837   function approveAndCall(address _spender, uint256 _value) public returns (bool); // solium-disable-line max-len
838 
839   /**
840    * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
841    *  and then call `onApprovalReceived` on spender
842    *  Beware that changing an allowance with this method brings the risk that someone may use both the old
843    *  and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
844    *  race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
845    *  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
846    * @param _spender address The address which will spend the funds
847    * @param _value uint256 The amount of tokens to be spent
848    * @param _data bytes Additional data with no specified format, sent in call to `_spender`
849    */
850   function approveAndCall(address _spender, uint256 _value, bytes _data) public returns (bool); // solium-disable-line max-len
851 }
852 
853 // File: erc-payable-token/contracts/token/ERC1363/ERC1363Receiver.sol
854 
855 /**
856  * @title ERC1363Receiver interface
857  * @author Vittorio Minacori (https://github.com/vittominacori)
858  * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
859  *  from ERC1363 token contracts as defined in
860  *  https://github.com/ethereum/EIPs/issues/1363
861  */
862 contract ERC1363Receiver {
863   /*
864    * Note: the ERC-165 identifier for this interface is 0x88a7ca5c.
865    * 0x88a7ca5c === bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))
866    */
867 
868   /**
869    * @notice Handle the receipt of ERC1363 tokens
870    * @dev Any ERC1363 smart contract calls this function on the recipient
871    *  after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
872    *  transfer. Return of other than the magic value MUST result in the
873    *  transaction being reverted.
874    *  Note: the contract address is always the message sender.
875    * @param _operator address The address which called `transferAndCall` or `transferFromAndCall` function
876    * @param _from address The address which are token transferred from
877    * @param _value uint256 The amount of tokens transferred
878    * @param _data bytes Additional data with no specified format
879    * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
880    *  unless throwing
881    */
882   function onTransferReceived(address _operator, address _from, uint256 _value, bytes _data) external returns (bytes4); // solium-disable-line max-len, arg-overflow
883 }
884 
885 // File: erc-payable-token/contracts/token/ERC1363/ERC1363Spender.sol
886 
887 /**
888  * @title ERC1363Spender interface
889  * @author Vittorio Minacori (https://github.com/vittominacori)
890  * @dev Interface for any contract that wants to support approveAndCall
891  *  from ERC1363 token contracts as defined in
892  *  https://github.com/ethereum/EIPs/issues/1363
893  */
894 contract ERC1363Spender {
895   /*
896    * Note: the ERC-165 identifier for this interface is 0x7b04a2d0.
897    * 0x7b04a2d0 === bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))
898    */
899 
900   /**
901    * @notice Handle the approval of ERC1363 tokens
902    * @dev Any ERC1363 smart contract calls this function on the recipient
903    *  after an `approve`. This function MAY throw to revert and reject the
904    *  approval. Return of other than the magic value MUST result in the
905    *  transaction being reverted.
906    *  Note: the contract address is always the message sender.
907    * @param _owner address The address which called `approveAndCall` function
908    * @param _value uint256 The amount of tokens to be spent
909    * @param _data bytes Additional data with no specified format
910    * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
911    *  unless throwing
912    */
913   function onApprovalReceived(address _owner, uint256 _value, bytes _data) external returns (bytes4); // solium-disable-line max-len
914 }
915 
916 // File: erc-payable-token/contracts/token/ERC1363/ERC1363BasicToken.sol
917 
918 // solium-disable-next-line max-len
919 
920 
921 
922 
923 
924 
925 
926 /**
927  * @title ERC1363BasicToken
928  * @author Vittorio Minacori (https://github.com/vittominacori)
929  * @dev Implementation of an ERC1363 interface
930  */
931 contract ERC1363BasicToken is SupportsInterfaceWithLookup, StandardToken, ERC1363 { // solium-disable-line max-len
932   using AddressUtils for address;
933 
934   /*
935    * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
936    * 0x4bbee2df ===
937    *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
938    *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
939    *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
940    *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
941    */
942   bytes4 internal constant InterfaceId_ERC1363Transfer = 0x4bbee2df;
943 
944   /*
945    * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
946    * 0xfb9ec8ce ===
947    *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
948    *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
949    */
950   bytes4 internal constant InterfaceId_ERC1363Approve = 0xfb9ec8ce;
951 
952   // Equals to `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
953   // which can be also obtained as `ERC1363Receiver(0).onTransferReceived.selector`
954   bytes4 private constant ERC1363_RECEIVED = 0x88a7ca5c;
955 
956   // Equals to `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
957   // which can be also obtained as `ERC1363Spender(0).onApprovalReceived.selector`
958   bytes4 private constant ERC1363_APPROVED = 0x7b04a2d0;
959 
960   constructor() public {
961     // register the supported interfaces to conform to ERC1363 via ERC165
962     _registerInterface(InterfaceId_ERC1363Transfer);
963     _registerInterface(InterfaceId_ERC1363Approve);
964   }
965 
966   function transferAndCall(
967     address _to,
968     uint256 _value
969   )
970     public
971     returns (bool)
972   {
973     return transferAndCall(_to, _value, "");
974   }
975 
976   function transferAndCall(
977     address _to,
978     uint256 _value,
979     bytes _data
980   )
981     public
982     returns (bool)
983   {
984     require(transfer(_to, _value));
985     require(
986       checkAndCallTransfer(
987         msg.sender,
988         _to,
989         _value,
990         _data
991       )
992     );
993     return true;
994   }
995 
996   function transferFromAndCall(
997     address _from,
998     address _to,
999     uint256 _value
1000   )
1001     public
1002     returns (bool)
1003   {
1004     // solium-disable-next-line arg-overflow
1005     return transferFromAndCall(_from, _to, _value, "");
1006   }
1007 
1008   function transferFromAndCall(
1009     address _from,
1010     address _to,
1011     uint256 _value,
1012     bytes _data
1013   )
1014     public
1015     returns (bool)
1016   {
1017     require(transferFrom(_from, _to, _value));
1018     require(
1019       checkAndCallTransfer(
1020         _from,
1021         _to,
1022         _value,
1023         _data
1024       )
1025     );
1026     return true;
1027   }
1028 
1029   function approveAndCall(
1030     address _spender,
1031     uint256 _value
1032   )
1033     public
1034     returns (bool)
1035   {
1036     return approveAndCall(_spender, _value, "");
1037   }
1038 
1039   function approveAndCall(
1040     address _spender,
1041     uint256 _value,
1042     bytes _data
1043   )
1044     public
1045     returns (bool)
1046   {
1047     approve(_spender, _value);
1048     require(
1049       checkAndCallApprove(
1050         _spender,
1051         _value,
1052         _data
1053       )
1054     );
1055     return true;
1056   }
1057 
1058   /**
1059    * @dev Internal function to invoke `onTransferReceived` on a target address
1060    *  The call is not executed if the target address is not a contract
1061    * @param _from address Representing the previous owner of the given token value
1062    * @param _to address Target address that will receive the tokens
1063    * @param _value uint256 The amount mount of tokens to be transferred
1064    * @param _data bytes Optional data to send along with the call
1065    * @return whether the call correctly returned the expected magic value
1066    */
1067   function checkAndCallTransfer(
1068     address _from,
1069     address _to,
1070     uint256 _value,
1071     bytes _data
1072   )
1073     internal
1074     returns (bool)
1075   {
1076     if (!_to.isContract()) {
1077       return false;
1078     }
1079     bytes4 retval = ERC1363Receiver(_to).onTransferReceived(
1080       msg.sender, _from, _value, _data
1081     );
1082     return (retval == ERC1363_RECEIVED);
1083   }
1084 
1085   /**
1086    * @dev Internal function to invoke `onApprovalReceived` on a target address
1087    *  The call is not executed if the target address is not a contract
1088    * @param _spender address The address which will spend the funds
1089    * @param _value uint256 The amount of tokens to be spent
1090    * @param _data bytes Optional data to send along with the call
1091    * @return whether the call correctly returned the expected magic value
1092    */
1093   function checkAndCallApprove(
1094     address _spender,
1095     uint256 _value,
1096     bytes _data
1097   )
1098     internal
1099     returns (bool)
1100   {
1101     if (!_spender.isContract()) {
1102       return false;
1103     }
1104     bytes4 retval = ERC1363Spender(_spender).onApprovalReceived(
1105       msg.sender, _value, _data
1106     );
1107     return (retval == ERC1363_APPROVED);
1108   }
1109 }
1110 
1111 // File: eth-token-recover/contracts/TokenRecover.sol
1112 
1113 /**
1114  * @title TokenRecover
1115  * @author Vittorio Minacori (https://github.com/vittominacori)
1116  * @dev Allow to recover any ERC20 sent into the contract for error
1117  */
1118 contract TokenRecover is Ownable {
1119 
1120   /**
1121    * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
1122    * @param _tokenAddress address The token contract address
1123    * @param _tokens Number of tokens to be sent
1124    * @return bool
1125    */
1126   function recoverERC20(
1127     address _tokenAddress,
1128     uint256 _tokens
1129   )
1130   public
1131   onlyOwner
1132   returns (bool success)
1133   {
1134     return ERC20Basic(_tokenAddress).transfer(owner, _tokens);
1135   }
1136 }
1137 
1138 // File: contracts/token/base/BaseToken.sol
1139 
1140 /**
1141  * @title BaseToken
1142  * @author Vittorio Minacori (https://github.com/vittominacori)
1143  * @dev BaseToken is An ERC20 token with a lot of stuffs used as Base for any other token contract.
1144  *  It is DetailedERC20, RBACMintableToken, BurnableToken, ERC1363BasicToken.
1145  */
1146 contract BaseToken is DetailedERC20, CappedToken, RBACMintableToken, BurnableToken, ERC1363BasicToken, TokenRecover { // solium-disable-line max-len
1147 
1148   constructor(
1149     string _name,
1150     string _symbol,
1151     uint8 _decimals,
1152     uint256 _cap
1153   )
1154   DetailedERC20(_name, _symbol, _decimals)
1155   CappedToken(_cap)
1156   public
1157   {}
1158 }
1159 
1160 // File: contracts/token/GastroAdvisorToken.sol
1161 
1162 /**
1163  * @title GastroAdvisorToken
1164  * @author Vittorio Minacori (https://github.com/vittominacori)
1165  * @dev GastroAdvisorToken is an ERC20 token with a lot of stuffs. Extends from BaseToken
1166  */
1167 contract GastroAdvisorToken is BaseToken {
1168 
1169   uint256 public lockedUntil;
1170   mapping(address => uint256) lockedBalances;
1171   string constant ROLE_OPERATOR = "operator";
1172 
1173   /**
1174    * @dev Tokens can be moved only after minting finished or if you are an approved operator.
1175    *  Some tokens can be locked until a date. Nobody can move locked tokens before of this date.
1176    */
1177   modifier canTransfer(address _from, uint256 _value) {
1178     require(mintingFinished || hasRole(_from, ROLE_OPERATOR));
1179     require(_value <= balances[_from].sub(lockedBalanceOf(_from)));
1180     _;
1181   }
1182 
1183   constructor(
1184     string _name,
1185     string _symbol,
1186     uint8 _decimals,
1187     uint256 _cap,
1188     uint256 _lockedUntil
1189   )
1190   BaseToken(_name, _symbol, _decimals, _cap)
1191   public
1192   {
1193     lockedUntil = _lockedUntil;
1194     addMinter(owner);
1195     addOperator(owner);
1196   }
1197 
1198   function transfer(
1199     address _to,
1200     uint256 _value
1201   )
1202   public
1203   canTransfer(msg.sender, _value)
1204   returns (bool)
1205   {
1206     return super.transfer(_to, _value);
1207   }
1208 
1209   function transferFrom(
1210     address _from,
1211     address _to,
1212     uint256 _value
1213   )
1214   public
1215   canTransfer(_from, _value)
1216   returns (bool)
1217   {
1218     return super.transferFrom(_from, _to, _value);
1219   }
1220 
1221   /**
1222    * @dev Gets the locked balance of the specified address.
1223    * @param _who The address to query the balance of.
1224    * @return An uint256 representing the locked amount owned by the passed address.
1225    */
1226   function lockedBalanceOf(address _who) public view returns (uint256) {
1227     // solium-disable-next-line security/no-block-members
1228     return block.timestamp <= lockedUntil ? lockedBalances[_who] : 0;
1229   }
1230 
1231   /**
1232    * @dev Function to mint and lock tokens
1233    * @param _to The address that will receive the minted tokens.
1234    * @param _amount The amount of tokens to mint.
1235    * @return A boolean that indicates if the operation was successful.
1236    */
1237   function mintAndLock(
1238     address _to,
1239     uint256 _amount
1240   )
1241   public
1242   hasMintPermission
1243   canMint
1244   returns (bool)
1245   {
1246     lockedBalances[_to] = lockedBalances[_to].add(_amount);
1247     return super.mint(_to, _amount);
1248   }
1249 
1250   /**
1251    * @dev add a operator role to an address
1252    * @param _operator address
1253    */
1254   function addOperator(address _operator) public onlyOwner {
1255     require(!mintingFinished);
1256     addRole(_operator, ROLE_OPERATOR);
1257   }
1258 
1259   /**
1260    * @dev add a operator role to an array of addresses
1261    * @param _operators address[]
1262    */
1263   function addOperators(address[] _operators) public onlyOwner {
1264     require(!mintingFinished);
1265     require(_operators.length > 0);
1266     for (uint i = 0; i < _operators.length; i++) {
1267       addRole(_operators[i], ROLE_OPERATOR);
1268     }
1269   }
1270 
1271   /**
1272    * @dev remove a operator role from an address
1273    * @param _operator address
1274    */
1275   function removeOperator(address _operator) public onlyOwner {
1276     removeRole(_operator, ROLE_OPERATOR);
1277   }
1278 
1279   /**
1280    * @dev add a minter role to an array of addresses
1281    * @param _minters address[]
1282    */
1283   function addMinters(address[] _minters) public onlyOwner {
1284     require(_minters.length > 0);
1285     for (uint i = 0; i < _minters.length; i++) {
1286       addRole(_minters[i], ROLE_MINTER);
1287     }
1288   }
1289 }