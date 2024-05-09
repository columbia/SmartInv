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
321 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
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
378 // File: openzeppelin-solidity/contracts/token/ERC20/CappedToken.sol
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
413 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
414 
415 /**
416  * @title DetailedERC20 token
417  * @dev The decimals are only for visualization purposes.
418  * All the operations are done using the smallest and indivisible token unit,
419  * just as on Ethereum all the operations are done in wei.
420  */
421 contract DetailedERC20 is ERC20 {
422   string public name;
423   string public symbol;
424   uint8 public decimals;
425 
426   constructor(string _name, string _symbol, uint8 _decimals) public {
427     name = _name;
428     symbol = _symbol;
429     decimals = _decimals;
430   }
431 }
432 
433 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
434 
435 /**
436  * @title Pausable
437  * @dev Base contract which allows children to implement an emergency stop mechanism.
438  */
439 contract Pausable is Ownable {
440   event Pause();
441   event Unpause();
442 
443   bool public paused = false;
444 
445 
446   /**
447    * @dev Modifier to make a function callable only when the contract is not paused.
448    */
449   modifier whenNotPaused() {
450     require(!paused);
451     _;
452   }
453 
454   /**
455    * @dev Modifier to make a function callable only when the contract is paused.
456    */
457   modifier whenPaused() {
458     require(paused);
459     _;
460   }
461 
462   /**
463    * @dev called by the owner to pause, triggers stopped state
464    */
465   function pause() public onlyOwner whenNotPaused {
466     paused = true;
467     emit Pause();
468   }
469 
470   /**
471    * @dev called by the owner to unpause, returns to normal state
472    */
473   function unpause() public onlyOwner whenPaused {
474     paused = false;
475     emit Unpause();
476   }
477 }
478 
479 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
480 
481 /**
482  * @title Pausable token
483  * @dev StandardToken modified with pausable transfers.
484  **/
485 contract PausableToken is StandardToken, Pausable {
486 
487   function transfer(
488     address _to,
489     uint256 _value
490   )
491     public
492     whenNotPaused
493     returns (bool)
494   {
495     return super.transfer(_to, _value);
496   }
497 
498   function transferFrom(
499     address _from,
500     address _to,
501     uint256 _value
502   )
503     public
504     whenNotPaused
505     returns (bool)
506   {
507     return super.transferFrom(_from, _to, _value);
508   }
509 
510   function approve(
511     address _spender,
512     uint256 _value
513   )
514     public
515     whenNotPaused
516     returns (bool)
517   {
518     return super.approve(_spender, _value);
519   }
520 
521   function increaseApproval(
522     address _spender,
523     uint _addedValue
524   )
525     public
526     whenNotPaused
527     returns (bool success)
528   {
529     return super.increaseApproval(_spender, _addedValue);
530   }
531 
532   function decreaseApproval(
533     address _spender,
534     uint _subtractedValue
535   )
536     public
537     whenNotPaused
538     returns (bool success)
539   {
540     return super.decreaseApproval(_spender, _subtractedValue);
541   }
542 }
543 
544 // File: openzeppelin-solidity/contracts/access/rbac/Roles.sol
545 
546 /**
547  * @title Roles
548  * @author Francisco Giordano (@frangio)
549  * @dev Library for managing addresses assigned to a Role.
550  * See RBAC.sol for example usage.
551  */
552 library Roles {
553   struct Role {
554     mapping (address => bool) bearer;
555   }
556 
557   /**
558    * @dev give an address access to this role
559    */
560   function add(Role storage _role, address _addr)
561     internal
562   {
563     _role.bearer[_addr] = true;
564   }
565 
566   /**
567    * @dev remove an address' access to this role
568    */
569   function remove(Role storage _role, address _addr)
570     internal
571   {
572     _role.bearer[_addr] = false;
573   }
574 
575   /**
576    * @dev check if an address has this role
577    * // reverts
578    */
579   function check(Role storage _role, address _addr)
580     internal
581     view
582   {
583     require(has(_role, _addr));
584   }
585 
586   /**
587    * @dev check if an address has this role
588    * @return bool
589    */
590   function has(Role storage _role, address _addr)
591     internal
592     view
593     returns (bool)
594   {
595     return _role.bearer[_addr];
596   }
597 }
598 
599 // File: openzeppelin-solidity/contracts/access/rbac/RBAC.sol
600 
601 /**
602  * @title RBAC (Role-Based Access Control)
603  * @author Matt Condon (@Shrugs)
604  * @dev Stores and provides setters and getters for roles and addresses.
605  * Supports unlimited numbers of roles and addresses.
606  * See //contracts/mocks/RBACMock.sol for an example of usage.
607  * This RBAC method uses strings to key roles. It may be beneficial
608  * for you to write your own implementation of this interface using Enums or similar.
609  */
610 contract RBAC {
611   using Roles for Roles.Role;
612 
613   mapping (string => Roles.Role) private roles;
614 
615   event RoleAdded(address indexed operator, string role);
616   event RoleRemoved(address indexed operator, string role);
617 
618   /**
619    * @dev reverts if addr does not have role
620    * @param _operator address
621    * @param _role the name of the role
622    * // reverts
623    */
624   function checkRole(address _operator, string _role)
625     public
626     view
627   {
628     roles[_role].check(_operator);
629   }
630 
631   /**
632    * @dev determine if addr has role
633    * @param _operator address
634    * @param _role the name of the role
635    * @return bool
636    */
637   function hasRole(address _operator, string _role)
638     public
639     view
640     returns (bool)
641   {
642     return roles[_role].has(_operator);
643   }
644 
645   /**
646    * @dev add a role to an address
647    * @param _operator address
648    * @param _role the name of the role
649    */
650   function addRole(address _operator, string _role)
651     internal
652   {
653     roles[_role].add(_operator);
654     emit RoleAdded(_operator, _role);
655   }
656 
657   /**
658    * @dev remove a role from an address
659    * @param _operator address
660    * @param _role the name of the role
661    */
662   function removeRole(address _operator, string _role)
663     internal
664   {
665     roles[_role].remove(_operator);
666     emit RoleRemoved(_operator, _role);
667   }
668 
669   /**
670    * @dev modifier to scope access to a single role (uses msg.sender as addr)
671    * @param _role the name of the role
672    * // reverts
673    */
674   modifier onlyRole(string _role)
675   {
676     checkRole(msg.sender, _role);
677     _;
678   }
679 
680   /**
681    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
682    * @param _roles the names of the roles to scope access to
683    * // reverts
684    *
685    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
686    *  see: https://github.com/ethereum/solidity/issues/2467
687    */
688   // modifier onlyRoles(string[] _roles) {
689   //     bool hasAnyRole = false;
690   //     for (uint8 i = 0; i < _roles.length; i++) {
691   //         if (hasRole(msg.sender, _roles[i])) {
692   //             hasAnyRole = true;
693   //             break;
694   //         }
695   //     }
696 
697   //     require(hasAnyRole);
698 
699   //     _;
700   // }
701 }
702 
703 // File: openzeppelin-solidity/contracts/ownership/Superuser.sol
704 
705 /**
706  * @title Superuser
707  * @dev The Superuser contract defines a single superuser who can transfer the ownership
708  * of a contract to a new address, even if he is not the owner.
709  * A superuser can transfer his role to a new address.
710  */
711 contract Superuser is Ownable, RBAC {
712   string public constant ROLE_SUPERUSER = "superuser";
713 
714   constructor () public {
715     addRole(msg.sender, ROLE_SUPERUSER);
716   }
717 
718   /**
719    * @dev Throws if called by any account that's not a superuser.
720    */
721   modifier onlySuperuser() {
722     checkRole(msg.sender, ROLE_SUPERUSER);
723     _;
724   }
725 
726   modifier onlyOwnerOrSuperuser() {
727     require(msg.sender == owner || isSuperuser(msg.sender));
728     _;
729   }
730 
731   /**
732    * @dev getter to determine if address has superuser role
733    */
734   function isSuperuser(address _addr)
735     public
736     view
737     returns (bool)
738   {
739     return hasRole(_addr, ROLE_SUPERUSER);
740   }
741 
742   /**
743    * @dev Allows the current superuser to transfer his role to a newSuperuser.
744    * @param _newSuperuser The address to transfer ownership to.
745    */
746   function transferSuperuser(address _newSuperuser) public onlySuperuser {
747     require(_newSuperuser != address(0));
748     removeRole(msg.sender, ROLE_SUPERUSER);
749     addRole(_newSuperuser, ROLE_SUPERUSER);
750   }
751 
752   /**
753    * @dev Allows the current superuser or owner to transfer control of the contract to a newOwner.
754    * @param _newOwner The address to transfer ownership to.
755    */
756   function transferOwnership(address _newOwner) public onlyOwnerOrSuperuser {
757     _transferOwnership(_newOwner);
758   }
759 }
760 
761 // File: contracts/upgrade/Recoverable.sol
762 
763 /**
764  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
765  *
766  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
767  */
768 
769 pragma solidity ^0.4.24;
770 
771 
772 
773 contract Recoverable is Ownable {
774 
775     /// @dev Empty constructor (for now)
776     constructor() public{
777     }
778 
779     /// @dev This will be invoked by the owner, when owner wants to rescue tokens
780     /// @param token Token which will we rescue to the owner from the contract
781     function recoverTokens(ERC20Basic token) public onlyOwner  {
782         token.transfer(owner, tokensToBeReturned(token));
783     }
784 
785     /// @dev Interface function, can be overwritten by the superclass
786     /// @param token Token which balance we will check and return
787     /// @return The amount of tokens (in smallest denominator) the contract owns
788     function tokensToBeReturned(ERC20Basic token) public view returns (uint) {
789         return token.balanceOf(this);
790     }
791 }
792 
793 // File: contracts/upgrade/UpgradeAgent.sol
794 
795 /**
796  * Upgrade agent interface inspired by Lunyr.
797  *
798  * Upgrade agent transfers tokens to a new contract.
799  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
800  */
801 contract UpgradeAgent {
802 
803     uint public originalSupply;
804 
805     /** Interface marker */
806     function isUpgradeAgent() public pure returns (bool) {
807         return true;
808     }
809 
810     function upgradeFrom(address _from, uint256 _value) public;
811 
812 }
813 
814 // File: contracts/token/UpgradeableToken.sol
815 
816 /**
817  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
818  *
819  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
820  */
821 
822 pragma solidity ^0.4.24;
823 
824 
825 
826 
827 
828 /**
829  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
830  *
831  * First envisioned by Golem and Lunyr projects.
832  */
833 contract UpgradeableToken is StandardToken, Recoverable {
834 
835     /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
836     address public upgradeMaster;
837 
838     /** The next contract where the tokens will be migrated. */
839     UpgradeAgent public upgradeAgent;
840 
841     /** How many tokens we have upgraded by now. */
842     uint256 public totalUpgraded;
843 
844     /**
845     * Upgrade states.
846     *
847     * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
848     * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
849     * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
850     * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
851     *
852     */
853     enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
854 
855     /**
856     * Somebody has upgraded some of his tokens.
857     */
858     event Upgrade(address indexed _from, address indexed _to, uint256 _value);
859 
860     /**
861     * New upgrade agent available.
862     */
863     event UpgradeAgentSet(address agent);
864 
865     /**
866     * Do not allow construction without upgrade master set.
867     */
868     constructor() public {
869         upgradeMaster = msg.sender;
870     }
871 
872     /**
873     * @dev Throws if called by any account other than the upgradeMaster.
874     */
875     modifier onlyUpgradeMaster() {
876         require(msg.sender == upgradeMaster, "Sender not authorized.");
877         _;
878     }
879 
880     /**
881     * Allow the token holder to upgrade some of their tokens to a new contract.
882     */
883     function upgrade(uint256 value) public {
884         // Validate input value.
885         require(value != 0, "Value parameter must be non-zero.");
886 
887         UpgradeState state = getUpgradeState();
888         require(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading, "Function called in a bad state");
889 
890         balances[msg.sender] = balances[msg.sender].sub(value);
891 
892         // Take tokens out from circulation
893         totalSupply_ = totalSupply_.sub(value);
894         totalUpgraded = totalUpgraded.add(value);
895 
896         // Upgrade agent reissues the tokens
897         upgradeAgent.upgradeFrom(msg.sender, value);
898         emit Upgrade(msg.sender, upgradeAgent, value);
899     }
900 
901     /**
902     * Set an upgrade agent that handles
903     */
904     function setUpgradeAgent(address agent) external onlyUpgradeMaster {
905         // The token is not yet in a state that we could think upgrading
906         require(canUpgrade(), "Upgrade not enabled.");
907 
908         // Upgrade has already begun for an agent
909         require(getUpgradeState() != UpgradeState.Upgrading, "Updgrade has alredy begun.");
910 
911         upgradeAgent = UpgradeAgent(agent);
912 
913         // Bad interface
914         require(upgradeAgent.isUpgradeAgent(), "Not an upgrade Agent or bad interface");
915         // Make sure that token supplies match in source and target
916         assert(upgradeAgent.originalSupply() == totalSupply_);
917 
918         emit UpgradeAgentSet(upgradeAgent);
919     }
920 
921     /**
922     * Get the state of the token upgrade.
923     */
924     function getUpgradeState() public view returns(UpgradeState) {
925         if(!canUpgrade()) return UpgradeState.NotAllowed;
926         else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
927         else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
928         else return UpgradeState.Upgrading;
929     }
930 
931     /**
932     * Change the upgrade master.
933     *
934     * This allows us to set a new owner for the upgrade mechanism.
935     */
936     function setUpgradeMaster(address master) public onlyUpgradeMaster {
937         require(master != 0x0, "New master cant be 0x0");
938         upgradeMaster = master;
939     }
940 
941     /**
942     * Child contract can enable to provide the condition when the upgrade can begun.
943     */
944     function canUpgrade() public pure returns(bool) {
945         return true;
946     }
947 
948 }
949 
950 // File: contracts/token/ReservableToken.sol
951 
952 contract ReservableToken is MintableToken {
953 
954     using SafeMath for uint256;
955     
956     //Reserved Tokens Data Structure
957     struct ReservedTokensData {
958         uint256 amount;
959         bool isReserved;
960         bool isDistributed;
961     }
962 
963     //state variables for reserved token setting 
964     mapping (address => ReservedTokensData) public reservedTokensList;
965     address[] public reservedTokensDestinations;
966     uint256 public reservedTokensDestinationsLen = 0;
967     bool reservedTokensDestinationsAreSet = false;
968 
969     //state variables for reserved token distribution
970     bool reservedTokensAreDistributed = false;
971     uint256 public distributedReservedTokensDestinationsLen = 0;
972 
973     constructor(
974         address[] addrs, 
975         uint256[] amounts
976     ) 
977         public 
978     {
979         setReservedTokensListMultiple(addrs, amounts);
980     }
981 
982     function isAddressReserved(address addr) public view returns (bool isReserved) {
983         return reservedTokensList[addr].isReserved;
984     }
985 
986     function areTokensDistributedForAddress(address addr) public view returns (bool isDistributed) {
987         return reservedTokensList[addr].isDistributed;
988     }
989 
990     function getReservedTokens(address addr) public view returns (uint256 amount) {
991         return reservedTokensList[addr].amount;
992     }
993 
994     /// distributes reserved tokens
995     function distributeReservedTokens() public canMint onlyOwner returns (bool){
996         assert(!reservedTokensAreDistributed);
997         assert(distributedReservedTokensDestinationsLen < reservedTokensDestinationsLen);
998 
999 
1000         uint startLooping = distributedReservedTokensDestinationsLen;
1001         uint256 batch = reservedTokensDestinationsLen.sub(distributedReservedTokensDestinationsLen);
1002         uint endLooping = startLooping + batch;
1003 
1004         // move reserved tokens
1005         for (uint j = startLooping; j < endLooping; j++) {
1006             address reservedAddr = reservedTokensDestinations[j];
1007             if (!areTokensDistributedForAddress(reservedAddr)) {
1008                 uint256 allocatedTokens = getReservedTokens(reservedAddr);
1009 
1010                 if (allocatedTokens > 0) {
1011                     mint(reservedAddr, allocatedTokens);
1012                 }
1013 
1014                 finalizeReservedAddress(reservedAddr);
1015                 distributedReservedTokensDestinationsLen++;
1016             }
1017         }
1018 
1019         if (distributedReservedTokensDestinationsLen == reservedTokensDestinationsLen) {
1020             reservedTokensAreDistributed = true;
1021         }
1022         return true;
1023     }
1024 
1025     function setReservedTokensListMultiple(address[] addrs, uint256[] amounts) internal canMint onlyOwner {
1026         require(!reservedTokensDestinationsAreSet, "Reserved Tokens already set");
1027         require(addrs.length == amounts.length, "Parameters must have the same length");
1028         for (uint iterator = 0; iterator < addrs.length; iterator++) {
1029             if (addrs[iterator] != address(0)) {
1030                 setReservedTokensList(addrs[iterator], amounts[iterator]);
1031             }
1032         }
1033         reservedTokensDestinationsAreSet = true;
1034     }
1035 
1036     function setReservedTokensList(address addr, uint256 amount) internal canMint onlyOwner {
1037         assert(addr != address(0));
1038         if (!isAddressReserved(addr)) {
1039             reservedTokensDestinations.push(addr);
1040             reservedTokensDestinationsLen++;
1041         }
1042 
1043         reservedTokensList[addr] = ReservedTokensData({
1044             amount: amount,
1045             isReserved: true,
1046             isDistributed: false
1047         });
1048     }
1049 
1050     function finalizeReservedAddress(address addr) internal onlyOwner {
1051         ReservedTokensData storage reservedTokensData = reservedTokensList[addr];
1052         reservedTokensData.isDistributed = true;
1053     }
1054 }
1055 
1056 // File: contracts/FoodNationToken.sol
1057 
1058 contract FoodNationToken is StandardToken, MintableToken, CappedToken, DetailedERC20, PausableToken, UpgradeableToken, ReservableToken, Superuser {
1059 
1060     constructor(
1061         string _name, 
1062         string _symbol, 
1063         uint8 _decimals, 
1064         uint256 _cap, 
1065         address[] _addrs, 
1066         uint256[] _amounts
1067     )
1068         DetailedERC20(_name, _symbol, _decimals)
1069         CappedToken(_cap)
1070         ReservableToken(_addrs, _amounts)
1071         public
1072     {
1073 
1074     }
1075 }