1 pragma solidity ^0.4.24;
2 
3 // File: contracts/openzeppelin/ownership/Ownable.sol
4 // 0x1822126feedb4c7d61eecdbe3682fe61e91383d6
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address private _owner;
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     _owner = msg.sender;
26   }
27 
28   /**
29    * @return the address of the owner.
30    */
31   function owner() public view returns(address) {
32     return _owner;
33   }
34 
35   /**
36    * @dev Throws if called by any account other than the owner.
37    */
38   modifier onlyOwner() {
39     require(isOwner());
40     _;
41   }
42 
43   /**
44    * @return true if `msg.sender` is the owner of the contract.
45    */
46   function isOwner() public view returns(bool) {
47     return msg.sender == _owner;
48   }
49 
50   /**
51    * @dev Allows the current owner to relinquish control of the contract.
52    * @notice Renouncing to ownership will leave the contract without an owner.
53    * It will not be possible to call the functions with the `onlyOwner`
54    * modifier anymore.
55    */
56   function renounceOwnership() public onlyOwner {
57     emit OwnershipRenounced(_owner);
58     _owner = address(0);
59   }
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address newOwner) public onlyOwner {
66     _transferOwnership(newOwner);
67   }
68 
69   /**
70    * @dev Transfers control of the contract to a newOwner.
71    * @param newOwner The address to transfer ownership to.
72    */
73   function _transferOwnership(address newOwner) internal {
74     require(newOwner != address(0));
75     emit OwnershipTransferred(_owner, newOwner);
76     _owner = newOwner;
77   }
78 }
79 
80 // File: contracts/Administratable.sol
81 
82 pragma solidity 0.4.24;
83 
84 // August 21, 2018
85 // remove all admin code.
86 
87 
88 contract Administratable is Ownable {
89 	mapping (address => bool) public superAdmins;
90 
91 	event AddSuperAdmin(address indexed admin);
92 	event RemoveSuperAdmin(address indexed admin);
93 
94 
95     modifier validateAddress( address _addr )
96     {
97         require(_addr != address(0x0));
98         require(_addr != address(this));
99         _;
100     }
101 
102 	modifier onlySuperAdmins {
103 		require(msg.sender == owner() || superAdmins[msg.sender]);
104 		_;
105 	}
106 
107 	function addSuperAdmin(address _admin) public onlyOwner validateAddress(_admin){
108 		require(!superAdmins[_admin]);
109 		superAdmins[_admin] = true;
110 		emit AddSuperAdmin(_admin);
111 	}
112 
113 	function removeSuperAdmin(address _admin) public onlyOwner validateAddress(_admin){
114 		require(superAdmins[_admin]);
115 		superAdmins[_admin] = false;
116 		emit RemoveSuperAdmin(_admin);
117 	}
118 }
119 
120 // File: contracts/TimeLockable.sol
121 
122 // Lee, July 29, 2018
123 pragma solidity 0.4.24;
124 
125 
126 contract TimeLockable is Administratable{
127 
128     uint256 private constant ADVISOR_LOCKUP_END     = 0; 
129     uint256 private constant TEAM_LOCKUP_END        = 0; 
130 
131     mapping (address => uint256) public timelockedAccounts;
132     event LockedFunds(address indexed target, uint256 timelocked);
133 
134     modifier isNotTimeLocked() {
135         require(now >= timelockedAccounts[msg.sender]);
136         _;
137     }
138 
139     modifier isNotTimeLockedFrom( address _from ) {
140         require(now >= timelockedAccounts[_from] && now >= timelockedAccounts[msg.sender]);
141         _;
142     }
143 
144     function timeLockAdvisor(address _target) public onlySuperAdmins validateAddress(_target) {
145         require(timelockedAccounts[_target] == 0);
146         timelockedAccounts[_target] = ADVISOR_LOCKUP_END;
147         emit LockedFunds(_target, ADVISOR_LOCKUP_END);
148     }
149 
150     function timeLockTeam(address _target) public onlySuperAdmins validateAddress(_target) {
151         require(timelockedAccounts[_target] == 0);
152         timelockedAccounts[_target] = TEAM_LOCKUP_END;
153         emit LockedFunds(_target, TEAM_LOCKUP_END);
154     }
155 }
156 
157 // File: contracts/Freezable.sol
158 pragma solidity 0.4.24;
159 
160 
161 contract Freezable is Administratable {
162 
163     bool public frozenToken;
164     mapping (address => bool) public frozenAccounts;
165 
166     event FrozenFunds(address indexed _target, bool _frozen);
167     event FrozenToken(bool _frozen);
168 
169     modifier isNotFrozen( address _to ) {
170         require(!frozenToken);
171         require(!frozenAccounts[msg.sender] && !frozenAccounts[_to]);
172         _;
173     }
174 
175     modifier isNotFrozenFrom( address _from, address _to ) {
176         require(!frozenToken);
177         require(!frozenAccounts[msg.sender] && !frozenAccounts[_from] && !frozenAccounts[_to]);
178         _;
179     }
180 
181     function freezeAccount(address _target, bool _freeze) public onlySuperAdmins validateAddress(_target) {
182         require(frozenAccounts[_target] != _freeze);
183         frozenAccounts[_target] = _freeze;
184         emit FrozenFunds(_target, _freeze);
185     }
186 
187     function freezeToken(bool _freeze) public onlySuperAdmins {
188         require(frozenToken != _freeze);
189         frozenToken = _freeze;
190         emit FrozenToken(frozenToken);
191     }
192 }
193 
194 // File: contracts/openzeppelin/token/ERC20/IERC20.sol
195 
196 /**
197  * @title ERC20 interface
198  * @dev see https://github.com/ethereum/EIPs/issues/20
199  */
200 interface IERC20 {
201   function totalSupply() external view returns (uint256);
202 
203   function balanceOf(address who) external view returns (uint256);
204 
205   function allowance(address owner, address spender)
206     external view returns (uint256);
207 
208   function transfer(address to, uint256 value) external returns (bool);
209 
210   function approve(address spender, uint256 value)
211     external returns (bool);
212 
213   function transferFrom(address from, address to, uint256 value)
214     external returns (bool);
215 
216   event Transfer(
217     address indexed from,
218     address indexed to,
219     uint256 value
220   );
221 
222   event Approval(
223     address indexed owner,
224     address indexed spender,
225     uint256 value
226   );
227 }
228 
229 // File: contracts/openzeppelin/math/SafeMath.sol
230 
231 /**
232  * @title SafeMath
233  * @dev Math operations with safety checks that revert on error
234  */
235 library SafeMath {
236 
237   /**
238   * @dev Multiplies two numbers, reverts on overflow.
239   */
240   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
241     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
242     // benefit is lost if 'b' is also tested.
243     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
244     if (a == 0) {
245       return 0;
246     }
247 
248     uint256 c = a * b;
249     require(c / a == b);
250 
251     return c;
252   }
253 
254   /**
255   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
256   */
257   function div(uint256 a, uint256 b) internal pure returns (uint256) {
258     require(b > 0); // Solidity only automatically asserts when dividing by 0
259     uint256 c = a / b;
260     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
261 
262     return c;
263   }
264 
265   /**
266   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
267   */
268   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
269     require(b <= a);
270     uint256 c = a - b;
271 
272     return c;
273   }
274 
275   /**
276   * @dev Adds two numbers, reverts on overflow.
277   */
278   function add(uint256 a, uint256 b) internal pure returns (uint256) {
279     uint256 c = a + b;
280     require(c >= a);
281 
282     return c;
283   }
284 
285   /**
286   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
287   * reverts when dividing by zero.
288   */
289   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
290     require(b != 0);
291     return a % b;
292   }
293 }
294 
295 // File: contracts/openzeppelin/token/ERC20/ERC20.sol
296 
297 /**
298  * @title Standard ERC20 token
299  *
300  * @dev Implementation of the basic standard token.
301  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
302  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
303  */
304 contract ERC20 is IERC20 {
305   using SafeMath for uint256;
306 
307   mapping (address => uint256) private _balances;
308 
309   mapping (address => mapping (address => uint256)) private _allowed;
310 
311   uint256 private _totalSupply;
312 
313   /**
314   * @dev Total number of tokens in existence
315   */
316   function totalSupply() public view returns (uint256) {
317     return _totalSupply;
318   }
319 
320   /**
321   * @dev Gets the balance of the specified address.
322   * @param owner The address to query the balance of.
323   * @return An uint256 representing the amount owned by the passed address.
324   */
325   function balanceOf(address owner) public view returns (uint256) {
326     return _balances[owner];
327   }
328 
329   /**
330    * @dev Function to check the amount of tokens that an owner allowed to a spender.
331    * @param owner address The address which owns the funds.
332    * @param spender address The address which will spend the funds.
333    * @return A uint256 specifying the amount of tokens still available for the spender.
334    */
335   function allowance(
336     address owner,
337     address spender
338    )
339     public
340     view
341     returns (uint256)
342   {
343     return _allowed[owner][spender];
344   }
345 
346   /**
347   * @dev Transfer token for a specified address
348   * @param to The address to transfer to.
349   * @param value The amount to be transferred.
350   */
351   function transfer(address to, uint256 value) public returns (bool) {
352     require(value <= _balances[msg.sender]);
353     require(to != address(0));
354 
355     _balances[msg.sender] = _balances[msg.sender].sub(value);
356     _balances[to] = _balances[to].add(value);
357     emit Transfer(msg.sender, to, value);
358     return true;
359   }
360 
361   /**
362    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
363    * Beware that changing an allowance with this method brings the risk that someone may use both the old
364    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
365    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
366    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
367    * @param spender The address which will spend the funds.
368    * @param value The amount of tokens to be spent.
369    */
370   function approve(address spender, uint256 value) public returns (bool) {
371     require(spender != address(0));
372 
373     _allowed[msg.sender][spender] = value;
374     emit Approval(msg.sender, spender, value);
375     return true;
376   }
377 
378   /**
379    * @dev Transfer tokens from one address to another
380    * @param from address The address which you want to send tokens from
381    * @param to address The address which you want to transfer to
382    * @param value uint256 the amount of tokens to be transferred
383    */
384   function transferFrom(
385     address from,
386     address to,
387     uint256 value
388   )
389     public
390     returns (bool)
391   {
392     require(value <= _balances[from]);
393     require(value <= _allowed[from][msg.sender]);
394     require(to != address(0));
395 
396     _balances[from] = _balances[from].sub(value);
397     _balances[to] = _balances[to].add(value);
398     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
399     emit Transfer(from, to, value);
400     return true;
401   }
402 
403   /**
404    * @dev Increase the amount of tokens that an owner allowed to a spender.
405    * approve should be called when allowed_[_spender] == 0. To increment
406    * allowed value is better to use this function to avoid 2 calls (and wait until
407    * the first transaction is mined)
408    * From MonolithDAO Token.sol
409    * @param spender The address which will spend the funds.
410    * @param addedValue The amount of tokens to increase the allowance by.
411    */
412   function increaseAllowance(
413     address spender,
414     uint256 addedValue
415   )
416     public
417     returns (bool)
418   {
419     require(spender != address(0));
420 
421     _allowed[msg.sender][spender] = (
422       _allowed[msg.sender][spender].add(addedValue));
423     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
424     return true;
425   }
426 
427   /**
428    * @dev Decrease the amount of tokens that an owner allowed to a spender.
429    * approve should be called when allowed_[_spender] == 0. To decrement
430    * allowed value is better to use this function to avoid 2 calls (and wait until
431    * the first transaction is mined)
432    * From MonolithDAO Token.sol
433    * @param spender The address which will spend the funds.
434    * @param subtractedValue The amount of tokens to decrease the allowance by.
435    */
436   function decreaseAllowance(
437     address spender,
438     uint256 subtractedValue
439   )
440     public
441     returns (bool)
442   {
443     require(spender != address(0));
444 
445     _allowed[msg.sender][spender] = (
446       _allowed[msg.sender][spender].sub(subtractedValue));
447     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
448     return true;
449   }
450 
451   /**
452    * @dev Internal function that mints an amount of the token and assigns it to
453    * an account. This encapsulates the modification of balances such that the
454    * proper events are emitted.
455    * @param account The account that will receive the created tokens.
456    * @param amount The amount that will be created.
457    */
458   function _mint(address account, uint256 amount) internal {
459     require(account != 0);
460     _totalSupply = _totalSupply.add(amount);
461     _balances[account] = _balances[account].add(amount);
462     emit Transfer(address(0), account, amount);
463   }
464 
465   /**
466    * @dev Internal function that burns an amount of the token of a given
467    * account.
468    * @param account The account whose tokens will be burnt.
469    * @param amount The amount that will be burnt.
470    */
471   function _burn(address account, uint256 amount) internal {
472     require(account != 0);
473     require(amount <= _balances[account]);
474 
475     _totalSupply = _totalSupply.sub(amount);
476     _balances[account] = _balances[account].sub(amount);
477     emit Transfer(account, address(0), amount);
478   }
479 
480   /**
481    * @dev Internal function that burns an amount of the token of a given
482    * account, deducting from the sender's allowance for said account. Uses the
483    * internal burn function.
484    * @param account The account whose tokens will be burnt.
485    * @param amount The amount that will be burnt.
486    */
487   function _burnFrom(address account, uint256 amount) internal {
488     require(amount <= _allowed[account][msg.sender]);
489 
490     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
491     // this function needs to emit an event with the updated approval.
492     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
493       amount);
494     _burn(account, amount);
495   }
496 }
497 
498 // File: contracts/openzeppelin/token/ERC20/ERC20Burnable.sol
499 
500 /**
501  * @title Burnable Token
502  * @dev Token that can be irreversibly burned (destroyed).
503  */
504 contract ERC20Burnable is ERC20 {
505 
506   /**
507    * @dev Burns a specific amount of tokens.
508    * @param value The amount of token to be burned.
509    */
510   function burn(uint256 value) public {
511     _burn(msg.sender, value);
512   }
513 
514   /**
515    * @dev Burns a specific amount of tokens from the target address and decrements allowance
516    * @param from address The address which you want to send tokens from
517    * @param value uint256 The amount of token to be burned
518    */
519   function burnFrom(address from, uint256 value) public {
520     _burnFrom(from, value);
521   }
522 
523   /**
524    * @dev Overrides ERC20._burn in order for burn and burnFrom to emit
525    * an additional Burn event.
526    */
527   function _burn(address who, uint256 value) internal {
528     super._burn(who, value);
529   }
530 }
531 
532 pragma solidity 0.4.24;
533 
534 contract CustodyToken is ERC20Burnable, TimeLockable, Freezable
535 {
536     string 	public 	constant name 		= "Custody Token";
537     string 	public 	constant symbol 	= "CUST";
538     uint8 	public 	constant decimals 	= 18;
539     
540     event Burn(address indexed _burner, uint _value);
541 
542     constructor( address _registry, uint _totalTokenAmount ) public
543     {
544         _mint(_registry, _totalTokenAmount);
545         addSuperAdmin(_registry);
546     }
547 
548 
549     /**
550     * @dev Transfer token for a specified address
551     * @param _to The address to transfer to.
552     * @param _value The amount to be transferred.
553     */    
554     function transfer(address _to, uint _value) public validateAddress(_to) isNotTimeLocked() isNotFrozen(_to) returns (bool) 
555     {
556         return super.transfer(_to, _value);
557     }
558 
559     /**
560     * @dev Transfer tokens from one address to another
561     * @param _from address The address which you want to send tokens from
562     * @param _to address The address which you want to transfer to
563     * @param _value uint256 the amount of tokens to be transferred
564     */
565     function transferFrom(address _from, address _to, uint _value) public validateAddress(_to) isNotTimeLockedFrom(_from) isNotFrozenFrom(_from, _to) returns (bool) 
566     {
567         return super.transferFrom(_from, _to, _value);
568     }
569 
570     function approve(address _spender, uint256 _value) public validateAddress(_spender) isNotFrozen(_spender) isNotTimeLocked() returns (bool) 
571     {
572         return super.approve(_spender, _value);
573     }
574 
575     function increaseAllowance( address _spender, uint256 _addedValue ) public validateAddress(_spender) isNotFrozen(_spender) isNotTimeLocked() returns (bool)
576     {
577         return super.increaseAllowance(_spender, _addedValue);
578     }
579 
580     function decreaseAllowance(address _spender, uint256 _subtractedValue) public validateAddress(_spender) isNotFrozen(_spender) isNotTimeLocked() returns (bool)
581     {
582         return super.decreaseAllowance(_spender, _subtractedValue);
583     }
584 
585 
586     /**
587     * @dev Token Contract Emergency Drain
588     * @param _token - Token to drain
589     * @param _amount - Amount to drain
590     */
591     function emergencyERC20Drain( IERC20 _token, uint _amount ) public onlyOwner {
592         _token.transfer( owner(), _amount );
593     }
594 }