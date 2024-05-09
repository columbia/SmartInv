1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
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
36    * @dev Allows the current owner to relinquish control of the contract.
37    * @notice Renouncing to ownership will leave the contract without an owner.
38    * It will not be possible to call the functions with the `onlyOwner`
39    * modifier anymore.
40    */
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipRenounced(owner);
43     owner = address(0);
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address _newOwner) public onlyOwner {
51     _transferOwnership(_newOwner);
52   }
53 
54   /**
55    * @dev Transfers control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function _transferOwnership(address _newOwner) internal {
59     require(_newOwner != address(0));
60     emit OwnershipTransferred(owner, _newOwner);
61     owner = _newOwner;
62   }
63 }
64 
65 /**
66  * @title SafeMath
67  * @dev Math operations with safety checks that throw on error
68  */
69 library SafeMath {
70 
71   /**
72   * @dev Multiplies two numbers, throws on overflow.
73   */
74   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
75     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
76     // benefit is lost if 'b' is also tested.
77     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
78     if (_a == 0) {
79       return 0;
80     }
81 
82     c = _a * _b;
83     assert(c / _a == _b);
84     return c;
85   }
86 
87   /**
88   * @dev Integer division of two numbers, truncating the quotient.
89   */
90   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
91     // assert(_b > 0); // Solidity automatically throws when dividing by 0
92     // uint256 c = _a / _b;
93     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
94     return _a / _b;
95   }
96 
97   /**
98   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
99   */
100   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
101     assert(_b <= _a);
102     return _a - _b;
103   }
104 
105   /**
106   * @dev Adds two numbers, throws on overflow.
107   */
108   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
109     c = _a + _b;
110     assert(c >= _a);
111     return c;
112   }
113 }
114 
115 /**
116  * @title ERC20Basic
117  * @dev Simpler version of ERC20 interface
118  * See https://github.com/ethereum/EIPs/issues/179
119  */
120 contract ERC20Basic {
121   function totalSupply() public view returns (uint256);
122   function balanceOf(address _who) public view returns (uint256);
123   function transfer(address _to, uint256 _value) public returns (bool);
124   event Transfer(address indexed from, address indexed to, uint256 value);
125 }
126 
127 /**
128  * @title Roles
129  * @author Francisco Giordano (@frangio)
130  * @dev Library for managing addresses assigned to a Role.
131  * See RBAC.sol for example usage.
132  */
133 library Roles {
134   struct Role {
135     mapping (address => bool) bearer;
136   }
137 
138   /**
139    * @dev give an address access to this role
140    */
141   function add(Role storage _role, address _addr)
142     internal
143   {
144     _role.bearer[_addr] = true;
145   }
146 
147   /**
148    * @dev remove an address' access to this role
149    */
150   function remove(Role storage _role, address _addr)
151     internal
152   {
153     _role.bearer[_addr] = false;
154   }
155 
156   /**
157    * @dev check if an address has this role
158    * // reverts
159    */
160   function check(Role storage _role, address _addr)
161     internal
162     view
163   {
164     require(has(_role, _addr));
165   }
166 
167   /**
168    * @dev check if an address has this role
169    * @return bool
170    */
171   function has(Role storage _role, address _addr)
172     internal
173     view
174     returns (bool)
175   {
176     return _role.bearer[_addr];
177   }
178 }
179 
180 
181 /**
182  * @title RBAC (Role-Based Access Control)
183  * @author Matt Condon (@Shrugs)
184  * @dev Stores and provides setters and getters for roles and addresses.
185  * Supports unlimited numbers of roles and addresses.
186  * See //contracts/mocks/RBACMock.sol for an example of usage.
187  * This RBAC method uses strings to key roles. It may be beneficial
188  * for you to write your own implementation of this interface using Enums or similar.
189  */
190 contract RBAC {
191   using Roles for Roles.Role;
192 
193   mapping (string => Roles.Role) private roles;
194 
195   event RoleAdded(address indexed operator, string role);
196   event RoleRemoved(address indexed operator, string role);
197 
198   /**
199    * @dev reverts if addr does not have role
200    * @param _operator address
201    * @param _role the name of the role
202    * // reverts
203    */
204   function checkRole(address _operator, string _role)
205     public
206     view
207   {
208     roles[_role].check(_operator);
209   }
210 
211   /**
212    * @dev determine if addr has role
213    * @param _operator address
214    * @param _role the name of the role
215    * @return bool
216    */
217   function hasRole(address _operator, string _role)
218     public
219     view
220     returns (bool)
221   {
222     return roles[_role].has(_operator);
223   }
224 
225   /**
226    * @dev add a role to an address
227    * @param _operator address
228    * @param _role the name of the role
229    */
230   function addRole(address _operator, string _role)
231     internal
232   {
233     roles[_role].add(_operator);
234     emit RoleAdded(_operator, _role);
235   }
236 
237   /**
238    * @dev remove a role from an address
239    * @param _operator address
240    * @param _role the name of the role
241    */
242   function removeRole(address _operator, string _role)
243     internal
244   {
245     roles[_role].remove(_operator);
246     emit RoleRemoved(_operator, _role);
247   }
248 
249   /**
250    * @dev modifier to scope access to a single role (uses msg.sender as addr)
251    * @param _role the name of the role
252    * // reverts
253    */
254   modifier onlyRole(string _role)
255   {
256     checkRole(msg.sender, _role);
257     _;
258   }
259 
260   /**
261    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
262    * @param _roles the names of the roles to scope access to
263    * // reverts
264    *
265    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
266    *  see: https://github.com/ethereum/solidity/issues/2467
267    */
268   // modifier onlyRoles(string[] _roles) {
269   //     bool hasAnyRole = false;
270   //     for (uint8 i = 0; i < _roles.length; i++) {
271   //         if (hasRole(msg.sender, _roles[i])) {
272   //             hasAnyRole = true;
273   //             break;
274   //         }
275   //     }
276 
277   //     require(hasAnyRole);
278 
279   //     _;
280   // }
281 }
282 
283 contract CardioCoin is ERC20Basic, Ownable, RBAC {
284     string public constant ROLE_NEED_LOCK_UP = "need_lock_up";
285 
286     using SafeMath for uint256;
287 
288     uint public constant RESELLING_LOCKUP_PERIOD = 210 days;
289     uint public constant PRE_PUBLIC_LOCKUP_PERIOD = 180 days;
290     uint public constant UNLOCK_TEN_PERCENT_PERIOD = 30 days;
291 
292     string public name = "CardioCoin";
293     string public symbol = "CRDC";
294 
295     uint8 public decimals = 18;
296     uint256 internal totalSupply_ = 50000000000 * (10 ** uint256(decimals));
297 
298     mapping (address => uint256) internal reselling;
299     uint256 internal resellingAmount = 0;
300 
301     event ResellingAdded(address seller, uint256 amount);
302     event ResellingSubtracted(address seller, uint256 amount);
303     event Reselled(address seller, address buyer, uint256 amount);
304 
305     event TokenLocked(address owner, uint256 amount);
306     event TokenUnlocked(address owner, uint256 amount);
307 
308     constructor() public Ownable() {
309         balance memory b;
310 
311         b.available = totalSupply_;
312         balances[msg.sender] = b;
313     }
314 
315     function addLockedUpTokens(address _owner, uint256 amount, uint lockupPeriod)
316     internal {
317         balance storage b = balances[_owner];
318         lockup memory l;
319 
320         l.amount = amount;
321         l.unlockTimestamp = now + lockupPeriod;
322         b.lockedUp += amount;
323         b.lockUpData[b.lockUpCount] = l;
324         b.lockUpCount += 1;
325         emit TokenLocked(_owner, amount);
326     }
327 
328     // 리셀링 등록
329 
330     function addResellingAmount(address seller, uint256 amount)
331     public
332     onlyOwner
333     {
334         require(seller != address(0));
335         require(amount > 0);
336         require(balances[seller].available >= amount);
337 
338         reselling[seller] = reselling[seller].add(amount);
339         balances[seller].available = balances[seller].available.sub(amount);
340         resellingAmount = resellingAmount.add(amount);
341         emit ResellingAdded(seller, amount);
342     }
343 
344     function subtractResellingAmount(address seller, uint256 _amount)
345     public
346     onlyOwner
347     {
348         uint256 amount = reselling[seller];
349 
350         require(seller != address(0));
351         require(_amount > 0);
352         require(amount >= _amount);
353 
354         reselling[seller] = reselling[seller].sub(_amount);
355         resellingAmount = resellingAmount.sub(_amount);
356         balances[seller].available = balances[seller].available.add(_amount);
357         emit ResellingSubtracted(seller, _amount);
358     }
359 
360     function cancelReselling(address seller)
361     public
362     onlyOwner {
363         uint256 amount = reselling[seller];
364 
365         require(seller != address(0));
366         require(amount > 0);
367 
368         subtractResellingAmount(seller, amount);
369     }
370 
371     function resell(address seller, address buyer, uint256 amount)
372     public
373     onlyOwner
374     returns (bool)
375     {
376         require(seller != address(0));
377         require(buyer != address(0));
378         require(amount > 0);
379         require(reselling[seller] >= amount);
380         require(balances[owner].available >= amount);
381 
382         reselling[seller] = reselling[seller].sub(amount);
383         resellingAmount = resellingAmount.sub(amount);
384 
385         addLockedUpTokens(buyer, amount, RESELLING_LOCKUP_PERIOD);
386         emit Reselled(seller, buyer, amount);
387 
388         return true;
389     }
390 
391     // BasicToken
392 
393     struct lockup {
394         uint256 amount;
395         uint unlockTimestamp;
396         uint unlockCount;
397     }
398 
399     struct balance {
400         uint256 available;
401         uint256 lockedUp;
402         mapping (uint => lockup) lockUpData;
403         uint lockUpCount;
404         uint unlockIndex;
405     }
406 
407     mapping(address => balance) internal balances;
408 
409     function unlockBalance(address _owner) internal {
410         balance storage b = balances[_owner];
411 
412         if (b.lockUpCount > 0 && b.unlockIndex < b.lockUpCount) {
413             for (uint i = b.unlockIndex; i < b.lockUpCount; i++) {
414                 lockup storage l = b.lockUpData[i];
415 
416                 if (l.unlockTimestamp <= now) {
417                     uint count = unlockCount(l.unlockTimestamp, l.unlockCount);
418                     uint256 unlockedAmount = l.amount.mul(count).div(10);
419 
420                     if (unlockedAmount > b.lockedUp) {
421                         unlockedAmount = b.lockedUp;
422                         l.unlockCount = 10;
423                     } else {
424                         b.available = b.available.add(unlockedAmount);
425                         b.lockedUp = b.lockedUp.sub(unlockedAmount);
426                         l.unlockCount += count;
427                     }
428                     emit TokenUnlocked(_owner, unlockedAmount);
429                     if (l.unlockCount == 10) {
430                         lockup memory tempA = b.lockUpData[i];
431                         lockup memory tempB = b.lockUpData[b.unlockIndex];
432 
433                         b.lockUpData[i] = tempB;
434                         b.lockUpData[b.unlockIndex] = tempA;
435                         b.unlockIndex += 1;
436                     } else {
437                         l.unlockTimestamp += UNLOCK_TEN_PERCENT_PERIOD * count;
438                     }
439                 }
440             }
441         }
442     }
443 
444     function unlockCount(uint timestamp, uint _unlockCount) view internal returns (uint) {
445         uint count = 0;
446         uint nowFixed = now;
447 
448         while (timestamp < nowFixed && _unlockCount + count < 10) {
449             count++;
450             timestamp += UNLOCK_TEN_PERCENT_PERIOD;
451         }
452 
453         return count;
454     }
455 
456     /**
457     * @dev Total number of tokens in existence
458     */
459     function totalSupply() public view returns (uint256) {
460         return totalSupply_;
461     }
462 
463     /**
464     * @dev Transfer token for a specified address
465     * @param _to The address to transfer to.
466     * @param _value The amount to be transferred.
467     */
468     function transfer(address _to, uint256 _value)
469     public
470     returns (bool) {
471         unlockBalance(msg.sender);
472         if (hasRole(msg.sender, ROLE_NEED_LOCK_UP)) {
473             require(_value <= balances[msg.sender].available);
474             require(_to != address(0));
475 
476             balances[msg.sender].available = balances[msg.sender].available.sub(_value);
477             addLockedUpTokens(_to, _value, RESELLING_LOCKUP_PERIOD);
478         } else {
479             require(_value <= balances[msg.sender].available);
480             require(_to != address(0));
481 
482             balances[msg.sender].available = balances[msg.sender].available.sub(_value);
483             balances[_to].available = balances[_to].available.add(_value);
484         }
485         emit Transfer(msg.sender, _to, _value);
486 
487         return true;
488     }
489 
490     /**
491     * @dev Gets the balance of the specified address.
492     * @param _owner The address to query the the balance of.
493     * @return An uint256 representing the amount owned by the passed address.
494     */
495     function balanceOf(address _owner) public view returns (uint256) {
496         return balances[_owner].available.add(balances[_owner].lockedUp);
497     }
498 
499     function lockedUpBalanceOf(address _owner) public view returns (uint256) {
500         return balances[_owner].lockedUp;
501     }
502 
503     function resellingBalanceOf(address _owner) public view returns (uint256) {
504         return reselling[_owner];
505     }
506 
507     function refreshLockUpStatus()
508     public
509     {
510         unlockBalance(msg.sender);
511     }
512 
513     function transferWithLockUp(address _to, uint256 _value)
514     public
515     onlyOwner
516     returns (bool) {
517         require(_value <= balances[owner].available);
518         require(_to != address(0));
519 
520         balances[owner].available = balances[owner].available.sub(_value);
521         addLockedUpTokens(_to, _value, PRE_PUBLIC_LOCKUP_PERIOD);
522         emit Transfer(msg.sender, _to, _value);
523 
524         return true;
525     }
526 
527     // Burnable
528 
529     event Burn(address indexed burner, uint256 value);
530 
531     /**
532      * @dev Burns a specific amount of tokens.
533      * @param _value The amount of token to be burned.
534      */
535     function burn(uint256 _value) public {
536         _burn(msg.sender, _value);
537     }
538 
539     function _burn(address _who, uint256 _value) internal {
540         require(_value <= balances[_who].available);
541         // no need to require value <= totalSupply, since that would imply the
542         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
543 
544         balances[_who].available = balances[_who].available.sub(_value);
545         totalSupply_ = totalSupply_.sub(_value);
546         emit Burn(_who, _value);
547         emit Transfer(_who, address(0), _value);
548     }
549 
550     // 리셀러 락업
551 
552     function addAddressToNeedLockUpList(address _operator)
553     public
554     onlyOwner {
555         addRole(_operator, ROLE_NEED_LOCK_UP);
556     }
557 
558     function removeAddressToNeedLockUpList(address _operator)
559     public
560     onlyOwner {
561         removeRole(_operator, ROLE_NEED_LOCK_UP);
562     }
563 }