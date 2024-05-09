1 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * See https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address _who) public view returns (uint256);
14   function transfer(address _to, uint256 _value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
19 
20 pragma solidity ^0.4.24;
21 
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that throw on error
26  */
27 library SafeMath {
28 
29   /**
30   * @dev Multiplies two numbers, throws on overflow.
31   */
32   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
33     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
34     // benefit is lost if 'b' is also tested.
35     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
36     if (_a == 0) {
37       return 0;
38     }
39 
40     c = _a * _b;
41     assert(c / _a == _b);
42     return c;
43   }
44 
45   /**
46   * @dev Integer division of two numbers, truncating the quotient.
47   */
48   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
49     // assert(_b > 0); // Solidity automatically throws when dividing by 0
50     // uint256 c = _a / _b;
51     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
52     return _a / _b;
53   }
54 
55   /**
56   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
57   */
58   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
59     assert(_b <= _a);
60     return _a - _b;
61   }
62 
63   /**
64   * @dev Adds two numbers, throws on overflow.
65   */
66   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
67     c = _a + _b;
68     assert(c >= _a);
69     return c;
70   }
71 }
72 
73 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
74 
75 pragma solidity ^0.4.24;
76 
77 
78 
79 
80 /**
81  * @title Basic token
82  * @dev Basic version of StandardToken, with no allowances.
83  */
84 contract BasicToken is ERC20Basic {
85   using SafeMath for uint256;
86 
87   mapping(address => uint256) internal balances;
88 
89   uint256 internal totalSupply_;
90 
91   /**
92   * @dev Total number of tokens in existence
93   */
94   function totalSupply() public view returns (uint256) {
95     return totalSupply_;
96   }
97 
98   /**
99   * @dev Transfer token for a specified address
100   * @param _to The address to transfer to.
101   * @param _value The amount to be transferred.
102   */
103   function transfer(address _to, uint256 _value) public returns (bool) {
104     require(_value <= balances[msg.sender]);
105     require(_to != address(0));
106 
107     balances[msg.sender] = balances[msg.sender].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     emit Transfer(msg.sender, _to, _value);
110     return true;
111   }
112 
113   /**
114   * @dev Gets the balance of the specified address.
115   * @param _owner The address to query the the balance of.
116   * @return An uint256 representing the amount owned by the passed address.
117   */
118   function balanceOf(address _owner) public view returns (uint256) {
119     return balances[_owner];
120   }
121 
122 }
123 
124 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
125 
126 pragma solidity ^0.4.24;
127 
128 
129 
130 /**
131  * @title ERC20 interface
132  * @dev see https://github.com/ethereum/EIPs/issues/20
133  */
134 contract ERC20 is ERC20Basic {
135   function allowance(address _owner, address _spender)
136     public view returns (uint256);
137 
138   function transferFrom(address _from, address _to, uint256 _value)
139     public returns (bool);
140 
141   function approve(address _spender, uint256 _value) public returns (bool);
142   event Approval(
143     address indexed owner,
144     address indexed spender,
145     uint256 value
146   );
147 }
148 
149 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
150 
151 pragma solidity ^0.4.24;
152 
153 
154 
155 
156 /**
157  * @title Standard ERC20 token
158  *
159  * @dev Implementation of the basic standard token.
160  * https://github.com/ethereum/EIPs/issues/20
161  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
162  */
163 contract StandardToken is ERC20, BasicToken {
164 
165   mapping (address => mapping (address => uint256)) internal allowed;
166 
167 
168   /**
169    * @dev Transfer tokens from one address to another
170    * @param _from address The address which you want to send tokens from
171    * @param _to address The address which you want to transfer to
172    * @param _value uint256 the amount of tokens to be transferred
173    */
174   function transferFrom(
175     address _from,
176     address _to,
177     uint256 _value
178   )
179     public
180     returns (bool)
181   {
182     require(_value <= balances[_from]);
183     require(_value <= allowed[_from][msg.sender]);
184     require(_to != address(0));
185 
186     balances[_from] = balances[_from].sub(_value);
187     balances[_to] = balances[_to].add(_value);
188     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
189     emit Transfer(_from, _to, _value);
190     return true;
191   }
192 
193   /**
194    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
195    * Beware that changing an allowance with this method brings the risk that someone may use both the old
196    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
197    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
198    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
199    * @param _spender The address which will spend the funds.
200    * @param _value The amount of tokens to be spent.
201    */
202   function approve(address _spender, uint256 _value) public returns (bool) {
203     allowed[msg.sender][_spender] = _value;
204     emit Approval(msg.sender, _spender, _value);
205     return true;
206   }
207 
208   /**
209    * @dev Function to check the amount of tokens that an owner allowed to a spender.
210    * @param _owner address The address which owns the funds.
211    * @param _spender address The address which will spend the funds.
212    * @return A uint256 specifying the amount of tokens still available for the spender.
213    */
214   function allowance(
215     address _owner,
216     address _spender
217    )
218     public
219     view
220     returns (uint256)
221   {
222     return allowed[_owner][_spender];
223   }
224 
225   /**
226    * @dev Increase the amount of tokens that an owner allowed to a spender.
227    * approve should be called when allowed[_spender] == 0. To increment
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param _spender The address which will spend the funds.
232    * @param _addedValue The amount of tokens to increase the allowance by.
233    */
234   function increaseApproval(
235     address _spender,
236     uint256 _addedValue
237   )
238     public
239     returns (bool)
240   {
241     allowed[msg.sender][_spender] = (
242       allowed[msg.sender][_spender].add(_addedValue));
243     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244     return true;
245   }
246 
247   /**
248    * @dev Decrease the amount of tokens that an owner allowed to a spender.
249    * approve should be called when allowed[_spender] == 0. To decrement
250    * allowed value is better to use this function to avoid 2 calls (and wait until
251    * the first transaction is mined)
252    * From MonolithDAO Token.sol
253    * @param _spender The address which will spend the funds.
254    * @param _subtractedValue The amount of tokens to decrease the allowance by.
255    */
256   function decreaseApproval(
257     address _spender,
258     uint256 _subtractedValue
259   )
260     public
261     returns (bool)
262   {
263     uint256 oldValue = allowed[msg.sender][_spender];
264     if (_subtractedValue >= oldValue) {
265       allowed[msg.sender][_spender] = 0;
266     } else {
267       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
268     }
269     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
270     return true;
271   }
272 
273 }
274 
275 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
276 
277 pragma solidity ^0.4.24;
278 
279 
280 /**
281  * @title Ownable
282  * @dev The Ownable contract has an owner address, and provides basic authorization control
283  * functions, this simplifies the implementation of "user permissions".
284  */
285 contract Ownable {
286   address public owner;
287 
288 
289   event OwnershipRenounced(address indexed previousOwner);
290   event OwnershipTransferred(
291     address indexed previousOwner,
292     address indexed newOwner
293   );
294 
295 
296   /**
297    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
298    * account.
299    */
300   constructor() public {
301     owner = msg.sender;
302   }
303 
304   /**
305    * @dev Throws if called by any account other than the owner.
306    */
307   modifier onlyOwner() {
308     require(msg.sender == owner);
309     _;
310   }
311 
312   /**
313    * @dev Allows the current owner to relinquish control of the contract.
314    * @notice Renouncing to ownership will leave the contract without an owner.
315    * It will not be possible to call the functions with the `onlyOwner`
316    * modifier anymore.
317    */
318   function renounceOwnership() public onlyOwner {
319     emit OwnershipRenounced(owner);
320     owner = address(0);
321   }
322 
323   /**
324    * @dev Allows the current owner to transfer control of the contract to a newOwner.
325    * @param _newOwner The address to transfer ownership to.
326    */
327   function transferOwnership(address _newOwner) public onlyOwner {
328     _transferOwnership(_newOwner);
329   }
330 
331   /**
332    * @dev Transfers control of the contract to a newOwner.
333    * @param _newOwner The address to transfer ownership to.
334    */
335   function _transferOwnership(address _newOwner) internal {
336     require(_newOwner != address(0));
337     emit OwnershipTransferred(owner, _newOwner);
338     owner = _newOwner;
339   }
340 }
341 
342 // File: contracts/base/MintableToken.sol
343 
344 pragma solidity ^0.4.24;
345 
346 
347 
348 /**
349  * @title Mintable token
350  * @dev Simple ERC20 Token example, with mintable token creation
351  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
352  */
353 contract MintableToken is StandardToken, Ownable {
354   event Mint(address indexed to, uint256 amount);
355   event MintFinished();
356 
357   bool public mintingFinished = false;
358 
359 
360   modifier canMint() {
361     require(!mintingFinished);
362     _;
363   }
364 
365   modifier hasMintPermission() {
366     require(msg.sender == owner);
367     _;
368   }
369 
370   /**
371    * @dev Function to mint tokens
372    * @param _to The address that will receive the minted tokens.
373    * @param _amount The amount of tokens to mint.
374    * @return A boolean that indicates if the operation was successful.
375    */
376   function mint(
377     address _to,
378     uint256 _amount
379   )
380     public
381     hasMintPermission
382     canMint
383     returns (bool)
384   {
385     return _mint(_to, _amount);
386   }
387 
388    /**
389    * @dev Internal Function to mint tokens
390    * @param _to The address that will receive the minted tokens.
391    * @param _amount The amount of tokens to mint.
392    * @return A boolean that indicates if the operation was successful.
393    */
394   function _mint(
395     address _to,
396     uint256 _amount
397   ) 
398     internal
399     returns (bool) 
400   {
401     totalSupply_ = totalSupply_.add(_amount);
402     balances[_to] = balances[_to].add(_amount);
403     emit Mint(_to, _amount);
404     emit Transfer(address(0), _to, _amount);
405     return true;
406   }
407 
408   /**
409    * @dev Function to stop minting new tokens.
410    * @return True if the operation was successful.
411    */
412   function finishMinting() public onlyOwner canMint returns (bool) {
413     mintingFinished = true;
414     emit MintFinished();
415     return true;
416   }
417 }
418 
419 // File: openzeppelin-solidity/contracts/lifecycle/Destructible.sol
420 
421 pragma solidity ^0.4.24;
422 
423 
424 
425 /**
426  * @title Destructible
427  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
428  */
429 contract Destructible is Ownable {
430   /**
431    * @dev Transfers the current balance to the owner and terminates the contract.
432    */
433   function destroy() public onlyOwner {
434     selfdestruct(owner);
435   }
436 
437   function destroyAndSend(address _recipient) public onlyOwner {
438     selfdestruct(_recipient);
439   }
440 }
441 
442 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
443 
444 pragma solidity ^0.4.24;
445 
446 
447 
448 /**
449  * @title Pausable
450  * @dev Base contract which allows children to implement an emergency stop mechanism.
451  */
452 contract Pausable is Ownable {
453   event Pause();
454   event Unpause();
455 
456   bool public paused = false;
457 
458 
459   /**
460    * @dev Modifier to make a function callable only when the contract is not paused.
461    */
462   modifier whenNotPaused() {
463     require(!paused);
464     _;
465   }
466 
467   /**
468    * @dev Modifier to make a function callable only when the contract is paused.
469    */
470   modifier whenPaused() {
471     require(paused);
472     _;
473   }
474 
475   /**
476    * @dev called by the owner to pause, triggers stopped state
477    */
478   function pause() public onlyOwner whenNotPaused {
479     paused = true;
480     emit Pause();
481   }
482 
483   /**
484    * @dev called by the owner to unpause, returns to normal state
485    */
486   function unpause() public onlyOwner whenPaused {
487     paused = false;
488     emit Unpause();
489   }
490 }
491 
492 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
493 
494 pragma solidity ^0.4.24;
495 
496 
497 
498 /**
499  * @title Burnable Token
500  * @dev Token that can be irreversibly burned (destroyed).
501  */
502 contract BurnableToken is BasicToken {
503 
504   event Burn(address indexed burner, uint256 value);
505 
506   /**
507    * @dev Burns a specific amount of tokens.
508    * @param _value The amount of token to be burned.
509    */
510   function burn(uint256 _value) public {
511     _burn(msg.sender, _value);
512   }
513 
514   function _burn(address _who, uint256 _value) internal {
515     require(_value <= balances[_who]);
516     // no need to require value <= totalSupply, since that would imply the
517     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
518 
519     balances[_who] = balances[_who].sub(_value);
520     totalSupply_ = totalSupply_.sub(_value);
521     emit Burn(_who, _value);
522     emit Transfer(_who, address(0), _value);
523   }
524 }
525 
526 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
527 
528 pragma solidity ^0.4.24;
529 
530 
531 
532 /**
533  * @title DetailedERC20 token
534  * @dev The decimals are only for visualization purposes.
535  * All the operations are done using the smallest and indivisible token unit,
536  * just as on Ethereum all the operations are done in wei.
537  */
538 contract DetailedERC20 is ERC20 {
539   string public name;
540   string public symbol;
541   uint8 public decimals;
542 
543   constructor(string _name, string _symbol, uint8 _decimals) public {
544     name = _name;
545     symbol = _symbol;
546     decimals = _decimals;
547   }
548 }
549 
550 // File: openzeppelin-solidity/contracts/access/rbac/Roles.sol
551 
552 pragma solidity ^0.4.24;
553 
554 
555 /**
556  * @title Roles
557  * @author Francisco Giordano (@frangio)
558  * @dev Library for managing addresses assigned to a Role.
559  * See RBAC.sol for example usage.
560  */
561 library Roles {
562   struct Role {
563     mapping (address => bool) bearer;
564   }
565 
566   /**
567    * @dev give an address access to this role
568    */
569   function add(Role storage _role, address _addr)
570     internal
571   {
572     _role.bearer[_addr] = true;
573   }
574 
575   /**
576    * @dev remove an address' access to this role
577    */
578   function remove(Role storage _role, address _addr)
579     internal
580   {
581     _role.bearer[_addr] = false;
582   }
583 
584   /**
585    * @dev check if an address has this role
586    * // reverts
587    */
588   function check(Role storage _role, address _addr)
589     internal
590     view
591   {
592     require(has(_role, _addr));
593   }
594 
595   /**
596    * @dev check if an address has this role
597    * @return bool
598    */
599   function has(Role storage _role, address _addr)
600     internal
601     view
602     returns (bool)
603   {
604     return _role.bearer[_addr];
605   }
606 }
607 
608 // File: openzeppelin-solidity/contracts/access/rbac/RBAC.sol
609 
610 pragma solidity ^0.4.24;
611 
612 
613 
614 /**
615  * @title RBAC (Role-Based Access Control)
616  * @author Matt Condon (@Shrugs)
617  * @dev Stores and provides setters and getters for roles and addresses.
618  * Supports unlimited numbers of roles and addresses.
619  * See //contracts/mocks/RBACMock.sol for an example of usage.
620  * This RBAC method uses strings to key roles. It may be beneficial
621  * for you to write your own implementation of this interface using Enums or similar.
622  */
623 contract RBAC {
624   using Roles for Roles.Role;
625 
626   mapping (string => Roles.Role) private roles;
627 
628   event RoleAdded(address indexed operator, string role);
629   event RoleRemoved(address indexed operator, string role);
630 
631   /**
632    * @dev reverts if addr does not have role
633    * @param _operator address
634    * @param _role the name of the role
635    * // reverts
636    */
637   function checkRole(address _operator, string _role)
638     public
639     view
640   {
641     roles[_role].check(_operator);
642   }
643 
644   /**
645    * @dev determine if addr has role
646    * @param _operator address
647    * @param _role the name of the role
648    * @return bool
649    */
650   function hasRole(address _operator, string _role)
651     public
652     view
653     returns (bool)
654   {
655     return roles[_role].has(_operator);
656   }
657 
658   /**
659    * @dev add a role to an address
660    * @param _operator address
661    * @param _role the name of the role
662    */
663   function addRole(address _operator, string _role)
664     internal
665   {
666     roles[_role].add(_operator);
667     emit RoleAdded(_operator, _role);
668   }
669 
670   /**
671    * @dev remove a role from an address
672    * @param _operator address
673    * @param _role the name of the role
674    */
675   function removeRole(address _operator, string _role)
676     internal
677   {
678     roles[_role].remove(_operator);
679     emit RoleRemoved(_operator, _role);
680   }
681 
682   /**
683    * @dev modifier to scope access to a single role (uses msg.sender as addr)
684    * @param _role the name of the role
685    * // reverts
686    */
687   modifier onlyRole(string _role)
688   {
689     checkRole(msg.sender, _role);
690     _;
691   }
692 
693   /**
694    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
695    * @param _roles the names of the roles to scope access to
696    * // reverts
697    *
698    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
699    *  see: https://github.com/ethereum/solidity/issues/2467
700    */
701   // modifier onlyRoles(string[] _roles) {
702   //     bool hasAnyRole = false;
703   //     for (uint8 i = 0; i < _roles.length; i++) {
704   //         if (hasRole(msg.sender, _roles[i])) {
705   //             hasAnyRole = true;
706   //             break;
707   //         }
708   //     }
709 
710   //     require(hasAnyRole);
711 
712   //     _;
713   // }
714 }
715 
716 // File: openzeppelin-solidity/contracts/access/Whitelist.sol
717 
718 pragma solidity ^0.4.24;
719 
720 
721 
722 
723 /**
724  * @title Whitelist
725  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
726  * This simplifies the implementation of "user permissions".
727  */
728 contract Whitelist is Ownable, RBAC {
729   string public constant ROLE_WHITELISTED = "whitelist";
730 
731   /**
732    * @dev Throws if operator is not whitelisted.
733    * @param _operator address
734    */
735   modifier onlyIfWhitelisted(address _operator) {
736     checkRole(_operator, ROLE_WHITELISTED);
737     _;
738   }
739 
740   /**
741    * @dev add an address to the whitelist
742    * @param _operator address
743    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
744    */
745   function addAddressToWhitelist(address _operator)
746     public
747     onlyOwner
748   {
749     addRole(_operator, ROLE_WHITELISTED);
750   }
751 
752   /**
753    * @dev getter to determine if address is in whitelist
754    */
755   function whitelist(address _operator)
756     public
757     view
758     returns (bool)
759   {
760     return hasRole(_operator, ROLE_WHITELISTED);
761   }
762 
763   /**
764    * @dev add addresses to the whitelist
765    * @param _operators addresses
766    * @return true if at least one address was added to the whitelist,
767    * false if all addresses were already in the whitelist
768    */
769   function addAddressesToWhitelist(address[] _operators)
770     public
771     onlyOwner
772   {
773     for (uint256 i = 0; i < _operators.length; i++) {
774       addAddressToWhitelist(_operators[i]);
775     }
776   }
777 
778   /**
779    * @dev remove an address from the whitelist
780    * @param _operator address
781    * @return true if the address was removed from the whitelist,
782    * false if the address wasn't in the whitelist in the first place
783    */
784   function removeAddressFromWhitelist(address _operator)
785     public
786     onlyOwner
787   {
788     removeRole(_operator, ROLE_WHITELISTED);
789   }
790 
791   /**
792    * @dev remove addresses from the whitelist
793    * @param _operators addresses
794    * @return true if at least one address was removed from the whitelist,
795    * false if all addresses weren't in the whitelist in the first place
796    */
797   function removeAddressesFromWhitelist(address[] _operators)
798     public
799     onlyOwner
800   {
801     for (uint256 i = 0; i < _operators.length; i++) {
802       removeAddressFromWhitelist(_operators[i]);
803     }
804   }
805 
806 }
807 
808 // File: openzeppelin-solidity/contracts/ECRecovery.sol
809 
810 pragma solidity ^0.4.24;
811 
812 
813 /**
814  * @title Elliptic curve signature operations
815  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
816  * TODO Remove this library once solidity supports passing a signature to ecrecover.
817  * See https://github.com/ethereum/solidity/issues/864
818  */
819 
820 library ECRecovery {
821 
822   /**
823    * @dev Recover signer address from a message by using their signature
824    * @param _hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
825    * @param _sig bytes signature, the signature is generated using web3.eth.sign()
826    */
827   function recover(bytes32 _hash, bytes _sig)
828     internal
829     pure
830     returns (address)
831   {
832     bytes32 r;
833     bytes32 s;
834     uint8 v;
835 
836     // Check the signature length
837     if (_sig.length != 65) {
838       return (address(0));
839     }
840 
841     // Divide the signature in r, s and v variables
842     // ecrecover takes the signature parameters, and the only way to get them
843     // currently is to use assembly.
844     // solium-disable-next-line security/no-inline-assembly
845     assembly {
846       r := mload(add(_sig, 32))
847       s := mload(add(_sig, 64))
848       v := byte(0, mload(add(_sig, 96)))
849     }
850 
851     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
852     if (v < 27) {
853       v += 27;
854     }
855 
856     // If the version is correct return the signer address
857     if (v != 27 && v != 28) {
858       return (address(0));
859     } else {
860       // solium-disable-next-line arg-overflow
861       return ecrecover(_hash, v, r, s);
862     }
863   }
864 
865   /**
866    * toEthSignedMessageHash
867    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
868    * and hash the result
869    */
870   function toEthSignedMessageHash(bytes32 _hash)
871     internal
872     pure
873     returns (bytes32)
874   {
875     // 32 is the length in bytes of hash,
876     // enforced by the type signature above
877     return keccak256(
878       abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)
879     );
880   }
881 }
882 
883 // File: contracts/SilverToken.sol
884 
885 pragma solidity ^0.4.24;
886 
887 
888 
889 
890 
891 
892 
893 
894 interface ASilverDollar {
895   function purchaseWithSilverToken(address, uint256) external returns(bool);
896 }
897 
898 contract SilverToken is Destructible, Pausable, MintableToken, BurnableToken, DetailedERC20("Silvertoken", "SLVT", 8), Whitelist {
899   using SafeMath for uint256;
900   using ECRecovery for bytes32;
901 
902   uint256 public transferFee = 10;//1%
903   uint256 public transferDiscountFee = 8;//0.8%
904   uint256 public redemptionFee = 40;//4%
905   uint256 public convertFee = 10;//1%
906   address public feeReturnAddress = 0xE34f13B2dadC938f44eCbC38A8dBe94B8bdB2109;
907   uint256 public transferFreeAmount;
908   uint256 public transferDiscountAmount;
909   address public silverDollarAddress;
910   address public SLVTReserve = 0x900122447a2Eaeb1655C99A91E20f506D509711B;
911   bool    public canPurchase = true;
912   bool    public canConvert = true;
913 
914   // Internal features
915 
916   uint256 internal multiplier;
917   uint256 internal percentage = 1000;
918 
919   //ce4385affa8ad2cbec45b1660c6f6afcb691bf0a7a73ebda096ee1dfb670fe6f
920   event TokenRedeemed(address from, uint256 amount);
921   //3ceffd410054fdaed44f598ff5c1fb450658778e2241892da4aa646979dee617
922   event TokenPurchased(address addr, uint256 amount, uint256 tokens);
923   //5a56a31cc0c9ebf5d0626c5189b951fe367d953afc1824a8bb82bf168713cc52
924   event FeeApplied(string name, address addr, uint256 amount);
925   event Converted(address indexed sender, uint256 amountSLVT, uint256 amountSLVD, uint256 amountFee);
926 
927   modifier purchasable() {
928     require(canPurchase == true, "can't purchase");
929     _;
930   }
931 
932   modifier onlySilverDollar() {
933     require(msg.sender == silverDollarAddress, "not silverDollar");
934     _;
935   }
936   
937   modifier isConvertible() {
938     require(canConvert == true, "SLVT conversion disabled");
939     _;
940   }
941 
942 
943   constructor () public {
944     multiplier = 10 ** uint256(decimals);
945     transferFreeAmount = 2 * multiplier;
946     transferDiscountAmount = 500 * multiplier;
947     owner = msg.sender;
948     super.mint(msg.sender, 1 * 1000 * 1000 * multiplier);
949   }
950 
951   // Settings begin
952 
953   function setTransferFreeAmount(uint256 value) public onlyOwner      { transferFreeAmount = value; }
954   function setTransferDiscountAmount(uint256 value) public onlyOwner  { transferDiscountAmount = value; }
955   function setRedemptionFee(uint256 value) public onlyOwner           { redemptionFee = value; }
956   function setFeeReturnAddress(address value) public onlyOwner        { feeReturnAddress = value; }
957   function setCanPurchase(bool value) public onlyOwner                { canPurchase = value; }
958   function setSilverDollarAddress(address value) public onlyOwner     { silverDollarAddress = value; }
959   function setCanConvert(bool value) public onlyOwner                 { canConvert = value; }
960   function setConvertFee(uint256 value) public onlyOwner              { convertFee = value; }
961 
962 
963   function increaseTotalSupply(uint256 value) public onlyOwner returns (uint256) {
964     super.mint(owner, value);
965     return totalSupply_;
966   }
967 
968   // Settings end
969 
970   // ERC20 re-implementation methods begin
971 
972   function transfer(address to, uint256 amount) public whenNotPaused returns (bool) {
973     uint256 feesPaid = payFees(address(0), to, amount);
974     require(super.transfer(to, amount.sub(feesPaid)), "failed transfer");
975 
976     return true;
977   }
978 
979   function transferFrom(address from, address to, uint256 amount) public whenNotPaused returns (bool) {
980     uint256 feesPaid = payFees(from, to, amount);
981     require(super.transferFrom(from, to, amount.sub(feesPaid)), "failed transferFrom");
982 
983     return true;
984   }
985 
986   // ERC20 re-implementation methods end
987 
988   // Silvertoken methods end
989 
990   function payFees(address from, address to, uint256 amount) private returns (uint256 fees) {
991     if (msg.sender == owner || hasRole(from, ROLE_WHITELISTED) || hasRole(msg.sender, ROLE_WHITELISTED) || hasRole(to, ROLE_WHITELISTED))
992         return 0;
993     fees = getTransferFee(amount);
994     if (from == address(0)) {
995       require(super.transfer(feeReturnAddress, fees), "transfer fee payment failed");
996     }
997     else {
998       require(super.transferFrom(from, feeReturnAddress, fees), "transferFrom fee payment failed");
999     }
1000     emit FeeApplied("Transfer", to, fees);
1001   }
1002 
1003   function getTransferFee(uint256 amount) internal view returns(uint256) {
1004     if (transferFreeAmount > 0 && amount <= transferFreeAmount) return 0;
1005     if (transferDiscountAmount > 0 && amount >= transferDiscountAmount) return amount.mul(transferDiscountFee).div(percentage);
1006     return amount.mul(transferFee).div(percentage);
1007   }
1008 
1009   function transferTokens(address from, address to, uint256 amount) internal returns (bool) {
1010     require(balances[from] >= amount, "balance insufficient");
1011 
1012     balances[from] = balances[from].sub(amount);
1013     balances[to] = balances[to].add(amount);
1014 
1015     emit Transfer(from, to, amount);
1016 
1017     return true;
1018   }
1019 
1020   function purchase(uint256 tokens, uint256 fee, uint256 timestamp, bytes signature) public payable purchasable whenNotPaused {
1021     require(
1022       isSignatureValid(
1023         msg.sender, msg.value, tokens, fee, timestamp, signature
1024       ),
1025       "invalid signature"
1026     );
1027     require(tokens > 0, "invalid number of tokens");
1028     
1029     emit TokenPurchased(msg.sender, msg.value, tokens);
1030     transferTokens(owner, msg.sender, tokens);
1031 
1032     feeReturnAddress.transfer(msg.value);
1033     if (fee > 0) {
1034       emit FeeApplied("Purchase", msg.sender, fee);
1035     }       
1036   }
1037 
1038   function purchasedSilverDollar(uint256 amount) public onlySilverDollar purchasable whenNotPaused returns (bool) {
1039     require(super._mint(SLVTReserve, amount), "minting of slvT failed");
1040     
1041     return true;
1042   }
1043 
1044   function purchaseWithSilverDollar(address to, uint256 amount) public onlySilverDollar purchasable whenNotPaused returns (bool) {
1045     require(transferTokens(SLVTReserve, to, amount), "failed transfer of slvT from reserve");
1046 
1047     return true;
1048   }
1049 
1050   function redeem(uint256 tokens) public whenNotPaused {
1051     require(tokens > 0, "amount of tokens redeemed must be > 0");
1052 
1053     uint256 fee = tokens.mul(redemptionFee).div(percentage);
1054 
1055     _burn(msg.sender, tokens.sub(fee));
1056     if (fee > 0) {
1057       require(super.transfer(feeReturnAddress, fee), "token transfer failed");
1058       emit FeeApplied("Redeem", msg.sender, fee);
1059     }
1060     emit TokenRedeemed(msg.sender, tokens);
1061   }
1062 
1063   function isSignatureValid(
1064     address sender, uint256 amount, uint256 tokens, 
1065     uint256 fee, uint256 timestamp, bytes signature
1066   ) public view returns (bool) 
1067   {
1068     if (block.timestamp > timestamp + 10 minutes) return false;
1069     bytes32 hash = keccak256(
1070       abi.encodePacked(
1071         address(this),
1072         sender, 
1073         amount, 
1074         tokens,
1075         fee,
1076         timestamp
1077       )
1078     );
1079     return hash.toEthSignedMessageHash().recover(signature) == owner;
1080   }
1081 
1082   function isConvertSignatureValid(
1083     address sender, uint256 amountSLVT, uint256 amountSLVD, 
1084     uint256 timestamp, bytes signature
1085   ) public view returns (bool) 
1086   {
1087     if (block.timestamp > timestamp + 10 minutes) return false;
1088     bytes32 hash = keccak256(
1089       abi.encodePacked(
1090         address(this),
1091         sender, 
1092         amountSLVT, 
1093         amountSLVD,
1094         timestamp
1095       )
1096     );
1097     return hash.toEthSignedMessageHash().recover(signature) == owner;
1098   }
1099 
1100   function convertToSLVD(
1101     uint256 amountSLVT, uint256 amountSLVD,
1102     uint256 timestamp, bytes signature
1103   ) public isConvertible whenNotPaused returns (bool) {
1104     require(
1105       isConvertSignatureValid(
1106         msg.sender, amountSLVT, 
1107         amountSLVD, timestamp, signature
1108       ), 
1109       "convert failed, invalid signature"
1110     );
1111 
1112     uint256 fees = amountSLVT.mul(convertFee).div(percentage);
1113     if (whitelist(msg.sender) && Whitelist(silverDollarAddress).whitelist(msg.sender))
1114       fees = 0;
1115 
1116     super.transfer(SLVTReserve, amountSLVT.sub(fees));
1117     require(super.transfer(feeReturnAddress, fees), "transfer fee payment failed");
1118     require(
1119       ASilverDollar(silverDollarAddress).purchaseWithSilverToken(msg.sender, amountSLVD), 
1120       "failed purchase of silverdollar with silvertoken"
1121     );
1122     
1123     emit Converted(msg.sender, amountSLVD, amountSLVD, fees);
1124     return true;
1125   }
1126 }