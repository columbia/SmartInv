1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 contract ERC20 {
8   function totalSupply() public view returns (uint256);
9 
10   function balanceOf(address _who) public view returns (uint256);
11 
12   function allowance(address _owner, address _spender)
13     public view returns (uint256);
14 
15   function transfer(address _to, uint256 _value) public returns (bool);
16 
17   function approve(address _spender, uint256 _value)
18     public returns (bool);
19 
20   function transferFrom(address _from, address _to, uint256 _value)
21     public returns (bool);
22 
23   event Transfer(
24     address indexed from,
25     address indexed to,
26     uint256 value
27   );
28 
29   event Approval(
30     address indexed owner,
31     address indexed spender,
32     uint256 value
33   );
34 }
35 
36 /**
37  * @title SafeMath
38  * @dev Math operations with safety checks that revert on error
39  */
40 library SafeMath {
41 
42   /**
43   * @dev Multiplies two numbers, reverts on overflow.
44   */
45   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
46     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47     // benefit is lost if 'b' is also tested.
48     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
49     if (_a == 0) {
50       return 0;
51     }
52 
53     uint256 c = _a * _b;
54     require(c / _a == _b);
55 
56     return c;
57   }
58 
59   /**
60   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
61   */
62   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
63     require(_b > 0); // Solidity only automatically asserts when dividing by 0
64     uint256 c = _a / _b;
65     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
66 
67     return c;
68   }
69 
70   /**
71   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
72   */
73   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
74     require(_b <= _a);
75     uint256 c = _a - _b;
76 
77     return c;
78   }
79 
80   /**
81   * @dev Adds two numbers, reverts on overflow.
82   */
83   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
84     uint256 c = _a + _b;
85     require(c >= _a);
86 
87     return c;
88   }
89 
90   /**
91   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
92   * reverts when dividing by zero.
93   */
94   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
95     require(b != 0);
96     return a % b;
97   }
98 }
99 
100 /**
101  * @title Standard ERC20 token
102  *
103  * @dev Implementation of the basic standard token.
104  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
105  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
106  */
107 contract StandardToken is ERC20 {
108   using SafeMath for uint256;
109 
110   mapping (address => uint256) private balances;
111 
112   mapping (address => mapping (address => uint256)) private allowed;
113 
114   uint256 private totalSupply_;
115 
116   /**
117   * @dev Total number of tokens in existence
118   */
119   function totalSupply() public view returns (uint256) {
120     return totalSupply_;
121   }
122 
123   /**
124   * @dev Gets the balance of the specified address.
125   * @param _owner The address to query the the balance of.
126   * @return An uint256 representing the amount owned by the passed address.
127   */
128   function balanceOf(address _owner) public view returns (uint256) {
129     return balances[_owner];
130   }
131 
132   /**
133    * @dev Function to check the amount of tokens that an owner allowed to a spender.
134    * @param _owner address The address which owns the funds.
135    * @param _spender address The address which will spend the funds.
136    * @return A uint256 specifying the amount of tokens still available for the spender.
137    */
138   function allowance(
139     address _owner,
140     address _spender
141    )
142     public
143     view
144     returns (uint256)
145   {
146     return allowed[_owner][_spender];
147   }
148 
149   /**
150   * @dev Transfer token for a specified address
151   * @param _to The address to transfer to.
152   * @param _value The amount to be transferred.
153   */
154   function transfer(address _to, uint256 _value) public returns (bool) {
155     require(_value <= balances[msg.sender]);
156     require(_to != address(0));
157 
158     balances[msg.sender] = balances[msg.sender].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     emit Transfer(msg.sender, _to, _value);
161     return true;
162   }
163 
164   /**
165    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
166    * Beware that changing an allowance with this method brings the risk that someone may use both the old
167    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
168    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
169    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
170    * @param _spender The address which will spend the funds.
171    * @param _value The amount of tokens to be spent.
172    */
173   function approve(address _spender, uint256 _value) public returns (bool) {
174     allowed[msg.sender][_spender] = _value;
175     emit Approval(msg.sender, _spender, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Transfer tokens from one address to another
181    * @param _from address The address which you want to send tokens from
182    * @param _to address The address which you want to transfer to
183    * @param _value uint256 the amount of tokens to be transferred
184    */
185   function transferFrom(
186     address _from,
187     address _to,
188     uint256 _value
189   )
190     public
191     returns (bool)
192   {
193     require(_value <= balances[_from]);
194     require(_value <= allowed[_from][msg.sender]);
195     require(_to != address(0));
196 
197     balances[_from] = balances[_from].sub(_value);
198     balances[_to] = balances[_to].add(_value);
199     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
200     emit Transfer(_from, _to, _value);
201     return true;
202   }
203 
204   /**
205    * @dev Increase the amount of tokens that an owner allowed to a spender.
206    * approve should be called when allowed[_spender] == 0. To increment
207    * allowed value is better to use this function to avoid 2 calls (and wait until
208    * the first transaction is mined)
209    * From MonolithDAO Token.sol
210    * @param _spender The address which will spend the funds.
211    * @param _addedValue The amount of tokens to increase the allowance by.
212    */
213   function increaseApproval(
214     address _spender,
215     uint256 _addedValue
216   )
217     public
218     returns (bool)
219   {
220     allowed[msg.sender][_spender] = (
221       allowed[msg.sender][_spender].add(_addedValue));
222     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223     return true;
224   }
225 
226   /**
227    * @dev Decrease the amount of tokens that an owner allowed to a spender.
228    * approve should be called when allowed[_spender] == 0. To decrement
229    * allowed value is better to use this function to avoid 2 calls (and wait until
230    * the first transaction is mined)
231    * From MonolithDAO Token.sol
232    * @param _spender The address which will spend the funds.
233    * @param _subtractedValue The amount of tokens to decrease the allowance by.
234    */
235   function decreaseApproval(
236     address _spender,
237     uint256 _subtractedValue
238   )
239     public
240     returns (bool)
241   {
242     uint256 oldValue = allowed[msg.sender][_spender];
243     if (_subtractedValue >= oldValue) {
244       allowed[msg.sender][_spender] = 0;
245     } else {
246       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
247     }
248     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
249     return true;
250   }
251 
252   /**
253    * @dev Internal function that mints an amount of the token and assigns it to
254    * an account. This encapsulates the modification of balances such that the
255    * proper events are emitted.
256    * @param _account The account that will receive the created tokens.
257    * @param _amount The amount that will be created.
258    */
259   function _mint(address _account, uint256 _amount) internal {
260     require(_account != 0);
261     totalSupply_ = totalSupply_.add(_amount);
262     balances[_account] = balances[_account].add(_amount);
263     emit Transfer(address(0), _account, _amount);
264   }
265 
266   /**
267    * @dev Internal function that burns an amount of the token of a given
268    * account.
269    * @param _account The account whose tokens will be burnt.
270    * @param _amount The amount that will be burnt.
271    */
272   function _burn(address _account, uint256 _amount) internal {
273     require(_account != 0);
274     require(_amount <= balances[_account]);
275 
276     totalSupply_ = totalSupply_.sub(_amount);
277     balances[_account] = balances[_account].sub(_amount);
278     emit Transfer(_account, address(0), _amount);
279   }
280 
281   /**
282    * @dev Internal function that burns an amount of the token of a given
283    * account, deducting from the sender's allowance for said account. Uses the
284    * internal _burn function.
285    * @param _account The account whose tokens will be burnt.
286    * @param _amount The amount that will be burnt.
287    */
288   function _burnFrom(address _account, uint256 _amount) internal {
289     require(_amount <= allowed[_account][msg.sender]);
290 
291     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
292     // this function needs to emit an event with the updated approval.
293     allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
294     _burn(_account, _amount);
295   }
296 }
297 
298 /**
299  * @title Burnable Token
300  * @dev Token that can be irreversibly burned (destroyed).
301  */
302 contract BurnableToken is StandardToken {
303 
304   event Burn(address indexed burner, uint256 value);
305 
306   /**
307    * @dev Burns a specific amount of tokens.
308    * @param _value The amount of token to be burned.
309    */
310   function burn(uint256 _value) public {
311     _burn(msg.sender, _value);
312   }
313 
314   /**
315    * @dev Burns a specific amount of tokens from the target address and decrements allowance
316    * @param _from address The address which you want to send tokens from
317    * @param _value uint256 The amount of token to be burned
318    */
319   function burnFrom(address _from, uint256 _value) public {
320     _burnFrom(_from, _value);
321   }
322 
323   /**
324    * @dev Overrides StandardToken._burn in order for burn and burnFrom to emit
325    * an additional Burn event.
326    */
327   function _burn(address _who, uint256 _value) internal {
328     super._burn(_who, _value);
329     emit Burn(_who, _value);
330   }
331 }
332 
333 /**
334  * @title Ownable
335  * @dev The Ownable contract has an owner address, and provides basic authorization control
336  * functions, this simplifies the implementation of "user permissions".
337  */
338 contract Ownable {
339   address public owner;
340 
341 
342   event OwnershipRenounced(address indexed previousOwner);
343   event OwnershipTransferred(
344     address indexed previousOwner,
345     address indexed newOwner
346   );
347 
348 
349   /**
350    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
351    * account.
352    */
353   constructor() public {
354     owner = msg.sender;
355   }
356 
357   /**
358    * @dev Throws if called by any account other than the owner.
359    */
360   modifier onlyOwner() {
361     require(msg.sender == owner);
362     _;
363   }
364 
365   /**
366    * @dev Allows the current owner to relinquish control of the contract.
367    * @notice Renouncing to ownership will leave the contract without an owner.
368    * It will not be possible to call the functions with the `onlyOwner`
369    * modifier anymore.
370    */
371   function renounceOwnership() public onlyOwner {
372     emit OwnershipRenounced(owner);
373     owner = address(0);
374   }
375 
376   /**
377    * @dev Allows the current owner to transfer control of the contract to a newOwner.
378    * @param _newOwner The address to transfer ownership to.
379    */
380   function transferOwnership(address _newOwner) public onlyOwner {
381     _transferOwnership(_newOwner);
382   }
383 
384   /**
385    * @dev Transfers control of the contract to a newOwner.
386    * @param _newOwner The address to transfer ownership to.
387    */
388   function _transferOwnership(address _newOwner) internal {
389     require(_newOwner != address(0));
390     emit OwnershipTransferred(owner, _newOwner);
391     owner = _newOwner;
392   }
393 }
394 
395 /// @title Alex token implementation
396 /// @author Aler Denisov <aler.zampillo@gmail.com>
397 /// @dev Implements ERC20
398 contract MainCoin is BurnableToken, Ownable {
399   /// @notice Constant field with token full name
400   // solium-disable-next-line uppercase
401   string constant public name = "MainCoin"; 
402   /// @notice Constant field with token symbol
403   string constant public symbol = "MNC"; // solium-disable-line uppercase
404   /// @notice Constant field with token precision depth
405   uint256 constant public decimals = 18; // solium-disable-line uppercase
406   /// @notice Constant field with token cap (total supply limit) - 500M 
407   uint256 constant public initial = 500 ether * 10 ** 6; // solium-disable-line uppercase
408 
409   mapping (address=>bool) public allowedAddresses;
410   bool public unfrozen;
411 
412   event Unfreeze();
413 
414   constructor() public {
415     _mint(msg.sender, initial);
416   }
417 
418 
419   function allowTransfer(address _for) public onlyOwner returns (bool) {
420     allowedAddresses[_for] = true;
421     return true;
422   }
423 
424   function disableTransfer(address _for) public onlyOwner returns (bool) {
425     allowedAddresses[_for] = false;
426     return true;
427   }
428   
429   modifier isTrasferAllowed(address a, address b) {
430     require(unfrozen || allowedAddresses[a] || allowedAddresses[b]);
431     _;
432   }
433   /// @notice Finalizes contract
434   /// @dev Requires owner role to interact
435   /// @return A boolean that indicates if the operation was successful.
436   function unfreeze() public onlyOwner returns (bool) {
437     require(!unfrozen);
438     unfrozen = true;
439     emit Unfreeze();
440     return true;
441   }
442 
443 
444   /// @dev Overrides burnable interface to prevent interaction before finalization
445   function burn(uint256 _value) public isTrasferAllowed(msg.sender, address(0x0)) {
446     super.burn(_value);
447   }
448 
449   /// @dev Overrides burnable interface to prevent interaction before finalization
450   function burnFrom(address _from, uint256 _value) isTrasferAllowed(_from, address(0x0)) public {
451     super.burnFrom(_from, _value);
452   }
453 
454   /// @dev Overrides ERC20 interface to prevent interaction before finalization
455   function transferFrom(address _from, address _to, uint256 _value) public isTrasferAllowed(_from, _to) returns (bool) {
456     return super.transferFrom(_from, _to, _value);
457   }
458 
459   /// @dev Overrides ERC20 interface to prevent interaction before finalization
460   function transfer(address _to, uint256 _value) public isTrasferAllowed(msg.sender, _to) returns (bool) {
461     return super.transfer(_to, _value);
462   }
463 
464   /// @dev Overrides ERC20 interface to prevent interaction before finalization
465   function approve(address _spender, uint256 _value) public isTrasferAllowed(msg.sender, _spender) returns (bool) {
466     return super.approve(_spender, _value);
467   }
468 
469   /// @dev Overrides ERC20 interface to prevent interaction before finalization
470   function increaseApproval(address _spender, uint256 _addedValue) public isTrasferAllowed(msg.sender, _spender) returns (bool) {
471     return super.increaseApproval(_spender, _addedValue);
472   }
473 
474   /// @dev Overrides ERC20 interface to prevent interaction before finalization
475   function decreaseApproval(address _spender, uint256 _subtractedValue) public isTrasferAllowed(msg.sender, _spender) returns (bool) {
476     return super.decreaseApproval(_spender, _subtractedValue);
477   }
478 }