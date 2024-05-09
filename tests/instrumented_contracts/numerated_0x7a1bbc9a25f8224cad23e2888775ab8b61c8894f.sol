1 pragma solidity ^0.4.23;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
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
24   function allowance(address owner, address spender)
25     public view returns (uint256);
26 
27   function transferFrom(address from, address to, uint256 value)
28     public returns (bool);
29 
30   function approve(address spender, uint256 value) public returns (bool);
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
39 
40 /**
41  * @title SafeERC20
42  * @dev Wrappers around ERC20 operations that throw on failure.
43  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
44  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
45  */
46 library SafeERC20 {
47   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
48     require(token.transfer(to, value));
49   }
50 
51   function safeTransferFrom(
52     ERC20 token,
53     address from,
54     address to,
55     uint256 value
56   )
57     internal
58   {
59     require(token.transferFrom(from, to, value));
60   }
61 
62   function safeApprove(ERC20 token, address spender, uint256 value) internal {
63     require(token.approve(spender, value));
64   }
65 }
66 
67 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
68 
69 /**
70  * @title Ownable
71  * @dev The Ownable contract has an owner address, and provides basic authorization control
72  * functions, this simplifies the implementation of "user permissions".
73  */
74 contract Ownable {
75   address public owner;
76 
77 
78   event OwnershipRenounced(address indexed previousOwner);
79   event OwnershipTransferred(
80     address indexed previousOwner,
81     address indexed newOwner
82   );
83 
84 
85   /**
86    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
87    * account.
88    */
89   constructor() public {
90     owner = msg.sender;
91   }
92 
93   /**
94    * @dev Throws if called by any account other than the owner.
95    */
96   modifier onlyOwner() {
97     require(msg.sender == owner);
98     _;
99   }
100 
101   /**
102    * @dev Allows the current owner to relinquish control of the contract.
103    */
104   function renounceOwnership() public onlyOwner {
105     emit OwnershipRenounced(owner);
106     owner = address(0);
107   }
108 
109   /**
110    * @dev Allows the current owner to transfer control of the contract to a newOwner.
111    * @param _newOwner The address to transfer ownership to.
112    */
113   function transferOwnership(address _newOwner) public onlyOwner {
114     _transferOwnership(_newOwner);
115   }
116 
117   /**
118    * @dev Transfers control of the contract to a newOwner.
119    * @param _newOwner The address to transfer ownership to.
120    */
121   function _transferOwnership(address _newOwner) internal {
122     require(_newOwner != address(0));
123     emit OwnershipTransferred(owner, _newOwner);
124     owner = _newOwner;
125   }
126 }
127 
128 // File: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol
129 
130 /**
131  * @title Contracts that should be able to recover tokens
132  * @author SylTi
133  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
134  * This will prevent any accidental loss of tokens.
135  */
136 contract CanReclaimToken is Ownable {
137   using SafeERC20 for ERC20Basic;
138 
139   /**
140    * @dev Reclaim all ERC20Basic compatible tokens
141    * @param token ERC20Basic The address of the token contract
142    */
143   function reclaimToken(ERC20Basic token) external onlyOwner {
144     uint256 balance = token.balanceOf(this);
145     token.safeTransfer(owner, balance);
146   }
147 
148 }
149 
150 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
151 
152 /**
153  * @title Pausable
154  * @dev Base contract which allows children to implement an emergency stop mechanism.
155  */
156 contract Pausable is Ownable {
157   event Pause();
158   event Unpause();
159 
160   bool public paused = false;
161 
162 
163   /**
164    * @dev Modifier to make a function callable only when the contract is not paused.
165    */
166   modifier whenNotPaused() {
167     require(!paused);
168     _;
169   }
170 
171   /**
172    * @dev Modifier to make a function callable only when the contract is paused.
173    */
174   modifier whenPaused() {
175     require(paused);
176     _;
177   }
178 
179   /**
180    * @dev called by the owner to pause, triggers stopped state
181    */
182   function pause() onlyOwner whenNotPaused public {
183     paused = true;
184     emit Pause();
185   }
186 
187   /**
188    * @dev called by the owner to unpause, returns to normal state
189    */
190   function unpause() onlyOwner whenPaused public {
191     paused = false;
192     emit Unpause();
193   }
194 }
195 
196 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
197 
198 /**
199  * @title SafeMath
200  * @dev Math operations with safety checks that throw on error
201  */
202 library SafeMath {
203 
204   /**
205   * @dev Multiplies two numbers, throws on overflow.
206   */
207   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
208     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
209     // benefit is lost if 'b' is also tested.
210     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
211     if (a == 0) {
212       return 0;
213     }
214 
215     c = a * b;
216     assert(c / a == b);
217     return c;
218   }
219 
220   /**
221   * @dev Integer division of two numbers, truncating the quotient.
222   */
223   function div(uint256 a, uint256 b) internal pure returns (uint256) {
224     // assert(b > 0); // Solidity automatically throws when dividing by 0
225     // uint256 c = a / b;
226     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
227     return a / b;
228   }
229 
230   /**
231   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
232   */
233   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
234     assert(b <= a);
235     return a - b;
236   }
237 
238   /**
239   * @dev Adds two numbers, throws on overflow.
240   */
241   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
242     c = a + b;
243     assert(c >= a);
244     return c;
245   }
246 }
247 
248 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
249 
250 /**
251  * @title Basic token
252  * @dev Basic version of StandardToken, with no allowances.
253  */
254 contract BasicToken is ERC20Basic {
255   using SafeMath for uint256;
256 
257   mapping(address => uint256) balances;
258 
259   uint256 totalSupply_;
260 
261   /**
262   * @dev total number of tokens in existence
263   */
264   function totalSupply() public view returns (uint256) {
265     return totalSupply_;
266   }
267 
268   /**
269   * @dev transfer token for a specified address
270   * @param _to The address to transfer to.
271   * @param _value The amount to be transferred.
272   */
273   function transfer(address _to, uint256 _value) public returns (bool) {
274     require(_to != address(0));
275     require(_value <= balances[msg.sender]);
276 
277     balances[msg.sender] = balances[msg.sender].sub(_value);
278     balances[_to] = balances[_to].add(_value);
279     emit Transfer(msg.sender, _to, _value);
280     return true;
281   }
282 
283   /**
284   * @dev Gets the balance of the specified address.
285   * @param _owner The address to query the the balance of.
286   * @return An uint256 representing the amount owned by the passed address.
287   */
288   function balanceOf(address _owner) public view returns (uint256) {
289     return balances[_owner];
290   }
291 
292 }
293 
294 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
295 
296 /**
297  * @title Standard ERC20 token
298  *
299  * @dev Implementation of the basic standard token.
300  * @dev https://github.com/ethereum/EIPs/issues/20
301  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
302  */
303 contract StandardToken is ERC20, BasicToken {
304 
305   mapping (address => mapping (address => uint256)) internal allowed;
306 
307 
308   /**
309    * @dev Transfer tokens from one address to another
310    * @param _from address The address which you want to send tokens from
311    * @param _to address The address which you want to transfer to
312    * @param _value uint256 the amount of tokens to be transferred
313    */
314   function transferFrom(
315     address _from,
316     address _to,
317     uint256 _value
318   )
319     public
320     returns (bool)
321   {
322     require(_to != address(0));
323     require(_value <= balances[_from]);
324     require(_value <= allowed[_from][msg.sender]);
325 
326     balances[_from] = balances[_from].sub(_value);
327     balances[_to] = balances[_to].add(_value);
328     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
329     emit Transfer(_from, _to, _value);
330     return true;
331   }
332 
333   /**
334    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
335    *
336    * Beware that changing an allowance with this method brings the risk that someone may use both the old
337    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
338    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
339    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
340    * @param _spender The address which will spend the funds.
341    * @param _value The amount of tokens to be spent.
342    */
343   function approve(address _spender, uint256 _value) public returns (bool) {
344     allowed[msg.sender][_spender] = _value;
345     emit Approval(msg.sender, _spender, _value);
346     return true;
347   }
348 
349   /**
350    * @dev Function to check the amount of tokens that an owner allowed to a spender.
351    * @param _owner address The address which owns the funds.
352    * @param _spender address The address which will spend the funds.
353    * @return A uint256 specifying the amount of tokens still available for the spender.
354    */
355   function allowance(
356     address _owner,
357     address _spender
358    )
359     public
360     view
361     returns (uint256)
362   {
363     return allowed[_owner][_spender];
364   }
365 
366   /**
367    * @dev Increase the amount of tokens that an owner allowed to a spender.
368    *
369    * approve should be called when allowed[_spender] == 0. To increment
370    * allowed value is better to use this function to avoid 2 calls (and wait until
371    * the first transaction is mined)
372    * From MonolithDAO Token.sol
373    * @param _spender The address which will spend the funds.
374    * @param _addedValue The amount of tokens to increase the allowance by.
375    */
376   function increaseApproval(
377     address _spender,
378     uint _addedValue
379   )
380     public
381     returns (bool)
382   {
383     allowed[msg.sender][_spender] = (
384       allowed[msg.sender][_spender].add(_addedValue));
385     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
386     return true;
387   }
388 
389   /**
390    * @dev Decrease the amount of tokens that an owner allowed to a spender.
391    *
392    * approve should be called when allowed[_spender] == 0. To decrement
393    * allowed value is better to use this function to avoid 2 calls (and wait until
394    * the first transaction is mined)
395    * From MonolithDAO Token.sol
396    * @param _spender The address which will spend the funds.
397    * @param _subtractedValue The amount of tokens to decrease the allowance by.
398    */
399   function decreaseApproval(
400     address _spender,
401     uint _subtractedValue
402   )
403     public
404     returns (bool)
405   {
406     uint oldValue = allowed[msg.sender][_spender];
407     if (_subtractedValue > oldValue) {
408       allowed[msg.sender][_spender] = 0;
409     } else {
410       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
411     }
412     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
413     return true;
414   }
415 
416 }
417 
418 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
419 
420 /**
421  * @title Pausable token
422  * @dev StandardToken modified with pausable transfers.
423  **/
424 contract PausableToken is StandardToken, Pausable {
425 
426   function transfer(
427     address _to,
428     uint256 _value
429   )
430     public
431     whenNotPaused
432     returns (bool)
433   {
434     return super.transfer(_to, _value);
435   }
436 
437   function transferFrom(
438     address _from,
439     address _to,
440     uint256 _value
441   )
442     public
443     whenNotPaused
444     returns (bool)
445   {
446     return super.transferFrom(_from, _to, _value);
447   }
448 
449   function approve(
450     address _spender,
451     uint256 _value
452   )
453     public
454     whenNotPaused
455     returns (bool)
456   {
457     return super.approve(_spender, _value);
458   }
459 
460   function increaseApproval(
461     address _spender,
462     uint _addedValue
463   )
464     public
465     whenNotPaused
466     returns (bool success)
467   {
468     return super.increaseApproval(_spender, _addedValue);
469   }
470 
471   function decreaseApproval(
472     address _spender,
473     uint _subtractedValue
474   )
475     public
476     whenNotPaused
477     returns (bool success)
478   {
479     return super.decreaseApproval(_spender, _subtractedValue);
480   }
481 }
482 
483 // File: openzeppelin-solidity/contracts/ownership/rbac/Roles.sol
484 
485 /**
486  * @title Roles
487  * @author Francisco Giordano (@frangio)
488  * @dev Library for managing addresses assigned to a Role.
489  *      See RBAC.sol for example usage.
490  */
491 library Roles {
492   struct Role {
493     mapping (address => bool) bearer;
494   }
495 
496   /**
497    * @dev give an address access to this role
498    */
499   function add(Role storage role, address addr)
500     internal
501   {
502     role.bearer[addr] = true;
503   }
504 
505   /**
506    * @dev remove an address' access to this role
507    */
508   function remove(Role storage role, address addr)
509     internal
510   {
511     role.bearer[addr] = false;
512   }
513 
514   /**
515    * @dev check if an address has this role
516    * // reverts
517    */
518   function check(Role storage role, address addr)
519     view
520     internal
521   {
522     require(has(role, addr));
523   }
524 
525   /**
526    * @dev check if an address has this role
527    * @return bool
528    */
529   function has(Role storage role, address addr)
530     view
531     internal
532     returns (bool)
533   {
534     return role.bearer[addr];
535   }
536 }
537 
538 // File: openzeppelin-solidity/contracts/ownership/rbac/RBAC.sol
539 
540 /**
541  * @title RBAC (Role-Based Access Control)
542  * @author Matt Condon (@Shrugs)
543  * @dev Stores and provides setters and getters for roles and addresses.
544  * @dev Supports unlimited numbers of roles and addresses.
545  * @dev See //contracts/mocks/RBACMock.sol for an example of usage.
546  * This RBAC method uses strings to key roles. It may be beneficial
547  *  for you to write your own implementation of this interface using Enums or similar.
548  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
549  *  to avoid typos.
550  */
551 contract RBAC {
552   using Roles for Roles.Role;
553 
554   mapping (string => Roles.Role) private roles;
555 
556   event RoleAdded(address addr, string roleName);
557   event RoleRemoved(address addr, string roleName);
558 
559   /**
560    * @dev reverts if addr does not have role
561    * @param addr address
562    * @param roleName the name of the role
563    * // reverts
564    */
565   function checkRole(address addr, string roleName)
566     view
567     public
568   {
569     roles[roleName].check(addr);
570   }
571 
572   /**
573    * @dev determine if addr has role
574    * @param addr address
575    * @param roleName the name of the role
576    * @return bool
577    */
578   function hasRole(address addr, string roleName)
579     view
580     public
581     returns (bool)
582   {
583     return roles[roleName].has(addr);
584   }
585 
586   /**
587    * @dev add a role to an address
588    * @param addr address
589    * @param roleName the name of the role
590    */
591   function addRole(address addr, string roleName)
592     internal
593   {
594     roles[roleName].add(addr);
595     emit RoleAdded(addr, roleName);
596   }
597 
598   /**
599    * @dev remove a role from an address
600    * @param addr address
601    * @param roleName the name of the role
602    */
603   function removeRole(address addr, string roleName)
604     internal
605   {
606     roles[roleName].remove(addr);
607     emit RoleRemoved(addr, roleName);
608   }
609 
610   /**
611    * @dev modifier to scope access to a single role (uses msg.sender as addr)
612    * @param roleName the name of the role
613    * // reverts
614    */
615   modifier onlyRole(string roleName)
616   {
617     checkRole(msg.sender, roleName);
618     _;
619   }
620 
621   /**
622    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
623    * @param roleNames the names of the roles to scope access to
624    * // reverts
625    *
626    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
627    *  see: https://github.com/ethereum/solidity/issues/2467
628    */
629   // modifier onlyRoles(string[] roleNames) {
630   //     bool hasAnyRole = false;
631   //     for (uint8 i = 0; i < roleNames.length; i++) {
632   //         if (hasRole(msg.sender, roleNames[i])) {
633   //             hasAnyRole = true;
634   //             break;
635   //         }
636   //     }
637 
638   //     require(hasAnyRole);
639 
640   //     _;
641   // }
642 }
643 
644 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
645 
646 /**
647  * @title Mintable token
648  * @dev Simple ERC20 Token example, with mintable token creation
649  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
650  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
651  */
652 contract MintableToken is StandardToken, Ownable {
653   event Mint(address indexed to, uint256 amount);
654   event MintFinished();
655 
656   bool public mintingFinished = false;
657 
658 
659   modifier canMint() {
660     require(!mintingFinished);
661     _;
662   }
663 
664   modifier hasMintPermission() {
665     require(msg.sender == owner);
666     _;
667   }
668 
669   /**
670    * @dev Function to mint tokens
671    * @param _to The address that will receive the minted tokens.
672    * @param _amount The amount of tokens to mint.
673    * @return A boolean that indicates if the operation was successful.
674    */
675   function mint(
676     address _to,
677     uint256 _amount
678   )
679     hasMintPermission
680     canMint
681     public
682     returns (bool)
683   {
684     totalSupply_ = totalSupply_.add(_amount);
685     balances[_to] = balances[_to].add(_amount);
686     emit Mint(_to, _amount);
687     emit Transfer(address(0), _to, _amount);
688     return true;
689   }
690 
691   /**
692    * @dev Function to stop minting new tokens.
693    * @return True if the operation was successful.
694    */
695   function finishMinting() onlyOwner canMint public returns (bool) {
696     mintingFinished = true;
697     emit MintFinished();
698     return true;
699   }
700 }
701 
702 // File: openzeppelin-solidity/contracts/token/ERC20/RBACMintableToken.sol
703 
704 /**
705  * @title RBACMintableToken
706  * @author Vittorio Minacori (@vittominacori)
707  * @dev Mintable Token, with RBAC minter permissions
708  */
709 contract RBACMintableToken is MintableToken, RBAC {
710   /**
711    * A constant role name for indicating minters.
712    */
713   string public constant ROLE_MINTER = "minter";
714 
715   /**
716    * @dev override the Mintable token modifier to add role based logic
717    */
718   modifier hasMintPermission() {
719     checkRole(msg.sender, ROLE_MINTER);
720     _;
721   }
722 
723   /**
724    * @dev add a minter role to an address
725    * @param minter address
726    */
727   function addMinter(address minter) onlyOwner public {
728     addRole(minter, ROLE_MINTER);
729   }
730 
731   /**
732    * @dev remove a minter role from an address
733    * @param minter address
734    */
735   function removeMinter(address minter) onlyOwner public {
736     removeRole(minter, ROLE_MINTER);
737   }
738 }
739 
740 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
741 
742 /**
743  * @title Burnable Token
744  * @dev Token that can be irreversibly burned (destroyed).
745  */
746 contract BurnableToken is BasicToken {
747 
748   event Burn(address indexed burner, uint256 value);
749 
750   /**
751    * @dev Burns a specific amount of tokens.
752    * @param _value The amount of token to be burned.
753    */
754   function burn(uint256 _value) public {
755     _burn(msg.sender, _value);
756   }
757 
758   function _burn(address _who, uint256 _value) internal {
759     require(_value <= balances[_who]);
760     // no need to require value <= totalSupply, since that would imply the
761     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
762 
763     balances[_who] = balances[_who].sub(_value);
764     totalSupply_ = totalSupply_.sub(_value);
765     emit Burn(_who, _value);
766     emit Transfer(_who, address(0), _value);
767   }
768 }
769 
770 // File: openzeppelin-solidity/contracts/token/ERC20/StandardBurnableToken.sol
771 
772 /**
773  * @title Standard Burnable Token
774  * @dev Adds burnFrom method to ERC20 implementations
775  */
776 contract StandardBurnableToken is BurnableToken, StandardToken {
777 
778   /**
779    * @dev Burns a specific amount of tokens from the target address and decrements allowance
780    * @param _from address The address which you want to send tokens from
781    * @param _value uint256 The amount of token to be burned
782    */
783   function burnFrom(address _from, uint256 _value) public {
784     require(_value <= allowed[_from][msg.sender]);
785     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
786     // this function needs to emit an event with the updated approval.
787     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
788     _burn(_from, _value);
789   }
790 }
791 
792 // File: contracts/KMHToken.sol
793 
794 contract ERC223Receiver {
795   function tokenFallback(address _sender, uint256 _value, bytes _data) public payable returns (bool success);
796 }
797 
798 contract KMHToken is
799   RBACMintableToken,
800   PausableToken,
801   StandardBurnableToken,
802   CanReclaimToken
803 {
804   string public name = "KeyMesh Token";
805   string public symbol = "KMH";
806   uint8 public decimals = 18;
807 
808   function sendToContract(address _to, uint _value, bytes _data) public payable returns (bool success) {
809     require(transfer(_to, _value));
810     ERC223Receiver receiver = ERC223Receiver(_to);
811     return receiver.tokenFallback.value(msg.value)(msg.sender, _value, _data);
812   }
813 
814   function ownerAddRole(address addr, string roleName)
815     onlyOwner
816     public
817   {
818     addRole(addr, roleName);
819   }
820 
821   /**
822    * @dev remove a role from an address
823    * @param addr address
824    * @param roleName the name of the role
825    */
826   function ownerRemoveRole(address addr, string roleName)
827     onlyOwner
828     public
829   {
830     removeRole(addr, roleName);
831   }
832 }