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
69 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
70 
71 /**
72  * @title Ownable
73  * @dev The Ownable contract has an owner address, and provides basic authorization control
74  * functions, this simplifies the implementation of "user permissions".
75  */
76 contract Ownable {
77   address public owner;
78 
79 
80   event OwnershipRenounced(address indexed previousOwner);
81   event OwnershipTransferred(
82     address indexed previousOwner,
83     address indexed newOwner
84   );
85 
86 
87   /**
88    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
89    * account.
90    */
91   constructor() public {
92     owner = msg.sender;
93   }
94 
95   /**
96    * @dev Throws if called by any account other than the owner.
97    */
98   modifier onlyOwner() {
99     require(msg.sender == owner);
100     _;
101   }
102 
103   /**
104    * @dev Allows the current owner to relinquish control of the contract.
105    * @notice Renouncing to ownership will leave the contract without an owner.
106    * It will not be possible to call the functions with the `onlyOwner`
107    * modifier anymore.
108    */
109   function renounceOwnership() public onlyOwner {
110     emit OwnershipRenounced(owner);
111     owner = address(0);
112   }
113 
114   /**
115    * @dev Allows the current owner to transfer control of the contract to a newOwner.
116    * @param _newOwner The address to transfer ownership to.
117    */
118   function transferOwnership(address _newOwner) public onlyOwner {
119     _transferOwnership(_newOwner);
120   }
121 
122   /**
123    * @dev Transfers control of the contract to a newOwner.
124    * @param _newOwner The address to transfer ownership to.
125    */
126   function _transferOwnership(address _newOwner) internal {
127     require(_newOwner != address(0));
128     emit OwnershipTransferred(owner, _newOwner);
129     owner = _newOwner;
130   }
131 }
132 
133 // File: eth-token-recover/contracts/TokenRecover.sol
134 
135 /**
136  * @title TokenRecover
137  * @author Vittorio Minacori (https://github.com/vittominacori)
138  * @dev Allow to recover any ERC20 sent into the contract for error
139  */
140 contract TokenRecover is Ownable {
141 
142   /**
143    * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
144    * @param _tokenAddress address The token contract address
145    * @param _tokens Number of tokens to be sent
146    * @return bool
147    */
148   function recoverERC20(
149     address _tokenAddress,
150     uint256 _tokens
151   )
152   public
153   onlyOwner
154   returns (bool success)
155   {
156     return ERC20Basic(_tokenAddress).transfer(owner, _tokens);
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
181 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
182 
183 /**
184  * @title DetailedERC20 token
185  * @dev The decimals are only for visualization purposes.
186  * All the operations are done using the smallest and indivisible token unit,
187  * just as on Ethereum all the operations are done in wei.
188  */
189 contract DetailedERC20 is ERC20 {
190   string public name;
191   string public symbol;
192   uint8 public decimals;
193 
194   constructor(string _name, string _symbol, uint8 _decimals) public {
195     name = _name;
196     symbol = _symbol;
197     decimals = _decimals;
198   }
199 }
200 
201 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
202 
203 /**
204  * @title Basic token
205  * @dev Basic version of StandardToken, with no allowances.
206  */
207 contract BasicToken is ERC20Basic {
208   using SafeMath for uint256;
209 
210   mapping(address => uint256) internal balances;
211 
212   uint256 internal totalSupply_;
213 
214   /**
215   * @dev Total number of tokens in existence
216   */
217   function totalSupply() public view returns (uint256) {
218     return totalSupply_;
219   }
220 
221   /**
222   * @dev Transfer token for a specified address
223   * @param _to The address to transfer to.
224   * @param _value The amount to be transferred.
225   */
226   function transfer(address _to, uint256 _value) public returns (bool) {
227     require(_value <= balances[msg.sender]);
228     require(_to != address(0));
229 
230     balances[msg.sender] = balances[msg.sender].sub(_value);
231     balances[_to] = balances[_to].add(_value);
232     emit Transfer(msg.sender, _to, _value);
233     return true;
234   }
235 
236   /**
237   * @dev Gets the balance of the specified address.
238   * @param _owner The address to query the the balance of.
239   * @return An uint256 representing the amount owned by the passed address.
240   */
241   function balanceOf(address _owner) public view returns (uint256) {
242     return balances[_owner];
243   }
244 
245 }
246 
247 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
248 
249 /**
250  * @title Standard ERC20 token
251  *
252  * @dev Implementation of the basic standard token.
253  * https://github.com/ethereum/EIPs/issues/20
254  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
255  */
256 contract StandardToken is ERC20, BasicToken {
257 
258   mapping (address => mapping (address => uint256)) internal allowed;
259 
260 
261   /**
262    * @dev Transfer tokens from one address to another
263    * @param _from address The address which you want to send tokens from
264    * @param _to address The address which you want to transfer to
265    * @param _value uint256 the amount of tokens to be transferred
266    */
267   function transferFrom(
268     address _from,
269     address _to,
270     uint256 _value
271   )
272     public
273     returns (bool)
274   {
275     require(_value <= balances[_from]);
276     require(_value <= allowed[_from][msg.sender]);
277     require(_to != address(0));
278 
279     balances[_from] = balances[_from].sub(_value);
280     balances[_to] = balances[_to].add(_value);
281     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
282     emit Transfer(_from, _to, _value);
283     return true;
284   }
285 
286   /**
287    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
288    * Beware that changing an allowance with this method brings the risk that someone may use both the old
289    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
290    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
291    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
292    * @param _spender The address which will spend the funds.
293    * @param _value The amount of tokens to be spent.
294    */
295   function approve(address _spender, uint256 _value) public returns (bool) {
296     allowed[msg.sender][_spender] = _value;
297     emit Approval(msg.sender, _spender, _value);
298     return true;
299   }
300 
301   /**
302    * @dev Function to check the amount of tokens that an owner allowed to a spender.
303    * @param _owner address The address which owns the funds.
304    * @param _spender address The address which will spend the funds.
305    * @return A uint256 specifying the amount of tokens still available for the spender.
306    */
307   function allowance(
308     address _owner,
309     address _spender
310    )
311     public
312     view
313     returns (uint256)
314   {
315     return allowed[_owner][_spender];
316   }
317 
318   /**
319    * @dev Increase the amount of tokens that an owner allowed to a spender.
320    * approve should be called when allowed[_spender] == 0. To increment
321    * allowed value is better to use this function to avoid 2 calls (and wait until
322    * the first transaction is mined)
323    * From MonolithDAO Token.sol
324    * @param _spender The address which will spend the funds.
325    * @param _addedValue The amount of tokens to increase the allowance by.
326    */
327   function increaseApproval(
328     address _spender,
329     uint256 _addedValue
330   )
331     public
332     returns (bool)
333   {
334     allowed[msg.sender][_spender] = (
335       allowed[msg.sender][_spender].add(_addedValue));
336     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
337     return true;
338   }
339 
340   /**
341    * @dev Decrease the amount of tokens that an owner allowed to a spender.
342    * approve should be called when allowed[_spender] == 0. To decrement
343    * allowed value is better to use this function to avoid 2 calls (and wait until
344    * the first transaction is mined)
345    * From MonolithDAO Token.sol
346    * @param _spender The address which will spend the funds.
347    * @param _subtractedValue The amount of tokens to decrease the allowance by.
348    */
349   function decreaseApproval(
350     address _spender,
351     uint256 _subtractedValue
352   )
353     public
354     returns (bool)
355   {
356     uint256 oldValue = allowed[msg.sender][_spender];
357     if (_subtractedValue >= oldValue) {
358       allowed[msg.sender][_spender] = 0;
359     } else {
360       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
361     }
362     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
363     return true;
364   }
365 
366 }
367 
368 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
369 
370 /**
371  * @title Mintable token
372  * @dev Simple ERC20 Token example, with mintable token creation
373  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
374  */
375 contract MintableToken is StandardToken, Ownable {
376   event Mint(address indexed to, uint256 amount);
377   event MintFinished();
378 
379   bool public mintingFinished = false;
380 
381 
382   modifier canMint() {
383     require(!mintingFinished);
384     _;
385   }
386 
387   modifier hasMintPermission() {
388     require(msg.sender == owner);
389     _;
390   }
391 
392   /**
393    * @dev Function to mint tokens
394    * @param _to The address that will receive the minted tokens.
395    * @param _amount The amount of tokens to mint.
396    * @return A boolean that indicates if the operation was successful.
397    */
398   function mint(
399     address _to,
400     uint256 _amount
401   )
402     public
403     hasMintPermission
404     canMint
405     returns (bool)
406   {
407     totalSupply_ = totalSupply_.add(_amount);
408     balances[_to] = balances[_to].add(_amount);
409     emit Mint(_to, _amount);
410     emit Transfer(address(0), _to, _amount);
411     return true;
412   }
413 
414   /**
415    * @dev Function to stop minting new tokens.
416    * @return True if the operation was successful.
417    */
418   function finishMinting() public onlyOwner canMint returns (bool) {
419     mintingFinished = true;
420     emit MintFinished();
421     return true;
422   }
423 }
424 
425 // File: openzeppelin-solidity/contracts/access/rbac/Roles.sol
426 
427 /**
428  * @title Roles
429  * @author Francisco Giordano (@frangio)
430  * @dev Library for managing addresses assigned to a Role.
431  * See RBAC.sol for example usage.
432  */
433 library Roles {
434   struct Role {
435     mapping (address => bool) bearer;
436   }
437 
438   /**
439    * @dev give an address access to this role
440    */
441   function add(Role storage _role, address _addr)
442     internal
443   {
444     _role.bearer[_addr] = true;
445   }
446 
447   /**
448    * @dev remove an address' access to this role
449    */
450   function remove(Role storage _role, address _addr)
451     internal
452   {
453     _role.bearer[_addr] = false;
454   }
455 
456   /**
457    * @dev check if an address has this role
458    * // reverts
459    */
460   function check(Role storage _role, address _addr)
461     internal
462     view
463   {
464     require(has(_role, _addr));
465   }
466 
467   /**
468    * @dev check if an address has this role
469    * @return bool
470    */
471   function has(Role storage _role, address _addr)
472     internal
473     view
474     returns (bool)
475   {
476     return _role.bearer[_addr];
477   }
478 }
479 
480 // File: openzeppelin-solidity/contracts/access/rbac/RBAC.sol
481 
482 /**
483  * @title RBAC (Role-Based Access Control)
484  * @author Matt Condon (@Shrugs)
485  * @dev Stores and provides setters and getters for roles and addresses.
486  * Supports unlimited numbers of roles and addresses.
487  * See //contracts/mocks/RBACMock.sol for an example of usage.
488  * This RBAC method uses strings to key roles. It may be beneficial
489  * for you to write your own implementation of this interface using Enums or similar.
490  */
491 contract RBAC {
492   using Roles for Roles.Role;
493 
494   mapping (string => Roles.Role) private roles;
495 
496   event RoleAdded(address indexed operator, string role);
497   event RoleRemoved(address indexed operator, string role);
498 
499   /**
500    * @dev reverts if addr does not have role
501    * @param _operator address
502    * @param _role the name of the role
503    * // reverts
504    */
505   function checkRole(address _operator, string _role)
506     public
507     view
508   {
509     roles[_role].check(_operator);
510   }
511 
512   /**
513    * @dev determine if addr has role
514    * @param _operator address
515    * @param _role the name of the role
516    * @return bool
517    */
518   function hasRole(address _operator, string _role)
519     public
520     view
521     returns (bool)
522   {
523     return roles[_role].has(_operator);
524   }
525 
526   /**
527    * @dev add a role to an address
528    * @param _operator address
529    * @param _role the name of the role
530    */
531   function addRole(address _operator, string _role)
532     internal
533   {
534     roles[_role].add(_operator);
535     emit RoleAdded(_operator, _role);
536   }
537 
538   /**
539    * @dev remove a role from an address
540    * @param _operator address
541    * @param _role the name of the role
542    */
543   function removeRole(address _operator, string _role)
544     internal
545   {
546     roles[_role].remove(_operator);
547     emit RoleRemoved(_operator, _role);
548   }
549 
550   /**
551    * @dev modifier to scope access to a single role (uses msg.sender as addr)
552    * @param _role the name of the role
553    * // reverts
554    */
555   modifier onlyRole(string _role)
556   {
557     checkRole(msg.sender, _role);
558     _;
559   }
560 
561   /**
562    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
563    * @param _roles the names of the roles to scope access to
564    * // reverts
565    *
566    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
567    *  see: https://github.com/ethereum/solidity/issues/2467
568    */
569   // modifier onlyRoles(string[] _roles) {
570   //     bool hasAnyRole = false;
571   //     for (uint8 i = 0; i < _roles.length; i++) {
572   //         if (hasRole(msg.sender, _roles[i])) {
573   //             hasAnyRole = true;
574   //             break;
575   //         }
576   //     }
577 
578   //     require(hasAnyRole);
579 
580   //     _;
581   // }
582 }
583 
584 // File: openzeppelin-solidity/contracts/token/ERC20/RBACMintableToken.sol
585 
586 /**
587  * @title RBACMintableToken
588  * @author Vittorio Minacori (@vittominacori)
589  * @dev Mintable Token, with RBAC minter permissions
590  */
591 contract RBACMintableToken is MintableToken, RBAC {
592   /**
593    * A constant role name for indicating minters.
594    */
595   string public constant ROLE_MINTER = "minter";
596 
597   /**
598    * @dev override the Mintable token modifier to add role based logic
599    */
600   modifier hasMintPermission() {
601     checkRole(msg.sender, ROLE_MINTER);
602     _;
603   }
604 
605   /**
606    * @dev add a minter role to an address
607    * @param _minter address
608    */
609   function addMinter(address _minter) public onlyOwner {
610     addRole(_minter, ROLE_MINTER);
611   }
612 
613   /**
614    * @dev remove a minter role from an address
615    * @param _minter address
616    */
617   function removeMinter(address _minter) public onlyOwner {
618     removeRole(_minter, ROLE_MINTER);
619   }
620 }
621 
622 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
623 
624 /**
625  * @title Burnable Token
626  * @dev Token that can be irreversibly burned (destroyed).
627  */
628 contract BurnableToken is BasicToken {
629 
630   event Burn(address indexed burner, uint256 value);
631 
632   /**
633    * @dev Burns a specific amount of tokens.
634    * @param _value The amount of token to be burned.
635    */
636   function burn(uint256 _value) public {
637     _burn(msg.sender, _value);
638   }
639 
640   function _burn(address _who, uint256 _value) internal {
641     require(_value <= balances[_who]);
642     // no need to require value <= totalSupply, since that would imply the
643     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
644 
645     balances[_who] = balances[_who].sub(_value);
646     totalSupply_ = totalSupply_.sub(_value);
647     emit Burn(_who, _value);
648     emit Transfer(_who, address(0), _value);
649   }
650 }
651 
652 // File: openzeppelin-solidity/contracts/token/ERC20/CappedToken.sol
653 
654 /**
655  * @title Capped token
656  * @dev Mintable token with a token cap.
657  */
658 contract CappedToken is MintableToken {
659 
660   uint256 public cap;
661 
662   constructor(uint256 _cap) public {
663     require(_cap > 0);
664     cap = _cap;
665   }
666 
667   /**
668    * @dev Function to mint tokens
669    * @param _to The address that will receive the minted tokens.
670    * @param _amount The amount of tokens to mint.
671    * @return A boolean that indicates if the operation was successful.
672    */
673   function mint(
674     address _to,
675     uint256 _amount
676   )
677     public
678     returns (bool)
679   {
680     require(totalSupply_.add(_amount) <= cap);
681 
682     return super.mint(_to, _amount);
683   }
684 
685 }
686 
687 // File: openzeppelin-solidity/contracts/AddressUtils.sol
688 
689 /**
690  * Utility library of inline functions on addresses
691  */
692 library AddressUtils {
693 
694   /**
695    * Returns whether the target address is a contract
696    * @dev This function will return false if invoked during the constructor of a contract,
697    * as the code is not actually created until after the constructor finishes.
698    * @param _addr address to check
699    * @return whether the target address is a contract
700    */
701   function isContract(address _addr) internal view returns (bool) {
702     uint256 size;
703     // XXX Currently there is no better way to check if there is a contract in an address
704     // than to check the size of the code at that address.
705     // See https://ethereum.stackexchange.com/a/14016/36603
706     // for more details about how this works.
707     // TODO Check this again before the Serenity release, because all addresses will be
708     // contracts then.
709     // solium-disable-next-line security/no-inline-assembly
710     assembly { size := extcodesize(_addr) }
711     return size > 0;
712   }
713 
714 }
715 
716 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
717 
718 /**
719  * @title ERC165
720  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
721  */
722 interface ERC165 {
723 
724   /**
725    * @notice Query if a contract implements an interface
726    * @param _interfaceId The interface identifier, as specified in ERC-165
727    * @dev Interface identification is specified in ERC-165. This function
728    * uses less than 30,000 gas.
729    */
730   function supportsInterface(bytes4 _interfaceId)
731     external
732     view
733     returns (bool);
734 }
735 
736 // File: openzeppelin-solidity/contracts/introspection/SupportsInterfaceWithLookup.sol
737 
738 /**
739  * @title SupportsInterfaceWithLookup
740  * @author Matt Condon (@shrugs)
741  * @dev Implements ERC165 using a lookup table.
742  */
743 contract SupportsInterfaceWithLookup is ERC165 {
744 
745   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
746   /**
747    * 0x01ffc9a7 ===
748    *   bytes4(keccak256('supportsInterface(bytes4)'))
749    */
750 
751   /**
752    * @dev a mapping of interface id to whether or not it's supported
753    */
754   mapping(bytes4 => bool) internal supportedInterfaces;
755 
756   /**
757    * @dev A contract implementing SupportsInterfaceWithLookup
758    * implement ERC165 itself
759    */
760   constructor()
761     public
762   {
763     _registerInterface(InterfaceId_ERC165);
764   }
765 
766   /**
767    * @dev implement supportsInterface(bytes4) using a lookup table
768    */
769   function supportsInterface(bytes4 _interfaceId)
770     external
771     view
772     returns (bool)
773   {
774     return supportedInterfaces[_interfaceId];
775   }
776 
777   /**
778    * @dev private method for registering an interface
779    */
780   function _registerInterface(bytes4 _interfaceId)
781     internal
782   {
783     require(_interfaceId != 0xffffffff);
784     supportedInterfaces[_interfaceId] = true;
785   }
786 }
787 
788 // File: erc-payable-token/contracts/token/ERC1363/ERC1363.sol
789 
790 /**
791  * @title ERC1363 interface
792  * @author Vittorio Minacori (https://github.com/vittominacori)
793  * @dev Interface for a Payable Token contract as defined in
794  *  https://github.com/ethereum/EIPs/issues/1363
795  */
796 contract ERC1363 is ERC20, ERC165 {
797   /*
798    * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
799    * 0x4bbee2df ===
800    *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
801    *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
802    *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
803    *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
804    */
805 
806   /*
807    * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
808    * 0xfb9ec8ce ===
809    *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
810    *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
811    */
812 
813   /**
814    * @notice Transfer tokens from `msg.sender` to another address
815    *  and then call `onTransferReceived` on receiver
816    * @param _to address The address which you want to transfer to
817    * @param _value uint256 The amount of tokens to be transferred
818    * @return true unless throwing
819    */
820   function transferAndCall(address _to, uint256 _value) public returns (bool);
821 
822   /**
823    * @notice Transfer tokens from `msg.sender` to another address
824    *  and then call `onTransferReceived` on receiver
825    * @param _to address The address which you want to transfer to
826    * @param _value uint256 The amount of tokens to be transferred
827    * @param _data bytes Additional data with no specified format, sent in call to `_to`
828    * @return true unless throwing
829    */
830   function transferAndCall(address _to, uint256 _value, bytes _data) public returns (bool); // solium-disable-line max-len
831 
832   /**
833    * @notice Transfer tokens from one address to another
834    *  and then call `onTransferReceived` on receiver
835    * @param _from address The address which you want to send tokens from
836    * @param _to address The address which you want to transfer to
837    * @param _value uint256 The amount of tokens to be transferred
838    * @return true unless throwing
839    */
840   function transferFromAndCall(address _from, address _to, uint256 _value) public returns (bool); // solium-disable-line max-len
841 
842 
843   /**
844    * @notice Transfer tokens from one address to another
845    *  and then call `onTransferReceived` on receiver
846    * @param _from address The address which you want to send tokens from
847    * @param _to address The address which you want to transfer to
848    * @param _value uint256 The amount of tokens to be transferred
849    * @param _data bytes Additional data with no specified format, sent in call to `_to`
850    * @return true unless throwing
851    */
852   function transferFromAndCall(address _from, address _to, uint256 _value, bytes _data) public returns (bool); // solium-disable-line max-len, arg-overflow
853 
854   /**
855    * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
856    *  and then call `onApprovalReceived` on spender
857    *  Beware that changing an allowance with this method brings the risk that someone may use both the old
858    *  and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
859    *  race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
860    *  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
861    * @param _spender address The address which will spend the funds
862    * @param _value uint256 The amount of tokens to be spent
863    */
864   function approveAndCall(address _spender, uint256 _value) public returns (bool); // solium-disable-line max-len
865 
866   /**
867    * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
868    *  and then call `onApprovalReceived` on spender
869    *  Beware that changing an allowance with this method brings the risk that someone may use both the old
870    *  and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
871    *  race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
872    *  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
873    * @param _spender address The address which will spend the funds
874    * @param _value uint256 The amount of tokens to be spent
875    * @param _data bytes Additional data with no specified format, sent in call to `_spender`
876    */
877   function approveAndCall(address _spender, uint256 _value, bytes _data) public returns (bool); // solium-disable-line max-len
878 }
879 
880 // File: erc-payable-token/contracts/token/ERC1363/ERC1363Receiver.sol
881 
882 /**
883  * @title ERC1363Receiver interface
884  * @author Vittorio Minacori (https://github.com/vittominacori)
885  * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
886  *  from ERC1363 token contracts as defined in
887  *  https://github.com/ethereum/EIPs/issues/1363
888  */
889 contract ERC1363Receiver {
890   /*
891    * Note: the ERC-165 identifier for this interface is 0x88a7ca5c.
892    * 0x88a7ca5c === bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))
893    */
894 
895   /**
896    * @notice Handle the receipt of ERC1363 tokens
897    * @dev Any ERC1363 smart contract calls this function on the recipient
898    *  after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
899    *  transfer. Return of other than the magic value MUST result in the
900    *  transaction being reverted.
901    *  Note: the contract address is always the message sender.
902    * @param _operator address The address which called `transferAndCall` or `transferFromAndCall` function
903    * @param _from address The address which are token transferred from
904    * @param _value uint256 The amount of tokens transferred
905    * @param _data bytes Additional data with no specified format
906    * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
907    *  unless throwing
908    */
909   function onTransferReceived(address _operator, address _from, uint256 _value, bytes _data) external returns (bytes4); // solium-disable-line max-len, arg-overflow
910 }
911 
912 // File: erc-payable-token/contracts/token/ERC1363/ERC1363Spender.sol
913 
914 /**
915  * @title ERC1363Spender interface
916  * @author Vittorio Minacori (https://github.com/vittominacori)
917  * @dev Interface for any contract that wants to support approveAndCall
918  *  from ERC1363 token contracts as defined in
919  *  https://github.com/ethereum/EIPs/issues/1363
920  */
921 contract ERC1363Spender {
922   /*
923    * Note: the ERC-165 identifier for this interface is 0x7b04a2d0.
924    * 0x7b04a2d0 === bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))
925    */
926 
927   /**
928    * @notice Handle the approval of ERC1363 tokens
929    * @dev Any ERC1363 smart contract calls this function on the recipient
930    *  after an `approve`. This function MAY throw to revert and reject the
931    *  approval. Return of other than the magic value MUST result in the
932    *  transaction being reverted.
933    *  Note: the contract address is always the message sender.
934    * @param _owner address The address which called `approveAndCall` function
935    * @param _value uint256 The amount of tokens to be spent
936    * @param _data bytes Additional data with no specified format
937    * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
938    *  unless throwing
939    */
940   function onApprovalReceived(address _owner, uint256 _value, bytes _data) external returns (bytes4); // solium-disable-line max-len
941 }
942 
943 // File: erc-payable-token/contracts/token/ERC1363/ERC1363BasicToken.sol
944 
945 // solium-disable-next-line max-len
946 
947 
948 
949 
950 
951 
952 
953 /**
954  * @title ERC1363BasicToken
955  * @author Vittorio Minacori (https://github.com/vittominacori)
956  * @dev Implementation of an ERC1363 interface
957  */
958 contract ERC1363BasicToken is SupportsInterfaceWithLookup, StandardToken, ERC1363 { // solium-disable-line max-len
959   using AddressUtils for address;
960 
961   /*
962    * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
963    * 0x4bbee2df ===
964    *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
965    *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
966    *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
967    *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
968    */
969   bytes4 internal constant InterfaceId_ERC1363Transfer = 0x4bbee2df;
970 
971   /*
972    * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
973    * 0xfb9ec8ce ===
974    *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
975    *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
976    */
977   bytes4 internal constant InterfaceId_ERC1363Approve = 0xfb9ec8ce;
978 
979   // Equals to `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
980   // which can be also obtained as `ERC1363Receiver(0).onTransferReceived.selector`
981   bytes4 private constant ERC1363_RECEIVED = 0x88a7ca5c;
982 
983   // Equals to `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
984   // which can be also obtained as `ERC1363Spender(0).onApprovalReceived.selector`
985   bytes4 private constant ERC1363_APPROVED = 0x7b04a2d0;
986 
987   constructor() public {
988     // register the supported interfaces to conform to ERC1363 via ERC165
989     _registerInterface(InterfaceId_ERC1363Transfer);
990     _registerInterface(InterfaceId_ERC1363Approve);
991   }
992 
993   function transferAndCall(
994     address _to,
995     uint256 _value
996   )
997     public
998     returns (bool)
999   {
1000     return transferAndCall(_to, _value, "");
1001   }
1002 
1003   function transferAndCall(
1004     address _to,
1005     uint256 _value,
1006     bytes _data
1007   )
1008     public
1009     returns (bool)
1010   {
1011     require(transfer(_to, _value));
1012     require(
1013       checkAndCallTransfer(
1014         msg.sender,
1015         _to,
1016         _value,
1017         _data
1018       )
1019     );
1020     return true;
1021   }
1022 
1023   function transferFromAndCall(
1024     address _from,
1025     address _to,
1026     uint256 _value
1027   )
1028     public
1029     returns (bool)
1030   {
1031     // solium-disable-next-line arg-overflow
1032     return transferFromAndCall(_from, _to, _value, "");
1033   }
1034 
1035   function transferFromAndCall(
1036     address _from,
1037     address _to,
1038     uint256 _value,
1039     bytes _data
1040   )
1041     public
1042     returns (bool)
1043   {
1044     require(transferFrom(_from, _to, _value));
1045     require(
1046       checkAndCallTransfer(
1047         _from,
1048         _to,
1049         _value,
1050         _data
1051       )
1052     );
1053     return true;
1054   }
1055 
1056   function approveAndCall(
1057     address _spender,
1058     uint256 _value
1059   )
1060     public
1061     returns (bool)
1062   {
1063     return approveAndCall(_spender, _value, "");
1064   }
1065 
1066   function approveAndCall(
1067     address _spender,
1068     uint256 _value,
1069     bytes _data
1070   )
1071     public
1072     returns (bool)
1073   {
1074     approve(_spender, _value);
1075     require(
1076       checkAndCallApprove(
1077         _spender,
1078         _value,
1079         _data
1080       )
1081     );
1082     return true;
1083   }
1084 
1085   /**
1086    * @dev Internal function to invoke `onTransferReceived` on a target address
1087    *  The call is not executed if the target address is not a contract
1088    * @param _from address Representing the previous owner of the given token value
1089    * @param _to address Target address that will receive the tokens
1090    * @param _value uint256 The amount mount of tokens to be transferred
1091    * @param _data bytes Optional data to send along with the call
1092    * @return whether the call correctly returned the expected magic value
1093    */
1094   function checkAndCallTransfer(
1095     address _from,
1096     address _to,
1097     uint256 _value,
1098     bytes _data
1099   )
1100     internal
1101     returns (bool)
1102   {
1103     if (!_to.isContract()) {
1104       return false;
1105     }
1106     bytes4 retval = ERC1363Receiver(_to).onTransferReceived(
1107       msg.sender, _from, _value, _data
1108     );
1109     return (retval == ERC1363_RECEIVED);
1110   }
1111 
1112   /**
1113    * @dev Internal function to invoke `onApprovalReceived` on a target address
1114    *  The call is not executed if the target address is not a contract
1115    * @param _spender address The address which will spend the funds
1116    * @param _value uint256 The amount of tokens to be spent
1117    * @param _data bytes Optional data to send along with the call
1118    * @return whether the call correctly returned the expected magic value
1119    */
1120   function checkAndCallApprove(
1121     address _spender,
1122     uint256 _value,
1123     bytes _data
1124   )
1125     internal
1126     returns (bool)
1127   {
1128     if (!_spender.isContract()) {
1129       return false;
1130     }
1131     bytes4 retval = ERC1363Spender(_spender).onApprovalReceived(
1132       msg.sender, _value, _data
1133     );
1134     return (retval == ERC1363_APPROVED);
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
1290 
1291 // File: contracts/distribution/CappedDelivery.sol
1292 
1293 /**
1294  * @title CappedDelivery
1295  * @author Vittorio Minacori (https://github.com/vittominacori)
1296  * @dev Contract to distribute tokens by transfer function
1297  */
1298 contract CappedDelivery is TokenRecover {
1299 
1300   using SafeMath for uint256;
1301 
1302   // the token to distribute
1303   ERC20 internal _token;
1304 
1305   // the max token cap to distribute
1306   uint256 private _cap;
1307 
1308   // if multiple sends to the same address are allowed
1309   bool private _allowMultipleSend;
1310 
1311   // the sum of distributed tokens
1312   uint256 private _distributedTokens;
1313 
1314   // map of address and received token amount
1315   mapping (address => uint256) private _receivedTokens;
1316 
1317   /**
1318    * @param token Address of the token being distributed
1319    * @param cap Max amount of token to be distributed
1320    * @param allowMultipleSend Allow multiple send to same address
1321    */
1322   constructor(address token, uint256 cap, bool allowMultipleSend) public {
1323     require(token != address(0));
1324     require(cap > 0);
1325 
1326     _token = ERC20(token);
1327     _cap = cap;
1328     _allowMultipleSend = allowMultipleSend;
1329   }
1330 
1331   /**
1332    * @return the token to distribute
1333    */
1334   function token() public view returns(ERC20) {
1335     return _token;
1336   }
1337 
1338   /**
1339    * @return the max token cap to distribute
1340    */
1341   function cap() public view returns(uint256) {
1342     return _cap;
1343   }
1344 
1345   /**
1346    * @return if multiple sends to the same address are allowed
1347    */
1348   function allowMultipleSend() public view returns(bool) {
1349     return _allowMultipleSend;
1350   }
1351 
1352   /**
1353    * @return the sum of distributed tokens
1354    */
1355   function distributedTokens() public view returns(uint256) {
1356     return _distributedTokens;
1357   }
1358 
1359   /**
1360    * @param account The address to check
1361    * @return received token amount for the given address
1362    */
1363   function receivedTokens(address account) public view returns(uint256) {
1364     return _receivedTokens[account];
1365   }
1366 
1367   /**
1368    * @dev return the number of remaining tokens to distribute
1369    * @return uint256
1370    */
1371   function remainingTokens() public view returns(uint256) {
1372     return _cap.sub(_distributedTokens);
1373   }
1374 
1375   /**
1376    * @dev send tokens
1377    * @param accounts Array of addresses being distributing
1378    * @param amounts Array of amounts of token distributed
1379    */
1380   function multiSend(address[] accounts, uint256[] amounts) public onlyOwner {
1381     require(accounts.length > 0);
1382     require(amounts.length > 0);
1383     require(accounts.length == amounts.length);
1384 
1385     for (uint i = 0; i < accounts.length; i++) {
1386       address account = accounts[i];
1387       uint256 amount = amounts[i] * 10 ** 18;
1388 
1389       if (_allowMultipleSend || _receivedTokens[account] == 0) {
1390         _receivedTokens[account] = _receivedTokens[account].add(amount);
1391         _distributedTokens = _distributedTokens.add(amount);
1392 
1393         require(_distributedTokens <= _cap);
1394 
1395         _distributeTokens(account, amount);
1396       }
1397     }
1398   }
1399 
1400   /**
1401    * @dev distribute tokens
1402    * @param account Address being distributing
1403    * @param amount Amount of token distributed
1404    */
1405   function _distributeTokens(address account, uint256 amount) internal {
1406     _token.transfer(account, amount);
1407   }
1408 }