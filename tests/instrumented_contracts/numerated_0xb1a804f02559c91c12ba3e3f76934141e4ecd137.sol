1 pragma solidity 0.4.25;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address private _owner;
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
26     _owner = msg.sender;
27   }
28 
29   /**
30    * @return the address of the owner.
31    */
32   function owner() public view returns(address) {
33     return _owner;
34   }
35 
36   /**
37    * @dev Throws if called by any account other than the owner.
38    */
39   modifier onlyOwner() {
40     require(isOwner());
41     _;
42   }
43 
44   /**
45    * @return true if `msg.sender` is the owner of the contract.
46    */
47   function isOwner() public view returns(bool) {
48     return msg.sender == _owner;
49   }
50 
51   /**
52    * @dev Allows the current owner to relinquish control of the contract.
53    * @notice Renouncing to ownership will leave the contract without an owner.
54    * It will not be possible to call the functions with the `onlyOwner`
55    * modifier anymore.
56    */
57   function renounceOwnership() public onlyOwner {
58     emit OwnershipRenounced(_owner);
59     _owner = address(0);
60   }
61 
62   /**
63    * @dev Allows the current owner to transfer control of the contract to a newOwner.
64    * @param newOwner The address to transfer ownership to.
65    */
66   function transferOwnership(address newOwner) public onlyOwner {
67     _transferOwnership(newOwner);
68   }
69 
70   /**
71    * @dev Transfers control of the contract to a newOwner.
72    * @param newOwner The address to transfer ownership to.
73    */
74   function _transferOwnership(address newOwner) internal {
75     require(newOwner != address(0));
76     emit OwnershipTransferred(_owner, newOwner);
77     _owner = newOwner;
78   }
79 }
80 
81 // File: contracts/Administratable.sol
82 
83 // Lee, July 29, 2018
84 pragma solidity 0.4.25;
85 
86 
87 contract Administratable is Ownable {
88 	mapping (address => bool) public superAdmins;
89 
90 	event AddSuperAdmin(address indexed admin);
91 	event RemoveSuperAdmin(address indexed admin);
92 
93     modifier validateAddress( address _addr )
94     {
95         require(_addr != address(0x0));
96         require(_addr != address(this));
97         _;
98     }
99 
100 	modifier onlySuperAdmins {
101 		require(msg.sender == owner() || superAdmins[msg.sender]);
102 		_;
103 	}
104 
105 	function addSuperAdmin(address _admin) public onlyOwner validateAddress(_admin){
106 		require(!superAdmins[_admin]);
107 		superAdmins[_admin] = true;
108 		emit AddSuperAdmin(_admin);
109 	}
110 
111 	function removeSuperAdmin(address _admin) public onlyOwner validateAddress(_admin){
112 		require(superAdmins[_admin]);
113 		superAdmins[_admin] = false;
114 		emit RemoveSuperAdmin(_admin);
115 	}
116 }
117 
118 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
119 
120 /**
121  * @title ERC20 interface
122  * @dev see https://github.com/ethereum/EIPs/issues/20
123  */
124 interface IERC20 {
125   function totalSupply() external view returns (uint256);
126 
127   function balanceOf(address who) external view returns (uint256);
128 
129   function allowance(address owner, address spender)
130     external view returns (uint256);
131 
132   function transfer(address to, uint256 value) external returns (bool);
133 
134   function approve(address spender, uint256 value)
135     external returns (bool);
136 
137   function transferFrom(address from, address to, uint256 value)
138     external returns (bool);
139 
140   event Transfer(
141     address indexed from,
142     address indexed to,
143     uint256 value
144   );
145 
146   event Approval(
147     address indexed owner,
148     address indexed spender,
149     uint256 value
150   );
151 }
152 
153 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
154 
155 /**
156  * @title SafeMath
157  * @dev Math operations with safety checks that revert on error
158  */
159 library SafeMath {
160 
161   /**
162   * @dev Multiplies two numbers, reverts on overflow.
163   */
164   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
165     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
166     // benefit is lost if 'b' is also tested.
167     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
168     if (a == 0) {
169       return 0;
170     }
171 
172     uint256 c = a * b;
173     require(c / a == b);
174 
175     return c;
176   }
177 
178   /**
179   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
180   */
181   function div(uint256 a, uint256 b) internal pure returns (uint256) {
182     require(b > 0); // Solidity only automatically asserts when dividing by 0
183     uint256 c = a / b;
184     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
185 
186     return c;
187   }
188 
189   /**
190   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
191   */
192   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
193     require(b <= a);
194     uint256 c = a - b;
195 
196     return c;
197   }
198 
199   /**
200   * @dev Adds two numbers, reverts on overflow.
201   */
202   function add(uint256 a, uint256 b) internal pure returns (uint256) {
203     uint256 c = a + b;
204     require(c >= a);
205 
206     return c;
207   }
208 
209   /**
210   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
211   * reverts when dividing by zero.
212   */
213   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
214     require(b != 0);
215     return a % b;
216   }
217 }
218 
219 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
220 
221 /**
222  * @title Standard ERC20 token
223  *
224  * @dev Implementation of the basic standard token.
225  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
226  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
227  */
228 contract ERC20 is IERC20 {
229   using SafeMath for uint256;
230 
231   mapping (address => uint256) private _balances;
232 
233   mapping (address => mapping (address => uint256)) private _allowed;
234 
235   uint256 private _totalSupply;
236 
237   /**
238   * @dev Total number of tokens in existence
239   */
240   function totalSupply() public view returns (uint256) {
241     return _totalSupply;
242   }
243 
244   /**
245   * @dev Gets the balance of the specified address.
246   * @param owner The address to query the the balance of.
247   * @return An uint256 representing the amount owned by the passed address.
248   */
249   function balanceOf(address owner) public view returns (uint256) {
250     return _balances[owner];
251   }
252 
253   /**
254    * @dev Function to check the amount of tokens that an owner allowed to a spender.
255    * @param owner address The address which owns the funds.
256    * @param spender address The address which will spend the funds.
257    * @return A uint256 specifying the amount of tokens still available for the spender.
258    */
259   function allowance(
260     address owner,
261     address spender
262    )
263     public
264     view
265     returns (uint256)
266   {
267     return _allowed[owner][spender];
268   }
269 
270   /**
271   * @dev Transfer token for a specified address
272   * @param to The address to transfer to.
273   * @param value The amount to be transferred.
274   */
275   function transfer(address to, uint256 value) public returns (bool) {
276     require(value <= _balances[msg.sender]);
277     require(to != address(0));
278 
279     _balances[msg.sender] = _balances[msg.sender].sub(value);
280     _balances[to] = _balances[to].add(value);
281     emit Transfer(msg.sender, to, value);
282     return true;
283   }
284 
285   /**
286    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
287    * Beware that changing an allowance with this method brings the risk that someone may use both the old
288    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
289    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
290    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
291    * @param spender The address which will spend the funds.
292    * @param value The amount of tokens to be spent.
293    */
294   function approve(address spender, uint256 value) public returns (bool) {
295     require(spender != address(0));
296 
297     _allowed[msg.sender][spender] = value;
298     emit Approval(msg.sender, spender, value);
299     return true;
300   }
301 
302   /**
303    * @dev Transfer tokens from one address to another
304    * @param from address The address which you want to send tokens from
305    * @param to address The address which you want to transfer to
306    * @param value uint256 the amount of tokens to be transferred
307    */
308   function transferFrom(
309     address from,
310     address to,
311     uint256 value
312   )
313     public
314     returns (bool)
315   {
316     require(value <= _balances[from]);
317     require(value <= _allowed[from][msg.sender]);
318     require(to != address(0));
319 
320     _balances[from] = _balances[from].sub(value);
321     _balances[to] = _balances[to].add(value);
322     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
323     emit Transfer(from, to, value);
324     return true;
325   }
326 
327   /**
328    * @dev Increase the amount of tokens that an owner allowed to a spender.
329    * approve should be called when allowed_[_spender] == 0. To increment
330    * allowed value is better to use this function to avoid 2 calls (and wait until
331    * the first transaction is mined)
332    * From MonolithDAO Token.sol
333    * @param spender The address which will spend the funds.
334    * @param addedValue The amount of tokens to increase the allowance by.
335    */
336   function increaseAllowance(
337     address spender,
338     uint256 addedValue
339   )
340     public
341     returns (bool)
342   {
343     require(spender != address(0));
344 
345     _allowed[msg.sender][spender] = (
346       _allowed[msg.sender][spender].add(addedValue));
347     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
348     return true;
349   }
350 
351   /**
352    * @dev Decrease the amount of tokens that an owner allowed to a spender.
353    * approve should be called when allowed_[_spender] == 0. To decrement
354    * allowed value is better to use this function to avoid 2 calls (and wait until
355    * the first transaction is mined)
356    * From MonolithDAO Token.sol
357    * @param spender The address which will spend the funds.
358    * @param subtractedValue The amount of tokens to decrease the allowance by.
359    */
360   function decreaseAllowance(
361     address spender,
362     uint256 subtractedValue
363   )
364     public
365     returns (bool)
366   {
367     require(spender != address(0));
368 
369     _allowed[msg.sender][spender] = (
370       _allowed[msg.sender][spender].sub(subtractedValue));
371     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
372     return true;
373   }
374 
375   /**
376    * @dev Internal function that mints an amount of the token and assigns it to
377    * an account. This encapsulates the modification of balances such that the
378    * proper events are emitted.
379    * @param account The account that will receive the created tokens.
380    * @param amount The amount that will be created.
381    */
382   function _mint(address account, uint256 amount) internal {
383     require(account != 0);
384     _totalSupply = _totalSupply.add(amount);
385     _balances[account] = _balances[account].add(amount);
386     emit Transfer(address(0), account, amount);
387   }
388 
389   /**
390    * @dev Internal function that burns an amount of the token of a given
391    * account.
392    * @param account The account whose tokens will be burnt.
393    * @param amount The amount that will be burnt.
394    */
395   function _burn(address account, uint256 amount) internal {
396     require(account != 0);
397     require(amount <= _balances[account]);
398 
399     _totalSupply = _totalSupply.sub(amount);
400     _balances[account] = _balances[account].sub(amount);
401     emit Transfer(account, address(0), amount);
402   }
403 
404   /**
405    * @dev Internal function that burns an amount of the token of a given
406    * account, deducting from the sender's allowance for said account. Uses the
407    * internal burn function.
408    * @param account The account whose tokens will be burnt.
409    * @param amount The amount that will be burnt.
410    */
411   function _burnFrom(address account, uint256 amount) internal {
412     require(amount <= _allowed[account][msg.sender]);
413 
414     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
415     // this function needs to emit an event with the updated approval.
416     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
417       amount);
418     _burn(account, amount);
419   }
420 }
421 
422 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
423 
424 /**
425  * @title Burnable Token
426  * @dev Token that can be irreversibly burned (destroyed).
427  */
428 contract ERC20Burnable is ERC20 {
429 
430   /**
431    * @dev Burns a specific amount of tokens.
432    * @param value The amount of token to be burned.
433    */
434   function burn(uint256 value) public {
435     _burn(msg.sender, value);
436   }
437 
438   /**
439    * @dev Burns a specific amount of tokens from the target address and decrements allowance
440    * @param from address The address which you want to send tokens from
441    * @param value uint256 The amount of token to be burned
442    */
443   function burnFrom(address from, uint256 value) public {
444     _burnFrom(from, value);
445   }
446 
447   /**
448    * @dev Overrides ERC20._burn in order for burn and burnFrom to emit
449    * an additional Burn event.
450    */
451   function _burn(address who, uint256 value) internal {
452     super._burn(who, value);
453   }
454 }
455 
456 // File: openzeppelin-solidity/contracts/access/Roles.sol
457 
458 /**
459  * @title Roles
460  * @dev Library for managing addresses assigned to a Role.
461  */
462 library Roles {
463   struct Role {
464     mapping (address => bool) bearer;
465   }
466 
467   /**
468    * @dev give an account access to this role
469    */
470   function add(Role storage role, address account) internal {
471     require(account != address(0));
472     role.bearer[account] = true;
473   }
474 
475   /**
476    * @dev remove an account's access to this role
477    */
478   function remove(Role storage role, address account) internal {
479     require(account != address(0));
480     role.bearer[account] = false;
481   }
482 
483   /**
484    * @dev check if an account has this role
485    * @return bool
486    */
487   function has(Role storage role, address account)
488     internal
489     view
490     returns (bool)
491   {
492     require(account != address(0));
493     return role.bearer[account];
494   }
495 }
496 
497 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
498 
499 contract MinterRole {
500   using Roles for Roles.Role;
501 
502   event MinterAdded(address indexed account);
503   event MinterRemoved(address indexed account);
504 
505   Roles.Role private minters;
506 
507   constructor() public {
508     minters.add(msg.sender);
509   }
510 
511   modifier onlyMinter() {
512     require(isMinter(msg.sender));
513     _;
514   }
515 
516   function isMinter(address account) public view returns (bool) {
517     return minters.has(account);
518   }
519 
520   function addMinter(address account) public onlyMinter {
521     minters.add(account);
522     emit MinterAdded(account);
523   }
524 
525   function renounceMinter() public {
526     minters.remove(msg.sender);
527   }
528 
529   function _removeMinter(address account) internal {
530     minters.remove(account);
531     emit MinterRemoved(account);
532   }
533 }
534 
535 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
536 
537 /**
538  * @title ERC20Mintable
539  * @dev ERC20 minting logic
540  */
541 contract ERC20Mintable is ERC20, MinterRole {
542   event MintingFinished();
543 
544   bool private _mintingFinished = false;
545 
546   modifier onlyBeforeMintingFinished() {
547     require(!_mintingFinished);
548     _;
549   }
550 
551   /**
552    * @return true if the minting is finished.
553    */
554   function mintingFinished() public view returns(bool) {
555     return _mintingFinished;
556   }
557 
558   /**
559    * @dev Function to mint tokens
560    * @param to The address that will receive the minted tokens.
561    * @param amount The amount of tokens to mint.
562    * @return A boolean that indicates if the operation was successful.
563    */
564   function mint(
565     address to,
566     uint256 amount
567   )
568     public
569     onlyMinter
570     onlyBeforeMintingFinished
571     returns (bool)
572   {
573     _mint(to, amount);
574     return true;
575   }
576 
577   /**
578    * @dev Function to stop minting new tokens.
579    * @return True if the operation was successful.
580    */
581   function finishMinting()
582     public
583     onlyMinter
584     onlyBeforeMintingFinished
585     returns (bool)
586   {
587     _mintingFinished = true;
588     emit MintingFinished();
589     return true;
590   }
591 }
592 
593 // File: contracts/Freezable.sol
594 
595 // Lee, July 29, 2018
596 pragma solidity 0.4.25;
597 
598 
599 contract Freezable is Administratable {
600 
601     bool public frozenToken;
602     mapping (address => bool) public frozenAccounts;
603 
604     event FrozenFunds(address indexed _target, bool _frozen);
605     event FrozenToken(bool _frozen);
606 
607     modifier isNotFrozen( address _to ) {
608         require(!frozenToken);
609         require(!frozenAccounts[msg.sender] && !frozenAccounts[_to]);
610         _;
611     }
612 
613     modifier isNotFrozenFrom( address _from, address _to ) {
614         require(!frozenToken);
615         require(!frozenAccounts[msg.sender] && !frozenAccounts[_from] && !frozenAccounts[_to]);
616         _;
617     }
618 
619     function freezeAccount(address _target, bool _freeze) public onlySuperAdmins validateAddress(_target) {
620         require(frozenAccounts[_target] != _freeze);
621         frozenAccounts[_target] = _freeze;
622         emit FrozenFunds(_target, _freeze);
623     }
624 
625     function freezeToken(bool _freeze) public onlySuperAdmins {
626         require(frozenToken != _freeze);
627         frozenToken = _freeze;
628         emit FrozenToken(frozenToken);
629     }
630 }
631 
632 // File: contracts/Cryptonium.sol
633 
634 // Lee, July 29, 2018
635 pragma solidity 0.4.25;
636 
637 
638 
639 
640 contract Cryptonium is ERC20Burnable, ERC20Mintable, Freezable
641 {
642     string  public  constant name       = "Cryptonium";
643     string  public  constant symbol     = "CRN";
644     uint8   public  constant decimals   = 18;
645     
646     event Burn(address indexed _burner, uint _value);
647 
648     constructor( address _registry, uint _totalTokenAmount ) public
649     {
650         _mint(_registry, _totalTokenAmount);
651         addSuperAdmin(_registry);
652     }
653 
654 
655 
656 
657     /**
658     * @dev Transfer token for a specified address
659     * @param _to The address to transfer to.
660     * @param _value The amount to be transferred.
661     */    
662     function transfer(address _to, uint _value) public validateAddress(_to) isNotFrozen(_to) returns (bool) 
663     {
664         return super.transfer(_to, _value);
665     }
666 
667     /**
668     * @dev Transfer tokens from one address to another
669     * @param _from address The address which you want to send tokens from
670     * @param _to address The address which you want to transfer to
671     * @param _value uint256 the amount of tokens to be transferred
672     */
673     function transferFrom(address _from, address _to, uint _value) public validateAddress(_to)  isNotFrozenFrom(_from, _to) returns (bool) 
674     {
675         return super.transferFrom(_from, _to, _value);
676     }
677 
678     function approve(address _spender, uint256 _value) public validateAddress(_spender) isNotFrozen(_spender)  returns (bool) 
679     {
680         return super.approve(_spender, _value);
681     }
682 
683     function increaseAllowance( address _spender, uint256 _addedValue ) public validateAddress(_spender) isNotFrozen(_spender)  returns (bool)
684     {
685         return super.increaseAllowance(_spender, _addedValue);
686     }
687 
688     function decreaseAllowance(address _spender, uint256 _subtractedValue) public validateAddress(_spender) isNotFrozen(_spender)  returns (bool)
689     {
690         return super.decreaseAllowance(_spender, _subtractedValue);
691     }
692 }
693 
694 // File: contracts/Migrations.sol
695 
696 contract Migrations {
697     address public owner;
698     uint public last_completed_migration;
699 
700     constructor() public {
701         owner = msg.sender;
702     }
703 
704     modifier restricted() {
705         if (msg.sender == owner) _;
706     }
707 
708     function setCompleted(uint completed) public restricted {
709         last_completed_migration = completed;
710     }
711 
712     function upgrade(address new_address) public restricted {
713         Migrations upgraded = Migrations(new_address);
714         upgraded.setCompleted(last_completed_migration);
715     }
716 }