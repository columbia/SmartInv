1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25     if (a == 0) {
26       return 0;
27     }
28     uint256 c = a * b;
29     assert(c / a == b);
30     return c;
31   }
32 
33   /**
34   * @dev Integer division of two numbers, truncating the quotient.
35   */
36   function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return c;
41   }
42 
43   /**
44   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45   */
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   /**
52   * @dev Adds two numbers, throws on overflow.
53   */
54   function add(uint256 a, uint256 b) internal pure returns (uint256) {
55     uint256 c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 /**
62  * @title Basic token
63  * @dev Basic version of StandardToken, with no allowances.
64  */
65 contract BasicToken is ERC20Basic {
66   using SafeMath for uint256;
67 
68   mapping(address => uint256) balances;
69 
70   uint256 totalSupply_;
71 
72   /**
73   * @dev total number of tokens in existence
74   */
75   function totalSupply() public view returns (uint256) {
76     return totalSupply_;
77   }
78 
79   /**
80   * @dev transfer token for a specified address
81   * @param _to The address to transfer to.
82   * @param _value The amount to be transferred.
83   */
84   function transfer(address _to, uint256 _value) public returns (bool) {
85     require(_to != address(0));
86     require(_value <= balances[msg.sender]);
87 
88     // SafeMath.sub will throw if there is not enough balance.
89     balances[msg.sender] = balances[msg.sender].sub(_value);
90     balances[_to] = balances[_to].add(_value);
91     emit Transfer(msg.sender, _to, _value);
92     return true;
93   }
94 
95   /**
96   * @dev Gets the balance of the specified address.
97   * @param _owner The address to query the the balance of.
98   * @return An uint256 representing the amount owned by the passed address.
99   */
100   function balanceOf(address _owner) public view returns (uint256 balance) {
101     return balances[_owner];
102   }
103 }
104 
105 /**
106  * @title ERC20 interface
107  * @dev see https://github.com/ethereum/EIPs/issues/20
108  */
109 contract ERC20 is ERC20Basic {
110   function allowance(address owner, address spender) public view returns (uint256);
111   function transferFrom(address from, address to, uint256 value) public returns (bool);
112   function approve(address spender, uint256 value) public returns (bool);
113   event Approval(address indexed owner, address indexed spender, uint256 value);
114 }
115 
116 /**
117  * @title Standard ERC20 token
118  *
119  * @dev Implementation of the basic standard token.
120  * @dev https://github.com/ethereum/EIPs/issues/20
121  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
122  */
123 contract StandardToken is ERC20, BasicToken {
124 
125   mapping (address => mapping (address => uint256)) internal allowed;
126 
127   /**
128    * @dev Transfer tokens from one address to another
129    * @param _from address The address which you want to send tokens from
130    * @param _to address The address which you want to transfer to
131    * @param _value uint256 the amount of tokens to be transferred
132    */
133   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
134     require(_to != address(0));
135     require(_value <= balances[_from]);
136     require(_value <= allowed[_from][msg.sender]);
137 
138     balances[_from] = balances[_from].sub(_value);
139     balances[_to] = balances[_to].add(_value);
140     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
141     emit Transfer(_from, _to, _value);
142     return true;
143   }
144 
145   /**
146    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
147    *
148    * Beware that changing an allowance with this method brings the risk that someone may use both the old
149    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
150    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
151    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
152    * @param _spender The address which will spend the funds.
153    * @param _value The amount of tokens to be spent.
154    */
155   function approve(address _spender, uint256 _value) public returns (bool) {
156     allowed[msg.sender][_spender] = _value;
157     emit Approval(msg.sender, _spender, _value);
158     return true;
159   }
160 
161   /**
162    * @dev Function to check the amount of tokens that an owner allowed to a spender.
163    * @param _owner address The address which owns the funds.
164    * @param _spender address The address which will spend the funds.
165    * @return A uint256 specifying the amount of tokens still available for the spender.
166    */
167   function allowance(address _owner, address _spender) public view returns (uint256) {
168     return allowed[_owner][_spender];
169   }
170 
171   /**
172    * @dev Increase the amount of tokens that an owner allowed to a spender.
173    *
174    * approve should be called when allowed[_spender] == 0. To increment
175    * allowed value is better to use this function to avoid 2 calls (and wait until
176    * the first transaction is mined)
177    * From MonolithDAO Token.sol
178    * @param _spender The address which will spend the funds.
179    * @param _addedValue The amount of tokens to increase the allowance by.
180    */
181   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
182     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
183     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
184     return true;
185   }
186 
187   /**
188    * @dev Decrease the amount of tokens that an owner allowed to a spender.
189    *
190    * approve should be called when allowed[_spender] == 0. To decrement
191    * allowed value is better to use this function to avoid 2 calls (and wait until
192    * the first transaction is mined)
193    * From MonolithDAO Token.sol
194    * @param _spender The address which will spend the funds.
195    * @param _subtractedValue The amount of tokens to decrease the allowance by.
196    */
197   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
198     uint oldValue = allowed[msg.sender][_spender];
199     if (_subtractedValue > oldValue) {
200       allowed[msg.sender][_spender] = 0;
201     } else {
202       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
203     }
204     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
205     return true;
206   }
207 }
208 
209 /**
210  * @title Ownable
211  * @dev The Ownable contract has an owner address, and provides basic authorization control
212  * functions, this simplifies the implementation of "user permissions".
213  */
214 contract Ownable {
215   address public owner;
216 
217 
218   event OwnershipRenounced(address indexed previousOwner);
219   event OwnershipTransferred(
220     address indexed previousOwner,
221     address indexed newOwner
222   );
223 
224 
225   /**
226    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
227    * account.
228    */
229   constructor() public {
230     owner = msg.sender;
231   }
232 
233   /**
234    * @dev Throws if called by any account other than the owner.
235    */
236   modifier onlyOwner() {
237     require(msg.sender == owner);
238     _;
239   }
240 
241   /**
242    * @dev Allows the current owner to transfer control of the contract to a newOwner.
243    * @param newOwner The address to transfer ownership to.
244    */
245   function transferOwnership(address newOwner) public onlyOwner {
246     require(newOwner != address(0));
247     emit OwnershipTransferred(owner, newOwner);
248     owner = newOwner;
249   }
250 
251   /**
252    * @dev Allows the current owner to relinquish control of the contract.
253    */
254   function renounceOwnership() public onlyOwner {
255     emit OwnershipRenounced(owner);
256     owner = address(0);
257   }
258 }
259 
260 
261 /**
262  * @title Burnable Token
263  * @dev Token that can be irreversibly burned (destroyed).
264  */
265 contract BurnableToken is BasicToken {
266 
267   event Burn(address indexed burner, uint256 value);
268 
269   /**
270    * @dev Burns a specific amount of tokens.
271    * @param _value The amount of token to be burned.
272    */
273   function burn(uint256 _value) public {
274     _burn(msg.sender, _value);
275   }
276 
277   function _burn(address _who, uint256 _value) internal {
278     require(_value <= balances[_who]);
279     // no need to require value <= totalSupply, since that would imply the
280     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
281 
282     balances[_who] = balances[_who].sub(_value);
283     totalSupply_ = totalSupply_.sub(_value);
284     emit Burn(_who, _value);
285     emit Transfer(_who, address(0), _value);
286   }
287 }
288 
289 
290 /**
291  * @title Standard Burnable Token
292  * @dev Adds burnFrom method to ERC20 implementations
293  */
294 contract StandardBurnableToken is BurnableToken, StandardToken {
295 
296   /**
297    * @dev Burns a specific amount of tokens from the target address and decrements allowance
298    * @param _from address The address which you want to send tokens from
299    * @param _value uint256 The amount of token to be burned
300    */
301   function burnFrom(address _from, uint256 _value) public {
302     require(_value <= allowed[_from][msg.sender]);
303     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
304     // this function needs to emit an event with the updated approval.
305     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
306     _burn(_from, _value);
307   }
308 }
309 
310 
311 /**
312  * @title Mintable token
313  * @dev Simple ERC20 Token example, with mintable token creation
314  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
315  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
316  */
317 contract MintableToken is StandardToken, Ownable {
318   event Mint(address indexed to, uint256 amount);
319   event MintFinished();
320 
321   bool public mintingFinished = false;
322 
323 
324   modifier canMint() {
325     require(!mintingFinished);
326     _;
327   }
328 
329   modifier hasMintPermission() {
330     require(msg.sender == owner);
331     _;
332   }
333 
334   /**
335    * @dev Function to mint tokens
336    * @param _to The address that will receive the minted tokens.
337    * @param _amount The amount of tokens to mint.
338    * @return A boolean that indicates if the operation was successful.
339    */
340   function mint(
341     address _to,
342     uint256 _amount
343   )
344     hasMintPermission
345     canMint
346     public
347     returns (bool)
348   {
349     totalSupply_ = totalSupply_.add(_amount);
350     balances[_to] = balances[_to].add(_amount);
351     emit Mint(_to, _amount);
352     emit Transfer(address(0), _to, _amount);
353     return true;
354   }
355 
356   /**
357    * @dev Function to stop minting new tokens.
358    * @return True if the operation was successful.
359    */
360   function finishMinting() onlyOwner canMint public returns (bool) {
361     mintingFinished = true;
362     emit MintFinished();
363     return true;
364   }
365 }
366 
367 
368 /**
369  * @title Capped token
370  * @dev Mintable token with a token cap.
371  */
372 contract CappedToken is MintableToken {
373 
374   uint256 public cap;
375 
376   constructor(uint256 _cap) public {
377     require(_cap > 0);
378     cap = _cap;
379   }
380 
381   /**
382    * @dev Function to mint tokens
383    * @param _to The address that will receive the minted tokens.
384    * @param _amount The amount of tokens to mint.
385    * @return A boolean that indicates if the operation was successful.
386    */
387   function mint(
388     address _to,
389     uint256 _amount
390   )
391     onlyOwner
392     canMint
393     public
394     returns (bool)
395   {
396     require(totalSupply_.add(_amount) <= cap);
397 
398     return super.mint(_to, _amount);
399   }
400 
401 }
402 
403 
404 /**
405  * @title Pausable
406  * @dev Base contract which allows children to implement an emergency stop mechanism.
407  */
408 contract Pausable is Ownable {
409   event Pause();
410   event Unpause();
411 
412   bool public paused = false;
413 
414 
415   /**
416    * @dev Modifier to make a function callable only when the contract is not paused.
417    */
418   modifier whenNotPaused() {
419     require(!paused);
420     _;
421   }
422 
423   /**
424    * @dev Modifier to make a function callable only when the contract is paused.
425    */
426   modifier whenPaused() {
427     require(paused);
428     _;
429   }
430 
431   /**
432    * @dev called by the owner to pause, triggers stopped state
433    */
434   function pause() onlyOwner whenNotPaused public {
435     paused = true;
436     emit Pause();
437   }
438 
439   /**
440    * @dev called by the owner to unpause, returns to normal state
441    */
442   function unpause() onlyOwner whenPaused public {
443     paused = false;
444     emit Unpause();
445   }
446 }
447 
448 
449 /**
450  * @title Pausable token
451  * @dev StandardToken modified with pausable transfers.
452  **/
453 contract PausableToken is StandardToken, Pausable {
454 
455   function transfer(
456     address _to,
457     uint256 _value
458   )
459     public
460     whenNotPaused
461     returns (bool)
462   {
463     return super.transfer(_to, _value);
464   }
465 
466   function transferFrom(
467     address _from,
468     address _to,
469     uint256 _value
470   )
471     public
472     whenNotPaused
473     returns (bool)
474   {
475     return super.transferFrom(_from, _to, _value);
476   }
477 
478   function approve(
479     address _spender,
480     uint256 _value
481   )
482     public
483     whenNotPaused
484     returns (bool)
485   {
486     return super.approve(_spender, _value);
487   }
488 
489   function increaseApproval(
490     address _spender,
491     uint _addedValue
492   )
493     public
494     whenNotPaused
495     returns (bool success)
496   {
497     return super.increaseApproval(_spender, _addedValue);
498   }
499 
500   function decreaseApproval(
501     address _spender,
502     uint _subtractedValue
503   )
504     public
505     whenNotPaused
506     returns (bool success)
507   {
508     return super.decreaseApproval(_spender, _subtractedValue);
509   }
510 }
511 
512 
513 /**
514  * @title SimpleToken
515  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
516  * Note they can later distribute these tokens as they wish using `transfer` and other
517  * `StandardToken` functions.
518  */
519 contract MyToken is StandardBurnableToken, CappedToken, PausableToken {
520 
521   string public constant name = "ORICToken"; // 
522   string public constant symbol = "ORIC"; // solium-disable-line uppercase
523   uint8 public constant decimals = 18; // solium-disable-line uppercase
524 
525   uint256 public constant INITIAL_SUPPLY = 1e9 * (10 ** uint256(decimals));
526   uint256 public constant CAPPED_SUPPLY = 1e9 * (20 ** uint256(decimals));
527 
528   /**
529    * @dev Constructor that gives msg.sender all of existing tokens.
530    */
531   constructor() CappedToken(CAPPED_SUPPLY) public {
532     totalSupply_ = INITIAL_SUPPLY;
533     balances[msg.sender] = INITIAL_SUPPLY;
534     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
535   }
536 }