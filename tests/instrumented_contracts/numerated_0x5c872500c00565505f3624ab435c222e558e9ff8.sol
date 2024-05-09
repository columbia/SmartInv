1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * See https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address _who) public view returns (uint256);
12   function transfer(address _to, uint256 _value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipRenounced(address indexed previousOwner);
28   event OwnershipTransferred(
29     address indexed previousOwner,
30     address indexed newOwner
31   );
32 
33 
34   /**
35    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36    * account.
37    */
38   constructor() public {
39     owner = msg.sender;
40   }
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50   /**
51    * @dev Allows the current owner to relinquish control of the contract.
52    * @notice Renouncing to ownership will leave the contract without an owner.
53    * It will not be possible to call the functions with the `onlyOwner`
54    * modifier anymore.
55    */
56   function renounceOwnership() public onlyOwner {
57     emit OwnershipRenounced(owner);
58     owner = address(0);
59   }
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param _newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address _newOwner) public onlyOwner {
66     _transferOwnership(_newOwner);
67   }
68 
69   /**
70    * @dev Transfers control of the contract to a newOwner.
71    * @param _newOwner The address to transfer ownership to.
72    */
73   function _transferOwnership(address _newOwner) internal {
74     require(_newOwner != address(0));
75     emit OwnershipTransferred(owner, _newOwner);
76     owner = _newOwner;
77   }
78 }
79 
80 
81 
82 
83 
84 /**
85  * @title ERC20 interface
86  * @dev see https://github.com/ethereum/EIPs/issues/20
87  */
88 contract ERC20 is ERC20Basic {
89   function allowance(address _owner, address _spender)
90     public view returns (uint256);
91 
92   function transferFrom(address _from, address _to, uint256 _value)
93     public returns (bool);
94 
95   function approve(address _spender, uint256 _value) public returns (bool);
96   event Approval(
97     address indexed owner,
98     address indexed spender,
99     uint256 value
100   );
101 }
102 
103 
104 
105 
106 
107 
108 
109 
110 
111 /**
112  * @title SafeMath
113  * @dev Math operations with safety checks that throw on error
114  */
115 library SafeMath {
116 
117   /**
118   * @dev Multiplies two numbers, throws on overflow.
119   */
120   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
121     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
122     // benefit is lost if 'b' is also tested.
123     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
124     if (_a == 0) {
125       return 0;
126     }
127 
128     c = _a * _b;
129     assert(c / _a == _b);
130     return c;
131   }
132 
133   /**
134   * @dev Integer division of two numbers, truncating the quotient.
135   */
136   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
137     // assert(_b > 0); // Solidity automatically throws when dividing by 0
138     // uint256 c = _a / _b;
139     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
140     return _a / _b;
141   }
142 
143   /**
144   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
145   */
146   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
147     assert(_b <= _a);
148     return _a - _b;
149   }
150 
151   /**
152   * @dev Adds two numbers, throws on overflow.
153   */
154   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
155     c = _a + _b;
156     assert(c >= _a);
157     return c;
158   }
159 }
160 
161 
162 
163 /**
164  * @title Basic token
165  * @dev Basic version of StandardToken, with no allowances.
166  */
167 contract BasicToken is ERC20Basic {
168   using SafeMath for uint256;
169 
170   mapping(address => uint256) internal balances;
171 
172   uint256 internal totalSupply_;
173 
174   /**
175   * @dev Total number of tokens in existence
176   */
177   function totalSupply() public view returns (uint256) {
178     return totalSupply_;
179   }
180 
181   /**
182   * @dev Transfer token for a specified address
183   * @param _to The address to transfer to.
184   * @param _value The amount to be transferred.
185   */
186   function transfer(address _to, uint256 _value) public returns (bool) {
187     require(_value <= balances[msg.sender]);
188     require(_to != address(0));
189 
190     balances[msg.sender] = balances[msg.sender].sub(_value);
191     balances[_to] = balances[_to].add(_value);
192     emit Transfer(msg.sender, _to, _value);
193     return true;
194   }
195 
196   /**
197   * @dev Gets the balance of the specified address.
198   * @param _owner The address to query the the balance of.
199   * @return An uint256 representing the amount owned by the passed address.
200   */
201   function balanceOf(address _owner) public view returns (uint256) {
202     return balances[_owner];
203   }
204 
205 }
206 
207 
208 
209 
210 /**
211  * @title Standard ERC20 token
212  *
213  * @dev Implementation of the basic standard token.
214  * https://github.com/ethereum/EIPs/issues/20
215  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
216  */
217 contract StandardToken is ERC20, BasicToken {
218 
219   mapping (address => mapping (address => uint256)) internal allowed;
220 
221 
222   /**
223    * @dev Transfer tokens from one address to another
224    * @param _from address The address which you want to send tokens from
225    * @param _to address The address which you want to transfer to
226    * @param _value uint256 the amount of tokens to be transferred
227    */
228   function transferFrom(
229     address _from,
230     address _to,
231     uint256 _value
232   )
233     public
234     returns (bool)
235   {
236     require(_value <= balances[_from]);
237     require(_value <= allowed[_from][msg.sender]);
238     require(_to != address(0));
239 
240     balances[_from] = balances[_from].sub(_value);
241     balances[_to] = balances[_to].add(_value);
242     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
243     emit Transfer(_from, _to, _value);
244     return true;
245   }
246 
247   /**
248    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
249    * Beware that changing an allowance with this method brings the risk that someone may use both the old
250    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
251    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
252    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
253    * @param _spender The address which will spend the funds.
254    * @param _value The amount of tokens to be spent.
255    */
256   function approve(address _spender, uint256 _value) public returns (bool) {
257     allowed[msg.sender][_spender] = _value;
258     emit Approval(msg.sender, _spender, _value);
259     return true;
260   }
261 
262   /**
263    * @dev Function to check the amount of tokens that an owner allowed to a spender.
264    * @param _owner address The address which owns the funds.
265    * @param _spender address The address which will spend the funds.
266    * @return A uint256 specifying the amount of tokens still available for the spender.
267    */
268   function allowance(
269     address _owner,
270     address _spender
271    )
272     public
273     view
274     returns (uint256)
275   {
276     return allowed[_owner][_spender];
277   }
278 
279   /**
280    * @dev Increase the amount of tokens that an owner allowed to a spender.
281    * approve should be called when allowed[_spender] == 0. To increment
282    * allowed value is better to use this function to avoid 2 calls (and wait until
283    * the first transaction is mined)
284    * From MonolithDAO Token.sol
285    * @param _spender The address which will spend the funds.
286    * @param _addedValue The amount of tokens to increase the allowance by.
287    */
288   function increaseApproval(
289     address _spender,
290     uint256 _addedValue
291   )
292     public
293     returns (bool)
294   {
295     allowed[msg.sender][_spender] = (
296       allowed[msg.sender][_spender].add(_addedValue));
297     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
298     return true;
299   }
300 
301   /**
302    * @dev Decrease the amount of tokens that an owner allowed to a spender.
303    * approve should be called when allowed[_spender] == 0. To decrement
304    * allowed value is better to use this function to avoid 2 calls (and wait until
305    * the first transaction is mined)
306    * From MonolithDAO Token.sol
307    * @param _spender The address which will spend the funds.
308    * @param _subtractedValue The amount of tokens to decrease the allowance by.
309    */
310   function decreaseApproval(
311     address _spender,
312     uint256 _subtractedValue
313   )
314     public
315     returns (bool)
316   {
317     uint256 oldValue = allowed[msg.sender][_spender];
318     if (_subtractedValue >= oldValue) {
319       allowed[msg.sender][_spender] = 0;
320     } else {
321       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
322     }
323     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
324     return true;
325   }
326 
327 }
328 
329 
330 
331 
332 
333 
334 
335 /**
336  * @title DetailedERC20 token
337  * @dev The decimals are only for visualization purposes.
338  * All the operations are done using the smallest and indivisible token unit,
339  * just as on Ethereum all the operations are done in wei.
340  */
341 contract DetailedERC20 is ERC20 {
342   string public name;
343   string public symbol;
344   uint8 public decimals;
345 
346   constructor(string _name, string _symbol, uint8 _decimals) public {
347     name = _name;
348     symbol = _symbol;
349     decimals = _decimals;
350   }
351 }
352 
353 
354 
355 
356 
357 
358 
359 /**
360  * @title Mintable token
361  * @dev Simple ERC20 Token example, with mintable token creation
362  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
363  */
364 contract MintableToken is StandardToken, Ownable {
365   event Mint(address indexed to, uint256 amount);
366   event MintFinished();
367 
368   bool public mintingFinished = false;
369 
370 
371   modifier canMint() {
372     require(!mintingFinished);
373     _;
374   }
375 
376   modifier hasMintPermission() {
377     require(msg.sender == owner);
378     _;
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
391     public
392     hasMintPermission
393     canMint
394     returns (bool)
395   {
396     totalSupply_ = totalSupply_.add(_amount);
397     balances[_to] = balances[_to].add(_amount);
398     emit Mint(_to, _amount);
399     emit Transfer(address(0), _to, _amount);
400     return true;
401   }
402 
403   /**
404    * @dev Function to stop minting new tokens.
405    * @return True if the operation was successful.
406    */
407   function finishMinting() public onlyOwner canMint returns (bool) {
408     mintingFinished = true;
409     emit MintFinished();
410     return true;
411   }
412 }
413 
414 
415 
416 
417 
418 
419 
420 
421 
422 
423 /**
424  * @title Pausable
425  * @dev Base contract which allows children to implement an emergency stop mechanism.
426  */
427 contract Pausable is Ownable {
428   event Pause();
429   event Unpause();
430 
431   bool public paused = false;
432 
433 
434   /**
435    * @dev Modifier to make a function callable only when the contract is not paused.
436    */
437   modifier whenNotPaused() {
438     require(!paused);
439     _;
440   }
441 
442   /**
443    * @dev Modifier to make a function callable only when the contract is paused.
444    */
445   modifier whenPaused() {
446     require(paused);
447     _;
448   }
449 
450   /**
451    * @dev called by the owner to pause, triggers stopped state
452    */
453   function pause() public onlyOwner whenNotPaused {
454     paused = true;
455     emit Pause();
456   }
457 
458   /**
459    * @dev called by the owner to unpause, returns to normal state
460    */
461   function unpause() public onlyOwner whenPaused {
462     paused = false;
463     emit Unpause();
464   }
465 }
466 
467 
468 
469 /**
470  * @title Pausable token
471  * @dev StandardToken modified with pausable transfers.
472  **/
473 contract PausableToken is StandardToken, Pausable {
474 
475   function transfer(
476     address _to,
477     uint256 _value
478   )
479     public
480     whenNotPaused
481     returns (bool)
482   {
483     return super.transfer(_to, _value);
484   }
485 
486   function transferFrom(
487     address _from,
488     address _to,
489     uint256 _value
490   )
491     public
492     whenNotPaused
493     returns (bool)
494   {
495     return super.transferFrom(_from, _to, _value);
496   }
497 
498   function approve(
499     address _spender,
500     uint256 _value
501   )
502     public
503     whenNotPaused
504     returns (bool)
505   {
506     return super.approve(_spender, _value);
507   }
508 
509   function increaseApproval(
510     address _spender,
511     uint _addedValue
512   )
513     public
514     whenNotPaused
515     returns (bool success)
516   {
517     return super.increaseApproval(_spender, _addedValue);
518   }
519 
520   function decreaseApproval(
521     address _spender,
522     uint _subtractedValue
523   )
524     public
525     whenNotPaused
526     returns (bool success)
527   {
528     return super.decreaseApproval(_spender, _subtractedValue);
529   }
530 }
531 
532 
533 contract COT is MintableToken, PausableToken, DetailedERC20 {
534 
535     constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSuply)
536         DetailedERC20(_name, _symbol, _decimals)
537         public
538     {
539         // Initialize totalSupply
540         totalSupply_ = _totalSuply;
541         // Initialize Holder
542         balances[msg.sender] = _totalSuply;
543     }
544 }