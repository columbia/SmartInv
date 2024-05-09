1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to relinquish control of the contract.
38    */
39   function renounceOwnership() public onlyOwner {
40     emit OwnershipRenounced(owner);
41     owner = address(0);
42   }
43 
44   /**
45    * @dev Allows the current owner to transfer control of the contract to a newOwner.
46    * @param _newOwner The address to transfer ownership to.
47    */
48   function transferOwnership(address _newOwner) public onlyOwner {
49     _transferOwnership(_newOwner);
50   }
51 
52   /**
53    * @dev Transfers control of the contract to a newOwner.
54    * @param _newOwner The address to transfer ownership to.
55    */
56   function _transferOwnership(address _newOwner) internal {
57     require(_newOwner != address(0));
58     emit OwnershipTransferred(owner, _newOwner);
59     owner = _newOwner;
60   }
61 }
62 
63 
64 
65 /**
66  * @title ERC20Basic
67  * @dev Simpler version of ERC20 interface
68  * @dev see https://github.com/ethereum/EIPs/issues/179
69  */
70 contract ERC20Basic {
71   function totalSupply() public view returns (uint256);
72   function balanceOf(address who) public view returns (uint256);
73   function transfer(address to, uint256 value) public returns (bool);
74   event Transfer(address indexed from, address indexed to, uint256 value);
75 }
76 
77 
78 
79 /**
80  * @title Roles
81  * @author Francisco Giordano (@frangio)
82  * @dev Library for managing addresses assigned to a Role.
83  *      See RBAC.sol for example usage.
84  */
85 library Roles {
86   struct Role {
87     mapping (address => bool) bearer;
88   }
89 
90   /**
91    * @dev give an address access to this role
92    */
93   function add(Role storage role, address addr)
94     internal
95   {
96     role.bearer[addr] = true;
97   }
98 
99   /**
100    * @dev remove an address' access to this role
101    */
102   function remove(Role storage role, address addr)
103     internal
104   {
105     role.bearer[addr] = false;
106   }
107 
108   /**
109    * @dev check if an address has this role
110    * // reverts
111    */
112   function check(Role storage role, address addr)
113     view
114     internal
115   {
116     require(has(role, addr));
117   }
118 
119   /**
120    * @dev check if an address has this role
121    * @return bool
122    */
123   function has(Role storage role, address addr)
124     view
125     internal
126     returns (bool)
127   {
128     return role.bearer[addr];
129   }
130 }
131 
132 
133 
134 
135 
136 /**
137  * @title RBAC (Role-Based Access Control)
138  * @author Matt Condon (@Shrugs)
139  * @dev Stores and provides setters and getters for roles and addresses.
140  * @dev Supports unlimited numbers of roles and addresses.
141  * @dev See //contracts/mocks/RBACMock.sol for an example of usage.
142  * This RBAC method uses strings to key roles. It may be beneficial
143  *  for you to write your own implementation of this interface using Enums or similar.
144  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
145  *  to avoid typos.
146  */
147 contract RBAC {
148   using Roles for Roles.Role;
149 
150   mapping (string => Roles.Role) private roles;
151 
152   event RoleAdded(address addr, string roleName);
153   event RoleRemoved(address addr, string roleName);
154 
155   /**
156    * @dev reverts if addr does not have role
157    * @param addr address
158    * @param roleName the name of the role
159    * // reverts
160    */
161   function checkRole(address addr, string roleName)
162     view
163     public
164   {
165     roles[roleName].check(addr);
166   }
167 
168   /**
169    * @dev determine if addr has role
170    * @param addr address
171    * @param roleName the name of the role
172    * @return bool
173    */
174   function hasRole(address addr, string roleName)
175     view
176     public
177     returns (bool)
178   {
179     return roles[roleName].has(addr);
180   }
181 
182   /**
183    * @dev add a role to an address
184    * @param addr address
185    * @param roleName the name of the role
186    */
187   function addRole(address addr, string roleName)
188     internal
189   {
190     roles[roleName].add(addr);
191     emit RoleAdded(addr, roleName);
192   }
193 
194   /**
195    * @dev remove a role from an address
196    * @param addr address
197    * @param roleName the name of the role
198    */
199   function removeRole(address addr, string roleName)
200     internal
201   {
202     roles[roleName].remove(addr);
203     emit RoleRemoved(addr, roleName);
204   }
205 
206   /**
207    * @dev modifier to scope access to a single role (uses msg.sender as addr)
208    * @param roleName the name of the role
209    * // reverts
210    */
211   modifier onlyRole(string roleName)
212   {
213     checkRole(msg.sender, roleName);
214     _;
215   }
216 
217   /**
218    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
219    * @param roleNames the names of the roles to scope access to
220    * // reverts
221    *
222    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
223    *  see: https://github.com/ethereum/solidity/issues/2467
224    */
225   // modifier onlyRoles(string[] roleNames) {
226   //     bool hasAnyRole = false;
227   //     for (uint8 i = 0; i < roleNames.length; i++) {
228   //         if (hasRole(msg.sender, roleNames[i])) {
229   //             hasAnyRole = true;
230   //             break;
231   //         }
232   //     }
233 
234   //     require(hasAnyRole);
235 
236   //     _;
237   // }
238 }
239 
240 
241 
242 
243 
244 
245 
246 
247 
248 /**
249  * @title ERC20 interface
250  * @dev see https://github.com/ethereum/EIPs/issues/20
251  */
252 contract ERC20 is ERC20Basic {
253   function allowance(address owner, address spender)
254     public view returns (uint256);
255 
256   function transferFrom(address from, address to, uint256 value)
257     public returns (bool);
258 
259   function approve(address spender, uint256 value) public returns (bool);
260   event Approval(
261     address indexed owner,
262     address indexed spender,
263     uint256 value
264   );
265 }
266 
267 
268 
269 /**
270  * @title DetailedERC20 token
271  * @dev The decimals are only for visualization purposes.
272  * All the operations are done using the smallest and indivisible token unit,
273  * just as on Ethereum all the operations are done in wei.
274  */
275 contract DetailedERC20 is ERC20 {
276   string public name;
277   string public symbol;
278   uint8 public decimals;
279 
280   constructor(string _name, string _symbol, uint8 _decimals) public {
281     name = _name;
282     symbol = _symbol;
283     decimals = _decimals;
284   }
285 }
286 
287 
288 
289 
290 
291 
292 
293 
294 
295 
296 
297 
298 /**
299  * @title SafeMath
300  * @dev Math operations with safety checks that throw on error
301  */
302 library SafeMath {
303 
304   /**
305   * @dev Multiplies two numbers, throws on overflow.
306   */
307   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
308     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
309     // benefit is lost if 'b' is also tested.
310     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
311     if (a == 0) {
312       return 0;
313     }
314 
315     c = a * b;
316     assert(c / a == b);
317     return c;
318   }
319 
320   /**
321   * @dev Integer division of two numbers, truncating the quotient.
322   */
323   function div(uint256 a, uint256 b) internal pure returns (uint256) {
324     // assert(b > 0); // Solidity automatically throws when dividing by 0
325     // uint256 c = a / b;
326     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
327     return a / b;
328   }
329 
330   /**
331   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
332   */
333   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
334     assert(b <= a);
335     return a - b;
336   }
337 
338   /**
339   * @dev Adds two numbers, throws on overflow.
340   */
341   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
342     c = a + b;
343     assert(c >= a);
344     return c;
345   }
346 }
347 
348 
349 
350 /**
351  * @title Basic token
352  * @dev Basic version of StandardToken, with no allowances.
353  */
354 contract BasicToken is ERC20Basic {
355   using SafeMath for uint256;
356 
357   mapping(address => uint256) balances;
358 
359   uint256 totalSupply_;
360 
361   /**
362   * @dev total number of tokens in existence
363   */
364   function totalSupply() public view returns (uint256) {
365     return totalSupply_;
366   }
367 
368   /**
369   * @dev transfer token for a specified address
370   * @param _to The address to transfer to.
371   * @param _value The amount to be transferred.
372   */
373   function transfer(address _to, uint256 _value) public returns (bool) {
374     require(_to != address(0));
375     require(_value <= balances[msg.sender]);
376 
377     balances[msg.sender] = balances[msg.sender].sub(_value);
378     balances[_to] = balances[_to].add(_value);
379     emit Transfer(msg.sender, _to, _value);
380     return true;
381   }
382 
383   /**
384   * @dev Gets the balance of the specified address.
385   * @param _owner The address to query the the balance of.
386   * @return An uint256 representing the amount owned by the passed address.
387   */
388   function balanceOf(address _owner) public view returns (uint256) {
389     return balances[_owner];
390   }
391 
392 }
393 
394 
395 
396 
397 /**
398  * @title Standard ERC20 token
399  *
400  * @dev Implementation of the basic standard token.
401  * @dev https://github.com/ethereum/EIPs/issues/20
402  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
403  */
404 contract StandardToken is ERC20, BasicToken {
405 
406   mapping (address => mapping (address => uint256)) internal allowed;
407 
408 
409   /**
410    * @dev Transfer tokens from one address to another
411    * @param _from address The address which you want to send tokens from
412    * @param _to address The address which you want to transfer to
413    * @param _value uint256 the amount of tokens to be transferred
414    */
415   function transferFrom(
416     address _from,
417     address _to,
418     uint256 _value
419   )
420     public
421     returns (bool)
422   {
423     require(_to != address(0));
424     require(_value <= balances[_from]);
425     require(_value <= allowed[_from][msg.sender]);
426 
427     balances[_from] = balances[_from].sub(_value);
428     balances[_to] = balances[_to].add(_value);
429     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
430     emit Transfer(_from, _to, _value);
431     return true;
432   }
433 
434   /**
435    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
436    *
437    * Beware that changing an allowance with this method brings the risk that someone may use both the old
438    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
439    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
440    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
441    * @param _spender The address which will spend the funds.
442    * @param _value The amount of tokens to be spent.
443    */
444   function approve(address _spender, uint256 _value) public returns (bool) {
445     allowed[msg.sender][_spender] = _value;
446     emit Approval(msg.sender, _spender, _value);
447     return true;
448   }
449 
450   /**
451    * @dev Function to check the amount of tokens that an owner allowed to a spender.
452    * @param _owner address The address which owns the funds.
453    * @param _spender address The address which will spend the funds.
454    * @return A uint256 specifying the amount of tokens still available for the spender.
455    */
456   function allowance(
457     address _owner,
458     address _spender
459    )
460     public
461     view
462     returns (uint256)
463   {
464     return allowed[_owner][_spender];
465   }
466 
467   /**
468    * @dev Increase the amount of tokens that an owner allowed to a spender.
469    *
470    * approve should be called when allowed[_spender] == 0. To increment
471    * allowed value is better to use this function to avoid 2 calls (and wait until
472    * the first transaction is mined)
473    * From MonolithDAO Token.sol
474    * @param _spender The address which will spend the funds.
475    * @param _addedValue The amount of tokens to increase the allowance by.
476    */
477   function increaseApproval(
478     address _spender,
479     uint _addedValue
480   )
481     public
482     returns (bool)
483   {
484     allowed[msg.sender][_spender] = (
485       allowed[msg.sender][_spender].add(_addedValue));
486     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
487     return true;
488   }
489 
490   /**
491    * @dev Decrease the amount of tokens that an owner allowed to a spender.
492    *
493    * approve should be called when allowed[_spender] == 0. To decrement
494    * allowed value is better to use this function to avoid 2 calls (and wait until
495    * the first transaction is mined)
496    * From MonolithDAO Token.sol
497    * @param _spender The address which will spend the funds.
498    * @param _subtractedValue The amount of tokens to decrease the allowance by.
499    */
500   function decreaseApproval(
501     address _spender,
502     uint _subtractedValue
503   )
504     public
505     returns (bool)
506   {
507     uint oldValue = allowed[msg.sender][_spender];
508     if (_subtractedValue > oldValue) {
509       allowed[msg.sender][_spender] = 0;
510     } else {
511       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
512     }
513     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
514     return true;
515   }
516 
517 }
518 
519 
520 
521 
522 
523 
524 
525 /**
526  * @title Pausable
527  * @dev Base contract which allows children to implement an emergency stop mechanism.
528  */
529 contract Pausable is Ownable {
530   event Pause();
531   event Unpause();
532 
533   bool public paused = false;
534 
535 
536   /**
537    * @dev Modifier to make a function callable only when the contract is not paused.
538    */
539   modifier whenNotPaused() {
540     require(!paused);
541     _;
542   }
543 
544   /**
545    * @dev Modifier to make a function callable only when the contract is paused.
546    */
547   modifier whenPaused() {
548     require(paused);
549     _;
550   }
551 
552   /**
553    * @dev called by the owner to pause, triggers stopped state
554    */
555   function pause() onlyOwner whenNotPaused public {
556     paused = true;
557     emit Pause();
558   }
559 
560   /**
561    * @dev called by the owner to unpause, returns to normal state
562    */
563   function unpause() onlyOwner whenPaused public {
564     paused = false;
565     emit Unpause();
566   }
567 }
568 
569 
570 
571 
572 contract PausableToken is StandardToken, Pausable, RBAC {
573 
574     string public constant ROLE_ADMINISTRATOR = "administrator";
575 
576     modifier whenNotPausedOrAuthorized() {
577         require(!paused || hasRole(msg.sender, ROLE_ADMINISTRATOR));
578         _;
579     }
580     /**
581      * @dev Add an address that can administer the token even when paused.
582      * @param _administrator Address of the given administrator.
583      * @return True if the administrator has been added, false if the address was already an administrator.
584      */
585     function addAdministrator(address _administrator) onlyOwner public returns (bool) {
586         if (isAdministrator(_administrator)) {
587             return false;
588         } else {
589             addRole(_administrator, ROLE_ADMINISTRATOR);
590             return true;
591         }
592     }
593 
594     /**
595      * @dev Remove an administrator.
596      * @param _administrator Address of the administrator to be removed.
597      * @return True if the administrator has been removed,
598      *  false if the address wasn't an administrator in the first place.
599      */
600     function removeAdministrator(address _administrator) onlyOwner public returns (bool) {
601         if (isAdministrator(_administrator)) {
602             removeRole(_administrator, ROLE_ADMINISTRATOR);
603             return true;
604         } else {
605             return false;
606         }
607     }
608 
609     /**
610      * @dev Determine if address is an administrator.
611      * @param _administrator Address of the administrator to be checked.
612      */
613     function isAdministrator(address _administrator) public view returns (bool) {
614         return hasRole(_administrator, ROLE_ADMINISTRATOR);
615     }
616 
617     /**
618     * @dev Transfer token for a specified address with pause feature for administrator.
619     * @dev Only applies when the transfer is allowed by the owner.
620     * @param _to The address to transfer to.
621     * @param _value The amount to be transferred.
622     */
623     function transfer(address _to, uint256 _value) public whenNotPausedOrAuthorized returns (bool) {
624         return super.transfer(_to, _value);
625     }
626 
627     /**
628     * @dev Transfer tokens from one address to another with pause feature for administrator.
629     * @dev Only applies when the transfer is allowed by the owner.
630     * @param _from address The address which you want to send tokens from
631     * @param _to address The address which you want to transfer to
632     * @param _value uint256 the amount of tokens to be transferred
633     */
634     function transferFrom(address _from, address _to, uint256 _value) public whenNotPausedOrAuthorized returns (bool) {
635         return super.transferFrom(_from, _to, _value);
636     }
637 }
638 
639 
640 contract IQCoin is DetailedERC20, PausableToken {
641 
642     uint256 public initialTotalSupply;
643     uint256 constant INITIAL_WHOLE_TOKENS = 10 * 10e7;
644 
645     constructor()
646         public
647         DetailedERC20("IQ Coin", "IQC", 18)
648     {
649         initialTotalSupply = INITIAL_WHOLE_TOKENS * uint256(10) ** decimals;
650         totalSupply_ = initialTotalSupply;
651         balances[msg.sender] = initialTotalSupply;
652         emit Transfer(address(0), msg.sender, initialTotalSupply);
653     }
654 }