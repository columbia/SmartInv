1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
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
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    */
40   function renounceOwnership() public onlyOwner {
41     emit OwnershipRenounced(owner);
42     owner = address(0);
43   }
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param _newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address _newOwner) public onlyOwner {
50     _transferOwnership(_newOwner);
51   }
52 
53   /**
54    * @dev Transfers control of the contract to a newOwner.
55    * @param _newOwner The address to transfer ownership to.
56    */
57   function _transferOwnership(address _newOwner) internal {
58     require(_newOwner != address(0));
59     emit OwnershipTransferred(owner, _newOwner);
60     owner = _newOwner;
61   }
62 }
63 
64 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
65 
66 /**
67  * @title Pausable
68  * @dev Base contract which allows children to implement an emergency stop mechanism.
69  */
70 contract Pausable is Ownable {
71   event Pause();
72   event Unpause();
73 
74   bool public paused = false;
75 
76 
77   /**
78    * @dev Modifier to make a function callable only when the contract is not paused.
79    */
80   modifier whenNotPaused() {
81     require(!paused);
82     _;
83   }
84 
85   /**
86    * @dev Modifier to make a function callable only when the contract is paused.
87    */
88   modifier whenPaused() {
89     require(paused);
90     _;
91   }
92 
93   /**
94    * @dev called by the owner to pause, triggers stopped state
95    */
96   function pause() onlyOwner whenNotPaused public {
97     paused = true;
98     emit Pause();
99   }
100 
101   /**
102    * @dev called by the owner to unpause, returns to normal state
103    */
104   function unpause() onlyOwner whenPaused public {
105     paused = false;
106     emit Unpause();
107   }
108 }
109 
110 // File: openzeppelin-solidity/contracts/ownership/rbac/Roles.sol
111 
112 /**
113  * @title Roles
114  * @author Francisco Giordano (@frangio)
115  * @dev Library for managing addresses assigned to a Role.
116  *      See RBAC.sol for example usage.
117  */
118 library Roles {
119   struct Role {
120     mapping (address => bool) bearer;
121   }
122 
123   /**
124    * @dev give an address access to this role
125    */
126   function add(Role storage role, address addr)
127     internal
128   {
129     role.bearer[addr] = true;
130   }
131 
132   /**
133    * @dev remove an address' access to this role
134    */
135   function remove(Role storage role, address addr)
136     internal
137   {
138     role.bearer[addr] = false;
139   }
140 
141   /**
142    * @dev check if an address has this role
143    * // reverts
144    */
145   function check(Role storage role, address addr)
146     view
147     internal
148   {
149     require(has(role, addr));
150   }
151 
152   /**
153    * @dev check if an address has this role
154    * @return bool
155    */
156   function has(Role storage role, address addr)
157     view
158     internal
159     returns (bool)
160   {
161     return role.bearer[addr];
162   }
163 }
164 
165 // File: openzeppelin-solidity/contracts/ownership/rbac/RBAC.sol
166 
167 /**
168  * @title RBAC (Role-Based Access Control)
169  * @author Matt Condon (@Shrugs)
170  * @dev Stores and provides setters and getters for roles and addresses.
171  * @dev Supports unlimited numbers of roles and addresses.
172  * @dev See //contracts/mocks/RBACMock.sol for an example of usage.
173  * This RBAC method uses strings to key roles. It may be beneficial
174  *  for you to write your own implementation of this interface using Enums or similar.
175  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
176  *  to avoid typos.
177  */
178 contract RBAC {
179   using Roles for Roles.Role;
180 
181   mapping (string => Roles.Role) private roles;
182 
183   event RoleAdded(address addr, string roleName);
184   event RoleRemoved(address addr, string roleName);
185 
186   /**
187    * @dev reverts if addr does not have role
188    * @param addr address
189    * @param roleName the name of the role
190    * // reverts
191    */
192   function checkRole(address addr, string roleName)
193     view
194     public
195   {
196     roles[roleName].check(addr);
197   }
198 
199   /**
200    * @dev determine if addr has role
201    * @param addr address
202    * @param roleName the name of the role
203    * @return bool
204    */
205   function hasRole(address addr, string roleName)
206     view
207     public
208     returns (bool)
209   {
210     return roles[roleName].has(addr);
211   }
212 
213   /**
214    * @dev add a role to an address
215    * @param addr address
216    * @param roleName the name of the role
217    */
218   function addRole(address addr, string roleName)
219     internal
220   {
221     roles[roleName].add(addr);
222     emit RoleAdded(addr, roleName);
223   }
224 
225   /**
226    * @dev remove a role from an address
227    * @param addr address
228    * @param roleName the name of the role
229    */
230   function removeRole(address addr, string roleName)
231     internal
232   {
233     roles[roleName].remove(addr);
234     emit RoleRemoved(addr, roleName);
235   }
236 
237   /**
238    * @dev modifier to scope access to a single role (uses msg.sender as addr)
239    * @param roleName the name of the role
240    * // reverts
241    */
242   modifier onlyRole(string roleName)
243   {
244     checkRole(msg.sender, roleName);
245     _;
246   }
247 
248   /**
249    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
250    * @param roleNames the names of the roles to scope access to
251    * // reverts
252    *
253    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
254    *  see: https://github.com/ethereum/solidity/issues/2467
255    */
256   // modifier onlyRoles(string[] roleNames) {
257   //     bool hasAnyRole = false;
258   //     for (uint8 i = 0; i < roleNames.length; i++) {
259   //         if (hasRole(msg.sender, roleNames[i])) {
260   //             hasAnyRole = true;
261   //             break;
262   //         }
263   //     }
264 
265   //     require(hasAnyRole);
266 
267   //     _;
268   // }
269 }
270 
271 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
272 
273 /**
274  * @title SafeMath
275  * @dev Math operations with safety checks that throw on error
276  */
277 library SafeMath {
278 
279   /**
280   * @dev Multiplies two numbers, throws on overflow.
281   */
282   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
283     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
284     // benefit is lost if 'b' is also tested.
285     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
286     if (a == 0) {
287       return 0;
288     }
289 
290     c = a * b;
291     assert(c / a == b);
292     return c;
293   }
294 
295   /**
296   * @dev Integer division of two numbers, truncating the quotient.
297   */
298   function div(uint256 a, uint256 b) internal pure returns (uint256) {
299     // assert(b > 0); // Solidity automatically throws when dividing by 0
300     // uint256 c = a / b;
301     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
302     return a / b;
303   }
304 
305   /**
306   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
307   */
308   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
309     assert(b <= a);
310     return a - b;
311   }
312 
313   /**
314   * @dev Adds two numbers, throws on overflow.
315   */
316   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
317     c = a + b;
318     assert(c >= a);
319     return c;
320   }
321 }
322 
323 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
324 
325 /**
326  * @title ERC20Basic
327  * @dev Simpler version of ERC20 interface
328  * @dev see https://github.com/ethereum/EIPs/issues/179
329  */
330 contract ERC20Basic {
331   function totalSupply() public view returns (uint256);
332   function balanceOf(address who) public view returns (uint256);
333   function transfer(address to, uint256 value) public returns (bool);
334   event Transfer(address indexed from, address indexed to, uint256 value);
335 }
336 
337 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
338 
339 /**
340  * @title Basic token
341  * @dev Basic version of StandardToken, with no allowances.
342  */
343 contract BasicToken is ERC20Basic {
344   using SafeMath for uint256;
345 
346   mapping(address => uint256) balances;
347 
348   uint256 totalSupply_;
349 
350   /**
351   * @dev total number of tokens in existence
352   */
353   function totalSupply() public view returns (uint256) {
354     return totalSupply_;
355   }
356 
357   /**
358   * @dev transfer token for a specified address
359   * @param _to The address to transfer to.
360   * @param _value The amount to be transferred.
361   */
362   function transfer(address _to, uint256 _value) public returns (bool) {
363     require(_to != address(0));
364     require(_value <= balances[msg.sender]);
365 
366     balances[msg.sender] = balances[msg.sender].sub(_value);
367     balances[_to] = balances[_to].add(_value);
368     emit Transfer(msg.sender, _to, _value);
369     return true;
370   }
371 
372   /**
373   * @dev Gets the balance of the specified address.
374   * @param _owner The address to query the the balance of.
375   * @return An uint256 representing the amount owned by the passed address.
376   */
377   function balanceOf(address _owner) public view returns (uint256) {
378     return balances[_owner];
379   }
380 
381 }
382 
383 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
384 
385 /**
386  * @title ERC20 interface
387  * @dev see https://github.com/ethereum/EIPs/issues/20
388  */
389 contract ERC20 is ERC20Basic {
390   function allowance(address owner, address spender)
391     public view returns (uint256);
392 
393   function transferFrom(address from, address to, uint256 value)
394     public returns (bool);
395 
396   function approve(address spender, uint256 value) public returns (bool);
397   event Approval(
398     address indexed owner,
399     address indexed spender,
400     uint256 value
401   );
402 }
403 
404 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
405 
406 /**
407  * @title Standard ERC20 token
408  *
409  * @dev Implementation of the basic standard token.
410  * @dev https://github.com/ethereum/EIPs/issues/20
411  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
412  */
413 contract StandardToken is ERC20, BasicToken {
414 
415   mapping (address => mapping (address => uint256)) internal allowed;
416 
417 
418   /**
419    * @dev Transfer tokens from one address to another
420    * @param _from address The address which you want to send tokens from
421    * @param _to address The address which you want to transfer to
422    * @param _value uint256 the amount of tokens to be transferred
423    */
424   function transferFrom(
425     address _from,
426     address _to,
427     uint256 _value
428   )
429     public
430     returns (bool)
431   {
432     require(_to != address(0));
433     require(_value <= balances[_from]);
434     require(_value <= allowed[_from][msg.sender]);
435 
436     balances[_from] = balances[_from].sub(_value);
437     balances[_to] = balances[_to].add(_value);
438     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
439     emit Transfer(_from, _to, _value);
440     return true;
441   }
442 
443   /**
444    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
445    *
446    * Beware that changing an allowance with this method brings the risk that someone may use both the old
447    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
448    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
449    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
450    * @param _spender The address which will spend the funds.
451    * @param _value The amount of tokens to be spent.
452    */
453   function approve(address _spender, uint256 _value) public returns (bool) {
454     allowed[msg.sender][_spender] = _value;
455     emit Approval(msg.sender, _spender, _value);
456     return true;
457   }
458 
459   /**
460    * @dev Function to check the amount of tokens that an owner allowed to a spender.
461    * @param _owner address The address which owns the funds.
462    * @param _spender address The address which will spend the funds.
463    * @return A uint256 specifying the amount of tokens still available for the spender.
464    */
465   function allowance(
466     address _owner,
467     address _spender
468    )
469     public
470     view
471     returns (uint256)
472   {
473     return allowed[_owner][_spender];
474   }
475 
476   /**
477    * @dev Increase the amount of tokens that an owner allowed to a spender.
478    *
479    * approve should be called when allowed[_spender] == 0. To increment
480    * allowed value is better to use this function to avoid 2 calls (and wait until
481    * the first transaction is mined)
482    * From MonolithDAO Token.sol
483    * @param _spender The address which will spend the funds.
484    * @param _addedValue The amount of tokens to increase the allowance by.
485    */
486   function increaseApproval(
487     address _spender,
488     uint _addedValue
489   )
490     public
491     returns (bool)
492   {
493     allowed[msg.sender][_spender] = (
494       allowed[msg.sender][_spender].add(_addedValue));
495     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
496     return true;
497   }
498 
499   /**
500    * @dev Decrease the amount of tokens that an owner allowed to a spender.
501    *
502    * approve should be called when allowed[_spender] == 0. To decrement
503    * allowed value is better to use this function to avoid 2 calls (and wait until
504    * the first transaction is mined)
505    * From MonolithDAO Token.sol
506    * @param _spender The address which will spend the funds.
507    * @param _subtractedValue The amount of tokens to decrease the allowance by.
508    */
509   function decreaseApproval(
510     address _spender,
511     uint _subtractedValue
512   )
513     public
514     returns (bool)
515   {
516     uint oldValue = allowed[msg.sender][_spender];
517     if (_subtractedValue > oldValue) {
518       allowed[msg.sender][_spender] = 0;
519     } else {
520       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
521     }
522     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
523     return true;
524   }
525 
526 }
527 
528 // File: contracts/token/PausableToken.sol
529 
530 contract PausableToken is StandardToken, Pausable, RBAC {
531 
532     string public constant ROLE_ADMINISTRATOR = "administrator";
533 
534     modifier whenNotPausedOrAuthorized() {
535         require(!paused || hasRole(msg.sender, ROLE_ADMINISTRATOR));
536         _;
537     }
538     /**
539      * @dev Add an address that can administer the token even when paused.
540      * @param _administrator Address of the given administrator.
541      * @return True if the administrator has been added, false if the address was already an administrator.
542      */
543     function addAdministrator(address _administrator) onlyOwner public returns (bool) {
544         if (isAdministrator(_administrator)) {
545             return false;
546         } else {
547             addRole(_administrator, ROLE_ADMINISTRATOR);
548             return true;
549         }
550     }
551 
552     /**
553      * @dev Remove an administrator.
554      * @param _administrator Address of the administrator to be removed.
555      * @return True if the administrator has been removed,
556      *  false if the address wasn't an administrator in the first place.
557      */
558     function removeAdministrator(address _administrator) onlyOwner public returns (bool) {
559         if (isAdministrator(_administrator)) {
560             removeRole(_administrator, ROLE_ADMINISTRATOR);
561             return true;
562         } else {
563             return false;
564         }
565     }
566 
567     /**
568      * @dev Determine if address is an administrator.
569      * @param _administrator Address of the administrator to be checked.
570      */
571     function isAdministrator(address _administrator) public view returns (bool) {
572         return hasRole(_administrator, ROLE_ADMINISTRATOR);
573     }
574 
575     /**
576     * @dev Transfer token for a specified address with pause feature for administrator.
577     * @dev Only applies when the transfer is allowed by the owner.
578     * @param _to The address to transfer to.
579     * @param _value The amount to be transferred.
580     */
581     function transfer(address _to, uint256 _value) public whenNotPausedOrAuthorized returns (bool) {
582         return super.transfer(_to, _value);
583     }
584 
585     /**
586     * @dev Transfer tokens from one address to another with pause feature for administrator.
587     * @dev Only applies when the transfer is allowed by the owner.
588     * @param _from address The address which you want to send tokens from
589     * @param _to address The address which you want to transfer to
590     * @param _value uint256 the amount of tokens to be transferred
591     */
592     function transferFrom(address _from, address _to, uint256 _value) public whenNotPausedOrAuthorized returns (bool) {
593         return super.transferFrom(_from, _to, _value);
594     }
595 }
596 
597 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
598 
599 /**
600  * @title Burnable Token
601  * @dev Token that can be irreversibly burned (destroyed).
602  */
603 contract BurnableToken is BasicToken {
604 
605   event Burn(address indexed burner, uint256 value);
606 
607   /**
608    * @dev Burns a specific amount of tokens.
609    * @param _value The amount of token to be burned.
610    */
611   function burn(uint256 _value) public {
612     _burn(msg.sender, _value);
613   }
614 
615   function _burn(address _who, uint256 _value) internal {
616     require(_value <= balances[_who]);
617     // no need to require value <= totalSupply, since that would imply the
618     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
619 
620     balances[_who] = balances[_who].sub(_value);
621     totalSupply_ = totalSupply_.sub(_value);
622     emit Burn(_who, _value);
623     emit Transfer(_who, address(0), _value);
624   }
625 }
626 
627 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
628 
629 /**
630  * @title DetailedERC20 token
631  * @dev The decimals are only for visualization purposes.
632  * All the operations are done using the smallest and indivisible token unit,
633  * just as on Ethereum all the operations are done in wei.
634  */
635 contract DetailedERC20 is ERC20 {
636   string public name;
637   string public symbol;
638   uint8 public decimals;
639 
640   constructor(string _name, string _symbol, uint8 _decimals) public {
641     name = _name;
642     symbol = _symbol;
643     decimals = _decimals;
644   }
645 }
646 
647 // File: contracts/BlockFollowToken.sol
648 
649 contract BlockFollowToken is DetailedERC20, PausableToken, BurnableToken {
650 
651     uint256 public initialTotalSupply;
652 
653     constructor() public DetailedERC20("BlockFollow Network", "BFN", 8)
654     {
655         initialTotalSupply = 210e6 * (uint256(10) ** decimals);
656         totalSupply_ = initialTotalSupply;
657         balances[msg.sender] = initialTotalSupply;
658         emit Transfer(address(0), msg.sender, initialTotalSupply);
659     }
660 }