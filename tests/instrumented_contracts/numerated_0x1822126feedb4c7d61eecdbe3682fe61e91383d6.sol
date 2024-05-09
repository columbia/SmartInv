1 pragma solidity ^0.4.24;
2 
3 // File: contracts/openzeppelin/ownership/Ownable.sol
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
84 pragma solidity 0.4.24;
85 
86 // August 21, 2018
87 // remove all admin code.
88 
89 
90 contract Administratable is Ownable {
91 	mapping (address => bool) public superAdmins;
92 
93 	event AddSuperAdmin(address indexed admin);
94 	event RemoveSuperAdmin(address indexed admin);
95 
96 
97     modifier validateAddress( address _addr )
98     {
99         require(_addr != address(0x0));
100         require(_addr != address(this));
101         _;
102     }
103 
104 	modifier onlySuperAdmins {
105 		require(msg.sender == owner() || superAdmins[msg.sender]);
106 		_;
107 	}
108 
109 	function addSuperAdmin(address _admin) public onlyOwner validateAddress(_admin){
110 		require(!superAdmins[_admin]);
111 		superAdmins[_admin] = true;
112 		emit AddSuperAdmin(_admin);
113 	}
114 
115 	function removeSuperAdmin(address _admin) public onlyOwner validateAddress(_admin){
116 		require(superAdmins[_admin]);
117 		superAdmins[_admin] = false;
118 		emit RemoveSuperAdmin(_admin);
119 	}
120 }
121 
122 // File: contracts/TimeLockable.sol
123 
124 // Lee, July 29, 2018
125 pragma solidity 0.4.24;
126 
127 
128 contract TimeLockable is Administratable{
129 
130     uint256 private constant ADVISOR_LOCKUP_END     = 1551398399; // 2019.02.28 23.59.59 (UTC)
131     uint256 private constant TEAM_LOCKUP_END        = 1567295999; // 2019.08.31 23.59.59 (UTC)
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
142         require( now >= timelockedAccounts[_from] && now >= timelockedAccounts[msg.sender]);
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
160 
161 // Lee, July 29, 2018
162 pragma solidity 0.4.24;
163 
164 
165 contract Freezable is Administratable {
166 
167     bool public frozenToken;
168     mapping (address => bool) public frozenAccounts;
169 
170     event FrozenFunds(address indexed _target, bool _frozen);
171     event FrozenToken(bool _frozen);
172 
173     modifier isNotFrozen( address _to ) {
174         require(!frozenToken);
175         require(!frozenAccounts[msg.sender] && !frozenAccounts[_to]);
176         _;
177     }
178 
179     modifier isNotFrozenFrom( address _from, address _to ) {
180         require(!frozenToken);
181         require(!frozenAccounts[msg.sender] && !frozenAccounts[_from] && !frozenAccounts[_to]);
182         _;
183     }
184 
185     function freezeAccount(address _target, bool _freeze) public onlySuperAdmins validateAddress(_target) {
186         require(frozenAccounts[_target] != _freeze);
187         frozenAccounts[_target] = _freeze;
188         emit FrozenFunds(_target, _freeze);
189     }
190 
191     function freezeToken(bool _freeze) public onlySuperAdmins {
192         require(frozenToken != _freeze);
193         frozenToken = _freeze;
194         emit FrozenToken(frozenToken);
195     }
196 }
197 
198 // File: contracts/openzeppelin/token/ERC20/IERC20.sol
199 
200 /**
201  * @title ERC20 interface
202  * @dev see https://github.com/ethereum/EIPs/issues/20
203  */
204 interface IERC20 {
205   function totalSupply() external view returns (uint256);
206 
207   function balanceOf(address who) external view returns (uint256);
208 
209   function allowance(address owner, address spender)
210     external view returns (uint256);
211 
212   function transfer(address to, uint256 value) external returns (bool);
213 
214   function approve(address spender, uint256 value)
215     external returns (bool);
216 
217   function transferFrom(address from, address to, uint256 value)
218     external returns (bool);
219 
220   event Transfer(
221     address indexed from,
222     address indexed to,
223     uint256 value
224   );
225 
226   event Approval(
227     address indexed owner,
228     address indexed spender,
229     uint256 value
230   );
231 }
232 
233 // File: contracts/openzeppelin/math/SafeMath.sol
234 
235 /**
236  * @title SafeMath
237  * @dev Math operations with safety checks that revert on error
238  */
239 library SafeMath {
240 
241   /**
242   * @dev Multiplies two numbers, reverts on overflow.
243   */
244   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
245     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
246     // benefit is lost if 'b' is also tested.
247     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
248     if (a == 0) {
249       return 0;
250     }
251 
252     uint256 c = a * b;
253     require(c / a == b);
254 
255     return c;
256   }
257 
258   /**
259   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
260   */
261   function div(uint256 a, uint256 b) internal pure returns (uint256) {
262     require(b > 0); // Solidity only automatically asserts when dividing by 0
263     uint256 c = a / b;
264     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
265 
266     return c;
267   }
268 
269   /**
270   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
271   */
272   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
273     require(b <= a);
274     uint256 c = a - b;
275 
276     return c;
277   }
278 
279   /**
280   * @dev Adds two numbers, reverts on overflow.
281   */
282   function add(uint256 a, uint256 b) internal pure returns (uint256) {
283     uint256 c = a + b;
284     require(c >= a);
285 
286     return c;
287   }
288 
289   /**
290   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
291   * reverts when dividing by zero.
292   */
293   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
294     require(b != 0);
295     return a % b;
296   }
297 }
298 
299 // File: contracts/openzeppelin/token/ERC20/ERC20.sol
300 
301 /**
302  * @title Standard ERC20 token
303  *
304  * @dev Implementation of the basic standard token.
305  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
306  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
307  */
308 contract ERC20 is IERC20 {
309   using SafeMath for uint256;
310 
311   mapping (address => uint256) private _balances;
312 
313   mapping (address => mapping (address => uint256)) private _allowed;
314 
315   uint256 private _totalSupply;
316 
317   /**
318   * @dev Total number of tokens in existence
319   */
320   function totalSupply() public view returns (uint256) {
321     return _totalSupply;
322   }
323 
324   /**
325   * @dev Gets the balance of the specified address.
326   * @param owner The address to query the balance of.
327   * @return An uint256 representing the amount owned by the passed address.
328   */
329   function balanceOf(address owner) public view returns (uint256) {
330     return _balances[owner];
331   }
332 
333   /**
334    * @dev Function to check the amount of tokens that an owner allowed to a spender.
335    * @param owner address The address which owns the funds.
336    * @param spender address The address which will spend the funds.
337    * @return A uint256 specifying the amount of tokens still available for the spender.
338    */
339   function allowance(
340     address owner,
341     address spender
342    )
343     public
344     view
345     returns (uint256)
346   {
347     return _allowed[owner][spender];
348   }
349 
350   /**
351   * @dev Transfer token for a specified address
352   * @param to The address to transfer to.
353   * @param value The amount to be transferred.
354   */
355   function transfer(address to, uint256 value) public returns (bool) {
356     require(value <= _balances[msg.sender]);
357     require(to != address(0));
358 
359     _balances[msg.sender] = _balances[msg.sender].sub(value);
360     _balances[to] = _balances[to].add(value);
361     emit Transfer(msg.sender, to, value);
362     return true;
363   }
364 
365   /**
366    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
367    * Beware that changing an allowance with this method brings the risk that someone may use both the old
368    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
369    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
370    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
371    * @param spender The address which will spend the funds.
372    * @param value The amount of tokens to be spent.
373    */
374   function approve(address spender, uint256 value) public returns (bool) {
375     require(spender != address(0));
376 
377     _allowed[msg.sender][spender] = value;
378     emit Approval(msg.sender, spender, value);
379     return true;
380   }
381 
382   /**
383    * @dev Transfer tokens from one address to another
384    * @param from address The address which you want to send tokens from
385    * @param to address The address which you want to transfer to
386    * @param value uint256 the amount of tokens to be transferred
387    */
388   function transferFrom(
389     address from,
390     address to,
391     uint256 value
392   )
393     public
394     returns (bool)
395   {
396     require(value <= _balances[from]);
397     require(value <= _allowed[from][msg.sender]);
398     require(to != address(0));
399 
400     _balances[from] = _balances[from].sub(value);
401     _balances[to] = _balances[to].add(value);
402     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
403     emit Transfer(from, to, value);
404     return true;
405   }
406 
407   /**
408    * @dev Increase the amount of tokens that an owner allowed to a spender.
409    * approve should be called when allowed_[_spender] == 0. To increment
410    * allowed value is better to use this function to avoid 2 calls (and wait until
411    * the first transaction is mined)
412    * From MonolithDAO Token.sol
413    * @param spender The address which will spend the funds.
414    * @param addedValue The amount of tokens to increase the allowance by.
415    */
416   function increaseAllowance(
417     address spender,
418     uint256 addedValue
419   )
420     public
421     returns (bool)
422   {
423     require(spender != address(0));
424 
425     _allowed[msg.sender][spender] = (
426       _allowed[msg.sender][spender].add(addedValue));
427     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
428     return true;
429   }
430 
431   /**
432    * @dev Decrease the amount of tokens that an owner allowed to a spender.
433    * approve should be called when allowed_[_spender] == 0. To decrement
434    * allowed value is better to use this function to avoid 2 calls (and wait until
435    * the first transaction is mined)
436    * From MonolithDAO Token.sol
437    * @param spender The address which will spend the funds.
438    * @param subtractedValue The amount of tokens to decrease the allowance by.
439    */
440   function decreaseAllowance(
441     address spender,
442     uint256 subtractedValue
443   )
444     public
445     returns (bool)
446   {
447     require(spender != address(0));
448 
449     _allowed[msg.sender][spender] = (
450       _allowed[msg.sender][spender].sub(subtractedValue));
451     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
452     return true;
453   }
454 
455   /**
456    * @dev Internal function that mints an amount of the token and assigns it to
457    * an account. This encapsulates the modification of balances such that the
458    * proper events are emitted.
459    * @param account The account that will receive the created tokens.
460    * @param amount The amount that will be created.
461    */
462   function _mint(address account, uint256 amount) internal {
463     require(account != 0);
464     _totalSupply = _totalSupply.add(amount);
465     _balances[account] = _balances[account].add(amount);
466     emit Transfer(address(0), account, amount);
467   }
468 
469   /**
470    * @dev Internal function that burns an amount of the token of a given
471    * account.
472    * @param account The account whose tokens will be burnt.
473    * @param amount The amount that will be burnt.
474    */
475   function _burn(address account, uint256 amount) internal {
476     require(account != 0);
477     require(amount <= _balances[account]);
478 
479     _totalSupply = _totalSupply.sub(amount);
480     _balances[account] = _balances[account].sub(amount);
481     emit Transfer(account, address(0), amount);
482   }
483 
484   /**
485    * @dev Internal function that burns an amount of the token of a given
486    * account, deducting from the sender's allowance for said account. Uses the
487    * internal burn function.
488    * @param account The account whose tokens will be burnt.
489    * @param amount The amount that will be burnt.
490    */
491   function _burnFrom(address account, uint256 amount) internal {
492     require(amount <= _allowed[account][msg.sender]);
493 
494     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
495     // this function needs to emit an event with the updated approval.
496     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
497       amount);
498     _burn(account, amount);
499   }
500 }
501 
502 // File: contracts/openzeppelin/token/ERC20/ERC20Burnable.sol
503 
504 /**
505  * @title Burnable Token
506  * @dev Token that can be irreversibly burned (destroyed).
507  */
508 contract ERC20Burnable is ERC20 {
509 
510   /**
511    * @dev Burns a specific amount of tokens.
512    * @param value The amount of token to be burned.
513    */
514   function burn(uint256 value) public {
515     _burn(msg.sender, value);
516   }
517 
518   /**
519    * @dev Burns a specific amount of tokens from the target address and decrements allowance
520    * @param from address The address which you want to send tokens from
521    * @param value uint256 The amount of token to be burned
522    */
523   function burnFrom(address from, uint256 value) public {
524     _burnFrom(from, value);
525   }
526 
527   /**
528    * @dev Overrides ERC20._burn in order for burn and burnFrom to emit
529    * an additional Burn event.
530    */
531   function _burn(address who, uint256 value) internal {
532     super._burn(who, value);
533   }
534 }
535 
536 // File: contracts/XtockToken.sol
537 
538 // Lee, July 29, 2018
539 pragma solidity 0.4.24;
540 
541 
542 
543 
544 contract XtockToken is ERC20Burnable, TimeLockable, Freezable
545 {
546     string 	public 	constant name 		= "XtockToken";
547     string 	public 	constant symbol 	= "XTX";
548     uint8 	public 	constant decimals 	= 18;
549     
550     event Burn(address indexed _burner, uint _value);
551 
552     constructor( address _registry, uint _totalTokenAmount ) public
553     {
554         _mint(_registry, _totalTokenAmount);
555         addSuperAdmin(_registry);
556     }
557 
558 
559     /**
560     * @dev Transfer token for a specified address
561     * @param _to The address to transfer to.
562     * @param _value The amount to be transferred.
563     */    
564     function transfer(address _to, uint _value) public validateAddress(_to) isNotTimeLocked() isNotFrozen(_to) returns (bool) 
565     {
566         return super.transfer(_to, _value);
567     }
568 
569     /**
570     * @dev Transfer tokens from one address to another
571     * @param _from address The address which you want to send tokens from
572     * @param _to address The address which you want to transfer to
573     * @param _value uint256 the amount of tokens to be transferred
574     */
575     function transferFrom(address _from, address _to, uint _value) public validateAddress(_to) isNotTimeLockedFrom(_from) isNotFrozenFrom(_from, _to) returns (bool) 
576     {
577         return super.transferFrom(_from, _to, _value);
578     }
579 
580     function approve(address _spender, uint256 _value) public validateAddress(_spender) isNotFrozen(_spender) isNotTimeLocked() returns (bool) 
581     {
582         return super.approve(_spender, _value);
583     }
584 
585     function increaseAllowance( address _spender, uint256 _addedValue ) public validateAddress(_spender) isNotFrozen(_spender) isNotTimeLocked() returns (bool)
586     {
587         return super.increaseAllowance(_spender, _addedValue);
588     }
589 
590     function decreaseAllowance(address _spender, uint256 _subtractedValue) public validateAddress(_spender) isNotFrozen(_spender) isNotTimeLocked() returns (bool)
591     {
592         return super.decreaseAllowance(_spender, _subtractedValue);
593     }
594 
595 
596     /**
597     * @dev Token Contract Emergency Drain
598     * @param _token - Token to drain
599     * @param _amount - Amount to drain
600     */
601     function emergencyERC20Drain( IERC20 _token, uint _amount ) public onlyOwner {
602         _token.transfer( owner(), _amount );
603     }
604 }