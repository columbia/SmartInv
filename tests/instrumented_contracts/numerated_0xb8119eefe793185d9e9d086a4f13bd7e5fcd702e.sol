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
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
56 
57 /**
58  * @title ERC20Basic
59  * @dev Simpler version of ERC20 interface
60  * @dev see https://github.com/ethereum/EIPs/issues/179
61  */
62 contract ERC20Basic {
63   function totalSupply() public view returns (uint256);
64   function balanceOf(address who) public view returns (uint256);
65   function transfer(address to, uint256 value) public returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
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
78   mapping(address => uint256) balances;
79 
80   uint256 totalSupply_;
81 
82   /**
83   * @dev total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_to != address(0));
96     require(_value <= balances[msg.sender]);
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
115 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
116 
117 /**
118  * @title Burnable Token
119  * @dev Token that can be irreversibly burned (destroyed).
120  */
121 contract BurnableToken is BasicToken {
122 
123   event Burn(address indexed burner, uint256 value);
124 
125   /**
126    * @dev Burns a specific amount of tokens.
127    * @param _value The amount of token to be burned.
128    */
129   function burn(uint256 _value) public {
130     _burn(msg.sender, _value);
131   }
132 
133   function _burn(address _who, uint256 _value) internal {
134     require(_value <= balances[_who]);
135     // no need to require value <= totalSupply, since that would imply the
136     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
137 
138     balances[_who] = balances[_who].sub(_value);
139     totalSupply_ = totalSupply_.sub(_value);
140     emit Burn(_who, _value);
141     emit Transfer(_who, address(0), _value);
142   }
143 }
144 
145 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
146 
147 /**
148  * @title ERC20 interface
149  * @dev see https://github.com/ethereum/EIPs/issues/20
150  */
151 contract ERC20 is ERC20Basic {
152   function allowance(address owner, address spender)
153     public view returns (uint256);
154 
155   function transferFrom(address from, address to, uint256 value)
156     public returns (bool);
157 
158   function approve(address spender, uint256 value) public returns (bool);
159   event Approval(
160     address indexed owner,
161     address indexed spender,
162     uint256 value
163   );
164 }
165 
166 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
167 
168 /**
169  * @title DetailedERC20 token
170  * @dev The decimals are only for visualization purposes.
171  * All the operations are done using the smallest and indivisible token unit,
172  * just as on Ethereum all the operations are done in wei.
173  */
174 contract DetailedERC20 is ERC20 {
175   string public name;
176   string public symbol;
177   uint8 public decimals;
178 
179   constructor(string _name, string _symbol, uint8 _decimals) public {
180     name = _name;
181     symbol = _symbol;
182     decimals = _decimals;
183   }
184 }
185 
186 // File: openzeppelin-solidity/contracts/ownership/rbac/Roles.sol
187 
188 /**
189  * @title Roles
190  * @author Francisco Giordano (@frangio)
191  * @dev Library for managing addresses assigned to a Role.
192  *      See RBAC.sol for example usage.
193  */
194 library Roles {
195   struct Role {
196     mapping (address => bool) bearer;
197   }
198 
199   /**
200    * @dev give an address access to this role
201    */
202   function add(Role storage role, address addr)
203     internal
204   {
205     role.bearer[addr] = true;
206   }
207 
208   /**
209    * @dev remove an address' access to this role
210    */
211   function remove(Role storage role, address addr)
212     internal
213   {
214     role.bearer[addr] = false;
215   }
216 
217   /**
218    * @dev check if an address has this role
219    * // reverts
220    */
221   function check(Role storage role, address addr)
222     view
223     internal
224   {
225     require(has(role, addr));
226   }
227 
228   /**
229    * @dev check if an address has this role
230    * @return bool
231    */
232   function has(Role storage role, address addr)
233     view
234     internal
235     returns (bool)
236   {
237     return role.bearer[addr];
238   }
239 }
240 
241 // File: openzeppelin-solidity/contracts/ownership/rbac/RBAC.sol
242 
243 /**
244  * @title RBAC (Role-Based Access Control)
245  * @author Matt Condon (@Shrugs)
246  * @dev Stores and provides setters and getters for roles and addresses.
247  * @dev Supports unlimited numbers of roles and addresses.
248  * @dev See //contracts/mocks/RBACMock.sol for an example of usage.
249  * This RBAC method uses strings to key roles. It may be beneficial
250  *  for you to write your own implementation of this interface using Enums or similar.
251  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
252  *  to avoid typos.
253  */
254 contract RBAC {
255   using Roles for Roles.Role;
256 
257   mapping (string => Roles.Role) private roles;
258 
259   event RoleAdded(address addr, string roleName);
260   event RoleRemoved(address addr, string roleName);
261 
262   /**
263    * @dev reverts if addr does not have role
264    * @param addr address
265    * @param roleName the name of the role
266    * // reverts
267    */
268   function checkRole(address addr, string roleName)
269     view
270     public
271   {
272     roles[roleName].check(addr);
273   }
274 
275   /**
276    * @dev determine if addr has role
277    * @param addr address
278    * @param roleName the name of the role
279    * @return bool
280    */
281   function hasRole(address addr, string roleName)
282     view
283     public
284     returns (bool)
285   {
286     return roles[roleName].has(addr);
287   }
288 
289   /**
290    * @dev add a role to an address
291    * @param addr address
292    * @param roleName the name of the role
293    */
294   function addRole(address addr, string roleName)
295     internal
296   {
297     roles[roleName].add(addr);
298     emit RoleAdded(addr, roleName);
299   }
300 
301   /**
302    * @dev remove a role from an address
303    * @param addr address
304    * @param roleName the name of the role
305    */
306   function removeRole(address addr, string roleName)
307     internal
308   {
309     roles[roleName].remove(addr);
310     emit RoleRemoved(addr, roleName);
311   }
312 
313   /**
314    * @dev modifier to scope access to a single role (uses msg.sender as addr)
315    * @param roleName the name of the role
316    * // reverts
317    */
318   modifier onlyRole(string roleName)
319   {
320     checkRole(msg.sender, roleName);
321     _;
322   }
323 
324   /**
325    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
326    * @param roleNames the names of the roles to scope access to
327    * // reverts
328    *
329    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
330    *  see: https://github.com/ethereum/solidity/issues/2467
331    */
332   // modifier onlyRoles(string[] roleNames) {
333   //     bool hasAnyRole = false;
334   //     for (uint8 i = 0; i < roleNames.length; i++) {
335   //         if (hasRole(msg.sender, roleNames[i])) {
336   //             hasAnyRole = true;
337   //             break;
338   //         }
339   //     }
340 
341   //     require(hasAnyRole);
342 
343   //     _;
344   // }
345 }
346 
347 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
348 
349 /**
350  * @title Ownable
351  * @dev The Ownable contract has an owner address, and provides basic authorization control
352  * functions, this simplifies the implementation of "user permissions".
353  */
354 contract Ownable {
355   address public owner;
356 
357 
358   event OwnershipRenounced(address indexed previousOwner);
359   event OwnershipTransferred(
360     address indexed previousOwner,
361     address indexed newOwner
362   );
363 
364 
365   /**
366    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
367    * account.
368    */
369   constructor() public {
370     owner = msg.sender;
371   }
372 
373   /**
374    * @dev Throws if called by any account other than the owner.
375    */
376   modifier onlyOwner() {
377     require(msg.sender == owner);
378     _;
379   }
380 
381   /**
382    * @dev Allows the current owner to relinquish control of the contract.
383    */
384   function renounceOwnership() public onlyOwner {
385     emit OwnershipRenounced(owner);
386     owner = address(0);
387   }
388 
389   /**
390    * @dev Allows the current owner to transfer control of the contract to a newOwner.
391    * @param _newOwner The address to transfer ownership to.
392    */
393   function transferOwnership(address _newOwner) public onlyOwner {
394     _transferOwnership(_newOwner);
395   }
396 
397   /**
398    * @dev Transfers control of the contract to a newOwner.
399    * @param _newOwner The address to transfer ownership to.
400    */
401   function _transferOwnership(address _newOwner) internal {
402     require(_newOwner != address(0));
403     emit OwnershipTransferred(owner, _newOwner);
404     owner = _newOwner;
405   }
406 }
407 
408 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
409 
410 /**
411  * @title Standard ERC20 token
412  *
413  * @dev Implementation of the basic standard token.
414  * @dev https://github.com/ethereum/EIPs/issues/20
415  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
416  */
417 contract StandardToken is ERC20, BasicToken {
418 
419   mapping (address => mapping (address => uint256)) internal allowed;
420 
421 
422   /**
423    * @dev Transfer tokens from one address to another
424    * @param _from address The address which you want to send tokens from
425    * @param _to address The address which you want to transfer to
426    * @param _value uint256 the amount of tokens to be transferred
427    */
428   function transferFrom(
429     address _from,
430     address _to,
431     uint256 _value
432   )
433     public
434     returns (bool)
435   {
436     require(_to != address(0));
437     require(_value <= balances[_from]);
438     require(_value <= allowed[_from][msg.sender]);
439 
440     balances[_from] = balances[_from].sub(_value);
441     balances[_to] = balances[_to].add(_value);
442     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
443     emit Transfer(_from, _to, _value);
444     return true;
445   }
446 
447   /**
448    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
449    *
450    * Beware that changing an allowance with this method brings the risk that someone may use both the old
451    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
452    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
453    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
454    * @param _spender The address which will spend the funds.
455    * @param _value The amount of tokens to be spent.
456    */
457   function approve(address _spender, uint256 _value) public returns (bool) {
458     allowed[msg.sender][_spender] = _value;
459     emit Approval(msg.sender, _spender, _value);
460     return true;
461   }
462 
463   /**
464    * @dev Function to check the amount of tokens that an owner allowed to a spender.
465    * @param _owner address The address which owns the funds.
466    * @param _spender address The address which will spend the funds.
467    * @return A uint256 specifying the amount of tokens still available for the spender.
468    */
469   function allowance(
470     address _owner,
471     address _spender
472    )
473     public
474     view
475     returns (uint256)
476   {
477     return allowed[_owner][_spender];
478   }
479 
480   /**
481    * @dev Increase the amount of tokens that an owner allowed to a spender.
482    *
483    * approve should be called when allowed[_spender] == 0. To increment
484    * allowed value is better to use this function to avoid 2 calls (and wait until
485    * the first transaction is mined)
486    * From MonolithDAO Token.sol
487    * @param _spender The address which will spend the funds.
488    * @param _addedValue The amount of tokens to increase the allowance by.
489    */
490   function increaseApproval(
491     address _spender,
492     uint _addedValue
493   )
494     public
495     returns (bool)
496   {
497     allowed[msg.sender][_spender] = (
498       allowed[msg.sender][_spender].add(_addedValue));
499     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
500     return true;
501   }
502 
503   /**
504    * @dev Decrease the amount of tokens that an owner allowed to a spender.
505    *
506    * approve should be called when allowed[_spender] == 0. To decrement
507    * allowed value is better to use this function to avoid 2 calls (and wait until
508    * the first transaction is mined)
509    * From MonolithDAO Token.sol
510    * @param _spender The address which will spend the funds.
511    * @param _subtractedValue The amount of tokens to decrease the allowance by.
512    */
513   function decreaseApproval(
514     address _spender,
515     uint _subtractedValue
516   )
517     public
518     returns (bool)
519   {
520     uint oldValue = allowed[msg.sender][_spender];
521     if (_subtractedValue > oldValue) {
522       allowed[msg.sender][_spender] = 0;
523     } else {
524       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
525     }
526     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
527     return true;
528   }
529 
530 }
531 
532 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
533 
534 /**
535  * @title Mintable token
536  * @dev Simple ERC20 Token example, with mintable token creation
537  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
538  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
539  */
540 contract MintableToken is StandardToken, Ownable {
541   event Mint(address indexed to, uint256 amount);
542   event MintFinished();
543 
544   bool public mintingFinished = false;
545 
546 
547   modifier canMint() {
548     require(!mintingFinished);
549     _;
550   }
551 
552   modifier hasMintPermission() {
553     require(msg.sender == owner);
554     _;
555   }
556 
557   /**
558    * @dev Function to mint tokens
559    * @param _to The address that will receive the minted tokens.
560    * @param _amount The amount of tokens to mint.
561    * @return A boolean that indicates if the operation was successful.
562    */
563   function mint(
564     address _to,
565     uint256 _amount
566   )
567     hasMintPermission
568     canMint
569     public
570     returns (bool)
571   {
572     totalSupply_ = totalSupply_.add(_amount);
573     balances[_to] = balances[_to].add(_amount);
574     emit Mint(_to, _amount);
575     emit Transfer(address(0), _to, _amount);
576     return true;
577   }
578 
579   /**
580    * @dev Function to stop minting new tokens.
581    * @return True if the operation was successful.
582    */
583   function finishMinting() onlyOwner canMint public returns (bool) {
584     mintingFinished = true;
585     emit MintFinished();
586     return true;
587   }
588 }
589 
590 // File: openzeppelin-solidity/contracts/token/ERC20/RBACMintableToken.sol
591 
592 /**
593  * @title RBACMintableToken
594  * @author Vittorio Minacori (@vittominacori)
595  * @dev Mintable Token, with RBAC minter permissions
596  */
597 contract RBACMintableToken is MintableToken, RBAC {
598   /**
599    * A constant role name for indicating minters.
600    */
601   string public constant ROLE_MINTER = "minter";
602 
603   /**
604    * @dev override the Mintable token modifier to add role based logic
605    */
606   modifier hasMintPermission() {
607     checkRole(msg.sender, ROLE_MINTER);
608     _;
609   }
610 
611   /**
612    * @dev add a minter role to an address
613    * @param minter address
614    */
615   function addMinter(address minter) onlyOwner public {
616     addRole(minter, ROLE_MINTER);
617   }
618 
619   /**
620    * @dev remove a minter role from an address
621    * @param minter address
622    */
623   function removeMinter(address minter) onlyOwner public {
624     removeRole(minter, ROLE_MINTER);
625   }
626 }
627 
628 // File: openzeppelin-solidity/contracts/token/ERC827/ERC827.sol
629 
630 /**
631  * @title ERC827 interface, an extension of ERC20 token standard
632  *
633  * @dev Interface of a ERC827 token, following the ERC20 standard with extra
634  * @dev methods to transfer value and data and execute calls in transfers and
635  * @dev approvals.
636  */
637 contract ERC827 is ERC20 {
638   function approveAndCall(
639     address _spender,
640     uint256 _value,
641     bytes _data
642   )
643     public
644     payable
645     returns (bool);
646 
647   function transferAndCall(
648     address _to,
649     uint256 _value,
650     bytes _data
651   )
652     public
653     payable
654     returns (bool);
655 
656   function transferFromAndCall(
657     address _from,
658     address _to,
659     uint256 _value,
660     bytes _data
661   )
662     public
663     payable
664     returns (bool);
665 }
666 
667 // File: openzeppelin-solidity/contracts/token/ERC827/ERC827Token.sol
668 
669 /* solium-disable security/no-low-level-calls */
670 
671 pragma solidity ^0.4.23;
672 
673 
674 
675 
676 /**
677  * @title ERC827, an extension of ERC20 token standard
678  *
679  * @dev Implementation the ERC827, following the ERC20 standard with extra
680  * @dev methods to transfer value and data and execute calls in transfers and
681  * @dev approvals.
682  *
683  * @dev Uses OpenZeppelin StandardToken.
684  */
685 contract ERC827Token is ERC827, StandardToken {
686 
687   /**
688    * @dev Addition to ERC20 token methods. It allows to
689    * @dev approve the transfer of value and execute a call with the sent data.
690    *
691    * @dev Beware that changing an allowance with this method brings the risk that
692    * @dev someone may use both the old and the new allowance by unfortunate
693    * @dev transaction ordering. One possible solution to mitigate this race condition
694    * @dev is to first reduce the spender's allowance to 0 and set the desired value
695    * @dev afterwards:
696    * @dev https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
697    *
698    * @param _spender The address that will spend the funds.
699    * @param _value The amount of tokens to be spent.
700    * @param _data ABI-encoded contract call to call `_to` address.
701    *
702    * @return true if the call function was executed successfully
703    */
704   function approveAndCall(
705     address _spender,
706     uint256 _value,
707     bytes _data
708   )
709     public
710     payable
711     returns (bool)
712   {
713     require(_spender != address(this));
714 
715     super.approve(_spender, _value);
716 
717     // solium-disable-next-line security/no-call-value
718     require(_spender.call.value(msg.value)(_data));
719 
720     return true;
721   }
722 
723   /**
724    * @dev Addition to ERC20 token methods. Transfer tokens to a specified
725    * @dev address and execute a call with the sent data on the same transaction
726    *
727    * @param _to address The address which you want to transfer to
728    * @param _value uint256 the amout of tokens to be transfered
729    * @param _data ABI-encoded contract call to call `_to` address.
730    *
731    * @return true if the call function was executed successfully
732    */
733   function transferAndCall(
734     address _to,
735     uint256 _value,
736     bytes _data
737   )
738     public
739     payable
740     returns (bool)
741   {
742     require(_to != address(this));
743 
744     super.transfer(_to, _value);
745 
746     // solium-disable-next-line security/no-call-value
747     require(_to.call.value(msg.value)(_data));
748     return true;
749   }
750 
751   /**
752    * @dev Addition to ERC20 token methods. Transfer tokens from one address to
753    * @dev another and make a contract call on the same transaction
754    *
755    * @param _from The address which you want to send tokens from
756    * @param _to The address which you want to transfer to
757    * @param _value The amout of tokens to be transferred
758    * @param _data ABI-encoded contract call to call `_to` address.
759    *
760    * @return true if the call function was executed successfully
761    */
762   function transferFromAndCall(
763     address _from,
764     address _to,
765     uint256 _value,
766     bytes _data
767   )
768     public payable returns (bool)
769   {
770     require(_to != address(this));
771 
772     super.transferFrom(_from, _to, _value);
773 
774     // solium-disable-next-line security/no-call-value
775     require(_to.call.value(msg.value)(_data));
776     return true;
777   }
778 
779   /**
780    * @dev Addition to StandardToken methods. Increase the amount of tokens that
781    * @dev an owner allowed to a spender and execute a call with the sent data.
782    *
783    * @dev approve should be called when allowed[_spender] == 0. To increment
784    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
785    * @dev the first transaction is mined)
786    * @dev From MonolithDAO Token.sol
787    *
788    * @param _spender The address which will spend the funds.
789    * @param _addedValue The amount of tokens to increase the allowance by.
790    * @param _data ABI-encoded contract call to call `_spender` address.
791    */
792   function increaseApprovalAndCall(
793     address _spender,
794     uint _addedValue,
795     bytes _data
796   )
797     public
798     payable
799     returns (bool)
800   {
801     require(_spender != address(this));
802 
803     super.increaseApproval(_spender, _addedValue);
804 
805     // solium-disable-next-line security/no-call-value
806     require(_spender.call.value(msg.value)(_data));
807 
808     return true;
809   }
810 
811   /**
812    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
813    * @dev an owner allowed to a spender and execute a call with the sent data.
814    *
815    * @dev approve should be called when allowed[_spender] == 0. To decrement
816    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
817    * @dev the first transaction is mined)
818    * @dev From MonolithDAO Token.sol
819    *
820    * @param _spender The address which will spend the funds.
821    * @param _subtractedValue The amount of tokens to decrease the allowance by.
822    * @param _data ABI-encoded contract call to call `_spender` address.
823    */
824   function decreaseApprovalAndCall(
825     address _spender,
826     uint _subtractedValue,
827     bytes _data
828   )
829     public
830     payable
831     returns (bool)
832   {
833     require(_spender != address(this));
834 
835     super.decreaseApproval(_spender, _subtractedValue);
836 
837     // solium-disable-next-line security/no-call-value
838     require(_spender.call.value(msg.value)(_data));
839 
840     return true;
841   }
842 
843 }
844 
845 // File: contracts/GastroAdvisorToken.sol
846 
847 contract GastroAdvisorToken is DetailedERC20, ERC827Token, RBACMintableToken, BurnableToken {
848 
849   modifier canTransfer() {
850     require(mintingFinished);
851     _;
852   }
853 
854   constructor()
855   DetailedERC20("GastroAdvisorToken", "FORK", 18)
856   public
857   {}
858 
859   function transfer(address _to, uint256 _value) canTransfer public returns (bool) {
860     return super.transfer(_to, _value);
861   }
862 
863   function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool) {
864     return super.transferFrom(_from, _to, _value);
865   }
866 
867   function transferAndCall(
868     address _to,
869     uint256 _value,
870     bytes _data)
871   canTransfer public payable returns (bool)
872   {
873     return super.transferAndCall(_to, _value, _data);
874   }
875 
876   function transferFromAndCall(
877     address _from,
878     address _to,
879     uint256 _value,
880     bytes _data)
881   canTransfer public payable returns (bool)
882   {
883     return super.transferFromAndCall(
884       _from,
885       _to,
886       _value,
887       _data
888     );
889   }
890 
891   function transferAnyERC20Token(address _tokenAddress, uint256 _tokens) onlyOwner public returns (bool success) {
892     return ERC20Basic(_tokenAddress).transfer(owner, _tokens);
893   }
894 }
895 
896 // File: contracts/CappedBountyMinter.sol
897 
898 contract CappedBountyMinter is Ownable {
899   using SafeMath for uint256;
900 
901   GastroAdvisorToken public token;
902 
903   uint256 public cap;
904   uint256 public totalGivenBountyTokens;
905   mapping (address => uint256) public givenBountyTokens;
906 
907   uint256 decimals;
908 
909   constructor(address _token, uint256 _cap) public {
910     require(_token != address(0));
911     require(_cap > 0);
912 
913     token = GastroAdvisorToken(_token);
914 
915     decimals = uint256(token.decimals());
916     cap = _cap * (10 ** decimals);
917   }
918 
919   function multiSend(address[] addresses, uint256[] amounts) public onlyOwner {
920     require(addresses.length > 0);
921     require(amounts.length > 0);
922     require(addresses.length == amounts.length);
923 
924     for (uint i = 0; i < addresses.length; i++) {
925       address to = addresses[i];
926       uint256 value = amounts[i] * (10 ** decimals);
927 
928       givenBountyTokens[to] = givenBountyTokens[to].add(value);
929       totalGivenBountyTokens = totalGivenBountyTokens.add(value);
930 
931       require(totalGivenBountyTokens <= cap);
932 
933       token.mint(to, value);
934     }
935   }
936 
937   function remainingTokens() public view returns(uint256) {
938     return cap.sub(totalGivenBountyTokens);
939   }
940 
941   function transferAnyERC20Token(address _tokenAddress, uint256 _tokens) onlyOwner public returns (bool success) {
942     return ERC20Basic(_tokenAddress).transfer(owner, _tokens);
943   }
944 }