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
28   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
29     if (a == 0) {
30       return 0;
31     }
32     c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   /**
38   * @dev Integer division of two numbers, truncating the quotient.
39   */
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     // uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return a / b;
45   }
46 
47   /**
48   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   /**
56   * @dev Adds two numbers, throws on overflow.
57   */
58   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
59     c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   uint256 totalSupply_;
77 
78   /**
79   * @dev total number of tokens in existence
80   */
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[msg.sender]);
93 
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     emit Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100   /**
101   * @dev Gets the balance of the specified address.
102   * @param _owner The address to query the the balance of.
103   * @return An uint256 representing the amount owned by the passed address.
104   */
105   function balanceOf(address _owner) public view returns (uint256) {
106     return balances[_owner];
107   }
108 
109 }
110 
111 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
112 
113 /**
114  * @title ERC20 interface
115  * @dev see https://github.com/ethereum/EIPs/issues/20
116  */
117 contract ERC20 is ERC20Basic {
118   function allowance(address owner, address spender)
119     public view returns (uint256);
120 
121   function transferFrom(address from, address to, uint256 value)
122     public returns (bool);
123 
124   function approve(address spender, uint256 value) public returns (bool);
125   event Approval(
126     address indexed owner,
127     address indexed spender,
128     uint256 value
129   );
130 }
131 
132 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
133 
134 /**
135  * @title Standard ERC20 token
136  *
137  * @dev Implementation of the basic standard token.
138  * @dev https://github.com/ethereum/EIPs/issues/20
139  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
140  */
141 contract StandardToken is ERC20, BasicToken {
142 
143   mapping (address => mapping (address => uint256)) internal allowed;
144 
145 
146   /**
147    * @dev Transfer tokens from one address to another
148    * @param _from address The address which you want to send tokens from
149    * @param _to address The address which you want to transfer to
150    * @param _value uint256 the amount of tokens to be transferred
151    */
152   function transferFrom(
153     address _from,
154     address _to,
155     uint256 _value
156   )
157     public
158     returns (bool)
159   {
160     require(_to != address(0));
161     require(_value <= balances[_from]);
162     require(_value <= allowed[_from][msg.sender]);
163 
164     balances[_from] = balances[_from].sub(_value);
165     balances[_to] = balances[_to].add(_value);
166     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
167     emit Transfer(_from, _to, _value);
168     return true;
169   }
170 
171   /**
172    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
173    *
174    * Beware that changing an allowance with this method brings the risk that someone may use both the old
175    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
176    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
177    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
178    * @param _spender The address which will spend the funds.
179    * @param _value The amount of tokens to be spent.
180    */
181   function approve(address _spender, uint256 _value) public returns (bool) {
182     allowed[msg.sender][_spender] = _value;
183     emit Approval(msg.sender, _spender, _value);
184     return true;
185   }
186 
187   /**
188    * @dev Function to check the amount of tokens that an owner allowed to a spender.
189    * @param _owner address The address which owns the funds.
190    * @param _spender address The address which will spend the funds.
191    * @return A uint256 specifying the amount of tokens still available for the spender.
192    */
193   function allowance(
194     address _owner,
195     address _spender
196    )
197     public
198     view
199     returns (uint256)
200   {
201     return allowed[_owner][_spender];
202   }
203 
204   /**
205    * @dev Increase the amount of tokens that an owner allowed to a spender.
206    *
207    * approve should be called when allowed[_spender] == 0. To increment
208    * allowed value is better to use this function to avoid 2 calls (and wait until
209    * the first transaction is mined)
210    * From MonolithDAO Token.sol
211    * @param _spender The address which will spend the funds.
212    * @param _addedValue The amount of tokens to increase the allowance by.
213    */
214   function increaseApproval(
215     address _spender,
216     uint _addedValue
217   )
218     public
219     returns (bool)
220   {
221     allowed[msg.sender][_spender] = (
222       allowed[msg.sender][_spender].add(_addedValue));
223     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
224     return true;
225   }
226 
227   /**
228    * @dev Decrease the amount of tokens that an owner allowed to a spender.
229    *
230    * approve should be called when allowed[_spender] == 0. To decrement
231    * allowed value is better to use this function to avoid 2 calls (and wait until
232    * the first transaction is mined)
233    * From MonolithDAO Token.sol
234    * @param _spender The address which will spend the funds.
235    * @param _subtractedValue The amount of tokens to decrease the allowance by.
236    */
237   function decreaseApproval(
238     address _spender,
239     uint _subtractedValue
240   )
241     public
242     returns (bool)
243   {
244     uint oldValue = allowed[msg.sender][_spender];
245     if (_subtractedValue > oldValue) {
246       allowed[msg.sender][_spender] = 0;
247     } else {
248       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
249     }
250     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251     return true;
252   }
253 
254 }
255 
256 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
257 
258 /**
259  * @title Ownable
260  * @dev The Ownable contract has an owner address, and provides basic authorization control
261  * functions, this simplifies the implementation of "user permissions".
262  */
263 contract Ownable {
264   address public owner;
265 
266 
267   event OwnershipRenounced(address indexed previousOwner);
268   event OwnershipTransferred(
269     address indexed previousOwner,
270     address indexed newOwner
271   );
272 
273 
274   /**
275    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
276    * account.
277    */
278   constructor() public {
279     owner = msg.sender;
280   }
281 
282   /**
283    * @dev Throws if called by any account other than the owner.
284    */
285   modifier onlyOwner() {
286     require(msg.sender == owner);
287     _;
288   }
289 
290   /**
291    * @dev Allows the current owner to transfer control of the contract to a newOwner.
292    * @param newOwner The address to transfer ownership to.
293    */
294   function transferOwnership(address newOwner) public onlyOwner {
295     require(newOwner != address(0));
296     emit OwnershipTransferred(owner, newOwner);
297     owner = newOwner;
298   }
299 
300   /**
301    * @dev Allows the current owner to relinquish control of the contract.
302    */
303   function renounceOwnership() public onlyOwner {
304     emit OwnershipRenounced(owner);
305     owner = address(0);
306   }
307 }
308 
309 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
310 
311 /**
312  * @title Mintable token
313  * @dev Simple ERC20 Token example, with mintable token creation
314  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
315  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
316  */
317 contract MintableToken is StandardToken, Ownable {
318   event Mint(address indexed to, uint256 amount);
319   event MintFinished();
320 
321   bool public mintingFinished = false;
322 
323 
324   modifier canMint() {
325     require(!mintingFinished);
326     _;
327   }
328 
329   modifier hasMintPermission() {
330     require(msg.sender == owner);
331     _;
332   }
333 
334   /**
335    * @dev Function to mint tokens
336    * @param _to The address that will receive the minted tokens.
337    * @param _amount The amount of tokens to mint.
338    * @return A boolean that indicates if the operation was successful.
339    */
340   function mint(
341     address _to,
342     uint256 _amount
343   )
344     hasMintPermission
345     canMint
346     public
347     returns (bool)
348   {
349     totalSupply_ = totalSupply_.add(_amount);
350     balances[_to] = balances[_to].add(_amount);
351     emit Mint(_to, _amount);
352     emit Transfer(address(0), _to, _amount);
353     return true;
354   }
355 
356   /**
357    * @dev Function to stop minting new tokens.
358    * @return True if the operation was successful.
359    */
360   function finishMinting() onlyOwner canMint public returns (bool) {
361     mintingFinished = true;
362     emit MintFinished();
363     return true;
364   }
365 }
366 
367 // File: openzeppelin-solidity/contracts/ownership/rbac/Roles.sol
368 
369 /**
370  * @title Roles
371  * @author Francisco Giordano (@frangio)
372  * @dev Library for managing addresses assigned to a Role.
373  *      See RBAC.sol for example usage.
374  */
375 library Roles {
376   struct Role {
377     mapping (address => bool) bearer;
378   }
379 
380   /**
381    * @dev give an address access to this role
382    */
383   function add(Role storage role, address addr)
384     internal
385   {
386     role.bearer[addr] = true;
387   }
388 
389   /**
390    * @dev remove an address' access to this role
391    */
392   function remove(Role storage role, address addr)
393     internal
394   {
395     role.bearer[addr] = false;
396   }
397 
398   /**
399    * @dev check if an address has this role
400    * // reverts
401    */
402   function check(Role storage role, address addr)
403     view
404     internal
405   {
406     require(has(role, addr));
407   }
408 
409   /**
410    * @dev check if an address has this role
411    * @return bool
412    */
413   function has(Role storage role, address addr)
414     view
415     internal
416     returns (bool)
417   {
418     return role.bearer[addr];
419   }
420 }
421 
422 // File: openzeppelin-solidity/contracts/ownership/rbac/RBAC.sol
423 
424 /**
425  * @title RBAC (Role-Based Access Control)
426  * @author Matt Condon (@Shrugs)
427  * @dev Stores and provides setters and getters for roles and addresses.
428  * @dev Supports unlimited numbers of roles and addresses.
429  * @dev See //contracts/mocks/RBACMock.sol for an example of usage.
430  * This RBAC method uses strings to key roles. It may be beneficial
431  *  for you to write your own implementation of this interface using Enums or similar.
432  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
433  *  to avoid typos.
434  */
435 contract RBAC {
436   using Roles for Roles.Role;
437 
438   mapping (string => Roles.Role) private roles;
439 
440   event RoleAdded(address addr, string roleName);
441   event RoleRemoved(address addr, string roleName);
442 
443   /**
444    * @dev reverts if addr does not have role
445    * @param addr address
446    * @param roleName the name of the role
447    * // reverts
448    */
449   function checkRole(address addr, string roleName)
450     view
451     public
452   {
453     roles[roleName].check(addr);
454   }
455 
456   /**
457    * @dev determine if addr has role
458    * @param addr address
459    * @param roleName the name of the role
460    * @return bool
461    */
462   function hasRole(address addr, string roleName)
463     view
464     public
465     returns (bool)
466   {
467     return roles[roleName].has(addr);
468   }
469 
470   /**
471    * @dev add a role to an address
472    * @param addr address
473    * @param roleName the name of the role
474    */
475   function addRole(address addr, string roleName)
476     internal
477   {
478     roles[roleName].add(addr);
479     emit RoleAdded(addr, roleName);
480   }
481 
482   /**
483    * @dev remove a role from an address
484    * @param addr address
485    * @param roleName the name of the role
486    */
487   function removeRole(address addr, string roleName)
488     internal
489   {
490     roles[roleName].remove(addr);
491     emit RoleRemoved(addr, roleName);
492   }
493 
494   /**
495    * @dev modifier to scope access to a single role (uses msg.sender as addr)
496    * @param roleName the name of the role
497    * // reverts
498    */
499   modifier onlyRole(string roleName)
500   {
501     checkRole(msg.sender, roleName);
502     _;
503   }
504 
505   /**
506    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
507    * @param roleNames the names of the roles to scope access to
508    * // reverts
509    *
510    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
511    *  see: https://github.com/ethereum/solidity/issues/2467
512    */
513   // modifier onlyRoles(string[] roleNames) {
514   //     bool hasAnyRole = false;
515   //     for (uint8 i = 0; i < roleNames.length; i++) {
516   //         if (hasRole(msg.sender, roleNames[i])) {
517   //             hasAnyRole = true;
518   //             break;
519   //         }
520   //     }
521 
522   //     require(hasAnyRole);
523 
524   //     _;
525   // }
526 }
527 
528 // File: contracts/RBACMintableToken.sol
529 
530 // This contract is adapted from RBACMintableToken by OpenZeppelin
531 pragma solidity ^0.4.19;
532 
533 
534 
535 
536 /**
537  * @title RBACMintableToken
538  * @author Vittorio Minacori (@vittominacori)
539  * @dev Mintable Token, with RBAC minter permissions
540  */
541 contract RBACMintableToken is MintableToken, RBAC {
542     /**
543      * A constant role name for indicating minters.
544      */
545     string public constant ROLE_MINTER = "minter";
546     address[] internal minters;
547 
548     /**
549      * @dev override the Mintable token modifier to add role based logic
550      */
551     modifier hasMintPermission() {
552         checkRole(msg.sender, ROLE_MINTER);
553         _;
554     }
555 
556     /**
557      * @dev add a minter role to an address
558      * @param minter address
559      */
560     function addMinter(address minter) onlyOwner public {
561         if (!hasRole(minter, ROLE_MINTER))
562             minters.push(minter);
563         addRole(minter, ROLE_MINTER);
564     }
565 
566     /**
567      * @dev remove a minter role from an address
568      * @param minter address
569      */
570     function removeMinter(address minter) onlyOwner public {
571         removeRole(minter, ROLE_MINTER);
572         removeMinterByValue(minter);
573     }
574 
575     function getNumberOfMinters() onlyOwner public view returns (uint) {
576         return minters.length;
577     }
578 
579     function getMinter(uint _index) onlyOwner public view returns (address) {
580         require(_index < minters.length);
581         return minters[_index];
582     }
583 
584     function removeMinterByIndex(uint index) internal {
585         require(minters.length > 0);
586         if (minters.length > 1) {
587             minters[index] = minters[minters.length - 1];
588             // recover gas
589             delete (minters[minters.length - 1]);
590         }
591         minters.length--;
592     }
593 
594     function removeMinterByValue(address _client) internal {
595         for (uint i = 0; i < minters.length; i++) {
596             if (minters[i] == _client) {
597                 removeMinterByIndex(i);
598                 break;
599             }
600         }
601     }
602 }
603 
604 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
605 
606 /**
607  * @title Burnable Token
608  * @dev Token that can be irreversibly burned (destroyed).
609  */
610 contract BurnableToken is BasicToken {
611 
612   event Burn(address indexed burner, uint256 value);
613 
614   /**
615    * @dev Burns a specific amount of tokens.
616    * @param _value The amount of token to be burned.
617    */
618   function burn(uint256 _value) public {
619     _burn(msg.sender, _value);
620   }
621 
622   function _burn(address _who, uint256 _value) internal {
623     require(_value <= balances[_who]);
624     // no need to require value <= totalSupply, since that would imply the
625     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
626 
627     balances[_who] = balances[_who].sub(_value);
628     totalSupply_ = totalSupply_.sub(_value);
629     emit Burn(_who, _value);
630     emit Transfer(_who, address(0), _value);
631   }
632 }
633 
634 // File: contracts/CappedToken.sol
635 
636 // This contract is adapted from CappedToken by OpenZeppelin
637 pragma solidity ^0.4.19;
638 
639 
640 
641 /**
642  * @title Capped token
643  * @dev Mintable token with a token cap.
644  */
645 contract CappedToken is MintableToken {
646 
647     uint256 public cap;
648 
649     constructor(uint256 _cap) public {
650         require(_cap > 0);
651         cap = _cap;
652     }
653 
654     /**
655      * @dev Function to mint tokens
656      * @param _to The address that will receive the minted tokens.
657      * @param _amount The amount of tokens to mint.
658      * @return A boolean that indicates if the operation was successful.
659      */
660     function mint(
661         address _to,
662         uint256 _amount
663     )
664     hasMintPermission
665     canMint
666     public
667     returns (bool)
668     {
669         require(totalSupply_.add(_amount) <= cap);
670 
671         return super.mint(_to, _amount);
672     }
673 
674 }
675 
676 // File: contracts/DeviseToken.sol
677 
678 contract DeviseToken is CappedToken, BurnableToken, RBACMintableToken {
679     string public name = "DEVISE";
680     string public symbol = "DVZ";
681     // The pricision is set to micro DVZ
682     uint8 public decimals = 6;
683 
684     function DeviseToken(uint256 _cap) public
685     CappedToken(_cap) {
686         addMinter(owner);
687     }
688 
689     /**
690      * @dev Allows the current owner to transfer control of the contract to a newOwner.
691      * @param newOwner The address to transfer ownership to.
692      */
693     function transferOwnership(address newOwner) public onlyOwner {
694         removeMinter(owner);
695         addMinter(newOwner);
696         super.transferOwnership(newOwner);
697     }
698 }