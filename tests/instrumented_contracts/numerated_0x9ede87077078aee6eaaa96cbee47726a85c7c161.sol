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
55 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipRenounced(address indexed previousOwner);
67   event OwnershipTransferred(
68     address indexed previousOwner,
69     address indexed newOwner
70   );
71 
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   constructor() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to relinquish control of the contract.
91    * @notice Renouncing to ownership will leave the contract without an owner.
92    * It will not be possible to call the functions with the `onlyOwner`
93    * modifier anymore.
94    */
95   function renounceOwnership() public onlyOwner {
96     emit OwnershipRenounced(owner);
97     owner = address(0);
98   }
99 
100   /**
101    * @dev Allows the current owner to transfer control of the contract to a newOwner.
102    * @param _newOwner The address to transfer ownership to.
103    */
104   function transferOwnership(address _newOwner) public onlyOwner {
105     _transferOwnership(_newOwner);
106   }
107 
108   /**
109    * @dev Transfers control of the contract to a newOwner.
110    * @param _newOwner The address to transfer ownership to.
111    */
112   function _transferOwnership(address _newOwner) internal {
113     require(_newOwner != address(0));
114     emit OwnershipTransferred(owner, _newOwner);
115     owner = _newOwner;
116   }
117 }
118 
119 // File: openzeppelin-solidity/contracts/access/rbac/Roles.sol
120 
121 /**
122  * @title Roles
123  * @author Francisco Giordano (@frangio)
124  * @dev Library for managing addresses assigned to a Role.
125  * See RBAC.sol for example usage.
126  */
127 library Roles {
128   struct Role {
129     mapping (address => bool) bearer;
130   }
131 
132   /**
133    * @dev give an address access to this role
134    */
135   function add(Role storage _role, address _addr)
136     internal
137   {
138     _role.bearer[_addr] = true;
139   }
140 
141   /**
142    * @dev remove an address' access to this role
143    */
144   function remove(Role storage _role, address _addr)
145     internal
146   {
147     _role.bearer[_addr] = false;
148   }
149 
150   /**
151    * @dev check if an address has this role
152    * // reverts
153    */
154   function check(Role storage _role, address _addr)
155     internal
156     view
157   {
158     require(has(_role, _addr));
159   }
160 
161   /**
162    * @dev check if an address has this role
163    * @return bool
164    */
165   function has(Role storage _role, address _addr)
166     internal
167     view
168     returns (bool)
169   {
170     return _role.bearer[_addr];
171   }
172 }
173 
174 // File: openzeppelin-solidity/contracts/access/rbac/RBAC.sol
175 
176 /**
177  * @title RBAC (Role-Based Access Control)
178  * @author Matt Condon (@Shrugs)
179  * @dev Stores and provides setters and getters for roles and addresses.
180  * Supports unlimited numbers of roles and addresses.
181  * See //contracts/mocks/RBACMock.sol for an example of usage.
182  * This RBAC method uses strings to key roles. It may be beneficial
183  * for you to write your own implementation of this interface using Enums or similar.
184  */
185 contract RBAC {
186   using Roles for Roles.Role;
187 
188   mapping (string => Roles.Role) private roles;
189 
190   event RoleAdded(address indexed operator, string role);
191   event RoleRemoved(address indexed operator, string role);
192 
193   /**
194    * @dev reverts if addr does not have role
195    * @param _operator address
196    * @param _role the name of the role
197    * // reverts
198    */
199   function checkRole(address _operator, string _role)
200     public
201     view
202   {
203     roles[_role].check(_operator);
204   }
205 
206   /**
207    * @dev determine if addr has role
208    * @param _operator address
209    * @param _role the name of the role
210    * @return bool
211    */
212   function hasRole(address _operator, string _role)
213     public
214     view
215     returns (bool)
216   {
217     return roles[_role].has(_operator);
218   }
219 
220   /**
221    * @dev add a role to an address
222    * @param _operator address
223    * @param _role the name of the role
224    */
225   function addRole(address _operator, string _role)
226     internal
227   {
228     roles[_role].add(_operator);
229     emit RoleAdded(_operator, _role);
230   }
231 
232   /**
233    * @dev remove a role from an address
234    * @param _operator address
235    * @param _role the name of the role
236    */
237   function removeRole(address _operator, string _role)
238     internal
239   {
240     roles[_role].remove(_operator);
241     emit RoleRemoved(_operator, _role);
242   }
243 
244   /**
245    * @dev modifier to scope access to a single role (uses msg.sender as addr)
246    * @param _role the name of the role
247    * // reverts
248    */
249   modifier onlyRole(string _role)
250   {
251     checkRole(msg.sender, _role);
252     _;
253   }
254 
255   /**
256    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
257    * @param _roles the names of the roles to scope access to
258    * // reverts
259    *
260    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
261    *  see: https://github.com/ethereum/solidity/issues/2467
262    */
263   // modifier onlyRoles(string[] _roles) {
264   //     bool hasAnyRole = false;
265   //     for (uint8 i = 0; i < _roles.length; i++) {
266   //         if (hasRole(msg.sender, _roles[i])) {
267   //             hasAnyRole = true;
268   //             break;
269   //         }
270   //     }
271 
272   //     require(hasAnyRole);
273 
274   //     _;
275   // }
276 }
277 
278 // File: openzeppelin-solidity/contracts/ownership/Superuser.sol
279 
280 /**
281  * @title Superuser
282  * @dev The Superuser contract defines a single superuser who can transfer the ownership
283  * of a contract to a new address, even if he is not the owner.
284  * A superuser can transfer his role to a new address.
285  */
286 contract Superuser is Ownable, RBAC {
287   string public constant ROLE_SUPERUSER = "superuser";
288 
289   constructor () public {
290     addRole(msg.sender, ROLE_SUPERUSER);
291   }
292 
293   /**
294    * @dev Throws if called by any account that's not a superuser.
295    */
296   modifier onlySuperuser() {
297     checkRole(msg.sender, ROLE_SUPERUSER);
298     _;
299   }
300 
301   modifier onlyOwnerOrSuperuser() {
302     require(msg.sender == owner || isSuperuser(msg.sender));
303     _;
304   }
305 
306   /**
307    * @dev getter to determine if address has superuser role
308    */
309   function isSuperuser(address _addr)
310     public
311     view
312     returns (bool)
313   {
314     return hasRole(_addr, ROLE_SUPERUSER);
315   }
316 
317   /**
318    * @dev Allows the current superuser to transfer his role to a newSuperuser.
319    * @param _newSuperuser The address to transfer ownership to.
320    */
321   function transferSuperuser(address _newSuperuser) public onlySuperuser {
322     require(_newSuperuser != address(0));
323     removeRole(msg.sender, ROLE_SUPERUSER);
324     addRole(_newSuperuser, ROLE_SUPERUSER);
325   }
326 
327   /**
328    * @dev Allows the current superuser or owner to transfer control of the contract to a newOwner.
329    * @param _newOwner The address to transfer ownership to.
330    */
331   function transferOwnership(address _newOwner) public onlyOwnerOrSuperuser {
332     _transferOwnership(_newOwner);
333   }
334 }
335 
336 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
337 
338 /**
339  * @title ERC20Basic
340  * @dev Simpler version of ERC20 interface
341  * See https://github.com/ethereum/EIPs/issues/179
342  */
343 contract ERC20Basic {
344   function totalSupply() public view returns (uint256);
345   function balanceOf(address _who) public view returns (uint256);
346   function transfer(address _to, uint256 _value) public returns (bool);
347   event Transfer(address indexed from, address indexed to, uint256 value);
348 }
349 
350 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
351 
352 /**
353  * @title Basic token
354  * @dev Basic version of StandardToken, with no allowances.
355  */
356 contract BasicToken is ERC20Basic {
357   using SafeMath for uint256;
358 
359   mapping(address => uint256) internal balances;
360 
361   uint256 internal totalSupply_;
362 
363   /**
364   * @dev Total number of tokens in existence
365   */
366   function totalSupply() public view returns (uint256) {
367     return totalSupply_;
368   }
369 
370   /**
371   * @dev Transfer token for a specified address
372   * @param _to The address to transfer to.
373   * @param _value The amount to be transferred.
374   */
375   function transfer(address _to, uint256 _value) public returns (bool) {
376     require(_value <= balances[msg.sender]);
377     require(_to != address(0));
378 
379     balances[msg.sender] = balances[msg.sender].sub(_value);
380     balances[_to] = balances[_to].add(_value);
381     emit Transfer(msg.sender, _to, _value);
382     return true;
383   }
384 
385   /**
386   * @dev Gets the balance of the specified address.
387   * @param _owner The address to query the the balance of.
388   * @return An uint256 representing the amount owned by the passed address.
389   */
390   function balanceOf(address _owner) public view returns (uint256) {
391     return balances[_owner];
392   }
393 
394 }
395 
396 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
397 
398 /**
399  * @title ERC20 interface
400  * @dev see https://github.com/ethereum/EIPs/issues/20
401  */
402 contract ERC20 is ERC20Basic {
403   function allowance(address _owner, address _spender)
404     public view returns (uint256);
405 
406   function transferFrom(address _from, address _to, uint256 _value)
407     public returns (bool);
408 
409   function approve(address _spender, uint256 _value) public returns (bool);
410   event Approval(
411     address indexed owner,
412     address indexed spender,
413     uint256 value
414   );
415 }
416 
417 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
418 
419 /**
420  * @title Standard ERC20 token
421  *
422  * @dev Implementation of the basic standard token.
423  * https://github.com/ethereum/EIPs/issues/20
424  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
425  */
426 contract StandardToken is ERC20, BasicToken {
427 
428   mapping (address => mapping (address => uint256)) internal allowed;
429 
430 
431   /**
432    * @dev Transfer tokens from one address to another
433    * @param _from address The address which you want to send tokens from
434    * @param _to address The address which you want to transfer to
435    * @param _value uint256 the amount of tokens to be transferred
436    */
437   function transferFrom(
438     address _from,
439     address _to,
440     uint256 _value
441   )
442     public
443     returns (bool)
444   {
445     require(_value <= balances[_from]);
446     require(_value <= allowed[_from][msg.sender]);
447     require(_to != address(0));
448 
449     balances[_from] = balances[_from].sub(_value);
450     balances[_to] = balances[_to].add(_value);
451     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
452     emit Transfer(_from, _to, _value);
453     return true;
454   }
455 
456   /**
457    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
458    * Beware that changing an allowance with this method brings the risk that someone may use both the old
459    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
460    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
461    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
462    * @param _spender The address which will spend the funds.
463    * @param _value The amount of tokens to be spent.
464    */
465   function approve(address _spender, uint256 _value) public returns (bool) {
466     allowed[msg.sender][_spender] = _value;
467     emit Approval(msg.sender, _spender, _value);
468     return true;
469   }
470 
471   /**
472    * @dev Function to check the amount of tokens that an owner allowed to a spender.
473    * @param _owner address The address which owns the funds.
474    * @param _spender address The address which will spend the funds.
475    * @return A uint256 specifying the amount of tokens still available for the spender.
476    */
477   function allowance(
478     address _owner,
479     address _spender
480    )
481     public
482     view
483     returns (uint256)
484   {
485     return allowed[_owner][_spender];
486   }
487 
488   /**
489    * @dev Increase the amount of tokens that an owner allowed to a spender.
490    * approve should be called when allowed[_spender] == 0. To increment
491    * allowed value is better to use this function to avoid 2 calls (and wait until
492    * the first transaction is mined)
493    * From MonolithDAO Token.sol
494    * @param _spender The address which will spend the funds.
495    * @param _addedValue The amount of tokens to increase the allowance by.
496    */
497   function increaseApproval(
498     address _spender,
499     uint256 _addedValue
500   )
501     public
502     returns (bool)
503   {
504     allowed[msg.sender][_spender] = (
505       allowed[msg.sender][_spender].add(_addedValue));
506     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
507     return true;
508   }
509 
510   /**
511    * @dev Decrease the amount of tokens that an owner allowed to a spender.
512    * approve should be called when allowed[_spender] == 0. To decrement
513    * allowed value is better to use this function to avoid 2 calls (and wait until
514    * the first transaction is mined)
515    * From MonolithDAO Token.sol
516    * @param _spender The address which will spend the funds.
517    * @param _subtractedValue The amount of tokens to decrease the allowance by.
518    */
519   function decreaseApproval(
520     address _spender,
521     uint256 _subtractedValue
522   )
523     public
524     returns (bool)
525   {
526     uint256 oldValue = allowed[msg.sender][_spender];
527     if (_subtractedValue >= oldValue) {
528       allowed[msg.sender][_spender] = 0;
529     } else {
530       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
531     }
532     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
533     return true;
534   }
535 
536 }
537 
538 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
539 
540 /**
541  * @title Mintable token
542  * @dev Simple ERC20 Token example, with mintable token creation
543  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
544  */
545 contract MintableToken is StandardToken, Ownable {
546   event Mint(address indexed to, uint256 amount);
547   event MintFinished();
548 
549   bool public mintingFinished = false;
550 
551 
552   modifier canMint() {
553     require(!mintingFinished);
554     _;
555   }
556 
557   modifier hasMintPermission() {
558     require(msg.sender == owner);
559     _;
560   }
561 
562   /**
563    * @dev Function to mint tokens
564    * @param _to The address that will receive the minted tokens.
565    * @param _amount The amount of tokens to mint.
566    * @return A boolean that indicates if the operation was successful.
567    */
568   function mint(
569     address _to,
570     uint256 _amount
571   )
572     public
573     hasMintPermission
574     canMint
575     returns (bool)
576   {
577     totalSupply_ = totalSupply_.add(_amount);
578     balances[_to] = balances[_to].add(_amount);
579     emit Mint(_to, _amount);
580     emit Transfer(address(0), _to, _amount);
581     return true;
582   }
583 
584   /**
585    * @dev Function to stop minting new tokens.
586    * @return True if the operation was successful.
587    */
588   function finishMinting() public onlyOwner canMint returns (bool) {
589     mintingFinished = true;
590     emit MintFinished();
591     return true;
592   }
593 }
594 
595 // File: openzeppelin-solidity/contracts/token/ERC20/CappedToken.sol
596 
597 /**
598  * @title Capped token
599  * @dev Mintable token with a token cap.
600  */
601 contract CappedToken is MintableToken {
602 
603   uint256 public cap;
604 
605   constructor(uint256 _cap) public {
606     require(_cap > 0);
607     cap = _cap;
608   }
609 
610   /**
611    * @dev Function to mint tokens
612    * @param _to The address that will receive the minted tokens.
613    * @param _amount The amount of tokens to mint.
614    * @return A boolean that indicates if the operation was successful.
615    */
616   function mint(
617     address _to,
618     uint256 _amount
619   )
620     public
621     returns (bool)
622   {
623     require(totalSupply_.add(_amount) <= cap);
624 
625     return super.mint(_to, _amount);
626   }
627 
628 }
629 
630 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
631 
632 /**
633  * @title Pausable
634  * @dev Base contract which allows children to implement an emergency stop mechanism.
635  */
636 contract Pausable is Ownable {
637   event Pause();
638   event Unpause();
639 
640   bool public paused = false;
641 
642 
643   /**
644    * @dev Modifier to make a function callable only when the contract is not paused.
645    */
646   modifier whenNotPaused() {
647     require(!paused);
648     _;
649   }
650 
651   /**
652    * @dev Modifier to make a function callable only when the contract is paused.
653    */
654   modifier whenPaused() {
655     require(paused);
656     _;
657   }
658 
659   /**
660    * @dev called by the owner to pause, triggers stopped state
661    */
662   function pause() public onlyOwner whenNotPaused {
663     paused = true;
664     emit Pause();
665   }
666 
667   /**
668    * @dev called by the owner to unpause, returns to normal state
669    */
670   function unpause() public onlyOwner whenPaused {
671     paused = false;
672     emit Unpause();
673   }
674 }
675 
676 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
677 
678 /**
679  * @title Pausable token
680  * @dev StandardToken modified with pausable transfers.
681  **/
682 contract PausableToken is StandardToken, Pausable {
683 
684   function transfer(
685     address _to,
686     uint256 _value
687   )
688     public
689     whenNotPaused
690     returns (bool)
691   {
692     return super.transfer(_to, _value);
693   }
694 
695   function transferFrom(
696     address _from,
697     address _to,
698     uint256 _value
699   )
700     public
701     whenNotPaused
702     returns (bool)
703   {
704     return super.transferFrom(_from, _to, _value);
705   }
706 
707   function approve(
708     address _spender,
709     uint256 _value
710   )
711     public
712     whenNotPaused
713     returns (bool)
714   {
715     return super.approve(_spender, _value);
716   }
717 
718   function increaseApproval(
719     address _spender,
720     uint _addedValue
721   )
722     public
723     whenNotPaused
724     returns (bool success)
725   {
726     return super.increaseApproval(_spender, _addedValue);
727   }
728 
729   function decreaseApproval(
730     address _spender,
731     uint _subtractedValue
732   )
733     public
734     whenNotPaused
735     returns (bool success)
736   {
737     return super.decreaseApproval(_spender, _subtractedValue);
738   }
739 }
740 
741 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
742 
743 /**
744  * @title SafeERC20
745  * @dev Wrappers around ERC20 operations that throw on failure.
746  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
747  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
748  */
749 library SafeERC20 {
750   function safeTransfer(
751     ERC20Basic _token,
752     address _to,
753     uint256 _value
754   )
755     internal
756   {
757     require(_token.transfer(_to, _value));
758   }
759 
760   function safeTransferFrom(
761     ERC20 _token,
762     address _from,
763     address _to,
764     uint256 _value
765   )
766     internal
767   {
768     require(_token.transferFrom(_from, _to, _value));
769   }
770 
771   function safeApprove(
772     ERC20 _token,
773     address _spender,
774     uint256 _value
775   )
776     internal
777   {
778     require(_token.approve(_spender, _value));
779   }
780 }
781 
782 // File: openzeppelin-solidity/contracts/token/ERC20/TokenTimelock.sol
783 
784 /**
785  * @title TokenTimelock
786  * @dev TokenTimelock is a token holder contract that will allow a
787  * beneficiary to extract the tokens after a given release time
788  */
789 contract TokenTimelock {
790   using SafeERC20 for ERC20Basic;
791 
792   // ERC20 basic token contract being held
793   ERC20Basic public token;
794 
795   // beneficiary of tokens after they are released
796   address public beneficiary;
797 
798   // timestamp when token release is enabled
799   uint256 public releaseTime;
800 
801   constructor(
802     ERC20Basic _token,
803     address _beneficiary,
804     uint256 _releaseTime
805   )
806     public
807   {
808     // solium-disable-next-line security/no-block-members
809     require(_releaseTime > block.timestamp);
810     token = _token;
811     beneficiary = _beneficiary;
812     releaseTime = _releaseTime;
813   }
814 
815   /**
816    * @notice Transfers tokens held by timelock to beneficiary.
817    */
818   function release() public {
819     // solium-disable-next-line security/no-block-members
820     require(block.timestamp >= releaseTime);
821 
822     uint256 amount = token.balanceOf(address(this));
823     require(amount > 0);
824 
825     token.safeTransfer(beneficiary, amount);
826   }
827 }
828 
829 // File: contracts/SocialGoodToken.sol
830 
831 /// @title Token contract - ERC20 compatible SocialGood token contract.
832 /// @author Social Good Foundation Inc. - <info@socialgood-foundation.com>
833 contract SocialGoodToken is CappedToken(210000000e18), PausableToken, Superuser { // capped at 210 mil
834     using SafeMath for uint256;
835 
836     /*
837      *  Constants / Token meta data
838      */
839     string constant public name = 'SocialGood'; // Token name
840     string constant public symbol = 'SG';       // Token symbol
841     uint8 constant public decimals = 18;
842     uint256 constant public totalTeamTokens = 3100000e18;  // 3.1 mil reserved tokens for the team
843     uint256 constant private secsInYear = 365 * 86400 + 21600;  // including the extra seconds in a leap year
844 
845     /*
846      *  Timelock contracts for team's tokens
847      */
848     address public timelock1;
849     address public timelock2;
850     address public timelock3;
851     address public timelock4;
852 
853     /*
854      *  Events
855      */
856     event Burn(address indexed burner, uint256 value);
857 
858     /*
859      *  Contract functions
860      */
861     /**
862      * @dev Contract constructor function
863      */
864     constructor() public {
865         paused = true; // not to allow token transfers initially
866     }
867 
868     /**
869      * @dev Initialize this contract
870      * @param socialGoodTeamAddr Address to receive unlocked team tokens
871      * @param startTimerAt Time to start counting the lock-up periods
872      */
873     function initializeTeamTokens(address socialGoodTeamAddr, uint256 startTimerAt) external {
874         require(socialGoodTeamAddr != 0 && startTimerAt > 0);
875 
876         // Tokens for the SocialGood team (loked-up initially)
877         // 25% tokens will be released every year
878         timelock1 = new TokenTimelock(ERC20Basic(this), socialGoodTeamAddr, startTimerAt.add(secsInYear));
879         timelock2 = new TokenTimelock(ERC20Basic(this), socialGoodTeamAddr, startTimerAt.add(secsInYear.mul(2)));
880         timelock3 = new TokenTimelock(ERC20Basic(this), socialGoodTeamAddr, startTimerAt.add(secsInYear.mul(3)));
881         timelock4 = new TokenTimelock(ERC20Basic(this), socialGoodTeamAddr, startTimerAt.add(secsInYear.mul(4)));
882         mint(timelock1, totalTeamTokens / 4);
883         mint(timelock2, totalTeamTokens / 4);
884         mint(timelock3, totalTeamTokens / 4);
885         mint(timelock4, totalTeamTokens / 4);
886     }
887 
888     /**
889      * @dev Burns a specific amount of tokens.
890      * @param _value The amount of token to be burned.
891      */
892     function burn(uint256 _value) public onlyOwner {
893         _burn(msg.sender, _value);
894     }
895 
896     // save some gas by making only one contract call
897     function burnFrom(address _from, uint256 _value)
898         public
899         onlyOwner
900     {
901         assert(transferFrom(_from, msg.sender, _value));
902         _burn(msg.sender, _value);
903     }
904 
905     // this inherited function is disabled to prevent centralized pausing
906     function pause() public { revert(); }
907 
908     function _burn(address _who, uint256 _value) internal {
909         require(_value <= balances[_who]);
910         // no need to require value <= totalSupply, since that would imply the
911         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
912 
913         balances[_who] = balances[_who].sub(_value);
914         totalSupply_ = totalSupply_.sub(_value);
915         emit Burn(_who, _value);
916         emit Transfer(_who, address(0), _value);
917     }
918 }