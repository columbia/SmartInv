1 pragma solidity ^0.4.24;
2 
3 // File: contracts\token\ERC20\ERC20.sol
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 contract ERC20 {
10   function totalSupply() public view returns (uint256);
11 
12   function balanceOf(address _who) public view returns (uint256);
13 
14   function allowance(address _owner, address _spender)
15     public view returns (uint256);
16 
17   function transfer(address _to, uint256 _value) public returns (bool);
18 
19   function approve(address _spender, uint256 _value)
20     public returns (bool);
21 
22   function transferFrom(address _from, address _to, uint256 _value)
23     public returns (bool);
24 
25   event Transfer(
26     address indexed from,
27     address indexed to,
28     uint256 value
29   );
30 
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: contracts\math\SafeMath.sol
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that revert on error
43  */
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, reverts on overflow.
48   */
49   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
50     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51     // benefit is lost if 'b' is also tested.
52     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53     if (_a == 0) {
54       return 0;
55     }
56 
57     uint256 c = _a * _b;
58     require(c / _a == _b);
59 
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
65   */
66   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
67     require(_b > 0); // Solidity only automatically asserts when dividing by 0
68     uint256 c = _a / _b;
69     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
70 
71     return c;
72   }
73 
74   /**
75   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
76   */
77   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
78     require(_b <= _a);
79     uint256 c = _a - _b;
80 
81     return c;
82   }
83 
84   /**
85   * @dev Adds two numbers, reverts on overflow.
86   */
87   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
88     uint256 c = _a + _b;
89     require(c >= _a);
90 
91     return c;
92   }
93 
94   /**
95   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
96   * reverts when dividing by zero.
97   */
98   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
99     require(b != 0);
100     return a % b;
101   }
102 }
103 
104 // File: contracts\token\ERC20\StandardToken.sol
105 
106 /**
107  * @title Standard ERC20 token
108  *
109  * @dev Implementation of the basic standard token.
110  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
111  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
112  */
113 contract StandardToken is ERC20 {
114   using SafeMath for uint256;
115 
116   mapping (address => uint256) internal balances;
117 
118   mapping (address => mapping (address => uint256)) internal allowed;
119 
120   uint256 internal totalSupply_;
121 
122   /**
123   * @dev Total number of tokens in existence
124   */
125   function totalSupply() public view returns (uint256) {
126     return totalSupply_;
127   }
128 
129   /**
130   * @dev Gets the balance of the specified address.
131   * @param _owner The address to query the the balance of.
132   * @return An uint256 representing the amount owned by the passed address.
133   */
134   function balanceOf(address _owner) public view returns (uint256) {
135     return balances[_owner];
136   }
137 
138   /**
139    * @dev Function to check the amount of tokens that an owner allowed to a spender.
140    * @param _owner address The address which owns the funds.
141    * @param _spender address The address which will spend the funds.
142    * @return A uint256 specifying the amount of tokens still available for the spender.
143    */
144   function allowance(
145     address _owner,
146     address _spender
147    )
148     public
149     view
150     returns (uint256)
151   {
152     return allowed[_owner][_spender];
153   }
154 
155   /**
156   * @dev Transfer token for a specified address
157   * @param _to The address to transfer to.
158   * @param _value The amount to be transferred.
159   */
160   function transfer(address _to, uint256 _value) public returns (bool) {
161     require(_value <= balances[msg.sender]);
162     require(_to != address(0));
163 
164     balances[msg.sender] = balances[msg.sender].sub(_value);
165     balances[_to] = balances[_to].add(_value);
166     emit Transfer(msg.sender, _to, _value);
167     return true;
168   }
169 
170   /**
171    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
172    * Beware that changing an allowance with this method brings the risk that someone may use both the old
173    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
174    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
175    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176    * @param _spender The address which will spend the funds.
177    * @param _value The amount of tokens to be spent.
178    */
179   function approve(address _spender, uint256 _value) public returns (bool) {
180     allowed[msg.sender][_spender] = _value;
181     emit Approval(msg.sender, _spender, _value);
182     return true;
183   }
184 
185   /**
186    * @dev Transfer tokens from one address to another
187    * @param _from address The address which you want to send tokens from
188    * @param _to address The address which you want to transfer to
189    * @param _value uint256 the amount of tokens to be transferred
190    */
191   function transferFrom(
192     address _from,
193     address _to,
194     uint256 _value
195   )
196     public
197     returns (bool)
198   {
199     require(_value <= balances[_from]);
200     require(_value <= allowed[_from][msg.sender]);
201     require(_to != address(0));
202 
203     balances[_from] = balances[_from].sub(_value);
204     balances[_to] = balances[_to].add(_value);
205     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
206     emit Transfer(_from, _to, _value);
207     return true;
208   }
209 
210   /**
211    * @dev Increase the amount of tokens that an owner allowed to a spender.
212    * approve should be called when allowed[_spender] == 0. To increment
213    * allowed value is better to use this function to avoid 2 calls (and wait until
214    * the first transaction is mined)
215    * From MonolithDAO Token.sol
216    * @param _spender The address which will spend the funds.
217    * @param _addedValue The amount of tokens to increase the allowance by.
218    */
219   function increaseApproval(
220     address _spender,
221     uint256 _addedValue
222   )
223     public
224     returns (bool)
225   {
226     allowed[msg.sender][_spender] = (
227       allowed[msg.sender][_spender].add(_addedValue));
228     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
229     return true;
230   }
231 
232   /**
233    * @dev Decrease the amount of tokens that an owner allowed to a spender.
234    * approve should be called when allowed[_spender] == 0. To decrement
235    * allowed value is better to use this function to avoid 2 calls (and wait until
236    * the first transaction is mined)
237    * From MonolithDAO Token.sol
238    * @param _spender The address which will spend the funds.
239    * @param _subtractedValue The amount of tokens to decrease the allowance by.
240    */
241   function decreaseApproval(
242     address _spender,
243     uint256 _subtractedValue
244   )
245     public
246     returns (bool)
247   {
248     uint256 oldValue = allowed[msg.sender][_spender];
249     if (_subtractedValue >= oldValue) {
250       allowed[msg.sender][_spender] = 0;
251     } else {
252       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
253     }
254     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255     return true;
256   }
257 
258   /**
259    * @dev Internal function that mints an amount of the token and assigns it to
260    * an account. This encapsulates the modification of balances such that the
261    * proper events are emitted.
262    * @param _account The account that will receive the created tokens.
263    * @param _amount The amount that will be created.
264    */
265   function _mint(address _account, uint256 _amount) internal {
266     require(_account != 0);
267     totalSupply_ = totalSupply_.add(_amount);
268     balances[_account] = balances[_account].add(_amount);
269     emit Transfer(address(0), _account, _amount);
270   }
271 
272   /**
273    * @dev Internal function that burns an amount of the token of a given
274    * account.
275    * @param _account The account whose tokens will be burnt.
276    * @param _amount The amount that will be burnt.
277    */
278   function _burn(address _account, uint256 _amount) internal {
279     require(_account != 0);
280     require(balances[_account] > _amount);
281 
282     totalSupply_ = totalSupply_.sub(_amount);
283     balances[_account] = balances[_account].sub(_amount);
284     emit Transfer(_account, address(0), _amount);
285   }
286 
287   /**
288    * @dev Internal function that burns an amount of the token of a given
289    * account, deducting from the sender's allowance for said account. Uses the
290    * internal _burn function.
291    * @param _account The account whose tokens will be burnt.
292    * @param _amount The amount that will be burnt.
293    */
294   function _burnFrom(address _account, uint256 _amount) internal {
295     require(allowed[_account][msg.sender] > _amount);
296 
297     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
298     // this function needs to emit an event with the updated approval.
299     allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
300     _burn(_account, _amount);
301   }
302 }
303 
304 // File: contracts\token\ERC20\BurnableToken.sol
305 
306 /**
307  * @title Burnable Token
308  * @dev Token that can be irreversibly burned (destroyed).
309  */
310 contract BurnableToken is StandardToken {
311 
312   event Burn(address indexed burner, uint256 value);
313 
314   /**
315    * @dev Burns a specific amount of tokens.
316    * @param _value The amount of token to be burned.
317    */
318   function burn(uint256 _value) public {
319     _burn(msg.sender, _value);
320   }
321 
322   /**
323    * @dev Burns a specific amount of tokens from the target address and decrements allowance
324    * @param _from address The address which you want to send tokens from
325    * @param _value uint256 The amount of token to be burned
326    */
327   function burnFrom(address _from, uint256 _value) public {
328     _burnFrom(_from, _value);
329   }
330 
331   /**
332    * @dev Overrides StandardToken._burn in order for burn and burnFrom to emit
333    * an additional Burn event.
334    */
335   function _burn(address _who, uint256 _value) internal {
336     super._burn(_who, _value);
337     emit Burn(_who, _value);
338   }
339 }
340 
341 // File: contracts\ownership\Ownable.sol
342 
343 /**
344  * @title Ownable
345  * @dev The Ownable contract has an owner address, and provides basic authorization control
346  * functions, this simplifies the implementation of "user permissions".
347  */
348 contract Ownable {
349   address public owner;
350 
351 
352   event OwnershipRenounced(address indexed previousOwner);
353   event OwnershipTransferred(
354     address indexed previousOwner,
355     address indexed newOwner
356   );
357 
358 
359   /**
360    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
361    * account.
362    */
363   constructor() public {
364     owner = msg.sender;
365   }
366 
367   /**
368    * @dev Throws if called by any account other than the owner.
369    */
370   modifier onlyOwner() {
371     require(msg.sender == owner);
372     _;
373   }
374 
375   /**
376    * @dev Allows the current owner to relinquish control of the contract.
377    * @notice Renouncing to ownership will leave the contract without an owner.
378    * It will not be possible to call the functions with the `onlyOwner`
379    * modifier anymore.
380    */
381   function renounceOwnership() public onlyOwner {
382     emit OwnershipRenounced(owner);
383     owner = address(0);
384   }
385 
386   /**
387    * @dev Allows the current owner to transfer control of the contract to a newOwner.
388    * @param _newOwner The address to transfer ownership to.
389    */
390   function transferOwnership(address _newOwner) public onlyOwner {
391     _transferOwnership(_newOwner);
392   }
393 
394   /**
395    * @dev Transfers control of the contract to a newOwner.
396    * @param _newOwner The address to transfer ownership to.
397    */
398   function _transferOwnership(address _newOwner) internal {
399     require(_newOwner != address(0));
400     emit OwnershipTransferred(owner, _newOwner);
401     owner = _newOwner;
402   }
403 }
404 
405 // File: contracts\lifecycle\Pausable.sol
406 
407 /**
408  * @title Pausable
409  * @dev Base contract which allows children to implement an emergency stop mechanism.
410  */
411 contract Pausable is Ownable {
412   event Pause();
413   event Unpause();
414 
415   bool public paused = false;
416 
417 
418   /**
419    * @dev Modifier to make a function callable only when the contract is not paused.
420    */
421   modifier whenNotPaused() {
422     require(!paused);
423     _;
424   }
425 
426   /**
427    * @dev Modifier to make a function callable only when the contract is paused.
428    */
429   modifier whenPaused() {
430     require(paused);
431     _;
432   }
433 
434   /**
435    * @dev called by the owner to pause, triggers stopped state
436    */
437   function pause() public onlyOwner whenNotPaused {
438     paused = true;
439     emit Pause();
440   }
441 
442   /**
443    * @dev called by the owner to unpause, returns to normal state
444    */
445   function unpause() public onlyOwner whenPaused {
446     paused = false;
447     emit Unpause();
448   }
449 }
450 
451 // File: contracts\token\ERC20\PausableToken.sol
452 
453 /**
454  * @title Pausable token
455  * @dev StandardToken modified with pausable transfers.
456  **/
457 contract PausableToken is BurnableToken, Pausable {
458 
459   function transfer(
460     address _to,
461     uint256 _value
462   )
463     public
464     whenNotPaused
465     returns (bool)
466   {
467     return super.transfer(_to, _value);
468   }
469 
470   function transferFrom(
471     address _from,
472     address _to,
473     uint256 _value
474   )
475     public
476     whenNotPaused
477     returns (bool)
478   {
479     return super.transferFrom(_from, _to, _value);
480   }
481 
482   function approve(
483     address _spender,
484     uint256 _value
485   )
486     public
487     whenNotPaused
488     returns (bool)
489   {
490     return super.approve(_spender, _value);
491   }
492 
493   function increaseApproval(
494     address _spender,
495     uint _addedValue
496   )
497     public
498     whenNotPaused
499     returns (bool success)
500   {
501     return super.increaseApproval(_spender, _addedValue);
502   }
503 
504   function decreaseApproval(
505     address _spender,
506     uint _subtractedValue
507   )
508     public
509     whenNotPaused
510     returns (bool success)
511   {
512     return super.decreaseApproval(_spender, _subtractedValue);
513   }
514 }
515 /**
516  * @title KWATT_Token Token
517  * @dev Token that can be irreversibly burned (destroyed).
518  */
519 contract KWATT_Token is PausableToken {
520     string public name = "4NEW";
521     string public symbol = "KWATT";
522     uint8 public decimals = 18;
523     uint public INITIAL_SUPPLY = 300000000000000000000000000;
524 constructor() public {
525   totalSupply_ = INITIAL_SUPPLY;
526   balances[msg.sender] = totalSupply_;
527 }
528 
529 }