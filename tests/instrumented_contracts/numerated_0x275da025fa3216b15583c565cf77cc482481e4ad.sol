1 pragma solidity 0.4.18;
2 
3 // File: zeppelin-solidity/contracts/ownership/rbac/Roles.sol
4 
5 /**
6  * @title Roles
7  * @author Francisco Giordano (@frangio)
8  * @dev Library for managing addresses assigned to a Role.
9  *      See RBAC.sol for example usage.
10  */
11 library Roles {
12     struct Role {
13         mapping (address => bool) bearer;
14     }
15 
16     /**
17      * @dev give an address access to this role
18      */
19     function add(Role storage role, address addr)
20         internal
21     {
22         role.bearer[addr] = true;
23     }
24 
25     /**
26      * @dev remove an address' access to this role
27      */
28     function remove(Role storage role, address addr)
29         internal
30     {
31         role.bearer[addr] = false;
32     }
33 
34     /**
35      * @dev check if an address has this role
36      * // reverts
37      */
38     function check(Role storage role, address addr)
39         view
40         internal
41     {
42         require(has(role, addr));
43     }
44 
45     /**
46      * @dev check if an address has this role
47      * @return bool
48      */
49     function has(Role storage role, address addr)
50         view
51         internal
52         returns (bool)
53     {
54         return role.bearer[addr];
55     }
56 }
57 
58 // File: zeppelin-solidity/contracts/ownership/rbac/RBAC.sol
59 
60 /**
61  * @title RBAC (Role-Based Access Control)
62  * @author Matt Condon (@Shrugs)
63  * @dev Stores and provides setters and getters for roles and addresses.
64  *      Supports unlimited numbers of roles and addresses.
65  *      See //contracts/examples/RBACExample.sol for an example of usage.
66  * This RBAC method uses strings to key roles. It may be beneficial
67  *  for you to write your own implementation of this interface using Enums or similar.
68  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
69  *  to avoid typos.
70  */
71 contract RBAC {
72     using Roles for Roles.Role;
73 
74     mapping (string => Roles.Role) private roles;
75 
76     event RoleAdded(address addr, string roleName);
77     event RoleRemoved(address addr, string roleName);
78 
79     /**
80      * A constant role name for indicating admins.
81      */
82     string public constant ROLE_ADMIN = "admin";
83 
84     /**
85      * @dev constructor. Sets msg.sender as admin by default
86      */
87     function RBAC()
88         public
89     {
90         addRole(msg.sender, ROLE_ADMIN);
91     }
92 
93     /**
94      * @dev add a role to an address
95      * @param addr address
96      * @param roleName the name of the role
97      */
98     function addRole(address addr, string roleName)
99         internal
100     {
101         roles[roleName].add(addr);
102         RoleAdded(addr, roleName);
103     }
104 
105     /**
106      * @dev remove a role from an address
107      * @param addr address
108      * @param roleName the name of the role
109      */
110     function removeRole(address addr, string roleName)
111         internal
112     {
113         roles[roleName].remove(addr);
114         RoleRemoved(addr, roleName);
115     }
116 
117     /**
118      * @dev reverts if addr does not have role
119      * @param addr address
120      * @param roleName the name of the role
121      * // reverts
122      */
123     function checkRole(address addr, string roleName)
124         view
125         public
126     {
127         roles[roleName].check(addr);
128     }
129 
130     /**
131      * @dev determine if addr has role
132      * @param addr address
133      * @param roleName the name of the role
134      * @return bool
135      */
136     function hasRole(address addr, string roleName)
137         view
138         public
139         returns (bool)
140     {
141         return roles[roleName].has(addr);
142     }
143 
144     /**
145      * @dev add a role to an address
146      * @param addr address
147      * @param roleName the name of the role
148      */
149     function adminAddRole(address addr, string roleName)
150         onlyAdmin
151         public
152     {
153         addRole(addr, roleName);
154     }
155 
156     /**
157      * @dev remove a role from an address
158      * @param addr address
159      * @param roleName the name of the role
160      */
161     function adminRemoveRole(address addr, string roleName)
162         onlyAdmin
163         public
164     {
165         removeRole(addr, roleName);
166     }
167 
168 
169     /**
170      * @dev modifier to scope access to a single role (uses msg.sender as addr)
171      * @param roleName the name of the role
172      * // reverts
173      */
174     modifier onlyRole(string roleName)
175     {
176         checkRole(msg.sender, roleName);
177         _;
178     }
179 
180     /**
181      * @dev modifier to scope access to admins
182      * // reverts
183      */
184     modifier onlyAdmin()
185     {
186         checkRole(msg.sender, ROLE_ADMIN);
187         _;
188     }
189 
190     /**
191      * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
192      * @param roleNames the names of the roles to scope access to
193      * // reverts
194      *
195      * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
196      *  see: https://github.com/ethereum/solidity/issues/2467
197      */
198     // modifier onlyRoles(string[] roleNames) {
199     //     bool hasAnyRole = false;
200     //     for (uint8 i = 0; i < roleNames.length; i++) {
201     //         if (hasRole(msg.sender, roleNames[i])) {
202     //             hasAnyRole = true;
203     //             break;
204     //         }
205     //     }
206 
207     //     require(hasAnyRole);
208 
209     //     _;
210     // }
211 }
212 
213 // File: zeppelin-solidity/contracts/math/SafeMath.sol
214 
215 /**
216  * @title SafeMath
217  * @dev Math operations with safety checks that throw on error
218  */
219 library SafeMath {
220   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
221     if (a == 0) {
222       return 0;
223     }
224     uint256 c = a * b;
225     assert(c / a == b);
226     return c;
227   }
228 
229   function div(uint256 a, uint256 b) internal pure returns (uint256) {
230     // assert(b > 0); // Solidity automatically throws when dividing by 0
231     uint256 c = a / b;
232     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
233     return c;
234   }
235 
236   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
237     assert(b <= a);
238     return a - b;
239   }
240 
241   function add(uint256 a, uint256 b) internal pure returns (uint256) {
242     uint256 c = a + b;
243     assert(c >= a);
244     return c;
245   }
246 }
247 
248 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
249 
250 /**
251  * @title ERC20Basic
252  * @dev Simpler version of ERC20 interface
253  * @dev see https://github.com/ethereum/EIPs/issues/179
254  */
255 contract ERC20Basic {
256   uint256 public totalSupply;
257   function balanceOf(address who) public view returns (uint256);
258   function transfer(address to, uint256 value) public returns (bool);
259   event Transfer(address indexed from, address indexed to, uint256 value);
260 }
261 
262 // File: zeppelin-solidity/contracts/token/BasicToken.sol
263 
264 /**
265  * @title Basic token
266  * @dev Basic version of StandardToken, with no allowances.
267  */
268 contract BasicToken is ERC20Basic {
269   using SafeMath for uint256;
270 
271   mapping(address => uint256) balances;
272 
273   /**
274   * @dev transfer token for a specified address
275   * @param _to The address to transfer to.
276   * @param _value The amount to be transferred.
277   */
278   function transfer(address _to, uint256 _value) public returns (bool) {
279     require(_to != address(0));
280     require(_value <= balances[msg.sender]);
281 
282     // SafeMath.sub will throw if there is not enough balance.
283     balances[msg.sender] = balances[msg.sender].sub(_value);
284     balances[_to] = balances[_to].add(_value);
285     Transfer(msg.sender, _to, _value);
286     return true;
287   }
288 
289   /**
290   * @dev Gets the balance of the specified address.
291   * @param _owner The address to query the the balance of.
292   * @return An uint256 representing the amount owned by the passed address.
293   */
294   function balanceOf(address _owner) public view returns (uint256 balance) {
295     return balances[_owner];
296   }
297 
298 }
299 
300 // File: zeppelin-solidity/contracts/token/BurnableToken.sol
301 
302 /**
303  * @title Burnable Token
304  * @dev Token that can be irreversibly burned (destroyed).
305  */
306 contract BurnableToken is BasicToken {
307 
308     event Burn(address indexed burner, uint256 value);
309 
310     /**
311      * @dev Burns a specific amount of tokens.
312      * @param _value The amount of token to be burned.
313      */
314     function burn(uint256 _value) public {
315         require(_value <= balances[msg.sender]);
316         // no need to require value <= totalSupply, since that would imply the
317         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
318 
319         address burner = msg.sender;
320         balances[burner] = balances[burner].sub(_value);
321         totalSupply = totalSupply.sub(_value);
322         Burn(burner, _value);
323     }
324 }
325 
326 // File: zeppelin-solidity/contracts/token/ERC20.sol
327 
328 /**
329  * @title ERC20 interface
330  * @dev see https://github.com/ethereum/EIPs/issues/20
331  */
332 contract ERC20 is ERC20Basic {
333   function allowance(address owner, address spender) public view returns (uint256);
334   function transferFrom(address from, address to, uint256 value) public returns (bool);
335   function approve(address spender, uint256 value) public returns (bool);
336   event Approval(address indexed owner, address indexed spender, uint256 value);
337 }
338 
339 // File: zeppelin-solidity/contracts/token/StandardToken.sol
340 
341 /**
342  * @title Standard ERC20 token
343  *
344  * @dev Implementation of the basic standard token.
345  * @dev https://github.com/ethereum/EIPs/issues/20
346  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
347  */
348 contract StandardToken is ERC20, BasicToken {
349 
350   mapping (address => mapping (address => uint256)) internal allowed;
351 
352 
353   /**
354    * @dev Transfer tokens from one address to another
355    * @param _from address The address which you want to send tokens from
356    * @param _to address The address which you want to transfer to
357    * @param _value uint256 the amount of tokens to be transferred
358    */
359   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
360     require(_to != address(0));
361     require(_value <= balances[_from]);
362     require(_value <= allowed[_from][msg.sender]);
363 
364     balances[_from] = balances[_from].sub(_value);
365     balances[_to] = balances[_to].add(_value);
366     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
367     Transfer(_from, _to, _value);
368     return true;
369   }
370 
371   /**
372    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
373    *
374    * Beware that changing an allowance with this method brings the risk that someone may use both the old
375    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
376    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
377    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
378    * @param _spender The address which will spend the funds.
379    * @param _value The amount of tokens to be spent.
380    */
381   function approve(address _spender, uint256 _value) public returns (bool) {
382     allowed[msg.sender][_spender] = _value;
383     Approval(msg.sender, _spender, _value);
384     return true;
385   }
386 
387   /**
388    * @dev Function to check the amount of tokens that an owner allowed to a spender.
389    * @param _owner address The address which owns the funds.
390    * @param _spender address The address which will spend the funds.
391    * @return A uint256 specifying the amount of tokens still available for the spender.
392    */
393   function allowance(address _owner, address _spender) public view returns (uint256) {
394     return allowed[_owner][_spender];
395   }
396 
397   /**
398    * @dev Increase the amount of tokens that an owner allowed to a spender.
399    *
400    * approve should be called when allowed[_spender] == 0. To increment
401    * allowed value is better to use this function to avoid 2 calls (and wait until
402    * the first transaction is mined)
403    * From MonolithDAO Token.sol
404    * @param _spender The address which will spend the funds.
405    * @param _addedValue The amount of tokens to increase the allowance by.
406    */
407   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
408     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
409     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
410     return true;
411   }
412 
413   /**
414    * @dev Decrease the amount of tokens that an owner allowed to a spender.
415    *
416    * approve should be called when allowed[_spender] == 0. To decrement
417    * allowed value is better to use this function to avoid 2 calls (and wait until
418    * the first transaction is mined)
419    * From MonolithDAO Token.sol
420    * @param _spender The address which will spend the funds.
421    * @param _subtractedValue The amount of tokens to decrease the allowance by.
422    */
423   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
424     uint oldValue = allowed[msg.sender][_spender];
425     if (_subtractedValue > oldValue) {
426       allowed[msg.sender][_spender] = 0;
427     } else {
428       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
429     }
430     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
431     return true;
432   }
433 
434 }
435 
436 // File: contracts/DUBI.sol
437 
438 contract DUBI is StandardToken, BurnableToken, RBAC {
439   string public constant name = "Decentralized Universal Basic Income";
440   string public constant symbol = "DUBI";
441   uint8 public constant decimals = 18;
442   string constant public ROLE_MINT = "mint";
443 
444   event MintLog(address indexed to, uint256 amount);
445 
446   function DUBI() public {
447     totalSupply = 0;
448   }
449 
450   // used by contracts to mint DUBI tokens
451   function mint(address _to, uint256 _amount) external onlyRole(ROLE_MINT) returns (bool) {
452     require(_to != address(0));
453     require(_amount > 0);
454 
455     // update state
456     totalSupply = totalSupply.add(_amount);
457     balances[_to] = balances[_to].add(_amount);
458 
459     // logs
460     MintLog(_to, _amount);
461     Transfer(0x0, _to, _amount);
462     
463     return true;
464   }
465 }
466 
467 // File: contracts/Purpose.sol
468 
469 contract Purpose is StandardToken, BurnableToken, RBAC {
470   string public constant name = "Purpose";
471   string public constant symbol = "PRPS";
472   uint8 public constant decimals = 18;
473   string constant public ROLE_BURN = "burn";
474   string constant public ROLE_TRANSFER = "transfer";
475   address public supplier;
476 
477   function Purpose(address _supplier) public {
478     supplier = _supplier;
479     totalSupply = 1000000000 ether;
480     balances[supplier] = totalSupply;
481   }
482   
483   // used by burner contract to burn athenes tokens
484   function supplyBurn(uint256 _value) external onlyRole(ROLE_BURN) returns (bool) {
485     require(_value > 0);
486 
487     // update state
488     balances[supplier] = balances[supplier].sub(_value);
489     totalSupply = totalSupply.sub(_value);
490 
491     // logs
492     Burn(supplier, _value);
493 
494     return true;
495   }
496 
497   // used by hodler contract to transfer users tokens to it
498   function hodlerTransfer(address _from, uint256 _value) external onlyRole(ROLE_TRANSFER) returns (bool) {
499     require(_from != address(0));
500     require(_value > 0);
501 
502     // hodler
503     address _hodler = msg.sender;
504 
505     // update state
506     balances[_from] = balances[_from].sub(_value);
507     balances[_hodler] = balances[_hodler].add(_value);
508 
509     // logs
510     Transfer(_from, _hodler, _value);
511 
512     return true;
513   }
514 }
515 
516 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
517 
518 /**
519  * @title Ownable
520  * @dev The Ownable contract has an owner address, and provides basic authorization control
521  * functions, this simplifies the implementation of "user permissions".
522  */
523 contract Ownable {
524   address public owner;
525 
526 
527   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
528 
529 
530   /**
531    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
532    * account.
533    */
534   function Ownable() public {
535     owner = msg.sender;
536   }
537 
538 
539   /**
540    * @dev Throws if called by any account other than the owner.
541    */
542   modifier onlyOwner() {
543     require(msg.sender == owner);
544     _;
545   }
546 
547 
548   /**
549    * @dev Allows the current owner to transfer control of the contract to a newOwner.
550    * @param newOwner The address to transfer ownership to.
551    */
552   function transferOwnership(address newOwner) public onlyOwner {
553     require(newOwner != address(0));
554     OwnershipTransferred(owner, newOwner);
555     owner = newOwner;
556   }
557 
558 }
559 
560 // File: zeppelin-solidity/contracts/token/SafeERC20.sol
561 
562 /**
563  * @title SafeERC20
564  * @dev Wrappers around ERC20 operations that throw on failure.
565  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
566  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
567  */
568 library SafeERC20 {
569   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
570     assert(token.transfer(to, value));
571   }
572 
573   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
574     assert(token.transferFrom(from, to, value));
575   }
576 
577   function safeApprove(ERC20 token, address spender, uint256 value) internal {
578     assert(token.approve(spender, value));
579   }
580 }
581 
582 // File: contracts/Hodler.sol
583 
584 contract Hodler is Ownable {
585   using SafeMath for uint256;
586   using SafeERC20 for Purpose;
587   using SafeERC20 for DUBI;
588 
589   Purpose public purpose;
590   DUBI public dubi;
591 
592   struct Item {
593     uint256 id;
594     address beneficiary;
595     uint256 value;
596     uint256 releaseTime;
597     bool fulfilled;
598   }
599 
600   mapping(address => mapping(uint256 => Item)) private items;
601 
602   function Hodler(address _purpose, address _dubi) public {
603     require(_purpose != address(0));
604 
605     purpose = Purpose(_purpose);
606     changeDubiAddress(_dubi);
607   }
608 
609   function changeDubiAddress(address _dubi) public onlyOwner {
610     require(_dubi != address(0));
611 
612     dubi = DUBI(_dubi);
613   }
614 
615   function hodl(uint256 _id, uint256 _value, uint256 _months) external {
616     require(_id > 0);
617     require(_value > 0);
618     // only 3 types are allowed
619     require(_months == 3 || _months == 6 || _months == 12);
620 
621     // user
622     address _user = msg.sender;
623 
624     // get dubi item
625     Item storage item = items[_user][_id];
626     // make sure dubi doesnt exist already
627     require(item.id != _id);
628 
629     // turn months to seconds
630     uint256 _seconds = _months.mul(2628000);
631     // get release time
632     uint256 _releaseTime = now.add(_seconds);
633     require(_releaseTime > now);
634 
635     // check if user has enough balance
636     uint256 balance = purpose.balanceOf(_user);
637     require(balance >= _value);
638 
639     // calculate percentage to mint for user: 3 months = 1% => _months / 3 = x
640     uint256 userPercentage = _months.div(3);
641     // get dubi amount: => (_value * userPercentage) / 100
642     uint256 userDubiAmount = _value.mul(userPercentage).div(100);
643 
644     // calculate percentage * 100 to mint for owner: 3 months = 0.05% => (_months * (0.05 * 100)) / 3 = x * 100
645     uint256 ownerPercentage100 = _months.mul(5).div(3);
646     // get dubi amount: => (_value * ownerPercentage100) / 100 * 100
647     uint256 ownerDubiAmount = _value.mul(ownerPercentage100).div(10000);
648 
649     // update state
650     items[_user][_id] = Item(_id, _user, _value, _releaseTime, false);
651 
652     // transfer tokens to hodler
653     assert(purpose.hodlerTransfer(_user, _value));
654 
655     // mint tokens for user and owner
656     assert(dubi.mint(_user, userDubiAmount));
657     assert(dubi.mint(owner, ownerDubiAmount));
658   }
659 
660   function release(uint256 _id) external {
661     require(_id > 0);
662 
663     // user
664     address _user = msg.sender;
665 
666     // get item
667     Item storage item = items[_user][_id];
668 
669     // check if it exists
670     require(item.id == _id);
671     // check if its not already fulfilled
672     require(!item.fulfilled);
673     // check time
674     require(now >= item.releaseTime);
675 
676     // check if there is enough tokens
677     uint256 balance = purpose.balanceOf(this);
678     require(balance >= item.value);
679 
680     // update state
681     item.fulfilled = true;
682 
683     // transfer tokens to beneficiary
684     purpose.safeTransfer(item.beneficiary, item.value);
685   }
686 
687   function getItem(address _user, uint256 _id) public view returns (uint256, address, uint256, uint256, bool) {
688     Item storage item = items[_user][_id];
689 
690     return (
691       item.id,
692       item.beneficiary,
693       item.value,
694       item.releaseTime,
695       item.fulfilled
696     );
697   }
698 }
699 
700 // File: contracts/HodlFor.sol
701 
702 contract HodlFor is Ownable {
703   using SafeERC20 for Purpose;
704   using SafeERC20 for DUBI;
705 
706   Purpose public purpose;
707   DUBI public dubi;
708   Hodler public hodler;
709 
710   struct Item {
711     uint256 id;
712     address creator;
713     address beneficiary;
714     bool fulfilled;
715   }
716 
717   mapping(address => mapping(uint256 => Item)) private items;
718 
719   function HodlFor(address _purpose, address _dubi, address _hodler) public {
720     require(_purpose != address(0));
721     require(_hodler != address(0));
722 
723     purpose = Purpose(_purpose);
724     changeDubiAddress(_dubi);
725     hodler = Hodler(_hodler);
726   }
727 
728   function changeDubiAddress(address _dubi) public onlyOwner {
729     require(_dubi != address(0));
730 
731     dubi = DUBI(_dubi);
732   }
733 
734   function hodl(address _beneficiary, uint256 _id, uint256 _value, uint256 _months) external {
735     require(_beneficiary != address(0));
736     require(_id > 0);
737 
738     address _creator = msg.sender;
739 
740     // get item
741     Item storage item = items[_creator][_id];
742     // make sure item doesnt exist
743     require(item.id != _id);
744 
745     // update state
746     items[_creator][_id] = Item(_id, _creator, _beneficiary, false);
747 
748     // get tokens from creator to this contract
749     purpose.safeTransferFrom(_creator, this, _value);
750     
751     // hodl tokens
752     hodler.hodl(_id, _value, _months);
753 
754     // send DUBI to beneficiary
755     uint256 balance = dubi.balanceOf(this);
756     dubi.safeTransfer(_beneficiary, balance);
757   }
758 
759   function release(address _creator, uint256 _id) external {
760     require(_creator != address(0));
761     require(_id > 0);
762 
763     address _beneficiary = msg.sender;
764 
765     // get item
766     Item storage item = items[_creator][_id];
767     // check if it exists
768     require(item.id == _id);
769     // check if its not already fulfilled
770     require(!item.fulfilled);
771     // check if beneficiary is same
772     require(item.beneficiary == _beneficiary);
773 
774     // update state
775     item.fulfilled = true;
776 
777     // release tokens to this contract
778     hodler.release(item.id);
779 
780     // transfer tokens from this contract to beneficiary
781     uint256 balance = purpose.balanceOf(this);
782     purpose.safeTransfer(_beneficiary, balance);
783   }
784 
785   function getItem(address _creator, uint256 _id) public view returns (uint256, address, address, bool) {
786     Item storage item = items[_creator][_id];
787 
788     return (
789       item.id,
790       item.creator,
791       item.beneficiary,
792       item.fulfilled
793     );
794   }
795 }