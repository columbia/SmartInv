1 pragma solidity ^0.4.24;
2 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
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
71 contract Administratable is Ownable {
72     mapping (address => bool) public superAdmins;
73     event AddSuperAdmin(address indexed admin);
74     event RemoveSuperAdmin(address indexed admin);
75     modifier validateAddress( address _addr )
76     {
77         require(_addr != address(0x0));
78         require(_addr != address(this));
79         _;
80     }
81     modifier onlySuperAdmins {
82         require(msg.sender == owner() || superAdmins[msg.sender]);
83         _;
84     }
85     function addSuperAdmin(address _admin) public onlyOwner validateAddress(_admin){
86         require(!superAdmins[_admin]);
87         superAdmins[_admin] = true;
88         emit AddSuperAdmin(_admin);
89     }
90     function removeSuperAdmin(address _admin) public onlyOwner validateAddress(_admin){
91         require(superAdmins[_admin]);
92         superAdmins[_admin] = false;
93         emit RemoveSuperAdmin(_admin);
94     }
95 }
96 // File: contracts/Freezable.sol
97 // Lee, July 29, 2018
98 pragma solidity 0.4.24;
99 contract Freezable is Administratable {
100     bool public frozenToken;
101     mapping (address => bool) public frozenAccounts;
102     event FrozenFunds(address indexed _target, bool _frozen);
103     event FrozenToken(bool _frozen);
104     modifier isNotFrozen( address _to ) {
105         require(!frozenToken);
106         require(!frozenAccounts[msg.sender] && !frozenAccounts[_to]);
107         _;
108     }
109     modifier isNotFrozenFrom( address _from, address _to ) {
110         require(!frozenToken);
111         require(!frozenAccounts[msg.sender] && !frozenAccounts[_from] && !frozenAccounts[_to]);
112         _;
113     }
114     function freezeAccount(address _target, bool _freeze) public onlySuperAdmins validateAddress(_target) {
115         require(frozenAccounts[_target] != _freeze);
116         frozenAccounts[_target] = _freeze;
117         emit FrozenFunds(_target, _freeze);
118     }
119     function freezeToken(bool _freeze) public onlySuperAdmins {
120         require(frozenToken != _freeze);
121         frozenToken = _freeze;
122         emit FrozenToken(frozenToken);
123     }
124 }
125 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
126 /**
127  * @title SafeMath
128  * @dev Math operations with safety checks that revert on error
129  */
130 library SafeMath {
131   /**
132   * @dev Multiplies two numbers, reverts on overflow.
133   */
134   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
135     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
136     // benefit is lost if 'b' is also tested.
137     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
138     if (a == 0) {
139       return 0;
140     }
141     uint256 c = a * b;
142     require(c / a == b);
143     return c;
144   }
145   /**
146   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
147   */
148   function div(uint256 a, uint256 b) internal pure returns (uint256) {
149     require(b > 0); // Solidity only automatically asserts when dividing by 0
150     uint256 c = a / b;
151     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
152     return c;
153   }
154   /**
155   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
156   */
157   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
158     require(b <= a);
159     uint256 c = a - b;
160     return c;
161   }
162   /**
163   * @dev Adds two numbers, reverts on overflow.
164   */
165   function add(uint256 a, uint256 b) internal pure returns (uint256) {
166     uint256 c = a + b;
167     require(c >= a);
168     return c;
169   }
170   /**
171   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
172   * reverts when dividing by zero.
173   */
174   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
175     require(b != 0);
176     return a % b;
177   }
178 }
179 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
180 /**
181  * @title ERC20 interface
182  * @dev see https://github.com/ethereum/EIPs/issues/20
183  */
184 interface IERC20 {
185   function totalSupply() external view returns (uint256);
186   function balanceOf(address who) external view returns (uint256);
187   function allowance(address owner, address spender)
188     external view returns (uint256);
189   function transfer(address to, uint256 value) external returns (bool);
190   function approve(address spender, uint256 value)
191     external returns (bool);
192   function transferFrom(address from, address to, uint256 value)
193     external returns (bool);
194   event Transfer(
195     address indexed from,
196     address indexed to,
197     uint256 value
198   );
199   event Approval(
200     address indexed owner,
201     address indexed spender,
202     uint256 value
203   );
204 }
205 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
206 /**
207  * @title Standard ERC20 token
208  *
209  * @dev Implementation of the basic standard token.
210  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
211  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
212  */
213 contract ERC20 is IERC20 {
214   using SafeMath for uint256;
215   mapping (address => uint256) private _balances;
216   mapping (address => mapping (address => uint256)) private _allowed;
217   uint256 private _totalSupply;
218   /**
219   * @dev Total number of tokens in existence
220   */
221   function totalSupply() public view returns (uint256) {
222     return _totalSupply;
223   }
224   /**
225   * @dev Gets the balance of the specified address.
226   * @param owner The address to query the the balance of.
227   * @return An uint256 representing the amount owned by the passed address.
228   */
229   function balanceOf(address owner) public view returns (uint256) {
230     return _balances[owner];
231   }
232   /**
233    * @dev Function to check the amount of tokens that an owner allowed to a spender.
234    * @param owner address The address which owns the funds.
235    * @param spender address The address which will spend the funds.
236    * @return A uint256 specifying the amount of tokens still available for the spender.
237    */
238   function allowance(
239     address owner,
240     address spender
241    )
242     public
243     view
244     returns (uint256)
245   {
246     return _allowed[owner][spender];
247   }
248   /**
249   * @dev Transfer token for a specified address
250   * @param to The address to transfer to.
251   * @param value The amount to be transferred.
252   */
253   function transfer(address to, uint256 value) public returns (bool) {
254     require(value <= _balances[msg.sender]);
255     require(to != address(0));
256     _balances[msg.sender] = _balances[msg.sender].sub(value);
257     _balances[to] = _balances[to].add(value);
258     emit Transfer(msg.sender, to, value);
259     return true;
260   }
261   /**
262    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
263    * Beware that changing an allowance with this method brings the risk that someone may use both the old
264    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
265    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
266    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
267    * @param spender The address which will spend the funds.
268    * @param value The amount of tokens to be spent.
269    */
270   function approve(address spender, uint256 value) public returns (bool) {
271     require(spender != address(0));
272     _allowed[msg.sender][spender] = value;
273     emit Approval(msg.sender, spender, value);
274     return true;
275   }
276   /**
277    * @dev Transfer tokens from one address to another
278    * @param from address The address which you want to send tokens from
279    * @param to address The address which you want to transfer to
280    * @param value uint256 the amount of tokens to be transferred
281    */
282   function transferFrom(
283     address from,
284     address to,
285     uint256 value
286   )
287     public
288     returns (bool)
289   {
290     require(value <= _balances[from]);
291     require(value <= _allowed[from][msg.sender]);
292     require(to != address(0));
293     _balances[from] = _balances[from].sub(value);
294     _balances[to] = _balances[to].add(value);
295     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
296     emit Transfer(from, to, value);
297     return true;
298   }
299   /**
300    * @dev Increase the amount of tokens that an owner allowed to a spender.
301    * approve should be called when allowed_[_spender] == 0. To increment
302    * allowed value is better to use this function to avoid 2 calls (and wait until
303    * the first transaction is mined)
304    * From MonolithDAO Token.sol
305    * @param spender The address which will spend the funds.
306    * @param addedValue The amount of tokens to increase the allowance by.
307    */
308   function increaseAllowance(
309     address spender,
310     uint256 addedValue
311   )
312     public
313     returns (bool)
314   {
315     require(spender != address(0));
316     _allowed[msg.sender][spender] = (
317       _allowed[msg.sender][spender].add(addedValue));
318     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
319     return true;
320   }
321   /**
322    * @dev Decrease the amount of tokens that an owner allowed to a spender.
323    * approve should be called when allowed_[_spender] == 0. To decrement
324    * allowed value is better to use this function to avoid 2 calls (and wait until
325    * the first transaction is mined)
326    * From MonolithDAO Token.sol
327    * @param spender The address which will spend the funds.
328    * @param subtractedValue The amount of tokens to decrease the allowance by.
329    */
330   function decreaseAllowance(
331     address spender,
332     uint256 subtractedValue
333   )
334     public
335     returns (bool)
336   {
337     require(spender != address(0));
338     _allowed[msg.sender][spender] = (
339       _allowed[msg.sender][spender].sub(subtractedValue));
340     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
341     return true;
342   }
343   /**
344    * @dev Internal function that mints an amount of the token and assigns it to
345    * an account. This encapsulates the modification of balances such that the
346    * proper events are emitted.
347    * @param account The account that will receive the created tokens.
348    * @param amount The amount that will be created.
349    */
350   function _mint(address account, uint256 amount) internal {
351     require(account != 0);
352     _totalSupply = _totalSupply.add(amount);
353     _balances[account] = _balances[account].add(amount);
354     emit Transfer(address(0), account, amount);
355   }
356   /**
357    * @dev Internal function that burns an amount of the token of a given
358    * account.
359    * @param account The account whose tokens will be burnt.
360    * @param amount The amount that will be burnt.
361    */
362   function _burn(address account, uint256 amount) internal {
363     require(account != 0);
364     require(amount <= _balances[account]);
365     _totalSupply = _totalSupply.sub(amount);
366     _balances[account] = _balances[account].sub(amount);
367     emit Transfer(account, address(0), amount);
368   }
369   /**
370    * @dev Internal function that burns an amount of the token of a given
371    * account, deducting from the sender's allowance for said account. Uses the
372    * internal burn function.
373    * @param account The account whose tokens will be burnt.
374    * @param amount The amount that will be burnt.
375    */
376   function _burnFrom(address account, uint256 amount) internal {
377     require(amount <= _allowed[account][msg.sender]);
378     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
379     // this function needs to emit an event with the updated approval.
380     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
381       amount);
382     _burn(account, amount);
383   }
384 }
385 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
386 /**
387  * @title Burnable Token
388  * @dev Token that can be irreversibly burned (destroyed).
389  */
390 contract ERC20Burnable is ERC20 {
391   /**
392    * @dev Burns a specific amount of tokens.
393    * @param value The amount of token to be burned.
394    */
395   function burn(uint256 value) public {
396     _burn(msg.sender, value);
397   }
398   /**
399    * @dev Burns a specific amount of tokens from the target address and decrements allowance
400    * @param from address The address which you want to send tokens from
401    * @param value uint256 The amount of token to be burned
402    */
403   function burnFrom(address from, uint256 value) public {
404     _burnFrom(from, value);
405   }
406   /**
407    * @dev Overrides ERC20._burn in order for burn and burnFrom to emit
408    * an additional Burn event.
409    */
410   function _burn(address who, uint256 value) internal {
411     super._burn(who, value);
412   }
413 }
414 // File: contracts/PlusCoin.sol
415 // Lee, July 29, 2018
416 pragma solidity 0.4.24;
417 contract PlusCoin is ERC20Burnable, Freezable
418 {
419     string  public  constant name       = "PlusCoin";
420     string  public  constant symbol     = "NPLC";
421     uint8   public  constant decimals   = 18;
422     
423     event Burn(address indexed _burner, uint _value);
424     constructor( address _registry, uint _totalTokenAmount ) public
425     {
426         _mint(_registry, _totalTokenAmount);
427         addSuperAdmin(_registry);
428     }
429     /**
430     * @dev Transfer token for a specified address
431     * @param _to The address to transfer to.
432     * @param _value The amount to be transferred.
433     */    
434     function transfer(address _to, uint _value) public validateAddress(_to) isNotFrozen(_to) returns (bool) 
435     {
436         return super.transfer(_to, _value);
437     }
438     /**
439     * @dev Transfer tokens from one address to another
440     * @param _from address The address which you want to send tokens from
441     * @param _to address The address which you want to transfer to
442     * @param _value uint256 the amount of tokens to be transferred
443     */
444     function transferFrom(address _from, address _to, uint _value) public validateAddress(_to)  isNotFrozenFrom(_from, _to) returns (bool) 
445     {
446         return super.transferFrom(_from, _to, _value);
447     }
448     function approve(address _spender, uint256 _value) public validateAddress(_spender) isNotFrozen(_spender)  returns (bool) 
449     {
450         return super.approve(_spender, _value);
451     }
452     function increaseAllowance( address _spender, uint256 _addedValue ) public validateAddress(_spender) isNotFrozen(_spender)  returns (bool)
453     {
454         return super.increaseAllowance(_spender, _addedValue);
455     }
456     function decreaseAllowance(address _spender, uint256 _subtractedValue) public validateAddress(_spender) isNotFrozen(_spender)  returns (bool)
457     {
458         return super.decreaseAllowance(_spender, _subtractedValue);
459     }
460     /**
461     * @dev Token Contract Emergency Drain
462     * @param _token - Token to drain
463     * @param _amount - Amount to drain
464     */
465     function emergencyERC20Drain( IERC20 _token, uint _amount ) public onlyOwner {
466         _token.transfer( owner(), _amount );
467     }
468 }