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
326 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
327 
328 /**
329  * @title Ownable
330  * @dev The Ownable contract has an owner address, and provides basic authorization control
331  * functions, this simplifies the implementation of "user permissions".
332  */
333 contract Ownable {
334   address public owner;
335 
336 
337   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
338 
339 
340   /**
341    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
342    * account.
343    */
344   function Ownable() public {
345     owner = msg.sender;
346   }
347 
348 
349   /**
350    * @dev Throws if called by any account other than the owner.
351    */
352   modifier onlyOwner() {
353     require(msg.sender == owner);
354     _;
355   }
356 
357 
358   /**
359    * @dev Allows the current owner to transfer control of the contract to a newOwner.
360    * @param newOwner The address to transfer ownership to.
361    */
362   function transferOwnership(address newOwner) public onlyOwner {
363     require(newOwner != address(0));
364     OwnershipTransferred(owner, newOwner);
365     owner = newOwner;
366   }
367 
368 }
369 
370 // File: zeppelin-solidity/contracts/token/ERC20.sol
371 
372 /**
373  * @title ERC20 interface
374  * @dev see https://github.com/ethereum/EIPs/issues/20
375  */
376 contract ERC20 is ERC20Basic {
377   function allowance(address owner, address spender) public view returns (uint256);
378   function transferFrom(address from, address to, uint256 value) public returns (bool);
379   function approve(address spender, uint256 value) public returns (bool);
380   event Approval(address indexed owner, address indexed spender, uint256 value);
381 }
382 
383 // File: zeppelin-solidity/contracts/token/StandardToken.sol
384 
385 /**
386  * @title Standard ERC20 token
387  *
388  * @dev Implementation of the basic standard token.
389  * @dev https://github.com/ethereum/EIPs/issues/20
390  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
391  */
392 contract StandardToken is ERC20, BasicToken {
393 
394   mapping (address => mapping (address => uint256)) internal allowed;
395 
396 
397   /**
398    * @dev Transfer tokens from one address to another
399    * @param _from address The address which you want to send tokens from
400    * @param _to address The address which you want to transfer to
401    * @param _value uint256 the amount of tokens to be transferred
402    */
403   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
404     require(_to != address(0));
405     require(_value <= balances[_from]);
406     require(_value <= allowed[_from][msg.sender]);
407 
408     balances[_from] = balances[_from].sub(_value);
409     balances[_to] = balances[_to].add(_value);
410     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
411     Transfer(_from, _to, _value);
412     return true;
413   }
414 
415   /**
416    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
417    *
418    * Beware that changing an allowance with this method brings the risk that someone may use both the old
419    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
420    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
421    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
422    * @param _spender The address which will spend the funds.
423    * @param _value The amount of tokens to be spent.
424    */
425   function approve(address _spender, uint256 _value) public returns (bool) {
426     allowed[msg.sender][_spender] = _value;
427     Approval(msg.sender, _spender, _value);
428     return true;
429   }
430 
431   /**
432    * @dev Function to check the amount of tokens that an owner allowed to a spender.
433    * @param _owner address The address which owns the funds.
434    * @param _spender address The address which will spend the funds.
435    * @return A uint256 specifying the amount of tokens still available for the spender.
436    */
437   function allowance(address _owner, address _spender) public view returns (uint256) {
438     return allowed[_owner][_spender];
439   }
440 
441   /**
442    * @dev Increase the amount of tokens that an owner allowed to a spender.
443    *
444    * approve should be called when allowed[_spender] == 0. To increment
445    * allowed value is better to use this function to avoid 2 calls (and wait until
446    * the first transaction is mined)
447    * From MonolithDAO Token.sol
448    * @param _spender The address which will spend the funds.
449    * @param _addedValue The amount of tokens to increase the allowance by.
450    */
451   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
452     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
453     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
454     return true;
455   }
456 
457   /**
458    * @dev Decrease the amount of tokens that an owner allowed to a spender.
459    *
460    * approve should be called when allowed[_spender] == 0. To decrement
461    * allowed value is better to use this function to avoid 2 calls (and wait until
462    * the first transaction is mined)
463    * From MonolithDAO Token.sol
464    * @param _spender The address which will spend the funds.
465    * @param _subtractedValue The amount of tokens to decrease the allowance by.
466    */
467   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
468     uint oldValue = allowed[msg.sender][_spender];
469     if (_subtractedValue > oldValue) {
470       allowed[msg.sender][_spender] = 0;
471     } else {
472       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
473     }
474     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
475     return true;
476   }
477 
478 }
479 
480 // File: zeppelin-solidity/contracts/token/MintableToken.sol
481 
482 /**
483  * @title Mintable token
484  * @dev Simple ERC20 Token example, with mintable token creation
485  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
486  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
487  */
488 
489 contract MintableToken is StandardToken, Ownable {
490   event Mint(address indexed to, uint256 amount);
491   event MintFinished();
492 
493   bool public mintingFinished = false;
494 
495 
496   modifier canMint() {
497     require(!mintingFinished);
498     _;
499   }
500 
501   /**
502    * @dev Function to mint tokens
503    * @param _to The address that will receive the minted tokens.
504    * @param _amount The amount of tokens to mint.
505    * @return A boolean that indicates if the operation was successful.
506    */
507   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
508     totalSupply = totalSupply.add(_amount);
509     balances[_to] = balances[_to].add(_amount);
510     Mint(_to, _amount);
511     Transfer(address(0), _to, _amount);
512     return true;
513   }
514 
515   /**
516    * @dev Function to stop minting new tokens.
517    * @return True if the operation was successful.
518    */
519   function finishMinting() onlyOwner canMint public returns (bool) {
520     mintingFinished = true;
521     MintFinished();
522     return true;
523   }
524 }
525 
526 // File: contracts/Purpose.sol
527 
528 contract Purpose is StandardToken, BurnableToken, MintableToken, RBAC {
529   string public constant name = "Purpose";
530   string public constant symbol = "PRPS";
531   uint8 public constant decimals = 18;
532   string constant public ROLE_TRANSFER = "transfer";
533 
534   function Purpose() public {
535     totalSupply = 0;
536   }
537 
538   // used by hodler contract to transfer users tokens to it
539   function hodlerTransfer(address _from, uint256 _value) external onlyRole(ROLE_TRANSFER) returns (bool) {
540     require(_from != address(0));
541     require(_value > 0);
542 
543     // hodler
544     address _hodler = msg.sender;
545 
546     // update state
547     balances[_from] = balances[_from].sub(_value);
548     balances[_hodler] = balances[_hodler].add(_value);
549 
550     // logs
551     Transfer(_from, _hodler, _value);
552 
553     return true;
554   }
555 }