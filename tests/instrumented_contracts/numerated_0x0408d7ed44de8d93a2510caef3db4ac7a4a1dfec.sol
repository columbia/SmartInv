1 pragma solidity ^0.4.24;
2 
3 
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
15     if (a == 0) {
16       return 0;
17     }
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 
50   /**
51   * @dev Integer division of two numbers, truncating the quotient.
52   */
53   function divRemain(uint256 numerator, uint256 denominator) internal pure returns (uint256 quotient, uint256 remainder) {
54     quotient  = div(numerator, denominator);
55     remainder = sub(numerator, mul(denominator, quotient));
56   }
57 }
58 
59 
60 /**
61  * @title Roles
62  * @author Francisco Giordano (@frangio)
63  * @dev Library for managing addresses assigned to a Role.
64  * See RBAC.sol for example usage.
65  */
66 library Roles {
67   struct Role {
68     mapping (address => bool) bearer;
69   }
70 
71   /**
72    * @dev give an address access to this role
73    */
74   function add(Role storage role, address addr)
75     internal
76   {
77     role.bearer[addr] = true;
78   }
79 
80   /**
81    * @dev remove an address' access to this role
82    */
83   function remove(Role storage role, address addr)
84     internal
85   {
86     role.bearer[addr] = false;
87   }
88 
89   /**
90    * @dev check if an address has this role
91    * // reverts
92    */
93   function check(Role storage role, address addr)
94     view
95     internal
96   {
97     require(has(role, addr));
98   }
99 
100   /**
101    * @dev check if an address has this role
102    * @return bool
103    */
104   function has(Role storage role, address addr)
105     view
106     internal
107     returns (bool)
108   {
109     return role.bearer[addr];
110   }
111 }
112 
113 
114 /**
115  * @title RBAC (Role-Based Access Control)
116  * @author Matt Condon (@Shrugs)
117  * @dev Stores and provides setters and getters for roles and addresses.
118  * Supports unlimited numbers of roles and addresses.
119  * See //contracts/mocks/RBACMock.sol for an example of usage.
120  * This RBAC method uses strings to key roles. It may be beneficial
121  * for you to write your own implementation of this interface using Enums or similar.
122  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
123  * to avoid typos.
124  */
125 contract RBAC {
126   using Roles for Roles.Role;
127 
128   mapping (string => Roles.Role) private roles;
129 
130   event RoleAdded(address indexed operator, string role);
131   event RoleRemoved(address indexed operator, string role);
132   event RoleRemovedAll(string role);
133 
134   /**
135    * @dev reverts if addr does not have role
136    * @param _operator address
137    * @param _role the name of the role
138    * // reverts
139    */
140   function checkRole(address _operator, string _role)
141     view
142     public
143   {
144     roles[_role].check(_operator);
145   }
146 
147   /**
148    * @dev determine if addr has role
149    * @param _operator address
150    * @param _role the name of the role
151    * @return bool
152    */
153   function hasRole(address _operator, string _role)
154     view
155     public
156     returns (bool)
157   {
158     return roles[_role].has(_operator);
159   }
160 
161   /**
162    * @dev add a role to an address
163    * @param _operator address
164    * @param _role the name of the role
165    */
166   function addRole(address _operator, string _role)
167     internal
168   {
169     roles[_role].add(_operator);
170     emit RoleAdded(_operator, _role);
171   }
172 
173   /**
174    * @dev remove a role from an address
175    * @param _operator address
176    * @param _role the name of the role
177    */
178   function removeRole(address _operator, string _role)
179     internal
180   {
181     roles[_role].remove(_operator);
182     emit RoleRemoved(_operator, _role);
183   }
184 
185   /**
186    * @dev remove a role from an address
187    * @param _role the name of the role
188    */
189   function removeRoleAll(string _role)
190     internal
191   {
192     delete roles[_role];
193     emit RoleRemovedAll(_role);
194   }
195 
196   /**
197    * @dev modifier to scope access to a single role (uses msg.sender as addr)
198    * @param _role the name of the role
199    * // reverts
200    */
201   modifier onlyRole(string _role)
202   {
203     checkRole(msg.sender, _role);
204     _;
205   }
206 
207   /**
208    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
209    * @param _roles the names of the roles to scope access to
210    * // reverts
211    *
212    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
213    *  see: https://github.com/ethereum/solidity/issues/2467
214    */
215   // modifier onlyRoles(string[] _roles) {
216   //     bool hasAnyRole = false;
217   //     for (uint8 i = 0; i < _roles.length; i++) {
218   //         if (hasRole(msg.sender, _roles[i])) {
219   //             hasAnyRole = true;
220   //             break;
221   //         }
222   //     }
223 
224   //     require(hasAnyRole);
225 
226   //     _;
227   // }
228 }
229 
230 
231 /**
232  * @title Ownable
233  * @dev The Ownable contract has an owner address, and provides basic authorization control
234  * functions, this simplifies the implementation of "user permissions".
235  */
236 contract Ownable {
237   address public owner;
238 
239 
240   event OwnershipRenounced(address indexed previousOwner);
241   event OwnershipTransferred(
242     address indexed previousOwner,
243     address indexed newOwner
244   );
245 
246 
247   /**
248    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
249    * account.
250    */
251   constructor() public {
252     owner = msg.sender;
253   }
254 
255   /**
256    * @dev Throws if called by any account other than the owner.
257    */
258   modifier onlyOwner() {
259     require(msg.sender == owner);
260     _;
261   }
262 
263   /**
264    * @dev Allows the current owner to relinquish control of the contract.
265    * @notice Renouncing to ownership will leave the contract without an owner.
266    * It will not be possible to call the functions with the `onlyOwner`
267    * modifier anymore.
268    */
269   function renounceOwnership() public onlyOwner {
270     emit OwnershipRenounced(owner);
271     owner = address(0);
272   }
273 
274   /**
275    * @dev Allows the current owner to transfer control of the contract to a newOwner.
276    * @param _newOwner The address to transfer ownership to.
277    */
278   function transferOwnership(address _newOwner) public onlyOwner {
279     _transferOwnership(_newOwner);
280   }
281 
282   /**
283    * @dev Transfers control of the contract to a newOwner.
284    * @param _newOwner The address to transfer ownership to.
285    */
286   function _transferOwnership(address _newOwner) internal {
287     require(_newOwner != address(0));
288     emit OwnershipTransferred(owner, _newOwner);
289     owner = _newOwner;
290   }
291 }
292 
293 
294 /**
295  * @title Administrable
296  * @dev The Admin contract defines a single Admin who can transfer the ownership 
297  * of a contract to a new address, even if he is not the owner. 
298  * A Admin can transfer his role to a new address. 
299  */
300 contract Administrable is Ownable, RBAC {
301   string public constant ROLE_LOCKUP = "lockup";
302   string public constant ROLE_MINT = "mint";
303 
304   constructor () public {
305     addRole(msg.sender, ROLE_LOCKUP);
306     addRole(msg.sender, ROLE_MINT);
307   }
308 
309   /**
310    * @dev Throws if called by any account that's not a Admin.
311    */
312   modifier onlyAdmin(string _role) {
313     checkRole(msg.sender, _role);
314     _;
315   }
316 
317   modifier onlyOwnerOrAdmin(string _role) {
318     require(msg.sender == owner || isAdmin(msg.sender, _role));
319     _;
320   }
321 
322   /**
323    * @dev getter to determine if address has Admin role
324    */
325   function isAdmin(address _addr, string _role)
326     public
327     view
328     returns (bool)
329   {
330     return hasRole(_addr, _role);
331   }
332 
333   /**
334    * @dev add a admin role to an address
335    * @param _operator address
336    * @param _role the name of the role
337    */
338   function addAdmin(address _operator, string _role)
339     public
340     onlyOwner
341   {
342     addRole(_operator, _role);
343   }
344 
345   /**
346    * @dev remove a admin role from an address
347    * @param _operator address
348    * @param _role the name of the role
349    */
350   function removeAdmin(address _operator, string _role)
351     public
352     onlyOwner
353   {
354     removeRole(_operator, _role);
355   }
356 
357   /**
358    * @dev claim a admin role from an address
359    * @param _role the name of the role
360    */
361   function claimAdmin(string _role)
362     public
363     onlyOwner
364   {
365     removeRoleAll(_role);
366 
367     addRole(msg.sender, _role);
368   }
369 }
370 
371 
372 /**
373  * @title Lockable
374  * @dev Base contract which allows children to implement an emergency stop mechanism.
375  */
376 contract Lockable is Administrable {
377 
378   using SafeMath for uint256;
379 
380   event Locked(address _granted, uint256 _amount, uint256 _expiresAt);
381   event UnlockedAll(address _granted);
382 
383   /**
384   * @dev Lock defines a lock of token
385   */
386   struct Lock {
387     uint256 amount;
388     uint256 expiresAt;
389   }
390 
391   // granted to locks;
392   mapping (address => Lock[]) public grantedLocks;
393   
394 
395   /**
396    * @dev called by the owner to lock, triggers stopped state
397    */
398   function lock
399   (
400     address _granted, 
401     uint256 _amount, 
402     uint256 _expiresAt
403   ) 
404     onlyOwnerOrAdmin(ROLE_LOCKUP) 
405     public 
406   {
407     require(_amount > 0);
408     require(_expiresAt > now);
409 
410     grantedLocks[_granted].push(Lock(_amount, _expiresAt));
411 
412     emit Locked(_granted, _amount, _expiresAt);
413   }
414 
415   /**
416    * @dev called by the owner to unlock, returns to normal state
417    */
418   function unlock
419   (
420     address _granted
421   ) 
422     onlyOwnerOrAdmin(ROLE_LOCKUP) 
423     public 
424   {
425     require(grantedLocks[_granted].length > 0);
426     
427     delete grantedLocks[_granted];
428     emit UnlockedAll(_granted);
429   }
430 
431   function lockedAmountOf
432   (
433     address _granted
434   ) 
435     public
436     view
437     returns(uint256)
438   {
439     require(_granted != address(0));
440     
441     uint256 lockedAmount = 0;
442     uint256 lockedCount = grantedLocks[_granted].length;
443     if (lockedCount > 0) {
444       Lock[] storage locks = grantedLocks[_granted];
445       for (uint i = 0; i < locks.length; i++) {
446         if (now < locks[i].expiresAt) {
447           lockedAmount = lockedAmount.add(locks[i].amount);
448         } 
449       }
450     }
451 
452     return lockedAmount;
453   }
454 }
455 
456 
457 /**
458  * @title Pausable
459  * @dev Base contract which allows children to implement an emergency stop mechanism.
460  */
461 contract Pausable is Ownable  {
462   event Pause();
463   event Unpause();
464 
465   bool public paused = false;
466 
467   /**
468    * @dev Modifier to make a function callable only when the contract is not paused.
469    */
470   modifier whenNotPaused() {
471     require(!paused);
472     _;
473   }
474 
475   /**
476    * @dev Modifier to make a function callable only when the contract is paused.
477    */
478   modifier whenPaused() {
479     require(paused);
480     _;
481   }
482 
483   /**
484    * @dev called by the owner to pause, triggers stopped state
485    */
486   function pause() onlyOwner whenNotPaused public {
487     paused = true;
488     emit Pause();
489   }
490 
491   /**
492    * @dev called by the owner to unpause, returns to normal state
493    */
494   function unpause() onlyOwner whenPaused public {
495     paused = false;
496     emit Unpause();
497   }
498 }
499 
500 
501 /**
502  * @title ERC20Basic
503  * @dev Simpler version of ERC20 interface
504  * @dev see https://github.com/ethereum/EIPs/issues/179
505  */
506 contract ERC20Basic {
507   function totalSupply() public view returns (uint256);
508   function balanceOf(address who) public view returns (uint256);
509   function transfer(address to, uint256 value) public returns (bool);
510   event Transfer(address indexed from, address indexed to, uint256 value);
511 }
512 
513 
514 /**
515  * @title ERC20 interface
516  * @dev see https://github.com/ethereum/EIPs/issues/20
517  */
518 contract ERC20 is ERC20Basic {
519   function allowance(address owner, address spender) public view returns (uint256);
520   function transferFrom(address from, address to, uint256 value) public returns (bool);
521   function approve(address spender, uint256 value) public returns (bool);
522   event Approval(address indexed owner, address indexed spender, uint256 value);
523 }
524 
525 
526 
527 contract BasicToken is ERC20Basic {
528     using SafeMath for uint256;
529 
530     mapping(address => uint256) balances;
531 
532     uint256 totalSupply_;
533 
534     /**
535     * @dev total number of tokens in exsitence
536     */
537     function totalSupply() public view returns (uint256) {
538         return totalSupply_;
539     }
540 
541     function msgSender() 
542         public
543         view
544         returns (address)
545     {
546         return msg.sender;
547     }
548 
549     function transfer(
550         address _to, 
551         uint256 _value
552     ) 
553         public 
554         returns (bool) 
555     {
556         require(_to != address(0));
557         require(_to != msg.sender);
558         require(_value <= balances[msg.sender]);
559         
560         balances[msg.sender] = balances[msg.sender].sub(_value);
561         balances[_to] = balances[_to].add(_value);
562         emit Transfer(msg.sender, _to, _value);
563         return true;
564     }
565 
566     /**
567      * @dev Gets the balance of the specified address.
568      * @return An uint256 representing the amount owned by the passed address.
569      */
570     function balanceOf(address _owner) public view returns (uint256) {
571         return balances[_owner];
572     }
573 }
574 
575 
576 
577 /**
578  * @title Standard ERC20 token
579  *
580  * @dev Implementation of the basic standard token.
581  * https://github.com/ethereum/EIPs/issues/20
582  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
583  */
584 contract StandardToken is ERC20, BasicToken {
585 
586   mapping (address => mapping (address => uint256)) internal allowed;
587 
588 
589   /**
590    * @dev Transfer tokens from one address to another
591    * @param _from address The address which you want to send tokens from
592    * @param _to address The address which you want to transfer to
593    * @param _value uint256 the amount of tokens to be transferred
594    */
595   function transferFrom(
596     address _from,
597     address _to,
598     uint256 _value
599   )
600     public
601     returns (bool)
602   {
603     require(_to != address(0));
604     require(_value <= balances[_from]);
605     require(_value <= allowed[_from][msg.sender]);
606 
607     balances[_from] = balances[_from].sub(_value);
608     balances[_to] = balances[_to].add(_value);
609     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
610     emit Transfer(_from, _to, _value);
611     return true;
612   }
613 
614   /**
615    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
616    * Beware that changing an allowance with this method brings the risk that someone may use both the old
617    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
618    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
619    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
620    * @param _spender The address which will spend the funds.
621    * @param _value The amount of tokens to be spent.
622    */
623   function approve(address _spender, uint256 _value) public returns (bool) {
624     allowed[msg.sender][_spender] = _value;
625     emit Approval(msg.sender, _spender, _value);
626     return true;
627   }
628 
629   /**
630    * @dev Function to check the amount of tokens that an owner allowed to a spender.
631    * @param _owner address The address which owns the funds.
632    * @param _spender address The address which will spend the funds.
633    * @return A uint256 specifying the amount of tokens still available for the spender.
634    */
635   function allowance(
636     address _owner,
637     address _spender
638    )
639     public
640     view
641     returns (uint256)
642   {
643     return allowed[_owner][_spender];
644   }
645 
646   /**
647    * @dev Increase the amount of tokens that an owner allowed to a spender.
648    * approve should be called when allowed[_spender] == 0. To increment
649    * allowed value is better to use this function to avoid 2 calls (and wait until
650    * the first transaction is mined)
651    * From MonolithDAO Token.sol
652    * @param _spender The address which will spend the funds.
653    * @param _addedValue The amount of tokens to increase the allowance by.
654    */
655   function increaseApproval(
656     address _spender,
657     uint256 _addedValue
658   )
659     public
660     returns (bool)
661   {
662     allowed[msg.sender][_spender] = (
663       allowed[msg.sender][_spender].add(_addedValue));
664     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
665     return true;
666   }
667 
668   /**
669    * @dev Decrease the amount of tokens that an owner allowed to a spender.
670    * approve should be called when allowed[_spender] == 0. To decrement
671    * allowed value is better to use this function to avoid 2 calls (and wait until
672    * the first transaction is mined)
673    * From MonolithDAO Token.sol
674    * @param _spender The address which will spend the funds.
675    * @param _subtractedValue The amount of tokens to decrease the allowance by.
676    */
677   function decreaseApproval(
678     address _spender,
679     uint256 _subtractedValue
680   )
681     public
682     returns (bool)
683   {
684     uint256 oldValue = allowed[msg.sender][_spender];
685     if (_subtractedValue > oldValue) {
686       allowed[msg.sender][_spender] = 0;
687     } else {
688       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
689     }
690     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
691     return true;
692   }
693 
694 }
695 
696 
697 contract BurnableToken is StandardToken {
698     
699     event Burn(address indexed burner, uint256 value);
700 
701     /**
702     * @dev Burns a specific amount of tokens.
703     * @param _value The amount of token to be burned.
704     */
705     function burn(uint256 _value) 
706         public 
707     {
708         _burn(msg.sender, _value);
709     }
710 
711     function _burn(address _who, uint256 _value) 
712         internal 
713     {
714         require(_value <= balances[_who]);
715         // no need to require value <= totalSupply, since that would imply the
716         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
717         
718         balances[_who] = balances[_who].sub(_value);
719         totalSupply_ = totalSupply_.sub(_value);
720         emit Burn(_who, _value);
721         emit Transfer(_who, address(0), _value);
722     }
723 }
724 
725 
726 
727 contract MintableToken is StandardToken, Administrable {
728     event Mint(address indexed to, uint256 amount);
729     event MintStarted();
730     event MintFinished();
731 
732     bool public mintingFinished = false;
733 
734     modifier canMint() {
735         require(!mintingFinished);
736         _;
737     }
738 
739     modifier cantMint() {
740         require(mintingFinished);
741         _;
742     }
743    
744     /**
745     * @dev Function to mint tokens
746     * @param _to The address that will receive the minted tokens.
747     * @param _amount The amount of tokens to mint
748     * @return A boolean that indicated if the operation was successful.
749     */
750     function mint(address _to, uint256 _amount) onlyOwnerOrAdmin(ROLE_MINT) canMint public returns (bool) {
751         totalSupply_ = totalSupply_.add(_amount);
752         balances[_to] = balances[_to].add(_amount);
753         emit Mint(_to, _amount);
754         emit Transfer(address(0), _to, _amount);
755         return true;
756     }
757 
758     /**
759      * @dev Function to start minting new tokens.
760      * @return True if the operation was successful. 
761      */
762     function startMinting() onlyOwner cantMint public returns (bool) {
763         mintingFinished = false;
764         emit MintStarted();
765         return true;
766     }
767 
768     /**
769      * @dev Function to stop minting new tokens.
770      * @return True if the operation was successful. 
771      */
772     function finishMinting() onlyOwner canMint public returns (bool) {
773         mintingFinished = true;
774         emit MintFinished();
775         return true;
776     }
777 }
778 
779 
780 
781 
782 /**
783  * @title Lockable token
784  * @dev ReliableTokenToken modified with lockable transfers.
785  **/
786 contract ReliableToken is MintableToken, BurnableToken, Pausable, Lockable {
787 
788   using SafeMath for uint256;
789 
790   /**
791    * @dev Modifier to make a function callable only when the contract is not paused.
792    */
793   modifier whenNotExceedLock(address _granted, uint256 _value) {
794     uint256 lockedAmount = lockedAmountOf(_granted);
795     uint256 balance = balanceOf(_granted);
796 
797     require(balance > lockedAmount && balance.sub(lockedAmount) >= _value);
798     _;
799   }
800 
801   function transfer
802   (
803     address _to,
804     uint256 _value
805   )
806     public
807     whenNotPaused
808     whenNotExceedLock(msg.sender, _value)
809     returns (bool)
810   {
811     return super.transfer(_to, _value);
812   }
813 
814   function transferLocked
815   (
816     address _to, 
817     uint256 _value,
818     uint256 _lockAmount,
819     uint256[] _expiresAtList
820   ) 
821     public 
822     whenNotPaused
823     whenNotExceedLock(msg.sender, _value)
824     onlyOwnerOrAdmin(ROLE_LOCKUP)
825     returns (bool) 
826   {
827     require(_value >= _lockAmount);
828 
829     uint256 lockCount = _expiresAtList.length;
830     if (lockCount > 0) {
831       (uint256 lockAmountEach, uint256 remainder) = _lockAmount.divRemain(lockCount);
832       if (lockAmountEach > 0) {
833         for (uint i = 0; i < lockCount; i++) {
834           if (i == (lockCount - 1) && remainder > 0)
835             lockAmountEach = lockAmountEach.add(remainder);
836 
837           lock(_to, lockAmountEach, _expiresAtList[i]);  
838         }
839       }
840     }
841     
842     return transfer(_to, _value);
843   }
844 
845   function transferFrom
846   (
847     address _from,
848     address _to,
849     uint256 _value
850   )
851     public
852     whenNotPaused
853     whenNotExceedLock(_from, _value)
854     returns (bool)
855   {
856     return super.transferFrom(_from, _to, _value);
857   }
858 
859   function transferLockedFrom
860   (
861     address _from,
862     address _to, 
863     uint256 _value,
864     uint256 _lockAmount,
865     uint256[] _expiresAtList
866   ) 
867     public 
868     whenNotPaused
869     whenNotExceedLock(_from, _value)
870     onlyOwnerOrAdmin(ROLE_LOCKUP)
871     returns (bool) 
872   {
873     require(_value >= _lockAmount);
874 
875     uint256 lockCount = _expiresAtList.length;
876     if (lockCount > 0) {
877       (uint256 lockAmountEach, uint256 remainder) = _lockAmount.divRemain(lockCount);
878       if (lockAmountEach > 0) {
879         for (uint i = 0; i < lockCount; i++) {
880           if (i == (lockCount - 1) && remainder > 0)
881             lockAmountEach = lockAmountEach.add(remainder);
882 
883           lock(_to, lockAmountEach, _expiresAtList[i]);  
884         }
885       }
886     }
887 
888     return transferFrom(_from, _to, _value);
889   }
890 
891   function approve
892   (
893     address _spender,
894     uint256 _value
895   )
896     public
897     whenNotPaused
898     returns (bool)
899   {
900     return super.approve(_spender, _value);
901   }
902 
903   function increaseApproval
904   (
905     address _spender,
906     uint _addedValue
907   )
908     public
909     whenNotPaused
910     returns (bool success)
911   {
912     return super.increaseApproval(_spender, _addedValue);
913   }
914 
915   function decreaseApproval
916   (
917     address _spender,
918     uint _subtractedValue
919   )
920     public
921     whenNotPaused
922     returns (bool success)
923   {
924     return super.decreaseApproval(_spender, _subtractedValue);
925   }
926 
927   function () external payable 
928   {
929     revert();
930   }
931 }
932 
933 
934 contract BundableToken is ReliableToken {
935 
936     /**
937     * @dev Transfers tokens to recipients multiply.
938     * @param _recipients address list of the recipients to whom received tokens 
939     * @param _values the amount list of tokens to be transferred
940     */
941     function transferMultiply
942     (
943         address[] _recipients,
944         uint256[] _values
945     )
946         public
947         returns (bool)
948     {
949         uint length = _recipients.length;
950         require(length > 0);
951         require(length == _values.length);
952 
953         for (uint i = 0; i < length; i++) {
954             require(transfer(
955                 _recipients[i], 
956                 _values[i]
957             ));
958         }
959 
960         return true;
961     }
962 
963     /**
964     * @dev Transfers tokens held by timelock to recipients multiply.
965     * @param _recipients address list of the recipients to whom received tokens 
966     * @param _values the amount list of tokens to be transferred
967     * #param _defaultExpiresAtList default release times
968     */
969     function transferLockedMultiply
970     (
971         address[] _recipients,
972         uint256[] _values,
973         uint256[] _lockAmounts,
974         uint256[] _defaultExpiresAtList
975     )
976         public
977         onlyOwnerOrAdmin(ROLE_LOCKUP)
978         returns (bool)
979     {
980         uint length = _recipients.length;
981         require(length > 0);
982         require(length == _values.length && length == _lockAmounts.length);
983         require(_defaultExpiresAtList.length > 0);
984 
985         for (uint i = 0; i < length; i++) {
986             require(transferLocked(
987                 _recipients[i], 
988                 _values[i], 
989                 _lockAmounts[i], 
990                 _defaultExpiresAtList
991             ));
992         }
993 
994         return true;
995     }
996 }
997 
998 
999 contract AIEToken is BundableToken {
1000 
1001   string public constant name = "AIECOLOGY";
1002   string public constant symbol = "AIE";
1003   uint32 public constant decimals = 18;
1004 
1005   uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
1006 
1007   /**
1008   * @dev Constructor that gives msg.sender all of existing tokens.
1009   */
1010   constructor() public 
1011   {
1012     totalSupply_ = INITIAL_SUPPLY;
1013     balances[msg.sender] = INITIAL_SUPPLY;
1014     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
1015   }
1016 }