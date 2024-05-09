1 pragma solidity ^0.4.24;
2 
3 // File: node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol
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
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: node_modules/openzeppelin-solidity/contracts/access/rbac/Roles.sol
68 
69 /**
70  * @title Roles
71  * @author Francisco Giordano (@frangio)
72  * @dev Library for managing addresses assigned to a Role.
73  * See RBAC.sol for example usage.
74  */
75 library Roles {
76   struct Role {
77     mapping (address => bool) bearer;
78   }
79 
80   /**
81    * @dev give an address access to this role
82    */
83   function add(Role storage _role, address _addr)
84     internal
85   {
86     _role.bearer[_addr] = true;
87   }
88 
89   /**
90    * @dev remove an address' access to this role
91    */
92   function remove(Role storage _role, address _addr)
93     internal
94   {
95     _role.bearer[_addr] = false;
96   }
97 
98   /**
99    * @dev check if an address has this role
100    * // reverts
101    */
102   function check(Role storage _role, address _addr)
103     internal
104     view
105   {
106     require(has(_role, _addr));
107   }
108 
109   /**
110    * @dev check if an address has this role
111    * @return bool
112    */
113   function has(Role storage _role, address _addr)
114     internal
115     view
116     returns (bool)
117   {
118     return _role.bearer[_addr];
119   }
120 }
121 
122 // File: node_modules/openzeppelin-solidity/contracts/access/rbac/RBAC.sol
123 
124 /**
125  * @title RBAC (Role-Based Access Control)
126  * @author Matt Condon (@Shrugs)
127  * @dev Stores and provides setters and getters for roles and addresses.
128  * Supports unlimited numbers of roles and addresses.
129  * See //contracts/mocks/RBACMock.sol for an example of usage.
130  * This RBAC method uses strings to key roles. It may be beneficial
131  * for you to write your own implementation of this interface using Enums or similar.
132  */
133 contract RBAC {
134   using Roles for Roles.Role;
135 
136   mapping (string => Roles.Role) private roles;
137 
138   event RoleAdded(address indexed operator, string role);
139   event RoleRemoved(address indexed operator, string role);
140 
141   /**
142    * @dev reverts if addr does not have role
143    * @param _operator address
144    * @param _role the name of the role
145    * // reverts
146    */
147   function checkRole(address _operator, string _role)
148     public
149     view
150   {
151     roles[_role].check(_operator);
152   }
153 
154   /**
155    * @dev determine if addr has role
156    * @param _operator address
157    * @param _role the name of the role
158    * @return bool
159    */
160   function hasRole(address _operator, string _role)
161     public
162     view
163     returns (bool)
164   {
165     return roles[_role].has(_operator);
166   }
167 
168   /**
169    * @dev add a role to an address
170    * @param _operator address
171    * @param _role the name of the role
172    */
173   function addRole(address _operator, string _role)
174     internal
175   {
176     roles[_role].add(_operator);
177     emit RoleAdded(_operator, _role);
178   }
179 
180   /**
181    * @dev remove a role from an address
182    * @param _operator address
183    * @param _role the name of the role
184    */
185   function removeRole(address _operator, string _role)
186     internal
187   {
188     roles[_role].remove(_operator);
189     emit RoleRemoved(_operator, _role);
190   }
191 
192   /**
193    * @dev modifier to scope access to a single role (uses msg.sender as addr)
194    * @param _role the name of the role
195    * // reverts
196    */
197   modifier onlyRole(string _role)
198   {
199     checkRole(msg.sender, _role);
200     _;
201   }
202 
203   /**
204    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
205    * @param _roles the names of the roles to scope access to
206    * // reverts
207    *
208    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
209    *  see: https://github.com/ethereum/solidity/issues/2467
210    */
211   // modifier onlyRoles(string[] _roles) {
212   //     bool hasAnyRole = false;
213   //     for (uint8 i = 0; i < _roles.length; i++) {
214   //         if (hasRole(msg.sender, _roles[i])) {
215   //             hasAnyRole = true;
216   //             break;
217   //         }
218   //     }
219 
220   //     require(hasAnyRole);
221 
222   //     _;
223   // }
224 }
225 
226 // File: contracts/utils/SafeMath.sol
227 
228 /**
229  * @title SafeMath v0.1.9
230  * @dev Math operations with safety checks that throw on error
231  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
232  * - added sqrt
233  * - added sq
234  * - added pwr
235  * - changed asserts to requires with error log outputs
236  * - removed div, its useless
237  */
238 library SafeMath {
239 
240   /**
241   * @dev Multiplies two numbers, throws on overflow.
242   */
243   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
244     if (a == 0) {
245       return 0;
246     }
247     c = a * b;
248     require(c / a == b, "SafeMath mul failed");
249     return c;
250   }
251 
252   /**
253   * @dev Integer division of two numbers, truncating the quotient.
254   */
255   function div(uint256 a, uint256 b) internal pure returns (uint256) {
256     // assert(b > 0); // Solidity automatically throws when dividing by 0
257     uint256 c = a / b;
258     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
259     return c;
260   }
261 
262   /**
263   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
264   */
265   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
266     require(b <= a, "SafeMath sub failed");
267     return a - b;
268   }
269 
270   /**
271   * @dev Adds two numbers, throws on overflow.
272   */
273   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
274     c = a + b;
275     require(c >= a, "SafeMath add failed");
276     return c;
277   }
278 
279   /**
280    * @dev gives square root of given x.
281    */
282   function sqrt(uint256 x) internal pure returns (uint256 y) {
283     uint256 z = ((add(x,1)) / 2);
284     y = x;
285     while (z < y)
286     {
287       y = z;
288       z = ((add((x / z),z)) / 2);
289     }
290   }
291 
292   /**
293    * @dev gives square. multiplies x by x
294    */
295   function sq(uint256 x) internal pure returns (uint256) {
296     return (mul(x,x));
297   }
298 
299   /**
300    * @dev x to the power of y
301    */
302   function pwr(uint256 x, uint256 y) internal pure returns (uint256) {
303     if (x==0)
304       return (0);
305     else if (y==0)
306       return (1);
307     else
308     {
309       uint256 z = x;
310       for (uint256 i=1; i < y; i++)
311         z = mul(z,x);
312       return (z);
313     }
314   }
315 }
316 
317 // File: contracts/utils/ERC20Interface.sol
318 
319 /**
320  * @title ERC20
321  */
322 interface ERC20 {
323   function totalSupply() external view returns (uint256);
324   function balanceOf(address who) external view returns (uint256);
325   function transfer(address to, uint256 value) external returns (bool);
326   function allowance(address owner, address spender) external view returns (uint256);
327   function transferFrom(address from, address to, uint256 value) external returns (bool);
328   function approve(address spender, uint256 value) external returns (bool);
329 }
330 
331 // File: contracts/CryptoHeroRocket.sol
332 
333 contract CryptoHeroRocket is Ownable, RBAC {
334   using SafeMath for uint256;
335 
336   event Transfer(address indexed from, address indexed to, uint256 amount);
337   event Approval(address indexed owner, address indexed spender, uint256 amount);
338   event Mint(address indexed to, uint256 amount);
339   event Burn(address indexed from, uint256 amount);
340 
341   /**
342    * A constant role name for indicating minters & burners.
343    */
344   string internal constant ROLE_MINTER = "minter";
345   string internal constant ROLE_BURNER = "burner";
346 
347   string public name = 'Crypto Hero Rocket';
348   string public symbol = 'CH 🚀';
349   uint8 public decimals; //=0 by default
350 
351   uint256 public totalSupply;
352   mapping(address => uint256) internal balances;
353   mapping (address => mapping (address => uint256)) internal allowed;
354 
355   constructor() public {
356     addRole(msg.sender, ROLE_MINTER);
357     addRole(msg.sender, ROLE_BURNER);
358   }
359 
360   /**
361    * @dev Disallows direct send by setting a default function without the `payable` flag.
362    */
363   function() external {}
364 
365 
366   /**
367  * @dev Transfer token for a specified address
368  * @param _to The address to transfer to.
369  * @param _value The amount to be transferred.
370  */
371   function transfer(address _to, uint256 _value) public returns (bool) {
372     //not needed, due to SafeMath.sub
373     //require(_value <= balanceOf[msg.sender]);
374     require(_to != address(0));
375 
376     balances[msg.sender] = balances[msg.sender].sub(_value);
377     balances[_to] = balances[_to].add(_value);
378     emit Transfer(msg.sender, _to, _value);
379     return true;
380   }
381 
382   /**
383   * @dev Gets the balance of the specified address.
384   * @param _owner The address to query the the balance of.
385   * @return An uint256 representing the amount owned by the passed address.
386   */
387   function balanceOf(address _owner) public view returns (uint256) {
388     return balances[_owner];
389   }
390 
391   /**
392    * @dev Function to check the amount of tokens that an owner allowed to a spender.
393    * @param _owner address The address which owns the funds.
394    * @param _spender address The address which will spend the funds.
395    * @return A uint256 specifying the amount of tokens still available for the spender.
396    */
397   function allowance(address _owner, address _spender) public view returns (uint256) {
398     return allowed[_owner][_spender];
399   }
400 
401   /**
402    * @dev Transfer tokens from one address to another
403    * @param _from address The address which you want to send tokens from
404    * @param _to address The address which you want to transfer to
405    * @param _value uint256 the amount of tokens to be transferred
406    */
407   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
408     //not needed, due to SafeMath.sub
409 //    require(_value <= balanceOf[_from]);
410 //    require(_value <= allowance[_from][msg.sender]);
411     require(_to != address(0));
412 
413     balances[_from] = balances[_from].sub(_value);
414     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
415     balances[_to] = balances[_to].add(_value);
416     emit Transfer(_from, _to, _value);
417     return true;
418   }
419 
420   /**
421    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
422    * Beware that changing an allowance with this method brings the risk that someone may use both the old
423    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
424    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
425    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
426    * @param _spender The address which will spend the funds.
427    * @param _value The amount of tokens to be spent.
428    */
429   function approve(address _spender, uint256 _value) public returns (bool) {
430     allowed[msg.sender][_spender] = _value;
431     emit Approval(msg.sender, _spender, _value);
432     return true;
433   }
434 
435   /**
436    * @dev Increase the amount of tokens that an owner allowed to a spender.
437    * approve should be called when allowed[_spender] == 0. To increment
438    * allowed value is better to use this function to avoid 2 calls (and wait until
439    * the first transaction is mined)
440    * From MonolithDAO Token.sol
441    * @param _spender The address which will spend the funds.
442    * @param _addedValue The amount of tokens to increase the allowance by.
443    */
444   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
445     allowed[msg.sender][_spender] = (
446     allowed[msg.sender][_spender].add(_addedValue));
447     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
448     return true;
449   }
450 
451   /**
452    * @dev Decrease the amount of tokens that an owner allowed to a spender.
453    * approve should be called when allowed[_spender] == 0. To decrement
454    * allowed value is better to use this function to avoid 2 calls (and wait until
455    * the first transaction is mined)
456    * From MonolithDAO Token.sol
457    * @param _spender The address which will spend the funds.
458    * @param _subtractedValue The amount of tokens to decrease the allowance by.
459    */
460   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
461     uint256 oldValue = allowed[msg.sender][_spender];
462     if (_subtractedValue >= oldValue) {
463       allowed[msg.sender][_spender] = 0;
464     } else {
465       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
466     }
467     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
468     return true;
469   }
470 
471 
472 
473   /**
474    * @dev add a minter role to an address
475    * @param _minter address
476    */
477   function addMinter(address _minter) external onlyOwner {
478     addRole(_minter, ROLE_MINTER);
479   }
480 
481   function addBurner(address _burner) external onlyOwner {
482     addRole(_burner, ROLE_BURNER);
483   }
484 
485   /**
486    * @dev remove a minter role from an address
487    * @param _minter address
488    */
489   function removeMinter(address _minter) external onlyOwner {
490     removeRole(_minter, ROLE_MINTER);
491   }
492 
493   function removeBurner(address _burner) external onlyOwner {
494     removeRole(_burner, ROLE_BURNER);
495   }
496 
497 
498   /**
499    * @dev Function to mint tokens
500    * @param _to The address that will receive the minted tokens.
501    * @param _amount The amount of tokens to mint.
502    * @return A boolean that indicates if the operation was successful.
503    */
504   function mint(address _to, uint256 _amount) external onlyRole(ROLE_MINTER) returns (bool) {
505     totalSupply = totalSupply.add(_amount);
506     balances[_to] = balances[_to].add(_amount);
507     emit Mint(_to, _amount);
508     emit Transfer(address(0), _to, _amount);
509     return true;
510   }
511 
512   /**
513    * @dev Burns a specific amount of tokens.
514    * @param _from The address from which will tokens burn.
515    * @param _amount The amount of token to be burned.
516    */
517   function burn(address _from, uint256 _amount) external onlyRole(ROLE_BURNER) returns (bool) {
518     //not needed, due to SafeMath.sub
519 //    require(_amount <= balanceOf[_from]);
520 
521     balances[_from] = balances[_from].sub(_amount);
522     totalSupply = totalSupply.sub(_amount);
523     emit Burn(_from, _amount);
524     emit Transfer(_from, address(0), _amount);
525     return true;
526   }
527 
528   /// @notice This method can be used by the owner to extract mistakenly
529   ///  sent tokens to this contract.
530   /// @param _token The address of the token contract that you want to recover
531   ///  set to 0 in case you want to extract ether.
532 
533   function claimTokens(address _token) external onlyOwner {
534     if (_token == 0x0) {
535       owner.transfer(address(this).balance);
536       return;
537     }
538 
539     ERC20 token = ERC20(_token);
540     uint balance = token.balanceOf(this);
541     token.transfer(owner, balance);
542   }
543 
544 }