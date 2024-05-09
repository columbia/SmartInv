1 pragma solidity ^0.4.13;
2 
3 contract RBAC {
4   using Roles for Roles.Role;
5 
6   mapping (string => Roles.Role) private roles;
7 
8   event RoleAdded(address indexed operator, string role);
9   event RoleRemoved(address indexed operator, string role);
10 
11   /**
12    * @dev reverts if addr does not have role
13    * @param _operator address
14    * @param _role the name of the role
15    * // reverts
16    */
17   function checkRole(address _operator, string _role)
18     public
19     view
20   {
21     roles[_role].check(_operator);
22   }
23 
24   /**
25    * @dev determine if addr has role
26    * @param _operator address
27    * @param _role the name of the role
28    * @return bool
29    */
30   function hasRole(address _operator, string _role)
31     public
32     view
33     returns (bool)
34   {
35     return roles[_role].has(_operator);
36   }
37 
38   /**
39    * @dev add a role to an address
40    * @param _operator address
41    * @param _role the name of the role
42    */
43   function addRole(address _operator, string _role)
44     internal
45   {
46     roles[_role].add(_operator);
47     emit RoleAdded(_operator, _role);
48   }
49 
50   /**
51    * @dev remove a role from an address
52    * @param _operator address
53    * @param _role the name of the role
54    */
55   function removeRole(address _operator, string _role)
56     internal
57   {
58     roles[_role].remove(_operator);
59     emit RoleRemoved(_operator, _role);
60   }
61 
62   /**
63    * @dev modifier to scope access to a single role (uses msg.sender as addr)
64    * @param _role the name of the role
65    * // reverts
66    */
67   modifier onlyRole(string _role)
68   {
69     checkRole(msg.sender, _role);
70     _;
71   }
72 
73   /**
74    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
75    * @param _roles the names of the roles to scope access to
76    * // reverts
77    *
78    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
79    *  see: https://github.com/ethereum/solidity/issues/2467
80    */
81   // modifier onlyRoles(string[] _roles) {
82   //     bool hasAnyRole = false;
83   //     for (uint8 i = 0; i < _roles.length; i++) {
84   //         if (hasRole(msg.sender, _roles[i])) {
85   //             hasAnyRole = true;
86   //             break;
87   //         }
88   //     }
89 
90   //     require(hasAnyRole);
91 
92   //     _;
93   // }
94 }
95 
96 library Roles {
97   struct Role {
98     mapping (address => bool) bearer;
99   }
100 
101   /**
102    * @dev give an address access to this role
103    */
104   function add(Role storage _role, address _addr)
105     internal
106   {
107     _role.bearer[_addr] = true;
108   }
109 
110   /**
111    * @dev remove an address' access to this role
112    */
113   function remove(Role storage _role, address _addr)
114     internal
115   {
116     _role.bearer[_addr] = false;
117   }
118 
119   /**
120    * @dev check if an address has this role
121    * // reverts
122    */
123   function check(Role storage _role, address _addr)
124     internal
125     view
126   {
127     require(has(_role, _addr));
128   }
129 
130   /**
131    * @dev check if an address has this role
132    * @return bool
133    */
134   function has(Role storage _role, address _addr)
135     internal
136     view
137     returns (bool)
138   {
139     return _role.bearer[_addr];
140   }
141 }
142 
143 library SafeMath {
144 
145   /**
146   * @dev Multiplies two numbers, throws on overflow.
147   */
148   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
149     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
150     // benefit is lost if 'b' is also tested.
151     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
152     if (_a == 0) {
153       return 0;
154     }
155 
156     c = _a * _b;
157     assert(c / _a == _b);
158     return c;
159   }
160 
161   /**
162   * @dev Integer division of two numbers, truncating the quotient.
163   */
164   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
165     // assert(_b > 0); // Solidity automatically throws when dividing by 0
166     // uint256 c = _a / _b;
167     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
168     return _a / _b;
169   }
170 
171   /**
172   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
173   */
174   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
175     assert(_b <= _a);
176     return _a - _b;
177   }
178 
179   /**
180   * @dev Adds two numbers, throws on overflow.
181   */
182   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
183     c = _a + _b;
184     assert(c >= _a);
185     return c;
186   }
187 }
188 
189 contract Ownable {
190   address public owner;
191 
192 
193   event OwnershipRenounced(address indexed previousOwner);
194   event OwnershipTransferred(
195     address indexed previousOwner,
196     address indexed newOwner
197   );
198 
199 
200   /**
201    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
202    * account.
203    */
204   constructor() public {
205     owner = msg.sender;
206   }
207 
208   /**
209    * @dev Throws if called by any account other than the owner.
210    */
211   modifier onlyOwner() {
212     require(msg.sender == owner);
213     _;
214   }
215 
216   /**
217    * @dev Allows the current owner to relinquish control of the contract.
218    * @notice Renouncing to ownership will leave the contract without an owner.
219    * It will not be possible to call the functions with the `onlyOwner`
220    * modifier anymore.
221    */
222   function renounceOwnership() public onlyOwner {
223     emit OwnershipRenounced(owner);
224     owner = address(0);
225   }
226 
227   /**
228    * @dev Allows the current owner to transfer control of the contract to a newOwner.
229    * @param _newOwner The address to transfer ownership to.
230    */
231   function transferOwnership(address _newOwner) public onlyOwner {
232     _transferOwnership(_newOwner);
233   }
234 
235   /**
236    * @dev Transfers control of the contract to a newOwner.
237    * @param _newOwner The address to transfer ownership to.
238    */
239   function _transferOwnership(address _newOwner) internal {
240     require(_newOwner != address(0));
241     emit OwnershipTransferred(owner, _newOwner);
242     owner = _newOwner;
243   }
244 }
245 
246 contract ERC20Basic {
247   function totalSupply() public view returns (uint256);
248   function balanceOf(address _who) public view returns (uint256);
249   function transfer(address _to, uint256 _value) public returns (bool);
250   event Transfer(address indexed from, address indexed to, uint256 value);
251 }
252 
253 contract BasicToken is ERC20Basic {
254   using SafeMath for uint256;
255 
256   mapping(address => uint256) internal balances;
257 
258   uint256 internal totalSupply_;
259 
260   /**
261   * @dev Total number of tokens in existence
262   */
263   function totalSupply() public view returns (uint256) {
264     return totalSupply_;
265   }
266 
267   /**
268   * @dev Transfer token for a specified address
269   * @param _to The address to transfer to.
270   * @param _value The amount to be transferred.
271   */
272   function transfer(address _to, uint256 _value) public returns (bool) {
273     require(_value <= balances[msg.sender]);
274     require(_to != address(0));
275 
276     balances[msg.sender] = balances[msg.sender].sub(_value);
277     balances[_to] = balances[_to].add(_value);
278     emit Transfer(msg.sender, _to, _value);
279     return true;
280   }
281 
282   /**
283   * @dev Gets the balance of the specified address.
284   * @param _owner The address to query the the balance of.
285   * @return An uint256 representing the amount owned by the passed address.
286   */
287   function balanceOf(address _owner) public view returns (uint256) {
288     return balances[_owner];
289   }
290 
291 }
292 
293 contract ERC20 is ERC20Basic {
294   function allowance(address _owner, address _spender)
295     public view returns (uint256);
296 
297   function transferFrom(address _from, address _to, uint256 _value)
298     public returns (bool);
299 
300   function approve(address _spender, uint256 _value) public returns (bool);
301   event Approval(
302     address indexed owner,
303     address indexed spender,
304     uint256 value
305   );
306 }
307 
308 contract StandardToken is ERC20, BasicToken {
309 
310   mapping (address => mapping (address => uint256)) internal allowed;
311 
312 
313   /**
314    * @dev Transfer tokens from one address to another
315    * @param _from address The address which you want to send tokens from
316    * @param _to address The address which you want to transfer to
317    * @param _value uint256 the amount of tokens to be transferred
318    */
319   function transferFrom(
320     address _from,
321     address _to,
322     uint256 _value
323   )
324     public
325     returns (bool)
326   {
327     require(_value <= balances[_from]);
328     require(_value <= allowed[_from][msg.sender]);
329     require(_to != address(0));
330 
331     balances[_from] = balances[_from].sub(_value);
332     balances[_to] = balances[_to].add(_value);
333     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
334     emit Transfer(_from, _to, _value);
335     return true;
336   }
337 
338   /**
339    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
340    * Beware that changing an allowance with this method brings the risk that someone may use both the old
341    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
342    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
343    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
344    * @param _spender The address which will spend the funds.
345    * @param _value The amount of tokens to be spent.
346    */
347   function approve(address _spender, uint256 _value) public returns (bool) {
348     allowed[msg.sender][_spender] = _value;
349     emit Approval(msg.sender, _spender, _value);
350     return true;
351   }
352 
353   /**
354    * @dev Function to check the amount of tokens that an owner allowed to a spender.
355    * @param _owner address The address which owns the funds.
356    * @param _spender address The address which will spend the funds.
357    * @return A uint256 specifying the amount of tokens still available for the spender.
358    */
359   function allowance(
360     address _owner,
361     address _spender
362    )
363     public
364     view
365     returns (uint256)
366   {
367     return allowed[_owner][_spender];
368   }
369 
370   /**
371    * @dev Increase the amount of tokens that an owner allowed to a spender.
372    * approve should be called when allowed[_spender] == 0. To increment
373    * allowed value is better to use this function to avoid 2 calls (and wait until
374    * the first transaction is mined)
375    * From MonolithDAO Token.sol
376    * @param _spender The address which will spend the funds.
377    * @param _addedValue The amount of tokens to increase the allowance by.
378    */
379   function increaseApproval(
380     address _spender,
381     uint256 _addedValue
382   )
383     public
384     returns (bool)
385   {
386     allowed[msg.sender][_spender] = (
387       allowed[msg.sender][_spender].add(_addedValue));
388     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
389     return true;
390   }
391 
392   /**
393    * @dev Decrease the amount of tokens that an owner allowed to a spender.
394    * approve should be called when allowed[_spender] == 0. To decrement
395    * allowed value is better to use this function to avoid 2 calls (and wait until
396    * the first transaction is mined)
397    * From MonolithDAO Token.sol
398    * @param _spender The address which will spend the funds.
399    * @param _subtractedValue The amount of tokens to decrease the allowance by.
400    */
401   function decreaseApproval(
402     address _spender,
403     uint256 _subtractedValue
404   )
405     public
406     returns (bool)
407   {
408     uint256 oldValue = allowed[msg.sender][_spender];
409     if (_subtractedValue >= oldValue) {
410       allowed[msg.sender][_spender] = 0;
411     } else {
412       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
413     }
414     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
415     return true;
416   }
417 
418 }
419 
420 contract MintableToken is StandardToken, Ownable {
421   event Mint(address indexed to, uint256 amount);
422   event MintFinished();
423 
424   bool public mintingFinished = false;
425 
426 
427   modifier canMint() {
428     require(!mintingFinished);
429     _;
430   }
431 
432   modifier hasMintPermission() {
433     require(msg.sender == owner);
434     _;
435   }
436 
437   /**
438    * @dev Function to mint tokens
439    * @param _to The address that will receive the minted tokens.
440    * @param _amount The amount of tokens to mint.
441    * @return A boolean that indicates if the operation was successful.
442    */
443   function mint(
444     address _to,
445     uint256 _amount
446   )
447     public
448     hasMintPermission
449     canMint
450     returns (bool)
451   {
452     totalSupply_ = totalSupply_.add(_amount);
453     balances[_to] = balances[_to].add(_amount);
454     emit Mint(_to, _amount);
455     emit Transfer(address(0), _to, _amount);
456     return true;
457   }
458 
459   /**
460    * @dev Function to stop minting new tokens.
461    * @return True if the operation was successful.
462    */
463   function finishMinting() public onlyOwner canMint returns (bool) {
464     mintingFinished = true;
465     emit MintFinished();
466     return true;
467   }
468 }
469 
470 contract RBACMintableToken is MintableToken, RBAC {
471   /**
472    * A constant role name for indicating minters.
473    */
474   string public constant ROLE_MINTER = "minter";
475 
476   /**
477    * @dev override the Mintable token modifier to add role based logic
478    */
479   modifier hasMintPermission() {
480     checkRole(msg.sender, ROLE_MINTER);
481     _;
482   }
483 
484   /**
485    * @dev add a minter role to an address
486    * @param _minter address
487    */
488   function addMinter(address _minter) public onlyOwner {
489     addRole(_minter, ROLE_MINTER);
490   }
491 
492   /**
493    * @dev remove a minter role from an address
494    * @param _minter address
495    */
496   function removeMinter(address _minter) public onlyOwner {
497     removeRole(_minter, ROLE_MINTER);
498   }
499 }
500 
501 contract EnaToken is RBACMintableToken {
502     string public name = "EnaCoins";
503     string public symbol = "ENA";
504     uint8 public decimals = 18;
505 }