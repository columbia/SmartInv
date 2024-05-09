1 pragma solidity ^0.4.24;
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
114 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
115 
116 /**
117  * @title ERC20 interface
118  * @dev see https://github.com/ethereum/EIPs/issues/20
119  */
120 interface IERC20 {
121   function totalSupply() external view returns (uint256);
122 
123   function balanceOf(address who) external view returns (uint256);
124 
125   function allowance(address owner, address spender)
126     external view returns (uint256);
127 
128   function transfer(address to, uint256 value) external returns (bool);
129 
130   function approve(address spender, uint256 value)
131     external returns (bool);
132 
133   function transferFrom(address from, address to, uint256 value)
134     external returns (bool);
135 
136   event Transfer(
137     address indexed from,
138     address indexed to,
139     uint256 value
140   );
141 
142   event Approval(
143     address indexed owner,
144     address indexed spender,
145     uint256 value
146   );
147 }
148 
149 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
150 
151 /**
152  * @title SafeMath
153  * @dev Math operations with safety checks that revert on error
154  */
155 library SafeMath {
156 
157   /**
158   * @dev Multiplies two numbers, reverts on overflow.
159   */
160   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
161     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
162     // benefit is lost if 'b' is also tested.
163     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
164     if (a == 0) {
165       return 0;
166     }
167 
168     uint256 c = a * b;
169     require(c / a == b);
170 
171     return c;
172   }
173 
174   /**
175   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
176   */
177   function div(uint256 a, uint256 b) internal pure returns (uint256) {
178     require(b > 0); // Solidity only automatically asserts when dividing by 0
179     uint256 c = a / b;
180     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
181 
182     return c;
183   }
184 
185   /**
186   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
187   */
188   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
189     require(b <= a);
190     uint256 c = a - b;
191 
192     return c;
193   }
194 
195   /**
196   * @dev Adds two numbers, reverts on overflow.
197   */
198   function add(uint256 a, uint256 b) internal pure returns (uint256) {
199     uint256 c = a + b;
200     require(c >= a);
201 
202     return c;
203   }
204 
205   /**
206   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
207   * reverts when dividing by zero.
208   */
209   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
210     require(b != 0);
211     return a % b;
212   }
213 }
214 
215 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
216 
217 /**
218  * @title Standard ERC20 token
219  *
220  * @dev Implementation of the basic standard token.
221  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
222  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
223  */
224 contract ERC20 is IERC20 {
225   using SafeMath for uint256;
226 
227   mapping (address => uint256) private _balances;
228 
229   mapping (address => mapping (address => uint256)) private _allowed;
230 
231   uint256 private _totalSupply;
232 
233   /**
234   * @dev Total number of tokens in existence
235   */
236   function totalSupply() public view returns (uint256) {
237     return _totalSupply;
238   }
239 
240   /**
241   * @dev Gets the balance of the specified address.
242   * @param owner The address to query the the balance of.
243   * @return An uint256 representing the amount owned by the passed address.
244   */
245   function balanceOf(address owner) public view returns (uint256) {
246     return _balances[owner];
247   }
248 
249   /**
250    * @dev Function to check the amount of tokens that an owner allowed to a spender.
251    * @param owner address The address which owns the funds.
252    * @param spender address The address which will spend the funds.
253    * @return A uint256 specifying the amount of tokens still available for the spender.
254    */
255   function allowance(
256     address owner,
257     address spender
258    )
259     public
260     view
261     returns (uint256)
262   {
263     return _allowed[owner][spender];
264   }
265 
266   /**
267   * @dev Transfer token for a specified address
268   * @param to The address to transfer to.
269   * @param value The amount to be transferred.
270   */
271   function transfer(address to, uint256 value) public returns (bool) {
272     require(value <= _balances[msg.sender]);
273     require(to != address(0));
274 
275     _balances[msg.sender] = _balances[msg.sender].sub(value);
276     _balances[to] = _balances[to].add(value);
277     emit Transfer(msg.sender, to, value);
278     return true;
279   }
280 
281   /**
282    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
283    * Beware that changing an allowance with this method brings the risk that someone may use both the old
284    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
285    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
286    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
287    * @param spender The address which will spend the funds.
288    * @param value The amount of tokens to be spent.
289    */
290   function approve(address spender, uint256 value) public returns (bool) {
291     require(spender != address(0));
292 
293     _allowed[msg.sender][spender] = value;
294     emit Approval(msg.sender, spender, value);
295     return true;
296   }
297 
298   /**
299    * @dev Transfer tokens from one address to another
300    * @param from address The address which you want to send tokens from
301    * @param to address The address which you want to transfer to
302    * @param value uint256 the amount of tokens to be transferred
303    */
304   function transferFrom(
305     address from,
306     address to,
307     uint256 value
308   )
309     public
310     returns (bool)
311   {
312     require(value <= _balances[from]);
313     require(value <= _allowed[from][msg.sender]);
314     require(to != address(0));
315 
316     _balances[from] = _balances[from].sub(value);
317     _balances[to] = _balances[to].add(value);
318     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
319     emit Transfer(from, to, value);
320     return true;
321   }
322 
323   /**
324    * @dev Increase the amount of tokens that an owner allowed to a spender.
325    * approve should be called when allowed_[_spender] == 0. To increment
326    * allowed value is better to use this function to avoid 2 calls (and wait until
327    * the first transaction is mined)
328    * From MonolithDAO Token.sol
329    * @param spender The address which will spend the funds.
330    * @param addedValue The amount of tokens to increase the allowance by.
331    */
332   function increaseAllowance(
333     address spender,
334     uint256 addedValue
335   )
336     public
337     returns (bool)
338   {
339     require(spender != address(0));
340 
341     _allowed[msg.sender][spender] = (
342       _allowed[msg.sender][spender].add(addedValue));
343     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
344     return true;
345   }
346 
347   /**
348    * @dev Decrease the amount of tokens that an owner allowed to a spender.
349    * approve should be called when allowed_[_spender] == 0. To decrement
350    * allowed value is better to use this function to avoid 2 calls (and wait until
351    * the first transaction is mined)
352    * From MonolithDAO Token.sol
353    * @param spender The address which will spend the funds.
354    * @param subtractedValue The amount of tokens to decrease the allowance by.
355    */
356   function decreaseAllowance(
357     address spender,
358     uint256 subtractedValue
359   )
360     public
361     returns (bool)
362   {
363     require(spender != address(0));
364 
365     _allowed[msg.sender][spender] = (
366       _allowed[msg.sender][spender].sub(subtractedValue));
367     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
368     return true;
369   }
370 
371   /**
372    * @dev Internal function that mints an amount of the token and assigns it to
373    * an account. This encapsulates the modification of balances such that the
374    * proper events are emitted.
375    * @param account The account that will receive the created tokens.
376    * @param amount The amount that will be created.
377    */
378   function _mint(address account, uint256 amount) internal {
379     require(account != 0);
380     _totalSupply = _totalSupply.add(amount);
381     _balances[account] = _balances[account].add(amount);
382     emit Transfer(address(0), account, amount);
383   }
384 
385   /**
386    * @dev Internal function that burns an amount of the token of a given
387    * account.
388    * @param account The account whose tokens will be burnt.
389    * @param amount The amount that will be burnt.
390    */
391   function _burn(address account, uint256 amount) internal {
392     require(account != 0);
393     require(amount <= _balances[account]);
394 
395     _totalSupply = _totalSupply.sub(amount);
396     _balances[account] = _balances[account].sub(amount);
397     emit Transfer(account, address(0), amount);
398   }
399 
400   /**
401    * @dev Internal function that burns an amount of the token of a given
402    * account, deducting from the sender's allowance for said account. Uses the
403    * internal burn function.
404    * @param account The account whose tokens will be burnt.
405    * @param amount The amount that will be burnt.
406    */
407   function _burnFrom(address account, uint256 amount) internal {
408     require(amount <= _allowed[account][msg.sender]);
409 
410     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
411     // this function needs to emit an event with the updated approval.
412     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
413       amount);
414     _burn(account, amount);
415   }
416 }
417 
418 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
419 
420 /**
421  * @title Burnable Token
422  * @dev Token that can be irreversibly burned (destroyed).
423  */
424 contract ERC20Burnable is ERC20 {
425 
426   /**
427    * @dev Burns a specific amount of tokens.
428    * @param value The amount of token to be burned.
429    */
430   function burn(uint256 value) public {
431     _burn(msg.sender, value);
432   }
433 
434   /**
435    * @dev Burns a specific amount of tokens from the target address and decrements allowance
436    * @param from address The address which you want to send tokens from
437    * @param value uint256 The amount of token to be burned
438    */
439   function burnFrom(address from, uint256 value) public {
440     _burnFrom(from, value);
441   }
442 
443   /**
444    * @dev Overrides ERC20._burn in order for burn and burnFrom to emit
445    * an additional Burn event.
446    */
447   function _burn(address who, uint256 value) internal {
448     super._burn(who, value);
449   }
450 }
451 
452 // File: contracts/Whitelistable.sol
453 
454 contract Whitelistable is Administratable {
455     event WhitelistedTransferer(address indexed _transferer, bool _allowTransfer);
456 	mapping (address => bool) public whitelistedTransferer;
457 
458     function setWhitelistedTransferer(address _transferer, bool _allowTransfer) public onlySuperAdmins validateAddress(_transferer) returns (bool) {
459         require(_allowTransfer != whitelistedTransferer[_transferer]);
460         whitelistedTransferer[_transferer] = _allowTransfer;
461         emit WhitelistedTransferer(_transferer, _allowTransfer);
462         return true;
463     }
464 }
465 
466 // File: contracts/Freezable.sol
467 
468 contract Freezable is Whitelistable {
469     bool public frozenToken;
470     mapping (address => bool) public frozenAccounts;
471 
472     event FrozenFunds(address indexed _target, bool _frozen);
473     event FrozenToken(bool _frozen);
474 
475     modifier isNotFrozen( address _to ) {
476         require(!frozenToken);
477         require(whitelistedTransferer[_to] || (!frozenAccounts[msg.sender] && !frozenAccounts[_to]));
478         _;
479     }
480 
481     modifier isNotFrozenFrom( address _from, address _to ) {
482         require(!frozenToken);
483         require(whitelistedTransferer[_to] || (!frozenAccounts[msg.sender] && !frozenAccounts[_from] && !frozenAccounts[_to]));
484         _;
485     }
486 
487     function freezeAccount(address _target, bool _freeze) public onlySuperAdmins validateAddress(_target) {
488         require(frozenAccounts[_target] != _freeze);
489         frozenAccounts[_target] = _freeze;
490         emit FrozenFunds(_target, _freeze);
491     }
492 
493     function freezeToken(bool _freeze) public onlySuperAdmins {
494         require(frozenToken != _freeze);
495         frozenToken = _freeze;
496         emit FrozenToken(frozenToken);
497     }
498 }
499 
500 // File: contracts/TimeLockable.sol
501 
502 // Lee, July 29, 2018
503 pragma solidity ^0.4.24;
504 
505 
506 contract TimeLockable is Whitelistable {
507     mapping (address => uint256) public timelockedAccounts;
508     event LockedFunds(address indexed target, uint256 timelocked);
509 
510     modifier isNotTimeLocked( address _addr ) {
511         require( whitelistedTransferer[_addr] || (now >= timelockedAccounts[msg.sender]));
512         _;
513     }
514 
515     modifier isNotTimeLockedFrom( address _from, address _to) {
516         require( whitelistedTransferer[_to] || ( now >= timelockedAccounts[_from] && now >= timelockedAccounts[msg.sender]));
517         _;
518     }
519     
520     function timeLockAccount(address _target, uint256 _releaseTime) public onlySuperAdmins validateAddress(_target) {
521         require(_releaseTime > now);
522         require(timelockedAccounts[_target] != _releaseTime);
523 
524         timelockedAccounts[_target] = _releaseTime;
525         emit LockedFunds(_target, _releaseTime);
526     }
527 }
528 
529 // File: contracts/BLUCON.sol
530 
531 contract BLUCON is ERC20Burnable, Freezable, TimeLockable
532 {
533     string  public  constant name       = "BLUCON";
534     string  public  constant symbol     = "BEP";
535     uint8   public  constant decimals   = 18;
536     
537     event Burn(address indexed _burner, uint256 _value);
538 
539     constructor( address _registry, uint256 _totalTokenAmount ) public
540     {
541         _mint(_registry, _totalTokenAmount);
542         addSuperAdmin(_registry);
543     }
544 
545     function transfer(address _to, uint256 _value) public validateAddress(_to) isNotTimeLocked(_to) isNotFrozen(_to) returns (bool) 
546     {
547         return super.transfer(_to, _value);
548     }
549 
550     function transferFrom(address _from, address _to, uint256 _value) public validateAddress(_to) isNotTimeLockedFrom(_from, _to) isNotFrozenFrom(_from, _to) returns (bool) 
551     {
552         return super.transferFrom(_from, _to, _value);
553     }
554 
555     function approve(address _spender, uint256 _value) public validateAddress(_spender) isNotFrozen(_spender) isNotTimeLocked(_spender) returns (bool) 
556     {
557         return super.approve(_spender, _value);
558     }
559 
560     function increaseAllowance( address _spender, uint256 _addedValue ) public validateAddress(_spender) isNotFrozen(_spender) isNotTimeLocked(_spender) returns (bool)
561     {
562         return super.increaseAllowance(_spender, _addedValue);
563     }
564 
565     function decreaseAllowance(address _spender, uint256 _subtractedValue) public validateAddress(_spender) isNotFrozen(_spender) isNotTimeLocked(_spender) returns (bool)
566     {
567         return super.decreaseAllowance(_spender, _subtractedValue);
568     }
569 }
570 
571 // File: contracts/Migrations.sol
572 
573 contract Migrations {
574     address public owner;
575     uint public last_completed_migration;
576 
577     constructor() public {
578         owner = msg.sender;
579     }
580 
581     modifier restricted() {
582         if (msg.sender == owner) _;
583     }
584 
585     function setCompleted(uint completed) public restricted {
586         last_completed_migration = completed;
587     }
588 
589     function upgrade(address new_address) public restricted {
590         Migrations upgraded = Migrations(new_address);
591         upgraded.setCompleted(last_completed_migration);
592     }
593 }