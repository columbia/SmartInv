1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address _who) public view returns (uint256);
13   function transfer(address _to, uint256 _value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address _owner, address _spender)
25     public view returns (uint256);
26 
27   function transferFrom(address _from, address _to, uint256 _value)
28     public returns (bool);
29 
30   function approve(address _spender, uint256 _value) public returns (bool);
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
39 
40 /**
41  * @title DetailedERC20 token
42  * @dev The decimals are only for visualization purposes.
43  * All the operations are done using the smallest and indivisible token unit,
44  * just as on Ethereum all the operations are done in wei.
45  */
46 contract DetailedERC20 is ERC20 {
47   string public name;
48   string public symbol;
49   uint8 public decimals;
50 
51   constructor(string _name, string _symbol, uint8 _decimals) public {
52     name = _name;
53     symbol = _symbol;
54     decimals = _decimals;
55   }
56 }
57 
58 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
59 
60 /**
61  * @title SafeMath
62  * @dev Math operations with safety checks that throw on error
63  */
64 library SafeMath {
65 
66   /**
67   * @dev Multiplies two numbers, throws on overflow.
68   */
69   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
70     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
71     // benefit is lost if 'b' is also tested.
72     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
73     if (_a == 0) {
74       return 0;
75     }
76 
77     c = _a * _b;
78     assert(c / _a == _b);
79     return c;
80   }
81 
82   /**
83   * @dev Integer division of two numbers, truncating the quotient.
84   */
85   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
86     // assert(_b > 0); // Solidity automatically throws when dividing by 0
87     // uint256 c = _a / _b;
88     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
89     return _a / _b;
90   }
91 
92   /**
93   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
94   */
95   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
96     assert(_b <= _a);
97     return _a - _b;
98   }
99 
100   /**
101   * @dev Adds two numbers, throws on overflow.
102   */
103   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
104     c = _a + _b;
105     assert(c >= _a);
106     return c;
107   }
108 }
109 
110 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
111 
112 /**
113  * @title Basic token
114  * @dev Basic version of StandardToken, with no allowances.
115  */
116 contract BasicToken is ERC20Basic {
117   using SafeMath for uint256;
118 
119   mapping(address => uint256) internal balances;
120 
121   uint256 internal totalSupply_;
122 
123   /**
124   * @dev Total number of tokens in existence
125   */
126   function totalSupply() public view returns (uint256) {
127     return totalSupply_;
128   }
129 
130   /**
131   * @dev Transfer token for a specified address
132   * @param _to The address to transfer to.
133   * @param _value The amount to be transferred.
134   */
135   function transfer(address _to, uint256 _value) public returns (bool) {
136     require(_value <= balances[msg.sender]);
137     require(_to != address(0));
138 
139     balances[msg.sender] = balances[msg.sender].sub(_value);
140     balances[_to] = balances[_to].add(_value);
141     emit Transfer(msg.sender, _to, _value);
142     return true;
143   }
144 
145   /**
146   * @dev Gets the balance of the specified address.
147   * @param _owner The address to query the the balance of.
148   * @return An uint256 representing the amount owned by the passed address.
149   */
150   function balanceOf(address _owner) public view returns (uint256) {
151     return balances[_owner];
152   }
153 
154 }
155 
156 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
157 
158 /**
159  * @title Standard ERC20 token
160  *
161  * @dev Implementation of the basic standard token.
162  * https://github.com/ethereum/EIPs/issues/20
163  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
164  */
165 contract StandardToken is ERC20, BasicToken {
166 
167   mapping (address => mapping (address => uint256)) internal allowed;
168 
169 
170   /**
171    * @dev Transfer tokens from one address to another
172    * @param _from address The address which you want to send tokens from
173    * @param _to address The address which you want to transfer to
174    * @param _value uint256 the amount of tokens to be transferred
175    */
176   function transferFrom(
177     address _from,
178     address _to,
179     uint256 _value
180   )
181     public
182     returns (bool)
183   {
184     require(_value <= balances[_from]);
185     require(_value <= allowed[_from][msg.sender]);
186     require(_to != address(0));
187 
188     balances[_from] = balances[_from].sub(_value);
189     balances[_to] = balances[_to].add(_value);
190     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
191     emit Transfer(_from, _to, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
197    * Beware that changing an allowance with this method brings the risk that someone may use both the old
198    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
199    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
200    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201    * @param _spender The address which will spend the funds.
202    * @param _value The amount of tokens to be spent.
203    */
204   function approve(address _spender, uint256 _value) public returns (bool) {
205     allowed[msg.sender][_spender] = _value;
206     emit Approval(msg.sender, _spender, _value);
207     return true;
208   }
209 
210   /**
211    * @dev Function to check the amount of tokens that an owner allowed to a spender.
212    * @param _owner address The address which owns the funds.
213    * @param _spender address The address which will spend the funds.
214    * @return A uint256 specifying the amount of tokens still available for the spender.
215    */
216   function allowance(
217     address _owner,
218     address _spender
219    )
220     public
221     view
222     returns (uint256)
223   {
224     return allowed[_owner][_spender];
225   }
226 
227   /**
228    * @dev Increase the amount of tokens that an owner allowed to a spender.
229    * approve should be called when allowed[_spender] == 0. To increment
230    * allowed value is better to use this function to avoid 2 calls (and wait until
231    * the first transaction is mined)
232    * From MonolithDAO Token.sol
233    * @param _spender The address which will spend the funds.
234    * @param _addedValue The amount of tokens to increase the allowance by.
235    */
236   function increaseApproval(
237     address _spender,
238     uint256 _addedValue
239   )
240     public
241     returns (bool)
242   {
243     allowed[msg.sender][_spender] = (
244       allowed[msg.sender][_spender].add(_addedValue));
245     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
246     return true;
247   }
248 
249   /**
250    * @dev Decrease the amount of tokens that an owner allowed to a spender.
251    * approve should be called when allowed[_spender] == 0. To decrement
252    * allowed value is better to use this function to avoid 2 calls (and wait until
253    * the first transaction is mined)
254    * From MonolithDAO Token.sol
255    * @param _spender The address which will spend the funds.
256    * @param _subtractedValue The amount of tokens to decrease the allowance by.
257    */
258   function decreaseApproval(
259     address _spender,
260     uint256 _subtractedValue
261   )
262     public
263     returns (bool)
264   {
265     uint256 oldValue = allowed[msg.sender][_spender];
266     if (_subtractedValue >= oldValue) {
267       allowed[msg.sender][_spender] = 0;
268     } else {
269       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
270     }
271     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
272     return true;
273   }
274 
275 }
276 
277 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
278 
279 /**
280  * @title Ownable
281  * @dev The Ownable contract has an owner address, and provides basic authorization control
282  * functions, this simplifies the implementation of "user permissions".
283  */
284 contract Ownable {
285   address public owner;
286 
287 
288   event OwnershipRenounced(address indexed previousOwner);
289   event OwnershipTransferred(
290     address indexed previousOwner,
291     address indexed newOwner
292   );
293 
294 
295   /**
296    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
297    * account.
298    */
299   constructor() public {
300     owner = msg.sender;
301   }
302 
303   /**
304    * @dev Throws if called by any account other than the owner.
305    */
306   modifier onlyOwner() {
307     require(msg.sender == owner);
308     _;
309   }
310 
311   /**
312    * @dev Allows the current owner to relinquish control of the contract.
313    * @notice Renouncing to ownership will leave the contract without an owner.
314    * It will not be possible to call the functions with the `onlyOwner`
315    * modifier anymore.
316    */
317   function renounceOwnership() public onlyOwner {
318     emit OwnershipRenounced(owner);
319     owner = address(0);
320   }
321 
322   /**
323    * @dev Allows the current owner to transfer control of the contract to a newOwner.
324    * @param _newOwner The address to transfer ownership to.
325    */
326   function transferOwnership(address _newOwner) public onlyOwner {
327     _transferOwnership(_newOwner);
328   }
329 
330   /**
331    * @dev Transfers control of the contract to a newOwner.
332    * @param _newOwner The address to transfer ownership to.
333    */
334   function _transferOwnership(address _newOwner) internal {
335     require(_newOwner != address(0));
336     emit OwnershipTransferred(owner, _newOwner);
337     owner = _newOwner;
338   }
339 }
340 
341 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
342 
343 /**
344  * @title Mintable token
345  * @dev Simple ERC20 Token example, with mintable token creation
346  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
347  */
348 contract MintableToken is StandardToken, Ownable {
349   event Mint(address indexed to, uint256 amount);
350   event MintFinished();
351 
352   bool public mintingFinished = false;
353 
354 
355   modifier canMint() {
356     require(!mintingFinished);
357     _;
358   }
359 
360   modifier hasMintPermission() {
361     require(msg.sender == owner);
362     _;
363   }
364 
365   /**
366    * @dev Function to mint tokens
367    * @param _to The address that will receive the minted tokens.
368    * @param _amount The amount of tokens to mint.
369    * @return A boolean that indicates if the operation was successful.
370    */
371   function mint(
372     address _to,
373     uint256 _amount
374   )
375     hasMintPermission
376     canMint
377     public
378     returns (bool)
379   {
380     totalSupply_ = totalSupply_.add(_amount);
381     balances[_to] = balances[_to].add(_amount);
382     emit Mint(_to, _amount);
383     emit Transfer(address(0), _to, _amount);
384     return true;
385   }
386 
387   /**
388    * @dev Function to stop minting new tokens.
389    * @return True if the operation was successful.
390    */
391   function finishMinting() onlyOwner canMint public returns (bool) {
392     mintingFinished = true;
393     emit MintFinished();
394     return true;
395   }
396 }
397 
398 // File: openzeppelin-solidity/contracts/access/rbac/Roles.sol
399 
400 /**
401  * @title Roles
402  * @author Francisco Giordano (@frangio)
403  * @dev Library for managing addresses assigned to a Role.
404  * See RBAC.sol for example usage.
405  */
406 library Roles {
407   struct Role {
408     mapping (address => bool) bearer;
409   }
410 
411   /**
412    * @dev give an address access to this role
413    */
414   function add(Role storage _role, address _addr)
415     internal
416   {
417     _role.bearer[_addr] = true;
418   }
419 
420   /**
421    * @dev remove an address' access to this role
422    */
423   function remove(Role storage _role, address _addr)
424     internal
425   {
426     _role.bearer[_addr] = false;
427   }
428 
429   /**
430    * @dev check if an address has this role
431    * // reverts
432    */
433   function check(Role storage _role, address _addr)
434     internal
435     view
436   {
437     require(has(_role, _addr));
438   }
439 
440   /**
441    * @dev check if an address has this role
442    * @return bool
443    */
444   function has(Role storage _role, address _addr)
445     internal
446     view
447     returns (bool)
448   {
449     return _role.bearer[_addr];
450   }
451 }
452 
453 // File: openzeppelin-solidity/contracts/access/rbac/RBAC.sol
454 
455 /**
456  * @title RBAC (Role-Based Access Control)
457  * @author Matt Condon (@Shrugs)
458  * @dev Stores and provides setters and getters for roles and addresses.
459  * Supports unlimited numbers of roles and addresses.
460  * See //contracts/mocks/RBACMock.sol for an example of usage.
461  * This RBAC method uses strings to key roles. It may be beneficial
462  * for you to write your own implementation of this interface using Enums or similar.
463  */
464 contract RBAC {
465   using Roles for Roles.Role;
466 
467   mapping (string => Roles.Role) private roles;
468 
469   event RoleAdded(address indexed operator, string role);
470   event RoleRemoved(address indexed operator, string role);
471 
472   /**
473    * @dev reverts if addr does not have role
474    * @param _operator address
475    * @param _role the name of the role
476    * // reverts
477    */
478   function checkRole(address _operator, string _role)
479     public
480     view
481   {
482     roles[_role].check(_operator);
483   }
484 
485   /**
486    * @dev determine if addr has role
487    * @param _operator address
488    * @param _role the name of the role
489    * @return bool
490    */
491   function hasRole(address _operator, string _role)
492     public
493     view
494     returns (bool)
495   {
496     return roles[_role].has(_operator);
497   }
498 
499   /**
500    * @dev add a role to an address
501    * @param _operator address
502    * @param _role the name of the role
503    */
504   function addRole(address _operator, string _role)
505     internal
506   {
507     roles[_role].add(_operator);
508     emit RoleAdded(_operator, _role);
509   }
510 
511   /**
512    * @dev remove a role from an address
513    * @param _operator address
514    * @param _role the name of the role
515    */
516   function removeRole(address _operator, string _role)
517     internal
518   {
519     roles[_role].remove(_operator);
520     emit RoleRemoved(_operator, _role);
521   }
522 
523   /**
524    * @dev modifier to scope access to a single role (uses msg.sender as addr)
525    * @param _role the name of the role
526    * // reverts
527    */
528   modifier onlyRole(string _role)
529   {
530     checkRole(msg.sender, _role);
531     _;
532   }
533 
534   /**
535    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
536    * @param _roles the names of the roles to scope access to
537    * // reverts
538    *
539    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
540    *  see: https://github.com/ethereum/solidity/issues/2467
541    */
542   // modifier onlyRoles(string[] _roles) {
543   //     bool hasAnyRole = false;
544   //     for (uint8 i = 0; i < _roles.length; i++) {
545   //         if (hasRole(msg.sender, _roles[i])) {
546   //             hasAnyRole = true;
547   //             break;
548   //         }
549   //     }
550 
551   //     require(hasAnyRole);
552 
553   //     _;
554   // }
555 }
556 
557 // File: openzeppelin-solidity/contracts/token/ERC20/RBACMintableToken.sol
558 
559 /**
560  * @title RBACMintableToken
561  * @author Vittorio Minacori (@vittominacori)
562  * @dev Mintable Token, with RBAC minter permissions
563  */
564 contract RBACMintableToken is MintableToken, RBAC {
565   /**
566    * A constant role name for indicating minters.
567    */
568   string public constant ROLE_MINTER = "minter";
569 
570   /**
571    * @dev override the Mintable token modifier to add role based logic
572    */
573   modifier hasMintPermission() {
574     checkRole(msg.sender, ROLE_MINTER);
575     _;
576   }
577 
578   /**
579    * @dev add a minter role to an address
580    * @param _minter address
581    */
582   function addMinter(address _minter) public onlyOwner {
583     addRole(_minter, ROLE_MINTER);
584   }
585 
586   /**
587    * @dev remove a minter role from an address
588    * @param _minter address
589    */
590   function removeMinter(address _minter) public onlyOwner {
591     removeRole(_minter, ROLE_MINTER);
592   }
593 }
594 
595 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
596 
597 /**
598  * @title Burnable Token
599  * @dev Token that can be irreversibly burned (destroyed).
600  */
601 contract BurnableToken is BasicToken {
602 
603   event Burn(address indexed burner, uint256 value);
604 
605   /**
606    * @dev Burns a specific amount of tokens.
607    * @param _value The amount of token to be burned.
608    */
609   function burn(uint256 _value) public {
610     _burn(msg.sender, _value);
611   }
612 
613   function _burn(address _who, uint256 _value) internal {
614     require(_value <= balances[_who]);
615     // no need to require value <= totalSupply, since that would imply the
616     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
617 
618     balances[_who] = balances[_who].sub(_value);
619     totalSupply_ = totalSupply_.sub(_value);
620     emit Burn(_who, _value);
621     emit Transfer(_who, address(0), _value);
622   }
623 }
624 
625 // File: contracts/ERC20Token.sol
626 
627 contract ERC20Token is DetailedERC20, RBACMintableToken, BurnableToken {
628 
629   string public builtOn = "https://vittominacori.github.io/erc20-generator";
630 
631   constructor(
632     string _name,
633     string _symbol,
634     uint8 _decimals
635   )
636     DetailedERC20 (_name, _symbol, _decimals)
637     public
638   {
639     addMinter(owner);
640   }
641 
642   function transferAnyERC20Token(
643     address _tokenAddress,
644     uint256 _tokens
645   )
646     public
647     onlyOwner
648     returns (bool success)
649   {
650     return ERC20Basic(_tokenAddress).transfer(owner, _tokens);
651   }
652 }