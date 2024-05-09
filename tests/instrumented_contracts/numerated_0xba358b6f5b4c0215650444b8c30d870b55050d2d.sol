1 // File: contracts/token/ERC20/ERC20.sol
2 
3 pragma solidity 0.4.24;
4 
5 
6 /**
7  * @title ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/20
9  */
10 contract ERC20 {
11   function totalSupply() public view returns (uint256);
12 
13   function balanceOf(address _who) public view returns (uint256);
14 
15   function allowance(address _owner, address _spender)
16     public view returns (uint256);
17 
18   function transfer(address _to, uint256 _value) public returns (bool);
19 
20   function approve(address _spender, uint256 _value)
21     public returns (bool);
22 
23   function transferFrom(address _from, address _to, uint256 _value)
24     public returns (bool);
25 
26   event Transfer(
27     address indexed from,
28     address indexed to,
29     uint256 value
30   );
31 
32   event Approval(
33     address indexed owner,
34     address indexed spender,
35     uint256 value
36   );
37 }
38 
39 // File: contracts/math/SafeMath.sol
40 
41 pragma solidity 0.4.24;
42 
43 
44 /**
45  * @title SafeMath
46  * @dev Math operations with safety checks that revert on error
47  */
48 library SafeMath {
49 
50   /**
51   * @dev Multiplies two numbers, reverts on overflow.
52   */
53   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
54     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
55     // benefit is lost if 'b' is also tested.
56     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
57     if (_a == 0) {
58       return 0;
59     }
60 
61     uint256 c = _a * _b;
62     require(c / _a == _b);
63 
64     return c;
65   }
66 
67   /**
68   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
69   */
70   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
71     require(_b > 0); // Solidity only automatically asserts when dividing by 0
72     uint256 c = _a / _b;
73     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
74 
75     return c;
76   }
77 
78   /**
79   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
80   */
81   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
82     require(_b <= _a);
83     uint256 c = _a - _b;
84 
85     return c;
86   }
87 
88   /**
89   * @dev Adds two numbers, reverts on overflow.
90   */
91   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
92     uint256 c = _a + _b;
93     require(c >= _a);
94 
95     return c;
96   }
97 
98   /**
99   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
100   * reverts when dividing by zero.
101   */
102   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
103     require(b != 0);
104     return a % b;
105   }
106 }
107 
108 // File: contracts/token/ERC20/StandardToken.sol
109 
110 pragma solidity 0.4.24;
111 
112 
113 
114 
115 /**
116  * @title Standard ERC20 token
117  *
118  * @dev Implementation of the basic standard token.
119  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
120  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
121  */
122 contract StandardToken is ERC20 {
123   using SafeMath for uint256;
124 
125   mapping (address => uint256) private balances;
126 
127   mapping (address => mapping (address => uint256)) private allowed;
128 
129   uint256 private totalSupply_;
130 
131   /**
132   * @dev Total number of tokens in existence
133   */
134   function totalSupply() public view returns (uint256) {
135     return totalSupply_;
136   }
137 
138   /**
139   * @dev Gets the balance of the specified address.
140   * @param _owner The address to query the the balance of.
141   * @return An uint256 representing the amount owned by the passed address.
142   */
143   function balanceOf(address _owner) public view returns (uint256) {
144     return balances[_owner];
145   }
146 
147   /**
148    * @dev Function to check the amount of tokens that an owner allowed to a spender.
149    * @param _owner address The address which owns the funds.
150    * @param _spender address The address which will spend the funds.
151    * @return A uint256 specifying the amount of tokens still available for the spender.
152    */
153   function allowance(
154     address _owner,
155     address _spender
156    )
157     public
158     view
159     returns (uint256)
160   {
161     return allowed[_owner][_spender];
162   }
163 
164   /**
165   * @dev Transfer token for a specified address
166   * @param _to The address to transfer to.
167   * @param _value The amount to be transferred.
168   */
169   function transfer(address _to, uint256 _value) public returns (bool) {
170     require(_value <= balances[msg.sender]);
171     require(_to != address(0));
172 
173     balances[msg.sender] = balances[msg.sender].sub(_value);
174     balances[_to] = balances[_to].add(_value);
175     emit Transfer(msg.sender, _to, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
181    * Beware that changing an allowance with this method brings the risk that someone may use both the old
182    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
183    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
184    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
185    * @param _spender The address which will spend the funds.
186    * @param _value The amount of tokens to be spent.
187    */
188   function approve(address _spender, uint256 _value) public returns (bool) {
189     allowed[msg.sender][_spender] = _value;
190     emit Approval(msg.sender, _spender, _value);
191     return true;
192   }
193 
194   /**
195    * @dev Transfer tokens from one address to another
196    * @param _from address The address which you want to send tokens from
197    * @param _to address The address which you want to transfer to
198    * @param _value uint256 the amount of tokens to be transferred
199    */
200   function transferFrom(
201     address _from,
202     address _to,
203     uint256 _value
204   )
205     public
206     returns (bool)
207   {
208     require(_value <= balances[_from]);
209     require(_value <= allowed[_from][msg.sender]);
210     require(_to != address(0));
211 
212     balances[_from] = balances[_from].sub(_value);
213     balances[_to] = balances[_to].add(_value);
214     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
215     emit Transfer(_from, _to, _value);
216     return true;
217   }
218 
219   /**
220    * @dev Increase the amount of tokens that an owner allowed to a spender.
221    * approve should be called when allowed[_spender] == 0. To increment
222    * allowed value is better to use this function to avoid 2 calls (and wait until
223    * the first transaction is mined)
224    * From MonolithDAO Token.sol
225    * @param _spender The address which will spend the funds.
226    * @param _addedValue The amount of tokens to increase the allowance by.
227    */
228   function increaseApproval(
229     address _spender,
230     uint256 _addedValue
231   )
232     public
233     returns (bool)
234   {
235     allowed[msg.sender][_spender] = (
236       allowed[msg.sender][_spender].add(_addedValue));
237     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238     return true;
239   }
240 
241   /**
242    * @dev Decrease the amount of tokens that an owner allowed to a spender.
243    * approve should be called when allowed[_spender] == 0. To decrement
244    * allowed value is better to use this function to avoid 2 calls (and wait until
245    * the first transaction is mined)
246    * From MonolithDAO Token.sol
247    * @param _spender The address which will spend the funds.
248    * @param _subtractedValue The amount of tokens to decrease the allowance by.
249    */
250   function decreaseApproval(
251     address _spender,
252     uint256 _subtractedValue
253   )
254     public
255     returns (bool)
256   {
257     uint256 oldValue = allowed[msg.sender][_spender];
258     if (_subtractedValue >= oldValue) {
259       allowed[msg.sender][_spender] = 0;
260     } else {
261       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
262     }
263     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
264     return true;
265   }
266 
267   /**
268    * @dev Internal function that mints an amount of the token and assigns it to
269    * an account. This encapsulates the modification of balances such that the
270    * proper events are emitted.
271    * @param _account The account that will receive the created tokens.
272    * @param _amount The amount that will be created.
273    */
274   function _mint(address _account, uint256 _amount) internal {
275     require(_account != 0);
276     totalSupply_ = totalSupply_.add(_amount);
277     balances[_account] = balances[_account].add(_amount);
278     emit Transfer(address(0), _account, _amount);
279   }
280 
281   /**
282    * @dev Internal function that burns an amount of the token of a given
283    * account.
284    * @param _account The account whose tokens will be burnt.
285    * @param _amount The amount that will be burnt.
286    */
287   function _burn(address _account, uint256 _amount) internal {
288     require(_account != 0);
289     require(_amount <= balances[_account]);
290 
291     totalSupply_ = totalSupply_.sub(_amount);
292     balances[_account] = balances[_account].sub(_amount);
293     emit Transfer(_account, address(0), _amount);
294   }
295 
296   /**
297    * @dev Internal function that burns an amount of the token of a given
298    * account, deducting from the sender's allowance for said account. Uses the
299    * internal _burn function.
300    * @param _account The account whose tokens will be burnt.
301    * @param _amount The amount that will be burnt.
302    */
303   function _burnFrom(address _account, uint256 _amount) internal {
304     require(_amount <= allowed[_account][msg.sender]);
305 
306     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
307     // this function needs to emit an event with the updated approval.
308     allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
309     _burn(_account, _amount);
310   }
311 }
312 
313 // File: contracts/token/ERC20/BurnableToken.sol
314 
315 pragma solidity 0.4.24;
316 
317 
318 
319 /**
320  * @title Burnable Token
321  * @dev Token that can be irreversibly burned (destroyed).
322  */
323 contract BurnableToken is StandardToken {
324 
325   event Burn(address indexed burner, uint256 value);
326 
327   /**
328    * @dev Burns a specific amount of tokens.
329    * @param _value The amount of token to be burned.
330    */
331   function burn(uint256 _value) public {
332     _burn(msg.sender, _value);
333   }
334 
335   /**
336    * @dev Burns a specific amount of tokens from the target address and decrements allowance
337    * @param _from address The address which you want to send tokens from
338    * @param _value uint256 The amount of token to be burned
339    */
340   function burnFrom(address _from, uint256 _value) public {
341     _burnFrom(_from, _value);
342   }
343 
344   /**
345    * @dev Overrides StandardToken._burn in order for burn and burnFrom to emit
346    * an additional Burn event.
347    */
348   function _burn(address _who, uint256 _value) internal {
349     super._burn(_who, _value);
350     emit Burn(_who, _value);
351   }
352 }
353 
354 // File: contracts/ownership/Ownable.sol
355 
356 pragma solidity 0.4.24;
357 
358 
359 /**
360  * @title Ownable
361  * @dev The Ownable contract has an owner address, and provides basic authorization control
362  * functions, this simplifies the implementation of "user permissions".
363  */
364 contract Ownable {
365   address public owner;
366 
367 
368   event OwnershipRenounced(address indexed previousOwner);
369   event OwnershipTransferred(
370     address indexed previousOwner,
371     address indexed newOwner
372   );
373 
374 
375   /**
376    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
377    * account.
378    */
379   constructor() public {
380     owner = msg.sender;
381   }
382 
383   /**
384    * @dev Throws if called by any account other than the owner.
385    */
386   modifier onlyOwner() {
387     require(msg.sender == owner);
388     _;
389   }
390 
391   /**
392    * @dev Allows the current owner to relinquish control of the contract.
393    * @notice Renouncing to ownership will leave the contract without an owner.
394    * It will not be possible to call the functions with the `onlyOwner`
395    * modifier anymore.
396    */
397   function renounceOwnership() public onlyOwner {
398     emit OwnershipRenounced(owner);
399     owner = address(0);
400   }
401 
402   /**
403    * @dev Allows the current owner to transfer control of the contract to a newOwner.
404    * @param _newOwner The address to transfer ownership to.
405    */
406   function transferOwnership(address _newOwner) public onlyOwner {
407     _transferOwnership(_newOwner);
408   }
409 
410   /**
411    * @dev Transfers control of the contract to a newOwner.
412    * @param _newOwner The address to transfer ownership to.
413    */
414   function _transferOwnership(address _newOwner) internal {
415     require(_newOwner != address(0));
416     emit OwnershipTransferred(owner, _newOwner);
417     owner = _newOwner;
418   }
419 }
420 
421 // File: contracts/lifecycle/Pausable.sol
422 
423 pragma solidity 0.4.24;
424 
425 
426 
427 /**
428  * @title Pausable
429  * @dev Base contract which allows children to implement an emergency stop mechanism.
430  */
431 contract Pausable is Ownable {
432   event Pause();
433   event Unpause();
434 
435   bool public paused = false;
436 
437 
438   /**
439    * @dev Modifier to make a function callable only when the contract is not paused.
440    */
441   modifier whenNotPaused() {
442     require(!paused);
443     _;
444   }
445 
446   /**
447    * @dev Modifier to make a function callable only when the contract is paused.
448    */
449   modifier whenPaused() {
450     require(paused);
451     _;
452   }
453 
454   /**
455    * @dev called by the owner to pause, triggers stopped state
456    */
457   function pause() public onlyOwner whenNotPaused {
458     paused = true;
459     emit Pause();
460   }
461 
462   /**
463    * @dev called by the owner to unpause, returns to normal state
464    */
465   function unpause() public onlyOwner whenPaused {
466     paused = false;
467     emit Unpause();
468   }
469 }
470 
471 // File: contracts/token/ERC20/HubToken.sol
472 
473 pragma solidity 0.4.24;
474 
475 
476 
477 contract HubToken is BurnableToken, Pausable {
478 
479 	// Constants
480     string  public constant name = "Hub Token";
481     string  public constant symbol = "HUB";
482     uint8   public constant decimals = 18;
483     uint256 public constant INITIAL_SUPPLY = 1750000000 * (10 ** uint256(decimals));
484 
485 	constructor() public {
486 		super._mint(msg.sender, INITIAL_SUPPLY);
487 	}	
488 
489 	function transfer(address _to, uint256 _value) whenNotPaused public returns (bool) {
490 		return super.transfer(_to, _value);
491 	}
492 
493 	function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool) {
494 		return super.transferFrom(_from, _to, _value);
495 	}
496 
497 	function burn(uint256 _value) whenNotPaused public {
498 		super._burn(msg.sender, _value);
499 	}
500 
501 	function burnFrom(address _from, uint256 _value) whenNotPaused public {
502 		super._burnFrom(_from, _value);
503 	}
504 }