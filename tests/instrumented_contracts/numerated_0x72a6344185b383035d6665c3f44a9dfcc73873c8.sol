1 /**
2  *Submitted for verification at Etherscan.io on 2019-05-28
3 */
4 
5 pragma solidity ^0.4.24;
6 
7 // File: contracts/openzeppelin/ownership/Ownable.sol
8 
9 /**
10  * @title Ownable
11  * @dev The Ownable contract has an owner address, and provides basic authorization control
12  * functions, this simplifies the implementation of "user permissions".
13  */
14 contract Ownable {
15   address private _owner;
16   event OwnershipRenounced(address indexed previousOwner);
17   event OwnershipTransferred(
18     address indexed previousOwner,
19     address indexed newOwner
20   );
21 
22 
23   /**
24    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
25    * account.
26    */
27   constructor() public {
28     _owner = msg.sender;
29   }
30 
31   /**
32    * @return the address of the owner.
33    */
34   function owner() public view returns(address) {
35     return _owner;
36   }
37 
38   /**
39    * @dev Throws if called by any account other than the owner.
40    */
41   modifier onlyOwner() {
42     require(isOwner());
43     _;
44   }
45 
46   /**
47    * @return true if `msg.sender` is the owner of the contract.
48    */
49   function isOwner() public view returns(bool) {
50     return msg.sender == _owner;
51   }
52 
53   /**
54    * @dev Allows the current owner to relinquish control of the contract.
55    * @notice Renouncing to ownership will leave the contract without an owner.
56    * It will not be possible to call the functions with the `onlyOwner`
57    * modifier anymore.
58    */
59   function renounceOwnership() public onlyOwner {
60     emit OwnershipRenounced(_owner);
61     _owner = address(0);
62   }
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) public onlyOwner {
69     _transferOwnership(newOwner);
70   }
71 
72   /**
73    * @dev Transfers control of the contract to a newOwner.
74    * @param newOwner The address to transfer ownership to.
75    */
76   function _transferOwnership(address newOwner) internal {
77     require(newOwner != address(0));
78     emit OwnershipTransferred(_owner, newOwner);
79     _owner = newOwner;
80   }
81 }
82 
83 // File: contracts/Administratable.sol
84 
85 pragma solidity 0.4.24;
86 
87 // August 21, 2018
88 // remove all admin code.
89 
90 
91 contract Administratable is Ownable {
92 	mapping (address => bool) public superAdmins;
93 
94 	event AddSuperAdmin(address indexed admin);
95 	event RemoveSuperAdmin(address indexed admin);
96 
97 
98     modifier validateAddress( address _addr )
99     {
100         require(_addr != address(0x0));
101         require(_addr != address(this));
102         _;
103     }
104 
105 	modifier onlySuperAdmins {
106 		require(msg.sender == owner() || superAdmins[msg.sender]);
107 		_;
108 	}
109 
110 	function addSuperAdmin(address _admin) public onlyOwner validateAddress(_admin){
111 		require(!superAdmins[_admin]);
112 		superAdmins[_admin] = true;
113 		emit AddSuperAdmin(_admin);
114 	}
115 
116 	function removeSuperAdmin(address _admin) public onlyOwner validateAddress(_admin){
117 		require(superAdmins[_admin]);
118 		superAdmins[_admin] = false;
119 		emit RemoveSuperAdmin(_admin);
120 	}
121 }
122 
123 // File: contracts/TimeLockable.sol
124 
125 pragma solidity 0.4.24;
126 
127 
128 contract TimeLockable is Administratable{
129 
130     uint256 private constant ADVISOR_LOCKUP_END     = 0; 
131     uint256 private constant TEAM_LOCKUP_END        = 0; 
132 
133     mapping (address => uint256) public timelockedAccounts;
134     event LockedFunds(address indexed target, uint256 timelocked);
135 
136     modifier isNotTimeLocked() {
137         require(now >= timelockedAccounts[msg.sender]);
138         _;
139     }
140 
141     modifier isNotTimeLockedFrom( address _from ) {
142         require(now >= timelockedAccounts[_from] && now >= timelockedAccounts[msg.sender]);
143         _;
144     }
145 
146     function timeLockAdvisor(address _target) public onlySuperAdmins validateAddress(_target) {
147         require(timelockedAccounts[_target] == 0);
148         timelockedAccounts[_target] = ADVISOR_LOCKUP_END;
149         emit LockedFunds(_target, ADVISOR_LOCKUP_END);
150     }
151 
152     function timeLockTeam(address _target) public onlySuperAdmins validateAddress(_target) {
153         require(timelockedAccounts[_target] == 0);
154         timelockedAccounts[_target] = TEAM_LOCKUP_END;
155         emit LockedFunds(_target, TEAM_LOCKUP_END);
156     }
157 }
158 
159 // File: contracts/Freezable.sol
160 pragma solidity 0.4.24;
161 
162 
163 contract Freezable is Administratable {
164 
165     bool public frozenToken;
166     mapping (address => bool) public frozenAccounts;
167 
168     event FrozenFunds(address indexed _target, bool _frozen);
169     event FrozenToken(bool _frozen);
170 
171     modifier isNotFrozen( address _to ) {
172         require(!frozenToken);
173         require(!frozenAccounts[msg.sender] && !frozenAccounts[_to]);
174         _;
175     }
176 
177     modifier isNotFrozenFrom( address _from, address _to ) {
178         require(!frozenToken);
179         require(!frozenAccounts[msg.sender] && !frozenAccounts[_from] && !frozenAccounts[_to]);
180         _;
181     }
182 
183     function freezeAccount(address _target, bool _freeze) public onlySuperAdmins validateAddress(_target) {
184         require(frozenAccounts[_target] != _freeze);
185         frozenAccounts[_target] = _freeze;
186         emit FrozenFunds(_target, _freeze);
187     }
188 
189     function freezeToken(bool _freeze) public onlySuperAdmins {
190         require(frozenToken != _freeze);
191         frozenToken = _freeze;
192         emit FrozenToken(frozenToken);
193     }
194 }
195 
196 // File: contracts/openzeppelin/token/ERC20/IERC20.sol
197 
198 /**
199  * @title ERC20 interface
200  * @dev see https://github.com/ethereum/EIPs/issues/20
201  */
202 interface IERC20 {
203   function totalSupply() external view returns (uint256);
204 
205   function balanceOf(address who) external view returns (uint256);
206 
207   function allowance(address owner, address spender)
208     external view returns (uint256);
209 
210   function transfer(address to, uint256 value) external returns (bool);
211 
212   function approve(address spender, uint256 value)
213     external returns (bool);
214 
215   function transferFrom(address from, address to, uint256 value)
216     external returns (bool);
217 
218   event Transfer(
219     address indexed from,
220     address indexed to,
221     uint256 value
222   );
223 
224   event Approval(
225     address indexed owner,
226     address indexed spender,
227     uint256 value
228   );
229 }
230 
231 // File: contracts/openzeppelin/math/SafeMath.sol
232 
233 /**
234  * @title SafeMath
235  * @dev Math operations with safety checks that revert on error
236  */
237 library SafeMath {
238 
239   /**
240   * @dev Multiplies two numbers, reverts on overflow.
241   */
242   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
243     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
244     // benefit is lost if 'b' is also tested.
245     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
246     if (a == 0) {
247       return 0;
248     }
249 
250     uint256 c = a * b;
251     require(c / a == b);
252 
253     return c;
254   }
255 
256   /**
257   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
258   */
259   function div(uint256 a, uint256 b) internal pure returns (uint256) {
260     require(b > 0); // Solidity only automatically asserts when dividing by 0
261     uint256 c = a / b;
262     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
263 
264     return c;
265   }
266 
267   /**
268   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
269   */
270   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
271     require(b <= a);
272     uint256 c = a - b;
273 
274     return c;
275   }
276 
277   /**
278   * @dev Adds two numbers, reverts on overflow.
279   */
280   function add(uint256 a, uint256 b) internal pure returns (uint256) {
281     uint256 c = a + b;
282     require(c >= a);
283 
284     return c;
285   }
286 
287   /**
288   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
289   * reverts when dividing by zero.
290   */
291   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
292     require(b != 0);
293     return a % b;
294   }
295 }
296 
297 // File: contracts/openzeppelin/token/ERC20/ERC20.sol
298 
299 /**
300  * @title Standard ERC20 token
301  *
302  * @dev Implementation of the basic standard token.
303  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
304  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
305  */
306 contract ERC20 is IERC20 {
307   using SafeMath for uint256;
308 
309   mapping (address => uint256) private _balances;
310 
311   mapping (address => mapping (address => uint256)) private _allowed;
312 
313   uint256 private _totalSupply;
314 
315   /**
316   * @dev Total number of tokens in existence
317   */
318   function totalSupply() public view returns (uint256) {
319     return _totalSupply;
320   }
321 
322   /**
323   * @dev Gets the balance of the specified address.
324   * @param owner The address to query the balance of.
325   * @return An uint256 representing the amount owned by the passed address.
326   */
327   function balanceOf(address owner) public view returns (uint256) {
328     return _balances[owner];
329   }
330 
331   /**
332    * @dev Function to check the amount of tokens that an owner allowed to a spender.
333    * @param owner address The address which owns the funds.
334    * @param spender address The address which will spend the funds.
335    * @return A uint256 specifying the amount of tokens still available for the spender.
336    */
337   function allowance(
338     address owner,
339     address spender
340    )
341     public
342     view
343     returns (uint256)
344   {
345     return _allowed[owner][spender];
346   }
347 
348   /**
349   * @dev Transfer token for a specified address
350   * @param to The address to transfer to.
351   * @param value The amount to be transferred.
352   */
353   function transfer(address to, uint256 value) public returns (bool) {
354     require(value <= _balances[msg.sender]);
355     require(to != address(0));
356 
357     _balances[msg.sender] = _balances[msg.sender].sub(value);
358     _balances[to] = _balances[to].add(value);
359     emit Transfer(msg.sender, to, value);
360     return true;
361   }
362 
363   /**
364    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
365    * Beware that changing an allowance with this method brings the risk that someone may use both the old
366    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
367    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
368    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
369    * @param spender The address which will spend the funds.
370    * @param value The amount of tokens to be spent.
371    */
372   function approve(address spender, uint256 value) public returns (bool) {
373     require(spender != address(0));
374 
375     _allowed[msg.sender][spender] = value;
376     emit Approval(msg.sender, spender, value);
377     return true;
378   }
379 
380   /**
381    * @dev Transfer tokens from one address to another
382    * @param from address The address which you want to send tokens from
383    * @param to address The address which you want to transfer to
384    * @param value uint256 the amount of tokens to be transferred
385    */
386   function transferFrom(
387     address from,
388     address to,
389     uint256 value
390   )
391     public
392     returns (bool)
393   {
394     require(value <= _balances[from]);
395     require(value <= _allowed[from][msg.sender]);
396     require(to != address(0));
397 
398     _balances[from] = _balances[from].sub(value);
399     _balances[to] = _balances[to].add(value);
400     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
401     emit Transfer(from, to, value);
402     return true;
403   }
404 
405   /**
406    * @dev Increase the amount of tokens that an owner allowed to a spender.
407    * approve should be called when allowed_[_spender] == 0. To increment
408    * allowed value is better to use this function to avoid 2 calls (and wait until
409    * the first transaction is mined)
410    * From MonolithDAO Token.sol
411    * @param spender The address which will spend the funds.
412    * @param addedValue The amount of tokens to increase the allowance by.
413    */
414   function increaseAllowance(
415     address spender,
416     uint256 addedValue
417   )
418     public
419     returns (bool)
420   {
421     require(spender != address(0));
422 
423     _allowed[msg.sender][spender] = (
424       _allowed[msg.sender][spender].add(addedValue));
425     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
426     return true;
427   }
428 
429   /**
430    * @dev Decrease the amount of tokens that an owner allowed to a spender.
431    * approve should be called when allowed_[_spender] == 0. To decrement
432    * allowed value is better to use this function to avoid 2 calls (and wait until
433    * the first transaction is mined)
434    * From MonolithDAO Token.sol
435    * @param spender The address which will spend the funds.
436    * @param subtractedValue The amount of tokens to decrease the allowance by.
437    */
438   function decreaseAllowance(
439     address spender,
440     uint256 subtractedValue
441   )
442     public
443     returns (bool)
444   {
445     require(spender != address(0));
446 
447     _allowed[msg.sender][spender] = (
448       _allowed[msg.sender][spender].sub(subtractedValue));
449     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
450     return true;
451   }
452 
453   /**
454    * @dev Internal function that mints an amount of the token and assigns it to
455    * an account. This encapsulates the modification of balances such that the
456    * proper events are emitted.
457    * @param account The account that will receive the created tokens.
458    * @param amount The amount that will be created.
459    */
460   function _mint(address account, uint256 amount) internal {
461     require(account != 0);
462     _totalSupply = _totalSupply.add(amount);
463     _balances[account] = _balances[account].add(amount);
464     emit Transfer(address(0), account, amount);
465   }
466 
467   /**
468    * @dev Internal function that burns an amount of the token of a given
469    * account.
470    * @param account The account whose tokens will be burnt.
471    * @param amount The amount that will be burnt.
472    */
473   function _burn(address account, uint256 amount) internal {
474     require(account != 0);
475     require(amount <= _balances[account]);
476 
477     _totalSupply = _totalSupply.sub(amount);
478     _balances[account] = _balances[account].sub(amount);
479     emit Transfer(account, address(0), amount);
480   }
481 
482   /**
483    * @dev Internal function that burns an amount of the token of a given
484    * account, deducting from the sender's allowance for said account. Uses the
485    * internal burn function.
486    * @param account The account whose tokens will be burnt.
487    * @param amount The amount that will be burnt.
488    */
489   function _burnFrom(address account, uint256 amount) internal {
490     require(amount <= _allowed[account][msg.sender]);
491 
492     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
493     // this function needs to emit an event with the updated approval.
494     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
495       amount);
496     _burn(account, amount);
497   }
498 }
499 
500 // File: contracts/openzeppelin/token/ERC20/ERC20Burnable.sol
501 
502 /**
503  * @title Burnable Token
504  * @dev Token that can be irreversibly burned (destroyed).
505  */
506 contract ERC20Burnable is ERC20 {
507 
508   /**
509    * @dev Burns a specific amount of tokens.
510    * @param value The amount of token to be burned.
511    */
512   function burn(uint256 value) public {
513     _burn(msg.sender, value);
514   }
515 
516   /**
517    * @dev Burns a specific amount of tokens from the target address and decrements allowance
518    * @param from address The address which you want to send tokens from
519    * @param value uint256 The amount of token to be burned
520    */
521   function burnFrom(address from, uint256 value) public {
522     _burnFrom(from, value);
523   }
524 
525   /**
526    * @dev Overrides ERC20._burn in order for burn and burnFrom to emit
527    * an additional Burn event.
528    */
529   function _burn(address who, uint256 value) internal {
530     super._burn(who, value);
531   }
532 }
533 
534 pragma solidity 0.4.24;
535 
536 contract RoonexToken is ERC20Burnable, TimeLockable, Freezable
537 {
538     string 	public 	constant name 		= "ROONEX";
539     string 	public 	constant symbol 	= "RNX";
540     uint8 	public 	constant decimals 	= 18;
541     
542     event Burn(address indexed _burner, uint _value);
543 
544     constructor( address _registry, uint _totalTokenAmount ) public
545     {
546         _mint(_registry, _totalTokenAmount);
547         addSuperAdmin(_registry);
548     }
549 
550 
551     /**
552     * @dev Transfer token for a specified address
553     * @param _to The address to transfer to.
554     * @param _value The amount to be transferred.
555     */    
556     function transfer(address _to, uint _value) public validateAddress(_to) isNotTimeLocked() isNotFrozen(_to) returns (bool) 
557     {
558         return super.transfer(_to, _value);
559     }
560 
561     /**
562     * @dev Transfer tokens from one address to another
563     * @param _from address The address which you want to send tokens from
564     * @param _to address The address which you want to transfer to
565     * @param _value uint256 the amount of tokens to be transferred
566     */
567     function transferFrom(address _from, address _to, uint _value) public validateAddress(_to) isNotTimeLockedFrom(_from) isNotFrozenFrom(_from, _to) returns (bool) 
568     {
569         return super.transferFrom(_from, _to, _value);
570     }
571 
572     function approve(address _spender, uint256 _value) public validateAddress(_spender) isNotFrozen(_spender) isNotTimeLocked() returns (bool) 
573     {
574         return super.approve(_spender, _value);
575     }
576 
577     function increaseAllowance( address _spender, uint256 _addedValue ) public validateAddress(_spender) isNotFrozen(_spender) isNotTimeLocked() returns (bool)
578     {
579         return super.increaseAllowance(_spender, _addedValue);
580     }
581 
582     function decreaseAllowance(address _spender, uint256 _subtractedValue) public validateAddress(_spender) isNotFrozen(_spender) isNotTimeLocked() returns (bool)
583     {
584         return super.decreaseAllowance(_spender, _subtractedValue);
585     }
586 
587 
588     /**
589     * @dev Token Contract Emergency Drain
590     * @param _token - Token to drain
591     * @param _amount - Amount to drain
592     */
593     function emergencyERC20Drain( IERC20 _token, uint _amount ) public onlyOwner {
594         _token.transfer( owner(), _amount );
595     }
596 }