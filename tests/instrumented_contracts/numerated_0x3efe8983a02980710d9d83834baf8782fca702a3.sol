1 pragma solidity ^0.4.24;
2 // File: contracts/openzeppelin/ownership/Ownable.sol
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address private _owner;
10   event OwnershipRenounced(address indexed previousOwner);
11   event OwnershipTransferred(
12     address indexed previousOwner,
13     address indexed newOwner
14   );
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   constructor() public {
20     _owner = msg.sender;
21   }
22   /**
23    * @return the address of the owner.
24    */
25   function owner() public view returns(address) {
26     return _owner;
27   }
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(isOwner());
33     _;
34   }
35   /**
36    * @return true if `msg.sender` is the owner of the contract.
37    */
38   function isOwner() public view returns(bool) {
39     return msg.sender == _owner;
40   }
41   /**
42    * @dev Allows the current owner to relinquish control of the contract.
43    * @notice Renouncing to ownership will leave the contract without an owner.
44    * It will not be possible to call the functions with the `onlyOwner`
45    * modifier anymore.
46    */
47   function renounceOwnership() public onlyOwner {
48     emit OwnershipRenounced(_owner);
49     _owner = address(0);
50   }
51   /**
52    * @dev Allows the current owner to transfer control of the contract to a newOwner.
53    * @param newOwner The address to transfer ownership to.
54    */
55   function transferOwnership(address newOwner) public onlyOwner {
56     _transferOwnership(newOwner);
57   }
58   /**
59    * @dev Transfers control of the contract to a newOwner.
60    * @param newOwner The address to transfer ownership to.
61    */
62   function _transferOwnership(address newOwner) internal {
63     require(newOwner != address(0));
64     emit OwnershipTransferred(_owner, newOwner);
65     _owner = newOwner;
66   }
67 }
68 // File: contracts/Administratable.sol
69 // Lee, July 29, 2018
70 pragma solidity 0.4.24;
71 // August 21, 2018
72 // remove all admin code.
73 contract Administratable is Ownable {
74     mapping (address => bool) public superAdmins;
75     event AddSuperAdmin(address indexed admin);
76     event RemoveSuperAdmin(address indexed admin);
77     modifier validateAddress( address _addr )
78     {
79         require(_addr != address(0x0));
80         require(_addr != address(this));
81         _;
82     }
83     modifier onlySuperAdmins {
84         require(msg.sender == owner() || superAdmins[msg.sender]);
85         _;
86     }
87     function addSuperAdmin(address _admin) public onlyOwner validateAddress(_admin){
88         require(!superAdmins[_admin]);
89         superAdmins[_admin] = true;
90         emit AddSuperAdmin(_admin);
91     }
92     function removeSuperAdmin(address _admin) public onlyOwner validateAddress(_admin){
93         require(superAdmins[_admin]);
94         superAdmins[_admin] = false;
95         emit RemoveSuperAdmin(_admin);
96     }
97 }
98 // File: contracts/Freezable.sol
99 // Lee, July 29, 2018
100 pragma solidity 0.4.24;
101 contract Freezable is Administratable {
102     bool public frozenToken;
103     mapping (address => bool) public frozenAccounts;
104     event FrozenFunds(address indexed _target, bool _frozen);
105     event FrozenToken(bool _frozen);
106     modifier isNotFrozen( address _to ) {
107         require(!frozenToken);
108         require(!frozenAccounts[msg.sender] && !frozenAccounts[_to]);
109         _;
110     }
111     modifier isNotFrozenFrom( address _from, address _to ) {
112         require(!frozenToken);
113         require(!frozenAccounts[msg.sender] && !frozenAccounts[_from] && !frozenAccounts[_to]);
114         _;
115     }
116     function freezeAccount(address _target, bool _freeze) public onlySuperAdmins validateAddress(_target) {
117         require(frozenAccounts[_target] != _freeze);
118         frozenAccounts[_target] = _freeze;
119         emit FrozenFunds(_target, _freeze);
120     }
121     function freezeToken(bool _freeze) public onlySuperAdmins {
122         require(frozenToken != _freeze);
123         frozenToken = _freeze;
124         emit FrozenToken(frozenToken);
125     }
126 }
127 // File: contracts/TimeLockable.sol
128 // Lee, July 29, 2018
129 pragma solidity 0.4.24;
130 contract TimeLockable is Administratable{
131     uint256 private constant ADVISOR_LOCKUP_END     = 1551398399; // 2019.02.28 23.59.59 (UST)
132     uint256 private constant TEAM_LOCKUP_END        = 1567295999; // 2019.08.31 23.59.59 (UST)
133     mapping (address => uint256) public timelockedAccounts;
134     event LockedFunds(address indexed target, uint256 timelocked);
135     modifier isNotTimeLocked() {
136         require(now >= timelockedAccounts[msg.sender]);
137         _;
138     }
139     modifier isNotTimeLockedFrom( address _from ) {
140         require( now >= timelockedAccounts[_from] && now >= timelockedAccounts[msg.sender]);
141         _;
142     }
143     function timeLockAdvisor(address _target) public onlySuperAdmins validateAddress(_target) {
144         require(timelockedAccounts[_target] == 0);
145         timelockedAccounts[_target] = ADVISOR_LOCKUP_END;
146         emit LockedFunds(_target, ADVISOR_LOCKUP_END);
147     }
148     function timeLockTeam(address _target) public onlySuperAdmins validateAddress(_target) {
149         require(timelockedAccounts[_target] == 0);
150         timelockedAccounts[_target] = TEAM_LOCKUP_END;
151         emit LockedFunds(_target, TEAM_LOCKUP_END);
152     }
153 }
154 // File: contracts/openzeppelin/math/SafeMath.sol
155 /**
156  * @title SafeMath
157  * @dev Math operations with safety checks that revert on error
158  */
159 library SafeMath {
160   /**
161   * @dev Multiplies two numbers, reverts on overflow.
162   */
163   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
164     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
165     // benefit is lost if 'b' is also tested.
166     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
167     if (a == 0) {
168       return 0;
169     }
170     uint256 c = a * b;
171     require(c / a == b);
172     return c;
173   }
174   /**
175   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
176   */
177   function div(uint256 a, uint256 b) internal pure returns (uint256) {
178     require(b > 0); // Solidity only automatically asserts when dividing by 0
179     uint256 c = a / b;
180     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
181     return c;
182   }
183   /**
184   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
185   */
186   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
187     require(b <= a);
188     uint256 c = a - b;
189     return c;
190   }
191   /**
192   * @dev Adds two numbers, reverts on overflow.
193   */
194   function add(uint256 a, uint256 b) internal pure returns (uint256) {
195     uint256 c = a + b;
196     require(c >= a);
197     return c;
198   }
199   /**
200   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
201   * reverts when dividing by zero.
202   */
203   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
204     require(b != 0);
205     return a % b;
206   }
207 }
208 // File: contracts/openzeppelin/token/ERC20/IERC20.sol
209 /**
210  * @title ERC20 interface
211  * @dev see https://github.com/ethereum/EIPs/issues/20
212  */
213 interface IERC20 {
214   function totalSupply() external view returns (uint256);
215   function balanceOf(address who) external view returns (uint256);
216   function allowance(address owner, address spender)
217     external view returns (uint256);
218   function transfer(address to, uint256 value) external returns (bool);
219   function approve(address spender, uint256 value)
220     external returns (bool);
221   function transferFrom(address from, address to, uint256 value)
222     external returns (bool);
223   event Transfer(
224     address indexed from,
225     address indexed to,
226     uint256 value
227   );
228   event Approval(
229     address indexed owner,
230     address indexed spender,
231     uint256 value
232   );
233 }
234 // File: contracts/openzeppelin/token/ERC20/ERC20.sol
235 /**
236  * @title Standard ERC20 token
237  *
238  * @dev Implementation of the basic standard token.
239  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
240  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
241  */
242 contract ERC20 is IERC20 {
243   using SafeMath for uint256;
244   mapping (address => uint256) private _balances;
245   mapping (address => mapping (address => uint256)) private _allowed;
246   uint256 private _totalSupply;
247   /**
248   * @dev Total number of tokens in existence
249   */
250   function totalSupply() public view returns (uint256) {
251     return _totalSupply;
252   }
253   /**
254   * @dev Gets the balance of the specified address.
255   * @param owner The address to query the balance of.
256   * @return An uint256 representing the amount owned by the passed address.
257   */
258   function balanceOf(address owner) public view returns (uint256) {
259     return _balances[owner];
260   }
261   /**
262    * @dev Function to check the amount of tokens that an owner allowed to a spender.
263    * @param owner address The address which owns the funds.
264    * @param spender address The address which will spend the funds.
265    * @return A uint256 specifying the amount of tokens still available for the spender.
266    */
267   function allowance(
268     address owner,
269     address spender
270    )
271     public
272     view
273     returns (uint256)
274   {
275     return _allowed[owner][spender];
276   }
277   /**
278   * @dev Transfer token for a specified address
279   * @param to The address to transfer to.
280   * @param value The amount to be transferred.
281   */
282   function transfer(address to, uint256 value) public returns (bool) {
283     require(value <= _balances[msg.sender]);
284     require(to != address(0));
285     _balances[msg.sender] = _balances[msg.sender].sub(value);
286     _balances[to] = _balances[to].add(value);
287     emit Transfer(msg.sender, to, value);
288     return true;
289   }
290   /**
291    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
292    * Beware that changing an allowance with this method brings the risk that someone may use both the old
293    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
294    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
295    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
296    * @param spender The address which will spend the funds.
297    * @param value The amount of tokens to be spent.
298    */
299   function approve(address spender, uint256 value) public returns (bool) {
300     require(spender != address(0));
301     _allowed[msg.sender][spender] = value;
302     emit Approval(msg.sender, spender, value);
303     return true;
304   }
305   /**
306    * @dev Transfer tokens from one address to another
307    * @param from address The address which you want to send tokens from
308    * @param to address The address which you want to transfer to
309    * @param value uint256 the amount of tokens to be transferred
310    */
311   function transferFrom(
312     address from,
313     address to,
314     uint256 value
315   )
316     public
317     returns (bool)
318   {
319     require(value <= _balances[from]);
320     require(value <= _allowed[from][msg.sender]);
321     require(to != address(0));
322     _balances[from] = _balances[from].sub(value);
323     _balances[to] = _balances[to].add(value);
324     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
325     emit Transfer(from, to, value);
326     return true;
327   }
328   /**
329    * @dev Increase the amount of tokens that an owner allowed to a spender.
330    * approve should be called when allowed_[_spender] == 0. To increment
331    * allowed value is better to use this function to avoid 2 calls (and wait until
332    * the first transaction is mined)
333    * From MonolithDAO Token.sol
334    * @param spender The address which will spend the funds.
335    * @param addedValue The amount of tokens to increase the allowance by.
336    */
337   function increaseAllowance(
338     address spender,
339     uint256 addedValue
340   )
341     public
342     returns (bool)
343   {
344     require(spender != address(0));
345     _allowed[msg.sender][spender] = (
346       _allowed[msg.sender][spender].add(addedValue));
347     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
348     return true;
349   }
350   /**
351    * @dev Decrease the amount of tokens that an owner allowed to a spender.
352    * approve should be called when allowed_[_spender] == 0. To decrement
353    * allowed value is better to use this function to avoid 2 calls (and wait until
354    * the first transaction is mined)
355    * From MonolithDAO Token.sol
356    * @param spender The address which will spend the funds.
357    * @param subtractedValue The amount of tokens to decrease the allowance by.
358    */
359   function decreaseAllowance(
360     address spender,
361     uint256 subtractedValue
362   )
363     public
364     returns (bool)
365   {
366     require(spender != address(0));
367     _allowed[msg.sender][spender] = (
368       _allowed[msg.sender][spender].sub(subtractedValue));
369     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
370     return true;
371   }
372   /**
373    * @dev Internal function that mints an amount of the token and assigns it to
374    * an account. This encapsulates the modification of balances such that the
375    * proper events are emitted.
376    * @param account The account that will receive the created tokens.
377    * @param amount The amount that will be created.
378    */
379   function _mint(address account, uint256 amount) internal {
380     require(account != 0);
381     _totalSupply = _totalSupply.add(amount);
382     _balances[account] = _balances[account].add(amount);
383     emit Transfer(address(0), account, amount);
384   }
385   /**
386    * @dev Internal function that burns an amount of the token of a given
387    * account.
388    * @param account The account whose tokens will be burnt.
389    * @param amount The amount that will be burnt.
390    */
391   function _burn(address account, uint256 amount) internal {
392     require(account != 0);
393     require(amount <= _balances[account]);
394     _totalSupply = _totalSupply.sub(amount);
395     _balances[account] = _balances[account].sub(amount);
396     emit Transfer(account, address(0), amount);
397   }
398   /**
399    * @dev Internal function that burns an amount of the token of a given
400    * account, deducting from the sender's allowance for said account. Uses the
401    * internal burn function.
402    * @param account The account whose tokens will be burnt.
403    * @param amount The amount that will be burnt.
404    */
405   function _burnFrom(address account, uint256 amount) internal {
406     require(amount <= _allowed[account][msg.sender]);
407     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
408     // this function needs to emit an event with the updated approval.
409     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
410       amount);
411     _burn(account, amount);
412   }
413 }
414 // File: contracts/openzeppelin/token/ERC20/ERC20Burnable.sol
415 /**
416  * @title Burnable Token
417  * @dev Token that can be irreversibly burned (destroyed).
418  */
419 contract ERC20Burnable is ERC20 {
420   /**
421    * @dev Burns a specific amount of tokens.
422    * @param value The amount of token to be burned.
423    */
424   function burn(uint256 value) public {
425     _burn(msg.sender, value);
426   }
427   /**
428    * @dev Burns a specific amount of tokens from the target address and decrements allowance
429    * @param from address The address which you want to send tokens from
430    * @param value uint256 The amount of token to be burned
431    */
432   function burnFrom(address from, uint256 value) public {
433     _burnFrom(from, value);
434   }
435   /**
436    * @dev Overrides ERC20._burn in order for burn and burnFrom to emit
437    * an additional Burn event.
438    */
439   function _burn(address who, uint256 value) internal {
440     super._burn(who, value);
441   }
442 }
443 // File: contracts/XtockToken.sol
444 // Lee, July 29, 2018
445 pragma solidity 0.4.24;
446 contract XtockToken is ERC20Burnable, TimeLockable, Freezable
447 {
448     string  public  constant name       = "XtockToken";
449     string  public  constant symbol     = "XTX";
450     uint8   public  constant decimals   = 18;
451     
452     event Burn(address indexed _burner, uint _value);
453     constructor( address _registry, uint _totalTokenAmount ) public
454     {
455         _mint(_registry, _totalTokenAmount);
456         addSuperAdmin(_registry);
457     }
458     /**
459     * @dev Transfer token for a specified address
460     * @param _to The address to transfer to.
461     * @param _value The amount to be transferred.
462     */    
463     function transfer(address _to, uint _value) public validateAddress(_to) isNotTimeLocked() isNotFrozen(_to) returns (bool) 
464     {
465         return super.transfer(_to, _value);
466     }
467     /**
468     * @dev Transfer tokens from one address to another
469     * @param _from address The address which you want to send tokens from
470     * @param _to address The address which you want to transfer to
471     * @param _value uint256 the amount of tokens to be transferred
472     */
473     function transferFrom(address _from, address _to, uint _value) public validateAddress(_to) isNotTimeLockedFrom(_from) isNotFrozenFrom(_from, _to) returns (bool) 
474     {
475         return super.transferFrom(_from, _to, _value);
476     }
477     function approve(address _spender, uint256 _value) public validateAddress(_spender) isNotFrozen(_spender) isNotTimeLocked() returns (bool) 
478     {
479         return super.approve(_spender, _value);
480     }
481     function increaseAllowance( address _spender, uint256 _addedValue ) public validateAddress(_spender) isNotFrozen(_spender) isNotTimeLocked() returns (bool)
482     {
483         return super.increaseAllowance(_spender, _addedValue);
484     }
485     function decreaseAllowance(address _spender, uint256 _subtractedValue) public validateAddress(_spender) isNotFrozen(_spender) isNotTimeLocked() returns (bool)
486     {
487         return super.decreaseAllowance(_spender, _subtractedValue);
488     }
489     /**
490     * @dev Token Contract Emergency Drain
491     * @param _token - Token to drain
492     * @param _amount - Amount to drain
493     */
494     function emergencyERC20Drain( IERC20 _token, uint _amount ) public onlyOwner {
495         _token.transfer( owner(), _amount );
496     }
497 }