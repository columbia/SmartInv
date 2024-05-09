1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     emit OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 /**
44  * @title SafeMath
45  * @dev Math operations with safety checks that throw on error
46  */
47 library SafeMath {
48 
49   /**
50   * @dev Multiplies two numbers, throws on overflow.
51   */
52   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
53     if (a == 0) {
54       return 0;
55     }
56     c = a * b;
57     assert(c / a == b);
58     return c;
59   }
60 
61   /**
62   * @dev Integer division of two numbers, truncating the quotient.
63   */
64   function div(uint256 a, uint256 b) internal pure returns (uint256) {
65     // assert(b > 0); // Solidity automatically throws when dividing by 0
66     // uint256 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68     return a / b;
69   }
70 
71   /**
72   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
73   */
74   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75     assert(b <= a);
76     return a - b;
77   }
78 
79   /**
80   * @dev Adds two numbers, throws on overflow.
81   */
82   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
83     c = a + b;
84     assert(c >= a);
85     return c;
86   }
87 }
88 
89 /**
90  * @title ERC20Basic
91  * @dev Simpler version of ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/179
93  */
94 contract ERC20Basic {
95   function totalSupply() public view returns (uint256);
96   function balanceOf(address who) public view returns (uint256);
97   function transfer(address to, uint256 value) public returns (bool);
98   event Transfer(address indexed from, address indexed to, uint256 value);
99 }
100 
101 
102 /**
103  * @title ERC20 interface
104  * @dev see https://github.com/ethereum/EIPs/issues/20
105  */
106 contract ERC20 is ERC20Basic {
107   function allowance(address owner, address spender) public view returns (uint256);
108   function transferFrom(address from, address to, uint256 value) public returns (bool);
109   function approve(address spender, uint256 value) public returns (bool);
110   event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 
113 /**
114  * @title SafeERC20
115  * @dev Wrappers around ERC20 operations that throw on failure.
116  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
117  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
118  */
119 library SafeERC20 {
120   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
121     assert(token.transfer(to, value));
122   }
123 
124   function safeTransferFrom(
125     ERC20 token,
126     address from,
127     address to,
128     uint256 value
129   )
130     internal
131   {
132     assert(token.transferFrom(from, to, value));
133   }
134 
135   function safeApprove(ERC20 token, address spender, uint256 value) internal {
136     assert(token.approve(spender, value));
137   }
138 }
139 
140 /**
141  * @title Basic token
142  * @dev Basic version of StandardToken, with no allowances.
143  */
144 contract BasicToken is ERC20Basic {
145   using SafeMath for uint256;
146 
147   mapping(address => uint256) balances;
148 
149   uint256 totalSupply_;
150 
151   /**
152   * @dev total number of tokens in existence
153   */
154   function totalSupply() public view returns (uint256) {
155     return totalSupply_;
156   }
157 
158   /**
159   * @dev transfer token for a specified address
160   * @param _to The address to transfer to.
161   * @param _value The amount to be transferred.
162   */
163   function transfer(address _to, uint256 _value) public returns (bool) {
164     require(_to != address(0));
165     require(_value <= balances[msg.sender]);
166 
167     balances[msg.sender] = balances[msg.sender].sub(_value);
168     balances[_to] = balances[_to].add(_value);
169     emit Transfer(msg.sender, _to, _value);
170     return true;
171   }
172 
173   /**
174   * @dev Gets the balance of the specified address.
175   * @param _owner The address to query the the balance of.
176   * @return An uint256 representing the amount owned by the passed address.
177   */
178   function balanceOf(address _owner) public view returns (uint256) {
179     return balances[_owner];
180   }
181 
182 }
183 
184 /**
185  * @title TokenTimelock
186  * @dev TokenTimelock is a token holder contract that will allow a
187  * beneficiary to extract the tokens after a given release time
188  */
189 contract TokenTimelock {
190   using SafeERC20 for ERC20Basic;
191 
192   // ERC20 basic token contract being held
193   ERC20Basic public token;
194 
195   // beneficiary of tokens after they are released
196   address public beneficiary;
197 
198   // timestamp when token release is enabled
199   uint256 public releaseTime;
200 
201   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
202     // solium-disable-next-line security/no-block-members
203     require(_releaseTime > block.timestamp);
204     token = _token;
205     beneficiary = _beneficiary;
206     releaseTime = _releaseTime;
207   }
208 
209   /**
210    * @notice Transfers tokens held by timelock to beneficiary.
211    */
212   function release() public {
213     // solium-disable-next-line security/no-block-members
214     require(block.timestamp >= releaseTime);
215 
216     uint256 amount = token.balanceOf(this);
217     require(amount > 0);
218 
219     token.safeTransfer(beneficiary, amount);
220   }
221 }
222 
223 /**
224  * @title Burnable Token
225  * @dev Token that can be irreversibly burned (destroyed).
226  */
227 contract BurnableToken is BasicToken {
228 
229   event Burn(address indexed burner, uint256 value);
230 
231   /**
232    * @dev Burns a specific amount of tokens.
233    * @param _value The amount of token to be burned.
234    */
235   function burn(uint256 _value) public {
236     _burn(msg.sender, _value);
237   }
238 
239   function _burn(address _who, uint256 _value) internal {
240     require(_value <= balances[_who]);
241     // no need to require value <= totalSupply, since that would imply the
242     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
243 
244     balances[_who] = balances[_who].sub(_value);
245     totalSupply_ = totalSupply_.sub(_value);
246     emit Burn(_who, _value);
247     emit Transfer(_who, address(0), _value);
248   }
249 }
250 
251 /**
252  * @title Standard ERC20 token
253  *
254  * @dev Implementation of the basic standard token.
255  * @dev https://github.com/ethereum/EIPs/issues/20
256  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
257  */
258 contract StandardToken is ERC20, BasicToken {
259 
260   mapping (address => mapping (address => uint256)) internal allowed;
261 
262 
263   /**
264    * @dev Transfer tokens from one address to another
265    * @param _from address The address which you want to send tokens from
266    * @param _to address The address which you want to transfer to
267    * @param _value uint256 the amount of tokens to be transferred
268    */
269   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
270     require(_to != address(0));
271     require(_value <= balances[_from]);
272     require(_value <= allowed[_from][msg.sender]);
273 
274     balances[_from] = balances[_from].sub(_value);
275     balances[_to] = balances[_to].add(_value);
276     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
277     emit Transfer(_from, _to, _value);
278     return true;
279   }
280 
281   /**
282    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
283    *
284    * Beware that changing an allowance with this method brings the risk that someone may use both the old
285    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
286    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
287    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
288    * @param _spender The address which will spend the funds.
289    * @param _value The amount of tokens to be spent.
290    */
291   function approve(address _spender, uint256 _value) public returns (bool) {
292     allowed[msg.sender][_spender] = _value;
293     emit Approval(msg.sender, _spender, _value);
294     return true;
295   }
296 
297   /**
298    * @dev Function to check the amount of tokens that an owner allowed to a spender.
299    * @param _owner address The address which owns the funds.
300    * @param _spender address The address which will spend the funds.
301    * @return A uint256 specifying the amount of tokens still available for the spender.
302    */
303   function allowance(address _owner, address _spender) public view returns (uint256) {
304     return allowed[_owner][_spender];
305   }
306 
307   /**
308    * @dev Increase the amount of tokens that an owner allowed to a spender.
309    *
310    * approve should be called when allowed[_spender] == 0. To increment
311    * allowed value is better to use this function to avoid 2 calls (and wait until
312    * the first transaction is mined)
313    * From MonolithDAO Token.sol
314    * @param _spender The address which will spend the funds.
315    * @param _addedValue The amount of tokens to increase the allowance by.
316    */
317   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
318     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
319     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
320     return true;
321   }
322 
323   /**
324    * @dev Decrease the amount of tokens that an owner allowed to a spender.
325    *
326    * approve should be called when allowed[_spender] == 0. To decrement
327    * allowed value is better to use this function to avoid 2 calls (and wait until
328    * the first transaction is mined)
329    * From MonolithDAO Token.sol
330    * @param _spender The address which will spend the funds.
331    * @param _subtractedValue The amount of tokens to decrease the allowance by.
332    */
333   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
334     uint oldValue = allowed[msg.sender][_spender];
335     if (_subtractedValue > oldValue) {
336       allowed[msg.sender][_spender] = 0;
337     } else {
338       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
339     }
340     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
341     return true;
342   }
343 
344 }
345 
346 /**
347  * @title Mintable token
348  * @dev Simple ERC20 Token example, with mintable token creation
349  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
350  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
351  */
352 contract MintableToken is StandardToken, Ownable {
353   event Mint(address indexed to, uint256 amount);
354   event MintFinished();
355 
356   bool public mintingFinished = false;
357 
358 
359   modifier canMint() {
360     require(!mintingFinished);
361     _;
362   }
363 
364   /**
365    * @dev Function to mint tokens
366    * @param _to The address that will receive the minted tokens.
367    * @param _amount The amount of tokens to mint.
368    * @return A boolean that indicates if the operation was successful.
369    */
370   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
371     totalSupply_ = totalSupply_.add(_amount);
372     balances[_to] = balances[_to].add(_amount);
373     emit Mint(_to, _amount);
374     emit Transfer(address(0), _to, _amount);
375     return true;
376   }
377 
378   /**
379    * @dev Function to stop minting new tokens.
380    * @return True if the operation was successful.
381    */
382   function finishMinting() onlyOwner canMint public returns (bool) {
383     mintingFinished = true;
384     emit MintFinished();
385     return true;
386   }
387 }
388 
389 /**
390  * @title Capped token
391  * @dev Mintable token with a token cap.
392  */
393 contract CappedToken is MintableToken {
394 
395   uint256 public cap;
396 
397   function CappedToken(uint256 _cap) public {
398     require(_cap > 0);
399     cap = _cap;
400   }
401 
402   /**
403    * @dev Function to mint tokens
404    * @param _to The address that will receive the minted tokens.
405    * @param _amount The amount of tokens to mint.
406    * @return A boolean that indicates if the operation was successful.
407    */
408   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
409     require(totalSupply_.add(_amount) <= cap);
410 
411     return super.mint(_to, _amount);
412   }
413 
414 }
415 
416 /**
417  * @title Pausable
418  * @dev Base contract which allows children to implement an emergency stop mechanism.
419  */
420 contract Pausable is Ownable {
421   event Pause();
422   event Unpause();
423 
424   bool public paused = false;
425 
426 
427   /**
428    * @dev Modifier to make a function callable only when the contract is not paused.
429    */
430   modifier whenNotPaused() {
431     require(!paused);
432     _;
433   }
434 
435   /**
436    * @dev Modifier to make a function callable only when the contract is paused.
437    */
438   modifier whenPaused() {
439     require(paused);
440     _;
441   }
442 
443   /**
444    * @dev called by the owner to pause, triggers stopped state
445    */
446   function pause() onlyOwner whenNotPaused public {
447     paused = true;
448     emit Pause();
449   }
450 
451   /**
452    * @dev called by the owner to unpause, returns to normal state
453    */
454   function unpause() onlyOwner whenPaused public {
455     paused = false;
456     emit Unpause();
457   }
458 }
459 
460 /**
461  * @title Pausable token
462  * @dev StandardToken modified with pausable transfers.
463  **/
464 contract PausableToken is StandardToken, Pausable {
465 
466   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
467     return super.transfer(_to, _value);
468   }
469 
470   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
471     return super.transferFrom(_from, _to, _value);
472   }
473 
474   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
475     return super.approve(_spender, _value);
476   }
477 
478   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
479     return super.increaseApproval(_spender, _addedValue);
480   }
481 
482   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
483     return super.decreaseApproval(_spender, _subtractedValue);
484   }
485 }
486 
487 contract DetailedERC20 is ERC20 {
488   string public name;
489   string public symbol;
490   uint8 public decimals;
491 
492   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
493     name = _name;
494     symbol = _symbol;
495     decimals = _decimals;
496   }
497 }
498 
499 
500 //import "zeppelin-solidity/contracts/math/SafeMath.sol";
501 //import "zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol";
502 //import "zeppelin-solidity/contracts/token/ERC20/PausableToken.sol";
503 //import "zeppelin-solidity/contracts/token/ERC20/CappedToken.sol";
504 //import "zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol";
505 //import "zeppelin-solidity/contracts/token/ERC20/TokenTimelock.sol";
506 
507 
508 
509 contract SportXToken is DetailedERC20, PausableToken, CappedToken,BurnableToken {
510   using SafeMath for uint256;
511   
512   uint256 private constant TOKEN_UNIT = 10 ** uint256(4);
513   uint256 public constant TOTAL_SUPPLY = 1000 * (10 ** 6) * TOKEN_UNIT;
514 
515   mapping (address => TokenTimelock) private timelock;
516 
517   function SportXToken() public 
518   DetailedERC20("SportX Token", "SOX", 4) 
519   CappedToken(TOTAL_SUPPLY)  { }
520 
521   function mintAndLock(address to, uint256 amount, uint256 releaseTime) onlyOwner public {
522     timelock[to] = new TokenTimelock(this, to, releaseTime);
523     mint(address(timelock[to]), amount);
524   }
525 
526   function unlock(address to) onlyOwner public {
527     TokenTimelock t = timelock[to];
528     t.release();
529   }
530 }