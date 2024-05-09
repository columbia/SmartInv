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
625 // File: openzeppelin-solidity/contracts/AddressUtils.sol
626 
627 /**
628  * Utility library of inline functions on addresses
629  */
630 library AddressUtils {
631 
632   /**
633    * Returns whether the target address is a contract
634    * @dev This function will return false if invoked during the constructor of a contract,
635    * as the code is not actually created until after the constructor finishes.
636    * @param _addr address to check
637    * @return whether the target address is a contract
638    */
639   function isContract(address _addr) internal view returns (bool) {
640     uint256 size;
641     // XXX Currently there is no better way to check if there is a contract in an address
642     // than to check the size of the code at that address.
643     // See https://ethereum.stackexchange.com/a/14016/36603
644     // for more details about how this works.
645     // TODO Check this again before the Serenity release, because all addresses will be
646     // contracts then.
647     // solium-disable-next-line security/no-inline-assembly
648     assembly { size := extcodesize(_addr) }
649     return size > 0;
650   }
651 
652 }
653 
654 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
655 
656 /**
657  * @title ERC165
658  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
659  */
660 interface ERC165 {
661 
662   /**
663    * @notice Query if a contract implements an interface
664    * @param _interfaceId The interface identifier, as specified in ERC-165
665    * @dev Interface identification is specified in ERC-165. This function
666    * uses less than 30,000 gas.
667    */
668   function supportsInterface(bytes4 _interfaceId)
669     external
670     view
671     returns (bool);
672 }
673 
674 // File: openzeppelin-solidity/contracts/introspection/SupportsInterfaceWithLookup.sol
675 
676 /**
677  * @title SupportsInterfaceWithLookup
678  * @author Matt Condon (@shrugs)
679  * @dev Implements ERC165 using a lookup table.
680  */
681 contract SupportsInterfaceWithLookup is ERC165 {
682 
683   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
684   /**
685    * 0x01ffc9a7 ===
686    *   bytes4(keccak256('supportsInterface(bytes4)'))
687    */
688 
689   /**
690    * @dev a mapping of interface id to whether or not it's supported
691    */
692   mapping(bytes4 => bool) internal supportedInterfaces;
693 
694   /**
695    * @dev A contract implementing SupportsInterfaceWithLookup
696    * implement ERC165 itself
697    */
698   constructor()
699     public
700   {
701     _registerInterface(InterfaceId_ERC165);
702   }
703 
704   /**
705    * @dev implement supportsInterface(bytes4) using a lookup table
706    */
707   function supportsInterface(bytes4 _interfaceId)
708     external
709     view
710     returns (bool)
711   {
712     return supportedInterfaces[_interfaceId];
713   }
714 
715   /**
716    * @dev private method for registering an interface
717    */
718   function _registerInterface(bytes4 _interfaceId)
719     internal
720   {
721     require(_interfaceId != 0xffffffff);
722     supportedInterfaces[_interfaceId] = true;
723   }
724 }
725 
726 // File: erc-payable-token/contracts/token/ERC1363/ERC1363.sol
727 
728 /**
729  * @title ERC1363 interface
730  * @author Vittorio Minacori (https://github.com/vittominacori)
731  * @dev Interface for a Payable Token contract as defined in
732  *  https://github.com/ethereum/EIPs/issues/1363
733  */
734 contract ERC1363 is ERC20, ERC165 {
735   /*
736    * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
737    * 0x4bbee2df ===
738    *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
739    *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
740    *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
741    *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
742    */
743 
744   /*
745    * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
746    * 0xfb9ec8ce ===
747    *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
748    *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
749    */
750 
751   /**
752    * @notice Transfer tokens from `msg.sender` to another address
753    *  and then call `onTransferReceived` on receiver
754    * @param _to address The address which you want to transfer to
755    * @param _value uint256 The amount of tokens to be transferred
756    * @return true unless throwing
757    */
758   function transferAndCall(address _to, uint256 _value) public returns (bool);
759 
760   /**
761    * @notice Transfer tokens from `msg.sender` to another address
762    *  and then call `onTransferReceived` on receiver
763    * @param _to address The address which you want to transfer to
764    * @param _value uint256 The amount of tokens to be transferred
765    * @param _data bytes Additional data with no specified format, sent in call to `_to`
766    * @return true unless throwing
767    */
768   function transferAndCall(address _to, uint256 _value, bytes _data) public returns (bool); // solium-disable-line max-len
769 
770   /**
771    * @notice Transfer tokens from one address to another
772    *  and then call `onTransferReceived` on receiver
773    * @param _from address The address which you want to send tokens from
774    * @param _to address The address which you want to transfer to
775    * @param _value uint256 The amount of tokens to be transferred
776    * @return true unless throwing
777    */
778   function transferFromAndCall(address _from, address _to, uint256 _value) public returns (bool); // solium-disable-line max-len
779 
780 
781   /**
782    * @notice Transfer tokens from one address to another
783    *  and then call `onTransferReceived` on receiver
784    * @param _from address The address which you want to send tokens from
785    * @param _to address The address which you want to transfer to
786    * @param _value uint256 The amount of tokens to be transferred
787    * @param _data bytes Additional data with no specified format, sent in call to `_to`
788    * @return true unless throwing
789    */
790   function transferFromAndCall(address _from, address _to, uint256 _value, bytes _data) public returns (bool); // solium-disable-line max-len, arg-overflow
791 
792   /**
793    * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
794    *  and then call `onApprovalReceived` on spender
795    *  Beware that changing an allowance with this method brings the risk that someone may use both the old
796    *  and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
797    *  race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
798    *  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
799    * @param _spender address The address which will spend the funds
800    * @param _value uint256 The amount of tokens to be spent
801    */
802   function approveAndCall(address _spender, uint256 _value) public returns (bool); // solium-disable-line max-len
803 
804   /**
805    * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
806    *  and then call `onApprovalReceived` on spender
807    *  Beware that changing an allowance with this method brings the risk that someone may use both the old
808    *  and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
809    *  race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
810    *  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
811    * @param _spender address The address which will spend the funds
812    * @param _value uint256 The amount of tokens to be spent
813    * @param _data bytes Additional data with no specified format, sent in call to `_spender`
814    */
815   function approveAndCall(address _spender, uint256 _value, bytes _data) public returns (bool); // solium-disable-line max-len
816 }
817 
818 // File: erc-payable-token/contracts/token/ERC1363/ERC1363Receiver.sol
819 
820 /**
821  * @title ERC1363Receiver interface
822  * @author Vittorio Minacori (https://github.com/vittominacori)
823  * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
824  *  from ERC1363 token contracts as defined in
825  *  https://github.com/ethereum/EIPs/issues/1363
826  */
827 contract ERC1363Receiver {
828   /*
829    * Note: the ERC-165 identifier for this interface is 0x88a7ca5c.
830    * 0x88a7ca5c === bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))
831    */
832 
833   /**
834    * @notice Handle the receipt of ERC1363 tokens
835    * @dev Any ERC1363 smart contract calls this function on the recipient
836    *  after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
837    *  transfer. Return of other than the magic value MUST result in the
838    *  transaction being reverted.
839    *  Note: the token contract address is always the message sender.
840    * @param _operator address The address which called `transferAndCall` or `transferFromAndCall` function
841    * @param _from address The address which are token transferred from
842    * @param _value uint256 The amount of tokens transferred
843    * @param _data bytes Additional data with no specified format
844    * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
845    *  unless throwing
846    */
847   function onTransferReceived(address _operator, address _from, uint256 _value, bytes _data) external returns (bytes4); // solium-disable-line max-len, arg-overflow
848 }
849 
850 // File: erc-payable-token/contracts/token/ERC1363/ERC1363Spender.sol
851 
852 /**
853  * @title ERC1363Spender interface
854  * @author Vittorio Minacori (https://github.com/vittominacori)
855  * @dev Interface for any contract that wants to support approveAndCall
856  *  from ERC1363 token contracts as defined in
857  *  https://github.com/ethereum/EIPs/issues/1363
858  */
859 contract ERC1363Spender {
860   /*
861    * Note: the ERC-165 identifier for this interface is 0x7b04a2d0.
862    * 0x7b04a2d0 === bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))
863    */
864 
865   /**
866    * @notice Handle the approval of ERC1363 tokens
867    * @dev Any ERC1363 smart contract calls this function on the recipient
868    *  after an `approve`. This function MAY throw to revert and reject the
869    *  approval. Return of other than the magic value MUST result in the
870    *  transaction being reverted.
871    *  Note: the token contract address is always the message sender.
872    * @param _owner address The address which called `approveAndCall` function
873    * @param _value uint256 The amount of tokens to be spent
874    * @param _data bytes Additional data with no specified format
875    * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
876    *  unless throwing
877    */
878   function onApprovalReceived(address _owner, uint256 _value, bytes _data) external returns (bytes4); // solium-disable-line max-len
879 }
880 
881 // File: erc-payable-token/contracts/token/ERC1363/ERC1363BasicToken.sol
882 
883 // solium-disable-next-line max-len
884 
885 
886 
887 
888 
889 
890 
891 /**
892  * @title ERC1363BasicToken
893  * @author Vittorio Minacori (https://github.com/vittominacori)
894  * @dev Implementation of an ERC1363 interface
895  */
896 contract ERC1363BasicToken is SupportsInterfaceWithLookup, StandardToken, ERC1363 { // solium-disable-line max-len
897   using AddressUtils for address;
898 
899   /*
900    * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
901    * 0x4bbee2df ===
902    *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
903    *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
904    *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
905    *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
906    */
907   bytes4 internal constant InterfaceId_ERC1363Transfer = 0x4bbee2df;
908 
909   /*
910    * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
911    * 0xfb9ec8ce ===
912    *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
913    *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
914    */
915   bytes4 internal constant InterfaceId_ERC1363Approve = 0xfb9ec8ce;
916 
917   // Equals to `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
918   // which can be also obtained as `ERC1363Receiver(0).onTransferReceived.selector`
919   bytes4 private constant ERC1363_RECEIVED = 0x88a7ca5c;
920 
921   // Equals to `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
922   // which can be also obtained as `ERC1363Spender(0).onApprovalReceived.selector`
923   bytes4 private constant ERC1363_APPROVED = 0x7b04a2d0;
924 
925   constructor() public {
926     // register the supported interfaces to conform to ERC1363 via ERC165
927     _registerInterface(InterfaceId_ERC1363Transfer);
928     _registerInterface(InterfaceId_ERC1363Approve);
929   }
930 
931   function transferAndCall(
932     address _to,
933     uint256 _value
934   )
935     public
936     returns (bool)
937   {
938     return transferAndCall(_to, _value, "");
939   }
940 
941   function transferAndCall(
942     address _to,
943     uint256 _value,
944     bytes _data
945   )
946     public
947     returns (bool)
948   {
949     require(transfer(_to, _value));
950     require(
951       checkAndCallTransfer(
952         msg.sender,
953         _to,
954         _value,
955         _data
956       )
957     );
958     return true;
959   }
960 
961   function transferFromAndCall(
962     address _from,
963     address _to,
964     uint256 _value
965   )
966     public
967     returns (bool)
968   {
969     // solium-disable-next-line arg-overflow
970     return transferFromAndCall(_from, _to, _value, "");
971   }
972 
973   function transferFromAndCall(
974     address _from,
975     address _to,
976     uint256 _value,
977     bytes _data
978   )
979     public
980     returns (bool)
981   {
982     require(transferFrom(_from, _to, _value));
983     require(
984       checkAndCallTransfer(
985         _from,
986         _to,
987         _value,
988         _data
989       )
990     );
991     return true;
992   }
993 
994   function approveAndCall(
995     address _spender,
996     uint256 _value
997   )
998     public
999     returns (bool)
1000   {
1001     return approveAndCall(_spender, _value, "");
1002   }
1003 
1004   function approveAndCall(
1005     address _spender,
1006     uint256 _value,
1007     bytes _data
1008   )
1009     public
1010     returns (bool)
1011   {
1012     approve(_spender, _value);
1013     require(
1014       checkAndCallApprove(
1015         _spender,
1016         _value,
1017         _data
1018       )
1019     );
1020     return true;
1021   }
1022 
1023   /**
1024    * @dev Internal function to invoke `onTransferReceived` on a target address
1025    *  The call is not executed if the target address is not a contract
1026    * @param _from address Representing the previous owner of the given token value
1027    * @param _to address Target address that will receive the tokens
1028    * @param _value uint256 The amount mount of tokens to be transferred
1029    * @param _data bytes Optional data to send along with the call
1030    * @return whether the call correctly returned the expected magic value
1031    */
1032   function checkAndCallTransfer(
1033     address _from,
1034     address _to,
1035     uint256 _value,
1036     bytes _data
1037   )
1038     internal
1039     returns (bool)
1040   {
1041     if (!_to.isContract()) {
1042       return false;
1043     }
1044     bytes4 retval = ERC1363Receiver(_to).onTransferReceived(
1045       msg.sender, _from, _value, _data
1046     );
1047     return (retval == ERC1363_RECEIVED);
1048   }
1049 
1050   /**
1051    * @dev Internal function to invoke `onApprovalReceived` on a target address
1052    *  The call is not executed if the target address is not a contract
1053    * @param _spender address The address which will spend the funds
1054    * @param _value uint256 The amount of tokens to be spent
1055    * @param _data bytes Optional data to send along with the call
1056    * @return whether the call correctly returned the expected magic value
1057    */
1058   function checkAndCallApprove(
1059     address _spender,
1060     uint256 _value,
1061     bytes _data
1062   )
1063     internal
1064     returns (bool)
1065   {
1066     if (!_spender.isContract()) {
1067       return false;
1068     }
1069     bytes4 retval = ERC1363Spender(_spender).onApprovalReceived(
1070       msg.sender, _value, _data
1071     );
1072     return (retval == ERC1363_APPROVED);
1073   }
1074 }
1075 
1076 // File: eth-token-recover/contracts/TokenRecover.sol
1077 
1078 /**
1079  * @title TokenRecover
1080  * @author Vittorio Minacori (https://github.com/vittominacori)
1081  * @dev Allow to recover any ERC20 sent into the contract for error
1082  */
1083 contract TokenRecover is Ownable {
1084 
1085   /**
1086    * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
1087    * @param _tokenAddress address The token contract address
1088    * @param _tokens Number of tokens to be sent
1089    * @return bool
1090    */
1091   function recoverERC20(
1092     address _tokenAddress,
1093     uint256 _tokens
1094   )
1095   public
1096   onlyOwner
1097   returns (bool success)
1098   {
1099     return ERC20Basic(_tokenAddress).transfer(owner, _tokens);
1100   }
1101 }
1102 
1103 // File: contracts/token/FidelityHouseToken.sol
1104 
1105 // solium-disable-next-line max-len
1106 contract FidelityHouseToken is DetailedERC20, RBACMintableToken, BurnableToken, ERC1363BasicToken, TokenRecover {
1107 
1108   uint256 public lockedUntil;
1109   mapping(address => uint256) internal lockedBalances;
1110 
1111   modifier canTransfer(address _from, uint256 _value) {
1112     require(
1113       mintingFinished,
1114       "Minting should be finished before transfer."
1115     );
1116     require(
1117       _value <= balances[_from].sub(lockedBalanceOf(_from)),
1118       "Can't transfer more than unlocked tokens"
1119     );
1120     _;
1121   }
1122 
1123   constructor(uint256 _lockedUntil)
1124     DetailedERC20("FidelityHouse Token", "FIH", 18)
1125     public
1126   {
1127     lockedUntil = _lockedUntil;
1128   }
1129 
1130   /**
1131    * @dev Gets the locked balance of the specified address.
1132    * @param _owner The address to query the balance of.
1133    * @return An uint256 representing the locked amount owned by the passed address.
1134    */
1135   function lockedBalanceOf(address _owner) public view returns (uint256) {
1136     // solium-disable-next-line security/no-block-members
1137     return block.timestamp <= lockedUntil ? lockedBalances[_owner] : 0;
1138   }
1139 
1140   /**
1141    * @dev Function to mint and lock tokens
1142    * @param _to The address that will receive the minted tokens.
1143    * @param _amount The amount of tokens to mint.
1144    * @return A boolean that indicates if the operation was successful.
1145    */
1146   function mintAndLock(
1147     address _to,
1148     uint256 _amount
1149   )
1150     public
1151     hasMintPermission
1152     canMint
1153     returns (bool)
1154   {
1155     lockedBalances[_to] = lockedBalances[_to].add(_amount);
1156     return super.mint(_to, _amount);
1157   }
1158 
1159   function transfer(
1160     address _to,
1161     uint256 _value
1162   )
1163     public
1164     canTransfer(msg.sender, _value)
1165     returns (bool)
1166   {
1167     return super.transfer(_to, _value);
1168   }
1169 
1170   function transferFrom(
1171     address _from,
1172     address _to,
1173     uint256 _value
1174   )
1175     public
1176     canTransfer(_from, _value)
1177     returns (bool)
1178   {
1179     return super.transferFrom(_from, _to, _value);
1180   }
1181 }