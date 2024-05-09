1 pragma solidity ^0.4.24;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public view returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 contract BasicToken is ERC20Basic {
17   using SafeMath for uint256;
18 
19   mapping(address => uint256) balances;
20 
21   uint256 totalSupply_;
22 
23   /**
24   * @dev total number of tokens in existence
25   */
26   function totalSupply() public view returns (uint256) {
27     return totalSupply_;
28   }
29 
30   /**
31   * @dev transfer token for a specified address
32   * @param _to The address to transfer to.
33   * @param _value The amount to be transferred.
34   */
35   function transfer(address _to, uint256 _value) public returns (bool) {
36     require(_to != address(0));
37     require(_value <= balances[msg.sender]);
38 
39     balances[msg.sender] = balances[msg.sender].sub(_value);
40     balances[_to] = balances[_to].add(_value);
41     emit Transfer(msg.sender, _to, _value);
42     return true;
43   }
44 
45   /**
46   * @dev Gets the balance of the specified address.
47   * @param _owner The address to query the the balance of.
48   * @return An uint256 representing the amount owned by the passed address.
49   */
50   function balanceOf(address _owner) public view returns (uint256) {
51     return balances[_owner];
52   }
53 
54 }
55 
56 contract StandardToken is ERC20, BasicToken {
57 
58   mapping (address => mapping (address => uint256)) internal allowed;
59 
60 
61   /**
62    * @dev Transfer tokens from one address to another
63    * @param _from address The address which you want to send tokens from
64    * @param _to address The address which you want to transfer to
65    * @param _value uint256 the amount of tokens to be transferred
66    */
67   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
68     require(_to != address(0));
69     require(_value <= balances[_from]);
70     require(_value <= allowed[_from][msg.sender]);
71 
72     balances[_from] = balances[_from].sub(_value);
73     balances[_to] = balances[_to].add(_value);
74     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
75     emit Transfer(_from, _to, _value);
76     return true;
77   }
78 
79   /**
80    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
81    *
82    * Beware that changing an allowance with this method brings the risk that someone may use both the old
83    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
84    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
85    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
86    * @param _spender The address which will spend the funds.
87    * @param _value The amount of tokens to be spent.
88    */
89   function approve(address _spender, uint256 _value) public returns (bool) {
90     allowed[msg.sender][_spender] = _value;
91     emit Approval(msg.sender, _spender, _value);
92     return true;
93   }
94 
95   /**
96    * @dev Function to check the amount of tokens that an owner allowed to a spender.
97    * @param _owner address The address which owns the funds.
98    * @param _spender address The address which will spend the funds.
99    * @return A uint256 specifying the amount of tokens still available for the spender.
100    */
101   function allowance(address _owner, address _spender) public view returns (uint256) {
102     return allowed[_owner][_spender];
103   }
104 
105   /**
106    * @dev Increase the amount of tokens that an owner allowed to a spender.
107    *
108    * approve should be called when allowed[_spender] == 0. To increment
109    * allowed value is better to use this function to avoid 2 calls (and wait until
110    * the first transaction is mined)
111    * From MonolithDAO Token.sol
112    * @param _spender The address which will spend the funds.
113    * @param _addedValue The amount of tokens to increase the allowance by.
114    */
115   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
116     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
117     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
118     return true;
119   }
120 
121   /**
122    * @dev Decrease the amount of tokens that an owner allowed to a spender.
123    *
124    * approve should be called when allowed[_spender] == 0. To decrement
125    * allowed value is better to use this function to avoid 2 calls (and wait until
126    * the first transaction is mined)
127    * From MonolithDAO Token.sol
128    * @param _spender The address which will spend the funds.
129    * @param _subtractedValue The amount of tokens to decrease the allowance by.
130    */
131   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
132     uint oldValue = allowed[msg.sender][_spender];
133     if (_subtractedValue > oldValue) {
134       allowed[msg.sender][_spender] = 0;
135     } else {
136       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
137     }
138     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
139     return true;
140   }
141 
142 }
143 
144 
145 contract BurnableToken is BasicToken {
146 
147   event Burn(address indexed burner, uint256 value);
148 
149   /**
150    * @dev Burns a specific amount of tokens.
151    * @param _value The amount of token to be burned.
152    */
153   function burn(uint256 _value) public {
154     _burn(msg.sender, _value);
155   }
156 
157   function _burn(address _who, uint256 _value) internal {
158     require(_value <= balances[_who]);
159     // no need to require value <= totalSupply, since that would imply the
160     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
161 
162     balances[_who] = balances[_who].sub(_value);
163     totalSupply_ = totalSupply_.sub(_value);
164     emit Burn(_who, _value);
165     emit Transfer(_who, address(0), _value);
166   }
167 }
168 
169 
170 library SafeMath {
171 
172   /**
173   * @dev Multiplies two numbers, throws on overflow.
174   */
175   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
176     if (a == 0) {
177       return 0;
178     }
179     c = a * b;
180     assert(c / a == b);
181     return c;
182   }
183 
184   /**
185   * @dev Integer division of two numbers, truncating the quotient.
186   */
187   function div(uint256 a, uint256 b) internal pure returns (uint256) {
188     // assert(b > 0); // Solidity automatically throws when dividing by 0
189     // uint256 c = a / b;
190     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
191     return a / b;
192   }
193 
194   /**
195   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
196   */
197   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
198     assert(b <= a);
199     return a - b;
200   }
201 
202   /**
203   * @dev Adds two numbers, throws on overflow.
204   */
205   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
206     c = a + b;
207     assert(c >= a);
208     return c;
209   }
210 }
211 
212 
213 library Roles {
214   struct Role {
215     mapping (address => bool) bearer;
216   }
217 
218   /**
219    * @dev give an address access to this role
220    */
221   function add(Role storage role, address addr)
222     internal
223   {
224     role.bearer[addr] = true;
225   }
226 
227   /**
228    * @dev remove an address' access to this role
229    */
230   function remove(Role storage role, address addr)
231     internal
232   {
233     role.bearer[addr] = false;
234   }
235 
236   /**
237    * @dev check if an address has this role
238    * // reverts
239    */
240   function check(Role storage role, address addr)
241     view
242     internal
243   {
244     require(has(role, addr));
245   }
246 
247   /**
248    * @dev check if an address has this role
249    * @return bool
250    */
251   function has(Role storage role, address addr)
252     view
253     internal
254     returns (bool)
255   {
256     return role.bearer[addr];
257   }
258 }
259 
260 contract RBAC {
261   using Roles for Roles.Role;
262 
263   mapping (string => Roles.Role) private roles;
264 
265   event RoleAdded(address addr, string roleName);
266   event RoleRemoved(address addr, string roleName);
267 
268   /**
269    * @dev reverts if addr does not have role
270    * @param addr address
271    * @param roleName the name of the role
272    * // reverts
273    */
274   function checkRole(address addr, string roleName)
275     view
276     public
277   {
278     roles[roleName].check(addr);
279   }
280 
281   /**
282    * @dev determine if addr has role
283    * @param addr address
284    * @param roleName the name of the role
285    * @return bool
286    */
287   function hasRole(address addr, string roleName)
288     view
289     public
290     returns (bool)
291   {
292     return roles[roleName].has(addr);
293   }
294 
295   /**
296    * @dev add a role to an address
297    * @param addr address
298    * @param roleName the name of the role
299    */
300   function addRole(address addr, string roleName)
301     internal
302   {
303     roles[roleName].add(addr);
304     emit RoleAdded(addr, roleName);
305   }
306 
307   /**
308    * @dev remove a role from an address
309    * @param addr address
310    * @param roleName the name of the role
311    */
312   function removeRole(address addr, string roleName)
313     internal
314   {
315     roles[roleName].remove(addr);
316     emit RoleRemoved(addr, roleName);
317   }
318 
319   /**
320    * @dev modifier to scope access to a single role (uses msg.sender as addr)
321    * @param roleName the name of the role
322    * // reverts
323    */
324   modifier onlyRole(string roleName)
325   {
326     checkRole(msg.sender, roleName);
327     _;
328   }
329 }
330 
331 contract MultiOwnable {
332     using SafeMath for uint256;
333 
334     mapping(address => bool) public isOwner;
335     address[] public ownerHistory;
336     uint256 public ownerCount;
337 
338 
339     event OwnerAddedEvent(address indexed _newOwner);
340     event OwnerRemovedEvent(address indexed _oldOwner);
341 
342     constructor() public
343     {
344         address owner = msg.sender;
345         setOwner(owner);
346     }
347 
348     modifier onlyOwner() {
349         require(isOwner[msg.sender]);
350         _;
351     }
352 
353     function ownerHistoryCount() public view returns (uint) {
354         return ownerHistory.length;
355     }
356 
357     function addOwner(address owner) onlyOwner public {
358         require(owner != address(0));
359         require(!isOwner[owner]);
360         setOwner(owner);
361         emit OwnerAddedEvent(owner);
362     }
363 
364     function removeOwner(address owner) onlyOwner public {
365         require(ownerCount > 1);
366         require(isOwner[owner]);
367         isOwner[owner] = false;
368         ownerCount = ownerCount.sub(1);
369         emit OwnerRemovedEvent(owner);
370     }
371 
372     function setOwner(address owner) internal {
373         ownerHistory.push(owner);
374         isOwner[owner] = true;
375         ownerCount = ownerCount.add(1);
376     }
377 }
378 
379 contract AccessControl is RBAC, MultiOwnable {
380     event AddedToWhitelist(address addr);
381     event RemovedFromWhitelist(address addr);
382     event AdminAddressAdded(address addr);
383     event AdminAddressRemoved(address addr);
384 
385     string public constant ROLE_WHITELISTED = "whitelist";
386     string public constant ROLE_ADMIN = "admin";
387 
388 
389     constructor() public
390     {
391         addToAdminlist(msg.sender);
392         addToWhitelist(msg.sender);
393     }
394 
395     /**
396      * @dev Throws if called by any account that's not whitelisted.
397      */
398     modifier onlyAdmin()
399     {
400         checkRole(msg.sender, ROLE_ADMIN);
401         _;
402     }
403 
404     modifier onlyFromWhitelisted() {
405         checkRole(msg.sender, ROLE_WHITELISTED);
406         _;
407     }
408 
409     modifier onlyWhitelisted(address first)
410     {
411         checkRole(msg.sender, ROLE_WHITELISTED);
412         checkRole(first, ROLE_WHITELISTED);
413         _;
414     }
415 
416     modifier onlyWhitelistedParties(address first, address second)
417     {
418         checkRole(msg.sender, ROLE_WHITELISTED);
419         checkRole(first, ROLE_WHITELISTED);
420         checkRole(second, ROLE_WHITELISTED);
421         _;
422     }
423 
424     /**
425     *
426     * WHITELIST FUNCTIONS
427     *
428     */
429 
430     /**
431      * @dev add an address to the whitelist
432      * @param addr address
433      * @return true if the address was added to the whitelist, false if the address was already in the whitelist
434      */
435     function addToWhitelist(address addr)
436     onlyAdmin
437     public
438     {
439         addRole(addr, ROLE_WHITELISTED);
440         emit AddedToWhitelist(addr);
441     }
442 
443     /**
444      * @dev add addresses to the whitelist
445      * @param addrs addresses
446      * @return true if at least one address was added to the whitelist,
447      * false if all addresses were already in the whitelist
448      */
449     function addManyToWhitelist(address[] addrs)
450     onlyAdmin
451     public
452     {
453         for (uint256 i = 0; i < addrs.length; i++) {
454             addToWhitelist(addrs[i]);
455         }
456     }
457 
458     /**
459      * @dev remove an address from the whitelist
460      * @param addr address
461      * @return true if the address was removed from the whitelist,
462      * false if the address wasn't in the whitelist in the first place
463      */
464     function removeFromWhitelist(address addr)
465     onlyAdmin
466     public
467     {
468         removeRole(addr, ROLE_WHITELISTED);
469         emit RemovedFromWhitelist(addr);
470     }
471 
472     /**
473      * @dev remove addresses from the whitelist
474      * @param addrs addresses
475      * @return true if at least one address was removed from the whitelist,
476      * false if all addresses weren't in the whitelist in the first place
477      */
478     function removeManyFromWhitelist(address[] addrs)
479     onlyAdmin
480     public
481     {
482         for (uint256 i = 0; i < addrs.length; i++) {
483             removeFromWhitelist(addrs[i]);
484         }
485     }
486 
487     /**
488      * @dev getter to determine if address is in whitelist
489      */
490     function whitelist(address addr)
491     public
492     view
493     returns (bool)
494     {
495         return hasRole(addr, ROLE_WHITELISTED);
496     }
497 
498     /**
499     *
500     * ADMIN LIST FUNCTIONS
501     *
502     */
503 
504     /**
505      * @dev add an address to the adminlist
506      * @param addr address
507      * @return true if the address was added to the adminlist, false if the address was already in the adminlist
508      */
509     function addToAdminlist(address addr)
510     onlyOwner
511     public
512     {
513         addRole(addr, ROLE_ADMIN);
514         emit AdminAddressAdded(addr);
515     }
516 
517     function removeFromAdminlist(address addr)
518     onlyOwner
519     public
520     {
521         removeRole(addr, ROLE_ADMIN);
522         emit AdminAddressRemoved(addr);
523     }
524 
525     /**
526      * @dev getter to determine if address is in adminlist
527      */
528     function admin(address addr)
529     public
530     view
531     returns (bool)
532     {
533         return hasRole(addr, ROLE_ADMIN);
534     }
535 
536 }
537 
538 
539 contract AKJToken is BurnableToken, StandardToken, AccessControl
540 {
541   string public constant name = "AKJ"; // solium-disable-line uppercase
542   string public constant symbol = "AKJ"; // solium-disable-line uppercase
543   uint8 public constant decimals = 18; // solium-disable-line uppercase
544 
545   uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals)); // Creates 1.000.000.000 with a given amount of "decimals"
546 
547   /**
548    * @dev Constructor that gives msg.sender all of existing tokens.
549    */
550   constructor() public {
551     totalSupply_ = INITIAL_SUPPLY;
552     balances[msg.sender] = INITIAL_SUPPLY;
553     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
554   }
555   function transfer(address _to, uint256 _value) public onlyWhitelisted(_to) returns (bool) {
556     return super.transfer(_to, _value);
557   }
558 
559   function transferFrom(address _from, address _to, uint256 _value) public onlyWhitelistedParties(_from, _to) returns (bool) {
560     return super.transferFrom(_from, _to, _value);
561   }
562 
563   function approve(address _spender, uint256 _value) public onlyWhitelisted(_spender) returns (bool) {
564     return super.approve(_spender, _value);
565   }
566 
567 
568 
569 
570 }