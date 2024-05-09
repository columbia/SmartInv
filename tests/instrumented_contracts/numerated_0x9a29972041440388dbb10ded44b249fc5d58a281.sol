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
28   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
29     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (_a == 0) {
33       return 0;
34     }
35 
36     c = _a * _b;
37     assert(c / _a == _b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
45     // assert(_b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = _a / _b;
47     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
48     return _a / _b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
55     assert(_b <= _a);
56     return _a - _b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
63     c = _a + _b;
64     assert(c >= _a);
65     return c;
66   }
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
78   mapping(address => uint256) internal balances;
79 
80   uint256 internal totalSupply_;
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
95     require(_value <= balances[msg.sender]);
96     require(_to != address(0));
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
152   function allowance(address _owner, address _spender)
153     public view returns (uint256);
154 
155   function transferFrom(address _from, address _to, uint256 _value)
156     public returns (bool);
157 
158   function approve(address _spender, uint256 _value) public returns (bool);
159   event Approval(
160     address indexed owner,
161     address indexed spender,
162     uint256 value
163   );
164 }
165 
166 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
167 
168 /**
169  * @title Standard ERC20 token
170  *
171  * @dev Implementation of the basic standard token.
172  * https://github.com/ethereum/EIPs/issues/20
173  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
174  */
175 contract StandardToken is ERC20, BasicToken {
176 
177   mapping (address => mapping (address => uint256)) internal allowed;
178 
179 
180   /**
181    * @dev Transfer tokens from one address to another
182    * @param _from address The address which you want to send tokens from
183    * @param _to address The address which you want to transfer to
184    * @param _value uint256 the amount of tokens to be transferred
185    */
186   function transferFrom(
187     address _from,
188     address _to,
189     uint256 _value
190   )
191     public
192     returns (bool)
193   {
194     require(_value <= balances[_from]);
195     require(_value <= allowed[_from][msg.sender]);
196     require(_to != address(0));
197 
198     balances[_from] = balances[_from].sub(_value);
199     balances[_to] = balances[_to].add(_value);
200     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
201     emit Transfer(_from, _to, _value);
202     return true;
203   }
204 
205   /**
206    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
207    * Beware that changing an allowance with this method brings the risk that someone may use both the old
208    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
209    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
210    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
211    * @param _spender The address which will spend the funds.
212    * @param _value The amount of tokens to be spent.
213    */
214   function approve(address _spender, uint256 _value) public returns (bool) {
215     allowed[msg.sender][_spender] = _value;
216     emit Approval(msg.sender, _spender, _value);
217     return true;
218   }
219 
220   /**
221    * @dev Function to check the amount of tokens that an owner allowed to a spender.
222    * @param _owner address The address which owns the funds.
223    * @param _spender address The address which will spend the funds.
224    * @return A uint256 specifying the amount of tokens still available for the spender.
225    */
226   function allowance(
227     address _owner,
228     address _spender
229    )
230     public
231     view
232     returns (uint256)
233   {
234     return allowed[_owner][_spender];
235   }
236 
237   /**
238    * @dev Increase the amount of tokens that an owner allowed to a spender.
239    * approve should be called when allowed[_spender] == 0. To increment
240    * allowed value is better to use this function to avoid 2 calls (and wait until
241    * the first transaction is mined)
242    * From MonolithDAO Token.sol
243    * @param _spender The address which will spend the funds.
244    * @param _addedValue The amount of tokens to increase the allowance by.
245    */
246   function increaseApproval(
247     address _spender,
248     uint256 _addedValue
249   )
250     public
251     returns (bool)
252   {
253     allowed[msg.sender][_spender] = (
254       allowed[msg.sender][_spender].add(_addedValue));
255     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
256     return true;
257   }
258 
259   /**
260    * @dev Decrease the amount of tokens that an owner allowed to a spender.
261    * approve should be called when allowed[_spender] == 0. To decrement
262    * allowed value is better to use this function to avoid 2 calls (and wait until
263    * the first transaction is mined)
264    * From MonolithDAO Token.sol
265    * @param _spender The address which will spend the funds.
266    * @param _subtractedValue The amount of tokens to decrease the allowance by.
267    */
268   function decreaseApproval(
269     address _spender,
270     uint256 _subtractedValue
271   )
272     public
273     returns (bool)
274   {
275     uint256 oldValue = allowed[msg.sender][_spender];
276     if (_subtractedValue >= oldValue) {
277       allowed[msg.sender][_spender] = 0;
278     } else {
279       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
280     }
281     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
282     return true;
283   }
284 
285 }
286 
287 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
288 
289 /**
290  * @title Ownable
291  * @dev The Ownable contract has an owner address, and provides basic authorization control
292  * functions, this simplifies the implementation of "user permissions".
293  */
294 contract Ownable {
295   address public owner;
296 
297 
298   event OwnershipRenounced(address indexed previousOwner);
299   event OwnershipTransferred(
300     address indexed previousOwner,
301     address indexed newOwner
302   );
303 
304 
305   /**
306    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
307    * account.
308    */
309   constructor() public {
310     owner = msg.sender;
311   }
312 
313   /**
314    * @dev Throws if called by any account other than the owner.
315    */
316   modifier onlyOwner() {
317     require(msg.sender == owner);
318     _;
319   }
320 
321   /**
322    * @dev Allows the current owner to relinquish control of the contract.
323    * @notice Renouncing to ownership will leave the contract without an owner.
324    * It will not be possible to call the functions with the `onlyOwner`
325    * modifier anymore.
326    */
327   function renounceOwnership() public onlyOwner {
328     emit OwnershipRenounced(owner);
329     owner = address(0);
330   }
331 
332   /**
333    * @dev Allows the current owner to transfer control of the contract to a newOwner.
334    * @param _newOwner The address to transfer ownership to.
335    */
336   function transferOwnership(address _newOwner) public onlyOwner {
337     _transferOwnership(_newOwner);
338   }
339 
340   /**
341    * @dev Transfers control of the contract to a newOwner.
342    * @param _newOwner The address to transfer ownership to.
343    */
344   function _transferOwnership(address _newOwner) internal {
345     require(_newOwner != address(0));
346     emit OwnershipTransferred(owner, _newOwner);
347     owner = _newOwner;
348   }
349 }
350 
351 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
352 
353 /**
354  * @title Mintable token
355  * @dev Simple ERC20 Token example, with mintable token creation
356  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
357  */
358 contract MintableToken is StandardToken, Ownable {
359   event Mint(address indexed to, uint256 amount);
360   event MintFinished();
361 
362   bool public mintingFinished = false;
363 
364 
365   modifier canMint() {
366     require(!mintingFinished);
367     _;
368   }
369 
370   modifier hasMintPermission() {
371     require(msg.sender == owner);
372     _;
373   }
374 
375   /**
376    * @dev Function to mint tokens
377    * @param _to The address that will receive the minted tokens.
378    * @param _amount The amount of tokens to mint.
379    * @return A boolean that indicates if the operation was successful.
380    */
381   function mint(
382     address _to,
383     uint256 _amount
384   )
385     public
386     hasMintPermission
387     canMint
388     returns (bool)
389   {
390     totalSupply_ = totalSupply_.add(_amount);
391     balances[_to] = balances[_to].add(_amount);
392     emit Mint(_to, _amount);
393     emit Transfer(address(0), _to, _amount);
394     return true;
395   }
396 
397   /**
398    * @dev Function to stop minting new tokens.
399    * @return True if the operation was successful.
400    */
401   function finishMinting() public onlyOwner canMint returns (bool) {
402     mintingFinished = true;
403     emit MintFinished();
404     return true;
405   }
406 }
407 
408 // File: openzeppelin-solidity/contracts/access/rbac/Roles.sol
409 
410 /**
411  * @title Roles
412  * @author Francisco Giordano (@frangio)
413  * @dev Library for managing addresses assigned to a Role.
414  * See RBAC.sol for example usage.
415  */
416 library Roles {
417   struct Role {
418     mapping (address => bool) bearer;
419   }
420 
421   /**
422    * @dev give an address access to this role
423    */
424   function add(Role storage _role, address _addr)
425     internal
426   {
427     _role.bearer[_addr] = true;
428   }
429 
430   /**
431    * @dev remove an address' access to this role
432    */
433   function remove(Role storage _role, address _addr)
434     internal
435   {
436     _role.bearer[_addr] = false;
437   }
438 
439   /**
440    * @dev check if an address has this role
441    * // reverts
442    */
443   function check(Role storage _role, address _addr)
444     internal
445     view
446   {
447     require(has(_role, _addr));
448   }
449 
450   /**
451    * @dev check if an address has this role
452    * @return bool
453    */
454   function has(Role storage _role, address _addr)
455     internal
456     view
457     returns (bool)
458   {
459     return _role.bearer[_addr];
460   }
461 }
462 
463 // File: openzeppelin-solidity/contracts/access/rbac/RBAC.sol
464 
465 /**
466  * @title RBAC (Role-Based Access Control)
467  * @author Matt Condon (@Shrugs)
468  * @dev Stores and provides setters and getters for roles and addresses.
469  * Supports unlimited numbers of roles and addresses.
470  * See //contracts/mocks/RBACMock.sol for an example of usage.
471  * This RBAC method uses strings to key roles. It may be beneficial
472  * for you to write your own implementation of this interface using Enums or similar.
473  */
474 contract RBAC {
475   using Roles for Roles.Role;
476 
477   mapping (string => Roles.Role) private roles;
478 
479   event RoleAdded(address indexed operator, string role);
480   event RoleRemoved(address indexed operator, string role);
481 
482   /**
483    * @dev reverts if addr does not have role
484    * @param _operator address
485    * @param _role the name of the role
486    * // reverts
487    */
488   function checkRole(address _operator, string _role)
489     public
490     view
491   {
492     roles[_role].check(_operator);
493   }
494 
495   /**
496    * @dev determine if addr has role
497    * @param _operator address
498    * @param _role the name of the role
499    * @return bool
500    */
501   function hasRole(address _operator, string _role)
502     public
503     view
504     returns (bool)
505   {
506     return roles[_role].has(_operator);
507   }
508 
509   /**
510    * @dev add a role to an address
511    * @param _operator address
512    * @param _role the name of the role
513    */
514   function addRole(address _operator, string _role)
515     internal
516   {
517     roles[_role].add(_operator);
518     emit RoleAdded(_operator, _role);
519   }
520 
521   /**
522    * @dev remove a role from an address
523    * @param _operator address
524    * @param _role the name of the role
525    */
526   function removeRole(address _operator, string _role)
527     internal
528   {
529     roles[_role].remove(_operator);
530     emit RoleRemoved(_operator, _role);
531   }
532 
533   /**
534    * @dev modifier to scope access to a single role (uses msg.sender as addr)
535    * @param _role the name of the role
536    * // reverts
537    */
538   modifier onlyRole(string _role)
539   {
540     checkRole(msg.sender, _role);
541     _;
542   }
543 
544   /**
545    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
546    * @param _roles the names of the roles to scope access to
547    * // reverts
548    *
549    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
550    *  see: https://github.com/ethereum/solidity/issues/2467
551    */
552   // modifier onlyRoles(string[] _roles) {
553   //     bool hasAnyRole = false;
554   //     for (uint8 i = 0; i < _roles.length; i++) {
555   //         if (hasRole(msg.sender, _roles[i])) {
556   //             hasAnyRole = true;
557   //             break;
558   //         }
559   //     }
560 
561   //     require(hasAnyRole);
562 
563   //     _;
564   // }
565 }
566 
567 // File: openzeppelin-solidity/contracts/token/ERC20/RBACMintableToken.sol
568 
569 /**
570  * @title RBACMintableToken
571  * @author Vittorio Minacori (@vittominacori)
572  * @dev Mintable Token, with RBAC minter permissions
573  */
574 contract RBACMintableToken is MintableToken, RBAC {
575   /**
576    * A constant role name for indicating minters.
577    */
578   string public constant ROLE_MINTER = "minter";
579 
580   /**
581    * @dev override the Mintable token modifier to add role based logic
582    */
583   modifier hasMintPermission() {
584     checkRole(msg.sender, ROLE_MINTER);
585     _;
586   }
587 
588   /**
589    * @dev add a minter role to an address
590    * @param _minter address
591    */
592   function addMinter(address _minter) public onlyOwner {
593     addRole(_minter, ROLE_MINTER);
594   }
595 
596   /**
597    * @dev remove a minter role from an address
598    * @param _minter address
599    */
600   function removeMinter(address _minter) public onlyOwner {
601     removeRole(_minter, ROLE_MINTER);
602   }
603 }
604 
605 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
606 
607 /**
608  * @title Pausable
609  * @dev Base contract which allows children to implement an emergency stop mechanism.
610  */
611 contract Pausable is Ownable {
612   event Pause();
613   event Unpause();
614 
615   bool public paused = false;
616 
617 
618   /**
619    * @dev Modifier to make a function callable only when the contract is not paused.
620    */
621   modifier whenNotPaused() {
622     require(!paused);
623     _;
624   }
625 
626   /**
627    * @dev Modifier to make a function callable only when the contract is paused.
628    */
629   modifier whenPaused() {
630     require(paused);
631     _;
632   }
633 
634   /**
635    * @dev called by the owner to pause, triggers stopped state
636    */
637   function pause() public onlyOwner whenNotPaused {
638     paused = true;
639     emit Pause();
640   }
641 
642   /**
643    * @dev called by the owner to unpause, returns to normal state
644    */
645   function unpause() public onlyOwner whenPaused {
646     paused = false;
647     emit Unpause();
648   }
649 }
650 
651 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
652 
653 /**
654  * @title Pausable token
655  * @dev StandardToken modified with pausable transfers.
656  **/
657 contract PausableToken is StandardToken, Pausable {
658 
659   function transfer(
660     address _to,
661     uint256 _value
662   )
663     public
664     whenNotPaused
665     returns (bool)
666   {
667     return super.transfer(_to, _value);
668   }
669 
670   function transferFrom(
671     address _from,
672     address _to,
673     uint256 _value
674   )
675     public
676     whenNotPaused
677     returns (bool)
678   {
679     return super.transferFrom(_from, _to, _value);
680   }
681 
682   function approve(
683     address _spender,
684     uint256 _value
685   )
686     public
687     whenNotPaused
688     returns (bool)
689   {
690     return super.approve(_spender, _value);
691   }
692 
693   function increaseApproval(
694     address _spender,
695     uint _addedValue
696   )
697     public
698     whenNotPaused
699     returns (bool success)
700   {
701     return super.increaseApproval(_spender, _addedValue);
702   }
703 
704   function decreaseApproval(
705     address _spender,
706     uint _subtractedValue
707   )
708     public
709     whenNotPaused
710     returns (bool success)
711   {
712     return super.decreaseApproval(_spender, _subtractedValue);
713   }
714 }
715 
716 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
717 
718 /**
719  * @title DetailedERC20 token
720  * @dev The decimals are only for visualization purposes.
721  * All the operations are done using the smallest and indivisible token unit,
722  * just as on Ethereum all the operations are done in wei.
723  */
724 contract DetailedERC20 is ERC20 {
725   string public name;
726   string public symbol;
727   uint8 public decimals;
728 
729   constructor(string _name, string _symbol, uint8 _decimals) public {
730     name = _name;
731     symbol = _symbol;
732     decimals = _decimals;
733   }
734 }
735 
736 // File: contracts/MAUcToken.sol
737 
738 contract MAUcToken is DetailedERC20, StandardToken, PausableToken, RBACMintableToken, BurnableToken {
739   constructor(
740     string _name,
741     string _symbol,
742     uint8 _decimals,
743     uint256 _amount
744   )
745     DetailedERC20(_name, _symbol, _decimals)
746     public
747   {
748     require(_amount > 0, "amount has to be greater than 0");
749     totalSupply_ = _amount * uint256(10) ** _decimals;
750     balances[msg.sender] = totalSupply_;
751     emit Transfer(address(0), msg.sender, totalSupply_);
752   }
753 }