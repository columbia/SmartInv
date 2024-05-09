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
83 contract Administratable is Ownable {
84 	mapping (address => bool) public superAdmins;
85 
86 	event AddSuperAdmin(address indexed admin);
87 	event RemoveSuperAdmin(address indexed admin);
88 
89     modifier validateAddress( address _addr )
90     {
91         require(_addr != address(0x0));
92         require(_addr != address(this));
93         _;
94     }
95 
96 	modifier onlySuperAdmins {
97 		require(msg.sender == owner() || superAdmins[msg.sender]);
98 		_;
99 	}
100 
101 	function addSuperAdmin(address _admin) public onlyOwner validateAddress(_admin){
102 		require(!superAdmins[_admin]);
103 		superAdmins[_admin] = true;
104 		emit AddSuperAdmin(_admin);
105 	}
106 
107 	function removeSuperAdmin(address _admin) public onlyOwner validateAddress(_admin){
108 		require(superAdmins[_admin]);
109 		superAdmins[_admin] = false;
110 		emit RemoveSuperAdmin(_admin);
111 	}
112 }
113 
114 // File: contracts/Freezable.sol
115 
116 contract Freezable is Administratable {
117 
118     bool public frozenToken;
119     mapping (address => bool) public frozenAccounts;
120 
121     event FrozenFunds(address indexed _target, bool _frozen);
122     event FrozenToken(bool _frozen);
123 
124     modifier isNotFrozen( address _to ) {
125         require(!frozenToken);
126         require(!frozenAccounts[msg.sender] && !frozenAccounts[_to]);
127         _;
128     }
129 
130     modifier isNotFrozenFrom( address _from, address _to ) {
131         require(!frozenToken);
132         require(!frozenAccounts[msg.sender] && !frozenAccounts[_from] && !frozenAccounts[_to]);
133         _;
134     }
135 
136     function freezeAccount(address _target, bool _freeze) public onlySuperAdmins validateAddress(_target) {
137         require(frozenAccounts[_target] != _freeze);
138         frozenAccounts[_target] = _freeze;
139         emit FrozenFunds(_target, _freeze);
140     }
141 
142     function freezeToken(bool _freeze) public onlySuperAdmins {
143         require(frozenToken != _freeze);
144         frozenToken = _freeze;
145         emit FrozenToken(frozenToken);
146     }
147 }
148 
149 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
150 
151 /**
152  * @title ERC20 interface
153  * @dev see https://github.com/ethereum/EIPs/issues/20
154  */
155 interface IERC20 {
156   function totalSupply() external view returns (uint256);
157 
158   function balanceOf(address who) external view returns (uint256);
159 
160   function allowance(address owner, address spender)
161     external view returns (uint256);
162 
163   function transfer(address to, uint256 value) external returns (bool);
164 
165   function approve(address spender, uint256 value)
166     external returns (bool);
167 
168   function transferFrom(address from, address to, uint256 value)
169     external returns (bool);
170 
171   event Transfer(
172     address indexed from,
173     address indexed to,
174     uint256 value
175   );
176 
177   event Approval(
178     address indexed owner,
179     address indexed spender,
180     uint256 value
181   );
182 }
183 
184 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
185 
186 /**
187  * @title SafeMath
188  * @dev Math operations with safety checks that revert on error
189  */
190 library SafeMath {
191 
192   /**
193   * @dev Multiplies two numbers, reverts on overflow.
194   */
195   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
196     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
197     // benefit is lost if 'b' is also tested.
198     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
199     if (a == 0) {
200       return 0;
201     }
202 
203     uint256 c = a * b;
204     require(c / a == b);
205 
206     return c;
207   }
208 
209   /**
210   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
211   */
212   function div(uint256 a, uint256 b) internal pure returns (uint256) {
213     require(b > 0); // Solidity only automatically asserts when dividing by 0
214     uint256 c = a / b;
215     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
216 
217     return c;
218   }
219 
220   /**
221   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
222   */
223   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
224     require(b <= a);
225     uint256 c = a - b;
226 
227     return c;
228   }
229 
230   /**
231   * @dev Adds two numbers, reverts on overflow.
232   */
233   function add(uint256 a, uint256 b) internal pure returns (uint256) {
234     uint256 c = a + b;
235     require(c >= a);
236 
237     return c;
238   }
239 
240   /**
241   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
242   * reverts when dividing by zero.
243   */
244   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
245     require(b != 0);
246     return a % b;
247   }
248 }
249 
250 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
251 
252 /**
253  * @title Standard ERC20 token
254  *
255  * @dev Implementation of the basic standard token.
256  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
257  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
258  */
259 contract ERC20 is IERC20 {
260   using SafeMath for uint256;
261 
262   mapping (address => uint256) private _balances;
263 
264   mapping (address => mapping (address => uint256)) private _allowed;
265 
266   uint256 private _totalSupply;
267 
268   /**
269   * @dev Total number of tokens in existence
270   */
271   function totalSupply() public view returns (uint256) {
272     return _totalSupply;
273   }
274 
275   /**
276   * @dev Gets the balance of the specified address.
277   * @param owner The address to query the the balance of.
278   * @return An uint256 representing the amount owned by the passed address.
279   */
280   function balanceOf(address owner) public view returns (uint256) {
281     return _balances[owner];
282   }
283 
284   /**
285    * @dev Function to check the amount of tokens that an owner allowed to a spender.
286    * @param owner address The address which owns the funds.
287    * @param spender address The address which will spend the funds.
288    * @return A uint256 specifying the amount of tokens still available for the spender.
289    */
290   function allowance(
291     address owner,
292     address spender
293    )
294     public
295     view
296     returns (uint256)
297   {
298     return _allowed[owner][spender];
299   }
300 
301   /**
302   * @dev Transfer token for a specified address
303   * @param to The address to transfer to.
304   * @param value The amount to be transferred.
305   */
306   function transfer(address to, uint256 value) public returns (bool) {
307     require(value <= _balances[msg.sender]);
308     require(to != address(0));
309 
310     _balances[msg.sender] = _balances[msg.sender].sub(value);
311     _balances[to] = _balances[to].add(value);
312     emit Transfer(msg.sender, to, value);
313     return true;
314   }
315 
316   /**
317    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
318    * Beware that changing an allowance with this method brings the risk that someone may use both the old
319    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
320    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
321    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
322    * @param spender The address which will spend the funds.
323    * @param value The amount of tokens to be spent.
324    */
325   function approve(address spender, uint256 value) public returns (bool) {
326     require(spender != address(0));
327 
328     _allowed[msg.sender][spender] = value;
329     emit Approval(msg.sender, spender, value);
330     return true;
331   }
332 
333   /**
334    * @dev Transfer tokens from one address to another
335    * @param from address The address which you want to send tokens from
336    * @param to address The address which you want to transfer to
337    * @param value uint256 the amount of tokens to be transferred
338    */
339   function transferFrom(
340     address from,
341     address to,
342     uint256 value
343   )
344     public
345     returns (bool)
346   {
347     require(value <= _balances[from]);
348     require(value <= _allowed[from][msg.sender]);
349     require(to != address(0));
350 
351     _balances[from] = _balances[from].sub(value);
352     _balances[to] = _balances[to].add(value);
353     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
354     emit Transfer(from, to, value);
355     return true;
356   }
357 
358   /**
359    * @dev Increase the amount of tokens that an owner allowed to a spender.
360    * approve should be called when allowed_[_spender] == 0. To increment
361    * allowed value is better to use this function to avoid 2 calls (and wait until
362    * the first transaction is mined)
363    * From MonolithDAO Token.sol
364    * @param spender The address which will spend the funds.
365    * @param addedValue The amount of tokens to increase the allowance by.
366    */
367   function increaseAllowance(
368     address spender,
369     uint256 addedValue
370   )
371     public
372     returns (bool)
373   {
374     require(spender != address(0));
375 
376     _allowed[msg.sender][spender] = (
377       _allowed[msg.sender][spender].add(addedValue));
378     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
379     return true;
380   }
381 
382   /**
383    * @dev Decrease the amount of tokens that an owner allowed to a spender.
384    * approve should be called when allowed_[_spender] == 0. To decrement
385    * allowed value is better to use this function to avoid 2 calls (and wait until
386    * the first transaction is mined)
387    * From MonolithDAO Token.sol
388    * @param spender The address which will spend the funds.
389    * @param subtractedValue The amount of tokens to decrease the allowance by.
390    */
391   function decreaseAllowance(
392     address spender,
393     uint256 subtractedValue
394   )
395     public
396     returns (bool)
397   {
398     require(spender != address(0));
399 
400     _allowed[msg.sender][spender] = (
401       _allowed[msg.sender][spender].sub(subtractedValue));
402     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
403     return true;
404   }
405 
406   /**
407    * @dev Internal function that mints an amount of the token and assigns it to
408    * an account. This encapsulates the modification of balances such that the
409    * proper events are emitted.
410    * @param account The account that will receive the created tokens.
411    * @param amount The amount that will be created.
412    */
413   function _mint(address account, uint256 amount) internal {
414     require(account != 0);
415     _totalSupply = _totalSupply.add(amount);
416     _balances[account] = _balances[account].add(amount);
417     emit Transfer(address(0), account, amount);
418   }
419 
420   /**
421    * @dev Internal function that burns an amount of the token of a given
422    * account.
423    * @param account The account whose tokens will be burnt.
424    * @param amount The amount that will be burnt.
425    */
426   function _burn(address account, uint256 amount) internal {
427     require(account != 0);
428     require(amount <= _balances[account]);
429 
430     _totalSupply = _totalSupply.sub(amount);
431     _balances[account] = _balances[account].sub(amount);
432     emit Transfer(account, address(0), amount);
433   }
434 
435   /**
436    * @dev Internal function that burns an amount of the token of a given
437    * account, deducting from the sender's allowance for said account. Uses the
438    * internal burn function.
439    * @param account The account whose tokens will be burnt.
440    * @param amount The amount that will be burnt.
441    */
442   function _burnFrom(address account, uint256 amount) internal {
443     require(amount <= _allowed[account][msg.sender]);
444 
445     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
446     // this function needs to emit an event with the updated approval.
447     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
448       amount);
449     _burn(account, amount);
450   }
451 }
452 
453 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
454 
455 /**
456  * @title Burnable Token
457  * @dev Token that can be irreversibly burned (destroyed).
458  */
459 contract ERC20Burnable is ERC20 {
460 
461   /**
462    * @dev Burns a specific amount of tokens.
463    * @param value The amount of token to be burned.
464    */
465   function burn(uint256 value) public {
466     _burn(msg.sender, value);
467   }
468 
469   /**
470    * @dev Burns a specific amount of tokens from the target address and decrements allowance
471    * @param from address The address which you want to send tokens from
472    * @param value uint256 The amount of token to be burned
473    */
474   function burnFrom(address from, uint256 value) public {
475     _burnFrom(from, value);
476   }
477 
478   /**
479    * @dev Overrides ERC20._burn in order for burn and burnFrom to emit
480    * an additional Burn event.
481    */
482   function _burn(address who, uint256 value) internal {
483     super._burn(who, value);
484   }
485 }
486 
487 // File: openzeppelin-solidity/contracts/access/Roles.sol
488 
489 /**
490  * @title Roles
491  * @dev Library for managing addresses assigned to a Role.
492  */
493 library Roles {
494   struct Role {
495     mapping (address => bool) bearer;
496   }
497 
498   /**
499    * @dev give an account access to this role
500    */
501   function add(Role storage role, address account) internal {
502     require(account != address(0));
503     role.bearer[account] = true;
504   }
505 
506   /**
507    * @dev remove an account's access to this role
508    */
509   function remove(Role storage role, address account) internal {
510     require(account != address(0));
511     role.bearer[account] = false;
512   }
513 
514   /**
515    * @dev check if an account has this role
516    * @return bool
517    */
518   function has(Role storage role, address account)
519     internal
520     view
521     returns (bool)
522   {
523     require(account != address(0));
524     return role.bearer[account];
525   }
526 }
527 
528 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
529 
530 contract MinterRole {
531   using Roles for Roles.Role;
532 
533   event MinterAdded(address indexed account);
534   event MinterRemoved(address indexed account);
535 
536   Roles.Role private minters;
537 
538   constructor() public {
539     minters.add(msg.sender);
540   }
541 
542   modifier onlyMinter() {
543     require(isMinter(msg.sender));
544     _;
545   }
546 
547   function isMinter(address account) public view returns (bool) {
548     return minters.has(account);
549   }
550 
551   function addMinter(address account) public onlyMinter {
552     minters.add(account);
553     emit MinterAdded(account);
554   }
555 
556   function renounceMinter() public {
557     minters.remove(msg.sender);
558   }
559 
560   function _removeMinter(address account) internal {
561     minters.remove(account);
562     emit MinterRemoved(account);
563   }
564 }
565 
566 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
567 
568 /**
569  * @title ERC20Mintable
570  * @dev ERC20 minting logic
571  */
572 contract ERC20Mintable is ERC20, MinterRole {
573   event MintingFinished();
574 
575   bool private _mintingFinished = false;
576 
577   modifier onlyBeforeMintingFinished() {
578     require(!_mintingFinished);
579     _;
580   }
581 
582   /**
583    * @return true if the minting is finished.
584    */
585   function mintingFinished() public view returns(bool) {
586     return _mintingFinished;
587   }
588 
589   /**
590    * @dev Function to mint tokens
591    * @param to The address that will receive the minted tokens.
592    * @param amount The amount of tokens to mint.
593    * @return A boolean that indicates if the operation was successful.
594    */
595   function mint(
596     address to,
597     uint256 amount
598   )
599     public
600     onlyMinter
601     onlyBeforeMintingFinished
602     returns (bool)
603   {
604     _mint(to, amount);
605     return true;
606   }
607 
608   /**
609    * @dev Function to stop minting new tokens.
610    * @return True if the operation was successful.
611    */
612   function finishMinting()
613     public
614     onlyMinter
615     onlyBeforeMintingFinished
616     returns (bool)
617   {
618     _mintingFinished = true;
619     emit MintingFinished();
620     return true;
621   }
622 }
623 
624 // File: contracts/TOXToken.sol
625 
626 contract TOXToken is ERC20Burnable, ERC20Mintable, Freezable
627 {
628     string  public  constant name       = "TokenX";
629     string  public  constant symbol     = "TOX";
630     uint8   public  constant decimals   = 18;
631     
632     event Burn(address indexed _burner, uint _value);
633 
634     constructor( address _registry, uint _totalTokenAmount ) public
635     {
636         _mint(_registry, _totalTokenAmount);
637         addSuperAdmin(_registry);
638     }
639 
640 
641 
642 
643     /**
644     * @dev Transfer token for a specified address
645     * @param _to The address to transfer to.
646     * @param _value The amount to be transferred.
647     */    
648     function transfer(address _to, uint _value) public validateAddress(_to) isNotFrozen(_to) returns (bool) 
649     {
650         return super.transfer(_to, _value);
651     }
652 
653     /**
654     * @dev Transfer tokens from one address to another
655     * @param _from address The address which you want to send tokens from
656     * @param _to address The address which you want to transfer to
657     * @param _value uint256 the amount of tokens to be transferred
658     */
659     function transferFrom(address _from, address _to, uint _value) public validateAddress(_to)  isNotFrozenFrom(_from, _to) returns (bool) 
660     {
661         return super.transferFrom(_from, _to, _value);
662     }
663 
664     function approve(address _spender, uint256 _value) public validateAddress(_spender) isNotFrozen(_spender)  returns (bool) 
665     {
666         return super.approve(_spender, _value);
667     }
668 
669     function increaseAllowance( address _spender, uint256 _addedValue ) public validateAddress(_spender) isNotFrozen(_spender)  returns (bool)
670     {
671         return super.increaseAllowance(_spender, _addedValue);
672     }
673 
674     function decreaseAllowance(address _spender, uint256 _subtractedValue) public validateAddress(_spender) isNotFrozen(_spender)  returns (bool)
675     {
676         return super.decreaseAllowance(_spender, _subtractedValue);
677     }
678 }
679 
680 // File: contracts/Migrations.sol
681 
682 contract Migrations {
683     address public owner;
684     uint public last_completed_migration;
685 
686     constructor() public {
687         owner = msg.sender;
688     }
689 
690     modifier restricted() {
691         if (msg.sender == owner) _;
692     }
693 
694     function setCompleted(uint completed) public restricted {
695         last_completed_migration = completed;
696     }
697 
698     function upgrade(address new_address) public restricted {
699         Migrations upgraded = Migrations(new_address);
700         upgraded.setCompleted(last_completed_migration);
701     }
702 }