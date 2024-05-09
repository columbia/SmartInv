1 pragma solidity 0.4.18;
2 
3 
4 
5 
6 
7 /** 
8  * @title Ownable
9  * @dev The Ownable contract has an owner address, and provides basic authorization control
10  * functions, this simplifies the implementation of "user permissions".
11  */
12 contract Ownable {
13   address public owner;
14 
15 
16   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   function Ownable() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 
48 
49 /**
50  * @title SafeMath
51  * @dev Math operations with safety checks that throw on error
52  */
53 library SafeMath {
54 
55   /**
56   * @dev Multiplies two numbers, throws on overflow.
57   */
58   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59     if (a == 0) {
60       return 0;
61     }
62     uint256 c = a * b;
63     assert(c / a == b);
64     return c;
65   }
66 
67   /**
68   * @dev Integer division of two numbers, truncating the quotient.
69   */
70   function div(uint256 a, uint256 b) internal pure returns (uint256) {
71     // assert(b > 0); // Solidity automatically throws when dividing by 0
72     uint256 c = a / b;
73     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74     return c;
75   }
76 
77   /**
78   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
79   */
80   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81     assert(b <= a);
82     return a - b;
83   }
84 
85   /**
86   * @dev Adds two numbers, throws on overflow.
87   */
88   function add(uint256 a, uint256 b) internal pure returns (uint256) {
89     uint256 c = a + b;
90     assert(c >= a);
91     return c;
92   }
93 }
94 
95 
96 /**
97  * @title ERC20Basic
98  * @dev Simpler version of ERC20 interface
99  * @dev see https://github.com/ethereum/EIPs/issues/179
100  */
101 contract ERC20Basic {
102     uint256 public totalSupply;
103     function balanceOf(address who) public constant returns (uint256);
104     function transfer(address to, uint256 value) public returns (bool);
105     event Transfer(address indexed from, address indexed to, uint256 value);
106 }
107 
108 /**
109  * @title ERC20 interface
110  * @dev see https://github.com/ethereum/EIPs/issues/20
111  */
112 contract ERC20 is ERC20Basic {
113   function allowance(address owner, address spender) public view returns (uint256);
114   function transferFrom(address from, address to, uint256 value) public returns (bool);
115   function approve(address spender, uint256 value) public returns (bool);
116   event Approval(address indexed owner, address indexed spender, uint256 value);
117 }
118 
119 
120 /**
121  * @title SafeERC20
122  * @dev Wrappers around ERC20 operations that throw on failure.
123  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
124  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.  athaine
125  */
126 library SafeERC20 {
127   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
128     assert(token.transfer(to, value));
129   }
130 
131   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
132     assert(token.transferFrom(from, to, value));
133   }
134 
135   function safeApprove(ERC20 token, address spender, uint256 value) internal {
136     assert(token.approve(spender, value));
137   }
138 }
139 
140 
141 
142 // File: zeppelin-solidity/contracts/ownership/rbac/Roles.sol
143 
144 /**
145  * @title Roles
146  * @author Francisco Giordano (@frangio)
147  * @dev Library for managing addresses assigned to a Role.
148  *      See RBAC.sol for example usage.
149  */
150 library Roles {
151     struct Role {
152         mapping (address => bool) bearer;
153     }
154 
155     /**
156      * @dev give an address access to this role
157      */
158     function add(Role storage role, address addr)
159         internal
160     {
161         role.bearer[addr] = true;
162     }
163 
164     /**
165      * @dev remove an address' access to this role
166      */
167     function remove(Role storage role, address addr)
168         internal
169     {
170         role.bearer[addr] = false;
171     }
172 
173     /**
174      * @dev check if an address has this role
175      * // reverts
176      */
177     function check(Role storage role, address addr)
178         view
179         internal
180     {
181         require(has(role, addr));
182     }
183 
184     /**
185      * @dev check if an address has this role
186      * @return bool
187      */
188     function has(Role storage role, address addr)
189         view
190         internal
191         returns (bool)
192     {
193         return role.bearer[addr];
194     }
195 }
196 
197 // File: zeppelin-solidity/contracts/ownership/rbac/RBAC.sol
198 
199 /**
200  * @title RBAC (Role-Based Access Control)
201  * @author Matt Condon (@Shrugs)
202  * @dev Stores and provides setters and getters for roles and addresses.
203  *      Supports unlimited numbers of roles and addresses.
204  *      See //contracts/examples/RBACExample.sol for an example of usage.
205  * This RBAC method uses strings to key roles. It may be beneficial
206  *  for you to write your own implementation of this interface using Enums or similar.
207  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
208  *  to avoid typos.
209  */
210 contract RBAC {
211     using Roles for Roles.Role;
212 
213     mapping (string => Roles.Role) private roles;
214 
215     event RoleAdded(address addr, string roleName);
216     event RoleRemoved(address addr, string roleName);
217 
218     /**
219      * A constant role name for indicating admins.
220      */
221     string public constant ROLE_ADMIN = "admin";
222 
223     /**
224      * @dev constructor. Sets msg.sender as admin by default
225      */
226     function RBAC()
227         public
228     {
229         addRole(msg.sender, ROLE_ADMIN);
230     }
231 
232     /**
233      * @dev add a role to an address
234      * @param addr address
235      * @param roleName the name of the role
236      */
237     function addRole(address addr, string roleName)
238         internal
239     {
240         roles[roleName].add(addr);
241         RoleAdded(addr, roleName);
242     }
243 
244     /**
245      * @dev remove a role from an address
246      * @param addr address
247      * @param roleName the name of the role
248      */
249     function removeRole(address addr, string roleName)
250         internal
251     {
252         roles[roleName].remove(addr);
253         RoleRemoved(addr, roleName);
254     }
255 
256     /**
257      * @dev reverts if addr does not have role
258      * @param addr address
259      * @param roleName the name of the role
260      * // reverts
261      */
262     function checkRole(address addr, string roleName)
263         view
264         public
265     {
266         roles[roleName].check(addr);
267     }
268 
269     /**
270      * @dev determine if addr has role
271      * @param addr address
272      * @param roleName the name of the role
273      * @return bool
274      */
275     function hasRole(address addr, string roleName)
276         view
277         public
278         returns (bool)
279     {
280         return roles[roleName].has(addr);
281     }
282 
283     /**
284      * @dev add a role to an address
285      * @param addr address
286      * @param roleName the name of the role
287      */
288     function adminAddRole(address addr, string roleName)
289         onlyAdmin
290         public
291     {
292         addRole(addr, roleName);
293     }
294 
295     /**
296      * @dev remove a role from an address
297      * @param addr address
298      * @param roleName the name of the role
299      */
300     function adminRemoveRole(address addr, string roleName)
301         onlyAdmin
302         public
303     {
304         removeRole(addr, roleName);
305     }
306 
307 
308     /**
309      * @dev modifier to scope access to a single role (uses msg.sender as addr)
310      * @param roleName the name of the role
311      * // reverts
312      */
313     modifier onlyRole(string roleName)
314     {
315         checkRole(msg.sender, roleName);
316         _;
317     }
318 
319     /**
320      * @dev modifier to scope access to admins
321      * // reverts
322      */
323     modifier onlyAdmin()
324     {
325         checkRole(msg.sender, ROLE_ADMIN);
326         _;
327     }
328 
329     /**
330      * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
331      * @param roleNames the names of the roles to scope access to
332      * // reverts
333      *
334      * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
335      *  see: https://github.com/ethereum/solidity/issues/2467
336      */
337     // modifier onlyRoles(string[] roleNames) {
338     //     bool hasAnyRole = false;
339     //     for (uint8 i = 0; i < roleNames.length; i++) {
340     //         if (hasRole(msg.sender, roleNames[i])) {
341     //             hasAnyRole = true;
342     //             break;
343     //         }
344     //     }
345 
346     //     require(hasAnyRole);
347 
348     //     _;
349     // }
350 }
351 
352 // File: zeppelin-solidity/contracts/math/SafeMath.sol
353 
354 /**
355  * @title SafeMath
356  * @dev Math operations with safety checks that throw on error
357  */
358 
359 
360 
361 // File: zeppelin-solidity/contracts/token/BasicToken.sol
362 
363 /**
364  * @title Basic token
365  * @dev Basic version of StandardToken, with no allowances.
366  */
367 contract BasicToken is ERC20Basic {
368   using SafeMath for uint256;
369 
370   mapping(address => uint256) balances;
371 
372   /**
373   * @dev transfer token for a specified address
374   * @param _to The address to transfer to.
375   * @param _value The amount to be transferred.
376   */
377   function transfer(address _to, uint256 _value) public returns (bool) {
378     require(_to != address(0));
379     require(_value <= balances[msg.sender]);
380 
381     // SafeMath.sub will throw if there is not enough balance.
382     balances[msg.sender] = balances[msg.sender].sub(_value);
383     balances[_to] = balances[_to].add(_value);
384     Transfer(msg.sender, _to, _value);
385     return true;
386   }
387 
388   /**
389   * @dev Gets the balance of the specified address.
390   * @param _owner The address to query the the balance of.
391   * @return An uint256 representing the amount owned by the passed address.
392   */
393   function balanceOf(address _owner) public view returns (uint256 balance) {
394     return balances[_owner];
395   }
396 
397 }
398 
399 // File: zeppelin-solidity/contracts/token/BurnableToken.sol
400 
401 /**
402  * @title Burnable Token
403  * @dev Token that can be irreversibly burned (destroyed).
404  */
405 contract BurnableToken is BasicToken {
406 
407     event Burn(address indexed burner, uint256 value);
408 
409     /**
410      * @dev Burns a specific amount of tokens.
411      * @param _value The amount of token to be burned.
412      */
413     function burn(uint256 _value) public {
414         require(_value <= balances[msg.sender]);
415         // no need to require value <= totalSupply, since that would imply the
416         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
417 
418         address burner = msg.sender;
419         balances[burner] = balances[burner].sub(_value);
420         totalSupply = totalSupply.sub(_value);
421         Burn(burner, _value);
422     }
423 }
424 
425 
426 // File: zeppelin-solidity/contracts/token/StandardToken.sol
427 
428 /**
429  * @title Standard ERC20 token
430  *
431  * @dev Implementation of the basic standard token.
432  * @dev https://github.com/ethereum/EIPs/issues/20
433  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
434  */
435 contract StandardToken is ERC20, BasicToken {
436 
437   mapping (address => mapping (address => uint256)) internal allowed;
438 
439 
440   /**
441    * @dev Transfer tokens from one address to another
442    * @param _from address The address which you want to send tokens from
443    * @param _to address The address which you want to transfer to
444    * @param _value uint256 the amount of tokens to be transferred
445    */
446   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
447     require(_to != address(0));
448     require(_value <= balances[_from]);
449     require(_value <= allowed[_from][msg.sender]);
450 
451     balances[_from] = balances[_from].sub(_value);
452     balances[_to] = balances[_to].add(_value);
453     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
454     Transfer(_from, _to, _value);
455     return true;
456   }
457 
458   /**
459    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
460    *
461    * Beware that changing an allowance with this method brings the risk that someone may use both the old
462    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
463    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
464    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
465    * @param _spender The address which will spend the funds.
466    * @param _value The amount of tokens to be spent.
467    */
468   function approve(address _spender, uint256 _value) public returns (bool) {
469     allowed[msg.sender][_spender] = _value;
470     Approval(msg.sender, _spender, _value);
471     return true;
472   }
473 
474   /**
475    * @dev Function to check the amount of tokens that an owner allowed to a spender.
476    * @param _owner address The address which owns the funds.
477    * @param _spender address The address which will spend the funds.
478    * @return A uint256 specifying the amount of tokens still available for the spender.
479    */
480   function allowance(address _owner, address _spender) public view returns (uint256) {
481     return allowed[_owner][_spender];
482   }
483 
484   /**
485    * @dev Increase the amount of tokens that an owner allowed to a spender.
486    *
487    * approve should be called when allowed[_spender] == 0. To increment
488    * allowed value is better to use this function to avoid 2 calls (and wait until
489    * the first transaction is mined)
490    * From MonolithDAO Token.sol
491    * @param _spender The address which will spend the funds.
492    * @param _addedValue The amount of tokens to increase the allowance by.
493    */
494   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
495     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
496     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
497     return true;
498   }
499 
500   /**
501    * @dev Decrease the amount of tokens that an owner allowed to a spender.
502    *
503    * approve should be called when allowed[_spender] == 0. To decrement
504    * allowed value is better to use this function to avoid 2 calls (and wait until
505    * the first transaction is mined)
506    * From MonolithDAO Token.sol
507    * @param _spender The address which will spend the funds.
508    * @param _subtractedValue The amount of tokens to decrease the allowance by.
509    */
510   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
511     uint oldValue = allowed[msg.sender][_spender];
512     if (_subtractedValue > oldValue) {
513       allowed[msg.sender][_spender] = 0;
514     } else {
515       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
516     }
517     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
518     return true;
519   }
520 
521 }
522 
523 // File: contracts/DUBI.sol
524 
525 contract DUBI is StandardToken, BurnableToken, RBAC {
526   string public constant name = "Decentralized Universal Basic Income";
527   string public constant symbol = "DUBI";
528   uint8 public constant decimals = 18;
529   string constant public ROLE_MINT = "mint";
530 
531   event MintLog(address indexed to, uint256 amount);
532 
533   function DUBI() public {
534     totalSupply = 0;
535   }
536 
537   // used by contracts to mint DUBI tokens
538   function mint(address _to, uint256 _amount) external onlyRole(ROLE_MINT) returns (bool) {
539     require(_to != address(0));
540     require(_amount > 0);
541 
542     // update state
543     totalSupply = totalSupply.add(_amount);
544     balances[_to] = balances[_to].add(_amount);
545 
546     // logs
547     MintLog(_to, _amount);
548     Transfer(0x0, _to, _amount);
549     
550     return true;
551   }
552 }
553 
554 
555 
556 
557 // File: zeppelin-solidity/contracts/token/MintableToken.sol
558 
559 /**
560  * @title Mintable token
561  * @dev Simple ERC20 Token example, with mintable token creation
562  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
563  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
564  */
565 
566 contract MintableToken is StandardToken, Ownable {
567   event Mint(address indexed to, uint256 amount);
568   event MintFinished();
569 
570   bool public mintingFinished = false;
571 
572 
573   modifier canMint() {
574     require(!mintingFinished);
575     _;
576   }
577 
578   /**
579    * @dev Function to mint tokens
580    * @param _to The address that will receive the minted tokens.
581    * @param _amount The amount of tokens to mint.
582    * @return A boolean that indicates if the operation was successful.
583    */
584   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
585     totalSupply = totalSupply.add(_amount);
586     balances[_to] = balances[_to].add(_amount);
587     Mint(_to, _amount);
588     Transfer(address(0), _to, _amount);
589     return true;
590   }
591 
592   /**
593    * @dev Function to stop minting new tokens.
594    * @return True if the operation was successful.
595    */
596   function finishMinting() onlyOwner canMint public returns (bool) {
597     mintingFinished = true;
598     MintFinished();
599     return true;
600   }
601 }
602 
603 // File: contracts/Purpose.sol
604 
605 contract Purpose is StandardToken, BurnableToken, MintableToken, RBAC {
606   string public constant name = "Purpose";
607   string public constant symbol = "PRPS";
608   uint8 public constant decimals = 18;
609   string constant public ROLE_TRANSFER = "transfer";
610 
611   function Purpose() public {
612     totalSupply = 0;
613   }
614 
615   // used by hodler contract to transfer users tokens to it
616   function hodlerTransfer(address _from, uint256 _value) external onlyRole(ROLE_TRANSFER) returns (bool) {
617     require(_from != address(0));
618     require(_value > 0);
619 
620     // hodler
621     address _hodler = msg.sender;
622 
623     // update state
624     balances[_from] = balances[_from].sub(_value);
625     balances[_hodler] = balances[_hodler].add(_value);
626 
627     // logs
628     Transfer(_from, _hodler, _value);
629 
630     return true;
631   }
632 }
633 
634 
635 
636 contract Hodler is Ownable {
637   using SafeMath for uint256;
638   using SafeERC20 for Purpose;
639   using SafeERC20 for DUBI;
640 
641   Purpose public purpose;
642   DUBI public dubi;
643 
644   struct Item {
645     uint256 id;
646     address beneficiary;
647     uint256 value;
648     uint256 releaseTime;
649     bool fulfilled;
650   }
651 
652   mapping(address => mapping(uint256 => Item)) private items;
653 
654   function Hodler(address _purpose, address _dubi) public {
655     require(_purpose != address(0));
656 
657     purpose = Purpose(_purpose);
658     changeDubiAddress(_dubi);
659   }
660 
661   function changeDubiAddress(address _dubi) public onlyOwner {
662     require(_dubi != address(0));
663 
664     dubi = DUBI(_dubi);
665   }
666 
667   function hodl(uint256 _id, uint256 _value, uint256 _months) external {
668     require(_id > 0);
669     require(_value > 0);
670     // only 3 types are allowed
671     require(_months == 3 || _months == 6 || _months == 12);
672 
673     // user
674     address _user = msg.sender;
675 
676     // get dubi item
677     Item storage item = items[_user][_id];
678     // make sure dubi doesnt exist already
679     require(item.id != _id);
680 
681     // turn months to seconds
682     uint256 _seconds = _months.mul(2628000);
683     // get release time
684     uint256 _releaseTime = now.add(_seconds);
685     require(_releaseTime > now);
686 
687     // check if user has enough balance
688     uint256 balance = purpose.balanceOf(_user);
689     require(balance >= _value);
690 
691     // calculate percentage to mint for user: 3 months = 1% => _months / 3 = x
692     uint256 userPercentage = _months.div(3);
693     // get dubi amount: => (_value * userPercentage) / 100
694     uint256 userDubiAmount = _value.mul(userPercentage).div(100);
695 
696     // update state
697     items[_user][_id] = Item(_id, _user, _value, _releaseTime, false);
698 
699     // transfer tokens to hodler
700     assert(purpose.hodlerTransfer(_user, _value));
701 
702     // mint tokens for user
703     assert(dubi.mint(_user, userDubiAmount));
704   }
705 
706   function release(uint256 _id) external {
707     require(_id > 0);
708 
709     // user
710     address _user = msg.sender;
711 
712     // get item
713     Item storage item = items[_user][_id];
714 
715     // check if it exists
716     require(item.id == _id);
717     // check if its not already fulfilled
718     require(!item.fulfilled);
719     // check time
720     require(now >= item.releaseTime);
721 
722     // check if there is enough tokens
723     uint256 balance = purpose.balanceOf(this);
724     require(balance >= item.value);
725 
726     // update state
727     item.fulfilled = true;
728 
729     // transfer tokens to beneficiary
730     purpose.safeTransfer(item.beneficiary, item.value);
731   }
732 
733   function getItem(address _user, uint256 _id) public view returns (uint256, address, uint256, uint256, bool) {
734     Item storage item = items[_user][_id];
735 
736     return (
737       item.id,
738       item.beneficiary,
739       item.value,
740       item.releaseTime,
741       item.fulfilled
742     );
743   }
744 }