1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
56 
57 /**
58  * @title ERC20Basic
59  * @dev Simpler version of ERC20 interface
60  * See https://github.com/ethereum/EIPs/issues/179
61  */
62 contract ERC20Basic {
63   function totalSupply() public view returns (uint256);
64   function balanceOf(address who) public view returns (uint256);
65   function transfer(address to, uint256 value) public returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) balances;
79 
80   uint256 totalSupply_;
81 
82   /**
83   * @dev Total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev Transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_to != address(0));
96     require(_value <= balances[msg.sender]);
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
116 
117 /**
118  * @title Burnable Token
119  * @dev Token that can be irreversibly burned (destroyed).
120  */
121 contract BurnableToken is BasicToken {
122 
123   event Burn(address indexed burner, uint256 value);
124 
125   /**
126    * @dev Burns a specific amount of tokens.
127    * @param _value The amount of token to be burned.
128    */
129   function burn(uint256 _value) public {
130     _burn(msg.sender, _value);
131   }
132 
133   function _burn(address _who, uint256 _value) internal {
134     require(_value <= balances[_who]);
135     // no need to require value <= totalSupply, since that would imply the
136     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
137 
138     balances[_who] = balances[_who].sub(_value);
139     totalSupply_ = totalSupply_.sub(_value);
140     emit Burn(_who, _value);
141     emit Transfer(_who, address(0), _value);
142   }
143 }
144 
145 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
146 
147 /**
148  * @title ERC20 interface
149  * @dev see https://github.com/ethereum/EIPs/issues/20
150  */
151 contract ERC20 is ERC20Basic {
152   function allowance(address owner, address spender)
153     public view returns (uint256);
154 
155   function transferFrom(address from, address to, uint256 value)
156     public returns (bool);
157 
158   function approve(address spender, uint256 value) public returns (bool);
159   event Approval(
160     address indexed owner,
161     address indexed spender,
162     uint256 value
163   );
164 }
165 
166 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
167 
168 /**
169  * @title DetailedERC20 token
170  * @dev The decimals are only for visualization purposes.
171  * All the operations are done using the smallest and indivisible token unit,
172  * just as on Ethereum all the operations are done in wei.
173  */
174 contract DetailedERC20 is ERC20 {
175   string public name;
176   string public symbol;
177   uint8 public decimals;
178 
179   constructor(string _name, string _symbol, uint8 _decimals) public {
180     name = _name;
181     symbol = _symbol;
182     decimals = _decimals;
183   }
184 }
185 
186 // File: openzeppelin-solidity/contracts/ownership/rbac/Roles.sol
187 
188 /**
189  * @title Roles
190  * @author Francisco Giordano (@frangio)
191  * @dev Library for managing addresses assigned to a Role.
192  * See RBAC.sol for example usage.
193  */
194 library Roles {
195   struct Role {
196     mapping (address => bool) bearer;
197   }
198 
199   /**
200    * @dev give an address access to this role
201    */
202   function add(Role storage role, address addr)
203     internal
204   {
205     role.bearer[addr] = true;
206   }
207 
208   /**
209    * @dev remove an address' access to this role
210    */
211   function remove(Role storage role, address addr)
212     internal
213   {
214     role.bearer[addr] = false;
215   }
216 
217   /**
218    * @dev check if an address has this role
219    * // reverts
220    */
221   function check(Role storage role, address addr)
222     view
223     internal
224   {
225     require(has(role, addr));
226   }
227 
228   /**
229    * @dev check if an address has this role
230    * @return bool
231    */
232   function has(Role storage role, address addr)
233     view
234     internal
235     returns (bool)
236   {
237     return role.bearer[addr];
238   }
239 }
240 
241 // File: openzeppelin-solidity/contracts/ownership/rbac/RBAC.sol
242 
243 /**
244  * @title RBAC (Role-Based Access Control)
245  * @author Matt Condon (@Shrugs)
246  * @dev Stores and provides setters and getters for roles and addresses.
247  * Supports unlimited numbers of roles and addresses.
248  * See //contracts/mocks/RBACMock.sol for an example of usage.
249  * This RBAC method uses strings to key roles. It may be beneficial
250  * for you to write your own implementation of this interface using Enums or similar.
251  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
252  * to avoid typos.
253  */
254 contract RBAC {
255   using Roles for Roles.Role;
256 
257   mapping (string => Roles.Role) private roles;
258 
259   event RoleAdded(address indexed operator, string role);
260   event RoleRemoved(address indexed operator, string role);
261 
262   /**
263    * @dev reverts if addr does not have role
264    * @param _operator address
265    * @param _role the name of the role
266    * // reverts
267    */
268   function checkRole(address _operator, string _role)
269     view
270     public
271   {
272     roles[_role].check(_operator);
273   }
274 
275   /**
276    * @dev determine if addr has role
277    * @param _operator address
278    * @param _role the name of the role
279    * @return bool
280    */
281   function hasRole(address _operator, string _role)
282     view
283     public
284     returns (bool)
285   {
286     return roles[_role].has(_operator);
287   }
288 
289   /**
290    * @dev add a role to an address
291    * @param _operator address
292    * @param _role the name of the role
293    */
294   function addRole(address _operator, string _role)
295     internal
296   {
297     roles[_role].add(_operator);
298     emit RoleAdded(_operator, _role);
299   }
300 
301   /**
302    * @dev remove a role from an address
303    * @param _operator address
304    * @param _role the name of the role
305    */
306   function removeRole(address _operator, string _role)
307     internal
308   {
309     roles[_role].remove(_operator);
310     emit RoleRemoved(_operator, _role);
311   }
312 
313   /**
314    * @dev modifier to scope access to a single role (uses msg.sender as addr)
315    * @param _role the name of the role
316    * // reverts
317    */
318   modifier onlyRole(string _role)
319   {
320     checkRole(msg.sender, _role);
321     _;
322   }
323 
324   /**
325    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
326    * @param _roles the names of the roles to scope access to
327    * // reverts
328    *
329    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
330    *  see: https://github.com/ethereum/solidity/issues/2467
331    */
332   // modifier onlyRoles(string[] _roles) {
333   //     bool hasAnyRole = false;
334   //     for (uint8 i = 0; i < _roles.length; i++) {
335   //         if (hasRole(msg.sender, _roles[i])) {
336   //             hasAnyRole = true;
337   //             break;
338   //         }
339   //     }
340 
341   //     require(hasAnyRole);
342 
343   //     _;
344   // }
345 }
346 
347 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
348 
349 /**
350  * @title Ownable
351  * @dev The Ownable contract has an owner address, and provides basic authorization control
352  * functions, this simplifies the implementation of "user permissions".
353  */
354 contract Ownable {
355   address public owner;
356 
357 
358   event OwnershipRenounced(address indexed previousOwner);
359   event OwnershipTransferred(
360     address indexed previousOwner,
361     address indexed newOwner
362   );
363 
364 
365   /**
366    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
367    * account.
368    */
369   constructor() public {
370     owner = msg.sender;
371   }
372 
373   /**
374    * @dev Throws if called by any account other than the owner.
375    */
376   modifier onlyOwner() {
377     require(msg.sender == owner);
378     _;
379   }
380 
381   /**
382    * @dev Allows the current owner to relinquish control of the contract.
383    * @notice Renouncing to ownership will leave the contract without an owner.
384    * It will not be possible to call the functions with the `onlyOwner`
385    * modifier anymore.
386    */
387   function renounceOwnership() public onlyOwner {
388     emit OwnershipRenounced(owner);
389     owner = address(0);
390   }
391 
392   /**
393    * @dev Allows the current owner to transfer control of the contract to a newOwner.
394    * @param _newOwner The address to transfer ownership to.
395    */
396   function transferOwnership(address _newOwner) public onlyOwner {
397     _transferOwnership(_newOwner);
398   }
399 
400   /**
401    * @dev Transfers control of the contract to a newOwner.
402    * @param _newOwner The address to transfer ownership to.
403    */
404   function _transferOwnership(address _newOwner) internal {
405     require(_newOwner != address(0));
406     emit OwnershipTransferred(owner, _newOwner);
407     owner = _newOwner;
408   }
409 }
410 
411 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
412 
413 /**
414  * @title Standard ERC20 token
415  *
416  * @dev Implementation of the basic standard token.
417  * https://github.com/ethereum/EIPs/issues/20
418  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
419  */
420 contract StandardToken is ERC20, BasicToken {
421 
422   mapping (address => mapping (address => uint256)) internal allowed;
423 
424 
425   /**
426    * @dev Transfer tokens from one address to another
427    * @param _from address The address which you want to send tokens from
428    * @param _to address The address which you want to transfer to
429    * @param _value uint256 the amount of tokens to be transferred
430    */
431   function transferFrom(
432     address _from,
433     address _to,
434     uint256 _value
435   )
436     public
437     returns (bool)
438   {
439     require(_to != address(0));
440     require(_value <= balances[_from]);
441     require(_value <= allowed[_from][msg.sender]);
442 
443     balances[_from] = balances[_from].sub(_value);
444     balances[_to] = balances[_to].add(_value);
445     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
446     emit Transfer(_from, _to, _value);
447     return true;
448   }
449 
450   /**
451    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
452    * Beware that changing an allowance with this method brings the risk that someone may use both the old
453    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
454    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
455    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
456    * @param _spender The address which will spend the funds.
457    * @param _value The amount of tokens to be spent.
458    */
459   function approve(address _spender, uint256 _value) public returns (bool) {
460     allowed[msg.sender][_spender] = _value;
461     emit Approval(msg.sender, _spender, _value);
462     return true;
463   }
464 
465   /**
466    * @dev Function to check the amount of tokens that an owner allowed to a spender.
467    * @param _owner address The address which owns the funds.
468    * @param _spender address The address which will spend the funds.
469    * @return A uint256 specifying the amount of tokens still available for the spender.
470    */
471   function allowance(
472     address _owner,
473     address _spender
474    )
475     public
476     view
477     returns (uint256)
478   {
479     return allowed[_owner][_spender];
480   }
481 
482   /**
483    * @dev Increase the amount of tokens that an owner allowed to a spender.
484    * approve should be called when allowed[_spender] == 0. To increment
485    * allowed value is better to use this function to avoid 2 calls (and wait until
486    * the first transaction is mined)
487    * From MonolithDAO Token.sol
488    * @param _spender The address which will spend the funds.
489    * @param _addedValue The amount of tokens to increase the allowance by.
490    */
491   function increaseApproval(
492     address _spender,
493     uint256 _addedValue
494   )
495     public
496     returns (bool)
497   {
498     allowed[msg.sender][_spender] = (
499       allowed[msg.sender][_spender].add(_addedValue));
500     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
501     return true;
502   }
503 
504   /**
505    * @dev Decrease the amount of tokens that an owner allowed to a spender.
506    * approve should be called when allowed[_spender] == 0. To decrement
507    * allowed value is better to use this function to avoid 2 calls (and wait until
508    * the first transaction is mined)
509    * From MonolithDAO Token.sol
510    * @param _spender The address which will spend the funds.
511    * @param _subtractedValue The amount of tokens to decrease the allowance by.
512    */
513   function decreaseApproval(
514     address _spender,
515     uint256 _subtractedValue
516   )
517     public
518     returns (bool)
519   {
520     uint256 oldValue = allowed[msg.sender][_spender];
521     if (_subtractedValue > oldValue) {
522       allowed[msg.sender][_spender] = 0;
523     } else {
524       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
525     }
526     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
527     return true;
528   }
529 
530 }
531 
532 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
533 
534 /**
535  * @title Mintable token
536  * @dev Simple ERC20 Token example, with mintable token creation
537  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
538  */
539 contract MintableToken is StandardToken, Ownable {
540   event Mint(address indexed to, uint256 amount);
541   event MintFinished();
542 
543   bool public mintingFinished = false;
544 
545 
546   modifier canMint() {
547     require(!mintingFinished);
548     _;
549   }
550 
551   modifier hasMintPermission() {
552     require(msg.sender == owner);
553     _;
554   }
555 
556   /**
557    * @dev Function to mint tokens
558    * @param _to The address that will receive the minted tokens.
559    * @param _amount The amount of tokens to mint.
560    * @return A boolean that indicates if the operation was successful.
561    */
562   function mint(
563     address _to,
564     uint256 _amount
565   )
566     hasMintPermission
567     canMint
568     public
569     returns (bool)
570   {
571     totalSupply_ = totalSupply_.add(_amount);
572     balances[_to] = balances[_to].add(_amount);
573     emit Mint(_to, _amount);
574     emit Transfer(address(0), _to, _amount);
575     return true;
576   }
577 
578   /**
579    * @dev Function to stop minting new tokens.
580    * @return True if the operation was successful.
581    */
582   function finishMinting() onlyOwner canMint public returns (bool) {
583     mintingFinished = true;
584     emit MintFinished();
585     return true;
586   }
587 }
588 
589 // File: openzeppelin-solidity/contracts/token/ERC20/RBACMintableToken.sol
590 
591 /**
592  * @title RBACMintableToken
593  * @author Vittorio Minacori (@vittominacori)
594  * @dev Mintable Token, with RBAC minter permissions
595  */
596 contract RBACMintableToken is MintableToken, RBAC {
597   /**
598    * A constant role name for indicating minters.
599    */
600   string public constant ROLE_MINTER = "minter";
601 
602   /**
603    * @dev override the Mintable token modifier to add role based logic
604    */
605   modifier hasMintPermission() {
606     checkRole(msg.sender, ROLE_MINTER);
607     _;
608   }
609 
610   /**
611    * @dev add a minter role to an address
612    * @param minter address
613    */
614   function addMinter(address minter) onlyOwner public {
615     addRole(minter, ROLE_MINTER);
616   }
617 
618   /**
619    * @dev remove a minter role from an address
620    * @param minter address
621    */
622   function removeMinter(address minter) onlyOwner public {
623     removeRole(minter, ROLE_MINTER);
624   }
625 }
626 
627 // File: contracts/ERC20Token.sol
628 
629 contract ERC20Token is DetailedERC20, RBACMintableToken, BurnableToken {
630 
631   string public builtOn = "https://vittominacori.github.io/erc20-generator";
632 
633   constructor(
634     string _name,
635     string _symbol,
636     uint8 _decimals
637   )
638   DetailedERC20 (_name, _symbol, _decimals)
639   public
640   {
641     addMinter(owner);
642   }
643 
644   function transferAnyERC20Token(address _tokenAddress, uint256 _tokens) public onlyOwner returns (bool success) {
645     return ERC20Basic(_tokenAddress).transfer(owner, _tokens);
646   }
647 }