1 pragma solidity 0.4.21;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: zeppelin-solidity/contracts/math/SafeMath.sol
46 
47 /**
48  * @title SafeMath
49  * @dev Math operations with safety checks that throw on error
50  */
51 library SafeMath {
52 
53   /**
54   * @dev Multiplies two numbers, throws on overflow.
55   */
56   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57     if (a == 0) {
58       return 0;
59     }
60     uint256 c = a * b;
61     assert(c / a == b);
62     return c;
63   }
64 
65   /**
66   * @dev Integer division of two numbers, truncating the quotient.
67   */
68   function div(uint256 a, uint256 b) internal pure returns (uint256) {
69     // assert(b > 0); // Solidity automatically throws when dividing by 0
70     uint256 c = a / b;
71     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72     return c;
73   }
74 
75   /**
76   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
77   */
78   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79     assert(b <= a);
80     return a - b;
81   }
82 
83   /**
84   * @dev Adds two numbers, throws on overflow.
85   */
86   function add(uint256 a, uint256 b) internal pure returns (uint256) {
87     uint256 c = a + b;
88     assert(c >= a);
89     return c;
90   }
91 }
92 
93 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/179
99  */
100 contract ERC20Basic {
101   function totalSupply() public view returns (uint256);
102   function balanceOf(address who) public view returns (uint256);
103   function transfer(address to, uint256 value) public returns (bool);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
108 
109 /**
110  * @title Basic token
111  * @dev Basic version of StandardToken, with no allowances.
112  */
113 contract BasicToken is ERC20Basic {
114   using SafeMath for uint256;
115 
116   mapping(address => uint256) balances;
117 
118   uint256 totalSupply_;
119 
120   /**
121   * @dev total number of tokens in existence
122   */
123   function totalSupply() public view returns (uint256) {
124     return totalSupply_;
125   }
126 
127   /**
128   * @dev transfer token for a specified address
129   * @param _to The address to transfer to.
130   * @param _value The amount to be transferred.
131   */
132   function transfer(address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(_value <= balances[msg.sender]);
135 
136     // SafeMath.sub will throw if there is not enough balance.
137     balances[msg.sender] = balances[msg.sender].sub(_value);
138     balances[_to] = balances[_to].add(_value);
139     Transfer(msg.sender, _to, _value);
140     return true;
141   }
142 
143   /**
144   * @dev Gets the balance of the specified address.
145   * @param _owner The address to query the the balance of.
146   * @return An uint256 representing the amount owned by the passed address.
147   */
148   function balanceOf(address _owner) public view returns (uint256 balance) {
149     return balances[_owner];
150   }
151 
152 }
153 
154 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
155 
156 /**
157  * @title ERC20 interface
158  * @dev see https://github.com/ethereum/EIPs/issues/20
159  */
160 contract ERC20 is ERC20Basic {
161   function allowance(address owner, address spender) public view returns (uint256);
162   function transferFrom(address from, address to, uint256 value) public returns (bool);
163   function approve(address spender, uint256 value) public returns (bool);
164   event Approval(address indexed owner, address indexed spender, uint256 value);
165 }
166 
167 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
168 
169 /**
170  * @title Standard ERC20 token
171  *
172  * @dev Implementation of the basic standard token.
173  * @dev https://github.com/ethereum/EIPs/issues/20
174  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
175  */
176 contract StandardToken is ERC20, BasicToken {
177 
178   mapping (address => mapping (address => uint256)) internal allowed;
179 
180 
181   /**
182    * @dev Transfer tokens from one address to another
183    * @param _from address The address which you want to send tokens from
184    * @param _to address The address which you want to transfer to
185    * @param _value uint256 the amount of tokens to be transferred
186    */
187   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
188     require(_to != address(0));
189     require(_value <= balances[_from]);
190     require(_value <= allowed[_from][msg.sender]);
191 
192     balances[_from] = balances[_from].sub(_value);
193     balances[_to] = balances[_to].add(_value);
194     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
195     Transfer(_from, _to, _value);
196     return true;
197   }
198 
199   /**
200    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
201    *
202    * Beware that changing an allowance with this method brings the risk that someone may use both the old
203    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
204    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
205    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
206    * @param _spender The address which will spend the funds.
207    * @param _value The amount of tokens to be spent.
208    */
209   function approve(address _spender, uint256 _value) public returns (bool) {
210     allowed[msg.sender][_spender] = _value;
211     Approval(msg.sender, _spender, _value);
212     return true;
213   }
214 
215   /**
216    * @dev Function to check the amount of tokens that an owner allowed to a spender.
217    * @param _owner address The address which owns the funds.
218    * @param _spender address The address which will spend the funds.
219    * @return A uint256 specifying the amount of tokens still available for the spender.
220    */
221   function allowance(address _owner, address _spender) public view returns (uint256) {
222     return allowed[_owner][_spender];
223   }
224 
225   /**
226    * @dev Increase the amount of tokens that an owner allowed to a spender.
227    *
228    * approve should be called when allowed[_spender] == 0. To increment
229    * allowed value is better to use this function to avoid 2 calls (and wait until
230    * the first transaction is mined)
231    * From MonolithDAO Token.sol
232    * @param _spender The address which will spend the funds.
233    * @param _addedValue The amount of tokens to increase the allowance by.
234    */
235   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
236     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
237     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238     return true;
239   }
240 
241   /**
242    * @dev Decrease the amount of tokens that an owner allowed to a spender.
243    *
244    * approve should be called when allowed[_spender] == 0. To decrement
245    * allowed value is better to use this function to avoid 2 calls (and wait until
246    * the first transaction is mined)
247    * From MonolithDAO Token.sol
248    * @param _spender The address which will spend the funds.
249    * @param _subtractedValue The amount of tokens to decrease the allowance by.
250    */
251   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
252     uint oldValue = allowed[msg.sender][_spender];
253     if (_subtractedValue > oldValue) {
254       allowed[msg.sender][_spender] = 0;
255     } else {
256       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
257     }
258     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259     return true;
260   }
261 
262 }
263 
264 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
265 
266 /**
267  * @title Mintable token
268  * @dev Simple ERC20 Token example, with mintable token creation
269  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
270  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
271  */
272 contract MintableToken is StandardToken, Ownable {
273   event Mint(address indexed to, uint256 amount);
274   event MintFinished();
275 
276   bool public mintingFinished = false;
277 
278 
279   modifier canMint() {
280     require(!mintingFinished);
281     _;
282   }
283 
284   /**
285    * @dev Function to mint tokens
286    * @param _to The address that will receive the minted tokens.
287    * @param _amount The amount of tokens to mint.
288    * @return A boolean that indicates if the operation was successful.
289    */
290   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
291     totalSupply_ = totalSupply_.add(_amount);
292     balances[_to] = balances[_to].add(_amount);
293     Mint(_to, _amount);
294     Transfer(address(0), _to, _amount);
295     return true;
296   }
297 
298   /**
299    * @dev Function to stop minting new tokens.
300    * @return True if the operation was successful.
301    */
302   function finishMinting() onlyOwner canMint public returns (bool) {
303     mintingFinished = true;
304     MintFinished();
305     return true;
306   }
307 }
308 
309 // File: contracts/ZerochainToken.sol
310 
311 contract ZerochainToken is MintableToken {
312     string public constant name = "0chain";
313     string public constant symbol = "ZCN";
314     uint8 public constant decimals = 10;
315 }
316 
317 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
318 
319 /**
320  * @title Pausable
321  * @dev Base contract which allows children to implement an emergency stop mechanism.
322  */
323 contract Pausable is Ownable {
324   event Pause();
325   event Unpause();
326 
327   bool public paused = false;
328 
329 
330   /**
331    * @dev Modifier to make a function callable only when the contract is not paused.
332    */
333   modifier whenNotPaused() {
334     require(!paused);
335     _;
336   }
337 
338   /**
339    * @dev Modifier to make a function callable only when the contract is paused.
340    */
341   modifier whenPaused() {
342     require(paused);
343     _;
344   }
345 
346   /**
347    * @dev called by the owner to pause, triggers stopped state
348    */
349   function pause() onlyOwner whenNotPaused public {
350     paused = true;
351     Pause();
352   }
353 
354   /**
355    * @dev called by the owner to unpause, returns to normal state
356    */
357   function unpause() onlyOwner whenPaused public {
358     paused = false;
359     Unpause();
360   }
361 }
362 
363 // File: zeppelin-solidity/contracts/ownership/rbac/Roles.sol
364 
365 /**
366  * @title Roles
367  * @author Francisco Giordano (@frangio)
368  * @dev Library for managing addresses assigned to a Role.
369  *      See RBAC.sol for example usage.
370  */
371 library Roles {
372   struct Role {
373     mapping (address => bool) bearer;
374   }
375 
376   /**
377    * @dev give an address access to this role
378    */
379   function add(Role storage role, address addr)
380     internal
381   {
382     role.bearer[addr] = true;
383   }
384 
385   /**
386    * @dev remove an address' access to this role
387    */
388   function remove(Role storage role, address addr)
389     internal
390   {
391     role.bearer[addr] = false;
392   }
393 
394   /**
395    * @dev check if an address has this role
396    * // reverts
397    */
398   function check(Role storage role, address addr)
399     view
400     internal
401   {
402     require(has(role, addr));
403   }
404 
405   /**
406    * @dev check if an address has this role
407    * @return bool
408    */
409   function has(Role storage role, address addr)
410     view
411     internal
412     returns (bool)
413   {
414     return role.bearer[addr];
415   }
416 }
417 
418 // File: zeppelin-solidity/contracts/ownership/rbac/RBAC.sol
419 
420 /**
421  * @title RBAC (Role-Based Access Control)
422  * @author Matt Condon (@Shrugs)
423  * @dev Stores and provides setters and getters for roles and addresses.
424  *      Supports unlimited numbers of roles and addresses.
425  *      See //contracts/mocks/RBACMock.sol for an example of usage.
426  * This RBAC method uses strings to key roles. It may be beneficial
427  *  for you to write your own implementation of this interface using Enums or similar.
428  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
429  *  to avoid typos.
430  */
431 contract RBAC {
432   using Roles for Roles.Role;
433 
434   mapping (string => Roles.Role) private roles;
435 
436   event RoleAdded(address addr, string roleName);
437   event RoleRemoved(address addr, string roleName);
438 
439   /**
440    * A constant role name for indicating admins.
441    */
442   string public constant ROLE_ADMIN = "admin";
443 
444   /**
445    * @dev constructor. Sets msg.sender as admin by default
446    */
447   function RBAC()
448     public
449   {
450     addRole(msg.sender, ROLE_ADMIN);
451   }
452 
453   /**
454    * @dev reverts if addr does not have role
455    * @param addr address
456    * @param roleName the name of the role
457    * // reverts
458    */
459   function checkRole(address addr, string roleName)
460     view
461     public
462   {
463     roles[roleName].check(addr);
464   }
465 
466   /**
467    * @dev determine if addr has role
468    * @param addr address
469    * @param roleName the name of the role
470    * @return bool
471    */
472   function hasRole(address addr, string roleName)
473     view
474     public
475     returns (bool)
476   {
477     return roles[roleName].has(addr);
478   }
479 
480   /**
481    * @dev add a role to an address
482    * @param addr address
483    * @param roleName the name of the role
484    */
485   function adminAddRole(address addr, string roleName)
486     onlyAdmin
487     public
488   {
489     addRole(addr, roleName);
490   }
491 
492   /**
493    * @dev remove a role from an address
494    * @param addr address
495    * @param roleName the name of the role
496    */
497   function adminRemoveRole(address addr, string roleName)
498     onlyAdmin
499     public
500   {
501     removeRole(addr, roleName);
502   }
503 
504   /**
505    * @dev add a role to an address
506    * @param addr address
507    * @param roleName the name of the role
508    */
509   function addRole(address addr, string roleName)
510     internal
511   {
512     roles[roleName].add(addr);
513     RoleAdded(addr, roleName);
514   }
515 
516   /**
517    * @dev remove a role from an address
518    * @param addr address
519    * @param roleName the name of the role
520    */
521   function removeRole(address addr, string roleName)
522     internal
523   {
524     roles[roleName].remove(addr);
525     RoleRemoved(addr, roleName);
526   }
527 
528   /**
529    * @dev modifier to scope access to a single role (uses msg.sender as addr)
530    * @param roleName the name of the role
531    * // reverts
532    */
533   modifier onlyRole(string roleName)
534   {
535     checkRole(msg.sender, roleName);
536     _;
537   }
538 
539   /**
540    * @dev modifier to scope access to admins
541    * // reverts
542    */
543   modifier onlyAdmin()
544   {
545     checkRole(msg.sender, ROLE_ADMIN);
546     _;
547   }
548 
549   /**
550    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
551    * @param roleNames the names of the roles to scope access to
552    * // reverts
553    *
554    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
555    *  see: https://github.com/ethereum/solidity/issues/2467
556    */
557   // modifier onlyRoles(string[] roleNames) {
558   //     bool hasAnyRole = false;
559   //     for (uint8 i = 0; i < roleNames.length; i++) {
560   //         if (hasRole(msg.sender, roleNames[i])) {
561   //             hasAnyRole = true;
562   //             break;
563   //         }
564   //     }
565 
566   //     require(hasAnyRole);
567 
568   //     _;
569   // }
570 }
571 
572 // File: contracts/MultipleTokenVesting.sol
573 
574 /**
575  * @title MultipleTokenVesting
576  * @dev A token holder contract that can release its token balance gradually like a
577  * typical vesting scheme, for multiple users with a cliff and vesting period.
578  */
579 contract MultipleTokenVesting is Pausable, RBAC {
580     using SafeMath for uint256;
581 
582     event Released(address indexed beneficiary, uint256 indexed amount);
583     event Vested(address indexed beneficiary, uint256 indexed amount);
584     event Activated();
585     event VestingFinished();
586     event Airdrop(address indexed beneficiary);
587 
588     // beneficiaries of tokens with respective amounts of tokens to be released
589     mapping (address => uint256) public beneficiaries;
590     // beneficiaries of tokens with respective amounts of tokens already released
591     mapping (address => uint256) public released;
592 
593     ZerochainToken public token;
594 
595     uint256 public cliff;
596     uint256 public start;
597     uint256 public duration;
598     bool public isActive = false;
599     bool public canIssueIndividual = true;
600 
601     uint256 public constant AIRDROP_AMOUNT = 10 * (10 ** 10);
602     string public constant UTILITY_ROLE = "utility";
603     address public utilityAccount;
604     uint256 public hardCap;
605 
606     /**
607      * @dev Creates a vesting contract and a token.
608      * @param _start timestamp for the moment when vesting should be considered as started
609      * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
610      * @param _duration duration in seconds of the period in which the tokens will vest
611      */
612     function MultipleTokenVesting(
613         uint256 _start,
614         uint256 _cliff,
615         uint256 _duration,
616         address _utilityAccount,
617         uint256 _hardCap
618     )
619     public
620     {
621         require(_cliff <= _duration);
622         require(_utilityAccount != address(0));
623         require(_hardCap > 0);
624 
625         token = new ZerochainToken();
626         duration = _duration;
627         cliff = _start.add(_cliff);
628         start = _start;
629         utilityAccount = _utilityAccount;
630         addRole(_utilityAccount, UTILITY_ROLE);
631         hardCap = _hardCap;
632     }
633 
634     function changeUtilityAccount (
635         address newAddress
636     ) public onlyOwner {
637         require(newAddress != address(0));
638         removeRole(utilityAccount, UTILITY_ROLE);
639         utilityAccount = newAddress;
640         addRole(utilityAccount, UTILITY_ROLE);
641     }
642 
643     function activate() public onlyOwner {
644         require(!isActive);
645         isActive = true;
646         Activated();
647     }
648 
649     function finalise() public onlyOwner {
650         token.finishMinting();
651         VestingFinished();
652     }
653 
654     function stopIssuingIndividualTokens() public onlyOwner {
655         require(canIssueIndividual);
656         canIssueIndividual = false;
657     }
658 
659     function issueIndividualTokens(
660         address beneficiary,
661         uint256 amount
662     ) public onlyOwner {
663         require(beneficiary != address(0));
664         require(amount != 0);
665         require(canIssueIndividual);
666         require(token.totalSupply().add(amount) <= hardCap);
667 
668         token.mint(beneficiary, amount);
669     }
670 
671     /**
672      * @dev Main means of adding information about beneficiaries who should have tokens vested for them.
673      * We add users in array to save gas for such operation.
674      * @param _beneficiaries user addresses array whose tokens need to be vested.
675      * @param _amounts amount of tokens for vesting array which is related to the user with same idx.
676      **/
677     function addVestingForBeneficiaries(
678         address[] _beneficiaries,
679         uint256[] _amounts
680     ) public onlyRole(UTILITY_ROLE) whenNotPaused {
681         require(_beneficiaries.length == _amounts.length);
682         for (uint i = 0; i < _beneficiaries.length; i++) {
683             addVestingForBeneficiary(_beneficiaries[i], _amounts[i]);
684         }
685     }
686 
687     function releaseMultiple(
688         address[] _beneficiaries
689     ) public onlyRole(UTILITY_ROLE) whenNotPaused {
690         require(isActive);
691         for (uint i = 0; i < _beneficiaries.length; i++) {
692             release(_beneficiaries[i]);
693         }
694     }
695 
696     function airdropMultiple(
697         address[] _beneficiaries
698     ) public onlyRole(UTILITY_ROLE) whenNotPaused {
699         require(isActive);
700         require(block.timestamp >= cliff);
701         for (uint i = 0; i < _beneficiaries.length; i++) {
702             require(_beneficiaries[i] != address(0));
703             airdrop(_beneficiaries[i]);
704         }
705     }
706 
707     /**
708      * @dev Calculates the amount that has already vested but hasn't been released yet.
709      */
710     function releasableAmount() public view returns (uint256) {
711         return _releasableAmount(msg.sender);
712     }
713 
714     /**
715      * @dev Calculates the amount that has already vested.
716      */
717     function vestedAmount() public view returns (uint256) {
718         return _vestedAmount(msg.sender);
719     }
720 
721     /**
722      * @notice Transfers vested tokens to beneficiary.
723      */
724     function release(
725         address beneficiary
726     ) internal {
727 
728         uint256 unreleased = _releasableAmount(beneficiary);
729 
730         require(unreleased > 0);
731 
732         released[beneficiary] = released[beneficiary].add(unreleased);
733 
734         token.transfer(beneficiary, unreleased);
735 
736         Released(beneficiary, unreleased);
737     }
738 
739     function _releasableAmount(
740         address beneficiary
741     ) internal view returns (uint256) {
742         return _vestedAmount(beneficiary).sub(released[beneficiary]);
743     }
744 
745     function addVestingForBeneficiary(
746         address _beneficiary,
747         uint256 _amount
748     ) internal {
749         require(_beneficiary != address(0));
750         require(_amount > 0);
751         require(beneficiaries[_beneficiary] == 0);
752         require(token.totalSupply().add(_amount) <= hardCap);
753 
754         beneficiaries[_beneficiary] = _amount;
755         token.mint(this, _amount);
756         Vested(_beneficiary, _amount);
757     }
758 
759     function airdrop(
760         address _beneficiary
761     ) internal {
762         require(token.totalSupply().add(AIRDROP_AMOUNT) <= hardCap);
763 
764         token.mint(_beneficiary, AIRDROP_AMOUNT);
765         Airdrop(_beneficiary);
766     }
767 
768     function _vestedAmount(
769         address beneficiary
770     ) internal view returns (uint256) {
771         uint256 totalBalance = beneficiaries[beneficiary];
772 
773         if (block.timestamp < cliff) {
774             return 0;
775         } else if (block.timestamp >= start.add(duration)) {
776             return totalBalance;
777         } else {
778             return totalBalance.mul(block.timestamp.sub(start)).div(duration);
779         }
780     }
781 }